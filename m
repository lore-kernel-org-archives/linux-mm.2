Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2928606D830
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gfNPdoBK
Received: by kanga.kvack.org (Postfix)
	id 0C8A66B05B6; Sun,  8 Nov 2026 15:28:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07F7D6B05B7; Sun,  8 Nov 2026 15:28:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82636B05B8; Sun,  8 Nov 2026 15:28:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B78606B05B6
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:28:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39124A80ED
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:28:10 +0000 (UTC)
X-FDA: 85413088740.08.59D9A51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A2C29180002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:28:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gfNPdoBK;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794169688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5j7HhXnzELbkFkJqEZQNTDWxIhKaeKvJLsv/O41RlA=;
	b=AeHtivv+UszTqADQ2FUdu8tyFkETec5SntSuKm4ekQ1T8XKfQ/yuXw39dbypoyiEIAyAoe
	tcwJ0ZV9ncGz/ff4DvM48m9UIxa+4XSiUJvDEJxYclEy5y6mDr0sZe5L8LCWy/LvuhbLoT
	EdDYN3/dsnU3eyMuZXrV+wfw3MKQt+Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794169688;
	b=42axdGvdeSZksnNzOuys5ZVUqXgwLpJ82Uyio20LfvwfwOebxaRidAAndaR4uYv5YJUxwI
	p1WkYtory3fd4FOxDV8L7aEmtb6EKCUXCqpo52GcOytjUHHiwuit14gbf2BbLUUJCtvjVw
	q+VQAw01wndRTFW4kowtq5OWwMvBa2M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gfNPdoBK;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F4AF61DD7;
	Sun,  8 Nov 2026 20:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F7B1F008BD;
	Sun,  8 Nov 2026 20:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794169688;
	bh=Z5j7HhXnzELbkFkJqEZQNTDWxIhKaeKvJLsv/O41RlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfNPdoBKXcAtf6hRjx3oBKNvxuctMSQpp/iU/H5+S3lFaJwT4pILePYk9ynCAGLLH
	 ZQJ8bqirTCcBOaXloqpNaEz2VKMDfqtY8wq4tMkfj7Ehg8JKLyIxP6QwEiN/8RBgm3
	 zXrTuKZvl5Vrr23sVgTtroZLOxmzLMKXtdCYkWpY2T7PclwpuiIUqThyvEPj8VvwKm
	 DKqLyBO6KsoAsvY50IdhNuQicPCA+ngvurlEjB2UN3IXpMRho/hJneE4TnKedvnJhC
	 ehL1nyF63OVVy5QiPeDpZl6kbiEl0Xs2vCWKJueP591ZB0wWAHb9+2Eqsz54sXK6pX
	 7YEr5HJQOZm6w==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.1.y 2/2] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Sun,  8 Nov 2026 12:27:58 -0800
Message-ID: <20261108202759.117377-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108202759.117377-1-sj@kernel.org>
References: <20261108202759.117377-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: zq9u36js4o7xp4uqdpj6jbztamze8q9d
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A2C29180002
X-Rspam-User: 
X-HE-Tag: 1794169688-17757
X-HE-Meta: U2FsdGVkX1/+ct//bon8nPqilCQpQMr/FcJWm44KfzeCbRiCTLEghNlORpCBANqqOZf/r+TgN5/uTeNW6zX9lRaOBWzzpuTQx+MqhdJtLmIBuOlk8sHB6ABKLdfjfBCfzZv4AxSpWTygfa3rlkX1NxGMU5h/EAqbqkPZviNJ365bowgb7STB0wSjFJr6YldazY51puR1WyRQ8A2W8aYevkzjKfqXXkIPZZVkXHNLRMq8pjlXBVAiyvWv+OfZZy03gxK+9aP/OjDwOulmIXtqtuPj2MzetMu9XVm76IwNJfD5poQSGcACiVTPHOD9cMbN44R2+uWWOB5KzAw6mRG0wlwOiNkUQNewq+HjnSUfEadu+P4uSejLuFZIlAhA3I4UZOpe2fbCj0lwNAgBoZQ/HYtNvUchBQ1FpDMIQDsPTSGYHsaWUyDLiSEbTgF0eqslkSOeS0lu1AqckFAMyK2uKbmi3yODKK/dcZGt5lhXUuOwNgR+Z4J59/8rXF6wh+FuHbTPVfwhqfa1iZC6VEb2McK3+DNhcs15j0CfrGChY/tkYFwSFDwI5al/AlXdNyQux6aVM0W/Ew8Cry+DlydTss7Ag6DsY/yhrNWWjcnq3ze0xliwlrUM/UQWQM1GPakcmXBcUu3qD2l8OtY7+/eijeWjng37BOC+rwiFsic7ggprhVjMIqJvq1ADzUsAnjC/iXrDPMYmLUyrbUh7zN102s3xnNyCA0wdq9tSEJ8aYdf2KCLD6DXi+hAeTXe1192nXZ/ET6I54Q3+s2iZO4/Dae6mdOct+24HN7K8oKpaWQTMOca9fnVEWyTlkHkyal53ylxWnwhnmFKlR86pooogJLjYmdw//CZof7shRVTE7EeDyzHH1dGkdy6+tZ12e1IpQGdFjARVRPFBEWmJLhzQLfMk5spI7A5jtDwShs/5QYqW00xMTtJb8CUaBarXs6Cx1hqwZUgZCK26L1X+Xg+
 WGeAIZrq
 iv4nsLGxoDpYnDZfUBtICum+nyPnK7a62jsVPEwgHjOGFhqItPzve3miSQAD9qToja83wGMmDOBDS/emAAa0Lihu+D5VxcRH0BS4lIwUpveTEHLIzAQ4aE0PtkHVG0yXNz7+oVM9TFOQz4nbak7Ey4mwRtw+BG9IvYQfO+Ny9oZnDoTR9/aRGdAUbHPPjy7UjJcOrG19f/nelZpEkZx//5mHX6nZt+Ph1ddP7FT3NrDQqf2j2TZ3KiU99EGNWOLZrxOm5o6Kh9vDuQLvUFr4W0dxIPbDB2VQVRAAzTqi0XSI/h3nhz33mK1aKctjL3o/+2Jq+HzPTCxIm6onomfKBrzn1ikCJb+7Zi7xSPvM+5NyfmdijKa8/MI7dSe7L27OAK/aKupu0kGVBHN4=
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

Link: https://lore.kernel.org/20261020023958.108276-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-cd0c55fc-0cc8-45d8-9637-3334811c49b8
Cc: <stable@vger.kernel.org> # 5.19.x
(cherry picked from commit 5695abc4e742b947f586bfb6a080a80ad9957e5d)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9206737d05ae7..01f93146b92fe 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -860,6 +860,26 @@ static void damos_set_effective_quota(struct damos_quota *quota)
 	quota->esz = esz;
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
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
@@ -890,6 +910,8 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 			damos_set_effective_quota(quota);
 		}
 
+		damos_fix_stale_charge_pointers(c, s);
+
 		if (!c->ops.get_scheme_score)
 			continue;
 
-- 
2.47.3

