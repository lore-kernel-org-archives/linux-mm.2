Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F683CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 02:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0738E0003; Mon,  6 Oct 2025 22:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C86A8E0002; Mon,  6 Oct 2025 22:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE038E0003; Mon,  6 Oct 2025 22:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9A48E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 22:49:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F091F140803
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 02:49:09 +0000 (UTC)
X-FDA: 83969786418.28.5A70647
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 91852C0008
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 02:49:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=C9akHRXQ;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf28.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759805347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZaVRARoA0Utmb00lsi/x3dreIJP+vK0P4UWKcbv4Zgo=;
	b=wjPN1Wb12fFRENuAvKmYo9kXqIogz9qKDFmUM0e6vmW1YYZWMg3wfdNzUkX1xHKk2DnudD
	Ft17k/v+AaMYoBjE9/Hmv/oDSLLQcQ/Kz2PFBWr3ustWnsw2/uMcZBIKxMjkQu6aL7nCqn
	idH6SABofpunKFhNpzjpHr8IR7vJeuY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759805347; a=rsa-sha256;
	cv=none;
	b=MzS/t3xpKIjRJnQYz46MyFzq7pMkxR6jxmHAGCHdo9opF68vFEJto4IrHU92jPMM9tl6SS
	sOJsLs0bLT9a7Ouyzq3zq8h+Yfki3ON77ErAbQuf9sbpkU0A0YVnC8IBhrHOBNjTToNHGH
	aJyjKg8n93xV42mp1eYzF2I5M3pNuDA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=C9akHRXQ;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf28.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 596F1Jni015115
	for <linux-mm@kvack.org>; Tue, 7 Oct 2025 02:49:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZaVRARoA0Utmb00lsi/x3dreIJP+vK0P4UWKcbv4Zgo=; b=C9akHRXQXeF4ftyI
	HqGYpjPnKE68qbE9NVD/8nyXf7dC3l/iqvUblU3a66gCUGQmj+VhHj2iJ9/tu4X5
	ITS7ipt5Ho+pCpzaBu3IkVQeHXveMb70sIoMGw/BnZu2ThhC+X3uyj2sFzCf8FKj
	3CEBFWB4bulVgIh8siTZnXy3IyLi1WTrwERklVjNDDF7FQTNJtEKXOwaSq3OWpIG
	bv+zB2YU79VswFwnouMFGpxm7g4AEaHvFOe5/hRd8O0V1yxmP5gfznIKwJXuR1cc
	qshuYJIDJ8o3S/6wz5Y7AzbMUJcOzMgGxxyTw0d7yrgJ8Xy0tvfFhnvRJZDGlfQr
	CMnDrw==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49jtk6wury-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 07 Oct 2025 02:49:06 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-27eeb9730d9so58483325ad.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 19:49:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759805345; x=1760410145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZaVRARoA0Utmb00lsi/x3dreIJP+vK0P4UWKcbv4Zgo=;
        b=kpsbSqNX++wJovNwkhx8HhGiitksof2AvaJXAiTk7bLnNv8BnuKhwfjrz+jcZ2GmG+
         zm4NO9hOxkfdMYfXtDLRWfSzYwEakYgqv14/b1VsJCfmWJVQtv3oqPGbpHJp6TniyQzn
         NhuQEsxMYvUibo/Yw+CN8YBj+EC05L9LvCjndIqvMisujeAqqO45FrhiZPEBe6PJ9iU7
         cErv8RfPZU5GzbjPpnBfImElvcuvojJarsfzk7Lv13zE0MPhwUmYINzt09ATQh0v+Pl3
         HvpxPm7kThBLzfDkKHJc67cdO15fgi0GA+xZ16kDnp9wwmyQ8vG1vgh8UXGABqdQhQTv
         Gs+A==
X-Forwarded-Encrypted: i=1; AJvYcCXxv13Zcu3zS5Amw0BE/z5M+3+1vM/65s1bH8wlV9db70CCEc5Tua1Ti0n9B9MkPvak0fS7wwdgZQ==@kvack.org
X-Gm-Message-State: AOJu0YxTTp0NAwwj81CbQcM4Y4qMZJimQhqnCCjYya9OTW24dBzTiTAG
	5jXbQawUDpNU3XPVxSI1gLtAbDYPXxHKaYXwV2DWI+m/GDafW3jZXUvu352DvakL4/30Rn3PVzd
	e9rUbj9ZfVsAyJtgc5Jva18oiLSpo3NwCbgXR1cmjJjNkvgcgGYtaFwweaf8zAaw2l3f4KX1h4U
	ccROLTVTpSWr+6qfRGBcWIVxWU3VaE
