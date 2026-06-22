Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BCBCDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB9A96B009B; Mon, 22 Jun 2026 06:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A5C6B009D; Mon, 22 Jun 2026 06:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59336B009E; Mon, 22 Jun 2026 06:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE116B009B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:01:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FD50167000
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:56 +0000 (UTC)
X-FDA: 84907107432.27.053EDA8
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 12B43120002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JdnVMHad;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3EAg5aggKCF0E57FH5I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3EAg5aggKCF0E57FH5I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=anP6XoH/y5KwBW1jK93UnwjV54q17yZa+JENUx+IL4g=;
	b=371x3jXIigX6UAR8j8NxnYMZtjZV0t9YAnj2Hffp7yq++eSBmzZ9pS745jZCahYGu/N9aU
	7uuf5gAUzZyHLJiDkyR8+v8d+K3EutpwR+dm5uw+CTipx4QdD21SuNCCg8REOwLcDDP2Ta
	/G0PElv8dqQB5qz0dFTEIQCph0jJ4l8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JdnVMHad;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3EAg5aggKCF0E57FH5I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3EAg5aggKCF0E57FH5I6BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122514;
	b=Go+4dLZT/aiD5BMpUh6CjIqcUdo8KSCduXct0qPlnudoboFcdhbgOLP98oLvDH9T0ptZ4X
	osNuYu6lLU4yjsKp4mUn9/+PLlP1byRiRdZkAI2Zz/It5S2pKcohlbO2ChYNppkhqFtM/9
	dTMMj1p9sthJR0W7VdtrcIZqVrAzFjM=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b0682d2fso31490745e9.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122513; x=1782727313; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=anP6XoH/y5KwBW1jK93UnwjV54q17yZa+JENUx+IL4g=;
        b=JdnVMHadtUBC3ZY1q8faTZ+Cd900f+H0RsnUb5yr8XUG7TagsFYPQHQUwXI8gg6E6x
         yR27acEHylZH4SOXGPwzw0YHPSAIn0mU2ddz4snSqWBm+FfQifpUjxnpbHvfzoT21d7h
         fZ6Ef8uZ3G01XT4LSU3z9azmE8d7LW1bYvaluGtda97udt50PIeIMXY65C02tJvcZS82
         ZgGqpOhEP33xeIixBmmng2+2S8p/aFdxVyxhmrz7h7Y/v6OsFMAoWPRqjfnhk3lM5wmc
         3A+U9XCa8S1eSfFz38y21PKL39KDRC5K7Ld0PD237o/l4e8DNAqBhqAiSMlXmUeoE6gZ
         ElRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122513; x=1782727313;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=anP6XoH/y5KwBW1jK93UnwjV54q17yZa+JENUx+IL4g=;
        b=c6hqGIKuZBvR1V+jPA3H6NiIo4Ij62iYx3jtrF5XBD9jA2sGqdxfWpYZKCo7cG7ntx
         wRgKFMWk+qPfuDfw1hzJTUvqVDh1ky4zC/8Mup+Up0bR5vdrymbogf2rrK5NYFA91pFp
         HrVCqSlcoPwJ24VfAoPJ3Zw9pj4McjIbE1pNie8mEBh61588hqa97lTKDu4wA20qGrMS
         htrsrSfIoCeg+W5SGxZWmhg/V1zT/acne4Xf87PcFoplenSkvenvjav1oGfDQUH/79mJ
         uS1uzlbRVIViad6G+5XN/1qoP3r3Cw/L0Ki7iZX/42L+U7PHgcViI0Gy+xLot2//lYeZ
         8D6w==
X-Forwarded-Encrypted: i=1; AFNElJ+LxVy/jQF4Q7L2pMdkZeNYZ/2Pi/yVuPBCuys3KdDUuoR07WpAWFx2A/wpj8syYIuBaYjjeQLJLA==@kvack.org
X-Gm-Message-State: AOJu0YxHsPfnvkJOfJMFqkIQr+rKiMRKF8/QaOpPyY8Tnb69ygGeVss3
	q54gBg+HrQKnCav+3tUYGCozIfho/0uVny+X4jm214OeRTGXHpu8uewFZZMEz0/PBqrakIoWDti
	wNtmh56807vq3fg==
