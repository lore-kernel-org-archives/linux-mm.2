Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01368C88E42
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 04:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6A76B0088; Sun, 25 Jan 2026 23:22:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62AC46B0089; Sun, 25 Jan 2026 23:22:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 536436B008A; Sun, 25 Jan 2026 23:22:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FC836B0088
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 23:22:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C5AA1B0721
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:22:01 +0000 (UTC)
X-FDA: 84372817242.17.C65291B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 826494000B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:21:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mx3khty3;
	spf=pass (imf11.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769401319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLUqjxXZv7lWAxSUjPYCz/KXL/xFyVEfhNPKReA43tI=;
	b=KxQ2KR+VozeHEXOYhYSEfdsc0Bm1OB09v+XAqPKktYKwuMOvdbWIyWz+4teyfjl/JAumsa
	+rE5aj1Oa4sBfREHcw9hYwJHk1yPxFv9CpaB5tuTkPuU0HYBKEsKOO/G/ULgNHL+KeGDrA
	bOXjbmzrXyQ8MV1MC24gQJExY6lLlkw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mx3khty3;
	spf=pass (imf11.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769401319; a=rsa-sha256;
	cv=none;
	b=cQFz7XtmpvWzkxx8d9YEOw2gO1wAukZ4G78/UDo6s3vA6j1vnOCezPCdbNnlLy0fJz8ECW
	7MC0qLZwurtcwc6ays1QENZivvJCVfCZbUnxhZRguf+hggX4ocZ8wogdn1Et1hrMAyhetq
	Favd/oPCYQuHvklI7rDVZCC3bCs5vhQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 38FED44180;
	Mon, 26 Jan 2026 04:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163A3C116C6;
	Mon, 26 Jan 2026 04:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769401318;
	bh=u2mZjtT2ef63nBRxN806PtRnf8Sp48BSpzrnucxNvLM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=mx3khty3+dTGClMOSsm4TCGURDjhMxIJ6Hr1bO+Hbm7pIDDMRiqqUI60/PSBokAlS
	 XDKfB/qj+L3xyJ2qvyINgs0wD1pWn95s+Rkn2LpKpDZVb3Qm6E11lRb6+gmxfXX2fp
	 Y0puJp0SfTExJAn/+KhCOy5Bb/Cb4Wib65mAZItqOyzuEp0PMSk2hQ9F8YHBPAhLUl
	 4OkRVSJbQNM9okPoSdnbRH4h5yxkAZi8MRJuUoppDD2ti/3VZX6AQcX0/6q4RJB+hX
	 BoyEqXvgV5dn4f1qXwsNoEWqJw9JT7awjVq+tpfrUMGLV8dNWUCboeRZP7SRPsDOMP
	 iCanGpQICOKlg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 11B303809A22;
	Mon, 26 Jan 2026 04:21:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7] mm/hugetlb: ignore hugepage kernel args if hugepages
 are
 unsupported
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <176940131284.4057692.12950572087692218599.git-patchwork-notify@kernel.org>
Date: Mon, 26 Jan 2026 04:21:52 +0000
References: <20251224115524.1272010-1-sourabhjain@linux.ibm.com>
In-Reply-To: <20251224115524.1272010-1-sourabhjain@linux.ibm.com>
To: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, bp@alien8.de, christophe.leroy@csgroup.eu,
 hca@linux.ibm.com, mingo@redhat.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 muchun.song@linux.dev, osalvador@suse.de, tglx@linutronix.de,
 gor@linux.ibm.com, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, x86@kernel.org, david@kernel.org,
 ritesh.list@gmail.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 826494000B
X-Stat-Signature: 4bhsq995er1yp1ri4r16zd3furo6ruuc
X-Rspam-User: 
X-HE-Tag: 1769401319-715506
X-HE-Meta: U2FsdGVkX1+hbnuU+kQKtkHEZzQlp7Q6jHzoYyTbNHNJseTVazNvjFh9zGUdnWBGJO7Vd7hR1pZjs+6qex10vxq/L/2uHJ8GEE2//AsEREZ8sxiqnRdQ7xd4Rbp0up4BmOImfQQA3UHS3kEHHywoqtroAUmew3HtTwF5CnlyltLUiqv5eI/NoTzMxJsolArhnAH+HO9yNUrUTSGBOTqPZTohixkt2t56SZMFnVVXhGpJSjP3M2GtUa64BQTQEEsIPqeo3yWJXKsK821hQwqUySZpGeEwVfjAOdyVYVHxFGQ2Y0iKyvhAkpuE7TyKoRfw4buR0mkWLkgV72UlTPhQS80R0WZYFB95QxPr6hKLlMt3hj7+QxaKgPnJrOUPslKoMMoCtu1yjYaD9ULAnSi79B2N0AAlrFAWNOUEMfmtOBz+3aP6mO0gp3RiGUY2nQpVrO4jxDcaFM6VxHfY2TG5mgodHnhWxW7dXMJpRtbtViHWqQsD6rZN257jBO3zhGiSNPp/xcptml/OcAfjUbIFLRPF25Tqa0IeZDVWiddmBX5GYVAkPfyFi5K8UotE5MeyZqzs2MblmYtKhEbUm1G5Zd2tdLlUwbfaiTsWIZrLAnx+9DShHqE1zUi+UEQ2FIfj09hzRl5bocAe8At+En32clwBzcOpCES2ewtbhcfSJEcpy6GgHZhin0VaXqxr8gnIKwl9ql68MlieNaK7mQaqJdmnbwDzJzOKT2dHTr/blPm6XYg5T6MN1XrZLAUhVOWqQrmxe9T27xhV1B+Y843cnnBUiwS81rkksT+fjRo2Lc8m6rPQRu51sqw4Y/rwTfBejcKos7oyVgGLN9T8FRNlnTXvSKH7Id0anvi0MZ380pt4Dx9YaZWK2VRicjZQSmd2HBa1APX7dFOf07wKipB4i21buD7eC1/VfanitCO8ZveDg7RKojCJ8BLDh8zow2wzrCgpi/OcoxJ4SLdjrV/
 3qesDLDx
 9/br+ux2e00wVGkopIlGKgGLPPfVXWmjjK4tYVW1Vuk3l7hXTLwq3wMJfRMsMFCoZLapoD6702rkCvUnaR36dkk1zDSz8RUWEi2Wcj8WkUE16bRBKVVfHKafDIPegna4vgnm9PzPSQ7RwV3ZvyxMxzBVUqxdhYsGzu9PczlHG2ojUHRQ4OJOV4+mrGFJXZDufCNBGeo+dg+VgExEKZmfSDMyowX3brHEBIOhWs7dZCZL7X/N7h2U21PM9ConF5AOVt6jZVPfCdsi0trohNFXwjQ55OGJmW95QovBdA/8eivheEMF5SDZlbrgN0Lyf/+S4vbf1XjGr1GHFTGih80Z2dCl6ZMq9IrrosrBwznH2ZPp4NlKOOEs/TxGlK+aHe/kRUspOpPf5MLzcWTeCgtrH4eoDCdwUgJHWJgbvRumUNGLyYczyuS5FFmBcspxZX8QQCHELFR93ukfFfgVzxlGjeEDy8/3967erLhN0LBQcsKfwaRnmd6W2zlPW/o18DBIwCIF9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Wed, 24 Dec 2025 17:25:24 +0530 you wrote:
> Skip processing hugepage kernel arguments (hugepagesz, hugepages, and
> default_hugepagesz) when hugepages are not supported by the
> architecture.
> 
> Some architectures may need to disable hugepages based on conditions
> discovered during kernel boot. The hugepages_supported() helper allows
> architecture code to advertise whether hugepages are supported.
> 
> [...]

Here is the summary with links:
  - [v7] mm/hugetlb: ignore hugepage kernel args if hugepages are unsupported
    https://git.kernel.org/riscv/c/b02019169284

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



