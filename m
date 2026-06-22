Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FC9CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 10:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C1A16B0099; Mon, 22 Jun 2026 06:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172C46B009B; Mon, 22 Jun 2026 06:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088B16B009D; Mon, 22 Jun 2026 06:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8FBC6B0099
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:01:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35D8A1A05A6
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:55 +0000 (UTC)
X-FDA: 84907107390.11.FA1E5EF
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 60D38C0006
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DvEK1AzW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3Dgg5aggKCFsC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3Dgg5aggKCFsC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SzngTEUmnpI9e8CaEbeiYK4MLoCzByF+Q/8MZRzDpKY=;
	b=49wIFlpNwDJjs6d6eJgzTbK2/rFxZN5nIt6rrFf02G9L9JlCCLPRbNQboJyQ2/JH1i3pgq
	wL2/IR5vi/dQSnJWlPQDSL6M+UVNGsIx+J+B8kFG2MHSUn+JUdn7hjPlvylw7xIcScGd6K
	byD+J88qwKmGGtT731F1c+GhlEBlSbE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122513;
	b=O+PxvqY3FPK+UfrMIyYGZyiiL9RtrDeE1XShPFCwXm+cPUztZFUkvIq/wBOXFhpnKFEZCq
	PPk3L78KAxXDmLJ/1b0tmPTxdmLYzMkm6+VrjCoZuo3LrbwkpFWcHfwYW6UaME4Cm+mT1L
	me74xVbAnPYpmvb+aHY9AfYJZItYzrM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DvEK1AzW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3Dgg5aggKCFsC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3Dgg5aggKCFsC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4625e71d3ccso3499199f8f.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782122512; x=1782727312; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SzngTEUmnpI9e8CaEbeiYK4MLoCzByF+Q/8MZRzDpKY=;
        b=DvEK1AzW1qe1eXGNIV8aBp1wATVrkSw16swnOsOn9zdwFmFJn/xrXyZh4sgrGbkmxs
         a1597kiCVdw1C/vAFhCQAIK3be2V/oaxROCV3eoHb8V+zSbnbyz6ApqvUHVaUU3aLJ9y
         jJr2Qh/kv9c1ETRBdBo3FE1CobfEVvkdD7eV/RI9NuI2v80MRl1sJ/4N09gugPU/pK/A
         k2hV890YggH7sU34dIn6avCVlSSUn5oABU6qE5VCMhv0J2aT7PLTcodGrDKBH3xq7AMW
         IspTrrYcMu7OnOXs3VyZ7eU6sSCK91Y7lXbOwTkZxyHF9r+sfCmGCMCx7m7JQnUqiEsp
         wDEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782122512; x=1782727312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzngTEUmnpI9e8CaEbeiYK4MLoCzByF+Q/8MZRzDpKY=;
        b=kuzGIi0W4BF9+a7FIBuB/5Tngr0ovgQUEdMhnfDCIudPKLMbZjA3dBQKfZHzFaf+c8
         2eHL4J8W92lb8ORlx9Bk2sVaa1WJ6EDpcSev48zJsUJPhrXJrp5Sl2m79iZ4FrnOfILy
         R9KocoJuvS4KwfAZ5PD0Ge4Dr6CMiPKtqUEY6g3kWt1RtuvTozB2+zmRepHhp/JmIAKD
         fd6PrerJkUoHz1xYeq3u8c28SxSUj/Iki1HSwqO+ZeYMZVjnhdZ8LiH2SRfUq5Zg4Y6e
         CReAIDu6S8xZr6wNWxgrJBugjhopHOU1Ckw5i9eftkSFdOye3o/P2RxTjZiM1hU009A3
         sfmQ==
X-Forwarded-Encrypted: i=1; AFNElJ+VcmV7KOkYfVO26QHgGzGHXu45xc0uzdWJaDrXI4bb5o4uojSdjKanNvTV6t5AmJSERzJNdN+z+Q==@kvack.org
X-Gm-Message-State: AOJu0Yz02TNRC0vv9UfG4+/mH1hwWahr3u9+0JUIBkgJwjTymNkAZVFJ
	Eq0TphdnXw4VTycnKpRTS6vmyRSl7S5EcLjCvWg3EH1iwwMW7kUtva0YmnphfUj/ZtjqAAVT1Yv
	20GYef8UlQZUM0A==
X-Received: from wmpc6.prod.google.com ([2002:a05:600c:4a06:b0:48e:6f63:7624])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c27:b0:492:4871:7e21 with SMTP id 5b1f17b1804b1-49248717fcdmr138183195e9.10.1782122510601;
 Mon, 22 Jun 2026 03:01:50 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:34 +0000
