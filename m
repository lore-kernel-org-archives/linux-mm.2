Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9F5CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 13:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199D98E000C; Fri,  7 Nov 2025 08:51:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125AA8E0009; Fri,  7 Nov 2025 08:51:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0148E8E000C; Fri,  7 Nov 2025 08:51:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E428A8E0009
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:51:56 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 878D213B17C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:51:56 +0000 (UTC)
X-FDA: 84083949432.29.DD154E9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5D001A0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:51:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="hv/VOq3E";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IcTGpFhS;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762523514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qvlsbcBZ089j/NzKsFpZxKXLw4TpiqdOIdH9JEv6Go=;
	b=LS4xDlo1BWJI+wsYHa4pdg4kqT9QMzQe4MiuX/PUww+usddhA8H4ACvYuUhO8hAnVc31kP
	NrZ7bizJw/XrP4wVKLX9PGZyzAq42IRRZePQSf+bc4gCla5tCwtxyLE0Rf/hEFykP1jSdJ
	QLY4B2vZ++FIeOfkhdt14DiWsfYtEhY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="hv/VOq3E";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IcTGpFhS;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762523514; a=rsa-sha256;
	cv=none;
	b=IzfyqYt8pjdKUohp4fuycqs6TxrppNK4M4CALQdSoYLaxZy4dxBxVZ59I9nrcqLMh70IaK
	LjmRospFrMIMBtIC6Vc0rX9caqJxLFK8JzuHwzZ5l+LiuLT0GT+SZ63Y70rv6qek3CgETn
	xQ3QoNm/M9v8/wzaS6mnzZcML7mS4nQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A28711F457;
	Fri,  7 Nov 2025 13:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762523506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7qvlsbcBZ089j/NzKsFpZxKXLw4TpiqdOIdH9JEv6Go=;
	b=hv/VOq3EaIjugnpTHlyuexxWXtm8g/2kpUkHkEFcLqzbntwk2VQbs/0UADiHRwjhEtXgVe
	9m0saOZMtKmuS66+fWVSxLn8YvoHdn0DqSwX8bkqgKhL1V+eDBzv9HHlmxCsDMi4/Rb8i2
	fNLiaPvX+3KLs5VK5onNE6RPbRYJnMI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762523506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7qvlsbcBZ089j/NzKsFpZxKXLw4TpiqdOIdH9JEv6Go=;
	b=IcTGpFhS0Io25VB39gRKl5Bm2aB2cTMdBHcJp96/4WXPT1fzF1fsjhk6rcG35ZFRNzav70
	D1mjH+OKDBcGa2Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E64F13A67;
	Fri,  7 Nov 2025 13:51:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8C5zInL5DWlFCwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 07 Nov 2025 13:51:46 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 07 Nov 2025 14:51:24 +0100
Subject: [PATCH 2/4] slab: turn freelist_aba_t to a struct and fully define
 counters there
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251107-slab-fms-cleanup-v1-2-650b1491ac9e@suse.cz>
References: <20251107-slab-fms-cleanup-v1-0-650b1491ac9e@suse.cz>
In-Reply-To: <20251107-slab-fms-cleanup-v1-0-650b1491ac9e@suse.cz>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5D001A0006
X-Stat-Signature: e9nj3qhg9bq96axkzzajmk7ueryyr68h
X-Rspam-User: 
X-HE-Tag: 1762523514-131782
X-HE-Meta: U2FsdGVkX1+YCagCa6u6vu3JZR/PfiMbcDmt6d14TLbc4qQMGsuWj7gUKrnIe0+T9UJDPw5AMU12VJghGLlfuVZ0PxjtQhPPA0innf0PychERSAsgZA5kc3OhoYAZKmeA6gKsb23Dp3J372JfGSDGZtf3gmGCDp/Z9jbGB10L3CEbuFOT5jZxrJNkULwl7rms0XcXsQ5kwIAK6lvQoA9fxzFjuODVxOF1G4bhzZhvRomAimkk8SMeJGypJve/RYE55gvswXcocX0VW1PHIZ5LBgx8rZXSlUID3gblNmAQtsJG2uVWRxK/ljTWfXx3p3Sh0W+OYzh8HxBnleyyPTX2trG5Rmk2BBFH6gGJRM3EAvu/9owxhfdwpqB3PAazKZB6KWu1YlrQaF0K7yp7fYPy+nV2Jaue1djAGyfF6R6DsXL/3BQv218hs/IIWsml76Kanbj0iyPRoETmDUr5QwRAHBpL5AduSVDrLJ3mN4RSGQQxkJ1+OXKBX3VAweA93O4sHEPFcil3E2GCWOxAcWnSJm2UAfWPXnjPpmHIJQbkeQIbr8KQTXz759t1+fTKRwCEtGLjxJmgIz3CwM22ZbSf+y01knWaTWMqNtWJ0pSzZQdS82AozGgSzpkB59101L9Fv0K/fc+2TWuhynVqPXO0H4VdtT7fskhFbqjB4wJOp3XPMuf+POO0mwwfo/FXdAPzpYDHvbp6XQVN1dRfDBtgdtO9Ww9x4W8vU0+vEoH1wVKhyaC3MtwN2OFjvc5VaL/MpLaL5NIyugipRrI+R6wML+iG+cNU74XjTRP+sAdnQJz29QBHd2BWdFl2BMRLM4M+dvT2uHfw8hm2iWWB+CW3eMiRQ7DP4wnlGiCiYF3rebg/0F5Jx7wqwXxi+5vvFXKb8yBbiX2SpiILVb2OYbcNpz8dvehjZb6nEzVYU2tcbwzy/ZEkug9ub2fzBnXyuXIkvsEemHNrVILhkA+jEc
 B/XaiFlQ
 pCXcZ4W3QdZNLGPs5gaSpK+ko+Tv5xYDvdSjSMLsXGTyufV2uw4xBkdfcWJaVj9+ApxM4fr+HAJhqYI7gRMdClL6/gXaRnPWA2rpFmfvROkdvb86krMVrmPuUKs0PZ+lP+t2YcbpTY1fqVkXWneUdfpYZuDF+2Jre+tHYKfClSJifKtq/JQJPYNDAJz17DdyfigXzC4GR9d963aRgh++ZpOJmlp4/TZ3WIVmkRJan6/B59Ss7xRe0LE+SwpDDmUcTuJBCuPvTqveU0UFvzqa0nVxNEjnaX8Ghkjytr9TijN408Zs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In struct slab we currently have freelist and counters pair, where
