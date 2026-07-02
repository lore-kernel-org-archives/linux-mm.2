Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E16AC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520C66B019B; Thu,  2 Jul 2026 21:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0E66B019E; Thu,  2 Jul 2026 21:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40DBF6B01AB; Thu,  2 Jul 2026 21:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8E36B019B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:23:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE76940196
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:04:06 +0000 (UTC)
X-FDA: 84944459292.05.D96178D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 19EC71C0002
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:04:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HKOYsxPg;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783011845;
	b=SGLxUAR0cdLrvmVuhxW3RUN7Bf6hUoU4ZglkZXFRUW0urmUTk3lZ1yX02WuNmpH49TuwPD
	7c+fw5A35+UQq/hlh9oGLD8Ihwo8NrG5rifkyTAsWNPgwEevNDFseS+v6CV1eZn0xwpf+V
	IbK3H8MNfh96o9Ifm2cfQd6Z3Vojs+A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783011845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YmemtDDe1o1PgFyP6WGOt3q7FxPO3fkO/4XZQ1A7KyE=;
	b=KErcE3Sd+hrAXfYAusDOMOV5pMg507UQ6zE6I2QlJjscWi9pjz20U97a3Amf76Hks2+ePe
	4C9cnC0oJxCs+m1x7JLWZKMp5qaxNYxgMmRVYpalfZPGMhyv1wmU5jC9NrL6FuMc3Jxdb3
	RtTLtilthjHqXXzuJnDo4qhaBbWEWNc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HKOYsxPg;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87FE3601CA;
	Thu,  2 Jul 2026 17:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8261C1F000E9;
	Thu,  2 Jul 2026 17:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783011844;
	bh=YmemtDDe1o1PgFyP6WGOt3q7FxPO3fkO/4XZQ1A7KyE=;
	h=From:To:Cc:Subject:Date;
	b=HKOYsxPgiBSzSeDjVvQJzVpD1yrzVzFbOIX9SSHhfjxd8kVvbUuq9rxsO51jCZmiQ
	 1mi8eESw9sa0ASlgWaPTQPsGSoYsdsx5vnsciqTN6kCeh0ZOp1IkjJa+HyLJnuPS5z
	 obbFbJwJ/+l1ujMa2zEAUjbEwIoqmdFbrjaqHKWLrdb1xewKnqLXhr3zEYQYGclbL9
	 eIy4gvLHg5airwn+eIrh4rel9plg4b6zEZ+GMrkp1EcIJBmDoJz4gyhaWDWY5oVwtw
	 WfxZOYCYq0+HduasUolc8Dxbj+E3J6/teuBycot1XLo7k9yIWW8WwEhkHfpq8UJaeq
	 ggrVvicOaXk5w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1] mm/damon/core: disallow overlapping input ranges for damon_set_regions()
