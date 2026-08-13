Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B7D1C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 16:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 841A76B053B; Thu, 13 Aug 2026 12:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819BB6B053D; Thu, 13 Aug 2026 12:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71FF06B053E; Thu, 13 Aug 2026 12:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4990E6B053B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:11:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3735801F1
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:11:11 +0000 (UTC)
X-FDA: 85096735542.17.62169B6
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9D8A680006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:11:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786637469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wGR5JKCwKShHHX9tSPD27Z7eEx8n7bjXJA5BAhXB5BQ=;
	b=hFB7dTP9GCe30qBqp02+w2FQ7Gfbz+i+qEp8jA+Z/M4/RS9Q6nLZWM50tQc7L8PWrQOswM
	kxdUL9rK6Gb38TM+iAPr7rCjaLx+kMs6x6CuZ/SpZx5weRNXf4XaXI6L1he/yP8JWQRDLJ
	1CI2sbYgdAMeJKT2O3V/CRfcOWA6hIY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786637469;
	b=dS+uwAP9KvIxZa8bYKjshdgL38J79ZIz+dqecbNpXkKo/3yS54SvrkFVxMl5pbs8gNnrMH
	xhkhhKP/U179jR4iXi4htkiAwaHiJ2RLQk8RSB75ca+OlDiKuuGp1Izy+LG/2MpmgpDkF4
	ybfxxS+oQFitDuPGqaZ3aeRbPauoBV8=
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowAC3i++T7H1qyZF7BQ--.23471S2;
	Fri, 14 Aug 2026 00:11:00 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH v2 1/4] mm/slub: use a track count for user metadata sizing
Date: Fri, 14 Aug 2026 00:10:59 +0800
Message-ID: <20260813161059.73855-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260813160825.73031-1-pengpeng@iscas.ac.cn>
References: <20260813160825.73031-1-pengpeng@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAC3i++T7H1qyZF7BQ--.23471S2
X-Coremail-Antispam: 1UD129KBjvJXoWxAryrKw4rWF18Jw47uFW3Wrg_yoW5CF18pF
	W8K3WUAFWDJrW2gws5J397uryfArZakF47JrWIg34Fvr98t3W5XFWjy3yjyFW5Ar97u3Wf
	AFs5t3WjvrnFyw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9I14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r
	4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJb
	IYCTnIWIevJa73UjIFyTuYvjTRMv31DUUUU
X-Originating-IP: [111.196.241.250]
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/
X-Rspamd-Queue-Id: 9D8A680006
X-Stat-Signature: y11epxkckm9yfaof5ggbk46nhptijrox
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786637468-544796
X-HE-Meta: U2FsdGVkX19f33bVoK0jwXv4vZV+i70MuWTgf4ScvNM51ymAXKg/k/4bOivH7zY74lT3rsJHGNM2Hf6CE0eyy6LBdGNpzXs/XPO7gucy0M4EqqavdahmHro+oCOY7tSzgszhVfiDY1aNsVgG+/FhUe5OEv4oTUgMd6hOjqAJg/kTCw2wImCqd8at9sC0FyKxA14zUEPPB/MRFRaDutomxejcWPddlWno7dqgorVQfGa8lERmRCkHRPvlQDXVCDS53Clby5hdiFvPSxTkamkXJTuUyocWkqP71VlFV1QyFDSdVqNidPQsSHVpJDSEXcDpiUyzAdKPCwpPuI2yUuwG6prA4dHwx70YJgy8+UrtJzFfRH1PkSONgZLsVRlxx886OkyjkZbELx/Ne+iyu6lbq2r6SFSnFWNG/5Iu9jxMHjcGUxGRk/NGOyrAEg3pEMG0Y3zORgSDIH0QPapAGGU3wqKCuPnQHB5HchDo2hj6UmHv/nWe6q902z75Rgv2vwUsYU+heMKqdPVRWeQERED0qdq35q5kfv52Y/771V2TYwSb6sMp0/Hnvll9sa4eGs/HalbxispdlZ44i1MDc779DAbGaoeXBTia5qXG/GF1H21sMWlq7FdQzGQ/rM7IfyYrHFgjClFuPcN/MmHXM1emjS4lOTaMd7N+0W/NudYJywCht4heq31CQ9lwbDjh759dRW3WMQUoeHis0Wh9FzotHfCDY6UdAK6leY4gm4yYB97z35ovMrS7yYgzL62NTRbL6yx7aflVxet6B//C8cDQvCBbKkY4r3kwWkTr39sXvlGIUN75+oGIrO9w9v+0O0eJ39fo+JlvZ0c1OR6gOccEEPEktJs/MdwWHJ0q7hWK+pisNEnrhhSGp+iKM+QgWgzVg5TcyPDQ/o0bp2ewos/lpRRtfrWCWrBpxMhxOCHOOqvyPyGznTawrbg4aJbZFOFZ2xdOuefpGgqVgjZkgnM
 Fx3lsZeI
 Y56OdGS9Ryzf3vOENC+cWaJynTNIqWLy3t51Q5i9tBW3jZHiHPHGH3YJvE3q+umD+Y1cZn1WhcBN8wAlo50Nkm2nOv6z4xs82VghcxLbnOdGxnIMsYpCGrndChaW1scL2yb0YSZ6wtt1w3pxYk+vanTA/xaHelW/yU/f9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SLAB_STORE_USER metadata consists of allocation and free tracks, but the
