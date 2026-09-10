Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60A4EC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:36:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52DC26B009E; Thu, 10 Sep 2026 10:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5056B6B009F; Thu, 10 Sep 2026 10:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41CA86B00A0; Thu, 10 Sep 2026 10:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6B36B009E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:36:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DACBA0565
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:36:01 +0000 (UTC)
X-FDA: 85198102122.22.DA908BE
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf18.hostedemail.com (Postfix) with ESMTP id 373A51C0009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:35:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Of93RVaD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789050959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UERWUEx4a2PfB85CFmaCJZ/1wKYwdcKlHbdyKxQns2M=;
	b=6UATaGPgW7sQ2Hm6CQ/GMqiRhBhBuWwEQzRXhOThIdKoJwQqsnRtA5+AWm47BPCCNJGlaz
	6/1RnAgKty7W4cxbkpQjATKpMjNiLoGK1Cxwsgc82RhB1cNa2IjV316YfX1IS29AdYGJxj
	aWhtP0fmWrA5Mn1TBiD4BHh7PC3RAXk=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Of93RVaD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789050959;
	b=ylLHFVaC8Hwxs/aRSDVu46pFESREyX9zLqMHOz6hq0SZgA+/Wxuz1DDNt7skfX08YyfvFo
	J7n2CiP9WJOZQPMA04PGA/SLGeSms74uiV43mQMIJToEg6O20kNVN9Q4i0mcCd/PuLZ+TT
	Xo+Iq32KpPPLuv2XsB+dPGWaF/ZYut8=
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4ab201f9so1709244d50.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:35:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789050958; cv=none;
        d=google.com; s=arc-20260327;
        b=US9gwjrxDT+3PPPIfa5p2LE3FACU9nMI9zgCvR7boM2lxErpfPOsBtzj1ABC5N2jl9
         nNmTViBjy+kkxmuUCd8SaKrWkpyOJJ9ww+bp4AR8iWIpTi9FzCnQSpDC1ckXcpAHS6Hi
         Z5OihJwzfUoHDS5SG+NO6lVqUX6NC7ShuNdfMC/Wi7y9vYQmIy6dR6Q5CQfKC7E2+ymi
         ZtSAv0pxBt6QTBSE1uln5dYsWNKmpGNV//qZ5m5SIYBjuiBdBSUbliFXScXaJGCHMz1B
         6ENgbhOwPlAao4VI2kXjsE/MR7MHIdd4lR9FCLqIuaDl3yYNM2ti5sUq2mgVQ8vDmaSo
         V8Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UERWUEx4a2PfB85CFmaCJZ/1wKYwdcKlHbdyKxQns2M=;
        fh=SxiMlCFWAHjQOUrKzbGBDc+g+JsA0vTe30DqLjBxp+s=;
        b=B/KqNrj7sX7ylKm188s3GlyESGGkbeOr4XgGOv+qu/gn7Ljc9ttlZgCcPNpnE66W3x
         hwLO7fvJ1zziNyPeWpLD9I1IBiHn2hkQEjaGWiU2r2DuNVaniZQrFG2bPfUC2CfrkznL
         joOlcSc2YXl4vwPSjpEQsgJWiwtRzqMGweWRYSC3GBBO0rAo1ZwAK2enwJXECBCVmcc8
         i39mPue92z91jvvLh6mMiuJvyqtTd5Pn8fxcRFViuRXyqo6mJLflmz6eM7MZfjaAJEBG
         ancAdoZDuCM3e15BKlweokCuk1UltRQXSdDssBKuQ818aoGoB21uhVtrAsimTznvYGco
         xfoA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789050958; x=1789655758; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UERWUEx4a2PfB85CFmaCJZ/1wKYwdcKlHbdyKxQns2M=;
        b=Of93RVaDdSBB2XYixTEkIv66g7yr+ZHFJ4rswYlAP580wrD4jqeKH0hoYP8qdTDKiS
         4SBBn1XY8CIJ8Q9kAohKETK2ooF0gsjYIF+/NfTz6T4BxQ3llLAsI6X60GgUkVFYNBhC
         f812XJb45pqebTXE/bk2sT28o19pC9Edi/GvtqDHmrXTxR8o+BqxzPo6qQ/VYpH2JIAX
         TbdztPGduDy+U+v6EjNSESqzgHpoQoXhlNBnDwF5xeCdSedhUJyk0D4jnEapXRlieW/I
         R20+q364/bnni5Gg1pLQNWlZIHYinUI0QlCrSTiuj72i9jM5zt9/knaB6lYr9iSA9srj
         QicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789050958; x=1789655758;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UERWUEx4a2PfB85CFmaCJZ/1wKYwdcKlHbdyKxQns2M=;
        b=neztALSX9DCz9DQ+fc88b27qdPKGltc853nvjtIEuDTd4ELY1ss11claCyPuCVIS9k
         exLZ9ctfTXDq0ky1UQXbJc464zBp/YFgTgEdmU2vWJbY/EL7ukoWIjrJV/2+Tc84CyLB
         WGM766qIFxKsyG+ntCgKCletIjekoY3oejNbaiDoEXozJDptOeRhM/HXI24a/RStgeJa
         Ajx6jYiNfI/f+5LshoQ27kShd8s6X/Zj7RaYzExsskd9wMbFNeqRmHp+AXrHWSp/wfDH
         C+3GvNUJzvZN4TioIdtWUbF3dJMP5ICJYhV3AZzceNAufxKuuTZdvStjInnDDOGu7uvS
         MCCA==
