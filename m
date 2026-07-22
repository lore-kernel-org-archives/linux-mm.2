Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC03CC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9AAE6B007B; Wed, 22 Jul 2026 09:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4C2D6B0088; Wed, 22 Jul 2026 09:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62026B008A; Wed, 22 Jul 2026 09:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA436B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:33:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21F811601A9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:33:49 +0000 (UTC)
X-FDA: 85016505378.28.4D82AFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 630321C0011
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:33:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JyFz6jKi;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784727227;
	b=IO+eLgt/pc9D+/ljYx83JEgngbGSEo372lgyRk2PbQsYsa5KazO+QbAC43JoNPTPNntcmh
	k9zNJ1iWTLWZS9eqgQ4/YtE6rwDqRRimnmipGXWDhAoz7OSLor17ObU+qpGBcRxCLEelo2
	lIJc4QimJnq8rLzbnDe+xnqGOcgKwXo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JyFz6jKi;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784727227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTK1rlUFrmHBMlWiK/OncXT4tl+4gAfiT7OvDNlVqXw=;
	b=drSHdZpMIcaAMT7f4IOzXA96yI+Idv9k7E8xm6eLohSlEDAIzH5BoXt9Di9fevbhg4gEpc
	gi3ayyeaQzBtUadQjlfv6N5Es5EumGZCRy5HnZFn6RK39ID1NdwHO5HNeyFixTC2m1DyL+
	ohxBI0o9Fjfra6mbVzKdyLRCOoAsUdM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD3D1600AF;
	Wed, 22 Jul 2026 13:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D941F00A3E;
	Wed, 22 Jul 2026 13:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784727226;
	bh=sTK1rlUFrmHBMlWiK/OncXT4tl+4gAfiT7OvDNlVqXw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=JyFz6jKi/8sLexgerCnnlLz0zV0n78iaKObh9MK6Uez5siWAAn2pIsRabjenQjuGb
	 d7stkffV1HGriuKQgVAjmdUDDEhbwR3uVkMZps+evmzNs71uAyZA+09LNqi2Kw40lL
	 3BqME8yVYHZbg8sbIuWx0GDY/czPUFkgIKBHSiq42vB736jU89LBrrO8lrwqBt1ULP
	 x3SknDCyG8gEsPpxhCneyaEif2oC5wK3lJgYZOdwmCjzI4Xbu25gMVsjuB77J1fuqN
	 SfiB7gZPAxeQSiBlJ1XLNrC+Ny42d8scGr961A20CWkbfGpN+AFox/Vp9Unwk3U2Ed
	 N4LbdpLn+SzCQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
From: Christian Brauner <brauner@kernel.org>
To: Alessandro Di Federico <ale@rev.ng>
Cc: Christian Brauner <brauner@kernel.org>, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, david.laight.linux@gmail.com, 
 jack@suse.cz, jannh@google.com, kees@kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mail@johnericson.me, 
 shuah@kernel.org, viro@zeniv.linux.org.uk, Gemini <assistant@google.com>
In-Reply-To: <20260722011217.45e79a08@spawn>
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
 <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
 <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
 <CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
 <20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
 <20260722011217.45e79a08@spawn>
Date: Wed, 22 Jul 2026 15:33:40 +0200
Message-Id: <20260722-raser-leselust-konsolidieren-05f8e36a0782@brauner>
X-Mailer: b4 0.16-dev-2f6f2
X-Developer-Signature: v=1; a=openpgp-sha256; l=897; i=brauner@kernel.org;
 h=from:subject:message-id; bh=OSnqiWFGrRlyva5O8ZuwHNaFEVyx2w2j82qJYYjirvU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlHNt2svu4BouLxTaj4woqR5YtP+x/Y9XsZte+1I793
 lfvaBrs6yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI/qOMDL8fnliS92lTMp+5
 H1+LxmTXRVbWl47laBgleWVXPnXb7cfI8NfsicCsy2+cV7rJTjCY/P9NmXDCkTWzv8X+0Lsx+Up
 FBysA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 630321C0011
