Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E98D0CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC1206B008C; Fri,  9 Oct 2026 02:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72086B0092; Fri,  9 Oct 2026 02:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60906B0093; Fri,  9 Oct 2026 02:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B135A6B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:21:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10E301A0277
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:21:41 +0000 (UTC)
X-FDA: 85302091602.14.5816E76
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf04.hostedemail.com (Postfix) with ESMTP id 970CA40005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:21:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=iaT8XOEs;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf04.hostedemail.com: domain of "prvs=87421dbcea=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=87421dbcea=alexghiti@meta.com"
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791526898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaABAWmrmfeC0SrN4QFEmF0a1FSyEnSSctRb+pjY1mg=;
	b=mRDl6zFiQ5NaguhFGBlrBvYnb/0N0wnETmfpSP52qIvFMjF0cYuHN+ksR4IRpGkx9tysCV
	TE39f1XQCUF0eToQTzDMXZnKkgTlp06qSbwyknkFWFy/sn43WmCANPVYV0VE3tXpkRNjom
	oVIePbrG/dz+zDZX42CAoEpffKwpQKU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=iaT8XOEs;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf04.hostedemail.com: domain of "prvs=87421dbcea=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=87421dbcea=alexghiti@meta.com"
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1791526898;
	b=TgOLE69v7uZApI+vC1tOS8/QkNxRyMj+y8lgcTG9/hCqyT3kBcL4nLmeRTIiYzmRDDt4Gb
	v1x9x/bW69033P7YsnS3BLAR2L5PeEM3ry+hpabCMWnGYIGrdbbTetTpHoSgmCmhLfzy28
	sLXfrCPVYt5ZIOAZBwjrFq5i+sVCLvc=
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69956WV23215879
	for <linux-mm@kvack.org>; Thu, 8 Oct 2026 23:21:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=CaABAWmrmfeC0SrN4QFEmF0a1FSyEnSSctRb+
	pjY1mg=; b=iaT8XOEs5nMBNyXYmG7LMLJhle2r5WJ9AJxCeC+0pCdr5z/DHCnVV
	GvGxBoStC6gW0hn1pOaJnfbzHQQuq/WobCVvFztxjzIax21ca2fNOJbaqPaZQfP8
	YjI3iPRdvXfpeLlsTU9PWgVOeYqhQjCnnMoGpM74ZQGRklH7Ck7Reiv/d+uyrQdO
	eSgLtlBOyfjv7V7pV9DZP8Sdm1BM6YpO2ClRepr65nKJuPaTAWUM3TACGD1+fQW2
	MzqL9587tuHLplXrbQs4JxyKDvHlEswBCIUN0Rxiwo33ssPXQsiyoGwsgEcTklNB
	gmDH2YLsbCLWMTGssbALvhnzh2si9v+iQ==
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by m0001303.ppops.net (PPS) with ESMTPS id 4h5xdhw0uu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 08 Oct 2026 23:21:37 -0700 (PDT)
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c2e5d6c4e8fso781099966b.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 23:21:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791526896; cv=none;
        d=google.com; s=arc-20260327;
        b=lIGOXIQGe6igzRifB/gu8N9DxB61U7F0tJMLIGC4wOS2fwerLyccD9n9FRAQfTwjnX
         YszibevKX6dWVuvRIWVrY6tzMgUisj00lFDLDiA6xptuBJQ3drhhsjGzSSSnwebM2OQn
         eqXFx9iBUdo6Sk/MqZZFQ6JkmBwscsZ4eq30M+Is5ffqUotfj291rTP5otBN8VdoVElp
         GXJ6pU1gs6kUaC04GS5TqnDFFglfFkT7CKpBXlBAKfJXeuGvWe/CZd//Hk4/disM4+zL
         dGySN0WpVe2xfKdlokp0eETc7J3YVPl/mBzmhJNg1Gd0AX05r3RS1CB4H9rEVESBDjlu
         HdLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=JsKDox/DOR17cT5dHGriseWRFApPYTjGYYWCVV6YZrs=;
        fh=kR9BxRnTPIeWADMFTeL3xftwE5CuUzsKTOiCcE8l3Jk=;
        b=D75AwnzHEMsU4A1AHxaQ8/CSTNEj2gGQAb4mhij67yM0basN4th9DKxaHciAIanqUN
         BjvOR8AkPGxtep8v7wcUudlhqIWb1EirHrc6lr7i4262Z85uQkzFxDv/hNXlpzhxBOTT
         OiEn3I/cfz8r1CTf4wJYcNFgChhbByS32gUUiB+FATpEzCV1n4HYqDlHTAhJha2znGFG
         bFUkSaOBReHkZqsWYOw9ae1dcFbRyaIT/+YF7e4C+Xv8KiyahA2syYyu6czNr6cDv2Y/
         lh4b3dcYpRwl2v2wWY7W7aiFSx62l91Ybwm3LC99b3Z7CjfxI6is4qgKwoBUeTq8bihu
         Em+A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791526896; x=1792131696;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JsKDox/DOR17cT5dHGriseWRFApPYTjGYYWCVV6YZrs=;
        b=gf/bSFcBV7EThgm4gggEjpNuP+IrAp5DFlFLOLWFg3HYG+0DRhcdSEGMNWqTuI8V/Q
         9u/5FH5v4k/xXyfjDiFcMrUWXV1qTdiutS2jd6XnWPapcibeqc52R8mFCZNH0lXb1l+6
         JZIzCFO6mhQcJ3PLwz7UgZs38a/8jEzOy4qAHlJwSImRk8dK++u9bZAeFLgs1mtVm5ds
         h5RYI2a9SLYM0BGqoTA26A31xppPgO0hugVRBjB0Q2nKkyOA6xLcR6KKwIrcifvcammF
         0AE8WvIk3QeyGfFmjgUUA4+065u2+/ubLZqgWoQtGmwdBZrZQMVOIWdwH7BIjqQuD+81
         K+mQ==
