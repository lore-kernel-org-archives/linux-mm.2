Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C489C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 14:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048DC6B0096; Fri,  1 Aug 2025 10:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020D76B0098; Fri,  1 Aug 2025 10:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1706B0099; Fri,  1 Aug 2025 10:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC9B46B0096
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:24:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8EB8411392C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:24:21 +0000 (UTC)
X-FDA: 83728408722.01.7BDBAB2
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf14.hostedemail.com (Postfix) with ESMTP id EBB78100007
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:24:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sh34V0d6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754058260; a=rsa-sha256;
	cv=none;
	b=mwG6HWtjyDJ8z4pcs2CbWJn/OIR8nOU1WbpkMEG/ZsrhFOz3XlAxDii4n7O6C6JDYn5dHM
	nLch/EFFuXiKcz7loXpMyWMI2tnQ6clup3eBVjHW0YJXugOs0ON4dITpqpwY4GRWBnADow
	0dJYRx77kX36lkMRDzjCkOdqgX93Biw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sh34V0d6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754058260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXydD3FsZQCyWsAOrsQRIH41rX7TISotELFJPsxbkdY=;
	b=PfUskP0oMtjqbBWZ0MDaHNA9xPSSdO1stbfbqPdVkMZEAbUN8zqiKDcz2BT202kgHOc2Zy
	5p6kyVD0sxv9DGosLGnX0Wc8cdvfsKxYV3ZBL2eWJIjiEpBVGFjfUFNvUBq20hlcuddV52
	Xrb8XRjaUFL4vqDfeP9ZzRPwJRLI43M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 42560A55886;
	Fri,  1 Aug 2025 14:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2674C4CEE7;
	Fri,  1 Aug 2025 14:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754058258;
	bh=LdWLM57B/0XA9mDL5JeTNz6Ago8lMwc+LmfdW7VJ9js=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sh34V0d6zMmhqDHGN93E32yJAm0b4ksxVAZI5uPc8t8G02fK26EEihsDOFx5AiZmx
	 84mAo3hiF+tDfLCnX6IRQ4/OEXPUBntA+LiaYtAtfpAG9RT24sMyZj2zFmopZrpmTP
	 N5iFnXhs0W5N9pK/76oI98dfp4Pl6fuVwYEucPR3mGhZjvWw+tAOPovUERPmYdF9cB
	 zHcbXq7sGnX8Uzzj4bVWwm5wtu++jYsYvrhC3hPU8PUY53SR4tViP6sMpjF1VgKQSN
	 WczApY8X+fIkWTQbmFsJZLd2FS4yhDDfZpoTksrGDXvw2eLf0XOrViuKoDWtjVg5Wi
	 1XmbS2jXAVBRQ==
Date: Fri, 1 Aug 2025 10:24:16 -0400
From: Sasha Levin <sashal@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
	aarcange@redhat.com, surenb@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix missing PTE unmap for non-migration
 entries
Message-ID: <aIzOEJgbmjae7AOS@lappy>
References: <20250630031958.1225651-1-sashal@kernel.org>
 <20250630175746.e52af129fd2d88deecc25169@linux-foundation.org>
 <a4d8b292-154a-4d14-90e4-6c822acf1cfb@redhat.com>
 <aG06QBVeBJgluSqP@lappy>
 <a8f863b1-ea06-4396-b4da-4dca41e3d9a5@redhat.com>
 <aItjffoR7molh3QF@lappy>
 <214e78a0-7774-4b1e-8d85-9a66d2384744@redhat.com>
 <aIzAj9xUOPCsmZEG@lappy>
 <593b222e-1a62-475c-9502-76e128d3625d@redhat.com>
 <286466e3-9d1c-40a0-a467-a48cb2b657b4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <286466e3-9d1c-40a0-a467-a48cb2b657b4@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EBB78100007
