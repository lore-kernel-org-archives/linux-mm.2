Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C60A5C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465366B0093; Mon,  7 Sep 2026 12:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415546B0095; Mon,  7 Sep 2026 12:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307B86B0098; Mon,  7 Sep 2026 12:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 009136B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:41:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 824DD1C1080
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:41:44 +0000 (UTC)
X-FDA: 85187532528.29.7AFAC69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id EAB9D1A0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:41:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jeZrNCGs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2o2i19ypzRp1zZlcTwsPkK6eNqVdjfCbynSxyeXYXvc=;
	b=pRim9hcdSckN2dj1lOBp7heVJ/p3cZf3dAXlfEp2ZyxDx9NrefJFdm+A4n0T9Ef002cWmv
	0nzyp161TuoKO5GODDcL3+TWhism+q/KAFL31T0jvRMu4cPjH8KSFwinKKjHKHy1dQLkRs
	KnF9Z/9I9mX2QIjJ0lRXOONn7gXAnUQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799302;
	b=lgNIttKp06bOdoetIbhydMqZELN/Czao0PLRWz8DLTiWqLP0+IBPWlBX9mq950LsgE9HjK
	bMDTE7vQhy4KS6Y9k5tkDc1FPnEi65vmuXSry0Om1sHl3iJQaNnFicK86xdilanzSSJjmE
	5BGXsYjZg5fSy7Oy3P0Vj7jdi+0ddaU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jeZrNCGs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DAE1601FB;
	Mon,  7 Sep 2026 16:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CCE1F00A3A;
	Mon,  7 Sep 2026 16:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788799302;
	bh=2o2i19ypzRp1zZlcTwsPkK6eNqVdjfCbynSxyeXYXvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jeZrNCGs4WD65/u5voFDVJu2Ma65oDUNgRc93clYuDP6GSkDO2JtRtD2xncF6rOI2
	 2f+OLlBmoWqRoayX9iKMhoc20b25cThk2jBb0mFWXneLqCuC/JOxRzaWbZxaNP8SLS
	 9RzCNa1AVLdPFVE5wULRVgyAMqn8BqnXPzPi1xzLaM46f9g/uC3JH41cFZExF7CSeN
	 ySRjyaJmg3l3UhFQM3zwMaWmasvYp9sGVi09quy7ghOxmFTcDDCoV36uR+Ycea6QGJ
	 +YMFqmJ2PRvtm3nilju2fFUKWf9Hxf/VfAQQ1K7x+lOMHjH/cJST+XvjoMnWt0AErK
	 z99k0CK0c7IbQ==
From: SJ Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	ekffu200098@gmail.com
Subject: Re: [PATCH] selftests/damon: stop kdamond on error exits of no-op commit test
Date: Mon,  7 Sep 2026 09:41:34 -0700
Message-ID: <20260907164135.97543-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907123455.67246-1-zenghui.yu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EAB9D1A0006
X-Stat-Signature: s5x5e6knkjpdkofbbubb93g1asuwp69h
X-Rspam-User: 
X-HE-Tag: 1788799302-788345
X-HE-Meta: U2FsdGVkX1/HUeuea2BiUYo6eLWDoj/BZ/nnWe2c3d5wSeoSDBq3DPz1oWie1QlYJmhGV3ZM/5ZFDX+of2Ycmz6sYWYXx3LeNVbsKjf/mPAEoF8/+/ctlrcoC+0d80jkytmBdMfHuL6Qw4+FL+sgnkEbjLdf2B24IrXyHIY6ErnuZm382qjWL1x79jKwqkFIvUtkvxTbMiQy0sif175Bf3Vc3OKLVg8404xO9Q0s9SKK50xqCKJrdG57avkIR6OypwwLRo5XOTrovf5R6igqyzsIxrN/2tzqEvo/y4cWZwfg5Rk48MA874VP4YWlI4PaJCM0aXZ+e6RbZvcxXI/ltG/sFEXJIgxEISUc0u6q2TndZKUxcvtwQIMCm91hE2L2rCoIzvX5G+DCwS7DLQn0WrRTjPB2jtXI4C5qvgHxhwMFnuxBmwOga8O9lPEWMIt7i6Ip+9hLhHvuh0xV4ldPQFIt78+ukGxhn9/xb/HAwRr3stfM2FmFT8sSbKLi487anCyY4S5tyIbuO7FYFoeMFsrG28aBfGtO3VjVXaiBORD1kV2jTw7BD15snUuA6RO8YgpjbuxYpCitMEduXWU1jwtckWa2dozkkxmJ6bmRawEMWlOkSq2ODUrU/P9d6gZvcXcQe65xSzfH/IEGW0Bgg8fjpZaUxI34NQkV1bGBRlEJCHm08ZUbJ7eTQDDxJdvo5enYbr4n5nzvS5lVfDgtHs0/gqPtNXRsboqPXXebnOEYIpjMOPzTDOnhYx/kDCJN1TkxB1Pd1Yx65PGl9XMp2Nse06lRQgUlw5TYbvLg22Tm5EKeZIisM82saf2KhEUNkyOb2JWGz2S7M3WOsN3ixCLpxOFRFKtBc3Ycn/0unuu1LNEYJgtvLgpEOkYkpjGQDABuoQEGpUhyKwNFxuWKPkymYeUC2/tQFBYxmA/avzwSzedFqCay7uEQL1WVzVBIMfdSkWAsB9tebV2PQ29
 yms3NxRx
 GgDvwbKx5HmjPrZzcFViU0zKaPeuqsQcdXCVjeXWjYvVkbVYXDkzuoqZlg2KtXPapLY31+01UPmhQUv7UUhaHqMbKsYgkmXbTZuPkOyaGJE/VECtDwQrQJ7VsR967rXp7D+9Z65GRysWav41na5NEbiPA9ZUdwAQ0LRKN5sHgxO6usAReshlD6t/mFyCHaPGbQX5t8wW5RlygVOmFrxvKBzIS6rSupEn3WYzNSLS1iMDNU7Xn1uS288NepiMzhIGmFn3Ot4wxk7fiKQjrRL/qVHxiFYt3AHEpBB/A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 20:34:55 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> The sysfs_no_op_commit_break test starts a kdamond via sysfs, but its error
> paths (e.g., drgn not installed) exit without stopping it.  The leaked
> kdamond then makes subsequent tests, e.g. lru_sort.sh and reclaim.sh, skip
> with "Another kdamond is running".
> 
> Wrap the post-start logic in try-finally so that kdamonds.stop() is
> executed on every exit path.

Looks good to me, thank you for fixing this, Zenghui.

> 
> Fixes: 10725cd2b09a ("selftests/damon: test no-op commit broke DAMON status")
> Assisted-by: GLM-5.3 OpenCode
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

