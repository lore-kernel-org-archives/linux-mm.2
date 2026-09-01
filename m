Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 592C3C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963BC6B018D; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8767A6B019F; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73E406B01A0; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9E26B019E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBA76A0439
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:20 +0000 (UTC)
X-FDA: 85165264800.25.C7B1003
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1E33F14000F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ADcy2puK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGq3BJdNnnCTCYeGqjvgppOd2nVk87x7Bo82sRuFOlA=;
	b=qW+vPBR6gLg+SX8kXmI6b1QskCABRvxyZyJIQejoKHaZrziIbSAjamcMxOWupYTlhmwVdU
	qUlt5sXQjOYVbGUHoUdL5AROArLULnNqG60Kf96oBwZ0UC2bT52mwt+2PCO9oYNKtJppzh
	l2Sd2g3r5/vNYSH4dniOUyo597cIJmo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ADcy2puK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269119;
	b=dZoNgo3M0e5pl0MDuXGxdxRvPAWWUVjILlINluSa3KpjTdtgHbHtLjXXtdPkN064wW25gB
	sbr1pf14HbhvnQ+EuDyXGdqaW+FG79sTG0I2Sxt0il32VfBNWTmrlolYZ5SnQ0AQTwNVGR
	7k2CqcWK2KqZVapJIB+C/Jyu722B65g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C42B42E93;
	Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD831F00A3F;
	Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269118;
	bh=SGq3BJdNnnCTCYeGqjvgppOd2nVk87x7Bo82sRuFOlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADcy2puKfNE+YefSZfb7hqHyzErBhrUz3VAuvNmNrIirudLMcD2NYz+iKmJXkxHIZ
	 BUgXl/ggB/p1Pw6NgDY34XZDTXlgMN76BjQMxuY8k+JCon69wEg6Pw3ihVO0y6sRB7
	 UDkVZpBCuth5JOst5k48TYrQMfkDl/pft7z/sZHqoblCDixZa7jg1kfiC6VfOrBoue
	 LGtDbpl7HaBrqZu+2bykoaOVGDYr2eHJ1CB+/Teo25TyPqTZXFWeeDfvpxigeVoFt1
	 gNVbQWVPMTawaN2cM4LilikB5hs8CzJlT2iTU//TsPD+8o+a124hTaJ1QlDGv1fD9X
	 pgJm9Q3yqEnBQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 10/17] mm/damon/sysfs: implement preps/nr_preps file
