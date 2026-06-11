Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF999CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 06:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350696B008C; Thu, 11 Jun 2026 02:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0D56B0095; Thu, 11 Jun 2026 02:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0B36B0093; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82DA66B0095
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25091404E7
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:39:41 +0000 (UTC)
X-FDA: 84866680962.06.30D03D7
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf23.hostedemail.com (Postfix) with ESMTP id B7382140003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:39:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781159979;
	b=dmak5R2sKwOE+BKo7txti0fB/7pwC9rMklYhZdJsDxm2bbr1KVLSXmpIIl95bTNzyQhjlP
	u2cfYDtbar1Wd6gV1sv0kTewJqEa1NXMK0fgjTbJJNVFhE9eY7zMc00FcJVMVXWyH8cJu0
	dS6xnYpvt2tvn737Qm8qfeCxkbxIhGo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781159979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dl789qp8wyZwgXNHEyClulIA6vsmn07mT0oQJxkuSwA=;
	b=VQy1uzNA24TNZjqsvKxzPs+xftcjqNSrD53y+vo6YRtwNO4MSS2ip7BpJ3vBhPJf+4mmMs
	C0ldtuioQ/6PvNA4Nga0CepYCUOi1nF+sbW1U8sXIErg8ndBTU/xXv7tTzlaZAmw/cRK1g
	HE5ScWh1GvGaIZYNmxuh3woeYQbt1Ag=
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-01 (Coremail) with SMTP id qwCowADHbdYgWCpqYOJFAQ--.1790S7;
	Thu, 11 Jun 2026 14:39:29 +0800 (CST)
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
Subject: [RFC PATCH 5/5] mm/slub: sanitize previous lifetime tracking flags
Date: Thu, 11 Jun 2026 14:39:26 +0800
Message-ID: <20260611063926.38111-6-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
References: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADHbdYgWCpqYOJFAQ--.1790S7
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr43KFWUCw13Cr15uw13CFg_yoW8uF15pa
	y8GFn8tF48tr1fA3y7ArW8Wws3ZayrKFW2yFy5Ww1Svry5J3W5AFsakFyYvFyrJFyjya4D
	AFWFya4FgFWUAr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTRNdb1DUUUU
X-Originating-IP: [111.196.245.140]
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B7382140003
X-Rspam-User: 
X-Stat-Signature: d54xwea4bcdzp7mu9xq9wmfhaeeaopyt
X-HE-Tag: 1781159977-681682
X-HE-Meta: U2FsdGVkX1/It3nNkWbENgIXbC5eeQ2zd3hOlzzZmWXSjUyPtbaH8WP74lJHEuqeJru/c9ncSbq5uHtJKjNfcEh58k2+cBOF632RSeRXOy/G+3kOGD1OVzS5mwSL9iQUfAON9czMVKCJl3cuUFJMTQ1COyCp2moE/RA2NvBoUVGqLO4EfPHVpsPVpk6El/GxXiO9XxPsFMKh9GPEPbTaARhj/ttq10KZEAYUdan2kyDuTCT0HaXvHgPsVJ5SoJTZLtH0CxnSeg3hLm91Zh8zSMpCMr+kKvfyxCzwvyh8xumCWgjR3rMODcp6C5pb/PXjkgeBWSPMEai5gdGIHt4K7teAYYGE5jqe3NhrF51hKkQCJ/v2orbLQ/t0zXu4QykmM10IqQVmUIdS5asG2E33/kKJcSQ3Mvlkbm1F+j9kDiqsfjK3v80SJ1MB9npFfbUsNPKuJdTipH4T0BCHCi9qtLq7v9inircYKq30d7IeMLzyGtlRVpK8ykoMsTZKbNwRT0EErWPilP+46qWjQpPafnUylZx4WQpoXUqTyLO2UJKRC55jpQSjxXtA+U1eGUK2efRNa7WvwRhquMBkBjD1gN5jG7KibmwLJ+sk8/xB8nCVFXalejuCWPAVpV0YoBBVw1lxmHs/SkAgUBwB1oKKBNGejZV6zMaM3MLK3F25P3Z3l6ZgS0Qhu0YLQsi3Ztq/kqDFebhR0N8HIzjHiCrj++YSAvohKnIL3kSaHOUMuZw2ZUAgPynQE/wnXQrMBHyCzDqLdWT6ob7rRH4OiGOqAnH11ro/DfdRfK8YtXBlrP1Fgt4ZL9ddu4Mq3LSz70f+KHQqQ80t4XtmUzXGXyP/9MK1zeADEehxLevjhUhpu0OmIadP7Z6n382tAd0SxnYlM+v1Iv2IhX7htbRijtMy4q4mBryRWLshG3skz35cJL/sw9pcE/SpQ3v5De1QnYsnsBphorik/4DvR6bHrRz
 L8kL8iM+
 XyMCw0MD8O8/xWQdnVKX1FJez9Il7MDojZxNWGUULiEssCiIcOKQO6Y4Mc0FQMhQICR+trrrQ0ED6xW5jzT+l+51u8rm8A7VTwoktI7xu6ndCiiyEf1dn8M9aUA4zFnosXLGpq9b3rhW8/m1SjHlf1zyMfjXPrTfP12bf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SLAB_STORE_HISTORY only has meaning together with SLAB_STORE_USER because
the previous lifetime records live in the user tracking metadata area.

The slab_debug parser rejects H without U, but kmem_cache_create()
callers may also pass debug flags directly. Clear SLAB_STORE_HISTORY
whenever SLAB_STORE_USER is not present so caches cannot end up
reporting store_history without any user tracking storage.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 mm/slub.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2dfa8af00a49..931e6d04ba2b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -341,6 +341,14 @@ static inline unsigned int user_tracking_size(struct kmem_cache *s)
 	return nr_user_tracks(s) * sizeof(struct track);
 }
 
+static inline slab_flags_t sanitize_user_tracking_flags(slab_flags_t flags)
+{
+	if ((flags & SLAB_STORE_HISTORY) && !(flags & SLAB_STORE_USER))
+		flags &= ~SLAB_STORE_HISTORY;
+
+	return flags;
+}
+
 #ifdef SLAB_SUPPORTS_SYSFS
 static int sysfs_slab_add(struct kmem_cache *);
 #else
@@ -1910,7 +1918,7 @@ parse_slub_debug_flags(const char *str, slab_flags_t *flags, const char **slabs,
 	if ((*flags & SLAB_STORE_HISTORY) && !(*flags & SLAB_STORE_USER)) {
 		if (init)
 			pr_err("slab_debug option 'H' requires 'U'. skipped\n");
-		*flags &= ~SLAB_STORE_HISTORY;
+		*flags = sanitize_user_tracking_flags(*flags);
 	}
 check_slabs:
 	if (*str == ',')
@@ -2052,7 +2060,7 @@ slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name)
 
 			if (!strncmp(name, iter, cmplen)) {
 				flags |= block_flags;
-				return flags;
+				return sanitize_user_tracking_flags(flags);
 			}
 
 			if (!*end || *end == ';')
@@ -2061,7 +2069,7 @@ slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name)
 		}
 	}
 
-	return flags | slub_debug_local;
+	return sanitize_user_tracking_flags(flags | slub_debug_local);
 }
 #else /* !CONFIG_SLUB_DEBUG */
 static inline void setup_object_debug(struct kmem_cache *s, void *object) {}
-- 
2.50.1 (Apple Git-155)


