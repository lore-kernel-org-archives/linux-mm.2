Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D9C109E53E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 02:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37AB26B0005; Wed, 25 Mar 2026 22:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304146B0088; Wed, 25 Mar 2026 22:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC1B6B0089; Wed, 25 Mar 2026 22:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 062376B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 22:42:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9662E140B40
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:42:37 +0000 (UTC)
X-FDA: 84586665954.23.6DB515C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id F2992180004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:42:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S8zGn/i+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774492956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWjcQxkIkXKJWQMQD//4uoNpukCWFp7/8TrvqUt2M6o=;
	b=rEwhxAuoG6rRD4U5Vo1KHEjoA8BAjWumtvFlFxzy/Da5tdOZ7NGty+xYyTT29h6/snEYJ8
	sp5xmtE1J7DmCdsVDKtX3Qf58svWNVv/fD/ohV5+SHNAD92Kl/QC2I2UACAjCHbeysHF7O
	lVrEyN8qfUS2UnZmDfvnGiUihv2+swc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774492956; a=rsa-sha256;
	cv=none;
	b=4xbxJkDPA2mOgMulwPnPXyn7JMZnCMv0yS+ujPUrd5FN3hwKRYMsEkMkNu6iSxNGsouBf6
	wipqlTCFjXQvOsNaJXwyF3P62TTtV2fz8Tv4ugEBzkVSQarUb7AFB7CHEUAJRKHbbq1XG2
	oT0A4hshvMnB4mBha/h4j7/5yQ68AOA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S8zGn/i+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3113960053;
	Thu, 26 Mar 2026 02:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB208C4CEF7;
	Thu, 26 Mar 2026 02:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774492954;
	bh=zQaAoby1LL5qtX0PbqpV15cjdPtMgN1fWIPjYj6cHHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S8zGn/i+Spyx9XA47CpCu/vQAg2jkahFRQzQumLqtrDpCNSJTCj03aAkEznFHIBqF
	 BHqQtK9yH0jlsDRFhpqINdr/8qKOFZZ33DoLjiHS1rBQN8A7rN6+cd4XspEv86q4aw
	 fX5sdIVSmixq08mIaV+WQ20CFRO/xOqtaVcHBACJLjdgVgNEAW/1eD2ppZ4E8Sqo34
	 KMBXF5A5vLLXjt9vVzfBdhnIBFejLTjFksFyWA19+Dk1JNuNC3tUVbCRh3Eo+Ed2YP
	 iTNr+GVTtwyhLeEY70H14v74c5VO6yI6pMXy8ExXxlKbsKAbxCmXLa/pnbG4dlN+CH
	 y4s8jAUhtp60A==
Date: Wed, 25 Mar 2026 19:42:26 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	David Gow <david@davidgow.net>,
	Russell King <linux@armlinux.org.uk>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>, aliceryhl@google.com,
	linux-um@lists.infradead.org, llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	a.hindborg@kernel.org, acourbot@nvidia.com,
	akpm@linux-foundation.org, bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com, dakr@kernel.org, gary@garyguo.net,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lossin@kernel.org,
	mark.rutland@arm.com, mmaurer@google.com, nicolas.schier@linux.dev,
	peterz@infradead.org, rust-for-linux@vger.kernel.org,
	tmgross@umich.edu, urezki@gmail.com, will@kernel.org
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Message-ID: <20260326024226.GB2302780@ax162>
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
 <20260322192159.88138-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260322192159.88138-1-ojeda@kernel.org>
X-Rspamd-Queue-Id: F2992180004
X-Stat-Signature: gghzeqq8kdyq9edwusre1axinufohu8z
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774492955-394561
X-HE-Meta: U2FsdGVkX1/iCHp+f2g6/HbOVq4HLm3a2b1TH5kl274Tr6Im+1trevXpIAFr9hr68J4frrc3TPYpQCrGusX8mmebdiirgIyHKp0vFkcU2diebE1bRg9gvj3Qr+2RPh5vZpJ4/p9+NiX0abqMdXadHaeBiFKk+CnPgFupJaUzz5mHOfQfV4CyXOUBLC3K5jallcz1vPXxVOK1KQY2Ht2lgrbzZHpRvoyV4xgTi2ep8aXCZz4jyB7q1upOn6SklPhm4TZaOna9PF4O9E5UHFxfMd7ZUooysNwHDYE81BLQZIdR4L/iPB+5t6t4AlfbLpgGy16bwHolges9shumBG6R/Gpt82CoLYsZXa3LbJZ7WUywjPlElD7ttbelqYOA5s8+PZfRjHo9mFqyKV/mSr8VQVxC4zBBH3Cg6DzjYelNiEekUCN/6KbFKass4V8CDH4ubLGlEjjHKedfZ7MjwhhvyITdwY0rp2CAOCEJPujB2tT8BljY+hiNCFgPYFudGoWQOl9QkfZDrgWFqckBZbaUSxfS9TDSB80EMsPW49LokcmdkiBy0t0cPBAlAkKhoYYpcTnftxONeu2gf44yfcu09bdFKbZKY+5NzMbHGnZsss3Sx0AIQJ1uiUkd7g7soNhj62Omy8QXSDYTtfbZhpB6h+VU09GdMjYfCXMoH99ByD0Vk70hiMfN6IH/9MJT4IHsgPClqxN+9EnMsDC1U9Nd/PZWQ6b56vONBdBFlHcYkmr94BuY2ybo7xJQ5/XVWbkNRI0l6H9tryraXxE1zT3EHY5mmUY2jwMsebIJBm3Cit+Fn9BWwVz87pt6HmnEfGTBH/2w7yqjIPQUYIxPwmShlKmdsBDwaWNIhbxmaZXajAI+WT4KhR6f+ZueNfecgMXKi37gp/s1+HHyydLhjbvJlAjwm4mC4z5ZLk4k7XUaLSFKfFl2vlPiPAxsUxk4WQS27QruHUYjrRRansCR8L7
 OLjGnX1d
 WiAnIgwCGhVwd53lBpqW+w1KUTbfQRJU7CgPRHVvcIfPY9tUI6oIZAse9k54hvjYq5mJlnpk+/zvMw4ex8LQAWLQNf1B/ZPP5KVX6bMGFOHQscbwGfz+xJ7jiDYI2DXvr0ADBkIT4iatwR1H25gh7cd6bmFYBWuypvDDOkQiy55g8zZuZewCf3H8anHTPbZ05p0Ezj8lS71PKpIUHwK0lze8k3Yi9BpPUt5+HSS6BHs5deFHD7ULvv8OVrgPnVd2xoQ4yawDSMulTGNFSBhjXJSIB6B3vAC5/3S7560R/w+bh8PflUwRME0sccBdACWJPjA1w5Xzt9A1VXcJXocXk8TK3Ewl3MqOXpJAClwmdBapYXN44tE9yy8YUvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 08:21:59PM +0100, Miguel Ojeda wrote:
>   - Clang passes `-Werror=unused-command-line-argument`, which means
>     under arm (i.e. 32-bit) we get:
> 
>       clang: error: argument unused during compilation: '-U arm' [-Werror,-Wunused-command-line-argument]
> 
>     And under UML I see:
> 
>       clang: error: argument unused during compilation: '-I ./arch/um/include/shared' [-Werror,-Wunused-command-line-argument]
>       clang: error: argument unused during compilation: '-I ./arch/x86/um/shared' [-Werror,-Wunused-command-line-argument]
>       clang: error: argument unused during compilation: '-I ./arch/um/include/shared/skas' [-Werror,-Wunused-command-line-argument]
> 
>     So we would need e.g. `-Wno-unused-command-line-argument` there
>     close to the `-Wno-override-module` one, unless Kbuild or
>     ClangBuiltLinux thinks it is important to keep it for this case.

No, I don't think it is worth trying to make -Wunused-command-line-argument
work for this command. Just disable it. This mirrors what is being done
for cmd_cc_o_bc in the distributed ThinLTO:

  https://lore.kernel.org/20260316212930.120438-3-xur@google.com/

>     On the other hand, regardless of whether we fix this (and another
>     issue in a separate email found thanks to the UML build), we could
>     instead add `depends on` listing explicitly the architectures where
>     this is going to be actually tested. That way maintainers can decide
>     whether they want to support it when they are ready. Thoughts?
> 
>     Cc'ing Nathan, Nicolas, Nick, Bill, Justin, David, UML, ARM.

I do agree with some of the concerns that adding an architecure
dimension to this is a little complicated. I would rather try to flush
out those build problems with patches and keep it enabled for all
architectures. At the same time though, I understand that enabling it
for the "tier 1" architectures is a low barrier of entry for getting the
feature upstream, validated, and distributed to the majority of people
that would actually use and depend on it, so I ultimately leave that
call up to you.

>   - If we use the `.bc` extension, we need to add a `.gitignore` for
>     `.bc` files, and an exception for `kernel/time/timeconst.bc`.
> 
>     I guess we will not have too many `bc` scripts in the future for
>     that to be a problem. On the other hand, we have the chance to use
>     another extension (either for LLVM bitcode or for `bc` scripts).
> 
>     But please let me know on e.g. the Kbuild side if someone has
>     concerns...

No real concern on that front but .gitignore has a command to run when
modifying it, which will require a !timeconst.bc in a
kernel/time/.gitignore file.

Cheers,
Nathan

