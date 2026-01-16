Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E101C982FE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 20:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98076B0088; Fri, 16 Jan 2026 15:46:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58606B0089; Fri, 16 Jan 2026 15:46:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1AB86B008A; Fri, 16 Jan 2026 15:46:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A19C16B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:46:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A94A14025C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:46:04 +0000 (UTC)
X-FDA: 84339009048.29.AA95202
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf18.hostedemail.com (Postfix) with ESMTP id 441841C0011
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:46:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=normal.zone header.s=fm1 header.b=ipOHGeCI;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="n F7bx1u";
	spf=pass (imf18.hostedemail.com: domain of zi.yan@normal.zone designates 103.168.172.137 as permitted sender) smtp.mailfrom=zi.yan@normal.zone;
	dmarc=pass (policy=none) header.from=normal.zone
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768596362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SPM+Di8o83qZm/G1viX3w5UQo8dmbrCLtR+QmZaB1C8=;
	b=rATOTCGpuLdpeSfcJunRGjwXeNb9Z8FN3YcGqcLov7VAh8b2ODbH+eKva0U2S9R4EEuEeY
	xknAgfP+vMt40SPM4jvhxxpzFirDJQEKbP78wyn54+9LEOhM8gvHY5hHv6z95SAxZNplm9
	3H3MpIP9zFuTCE7VvT+XVx+FLIzyo6k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=normal.zone header.s=fm1 header.b=ipOHGeCI;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="n F7bx1u";
	spf=pass (imf18.hostedemail.com: domain of zi.yan@normal.zone designates 103.168.172.137 as permitted sender) smtp.mailfrom=zi.yan@normal.zone;
	dmarc=pass (policy=none) header.from=normal.zone
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768596362; a=rsa-sha256;
	cv=none;
	b=YBbARBcmH1XwLfZalTpDHNxLQlCE8tDDyw+DzeqEr5hRKK9ClYuAFF4VFpzv7QWsITIwGN
	Zfjkszma0YsXTKyWO2mjolS/lwP3gtl4DScRhxrb8xntuTgF6FW2MwFJsGSP+5t5Q6AncB
	UyVwxlFFQlR2W3Lp/kERhxY5rtEZosg=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id 8C50A1380232;
	Fri, 16 Jan 2026 15:46:01 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 16 Jan 2026 15:46:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=normal.zone; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1768596361;
	 x=1768603561; bh=SPM+Di8o83qZm/G1viX3w5UQo8dmbrCLtR+QmZaB1C8=; b=
	ipOHGeCI8vfuwbJ0G9BTZGmspdG4P5IZW3lUtHQErzD1F4wjLAuPb8DU+ryQ0qwf
	H6n0d8ZWSgcREtGtlFKruEN+XfdWRBDs8fHLyxvfmNCh489LMQuPiVIhCqOoG/DF
	PMKlLHINJRTL5RC3wwlhblck14xotvnfFX3AUIA2E7SEiG9t6J/mkrUSpXZNhTp8
	ukprLrMfdMAjQLNLBvHrmCr1doJf4W2IJKfPPPJ0oIOq+dcRy8dn1wKOZBa48M8l
	CGgZ9BFadQ4OiS5o0e19CnhCOv+XFHwUX3VYBRIZtpMGieOoeQHCnyBLyMh6FMRI
	dDCufjfWrkRvn30mvI2j1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1768596361; x=
	1768603561; bh=SPM+Di8o83qZm/G1viX3w5UQo8dmbrCLtR+QmZaB1C8=; b=n
	F7bx1uyakl60BRpwIW31+byfz4QrvE2o5vXuIUGy04BFX22PtWNq9A7URwL8mJ5a
	3i6bimYhvfsnKBiskrJEt5Ehsa2Hy0w1lE+cAG5hOKpReFpkR/bdOL0ToMJGy+YF
	CeBE0v/1FSnl4C0/MZp1vsXHWyT8XP/v5VpJUlCk+23zg+MGnzwikTK0ArV4tQ9V
	RXROaVf9JzHKdaEccWXNRcU/GP/WRbtkZoNTYxHvRxY6aJdcciac6TTQ+oCLRPO9
	jy9MeLs8howzDy8Jndjtw11VT2iVUd93TtEN8FYP8kQKi22XScgc2TLgujPT/JFZ
	FglKAIVnAxt3dJkNiezrQ==
