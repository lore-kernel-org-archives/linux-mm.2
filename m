Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 697C5CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A52B6B009B; Tue, 12 May 2026 10:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D7E6B0096; Tue, 12 May 2026 10:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780406B009B; Tue, 12 May 2026 10:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5597F6B0096
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 022E7C1C5E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:01 +0000 (UTC)
X-FDA: 84759019884.24.71E37DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 385AC40004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:36:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ppLexMir;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qEscwrNOdzu6oYO6SHyp2t3bg4C47DzpGWWecYRMDPM=;
	b=PgTHXyYuR78a0u01tJPINAdFBCKZ27i+5ZsmNnGwKPWWALZ3vkriw/knH9fS/JhUWSHHyi
	lPyepNnlIENGICKCQ3xT+qPsTTZ+oLbtFgO2NpxkmfdRRy2lCQddmM8RewhSoqCRUIsaE/
	+tIC6RAE3uJEzEGt2DuI7k8GhYYunp8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596620; a=rsa-sha256;
	cv=none;
	b=7xhZWzLITUPj9w//Ek3MHYppbeIQwvpRaBi4qd5ND5x4fuIG1enQf1vkKFESvJTO3HW574
	r49+parb2gWcbgBQhWzNhmw2tZ0JFfxpEzdamauVsjPZoTDFlAZDfw53NmxDsObPai7Jnr
	5BT/wNDWPJJl1vZK09ouRTcblEz16go=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ppLexMir;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 609D444AA2;
	Tue, 12 May 2026 14:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAD6C2BCF6;
	Tue, 12 May 2026 14:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596619;
	bh=OKhmfytBqX/7un5Obh/JeNbzocTBgyUdokH+J+a21+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppLexMirhSeD9E+SCsqA39/jd0rc9uOgTn8XQSvvohheJ4uFm1wYys1uncpVtJJdJ
	 ZfQXviR97WUSVWsXSAmIpJejuiuTNgy+IEyjQhEbYok5qXsEu7FOXfKzT4JGuSmESU
	 E2afXBz6oCWTqdKUQuzRKRMSpw7PnOgdxEmsnlHFtys3wYOD7hTS3S44J25Tsbz40C
	 VjX0TUn/Sm8QK1k2sBHwGU37CjpBSo/oEMH5v01E1M97S5jpbERbTYCWwQXadfwQpE
	 DVfSRlzEp2zVwliP4CJubiVlO9zLbylhoUV2ylJNemGyKZIEoczNgm4ARSrqBkiP8W
	 5xAadZlukYt1Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 04/28] mm/damon/core: commit probes
Date: Tue, 12 May 2026 07:36:19 -0700
Message-ID: <20260512143645.113201-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 385AC40004
X-Stat-Signature: kkxmb5gw5waxfw8kre3qyjc5xuqu8ca4
X-Rspam-User: 
X-HE-Tag: 1778596619-749215
X-HE-Meta: U2FsdGVkX19A1WJay1kw5T74xjUupcKzbUFCaEPoboqE+sAcNQmrWogj+equSVxQdUoOJkgyAd0QOaLXKLf2rKMYoYmNbODDvqJWeKrJUDVMXwcB1hDXzy19XlDyvMX3HQ5OriaZ2lu54p/JzebPC9MSw9a4vUtcbKShNTQaMpuG+taU7APBenV+QvWAp0tmKLALxMmGGWIxEdy9OSeX3qSHBslZ7vvpq2UgDseixUM9V7pFDXPIcjWkyVUq/DvWNZJ0aIyyz8WT0fFUZBeZcl2vtyJlwCySgrG5rh91Zmrq49fQ43I+Fv2SrSXrJ9CC5+RFxL3gc7ku2MTP63FnXpv0GXag+I0vocWH86/EzArqO+jaG5dYIRUEV9QKMPaejtQknN4SbsYoBNKXPnQff68vU2L4H5+Frm5BhnGSU5LF6wklrwA8l0V3ZadtZxZwLkO2h6IXtNlJHV5PCoJ3GuwSFOqbfZYbQ7Zi7Je93pKGSmM94psEJqXltb9la2LZd15SP2g6+qY8XiPR2UEKjP2GBc4lzsim+7D7XyA7RQfZ8+/FngIhCyS0TwpfabdPZR3M8A/3hd7l28Htt3SFE6SJL2z2x5mxWlGXtiYdvhh0RD9OIVz6ow2yIBirPwXEeHl3DCTTxYP3jB34kBh/ukTwQtXtQXghnOj56RBFIvhvsixg8vRuak0qBR2c6RHVdABJzzkkClA+njeQlWUtmPeMDsGv8/hh5JmgaEoAPihlNEexLiaMctJpU3XHQkJxZg4etR/nmSsu/RcOKElZL9mxbeK0LekhxpnbAqeMZmRX1SkvQ2vTEHldcfGRZcHIGAlHEUMkKtIMkU00/gItP347c0E4SNKOKzBNjx392dUlswZEQlTq7sFJftjcNDDboJ2XyUG0W15eLgDZ9cyY7e2UeeeqRGqO5OoxM1EID27g0jk4yZ3ghRigaH2rmbn96gSmtq+b6BK9gJ3aVd8
 Dy+HZk/6
 ZwYneas4+XiZHHWrBAYwY69aoY623g+glPVjhvWnlT/eUOKkQu1Xjnu7sTcqc5tnw0qDLesLWDoY2W42XU3cpgQBodgDrYzckDHUeCtp8y0knNAiFjd+0Vhs605iSiJyXnT8hLMfBm1T0GzgOpcfa4csyNbz1LfAkm+COGgbzJNChUumejAYu584Q4T/ANBnoItJUH8yiw+zcHUaRoSd66N4n52CRyvbpkS4pOalkT7N4vBw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update damon_commit_ctx() to commit installed data probes, too.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index d01417955a3b4..240cae1420c12 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -133,11 +133,34 @@ void damon_add_filter(struct damon_probe *p, struct damon_filter *f)
 	list_add_tail(&f->list, &p->filters);
 }
 
