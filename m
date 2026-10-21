Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF2E60A4AC9
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GGZ+kJM0
Received: by kanga.kvack.org (Postfix)
	id 39C906B06E8; Wed, 21 Oct 2026 07:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373B16B06EA; Wed, 21 Oct 2026 07:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175CC6B06E8; Wed, 21 Oct 2026 07:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E25AF6B06E8
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:48:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC0AE1404DC
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:48:14 +0000 (UTC)
X-FDA: 85346460108.19.5A28926
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 38AAC140002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:48:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GGZ+kJM0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxQm9Utiw9ju7W33QEdNT3UP6e3902Yp5TQgdUDZVi8=;
	b=NQqd2mzpk/iVd4+ABGil72kKKwdfxk5ODitCTs2x4CX+XRymBCnkhMmhnHw1b4NS0A6Mky
	4bnXfwQ63lYIAoldLwWKybF7oFu93lp41vI4sCNX3BgaDueDltr+Gnz4haRN1WE0Z1+4rr
	yrBDsWXT+yfe/JPCH78/l9Tm7Ubd6HU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GGZ+kJM0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583293;
	b=IDpz4xUMGnrmKlNR5Ec/0pAjh3r5DsYMRVHKhO2nTg93KO2GMINGRAbxZiaBXpRWOnnzQy
	dyPVg4+aJ2zDBOkW8AUXJM1bwJ51FZB0h0Ynt/Y5F61E5nz9c6zKQJIMgmmdHOOGy6QcGw
	uzC/uDcoYeFfYAi7UggwWEswlRZs+gc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 875EB44506;
	Wed, 21 Oct 2026 11:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7AFE1F000C4;
	Wed, 21 Oct 2026 11:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583292;
	bh=NxQm9Utiw9ju7W33QEdNT3UP6e3902Yp5TQgdUDZVi8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GGZ+kJM08hfM1lBWxUrfgYvioC+cAsdaU4flddHkzp5af345rxmboRfwbl7SUH4BX
	 K7GUNWtrEE5gFO+BovByE7aty+pTU2V6Y1U38UZfiYkRLfI6obMLkUsUY00sgbiBXK
	 hpddfh9CqA5lIi3KL0aJP5rDARidSBM9GLkniGYNanacj4u04n8rVd7t83JlMfdPrK
	 MGbSiuyweLdTv/vpHmO4gJJx6kj88deUP3hsBmbCivvLOqNfCetcBevHh6WXLU2l9z
	 WK7tO/ui30o9cuuzrCQftec27SuvHwDbERUM2Mm8LqUOa9T3KXnYnkaQRHhoL5x4r8
	 ww9uDCQNeC8EQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:54 +0100
Subject: [PATCH slab/for-next 13/14] mm/memcontrol: do not allow charging
 objects without SLAB_MAY_ACCOUNT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-13-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, cgroups@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 38AAC140002
X-Stat-Signature: 6fbagmzyjcm7kbomhww3qb3on9qf7ph4
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792583293-441213
X-HE-Meta: U2FsdGVkX1+R8mnMQM6VD1lS4lYmGsHelf5YVHq+qUC67eVyqHRYq/YPT4GDAp3KYCY5c0fQ3ZMk7su+P0yM3CCoE+WBJyLCuvnjFlIp563Gs3dr7oIOprAYofksgqRHItVLv2/JUju5r9xO3SayywnjO2AOi2kw6lr4kpUIINF/5htTRyOArriWVfnQ4K0QNfJYEaQp5AOete2luv/9Q1GC6F2d06/negfR2I0lydGUEu0tBZQdTw8O5+7QfWcWgK9UW112bhTzep8ADPlXveAXwn9ZTIElzZ8k4YVT42GsCVycW40wFNvCSgyxyFQ+c60MI2l+Izj0bq/yXDpup8Vg1sKj3w71rQJsj3UyacaM3bfTYjYkIMjOCT0tyxUYdzm2aJgSZnDuvgglT32HR5MFUx198hLThgXlM6ter8jdHyQVIehZDBSplDWSbLZxeNrVxZK+Wzf73WU4lRsMZXXcNpisHC7dllQVC39itFEI+ranTjP7Tx6zwC74WwGgnrb7Qs/+2bD2GMqPSHe/uG4IyzIf6hLnVNbIKYk2FN+HN1VCwb/g0dah9ui0LDLRTDWGHBPIWD1rRg+dIHzUMoY90uH4WZnrrIKVPspEbQ2bCCN4ea6GIIC1ELr3mwFjSpxDRxQSEi3XqL32IxzOFcqtjn5PRl1HIi1beFVCFgGFKs0p/uOHfus8XnVpHE6/2BbnrfH+FMSlaym2BZUgwRnlpO5ks77XhGncWFJ3kudiNR/aqFCOeiEevcCi6OKNImQV4jQ362pp3kE+xuZTgi0ZQ1JYfGh5ysC5jjNGtDgm7IZ4RuzPOTnidSMdSf/4ur4ULb4fKwoYICSCUL84hk0nhXN0JxzLQ5GX4+GVU7ysbqlG/VVts5TFvLWx0WlBRg1yCjgTwCX9bKiaCFrXmuO/142fyPLV4Dmu/ln5W7J8v9ECmoBfB7deEmefeY3foSguG2AQp83KsFXpVcp
 WACjeMvK
 d38xgxbOzj9a69F34/X/faCyCfGvXhv1PYLrkitpObzErLiEmdm/hINfFH8FTEkMtk2m3VzFUVgVsGfIlCefStOzBOcncHznFIwb6FChglZZMyvhcjwt9BiIRyFAp7uBr3JmZ8HxQA/0zQ9rl5KAa7Dx3xVY66o/A65Q8IyH6+M+5gBICUmGBozDboEzCdowPlD9/HYwtVlKx0/KCNn8QE302Y+Zx6lGKiwTAu37rzrUy/LkcNlBziQkpgwxbDV2bJ1L1NSIcIWkAdp6q1GV0e9wm+oF/yapIeYL8Ug6F2JKSn2JXPlZG3CfjLEmkKnHx4EFs0b2B3kji+gahNcuszfXtYPeSIHr1+cv4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Objects of a cache without SLAB_MAY_ACCOUNT cannot store the objcg
pointer once slabobj_ext space is no longer reserved for every cache.
Skip charging when __GFP_ACCOUNT hits such a cache, and warn once under
CONFIG_DEBUG_VM to catch callers that did not opt in.

Refusing the charge here is sufficient for correctness: an object that
is never charged does not access the objcg slot again, and the free
path already skips such caches via slab_needs_objcg().

Assisted-by: LLM # Changelog
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..9f996206592f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3622,6 +3622,12 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	if (unlikely(*p == NULL))
 		return true;
 
+	/* Do not allow __GFP_ACCOUNT without SLAB_MAY_ACCOUNT */
+	if (unlikely(!cache_needs_objcg(s))) {
+		VM_WARN_ON_ONCE(1);
+		return true;
+	}
+
 	flags &= gfp_allowed_mask;
 
 	if (lru) {

-- 
2.54.0


