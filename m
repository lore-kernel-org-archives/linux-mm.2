Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90077C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247B26B008C; Thu, 27 Aug 2026 19:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21EBC6B0092; Thu, 27 Aug 2026 19:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10EBF6B0095; Thu, 27 Aug 2026 19:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC6346B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:31:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5CDAA4020F
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:23 +0000 (UTC)
X-FDA: 85148648046.22.52130E4
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3AE2C0004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mbpafk7f;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3yMiQaggKCPcrsdudmrcfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--stevensd.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3yMiQaggKCPcrsdudmrcfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--stevensd.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787873481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4pKguOeL4XpEhj7eOn7cPoRPiZ6Kih53q6MwTo24ARI=;
	b=xjYyL2BGR1vh221Cr8dqcVviNr9WX4Xf4tgQLzwCiIQdzDpPV4YgPsZwfsJgV2ADisIkpT
	LaMdx5SODNqIy48M9BI99Dqm0353rqGsKq5MYr1Lbgjyhrhz7zuBuG7E/LsHnr7+tnkgmo
	3k2xU2su6nNS+ZINmb+cKXTjjdoLFR4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Mbpafk7f;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3yMiQaggKCPcrsdudmrcfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--stevensd.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3yMiQaggKCPcrsdudmrcfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--stevensd.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787873481;
	b=FKPLoXEEIxibC/pJsbc0dpqBFtM7X6EdVBqciaSfWNTYXpyBQAsvKK3bkKdzIbYx4Q1FoA
	aurN1YTN+S7EBVKRF3pMdm13af5ax+O/6bYzWJGUQIPoNwzDOcJasnC20U2oDP6wwEaMab
	qVn/dfVDX8TLyOBLFN/pkHF72FSDvCg=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e25e4b41cso481627a91.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787873480; x=1788478280; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4pKguOeL4XpEhj7eOn7cPoRPiZ6Kih53q6MwTo24ARI=;
        b=Mbpafk7fOgfUeCKdnqIRF3Rzv64qlHV61ebhecM9gaYULJtQZji3IQyCwant/+T8+F
         qxAcwpC7qKavJqFO3hijXHaWUZmf9uvg8aCgYkOL2TurCFL55NfQV2DnXvSgwoAaiTZo
         KtdzpIbl8jDMcgpQ43dUuvMe7GKNgQQJQkKkz08KhouCWxn6lrvaimbr22jjiwgCVcf1
         OV3gIe4VmfjMlHtAehqpHbcgwjCx7Z1iOWLf/Te1uYAIaxKm8u+z00FpW9zSw24mkQgN
         qlYT3hKB5f8GQUrgA36T3uNlun0uCsaSXFyRsvxZYOKmulBTJg2t6p7TKCxCiPoPrOuL
         977g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787873480; x=1788478280;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4pKguOeL4XpEhj7eOn7cPoRPiZ6Kih53q6MwTo24ARI=;
        b=rXYOY2r70Qrb+7WGUOcZ6LlHRbhPmjkkT73hFYUbcqIsZ4iXQw5TwX7d4x4PHmk6UR
         Stg8WqzIYas5XjcqU/eb8ZknS/gOETBqUMriCdgAcbfk9y7eDRITPNlUPA+I7pGwKlnl
         La3wbroBIslPCB6oWGIPcE1+0NvwZBjLX2chz/5pbf4yJiCSX2IXtr8IGJMNSaU6ejwm
         QyeG1pCW0x7du7QxBk3kxD5J4HKQNTcDmrWBfTviRD21jNWdK/9DhtA2Sctx//tSO1vd
         5XXlBFqNCbMc2SCrmGelr6ilYrbOrMcCcRA5Rzc2OAWTQ32OrY8xGFPCfrtOWTE+5I+b
         mwwg==
X-Forwarded-Encrypted: i=1; AHgh+RrpSfAs3hrCTzkpnrRNKizSTs6nTlGB8DaH1vomc9mBUOW3NltrvKIZALkUatme3MBvhlAiXTzCGQ==@kvack.org
X-Gm-Message-State: AFuF++kOQeUT8W8XRJ8ldkRohHlgZDDKe2P9jNw+/3yG9SZ73P6jSwnZ
	D5W9Ro4Mq4FJYT8bFqRTvut9ziM84ufXJxhJP4pPqNDYJB/DPZJRTWq4hu8VhnlHSs5JSWC9pJm
	2w68aiQiptB0HKQ==
X-Received: from dlbtp4.prod.google.com ([2002:a05:7022:3b84:b0:141:4abc:f12d])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1a8e:b0:396:4c63:7193 with SMTP id 98e67ed59e1d1-396d0fe45damr5091530a91.11.1787873480154;
 Thu, 27 Aug 2026 16:31:20 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:29:40 -0700
In-Reply-To: <20260827232948.2520558-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260827232948.2520558-3-stevensd@google.com>
Subject: [RFC 02/10] mm/vmalloc: Skip vmallocinfo NUMA stats for VM_SPARSE
From: David Stevens <stevensd@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, 
	David Stevens <stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3AE2C0004
X-Stat-Signature: ef3ymbnqc5gxqmsf4ieieq6ybqij3yz5
X-Rspam-User: 
X-HE-Tag: 1787873481-24828
X-HE-Meta: U2FsdGVkX1+QM0xLQa0FBHCrGfm/X6DDFJwzNLVwdKeehKVMLh9to/En5qGBHXoHwzC5xFEIq0Mg8AV+8CnGcCepiMBPzWbH8FrkbAPZeZ1dS2eCXYdDZ7x8Wug3wVA5JmnmoGjxDox+xehRQLBYAWVcb4+tmVATCIyaozgydYXXH4eT4S8LhAuKQ1UyUkjk+4HdfFodigWnHx4GBDb8xjZnjql/qmK7ALqavXGbaM+Uj0lxKKFnu7wXWZ4B01LsI9LY7VD/h/RaVQi0qnFrwkRyjIy/ppFMa37dGc/dxlwnRjUj+HPw6g68CGBy3dP4RqG3QnYNSYJJBCTAZhsE0UX+JA75MMB3MrZaa+MHSJtOd8K2gqAloFwYF7++0aeSxbeb+Gbm8cTIKBdwSrGrquA7IIT8u1Fp0qU0l4uk+iqss/fdLrmQN62kVNtcE85+JXvAs/npZpBPDqwTSDVqKo3QXoAMgIft4kz6JjXtOzFN+p3T2i7v10Tpw37WA1LvnRZy/kw9DPY6A3ZCDw5K5vccqVKsrI49hRli9m8VEkXeAOozATbYuPACes1KGjYDoXGbVISLPT3ukLoQn8MqPw8vLWm3lr7WwD6y1s07WqKCRWsG6M8gvKNJXB0tjpobqxtvEEGRDz1dnPMDmFxIN5YVEhZo8lfKqlgSSDkUAO4/OOPRmfAGuHdZT+JkKXvKIPzlb6oyz9FZeAGRff84MkoGB0WgN7PfwNfvJM4AdQQNYtw4CybDnRGKTDjWi0b+Oqb8YIJIzHZgrJ1ZU1EMtXGC0aWPP8bb3aCFlDapVmEcFcwfsDChvgoYkteRuKyLCkw1ccFBtcTOlO8HC/ivvw6eY2HpK0abUqW1w4JDSs7Cluo1cEir+/hUb5Vw0as3XP2QQiDgMlCmMuh4dtsmG3MPc+FTWBySTVZcacxF0NecL0KxqQR/fQNuSaX9hvVQivmHcAHym4/yGUVSCs1
 kGUbrpc/
 70xx1bvfHWQrAnqmxFiac193AfuIDJjjfQq/GFfyHw1PSwYoGuaJqDJjOet37qLtWsQIErMcr3lB2WUkozclZ1fE6M5YtuQznTG/7/bjEkYIAlu8BMdTnXNZq/W1GZPib9oLkoaAgXTWGmethh0QGcAde4riLY7hyOeNKYOcHWGWQ7sYuKe3oTdtRipQAJQZP64CROLQ75/9GLZZUOw2f2xlUB38OiaSmLPEo0QXZI6/1ZCbxLIAwD63GS0b6gF1yvKADF1RRHrSTZhUow2c0T7FMLM9egRQHfZMuFfeq7XrTarrXPxIF4u/ybgzkblVH03O0XucGjtmKvZ1mJM8pOUXMU4PEUBIW2hPuLG0/CPeW4+YwKRyI91/GRSgILDljISAPAwChkePiAm8g+/5QSULS0fWNdAeOE3FAh1AF7IkLCYkd+6hkA3684m5NmtMxJOjXwJ8VFDE1kNvehYA7Z4jvWa9nEfzVAwgKwhPkN2bzZi+SMtloQGno1iShuD05mm3xl7b81Y4/zegnmy6wSVN77EVOZAF03/Hnd2+DEFL3VthDIvhlGfcgJmBS5/693VEUuAWbd+vh/L0TcaL6BMaAAg+hdZATF7vEW/nLsjx4rkLd7o2I61wHkg7o5DrRlmwnU/w8wkIUdtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bail from show_numa_info() in vmalloc_info_show() for areas with
VM_SPARSE set. This lets clients that allocate VM_SPARSE areas directly
use vm_struct's nr_pages and pages fields.

Signed-off-by: David Stevens <stevensd@google.com>
---
 mm/vmalloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f4fa227a8d7f..d39897300f29 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5294,6 +5294,9 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v,
 	if (!counters)
 		return;
 
+	if (v->flags & VM_SPARSE)
+		return;
+
 	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
 	for (nr = 0; nr < v->nr_pages; nr += step)
-- 
2.55.0.897.gb25b4bd76c-goog


