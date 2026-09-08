Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FDBC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17626B00A5; Tue,  8 Sep 2026 11:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7A4B6B00A6; Tue,  8 Sep 2026 11:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1F516B00A7; Tue,  8 Sep 2026 11:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FE196B00A5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:57:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B77DA07AA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:58 +0000 (UTC)
X-FDA: 85191051036.13.88E63AA
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id EC2861C0007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:57:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=sWPgyd4k;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="pb/4UAfb";
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883076;
	b=CjG1QP7UpN7deaZD15sI067qHUjSEAaoXdukrftHzPFbl2D2rbK37ca8JdaQg5Xj6dolRY
	dukPaZOLhfQJYf+HGUA46TmzMKRfjkvsVEcGOtt57fGiqoXtmEdPfc3SxKEhqk9GRZewEM
	ILq+LCibhgv6A50ahMlOuXu6OocYCS4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=sWPgyd4k;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="pb/4UAfb";
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxtD+AQL002KfnnDsmRr+07OlI5SPZR1PCTXeAbvZWM=;
	b=6nVMQVVz/QEC3ltX5yrHM20Zy1IOGEBqVrM53ox8PVr/7NmLTmADoRwvUXf9LUu/M1ABQX
	Aomd6GE/gaRPL+vYDfI6sjEQ+92g78ojauAZlNq4CikhuuMZezHgDRub/2TH4tmPHgEQC2
	6oID0ffMDkmuNPLbryaq81cLHWdMqRs=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688FbTfw1065264
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:57:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=SxtD
	+AQL002KfnnDsmRr+07OlI5SPZR1PCTXeAbvZWM=; b=sWPgyd4kPNiYtY26W90P
	qYzZMBmjKfERC8GP8MEI+KU/9IAvN/2/7fAkKxvwb4eZLXY5bxazu5SnKiB2hOqf
	W/uVN4poCvg/Cl0EpaUuzJjmkPBltVMZot7yuXqHFCDBWBf8WZSSSOzVcAw4LJSl
	Qf24SrfzC60zPlewBKKh62WiueCKH58K5xwFBZFZpGWRo/KCRxOkz7KEsk14pw+1
	AA1coU29U+jptJ/YLzlcTKjV6BxDTQ9WoYlT8xhFIwgMnmYXNWS9tnO9g2oa6B2+
	2hGpDC7lyFLlblFiMqAPmL9LqgDsI6iQx2MxC3fcwPXgKgHIQdKmTyC3GlAKPUbs
	Hg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjmwm8bqx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:57:54 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52d33c89a29so106161371cf.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788883073; x=1789487873; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SxtD+AQL002KfnnDsmRr+07OlI5SPZR1PCTXeAbvZWM=;
        b=pb/4UAfbSnBF+pPt3phwf8+jDZCEikjIJrjZ9Ubb9x2x9SP1uBf2ihh9+GQrie9ciJ
         Ge6GzqRXvlqtn9Pzi4IVQGwnEPLgBnTZmKtnsVG91QGI9XRvXgyq6TQ5dH+SltQvktbZ
         Vk9YnMk/hsnYJNlWbhPPm2PNP+Mt8BN9iEDtX+2w0aH9CxiQdnVlDMOqaUmSHgJyasaa
         iAiaECx3G8gXLG2AMIqhCteOsz75/WrNluWU+BfjcLF83qVTFOsNUabK52a4lW7inAHE
         pjRbp2+jx+jmjuHnT3ZC/Jc4I1rAF8nvyC8+zXqzn4KCI3MbWIrdifdFGoehzLRZPfpK
         AVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883073; x=1789487873;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SxtD+AQL002KfnnDsmRr+07OlI5SPZR1PCTXeAbvZWM=;
        b=Lrb0woFnCgS2E/3rn17DkDQS6xhK3I2il7UCJxtPt7TmoO6rwnblck5NLTQNCcmFC2
         f0Yzesu5qPSOzZFmF4yJP5lM+r26vFbS+F+XKZeI++wFOAdrV3PnVSEdjqiYLy1Me4iZ
         pgZgImLo6HQx2ayKtTW4aF5ZU1p22UAV4mP4qE55iinVF8ki5EgnAyy/P+KLXouKTfri
         UAk6kwADSVzVx30OtYVOTChiI0WnLE5JC88gVXaPZQqKlyErvtpKPSMaZoW5zdjANMa+
         YBK2olRyaEKOsekqtR1p1FmQtPxZhVEmxNpZahag5XGzmW7qAuWGe7VQ8i0s/8+0ZlNR
         tRzg==
