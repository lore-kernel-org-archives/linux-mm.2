Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 025DAC54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 06:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BEF46B009B; Thu, 30 Jul 2026 02:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56EAA6B009D; Thu, 30 Jul 2026 02:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7FF6B009E; Thu, 30 Jul 2026 02:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7D46B009D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F84940915
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:59:12 +0000 (UTC)
X-FDA: 85044541344.06.5F27394
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7E405140005
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:59:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HKNEeqvR;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785394750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=74HZ01F88KB/oklQrwCAy7hY9ntmF2BEMQHJrOL405s=;
	b=AyMd9PRLNnwsOinPyPRug6LwJsa3EXhOQpJF7wuI21vtsn/V4G4poAvOYqlFjrrI+6XPp8
	9C+SkgwPEzNjR0aMpKt9apecn1dOzTv9QO7KOv/s+3Ag6Yzxrzn+GCyS+zwjWdXNTzPYdg
	nz9GHg/Q2Co4qjOU+ux0FiHWtETX6E0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785394750;
	b=tBO9vSGiXYbAr6q+5/c+syYx+JAuYEq3mC9dgNavKJ47icZagXb84Eoh8s1l4OGlCBy3sB
	5mFooPncIbxcsO2MUb2U1FEo/wc7//eTbphFx3DsJI/10Iu/V4JRC+o4MatthLl674EEQa
	lFp5CIXfoRWfNziHV9TpxtukSgBIdxM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HKNEeqvR;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6ZbSA1849339
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=74HZ
	01F88KB/oklQrwCAy7hY9ntmF2BEMQHJrOL405s=; b=HKNEeqvRLRNt1X/6LcMe
	0tSPW3BkvnqEPRKFomJ/CgXbFb4ZPAGMV2HOF0JGj0RPL2mgPAO3ndg4mnsLdfQf
	Ifzxuhw7K3bPVBqwt9UCWf62YO61G4ZLnrokkiD5smLWKEtDwzKqvSjQe6AiaLso
	s77mjKJQNhYgZt5Itf4NtY3duXQ7HUg6BhTKPzb3mG0JH825HYfQCj7RuN8AN8Nd
	gUpwM0c2KiuEviL6kD2SgcSmv8/OIjj9rK7eX3oPweqyoWcneWoY05hfUU74q0Kc
	HuhLaTG1mTGXaMaRCTEwt11Bqwb+rBqBzRKU7yKlweiqssCeN/UVPkK3sMLpVD6s
	+g==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fqv948yb9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:59:07 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e4f946461so214622485a.2
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394741; x=1785999541;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=74HZ01F88KB/oklQrwCAy7hY9ntmF2BEMQHJrOL405s=;
        b=R5RtTg+e0WlzGP87JPOfZY/JXz0ir/zArML0qNHpGAG5SXAvTDIGQrB/tQYputrOsD
         sgMtsKxHtrsVNndhl/hdWxooqgRzU+53BQlpzXUbsUbM0UvDgJYS/UutTHGrEN6buXwK
         5PmDYmos2aUtmwn/ImFFm5wUOoQOPFE7qNKw2FPbKuAw2eEwGX2g6hXNqENJW+7Czc1a
         1UJzgB5XFK4pZc8B/JZ2jnjsitm+jZCqi709CyeGaj+tkLGR0pLqRUZlui4AzbTPrIzm
         ex7eROQCRGdNKrF4GYii+KbJVhiKV4IIQ6iHjdscymmFsToD9J/mIGg7fY+PmgtJxEVz
         oSMQ==
X-Forwarded-Encrypted: i=1; AHgh+RpqrQUAMhl1ZXgqzzn6fFBc1Mq1EpBpB0aNWMBs+1N1DEjJxg6THn+meuJaTSobHusNFo6oFdcxUg==@kvack.org
X-Gm-Message-State: AOJu0YyP0A/BY84mp+e9fNahoDokJmSEZuYavyLoodqpbfmhsmlUyXDI
	1hXwokifBpA5SPWnYOywgxJl8iUVYHl1o+ogt9hqz9bI+5e0V8rrWx92HXGi9f6qwmnbog7tXJY
	90PplXMyp46/2mqmDyHTiV44bCbngnyD8Q+LJMpl7L4gAJtsz
