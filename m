Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1970C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 12:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329696B0089; Mon, 11 Aug 2025 08:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B37A6B010E; Mon, 11 Aug 2025 08:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A14B8E0045; Mon, 11 Aug 2025 08:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0846B0088
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:46:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7B79134550
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:46:36 +0000 (UTC)
X-FDA: 83764450392.18.B8B13BC
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4DDA64000C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:46:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=iRfolxFP;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf17.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754916394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXgUdVgdlgn2VCynAFRV7iUs1nePSUmL8BBkYLFdokc=;
	b=0Qh8h23A1Vq3w88BOEUMtdTN5yPTUy5qgodohKHWzdV9nwwBkJUjezu1f9DgQ6eaa5pUVn
	oeA+vHDODxgk8d1pRGQ9Ccj20/gzJkhmL/+lQhmE3umRgX73G7r3eb+tdBjon3GLnYKW13
	6ssf3d18jh0n/IIbw6SboEQi6KuUMdk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754916394; a=rsa-sha256;
	cv=none;
	b=BPQO/4ubOVRGrhv1IHoiXZYYkuzRO+jnMZCOizHl3QmkrxJ+khAHk2CBQAyaLjhOXY+XHL
	+5fsfYme9UEoBlkZ/tLFKmZsHUZtUZzzFgbm7M4nKfRlnxcTTGms7QyVE9Wdh5k/0JgDpj
	g/6BhnVv6jebuvlwgSLekGgx63HP7mE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=iRfolxFP;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf17.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57B9dVnt022882
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:46:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=IXgUdVgdlgn2VCynAFRV7iUs
	1nePSUmL8BBkYLFdokc=; b=iRfolxFPY1TSryU4vlf8vQvuuQ1aJwnqBoi0AF1k
	2/IVRqjYbiC+DIp/6xQ3AP9g0SolKAFtS+ybBzO/SPEqXF+YCtYjhF/oMA1Vf3oT
	zXWkC3fjjiVHVm+rwtXNL3oO8M1pqAedhapgYWGd2ZsWMjdF1k53Gqzt6dSSa5Es
	38PqkL2WWtxZaIBp78HGiv78JCt6u2qSVkFEyRO8wzdgKimpcChOUoekuthoFd1n
	WsmpcUIHksNgeZR+/bPDYsWhcVq//vq3SfAzwsyM1b3V8XvmvfrzX0ykvwmcqFV/
	dswZUvYTX4/wRLZELS7JBXMTAtq7LEdArqDOsBeLDYdTFg==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48dxj44f8y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:46:32 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-240b9c0bddcso40474715ad.2
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:46:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754916392; x=1755521192;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IXgUdVgdlgn2VCynAFRV7iUs1nePSUmL8BBkYLFdokc=;
        b=QEmjEVOIFf/g8rohJy73avZERuNraxfUnRoMX1rGfv0FmBbrqpNh4I1tVbokUmg9ji
         l0J2KRMFno/J7cC0wGrvqXfa44mhjuDi8ZZlaSYqWuDk87ihTN5PdMurhKgArLTBbtum
         oT+dcQvfIBED6jJU36JeeD5BGdDYTRYcMH2BGWRsfOfnNDuLp6AiTTLvPtyphGSyCCSN
         m1Q79R5clcMzQ05Insxk67BpSKv9N2krWHCmNU+xXa4BYLxnUhv2DB61u+FkkwfnTaSk
         QKiiLUp7ArVxw8WjLHuDZc6sRJVxm8W7wY5XQT+XB6mEelTF4VyqmwWnbHBcR/s11TR5
         8Bfw==
X-Forwarded-Encrypted: i=1; AJvYcCUau+tD0SrWa/xZjnhTaZxB4v6Bhgupprgu+J9wc/Bxq7lah5BrYgV1gegob78q14Vtebh8qYcdxw==@kvack.org
X-Gm-Message-State: AOJu0YwXTCl6bzOrchRU3ZEck//vrOc8kV3BGyS4h+sfT3ohqBz0VcJl
	9co4PcdcWzNPIESib7VIPzPcgRi/BzTe3OGeOrvImWGq+SU2SnvXUDWpg36jfal/uzTxZcX6ju1
	AqVnfKZsqQGC3eI1brdgSIOQYJUhLiWOanQOM3TiS5aMJZ9JC20hSh9bk5pGIaQybkzkfl7g30Q
	UZwkoO0KhIDOEe0v+uyVFCfKB37HuO
X-Gm-Gg: ASbGncswWpCR6ZUxoXXoiac+hLljShXFrLN+W9EsCFpKc4JcD9a1wZov6/kEAAM8fdh
	7KkBj2KueVK6GjLWLHAhHWqV3Fs1OnBo/cKTvVN3dJThBAi52T8DFAI/l8FrjMSuY0icbNhEw+A
	J/MJkAWYmWPsitj/JA+h2qPw==
