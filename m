Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C262B606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 03:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=NJrWZDvx;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=rttjx1//
Received: by kanga.kvack.org (Postfix)
	id A0F3C6B05CF; Mon, 23 Nov 2026 22:17:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BFE86B05D1; Mon, 23 Nov 2026 22:17:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AFF46B05D2; Mon, 23 Nov 2026 22:17:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 365856B05CF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:17:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DEC4D1A0A08
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:17:51 +0000 (UTC)
X-FDA: 85468553142.13.5FADBBA
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id 06A6040006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:17:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=NJrWZDvx;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="rttjx1//";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf27.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795490269;
	b=m8C0+6QAfkkpA7hAiKleegorPRE4tuHvFlmI0yox46OW0KYO8aS8A4VKfzIBpadtaLmT3Z
	L6qvPN51Vdru8VmlbCNRDO6R4pd7yjP/BcvqJWmsYarwWeCgJ40ePiQ5BMxpRLzY+BIwXD
	xAAMgpS5EiVidVwlYpIpmMyP3H/LPxo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795490269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xc1Jva+P5RD32pY3oC31LLn2mJzvWkGZ2xK0oVerZnM=;
	b=KlQ4U0EIwG7RCtmfBjmmqq5XXYKlvR/5wl3AEDN27W5tHdo4EKGKgcywVNh5P5GWNdBl0V
	Awux6m3DuTN9FmyUSZxsJRW/4aduDvmHj/vAqgG6p+AQ751NeibdTbMjo10nRPyJyt1mx3
	WzCPhKksDLN1a1nr/gx7QOO6tBJlIhc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=NJrWZDvx;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="rttjx1//";
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf27.hostedemail.com: domain of mt4022@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=mt4022@columbia.edu
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO2cK7w2717964
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:17:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Xc1J
	va+P5RD32pY3oC31LLn2mJzvWkGZ2xK0oVerZnM=; b=NJrWZDvx6gQLk5DHzVnU
	5MdW6ovmyfdbd7htr9RqakV/rreAeRijEH7NIT5D70kiQ7HVUl+liLtLmC/Xh8Ik
	uUCCWYwSzbWxbSQMxvbUIyUOMEDtMFg2w0c9BqbvyykPGFj2wGASSwFxlCQonuZH
	cLhEtDIunLIe78ulwC/2giQUM+e72ZFXlpd9GxiPWWR+mrUIGzrTv7Zh567gNGVm
	I9uDrTy8dpJVXxAPWRp8+hIbnELGoYo7ujzH91KKGLblNQw/bYdDq+bLnlTIOiXu
	1jth3z36K6Ymm50as4Dr0xG4k6QoSkERut2znQbTX7i4VGVIPHEse56HVywu79sG
	mA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j4ub9u3bf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:17:47 -0500 (EST)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-55d33f412b1so78656771cf.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795490266; x=1796095066; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xc1Jva+P5RD32pY3oC31LLn2mJzvWkGZ2xK0oVerZnM=;
        b=rttjx1//E+hNADPMvX+MOkMXycUidJJtPQUF95oE53Zqvrkl0FauaVfkcMjNHI+/iO
         IL+fnw3nRau/+RcPZNCuw1aeLeVOb8sq2eBF4b8MnLEakFw7F0YI7P55VC2TxQp8fgZp
         rSZAGFuhfJvF//gg5FMZ2ACA5B+5mhHc1JkUWFjLhFgWgYDuE4iAxKyC3DQC2mgCxziN
         J/ADiqzFZ4LvRuT4HGSsNICZWVw8mfvxH8v0Bx0meACjg0s4j9hV2RWHypbwxWx8J9fp
         lC0jYB5kRj9ixykNbkWkCaEYjs9ou0psiZCWpOaBeziHSt1qFCKWO+1aOtTJUdD7+2aA
         +jlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795490266; x=1796095066;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xc1Jva+P5RD32pY3oC31LLn2mJzvWkGZ2xK0oVerZnM=;
        b=yrkjIM7gwHHEGqrh2ghgIPztj9qhqGMUgXi3siHsyWBSu/zsOY3zGm+ldjidfkRftv
         TKDA0qMOnIcVihrokNau7jmW1HDPWTK+e53pMZiYde5m7ZMkUzC1s9My23GLFvfwvr1J
         YDQE1tZg9NpU3qQlFKcp29vJzJe65vEDdbF7EK27sXzKAL8rI2cwGoDIDf8gpfIKTQYm
         scJF5wm/YrEuL0p5+pT2nvzjbkAwm/jDMe78QJhHdHdk2ptSyGPGAccRH3pzGXhyG8mZ
         0NKCUyhK/qrZhr5CHi+bpYy29JnpDEP9vrvz22Mq9r0Pmt1vlo6pIVITHzq0o9wPoYCW
         MDgw==
