Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B231061B1B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D4C6B008C; Mon, 30 Mar 2026 15:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814C26B0095; Mon, 30 Mar 2026 15:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A156B0096; Mon, 30 Mar 2026 15:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 621896B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:38:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F1BC0E0B4F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:38:52 +0000 (UTC)
X-FDA: 84603742104.14.B97D31B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id C4F731A000A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:38:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W2K0WkSp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774899530; a=rsa-sha256;
	cv=none;
	b=PXDK+keJPC7em/I+Bvc8xJxzFa2WveUqEgCxvrBm3meih6T6KXdy/lNmLfcg7sb+tXE71a
	QRF5M1bgZPpeLHycQcsTe5P2DVk+ELx5AsG0B02a48yOv4g6XQpUZmu6E4Bs95NoW9zK2+
	3eWzqt9D5YIB+B16WrJgt0Ibtn9RdJs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W2K0WkSp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774899530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0GrCWjFJdwivrglfaRGY9APiPoMwEIvIsexr/luwWs=;
	b=LpThyjtXKEfuMDyzxyiSTB39lBzmD9s8OLOlTjDgKbRbQv+R9wTRiTMBzXWMdncCl3uU0J
	dSyUMn7a5mtLf0UZ2iQXyr0cLof0FhSnz5qzdBCTKFCAMGjhY8EyfVOFa8pEyB4lMNWKag
	YOU7sxnRLPzKtonkVumXEMuj1hzYwYs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774899530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b0GrCWjFJdwivrglfaRGY9APiPoMwEIvIsexr/luwWs=;
	b=W2K0WkSpEm7GmoeZHviI25q2yVb4QYCrswzgu9pA9VKJJkWIbpmq/R9pkzaHY7X07jI2Gh
	ENrbiQk2XGc7WFswDLYWrqoTfDUav4bTSQFRcs9MyUGmrj8qgDDpBtPgEky/FoAWs2W/Cz
	n0A/LJrWK9nWyu4zdsq/V+/Q6fSq09g=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-KRBXgyrfNsG7qNxYJ5oT5g-1; Mon, 30 Mar 2026 15:38:48 -0400
X-MC-Unique: KRBXgyrfNsG7qNxYJ5oT5g-1
X-Mimecast-MFC-AGG-ID: KRBXgyrfNsG7qNxYJ5oT5g_1774899528
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-50b4987c698so94353581cf.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:38:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774899528; x=1775504328;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b0GrCWjFJdwivrglfaRGY9APiPoMwEIvIsexr/luwWs=;
        b=E6mFOr80Aj0TqXiUY4mPI14OLkESK9CxRdxrVBCeMAhg3Wn/mTe4Fa4fX5C4kFs/lD
         OFstbibPdnNOrQXbMtQDFdZ63utoCF4HcT9+iQeXlZqYTkoA8byCxTkID2TmplFm5mMb
         pxCRMeP0jQLAPKd1ewbT7m/Ms9u9V988sQP+HFen5RQbH5GBw90b7ctunvWv9BKMZBM3
         EO+O1tUmwCc6xbnPQm2qW0Gw8I/UG1KOmohNpe0WRcbeuG3yDXsjQQTKJDZHJVh+REAw
         x6yMHMhE0flWB2d3/2qR8YapZdoMtkT4WeevooPeEE6eAYt1ERt9vrhIf9MoOt7+0kQ0
         NnTw==
X-Forwarded-Encrypted: i=1; AJvYcCXg7XreWhz1TV0AT87lbUkdfx9vroJOj6pFCSU77LEuMHmT9rKfJB7CzSLjPnOtIDS1UXF7FfVqAQ==@kvack.org
X-Gm-Message-State: AOJu0YyoEqjhnJYTgo0J5E5mGZGhhn8WmANntRr1YLV+jEgG5MLKQ4s+
	t69COxPAZ6QOKLsGayLePmV6dm80osYyPDT+e+j3h6qVEaVQggUsZUHw/8meRsFFzGqSd1iCA8d
	CsnRBeNE3atiRVK6YVb/74Ft1CeorSB9ysG5A4nAHdxJ9XVx0v/91
X-Gm-Gg: ATEYQzwucdg2JAJKKkPTKRAkzD+iO7E1EAhlm/7nkB97NYlSBQzK+hh3ypd2AZ0zdWc
	ezR1G8Y5/9DZLxXGEmWK8JrtwGAUTaAnBOgDS+aN7KpFhBscG3+msyMv+xiNH0Xbh4Q8lmMPcuy
	y6uT37dA66J7QOLwRdNzCbayKKYeRYWhe2Jp/CS6W2/RCpMsl+4VUb0IRbbsQUyuk2qb1nfqDLQ
	hNBQe/Vk+hSI6eeIJKp699+y9IzqcBj03z3k9qPndxArl9vung4sGi42zjQYY8VJ45o4etiSm2U
	eotkghigcTzSCjp08j1OkFz1Bcow5jn6B/hrZKjQFFUx4ExyyulxDNu5EA7aV620pZbIr/B6oHZ
	JyRj/nKOAgUEclA==
X-Received: by 2002:a05:622a:618c:b0:509:1523:8b07 with SMTP id d75a77b69052e-50d2c8d6329mr10386391cf.25.1774899527973;
        Mon, 30 Mar 2026 12:38:47 -0700 (PDT)
X-Received: by 2002:a05:622a:618c:b0:509:1523:8b07 with SMTP id d75a77b69052e-50d2c8d6329mr10385981cf.25.1774899527444;
        Mon, 30 Mar 2026 12:38:47 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50bbf69fee9sm56760151cf.30.2026.03.30.12.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 12:38:46 -0700 (PDT)
Date: Mon, 30 Mar 2026 15:38:45 -0400
From: Peter Xu <peterx@redhat.com>
To: David Carlier <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	James Houghton <jthoughton@google.com>
Subject: Re: [PATCH 1/2] mm/userfaultfd: fix stale ops and VMA type mismatch
 after copy retry
Message-ID: <acrRRRT1xrAqNraj@x1.local>
References: <20260328170101.184163-1-devnexen@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260328170101.184163-1-devnexen@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jfMjLQQ-z42GsbmgMRows9vU015kZBZPdzeccCV16lk_1774899528
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: C4F731A000A
X-Stat-Signature: utk3mcqo9e8ahn1r5n78y3rm4dogr8gw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774899530-219651
X-HE-Meta: U2FsdGVkX19M+NewmchC/QhxxV/s/qnKlu9jztTIZVr2dhB800NBaqmPzB08Lxs1lw4snQCyqbGOv6nM4TEfk5IDW1/Vfb8trY24BoAoo9XztAdHO+fUae/XSs18uub30T71ieLBuFtuFjYMPHhveLPhJ/wNkI0p3+BgxENDgMcLaT9gio+VUI7lujGzvMLU2i+9tBaftUwQx+pFvO6DD4xgbzkfJ3f11XrfwFziPf/zm1kb/W7KxxJVpAMyajdGAiezuDF4mw2MBBg64bhiHeNGJQGlUkfEFcvJQH1ZDlSjxHsAROC4rlC6Y4JrmhNmNiVK1DPMh28MVcsdH24/5eAJDLPr1HEAD6dKfcQZ3+85rNfIVIVp9fMK2usNN7VqQRTAWqkm95JdDdG3xcxUdBr+RXGZrGEsoSDyrQ7+hK+tJT33Zy6bw0Ji3yZHm36hgIUmKQXBOtWY7g3yzL6LcJbcjPNOobkTz+jxlJSTn5JmNcM8BppbfByXGH7H9DAN4KQ+6/qZ/5VrAORmaEaOSMMnDpp1DJJ/KFbMO5aiWyN5XfX8pJ6ELFolnNNY+q6fvLs1ruxbZmrP5cMTLhxhxXmELlYGiKBpg124m6Ey9qdTuYQpNEkTS2T9Bz44Kn5uzHhTOzlBSZaqJnoMLZ+KGDL6Zvskh2rD0lANDR+5WrJUFRAnD2Ya4F+QinlzZ2lXhyxk3VgGFNHehZPGvBSFc927a0Wtol3z8AVq8KGrUdbN2J4bzK2GTBo73Hkq7VEBmREp1EpmNhE5tOFdNgMAvyFLGA76kQWU8pQFGQ8oTtYl2jMQgvaefGaOZ6ZVtZ/sOdDq3wNW0B+m76078FJLRxJ3DpA54QuOIgKarbhKjUPiEsyK6r0dCfjTD4SXJgH/ii3t16cb0aRtD8tnj2sayTw8QsA9KUKHAh7DzXSt3OXnOeWSLEKzNGrIKnv1QJblPmFd02QiylLBoZMIQT0
 cRgXDChP
 YcBG7WjWpft9WmNBYKhOL5Fl6UlxJqfnFMBxzUvLUcw6axCC2QFcjKHRu4n0MmpXMubZ8VYhDj6CYyMgOFyrf04XHG2HjNDBi5GSJ75s62fuWb6U+EcJX3s9FJtke17Ah0iWjFv1sYsjICLQmQbfI2fXrRUEBxR2RUKYZ8GjkmbxiF3fIsdBw5OZV/qMpceWLK16TtQ/zeYRdJubMNOHYcUGqCxUfFP6CqJo5jao8bE+QRdAXi4w8ILvmyhAilYlG+oxDICoDYKIzYLC8mCTUeQTJQLG2Kai5INRTYPsYaejVXlA1cIwiqHXOB4M2YxRPPtJPXr3KU/iARszGdhMuAQ9f/wlTMvn4ji2VLZuugoE+zJ5IiZhbGOu1unPy/crQlI9FqR0OL7RZfYDHJhESBveEFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, David,

On Sat, Mar 28, 2026 at 05:01:00PM +0000, David Carlier wrote:
> In mfill_atomic_pte_copy(), ops is derived from the VMA once and passed
> to __mfill_atomic_pte(). When the initial copy_from_user() fails under
> pagefault_disable(), mfill_copy_folio_retry() drops all locks, performs
> the copy with page faults enabled, then re-acquires locks via
> mfill_get_vma(). During this window, the VMA can be replaced entirely
> (e.g. munmap + mmap + UFFDIO_REGISTER by another thread), but ops is
> never re-validated.

Thanks for the report, this seems a bug indeed.

> 
> If a shared shmem VMA is replaced by an anonymous VMA, the stale
> shmem_uffd_ops->filemap_add calls shmem_mfill_filemap_add() with an
> anonymous VMA, causing a NULL pointer dereference at file_inode(vma->
> vm_file) since vm_file is NULL for anonymous mappings.
> 
> The mmap_changing guard does not fully prevent this because
> userfaultfd_unmap_prep() only increments mmap_changing when
> UFFD_FEATURE_EVENT_UNMAP is enabled, which is optional. Without it,
> munmap proceeds without any signal to the retry path.
> 
> The copy_from_user() in the retry runs with page faults enabled and can
> block on slow backing stores (FUSE, NFS), significantly widening the
> race window.
> 
> Fix this by:
>  - Validating that the VMA's userfaultfd context matches state->ctx in
>    mfill_get_vma() to detect cross-context VMA replacement.
>  - Re-checking that vma_uffd_ops() still matches the frozen ops after
>    the retry, and that the VMA is still VM_SHARED when ops expects it
>    to be, returning -EAGAIN otherwise.
> 
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
>  mm/userfaultfd.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 481ec7eb4442..2a6e034b15aa 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -225,8 +225,9 @@ static int mfill_get_vma(struct mfill_state *state)
>  	 */
>  	down_read(&ctx->map_changing_lock);
>  	state->vma = dst_vma;
> +
>  	err = -EAGAIN;
> -	if (atomic_read(&ctx->mmap_changing))
> +	if (dst_vma->vm_userfaultfd_ctx.ctx != ctx || atomic_read(&ctx->mmap_changing))

This is a valid and good check.  Though IMHO it doesn't need to be in the
same patch as a fix to the bug reported, likely it suites for a separate
patch.

For example, a new VMA (as you described in the case of when the bug can
happen) can also be registered to the same userfaultfd ctx, and this check
won't help there since the ctx will still match.

