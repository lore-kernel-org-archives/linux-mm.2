Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DD94F54ACE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49AAF6B0088; Tue, 24 Mar 2026 11:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD706B0089; Tue, 24 Mar 2026 11:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5256B008A; Tue, 24 Mar 2026 11:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15F1B6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:17:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35CE41396A7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:17:38 +0000 (UTC)
X-FDA: 84581310996.23.8EEE3C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ACFE11C000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:17:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cbo4hoim;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774365456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=szwE7Qs9TreaV+UIOZVaQfTOUiCpoE67KHYMwyKLXhM=;
	b=avOLl0fLUKSaK4Zf5WnVmeq1NnrhJeXiG5boqAw3StSL2pOizRBA1pB7ZT3twPqhPB67jS
	hLrA48PUskHsOBYBX+cKf3QFarprJ0FCRAKEAqUhJnBb8U9shPT/humXVesZaCxw7LoMvq
	+EjsQWJihXTRxN9DkQjsKwnGhjbMIQY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cbo4hoim;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774365456; a=rsa-sha256;
	cv=none;
	b=f2J31EUipfn0ZEbQSMewY9UZLNjVtDZJJfhqIzS74MRPCyuJqwq1je2bX5wgKge3P9smVK
	yGFWVOBgCZYsC4hUNxyeyLu9mIR13HFJoHyRm3IDYa7rb5uGWMjTWZQ7QIupohXbS3uYgc
	0UVqttOEQiIV/GfzEWEHkBVpxIJzRyY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BF0F600AC;
	Tue, 24 Mar 2026 15:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CF0C19424;
	Tue, 24 Mar 2026 15:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774365455;
	bh=sM3sAJGN5MHejbEkaZ6TCvow+96TMIcx7oNArvDUlNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cbo4hoimlsjM4ejeTx4iWADpOWuwpDOVWAPe7XIgEKyiPW7HnNCYQ4ioiVh5nshzP
	 /RcQhBdJSnypRhqsPKk+aNCXwQKX39p0JPiuSd4F02N/O2WSqH0vzD+eG2EwlcTYZ9
	 n1J/ncFLQImIWGVlNmpKOHvnBAOJf09PEn7EhoExpQJjgBic2wKzn1fM9EVZjvBGPm
	 Khe0BlkPK/t0pqN8T5tZ8GrR3K26L6cNetXH08yUYsrhrSnxTGhGIG/1xi70r0xrF6
	 SBxChoge1H0r6UakqjuFkDtui10Gl7fy14lqHAno8GskJNy/1WbGHVqAD8ABVwGN/E
	 PDTCsZj7b5UiQ==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v3 0/2] Small improvements to reserve_mem, 3rd attempt
Date: Tue, 24 Mar 2026 17:17:17 +0200
Message-ID: <177436539808.216951.5818644447126905972.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318190816.1811325-1-gpiccoli@igalia.com>
References: <20260318190816.1811325-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ACFE11C000E
X-Stat-Signature: 1hh5o1h3diabtig4qbfhr7xim8zagtso
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774365456-335125
X-HE-Meta: U2FsdGVkX1/b/IuotiigWFfTzOmPoSsaTxCnqcj0YJTb9RRMLdfbkqwfrFKiF7fdubhvX9kNOL//TbEZJhv1afV2DDJ3fwGB6+FwZfSxRvlsk8k2St7XuQ5xE3SRVjvpNV1meZsoz6NUKbVAiNqMLGtI1J0xe/u8xAbRyBrF3yJI49WIt9z/ORjBQb6CMnYQnMggPgSBZR7HwmpbMycMdVf8ktNxI2rMpZToCUCN4/R2EDE/a+vI9IFdr67IL8uQXy0GOVKz2gBLb/gOs78gnSYFV+4atw/6/w/CNwnm25yqdh8IRaCt2c76FST5Hu+HS2wx7uafSIiDEGP076FyjjCDz9PCpLydCi7MIcTmKapEYwpXffTlg0BvP0nQPnzB14SoBWthL1y1bJx0JYRDsXk7FGQFXkwgzQ/NXts0rbVW4Cj3hIF4cQq6vhRXTUfKjr7DNkI+7Krg5ovv5ZqA1zjVx46nt+inIz/2dOcibkv7i47SGSjY73b/hCb4bv7On6VivcnAs1xofiG4dJ3+81zPdMbesf67CO7vRwbMVfbac/f2bBtrkbJRDSW/pN/XBesHAOzftaVVXPR4ktJkT2XqXpRU+3tv6BwhduP/G+uJsGCHMJGc9O7Uzi3IXh0Ue3IDppkGixJzIb32NLkn+UsAFBJhRgXaD2+LrkxE3CMBbjP7aizAQw7N/VWOgcIAtld9E79YqKHH4i0YLoaXIsM7+m+411UfxhYYLBE5Ort5PpmtngdvO6Sb4Aqf56fsYFCtkpxN+n+dWXEor3MPtIhwDKwGjBSWLnw1yacHm7d7Royq9TflvG4rDP4uzIB/E1KXYO++V948tNDzpLQQmYUAnV3LatrRUcXSmNzd0ahdfRfbfQjbn1V+NQg76R4DkJr6k00yZX2en+4NMf8sDGiqmtsamDBOTZJLdTXm4wA9KoX5MDVjmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Mar 2026 15:56:31 -0300, Guilherme G. Piccoli wrote:
> tl; dr: we are adding here error messages in case of failures when
> reserve_mem parameter is used, and also a debugfs file to show
> successful reservations, with name and size as passed in the cmdline.
> 
> More details and history, please take a look at:
> 
> V2: lore.kernel.org/r/20260304203300.1414286-2-gpiccoli@igalia.com/
> V1: lore.kernel.org/r/20260217195816.861684-1-gpiccoli@igalia.com/
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/2] mm/memblock: Print out errors on reserve_mem parser
      commit: 855b388182df35d2907cb2d5723270b0df3a9e6e
[2/2] mm/memblock: Add reserve_mem debugfs info
      commit: 2db6cd07805051744036235f7ee9f24a9be9e283

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.


