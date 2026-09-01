Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D662BC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210586B0185; Tue,  1 Sep 2026 09:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7606B0186; Tue,  1 Sep 2026 09:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6796B0188; Tue,  1 Sep 2026 09:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D65326B0185
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6BDD2A4148
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:19 +0000 (UTC)
X-FDA: 85165264758.05.2B540AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D4B43180006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cjHZ25Oz;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269117;
	b=ZE1GJKVDJ6kyORI85gye8/n2PUFSEQIImAyqBwgLjhueToH2J+ROo6y0mVXId6NcTd5BhK
	q+8Pn5RlY5YOD5t5FEiQxFlmB87BZyFWoWOQ6RG5KAzKn8NFRtifclxb9rFlPNdLKG5tQT
	P6PGZhoYfQNiIrqd7zTZ6ZJcv4xYPB4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cjHZ25Oz;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMsa03+GswfqkWjEdLMDvVsbH1S2RLUAm5b70sXm7PU=;
	b=BpG1/ul4zmQp1UoWbSS5M77j1Oc6N/RJO6vjp86lGQw27F9zi8t6bcPzETPBOO0dtmlFcF
	HkJJYuO1IRW/1XrR0fWCUNTcOy+tJopAJfeKGFk7yjjphCoNQxZ5IC24pXtNvrwxjrghyt
	v4tpaqfUqvepyC4zTw9Mu2kIupq7guE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62BBC60534;
	Tue,  1 Sep 2026 13:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43551F00A3E;
	Tue,  1 Sep 2026 13:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269117;
	bh=IMsa03+GswfqkWjEdLMDvVsbH1S2RLUAm5b70sXm7PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjHZ25Oz9d82f4iu/ntoDLNgS2VHC5AmV6rh5E+Cdfgc3to7+yhLlvPEX2uChGZMo
	 R216F4gJzmaXRU/IB7ICEXe/Ksp5KLkNhyYIjR9PS1bWyF3EfkAN2Hc5Cqyfe3JkNa
	 orR7HlexcFuv7sl1bPktoBgTSYCyILVo1o8TPSQvfMqkXQIi/6oeEqtb9jY7YZiRIp
	 WhFjaHmYv1dYJfBY3Nec64S0vQ/zkfPTumWbhy4IDWr+AW4CUq7ljK0x80qyYrGnmV
	 JVqhyGLeIwJRWwDyfT931jmnYop3PfAVz267XUQMS2TKFZGcXa80Pnpo1xj/C3b7V+
	 SUrGZXhWZKFbw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 06/17] mm/damon/core: commit preps
Date: Tue,  1 Sep 2026 06:24:53 -0700
Message-ID: <20260901132506.99243-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 694po6eotf48cxg67np8wwncodi8bud6
X-Rspamd-Queue-Id: D4B43180006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788269117-113904
X-HE-Meta: U2FsdGVkX19cwUfULMoLjjx70/JEtAzk2kxTJY4Rok3W3yNIvngy3AqeLN+Azh7rFpFP3P8+MkJFMtZPY5cXJDwcKCbeNKptY6dLvraLR7se7SoEwzNoxKQlZORktWKBHEaRluQ2etI73XLPEfVJ3W6XuNOIP4f8xV/svaqu6QONbg8FL+dQMJMy1gVYz5hpI1MV3cGgoLwA9uWHDVMWogKAY2Pcft2TqDfqa91IIOyKlJAakxEeI+W8yeUFn8YDPUohgSQvT86tepXZCdHwFp0+q9f4eDdrDDHJ1gwqBqckK0BAZ7/OyiJV0gM5Jguv4swwOG2kfx6xV2XgvZenQ2Lqc7w3lbEW0YO9XpZNlARfhSl8NSCw/UMlKddZY/fQgqnicFaQG3Lxb2AEKT1YdhCeb8vYzP/0FC66CuZElBIXQCtC6ulKLUDkdJmRYL3FaF29NX2Vmb8AFyC9ucKPlwJRQXOKx+UF0LaaPyldpL/xMymNErPO+DRioJMw4ytolc9VPMwFYrkVxpxTl6YD7RlS+bVD25xFABzNBZhI8hk0Dt4EpR9eRaQMyjLQJKuIWacv053eRKB3r83QglibD+P3aYphMJJVMhBQsH9YPWv36DbjcgFXXY+OOQhudD9z4CHVW3OYp+/zU7rdVitSlz00LgH1OVN1aH3exYRxRY4Q+sjLOnkQ8RRXhllvcVD0j5h12kW6XTG3Upc1kIWiXDb8n6DZBgUgNP81WJv1TvNWTZ9OXd+gl2MIef8DK/IbU2yYK2+yiq7wklzmCIuFc1tcDIYkHrs1GdCG3vvuWvNAs+0cPw4C7gqUJxuRvSak7ZDWA+WpVwFotvM93nypkiwPz+82szH2jfVS7jL99/f+ynaCMJsipfrvxpFlSXneY7wNK/3WyjGLQFszld3pP0EiPTJl+2SXzGrOGKaTGVsJtxLtYdWd6qcauhwZBHDg5eU+1NE63kpZ3Sj9wYH
 31NhwYYi
 7AJWHpNLglhG6klK4AyO7hKNSdvo7KWwmaTycgkGmxiR3kd8Q/Pc/luElf2dC+DZHpqIveuJEqcQYTuyEdjuQFnZxX0ZMVcPrmsms7pdjb0Yn0qIWFeCKpqTEVrV14uzM2DDDikn9vx/w6dmeDJGUcpIabV7VFC70HvUsA4JitFWlJVSmTwX7bkidx/LDLaVfv2W0wiXadGVYCYGTBYemQb7TRl8ukldcitHWeSVdBjKVNH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_probes() is ignoring damon_prep.  Commit the prep actions,
