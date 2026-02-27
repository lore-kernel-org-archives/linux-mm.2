Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24931FEFB57
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 14:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14F756B0092; Fri, 27 Feb 2026 09:07:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091E36B0093; Fri, 27 Feb 2026 09:07:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E965D6B0095; Fri, 27 Feb 2026 09:07:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D85156B0092
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:07:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A17CEC250A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:11 +0000 (UTC)
X-FDA: 84490413462.02.EC83ED0
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 50C684000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=azyUuvz2;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ggYSLpRB;
	spf=pass (imf11.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772201229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/M/Mw/VkIMmop6kOgPd/ElQCMlQNXPvBeXbJGToyfE=;
	b=pbQMZEdhFw6O+6leq8wZ10wbzjDx6vgtgHUgxCYVW7sF6UBpdo/8pqEK/aRc4kQ//7/ho9
	pp/J1bJVZctJY42SeP+DJC9diSriqlzjSS8X14coDMvYOQiTtnoBsviUmWibJ7N6XVIKwn
	ZirN8xe1AF07F4N+8NwP7rd/1eH6Mro=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=azyUuvz2;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ggYSLpRB;
	spf=pass (imf11.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772201229; a=rsa-sha256;
	cv=none;
	b=i+NA2JN+zquMQYSO860AvcPut+5IWDbLlTvqM19dWZPhWGfasZ7CXbcIn3QzUkxPyxZnd/
	HMNNxe8JXk2nbWGra9Ofa4p96i9PWHr501eL+AP27SJN6WV0XHB3i9NBwmhD8XiU5nrzj7
	g3rNuaOLPxUonHUU6jqUnImCHMrLUY4=
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61RB4S4j3484276
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=y/M/Mw/VkIM
	mop6kOgPd/ElQCMlQNXPvBeXbJGToyfE=; b=azyUuvz2IKdTpCeERnBMi+mG27W
	GbwNusPYUJBuAMRi7jt23oZKPEppod3GF1AyL726d/GmEuJLXrj4QBq+I7Y+jFAM
	mXJVqJLQ0goLEK8GRPj/8n1YUy4ndj102N1XnE3bthZ1qhH5fNr72BE3wNawuPQ9
	Jiwb9I0BMGS4sTMm3RDmvyvBYEv4M6+tddAfcZ/DwNmDrDlidnH6/jE6YzSaiDNl
	Tc9nN0gJUhuwVW+vbR8lspJHMk7/fpKcwTaNfZDGKYHjoI+lljYERrALXaOZNKKh
	QEKeHYvsRis+SruC9PhXOMFaZmoZQSFwalfp2b9PyqDHrxC+RFeF416hT9A==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cka2xggtn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:07:08 +0000 (GMT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7d4d6edec7eso16545352a34.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772201227; x=1772806027; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y/M/Mw/VkIMmop6kOgPd/ElQCMlQNXPvBeXbJGToyfE=;
        b=ggYSLpRBr7KdmOD1zIvUmz2RZwHZoBCs4oZ1npSof8YzUwdFa4/bc/Soxez6TXYblP
         kKRCIDhbBoPB9lpd4kjT7/hi2t7JhZHR8Rc34espeReX4yfMTr0oBz5WFRIX2w0bGT2O
         Bw5rn0C5HeZP/9FWwCu26TL/caDeMm6onCjQEtnAAaMWuPSEmdyIRy/GM+dMZ2/vePEO
         xoZVH6UznPzXtaJnV/MBDCKC7hO7HRPnMwvwKLjT8MHmje8cD6JWwlSYLWhXTBdFJzCe
         epvQUB4+MYP8+4Zw2SPYGAqzB7bDO+9Mhzr6us+dqH56K26y9FNUW4d7r83hbxzKkNzP
         /gaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772201227; x=1772806027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y/M/Mw/VkIMmop6kOgPd/ElQCMlQNXPvBeXbJGToyfE=;
        b=VFeCWZK84PQ45bVTuyjRboCthgse+thhwUr2VaWGSUKfbJdXheIFiJMxj+huI4mL5J
         Rk3I0VSpZtM8qOZUm6W0WAVdTELGp42cSr4xgL5EHMbB804Tgen17PqfOJeKczthrg/P
         R5KJ+cGXRZlfX/TYjwaoLtWpsDpT0meGGp7L5E32ybu/73f73A3QIlxutqCwZUsbutuR
         mux6UO4bqPso7Tc/bbaue/7eslZ488FqKh4wuPnxYpZt2sacx0khhaeMVfz1i9UZKhgE
         Q1U41ouIZu+9QIJqGskRR9AfVqHU5acVu7Vq3b0nacKAfdTuYkXp7C+ic1QQsKj8kG37
         dtRw==
X-Forwarded-Encrypted: i=1; AJvYcCWlvMN6LsIcsXrIfdhUCJ64BZ3J2heADq1UZjDUorVsvIaT5KSZdNm7nSNK85usDBoR8E6blImy3Q==@kvack.org
X-Gm-Message-State: AOJu0YxELutk5NO2tUNdZONZg0sfBNaCVvrQ/xD99KEUwBwh0KjbShLI
	m5XYE0XwjcrJM7STW6qeRuE80BiHTW0knAlJ08PaooIs8ByiUUgTA+GBz12M5RGUEKQDUZ2fuzT
	GWSbl2hGAsfMqFxENhGvZ1gA+hwMZtQUQ4Fswabq38bWGGdWhYoBUwQ==
X-Gm-Gg: ATEYQzx3rLQYnoOk3/Mr/QIlvgm1QYIGnWrz9V1IJKRbbKwtErSaJ8ijN3vYiIGO7kx
	z6olAHeULDGV/+GyPFYwKuFbIkWFx+qSwleVvvTOm5G6c1fK6eCt4JWX96YwmmxnJRhjjT3UCcR
	upOLMJ8zTQIgUf8GtsnSBAV60ZstwcseXmAphLT5GjFHBft2qhcIMFnPdt2r85g473QdsF+TYRH
	nxDQAtr2OVaKQtNZl50Qdm0UvWoc0gaa4gH0WWsrDqLmkPbAv6diGNDKyEXAtqdYhu4ys+etIto
	3tUnqvpf+z8LlyiAUT+1CFwxWMNns9h9OZBuYQq93PeBUtD6uFvtWBtpZ0EYfFoNUWyj1oGH6zv
	zQOWVBaMAjQ6JOW2Es5Le/xI1DJeZjy3RJtzwSJCNWw5KU/CBvL4JXhvwQ5JRDw4thTFR+CsPeC
	HjG/xZ
X-Received: by 2002:a05:6830:630e:b0:7d4:49a6:d9fc with SMTP id 46e09a7af769-7d591b03f93mr1986609a34.6.1772201227694;
        Fri, 27 Feb 2026 06:07:07 -0800 (PST)
X-Received: by 2002:a05:6830:630e:b0:7d4:49a6:d9fc with SMTP id 46e09a7af769-7d591b03f93mr1986566a34.6.1772201227199;
        Fri, 27 Feb 2026 06:07:07 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d5866269a8sm4324502a34.13.2026.02.27.06.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 06:07:06 -0800 (PST)
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: akpm@linux-foundation.org
Cc: mst@redhat.com, david@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        longli@microsoft.com, jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
        eperezma@redhat.com, lorenzo.stoakes@oracle.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 4/4] page_reporting: change PAGE_REPORTING_DEFAULT_ORDER to -1
Date: Fri, 27 Feb 2026 06:06:55 -0800
Message-Id: <20260227140655.360696-5-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
References: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=BOC+bVQG c=1 sm=1 tr=0 ts=69a1a50c cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=6q7Fjfde3VlTRWJJNBIA:9 a=eYe2g0i6gJ5uXG_o6N4q:22
X-Proofpoint-GUID: rtCuneLJCKDgI9V9ePFmKtcQ-a5YmWog
X-Proofpoint-ORIG-GUID: rtCuneLJCKDgI9V9ePFmKtcQ-a5YmWog
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDEyNSBTYWx0ZWRfX1Myk+dxhPF9J
 N+ShYwx9ve7yaHSvV3KGOJ8+a8V3uTCPkycEMhOwN/sj0v1ErDpZx9C8sxXMQ4FSNVZIlJxhnqu
 2CFs5e+ni/Spa/bMHL3n6JHrnsUMxd0LhJAr/YcnP2oB+8SFfj8B27qGm0IDFxjM4KoCnJoKqKU
 /nFdOG1QW1UIklMT6FxaPUZQwvlWu7SVaAdoK67LvY7IBu3bRt2l3bno+4yrCg7tXa/712weuQB
 DuqW2bDtvIh41D2Da/IxPychyrdIlUBpQYhlZbMSruOoDVtKpMMGD9xpPQqZX71e7xtwYQh4oFk
 QPApqNbaaqB5SOMc4ng4LXLOILLhiDvgpDsrENJAANyGZy7YIl/j/RLHud90gubi7QSAehOfwa9
 qWcDWts6JTrfOrChW5b0bSrsaxHt6UKeWGcBHHAElOxAKj33SfcHNmcbT12lXFaRK0QYBsMQmJA
 zKjjzviQQeBb2JC/uaQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_02,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602270125
X-Rspam-User: 
X-Stat-Signature: 8t7g39i8cip863bnen5sj5aoesyuaeir
X-Rspamd-Queue-Id: 50C684000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1772201229-744359
X-HE-Meta: U2FsdGVkX1/GGWSdvbMxPNR2j7or8pjfAzj2xXZf5eB0iLriqhPiEW4+KozQNO6hGgpwU3I5Y1y0pFsbtfr4vsjIpiwZi4mQQAL98bUhM22WL+3T2kJfLao2bmGyuZRAk3fcb83taE1qxp/n7OUmSYu8vQ+f6W5TwLdZ3A+UIwk6/MzIjoR7okjw8OhuKOKIid704I1pyU3BZaf0Ua/nimcBUg58Dz+Iha4NdbkTLLsOm7dzvIsKcBULzjVi6acSrL/9Pml3i1IgxLUwdJwYHFKS6X6TT7Ix/PkasWmsBIBn+rQf5Vfm4/4Yt9gmhpD7AGpAMFQfkhOZQkPlMPr51Z1kfKJUe/VyGwMTokODzN6ETKRrzzubfaDDL+J8l3jckDWk+Qr5tOpatsKkHUMNE8yQ+R9bqwQfGb72ZbHafIHgBYCx3nuZPYhMOgRYTdi1iekqBsl9HvPF+9AVZ6hMebzK3EjgFWDNeDmrPa3Kg1DftGzZKqoTITNr1PUT1fSZNHbgTvdhV08RyNu9zPtq2/M8t0dDPff4F9smHl806/1ALZpNjEhExi2yG6mOEq2KhVZ3sFMtIOmfdttxr8yYivDuIrW5MRRzlVTwtL7U0DBOcdwKvO2KeWudTpjOWmkLA+JZDGNZsAbsZ6PMKOxTdMJaeUshsoyAmYDZlU6VxJOoI45wwfZ60mDjkzM7ie9Pjeta84SchLSSSdeU9yUwBE4hOZq9elbb3HLOVUOmZoZ2G9w5t7FjIs+nLNgY3m34SqyJTEvpG4AywjgAeNWNI9BkDIXnu8pbACbsuX+r76rNLC2WmN1N19aVHtBlWxVtPlDEg2BsVGuNe4tFLVr9BSj6zSksNFf9pOXvw0/0w3GYR3kig+74lv4X2hvll9sJTGOBl+vwLcHHzozQQ7MKTUYIPr0Q63PxpiKNAw6s5ttTKyMF3GuGdSS4dlu/lrn4fYzlrky3Z7AxTD+yOm8
 WN2ZRTZu
 FMgkvvFmk3eyJZPs1J729++Fpjxmjh091wFyt7tVt1cdTmDeyStrJTyDHRoALQmFOIwVOdLc0WYW60YBYuR94CBsqy9ngCmTz8rz8qm76bTESmX2FxMW0ohHeOoKkifuHrcSebw2placci5Oi7J843/yeGOWOxJ2H+PaIYGT0TNPgOZePwU/20UKW8Fxq+jvRQ2C30+F6BFDkEMCzqHo6ovJhxpjWEB3DYgFYhBus4TQc5WYqIgiAXtoXBquhJAusgYrwyW++GyXoHqfNUmHp6tmT9CVBI7ChDi92m5Ow83bsv7sKaC/Bn/HiW+6n85/kv5aaEJRIVnaJslf9dNkFKUBuMfDCXmfE0skGJtWZ8PCKPKFaVkH+A+vfAJxlyRFs4VWhLvpRper2kO4EyExwVDjzbyQpeZsd7lCXsM4IDJUvCitnLULgf8ZHDLUs6vc/6Q3GBo0jEKeoiFdOf6O4VjWnY/BIHnIVeV/ZqZ9kbf2M8EbNgCHk1B9GjHGSQU3bDzjVy4Lop5vcjjmJc2+e2uWvKZ7poFx5MVLv1/dJ8ys+49bvwdgfEPoQfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PAGE_REPORTING_DEFAULT_ORDER is now set to zero. This means,
pages of order zero cannot be reported to a client/driver -- as zero
is used to signal a fallback to MAX_PAGE_ORDER.

Change PAGE_REPORTING_DEFAULT_ORDER to (-1),
so that zero can be used as a valid order with which pages can
be reported.

Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
---
 include/linux/page_reporting.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index a7e3e30f2..3eb3e26d8 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -7,7 +7,7 @@
 
 /* This value should always be a power of 2, see page_reporting_cycle() */
 #define PAGE_REPORTING_CAPACITY		32
-#define PAGE_REPORTING_DEFAULT_ORDER	0
+#define PAGE_REPORTING_DEFAULT_ORDER	(-1)
 
 struct page_reporting_dev_info {
 	/* function that alters pages to make them "reported" */
-- 
2.34.1


