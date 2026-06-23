Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70FFCCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 13:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5614B6B0093; Tue, 23 Jun 2026 09:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511966B0095; Tue, 23 Jun 2026 09:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428776B0096; Tue, 23 Jun 2026 09:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB366B0093
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:58:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9119A1204A5
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:58:49 +0000 (UTC)
X-FDA: 84911333178.10.8451628
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id F3E0BA0010
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:58:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XfKOJ6+D;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782223128;
	b=B7Bps0+hOgMOmPxbXjMHnGJ67ykvBFfxwu/RgGksLFGWqJyiPNYfHOV43LbPqKyzH/m6B1
	xlJhEB4aRxv/fnOZYTJ8p6WgmKgsuZWjU4KK724LL2S0DwaqkdPogUvT2k3qHQ44bhbpLr
	2yYgLyyh9D0Qk/ziXUP7g73RLxfQ5Xw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782223128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qPJB5FWFfqGea7PI1Ch17WntCkpS3wYF0Wfk6C5GHV0=;
	b=L9tUliJcAbF+QupJpwfU8nCSzMLyvFWFDXPEMbiNHsEv4G/rnIvWcoI19hDTJCqqhW1k31
	SaBAEau98b7P5UdJWcVH/dcpfjP/7d1aCOi/pc1qOddqL2e4khkBnRueuYK0rcftQ9yUVY
	Mbmn4ZDmpDMeLyF8B09puIJkPUFA9qg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XfKOJ6+D;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DCE344463;
	Tue, 23 Jun 2026 13:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637FE1F000E9;
	Tue, 23 Jun 2026 13:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782223127;
	bh=qPJB5FWFfqGea7PI1Ch17WntCkpS3wYF0Wfk6C5GHV0=;
	h=From:To:Cc:Subject:Date;
	b=XfKOJ6+DecxCNelskMTyAqIzRcKsZKS/J/idHWt196ogpNgr8yfmxTKB3WG5qk41u
	 4oNhZyKcT2ztSlGEzecagYQddoGB7qhQ4+zbvstJfIezdbx/qyNIr5s6kLpw74Ui/W
	 /R+ATITjJ1q5RD8XDtcoD5cGaplDWh/rjpQW856c2k+5e1PD0uGo0K2i8m0PwYP8qI
	 RTwnIic+YghWruvA0y+Cua8nYI5IYzR/TlosREefjUAlT3Gn4z7/62nnAAswSQ6nha
	 tH/7IQjycQ3RUrA1Uf2hNPz2k+26saBel+QBEOKKLD75Yoa2LRN7tKDeJ8NHFT6V02
	 UvpfoVk6UO/9g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] mm/damon/ops-common: handle extreme intervals in damon_hot_score()
Date: Tue, 23 Jun 2026 06:58:31 -0700
Message-ID: <20260623135834.67189-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F3E0BA0010
X-Rspam-User: 
X-Stat-Signature: cj4wq1idgfk3am53fezr65rdym6bg84d
X-HE-Tag: 1782223127-28194
X-HE-Meta: U2FsdGVkX1/ba8UIpHPkFI+PCYC9drassGSFL00GmFycKofFMbM8g1G86flfm4rR8oduZv1SjpclOxnraH1bh/E9vITZMfp5bSRmYrdAZaFW1xNb+fu6Ey+rNiCx7bW24F2pJFnp4HqfPkkYgnv0pKi7yQi2V2H/INRQ/eVTMMs1z3T5+MpQrQ4yy/KLAP/laUkxdfAtFd9+QSYzm+bgFchxWYMkEIkdApvOV8dWW2xdjTdLCKjmIlcr08O6FN2mpAbu87WbAxuSYyaSB5emvqBOU5csgfre7GY4PkHkHIXxRoaqXkeR1CIEW8MvZuPCgWr3wfiH4fYZuSNI5g6oOBSI8YLOQnz2epnndj8IahsldfHI83OI/aPGCFyYidv0wr+SVEywbswWtfIyVu0YXauMj4Q+fA5ODGpbYi49Gg3lL7KDRU/fPD8Q8HOXYq9FXEXUfejDjkDGnCD0JwBWsUZoT2A/IX93zyIKt0XzVyaCRJtuvEToJpKgFXA5knFESHk26h4emTVeyxMvND1LcTOufukGdlIaLWJoXtFUPbSwXVcLbP/Gd6W3Or4nd0u/k567WpWE8pHHrMLSuuqqloy4yOFq9L6Cr1oAnBLKzt7T9Mp0Qy7nb+cTf77ntPwy8JioVYnZ7g6Zd6TgMHSkiJJ2GwxzdRCTeJIibPieEG6j4YqLA+0BoQbc3tlAOsuA8s24AdnYxQzgsbWXeZ5HYg203lO0tRzSkeGeR3tshTEkBsqtlOTxwgSAy6ytqyf188bgw6doDqDJ72Vv5kUCtpcuBWDN2GpZuae1RFwRwmKY/8zA8sO318/+n/+OsCwtemOns+EMnHi4YcsZSYYOOZWkJABnm17SO4ng7TuRd/OsEEEWUeF+mVQx62PoAZxRhUjPBtdLcrEa8Pa56hxcJ9ml9t0/pW27OBMHVlUMnjROqg/eBK8aUEtzirOnOH831FkjBXWH8IUwYbDWBqG
 pIFp6nhi
 ajUlV9SJKIAigibybOXHbi9SSaaD2RWwZJNfoZlnb9M5MdTheub0XkmQxjdKh9C6y9NhbbZkoxDdG87xzQ1oGcDV+wkZJs0f/Jn1UygXeUgdBPakm0N80+E5e2OAloDTSeGpGOiSKwRj0UNCoMIK/OMr+gl5O/TlJkLQoFYO/5vqfco3OdJmyh5exqH6XQ6H5zvaY99BG0JphzU3jIA5Z73S4pf/DOb2GO8L/w41WmgRVA86EDps3/BQotk6RkTCe1NVixTlZvlNbw/p+dgoKm25w6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix three issues in damon_hot_score() that comes from wrong handling of