X-Stat-Signature: cc1mo8ohjdsaznw1iqk5c6y6bcm7jyio
X-HE-Tag: 1754058259-626045
X-HE-Meta: U2FsdGVkX19uzjVyQL4ZlIoffWUXE8+V3IbFyhtEnfG+XR49t4VzClVkvdn6ws+T1JXzz6UVzg8nEGiUQADlgmR4cbc0kTz0ichOVNGr+LYtJXYeTmE+CNdkPT36hVwndlAsoFZuxH3A/4ocB8a5zBVPwHKXDv0G/GPIzk0beVDsQJ6ZKHXi0e6lZFbyU3AcjFHNYAi8TY5X3Wuyex6QTCt/LF5hB+hQU/ofP2+WAzNVPIuLXcGAvrBluTr6v66TMfQN7z/65DeJRlHiu7d+3XnQ644zKrCKlv79mkUfknDcl7SAYOMVzHs3BK7el7gooWrmioqSsdClc6GwHtFVjm+8jegbxtRABZQpw7zlChTAtFKEcGh/RzK7oyXnZxsl7fNf3XJus7Mt8Spp0tJKQjc8jILsfvWibOK6MOYrCov834Oh4upAvXnAOCe1hCLE1yQlb8NnPeI4UWPO0nZs+LjBjxEEkT3UXq+JKbQJtZQ+JGdupV+9x9kwAoFoKHgWItTHEEClGTa+1Duwkp+BhCuPrdyAALQfAWGaNPsvvXBcYVKLre46qyVggP/3FtzI7AZ4e8F92b+QwTVqQn0CM1i24/WeUGhvXIOyy/FERewvnrWhy0mqrBv5HT62wM30oxQPqNDbMgviiRv/yiPaX66opNwQ3xPk4BmR0ZlW+DWmLxjjXuUjkWmh2ieUKLwV03zg/IxD5WR+DFDWMnSmi5MUcrp9RZ5KnvLoDr+jt1Llvn8VIwwyuUnfXxpkpKlzEb5ZiiDaESlrFq9DgEwSIAPiBP8rFhE5FRYg1l4Y35KjsAOoz9D+OjEDpcRQWGRlQqOtQ772Z839KjeXZWcPcYFWOL9H83aZCOBJQZm2K1MKMehkiONzmdTeWWKAeoe2G/EoS5Se2CV5Zh+CU3vVs0RGPIWdI1vgoKA0GOpi4KasEGfRsl2GHuoStdpAJiq5ACDKl6P5KRdNXH8InFt
 mdFg6P4c
 dMLq695Zy+LOls2Keq/U0pL39jK7eeBw/vOazAbcF02oV7k4m+tMnX14AKLDTGtdghSK9FXZjcZ8qRru6CH1/eBv7J8xYEcLB/ekvsFzls2GJUCN3u9/96apQfbU51t3yLIb6rzkUjxesn2uiSKSe/BMRbxMyYP5svnXBgl6XAh/tv/VlAcmaX/y9nhMYBbxHUM4UgKV/l0xO11HOcM4FE/j5N2Tw6uqEy00sulczxNCukWaMgD/J3scZv+zHkn4hxR4OzRRlY1jUDphkIfKh7ZcIcanOFCXCaHfSeakJLIJz6V8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 04:13:32PM +0200, David Hildenbrand wrote:
>On 01.08.25 16:06, David Hildenbrand wrote:
>>On 01.08.25 15:26, Sasha Levin wrote:
>>>On Thu, Jul 31, 2025 at 02:56:25PM +0200, David Hildenbrand wrote:
>>>>On 31.07.25 14:37, Sasha Levin wrote:
>>>>>On Tue, Jul 08, 2025 at 05:42:16PM +0200, David Hildenbrand wrote:
>>>>>>On 08.07.25 17:33, Sasha Levin wrote:
>>>>>>>On Tue, Jul 08, 2025 at 05:10:44PM +0200, David Hildenbrand wrote:
>>>>>>>>On 01.07.25 02:57, Andrew Morton wrote:
>>>>>>>>>On Sun, 29 Jun 2025 23:19:58 -0400 Sasha Levin <sashal@kernel.org> wrote:
>>>>>>>>>
>>>>>>>>>>When handling non-swap entries in move_pages_pte(), the error handling
>>>>>>>>>>for entries that are NOT migration entries fails to unmap the page table
>>>>>>>>>>entries before jumping to the error handling label.
>>>>>>>>>>
>>>>>>>>>>This results in a kmap/kunmap imbalance which on CONFIG_HIGHPTE systems
>>>>>>>>>>triggers a WARNING in kunmap_local_indexed() because the kmap stack is
>>>>>>>>>>corrupted.
>>>>>>>>>>
>>>>>>>>>>Example call trace on ARM32 (CONFIG_HIGHPTE enabled):
>>>>>>>>>>    WARNING: CPU: 1 PID: 633 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
>>>>>>>>>>    Call trace:
>>>>>>>>>>      kunmap_local_indexed from move_pages+0x964/0x19f4
>>>>>>>>>>      move_pages from userfaultfd_ioctl+0x129c/0x2144
>>>>>>>>>>      userfaultfd_ioctl from sys_ioctl+0x558/0xd24
>>>>>>>>>>
>>>>>>>>>>The issue was introduced with the UFFDIO_MOVE feature but became more
>>>>>>>>>>frequent with the addition of guard pages (commit 7c53dfbdb024 ("mm: add
>>>>>>>>>>PTE_MARKER_GUARD PTE marker")) which made the non-migration entry code
>>>>>>>>>>path more commonly executed during userfaultfd operations.
>>>>>>>>>>
>>>>>>>>>>Fix this by ensuring PTEs are properly unmapped in all non-swap entry
>>>>>>>>>>paths before jumping to the error handling label, not just for migration
>>>>>>>>>>entries.
>>>>>>>>>
>>>>>>>>>I don't get it.
>>>>>>>>>
>>>>>>>>>>--- a/mm/userfaultfd.c
>>>>>>>>>>+++ b/mm/userfaultfd.c
>>>>>>>>>>@@ -1384,14 +1384,15 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
>>>>>>>>>>   		entry = pte_to_swp_entry(orig_src_pte);
>>>>>>>>>>   		if (non_swap_entry(entry)) {
>>>>>>>>>>+			pte_unmap(src_pte);
>>>>>>>>>>+			pte_unmap(dst_pte);
>>>>>>>>>>+			src_pte = dst_pte = NULL;
>>>>>>>>>>   			if (is_migration_entry(entry)) {
>>>>>>>>>>-				pte_unmap(src_pte);
>>>>>>>>>>-				pte_unmap(dst_pte);
>>>>>>>>>>-				src_pte = dst_pte = NULL;
>>>>>>>>>>   				migration_entry_wait(mm, src_pmd, src_addr);
>>>>>>>>>>   				err = -EAGAIN;
>>>>>>>>>>-			} else
>>>>>>>>>>+			} else {
>>>>>>>>>>   				err = -EFAULT;
>>>>>>>>>>+			}
>>>>>>>>>>   			goto out;
>>>>>>>>>
>>>>>>>>>where we have
>>>>>>>>>
>>>>>>>>>out:
>>>>>>>>>	...
>>>>>>>>>	if (dst_pte)
>>>>>>>>>		pte_unmap(dst_pte);
>>>>>>>>>	if (src_pte)
>>>>>>>>>		pte_unmap(src_pte);
>>>>>>>>
>>>>>>>>AI slop?
>>>>>>>
>>>>>>>Nah, this one is sadly all me :(
>>>>>>
>>>>>>Haha, sorry :P
>>>>>
>>>>>So as I was getting nowhere with this, I asked AI to help me :)
>>>>>
>>>>>If you're not interested in reading LLM generated code, feel free to
>>>>>stop reading now...
>>>>>
>>>>>After it went over the logs, and a few prompts to point it the right
>>>>>way, it ended up generating a patch (below) that made sense, and fixed
>>>>>the warning that LKFT was being able to trigger.
>>>>>
>>>>>If anyone who's more familiar with the code than me (and the AI) agrees
>>>>>with the patch and ways to throw their Reviewed-by, I'll send out the
>>>>>patch.
>>>>
>>>>Seems to check out for me. In particular, out pte_unmap() everywhere
>>>>else in that function (and mremap.c:move_ptes) are ordered properly.
>>>>
>>>>Even if it would not fix the issue, it would be a cleanup :)
>>>>
>>>>Acked-by: David Hildenbrand <david@redhat.com>
>>>
>>>David, I ended up LLM generating a .cocci script to detect this type of
>>>issues, and it ended up detecting a similar issue in
>>>arch/loongarch/mm/init.c.
>>
>>Does loongarch have these kmap_local restrictions?
>
>loongarch doesn't use HIGHMEM, so it probably doesn't matter. Could be 
>considered a cleanup, though.

Yup, it's just a cleanup for loongarch.

It was the only other place besides mm/userfaultfd.c that had that
inversion, so keeping the tree warning clear will make it easier to spot
newly introduced issues in the future.

-- 
Thanks,
Sasha

