Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A48DECD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 05:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D48AF6B0005; Fri, 29 May 2026 01:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20CC6B0088; Fri, 29 May 2026 01:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0F756B008A; Fri, 29 May 2026 01:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFF176B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:30:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C197C42F8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:30:14 +0000 (UTC)
X-FDA: 84819331548.06.FCC596C
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id D189440004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:30:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=RMcon9Oq;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=emil@etsalapatis.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780032612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/UlsWXbnlywpZNi56py/1CKrzpnAXP49BFYVBPQEJw=;
	b=nbDjdfzmWS/hOZf3QDKlIMiBCUgOvxB2HdMX580PtX/27wDAVUtWF+higTGSqV9IMliT5B
	JUSyiCuCP3+b2x5IwWq7lHgU3piaWddh75kKRV3lfarCQQg20OfImcXQMqjJf4Wwy6tous
	FzjKz/gPzaegS8+ruOa/Hm5z/b36U8w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=etsalapatis-com.20251104.gappssmtp.com header.s=20251104 header.b=RMcon9Oq;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of emil@etsalapatis.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=emil@etsalapatis.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780032612; a=rsa-sha256;
	cv=none;
	b=IXzuOH8fSmHUbFu0Mm12UbWXaWM4Zg1OXQJgzaRRONmnVxXYAN/07ZDttzO00swSYcB8+o
	mEnobJQRmJgok2P0x4g9wnslwPnKqFEvJjR4pVQzgMK0NrTgh4EXghDRQIFTRvS8d3NQe2
	o/QqOJb201DqJi+hiSplKveF1pr68+M=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-36ad15213fbso3108947a91.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 22:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1780032605; x=1780637405; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/UlsWXbnlywpZNi56py/1CKrzpnAXP49BFYVBPQEJw=;
        b=RMcon9Oq/97Xgx9pbhTMNyjXYIt3O+BZmZLVWCNzxmsKYauboB/C2RUctcBtl4j9KR
         mMXq1OXQieuwx4Qp+hLslx/FT5swEqZC2tNoKLf1AytZfQsfnNGDyARX5O0ABFrC9Hfl
         FxFar/xvpPcoYu7Pm5absMv6mzSQAwpioXtzWFtBs6DP6T/T0USX7VWLwtCbSPTRizIW
         3TrDCzmk3wmUtYoHTVdeaHcjEMyQ90YNIiJ21qstt7EuYOTa0VVdIUKDTABvCGl0Pr/S
         Wm7rCN4a9d0D68gsx/OUEYJOOoUPianBOa0Xrfh4R/DgSVUPIQT+iQbvUlZjcG+xMhKM
         ktJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780032605; x=1780637405;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z/UlsWXbnlywpZNi56py/1CKrzpnAXP49BFYVBPQEJw=;
        b=Xp2weRve4Ck8c0F/L1shhvLxpPXiSmhwMM0CX3izDCI7PQe3BRMf5y8RlF4LvNcE2A
         menlJHg4gcVKHlH1EnluKodc1zfMOjnU3XnyS7l6tyr6HGvp6yreWsOpuackY+UeaoMv
         O5asH+GO2DXmFUyIhSwXRZb24MSrbCcc6LDp0WyZVERshW9RIpm+xnhZ3iY5lSei0v++
         5hPbXAYzLWZ3pWItNZtB9XQWtKjKT9NMyG8sZkBo4MObyN2LO200t2f6CA8DyQOrOzvW
         5DcBFbw1f+rO1EGoEXo3uUFCmX2vaNKhAmqlGXQ2sIwDOrf8DuYwBDtc6U1nddMUCDmC
         hhIA==
X-Forwarded-Encrypted: i=1; AFNElJ8iZ//EhXPUt30EV7ASl5NcwGA2XVJYAibDtwmTJ81kpiVz6f6oDT8puLGK78HhzGbXNcTOYg6tsg==@kvack.org
X-Gm-Message-State: AOJu0Yxed/G9QhTi5JLKwWoUCPebfSWA4D9XmQ6cXYG1evYU8ioPJzHa
	RFihp28VJP328EWt3vZnpXxSAFT9m0/ffiYPgOnHcUfnrnBEQ/RbY7wYEzHif5VDiOM=
X-Gm-Gg: Acq92OHnSkg7AsdUG+feTLM6866fqleXFzkqk9t+tD7HPbwhT4zsqm5S3CYc4a0WDQ6
	yBAfts/8EcjyKDCBLexq6CDWp71lR4uD2Ag6JwFXn0e/ynatXm8X115ivveAQFWAmI+kR+Y6Krk
	spGpHx2cAgce6xeWPZJysZumTvBmvQtDVC2Fm+C48vRU2zeUjeKogYbExSmxe/S3V/gZdzFdBcI
	gxFfrG1sFcpWQQrTjCFR1BIdwIqGXDOcrAxzVCSzb0rL/sCpxzsr4Xe6Pr5y53Le5DqOAYIW41d
	MAis3DcTvnab50FR/r9tyLQ3tmXpDN6FJb/rfo2fDHdE5dGwreEDpu2Ug1UP0JKgmlJnpPDK+VJ
	+hIQaJ5NhKAtIGSINaNcKC8HYYeit+j7iEe26Vtsypb1N0GD/UDlQWTSbEVLFeoTjRjb9egxTkP
	O4IcDT5tfVNm4WnzDmjyWpq87Xn3iO+4/oAnM=
X-Received: by 2002:a17:90b:17c9:b0:36b:9184:ea49 with SMTP id 98e67ed59e1d1-36bbd13ac3cmr1639053a91.26.1780032605209;
        Thu, 28 May 2026 22:30:05 -0700 (PDT)
