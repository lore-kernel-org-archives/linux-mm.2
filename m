Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B8BECAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 07:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4798E0027; Mon, 29 Sep 2025 03:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B9F8E0002; Mon, 29 Sep 2025 03:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1688E0027; Mon, 29 Sep 2025 03:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21FA48E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:17:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9E1DC0292
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:16:59 +0000 (UTC)
X-FDA: 83941430958.27.5D7498F
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6CBAF40005
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:16:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=FFMLOviD;
	spf=pass (imf17.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759130217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Jh7BHlQDk/uoU1C2uWfr20rSCKWIl/AF6JGIQF/PdI=;
	b=TmVW9c93dqgpQlMgF1nZs3CnkUFR6QyJAN4TlQz8+IwJinYZZDlV6h2XGT6YccIsdW0kOK
	HjS/FxSQAjXP3/nAqE2fG/w6Xm5hu+DPBNzees0cUpkznc8AoC5vHMCUNDI2WbWPlKePHB
	WSKl2G8OSXZOQNRP5DRnZqurSDRK7Wk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=FFMLOviD;
	spf=pass (imf17.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759130217; a=rsa-sha256;
	cv=none;
	b=RIMc1KxMevDtOJS0MBQ23L+i+xb0ooHH92Kit2AkgVhAlLhBSLKhK4MuIsD4ziP+LgBqZ/
	fA/WlL0MdV8WXJnVNUJGkoGrfuwyIHDlRTUcwMNb93NqhAXxrYAa+vyj4MRE7Lwb7SQC61
	oPgQB1DXHjU0Z6nDCSYNKG5tp3ifR9w=
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58SMtDr7008908
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:16:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=+Jh7BHlQDk/uoU1C2uWfr20r
	SCKWIl/AF6JGIQF/PdI=; b=FFMLOviDk7qTWU70W+8SBzUFAZFrMbeig+VArlJw
	y9cF41cs3pIB/XiU0/tSBgf2Hz2NEpjOXnd/IvuefrKeS3IIh1+T0qs+SFLr8epW
	bujNdTY6KkSNkkKLBw/fkdVXZDCPrTowIhPt8FyZT02/JhrD1qRkjiTHq6aTGrsG
	eixrS3QOlS3zRxwXYeL+bxcoKRmULLQ9eT7psLJIIJAtsVFi7pOZT+hBod4lGN9b
	Ew2BspI7ZRkfQLK6W4BRIrA6/w5kqvy5WH4XxuleDL2R/7ChQ9AFoCzbtb/fcztF
	PpJ3dahkDi/xSYzcsF88qlW8vmA+Cg4oAjYK7lMq64iNbg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49e78fv9h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:16:56 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2681623f927so40978065ad.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 00:16:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759130215; x=1759735015;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Jh7BHlQDk/uoU1C2uWfr20rSCKWIl/AF6JGIQF/PdI=;
        b=lXsaOhC/tfnUM2dA1HLjDoQQePAX0aDX9T5Cdq6wvgg9qVaDq3+bErhkHLkpEEYmGF
         wErxlnQuKIvrHXMmaJQqi1AUtPXa+e6FZtzFY/L+0sJDv9m+MTBFGU86fPG+OI06Rtuk
         8cJc23tkyLFc/0i/IqxHx5YFpfmO1A2hB8qRHWkT7F5Vz2EHuKZektd5Loz6GXMQW3jg
         2QyRj/mqrhJJBjVRs8DGDcfWt0oFDarFg2gv0KQc9yBA2QpC/RMRkDU37/4PK8y7BXvy
         6/EbCTHCMGDNsZw3SKcSx1wLkyvuMGdpHNo0h+HI/AKpQdHRiuN0RE3NfFJN41y4d7dB
         1Zhw==
X-Forwarded-Encrypted: i=1; AJvYcCUVDqQZoJgwyp8wlA4+IQrMBgNRfw+pLbF5RryxMUn3HVzwuPA54CY+pW2C+mgN9f9EjhWPqNNshQ==@kvack.org
X-Gm-Message-State: AOJu0YznD9xrfoykTRnFxAB8Cl+kCJ2t8OAFLoGuACrhbHHDAmLEhmiL
	etRwWOKb2LA9j2Lu4BuCZMK9JdexQvCOJ6CaoMzNKohAohJcm6BmwMaz/eLAaLR2Ix7MeEE6VvQ
	aFaAUfN9AcWkBq0wjOr82b/OlQRncjuiiLw/aE3B/7WGNsnBqEux0OCkpZaJ57ShoI14Xyo9cwI
	ULnMUb+jgErkn/zm3Wdw+xHM4M2IwR
X-Gm-Gg: ASbGncuubOrqSZ1eHZ/WDqQqqoQZS2ndVz7ojqGxpuzOqGRH68FU7ME4Y7nPAIFap64
	cLKmxKYOLHtlOVSx89F4LrSixJfu68u1DCe9zlZzKg75Ix3P9pELoQqj5kN+XJ/tsuFIe/21wRp
	rwhgF6FX0CNNQ+KCVI2ms9qDQ=
X-Received: by 2002:a17:902:e5c7:b0:24b:1589:5054 with SMTP id d9443c01a7336-27ed4a29670mr158672685ad.23.1759130214772;
        Mon, 29 Sep 2025 00:16:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+lMJG6VZ3WEs92+B+sNQaSSEOImGLTGVCqFHVy/OIrnif5wovwToazkXNgFwmrvkJFIsA3AOQFilAJae6PrM=
X-Received: by 2002:a17:902:e5c7:b0:24b:1589:5054 with SMTP id
 d9443c01a7336-27ed4a29670mr158672295ad.23.1759130214231; Mon, 29 Sep 2025
 00:16:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250926-numa-emu-v1-0-714f2691bf8b@oss.qualcomm.com>
 <20250926-numa-emu-v1-2-714f2691bf8b@oss.qualcomm.com> <3a1e75dd-6b39-4506-b4d7-806915d2a6fa@csgroup.eu>
In-Reply-To: <3a1e75dd-6b39-4506-b4d7-806915d2a6fa@csgroup.eu>
From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Date: Mon, 29 Sep 2025 12:46:43 +0530
X-Gm-Features: AS18NWAOhuYe9Aa3EyliLPNXdM_ie7T126jaEW_4cr0Yk3sWnv7vjobjcIas5Zo
Message-ID: <CALzOmR06+7wz1mF4PcA5oYn-1HJg7ZEn0WzCQyCrUK3WZT1E9g@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/numa_emulation: Move the size calculation in
 split_nodes_interleave() to a separate function
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000888241063feb6b32"
X-Authority-Analysis: v=2.4 cv=DZAaa/tW c=1 sm=1 tr=0 ts=68da3268 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=yJojWOMRYYMA:10 a=1UX6Do5GAAAA:8
 a=EUspDBNiAAAA:8 a=bplrAKsiAicH8rB66usA:9 a=QEXdDO2ut3YA:10
 a=GGEzqWFZrqF5wQro_C8A:9 a=wD75jqPagPSrfxgV:21 a=lqcHg5cX4UMA:10
 a=1OuFwYUASf3TG4hYMiVC:22 a=Et2XPkok5AAZYJIKzHr1:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyMiBTYWx0ZWRfX9f30xTk3D5C0
 eVyinGTWZIPdijDKPwgzIUSKiU5didb7moNrE/opI80V5Lfr23T8U+FX9jqwDw2pELSLyNq/1Oa
 SW/S6Q5L0T4oCbhIWTiC7JaUbEVAsIbLbDO2pzdBnYvwGXa5gwtRz7gUf4ANOs5YabMDQuk9bLx
 FKJC5fkHSmCFOKFCYtHCcG1nfEzPA9Ng+SCBjZ4BZhyYsi01B+74XtPdZvjELBbD1V40HQrhggY
 d9thgf344qkovJVowDM89wlIOPX2kT56BRiO2UFJAuQBo8JkcXyc8mE5atazrIrxKZwTwMziubr
 UvdGvhKkREhE+UHYHe85MKCFkfZdUJ46nTaA/C1XX650Ip5LINsRnJZNSX6PS00mucBkYJIPpzL
 B8pVMysCdDmy8PF8p2voUnyvME0TwA==
X-Proofpoint-GUID: dJc28wkc53kjkzi0t21ei7ritou1z781
X-Proofpoint-ORIG-GUID: dJc28wkc53kjkzi0t21ei7ritou1z781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_02,2025-09-29_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2509270022
X-Rspamd-Queue-Id: 6CBAF40005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 1nst7jetfoobqiy7c9p47a15o1qp5fkp
X-HE-Tag: 1759130217-381729
X-HE-Meta: U2FsdGVkX18DYy33mcQg/In+eU5AlsIyYhoeFZNl/J25Frks1Os2H0InprGMi+aem3s2BCoivnaZ17ufgKb1FYLe107gLhbfof1IG42uU7aALVSYVRTIzsFytYabfze97CLyAMq7RTjPouUJ/0C3Mk7mBkxzLieQGWp7dD1GUZyckcBayDH0TgVPj+RJgJ6oo6b8/8jvPCpZIz7XtZ5Co3EupSzVbQEeDyRR5SLEY+IW7EAwWvA3CekYsWx+WRXI4GHCbjrLn9e4A0/F1bhFxpLj0NaBW56sGZmcoyKFY02z0lxV7Ld7oZEZSYeKY7gsgAqRs+pX5An4BQJUIHqSj+FCuLH2U1JgEXA7CvuQ670XrVNvq4odFqNIVx+Q8r5P5MpVxwJT1koBkauugOuOQueTg47rCo4Nwcftihtj5RpkRqqXQ5h3FXabs4SE0BG2BjhGWviZauD4YwRAxOL1DgYM9FqAQ8CtNptmnoab59SjHNsawc2gje2of4Q/PRvTXx2KleQfAdO2UcHVuueO/QFL8Ut2pVM85xwH6JcASf7k4WUofHku29E2HOEavoCaL/UQCuPPGcQx5Gn9T4jKTr8PygSjVIRF2pmNj1FsnCEHEHbp67Hj1GbGWhV7TaaVe5eTn7BVi7WrbOGakv3IWw/MoHc2jlIePw77zGQr5dp3xkbQvrdqN6CEASKPDTYpSBdBv/eOehHXXvGjx/d+RvFbENDLbTd/Qj/tdeuBkdHSjVuDI6e1UKeoNn0tMBIud0r24axkrz+B2+J7uxxFTgQ8huRTb7MVdCN+VnnGiksxcs0cRbNcPsG27+Q1jQYusNMm0piMsmnEXInOSsEFmHdzzLFlj24et8zrxZR41hfjjYmCPd/PaBXPCRPjv5pANlcYVde2eTJVrB9sD0DrGYZkJpl5ya7xoE56DECF8RTDgLyw2rczmTDSRPpha7/G+Jyfztr9PYAIuLww0V7
 JVhkuQ1G
 xlIzos5a4IaAlcPua9hQyx2i1gKnjPYt26tkfCpqu1wTMjvb7C7rLAHspSBxvZ5YFkmUI9PA/umreLtxm3eMXnHHJkbczDpDDY4sI2/J47iRvd9uOXc+qp8JOWHezhWLYCIvNaFxB3ANhW6TNqMD6UuassfXHq42S4EwWxOgTzhgEmK0O/Tj1kPrtFkvVMSEscqmnuMY5sa9OXoyGXBGKnzQHzLJGHBsDBXGgSDrT6C86xHCSNUSzhxdAcL4t6fSyXEzinItOD6pK1fJwpN7NlY1KrGUgIjmfHZb40BdoEqF6vKPVvAz3yTRh/vQRZCXIPACoKThsM9e35sXWE7bpbDJ3ZkUA9M3hDJb7DLJdqK2z6qdBJaEbPoeuJQP0m+tNoVENvBzo2EkNGnPGn2O4l4jO5iyqERAAPJ9H73MHI43jAXi4FdHHSh8Hl0cm+Wu/jVOX+OD+lwFlKKFZo9a1+aW1sKqcMbSAtZPf8OhahKxZFxYpsZaGSN1qffOlhVbeoVZm7dmOq+OXTZ5jk5QhH5m259ClHQwj09VveBsj6KRzubng3qiBuoYFMcHirpPV19lb91xilS7K89I3cBN+tKJehbjbHclmL75myTynJom1jLNs42dg2ntp5R+qdJSunWri
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000888241063feb6b32
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2025 at 7:50=E2=80=AFPM Christophe Leroy <
christophe.leroy@csgroup.eu> wrote:
>
>
>
> Le 26/09/2025 =C3=A0 12:34, pratyush.brahma@oss.qualcomm.com a =C3=A9crit=
 :
> > From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> >
> > The size calculation in split_nodes_interleave() has several nuances.
> > Move it to a separate function to improve code modularity and
> > simplify the readability of split_nodes_interleave().
> >
> > Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> > ---
> >   mm/numa_emulation.c | 44 +++++++++++++++++++++++++++++---------------
> >   1 file changed, 29 insertions(+), 15 deletions(-)
> >
> > diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> > index 2a335b3dd46a..882c349c2a0f 100644
> > --- a/mm/numa_emulation.c
> > +++ b/mm/numa_emulation.c
> > @@ -76,6 +76,34 @@ static int __init emu_setup_memblk(struct
numa_meminfo *ei,
> >       return 0;
> >   }
> >
> > +static void __init __calc_split_params(u64 addr, u64 max_addr,
> > +             int nr_nodes, u64 *psize, int *pbig)
> > +{
> > +     u64 size, usable_size;
> > +     int big;
> > +
> > +     /* total usable memory (skip holes) */
> > +     usable_size  =3D max_addr - addr - mem_hole_size(addr, max_addr);
> > +
> > +     /*
> > +      * Calculate target node size.  x86_32 freaks on __udivdi3() so d=
o
> > +      * the division in ulong number of pages and convert back.
> > +      */
> > +     size =3D PFN_PHYS((unsigned long)(usable_size >> PAGE_SHIFT) /
nr_nodes);
> > +
> > +     /*
> > +      * Calculate the number of big nodes that can be allocated as a
result
> > +      * of consolidating the remainder.
> > +      */
> > +     big =3D ((size & (FAKE_NODE_MIN_SIZE - 1UL)) * nr_nodes) /
FAKE_NODE_MIN_SIZE;
> > +
> > +     /* Align the base size down to the minimum granularity */
> > +     size =3D ALIGN_DOWN(size, FAKE_NODE_MIN_SIZE);
> > +
> > +     *psize =3D size;
> > +     *pbig  =3D big;
>
> Having to return simple type values through pointers is usually the
> start of proplems.Whenever possible you shouldn't returning simple types
> via pointers.
Thanks Christophe for your comments. Can you please help me understand what
kind of
problems can we run into so I can be mindful of this going forward?
>
> Your function is void, it could return size instead.
Sure, it can be done.
>
> And big seems independant, could be returned by another function.
Had included big in this function as it was calculated before we align the
size to
FAKE_NODE_MIN_SIZE. If we move the calculation of big to a separate
function,
it would compute the value after the alignment of size, which would always
render
big as zero, wouldn't it?

And if I move the calculation of big to a separate function which takes in
the precomputed
size value as input and call it within the new helper, then I would still
have to return big
from this new helper, won't I?

Please let me know if I am missing something.
>
> > +}
> > +
> >   /*
> >    * Sets up nr_nodes fake nodes interleaved over physical nodes
ranging from addr
> >    * to max_addr.
> > @@ -100,21 +128,7 @@ static int __init split_nodes_interleave(struct
numa_meminfo *ei,
> >               nr_nodes =3D MAX_NUMNODES;
> >       }
> >
> > -     /*
> > -      * Calculate target node size.  x86_32 freaks on __udivdi3() so d=
o
> > -      * the division in ulong number of pages and convert back.
> > -      */
> > -     size =3D max_addr - addr - mem_hole_size(addr, max_addr);
> > -     size =3D PFN_PHYS((unsigned long)(size >> PAGE_SHIFT) / nr_nodes)=
;
> > -
> > -     /*
> > -      * Calculate the number of big nodes that can be allocated as a
result
> > -      * of consolidating the remainder.
> > -      */
> > -     big =3D ((size & (FAKE_NODE_MIN_SIZE - 1UL)) * nr_nodes) /
> > -             FAKE_NODE_MIN_SIZE;
> > -
> > -     size =3D ALIGN_DOWN(size, FAKE_NODE_MIN_SIZE);
> > +     __calc_split_params(addr, max_addr, nr_nodes, &size, &big);
> >       if (!size) {
> >               pr_err("Not enough memory for each node.  "
> >                       "NUMA emulation disabled.\n");
> >
>

--000000000000888241063feb6b32
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><br>On Fri, Sep 26, 2025 at 7:50=E2=80=AFPM Christophe=
 Leroy &lt;<a href=3D"mailto:christophe.leroy@csgroup.eu">christophe.leroy@=
csgroup.eu</a>&gt; wrote:<br>&gt;<br>&gt;<br>&gt;<br>&gt; Le 26/09/2025 =C3=
=A0 12:34, <a href=3D"mailto:pratyush.brahma@oss.qualcomm.com">pratyush.bra=
hma@oss.qualcomm.com</a> a =C3=A9crit :<br>&gt; &gt; From: Pratyush Brahma =
&lt;<a href=3D"mailto:pratyush.brahma@oss.qualcomm.com">pratyush.brahma@oss=
.qualcomm.com</a>&gt;<br>&gt; &gt;<br>&gt; &gt; The size calculation in spl=
it_nodes_interleave() has several nuances.<br>&gt; &gt; Move it to a separa=
te function to improve code modularity and<br>&gt; &gt; simplify the readab=
ility of split_nodes_interleave().<br>&gt; &gt;<br>&gt; &gt; Signed-off-by:=
 Pratyush Brahma &lt;<a href=3D"mailto:pratyush.brahma@oss.qualcomm.com">pr=
atyush.brahma@oss.qualcomm.com</a>&gt;<br>&gt; &gt; ---<br>&gt; &gt; =C2=A0=
 mm/numa_emulation.c | 44 +++++++++++++++++++++++++++++---------------<br>&=
gt; &gt; =C2=A0 1 file changed, 29 insertions(+), 15 deletions(-)<br>&gt; &=
gt;<br>&gt; &gt; diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c<br>=
&gt; &gt; index 2a335b3dd46a..882c349c2a0f 100644<br>&gt; &gt; --- a/mm/num=
a_emulation.c<br>&gt; &gt; +++ b/mm/numa_emulation.c<br>&gt; &gt; @@ -76,6 =
+76,34 @@ static int __init emu_setup_memblk(struct numa_meminfo *ei,<br>&g=
t; &gt; =C2=A0 =C2=A0 =C2=A0 return 0;<br>&gt; &gt; =C2=A0 }<br>&gt; &gt; =
=C2=A0<br>&gt; &gt; +static void __init __calc_split_params(u64 addr, u64 m=
ax_addr,<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int nr_no=
des, u64 *psize, int *pbig)<br>&gt; &gt; +{<br>&gt; &gt; + =C2=A0 =C2=A0 u6=
4 size, usable_size;<br>&gt; &gt; + =C2=A0 =C2=A0 int big;<br>&gt; &gt; +<b=
r>&gt; &gt; + =C2=A0 =C2=A0 /* total usable memory (skip holes) */<br>&gt; =
&gt; + =C2=A0 =C2=A0 usable_size =C2=A0=3D max_addr - addr - mem_hole_size(=
addr, max_addr);<br>&gt; &gt; +<br>&gt; &gt; + =C2=A0 =C2=A0 /*<br>&gt; &gt=
; + =C2=A0 =C2=A0 =C2=A0* Calculate target node size. =C2=A0x86_32 freaks o=
n __udivdi3() so do<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0* the division in ul=
ong number of pages and convert back.<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0*/=
<br>&gt; &gt; + =C2=A0 =C2=A0 size =3D PFN_PHYS((unsigned long)(usable_size=
 &gt;&gt; PAGE_SHIFT) / nr_nodes);<br>&gt; &gt; +<br>&gt; &gt; + =C2=A0 =C2=
=A0 /*<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0* Calculate the number of big nod=
es that can be allocated as a result<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0* o=
f consolidating the remainder.<br>&gt; &gt; + =C2=A0 =C2=A0 =C2=A0*/<br>&gt=
; &gt; + =C2=A0 =C2=A0 big =3D ((size &amp; (FAKE_NODE_MIN_SIZE - 1UL)) * n=
r_nodes) / FAKE_NODE_MIN_SIZE;<br>&gt; &gt; +<br>&gt; &gt; + =C2=A0 =C2=A0 =
/* Align the base size down to the minimum granularity */<br>&gt; &gt; + =
=C2=A0 =C2=A0 size =3D ALIGN_DOWN(size, FAKE_NODE_MIN_SIZE);<br>&gt; &gt; +=
<br>&gt; &gt; + =C2=A0 =C2=A0 *psize =3D size;<br>&gt; &gt; + =C2=A0 =C2=A0=
 *pbig =C2=A0=3D big;<br>&gt;<br>&gt; Having to return simple type values t=
hrough pointers is usually the<br>&gt; start of proplems.Whenever possible =
you shouldn&#39;t returning simple types<br>&gt; via pointers.<br>Thanks Ch=
ristophe for your comments. Can you please help me understand what kind of<=
br>problems can we run into so I can be mindful of this going forward?<br>&=
gt;<br>&gt; Your function is void, it could return size instead.<br>Sure, i=
t can be done.<br>&gt;<br>&gt; And big seems independant, could be returned=
 by another function.<br>Had included big in this function as it was calcul=
ated before we align the size to <br>FAKE_NODE_MIN_SIZE. If we move the cal=
culation of big to a separate function,<br>it would compute the value after=
 the alignment of size, which would always render<br>big as zero, wouldn&#3=
9;t it?<br><br>And if I move the calculation of big to a separate function =
which takes in the precomputed<br>size value as input and call it within th=
e new helper, then I would still have to return big<br><div>from this new h=
elper, won&#39;t I?</div><div><br></div><div>Please let me know if I am mis=
sing something.</div>&gt;<br>&gt; &gt; +}<br>&gt; &gt; +<br>&gt; &gt; =C2=
=A0 /*<br>&gt; &gt; =C2=A0 =C2=A0* Sets up nr_nodes fake nodes interleaved =
over physical nodes ranging from addr<br>&gt; &gt; =C2=A0 =C2=A0* to max_ad=
dr.<br>&gt; &gt; @@ -100,21 +128,7 @@ static int __init split_nodes_interle=
ave(struct numa_meminfo *ei,<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 nr_nodes =3D MAX_NUMNODES;<br>&gt; &gt; =C2=A0 =C2=A0 =C2=
=A0 }<br>&gt; &gt; =C2=A0<br>&gt; &gt; - =C2=A0 =C2=A0 /*<br>&gt; &gt; - =
=C2=A0 =C2=A0 =C2=A0* Calculate target node size. =C2=A0x86_32 freaks on __=
udivdi3() so do<br>&gt; &gt; - =C2=A0 =C2=A0 =C2=A0* the division in ulong =
number of pages and convert back.<br>&gt; &gt; - =C2=A0 =C2=A0 =C2=A0*/<br>=
&gt; &gt; - =C2=A0 =C2=A0 size =3D max_addr - addr - mem_hole_size(addr, ma=
x_addr);<br>&gt; &gt; - =C2=A0 =C2=A0 size =3D PFN_PHYS((unsigned long)(siz=
e &gt;&gt; PAGE_SHIFT) / nr_nodes);<br>&gt; &gt; -<br>&gt; &gt; - =C2=A0 =
=C2=A0 /*<br>&gt; &gt; - =C2=A0 =C2=A0 =C2=A0* Calculate the number of big =
nodes that can be allocated as a result<br>&gt; &gt; - =C2=A0 =C2=A0 =C2=A0=
* of consolidating the remainder.<br>&gt; &gt; - =C2=A0 =C2=A0 =C2=A0*/<br>=
&gt; &gt; - =C2=A0 =C2=A0 big =3D ((size &amp; (FAKE_NODE_MIN_SIZE - 1UL)) =
* nr_nodes) /<br>&gt; &gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FAKE=
_NODE_MIN_SIZE;<br>&gt; &gt; -<br>&gt; &gt; - =C2=A0 =C2=A0 size =3D ALIGN_=
DOWN(size, FAKE_NODE_MIN_SIZE);<br>&gt; &gt; + =C2=A0 =C2=A0 __calc_split_p=
arams(addr, max_addr, nr_nodes, &amp;size, &amp;big);<br>&gt; &gt; =C2=A0 =
=C2=A0 =C2=A0 if (!size) {<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 pr_err(&quot;Not enough memory for each node. =C2=A0&quot;<br=
>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 &quot;NUMA emulation disabled.\n&quot;);<br>&gt; &gt;<br>&gt;=
</div>

--000000000000888241063feb6b32--

