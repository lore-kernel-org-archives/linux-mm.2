Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF2A3C83F17
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 645538E0009; Thu, 31 Jul 2025 08:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61D628E0001; Thu, 31 Jul 2025 08:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A418E0009; Thu, 31 Jul 2025 08:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 467B08E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:37:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D04A2134A3C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:37:22 +0000 (UTC)
X-FDA: 83724510324.27.79DDD57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4612210000C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:37:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DQwjL0KX;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753965441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7s7Zf9h9lQsRDL0DjxBX7m+8RhdnH8Y3lvusXJPVoCA=;
	b=OqQUSAAcJd1KK2jAvNn2NMz58GSjC6i8J5UCEla5YpQ4jDfUC8jb7FiI3dV+i29Cfe7qjd
	DFbN94XIm79CfIqWEp0gdZRSJ7rksA3tr/XOKso45YDB8GjAm1U34XFIFbNvtVL71buc9f
	z085Z7+lgwm3aT8rtIaQNVbwZ1TX/BE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DQwjL0KX;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753965441; a=rsa-sha256;
	cv=none;
	b=baJrTLwqTLSvDvgT0aEJNHiXcilh1xHgIGEI//6Icfv/7eihBJ5i9tDSKGGluBx9qS01LL
	3sgxYsm55oLoTTGw508Nncqe97/7VfgUsOmvaGc8hGgx7bD7xI7rI494uU/s+5OXmrUCbC
	jm50ffLOGYFD55dk0T63w1FM2dEI9Aw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AE68601F0;
	Thu, 31 Jul 2025 12:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71B6C4CEEF;
	Thu, 31 Jul 2025 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753965440;
	bh=x1zdbpjE+cQySjmlF0wAM2xxqmg+a54+zYfqjK8Zpzg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DQwjL0KXX9GSPLy404TgAv0Qjn5xJ/FZd0z0sd2awLL9rtJ6MpA0rDUw5mOVdzCMq
	 bMpFB8M36c4znUpKP/k50xNWpODaryzeMbshLCpQjMli2PVEe4qOQWgRuJc8rndyXK
	 BH1Z6o0w2ur0cNxQf1PwRaeMdZcj1hdTc2/Y9DttZsTtvvaHmzC3atRN5EtcoDkqBf
	 hfBo67Vr0R3Y0/MbpO0VeNbRNIHvoKW2qw9ht+3NKrG7vkyOnoitqwiCcCc1xmNe5i
	 IATI8gFqfxsQQyklFYF9OEkCf5DIk7ttJepk8TkGFkOLxuhy3ePvyZX2NGm605ONo3
	 WhjTJ5Qx1Bk6w==
Date: Thu, 31 Jul 2025 08:37:17 -0400
From: Sasha Levin <sashal@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
	aarcange@redhat.com, surenb@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix missing PTE unmap for non-migration
 entries
Message-ID: <aItjffoR7molh3QF@lappy>
References: <20250630031958.1225651-1-sashal@kernel.org>
 <20250630175746.e52af129fd2d88deecc25169@linux-foundation.org>
 <a4d8b292-154a-4d14-90e4-6c822acf1cfb@redhat.com>
 <aG06QBVeBJgluSqP@lappy>
 <a8f863b1-ea06-4396-b4da-4dca41e3d9a5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a8f863b1-ea06-4396-b4da-4dca41e3d9a5@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4612210000C