X-Forwarded-Encrypted: i=1; AKwUvBywa0JF2xB8jZHxHre/AsPqKJOrYYLPdjb3y+yGWnOca4ePCTLAQQ8q2eZ7tekhRyehwfqF1rld1w==@kvack.org
X-Gm-Message-State: AFq9FYJH9UwVrZxKQqwcj03s0hCcM7PBalnW3YN6KcbQ3GeNfZyl9JNv
	0picxqjHiduIkyWKpqJka25gVWXEYt59Mlyd2gV9joQj5O28Da0V/5YQIpyTgJlA8Qa3ykCRHZh
	SA8huP2NeebttxHT7Xtd6EF812DcFw3g4qb9A8jSibW6Y9pfhEALljGiloyAiDew9yyZD/noSWY
	UollmMkxDbbDtgPF/Cw4EkbNLqJA==
X-Gm-Gg: AYBFou0eadmYYYVUcWwvIa56id6Dl7oUYU59MCMSO8sI4bVAy65K8LW8uW7bI8rdT2e
	tl2uRKTqHtOp3V+SPmGP7oOY7cfLtxkjHOUyoUUFLsbD+Z4Zo7Lf4YxasHZCVyyyb1Sjyv4Xdqu
	03sgFaKSp3pcvVwEye1HscL3NkTU2fhd5UpHDCGCion7AFHxXHutdE15r3xYf8G0uNQ+Nlv6Fp1
	OnoeqBTJfwgPjlR2w==
X-Received: by 2002:a17:907:d8b:b0:c21:180c:d82d with SMTP id a640c23a62f3a-c31aa006731mr90680966b.20.1791526896266;
        Thu, 08 Oct 2026 23:21:36 -0700 (PDT)
