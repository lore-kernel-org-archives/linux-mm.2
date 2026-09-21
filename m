Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B0BC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94F686B00C2; Mon, 21 Sep 2026 11:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FFE96B00C3; Mon, 21 Sep 2026 11:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF2A6B00C5; Mon, 21 Sep 2026 11:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 512AE6B00C2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:14:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 741171201EC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:14:50 +0000 (UTC)
X-FDA: 85238116740.12.6219C56
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 20C7C100004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:14:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=dcH+Et1y;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=NM1Lw168;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf14.hostedemail.com: domain of pankaj.patil@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pankaj.patil@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790003687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+sC0Yvqh8Q5nitoPDOO2xtDXj5k7Je/RXYaZIXdOYtg=;
	b=Ppf9R3I77BwzeAFtjhCaWvv4+YcMo6dMMb0IJpPasKudGOUnDaqIKn8XWgkvE7TI8zMITc
	Y9QuP+jdj/sdo2b6sXWddYAhti+cfTkL5VrYXl/vnZ4AxL7xnYJfafuMDkJR+BaAC4cp2s
	vZtE2CzgycL6k4peWO8A9onF+IkAEqk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790003687;
	b=AoVbQkPIAP5nCQpGAjdT5JV3uEgxhDxVK9PLezE3L6kRL3+huVV/YFXJl12A5jEgho9uXD
	ixSmKCmQgmTGeUYVmM4pzovziYKlDxd7j9OfEiS4cMai2XL/MiAx+rrx/Hk+eUwDYVsNQY
	20gA45Dty8LEAAvvJBR1xguNN6RRtKk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=dcH+Et1y;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=NM1Lw168;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf14.hostedemail.com: domain of pankaj.patil@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pankaj.patil@oss.qualcomm.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LFAI7M2011980
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:14:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=+sC0Yvqh8Q5nitoPDOO2xt
	DXj5k7Je/RXYaZIXdOYtg=; b=dcH+Et1yC92Lu5dw7AEjH/U1yXQ6mEHF6MbfJO
	ePttSzU0pXW3tGBgh0USunt9zJbIWlj3bdB5t0Cn98Ns/BgFdhw+YUAC9/UQ9LtS
	sPzLhE4A3NC8i+VRr9SOmn5wmtolZqWZ64HNcKwQfvt8+3GwTRyecnobNZxqoyTE
	Kq4iYbAHg9N66jlxI6xfRt1lZUWRrJG1kwOTEeC56ZQEhe95yokRMwleVnIpHlzp
	4fwRt16x5LK2thprq9Q0h3V9qAV+3FGNVrBVECSgQHLfNTydcB6UMe/qwSxMPiw2
	sFBI1incax2uGm8Mv68+yAvwhxYxcABM9I7tZSfs0C13IXdQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu01d1x2n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:14:45 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2dd53f2b27cso39194045ad.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790003685; x=1790608485; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+sC0Yvqh8Q5nitoPDOO2xtDXj5k7Je/RXYaZIXdOYtg=;
        b=NM1Lw168OZ4QAljHTGibfHiPYYg4zJQA0gLyr7qyoPLPjc5ogm6G2zk8CxKgjEiUiz
         xTd320UQDe/BQVOcvp4coGS3mkmrYuwa6oaJQNmFtZkziISa0MonyZhKXGw0UuSoaEkD
         /omgolW/aTTj3dcu0sTvvy7vBoCQx6nTfVgf3Ue95FrHRbY41OZL9fFpnFRxtfI29Oek
         Lt3GWqzkxvvFcsJXjdZoYgNTDX42bZZxIaYHA+4jdezKxgxaY67NKFJ+DY69Byngj3k7
         OmsvHK6oBIynORiwGz6tCpzqaU+rEDfYpMb8Wp6h8fwFyn2Jcx+zDAdJMxaGP68Qjiv+
         6gSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790003685; x=1790608485;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+sC0Yvqh8Q5nitoPDOO2xtDXj5k7Je/RXYaZIXdOYtg=;
        b=ZECmiReQWOek40XZqOnetyH5F+5nrqgIvwJYpOQF/BE3LLTj4o9rLDLKZK492URLBa
         FoAndsaIcnLvU4paN0SDh/01Mq05ZT1PFYvBJP7HRUZ3Z3TcH9mcIKKM5ghUV0bbOH54
         4fR+IMj3TK6QIfqV+N6k+gmmR9nIQY15GbDVJzAA15abQf5tlFXFW6ltdb0alkmYkxAQ
         es9m6EjDF9bbIcPgN8pZCInjPJvEbF7gb0LFe5JYdLZ84nnykAsb0xYIPW634kPFooDn
         FNMRghtJFDKgzkNZTNNwc02yIRVNZivOwbx55NWbW1jRrw/YRNEQo9Tb1pGR32Tt/Rjv
         IPGg==
