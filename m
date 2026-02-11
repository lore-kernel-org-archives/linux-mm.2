Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE494EB595E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 04:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA8ED6B0005; Tue, 10 Feb 2026 23:45:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C1B6B0089; Tue, 10 Feb 2026 23:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37D56B008A; Tue, 10 Feb 2026 23:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD8946B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 23:45:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B3CA160224
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:45:44 +0000 (UTC)
X-FDA: 84430937808.21.5299A56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id CAF7710000F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:45:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sdFUGL+b;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770785142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYPhNZWTPLAYyMFW//VtlVG6F0J9OS/HOjl85dVXej4=;
	b=X/FVLp9EO0ISVggvFkQKzF8H0D3FlxoKfZiuKzW+HJAfAWetQB9hVdu2xtWzYi7tZUwkJr
	NsCZA9+/3AKuxSOGzMroyEY4dTOq6E+IGwqbrXN0H0YZvxp7LFnYcnlpf4jafZ7P4yoC+N
	gmhmGWwOcxqhGdPsgFwQceVdYWPc86s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sdFUGL+b;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770785142; a=rsa-sha256;
	cv=none;
	b=JvYPveFInbdaMLPTMgY+IDXf8diBSoYBrWgsYKkiIk6NZWN1Z4kh89nAZnNJJCaX3W5bBz
	bAYbOdpx6hYjE71PdDbQZSTU6dxWUMCzmXqrUPvO/W2RDKEQa9i90YgwzO86UrLx7AxiK0
	EV2lcUjdjO0mnOu3KaB90k74MkwLp04=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16A2960130;
	Wed, 11 Feb 2026 04:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4D3C4CEF7;
	Wed, 11 Feb 2026 04:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770785141;
	bh=E5hH+94BQyQzA+weVXnVfrJGvZPLtKrpyR0k8/5AQms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdFUGL+bB3yHHLYGp3uRMfz4GT7WL9dcbyIhwyKGHGPChZv0av4AfVdCHTTG37oz8
	 XAs9Rv3JJJF840+0yCqH9Xp/Nba+Dsr2ATMSpCX0WCAuXg2Z15JdA8HT947N0vmijk
	 7k7dDib1TEcpcKgoKLUsCPWVpjjZZmXNXBIxAMphwen+pH5L6C2ctaCXYO3S42v+DT
	 mDNYxbRUorkKD5mja4kEqAlEfnKgYcr6i+ds6O4ythHzcoPegrAlt9fOeyb1RkuZQW
	 8thUrMqc1oiypWWYtoZhDLeol0M+Q5QBL2mN1HCpHbTcwEnSnwnIquTTrmCUcSPJse
	 bRawS+CdFqTyA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Data Access-aware Transparent Hugepages
