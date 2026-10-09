Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7095CCA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48A8A6B008A; Fri,  9 Oct 2026 02:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B306B0093; Fri,  9 Oct 2026 02:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3512C6B0095; Fri,  9 Oct 2026 02:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D07D6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:22:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99F36140229
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:22:42 +0000 (UTC)
X-FDA: 85302094164.24.BC3F3AF
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B14740002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:22:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=BVxSNA9E;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf01.hostedemail.com: domain of "prvs=87421dbcea=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=87421dbcea=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791526960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrUTSyKtAgDV97zqjefAwYojktkvjwSj6eMRr4iTKmc=;
	b=l+vTeWB+8m5deXr1BI0aPnZwv7HjbQnzC3MyBG5HAQuYRsac97wVMIQVEcNlq63W8XGtt0
	fPB+91AF7sU35kAK2CVog02nCwNMSbbg7LxstHahN+msK1mN3hXFLqCJ0ttF2lsdzAnBiG
	BANHz5jVrLbUdf4MdDwzWrp6BQhO50w=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=BVxSNA9E;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf01.hostedemail.com: domain of "prvs=87421dbcea=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=87421dbcea=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1791526960;
	b=aErM9mY/uhVZCBwYUxis80EH9Xmiutp3HxFxGhURP0AAoSxTQwovFGduG/Z9CE2oh0Xgtx
	GF+HW/AcoVgeeqpT1z9lNe06xvXPkoXWLcewIKHcFf0O8IXS76eQ2yGeCgORDA9oTztKOs
	JOBvaOZMMNI/2MbsWQr3xbPOX2/DLaA=
