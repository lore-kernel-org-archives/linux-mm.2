Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D2E4F013CC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 08:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652DC6B015D; Mon, 16 Mar 2026 04:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62A646B015E; Mon, 16 Mar 2026 04:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D96E6B015F; Mon, 16 Mar 2026 04:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 373C26B015D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:32:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 00681160138
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:32:17 +0000 (UTC)
X-FDA: 84551259156.13.20815FC
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 86EDE80008
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:32:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=eOOFJRm+;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=M354rlvA;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf02.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773649935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEsX4AQIACcJrlZimSP3t1dr/d3grVw7qEZ6LiElNb0=;
	b=h7TgtFj2Wg1kzCpSV/dLFRspo5toJ+X3cNnYt5wCyBXH3LiwtSw5gHqXb/1OnD54bezvRe
	PosuaxLt9ZPbUXj51B+7TU6LOHgpbLjBa85jdASfQYzG3gan1ktKPkRhTlgULNVIVPF/iT
	VXDptPp51beoIVC7uQeRyZDwut67DWs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=eOOFJRm+;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=M354rlvA;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf02.hostedemail.com: domain of mukesh.ojha@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=mukesh.ojha@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773649935; a=rsa-sha256;
	cv=none;
	b=LCwhgQt4cT5dY2FjWrMyDK7Q8eg6aaOOX75u2fr7LFa1hYC/PGbu6lALzwPLEdTcfIXPyE
	nPMnwV5b8rJyGghff9PzSDAcBa+cK792cttSimHxpwC1Mg1PMQ1WIe4xP8oSHrfI1eGily
	ZT4fjN3ZR5sVAPQENxGXuCjZeWM54vw=
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G64ate1066807
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:32:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=KEsX4AQIACcJrlZimSP3t1dr
	/d3grVw7qEZ6LiElNb0=; b=eOOFJRm+jMWGHqyVPOa3E/QSvfn3ZFyQu98P0Adw
	G76bAAUSfG1WZgcvyH0iVmG8v55xPDpJzFynWsac5VipA/OT5RgovitBFGfrViVP
	qoqD+o7uzSwMBuSZgsds/PuYyPfLYZgYYKgT1XFqamwafMVm+s1RhL/m0Pr9czPf
	6+HjYTVjD2zns/I+oXeqPQubvbQeO0sYjLuFYLTBuGE+wSdbD5w5tpnHUjC5LXi2
	jcUBgMJFZ7HENbsT/wULQDrsaam5mIdiGSsfsG7vNu7niu1FuBM54dQSLd/676+0
	+sczHTMCbYAd7Z6HsnmfcPwD2YNzdBSPJSrVNVizDH9tLw==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cw027cuuy-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:32:14 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c629a3276e9so19670805a12.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 01:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773649933; x=1774254733; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KEsX4AQIACcJrlZimSP3t1dr/d3grVw7qEZ6LiElNb0=;
        b=M354rlvA+4Lm7dIRp6JVwb28uwz1+0cq/TCixbm+lP39FLOuYCIa3h3uNRq2wUbYa0
         PCQtJ7PaHCdAPTn9rsAaPp7gntPXkv9DXBvopshYrUvaN3ptUrVhzLQLA5WxvbObFhMC
         qG1s8r5e0Qsak4f84yggZDhirHJxGMcORaNDKagsD7o9w6W3ulA3C12oxf8GZGsdvyIk
         kqwn4wl+8uaZauP7aFobSAmWR5LhtJSjvwMrRQNqkCiGfBVHHZRD1H63TXxQOi6l2MNC
         mVeU2SIP4WHxuVX6xGvVn2oSizAjuc+2IQpIFfcT+DDcpKxgAL89z65u03kO9tqleV7m
         a92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773649933; x=1774254733;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KEsX4AQIACcJrlZimSP3t1dr/d3grVw7qEZ6LiElNb0=;
        b=ZFb4Oqr4vN6r4ahRHIPn5/3IyD6CqyH31pyzweAqnIv516st4M40d8OJfygMOAlbPL
         kuGAdVY9YdIHlXhihEjAgaD3WdPoNIrIanjPFWnnWhgE795GcPRGTbkQiwfbs2l0JoOm
         ZVDmaTchCR97b38FSOsauNJ0WC9keWKYRTrGyjUl8FWoSeJdhjEC8iotRFmoV2EYV2Wn
         n9KyiEkju7O7Zl6HhLmrpikfaTk0jF+DiyjpyB8ErlbYZVLQNXiYtKeXub9J7cKDxAVs
         GMkq0TkZWj0UVeHlp0/ZHSvAtVonZ5RutoyN98ntTuHkIWesnmZ9/XoV00dXBXX3SRaC
         SDUw==
