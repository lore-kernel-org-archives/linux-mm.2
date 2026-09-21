Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD7DAC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0B366B00E3; Mon, 21 Sep 2026 11:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3F26B00E4; Mon, 21 Sep 2026 11:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD1706B00E5; Mon, 21 Sep 2026 11:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A43786B00E3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:24:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 346F01C1933
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:24:54 +0000 (UTC)
X-FDA: 85238142108.23.0FC2BDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9DA5A14000E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:24:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYuNaofm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790004292;
	b=NrgB4Gmr9nijYoOKFu03I+JqOjp5U3oh6h/e1V3/H7oIVKeXwwW7SJl7YWHe2HAnR5TIUi
	ZyzwmjvwK73VMTdAMyKBhLu8iaHY3D1H5mUNEpaYoa092Fx/mXuFHNY9gmW0AZxyMDehPU
	ZuaK6csczvztShQ8L9nt/CNXXynfaEc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYuNaofm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790004292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhYZozQNlJ+OrzQg2fSGExZ1q1RyH+RT/pmgwytGQEE=;
	b=Y8tU9rpPGxYAqcdqdqcbydJVD6CY+Ihu67JwFgQLV6e4EaCQCabcC4/FOSTfaWHSRx94ba
	ikPXKYyRcUYqIgy+1rFf2wqzptV2AK8TuFLr9hBngBZn7ddZespymTCP3NJYzgG7HCqlE4
	FAPLA2I5xE0OMMXv0P0BaaX0bSYZI5k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FB116021A;
	Mon, 21 Sep 2026 15:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD611F00893;
	Mon, 21 Sep 2026 15:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790004291;
	bh=lhYZozQNlJ+OrzQg2fSGExZ1q1RyH+RT/pmgwytGQEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SYuNaofmP9J/SPxw18OqPmlkKyGRAXDtPJwkLz2ge4Zt4g73J1V+L8QQbBE3zxTl1
	 mzN/DcuVT9m2uTdBhhMCTQYbc/oeYG41Qspbm2xjDNfvKbSmNpl3voMqE4Cl3pPSzq
	 HivvICv7TDF/CgK3KyLQMlMj7U0V3JslI+Nb+lHh/qLfXSECHfRWbm0zxwI+BVwlKm
	 PoHGxbQrKVRuvBLyHb2/r8gedFlZAfrBlfodvXLA/s0B/2wZu16UB2dJGtszWXHX9p
	 JV/xiDbGnIjztmy6rl48urDy4DSDr9He/mw6iZAzoR2rrZQWL+J0/Bzdy3Mi5A4Knc
	 mMbiQEXCszn8Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	stable@vger.kernel.org,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/2] mm/damon/core: charge only the part of a region the filter left
Date: Mon, 21 Sep 2026 08:24:41 -0700
Message-ID: <20260921152443.80132-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921152443.80132-1-sj@kernel.org>
References: <20260921152443.80132-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9DA5A14000E
X-Stat-Signature: gswonzxk6a678nsqce38cdroe944os3u
X-HE-Tag: 1790004292-326480
X-HE-Meta: U2FsdGVkX185Ehyls055fbj/24HK10Nr5dBVMnu/abqoUt2G46nuCegwf2HF8IivgTXEbBA5Qsu/XKizYRxwDsv3cw++LFhlsTXmc9dQ7bsg7VK7q/dbLfFLJeZTFovFxN+7714kRZObz49sq+nz4TIk38/hP21+LRqsTgM7c7N3hg3p6R9ZzTh5z19HMOu2BAVa/UG6Yg9ZaAB6tWNnX6ymDJoS4C5lMZoJWD5xS9LjbsGk8vAFFyzajugtdsdZleeU1UyjhjKBgHqsTxIxftrgzj/7A+r/iKgYqynDhPReoQ4vaU3j3JP3UyovdT135IAX4T8Fs295hA1hTFYrr0i+ezrqDIRsGsBMBisOrr2TBHUAA+AY0Nozub4aJtn4+64RujOcut/S3c3wZ7IwFBCMSWRdmHfFBU9pTOFmldbUqmArOxLAQwW2PUDdI8y8hXNCOMnWaR697Y26ojkcyqtFgwguIZSuugbxwyzZifx6eR82IPm3jJ2Hcv1UVhXAGFhBgy3JDVdaP6S4X09lVPXYVsIUUkU/tVFIzfntCuazYiz0AZmQsLRaL5PtXwrESmGZuap7Ygw73rsNjAO5pOT4VuIs6m5n3ceU5ASIkjsHfqdmeHOOA/64Pql9+nFphemwvUSboAebr6NLoCLJ651yfWZE8e+UlLIpsYldb9+LqXSEdc0+YOcVcNMnerCV1eWC4tqTC4q65XkcO68zJU8kNVJLfc//uCObjM7RdlPSHqjwN0hTzGVZgYyQ+3PZ1BTiLzIWGlRYEk/IePuhekUx9QAfOQJdnfftJYnjwJl/yCKnhMqd5Uy1EFjUZ9bGCg6BuJrltlbImaZZaf6lVaqu/I1SXVA1IsdBeEcEwkH4wHWvamehOQY/Q78GTw7AifTxWb6/qVtgsfktCMipexjebmmDkhLQyfYQMjx3rErpLIlxwK6oN+9adPIHUsj0onyfsiCgOIxb+wv112F
 DbB0H9IO
 QCwbGOsI5goi+g4uSR75SktVp/nCkGD65SYbn/SFrTk8CHpgX/juFRFLukRUuzyimsPdxSBB94r07781BJqSBlITdI/qcvoRW+RGBmu8TeeQOvXSKRmVXQFJUJoUTSe1JWF7mjQQQ1IvmuzuRVQcmVSoAOJmJTj0+V6DMVOCSQxgIoSjMngmRXgg4pjxppd/8qIQUbKVS4r6NsdGygDOgJck1oUMYJO/HAg+7KZ+/zkwIW+EurIkmUYvJnP6KgXjLiq0xSgbhEAhcUd2jnlZW4cKNgqK7vVZUTnPHiqVscB7j9k6TEy2LIsB8VNlZEc2+lDOkhxPGQDbpcGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

An address range DAMOS filter that partially overlaps a monitoring
region splits the region at the filter boundary, so the scheme action is
applied to only one side of it.  damos_apply_scheme() reads the region
size once on entry, before damos_core_filter_out() performs that split.

The quota charge and the statistics update therefore account for the
region as it was before the trim.  schemes/<S>/stats/sz_tried counts
memory the filter excluded, which Documentation/mm/damon/design.rst says
is not counted as tried, and with quotas/bytes set the excluded part is
charged against the budget, throttling the scheme to a fraction of what
was configured.

User impact is that DAMOS could unexpectedly slowly run, due to
over-charged quota.  DAMOS stat could also be confusing.  No critical
events such as crashes or leask happen.

Re-read the region size after the core filters have run.

Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Reviewee-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0aa5d0ea8ebc..4687b909d42c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2784,6 +2784,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		}
 		if (damos_core_filter_out(c, t, r, s))
 			return;
+		sz = damon_sz_region(r);
 		ktime_get_coarse_ts64(&begin);
 		trace_damos_before_apply(cidx, sidx, tidx, r, nr_accesses,
 				damon_nr_regions(t), do_trace);
-- 
2.47.3