X-Received: by 2002:a17:907:d8b:b0:c21:180c:d82d with SMTP id
 a640c23a62f3a-c31aa006731mr90678166b.20.1791526895838; Thu, 08 Oct 2026
 23:21:35 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr> <CAO9r8zMHKmAQT8WBAd+kkQEjETVvyHhfbESzKHpXXPQJUB9nVw@mail.gmail.com>
In-Reply-To: <CAO9r8zMHKmAQT8WBAd+kkQEjETVvyHhfbESzKHpXXPQJUB9nVw@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Fri, 9 Oct 2026 08:21:23 +0200
X-Gm-Features: AclHuK_ofVrPNacPxpsIYVVCE3Ue6MuHcG8aof-vcNnWTyl8bOgx_1bILK5lleA
Message-ID: <CAEmasaUijhEyxTL=ODsjA4ik1ZuE4y0kh700NKGta5LDH8nqUA@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Yosry Ahmed <yosry@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Kairui Song <kasong@tencent.com>,
        akpm@linux-foundation.org, hannes@cmpxchg.org, nphamcs@gmail.com,
        shikemeng@huaweicloud.com, baoquan.he@linux.dev, youngjun.park@lge.com,
        chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org,
        liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, ryncsn@gmail.com,
        chrisl@kernel.org, baohua@kernel.org, usama.arif@linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: KcyzLP-_2nETVmaKuhGreTvnVW7s1UC6
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDAyNCBTYWx0ZWRfX1hWchJaK/Ff0
 OGafZ5cq2MZnvFuPDEfJ72L6ud2AvfAuUFGMT8Pl3z1STEYC8sPfz1za72qmW/T+3OYVlzJW4hM
 tW+yKHZrTZud+T+GN+nK9ZO9JdNMgag=
X-Authority-Analysis: v=2.4 cv=aognmiZV c=1 sm=1 tr=0 ts=6ac887f1 cx=c_pps
 a=D+UBI74RbQA8i2EYnbuvxw==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_78whYxrdx1mplLwxq1U:22
 a=OGjWj8McAAAA:8 a=VwQbUJbxAAAA:8 a=EsdWce9n9fk95wY-pwkA:9 a=QEXdDO2ut3YA:10
 a=UYjydHh6ynBBc6_pBLvz:22
X-Proofpoint-ORIG-GUID: KcyzLP-_2nETVmaKuhGreTvnVW7s1UC6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDAyNCBTYWx0ZWRfX285EeyF+hc+f
 v4Mg0Tt+LEBgNGOl7ThNOGFxhK86aAzuRPat6P8F8GCaipG97YvYCw2R5XLBc75O7s5S3A6pg5O
 AFqulzuSeaUviWKR1IITZ4kpr/IWH7KGNrUTNmbmBoL8kE6w6s8HGJBGxqHPj9t0T4+0czbffnB
 WDMzRheobHsV5pKRswDvHNDnRWrodNiC+Z4OsWEa2Boji6CA1QD27IXzP6qc+j2U4Upt9f65GrB
 h4zdyCO7kYkWQIIqyaph7tkWJz394Ld/PJk7oMzJVIctho+Vy1vbiKZ0frszJnPbeZQEs0ZtNHx
 L1B8ufVECrmNdLXkAdl1P9ioyOh7JUM6GEialjDVOJnsj3fVeZVdj38Ve7G24bwDRYAT9HZRKy7
 kSInI3u5yMU5lYS9hnESTEud0Fwh1KkQPgdqKgDHw1VQkox2TkKADX8DlvQp1FkkBXuPUn7/+Bj
 +w3rb1+db4D/PQwpEXA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_02,2026-10-08_01,2025-10-01_01
