Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73EFCCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 10:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B006B0005; Tue, 19 May 2026 06:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BBF06B0088; Tue, 19 May 2026 06:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1926B008C; Tue, 19 May 2026 06:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9096B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:59:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D994120290
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:59:39 +0000 (UTC)
X-FDA: 84783873678.18.5232998
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6C2A1C0003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:59:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aG5qVDw4;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779188377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Ufx95wBhoNcawt+JgquCcF6AitMkxA/CpStCPdSgmw=;
	b=rmFlzmOwpDJZX/MO9xx/YH9CpNcpX7Ty0woRUIo41rjrcqzrv3tM9i6+hPGfUgpTooRXfY
	IkYNyZg9EdBNYEcqxh3PvVEVd8dUPnMj1nAMuugh9f6un//S1RKXO3zVb77CG3uNeNaqJA
	Pxt91CDkd+sVAjBU30zjWbA3w4I94HE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aG5qVDw4;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779188377; a=rsa-sha256;
	cv=none;
	b=vVb4rMQW1zQsNjNgYQFgz53RIBEOgsDnvZL1lCdgyZnYykE4zYCLPEZB0e5Dct8xEtLQ8S
	M4asXqRWsa1jpG5AON2jGE7R7XHM+samem92R6db0SJCJyiqTzh0Tro5O38gN5eJX+8pqy
	Td9v0Dj35GP6w8RksGpI9ZF/iAA25go=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA94B60129;
	Tue, 19 May 2026 10:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B010DC2BCB3;
	Tue, 19 May 2026 10:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779188376;
	bh=A/sK4uYKDHlfqofPeTZV72AW44cUa0BDZi7ueukxUkw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date:From;
	b=aG5qVDw49j2L2f66I6reDbbTDvfsExNp2ERHe47cjeXBviNqvvDR8z1frpZlrBkse
	 tIlzlu2hXDy8PjKpn0j/EAltvgWotNHLkJ4ekyCZemhrcPrT/gByURBUTWQa1K2wlX
	 4qz2Dz96oe1ggLnbsHF2LqOPMY4LhwRWzQMZyewA5986IhP7HBSKoO6FWnrcNsOHty
	 ZX6EYI1V6k+mJONl0TkLkWHyUMV7XvNjaDR5EIUpfaaiptF2RAeWVNHTDRy7H/po3/
	 QiU1dYvQR4i5schE8YVonPenLPwyprZcoJJ+REeEaNGiNHpKm8MEHPz194awVo6y96
	 0aIN+NccsREnw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
From: Christian Brauner <brauner@kernel.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Jens Axboe <axboe@kernel.dk>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
 Kees Cook <kees@kernel.org>
In-Reply-To: <CAGudoHFtecdkcYpFrtM5RAAPSU11eL_ALPGp_jhtHW=WxyHE4Q@mail.gmail.com>
References: <20260516182126.530498-1-pfalcato@suse.de>
 <20260518-starten-messdaten-3b8aa670ec85@brauner>
 <CAG48ez0jbSUgT3ZxPKZP7Eu=K7ce2cX7k2NzHCHNMOxQjOGT9w@mail.gmail.com>
 <177918418452.771415.4371785688744608623.b4-reply@b4>
 <CAGudoHFtecdkcYpFrtM5RAAPSU11eL_ALPGp_jhtHW=WxyHE4Q@mail.gmail.com>
Date: Tue, 19 May 2026 12:59:31 +0200
Message-Id: <177918837114.804096.3977912252785122973.b4-reply@b4>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=3427; i=brauner@kernel.org;
 h=from:subject:message-id; bh=A/sK4uYKDHlfqofPeTZV72AW44cUa0BDZi7ueukxUkw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTxOE0tNgvv0N2gc3XLoTeeh03teF81p9f8dZ3ub7eBf
 eNjKSOJjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIncj2ZkmHauY9nrwpt7P1y8
 8+CtbdTPmQee6blN3WazXbCr/MbUDi+G/44M8ww4N7uWHvvyRTt83TcF5kufzkUfO/KL95jUocz
 NwnwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6C2A1C0003
X-Rspam-User: 
X-Stat-Signature: bnmay8bjaxwhpi1s1icwgyqxk8oo4cg9
X-HE-Tag: 1779188377-454679
X-HE-Meta: U2FsdGVkX1+fZTDRUVJKENTURE11EhvpaG3FANuC2SQtItiz8xGFABP5Z/ZNsFCqidF578T7llbT508M4Gvr2kLI2ocOAdf7BytvCPX/dGdCkLzjc1QvXPPvHEEDnMNi6jPSnJouR2vM2m2d4vFq2lZBtPuZVpRcs/uA2cFH/S5gAl3gWm/l6aBcY36WN1TLBwpCdpYWjKiJoqtWI1EVBsj1nF0mXkINpGRQo2Dow37YwteD39OF/v8Fs5pL8H6lwZkSXCgrQBWzhv2GCRjlrLxNUjHrqvOg9uiVi1FzKpCw5tphbhDlirjLCE/wZ4hGfEtNO6lfKhvi/Dl9q36UzvmZxsc3Ojocm7KAa0/JjUXXU7k1WuJ1F5tFC5x6Vg28CCmIitNy+Iaw1qNrhCPdpxhOyrNHJHyofc6qHGAVGp/XAsGVVbo9UtafuQbuTUBDHdqKOc/CR0mVr3h1TN5C8Ixk9awTi4QtyNh4nFfy3sTu0VrV717cUxABiMwTa4+W2U3nst+HyP5cDQ9np2X/RMOLuf6fpM+47IgEKgdCB63MGFYsko6qWZbuGL3ZRsrP+hPBHjdmPE9NRTTWGCdDjiER3NO1j7nsVJlJr8cTyIa/XWT1dwiyEiaE3RUjes7MiBRqnS2z/c/sIH4g2/IRPahihx+GYT37H93kcTrekttwURLlFC2uTHpPNDO/OG/ixFHHr5yVDnbhbk9FV+oC0/AwIfaikj5Fx40QRwZ2goDRnqIayZPFWx1wn6VjxBH7bAlX33CK0ecsB+3GWC8YzXCLDbf4ynMd3VZT11htB1DAeYum2P4/ecisIRvLMg7tT7ji0WxsdqgI0o2z+Rv0xndNpYex0GeVJJiyrhqCbhwo8PZKzlP5SLqco1JDCIr2Mse6/AF6fUZw1ZsUxhXa5+bzPFwMS7e3yEmhQ+jWppYbHPUnJUn+RRbNDzoGPkkuoEN/PMaPBwSTCbZdDvo
 lKNPj+lq
 NbCjovJFJcl5nxIH1s2di5O902Kn9baG4Qodw7aXOKu9wt/Gq2Ub3Tj0D8cfv+GiyYoAM1/6qJM9viCalI1eBqFOyvgePualWVLXAiOB/5xpvZZkmeoV4O8iExOhzCRuWcebv+mfgooS+zj8yjeyRkCg5RvWp2jBTLynf8deLNQxCHNWxItIhy2aSie1qALaXtbolX2kE3tDNRbjcb6pD0H8QEYvZJvuqHQzI7S64JYW8C67VaxU3wXQBFeZE7oLezrwyNt0w0SMFDaUFMvb1AfuMxHKOnZhO7iMA64CFJmpDXMU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-19 12:51 +0200, Mateusz Guzik wrote:
> On Tue, May 19, 2026 at 11:49 AM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On 2026-05-18 20:59 +0200, Jann Horn wrote:
> > > I feel like a sysctl for "disable all the splice-like interfaces and
> > > zerocopy TX" would be reasonable to have? Either by blocking such
> > > operations, or better, silently downgrading all such operations to
> > > normal copies.
> >
> [..]
> > I think blocking isn't going to be useful as it will make it harder for
> > distros to turn this on. So we should degrade.
> >
> [..]
> > Let's discuss the other aggressive alternative: Can we try and
> > unconditionally degrade to copy. This would affect sendfile(), splice(),
> > and vmsplice(). Worst-case we would have to introduce the sysctl
> > retroactively.
> >
> 
> I know at least nginx uses sendfile, but I never benchmarked how much it buys.
> 
> The original patch as proposed filters by rw perms on the file, which
> I expect to exclude nginx.
> 
> While kernel-internal copy is still going to beat a userspace-based
> read/write loop, this is still going to be a hit and I expect people
> are going to complain. Afterwards you may end up with tutorials how to
> re-enable pre-patch behavior, partially defeating the point.
> 
> How about denial of splice usage or degradation to copy are still on
> the table, but based on a different criterion: whether code involved
> is "known good" for lack of a better description. iow the kernel would
> maintain a whitelist of "safe" cases. Random-ass AF_NOBODYEVERHEARDOF
> does not make the cut.

I had thought about that to but I felt a bit iffy about it. You could
envision an FOP_* flag for this:

  /* Module may use splice-like apis */
  #define FOP_MAY_SPLICE          ((__force fop_flags_t)(1 << 8))

But that doesn't address how fundamentally broken vmsplice() for example
really is and that probably no one should get to use it in its current
form.

> Common-case usage would have to be audited of course, but this sounds
> rather actionable and would provide hardening without much friction.

And that's the usual problem where rando module will just raise the
flag. Maybe that's fine and we will keep up.

> I can't stress enough that mucking around splice (even if worthwhile)
> is merely addressing the currently popular attack vector and not the
> general problem.
> 
> The general problem is that the kernel is expected to be able to run
> with untrusted unprivileged users, while it avoidably exposes a huge
> attack surface. Of course there is no way around providing a bunch of
> syscalls to users, so *some* danger will always be there and one has
> to expect that even core code has bugs which will be discovered by
> LLMs in the coming months. Even then, there is tons of code which is
> currently being audited by third parties and which has no use in most
> setups. Instead it gets autoloaded in response to an exploit wishing
> to take advantage of its bugs.
> 
> The huge attack surface was always a problematic position to be in,
> but with the advent lf LLMs any unskilled person can drop a 0day and
> the position is straight up untenable. In the long run there is no way
> around blocking access to code by default, way beyond the current
> splice proposal.

I see this is the "let's become goat-farmers" portion of the message.