extreme (zero or too high) monitoring intervals user setup.

When the user sets sampling interval zero, damon_max_nr_accesses(),
which  is called from damon_hot_score(), causes a divide-by-zero.
Needless to say, it is a problem.

When the user sets the aggregation interval zero, the function returns
zero.  It is wrong, since the real maximum nr_acceses in the setup
should be one.  Worse yet, it can cause another divide-by-zero from its
caller, damon_hot_score(), since it uses damon_max_nr_accesses() return
value as a denominator.

When the user sets the aggregation interval very high, damon_hot_score()
could return a value out of [0, DAMOS_MAX_SCORE] range.  Since the
return value is used as an index to the regions_score_histogram array,
which is DAMOS_MAX_SCORE+1 size, it causes out of bounds array access.

The issues can be relatively easily reproduced like below.  The sysfs
write permission is required, though.

    # ./damo start --damos_action lru_prio --damos_quota_space 100M \
            --damos_quota_interval 1s
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/0/monitoring_attrs/intervals/sample_us
    # echo 0 > contexts/0/monitoring_attrs/intervals/aggr_us
    # echo commit > state
    # dmesg
    [...]
    [  131.329762] Oops: divide error: 0000 [#1] SMP NOPTI
    [...]
    [  131.336089] RIP: 0010:damon_hot_score+0x27/0xd0
    [...]

Fix the divide-by-zero intervals problems by explicitly handling the
zero intervals in damon_max_nr_accesses().  Fix the out-of-bound array
access by applying [0, DAMOS_MAX_SCORE] bounds before returning from
damon_hot_score().

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260619202459.145010-1-sj@kernel.org

Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC v1.3
- RFC v1.3: https://lore.kernel.org/20260623011652.1354-1-sj@kernel.org
- Drop RFC again.
Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260622141027.29145-1-sj@kernel.org
- Drop patch 2 and make patch 1 fixes all damon_hot_score() problems.
Changes from v1
- v1: https://lore.kernel.org/20260621154808.86431-1-sj@kernel.org
- Add out-of-bound array access bug fix as patch 2.
- Add the RFC tag again.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260620171413.89555-1-sj@kernel.org
- Wordsmith commit message.
- Drop RFC tag.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260619205144.150664-1-sj@kernel.org
- Handle zero aggr_interval case.

 include/linux/damon.h | 8 ++++++--
 mm/damon/ops-common.c | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6f7edb3590ef9..888570f55b416 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1065,9 +1065,13 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
 
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
 
 
diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 5c93ef2bb8a97..d1842e2b00ef8 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -143,6 +143,7 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 	 * Transform it to fit in [0, DAMOS_MAX_SCORE]
 	 */
 	hotness = hotness * DAMOS_MAX_SCORE / DAMON_MAX_SUBSCORE;
+	hotness = max(min(hotness, DAMOS_MAX_SCORE), 0);
 
 	return hotness;
 }

base-commit: c12377ad97c98e0bee10870abf4ab1101a946b4c
-- 
2.47.3

