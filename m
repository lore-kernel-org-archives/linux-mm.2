Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 421DBCAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 11:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A948E005E; Fri, 19 Sep 2025 07:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721F28E0053; Fri, 19 Sep 2025 07:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65EEB8E005E; Fri, 19 Sep 2025 07:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 514F98E0053
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:27:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC6FDBA616
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:27:25 +0000 (UTC)
X-FDA: 83905774050.08.8A4FF31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3E465100004
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:27:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KyDFhaX0;
	spf=pass (imf14.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758281244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIkiBvMA6JeWONNzDm5/DzBhYza7SWGDeRUB71fxshg=;
	b=yqTsr31Xz1do8PwHcv+9EI0seaO+UFAgRd6hBvCy/YJ6s56OjisApVmHi9/zt011iwI9hs
	IIpgOwRxvAX2OjhW1DY5tHUmbWfcAQt03Z92HwYy3DwpD4ft+UjNFl9TU3XnLiUHW++I/0
	0dkP4XqnzYdaDcHrsX1RG/OWNK2WajE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KyDFhaX0;
	spf=pass (imf14.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758281244; a=rsa-sha256;
	cv=none;
	b=Ikg1GZAodtrqQ+dG10iVtXmU1ToIuRYQbsO4vmFdSAgCL19SJnisNF4pq5M352q7vnCgjK
	Y0GuotDn+NwDljfXt0zqfxcUJqD8KZViFVg7Nun1bUyZ4y6G+jfTbcfDXB7WsPXXH2KMJu
	OpwsVGFAPAkgu3Cv3Os5L1m9C1tFk+E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51AF860053;
	Fri, 19 Sep 2025 11:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C01C4CEF1;
	Fri, 19 Sep 2025 11:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758281243;
	bh=C7w7HkIT7yX2Ji+TqLNQ8VqWh4vuv3N2kHTkNH+vyH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KyDFhaX0ckf5/YrwFt0U5X9+9yhz7wuK1xRDrQby4m9loYda/mWYsYv9SY59N4gJ6
	 5d073ME7gJ1z9rA31EIzjFcxe4I3AVQIT/2NSGorRpYNEOtT+F8EhM2AZW46Dw/n0Z
	 vaGYR9Xfm5JfGdqLNtiL2cnXXVqj1BrqYqoU5i4BKvOWzGv2Yd7B4cAICNJ5fC+Vc8
	 uGGjcIe+DLFxmnd3I3SiLsEKP6g/IP4pH72Gg5RuodsraJis5EAIqdG5XWt1P3jcEV
	 Huk4QRaOzR7e3qPnBSCwxW8/GHEjjU+k0tlGpa0pNjQEMA5kAEawmKxX5Pe+HA5fh7
	 knPyNOYNgXPaA==
Date: Fri, 19 Sep 2025 12:27:17 +0100
From: Will Deacon <will@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, ardb@kernel.org, dev.jain@arm.com,
	scott@os.amperecomputing.com, cl@gentwo.org,
	Yang Shi <yang@os.amperecomputing.com>, kernel-team@android.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
Message-ID: <aM0-FQlepoxxGkRd@willie-the-truck>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <175822779944.710258.10028837182267037801.b4-ty@kernel.org>
 <fc43aa07-d4ad-47d5-8381-61d4a9b8c467@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc43aa07-d4ad-47d5-8381-61d4a9b8c467@arm.com>
X-Rspamd-Queue-Id: 3E465100004
X-Stat-Signature: 8b4m4gc5psnq3jzh79dyt1fjaepd9yuz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758281244-983881
X-HE-Meta: U2FsdGVkX18I5Hcx4l+FGbJUmnLrvx7iMZf10zbePnkIKhosVeIVojeYf3IZ1GYisURzg8McinHpyO5amSuoXkgayqkATxQ+js92pPkV+5m29RY2IwKLF8xbnC/02LHuwCLZ9t+T1ImwvVeFqPvYGIJV6FKwcbOYSQYNb4Pp5PbBFZWMGcW9LbcZTuODD2frgcxgS58o+JAVTpl+4WSGwaF65PUmhaF29TSDgRvCpVQOGgUEJHYYO+drd06HAyCsVX19Jm91dcOfu4uAMKP+us0FfLD7ynjz3vonZiUAc3AWkWIpug4aQbCO38k0mjqbmqi9oyf1zof72cvQLRDcjkJEceQWJK+7hB9UBjb9r1VpH33hgv5Q0FKdC1jHz8iYIGTR/OxkV262kI8qrddqXn1VKhveePXJ5kaS1LaqHN1+88STgRrXxm6ccY4JZ4AGQ7GdNvE2NDkfLQ3zF/zi7w1Bj9rl/s/kDzPT1PsT6ubzxWuOgItaS6ydASu4pI836SWYMPSwUPsMb+VVwFqyZPstgtX08Sv9MTy+Edu2UfZ1SIVp5ObAs6vIsBwmjPza5lXAIrZN+gRgasOz4UFoq+biqqzusy9tQSR5hcm0qt1h+d3J0tcqVPb1MtAQDIyO9+Fr69YbLwZocNXEzRb8YpsSKE1LD6gLJlp4NCn/ayyFkrd7r44lcPvLbKNMDcRCmfJW++jgjigUIFR0ACxo8mGcDjt/NKmrabtLgiW7il6lNl6gHvbOpjfTn3EBRSFBwMD76qmcd73MQ6kr5ECON//WsmsIa8t8DRAkzTkX+HmsJ91Bu6fT5SBLDBXtbz3yV/xpfHEQSLnKrIsO+nGeGMB3gnDSUzFd8uGEIssIQf9VpVQN66PuVI6YbtqTVA2DjadFTxt0mzVa4gkJhA4tO/TqphwdH8AyGFSTeWKJeb/Iv9ugXrwl9k1Y2Xtd+7fEPQXcNOGo2TX3MU+Hys5
 8s9ctJeh
 Ie8ah96iQSLc+tsfgVWnwsMB6ImJkCn/J0NdrkX8pYiHwj/qiZw7aLdiQKKtGALefQnGX8k9t+h9LycjyfZEfXloGJIjy3bjQ1xqt4SeEtPeoz6x2o3kQwPfzjlaqR2i4/Duf+lKb6Z/peDfcLKRoEpUS4aL50eDCZoBTQPRL3EUiIHy6KsuR6HAkPL7EdEEUOWVxceuDlooJaGqw9ETG5KHpAYQLXF+rqOdndQl+9ndzdCwOJM+848aUpQCfwGoJm8Fn9GOLssnYJsK1WaIxkHQAzeugSk7z/VzQ8DsWD7Tazsg4eREIlS8SOAIwOErPdTMj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 11:08:47AM +0100, Ryan Roberts wrote:
> On 18/09/2025 22:10, Will Deacon wrote:
> > On Wed, 17 Sep 2025 12:02:06 -0700, Yang Shi wrote:
> >> On systems with BBML2_NOABORT support, it causes the linear map to be mapped
> >> with large blocks, even when rodata=full, and leads to some nice performance
> >> improvements.
> >>
> >> Ryan tested v7 on an AmpereOne system (a VM with 12G RAM) in all 3 possible
> >> modes by hacking the BBML2 feature detection code:
> >>
> >> [...]
> > 
> > Applied patches 1 and 3 to arm64 (for-next/mm), thanks!
> > 
> > [1/5] arm64: Enable permission change on arm64 kernel block mappings
> >       https://git.kernel.org/arm64/c/a660194dd101
> > [3/5] arm64: mm: support large block mapping when rodata=full
> >       https://git.kernel.org/arm64/c/a166563e7ec3
> > 
> > I also picked up the BBML allow-list addition (second patch) on
> > for-next/cpufeature.
> > 
> > The fourth patch ("arm64: mm: split linear mapping if BBML2 unsupported
> > on secondary CPUs") has some really horrible conflicts. These are partly
> > due to some of the type cleanups on for-next/mm but I think mainly due
> > to Kevin's kpti rework that landed after -rc1.
> 
> Thanks Will, although I'm nervous that without this patch, some platforms might
> not boot; Wikipedia tells me that there are some Google, Mediatek and Qualcomm
> SoCs that pair X4 CPUs (which is on the BBML2_NOABORT allow list) with A720
> and/or A520 (which are not). See previous mail at [1].

I'd be surprised if these SoCs are booting on the X4 but who knows.

Lemme have another look at applying the patch with fresh eyes, but I do
wonder whether having X4 on the allow list really makes any sense. Are
there any SoCs out there that _don't_ pair it with CPUs that aren't on
the allow list? (apologies for the double negative).

Will

