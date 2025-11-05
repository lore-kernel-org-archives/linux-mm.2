Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4127CCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 10:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F46E8E000B; Wed,  5 Nov 2025 05:26:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4A58E0003; Wed,  5 Nov 2025 05:26:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1C78E000B; Wed,  5 Nov 2025 05:26:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1828E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 05:26:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 275881A01E0
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:26:40 +0000 (UTC)
X-FDA: 84076174560.27.0D9AED4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9CCB920005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:26:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gxeq53K0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762338398; a=rsa-sha256;
	cv=none;
	b=aidPKrMrx0S/uL+/8TlQK7Xdxg9BmYmHoOnMy3jRGW9PVVcYVyqG7J2axOBf6FIrbOlcTt
	nN7ijH2QmAJX6BHzQaLJ83N9ockW1N9kyzmmzyd1hwP7QIgGrGrlHewv0f2aJt5Wv9JL6V
	c9yyD6VzzAi2h9+lTSIY8puC4WaTHEQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gxeq53K0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762338398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OE7AoJbhE6VpjlceNiF8VOqD+B/im2atz4jqngQqZvM=;
	b=Pd11AiOk5r3HoxUXkt19RHb20uDQhimyrgGSINnlss2+k9resFxX3Vu6LF5CmmKfNFlt6t
	FfkZ+hydUBG8YDq1jdGLDCP5r9KvmJEKBf5k0uauvkpKYiXeQsYUsGvk3+XRBmNzAdylBl
	f4SFAHqWQrdHgqMoN9pVBrLp153mrhI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CE6B4090E;
	Wed,  5 Nov 2025 10:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B37C4CEFB;
	Wed,  5 Nov 2025 10:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762338397;
	bh=I+3JMkmXub0Om9x1OdwocGKiSC8yEiSgXZyoFKMlEVw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Gxeq53K0YO1rrLqRKi+ZKDxCWG/hCytZXm6QxtcTY10w3UtM/t4lFglfJW71RwS7z
	 gJk9TjarlsPVgn2uvkEWUQT3sAh2Zf29TZeIYsl4JZ/DdloehsvLLvMdm0oSmtJJ4S
	 lEMH3OdAF9ZrxxffeXERgioD0IEkvJIfLMJu9FeGR473c8ifRyXUvB2rDI05Ct83YG
	 U4tNW0QlqxPdfuLjV5LyS6k3EZxD+PVPzas1hkDW3hzcUIH1jRJ10jHOGPZwH8YyjD
	 OUDZyHxGBM6YcrHMPGRDojRusKwMYp4Ne/R6OaHIXbjiigR3mDnzOtM05ctjUqfe2j
	 jU3eZPNpb814w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org,
  yanjun.zhu@linux.dev
Subject: Re: [PATCH v9 4/9] memblock: Unpreserve memory in case of error
In-Reply-To: <20251101142325.1326536-5-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 1 Nov 2025 10:23:20 -0400")
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
	<20251101142325.1326536-5-pasha.tatashin@soleen.com>
Date: Wed, 05 Nov 2025 11:26:33 +0100
Message-ID: <mafs0pl9wbwrq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 9CCB920005
X-Rspamd-Server: rspam07
X-Stat-Signature: n7f89xmdr8h18h361oh57bnani48caen
X-Rspam-User: 
X-HE-Tag: 1762338398-160715
X-HE-Meta: U2FsdGVkX19z2vbgnuYQR0HZizGhwtp4suIs//iNQzZtfz6NIKnpN2iI0tLEEng27N0AJKmJ+3MmT96E0Z2fEv8QmkDpX6YGXgjkY06Ql/TMBN8af/1/YenQh6xlxtBkU36lvTOnt9mQXLWn13bdit/5UWdQBR/rNXjpSEztIUPjVoj8BBMWWVo8w/Ob8dVfIzww4lYvnkHFQoLQ5AqF/bTXci8Nv1en3aG+82wkiwP07RLn2+Z+8Ncsg94Hazb42WvjbBiNYvZS6cUhb4rCWHHL10VDrmennJ3utlskTxQfLC1R1z/H2o1DYpo+Xc5977RxnbQr1czJ2H0MNj/8tZnKpjFOnyutSuS4f+0nG5shoCAL6wKnlHlHYmbqW+5oNt0QUO+Lw69RvjmboCm6oLzarbw5tVK/FSPi68cENGR4AQXdFsfm+QTfuDHP0yiFOzEGOA5XnioyFVJgTiPFxLq7vUlsBXmw4Ql5UzqIr1GMHswYaF2OYbTZCPDjULnoi1lGNaelc2D58iJahbuFPREJKp8P+6OooS5Pvatczop0Pc1yZQWeJYvpg5zrZXcWeqqC5mdl25zhPwjKTH5ZrZi7RtBVz1nIJGFFyn6sozdy/tvakjcPEDk/ykoW0fBENNV7I1wf5IdNK2nh+c8PJuNQzY2xl4YR3zWe+6Pmgvsnw9uY3vHAgKTfx9P+uW/PzKqxir0eB8XpTyoJeFe0Q6TgJl62gObijw81D/YUeVHbDsoKHxLTFAKF6NUS4NfrhWZbm8T67Idyp9VRY3FdNaY2+uMADIa4Qe6QFLoSJ2wQkM28DcVZFXxZsQnYDDJRRfI/5t2kzdfskwFtguxuDG4wlnaVUtJHlVAALS9I4XdGZVxOO+3dUaklqpPbK9mt23o6Sfu+O5lKC9/ViPc1ZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 01 2025, Pasha Tatashin wrote:

> If there is an error half way through KHO memory preservation, we should
> rollback and unpreserve everything that is partially preserved.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>

Nice! This is quite an improvement in readability compared to the
previous version.

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

