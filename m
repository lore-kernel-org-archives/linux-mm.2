Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACBCFFF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C9FF6B0096; Sun, 26 Apr 2026 16:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1206B0098; Sun, 26 Apr 2026 16:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669166B0099; Sun, 26 Apr 2026 16:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2266B0098
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10168C22EF
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:39 +0000 (UTC)
X-FDA: 84701905638.23.C195CD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8102C40003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GXMKqhsQ;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1RNfw4rBtu6n86gT5HvOtDC0ps78dggT9IqjKvYBlEY=;
	b=c7dfUV1XWgNBWCgjCCTKgRVQWOqvHKPAk/BJ2XimCNr/U+usUIGvvtyjCVCIjBFxibTSY1
	qpkcMuYsJSFcMIAhsm75VXjnuP9Ae0Mv/97IIrZRkMxLiszvWcxPucIgq1L42oB/9mbHYc
	270/zkuf2tbcDZflIqUw8gsPS1W3JHU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GXMKqhsQ;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236757; a=rsa-sha256;
	cv=none;
	b=k0AAuUoERSUjrtWl0Gfhl48OkResKDkgvL8UfeAa1/PClvPOWVHFtHD9biDx4DnJoEUBgK
	PI3aONUak6GiEoa9qfcHuiZS16MKQlGjpU/I2r+bplJ8i/+k7DKECCKVCjh6ySePhJHHEd
	JxyRUNnmrL2P4Pz/+wdsJA3IXp56rcs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 04FA660145
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDD0C2BCAF;
	Sun, 26 Apr 2026 20:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236756;
	bh=eeiUmDXDACMbPx16b5hdV72jEFWacDugbdDQW4vjkpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXMKqhsQ5FoHGqmoLFZYr3lIcs2q57qa/lQj1+BBzHZ1w2UubNCRvee/ZMw/MzLxb
	 kXtHOuZXZneHfiZIyWEP785KCR9MZFl4ck3t6TFIllQrSyoM0UmRZQfkuQcDIdllXe
	 jS28y9pkO4ol6pOBWw47bC6B04X/7xAGdFOn6ljQOO7ao79j/i3/jIXzX8/JTatk4j
	 Wm2HswnkcWuDwZBTKm6j1Z0WhWVu3C+mov2cf2wMDvTQu8+RJnOHUqWFzM9v7d113y
	 DZMbbP9WwWbpUl7Qx0ismbDLp9ccDL8gbnn/kVSVGxKKs9lDNvkWoQz3wrDfkihcin
	 9OvrzP3HkxDEQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 06/19] mm/damon/core: introduce damon_ops->apply_probes
Date: Sun, 26 Apr 2026 13:52:07 -0700
Message-ID: <20260426205222.93895-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8102C40003
X-Stat-Signature: qx9c6nbm356yasdgn9oxzcifmwip5ydc
X-HE-Tag: 1777236757-886947
X-HE-Meta: U2FsdGVkX1+jgoZpjfrO+ozKQqRw76kZ0MQkiGavwEOQTN55jQwGAVX5vTvdvIA2/DmlhYxMgsyZcr+ELig97gDGkZZpCfTjxOq3PGBECHaQsE6tpv7/rlDhfQkD3xgl2sS9E76vd8Elyo9afS9b3fzi34Twgd/ThGXMPcGmhAxrv+sabp/wm6a7bfhix5MkPksQBYBthTyWi//WkObmrNvKlUwM0O5ekBaYJZPXhE89vEFraadN74Y5BMeY3rmW2ORYH0nAUFeSW6opm2brQB8HVIFHSsFh5BE0Q0DMCQEeOJpNFFEEqa9h4EgQa98PGi6GrwuG/5sijavYQ0oQXjTq4x+HIuKiRK6CSiBvoiAdlx+EdPSa22wsRd/TIPVs0x3jzLoRnDSocRYWwTpNiG9YLur4qpnSv5CZJQk18x3NP4TATBKDGZeoo00C38fjwYvWO8dCgbTFwk+8r1k5XcYbRgPnKzRGrZ+BWMw/ly6JRnr3Lci9C1qRhVnxWQL5Iy6xokbfP9ShPi8kWjt0kzGDGBqIENtgHugtBMsqzdPnDlRFJpBttZCSAJSDtbqmbK3OR34o5Oj1RAH1b+rfm1SYJmT0McNfZohKpCvf0KvQpkWkMGdkGmBuR3BoIoFloc4PWRVMvuFtcloVlcw8WxvSG20NWXAziJ8wEnfno+TECP1oPWdJnaiU+NuHIu73DtdzqFGKwjnRL+Qe7MEiZ7ry1zyuRr/ogMYjl7kRaVLR85YbmnoLwRHV1UfTLn3jiluRvxQ5CEjEW/rkv88gqYyqhT/bRYrb6cnsMwWkqprveUg0R88Pd8RcND1pFD9FBKt1l5KhSn0++XDVMpzNZFMWa4TBUyb6kGJcB2SwBl+BVczwUx3l6EHFvxxOE2Vmz0MURlwDdGkHRm8jaDjYPzhbvNln/I/TeDzCv1g+tmUkEKkDMgi0pk5dNq9bJacENZA2kmZJcQVhNLhRVBo
 naxyzmY1
 +KFAfO7PvgvJWLs5foNkorr4AFqwwbdwp3CP+9tQwj0vGL++qjcpjLZ4RAeBDijmbtLBJgGyhArZR70O8bGzmNhqJW62NNhmx7xNzKUaUrYotZx7fahQNUrADHlGdmLoMQT6zGxGAmHv9F3v/doKaeR2ha30SzqEZ548DBzxK+m+0NeOuu+P/gUAs5IEIISpmj/r1ffkpUCOkLXtfUNj0GSHiK72uwRAz9pCIOyMORigoYf8t3FrOis8r3g/MQbQBsdxBArHE3KzotzQzS1ZaEU+jSkRAt6ULTUhV5qiJjSIRJxUB00zbQfaiaOCuRb/u2olCQhvJeQhtr0G4hBlEx6PQ4ZFxixzlx0bTph1Psx7OWGFu37ZA7qGcofZ6/fEFdm3x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damon_operations struct with a new callback, namely apply_probe.
The callback will be invoked for data attributes monitoring.  More
specifically, the callback will apply damon_probe objects to each region
and update the per-region per-probe counters for the number of
encountered probe-positive samples.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 766d6daa52a3e..4266fcb121a33 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -632,6 +632,7 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
+ * @apply_probes:		Apply probes for each region.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
@@ -675,6 +676,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
+	void (*apply_probes)(struct damon_ctx *context);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
-- 
2.47.3

