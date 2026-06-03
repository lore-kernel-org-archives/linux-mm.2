Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0DD2CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31606B0088; Wed,  3 Jun 2026 07:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C092A6B008A; Wed,  3 Jun 2026 07:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF78A6B008C; Wed,  3 Jun 2026 07:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A08646B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:14:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D264161B40
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:14:06 +0000 (UTC)
X-FDA: 84838342092.15.AE8EBEC
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9C1B040003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:14:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="Sy FYwlG";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=jvTthBBx;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf04.hostedemail.com: domain of robin.clark@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=robin.clark@oss.qualcomm.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780485243;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19tJFy9lIf9VnTinb1+YfhqFSRdeYqD56zDrzVGVBoM=;
	b=54VEZMY6SkYS7IiwuNHzS/aaQa1b9ujZgltpn4OdKIrM94tZLdKGQ3o/JZ0syPExyakl0u
	boG8o+TUgT5Pd9sSHGqy90ikJuq6J1aSy+3hbNchckNw4m3B0P+kRpB8lF+dY+L6FA249N
	A4AtONUu2TmqvUxFdRam92fYyxtsBvk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="Sy FYwlG";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=jvTthBBx;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf04.hostedemail.com: domain of robin.clark@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=robin.clark@oss.qualcomm.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780485243;
	b=FgrknpVVoi9sJbLS6IOz/D7CbDXKUYV1g8QTaoaFWmPtL56JLgx3BvWtol0BKLanMQTalO
	7JoFt9PGZ6u3p/PU0YfzFL8gJzHkSghWhVM1YXyzAZLC0fhtGsVn0vCP0R7uGAZ8AK52P2
	ND3SJeMzmv2QVk0oS7EhRuhTJGYtXwE=
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6536Rhif1947093
	for <linux-mm@kvack.org>; Wed, 3 Jun 2026 11:14:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=19tJFy9lIf9VnTinb1+YfhqFSRdeYqD56zDrzVGVBoM=; b=Sy
	FYwlGagsxvh7ElOxJmaihXiqez53lfLpIWWl8M297FhjleULl5awjFAoM5CCEWiB
	JvXI+mZLsZQPYSnPNcg2ugnoQ/gJEUl8hFeBJujbGpipnoB6KK60ku7kENQ97OWA
	5Y/dnbMSMl+swmylyF04SqbWrrIOMrvp+538/VQuHGmfDt4QM8n6aJnQps0CPeQQ
	Zw5xpD95r/bTbUfArT1S42IVDtiPxePAIKB86A54NhuZ4lBvfoIlKToh7F1xnAco
	R3BVyIm8rwKaAb/B6rU2fDdMyufOt99LQP2nwge0bnpH662XZoHu41TfCP8gn3UN
	eZaHisN6F0jKdQZxaU/A==
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ejabgj68w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 03 Jun 2026 11:14:02 +0000 (GMT)
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-43d1e4bca47so2896633fac.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 04:14:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780485241; cv=none;
        d=google.com; s=arc-20240605;
        b=hyERaVtok+rhMckRcMcP8RCst1toXHziDtUDjAFXiITsO5uZp33DLWvBPO2QgJ5Bcd
         ZNeksOmOCzIfWXWPECC8tvOBgliI0cSmhoR4WMdkrHmDquYTVJK6+0mGQxn+rlzXKBZF
         f+reAGH+t3c2O/7o1xSqpKKcG9/YucjmGpa2z8D7brnaEfvMyjTiQaagidf0JY9iAU8p
         5NlEiuE4tXhDeeknAwoGEfmzptk1x1FFAVTdMEOveTjSzFbFlON7FbuJP3HQP1KXQKDd
         E8lt+igYIXwz1r5OY1qpcQ9Lsb9Q3Yj2pw6XIHwcJp7vwarJ2UXsHik8uhQsx6lXEmTP
         X9SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=19tJFy9lIf9VnTinb1+YfhqFSRdeYqD56zDrzVGVBoM=;
        fh=Abx4H+3LFK1lFyGS+cfGMgVXUEuakYhT/bcZ6FublKs=;
        b=KOIG9XNaiEi3Wc8qy1ApV4r34xGPHe9Y+5yqTnrIgLQYqqGayi4P8Zjy0FEVcjChwi
         270sUhgUQkAeAkDjytv9ztKXOFadyLIPpLKwPHe+Fc86JMuLfR9n2D3FhRVg0IgBhgUJ
         v9UfwFqlp15J4odeQkmVbzzdABiMt29igMAh3Zy6uB8AIkl+YtrhuH60rdTAcduP2lAv
         OcY1c6xiQFJHJM6vP9dPn0L3MvM2C+WDZLdZ0vx2Qo6SFI/KD9Qpi8JRQlzzkHrRXMVD
         QFoF+dzPIDPkes62s6ESVseQlitnBxF1v5a7wIe/JH7mnaYZ2irUEpPUpg2r7PnBZ1Md
         Iqlw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780485241; x=1781090041; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=19tJFy9lIf9VnTinb1+YfhqFSRdeYqD56zDrzVGVBoM=;
        b=jvTthBBxb4+/6dSUlg7pIm/pH9KMyk2EqvKtnIJAq6jNMvGfue7T9IHMOjFvSRRCfk
         IC5M89SFjPx5Vorrqmnva0DOhBB8Km2XsWJ4FW9zj74opLe3QmE50wkXSs44q3UHI9kc
         FoWOqgJlxoaNC3z9UwwHKfD3OtdXCNvGWwyImPImJom7QUCgIZOc8jwcoGYW8l/n/rxB
         vkufWZ8PECnHjkRddrWoiHUqciIJXJUxSVU4CrS277sKYvaH/sgfuxKk5Qr3SC3dzvE2
         mjpl6Vb9KxnZpik9j76BMFUuFBM/xkTSw4olrUcIz5czXvRQt4Mbi0842UoI/66lPdnf
         i7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780485241; x=1781090041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=19tJFy9lIf9VnTinb1+YfhqFSRdeYqD56zDrzVGVBoM=;
        b=doM79MiGo4NWOqXlLlqvojHfb5mJFNddqidT3E2HBMhg7pRQV942l6AFtf09uW7gN2
         W8+4EvXgaGn6tPoMJuroacURo835dXvjbv4jyUjLaY+V/CNlLp2ySq+9ZspUBFg9HbHN
         0nhMBCNcTvBJN0PCt6bUntIv5UbDjS+r/O0uxSg+sS44xHkSsh+EySIU9wh2NZDOgFQj
         OonEKd9RFw0WZKfLdF1oO1ZgBOS87YIXavv1qKSiwIS2YD072WBbU+98cPF6435OZyYj
         SmdlyLEovN3tlTlVAkQQnA2Q3DVZt/Bc6v0uJpcwpThxfkNQS9v3KoNRuss2wvGUvyTT
         aj2A==