X-Forwarded-Encrypted: i=1; AKwUvBwee6AP6V4qlYkeQ+PBAV7eQzU/BHTMIL+pGGesNVdXZoF8Qr4zQsmEJb6zu1OnRp9o/qLvCHnAWw==@kvack.org
X-Gm-Message-State: AFuF++litoZhQoxzg28TfV+9PHvd6ESFT+N3euTJ/TlYYjoOprs+Fkr9
	Pue+/cPdhN5xkGEKeBCQzfeEmJxI3BFghGUQwhwgoxa4mol2cR6nEl4TARM6YfY8cWDcRFvrgBR
	7MGqzgeov/oyXuEA7nbJYq5EA61ClX4U=
X-Gm-Gg: AYBFou33QaiUgNXMOlZPPUGURjMwbaFEHfxUOSBss45cqRbRoCJM5U5o1+Rb2MxKJgF
	GccckDt+AtO2jnFIpSZ+oSSXGgoW2zCHXOWM7riNh1SEcKePpXzrIaYGpHUY5Ns8bsQPTVO+odf
	+pJGmqInnQesG/vMvsqelm1QFEjHrAbLnLB9JRsvEfzjaVIbhf4auTIO0rqfhlTKgHHPmAyMBcP
	CVir3c5ejDD5uvFCnkFrz3seSo7ciK9zGHrVeCtOv2dJYfEVSLKZYWV4Tqt6tJaZcIe5LLa9zLE
	gAkBm2JcXnzGIiIu/9bHGZXj9rUb/OHQpdcxipgFV1pJb60GfKxRGw==
X-Received: by 2002:a05:690e:4882:10b0:671:7fb:c9a3 with SMTP id
 956f58d0204a3-6710fe4356emr2546606d50.15.1789050953572; Thu, 10 Sep 2026
 07:35:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260908165733.1703766-1-ekffu200098@gmail.com>
 <178903430147.1489479.2162515570306846533.b4-ty@b4> <178903518466.2710705.16546329711992780120.b4-reply@b4>
 <CABFDxMEAkqGhXc93crUKjP9bKs2xh1gb0Nt32jzC08qSADJjRQ@mail.gmail.com>
