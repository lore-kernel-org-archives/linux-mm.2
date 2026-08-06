Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D695C5AC7A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668166B007B; Thu,  6 Aug 2026 18:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63CFC6B008A; Thu,  6 Aug 2026 18:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E496B0092; Thu,  6 Aug 2026 18:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 032106B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:57:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 651E51A05DA
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:35 +0000 (UTC)
X-FDA: 85072358070.11.F3ACD34
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5FD654000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Jk1NpEnN;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786057053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4oDNY1ZKVgl9eUi8cR9hOV7SbmDJAyGng1F+GOysSro=;
	b=a8SOSte78eo+h6h9MtEHYmipNJBH+p7CMmMavleJBkpDeP01gNbSLIkAqkCOzDEwJC6sKk
	PqfTEmkAC5tkQpJPdj4/Ds7aGXMEwFQL/4ogvdZg/JYXhddOpJH4HEsTFLuh1k9YG1RK36
	CPcRXkuL5r9mlqrJOpCS9tIjzC57Sl4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786057053;
	b=JqXd9JmiFTGXEBAyox0gf0bKS3oaY4YxwAHLZ+KPVlbpOdr2mgNrUpC+j72uFCofZnUeqr
	uINb5qCEV1/Ums6RYXN1ohy/elfZtNjGPjzAu8N9DnVHiXJKov7ZjfqwDyuCrv/2uo0ZLN
	fH3K5VqygUkQZa1ldBcQqfj6MNP619U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Jk1NpEnN;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676MbIQL916613
	for <linux-mm@kvack.org>; Thu, 6 Aug 2026 18:57:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=4oDNY1ZKVgl9eUi8cR9hOV7Sbm
	DJAyGng1F+GOysSro=; b=Jk1NpEnNjz2pwRRjxwHsGAndgyCE0VgZqK1T2Ur2CW
	O1c9kNIgbVs+o8rAsjR1pw9g/qXk3axWs4AjkisOeT7zYnI6feksCEt4mVWLchTi
	vPCuw8XWPon2Zd3UxyrItQfgQZdjPTM50neDRVT/Irej+izE9AbVTm3jGZNvLbDT
	O9RXdDNyEhCxWkdQkjVaC1TDl2+8cfZ6YIW6dkWzqFppI8IFPGobQtqU5SBUjXfF
	aRjOmsEzTqurRSOCp1eUU6VKq/2Ky6Ag7yyZtVp6ybaq86BV+5XMkNTPRPA/opb1
	E0awN3pY0TqMKa8xPzLh6D4ZlnyysdHLhZiiA2OuxqaA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fvvqrujy3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 06 Aug 2026 18:57:30 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52ce3c7cb2eso41231491cf.3
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 15:57:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786057050; x=1786661850;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4oDNY1ZKVgl9eUi8cR9hOV7SbmDJAyGng1F+GOysSro=;
        b=qSnBR99KGetQ8ZVDKXWdQahuBU9xSB9CD42dnEtRvv/OL+w12JsUbkmVzhyNQyloBs
         ajxGlX9dlBC61wTviSrWSVc06YLZ75WLQhZuyDTH7B+DIKYx7yov+5ewFoQKHPEAqtRv
         PqnMbVb1Y8CHWHwrmHCngX+7GF0HTaXWO0BHhii5c0WOeMqkIeFPgYWzWRWwkiWMMrwc
         tN78wgJm9h5b+Sz1CQuHdgs4Kl3jCEVocb5PRJlgv1an/+FNKCUcaUsuS3SGW/BCXAbK
         Lx10fQmdEGT117oFnmhU8Q/mX0CYfGu7pQdNSEjD+vKkx3aw3RDTJKFCBrMCv/O0BTNT
         xZ3g==
X-Gm-Message-State: AOJu0YwFTSYvfn75J+GUwrvNUNvdqcSCOL+gAfJ0MzS/ntzPUbzMAEcv
	aLLvKI1B/XhQ5pTXW+kQKhlwGOlEdel2rzmqQdYWuOFG3gi3bUzZP0myeTeljGMa2OdnFfg986X
	43KKPA4WvUXeOInUlpCjMo6Ylc+mIz9/9f5T9xronmaByQxq2
