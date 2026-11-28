Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D96606A323
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 09:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Axay4iNP
Received: by kanga.kvack.org (Postfix)
	id AFC2C6B05B0; Sat, 28 Nov 2026 04:14:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD48E6B05B1; Sat, 28 Nov 2026 04:14:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA6D6B05B2; Sat, 28 Nov 2026 04:14:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2626C6B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 04:14:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99B1DA046C
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:14:40 +0000 (UTC)
X-FDA: 85483967520.15.9BA9B85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 776961A0009
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:14:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Axay4iNP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+dickson.wu.certik.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+dickson.wu.certik.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795857278;
	b=6Z25iw9+ELS4ITm8Xgs0zT5HGQ6w2DjgVnnrWNBs4IPTeQiH3OoeIqk947s7C0gnHH7Cus
	AjI0F1/bN53qQD+MGjE9zLqwlMJdvv6hKjHqLtOHefyiss7sZxUmjCc6mcm5hYqiPgl5M0
	hhi+RqPzM4GROEHY5f3P5tfKntD7hUc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795857278;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VsKb42s+5bHM1ZoiF6LkiA4s6kGoq5BsrJdery40LXw=;
	b=SuSN6viRONOy4+WYqx6Q8RiACS+ELLNWkurDS27BEO7NxO/S30BTAJaCKpyGzR1G8mO2Tm
	At50tM1YnGOK4zRcYBFw+t1GzjLxeu98rEKMxDiWGNMUDhjuFlywaothZ1Yn1YOUA4ikbY
	AlTLsx+d2v7/lglzhALe8rUZSsFxZ+Q=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Axay4iNP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+dickson.wu.certik.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+dickson.wu.certik.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CB3741FD1;
	Sat, 28 Nov 2026 09:14:37 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795857277;
	b=qaOXyFuJPZuXjaVYk/Uu+QkFbQxY8Q3n9yTQMW3yOw1ig0bMwwlPPK0srj59pcHd+Jfg
	 Yf84Q2sTUDmu4J5et0ChV9hKYVOCj4m9GbxE5742jxYCu0reua3aXIdf8e++olpy3Fey8
	 JgVFi0/QIw3MXTS1eHgbv0OIQCe13fxh8bDygGLngpiMvx3rdZj/1ElWb3HmRvZRym6+Y
	 d1ZtSEeGwJWCXJ53trKpN7zefZZ7h4ghABIFSzZSm12pOzo3+wHfCg4LXEK7Ey2iwuJOY
	 pldiCUm5xRIi2EQs4z8iPIqJQsqR7TUF77lEVa+iiIK2k+Qgun+dNPoRFvOqa5FflJg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795857277;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=VsKb42s+5bHM1ZoiF6LkiA4s6kGoq5BsrJdery40LXw=;
	b=G2TY0fJfx4hJbj+j7ejAWjNi+i5oJvbMHyS0JoLWZEesyXLX2C4E+Fx+bpFyFrYzwkSY
	 HNokMVXgbyOU/K+6VHIPKLBktRF3a71IckXpubuHgDaTWD2qq/DVwIoML5sP3ectNB7Xd
	 7zxoJ0wWPxBqLZEvi2iHM3muPXpgWb42m85zfC8pkhyat1EgS0cLof5TXowSStiVkBV21
	 pQpqpr1gKpMVl2D8yvmggZ6+DzAm8wtEiwdld3t8zi/CeW2q5dyq771QorqzLzzhSEt4C
	 d4dkDdFe7nOlOi+tufkTIXLfEEEv8MP4GX/IRujdsOpwuO0ims6C630HtJrxuAP3A/Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B55D41F00893;
	Sat, 28 Nov 2026 09:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795857277;
	bh=VsKb42s+5bHM1ZoiF6LkiA4s6kGoq5BsrJdery40LXw=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=Axay4iNPeNa7xU3OrkMFrTVQlSehKSYj7jNKxVjy/uyhb3UiHHEnLIPTp7QFIo3s0
	 3ryPMFUTk7JrItr4tkQdU3QbNjjQ5ULQO7x4u0Wh7BUeaK7DX1GovKxBf5OPl5DlJK
	 J6vV8FNMZxIkv49hRct56Yz8rBPuyba04+1E9pzOE308oih+9ggVEwVMlzxkMKtSsg
	 QmG3irvH9V4HryLjsCq6Ph4LyMyz4UYEjZ3Tlk2cEndNsGG16dyeAnh6+qCUOp3aio
	 LVhR3oHKNNJsLIuJUa4bOEZo2lTK4j8hAk8xdjRoeqEiWwHeTKAuHUX0Dch0l9WK7H
	 gJKWVxj8Ynwcg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4AA184E05B;
	Sat, 28 Nov 2026 09:14:36 +0000 (UTC)
