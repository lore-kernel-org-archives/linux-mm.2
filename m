Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121EDCD5BAE
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90C46B009D; Wed, 20 May 2026 16:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68486B009E; Wed, 20 May 2026 16:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B45DF6B009F; Wed, 20 May 2026 16:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6D56B009D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C764A02AE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:44 +0000 (UTC)
X-FDA: 84788992008.08.4559BD4
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id EFF5D100003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=R6qzpP2I;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avRQNH2N900diQes/ogN4qxa19bmdOzpQ8cdXUSTkOY=;
	b=wI8GMd1f1+xuVy1mHwI/pW+DsK49XamUf23J6F0LK94hO22+0U8f5m9ljMOzhblr5s+nGP
	yaPdv+H36gMUBJuFZt+HyeSiiDFcAJy4623uw3c19gx4MFyUN5wKYmspgcqnPS8ZDHsDww
	VEat+v6y4NCpAUadpqcofbjkQ6D5f+s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=R6qzpP2I;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310242; a=rsa-sha256;
	cv=none;
	b=8OiJ3ogly1ISQbDggH5BUuxNp1z1ghjBIqQzjuuVrQCj2kGGQ/DPeOZQk3EmiNgUrCmtw4
	jkghWQy6L320SHl5eLPdl3p9m+2RlrzlIEKazsycaG0lyp/89QzoLYkH43kLGNro3/Y7Xg
	D3I+OD245YWltkvL/j6MBOi0imFYHK0=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKNx6X3138398
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=avRQ
	NH2N900diQes/ogN4qxa19bmdOzpQ8cdXUSTkOY=; b=R6qzpP2I6TzJ9toROuZ4
	25CAzSV0QypPvPhnHnRyFZnZ7ztKEuyAJKs24zra5vCMLYILNukkb/Tcsd217DS4
	fggTihPdbZMn+yqz2B2JBLKJEc+41PZdlH++fP5e0SMaxYoHk97ZEfIr41vmfVO5
	XXjqsssgJOCszcemHbfkWa25njREhNk0idIx4DAK/7F/BjCp3GKntlko+aGADs6u
	d6DefmlE/cw97ki7b5pBMrodg54Pz/HR+n/BZYql+ihGX5222U2LgO/KLY7N8m6F
	Up9pgnDgHsAJ2UD7LhXHFKJfSdOfrcpQEVqb5tVXZVQD1a5fjEHWUxupV7ijBmBb
	lA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e9d3hv05d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:41 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-90d175ae52bso1167906685a.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310240; x=1779915040;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=avRQNH2N900diQes/ogN4qxa19bmdOzpQ8cdXUSTkOY=;
        b=HuCHnVa8QSbvEffMhBA4ytetHxNeZjrRdRs/GAEj0jF2bHI44Mp0zaL+CnE0qANwld
         kJ2/AGJr+NWapfb5l1hmyuz+VqfO+gBDa80drJJeSJ0KNrP9hpDph1w4CDMWjdVD+Nkd
         XFvLP9zzAP0blQ1ekg5VHJMJlZdtgDL2nILmK14BceuFhJwq04WXaQFniD+RlGsKS3aE
         t2lz7VQobhROQ0L6PgrlaXxicnymDyjY02brgx41HueXnlFcRDGZrL+BGsH/M7yTftO2
         p3xkRcSMiMoqF7JZonVXCjRWjjS2RRV714Zo9gqZgiZItWb7pqqhXRh9fWcMVb3Ldeg2
         K7fw==
X-Forwarded-Encrypted: i=1; AFNElJ/S5X7LPmR8ldGNf8k0XW3NgiUli5a4Iy9IZcaH9SMu92y+3xZ1f3PW1WJ2TAwopnMBvnqXaJdv5A==@kvack.org
X-Gm-Message-State: AOJu0YxCP7sCVjr6yXK0b+8/93o102BWMhZa04lfNhmQ2HCZvve+jFyp
	vy90k+JchQUI00L16XSLu8a88B8K/jLLMtc4bZ27TB9hiw0DHtzENElNTT7GRQQ8pG++wiRC+qx
	MY7f69T5QvqPlXvKVy7lYteFEXx4DaHnpvHCvktP9UR0OqEPN
