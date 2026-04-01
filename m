Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39D4E10F92EC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 01:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BDAF6B0092; Tue, 31 Mar 2026 21:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E906B0095; Tue, 31 Mar 2026 21:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684AB6B0096; Tue, 31 Mar 2026 21:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A18B6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:02:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC9641B82CE
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:02:01 +0000 (UTC)
X-FDA: 84608185242.09.080CBE5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5924D180011
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:02:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FZDeVQJw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775005320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4zuqYmEh5+WKaXwTR6bFZ3uWCmKP26pMS5biANl4oc=;
	b=psAh3o+Tf2elnNHOnFVP/CkVCrL36WJSMt3pU9vGhAX/p3y3p9Vc/GdYnIRwnPK7ycmEzr
	RqoP7zXt+raoTd0EG5KRgHt2JMfMjPMz45ld14zaD+Uzjb1vxi+0tjadEyMfl1E5EaaKYt
	rCiGfLGkefrCH+IGj4+AM905RqQBQ6s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775005320; a=rsa-sha256;
	cv=none;
	b=6bpl2cObBNWIk9PyyeBuxrmTPqTmj3nmqvcdBFluPlCciwKswVT/w2+ob4WYVMIUbhdscE
	dAbC5Nyoy1qma3v42nxc0JMYljNfnXRVXQ6aBC0dTME+x6OGn7Nhl3N9FWEvmJmEu3mq6k
	piGlM7iTwSx2C/gs4WZ59ofXHdt4DH0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FZDeVQJw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5FDB600AD;
	Wed,  1 Apr 2026 01:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBDEC19423;
	Wed,  1 Apr 2026 01:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775005319;
	bh=jcORolmk2pu3U1KnRXM+xvp+DaiomzAMbEur1rQS6PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZDeVQJw4GASOjNYX8+ocjkJYyN3ReMmn6javnl04Oau69d7Wl/6H4cvUhTVfwRPx
	 +BYTI0tkNnsaV0C3QQ9KSj41eUL6LVtnClbc6wipxwdEU3i0GWn4567J8llXXFVBz2
	 IlXw7OvBoKEArkvIBXWb8GVWxyp5uy0yIVRHcHwXEmc4lTsch74QGTyjIWpw/x0ph1
	 Hmt7SwgqOytbGavQH8UqtzMcJ03Ihnm/yUZwnPcOFcWIfK2BkAp8XEoeG7njazXdU6
	 o8PGB4ElirT/dagWyJfTs3TQbzzlwkdy+GZlJllB1DfSsNlInQKYUUb0gN9cdan7/h
	 bUcqd890l5EIg==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate min_region_size to be power of 2
Date: Tue, 31 Mar 2026 18:01:56 -0700
Message-ID: <20260401010157.86136-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260331073231.30060-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5924D180011
X-Stat-Signature: c9ucdr5y9fza13ouyrrhixf4d11kkd1f
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775005320-903849
X-HE-Meta: U2FsdGVkX1+OVdKKiHryvJm7HeG6HDVUApkYU3ktaazxqV8KDs8IOiSrsGFNY3Bl9OD7LE8/syk1uVDIPjCRYWTqm8jtYBydihA4mzT9tOzb1WfallYm3aZxQDyzQXLEggQawXDYSOEQQpmDgxMFoxPFT5XooLKEBUf8Sa8M6rf7dOiONhnoFkmHtrYG/bzld0Odx4A4vKWRGvBjzaIWQGdeZJ7iSffy4E8CUVjgWQSXO0476LWMJI/3Mqi2AxB2QP8uqMfwlWpS35PFyAEaPOzJig3aH49MFBLpJzuaZBIip3JmoLOaGjJletZM9ETFSFwabE8GBVqpyC3M/lwFtyw8Cnsf3AtDP3f+TVt8JlIvw4VOTR8AUVaI4aAiaC0cWUZQKShtyOdOx6BsHmSjeFqp9HuJvoFO8SU2/w34pZSCPCUoaznznq5K5lWUjyKgnFm/0+x25nzp3lhyomxKTNKeXl6HPOITy4DVcIClqGtOTbFCu+72Y+853t0H7i9qWsyhKXOK/KFNCWah8KZ2F6t1mfVcacLZVI+AHr4GhRnxMca9rH4D+yO27C7nLbXGmpDWkY+rR6p8N33CL3cZR4XCLElj8sP5HTx8RgjK4hMHP2SxBN7QNy1G2bZ/GqKtUL73nlLnaLkWyI3HuqI+Zjlh5YPmr5bfHu3NYtWTO4L1iE9xr+77JtrPQtliS/rCnWh5+0tnT9AMQtSYJow5efNmS9jlHswL2W+oXM+c5oTnlZ5tNigO0uLgdFQDg5qasG6DwgkpzFjY/dfX+OXg9UOvhleQ1BrqqEmd+pLu9pRWiAeNiF7iC93JjJRCRti2rGpidZpwHXFFopl4PenMY4bYfiq4jyYpGYoBlHsY4BfRXX5lHYPWUBbvv2X/ET+wGo3ofqpNBrtk6GojKEbRD5SlXc+gEpDfo7NyNLVQBCjF0mWQO/wAeDKkiUgeVt9lUqRR1zPNIZrtVvACHCD
 E7oTv3he
 woaEr/LMu/kDp7/IutXVLetSmiZmJeYXB6jra+hbH5SRhtptlzyWdbDqtPzHcN1TJPyKU5F4QytReDBHnzB+roFdVUlva9L95nj9xbBF4EVd9f+PvUMbV1bJNAdv1OaQqgBpidLspHCERS9LJOEC3+i5Yy04XpK9VbGROKbKLGEnTvTNatqKYHcEpXxkZ/+aPiDdLatvHT1icjm1cgFQ6VQBr6REOeMzZaLQffCgtFtNqfXbSpyG+8RCzNuzl4FVM9DUIgq6DwpIp9u46fezLlE1ftw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 15:32:31 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> damon_commit_ctx() checks if 'min_region_sz' is a power of 2. But if it
> is not, kdamond will terminate unexpectedly due to the user's invalid
> input.
> 
> Solution
> ========
> Add the same check to damon_{lru_sort, reclaim}_apply_parameters(), but
> return -EINVAL immediately. This is to prevent user's invalid input
> causing kdamond to terminate unexpectedly.

Seems sashiko found an issue, and you are preparing the next revision, right?
Assuming so, I will skip code review of this version.
> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---

Weren't there previous versions of this patch?  Could you please add changelog
here, from the next version?


Thanks,
SJ

[...]