X-Received: by 2002:a17:902:cf51:b0:235:ef67:b5a0 with SMTP id d9443c01a7336-242c2208e41mr124714825ad.36.1754916391696;
        Mon, 11 Aug 2025 05:46:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUSsMYIk1UpybPX4GBfcj8m+7ykkshfaUxy3ruyrRoUbnrlABiVsmhhcAQYAJVGJh1DFXQF44Oi+aOnUsFByk=
X-Received: by 2002:a17:902:cf51:b0:235:ef67:b5a0 with SMTP id
 d9443c01a7336-242c2208e41mr124714595ad.36.1754916391174; Mon, 11 Aug 2025
 05:46:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250811-numa-dbg-v2-1-7842aa2d4c41@oss.qualcomm.com> <aJmjXABrInqumY1-@kernel.org>
In-Reply-To: <aJmjXABrInqumY1-@kernel.org>
From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Date: Mon, 11 Aug 2025 18:16:19 +0530
X-Gm-Features: Ac12FXxTrprsoGfTXcp2hVKQ3QPi6mhVZaijVPOAmyMeR3UBFPT02_vLXqcujpQ
Message-ID: <CALzOmR0rhjfWrULWp=1C7epyFRJUMqAtpz4xLMS9a0cDu3z2nw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/numa_memblks: Use pr_debug instead of printk(KERN_DEBUG)
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: multipart/alternative; boundary="0000000000001b578c063c1650af"
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA5MDAyNyBTYWx0ZWRfX1owr6tXtGsKi
 Gr24RAHO2as+hMgOIN5p2DSYgYXEpiIM6SsDrKfyW8bnenT8htu+1R1XTV2rxRmA7+JF6UEsBri
 8iyhNKvjXt/mFEEFlYaul9B4dwyXkUZ4M2HTOS9kplgPJIjR01mkLbfEqPYLDbPn5ZHZmkqG1a+
 fnL/ZdJ9pKjSRzpfUkbBerOFsldcRgjkPCm/j4zLFzCD6/fXse04r27SH2leEt+cuOszce352aN
 UbF+E/tJ4HRqJBZNdJ+UNlbVXw103CWSHSbVpfYu7HldW8bP7Y95T8wFAEccC4uC6/cZPbIM8Ls
 xDY3uXUgTXx/XUVXCR5xnDmJPMsn6ZmXTrtkMHgsM1ZhRaWnSsaXPQz5Kq65uDGSEpoy/GJR3pG
 HcbpjQFF
X-Authority-Analysis: v=2.4 cv=fvDcZE4f c=1 sm=1 tr=0 ts=6899e628 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=pGLkceISAAAA:8 a=7J4mmper_PH-bgyCdsoA:9 a=QEXdDO2ut3YA:10
 a=QfQeIlgEMGjqttuRjYEA:9 a=y369VYwgyOTHPdyk:21 a=lqcHg5cX4UMA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: Upou2SrblVBJeeaPP-xzreoHeN7_TQcu