X-ME-Sender: <xms:h6NqabjIlOuS08v6iqpksVNSe5Yc_cyNZ-kzhy0PVBK949vOrajCZg>
    <xme:h6NqaZV3IDKvfn-SRAnBv8R_8BT7dIk6qL9RbDWL1WzZwdZy1lWFd7hq-bke3XJn6
    T9_PhFMxt3sT5BLECbd6Nibfncc5wkENPQ4esWRB7tbzZXvISs6TjM>
X-ME-Received: <xmr:h6NqafvMzZGJkNVEeMHLPUn-pN5Cgo41CSMQnxDNgbKqwyzAnQbbXuMOLfdm5ZwEdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdelleefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffokfgjfhggtgfgsehtqhhmtdertddtnecuhfhrohhmpegkihcujggr
    nhcuoeiiihdrhigrnhesnhhorhhmrghlrdiiohhnvgeqnecuggftrfgrthhtvghrnhepvd
    fhffehiefgjeefgeegvdejhfejhfevieeiudelgfeuieetffdvtedvuedvkeefnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepiihirdihrghnse
    hnohhrmhgrlhdriihonhgvpdhnsggprhgtphhtthhopedvvddpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtoh
    hmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdp
    rhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmh
    drhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehs
    uhhsvgdrtgiipdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepmhhhohgtkhhosehs
    uhhsvgdrtghomhdprhgtphhtthhopehshhgrkhgvvghlrdgsuhhttheslhhinhhugidrug
    gvvh
X-ME-Proxy: <xmx:h6Nqaa9w6UYiI1ZIjUYzqwCSdTY8c9xxm8q_NF3woFiTKY_1q6hNCg>
    <xmx:h6NqafvRG9YRnbZjo598ejB-ABxCk5ZKRh1W02dGoZneqBSQ5PVAnA>
    <xmx:h6NqaQ6xUIFPlO6ZEJpEJRudiZfOHB5_rvCFO0ODvTOkygsfTdNWuw>
    <xmx:h6NqaYM6FMBx_lol5hidKvzPMzTQzYhNk1YZK54OLb4LEAJT11VEvg>
    <xmx:iaNqaWXCIF0d9tPUnNdvsTiEGS6kEVPoiMBGySDlNv533ItGc0TgeDfs>
Feedback-ID: i2b794257:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Jan 2026 15:45:56 -0500 (EST)
From: Zi Yan <zi.yan@normal.zone>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND 3/3] mm: add + use vma_is_stabilised(),
 vma_assert_stabilised() helpers
Date: Fri, 16 Jan 2026 15:45:53 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <2859A1AD-E37A-4575-B217-AF233F7A99A5@normal.zone>
In-Reply-To: <87b36e11c632fee6c965b944974d8dc4357b5904.1768569863.git.lorenzo.stoakes@oracle.com>
References: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
 <87b36e11c632fee6c965b944974d8dc4357b5904.1768569863.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ou6w8dyghuk3s7p5xr79nq5oqb8mjhdc