Received: from localhost ([2001:569:58a0:da00:a5c8:c4ce:f7c1:40c1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bc6631789sm551648a91.8.2026.05.28.22.30.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 22:30:04 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 29 May 2026 01:30:03 -0400
Message-Id: <DIUWW97NOAG2.N0U9S6VNDIQ7@etsalapatis.com>
Subject: Re: [PATCH bpf-next] bpf: Take mmap_lock in zap_pages()
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
 <bpf@vger.kernel.org>
Cc: <daniel@iogearbox.net>, <andrii@kernel.org>, <memxor@gmail.com>,
 <eddyz87@gmail.com>, <david@kernel.org>, <tj@kernel.org>,
 <linux-mm@kvack.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260528222014.38980-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20260528222014.38980-1-alexei.starovoitov@gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D189440004
X-Stat-Signature: d6am8qxu8hejw84tfjfa11hg7kp3cumz
X-Rspam-User: 
X-HE-Tag: 1780032610-112080
X-HE-Meta: U2FsdGVkX185XH2swSi2gMCwJx0jK6em+eh0ol0r1GgId5p6UDDnFo+IwugVxNRE7mhJqNNreEQPr95b/cWgvJjCgsBaV00LK7hndyJxT4aOFBVR0QGP86GlTeNPhrDSa80+h2biOrXF51BQpGeuC8g5hLvj1BAz8UtFJ6ZhhlQjE4amyu9M3v4bU0KjPS3cTJDWnD5FPKuF+oG8X8v4BF322SeGCXrnQN2cgNNsVakpXmMB+WZGUnuoIhX4u7JqyUoYPD9pHXM3uQd0YvG2RFrL1ojRdhLli/jraFjwxh0b23JMRtTWb2auXdq5ZDzWjMVil2oNBQ6wd7veG8SpknuAILHaA9bpb5fvpf8JZVM6MlOFdVhjZtxX3AN24fHBns+DJVYP6+24MHgfeM6eLA8o0oo+r3yqUgOlu2uR9MCjfUdvVk4yNmB5dCRn/CU4ggojO6LIHDM1MJteLxu/D8LSluCJHt2Iucg/pTpw7ecq+9XwxT1BhlAJgOwU+uU6nHwp71jJanxs4Ds3KFCL+CFuFYNQxhcyW++ZO0WDdI/giEw2BMOCLPfBCobUafk/OqFhC6feI4CdSv3CeSdCT8OlfcBKSHruDfRpu17C0EUihcBLeKnuO4vBvfk1fLIgehTJFSIh9Y0KXOCeqCtDW0dICQ+c8Z9oswZG2db1w6zS6fefR9eVPLNkXxE+MNEk7MrxtAin0R7dD8t4AVLniSTamoQKYr/+q0KMnChRmu9ZOpkbojmEGV9jM4ym5X05mbVn16DKhqqnx35yzkkhjtu7rXHg3vx75WJawhdGpPTA4qzzq1cLIdaGo8m7+cv1A7oIrxaT/jnBx2rF5nq/SsZxhc1Iy9wWto210AyIa/aYj6d9NlQkQlqLoOGoqPczxES9+o6EWw42MMNhueNipS0yUm69C5C5x5Na1C0GllEOBbSGo5H+r4rGz7Cuud3B13siJ648CCqDN6TRlMN
 879UKA9M
 K9iaqSr2jZfIFHqTvUkm4DcMDNANjEMWwzTM7IG7+ogW4LKfnfU1cZPsijKk2p8mWe9D0odVoI89GrEVBuGe8xA4ZLCa5XAHShcZi7OLO15iywUAxEYb4tu2RPRaHCQSqN6itss8jFhMI5PSdb/fuT++1v+FSKnNnNobm/U2hdjczqyt65DcKIUmWfV9+kbHAJZ9HQz6EBBy0M0akl70izjtUegmpenjLcNW+qM9ckJz04WpElUXPNHUYuylmjng2l5srqVjxYQAMcv22XGsgOMvj/I43SvJOJmz6PZfoTVXsgG0lFocJFAW5QG1AHS4Uz/P3m8cjI8CFLSj3g6FCPyYYhGj5dYdZCGHkKI3qeJWKXU90G/8hsG8OyAayDW4m3T8yf4e1rWWI6hK2J9ZlHFenRRTUEV8aJoUW5MHoMs1bf3PBi8qPJ5n0pHPfgvQe3HDRfcZwogkCmBOKq79VuUMloed4/splO/f/+0DBrHQQzHoMNKYY0c++w6CwRRCaKFxE3GLHPYAIHX5hzaz3K8+tYLsJRZzs61FGwil9vG4cYtmAx7P5U1MtK2g8xcm6O7n/xc58KxUjpF+A/zNsLfXQmvcjxuWUYuHg+6FPEgQjhD1ua4QuZMdD0v3N15LdSht1tKI9RFhymr5Q/WLipqgYctfhs+CYCSoe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu May 28, 2026 at 6:20 PM EDT, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
>
> zap_vma_range() requires the owning mm's mmap_lock to be held.
>
> Taking mmap_read_lock under arena->lock would AB-BA against
> arena_vm_close() and arena_map_mmap(), both of which run with
> mmap_write_lock held and then acquire arena->lock. Instead drop
> arena->lock, mmget_not_zero() the vma's mm, take mmap_read_lock, and
> re-resolve the vma via find_vma() since it may have been unmapped or
> replaced while waiting.
>
> Track processed vmls with a per-call generation in vml->zap_gen and
> serialize zap_pages() callers with a new arena->zap_mutex so
> concurrent callers on different uaddr ranges do not mark each other's
> vmls processed before the zap is done.
>
> Reported-by: David Hildenbrand <david@kernel.org>
> Fixes: 317460317a02 ("bpf: Introduce bpf_arena.")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/bpf/arena.c | 61 +++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 57 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
> index 1727503b25d8..9b2dea229b38 100644
> --- a/kernel/bpf/arena.c
> +++ b/kernel/bpf/arena.c
> @@ -60,6 +60,8 @@ struct bpf_arena {
>  	struct list_head vma_list;
>  	/* protects vma_list */
>  	struct mutex lock;
> +	u64 zap_gen;
> +	struct mutex zap_mutex;
>  	struct irq_work     free_irq;
>  	struct work_struct  free_work;
>  	struct llist_head   free_spans;
> @@ -289,6 +291,7 @@ static struct bpf_map *arena_map_alloc(union bpf_attr=
 *attr)
>  	if (err)
>  		goto err_free_scratch;
>  	mutex_init(&arena->lock);
> +	mutex_init(&arena->zap_mutex);
>  	raw_res_spin_lock_init(&arena->spinlock);
>  	err =3D populate_pgtable_except_pte(arena);
>  	if (err)
> @@ -391,6 +394,7 @@ struct vma_list {
>  	struct vm_area_struct *vma;
>  	struct list_head head;
>  	refcount_t mmap_count;
> +	u64 zap_gen;
>  };
> =20
>  static int remember_vma(struct bpf_arena *arena, struct vm_area_struct *=
vma)
> @@ -403,6 +407,7 @@ static int remember_vma(struct bpf_arena *arena, stru=
ct vm_area_struct *vma)
>  	refcount_set(&vml->mmap_count, 1);
>  	vma->vm_private_data =3D vml;
>  	vml->vma =3D vma;
> +	vml->zap_gen =3D 0;
>  	list_add(&vml->head, &arena->vma_list);
>  	return 0;
>  }
> @@ -746,12 +751,60 @@ static long arena_alloc_pages(struct bpf_arena *are=
na, long uaddr, long page_cnt
>   */
>  static void zap_pages(struct bpf_arena *arena, long uaddr, long page_cnt=
)
>  {
> +	unsigned long size =3D (unsigned long)page_cnt << PAGE_SHIFT;
> +	struct vm_area_struct *vma;
> +	struct mm_struct *mm;
>  	struct vma_list *vml;
> +	unsigned long vm_start;
> +	u64 my_gen;
> =20
> -	guard(mutex)(&arena->lock);
> -	/* iterate link list under lock */
> -	list_for_each_entry(vml, &arena->vma_list, head)
> -		zap_vma_range(vml->vma, uaddr, PAGE_SIZE * page_cnt);
> +	/*
> +	 * Taking mmap_read_lock() under arena->lock would deadlock against
> +	 * arena_vm_close(), which runs with mmap_write_lock held and then
> +	 * acquires arena->lock. Drop arena->lock for mmap_read_lock().
> +	 *
> +	 * Use per-call my_gen, recorded in vml->zap_gen, to remember which
> +	 * vmls this invocation has already processed across the lock drop.
> +	 * Hold zap_mutex around the whole walk so concurrent zap_pages()
> +	 * callers cannot overwrite each other's marks on shared vmls --
> +	 * otherwise call B's mark would make call A skip a vml that A has
> +	 * not yet zapped for A's uaddr range.

One thing I'm fuzzy on: If the vml gens are to mediate between zap_pages
calls on the same arena, doesn't the zap_mutex already serialize those
calls? In that case, since zap_gen is only used for zap_pages(), do we
actually need gen counting?

> +	 */
> +	mutex_lock(&arena->zap_mutex);
> +	mutex_lock(&arena->lock);
> +	my_gen =3D ++arena->zap_gen;
> +	for (;;) {
> +		mm =3D NULL;
> +		list_for_each_entry(vml, &arena->vma_list, head) {
> +			if (vml->zap_gen >=3D my_gen)
> +				continue;
> +			vml->zap_gen =3D my_gen;
> +			if (!mmget_not_zero(vml->vma->vm_mm))
> +				continue;
> +			mm =3D vml->vma->vm_mm;
> +			vm_start =3D vml->vma->vm_start;
> +			break;
> +		}
> +		if (!mm)
> +			break;
> +		mutex_unlock(&arena->lock);
> +
> +		mmap_read_lock(mm);
> +		/*
> +		 * Re-resolve: while we waited the VMA could have been unmapped
> +		 * and a different mapping installed at the same address.
> +		 */
> +		vma =3D find_vma(mm, vm_start);
> +		if (vma && vma->vm_start =3D=3D vm_start &&
> +		    vma->vm_file && vma->vm_file->private_data =3D=3D &arena->map)
> +			zap_vma_range(vma, uaddr, size);
> +		mmap_read_unlock(mm);
> +		mmput(mm);
> +
> +		mutex_lock(&arena->lock);
> +	}
> +	mutex_unlock(&arena->lock);
> +	mutex_unlock(&arena->zap_mutex);
>  }
> =20
>  static void arena_free_pages(struct bpf_arena *arena, long uaddr, long p=
age_cnt, bool sleepable)


