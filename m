Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BDA2C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2890F6B00AE; Tue,  7 Jul 2026 15:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239986B00AF; Tue,  7 Jul 2026 15:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F676B00B0; Tue,  7 Jul 2026 15:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBE106B00AE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:55:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 602368EAF1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:55:22 +0000 (UTC)
X-FDA: 84963034884.04.188FE7E
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4ED0D40002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:55:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VUAzXz+r;
	spf=pass (imf04.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783454120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/UUjuXqKnuK61a7cFsjW9ZWqBCGpYoIH9JYtW2nvWM0=;
	b=HVz2DSVLlbgh4FSq9yAre5iDBdfyboSmzCA8Siyq0iISIfslXf5qoYSiG6rcIQOBjSHh9c
	q3Ebg+2dv+bomCxR+qnjH7kk70kmcSNOo7SNw6EKwu+x2V9Qf17E/w7x6XZcawb9vaScXr
	EyoOmwzOL+cg7cjj0aj5kahQtRrNUGk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783454120;
	b=c5uFGMoIt7STQKUU2BAMTHoFqSkhSrrCjhs5XRYVI/VUWJ0r9Mj3T5MwTKCgFO5InP5ayB
	nnr39NvEH8F6dYm4iQS7cCCSbwKKZYxc2JP7TVlSkXfByYuT8mQJsBdaJ34UVHAiKw8dvp
	FtAu7K8kuDjG25jnmfgKtspqTU9fd3s=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VUAzXz+r;
	spf=pass (imf04.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-43bfe209e45so2137079fac.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:55:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783454119; cv=none;
        d=google.com; s=arc-20260327;
        b=dPZqt6+3V79Sp+tj6pbuMDJmbQyd5R3wcCQC1k3RJBrvyeXK2TvsMVIaxnGBR+YQNj
         SV4E2v0aVVy2uiewU0zDatgMzmGeRlXkHh9bstrxtk2stbX4y+RJzqQ8zy6MR95rzvak
         L5y8ygSIAvWs5XacPsAzmGpeCgR7eUcd5l0RASc660KwMW/xLBkFfLvpG47CuwsY4/IN
         QUs6r4FU7g/lzLiVsnhK8TZdQWQWV0b5nOiWWxjBIEEiYsBvyoD5LjsuEbruUh11iy9s
         BIurWzWwB4LP+i/5jXTvABGrUL16roDF+AZfmeXT/bkb/zDRsK25iN7fSRTafGGtw3R2
         Jaew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/UUjuXqKnuK61a7cFsjW9ZWqBCGpYoIH9JYtW2nvWM0=;
        fh=Of/TwXuSWc+2INqfnWAntNh5/kTIEVBWyF1s5y36x18=;
        b=TnewPGqNywT2Hh/qK2mA7iRRx5fwsxo2IztGE+Q4aYdDkftO46Tj63p1bA0PVzZi4K
         rqulYRCKaVRbZG3l/zXP3Los7wbIG6s6G6K3LZH82chtbzzAXk2/Js9wivSTvQhARh7x
         Wt/Zehk86Pf2RC8/05B12Uq0/zkpHW9wNlm0EebBkAfEio2D6x7UQxYNpAH5ewqVtvtd
         0VMgEooMU7qaMu8HASKIA5qVy2+hFQ8YB0C3IcKh2ThkCp9Mx20gcs+r1opEM+/Iv1HS
         CFvxQZiLnt3WRb9MAWLCHhHdxbcBKINMqhdAGgKCORbNdgp57tmq15T6GCDWZGuPtN2Y
         OYjw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783454119; x=1784058919; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/UUjuXqKnuK61a7cFsjW9ZWqBCGpYoIH9JYtW2nvWM0=;
        b=VUAzXz+rfUyHFralp4rISvrmUhvWXBYLWRvko6WMuYW8YqTNtsOOSCqbvvmEj23lTY
         /9XLdDYJr7qnZKWxqk6hZdp1KL5l7igDjK8cdO+otmIgQxsXq8FsHom8hwfM5DiKuZbU
         48ysuM6E0/lukp41kVgZJKJyQnBjPnCOlJRv8hk7aN1VXMCJIiSUZ/HwCtTXkzF6beQj
         BUITNdllaGqAW6AfLle/Cnj5Sa61WcWqRNYsyuBjSGHq6PAEW07fqcniW0YuqgIFYKhd
         l6798WE+rSX0nfLoMj21tlrh+JPHYntlph3cQjiHyLbFWd336EYQAPDtZLAdAL7vzxUp
         cXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783454119; x=1784058919;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/UUjuXqKnuK61a7cFsjW9ZWqBCGpYoIH9JYtW2nvWM0=;
        b=aSw+3TtE/yh9KPnDpcPVfrtiMxFsw4Yh+b6vX0PSx1318LRkBFPqLKUKA9+7EG5r9F
         glrTihF1yYhPvdxY1bEtp4FQwww42gt89lvNQ5upzZ61pX3ToVH5Ujm0/3wVAOD3J2GX
         X+Je/V8x7pz3ZP9wNmNfzmsQ5Sz9NOZyJgECJTBFXCZY/pxaeS1HfNGmrC43UoWywlPV
         LBjOnHnUyFKte8NwYvSWNEfvA+5xRNMqPoymMq3sxVq4z4/MwFdQHQXZQvNCN014J0pk
         2q5nthK+cvA+W/Nxjcfl482o6R8Fwg5vrS0yNpaMmo5cXMqLa9oOXSZDD/idqW85A+4Q
         cjkA==
X-Forwarded-Encrypted: i=1; AFNElJ84OzFnheIZZfO+FlA6rKO5/aFh0rETFmnhrpsy51Ons0rMEHdQKX7fU+Rc6yVRascp9riThKueEg==@kvack.org
X-Gm-Message-State: AOJu0YzB717I4b+m7EU1mVEuYaTM9GrKpxYeNL3JhTPNgYNe6FpcSuCf
	s7aMz6NshgvKCRlpMPpDG+dQx1fZsf6Igc5QjgECa/kXZYJIe+p25P1GqWGSbflE7sOJoiV/u2y
	cUhtF0FQbdWplDu7nCH5kWcsDbraEYy4=
X-Gm-Gg: AfdE7cmUjQcAU/YgPftTfrFoLYJpBtenYM0DJIPjzBJeZlRTzC92H7bs3hvwDNxUs0J
	CVapNFWaE0G8OeVKAb4lUnu4LjWe/IbbMcphA7b7Qx/cwsK61swN0ynLFJt7xaIN5iVJP+7h1hU
	6JX+q4n19LxpiLV3My1rpNt93qLDqwbxWkLDHyn2UX08l6DRXGyGG/3FCV1MlZSBRZ69DmCe1tT
	jJXr6FwA+pb52UDuVnEsvPv4L3muY7OSnjrwAFQ/IM+1oG1pwZMi0djS+a0plykmIYcIcpKS12s
	Zp3B7AQ=
X-Received: by 2002:a05:6871:2eaa:b0:439:c66d:2e5f with SMTP id
 586e51a60fabf-451062d14b9mr4294017fac.24.1783454119271; Tue, 07 Jul 2026
 12:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260706000338.362421-1-shijujose2008@gmail.com>
 <20260706000338.362421-2-shijujose2008@gmail.com> <akx2wqr3ULcmpCmc@hu-ashoraj-lv.qualcomm.com>
In-Reply-To: <akx2wqr3ULcmpCmc@hu-ashoraj-lv.qualcomm.com>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Tue, 7 Jul 2026 20:55:06 +0100
X-Gm-Features: AVVi8CdNXthfgZirwipMRC0g06u6afOreJEJzYGgCdk14S6ETxObFJktMa8ee-M
Message-ID: <CAG4KcR+TPE9a7Fr1FWwoRa9tcb+u4qfp=UiuYvb=kNXKRWPP7w@mail.gmail.com>
Subject: Re: [PATCH v21 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature table
To: Ashok Raj <ashok.raj@oss.qualcomm.com>
Cc: rafael@kernel.org, bp@alien8.de, akpm@linux-foundation.org, 
	rppt@kernel.org, dferguson@amperecomputing.com, linux-edac@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	tony.luck@intel.com, lenb@kernel.org, leo.duran@amd.com, 
	Yazen.Ghannam@amd.com, mchehab@kernel.org, jic23@kernel.org, 
	linuxarm@huawei.com, rientjes@google.com, jiaqiyan@google.com, 
	Jon.Grimm@amd.com, dave.hansen@linux.intel.com, naoya.horiguchi@nec.com, 
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com, 
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com, 
	gthelen@google.com, wschwartz@amperecomputing.com, wbs@os.amperecomputing.com, 
	nifan.cxl@gmail.com, tanxiaofei@huawei.com, prime.zeng@hisilicon.com, 
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com, 
	wanghuiqiang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4ED0D40002
X-Stat-Signature: afrfm5hfxksznk7fj5116n9w78yqwatt
X-HE-Tag: 1783454120-604989
X-HE-Meta: U2FsdGVkX19DCRrmwRq/aO3vv2oAFOGzWex9WvRJmha+ESWPhExVLVr1xZt2Ig0oJO93yA/VKPyZ1bebxq/4ynu15c0z+nZYJVc/sLWtnwlbxYz8+GA1SPGOpnT1hTxIxMxaz25BnS8hUXUou5Qhwel/0EMsS96CQYe9LZ6QEcZo/cLgHyC94lRbBJTbNyASew6FtCNg+iX8gLE0bi0O0kzqA5HO1jcf3uhQ5UpT/toG1qckxj7dED9+Znk3vsg1nezkqmPgqOfgiWqBwuTrYyP+A+go4YhvSNj/5EpsGwP65S3OOi5xbviTCPUjEGKrCPghlPjpU1jg8LRSTIhV44NjhG7iYISboi5S76aqwb44XAN5vbB3tzJ4yxYbfDiCzvUCJfJDr8yw4Ty7hgQuiXms1qIOa8DsbXjPEXhWA4vxVdFtmwbl0rj9tTzzsVUxVhjealLcYx9BZE+EdCY6hLC46XLEfldHabmIQFYrdAImgb4RnMniFWNFdT66N7I9QI9AFErJ9s+H6x90Zew0TMPDV6sqlqalLbd/reBM5LMM+40x7I6nd62HZVFgRKikWdPlI36ZvercaS+mZ0Xqu0qOKFNrT3VOrib2sBA19BVn9lvTEdjsFqJBIk7+4BAwDKJNwZcSur1DnEIjDFr+SANEqmepEn2eiIjgXe3lXwZHAbgyFLxbOdmpkjZXMfmqhPz8/KBTS343rGL1J7xEX9N8YyLXtw7iCu6esfbSO96K7fdQGHpJMulnS5PMl1zFyHWwlmX+Jxn4/BitKvUL3xjGekDTNVT2em/5a9E9dHD/uVwwQmtrUUjK5AOGvILU2TtdX95yJzIKmQFSfD+HNL0MP1agLphhm+olFOulvlW3QSj2suoGxjC7AZ7Hm7E9EhZ70WX9mTRLsuJ64SjZasLTWWIJVfvIbD9wtW2uCz4+LbB4EeDAHHS0b5PJgQcawnrLfhNSpVTFJu5A4an
 Pl1zvXkI
 qb0u9uvR6mGyQlDXGg9egfRXGBxVbW2m0o/pC1BVv4iHrPubZTrVcNoBEtxKb+RZPC128yHP8jYq6q7vKEvbVtzP5M3NYmXKfZAIuLQTc1VntJmgNtPJQ96JGCumdMkeL7gtOIn4mrQFIBKL19vpeBQBJWfQL6/DplkiX1BKImUPhodyKhPzxmKE1rz54l1Od6t4Xv3CJxQRL3KiYCCrmua8CsGjRsCsQO5OwxohOybrzKG4IzIdf8KXdCiXTQnLR8GYOgrPdPcX9X6TpbL72o72eSQwRNUHpBdn8/TZTQPxCqyTGqUgEfjqbO7f/INxyNvUMQ895ngsDk4ZtLcK0qVsTPvGOaNAV1bDxKNm4k9WOMOfF+KcY4PUhgDiyJh8+su4ggYvmhASuiloUv6xbpjAC0mFx3vRwSI/0dovunLm4EsyokCd1LZhWjcHIAxgDETAVGm3xzxeiK3nXxkfafVDrGEvnmegvM1Tn85ie6QeNxZMcxRg+RFKRji88ksxaiLkkU0IAShYOL8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ashok,

Thanks for looking into this and good catch.
I will incorporate this change in the next version.

Thanks,
Shiju


On Tue, Jul 7, 2026 at 4:47=E2=80=AFAM Ashok Raj <ashok.raj@oss.qualcomm.co=
m> wrote:
>
> Hi Shiju
>
> Thanks!
>
> On Mon, Jul 06, 2026 at 01:03:37AM +0100, shijujose2008@gmail.com wrote:
> > From: Shiju Jose <shijujose2008@gmail.com>
> >
>
> [snip]
>
> > +static int register_pcc_channel(struct ras2_mem_ctx *ras2_ctx, int pcc=
_id)
> > +{
> > +     struct pcc_mbox_chan *pcc_chan;
> > +     struct ras2_sspcc *sspcc;
> > +
> > +     if (pcc_id < 0)
> > +             return -EINVAL;
> > +
> > +     sspcc =3D ras2_sspcc_get(pcc_id);
> > +     if (sspcc) {
> > +             ras2_ctx->sspcc         =3D sspcc;
> > +             ras2_ctx->comm_addr     =3D sspcc->comm_addr;
> > +             ras2_ctx->dev           =3D
> > +                     sspcc->pcc_chan->mchan->mbox->dev;
> > +             ras2_ctx->pcc_lock      =3D &sspcc->pcc_lock;
> > +             return 0;
> > +     }
> > +
> > +     sspcc =3D kzalloc(sizeof(*sspcc), GFP_KERNEL);
> > +     if (!sspcc)
> > +             return -ENOMEM;
> > +
> > +     pcc_chan =3D pcc_mbox_request_channel(&sspcc->mbox_client, pcc_id=
);
> > +     if (IS_ERR(pcc_chan)) {
> > +             kfree(sspcc);
> > +             return PTR_ERR(pcc_chan);
> > +     }
> > +
> > +     if (!pcc_chan->shmem) {
> > +             pcc_mbox_free_channel(pcc_chan);
> > +             kfree(sspcc);
> > +             return -EINVAL;
> > +     }
> > +
> > +     sspcc->pcc_id           =3D pcc_id;
> > +     sspcc->pcc_chan         =3D pcc_chan;
> > +     sspcc->comm_addr        =3D pcc_chan->shmem;
> > +     if (pcc_chan->latency)
> > +             sspcc->deadline_us =3D PCC_NUM_RETRIES * pcc_chan->latenc=
y;
> > +     else
> > +             sspcc->deadline_us =3D PCC_NUM_RETRIES * PCC_CHNL_DEFAULT=
_LATENCY;
> > +     sspcc->pcc_mrtt         =3D pcc_chan->min_turnaround_time;
> > +     sspcc->pcc_mpar         =3D pcc_chan->max_access_rate;
> > +     sspcc->mbox_client.knows_txdone =3D true;
> > +
>
>   Probably a minor nit ..
>
>   sspcc is published on the global ras2_sspcc list (with a live kref)
>   via list_add() before sspcc->pcc_lock is initialized a few lines
>   later via mutex_init().
>
>   Once list_add() runs, ras2_sspcc_get() can find this sspcc and hand
>   out a pointer to it (kref_get_unless_zero() succeeds since kref_init()
>   already ran). A caller doing so before mutex_init() executes would
>   end up with ras2_ctx->pcc_lock pointing at an uninitialized mutex.
>
>   Currently harmless because the only caller, parse_ras2_table(), walks
>   PCC descriptors strictly sequentially, so no second register_pcc_channe=
l()
>   call for the same pcc_id can land inside the window. But it's relying o=
n
>   that being true rather than the code enforcing it.
>
>   Should we initialize the mutex before publishing the object, e.g.:
>
>         mutex_init(&sspcc->pcc_lock);
>
> > +     kref_init(&sspcc->kref);
> > +
> > +     mutex_lock(&ras2_pcc_list_lock);
> > +     list_add(&sspcc->elem, &ras2_sspcc);
> > +     mutex_unlock(&ras2_pcc_list_lock);
> > +
> > +     ras2_ctx->sspcc         =3D sspcc;
> > +     ras2_ctx->comm_addr     =3D sspcc->comm_addr;
> > +     ras2_ctx->dev           =3D pcc_chan->mchan->mbox->dev;
> > +
>
> > +     mutex_init(&sspcc->pcc_lock); <---------------------
>
> > +     ras2_ctx->pcc_lock      =3D &sspcc->pcc_lock;
> > +
> > +     return 0;
> > +}
>
> Otherwise
>
> Reviewed-by: Ashok Raj <ashok.raj@oss.qualcomm.com>
>
> Cheers,
> Ashok

