Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1FD560A6F7C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j/ZYHIQJ
Received: by kanga.kvack.org (Postfix)
	id C0B556B05B0; Mon, 16 Nov 2026 14:10:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B930D6B05B1; Mon, 16 Nov 2026 14:10:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8CB6B05B2; Mon, 16 Nov 2026 14:10:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 833406B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:10:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06CFAA01F0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:10:25 +0000 (UTC)
X-FDA: 85441923210.03.4E9A70D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id F121940008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:10:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/ZYHIQJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794856223;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JBagyXxECIQ4yhDUegePc/CqbsWLNLNpVx2YFp7Whg=;
	b=KFYH/lJ7N1uYl402cpD5rbDFCMMrQshiy0Jai9Qh+tlxD6+fM4S1boWpNrFqxBdw8YeBBb
	acOSjNMEOI4Fu75hIUBv6sQRdbLdLtObg9yp+AdgNYtdmPGdmoQj1XZlD+dVpFNXshzqQ8
	Z9bkeV5kGnC4XYjZSzhX7QCLOfCz8Gs=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/ZYHIQJ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794856223;
	b=dWKWOdkTIKW4f3T6vn11E7Ja1tg2e8wHNmVnmGyTCJuU4gntmR+9Y+UV4y+AL9Epj+TDZN
	daowsJ+9YJOZAEEwliaxLJT4y2WikHZP9CqguEbvCN6moH+T68dJSubcWvef+4+gAXoO8l
	olctVaPOMkh3qKPGyZIoqniHO5rDAUU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 70D0262F47;
	Mon, 16 Nov 2026 19:10:22 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794856222;
	b=04+VEBHZ2mQ2DcIgAH/Szfnk+D/fK9E8Jt2+iDnZfFsnzy3OC5pdBkYRCa0KuOgflajk
	 fRxYBihRsCEutNRtJCDK/0hmuU0xR3gfkU8KsnbTMWz0n40R1yX++wAELUUD9yCt70Bl5
	 YBsMhTksBwrnou3kiOtPrSyNOg5rfvSK9a5MDjUqIBnlCk2i9tMF2yU87g6Ic2r4TIep/
	 yKPTtw0YjxnWww+nbtV6+DTQrdgAdlZ1zr4ec9yyQpFXchBaLdWAGB6EU8u3fxEc3XCOt
	 PA6xzEWYgKUIGoIuMzP8vhdWm8eP2jwI2KxNIi9gLktY4cgHbhH9w8Gny4krPvbJfhQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794856222;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1JBagyXxECIQ4yhDUegePc/CqbsWLNLNpVx2YFp7Whg=;
	b=aMVLKAl4Vw1ZflzR+vdcSsCzgaAhb3Q9DhD2tO7fiDbozCNmtRjuDktzSlTl8NmVoA+3
	 TmhRzV46oL3S6/4bS+XI7XEXrfSA4nwtLpICQ1YG4cXyEx+jWLa65u6MjAUBZ08RmXhMZ
	 eIkxysZpCF5XWkK5Zp+lyB1zh6Njs4IocCKt61ISCUekWO/cNODefngjjdNO7yrG1utjF
	 4f7hmhzIhiFySV2o9v8VkDyet22Kjpo78gi410uqRm67qzCQcH5jIYy7uDLNREFk9przb
	 ET16G9LnggBcOZG1f9Cwvag4yMHu0V1DrUC2ARH8b9IrOUHU1ZWp3jA8Xp3DQ7lgSNQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DB1771F000C6;
	Mon, 16 Nov 2026 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794856222;
	bh=1JBagyXxECIQ4yhDUegePc/CqbsWLNLNpVx2YFp7Whg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=j/ZYHIQJpplTAx6rKU57hXc6CDboNrxyxYGnUAnX8E3eWaVBZfdIPS6kHHL2qhx7y
	 o2riqRtiWKsNRik6lJcpqZs0zvniAUNxoQgRVzx3wllpg+KnZP3oTC/u6JBtxNG2PJ
	 JtS+15kNDmYAe2MnTCgiMEXANS4a0cUFCkQax7GOC7HrWj3NlrBkTKdI5dP3JMb8aK
	 FIMw0f+8Hjwz0Z03urGbvsgufwOnQWYV+IfIGU8zPYgnKoM8pXj+FYwqncGBPiJRzG
	 0kg8kyB/D43/GzDng6EZDS+enJe0+H7eJWP+Eg/1zdFUo7YOOSddVD5+Nh5856M+b8
	 VWKKHWZRMOX9w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 52DA34A582;
	Mon, 16 Nov 2026 19:10:20 +0000 (UTC)