X-Forwarded-Encrypted: i=1; AL+hErEftQgLvnN3aGhEFkXb0WBN3Zeb9AqJtPDa88TxZFhyal3wimivLv724QowvmlD/MsJNB0vOlL1OA==@kvack.org
X-Gm-Message-State: APuU4Z/+F6K7SMp6MELedPkV5Uh/yewX07I4QnLl0DuLBnK259elg6dp
	K/LJnvOsnlSFnaHwZq/Wooj/ZgSfU2tqwUKt/Gs9uMRpwt/E4f8DPe7swgzPitv9NcogD5plfSI
	IL5WX3LIbCHqlH4ckbZxedlyxX5cV6ukjLs3V7bv+Y1uCnLOA
X-Gm-Gg: AZFdTZfbNZknt8LcYKlm8gOup8/R7/DNeRLSp2lABk77OGbj/KbDjcFDH1tD6slY53f
	sV4hIydtqxQuZ0pG8IC5lYFJwGhcOYbZJWjo0k2XRpgK/ZIjvSXnvJpN1s4mgHfZO+amn9Io8VY
	W9Cc0dAKP5J2IAzYSbKpYOAFZOVl7L+4vM5Kx4LOjD8SI6yHUiYAwJEnHr3uVDLy0xtvhPTrlCW
	Cn40xtn0YYqueTmjcapnJjCSdVUNI55Akxe99HBrGFIt7qr0U9cJrVPqLbM4OwdOUnynB30e4hE
	t0vOdI8EZkAYXrsU19eOp4CNUpKAP2EPZcZGyzSojwTxKjd4RSqaKBTu5537OCiPKBfMnj9mkKF
	47lGFVbFcyWzbbnMvsimwtm4GWeb1M5M3ArskvSoZ8k1k0+b0DEGGpoTQGEv8102xEuEcXQ8MBV
	gRivn2k7hzEAB1voQAJavllFOTkd0BLDxiinyELgBytwqFBQ4coA0hVX9qU5ZUkolaJ8wMd/LNT
	jAAGlol/FS2V86rj9MxfFZGdxlGph2YUegmjOB78BDlyuKmykkbH+W6C5UIU8dtkt85fMzC4eaE
	O6/zW4b9gogdVTYieAYcLAI=
X-Received: by 2002:a05:622a:4014:b0:535:a5fb:6459 with SMTP id d75a77b69052e-55d76a97e34mr243107781cf.68.1795490266608;
        Mon, 23 Nov 2026 19:17:46 -0800 (PST)
X-Received: by 2002:a05:622a:4014:b0:535:a5fb:6459 with SMTP id d75a77b69052e-55d76a97e34mr243107601cf.68.1795490266274;
        Mon, 23 Nov 2026 19:17:46 -0800 (PST)
