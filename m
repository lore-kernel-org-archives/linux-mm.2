Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B232FCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 18:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BB0D8E0151; Thu, 30 Oct 2025 14:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B9A8E0089; Thu, 30 Oct 2025 14:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05AF98E0151; Thu, 30 Oct 2025 14:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E98B08E0089
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:00:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 934F2140232
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:00:41 +0000 (UTC)
X-FDA: 84055545882.10.6FEE934
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id E78EE180006
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 18:00:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=lP7ppbfl;
	spf=pass (imf16.hostedemail.com: domain of "prvs=391970341=kalyazin@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=391970341=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761847239;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5wlxdnDcWixx3BBmRUtZ/2zQxVYjliI5U0iUUmSWIE=;
	b=26xiD24lt6MrgRkinIypfn6b9ePpBFYNGvlFPj3ls8DNA/SJyyN5YZocR8Gn+c4FrS2FFq
	50yFBcVAZxnY6ts6dxQ1eduJK/1+zzXV3j/T24IR6n3USymrf7HqOrAv9xlOs9pp7j4BfJ
	xqHxZBbCnUNjRxj9hAaIMOpmqw6owAo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=lP7ppbfl;
	spf=pass (imf16.hostedemail.com: domain of "prvs=391970341=kalyazin@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=391970341=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761847239; a=rsa-sha256;
	cv=none;
	b=cafCz7OXAEVViPcRpm0WerWHjIGtdSf9UX9944vmAmp++ZbPrepal9OkIGqGT0WG9Rl4xT
	I1nd+zRHB5gi3YweO564dT5NIEHuLTB7wCd362bE7wOOROmm9VJ6v3uJx11AVE4w6qBJ5Y
	Py1ltjR+uso8kWYbOJYjmCZOnaIss1k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1761847239; x=1793383239;
  h=message-id:date:mime-version:reply-to:subject:to:
   references:from:in-reply-to:content-transfer-encoding;
  bh=E5wlxdnDcWixx3BBmRUtZ/2zQxVYjliI5U0iUUmSWIE=;
  b=lP7ppbfljTOhVMc0RcxKspXSy8ns67IvU9uZPk043omtUAgFYEONrpqJ
   kyOwsD4hiSbu2KlfieEW5aicK2DQyO3KX/R7M9f0kS2wA0Q6filSEG5Zn
   TofqT1lHm7KxY9dMENoWOkQEs4s2GWP1T+rIJR/e7y1WJX1kKrZ+wywdO
   TZxSWeWB3JJeDiPio7i4fMQZDpNpLxUuIelTB00EOH/CgrxJIAdhM+H0n
   P6jlBASun7ekLiP8/r7z9/ZFYQG9uR+86sem+DcY3t7avPxKNX8Fk5f0x
   +NuZsxzeC6+lNejVsaNcF2lwg8CIcC0ENzDgNZFSBqVBjPb9xIWtYo5UR
   A==;
X-CSE-ConnectionGUID: G8ewqpOrQEq2XZbS6lN9+A==
X-CSE-MsgGUID: DnvGQGwYQ6C6gQx2z9HmHw==
X-IronPort-AV: E=Sophos;i="6.19,250,1754956800"; 
   d="scan'208";a="4468863"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 18:00:28 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:12141]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.6.105:2525] with esmtp (Farcaster)
 id de7d695c-09e8-48b3-aec3-a2124ec2e8ae; Thu, 30 Oct 2025 18:00:28 +0000 (UTC)
X-Farcaster-Flow-ID: de7d695c-09e8-48b3-aec3-a2124ec2e8ae
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Thu, 30 Oct 2025 18:00:28 +0000
Received: from [192.168.10.151] (10.106.82.18) by
 EX19D022EUC002.ant.amazon.com (10.252.51.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Thu, 30 Oct 2025 18:00:27 +0000
Message-ID: <0b403696-addb-45ab-a9b5-60f231d9dc4b@amazon.com>
Date: Thu, 30 Oct 2025 18:00:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Mike Rapoport <rppt@kernel.org>, Muchun Song
	<muchun.song@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, Axel Rasmussen
	<axelrasmussen@google.com>, Andrew Morton <akpm@linux-foundation.org>, "James
 Houghton" <jthoughton@google.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Hugh Dickins <hughd@google.com>, Michal Hocko
	<mhocko@suse.com>, Ujwal Kundur <ujwal.kundur@gmail.com>, Oscar Salvador
	<osalvador@suse.de>, Suren Baghdasaryan <surenb@google.com>, Andrea Arcangeli
	<aarcange@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com> <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.18]
