Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB23606A897
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aeu8DGrK
Received: by kanga.kvack.org (Postfix)
	id E15EF6B05B7; Mon, 16 Nov 2026 10:28:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEDAC6B05B8; Mon, 16 Nov 2026 10:28:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D03FF6B05B9; Mon, 16 Nov 2026 10:28:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A62CB6B05B7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:28:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9823840154
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:28:52 +0000 (UTC)
X-FDA: 85441364904.15.F961014
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 00EB218000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:28:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeu8DGrK;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794842931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xAnuCAiuWX4/keedDsQNjuLhi8WyX14EAVs42DysHA=;
	b=pxHXPAf1+K8RjrgXTBR0yw8OmUWhSuoqNoxCq44usmF3RDsbD/nrtkXSfgDJpzt68vgTLE
	ClIP/NBSVgtvTtxyWC3iRxh4h3sDPJTWHhU7H7+JYoluorRc60Za79DOuHQm4Me0Dq400V
	Uo2FGlndrLykVydEP9zK9luuPphxtFs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aeu8DGrK;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794842931;
	b=tktA9Bk0mJA5GubIm5V7hvOKrZow+MnaaS/F6DOpUQ7G0N9LK7UdFWj99TSNE32JCBhl0f
	NDCX/B65NTFgxEJxySk1A9hJlywOvoRBtKqtGUmAr0u6tpdrLkxBlIvluAtEHIaU4oO3jP
	46onEtN1/pZg/flmzJwj6hNUfLTnWTk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2985A62CC4;
	Mon, 16 Nov 2026 15:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A7D1F000C6;
	Mon, 16 Nov 2026 15:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794842929;
	bh=4xAnuCAiuWX4/keedDsQNjuLhi8WyX14EAVs42DysHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeu8DGrK7dOcH+25xyUfDQcUxpXG3VsMt7G/OtfmB+zqydYBhQRnyIUQZe9NDc8WI
	 0/noo+Rhb1OqjXKQ/ye7foi+ZqBLS5PecEbjpgYoIx9wR3fgWGPgLrnJ72QhYx6CQ6
	 p1h6NzlPYGEn7zp2M7o4imdmj7bdzv7+/jvTU74pcez4yQrUvdSpn8mMGx3Cv4QtLr
	 xJYGDUmGbcrrVy0X3yQMVdvAgzx7hQTsoYvNpVk2+iMg7nnCgClNpwMnUPFlFdBLPc
	 Y7J5GVmgiOJCdAfX7HVypUgxOTdjB5aZ6RArEcdLBM0LC0re1XbCwg9nJjBgcR0W9M
	 PtEOMv1LfrcrQ==
From: SJ Park <sj@kernel.org>
To: Jason Angelov <jasonangelov@ucla.edu>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] mm/damon/tests: add KUnit coverage for age_ms filters
Date: Mon, 16 Nov 2026 07:28:42 -0800
Message-ID: <20261116152842.97789-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116-test-age-ms-filter-v2-0-3b265d59ec98@ucla.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 00EB218000E
X-Stat-Signature: 3dqpmmis6hgrnafmyqriorqij3qfm41i
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794842930-854650
X-HE-Meta: U2FsdGVkX19QUqxnFeM7iucn9E5cTk24Gvm+MiJD03LkRARTKyXRKjZcgzjlQbFnqrgQo49TzlPzxm52cf6p3OzmpaUlJPxq7vpikIw5DIzd87HGTzp9/Bbm15D/bT5aJ4KZAPW+Jdp2iHlDtDUxfcL9hjgAfzZbyFwRLEc7RiWOpoA5sar35iA34hnsoDI+GwxjmMUCvyagr1lWVoM6cr4rpACP18O+AinaZq2RcSgOmws6k0rE7fqS04cqC5MgV6u5xnvktSzcPKJ/u/kl6QQwWHVhTa9KQyR9eBO34kl3+5sh3br2DqBbzJLsOy+grLMaIAyJR6kxX7VO1+QXPY4ddQG4ppWJVKA1QmsVGFcpRJlq2P0yxtBorWEbjo7y8fN3RgtaoVMOVgZ9SeuKa33JIT6UWcMC9/W+GMODzB+DL/EaMaaEIbDDGrwHbHeZiSMC5V/UxyCjcIVoJvcKHsysVP6XKterwRGFvayACo3XidNioJ9P3TGF1vDRT4YVDHtzDEp7hEvpI4jqE1gzC3MXn50g1uG58Gc6I6OG/H/ycTeWUE1XUIMHycWU2+AEt3gKn4QFqbOU5RmbU4dS5RAoNtoW5jaLV7eOeDU0SGN9+nck290d6wO7Imcb7JYh4cotoP6VIrIF8CZX7RREdtZIBWwUYvaO5im1CpTHQ+owNFPzxLFnGV9Pew4ny650ChaBMXt6TpTZrPslhNMm8qir3+TamEvoWNzEMQrd2D7Fr6srAd9Ne0TYuTum9jN3PMCF/6m45GpRJRzI1dCqc8Hm+wOEekL9aYUp8tSXBFrMPDU24pkNNH+/H0sPs/D5dITy/5OJAZ1lVprmGVzKv4yCAv8riLH8Uv6jWx2ckOIfuPZDVb3TqsGtPcXKSGbdx4/IzW6YtFJczBSqlAyvBwiumlMM/kvQiP9YA1EmNPXiofKNRRFLdM3SfdS6IFdMKh6BTywgW3PcNtTx7nl
 zllR/fBD
 ckoJqucG0+7FeLciGJW6cPsVYgjxjkHWBZF9TDbmuq9yu44AHqKgp6u8aRoToxI9Apla3nIGxnE52VkYFt4wUdj2WcJ1gEETsR+f6ThvTJm3mM3yVWQM9YKaRcbThgavTC3C4D4clz3m5+NuVMoI1yGQeYfNhOb57vohsUNV6ylk3CClYdaI6EofjQtkCqWDAzgpyhd3FZ+wXKF1vRXZzSSKsKnoZu5XFD9ijihYpA0K+g+hLiqb9FnPlr/FSalK+NbMjtTNR3u3hrl88AeII75GG3RRk4m0QS3Dgyh8f5r90sR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Jason,

On Mon, 16 Nov 2026 03:06:20 -0800 Jason Angelov <jasonangelov@ucla.edu> wrote:

> The DAMON core tests do not cover DAMOS_FILTER_TYPE_AGE_MS. Add tests for
> committing valid and invalid age ranges, identifying the filter as
> core-handled, and matching ages at and outside the range boundaries.
> 
> Region age is counted in aggregation intervals, but age_ms filter bounds
> are in milliseconds. The interval-change test checks filter matching
> after both increasing and decreasing the aggregation interval.
> 
> Signed-off-by: Jason Angelov <jasonangelov@ucla.edu>
> ---
> Changes in v2:
> - Fix commit-message formatting, line wrapping, and comments.
> - Set age and interval inputs directly in patch 3.
> - Add SJ's Reviewed-by tags to patches 1 and 2.
> - Link to v1: https://lore.kernel.org/r/20261113-test-age-ms-filter-v1-0-b99eab2f71bb@ucla.edu

From next time, please reply to comments on previous version and share plan to
the post next revision, before posting the next revision.

> 
> ---
> Jason Angelov (3):
>       mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_test_commit_filter()
>       mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in damos_filter_for_ops()
>       mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS interval changes

All patches look good to me, thank you for this patch series, Jason.

This series is applied to damon/next [1] tree.  I will repost it soon (~1 week)
as an mm.git merge request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

