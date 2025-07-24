Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97866C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 10:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CAA8E006E; Thu, 24 Jul 2025 06:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC308E0051; Thu, 24 Jul 2025 06:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19CF08E006E; Thu, 24 Jul 2025 06:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00D808E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:57:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8B54B89BC
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:57:51 +0000 (UTC)
X-FDA: 83698857942.24.D990E30
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id E053840005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:57:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=MCM9U+EI;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf17.hostedemail.com: domain of konrad.dybcio@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=konrad.dybcio@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753354669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frgttlq1wUpHfs85c6sOB8oFTBM5O4TFBHJ8W4S/2Zg=;
	b=kAj+4/9KwTaWmUviJiMyFkQuDzam49PnUD8ZwJcJjcGK25Y9TvRemh+6AKmE7tzo3giFf0
	XauuadhN1cXzdBscLFA6Hu8VHNTDTYeUhU45pqOon+odM6Fb27gkyX3oHpQWWQAPj3pFDt
	RnAv3wd6rZODsRj1BmWbWgYWQ0we+yQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753354669; a=rsa-sha256;
	cv=none;
	b=zT5bI6HrLpH8UPDU7twBEDadfCeK55ZMjgl78N8Oto2yp+QPD5UH0bMyS41k6fx3RO2kP4
	L9UQ4QNWt7wGU9dhgo6osgkhuw4jeme1n9Ei6cmvGT9bsgYq6v4A6xQ6fe7jGA3htWi+mM
	ITXQnQT6IWEP976U6w2oyOTlO7hWfVc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=MCM9U+EI;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf17.hostedemail.com: domain of konrad.dybcio@oss.qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=konrad.dybcio@oss.qualcomm.com
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56O9kBwo015267
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:57:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	frgttlq1wUpHfs85c6sOB8oFTBM5O4TFBHJ8W4S/2Zg=; b=MCM9U+EIRXdUhkkj
	RnaQHyphmlwj8ufux4uRqT1CeeRyh4WJeQyMhFCoM7HUZE8B54OyMur9MQ7pLAHK
	q7Q1KVrS7BFGTDMUnHwdUrmlCjNOXtf0Rp/Gdwturu54n0TsR+qJU3AtKnFv2WhV
	Ajeq9g9mm1HxhnKm5PMSdv09h5GF5GTeKQLa+UREcjMI+vHbBSZEp5ZsQOJYdrBc
	29cuk/jHFBZqdsYWQeB8ET0R6F2HpIBhXtEQ0eTVFTrqxXZJKuhGlQ4XUWQjybWw
	SQmEEyV1+dpeOxXC5puV3gSzpq8fRjewj3wouaPKzcYBH4zMbbbQ82M9zd+81FQV
	uLJMxQ==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 483379tk85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:57:47 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6fb030f541bso2733476d6.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:57:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753354666; x=1753959466;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=frgttlq1wUpHfs85c6sOB8oFTBM5O4TFBHJ8W4S/2Zg=;
        b=wzxN0kECvuQk18konKPcNOoYXLE4Maphu4xVa+KWzmKh9jCQ+dGWf6vsnnpx8FhydT
         wQ8C8N0FAX+71D3NNRW7YA7LvM1sGnGU7eDggtFpSqnPOMS5clSd/3hSwpcYVLvnrewV
         LXDQzXLAL2aOhSxD/qFLYwWXSOjTxHGBu4ff0oa1Z8DQN/zVtqIjpagb5XzFivymg2LI
         /IAN8O9gz7WaQ41aptqbey166OsA61mL9JP24bhzTMNcr0jcc4oG+BuJTaXVfFlnubQN
         NBkJ8AA3ITUh1aofiA2kKpn1+rjhaqa04hgrM6UmgwgLof8uH7NqyMMHN/DfGbRja/wO
         ro/A==
X-Forwarded-Encrypted: i=1; AJvYcCWf3Bk5rOAVG1xIVdBIvSTSScci/UVJkDjtLmwf5d2Ty4zZ9Kucnfbx/hvHvEaOl9fDnOgtyYnsHw==@kvack.org
X-Gm-Message-State: AOJu0YxWFpSe3p1thTyJ+4zbMJkb6b0wrb/4GKZwWQ8K8WoF3XL4jT/B
	nQPKTFb+k/rdD/YcTnYqYhcPemOpcGGUD3bI1Wr8tdzTEYBsb6y0jX7Htl7q3/pspFpLYZ6pyAW
	rdCbX20xhGXxaLQb28yBMogCqbNKTYygUqW+UEpHPRVd7/RQ/9ycKVQ==
X-Gm-Gg: ASbGnctiw7xrCUjRDWRJHDVGITINimhZMP3+381PaTJ2RFp/Y6RJ4dD1mhl8topbXPl
	P286TwH54BZ9G3km6JbfKAoBCGafTqMMMTzsIxZB9BFTvvjukCu6F2vQwSz0OpW5QeK3/TGvlo1
	vXXqbzOP36ig4V2CjNsVDgagz37y+fNDi5vHJ6lZbqfaiom11eVsNLD3nCnoC70XocQKvVvCuhD
	QnSdGgWrH1MrG1vRGdozOofnuaC3/iD/N7ZUgIju8tzaf56T0iiqSpNWcOposhPLnpDjlZwgzes
	SMPwHmPIRu8uLeXuY5u2JaXh144o8JtyHNJTSaSWrmqte/qU1KzB2bl+wFqk1g/7CWlGMQPpHyj
	omuzsX6l85jr3RK150A==
X-Received: by 2002:a05:6214:1d2f:b0:702:d3c5:2bf1 with SMTP id 6a1803df08f44-70700537849mr43874706d6.3.1753354666050;
        Thu, 24 Jul 2025 03:57:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOPUGD8doV9+jglxqU2GB0DYEWEF7aTYg/TWGqOaOfQBWULvPms9oF3r1fFWzU0hBkNoKlEg==
X-Received: by 2002:a05:6214:1d2f:b0:702:d3c5:2bf1 with SMTP id 6a1803df08f44-70700537849mr43874396d6.3.1753354665532;
        Thu, 24 Jul 2025 03:57:45 -0700 (PDT)
Received: from [192.168.43.16] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af47cc6e753sm95191866b.50.2025.07.24.03.57.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 03:57:44 -0700 (PDT)
Message-ID: <bbb07270-cf7d-4fc6-9a74-334fcaf00f05@oss.qualcomm.com>
Date: Thu, 24 Jul 2025 12:57:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/15] pinctrl: qcom: use generic pin function helpers
To: Bartosz Golaszewski <brgl@bgdev.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Alexey Klimov <alexey.klimov@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sean Wang <sean.wang@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>,
        Andy Shevchenko <andy@kernel.org>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawnguo@kernel.org>,
        Jacky Bai <ping.bai@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP S32 Linux Team <s32@nxp.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang
 <haojian.zhuang@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-mm@kvack.org,
        imx@lists.linux.dev, linux-omap@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20250724-pinctrl-gpio-pinfuncs-v3-0-af4db9302de4@linaro.org>
 <20250724-pinctrl-gpio-pinfuncs-v3-11-af4db9302de4@linaro.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250724-pinctrl-gpio-pinfuncs-v3-11-af4db9302de4@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 1mQMw_Qd2461H_vMX4HxxzVfg3RLrGTh
X-Authority-Analysis: v=2.4 cv=btxMBFai c=1 sm=1 tr=0 ts=688211ab cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8
 a=jpok1_DMC_Ne8w05vhoA:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDA4MiBTYWx0ZWRfXz7T4OMuA4hXv
 jkFi3osyWtU4k46NSARBgqLguWxb/3SkFjfl38iETPp3+LR1aRs7hzfxakRqOUaA9pXyBtIDcEi
 4R4xWVDV3g8vJQfhUSavWbCQZz2qWQdJd/ACcmjMuuGwyVCw3OrltLzg8VgOhp6dveMKBPgqBJ1
 bGooHz3pSQ9c1C2QtHtUdglIjcdYjg0l5h8JBqbbpmpxE7i4GM6PkCRceRebzMZRpB4IkNdrPsd
 6fJkoYCsd2FxNYwsOTOw/ktkfWsoA+aoNTXRj1VjfIXOuzB9KjsiIyWBXaGv+9lyHcl4EsiDn7z
 reSPo3LNHeLRcMFPkOLsgFLSZAZxOTtRzHgjEBkHVXoBHrlhxivknSawQ6rdDGqRXluG0ydT7rr
 kfE/6u8zTyO0fxhJd9A+en7Ae78Gw5U7qEi4cLJLSMBEjXorFcz6x8Y7cXQ+KBnDffHp03up
X-Proofpoint-ORIG-GUID: 1mQMw_Qd2461H_vMX4HxxzVfg3RLrGTh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_01,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 mlxlogscore=456 impostorscore=0 mlxscore=0 clxscore=1011
 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507240082