From: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Date: Mon, 16 Nov 2026 19:10:04 +0000
Subject: [PATCH 1/6] mm/damon/core: introduce sz_ops_filter_passed_last
 stat
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261116-damon-sz-ops-b4-v1-1-1cffe7227e6d@uber.com>
References: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
In-Reply-To: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 Mattathias Pinchover <mattathias.pinchover@uber.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794856219; l=3175;
 i=mattathias.pinchover@uber.com; s=20261113; h=from:subject:message-id;
 bh=+LoR4vjeWULTWq1HaaBRt0DI5bIP4EpokrffEX6bIPk=;
 b=LTou6WHMxnLQienM9yJ0jomHPbYxEh+IIwzgRJywMRzgdUp/Z50xpB4I7QiEoZhPibPGUxjZW
 4n90urIrykDDGR9PBUYhJ6jgH1FvfwjvLCsfiw5Gn6rhgTj4JjBUkUo
X-Developer-Key: i=mattathias.pinchover@uber.com; a=ed25519;
 pk=6Bh6OEwWiU6dpON0CVcoipq8fXtEgvhsM1Tmm9CTmtY=
X-Endpoint-Received: by B4 Relay for mattathias.pinchover@uber.com/20261113
 with auth_id=1515
X-Original-From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reply-To: mattathias.pinchover@uber.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F121940008
X-Rspam-User: 
X-Stat-Signature: cmtma8u3b8miogyettc8kuum76sx1yss
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794856222-931568
X-HE-Meta: U2FsdGVkX19Ndf2lETik+B9rEsjbT4ysPvTlBwqf2puK/lRwO3GY063gM18/T/BJudi8rnlAch0h6ulrVzZTre92hWO7w95eg9UMXu+FTgyEPXXTMLMRSINq7ynhfobCm3835RFJFiNE9WR80MMdkKq60vxM7belQdWu8dxAnzUMTWD24uCmWF5K43ApeVLb8cUGf/pXBJGeDciFKBbA9myK3aMP8PFY5D5AT1Hs6uOUm6bjEs0nAXsS5XquERJPg1Me8NIzCQs/t9d7I5MYRR3xdg7iYBdu56N66vjNPsJYh6n3E3bQzY0Qha97QiSeF2SBPAt0qeJuD1w1aMbJ/H+yreKxcDsjJVtG9kNEiXITJCDqqv2BviG6GQfnHaihDLeDJjz+tJ2ETbMCblGA1JiDdWBpMDDnniV9ZOGGZl0T8Rvj8Fhy0BIaqqGN9LVNwf6lpTXqgwtfEQmMcJsxyY3Wwe5CMSNMW5CwJ7BTYXnpe5w9x6r/er9fdlMsMJnqCrUW8ByFDh9JOVlA8ZWiO3TVvhDeVsJI3Wtjs5PmeQR2mK3OWvgsyPgn4Sj2rw2YS03c5zM/EPmiUpv2OV8pvcbOcyap7EUofTX4lxzEUGRv1N+zl/hvjVNKDBrdsXszkJslScrFbjof5fPusc3PANZiS8mfCIUDB8c9zs87WLW9lXxCLHatyB79qMO4iLoK5wtWoetWw2cGCbc45yLz+t7ZdweYPMUD6jHz01St/CsBrn623pVr4TYc0bgMq4jG6FGvRTtTxFnckylxPBStfzsahD0nngBYwZ/Ytz1Z6xg30i5STSoroafkZEutJvM78bYzpCmarWrvQ2jK7mOuD/amNWnWX6ftZPm1Vg0Du7gS4jGY9/be7o5Re1P/oA5yewAX+Tcm/gcC/+RNYeBR0dv1wjN5uxyPBwXzmxMVEbHXnUCVOY+X8JIsD5peGgNh8NvaU5xS9ChBdI28qj5
 c8hB/5Q9
 7NeqsQfihd6LPKmcCCH5cETkQ3aGFaAeaK84wZreiyk3RLEjw7jvp10VVqZfroFG99CwahuO2l2IVf/FGWaZhDvTxXWcbFWqNVinTRXAmlx9Q4lz0C3zrtD01rmmpcAmiEED4dsmp352TWjy47SEXkgrps0NHdEItnx6d9XnPGmT00hALeGw8YtHbcT6o0QpwvChodeBpozA04Kqllnd/bMX/0jz7WRFulLlQ8I7VRllEDkzteHpiRDpA4SZvFyOE/3tdmVIIgIG9+nB5Q1dO2rcDHrFp6kMGYL36b/rCB0okhO7f/9SL4P2LxZjwL4Dzk+lhW7FW55u7IriByqSHDAEjpErVWMqje76A0o98m+/KHsaHhqNhxFBJJF0vLO+wuv520SN4zPlWtQPLP9PDWWMrDDb2Efu3Za1axNsqQbL82RPhD2xhmJpDQg3ltLEQd8JxcEtBvDJANI9dyw11fwb5pJszYLE9Vmspx2cHEsNuAIxbBv/i4kqlKpgzxHKj6c8nxH23jE87RGA2JoxSXkQtfzxaP770KipztNAk6fLEBLPRfnPC6iG9jXSi2APSOFQn83h+C4FzIGRU95oma6oFJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

