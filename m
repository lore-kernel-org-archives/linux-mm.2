Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F40C5C9EC97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:17:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F5C6B008C; Mon, 12 Jan 2026 10:17:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C9C6B008A; Mon, 12 Jan 2026 10:17:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8EC6B008C; Mon, 12 Jan 2026 10:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A80656B008A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:17:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BDDD14048E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:01 +0000 (UTC)
X-FDA: 84323664642.27.7828FB9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 11BEC1C000C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:16:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=viR1PWyE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MHNqA7Sl;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KrA6Fyw2WVDJmDZKCXu6ahFK/Dsl+EjYPaRIRf6Zix8=;
	b=afKIke5brHK0VuLglTJlqaA5Se7G3/cAwOmduZfOxdc5TT413WmYNnB0ergIl5PJI38r3E
	lbfpJ2+8eHcALbFyAljcABxRV7K7nBM4rywUPE2PgZvK7/K6MD9dtI6gkvp/inf4Re25Gb
	T6e2VfpyDFv2EUl0vdLoXFBwngFn3ww=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=viR1PWyE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MHNqA7Sl;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231019; a=rsa-sha256;
	cv=none;
	b=8XJLsNqSyjUBs82zRS+f8XrqI6pTsAePox78LAl8q6xtuA32PoLZZT4MFA0FBRDfWY/4CL
	WU8mgmLywGuQAQhwnvUIYIxg9sgCrj5xDzUTP23XMCGwkqdw3kHM2uHq+wFWCx9Pz0O/dB
	+EGEMCxUpVSWkR8DRN7RbYBSPe4SSIY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 553755BCC4;
	Mon, 12 Jan 2026 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768231017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KrA6Fyw2WVDJmDZKCXu6ahFK/Dsl+EjYPaRIRf6Zix8=;
	b=viR1PWyEA3I2y9RBXkTHUFEdpybyaimIOGmmoaxT+5c74ln3o4M8CIADqr7dNs2s49/DLO
	rPIVypmdFCv2XbYStysO7Jz+I3q4wyUVkS4zBt/ymQB0JlM5oLxS9zyV5FlLpZzy5IB4Oi
	haoSlZYqaECrVY5rank+ctV3Cg5R7rA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768231017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KrA6Fyw2WVDJmDZKCXu6ahFK/Dsl+EjYPaRIRf6Zix8=;
	b=MHNqA7SljFEDHwgBsaHY/qfV2Os1q2qRfud6yxlSlQ5GZCDMqxMDwoEIe0a8RME/vzZrpB
	Bew+4AuS4w5NxrCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 306713EA65;
	Mon, 12 Jan 2026 15:16:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oEhwC2kQZWn7FgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 12 Jan 2026 15:16:57 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 12 Jan 2026 16:16:55 +0100
Subject: [PATCH RFC v2 01/20] mm/slab: add rcu_barrier() to
 kvfree_rcu_barrier_on_cache()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-sheaves-for-all-v2-1-98225cfb50cf@suse.cz>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
In-Reply-To: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
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
 Vlastimil Babka <vbabka@suse.cz>, kernel test robot <oliver.sang@intel.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: 3zdboz6o95omj9hpknjnaqea9x4cfqs3
X-Rspamd-Queue-Id: 11BEC1C000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1768231018-688803
X-HE-Meta: U2FsdGVkX18eO+QwxHyL9krXyaCIEvWon/FlK8JsydZ0dj+fg2Lj5269tyONYRBlJJ3/1G7EcxhGt/mI1dMx/hvXDtAKBYz5WXezbNzMvR2b78hDMNoWxv4gX0OLDFLz0QCPPa/atuT/9KmbQI0w/X6ovf6AmfKlWbM/CUkDzVTLqet0W7tcdmtMOiPb+CuANZ5kJXUf/VUDaZ3gMyBVYkOBNR8FHrqQUVoKQUjH7lG2sui57ConiUu4J3A9CB6IusCDb2ZkY+2sGW0A6uCvRr5vc/B8hMkl2HXK32hhvGHsLwlsZLuI+DF0i+isEbxnVV/ylvaNKy9Z4dTgpEmEPvraIqaFSIVPMMZ4N6sWrWenjjnYkiKEypDppGK3EhtZo19ArhfKf1+6WnOsrYnuCj+LDaH3hKE8eMh2AHiEdj5pwKyEBtRvHk5YQJCPVlPLhvzJQe65SlTiD7kplYgfm+1BoqYU275ElihmyDOh8B+17LNNCwXESsILTQv/0jjXrg8TOJGcweoNy9nLOggBNwkTVwKJ+vIIjV5BzDJOeLveUdzxWAPkfPuoBvOLq+ya0LoTlDLT88trtxLe73JdXx5bBb0QW0tAoQrW0p1kwMOYCXHAbWVJVx4T2l/sc0bn1zGymunKZa0qW+lHqwkjRf64NpROYbSOQ0lRnEvof1yeHghi4ATSw2x2hArOzZntpHRIzMwE6JdL24VDA6QR6sgB5VHg59QCoSYi/G7ujTCUD+TbrTg9+cRQ1pO6iMxXg2AxhtBEOgdVi59y2PzqlLgS4Fow+magE/wtPWaCI8Ea1gKFOk6GYgLVQn/RspoPBcPS9vWNXRylaL2FN/ilQQXQJrW5j5gDDClLIK83U8Y9EWnViaGNeseNGQjxB01JFthOOW9t1ByGCPfkrTLe1+5ASk4INRBf/gGZPU2w98Cicdqhso5oIY9YUk3a83BMMgQ3hh2UrzPJcIi0ZK+
 Nld/pv63
 qXdQA2TnfE8vYJDciLJbZxi/sisu5B3CRmdVa/4V3haFE0uVcSXfbsmbmud92wiF6H+VCrYqe5cXIqB2DHlo5hoVWZ+GiWqa/BjSsuvaSpNGoPSwVl0oI/qJTpBHoHoYvLUjJTmv8l5S1vmjB/Y3PInSMr5/WFeTmstxeW88qc+TyjlWsIgrbJzLi4hA+jKZUUi5welEzGKPzzeiNNMzXEeeBGP3B3ftE6LXquWpD1YBSEkexthhBI3D7v1uUUArent3DkNHeZUJoODmVG+FMNHEcD9Xx7RoKApjmtJYnZonJD48xv8Mt2wpSxOSnHE+CCYPNihe87FRSYFZMfUXgDq4xVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After we submit the rcu_free sheaves to call_rcu() we need to make sure
the rcu callbacks complete. kvfree_rcu_barrier() does that via
flush_all_rcu_sheaves() but kvfree_rcu_barrier_on_cache() doesn't. Fix
that.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202601121442.c530bed3-lkp@intel.com
Fixes: 0f35040de593 ("mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction")
Cc: stable@vger.kernel.org
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index eed7ea556cb1..ee994ec7f251 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2133,8 +2133,11 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
  */
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 {
-	if (s->cpu_sheaves)
+	if (s->cpu_sheaves) {
 		flush_rcu_sheaves_on_cache(s);
+		rcu_barrier();
+	}
+
 	/*
 	 * TODO: Introduce a version of __kvfree_rcu_barrier() that works
 	 * on a specific slab cache.

-- 
2.52.0