+static void damon_del_filter(struct damon_filter *f)
+{
+	list_del(&f->list);
+}
+
 static void damon_free_filter(struct damon_filter *f)
 {
 	kfree(f);
 }
 
+static void damon_destroy_filter(struct damon_filter *f)
+{
+	damon_del_filter(f);
+	damon_free_filter(f);
+}
+
+static struct damon_filter *damon_nth_filter(int n, struct damon_probe *p)
+{
+	struct damon_filter *f;
+	int i = 0;
+
+	damon_for_each_filter(f, p) {
+		if (i++ == n)
+			return f;
+	}
+	return NULL;
+}
+
 struct damon_probe *damon_new_probe(void)
 {
 	struct damon_probe *p;
@@ -175,6 +198,18 @@ static void damon_destroy_probe(struct damon_probe *p)
 	damon_free_probe(p);
 }
 
+static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
+{
+	struct damon_probe *p;
+	int i = 0;
+
+	damon_for_each_probe(p, ctx) {
+		if (i++ == n)
+			return p;
+	}
+	return NULL;
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_new_region(unsigned long start, unsigned long end)
 {
@@ -1386,6 +1421,72 @@ static int damon_commit_targets(
 	return 0;
 }
 
+static void damon_commit_filter(struct damon_filter *dst,
+		struct damon_filter *src)
+{
+	dst->type = src->type;
+	dst->matching = src->matching;
+	dst->allow = src->allow;
+}
+
+static int damon_commit_filters(struct damon_probe *dst,
+		struct damon_probe *src)
+{
+	struct damon_filter *dst_filter, *next, *src_filter, *new_filter;
+	int i = 0, j = 0;
+
+	damon_for_each_filter_safe(dst_filter, next, dst) {
+		src_filter = damon_nth_filter(i++, src);
+		if (src_filter)
+			damon_commit_filter(dst_filter, src_filter);
+		else
+			damon_destroy_filter(dst_filter);
+	}
+
+	damon_for_each_filter_safe(src_filter, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_filter = damon_new_filter(src_filter->type,
+				src_filter->matching, src_filter->allow);
+		if (!new_filter)
+			return -ENOMEM;
+		damon_add_filter(dst, new_filter);
+	}
+	return 0;
+}
+
+static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
+{
+	struct damon_probe *dst_probe, *next, *src_probe, *new_probe;
+	int i = 0, j = 0, err;
+
+	damon_for_each_probe_safe(dst_probe, next, dst) {
+		src_probe = damon_nth_probe(i++, src);
+		if (src_probe) {
+			err = damon_commit_filters(dst_probe, src_probe);
+			if (err)
+				return err;
+		} else {
+			damon_destroy_probe(dst_probe);
+		}
+	}
+
+	damon_for_each_probe_safe(src_probe, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_probe = damon_new_probe();
+		if (!new_probe)
+			return -ENOMEM;
+		damon_add_probe(dst, new_probe);
+		err = damon_commit_filters(new_probe, src_probe);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 /**
  * damon_commit_ctx() - Commit parameters of a DAMON context to another.
  * @dst:	The commit destination DAMON context.
@@ -1442,6 +1543,9 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	}
 	dst->pause = src->pause;
 	dst->ops = src->ops;
+	err = damon_commit_probes(dst, src);
+	if (err)
+		return err;
 	dst->addr_unit = src->addr_unit;
 	dst->min_region_sz = src->min_region_sz;
 
-- 
2.47.3