X-Gm-Gg: ASbGncuOHltuwjKKh0kmYM2alZbd5Z21tF90pzKpBrS1gvex70a4uPID317T5dWNQeP
	ckJQF1h9Eh909PUSjBl37mYpZTAT2Df1kFS1q6mS6DPD85/UFtcKN7P+8Jab9926TiS9Q1RF+WX
	HFgP6/t4G7eE+F4PJWRV+zBwnaKDI=
X-Received: by 2002:a17:902:d50e:b0:269:96db:939 with SMTP id d9443c01a7336-28e9a6b0dcdmr199099675ad.58.1759805344810;
        Mon, 06 Oct 2025 19:49:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRw/gCNivlB2gJzL3pzI5yAlRdbCy22/fFa4QaQE+YWcrxo0MZumJE//yiECCnuHYpwKKk9WHBmMtTy9sAQ0I=
X-Received: by 2002:a17:902:d50e:b0:269:96db:939 with SMTP id
 d9443c01a7336-28e9a6b0dcdmr199099265ad.58.1759805344266; Mon, 06 Oct 2025
 19:49:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250926-numa-emu-v1-0-714f2691bf8b@oss.qualcomm.com>
 <20250926-numa-emu-v1-2-714f2691bf8b@oss.qualcomm.com> <3a1e75dd-6b39-4506-b4d7-806915d2a6fa@csgroup.eu>
 <CALzOmR06+7wz1mF4PcA5oYn-1HJg7ZEn0WzCQyCrUK3WZT1E9g@mail.gmail.com>
In-Reply-To: <CALzOmR06+7wz1mF4PcA5oYn-1HJg7ZEn0WzCQyCrUK3WZT1E9g@mail.gmail.com>
From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Date: Tue, 7 Oct 2025 08:18:52 +0530
X-Gm-Features: AS18NWDuD4sXAZmnnUGTHv_6__r29Bqwu2piwwlOTsCHSiyCXxtoTQWAGSnstCM
Message-ID: <CALzOmR1Pi0Uf9q=kW5ooLFxyxZ79J8rkMQTgEKH8s+aa8_rAEg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/numa_emulation: Move the size calculation in
 split_nodes_interleave() to a separate function
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA0MDAxNyBTYWx0ZWRfX1B7cMWaV32a8
 AIPw0XoOCnVIUeHeV8JTu86UhfpxW58B5E5+nvyf4v3SogGW7gTgceVv587ACO1iyvtkFaKM+Om
 TXlg6BzdIUnO2wZ+jhSHiFtfu8MSeHrteFmFW6e1JsO1Sq7Y5fK2rXjQfFAQjQM8ihcX9XFunyj
 kImHcdpsnXTCdluTplO8fYSM4W+VYt8giNwVhmrV5GpdKseANqa3aGNhIdZgelL1mih6yQ7E8Ac
 3Bw65vquaMCBIUv9Du3Xym3EMQ1I/hj/9941CE00W7bffAECNlYtzzT4/4pL5GFUdgeClPSuVOy
 FJ5Bc8FOpxNJOkOecQSS0kBnk1NW7jvEzY85oK5Mkb1MJxaXQiFHaeKUV1LgYdP51gDqR8ng+EI
 /lKmCBkrKyf5ypNSQMq/xBzqBbxDew==
X-Authority-Analysis: v=2.4 cv=do3Wylg4 c=1 sm=1 tr=0 ts=68e47fa2 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10
 a=EUspDBNiAAAA:8 a=1UX6Do5GAAAA:8 a=rmvc3b5iyUt8DdIxB8EA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22 a=Et2XPkok5AAZYJIKzHr1:22
