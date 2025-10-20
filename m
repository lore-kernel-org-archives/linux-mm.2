Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CEA3CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A4C8E0013; Mon, 20 Oct 2025 11:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62508E0002; Mon, 20 Oct 2025 11:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F648E0013; Mon, 20 Oct 2025 11:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 897DE8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:13:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 363791399F8
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:13:21 +0000 (UTC)
X-FDA: 84018836202.04.AE266BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8242AC0009
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:13:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIIIdDA9;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760973199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+B6RLSi7upe17nU/JwJyfBsdnsuSDAx2ZffC+5tLy/I=;
	b=rxYMm8+zRn4seaJpdlq0KinA4v02hjsd3gMc0S6vVBkDXySKpHrNYPZG5Hf/20d+q87nNI
	CUZnfK1pOo4AEF7f5kC3NVmfZhWtcMOha50lo4FlGJviAb2stPDNfkWVETx8GND9Cyq8RW
	Gwa1XVOn00W0jce+nmGhqi6NCFSHnI0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760973199; a=rsa-sha256;
	cv=none;
	b=zYYn/OFVsOx5ikiscuJqHMxKOPT4PWtVkmv+uUtsfXp2f9nY5QKipWBKjSqYGZXF5/Nv3a
	UT8ikDEVsnxXcZwfzUvKnMLQ0Oz6J4a1LsckrAhe9TXtbyND2Aovvz0laZxMeOQZz3iC7r
	PJcaJuUzZNM1DVBMAlYFnFICToO5E2s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIIIdDA9;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AEE0441DE;
	Mon, 20 Oct 2025 15:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC74EC4CEF9;
	Mon, 20 Oct 2025 15:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760973198;
	bh=YqHSvPd7oXvJfa97f+UihKrYm4qSWMBIKneomnSlbWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIIIdDA9KQzEaz89j2hXJTZ67sI6wWiDy25wwwN0tp292Bec6F1OmUqRdYJBICquf
	 GG1TmYy+LJdEP622X97TR3SCiL7iwhZYL9Oj40dzQgc+ZJS+c2VWv/RcAyVYThvRx1
	 mVhSRu2avHN+FrR5uDg+XP6VsyrQym7sk7YKl2U8Jo3WnUlFGNfHeDNyeM4Ld6ZDxN
	 Yc86V8EjMKY8agrMd2hJoJ9lUBE+HbDaStx59927+wNEWcyouoK3DcCa9rQknxGcul
	 2vh5gbckgtelfWEPj+bFaYQR8ku0LTZsCg+jOowA9Wvrz6DsNS863lq0NeK2KFbEqN
	 oVQ+8q/9v/tow==
