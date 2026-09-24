Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43074C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 15:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7BD6B0093; Thu, 24 Sep 2026 11:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58FFF6B0095; Thu, 24 Sep 2026 11:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5236B0099; Thu, 24 Sep 2026 11:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 215DE6B0093
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:37:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9394D1403EA
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:37:39 +0000 (UTC)
X-FDA: 85249060638.18.0E6D0BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D7412C0002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:37:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z4oORqYx;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790264257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPYMIO+x+iyA0KmeCBR0xygja5jK7guc51FQmPPzDvQ=;
	b=VvwyQny94CqFvD39qHj1WESgSxNFy8+h8J2qD2pYlB/lTu55h1RJnK6YzzvMiwHcihlt9A
	0rldzayFd07u/aafNEs2RAUoYhvBGUFCA0BcJyQfJR9E4vN8o5Z4m3vThgHXsPpVjoXMk/
	qDZ8DynTlOFqhbI5g0WqcQULR5YT6ic=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z4oORqYx;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790264257;
	b=fkDn4MgL3kZkSJiaJVO8/Sg7/nwNykvcbVoKlwfYWtHZSau6qCh9dGhVNjCgg1XX77lx7I
	12e7M3/Jr08laQvGR83mca7jQ0vqWIO5Mo6s0Gr1qoceb6Mz57UZplbHtAXN2ZGr3HVg2N
	LIe3LVnS452Ff96RiZJNNeJVsEAmupA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A029601FF;
	Thu, 24 Sep 2026 15:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5511F00898;
	Thu, 24 Sep 2026 15:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790264256;
	bh=RPYMIO+x+iyA0KmeCBR0xygja5jK7guc51FQmPPzDvQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z4oORqYxAMkKSMkDNtbfR1jsCQHUXLBD6TZwNmyBRKn8ZviLafP2zdEPoHhQ560jC
	 eHlLgNjZ7knIezPx9yHK1VAbNO/GB84bba3jhCx1zy128BUOXrQF06neosCrNkPRG+
	 nH1ecjZZL1ppjErPy8/mVsIEhXSwo7HPOgPdcOiCuvUAGJn+uoeX/2yT1gbtHnYdoX
	 kmsuQ98pco/kTW4P6tmAAhYH6RT4tUnzxuA8wAXxYbmrqc1Zy5Dn8XTL5h0Oyredk4
	 rxBI8xX39hphWQ4zdxMwxjEWrLrd+tqNxQJWSLeQF55bPG2bsidc/qXjs6TVgID3sj
	 Kbv0NTAV0hnNQ==
Message-ID: <9efc7bc1-8d9d-49ac-b856-003e81558411@kernel.org>
Date: Thu, 24 Sep 2026 17:37:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero
 correctly
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lance Yang <lance.yang@linux.dev>,
 syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