X-Gm-Gg: Acq92OG69VaQ8rSjg5FHASoWyhBN2vOmirBSwK84ntuhUecwNfizFJtp4RBo+Oaqg2w
	NGrW9J6A/obL/Mkb3tYtRx/ibSmmWuMs5lKX0h4tcb3RuldWS5wLtW83NlID17DzTwagPO7bvvG
	+UYEAGcvxPLxLcaObqZWUT3UhA4J6jzbHzOvYX+bIQ5FRtj5no7mBTVZ0V76VYD6IzRnlJHgjMX
	nmnG/Hez98l5reJ7hHd/NE6Ux90sgU17B40G1DpbxUIsn/eaDyfZyJffWeMUtanAoRk7d3fwetl
	LkSuxB6QX1bFnQsMEvZ8j5hmZtMY6xhW7ToErh4asKwZphARq11dkpJ8OXnQq2ZqnvPQnTY8N0V
	xpdn7ax7aPjdjSGpjNiFFVZGq4b3Vgp+CMSebb+KjBKSJ8uF4oPBSJAAEcf+H+lxFWjY=
X-Received: by 2002:a05:620a:28c2:b0:909:e4dc:fb32 with SMTP id af79cd13be357-911cdc429b7mr3837076585a.33.1779310240581;
        Wed, 20 May 2026 13:50:40 -0700 (PDT)
X-Received: by 2002:a05:620a:28c2:b0:909:e4dc:fb32 with SMTP id af79cd13be357-911cdc429b7mr3837072885a.33.1779310240054;
        Wed, 20 May 2026 13:50:40 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:39 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:48:59 -0400
Subject: [PATCH RFC 08/11] MAINTAINERS: add folio_wait files to MEMORY
 MANAGEMENT - CORE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-8-c36ddc2b6cf2@columbia.edu>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=850;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=dFyWvW6idGsgNVV3N8U6/Sf1EZqh/O1Nww0zGEVwRg8=;
 b=HPyU6CJCZ8kqU8alpJJp2HCe9isKSiBdanKUUwMFGvy0Q00sMV+3afcEBole6GJFz/iDcpiMr
 llz2jdaNdK3DhYhQLMgNYC2AXXFscR5FYH0b1/6uHxLX4UxQ5UB3BTb
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=fsvsol4f c=1 sm=1 tr=0 ts=6a0e1ea1 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=1-S1nHsFAAAA:8 a=VwQbUJbxAAAA:8 a=hdCJvu6vi-O6ykQZt0QA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=gK44uIRsrOYWoX5St5dO:22
X-Proofpoint-GUID: lQ9xuzcPPAEJoHkOgh7upz5hDCbv09Cs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfXz6yOgAoi5O/F
 73XK0FfoRydJmq44HJT8Y4Yc63APTc1E2alViaYGK0YjPFEz8QRexKw0p1KQJ/84IpDYtzLk8tX
 KAaJmOjhedtXxpy1JIAi6xcYGTE6CiF94inpsDz9fKmytpE7bHfgdbxlRDyBsUTQWNGsJ7g5NzC
 l6pCbBV8/KISNloBqOI1ztS8EC8JsgbCwcjlnwe9vSEz1KH8z82Gy/jtU6W/wBrk0PEePfwIGt8
 9Wy/LVCyBKftEFn36oSqZJZhCCnA5ONY9aSvt0o2KA+2B0IIVFCO07nheKVDA5WnRs2zqvPPO51
 NRGG0331m5UZ0dQv9IUm3xZ1yG3dEsvf2O78Cz9ONZfEuFSN4QvSBXoOo/gqvfMieDMX+gwGEWQ
 CfV5AYKN8yphZQqvU5qpjS8QvImZeuoHcdO1etmrYWA51KfArIKxGJ4pea+pEGhQ0TCeJXnqGbW
 fNbS1tS4wG5ktniN3wQ==
