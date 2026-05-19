Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A8DCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 13:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B796B0005; Tue, 19 May 2026 09:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 802B06B0088; Tue, 19 May 2026 09:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719AB6B008C; Tue, 19 May 2026 09:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3166B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:29:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07B9D120294
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:29:01 +0000 (UTC)
X-FDA: 84784250082.12.9D9EAE0
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8CFD42000F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:28:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=hansenpartnership.com header.s=20151216 header.b=UWVNmJ2f;
	spf=pass (imf03.hostedemail.com: domain of James.Bottomley@HansenPartnership.com designates 198.37.111.173 as permitted sender) smtp.mailfrom=James.Bottomley@HansenPartnership.com;
	dmarc=pass (policy=quarantine) header.from=hansenpartnership.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779197339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wPPhv9rBL8FI+q6jxoQxQtVgR79fo8XoyfRl2VtW/BE=;
	b=QGEUNbU42+bqQcIpQ2H5W3MWLa6yn1pFRrbmkiz/pXxhP+WoqCG7NH7Bpi/2yjnElNt4+D
	NQrEZrTJR4WnzUlFDlWNZW9ZoWGYFx1Q3qJp62T43UGS6q/61z4rPL6DcttFttEj53DedO
	REyf9r2fCzYY9u8jD9G9lioJVdZykqw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779197339; a=rsa-sha256;
	cv=none;
	b=OnYpQ3iQHAYZbnnCSWZ2KD91BClZTNeKa9RwjtCC+4yOVycJr4+ffLqJCjEufs9GMTQgJA
	OdnPxU3uKhQEHlYSj8cOoSXOM+aqdo188uc3GF1l/7wpbjCfXDttLbljDiagBFlviUW5As
	jOqVd4oUmhKAwS51mvRTffs0SS9Fb1Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=hansenpartnership.com header.s=20151216 header.b=UWVNmJ2f;
	spf=pass (imf03.hostedemail.com: domain of James.Bottomley@HansenPartnership.com designates 198.37.111.173 as permitted sender) smtp.mailfrom=James.Bottomley@HansenPartnership.com;
	dmarc=pass (policy=quarantine) header.from=hansenpartnership.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1779197337;
	bh=ZDJmOhI1wYlm6YK7a83UmlKGrHKheOPreLwP8qNBwc8=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=UWVNmJ2fTf3rGljtv/AqYCRT05jrMsjgLg+ZYPdr5wnVHHzjlUa5B7VyJwMkUs+fa
	 K33rZn4F6PVZTEJfPqpTPuACJriDqJXqywXKNX5bmTTeDaFCnd0Y5d50AjZAUs62OH
	 KbY9A4FOJKLz8YEY9g9Vrm4JLmYbQ+OJNe4h6BoQ=
Received: from rainbow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d342:21e:67ff:feb4:e2e0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id BE1D21C0379;
	Tue, 19 May 2026 09:28:56 -0400 (EDT)
Message-ID: <27d39b4843077a7c8a9c4a3b2e14c480afbb573a.camel@HansenPartnership.com>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mateusz Guzik <mjguzik@gmail.com>, Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Jens
 Axboe	 <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan
 Kara	 <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	linux-mm@kvack.org,
 linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>
Date: Tue, 19 May 2026 09:28:48 -0400
In-Reply-To: <CAGudoHFtecdkcYpFrtM5RAAPSU11eL_ALPGp_jhtHW=WxyHE4Q@mail.gmail.com>
References: <20260516182126.530498-1-pfalcato@suse.de>
	 <20260518-starten-messdaten-3b8aa670ec85@brauner>
	 <CAG48ez0jbSUgT3ZxPKZP7Eu=K7ce2cX7k2NzHCHNMOxQjOGT9w@mail.gmail.com>
	 <177918418452.771415.4371785688744608623.b4-reply@b4>
	 <CAGudoHFtecdkcYpFrtM5RAAPSU11eL_ALPGp_jhtHW=WxyHE4Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-9 
MIME-Version: 1.0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8CFD42000F
X-Rspam-User: 
X-Stat-Signature: r3f4cetddyxz15suq9osb8tmykc5zcjz
X-HE-Tag: 1779197338-321025
X-HE-Meta: U2FsdGVkX1+LnU6NrhQYZHiFtwp+BsjgJ+dkULszzinxATsOfw/LrGPac5z5AlZHmlvD+dwv6ZZWkQHsKCIByjPHRTf0lnNfByx865Xsb59Mf22305cruK/u0NR94XCPsSHoou2MWw5V2pgMD6D9iQcF7WNaP845/bUi2CqwmIllyOxIOIVdvOU8RovyzDOut7SEqvruM0v6YuDpBqmc8QM8xdLDAehwhf6KRO7FAWLM5E8w9/VotLvX4LC7A3epvUctUi/pulCZkrzEsCusNOreGwB9XRj4YUVrsHiIhv+TPKGKOmsypiRzRoZFVtQc+3Lth1t0wCETGBTMSC2QBziR+1JsjZXwvRiLYyrlA//ev7tSteeWYKYzYxDZuiKdb0/F3b7y13za6FiEJTwtqBa7cdEetC8VFtwAq/SpXytHhebLIY5KROPOk3n+mHx3SnfJB2hKQ17Y6MNfrLVn4uLe/Dfkh50lC+GTvFjzQV3zRBPmoxcgxQ7oxi5fGp32bu0uXb1RUDD2L0cwnbXB/csnABBB3NfyKjjGx5jMTQGbqVn/dutZQZvSc1mxw7FknSI+Q/NmlH6IkFn92RTG0H6xAd8uaGnQmIkaEl50XRfLbGevQWteRHe8gYDRvEo6e+2b/y1FM3vNp8d08fE2ufpvgtxq8IPIhNOjZhnqs1/i4UzklmtDUugANPR0tN5Ugm8DkRCZBUa0l8NmBjKPGuEmPBScXBLHZxeLeY+GmNFeKlhNMsihfwAPI3YKhfQ2k3Bxrfor90rxU1WcneOEYz4n7DoDkkxcu4ZpQFjXxxC77Vvmgwzv9Tx8p/YxaKOLZBYv5uHOMFva1L45vv1+5GqN0XtlR7lh1bcZyEafzCzysKsYFv72UcVJGbYhlq9QxbgfYP8oWMxoy+LqaA8k9czQK8BC2giH+gj7/hkYBpqDTwEVnWsjGhc6dzWZdwv6gL8TmrYqZlqDkaiBbHX
 EMtTyZlh
 EX/G93rnmLDASZepK1LD0uythcv7jmcaW5CnJ3TxjhsyAt8Y+z2VruIRxBCIe6VH2Vs0kpkYDSLphngtlUeICPIu8GZwaaFY+V2H4+G/18Yjr/YKcbUQr6Q7RhnuNv0P4nRTyDXfxnJV+eUaH8lDHWlolP8vrGUmfq8acDo6fPwPeXAKyPgjCest6/GAYb4bi9DCRCcZalQzdM0ghgyIyC6kE0RS1zjojg/D637Ceewkm/wevK9FLFBCgM91qHrBf2Ycqj2xnF3zbKFgToK1BOB7kSRWQBx0XqshUuDK+TivAlTHa2tFB1rcUWzQ3N2WeJX+FoeOkUfkqJVLIogeBQX1UpqE/J/BjJdjoPvq19sJC31t/1QsmryVJuHXa9WlsdZxE2H2wKnbKy0RFUZn2ERUcvm7dyFN4hIxq1pAnBgpehiA8SZSRXzaRTaxtKUvKLTO1r2p7XIATkiV6H0CEcf0x5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-05-19 at 12:51 +0200, Mateusz Guzik wrote:
[...]
> I can't stress enough that mucking around splice (even if worthwhile)
> is merely addressing the currently popular attack vector and not the
> general problem.
>=20
> The general problem is that the kernel is expected to be able to run
> with untrusted unprivileged users, while it avoidably exposes a huge
> attack surface. Of course there is no way around providing a bunch of
> syscalls to users, so *some* danger will always be there and one has
> to expect that even core code has bugs which will be discovered by
> LLMs in the coming months. Even then, there is tons of code which is
> currently being audited by third parties and which has no use in most
> setups. Instead it gets autoloaded in response to an exploit wishing
> to take advantage of its bugs.
>=20
> The huge attack surface was always a problematic position to be in,
> but with the advent lf LLMs any unskilled person can drop a 0day and
> the position is straight up untenable. In the long run there is no
> way around blocking access to code by default, way beyond the current
> splice proposal.

Attack surface is a great measure for making lower bound security
assertions and proofs.  I mean I've used it myself to build a container
that was provably more secure than a VM:

https://blog.hansenpartnership.com/measuring-the-horizontal-attack-profile-=
of-nabla-containers/

But the point is it is a lower bound: security is always better than
the attack surface measure says.  The problem with the measure for
something like a kernel is that the kernel's job is to provide services
to untrusted users, so amazingly enough a plurality of its code goes to
this function making, as you say, the attack surface huge.  I'm sure
there are low hanging little used interfaces we could remove to lower
the attack surface, and perhaps we could voluntarily wall off large
areas for "secure" users.  However, security has always been a tradeoff
for usability (the most secure PC is one that's powered off) so the
more you wall off the smaller the pool of actual users becomes.

I think we should be spending our time on better interface design.  As
Kees' security project proves: classes of bug can be eliminated via
various techniques (effectively rendering extant defects unexploitable)
and we can certainly do a better job of error legs, which seems to be
where AI is turning up the majority of the issues.

The problem with the above is that while it's easy to measure bug
density and correlate it directly to attack surface as lower bound
mathematics, it's really hard to measure the reductions in
exploitability potential that better API, coding and other security
techniques give us.

I really believe we've done significant improvements to reduce our
exploitability, but I can't (yet) measure it.  That makes it easy to
claim the sky is falling due to the size of our attack surface, but
doing so effectively ignores every exploitability improvement we've
made over the years (and thus ignores the hard work and dedication of a
large group of individuals).

Regards,

James