X-Rspamd-Queue-Id: 970CA40005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: bf3yu8c45c7hindms98k84aziaswpbpr
X-HE-Tag: 1791526898-905483
X-HE-Meta: U2FsdGVkX1/wtqp1inQ+7ThF9Zlgk+VM5vhwWOoNLJV1kID7YObq4PgsCFnNq9Beb4qjQChg5Xi19TOnhcDXAnX6U5tlKiCJR0ZAThdXkdCa9E302H7v0VmcCrnvyJSL6vi9/CxhdLsR/6J1RgXgo5OPLQAOfnjI7qgsxx5/aiEPmnfEkhkzXBIhHi/9LahKofm97gOcnVKpu+snM5HxuLgjzsx/yp1uAsm2ZAhINcX6itqbe2eJWjt6RgDfkfbiY170d/KQtLrFc0iIIYMIitysjgP8Px3ZDw9z4DKlTi30ssLQZqAmvswtzqhnr/aLK25PWCOLiseYJZVe67tgwAQSI9t/AmB665AjWUUVLqsg3sGBhqfG1VJ5PYEhu7laz9Tsz3njQZvrO/XQ3tM6JjTygQ0j/UyZE73V4DfqdX4eopOAsJee8zJMTn0RkQ+DohSfaOeQ90vXMIquvC4uxxX3erZ/BMBrYpL+IF4AW/WDwN11x5GL9fKJKn5dBhoXhE6nIocsyO6VTBn8ZiV2tCSGpYWGQssZGUKovhH9LmJaHaPX9ZoHPZawv9h2dXMpyEHoe4ouhbgwnBArC0b2d4rFFgYmRyZqBIG9IVD/hvgNNUCG9wr08otc3kNU4gEYjIno5aHK7lyEEWSgQT98T3l8lZILDVDEA5l1qbYiIfONXe1+g/x/FlVc7jSJPecuKGiCdg9HOKa/wkEpgkMMrLdLqc+hw0SC7bPmD/NLN1J3BjHcbUqaqxTVv/vT7lPImUv8SZtF5cTj2VJBF0Dq9axlW5MwP+Hny870iCUIc3AKuP+NUlSbTDxRJMHM4W1dEvIfuETu5PnI6pgZ8jsWyqfyEHDaFl21viBraUniQz9M774SzyGp1AvWmRADw7Ntmv8WJTDgGu5+gfuYaNhGttflueq+O5BjrKDGW/yTyEbTal3BI4V9SZJuI6aBVDiEPET3lFBYX5aTTRywgYX
 nQjP0FS4
 MWa9ulX3gsRZUg5wXDUPkUwsKfZpakahy+XSWmcOGH2XovDWt4oxNkqIjRShSUE0vxhSqGXzu+OuwPrH7bYGq/vC/uCZATvJ2dUa8qIzvcop+PN2P00AbDRJFuMiaUki4oYkHH2fYlhbRdeiPbqK0oOuiU5AqPC42J/RyoReTYNFj+5VMIFxNJ2AJSD4/we94s9XwoG6fNX//BbsVGR66kiYI8Si8yHPV+Nl9aEVMXZmoXkxBRs11fqN915h33a5TOvIAO8exbQ5L+Mk8LFNWKyaysvGu0Mk1H4PYvy6fLeXIvE5H3V/uO1UcQDrvePUY1vpS2rO27hqgm2S4oNsBEfUVRgHEGCm52vcy8xSVp1UFALtFyIpyXfLPrBuvvRTrlrzAAyIZBVN/cSjzFsA7An0dFYMDxKsPRvfAkPicc2l2W0iYMKLdyScM4XBPQCRT/hIzw2j2Kyv6MK4c3rLAK0WH5dhM0cz6UyQMaIg/VNUQvCWRhM9naJHWKObcfOnuNlZTKUZgESKbT7L8UMgnB1CwqkxVwnbywhTkUvsg+iSKpSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yosry,