X-Forwarded-Encrypted: i=1; AKwUvBzKyeVzu9QU63kFEwtWbuvCTCCm0m/UqgxPYDX9TpVb8ULhOR9OKhrgvOZm85zmL7vdSW9ekS5Gsw==@kvack.org
X-Gm-Message-State: AFuF++ny6cczKdM4Hl2GoHlxd2290prVRHX0l/ikyYHwTKAYejKmcG1N
	AW8q3K6sTXMfdVRFnDSppAgjz2SesNL5lejK5vbdn+j/7+d68a15hZ3/J66ObIL5qesLvpek057
	O2NrFxAhW8UG1AJ27jyYdXdtsPH+Hi+aXIR62nTnGyTVcmg/k
X-Gm-Gg: AYBFou2y8aVk7qXpSlqDpO8C3sAqhe3D9Si4RbCOCnlQg8RxAQP9jBQnjjC09D51Gmd
	d1G8RKjGPDmJ3QJ5EzsqDD9i91XTkklCqtGFGWn3TsjMQyQp5t0L2s50Hvprlq+vuRs55pZQ3Vg
	mP4/yuTT0fnFoykUCAY8VjVNGOmNEwIgOGDwEMDHwRy3ZcTB0MIP59qBSG6gZgOAZQxU42QiY5G
	qCHpJKnnwI9H9VtgYe35mKBRXNeZaVDMBPevRKMPnnr+ccOzEqRigs3Wee/XhYWhZuHP8EXkAHe
	NcZSQ3h7qBCOHSH3eoQuoAR8VdvbV2eXkQzf4P1NlsAIsOxvbwfwiYzTotD5uqYDY2hnWj14MAk
	ysVohv35h+GkeFnjPalCXt/7VFlQr9eo9etYt1vrPqsRlClMc
X-Received: by 2002:a05:622a:40d:b0:52f:f5f4:e9b6 with SMTP id d75a77b69052e-53054858afemr325153091cf.20.1788883073621;
        Tue, 08 Sep 2026 08:57:53 -0700 (PDT)
X-Received: by 2002:a05:622a:40d:b0:52f:f5f4:e9b6 with SMTP id d75a77b69052e-53054858afemr325152371cf.20.1788883073013;
        Tue, 08 Sep 2026 08:57:53 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53093295584sm27830461cf.13.2026.09.08.08.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:57:52 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:57:43 -0400
Subject: [PATCH v2 07/11] mm: memcontrol: constify the reclaim protection
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_memcg-const-v2-7-811e9f443409@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788883062; l=3509;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=kvV44+aJCJM4fB77OGbPL56etuSFfl3a0wSY86ZeaTk=;
 b=ov3vX3rCMKxxUOA2NgB6If66E7ZEX7qrXVJ7T9lPrHGCKzDrZ99uuX/zCq3mtNsOMWHbjtwLC
 0waWXjMDTixBaKrxfaHAOjhASiV3wuC4Fo7O+xEpwx4PJkMcedwF4Ba
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfXyvDCthfcbLjn
 t8PPZTgLOc+GX5KX8lOOcnKXwDfuxfkIKLh+PIjR/5YgkENtgY5deHi4l9cIM0vyOYCbUSJsEac
 LlRHe0yJAZN7lE/OBhExl5dwgYwSu0mErHvCiuoF/3ErZfvV/Q8OaM2D4ayLGZ5+kObmEcGJmi4
 jM60n6+0xq2psrL/4EeF3LZ211uwZsTqMDG771Cv9AzodiCdfxG4GxjbJymcyWXDIq52kIVbFev
 5kW6kpzV9HaYfcBjty2nChfm9HDw8QSAz0ms7203ABgyKc3ohTBGVcHZQl5Cl+0FXSIggWzll8m
 Cau3n2IhTwBnx0Ys6lHi50A9NcOXpFDqcF7uZbsO43CTZ8lqNzzdzmDwPDaKRiDuJlNb767Ad65
 NvPKqnb3FvuOQ+1rE/JSYAFgOyObW0M+oP5aijksZU6GoJ53xZoFFY2GEVyf1YU220yxkLnhvN+
 0/MOWSUV5O8ITNjr1oQ==
X-Proofpoint-ORIG-GUID: aoen2O0Jx1UiDsUgUsoF8dADXkSvSwqO
X-Proofpoint-GUID: aoen2O0Jx1UiDsUgUsoF8dADXkSvSwqO
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE3MiBTYWx0ZWRfXyPSqTiHXLHaU
 6lzIom7/28ii11JZq9fcB3iQQL04mthGULMzsubkSdqskqShg2YuS4SQQ7Jj3dgaHNc0DcxpisS
 qgdIYs4GbHUNaffJxnJ1E3sdiV2U2Kr+BDhJoYOp3orRCNF9QF2H