too.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 85774dbca64b8..87ac428358ec0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -129,11 +129,34 @@ void damon_add_prep(struct damon_probe *p, struct damon_prep *prep)
 	list_add_tail(&prep->list, &p->preps);
 }
 
+static void damon_del_prep(struct damon_prep *p)
+{
+	list_del(&p->list);
+}
+
 static void damon_free_prep(struct damon_prep *p)
 {
 	kfree(p);
 }
 
+static void damon_destroy_prep(struct damon_prep *p)
+{
+	damon_del_prep(p);
+	damon_free_prep(p);
+}
+
+static struct damon_prep *damon_nth_prep(int n, struct damon_probe *p)
+{
+	struct damon_prep *prep;
+	int i = 0;
+
+	damon_for_each_prep(prep, p) {
+		if (i++ == n)
+			return prep;
+	}
+	return NULL;
+}
+
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow)
 {
@@ -1706,6 +1729,36 @@ static int damon_commit_targets(
 	return err;
 }
 
+static void damon_commit_prep(struct damon_prep *dst, struct damon_prep *src)
+{
+	dst->action = src->action;
+}
+
+static int damon_commit_preps(struct damon_probe *dst, struct damon_probe *src)
+{
+	struct damon_prep *dst_prep, *next, *src_prep, *new_prep;
+	int i = 0, j = 0;
+
+	damon_for_each_prep_safe(dst_prep, next, dst) {
+		src_prep = damon_nth_prep(i++, src);
+		if (src_prep)
+			damon_commit_prep(dst_prep, src_prep);
+		else
+			damon_destroy_prep(dst_prep);
+	}
+
+	damon_for_each_prep_safe(src_prep, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_prep = damon_new_prep(src_prep->action);
+		if (!new_prep)
+			return -ENOMEM;
+		damon_add_prep(dst, new_prep);
+	}
+	return 0;
+}
+
 static void damon_commit_filter(struct damon_filter *dst,
 		struct damon_filter *src)
 {
@@ -1764,6 +1817,9 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 		src_probe = damon_nth_probe(i++, src);
 		if (src_probe) {
 			dst_probe->weight = src_probe->weight;
+			err = damon_commit_preps(dst_probe, src_probe);
+			if (err)
+				return err;
 			err = damon_commit_filters(dst_probe, src_probe);
 			if (err)
 				return err;
@@ -1781,6 +1837,9 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 			return -ENOMEM;
 		damon_add_probe(dst, new_probe);
 		new_probe->weight = src_probe->weight;
+		err = damon_commit_preps(new_probe, src_probe);
+		if (err)
+			return err;
 		err = damon_commit_filters(new_probe, src_probe);
 		if (err)
 			return err;
-- 
2.47.3