X-ClientProxiedBy: EX19D010EUA002.ant.amazon.com (10.252.50.108) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)
X-Rspamd-Queue-Id: E78EE180006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7iqmtpifkrt3mncubb9x44wi944seiec
X-HE-Tag: 1761847238-400464
X-HE-Meta: U2FsdGVkX1+Okaf/52hO1ZtPne/tPH+GlLljYOMSj7LXiCbJxx0quEqDFOVi6OQerKhHL8Y47xI1oa6iAd8H028xMw+m9GMEd3zr/lL1Qm/T4vXYG57FJaYEXgJm5986RdtQAt25y1oZXnx05A+/9svRjSGfXN+Zp6mz6rm7/YwC0LeKtKkcZegICefcYoP42ipkMJcvZ8WTUEPpEHxRSWiUy3t3lxS5n72WxC5EMcGkF8ZD7ywGfFRgAAJ/NtVT6C/5pwXg4/da6jBN796SyPDF3p+ZGj2bGe5eoBt0CjL09nmcBGQwFpmD4G+SwOe9+mbYAAqxnTsDT7+h2FEsqphaCA/BmkJGBT796UaaE6jdzrLTblDMIndUdPGIFxrbuOSfSLXgx5rU0ITqSMuwWMhzZoUrIZWdpSWOKCeSKGJtPa3Spq3cGFtqpl36mOZIz080jFv8RXkAOSKSJqwzJ+vhc/0QuMUMHyvKls5eHqzAIP51k53NGhu734Wj3QFt8q3Li9lqfGKnJ1U0EdpYdlSjSatfJ8yrjz52IqYyvyEqO7uvKzOARqkjlTCrRvnyjRTpnJak5yL2MZJL21VriJ/X5s68/0mvanFzJ+W4uoy/yf3hNI0KnnIEi4sxPJLIst14LNQdeIHDu6dk0i8jquuq6OmEwPPs0cIUbqNhAOofdWgel6IyplhEioARxzVB7UCsnQSQvJOOUovScVKYzs9FbJ01H7+643ESiknBD8NALPJtIi8jTn1/vVqw+WNT3muApS0FE4vZNC+ryyZjEJwf9KgVbcSdm56M9iCU3fjSBpGnkaGCgUBtrvcooJrsPbDuEV4ZrRMjDDzmEetZpFgjN9bYxQeYWtBdJyPzh6whlhooUV3SY+jKUwhWT4iJpC6wY7qEDnmpnxnsC9JsPdRisKLCuBIBTaR4zMUQKdCFEt/HwW1Rsc3nLAmk9bE02IuC2NSOPR6qt7oNBio
 tCvKS/H5
 JcXfbt/1qnSzbE08F8fRA3kpNTZrY4uHnmuCOVROOwuZTNSLqMzvIewSm4pJq84+PU3E2FxrxPLiXg2tHIiHZZTYzuZ8srTwiXp/t0UFaXO7ctQ6Iv/+hODghtuEKDN4N/BDeyg9xhb0xlgvYCAecxwjLDMLJUqfyOMXDplnUwIObEiUgkl709QXKmpM/9UfuZ8Lsvd3AXV0jZ3jQOPiFQdTCaGPeSAc1e8UKWZHTTEd72r+Uju72TRhhskH1HmBWNxYrcIQNuJ4ZiVqVEme67kY1VHszP8DIElq22g83M9UuqWqWaBxM0p8WYpcvLoudJrIBOd6ira5coSjPpjrL+TN9BAtFwKISRECZLYxDuQOdijJowlwepfcJ5ZlKyYAkCxuGlss/6QwbdX3o+P+jGg4P8HnWBIQ6jqurYmI/XovoBJ43rXInWAz5KfgiVKIihqSzgr+hH0gRUlYj45Z2iMGbgWr8EilKQzD19iUBYkIcGQtCWUwS/HlTNonULJSGqIiAucvbOfew8QlETjWv4AxST2jzSvMaewT5PKjRlee0+NlV+DOzf+qNE1w9lTvOSRRWFE0hdy3/rE8kGI6rDhWeAXk+E6RpJQrHgsZBzuwnXJCkq94fks8G2YOAwnzvFryWM6Ix08BXDysVm7pjktoht2jY4xacwj7iq70QXawA/MyWQ0WYNKzzVZapfyAa1zVYJgQKeHdiXBb7RT4g8AfAfndHJr7Q9z+b4HiB8Psj3CBcZGDYMxgIkK5xz/62xGKcgtZ8O5GJrTvf68LSyPLpqnZtgmaB3KfOVWxcx2RA7YwDcJ1dbD9sXACijEyK7VaaUpKfHalphYhhDAhFdm+NGgBWApuW/A3sfOa1gtE/uxIieGTCq2QxYyiaY1uwRsgUqumnYLlAjvkCxNJMwzAO9f4FFxDy4lVM1urB22Ygbp6DZXqLL+AKfodLYsMTSOJ0/GYuZoEh0mFs//apYBneUCDc
 qHpWE20B
 cP4IN1lhzKyg5vUQrEe1Pss74riW3WMWiaiW1Eaisou0ZWnya5sfn4O8r0F9e/+Odrf6Cme2rHM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 30/10/2025 17:13, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [251021 12:28]:
> 
> ...
> 
>> Can you send some patches and show us the code, help everyone to support
>> guest-memfd minor fault, please?
> 
> Patches are here:
> 
> https://git.infradead.org/?p=users/jedix/linux-maple.git;a=shortlog;h=refs/heads/modularized_mem
> 
> This is actually modularized memory types.  That means there is no
> hugetlb.h or shmem.h included in mm/userfaultfd.c code.
> 
> uffd_flag_t has been removed.  This was turning into a middleware and
> it is not necessary.  Neither is supported_ioctls.
> 
> hugetlb now uses the same functions as every other memory type,
> including anon memory.
> 
> Any memory type can change functionality without adding instructions or
> flags or anything to some other code.
> 
> This code passes uffd-unit-test and uffd-wp-mremap (skipped the swap
> tests).
> 
> guest-memfd can implement whatever it needs to (or use others
> implementations), like shmem_uffd_ops here:
> 
> static const struct vm_uffd_ops shmem_uffd_ops = {
>          .copy                   =       shmem_mfill_atomic_pte_copy,
>          .zeropage               =       shmem_mfill_atomic_pte_zeropage,
>          .cont                   =       shmem_mfill_atomic_pte_continue,
>          .poison                 =       mfill_atomic_pte_poison,
>          .writeprotect           =       uffd_writeprotect,
>          .is_dst_valid           =       shmem_is_dst_valid,
>          .increment              =       mfill_size,
>          .failed_do_unlock       =       uffd_failed_do_unlock,
>          .page_shift             =       uffd_page_shift,
>          .complete_register      =       uffd_complete_register,
> };
> 
> Where guest-memfd needs to write the one function:
> guest_memfd_pte_continue(), from what I understand.
> 
> Obviously some of the shmem_ functions would need to be added to a
> header, or such.
> 
> And most of that can come from shmem_mfill_atomic_pte_continue(), from
> what I understand.  This is about 40 lines of code, but may require
> exposing some shmem functions to keep the code that compact.
> 
> So we don't need to expose getting a folio to a module, or decode any
> special flags or whatever.  We just call the function that needs to be
> called on the vma that is found.
> 
> If anyone has tests I can use for guest-memfd and instructions on
> guest-memfd setup, I'll just write it instead of expanding the
> userfaultfd middleware.

I used to use [1] as a test.  The test function can be called from inside

         if (flags & GUEST_MEMFD_FLAG_MMAP) {
                 test_mmap_supported(fd, page_size, total_size);
                 test_fault_overflow(fd, page_size, total_size);
         } else {

in your tree (tools/testing/selftests/kvm/guest_memfd_test.c).

CONFIG_KVM_GUEST_MEMFD=y should be sufficient to enable guest_memfd support.

[1] https://lore.kernel.org/kvm/20250404154352.23078-7-kalyazin@amazon.com/

> 
> Thanks,
> Liam
> 


