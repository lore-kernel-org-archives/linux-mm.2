Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9A51C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53C96B00A0; Tue,  8 Sep 2026 11:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C101C6B00A1; Tue,  8 Sep 2026 11:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC176B00A1; Tue,  8 Sep 2026 11:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DD766B009F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:57:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 16DCA1A0668
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:52 +0000 (UTC)
X-FDA: 85191050784.24.EB7EC5E
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0479F8000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=H0X9Gg7d;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=vrTwbK9X;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1SagTgITL5NsRvzAQglokC1slbC5Sjoi1TsTJ0PiCE=;
	b=Hyhktt/M2fxvWDX0JW5rYTs3dfEq9AK53pxjuHNHwPO9pfZ2aowVdfjsW0sMggOnnWOKTa
	8RBIVsMqfSRAUgWJtui5tXiqKtjtvS+QwN/HW5ja44YkNMtATP2BUujwziUaXcrTEwtyFX
	jM4qFShuskWfRkofHbZedPmBmk3Zdtk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=H0X9Gg7d;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=vrTwbK9X;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883069;
	b=hoa4c0W6+vJlpzAqrDiDDeo7pY3XJhCrSIjdRvM52OWLY0styOd446AuOttxGFW3arVjw2
	6h+ToTNHsVHFeyqIU5ZCoyBB/G0YxP5qCnsR6uT1R9dkZZ3hxv/J0UqYh43b+mGnPDz7DU
	BUBpUpJZtah+gii2WXWnOIzWY+yowG8=
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688Fbe4F1154516
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:57:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=a1Sa
	gTgITL5NsRvzAQglokC1slbC5Sjoi1TsTJ0PiCE=; b=H0X9Gg7d+NgnDVZ1sJdJ
	YhoeRED5c1/QYDjOyFwx02Xm1hNGpoVNdlNqlTjhc2Riq5/6DGf3nd+oa33l2dx+
	T5NyLuUFBqGGZK1tf8QaXXJKbLUCJvJ7EqbR7bY8qM1gIh2kKzVE9VIFQjknEyvk
	XpYIPxzwCwKBwlPdvpcif8QlPp87S1qU8NayRxTfoNpuaabuTedHjRVJjB5R7LAz
	2DGU7rvnFpWI4kP/rkcb76KAS2mmrkgW4AXG45tmMwVNmGjansQn645jk8mZz6Sr
	v9BgFn5F8Bqjf+94ChbTA4y5DiibtB20WcN42/ZXqicVM9Zbkcxl/P5Q4sp33lHU
	dw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj50j5h1m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:57:47 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c1d137a68so63036281cf.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883066; x=1789487866; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a1SagTgITL5NsRvzAQglokC1slbC5Sjoi1TsTJ0PiCE=;
        b=vrTwbK9XfAWwXYfP3MeFf4tB+lH3O6z4XGHWUKkF8Gr7nBUb7N5YcsangqCuX0CdkV
         wJIn1J6XYjhudElnaVZ5vUgbVVZAJYmgZ3UgV+gwXQmuAv9lMLNMYI9xAdfB01N9ukfH
         TF8Jk3u5vV9FnCIXmz+CHvVgGRppIYKdRFHcRDLj1wG0lseVcKkwODeBTTcb8MQHlF9N
         3s0iqY4bP/uR1YPkoCUqxF27qUD6gjWyQP2NL4TRv9R1jnWrVzusoRPodlgaH/TPq0cm
         YTi5GZXD568VIwut5MINS5VcWsVY0kDxJRLl0cgHzecyQAccEqqjeD+Oo0wzw5tmCQBV
         z5RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883066; x=1789487866;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a1SagTgITL5NsRvzAQglokC1slbC5Sjoi1TsTJ0PiCE=;
        b=olzcF9CQtLb1s6OzuFikdMsthe8fpNIQrxiAS9AfWoNaiSSoD/5ZmqU5leknjK92ZD
         9KUk68prgbGkSIMMm3OVyKK0melKDABbAcsNQld+5YElVtfNNMbjMOScz/t+1YkDWmFT
         wyKgUAb082waHr5f4CEkWgGb77Iz2RmqyLRP84QfLHEPtat/KqFgi5ffOASO8SrXT2zX
         I/VTQ3sD8PeYj7CsP8VRLcJrvilBIbe6HGXi6SvIVbHAX+zqt/XvP9wZr4AhnrSYqOhl
         3NDaJZHSimKbhfY5T17Js+eJpjTlXsJbBhuTQp1WVVnO2RCJh8Op/LpEo0gHVypPEjrx
         yVkA==