Date: Tue, 10 Feb 2026 20:45:33 -0800
Message-ID: <20260211044533.69515-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260211022845.68865-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CAF7710000F
X-Stat-Signature: jesm8e9qrzprbwypc73rfkospwmsb5qm
X-Rspam-User: 
X-HE-Tag: 1770785142-458820
X-HE-Meta: U2FsdGVkX1+2PoEuPez8fQKIW+zf6BOMmSh8+w3zXEdNHyj9uvQDVB/ra1Zz2aVb82YO50zdDSxHoyADq6P5PqsdVKJLH2CU3ISbwjwEtyfenzG7hE2neq8SJTGPQJkukcgHWXn+WxT4SHgMqF6Wnattbs7HBEY5lShH3a/D10jicsnAFAws6qIcMIK416arn8W8R4EIa625HLtK+ceeIxwcmV2Nyhlw3YKc68dfcASVDZ2IUH+0dZ9o4A7HUzv9MUstZvrdK+FGN5FLZ2DQgzhI0HVMfhqJJseGPuG6vsSO1dgDxgoYjF52DszSiywZsRtLDYPrMi0W9n8y1OMR+4GRW9pzUaP7nvBSrxXvyyLrDWe2uy3GQnVQl/XK57My7dVKKZqQaBwD3Itmd9eeISzt4rbhSmiR8rE7Ee7pYOnOXlMJ73LhS1ScXciAiYRziIvL/kZuNM62yPcd/kuW16LGOe4hFmuMNwJNS64+d6UhC47v4/NGbz2bmdqTEeFgGSG1zs+aiPA62tIOxOmpM9SpQ/XWjCNuUtfHARSL+S73oicTddMascgnqLY8k8I13VdriL2J2SwOQzHnVIChH9N1pSSeKmi8y32jJapgIeEmkOEttCmrZns6W7pQL7zmv/D1TWqwon+42tynX7cE1wR1KH7Pz4LEd1H7bBaJVlh5XxJkQBaPCFSJZh4lxiU+aYGIxNFPTYjEc4t/O6wItcx7txr5zWuwZSBMQ7Q7hLz+hCbI414d9XB9Z3egijbvLvJkph8OZKDmJ3xHOlkKb5kv3d2r13NfqZurznddARv7CQRoOsa60GALCWYkd357hpGTwVnXCH4Cr/AHe5xupTxgSpqm3c/Iuoab+/75xr9fXcYfUH3OooEbD9aYxnNhsCmj3WrVnW3xpqiACsg1iScLOUAgsdVRMB27MA+dBdenfdXNSg9sBxY0SFx/RGTCeBQC05yvNAXi8+kLzR9
 NmyxWDP8
 /bMHwyfBivgG+Yd5VpuKK+tVmK/sHCIUoUu6BhP010j2CUV7WrIEFvt996IPLxcals9sZmjeGpjs0qTJRo35EHIi5L7uiAcnPHcqPwTwMx3PQQjlqEbCCe0ie45x8qI/hNRL6NPlQS/OnjzDXHrcDDRblkWc43Y9LWlzTOhwD1tMMqGIFcDgkawBprRP/quNY7vvtNjGdYX5iGbgkaaF+zBuiaa77id0HvzKlruCk4re8beu5ZjpNtKWWM+wBP/+iiisZx23bjY4OHTk2XDlSA3fjk87UlOnJN79YXVQdWDqDIsBadTJ/87jBOwJlGmkmeeqjp/ESh2AUk6CkyNMJ33lVMSkVmEI4YMN4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forgot Cc-ing damon@ and linux-kernel@.  Adding those.  Sorry for noise.

On Tue, 10 Feb 2026 18:28:55 SeongJae Park <sj@kernel.org> wrote:

> Hello,
> 
> 
> Transparent Huge Pages (THP) could be more efficient if those are used only for
> frequently accessed data.  DAMON is one of the ways for fidning such hot data,
> and hence there were interests in utilizing DAMON for access-aware THP.  A
> simple experiment leveraging MADV_[NO]HUGEPAGE based on DAMON-identifed hot and
> cold memory regions was conducted as a proof of the concept.  The experiment
> demonstrated [1] an 80% reduction in memory overhead while retaining 46% of THP
> performance gains.
> 
> Multiple discussions for further developing production level access-aware THP
> solutions have followed.  Most of the discussions were made in private, though
> Asier recently proposed yet another approach [2] on the mailing list.  As a
> result, we collected interesting challenges and ideas for the production level
> data access-aware THP.  Some of the ideas are not yet public, could be
> controversial, and missing important things that more eyeballs can find.  I
> want to discuss those in LSF/MM/BPF to get more ideas and make high level
> community alignments for next steps.
> 
> [1] https://assets.amazon.science/b7/2b/ce53222247739b174f2b54498d1a/daos-data-access-aware-operating-system.pdf
> [2] https://lore.kernel.org/20260202145650.1795854-1-gutierrez.asier@huawei-partners.com
> 
> 
> Thanks,
> SJ
> 

Sent using hkml (https://github.com/sjp38/hackermail)

