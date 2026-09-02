Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 423C7C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5516B0096; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C75E66B0098; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6886B0099; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88B606B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:47:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09767120741
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:58 +0000 (UTC)
X-FDA: 85167741036.27.9C994A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7DB3D14000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OaOrtRB3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KapXeO7OndJodgXvsAPTUdwLTA5ybEOS8WtNM8GGre0=;
	b=fc0oAVL5fn5ST3zXPB6th9mxXfUTz1l/ui52tL+8Cv2pRYZWnmW5mydGM+qPB/32wtPVsT
	0ClZzGe0c3JGpfB+FZB57aT0MAbrQ9guaBdvKQl2qykEhJ7i1VVvO9yyrTnjkQnDjCR3xL
	QYwdrUR6hVGNFdSCcIHD70UeGxvSrG4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OaOrtRB3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328076;
	b=vQf5i2jpAUd5+OCwYj2zVWGDB5r63uxhYtetDPJvVWOH95PWfdCk8D4aRmHNmKXgG45EP9
	SYa/JmqgyUhZeicrFr57FJjxK7gdV0Clr/9RnfuLVE+Wy+7gmD5zQW9CpdDjlxNW6AaQyE
	YpqXtd/U3w+7VVpmeoK9ybk9IJ9d5kc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22E9060233;
	Wed,  2 Sep 2026 05:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29401F00A3E;
	Wed,  2 Sep 2026 05:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328075;
	bh=KapXeO7OndJodgXvsAPTUdwLTA5ybEOS8WtNM8GGre0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OaOrtRB31+vdvxxaQTsVcdtksSf8AUVnGY2FQ1ubJilAVPbuppVruEKp/YmmPB1Lw
	 +oEr8eQ/dJtc7TCCvA3rXvhnc/cWsS8UEsPNwFlQ6l/qoCIWnZQ3ZmJl0gG3dMglqN
	 BfocpI59IRFjL4DyCB4CrWqtrDWYNWhDqQgGwXorFOKLIUHgvyj9Kv60UHD9emSOzE
	 4gjQkBncrHHdsT/V1ImAcw2RlxWVCP4SOLfiJOgFqDxkHnmKpGK3N8a3eyrGvgg4DR
	 ZvuTyHdMvOblzcqAKbIn5wH9bZT/B9T2Q8LHB4YVnhtuyzv0iZPlE9YYIt/ezsFVSh
	 pDf2isDehJetw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/12] mm/damon/core: validate number of probes in valid_probe_params()
Date: Tue,  1 Sep 2026 22:47:37 -0700
Message-ID: <20260902054747.99370-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: <20260902054747.99370-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fzqn7zmy7ge45gsdaep5maaxut1n95k5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7DB3D14000B
X-Rspam-User: 
X-HE-Tag: 1788328076-424353
X-HE-Meta: U2FsdGVkX18317trwlflh018QMj0InLsKr2oGZI4GGfv8Po6y0HTmT0yBsChEL+MzS0dZ9ABh+AL6FSKDwxO2HiyHkCIEAx/pYZg2DTPFZiWwd/mWiUfZfDYus12qgS01Qp7+C/n0N8hkOyNrbvUlVPW9+X13S/7iQ9FsOJKiaSzCuKFgjc/tYoBLeeCZYEiOjkJ5Mg5GanktSTxHkj3mcdRYcOD/kymHkhCn4X1+3PlWcgf6G9yuzshafmuYYJBY+P/YSnxH2awSLxJmWWiEjQurmsLCVoumHTl+egSl3yFBMBIHcxo2Zd2WBT8xiA1YPLYd4citnyufVaiIrRE1H519IghKbyE3ULh6WGqM94qIkUkmbmymZcrg/mixzwJR7g/nZhukR/rTD/7i+27lwHC8fnubCepOieAKi5tkY9W8pEu9VEVNSYsQ9i45eZkXi8R5ClaJEdT5JUzmZ1OmWSI1yjdgofyFldP8vwk2wXq7KpIKi36EXMXZkyFlDjBGPquHum4Ba+2CCTmHx2n3R+Cl/6LIkoQsmG7hLQtl46Z7wBhKT6+11XrvJBTA6UuHmHsL2P5dPpN73d3UGItq5M8BAHAC94w2EsLZIlW5kRimntudATJk3Tta+KJgO3KM636lT9l4VtJhxajm+GWBxWH6MiVNqhueEI97GYqNtAmIheOiQDPIhAPhGzrfI1KV3wr3voT5u0bdwVTXZEso42bAVKfib9xfQ628XIeZqrbW8FWhqdGItPP0NNg6pya9Ks6d7zwunaDtu05KYoCp3IQvnRjqBnq/bmEioyn+2w6/lVunaBnRRLKOj4olHNBOYOcm44wlP1/TohQpA+o7aizAAFMQmxUE40gqJCv20W2I8f5eyfamS6dlU0BiknP7u08xn8kLu8noLepmkysUUmyvuaJqnluyORKNooTOLgy0Ys1/AYsiZbvDPAkdtJ0WFPHjcT2EP+CzwygOzY
 yc38bSgb
 wltLs4Wn1Ej0K/uJLNiZeaTayCUVkAHmwyDxcbB7p4f6XsolyblDz73nwZf2cV2muyig0n7Dfuy+1+T4IQpBfEA7yllvetoSZk9MyJbomqWVXSZlRqM7kpINIiLyfN5rrrwitU4oTfRrRmZbWw7g+1uy1fBeRhJaKHM/WZ/9K/qZlVTGbG/75lfjjJWfVqZswpp6amZVx8+1WGzNclt6XXhCxco4lJd1YPMD8dxJuNzMLsEFVGMt53ezRLvCmHpikoKjCbSfmmSqsRafUNnjEqmhj3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each DAMON context is allowed to have only up to DAMON_MAX_PROBES
probes.  The central place for validating DAMON probe parameters,
damon_valid_probe_params(), is not validating the upper limit, though.
Do the validation.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4d28eb033fc4a..c010f686d033e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1420,6 +1420,13 @@ static bool damon_valid_probe_params(struct damon_ctx *ctx)
 	unsigned char max_probe_hits;
 	struct damon_probe *probe;
 	unsigned int wsum, wsum_to_add;
+	int nr_probes;
+
+	nr_probes = 0;
+	damon_for_each_probe(probe, ctx)
+		nr_probes++;
+	if (nr_probes > DAMON_MAX_PROBES)
+		return false;
 
 	if (!damon_has_probe_weights(ctx))
 		return true;
-- 
2.47.3

