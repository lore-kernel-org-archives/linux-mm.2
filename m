Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64343C982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 10:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7541B6B008C; Sun, 20 Sep 2026 06:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705036B0092; Sun, 20 Sep 2026 06:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61BB36B0093; Sun, 20 Sep 2026 06:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 414B16B008C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:00:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88996A5C83
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:00:35 +0000 (UTC)
X-FDA: 85233696030.16.2CDBDD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id EBB7F2000F
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:00:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TwfVX3I9;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789898434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNOkuOvBgpaeImx4XytamWlsHw1NNr1OL5vpKYxF3rg=;
	b=yVieroRTMuiv2BnK1gNTAZn3TiAzlmFBKVl61DbAe9FRf6FxtnVH5yEDY0wfE+uFICABxg
	TNlsmpGMPN8fs2pnpq0Gf/yrXIRLwTqt1twa2nJHpVat1SySnTXBS2TQvRwaO3zsg/9NFw
	OLFigzNEQkKxgcUHGs3CGFK/14qN+kw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789898434;
	b=PChtge0jWeET3UKxLGsndQOngj2rAIw7gl4JKIIKqK0bWGvelBF47VwQh+IQCQo/pFamOt
	2CkRVrToDFMIVty0iSOSXwRmzFBtuWnM0XluU+yWpZX6YesH1lAjWhgzVaWjAGPPFJ7Vud
	MwU4z1HboCuv48eVP5fTICH2+G6gJp4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TwfVX3I9;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B3D4601FD;
	Sun, 20 Sep 2026 10:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67AB1F000FF;
	Sun, 20 Sep 2026 10:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789898432;
	bh=eNOkuOvBgpaeImx4XytamWlsHw1NNr1OL5vpKYxF3rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TwfVX3I9FP2+Cj8IDi6JXuS9zcovsK5gEevP9S2LkyW/wd5gFw4QKgVFahXizcQjY
	 qH4BLljpWsAnohK8aOSwE+js0ywxcy+ai1wUDHEvJMlt+oNdr3FqYp+0ZMw5TPjYbi
	 AAJsz6+hfTCUiW6DHcDxu2kYQ417eL+TfLrfTTQxp9lOLpFfXomF82B0VIAANbMJNA
	 P4oOsP03EK2aVn4CpUXsw33vXDjncp1USqz9FrbGWz+39T/IdK508cpC+b+qnF8wJO
	 FbJfhNBUejmQPS95Z2oRaye0VqUvWyKk+RDojqKBipgw+BuanvfgbiBz4w9rWEryAJ
	 00B04w9Wg3DQg==
From: SJ Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] mm/damon/api: remove unused NR_DAMOS_* enumerators
Date: Sun, 20 Sep 2026 03:00:28 -0700
Message-ID: <20260920100029.46849-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260920012028.9565-1-zenghui.yu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EBB7F2000F
X-Stat-Signature: yxzcck9uhuarr891bnh8ya8a4zhm5e5z
X-Rspam-User: 
X-HE-Tag: 1789898433-233893
X-HE-Meta: U2FsdGVkX18uJRgaxgA3KUDg40r+3k/DGabt4aoWK/GLGCdDi8Bj4qvLvCx4daqG9JJAcH5yRLzEc+TEPBZxMv9sxUFy8y57WfrBvLl0NOr0LJQI9vMlb+4Fx8LeqHoWFfoIRohQkwryjl4eiifn20ZMxWa9jFtZ1fsY6W3heMjpKvBQvenA/BmaG7mHVTmNj0tIrjI0LFuwb27ANNCCZ0MkIhJaCSSUNmZgEADFVO6V3aSfp8bST/ivrs6u6iV4FYdvyefl4CCM0CShHMcoBtcjkzkoFp4IV5NdEusK7st4b0uqHWrFYFfqT8FIDa39jDM0zKoaJ+eQ8rdiZsSsdFX3aT+dII6aGSAtm+iQvdYypiKhl+vpoLetW34mmzlIb+5+3jboiX08vT6O/aWwdqEQue5FqhMYly70iE0o4vqFI54nz74Yh6DO6OZAwbH9Iz/hHILLVhycYU2RQoEn20Jwx3aherMU3jgg9T86LrTKeJoG7UQG4UiH4dCUgqRNz9Sl71A6Q1Ju0jaa4TtCwCTZlc+uRk/H3ZumOPNQBHLTOt/vAkAJVKHHL6xo8La1s49lOsg1U6Gue58D46p9rhr3U4JguZ+LjAr4VyMLUfG64dAV+Ge6Is7dfjHLajWwOGhFuzJhignfXeZ8DpjG6IoXQErO1wbicF7KoQIn38ufSH0QHaAsklv7i2BerMspcVAh6KWSKPq8ekpihWDZ9tNJv8rZCP4hYTl0zo94vhO+st5MmIt8yNbxuFOgO9AJReyvsovwtH7ITHl58xM22F3fkH1s+kkE5Q0Kya4RzNPN5HNC5sRSuw2EIIiCHf/aHiKr0LIH0QF9tiSn6Hho5rgVxCXnUdedFjojupRxG+ov3yfvlfRmoHC99zz3LE6Oe//e9MmCHddEAsYUEaiy0SemMQNRi3rc3ERTezi8NXjrkQRuialtdOeiz5pG1qcJZEFE6lh7zg78IyPRt79
 0p48Eeh/
 sI34P65Vy6D+sl4x7LRAlJNRhfRvTYz6WgKvvSbdwAkquBZXl6ACJSMZ61Y9xoBspVcOh3Gzz7e0cAT832O1455XB+lMcPvRD481wvB20N2Ay1QfOxqyCJvNdt5adaxhwD5C4V3yomAVkKTkqW2aCGQ2sJ0z/RkCog+Ir7zsE2hDk53XgqfT9GVme9TVFWqetHRPZcbGV0DeTs0/0K5YsoFmJuaWfzC6oWtzsXRUmWfOoCyegUTREoz4uU1J6miI0/pBa5NHnvTQs0V+EtGwbTdpphZJAexmnKG/oWCaKZmWdntLYqTjN7P7gNWbxPZtSnZvW8PghhGqW+zbsGRSH8bAjuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 20 Sep 2026 09:20:28 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> NR_DAMOS_ACTIONS, NR_DAMOS_QUOTA_GOAL_METRICS, and NR_DAMOS_WMARK_METRICS

More than 72 columns.

> are not referenced by any code.  Remove them.
> 
> They can be reintroduced if a real user comes up.
> 
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Other than the above too trivial thing,

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree with the fix of the trivial commit
message length issue.  If this patch is not added to mm.git in short term
(~1 week?) with the fix, I will ask mm.git maintainer (Andrew Morton) to pick
this.  So, no action from your side is needed for now.  If it seems I also
forgot doing that or you cannot wait for my action, please feel free to ping me
or Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

