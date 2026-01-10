Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA623D277CA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162536B0096; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A856B0093; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C663C6B00A5; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72D416B0099
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C72551986
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:02 +0000 (UTC)
X-FDA: 84314703564.08.C8B6D20
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 50C9A40009
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Ph0ALkCK;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUfjq/cQTQJkqeTRHOq+fL1zvjNTzJMLDYauRTOdnO4=;
	b=Mxk1F3OYKwRDCKYirQ/t5fqmdoyFRIgdDyEBYotth0H0p9qG8zdPW3TCkLl9TKYRUOhFoa
	4KOEEofHBI5jJFXyQOFhhm/Q+DLc/rLrREblwOjsLcrKKC4NJVslJA9Fy24nZEIqw8hMpS
	pDzaB32kKu9dZbkXlBddOoLy0GDXcXk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Ph0ALkCK;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017660; a=rsa-sha256;
	cv=none;
	b=1bShTLA3BlMB1T0D6xjhKYGN3NLnpS9DNQXRvVrSWIUGuJRhbIeeKelXb73vctKLVsqQzs
	X0eruce8887VGTZjXEeuJ75RiEVO0Ud8WZItMH1vY0dtI5VRJPlEnQx790QG2oosD247UN
	HI0/FmL/2bTo5gQeQdNQInW5oliy9vA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yUfjq/cQTQJkqeTRHOq+fL1zvjNTzJMLDYauRTOdnO4=; b=Ph0ALkCKCYTptUv3Vhh2Nuf1mQ
	UzC/xvzrJz+R3J3N/IkPvbgNT1VUADc/P60p4M/p/Tfq6b9AXo6PGR3Of00BGb+nbV9qVolGywIbS
	4qlo33yOoLuLmpyw2pOMWqa7n9v2oYj6UNpSK8TyJ6IALmXPL1V6S4wGvXIRu3c2PHMAszgXra1Zx
	RDyZOAVhrtqim+rwGW5UZwP8r462a3XK7qSyBsjUm18blsC9tazRwWxQ0q9Xo3rZJ1umbB3Y4ABzA
	Ng6Ot50qgrd/rdusNTPlFmP8ns+Dg58Djbg2pW6P5sCBpbxN/X4RCmKJDjInPW6qJ88rFRRYXE8Rh
	V7y4NNhA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB9-000000085Zl-0In6;
	Sat, 10 Jan 2026 04:02:19 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 07/15] turn dentry_cache static-duration
