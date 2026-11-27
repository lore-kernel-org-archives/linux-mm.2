Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7426D606A332
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 23:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EcQaKITO
Received: by kanga.kvack.org (Postfix)
	id 565566B05C2; Fri, 27 Nov 2026 18:15:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C826B05C4; Fri, 27 Nov 2026 18:15:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479936B05C5; Fri, 27 Nov 2026 18:15:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21A9F6B05C2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:15:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73410A0575
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:15:08 +0000 (UTC)
X-FDA: 85482456696.03.0A69182
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A3D6CA0010
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 23:15:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EcQaKITO;
	spf=pass (imf25.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795821306;
	b=GJ8jXia4bTZ2j/cGAeNdkowt/wy5KY+zjjCI2rqY35AsKbTIariOt0nc4jyBq+Tb3AO5fP
	3gUQwvqckilbTY9xFVkYRp0Fd4gQaet0wzL6zk3yAWtIMW0+CeQtlYUZcWKZx5bCPIdtU8
	1rc9YHdg8pcegO/imsfCTDV2P7B9Kq0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795821306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrDS4A11tKAewGc5ik+OaYkecvMF57R7fCAe0JmkaBc=;
	b=l7A7KS5Z7mimmx+pNjx8DjkSETNCgIKOgg0d4wh8fSt4nVOSAPYJhWkRfdXTp6DWGDYrtu
	2es00L/Ev/OHb/zDR0H2JgaCkfX0S0l+Y+FsELqJyi5BYd5gqvwRgMdeNw38ivosmGLEoN
	N0Qqo2TzKTMwBpP0rAxsvyiuV3gk9lE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EcQaKITO;
	spf=pass (imf25.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 0AE106124F;
	Fri, 27 Nov 2026 23:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0FA1D1F000C1;
	Fri, 27 Nov 2026 23:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795821305;
	bh=IrDS4A11tKAewGc5ik+OaYkecvMF57R7fCAe0JmkaBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EcQaKITOrl9V263dyfVjJdRqu7KemR4FxN4hFjrTHw+2KzO3Qa+MByOpOjIhMqFmV
	 qCT+jPAFEuySBDSXaWluhEjpN3uxqXzgWRq0njWLczKgZ8oCZVwpsLnlBs2YpNlzDT
	 6JqU5uXjurbdb7FHb3cEAd69Aq8R00ULrBKfvdxNHM8SdS8qBiOd5QCdI9SSVvtDVh
	 gOTGLLnz2XfqY6CjGmNkP/lR9OOP1eTnCzUL7dudMCQbsYed+ylVDuFvMN49yFUckG
	 puAtcdZCbt343YroteKV5W4L6rq6JNEyg4255jegM4RiST3htoJ/dwCChVDytRVczg
	 YZ+0shkfiEW4w==
Date: Sat, 28 Nov 2026 01:15:01 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: aleksa@amutable.com, alex@amutable.com, alexei.starovoitov@gmail.com,
	arnd@arndb.de, bpf@vger.kernel.org, brauner@kernel.org,
	containers@lists.linux.dev, corbet@lwn.net, dhowells@redhat.com,
	ebiggers@kernel.org, giuseppe@scrivano.org, hughd@google.com,
	jack@suse.cz, jlayton@kernel.org, josef@toxicpanda.com,
	kees@kernel.org, kpsingh@kernel.org, lennart@poettering.net,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awoO9R7YF_5_6dHA@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org>
 <awn_Y7oI4ckfsjSv@kernel.org>
 <awoHex4LVst2JwkO@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awoHex4LVst2JwkO@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A3D6CA0010
X-Rspam-User:
X-Stat-Signature: rw7qpwu69mqk914g33qixzcyyo8ficzb
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795821306-109920
X-HE-Meta: U2FsdGVkX18Oh18oE3bns4tlFg+y8TEDU6V3ypSfoWaP4z8N1OiNUVE6hwIBCiAO9yLON7zkb1db66l1U5ehtRR8arGNwwx2eMsVd6IU8V1HM1bZ6u0Lty/AbcCjMVbJHCLYY77iq5DBiCYD30xr1ny5ptlndeQfdPdBcryTqhAubeos1WiK/WuBQ4MVyB/dHlrBDmLOU416KXTJyq+2ubOSZakmwj/DMJTrweiB2xvg3QEhShHmU0rTdwjvR8fVmX5yjNLw6J9781StUbyCUaeff/zvmkRqTcsHm3ZoQ8xQaiUpRdZSM3Qr2ZXCxazzNVeEkbhaO51SOfO3T0Wg93bqh4gL07m9fPnUr3wKTDXp+bxVCpYIAYG9KIX24YINz4gG3tw0Hi+yoEA2zBE2sg874X9Wf0v2MqKoI/NA0TKM+is8fJ/WTHkn7ql8DwLOOOENqnlRRtwioV9NwX3ayDRRJyPctQz/RgDAKSawI2lpTv2KXuBT36xL+2SmgJRKHpMHtzRQ387NBv/hJHVTtb8ngj6nGSawPzoJyeB5X6ZvwolZgjG0LwqpUa2jhvpXsiEJADcMPZxKdYbBY6clMcA4x7aXAwHiRAeUZ1PvKbL9t+kGcc1PGRDzvkvW/JCDVKqnndHOZ1moCwn1FSOAX/5O4ea9UakiZYG8mETJ31Q+lV9OFMoeVJVhgKESaCEmd5tukH+aXNmFvM5Jhrd5YMqDSqkkrRggghQnH7zf1FImaiYMG3AFQesKHAJALodV7aipX4okl/VNAasNn5tfMAzfB4DD+WQEcBBMzrXRpvBSGFWJ6Ryse18NKLeW17IxBv1Yc1raLsZCBlGlRyMCNTp5lMPqtwsv7Zh+RM2pgUahpP9OmDiFAD/E+NtxHBSDGAXObsj688vmnNH/xElK7VMm+ztmX14sam2Rk8Cqb+9koh5kVM/lhlbqwrPNCI505J+ixsGMZDz22JlD4Nz
 iMo+kYAg
 +X0uVB/InS1+/ykMUOGQTwktkR33K/970aylOVOdywdrxFDjBJSp7yhoLrqRT/7I75aTsDII1J9cEHjLOBIXE2hznLS5sURhskyO/IA7Z1r87HtUq3t0vn6mh3JM9LS5SuA9eEFCTAACDiIwm9NJey7Iwcde4ZnuHoJsEtX6r55lG7ztrYKdglbrtT/Y788twgrX2yhHG9OWi6M9buxsitRxbfhI64lSpIf1a+9Ye1Aki7vNnvlJqCwc0o2OPLhpqYaHcB2DuX/H3n/b3Bp1n7MB+VqnK5ZLTmoe/6MUPGmjmAurXN49PK1dAhStBOVQ1LXdThbWro3yugdxgdkAVZllxQYJ/VgrePC1DQRGF/5mmglDYRsVdLOkOoIRnqHKcFkfncZNan0rRhVr8q9+uGFBgnVx+h6mi9AVZtMI7Eah1kVJh4jpMFU4fVcpRhEeU+dhmm25i6KyCfeFW9rZvpPjZNlS5vyIJCl8Cc+NF8exVVpAymcLIdPDlcnwTz7qx7Q4RbgnAWwkjYgELnNBy9+t/iW4Xvyf6pTb1daAnHc/sEsMzogWcEtDMDkk+l4iC0r1t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 28, 2026 at 12:43:12AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 28, 2026 at 12:08:38AM +0200, Jarkko Sakkinen wrote:
> > On Sat, Nov 28, 2026 at 12:05:03AM +0200, Jarkko Sakkinen wrote:
> > > On Sat, Nov 28, 2026 at 12:41:03AM +0300, Askar Safin wrote:
> > > > Jarkko Sakkinen <jarkko@kernel.org>:
> > > > > I personally think that "getting in" should not be a goal in the first
> > > > > place. I care more about that whaever gets in has a high bar of
> > > > > quality enough. It can be something different than this but
> > > > > when I read the LWN article about Cells I was alarmed enough
> > > > > so that I had to do this and prove my point.
> > > > 
> > > > I think that Bacik's patchset has better chances than yours.
> > > > I think so, because (as Bacik said) it was tested in Anthropic, and also
> > > > because Brauner reacted positively:
> > > > https://lore.kernel.org/all/20261021-zeitig-niemals-clubmitglieder-b3973fcebd38@brauner/ .
> > > > 
> > > > So I suggest reading Bacik's patchset and say what you don't like about it.
> > > > You will have chance to influence Bacik's proposal before it will be merged.
> > > 
> > > I've read it through and the way I'm seeing it is that it is overdoing,
> > > and has somewhat complicated life-cycle model tbh. I don't like it.
> > > 
> > > This could be of course wrong way to see things and I did this just
> > > to demonstrate that similar goals can be achieved with a relatively
> > > lightweight core. And this is also demonstrated with a Python daemon
> > > emulating Cells style containers (and alos relatively trivial SystemD
> > > wiring).
> > > 
> > > There's no reason to continue this for the time being as it
> > > demonstrates already how I see the world i.e., "I showed the
> > > code". It's up to whoever decides these what they do.
> > 
> > And even if Cells is the ultimate solution since I had thought about the
> > whole problem 1.5 years (mainly for my own entertainment but still) this
> > was the best way to unpurge all of that. Regardless, world became a
> > better place... New information arrived.
> 
> When it comes to containers and namespaces I even don't want to have
> any opinions tbh, because it is so opionated area to begin with. Thus,
> I pushed back sending anything using this approach for a year.
> 
> Despite the patch set tsunami (sorry about that, shit started to 
> unpurge as I went on), I was not too hesitate to send this in the
> first place, or have no motivation to compete with any solution.
> 
> I did all this really for the sake of rightful concerns about the
> complexity of the mainstream approach; and in that sense I'm happy about
> myself.

When I was thinking about the whole problem (for mostly fun) I was
thinking more sequencing than data structures. I.e. I have a game where
I need to end up to process creation without embryonic state, and add
just enough weight to kernel to support that outcome, and that leads
to ~2K'ish LOC of extra kernel complexity.

The type of staging that SGX driver uses seems to work really well here,
and allows to create the container state easily in non-running 
state.

Br, Jarkko

