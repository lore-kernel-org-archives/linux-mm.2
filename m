Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E94BBC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C546B013A; Thu,  2 Jul 2026 20:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC7F6B013C; Thu,  2 Jul 2026 20:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A2C6B013D; Thu,  2 Jul 2026 20:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 866AC6B013A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:49:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80102140294
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:01:03 +0000 (UTC)
X-FDA: 84944905206.21.9AD951E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E98C080009
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:01:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyAFRhvl;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783022462;
	b=zd2whGcfXcWCrCww/mItaBX9y+XscmFMmdNdPQKA3N9ksIq08v9Q2ZmHNLRQ/7fhre7oMQ
	wA1dr2EfCFooerCUJPqqsE5Zae7nYdpj5w9mf2lj4tDfCpjKGbHy0U0cQfAdQ3TWFbcFXj
	leBcDEbf6uPByRnb9y/8z7fcxQFLLyw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783022461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s1O7yxhZA4uvwDJ7tfSidpqHooCz3PzvrPr8bHBzeY4=;
	b=Onc3PuVhqmikHDurgk2IWVCzIjmOpB44FqT7S0QxJ6G+ZlLQuw8w5ukxLFNrOcAYNkHGi/
	C50r0IrG/jfas3KV98FDRBbZiWPj9bJNaPscfzqSksj+BI5irmYst50Rb8buToH3huvlOd
	6OZYsWN9qVpFIqHsnrj7lBmXFaiNPrQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyAFRhvl;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 316DD601CC;
	Thu,  2 Jul 2026 20:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483FE1F000E9;
	Thu,  2 Jul 2026 20:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022460;
	bh=s1O7yxhZA4uvwDJ7tfSidpqHooCz3PzvrPr8bHBzeY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SyAFRhvlIwWuXxtyW+DsYxsCGfICLywCNwisc9/R05DvJtWpdXfO+V6YaT9UJRYS5
	 7yqczLFVhUoBa3jiKUac4MKkaeZf2UzyH8UGuiY6lH4K7GojUiUjy52dxu2T58nvUv
	 F29DoDuvn9S0r+/qz6nm46ufYGH4dVO2Rh1Bgnb/wOCU8US+ZbyyaEYxUl3KSW3UmI
	 pw1ldkWPvsljqcBZZC0J3dnyowVHxs9de1m61hnMxMTbcuV/P8WLw8TjWCl/3c/Nu3
	 LOJSd/23nPnoB6lKTFsxrkKyWp/djcFqpEZmQ2cg3+4P3FYEd/kGlCqYkP3hnrkX/t
	 lCsfBmpVPRnuw==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	daichaobing@sangfor.com.cn,
	kunwu.chan@gmail.com
Subject: Re: [RESEND RFC PATCH v2 4/5] mm/damon: introduce DAMOS_SPLIT action
Date: Thu,  2 Jul 2026 13:00:44 -0700
Message-ID: <20260702200045.92126-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702094633.75658-5-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: u65urn7dc7zoi6u6aqaopzdrji1cszsm
X-Rspamd-Queue-Id: E98C080009
X-HE-Tag: 1783022461-198135
X-HE-Meta: U2FsdGVkX19v/WjLjLBWhjHz3iDspZY15QDxiy3PB5Qzn0fIRpWyj64wKJHdnBula7GRn4dNF4VgD7QNjOAy0WYLJHutR/zE73mbe0JtRMLFul0IkyBjvDkBI+tPxCfpLSbjPz5t27GPSXS9JbSrDF86fmimc/NTclWYoEPLa9pIqkAzMKoym+EGP/1hHypR4pguE9RivI3jlldUioLi/ULAvZc9CxrJVWP3SVNbvO8FEkYnl+bkHoAzvyRp3saZmpAtoJQ9MYJ2H3eJg5D/TrZ/seaUFh5v4IAItOhTkpTuynuMXAicMQveB4kAzws4ry+XlxKZG5GlNM5pfrsabaweX++hft0KBgeziNpwPtTNmFP1TTdqJ3pFvLhuWv3M836ir6y0GuLNDbhr2NkikrVg49ZiA0OOyQrADufHp1V8wWoC1PEFvbFe1ufN48UJRru7Xet4alvw45zQc2RWagd13sL3+XaeOtM1VjObATV2REBfn28nu0jxYuhJm90JiDGNVPtlk7tpypK4flbd4lYpyuAqZ97Hmw2UH0bHL+ale6mpQXaMpQrlqzHNoAxcRqWv19FgTvg8e+s6Wvg5fFtMa3w44UbntOJ8SplZ9Bf/GSTDq0whvrEgUjBXyvlM8jk3k6XYJ8hSQCNo97xINwPCqhHqps+1b+lVoNk0J16q0hZ95nDwLEWPfjJltRZBFMw+rUklnvUSNalKyzjrUUxI2qUnzErAaO1g6kGVMboagHILqCIeNMR2pWdLfnlXzIrlxMrDEwlrQIQVA+mJWVKBvWoNf5R4CAFUKbT7jR7ls+OPuJz6aLUl43ahJL/5imVWvY/nd5B2Isl2XK3kGtqiym1Tmzb3NrJ3jHD0CgPpoOYFvi6hHaXey5bJJY6Ouwh0nvQnCarBALy6b6W8qZvCNwb8pnTX2jhe7reIgXdkOb7hM/NRf7Co3X++9P2fy6D2hNyPMAiYvrEUyg+
 zB2S15eA
 T4Pw0nl4CcAmmmP9d9bPkPAnH9bO0J8V2+F+Z1aSOxxTFamQynH1/AePocSttfN/0L0Kw9Ic+RVVCD7nNIIpwYqDpHF6lcEZOXyYfnaEtlyY6vEnAhgkRwpxIAbnCmLA70gwfHJL3Y2hGvGOqfWNN3RnBNjQo/8Mf69c8fEk9ilbc+w9QnHIsRZH4U0RAH2quz291nQNYBs+FMYM6Vma2beaiot0vW0JvCVi/eO7jMecLb7pg7WiL1E9fijNF9AT9Zvj7Pr6/4a9XHaA20xIqLkrLWsjpbEM2x18ESi3IAE07n4Pw1wLHkToY12vzCwGCCIYSQYxUHrpWDt7pjg/Z0Hd/D5fYnYJx3GFngwX7N93wv6XP1frQiPN2tFu3dfjX5eO3ZcgAST3geL/gWwCe+vHDU4R2nkt9v8HyiT4LS8uEiDxU+YCznBW1qa2NOk3XrRzjRFJ46/dX3og=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 17:46:32 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> Add DAMOS_SPLIT to the damos_action enum for splitting large folios