X-Stat-Signature: cfwup9zapof9xg188phor4zqpyafsn3o
X-Rspam-User: 
X-HE-Tag: 1784727227-56680
X-HE-Meta: U2FsdGVkX18j95z2PCh4SrCaxDP3ow8wssUZW5GWd8dR30vJjRHVvPA8BqEHZEkJGLft17Jw3IKZW5sktKkgy9SF8MptWoj9hm3vuBQyVWvJ9wX/K+Pb9YM8IhthNkTODS8p0AC5aHtu9qtDM89ZDGkpH769jjzgnK89p8pdA5Ocp70roT28isymB5Ui1EfROk1jzyviOk/zKVP377cIsLbMeQSMbEr3AzOahgc9sqMvZ3+ZGlEBUBXxREFtat6EFpbpSajKOn0CtWMaFIoWQ+rSDCHB8Sm2DzTlBFL14Kf4lQC4awQw7RtqZUuP+KsbEjTctCJB4ihS/H5N4zgt2G+9RWVwdpa+7SEjbJJvdHG6xUEhHwa6qb56JGYxQlGcaJgUduMPLVkUduNihwd4t0Dd1BZC7qQikNjFdVk0nKKwSWoVNtIYwiBbZ5qGiJzFE74PXB0t9BBN7K7tlNWJgEKdwztkmxBOJjtB1d7x6toCBvtdoodlpgIEkubwtrXLkmVwVhdIHMh4zsdtlfdOI0zaXMMJBR/uGeI8iyWSe5O7FCF2tqWj+Z5AoQI2Y7aBRmjeNfYx8iqWBRpDVACMUGe1+8psbbLYajxek0BBgS5YA9uFk0T8Cw981mKvudAFKucwdSU54jejhieDoR4jpzqY+V+hIpTL8aAZood4dSUZmcB859ljvNn1ao+QsEHR+4PKrPfp9szcmVSoh+tTAODmLoUv3GM7OjobZx2B8QS+INe6qicndLivURJp79dExdEMYOU676YWioGPXsRoBuypOOmL1wyKyv5RPQlhZNShguXmvj81dEeQ9m9mKTcIqF0v8m6irV1ivy3NKW/pyXsTWsSLnsWvtjQpfkW88uqfvLbp4Zj4hMveg0kGhgr53+n04zYUqX5wcxFSs/o4pgJk3wq1NOVrneYj0GJWQiZj+8u/zSWQsbYdB37+wzOjTdhQAxJ7WnMbRLPFabL
 CNznkqaw
 gM1Ejj2wyt9HkT6uqogs4rZdFN46yM1fS0J/hogbA+QL4uPxXCVI5hcIUzruYin055vRh6m5vooupBBou+3CBvWRpdeHZWpzMuMiRkACUkW9lEycgPH7rmUgwQ2kELXODLwMViueQfCOFL7HtMJIT8lcjtReg8bQpy81/9BLeBhe84OdOGabx6gyKpWTaHjVBWLOrH9kJsZyS4i4U2LKCpbPQwtymAHRqaPsh2q8MK+L7MYoh9SarooOy35Sxalv4GT9NGouJyZj7odilgJYnH8dpRmdIsamuJ7zdZ3w9xmzWE4duc8EzsTYSDIeZiS8c9YrLfbs1NivvUHjQB6lWe2LE80gs8hI2hwkbHjMmviB0RZwZUFGJh2zqo6fsdTO8JylnGfKJUolXwfY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> This patch could in theory solve our problems, except for the "no root"

We're not really enabling $ORIGIN in core elf unconditionally with weird
escape hatches to make it fit for a subset of binaries.

> > In any case, I think it wouldn't be crazy to allow registering
> > "default" handlers that appear in all binfmt_misc instances if needed
> > so containers with separate binfmt_misc always have the bpf program
> > available. [...]
> 
> Maybe we can have a "default eBPF program" loaded for
> `PT_INTERP_WITH_ORIGIN`?

I think this could even just be part of systemd. You ship the distro
with a file for that in /etc/binfmt.d/ and systemd loads that bpf
program for PT_INTERP_WITH_ORIGIN. Then you're good to go for all your
binaries with the 'L' option my other patch series adds.

This is policy that the admin should decide, not an arbitrary extension
into elf core.


