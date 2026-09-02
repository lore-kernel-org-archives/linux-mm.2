Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5742C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 05:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87D236B009D; Wed,  2 Sep 2026 01:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833B36B009E; Wed,  2 Sep 2026 01:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8866B009F; Wed,  2 Sep 2026 01:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4ABE76B009D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 01:48:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D271A160726
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:59 +0000 (UTC)
X-FDA: 85167741078.11.40EF31E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4CA75100002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:47:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EgyR80sS;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788328078;
	b=ZEvuvChePy+ZPIDh/laFbY7lbqs1RdyG75vMX8/3d2gPv02Ndus2605/7aSFDeqT+Keuq3
	rA3oG2omoemxyOLJsQHfwKK8TZxusbRcw8VDeQoV9NbGYntrvfSUUpZba/qShxoQlwK0vs
	e496SqZ6yRP1evW1dd2SaNAX8BsM/qU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EgyR80sS;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788328078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KnjoWKXYy9mV4JP4a4wfsis0KbFL9ZmPOgZcY5kWfCo=;
	b=4MsuyApalQiuhuf+B6cxk67bn/oPeYH9AA5qvDEauUaOeipfQdqOvS+Edkb0OxIU6Q95IY
	oHqGEe9Rt1Pw0qo0OIXHk3m3eZLTqK5k+xK9KukMMFTsDaqXZ28mb9K7EfAelYT1xHGowx
	rgkyv3JRxM1gPRyrq6wV5FfkSPubKzY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9968244464;
	Wed,  2 Sep 2026 05:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362531F000E9;
	Wed,  2 Sep 2026 05:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328077;
	bh=KnjoWKXYy9mV4JP4a4wfsis0KbFL9ZmPOgZcY5kWfCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EgyR80sSVGZeqAZxZ92XTLPu7/ygW+YWlw9SJ+T3xdyG+MrPAYVWAuYYwIacpddeN
	 ICh6gf/gejLtS8LofSIiOs75v5RelfALnKuSTdO+mg6SJaV32cPRkcd13FUyqBAxf/
	 Pv+s+G0edkJ9J5bb/2vAGl7ahKfGV0EtXZJYfZ4G9Pi66X+L5ufr7fg9IH4bLJmeaC
	 sLkfJlOzM2CyPwilF+7Gzmp1lMdmfcu8sMtW3BX8gr/EQhZBx/8AZJ0Of6E2kq+Osq
	 1m/H436xwi8JcRP2gFLyszGHhqFdrIfWXlT/+J2DxX5dO9+dfm/MAlrQLDS1D3wMOo
	 kaIsW99KfflpQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/12] mm/damon/tests/core-kunit: test overlapping ranges for set_regions()
Date: Tue,  1 Sep 2026 22:47:41 -0700
Message-ID: <20260902054747.99370-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902054747.99370-1-sj@kernel.org>
References: <20260902054747.99370-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4CA75100002
X-Stat-Signature: iehar6kncxmrsfg87acord8uod4twmks
X-HE-Tag: 1788328078-248961
X-HE-Meta: U2FsdGVkX19mEdpJKlSfSfRcO6fFCgFqRkmPZkeyXKMTQW3obvgtBmJzsu1F3lrFXxFQ82ZjW+QOlm+b5p0RpmOWq/LAlNJNfG7zRZio3YzIwUjAE/Cg/z1/uVuwAKOiQEahOSzJtr8x6h+BVfqUYYzImpfjG1MDk//siNSk9xEJfwx9gMuiU2prmoPlOEC/ZYM1QzW91pZfmMAop0Wfr7OxkK9HJye6YDt6WZXyTJaBp0jFHxrSC/J5bhUlKEXJzjBOUsYtsnsIZuZPVRsE7kW1MlJghUdLywdETPeZYEscGFScZfN8mAimHIT8D0Kv0VKMx62kKSOtrVJuGNyfJUa3P+UjPVmUj8BXHDmV4EUulGj53Wtp5rXDx9iVZ7lE/JvAOn0UVN1LGjebAROU4/K0EtnvXb9+dh4ANN9FF+fnNxvYkDzmERWwCnqvTJ0Q+EmeoC/f/qo9dbUS73iJga0E55uqbMIj4r5QbkXLB4Fl629XfYmFLBtNeSh8hdzeDuTcWyCSo1hU71EVe8tY7qa93kwzU+6JMHJVaY9JnuzeKfnQDqDKN7j/uIwE2/q2+ESnVWC4HwziF/TVOPXnhlnsuqgoOk3DxasdH3uMUUbyLORT2X7K4AMIG+BBlkXfJRO2jD4VbXYK9+L695/6Ay4GOzqKStdCLQYoNY+/Widaw/xc1vLi+4Pz/wJSTl01ZGSSXT//7HgabeFlAShQs6r5+VTnr6MovzEC1MIF9AFfZ+3gvbfbNIKhyr+GexBxxSPKjdlQSN/BcI/RRttetOShFlbc/kRr+QMn99FfLLtqab5sWTXwGLHsI/qmGcfp7xNtkZzPQ5VBoC37Q3KgFoQeO16KBCVFbYODFKbFThrHkOEFOoL81GlY5NY6oSaiBu6rdLgLpgbEjQZUuzbL6iSnI0RlVuyeL6zZIUO+2Ii9GEhmk55mUR0sCo/AcitWKjXRpZVT3Z3crkqTQxm
 v3raiRU/
 zZxV6a507/nbwGqlzUlvjjNWH0SrnKq9wL/PbunIgGBxlkornqfVdUlGrkfgLGXEwosmrxyFAnH+RFdEji/HZTCvNQTCrWzHR9AOwf2IsPvyxBwHbksNoZgGe4vMe6qhdJIWU+ghtoc5YE3JAoA6i0M/3bIvLatkm8lLkhZvbyWrprGrFZ1VTo/7KKa8IVDGvuaO9wlYI6/DgjYilHkmXYGvvqjIO6icrLoPSahJ1tqXskiduyUtW4sqw58vrWou81nimrf40cCqaFiiCvKTJqWFQ3BKB+422PX3/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 954157679ec3 ("mm/damon/core: disallow overlapping input ranges
for damon_set_regions()") disallowed passing overlapping input ranges to
damon_set_regions().  Add a kunit test case for the overlapping input.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 3cbbbcbfbef8f..a4164ac489a61 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -612,6 +612,17 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 42, .end = 21},
 			}, 1, 1,
 			(struct damon_addr_range[]){}, 0, -EINVAL);
+	/*
+	 * Regions resulting in same region after alignment should return
+	 * -EINVAL.
+	 */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 10, .end = 20},
+			{.start = 20, .end = 30},
+			}, 2, 4096,
+			(struct damon_addr_range[]){}, 0, -EINVAL);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
-- 
2.47.3