In-Reply-To: <CABFDxMEAkqGhXc93crUKjP9bKs2xh1gb0Nt32jzC08qSADJjRQ@mail.gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 10 Sep 2026 23:35:41 +0900
X-Gm-Features: AcwNN1U3wgeoQZ0YqFwVZ6jyhiyaup3WV756zXmY2xr5u7jxJbmonhUHZrhZNAU
Message-ID: <CABFDxMGHwUrssk09-2j0yoQh9AVHTqoJDmJw3o8k10astr+bsg@mail.gmail.com>
Subject: Re: [PATCH] memblock: use for_each_zone() in reset_all_zones_managed_pages()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 36bf7fg3tzqramboyakgno58wwte3ipi
X-Rspamd-Queue-Id: 373A51C0009
X-Rspamd-Server: rspam07
X-HE-Tag: 1789050959-121592
X-HE-Meta: U2FsdGVkX19sCAC39ZPt2ngez0QARL2LWkGd2DCiprQW6cnKZLX3fHCe3JifOv958eeijpwRlDqN8Zoy1gCP289aHCH2hLyr+cpgv3lo1/dzlp4aLdf7mF4nWu51TpITpKjnungLmdrjnovAUQ1wxAnflpwQCjHQ9RZFepvXoVBAGWSidJJnc96YnBV5fLRkTICG8gjh0hqkuJcuIXp8fuB6ytQbsWcA3hwRABK1FRxIbdTFhRJD8+k1pl2iWVOwdvuj6Ll9nu06YFEXbs+R4leal0lKOqIoFOLUQChb4s96eLBSPYxSzCs1wXThLiHeUJn1ig9ahOvH1xPGEAgiaunbhTUqdQ1wJ+8rMW0B7wf+TFlFmNCd0d7jiXOkrLAsn5ClD/9T/6xQc9x5ycj35Ez9DT2RvmhxJiPD6Tl1/6QPPyuMmalCNVvIrArG3lMD9jjtTesPJm4y3I3dv7IQSocTjNnlyUJlerJdeVxGjpSboWDn6CBNNmAMya7y+fo5gUPnIbdW9N5OPUVjLusjuizbKesiehjIuUF/UU/AH0LfF0s+LrVR0gcR/0Hv3UEYcxI2QYYXqoe3shkR1ctaxMnBrq9NTiU6ZxmYrOUwJphsALyBOTq+Zob1DYCLdfPJ/DGTrFRioMr1snu8fhAIybPjnn/W7pl1yVrs4h6tcxNstAW1U3nc17252s4DOBjosmEExqfyDa6lxGv+465af/XZQYuSH6MqD9Y2Uy21rBeO9bi4Gp7I1fT95OFVS6bSad+g1F7L0yxyrnaVKue5kBBmHhtBskiDeUpj09e5skW6l+kobdeLcYRpPTwYiTsWEtCQ9b7xlWkz6na5ZFcMu9E5DPx706CqjhgOA+VCgvHRV4fZgOzRStMw0GNo1+IQ/o9b9G7a8F8TGdcb3jXcMufolO9YO2eP7L6tEJTuaQfHli0bYd/1tZXkqNUeCfLR7bEVgN4WKmQSL2Zfe1i
 EfMI9ecZ
 B7V3ZlrxaDM8GQRNk63bq/KZ/+M31zedvBbkHRWjMbghCIRtYpi5KhbW5U+RwHk/HMWX6IeTbm6RJhhysALnHAfkzOsA49Wrcxkd7SbZ+bCo40LJLXgDB0GceIX87wJ/1z9XJQLEQ4aAhlnGGYwFnl2peGMVLLo5DO1N8RKUx/t1lTqRYrpeFtmA7GZpATNWqfI5zYyLsI+v6bqO9jJHXr43/mvumJQq3zk8B9n/4SjM7OlGcyUDqj26AfrHQ7yWBNCH3/xFf4sXGAuRTrQGh3G/J2FyPBm4CeSFDowtCni5Swwl8LM+JxmD5949vhfhCD72KmH+etrU7WVefoZ1bobWaXowg/WvHthRlCB4d/Y9yJubXgQ3vLjiyNTWeCS9293DKqnWluzfFx00zvARTZ8tpAiqOCr54Ai1EftlnZuhGqX7z9gx4RCmW8V3ywKihGXvZPxLzmUtjETE8ytSX3AjQWMzMmvdX00Aa+E5Xl8cV4G0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 9:19=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gmail.c=
