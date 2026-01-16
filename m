Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23795C982C7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4206B0088; Fri, 16 Jan 2026 09:40:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7878B6B0089; Fri, 16 Jan 2026 09:40:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614636B008C; Fri, 16 Jan 2026 09:40:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9D76B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:40:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EEF7814013A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:40 +0000 (UTC)
X-FDA: 84338088240.10.EFE3690
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id AB2E680005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WOx4muwU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xXLrQM1d;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WOx4muwU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xXLrQM1d;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gOKU0T0kl+7yhz3gb2FHYxgpYP3PPC7SU1SA5tPPFio=;
	b=cz+OSxEKIYT4KTisl/9AaFr8KJrD1ghi7MzMKLupn/vzynfcIlcJ/h4sNYi9dtLdKjWsid
	rEJ4IPv86zhv8eCfhFxPoxAa5NN8xdh+a6NC0jVXseyXejEEUrDUSto0B8/hpd04FOaSZL
	ghYgTngWqXJ8UQIIL5UG8Ra/5lQlMdA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WOx4muwU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xXLrQM1d;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WOx4muwU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xXLrQM1d;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574439; a=rsa-sha256;
	cv=none;
	b=lTCnD1MM4+YyvWMhQCJiGHoMJycDjt4MCT2g/OACx7mH/3rWbiYngdhMq7ptcG1/sMgyRL
	1rvA0hseOaBVek1N9NT9o8tDCynUYWdxStOhDX0QdlPb36PAuOOgPCFZIxX0gAeqrxujiB
	9V6G9U3wXeCM0hgF1jmUaks5PU6V108=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0D0215BE7B;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gOKU0T0kl+7yhz3gb2FHYxgpYP3PPC7SU1SA5tPPFio=;
	b=WOx4muwUs5VNrGMMl+iGp6qNTHt/zCHS+NULZpOZ60mqn8cpA+h+ANefjC7gK/4bQ5VdQE
	QGrdfqMdmkmJmtMPWuxvxdG2z9dofBXhXqNmJy/6JQryRGo20hXw6wemYEl4YgPL0XHhES
	r6g2a6Mcfc9iFnbQPBGWopPawLqszrA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gOKU0T0kl+7yhz3gb2FHYxgpYP3PPC7SU1SA5tPPFio=;
	b=xXLrQM1doOZOK+z+kEfNdy9xu9Ar+wPaRQ0sxFVDxxVILn0t921o7EfXjIr/aia6HHws0R
	EvC5p14cKUiZznBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gOKU0T0kl+7yhz3gb2FHYxgpYP3PPC7SU1SA5tPPFio=;
	b=WOx4muwUs5VNrGMMl+iGp6qNTHt/zCHS+NULZpOZ60mqn8cpA+h+ANefjC7gK/4bQ5VdQE
	QGrdfqMdmkmJmtMPWuxvxdG2z9dofBXhXqNmJy/6JQryRGo20hXw6wemYEl4YgPL0XHhES
	r6g2a6Mcfc9iFnbQPBGWopPawLqszrA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gOKU0T0kl+7yhz3gb2FHYxgpYP3PPC7SU1SA5tPPFio=;
	b=xXLrQM1doOZOK+z+kEfNdy9xu9Ar+wPaRQ0sxFVDxxVILn0t921o7EfXjIr/aia6HHws0R
	EvC5p14cKUiZznBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E2B5D3EA63;
	Fri, 16 Jan 2026 14:40:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eB0QN+RNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:36 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:24 +0100
