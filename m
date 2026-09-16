Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A1DC982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 19:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B70F6B0093; Wed, 16 Sep 2026 15:52:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966926B0095; Wed, 16 Sep 2026 15:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87CA96B0096; Wed, 16 Sep 2026 15:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 638736B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:52:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9021A350D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:52:37 +0000 (UTC)
X-FDA: 85220672754.12.9A1FEB2
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	by imf17.hostedemail.com (Postfix) with ESMTP id E484940008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:52:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PxPEBXuP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PxPEBXuP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789588356;
	b=k6UgoG2nQrvX9bWB/NeSpcv1ooFxCvLco6Pm6+q/3JB5Ql8xF9qp6d2tzk0cXQFj/xrHhl
	+XroStpVYeSpXv2W5d7aAtmxORdQjWCxBOGxulVbtRGELqI4MuMAOjb9Qhfsye/gVkxsJ+
	Dic+hZmjwZEr74Slz5y8En9WZFTxLBg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789588356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpCaDbmjKMeHx7J89KXCbEJQfyMBJpf7EOzjHqerf5I=;
	b=zMSwwciMm9kFVwIz2ye2Luqm8TYAb+2TxZlRtip+/tfd2KBFNQgWjpwEThQV8BOqym9hY+
	AU4Jee3ko7ncIEoYyoNVATIIo42ma8mopatEOnHmymXcjzXg9OQpVZpm0sRLeiszx508n+
	KmR3LiAuuA1VqxSE/tqvr3MA0ZB4XL4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uezm5MFaGZMNvW+locU7R+duzoa5ZNNuKXadO7AJik4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789588354; v=1; x=1790193154;
 b=PxPEBXuP1a0yKQW86JkSiyLOtwOD5WqldVHkYt76++OiT/AprvVmI+8fZ4gXHz704tn2ipjr
 ZvQYjWiQoiXq8J4+ez3qZMy9gKyKl3YM67sNSqPTPXsZQAmdZMLAjcz+TnsYMer3iaB5pBg62rO
 S4Uwl0ZYK0n+ThOSse1/W0L4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id d4694686d251f010;
	Wed, 16 Sep 2026 19:52:34 +0000
X-Mizu-Trace-ID: d4694686d251f010
X-Migadu-Flow: FLOW_OUT
From: Ihor Solodrai <ihor.solodrai@linux.dev>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	bpf@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v3 2/5] x86/cpu: Initialize boot CPU cpuinfo defaults early
Date: Wed, 16 Sep 2026 12:52:00 -0700
Message-ID: <20260916195203.1099646-3-ihor.solodrai@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916195203.1099646-1-ihor.solodrai@linux.dev>
References: <20260916195203.1099646-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E484940008
X-Stat-Signature: f776f5peai5fk55543fz38u6hriw5zpi
X-Rspamd-Server: rspam01
X-HE-Tag: 1789588355-186833
X-HE-Meta: U2FsdGVkX18wpFMuWip2ewB1LJKrZhPPn2hp9pipSphsSk8S6+hdBEzoVyJkj29souH0jmLzsOeRysp7P6J5AC2DVfzqsfIvwLmxkZ3TII5YbhoW/o7cedG9Cv9UpPVg2AAZEixOVGIyNzwpkbgP/JxaOqEZGfLINcSCkJkOx4rYlnHxFVtxV7mDr9QPVW7sosgzx0dXELcL7tWKTvseZrZejTJf84CpSOQinv7igR5AqSrXCWFgvyaYiq4z+5o+2zFgozWQNzwWLxVKvSVvzS2xwwGmIdxNkUxObh5n9J2B7IgmxWXVM6YLUbE6gvjvniy+yG5BCYnxpc5xlheF+rnLu7tRiYZnFUIE748Ss2aO4ty4TX+fvjcjuGy3SvscF+bvSQJe3UKLECw4QNstGYCV8hVN5EkEeN3A6XLtSDrSigtfDldW4mdlwZFyVHPKmpCFQRS3wwX7IaVmhLgTfHcGeurvI7pojI3OAHmEiedJLZO00jic8Xz78MxI7/9gniDL5iVXVxZKGIPWLUjh0elTi0TSlB0ADk3puWlOaA2gcGohvCg/vydDYr2NGybjAtRlLXfj9b9JAbSLZnKgtH7otOHBO2bV3t/sLVxaWat3dZ+XA8DqTBriT8qeZwVGiPCAPLTxg9bkLUeF6I61Oe/VBSs+D/8BGac/kh3Mf/OhjzAJlI0m19vwaainkHL7WdZVqUOa2WnjZUE9ZFjy4n1qiu0X6SlLcHxXcA1JEMyqZtxHT4YuORo2g+2gwBYR9a0f2pcC22Y8ubAP3TMqzRPThUSJGGJAQ8nH2FS9UQxjsTP4+P2USkx7B6QduQJ9vhLqaSrqdVNgPwZ++5yPVtWfxfc5/wYWMGkde9myO23ogIO29F2U4ngDGCRa7oOnY62StmGTT7/R6UW3meclnKCiqG21vvoaO3HH648fXNYB/eokONdS5R1x5kYn+dEttWxStk1Ny3zNFhi59DI
 HPOjvaKv
 OplQm591JILNV7TaARqqYOLP4bSKfdBjC82qn8gZIfB556nYLymgxTwug1fM+Lb9SPxVlJSOnmk+8YfZiLeTgnEKTX6aTL0VW37wyifSswsH/l2m/jzbp6ibMQao2MMlEMmGvREiVNs4lgNjTJs5/h2jXocfW5rZ/rCqTLjHNiS5Q0TZ4yn/orzenKOYlOUmsmlYkb1xBNLRFoUmEF07Kvsp6cQX+ixczGmSYMzdQJzra7EmTCqG/qAp4/fFJ6rvvpOo35qRpyPpP2GhU+rp9G1ekWthbeixFCoxaFXLokukRHKlsdez2RVV2AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

early_identify_cpu() clears the capability array, the CPUID table and
extended_cpuid_level, but the architectural defaults for the rest of
struct cpuinfo_x86 are set only later, in identify_cpu().

Use the same defaults from the start, so that the boot CPU does not
depend on a later reset to end up with the right ones.

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>

---

This change comes before the last patch because that one removes the
reset: without the defaults established here the boot CPU would be
left at 32 instead of 64 on an x86_64 CPU which does not enumerate
CLFLUSH.
---
 arch/x86/kernel/cpu/common.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c3dce89ba590..66695addbdf3 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1812,16 +1812,15 @@ static void init_cpu_info(struct cpuinfo_x86 *c)
  * Do minimum CPU detection early.
  * Fields really needed: vendor, cpuid_level, family, model, mask,
  * cache alignment.
- * The others are not touched to avoid unwanted side effects.
+ * The others are reset to their defaults here and only filled in later,
+ * by identify_cpu().
  *
  * WARNING: this function is only called on the boot CPU.  Don't add code
  * here that is supposed to run on all CPUs.
  */
 static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 {
-	memset(&c->x86_capability, 0, sizeof(c->x86_capability));
-	memset(&c->cpuid, 0, sizeof(c->cpuid));
-	c->extended_cpuid_level = 0;
+	init_cpu_info(c);
 
 	if (!cpuid_feature())
 		identify_cpu_without_cpuid(c);
-- 
2.55.0