X-Forwarded-Encrypted: i=1; AKwUvByDuY17giaVbK0mfrmKjYSt9EIvECUsX1L0ALbLYrrANsI8PS0PygT8o05L0DA6WyRMMI84AHpMDA==@kvack.org
X-Gm-Message-State: AFuF++m45IT/ebiuH3KIrjn+QSviikOap4rZS7aZqHbIAIQtn88L7LgX
	0qLl2rBluvtCTBteLUmWF7uhsgpT/GTo7/OmTYmCArJxi6xKJG3Z4ZYNYqFwUhhsbqyqBbzhAgO
	Q0nnxb9VA9XOWailrYujXveA8JUxtIx56/uvoJNKIaw69Q99BL+bJSA==
X-Gm-Gg: AYBFou1aOy4jGVzhPfoSyoxdKgBt4cMDYyMUmgKPekaGFoOP0cSI2nj0u1XSOESPVtC
	URwIIvcX1APB0UNjv2oMHg5ApIr/XHrCFWOVvltX1aFElRbrN9GM/gp9bQZXHBMQ2B3sg6PqTS4
	w1ocM786z2Nm8LsJwEsIh8+r53/OhM1luhbowq1C0z3HlDhWl242EHQPy3SXWoCftRh3U+/PJiQ
	cjKSqL1SZstnJZjGLCWcr0dIvirWdjJCsDizxvKEcgF1XjDtec4FtFTvHaYkVRhlZcgkNode+B2
	vz8zONMj1KzdpjCN67W208zd5ESKIE+vNW6LKDtoxpbV3TG5vLoLooiXQVWjMZmImPKfTfIHVN2
	vyGYmv8bbMRIHGjBFvxW+WKnuQ4f/a3XMpArT2bvUCZS+LeZT/XQaOs7pBA9tqYS+ar601Mdguc
	bICFNDqS5WJMWbibFH/np/
X-Received: by 2002:a17:902:e741:b0:2c0:a555:80d6 with SMTP id d9443c01a7336-2ddb1aaf260mr174889385ad.2.1790003685034;
        Mon, 21 Sep 2026 08:14:45 -0700 (PDT)
X-Received: by 2002:a17:902:e741:b0:2c0:a555:80d6 with SMTP id d9443c01a7336-2ddb1aaf260mr174888945ad.2.1790003684406;
        Mon, 21 Sep 2026 08:14:44 -0700 (PDT)
Received: from hu-pankpati-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc17ba54dsm35708185ad.54.2026.09.21.08.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 08:14:43 -0700 (PDT)
From: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 20:43:41 +0530
Subject: [PATCH] dma-buf: system_heap: align allocation orders to ARM64
 hugepage sizes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dma_buf_improvement-v1-1-23d82e771dec@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAKRJsWoC/yXM0QqDIBTG8VeRcz2HFRr1KiPC7LidC7WpSRC9+
 2Rd/j74/ickjIQJRnZCxEKJgq9oHgzMR/s3clqroRWtEkOj+Or0vOx2JrfFUNChz1yLQWqUqkd
 poT63iJaOf/U13Y743Ws83yMsOiE3wTnKIyv9s+PRdDBd1w+O3lTQkQAAAA==