X-Authority-Analysis: v=2.4 cv=JPELdcKb c=1 sm=1 tr=0 ts=6aa03082 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=daxEQBKrgOSOeia-9noA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11900
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 adultscore=0 lowpriorityscore=10 spamscore=0
 priorityscore=1501 bulkscore=10 impostorscore=10 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080172
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EC2861C0007
X-Stat-Signature: 3wq3a5oaiawepjz36scurj4whxte6qpm
X-Rspam-User: 
X-HE-Tag: 1788883075-559165
X-HE-Meta: U2FsdGVkX19x2EGKFo5NKfahW9Mw6QtcoqUoYOQkCI4hqGWneuG6fdNVMbFb5c96Rb2yxahEDoyjuvsqXtbOJn9p8ylVvyJx9EBJFjBmFHoESN6h9Ffj+J4WuSOnJLN0ZB1dZkajzOUpnRmL0QG2yKpElejJ521ywb2FMrwcU20x8k6vUrofV0h9PTJA+FtPx1hYbZwkjfkVsxRz7mO+MTM3kYOBk3gDWdrroDrsokLsT91TqrIxZOuU09kQh64nuj2KsRmDnz7my/KCQl878VFMMkta0iL3yRJcM9KZZFVSerfglugqBCXJ5PasAOFvwZ28y3vRC859dwyjtvs40l4IxJWn3N1PXz6nOH0lVe/+fgiZqqAbMefaBbqdtKwyfzRik7luxkY3jOxAYzOlFudhiTGcKOoV8MLF+NPtrfk5q4GFmmzqvBSY8cZlUanQ5cjQCYYITMg4NOlmnA5n/3rwFE3aaaa3v3CNeRzBaJ7AU0hbZ62R5AYPDREIDyIBePwJX+BhFWTkintsTFZOHy4ALxtN9ePMYcbCV/iX0GaE6msF0v/A2VOTrxkWEdMnVp1l4TNGUpI2I8JPStpCaPVj4ZaL9UOEC3lLg0X6SddmS19AbGku1I2Los5E/bJj7M5rcP3d5dEQTo040CpMKmBEFMb9pwrbiFHK8h+UlrmLopUxc/1S5Nd2TR39fHkrEa7Xci9YLaWEgTecph/QfxE7SJm1YGtleCJKD2Ti7Ts98UwwH1Mr0IFjs1iJD2HyvTTxpLk+wQ3I4x9MU/iwUo0K6izPrz8M+0GXuB5pyqi7NheGeJlezOEgjmCY05hR4RDeqj9jXW0//GCN8I5W/9UYfCjUVse7WelutU4mhxqGN8a1aWLm7xZx8cJK8e6gPnoIYlc9Qmr86X74pZNE6vmiap8BBgxwy0gZtVVq1d2rKPsnlMp/GTQijz1gQu8/TN8yluI0XgBO7V3owiF
 yJN0V5c4
 Pc3N4CV79Ud+aMvJNlkVcSCS0Nx5RjN4QLTXAhUI7ip5uyrVJ6G+0z5eIrQ/IkJmsVOZqTXNvoOV9NeMyfxFoLKLdYqyy0xR4XXVph/OGbaJAI7lDNMQ0w49u2k2uuJpsj+xmgzAYVdkkexypPGmy8NVKUWlc8P9AWVqy3Z3JvJ9wLoWKdclmz6HRVtPbeTic4GqN1S001iuPzEP0Ar+io87WJoEFD0M/FvZlftsfV13PR2Mn5rxaOKSe7LuzzZ22vSk8/EPtQmmg8tsXfwKJQNtS711ImUy5kjBEyodd7LgkbYB/vPH1sKw12ZgE5IW9j3ZjZiB3byR1Z9n8lmMY7Ui6JetbmNxHtWQo9GqOeFtdMPPEdprlHYz4cG8TPWPrctzD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mem_cgroup_protection(), mem_cgroup_unprotected(),
mem_cgroup_below_low(), and mem_cgroup_below_min() only read the
protection state. Constify them.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c434a567bf57..f04d2b2b47e7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -570,8 +570,8 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -625,8 +625,8 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 				     struct mem_cgroup *memcg);
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	/*
 	 * The root memcg doesn't account charges, and doesn't support
@@ -637,8 +637,8 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 		memcg == target;
 }
 
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -647,8 +647,8 @@ static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
 		page_counter_read(&memcg->memory);
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
@@ -1149,8 +1149,8 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
 {
 }
 
-static inline void mem_cgroup_protection(struct mem_cgroup *root,
-					 struct mem_cgroup *memcg,
+static inline void mem_cgroup_protection(const struct mem_cgroup *root,
+					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
 					 unsigned long *low,
 					 unsigned long *usage)
@@ -1163,19 +1163,19 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 {
 }
 
-static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
-					  struct mem_cgroup *memcg)
+static inline bool mem_cgroup_unprotected(const struct mem_cgroup *target,
+					  const struct mem_cgroup *memcg)
 {
 	return true;
 }
-static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_low(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }
 
-static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+static inline bool mem_cgroup_below_min(const struct mem_cgroup *target,
+					const struct mem_cgroup *memcg)
 {
 	return false;
 }

-- 
2.39.5


