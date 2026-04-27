Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E53AFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7D936B008C; Mon, 27 Apr 2026 11:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2E416B0093; Mon, 27 Apr 2026 11:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6AB66B0096; Mon, 27 Apr 2026 11:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96E926B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:16:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78E691404A4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:10:03 +0000 (UTC)
X-FDA: 84704671086.16.8B0942E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C183B100016
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:10:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nyy0b6B9;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTDqitPncsYga4gZ1RdvpupgT9kVaaswhltFfeDniiQ=;
	b=UHDrwsBxXxNcAVs9k1/0iTWASUjw9IOIbDkCdT0MvS9EDbM5NKNkTzP9lxbROzqpN6vnNd
	4pNdbzuxTdvr97+lxzAEtNrbnG77oNwuSjz0ZbUGzEWHHTPdF2R7PHh6Ir+aG2moBiAa9h
	62ClpfQU82HmA2U0H9nujYOaxB3+NRw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302601; a=rsa-sha256;
	cv=none;
	b=mHlAWZjnurmncKfwKlkT+qt2JTbz9aMMQ1eS3ySuF79W2HI+yNtKR83hiMXOX+d7lQhwwG
	LC4H3+go7BjrMWaLiQm3yU9cwOnCTSF7H57f4PNUrjye4Uv8hGcP38HNBQ71Yizb3jNyMg
	ePwOQNMnLOZmGRPO9pBk8hEvvBpSdDQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nyy0b6B9;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 044E960126;
	Mon, 27 Apr 2026 15:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78193C19425;
	Mon, 27 Apr 2026 15:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777302600;
	bh=D3bN09nuD0jE5rvlzrltFtSzKt2ZOU/RkqRJSMh1fBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyy0b6B9VE/dfGuew3dmPZtuzjUfaVeza2re4ZfVt33Oo2kBsgR7UQ+bpAfGTKxs8
	 K8qOtDgeJVmUBEy+xvqt8im4BrW8YcERDFCgCyFnrFZ9w0RjP+ykTnY4g3r1R8PDJf
	 pQ3pEvlP/hD3el2phaSsXfoyTf1rkBzMmC7iZ4xBx3Yoxbwzf9fbsW4UuOv/k97WHF
	 4f1TBnd1crDamBOoN0vaLN8iNOaY7PrvVfOmDuLW1+I/pP+4jM/ST/ZGhZgTfUL52X
	 RvXvV911e58lxaNCRfBFJdHgWEvND1y7SMbJ76Un/LYD3aUlGqXynnQ8BHlXEX7bYt
	 V4ixAnzZ9AqGA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/4] mm/damon/ops-common: optimize damon_hot_score() using ilog2()
Date: Mon, 27 Apr 2026 08:09:57 -0700
Message-ID: <20260427150958.113205-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426231619.107231-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C183B100016
X-Stat-Signature: dwdk3tmo1uc5qjhg1o7mznbzb8h64yss
X-Rspam-User: 
X-HE-Tag: 1777302601-496054
X-HE-Meta: U2FsdGVkX19J7A0hNq8Y9qLzcpLjoWFC/5bmYOGmghkk/swzW3gQu5jIJqiVxyDhXWNWj1uaYXkEgzhPuZ1vH37AQgAwXmkyup8wTMSqhIucm34wF8p6U1/9R8qFp60TbMm3gfmvwhvkmgBhqY+wR/sAarW4RR+6oDAAHaWO/CfTGRnFZMtvNxVlVrT1DIpSsbrCXjm11nwnfUIdrLRDXxI2WyvpWfCtJM/UI5b9M6cKQqABeuz7uKP79byV1WFD8+n6YoMKb1hyKt76zaKnM1c4Bgb08Dn2+EItQiUz4jeUCUEMURivteI+vnvmR1fbjb9+0EaX42NTk9x+KD374WNhiGtHV91iF1Vd60rOOE71Q15MQXWerrGCsVE1MzXHyhBLKOFmc4QL2/pAJgTezuIm9ljtDIRl20wjlNppRvyfYXoE4EjSDoFD/Qu2x8CD2rvgghuz3KyasPB41hyI29YoW45up+Z5sQrdm5tU5CR/Tmxjovn6OkH9/afvFZ979XUW8hbNsQprsL0tNL8iDmEye0CfBH/jsg/I1FLPJRZnH0pKVg1NxnLcNprfsKNcZ/aGuHsWb9Afcugdc11Unzs8oo1q7fYvMZiT5jukcKxuPfrJtefT/qEosq4miOqSBadPdbStjNbNXWWdS25uo0SmXf7fauvJEQG769z0b1rDRKZVUwxwBZDWZ5Rmlv/JAPRN6QEWDnbOJpvzQs4fPheOPu66DikqNIlMtCH6elO9yn6ObpWNGqJOLF+HB6+jq/kq06AVGL+PQBlgYXVile0sTf3rcpEAGz1hfpLoOuTBH3nefdQ7ndPgZzSimBQ/uFqSLQP6zPQfohkVvl7Ng7nuypCIJZBWu2tRapM7gHfEprpqGIiR/PlE026jRyHqMIeX1JnDe7JhM5p4wnoSQju9xuq9wH5taQxnc4m/hIdanHi5h94/x1YlZ9QEhRMIKqgGSqnmPIGzn0dnlHB
 TMSEuYM5
 bnE1BnQWyHvOoBmtIJaVpyukU94mL9vpcwKKdB4zhKcQvaW45qewaA1pcTx32crKJ7mhQytZuFWZOT936VmsWhSWYUmfMs9XC2x56pw5XALlW8P4YEC+ulAx1nF4IorEFs4pdP9nzBGEtiRzeBXigru1cMn8Jxi2YnQSJILJxwVf/mlztSmabhCpVKXrOgmqQCfTgM2lbdJXKW5NzHrBtgt4w7QXdvbjmJefC92RRJNjrJKeu3J8RFhfp3TatsdWztZb7lDDFjLmFQ2tJh4tS+vrvpjuCIY8VSdd0zxaUWDuC/+I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 16:16:14 -0700 SeongJae Park <sj@kernel.org> wrote:

> From: Liew Rui Yan <aethernet65535@gmail.com>
[...]
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -117,9 +117,12 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
>  		damon_max_nr_accesses(&c->attrs);
>  
>  	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
> -	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
> -			age_in_log++, age_in_sec >>= 1)
> -		;
> +	if (age_in_sec)
> +		age_in_log = min_t(int, ilog2(age_in_sec) + 1,
> +				DAMON_MAX_AGE_IN_LOG);
> +	else
> +		age_in_log = 0;
> +
>  
>  	/* If frequency is 0, higher age means it's colder */
>  	if (freq_subscore == 0)

Sashiko found this patch is introducing two blank lines.  Andrew, I saw you
already added this to mm-new.  Could you please add below attaching fixup?  If
you prefer reposting this patch, please let me know.


Thanks,
SJ

[...]
=== >8 ===
From 1d97945a7c35463d3757df985cf3545bf9d5ed9c Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Mon, 27 Apr 2026 08:05:09 -0700
Subject: [PATCH] mm/damon/ops-common: (fixup) remove unnecessary blank line

Two blank lines are unnecessary.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260426232811.618BFC2BCAF@smtp.kernel.org

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 3a0ddc3ac7196..b2ce817f33c53 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -123,7 +123,6 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 	else
 		age_in_log = 0;
 
-
 	/* If frequency is 0, higher age means it's colder */
 	if (freq_subscore == 0)
 		age_in_log *= -1;
-- 
2.47.3



