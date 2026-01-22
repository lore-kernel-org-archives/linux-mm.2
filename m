Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82FE0D3EE75
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 15:45:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8F66B024B; Thu, 22 Jan 2026 10:45:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56776B024C; Thu, 22 Jan 2026 10:45:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83ED6B024D; Thu, 22 Jan 2026 10:45:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A62836B024B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:45:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 14FCB1A0408
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:45:05 +0000 (UTC)
X-FDA: 84360023370.13.44BA541
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 89DF1120009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:45:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Evfn9Bbf;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769096703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBH4OAZWQsKn81We9o0RG9SLqVKAoMOD64bGQSd1Cag=;
	b=M09X4Sub8j23nInAv7FPzG23cFPioDHxXHs4SzCXl9jg7z8EOLRaGfR1NzdUz5aMKRkg+i
	APzQcvxeCgcdb3+ruJzGCAiyBd4E2jTRFSICb+kJ2D6KwaiwBEiOZOWJnv9FzAnufIctuI
	0fQ+nmi7StAPWpiR1rycR025mfsLCfo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Evfn9Bbf;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769096703; a=rsa-sha256;
	cv=none;
	b=WCSIRiUpMl9R6olvY/dpUxUVUd5irHymbTvTsUqfPmRMWOe6L1qyMVFcHk73GPsZM1mXxY
	Qc/iJwhn1AW/cGZnt0sTyKO87c9tY+Evs15jCX1KZ8QK0YG3UA1pqqNLLIYs/YRkz3LHPk
	BzBBOqsMXe+43JX82JByHpT4+UX6vIM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D70E160128;
	Thu, 22 Jan 2026 15:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B3AC116C6;
	Thu, 22 Jan 2026 15:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769096702;
	bh=52XMBjtg9ukz4aelwXz5NWLALBx3/KQUBQRuzd6rRXQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Evfn9BbfvpGnIvAvt8Oqgd2YaoDCSTDUhz5V42CGfCouBunHnAWaffYOwFoq00iGt
	 AbBFy6MAnqXp7gH99YT888MmuofDK29O9ulFFUNTZsLZckD1JQiZ7KHeGaqlL2joDs
	 MvPpgNnH1Nxega7/W2TEiI6yjFkQSdhfkN/frrRIkiRqN9YuOPuxP8C7SwgN4LgTfu
	 5yl+MM49NL1ZCh9dHZ4AMReiorkUkEpmJOnjL7jH3YjNurTBchTlTLAQdGn/s7rfum
	 MTnyDXRLNkc5vNJGmceIijGi7uB3e6s5W3GGNNhRGm4BQzL/hg9L/yH1OHk4e7i1tx
	 OYs6Gl+XVcUuA==
Date: Thu, 22 Jan 2026 17:44:56 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] memfd: export alloc_file()
Message-ID: <aXJF-GGFxP55lgs8@kernel.org>
References: <20260122151842.4069702-1-pratyush@kernel.org>
 <20260122151842.4069702-2-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122151842.4069702-2-pratyush@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89DF1120009
X-Stat-Signature: ed8f5m1xggdjwzihdaoucrue5i9tprah
X-Rspam-User: 
X-HE-Tag: 1769096703-241169
X-HE-Meta: U2FsdGVkX1/9xutSWfKXrDSsg5a0h9NstF17ee0r9Davabmu9arePf3VGnzKvvolrOQ4PJLZeo9UsVl/lpKcSpppca6kYwIfdDm5mjgcZaC+HX0iVHAoeowmGBYZ6WEc3/EnxDT43hTTc891NA71/k6WR7UxYNUZbV+d5aVyCgayDAYm1bd7zfmuoXZrYqxfx8FlVRSqqsTACFR64SjahAJOl4So+P3Kqae6e6lkL+0w8bvjfgfWtn7PsmVVk8F7LBTMGMWMEOeMK/EVRSfT0RogdbNG70tD0b2/bweyNqKIf1A98U2qOF0ySL7rt2hGjYG0lGlUVp+YweILr8qyupJDEu0vbFuWFJt9oOyG4fQpORc9+5i1gmjKEqSH+V5FlF/t8ll2mjCCXbFejXIvrwBShDQyIXOMOI60g6Yd4HjYSqv7pxoIKkVnS8xHeD+qO6Ubpu76dc3nmhsAIVA4bWofmSg8/suu+GbNOXdfPcB9fmlNpwE/3uVeLY0setaERUkLV1v9Fk8X3Oft0GoqUQzZOMivAYQoijKEQm57qCDRa1wl/U8SzfpAzSFBaK0CMjrVwTBZABbHlsCecfdP8ypCO5FF2WcqkXD1BUL27Dh3t9KF1esdBsUnLjPN8P+P4NCpjPYHyoqJYK+WDTQMid4mUOTepAZ8QDgAdp+ZK6NplsIKugPT6Pt/3gcWj0zynbzzaxNXoDCOfX3ufkqBEEOGwOmEbqBXqrhVs0cKNUCjzkO9oXi7tw7i45I9x1HDREHTi/OHenm7mf2Od1t80SDTy4Yo8+QZmDu00BvHAqnVSvH32vw5XtKNOfC1lldYqfugBXC+PhHrxV30Je24NIisjJJir4e9yiQvslignojck8t0ylMnekE7sMOvAEpmmXU1pymC/I19P/A4WhnvGQZ6zjjs7Vbu9DD1E1FDr6/WWyFc30t+8PAjbtzS+Phm/fiir9pU7gt8HeBEys2
 NEshVZZb
 Jq00/mMs2Yo/1X8wgJ5uzseG/JjOM2M543lEVZUgHwXxms4jxlWw2lHBqpwdMPm9YhFiJouLMXvWOTpFRISY4uWEASLaGIiOw68nO8FwZbSPVajbvT5e7i0M0SV5evijqWI+QYtF2vfEXahkqeJCOfAgOAlaAqbGReMd2Lsdnhio0HUoizfYaVURzjpL+lGJMigqFG3iO2dzZ23HS7rOmia2+1cX0ljk/a9ADXMkktcZe+FhyyVcKXW/J5T86BLInp3RTpJ6i+4/Mgo7Iaa1OzcHbFSO7+mAkf7GqwQsjNXIV++v3mXUTU9GAzvWHTOTZEvv1JGR8hZa1BitwJhmUhIqyb98GMaWegTyt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 04:18:39PM +0100, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The Live Update Orchestrator's (LUO) memfd preservation works by
> preserving all the folios of a memfd, re-creating an empty memfd on the
> next boot, and then inserting back the preserved folios.
> 
> Currently it creates the file by directly calling shmem_file_setup().
> This leaves out other work done by alloc_file() like setting up the file
> mode, flags, or calling the security hooks.
> 
> Export alloc_file() to let memfd_luo use it. Rename it to
> memfd_alloc_file() since it is no longer private and thus needs a
> subsystem prefix.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