Received: from [192.168.0.76] (dyn-160-39-51-212.dyn.columbia.edu. [160.39.51.212])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a2806dsm120277726d6.45.2026.11.23.19.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 19:17:45 -0800 (PST)
Message-ID: <ed5e6771-785a-434e-afe1-90ffd10a34e6@columbia.edu>
Date: Mon, 23 Nov 2026 22:17:45 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory-failure: set PG_hwpoison of a non-hugetlb
 page under hugetlb_lock
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tz2294@columbia.edu,
        stable@vger.kernel.org, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20261106-hwpoison-hugetlb-ro-v3-1-c11186963647@columbia.edu>
 <42a60f57-5323-f981-8ef3-2e5d67623902@huawei.com>
 <a87cbd92-0e07-4f84-9a6f-8db0b1778fcf@columbia.edu>
 <b0f30561-aabf-2bf5-2204-20907c40ef43@huawei.com>
 <08b18b88-3ab4-4681-bec8-f4564fe9f1dc@columbia.edu>
 <77680005-7178-cb1d-6e20-e23519839222@huawei.com>
 <56de516a-c895-44a0-94f5-ea7bc5bd3ef9@columbia.edu>
 <53d2f7e6-581a-ec05-6dc5-59a892ace835@huawei.com>
Content-Language: en-US
From: Mani Tofigh <mt4022@columbia.edu>
In-Reply-To: <53d2f7e6-581a-ec05-6dc5-59a892ace835@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAxMiBTYWx0ZWRfXwiXApV66+d6C
 wueuj6DuA4kl2d4pxqhGmn+I8si00KEW/O4A9FMl9GdeOJizDaHEwwsFHcXP2mggkVHEfdijsfj
 xKgRL7VhQZZLGPv3wJ12UYIa7mRNbmrOenXMELOWGvoTUo/aeHYm9dz8Dxpg5ztLJgi9HCo5HDI
 VrSxKZJ3Qpxt9u7NS13eBAv7/4Godw5kgzdx410dfnc1Ze+WlIG842wTetzV1j8oNBtS+N83dGq
 /627UiKG8td6ZbBc1yeKtCfNg0qjo21wZAKMZb9DBQKfNnzOddT5r23Xy9E267KAm/GPHomhQG4
 3zQt5qXAs5t1LrDpoewyjheML35CYEf04MjAZ+50ZZvIkxFStA26V4DTo5TMRDu+vIbu+Twj49z
 ql/5oA6LrKAggJYmgIeYLoNNoVDE4018hPQK+k6nZ88eHpFSXRPRBrz/KoUpT5uLimixnyYdOZg
 GOEfhr9EI0+3A4E7wNQ==
X-Authority-Analysis: v=2.4 cv=fd04WEQF c=1 sm=1 tr=0 ts=6b0501db cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=l9izRfKDRJJ6Wn/vzKnQSA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=ksQGBAMdBnAiGY_M9A8A:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: odIMkBZeyOimlkaoOM_IE4Z67-4fs4sD
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAxMiBTYWx0ZWRfXwEWsAVrcBtQb
 KST2fXlpSrr3B90wn27RCK59QOHiWB9vPLz6NPBcTKudf0nYPEGDN0MJkTIFfMTv4XkJk+FaiQx
 wqJ6FV/iOC+BYEumz+axmkRdWIDziDPUZ//itUXXTygGMRLpkERi
