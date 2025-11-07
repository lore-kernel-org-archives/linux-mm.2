Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12BBDCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 13:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67E3B8E0009; Fri,  7 Nov 2025 08:52:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655A08E000D; Fri,  7 Nov 2025 08:52:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598DC8E0009; Fri,  7 Nov 2025 08:52:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2408E0009
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:52:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E502D160354
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:52:02 +0000 (UTC)
X-FDA: 84083949684.01.B1EA6F8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id B33C94000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:52:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="fYxK1G/W";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TGWKXhah;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762523521; a=rsa-sha256;
	cv=none;
	b=pQr4sdwiUuOXzW3EoZSDwk76A7DQdiCPbLsssSCPuxhfVksM6xJW4YQwlcunP6fUvyw8yO
	taSmPm6+1/Zij6RtlQf5xs6E4MWAjZ8IIkmdszKVJZegbWXG9wzCgYxRc6L5mQmRU9ieH4
	iQ0t15LdNixdjeydUuUdNlGOO0oAyoQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="fYxK1G/W";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TGWKXhah;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762523521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpbVwPnigYZBYPBD0v1fEcmXhvJqKrRei+EvKd6N3nY=;
	b=Ixu4z84o5d0gtaQhEJHc1ghaYdL3lsQz17Vd8/MEzvRuLwpW9F5skfXX7P6D5v0KZ1+M68
	bFCFPPz834ac2zSeVe3yuYcFoH3Fjqmygd2TvCm07zv7RBT+MLKpIB4raVUWkeozUq9W3l
	qM6WeiJaYtUWygI9GfbvdWQbVwBTuHc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 93CCC1F395;
	Fri,  7 Nov 2025 13:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762523506; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DpbVwPnigYZBYPBD0v1fEcmXhvJqKrRei+EvKd6N3nY=;
	b=fYxK1G/WAs29MTQdyG4dByVDgnPXCPDtfebWTTPlRWgieWXFzAFXw5gmwUHNimGlMgfOTV
	2r86Q1/yrh36ncnuN6hV56lyUwNj9a1voTpQbsiA4laNyWs7Jdf+SgWB+79gG3jcoLEEqq
	tf7sjPmO3wXCl8lYtteBzP0il4wq4RU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762523506;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DpbVwPnigYZBYPBD0v1fEcmXhvJqKrRei+EvKd6N3nY=;
	b=TGWKXhahJY6XQ/0Q8hvOY1jKzklVoLltGsdlgtHSsy3J5hkAgZl1Rib1VN2cDJP4cAnpGI
	7BCDMGm4DtQ4hzBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8053513A60;
	Fri,  7 Nov 2025 13:51:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yP8JH3L5DWlFCwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 07 Nov 2025 13:51:46 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 07 Nov 2025 14:51:23 +0100
