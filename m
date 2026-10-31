Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBAC5606A321
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 17:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lbuTd6xN
Received: by kanga.kvack.org (Postfix)
	id A17386B00EF; Sat, 31 Oct 2026 13:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8726B05B1; Sat, 31 Oct 2026 13:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0D16B05B2; Sat, 31 Oct 2026 13:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6898A6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 13:47:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D88F81A09FE
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:47:40 +0000 (UTC)
X-FDA: 85383653880.25.DB720A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 56787160003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:47:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lbuTd6xN;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793468859;
	b=EidlW9yyacrr7bgauavW+iQUps4ym+Dm/GKhOFw4V2jMZJ/kRqOvqRWyvMCg92StvDfnhz
	uERCfI6Xeu+AUHZQpVzMbaR6CQS9738tQTYti9PdiAIEJ2y9p4AmWC7aPM9D6VZ7mykpAy
	8xb7hWd/Dca18Dym8a2XXgYSb+Zq7bQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lbuTd6xN;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793468859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1h5N+uXBUkAc2XasWbf+L9wwWxu8fi1nQyRF01jT8d8=;
	b=NsdLAFcsq7aiudJmmeu3RDx8CcXC+CtxnmPjNCwNSqje9In/7k0NfFYbeb2pRUw/LVz3oW
	5PA/s2AANXIzwzfJ9vq79w+cufOvxbQJLI/O7obagIIo9N3AUVelaBL1Jv8OrNjJ0olbpj
	yKXeTiby3zEEdiDNFMVvdB2o77W8AMs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DABC60B3B;
	Sat, 31 Oct 2026 17:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12FC1F000C1;
	Sat, 31 Oct 2026 17:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793468858;
	bh=1h5N+uXBUkAc2XasWbf+L9wwWxu8fi1nQyRF01jT8d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lbuTd6xNnxzdilE1w0rc0CBCjKyKLmuTFN0ZkPJp8l0CHMEMCSa0pedHFdUP6VI5V
	 4w7flaCig/G2AcBK3nVYftBnflhgxu/FJXeI8MZ/cSp7jpuuU00xtTQPpgCYh5ElLA
	 Z3m1Xp0xWuVyP3dGnyhH+KLqvAv+dqucYOrVv6fwjoJNRK+nGmd1lRJkIBgyUYYraJ
	 EC2NyWGK/s6iE261vlWHrsSqQSEroUYKuD9DQIBqiN4wpCFkRP2L/ROm2C32Kmzb/5
	 /XKZycPwA3ssUx+64jaA8lO72VWn2Rx9jrII7xA8QqgiQf820IlPUcN52gUviFg345
	 W8lpSSTJOZAcg==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev,
	Shuah Khan <shuah@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH] selftests/damon/sysfs_memcg_path_leak: define ksft_skip
Date: Sat, 31 Oct 2026 10:47:25 -0700
Message-ID: <20261031174726.85433-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179346448183.4.15545164251841296990@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 56787160003
X-Stat-Signature: mr9xzscqa9m1tx1xn6i35qtopys4fd73
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793468859-375305
X-HE-Meta: U2FsdGVkX18wwZiLfw4kYY9gVuxgaQ5YK55mN+UmkTdqIFNVxd09hboXhyBP1g6xvwhpIc2+njYTKDvLBZI3XnIJIJUtG5sfvU4qgeL8aO6ZwXfQ785o6ZV1rgDSrXuG6lAgB8huLxd/8ShJBlFgyqcSfThDCM9vWvg8pQ0PDhdW9zVDOszIKA5Ecd0Q7GJ8cVX0WCr22lw6IjtFK2S8yLpxZjle6jQAsksPT7AsIQPc1TiClOpPCbe/96tme31H6eLsWyCblSuQLzWsG3smYOT5Bok8BUxTGuNIODLTkHAm59KfBA/ZCznqT5IPQg6dKeheimQvvDcst1NTebyu1QoV/3eoiC7fECvj2FA2Q4wxDDmBWqSATd1nsWo0s7SkDaJ799WPCe2F3ewdOwHMFO4TbEh5bY8egtZ91+L1SLHTo1E/YOwtRvEH8+uDs/3HLJrq6ighKN+x5E9T30/fIOikLK5nRbwqRtoypplHdburojEIV/Hrfc5GDQvTYxY0VHPLHbHTLc0Y14DNDgc6avViBz0m2QMwo6qHPnUJn8Q8AwTnb0J13oUGEKMVOkUmKCe2JoTZGW4ofzuTVJaJRyjXi1aKgPWS6gXFmQVCY7NlKU6psh2DVUPZroIXzf1QH0CVJs0KxbqRcbfDDe+ifdyt5Nih5rl0x+EsYzD9LHcho4eA4TDwdQPf60ZCD467ngrEPuItC7S2Onuf6cPRWwTmQwH+vgB28XSBZaS5HbxI+czCiETNDxIY2vYLjcwd/beI7GFubt4qFG9azd7llvdnom4+33I4dvZDrRrhXowaZSzD+zwILPnkU5+SnGCsuO6WnD9hJ8WMJfJWPMfHT9zqPXq72hvr+45oO0VSmcTR3mMN1ipA98kYL830apa3eTTzPwQusHgJOWX4/cTERmxrVn5nJD1mJ87j1daDjq8GpRKNiETPMuIIlQjcuYLFXN+6OnbH06QbMJw7Nvd
 8MO+Sy8P
 FalpOcYZvCmgYw5juSwrNFHAk1eF6NI7fQNozhi/paE7QXhqgRYe2/W1mGyhgEDjrnzut6ON3CheJtCQZ+h8NQCS6KpyUowQ3BdLQK078/pNqsUjh1+isBOB/tBelbejDYpCE0yg+MTjL1gkurwPBJey5y/tWBDwctFEYAPOQyrRh6OH0ueDQwwR6puI1b13Sd01vBA+gA3V7T+i/xXq7oRj0Vw06gpA27eUy+Wxh7Z3zy0Y1aUQTzmbkatVzcdiDCxyJBqYwvfiG8oKoDE+5YpskJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 01 Nov 2026 03:34:41 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> On Sat, 31 Oct 2026 08:38:58 -0700 SJ Park wrote:
> 
> > Thank you for reviewing, Aveline.
> 
> Oh, looks like I forgot that. Thanks for the reminder.

No worries!

> 
> That also gives me an idea: maybe I could build a modular tool to help
> write emails. Building on b4 might be a good starting point.

Sounds like a good plan!

> 
> Tested the non-root skip path on x86-64 Linux with Bash 5.3.20:
> the exit status changed from 0 to 4.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Tested-by: Aveline Noir <jm5905938@gmail.com>

Thank you for reviewing and testing!


Thanks,
SJ

[...]

