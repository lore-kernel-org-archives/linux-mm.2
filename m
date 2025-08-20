Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DD3CA0EE6
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 00:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9E08E0009; Tue, 19 Aug 2025 20:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0E88E0001; Tue, 19 Aug 2025 20:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC71E8E0009; Tue, 19 Aug 2025 20:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABD3A8E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:39:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53AEC5820E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 00:39:30 +0000 (UTC)
X-FDA: 83795277300.20.4B5EA83
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id B73271A0002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 00:39:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AM9fsCHn;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf19.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755650368; a=rsa-sha256;
	cv=none;
	b=wMJ1z1T3Jgs2txK41PXRKosLV28Ke/46bsa0M4P6uWj4ZHK3YGef/1PU0B1eJZ62vRBZAb
	kDLEfX6d0+1L27c0LA/uQIjvfABEhKF61VXYhjSkhCzHbH3XPZtyHgMVkmSY7XVmLuE5xe
	iMCIGTiWLm2nfDbyl5bQ5uXHpAQyv+w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AM9fsCHn;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf19.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755650368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZLOgOakm+kbXuiWKsG+J81Fb7iSgA1HKL74lsfZzlc=;
	b=OEcTcXQr/0TyBa+kak2Ld/cL8c3r/6KnagmG+zb0zVyR37KyK9vJcd9Yx+dTQDT3WyKr3Z
	OU3vVQaT1YGtLI5TV9LnyMNlpals4BZ6ctSb1BihmNgPew8nNw3nhnzXsj046GalZUtYAE
	BHN9ngB/cfWLMsK+yQJO8djTZOPPjzs=
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLAthF000590
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 00:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	sZLOgOakm+kbXuiWKsG+J81Fb7iSgA1HKL74lsfZzlc=; b=AM9fsCHn8QL+D+JE
	G1UKcmlhK7p5oI5iqRxIOqI1Tec8XCsqedvnvBW0esUkYW0iSVvoQBRfDY/L23In
	60EvR2ZM8N+fQxWsqZL29C/3oU+MwCqP630WSPgSLR5MAbbKi3dQ//UPHqYhCngq
	AtXwJohghgYfZxM7v4mbWayKFnzdxOZbxRheLSfIyT9YK6DuOZtwtpNEKMPmkvl9
	fG9/YW5ZqsWZ3CJ6GBrOJrKJ3yhRfxmO5LNEra6NqYYM9sqRlkY7IMLFDKux4m6n
	QiEHqA1wHN+QyoTwvplUNdSckATboOD1gYHqHYx5YcON4m1tb5p1MTNpUb0Zsykb
	qe5+TA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48n0y38ct7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 00:39:26 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2445805d386so64153175ad.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:39:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755650365; x=1756255165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sZLOgOakm+kbXuiWKsG+J81Fb7iSgA1HKL74lsfZzlc=;
        b=iyG+4y2uigKTcrPFfknbrPSnCTRcHK3N9NkE9K/gleeXZyL1QppRn0JIU3L5XlYZsp
         uaK1pvR8rvQOoWwYBKG0FZAOUrFbd2unvNuv7hO93JHjsJVnnbk7Knn+d5kTdKD+cS4m
         3Pni/oiHyY9TWamPxyl1XpT/6QyvHzHgdL1n6nWFM95TSTNUya2jxaJsVuPGZiVBEcZc
         Hy/qtRXzcIelp9TdUTcRLg0g0mDxmJhZyXvgXP5mgtXDWm4EAnN2BVMOdqwr+1h0Ypjl
         9CtWmX6+cEmaila3RcsuipcurmVhcQIPb+/Hb+1V9DEhpE0z4puW7EUbmXNmzChxJacV
         aX3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXDePOLFWmqlZ2hQkNWnxk0PYkJrvVXJo1k6vRnFhCt10FKf+0BO8K/uT5y7KhXErXoVnIQiJEsBQ==@kvack.org
X-Gm-Message-State: AOJu0YxDdcioDLRSpmPzAw4FJ2DndRpkLO5bETwMETijXExLDrrJHYtk
	WPuYaTssG5IIGc8a2Uqtva/9sbmbx2ZRAQCGXtpsj3uTgEsKiecnEvvIkSIKmFq0x7D4N008rAk
	8Cn2UdlQ3jSMe9FYe5pWaxILlWgfm7AJSSuKggvn6tmCrzwF7ttC4FxgEJQQvquhxvlJf835iVs
	0dcwVgFsMgBIoGnEXgqAJQBmtuJegX