From: Dickson Wu via B4 Relay <devnull+dickson.wu.certik.com@kernel.org>
Date: Sat, 28 Nov 2026 09:12:21 +0000
Subject: [PATCH 6.6.y] mm: list_lru: fix UAF for memory cgroup
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261128-listlru-66b-v1-1-38119b440740@certik.com>
X-B4-Tracking: v=1; b=H4sIAPSaCmsC/02NwQ7CIBBEf6XZs1uFCDH+ivEAdLEYAoalRtP03
 wW9eJyXmTcrMJVADOdhhULPwCGnFsRuADebdCMMU8sgD1ILIU8YA9dYFtTa4tEraaVSznmCtng
 U8uH1tV1Aj3p8w/WHebF3crWbetEaJrTFJDd3xJSmmnPEzvd/D7BtH2+euYmiAAAA
X-Change-ID: 20261128-listlru-66b-4f52b255ccfe
To: stable@vger.kernel.org
Cc: Muchun Song <muchun.song@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795857140; l=3786;
 i=dickson.wu@certik.com; s=dickson-b4; h=from:subject:message-id;
 bh=POu2beyDobF+0phd+hiYwzwZCt9DRStto5gd3AQtySg=;
 b=mlGUL6TzOy4lzlVmeugaep9HuL/M5Krv56k/4wQTf+FCHY77yp8viURAqToN7Ofyk8c7+RRov
 gtF7vaL5er6CAsoxmGSYZAbH2VtVd/aWo8uOSXe6A5g6EJkzWLWiy4D
X-Developer-Key: i=dickson.wu@certik.com; a=ed25519;
 pk=fxH7FS4FdojeJSGLJzgKdfO51Rvr4EW30yinj2mc1vg=
X-Endpoint-Received: by B4 Relay for dickson.wu@certik.com/dickson-b4 with
 auth_id=1647
X-Original-From: Dickson Wu <dickson.wu@certik.com>
Reply-To: dickson.wu@certik.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 776961A0009
X-Rspam-User:
X-Stat-Signature: wrkhx33e4pjk1rj7xo18u14b6r7sykup
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795857278-816369
X-HE-Meta: U2FsdGVkX18w1Vi5KR76V92HqJUYnbcGhRz/lCeal1/QN5bJp+BPJUUw5QduOCXHyEZQ0D1e4j4Yg3bMlWp4jYVPfyOtSjVmMHDGG1rfBiCGPQZ1JlUnOXC5TtFj/mvknpsRAeNxaIZX9H8GyMdmYm2+UZlXdTqyOoJs2QkKS+sTrNt9xmR5PDH31ojKwf62KAmkv8qzgms7oxNLNdVaRXURvC+/i4zhwGTbCx19gJUnHahCd2rxCfPbZDSTRDCT2DBn8ktb/XDhH7D03OHuH6OWTVw0qqI2/d9GuZGsJKXZOGvtJtAyMvfFZSbEdgzpysTctzgihHgzAbKpy24whcMSJMwivf3efpNYBglNWbTM5bm89E75gV36fHmboqLQZa4+Fj1zVCdi9eER2l6/L5/5WuZAZsYRI3tew4HuNdnUIqyK6Dwo1TNwecLKeoqxkdGBbJMF2+EZXN+c7FCcbLQ0qFLcyMHVNVvuFpiVAheT4l9s7vUjg1G2/N1W9vCFO6uQsJ9U1e/63WE0dVRxQjF6+qq+Mgalu7g8W6s/Fq6qyFaIAu0jrn93SidQsRttYPJ4ASjMBIlwt4n8mJGM+iwK65U9GHkdSfzylLzjp6Zoc/q2eQ7m3MIVFPY5VG3QhnFhVflii9Snm3/lXt8F9RwrDzKlieysIeDf55yCTRE65lgDJIof7as4J5RlUBgNa7uKUlGbvOgyFY+RB69iHYuaQXZFAFCYBZN1LjbA41l/MQ0vHMyCvILrXjmmdP2WNDxBWU034aJpXYJflAxcDzrOuwvSi6wcY2qrzdCVjAYmw9W14xyWH/j01zTXuxtw0nFry1kP7EEddPBdrMw7CNasU2wIqNf1BsWBBEwJ1mwddfRRrLR+HVjRzkc9NMtROoQGSM5Ww/QysuJyqTNunoc9k/Seiqn5oytIMSUxtTRJnIENRGVo/FsYSVARCXrrqVo4saAeKa3dO0HQboi
 6bzUaQea
 qvPhBL4dilbVYkdZfjhI7SaUrSOhfMMrJptQ9dlC5TOG6s+F930qckM6JCVoPlqHQxcTHUROqHaaLAVFsK28jPjiAZ+VJsko4MOt4E+7sOYvmOlgDkOITqZAwhYtLSrWmampxmVdFpkJXStlUY34uFsrlhvclQ89yB9n8CZcCdJ1VklbHaphX/U5/fZ6XeuQKpx20k5wPiZNwoxn/lV+Xu55QWKe57Yfy8zYDz+CVOdGtoMAh6q4L9Q18guszqOvauYMFj1T4U35K8PvSezQMXGx1/QsuDnf4xnwEh5wpo2r6wCh1CqU6jyXWRbx1jO/NbiCAhZ6bif29WxJmZ32icpO6+ps1YLPJVqKPtHFsKDgawKkpe8Sk3j842DcgY38eOxPj8/ntDpDc+MKNdAX9FdC9YLMow+mlVEW2/xCfKmkTdJ8boD1ur2oBhcTJeZrt+pGqG70oxJ/5or7i0ooyOqX+YB/zQbUOPTkNnPwIxgqcyWyHcv0tKIg29XH4WXNMJuVD0OKOyOonC+AOTFRgRLmvbGYZ/b6dlZUeUwS109THCr7k2bwsNpPOhoN5VFcSojxMRwHiXTxJOgjsNsUZg4Gsa8iBBw1r4hW8PjkGLm5Y2FxRbu41ZxwjmZL6h+cFl2PAduUWI97ks/i1txB0LieTHBdHarslQ5uuLgM5MfmKM9yevAbj7RJdjbPspV2FgEuDEldR6zUsscmt/M7yVurA1wPKGgE6D+dqoplaVaTWu+QeHzMA8q5jKG92TSiFXzWLa8M4YIiFkL2V0+sRELWs/q38/Md8mGu9k2SetGMiSh8uCKtE90H8HyJ5CTHYNgAuJx6EEWyBcxfI4SFDw9Y8MhM2FPYCnXcRwLMm1Vh9AIO67pBaoPVAbkmwyIfO7Ii9KcJIO1RRLO8D2yMTFF7VJoRSjrEpHN+OB+F9tifyxhr1StMBDztO9/xEtDK4YcIeEJKL6VYqJab3iyocaw5X9UBM
 mxHKFLuj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Muchun Song <songmuchun@bytedance.com>

commit 5161b48712dcd08ec427c450399d4d1483e21dea upstream.

The mem_cgroup_from_slab_obj() is supposed to be called under rcu lock or
cgroup_mutex or others which could prevent returned memcg from being
freed.  Fix it by adding missing rcu read lock.

Found by code inspection.

[songmuchun@bytedance.com: only grab rcu lock when necessary, per Vlastimil]
  Link: https://lkml.kernel.org/r/20240801024603.1865-1-songmuchun@bytedance.com
Link: https://lkml.kernel.org/r/20240718083607.42068-1-songmuchun@bytedance.com
Fixes: 0a97c01cd20b ("list_lru: allow explicit memcg and NUMA node selection")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dickson Wu <dickson.wu@certik.com>
---
6.6.y picked up the code this fixes later than the other branches:
0a97c01cd20b came to 6.6.y as 32d7120a499d in 6.6.160, but this
follow-up didn't come with it, so 6.6 has the unprotected
mem_cgroup_from_slab_obj() calls in list_lru_add_obj() and
list_lru_del_obj(). It applies cleanly.

Tested on 6.6.163: allmodconfig W=1 build of mm/list_lru.o, base vs
patched, no new warnings. Both kernels booted under QEMU from an ext4
root and passed all six cgroup test_kmem selftests, including the
memcg deletion case. I didn't hit the race itself.

The backport and the test runs were prepared with AI coding tools
(OpenAI Codex agents, with review by Claude). I went over the result
before signing off.
---
 mm/list_lru.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index fcca67ac26ec..e362a956bf8f 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -116,6 +116,7 @@ list_lru_from_kmem(struct list_lru *lru, int nid, void *ptr,
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
+/* The caller must ensure the memcg lifetime. */
 bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 		    struct mem_cgroup *memcg)
 {
@@ -140,14 +141,22 @@ EXPORT_SYMBOL_GPL(list_lru_add);
 
 bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
 {
+	bool ret;
 	int nid = page_to_nid(virt_to_page(item));
-	struct mem_cgroup *memcg = list_lru_memcg_aware(lru) ?
-		mem_cgroup_from_slab_obj(item) : NULL;
 
-	return list_lru_add(lru, item, nid, memcg);
+	if (list_lru_memcg_aware(lru)) {
+		rcu_read_lock();
+		ret = list_lru_add(lru, item, nid, mem_cgroup_from_slab_obj(item));
+		rcu_read_unlock();
+	} else {
+		ret = list_lru_add(lru, item, nid, NULL);
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(list_lru_add_obj);
 
+/* The caller must ensure the memcg lifetime. */
 bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
 		    struct mem_cgroup *memcg)
 {
@@ -170,11 +179,18 @@ EXPORT_SYMBOL_GPL(list_lru_del);
 
 bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
 {
+	bool ret;
 	int nid = page_to_nid(virt_to_page(item));
-	struct mem_cgroup *memcg = list_lru_memcg_aware(lru) ?
-		mem_cgroup_from_slab_obj(item) : NULL;
 
-	return list_lru_del(lru, item, nid, memcg);
+	if (list_lru_memcg_aware(lru)) {
+		rcu_read_lock();
+		ret = list_lru_del(lru, item, nid, mem_cgroup_from_slab_obj(item));
+		rcu_read_unlock();
+	} else {
+		ret = list_lru_del(lru, item, nid, NULL);
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(list_lru_del_obj);
 

---
base-commit: e2bb30811e063ce0db964484357973b855b06572
change-id: 20261128-listlru-66b-4f52b255ccfe

Best regards,
--  
Dickson Wu <dickson.wu@certik.com>