X-Forwarded-Encrypted: i=1; AKwUvByBTVutjfuAZZAKNeq4Cn2SEKxzXHZCWp8zoRRLPoT3hf+WI8VPk+Np/CFA2z0p5RQd/LdTMAZ/2w==@kvack.org
X-Gm-Message-State: AFuF++nInu3pozOyGxfk9pesXo0zsGfvCACFrptXeNl7NYcsw8fyxdWx
	6nL+enoMMnvv4p9MWkxIMqOnMcj42w6lkf7jPcrgzH8LjNKiRcumshVpoDm/YiAW1OwMHlIJx1y
	wCCnT1/AkWzN+uR5uA2Z+cM/tj/EEAAy5hkkpt1p7Pw4Oeu22
X-Gm-Gg: AYBFou01gWPYA8odcQwXIhLm1v5SEMOXOLkQwP5hn0/YkNgumjhQded+C63las/ZAJq
	okfyiMXOHPvLFaYPuT7HgIwHezloszSjCLaJ7iuX73oWDsDFBUMym7Kyvd9RO2T5vJIVTnEVG+6
	66oQZEm6dtlFeXupLEcm1AC/P8wo23UGjfFyW+3lOsXXwh7rU/3LiKoH8CoKO12C98cBCn4S9yK
	yCZkDJpOSBvp+1ZeKnZX1NqfrZP8Z0ToupqPb+3yhrMvg+hmxcdG2xy4pgYaMh2XMKT7ycUQRub
	0JGv6Ic7I08Ut8ekB8GyOOG/eBPlHx3ZGCP8FxTCGUEKwE3VbZNcs91+tf4DFSEjOn8qN+O5YBL
	TeYj53zAGlbOnhMv6dH3KfuHwzJF99+zfYa9JrDOwh6GVn4b3
X-Received: by 2002:ac8:5987:0:b0:530:178a:9de8 with SMTP id d75a77b69052e-530547d74e5mr351510401cf.22.1788883066227;
        Tue, 08 Sep 2026 08:57:46 -0700 (PDT)
X-Received: by 2002:ac8:5987:0:b0:530:178a:9de8 with SMTP id d75a77b69052e-530547d74e5mr351509611cf.22.1788883065571;
        Tue, 08 Sep 2026 08:57:45 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:45 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:37 -0400
Subject: [PATCH v2 01/11] mm: memcontrol: take a const folio in
 folio_memcg() and friends
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-1-811e9f443409@columbia.edu>
References: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
In-Reply-To: <20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=8676;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ugnKiN2qF100fvbO6aZoM7EJjqjdGQ9b7nhN8W8O0/M=;
 b=+g0EzX/rIcUaVH8Zv4IsAN/c7ulNBIIEwyCkRhsx2EFbcdwzmWsb2G9SwUbw6+YoxNYAfRbC7
 SvAM1LqY4mNAxiYEXzzRzNdjo8rO7TReAFS/jmUKrvbnENy32ljtI+w
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfXz7P5cvgC3SJ9
 056ce8HU+rpDVXc0paYWxJJfJKIl1r70r7KwbGRjRVmAYEbguLXhGCppxvK+wGBlTJP85YCXxmA
 cGehPTpEGDOzFXOGPtEynD741Dk3IQ19cUWlkEQAGfYjzLA3HvfzBy06W3/d6+dCAaWQw3v7pAq
 Lk0VLN/pPQRHOz6HRZs7XcHsCmzuOE/loDca/wDyQBgGjm1/5+lGtITucJs/YeXgMxgKvwih2zn
 2ng1dMN+cNHp7h3YIgmoDRE0HXPbj7WHDxL/RNhIBFKlBE7aUi7woQIuqx5+hRg46TLn/ZX70Ot
 QDbY4pQKGFSg1lQhZlvyaeptCGTHDNzJ0HjX0st/jbqc40QNbajohTuG1Q6F8fKiGJvQmW3VSdZ
 P+tqXT2b00pn1TKDeal/GCBFBv85GnxDwFdMZI5xAEL3YKUFrOKfSvL82TG2L2JjDp7LvQQzyDk
 kd/9oIpp3mOe0GR+ScQ==