X-Proofpoint-GUID: w0hCYkc41eILglx_-3dnemAoTGclpv8b
X-Proofpoint-ORIG-GUID: w0hCYkc41eILglx_-3dnemAoTGclpv8b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 malwarescore=0 spamscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2510040017
X-Rspam-User: 
X-Rspamd-Queue-Id: 91852C0008
X-Rspamd-Server: rspam02
X-Stat-Signature: j4qf8et6bkeox9z71m41ze1nr4t7r4h7
X-HE-Tag: 1759805347-62469
X-HE-Meta: U2FsdGVkX1+sUj0tdU4LU4QkJcMWfLkbRDIxyeB25CzVeu0YF6FBOBTLPZlgYiZcJDmOjR7qW3ByOHAYK+QlvRUpPo9wkDK3224f/IXUj7UeQa4LAsTI4QF6waz+ChDit9NJzAps2xTZ62/PAfu09XPzXf8jM5fCBJIRE/MvX9gIMumGTGnh0VV1s438b7vNAEvxGQ1CBSzRkYaRVA9mj3ioKAaMB7izwlUy1GocmaW1b9j5uDahTbBBOdX2PiIA4nwzOiUOvGMVaKxklGs8LbmU/Ms3fr3O5KzFozkVamGstE1E/NpZsbMXOQRzer0T7xX28OJXtF3NJNp/QgOiDoXv1BDZv9IQO3OiA3Rkw1ef+KrDmkFICbFJZXT1/nkrR361+MtT5vIiydlVxyHt7AY0LmQ9pa29J70UeLStqibx6urLTz9QpVHtdPs/d0JXZrkSREUTxI0Zy3zUdFjfLwGw1UDiTCSaqGQe1y/6y7FQstBYiMZxRs5pxIdc/HSwuYpLxwIvty8FWcwBSlO1PJiNKSdZyrlbtD0oTOCubCyq+ovbDqUiSQJqs0MVjYdLOabkTEDNHjTBUjmYm/8q/uR2EqzQP9sc8SvkJASqrGVqzeGXJqatP98PMcijysBfrL9PCMhMWZYAGEnZG0ERsvyse5e1GAy+/gIV6Ny3acjsCgFxfkNIUbkY3nfWNXJp5OqTeEWOwF/fnrVjbRiVXURrnLjX28XYLPh6+HwMlL+LBL/hoZu7/fEoPZkzuo4RYbZwKjYrwCGll+PP7zYqBHxR6BvaZjfRkDOnDlYtQS0r1hPErHj6wMuzVZCuX/IvNA6e/JCldImaUcNU8f6mW6CT0mxY5/OW6e/oIgG2QfQueOSb8gtem3p8jgHHOObPFKRiJiZQeUhp46QE83ps2bJuNc3m0xQrNHqKmAIOwEsFGS7GYXDAq9fohXJE+O1glhXSjFttasnfmU/IQTU
 wgPQcb0h
 lKajKxfjA8WuB/J7czksesZC083P6QVTpUzT9JO4TvvTwxqM7mstywOf71oVzPxRfwJtOjUrphmH9LUNyEiEzFXa+DoLJhQUyVd6EQWpXYs497FEsGpo+RFpncN7pn/Jve0ZWhv7ysJWtfm4j3OWfDKQqznLKN568HLjNMWZzkeD6Yd/eFozTIygMkPnf7q9eHyhWv7cG9Q0MHKcI+SIHjoaJi8zWOzVelRIlG2SuyAa5JyLbtxDyE73qr7mN95n8gobbNj6t6zopxR4+viFft9E3+0AoyvYUQisKcQh8VVnN+PX1MqAXJ8uJWELJ18jiWKpGvw+jFnMmb+3w5uCa1GhipcNEzd3KFup6EcP8m3IVS5bXytfcHQlHkNAmNG7iWPgSIGP39iFfxgKFxdCfdMKjUWljCpB+J6IH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29, 2025 at 12:46=E2=80=AFPM Pratyush Brahma