X-Gm-Gg: ASbGncuGcBK8cDR7FNads5nlNXm/c+8UmxF0SlR5vW6Ewa+RfMR3nQ7dud/ZpSGCKIg
	sArKU6HWANcBQSw/WofLOGOEnCL3OzpJJaCoJcQ/9QMomDvuRz8ZIC0ZQGByEyKsnd2BID2yP4E
	ygVpEbMUL6OKluHIbrULFTaA==
X-Received: by 2002:a17:902:f0cd:b0:240:58a7:8938 with SMTP id d9443c01a7336-245ef0eeda3mr9115555ad.7.1755650365076;
        Tue, 19 Aug 2025 17:39:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHE+lwzJc02JwGtvQsFoWimeOv9a5hCP13MeNKKTEHXQTeefVF7wVVw5AarZciu+sMP5CbvXWOpoOD+dV+l/zI=
X-Received: by 2002:a17:902:f0cd:b0:240:58a7:8938 with SMTP id
 d9443c01a7336-245ef0eeda3mr9115375ad.7.1755650364589; Tue, 19 Aug 2025
 17:39:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250819-numa-memblks-refac-v1-1-936b4fd35000@oss.qualcomm.com> <aKSNED01R-AaclOT@kernel.org>
In-Reply-To: <aKSNED01R-AaclOT@kernel.org>
From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Date: Wed, 20 Aug 2025 06:09:14 +0530
X-Gm-Features: Ac12FXxe4_RLjord-WMcAQ-D9q1Jse-uFVm7Kpvg0wqknococsL8UbxY0BY33d8
Message-ID: <CALzOmR2zOpiN_u1GfudY8QKWOf=w3ytOPuK-dznY7bqKJgJGnA@mail.gmail.com>
Subject: Re: [PATCH] mm/numa_memblks: Use SZ_1M macro to denote bytes to MB conversion
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=Vud6w+2n c=1 sm=1 tr=0 ts=68a5193e cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=SxtzLQ3OghRKqkiKGnwA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXwcbO3/LwtIDU
 tq9G/2BxGN+uZT3F82P6V6rqYHewaChqB5GAyBeG+qxrUzeAxuwqyStgZ17l4nbPOVnuKzeOag3
 IzoZ2nLrEFUaS9Z7lCpARwXQI/YtgI1dqCC9aX4mIehbs6b4LdJAizvG1cHbRk/yGh70aYQc+xu
 TFCUIUySpJ4u3knTbbdSv4eb4T7RObwr03kdjxA0B8FITy98hea0DUFtxBuv80kgaltqmA/fq6j
 QABpCV1OpBSFpd6d0Jv2Vp7ZWhPqtYA72l0TATe+KwUO2cvmZ2GHqtz+u9PbBTyEBPTDFUtm0vY
 xfNe48B9UcAFnPuiW2GdDYzyEXp2MqXt8ZUgvJcqjp1e20pMaAAtT2QzZ77DjnzxQIf4g6uTo/d
 Fmm4Ny6gn8uSIMrPOEsOgT3rV6XRvA==