X-Received: from wmk16.prod.google.com ([2002:a05:600c:290:b0:490:e9bc:6058])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5020:b0:490:d946:47cf with SMTP id 5b1f17b1804b1-4923ef47d08mr224907005e9.4.1782122512201;
 Mon, 22 Jun 2026 03:01:52 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:35 +0000
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Mime-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-8-31f31367d420@google.com>
Subject: [PATCH v2 08/13] sgi-xp: Use higher-level allocator
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>, 
	Robin Holt <robinmholt@gmail.com>, Steve Wahl <steve.wahl@hpe.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: wt3rxyxrfj4rb8q6q8bkbsphhau5pjkt
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 12B43120002
X-Rspam-User: 
X-HE-Tag: 1782122513-450860
X-HE-Meta: U2FsdGVkX1+LXrKKz71lcH4SRcGsOd00qHVeF2Vf6GWzFVP82EeqUh/EUg3j+PoYSdzF7cDCBoHnAgKVyVdyg6b5xOUrp75eYtpfhXdzWTJNAMUV7hIoHVnsU7A37hknabCYg/2IFEPi/m8/FUugxDtQkkb2cW75n3uEhanNMWByDEBg3XP9RoBsElJzXik0A4umIJdKA32TSQQZnLgJ3MQlAvBnqII/Qd8rpcTtWsRM9thCBKXIhXb8nnp10BqdsaknbVxUBM1FVGxwYRrCjunJXeiaW3h/g4WB8lmQGrX4G6Ux0stl2a/PuEvjpl6yFNVff77kCEJ60rcP2alDhIVbdNM8QJaE3jo+LHizDX+9XotpFvU0VWlaRONwDJA544mj2p5gV3ouRQfuYjqNlNXyWbuXaSOcxtDA3c1NXkdyWd7lzn0odiUcT58TXXOE3Z/CzzVT/zAS0IAUlImEbdLMctrM5TRxhwk4o8MNnU6ipyH28+HUG0kfjQBsx+NcjFnw6gbFXXNyQ3IYgs97sercoQQLUO9MXPv6EZkllQxlKLjSGYsUjpqp9utCdLWi/cXrf8xXlaMR5WDK2jJ1+XhaFaCWQ48x8ZuVBp6rg97jEfeS/FQGqaaqOtvFpNl6r2chZCite713mVuu1GEJ8qSttvCPHf4wL45sjSoXb7UeOD28ZlCrWF6+/0CymdM5ybRhEmQf5MbmnJxN0gjWZFjAeLdSAISi+tLAbif/Sf7fL0mwKd0NZOvTOrQT8BKBqFywPSZqbSYucgjMXdqNEMV54XdeOwoafMum6SJo4dpR9q3Q7ukZ+MVkXE5VHutx4w3Gr4WjM81RlbUw9t7PzuzVnFHh4TsVOhhzIdsUm5FP4O68PdJhTzsaDdgKBpldDN/AZza2+UE1+Lagf++1fZaUcEPWrbOvHFHj/N16aZmqS0IyXFi6wZXaRmefGuqwpPy/6X+n2P8pa21yWvx
 oAi7btB9
 qBRzu+6+RjnaLoxtlClycCM7/Nw35IVFhasK2AV2En8hnvXkO3MK1Vi+Exl4mty8+zbaZ16cJd++lok9wBDShr4eLS+vB/7mI+lK9Zv4iUbH3zrxDDgTAs2qrlDAzdE+P6sDoQnPqjfh8fZ7ymS+ZqK6ZBrD2j64+XxuZ3sErfYIeKoxp9X7CC1kZ/F105lJlXsKgy5UmpAzXQ6H7esWDfdaIXhQzvziO0++Llmtwrlsy56cSm+kboNt+TTix9sdQaC+D3K8X6d1vFlgMf+XlN9f9REPJh730jfbtyfcM7iqakXUp63FMVkWti2MNEi4BgW2OXeS5IrK4L5rURONvmNQRujrEJk5m1XlgP3yxo4u92Xs+PpccENMel6i1HjQtep0cxKyprpU7KcXRSOwvRlGR69Gyy26U8b7vnqfbBdH2l0PFeSrwwurkl6YrqjADLcOikSWNWCCvqjEO6E8O5miz0QlTjkJpZlxypmbGSKUQX0G+cRkAe52wGwEEv9Q8Ic7S8o92O+I8k3fVnN2oWUR7PIYmGofxqqMHwFV9xW7K2RECwVftqW3FiGsD6WQy0/5jb2P1VnwtVyKxje2LvdIY318a2fSSU767VU9E/CeFMqjyiFNB+2aZS2T0ZrtzvFx8dwnzokVZ4BQCdiROg6+p8ZFt9DP4wM5xvr1q3/eJJjgY8FGmqD7ZDEplvNmySH0s6CWTaScBNS0xSAaRzrfqN404gBs9VDGoe/bfdTtMmos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The difference between __alloc_pages_node() and alloc_pages_node() is
that the former allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

Cc: Robin Holt <robinmholt@gmail.com>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Assisted-by: Gemini:unknown-model
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 drivers/misc/sgi-xp/xpc_uv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index 772c787268932..aacff70204241 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -170,7 +170,7 @@ xpc_create_gru_mq_uv(unsigned int mq_size, int cpu, char *irq_name,
 	mq->mmr_blade = uv_cpu_to_blade_id(cpu);
 
 	nid = cpu_to_node(cpu);
-	page = __alloc_pages_node(nid,
+	page = alloc_pages_node(nid,
 				      GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
 				      pg_order);
 	if (page == NULL) {

-- 
2.54.0


