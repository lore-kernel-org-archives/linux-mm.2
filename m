Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8162CF46126
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED50C6B0089; Mon, 23 Mar 2026 10:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EACB36B008C; Mon, 23 Mar 2026 10:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11066B0093; Mon, 23 Mar 2026 10:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D26676B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:07:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7BA03C38EA
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:07:58 +0000 (UTC)
X-FDA: 84577506636.23.DC1E768
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id D4EB540007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:07:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n1iSyCwv;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774274876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1PaO+4+rWONsxrlOsGWVrD/qF2EGfVXjIo64l+ZCULY=;
	b=NjkSztgWC+bJnvDkWhaiWyMmFjRJoQynKlvru91qQWVHo89Y6ihaCJLRGpG8YKtByfvU4V
	mkLwQpVWQAzdWWaFX3sIT7M8zqD0EmTIBZ/JUDy4lyfooHLMsd0PKCDVVNKAIzMC4ndBpz
	5nh2LKmxUEZPFgIyv9nnhDvZxv6hG+0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n1iSyCwv;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774274876; a=rsa-sha256;
	cv=none;
	b=SDNll8tbLz7YtTyn/i5oySHFXN/LrzqvGCp9ozPajpHrx62zQBd6OKSUKu2pLXHzkw2WO5
	85EaoCIr8Qfz0XnSJAXlHPwaZew+EB2zwStHI3z5270kGlcRuviYAWMqsBajgMGTMTiiJO
	/VRgEWNPmtI3wh4NVzi4v6w9imly0ow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E82C600C4;
	Mon, 23 Mar 2026 14:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58E9C4CEF7;
	Mon, 23 Mar 2026 14:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774274876;
	bh=1PaO+4+rWONsxrlOsGWVrD/qF2EGfVXjIo64l+ZCULY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1iSyCwv4RPHMa9bKPi7CKWFOdHrI4g48+418mqXCrBCwAUFlzO/OgqIgoybsxZEn
	 z6A6sAbxjs4kP8KVTZpQ79j5neOnJgBWeM0bF5WxVTWBl3wQCd9D0nJx3Vpa7CEKXc
	 jjoGlAHHMSlOaySIU54LPJbLXDDCJHkeNYTLNTkP/vFq3lh1VPxHUV1BXc6wmoCYaZ
	 Ms9UOqI9aLlr3GGyX1MZN3pF8TMW28406AXQG2OfP+z96rwVvZr8yHvOiJGCog26wl
	 WB1YH745EVFt65ULXLaWPnADtcoVImT4j0ZeyD2gueXsC+ZMEIKToCDJVNt2CwLlKR
	 D2K4en1d1ahHQ==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/damon/core: optimize kdamond_apply_schemes() by inverting scheme and region loops
Date: Mon, 23 Mar 2026 07:07:48 -0700
Message-ID: <20260323140748.80083-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322214325.260007-2-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D4EB540007
X-Rspamd-Server: rspam08
X-Stat-Signature: jesji75ygi8qxtn1axebykrbmrqauywq
X-HE-Tag: 1774274876-771731
X-HE-Meta: U2FsdGVkX1/UIN0kjes4I7fuS6MGuKvpccbaIQJqmCY3TtjjfbMa9Mq4z/mWu0D+9cW4PvgXOKMzshGSwkZ5rh5FXasJDofKfaf65HSKgePD3GLDqoXZlRHbdQTDuwK1T083m65UAS9OJwgzx411ZiEWaMeBuaTGLu06pSmr0Fyq0EicKO7GC+E9iNB7A8Tr7aNgy3D2j/g2nLxRag8KkzFdLaUlhOGZlnSZZaiSEKSR5DdY80/HulfEaSG/E6Yq96x3a4Ns9vEiN+tWBbWeXGy9RVsCSLcdxqiyoFIHFPfJshK4Z5/GelD+d5SsEDFUuDTxzo3Pwq5WJ1g+qxHBdqb0j2np5kV6+5cd7eLMEvCTq1WF1/NL24wHTXCpIzazjJhVMN6AAySpInzrBTLrkGaW9WORxMRVZcw8sG08Cp1RQJtS6DX6xwWaOWXiyK42pZW1ClNzMbE4yHlmFPhma0Pkq4tMFsrjs9/mbSd6/eS7URX1SuYws9EBaofwLRbPlA6VcGzw0XUkBLXQouwgq+TIvBRfxZnN5wkMmxy6QiMysCQaKjRNXy/Jc6dJ6nTMF3+51wvTeOLXjg/hBVf4si5RCnkPMEey0UBVpbwVn45Ilz+e3rfSLd5ccRraTHOTfB3urdX1bive7sB1Iqy0cjPgNdXCL4ki0+8DAZrGsOHZQK2Y898TTVzbOdghVIKIFUxBOZzgsQo4QlLuTA3vgdmbMnmgexyBoRRjaR2xPpriLqTAG2PVH0lduay4XoAhLbGN1RjLbC73STCro8wtQP5go9Dhiv5ah4tsGGRC/KtlDSFYf9nVvHf7cAP8maqsQp1hjdHqh5Ual9E9CuMQ6n9NQcFfXBopDmxQn8W3loBzu5KIsskEkmIsyFz/E2bEtRhuI7yww21waSgHhF/2LJhZLpanPK9cCfJPhXYrSH2LanaKp6PAIM7IHORpzpWBi/nNDBwg6kiZuzTfqRB
 KwLUxecW
 uwRB6WC+I7uFKTb6kENJKoAqpfJMSm0IhF606/99OxsdP9E8GymOAzWtAzcW0u1pgQ9HB0yj0+QUw+4+xVgmlFlO/W9rSyeATeR8KUbp0pv1uxxARxOz0cruM/vKljRY3nKr8NBOFTMS47P33f/5Koisg9m+qots/Nt+h19K9B63nU4xXNao59luJtWCDPegGCsJEQ1qkhYd3TKb2JJa2C9f1RJwtj7QZe/3/qdY+neMKhT6YXnzXmZsVux6XRDh1FGzbqY9UskyIPPWY7HhfE7UpijIqys4d8YwDeVA1G0Knoq1R60jNQVyX5Zt2eOFkIjMLu2tnljQaAKZ/LdofeL98dmT3vP0kUUZzzGFBIQrxFBY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I show you posted a new version [1] of this patch, so I'm skipping this.

[1] https://lore.kernel.org/20260322225627.263202-1-objecting@objecting.org


Thanks,
SJ

[...]