DAMOS stat sz_ops_filter_passed shows the total bytes that passed
operations layer-handled DAMOS filters, accumulated from the beginning of
the scheme's execution.  Users who want the amount for only the latest
apply interval, e.g., the size of a workload's anonymous memory that is
cold as of now, need to keep the previous values in user space and
compute the difference with the help of nr_snapshots.  Because
nr_snapshots is increased once per target per apply interval, the
computation is complicated and error-prone, especially for contexts
having multiple targets.

Introduce a new DAMOS stat, sz_ops_filter_passed_last.  It is
updated at the end of each apply interval of the scheme with the amount
of sz_ops_filter_passed increase in the interval.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
---
 include/linux/damon.h | 6 ++++++
 mm/damon/core.c       | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 06bd92981af2..3aff5c525132 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -351,6 +351,9 @@ struct damos_watermarks {
  * @sz_applied:	Total size of regions that the scheme is applied.
  * @sz_ops_filter_passed:
  *		Total bytes that passed ops layer-handled DAMOS filters.
+ * @sz_ops_filter_passed_last:
+ *		Bytes that passed ops layer-handled DAMOS filters in the last
+ *		apply interval.
  * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
  * @nr_snapshots:
  *		Total number of DAMON snapshots that the scheme is completely
@@ -379,6 +382,7 @@ struct damos_stat {
 	unsigned long nr_applied;
 	unsigned long sz_applied;
 	unsigned long sz_ops_filter_passed;
+	unsigned long sz_ops_filter_passed_last;
 	unsigned long qt_exceeds;
 	unsigned long nr_snapshots;
 };
@@ -578,6 +582,8 @@ struct damos {
 	 * @action
 	 */
 	unsigned long next_apply_sis;
+	/* @stat.sz_ops_filter_passed at the start of the current apply interval */
+	unsigned long sz_ops_filter_passed_at_start;
 	/* informs if ongoing DAMOS walk for this scheme is finished */
 	bool walk_completed;
 	/*
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0a056949604f..6af3309691d4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -769,6 +769,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	 * or damon_attrs are updated.
 	 */
 	scheme->next_apply_sis = 0;
+	scheme->sz_ops_filter_passed_at_start = 0;
 	scheme->walk_completed = false;
 	INIT_LIST_HEAD(&scheme->core_filters);
 	INIT_LIST_HEAD(&scheme->ops_filters);
@@ -3533,6 +3534,10 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 		damos_walk_complete(c, s);
+		s->stat.sz_ops_filter_passed_last =
+			s->stat.sz_ops_filter_passed -
+			s->sz_ops_filter_passed_at_start;
+		s->sz_ops_filter_passed_at_start = s->stat.sz_ops_filter_passed;
 		damos_set_next_apply_sis(s, c);
 		s->last_applied = NULL;
 		damos_trace_stat(c, s);

-- 
2.54.0-uber3



