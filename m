Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30ED3FEE4EF
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 16:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D2F6B0005; Sat, 28 Feb 2026 11:59:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A736B008C; Sat, 28 Feb 2026 11:59:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D09B6B0092; Sat, 28 Feb 2026 11:59:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7636B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 11:59:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFC17B5A69
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 16:59:28 +0000 (UTC)
X-FDA: 84494476416.11.273A94E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 465E5C000E
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 16:59:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eP7emqBO;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772297967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rb6pIGgFgYPNZMQmaH3UvvGS1bVqerPeng8EvPu+KqU=;
	b=faen8T9Z1ew/mRHh4IRZjQtNLEiX6xxk8O3ZljyLK2BYeAuC+SHasi12XHUJk+XHrGjv7+
	f71ue5NoKTD8zKyMUBQny1whv3LEXEDS+kDzNEgWyKtV6zYYhcjdh+Yw0z7G1hYc1DgRoM
	el765Q/v7HpneOgZL3gEWvZdLs/Mtys=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eP7emqBO;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772297967; a=rsa-sha256;
	cv=none;
	b=EtWVECYuO97aIOYMYHy7gHTGp2SMZXyQzLCY41O2pQWa2udvxHvPzrmy1MFVFDz3X+wFrx
	Ecidg3V5cyW244OokoJjvKUFuCMU1EQexSP1N3UeZ/aFm8CWtBHNXUGmT6jJvSIrkAfsuD
	qMwTCgTHrIoyJMq8DtF5XzM+spaXYzo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A46543B2E;
	Sat, 28 Feb 2026 16:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182F2C116D0;
	Sat, 28 Feb 2026 16:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772297966;
	bh=1dPFKNGaQKucQW4GhmNKqHSkfYCVWM7ZNxsIKJMaCIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eP7emqBO/aeeowW0UrhS1qBVRymzj5W5fdEZaD84Mdp+2uk1P3R18HttcZ4smTzoc
	 6Q9vTovF9UofUBmzAHsnsPQDOUHkd3egBbDNHU7HCgZOXEfyXDhIF84KTR8wanUBXf
	 2Uh2HInkIiKr2hRiiWT9TVKAiwOww7345aULRkfFFNc64RflLrr3FPs3xocNLKySA8
	 OjoshjeXsKBplWEKSo5zANKUwdlCG+aeFrSpdwX56y7xsrKUQ/PZPH9DlVugwXuGq+
	 IS27uLycBw6WiSIviaSOlbXyhlphHNiHruA1U11nB3+xpiaW2cY7gvG8Y5FEYG7CWw
	 R17QdTNWPCpLg==
From: SeongJae Park <sj@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	linux-kernel@vger.kernel.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] mm/debug_vm_pgtable: Replace WRITE_ONCE() with pxd_clear()
Date: Sat, 28 Feb 2026 08:59:22 -0800
Message-ID: <20260228165923.88564-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260227061204.2215395-1-anshuman.khandual@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 465E5C000E
X-Rspamd-Server: rspam07
X-Stat-Signature: f6wbhsm6f88ktayzg9p575ny5njc4mgo
X-Rspam-User: 
X-HE-Tag: 1772297967-665724
X-HE-Meta: U2FsdGVkX19LiGnALAF+5im5z1e+l58J1MSeKGIYXngodnAOoNnvIiedPIpIZSCTV/Pdlqlc/gQZvkPPqn6GgWBWYF7dj/HT1egbkPuyVFKIGKsjveI79NS7yVuV5KcQNkzBmT3QYWN/miFQOZszP0vnEHgBTc0Y6fsbAQqN8CQzc1eeSOZfufI6gOcm2VUzmeEY/Z5eU9wamnLvpiFNUlFmfAIee1Mjl74cwYUIOFR2EA+C1tq1jvxmFlbTqHXlG5+05yo1V6E2edr+F9jX3djCLeBIZGDld8tjcNV0AWQPb2ocB4A5YHEaqvjRfz48QA7Mrh7cnhZAHTG65LuX8gCPp3Js3MP5fJi+Hatjp9YhdQKS0jrhCay9dBqyUxSlJkesC6F5aUIggVBZ4MAnlYipeFwRsadUoGo/0Im5I6qTj1aHe2CodlLLCV9/19Kmv+QFAtKKpPFhJ9n1vFplCBt507jf3cW3IC6VDTdJdAWD80gZCJkYHhPZ/dPd0D1ZhqllAOoQprO8PAdxLvJAk7m2htljaWw1vRbcs2hqaYK1iulyjnlmHq7BeshEWlCg1xUr5BHJaKfT+ZWHaJ9E9EaIPWsgzVQ7qQ7N5j972VqM5n+2xtWZ8BbI+PrBaibyXirU8hmTCbzzAO2DDX/KtuhR0vnLygX86MC4disPO0eFpLhcEHdsm9tLQeeYVRlfhc1GaECG8n1lBWrPrnc2DHgj+cr6DZBRnVecnT+MontHJiAkzO6PWmWjON+PZRLhDtu27Rkejx1bXBf1kHdBjnaWDyVjl3nVgDe26gW3EKtJ5Nh/7pzDF9t0OceY4aXMOjF3ddOeALy7d6wrI0oOFfAxWK1pTXFYAcR9Y2RQ0/Q3OZy6VwzL0kV5xVCtSgHBz6P6mHNX7qRA7BC0YDSQrijAyiOsl4ApJUikafgQ6tiPAn8JD0W2u46jNslkGDqvJuUNQEyT+HNkpwU8Sn/
 kiRROgy7
 CGW0fvK+tHPL54c7UMZpz8FJam2L5KGeMKJemJjo9+lOEGrctDsSlmI2AGLj28vBIlUj/jbNrrErZYz5GI0vOMRKOrLpbJlTEBszXnJC36vWcm/xwLz3YvbBXovG1NraZA+GtbUJPCmJ3tiulA02ejdh/lGlo9AysN2P7fJsCJ0UlUEdPFHP4dUeDG0yaMS+iFijWd5Gx8V2RjNh/6fFe6+TuewIRzEjEV+IbA//xrr54sVFHf0YKCWfS722/aVQPiSUbpKiNJUrfXn/WdL23ZTlXVvIx7l0o8CrOrn/0eBQLxlOfM9yBqJyBP0uCt3yv7mnYHCZltg4Xw/N25qzwdPPq4fRX9WxGTiK9x5TZB5wOQwjSH+mtXMJjvOBLxhMJJgBIGfs5z2wdaQRYDmf9Et6jCV0vuHU8op3S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 06:12:04 +0000 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> Replace WRITE_ONCE() with generic pxd_clear() to clear out the page table
> entries as required. Besides this does not cause any functional change as
> well.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Suggested-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Ackeed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