X-Proofpoint-ORIG-GUID: JjV56XjO6ftuCe0y4HYbecFFXOJtiaj0
X-Proofpoint-GUID: JjV56XjO6ftuCe0y4HYbecFFXOJtiaj0
X-Authority-Analysis: v=2.4 cv=O7gJeh9W c=1 sm=1 tr=0 ts=6aa0307b cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=mS-MXv6ntEAvCgPac54A:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfXyG03HiKrYdCu
 ojgzslyX6t3T1HO56n7neZO3gl0eZL+L2UWJT1x+Pdov+QuDjmCNQGNe/bho3PkQBjXvpUxR66X
 R8yHADlGFvSKT1MbclAW3BqaMVDsAiXBJsz4F8nHeHAiSN1JcQ47
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 clxscore=1015 malwarescore=0 bulkscore=10
 adultscore=0 priorityscore=1501 spamscore=0 impostorscore=10
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172
X-Rspam-User: 
X-Stat-Signature: mhz53x49tgqbkg4zfdzxo9yi9tiaqnmz
X-Rspamd-Queue-Id: 0479F8000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1788883068-968714
X-HE-Meta: U2FsdGVkX18bFGRGuQt8sXzHZKBgPaENKBvlutcFuXoPoGRepX/E2/gOPEZiE7Vxsg5k3GBWBoNHDSNiF3hjOHnql701+NpLNHJDdEHLM4TG79BOLiaNhqv7UVKAHU7F+Y8hsCDEf5ZQt6e4Tanzydgyjcqt+qGoXNQjHCls2kLIpcSCQLGrwa6Sxe7rIomBTkp9wX59CDf6u9eGSxDkJBVuU0nuiQUcNunnp9GkexRa5aSrOXPOulVX6U6xeURfUXBIgRm6njX3F1NJqasDV3pScbmHnuQ4BKC4DUSeutLInKrU1kcQuBN82n2m3V1dN1E9VwJX/NWGusGV7ksHW4GOxgQKbdLlSr8wpORSqkEb86xkoaVzdVzw7y8iDuUpHg/IlvsS+yq3OJThn9G6CbOOooblxaASl3GhQO5JQJI+On2hbXZC1LiEpdcCbBkNU3WUYweaA0cbOhjB7BroV+vBihxooqgiv8MLiZnge1cC2igDQuppy5LRqfo0hE5g+pYI+xszRpr0wLBiHLpa8k6qVWCZtduQd/jSif4tHJ9Zq7mxhoa1Yp1BMVXuZGOi/Yvz6mZ/Tjd88N4u7aqo18WmdpgSMJNFBrZzwrBI7MKDNSf74lyqPsEbBqbjUjDqRdbWyenjb3/EzVRZWRAtMWsDPlgV5e6qD/BORljejqNE2qf8BaC7VRfSIeyi8Gb+MqpNZw9/v5Cp7GN7tjDKyu1Nu/XjAbVnBkPt7J+dt4sfMKE78ivZlLJtQxSn7B/JeiMIWz8f8V10d8PFaIukqoX8swMuZmOcRL4goUf8bgGJrfQ7TkH1IVy4y5BPPUrom5Dw6zgBsZYUQdQT824TCfkJN0o9kZIohhiZTPzmrgQWBkEYB034kYB1RtPaI0zYO27rXY0QRTHb/eV4RQzuj1jYb7YrA4FO+giBVYATiNlMOcRnN4TeApJwdiQOLJpTlnvRJZ4BfrQ3pGCCf7H
 DvXlSHIf
 WXxd603NWrUFr0JT5DBZYSdmC0kprmSms7eVb12QJco4FqRMxW9er4EvDQUi0ymSg3eIK55g0DeD61pi5Eht60w0lXRm8Y2LpK03KlsBPxx3nCVUEXu/J3+IkTadT5yFJ4950SdKTb7DypkY3Ym+beRXCEjynG0zaGSQhOePmKbcDL9NHvjmb5obpGRkFv6JyzMnkDC4Kt63rDJDRzu63eSwhP4OauI/K9LAi0bg7P1b8sLnAmdd62HCsjk88+nHLzHcQpyZB2jegmYWIHAKjitcO9AdS8p+O5pFqB47mv90w2lEtcAnxvv5+ZsS+VWv7VboHLmYDkbm0+xaMoGX+nrqK6hNZ7QEM/RBQxkFc2/uaTKKEqXtMMGJKx990i3+dVP3GUX6Tu0ldkzlDlr9Ei9C3JYSSwVNlC92BuRpHGlHSVzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The folio_memcg() family only reads from the folio, and everything it
calls already takes a const folio. Constify it, along with the page
wrappers built on top of it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 46 +++++++++++++++++++++++-----------------------
 mm/memcontrol.c            |  6 +++---
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4f720791a31c..8a614a36c05d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -410,7 +410,7 @@ static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
  * or NULL. This function assumes that the folio is known to have a
  * proper object cgroup pointer.
  */
-static inline struct obj_cgroup *folio_objcg(struct folio *folio)
+static inline struct obj_cgroup *folio_objcg(const struct folio *folio)
 {
 	unsigned long memcg_data = folio->memcg_data;
 
@@ -448,7 +448,7 @@ static inline struct obj_cgroup *folio_objcg(struct folio *folio)
  * Note: The caller should hold an rcu read lock or cgroup_mutex to protect
  * memcg associated with a folio from being released.
  */
-static inline struct mem_cgroup *folio_memcg(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg(const struct folio *folio)
 {
 	struct obj_cgroup *objcg = folio_objcg(folio);
 
@@ -461,7 +461,7 @@ static inline struct mem_cgroup *folio_memcg(struct folio *folio)
  *
  * Returns true if folio is charged to a memory cgroup, otherwise returns false.
  */
-static inline bool folio_memcg_charged(struct folio *folio)
+static inline bool folio_memcg_charged(const struct folio *folio)
 {
 	return folio->memcg_data != 0;
 }
@@ -481,7 +481,7 @@ static inline bool folio_memcg_charged(struct folio *folio)
  * A caller should hold an rcu read lock to protect memcg associated with a
  * page from being released.
  */
-static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 {
 	/*
 	 * Because folio->memcg_data might be changed asynchronously
@@ -498,11 +498,11 @@ static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
 	return obj_cgroup_memcg(objcg);
 }
 
-static inline struct mem_cgroup *page_memcg_check(struct page *page)
+static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 {
 	if (PageTail(page))
 		return NULL;
-	return folio_memcg_check((struct folio *)page);
+	return folio_memcg_check((const struct folio *)page);
 }
 
 static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
@@ -527,14 +527,14 @@ static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *ob
  * that the folio has an associated memory cgroup. It's not safe to call
  * this function against some types of folios, e.g. slab folios.
  */
-static inline bool folio_memcg_kmem(struct folio *folio)
+static inline bool folio_memcg_kmem(const struct folio *folio)
 {
 	VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
 	VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
 	return folio->memcg_data & MEMCG_DATA_KMEM;
 }
 
-static inline bool PageMemcgKmem(struct page *page)
+static inline bool PageMemcgKmem(const struct page *page)
 {
 	return folio_memcg_kmem(page_folio(page));
 }
@@ -777,7 +777,7 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
 
 struct mem_cgroup *get_mem_cgroup_from_current(void);
 
-struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio);
+struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio);
 
 struct lruvec *folio_lruvec_lock(struct folio *folio);
 struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
@@ -905,8 +905,8 @@ static inline bool mm_match_cgroup(struct mm_struct *mm,
 	return match;
 }
 
-struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio);
-ino_t page_cgroup_ino(struct page *page);
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(const struct folio *folio);
+ino_t page_cgroup_ino(const struct page *page);
 
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 {
@@ -956,7 +956,7 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
 
-static inline void mod_memcg_page_state(struct page *page,
+static inline void mod_memcg_page_state(const struct page *page,
 					enum memcg_stat_item idx, int val)
 {
 	struct mem_cgroup *memcg;
@@ -990,7 +990,7 @@ void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
 void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			unsigned long count);
 
-static inline void count_memcg_folio_events(struct folio *folio,
+static inline void count_memcg_folio_events(const struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
 	struct mem_cgroup *memcg;
@@ -1084,22 +1084,22 @@ static inline struct mem_cgroup *obj_cgroup_memcg(struct obj_cgroup *objcg)
 
 #define root_mem_cgroup		(NULL)
 
-static inline struct mem_cgroup *folio_memcg(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg(const struct folio *folio)
 {
 	return NULL;
 }
 
-static inline bool folio_memcg_charged(struct folio *folio)
+static inline bool folio_memcg_charged(const struct folio *folio)
 {
 	return false;
 }
 
-static inline struct mem_cgroup *folio_memcg_check(struct folio *folio)
+static inline struct mem_cgroup *folio_memcg_check(const struct folio *folio)
 {
 	return NULL;
 }
 
-static inline struct mem_cgroup *page_memcg_check(struct page *page)
+static inline struct mem_cgroup *page_memcg_check(const struct page *page)
 {
 	return NULL;
 }
@@ -1109,12 +1109,12 @@ static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *ob
 	return NULL;
 }
 
-static inline bool folio_memcg_kmem(struct folio *folio)
+static inline bool folio_memcg_kmem(const struct folio *folio)
 {
 	return false;
 }
 
-static inline bool PageMemcgKmem(struct page *page)
+static inline bool PageMemcgKmem(const struct page *page)
 {
 	return false;
 }
@@ -1248,7 +1248,7 @@ static inline struct mem_cgroup *get_mem_cgroup_from_current(void)
 	return NULL;
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+static inline struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio)
 {
 	return NULL;
 }
@@ -1406,7 +1406,7 @@ static inline void mod_memcg_state(struct mem_cgroup *memcg,
 {
 }
 
-static inline void mod_memcg_page_state(struct page *page,
+static inline void mod_memcg_page_state(const struct page *page,
 					enum memcg_stat_item idx, int val)
 {
 }
@@ -1471,7 +1471,7 @@ static inline void count_memcg_events(struct mem_cgroup *memcg,
 {
 }
 
-static inline void count_memcg_folio_events(struct folio *folio,
+static inline void count_memcg_folio_events(const struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
 }
@@ -1901,7 +1901,7 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
 {
 }
 
-static inline ino_t page_cgroup_ino(struct page *page)
+static inline ino_t page_cgroup_ino(const struct page *page)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 307203301a2a..1ad7de092611 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -332,7 +332,7 @@ EXPORT_SYMBOL(memcg_bpf_enabled_key);
  * If memcg is bound to a traditional hierarchy, the css of root_mem_cgroup
  * is returned.
  */
-struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio)
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 
@@ -357,7 +357,7 @@ struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio)
  * after page_cgroup_ino() returns, so it only should be used by callers that
  * do not care (such as procfs interfaces).
  */
-ino_t page_cgroup_ino(struct page *page)
+ino_t page_cgroup_ino(const struct page *page)
 {
 	struct mem_cgroup *memcg;
 	unsigned long ino = 0;
@@ -1242,7 +1242,7 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
  *
  * See folio_memcg() for folio->objcg/memcg binding rules.
  */
-struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
+struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio)
 {
 	struct mem_cgroup *memcg;
 

-- 
2.39.5


