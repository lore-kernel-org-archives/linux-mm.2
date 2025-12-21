Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1103E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A4F6B00A6; Sun, 21 Dec 2025 04:22:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B9746B00A7; Sun, 21 Dec 2025 04:22:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA296B00A8; Sun, 21 Dec 2025 04:22:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4D96B00A6
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:22:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 929F45B334
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:22:53 +0000 (UTC)
X-FDA: 84242938626.24.96A3476
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id BD5C21C0006
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:22:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gmwuyHj+;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766308971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpZeZM48gN392hwtrdm+XPYbRwOvOacSCICRceQeC8I=;
	b=ZnVNqGzuUXP7HOudi3pxa/5dO/B89oIJQUkOu2jzzUP1s9ZVTFJCAGVX+YP1X0NTj32j84
	xibc5/b21UjoFSoEsb0tIkCZeNBlk1AYWozCgrRPLqlYs0YMoQyo8WEnPai0nb4b1RGLAL
	SdOZwWT5o4E5QBgFbCBSeR4S/6Hvp0c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gmwuyHj+;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766308971; a=rsa-sha256;
	cv=none;
	b=GkQ6m78s02CKEcvWgnSY6xOKeSA8TJooKvf+RN4Nl35DoNLjZWongPSXmz+eE//bPkzCbf
	9Fs+RjffF8iGWLPua0Jssbm3gYFVMU5E0QYuiLgboBJS5L83Do+WX6k1hJPlSM42UXRSNk
	x2OuqzDgGDJo919M+Y5VeIhK8MjfC/E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD09143BE5;
	Sun, 21 Dec 2025 09:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE3EC4CEFB;
	Sun, 21 Dec 2025 09:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766308970;
	bh=1hH+QYmuXmY+esC5aiJxRFWapofDzNwd4JqJjBXFA6g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gmwuyHj+PQbFQQ/ir2/clzoLLRp/DiruHvZT3ZWwJSRoMFFkgT4qAdgrddf19g2lh
	 XgDW+n2LQQaB2Ri/aFW0Jhsu0kPomMtoPV4kvSWM+L4oQtFaB4YmwwChK0zdQ+T303
	 Ua0wvmIdpdryQc3lc8k2wuv6ygYDJ04rJ5gsJ2v2Gc8QkhibbD2L9xiUgS88VCiOkO
	 diJY9OQbc/+hV4SVUPuxLTe1XeZ6SV+femSqq4ROEumdksZQCIH8tEmolsNyJxbwcL
	 j5qVjtf4ulvdUtKISwElr/mK7wKo0lKT43UVJDfRo6+5qjgssZT83/ralZNBpBTo+I
	 8ZMXhWEpkJpnQ==
Message-ID: <655cc605-2ce1-4ccb-8cc0-a0a31a9c89fd@kernel.org>
Date: Sun, 21 Dec 2025 10:22:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Sourabh Jain <sourabhjain@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
 Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20251221053611.441251-1-sourabhjain@linux.ibm.com>
 <87a4zcml36.ritesh.list@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <87a4zcml36.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: kxppoifdwiga6dtwtdxkyqwjjop78qim