On Wed, Oct 7, 2026 at 11:37=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> >
> On Wed, Oct 7, 2026 at 8:39=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wr=
ote:
> >
> > Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
> > device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahea=
d.
> >
> > zswap is the same kind of in-memory, synchronous backend as zram, not a
> > swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> > swapin_readahead().
> >
> > Here are the results from bypassing readahead for zswap too: it was
> > measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, shri=
nker
> > off, on Sapphire Rapids and 3 iterations.
> >
> >   768M memcg (sustained swap thrash):
> >     metric                 mm-new    + bypass    delta
> >     build time (s)          405.0       341.7    -15.6%
> >     zswap-in (GB)            79.5        53.0     -33%
> >     zswap-out (GB)          144.8       115.6     -20%
> >     swap readahead (pages)  6.79M       0.45M     -93%
> >     swap_ra hit (%)          72.1        89.9     +18pp
> >
> >   1G memcg (light pressure, build not memory-bound):
> >     metric                 mm-new    + bypass    delta
> >     build time (s)          177.7       176.0    ~same (no regression)
> >     zswap-in (GB)            10.2         7.5     -26%
> >     zswap-out (GB)           27.7        25.1      -9%
> >     swap readahead (pages)  1.07M       0.08M     -93%
> >     swap_ra hit (%)          68.6        87.2     +19pp
> >
> > Similar gains were observed on an AMD EPYC 7D13 host.
> >
> > The gain is from no longer prefetching pages that are pointless for an
> > in-memory backend: readahead inflates anon residency and thrashes the
> > page cache (file pages get evicted and re-read), lengthens each fault by
> > synchronously (de)compressing a cluster of neighbours, and adds
> > compression traffic when those extra pages are reclaimed.
> >
> > Bypassing swap readahead for zswap therefore makes sense.
>
> No objection here, I am just thinking about Kairui's LPC presentation
> about how compressed swap can (in theory at least) still benefit from
> readahead: https://urldefense.com/v3/__https://lpc.events/event/20/contri=
butions/2421/attachments/2116/4689/Better*20Anon*20(Swap)*20Readahead*20(2)=
.pdf__;JSUlJQ!!Bt8RZUm9aw!4SSWs97-L1JNciWpQqvSw5xpIAUSZorWG4UrxCy7RYlUbAY1n=
jEfPPH-OBH8Ny1fqOOB7TpHMM2-$ .
>
> Seems like a big portion of the fault cost is still outside of
> decompression and can benefit from readahead, but that isn't the case
> today. I assume any future improvements to readahead and re-enabling
> for zram would also cover zswap?
>

I'll follow Kairui's work and ensure zswap stays aligned with zram.

Thanks,

Alex