X-Gm-Gg: AR+sD10oZJd2ou3EGVdnrMsXJTrXVIGFz6tdnZZB03w7b5IwKC8QfZW3/GH3PX3wPqD
	WToeRA1EyjktGMYtgprM8zyWOs+OxK7jpe/y0IzLYqfm9yBdgOUgkpMrByRSxHXbixuEJTFKIg0
	lSkMTt0/0P6b/ROy+tp8zTKXGGksW+LlEI5fLgSOr+7jhjdjWAeuXS9SUctnQ4tpl9JEF21kpAR
	HjUx7XOAiPCY9P0ZVDods/N1dFAsZT34k9yR7HfsJkCTxp2E42+PeVLGvC7jVnqx2r498xs//pf
	X+iiGk90XX2/Dstb17ek/Efbc5Tb+599kds9rSPOOGx4yPD15HVsRIuEcFdH/xPf89tNPmrvVYA
	BszbMeXIGK7xp
X-Received: by 2002:a05:622a:1484:b0:528:3471:9390 with SMTP id d75a77b69052e-52d0b044ae0mr55800041cf.10.1786057050022;
        Thu, 06 Aug 2026 15:57:30 -0700 (PDT)
X-Received: by 2002:a05:622a:1484:b0:528:3471:9390 with SMTP id d75a77b69052e-52d0b044ae0mr55799731cf.10.1786057049603;
        Thu, 06 Aug 2026 15:57:29 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.78.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b31975sm8751344f8f.33.2026.08.06.15.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 15:57:27 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 0/6] mm/page_io: folio conversion cleanups
Date: Thu, 06 Aug 2026 18:55:32 -0400
Message-Id: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOQQdWoC/yXMywqDQAxA0V+RrA3E9+NXioij0aaII5O2COK/O
 +ryLO7dQdkJK9TBDo7/omIXjygMoH93y8QogzfEFOdUUo4mxbWbuBWLo53FKmZVSUlUGDJDBr5
 bHY+y3c9X81h/5sP99xrBcZy/lBludQAAAA==
X-Change-ID: 20260806-b4-page_io-folios-5980317b0bd5
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786057045; l=1132;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=d9D78s1jwISwBxyaOZacYxeiZRnxXZhM9NcRDvQZXIo=;
 b=JWwKTbplSIhgHijP+GPNRriCUmCVudRcl4AMy6WiV5kh9Kb0hUAKk/9VYjIWdae+TwoJ1+hfj
 dMgCr2taDCjBmvQZrwmTBHig2Up4lc7e3rnnxKz+SlRRpAHqTVMPqKJ
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Mv9iLWae c=1 sm=1 tr=0 ts=6a75115a cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=z9N5oyD7lR4RENIpbqURcg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=d2TyfQZRb0Dxy7BKGjAA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: gTbgcBPyxvQu3x-ScXKfUL-PDaY4P5wW
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfXy+ROz5w8R1Ae
 a/cPaqKAsu2KQDc4mCxDp18yrBacXYtImRFPhQRuH9CLWwKgeRJwHCBP7nybgQ3nqCYwdL/NCfI
 uMIlmJ4UdJlrtKO6AWv61yVZw7hEUnltZZuAsSeOr6si+0XwN+AX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfX8efDTB1TmL6y
 zKKSbZDIzRRIU3aLbmSWl2jz23OKLB/xo62Mb45J6rYWIr6wJfdaQ3vpi024xF3MQqiEUpYZVyM
 VNxnCY9ViD81P6y/VPcJhcbRv4O4E/pfenEGpoKdRaouZMHaujvN9SY+XYCLaogfqEwmhu1KMqr
 B5MV/hMHNR0N5I152ZqP5BVSWT7PQha+3ZNXNLmtMTseFJAL7r/q4gixgJ/OrY/XUb81JwryxSR
 AyqEI55RxDpmGq28p6hh6OmQRoNcapw/wX8gCuu/GWQEYUsD7e/2oEv7yQkDwjJ/MxbMscmbOvj
 u/ipRrjaQk6cQRT7CwJJRAYTbKMheHjin7Dt+dPA0psysnPaxnr6kpNsbcbexlGzwzgy5v9D7Fx
 SvWOJbJHlf5xZHRvPTHjJsCBuqWPS94jrP6kUdZysH8tEC8l5OsQBdFBv7WwAfHTeHVTswF+3Ls
 sx/vvEG7DypxmvbVH0g==