X-Proofpoint-GUID: Upou2SrblVBJeeaPP-xzreoHeN7_TQcu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 clxscore=1015 phishscore=0 bulkscore=0 impostorscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508090027
X-Stat-Signature: ya61qmgkshjdkbnk14jknof664hyquen
X-Rspamd-Queue-Id: 4DDA64000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754916394-827155
X-HE-Meta: U2FsdGVkX1/mRZEgoNt21jxNDPqM2NmkR7envezNtBm2jlfzsO3bq8hKy7rrTYfo6EljF88ayNQwr/uiFnos3ZIAGIjL+uXNrsq/KY7LJA55ITx4Ul4+rMjjS4lJy1JXy/c2yv3NBaFcc82MsBFaD3ylyboXKfLtMLsquU4QRS9SglP6/ZbX3E2IzxmLq2SBs5+/0foX/yum6nSS/Eh+kRzGJFfIROPDl/6TbEZMCyrT/E7vzyjJNHRJwhO350F9+Q79mUoaZ4Ogkuq+4rnVO/ozLMhnShsSkVVvNMXYVZ0C09iqGSfYKAqt1JxQH0sMw1XrF+W4P7aZKxMVXq0Ulx14Rr2FNXrakU0C0URMInoRaRZrwrlGUsUCkFaNRYiYXcGDu6fJy/k4vq9tChQymKhL2vVlPV051rzL7uLmtpP4J2C04l/aONLCRqVB2nrYYw0qnzPJBc5tcwo4hEjjfmUgyIi2Rvvb8tPGEMuBRZYXnsI/QzjrYYlT3LtbZLJArfPh/5pVvVrSmXOu56hHoYemRgwwWFEcLzssj4UJLT1Jd2qOo/UkGOkXokJWgbZlXf8iJC7mtNHesL35NKvHggM1CYi0My+4uOLkiam3Xe7rHYCZryWWtmy1VUXRViuukMmMjBxRAeJz41tJGqkBQu9IdPxF6gK2xvMd7P3xqXu1R/JtP91+yFB0dFKJfjLoegnZIz3ypAcToe2P5xCoIBZeNJyj1xMsgjJSHBAtSnwLA79RJnTatAcoQSy0dNhW5+GEgX9ZannifLtf/fUsR8XorI/aWEHSGUHyJFmRiYxuuPgE8ZZJeJd4IFHGxxKQ6G13duqqaGNCHRMi9Yy3UuYZNnyoidHjNUmhjNqK1ClwiS+8AbXi3KwZBQx+03rNyTAvqroQeiodvlNqriPRQ01Cog+X4/hpodx6Ia8T0nhw7MAwfrr+uE75MoraI6VZBYn+BgJAGtnM8Jstiu2
 sOmVnQ+J
 889wdlNgltPhAVSamguDsIyYAG6y0fZYutbTs+c9YOPZ9Ml8CYkMw+PyT1u4M1Tce3nde8Oj70oI0W2FOmRJMXccmcIqTL9OzTWVqbBO50efPVLGYBaJ8G3hDRIbwlC33Jhg+SFGjNPcbwtuugRAk4vKmFfHE2fT0ALUVTcf7K7zsR5C9ezrM5+sstMZEopPP+zDdcGh8KcAOULKuY4Z7jFqUt0qmGRppXXSUCxhLVphvkkiSEICrPxAoTj/MnWXJuvFkr1liap20xGpeQYD59pyEQAUEVKDk63x/KkAuA/dNN2DWhzKFTJHWB8Sf5bewwjKfZbZk4BGlroLq61ORgcpvhmTwM1o5zPjmRXaMF1WJ/U9ID6QOwJiMzGMrnMPqT/7eSr6Q6qk8akD1HjZOAKVfH0WtFG/4qXVAAlc39QhA+UgfIqXK2nbUrFUxnzakEsNVikDYghZOJ1K9Rs4CPEQZHnlvWibDEfCN+iSUQpbWZ25LUQ54RwWZOP+2gDCNfC6OOKWzItpjjBVtC3dIDvEwxyQLEQO94yAbqYDR0024AFV/2m6/03mzx8y3argPWYn1Gu+rWvOtTbP08eQXrSPBg/UE/sAvd87r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000001b578c063c1650af
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2025 at 1:31=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:

> On Mon, Aug 11, 2025 at 12:13:54PM +0530, pratyush.brahma@oss.qualcomm.co=
m
> wrote:
> > From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> >
> > Replace the direct usage of printk(KERN_DEBUG ...) with pr_debug(...) t=
o
> > align with the consistent `pr_*` API usage within the file.
> >
> > Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> > ---
> > Changes in v2:
> > - Removed printk header as suggested by Joshua.
> > - Link to v1:
> https://lore.kernel.org/r/20250808-numa-dbg-v1-1-2ddd1ec634aa@oss.qualcom=
m.com
> > ---
> >  mm/numa_memblks.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> > index
> 541a99c4071a67e5b0ef66f4136dee268a880003..ed6fcfca057ab4c9a8aa26cd1929551=
b4ded4a5b
> 100644
> > --- a/mm/numa_memblks.c
> > +++ b/mm/numa_memblks.c
> > @@ -2,7 +2,6 @@
> >
> >  #include <linux/array_size.h>
> >  #include <linux/sort.h>
> > -#include <linux/printk.h>
>
> Please don't, pr_debug is defined there.
>
But I had compile tested this code. I wonder why it didn't throw any error.

>
> >  #include <linux/memblock.h>
> >  #include <linux/numa.h>
> >  #include <linux/numa_memblks.h>
> > @@ -76,7 +75,7 @@ static int __init numa_alloc_distance(void)
> >               for (j =3D 0; j < cnt; j++)
> >                       numa_distance[i * cnt + j] =3D i =3D=3D j ?
> >                               LOCAL_DISTANCE : REMOTE_DISTANCE;
> > -     printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=3D%d\n",
> cnt);
> > +     pr_debug("NUMA: Initialized distance table, cnt=3D%d\n", cnt);
> >
> >       return 0;
> >  }
> >
> > ---
> > base-commit: 479058002c32b77acac43e883b92174e22c4be2d
> > change-id: 20250808-numa-dbg-62a8b2092c56
> >
> > Best regards,
> > --
> > Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> >
>
> --
> Sincerely yours,
> Mike.
>