From: SeongJae Park <sj@kernel.org>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev (open list:DAMON),
	linux-mm@kvack.org (open list:DAMON),
	linux-kernel@vger.kernel.org (open list),
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com
Subject: Re: [PATCH] mm/damon/sysfs-schemes: Validate nid usage in nid_show()
Date: Mon, 20 Oct 2025 08:13:15 -0700
Message-ID: <20251020151315.66260-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251020112824.144391-1-swarajgaikwad1925@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: ue3yki8whn33m8a6z1xghgkis6p76r5o
X-Rspam-User: 
X-Rspamd-Queue-Id: 8242AC0009
X-HE-Tag: 1760973199-568586
X-HE-Meta: U2FsdGVkX181vum8qRqyFo1bb4uKb18gno/yL102r39BeOZW/05ueG/nKqy3wqA9JKgcHlcHCtKBAgPIjOa6omF2TxSFcEjUWLbsfU5a8R0y4pnz8d4Z/mQF52qyhyXHnT5droOnDXxz2hAvYTvRKM3Ykkg8yBBok1D4wgGldr6ZGaIn1/oncGOGbrlVMuZdzuR+HlSyKda9jR7d61JZV5I2FjwFoZYZo1d78VqjCB35i5+Sqz6vq6BYnsP2w4k1AcsTsv/xoKFyGtzAobo7WT8K+tsTb8Ix5ds8HwVxOwClDFBsiJczyqog3i569+RdQwTtAOJ89ggOvWnyIHrfdp/REUPDjcMDLeCSkM/BLsf+4k+zNAKoo9UaitiveywtlOFod0Y5wKP06UjGeTSIWOIFv2Aq40bQxKAG5pTAF4d1V3qd/CBYGzx5aR8UQU4jqY9b5Nc3Q00VZMqdeLefOSh+kz2x0RrHHkvDL8fMnF+naDkrd7ACCsYqtCOjVPj+RLI/Jl/Y8I7CWYSQWphdqYuOiUnnLaR7U8wVtS/ft0nqxXEJy9k2GQyBlRVGBzycMNPYKZOxKTOdQv+vKDNX8Xalbx5tAf2UhymIT0Uv8yL1h2BXY6KnNpYEEZQuaZvWUBo4ujlhJgbJFbPNOvtjNFpRSKjlmbJPqLA2eBPAXzShJ7TR/oqBghVTfWz3TXdAlYB9mMSEBA5x6wjYQ37rTLOWymmNv1hjzPuBs1dr5a1/K4D+BEcLiDO5ztT1S3UO7OIf9IJ4CYrrC+9mO3+Ib5iJgsk3Zeo65cp5RNL7Zd9v6j0DRA4oM/l/cbRyc3g7IF8F0sg49Adq/XGvIxu5HEsRlvIhGqjr6B08BKRM+q27YFuyVtmcjXYXkN/8/3KGsfkBTOc+WYJqWrvtpgJRYBgYPCIPBoHiO/MSGpML1W+GpGWA4Zp6b7j6D64Usutp1FqtjWY6lcQjTamIoBS
 3nHK7i24
 BwezH3XminWw9DXv1wnlQV/MnjCSklxHzTXfzRfDiUct+63n0rPeDnLlV6cqMm9qJS/4yG5S07CqN1nASMJ8Pgj4PrpWQ0Nrbs01lEIgeFKvI8dbkNKpSjIZZDNVGqklmZqApT6yV5op0lM/rBWso646c6OIPZtMZyBzSi4yhGdtiegj/cygdXSmBbiGgLx3Td+4YwE5UgWSI+xoKips7fUTqF8ztOUbBLW6KTjv0d374IYrB0E6B5OD1RJla9XpkEJMv2r7CLu0cnQ+T03Cgr0vkZ5caG7RUECPzm2FqY0PS2ZgJHeZrZpk7vg7gv4+Wu5nq+wAGoJy6xXNqFhYCf4cgWVJ3XcHtOc4aQzFa3AbSmMMI/fTQcmpNvHCUNvnnkdjN/4YSW68RhuE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Swaraj,

On Mon, 20 Oct 2025 11:28:24 +0000 Swaraj Gaikwad <swarajgaikwad1925@gmail.com> wrote:

> The nid_show() function previously returned the node ID (nid) without
> verifying if the goal object of damos_sysfs_quota_goal was using a
> node-based metric. This could lead to incorrect reporting when the
> goal metric was unrelated to node memory.
> 
> This patch introduces a validation step to ensure that nid_show() only
> returns the node ID for valid node-based metrics:
> - DAMOS_QUOTA_NODE_MEM_USED_BP
> - DAMOS_QUOTA_NODE_MEM_FREE_BP
> 
> For other metrics, it returns -EINVAL to prevent misleading information.
> 
> Tested with KUnit:
> - Built kernel with KUnit and DAMON sysfs tests enabled.
> - Executed KUnit tests:
>   ./kunit.py run --kunitconfig ./mm/mm/damon/tests/.kunitconfig
> - All 25 tests passed, including damon_sysfs_test_add_targets.

So nice patch, thank you!  I have a comment below, though.

> 
> Based on commit 3a8660878839 ("Linux 6.18-rc1").

Maybe this is better to be put under the below comment section [1].

> 
> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
> ---
>  mm/damon/sysfs-schemes.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 6536f16006c9..23a73b94fe53 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -1112,7 +1112,16 @@ static ssize_t nid_show(struct kobject *kobj,
>  	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
>  			damos_sysfs_quota_goal, kobj);
>  
> -	/* todo: return error if the goal is not using nid */
> +	switch (goal->metric) {
> +		case DAMOS_QUOTA_USER_INPUT:
> +		case DAMOS_QUOTA_SOME_MEM_PSI_US:
> +			return -EINVAL;
> +		case DAMOS_QUOTA_NODE_MEM_USED_BP:
> +		case DAMOS_QUOTA_NODE_MEM_FREE_BP:
> +			break;
> +		default:
> +			return -EINVAL;
> +	}
>  
>  	return sysfs_emit(buf, "%d\n", goal->nid);
>  }

According to 'git bisect', I in the past actually added the todo comment.  But,
I of now cannot remember why I in the past did think that's something to do.  I
now think this function is better to be simply show the value the user has set
last time, since users could set the metrics after setting nid.  Other similar
parameters also work in the way, to be wiring-order independent, so that simple
behavior would be better for consistency, too.

I'm sorry if the wrong todo comment was confusing you, Swaraj.  Would you mind
sending a patch removing only the todo comment, without introducing any
behavior change?

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