object-layout calculations repeat the literal count at each offset site.

Add TRACK_NR to the existing track-item enum and use it for metadata
initialization, original-size placement, object-extension offsets, padding
checks and cache sizing.  This is a behavior-preserving preparation for
extending the tracked history.

Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 mm/slub.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0337e60db5ac..0653def0fe36 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -329,7 +329,7 @@ struct track {
 	unsigned long when;	/* When did the operation occur */
 };
 
-enum track_item { TRACK_ALLOC, TRACK_FREE };
+enum track_item { TRACK_ALLOC, TRACK_FREE, TRACK_NR };
 
 #ifdef SLAB_SUPPORTS_SYSFS
 static int sysfs_slab_add(struct kmem_cache *);
@@ -753,7 +753,7 @@ static inline void set_orig_size(struct kmem_cache *s,
 		return;
 
 	p += get_info_end(s);
-	p += sizeof(struct track) * 2;
+	p += sizeof(struct track) * TRACK_NR;
 
 	*(unsigned long *)p = orig_size;
 }
@@ -769,7 +769,7 @@ static inline unsigned long get_orig_size(struct kmem_cache *s, void *object)
 		return s->object_size;
 
 	p += get_info_end(s);
-	p += sizeof(struct track) * 2;
+	p += sizeof(struct track) * TRACK_NR;
 
 	return *(unsigned long *)p;
 }
@@ -887,7 +887,7 @@ static unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
 	unsigned int offset = get_info_end(s);
 
 	if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
-		offset += sizeof(struct track) * 2;
+		offset += sizeof(struct track) * TRACK_NR;
 
 	if (slub_debug_orig_size(s))
 		offset += sizeof(unsigned long);
@@ -1090,7 +1090,7 @@ static void init_tracking(struct kmem_cache *s, void *object)
 		return;
 
 	p = get_track(s, object, TRACK_ALLOC);
-	memset(p, 0, 2*sizeof(struct track));
+	memset(p, 0, sizeof(struct track) * TRACK_NR);
 }
 
 static void print_track(const char *s, struct track *t, unsigned long pr_time)
@@ -1199,7 +1199,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
 	off = get_info_end(s);
 
 	if (s->flags & SLAB_STORE_USER)
-		off += 2 * sizeof(struct track);
+		off += sizeof(struct track) * TRACK_NR;
 
 	if (slub_debug_orig_size(s))
 		off += sizeof(unsigned long);
@@ -1403,7 +1403,7 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 
 	if (s->flags & SLAB_STORE_USER) {
 		/* We also have user information there */
-		off += 2 * sizeof(struct track);
+		off += sizeof(struct track) * TRACK_NR;
 
 		if (s->flags & SLAB_KMALLOC)
 			off += sizeof(unsigned long);
@@ -7895,7 +7895,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 		 * Need to store information about allocs and frees after
 		 * the object.
 		 */
-		size += 2 * sizeof(struct track);
+		size += sizeof(struct track) * TRACK_NR;
 
 		/* Save the original kmalloc request size */
 		if (flags & SLAB_KMALLOC)
-- 
2.50.1 (Apple Git-155)


