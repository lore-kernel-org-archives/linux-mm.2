Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BEB5606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Y6Vrek0Y
Received: by kanga.kvack.org (Postfix)
	id 42E1F6B00EF; Mon,  2 Nov 2026 02:42:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405526B05B1; Mon,  2 Nov 2026 02:42:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31AC56B05B2; Mon,  2 Nov 2026 02:42:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 061A06B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:42:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E2DC40C88
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:42:13 +0000 (UTC)
X-FDA: 85389385746.06.6EC9131
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3B663100009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:42:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=Y6Vrek0Y;
	spf=pass (imf05.hostedemail.com: domain of "prvs=97666edd39=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=97666edd39=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793605331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mFBSTRr0j5MiHbKH9taC4fPcpaGn0/BbSg2iUW7YhM=;
	b=xX2cPv1MQGSLhM3rTqd2xCN9a+e9JWHnha1xmm6RZWueXJU8grpxi/nLb1tGE2eME7ByFa
	7AKrEk3Og+WCJQlli+i5oW2/FiNXMY490OFA4ZKkG8ORP/nLWqKwh/oJuXq0oNvES8qMJQ
	g4E56GX4h1G4i1PNbRcvQd1ZqU+w2UI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1793605331;
	b=vqDIVvpgNlmCKN17cWwV7CuT11g3IIVvyoZOAvrEu2bkr8y1Co09JoZ3UJGx12TvsYFTmX
	r5ZDGZUQaiSXQe83zO2KcNnql8J897N9IPc/aMBasDEwKro72yGZMEBMC+5U8B7qllyNHV
	WlVRxZvB3XcPL61HwtJh7lHR/uVkKng=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=Y6Vrek0Y;
	spf=pass (imf05.hostedemail.com: domain of "prvs=97666edd39=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=97666edd39=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A248Sq7121247
	for <linux-mm@kvack.org>; Sun, 1 Nov 2026 23:42:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=5mFBSTRr0j5MiHbKH9taC4fPcpaGn0/BbSg2i
	UW7YhM=; b=Y6Vrek0Yn8jcVvuIJhYfiBagoJU+Keb+3UHoIkoh7evxP3APa+2/O
	YCJWv9Z9AJNZZ+HRspxLIVpjpc6hwAjZOc/PuaqFkQjdUFwoOd2f89WJsGfPndaA
	pf4fJi7PUKY+Y20Pc2ZrwP1UrY1tMEbI1QGn2a+4UW5WZj9Pt3P3mhCkMyublN+I
	I4F2hTZTgksKUXtxVaC+699KEdxa6VX7lXu+zc/2AzzriG5dBMlkJYdBDawbmUYd
	SD2un/gGNphjKTiCF88XEDsQXgNQEu3Ca/fnQ9nYHJ6/vF5u7FAFq4hu5Jjv6Qml
	rFu0qyWSCHTPt7lz6l/2+azJz96bLa4+Q==
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by m0001303.ppops.net (PPS) with ESMTPS id 4hnc09fxmv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 01 Nov 2026 23:42:10 -0800 (PST)
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6aff6a8ee69so3046561a12.1
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 23:42:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793605329; cv=none;
        d=google.com; s=arc-20260327;
        b=WmXh1nbaHkBs2ccHNca2hN+4oZY9PoTVqYpE2fz1yp5TyOC1AqpwYQfuXUCQnqckPR
         Jznwap5mtgfZtLgKej5ADrXtnLcWFYkU0G8OWiHkTJ4+goaOsDtYPSo70V9fgVkj/lfK
         xyZEYJzz47514EQOaAYF8g/vFpSmEsFx3X3PYZitZ/tNoE4iHPn8KAdwRV3J3xwPwgWA
         RBJk2FRGeLFhITHvmvCJhA+DCTqk4TV8FNM033PgQngad/4kA8gmKyIi183CkREBvpgI
         LykMQRuJpARpHlyCxEn6umxCUrnswF0jNBnEaU2eFPizv/HCldjGIcP9vy45Bs275ygs
         YpRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=/tISQoeOPy1BAFDyFldAVc3RuvTUszXOOf5Ksc60ZGs=;
        fh=qBjWG4IYdpx2vpqKnWP5A/IFoM6r9lHwcVt+5hDPXBU=;
        b=XooMLSsljSvfYshqJBOR2Rvy198d1t7oRJghws7PP2kCsHL/hwJmKbUIkFe8gvAOug
         9FfNrhRE+NPRdQDLBBJM95SHfBdRcOkiXyAWuTJYR9lY4bt51q9uwpOFPxkyGHiQFNO6
         hF1hRta+WuFhV2bYjHx8wkPE65UPmzR3TEBVJYzWCP3f3Ksyplsmkl8FTKyE+VXrrgZ6
         EGmbmOCi7aWu6UYE9KHj3vpFXgIlq3zmZ2AoQQMPhzHd6KaT/YAyfg2Z2wiNwvuSw1nr
         iTnntms3KjTw0O+szHWnQexbubXBYn/aS7Z8LcrGfmGRvBhxdkk6kQEKy7bnCDzf26sH
         X0Iw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793605329; x=1794210129;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/tISQoeOPy1BAFDyFldAVc3RuvTUszXOOf5Ksc60ZGs=;
        b=HzarGRYBropuBxhSC1XRhm5SufSr5xN4yaCw2g72HMW443WhGLyXXN7bBPwl/gy9e/
         X+BddM27p6ynk4b+cwNBMA5kwJnPjRq2DGX958w95v0xLAMU+mG1foHESaGCi+7F/edR
         qY/NZYwEfRP1LfOI/QOOdiyiDUVOVZ3CTQuKdCcvLqbtwNmDrwglaABXv/Paj12P6aJD
         gHBfzcAthh364d+RpVWph4/JcnApZwlxGzViHYZ2lLCKsokRqDpKtXwmU752ot4Hiy95
         dpSfyx5yGkX/8BUSMQQitQE2hEuyGJAlcX9QbZ/LIlhdC7/uXDLlVgVJ75+egEnGeGRm
         X9pA==
X-Forwarded-Encrypted: i=1; AKwUvBw9piiG50lRQ5+UfJr+uUMgqpz9tsetnKTKxVyaw6vKYT/rwc6lponoEKk5NWtswgMlmL5IfvgHnw==@kvack.org
X-Gm-Message-State: APuU4Z/z2v0FVy7AZWVkUHgf/NTBlUPxbJmIdjppAsw0MQc6mRBk1bKD
	WIxKEbdwb+0zGk1wg1Zt/6+iZJ1PS991tjyyX1pxYcidSBx55QNs6wxMki8O5ft+H2DZ5DYxb/V
	vJTCi56Y7HuopMyAAZCnDXykLslzLUu2g5v1gK/I4M6Z+VAKOMdfXRIe0RRg9afLfQX93i/aDMT
	G2O6LmKpeXwKBVaexeuvIKRMq6LA==
X-Gm-Gg: AYBFou2AC58OIlLk0kR4TH3x1/BbG9fpKPVMP1Xn53XYADFMnpiHDC80tKIAhKGHuuh
	Z1sY+ZXk9ZVbKRkt7qdLgcHSbiQweYIwSJAoePwivA8lu3uSgpplTg2FBEj2/HlFvE6yr4wRx0z
	4YuiQ4XLJzeiosAGjnezUewnpnfmxr74KQS8KbMNE/fS+yuk/3hEDlat9dMqeQxODsy4ZGWVbFs
	uMMeTyC+Cz78h3i+A==
X-Received: by 2002:a05:6402:c9:b0:6b4:12df:8243 with SMTP id 4fb4d7f45d1cf-6b4d468ad29mr4577805a12.20.1793605328779;
        Sun, 01 Nov 2026 23:42:08 -0800 (PST)
X-Received: by 2002:a05:6402:c9:b0:6b4:12df:8243 with SMTP id
 4fb4d7f45d1cf-6b4d468ad29mr4577778a12.20.1793605328346; Sun, 01 Nov 2026
 23:42:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr> <CAKEwX=M6G3NPOrGJg7Sz68BDSjzrF4R-tTjcX07L9oZ0GK4Upw@mail.gmail.com>
In-Reply-To: <CAKEwX=M6G3NPOrGJg7Sz68BDSjzrF4R-tTjcX07L9oZ0GK4Upw@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Mon, 2 Nov 2026 08:41:57 +0100
X-Gm-Features: AclHuK_ZBjm071ukvNbDmfZJEnuL9tpwTpRPlzedYNA1H7fjxQBxYf7Dj8f29uQ
Message-ID: <CAEmasaV0jxQVTGRi6vfwuZbm6kcnxJcn7xJmT7aHHKf+Ad3bPQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org,
        hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com,
        baoquan.he@linux.dev, youngjun.park@lge.com, chengming.zhou@linux.dev,
        david@kernel.org, ljs@kernel.org, liam@infradead.org,
        vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        kasong@tencent.com, ryncsn@gmail.com, chrisl@kernel.org,
        baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: EbA4m-p7FEjuWc8I8hVBWdtiBJ2SEouw
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDAzMCBTYWx0ZWRfX+nYQMRGg/+XD
 M4tI2H2WL7GTaWHQr2QqfGQHEy6LeIuAueFhMOVZthgGxcpOWBhGw2sjkEH6tcy2n7U87mG0r4N
 JPWOi/4Kd3vQHDFWL0l/BQ5NfLjxjWg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDAzMCBTYWx0ZWRfXzFJzcMU+DJ+D
 n4DoKexqbZBopy/otpLJvnSO5e8fHTweLgk+JbFM6+WeXFI+qM6pOo5SqcRFEXe3M1YJDOpzZPO
 V8m5DjqLjoatLjnnvJ77SO4tjfMQ2yMWImlZJIGOMre/GHv87UugheNOxJhRBFe62t4IyrCnanY
 kqWmrN/UG1GR2u97HIZkXT+PacUpFesh6l/RmLK/lFd1M9MUdZsYNPWlcPjDYFi4zE/vu3gha8Z
 K2z/+Lrhv/9lcFBlh+RmTnHyeOSfpGyIsvzmPuHtfoqgfvZbZBirQ9BJLGBEi9giqsvbzmd9FAE
 Uz6580R3F3z4VeHF7GMdLMLmD61leP2CzffDzX2g0+mdANLvT8Kd/+yyyJISMi1HHifgDNW9K8N
 9/9+vMU+vFTafD9mwM7/uyEE9aAwZ0S1j/SJRsaGYMgOLcmoDrg06Lw0qco0Q913/TLkE52EKRO
 WVC+mZrE1WCYzftahAA==
X-Proofpoint-GUID: EbA4m-p7FEjuWc8I8hVBWdtiBJ2SEouw
X-Authority-Analysis: v=2.4 cv=OYcNnRTY c=1 sm=1 tr=0 ts=6ae83ed2 cx=c_pps
 a=CYpx6mtW7qE8U/l5VCnCPQ==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_78whYxrdx1mplLwxq1U:22
 a=pGLkceISAAAA:8 a=h8lhBcyy4TMpjp85FJYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-02_02,2026-10-21_02,2025-10-01_01
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B663100009
X-Stat-Signature: pt1ak4x9nr41xaamdr1136wyri8f7poe
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793605331-623483
X-HE-Meta: U2FsdGVkX1+o/+IoHgbw9C904nEcEskL6URokUknuRpXTK6Ro29m3+bjyzVrTvVWpoTxfYRpwUvF5hoornXNhQ1cCsSRLpHUHwG8AzQXOOjC6B4jzIAcajRruqymcA5kUSmUUjsUSoCpKwL3OHfHVd+f0LNki2m22/2Qb2SV1Sg57lRb8lLq4NpE9LoGXsxQnS1ZLBuLOZIB/nAOslcBgHbJ064HweV7+RuP2gEFSiUSRHjTK6ZH17u9SitDgit4cOh5mYU/KOcwZsn4GnjujjGEgIvKeXt/Dv1sPSxoXe5mam5jg/d9iSJ0Y8kSf8RQa9szDlHs4b8bAjJTLLYNaJbjefkPSe6/vB8nYeSLD8hAZW7rRU4FtNE4784TzbmLnp1JKIanpiGN/4UVy6E79B+2PB1fG7QrlG7TtpXH2O8Jj8Esyjyjg5BvVaySmHsgcPmta8P+/pb9WZjWllm7ShYI2tB5eWN09VmvAwIFkrdy8rO1qLRXw5/XpXNjoZqWRMR9Ad9C5OF2K3lYQ966xSVG5mWzE9Qo1A+Vxg0V9qKzp0gWUQ/CmuAZBNoXlNeBK8i7XeeTnCDoYVSyMyIzV+Vih54KZfXy7GAv5s5nneXFMs13I/0LqC9VI5S5SqG/1CeIO4+FOtCNM2xi11PXnAeYLSArIzCklwmSGrDPgQK0gZV+AHnJ9RYgwbauBN8EDVOWEwWdc5EN4HeEpcOeVC2f3dBeKeBkh8fg9HFv+cyBbmwhBZq9YFupifo0R7Mc48Ndt7arHEWcBOZULbJzsJ1/YRsctJmRmhXBl86qjbSxxwY+P2C9Lwd5BsqdmwY5PeGqleFtuOyNkAa5RQOsyaGcOvDgSZips6jGyxDggHbL5cTKbksIDoK4g0helz0KXzkDQ/f0Seqt+HiegVFOTITZuyDVtVu1n/z8S8P9AsXWcsLAyDDmLGDxCdnIJAIjr65XsIXsGbKjMKrpY8O
 4hOEpFuQ
 AzP14teVazzVE5bRyvdybPDqj96N311L8xdfBoeV6ixIje6hoi5DEczsGnAaZL6F7odjsFKFC1WECDIooqgXZpZ766Xl5rgi9Ww5XifE+vcubJgYDX8CybikrtjnPtPo3XfkgwGhuP9I2Q+ec34fYyrvQQ4SIkapsbfSLTIcWoeNnPBC23/WCsVHnsBmoliQwY9kljwYjGUGA9skhxhox5po+ESWaVaLlAtpdfI6BRMDKakKOkFSTdn5CVqEU4tyS6pw2UWvY0bs1PDr04N91+zY/H9VzTsC7mDGCav2sFJ21eHknxu22Yj9py9SAlkhZ6E+BcMefbq4HSescGuu0JUjk7E4ZsstRjs71383nq1sO3hs/6fKtupYoTrs8+AE5FUOPnKaLeyWQO5kwUC6i0aA1Y9aRkqLEu7YyvzKKoFD+WWdPQM73cijoYYAADKSdUD+bJrmRXr92qjXbAuQHxsTlvNPDcaH4a9Jpiu7N326X2LmpiNm9LlmwX3vBmurlqtIwPoSPM5js3Yc2vBq18JDW73Ezzs4mTLVGlrXGy5VkKhP3Snvn3VLm5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Nhat,

Sorry I missed your answer.

On Fri, Oct 16, 2026 at 6:19=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
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
>
> Would there be regression with shrinker on, when we have mixed zswap
> and disk swap backends?

Readahead won't happen if the faulting entry is in zswap but it keeps
happening when the faulting entry is on disk. But if a zswap fault
does not bring its disk neighbours, we will incur the latency of the
disk read on the first disk neighbour that faults.

It's hard to say if this would regress, it must depend on the
distribution. v2 deals with that so would you like me to resurrect it?
That would be in addition to this patch as I'm about to send to the v4
so it gets merged.


>
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
> >
> > Suggested-by: Usama Arif <usama.arif@linux.dev>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>
> Code looks solid to me otherwise! Nice job.
>

Thanks!

Alex

