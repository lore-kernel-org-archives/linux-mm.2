Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B99410A3D80
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F7B6B00AE; Thu, 26 Mar 2026 08:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B402B6B00B1; Thu, 26 Mar 2026 08:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2EDB6B00B3; Thu, 26 Mar 2026 08:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6B76B00AE
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:12:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38C2B1A095F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:12:11 +0000 (UTC)
X-FDA: 84588101262.24.4AA2CBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5AA684000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:12:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f2NPtvnQ;
	spf=pass (imf11.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774527129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqGfbNl30NSapuxDl6F6achIWjPcAOkI3q+zHc+HotE=;
	b=zI9zA00tGfe8URLjLu4IXF7+fksYXRI7ODd/sf5DzvsahLU98e0oUS5sZjKhXfOgEuYx5d
	TtNVe5IWwoHI4xROR+skRhUnZC2DoVUXfvRnPSj/pqZnh1g79EI7oJ64axTA5U9OR54vRR
	pSi04ZTWr2uYFueKYRCmsA1r/2s0Z8E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f2NPtvnQ;
	spf=pass (imf11.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774527129; a=rsa-sha256;
	cv=none;
	b=wPDiNz2V+giScX1RJaHa6kMM4yLmDHGZy8HrdywXtTfOFwLajb8SBFggJUHPjnpExwqGEV
	d7upFX3Aii3+bbA83PdhgLfZ0UD6IWIKvnS1E84VOtDgqI+ZjbDQbylRYHx0Fqt37qPBgc
	qSYi0O+FcsycMSKFq2B1sgB9beIxGvk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 739A544233;
	Thu, 26 Mar 2026 12:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE17C116C6;
	Thu, 26 Mar 2026 12:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774527128;
	bh=GaoPImR0X0ioFmaoaToA4myk9U0YdNsMsVeE2CapRSo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f2NPtvnQXFwqudU1WmHW2/RX98/e5740Zc3kpalBsO0rznuOvLs43E/vF/dsq1Hwp
	 x82BfDnSCbVj/UE9JJeVqP/ORgTH4WU7w19kl4iWMX8DliLjdUxoYgfSnZf4XzxGnK
	 wbKD/gF3aC7ajt54ErRFBCKRMqk4OzUAEY+bWR3WFFEztBF4pXXmI+DdTsiuaYt9oL
	 JnHRoSpoMuAMpr+BtDwkeWwVSZwxlNeG8JQWHNeflLf3xGo2PIVJriGbu0QBGtD7uL
	 8NertDYo5N3pZCYN/kwygA2m66N7wr5sBQdtAJ/3u1fWGvqAsm0i8SUdYa8J22+1SZ
	 GKRh8BS2sOIRA==
Message-ID: <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
Date: Thu, 26 Mar 2026 13:12:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Josh Law <objecting@objecting.org>, Josh Law <hlcj1234567@gmail.com>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5AA684000C
X-Stat-Signature: ntzsfwr3oz1s3xwcbjskwco599xw5fdx
X-Rspamd-Server: rspam06
X-HE-Tag: 1774527129-781707
X-HE-Meta: U2FsdGVkX1/gLJj+uQ6FKUIro7NLqedJEC7IKQxGbWg1lP2W79qvCt4rcKd4Ry6uv6naqZAWzS8vTvVbhuNpJcamR0KDqhs03GXag302JbBjjFUwh39iIabJQhMma6CQAtCklh12hHyRtB+EdJyXtIygk7wmjgcafytH/45qQlGharbE69JgKW4EAv0tRM2xs0XluE+qBhvdy909BTRsZDW+Ih9NUTIPkBV1vgaCtgpoj2eSgK1q3S+7Y7Zqc4uqe+9M4zAJ7WIG7vgqA/sIlN/xGMSDId+hPIZ0fUAN4E+92WsyM4KC0Ol3VlTtz/wUuN0tasdLthNZJCCxsML0ewTqnyiwIv4U26c8PEDMaFctSpw8mUYkN6QXgJV+NRvfvDN/ewtC1/MgWNKmkHjgmeMP267N5DxYL+/+5x6ea5ZTLWfe8++muy0UUoKSwUNzuBpbsZZODoL9j8gdgWNIgGoU3r56+ADVQmvmLfvApaSCVNrUKvg2y6zr+oQZfBAywuRX3BzPedzY658teLFQ7U9kTPN7lbgv+v2XZH0s4CzthAZgfz+5FZSEiJPyYmib+LvQqpL9bgjV+VDTUnMVGGxXFdMje1ezzwBcb9UvqXCYvH4mGAi8vbInWYVdsCHZNMXgIrRAXOAJ/T6EIygBEE/Jq+UKI/GSL0hs12JojyC3POLZRoCglF5dX0RvSol8mlaXErPrvqwn/75wOeyDR7xcJDdmfllyzLYXQzocQ1p5SL9vEG4NYpapKkuruY+6Lznt0Qrivn2b5VB7br5xITwibi3sxb8UUMhkR5OJp3OXSKiDLpAgrHNDEFRcN1AtAcCJcx9EyqVVTBf4lBtLrThtLpf5OoRv8/RW+3756qpWC2jTSfBNc99JzIj7+aJnbd29bBf1BvEHj8eK3hhlkBXSFZ4qMcvl3JZ0YykQRenran8rKPVtLnWxc5BCCqG2nftv2ANpu8KFq6ARLpZ
 b239b09o
 Kpcf4Yy2kaTTyVk4tmDhN9RlZxHqdWHKBEcxRr9fwCkjFtTHOigE2i0wiU91EkSL8Ay3W9hlayuTTeIEjsfdnmEgrjJyoKI46UavLhhRYlCVI7vj60tilAm2uhTJcZqMAKDlwCnxDISMVRv2GtEqf4MleOjW7CGoqquHrm8Bb+41a7GxrTogpC4HJuxEeYyeCW+t8rC04s6QPwlO1ZD3sSnQXJO2Y4GUsXh197FdmRNMx3T4DPn67DxIt47MVWUEQlKOd2LWMuzmbp5mtqTcMcySz9M5yb1OJcLPLOiywFtvo/08y9pru9h3fD21V41QXwGxEEfGrobkOQKOHI8BQrArpDFEUKhoBvJe1HH/Lfb/ki2Xas7eC2o2+pinwZbnZo96nGKEMkLQ9TSooivpgzDBiSyfljw84eLk2ObXz8CSgZ+5UoilYjKDYaYaAHW779hO/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/03/2026 11:34, Lorenzo Stoakes (Oracle) wrote:

Trimming context, I agree with everything said by Lorenzo, very detailed
analysis.

> ~~~
> ● Looking at the headers specifically:
> 
>   Infrastructure:
> 
>   - Mail provider: Zoho EU (zohomail.eu) — a privacy-oriented
>     EU-jurisdiction mail provider. Easy to set up anonymously.
> 
>   - Domain: objecting.org — custom domain, no organizational affiliation,
>     no accountability chain. Anyone can register this and point MX to Zoho.
> 
>   - Authentication: DKIM, SPF, DMARC all pass — but this only proves the
>     email came from objecting.org's Zoho setup, not who's behind it.
> 
>   - X-Mailer: git-send-email 2.34.1 — Ubuntu 22.04 LTS default. One reply
>     had @ubuntu in the Message-ID, confirming the platform.
> 
>   What the headers DON'T provide:
>   - No corporate or institutional email that ties to a verifiable identity
>   - No PGP/GPG signature
>   - No Signed-off-by chain from a known developer vouching for this person
> 
>   Supply chain attack assessment:
> 
>   This matches the threat model of automated supply chain compromise:
> 
>   1. Patches already landed in stable — the bootconfig fixes made it into
>   6.19.10. The pipeline is working. Whatever is in those patches is now in
>   production kernels.
> 
>   2. Trust-building pattern — the mix of real bug fixes (fd leaks,
>   unchecked returns, type issues) alongside feature additions (DAMON
>   tiering module, glob features, debugfs interface) is textbook. The small
>   fixes build reviewer trust and merge history; the features add attack
>   surface.
> 
>   3. Volume as a weapon — 328 emails in 11 days overwhelms maintainer
>   review capacity. Maintainers like SeongJae Park (DAMON) and Masami
>   Hiramatsu (bootconfig) are now spending review cycles on AI-generated
>   submissions. Even if every patch is rejected, the reviewer's attention is
>   being consumed.
> 
>   4. The DAMON NUMA tiering module is the most concerning submission — 409
>   lines of new kernel code that runs with kernel privileges, monitors
>   physical memory access patterns, and migrates pages between NUMA
>   nodes. If accepted, it's a significant new attack surface delivered as a
>   single commit from an unverifiable identity.
> 
>   5. The feature additions are the real risk — bug fixes are relatively
>   easy to review (small, focused, verifiable). But glob_validate(),
>   glob_match_nocase(), the debugfs
> 
>   BUG/WARN site lister, and the DAMON tiering module all add new code paths
>   that are much harder to exhaustively verify.
> 
>   Bottom line: Whether the intent is malicious or not, the pattern —
>   anonymous identity, AI-generated code, industrial volume, patches already
>   in stable, mixing trust-building fixes with attack-surface-expanding
>   features — is exactly what an automated supply chain attack on the kernel
>   looks like. The 2021 University of Minnesota "Hypocrite Commits" incident
>   was a manual version of this; this appears to be the automated version at
>   scale.
> 
> ~~~
> 
> I'm hoping this is some naive attempt to try to 'contribute' to the kernel
> rather than something more nefarious, but the seemingly sophisticated
> tooling used makes me wonder otherwise.
> 
> In any case I'm deeply concerned by this.


This patch also targets NUMA which is quite unpopular setup for
hobbyist. I don't have any NUMA around me for years... Even my build
machines are not NUMA. How did you get one as a hobbyist?

Also after looking at the code style in this patch, after "reviews" [1]
and "acks" [2] (quotes on purpose) this account gave on various patches,
let's look what was admitted 3 weeks ago:

https://lore.kernel.org/all/f8772114-a495-409b-a590-a9b1d8ed1d41@gmail.com/

> I'm learning this Linux system day by day

So learning or adding serious code for MM for NUMA machines?

> I own this device ...

This is about Xilinx AXIS FIFO which is an FPGA IP core. No way you have
it. It's not popular, no easy way to get it in common embedded boards.

Even assuming if you have embedded FPGA device and work on it, the jump
from embedded to NUMA is just stunning.

Answering to reviewers with whatever confirmation they look for is also
a warning sign of non-trustworthy behavior. Or rather behavior trying to
get trust.

[1]
https://lore.kernel.org/all/D47F8215-FD08-45ED-AB01-0A5C48CD41DD@objecting.org/

[2]
https://lore.kernel.org/all/2F84DD09-2880-45E0-AA98-204F10848F85@objecting.org/

Best regards,
Krzysztof