X-Forwarded-Encrypted: i=1; AFNElJ9TouD3DkJnFi1HZcfD8oX3YpTG7viOhobGaAXmAbfhkHYogQhomTRjaL2VCvl8vur+PHRImko7yg==@kvack.org
X-Gm-Message-State: AOJu0YyqhBwMGOdz4NIEWdDPDPmBpQT44jHjuRwIDZ4x3B9VsWGwNB7R
	Jdc4A0JPK73n/A6i1t/TB3Xz/qUPnTou3VkzaEtKRx2gTm+ieIpmbsDcCiCLcmtx2TROrD/pNey
	2XMP0PEkU9UgINat3GMtdQoHRjkHsa1JG74QdyImy/97zVNPMUzb8qdWLBFqPBcVBTzVPE58n9P
	Mc+QXT+lLQmUVd12hkAYi7ieMTZ69s
X-Gm-Gg: Acq92OHBT+cbrRKM/0dY8gqfrZmvpqY2LKaQ1vqlScuJHJyJ1lONabLrgU4WGE9fNe1
	ob57CEunodSbS40U4iCdAPc02K1g7g1UCTaElaW5VSqwaGt+YlxxHdKBZQphTiDFIST8EQvdoE8
	w7TDaM1z6A+QbyMDGx3VdEuxCpxG3zXHtqWOYKw/strTKSl4TCIUGTOdSwTI+h1Be+D4BW1n8N6
	WhSWGEGkWZgYILK1A==
