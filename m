Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30792C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 15:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8A976B008A; Thu, 17 Sep 2026 11:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15D66B008C; Thu, 17 Sep 2026 11:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC156B0092; Thu, 17 Sep 2026 11:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A17A86B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:06:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1AB31403AF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:06:45 +0000 (UTC)
X-FDA: 85223581170.01.C5D14E1
Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	by imf19.hostedemail.com (Postfix) with ESMTP id 35DB41A0009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:06:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lkWoNNHB;
	spf=pass (imf19.hostedemail.com: domain of karthiproffesional@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=karthiproffesional@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789657604;
	b=GVHQnyaud+xbw9a5dGZ4DRBSa5vBsAL85qtFj7buy4hoFxtk7judxpnhy4d/anRXTpm/GK
	d2dDHCQGyw1cKGqdrblV8u6GgDhlcVwyydZghF9KR4Z7/gIXd6v/jI8XW2AFBs9FP6K5AR
	CGYLWoUCyxNeiwMa5ln1q5QsCaH9E4E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lkWoNNHB;
	spf=pass (imf19.hostedemail.com: domain of karthiproffesional@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=karthiproffesional@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789657604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1zHs5HAyUucVjtHvZt4rt64j5+dwbb1H5FeS2taXPLw=;
	b=wFfyQOrrZoznCSpcuq4OxuuXVTr9NOO7TT/0YnaeJBuc89iWuAcFDEYwklhitWnurCAkqu
	+Ux989WMFiNHwEciwtaWXq7n2Dx42FeikZfHgC4n04m9zEYXXoCNsdwRHfclatNThjUB4Z
	ENQqjejA4mybc5Q8lSKJaNAhW9RwDb4=
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4c112aaaf04so538826b6e.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789657603; x=1790262403; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1zHs5HAyUucVjtHvZt4rt64j5+dwbb1H5FeS2taXPLw=;
        b=lkWoNNHBPr278DvXImkx6vvFOhTuU+bL9DMOPMNvIGRRkgDD1Kco/gl9X7m+zx+rLr
         rSW3iV/GRvTF4jLUL2i1X/+HYQ0yMaGC2T5Oa+qxmxmqZ/dP5u45Gr9UC4o66AbUGRuL
         trClf+udPTXZigCnBi0pwn2oZG6QMmEuVmb4YlouqXHyOCyoSC8/bKbVODIhK8zE/Sz6
         3QONIlnGlYAEJdJr37LKmfZmJk4UllmbB5T1rvCc1ZqEvn7Wgd3m1ZQiK6nWUCtvk3ef
         z2fP6tCWSAkVC3pWi4XF3fRIAozTcFql17kKaE17x+2uoulhglMATP+PRwY5BTogRktH
         pQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789657603; x=1790262403;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1zHs5HAyUucVjtHvZt4rt64j5+dwbb1H5FeS2taXPLw=;
        b=XOMrjeX00R9NVLll7iFWfgpoSlsuLQR4DgTax+nt4uhvjIV01CLmL2zVb7X1EZeG1D
         MduSmyyceVwO4BQ+KRR+TNmazwM6l8z7g8H90ZU/zISguAwoorWiCeZX/oCRNdb62HZY
         Ek+XfNwFe00pmsE/LrmicOLOhVSh0+J/s3uNDg2fJBliiF1T7zcZjcKoDoZdUVgMZYI0
         sfbRH25/kxm5EMcq1VALt73HAoEQziaJIDF3cG66FwRVW8NLQdko0zuW/HVSeVKHDZcF
         Q1ZrbDdF8LNtj4A43NOudBD7si5RQHK635Gd9Mh6IEt0QZvOJsZGaScvojZrgRYrYqK7
         Lbcw==
X-Forwarded-Encrypted: i=1; AKwUvBzZBYXVd4jTyEqiv0hKXqW5M4aakSN0DmtLl+JoL8SFjQmS7VB/2O4F9bgT1kpAxNp4PosamxphlA==@kvack.org
X-Gm-Message-State: AFuF++lgCw9cW/jcqzALUP1VUd0PUi/6l7qi/4X8QLAFkuuZosgiuWwM
	yuBC2BEeN0Wl+XZ0gdkh1Vug5pJidjip3NxsvVelYcWlDzXIqJ6TSqjW
X-Gm-Gg: AYBFou2U0EAFUo89T4BS61g84ZsNVS4lrZNS5vu3b8uF1w7EGAIhogzURI9pKPkxGMW
	KFhqS1TKN1+hubNsuZ8sNs42lMQ97lKsHUTgBjeF8IB43o/1tpilLi419OGHgxw1EUFIbHtPzwg
	jFCmJjUJ2A0oFMfZpnpq2+amQUBfi0qGCnFRsQZfzKrDcQB4+fOTOUjprobMvic6VfyDvOjqKbn
	EkuVTjNWYqKm+SjKhPRnmB4QpzFmwkcQGuldP6AAMWWchA2eASsoy7O5flkXCu6W8GFKgXuoNfg
	0CgUC81iGSdQqhbcRCGWtQ/+sEi28sT347+YMjMC8E2Qxa31pXEBkA0JFhhlCGRtuLAzK4/9K18
	7vefoW4uH1Ri0S4NVsdXCq2KO4JS5v8SqMCTvQ5jjaZMzHiPJsKU+V7wiurvBLubpPEITdWS3gT
	rGQ2b2MgXzdv6Cv1e0pwTD38v183ZU5X4pXCqFxJdBhKHrSojjctXKN/th80qiwJE4jVy0uLOjl
	wYlTN+IBCwpkNGSLfVskBx69pfGnkuyjkQTvVXnm/EM2bgDv1C5pX2TEj2ApQb1++jJZS93DBPB
	tpuCc1HDKnm++LFzNfh04vxl8BcoZHDtci7SjIgpmNwvmA==
X-Received: by 2002:a05:6808:1b9b:b0:4c3:e608:ade6 with SMTP id 5614622812f47-4ca4cbd4551mr9330216b6e.18.1789657602989;
        Thu, 17 Sep 2026 08:06:42 -0700 (PDT)
Received: from LAPTOP-97G9G880.domain.name ([106.222.202.182])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cb6a3d7a4fsm2741322b6e.2.2026.09.17.08.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 08:06:42 -0700 (PDT)
From: Karthikeyan KS <karthiproffesional@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Karthikeyan KS <karthiproffesional@gmail.com>
Subject: [PATCH] mm/damon: reject zero sampling interval
Date: Thu, 17 Sep 2026 15:06:31 +0000
Message-ID: <20260917150631.1138698-1-karthiproffesional@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 35DB41A0009
X-Stat-Signature: r3hrngra77d4omkpf53r869rsoaqh8w1
X-HE-Tag: 1789657604-147432
X-HE-Meta: U2FsdGVkX19IzlHBs1itrESzlgvNjxg+BMWCvNlMuvM2ixLRxM5qaeG3dkUk8zgHLAzveoRIpkxg5sC0Oz5U+SjcGr1xeB9MMtMNIVzY+OTd9YPwUL+XkQiYf4rkffLHSYtCddpKNSLZPug/meuBLYnIXiwja08AWB3ycNJL0/GiD+yWYH6CG3nk9epx5RRC53OjIrA4m5TuRMHhPg68PY5JOvpYsr5FgFsC69063XtTkqZUVwPgDOQfWuRcJB2IrREevupVuf0IQxhRShc+2g6vrf8AhaXmwFP2ELojuCVCFlKIlEnA3vfJ14pckgsG2Uzpc3bG7xPepgXJlGnpSUgY2wt7q+buCQ4ifaqWI9qu8Tvrn+ZabM6fxi9+A45sTX6ZMdvEIZFdKhCbY6Q/PlzeS53jrrWzihfzzJNWWa9ro6J5rwKQPA9MRRELyiLC/x/0UrTjMYXEmzJJ5PRjUf0K6EVFIjJ39p25oNKRq4W7q3nIVxghXGO2awUv3fzIzlOwelySdMluKT5QrwLUThttmdef+bvjl6O052VUeC7uJN544ejqlAbMXY5NsKioHZUp2SdrFK4HdcuLD4+KN88k2ziKeUWAnNQ6dO9GOWURmCPTWq5OaRtSyjQMrTnLnFf9PGtcjZ0g6fhA9XYPWF6FYq4sMWlSdLagR1o2ApEmrYmZtEe/dLZW4Z0vReM2PrdKUmz/CVCbUKKssHlD3RIJ+EXSlaLH99HbMcr6liB4gwQcd1SSNbCQnMcSy2NH6SPz0daVn4Sjw8t6n0yxk7x9MnLBsZ+baeot7/2KEOPH0/GkoAGtiWJGpmaemclOz52wEO1DqbEAOxbIgmJ8vlp02Q3aUVSRtKspUtbGMoGZs7PAxsVsX7mgQLO0WXhnHu22yOgeB1DVt+urwvpoOXVkVcBQQXN0/LNccVFt13XCi6o5o5OOlP8xaS7X7vz6RXu2S3yfKVqNfwD0yq7
 l3KfBy/R
 Cm460leAU5P5NCeOTqidQr6eml1xTKdki6LyRAMuydWEyaIuJ5NnI2JlVfbs0Quv0Ay/8+yXx279BeygUiHYPPG6xXcClbJZbjaI7L8fclhEOHUTBprvtGRnpdH37bFY3BMEaMBh7i4huM8iBc0EnnfbySWo23zD5Y/TgdUlB9UQV0d7iI3ubGfaAeekuES7x0ZpWPwIJAhkD1SCkhnGeKXGolUu93B44unhJRExKwovOI2tiRsGLmHlJnxlPKspzRwRUo1YtfPq3MK/dbMwqnC8eEHCAcfYPiBv7M9lyuNcU/WsX703DN0BjnQBtP4GYGCVIwJAPfvO2TDdPbvqiXvhz0/epCjfsNQbh4s0ppA+B96nF+UnZeAKnoQgFxaDsUiMMC6MJl7uz20hjjfdQg3/C1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_attrs() already rejects inverted intervals (sample_interval >
aggr_interval) and invalid region counts, but it accepts
sample_interval == 0.

A zero sampling interval is not a valid monitoring period.  Sysfs "on"
and "commit" both install attrs via damon_set_attrs(), so kdamond then
calls kdamond_usleep(0) and busy-spins.

Return -EINVAL if sample_interval is zero.

Signed-off-by: Karthikeyan KS <karthiproffesional@gmail.com>
---

Hello,

I recently started reading DAMON and just found this one.  This
change only tightens damon_set_attrs() validation, in the same place
as the existing sample > aggr and min_nr_regions checks.  It is not a
crash, UAF, or race.

sample_us=0 is accepted today, so kdamond_usleep(0) busy-spins (about
one core).  Sysfs "on" and "commit" both go through damon_set_attrs();
one check covers both.

Checked on v7.3-rc3 (238650ef6c7c):

  unpatched: echo on with sample_us=0 succeeds; kdamond uses ~97% of
             one core.  echo commit of 0 onto a running kdamond also
             succeeds and it starts spinning.

  patched:   both on and commit return -EINVAL.  Valid sample_us=5000
             still starts.  After a rejected commit the same pid stays
             on and does not spin.

aggr_us=0 with a positive sample_us is already -EINVAL from the
ordering check.

Thanks,

 mm/damon/core.c             |  2 ++
 mm/damon/tests/core-kunit.h | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a1656..376c3e2cbe00 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1060,6 +1060,8 @@ int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs)
 		return -EINVAL;
 	if (attrs->min_nr_regions > attrs->max_nr_regions)
 		return -EINVAL;
+	if (!attrs->sample_interval)
+		return -EINVAL;
 	if (attrs->sample_interval > attrs->aggr_interval)
 		return -EINVAL;
 
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4a536d41cdb2..ec8ef71956c8 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -658,6 +658,19 @@ static void damon_test_set_attrs(struct kunit *test)
 	invalid_attrs.aggr_interval = 4999;
 	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL);
 
+	invalid_attrs = valid_attrs;
+	invalid_attrs.sample_interval = 0;
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL);
+
+	invalid_attrs = valid_attrs;
+	invalid_attrs.aggr_interval = 0;
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL);
+
+	invalid_attrs = valid_attrs;
+	invalid_attrs.sample_interval = 0;
+	invalid_attrs.aggr_interval = 0;
+	KUNIT_EXPECT_EQ(test, damon_set_attrs(c, &invalid_attrs), -EINVAL);
+
 	damon_destroy_ctx(c);
 }

-- 
2.34.1

