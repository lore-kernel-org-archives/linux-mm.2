Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA1E7CAC587
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 01:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2541B8E000A; Sun, 14 Sep 2025 21:58:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205038E0001; Sun, 14 Sep 2025 21:58:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07EBB8E000A; Sun, 14 Sep 2025 21:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D74B88E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 21:58:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D44713AC56
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:58:15 +0000 (UTC)
X-FDA: 83889824550.22.B28B2B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1F2A5160002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:58:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DvG8ia4q;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757901494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIaS1XYBqGgcMgz3YvX9sFTiJ5xxVeyVMlnnDJ4d+lg=;
	b=e58synbqurXmylVWX00wiuZEiXGyLKCf2DbvmMuSDb/xDk+k+2Ecbfo5b0uZs0/DGKRhM2
	WDsoqiXpfLKBexM7qUPPQ9W+9ftb5eFolPdEgfr88izwVBazimv3AooZDmWG9LzzpqBWEA
	U3hu3HSsRgafhtJpnjXthJsEFpRM0C8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DvG8ia4q;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757901494; a=rsa-sha256;
	cv=none;
	b=EJWaUeqNclH6g+JCJDs0iPCin7+R3FxzFuaYT7Fr0F0dB+S9LywC3DA0sFMNBrJxCubg7C
	wKUcvM6oXLbALA7CegWGxjTS403T7Yc07AsGuMQzdNYRxXLGCo91fKh4l+ddGZNX3gk6uG
	O+BqtJ1125DPKPKP8MtDkvVza6auaVQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 88279601D2;
	Mon, 15 Sep 2025 01:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C31CC4CEF0;
	Mon, 15 Sep 2025 01:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757901493;
	bh=LPyFMKB43zMlbHRsGJfXl3nVz2GmOh2C7PouLJ938HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvG8ia4qP38O3NEYaj64HpSn7dn2Ni8E73J+n/o/qiKCt9lL2wdZ+8AeAegbzg4gW
	 aR7iX7LuMoaliorim7TJQ42HGMNIJ6cPJp3hfa5IBm5HBYXqRxR7DKqmbwOALUnrJt
	 A6JP1Fgen11hlDQhrUlLmbVcKU1QP2azOug0XQUf5NmMeegrjy+5DXCIqFuc2AfbuV
	 zWxau/gxB1FW9xmbOU+xmQkkf6HWLv59i4K0Iky1VVflnkJm58lkyCUMQpBNFNkLKQ
	 qXIkN17/to6ZB2MUz8VXNlwIgQQPb+K2Cno1KtZx5r1RmPWggl9i7GmiHUzmymcTN8
	 Jz70PbzrgdzTg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/6] mm/damon/core: reset age if nr_accesses changes between non-zero and zero
Date: Sun, 14 Sep 2025 18:58:02 -0700
Message-Id: <20250915015807.101505-2-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915015807.101505-1-sj@kernel.org>
References: <20250915015807.101505-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1F2A5160002
X-Rspamd-Server: rspam05
X-Stat-Signature: qmtchgakdu5h1k5xqci3wswe9qr6wxx6
X-Rspam-User: 
X-HE-Tag: 1757901493-163454
X-HE-Meta: U2FsdGVkX18FrIraeADk+0GpScnYp9icUwIu3zMiTy+h/LT0ExNOR0looswQhFoNaZEmj2ODVTf9T9xj1KSZa3uwqM5sete7WEPYeqk9kqOunvQ/XsVQOLOdJNyk0kzFmdpt9Bv8st4Xcb9fBqgDAMTQPnLZpOAW+UBTVUkqUHvNDofTiO8XW5rrlLxN2qBfFKsBEW5sRFSrAyCfcFU+AYYVVjJQQHpWXXyXZkFFTLdgmWRaBhmkqUZUlNtLepzzX7rMtQDurhNo5HoFEE2dERTG4iDsRGuC0LkSps7oOgOrhYpMZpz/UPW7EBEOfLyCkrBLHgilt0PGYU6wJa/DNUk/HxF3XBXOem3aqfa1Iwg3grJBsrlF7mmVe2lq96H4V4UXRR7ZnCIo+hT2b++rX0b4BdoE6LUH+OPJvvSmKAeuF+z8QeNz/nTd4quIiGoVSWiBvpZ4XE3WNqQNzSAUQ09QegesdmrRX5N718uwqlPlqA/1kwx7WvO9o3gR7MP2mqqbiCpIGt0lAUqYbf/Ag3DKJZlWs8Mp6I/hYHOZ1HTMzIlNrKKGuKVIi6NqHJWCdQMkbYQ5IqElk95E8Gk1ZOJESuGpstBzu9ZtTgCdyFOidvDSByRE8cgAfVM8llw3uP0MyHBpLgFFX40LZzO/jch99Yf1xx5oGAGElPVl7mgAelkw1WUKqMcZ39MtjEZrvsf2ZwYfsQ5+qEEYvmd+iyZ274dGzVsZvsvMSFSlpBIyxKZNCfTT2aCilyFRgggHkh4rr8JlpSxt1GzvBArq0cLgQvqWAkAFxOPzq2w0H79INBPrtB/tNnGJJdDVIGE78ptZdycxq84Ibigz71yBBWdkhauG9z8iysNX996ZeifvAvvlA7dvrpNGqR6wRJHB2eFuGBGvZhGySWOEhYCn1vNXlcZyzbfh7B4XR6YLLk3PAtoHaus1bGMuRv611NiAQtKQPwd6aJVWMwdsLcM
 SxJnMq3a
 Yb+ohiWzCriOaCQW0bZsR4kl6wtAk4QUwxh6tXWaQWj1b7/7atN2YEq9hXGcXt0klpgGaq5ca901KlF41Qk0tBElce5dmP4q2YPqeyb1kr90Z0Z2vW2H01tS9/mygHxUoMItrGIRhjd7B7HWeciI7IZ9NNqaS1BTYI50GZcViz5GPuPBD3vmPQrFu8tQJ5jhTN4hS6eUIVW70gRCLjAjYfDoyYb/6Xlmz5I1pXlcNcMLK4bvUs67DAQsGaq1oY2j3Xd18usi8hmTGQ9+mozygVufwyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON resets the age of a region if its nr_accesses value has
significantly changed. Specifically, the threshold is calculated as 20%
of largest nr_accesses of the current snapshot.  This means that regions
changing the nr_accesses from zero to small non-zero value or from a
small non-zero value to zero will keep the age.  Since many users treat
zero nr_accesses regions special, this can be confusing.  Kernel code
including DAMOS' regions priority calculation and DAMON_STAT's idle time
calculation also treat zero nr_accesses regions special.  Make it
unconfusing by resetting the age when the nr_accesses changes between
zero and a non-zero value.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index be5942435d78..996647caca02 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2261,6 +2261,9 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 	damon_for_each_region_safe(r, next, t) {
 		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
+		else if ((!r->nr_accesses && r->last_nr_accesses) ||
+				(r->nr_accesses && !r->last_nr_accesses))
+			r->age = 0;
 		else
 			r->age++;
 
-- 
2.39.5

