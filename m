Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D714106ACC9
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 16:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5776B6B0096; Thu, 12 Mar 2026 12:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F5C6B0099; Thu, 12 Mar 2026 12:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486006B009B; Thu, 12 Mar 2026 12:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 394F36B0096
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:18:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3C5E13A821
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:18:07 +0000 (UTC)
X-FDA: 84537917814.10.B298F62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2E595140012
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:18:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JR4fq5ey;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773332286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sdcAvQYluRsHiaq27HB7UHGVzrwV+fXvIHwcGJQA/GA=;
	b=PRR2rScIgzicYf5EA7glqSrVSeLFqhCWgZ0TxI9XiYMyrIUI/yXN9+bQY2YRdeMmuAPa5o
	LEfkk/3eTqOVnwtYvs7ThAQ0kfd5eDoU5VNycKHoJ8vGPHdapIIJmquuwHvK3mPj8DM3mE
	rWTq/5JLsSdWV3hZiw+rGr+cCiPAd0o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JR4fq5ey;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773332286; a=rsa-sha256;
	cv=none;
	b=rTksC1w0TwI35Ge6NBzb45la3/VzGP/VSRq4AnQ1bnW1QMC7Nnkox+XMHMf9fzJoudQQSz
	zSpg9I46cIwruuh1soA/N7XWCFyZgCMWYTta1Yuvi/0oT9Xs3/MCsqpLXvtLbBw5iipik2
	tICoNn3fkrqpILR3ZGpO0EEykY1uq+Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 68DCA6012A;
	Thu, 12 Mar 2026 16:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F6CC4CEF7;
	Thu, 12 Mar 2026 16:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773332285;
	bh=9aDhjOigL7tYYsWcsq6290598xav89KKBwOignR3TsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JR4fq5ey+rkrl42f8bTNCih0k4suiLD3rhGCe5CaADR2yCeiTLNLx4GkxQXgTyu8o
	 spccig8j7j6D1GH2FFsP//yuaJiSow5CXNeN0dv7br8TbEXK3f/RE2JMmeFXqf5UD+
	 i0+sDclWL56hy8NE9sigfV+gZDaRMSPHbLj8PbfgDaNfeI3RproqznpBet0J3a0Fby
	 YvUnaFCvM9YTcPHUmckr1rhKLcCqFCtY0Q3jr/dfduHb81ei8jJXEIfar98VajlwU4
	 By24JEmRJQAscmxF+y3ezqte4BIJcr80OKtkD4Os2MAxxpMFVxCjk5A5EYjgJVJTsS
	 Fik6r6HrOCo/w==
Date: Thu, 12 Mar 2026 18:17:57 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	usamaarif642@gmail.com, SeongJae Park <sj@kernel.org>,
	kernel-team@meta.com
Subject: Re: [PATCH v8 4/6] kho: fix kho_in_debugfs_init() to handle non-FDT
 blobs
Message-ID: <abLnNbNCZgMNtKS9@kernel.org>
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
 <20260309-kho-v8-4-c3abcf4ac750@debian.org>
 <aa_0OESNkyp8V2eF@kernel.org>
 <abKfG0w7frLldlfd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abKfG0w7frLldlfd@gmail.com>
X-Rspamd-Queue-Id: 2E595140012
X-Stat-Signature: 4bp4s973896jt9w9juj1b75jc6znhp7p
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773332286-791146
X-HE-Meta: U2FsdGVkX1/D+GGn0JhQ8tx1zEoAyYPIDQIGeEDJTfEXhhJjSqHg6rgS7TGR8jVtxOHnqNaRDbISZW5b0B6IuO0OFgrnAJBGfXTAcpVFYcXJ9J3DoSCayZlBx+IYHvHaoc9ecSkPEI4yBzihVFLwHcbJxyEHxU9UE7YTLa7lxAHyQbp4XTDyEOt/8Hs8ZQDXBVbcHlvLTtoDAudmtYAemvjYaonQT1z7F9fQE8UBrY4sCYonpQ8lewjr6swtXn1mXIK+u9sDPs2MnoBdQn8PbEqisbWq5krJ23ULD5DjP9E+Jb0XmnSHdb+2Y4j5xaDLLUAd3iBoNr0Lt+wmyxY84N0pWJto4MG9H6IaValzXharHuVaBpGZTbbbXRHZRSu6jHF9B0tcxLjjiHM/qoFyeUIRXwjhEUk5qNb7VCkzglXlObUA6yCOuBNkeO5Qgk1quZD0Eo9Tpae0TC/UXZouCGm4RlMKln4axtmhf/R0Ay6eF0CV88Qi1FCNwiFLO+n7uRyixR12iz5ICQ+bDcvHio4UjEyviYIoGk2/syLN368tj4lQ6RNgzHj0oOykl0f2MDVjOuUj34frqSQzc/4WNTaQMoL7LguavI3vFRP3CI1zQPapDV1lBI79VykQGmPIScBK1a9xrfqCZMqMe4/3OJDhZZJkBnlGKrkJDYLqSSP5w8Zl6zAh5rpbKyzzekO1u6v+nmrlHACbxibydbmUUPJAQAjFI3A9ayyOvRe5z0zXTCEDlYcJcT8zH+Wsq73LVXItXbUotUFfKxeJ3ezoriLn7f9uoKvqUz3KHi6pp+fFvMJCOO2u5oqmO8OMNUlveqxAxRQJ7honHS2PMoucR+rc148FeXeWbu+HSiCSdfL8eNlvni3yTW52IPtrDtkyfObzenOdJYtzuFyDp1p6P7Kn5Y41koIlwX3E7/pW/rhn26zQ8ENwBT9J1OupPDLmxqrAZCdUgx0Y8RFI7ig
 8XEhVp3P
 p8IuscUZY7MUfaM+XzAIrX6+kUDLyCnjk/4X89l6jDM8GAKflJUNvzyOgIkBE5kFBKHhLM4N+Jnq52EFxMzNGIij5YiztNt98E5Jh3Zpp1fxnukGw1jTXn07AhQQ2s41LBjY1vlLtoBxxD9pr/+bn1qabUk7TRz1VGXPbIMCAzfIjgOoVmcnCBZL0/vrgW6M/wmCtInBM8kwIy/4Tw3kO+qSmW6JBdA9lctaYYdstGc5ygWRDw4sfFCJRP2fqz9H6Xd9fi7AW7lwZv+T4f1fBxetMBu36jc6omu8BhoLHPzEhfpE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On Thu, Mar 12, 2026 at 04:11:54AM -0700, Breno Leitao wrote:
> Hello Mike,
> 
> As this is my first contribution to KHO, could you please let me know
> which tree these patches typically go through?

KHO patches go via mm tree.
 
> Thanks,
> --breno

-- 
Sincerely yours,
Mike.

