Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6B94C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFCF76B008C; Wed,  2 Sep 2026 02:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2AB6B0092; Wed,  2 Sep 2026 02:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9AE6B0095; Wed,  2 Sep 2026 02:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5AA6B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:45:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0697A1C2540
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:45:46 +0000 (UTC)
X-FDA: 85167886692.03.751B35B
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4B09B80002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:45:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bjK3u+wl;
	spf=pass (imf02.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788331544;
	b=pMDaa9APVhIkOd0//oCz6qrkPT8vvP0t+p4PrRdcjxld4xNKGUX116KAYLQo4wXCRvRmaG
	WA6P16JWwQMySdpel5D9uhDlSP83VBR/LzgcEevd4Nk9cMc5b7M//71Een2nvc1D844S5A
	nXAKiy3Lsjpcs5n66sazGcHD2uuBFWs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bjK3u+wl;
	spf=pass (imf02.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788331544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhH8Mo5IKwB8nmCAJcEjBx6yBcTLSZlIEQfHIlsogi4=;
	b=FLYPV5KQWWtQfvX+BsDCl3mnJ/Hf56/yjud8DZwbyi2qC4h6o935HHTcgw06pmGae2aMmQ
	dkU7/YwntLHX4Uf5kdENLMbNCZ6KI+grf67rGBPbOGzEQqmWPMlVYJ12VumQwYAhgTiv4d
	F+QE5Dtm9HPBLl9Fc8a3UFflYzE4128=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so676001a91.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 23:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788331543; x=1788936343; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hhH8Mo5IKwB8nmCAJcEjBx6yBcTLSZlIEQfHIlsogi4=;
        b=bjK3u+wlZ3wD6uRDFillnJgq42iM5mVTrQcEtu7Z8aQyGgUCYLelDgDwxfPC07dyOe
         hT6oLSSPpsCpjwyZLz5D29DkTACPSDJ6+M0l4hSRrtZA3bxpjdt6N5SqVUE3GnYGbasY
         zrbjffFG9eM0dRLZoOG0vWNZiUuRGLsBsGHdxVXkldTETBGveSys7W+fk1+PjEsbqLxM
         t0QhUy+tEOLhbMItcacE2djrHgDRJGs06wj9UWg0FfPmejHK01yXjVHYzhYspfWGQtmZ
         ywKAV3qlfiRdngANlcfarMLqpZM9sq54MUdcqESpPc0vD8kBgkojqjXWv2P1y3h0d15k
         i7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788331543; x=1788936343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hhH8Mo5IKwB8nmCAJcEjBx6yBcTLSZlIEQfHIlsogi4=;
        b=tLlrq8r4k/jgn33DLzeX+tvpLEYwz12km6/k1tBNj+c8b4sIoSDoNiW3e5Ewfsa7K1
         pLwNo5xzP6sb3M+vjcKoY/9wSI5tLb4ij/aeXWMFG3Wpq3zfT4WrpiXB7x1G8B/BNypg
         76XphD3j8buzRIt+4BSyecurYH/WOabcADGnAp60vA7uh6yajgY4h7FyFELtbiynmBZ8
         GSl4qGm9V1NqxjkZ5jMHLtE0xiqThm7i+CDwrhuqxp6XOgOM0AURlXmyvsWLm19rfBQV
         EmJsnYrnBelRs9XhDXi5F1BAuxRMJjPEm/YXLk7dmhCQaDRTk19+MqhXJ3OYW1iDjowD
         zidQ==
X-Forwarded-Encrypted: i=1; AKwUvBxTEXWd0NN5eZQAKjy/DTMMCSuPzQjQ/FytULT8SGRepk2w9H1oAEw46ew44AznjQULVs669g2//A==@kvack.org
X-Gm-Message-State: AFuF++lM9J5Ut2IQtMdnPTbqWH55dosnzEcatWR5YbFLLSAWH7Z34ueh
	Lpd/HMQDi0YZUNKi4uVxu0EgvRNtm+SawvbpBYCE946W3udQP8x8M+CL
X-Gm-Gg: AYBFou3NzyP5YwLPbvvw3620cxvBHCtGF3oAFOenvWrCBP80k2r241bzVIQA3y42126
	rrWzTj0zUHTPM6JZ7JEcUROgsyEyH4asbH8WaAA+BS/AKWcmyyXYSpfkcFWdNCz8N6g8eNlJY3z
	7qlnq+EO3V2zUORJ0MNKWJklDmVkEIizPJQOcSruPmodUz1E6sEbRQyP7lnm1C7U0XY2rc2rbPf
	GnEtLr0LM50uU6Oh4gKgT83TPkWZ4gdzuTNrAeXIndVs2Fbgpg3LXz92gdcD0b2YlQGqOejdsqJ
	9TNGhnGo+78SOWa+bO7D8ONqVr/a5VdeCdyhXhZf2Lcdrjoe5Qwk7SzfX9N49vVFnYC2g+2qkiT
	smd48uG3gv4p/p8btsTP22uwhAYfRVGhKQwo0BD6ceOmYIoBm5ejnGJQ3DNElJaMJ7BF1xzdW+b
	6skyoKcpsGi40U7Wc/tMAnQQX6kVnEqGg+s5t2R7xPC56/GQtYITyNJkcKCA29uk6HbeIw9op8X
	rl1jSoIVwdnOHQF
X-Received: by 2002:a17:90b:3902:b0:398:9bd1:3215 with SMTP id 98e67ed59e1d1-39aee13c238mr3645191a91.22.1788331542955;
        Tue, 01 Sep 2026 23:45:42 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990bd1b395sm11051480a91.1.2026.09.01.23.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 23:45:41 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Meijing Zhao <zhaomeijing@lixiang.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Wandun Chen <chenwandun@lixiang.com>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] mm: trace: decode arm64 and sparc64 VM_ARCH_1 flags
Date: Wed,  2 Sep 2026 14:45:08 +0800
Message-Id: <bcf0fea58240c4b6daa253739683ed7709e42fbb.1788330432.git.zhaomeijing@lixiang.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1788330432.git.zhaomeijing@lixiang.com>
References: <cover.1788330432.git.zhaomeijing@lixiang.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fif1rt8q87x3da6pzt84wdnd9cmwhpqf
X-Rspamd-Queue-Id: 4B09B80002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788331544-453671
X-HE-Meta: U2FsdGVkX1+/q7a993kZymyaTk4PtgMBaHkmt9xRitFFkyRe0/AVlekbv+9tv32k+Fomc21JrWVb2qtnPlEkKgrpYF7U53IdscjKOHflgKum8UDNrBMyDRUUX3g+ht0IKDx1sxvbu7ZKQU2IsdxH16UJeydT9VY3dAd6l+AvO5L0OfzkTK7iZia8bjdRLsCjVkBnzGc222YjTK46nEOe51AFIuZhwOhhrPSPqfft1KyTrHnuStfz+8t1q7M1DR/LSGNTROQnFv+olqnQxpGPrIxJWZ4yofzTDmSL1d6wuOmlGEdAMLgSA5s0r4rCHrY03v4MT63BNfmtKdrRe8szsFicII8G/bz+ntZDUkocLXg1Szc1ygcNT7JJ4oxZ8NSAcaXlrdfL6vwtWFFQC0oNXFD369tyKCswmgvLyCrpAEAq00wuxBKQEl3mJ/pHbIbf5aP4t1vOYW+Ck6FnSDOROBPEKHRtUrHPYmqYeeiZOvRR0gM4IRXCMlHKHJehZFPY2F+Kqg0emJx8fWlBLnZmDkaT7mvGQnMCFN03iILIwXdqm41ZmphZS6PIQ2QMtHTgp3dA+PocJiRk89wRS7YVR2TLjgWeEiK0kAKRkxFH+SS2GPZ2VilotwYk4f3O5HtxjRZoBMbJSjbETxTwVP5CH27XCSjVZepyNCicmja9rDuHRpvVkSfwsREiP7ITYywaGSrK0o/DrfaHABYki+81Mdjrvf4TEEKIOa4evCcUNW+SeJ1067JPant143VKMchZW0+IHQo0mtgQwlmhJWBkK/1j0g+VCSk3Zvf+1sB/lymbLJV8YKpnSi5oopxKMMkpk+K6RCMx5UIihQBO6Fjc/FAzf05UuIgVCM9+JufEG1LiFZ/efTcmTW+OIvxZRFz5oi1lGO6sa+v4KuBD9+9Ou0l1/iZ8m0uWDWuTpAL8t2xkLFr1jlezh4HYAUAfsfIdjXg+BxKsJhPZZSVPudK
 0hVSylhl
 UOb1UnFTLB3Prr0qQuYgMCoUbkXsemTNpSNM8YwGZDNAiukm/j4ZEBpz+WzU2cHWPOhEF1kdfV9kGAqPAcrmh29pTrmMR5/N9B0njsUCHSDr/ATcTYqsulxE3oZdXuclVz9pgw85N6ZErEqluSo26upyyB3ra4p8N854pp6qFkrYRD/wCNyjCsRd/ZLOSDnCz5QxF+HaWMdyUlscpI8DTrAnCKS2+lkKDlluszdKqO/gmsHIYOrIG4/EenKJxabRlEE/uwz7wu0n2u4zASW7lscJlamBO2SjzL9bCLYVSvUj7yo4u1VoDJXoqbJce46UcWnyQGIRrAR0Am6qEf8455lF4aPK0xt7Q7TgqTMr0lq8ity1Q3e88VrF67RUF+nvIzSpn5atRW4f7qtCf6a9oa6xheZwIBOd/4r6xKlBrGBW2I0mGJYNiZWkLF+ixHp4FkyWNcUPBI6npnraeeOHaNwweHRcUkiEL4+FH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

The VM_ARCH_1 bit has architecture-specific meanings.  show_vma_flags(),
which is used by VMA tracepoints and %pGv, already reports the powerpc,
parisc and no-MMU meanings, but falls back to the generic "arch_1" name
on arm64 and sparc64.

Report VM_ARM64_BTI as "bti" and VM_SPARC_ADI as "adi" so trace output
and %pGv dumps expose the actual architecture-specific state.

Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 include/trace/events/mmflags.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 935893e5ea53..02caeaf359ab 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -168,6 +168,10 @@ IF_HAVE_PG_ARCH_3(arch_3)
 #define __VM_ARCH_SPECIFIC_1 {VM_SAO,     "sao"           }
 #elif defined(CONFIG_PARISC)
 #define __VM_ARCH_SPECIFIC_1 {VM_GROWSUP,	"growsup"	}
+#elif defined(CONFIG_SPARC64)
+#define __VM_ARCH_SPECIFIC_1 {VM_SPARC_ADI, "adi"		}
+#elif defined(CONFIG_ARM64)
+#define __VM_ARCH_SPECIFIC_1 {VM_ARM64_BTI, "bti"		}
 #elif !defined(CONFIG_MMU)
 #define __VM_ARCH_SPECIFIC_1 {VM_MAPPED_COPY,"mappedcopy"	}
 #else
-- 
2.25.1

