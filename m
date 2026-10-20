Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0ACE606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 02:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xyqgyjm5
Received: by kanga.kvack.org (Postfix)
	id 49D5C6B0126; Mon, 19 Oct 2026 22:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426C36B03F0; Mon, 19 Oct 2026 22:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EEF36B03F1; Mon, 19 Oct 2026 22:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 06F876B0126
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:40:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F75EC0875
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:40:09 +0000 (UTC)
X-FDA: 85341450138.23.2F90C75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EE8CE1C0004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:40:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xyqgyjm5;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792464008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=60QPBhNMCngRfmcAjrxpcv4Imf6U8Bv5IKWR7KuqOvs=;
	b=FMR1GiTAwtN+g4Sp7RyIz1YyGjjAhTyr8pnxpXQ3MvP12bcuWEKIGIMhPwNF9Q9YwLrNlD
	3QokB+qUKSCncwhf1D+hcIsQq/qLkRyjXjR6VD4zUeNbiAtG+pU6iF6xPZuAPa5gMIX1/5
	AvcQM93p5/als9K5Ck9mHooAH/LQ2ek=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792464008;
	b=tMWrKX41lut8dME6FNmzLa3ONdlPrMOxlSjHIUHIO2CqDYInZs+BHYB+Xri9hdHbdvLv/D
	GfsOXA5gMPyBxZOfrWE0POhdarDu4Sp/w8y0mvKUJzLSHsrPVyewqK6YoapjMuC5k5Y+m4
	EB2zX0sGBLos1Tyo4NTa2lALaKNU2Kg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xyqgyjm5;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B8CF560098;
	Tue, 20 Oct 2026 02:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9241F000C4;
	Tue, 20 Oct 2026 02:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792464006;
	bh=60QPBhNMCngRfmcAjrxpcv4Imf6U8Bv5IKWR7KuqOvs=;
	h=From:To:Cc:Subject:Date;
	b=Xyqgyjm5aAEUx7O1C9+9sZ9HoyLu1TowKrpLnSkIE2mnYWjuicwO9PecBk4neY/QR
	 qOEt0O820lHWWZw3hrx+f6My1KevhlIB/FNNOapdeq8Uub3voWMxb2nb4Sc5p+QgMB
	 hncjtTQ25QsrGw6AmtFQKsg4WlFMZsuz0ekg82bW9XeertI7dDcyOhKPjRqT0vbvqU
	 eGdfGNIsslgL/v044qhPF79CYZ+XN03Gbjj8gygXSkwtNGkAyAiXvg8GcgzJb4m1yz
	 qyhk3F4OfK1NbUu5zoNOmc2UuwaXjO8xZTM4+7XL7MF6zv+DSxIYaU908k6iF2gqTW
	 4cycCLMbtUWnw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Mon, 19 Oct 2026 19:39:56 -0700
