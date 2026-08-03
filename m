Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FEBFC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7001A6B00D6; Mon,  3 Aug 2026 09:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7AE6B00E9; Mon,  3 Aug 2026 09:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6149E6B00EA; Mon,  3 Aug 2026 09:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 410816B00D6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:41:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D03DAC070A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:41:27 +0000 (UTC)
X-FDA: 85060070214.15.E6C6774
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id E2C5C1C000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:41:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RgnqxIc5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Ljejk4giCEi2NvwLQW9LTJxddkLmtqRKfHKs3KWWN8=;
	b=YCrwGHlcdjxhZ7Of52aQrUXW5V9WQvWYIfibZtb2UciFhcRm2pJPlFUmDgdanyfXSnH9jK
	gAB3IfIpc1v25nPIM7oT67t/ncUnl+2aK9Q8HRMX/1dfsZdb/DoxijBX9jA46aFCN1KwRz
	TgEYO5NHD85FqxftW/uiQ+meQjetDEk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RgnqxIc5;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764486;
	b=aR6EZfecA8YZRlzk8YBpS1Cdv5fJQRyEsUGAJK5ud8i5ItxjqadVTXadq27Hue+K6ipvn6
	89NaVE/0OPUmovl+QNT/ttsr6uBWwV2N986JGDDlJDBmhrMEI4BTB9k9qAmJyHXVaRzzh6
	N6f0CfVZn3dYRpTGpcaaKsOXQ0ycPhU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA3371476;
	Mon,  3 Aug 2026 06:41:20 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC9E93F66F;
	Mon,  3 Aug 2026 06:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764484; bh=Iuo7pUTza4UWUwQ1dXSfrokh0IIgddyLc/uxMKgri2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RgnqxIc5A4hDNvmmDuRfbNnVTc1TmQsuhtYOj0JrWT0jRmjBA2CTQTTgKP6AtG9IE
	 nOxRxSNT6pRHgpIueuJUzx/ZQBqUTxeJoI/kb2gHgp3LUHvdF4ctZJdVldyCIBZRk7
	 ZCqz25FYqnn6ZYxygxEuZZtRXt2nEt+8UReW3QVk=
Date: Mon, 3 Aug 2026 14:41:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: kmemleak: default min_unref_scans to 2 for verbose
 auto-scan
Message-ID: <anCagP6JDQG9w71j@arm.com>
References: <20260730-kmemleak_hardened-v1-1-b0b20033b4bb@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-kmemleak_hardened-v1-1-b0b20033b4bb@debian.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2C5C1C000B
X-Rspam-User: 
X-Stat-Signature: erdqcqstt5hz96f5t3ik1djbwmmds7io
X-HE-Tag: 1785764485-279686
X-HE-Meta: U2FsdGVkX18mEpbsNj0/ywLuiFe2Y8BysGHg60ejqMTaaBpBJNrSojgDBoVtibveCdO4lL9tUNyL//7bJ4X3aTIkOr9fKedtpP6ewVC61/e1zuwEbS0gsvL+3sa15vU9U9+moNxi+nd4MQ2abrNaxc5Y8SvKgTDuLHSu388MxLm+JDye0wTxzLAOrv9mfWw2Hl3OtII5tTheqgFkY+NYdNvCEh7pMwumddJ8jHma3aItKDX8rAm3cseMVOBxpbqhT0obbgRC2EkhUCh8XqRrVoVFmncGikFfMvKpvg6LSE6GBvBwN5shyBfZchohEDlv0h8fjxy9AGRSG1cWYT93JAGo9HXAnS/QARbA7ORwiSn3sBDBe6bLslX0N6WVGOvxyeLKOPJZeT2a2qnpXM6EvD5Y1PiBjjkVs/KDpagzRe8hOTtuTcHuvgIP3eV3JkfhTKZ3eSf92lmpeaTkFG5qUUL4enCQCSjjeYcGqcqU+v708XZRMuBI5pczJ7LShjpJ+bMCcT/3iyZub84L3L+GWi7EZ/GXO70KPig5NIE/On86L/pSUKPLPMad2vP0PpSVcygyGG3cfXXpmeIAhI82eVEA2RWDfIVxXuKEffKtOoVhfCsahpT8/RnySIBiDzAYDcOP5QZC/ZoNTx7OfL3sBLuSbVtTl9n9oPXTHMmNpSeUhOBJWzP5gb14AxZL8k8wzrWCA4ejwM3x7ZFjx3vG7b6bq96hssdU7qlof9X+THyDtb8U075B7NnsGJVPc96GO6rkEt0oA4rR/kXJwwk/EdvTBtpfgTbVwnemkf6atwzIdF+NyP+JL9vcqtTItnak8x6l0ACFJ6sY6xED8W5B9fl9EsT1RbAVt7ZY/9yz8RVrRrk4zvgrxykwfwyb602pcGeRoKxjYcu1pJRs9IeD5YiQK3mMQbd6V/DIcMbsmp2Y7IljnBAU9SCtx8DlLge7rFOvnMWFxxeuUsDKjFy
 CbaQ8j3/
 I9vOVoPFNChPCiTs1Fv+VjjD/YcqNnHApLXKZc8OsloUzDxSqr6qscLRY31AsgHbZmfUziE+HhI9zGT/TFHrOfeB6+qXlFm88P+YIqbGCJhohcAcfPJU7Jh9O4UubfhcOt0PNCCtpLyHIpZAm88jWY6BXRkFEjVKIzYHKiNooGNy6nYJw29nBA3zQB3o09ybeJiewEGFesSRLmaA25c4YD6kDsnubuE41kYvbJ4XN2E0wOTdULiVv2NgWlY5I62cpzTloaVE907clAPunrLHr2zl2R17VpapsKBoRNmW/4CJDmlgYtV1nownvR+1A5lXk93JfFNqlcy350b0kBHx1Nxsu7JkghwFeg8m8eoIWwlSBII4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 07:31:21AM -0700, Breno Leitao wrote:
> min_unref_scans defers reporting an object as leaked until it has stayed
> unreferenced for that many consecutive scans, filtering out objects that
> are only transiently unreferenced during a scan.
> 
> It defaults to 1, which reports on the first unreferenced scan.
> 
> When CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN and CONFIG_DEBUG_KMEMLEAK_VERBOSE are
> both enabled, the scan thread runs periodically and the user has opted into
> detailed leak reporting, so a second confirming scan happens on its own.
> 
> Default min_unref_scans to 2 in that configuration to suppress transient
> false positives.
> 
> Keep the default at 1 otherwise, where a manually triggered scan is
> expected to report immediately. The value stays writable through the module
> parameter.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