X-Rspam-User: 
X-Rspamd-Queue-Id: BD5C21C0006
X-HE-Tag: 1766308971-468655
X-HE-Meta: U2FsdGVkX19ge/RQiUF3baMqLFt0rDGgRlGD6TdVETdtc4KXqjDreSChF4CiVubrmdqi9Jp2YjoVUuMguvoemQRYusCpuTDFFkbLav0gQe2nx/V7HLkwTqVRvfFaQBC9ESd3Dv/aPafCsxhBpAk8BxRhbi5eBWxlm4ed+kkNXJQRcEkdnE6UxPpuvtmUzIp+VQQ24KLX8IdHzqyRMjaDWz1WmewAi4VA7OJx8ZUVCZm7qGclxLuJwaSe8bsXwr9vpPr7fvAf+SwnmjsJpmOnCWmQ6gaCpyKwZkvn7Mb6WSNxfK0zKIVcjAsWH/0XaUVNwIDeFLQZMNlfHpWM+4zkVijbgAzSkTBAuvjKZcZo+mvxFfImcJhETL7gnbp7tBjJO7mQfTrPwpiFICPMdXH23AI1gFBiQPPn6abD6ZHFEdhgIwNSa3dyLkkiT/GXUmHrNiD6M2fXKeI32dh61psbzG8VIysxdi5zYqzfoLN4+98kdLgoUU6INZnpRCSGfGzQOwv4kApaXmNQ0kst2uDkFH0omuxlvCAza16bm6muydMBwp2yIAZftjJujR6UGG6l/iPDqU721NwbUfhTKdNjusGqINJH3fVfyaw8SAk4f+mePZDkAQKZgVIXw5beVDz6bOh2MXcnzkV93cefigiizFTOIVunl3fxbMnFhiaocAXVxf6S8L+4I1GFim07iwZc8RwwX7EKlIoBAl4jO5IPEhpl3dvhoo8KPbSxoxqvqhgyJn+jGVx4ByyHjhrdSFsoFADchsAYp4J2d/jK16xajJOthBhzH+9AXfrpfZzFnfGQ1hRtVNMeLZfKhNGuiOXRScnyDJCkxHF2by6MJxEXRz1iVQlcNIeiRb/RqLQXOdIIOFcZjx6+bnL7Mas7jiZ7gyQ/AfzmbfkSbFBcK2lGaoazrxFe7dUTINrkKH/BGYFy4rNNf9sdnPJU7yRAmAexA/4jEW1TUhgWBvBFwiG
 gfSaWW1X
 C/1jHFmsE5tDOKzjIMyE/SGH7/ArqpTgJFQeB7Ds2+yeWoUvR7XFhpKsXXlpiWqSUot1RQkcoJx1bxVFM/Zmu32nwmwJVc+qfHMqLBQdh8v+7K/vkecJxGBzGT9VIPea+MMPCTmEk2O2AyHw0TRYXjog4Vzr6/pfrkDQIobTBvDyZMxDzbmTm+Bfnz9aduJNgEkgd8ofcPdFQGdB+WmJvMBy4WAPO//R1GFhN5EU1zBVe1DCrTI6DV2swC4cZH8VK8YtmqBSKdxX+v9qGmgE+MG/sO+EN1m9VmopFCp7BhIyR6rqNxUo3uvhEBA61nmlvkkcipe3JZWSbDFf/qm1B6XGhIS58Wk+QbWMEMjY0dNE9AKqoUgeyFR5xpUjlrhghaE+grGMvjrNpUBgDeSFhDhbp0/4ZMFbDAdtNtDaP9xfhYn8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/21/25 06:59, Ritesh Harjani (IBM) wrote:
> Hi Sourabh,
> 
> Sourabh Jain <sourabhjain@linux.ibm.com> writes:
> 
>> Skip processing hugepage kernel arguments (hugepagesz, hugepages, and
>> default_hugepagesz) when hugepages are not supported by the
>> architecture.
>>
>> Some architectures may need to disable hugepages based on conditions
>> discovered during kernel boot. The hugepages_supported() helper allows
>> architecture code to advertise whether hugepages are supported.
>>
>> Currently, normal hugepage allocation is guarded by
>> hugepages_supported(), but gigantic hugepages are allocated regardless
>> of this check. This causes problems on powerpc for fadump (firmware-
>> assisted dump).
>>
>> In the fadump (firmware-assisted dump) scenario, a production kernel
>> crash causes the system to boot into a special kernel whose sole
>> purpose is to collect the memory dump and reboot. Features such as
>> hugepages are not required in this environment and should be
>> disabled.
>>
>> For example, when the fadump kernel boots with the following kernel
>> arguments:
>> default_hugepagesz=1GB hugepagesz=1GB hugepages=200
>>
>> Before this patch, the kernel prints the following logs:
>>
>> HugeTLB: allocating 200 of page size 1.00 GiB failed.  Only allocated 58 hugepages.
>> HugeTLB support is disabled!
>> HugeTLB: huge pages not supported, ignoring associated command-line parameters
>> hugetlbfs: disabling because there are no supported hugepage sizes
>>
>> Even though the logs state that HugeTLB support is disabled, gigantic
>> hugepages are still allocated. This causes the fadump kernel to run out
>> of memory during boot.
>>
>> After this patch is applied, the kernel prints the following logs for
>> the same command line:
>>
>> HugeTLB: hugepages unsupported, ignoring default_hugepagesz=1GB cmdline
>> HugeTLB: hugepages unsupported, ignoring hugepagesz=1GB cmdline
>> HugeTLB: hugepages unsupported, ignoring hugepages=200 cmdline
>> HugeTLB support is disabled!
>> hugetlbfs: disabling because there are no supported hugepage sizes
>>
>> To fix the issue, gigantic hugepage allocation should be guarded by
>> hugepages_supported().
>>
>> Previously, two approaches were proposed to bring gigantic hugepage
>> allocation under hugepages_supported():
>>
>> [1] Check hugepages_supported() in the generic code before allocating
>> gigantic hugepages
>> [2] Make arch_hugetlb_valid_size() return false for all hugetlb sizes
>>
>> Approach [2] has two minor issues:
>> 1. It prints misleading logs about invalid hugepage sizes
>> 2. The kernel still processes hugepage kernel arguments unnecessarily
>>
>> To control gigantic hugepage allocation, skip processing hugepage kernel
>> arguments (default_hugepagesz, hugepagesz and hugepages) when
>> hugepages_supported() returns false.
>>
>> Link: https://lore.kernel.org/all/20250121150419.1342794-1-sourabhjain@linux.ibm.com/ [1]
>> Link: https://lore.kernel.org/all/20250128043358.163372-1-sourabhjain@linux.ibm.com/ [2]
>> Fixes: c2833a5bf75b ("hugetlbfs: fix changes to command line processing")
> 
> 
> I appreciate our proactiveness to respond quickly on mailing list, but I
> suggest we give enough time to folks before sending the next version
> please ;).
> 
> Your email from last night [1] says that we will use this fixes tag but
> you haven't even given us 24hrs to respond to that email thread :). Now
> we've sent this v6, with Acked-by of David and Reviewed-by of mine,
> which seems like everything was agreed upon, but that isn't the case
> actually.

Agreed.

> 
> My main concern was -
> A fixes tag means it might get auto backported to stable kernels too,

Not in the MM world -- IIRC. I think there is the agreement, that we 
decide what should go into stable and what not.

Andrew can correct me if my memory is wrong.

But we can always jump in and say that something should not go to stable 
trees.

> which means if the fixes tag is incorrect it could even break stable
> kernels then.
> 
> [1]: https://lore.kernel.org/linuxppc-dev/041352df-41ce-4898-8535-d6b7fd74a52b@linux.ibm.com/T/#m6e16738c03b2b2a8d09717f6291e46207033507a
> 
> 
> Anyways,
> Coming back to the fixes tag. I did mention a bit of a history [2] of
> whatever I could find while reviewing this patch. I am not sure whether
> you have looked into the links shared in that email or not. Here [2]:
> 
> [2]: https://lore.kernel.org/linuxppc-dev/875xa3ksz9.ritesh.list@gmail.com/
> 
> Where I am coming from is.. The current patch is acutally a partial
> revert of the patch mentioned in the fixes tag. That means if this patch
> gets applied to the older stable kernels, it would end up bringing the
> same problem back, which the "Fixes" tagged patch is fixing in the 1st
> place, isnt' it? See this discussion [3]...
> 
> [3]: https://lore.kernel.org/all/b1f04f9f-fa46-c2a0-7693-4a0679d2a1ee@oracle.com/T/#m0eee87b458d93559426b8b0e78dc6ebcd26ad3ae
> 
> ... So, IMO - the right fixes tag, if we have to add, it should be the
> patch which moved the hpage_shift initialization to happen early i.e. in
> mmu_early_init_devtree. That would be this patch [4]:
> 
> [4]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2354ad252b66695be02f4acd18e37bf6264f0464
> 
> Now, it's not really that the patch [4] had any issue as such. But it
> seems like, that the current fix can only be applied after patch [4] is
> taken.
> 
> Do we agree?
I think we should document all that in the cover letter, an describe 
that this partial revert is only possible after [4], and that that must 
be considered when attempting any kind of stable backports.

Thanks for pointing all that out.

-- 
Cheers

David

