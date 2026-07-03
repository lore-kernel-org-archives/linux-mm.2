Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD31FC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 04:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0FC6B00C0; Fri,  3 Jul 2026 00:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7816B00C1; Fri,  3 Jul 2026 00:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 896666B00C2; Fri,  3 Jul 2026 00:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 571C16B00C0
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:14:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B22F9A041E
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:18 +0000 (UTC)
X-FDA: 84946148196.12.FC81DD4
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id F3B7A120003
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oTxA3Dsa;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783052057;
	b=Ti72Ho7XqBe3qtpdXu1jVoPCLfps63TE9Z17T1sc8T1gMhyT2Mknne7VoETNBO/keKS5Cl
	RD8eun1Y4VDqpMKJc6BfkIwoQRqXcbHOZ39pqWNCzJuUuhW++p91+ia4bRpLGSOOttcKqv
	l8E/+SecbkuiNuRZ1ReLahLp8KGf4yE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783052057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+iysOyNbRm03PhdFjVxkBmiS8J9Op+shCzVJjlLBpQ=;
	b=rFgGgc2qDyOms6WMTPNZZkL85MR1K/CtxZmbTZKiPV3Vrf9Mno7WFXoL1MsLcH+oQIEbsz
	8wZ4+XmlpzB2u6kIKNq06pJD+FoTP6m9bH4kXSfPjVDBodA+kSLxom0qHTIkwq2T+MB03b
	P0uTNG0J8JSeVFpgsCgCyvrcCPiXk/c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oTxA3Dsa;
	spf=pass (imf29.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-846970f0acaso104947b3a.3
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 21:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783052056; x=1783656856; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x+iysOyNbRm03PhdFjVxkBmiS8J9Op+shCzVJjlLBpQ=;
        b=oTxA3DsaRAU42pG/9zwwXETr2xNz/gRx7GR6+VyjzeoKk9yLHqtYLVDb9ooqLrhS0V
         YgYBao5MxGLtHS0YMMtr4HHDxpFoC72VSoKZbQSxql10lI9gyA+4MG2GGVsoX3k3qTYu
         RhM4njANsH6V/10eWCD6cqr+DuPxrh2+oq502tbcWMM8goTEOBu2LxPvYhoop9bBGU1t
         Yg3M1cIej49GjeBAWWe177FG+iOkBt/lFWPWiMDRn+8OeVad5NNWVlpKFvihD5DwNAQW
         MsmxaUvfjW0+Cfs1oEi5Sxda0xyAXFEw6tzQkjcEHnJGL4VRRUVADuwEPlGZX1Ac5QyB
         j2Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783052056; x=1783656856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x+iysOyNbRm03PhdFjVxkBmiS8J9Op+shCzVJjlLBpQ=;
        b=KJzTU3azsNvXZ921IFn7ciRm/i2yFMXBHNBtgH/D4F7kuX12JycHMiRcEf+ItyVU+Q
         mDhyeVqJhIDOJecckKlaY1b6MU3p9RijmJwHIh7ntIb0Tw0IjK67rjH3Ih2L3Hd93AZO
         wiOcEDD3UcdCr3uS7wB0mmrsA3FRE81dZWb/IIqR6HAmZ6jaSw0klwxL5ApDVg+mh+g4
         2fxaMrYdYlpXCXsh5+O5y79Cbur4lJEavKb8DSmqSO52mQs+mSWMVYwlJnZ/OZ495/yq
         EdjcL7W2yLPlSDRcJ6EBHkxc30b7/opQswlmV8Iixbot+BKlgle0wiEJc5UMcHMkfnYX
         75ug==
X-Gm-Message-State: AOJu0YxhA8p0UMreaaysOiZhbiCP4RPBtCkwZE/Bsn4WwChnIdvbWYHg
	HlmEpwNdzioIaJDJmel6OLups8hfw/nNU/m/KG9tapaRz6iZ/2O4X3fz
X-Gm-Gg: AfdE7clbsvnVlZIwOsEdR/I8rQKGB1norIW/qRKsh+BQervJozNraGjHSYDXZNB2tfV
	g2AAHXDUZKH2ksXcn/+VWoaYnVYzpMhmalPCHJy3i2sr1qc/Cm65M+lS7yBiBvU/rEgwEvzLzNB
	oK+qKOLA6MHjMOYrBWIbK9IB4tfn8mNQJS/ryzntmwoAYntHEyt3BMzTWvhkVH5gyvW0O0BSZoa
	0rHuSJGebbZBLByxBIew5H9oh22ZIEY7brCslkLUEKG+xc2j5s7gFyCcO+JHlWpjj+pvOSmYPT4
	YsCTX4hqA333b9NF7s7dwWewoOSbDAvZ7d7p4nfE6336FVUx+85WeYZOxcOVfwmUUsUaRumJ6Xd
	sFM8/vrZalG7tomYFj2ll/peUwH9V7Fqb2H38f5GbfS+jhZivb+Uw+ZbKEHEg56P5xHnsHWFC2B
	o3R3KRqNE=
X-Received: by 2002:a05:6a00:e8a:b0:837:e9cc:d474 with SMTP id d2e1a72fcca58-847c06739c9mr8648805b3a.2.1783052055912;
        Thu, 02 Jul 2026 21:14:15 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94bd7esm2207768b3a.38.2026.07.02.21.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 21:14:15 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-kernel@vger.kernel.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	x86@kernel.org
Subject: [PATCH v2 4/9] x86/numa: remove redundant numa_nodes_parsed node_set()
Date: Fri,  3 Jul 2026 13:13:24 +0900
Message-ID: <20260703041329.2797584-5-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703041329.2797584-1-ekffu200098@gmail.com>
References: <20260703041329.2797584-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F3B7A120003
X-Stat-Signature: daagpxeqwkb1i61pdr1m46ekmmdja8ma
X-Rspam-User: 
X-HE-Tag: 1783052056-362014
X-HE-Meta: U2FsdGVkX1/jtr5TIdEpzEKnELym9xmKonVpiPSMNbJ3EsUcM3T4YwUNwsBJzbpbvOTRudtlnPlk7RfXXWy/ghyPpOvJT0dh20GC2G336SOa2t9K9Y38pUH4Wfq9G/5DDm8RpAWo70mjEzSHUWj1+68UV+6+yEnucLqZMBcLe3MEiddoaI/4cf0QhabjZbiDJI06OhhhMtEwzmSANmEusEPzlqLmrHvhlTbES3+AtC5iLjxyYrsQe628vqB4PFzTdP159BRKwIQlMFTbs3lRI98gNfHNdBSsHNrGiKzf4CckX99PCZVyTiF6pbE9e6XUUXiK1XuicBF0aB1tYJ0nyf3q7n/ht7Ubb5Vw644hoOn9WM5lc9/a6ky1JDH6LFQVgtFvCNILZHQTqtkH0tlfJHXpTtP2V06/NCxjsKW+WmAbCjT0JgYwyz7jjFfo1BhFggRUYdUt+O6fsRSuHqluOWapjHi68gDaW7hn5Gw4EuvsJ/3pk5E56z/mmZtSmFjA6Ttpm8B2eNcep2hBbpYECiVdjFvQ1vrLZaGQ3OhAFrzwYQQnvzRUPCqb1YAE2OhUIyGG6SncAfce7jbvxOBK4UM3S6TK0AC5x25qEwvUwOOfBVh3/P2lFLgf23tsU2vTMzbDPg7A4QW3mPfq9XswTWmcquS8ILDjinjzhioCAdAJbAdCwvSwlqNsRR1QJoVA/tf2UcJmXVfDZkLKtlxzK6Chi+gDznyH4jZKmg9Dhxj92OORPMLy5HG4Cw3ZKO4xZWr7gi4y1JCfMTbl1lLZBOuF5xnAESiP1PoiOlvq1eJYo1l1gveai9el+I6MtMAJSzUQ2pKmKYAAl3Eyna8LKfl+lqPtMf2k+xP62hNhBZ5zdwEKnIYUN5UuFHpkUFyZ1cv3/z8i+sp+DP7/i1IyA77OGR0+fli4Grz5HnYlTd3sUE1HJ3j8ovNTpIRZ1C1F2Z5Rl8Cz5cWcmnFi2HY
 bOQ2yZW6
 uwvWCM1Uaqitx/ufqQIJmNcdic2zHvMyVxLsohit6/77/HyKkRaLkcJAhCORGrZynykvmD9oQtnCBmxYAqT+xXth1niMeiQUcCZYiBqKnIBSzQPa/drND7xV6AVokOAMiuwaBr/v26SoPEi9wzTL602SRo0j7atw0GcNVpmNZ+64MzGpAHzeXHBvHpKNigXkfiIflYeAPvQ6RFhY5v4NMD6iy64mQ5FdyCl1WKx9Ci68CECt7DIVV0LSZA2j/3TROy1yP8kBNaHlbC+mkqnJDf1Uee5Q8j0m/qRC7MNjWcVPCnnFhkcnUctyprv26pYxSSKjRKcwNfJdPWFkyz3AMNyjWlaepP+TtgPo7d1FL3LkhmmumILHmrIJ0LeDfxcW5MEofK76+sxuUIyvgPXnFjPOkxyi1b/tsjiqMI2RJCnGmJJxMul77lSIMp1y+s3IAlZ/6g9e9pt4FVxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

numa_add_memblk() now sets the node in numa_nodes_parsed itself, so the
caller's own node_set() is redundant.  Remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/x86/mm/amdtopology.c | 1 -
 arch/x86/mm/numa.c        | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/x86/mm/amdtopology.c b/arch/x86/mm/amdtopology.c
index f980b0eb0105..1cb581bbf2b6 100644
--- a/arch/x86/mm/amdtopology.c
+++ b/arch/x86/mm/amdtopology.c
@@ -150,7 +150,6 @@ int __init amd_numa_init(void)
 
 		prevbase = base;
 		numa_add_memblk(nodeid, base, limit);
-		node_set(nodeid, numa_nodes_parsed);
 	}
 
 	if (nodes_empty(numa_nodes_parsed))
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 99d0a9332c14..ced66e68a68e 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -216,7 +216,6 @@ static int __init dummy_numa_init(void)
 	printk(KERN_INFO "Faking a node at [mem %#018Lx-%#018Lx]\n",
 	       0LLU, PFN_PHYS(max_pfn) - 1);
 
-	node_set(0, numa_nodes_parsed);
 	node_set(0, numa_phys_nodes_parsed);
 	numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
 
-- 
2.43.0