X-Forwarded-Encrypted: i=1; AJvYcCVKYmCKcd5MycJiDb35qkmHyS1U/BtMGlFH28GkQ13MkmnkBYg/D7CS9VZs+bVVb/itvHi+rtP3HA==@kvack.org
X-Gm-Message-State: AOJu0Yy5u81wQh8oxxuKL+hOobvm++cdoK3MrGCGSP5G8zttSJUSj/zo
	GEuc9ua9gRuhToH5iD4jA4gnC2F8PYTGvaT2MrGeiwFm8aw4/cWpJBxaAQYoqjYgKlN3oowiBE6
	QfxSDx3ENDYSK+z+ZLXkBDhLyLy0nMKJ3sKZs5PwPZM+m1n0q1E1QCQ==
X-Gm-Gg: ATEYQzxvY2b1L4L9TCee15WRux/v0kgxUPFxGHjNYoQDYHXAhKWR0r+ByAgdb5djVaq
	MXZZ97MXuWrYBlqRqUIufvLwC2HZ+92QYTcHtZ+gZ23Or5muWc+B+TCSVHdz6dDGcNKYOzBpRv2
	uakYOSKcu8R3uDci7NsYCfsYOlNJEzSzYMVs7f4ajOZ5/RU5ERJuVbU6jCueLuZ2G2UQ3dck0Iz
	vBW++vrBZUYEiunb1Y++5KPvSTOZLqSjWuqRVDLlC779pyCQal5vumkqkf88VXSZGYAiVfgHK5w
	FJ1FKHprn1kDrjU/p3G6dOw06Sejhapfl3clT9ewcKctFEfteAmAAA/4pSaF5CP3yU+MvowIm2d
	wzUTs83xf4MgocwvnIQvpyNhgFhXSp154EE8ZhhwdtBgsnWwU
X-Received: by 2002:a05:6a20:914c:b0:398:8a92:78aa with SMTP id adf61e73a8af0-398eca38eecmr12281894637.22.1773649933039;
        Mon, 16 Mar 2026 01:32:13 -0700 (PDT)
X-Received: by 2002:a05:6a20:914c:b0:398:8a92:78aa with SMTP id adf61e73a8af0-398eca38eecmr12281802637.22.1773649932245;
        Mon, 16 Mar 2026 01:32:12 -0700 (PDT)
Received: from hu-mojha-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7401588ecesm4048529a12.32.2026.03.16.01.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 01:32:11 -0700 (PDT)
Date: Mon, 16 Mar 2026 14:01:53 +0530
From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
        Eugen Hristev <eugen.hristev@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Kees Cook <kees@kernel.org>, Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@kernel.org>, workflows@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 01/25] kernel: Introduce meminspect
Message-ID: <20260316083153.pgcdkio6hc4lyr6h@hu-mojha-hyd.qualcomm.com>
References: <20260311-minidump-v2-v2-0-f91cedc6f99e@oss.qualcomm.com>
 <20260311-minidump-v2-v2-1-f91cedc6f99e@oss.qualcomm.com>
 <e398475e-4db2-40ed-baeb-89c2bbf6a0d5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e398475e-4db2-40ed-baeb-89c2bbf6a0d5@infradead.org>
