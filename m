Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE061C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC33E6B008A; Mon, 24 Aug 2026 03:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B426B008C; Mon, 24 Aug 2026 03:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB11F6B0092; Mon, 24 Aug 2026 03:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9282C6B008A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:11:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9814B1C1A47
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:11:41 +0000 (UTC)
X-FDA: 85135292802.29.4AC4F78
Received: from mta1.migadu.com (out-220.mta1.migadu.com [95.215.58.220])
	by imf11.hostedemail.com (Postfix) with ESMTP id 49F8C40009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:11:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BBiXNL4l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.220 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787555499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qagM8IIgCZ7aJYQi+BKjP6Qu+js1tt3mZZIHl8joMTg=;
	b=HIFAFIB8KnhARebS7DwzWjXb+Lxr9hHKsw/zSpxFJhyjxlEaOViNITta0n1S72YalW1Ak/
	8PkovzIjSfPcYddecJEERajRn1hdmaeGKegK+7YoYAb8nJyD1CZp8jP77hHchkCCzKefQE
	TOjvQPpDRTQmDa/Idz/GTaxdDzhkk5s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BBiXNL4l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.220 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787555499;
	b=6/73FUNnQpBcy5DqNSiYIR7tGYmjovHnEAMqqKABl4PxoDDUfKOZTStNI4EjAHJns6NDcg
	rK5wRMWdXSFbXw60b4SKf71KiZoWiYnGJFDl515W6PsnsRdAGyqw/zXAj+F52+JKlSl78E
	WkcQUfZZGAqXZuuBL4VEGy59Ajs9xhM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=upHHen4ux8L9irT5wAQCPUOo8cd6TtLi7blsQg4Qp0c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787555497; v=1; x=1788160297;
 b=BBiXNL4lNREsQ2300oMM+gr2YknnB9p1+MuIdmYBJamkt9iNgJYESP2ang0LIez/h3JLyx5F
 axQqA/FmBM/eA1KsGNvZQkK9FEz9pcH1QOUTMEPpNq5KsU3KKIwRfT/D+oO+iwFLMi+SF/r+w9h
 tt+Q+gJvYFqEsmwROXDciLSo=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id bf7ef9951ffd2d20;
	Mon, 24 Aug 2026 07:11:37 +0000
X-Mizu-Trace-ID: bf7ef9951ffd2d20
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: rppt@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	jannh@google.com,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	corbet@lwn.net,
	liam@infradead.org,
	ljs@kernel.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	nico.pache@linux.dev,
	osalvador@suse.de,
	pfalcato@suse.de,
	peterx@redhat.com,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	skhan@linuxfoundation.org,
	rostedt@goodmis.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 6/6] userfaultfd: collapse VM_UFFD_{MISSING,WP,MINOR,RWP} into single VM_UFFD
Date: Mon, 24 Aug 2026 15:11:26 +0800
Message-Id: <20260824071126.41979-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-6-3086981b33cf@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-6-3086981b33cf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: my37e31auidyjg9fm9mmms6u6eutsxw6
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49F8C40009
X-HE-Tag: 1787555499-89768
X-HE-Meta: U2FsdGVkX1/oKXU9XJ3Y6o5AuN8mWDyqxvOPv5JWorZE3GgEi5rEnHSvJsz8adn51MCJIIHveyWdkiPYwZoatvV+mXn9M6GNUSsb2zVjbqhEv7WwN2aUK5suh+/DfryiSYWGu98JRpZfgoEM06O+oNIXxhuugNDJRYaijsj2v0CX6udD1uo9XYOy5CiImEsD7AxwJb2mGHlxcayjPksTJfzEw16b4mZZa5eBZVGgdlmT4MOEpTKCF+rW3u4mQOZjnq68yB8PlSx3AO1eVdegMhy9bJZ1kW/NoUowCc5eCXpVJjnJ4WCDzeos9/Fj/XqyVkn6Q53ADxJx489GFErocoDLhdu5LJ8MuyjIv3ZSPVBan5Lblesz5vBbUF9QYP9hgOVi1s86NSNz36buODu9hBQkdoVxi5arEgFsu50XayOEZ+Hxkjc9WrglNK4uVhFrfMAv1mwFltUAxTAx3WKK8agia+4tSYydwu/vsFT6pmJgu73Sp1Lxy+K67rTp3QR0a9H6dAAjBRpC4V8JaRG5rV1oGJOOnwle+JK76GXbGGjd9tQGDNujciLg+tHxUyt1pARSbaGK0ToOlj5D+57JbSOLfMGPfrq5RLYiXChSU7QyrthAqIbJilnawiPmhgxX4FJoiNmKzgZ5dlqRweGHyl6r8TUB86hVkFjfcq5Gn+3aexs+IKqHFM+EFMxzMkfN8RyijMIP+L4iXSpLufZEIWhk6tkg/JaidNYV6yWnrHdn6S1csTMlNll0G2YxxxyOPxaksLy9EatWlKQBuckaA2eQNsqJ+/kD84lGgSLyXzJ42jxDM622jpd3ASYbaOUGf1OF787Of4m145CN5JZR1VIG3/3lK6Rw3V7nHMgxWKOzhWJ7pzTeLpsOB0YdcF2dSoeCZrwM+kT82HMDJH/lYaPa19ag+JHwbwZ50tGhUmRJsVSBMrOK9Ga+PsN8omcXkTbvtb01sA/uX9DP4aZ
 14l2ccxX
 uWRo0Sy/7L5qz42CLE3arIYvK40ThpCIMAFx7SGgLahJbpmnUQ4uUy+JhEQ1ZlpVvxpfSRt1/4fgkGPuG5MsrzeGev3ZC1EUbD2vNlD4B0dRvuWj5MFpPnLzQ5675VkM/iCmhybNZRH6fTu48xz/Sl61C5gRR1SSJEYd+wWHizjs+EQhU1CBwhKrwFWbY0I7CLPPGzEUdMTW/ucfjbEs2vZKyslfK7gZhFe/vZHdaG2939ewdbQk24deNXFprqBhVtqbp66aOyuvz1VHDIJTGG/YGUEqqw3CYemhHHYw4RScsHMA+OECaYchimV+zc5cEoIuJR6nJI4ac7/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, Aug 23, 2026 at 03:17:43PM +0300, Mike Rapoport (Microsoft) wrote:
[...]
>diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>index 83587d34b189..193f6e65d875 100644
>--- a/mm/userfaultfd.c
>+++ b/mm/userfaultfd.c
>@@ -50,10 +50,10 @@ struct mfill_state {
> 	pmd_t *pmd;
> };
> 
>-static bool anon_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
>+static bool anon_can_userfault(struct vm_area_struct *vma, unsigned int mode)
> {
> 	/* anonymous memory does not support MINOR mode */
>-	if (vm_flags & VM_UFFD_MINOR)
>+	if (mode & UFFD_MODE_MINOR)
> 		return false;
> 	return true;
> }
>@@ -462,7 +462,7 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
> }
> 
> #define MFILL_RETRY_STATE_VMA_FLAGS \
>-	append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)
>+	append_vma_flags(VMA_UFFD, VMA_SHARED_BIT)

Looks like this drops registration mode from the retry snapshot. Assume a
shared shmem VMA is registered for MISSING and COPY reaches
mfill_copy_folio_retry(). While locks are dropped, the same userfaultfd|
can re-register the range for MINOR. VMA_UFFD, VM_SHARED, ops, file and
pgoff all stay unchanged, so the old COPY can continue instead of
returning -EAGAIN ... no?

The snapshot and comparison bracket the unlocked copy:

static int mfill_copy_folio_retry(struct mfill_state *mfill_state,
				  struct folio *folio)
{
	...
	mfill_retry_state_save(&retry_state, mfill_state->vma);

	/* retry copying with mm_lock dropped */
	mfill_put_vma(mfill_state);
	...
	/* reget VMA and PMD, they could change underneath us */
	err = mfill_get_vma(mfill_state);
	if (err)
		return err;

	if (mfill_retry_state_changed(&retry_state, mfill_state->vma))
		return -EAGAIN;
	...
}

Since mode now lives in vm_uffd_state.mode, could we save it before
mfill_put_vma() and compare it after mfill_get_vma()? The UFFD flags
comment also needs an update, since the mask no longer contains per mode
flags.

Maybe something like this?

---8<---
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 193f6e65d875..5e3c86fe8aee 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -493,7 +493,7 @@ static bool mfill_retry_state_changed(struct mfill_retry_state *state,
 	vma_flags_t flags = vma_flags_and_mask(&vma->flags,
 					       MFILL_RETRY_STATE_VMA_FLAGS);

-	/* Have any UFFD flags (missing, WP, minor) changed? */
+	/* Has UFFD registration or VMA sharing changed? */
 	if (!vma_flags_same_pair(&state->flags, &flags))
 		return true;

@@ -528,6 +528,7 @@ static int mfill_copy_folio_retry(struct mfill_state *mfill_state,
 	struct mfill_retry_state retry_state = { 0 };
 	struct mfill_retry_state *for_free __free(retry_put) = &retry_state;
 	unsigned long src_addr = mfill_state->src_addr;
+	unsigned int saved_mode = uffd_mode(mfill_state->vma);
 	void *kaddr;
 	int err;

@@ -549,7 +550,8 @@ static int mfill_copy_folio_retry(struct mfill_state *mfill_state,
 	if (err)
 		return err;

-	if (mfill_retry_state_changed(&retry_state, mfill_state->vma))
+	if (saved_mode != uffd_mode(mfill_state->vma) ||
+	    mfill_retry_state_changed(&retry_state, mfill_state->vma))
 		return -EAGAIN;

 	err = mfill_establish_pmd(mfill_state);
---

Cheers, Lance