Subject: [PATCH v3 04/21] mm/slab: make caches with sheaves mergeable
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-4-5595cb000772@suse.cz>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: wtenpxj7utt3eajyzmyh3syk89ffb9ga
X-Rspamd-Queue-Id: AB2E680005
X-Rspamd-Server: rspam04
X-HE-Tag: 1768574438-708759
X-HE-Meta: U2FsdGVkX1/YnjepY2iHjCdkHdZ5uDc8wIP9jp4TwHnOrnLPyzBEAObFojqqkQft46ib+XFWYIpv6s8OBkvFAT8RqjWVMQQM0OcQnzb0jhrd90UwHtwcxKIgR8ngKnE+sMcp3Vyhi5LDACE7+3VZfdC0B6qIE3g1R/O1+IpBeCTSnmxz1o6+W0LOnvlSyhqzvh3jVyw/+gqFMwBvi5z+6PozpU16Oj36bqiMT/0aYdM5wQYDm7jc/O6bbDjDpsaXQPWI0xsCdZwzbUWYVUyWKdCymwh0AO346QIkoVukd2XWZRVgkfzax9Rl8r+sGEsW7/w0FlRt1ORSGtdND04lj5d7+uNgJqGV1TsTi3LCrjcSnRpI+4gxr8LzI1IDtPEUNFl3TMxlFdAlrmRoLKR6xpnXRQ1OsYML7nOFOmUz2ypta3sqTusyJDoia7c+fTT4Zt+4ZF+GC/L9v7WtvZToHgWwg92TLlwcsK2YolbdNcYEZhDIMp+z0jrmPPrLKbH1f2c6CGz36hlTkssqDb5Y+sqxT3NwIKVVNOfT+xT9jU5anDW9k8sWbPOyOhVxEH6kc0r4m2LGnLBV5PP9ASvFtX7yAMdziKZN2Lsvpd5d+gEGJYFOlNR9YHoR3qqi5yfr7YX+K1xTAyvDka8SG59X4mtYS3AFSEnWZuSl+gdcnAPlFXtwKR1YrzaGaJ0g1m4iwgTmXGQLYlag3ij8Osb8x7DrQeTUS5vOGr86krm1tD5JrQJcCnoYEOtMttP/zr+E/UUi2p42/OQOvk2Lzzua5GOcyfxxa5Ngrl/3+0QUGtMG0Uv5Fy08EEb4u6Rsl94VRLhk08+B35mLV0D6I7V3a9aXQCuXMJuGNb4wfLqwEP2r+/K+FYMXfckoJYbe5CU/XmEgAfITmdRMWhjJdLOkU0ChHNIbv66HkUBMqdsxls+LOyPhSQvBIxvmORFjdhSO/ZDDTR/elnGkc3rxCWG
 DNedVTAc
 QBVMjZQ5zD0PRmbv1yrRxMBu/JNNFO1BMvxLKBa/RpHJBZG7ioxEy5is3pQMAT2xbbUpM8WEMnUQdJNIKaA8OAqBzxUK0wxHVGBAeggpZllbHOzDZjHsfIO/sdtQM77RL/zi3EL+Dh572XuW2FLcC2lxDHGm7BnncrE2zdhnbqAKJQdtI2l8MAOS738GGp/VpZmmsjqxn4DRGzYOaX30LqZgQa11+zNwJOu/Yrc2R8K49sgRLvTuXUjWVZ3xbco9Enq3VFpM31LyLODk86LTDniDGIZNRkw0Su3ftAL49rPIukUM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before enabling sheaves for all caches (with automatically determined
capacity), their enablement should no longer prevent merging of caches.
Limit this merge prevention only to caches that were created with a
specific sheaf capacity, by adding the SLAB_NO_MERGE flag to them.

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab_common.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index ee245a880603..5c15a4ce5743 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -162,9 +162,6 @@ int slab_unmergeable(struct kmem_cache *s)
 		return 1;
 #endif
 
-	if (s->cpu_sheaves)
-		return 1;
-
 	/*
 	 * We may have set a slab to be unmergeable during bootstrap.
 	 */
@@ -189,9 +186,6 @@ static struct kmem_cache *find_mergeable(unsigned int size, slab_flags_t flags,
 	if (IS_ENABLED(CONFIG_HARDENED_USERCOPY) && args->usersize)
 		return NULL;
 
-	if (args->sheaf_capacity)
-		return NULL;
-
 	flags = kmem_cache_flags(flags, name);
 
 	if (flags & SLAB_NEVER_MERGE)
@@ -336,6 +330,13 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 	flags &= ~SLAB_DEBUG_FLAGS;
 #endif
 
+	/*
+	 * Caches with specific capacity are special enough. It's simpler to
+	 * make them unmergeable.
+	 */
+	if (args->sheaf_capacity)
+		flags |= SLAB_NO_MERGE;
+
 	mutex_lock(&slab_mutex);
 
 	err = kmem_cache_sanity_check(name, object_size);

-- 
2.52.0


