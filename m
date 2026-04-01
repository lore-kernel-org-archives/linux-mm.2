Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E4910F9316
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 01:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 491816B008A; Tue, 31 Mar 2026 21:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468CD6B0092; Tue, 31 Mar 2026 21:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5946B0095; Tue, 31 Mar 2026 21:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7E96B008A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:32:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB541B9AA8
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:32:54 +0000 (UTC)
X-FDA: 84608263068.23.881DFCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3D0E120004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:32:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KzSGxm/Y";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775007173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMH78dmSXWgG4XWwFzWyEzOYAAfGUOroXdh5InEDZq4=;
	b=d+R9ULNxyZBw0Z2/27GtZ4QT94ACjQdNol6lICUKiXUCz8Q5Ol3hJDFiMHQHS07Kp9ymIk
	zFDYuLkuZfvk+y/rv9FvpJ6xPTRqahWGgFk0jJjbIMtFXx4tHi0NJ6uylBlm37CSjMV21p
	DmtQiF2SnZkxaoJmsn4wcEv2fIaVRZA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KzSGxm/Y";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775007173; a=rsa-sha256;
	cv=none;
	b=11uNhgl/M9QjFYRl1mhRbogHiOcu7PJ/d/hQlv9Al0hxUIzLkXO3FWb1BbEhetIYqvchso
	IqDJSo/vRUtEWm38078xWFQ4Tgc4UO8cE/CXJRAIZJ12ORpiE7wl+zas/ySs/r7QTuLgFd
	vl2cUooOqbcAEfl9BkadEvDSVWbGtFM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1A8C43E47;
	Wed,  1 Apr 2026 01:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885D2C19423;
	Wed,  1 Apr 2026 01:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775007171;
	bh=jXZfk1mQPfK1IJl13J6c5AH6YpYSd06uZnkSiI5+/Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzSGxm/YXsYrSnsIGTiO722hvWDxeLVFmyn0TeukvOA192Z2O0S/92vynODty1E99
	 ooiy23VGQnQsCWlx+SelpYT5euY4WiA0qnUQx/RlqMw/9xgWUGuLNqhODRklf/iOQO
	 k7B1bMGaf5uSK5XGBRX8sy4FaIBczCQmBHnsk89gKZeB21nb3R74Nl0+cw/1J30z6e
	 4jfZXDVQYH12XX0tl3FLXuUyblWplTmwV+18un109j/qti6tNb6mf/CU+Ef0AFCjo/
	 thQqDA2FOayjKvZqU8lbZ2G12iH+Gyq8Qahp5HgcvTIBRdFO5vMRrKcBN/eL2sJDpR
	 vlLcFLidg9qYw==
From: SeongJae Park <sj@kernel.org>
To: Jackie Liu <liu.yun@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	damon@lists.linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/stat: fix memory leak on damon_start() failure in damon_stat_start()
Date: Tue, 31 Mar 2026 18:32:49 -0700
Message-ID: <20260401013250.90153-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331101553.88422-1-liu.yun@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D0E120004
X-Stat-Signature: ufcme6e7zoxbp95uzffxia9cppprj3it
X-Rspamd-Server: rspam06
X-HE-Tag: 1775007173-665324
X-HE-Meta: U2FsdGVkX19AbnDJOZxVPpfem122Kz0iB6rzcerkANXi0AloAg1vehDnNgjQ6mhIRnr9aF98f3Px9LWaMtrJUMRwRyaCUXASvjs6JLptZO6mSqXMYCfBdv9nGRCs/siebbhGIS53OFiQLgsilwywNuwJLrkUSSe6GzFHy78hlnPAZMWEMsOdUUUi8mKiOMSiL9WBWaicuhl+9WqqK7Mo4cP8a+rHYfgqaO4iEo4yiYsKCriG879E7TBEUGCh+fpuFCDwXHTAa7iSGxgF/k9pLBkQViiZraRYo8ABmvgn8hPVfcq37KY3OEZzn7l+Zk/yZvsvfOojnwwHMCJ8a47FkS0fyjU/OAe4Z3/4zEGOFXElYQ723DeS8rfVwYcMCv648IM0tq3AdzEuir2+a0TukmxOoUeZ7bbGVeTMIM3zQPBgMYLihQ5hZZZvigxo1X35VgK49JqZvF7I8KtigldLNuNKGPkCa/zlGn77uZ9C8oFS+yeK1hPhKC/OLD4PlmEW+5taC7K5DTu2DaJ8Jf+1EJd1RyHzv2R4tFm5fcxfEO/bBw2v9OtNN18cxF1UxQDcYPEoBEie0TUVgqkiDj8B6FckG3aiJrCpL1SAfTaj+AbJeEB8UNJB+FpXCp4IV7b2MLsQT7fkEsHK2SYlW4zwdnJHs5+0yXXCcTGyA7RJGKHabQb67NBTi4vUI4Q9rjMe542/g1h0xSrgUQ+86Yw3G8PqNEsDFT07H7ZAszEwemsf9ORqlIGZ7jp2uHyQE+CxKRnfvuOhTYiQJOjsDbj40ffTMl8omD42YJgY4OSW9G1BMUWARamQdZ93LFeencUHR+ViTL+ILCIxCduxMFrfmnajQkOZTDCGrRYVxGtPfKPM7Ds73hzF3ubK29yc260ZoCEpCta2GDpIAVXvuhkl7bZ13k2gC+d9Nt6AO4AknIYg/0UdFUEgMC9f95+M+lbg8QJfdjQfSEQJXNDd3/L
 Uq20BrDy
 /Er+8eWG1BliDYC5NXKNS5N3zmfpCIEN4MS5xx5oymiGu2m+INx2/NCNvXyQWySKRilKP6pQ/zfBsBLHXu9nLpb4mLUa4BKFBMgrG64c9L4XZyIg3GX+gygVduAvewVONvRAjB86DopQbYFfAfoHdWukTahKLTaSF+vB4koMq1DViyUEYqTkQfSvr1Y1ZrtSznw8H5/WI39evwUMsTI0Yl+Vo2aSVOS0KffNFEOqgHxbszT9/NqlqZAhmjs3QvTJiIS8/yBhbjKBiH8lzg4yEcLXrF+Mlus0uGgarYDX1vvFjaTqdx4k0y+80zehs2JddJq7dZVfusReO7vE6yoJg58LMpjF8WYoeHwX8zh6WRvViJ8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ damon@lists.linux.dev.  Please Cc damon@ for all DAMON patches.

Hello Jackie,

On Tue, 31 Mar 2026 18:15:53 +0800 Jackie Liu <liu.yun@linux.dev> wrote:

> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> Destroy the DAMON context and reset the global pointer when
> damon_start() fails. Otherwise, the context allocated by
> damon_stat_build_ctx() is leaked, and the stale damon_stat_context
> pointer will be overwritten on the next enable attempt, making the
> old allocation permanently unreachable.
> 
> Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")

As this is a memory leak, let's add Cc: stable@ too.

Cc: <stable@vger.kernel.org> # 6.17.x

> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

