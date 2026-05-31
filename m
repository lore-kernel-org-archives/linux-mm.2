Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06B20CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 16:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B296B0155; Sun, 31 May 2026 12:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C756B0156; Sun, 31 May 2026 12:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 388FC6B0158; Sun, 31 May 2026 12:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC986B0155
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:54:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5AF21C06AE
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:54:48 +0000 (UTC)
X-FDA: 84828314256.27.ABB71B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2A023160005
	for <linux-mm@kvack.org>; Sun, 31 May 2026 16:54:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHSnVtfW;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780246487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxNfjlt8z6ra/rBSB/w2v0ydMZ2aKkX0YJFO0NVjmRo=;
	b=VHkOxU2Zi4Pw5NSzFMM5lC7lkntQ/JBVkMeofTqDSMm98eJSwQciPL13AQ4PCfqISfdd8J
	GHP7DbMAF9rZSLj8LEvIehU62LDQV2Y2OW53XKgHNoqIQJ37Kwbqax6KBpMXemR90SOmMq
	bCLXjcqyELshtHjKqN+s6BiYujIJk4A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHSnVtfW;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780246487; a=rsa-sha256;
	cv=none;
	b=TNmUkYe82tJzlNi4e8Z9Z+vhMCbRI6+Gp2PGbvxRMWggNLx9r2kbbiliyAul7kaXRQum/p
	TzhQh3itVCA6be+/e5oUQ/PHp+eK6+pPFTvrhbLCzuQYJSdidO5pLN9i0LoQMu+xDtwuYp
	nI+uZmStpsyB/ksUlbqbyhCterD2Mzo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E70240B8A;
	Sun, 31 May 2026 16:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F94E1F00893;
	Sun, 31 May 2026 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780246486;
	bh=DxNfjlt8z6ra/rBSB/w2v0ydMZ2aKkX0YJFO0NVjmRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DHSnVtfWrjD47T/hXx9+C2HLPFW1gEiP+3fvg77a646RvPO5OVH/UshZcO60Vwhj/
	 h2qaXmpCXYhMCwutStXqyrzo2sR6P07O/xM+4oSUr98tT9wGhYcuUBYIsPF9E7RHLB
	 WjgsEOvn/ISIk5GosPPU2wC1nU26GZX3LPyPMnlUMN/IyuBOsOts+iRYN1QM8PrUdY
	 zDwmwDCnrmXWSwdxTrhqEaAGlaaZiNshzM6uPKnHSArATFYJTq3cxgxKFfrFh1r9Jg
	 VWFaqGOuO5g78m/pAxQOOpc29LvEZqGSvJR80sZ8vZmBHvi8kQSnonv1OObpLxq71B
	 r0LUX7qAcoOdQ==
From: SeongJae Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: Re: [PATCH 4/5] selftests/damon/damos_tried_regions: handle empty tried regions in early cycles
Date: Sun, 31 May 2026 09:54:36 -0700
Message-ID: <20260531165437.99410-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531091724.84381-4-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2A023160005
X-Stat-Signature: r1tqkworp6puii4a9hi9dmuhq3wqduu8
X-HE-Tag: 1780246487-527895
X-HE-Meta: U2FsdGVkX1/eMiu1pD3omA67GYeGBiIswyefNc6DbwK9ITBabs0AgS/8/7v4rhgALIRVjypgnXiHcmNJl9u0/5U/PBoQZNLGLkRWe8hOLQNpuxPNg8Pz9CasyPmpk9MNN27JW1WZ7dkGQ3Fr+yUi/vFkUL22wojB8F0vFuE+RZy358KZAnTguzm7T7crXBkB3JIEbEeCdAOHe1zij2G51WL5rm3if05OvYtWsGb9c+HQLRtX+DkX0LhNjHSxS6arB5aSI42wJTtCC7FlQ3yjzswsF9uDRTxWYMBOlS20Y/zvMNszzmxfDZ4IdylHVdKj9pl7WDhiWLEr1w9igyn5AmflzU7TadwWvmo3QlAzMpeu5m32sW/ZQto70sC3MojxwVv1ucRZHK4UbsXhRT6eWehYONuJwN68ygoZ6PMKgm1SUGklxoAHVbm2ZxyJNSqkmYUNFFkZMv1lPlFIKRnX9wZNKPWFBoZlGOTFlHSoF6fEuz1Le7B5aaA3Yu3zvTieNL2A8F25uYlS4QZpR13ods3JXa3DSFUSnVCwRtqBPtVl4zhJchF3tW6DaA91qF/fGsxULZI1ze5Sgf/IHU7kGjXxd7iOPYqhJwt2OPn0Wv3pVUd6IOCHO1ZCnKPtlLs7hO2wKmjd19mnS+MAbVuT5y4FmkyteLuqCYpG/sYAa9+iWJ9oDBhZMl3n336EfsGuNGdZJc6wUWQaC0ErJ2glwij+FsoMJuzqu4fTFEXl6duND5FNqBP7elqjGlpEKJ/qcYG6ViwLeK77vWuFkB5+rFWEHob7oV45vBSUn/XVvPNRX/LEzuoejah4fdDpHeyc3YIIiGyjXTdmS1yVtjQQFgzUtw7K9+H0EdNXwHzCC3YOATmwwHDDIWVbpI3yYWg7CNkIRKOsEODCut50305nAbOMUrc8qWARXELEUq+1YjvPVwExwRmXI7Wp2X/xmMLTNQ+8Gv+0wjUOHX64GsS
 YrLeG6KY
 WfIUl6OhbFT+TMNr79iRlRgXqJq/vjaFMX12QRk4kHNzoy7I/cqPbai68hBOaya0mQ3c7cYJTBK73l3AxWwt5+q5CkZegLyQfX1ZlYDufIVwUf2EJPtOPE5H1AmKcKAxxWsBTN1N+SAIuFNZ+gz0hnvAGKPNXlPb5W2DxOheKj7H/yOPrnHhQjRkJ+1Cbq4XVjNaw4wb0ye/SyByGi0u1wiKwU8gFsysZRUgv6CyKcDgmFrrjscNGx1PScTVxAHE3o9cPvnuvmMd7JJuwlAxJnsPMnOzpJcvLy9FbmSaad6xcOIif/e7SFpOInDq1hpRfBFl0jRG/thVFK4SoTBlmMCfjmA7kk8CCLfkpHF5ihPWUPzkMb5TxHfkdQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 31 May 2026 17:17:23 +0800 Kunwu Chan <kunwu.chan@linux.dev> wrote:

> From: Kunwu Chan <kunwu.chan@gmail.com>
> 
> The test aborts if the initial aggregation cycles produce zero
> tried regions.  This can happen on slow machines, causing false
> failures.  Skip empty cycles and retry up to 200 times before
> giving up.  Also check that enough samples were collected before
> computing the 50th percentile.

I agree this will make the test be more reliable.  I'm bit concerned if 200
times retry can make the test run too long, though.

Also, could you further elaborate why this can fail on slow machines?  That is,
DAMON will check the access of 'access_memory_even' process every 5ms.  Are you
thinking the 5ms is too short for 'access_memory_event' to make the expected
access (accessing the 7 regins of 10 MiB size) within?  If so, should we
increase the sampling interval before retrying?

I also suspect if the unreliable results you seen is due to the fact that DAMON
is not flushing TLB, like we discussed before.  If that's the case, could we
increase the working set size of this test, similar to the wss_estimation test?

[1] https://lore.kernel.org/20260525144846.604907-1-kunwu.chan@linux.dev


Thanks,
SJ

[...]