X-Change-ID: 20260916-dma_buf_improvement-a095ae567e5f
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Brian Starkey <Brian.Starkey@arm.com>,
        John Stultz <jstultz@google.com>,
        "T.J. Mercier" <tjmercier@google.com>,
        =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Philipp Stanner <phasta@kernel.org>, Juan Yescas <jyescas@google.com>,
        Prakash Gupta <prakash.gupta@oss.qualcomm.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pankaj Patil <pankaj.patil@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790003679; l=3701;
 i=pankaj.patil@oss.qualcomm.com; s=20251121; h=from:subject:message-id;
 bh=aYodpMjhjueRZKnta3cynI3TH/uCot98oWss+KQn/3k=;
 b=+fXkiGBUsgSDeAWL8tAR41f8+8vf5VxpHd5B7u4dqwtqgoHWuab3DmhyN+j3ssNg9tGAgFslE
 FlGWAWAqZ27D0cmreba2JmnHXGa9MWxZGkFmQY4Q8A/GxWgPpu+fdk7
X-Developer-Key: i=pankaj.patil@oss.qualcomm.com; a=ed25519;
 pk=pWpEq/tlX6TaKH1UQolvxjRD+Vdib/sEkb8bH8AL6gc=
X-Proofpoint-ORIG-GUID: FEYCDu-0y9-HZATpCgAkdSncsz_5Z7Ge
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDIyMiBTYWx0ZWRfX+bIIzetYOJ2/
 bjmVHFoVwOwvkG0/6xHLg0vRAH5cJxJlij+Y+lZAr2ATOxwFeEf8YMcVok/RUX0qcAzidMn6IVr
 Vu9QwPz17mxJeDHI44trTBi6M10MTy4=
