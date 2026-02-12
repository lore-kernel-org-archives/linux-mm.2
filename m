Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B952EEA845
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 18:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52E06B0088; Thu, 12 Feb 2026 13:58:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00D46B0089; Thu, 12 Feb 2026 13:58:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903296B008A; Thu, 12 Feb 2026 13:58:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0DA6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:58:44 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0CAE1A02D7
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:58:43 +0000 (UTC)
X-FDA: 84436716126.27.691A923
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id E068A40009
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:58:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770922722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FIrlDrTT7Y3GKxVtMOsUI07eABSCR6OvqGrnLzj9LsI=;
	b=mrmrzV050/emVXOEDgx5o01PT4fnK9pgrG/6gFgC0mvdPVht+ZcgnNxP14UNJd8ThKoHyn
	6Z/KCkV+uBnqQ2PKZHY5nUo/JHwCG2Dca9PkB4kgkcVLOmOy9RqI1T0XUFsvky/RvgRF1N
	5Ck7g70AJnSCDf4VU1cDBfBdxCTfO70=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770922722; a=rsa-sha256;
	cv=none;
	b=mryy2qxvGqPu2oMrC2R+vG4f556R6tmH7vjQVkJlAKrN37IAwQjuyA9BJ+9kb6WsIg6Wdx
	29aoYt/PtJq282pC9gwyb+6mT+cnP9R9xt2HVJ7qW056IRtgg3dRO2KSltx18V/QKCQP47
	n1LHl6gW9xGP056exDsEaC06dQCKJ9A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACE9D339;
	Thu, 12 Feb 2026 10:58:34 -0800 (PST)
Received: from [10.57.80.130] (unknown [10.57.80.130])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0C083F632;
	Thu, 12 Feb 2026 10:58:39 -0800 (PST)
Message-ID: <de5d90b7-0c64-4a38-8abd-66a43800432c@arm.com>
Date: Thu, 12 Feb 2026 18:58:38 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
Content-Language: en-GB
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Yang Shi <shy828301@gmail.com>, lsf-pc@lists.linux-foundation.org,
 Linux MM <linux-mm@kvack.org>, dennis@kernel.org, Tejun Heo <tj@kernel.org>,
 urezki@gmail.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <5a648f49-97b1-4195-a825-47f3261225eb@arm.com>
 <32969518-9106-363f-8a89-479b8246e4b1@gentwo.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <32969518-9106-363f-8a89-479b8246e4b1@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: ddw5cicgatwejcb8atoogyhyt6368fkn
X-Rspam-User: 
X-Rspamd-Queue-Id: E068A40009
X-HE-Tag: 1770922721-35573
X-HE-Meta: U2FsdGVkX1/H3zU2Fy+VGIWwQURzqUCoH4VM4xrPe84EdvBR3lIyD58G4uxOUjLfy7hZqyY+taR/66d5n2kFywHrqat3pmA+N0rYPybEJ5LCtCqVE2fUSAIiSY2E8MO7uq5C3FSQ3mQ8QgQJ5Q56gLie4u2348G2oVJOamB5zDGx3Qce7ynPbgg9UsoBELEjEeM6wH3VWX5wCELIs4+5bbb+zF+WYaK97VcTTZi1626MH0KLZTgS2KYgail/U19kC7rCJyKAxVkurPdAtLFdTyaIdDZ3tmgXvKWG7F7NgJ6uGtNRnss1jasBnMGgOmnPX8QSpXq9Ok8qozFV+m0787Z+y+pkiJU5PPNfA8W5snNwa62x1bfvm9DrozMJlPJhB/mPb1v6shnbWkf4w7YOMqRDpk1W2nwmUOe6bu8eydQaLk3/PTM9/zy0Rg6i0BLKNVg/bmgHTSiva2GE+BIlNpEBlA8O3/Y24QxI1KRMvPQXrLjZu+7uVqXbGMqm5eKqpPGZ8wAHVKwWK11UI4X6PbvzsYoHFerOawx8OvkeSv8eqnh8YMXudQ4/33VOhpyfECrE8BufCQbFfgh9zP4a0xHFFGTohNoLwtw9ncufc7UYImM+u3ZxFm9rYlqYqbghaLwtVor3paGCAC9F5b0xbv0+yrN8x6B3y/3JGhYu41aHaH9Kv2JaKSbUT1L0GceEcMdNN6lH8DqbzQqq6n/hbCXVLWiH8OSFt7SrLLcJoLraTSyVgP6xnL0LR2DlSOs2GPuY30kBSSkvRtyWrk4UqbSp9R9jQK7kgiK5q3takIFLUKBDDvY1Q8+iUkWn+7K6jobvDWT8S3Auw3u30NsAjVp5Mni+HVe4dKIYETjZiaDhrEumKFLt3DYbdyf2BTp0mLjc705DFrNC4uNjWgdQnuWReyY4dfuKt8GvKxsZH2jzz91jaZgVyTLOC5moax5nJXPYZQfdnebLwLUguA0
 abEuOaJf
 WYn3xS6GfIcqNvPa6/KVlBMTxXiBQT+7tG1S8kBKCCmIN+cGjOt6TgasqpufMzaUJ/vpRdK34FsNeAZXlSOI8x4y5zhql/vn3YMea8/QO1EGyBl75hlBKRoiBH2Tt/we5yf2IbcQMBgNgfdlxXjYpBnI78/5KojUSgK1ocTfMC2/U5KsIsJzfV6YT9QIDi9Z1BiSsSUmZ9dZ6/OCj+IEV2jWwJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/02/2026 18:55, Christoph Lameter (Ampere) wrote:
> On Thu, 12 Feb 2026, Ryan Roberts wrote:
> 
>> This is an interesting idea. I'm keen to be involved in discussions.
> 
> Note also that the percpu kernel page tables that are used in this
> proposal will also enable additional performance optimizations in the
> future
> 
> - Kernel text / readonly / readmostly replication for NUMA configurations
> to limit the volume of cacheline transfers across an interconnect.

I'm aware of Russell King's series to map kernel text locally for each node. I
guess that's the shape of what you're describing here?

> 
> - Per node memory allocator to optimize access paths and RMV operations
> for data that is NUMA node specific.
> 
> We think that these optimizations are especially relevant for high core
> count and high NUMA setups. These may be inefficient right now. With these
> additional scaling improvements more distributed SOC designs become
> possible.
> 
> 


