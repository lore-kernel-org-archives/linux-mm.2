Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C3ACCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 06:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0496B0088; Wed,  3 Jun 2026 02:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 591C46B008A; Wed,  3 Jun 2026 02:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7176B008C; Wed,  3 Jun 2026 02:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 365096B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:45:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9A801C05DB
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:45:26 +0000 (UTC)
X-FDA: 84837665052.30.E0D1D2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 366CF100013
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:45:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QIkoHRVh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780469125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ObTrJ9GazdR2NdJ+eeFKlgqk42+5iCHPfrmuB4B+lo=;
	b=R8SCni8Xw49G3PAdDdz3qHYt0FqRJMKy8fib+bR5zb5Zpg1PDOvebnqfhHXdRFqOJ2t8u0
	vDdGpWUPifc3YhyvjiHRpKgOFAo1Kl4LJFy4DW2Tj7m4FzLOR8jFFdZQIUzh7ybryJ94Wc
	8TfkKQZz9IYI3jOIa+tX2XmuN3G5PeQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QIkoHRVh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780469125;
	b=ge/tsDEkYsPgCzw2NKf57gcCapmISPRT3vfwuiEzzY5WLeFjzqzzQYZkeDdsT9WFeDPBfN
	zjVKLWxKj7BnrHnsxwKsYss5/mZKl/+CoLvOhFKKgulgPxwdGjvJz8hxhg2NVMw93retBw
	+Kuep1wrI3zlarhjil9FCXEIbRyw3F4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98A0B60218;
	Wed,  3 Jun 2026 06:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6561F00893;
	Wed,  3 Jun 2026 06:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780469124;
	bh=7ObTrJ9GazdR2NdJ+eeFKlgqk42+5iCHPfrmuB4B+lo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QIkoHRVhXdigDLO3Ti27f6bvHuF4ODHiAa2mlkrpEM1nLC7f6datXVoGlV8VMvS1S
	 a/mrSKIIQyHnmLLbge3o/ckSjxEDCAHku3TeAOPTkSP2Wm8tFg1XNrlnJQOR5r7AoA
	 0qxJUH1Ds5R906ZYV1bqz/sdInIfpC71u5DlLK9vhTZvn8xVm+pt9vxjHdhsfcE2Qm
	 rMfUhj/V8wuFctgcxRA+YtchnLIrWE7kb4wfTR4PXwAeG3wQH7lmsv9/Zh/GDdipaj
	 AU8B0rLgs2KbbD5CMbC+YnHvqBoqCkajxZFGVq0AlS1m+28agSYJaNqAZ9BI6qQKi3
	 X9JAdqxUcHvQQ==
Date: Wed, 3 Jun 2026 08:45:18 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, 
	Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, david@kernel.org, 
	dhowells@redhat.com, hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	miklos@szeredi.hu, netdev@vger.kernel.org, patches@lists.linux.dev, 
	pfalcato@suse.de, viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260603-navigieren-pleite-stilvoll-60e6da66b1d4@brauner>
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com>
 <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: opgzestu6b5mkinwc5hted84yimjpdo3
X-Rspamd-Queue-Id: 366CF100013
X-HE-Tag: 1780469125-326531
X-HE-Meta: U2FsdGVkX18f/RotgmpmlDTP76lPSPmyMBfeLUMgcb5F/cjDlaw66Z4szDu7TtYlfx3j1RHtZFgBr6aRv40UqsVcRlszeetW4IU+6W+jDriGrAB0+UC9yw29OvdsulopSsQkQ6mlcAQHMhFnW8E4Mi0HLDglF+Al8mFSvoiZShaSNPsFFwqyyc0Fc58qGSKfK0/8Ek42VYWBCmPYrVir9n5n+P3UHpI9iZbMW9kMu0TNn84OLvsBGY2pnpbpVENkF7qmSSs9/l5Ex/jXEVvmFXd+mX8C87d7pD/5+jyZ62HEaoiJsZ9/nA1Qqos0qEiHt0EfeYjVhY96IBjtLPCSS6Ufy/qe5Kz9F13KG7R2NcsKsk3oRe6fPBW9/SkoA1DbW1aqFbgsQ1F4GHwR6CTlyy0taWjI3TiQm5d0vX25ArDyt0XujPjoXWC1X1ZhaYsxIGFZaaOYOfGnJDaLulo7WI3HRWocWKXMrfn3p4oWjrP9SVD8yHGMYS+zb4nsDA9PxO0IyFYq1+6jNcDzvnyHFhBcAaCCLx4tfBwORF9CV8F2o/ToIWrH97xn71H9J1j3hjPR5Sc9uHpiRrvFNPyxxcwpf6zz0pTwtgCg6JfApalnwyovCDBLSehvOJWi8onsANyw0snCCWyD82b8sHxHOKtfl0JJ0qPs+kWV4+EmLZyr9/Nt/d2yeEvEL1QnmxLIsHydIsO0Pe/PbKoJvl8ChcYQYwxqrjTKw4Jmn5g4mUMEBCXZ0dv9a0SCBTdlaA6wxKiyWseV8T6QSixwUBip+nuT7wTIcswhMqsDW26a0mywQMu+RkWi6hzwhOqaIADe0JRBnIJNXscoUQAN7grtULO9UajpvjviVkEEbACHV/l8MbLLROMADYGwoOmavkTSAFeAe/eUXU5qoyK+OhZAgzw4OcSMNiFL8OgNF97Pb7P2CxdxRHfPwi/SMnhep8rFABOBsuhIfH6TkUj5SdD
 reNjfWMp
 neAz2yT3MSRQrahMx+dJiPIHVQmbVbVyTIolA8NPKRC1R0AQ4uESWNBVvOt5puqTL69wrE7vf1JZ3AbUYjXcQTAyv1cXnkuKOuU7+Q9U2Sq/+RO+M8MRVkKWFyPl6xGVpuX5azfVQRh76/uaQSVV1PL7I6NhC8JqQYoAYnxWzbiotwYso1RObZj5QO7C4A9f5B9JnkYxNzuS6LTM+cXFrUgPBWEDZiLh81DerNuWqx63O97vYVR6UUwM44Bf87GeIFT8b5+/lCMG3o2gxgvGkHx5Rf45KKgUTscBuC2Mae+GESZ7b43+thzgoyS2LRVAZK6zgLIAAJyYsBRJT+8vIoy9ia3G985spH5VHnsaVR71UtV/KYX+34xEa5JTG1PgOHruo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 09:20:13PM -0700, Linus Torvalds wrote:
> On Tue, 2 Jun 2026 at 20:51, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > Am I understanding correctly that this will completely break zerocopy
> > sendfile?
> 
> Very much, yes.
> 
> And it's worth making it very very clear that ABSOLUTELY NONE of the
> recent big security bugs were in splice.
> 
> They were all in the networking and crypto code that just didn't deal
> with shared data correctly.
> 
> So in that sense, it's a bit sad to discuss castrating splice.

Well, we're completely ignoring the fact that splice()'s locking and
interactions with pipe_lock() are complete insanity. So unless someone
sits down and really thinks about how to rework the locking I think
degrading splice() is just fine.

> But it's probably still the right thing to at least try.

Yes.

> I just suspect we'll never get real answers without going the "let's
> just see what happens" route...

Yes.

