Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEB3C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 04:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8C2F6B00A5; Tue, 22 Jul 2025 00:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3C906B00A7; Tue, 22 Jul 2025 00:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B7C6B00A8; Tue, 22 Jul 2025 00:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C31FC6B00A5
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 00:04:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A024B7793
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:04:10 +0000 (UTC)
X-FDA: 83690557860.10.BC51460
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C605A40008
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:04:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFtutMOc;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753157047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTGrdIOWgZjv3+/un1OCsVYKqr3yzaZFWPJW8InZIps=;
	b=PzT3G2ppQMGbDYShI5Aznp29IaiXs+4EztCfA3sdRODLSay/qKmWNnlbPhfFAsc8RNAYXQ
	Pfsq1qCgNn1YfSZcKKyvUHb4TbbcG726a1MawtUZAqXGMPNqNohxzdQfFaucRjyqWP2qws
	OJKpqVLquzl4RSJYY3tja0OxYxxlMvU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFtutMOc;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753157047; a=rsa-sha256;
	cv=none;
	b=jbxs8D6ZShiQTG5K7Nm6wcw3AkanMFn7JggwLU+sXs78HYxjQ8x+fB1Q2gg3Cb96AmvOcL
	yvSQ4AaF0Kp8bd8FmtzwhIsFBQEUiQFiWXrHRxN2HU/19VMAMHId9DzaHWXwLkMXquFTR9
	mSwbUp2y5Fq32kSu40dKnGxdRTaYPkM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 14022601FB;
	Tue, 22 Jul 2025 04:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACF4C4CEEB;
	Tue, 22 Jul 2025 04:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753157046;
	bh=sWFLbPKdRogAeCO4NDj6dit5DKLdo1elGMqIueuiDEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFtutMOcE08vlLS9/lRevrcIsHge7VHmofxu2T4R5WSoI1A5XNViB10nmON/w4rov
	 NA2sZwDB2idnXsjS2OFybxYKwIxOwd3Fl1JTue6LxK8b0xRShnH8xfoT+wyK7qO79g
	 Ly4vyFgQ/j/3GpBlgOl0pPGmNU/59hdT3SrPgACAdLlxImd8NH7oQ5Bv6X2Obh+dfU
	 GGBDJ+W/2qoygGPTZVFKdEL65T26w0eo/SZvUNlinY60ZCj3xqLhDquUCLHBU1PR2d
	 zzzaLuouyx7zKl2pzXNYxQaRNVuBgwIfdvGUBZROzf6jdbXvV2GBxcWkf3UkYY5sDj
	 J0C0uQ2UxszgQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 16/22] selftests/damon/sysfs.py: generalize DAMOS schemes commit assertion
Date: Mon, 21 Jul 2025 21:04:02 -0700
Message-Id: <20250722040402.56960-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250721200922.79b34a049af4a02947c716ee@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ufmm5w8aq3yx5x6cxnynfsaqq4oweexw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C605A40008
X-Rspam-User: 
X-HE-Tag: 1753157047-355641
X-HE-Meta: U2FsdGVkX1++JSaAJfCxyf9YSrF+jnyGIU1/0/m5b/yq2HiUDrnd1bkB/zonTQeYeDMPwf8sSxRyI7AURhQTm8D7oQesHfxupRhcKRIHtwbdgXV5oC85iBmDpDs7tBLN+Rdgag+qt/NLIofzPrJvc5NVcg8oSWWH4M7gG1AIqlDfIdfX2Fu+Shu7QvFv2NK2Bj7whA+AEpKeECD7K73kH8eTWONnTnFLgjKe2mMN3Oo05JELT7cBwy5Y8NrFSXJv4kvzCghEjOJCFLJzeaPbVSpsiDi3VnGD0+kq4GytzCxzECAl0rJ5qoqjPnThJ05/9hY4Qv4hzJUW91WP46VkjgU90SRbZn6Nz4ErJnFm8ly+Tr43TOzpmKAKHbZcDLtFhTgd0eEJhYDwlqqi1V6sSMKpPL5RmN+mhmtcl5uUDNAEZnMvDhfmfm1LpXBVqJeIWTjzqhMds0Yd599RMWyn2WMCE2+W06oZ7rF1FWGdYfx3Fb+7gC8NOX/GlfBkuAKAxGMsnWvARcNtICFML4KNtDFlhFirOub9OQ5wUFxS2HIwrDZrCSpPaDNZmwjCYMImqXIGQxlyMv6rtSbF1eQCdoZ0qQPnfhiyH7RhfXHsa0IYqvb13rgl0PWCW+JZRkeriiynCTrZ9Qnam1d/pSARJvDI2CZXZwXP1KclEaPadiN5jLmnn7hFLLA2EDSigtTohDmxt03JpWXdoUGMB3CTtZ1rmjf+yd9cCz6AJAOU89qhDQLmn23m06c1S2QV9RyANFoNZvpLNnKOeugbwmMgM8Q7sLraTsHjdE9zEfsIrFFKYlPFUHEeecVXs+nM2fqh/6HVekiOqTw0Vzm1tg/BS8JLJdkzU9dSFpPipkbvZ89hCuYzBjvbqCiXCxGOvpAtq5W3LXkCKrWGiUjZRYjBeO5R1+akZVpC2myGwyk7ujFb0HYI145v4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Jul 2025 20:09:22 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 20 Jul 2025 10:16:46 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > DAMOS scheme commitment assertion is hard-coded for a specific test
> > case.  Split it out into a general version that can be reused for
> > different test cases.
> > 
> 
> This patch has the same name as [18/22].  I renamed this patch to
> 
> "selftests/damon/sysfs.py: generalize DAMOS access pattern commit assertion"
> 
> and altered its changelog to
> 
> : DAMOS scheme access pattern assertion is hard-coded for a specific test
> : case.  Split it out into a general version that can be reused for
> : different test cases.

Thank you for catching this and fixing on your side, Andrew!  But, the actual
change that this patch is adding is the assertion of individual scheme, while
the 18th patch for the assertion of multiple schemes.  That is, this patch has
actually wrong subject, but the changelog is correct.

So, could you please make the changelog back to the original, but fix the
subject by 's/schemes/scheme/', as below?

"selftests/damon/sysfs.py: generalize DAMOS scheme commit assertion"

Sorry for making things unnecessarily complicated.  Please let me know if there
is anything that I can help for this.


Thanks,
SJ

[...]

