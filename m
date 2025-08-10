Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85A0C87FDA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 19:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 449186B00C7; Sun, 10 Aug 2025 15:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420ED6B00C8; Sun, 10 Aug 2025 15:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35DC96B00C9; Sun, 10 Aug 2025 15:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 263F26B00C7
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 15:32:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7AF69C040D
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 19:32:34 +0000 (UTC)
X-FDA: 83761844628.28.1E68FA7
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf12.hostedemail.com (Postfix) with ESMTP id E076640009
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 19:32:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qph/Chm2";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754854352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2bNPkyCODFzXmbjRr0Tn5kBVqgc6Zaa3q80s0PwqQ4=;
	b=fMebR8oDRxFHfo0wP+3+MnwX8lHGOec1D0O3lmDL1UkZ/ESRpngQVUkO+80VC9rLdgKM+N
	qwsUNENNQcAG6QCZlzfk29ZimTOO4CO5+qpKbickbOFwYyoZeS1rmHxN5AFC1+gDQR33k4
	FGa2r0wMucAvZzE6DQyN4Kd8Qpt4Tzo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qph/Chm2";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754854352; a=rsa-sha256;
	cv=none;
	b=Fk44ffkeKHoX6sMJlZGhmD7O2D8wsSn08Nis2FuQPxeooq9ORCnKKxm2zOg7KeFA8nd/IZ
	NBLRl/XN7DPeeuJ1Q2GDLgiX67QSPxR+sm4SWXAkCpBR1ZKZT2kseEfqomS8ACuWgH0lkc
	+Wnw3jMvX06JgiqjSGdTOqC87N/jw9c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 164FBA56765;
	Sun, 10 Aug 2025 19:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76474C4CEEB;
	Sun, 10 Aug 2025 19:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754854351;
	bh=7wFxe8f/K+rx3+UiMfHpQ9dhNKDAw8Dtp38fU8iBzeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qph/Chm2kmd4Ejz4y09GSDvWAbiq5rHvkeIdIqzwBUvwqnBN8hhDZTehzmpMDkkpi
	 AkmIEyEFYsqs2qH86ZtTxZUF6TUh462rSmZ56kGYOxJas+Mc7dnZ0q2ePNHZDpJwFC
	 MHP57tC8dewdMofXGcShbSvJuGZLdY33KFKgAtRBE/vgSKCdklPp7FmOt9DwHdVPi3
	 3qMs5sCgLzDmd2LsaeO4Utpt4TeQUobci8HhCsCdLJUlAi4jxdExKRF3crWD3Gck+o
	 uo1JWyNU9hfyOOGe4VP4UanlgAi+VH94RfxWiL3eKTL33JIDEW22SYqCztRCwUdFxA
	 L1aTxCjUKXfhA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3] mm/damon: update expired description of damos_action
Date: Sun, 10 Aug 2025 12:32:29 -0700
Message-Id: <20250810193229.51219-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805173205.7385-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rw5kcbw86q61tcrcg4f4hza1aa9yd4ha
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E076640009
X-Rspam-User: 
X-HE-Tag: 1754854352-771132
X-HE-Meta: U2FsdGVkX1/pQCY992muv+tAoTHh8XWbP67zQTPo/+KHaTVvG9Vslxe4G1ATj2RjXOt3gl85mulq5EaNXxoQnkfS15/sAlxBv9wEw+SUzBhWswtkEVvyVfAdPIuebzTpK3LKNTKVxYMTR41xGDoCWzlJobCPaf63s8FHZjh9N4UY4xnDH8a0gq0Ts1BohVDEAEqtVQ4T4w6n0IElLFy3FkLrC84MbYvDjPCeskTMd7diYNH/LkfIOOnex6ully7dDKfzbKtafi8sG5KGamlRQtgNSOBm+cqpCiWcU3mcLTlWImyKrI4IWFrp4G/AZYoBAt9vJdv85wQlZTzt9qi9iRCyejVkSYSQUBAyGlLAeofp54Lh/3YnLIssIl5zaQ+nAzCuRzPfB9efJKMBF2dRquigbCzFIGVAPN649EDzNkfty/cwqiUXv2RQ3jQn6KympMxOM5vHhrxTJ7um3kTz4ySXkFHrRRz9JWztnt4zpRmcIAGMlpDD7AsX92Inlijy8RnrJsDfelL2F+HHGcDwjE8F4CLqCZ6rk7dkkWLVgVoqjPZG93vCAh4Rv33HO35PF4jIaYm8l70R4a5t7JEQxt3N7bC1hGA0Aw7hz/sr/EyepIWpWRXEe7RmrNsu9lB4XD+s6Yb2cVY8AG7CsKjFtPzQkZbs4gh7IPzB2I5K5t135prycyukvaH5RqPhgqy4foizpYmkJROQG43aJX51oSBSqEX6+CdGjFqtbkKgvAasJXWgbbaoFK9al6Yvm4eXa+0bxH1AVxKTI3VotnhIwB9yhPOeeY547o3b8u8nCm9dC211c6fSAj4Aj8KF1/CvS8NSddGKdCytvRYSYebZPlcuPq+nll16Je2YpC0q0xPYGK34MsLNyf2nGP2zuqBh3O4ySw8RgQWdYr2W0bpR7WyYnbSyo9wWR6YHFfzGikliaGksj8epKk2LVyJ3xtMPal7OCPChxauX1WsKgd1
 250JF54I
 6T6qtUfC8CgIyPAz25CRwOUBq5Rk0hoaG5nBWsysT75RVqQAcWe2C7wBbzVCR1shbSUeWHPvEIf4I2xntm4acvOwBXs7o/ez1fntJw6jDnxjXGDbKq/lOsSeMveTQNPaPWcQIleEE2+v6cFKnVpgOcleCNUVMZ9SgHIOs33AjKXqkIoKGCNTB/C06dacx6rZWEfaOriE8mFBVxZnhFueJqpiZD1lWB3XEsVn2EWhZRzSPdLm3fJV6FJ6OMBEpmHuHl+IawdaetgT86wBIHPTv/QgDAi/wnDL8Yubs/x1RrzkgoIk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew, could you please merge this patch into mm tree?

On Tue,  5 Aug 2025 10:32:05 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Tue,  5 Aug 2025 21:39:40 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> 
> > Nowadays, damos operation actions support more various operation set.
> > But comments(also, generated documentation) doesn't updated.
> > So, fix the comments with current support status.
> > 
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 

Thanks,
SJ

[...]