>  		goto out_unlock;
>  
>  	err = -EINVAL;
> @@ -498,6 +499,12 @@ static int __mfill_atomic_pte(struct mfill_state *state,
>  			ret = mfill_copy_folio_retry(state, folio);
>  			if (ret)
>  				goto err_folio_put;
> +			if (vma_uffd_ops(state->vma) != ops ||
> +			    (ops != &anon_uffd_ops &&
> +			    !(state->vma->vm_flags & VM_SHARED))) {

Hard-code this (out of mfill_atomic_pte_copy) is very likely not a good
idea..  Meanwhile I also feel like it won't completely fix the problem.

Consider the changed VMA is not about shmem VMA becoming anon VMA, but
shmem VMA1 becoming shmem VMA2 and both of them can even have the same
flags.  IMHO in that case we should still fallback with EAGAIN because we
still hold a folio that we got allocated from VMA1 (rather than VMA2) here.

Ideally, we should check "if the VMA has changed at all", which will be a
very safe check, however I don't think we have any good way to refcount
VMA... at least not something I'm aware of.

A simple workaround here is we take a snapshot memory of the VMA attributes
and making sure that didn't change after the retried copy_from_user(),
assuming that guarantees the VMA didn't change.  AFAIU, the important bit
is at least two things: (1) the inode representing the backing store of the
VMA mapping (when it's a file), and (2) vma flags.

This patch below will do something like what I discussed above; that's the
best I can come up with so far.  Not sure if there's even better way to do.

Thanks,

===8<===
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 481ec7eb44420..caac1afabd520 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -443,33 +443,90 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
+struct vma_snapshot {
+	struct inode *inode;
+	vma_flags_t flags;
+};
+
+static void vma_snapshot_take(struct vm_area_struct *vma,
+			      struct vma_snapshot *s)
+{
+	struct inode *inode;
+
+	memcpy(&s->flags, &vma->flags, sizeof(s->flags));
+	if (vma->vm_file) {
+		/* We're holding vma lock, so file and inode are available */
+		inode = vma->vm_file->f_inode;
+		ihold(inode);
+		s->inode = inode;
+	} else {
+		s->inode = NULL;
+	}
+}
+
+static bool vma_snapshot_changed(struct vm_area_struct *vma,
+				 struct vma_snapshot *s)
+{
+	/* If vma flags changed? */
+	if (memcmp(&s->flags, &vma->flags, sizeof(s->flags)))
+		return true;
+
+	/* If there's a backing store of mapping, make sure it didn't change */
+	if (s->inode && vma->vm_file->f_inode != s->inode)
+		return true;
+
+	/* If not, making sure it's still anonymous */
+	if (!s->inode && !vma_is_anonymous(vma))
+		return true;
+
+	return false;
+}
+
+static void vma_snapshot_release(struct vma_snapshot *s)
+{
+	if (s->inode) {
+		iput(s->inode);
+		s->inode = NULL;
+	}
+}
+
 static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
 {
 	unsigned long src_addr = state->src_addr;
+	struct vma_snapshot s;
 	void *kaddr;
 	int err;
 
+	/* Take a quick snapshot of the current vma */
+	vma_snapshot_take(state->vma, &s);
+
 	/* retry copying with mm_lock dropped */
 	mfill_put_vma(state);
 
 	kaddr = kmap_local_folio(folio, 0);
 	err = copy_from_user(kaddr, (const void __user *) src_addr, PAGE_SIZE);
 	kunmap_local(kaddr);
-	if (unlikely(err))
-		return -EFAULT;
+	if (unlikely(err)) {
+		err = -EFAULT;
+		goto out;
+	}
 
 	flush_dcache_folio(folio);
 
 	/* reget VMA and PMD, they could change underneath us */
 	err = mfill_get_vma(state);
 	if (err)
-		return err;
+		goto out;
 
-	err = mfill_establish_pmd(state);
-	if (err)
-		return err;
+	if (vma_snapshot_changed(state->vma, &s)) {
+		err = -EAGAIN;
+		goto out;
+	}
 
-	return 0;
+	err = mfill_establish_pmd(state);
+out:
+	vma_snapshot_release(&s);
+	return err;
 }
 
 static int __mfill_atomic_pte(struct mfill_state *state,
-- 
2.50.1


-- 
Peter Xu