> >
> > Suggested-by: Usama Arif <usama.arif@linux.dev>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
> > Changes in v3:
> > - Go back to the RFC's single patch: readahead windows that mix zswap
> >   and disk entries will be dealt with later, the priority is to merge t=
he
> >   zswap readahead bypass
> > - Move the check into a swap helper, swap_entry_synchronous(), instead
> >   of open-coding it in do_swap_page() (David)
> > - Bail out early when zswap was never enabled or the tree is empty, so
> >   disk-only systems pay a static branch (Kairui, Nhat)
> > - Reuse zswap_is_present() rather than adding zswap_present_test()
> >   (Yosry)
> > - Rebase on mm-new
> >
> > Changes in v2:
> > - Keep readahead, but overlap the decompression of zswap neighbours with
> >   the disk I/O of the window, and bypass it when the target needs no
> >   disk I/O (Yosry, Nhat, Barry)
> >
> > v2: https://lore.kernel.org/all/20260722163536.773166-1-alex@ghiti.fr/
> > RFC: https://lore.kernel.org/all/20260624075700.751467-1-alex@ghiti.fr/
> >
> >  include/linux/zswap.h |  6 ++++++
> >  mm/memory.c           |  4 ++--
> >  mm/swap.h             | 25 +++++++++++++++++++++++++
> >  mm/zswap.c            |  5 ++++-
> >  4 files changed, 37 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> > index df6cafbe95dc..94746fb71bb6 100644
> > --- a/include/linux/zswap.h
> > +++ b/include/linux/zswap.h
> > @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
> >  void zswap_folio_swapin(struct folio *folio);
> >  bool zswap_is_enabled(void);
> >  bool zswap_never_enabled(void);
> > +bool zswap_is_present(swp_entry_t entry, unsigned int nr);
> >  #else
> >
> >  struct zswap_lruvec_state {};
> > @@ -73,6 +74,11 @@ static inline bool zswap_never_enabled(void)
> >         return true;
> >  }
> >
> > +static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> > +{
> > +       return false;
> > +}
> > +
> >  #endif
> >
> >  #endif /* _LINUX_ZSWAP_H */
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 330cde31bf8b..396bc71a265f 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5030,8 +5030,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >         if (folio)
> >                 swap_update_readahead(folio, vma, vmf->address);
> >         if (!folio) {
> > -               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO dev=
ices */
> > -               if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
> > +               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO dev=
ices and zswap */
> > +               if (swap_entry_synchronous(si, entry))
> >                         folio =3D swapin_sync(entry, GFP_HIGHUSER_MOVAB=
LE,
> >                                             thp_swapin_suitable_orders(=
vmf) | BIT(0),
> >                                             vmf, NULL, 0);
> > diff --git a/mm/swap.h b/mm/swap.h
> > index d5bf21f517dc..b8181bd056ee 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -94,6 +94,7 @@ static inline int mem_cgroup_swappiness(const struct =
mem_cgroup *memcg)
> >
> >  #ifdef CONFIG_SWAP
> >  #include <linux/swapops.h> /* for swp_offset */
> > +#include <linux/zswap.h> /* for zswap_is_present */
> >  #include <linux/blk_types.h> /* for bio_end_io_t */
> >
> >  static inline unsigned int swp_cluster_offset(swp_entry_t entry)
> > @@ -336,6 +337,24 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t=
 flag, unsigned long orders,
> >  void swap_update_readahead(struct folio *folio, struct vm_area_struct =
*vma,
> >                            unsigned long addr);
> >
> > +/**
> > + * swap_entry_synchronous - check if @entry is read synchronously
> > + * @si: the swap device of @entry
> > + * @entry: the swap entry
> > + *
> > + * SWP_SYNCHRONOUS_IO devices and zswap complete a read in the faulting
> > + * context, so swap readahead has no asynchronous I/O to overlap.
> > + *
> > + * Context: The caller must hold a reference on @si. The answer is a h=
int: the
> > + * entry can be written back from zswap or freed concurrently.
> > + */
> > +static inline bool swap_entry_synchronous(struct swap_info_struct *si,
> > +                                         swp_entry_t entry)
> > +{
> > +       return data_race(si->flags & SWP_SYNCHRONOUS_IO) ||
> > +              zswap_is_present(entry, 1);
> > +}
> > +
> >  #else /* CONFIG_SWAP */
> >
> >  static inline struct swap_cluster_info *swap_cluster_get_and_lock(
> > @@ -423,6 +442,12 @@ static inline void swap_update_readahead(struct fo=
lio *folio,
> >  {
> >  }
> >
> > +static inline bool swap_entry_synchronous(struct swap_info_struct *si,
> > +                                         swp_entry_t entry)
> > +{
> > +       return false;
> > +}
> > +
> >  static inline int swap_writeout(struct swap_io_ctx *ctx, struct folio =
*folio)
> >  {
> >         return 0;
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index eb3494491410..1dcf77d5edae 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1605,12 +1605,15 @@ bool zswap_store(struct folio *folio)
> >   * change under it.
> >   * Return: true if at least one slot in the range is in zswap.
> >   */
> > -static bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> > +bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> >  {
> >         pgoff_t offset =3D swp_offset(entry);
> >         struct xarray *tree =3D swap_zswap_tree(entry);
> >         unsigned long index =3D offset;
> >
> > +       if (zswap_never_enabled() || xa_empty(tree))
> > +               return false;
> > +
> >         /*
> >          * A pinned range is at most SWAPFILE_CLUSTER slots and is alig=
ned to
> >          * its own size, so one tree covers all of it and a single look=
up is
> > --
> > 2.53.0-Meta
> >
> >
>

