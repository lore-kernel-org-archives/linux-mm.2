Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C76DC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657826B0095; Tue, 15 Sep 2026 19:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62ED36B0096; Tue, 15 Sep 2026 19:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8176B0098; Tue, 15 Sep 2026 19:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23E086B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05281160503
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:34 +0000 (UTC)
X-FDA: 85217568030.10.7EBB045
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5269B20003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=fr8WCK0j;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=K5V0mCps;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789514432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xI8O6nUTdr8vwkC89YCiv/sTDb7PohQILvZ2tXdjQQ8=;
	b=Vlc/6eoZuCX0ecV6bBELCbyH0HzRgBK7eS3M1Rm6Ar6RA3MyAqchRQKIdiOohBsOQn0o2B
	oNwauFyVw/WjiP8EVuIYUfPj3QWHbEHsPeIWx3BE/BE89NbRhBrNDMESfcidMXj3bjdQj4
	lTwh7183aNIGnuI2RDgFrP9Tpdh6ReU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789514432;
	b=QQBigITwQZd0aM77+mbGN3+PiBDJl5asrtUQeacm3MJMAj191nMQDp09UATj8JPDL97SC2
	+Xxz0JvLjvyloAHBKArS3bT8MxxX27uyQcxRFqNzit7h0EpvMOx96aonz7ir1D4NwT05vH
	btoGjJNKiRuhPd3y0/bPrPu9jrDsSAA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=fr8WCK0j;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=K5V0mCps;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMdBxj2695438
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=xI8O
	6nUTdr8vwkC89YCiv/sTDb7PohQILvZ2tXdjQQ8=; b=fr8WCK0j0BHJre1/OWYc
	k5BDY+cpsNa2PQwGj9KsK9N7d0k32tcZueGCtDIq/Rank22cYs+usAlylHDOYvQb
	+kOK3USJNUZapFNdcIevYYedCV2jOsHR2R5UHQ21I2reof8c5hxEZp6RRr2LADYm
	W9CNbaMXkPXGuVwFyre9saYk4PNoNhpzvZ7EbGT1ApZqziM8RBlfSUhu8bDSgku6
	Cp63F9erILoQAlIxsGHRLXgKL3bxtLRivH9MM73b2VuOKcmT/S1Edgo5CpSgurrs
	sNDMwTYePbHISEo87rrduWZYOBeaqNbJrkrWgNjH1/U2BAv9agZBSjXBm5pDay6a
	cw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gq9n5uj49-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:30 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93a183a0e93so584074185a.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514430; x=1790119230; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xI8O6nUTdr8vwkC89YCiv/sTDb7PohQILvZ2tXdjQQ8=;
        b=K5V0mCpsJAl3unLrh2bGlSKXQG2pUqWcyGORVeDHPT8UqRwavms9f2WT/lVwUWepOA
         5JOMmqXYUD7S+BoHQtlxFFnX6Sx12y6R/YXK3eQimT21YSE+CrFXXWpQvUAV9LlqNXYG
         o6Hgpv0pqhnasokrr8NN+KIRapkt0TQ3OTsarh2JrVjzTq2QtQ5IFfWCqQCW68ig6bpU
         3+2hPxGhzhbnXvpUKJX39lHJ17itei5qGvHJQfdzvcN6hjIjVgoC4bMZGl2t0qXuZBRZ
         h0CaTZMJd43gzmSrq5P/11AcoiS9oKVME8C7LZkVS2APwlKnD7xj1UGFCMIO0FPo5gKo
         SgMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514430; x=1790119230;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xI8O6nUTdr8vwkC89YCiv/sTDb7PohQILvZ2tXdjQQ8=;
        b=bxLBu69yyiTM4jID2/v6JfSXl8kam2Vd65WVORwPa2CfzH3cm2tKzKNPK/VP3tORH5
         X9fEjXDTv6/eRmGidZKuwAMxd7kda4qdUaMZpvC+6ofWLFjgXCt6oflS+3N4AGaJsknm
         4ToKOPYsXA8NnyZKQeHn8sdmr3Pb4fqT/X4Q6RxiFdVsSj9L3/fu+qmqWNSxb16a1eX9
         q3YmeS9eM9N+u1uhXy4n1DTsfiOOLz5VFIQEasy0yZn8S0JmFcZLNolHyveePyb6kfyu
         NZ+DvpS5aYaGJDVtOGkcGq2VTWW0V7LkUnhxJaOMr6TNSMhTx36FU/ELS/1f7V9Rs3Nn
         Jmlg==
