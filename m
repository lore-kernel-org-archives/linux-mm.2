Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 192AEC5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011116B008C; Tue, 11 Aug 2026 09:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C046B0092; Tue, 11 Aug 2026 09:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1C9E6B0093; Tue, 11 Aug 2026 09:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BEB436B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:46:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 427B94042A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:46:44 +0000 (UTC)
X-FDA: 85089113928.30.62261A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 93F614000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:46:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XX9PVhp0;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786456002;
	b=ElKAHZsz1/XE905HXHQoVZQqjg6D5IY8Dgo6ZeSGVNnalkuzxI/jgqQ7uAm6rUeb3ARBhz
	R5nrJpWQsvbUfTsdAYQ2G2DIuKl42Nj9Mn4yMUx8LBvEjmqZUd8N6ovFbC+ierKNzkev93
	4IPH2GDVEB3/8thY+zfpPhfdtvo3GJ8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XX9PVhp0;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786456002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GtL11n8OdaWgBaMEgmB3HonaWO11FGXgueUh8Z6UWVs=;
	b=halgkAX1EB6FX6EO5H8t5nGEPfsxGubT3y+3OEH7WmGy05zm9a0SAcHePGzuYWkLVxZfEC
	ezSI2sXGEvs+68t3He7vhnxZBfo9roSumvE4VCTQhyS0g33Pi3rji/5L/wNUhI+X5AV2NM
	BuUo/M/sOPvR1G/xWK5rOCXxXHx1CaE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC4F442D9B;
	Tue, 11 Aug 2026 13:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8411F01559;
	Tue, 11 Aug 2026 13:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786456001;
	bh=GtL11n8OdaWgBaMEgmB3HonaWO11FGXgueUh8Z6UWVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XX9PVhp0hYtWXxPGD+TlKqjokKHxQd1egfWfY1SRsjmI3Au38K5m3PeG0ORWS0uOJ
	 S/6Vd03u2cn64RrNKAQu0t96T936JCkDfP3RAU2qpMhp7joNB7yuXoLFOODyn3YTyt
	 M7nfkLrGGn/wnifof+GRy1cLyL5TUrzqR1MbrhOyo3vGcl0+pWMS7Ey8e7Qzo4qamk
	 /X88RhP5Fm6GXyhKe+30DRKrYOdE442v+k3guoXMi591K4QSZdY5t/8TaazcrabBG5
	 aXNBxFbBkqB8dDOZyKjCuFH/q9yMX6dW1l0NHWWuFT1epn9RxIVsupeplPlcyaFJSn
	 kHAFSN9VshsfQ==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/3] docs/mm/damon/design: accurate semantics of nr_snapshots
Date: Tue, 11 Aug 2026 06:46:33 -0700
Message-ID: <20260811134634.4407-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260811101841.804596-2-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 93F614000D
X-Stat-Signature: 83bca5ia5jubbp6d9rizrwh7tumxesyq
X-Rspam-User: 
X-HE-Tag: 1786456002-137813
X-HE-Meta: U2FsdGVkX1/1ScXbJFWnNafnIxwrnJURJpIVTfS9B/6xgaRGIh6kU6Slq3e+U0srwaqme9kY7n+5PZ+AXuRV6w237RdcAT9kvSuKgtkmPgOp65/iWZJMzfiwevI56PBM685uBDTWkKOeK/TuUNgAFd63yDoSFOA/vzHJwWK1a+PrSFZhDy7txOe6Zwdu9eKGoGjqTZgRdb1sC1EsJBFpluKiqS+K74ZItWVCT+Y4moifiy7J+kFVnxWszoGtG60RTaiEh5g/3Fv5zBAQ6cQ5D7JHzsGN1caV+1YJaARE4PalSLBSJCsszzNbyvUmE9qSD1CDR4iaYnA7ZrBintSHRLSdAiF0oLz99cPYiQD1dIZmfpDxPJsi0AS+IZ3spQZ1Egi/4mdRyxtRXdo6yb+u5ozdNhyB3RuynSD48b4NFwtvXaKU7mNjdknhG7gevml80HOzJuhbonX3pqI9bsrzdJ501JLA6TfeYFj4yUXKREc5vVHZt10Y1I4jVbJICe8wuSthmtYcbnI1XPHg2/UE3cL4lvFXpU2eoydImhuLnFIfYOc/i3TolKRY1tU6uNB7aCwnR2nX5bp3wnIokcb3FwZSMlok7RKSvtmouBeFsiID4dNOoc06qooGKYAoyCiv3g1U4hNGrAF3HEydWo4ZqKrDzZ16N15sVEoz77JRV5a71N/Ix5bBloVBcek4JODn21+g8hcqzvDBebHgfhxkkxGufDcouD3Mb8m6pxxfKDE/I2wadclRykIIDR6B7O/UTa8axqTpKd8ZH5aDErwGI+Lsj0TaUMFW6CJ2QxXOPJE1GiTx/NeCunDUrAirhps43QDD35a87MF5vx6IWrCnfW6/dwnbj7SxDXq1TqVoR+MZWl5UhQKxV7y3ErJbN/ihBOq5OBlTFVbkVDi7gdIfsAS58HcwRi9L818I/sSNH4Zdt0JJZ/oJU7TTCkfg8Wpbhb5OmHZ7qCRL0k8RS3r
 UkTZpOUC
 lpDSbOZmmzx9f9ntYmd1O9SM7G5MPGhQKdGn6wDs6FWObsiFIk78qblasu7IA3ZKWVLXbJGrg3LNLyi7VB7zpCz/1GsIyZNls2+HnCXroOkY2NpXytPRV7Y9yjRZUePHkMaUV4dg842Nw3Khrms5njoEVZ4dJKasVSD5rtYPpUdyuovoPyaBI7aW3rTxGYdU7wxzk+9UlNHqdxe0dhEMAR8ZZf2zmAtbUmkB1InB2eTXKCWIqKkqHEacc7/KB7apjGxAym50Tg75oRJ+hQHBzTnY87Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 18:18:39 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Change "tried to be applied" -> "tried to be completely applied" to
> maintain consistency between the documentation and the code.

It feels bit confusing to me.  The completion in this context is for "trial",
not "application".  For example, someone might wrongly think the number could
be incremented even if a scheme was "tried" to be completely "applied" to the
snapshot, but failed due to a quota.

What about "completely tried to be applied"?

> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
>  Documentation/mm/damon/design.rst | 2 +-
>  include/linux/damon.h             | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index aed6cb1cf483..939298f2a9b9 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -847,7 +847,7 @@ scheme's execution.
>  - ``sz_applied``: Total size of regions that the scheme is applied.
>  - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
>  - ``nr_snapshots``: Total number of DAMON snapshots that the scheme is tried to
> -  be applied.
> +  be completely applied.
>  - ``max_nr_snapshots``: Upper limit of ``nr_snapshots``.
>  
>  "A scheme is tried to be applied to a region" means DAMOS core logic determined
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 0c8b7ddef9ab..d642ce4fc83c 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -357,7 +357,8 @@ struct damos_watermarks {
>   *		Total bytes that passed ops layer-handled DAMOS filters.
>   * @qt_exceeds: Total number of times the quota of the scheme has exceeded.
>   * @nr_snapshots:
> - *		Total number of DAMON snapshots that the scheme has tried.
> + *		Total number of DAMON snapshots that the scheme is tried to be
> + *		completely applied.
>   *
>   * "Tried an action to a region" in this context means the DAMOS core logic
>   * determined the region as eligible to apply the action.  The access pattern
> -- 
> 2.55.0


Thanks,
SJ