X-Proofpoint-GUID: FEYCDu-0y9-HZATpCgAkdSncsz_5Z7Ge
X-Authority-Analysis: v=2.4 cv=Ht7jiETS c=1 sm=1 tr=0 ts=6ab149e6 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=EUspDBNiAAAA:8 a=Y-RT13NjMWaHgGG2EaEA:9
 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDIyMiBTYWx0ZWRfX9RDdYg/yYxAv
 BM5ladfFMqQ8c5EgB2mDDmXQcINGXOZvp0Nh+E2ec/itwLjEIAffWJgUkRlggCefDzxkEtF71zI
 TbT1k0pH18CmSEvIH2O2eojAkmQyxJW8tve15AK6sZ3HageRtGt/IF8wA6vqURB5/bCSd8FAxm/
 yhF4aLr5ZGiXYshL6eF0+0iQ7QOxP94w+uKsaxA17ZFyrAwn1+5otnhZw+50QaZVGwWqxML0FSu
 njTYWpo1XrPI/ZpwoAA5Uli7MyiELTIU73MGI09QBxldBXYvUfGGEOto1lWPGNvsLq1F7Oc7laa
 OdH+vVwEIokwnCJIZD+loKL0KrWuWYL4H1filaYRvM0mEIw9kptpuFtrJfHrljOi5u1KLswlIPJ
 JRa+yDrfAQtxw/7/fRtJFWK59NGHFBxNNTDsHa0lwbi9mnMf83Oq37FOkQJgLKupVdKmmiIVu+p
 ebTxgGQ7a9gHDnUJx6w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_05,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 spamscore=0 adultscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210222
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 20C7C100004
X-Stat-Signature: aom7axn53q1xzwkmtbsky948zmpxkxxw
X-HE-Tag: 1790003686-914070
X-HE-Meta: U2FsdGVkX19d+LI5bxUnelOMGU/IxncT+j5OQ3/QoJ9WHVvkI2EsIvtN5dlEgO7EDQIKZzTdhpweLPrp0EfTaVSiqp0eKZTJWZ0gydKWgixW9QOfb+aaf/ikadd9UcMR0+ujorYot/yR37PVuwZdPBkvsBbBjz3zHoLbiAnnJDfCuNBzo11C7H/ldQEcALcF8kQ58z7okIhfa1NLb+SfYrl75NQqAbQjxHQl2zBMxAT2r0aqYe8EbhdU/4lQPdvQUERORlj9ALJQFa2PC+Um42gnNQ/UUvrCrJIXPKqpZ61HY+IJxRUII2M4nEd/qDHjLObH1+v140qQ/4uQOg9mjWoX/AWK4PM2BoK9G0mDiNRofc8bCI8t+9rG/PUsmcrYt7SbRMqYm8spAY0MeLH2hfNkEjK1Xp8mohPzlVkWqG6el7FB8qNt56KDgCasm6iVoPftrGFN6+qpyGC6YjUAtY6ktHCD+XUn2yrkaY7KFxc9enG5nx4RbjH4n+5xxjKkUnd+xRi4gsFpu4BWUvZJHKItoYGGXR+CltrvqMJh8V1qXuygiusMT9iYAI36wvXSZJSK1W1l6K+W0Pfzkq2eR0y+recJdOr3OWvJ65w2dEzWpyJ8LsY+jaOOd8JIZoPs1u+w+X0oYDZ4NT+356NkcDznMjZvc5OWpC06hWJ54V3ofcoOk6Q7sdVib54MoPDw8eLQ5+npYRnG00wBOqf3WOsJBxlUw8dUOdG5ATkQnY/6ESAy6OwHiS77qVUwiBdEdDWD2ZN17aHfT8Gg20xf/ECioQtml6I13L7WOOfN0q7oEIWMzbVMyzKEbNa9/kM27359wuOhjVZsWoyCE/nTATQpRFoeqfd+t6Rzp8J+RFm+HSUPEtXdZx+tHwmyAIuyRabMCgyK8v4lLNABqeTCvTt27Hjhl5zJajUyizXEiR6ull9hCnObpRdsneXAMewI6GduqN3QzdVg+fY8V7F
 yNE1osMo
 wnSom4LVw6m57yeYeDIdXjIbeFXI4BA3fzpu76JPVeTjcjpDlPwaoy0c2IMDF+kL9Foj2v9s5QPwO+EhU1g2ol/vC1jSo23Vd9jdXeGA17cstDEfnlNFVo+dZr7Ea+t5yhofhMGrvfhJCgGjTakDbd3UrU0ueQPiDb1EYjLjb88DbaBmuvRypa/eOk5AUk7gDkPpkFa5nJpi/0Kx9n9NwoTqcmyYvf1g4xW+0I0apoyqOBkQjTWAqdCXsr9pjiaFr8HbtEt1h3ux62sYXkuCb11pRhQycBvp7kWu4SqsKS3ghrYQUKs1vf+6nFs+K+PEI8+R4022w6lCeBDNMer2D45ZQNC0Nq2EfecgpU7jrpj2O0CYkMGl7J8VredgYeZ6ZJuMxMwSeQkafXSoA1BgVdJoW+O6P3VsxMIrfoxS8fjMxnXPu+TySeK1MNf8DWLqZmhCgqRPCxAforBz9EE+aF4vvpBxtK6GzpcfCmsuX8ZlvlwDke+WQnovN6zYTlFuDC1rucsMXTPBZfj7YhDSmJ2gAEJlCEqsfoA3oeA+sSLmIVMMpCAGSP8CtH89d4eCnHQlPTyuV/LyYzd77w59ZS9qHZREKZ1R32MiY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Prakash Gupta <prakash.gupta@oss.qualcomm.com>

System heap currently uses a fixed allocation order, {8, 4, 0} while
requesting pages from the buddy allocator which correspond to 1 MiB,
64 KiB and 4 KiB only on systems using 4 KiB page size.

