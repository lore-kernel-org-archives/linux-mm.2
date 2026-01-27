Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 836E0D2F030
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 13:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E2E6B0088; Tue, 27 Jan 2026 08:49:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1BD56B0089; Tue, 27 Jan 2026 08:49:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C486A6B008A; Tue, 27 Jan 2026 08:49:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B35F26B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:49:22 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2FEE21AF3AF
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:49:22 +0000 (UTC)
X-FDA: 84377875764.08.2BB5B19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 74499C000D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:49:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MD1e38zv;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769521760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v583eHnTwoCH+F8AamuT/Bbke2sGK65C0yaEYwfFzCQ=;
	b=sGDyBD4tsvYwToq5ATfYQIybsG4BGZXed6pyBlMevyh0WUZeV1y8cuZXRyu7CqvvkzPAGF
	m8qLPu26qM3uEQ8PvLT+hNj7zHbT/ifosKIneY20HCqmUHrQJpypyiu6NLa9rE45ykHvJU
	pqngQsP3tZkM6iYf8AUZiZqSXhR7yL0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MD1e38zv;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769521760; a=rsa-sha256;
	cv=none;
	b=qgC8uJ8kbTDlDBfImnonwSlxWp5uHOEjuL21IYbD/age5g0mZQcisoqzxCMjH+mwx/60o0
	8iqEk96IsFtBsyRKhSB2Lqr39Gsrha0QgQOjxO5+EuwXPtBxGo2qrxDM+Fhx8U9opq5GYq
	37vXv+JoajOcd88d+esZNoNzaWIE7eY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E78640ABA;
	Tue, 27 Jan 2026 13:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88994C116C6;
	Tue, 27 Jan 2026 13:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769521759;
	bh=SeCn7f6xD6ig2/TTlxQeUnXATuwToDbHHXsGspeI9qs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MD1e38zvow7+Y1gKwI7+ZJ6snWq4hCJWP21MAyKssd+zbq2r3Jjlsz8+Pw8Avpxh5
	 ZV+OeT2dolwEZx5v9hHkRvFs30IXTwdWpfU2wTdXO9B47zxsZLR6uerz7Rt4A4pmt5
	 TVE+mjOxAL1lxuLnePfSa5NLzV/GgjOfGE6qGuTiJTgRuuag/dhOyr5NmNXFKZ/6LT
	 LlTT293LF29/Y1df7/Azw/9J1Fdsl2MPgHtLplsEyBEpBxaWb4uEUpb/b5e8B2vMJ7
	 Los7QmMIBEuH8JKC8mcJNegumoygW1S/hBOxv6KLee8NjMos4KFbfoOmDBEc4Bkk4z
	 0FMDBArgHv9QA==
Date: Tue, 27 Jan 2026 14:49:16 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/3] mm: Replace use of system_unbound_wq with
 system_dfl_wq
Message-ID: <aXjCXHFHQHxup_ua@localhost.localdomain>
References: <20260113114630.152942-1-marco.crivellari@suse.com>
 <20260113114630.152942-2-marco.crivellari@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260113114630.152942-2-marco.crivellari@suse.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 74499C000D
X-Stat-Signature: f63m8mk99xmk6ccbbxmgwbae8cuammp8
X-Rspam-User: 
X-HE-Tag: 1769521760-512007
X-HE-Meta: U2FsdGVkX19RqZM+5ILuO51k0DD6Vnsa/Xu58lTgPmx6xcTY5qskR6uDc06rmyY69GPsxEh1OmtA13dHofwKUuDL4W01anDajNKm2kxlzjdUhBL9R5gllXvTiiyCaxBCxoaMlfcoRzVZoJd7bDx2BhPCkLXaGsD0cTln5vub5Mt1iKjn55vGM2cy2b1lFULJ8j7lW0whsGGey/05e5+b411yBAuYGwqhrRvPDplbdhnMHnfGecRHOmgPppu727Uf+YorTdDNINdZsxDPftHvTBGebzIv9Tdwp+Axnt5iBf7/bsQmvxyNXARtq96SGbax2dIH80kYKGiGnu+yLqOA7T20TiTX3Ox96Vcqq6TFGpIqPj+Rzh0BrRgzPXX/e+6P0TkWwXOR5/gDPo3kmWlTX4dCxrptsHTMkoBZbXFIc5ikDmM89s8L7qxzVMTydQ9h469/MKtrHJ3qqoJTtnoTm+KYK+a/5kbgaIK3n46TqWnJRKcBbVqBC1Jo+Kpa/r3s2KxjWOWH0PsBQtbmGFBJRbPW0nL/uWLzTPNBhuyz6rF09g6e28aViYssQcXZlY4flt1pJJmIzwIphxI2MU8BLWOk2ngpPg7MTIwih3hOO7s4Tqs34P9zDN9xxyr8rax4n1/BBB2fFV4nz83uKRvo1LLHXm0N6aPLwJz2Zqvj6urYiCxg8L9VzNAc2upbogINMbaLhvn8cNgvyLDAiaTyhl+edd6RtZ/G61a/eH4NgMjrrKf1ZA09D9H8OjOKAPBrC8QbP+TbCB+i4UDr/kORmF1DYoM2QWRLb6gnhY/Ex0doA8xukh9skiW1F++UZPbNn6MUUgi4HnLl+kuLkZ2KpHNGdcfk7bjf5NLGTfhq7wMOAIlOEFPt6FDAcan/niOJ3ckliYpvv71W5t7UyUVCfflj88++WjUUH8lHmGAzAf4LurYTH3khqKA0+eVRe1utryvMPvLltP/Ge/8Mv/Y
 oQhKrpmC
 s4a3serJxlNbiDGf+w1U6fIsw2bYYJxWpfgF0HFsjDTLpsdJ6IW4+o73oh5Kj33XF5NhJ6UWpsEJ/VISOddSfgHFE2G/gNFeCx9WfD2Y0Cv+uJf5bXLeA41CeDZbCZjn1sRPOrfZv1+uyY9NsfwudGv8JKZelChoyS3VEJ3qPVbcE9qMlLSAw3/3C+z4AdFFuJ6E4MdnPyjAqW5FHzGalXDVQF6QxlUuO8yfVchYlQjihtnYy5w8fphgvTXh11N0neJBb6jA8LYNmRuQuB1DeH8kprVdqPTb+apPRiNx7Eiaj72oZpIiu7NutpUCYr2fWlgNaVr24kHi9PLgIM+agMLXMnPl9hRC8xa3pY9/V2bHY82U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Jan 13, 2026 at 12:46:28PM +0100, Marco Crivellari a écrit :
> This patch continues the effort to refactor workqueue APIs, which has begun
> with the changes introducing new workqueues and a new alloc_workqueue flag:
> 
>    commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
>    commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")
> 
> The point of the refactoring is to eventually alter the default behavior of
> workqueues to become unbound by default so that their workload placement is
> optimized by the scheduler.
> 
> Before that to happen, workqueue users must be converted to the better named
> new workqueues with no intended behaviour changes:
> 
>    system_wq -> system_percpu_wq
>    system_unbound_wq -> system_dfl_wq
> 
> This way the old obsolete workqueues (system_wq, system_unbound_wq) can be
> removed in the future.
> 
> Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs

