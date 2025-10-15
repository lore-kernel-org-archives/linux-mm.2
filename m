Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74795CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 16:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A30D58E0056; Wed, 15 Oct 2025 12:29:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1E08E0005; Wed, 15 Oct 2025 12:29:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8138E0056; Wed, 15 Oct 2025 12:29:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 801BF8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:29:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3CA6F1A01E2
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:29:31 +0000 (UTC)
X-FDA: 84000884142.15.403E134
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7D4C114000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:29:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p7H+d0FW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.166.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760545769; a=rsa-sha256;
	cv=none;
	b=lbXH/IF0L/izLLrUXocjMCyYPOmla3ELOVtdy8cQmrPt9HvJPJ76aeoCaGnIENoxw/DxgT
	f4uOQu/XH59d79w4NAVNquEKuR2ynjQqnEuI0mM2WqboXM354AQvFEMqyf3a8iSbfnN0l1
	Ng7KdLmUtsYwQuvqI14xwk04ajT37PI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p7H+d0FW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.166.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760545769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EPABWHgz0aje1cFhOw6wZjzCfYUS7SupNu8eCmm6K50=;
	b=18JI9Ef+4ujIR5BSisZJW1HbWqb8vFhRPFNKqwldhwxWlAqabFnlbu8I7QnBJ+He/VdtS7
	f7BRyF5zdjCGkYZdqiRKqM/4EDhh17KyF+lByhBw092ewZyGNjC8wA4Jg/b8jBl3CQ+JK9
	G9p834PLdj44nwbnRoZPBw9EjW77MHg=
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-42d7d0c58f9so398295ab.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760545768; x=1761150568; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EPABWHgz0aje1cFhOw6wZjzCfYUS7SupNu8eCmm6K50=;
        b=p7H+d0FWQT7wsg59PTQb1U5mMGNnclxagLi6x1zIpJ8Uxwr5pkDJ9yCBvPt0KP6JX9
         Vjjth4UdWIfjlxJtipOEh534J3c0VqTMdMjhteRmPto1XVlcbTtEi5Bn2KF3f42j9XDQ
         h3Z1H904HOUtjjcEOxFd2zfJvFjDYy1RgTyzgM3CDuTt5xr6C2SyLrS3kkJ9NGmkfanx
         vQAw90RPlmsCXCC5iTKi0RIAucGEnYuzjvYU8vKRoWdXll4ggSCsMJryfnifB1XWOEwp
         HB6hWqx9Ot+6XOiBmvH9vdwXpicorR9VwnjQCIMARUe/rpPTDczRPBhNTU67xgndOkXR
         ULeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760545768; x=1761150568;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EPABWHgz0aje1cFhOw6wZjzCfYUS7SupNu8eCmm6K50=;
        b=kyhXYCo/2jbCZ1Q24EN3oSiMzTMr5IZheq0d9z9lv9cuROnsBEb/rv1NVJbjIAlZbe
         mUdhzrbghIoIx8vFbBM8P0byGVZ3WlGCA8jWWOtXum93fW2147IaxFfGI2d/VrTNz33D
         tTCEgAJRKf6Byu/f2YbwpP8kbzqZ2g/1LItflDtZNf/6zQroIWEUcbGygrZJidina3kt
         5hyGbhoweSSHGnt1570FowGZA3doz7LCQNLap/lwaJyEviqd2ZR/CCA/+w4X0hRml8rP
         N8iNtWnv1yxJluL0W8BCg3eIhFIOB69mKpZkoUrhEmW6saXGHhWEzd+oxdTdxZzwaI2B
         PfcQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1f7Okp3Lm700itM39cK5+3LWcfvv8QKE7iXWNVtKFG6sak1/HSQEsSghge0Tt55UksZcN2EGEiA==@kvack.org
X-Gm-Message-State: AOJu0YyOWI+wK5N8dDPoTU8Etbg3HM2GPxs4Eh7W5rmkkmblsppbCh88
	CbcbqS55RXTx6PVeIiP5bDHQB00f8bC4f96qLt+dkpAflbdtRfiPM9C5grmUACDjTQIZoFVb448
	Nr2pH1I7DkqdlHJ4cuiFDA8dI0nNm5YGmwmX/QTgs
X-Gm-Gg: ASbGnctNdt8VbWt7JRCTPpyQT26YlIAx9tdKupvonwi9OGGM0NS+fPjO/67s7WwAPLe
	myocB0G91aa3S6ExPrpNX8DJ44ViwOC7o5VK5mve0ElUMqi8aMrhk2buu54UC3o6xZsnzfN4IYe
	Kv3DOgmf5XLtIot/4osBDg9GpYrrGBJlt8JUBIle/YGI/78YWA94GCtDMAxVRKLxxxrZHLE5Dzb
	VsPsYudLC4yZHfziQrvuJkMrXXdWwCPWjc+dYT82j0uT4KujAPgwcixVmBsJYF1u7AFVH8FgQ==
X-Google-Smtp-Source: AGHT+IGKGHbbfLh5CSf6ynM1o7L33zcz+2l5Q3BiEGunq0zKCeC+9lQM0pT75u+/Tc0YS0EeuHM7RhK/llM28VOk93o=
X-Received: by 2002:a05:622a:1f15:b0:4e4:6a1b:1148 with SMTP id
 d75a77b69052e-4e882ec9fd1mr7214141cf.6.1760545767796; Wed, 15 Oct 2025
 09:29:27 -0700 (PDT)
MIME-Version: 1.0
References: <20251015141642.700170-1-hao.ge@linux.dev>
In-Reply-To: <20251015141642.700170-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Oct 2025 09:29:16 -0700
X-Gm-Features: AS18NWCtUmLEWW8-7DUbvX8A5tHpZs2tgG7P4DUVEuwVfYnJMCjKydySlEmkCcM
Message-ID: <CAJuCfpEpO_HaJuV3ukDtTdw_5zCq9R0MnMexC5PoEwOcKWjuYg@mail.gmail.com>
Subject: Re: [PATCH v5] slab: reset obj_ext when it is not actually valid
 during freeing
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Alexei Starovoitov <ast@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 43uzybj7ogw3468aucre4m9ksu8d965a
X-Rspamd-Queue-Id: 7D4C114000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760545769-847631
X-HE-Meta: U2FsdGVkX196e0lww2f07+fKiHTL8RKlJfBSirIVCwD72QYJ1dhOG17t4xAIAMjlFkKffNRsPpDngOCHnqcvmsPnSFiBGaTi+T663LZ79nNfy/HdmzwqK8V33/St5ZQEvQc30UvQXH9EtQVOWNSUPfWUrraAYdBDyWfchr1r60tGr63HmS737Kl2URD9YlknTIIBF/JtoNgAhHEJlXHDoII1fZnfL89CiPtaFahiDaoETrkoNc920CZLNM5wYgkKp4WVBAb5YKKGdhBzHe2gSHIXZ6OSyFB//WtV7b42PD6DwFc9hvgB6oLb7ni0gF0vcUF8vxGwvfd4QBAJlj7t1m/HIyWEFDSusqhZJYD8q3c0lFzUMOSkAs09rPtPucN858dJ/aac8q4y+FDukdEA+DGR2SalCFIBPSUfQgm8ywyc4MVw/khxb8n91B4iJE96WfyuR4ZMo3WsutC8ZDKqSnA3RtviAUT7hzoyYHNGPv90XaHraY4nH1R44UOtxq0cW9lIzG6UcoHH0K/TniWO+KhhW53jdzUcLbHFb1/MU31SbKeELy2RSGD/Uy8OzXGDpRkCLExOitsMMYde+fzCgm9VXZUYCPg70L8CkVM5KWe2uvc6BRi/NhX0zIpGI2ynSnA9ouAT2xh53/i7BRaogq3ujNXT6ZVJrD2SR2cNz6Eng2HtMKepJErN43n/l9Lez+LF10pJR4ljts/2Q7pMzD08nhjo0nsxLiGEo1eZ70ShvL4Y2C1SL478diAc9Heonh5uPui+hWtuqW0o1SeunXMC5yRKEehlBNtyU6H/xKwPEizDf2geg7klk3qEagPUiFeNLddBLZYBW9TQu5YMDQxbJ7kZvBgRYTOLSDFZvq6j4PHWnYvNdbfGxV3+Jn3gkTh0dDIQ0cCHS93tQhlXWh1d7005OatDOwySOyqkerzt21odDo5NDg2cL4ocYvfe64nj2/5wOUI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 7:17=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> From: Hao Ge <gehao@kylinos.cn>
>
> If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAI=
L,
> But we did not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAIL a=
nd
> MEMCG_DATA_OBJEXTS currently share the same bit position, during the
> release of the associated folio, a VM_BUG_ON_FOLIO() check in
> folio_memcg_kmem() is triggered because it was mistakenly assumed that
> a valid folio->memcg_data was not cleared before freeing the folio.
>
> When freeing a slab, we clear slab->obj_exts and reset it to 0
> if the obj_ext array has been successfully allocated.
> So let's reset slab->obj_exts to 0 when freeing a slab if
> the obj_ext array allocated fail to allow them to be returned
> to the buddy system more smoothly.
>
> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> ---
> v5: Adopt the simpler solution proposed by Vlastimil;
>     Many thanks to him
> ---
>  mm/slub.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index b1f15598fbfd..2e4340c75be2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2170,8 +2170,16 @@ static inline void free_slab_obj_exts(struct slab =
*slab)
>         struct slabobj_ext *obj_exts;
>
>         obj_exts =3D slab_obj_exts(slab);
> -       if (!obj_exts)
> +       if (!obj_exts) {
> +               /*
> +                * If obj_exts allocation failed, slab->obj_exts is set t=
o OBJEXTS_ALLOC_FAIL,
> +                * In this case, we will end up here.
> +                * Therefore, we should clear the OBJEXTS_ALLOC_FAIL flag=
 first when freeing a slab.
> +                * Then let's set it to 0 as below.
> +                */
> +               slab->obj_exts =3D 0;
>                 return;
> +       }

How about this instead:

static inline void free_slab_obj_exts(struct slab *slab)
{
        struct slabobj_ext *obj_exts;

        obj_exts =3D slab_obj_exts(slab);
+        /*
+         * Reset obj_exts to ensure all bits including OBJEXTS_ALLOC_FAIL
+         * are always cleared.
+         */
+        slab->obj_exts =3D 0;
        if (!obj_exts)
                return;

        /*
         * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
         * corresponding extension will be NULL. alloc_tag_sub() will throw=
 a
         * warning if slab has extensions but the extension of an object is
         * NULL, therefore replace NULL with CODETAG_EMPTY to indicate that
         * the extension for obj_exts is expected to be NULL.
         */
        mark_objexts_empty(obj_exts);
        kfree(obj_exts);
-        slab->obj_exts =3D 0;
}

>
>         /*
>          * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
> --
> 2.25.1
>