Received: from pps.filterd (m0528007.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6993Ikc91466651
	for <linux-mm@kvack.org>; Thu, 8 Oct 2026 23:22:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=xrUTSyKtAgDV97zqjefAwYojktkvjwSj6eMRr
	4iTKmc=; b=BVxSNA9ENcWBzNnRptdK+cNy15VcM8QiGxhNxBVmCF5Bj7sm72HzR
	rQQ2FStXdG9W7lFYFsa6RN2RLe+/clIP0YWjq/IgUovEqaEduUZjgjTD+WqM8Ssa
	kmpRGhYoLbv4yAUffhGkDawKdfnQLK3YlhFTB4edFW6xtj5rVuu77pCiTiZTpyB0
	JztefpvE8noI/sHnhS/MWGCDvmyj4+1hXXEixjEHPWBlMQc/mDcIUTKw7fGyNRya
	Fa9Y1Jsf5FeDeF+jtLuvMuWFI37seTHdrgujE8nVMvwjbF+8n/FEmc2ouLLOF8SB
	nRrl3VRVwuh2EXxtDZNZHttS8zVqAj/5g==
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4h6pr99dhq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 08 Oct 2026 23:22:38 -0700 (PDT)
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2e8c76334fso483629666b.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 23:22:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791526957; cv=none;
        d=google.com; s=arc-20260327;
        b=spjPIekCIpyVay33kF5WZKiCGecJxtfeHkwcvulDvZ8FwOsKk4C5JGGFn/Wcf4FixM
         PF/p7D0rmYTS3DT5A1rfpAAVbiNC/pQzAXegyu58iXorX02kZwZwrEKQPf+PLXxe/4v2
         HSHtmEeAnAjvTMYVXYJ/b55qXnB4CBPogjIMRYe2HJT8wM8XHn9GmpNfXrov84QaugI/
         09QdvusDRSqdqnxnZhT47BBCUvK7wAxG9+WDqI9laitsYwgQs1uMdzeNjrRTkK6QkxYk
         f9OP5xDyyDrrOE/B8xcps92DoMBltVBe9Bcsvd24hDZsM93jJc5H+r7kkI8rUWCRpfxP
         X7Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=MDAPJbo8bAyD4SNPtt3cKmDaYLJkrQPEK8cHU6m22o8=;
        fh=i7Wg0gGR/mbOo2qmi781A9KBYcr2mLaH7b0bLQvpGTM=;
        b=dizziJXn48E1YxPmlcJtpUV4G/fw7KA3HrSEWaChKOFlqGT8hWgXtjTFzVtPhADuOX
         yusG6LTKM8KLBWHWJmo5gAumoNEhTUAD8YYEC/Fu37K4W2r03tb2D8BHN5joaQme8022
         SPC8oks0XfXlxbh9bjsXTMhTsMc2CVHk2a+oAA4JGBuuQ3UAM8hFwJi/zyCfLQCXEL9G
         SzLtdv1HOVzkqOz+jWsqjhseDkKkxWVnCy5HEcaBcnLkDxeF5oZLcuqIjrneDUJh4bPD
         jbePgfGEfxhlWbEHO/jrutQ6DhXrVFmXDDLCsSgOQWZFw2RuWlsrLHXu2bC13JtPGjEB
         Hl4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791526957; x=1792131757;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MDAPJbo8bAyD4SNPtt3cKmDaYLJkrQPEK8cHU6m22o8=;
        b=AatKVTCnjgXILhr/2ARJn4gxnzdlxVCrphhCtqpC/gBK3y7G9bTlYbrgez2xNUtMQi
         h+M0ax9hIibrb24147/R34haJjtg530L2n1jGKcThhtd5tXDoFkc9CF3RTVBGu2inAyz
         2c+E3sBoL2/2eCAO0Mq9IQWRAWyiZipGZmlDL/2in12NSRKX9i8OYUDbyzYH84vpzlq5
         nt6Tdaxp0gcITKjn9N69YJPkMzRK+A+VWoSpVmWGHqFInExYHQQTpwLT6ae23hufI6rm
         ovcma9YNCD3lY16BaNgCms10BJVKSNYfDmH6vv0FWBDQ25n4mMnc0dRbqQClVp7nHUVy
         /dzg==
X-Forwarded-Encrypted: i=1; AKwUvBxwGKwY8p+wKvIhd2B12TQW3dx5QdOh3XQ95jjFGxOS0qHvIth947DBq00dKsKeXKvjbJqMlwN+jQ==@kvack.org
X-Gm-Message-State: AFq9FYJndeUd81/zbHmsnB2fZDLBWYV5JY1b9UpWTI0psCX6MEET0ZOo
	wG0Xd2yKKAF56qGRbRXbmPvDgyySb45V3ECZBkm2R2hL46Ac5iAP79MCKbv2ud1Har7P29bruFZ
	67UGmO78MTCfzjaUp1gq08LxaWsxwvx1tXA0BlPRcUx9nEGOQzLPB6ry8LVPtpcD9++ryfhNouy
	8FYo57/yX0EjFNzUszveMUHYF+eA==
X-Gm-Gg: AYBFou2vrE6wDLXeQVP3iOpxYDSrFlqeD+wdHvLJPLqszb+pbIVULu5BGM/LtR1qDyQ
	40b21YuH5QmB9PLvE3hy7xXvWBrRhcKP8DZOksR4x/nvvsOAmFsiJB5kGMcfVJ1o7gGEYtJh255
	87X+xadOuQcSC11D8ja7RhQi9+lAq9m0Y982JB0Pj5y4LG+A2ZUhKyYdnFq1dYgin1hqxUlweiC
	nFa+x6PgSWN/03fVg==
X-Received: by 2002:a17:907:c298:b0:c2d:cf0e:49e9 with SMTP id a640c23a62f3a-c31a9ff494dmr71955566b.15.1791526957233;
        Thu, 08 Oct 2026 23:22:37 -0700 (PDT)
X-Received: by 2002:a17:907:c298:b0:c2d:cf0e:49e9 with SMTP id
 a640c23a62f3a-c31a9ff494dmr71952466b.15.1791526956831; Thu, 08 Oct 2026
 23:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr> <CAGsJ_4xyzgUH4uhKqpD7PTVuOzdsAkYgowsyn5iT1LHWiaYqqw@mail.gmail.com>
In-Reply-To: <CAGsJ_4xyzgUH4uhKqpD7PTVuOzdsAkYgowsyn5iT1LHWiaYqqw@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Fri, 9 Oct 2026 08:22:25 +0200
X-Gm-Features: AclHuK8gPOgXXx1_x49eCX24hRCcO1E5atvyhBXA0_dq3WEte7PYf1e43nP0Pwo
Message-ID: <CAEmasaWQm6DPqAhmW_z=kuR+3LDWJ=h+yM0hAs+ryNoFQd6qmg@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Barry Song <baohua@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org,
        hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
        shikemeng@huaweicloud.com, baoquan.he@linux.dev, youngjun.park@lge.com,
        chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org,
        liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, kasong@tencent.com,
        ryncsn@gmail.com, chrisl@kernel.org, usama.arif@linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=d55gWhjE c=1 sm=1 tr=0 ts=6ac8882e cx=c_pps
 a=edIAN7ErZTGbxav20d8A7Q==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=4h92JMTCafKA-fb_NiOh:22
 a=VwQbUJbxAAAA:8 a=vvh9Qk1aVFpNxidmG9UA:9 a=QEXdDO2ut3YA:10
 a=nIuFr-8touD1a-RngYHT:22
X-Proofpoint-GUID: FC_NVtDFfxFwkxRNb6e39GU4zyGWyMDD
X-Proofpoint-ORIG-GUID: FC_NVtDFfxFwkxRNb6e39GU4zyGWyMDD
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDAyNCBTYWx0ZWRfXzB4KLmzS1Mrv
 H2b7stywrzvYHOp4kxCMLONx+DUyJuH3hkMtUzBxuZDPQw+8kvRNrAUUANA1CXei7P/D+qmcMjL
 sh7YILk6N4SoOamxFCTJjnQjPwhgx4U=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDAyNCBTYWx0ZWRfX8gxRkQKaUUR9
 /uRFSieh5/8Mx2QSYuTAo5t6r4Cl4jQ5ldradibnNpczcgTUOvi/C0Nl9iRtTySqiUvouOlMWA4
 tLplg9jRF/hVhpSKzfFEynSk0M1TYZ6uvCPbpKOm7a8QTrBGwzqA0NS03CbMLoxxtsHoMYXlD5F
 8Bu2sJRq7U+xZ4OPEfOhwmLZlenEIYVPobTlu/gpBa6nB/NVTggR1Jw1vxke2qgBVOAVf1DRz4q
 119kyDel6Q2+CACV8JxSMFCkrFdr49WT7tWX2KeVJCJQrR3yltgsMSl7i85MXT0NptWrXV8kQEc
 tUDMs+5o7OfVxOcW0T4NNv7w3VzMKppcK58VMaloeu3oJ+jGRcrXGTAf8FcV+7Cl9DitGvahOK/
 jZ0umjw0vOzDOKkCPK7DN/QN5DX4/5M1mgFn0Aj3c65oW1CUGaowPhg/QAq7FPl+CtCPE81WeQd
 j1r8DZytmeAKmW98jrw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_02,2026-10-08_01,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1B14740002
X-Stat-Signature: peoq98ty4b33po5orprcz8sd9c5mkpoj
X-HE-Tag: 1791526959-154541
X-HE-Meta: U2FsdGVkX1+DDBkyQdnwg7Zcd4PKGr3KGEyvFAMiM4olgsPOIi9vcJgESosU+Y6IUWUAnTLjaJ5S7IU7kPRMVxjmRcjsP2l3MMDCyMshFm4QFcgE+tKF/qfXb1bfDLkJb2Yx2DAD8ZVPv+6JFZXFH6oKvxY9k33hHTU19f+3AOYr91p3XgnhBuWCQWrMx05hVnQLpDcmzWC+nH89OIZEwsAvt6tztHyWsITpTFpNx5XwT9dyr8GmnK3TLMArKCGVIf+4YzDa0oAhA0dx1s88SZv++YFEBIDjSFae78t9RC1oIRO2MlLBOJeO/X5ZyAgh6Km1QrUt/Ut6tHew106FkQ66VwKrAxUZcIBFX19BsrHz9AE3i9Ozi8IRpWMi7SyfS3tJiCQy5S+DJyrS7QYgAk4vlViOtGhdQnl9RID3DOobtWSSVILABXIi1i6mgh3kwBSEqUkWEn/MuMlkbSOqlyxIjzDdjVvPmIWqf1Z+p7Y0RgyM8wMhmSPcEv2kmdfw6/2L7LVJeYAzsz3QUi5XoNZXH1LgNT+MsDIC6aiT51APRRfqLbhCy1Qu63HxgUhWcnxDRHs1kjs57sDWOVdkOct0j+5gpw7VB/21psruM7Ag+1zKZ7MUeIUA1t99xHxwaRq6N9EPA9lzBohLClqqja4Au/BjKJ/QqcxMPk3O+aGPRkzgH2/kzWR/muH9fIGf7wrXelpTgs0jbGhMIuCYqJiaIzZhV5qf2GsISWVXHZn8XcFNmYihRhCm8+PN/OTsa1FHno3wPLz5aNNfi5c5asciO+jJRb7oYg+My4d6LLXTv5OvEb6RZzfwFNa3h0r/2Mi/OBPirctCEyrdBSLONRyzPUPxdRzqGzsffQXrEwj25pIiGLClFkQK61HQcH9NtYFnphqjCgQIU5HetuIj4wB77XWiFkQk74wu2AFDsa1DQL9qAVb3u3L/ZYCo/kZuP1Yj7O6GhdjMPsIXWtt
 gB6ghyXL
 8SrHKPaBFdfj9a3oPCRqj8NuppxCUxm2yFOUUs6sOTHDHIL5NpLsqsFI+/1sBgaf2lD3AztV4I4LpJW5FLKphjuTgA8C6Cdq01j+d++XKmthWqXBYsPW4bPE8ajI8mihMQbhePD4zrvkJMVUe9AqpDso1e3RWOjARLouQgWm1ySzXqVEIXWj5nfE+ex+HiVWyvk5fa8FxI/QDl6McPpWp2oDqZt5sJ5+V+AfzjyTZz+7SJ0DQF+zA0mGqkW31C+5D+8ID0ly485/nSurzNf5UHnOoD1GhiIN41y9NS+5xgBhIqgevva3UAvM8D+A2CiOjD3rofsL5Ufumjt0dt6ZQTpfV1rKMcTpKdNjgL5Ub3sQsm1rx8N+A3GqpGa8Wj/vJc7p4k0HTPnqe4SzNwuDwahlTRo6cYU1UdL9CGrVDvcDiO71ENIrRLNS7aWtkmw4xSTju64cwEYDUldemp1IV+RwdSM88ekhiWigkRrTJGrQQJSBDoyKYOa6/01o8En8XzoYTsbqhDTP8AMRMvgvkoWPqKS6kliWj0tk5Q5gTWaJOkksfFwewWrqtuPp1TO9IIuPbRszZB4aGCeAzFhV7f57Ya+/naFpc6tkFgLZBqH5qFh0QRjCRVkr5lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,


On Wed, Oct 7, 2026 at 11:05=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> >
> On Wed, Oct 7, 2026 at 11:39=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
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
>
> Hi Alexandre,
>
> I assume your configuration is as below?
>
> / # cat /proc/sys/vm/page-cluster
> 3
> / # cat /sys/kernel/mm/swap/vma_ra_enabled
> true

Yes

>
> I am curious whether setting `/proc/sys/vm/page-cluster` to either 0
> or 1 would result in the same performance gain on a zswap-enabled
> system?

I'll test and report back here.

>
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
> >
>
> The change makes sense to me. I am just curious whether setting those
> configurations would result in the same performance gain.
>
> Maybe you can mention the `page-cluster` configuration in the changelog
> as well.

Sure, I'll do that.

>
> > Suggested-by: Usama Arif <usama.arif@linux.dev>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
>
> Reviewed-by: Barry Song <baohua@kernel.org>
>
> This is RC6 now. You probably need to respin it after the new RC1.
>

Thanks Barry!

Alex