Extending on patch from Juan [1] for ARM64 targets with LPAE, a 1 MiB
allocation does not correspond to a PMD block size. For a 4 KiB-granule
IOMMU, a 2 MiB allocation can be mapped using a single PMD block entry,
reducing IOMMU TLB pressure by requiring fewer translation entries.

Use allocation orders corresponding to the ARM64 PMD block and
contiguous-PTE sizes for 4 KiB, 16 KiB and 64 KiB page configurations.
ARM64 applicable orders are selected for ARM64 targets with default
orders being used for rest of the architectures.

[1] https://lore.kernel.org/all/20250417201913.2393655-1-jyescas@google.com/

Co-developed-by: Juan Yescas <jyescas@google.com>
Signed-off-by: Juan Yescas <jyescas@google.com>
Co-developed-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
Signed-off-by: Prakash Gupta <prakash.gupta@oss.qualcomm.com>
---
 drivers/dma-buf/heaps/system_heap.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index c8959eadc71d..7a3e26c3dd43 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/pgtable.h>
 #include <linux/scatterlist.h>
+#include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
@@ -57,12 +58,30 @@ struct dma_heap_attachment {
 				| __GFP_COMP)
 static gfp_t order_flags[] = {HIGH_ORDER_GFP, HIGH_ORDER_GFP, LOW_ORDER_GFP};
 /*
- * The selection of the orders used for allocation (1MB, 64K, 4K) is designed
- * to match with the sizes often found in IOMMUs. Using order 4 pages instead
- * of order 0 pages can significantly improve the performance of many IOMMUs
- * by reducing TLB pressure and time spent updating page tables.
+ * For ARM64, allocation orders correspond to the PMD block and CONT PTE
+ * hugepage sizes for each CPU page granule, which also align with the
+ * TLB entry sizes of a 4K-granule IOMMU (arm-smmu, arm-smmu-v3).
+ * Each order = (level_shift - PAGE_SHIFT), derived from:
+ *   PMD_SHIFT      = (PAGE_SHIFT - 3) * 2 + 3
+ *   CONT_PTE_SHIFT = CONFIG_ARM64_CONT_PTE_SHIFT + PAGE_SHIFT
+ *
+ * 4K  CPU (PAGE_SHIFT=12): PMD=2MiB   (21-12=9),  CONT_PTE=64KiB  (16-12=4)
+ * 16K CPU (PAGE_SHIFT=14): PMD=32MiB  (25-14=11), CONT_PTE=2MiB   (21-14=7)
+ * 64K CPU (PAGE_SHIFT=16): PMD=512MiB (29-16=13), CONT_PTE=2MiB   (21-16=5)
+ */
+#if defined(CONFIG_ARM64) && (PAGE_SIZE == SZ_4K)
+static const unsigned int orders[] = {21 - PAGE_SHIFT, 16 - PAGE_SHIFT, 0};
+#elif defined(CONFIG_ARM64) && (PAGE_SIZE == SZ_16K)
+static const unsigned int orders[] = {25 - PAGE_SHIFT, 21 - PAGE_SHIFT, 0};
+#elif defined(CONFIG_ARM64) && (PAGE_SIZE == SZ_64K)
+static const unsigned int orders[] = {29 - PAGE_SHIFT, 21 - PAGE_SHIFT, 0};
+#else
+/* Fallback to default allocation order for non-arm64 architectures
+ * On 4K-page systems, these orders correspond to 1MiB, 64KiB and 4KiB,
+ * matching sizes commonly supported by IOMMUs.
  */
 static const unsigned int orders[] = {8, 4, 0};
+#endif
 #define NUM_ORDERS ARRAY_SIZE(orders)
 
 static int system_heap_set_page_decrypted(struct page *page)

---
base-commit: c2cd463d6ee7d55a3ec0719d93c49ff99022d58f
change-id: 20260916-dma_buf_improvement-a095ae567e5f

Best regards,
-- 
Pankaj Patil <pankaj.patil@oss.qualcomm.com>