om> wrote:
>
> On Thu, Sep 10, 2026 at 7:13=E2=80=AFPM Mike Rapoport <rppt@kernel.org> w=
rote:
> >
> > On 2026-09-10 12:58 +0300, Mike Rapoport wrote:
> > > On Wed, 09 Sep 2026 01:57:32 +0900, Sang-Heon Jeon wrote:
> > > > memblock: use for_each_zone() in reset_all_zones_managed_pages()
> > >
> > > Applied to for-next branch of memblock.git tree, thanks!
> > >
> > > [1/1] memblock: use for_each_zone() in reset_all_zones_managed_pages(=
)
> > >       commit: 0876b2d8794913c867a1bb0dc3fd22ea1c5f0a95
> > >
> > > tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
> > > branch: for-next
> >
> > Hmm, I was too hasty.
> > This breaks mmemblock tests, so I dropped it for now.
>
> Sorry for the noise. I missed it. I will keep it in mind next time.
> Just give me a second to check.

With the below fixes, tests will be fine again. Is it okay to send the
v2 patchset with below fixes?

diff --git a/tools/testing/memblock/linux/mmzone.h
b/tools/testing/memblock/linux/mmzone.h
index 8d934ff5b080..631fe07923e7 100644
--- a/tools/testing/memblock/linux/mmzone.h
+++ b/tools/testing/memblock/linux/mmzone.h
@@ -7,13 +7,20 @@

 struct pglist_data *first_online_pgdat(void);
 struct pglist_data *next_online_pgdat(struct pglist_data *pgdat);
+struct zone *next_zone(struct zone *zone);

 #define for_each_online_pgdat(pgdat)                   \
        for (pgdat =3D first_online_pgdat();              \
             pgdat;                                     \
             pgdat =3D next_online_pgdat(pgdat))

+#define for_each_zone(zone)                            \
+       for (zone =3D (first_online_pgdat())->node_zones; \
+            zone;                                      \
+            zone =3D next_zone(zone))
+
 enum zone_type {
+       ZONE_NORMAL,
        __MAX_NR_ZONES
 };

@@ -27,6 +34,7 @@ enum zone_type {
 #define pageblock_start_pfn(pfn)       ALIGN_DOWN((pfn), pageblock_nr_page=
s)

 struct zone {
+       struct pglist_data      *zone_pgdat;
        atomic_long_t           managed_pages;
 };

diff --git a/tools/testing/memblock/mmzone.c b/tools/testing/memblock/mmzon=
e.c
index e719450f81cb..e73848bdc8d6 100644
--- a/tools/testing/memblock/mmzone.c
+++ b/tools/testing/memblock/mmzone.c
@@ -1,9 +1,15 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 #include <linux/mmzone.h>

+static pg_data_t dummy_pgdat =3D {
+       .node_zones =3D {
+               [0 ... MAX_NR_ZONES - 1] =3D { .zone_pgdat =3D &dummy_pgdat=
 },
+       },
+};
+
 struct pglist_data *first_online_pgdat(void)
 {
-       return NULL;
+       return &dummy_pgdat;
 }

 struct pglist_data *next_online_pgdat(struct pglist_data *pgdat)
@@ -11,6 +17,22 @@ struct pglist_data *next_online_pgdat(struct
pglist_data *pgdat)
        return NULL;
 }

+struct zone *next_zone(struct zone *zone)
+{
+       pg_data_t *pgdat =3D zone->zone_pgdat;
+
+       if (zone < pgdat->node_zones + MAX_NR_ZONES - 1)
+               zone++;
+       else {
+               pgdat =3D next_online_pgdat(pgdat);
+               if (pgdat)
+                       zone =3D pgdat->node_zones;
+               else
+                       zone =3D NULL;
+       }
+       return zone;
+}
+
 void atomic_long_set(atomic_long_t *v, long i)
 {
 }

> > > --
> > > Sincerely yours,
> > > Mike.
> > >
> > >
> > >
> > >
> > >
> >
> >
>
> Best regards
> Sang-Heon Jeon

Best regards,
Sang-Heon Jeon

