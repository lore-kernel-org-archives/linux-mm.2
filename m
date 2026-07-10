Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF03C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 599116B0099; Fri, 10 Jul 2026 08:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570DE6B009D; Fri, 10 Jul 2026 08:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ADC06B009E; Fri, 10 Jul 2026 08:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CBE86B0099
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:05:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD2C312044B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:05:09 +0000 (UTC)
X-FDA: 84972736338.09.125AB04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E822C16000C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:05:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jZEI1G/k";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783685108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OcfNZwAiTSavg4XJXA5g1lvrBpQXdABBpHgtjVCRQn0=;
	b=yo4UlQLTf+LwyDmqo371RczhK+5dB7gCwIcnwU5KCOW7Azr86HppX00zdwz8+qpwQQt4kL
	IOI5VMvSIWRt3HokKwEfIFLSI8L5eRJygVww4HRQaZvsqybrMG83PXqd3j2Oqm3d4L6aZQ
	shKCLz/b22htmhGu8xaXQJWFnnTF3hk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jZEI1G/k";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783685108;
	b=GKEZREmBxo9QxRXIiDK8IIjeKHRw5I5gUdV6VhaoHW5I9YJ1BbGwtlMvPyBeaEN4An+VNJ
	K9+I0ZA2Nz5kzW+OBshTMPlTYmWRCZg9VcZ3EYmo1D1hfSZ6nuPciQw/5fhLruyKCfk12z
	ldgwooqVlQ9zU4cjeuOi3AkSnEb/JNQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15D8040464;
	Fri, 10 Jul 2026 12:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5831F000E9;
	Fri, 10 Jul 2026 12:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783685107;
	bh=OcfNZwAiTSavg4XJXA5g1lvrBpQXdABBpHgtjVCRQn0=;
	h=From:Date:Subject:To:Cc;
	b=jZEI1G/kKg8gJA5Nys3pkg35kjwLDdfWPBKFf+6kkh5BeV+SU8CYmOs77ZS/TbbQk
	 6JpHqnwi7n5bcczPC2t0dpP/itIvCskl2eqV4rOYv9TZqQykLsdJ3DRVrPlmpsgkSI
	 RMXz3XE7BXkJuil+W3HdpBuvR44mpz2aUiN69jp2ae2O+VhAeR9Q9JXPRMgDIc9fAX
	 3XMK0u0cjgwT5D7PSL50dBJ9UtY9JiHJgltDab6OzdFwpZYy+uXaPlL/BEAxiFfWdz
	 txQ7vOUHgzlxKPCAQCzrXyj4uFXPlibx7ZwhB1/XTShbBWz0gHDpPlw4HkFiKRHHAU
	 uA+OE7/UxqLIQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Fri, 10 Jul 2026 14:04:58 +0200
Subject: [PATCH slab/for-next] mm/slab: simplify freeing remote objects in
 free_to_pcs_bulk()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-bulk_free_remote-v1-1-a878d6dc52d5@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOnfUGoC/yWMUQrCMBAFr1L222BasQWvIlKy7VuN1kQ2qRRK7
 27Uz2GYWSlBPRKdqpUUb598DAXqXUXDzYUrjB8LU2Ob1na1NTxPj14U6BXPmGE6YbRycCzHkUr
 2UohffsszpcnxXqKagCXT5a/TzHcM+bulbfsAFFJTeoMAAAA=
X-Change-ID: 20260710-bulk_free_remote-7fbe6f3abf5d
To: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Shengming Hu <hu.shengming@zte.com.cn>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: E822C16000C
X-Stat-Signature: g66z4sjrh7boes89dnf6ccgo4yj11mj9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783685107-32201
X-HE-Meta: U2FsdGVkX18jkix8DK52eZNfa6rwRa9d1iqWEI450pBl2upfcOyHQOuHjks5zjyX+Jew7fh/Y1QbsHlN3tS5oEb8Dackwtm9Krm4/Ef+5K2xV9T8yo8fKJgnj6ecbYiab+Zp1SzBe3uRjwPG6H/iOXbRmAzxHrmNI3speTQhPamqkC0E2homD8g9TSbbuIFtXgbqwTqWOMsLIEqa+Kiug0gtfJTn4AJp/KfQp3MU5qRqgzavVNbHFIKMwibfkZcIPk6R/LiktkFbZOyayapKVwiEj13x+E+HdEw9WzjHyBuTf/IZMSAWoZeK1wLf6s9tWJz5KVK/Smhe1eFQQz3aFHOlWSa8DH/Z+/DwpTZBVr1KDFO9nTiFXl5CruCpPXmZBSEqmWISr+7+qXUxgnteokXTHJNxF/DzeGuoiRSna5o2e8gCcqbgqNkL2NXE0TtJueo+gasD/3hMLCwJ+jyl96C874lsFqreTXQBFx2i/AoB1Et7OSFOg82A5ugOiveLcQGMTyAEUBEyv8GKs4MLlBXpsZNVKVtJ5QWo+pUerSpGD7fAnsORA5HQNuRNRE6sMB6Pq7g+6u2na/Z4s88ry8SBfdiu+DMFXM6eO1BA0Ze57ArFroVFhst7rvw0dX8oHK9NS6H+TV4Hs+vB0vbMl74f8rfphh7dguXWlgzKMnutTJjoWL4kHfgTH3usBfsMJAS/TXKPBtP7lkAcX/Z/0l0jUx7eGfAA2lKZhgp65jEY8QOVlqnM5frVDdrDQxYHNQIdQieGiW3OjPfJIfFC0+7vKH38QrQHOUvh8KRv/J19crxgK4ZnbwJlkC0qnzrXf6ihcf7J0/OYxwiXzbKDsvc70CTuhguH7pCjKW0WxCTgJ3f68PAElLcoz6GuEJITeVUfZG+voHStMrMrmDJhbTMXh3tev7fV+3DeLBQZDRdV6uOS3aWwullkVAD5uMgwRJPt34IQLnC7atbea/X
 DSKwAmmO
 i4XJnj6vh4fYSLfOicU/mMSDJC0PnSWmEOCcAyM+PLOTqPo2gxsF90kgwU+WjrwHCCoqQDu4p3ebjXQlPKYNu6kHwNCQUw5IoSytRByZ0htk1mP2LEU+b9dVaNEab4NcE0IwwC/7arEyul58SBRvqaRgr02uNiRHr060oO1r97Z/vxZSR/0YORoWpCaf1f/G7qNr6vpqTcSR2pTRl9ihvUdr6WGHXBsB6UN9QNnzAhPwaH3ZWQJYCCw/BoHhkcuvW8mdcEkXX5awKS1KlXEwMIb8HVuwTVpFigpN5QAK9bcV3I//IYj+Z/o42WlJjB/mwahMd0VCX+ZTDhLU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have been moving remote objects to an on-stack array and flushing it
when full. Instead, we can swap them towards the beginning of the
supplied array and bulk-free it just once.

Also add a comment to explain the rationale of freeing remote objects
last, because now it would appear to be simpler to free them first.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
One more cleanup I realized it's possible when processing feedback to
the previous one [1]

[1] https://lore.kernel.org/all/20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org/
---
 mm/slub.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 22045dc919ef..966d2fb114e8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6255,7 +6255,7 @@ static unsigned int __free_to_pcs_batch(struct kmem_cache *s, size_t size, void
 static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 {
 	bool init = slab_want_init_on_free(s);
-	void *remote_objects[PCS_BATCH_MAX];
+	void **remote_objects = p;
 	unsigned int remote_nr = 0;
 
 	for (unsigned int i = 0; i < size;) {
@@ -6270,19 +6270,17 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		}
 
 		if (unlikely(!can_free_to_pcs(slab))) {
-			remote_objects[remote_nr] = p[i];
-			p[i] = p[--size];
-			if (++remote_nr >= PCS_BATCH_MAX) {
-				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
-				stat_add(s, FREE_SLOWPATH, remote_nr);
-				remote_nr = 0;
-			}
-			continue;
+			if (i != remote_nr)
+				swap(remote_objects[remote_nr], p[i]);
+			remote_nr++;
 		}
 
 		i++;
 	}
 
+	p += remote_nr;
+	size -= remote_nr;
+
 	while (size) {
 		unsigned int batch_freed = __free_to_pcs_batch(s, size, p);
 
@@ -6296,8 +6294,12 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		size -= batch_freed;
 	}
 
+	/*
+	 * Processing remote objects last decreases the chances of cpu migration
+	 * while freeing to sheaves and compromising object locality
+	 */
 	if (remote_nr) {
-		__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
+		__kmem_cache_free_bulk(s, remote_nr, remote_objects);
 		stat_add(s, FREE_SLOWPATH, remote_nr);
 	}
 }

---
base-commit: e1fa26489025d6deac76d1dbfe2e0720a3ad84b1
change-id: 20260710-bulk_free_remote-7fbe6f3abf5d

Best regards to everyone but Pedro (btw this is not hard-coded,
there's a config option for this),
--
Vlastimil Babka (SUSE) <vbabka@kernel.org>