X-Forwarded-Encrypted: i=1; AKwUvBz2MYFdxYlsRNcaVN5s2im1TkyePWAvFxOgruobYTX1YEFTw/EzZSCNEbh9+O281NV/kPIjcDtbUg==@kvack.org
X-Gm-Message-State: AFuF++mc0hC6pTyAGHyz765K415RQ7zEsLUgywpFa21G4jW4WHpQW4o8
	jg3hciWDhSVppqyU9lYom29ZI8Fg+LoJWJFRgE1vDWOQTqCIRqsgL4DaimYRlki64UN9PHAl3YQ
	UB9OKBjYAVEEFPNlfZ+d9PP7A6NASbQNQFzR6R+mNax+FFouO
X-Gm-Gg: AYBFou3+87q8H340jl+EyZUYG7SmHXYq6eQXgYfANivgZYX7rpv3C5szIaKKQTAqMT8
	nSxEq/t3bfONsI30X3f7LNxZhEtNYitsTrNI+1Oz4yB2xT9VEf20OKx0biCzkwQFmnDEwl3kxFL
	zmGk4B5rJRP7KqFxqpUGGHJ3YjarkVFiICiYzlQihvZDQSKqaommKjDAGR6BPQKyYqWzqe73gm/
	v2c6T7Y9zZPaxqFctYu5mwRVQ0eYk4g6YQFx9P8g5cq6+ACKkur16lmI3GHp1AhO/5ztDlhjAQJ
	OIKon4DGEZ5o+xAjie3R03uQ0c5TlOBBsbN977lhExE59Nzum37BkMM+Nye7uX9lRMxB7MHIVnJ
	4cV9c5GwMcsV64A9Ayp44juFIv+27RcPz1f6IhVUotqFDXOm7
X-Received: by 2002:a05:620a:462c:b0:915:83f3:780d with SMTP id af79cd13be357-93bb785be63mr61979885a.32.1789514429834;
        Tue, 15 Sep 2026 16:20:29 -0700 (PDT)
X-Received: by 2002:a05:620a:462c:b0:915:83f3:780d with SMTP id af79cd13be357-93bb785be63mr61974785a.32.1789514429367;
        Tue, 15 Sep 2026 16:20:29 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:28 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:20:07 -0400
Subject: [PATCH v3 03/11] mm: memcontrol: constify the lruvec helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-folio_memcg-const-v3-3-c239a6010b58@columbia.edu>
References: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
In-Reply-To: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
        Barry Song <baohua@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=9069;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=QErkJjMmQvmsS88jxAIrE9Ky5O4EbrTfoXBaycDxTEs=;
 b=B32sWF75c3qlH0UPqHe1rOYhPDsSHtgFDH9HH2yVkg3R8Bec/IIENkJk8Ee4OtAVS73mwx9fx
 bJqShL+MhmoBs6F5daqgJnAUlGS0n5d6CdZEhIIS8WR/gpypZaSjmmj
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: VrX4yAZTDzL17fCzmMPkd2JUCCv52CXs
X-Proofpoint-ORIG-GUID: VrX4yAZTDzL17fCzmMPkd2JUCCv52CXs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX7+kNBFkR7g7x
 uqb3v/19W3lOe+DoRY8vh/ybMLcdWyfUlB4YE11mZeFN1RCkiTUhXd95fPie3ULrgKZKiz8ro2w
 uNsHniPxZehU/9Q3F+T3MZvrNo5gd9RUaPOojktLOTWj9UGx0qhKNTsnC9YZqFnW/Ceo06giree
 PuhKGiOsAZDeiL2sLQJtpUO2YQr1+Sb6WZTQzbN4W1M+tkcVgHZ3hSMVuuTRveIVkra3gk5wWPR
 s8KkapVbvWJSo82puOP2MSLeFtWP6Peax26Gho7Dgjh+8QublP8cqweWSh8XZNKWL7rKkKSYwVc
 l37AsCMpOV0UN/q+i7L+tAAnG17Z0XgWxqtJXuon+7M1WBtpELRglpjYJ9DMYj4h7arkYP5dqh3
 3HZANU7EsAMw5uJxCOw/DKOkVC4bY6xv7mtGqXlh9Fhq8Pd41L5CNLQj7+vgcUxvO8khNr6Iksr
 2v7ABiMhQur+QJEdJyA==