X-Rspamd-Queue-Id: 441841C0011
X-Rspamd-Server: rspam04
X-HE-Tag: 1768596362-501630
X-HE-Meta: U2FsdGVkX18fRouB+5v0/zLF9drE4R1JK6RlGKu9J4d5E//F6kXsSq7vQDFr6Pc+FsDR6gGIITLumww+Z8lxxxzO3K9k+TIDif+pzirBu6UlszHgof2kzvOkMIxzLImT/FzxgbTP/s4KGG/A+mPfdTMbFKmVJkz+SfkgD/gK6760MDDQkItGcIYBZhG6D98uqGCUjoBkYPOu8f1DLMmQsz47eruEQvfdLhF0b8Q9Hbp9YhCO1XgWhpTfxjyqPCnjmLYYx3Vn88pIagZN3Hb7H05T0KN41j1KywUX4w2HkX3ZcqfOvtYu77uU09J1Ul/3X/26RX1jc/LEHIvCkmeix1pdFI7TkeSUSi2+FJloaegAQ+8wUezZ/EHA7+LFXYn0SXRhb9n0AC9ZBpgDo0yuU9/JVZt2pLn37jEtWJDaQsMKOJ41pyGlKtgP8RjXF/4w0TSIsBNpRKc6gdgEY78p9J/LE9MkOie5chKjuL9ks9s7LKjIOzOyDtAsbuc5SEpBGv/Ye3J/EwLma4xJSP0YzUaK4dzFK6g3fh/+THCCZNZLwbe6OQS+H3Soem9zNRfhuKeitnX69PkdAbR2P1vgESOCVKoRPurDbpoLhk95pwRHbpsTm2p021GL+3vSjCVWJLQdyzff7mFeV/Yi188XMyvlXFl3gbX0EvRkajjvA+GfvS8MpDmqkfhUz0H/2DgIVeP15Sy0qgRMEgo4F3zLiU2m+RPHUDDwdU5z2Rxdy47lHECag7/Q7dDv09WFWWMR918MIlOK0q3ReMn2AAvvhuGXfSiteofOB94bfUtyQ+BTPg8fous87/CYfhwc/OHm9RyIj3AvaFhHpMw1krfSKFxJMvJoxxzUU7zjhIjiMK1o0P3AAbt4BZ5IpUScUEXkLlEwW3NALIXf/nneDgnEz+UP9INmKE/0fHTb/VgW3ma161gs8gaUnCXc7rSIHE5m4BHsN0cUXp+8/5uvCre
 AmbxAkUU
 h+5wVzoEu5cg+cFBCbzDW7/05Nzr8owF60fEpDXBQa7/cz5MWEX4oDlTF1kKEECzOfz/COn/RjrQCFuPILhPxU641q0nLtmj5NRSkWsRZtecHPBq+WGCGNsimG9elLSEP17P3MvK3swNlo73q/6aTn/VZp+DUrz0bQ9KlYKide+RX+W3miKQw+R06FTJaSbtlT4RIyyXL1p8b3N4xTKU5pTASHTVuGONlJI2eySaibGyw+TjucKgXdFF4+36Uob7mhUgqoSviWyZd6ZfDIyPME1pJ6TOxRtyyXHWn4lSydmCHAZlKJRrg8aqCDDQkL8Wr5wJAE1pwJZEILo+T4gMuWso0PjstSAdeaBtdcwHhLjg2OH/EEdlyLrXx/fCvp9RErIfZGTXoXVV3rSPb1uIpPE8W3nEPbFl5SYCcfBWFXh4QeWNOkR4O07+2YnUg05zXsnr4EODR5+E0N1NaFlzsITbv+3o/pfbKbmhhoAXyIGO1isKGSRDYQ6YeRydNLJlz9OmhiyPv+LlxImI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Jan 2026, at 8:36, Lorenzo Stoakes wrote:

> Sometimes we wish to assert that a VMA is stable, that is - the VMA can=
not
> be changed underneath us. This will be the case if EITHER the VMA lock =
or
> the mmap lock is held.
>
> In order to be able to do so this patch adds a vma_is_stabilised()
> predicate.
>
> We specify this differently based on whether CONFIG_PER_VMA_LOCK is
> specified - if it is then naturally we check both whether a VMA lock is=

> held or an mmap lock held, otherwise we need only check the mmap lock.
>
> Note that we only trigger the assert is CONFIG_DEBUG_VM is set, as havi=
ng
> this lock unset would indicate a programmatic error, so a release kerne=
l
> runtime assert doesn't make much sense.
>
> There are a couple places in the kernel where we already do this check =
-
> the anon_vma_name() helper in mm/madvise.c and vma_flag_set_atomic() in=