X-Gm-Gg: AR+sD11V+KL4f4tfg/dVz2nzhnNTYm7039E0PWnHlwKOpm7SdiZX1hwOLhhU2Elt/5R
	3cckRWRI6MguD3T0J868kcvWbPBBUQCXc1JgFQaDmO9hnKJ9JsOS+EmH6ZRheEcKSCNQ7KYZ+zv
	5ik17v+10B+KlVWkkvl8tb9ZykItUFyktC9h/D3f1UHra3jjjcC54SSpgJqngLukAUVVZzzLEj+
	qwxoQZnPEwmLeNqiCk5FSPkbB3Qn+h4J8aI8G3pyQpRaQn5dcnTEXvi6cragPyh57XrY2r5lpg1
	DqBbBmcPC/U9W3EUCFL290RVPOood1HLCbT6TY3+Q+ex8YM0gptWQi/kFQg8IMBGzyOxfIaZaK0
	QFO3RflRVNWylwioTYmtG2fcrAWvmGJvmuqPB0w+BHmafEw==
X-Received: by 2002:a05:620a:1988:b0:92e:7733:e3ac with SMTP id af79cd13be357-93485fbe303mr145369685a.20.1785394740593;
        Wed, 29 Jul 2026 23:59:00 -0700 (PDT)
X-Received: by 2002:a05:620a:1988:b0:92e:7733:e3ac with SMTP id af79cd13be357-93485fbe303mr145367585a.20.1785394740081;
        Wed, 29 Jul 2026 23:59:00 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm349752485a.7.2026.07.29.23.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:58:59 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 30 Jul 2026 02:57:52 -0400
Subject: [PATCH v7 2/5] block: add task-context bio completion
 infrastructure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260730-blk-dontcache-v7-2-3e8e6850068d@columbia.edu>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
In-Reply-To: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785394735; l=7962;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=YrH/DI0wDNjV2YhuSveiemrqulp6QrFTzw6B0mwxX4w=;
 b=kbYbuMhjXn1+05VTQOJx1nfXceANSbqyKVyaSmrfVoPjXZyio2Q4S6pS4ZglHtR5agyOibJ8a
 8FRVk+iY5pzDSRlHRoDycOfdt7M3KogsFwfx4OCm4kkWFT0/CDVPDM3
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX8J1Ba6vqax2h
 iWB50NPVWUm8WmLhN6gwCNCSZ1S6sJmL7GDzf96BbvnFYCWYjdnN/uar3jrCqFHnEhciLojAsD5
 NeJqy1bJZBRGknKKZRYDDQRKINw447ua7PZBdfvt+cH/bQnqxKVl
