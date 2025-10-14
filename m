Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1340CCD193
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 16:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002898E0146; Tue, 14 Oct 2025 12:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C688E0090; Tue, 14 Oct 2025 12:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31AB8E0146; Tue, 14 Oct 2025 12:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D23778E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:12:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6171A874CE
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:12:58 +0000 (UTC)
X-FDA: 83997213636.19.4BE39F2
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7D9BB16000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:12:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iDDMtWwx;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.166.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760458376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1l4EKKqI8FBMhyIpr+zCVYKqGmbIAtFPgpDTTeM4gt4=;
	b=PwQqDT4oLhwV4k+vKIbapQNdEP4peQnbQTE9OSDV6GcM2yVUcoSQgCeCbYg7XBKxWv8fnX
	Hfvaxa5MaYMF76Ol8dWar2Lz3Dyb38bEsujv8CvrnqL0xR8kYri1sDLJ0oujzapJcfcNhR
	eVgekxwgUrtWGeppPdNwuzLPOVSqRi0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iDDMtWwx;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.166.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760458376; a=rsa-sha256;
	cv=none;
	b=N40A1y9a7wnlkoQUVx6wrS7Yq4AParqokTGlR6JjViMj7nzJpNaqi2BGJVyrLGrATMrChQ
	u+vycgNL3to4nCJAnjxCErtyNemevsWJls4ZYwObbOB54c1IsMRrDJqFUr6+lwCvQpj+am
	8AsGWYIVFSyblOImXSTEqPp/3dUgy6Q=
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-4308afd43f0so2352225ab.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760458375; x=1761063175; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1l4EKKqI8FBMhyIpr+zCVYKqGmbIAtFPgpDTTeM4gt4=;
        b=iDDMtWwxmsbQQcwqW7JaSBniGZBGx5nu5Z/hc9kScS6B9reAy9BQACyz5jw/n+brLf
         C1/5zAtINchQNnzCNVd5y1asqS/Z4i4iwYDdim3T1iyP4sldf0wgwv2vZ6kOQxyi8Xah
         i9sjdVwoHA1Kys1AY/bytMlU2M3RVli2tbKVd5Qsc7UndjcgaAjhpF3eCBpSRIGv2uHr
         Wz9QESSIR8yjSo8R96kPAMgUGGEWa8SvLx046ftmqFoJxYAaq/8LUzKgqofRtJrEkcpF
         bNKTvijf18K2g+vPWVlpI+ru5UcZWWItBWklMfsMhaoMtx2MFUi+HSA/DaRM8Tx8w7W5
         dwrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760458375; x=1761063175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1l4EKKqI8FBMhyIpr+zCVYKqGmbIAtFPgpDTTeM4gt4=;
        b=TS/erHt+NPu9jCzmnpJXsLb63d1/sJh1yv+hZ5wZw2AOgDoKa7IhsD4I34hcsoQl6u
         rSb4LnSKh6A+QULmYFFRQsAN8D0040BNp4f95efZ/yHGxXd/wN5RXpMqx4mH9r8bDSMf
         REc8iGGI8UkGRhz6vPOeL81PcjRdERXTMg5nY34St7npAbFptPSg6jtPqDjTNeM1xyaM
         7rj9WP5I6G0NJqjmIlAGM5CaliLvHD9tERxEw8WZgpjLxuAJ3BXsetfzJx32ETmXhjwz
         3geCCA3EJNSDUQdPFqrg7JAZwxtuReU5iw6B1bqE1u5naSCywLyxJpEux0b74B4CidK/
         5DTA==
X-Forwarded-Encrypted: i=1; AJvYcCW2MqnZMeATc5ZVsRJwDT94om4GFEkF3MPzXZ0SUSSIF9HHYNn4QaGb4jQ2555Wb0ieWWnbKtzKQw==@kvack.org
X-Gm-Message-State: AOJu0YxMIEASrJxJ+7HYGG1ccutmHTsy2x/g6vutyGC7Lq0b3M4X/xDl
	xamBjYASeU2GLNFLjKuDHKgtq3IktKyFlDHlJpVIwQOIDBPFIJqfMOtTA6uwgpZbzyb0czAcX9T
	EnA0FSXcoRixJIl8oFvxzKJlErEJgkKY0vwmztnD+
X-Gm-Gg: ASbGnctoWNI/9rI6bEUMiNZv97U0dd1PfNa/XhQdjKRYbQ/2vl1apb4pd2Ygcq/71rm
	ZFZTFeuDl+fYYQwS6AkvIqnKNEZwVkxndobFRC+HA4K9Lg6nTeN37F9cWBVQ49K+3QEw1D74sdr
	xwBKFkF2UNBn8OHHHBSAE/zm3BYh9+bied97L3PyTqNIdAkPJME6n+3HmRz8z6Mdxt2YZt8xYiY
	+2vUHVCTpteyDM+jEEtaQkDHWZDnh5qrynbg3soU1t6Yc/1W2eHgEni8JtpyZpjcHztNrGq0Q==
X-Google-Smtp-Source: AGHT+IHsxfkI3RqV60s+4SmwuFMESPV6szhVrpxfuVQ107I5yLh6CGiq1Si9ni7nugofNA3QUKMsfNaQEUkOomFVGCk=
X-Received: by 2002:ac8:5987:0:b0:4b4:9590:e091 with SMTP id
 d75a77b69052e-4e6eab2cd23mr44696741cf.5.1760458374781; Tue, 14 Oct 2025
 09:12:54 -0700 (PDT)
