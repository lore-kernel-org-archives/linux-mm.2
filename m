Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9120DC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FED36B008C; Thu, 10 Sep 2026 05:58:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0756B0099; Thu, 10 Sep 2026 05:58:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4B16B009B; Thu, 10 Sep 2026 05:58:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21E096B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:58:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CECD80454
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:58:15 +0000 (UTC)
X-FDA: 85197402150.10.C5862EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id F15DB1A0009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:58:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WKaF9uVF;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789034294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipF4yAyH+8cCr/5i9AssjJeIC5nrzhoLBaXZQ+ebQbg=;
	b=XE8YiK+JRbcHWSCslEHQFGjyPqWGb0Drr1G4DRF68TmNjcq+g7nHfxfpIa0W9bKxQVi0rG
	9MkGIyp8gpuSvwVAliZJKgEnqdzGS6gPing0armUeYBdrIHYSMnwgQ5RU1sQI+E/047Mi/
	P5WrYK1VeLhgt95j5gm48arkl871cog=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WKaF9uVF;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789034294;
	b=oarLkLtuqi/bVDfUO2vJfV+KULpaXQQOmzgWo6HpCEjWd5fUqK4lHZyrMKg9rCACYY7593
	keX8fqWDRP1B2MjEAFawGCM15JB9KjZ/QhBMXpHn/4iOD8LoGZL6LM5D0ChCf63emc3ViN
	onBXA9T9W+PKUiCRysQYvZEtTLSUC5I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F557436F1;
	Thu, 10 Sep 2026 09:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA2F1F00893;
	Thu, 10 Sep 2026 09:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789034293;
	bh=ipF4yAyH+8cCr/5i9AssjJeIC5nrzhoLBaXZQ+ebQbg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=WKaF9uVFSuDdkvnZUv3XVv2Ww4wViV0R7H07gTfwwn1hONZCNV2Bx702FMNcvfM9d
	 QDpHT09iVgcFFWsUrSnK4y/cbdd7Y8bJvRLO9QhnFwCpOFJNqClSd1qMGelcDXzdA+
	 +wyhI+eixS2A42tuo5pnWmFQLs60NeTdidSi+dph9LWMRLXoQ0Op3bHL9uWolWS0qJ
	 mIVMSxGBTrF8dpkSDOYFXMlfnrE0htjG+f4uJXMTb5CT46iTZmJikHd5ow2SL9hWfG
	 Zewrg+p8Zur/nAaZ3TcPz/HWkqMKnhtLMhC+748FLabJIbjEPXCEGhiIs7ipcNdFS/
	 sefzwbHF0f8mA==
From: Mike Rapoport <rppt@kernel.org>
To: Tianyi Chen <hi@tychen.cc>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <cover.1788997523.git.hi@tychen.cc>
References: <cover.1788997523.git.hi@tychen.cc>
Subject: Re: [PATCH v3 0/2] memblock tests: cover low-address allocations
Message-Id: <178903428798.1489479.5765028250372068441.b4-ty@b4>
Date: Thu, 10 Sep 2026 12:58:07 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F15DB1A0009
X-Stat-Signature: dkzpd3ec9fdn3wtinfs3ni8xpz1mwcco
X-Rspam-User: 
X-HE-Tag: 1789034293-975446
X-HE-Meta: U2FsdGVkX18QRyyTd0VtrpCVUT0kVvfE6srs59aZ7hmAZP4rJpXU//S5UBH3nQb5lHVNU4BOOgBasZql4hcklz07LT9XZt5RKKoFTbtIujY6Akdx6V3YwiuhpWYliWRnad01qLUdZnUD1cTvlb3bxDgPcOO4Twz4AJGNWdMlr+mz+ds64BNItl9NlZi5yiigzTkbnwijgDCapSLpXzU0LsfDx7qecWmmQQDXQjNziQ/i3ZoDckUu2cKibS9GuA1bAhHfwosrSz3iIxTHOmWPQeGxFezBwY38HIUh+ZBxlGtCFTni6moGn//qmunU71c4AL4svJoiLruiqqTII7MKbvu9J6bEqrV2ASDWS9Hotsga4RMRxG9Nt4wv4NO6L366J46uKGeLkdHsRro9G/lyChgW8MUsWLRboyys7byrvE1BfxYsMucOdRbZvqx5ypFPxxGNf3nVeG3/Rm+jS+TyHptqXfbrAJnCMKcUJ6jF+BjGjAC5tlXxY2bVZkN3takW5V8e2i/+mEk0PmDZjBeRli8gk0qhwJg1rdCdRDoltoUgQWXEB4+eaP9pjbCjVencK+MfOmzCdxIB9oaAXv9+f3J1PaH2xunwrShJOG0p7DZEz2vVn/HkyNrpLntoMiOFSUPoXM1oEd48qCJpClfcYN3kS3lsWFZVCnvo2+y4bGbPsn9XWzO6ajFV23nnm+ZBrY8RE2TCjAwravL52qsd60gbMrhvBg+gclD90a/rv2cUzn5D6+cz+vZxf/VfSILJ69VfDs4oXA2sFAWkge49A/lPJcMNOIfwT/AKEXSURyu1bisRRbWR3Ttj5rGDQpnZH8FrwNsgIccszVMlKMn8u+rE6peg4alHWoIykucFdTRLnIC+K8z0x8PkbrEcthVEJZrxLV6uy9GXaJcAqfVJtzLdsuDDfBgt2GdKTeyH+Uml18sTXuw3H76xyjCKGRtLXQEPac6P9CwLpkJKppZ
 kgXr8MZn
 rEEFFWnzKkTOXi9LA+t1ConxCGDRbOdEm7vo17qnSpDLxqd9iZU5U9AiU75ehyVTUzGcT23hpDgFLoArR3x7NDNWc2fMKBTABM7JS6RsQoz47bHuslSNftc7MO80rIY1I+2ZpwBiagVPDVxwixMmGxrTyJO5V6g0LJ8fhbmfAVLJIxZvwFY2LsdMUt9ZMQxlQOPuVK5kw2Ku1a5V9E4ARvYn/yF4uPLY7ifVyrhFvoW3uGyg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 07:55:22 +0800, Tianyi Chen wrote:
> memblock tests: cover low-address allocations
> 
> Model a low allocation limit within the memory registered by the simulator,
> then exercise memblock_alloc_low() in both allocation directions.
> 
> Changes in v3:
> - Describe the low limit and simulated RAM alignment directly in comments
>   and README.
> - Use Assisted-by: LLM in both patches.
> - Start a separate thread for this revision.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/2] memblock tests: model the low allocation limit within dummy memory
      commit: 5c194192279e0894b898967ff939e310a9bd06b5
[2/2] memblock tests: cover allocations below the low address limit
      commit: ba7b611a1fada0bff7f6c3fbc6ff13978bc1af91

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.