Date: Sat, 10 Jan 2026 04:02:09 +0000
Message-ID: <20260110040217.1927971-8-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bfgafrr4orm3w8ugkogazzb1576gq37w
X-Rspam-User: 
X-Rspamd-Queue-Id: 50C9A40009
X-Rspamd-Server: rspam08
X-HE-Tag: 1768017660-220284
X-HE-Meta: U2FsdGVkX1/e2+tqaJuO8sGsbHYehbo68trXOrZRLOzBceLicmgezHrtEdpukUlc+ePLvIHSazRe7uYxk7OYee9L0Ngbx60VOdCBmQLqgL7S2nJgoolExU33am6/YMxXC5gPUwtQQuRCaNe6WKpDpV7ej3kx+llNtCVoTb0GlWnYN36pw8zI6JwvTrSbtsq1PD9ZLqnqzs0DsIOebMyBl9lJTrnA2wnNVjNeoTF7npJGzGg4nfV5ZAVMJpsCXC1+BnyU0e4ODgYLNvd5aHEyUijAS9sUHZzfVpSq3W/JoS9Lmk+qusYkwQ/1vnJpGICqTU7e+MZ4tux3FbpyhIDliQgJdL+PV6fAE42Oqw9Yb5Pzob2gh7IDycZcKC2CSw2NtV+VQFFiKv1kNVR5H9WZL+U6Mv51ZCcu/Zofu0P1U/W/pqyHSGqUwh+5jQpqLAE9krHf08DkHBCPgpNOFYqFbHQS70IaYYbJSbcPExKHXO1BRnTS8+Rrpbjap9MQV6riKrf+PABxbayFENtcM3hJkMj4W2+lzDFgQTWn16vF+ex381pTJpo41sto9Ai5s7GyUWCw5oM94SdgsJx2+iPGSHlPDFWbliZeaUhcI9NTYUfD6O7HCua8Uqsw7oPUA6ulIXrCPFVfUU/PqpvpLCu4q3AlqcvrHtAd++9SHWyWJdwB9GgC/hc14At49hXTJXnyWsYE9zBxPOezH3uVPzR7cVVH1g1jcuRnfHjBdZdN1m++6OY0FX5N7FuoqDKPN6WaLHJlAuGTal9qSQKsRnLwEBv0s1PK7bm7TEslPpv6tZ+gOsnfdohqMOnW/xGhGTEh2LgsE2SvEXsRGhG9e0mP7BCk7r4CZKEOZ5pztrH4lBO5dnvz7A9XRUMDdd1/1Cv2P2Fm9KfoBmbNGMSIfcfHJ1yz56u0CBgKbRScw9hdVbwTMoIbsJyZFZokMMk78NPCEI9JNRDtTW+NwSoepi+
 JrPYbuQ5
 0w7oTJUiodZcnCVKCj0HLiSm23ywO48CR0J2gEToptieXJ0x9n6Y6RSG6A2pkfaU91sUUGrp32jIbH5OabkmuQTWIoMGphUZj73TllbioaPdaqjoepBTia7xngAk6jaZjNJb8OOOYdVqBLWpPKovcolkIixoloDIu4SJjw+jJL0l9sNAoofzjnlPPYPR5U8FT7PXOHmY5hmeIBwfcB/aHIvoB7RT5+LHPr91fiuFMjvNXVCiLbNGhNQKv873DUCQ8HOQLMdFkNVS87rIiBpf5qaMp9/zk1fo4tYEtbSuPeVvaHeA+HAe8yCt3DsDpC9BTno0C+Aod7gDD4Lt9YTEl2PN5cuDgeSCA2+YN3RiEZ9X51fGVmV3bRh6SARVslG2P2YwWRbcuNsm7v8+v1nft8UZx9HpsqXzvXwE9/wTV0Qnk0iJknS5PzL1Ng0YEy5XWcD1zS3oJPmsjRHWKs1n+PtjOOebz1X8x8KoMi4qX0Um1iGPTm76Q4LUixwhDfSU4u60K3c0wZgVlx9ZWkAc8wk3rE1dNHi9o0W4l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No need to bother with runtime_const() for it anymore...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/dcache.c                       | 8 ++++----
 include/asm-generic/vmlinux.lds.h | 3 +--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index dc2fff4811d1..43d3b4fbedcc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -32,6 +32,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/rculist_bl.h>
 #include <linux/list_lru.h>
+#include <linux/slab-static.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -86,8 +87,8 @@ __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
 
 EXPORT_SYMBOL(rename_lock);
 
-static struct kmem_cache *__dentry_cache __ro_after_init;
-#define dentry_cache runtime_const_ptr(__dentry_cache)
+static struct kmem_cache_opaque __dentry_cache;
+#define dentry_cache to_kmem_cache(&__dentry_cache)
 
 const struct qstr empty_name = QSTR_INIT("", 0);
 EXPORT_SYMBOL(empty_name);
@@ -3265,10 +3266,9 @@ static void __init dcache_init(void)
 	 * but it is probably not worth it because of the cache nature
 	 * of the dcache.
 	 */
-	__dentry_cache = KMEM_CACHE_USERCOPY(dentry,
+	KMEM_CACHE_SETUP_USERCOPY(dentry_cache, dentry,
 		SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_ACCOUNT,
 		d_shortname.string);
-	runtime_const_init(ptr, __dentry_cache);
 
 	/* Hash may have been set up in dcache_init_early */
 	if (!hashdist)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 8ca130af301f..6997f6301260 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -971,8 +971,7 @@
 
 #define RUNTIME_CONST_VARIABLES						\
 		RUNTIME_CONST(shift, d_hash_shift)			\
-		RUNTIME_CONST(ptr, dentry_hashtable)			\
-		RUNTIME_CONST(ptr, __dentry_cache)
+		RUNTIME_CONST(ptr, dentry_hashtable)
 
 /* Alignment must be consistent with (kunit_suite *) in include/kunit/test.h */
 #define KUNIT_TABLE()							\
-- 
2.47.3