X-Authority-Analysis: v=2.4 cv=d+HFDxjE c=1 sm=1 tr=0 ts=6a6af63c cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=c6MZQJnkE7hPhdHR2eoA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: iFvfdr8dO1-6U5A7J4W85jZwKW51-W6d
X-Proofpoint-ORIG-GUID: iFvfdr8dO1-6U5A7J4W85jZwKW51-W6d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX+TcE2ZhdiJDC
 jOoBJEJGIT+AJKJI7yZsgOPCNLV+wk0nxnvi1sTwo70bi4colv4wQGDTTqPDD7eEWG3ZLq4+RHy
 1zl3f6SM65QqCLY/hUnhvZqFGha5rUsO9s587xhMBSfA7HuQZXbye22qSjxJb30plLvhWnm7lSQ
 devOpwi5psG+OKddu2tBQ5m5tXhPhUmo/xli/CfkLQ2Fj6Q6DwbxXvTSwTUJNtVbA4EwpCAoiI6
 M6FsyWXRvlZjtOqZsNX48hvc/ZhGUl6WZ+4i7MqNL6J7oKBeTmqgqtE3hsjFRmGDwJh4F0CQY33
 QwAgHKurm+z3sn2O/i5k8Azg+adFXVVoSbplBcKgJIjXV/32mqlH/PaPUpa/3AS5GSI22YIuu2C
 Uh+LWgwtYTiG+u7o+tCPmOPosG7nIxN8bmVco0ozKoEkXH/Oc2gYQ9EBZk/swzEs+IP58w+SIAi
 fM5Pz+MfFbBX3aojl3w==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=10
 clxscore=1015 bulkscore=10 priorityscore=1501 malwarescore=0 impostorscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300048
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7E405140005
X-Stat-Signature: qszjoignon3x7zm34ipzdmpm1ztwe1no
X-Rspam-User: 
X-HE-Tag: 1785394749-827561
X-HE-Meta: U2FsdGVkX187g1zGEJjL1rmivQ2hXJzLfjLF+16E53LAuZv6x5aWyFzJp+315uZ6v1LR66McqJoAyysH3I5gBJb1yR8N3lidx92yxadXlB1xorJxhAD/IS6fNOe0p4AmY7SBF5DjuE+daIysKTGpMZrQ5YJLGDkq4ih8KEFoE/frWEmOCvbZFgMq7UE5ecaeUUMs9eUJAjjK1Rv4qMOJjYe+RV4CyIPgmy1GR+e+6F3soAJx6uuavcEc/FROg+RPStOSuca885fsSnPfWmjUy8V7tb4v+7exV8AS+R2QT5GoSTtGS/ZlmTomecDVA1TaTipP0w1ivl1BcyZOqeVf8G/NR0y29K6oBCyLetmtbpFnyzEDj8X+CJw/fIxaFR0SaNhXEF2XhdyrjqGJJWoAJiNhpU5P1lDbZTSkWuolQgcXvI5TRSNlulUkQPHz7oelfcNpVfOJ0pKxwUtMGIXJY9wIQhd8ut74bYIgaSoAoJMc6OE7TMDo/yWNRt7uiMDm2z7RTfpZFi/U1QQ3ufrPvM6k+ze8g4IEBgUQS4mEK4wuUkFewDsH2V2oTxB9drWUeEeMm7ocKfx+igA49myLoU0yglnqxVvzvPvR8Qfwxgw/XWTv515LrMAy+BF6g/EZQ40UTJ5CamX4xA9rSYxyj8UUeG6DHsEdYD+bNCZOW370jSyUGvN1UFvbzZTtza8s3vVmVnAp7i7u597r0B0TA5Pv+y9Pi/5Wd8P8xIuzJ0zEAChAPcxccwZCRLyAyOBUcTGMCRQ7d/F04AemWkUvT3BJbyF/aEDwE3lXHA6KFlGHtGf7P43H9h3fcT3WCb3nQRBC6PSOzuXDyBvKKswHw815JSMDNaEbmhftZj1ZomaPZjvwcpnX+arE20ReCCw+4v9HQ8SIVdOkEteaIThsOY9JUy6UJeL7Pgeynpnoq0RjGU2TPrMWCCFTAa373OHSgx7imUXDahDqF0/CoTi
 HtGRNVjq
 vn8A+e88m1bgK5QIgljwR/9HN2dh3ngUF1mtPazPdo9amDH538vQyaE8oFu/K0h7syByIU8LCvDvw3K/uYGMu9aIRtj46rxTDhbZ2yWL4JrVo7CIXP6sGVPfR2aetc2SSWncDjPIhALr2qlYxycSBHPwLHSIfXt5nkAGwj6C/ahKdi++4KVP1iny/0uHeevXxfw6HyVRwDj62itUG0smdzpARoF6zFwcV07k82B8ftQu39i4YHJOnWsc1/SJbDYmWzJXZGFWHf3uQ95sDB00wtkB+uV375Acel0AQ6FYreUJKCqTKPQTSsxFQpdnfyt48rezQ9e8J5blPt70AUkg++pDJrl0UyeZ25tm/f7oGV0btqcTxeTa1FkQkCxdc8bNYVHnojELTB5q7s/VZE8jjd4jDg8J6AHRwW6EEFF2Zhsf291iSjOi849xP+ybK/zpmtmsOELRCgtDn5B0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some bio completion handlers need to run from preemptible task context,
but bio_endio() may be called from IRQ context (e.g., buffer_head
writeback). Callers need a way to ensure their callback eventually runs
from a sleepable context. Add infrastructure for that, in two forms:

  1. BIO_COMPLETE_IN_TASK, a bio flag the submitter sets when it knows
     in advance that its callback needs task context (e.g., dropbehind
     writeback). bio_endio() sees the flag and offloads completion to a
     worker automatically.

  2. bio_complete_in_task(), a helper that completion callbacks can
     invoke from within bi_end_io() when the deferral decision is
     dynamic (e.g., fserror reporting).

Both share a per-CPU list drained by a work item on a WQ_PERCPU
workqueue. Producers push the bio onto the local CPU's list and schedule
the work item, which then dispatches each bio's bi_end_io() from task
context.

Both methods are gated on bio_in_atomic(), which returns true in any
context where a sleeping bi_end_io() is unsafe, including
non-preemptible task context.

Two CPU hotplug callbacks are used to drain remaining bios from the
departing CPU's batch, while maintaining the per-CPU behavior. The
CPUHP_AP_ONLINE_DYN callback disables the per-CPU work item while the
CPU is still online, preventing it from running on an unbound worker
later. CPUHP_BP_PREPARE_DYN then drains any bios added between disabling
the work item and CPU offline.

Link: https://lore.kernel.org/all/20260409160243.1008358-1-hch@lst.de/
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/bio.c               | 132 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/bio.h       |  24 +++++++++
 include/linux/blk_types.h |   1 +
 3 files changed, 156 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 6a2f6fc3413e..a9610950325b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1741,6 +1741,61 @@ void bio_check_pages_dirty(struct bio *bio)
 	schedule_work(&bio_dirty_work);
 }
 
+/*
+ * Infrastructure for deferring bio completions to task-context via a per-CPU
+ * workqueue. Triggered either by the BIO_COMPLETE_IN_TASK bio flag (static
+ * decision at submit time) or by calling bio_complete_in_task() from
+ * bi_end_io() (dynamic decision at completion time).
+ */
+
+struct bio_complete_batch {
+	struct bio_list list;
+	struct work_struct work;
+	int cpu;
+};
+
+static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch);
+static struct workqueue_struct *bio_complete_wq;
+
+static void bio_complete_work_fn(struct work_struct *w)
+{
+	struct bio_complete_batch *batch =
+		container_of(w, struct bio_complete_batch, work);
+
+	while (1) {
+		struct bio_list list;
+		struct bio *bio;
+
+		local_irq_disable();
+		list = batch->list;
+		bio_list_init(&batch->list);
+		local_irq_enable();
+
+		if (bio_list_empty(&list))
+			break;
+
+		while ((bio = bio_list_pop(&list)))
+			bio->bi_end_io(bio);
+	}
+}
+
+void __bio_complete_in_task(struct bio *bio)
+{
+	struct bio_complete_batch *batch;
+	unsigned long flags;
+	bool was_empty;
+
+	local_irq_save(flags);
+	batch = this_cpu_ptr(&bio_complete_batch);
+	was_empty = bio_list_empty(&batch->list);
+	bio_list_add(&batch->list, bio);
+	local_irq_restore(flags);
+
+	if (was_empty)
+		queue_work_on(batch->cpu, bio_complete_wq, &batch->work);
+}
+EXPORT_SYMBOL_GPL(__bio_complete_in_task);
+
 static inline bool bio_remaining_done(struct bio *bio)
 {
 	/*
@@ -1815,7 +1870,9 @@ void bio_endio(struct bio *bio)
 	}
 #endif
 
-	if (bio->bi_end_io)
+	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK) && bio_in_atomic())
+		__bio_complete_in_task(bio);
+	else if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
 EXPORT_SYMBOL(bio_endio);
@@ -2001,6 +2058,55 @@ int bioset_init(struct bio_set *bs,
 }
 EXPORT_SYMBOL(bioset_init);
 
+static int bio_complete_batch_cpu_online(unsigned int cpu)
+{
+	struct bio_complete_batch *batch = &per_cpu(bio_complete_batch, cpu);
+
+	enable_work(&batch->work);
+	if (!bio_list_empty(&batch->list))
+		queue_work_on(cpu, bio_complete_wq, &batch->work);
+	return 0;
+}
+
+/*
+ * Disable this CPU's work item so that it cannot run on an unbound worker
+ * after the CPU is offlined.
+ */
+static int bio_complete_batch_cpu_down_prep(unsigned int cpu)
+{
+	disable_work_sync(&per_cpu(bio_complete_batch, cpu).work);
+	return 0;
+}
+
+/*
+ * Drain a dead CPU's deferred bio completions. The CPU is dead and the worker
+ * is canceled so no locking is needed.
+ */
+static int bio_complete_batch_cpu_dead(unsigned int cpu)
+{
+	struct bio_complete_batch *batch =
+		per_cpu_ptr(&bio_complete_batch, cpu);
+	struct bio *bio;
+
+	while ((bio = bio_list_pop(&batch->list)))
+		bio->bi_end_io(bio);
+
+	return 0;
+}
+
+static void __init bio_complete_batch_init(int cpu)
+{
+	struct bio_complete_batch *batch =
+		per_cpu_ptr(&bio_complete_batch, cpu);
+
+	bio_list_init(&batch->list);
+	INIT_WORK(&batch->work, bio_complete_work_fn);
+	batch->cpu = cpu;
+
+	if (!cpu_online(cpu))
+		disable_work_sync(&batch->work);
+}
+
 static int __init init_bio(void)
 {
 	int i;
@@ -2015,6 +2121,30 @@ static int __init init_bio(void)
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	}
 
+	for_each_possible_cpu(i)
+		bio_complete_batch_init(i);
+
+	bio_complete_wq = alloc_workqueue("bio_complete",
+					   WQ_MEM_RECLAIM | WQ_PERCPU, 0);
+	if (!bio_complete_wq)
+		panic("bio: can't allocate bio_complete workqueue\n");
+
+	/*
+	 * bio task-context completion draining on hot-unplugged CPUs:
+	 *
+	 *   1. Stop the per-CPU work item while the CPU is still online, so
+	 *      that it cannot run on an unbound worker later.
+	 *   2. Drain leftover bios added between worker disabling and CPU
+	 *      offlining.
+	 */
+	cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+				  "block/bio:complete:online",
+				  bio_complete_batch_cpu_online,
+				  bio_complete_batch_cpu_down_prep);
+	cpuhp_setup_state_nocalls(CPUHP_BP_PREPARE_DYN,
+				  "block/bio:complete:dead",
+				  NULL, bio_complete_batch_cpu_dead);
+
 	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
 					bio_cpu_dead);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 62a983758e09..a8091a3e9d87 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -383,6 +383,30 @@ static inline bool bio_in_atomic(void)
 	return !preemptible();
 }
 
+void __bio_complete_in_task(struct bio *bio);
+
+/**
+ * bio_complete_in_task - ensure a bio is completed in preemptible task context
+ * @bio: bio to complete
+ *
+ * If called from non-task context, offload the bio completion to a worker
+ * thread and return %true. Else return %false and do nothing.
+ *
+ * Uses BIO_COMPLETE_IN_TASK as a sentinel: if set, the bio was already
+ * deferred and we are running in the worker — return %false so the
+ * callback proceeds instead of re-deferring.
+ */
+static inline bool bio_complete_in_task(struct bio *bio)
+{
+	if (bio_flagged(bio, BIO_COMPLETE_IN_TASK))
+		return false;
+	if (!bio_in_atomic())
+		return false;
+	bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
+	__bio_complete_in_task(bio);
+	return true;
+}
+
 extern void bio_endio(struct bio *);
 
 /**
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..d49d97a050d0 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -322,6 +322,7 @@ enum {
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
+	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
 	BIO_FLAG_LAST
 };
 

-- 
2.39.5


