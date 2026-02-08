Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B08DEF06E3
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 09:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E10B66B0089; Sun,  8 Feb 2026 04:55:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBED66B0092; Sun,  8 Feb 2026 04:55:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0A36B0093; Sun,  8 Feb 2026 04:55:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B93CC6B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 04:55:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6BA5013B151
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 09:55:01 +0000 (UTC)
X-FDA: 84420830802.20.D587169
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BFD3FC0004
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 09:54:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CWSbWdyb;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770544499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xx51/K0P6tvgFkamMYkM2jr5OWpcr9R9PsgGKwbs6c=;
	b=5M6tjmXG3UQ2ONMHXZXYnGRilQeT2cK5C2dY0ZUX/O9LE9j/VW/dVzjuUe4xU4g4xkJKzM
	8QRvCbwlBFvhacm4aZtuLuAeii0Gw73Zoer43h5TiBn4MAZ3u04pDOiWCC5NYChSNvquR/
	OPjNQzHgSAJSgkEqO0nzy6pxejN+vqk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CWSbWdyb;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770544499; a=rsa-sha256;
	cv=none;
	b=MQ+Cm/Opoc5p+YALcl5OIPkGPiq9QTvsT0oevlCs/Fj1CUg9xN8sAreA+ikCC4oKcjqt7t
	nEoK9jYcVUWdZciS+Gbc+L9duiYgkLPnzWErcunAS397esPv20UWxk95yjLR2SKqaNxa1q
	WhvppjUMX0+gKjdENjWgvV+bYXVlWZw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8771443A81;
	Sun,  8 Feb 2026 09:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B95C4CEF7;
	Sun,  8 Feb 2026 09:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770544498;
	bh=VAJOqVbp2qDpQlX5+DAiOZoQgjFgIQczf/wGGbbFMDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CWSbWdybgY7UKB8egp0AumFhSehROCOkw9ZwBvyaB6Cr22MlGdRfkppkARTv7xewS
	 CpHNebSqqlIlT+2SLxibHqkFfNvB/3ZZdew3XlQvCFNnuqqPmhBfuFp7R9CySFXrfm
	 298DS+S+pzIs5+sr4C9vPi49Cy65bixVDgtAu9fri2TmVXOjSpVLLVq0g1xGb3KAy/
	 cxKSP6KyriklgEyw6h2yYqJ1VyqiJTYr+y0Dlp7/qYd+3DvUc5p6FSoOtF1xV/oNnk
	 p+S/n7dVe31j+VtH3WAvWIKC5ZWWfkwmqRMyDS3y1ZOJQLH2kXNHqk0KZGtvpD/W/h
	 eGXZnCMt9eVXA==
Date: Sun, 8 Feb 2026 11:54:47 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 04/17] userfaultfd: introduce mfill_get_vma() and
 mfill_put_vma()
Message-ID: <aYhdZ_fOrkmAsSEX@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
 <20260127192936.1250096-5-rppt@kernel.org>
 <aYEb1RlGWBJWKXNg@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYEb1RlGWBJWKXNg@x1.local>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BFD3FC0004
X-Stat-Signature: 3zk1frfg4rzg5kchoiyp7cxg6uh935es
X-Rspam-User: 
X-HE-Tag: 1770544499-986937
X-HE-Meta: U2FsdGVkX1+F1eRCbxFeuD5bIngVguT9J9M93fK+SogE2vzeJbJnfBFskatt7jOacUfC8EIf+W3RGdu5Pmd8DQUZG4xb34pkmeNGHCEgegY/7yg8KO/SK+o7qZaE8Fpk+rYy/rojwbazNjrxGyNEZurQCzffyz40l/XXd3WaNuNn1/3R7h19u1fz9JBxkStrmU142Nw7s3/EfW9R7XD6K5xZE7XAfQ1652HBmqzq3ZykLrkvtxkxNR1S3lmymB4ymfp/swiBuYhNk1yIeBz3DLezjjTuEEU5Q23pDk1xpnnFyG7hbmJFeJPM5rcQGd4+QW/Rc5Wf4yAAQ0ZTbyVMcdYT9sgHJIps7j7GcjhLTtxf0IsLA7EH6ZCFSHU3EWaYEQlNQxap/YvPcONuyZg+mEAZIbLSVgGdKBQibWB72ru4kCJ6IwPGd1YynHF/LXRCI8hxEfWpupUqghEoHH67RLx+gkn25ZKwOXNxW084DsiPeDm63j3y1OeEpOlETi8kyi6YA5Hu9UhE3P/UsHjwVoO1YQmftshRr9E2iyDC6Ypd/XLCuYtXbjeE+DTC0OJPXh+Lx/9mzh9XUbads+3zNulmreQ6SuxRMyubqhxwtaCPYL5nS4rcpHd4XQg329SJG36mkHlei1PelbYeicPpWNu4h0oHul0CoD9eAbS1y1k19oQIm2QLtPPYn1lLZswIghfT4kkViyZtQkYHnSU9VIKXbi7OrJgtROy+4FYVJ7y1e3EaogUh/ylXadkh3V5U5kIxSrVdbjRUn2Sm2E6xOieaCnA9vMkCDV4WzNnPTw2YNySdLJWwcGCcU2uSV/PVlIdoKw91kwwkxwfjRJPqpNd4wLzGyseIjveX0CAIGJW7Y9TYDDuh2CLYwGMyN4OWwEjmQ+dDcfYSjsDMTZRXx/4Q5TqkJ4whjrwPa9yGoIoZUqL2Gai7w11hTglLGzXzS/CMdCu/XOcd9cjh3xV
 aO1x4Jk7
 ByK1MtY8O1OfkdftZyAjp4HcEEvl3r7j+rdobJpNdun4DqOXxpz0DAT48Us/FZT/72ePka1HUfiARV174fK6AfQ6/2KrE6wTlg7aeQJ8ZEuG2hnECsLC1CH84i9uutPqeNBrKXUiiH7SDRzod+OPsf017V+3yWe4T+lG/Af9I4GUfCPumZZJTOmtBKIPJqoBdZ9/nTezvJv52OpPuYJpatYXdwstGopTPgKXSbG7XQzh8aAaLypKEPr9lUU9FbXgKW7+ItyTRahA6PfMnR0pnOZinzZAPvey7rDS7WuHsof5Vysxl/HPYpDp7KoAieOcPINRaCta69yysfLU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

