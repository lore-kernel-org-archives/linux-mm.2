Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F73ECD8CB9
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 06:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10EB6B0005; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B74B6B0098; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F166B0096; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E29C6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C0DCA04A3
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:39:41 +0000 (UTC)
X-FDA: 84866680962.09.9C61CB9
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf21.hostedemail.com (Postfix) with ESMTP id D9FD41C000E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:39:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781159979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ziYrbCc0tttSm3dVgSOuHm58V6NUOSlJOb5IeQ9InMk=;
	b=zm+H5f2nrdEdFhleBg6CF3Smb07hADNT2e7K8WaqW7YLg9gGqY45z8zs79fuERRsNlTpDj
	nTnbPfulB5najzVBOdqY4p2kfs4EGgbmaJXHWWysUQfID0SGbk4SfLMedpzih6DZMg8dTp
	iLKuMhSne/feHB3XCxhu2dc7o85sLvI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781159979;
	b=O+l4eCT4dcRhE258aDOXASs7Zo4pWg2k1l4+vJFaKfd4rQFEcLPLIHsQEx0R8dwbiKiUJc
	ASr9TKrzPW9sQ8dCvu2Hw+/yH5ksGCw2tOthxzl1apu2tI/xetFboyh6Hbs6GfH6lAzN6s
	1z3ctCPETqokwmKnJ58b8aRUyoMQUm0=
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-01 (Coremail) with SMTP id qwCowADHbdYgWCpqYOJFAQ--.1790S3;
	Thu, 11 Jun 2026 14:39:28 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [RFC PATCH 1/5] mm/slub: factor user tracking metadata size calculation
Date: Thu, 11 Jun 2026 14:39:22 +0800
Message-ID: <20260611063926.38111-2-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
References: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADHbdYgWCpqYOJFAQ--.1790S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZFWxXr15CryDKFWrWF1UGFg_yoW5urWfpF
	W7K3W7AF4UJrW2kw4rJ348uryfZrZayryxXFW3Ka4FvF98tF15ZFWIyFyjvFW8Ar97u34a
	yrZ0kF15WrsFyw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQYb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI
	8067AKxVWUGwA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF
	64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcV
	CY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv
	6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c
	02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE
	4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4
	IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AK
	xVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8aiiDUUUUU==
X-Originating-IP: [111.196.245.140]
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/
X-Rspamd-Queue-Id: D9FD41C000E
X-Stat-Signature: a6kbxtjg9tccchc4p5o4tnpbpm5pthio
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781159977-926409
X-HE-Meta: U2FsdGVkX18TIPdi7nzlT3Vmfn6h3dkOZq5ZfaAjlKrqYaQNi3KqRZqHJhAKElSOLMtVuI1JKGF951gYqUhhBNSibwGANWC+i37BVbaiFjU+59HDKVIhdGVGmgCtzwxKGsFJAllhzNnBJERDbXOLYGvqs4xs3zWE/SULWqk/KViXCZFSrdPS7f+bWwA8kYeY+/Szt+yICxsX4dzShcMeXgDiwN0tg1oPNY4kit3M7XaKAyisOVWklubJGTA3NLCzKwzq4j9/NU5cfKJuNAW0WN+u+/HzCRowAGskXyMAGyxfB7hgEQJQ0p0j2c5siL5bL9IdZr3HuOxOFzaUgoQkwjSJO6TMt1ZgsD2fm0qgCed1O0bpi+Lbj9HzBxxkOqMrafjGM2j1+7UePhZ3vln+2cP9Eva+CInA4rbZ8UsKHvnOG0qhtjLR3J9nF/TVh0WWUOmKK7LNZxUZO7VgdA6BMUMjSHMXfsS4v/7DFFOjAJf1JXHrV+yg1U9sYduqkzwNkh0PGsfma3wV3Pgdh3ih+RU34lhk/6d7Id+8CARvyMTLhDqp760L3PjKcbMU1yneBE4MoHTeUUFIe+2ZJUjdVtLVgmPO92vpPCYd9oUA1JYhH746FsLRP2hDgcnCpBlkPTTiuD8rwNhQ3ibIcYwiVts6phEcZ4GeCgcYn9WBog9EMmb2ea7Lr1g3Hrxm0XRHnp/OWMJqK5El+oTCFrBB8gzYbnYEbZbEL0K1tjViMr3laA4i7Z8+uHnrNs0qPnHrbtkpSfmUQSjSXSIjYJHxwLiWt4EpoN7nMgtwDY9TH8kgerJsMozWt5tDs0MhdHcXSHqu9SifgtuVnBCzXLB63WbkrEwnF/NrBD/vVGSFkTP7/QLgzke2XqMYV5nuUXN/Cw18YAw5PTZMoqZcUB+dRjrpgBV8PpTMoGp+2TVqc9J2yLuPRfeCopISdx6VIc1JrcPAVy2a2s/OmUtqINx
 MODjS92t
 R75S+fnRnlx2aWq5AyFeJ4xU1vyVu5QO6q2IWH1keiE23oI3dYpVIbPhlhc8O0/UxnW5XUs4Swzn1MbGJUnco6pn3+2u34XVVTGTS/ZnrOpmiJU0J/t9be1QTE7y0haFb1Yz4dLeuodO60hKhEM/kt07BEKADaW+OrOqt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SLAB_STORE_USER stores one allocation track and one free track after the
object. Several offset and size calculations open-code that as
2 * sizeof(struct track).

Introduce helpers for the number and size of user tracking records, and
use them for the existing metadata layout calculations. This is a
preparatory cleanup for adding optional extra user tracking records
without changing the current layout or behavior.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 mm/slub.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a2bf3756ca7d..a9114dddc976 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -316,7 +316,20 @@ struct track {
 	unsigned long when;	/* When did the operation occur */
 };
 
-enum track_item { TRACK_ALLOC, TRACK_FREE };
+enum track_item { TRACK_ALLOC, TRACK_FREE, TRACK_NR };
+
+static inline unsigned int nr_user_tracks(struct kmem_cache *s)
+{
+	if (!(s->flags & SLAB_STORE_USER))
+		return 0;
+
+	return TRACK_NR;
+}
+
+static inline unsigned int user_tracking_size(struct kmem_cache *s)
+{
+	return nr_user_tracks(s) * sizeof(struct track);
+}
 
 #ifdef SLAB_SUPPORTS_SYSFS
 static int sysfs_slab_add(struct kmem_cache *);
@@ -740,7 +753,7 @@ static inline void set_orig_size(struct kmem_cache *s,
 		return;
 
 	p += get_info_end(s);
-	p += sizeof(struct track) * 2;
+	p += user_tracking_size(s);
 
 	*(unsigned long *)p = orig_size;
 }
@@ -756,7 +769,7 @@ static inline unsigned long get_orig_size(struct kmem_cache *s, void *object)
 		return s->object_size;
 
 	p += get_info_end(s);
-	p += sizeof(struct track) * 2;
+	p += user_tracking_size(s);
 
 	return *(unsigned long *)p;
 }
@@ -873,8 +886,7 @@ static unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
 {
 	unsigned int offset = get_info_end(s);
 
-	if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
-		offset += sizeof(struct track) * 2;
+	offset += user_tracking_size(s);
 
 	if (slub_debug_orig_size(s))
 		offset += sizeof(unsigned long);
@@ -1077,7 +1089,7 @@ static void init_tracking(struct kmem_cache *s, void *object)
 		return;
 
 	p = get_track(s, object, TRACK_ALLOC);
-	memset(p, 0, 2*sizeof(struct track));
+	memset(p, 0, user_tracking_size(s));
 }
 
 static void print_track(const char *s, struct track *t, unsigned long pr_time)
@@ -1185,8 +1197,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
 
 	off = get_info_end(s);
 
-	if (s->flags & SLAB_STORE_USER)
-		off += 2 * sizeof(struct track);
+	off += user_tracking_size(s);
 
 	if (slub_debug_orig_size(s))
 		off += sizeof(unsigned long);
@@ -1390,7 +1401,7 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 
 	if (s->flags & SLAB_STORE_USER) {
 		/* We also have user information there */
-		off += 2 * sizeof(struct track);
+		off += user_tracking_size(s);
 
 		if (s->flags & SLAB_KMALLOC)
 			off += sizeof(unsigned long);
@@ -7845,7 +7856,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 		 * Need to store information about allocs and frees after
 		 * the object.
 		 */
-		size += 2 * sizeof(struct track);
+		size += user_tracking_size(s);
 
 		/* Save the original kmalloc request size */
 		if (flags & SLAB_KMALLOC)
-- 
2.50.1 (Apple Git-155)