X-Proofpoint-ORIG-GUID: lQ9xuzcPPAEJoHkOgh7upz5hDCbv09Cs
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=10 suspectscore=0 spamscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 impostorscore=10 bulkscore=10
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200203
X-Rspamd-Queue-Id: EFF5D100003
X-Stat-Signature: tigb13bnkatx3i8tiyhk3x9f9y8m49pe
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779310241-519028
X-HE-Meta: U2FsdGVkX1/JsBc8aWgLgShu3G8xck1KG3H3gzUitfy9p1CEdY0kezXpgsIl9MDx8jBVdm5YRErXZk2pORn9IvLQv6Sre/krV5cE6cs/a21jiPd3XY0CtJVZ8tAnWrjj2tSqlGtsOp+qTYZRkzfBCCXYCXXWVb6YzBx/7NSUg1w+THsrBVMAyYrKq/qOg/tVQIOFEydUZI9zbBe+nEbomxmcyJGkHrXP9s0/kMsOk3zqgnchchcDWdZiEZWePY3Y/VV4y5IKkXMD1Xy8RTjWpVsu5gHlPpbu1lvRQ0333xk/yZTVaXvVyVjxeLg3Lg3r19ySsc3arszWDJi1F0kI9RN5GPR+T4REwxveKtMclFBM4899WB/GyLZA6bqnUSllAu6VgCprrKGJD3VbwoPTde8PaRSjwEXGkQFWkKMS+hyVhVNZSg+f8JT1//TXID5alh1UG4y/k7e13lQ+OXYZ0cSdeOLYaUXrCffc4jZUfdcjy+lTkT+8qo5SdBSKAyXTSocZyop62WQLDuXH0m9xd81dVRmcz/D6fNUm0FZ86ery6diVqaJkwI1cya50YatgetF2WshswIHHkzBvZmITUMlqiE4Hu7LCUAxaIZZnqNJcZpX6KlKyyNonhObdYTiRuSvk/g5JTT/bpWMcCzWmC54lIzCsFVy02dZptIwOYQ70yqKkhTrd6KawoWZbaPpdzUqx5NNceXYU6KQdaXze5+GYFD8b8DeUm0mot8iUJy50Cas4rQQ05F7XSwU8bqoNsNHC1F5i2yjc7fA5mcPVzaUis9Lqek0wiTxdVGgIjokidp9YrkCmHcI/spGwknB680biqVHxEfztp4w3/TorjVDYYtM6ckwKfz0GHIB+qP/6fMkjqS6ZvWEbrQN8niCkummSkpopSsXpTuOCaOjPy8V2NK9+lvV+UOLKwBWZkPUfCVnu2w46yuDfHvjEJH8/raPv/+48fGqSiIYKMyy
 dnDvx5+e
 mtt8vE5ZhxXy2GOuzO6VEA/BYEk2LbPf/rcEoMUs5XoIKrFbMphHxVsOPIAQjVWEekQiPu2GdM6XU++ahVU5Me6EjagKcHK3s3LIgbGiOLGCw3a8Hqravpv30y+s9dl8tBevCR6CwZcojM1yuEPBz3eMmtR48sjTBEs8ZdmCQ76I4GJXBcMiqaWdEZ1Lp7AX+rIFnWYmN68woSwGSID741sKQWvH+sRcZdrXksAva1lM5+xFdAaBd8+lsZxQs9OQmHyXjxhHwxA0uopv7xSPFUU27k48e/iUyiMWWDeI8opZ2xZFDGiKQBKyKEgOVmogcAINU8Tmi9jBWNQPsUPfCksqZIxNXM2kpV0LISHDONfNR+zs7LzVCGju3LuYrwrMd1IOmj5Xa5QHB+ezT8Dm5F+RaqnA4k7M8xrwd8G8FhNakKNiZBKWzciybGDReZc/GgcpbQ39yMSfq9UR9QKCHqLjlbwRZoRwKUSR7FzJh29p6I6nUA0hoU1sJBFiwuDvmtgUaAqurdmvzGum22IH724a1BoiXUw/jUkiG1bQnaMAFTeWdXMQD2eRMlV6cNz1+whX7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add mm/folio_wait.c and include/linux/folio_wait.h after they were split
out from mm/filemap.c, mm/page-writeback.c, and include/linux/pagemap.h.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8cf9ba51d981..bfe1488d9030 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16781,6 +16781,7 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	include/linux/folio_batch.h
+F:	include/linux/folio_wait.h
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
 F:	include/linux/highmem.h
@@ -16802,6 +16803,7 @@ F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
 F:	mm/folio-compat.c
+F:	mm/folio_wait.c
 F:	mm/highmem.c
 F:	mm/init-mm.c
 F:	mm/internal.h

-- 
2.39.5