--0000000000001b578c063c1650af
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Aug 11,=
 2025 at 1:31=E2=80=AFPM Mike Rapoport &lt;<a href=3D"mailto:rppt@kernel.or=
g">rppt@kernel.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote=
" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);=
padding-left:1ex">On Mon, Aug 11, 2025 at 12:13:54PM +0530, <a href=3D"mail=
to:pratyush.brahma@oss.qualcomm.com" target=3D"_blank">pratyush.brahma@oss.=
qualcomm.com</a> wrote:<br>
&gt; From: Pratyush Brahma &lt;<a href=3D"mailto:pratyush.brahma@oss.qualco=
mm.com" target=3D"_blank">pratyush.brahma@oss.qualcomm.com</a>&gt;<br>
&gt; <br>
&gt; Replace the direct usage of printk(KERN_DEBUG ...) with pr_debug(...) =
to<br>
&gt; align with the consistent `pr_*` API usage within the file.<br>
&gt; <br>
&gt; Reviewed-by: Joshua Hahn &lt;<a href=3D"mailto:joshua.hahnjy@gmail.com=
" target=3D"_blank">joshua.hahnjy@gmail.com</a>&gt;<br>
&gt; Signed-off-by: Pratyush Brahma &lt;<a href=3D"mailto:pratyush.brahma@o=
ss.qualcomm.com" target=3D"_blank">pratyush.brahma@oss.qualcomm.com</a>&gt;=
<br>
&gt; ---<br>
&gt; Changes in v2:<br>
&gt; - Removed printk header as suggested by Joshua.<br>
&gt; - Link to v1: <a href=3D"https://lore.kernel.org/r/20250808-numa-dbg-v=
1-1-2ddd1ec634aa@oss.qualcomm.com" rel=3D"noreferrer" target=3D"_blank">htt=
ps://lore.kernel.org/r/20250808-numa-dbg-v1-1-2ddd1ec634aa@oss.qualcomm.com=
</a><br>
&gt; ---<br>
&gt;=C2=A0 mm/numa_memblks.c | 3 +--<br>
&gt;=C2=A0 1 file changed, 1 insertion(+), 2 deletions(-)<br>
&gt; <br>
&gt; diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c<br>
&gt; index 541a99c4071a67e5b0ef66f4136dee268a880003..ed6fcfca057ab4c9a8aa26=
cd1929551b4ded4a5b 100644<br>
&gt; --- a/mm/numa_memblks.c<br>
&gt; +++ b/mm/numa_memblks.c<br>
&gt; @@ -2,7 +2,6 @@<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 #include &lt;linux/array_size.h&gt;<br>
&gt;=C2=A0 #include &lt;linux/sort.h&gt;<br>
&gt; -#include &lt;linux/printk.h&gt;<br>
<br>
Please don&#39;t, pr_debug is defined there.<br></blockquote><div>But I had=
 compile tested this code. I wonder why it didn&#39;t throw any error.</div=
><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border=
-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
&gt;=C2=A0 #include &lt;linux/memblock.h&gt;<br>
&gt;=C2=A0 #include &lt;linux/numa.h&gt;<br>
&gt;=C2=A0 #include &lt;linux/numa_memblks.h&gt;<br>
&gt; @@ -76,7 +75,7 @@ static int __init numa_alloc_distance(void)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0for (j =3D 0; j =
&lt; cnt; j++)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0numa_distance[i * cnt + j] =3D i =3D=3D j ?<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LOCAL_DISTANCE : REMOTE_DISTANCE;<=
br>
&gt; -=C2=A0 =C2=A0 =C2=A0printk(KERN_DEBUG &quot;NUMA: Initialized distanc=
e table, cnt=3D%d\n&quot;, cnt);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0pr_debug(&quot;NUMA: Initialized distance table, =
cnt=3D%d\n&quot;, cnt);<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 }<br>
&gt; <br>
&gt; ---<br>
&gt; base-commit: 479058002c32b77acac43e883b92174e22c4be2d<br>
&gt; change-id: 20250808-numa-dbg-62a8b2092c56<br>
&gt; <br>
&gt; Best regards,<br>
&gt; -- <br>
&gt; Pratyush Brahma &lt;<a href=3D"mailto:pratyush.brahma@oss.qualcomm.com=
" target=3D"_blank">pratyush.brahma@oss.qualcomm.com</a>&gt;<br>
&gt; <br>
<br>
-- <br>
Sincerely yours,<br>
Mike.<br>
</blockquote></div></div>

--0000000000001b578c063c1650af--