Date: Tue,  1 Sep 2026 06:24:57 -0700
Message-ID: <20260901132506.99243-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s39e7pdfm7yjb15qm5rcjqbib6mp3u5j
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1E33F14000F
X-Rspam-User: 
X-HE-Tag: 1788269118-719224
X-HE-Meta: U2FsdGVkX18FCTgiXyBykYFXeIt2thFio+zMVheUf1kBClOFgcKW039ueO8L4WFeMdDpvZ/g6lPCJ9MMemSUOC2UPwK9Tv2yR8+w2L7jaSwkEu8nBtYKfiy7U4vmF7aP/IzBew+rpGdXIqLW/fYFVH/6u2htS8oXZRIHd8kI53H96cZRxLq4YhcpTY4NQ//gEVJVy7LWgSG9ZpU5aV5Q9ErJXKa6QkRIcHiAbm9E81XYCnKlul5OGJEhGcCjwaLHtbKbUjsSQjSghXrX4cpbInLhIhXn9kQYh/pNmYN/BqzEgpP2VidyiXfXTFLNpg9L90NkJy2iGX1DbVkcqE0jjkn6D6SsYmVUzWmHlfcQoGD7sBYl+XJlFapbZaduuMtUbseLiezl19/OerH7qMkO1tKQi68Sjg2kvpoYTMzF6fMPST0GkD3aYq/tEBWuSBRaNyzi4cv0r8ZVTmTZpYA6pScgrk4pNXd/3zHxPMLaVqh1HP8YqJvvuEUUwkddPxgbodjpeL6Bfo0FgTvgEDzpdiaK5ZDMKVPjyfSnbYdUVQp8SZj+Z6yOvVFWEFB7pnGaKrREwDet/crL9mD+UJ7WiPp4wWCiqwddRIHyFDS6WsfFLEL/0gTViX4rs5EedtZwk/G9c1Nx3yFMCtMCQsrfdzktTi24LlyUukHjKzOI9e/sZhKQp6gzBeXRohK1J8NH3V6dorKRqlnzk2YqiQgLPcH5Z8G0rqmZqZ845emlZiKqCDpdnrIZhmc8wMQi63t+p2fwhbexk/w2OPMH9iINruIUHklNw5CdEiWDSMZdPst6YRcP3R+sd0kD6z48lCpiqYW3O/dV7yLDYNtV7MQFmZdZCGgz0DLPeIkCqPfpdM3VZoxQvL+IuFanHNZQTM+vjTdo7DL0/ckIP7EqvZsmt6h0ZUWDCTAriMMtZU/TtlsRkjY8IPaODndVeqNA+rZpy5nsSYDkcZhBSnvakL/
 ICYacUL8
 ++MlpuLu/w4NdfVz6S+y2a9x8Ac7c5Kf+2ddhepWIbsmoKT90NUdopG0kYgSGNHH+EoCgbU8vD38HPcKfzBJAGtG148ya4hxXvq6XsRU3fom0lo7aJRJOceFcRtS+BGp+oknA3107fZ+G/mBrMn1A70kAUSpWff7ieR6k3oqKon1ir13Hde+jhNF5HlgJFRqvxkr5UZnEyHAS/QcWAYlO9tlxrRNFG5XjLr4+jkV2Jz2VDgA6Oifi7QVoAoA4iDh9Zr0b6aHm0aksTxDs1gtWyseceg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement nr_preps file under the preps directory.  It will be evolved
to be used for generating sub directories that will represent each probe
preparation action.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 09641257d3a89..1d2d9950716e1 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -755,6 +755,7 @@ static const struct kobj_type damon_sysfs_intervals_ktype = {
 
 struct damon_sysfs_preps {
 	struct kobject kobj;
+	int nr;
 };
 
 static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
@@ -762,12 +763,60 @@ static struct damon_sysfs_preps *damon_sysfs_preps_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_preps);
 }
 
+static void damon_sysfs_preps_rm_dirs(struct damon_sysfs_preps *preps)
+{
+	preps->nr = 0;
+}
+
+static int damon_sysfs_preps_add_dirs(struct damon_sysfs_preps *preps,
+		int nr_preps)
+{
+	preps->nr = nr_preps;
+	return 0;
+}
+
+static ssize_t nr_preps_show(struct kobject *kobj, struct kobj_attribute *attr,
+		char *buf)
+{
+	struct damon_sysfs_preps *preps = container_of(kobj,
+			struct damon_sysfs_preps, kobj);
+
+	return sysfs_emit(buf, "%d\n", preps->nr);
+}
+
+static ssize_t nr_preps_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_preps *preps;
+	int nr, err = kstrtoint(buf, 0, &nr);
+
+	if (err)
+		return err;
+	if (nr < 0)
+		return -EINVAL;
+
+	preps = container_of(kobj, struct damon_sysfs_preps, kobj);
+
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+	err = damon_sysfs_preps_add_dirs(preps, nr);
+	mutex_unlock(&damon_sysfs_lock);
+	if (err)
+		return err;
+
+	return count;
+}
+
 static void damon_sysfs_preps_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_preps, kobj));
 }
 
+static struct kobj_attribute damon_sysfs_preps_nr_attr =
+		__ATTR_RW_MODE(nr_preps, 0600);
+
 static struct attribute *damon_sysfs_preps_attrs[] = {
+	&damon_sysfs_preps_nr_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_preps);
@@ -1149,8 +1198,10 @@ static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 
 static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
-	if (probe->preps)
+	if (probe->preps) {
+		damon_sysfs_preps_rm_dirs(probe->preps);
 		kobject_put(&probe->preps->kobj);
+	}
 	if (probe->filters) {
 		damon_sysfs_filters_rm_dirs(probe->filters);
 		kobject_put(&probe->filters->kobj);
-- 
2.47.3

