Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 934D4CCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 23:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC30B8E0018; Thu, 23 Oct 2025 19:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74768E0002; Thu, 23 Oct 2025 19:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89B68E0018; Thu, 23 Oct 2025 19:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A742A8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 19:13:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56EC488FDE
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 23:13:52 +0000 (UTC)
X-FDA: 84030933504.04.E1A1AA8
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6E39B180003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 23:13:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IiqRH7tV;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761261230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Y/mL/4eaultc1EWojfIyo8PsJnaNID3tRHJJgL28LY=;
	b=TZAlZu78QQ9dOnPIsG2bBT2PlKADAZu354ICrWNPN2tvT2mScOzX1Q6kpOsehvCETXT5GX
	1AtTQZoQm2Nhgr1zGo423fWq7TvKKbmLAEYPzJY0UIs/pDj/TNWi2Lg51VFgkHZvmjc0Ky
	qsH/ZhJwCnLp4NWdIIrlITfOuNysxMs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IiqRH7tV;
	spf=pass (imf24.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761261230; a=rsa-sha256;
	cv=none;
	b=Lh5kXEgDxX1iFWiopEnoAocbAjfrDTqPnjqlacb3SQ8vdKTj8gW3I4DPlbVVPW36r7Yn3z
	DQHNe420wcerju3dfYwWjT//ONpZ/VYkw+oteoz/2fKnvJ03B1YzregAt9zdRgbre23msH
	VCMjBXyKSbDpYP/uuBmi2ysdzs2kMAM=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42966ce6dbdso909902f8f.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761261229; x=1761866029; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Y/mL/4eaultc1EWojfIyo8PsJnaNID3tRHJJgL28LY=;
        b=IiqRH7tVWAdiNygKffGYXDGJ0+MR3rJ2bBY1yQPwcDiQA8zbcS6c7olXa0NC+zH/+y
         Q1zc8jkTyGS7Z3A57IZ6FEe1Wy7uOyjUkzqxvX6nSurqBC7xvD41tFRRyJTbz9WRl6nt
         BRpwMZxgkoNpjmSMlIlEe4cIlhKNYzkedtwAwFA3/U2raKK515kGSOs7xV6LASr8Io5Q
         p+JjTAEBr+6wOLqtlZH2GRrLTfLoEuMuH74EYG2UZ1VEXO3G8TF9Hjj5KRPVuLeY6/BE
         AzBDLgG1T1yWvUe8rJ72P+x2noSg5517mRkCP/QhlXyraWWeQbxmdcR58PWdQCLfXBA/
         TH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761261229; x=1761866029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Y/mL/4eaultc1EWojfIyo8PsJnaNID3tRHJJgL28LY=;
        b=uao+LbiZ9GB2aoQQq5KFZCpb68OwgJrfla6AOqgSIZSZgA6XdcBHonMBtJPMonSsmv
         cxlb6sfCre+bC7gQeSFTu4LwJP5kiNmAwCN2YKh/5gEtWj8kI47NL4lSrVN3J6ogeeho
         +D0gBaKUBHVuudrXSIUMKGjRmMuWNtojUZR4i+e9dsJQ+qMT1aTh5Qwo5ZW+hcSSn+DQ
         3ORj2mrAIFjNjM6REnPZ9CUkdtORxdi/POdxNgwEs2Z5NXgKEvBVpBnlg/E3uVZYvNWm
         vCb8zXg/AWefccNVys/cMsKuuP3tOjfpM93/W2WrV1ortYJrXVBYHl/+rE7N5rurMNbu
         UWeA==
X-Forwarded-Encrypted: i=1; AJvYcCVC1BixpdEnLiAhdh63CYDiTDFKObKpK/tz2PkHzDsYesHibSNsBHFWOpiYqxdO4WV1Ag4KzYFo+w==@kvack.org
X-Gm-Message-State: AOJu0Yw1/zHbK17Dak3lhWPbZBeJE4iPlykP+Tj7O245uA0tA9FsKwj4
	RdUup0BDlRiOkV/H4B5waYhR/6JLW8tp9Jy3/pQKk9Irg9iJz4GEHL7G993qvP4OweEGIa61dle
	/KAIniBA6/+I3mMtuG6nJaJVmmsme+Qg=
X-Gm-Gg: ASbGncsGUvF/S56DMUxQ7+7RcIcW/4jN4g9/tTqMgvBTsR9qmno31uJHOxzoS/MQRu0
	bU3npXoahTn51XCz11cGOPu5ddoRA41vrDHNzwDh5ORiQIQtAHgZVcYrJILLhOpEouNtRU7RvHf
	MD/Grah+bY1BekoR1t7RVYTp+1wyo9cqCzXdnj4i2Bcq3q0drnP/sZhuMcj/fwmdGp4jc8KYf/c
	mI2rTK5ZR949goN/Lgx6B+Sz2/3TEIzoY5Aq/0M7SZ1XY88yHhMa8gNG8M1NaGrPIxzLksOFqNP
	k/w3V5Ban2u/m/GNSzF7A3ktALE8RaKnjQR07P0=
X-Google-Smtp-Source: AGHT+IHcYKGRd4bWLykcRsWt3JGipu6QnZXYSUEvMKhBqZJGUVrkpfb+xY9h71be1NTcAIdFAFFeu9yDKWG6eVaN6Yo=
X-Received: by 2002:a5d:5d05:0:b0:428:3ea7:4473 with SMTP id
 ffacd0b85a97d-4283eb68979mr14692632f8f.39.1761261228527; Thu, 23 Oct 2025
 16:13:48 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-fix-slab-accounting-v2-1-0e62d50986ea@suse.cz>
In-Reply-To: <20251023-fix-slab-accounting-v2-1-0e62d50986ea@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 23 Oct 2025 16:13:37 -0700
X-Gm-Features: AWmQ_bmwCHOVy3eNr0hpo0ixT1MxbquvOBvpoyqeHClPdJfhgqBzqfF_YadwU_o
Message-ID: <CAADnVQJS_RUTnpCX5etS_qGD=jgHjtY_Mtc5GQqPwvyyTfghdg@mail.gmail.com>
Subject: Re: [PATCH v2] slab: fix slab accounting imbalance due to defer_deactivate_slab()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7u1so4d617inhkbhu97cgbkxckn1f36z
X-Rspamd-Queue-Id: 6E39B180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761261230-54675
X-HE-Meta: U2FsdGVkX182PxCKjQ0nuEDaFSlwMWCAKhX5OCQjUvRlkOSWPWn2eZwDdEK3ipJG+xEe0wQHLj1Sck1mYQ5ozfqTUG3NVUfryxuH0KqhQ9YOsVXY5vry8MKQI/VQREwjZ8Lto1OWM6AViyfasIhbWzbpJZu4Yn2OQCnw8vANU/xovg4vy0mdl0ypG1ZQU8JYAI6vwFGKNwB5u1/17mt3+QTTZR4iCvj962GjRfhdH3BMnVO2MNcoJuQPrQEiGYBZr53p1D+pOzqDvHYmUsFZzDZU3BooJ2HU3AuwqrOP7MTVxCye/cuMea2S9R+hb8Z5nkapxKyhyMnWttRpy3eRuZziCfgiUdugSGbmTsmZeKbMQ+Ldbny0gezomuSjqv6F9kRylPNEhUl4Fi6bq3OxtHqxPd01/b7DJhfDvqXj24VOnzbT4/NZNZneMBtStCH1/Isq71R9ydJpeGa2OrhAZuXL08/igjYSGdS/Q3ulWQlk2g99ws29FAOSBz0KNcoMR8act/LdlFHEfOgROx/rTMTHJYUwdkbH1sjftEh2dfVlKB3elrf7AlA7GcDCMzQS6vTfwLhT7Ujhj2pZ4FoUu+BCKGQ1Ov973mvo7+theevojXksO3FXTKNIXSUxiDiaDlszMnbLqVCAtBAqiKgdsauRWXDZV6rlGlBPdvaf9rSOwVn6t3d9RlX0WIj93RVkMh8y6pOTNV/iJ43s4ecS69RyZilcpngK36HTcsIe57Cf3XewmQ9egZvgqkT/z7f/RDD26p59OvCrHPYD3l8wLuwYQ9C37r2Y2LtLC8V5/xCM23OwvGBx937c8JLLI9N4O15YWfnXv+zciSiNMAJabrUKYq1NYjpFxgOa4PseD+oAkdv2+8HNJkan18Q6xKjwqtYz5nL37ApjLn3L+Y1WSQGPksRKwHQRPtg/jej7hoNhRGHXFo2EpPPJu2amQMhRQTFz98X/o7ctpucTE6g
 w2wnCf58
 NAPagOSzLZuLhtxjQV6h2M9hB6b7EAneH6SaqC4zuecRYhCaQ9zoLbQLD1NG09FDLrMr60Y3ac3FvQWe3TQDhC7iHPXuPu4e63weeimeQDeyeHM/IVNYxrYKFHGsW5zaSnUcFFk9y45yupWSEEHUb8aMYzPRTVoNCZjMdSOttrneS90DZhGq80WBcGKWhzgtF6rk3fb5FPAgcvub0fUhSJ0F1qy/q0qEEV9KQA3S8rq6AsGRTPgh5ctkoAWBD8ovF411Kq8456ibWmGMcVuel+AfosQaHyYUEHyL6t2bCV5Hm6PXF9vsAWZgKM3hzVJOx3YOCf9RcNlZluw9zsR7KOKxQ3AKeindodl0YM4zZX0UCvRCb0Emo2P69t1XhNvnr2I0Xq048bs9/qMybKCTck3BfyGOzYiwRYUT1SC+ymngMTU+ptD8l0a5Np8ZEAtM5FPmLs8VmYEE1c6EBfDLdHhJkJ422Eboi3MZxH50bI3i0wYtV0kjl4RK2oMI8I7czxkz0ixBsP4Rq2ug=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 5:01=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> Since commit af92793e52c3 ("slab: Introduce kmalloc_nolock() and
> kfree_nolock().") there's a possibility in alloc_single_from_new_slab()
> that we discard the newly allocated slab if we can't spin and we fail to
> trylock. As a result we don't perform inc_slabs_node() later in the
> function. Instead we perform a deferred deactivate_slab() which can
> either put the unacounted slab on partial list, or discard it
> immediately while performing dec_slabs_node(). Either way will cause an
> accounting imbalance.
>
> Fix this by not marking the slab as frozen, and using free_slab()
> instead of deactivate_slab() for non-frozen slabs in
> free_deferred_objects(). For CONFIG_SLUB_TINY, that's the only possible
> case. By not using discard_slab() we avoid dec_slabs_node().
>
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock()=
.")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> Changes in v2:
> - Fix the problem differently. Harry pointed out that we can't move
>   inc_slabs_node() outside of list_lock protected regions as that would
>   reintroduce issues fixed by commit c7323a5ad078
> - Link to v1: https://patch.msgid.link/20251022-fix-slab-accounting-v1-1-=
27870ec363ce@suse.cz
> ---
>  mm/slub.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 23d8f54e9486..87a1d2f9de0d 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3422,7 +3422,6 @@ static void *alloc_single_from_new_slab(struct kmem=
_cache *s, struct slab *slab,
>
>         if (!allow_spin && !spin_trylock_irqsave(&n->list_lock, flags)) {
>                 /* Unlucky, discard newly allocated slab */
> -               slab->frozen =3D 1;
>                 defer_deactivate_slab(slab, NULL);
>                 return NULL;
>         }
> @@ -6471,9 +6470,12 @@ static void free_deferred_objects(struct irq_work =
*work)
>                 struct slab *slab =3D container_of(pos, struct slab, llno=
de);
>
>  #ifdef CONFIG_SLUB_TINY
> -               discard_slab(slab->slab_cache, slab);
> +               free_slab(slab->slab_cache, slab);
>  #else
> -               deactivate_slab(slab->slab_cache, slab, slab->flush_freel=
ist);
> +               if (slab->frozen)
> +                       deactivate_slab(slab->slab_cache, slab, slab->flu=
sh_freelist);
> +               else
> +                       free_slab(slab->slab_cache, slab);

A bit odd to use 'frozen' flag as such a signal.
I guess I'm worried that truly !frozen slab can come here
via ___slab_alloc() -> retry_load_slab: -> defer_deactivate_slab().
And things will be much worse than just accounting.

Maybe add
  inc_slabs_node(s, nid, slab->objects);
right before
  defer_deactivate_slab(slab, NULL);
  return NULL;

I don't quite get why c7323a5ad078 is doing everything under n->list_lock.
It's been 3 years since.
We have an empty slab here that is going to be freed soon.
It's effectively frozen, so inc_slabs_node() on it seems like a safe fix.