X-Authority-Analysis: v=2.4 cv=KZVHIgYD c=1 sm=1 tr=0 ts=6aa9d2be cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=KOoHFShP43Ts9fVHKv0A:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX9TiCiUrgU9+D
 Y867/qJQRQMBgWG/gcqvNdBuf5CJueXuGf6t9oYheRguRburz3x+c95BQDoVYCQSYmeT6wKapfZ
 oTPwAREU1HTU5had8QgVOk9+N6IPY+bxGyPK30EMsAKAvCMMQHAm
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 impostorscore=10 bulkscore=10 clxscore=1015
 phishscore=0 lowpriorityscore=10 adultscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150341
X-Stat-Signature: ttndi7m6785jgpwktuf5eaukocs3fqz7
X-Rspam-User: 
X-Rspamd-Queue-Id: 5269B20003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789514432-691311
X-HE-Meta: U2FsdGVkX1+jHkud76wUQpBizsTK67r0PePi5sQqFLyNZGN5fZ++lQcr7vhbNhqSb7eIBf8tIlliVCMNa5OA5KCkEgK9EsEUaU5XdIZz8ZcOplgXUGIGAxC0PEHByKaw1TSaJlPyEo1Nz1gARvOWoYDqebYTchMsnk9rEEJ/1grlEZSxMfgdj/rrSXqTZ1XztIx9QrXPo5JBMhsIZ3DmSjCjZiMpVbO+NIruFiRg5cm8odgs3S4sAmCT3yEbEV4DAE0w7Sbjpf1jPPhk3AnVbPHoJGBEEJ8UG5fFXqkrbRIGmZ6ccnE2T5p+2X/qaiLoeXeXufGrFryIfCgzgEuX3IceIODYKxPKniyBtWWjg68l17sk9dbX61KvF5+emt4+yq45bamqq8WosCSQ1AWFyLjeeeJfVy+hLK+vAVnW+pbyOXU5CXY93haj8KGsEK0J87sPjcVu1Xsnjw0jsFuBSmj8rTu79NCDWKJH+4rt8KJBOW+X7CaGnZGF9kTmHT9PRxbj3wXBxfnNPaOZSDNOGYYgnvPrcy+hWPpxaaG+/ftnQEZCFi7wTwz1c/i+rDIlzTUEP1qKnkn4nFmbrsQEWBh3IwLDYLa64AePn3g/gRgIi73NC3ahQbhZ34YM4+5X84z+y3Ff+577g7pRjy/eyK5sMp/DUIbIrdn4h5U44KtaeU1PK+6Sdep486jzJQdkETfVnKOGmEo/VDVRk3NGhQESmHAG+aiHhmSfcZXDaaTsB8OZKzDlnEFi3GmRSuDRtmcJFopY1i5CThfzLpBlIYf8ilLeLjC+Y3bYJasFOowgbChCJMeFFxrWMV9bcblUitwoKUumh/GcKs3r7xiEVJM6UUliV181kPfGfdjmDxetbnpBo8imsSKHZllSyI4+pF1/hyUaFhPJsHBW8YceZzoT94NnPmO7DJRtw53eTQ6vIsuIz1IqPjXeLvPlflSPODk1zEFfDB3WrL7SUa8
 DLwIYJy1
 TVdzLMqBXvjz3ItlRs49TXZ2pg9o1meYeTIK7D6oFLwX9r6g6O/axRq6wH6YyQNLeLoRQ4bqGr0bxDrSA+5YJEx9dyaahFGjsdzl915iyD3hWmBUQHzbmFXdarmbOVLeVJ6ncBj5E8jqsXi8KDyg1tIKczr4VpX0e501s6uO++kDk4+Vlhb+Z7QMH+kQOfz2eXR6jgtlykkZGgke/oqsUz6Oz4K4hL5C2vdQADbXLZK88E2NqecyhhGx46th0cI0qBRw/BrcLppzJXsVuJgLeJmZNiqDEWieD7LrBvfbtH1qRq8yCOwD4C7AVQT/r8gWMRc5rlPAaBJ6OdseHAawIZ11yTxdaSei/gTh8FJgJMwsZVKv6afX8HH+7PBVwx9VMIsNF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The lruvec lookup helpers only read from the memcg, folio, or lruvec
