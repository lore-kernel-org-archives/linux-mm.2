Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9896C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4593D6B0092; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409A36B0095; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D12A6B0093; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04B9E6B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C6F014045B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
X-FDA: 84972993126.11.4A32A37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E06F380009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7USbvXY;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmfZTk/ZQOqnVMZqrheWjYkpxjXzlgMLoos2A38U/W4=;
	b=zL7unhhx/cTkhHH27Vpt4bbe9eZVPMEHVblFDicLmQHylwuXm1jnBgl7ZYkjYA/krHE4wM
	GXVprfzJVvwaSebt4hAyi8BCNskAJQ4xqnIwdgvjXf8+E0d00IbC3BUMU6q3HEo7bmGG7x
	lunutqD3V1CVlafIrgqPbkG2a6aLqMU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7USbvXY;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691221;
	b=pd6eN27Bqfxr0Y7LPRtPdCQbDa84+QoJY6WRRzwLqbtszNSfqWblRI3jFWKjcuM1JQTyyR
	khjdM8lxo2ascbHlWPPsw0EMUlDs/XDzoxFb895tVg8nsdzi7OAkgkCKKoQkgue8Dq2Llo
	t7euT+cZNb3DitJcsRgTK1Q9XQsohNo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3ACB43C2D;
	Fri, 10 Jul 2026 13:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3401F00A3A;
	Fri, 10 Jul 2026 13:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691220;
	bh=YmfZTk/ZQOqnVMZqrheWjYkpxjXzlgMLoos2A38U/W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7USbvXYMsHXGrpw4rOMNRw5wQyDSuQe5WE+vlNr1rTdxQ0V9e90uVNK7jx8sg350
	 y0qmnW19lPKSn6zAlicnMAKlHgE+PQ1KJ6xKP8nG7i4IMwMRXaAi3RnBWrGMnDQFhy
	 Oz/NKCZfEq0a6UytK2oa557tZS+o5hNJpmPcqX8KqsMLmbTKAyh2zzNyYxwYAZo7fF
	 l8Magt0XFb+DltxWV9kzyBkRu+sM9nA2JDhPWcKMIE1FkvYVZDP1ufwMjLhcJYOehR
	 Ovysr0Kg0kl3Q60p8z20A2oCFBMQnctX/5VVOxrKeD3l/Yb74x32VZBl7KQdlOHeOP
	 qBAQYGwGJBLZQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/19] mm/damon/core: introduce damon_probe->weight
Date: Fri, 10 Jul 2026 06:46:30 -0700
Message-ID: <20260710134651.18084-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zrk6q8cyotoh8wbs4gs6qubdhqfqtptq
X-Rspamd-Queue-Id: E06F380009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783691221-573129
X-HE-Meta: U2FsdGVkX1+DFd55xO3qlXhUxWYBBrs4bcRQpUmCSjhTpBbN2woaU1FYps0Xuv4FHMrIheateWn3o09+m7SpWbe/DExf5glgOOPCPNzXu/VvcTMO9f7zEEaD4oevHYLJqVu5S7uFYvsWztyaWMk/hMRHrdBfpJrvz3DHUQO2BSlsqSpvT4khePDn/MlADVHDlbWh48JMpAi7Nuz1UliXnJHA3p+Ysd6q1/wOYyb0/A6rYiRnPpVP74q0+krD2uT8GLbVzqgKq3AExRY0uqSo7n8XK1B8wNh9nOuhd9+wgKxgxOGa1AJokPXH1SKLaM9UmBBfC6SfVbchIWq+swJrx07PPoLyPgW8f6jvE7utbf5/zwFo8aletVijT2iFFO8EGJKmkP9DgfkK4uVmVcaWwLKb5hpAuHkJr+Bc5Jkwrrwrgj9r7FuBzRNypISvODftTPGEywCYzsf7jBkovQPesD8KeCRzWemiX6fJChh+RNlKRGLSqMAvNX8DDxOVmN5Rkm6TLdGoWxfPAfSPr8poLIIuPyzA/5j5iiEtP+dQyk2Nf1d8jrEBe7nziEln6LMky2DmJ0qHWtdH+ZccMIujAyiaqlcQi/gj/Bn+VbFw9VfcPeuYJ2ny4INzu9efnfBNj5lyCanbi0hnUwuxGUiGqT94DqQOEx8fJGdy4vpCQqSBxNKF2SE/+N0c3jLra20eAA0HMzTZrGPk3YFbwDn/X1fxQSUnC/e82C2ATCnfx8xkgQqBlh7BL0r/20KZ5DSVVD55kvle621FrqCfXAlhkqXjckVHwC1CTVZIRzByjTs7rCpge1I3KEgR0517/6I3NNJ3Xo3r9ojO8MvLACsf1yuN5hgzj9AQt6hGnZtN5D6dcg74cLhAKxoU/8893bsjHgMGMeQxL30DvmDS1F6y/NsJvPK69/7TvIfZRrj+rmJjz/3DcVOyvMKq00VrG++4tll05OoeEvGwi/lK+Wv
 VW8jfNFL
 Kd6enZyBcG4T2CC73h+D4M5dB7jQv7uEAT/UkQz8F/Df015gqkMbk9hLqhs5sTA8Rg5hFJ31EwHGKtM1DXCB0ICrAfjoXlKRDjlXAJ0wgZZpo9PsgAJWc+ihnFZCy77GjGLFockcGyDcoRJ1xqks7lZTkeFcOF4TlNjJ982b3zpyfqjK56a+jDJKkeZgu4yFTYXfnfiZByPx3THQ6kWfvjBD2V1nJjMiwFBMed8Qtx6vpwn8i4koS7dzHPk9/EdfcHnRPa9yzny4MEd+zKN7W2fUb2VMz9JOVRkIdyFchlxPakqOTQgU9f2o7ibJ+f4QrfgUOx6aLl35EfTJCeCRV9xOrXHRsFWmLvTEw6hC54FHGuEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new field, weight to damon_probe struct.  The field is used to
specify the degree of the API caller's interest to the data attribute
of the probe.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 mm/damon/core.c       | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 63f596957c1f1..d8251c83e6e55 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -760,10 +760,12 @@ struct damon_filter {
 /**
  * struct damon_probe - Data region attribute probe.
  *
+ * @weight:	Relative priority of the attribute for this probe.
  * @filters:	Filters for assessing if a given region is for this probe.
  * @list:	Siblings list.
  */
 struct damon_probe {
+	unsigned int weight;
 	struct list_head filters;
 	struct list_head list;
 };
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 11473aa1f70f4..327398fa4ee56 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -166,6 +166,7 @@ struct damon_probe *damon_new_probe(void)
 	p = kmalloc_obj(*p);
 	if (!p)
 		return NULL;
+	p->weight = 0;
 	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
 	return p;
@@ -1658,6 +1659,7 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 	damon_for_each_probe_safe(dst_probe, next, dst) {
 		src_probe = damon_nth_probe(i++, src);
 		if (src_probe) {
+			dst_probe->weight = src_probe->weight;
 			err = damon_commit_filters(dst_probe, src_probe);
 			if (err)
 				return err;
@@ -1674,6 +1676,7 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 		if (!new_probe)
 			return -ENOMEM;
 		damon_add_probe(dst, new_probe);
+		new_probe->weight = src_probe->weight;
 		err = damon_commit_filters(new_probe, src_probe);
 		if (err)
 			return err;
-- 
2.47.3