<pratyush.brahma@oss.qualcomm.com> wrote:
>
>
>
> On Fri, Sep 26, 2025 at 7:50=E2=80=AFPM Christophe Leroy <christophe.lero=
y@csgroup.eu> wrote:
> >
> >
> >
> > Le 26/09/2025 =C3=A0 12:34, pratyush.brahma@oss.qualcomm.com a =C3=A9cr=
it :
> > > From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> > >
> > > The size calculation in split_nodes_interleave() has several nuances.
> > > Move it to a separate function to improve code modularity and
> > > simplify the readability of split_nodes_interleave().
> > >
> > > Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> > > ---
> > >   mm/numa_emulation.c | 44 +++++++++++++++++++++++++++++-------------=
--
> > >   1 file changed, 29 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> > > index 2a335b3dd46a..882c349c2a0f 100644
> > > --- a/mm/numa_emulation.c
> > > +++ b/mm/numa_emulation.c
> > > @@ -76,6 +76,34 @@ static int __init emu_setup_memblk(struct numa_mem=
info *ei,
> > >       return 0;
> > >   }
> > >
> > > +static void __init __calc_split_params(u64 addr, u64 max_addr,
> > > +             int nr_nodes, u64 *psize, int *pbig)
> > > +{
> > > +     u64 size, usable_size;
> > > +     int big;
> > > +
> > > +     /* total usable memory (skip holes) */
> > > +     usable_size  =3D max_addr - addr - mem_hole_size(addr, max_addr=
);
> > > +
> > > +     /*
> > > +      * Calculate target node size.  x86_32 freaks on __udivdi3() so=
 do
> > > +      * the division in ulong number of pages and convert back.
> > > +      */
> > > +     size =3D PFN_PHYS((unsigned long)(usable_size >> PAGE_SHIFT) / =
nr_nodes);
> > > +
> > > +     /*
> > > +      * Calculate the number of big nodes that can be allocated as a=
 result
> > > +      * of consolidating the remainder.
> > > +      */
> > > +     big =3D ((size & (FAKE_NODE_MIN_SIZE - 1UL)) * nr_nodes) / FAKE=
_NODE_MIN_SIZE;
> > > +
> > > +     /* Align the base size down to the minimum granularity */
> > > +     size =3D ALIGN_DOWN(size, FAKE_NODE_MIN_SIZE);
> > > +
> > > +     *psize =3D size;
> > > +     *pbig  =3D big;
> >
> > Having to return simple type values through pointers is usually the
> > start of proplems.Whenever possible you shouldn't returning simple type=
s
> > via pointers.
> Thanks Christophe for your comments. Can you please help me understand wh=
at kind of
> problems can we run into so I can be mindful of this going forward?
> >
> > Your function is void, it could return size instead.
> Sure, it can be done.
> >
> > And big seems independant, could be returned by another function.
> Had included big in this function as it was calculated before we align th=
e size to
> FAKE_NODE_MIN_SIZE. If we move the calculation of big to a separate funct=
ion,
> it would compute the value after the alignment of size, which would alway=
s render
> big as zero, wouldn't it?
>
> And if I move the calculation of big to a separate function which takes i=
n the precomputed
> size value as input and call it within the new helper, then I would still=
 have to return big
> from this new helper, won't I?
>
> Please let me know if I am missing something.
Hi Christophe

Can you please help me to understand here?
> >
> > > +}
> > > +
> > >   /*
> > >    * Sets up nr_nodes fake nodes interleaved over physical nodes rang=
ing from addr
> > >    * to max_addr.
> > > @@ -100,21 +128,7 @@ static int __init split_nodes_interleave(struct =
numa_meminfo *ei,
> > >               nr_nodes =3D MAX_NUMNODES;
> > >       }
> > >
> > > -     /*
> > > -      * Calculate target node size.  x86_32 freaks on __udivdi3() so=
 do
> > > -      * the division in ulong number of pages and convert back.
> > > -      */
> > > -     size =3D max_addr - addr - mem_hole_size(addr, max_addr);
> > > -     size =3D PFN_PHYS((unsigned long)(size >> PAGE_SHIFT) / nr_node=
s);
> > > -
> > > -     /*
> > > -      * Calculate the number of big nodes that can be allocated as a=
 result
> > > -      * of consolidating the remainder.
> > > -      */
> > > -     big =3D ((size & (FAKE_NODE_MIN_SIZE - 1UL)) * nr_nodes) /
> > > -             FAKE_NODE_MIN_SIZE;
> > > -
> > > -     size =3D ALIGN_DOWN(size, FAKE_NODE_MIN_SIZE);
> > > +     __calc_split_params(addr, max_addr, nr_nodes, &size, &big);
> > >       if (!size) {
> > >               pr_err("Not enough memory for each node.  "
> > >                       "NUMA emulation disabled.\n");
> > >
> >
Thanks and Regards
Pratyush

