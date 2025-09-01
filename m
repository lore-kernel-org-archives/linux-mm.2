Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B940CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613B48E000F; Mon,  1 Sep 2025 12:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9D38E0002; Mon,  1 Sep 2025 12:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500028E000F; Mon,  1 Sep 2025 12:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39BC48E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:01:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D54F11DEFA8
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:01:26 +0000 (UTC)
X-FDA: 83841146172.22.2426CBE
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6CA9E180014
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:01:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Gs5olRz7;
	spf=pass (imf24.hostedemail.com: domain of "prvs=3326506f4=kalyazin@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=3326506f4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756742484;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ugf5wbQoino9kd5WGia2njnF7u5jzbHGtiRFQNnGI2w=;
	b=dB5J2lOGaDiBO9nmTgXh1MKOF5goiwSUMrQEzZfZ053/XaPqw24jYU/MaWy65UzaYxuayp
	2O2pCwWKYB6dg8ETevb15dfkKrET1vkYEEzM920apWp5x7d2NoENunD70uxg3nhFVQM1s/
	VSc416N4/1pZfPMSC942+LxzUHvDN78=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Gs5olRz7;
	spf=pass (imf24.hostedemail.com: domain of "prvs=3326506f4=kalyazin@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=3326506f4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756742484; a=rsa-sha256;
	cv=none;
	b=qjPhk1BV5EatqpRva/6mm5LClWSQgilt9lUJbjklM4bOMxdyFqul0arjyuS96an0elS+iM
	iak5KRYx68yjq9bGsoeqv217uq5pMETA/e3DDhTuILtzvwwKKBEkK+GTYdFNhVQq3Ft9NT
	PNbuV9R33LujLqq1kLj1GpBwCJHuBXg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1756742484; x=1788278484;
  h=message-id:date:mime-version:reply-to:subject:to:
   references:cc:from:in-reply-to:content-transfer-encoding;
  bh=Ugf5wbQoino9kd5WGia2njnF7u5jzbHGtiRFQNnGI2w=;
  b=Gs5olRz71+W8iiKoPivgHmrsix50JyPaQ+dpkJXgr58JC8+TzE4unyAU
   /uQXIBUwV9+XWD1O76h9m0rENGKtw0lohUHXyKt2Tk05cfEN7gPUbh6Ld
   OBQroP+QpSiIueY+PjqeZ70RAjqb1o5NY6JFp06H98/XhUAeL+tDxDlms
   7v8Krg5KJbkALjxqpV8so+4GjysmyNM4Du7T10BNmF0jxSbs7sXkUvVdy
   VD4BddUJjAPs4GLhgL5fqmCSx8/ZzBndnObzMWDHpRidVM4wKlQzxBG5V
   LwZIJsJGSoVZYb8EfSn6Bta1GNaZjv92t5pgo7XEg3o9wajPW/KZujB4Y
   w==;
X-CSE-ConnectionGUID: 9LVqG8tjSEKtk1Qh9q0TRw==
X-CSE-MsgGUID: XKHXqxXWSOmCzrBmo+hmAA==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1471829"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 16:01:14 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:5544]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.16.219:2525] with esmtp (Farcaster)
 id 109efc9c-73ad-4e6b-a56d-0ea4b4eebe0d; Mon, 1 Sep 2025 16:01:14 +0000 (UTC)
X-Farcaster-Flow-ID: 109efc9c-73ad-4e6b-a56d-0ea4b4eebe0d
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Mon, 1 Sep 2025 16:01:14 +0000
Received: from [192.168.30.195] (10.106.83.14) by
 EX19D022EUC002.ant.amazon.com (10.252.51.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 1 Sep 2025 16:01:13 +0000
Message-ID: <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
Date: Mon, 1 Sep 2025 17:01:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>
References: <20250627154655.2085903-2-peterx@redhat.com>
 <aaaca9d4-b8df-45b8-a3a4-a431c99f26c7@lucifer.local>
 <CAJuCfpHN6vpDx+UNPEzJgZ_qD9USTJZ_+yZzQg2BpF_aRpufYw@mail.gmail.com>
 <982f4f94-f0bf-45dd-9003-081b76e57027@lucifer.local>
 <cda7c46b-c474-48f4-b703-e2f988470f3b@amazon.com>
 <aGVu1Isy-R9RszxW@kernel.org> <aGWMsfbayEco0j4R@x1.local>
 <aGbCbW7hUf3a2do2@kernel.org>
 <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com> <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
Content-Language: en-US
CC: Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Vlastimil Babka
	<vbabka@suse.cz>, Muchun Song <muchun.song@linux.dev>, Hugh Dickins
	<hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, James Houghton
	<jthoughton@google.com>, Michal Hocko <mhocko@suse.com>, Andrea Arcangeli
	<aarcange@redhat.com>, Oscar Salvador <osalvador@suse.de>, Axel Rasmussen
	<axelrasmussen@google.com>, Ujwal Kundur <ujwal.kundur@gmail.com>
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
In-Reply-To: <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.14]
X-ClientProxiedBy: EX19D006EUA004.ant.amazon.com (10.252.50.166) To
 EX19D022EUC002.ant.amazon.com (10.252.51.137)
X-Stat-Signature: pp8useupqom8zfsao1ztk5guu6w1rf1k
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CA9E180014
X-Rspamd-Server: rspam05
X-HE-Tag: 1756742484-390330
X-HE-Meta: U2FsdGVkX1/o7xC/dvRPhdKymz/NXdXO41CfE18wrANsSa/LMcMpAGH7aF8p6iCGxd/8Mho4GmZxH3XE1no4jel8O0GXYjK2GwJL6PlIwZbmp44i9kO1f7phQpQihm6+RfFb8wOT+mblKSI4WJ6TxnnXnYVzjZy6O7Ulak2cPfhqnqo1Muh7mGSHT7BDDGxg432FwfouaWcPs+VkCIPiTg+elE431mjrC6te2TdkvS4H+CEBfbhjQvSZOCRxGDgNG4EKD+h3sD8cqVyudcpD4xG9568LvxMOIUocTCOjK4pD2fVoUwHX+/scoQgIIQYU1RV89KPXbWFVpf0KX/vEPtqr9Wket4hOTSTc92eXpvr6tCa93o5+HlJnSMi+KAkQz0BmpC0zgTPdEvsa6CBRSr2ZjSxfl19KCbDtFRahmgtIUAiQv5SHDNAjGAutNAEuuZ47hgtc4cW24kSG80IxEjo1yMDV2RzgUKdANknjwPeqsiRNR5ZGuT/du2L094WmDraXkXOIVKWXvUkTdnZxy3hFDwIvv0FMQcdc1z/iZpMS5v7xq+iZsCcCwW8gZyop8z40xAqWsAQBTOLZZrHMO0aselEepw+Bw6Nc1btsGxzSfjb02cv+hKA/hVfA76TrvL78wGu/lBpbl9xhoVqV6oiWJWF+ZTmVOrkFMTuUMaVIOlEOvRNrQph1HcD7eVP79dNCUsBaGUkO5vvIz5itktyVZvsltzFLajeShX94ItdOiMjuHhfIF08HbrLnzcZYgnX9mYD3qdXkQwxl9q+zuy5TnTvehUycm8ZouJoz6emjMDgVDLOWJmTd9h7OP2b+deethvRbuC+0lo4KgF57OooOX9z15XFxDprSq84xkoo+3ygXkAfHKfnKzUwX8HGGpzcXB1yNZRiTXl8KSjopSG2UMb6/NZoKtzt5YGAbQ3wBdPSYz742Osm0IIuOHNKAknSGm8yVstNWYeO9JWH
 Rnzjl14Q
 4P7OUip2rWZPWUL3NDVkEkcrxYkirF4g7EpyLdx8Zo+erHhxCQFMMiTOpUyEarE6mEjwmO+Gw89tv3gZO5IgizackjxJk8V8BRyBdrZHM/G+86vwelsKLkKYkjXra0XyIj+2iqf5qok6tsZskNSWMsMNIFC++FOGWw0mRdEUr8hYNAt5y/qAmfiYWuZTQ2YM1mQxh0YXZGjTL+YElK7nChEZOdDbqos6cA7sVfcLe+w/fMw6kk1bJ9hkzyaIxq96hNJZbGVFH48pvI0C3Js9NikSALzUlYRzDYxYcZ4htUrU6Bb9yiv4geGzljaau4awldOUeApC6tWXQb2dfAmIenfG9GeYK45h7Fv4GOePZuLxU+N146oXH8yRsKkY2sI4Zr+u/toAeF8m112naXi/l+gyawUqbtF5qeQQsDPnlFFWfEfkFfg5vf8TiFk6DWTuTU7k3dGf1JRgHQvPE2S/RHcO4cA/7wa6ovGl74XI1prAK9fEn7hSZKCo1/v0dY/MejdBFwxdgY5yMg2Stxh8sG9T6MMOAZ+Z6AWUNdVS+/w62TJRpxV6fErsFIgD1UokmOyHjwrs1QDMKojSDFW7iRLM/nYm/1ZJNc7FjWIdM7ySZg1VDtv1NgRPEKmhE3QOcypMJV5Pae2gdtzNlbnP+FJZGdpJQqxZW6T9+FDPVX2yE56+mN8CEN2alaNu6XGXs0btJbBtLzQDXX8O6GjmaZ78O/+u7HY5nZT+Cfg7A8xdx63+HMRO3FxTSslQUVH+TDU5WZJgrl/BS3ujcKOqP9Bf6mnYFcMjm2Iqu99fW9/daAN27wiQDZuHItDgJlKyeHnr9eYGjcu6ne8Kn/hYdM/qiKOVDQ+FcIIPUPY5ihTVxtEbCzjeTvTy52sKCcXTC6Xxwniub4TC1B/3+BqTZ2KVohpQWSx9+mdMRrVs7lZBQZdhr7mGH3r5N7MZ9dc3FH+QlL1/EGLJxewSw86nITbqnTarN
 QRsYUw7N
 5oSdFk7vGIgphhqshrUToeCwQ07u6SzBPGeLD2Hc8RxLUdOb96KyRAe9Fn+CSvK3Jvzsvgk+PNuNlQGVKaQdVF/b+J7nKRbjKk7qWlPj5lvS/MGznrQU763JiFaDq7Iq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/07/2025 20:39, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [250704 11:00]:
>> On Fri, Jul 04, 2025 at 11:34:15AM +0200, David Hildenbrand wrote:
>>> On 03.07.25 19:48, Mike Rapoport wrote:
>>>> On Wed, Jul 02, 2025 at 03:46:57PM -0400, Peter Xu wrote:
>>>>> On Wed, Jul 02, 2025 at 08:39:32PM +0300, Mike Rapoport wrote:
>>>>>
>>>>> [...]
>>>>>
>>>>>>> The main target of this change is the implementation of UFFD for
>>>>>>> KVM/guest_memfd (examples: [1], [2]) to avoid bringing KVM-specific code
>>>>>>> into the mm codebase.  We usually mean KVM by the "drivers" in this context,
>>>>>>> and it is already somewhat "knowledgeable" of the mm.  I don't think there
>>>>>>> are existing use cases for other drivers to implement this at the moment.
>>>>>>>
>>>>>>> Although I can't see new exports in this series, there is now a way to limit
>>>>>>> exports to particular modules [3].  Would it help if we only do it for KVM
>>>>>>> initially (if/when actually needed)?
>>>>>>
>>>>>> There were talks about pulling out guest_memfd core into mm, but I don't
>>>>>> remember patches about it. If parts of guest_memfd were already in mm/ that
>>>>>> would make easier to export uffd ops to it.
>>>>>
>>>>> Do we have a link to such discussion?  I'm also curious whether that idea
>>>>> was acknowledged by KVM maintainers.
>>>>
>>>> AFAIR it was discussed at one of David's guest_memfd calls
>>>
>>> While it was discussed in the call a couple of times in different context
>>> (guest_memfd as a library / guest_memfd shim), I think we already discussed
>>> it back at LPC last year.
>>>
>>> One of the main reasons for doing that is supporting guest_memfd in other
>>> hypervisors -- the gunyah hypervisor in the kernel wants to make use of it
>>> as well.
>>
>> I see, thanks for the info. I found the series, it's here:
>>
>> https://lore.kernel.org/all/20241113-guestmem-library-v3-0-71fdee85676b@quicinc.com/
>>
>> Here, the question is whether do we still want to keep explicit calls to
>> shmem, hugetlbfs and in the future, guest-memfd.  The library-ize of
>> guest-memfd doesn't change a huge lot on answering this question, IIUC.
> 
> Can you explore moving hugetlb_mfill_atomic_pte and
> shmem_mfill_atomic_pte into mm/userfaultfd.c and generalizing them to
> use the same code?
> 
> That is, split the similar blocks into functions and reduce duplication.
> 
> These are under the UFFD config option and are pretty similar.  This
> will also limit the bleeding of mfill_atomic_mode out of uffd.
> 
> 
> 
> If you look at what the code does in userfaultfd.c, you can see that
> some refactoring is necessary for other reasons:
> 
> mfill_atomic() calls mfill_atomic_hugetlb(), or it enters a while
> (src_addr < src_start + len) to call mfill_atomic_pte().. which might
> call shmem_mfill_atomic_pte() in mm/shmem.c
> 
> mfill_atomic_hugetlb() calls, in a while (src_addr < src_start + len)
> loop and calls hugetlb_mfill_atomic_pte() in mm/hugetlb.c
> 
> The shmem call already depends on the vma flags.. which it still does in
> your patch 4 here.  So you've replaced this:
> 
> if (!(dst_vma->vm_flags & VM_SHARED)) {
> ...
> } else {
>          shmem_mfill_atomic_pte()
> }
> 
> With...
> 
> if (!(dst_vma->vm_flags & VM_SHARED)) {
> ...
> } else {
> ...
>          uffd_ops->uffd_copy()
> }
> 
> So, really, what needs to happen first is userfaultfd needs to be
> sorted.
> 
> There's no point of creating a vm_ops_uffd if it will just serve as
> replacing the call locations of the functions like this, as it has done
> nothing to simplify the logic.
> 
>> However if we want to generalize userfaultfd capability for a type of
>> memory, we will still need something like the vm_uffd_ops hook to report
>> such information.  It means drivers can still overwrite these, with/without
>> an exported mfill_atomic_install_pte() functions.  I'm not sure whether
>> that eases the concern.
> 
> If we work through the duplication and reduction where possible, the
> path forward may be easier to see.
> 
>>
>> So to me, generalizing the mem type looks helpful with/without moving
>> guest-memfd under mm/.
> 
> Yes, it should decrease the duplication across hugetlb.c and shmem.c,
> but I think that userfaultfd is the place to start.
> 
>>
>> We do have the option to keep hard-code guest-memfd like shmem or
>> hugetlbfs. This is still "doable", but this likely means guest-memfd
>> support for userfaultfd needs to be done after that work.  I did quickly
>> check the status of gunyah hypervisor [1,2,3], I found that all of the
>> efforts are not yet continued in 2025.  The hypervisor last update was Jan
>> 2024 with a batch push [1].
>>
>> I still prefer generalizing uffd capabilities using the ops.  That makes
>> guest-memfd support on MINOR not be blocked and it should be able to be
>> done concurrently v.s. guest-memfd library.  If guest-memfd library idea
>> didn't move on, it's non-issue either.
>>
>> I've considered dropping uffd_copy() and MISSING support for vm_uffd_ops if
>> I'm going to repost - that looks like the only thing that people are
>> against with, even though that is not my preference, as that'll make the
>> API half-broken on its own.
> 
> The generalisation you did does not generalize much, as I pointed out
> above, and so it seems less impactful than it could be.
> 
> These patches also do not explore what this means for guest_memfd.  So
> it is not clear that the expected behaviour will serve the need.
> 
> You sent a link to an example user.  Can you please keep this work
> together in the patch set so that we know it'll work for your use case
> and allows us an easier way to pull down this work so we can examine it.

Hi Liam, Lorenzo,

With mmap support in guest_memfd being recently accepted and merged into 
kvm/next [1], UFFDIO_CONTINUE support in guest_memfd becomes a real use 
case.

 From what I understand, it is the API for UFFDIO_COPY (ie the 
.uffd_copy callback) proposed by Peter that raises the safery issues, 
while the generalisation of the checks (.uffd_features, .uffd_ioctls) 
and .uffd_get_folio needed for UFFDIO_CONTINUE do not introduce such 
concerns.  In order to unblock the userfaultfd support in guest_memfd, 
would it be acceptable to start with implementing 
.uffd_get_folio/UFFDIO_CONTINUE only, leaving the callback for 
UFFDIO_COPY for later when we have an idea about a safer API and a clear 
use case for that?

If that's the case, what would be the best way to demonstrate the client 
code?  Would using kvm/next as the base for the aggregated series (new 
mm API + client code in kvm/guest_memfd) work?

Thanks,
Nikita

[1]: https://lore.kernel.org/kvm/20250729225455.670324-1-seanjc@google.com/
> 
> Alternatively, you can reduce and combine the memory types without
> exposing the changes externally, if they stand on their own.  But I
> don't think anyone is going to accept using a vm_ops change where a
> direct function call could be used.
> 
>> Said that, I still prefer this against
>> hard-code and/or use CONFIG_GUESTMEM in userfaultfd code.
> 
> It also does nothing with regards to the CONFIG_USERFAULTFD in other
> areas.  My hope is that you could pull out the common code and make the
> CONFIG_ sections smaller.
> 
> And, by the way, it isn't the fact that we're going to copy something
> (or mfill_atomic it, I guess?) but the fact that we're handing out the
> pointer for something else to do that.  Please handle this manipulation
> in the core mm code without handing out pointers to folios, or page
> tables.
> 
> You could do this with the address being passed in and figure out the
> type, or even a function pointer that you specifically pass in an enum
> of the type (I think this is what Lorenzo was suggesting somewhere),
> maybe with multiple flags for actions and fallback (MFILL|ZERO for
> example).
> 
> Thanks,
> Liam
> 