X-Rspamd-Server: rspam06
X-Stat-Signature: n714wuuaazqebphxp3tb733u43rjutng
X-HE-Tag: 1753965441-148899
X-HE-Meta: U2FsdGVkX1+qmENUUbr417GmFYCPv9HxmbBWtR9SR4+z/mcMSmqIaI8FaeD1uBBHsiQ37xudLakaZMGvIPUKW8+MCiObp2J6urLw0xx/FE0nxWq6lZ04jzpcai0q2KRkK4/MyP6U94Jl8xTezcfhG0/FJjN7MBzc6hLobsg5dQpfKpHFXadFGo5SAvkQcXMq0Mk+4fC6L14j/wRwIheu0Eg4QMJQ2P3HigerYdi+4xntRZavRsEpPvkiuzGgItO1HkYRsc6P5LH4G+Meyq21nw3k/q3QYVkmxA7QN4gEE/zyELF5YnivVmEbF1e28thFq6wiGrAPoswn4GC7OcU/Bbt1T0vDh+wlhr0Btv7aynzaAiHT9tZSbk7tclSQKm3xCUN8IU92fV3yFx73puwnSP6uQV+kU7Xlzi09XRojJKg/yT1NZ8YATqXzJB31PUEgHJq2ZJohgZlg4yMaIqrwxOE3AI5gaoeVi0oEDqv4THJ87+KlnpIAVWx7zgTr+i56mo1LKJl7s0vsRzkV4a2b2SLtId9cvaR0ZePEgq/QmzmJ1MsWZr0IJAMoSL6Y1Fa7N4zfYD8i0eELfqlYEQYghmMVwy5bOWepzayJ4WQoCxB1LQMwAmI3rlw/6dEgQW/TqrJedUWlxhSp3RLcfF4hW9hJ/6HDo+F4YrhHjJ0qOJ4X/MUDQyckW5k2FhczGlwFZcT0dFBqIKMCO8/3pSca0jcy2VkgdL1oCp2ISxzqPr3wSWj4PELTL/gdpTIgiGiEu5M3jGHhsYzDPL9Taf0pcpxVLPy5DwrUbGyiM+Q8Hu0pQiihNq3EFDawmdOSijBHmsEErp+QrXm0EAbhhP8KNpQze7YX0lFBnMdechlrcImxQ/mvbWijNYRqikzfvhwBhhTHIYJn28I+o2uRXrENj2depJuRYhcmDWQAhdM++/az1Pt4uXnoBZ6RPbHmp12ybhenoCzTjtwfZkIc/3I
 ZR8Nerkd
 uLGIpgIu5T1e4OKe7wpk+lypiSLc6actEvcuEmlZi9MWNXjjBTNC8wyNjo5VOX87zpvuzPNW6XlZNX9WZ2fvASvUC1Mfu5c1mgetnA7OaOqykBT/L9o54EyM6p6TN47HpXW+ZFau/veqMkcOCzBKYlXPVNKq7TSHUexpjZvRimxNl3YPp2lehOrXcn4ZE5KxXBasL7mM9qGZb+vpujfmZipITEd07NBMEc47WCD21yZYViysuYuQy6Ta3uhnjX6VaWJEvgUFae2m3oB0iomY052ZRSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 08, 2025 at 05:42:16PM +0200, David Hildenbrand wrote:
>On 08.07.25 17:33, Sasha Levin wrote:
>>On Tue, Jul 08, 2025 at 05:10:44PM +0200, David Hildenbrand wrote:
>>>On 01.07.25 02:57, Andrew Morton wrote:
>>>>On Sun, 29 Jun 2025 23:19:58 -0400 Sasha Levin <sashal@kernel.org> wrote:
>>>>
>>>>>When handling non-swap entries in move_pages_pte(), the error handling
>>>>>for entries that are NOT migration entries fails to unmap the page table
>>>>>entries before jumping to the error handling label.
>>>>>
>>>>>This results in a kmap/kunmap imbalance which on CONFIG_HIGHPTE systems
>>>>>triggers a WARNING in kunmap_local_indexed() because the kmap stack is
>>>>>corrupted.
>>>>>
>>>>>Example call trace on ARM32 (CONFIG_HIGHPTE enabled):
>>>>>   WARNING: CPU: 1 PID: 633 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
>>>>>   Call trace:
>>>>>     kunmap_local_indexed from move_pages+0x964/0x19f4
>>>>>     move_pages from userfaultfd_ioctl+0x129c/0x2144
>>>>>     userfaultfd_ioctl from sys_ioctl+0x558/0xd24
>>>>>
>>>>>The issue was introduced with the UFFDIO_MOVE feature but became more
>>>>>frequent with the addition of guard pages (commit 7c53dfbdb024 ("mm: add
>>>>>PTE_MARKER_GUARD PTE marker")) which made the non-migration entry code
>>>>>path more commonly executed during userfaultfd operations.
>>>>>
>>>>>Fix this by ensuring PTEs are properly unmapped in all non-swap entry
>>>>>paths before jumping to the error handling label, not just for migration
>>>>>entries.
>>>>
>>>>I don't get it.
>>>>
>>>>>--- a/mm/userfaultfd.c
>>>>>+++ b/mm/userfaultfd.c
>>>>>@@ -1384,14 +1384,15 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
>>>>>  		entry = pte_to_swp_entry(orig_src_pte);
>>>>>  		if (non_swap_entry(entry)) {
>>>>>+			pte_unmap(src_pte);
>>>>>+			pte_unmap(dst_pte);
>>>>>+			src_pte = dst_pte = NULL;
>>>>>  			if (is_migration_entry(entry)) {
>>>>>-				pte_unmap(src_pte);
>>>>>-				pte_unmap(dst_pte);
>>>>>-				src_pte = dst_pte = NULL;
>>>>>  				migration_entry_wait(mm, src_pmd, src_addr);
>>>>>  				err = -EAGAIN;
>>>>>-			} else
>>>>>+			} else {
>>>>>  				err = -EFAULT;
>>>>>+			}
>>>>>  			goto out;
>>>>
>>>>where we have
>>>>
>>>>out:
>>>>	...
>>>>	if (dst_pte)
>>>>		pte_unmap(dst_pte);
>>>>	if (src_pte)
>>>>		pte_unmap(src_pte);
>>>
>>>AI slop?
>>
>>Nah, this one is sadly all me :(
>
>Haha, sorry :P

So as I was getting nowhere with this, I asked AI to help me :)

If you're not interested in reading LLM generated code, feel free to
stop reading now...

After it went over the logs, and a few prompts to point it the right
way, it ended up generating a patch (below) that made sense, and fixed
the warning that LKFT was being able to trigger.

If anyone who's more familiar with the code than me (and the AI) agrees
with the patch and ways to throw their Reviewed-by, I'll send out the
patch.

If the below patch is completely bogus then I'm sorry and I'll buy you a
beer at LPC :)


 From 70f7eae079a5203857b96d6c64bb72b0f566d4de Mon Sep 17 00:00:00 2001
From: Sasha Levin <sashal@kernel.org>
Date: Wed, 30 Jul 2025 20:41:54 -0400
Subject: [PATCH] mm/userfaultfd: fix kmap_local LIFO ordering for
  CONFIG_HIGHPTE

With CONFIG_HIGHPTE on 32-bit ARM, move_pages_pte() maps PTE pages using
kmap_local_page(), which requires unmapping in Last-In-First-Out order.

The current code maps dst_pte first, then src_pte, but unmaps them in
the same order (dst_pte, src_pte), violating the LIFO requirement.
This causes the warning in kunmap_local_indexed():

   WARNING: CPU: 0 PID: 604 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
   addr != __fix_to_virt(FIX_KMAP_BEGIN + idx)

Fix this by reversing the unmap order to respect LIFO ordering.

This issue follows the same pattern as similar fixes:
- commit eca6828403b8 ("crypto: skcipher - fix mismatch between mapping and unmapping order")
- commit 8cf57c6df818 ("nilfs2: eliminate staggered calls to kunmap in nilfs_rename")

Both of which addressed the same fundamental requirement that kmap_local
operations must follow LIFO ordering.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Co-developed-by: Claude claude-opus-4-20250514
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
  mm/userfaultfd.c | 9 +++++++--
  1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 8253978ee0fb..bf7a57ea71e0 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1453,10 +1453,15 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
  		folio_unlock(src_folio);
  		folio_put(src_folio);
  	}
-	if (dst_pte)
-		pte_unmap(dst_pte);
+	/*
+	 * Unmap in reverse order (LIFO) to maintain proper kmap_local
+	 * index ordering when CONFIG_HIGHPTE is enabled. We mapped dst_pte
+	 * first, then src_pte, so we must unmap src_pte first, then dst_pte.
+	 */
  	if (src_pte)
  		pte_unmap(src_pte);
+	if (dst_pte)
+		pte_unmap(dst_pte);
  	mmu_notifier_invalidate_range_end(&range);
  	if (si)
  		put_swap_device(si);


-- 
Thanks,
Sasha