References: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D7412C0002
X-Stat-Signature: 3uucqqhbqo9jpnyazyyufk6s6geep76d
X-Rspam-User: 
X-HE-Tag: 1790264257-746635
X-HE-Meta: U2FsdGVkX19LHsrk24sfOYKfs9Y0zSxgLNMomxc5FShbAuU7i6cY0bW42goh4o4lXPCJyJCmPbPshQIonJK1ymNiy7G+SYx9Tf8OAC7lGxBZGKiWFZ12hWd78SmghN86NGLzu/igfex01FloIjX1WwZvDlu+jQRFg3ERw5CfVnNHBVcUtuOK6OdvmHIHlKri+uzO9dz8htnytOqAP/uXxCTcP4hlPx5TAudFbqjBtreg87JIQDnIcrE8fxpqvspeh9ogrUty2HpM+PyemWgxgD8SsFUlNTwFM3J/HvCT61D+ZyS0CGZTA2ucQwh+hYAuhJJGkY+Ze2/h8f/UOBQS90cBs6xmOOkSwC6SgpRaO+trhPEleWGM+PWrSkCnezw0MvoKwiY9rJdZO2VnfD4Lm5MNqwp0enLCWpmdIOyy+7uXnUlC/panp+phIXoXSTmYxdNkiBu/HGIbzpLSUOu2N4pJdLHKmB3oUGWPZueo50otCrhcZb/vHKOi02lorg+3nrxncFm4lkduzJDbyZkCREhgX8ZwhhPBwWZwTornlvi0UJrVjk9gB6A6hwO3JZ9Ext3iKrPQ2f7/Y2xL0Xwdd1Oouwt5hlrelywP7lrcidEGgbmOXpl0ELyjr2PNq40laqaLEG1MsD3e5NTPmJ4E7zb0aqkUKZ0tY7CBZP38ZzsFMyAL0a0HqaddMrd0pCIfT3fYTe7KSW0eg1MSFP2opX25EUoTWaUZ40S5vAnTwVpfLkT8yhos/L5ENBNV+P5JF6dA7XP0jM3MjMD06nKJaJFInVduny5idmS97Q22r9vGkSJ2bSgFNxKHdXqzDsUA8xl1c+2SWzIGLVLfu0BfBawCw1fr0Z1NGOlblNBpJ8m6F5C1OCqxCkJxfjuLVdjagvxD1e9Tr+eSgYrNZCNEAOi+S7gVS3mIuj0DjvcWJGvIPyXmIuy1Rw2AWYzlfEdipVsdEu1zN4jVFvXWFB9
 oL3vnBcq
 kDF+VnKt72sSslhsGknWBngnkehsZ3YGJZs+zJa6dGW9d0Y932HbEfzCTF1Eytg4dllI8HrbJqtAwD96OhybyrZB/eEj19YXgjiENz5pBt933TVjn1gp6reummfeYmhwbyry/sqT19PATY4JMkx3N+pE90PVpFNbjLItCS1pDvE2XduyX0k2C8lzeUdDyY3K8QmAze8wkfd8gGqfINih7QR8anKGGrC3EPAWdgmdO2nae9nThjgm+/NAtYnPq7yFJcZ1om/nb+v4NuU5RnveDiib8EwoI3kG+Afjqhc6FhEGgveJcrQ9VYBI2JDMy8CvYQMPtyyYy9U9azpsfo5Zce2dUjDKBbbsUd5pQTHE9TEIR74T8zYbcZmXKcgMTvclRFM1aYpnb8VvVv/vkwmfFhMc4LDuedjKrJE9+y44VZbfWv/mVslkFkIaLs/JDY6YsKRCGcSYJW4eQ3W/ypNYgG38OAZytqllWwmIntjp5nWenIctwoWqI2WcBtmAv/PPZYlwU8ZcgLu7yiQkbk4vYgwDQmAYuzg0OMusq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 16:48, Lorenzo Stoakes (ARM) wrote:
> Rather surprisingly, opening /dev/zero read-only then mmap()'ing it
> MAP_SHARED gets you true anonymous memory (albeit in a VMA with
> non-NULL vma->vm_file).
> 
> This is a by-product of MAP_PRIVATE-/dev/zero being how anonymous memory
> was mapped in Linux's distant past.
> 
> It happens because mmap_zero_prepare() gates on VMA_SHARED_BIT and when
> mapping a read-only file MAP_SHARED, do_mmap() clears VMA_SHARED_BIT and
> VMA_MAYWRITE_BIT.
> 
> The gating is incorrect - the (poorly named) VMA_MAYSHARE_BIT flag exists
> explicitly to tell you if something was originally mapped MAP_SHARED.
> 
> So the fix is simple - gate on this instead.
> 
> This isn't exactly a common use case, but it's unexpected behaviour which
> now causes an assert if CONFIG_DEBUG_VM is set.
> 
> While this bug has existed since the dawn of time for linux (or at least
> since 2.6.12), it hasn't caused issues in the past, so while it's incorrect
> behaviour, it doesn't seem necessary to backport that far.
> 
> The mapping is now accounted at mmap time and can fail with -ENOMEM under
> strict overcommit, and read faults allocate folios. However this is normal
> behaviour for a read-only shmem mapping.
> 
> Commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE
> file-backed anon folios") is the first patch at which the debug assert
> fires, so target that instead.
> 
> Fixes: 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE file-backed anon folios")
> Reported-by: syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/linux-mm/6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  drivers/char/mem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 63253d1de5d7..5b93c92c2cf1 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -503,7 +503,7 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
>  #ifndef CONFIG_MMU
>  	return -ENOSYS;
>  #endif
> -	if (vma_desc_test(desc, VMA_SHARED_BIT))
> +	if (vma_desc_test(desc, VMA_MAYSHARE_BIT))
>  		return shmem_zero_setup_desc(desc);
>  

So instead of shared zeropages we'd now get zero-filled shmem pages.

The alternative would be to just convert it to a proper read-only COW mapping in
mmap code:
* Not clearing VM_MAYWRITE, but keeping VM_WRITE clear
* Clearing VMA_SHARED and VMA_MAYSHARE

Sure, someone could then mprotect(PROT_WRITE that thing) or
FOLL_FORCE|FOLL_WRITE to get anonymous memory. Just raising that as an alternative.

-- 
Cheers,

David

