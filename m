Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E844ACFC28C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 16:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 509166B002F; Fri, 21 Nov 2025 11:35:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B93D6B0030; Fri, 21 Nov 2025 11:35:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF436B0031; Fri, 21 Nov 2025 11:35:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BAB66B002F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:35:53 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C81A7160583
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:35:52 +0000 (UTC)
X-FDA: 84135165744.06.8A7994E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 34A192001E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 16:35:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CHl3689/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763742951; a=rsa-sha256;
	cv=none;
	b=Fzff4veW8+//JIhiy6uT+/6tf8ZvjBgPTYKUvatKn1wx9ICe+8ihsDP/v1A5+/nPWTGRmr
	7BLi84tMcrWbFs7jrZ+LXI6MOrUxL7SvVq48VvDy6HTNxRwda0NlMoeXYbnYGflhLEoemz
	tVPVIHKaY2uV9w6548/ZR+Eq0hwXsKs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CHl3689/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763742951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YA8D+kY8PDxWK8gWTN1M6Yg/v7G1zZIEPW164zQJQSA=;
	b=5GYMGWvaboTupZ1EbLv5S5ZPrtppc/iXnvgYsw+qxW9cWyLdsB9wqln5Zob+3/bZ3Imrtr
	/wI0BZWYLPFrQDs+IEmgUddoQIwgrislyX0BPFZuxtPSyJRy/4RBhRujr7iAQU8kjPD1Va
	fwCmvizpXdYKVBbWTkO4HLCxxvn+MMI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 509E64184D;
	Fri, 21 Nov 2025 16:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD77C4CEF1;
	Fri, 21 Nov 2025 16:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763742950;
	bh=+j8+cMczWh+41I829ullX5nvOYe6iNeHAFyjPVtK8uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHl3689/H54OfwlPu5yp23DklYBUo2cq+4BzC2d3rEQtYa2AeaCtTsqga8TWnwP+a
	 PY/b3CXBUEB8lH+wn2HTP0u/tI5kaWXgXSb3IbgScl6O0r0fxMQ9aLLptL3sO5vabK
	 zVQybjGesYOSZHYRmI8KfPAjCU7Hi1RJq6ppWnMRwLMyCdYLBqLjWHfa1jL4nw7HSS
	 vixRtfiGJh+sJvOjXZU4Xk0MKNaaTTsQC1pNFd9ohNIz+1O8RU3ct22IY0qzq7xRZ3
	 YumK7D2L6sJNviUR5UZsMttZn1BFACsZ+eWI1XXearxItD15TmnEk9mkDlJRrDNA57
	 PyroJFutNQ1NA==
From: SeongJae Park <sj@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH next] mm/damon/tests/sysfs-kunit: fix use after free on error path
Date: Fri, 21 Nov 2025 08:35:41 -0800
Message-ID: <20251121163542.137692-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aSBq5uSPIqsqH8zO@stanley.mountain>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 34A192001E
X-Stat-Signature: dcxsxmdtbazfa7ns8ayjz8rc4adkd93r
X-Rspam-User: 
X-HE-Tag: 1763742951-48056
X-HE-Meta: U2FsdGVkX18487I7fghJNJdeBEg7I3Ahkip5Ac4TSFz79+b6apFYeD4Bh1AdD7JmkaSx9drx/ktN6yl5BjjlipTccGD2jNcK08ArDAIqi41zIh6Mw7oaHvA8WhKCLuMcPwKsXHREbX8Wxc1YmaLqna6bhbs5XBOIHDCFTgfKb8bRX3hUEKHU4EoC9V0wHQvQMozTtuzdbZToPy+SopSnW4oetyXl3tOHsMWpCcKSLc4sg/qQkbpqSBuTrB5kG1S6L93qd+3hv3tcQZL7kAWN5vbKBVzLeyur8aaTPePgFcZw8LyHk7fO+rQARmst5lkep1e4teHFCDshrUxAgONHPpQBFYIONqwgmzhRHbkW/oQIiXn4q2Uzrwb1G6ddjzSmCnByfAIYPsh165om1Rsc6Hd2GWETmkgZF9kxHJFuAMICyZ0WBXtx0G91UVjzuGCS9NQQaoKX8Jca7XTIbJIe9E/ieV5dtSVX7liIoQYP11ZUlP/D+yVEVczEeQHUL2jcEh/Lqroou0Sj10Pjs2zINqCa4xIX5K8zA+hJwKsG/uCVEjbdNUrFo6kh6gXR3H2X4t3cpkaK4JZ+yHFEOhbKUE3wOQwaxqXIu81B48qmlVZF8EyPZjAvth5D88iBUBo2cpntcVuDHOkub27/9KVcaNh8eg90Nzkli90NDT5erKc3L2T/e9YWFHiiGBP63Z0cwnHXDN+L+QDYLqvJoYBIIOcUucQeyqwBRI3nz0tqgUEIcdBh20vyoOHyWdouL+ZfrwxR8X3Bl2pKJEb6PcchW4sEZbXj4SS36sBajSJsk8DrhJIcPV5M+Gmbxb5faJSNE9gu/Qk1p0SbQ6297oxr3nmiNYxO2seGbSHyDCGBJ6awMAiS75FFnL+g9B6GfWSjAb6xlLSyVNUJqgutVTNp/uJYuWnNB2gGhKLAW1Cv3nA8/8lgOC2f/j6iW3ZScDUe772nSpvG4P6AE2Xy3gr
 4uq8k/Lp
 cnSlva6awhFrTBi639SRinEfon0PltVP2JGKLNIsISQWCLYOtV2I3q2gjtyTpFwf4CyYq7dn+ziJI/1curA42DCwscaQDHhw1t6Q0xMRuwFIkYQBczFfl0j+mP55qq5ks9G/9TSbJ9GaijNEmedo1UvFIfTJ+Hz5/ZS6nCb9YPvSVQFtCnlMhJrMwAwBkrXoyPsQhO+CdYbFZknFJtUj6a33SGBaQnETimvfOdBYhPTPX210p/5BzSXBUeuMZOqn4ihMhDkfwZFniQL2mNmPxYHlqhoYp/UslbsvPFVq9arq3Bu7E+feY9XYiq7Iu9IddE4kOw3Iodgsl5yVTVOBUoR915SJ1sHlgK901
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 16:36:38 +0300 Dan Carpenter <dan.carpenter@linaro.org> wrote:

> Re-order these frees to avoid dereferencing "sysfs_target" after it has
> been freed.

Thank you for finding and fixing this!

> 
> Fixes: ee131696794c ("mm/damon/tests/sysfs-kunit: handle alloc failures on damon_sysfs_test_add_targets()")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

