Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC30C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 05:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 400F86B00B7; Wed,  8 Jul 2026 01:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8EC6B00B9; Wed,  8 Jul 2026 01:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C78C6B00BA; Wed,  8 Jul 2026 01:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECFBD6B00B7
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:37:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 685D71206B1
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:37:49 +0000 (UTC)
X-FDA: 84964502658.26.651DC14
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 010644000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 05:37:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=inU1ARyo;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="PMeoc/Ad";
	spf=pass (imf07.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783489067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVx2Ot4wYHE/kJppGaGF3PrkXXYmH0DCSaT02ef7IcY=;
	b=uYrv7+Tai3Ap9Zdr1Ph/IG/3HiNhXKfCHNtGBz3Fqj8bCBz9R6gk+qNY9hS9sOvRVsu8Wq
	57YZK2kQmfQYhZURYXxTkJWTr7W4omwBVy2JaueNdIkj7sADNWvYZuWvIW0l6G770P+/81
	pRCEmE05JcuGyla23yRTp35PHzaXeSY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783489067;
	b=ZWftWPpTpeoajtSp21yVOMYvoCTHWnE8U6k0v8eZiij+WZZR92Pv6vjvkTg/W4Teuuts7f
	s8VB2xs4hNjHPUoUfMXTjTRp99SzPh61ZWvSCCkz7g9A1NRPeFSSQ5qTAPkHBGuOAjfJ28
	mI5Y0s5cRwPzkc4OhZOYPs5sAjqLyTU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=inU1ARyo;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="PMeoc/Ad";
	spf=pass (imf07.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66842ncC1668617
	for <linux-mm@kvack.org>; Wed, 8 Jul 2026 05:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	UVx2Ot4wYHE/kJppGaGF3PrkXXYmH0DCSaT02ef7IcY=; b=inU1ARyoLJAPAbw/
	BjRBXXcr9iSgHE6aynnOtdyQe7dqf3MeI15Yj05HHjTJ9F9ULi9aha9ooZYbXB/Z
	Fv9LDPqVG622oRLW/U1jPwzaFl2OgGK6roZTmy0mtmmf0Xzr/VXlyiF5+OAd03yN
	gX9/C5lEZpNszlb7U84WBlG9WyLucbwAnQ3yY3R2n1sJ6PygSllh+n7LFQLi8TdF
	vNMwrAkymelKH0GuXqux1js0UUqyDCPux6IVl1l6CwprwTGsK2pFmg+dxOZRiYDl
	/tu3f3ExCgBlNu/F2zkV3a9RGN31KdEFe6fw57OUKejVgfbign0bZ8Lv5sU0jU1L
	HcmNeg==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f95e5tty0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Jul 2026 05:37:45 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-845df469a26so910646b3a.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 22:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783489065; x=1784093865; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UVx2Ot4wYHE/kJppGaGF3PrkXXYmH0DCSaT02ef7IcY=;
        b=PMeoc/AdE03i3MnG4EkWf9HjRUx3OTLefUhFe+LfDY2lZJDrrQRkXrCtW9uOFdrKp/
         /Ny3j+SnQ7DBi0oQ5MzbkFzMxf8uJR+UftzfqZwGsc+zBpPZwtqVVL92qgOylu3s+sW8
         9s9YwU0x1GdAH9vCMRoHxbv6IibCeEFqb44DhRWKeAeg25V0Kfx7i780deRCTwYpTLio
         zibs6Xd6wrOjV8+CCwUerVscRAS67KlH09v9OWDAjlaoyIhieMQQ23YrSRcdczreURxl
         W6y3OEjTt/DwLe6G64XKyg7pSn+ClRUmrwcs22OaSmmMmEnjCpk1e2saWteapNpRwEac
         0EjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783489065; x=1784093865;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UVx2Ot4wYHE/kJppGaGF3PrkXXYmH0DCSaT02ef7IcY=;
        b=etD3vZiRcwmGbGu7DMgpe22l3mzICUbqq9BWv7oDFszxbDjDs7kZzSKEAJm/Ra8/U8
         O8u3sUtjFlrOSLmxdZQMLRPlULEs/BBo9Mf+esOGK2SZz4xap9DhL6G++DpJrKTJjzY/
         8fb6WCCrDd606obVv4emZCob9yJHbdyooek0b/0Wm9Oh2cU1ahnef10DR8KXRdUOc6ku
         QMAG/THkaB2mX3vdyw+Sf4rfzmxN+CeJWVxiUr+45fnNl8H09xKvAll7oVSGcnmHT3PJ
         3RGy8ZJTa6sJcDfT+fJDDvMF1ryn3GsGJidTj0lN3jM4ljdG3nGKSVzKKEdxAv2aEfWa
         Lm/w==
X-Forwarded-Encrypted: i=1; AHgh+RogJZBi3y5FIF7OtFtPrdzgiXzI/7h/0PtcTodbB1LpireoEZN96cgXpM2G3Si0m8DdD7uYLCob5Q==@kvack.org
X-Gm-Message-State: AOJu0Yyf2Q2dH+TXIFdrG2Jn5CfqXpzKl/rgMyco7Wt1cOS8z6vtTWZd
	nVNr0HOe0W8b6/jq8S5dP9gnY9bznoIVRtBykv+nSzHCaJTMQk7t6ZH7lILsSqofigejNOCPaRN
	lYxvxzUoxy2eurF+Xcg4RGkjqh52N6IfgWxttSpsCcxgmtCstUw38Yw==
X-Gm-Gg: AfdE7cmWItcETVdrvELApP+M0JBU9p+RBAMsVJsYwKwehzKzTvYH/hMkfP8PULE0yJB
	zGRH1rWJA7C3HnwAyxezgWltIIW7A2h2+xh3JAu8qtqNrVFUxzoRXl1Rx0IoNeS69aD1jnhmxjg
	UVfhZJsv79X/V2K8GkMpunJKYhJ30ETkDE/RJ+40sVKaozYWhcVJP0GyhVVSoew934IcXr5E7Xr
	J/cICW9z4QURzGvTz9Hd8n9GIYKShkM5hkhjIEd+dNXgorBU/HHVLisQIT48Adblhw0RXHOaOIN
	kH3t+jKb9HJRSFpGPFTzZtTyOJUKiYkU2I57IOaOIBaxGCQJjphD4i3KJ1WsIKNLpBeV+Z/jMq5
	ud0N8KzHrqlg1fF2SeWodJ6ojwMG2atr6lISLFg==
X-Received: by 2002:a05:6a00:4106:b0:845:d284:9e10 with SMTP id d2e1a72fcca58-848438c848amr1258953b3a.55.1783489064391;
        Tue, 07 Jul 2026 22:37:44 -0700 (PDT)
X-Received: by 2002:a05:6a00:4106:b0:845:d284:9e10 with SMTP id d2e1a72fcca58-848438c848amr1258874b3a.55.1783489063825;
        Tue, 07 Jul 2026 22:37:43 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm6484592b3a.53.2026.07.07.22.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 22:37:43 -0700 (PDT)
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Date: Wed, 08 Jul 2026 11:02:00 +0530
Subject: [PATCH v3 21/26] printk: Register information into meminspect
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-meminspect-v3-v3-21-7aa5a0a74d5c@oss.qualcomm.com>
References: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
In-Reply-To: <20260708-meminspect-v3-v3-0-7aa5a0a74d5c@oss.qualcomm.com>
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Eugen Hristev <ehristev@kernel.org>,
        Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
        Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>,
        Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@kernel.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, devicetree@vger.kernel.org,
        Eugen Hristev <ehristev@kernel.org>
X-Mailer: b4 0.14-dev-f7c49
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783488714; l=2254;
 i=mukesh.ojha@oss.qualcomm.com; s=20250708; h=from:subject:message-id;
 bh=zaV3PbmFUtDnw62zQ3JXo0ZBeG6yDbJIOwaDAH/EVmo=;
 b=YjEBg3cAlPVuq1xhCmIAiTNcWWeuFlgSHOCYG43WEd1GLttZDwSktzjEnZl0RMIdqfCDXEr21
 C1QgDxuT5KPDakO6+ATEc2L8W3i3ckHvvSzSZ0yPJJB0VegO27FDpYe
X-Developer-Key: i=mukesh.ojha@oss.qualcomm.com; a=ed25519;
 pk=eX8dr/7d4HJz/HEXZIpe3c+Ukopa/wZmxH+5YV3gdNc=
X-Proofpoint-GUID: TtG1YuXlkYSZXh0XNEjz5SsN8pe1o6Ji
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA1MSBTYWx0ZWRfX8Ht08PXsQfuu
 +REpqpRuklH6QMFryIj7lGAjrOFwnLfUQZS9P7jk3LXOA0VgSnGMMva4hAKZ725mO/DZ+++8jqr
 VhSbvSYUOCxB3K8kOTcWtC2bJbsQU7c=
X-Authority-Analysis: v=2.4 cv=CNoamxrD c=1 sm=1 tr=0 ts=6a4de229 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=iox4zFpeAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=ZWDwVrzm9O4pBL7d_cQA:9
 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: TtG1YuXlkYSZXh0XNEjz5SsN8pe1o6Ji
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA1MSBTYWx0ZWRfX+2MkO80tF3Bl
 LIkoOBNMXJpotasGx4DpyKSwBH5tZ7dG5xKMbo8IG1uULoPgkiXCETolaMGnynTX/ku/CXAw95Q
 PrVQIBErnocctnxzCdiEruPbw1i2K3AESBWZEGNa7JHUS03XzudrTg2BAOd1AZBXd5NST4w7+Ms
 4MF1cxfn2jxkb3HMjpYTJTkp/tm7T40DI0xbRrNIqF7Y0EAGsgwVptuW5rx87eKAzUH0KEctX75
 gvSB5SCem0uNDtn1zlqwOGAXnbT+yxW9dA4P1XZtEpIVEPoOT4YO4uyxzbRCADJbSYysnItGMGs
 bJtktsGYSX9ZsWYfInLGzYhvPxQgIiKMKl7piEFFwXz+TdjtNTQvQt1MTFO6jNM9PYG8zKCgHeT
 6k+kSp9a/P+rTeLuGqTbu/lO+KUOnzWEPsCxITot7IUKXYQ3mbtc1bqT81CS8IY6ieCpRY56n9O
 df+UZ98sx4SLiuYj6xQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080051
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 010644000A
X-Stat-Signature: ydekgmrii9n6xtp4onhnemafwewi15qt
X-HE-Tag: 1783489066-779908
X-HE-Meta: U2FsdGVkX1+fmoL+LqROMGNTWpITvtrSyjOgXF7UdqylFEbPispVOnfOWCLnMIvPibcbDcT+o+cxQA4tHFnS3dkaujyPGfsXpQZ30B+4ax7xc0QGovi2R6Cz9d03Ynv8eDO8GeoWGrwIZuCwxHtJ3PPwlTTec44sVE/Ai5DzQjqzt/WhGXpr8WOEz2JBsDBQRRtwry2k0N6RT3eA6PdDwVwaNLLXklQeSL2EoHUHhlw1M2rP7b92pZjO4lomFB0yid3RehR0htilmPj2hNUd6396zdcwmmy5RA0hd9Y0s26VJk+Uj13VpulKUhZsueXrcju8Qeyvhb6zkW/tHKZjkA4yaGMk9fcF13QtFbDQlEOM4YPfC0P0VVoxzGuzJQ5fekRTzKo1ttY5YUYnzP1KirlR05RUfq2HlxYI3qDF0lCeYSD1XAe8WGA8nbsYj4uFvcq+FEeWPEPgVyYDufyIVx1aBpD7SuijVTUBeDRkn8v1K5X4skKV1GNho7YDXdXss54obdnKjZ+XMqBgs5aOIyWa68uzQ0aXMmINhJNV4oQSJ8iZzXTMx91TtwGziuEjjZDu7sAEr+h4YCJ0QmbetpMM8kObfDed7IC+jkj1TvK3O/HyCuZ6P7t0SZ530ICiq6uXp3/tYHdCspmhdF7XycH4/QTxNNB5xnTzeknYm11O3jJELgqO6oCzKAY9oHPFnzqk0wo+qMY1yl3iDh932F9wcMhBXOrdRlXsB5nsiI7WNqtQBl60ORp84Pxhdt/Ui7dWuRjntfgNkKOgqubs4Y+p8WJwaKxWz54VjpXIywlfRxCF74nBjFZfrcsJG106n/E8qde3WBN11lakXeGumOi+SBEXc/tKLljddeABu9P+9FLpp0Nqbm00jjA4o8e85AUtrBP0AtJxpNqyk3AKetXX/L0Z2AIw23RjQGNd2vhTk7ztlV8OE9TRnZPe1X36yZAeHVI2+p0wYHDIyKc
 +e+fGQKF
 v55gHCFQG+5jHfEtZ9Y8H+AXlStb9NbvbvGOdwEpWsPNetSr0dQdpj484+3elFiFcftvzxAU8R6weSQBdutAqZuBibLNNr3LtgYBR8JQNT+IFyQgbu5LLIHKoHXduKGBgYXItGuhWaa/J9cvOLmcHHlfAHhRXDve9nlKk9XCU7bUQtthTNV/R66WTdCsOWqZZNC9jgMFwzR5VxjTAK5otWSeu/0NHNtuR5+nGlum90Y+751dFz+GK8Hbe4Ib6BMcL75o0gv819ssxj36MtZZOyf0opd7Z30WsaaQWQrYGuU7HDdkL47LTZNPci3+Krqb211x7DfrtTCGE/gKZ2CZbTcpmAGYXICujfcx2VpnNYXjd4TAlIOap2QVSrjvviTlLudpu7cB95TL2GaQRAH5qv7LxQ4sUxJZBNAaXReyaKSz+lFpKlIeJto/O3bNIqMU5g9nLPeQTafMncwFoMA3kGHwIlBlVZc0JGftYj19NrNaNB+0qALCdQwpTV8fgYGu+NXhfywsgM0BGsO0Tn2bkGr0E8iASehXlVCNcjiAhK0tgXgElT035aMobgZIqvYDHeCxpeGaW6qqLT0MmrLlpaRm6A8jmwNdzGZqSsPg9LLHoWVRZ4DNHLe+jNrxnDpeg2OZi7LSrR9jZWesPxkhC5hxFjBodzpDB05EB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static, dynamic information into meminspect for debugging

Static:
 - prb_descs
 - prb_infos
 - prb
 - prb_data
 - clear_seq
 - printk_rb_static
 - printk_rb_dynamic

Dynamic:
 - new_descs
 - new_infos
 - new_log_buf

meminspect uses a different API to annotate variables for inspection,
and information about these variables is stored in the inspection table.

Reviewed-by: Petr Mladek <pmladek@suse.com>
Co-developed-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
---
 kernel/printk/printk.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 2fe9a963c823..f7f32c09b9b8 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -49,6 +49,7 @@
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
 #include <linux/panic.h>
+#include <linux/meminspect.h>
 
 #include <linux/uaccess.h>
 #include <asm/sections.h>
@@ -518,10 +519,17 @@ static u32 log_buf_len = __LOG_BUF_LEN;
 #endif
 _DEFINE_PRINTKRB(printk_rb_static, CONFIG_LOG_BUF_SHIFT - PRB_AVGBITS,
 		 PRB_AVGBITS, &__log_buf[0]);
+MEMINSPECT_NAMED_ENTRY(prb_descs, _printk_rb_static_descs);
+MEMINSPECT_NAMED_ENTRY(prb_infos, _printk_rb_static_infos);
+MEMINSPECT_NAMED_ENTRY(prb_data, __log_buf);
+MEMINSPECT_SIMPLE_ENTRY(printk_rb_static);
 
 static struct printk_ringbuffer printk_rb_dynamic;
+MEMINSPECT_SIMPLE_ENTRY(printk_rb_dynamic);
 
 struct printk_ringbuffer *prb = &printk_rb_static;
+MEMINSPECT_SIMPLE_ENTRY(prb);
+MEMINSPECT_SIMPLE_ENTRY(clear_seq);
 
 /*
  * We cannot access per-CPU data (e.g. per-CPU flush irq_work) before
@@ -1238,6 +1246,10 @@ void __init setup_log_buf(int early)
 
 	local_irq_restore(flags);
 
+	meminspect_lock_register_va(new_log_buf, new_log_buf_len);
+	meminspect_lock_register_va(new_descs, new_descs_size);
+	meminspect_lock_register_va(new_infos, new_infos_size);
+
 	/*
 	 * Copy any remaining messages that might have appeared from
 	 * NMI context after copying but before switching to the

-- 
2.53.0