X-Stat-Signature: 9znecomxj9rkuuguhsse5dcknoxt8g5y
X-Rspamd-Queue-Id: E053840005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753354668-707836
X-HE-Meta: U2FsdGVkX1/nrUUmg648QVRzFsvsyTsaTK0M+AbSIKC5cPA8w4NR+bTNs9akKnhVVK/DO7lcLYbt9wy0XzFtQIxDpD9nyLKSI1K9DDTMA+A0p23tKhbiv1dM9mugPGA1MYK23yAZWfrlEooCymrbYLQNfPwLsYqLiy8jlajs8wYPuxuYQp9lBo4ZhSWHPTyN87PId/Hkkzf59dBvFFLWrPLiJ+qTXJf/darIxfcKX+5Dgxhf+Vv5dTzvPQeZa1txVjRvrf+PljB+omqN11Skyqj+RmO6QJKJ5sQo3SlZB+KGNBum13/b6J7Mkt2sSWw0unRCeuiG6Ay0oJRL0QXhP13/hsq9QPJu4Raea4wqi/AcAm6F1+o6MOW5wBm9rR6USPINL4GfIFUhYG0qE5nbC5fhX7dYgReFan3AZJfkfIIHU2jwIYlHYc9BjCLxCuIAH0XjLkQMwYlHhvRxJWEwK3TOtrgN0p+B4+x65KsYKoIcXeQ3STquP9JPKl2+bCPvdsjmVDYG0vV5VMgL1TucKk0vgnz3Lrx7RqfZouzX69R10G9mwvrSD0VSSeZgy2MBWw2UazXc/o3zRYk7dbBgyx4lnl95sNwkGT8wTANV/E3F/dVTefl0U3wLx7RbNm0daH7yU5YeopQC9MPaa3CSfqKB1D6gLu/sG1Zh4O32ax+UEZJBh0+6mP9la/Kz3ZWUv4jDjkMxlTQXPfdl2G8Uhb1HBaVdFUtLWrJSXgxKWa22O/w5cM2DlWOYD4cO5fUTvo22VoMgJzN5TaueMmIu/Wt0HZcdtK7H8jddsKrNIdSG/iKL+JuO8JBuXi36AS3ftI4sTTXuoVkUVllDD6EvwDZim2beb9v46pxaLiAt6Sl7O5/ZLnWO/BYYAFLn88ceK7RDAajdCUBK1jZDwz71IIowzniqZRXu5CfXxTqClHL3incW6erQBuZpWM3u3NDwlaZc55/o30P7GCyC47E
 L7uYsSSj
 a88V4wAw3UjxeOk+IO9O5UaoUpuKfmk3GFQqTKc8HFbsF2folgQHP5jD+8su1U1pwuAqSC9KCp2vyw+kLNd3NeS6BUwm7A2t1F+X+RhAbbzA763PVJ5NOKu6Ej6ueOGWJCEU4M6gxVCnmjoJ5erQVTzpNalQs+Trmgmqv9Q4wW/zQ4uXwkHuyQrP+ZvYKJVhdbAGumsq99kRVBASTkZBFyIK+P+cf9ejiGu1RAGBVzpZwxqAWMzxBuvoXcUk1TmgyyCg1qdUdRat33UIAHCeYogiMV8caUQMlLcx+FsBO7UpNss77q6nXQqpC31aGSJSp0djNQvXLCbstC9UGgGBbl8HHi0WlbERCL56e/SSz1aFy/xxLyyGPI11rlRUFvqdbwJCG8VUvDkZCosvC3ja5R8+j7J6dqVcBMkb+ShlkigLU0RfYt/o7brWLEDJAGBnGCO+scZhVgvnO25c3mHGd5l6v0SXLMYgSskT2IF+jU5cPyFKp3g3oZrcdHnFybiR+K8STSLyYNQxMAC6lF+EQ4J+BH+alqGTplWQiSoFv2xeCvBn+LWBsdnyUKfOBdhp5mStkl/DgPHdHLCbXFrvcZNJkCUzwbxy7ZIgfyPjsj+Tsb9B2nvVs+e9BSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/25 11:24 AM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> With the pinmux core no longer duplicating memory used to store the
> struct pinfunction objects in .rodata, we can now use the existing
> infrastructure for storing and looking up pin functions in qualcomm
> drivers. Remove hand-crafted callbacks.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad

