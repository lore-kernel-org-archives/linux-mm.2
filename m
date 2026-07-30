Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C483C55167
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 22:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265106B008C; Thu, 30 Jul 2026 18:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215156B0092; Thu, 30 Jul 2026 18:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106546B0093; Thu, 30 Jul 2026 18:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDB176B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:49:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DC25402C7
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:49:16 +0000 (UTC)
X-FDA: 85046935512.30.0BD87EE
Received: from rev.ng (rev.ng [94.130.142.21])
	by imf15.hostedemail.com (Postfix) with ESMTP id 785FBA000A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 22:49:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=rev.ng header.s=dkim header.b=W59GTqzz;
	spf=pass (imf15.hostedemail.com: domain of ale@rev.ng designates 94.130.142.21 as permitted sender) smtp.mailfrom=ale@rev.ng;
	dmarc=pass (policy=reject) header.from=rev.ng
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785451754;
	b=yBouZ6iz5mOXQQM0hlsNVnmYv1GhIlBFGSrLD40T0PHTilMqMR2j+PvJc5WnhxC/8jwN2o
	q0litPp9J6/JJ5fkc4VB4ub2eoAMYlyMsBH7e3wM+59jSYkBlcBFWalwhVTcxnvePr5OpQ
	0+Pgik6rA2E6Hs29OvtVwInQt7jWL6M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=rev.ng header.s=dkim header.b=W59GTqzz;
	spf=pass (imf15.hostedemail.com: domain of ale@rev.ng designates 94.130.142.21 as permitted sender) smtp.mailfrom=ale@rev.ng;
	dmarc=pass (policy=reject) header.from=rev.ng
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785451754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L54GOWdjqRndf1N0Bl3JKPypFdhuh4dOD9kZrETKjt0=;
	b=e1KyHSwtQBd6Niroua46CzGGOG8E4flqqW6AFd43C6CEQwA2zylbuIXjcXmOeeI4G4nkg6
	DBzDlL0vFk2A72iKEgIkHrHzl15SZXjg0q8BzW008TP+rLXR1DfAcYvb4OPFecF6fl6qwH
	0OXL4ViOP1SekJ++Wd6v8fRvY1unmnc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rev.ng;
	s=dkim; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive:List-Unsubscribe:List-Unsubscribe-Post:
	List-Help; bh=L54GOWdjqRndf1N0Bl3JKPypFdhuh4dOD9kZrETKjt0=; b=W59GTqzz28XGIfy
	MgWx2m5J08iQh2gCyOqieNW/0EwHDytQKkSAAl/wKbD1Y3PD8KMO8aVJd04cLL531CRhIouIUz2cQ
	vf3sQspzC7+QNsYSFQ9VPoZVxfFd4tf4ltvruZ0zH8MQTZC/pMjcfRSvwLDW7ZrWkQHJnUhMeaDo0
	ks=;
Date: Fri, 31 Jul 2026 00:46:04 +0200
From: Alessandro Di Federico <ale@rev.ng>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, david.laight.linux@gmail.com,
 jack@suse.cz, jannh@google.com, kees@kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mail@johnericson.me,
 shuah@kernel.org, viro@zeniv.linux.org.uk, Gemini <assistant@google.com>
Subject: Re: [RFC PATCH] fs: binfmt_misc: introduce eBPF-based matching and
 interpreter selection
Message-ID: <20260731004604.53c66732@spawn>
In-Reply-To: <20260722-raser-leselust-konsolidieren-05f8e36a0782@brauner>
References: <20260704-kochkunst-hauswand-blass-7226e9443a9f@brauner>
 <20260704211409.1978485-1-farid.m.zakaria@gmail.com>
 <20260706-uhren-raubbau-sinnkrise-e40a8337414b@brauner>
 <CACCo2jm5=xrQNfak=TdO=2oh0DC5pe+atj=UfuTa8Y9s8GVkqg@mail.gmail.com>
 <20260707-campieren-fingen-himbeeren-e4b682bd8e63@brauner>
 <20260722011217.45e79a08@spawn>
 <20260722-raser-leselust-konsolidieren-05f8e36a0782@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y5ghxtrrfzrzzwgaqs9ksg4oe1qfuixz
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 785FBA000A
X-Rspam-User: 
X-HE-Tag: 1785451754-949903
X-HE-Meta: U2FsdGVkX1/m/x/Ps7U7wAskXeNwhjVm0y9d5ljKnOMWQ3Tm8NaM2ybUlNFyJwS+A+OMrcqIm4X7iU/n2rFcrA6JuWXvNy5vH+9p+bIc6AZjYNCZYcNgghsilB4Sb03i92rzno6NnG+DIN1e6V+oIA0ACxIneBqdkJUjVWnpe2gt9QFx1ySZ6QJYa6miWrhSXaN+eoartiaO5ThyaoaQIy8VioU8Z5hFIPabkNqEuVavLY9KU5c8N5zjPyiA+WYWFwwN0ocg3F53cKW9lEMLm1Bh+DQEQThPWXhKZUSN0jmv6OI/1t5QNr1by8QjP0tEPqt8dXV8iLyYKyHE6bOQ1YS/u57lrAX1VdaHSk9UD6wNBcH2ocrBawBnzqJxpMJk07xEqeTmd2rneQjBQXcsmB43Uia69Gza9HPHB2cUY1f6+Jpou78na8rLy0ZgdDN5CuRlN17FVST7dD+FSXOJSJxISVG1VedL0PWWs86iChRuJkAnF3vwbRhsIH2hS0WPAw64KVnysau4ZVRA9haZQEG6Cy5/no+Is37w9wn9kHy2f3aPDLX1KL0DWkV4LDW5jU/qlYtSL0pfIzozEwseRQsSngi5XyIJeE4Al7AjXAPr1uZ9R40DR+iQEMDlPklhSlZwxtZ6zeAW51ro8Ck7EZ56g2i7QPf5tIObFDKgALNL7XpLQwpshF9fRccCWvprrkOa5g6J1S+MkUXhWZJd+VENRzXj5tdIH3XjlCVedS1yUo4vPCJQNNOLYovLXkOUEqC5mYK0zLcqn2rOkfC6LUlwGpmkVmuk9rk1vZJobKHQBaEJ/MYrpjz3ZbrrVrgtdbdHUw6g/w8yODMzb/Vwxe3vE+THLgxGv8mM+6rbahstvoW+eXT2rjGypPr9TXwxB3pOEvrYlunU+v8RGVcdJ/g3U5NeLgVWOvIVnUMj4B1NsZi0cLr2ll8R0meEhUkUbVzr2gdh4YxA5ToGK17
 2B58+Rh9
 AyPMAHxtONr11Cu1VwrAoliR+8dk8cJyckV+OqV4+Cg58Wruc+eEmVXNk9FU85kmDURO2aDraun65w4e82pJ51hby3WKQo/dvtYCakZk1qes+KiCmAnGDR110Hnv5hFlLzIMu1Tq9AWHdllDogo+YYm8qBoMQhLwquC56xErTaQYIfIn98pOQB3rEQYNdCZsTBwrvtWq8KkyyasYHHa3N1Jvmby54owSMOSfkI5RGL+soXa2sKTkCF7rzeAysqCi3vEXZ03SFstPz+xONp10ruHhfQLCGtwcb6IViQR3cpTSAHnz8qKi3sURCdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 15:33:40 +0200
Christian Brauner <brauner@kernel.org> wrote:

> I think this could even just be part of systemd. You ship the distro
> with a file for that in /etc/binfmt.d/ and systemd loads that bpf
> program for PT_INTERP_WITH_ORIGIN.

One could delegate the feature to user space, but that makes it much
harder to get adopted in a uniform way.

Will systemd, Android [1] and OpenWrt implement this? In the same way?
If so, at that point it could have just been a feature of the Linux ELF
extension. 

Of course the Android people could disable the feature even if it's
in the kernel, but if the convention is established by the kernel,
there's really no reason to deviate from it in the way it's implemented.

The whole point of the portability thing is to reduce the assumptions
you make about the target system. Ideally, you just want to use
features widely available in kernels in the wild.

But from what I understand from another thread, your intention is to
use userspace as testbench, correct?

> This is policy that the admin should decide

Agreed, but the admin is probably satisfied with enabling/disabling,
not deciding whether the program header type is `PT_INTERP_WITH_ORIGIN`
or `PT_ORIGIN_ENABLED_INTERP`. Same for the distro maintainers.

> not an arbitrary extension into elf core.

I think that, in order for this to be useful, it needs to be a ELF
feature, not something the admin/distro maintainer puts together in
eBPF.

Then, from a security perspective, AFAIU, implementing this in
eBPF does not solve the problems that have been discussed.

For instance, `selftests/exec: add binfmt_misc bpf-backed handler test`
does string manipulation (no `openat`).

I understand that's just an example and it's not the same as committing
to a new ABI feature, but still.

Overall, I feel like the current proposal pushes back on having a new
ELF feature for security reasons, but then delegates to distro
maintainers who want to use the feature to take those risks. But also,
distro maintainers don't really need this feature because they can just
write /nix.

I love binfmt_misc enabling you to do ./foreign-architecture-binary or
./notepad.exe and spawn qemu/wine (usually with your friendly sysadmin
approval) and extra flexibility in that area with eBPF is super cool.
However if we are thinking about portability, this make sense only if
it's a default-enabled ELF feature (implemented in eBPF or not).

I'd be happy to try to work on the example eBPF program using openat,
address the various security concerns that have been mentioned until it
looks right and then it could be loaded by default, but with an option
to disable it. But I'm not sure whether there's such a thing as "default
loaded eBPF program".

Alternatively, I could extend the ELF core as a parallel feature of
the eBPF-based mechanism, reviving some patches from previous
iterations.

What do you think?

-- 
Alessandro Di Federico
rev.ng Labs

[1] There's a flavor of nix for Android (using proot) which would
benefit from this:

    https://github.com/nix-community/nix-on-droid-app

