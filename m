Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC37FCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 16:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 190778E0009; Wed,  5 Nov 2025 11:20:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168038E0005; Wed,  5 Nov 2025 11:20:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4D88E0009; Wed,  5 Nov 2025 11:20:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED3CD8E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:20:49 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72256888D6
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:20:49 +0000 (UTC)
X-FDA: 84077067018.18.CB4C09F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C558D2000E
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:20:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HiLfEowj;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762359647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=stxcgJFM7XAuSjQbOIOh1iIf0ZpMvw60UV2xtTfCjKk=;
	b=VkAbZSolpE2GIRYaWj4idkjhofd6hZwqP4wbTm9jitCHb1w7FZyZuwSF/YYaAZKWJp1lDv
	4pO4QD0xTuCinxy6LsjEL0RSUIRAohX82WdZrPionq6dco26CqKidhSPcVBxi3n0rrlGje
	03Mj7yS3G0i/cjVL5aA3SwkSHsXPgGo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HiLfEowj;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762359647; a=rsa-sha256;
	cv=none;
	b=t6/DSIMXqQZDZgkmlCblKp/K8zbvtwWYIcGoNB6uDyvE55LH0/0kKvYlUeB+INiOWoUwhd
	DTNXZO2PX/9z3/VN8tEqV6uBWv+qi6L7pK4yWxIWwVKh/m+tl14IFtSepeZ85z3pVxepxR
	n4tgJ8EHYgQbE/bTTRBbm4QCLznhJkw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D073E4032C;
	Wed,  5 Nov 2025 16:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32444C4CEF5;
	Wed,  5 Nov 2025 16:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762359646;
	bh=HORUZlleqGnWgVcZ+zlwYb20knRrXuIZGW9gxPsBS1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HiLfEowj7vPT6Pl4dqLOpNLY19tVHGFP0v47Tp5DoiLPK3xnsdZTSTMYbQBZuDYTo
	 O8ghL6BtQTDv8INj+VzQMymaj/H6sDCtq2nZ1z93yqc/wAajbl0PM7tSyFsYTz/oVH
	 c8csoGsf6nUZsLr93DkgsE+Cs/pZZf/8MxHEhKtdWeWCWhSg8sO1fmV2EZOdjzsLTO
	 H7H0v2Y693fEb83TENOJX76XqlJgw1m/0x88JXsiSnJDU06mdLum59RV1AgxSyyYbj
	 J7MczXFdDh7ckB3jsb1hJrEMmddJbXEPtYbA3ja1mjnnM9yqIi9xRpUsUZ4UKN/XOw
	 qCnVKl+dXmmFg==
Date: Wed, 5 Nov 2025 17:20:44 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <llong@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 14/33] sched/isolation: Flush memcg workqueues on cpuset
 isolated partition change
Message-ID: <aQt5XImgRtxYYt0e@localhost.localdomain>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-15-frederic@kernel.org>
 <364e084a-ef37-42ab-a2ae-5f103f1eb212@redhat.com>
 <a01172d1-d902-4d55-bc1e-c8234985e65a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a01172d1-d902-4d55-bc1e-c8234985e65a@redhat.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C558D2000E
X-Stat-Signature: dg37igxsaoz89hx7q4kx3ixn4jnpmmsm
X-Rspam-User: 
X-HE-Tag: 1762359647-821489
X-HE-Meta: U2FsdGVkX18Etkvay8+z7FNKaBSo1FN848TZn46/gwh4/kO53x+LXMDGG38T1O9M6brUAs+2UMxgjJ8XC/BZJtRgsGAiveoTu/9xEh7tuunSma+zvn802ZWgwBc7b2gm2US7l7LdFV8uiRak8f6iIsqrSx1B3AWc1XpuFdEjLJbvPr+6FkgrtNZlRz3nLuQRdRR/FODgYYLo4QLz/HWTn3bZ7OQJgtsBoRJVQbtbwqohZ4c5sLidd6jFRitz6770p8eFztEwPiK0G3k/qUdp9mjpXujNYtEnPmGO2FYTW88QdMyU5dOLYI9rtiO2OJXpVKbIhnC2oD21f534URCPJRQ0Ny961VeV0E8HPVEZ7lohb6lQFYNTqRWmsvRG7gZNTEmdeU776EFEabrgE/qkz1zmHDNQRnBoFSgaG4iyXvj4aRFyFk0YOi96Dku4zngz/BuNq1nVexPw9QpGN0JMch3SthG2LzLIUuk0CaVwqzIe64sj/+s118vKSOmeO7SQsiTMIsHjbqKoO+fR/hWYJ3+kp/Stb38astjs67SyUK39WXjli0hKISYaZgXxiQ9DeolGf/ZMYJVWgwLiRhvDDC/Z3OKZej2DaHzOMiEqtjnCwCpf6vDe8SOqVptJ823kqZfReof8JvOGtg/6Wiuuat55Ft95eHgIkhXu9wh5uYkaF2Yq2m8xaCR5T0uNo1fjMAv+DW5Hssv7Z/0A3X915qxRA2mx51EcnfOxA/2Pahx0Bh721amAzo3nLWrI+SQUsi7jWez1eloZggrzm2Of5qUBFcxh/68b9OHUXHF8/OYZzGWQSwEU2dadjtM1cbeKjIi2qaSkcA8axt/qYVVW7dtHIDxshA06OhU95JZ0A/fmGo21a+llJJwurf70lmHDYtfDTu+7lxlB+jcx626F24JOgDszEJ/X7pvNIGR5nqQUz9Er4pjrQBgJs9zE7B0MvjQ1g6C7BpR/CVFJxC/
 91bbgw5x
 0brPwEDH11BIVhIC+8C2S/xRfsiVFC0L1UvHRpTK8yOUMlIOOSdc1gLJ/zhxnD1E+BHhtvm7fByh8oy/wu6aIaoOm3JIPYqo0tsnfZp4QmdMSRKTWxZKmHLLHb1DMLe+CUz4kUR9KGuFi7uzOig3Hy7pyKEns5iXmErnVUKil7qIdcKa8lz+FL+Ng+/F2zjlb94J8OfB5WpaCijEZBLXTnZDTLcyrdOMHyQ8x5BmR1b7IEqg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Oct 21, 2025 at 03:28:42PM -0400, Waiman Long a écrit :
> On 10/21/25 3:16 PM, Waiman Long wrote:
> According to commit dadb3ebcf39 ("workqueue: WQ_PERCPU added to
> alloc_workqueue users"), the default may be changed to WQ_UNBOUND in the
> future.

Ok, well if necessary it will be easy to change.

Thanks.

> 
> Cheers,
> Longman
> 

-- 
Frederic Weisbecker
SUSE Labs