Message-ID: <20261020023958.108276-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EE8CE1C0004
X-Stat-Signature: jgh6m3665gm7tro4syf91d8ugmrjeun9
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792464007-306990
X-HE-Meta: U2FsdGVkX19HAZtnIb3BAG2L0rq5UhSopsgltWgtaBkrkaNzcdJvvxLh6SQhhn5gyyMXgipeB+GMWyGYuNa6qHW7wM86VgMrSLHLKs1/Vq9i7E26LKE2LdKBwC5rff74VlOKwEg03OzdSMKmE7xBXchhs5RXP07pz3XyZjUQFH/DuYfpvkAafhJCAxFD3Ql0bTVwDZ+2eB15KWzqsfdp9K3o+TCj/+/Nxuk/mt935mZE43hhpAumwAdUUARqaDEA+FxkgQvDlSaNa8DYvpVYbckUaWlNH1HmE38/9cycC0pOB27WDIxbn/WdKjNHMGxKjXPae50IWXasErIenyORyGWYffJvVCAmS3NQrpejl90z2xF5KsnqGmCAizcf83dFnGW79wdcasGkN0MdeBSb1TupKTu/ADIknVT5BxBwZWdW+Wd9j5W2xx/oWzu2rFZLbPTlrFyih//cPmuvBoU1UMB4DmxkxWopB5bV5jvLUxOkNigOJxroasGl+Nslbaez+0l55MdwJSAnL567d6plNhGZ3NgDiUp0TwrdFlWqXTyxSUhP41yHdYLTFQqK/CJjHEWz1zp1Y458Xd9efRzHABapUnjBwHO+xue7A7cJyheP8g3FPmbpBNhwMtWgF+V8ZXsQelD4dWCQsC3kFWprWRCZvuWLRLAA1LpRrcXVNU5sH+XGqOPHYpnjX3X2k0oxFtvsWC7dIH8zKTasB4OKCU4kyWS48TGqa/pYnyHNghwf0fl35+Ler+AwNY8iUUe1IdCNkbz/2qLiwwMIRedBEeBaIw1BnXCdboUH2ZNO9j9xgSBeQ7wg0Udf+prTGjZ7ZehRURH1i9wdw2821wQ7X+3ZoIlFzhwARgUVDhILat1KeRE//jYbwJQD1c5fco2db+wdFe/iRp5nmREvfiTq0jAmbB9kmCQcWEhYv2IIFKvR1CyNYPSJD0PDyRULq/H66kfSnjOdc2CXRYMj7u+
 buvFDCuQ
 akeLTYwj8tTyA7PnzYEsoBZLZAIjGde87PhhCqOyDKnRunICvyEaZv4TThb93HkG4opl8x7vCHgFmfqYsoo7cFbANJpRe/eeIwJHe3MklVFXEGKcnzkPWyLZrfoKcLMfYza+LWElLUkhgOY4jyWBxJGWxuH0bOezhbzFclXUwoxTZm62NqnUgi/peXWnUAN9ezaxWnhua4ajLFVYQSPyR3ciuZ5U8xNe6+YzYZTjZ5dROT2LEBeeHd1E/L2evlUJJ0vu5yVHTxIxgmBo/sxv0guHsLAu0xFLgd5CroyXXn26ytGWdGztR99bsmtfbgjTG8bzPgJzPpxsSPPCg698cVdtMsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_quota->charge_{target,addr}_from saves the target and region the
scheme's quota limit is reached.  damos_skip_charged_region() skips the
target and regions before the point.  The target that was assigned to
charge_target_from could be dynamically removed from the context by the
runtime parameters update (aka commit) feature.  In this case,
damos_skip_charged_region() cannot find if the point is passed or not,
so the scheme is effectively disabled.

Similarly, the user could also remove all the regions of the target
using the runtime parameters update feature.  It would be uncommon to do
that, but it is a supported feature.  Because the skip pointer detection
logic (damos_skip_charged_region()) works for each region of targets,
this result in the logic is entirely skipped and the scheme is
effectively disabled again.

The user impact is that the DAMOS scheme could suddenly stop working
under certain uses of the runtime parameters update feature.  It could
surprise users. No crash or leak happens though.  Users could also
simply work around by re-installing the scheme.

Catch the corner cases in damos_adjust_quota() and reset the pointers.

Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Cc: <stable@vger.kernel.org> # 5.19.x
Closes: https://sashiko.dev/#/bug/linux-cd0c55fc-0cc8-45d8-9637-3334811c49b8
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC
- RFC: https://lore.kernel.org/20261019143713.98610-1-sj@kernel.org
- Drop RFC tag.

 mm/damon/core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 479169dc9ac75..eb1fcdabc0075 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3383,6 +3383,26 @@ static void damos_trace_esz(struct damon_ctx *c, struct damos *s,
 	trace_damos_esz(cidx, sidx, quota->esz);
 }
 
+static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
+		struct damos *s)
+{
+	struct damos_quota *quota;
+	struct damon_target *t;
+
+	quota = &s->quota;
+	if (!quota->charge_target_from)
+		return;
+	damon_for_each_target(t, c) {
+		if (t == quota->charge_target_from) {
+			if (damon_nr_regions(t) > 0)
+				return;
+			break;
+		}
+	}
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+}
+
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
@@ -3418,6 +3438,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 			damos_trace_esz(c, s, quota);
 	}
 
+	damos_fix_stale_charge_pointers(c, s);
+
 	if (damos_quota_is_full(quota, c->min_region_sz))
 		return;
 	if (!c->ops.get_scheme_score)

base-commit: e558ba2a16a47baf6b8e76bb11e92eb92a491e3a
-- 
2.47.3

