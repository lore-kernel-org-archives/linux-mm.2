Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78107CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17E36B008C; Mon, 22 Jun 2026 10:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8F96B0092; Mon, 22 Jun 2026 10:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7376B0093; Mon, 22 Jun 2026 10:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 887D46B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:10:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A72FF12018A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:10:44 +0000 (UTC)
X-FDA: 84907734408.16.19C1C07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id ED16940002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:10:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHa0UaAV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782137443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GYfS+/BMt2alhv0ov5ohTbg1BBH0UkT3aXDJtkvAQwA=;
	b=wy2oMfNE29jqaEnMjOl1ijQJ1TIrXqGLP3MkD/GZynQwLuR7iidlzqVpsabm2T0oq5QLip
	R+eSfPUG0yosHHFaKO0D3+opHoxQR+NBfBE4xT2p4raClxUwf8RRfYaMLYsNtlNhTyY/5h
	z/jden43oGbUXURfXl40Ds+62rG3o7w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782137443;
	b=a+7iwMECRwSYxYxxn3LMHYiGLKOaoS2x6Cu7Ky736oBKlhiHfR3Ls9I0hm3KThxwgJRzLK
	xua/DMJTOpfaMQMf/MA8qW3eM/gOzLLy2zYJIxlWJ+Uyi7oJr73qqyySk84NuT4F/a9qOm
	CXLZfOl6Vi5gblWj1j+FyrbDpTixmYM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHa0UaAV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30CB343BF7;
	Mon, 22 Jun 2026 14:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666101F00A3A;
	Mon, 22 Jun 2026 14:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782137442;
	bh=GYfS+/BMt2alhv0ov5ohTbg1BBH0UkT3aXDJtkvAQwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHa0UaAVPETqYGAj1f2w9QCVcoQ0v3iwH8D7S44GHnF2xZzYLokpnnGdE7u6HbC4u
	 ASd2gfW2bVw2bQz19NKhIyZaMXoRVY0rE60pmarGHG97qkNfw+l58B6KaJm4Qg4d01
	 kGN8DTxgm+y6FOEkBW+r36X9oKyNo7I0Bp4Men2vD1s3T5hBIA7FHicepRpHEKWlLn
	 gaPB0T6fCi4a9vfB5F2onDPJfvg7kFGrFvRaZX4IB7c8YfPNfqONlKmUHLaqBZ/dCo
	 FooHO1Ob0de/jvzGr/49NyJy15U6ieMa7onZ4Fuf3yNtQQM46HWSnJkmsZtaL+cHzz
	 6q/pg89fzn3PQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 1/2] mm/damon/core: handle zero intervals in damon_max_nr_accesses()
Date: Mon, 22 Jun 2026 07:10:24 -0700
Message-ID: <20260622141027.29145-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622141027.29145-1-sj@kernel.org>
References: <20260622141027.29145-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ED16940002
X-Rspam-User: 
X-Stat-Signature: 78s5achescfcyi4w4g38fnskzfqq7tgo
X-HE-Tag: 1782137442-589952
X-HE-Meta: U2FsdGVkX19PirrVZhEqeuzsFKKi8NjILdsXRGQCxsAFoXtZGHDbqBONIPVejLQ40Fb8vW886ncbeCa4Xnd9xRdclVYSU76UKkITMfaXNe0nhYRjido1T64qRT8bXWsE9NF+QqLg83+bVKPETd09/PanHBsGj/XV9bS8VXYVH+utsH1y73sXswyQPP9f2pdes6A9BWcNFnbYErF6LelyDy+sMH9kQRK120YdAGChGOcoV38k75HxYN9WNMd60Dt2p7Bhr0awK1uUh0xhK+yPHZZQTq60awviyhUjb6XQeLFKlo7SjmjOa64oKs6WmP6+y+DhP75vGa8I9igHQt6H+QhqnHTyP+ylFhlsKw6ovOQOEPgW4zBQjCln30hNcnLNmNtFuYZT/vwglj9ycxXJSSkAhYE1ZsTIroQdcB7JjnNuL4jlMRwRF0tauB0Myw9RoQLbf36C/VPVkhrZYAYLdHEh4JUNFZLzK8V/V6/ROB5KnH7114Ui7uYX37D9xhUy88ImxfOzJVeV3NkCf9bOMdJ7CYd6tmaNMCmsTPDkqJN0E8jFJi+q5oP4M6MMmrvydJHj83dij13n1nwOe9LZ0+cYeuswvjZJa5QeCNncYWIBgNZz0fMUJaC1zUbBpnb8Ot0JBRKivASV/UK6e3uvdVzPMfzEMAksihThZukqX6j3JKnfGoCu+d+0NY6khpeduD+uwNzgYQkGUZDeuFK1FWmyw6uttvBjswPfq2kxeDPoeAa31tvXThsxg6gdBp33J02e19Z5NNPaRLdYVLKXf7ewWILk/uxIDtWchXpwf9pqGJ8S9B7/Q9NJta+n6S/KPtkrOrgavyIW7M08af4NX0qml6QwyKmox4BExJea4NUePxu/U3WgDJo3jKYhr5JisLGXGnizgznOK7u0OXECsi4JL2THM0obfDK43MGXOMTWR1rKpT2rfUhOc5MYYvc/HciJe7+Ubr8g9+g3pNE
 rDHiKdZ0
 DE4JUpK9rx0y6aSlLax9AdPEwc5kaCJoTBSpOf0TMqKSk+xsBxU+3cbQsXlyXIHNyFT1Jd2MX0VLt7nGSlXRxzEv7mH/6mTc4W4T94ZVsDTCGSmHNuEJQsTICiOd3W16en0iXInNoCJryqkvUjim26FeCDQzZHnQ0PWywEw/EiK9KVGdv16KbgHqS5konWbjzOUBF+Lv/ODmY+ShL6Hqw/E5r6ve3EtyHHzMR8qQoJ2aVY1BuM/P70dOT5QVCFsDoZ49sOQn2Sg4NYbjLyTE0I/O5Qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_max_nr_accesses() causes a divide-by-zero if the sampling interval
is set to zero by the user.  If the aggregation interval is set to zero,
the function returns zero.  It is wrong, since the real maximum
nr_acceses in the setup should be one.  Worse yet, it can cause another
divide-by-zero from its caller, damon_hot_score(), since it uses
damon_max_nr_accesses() return value as a denominator.

Fix the problem by setting the denominator in the function as 1 when the
sampling interval is zero.  Also ensure the return value is always 1 or
greater.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260619202459.145010-1-sj@kernel.org

Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 64d75c78f4df4..02ac34537df9a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1066,9 +1066,13 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
 
 static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
 {
-	/* {aggr,sample}_interval are unsigned long, hence could overflow */
-	return min(attrs->aggr_interval / attrs->sample_interval,
+	unsigned long sample_interval;
+	unsigned long max_nr_accesses;
+
+	sample_interval = attrs->sample_interval ? : 1;
+	max_nr_accesses = min(attrs->aggr_interval / sample_interval,
 			(unsigned long)UINT_MAX);
+	return max_nr_accesses ? : 1;
 }
 
 
-- 
2.47.3