X-Received: by 2002:a05:6870:171b:b0:439:d504:1465 with SMTP id 586e51a60fabf-440db44d16dmr1912784fac.5.1780485241395;
        Wed, 03 Jun 2026 04:14:01 -0700 (PDT)
X-Received: by 2002:a05:6870:171b:b0:439:d504:1465 with SMTP id
 586e51a60fabf-440db44d16dmr1912767fac.5.1780485240990; Wed, 03 Jun 2026
 04:14:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260528093437.2519248-1-hch@lst.de> <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org> <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org> <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
 <20260601113831.GA25535@lst.de> <d7b08296-7f6e-4d89-ab3b-04e43d04929e@kernel.org>
 <CACSVV00k-fxW6+waHNqvmYcnVNDkRexoWWprFzfayZfqdyMuuA@mail.gmail.com>
 <CACSVV00dNWgpNVU5rB=Hmg+3oWF18yTyfKNr_tWesjoP1jMxwg@mail.gmail.com> <5e6948b3-d235-4b61-aed7-e8b4d0f5b452@kernel.org>
In-Reply-To: <5e6948b3-d235-4b61-aed7-e8b4d0f5b452@kernel.org>
Reply-To: rob.clark@oss.qualcomm.com
From: Rob Clark <rob.clark@oss.qualcomm.com>
Date: Wed, 3 Jun 2026 04:13:49 -0700
X-Gm-Features: AVHnY4L4Mu1tTTnLDgXjw8iz5Wj3eHB3OSZ6g8qAAhd22vyCAP_N07hQtlCZoOc
Message-ID: <CACSVV02v0Fuc6=Rqyd89D-_tcSjEXuQmxz0+2-4aoRAEwJE4zg@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Harry Yoo <harry@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>, Hao Li <hao.li@linux.dev>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, io-uring@vger.kernel.org,
        kasan-dev@googlegroups.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Boris Brezillon <boris.brezillon@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=R6sz39RX c=1 sm=1 tr=0 ts=6a200c7a cx=c_pps
 a=zPxD6eHSjdtQ/OcAcrOFGw==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=DJpcGTmdVt4CTyJn9g5Z:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=8jdotb935GZv83SU0eMA:9 a=QEXdDO2ut3YA:10 a=y8BKWJGFn5sdPF1Y92-H:22
X-Proofpoint-GUID: 3u7QpKJ9aBEykzWN8Qwr3udQzmR4sB0E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDEwNiBTYWx0ZWRfX36JReL99jycT
 mIxbg2hMbyx9O0MtpsRrBslva/p/DYrBtRgzTySkC9r4AUwokN4VxJOFo43edc143EjcY88khbp
 HeI806AVb0eAUYp7iipxLt7FqUookB5QYeCmqaeCg5fj8CFAlRZtFbdGeV2CdJ2uBwjhuGc9Cyh
 mWYsNZC+iqS2ke+HdAOlacd8vPlzsB9yVJeUQ80ngBdZqwkQ0Hz/ZOadPTgMLWStFg+Z4794SUz
 zvsUvNPye8Aa2Mq+8p9LcLVv29zE4/59QGDiIvQE2ECKbEPCjj8cYBBUnHqPlqxGtz+MBi7faui
 UHUcQoC3yqSVmswu8B5BL6dH/g2LF8ohSU5gjoO4FPd8Vye/QdjdvotztJAyZFpiL69Vt7DqWWv
 DxcCgs9T3kPetQsF0kMVO8RRTkw0oURtlXe/9B6f2R0K/UrtholAwbMNapXWYbxzyH+tNQbmkoe
 uxonFv/fdqBc9Mb/mDQ==
X-Proofpoint-ORIG-GUID: 3u7QpKJ9aBEykzWN8Qwr3udQzmR4sB0E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-03_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606030106
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gtpq8u3zeec9imypk55aao6qr5dmopcm
X-Rspamd-Queue-Id: 9C1B040003
X-HE-Tag: 1780485243-443391
X-HE-Meta: U2FsdGVkX18Z8r7i/lj1YVw9yj9hBEJljhJblPAGvgcAQnZbtyz8bqKRHq6i/EtB4GPkmKEd7dubKGF9yFAy5rsS99Wxa4/oYLniah8CiC1abrwbe5xJ1H72V560O+ZeJSvXCeRLw365ejEsSvy3Mw7A6g8RGeiMqt6K44/tc2QZtaYep/LTq5W7jzjc6YQN4OFqyccTbsiOwMO6K0DbACCpD1nt7xv25G88/4BsB4JtzVKExIzShtL6H4IJJryLrV3YFvcrTQhrkNZTh4+JcRsB7pQgYaZbgGioZCayDZp3NNnJa3OIEW6mew6vvpyFyOwUBnKqkHQVxNoMuxSlLi3koNcm60nkmm55DrnLsvoOyspFxi+S2BxvIMoF8+W26M5zmJ7lKbeyqSfx+032zaldqM29PYj2sVLx4FPelvimx2LOy1e6/SlI/eLIbc1uSecX9I9j0Scx8n7oA0Wt0Nj+voeE19C56DcjOv56NJvp/ymb2AqIQlXtJHjbRIDEKEr4IrXwTJ7wV8cX+npQ/YeivtEd8cX6wBsVUa+frjYuRvqr3Iinnu+WeOfSqBDeRPNL/Lpsc/djh8DTQfTcaF1h2Z1aMlIMuY7wqbprOsjAOOpj8O9VolwXfMtwOUHwH1Uf9qk0RyEPlkre4laKCk32SEuWl8NFLGnFMM76ifGCQPBftLMR6uUWHV/YAQHbnG8ddbVbjnCsSQzp6IzMt3wcKqt+kml8awVkmLSUlalCP/l7H0kugXu0P+lnW8JJ2FfOe7hyQHSF9+t5bTkJjbdLbzGoLwIy0Rd4yO9n6XxHE5w/vm+aVW7FJw2xwIjvYYiJH/suevoSCtEk/ZsRp84NzsbLYpuAiKzJWp5ma5gT7vtzdb7fecQfv8dkfGhuvO7Ty3+zFcdQdAah0tMYnSoxUt5TVuw7rFWb8DBXFKWWxdkzaGesBshboUbnFizT+Ws00aOWg6JT2FIFFz9
 76AQFF7l
 eHJqqb3ZAueYmB4ltfghXooVhiPAqqggtyc0iPe7QdqyCwVVE7ybdYslG1tHibuS8NvAXn0XborpLgDAtnMeTicBYstLFT5y56w/r3DqszqMCCnZcusN6FzE9GSLai0X3kRHezPvB1LtbaBQZmSsgsl1MhTOcrVqW+Tku9LByqumJ9IHYbaGibT3EJsC6Gt4UP/o7A8WaRxR9aqR+wR0c1osfOnuJYXT3w+/cPv0krV0oeva1oU5PfS9h6hT5HTi/TUQdPdz+6sGyd7uKwTaTvTJZLqdkLv8TQzDivUEUw5wJKP5PJLLthkgUGzw5XWmhSWlxqZd61sZ5P+/2AlHsKbFYpMjvrqLNdZt5qsKItehkVjzMMDAVdyKRmuGDZvlJbYPtv3dv9d8zR3J9UXHM0osweK7KursDm/pTl88jMbEhwqtSETQm+uDprAS8UAw2F82Ogukrj3i5OTOeTnZRGu/nscyB7InkNR+aBk9AyJV2eIO2i9m1y9Ir5qZs2WKSxC7KcYgn0ZG6vX+mHvS9QHbYC1HxZE0r+9OzIVMDBHC/DkRbJ1RBSsz5u8Jfn13ccuNcjsXNiqPD0oRFC3GVPWu4HXwufzBjRNqWK2n49a+yPIgp7jtldUpmKf3wnxocX0nqA4qNZalh01fmNQviiDEpH6bJJ/nYrHwc8aqirMFgvAZotnWNstMPWhkxSAM0APV7p6jH4Zkspj9+9tg5muL0lMAyFEkRrrBRy5iPavHw/Nhgsl3TodqXsTx+pohapVZqqkqNa+m26KiAY/MS9g4opzjNQPXT6Y81mod3waICHGfUbz8TcdiFGiG7y2/Jn7ayVEieO4VIj469SKFP4TiZqpwV6MlYpRqGa43qRv6QYIw6O+H77STeHUlakrsTW+g/URnSL7Viebnpr3ZsFmEGsXNqPZX5Jiz5AvRQrbie7XA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 2:17=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka@kerne=