> include/linux/mm.h, which we update to use vma_assert_stabilised().
>
> These were in fact implemented incorrectly - if neither the mmap lock n=
or
> the VMA lock were held, these asserts did not fire.
>
> However since these asserts are debug-only, and a large number of test
> configurations will have CONFIG_PER_VMA_LOCK set, it has likely had no
> real-world impact.
>
> This change corrects this mistake at any rate.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/mm.h        |  4 +---
>  include/linux/mmap_lock.h | 23 ++++++++++++++++++++++-
>  mm/madvise.c              |  4 +---
>  3 files changed, 24 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 44a2a9c0a92f..8707059f4d37 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1008,9 +1008,7 @@ static inline void vma_flag_set_atomic(struct vm_=
area_struct *vma,
>  {
>  	unsigned long *bitmap =3D ACCESS_PRIVATE(&vma->flags, __vma_flags);
>
> -	/* mmap read lock/VMA read lock must be held. */
> -	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))

Ideally, this should have been converted to use mmap_is_locked(vma->vm_mm=
)
in Patch 2. But this is a bug fix here, so that churn is not necessary.

> -		vma_assert_locked(vma);
> +	vma_assert_stabilised(vma);
>
>  	if (__vma_flag_atomic_valid(vma, bit))
>  		set_bit((__force int)bit, bitmap);
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 9f6932ffaaa0..711885cb5372 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -66,7 +66,6 @@ static inline void __mmap_lock_trace_released(struct =
mm_struct *mm, bool write)
>
>  #endif /* CONFIG_TRACING */
>
> -
>  static inline bool mmap_lock_is_contended(struct mm_struct *mm)
>  {
>  	return rwsem_is_contended(&mm->mmap_lock);
> @@ -272,6 +271,11 @@ static inline bool vma_is_locked(struct vm_area_st=
ruct *vma)
>  	return vma_is_read_locked(vma) || vma_is_write_locked(vma);
>  }
>
> +static inline bool vma_is_stabilised(struct vm_area_struct *vma)
> +{
> +	return vma_is_locked(vma) || mmap_is_locked(vma->vm_mm);
> +}
> +
>  static inline void vma_assert_write_locked(struct vm_area_struct *vma)=

>  {
>  	VM_BUG_ON_VMA(!vma_is_write_locked(vma), vma);
> @@ -358,6 +362,11 @@ static inline struct vm_area_struct *lock_vma_unde=
r_rcu(struct mm_struct *mm,
>  	return NULL;
>  }
>
> +static inline bool vma_is_stabilised(struct vm_area_struct *vma)
> +{
> +	return mmap_is_locked(vma->vm_mm);
> +}
> +
>  static inline void vma_assert_locked(struct vm_area_struct *vma)
>  {
>  	mmap_assert_locked(vma->vm_mm);
> @@ -463,4 +472,16 @@ static inline void mmap_read_unlock_non_owner(stru=
ct mm_struct *mm)
>  	up_read_non_owner(&mm->mmap_lock);
>  }
>
> +/**
> + * vma_assert_stabilised() - assert that this VMA cannot be changed fr=
om
> + * underneath us either by having a VMA or mmap lock held.
> + * @vma: The VMA whose stability we wish to assess.
> + *
> + * Note that this will only trigger an assert if CONFIG_DEBUG_VM is se=
t.
> + */
> +static inline void vma_assert_stabilised(struct vm_area_struct *vma)
> +{
> +	VM_BUG_ON_VMA(!vma_is_stabilised(vma), vma);
> +}
> +
>  #endif /* _LINUX_MMAP_LOCK_H */
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 4bf4c8c38fd3..1f3040688f04 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -109,9 +109,7 @@ void anon_vma_name_free(struct kref *kref)
>
>  struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
>  {
> -	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
> -		vma_assert_locked(vma);
> -
> +	vma_assert_stabilised(vma);
>  	return vma->anon_name;
>  }
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