X-Proofpoint-GUID: 6z_f2PSqp8JN4z35NK41WcanVPwmq4Pf
X-Proofpoint-ORIG-GUID: 6z_f2PSqp8JN4z35NK41WcanVPwmq4Pf
X-Authority-Analysis: v=2.4 cv=AqXjHe9P c=1 sm=1 tr=0 ts=69b7c00e cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=O2Qb6zUoD9IP5w4LekwA:9 a=CjuIK1q_8ugA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDA2NCBTYWx0ZWRfXwlT/GURzXkvD
 EJ7SR04km9Tipzg0QAG5GeNKKPIhI9t3Gt+IyKIt2q4GzhezzKXYjFV7FwGuXGDY/lxuWTMqEGW
 fd0AL8sDtF+YluMx6iimFmaYQuxFmVt0dLZH4nM+a3d4dMyJSGNxKpbOtBSA/aB77H+I91hg3ax
 yG+LzNKjNpdk/1ASmhONiZSdJavoLGWenOtdp0I7wDcFCezA7YoTcoqyH09FLYgLLeZvgvUMzmc
 PoCwjaMzmCwtg/3aIaMEf59QU0HiSe5P20eB1Q8DEHws9trWRpfd+3szc5aF4yLhyNwuVweoiBl
 4vQaAQmzXWX8jvw82uzlSZWAZ7QjpWYYRcfDHgc77e3qEi888uSRvOfzJRtx1rDZCe3a42nDKzc
 DNeFKkOGsMAix6R/+tpaeA21m5aXQ7WgSTMNFHh38fS6DAfT7/AaVJFSYJli79piIn39FPZk3Oq
 G3PswZzeGwfkvmG7jag==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_03,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603160064
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 86EDE80008
X-Stat-Signature: wiecs8xw14q4qqm4emjaey8rttxq8szx
X-Rspam-User: 
X-HE-Tag: 1773649935-420240
X-HE-Meta: U2FsdGVkX18wfACXwzR0OCP6PSQVXI8h0J+JSsZ8qfV6tetYgj6O4MPOkgcydFNWjjNIsRv7ZqfRQ3hXa8oYlxC0a3CV/uelz6gS1aVK9pHc4XBPqi/TbtRj3sJHOApEoxm4OR/I4TKIJfuQ4L69JYrWCaN/tGaJc/xJiU9SiaoO/d1A+OefjMdkjJX4JOn4wVKwo2g45dMuv2FBdkGboLZwrSRO3AGaVWjkfPV5/Rwyax15xIzIXfYWcxEZEllS1F0bGVuPvQ8Gk0kZo2IpyihWNUSYufv/d8LFPUla2TIX2yIRC/WFtQIfC14uWPPbr8hM45rdix1d9yRhHAiVvIsltHU7mq52l6f/djZu8XwonTWeCxILG62piL/HHvqGfBzwi4zGfstGchSdctAX5qYzokW8vtDkJ/7e3tuhwrvVxQ/cUWrLBmnTY0bPslyprb+UFzsN6820Xki6sgJ70Hmzjn6iMnETDkCcixckZo5KxDDgYjAChLV85aa/h1VIFZ/WVBrFZNW2/oU27Nx6Ty8/qEpoRNW4/3lfdr277y9xHK0gByyqZodzuNf3oqXCGDU3ezV885z8EaUR28WBoGc4wCEjEKiDRuTVjNzyDzRLuc3dSqXh/0gj8c+q07Hv9LDbCfQxzTUZmJy+hbxq/4kaiihW0kK2Mo2Y1eBfbXBMF2YtWefEm+sB0tRoETX1toAaXz0wq1wboNzScIpUl6YLGO3pJdLOl+qCyaxHKi0RWA6u+NMXzzuJLkffcIG0VwzNCV6briUyDvdo0eULmrkasVhOnhoAvsqw6W6HYgjrCfqF9jkGFL8sgl9F4QVUydAttt+oPQF+LwioE1gGaMr9ImIlEGkkPdByLwwTu3hk8cNTjwfWyKsJmUFzFw6yJrZ7hZ/UXtXvAylV6m16BxclFmn38GaQe26p7zXkl/0ruanXxCZmhfm+0Ma4Yc2SyitkXeAdBW0STEjicbw
 Qt6X+GyV
 N4h5aNC+Te+4eHyDHDHflOJHv6a8lIB/mSMPm6rwv4bRUH7jnMBR9xPR2m6TxJUtxwmKV+fJlebWu1SmvQkLb4PAOIhw2nH2ASXNX2lh3iXOc+42SGcC1JjEczfdBTjh63f9BRyo1B39WT7R54YJ75/O+vndQfgzw7kLh1tjK8V2G9D+dbdMy7paIERG1Zp6PZooTp/Xao5pyr+26vFxb9Lcy0lDb4Wcp9Re4uFVR4pKcp1MfmTtXClg67GktatV10QaHhVk7RciaQXF96sPg36MAJMI5UpJyzJpi1+zXPirTeX+jBq1ZHGHn4bLwiII5YEXpIuVoqneXw9lyga8zpka5CdJpyOBn6Kss8UlxoLi2X04jtCYXjHb46Ma5Oy0TliT3xjq5c73alD81jBAS0XvWMjaaQDr7WLKUHEx8wOltuZJwAm/b6WasCp8bA8nUN1TyChVYhm2rUbQPZDvvF//FuWBCr4OYjicB5H3Hcsj92Mfe7nuRQAQZEJYP2NZxBstctzubK5GjyRGguM5zbwuOpudeUy8l3z16pXtLDgYCLww9WFLyeilYXFKX0vqrkzgjw0OzQ90OSgWSTQu1R+bFl2D6Gy6FmvxTN9I3B0LmUeE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 09:46:57PM -0700, Randy Dunlap wrote:
> 
> 
> On 3/10/26 1:15 PM, Mukesh Ojha wrote:
> > diff --git a/Documentation/dev-tools/meminspect.rst b/Documentation/dev-tools/meminspect.rst
> > new file mode 100644
> > index 000000000000..d0c7222bdcd7
> > --- /dev/null
> > +++ b/Documentation/dev-tools/meminspect.rst
> > @@ -0,0 +1,144 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +==========
> > +meminspect
> > +==========
> > +
> > +This document provides information about the meminspect feature.
> > +
> > +Overview
> > +========
> > +
> > +meminspect is a mechanism that allows the kernel to register a chunk of
> > +memory into a table, to be used at a later time for a specific
> > +inspection purpose like debugging, memory dumping or statistics.
> > +
> > +meminspect allows drivers to traverse the inspection table on demand,
> > +or to register a notifier to be called whenever a new entry is being added
> 
>   preferably...                                                is added
> 
> > +or removed.
> > +
> > +The reasoning for meminspect is also to minimize the required information
> > +in case of a kernel problem. For example a traditional debug method involves
> > +dumping the whole kernel memory and then inspecting it. Meminspect allows the
> > +users to select which memory is of interest, in order to help this specific
> > +use case in production, where memory and connectivity are limited.
> > +
> > +Although the kernel has multiple internal mechanisms, meminspect fits
> > +a particular model which is not covered by the others.
> > +
> > +meminspect Internals
> > +====================
> > +
> > +API
> > +---
> > +
> > +Static memory can be registered at compile time, by instructing the compiler
> > +to create a separate section with annotation info.
> > +For each such annotated memory (variables usually), a dedicated struct
> > +is being created with the required information.
> 
>    is created
> 
> > +To achieve this goal, some basic APIs are available:
> > +
> > +* MEMINSPECT_ENTRY(idx, sym, sz)
> > +  is the basic macro that takes an ID, the symbol, and a size.
> > +
> > +To make it easier, some wrappers are also defined
> > +
> > +* MEMINSPECT_SIMPLE_ENTRY(sym)
> > +  will use the dedicated MEMINSPECT_ID_##sym with a size equal to sizeof(sym)
> 
>      uses the dedicated
> 
> > +
> > +* MEMINSPECT_NAMED_ENTRY(name, sym)
> > +  will be a simple entry that has an id that cannot be derived from the sym,
> 
>      is a simple entry that
> 
> > +  so a name has to be provided
> > +
> > +* MEMINSPECT_AREA_ENTRY(sym, sz)
> > +  this will register sym, but with the size given as sz, useful for e.g.
> 
>      registers sym, but with
> 
> > +  arrays which do not have a fixed size at compile time.
> > +
> > +For dynamically allocated memory, or for other cases, the following APIs
> > +are being defined::
> 
>    are defined::
> 
> > +
> > +  meminspect_register_id_pa(enum meminspect_uid id, phys_addr_t zone,
> > +                            size_t size, unsigned int type);
> > +
> > +which takes the ID and the physical address.
> > +
> > +Similarly there are variations:
> > +
> > + * meminspect_register_pa() omits the ID
> > + * meminspect_register_id_va() requires the ID but takes a virtual address
> > + * meminspect_register_va() omits the ID and requires a virtual address
> > +
> > +If the ID is not given, the next avialable dynamic ID is allocated.
> 
>                                     available
> 
> > +
> > +To unregister a dynamic entry, some APIs are being defined:
> 
>                                             are defined:
> 
> > + * meminspect_unregister_pa(phys_addr_t zone, size_t size);
> > + * meminspect_unregister_id(enum meminspect_uid id);
> > + * meminspect_unregister_va(va, size);
> > +
> > +All of the above have a lock variant that ensures the lock on the table
> > +is taken.
> > +
> > +
> > +meminspect drivers
> > +------------------
> > +
> > +Drivers are free to traverse the table by using a dedicated function::
> > +
> > + meminspect_traverse(void *priv, MEMINSPECT_ITERATOR_CB cb)
> > +
> > +The callback will be called for each entry in the table.
> 
> maybe           is called
> 
> > +
> > +Drivers can also register a notifier with meminspect_notifier_register()
> > +and unregister with meminspect_notifier_unregister() to be called when a new
> > +entry is being added or removed.
> 
>          is added or removed.
> 
> > +
> > +Data structures
> > +---------------
> > +
> > +The regions are being stored in a simple fixed size array. It avoids
> 
>                are stored
> 
> > +memory allocation overhead. This is not performance critical nor does
> > +allocating a few hundred entries create a memory consumption problem.
> > +
> > +The static variables registered into meminspect are being annotated into
> 
>                                                    are annotated into
> 
> > +a dedicated .inspect_table memory section. This is then walked by meminspect> +at a later time and each variable is then copied to the whole inspect table.
> > +
> > +meminspect Initialization
> > +-------------------------
> > +
> > +At any time, meminspect will be ready to accept region registration
> 
>                 meminspect is ready
> 
> > +from any part of the kernel. The table does not require any initialization.
> > +In case CONFIG_CRASH_DUMP is enabled, meminspect will create an ELF header
> 
>                                          meminspect creates an ELF header
> 
> > +corresponding to a core dump image, in which each region is added as a
> > +program header. In this scenario, the first region is this ELF header, and
> > +the second region is the vmcoreinfo ELF note.
> > +By using this mechanism, all the meminspect table, if dumped, can be
> > +concatenated to obtain a core image that is loadable with the `crash` tool.
> > +
> > +meminspect example
> > +==================
> > +
> > +A simple scenario for meminspect is the following:
> > +The kernel registers the linux_banner variable into meminspect with
> > +a simple annotation like::
> > +
> > +  MEMINSPECT_SIMPLE_ENTRY(linux_banner);
> > +
> > +The meminspect late initcall will parse the compilation time created table
> 
> maybe...                                       compile-time
> 
> > +and copy the entry information into the inspection table.
> > +At a later point, any interested driver can call the traverse function to
> > +find out all entries in the table.
> > +A specific driver will then note into a specific table the address of the
> > +banner and the size of it.
> > +The specific table is then written to a shared memory area that can be
> > +read by upper level firmware.
> > +When the kernel freezes (hypothetically), the kernel will no longer feed
> > +the watchdog. The watchdog will trigger a higher exception level interrupt
> > +which will be handled by the upper level firmware. This firmware will then
> > +read the shared memory table and find an entry with the start and size of
> > +the banner. It will then copy it for debugging purpose. The upper level
> > +firmware will then be able to provide useful debugging information,
> > +like in this example, the banner.
> > +
> > +As seen here, meminspect facilitates the interaction between the kernel
> > +and a specific firmware.

Thanks for your time and review, I have applied the changes to both doc. and
Kconfig for next version.

> 
> 
> -- 
> ~Randy
> 

-- 
-Mukesh Ojha