In-Reply-To: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
Mime-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260622-alloc-trylock-v2-7-31f31367d420@google.com>
Subject: [PATCH v2 07/13] x86/virt: Use higher-level allocator
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
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 60D38C0006
X-Rspam-User: 
X-Stat-Signature: apmgoxwgtxaummtpribf5oxrwhawddu8
X-HE-Tag: 1782122513-677608
X-HE-Meta: U2FsdGVkX182+snp+g5s0dHjAI1PQSoPi0U3zML3UTKZv6tEbfQEIMaEiFUyWdv8QR3qnZcl4kMzdQwxTAWQ/RO/NXAKSCnFPyRuTNc6IXAxQ+kQ4iuIFgYrHdLQpCxwTEc0PEPbGSDkWVGny5ulJm7px++tPx5XmoqGFmPEpN6NM+24AL5hjvrH8axsAE9tZMkCS0qI3ZPwRnSgeGJzczUyKdpUZjfNlnvHOSIdyTUkz09HIcxWc1YCPQeiO1CDKBmMt/mMWkFB6wb0cZcYF44WjGsyyvJR4NnpTTSdftcm5O8tG780kFX7Lq0ReTWvFDm3TdTetbuxBJ0HNln1BmVHF5VpjsFAU/LwEW7M3shOlzRWZRGKkrHxREn9BaiazrmHFTM/Qzt3XSzsWYfi2iyFBPz+JdynZ25KICqS3GUP8vM0uG9DBBizbBYQooJmdckAN0cwegRJGZGronJ4S+aM2w1tvvNmlTHHhF05vxYaERtWSaEhUmqxt5KU1sLqviYuuWsXAE++7/65g/CNJjYcuNHs9DpX11O23fygVAQoVlyVGgfs0pLaq5RwJUT0iH7+soh0/uPNBhlvGxoZq90Gv4nIi5YqE9peFQ1sl5BA/I9r20vcPr0QAYuehdtIEkQZ6VfPBwConnW+iZMYR2bWS3kkkvcPt4teMRTfUcHzfX1E5/l3OneJgELXMMsPpA9z73Cs8qzMGg4MJaEHpMspG4OgwF6+7vXCH6HuZN9lISEk01W1oP8Fb+8bKf4DqcaYEp1p+XHhnWW/I+KDDAf8Aa5isNJ7dCPfAuDFpU6ZEIVT6Q6sH1KUaZyLOUgODVId9fp8tYa9OSFmBWM3KyobSGTg5YJQxK5wlWG/0+buM+dFV+AC4wb8M7mnwWeBoIyhZPdci/TVd6ELLJFDiFoFIumCvpWRsx5beSQkhzNlcaL4kjzJKSgy8rRyBX2NRhqKDgcNC8X7xxwrOBp
 1GSjGddy
 oS1TX9EsCIVwWSOU7U79XI8ays280a0UBFrdIZus3WgAAADjq0VygdVWf1W0/QchMM5ySLeVJXtEKMa65djMCDi4b7o8PefaD5FDPZrZ0yGUKvJcmEaxs27Nc1rjVoJL+KOJmsV/Pfwi3Lw7cdh+o63Wc8e2mG8Patxk2iK8hcvcg+2UelMjYVzOHsbrH2V40OV+r7fHsdWCGEo20CQeBpt5Z0hNPRvY65EwKY2RVvGyze5AiiUIVTWDlCkP+G7kFYRfGggaHlqrcQpNxj2INcYnHx2u+4A3L6DoZmSV689pb6FqvcjO1mJBT71UoDOvmhpnO41iqh7O7uNfQ58wv1iJxdLQS5V1/Y6X1XgE5lnqA72aV3f+FD3oZCMKUVPV2kkfG7R1rygzk5hHd1CAA8sNtsb5qCQrgkIGJ/sxnxGTzMnQjA62VS2fVNSlLCKk6V4Zp5mFQ/4AGb57LBh4eNhbilP/Dt7r99hX0lnA2okGcLT0duhJ90FNa62NfCDtiiUqjM8hbHR1FAv3L8X1okotgWXzgnP1XPJZUccgRDb63HXu9kPQykqm7EOmoXh7J9MNlFiEh4EKDlSQ+FViq/pyBN1+jR4IIxvabL2JuDIW8KIZIT6NkZWYF5o6C64P5PeuWEuk+x1OD6eHS0By5xpwAT2n/JIlIY5POjGfkbRtlKeS0ETr/qFLvvbU/0wiAnLGDc3hq7bqb2Ru5jXTllyoFb8joTV+pDiVFoGSaDadxVbroR+gkXZ2bRzNk2WaAvWIO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The difference between __alloc_pages_node() and alloc_pages_node() is
that the former allows you to pass NUMA_NO_NODE.

The former is going away and the latter works fine here so switch over.

Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Assisted-by: Gemini:unknown-version
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/virt/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
index f647557d38ac5..4251e410474fc 100644
--- a/arch/x86/virt/hw.c
+++ b/arch/x86/virt/hw.c
@@ -183,7 +183,7 @@ static __init int __x86_vmx_init(void)
 		struct page *page;
 		struct vmcs *vmcs;
 
-		page = __alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+		page = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
 		if (WARN_ON_ONCE(!page)) {
 			x86_vmx_exit();
 			return -ENOMEM;

-- 
2.54.0