X-Proofpoint-ORIG-GUID: gTbgcBPyxvQu3x-ScXKfUL-PDaY4P5wW
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11867
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 priorityscore=1501 bulkscore=10
 lowpriorityscore=10 malwarescore=0 phishscore=0 spamscore=0 impostorscore=10
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608060180
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: w1h7ag7ni6rmd5wanxpmo9sr834fdysz
X-Rspamd-Queue-Id: 5FD654000A
X-HE-Tag: 1786057052-977206
X-HE-Meta: U2FsdGVkX19b8jBX1+7j/itz/I7zGmw4A2V4Pc9I45P4FVZYHknnRhGq7w7ZrioZB2m7qj9lo1UAYh6et6FpwUj4cCw8ZQNlq2nD8a7BOx1LveQRnc/hmjhFY7exPG/vFmqZ0APxe4a82kFzSaFQCO1KK45JbMr8euX36eB3ulYVhefYpm/BZzoCh6nqttExF/zo1JvL5aReUsWemWO9dzoJJnLb9Z1/EdRTrnBw3L8ISsC1wxoMS+MEOqhOiw4HqwzERgOakrrdYDXmvSgBQc/SRR5btkrtYU7GKM8TxEl0Ye5lG5Fhv+rqueXFVueOyWcU6kPygfZQXi+/Yji+Pwe/rW83eFY6BSbltXQcbHg+pNeff2DTB6I3DYkAqXTmLwZ2Q5dHZRYCayWSvZ+c7eYCm0bCw2vBukoiXcOb9tDWfrnA0QowZYbQ8kbdGvn4SdLXh9f4gOIl7BqlRj9ooboKCxlhxzh4GgsO3Miyc7aB5zRyZAPerTbGlgl+wypHImc8LmSYhsmOaKtVNUi4xye+UIDp6PNCJAqIOblt999g6JyzGlqn5B6fGRQK5iHvX29d9q41+o/q/VRSgii7+Uq8z9g+ohUk4ffd2GE6WRTRMUVRIbB8p9lfgKmQDUtqMygroq1YOF6KnC2e0KG8eQLxuIkBZXOVh5CBl5F+Q1VyLwmXn8SLmWmBekZnyYNKLE8aPkJd8jH0/m3iZckucaf9noNxBvv8qykI1AdgMhpfLacp6/Rvci0J0joIAnoKHxycpUOlGxh1tBP2/1QsvXWenbAYx6PTPLHLlHHAHD1zynxmnwaw00GGct6tbgVDdA6kc4jFtZQ+I3FxexXI7PD4jEoaROzosC9Gi0WHe7SWj4+qAb2Xk5+JOLVQlIKuvY5ZGSbi18izmMhR/73gYo0f5+7cwWrx93cXRDSWthst9+Wj333MVoWkCgDTqYXBAH5l/aUK4nEsXj1mVhf
 BAgy6ya+
 8Hi4cfGSEaLrDla37wE+6KUUiOVA0lwkp8IK+zPoMqAAAx/ApqWduuXkTyTPe8OqFMBsX8hNPK7AGSrtoZi9sU8xfWN9Mzdlm5oYV3scfws5rKkZtruVqLmKtbv+RtRsXSS2JuSxRilLl4Je9DOu8VxzXeupVxLkKPcwR3MTT7NLomQ6shQbq0WQAqQODZ2Oz7c7IoVyp6Bwam1qKC7PI+kAtpJ1jHs7XkOihz7hJmTexLK8X+bH0loA8C9vfMCVrfX0HajHS2wN0S//nTr48h9QB7id0kgbMJEj4f1e5JZwDqvPzkFVyNy6EZWvP+3ZutW0963ueQYDAw1vdi9nLu9pB3ut63IMiTefltW4nxHrLb06do0y4Kz9kF2zWrgUpVlVPfMISc5Nfmr4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the remaining struct page usage in mm/page_io.c to folios. This
removes one of the last callers of end_page_writeback(), along with the
last caller of ClearPageReclaim(). This allows us to remove the
PG_reclaim page accessors entirely. Clean up a few other stale
references to pages throughout while at it.

---
Tal Zussman (6):
      mm/page_io: convert write completion handlers to folios
      mm: remove PageReclaim
      mm/page_io: use swap entries directly in zeromap helpers
      mm/page_io: rename bio_associate_blkg_from_page()
      mm/page_io: refer to folios in swap_writeout() comments
      mm/swap: rename __swap_writepage() to __swap_writeout()

 include/linux/page-flags.h |  4 ++--
 mm/page_io.c               | 38 ++++++++++++++++++++------------------
 mm/swap.h                  |  2 +-
 mm/swapfile.c              |  2 +-
 mm/zswap.c                 |  2 +-
 5 files changed, 25 insertions(+), 23 deletions(-)
---
base-commit: 1fb556c523f6c18b43b1f52fb366f61c9963ce06
change-id: 20260806-b4-page_io-folios-5980317b0bd5

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


