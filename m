Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE9CC87FD2
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 16:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 435726B008A; Sat,  2 Aug 2025 12:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5706B008C; Sat,  2 Aug 2025 12:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D48F6B0092; Sat,  2 Aug 2025 12:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1ABEE6B008A
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 12:55:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9CDD514022D
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 16:55:03 +0000 (UTC)
X-FDA: 83732417286.08.64C10F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 397C120010
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 16:55:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uBD7JYsC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754153702; a=rsa-sha256;
	cv=none;
	b=XPbUPHPRlRMxZYxLfpaUKwHokPncQhNB37aupbTjoAd/SXjd89LRQZsNitdR/lG1+/uXLs
	nZYnfQ+EU7/D01Ijefl7ydYvl8//n4YVFcZFdFw9RRZwuJfYkm3QigDSp4V+4wFw8YKg06
	W3hECmYs4QNN8Kkqn6znsjN0a3ipJKA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uBD7JYsC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754153702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjAIVcqDOE68F8Y4s96d3OXCQ/nWcSwu3GUlg8SCblE=;
	b=5sCq3pI/nDOLKSVXZZpmLXCvKmo3Q4C1ZkY4F0qkNi9XKRIkPOStKucO8l31qC9akkVmUR
	I6EUf0TnpY0HFRSs66xB9L5Wq4782NYkoSqBybWuQxA9y4rm9s6Thb775M1jgWGEky3nZi
	sKnsbl0DaqGFRtZWgAiOi2m2zOXPtGk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 614D9601CE;
	Sat,  2 Aug 2025 16:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47B0C4CEEF;
	Sat,  2 Aug 2025 16:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754153701;
	bh=SEc7rHR48cU8PgjS4PgPLzAVHNEQ00U8BuoFzkBvLBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBD7JYsCVJcYeeLVVTvcguO5RB332MYn1vfjnyUcdMjIS3ssYYNeIgIFuPla+rRxA
	 S3gIFA9AVENjcAsIZaajoAfLIw0xEtP5uFNAAo9TB5MO24NGzBPBTZJhc6TCHxhLqs
	 AgdRp3NPsi6sjDFbuwtvDIVFw3vkxVLT8uOtRu2etrsX8eifX2ceegDy/L9zIHAmm5
	 RxoHD90DySWrNxg1ON2U437wXmpMgfiqCr73kAjG7hqa9r7ouQ4zWM0YoipEqgjZRq
	 dINMxlRkNRHyChkHv+hkGgmnwrjsVhKlJAkHrDWLqFosSHoH3FHpsalL4cq3DeUnut
	 7ApJNGeb3UzIw==
From: SeongJae Park <sj@kernel.org>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 2/2] mm/damon/vaddr: support stat-purpose DAMOS filters
Date: Sat,  2 Aug 2025 09:54:58 -0700
Message-Id: <20250802165458.7179-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <264a4b5ea202fd73c01b349c9694d8bf9978c441.1754135312.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 397C120010
X-Stat-Signature: bz6muhj31bbyxfhar94ymkspb5sfxpff
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754153702-462525
X-HE-Meta: U2FsdGVkX1+1XkD0NTBITMmZT+fX1UQhTX8KUO0GlDzoplCt9e1rY4TpScGRpRcfWCDyrdRNfHPO3U4i1+PH6/uAEeDwJ/ehW6ERPejL9WKT7GmdauKMt+QZpY/s/+fDXUjxhjyg4ylCOFgmzZdh3HkqYC2u7IdYGWkwjSeq2bdly3q+ruVBa7XHgIVRBrkHRIKHc3o1DIeMK+7xXGZuPq9X2KR18UwrpoNNRaqzNLEToI7gHVTxg6fIxHBPzT+b1OjLNTf02wvaSC6CG+q+VxJF+l9VWgJdZ/t0ZmQoeUqG2IX7bAl/KNomymCe2f3r0h47sNaAionjhf4RX00LDADOkfTsdeIPxKzUuyJb294NCmQuSjuTtLbh0crupQfUCaD0aiFp7VdUEwErrvjAFFhHaectSvSoLCRKndV/YEv8eT6QlhF2UxMncb+sk9JsTVIq0mmWMcl6gSaWG566WcK+KQmJYP4LrK0rkZs0QagMXDGJ5sZeYEaXXicC24A+4c7He+akehROvhetgdmpkyEeLeitvy2QQZTxa5iwWjM87lW7OdGsnZADFgEzdENYkRVxHonADtFC4M18wQNE+M5w4EvO8SGi77jopNs4aAcH0Lld6jwo426BQxjNObwvc5P7xoLDh2UH6nGsXNksqi3Iw1xoFmtpaISCqSM681LA2klfpNocuRSLfUKC145TTrgPIqCI2USFRDL+CI3pjUvgJefcuh2OCNMqNl/J/y5k1ruOHx8cX1G00p5daboDYypmbkVX0D06IXcqLbyaAfJ8MrSS6SwwZNjlrbg/HKPWJynosIKg77qtKSJOiuyKBhDxUYOsakTj8fo/X5Sm1jj8DDZ8Pa8BBydogJ3msdog5YSvL+xH9J+uQz7K8b0RMwX/uVKoHJ6qUAJhcl+sp6OoRmDmpb6o5rIzG65bnVqZrNSVywk0fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  2 Aug 2025 11:52:46 +0000 Yueyang Pan <pyyjason@gmail.com> wrote:

> This patch extends DAMOS_STAT handling of the DAMON operations
> sets for virtual address spaces for ops-level DAMOS filters.
> It leverages the walk_page_range to walk the page table and gets
> the folio from page table. The last folio scanned is stored in
> damos->last_applied to prevent double counting.
> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