counters itself is a union of unsigned long with a sub-struct of
several smaller fields. Then for the usage with double cmpxchg we have
freelist_aba_t that duplicates the definition of the freelist+counters
with implicitly the same layout as the full definition in struct slab.

Thanks to -fms-extension we can now move the full counters definition to
freelist_aba_t (while changing it to struct freelist_counters as a
typedef is unnecessary and discouraged) and replace the relevant part in
struct slab to an unnamed reference to it.

The immediate benefit is the removal of duplication and no longer
relying on the same layout implicitly. It also allows further cleanups
thanks to having the full definition of counters in struct
freelist_counters.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.h | 52 ++++++++++++++++++++++++----------------------------
 mm/slub.c |  8 +++++---
 2 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 078daecc7cf5..42627b87d50c 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -40,13 +40,29 @@ typedef u64 freelist_full_t;
  * Freelist pointer and counter to cmpxchg together, avoids the typical ABA
  * problems with cmpxchg of just a pointer.
  */
-typedef union {
-	struct {
-		void *freelist;
-		unsigned long counter;
+struct freelist_counters {
+	union {
+		struct {
+			void *freelist;
+			union {
+				unsigned long counters;
+				struct {
+					unsigned inuse:16;
+					unsigned objects:15;
+					/*
+					 * If slab debugging is enabled then the
+					 * frozen bit can be reused to indicate
+					 * that the slab was corrupted
+					 */
+					unsigned frozen:1;
+				};
+			};
+		};
+#ifdef system_has_freelist_aba
+		freelist_full_t freelist_counters;
+#endif
 	};
-	freelist_full_t full;
-} freelist_aba_t;
+};
 
 /* Reuses the bits in struct page */
 struct slab {
@@ -69,27 +85,7 @@ struct slab {
 #endif
 			};
 			/* Double-word boundary */
-			union {
-				struct {
-					void *freelist;		/* first free object */
-					union {
-						unsigned long counters;
-						struct {
-							unsigned inuse:16;
-							unsigned objects:15;
-							/*
-							 * If slab debugging is enabled then the
-							 * frozen bit can be reused to indicate
-							 * that the slab was corrupted
-							 */
-							unsigned frozen:1;
-						};
-					};
-				};
-#ifdef system_has_freelist_aba
-				freelist_aba_t freelist_counter;
-#endif
-			};
+			struct freelist_counters;
 		};
 		struct rcu_head rcu_head;
 	};
@@ -114,7 +110,7 @@ SLAB_MATCH(_unused_slab_obj_exts, obj_exts);
 #undef SLAB_MATCH
 static_assert(sizeof(struct slab) <= sizeof(struct page));
 #if defined(system_has_freelist_aba)
-static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(freelist_aba_t)));
+static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(struct freelist_counters)));
 #endif
 
 /**
diff --git a/mm/slub.c b/mm/slub.c
index 5f6408c9e0fd..8330e4f8b3b2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -764,10 +764,12 @@ __update_freelist_fast(struct slab *slab,
 		      void *freelist_new, unsigned long counters_new)
 {
 #ifdef system_has_freelist_aba
-	freelist_aba_t old = { .freelist = freelist_old, .counter = counters_old };
-	freelist_aba_t new = { .freelist = freelist_new, .counter = counters_new };
+	struct freelist_counters old = { .freelist = freelist_old, .counters = counters_old };
+	struct freelist_counters new = { .freelist = freelist_new, .counters = counters_new };
 
-	return try_cmpxchg_freelist(&slab->freelist_counter.full, &old.full, new.full);
+	return try_cmpxchg_freelist(&slab->freelist_counters,
+				    &old.freelist_counters,
+				    new.freelist_counters);
 #else
 	return false;
 #endif

-- 
2.51.1