X-Proofpoint-GUID: x4BDSb9hDSfReLIp93LFhfU2ibnTI8wH
X-Proofpoint-ORIG-GUID: x4BDSb9hDSfReLIp93LFhfU2ibnTI8wH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_04,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 spamscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2508110000 definitions=main-2508190197
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B73271A0002
X-Stat-Signature: b3nchy4sus5ndxgndcgjqpzsj7y7e4e6
X-HE-Tag: 1755650367-499948
X-HE-Meta: U2FsdGVkX19g5LdtpR8wKbXmIAuW66y29yb8T4xV/IJ3+k/iU6QWtw1AjQYcTCUS+Mhml+QxfxlOI05wf60ApZxZa14wwX/EhH+SUc6U6nGgLGlDndUpGaOUN5G4QzbBR8ySY7AsBDqbE8sfFcRjEJz3m5GINheyO0zm2TufO7JpJgU6de8r6UzhMmH3v0IpOqOgfKQRyGCzlEBlFX8tdI4syxThS6lk3Ygmh55t3zCGM7B8RT9GPhdkFK4Dq/Gp31C1oIdxClePSMmn3cTV4tlzKzDn5BrrudgQkdk7QDs3eCSbaa830BWdus1FpF/KquYNTLbvUZPfWtl0GS7WxIr+EZXsYmnT8WL0A344KV/FzojN/wLPdFx/ZedHQ1qyp+2LmSruOWCttbX/wKJKLfssvcC1Y426fEWwaat2hef7gAx9yqdRZron2/yORhKhbrN6cxCaZ5UGuA3caDHBrWKcxRgJW5Ln/A60eFEqmW55acXGXvgKtcvime1FKRhA1BITUUtIeH0uPfmcU5RFL2GORfpPS+mgBlHdZG8VYWfkC8AxdA8vmvQVsGEgS7D1iZ2p0UM9ugh65e+coTmvD9q4oKGgBWMpuyiMKXtQWerCTW+CMVByCKhkfCOrUaID4XYEdevvyxihMSpi6obEiLgayBkLZVlVu5oGcQVbEZ3sr6UtfYYjWPBdBz4RoAh/noCq8kxUDDI592haOINzKOTjVucy04BthbeWfqgyb4Oyh6eOs7Y+36Ve+JPr6o4SaaArPDyNwfyxIcg4m+777EYkshTnZdYD9iycW3HIBeyWh9DLD53kxV3A3tCdItS6YAlS3S84pEyK5KnDLx103OD1zAdlAVwbGoQ3Rrlc7fBy/baqoSr081i9HGtCTYU9jtCprJHN1yazSZiwr84rSH2ckSWatm2NSK0TEj1GXS7jEfv4ibCv9mUoafcwslyGlaH9zpAyWMQOe0w0+zL
 QZ6mUdEX
 Py7kqkLTCgJMEQL8/1eCxC7AEOWrMvY4NQ+zCo49YW2wm+1/VL6psncp+QMyu0Y5TVvZTCgwQrMDJfko4cW8Bu+JpnfV6tx5qJbislx0MoppwYTG2viKADcWLFTdyMD4wobTexjqCgNF1bY0sC+1CNYtEhQH0aa6FJvb6cUB7vXWYx0WA4KwsmCecG2SAmRHXOdEHbVSmtKslIX1kKcjYP5BkwmTEbdgfBAzv3Fjl7dB+fMCF7/gZIzPGpFZjwLVYV3oqAMLeMBLXYQkMJC2hVnEYBq4GBLyJHGm8ouQzmxqlgZvjannel6ptGCmt84AevzgCS0xiPhWeewdqgI4aTzc/HTP6Upjae1lXCSGVKhdnvpOgKzOdLZUp3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 8:11=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Tue, Aug 19, 2025 at 02:21:44PM +0530, pratyush.brahma@oss.qualcomm.co=
m wrote:
> > From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> >
> > Replace the manual bitwise conversion of bytes to MB with
> > SZ_1M macro, a standard macro used within the mm subsystem,
> > to improve readability.
>
> There are few others:
>
> $ git grep '>> 20' mm/
> mm/memblock.c:          mem_size_mb =3D memblock_phys_mem_size() >> 20;
> mm/memblock.c:                 (nr_pages << PAGE_SHIFT) >> 20, mem_size_m=
b);
> mm/numa_emulation.c:           nid, eb->start, eb->end - 1, (eb->end - eb=
->start) >> 20);
> mm/numa_emulation.c:                    size >> 20, min_size >> 20);
>
> It makes sense to replace all of them in one patch.
Thanks for checking. Will send an updated patch in the next iteration.
>
> > Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> > ---
> >  mm/numa_memblks.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> > index 541a99c4071a67e5b0ef66f4136dee268a880003..a47aa262a33366337c38ccc=
7c7064da818523dd2 100644
> > --- a/mm/numa_memblks.c
> > +++ b/mm/numa_memblks.c
> > @@ -427,9 +427,9 @@ static int __init numa_register_meminfo(struct numa=
_meminfo *mi)
> >               unsigned long pfn_align =3D node_map_pfn_alignment();
> >
> >               if (pfn_align && pfn_align < PAGES_PER_SECTION) {
> > -                     unsigned long node_align_mb =3D PFN_PHYS(pfn_alig=
n) >> 20;
> > +                     unsigned long node_align_mb =3D PFN_PHYS(pfn_alig=
n) / SZ_1M;
> >
> > -                     unsigned long sect_align_mb =3D PFN_PHYS(PAGES_PE=
R_SECTION) >> 20;
> > +                     unsigned long sect_align_mb =3D PFN_PHYS(PAGES_PE=
R_SECTION) / SZ_1M;
> >
> >                       pr_warn("Node alignment %luMB < min %luMB, reject=
ing NUMA config\n",
> >                               node_align_mb, sect_align_mb);
> >
> > ---
> > base-commit: c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9
> > change-id: 20250819-numa-memblks-refac-7b4b5017b598
> >
> > Best regards,
> > --
> > Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> >
>
> --
> Sincerely yours,
> Mike.
Thanks & Regards
Pratyush

