Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11BF5CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 11:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 404738E005E; Fri, 19 Sep 2025 07:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DA668E0053; Fri, 19 Sep 2025 07:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317438E005E; Fri, 19 Sep 2025 07:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DBF68E0053
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:56:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC4E58726C
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:56:23 +0000 (UTC)
X-FDA: 83905847046.13.2309DC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2B60680011
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:56:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AfC2hGf5;
	spf=pass (imf30.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758282982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/rezV7vWcomrFYTNFQ1b+JfzxUwNii1PPW1DgulgkHE=;
	b=BdeJ85X6AbohIvtnZGZNI6SpuH1e+hrYdQxRxYdhf87bS21b6B8fXZyHec56tFAJrXFcvQ
	Gyac+sIZO9IAXKorUyZc71Ml81xbQHdiNeP1mtkYSAxrDX9LtNyVQi6VsnAZH5tJIcp1Zx
	zA7wqkdvTa8EN9diNawmTkTaa1rBUrk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758282982; a=rsa-sha256;
	cv=none;
	b=cs2U2BNE1Nb5Sqm0D1yE3s9E4gQQbO+93HJ/5R9pjZgMQtrOmfnTg/J8rDV5m3I3KiUwt9
	u4/S+t+sanhrb0AUHCbCT65rLX1jpZENGUOoImjBOo0iuSo98jtoPnwTRA1v2HnL/heZ5P
	OTOjShz7daJzLxK/morEaPObD6+dO3w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AfC2hGf5;
	spf=pass (imf30.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 71E7B6013A;
	Fri, 19 Sep 2025 11:56:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB7AC4CEF0;
	Fri, 19 Sep 2025 11:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758282981;
	bh=2g66+OQbOGAUuogUvn9+t6VAr2aTSHBay+sw1hDooc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AfC2hGf5WfHc9ZZKlDUiYPPOv1IgyTIvSrw11oXeh/kxHhhEK0c5dF5I5xZirlvZb
	 ohqfOhKt64jBwm8dPvrzIAchNQC76cXfOIgD270EA6XSVTp/j3xmZgT9PciA9fZOqG
	 T4OhFZ8a+knvgc/mM3bboHb5xP4N2LeZ9Yvr0w2hs6v4sbApfVNJZPy4hIcVLTYG37
	 3wUhwEptEpHllSdJXG4HAJgCM/ZPF3ZuTlvS1gY8AlGph3f1cuxsm+lpQuHwkL5htm
	 47bH0mcPQ3HIFSVkndmkYTLTOWcohN4N1FVTrv1BBGhUr7NQRGaHabTY3pMgPeR3/v
	 tz44Xirfuel1Q==
Date: Fri, 19 Sep 2025 12:56:15 +0100
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
Message-ID: <aM1E34lRjKg7nlRu@willie-the-truck>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <175822779944.710258.10028837182267037801.b4-ty@kernel.org>
 <fc43aa07-d4ad-47d5-8381-61d4a9b8c467@arm.com>
 <aM0-FQlepoxxGkRd@willie-the-truck>
 <ceaf604f-8ad7-4e19-812e-7eeace10d835@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ceaf604f-8ad7-4e19-812e-7eeace10d835@arm.com>
X-Stat-Signature: 8xbb8sps9z4wcqqo8zjs9pjn5i4hukss
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B60680011
X-Rspamd-Server: rspam10
X-HE-Tag: 1758282982-776015
X-HE-Meta: U2FsdGVkX1/VP0OfokQgbiLjOD40eoBJdg3FPW3AzWMR42oRsQ5v2+b0w5gvvDu65Nn95+afeBPE/OGHlx37lNFUuCWfshwlbUgSMF8e/qZqJxAXJkXY7WdRiwARlCqbBFIgGVWCEgGV9iuymQaftwQwFJHgTh4CAYAOJFk1XKwuF2ATOQhmjPFX0LBT5FZHtmQhcFjrEupRNW3HDhOMgGo3ip0j2R9YGzT9FilovmrKD6FstN0q6OpBxIxV7F4IBnLaldugEj2NeqWgQM+6aS0hjwvSBlxee1yBuiQU8r+kiI7Jt29dSstSp1SmaDDE10UNQdDrlkpjV3hmJGqOupj3dV3u1Q2lZTPhn5V+G7WcwSvzEVqxlI+bQEU/k2cBRg1C/0VYlSyBhPe0STKzAifhcqm4PgswdKue4P86S7SXK+bCedyLjijgOOZBD95tIiXpQ63ka3la4MFm/AqqoDXDkWp2Ls1eUV0GbnZtAmugLzi0JiHOAxWOlH09Wqx7ZiiIDgDzHw38CI64sLTLGl6MD/J434O3O/wMsbyD1JK9ujfSM6BtJxAqF3JJklL6bXbhXbFKC9B1+9HRrad7Ic7Kl0cQ58bsAvTRM+cEZcFqCQWA9SB9/gs5VGCrWuCRJE+6FYd9oea8VHxoYp7IscqjR6OP9D86lJGulmdljQr/iQ0XA4iZjh4i//t2aFbcIX8ySYQTnw9FkycRSez2epq6KvBWqY1DkdrYlZrkNtw8v+uW9s3+TslBUvLwLLXmH/L7LdlEon0JpOyvUb4dQUs78zA+kBHjFSmMqxhidSo2l9DOuXN8NcSFJIWYmULg6RNYeNDC8PSSzpFgsIruA+J/0fid5SI5rGfU5CNzV4QAFUrXpsRWT0ValgqRrj91hryd2iP84triUtoTVS/8CruIeqORUu/FFA3UhhDXhj5BcFtsFQHWbDJPZdmqdmlLfY/WUYqMgUWq0Q0NVvr
 B/bnBu6E
 hwX2iYZK6lek1sveg1FoL5T6R5r2u3UsJsjQoyB4MbGerp0Jo3KNQpuH2n7EIU2QBSjzArGhZyoVXBtDfWEg76cL3S1YLP5sImxmJVqWLl65gZ5azu/5i+V8IfXop54j/PwehAEQnVZEgpOZYXBW3a0m6FZXDyyNv38sCi7l10judPwxI5qUpUJWX3m/NcAYAvPSza0KDXegHwRa0SnPDH/xY4FZ4o58L9pHsqc2j94gIDBY4F7CrYgfjBI4VSB8UPlBUDuGBhsMEIg1oJfABp2uTyL7MQ9nHJCTHAsN/ZCpyCuEu1t1GsECEJtdkKKeMc9iM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 12:49:22PM +0100, Ryan Roberts wrote:
> On 19/09/2025 12:27, Will Deacon wrote:
> > On Fri, Sep 19, 2025 at 11:08:47AM +0100, Ryan Roberts wrote:
> >> On 18/09/2025 22:10, Will Deacon wrote:
> >>> On Wed, 17 Sep 2025 12:02:06 -0700, Yang Shi wrote:
> >>>> On systems with BBML2_NOABORT support, it causes the linear map to be mapped
> >>>> with large blocks, even when rodata=full, and leads to some nice performance
> >>>> improvements.
> >>>>
> >>>> Ryan tested v7 on an AmpereOne system (a VM with 12G RAM) in all 3 possible
> >>>> modes by hacking the BBML2 feature detection code:
> >>>>
> >>>> [...]
> >>>
> >>> Applied patches 1 and 3 to arm64 (for-next/mm), thanks!
> >>>
> >>> [1/5] arm64: Enable permission change on arm64 kernel block mappings
> >>>       https://git.kernel.org/arm64/c/a660194dd101
> >>> [3/5] arm64: mm: support large block mapping when rodata=full
> >>>       https://git.kernel.org/arm64/c/a166563e7ec3
> >>>
> >>> I also picked up the BBML allow-list addition (second patch) on
> >>> for-next/cpufeature.
> >>>
> >>> The fourth patch ("arm64: mm: split linear mapping if BBML2 unsupported
> >>> on secondary CPUs") has some really horrible conflicts. These are partly
> >>> due to some of the type cleanups on for-next/mm but I think mainly due
> >>> to Kevin's kpti rework that landed after -rc1.
> >>
> >> Thanks Will, although I'm nervous that without this patch, some platforms might
> >> not boot; Wikipedia tells me that there are some Google, Mediatek and Qualcomm
> >> SoCs that pair X4 CPUs (which is on the BBML2_NOABORT allow list) with A720
> >> and/or A520 (which are not). See previous mail at [1].
> > 
> > I'd be surprised if these SoCs are booting on the X4 but who knows.
> 
> Ahh. You can probably tell I'm a bit naive to some of this system level stuff...
> I had assumed they would want to boot on the big CPU to reduce boot time.

One of the problems is that the boot CPU becomes CPU0 and that inevitably
means it ends up being responsible for a tonne of extra stuff (interrupts,
TZ, etc) and in many cases can't be offlined. So it's all a trade-off.

> > Lemme have another look at applying the patch with fresh eyes, but I do
> > wonder whether having X4 on the allow list really makes any sense. Are
> > there any SoCs out there that _don't_ pair it with CPUs that aren't on
> > the allow list? (apologies for the double negative).
> 
> Hmm, that's a fair question. I'm not aware of any. So I guess the simplest
> solution is to remove X4 from the allow list and ditch fourth patch.

That's probably a good idea but I have a horrible feeling we _are_ going
to need your patch once the errata start flying about :)

So how about we:

  - Remove X4 from the list
  - I try harder to apply your patch for secondary CPUs...
  - ... if I fail, we can apply it next time around

Sound reasonable?

Will