l.org> wrote:
>
> On 6/1/26 16:39, Rob Clark wrote:
> > On Mon, Jun 1, 2026 at 6:32=E2=80=AFAM Rob Clark <rob.clark@oss.qualcom=
m.com> wrote:
> >>
> >> On Mon, Jun 1, 2026 at 5:50=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka@=
kernel.org> wrote:
> >> >
> >> > On 6/1/26 13:38, Christoph Hellwig wrote:
> >> > > On Mon, Jun 01, 2026 at 10:16:30AM +0200, Vlastimil Babka (SUSE) w=
rote:
> >> > >> > kmem_cache_alloc_bulk() returning 0 was considered a success in=
 that case.
> >> > >> >
> >> > >> > Either fixing kmem_cache_alloc_bulk() (and the comment) or fixi=
ng the
> >> > >> > user sounds fine to me.
> >> > >>
> >> > >> Would it be wrong if we just returned true for size of 0? Would s=
omething
> >> > >> else break?
> >> > >
> >> > > I don't think it is wrong per se, but it feels like the wrong kind=
 of
> >> > > API.  I.e. I don't think the MSM caller actually wants this, as th=
ey'd
> >> > > also do a zero-sized kvmalloc.
> >> >
> >> > If p->count is 0 then indeed there's a zero-sized kvmalloc so p->pag=
es =3D=3D
> >> > ZERO_SIZE_PTR but then nothing breaks because nothing tries to deref=
erence it?
> >> >
> >> > msm_iommu_pagetable_prealloc_cleanup() has a "if (p->count > 0)" bra=
nch so
> >> > it seems it's considered possible. But then the rest of the function=
s also
> >> > seems working fine, i.e. kmem_cache_free_bulk() of zero size does no=
thing,
> >> > kvfree() of ZERO_SIZE_PTR does nothing.
> >> >
> >> > It seems to me kmem_cache_alloc_bulk() returning true for size =3D=
=3D 0 fits
> >> > naturally in this world and is less likely to result in a gotcha?
> >>
> >> I think I was probably expecting kvmalloc(0) =3D> NULL ... but it
> >> happened to work out before
> >>
> >> Adding an "if (!p->count) return 0;" at the top of
> >> msm_iommu_pagetable_prealloc_allocate() seems like the thing to do..
> >> if you want, I can send that patch (but traveling this week... so
> >> let's see what I can do)
> >
> > Aaaaaand.. sending patch from hotel wifi doesn't seem to be a thing
> > that works.. but I've tested the following w/ deqp-vk cts, and works
> > as expected
>
> Thanks, I will amend the commit in slab tree with this as the easiest way=
 to
> go foward.

Thanks

> Just a quick question though:
>
> > ----------------
> >
> > diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_=
iommu.c
> > index 7d449e5202c5..ef744d154bbe 100644
> > --- a/drivers/gpu/drm/msm/msm_iommu.c
> > +++ b/drivers/gpu/drm/msm/msm_iommu.c
> > @@ -332,13 +332,16 @@ msm_iommu_pagetable_prealloc_allocate(struct
> > msm_mmu *mmu, struct msm_mmu_preall
> >         struct kmem_cache *pt_cache =3D get_pt_cache(mmu);
> >         int ret;
> >
> > +       if (!p->count)
> > +               return 0;
>
> We know p->pages is NULL in this case, right? Because it was allocated by
> vm_bind_job_create() using kzalloc().
> And the job can't be reused with a leftover value?
> (msm_iommu_pagetable_prealloc_cleanup doesn't set p->pages to zero).
> Or should we set p->pages to NULL here.

Correct, the job is not reused.  But I suppose setting p->pages to
NULL would make things more obvious, so no objection to that.

BR,
-R

> > +
> >         p->pages =3D kvmalloc_objs(*p->pages, p->count);
> >         if (!p->pages)
> >                 return -ENOMEM;
> >
> >         ret =3D kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->count, p=
->pages);
> >         if (ret !=3D p->count) {
> > -               kfree(p->pages);
> > +               kvfree(p->pages);
> >                 p->pages =3D NULL;
> >                 p->count =3D ret;
> >                 return -ENOMEM;
>