On Mon, Feb 02, 2026 at 04:49:09PM -0500, Peter Xu wrote:
> Hi, Mike,
> 
> On Tue, Jan 27, 2026 at 09:29:23PM +0200, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Split the code that finds, locks and verifies VMA from mfill_atomic()
> > into a helper function.
> > 
> > This function will be used later during refactoring of
> > mfill_atomic_pte_copy().
> > 
> > Add a counterpart mfill_put_vma() helper that unlocks the VMA and
> > releases map_changing_lock.
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  mm/userfaultfd.c | 124 ++++++++++++++++++++++++++++-------------------
> >  1 file changed, 73 insertions(+), 51 deletions(-)
> > 
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index 9dd285b13f3b..45d8f04aaf4f 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -157,6 +157,73 @@ static void uffd_mfill_unlock(struct vm_area_struct *vma)
> >  }
> >  #endif
> >  
> > +static void mfill_put_vma(struct mfill_state *state)
> > +{
> > +	up_read(&state->ctx->map_changing_lock);
> > +	uffd_mfill_unlock(state->vma);
> > +	state->vma = NULL;
> > +}
> > +
> > +static int mfill_get_vma(struct mfill_state *state)
> > +{
> > +	struct userfaultfd_ctx *ctx = state->ctx;
> > +	uffd_flags_t flags = state->flags;
> > +	struct vm_area_struct *dst_vma;
> > +	int err;
> > +
> > +	/*
> > +	 * Make sure the vma is not shared, that the dst range is
> > +	 * both valid and fully within a single existing vma.
> > +	 */
> > +	dst_vma = uffd_mfill_lock(ctx->mm, state->dst_start, state->len);
> > +	if (IS_ERR(dst_vma))
> > +		return PTR_ERR(dst_vma);
> > +
> > +	/*
> > +	 * If memory mappings are changing because of non-cooperative
> > +	 * operation (e.g. mremap) running in parallel, bail out and
> > +	 * request the user to retry later
> > +	 */
> > +	down_read(&ctx->map_changing_lock);
> > +	err = -EAGAIN;
> > +	if (atomic_read(&ctx->mmap_changing))
> > +		goto out_unlock;
> > +
> > +	err = -EINVAL;
> > +
> > +	/*
> > +	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
> > +	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
> > +	 */
> > +	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
> > +	    dst_vma->vm_flags & VM_SHARED))
> > +		goto out_unlock;
> > +
> > +	/*
> > +	 * validate 'mode' now that we know the dst_vma: don't allow
> > +	 * a wrprotect copy if the userfaultfd didn't register as WP.
> > +	 */
> > +	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
> > +		goto out_unlock;
> > +
> > +	if (is_vm_hugetlb_page(dst_vma))
> > +		goto out;
> > +
> > +	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
> > +		goto out_unlock;
> > +	if (!vma_is_shmem(dst_vma) &&
> > +	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> > +		goto out_unlock;
> 
> IMHO it's a bit weird to check for vma permissions in a get_vma() function.
> 
> Also, in the follow up patch it'll be also reused in
> mfill_copy_folio_retry() which doesn't need to check vma permission.
> 
> Maybe we can introduce mfill_vma_check() for these two checks? Then we can
> also drop the slightly weird is_vm_hugetlb_page() check (and "out" label)
> above.

This version of get_vma() keeps the checks exactly as they were when we
were retrying after dropping the lock and I prefer to have them this way to
begin with.
Later we can optimize this further after the dust settles after these
changes.

-- 
Sincerely yours,
Mike.