MIME-Version: 1.0
References: <20251014152751.499376-1-hao.ge@linux.dev>
In-Reply-To: <20251014152751.499376-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 14 Oct 2025 09:12:43 -0700
X-Gm-Features: AS18NWCAriF2eEUZLKRahG6-w3sbYVxwVeVbddImCwABMJPof2QmTeFqw72OU9Q
Message-ID: <CAJuCfpGBxUmvWoe2xv2-bsF+TY4fK-m1-Z_E3OcyTiSYz5KeAA@mail.gmail.com>
Subject: Re: [PATCH v3] slab: Add check for memcg_data != OBJEXTS_ALLOC_FAIL
 in folio_memcg_kmem
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o5hpctzpdjipjtkma4foqt6juk9qc3xr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7D9BB16000A
X-HE-Tag: 1760458376-49552
X-HE-Meta: U2FsdGVkX1+45og+sk1IFKxbk8z/qp85lcXAsd2ZyW0328NOrd42hkH+lP14hflSC351jd1A3PNOFQTYMhEr32FncUHv+YQ1K+BECWGdl34ZT34MsEYREJXE4Oc3OeD+AYWWIfF7whMLI4hZzA+Dj2ek2Cs0yXo4ekjJDZXqTTwjiY1cpOezB44D3V3jEVhN/JdWPpmEm98ja4vfbZAoEXgvJa2INl4/CcpN0rCJiGCzngS5zNamU4NjLmIy8+w/3cX3M4X37iPy/dPgcRXEe4vXdqHus1PCl6HiINFI/7xbv0aEVuD9RviX2aL2eQZ17PHtM9RuzfeaPMKS0QwewXIZroJcb0DfNkgVBAjYU+pCedMr3THFm/+RAzOCtMrCR6JeQ5ISZv5tp92xzyFghYdi6gKVGsV8zOZw+XIUknTIB2AEjFc0hD9im9IodBZNSjmXF1blAToGXC0zZuXA0sGV1xQEERDn+m4AQmu35iXecBxlLYpy0aoliJ8oFST9t+mfSvqd/zgFcsL8xjB3TZU/OOh0agZ41pZPsbAZolo6CmRH0GQ9KZWXB/zSfzR0yFjKVesvKYOmREsp43XtdTDrStKKwwWuo8GxAtThD+Ibdqj7EIWDYW/P+ZQYiTaB8JXw6BEyuGtmBW986gQiBB3Yr6lE84BQC97vEIEu4ou7lTe4VZhD0Xt1qltK2wG2yjKdaIcv+TQX/ZAtj4J4C1L9bkgcWmGvvCONAP8i1uxHTrmYfza/HMX2pvoHxTUw3qw2eDujpdmm9J5aEWubkbFXNAZkrMKz+RzM9dEikQ5p2UMajGRsPvuHxAactL+gMqmGTk5uE7CDzxVKtAnHVe6OqLy3I/mwlJ6rzy+OHWTJ+upKmr33TPM+PsLnOC/nVc+GwAmdXABQon4c37C4kahY6qcGMb1cEupXIrZK8vt5/BcDaD+VstjByvIGmSYcQ56dg76Df35p87mRDDu
 y6tIRpnv
 M3ADaH2DTHCcRpOKY51PlllnmY60ftB0QCWXDFbafb14AN/eDO99RKTzmmtNsmrMKlTpgjXkFe7UaOvj/PaM7dPspk8lbZ13M9wCaCuwwHMsAWT7RvMPcXIJg6kfL1ubCf4/yjpWkaAp/OA72wUn7V2GyAPUxhDoABtLxMrM231WHbPInWmXnzup5n1a9xHfjzJBwFkRlHK9BE2kbcRiAfs4lMTNNN/Qh5+/oPxx16bgTH4OpHYIbo9uOxCgyuqsHtxwNZRvJEOp8qNg9iRGaduD3diyzNR8QvyoB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 8:28=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> From: Hao Ge <gehao@kylinos.cn>
>
> Since OBJEXTS_ALLOC_FAIL and MEMCG_DATA_OBJEXTS currently share
> the same bit position, we cannot determine whether memcg_data still
> points to the slabobj_ext vector simply by checking
> folio->memcg_data & MEMCG_DATA_OBJEXTS.
>
> If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAI=
L,
> and during the release of the associated folio, the BUG check is triggere=
d
> because it was mistakenly assumed that a valid folio->memcg_data
> was not cleared before freeing the folio.
>
> So let's check for memcg_data !=3D OBJEXTS_ALLOC_FAIL in folio_memcg_kmem=
.
>
> Fixes: 7612833192d5 ("slab: Reuse first bit for OBJEXTS_ALLOC_FAIL")
> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Hao Ge <gehao@kylinos.cn>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

nit: I think it would be helpful if the changelog explained why we
need the additional check. We can have the same bit set in two
different situations:
1. object extension vector allocation failure;
2. memcg_data pointing to a valid mem_cgroup.
To distinguish between them, we need to check not only the bit itself
but also the rest of this field. If the rest is NULL, we have case 1,
otherwise case 2.

> ---
> v3: Simplify the solution, per Harry's suggestion in the v1 comments
>     Add Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  include/linux/memcontrol.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 873e510d6f8d..7ed15f858dc4 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -534,7 +534,9 @@ static inline struct mem_cgroup *get_mem_cgroup_from_=
objcg(struct obj_cgroup *ob
>  static inline bool folio_memcg_kmem(struct folio *folio)
>  {
>         VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
> -       VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
> +       VM_BUG_ON_FOLIO((folio->memcg_data !=3D OBJEXTS_ALLOC_FAIL) &&
> +                       (folio->memcg_data & MEMCG_DATA_OBJEXTS),
> +                       folio);
>         return folio->memcg_data & MEMCG_DATA_KMEM;
>  }
>
> --
> 2.25.1
>