they are given. Constify them, along with lruvec_pgdat() and the folio
argument of the folio_lruvec_relock_irq() helpers. mem_cgroup_lruvec()
may update lruvec->pgdat for a newly onlined node, but that lives in
the per-node structure, not the memcg. Similarly, lruvec_pgdat() still
returns a non-const pgdat and does not use container_of_const().

Use container_of_const() in lruvec_memcg() and
mem_cgroup_get_zone_lru_size(), so the const isn't silently cast away.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/memcontrol.h | 46 +++++++++++++++++++++++-----------------------
 include/linux/mmzone.h     |  2 +-
 mm/memcontrol.c            |  6 +++---
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 65cb45f4be32..436934030d79 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -722,7 +722,7 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new);
  * @pgdat combination. This can be the node lruvec, if the memory
  * controller is disabled.
  */
-static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
+static inline struct lruvec *mem_cgroup_lruvec(const struct mem_cgroup *memcg,
 					       struct pglist_data *pgdat)
 {
 	struct mem_cgroup_per_node *mz;
@@ -763,7 +763,7 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
  * their binding is stable if the returned lruvec matches the one the caller has
  * locked. Useful for lock batching.
  */
-static inline struct lruvec *folio_lruvec(struct folio *folio)
+static inline struct lruvec *folio_lruvec(const struct folio *folio)
 {
 	struct mem_cgroup *memcg = folio_memcg(folio);
 
@@ -779,9 +779,9 @@ struct mem_cgroup *get_mem_cgroup_from_current(void);
 
 struct mem_cgroup *get_mem_cgroup_from_folio(const struct folio *folio);
 
-struct lruvec *folio_lruvec_lock(struct folio *folio);
-struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
-struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
+struct lruvec *folio_lruvec_lock(const struct folio *folio);
+struct lruvec *folio_lruvec_lock_irq(const struct folio *folio);
+struct lruvec *folio_lruvec_lock_irqsave(const struct folio *folio,
 						unsigned long *flags);
 
 static inline
@@ -861,14 +861,14 @@ static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 	return mem_cgroup_from_css(seq_css(m));
 }
 
-static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
+static inline struct mem_cgroup *lruvec_memcg(const struct lruvec *lruvec)
 {
-	struct mem_cgroup_per_node *mz;
+	const struct mem_cgroup_per_node *mz;
 
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	mz = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	return mz->memcg;
 }
 
@@ -919,13 +919,13 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		int zid, long nr_pages);
 
 static inline
-unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
+unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
 	long val;
-	struct mem_cgroup_per_node *mz;
+	const struct mem_cgroup_per_node *mz;
 
-	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	mz = container_of_const(lruvec, struct mem_cgroup_per_node, lruvec);
 	val = READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
 	if (WARN_ON_ONCE(val < 0))
 		return 0;
@@ -1215,13 +1215,13 @@ static inline void mem_cgroup_migrate(struct folio *old, struct folio *new)
 {
 }
 
-static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
+static inline struct lruvec *mem_cgroup_lruvec(const struct mem_cgroup *memcg,
 					       struct pglist_data *pgdat)
 {
 	return &pgdat->__lruvec;
 }
 
-static inline struct lruvec *folio_lruvec(struct folio *folio)
+static inline struct lruvec *folio_lruvec(const struct folio *folio)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	return &pgdat->__lruvec;
@@ -1281,7 +1281,7 @@ static inline void mem_cgroup_put(struct mem_cgroup *memcg)
 {
 }
 
-static inline struct lruvec *folio_lruvec_lock(struct folio *folio)
+static inline struct lruvec *folio_lruvec_lock(const struct folio *folio)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
 
