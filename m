Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CFAAC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4468C6B0093; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0866B0095; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5706B0096; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E76436B0093
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:33:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58B01A061A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:02 +0000 (UTC)
X-FDA: 84963885804.10.7395465
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C0E75A0004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oL88cXuu;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783474380;
	b=jWgL8J6T6CK69ieIDDp2A84PmmypJGpYKLBP+lef7CzGo5H1ifRZapNjq0wRDm2ei/P1qJ
	a3OhxZCoBMFUOplgGaaTvtOVnB9yy1drq4Efvj1x5LPaUmkhjtQX3afrLuPDRaLdkodLAl
	A/ejiWF7cD4TC0oS/eLCLDKJCNaw0RQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oL88cXuu;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783474380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oA5QgRVwAQqXAsPa92ekv3Nt4l6hxznyCttmnCPVif0=;
	b=7vs11cOKxO4kaPq06n2zi/X5LyA/j3yRHcjAsXoLb9mdjMBWWnObaoWvEZxDtHYc51WeJQ
	MRHkMOelfiLGzQqB0XFaSYwY37+pPIxpL+djxfE9VTq6ujF1QNxTsrwl8mDBGqK07LtKQS
	QQEcGkYod2sytKNXbAXk23DAZompwI8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53AC060008;
	Wed,  8 Jul 2026 01:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61EC1F00A3D;
	Wed,  8 Jul 2026 01:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783474380;
	bh=oA5QgRVwAQqXAsPa92ekv3Nt4l6hxznyCttmnCPVif0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oL88cXuuN8395QUQrNiGFeS/FEhjboGc03PzRq3F8Ry62o72w9e6zoUHoVtcnd6do
	 OE798hXX20x+FHZaHbOoz6U+lzWzhRrLbQGsYZj/+wHM+hdesWMQgiMWDDVWLzrqWa
	 /2oU1gnFB872VGjGYubgjFoWaQMA6zVHdCL56NX74mpo32E+hF6N+d0yrG9m8u3a2g
	 /1Qpc7Psaw/yknQ37PP6I2MTKOicvv9z13FB8GC7pbntqTosTj+I85b+maxxDhm550
	 67wjnrT3lzOnoaAzgE9xKW1tOdPyutfKD1r1mn6GSstGZEDiqD4d30Inp60fr6V6ss
	 aA0L1YendXmaw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 4/7] mm/damon/core: s/nr_accesses_to_accesses_bp/sample_count_to_bp/
Date: Tue,  7 Jul 2026 18:32:47 -0700
Message-ID: <20260708013252.95888-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708013252.95888-1-sj@kernel.org>
References: <20260708013252.95888-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0E75A0004
X-Stat-Signature: ckdcfxpbtfk99onphrp1k7qtawh5re61
X-HE-Tag: 1783474380-563550
X-HE-Meta: U2FsdGVkX1+XBa3t5DMMcPSVfAmgUHmCqEls8D4X2VcpXxeKgwd4Tx7cCYTi5HcrY0tnwLfjmi9HUqrWmzV2lXC62aHi+7PkDYioUK9Og66H2bCUhKGwnsobxVNvF0JGkhIWR75TPeCRBQ6FK7ImBriMr3RWk8cJTUutad7YASwQz3EXrvBXvfaHYgpoi6ysJUuH8PTDRiSNGjfc4mK0S9id8nXUBy0FSfAHh25PD7gdYQyQ0sN03gFXiwKlkpgAOtk4HrfpCCPd1ZGPVpxxk+WCuoTW81Ogfl9GwsD2Gc/OZlPpzrZwu+MVdKkWLvj7hamhCTH0dbGT4ON9c6gjNzcKMrfGARf5P8sFTv3LMXh2fIuv7J4uoulBkYzLboEsR4yrLO4h3Z7A7LTFemaa9F/9vEF0jYaGsoCPDCwf/yazZkDJhgY4PdqQL26avmDZrdNAsp+MduIMxcM/guzBnvs7WWtYzGTq9NTcPwMClni9NYcubs6nyFr+yrSP0+Y/p5q2FEhSh6Kf8+gQ7NSYU9DOnXNABp1GiUsX4nmtfNOG2128A9KFYk6aTZRixNK0eD5vwpy1CiFNCZwby+TaPUqzAn6Q44I56ORfDgercYYmG9Aq1BLNrlpb3Y3u6zWhdpu1UhwzDa0Q4Bb/GimbCBbq80zp3988ZVRHmS/p3m4xWpQMEWKGNsXTagdxHiAkhCg5+15z20F5OBnOauI8tGCxCQQDpSXQdOos/p8Qd/3SsnGLbGD9/q4sz4nT5hLDTqKzUPn6Uqfyl22p6zCnrrSkewBs9MtwN2c4ozPZrgja4o4sHWLYpjkcwYH0t4d2ED50+0YYKTwF5OC5lOEhLVx2eTRNBNfDlQzv3h4/b7cn2UMjVqfw55YDQ3p5Njj0lvwqjgkEwLriWf7aMDNq03l0VvWm13SJernJdSOPFQidDvb5vQYIWyxGKHGWT7qUsUCtQRBwDm3pY5b/VxQ
 1sjWXlK8
 nrGGPBjCNzfekAwlZF2H1OsTiKcmQgrITLB475mjExQUnI5zH+aqMqLTpYAKv10A0RyMdRWCKjF2EHdQfctGy6qHBRrOrA0C25Nqv2h0tjbywe5VBcsB+2HXU3NeFocV4ubMI4wi3EJ1ElhUF2HyuNhA+sDb/3DQwlU5Fg0vAYKndzm/USqEk0OPws6TOCiVgLoae1q7myIEOffJl6CbywbmHAlGkSw1Beugst7HOJD5xNyvUuSI4XrUROX7trZlZOLCJwnTV3PyxdraGbJWE9ZOFQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_to_accesses_bp() actually converts a positive sample
count to the ratio.  Rename it to better describe what it really does
and not confusing for more general uses.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index dea63083917b0..718268df27fa7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -883,19 +883,18 @@ static unsigned int damon_sample_bp_to_count(
 	return bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
-/* Convert nr_accesses to access ratio in bp (per 10,000) */
-static unsigned int damon_nr_accesses_to_accesses_bp(
-		unsigned int nr_accesses, struct damon_attrs *attrs)
+/* convert sample count to ratio in bp (per 10,000) */
+static unsigned int damon_sample_count_to_bp(
+		unsigned int count, struct damon_attrs *attrs)
 {
-	return mult_frac(nr_accesses, 10000, damon_nr_samples_per_aggr(attrs));
+	return mult_frac(count, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
 	return damon_sample_bp_to_count(
-			damon_nr_accesses_to_accesses_bp(
-				nr_accesses, old_attrs),
+			damon_sample_count_to_bp(nr_accesses, old_attrs),
 			new_attrs);
 }
 
-- 
2.47.3

