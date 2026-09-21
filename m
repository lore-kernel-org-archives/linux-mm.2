Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1985DC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 00:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17C66B00D9; Sun, 20 Sep 2026 20:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54116B00DB; Sun, 20 Sep 2026 20:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F876B00DD; Sun, 20 Sep 2026 20:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6ECB46B00D9
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 20:30:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5061120543
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:30:54 +0000 (UTC)
X-FDA: 85235889228.13.BCBE5C2
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf29.hostedemail.com (Postfix) with ESMTP id E75B4120008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:30:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IIpwQ5qw;
	spf=pass (imf29.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789950652;
	b=IPhhqOwl7fgsw36cQvZfV90tO+BHQmAM4lW29jtyzxkAZTixQSYEpn6WkT1heIGXLFHFSv
	Y8cGQVoQTQKZJC40ZT/hlooI6lKSH35kHT6jRKJYpyYtRrNIstBJI1nD5hrS2egNOnf56U
	/MbZ6JpnGzW1wiCdmNULHG3EFfl9Dxw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IIpwQ5qw;
	spf=pass (imf29.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789950652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8p2uHDJTRX2GGhCC6kgbhWuhGhbxvLj9khVv1KzE7G0=;
	b=kqxdCOo9+IQc2G5QujJNei8TaeOohh0USus0kgbJrsFWSl1NXoCUOhYVSPWWUiRXpAjSlB
	TidV48lmRKhxH9E6EZO7wYAnNoGZyegDfaoMVJgKrlhMl4sDIJ+QErTrsy03iKIdwWJ6iZ
	0dqyiCsdFtpOsWfo761zimr4RKtQet8=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f633ecdeso2163991f8f.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 17:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789950651; x=1790555451; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8p2uHDJTRX2GGhCC6kgbhWuhGhbxvLj9khVv1KzE7G0=;
        b=IIpwQ5qwKfx95lvOP7mox44UTEEdGzsvOhahiDIBYRMgz/o9Mg4Ppyf1rbOsRgnDLI
         CuOL5EDIurs71qculEiDnGg1l4gSVMhky6/Ji2TgSKozL/To8VK5G0BUu9l0P/fYLqAh
         0Prpnu+gbIOcy/IWDtFuazJU4pP3wj6cNiQ6t3TKqef4w8osotCx2kd5pmkJSsCJszGT
         BwBBS/2eY/mX2DNJRc4SzWe+m5Hl75LWdJOCzg6k7jADBrplkeiPn82/OrcxUBKGs2xK
         cL4SatUXEt2h7oLUKZorE1l1pg7iSsxBhfsEadmI9SRct6zS1GUMb/QA5n/EwWpm/80N
         dbvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789950651; x=1790555451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8p2uHDJTRX2GGhCC6kgbhWuhGhbxvLj9khVv1KzE7G0=;
        b=tB2/kUIbCIOD8l/tg02v4/DvSd49DmXBLPnSc8W8VuLjZDnxFSaZLm2gJ1D7qCrZQL
         ZCN9px7/8cyEkw5Pb+Q371gZgQp6oCI3zkyAXqQ2XhoVEIt3ZuaYcTWbHkF7KPxRGBEm
         QLHLuTPH1AGbBefTZFGHsC8AcgJ4mNuVCMHgNfv3Eij+nTdfofql73HMk8SZaCpxynTA
         t/7wwsCQiJb1BedpJJkNI8IFjn8BDr3V/BF9VZ5075u+JF/spOB/lYF33G0ewutMldfJ
         u5A4760voU+f4IYUL3N2pCTStR7os9xlkMsXL3onTYFIfzGlfaVYEEWhPUybU3GkQ7Gp
         EmXQ==
X-Forwarded-Encrypted: i=1; AKwUvByxu0aM3KQAwrpAaVL+juj5kL6L7QdDZ+ieligpCGdYte6AxVKr1HhwEs8vybgnv9T+ml+C53kSUg==@kvack.org
X-Gm-Message-State: AFuF++mEuJISa5pj9lA6stz5Fs/xssQf75hHy4OFrmJ4ey401gmHHSC9
	DKQnAd3PSwZlGgTRRTsz8Hc1N/tvgCgkHVUOvMsLRjyL9g0yQIJIe+co04KP4g==
X-Gm-Gg: AYBFou1ei433zgJtx7R1rgW+TIrbC+mAu7E8K+Dk04wV2Rc/hCO479Dz//evt5eKZv5
	eiZ4DftrLJZSc7KPSW02Btr6vqS5sXA54qAnQPGZIwVn93+mZNr9S4qJUHq9lSv8+89T3yWQRDG
	Gv5qsAIs4LcmPCAxnLFT66+asHVUb9ylXlkuC3fKvF2wQOGCpWMPlAvJUUTCTlpZIqo6x8mFAaX
	Z8AOQ3bpwYJDkPQtBrq2m5BgeQ+kYqGdsxM1IyM6g/mHInu9uA0MvCTX6Svt4m9ZwFzmNhePz3U
	bej/foK8inGus40PRrsRoLoNOTs2rLBlU2u07ZGRZM7vAd5x1oaVfcrOYbjas/sPSybDrYFoTEw
	zzLPy5Tbz0EEu3DFVus8EnN4+i43CELuehyguOABcQ6dPa0E+1qGnfa3LIpVpWF8t/F2MOpOboN
	svc8dn3mz07gugNFwYez/GagtPO4UPgEOlB30buwdojp3XLo8KOiUk5SCAA+8xLae3kK6vi6lmd
	rnxCq18ckXCr+WQhkAALwX+VDomd3BsSpoP2dY8ySDT4rZ2jpHVOzgK7lsyCt0MeG4slciwro8T
	7XRCRz7cGInpd1ePS1bN7okyLBgm+Zm2RY7n0VaKdtIyI250rm9dc+UYoM7dKYeSeJ/qq3ylm37
	kKQ==
X-Received: by 2002:a05:6000:186a:b0:486:e949:532c with SMTP id ffacd0b85a97d-4871e367f08mr12791266f8f.43.1789950651450;
        Sun, 20 Sep 2026 17:30:51 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a012-6c01-e0c2-ccc1-7acc-3570.310.pool.telefonica.de. [2a02:3100:a012:6c01:e0c2:ccc1:7acc:3570])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48724583fffsm17515695f8f.23.2026.09.20.17.30.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Sep 2026 17:30:51 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm/damon/core: preserve the caller's quota in damon_new_scheme()
Date: Mon, 21 Sep 2026 02:30:46 +0200
Message-Id: <20260921003047.12041-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260921003047.12041-1-kmehltretter@gmail.com>
References: <20260921003047.12041-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E75B4120008
X-Stat-Signature: bksj9ycugpor3y94yfczb9enbf4jrnpz
X-HE-Tag: 1789950652-823662
X-HE-Meta: U2FsdGVkX1/a+ufRgs66w7e2X6oUk1amFMXq9xAAFWfWSLd3u+KQncnoOl8YyZtZuc7ObhBjtRpXQW/gYaBJxTwykcIxUK1Q4P18HLcYAY8pdHa/ZgSi2UW+PomgJdweqzZSrxfwSgQexwRweInnfhe0TwvksR78H7sObrLcFCNBozA4blkmuQPCnW91h51bYLgHjw/TmIVSrVtDJALRUJyfTHTqUdaxwixiYGFnJTvF9lG/vASPveWd0+9lyhOnBJBBgYTW8L+IYVBHxvUCIiEmbJF5kiiw5fSdQWQDar9qcCXQvPIE52rEBjTfxOQk5h5CJE1UhDL8hZ0EUsKsme8YzNTSUSVNKdRvW4BPsNBZxZKesKt4Uwf5EizZkpCb2z0ybSRNDqYPqNNGvmftexIYs0uiFHIO0+Eei0glaOeuDHmln146k+V82BVm+4FO6J4QPU/ef2aRaPH68pWiqKShfd5TFMB4H0rHOieyq6SgPLBaxmGz/tC4rActheO1jqer4QVKdElKBdSjuljVglun0P+mIW/uJQ19o3aHon5FYMr6Xx8+fpXHfYB2lCkWJp4mcxpWiHAsdwRmIaN9+AsYxcrAZx00KykYnbhq/encn9QVBtPsc7FnXl+d2KSkIlotK3zbt3HQKutAgjc7ejrutDUqJkaDjFxdnJ/gyNHqoEGVwIOM3SUaJGdZCMQfpXRx/V7UCFNpH/Hp7BN0rHyJeMRDs5Fe1l6um0yQRkujt96Fa+Ad3T1Ays9LhzjXTFUlrKBRbp25Ef4FjzaVtqa0okQP1aeRFjWLrtU+OGQoJwmTj0qJePE5JFl6nwB9eubfyszzW+MCR0WnZZpvzO8itX23uB91MBwTHIxOb4dHXh5eLLEWVl8puaTCeZk8zrTaplieHCkBk3goyX9AANpZRbmXxbzbaHBFeDllizDCDMtB+cFBehzkrqhRN/bXtUFGuv0Ta1BdaHgsLBw
 39J43vnl
 gdaFzJqp5sOyDTgnKvmdfUinlW/RJCarox/jcgUH6FuWAvvqfNKFRm+BWC4oNDmtB+8YDSrQl15S4/kRYD0dZ+cwPiP/ab/zqDwRg9McoxKJGnw2pUguAyBaKQezbNZx+09ILzlQg0hZhI0Jpz+zk1tx3XtrN7VCiKkTHThUfcbGyC4IzS98dzjm2kjbPQdAI0blui+zGt2kz15B+wlHWath37vOqKmv8FSwP/aYVtDgMmWkOghrO492HhEOBLJA9snIi93OXeXLZUe4wjHMLd6eO/Jq+JXey04cYRVuvs9upHGDRYTou4IimFXLfEnbbpPISuMc2t10dyWldoSS4DkUIBDVuzP/W6nczm2qtMPlj8kmPNpj0l+HbzrcjluXNNrRbHEpchScbNow1gKpHYiFGkiQCOOufVy3SrKlXIyA3r+Fki1kjbeV5tDSSf3Q4oR3q8voBsDMabMM5lZ0ds4qd4O6UyfHv9JMXJoIruv4lsJdV5i6H/xmr5pHJ+3t3k5CX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_new_scheme() calls damos_quota_init() on the caller's quota before
copying it to the new scheme. This clears the caller's effective quota,
feedback input and charging state as a side effect.

damon_commit_ctx() first copies the running context into a temporary
context for validating the proposed parameters. When
damon_commit_schemes() creates the temporary schemes, it passes the quota
of each running scheme to damon_new_scheme(). The quota pointer therefore
refers to the running scheme, and damos_quota_init() clears that scheme's
state before it is copied to the temporary scheme. Even an update
rejected with -EINVAL loses the running quota state.

For a size quota, this discards the bytes already charged and allows the
scheme to use a fresh quota before the reset interval has elapsed. For a
goal-driven quota, the consist tuner loses its accumulated input and
restarts from its minimum input. A time quota loses its throughput
estimate and falls back to the initial estimate.

The constructor side effect was introduced by commit 70e0c1d1bf94
("mm/damon/core: factor out 'damos_quota' private fileds initialization").
Commit 60bd24f272d0 ("mm/damon/sysfs: test commit input against realistic
destination"), merged in v6.19, exposed it when
validating sysfs updates against a copy of the running context. Commit
b90408ef1163 ("mm/damon/core: safely validate src on damon_commit_ctx()")
later moved that validation into the core API.

Sashiko reported the same side effect [1] on the RFC of the core API
change.

Copy the quota to the new scheme first, then initialize that copy. Make
damos_quota_init() return void, since its return value is no longer needed.

Fixes: 70e0c1d1bf94 ("mm/damon/core: factor out 'damos_quota' private fileds initialization")
Cc: <stable@vger.kernel.org> # 6.19.x
Link: https://lore.kernel.org/damon/20260702212143.0CB6D1F00A3D@smtp.kernel.org/ [1]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2258b72da7a78..e655863d33d9c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -734,7 +734,7 @@ static bool damos_quota_goals_empty(struct damos_quota *q)
 }
 
 /* initialize fields of @quota that normally API users wouldn't set */
-static struct damos_quota *damos_quota_init(struct damos_quota *quota)
+static void damos_quota_init(struct damos_quota *quota)
 {
 	quota->esz = 0;
 	quota->total_charged_sz = 0;
@@ -744,7 +744,6 @@ static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 	quota->charge_target_from = NULL;
 	quota->charge_addr_from = 0;
 	quota->esz_bp = 0;
-	return quota;
 }
 
 struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
@@ -776,7 +775,8 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	scheme->last_applied = NULL;
 	INIT_LIST_HEAD(&scheme->list);
 
-	scheme->quota = *(damos_quota_init(quota));
+	scheme->quota = *quota;
+	damos_quota_init(&scheme->quota);
 	/* quota.goals should be separately set by caller */
 	INIT_LIST_HEAD(&scheme->quota.goals);
 
-- 
2.53.0


