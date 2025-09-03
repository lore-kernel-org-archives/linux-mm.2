Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F223CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 11:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1548E000A; Wed,  3 Sep 2025 07:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35B4F8E0001; Wed,  3 Sep 2025 07:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5258E000A; Wed,  3 Sep 2025 07:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 01A738E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:16:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9DC9E1A05DF
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:16:22 +0000 (UTC)
X-FDA: 83847685404.11.7A1E4EB
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8486180010
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:16:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iTan8OVE;
	spf=pass (imf06.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756898180; a=rsa-sha256;
	cv=none;
	b=mMqpPrINBhn0CsJiCbyPrrEFidzzJpsi3ks/rssU/eOGUyBd0ScNX3wJqFq00ZrIqr2+a8
	ktZVsh+KIa4a1meAOahtsW4Mk2Whvwam9aL/jmxXyS+EzP5OzWsGF0QGTuTYq4M8oCdfS0
	IG0KaXK+HCZO9MW6bQOmz6k5pNQj6qs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iTan8OVE;
	spf=pass (imf06.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756898180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/J6B5kO21qmim3edptXX1lboSXT3A4ICQCYNPP7b6E=;
	b=fxWw4GXYuaiPFaHyEssGGr6HmdyuM0HVbnK++m8/bonrq9XNZ/h6KCIly6hNL/uj34rF/y
	VLokWnWt45j8TcO9Z8gXn/gug6YpJmLs3Uofxt49f8g6ZkN4vXD4f7W80fePPHFbvY3SQw
	2QOStlSll1Nj+u/AZlCBD4fci3kL7z8=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3b9edf4cf6cso5566270f8f.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 04:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756898179; x=1757502979; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/J6B5kO21qmim3edptXX1lboSXT3A4ICQCYNPP7b6E=;
        b=iTan8OVENEUQp+K313GTeO4yQSkyG6x6FYIljYGeL4G1abFf5l35BmWKKq07bRSbGH
         K4UMYhq8dnCFVeupYjFo+JKtUbCyUBZ8alBqtyFS2o4gtpB12KXjAoXe9dl7UrnB+lyn
         7EWucStrzRWDGJ3v4FL1KWNRDwEzBkI0FgcpLtfB9b6Txnyq+Dyesl0t5j0NS/BGSH7b
         QfNGs6OgAm9nrvzt1UxpEAtOMjIwB1cirpP1Fbfy75livcPWCtAANigdznAnsK1CrlkT
         zgWF5C1vO9M1psOjRT3MVkmO9b40baV12nQpBy53ibo5sWjt13sXIFsVtzg3XwCA+YgG
         LfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756898179; x=1757502979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6/J6B5kO21qmim3edptXX1lboSXT3A4ICQCYNPP7b6E=;
        b=gbm1q4BwsdjC5EcWA8KTbFGMg0NB5h/+MhDi74kp8cX5EvbPfQX/zS0ktNWVTGwwAD
         KIPNOAmB8XC/p8ZW1sGfJhyWgREykc+OXNy6g0MWi0cRSupK35RtNRdxs+Zj91l2zY8U
         mnl4x4CiLr+jgtG8OHVH5GncCjKtaxzzNPXrBbftDbIghCLppPTb9eT8aaKVFE1a22mG
         wk7LSegY9ym6GgVm94YCASaaRTTVqbjaZ3aAiMmkPwM0+A1mfno9zyxSbPOP5kypRfRD
         qg4qVO4+RyATacUHiGWCIDqBb7xv2e5RAcmcEc5yLEebr9ViHznhbgiSgJsXfSJmis3o
         YEHg==
X-Gm-Message-State: AOJu0YzYTOoqcd1cSiIRz/ZkN8/w7Hzyhd8wNe+NaCx7QNFcNGp03F53
	DTrPPXnEHLBg+9yWw4dr8bmRZVnRY3CCqxf2P8LMS9KUFGrjgN1QPKUk
X-Gm-Gg: ASbGncv1P4gcsI+0UqrBGuVp5EbnNuHXXVF8whU6JnaBJkVOu0T707nRX5qIsTQBcMW
	OcYaRUD9p2Up1aMRMqGjopoEbh6/r6N9Uvhe0uhPDot25b7tEm9A842JKyWk8ZiZ8pBR5msRQpS
	H8tYp2VQ8g29DMo71PMeZhie20J+vXlW3H8YHcchvP5q5P7f6qY2or/anQ5ZDOf8k+9njuAucg4
	oiLvr6BoMAUqBXbXI5K46VXshsxZqvLTQn2Q6SPkV53CMsAIoUMuCTS2cPHZKvOiYPiWAUfDmAp
	2RCfQdQttHlDBAzGQVz3aH0FY3Q7FXtTvRUAbhm0j/NR+A/P14ps/6w618w2HtVl95xhFTRH+gl
	pM2g/xwxuuKDFNHObuW8zi5HlbQ==
X-Google-Smtp-Source: AGHT+IE4XJp50UJAl1TyaOPKdT+BVYrcIKTmTgL9yNbuNNlBknPz1bjnwok/rktMidIrBE8JQNXNTA==
X-Received: by 2002:a05:6000:2909:b0:3d0:e72d:867d with SMTP id ffacd0b85a97d-3d1def6a593mr11880201f8f.53.1756898179208;
        Wed, 03 Sep 2025 04:16:19 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:4e::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7c461edasm144127605e9.9.2025.09.03.04.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 04:16:18 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] mm/show_mem: Add trylock while printing alloc info
Date: Wed,  3 Sep 2025 04:16:14 -0700
Message-ID: <4ed91296e0c595d945a38458f7a8d9611b0c1e52.1756897825.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1756897825.git.pyyjason@gmail.com>
References: <cover.1756897825.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C8486180010
X-Stat-Signature: hrb8ppeezj6jp6cqtiwx8h87mka6w3qe
X-Rspam-User: 
X-HE-Tag: 1756898180-266734
X-HE-Meta: U2FsdGVkX19iZb0+wHmSyVBWdiGKYHbLFehvd0fSx+fxxmXUM9rHeBQWjsdtOiV4Qd8bumjC1xVyaLkkkf+DsjXI2AGEs4n/4R3ERI/1/HKQrjmI49W47MxmjR7ja9GbLZLlYi1nmJjgyZMLOIWfHcVcioTJX5ooytpJydxCu1aOE/VSAlorD/tdlO21EX6sCOVkcY6D+485p/r6hdywe2+nJ0tmKu3OVUIk0p6UgRW5i84W7SNWRqYNE485MIn4jL3oMrMa7yB27rXSEc3k9YGJkz7bPajh2MvqEwOqAaHXLtXR8OiY2mp+QRixaKYPAGVkbtBTSvhZAz7I1H4dLcC9TKqQKB2C/yZ5LUdy5WuWlrddwNDvPC6MB0Gp5HqE9+z4Pwn2V3G6erhN/xqwJNj6eAdvV2ut8QJXso8AAbZIZYieIY0IOk5IwF5gC6ct+BSDoIclpQXnJdp106BFYPJQxNQCe6LTlFEXeSlu/Mb2QUyaxj4oA9tgFOKvMc79cxVwJXl+O+ssP6IfCLwqaUkPNbyXmve4I7FHos4qoxJQeTz50U17WuKOKcnvb22MLXm8nNbc+g4ne8ERAsX8N+isj573mJR5d8sYLLo3JeBTAEKvOqSFy26WKArtARWcKZO0ZqaR0brh2CQAKMJO1ACLfdp/YTliYDiUaIvJUFFPJqo7+PTp+zVq8ZvgwvAqA0RaVtG8dUu1wtx7kY0QP/Z937PaFgIrEqO9F5Y76sUQr1gRfm6DX1hO26gf7ctLR+ZN2t5O76v+DYRSy/eUo3kiRhhpkrsd6gZ5RWoe3MHgi0HPqq1wK2j0z1SyJHj5D8zQQj/es1AAwp2zH1N3VFxoOLsHMYUyLxRxfaQq+RBp9tF+WIneDEB6eSn2CeZ8ZBrS0QnAdcJS+j0aXOkphSyV80MzhiE3SYVY9xkdJN10TqZCXtrfT14FD/739kefb91O75ezmaUsfwwxEhd
 nZDcCw2n
 zVYkP/xnWxune1ZcqVg7JT3EAC2aLUJ6sOpLPbO8I/ZL2JeJvk35Bka1+d3eP/hCbEd2orgorpJs9u8dy1IahxMXLO9j9xIvXHx7QM7Wvv5E66zOLKaKd812lLgenG5myNgonKwSBHhekNY8SWbn7aKagK2wbK3lcJZVxIKEAX2wBZBXYCMwNDTATFeSA+alXkHjW4qk4jpkGIXA2rnPYfGyoWZfmcdo1ZQ0Kyz9CsaYQQ2Htd2gt82OnacL+AS282dhs6e7FlW8lMSP5LFmJUy6SFM8n9tS/TRZXgcHNT0HUtKBmJtqyFo3cOVRotGY3KyAi2dS+79Q7DjWBSlJFQyGJlgsVznwSm01y+vfHMAGWUpcXJpuWLmT/1iVw7uDXqShlSOz2IF/icF5/OELzQ2Cyes22SIuAvflO44sW99v+e0Xjo578OtUX6nRSeo74RbO+fEgF7gMAK0GSv0+6ZltnuqyDRtJBOvcz21Eu+VmAyFUeM0bi0nC4yvc0KsbXie3rXldyK47T1RfptZtan/V3NrSU6qxirlg64gMnclZj/yuG6Ej9CyMcwqSznhkNS6vDxVsjwNXnHuHcMf1U9OiS+rRd7VNgvpyU2nKMOaXvcLBLKituFSmHOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In production, show_mem() can be called concurrently from two
different entities, for example one from oom_kill_process()
another from __alloc_pages_slowpath from another kthread. This
patch adds a spinlock and invokes trylock before printing out the
kernel alloc info in show_mem(). This way two alloc info won't
interleave with each other, which then makes parsing easier.

Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
---
 mm/show_mem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index fd85a028a926..e9701d07549b 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -421,7 +421,9 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-	{
+	static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
+
+	if (spin_trylock(&mem_alloc_profiling_spinlock)) {
 		struct codetag_bytes tags[10];
 		size_t i, nr;
 
@@ -448,6 +450,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 						  ct->lineno, ct->function);
 			}
 		}
+		spin_unlock(&mem_alloc_profiling_spinlock);
 	}
 #endif
 }
-- 
2.47.3