Date: Thu,  2 Jul 2026 10:03:23 -0700
Message-ID: <20260702170326.87255-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19EC71C0002
X-Stat-Signature: tegsce14capduabf7twap9wmnyue61dw
X-Rspam-User: 
X-HE-Tag: 1783011844-843654
X-HE-Meta: U2FsdGVkX1/BmDs4cWa5oAvmIljZvDOICXh2SxLf2dZNJsFc6tmpw4VsOse4dlS70GKNS9aVU8SH9MjXWyoqLXkkviugAFjFKfA44ZoU4RnINAw9f+wVtz65n7mzorzCBDmHC3YKmrbqzKM53jFVaplbLLPhTfkmniDEEIHClZtpsKjINlurSLYlsiwcE4gd+8PpvH6/HUupt+AnwzGitPGFntW4ylx0NyAghdWORmQKCqHxNdSrJ58UIspNxWSICgP3wOuozJ8nMtBNYrDwVdFWRtB46SppHBU5cy57hSrDxTWR6OS7zBeB/xrShg8D6C6HxAS1Vi/M0Ys/S39sy5EU5CN0cj/7Qx123zp9DQSvzJ52idN1wjfbAkOS7WUZruu6mZNDIAtvAKiDxo+Ks8D2TqkvPAnVe+lff+adUi4x0shN3k9wo/8TYaFcZjd8xYvrpS8n2ckSMyTDUYEwAF/s9wWaMzdmovwXBPy7FNNo4tQxOyQ7gBFk/r42QxzipT42sRJMb6CbfQFXCVdNzL68Sl6ESvWq+EBaB4XrMGvIIyYkgMslQBwOs9uqOTtyU62ROUcdtinTHQv5dL+5JcAvER/YiUmZKwUaN8mGCj1hEbuaQm4knqCVCinNjjhYhFxCsjOe/ddPw6HBIjlwWo5lD8JI6Y3/leDJftc4x+ryRi0PAZySAyJzJQe0/qgy0p37Qks26v8ppudqKP5xkuN6gQG5IHUE+K+j1y5QL6eNULHabmHeSA3DE+YbCXapPJ5we/liQHai0ryKw6s09WgkCI/QWPlLtP00z35TgRnm9wgulD5vg59KKYHjsx0dHLaUM1fZl6lw8QwpOJqwVxrdHc1/bXEcXgTEKEp6YMIMyhZNpwJ8WdX8pIkad8Zl2O0ydX9S+JWORUbDeoKH2y3/sG4EPK86z1h2U61or3g9CaU7znUzP1SKhQYdmgYM09bItHFAosKj2HnRXY1
 uhTnFD/c
 xJFmhqU/z2M9BwacJ4I7yjw9rxE7dw6UK6wEN4i38V2CNPeX/b2tzKl5seYmO4ubXxGTXNsMOHoFASfmzR1IDiY7dUpMTeAKsYtUtkpX2bQRzi2SaFKck0FKZ219xH79sKGCDcu1iNLRhSIuDRlhWGWvR9IdgzPYEc5RnWDxtZcVZrjxEfN7iWv6V+mawgXBNYXBxUMUA/JiCkwPeaCwf7HLjTBmKYpP6IZJiyrInagC6b3oRsYxyHkvy7wlM455uwdRvpGInGIAutyfQBybyGGj0X5KbIuEHa217f/o13wyEdfwjSvBD157qmQXYk/tPAZArtu98+sCACJUlT1pO3Oce4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_regions() assumes the input ranges are sorted by the address
and don't overlap each other.  Hence the assumption was initially to be
explicitly validated.  But commit 97d482f4592f ("mm/damon/sysfs: reuse
damon_set_regions() for regions setting") has mistakenly removed the
validation.

This can make DAMON behave in unexpected ways.  At the best, the
monitoring results snapshot will just look weird since there will be
overlapping regions.  DAMOS will also work weirdly, applying the same
action multiple times for overlapping regions, and make DAMOS quota
weird. More seriously, depending on the setup and regions updates
sequence, negative size regions can be made.  It will trigger
WARN_ONCE() if the kernel is built with CONFIG_DAMON_DEBUG_SANITY=y.
Depending on the monitoring results, the negative size region can
further trigger division by zero in damon_merge_two_regions().

Note that some of the consequences including the WARN_ONCE() and the
divide by zero depend on commits that were introduced after the root
cause commit 97d482f4592f ("mm/damon/sysfs: reuse damon_set_regions()
for regions setting").

Fix the problems by checking the assumption and returning an error if
the input ranges don't meet the assumption.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260630041806.151124-1-sj@kernel.org

Fixes: 97d482f4592f ("mm/damon/sysfs: reuse damon_set_regions() for regions setting")
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC v1
- RFC v1: https://lore.keernel.org/20260701034921.99179-1-sj@kernel.org
- Move consequences divergence note to body of the commit message.
- Rebase to the latest mm-new.

 mm/damon/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c6fc35be633b3..b2fc15a3804ff 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -418,12 +418,19 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 {
 	struct damon_region *r, *next;
 	unsigned int i;
+	unsigned long last_end;
 	int err;
 
 	for (i = 0; i < nr_ranges; i++) {
-		if (ALIGN_DOWN(ranges[i].start, min_region_sz) >=
-				ALIGN(ranges[i].end, min_region_sz))
+		unsigned long start, end;
+
+		start = ALIGN_DOWN(ranges[i].start, min_region_sz);
+		end = ALIGN(ranges[i].end, min_region_sz);
+		if (start >= end)
+			return -EINVAL;
+		if (i > 0 && last_end > start)
 			return -EINVAL;
+		last_end = end;
 	}
 
 	/* Remove regions which are not in the new ranges */

base-commit: b62b6588a32f9aacd58e415ae883bdeb67594f5e
-- 
2.47.3

