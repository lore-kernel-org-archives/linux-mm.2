Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A17F36B97
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 23:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3AA6B0088; Thu,  9 Apr 2026 19:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888666B0089; Thu,  9 Apr 2026 19:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79AB36B008A; Thu,  9 Apr 2026 19:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1696B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:58:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2CF1716029D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:58:00 +0000 (UTC)
X-FDA: 84640683120.25.101107D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9285B180006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:57:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ndI6wPDo;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775779078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Axtrve3Vhpv9Oo1dGjEKWsvmK+Hfp2HW6RAIz/qFj/E=;
	b=CBxSV+fizP9fGwRyXZDc+masFAUwsfKMaeY4RTLjIiBIjbUWV+09BpQyCcGc7kZTd/87xi
	xyWNzThdDdK/R4+bvya+vsiUrg5X+wlwDxQu8asnyd6ckM8RvWxdwPCcDY7xn7k4FKYp1C
	IrFbBJScdYBSEFSCIKlSvG6ehPUuuPA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ndI6wPDo;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775779078; a=rsa-sha256;
	cv=none;
	b=uSs4/dpX5RNNcFUh05VZZZm961jJfVhWyUeI/LebeMfjz0bq1pFzdyZME6MN+VLeoIvi8h
	1uJrKikKoMo15K0AG1ZpZ9i5Wsoux+9kBt8f7XADUpXHSbSGgNmJCP2w83DgVUn3ONCkrd
	0nbpX43BfKkDgoIG3NTZ+VYYIt48r2M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 872A360123;
	Thu,  9 Apr 2026 23:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2014C4CEF7;
	Thu,  9 Apr 2026 23:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775779077;
	bh=u5R21OQ0WANX9OKWBcSz+IU+Rdbvqh+en/BD7D93X2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndI6wPDop8ca4aqo7vVM2jCeHLK+Q4Tked0CWpOkKW6cCfsrezHtCEa3Pa3t5n4w5
	 iDQUmACbOmjEBUUovTtFp8BeVPSpiwsysHcc1DBt+clPH5ScAVYhwlW0Zuyr32lBvG
	 tnnfuJgOE5vE63M/Sqaq60t3zt2FMhUNPVFAlychHrfXsxDWMkRwx/CjWHSbJp7aZ/
	 YGZ7wWUzoGF8prk5DNA236AmVOsH6Y0ChH/y7tjPA67EXyCUswzaxJ4BH4PKWYetyO
	 v5dG1vZbQlAUjAokCDRbf+Ip4yXu2H88jD9lmGH5SfKdU5sHDl3hENqxR1V8rqNmfA
	 a52vv0Ercc5kg==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Thu,  9 Apr 2026 16:57:49 -0700
Message-ID: <20260409235749.77481-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409150128.1566835-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9285B180006
X-Stat-Signature: jseoo5z57ky7ebda6eogspfcpsnjn8jd
X-Rspam-User: 
X-HE-Tag: 1775779078-499016
X-HE-Meta: U2FsdGVkX18EQ4OttNyAKM7dgtMFTLOpo8l7e2l+ptdg9IpEiufJs+ML7tL76YjUWDMObvGe07nA806q/bX+03juzlxA2KqduPH98Oswr8LgBYmqw0DZM+rysqrNAYvuYfxL+3qh2o9jLHqKkyslTLeksyqqGvA048PwcEWpQTsuJXkBCH3UNPdD2jDOoifMtcgQ2Tm4D5KqZPIG34ZT76+koyV2jmppBj2KfzWLXrKjcI5UFvXnIDlW74EoQx95wFug+vRL7Kjzy9lBFzZBgDDiLGS5y+9vL6Vg2T5/YH+UtD+9TxmPosDe7jiwCPA7SMNnO0Ry5y5NbGoVQKe1MSafz3yop9Lc9bwFFgwYbXRjxv2VMEiWjF0eBfjQ0MTdFZYooUVMJPgwFDAuB+nNYr/l1o/touigg8Q424tC2SeyaOILzdl7BVml0z/1SbaCir7J5+skUJ5FiO7dJwPv1HKQr4ZhcKxxQrw0X3krHo1yuh/Xec1WAhMwMLOOl3sN85jANeg5FzzhKOa+P36UAR2DFr2HSuwSYQUzoKsmrOQuwYASmCDLZR0D9NgwNdkvF3aOC91Tx/HbjTjrqn4gFIn9cBKl5VC247r4vob+Z70QZnGbKOs8qL8Q6pLCz1+m6xfA4OZtUv/QCzGUuuymZrlcchNeRfgTJIXktkPnR8PIimle5jJTi6BDXc7XXgqjwwnYsGse7tuva6y8BUq+37FAxPfwkc4LNUnURuPCKxED8i30f4Z7tNIpm3xlpUFUfTdjm/OTDzCH0xNY+ONkCajhI8I4M3GOa68Q5OxvZVZxyIPLAo5qZ2Un4gKMPujctebw/go5RYu2/g6FDtmYvAH0WYeRQvAazNLVl2y8i1eeXdER5evCoon1wrApEZCYX9Q/9nzTmeMC+mrdPKPF6Xfhz8ltDEiPcfsD0IQKjAKipw6M8/mTTArDgMm8T/1EljRBhV9kIdTxpsJRX8J
 ogmK6UYk
 u4kclwUyyziGDRhp/gPYNiqWcDlpkRPY34+Wq9rlnJ7/w/FPdsGd9yyqygngVbYsBbTmbXNd7FVh621GwAHdb59VA23xhtn0El1qRMzFploxXIIJIpFuCZ5+tJcqG6WiL4TCDBb9wLCD6JaNJwZM2FPQIdLfDVHDFV0J3Rd+ILsBgTY/rqeDHwJVSJniW1LLfXaYIqVK5wN7hVWwLsM3uCtLI0VQmak3klm4OlHsHxwdDsr2s45SmRp7QrBI1TreLf1ZKPKKockwubo3bP6ROthth1dLlQjJGG8TieEZzZRkF9wK5ynR9feGnvOIhLY8ucwn51rzNISHI5nr1JRsiJ2JSrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Asier,


Thank you for continuing your effort.

On Thu, 9 Apr 2026 15:01:28 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> This patch set introces a new action:  DAMOS_COLLAPSE.
[...]
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

I added this to damon/next tree.  Since mm.git is nearly closed for non-urgent
changes at the moment, I guess Andrew will not pick this for now.  I will
repost this after mm.git seems opened again (probably after the next rc1) in
the case.


Thanks,
SJ

[...]

