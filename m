Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46449C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FB646B00A1; Mon,  3 Aug 2026 03:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC826B00A2; Mon,  3 Aug 2026 03:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9926B00A3; Mon,  3 Aug 2026 03:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F01E6B00A1
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:15:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B4C4116060D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:15:22 +0000 (UTC)
X-FDA: 85059097284.01.9F5BAAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 026EC40008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:15:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViWKvJ1H;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8X3NP6f1tb6ECA/APcxd2Ra/6Y+sgbGOMzwFL5+0xI=;
	b=MwSzVM+sub7LD33ZaU42Ym/9q/3z2S0jb2uProsQbEKREG84CPcSY+SpMNuNOgHbYGnseJ
	NyuFNG2BV/mHshN1FbdZM42RgdlcQAVYfbBMdMKUmyVc3ateRPaqbGUWWMi5VBrGg9Wo/J
	34rKbnUjhnIRCfrPyQ6WcsiHbf6mXM8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ViWKvJ1H;
	spf=pass (imf11.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741321;
	b=5yZuebFYTic7sdh6XSkA+5jYMT6TIZoAhxFqWPuQS2zjicxWz2a5PkmrBU3cmGw43rqW41
	4DWO/as99HUQXT1jIdxJOaChwhvXBGSusaUgOfVCWzwwhBI3xOnxwUigi04tHPGiY0wFc9
	coSynu9iYWcSSFr/K3Ot+81hkNZdncs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BA0242B39;
	Mon,  3 Aug 2026 07:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1AB1F00A3A;
	Mon,  3 Aug 2026 07:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785741320;
	bh=Y8X3NP6f1tb6ECA/APcxd2Ra/6Y+sgbGOMzwFL5+0xI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ViWKvJ1HlFBgT9zzheZGicUdhe4AKPRypbeHJ6dCCBtQo+tWpReZAC6iEKc8yd/wz
	 1fFc3v1/HVqMGMkFLHBbllmVaRbNxfgOth4OdMRGC35E6vMleNCiqY5dmFrtg57OzE
	 mQecCxQAKIO2a/FN9Fe0hih30bqi18qyhxtQmwkdG2dg8RxAKYtnYxprsPV/j8Defr
	 8XsNuevPbDvqMIXndhk42p+26tfR3/I8bfH869bQV+hNIOV1ZRR5KJoVoURXURnU92
	 Ujk4yqxKpvDDv7V3k9X41/Qe0fbS2kfsEQRwgmggFrbc1VT0MCmONhO5GE6UEZQDwH
	 zr+FxCyskGarw==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 03 Aug 2026 07:15:10 +0000
Subject: [PATCH 6.18.y 1/2] lib/alloc_tag: introduce
 mem_alloc_profiling_permanently_disabled()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-kmalloc-no-objext-for-6-18-y-v1-1-8b01d1021f0d@kernel.org>
References: <20260803-kmalloc-no-objext-for-6-18-y-v1-0-8b01d1021f0d@kernel.org>
In-Reply-To: <20260803-kmalloc-no-objext-for-6-18-y-v1-0-8b01d1021f0d@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>, 
 Kees Cook <kees@kernel.org>, Danielle Costantino <dcostantino@meta.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Hao Ge <hao.ge@linux.dev>, 
 Hao Li <hao.li@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 "Liam R . Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Queue-Id: 026EC40008
X-Rspamd-Server: rspam01
X-Stat-Signature: pnmqit7mkp8xojcengno49t63eqt98ak
X-HE-Tag: 1785741320-409166
X-HE-Meta: U2FsdGVkX1/8ragY6p89ELN3ZGr9xsrF/ku4fnadp8x+v+Gt1b7T7eLXECGqXNcCP1pOSZ3oqcOy0ckVobamuflywo3sldVrp1eGwzaA3lKPCjehyOSHPigiqZH3PJgF/Oy7scqvYKjG6VTyYqTvksgX71kVck06WWTVmEuJTdIM5hP4k4Lh9wl8jNBF1raK6PgG045P1raol8HlvetqFWaUb3X04r8B8gz9tO2mc69gXXZlT2Vag1NP0vcLMJyGK6ygh7OA+AVTtWcYMMoXoHajOuu5q2XQijAcbyqFKvyv6xFKjyKT+J1FReWJHkN/0Au8VeKycKD2zWTCYK3CR2sYKwsBZhv/KxdMd9fDULwFh0PZF5+diEVB0rRNNyYf0gepb0lIJDhVyT3hIhyd5Juxuj+lsMO3Gm2cPY34QX+DkPX8MGjz8FNcwMtGIaHZ2oYuhkQl68isCdkIM1qg+TTSrRAmgNiazBsRPju5KAwN6N0qVvGDWsHnbCmWi1qetiMao/Qtm16GGBQLOIlprX/zzQfkg6WR+PomOgvLEffxspvF4LrKS3dEGSVJuCqdXxfqtf8UTVYU5yTF5rP7QQswrqd+lrMenNsVQv1RaDiax92Yvy0FUwsCToU1YfiNbtjivOFprWx3w28qVfrXkkBukTguKeHow2kD1Y4WMfuFfr3SFosF8rRzqx8il9IwAf5WVVWFqiIbrpxeEWSdXw0X0+6AjtzJRD+uwJyf0oCmpPIBiayyH87HAv64w1S5dLPa4u5txIltUYg8Q5QObza40Ipmbahf2aKMkxBrQCa92PzU9qMVRLdKFEpEEQ8/8fYuEClS7sW/i8EGe23L3YgB36Q5wukU+AxcOfKK9AIQkJ4d/WCH1JTus9XiUvrKgswOjgTgFHDLV5c3d0v3wgCrO4hNzwmFXjgqsJH2eEsUCi6FBg7xW+zoZlQcyYgilvG+l8VeccTcxD9cGsk
 2vRSnB4j
 +KKq2vABsSwSNWaPKuO+lLOf255kZBILOcrDAPJotCatRWvKOoaxs/obapqpaUf+CDKEOzoahTLgQI5S5CjQoSlgW4kj4R5q6WSFXkZT2V2BDKYFLkhP/+q7Y1IUbCWE4Uzuz1ZlaJ93YGxOVSa0CwcIP6sO8ay2AWc44D3QnjpLMSG7WXiLLDDonH2akdtCLR1zSPd0V5R9St3l8jiENvejUeGAbFuNAIKkBc2Hk+jsyEDQW4sskHQLdj+3TIxFLhH9u2bO7jauBPxW6yd8zZMusUtOEnZdMgTgqfjjeEL0+lKRfz3U6dwF+fWj5uJwoQvO+iZ/cBDYex1DQoIHebmpzZF2VCYIAxR1HCS6BLPrYOly3uYvpdtlfjufjXZd3tW4mxlvCG7Bcp0WdD22Z42dFEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit a37b0066a10aabf3c968b4566706fb866eaf9a85 upstream.

mem_alloc_profiling_enabled() tells whether memalloc profiling is
currently enabled. However, even when this function returns false,
it can be enabled later.

However, this is not enough. Some optimizations can be applied only when
memalloc profiling is permanently disabled. For example, to skip the
creation of KMALLOC_NO_OBJ_EXT caches at boot time, mem_profiling must
be set to "never", "0" w/ debugging on, or have been shutdown so that
it can no longer be enabled.

Introduce mem_alloc_profiling_permanently_disabled() for this purpose.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Link: https://patch.msgid.link/20260713-kmalloc-no-objext-v3-3-47c7bd138de7@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo <harry@kernel.org>
---
 include/linux/alloc_tag.h | 3 +++
 lib/alloc_tag.c           | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 02de2ede560f..7e7cdc7612be 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -134,6 +134,8 @@ static inline bool mem_alloc_profiling_enabled(void)
 				   &mem_alloc_profiling_key);
 }
 
+bool mem_alloc_profiling_permanently_disabled(void);
+
 static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag *tag)
 {
 	struct alloc_tag_counters v = { 0, 0 };
@@ -239,6 +241,7 @@ static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
 
 #define DEFINE_ALLOC_TAG(_alloc_tag)
 static inline bool mem_alloc_profiling_enabled(void) { return false; }
+static inline bool mem_alloc_profiling_permanently_disabled(void) { return true; }
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 				 size_t bytes) {}
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 3082d977efaa..7c6d3a086fdc 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -26,6 +26,15 @@ static bool mem_profiling_support = true;
 static bool mem_profiling_support;
 #endif
 
+/*
+ * Memory allocation profiling is permanently disabled and cannot be enabled.
+ * Must be called after setup_early_mem_profiling().
+ */
+bool mem_alloc_profiling_permanently_disabled(void)
+{
+	return !mem_profiling_support;
+}
+
 static struct codetag_type *alloc_tag_cttype;
 
 #ifdef CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU

-- 
2.53.0


