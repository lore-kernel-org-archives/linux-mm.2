Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E7F4C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A376B0005; Mon, 13 Jul 2026 03:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7014C6B008A; Mon, 13 Jul 2026 03:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F06E6B008C; Mon, 13 Jul 2026 03:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DD936B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:52:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC552140307
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:52:41 +0000 (UTC)
X-FDA: 84982986522.30.E5E25C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0688F120005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:52:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KjoePid7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783929160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JG3wfdlgkpMM8tt+kWWFpTDhSu/cA7QAayvWlQD2jTA=;
	b=oTZLlXjNNLX3bQyHE4FVUl0RPP3drygtOxLrjKXQUTQ+gYen3aN1KUnslfJRTYQeEEYa5T
	UENgxjSHgeNx9RhJLMGO4z7jyJ42+aDKQ4cb4Eu7yfwFuXF4kP59MNzKuazCMWH5dmdb7e
	C/OxIuf1Gcb0Bu3kxTj9eBxBfmLgy4I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KjoePid7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783929160;
	b=47PelRSR1AItpHNKyUwbCzPS6u5OGbt+Ocilqa4o+4zemeDCJ+qPVInoP9tC/qwZLHpsNg
	e9Lqib6DLN7IUPh1Mvk/UlM0nVO04BHJ6kH+tdwiyUe+PryuQDB0k5W+JBuSHm4zHhxByg
	179YFF8BAcB6tFinempcVYaU3856lwU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D330640308;
	Mon, 13 Jul 2026 07:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815E61F000E9;
	Mon, 13 Jul 2026 07:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783929158;
	bh=JG3wfdlgkpMM8tt+kWWFpTDhSu/cA7QAayvWlQD2jTA=;
	h=From:Date:Subject:To:Cc;
	b=KjoePid7SP2n4JqJFiVvkr4H36woTeOhh8kIVatO6/xv9frgAc82eUYEkKRqi1nDX
	 ccMp81BMtkGx3pGKkCVBPHd1a2ZsKhdckbWxNzbn2mOR94fJhuLTpYjB1A6OXOYH0y
	 FurC9mjUd+VPWSzHPe8Tgl8E65Q3m2zxlO2f1oanVOCRL7TOM/t1BKe7Qk0jPaXRpB
	 HORtQSUDGJRqmDdHdGt42GOKeqoMdXj0zQDx0dbSkCv2goR5uaM02RRBGnicEjIkiQ
	 IF/1UFFA9eSnBTCM3lAYJWYvsOIjfPijxzrF7/mjtQIJ+IBMvowynidGLhg+eHUJOp
	 Mkinh9rrbszXQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 13 Jul 2026 09:52:30 +0200
Subject: [PATCH slab/for-next v2] mm/slab: simplify freeing remote objects
 in free_to_pcs_bulk()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-bulk_free_remote-v2-1-24ee24771c2f@kernel.org>
X-B4-Tracking: v=1; b=H4sIAD2ZVGoC/3WOyw6CMBREf4XctVVawyOu/A9DSEtvoYKtuS0EQ
 /h3AdcuJ5NzZhYISBYD3JIFCCcbrHdbEKcEmk66FpnVWwaRijwteMrUOPS1IcSa8OUjssIozM1
 VKpNp2LA3obHzoXxAGKS6GE/M4Ryh+tVhVE9s4q7dgc6G6OlzXJj4gf1fmzjjTJZFqXPdZEJn9
 x7J4XD21EK1rusXQm/HgdIAAAA=
X-Change-ID: 20260710-bulk_free_remote-7fbe6f3abf5d
To: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Hao Li <hao.li@linux.dev>, 
 Shengming Hu <hu.shengming@zte.com.cn>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0688F120005
X-Stat-Signature: t3ewrh87imph43s1xq33wdiwgi8i57gy
X-Rspam-User: 
X-HE-Tag: 1783929159-632737
X-HE-Meta: U2FsdGVkX1+u61vCJIMnGaPytpJT9DnRkgxctNzDv9LxhYOaKfQZBS7Hi368+ZbTCLidwrSi+3njwfUppBTk1gIaIFH6b7O4NI0JU3FB+shdpuZib5AX3GHXhVpLQmAXqTgZYfo9kDlaVEikCq4ZFO5vP9qCtk9YHcKN6msg2AqYYznhzb745jlj5NZTxu8JM3VndTr6+9hHULY6+Wubc1TgqyYvjBjLVFHcjQuaDIe/58hAjbxkJX9hxHEls6LUm85hP+uOHJdwxs9fFK5Wdx3WEQmBPN9K9ShdobNauKwWCCGZ5g/WE8EuURDoVBa8cn0HvPlqIeV+vKLcP7evrZrhkApSoaguHhBvfGgZ/PA2WkVSgmwSq4TC/Kh5E5sNabkDNfaekqLSnL5LL3cpkh6DtMKFL0Au8GHrmWDeEeKYZuS/9Pz/2KSDSQpN5ZT9pShIkWRfZz+9mAEnbuZHd9o0Jsfe4eGOv713A+UU3/ME1OEj1k6bE13Y3/2m5C/UeeWJVxwDRxW6gJ5LLlc4U85z9+/w6z04zNQbyzr/2yxEgXKwkyTrTAQgUQBYyWVovjst800oRQYJRUqWmfpFbtUOKL6SXuLDjCqi9pHNKoIEZ9/CvNRzT+oW2GGdmUNi+x5WVErqQg+UjTu7hxztAD6cIDsPIX5OaV7Y180P+XWw9wNRe+JsY4KvynQ49cEou+bBZcHE7ksPeDLeGC1g8WCYp03bjx4GKNsmKsUiFbJg95oQmrs5IiujmFhUTHZUJ1apqHCExrfB6xvrmGMyMVAXsGHzMBubOg7Uv/OYN8uuTlnCdzMTlqmazAefg+2bYYsnLBqXKQ+NeDSJ2NQ/7/QakKAE1KvysbQf9mFz64IEwmivN8+cGrm7SaCmOWh6zBS2x4YT5RiAc9CM2CfFCX4rXvGTxQD7CW2+xkGfTzlpm8D7DwSW9e1PIGjxb2KjTh8Blj+LFc8BzWO/iEz
 wve1osFa
 ks9QQdDo/TRkiGvZgi0criZYOPpnOUF9R1GW2urk8HHoPrRLgyQwgC+J+SiYGjo0yJ8rRbMwYO7pxg0wo+Q+KTD7YQFunODQNCmWTrLcQffnZrM+94vseTGC1YZ9wqIfOkiky0Dg8ZEgkjJvPCGSWsaqzqzQPSernTaeiizGMHxLNgdpXxTBFT+zh6tesi40foYOR4SGW41D9+uZj4L+YT78qUjbygmM8OoCUMf80ln3HiUcWexa4Xeop/b3hQJiUP7m51fKAOGgBzV8fSwnvhiljrhjyyJAQtLm7XaTo+4yIScfM1vtEIyq1EY8rbahf+bd8Wv7ceipx/p7PCaKXo+d8zuIAEvtlMdQ2LNUcFVqZNN6qbk+EYm0LNJIYkXLG2wdDJaKFt+8A9tra3uUrvilBWld2cwpKO1N3/HXFT5W948VJDAn8DL/qTw==
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

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Shengming Hu <hu.shengming@zte.com.cn>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Here's v2 with updated comment, will add to slab/for-next right away.
Thanks all!

One more cleanup I realized it's possible when processing feedback to
the previous one [1]

[1] https://lore.kernel.org/all/20260707-slab-simplify-bulk-pcs-v1-1-4850dbe0d904@kernel.org/
---
Changes in v2:
- Add comment about the partitioning, based on Shengming's suggestion.
- Add R-b tags, thanks!
- Link to v1: https://patch.msgid.link/20260710-bulk_free_remote-v1-1-a878d6dc52d5@kernel.org
---
 mm/slub.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 22045dc919ef..b650c1729437 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6255,9 +6255,17 @@ static unsigned int __free_to_pcs_batch(struct kmem_cache *s, size_t size, void
 static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 {
 	bool init = slab_want_init_on_free(s);
-	void *remote_objects[PCS_BATCH_MAX];
+	void **remote_objects = p;
 	unsigned int remote_nr = 0;
 
+	/*
+	 * Process the free hooks and separate out remote objects by
+	 * partitioning the 'p' array in place:
+	 *
+	 * [0, remote_nr) - processed remote objects
+	 * [remote_nr, i) - processed local objects
+	 * [i, size)      - unprocessed objects
+	 */
 	for (unsigned int i = 0; i < size;) {
 		struct slab *slab = virt_to_slab(p[i]);
 
@@ -6270,19 +6278,17 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
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
 
@@ -6296,8 +6302,12 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
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