@@ -1290,7 +1290,7 @@ static inline struct lruvec *folio_lruvec_lock(struct folio *folio)
 	return &pgdat->__lruvec;
 }
 
-static inline struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
+static inline struct lruvec *folio_lruvec_lock_irq(const struct folio *folio)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
 
@@ -1299,7 +1299,7 @@ static inline struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
 	return &pgdat->__lruvec;
 }
 
-static inline struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
+static inline struct lruvec *folio_lruvec_lock_irqsave(const struct folio *folio,
 		unsigned long *flagsp)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
@@ -1354,7 +1354,7 @@ static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 	return NULL;
 }
 
-static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
+static inline struct mem_cgroup *lruvec_memcg(const struct lruvec *lruvec)
 {
 	return NULL;
 }
@@ -1365,7 +1365,7 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 }
 
 static inline
-unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
+unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
 	return 0;
@@ -1505,7 +1505,7 @@ static inline void mem_cgroup_flush_workqueue(void) { }
 static inline int mem_cgroup_init(void) { return 0; }
 #endif /* CONFIG_MEMCG */
 
-static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
+static inline struct lruvec *parent_lruvec(const struct lruvec *lruvec)
 {
 	struct mem_cgroup *memcg;
 
@@ -1568,15 +1568,15 @@ static inline void lruvec_unlock_irqrestore(struct lruvec *lruvec, unsigned long
 }
 
 /* Test requires a stable folio->memcg binding, see folio_memcg() */
-static inline bool folio_matches_lruvec(struct folio *folio,
-		struct lruvec *lruvec)
+static inline bool folio_matches_lruvec(const struct folio *folio,
+		const struct lruvec *lruvec)
 {
 	return lruvec_pgdat(lruvec) == folio_pgdat(folio) &&
 	       lruvec_memcg(lruvec) == folio_memcg(folio);
 }
 
 /* Don't lock again iff page's lruvec locked */
-static inline struct lruvec *folio_lruvec_relock_irq(struct folio *folio,
+static inline struct lruvec *folio_lruvec_relock_irq(const struct folio *folio,
 		struct lruvec *locked_lruvec)
 {
 	if (locked_lruvec) {
@@ -1590,7 +1590,7 @@ static inline struct lruvec *folio_lruvec_relock_irq(struct folio *folio,
 }
 
 /* Don't lock again iff folio's lruvec locked */
-static inline void folio_lruvec_relock_irqsave(struct folio *folio,
+static inline void folio_lruvec_relock_irqsave(const struct folio *folio,
 		struct lruvec **lruvecp, unsigned long *flags)
 {
 	if (*lruvecp) {
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index f8a2d823f7de..9c9c3119277d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1661,7 +1661,7 @@ extern void init_currently_empty_zone(struct zone *zone, unsigned long start_pfn
 
 extern void lruvec_init(struct lruvec *lruvec);
 
-static inline struct pglist_data *lruvec_pgdat(struct lruvec *lruvec)
+static inline struct pglist_data *lruvec_pgdat(const struct lruvec *lruvec)
 {
 #ifdef CONFIG_MEMCG
 	return lruvec->pgdat;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 54937efa075d..1f660af3bc3a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1463,7 +1463,7 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
  *
  * Return: The lruvec this folio is on with its lock held and rcu read lock held.
  */
-struct lruvec *folio_lruvec_lock(struct folio *folio)
+struct lruvec *folio_lruvec_lock(const struct folio *folio)
 {
 	struct lruvec *lruvec;
 
@@ -1491,7 +1491,7 @@ struct lruvec *folio_lruvec_lock(struct folio *folio)
  * Return: The lruvec this folio is on with its lock held and interrupts
  * disabled and rcu read lock held.
  */
-struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
+struct lruvec *folio_lruvec_lock_irq(const struct folio *folio)
 {
 	struct lruvec *lruvec;
 
@@ -1520,7 +1520,7 @@ struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
  * Return: The lruvec this folio is on with its lock held and interrupts
  * disabled and rcu read lock held.
  */
-struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
+struct lruvec *folio_lruvec_lock_irqsave(const struct folio *folio,
 		unsigned long *flags)
 {
 	struct lruvec *lruvec;

-- 
2.39.5