Subject: [PATCH 1/4] slab: separate struct freelist_tid from kmem_cache_cpu
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251107-slab-fms-cleanup-v1-1-650b1491ac9e@suse.cz>
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B33C94000F
X-Stat-Signature: 7sgny61zc9rtcjqqzuqh5jqonpg6w8po
X-HE-Tag: 1762523520-35809
X-HE-Meta: U2FsdGVkX18QPUof2GO7RwJftfDR+kZ0MvfwkmxcOfaIX9yasO3zFt0cC66liCE9BLbRiiONFMbKO2MqS77rjU94F50A91+/nhaYQg0kO1jYca/bdNCKRqSU1Ii8hiqvVoaY11n5i/FsFHBH5FCmLKD2JQ0yHBS6Z+SGzbz5vCXQq7PGqf2r55AdtBdyZIj4LYyj1EQmsgrGlxZnxTHmQNL3D8o3TJsw5iFytm4eT120tPfW401FO7htEVAGxKy2JxOyAjz0Mn8fH99bTQo2Yy4JgWf5MKmlj2ibnQaGuAgzkpiBYcnFf6wc9N+drEXrDxHtfiUXXShpq/9TEYJocU8tQacnoIKa5pT7HK/ms6K8jehTa3SXVUCBbF8T+09BFnDXX2XCGjPUV3nDbQ487rcrqyLr5zWSeVwBePqJ+YGNcABlNGe3yoQYZ7w90SJE6Snd2benr9f8T2BuZNU9F1Y0eVIpRehljVGDDcU58Fwnd1OfNyame4Ndvc/mCeooQNXL/vt6VpD5L8O1vN37rl0cpnw1bfd8iIY0/q8MPeU25Aj2bu4v4O267EqijxLOZF+nvxTNlWqcyMQFizt9QKZ3QrjueLqxR1bQrniav/1j71oEkSVo2yOTHqTu1sIg9uYcy21XoxHjRByd81k9UDvYv+EnBbo1A0Sqlfmr+kgynZNyybU/xZ5a87qvz7fGx7Qit/x86ahREKlWQqxrRoOL+2IFijqME4o8pzrOKbU/2+rB+U4XIk4zDeuzl8U9qhbNL+GRXQZytPv5HnxwMQnznVu0kgeCmim9b4pF4ksY5l0hJVd4YyYWjBXozRdIWWtnk6y+sV3UDwzhYIMTH3koqqssMYz4wsohIQEmpJ/Ayd36F9yq8etcnihJ6cn0A7BF6Fdd5JSpOCA2WT7HCULQkj3P+U0H007uc+Mf+L5zKxynqj7NQTbXjgKhFi9BO9rE0lARghciqTQvrZx
 BDqt+KWz
 5DGyODpKUUKbpsxdlTZdo8uptE5tfn/u9w+Cek/h7MZt+2cdgQq6z8ciirGN5/hNjZ+1wRc0O+ok9x/Za063myBah2gjtBVdit46Ie0Yjlik+Y9HITP7qbcjMGETfrXg0MVk0J96RSehp4Z+UNbJVC044i8MzLdMATi2/Wr53tY/7YLGXcy/njWGDm+EsylxBDidVHYIKMuO0YhYZw2dfGyugMm1AMmglBnoMGgRYaPs+52zVPyXBXUESr+6/ZQPirpN/TAa2qsRtNaamPGSwIIw7k+CjKM8v4PKbG6D/mB7Exec=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In kmem_cache_cpu we currently have a union of the freelist+tid pair
with freelist_aba_t, relying implicitly on the type compatibility with the
freelist+counters pair used in freelist_aba_t.

To allow further changes to freelist_aba_t, we can instead define a
separate struct freelist_tid (instead of a typedef, per the coding
style) for kmem_cache_cpu, as that affects only a single helper
__update_cpu_freelist_fast().

We can add the resulting struct freelist_tid to kmem_cache_cpu as
unnamed field thanks to -fms-extensions, so that freelist and tid fields
can still be accessed directly.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 074abe8e79f8..5f6408c9e0fd 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -411,18 +411,22 @@ enum stat_item {
 };
 
 #ifndef CONFIG_SLUB_TINY
-/*
- * When changing the layout, make sure freelist and tid are still compatible
- * with this_cpu_cmpxchg_double() alignment requirements.
- */
-struct kmem_cache_cpu {
+struct freelist_tid {
 	union {
 		struct {
-			void **freelist;	/* Pointer to next available object */
+			void *freelist;		/* Pointer to next available object */
 			unsigned long tid;	/* Globally unique transaction id */
 		};
-		freelist_aba_t freelist_tid;
+		freelist_full_t freelist_tid;
 	};
+};
+
+/*
+ * When changing the layout, make sure freelist and tid are still compatible
+ * with this_cpu_cmpxchg_double() alignment requirements.
+ */
+struct kmem_cache_cpu {
+	struct freelist_tid;
 	struct slab *slab;	/* The slab from which we are allocating */
 #ifdef CONFIG_SLUB_CPU_PARTIAL
 	struct slab *partial;	/* Partially allocated slabs */
@@ -4367,11 +4371,11 @@ __update_cpu_freelist_fast(struct kmem_cache *s,
 			   void *freelist_old, void *freelist_new,
 			   unsigned long tid)
 {
-	freelist_aba_t old = { .freelist = freelist_old, .counter = tid };
-	freelist_aba_t new = { .freelist = freelist_new, .counter = next_tid(tid) };
+	struct freelist_tid old = { .freelist = freelist_old, .tid = tid };
+	struct freelist_tid new = { .freelist = freelist_new, .tid = next_tid(tid) };
 
-	return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid.full,
-					     &old.full, new.full);
+	return this_cpu_try_cmpxchg_freelist(s->cpu_slab->freelist_tid,
+					     &old.freelist_tid, new.freelist_tid);
 }
 
 /*

-- 
2.51.1


