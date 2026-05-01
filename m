Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C685BCCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 16:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37D436B0005; Fri,  1 May 2026 12:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355856B008A; Fri,  1 May 2026 12:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A9F6B008C; Fri,  1 May 2026 12:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1082F6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 12:48:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C74712016E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:48:40 +0000 (UTC)
X-FDA: 84719434800.23.96440FC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0CD8A4000D
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:48:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cOyG47tY;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777654118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JVgPi8y5pr9WU/dl+aDm2nZ18TubPQulEy77eIIoew=;
	b=qinIFpBQ+IbWkkbEjVFfYXIunCnR/QJDukK9UtkD+XeQ6S1bozBLhGgGynv7G2ZdJCmwji
	lQXyAxiR64OB/UyxVsSNqt3QEduHXL10LHbU3BSXv3p8f8n0OZfkJ/UYN/zwAeC6eISiLm
	B4zVCHD7F76o13L35Dq/M38ZcxRaVbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777654118; a=rsa-sha256;
	cv=none;
	b=FFCYUW720sizpMTBIMp3Y3iwoNydWQmpUapfo8hINWXgyPFVAcE1xrfB3aIaME//owdh3Q
	DMixVViNXNmwhFR6vAwW16J+VZjzIxELezAyWdSrkKuHgBVSnGcXXSpypYL5Pf6u7RrX7Y
	7k7iIAK+LkCbQXP6gsqdg/iX6MKGCao=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cOyG47tY;
	spf=pass (imf04.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7240F176A;
	Fri,  1 May 2026 09:48:31 -0700 (PDT)
Received: from gaia.lan (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F49F3FB3E;
	Fri,  1 May 2026 09:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777654116; bh=0mhe5VO6bibA7BOMRyysUlyXRYgOpwf38PrIb8CTsm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOyG47tYx2GM+V815gcxteslVYvLCr/JT7YyNNg9OXp8pk8PfZ6816/nXtBk6i61O
	 03DNgK6VCRnQhXeO3jpN99bDGHeGw6krvxSPMbHG6doMc9rYTk7R2nXDCdf1tRNpvI
	 3w+rwseFvJS7G2ypiaSJaivkB1YzcHNpkHP41vO8=
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Will Deacon <will@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH v2 0/5] POE sigreturn fix and extra tests
Date: Fri,  1 May 2026 17:48:24 +0100
Message-ID: <177765401795.1247142.18437523935136255541.b4-ty@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427-poe_signal-v2-0-2bd9d6f16ab4@arm.com>
References: <20260427-poe_signal-v2-0-2bd9d6f16ab4@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0CD8A4000D
X-Stat-Signature: qntfaj4y3144fq8ruysfgbafyeaa4xfz
X-Rspam-User: 
X-HE-Tag: 1777654117-340439
X-HE-Meta: U2FsdGVkX1/p8SSKyJLH1eqdvYMRWFS9dpN7VjhkWvagc4uufrrVrWmM8HHGNIrJcENhYUE9i4y6sH3KNqoI3yJusuWTwej/VJU6QIHPUJrvEIXCJQqoZ5F+C/z4gpAgzZRNgCW1LvuyV6COhuFgatNaWFIKupCLQfOuaILYL4n3umvhgVwSKGvhObVjS0mMuV4hH6Sv2xjfqg9WnY1vKFAw0kcaCC8IWlfJT8wPVuw4xv4xIM1DngFIjAdBVGG/2iyAeDF43BKT7GelPgctwZPSzpwxRSDTnHXYtlkcynYivY2/mvB7tr3bU07+w3/mbO5RZuGV6KLuu7Km8VQR+hubkJh6B47qVsGk3iww+E6rsBJ509kpdG3gmLU2zudp2C+xLbVFtZEleJ5ulQjWkhchW48F+3BRy19WLzQzwQOGRNagJo7PdA9TCfqYpEyglP7Ux1trDkTYiMTFP/RXpnfpXct7d+0DMH1NzOUzRA0QdQBW/0TS3n5D1Wn9bH8vpe2QezFRQFW6d/a1DBxQejwSSycFs38up4cxrm1w60KyIF64Zc8qPa/a3FTEo5ON84kd8xlnBPMRldqqjOjNMLPai0k+lTSIE21TxPo6pP4dnxR/hXwe+VWDca2vuJO3M0fDUMCV7dk+GvIwQoj50pLvFeNZ3XT88yEIG+MhS5EhbKZ0d0F2j1AWXClyBS0kaWPb4WljRB/bBe8acsSApPzKr2YzN5YCxT8vTpFc8iiXgTwqyEyjxW1dE4J72oY/ixflInj4YoSoLcGQwYWtUcBF0XfKnzd2un+NutlpOZLROOYhXJ8m4yC2XBcbYrIEpGX9xJ/LWXhcasyHvvMuPqM7SvJ1Pwyb028aYYsx2GiDJlf0sHXGVootzExDaa/RQu6N+DsmY8arf5EW0nknhNyRIBDjtxw0ZoJJydqeadlkM7ZMlPd27KHZXW99lBBYgLKHVJAPEzdXhD2U2fx
 eP0K98nH
 KhM70cTlWJmFgqJIVgfDOwJQOOceM1qOFlQQySMgXa2jWkOVGV7lK1aiR3tFAFCW5VWxWp3Y5XGOZ5lVo0azau8ghUaKkd/gPOdrg2WCKtAdzgkGrBhtsrQwpQVWP6xYxgGKgL+8ZSCSqJmZME2wzvZnzcAN0iX7ELHbZVGviSA9lu1/KlHLwDWAiLgG31uaXQ7yR+7AbqosX4la3K4btrOvwV8ivMT6l6GE/waHh/62wFX1vQI7u5xp9og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 13:03:32 +0100, Kevin Brodsky wrote:
> Commit 2e8a1acea859 ("arm64: signal: Improve POR_EL0 handling to
> avoid uaccess failures") introduced special handling for EL0 registers
> that impact uaccess. This did not however handle the case where a signal
> handler removes the relevant record (poe_context for POE) from the
> signal frame; this is clearly not typical behaviour but it is legal.
> That commit resulted in arbitrary data from the kernel stack being
> written to POR_EL0 in that case.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/5] arm64: signal: Preserve POR_EL0 if poe_context is missing
      https://git.kernel.org/arm64/c/030e8a40fff6

Will, if any objections, please shout.

-- 
Catalin