> into smaller mTHP-order folios.  Add a target_order field to struct
> damos to specify the desired split order.

This commit is not adding but reusing the field.

> 
> Expose the action as "split" through the DAMON sysfs interface with
> target_order validation (must be 2..HPAGE_PMD_ORDER-1).
> 
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Lian Wang <lianux.wang@processmission.com>

Let's have only one S-o-b: line if there is no reason to have two.

> ---
>  include/linux/damon.h    |  9 +++++++--
>  mm/damon/sysfs-schemes.c | 16 ++++++++++++++++
>  2 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 5a0587556573..30cf4afb212c 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -121,6 +121,7 @@ struct damon_target {
>   * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
>   * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
>   * @DAMOS_COLLAPSE:	Call ``madvise()`` for the region with MADV_COLLAPSE.
> + * @DAMOS_SPLIT:	Split large folios to the target mTHP order.
>   * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
>   * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
>   * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
> @@ -141,6 +142,7 @@ enum damos_action {
>  	DAMOS_HUGEPAGE,
>  	DAMOS_NOHUGEPAGE,
>  	DAMOS_COLLAPSE,
> +	DAMOS_SPLIT,
>  	DAMOS_LRU_PRIO,
>  	DAMOS_LRU_DEPRIO,
>  	DAMOS_MIGRATE_HOT,
> @@ -573,8 +575,11 @@ struct damos {
>  	struct damos_access_pattern pattern;
>  	enum damos_action action;
>  	/*
> -	 * @target_order: target order for mTHP actions (DAMOS_COLLAPSE).
> -	 * 0 means system default (PMD order).  Valid: 0, 2..HPAGE_PMD_ORDER.
> +	 * @target_order: target mTHP order for DAMOS_COLLAPSE and
> +	 * DAMOS_SPLIT.  For COLLAPSE, 0 means PMD order default,
> +	 * valid values: 0, 2..HPAGE_PMD_ORDER.  For SPLIT,
> +	 * valid values: 2..HPAGE_PMD_ORDER-1; 0 and HPAGE_PMD_ORDER
> +	 * are rejected at scheme creation time (defaulting to 2).
>  	 */
>  	unsigned int target_order;

As I commented to an earlier patch, let's use the union.

>  	unsigned long apply_interval_us;
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 7dcd582ded86..84a4617ca3d3 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -2293,6 +2293,10 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
>  		.action = DAMOS_COLLAPSE,
>  		.name = "collapse",
>  	},
> +	{
> +		.action = DAMOS_SPLIT,
> +		.name = "split",
> +	},
>  	{
>  		.action = DAMOS_LRU_PRIO,
>  		.name = "lru_prio",
> @@ -3058,11 +3062,23 @@ static struct damos *damon_sysfs_mk_scheme(
>  			HPAGE_PMD_ORDER, HPAGE_PMD_ORDER);
>  		target_order = 0;
>  	}
> +	if (sysfs_scheme->action == DAMOS_SPLIT &&
> +	    (target_order == 0 ||
> +	     target_order >= HPAGE_PMD_ORDER)) {
> +		pr_warn("DAMON split: target_order %u invalid, need 2..%u. Defaulting to 2.\n",
> +			target_order,
> +			HPAGE_PMD_ORDER - 1);
> +		target_order = 2;
> +	}

As I also commented to an earlier patch, this validation will eventually
dropped.

>  #else
>  	if (sysfs_scheme->action == DAMOS_COLLAPSE && target_order != 0) {
>  		pr_warn("DAMON collapse: target_order not supported without THP. Use 0.\n");
>  		target_order = 0;
>  	}
> +	if (sysfs_scheme->action == DAMOS_SPLIT) {
> +		pr_warn("DAMON split: not supported without THP.\n");
> +		target_order = 2;

Why set target_order here?

> +	}
>  #endif
>  	scheme->target_order = target_order;


Thanks,
SJ