X-Proofpoint-GUID: odIMkBZeyOimlkaoOM_IE4Z67-4fs4sD
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11975
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 impostorscore=10 adultscore=0 priorityscore=1501
 bulkscore=10 suspectscore=0 clxscore=1015 lowpriorityscore=10 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240012
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: h77j3s363bff5ju9uzej6r8dei6eeonz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 06A6040006
X-Rspam-User:
X-HE-Tag: 1795490268-111277
X-HE-Meta: U2FsdGVkX1+z8xPrJHV0mQxOwdSdVKE4K8/aWO5q/ZsM6xxQGJzzAIPHJ8q/hzjX1YQatWu049ug0Uo+B4yVu7rCavoMqUMMsgIotIIE+KMHUMlAls84rVDc2Ec9SR510DQJwWObpdqRWknlZu7DgXrky/vPDwPp9kMGzVzw47X4/zEW5jTeQSnF8jsZZBcbiLKJZbfFjw3glxUe7GWtpK5OtYQAKeSVI9bjSVE1y5qohPK2RQs9l7WFgVJg8ujIChqAX1QPTtA1M35t9LwGrGEIvEYD6uS1FEyJpKBvwv7+izJ/08XB6X6Eufm+A6bBJ5FlfR9C7uGEA0MpVyNBnEZ2pzCccrJOBXJb0eG8/fGAK9u/y5C4cBwQFDPrba4U/Zh8EDM/bTOG5Km6Av1XD5ZweYhNTQjJi9+P/0eAm9Co9GP47MQea9um5kqfmTd0O85VsDUNOBq2URz+UAg/iKMqR6VPGmGvO1bFr5mcFnnwMvhqY+P33zuZw2ZU8Z0L2jLLPA0sA0dxFpA+Qopb9OW8vMY9veVmhL7s/uNjTThi4+Kdbydc4zqisneIea39S3eXXO+PznJGqGG4N5o4DH5bJHZs8ZlJDSDoz311ffltPPV/7JOX/tECB8WAmmu9D9G3ujxRK5VjcoznO7SWGvEy8uvurVpwtpni+CTph5uzPGBpH/C0IEzALHNquWEZHr28AvlCCTlH2XFAj3jLU16nCgXAJ7svlTKq3SSuaFguHaPxyH4bUmzPeIHSbPAoHXrxV6aVvl8L6cmfln606InN985hJW5FOuMQ19apDrHDSZcR6mxh/qu1m7F6Fr/AkzoFEbj6m/ZZU3IZkA4ATryWQdAUpgAQ93GpvwDjuubKOIGQkiUV1Emr+zgczcyLSjiM7fk0EiC+zVrgsp/uFo+4rZg36Qp9A1cz1y7XNL6ONtW6rZeAuT5D1ZX/d/kqAohCuwatHzNftXIc3Nj
 9t05aN41
 Hc2s6GlLXD/6N8mB5QdXOc80WIkXPSbQs4Nu+jJnNGbNmUH/F8lDOFH6jGwR5hmFBEGoOiZ/u9tn3a+Ape4SMJ/G/rshUnm9Ru9tIdSZCFrSpPurGKJwq6NK9vAmDCLQeDfxWgCl0kIgyTDjDAajmLNvV9V8FMrLT/x5Wsqo6ch6FRVFYp2Pl1ZTsJspFrjqqOF6OBEInbuXRSaKQx+G110j0tTcwjHqGGdozSjZPwc9QGaitenbCWCpjeObhQuZV27QoO1Y0YleWZ0cnLgsfXQgvNa/3Gexkf7nUfk/XL54Hf6q7blra+oiye0n4zhlMme0r84KNWGGa0oxjiTn88+tXiWi/Lss5HpohdeBS+Ayu35GA7KmaI6bac0wqaGKKP9drWrncfHHpIpo89M4nfl6M8chDEpLVP+NT3U+hkUuq6ySgcNUvWVli6lcOM/h8nTLqqfMGpZjblKfvk8YDRuMvGmZ3CuoFaDETbQFx5WFSiWqj/329BdSJlW4HyHkNzmB5eBQvV7WkBxmcP3mAeGXL9GZIRLL+L6OrtbaeyNXlBj7YLnQYCWTR+eFmxIg5KbpDPDpDpV+uS8sPt7qsrrd0RPj23IygGBoQQE/o9NC+HCQ3nxrB+DWqO3OchYfmrptzX6BkVcI3VqVqoLvuxl4y0BJl1p9pEqz6k658FrsD7FwLtW2CxoQiZIYtBsbdO2j+P+ophpOaQxv0MvV7uGrTZcwUh7xlvsVXLGBgg0gbW1SW8yB+FjxtZfT60wwKY3C34VVBwj6QyyidHIA6jgBf0jophyawDIPy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/23/26 10:11 PM, Miaohe Lin wrote:
> Yes, sounds good to me. And some comments might be helpful. But do we really need that rwsem?
> Could we avoid using that specified rwsem?
Yeah let's keep that, otherwise HVO can copy the first
vmemmap page before the flag is cleared and the copy
would still have it. + Will add comments too!

Mani

