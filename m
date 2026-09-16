Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC531C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716686B0088; Wed, 16 Sep 2026 05:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF206B008C; Wed, 16 Sep 2026 05:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DD5C6B0092; Wed, 16 Sep 2026 05:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 396F56B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:02:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAD061406A0
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:02:01 +0000 (UTC)
X-FDA: 85219033242.09.56E5BAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 35BCDC000A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:02:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wu0pWfdD;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789549320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztMMMMv7bxzK6KlzZ8FgpSfa4Wm0mxmludXZFP2zroQ=;
	b=XRpQgWTFX3NKYlr6/u35G/B6eDp8P44KyMwVhlmYB7owPK++Xs+5JN2pVY2ViZUufPYR3Q
	kM9/ugSQ1PT0JpAOJNdEt6qzVflMEY8qbUFnYL4M5IDUm+UzlLW9uHuEC8u8Td4ogAIzFC
	Nd7xSEtraOg0+x7RzDViJNRlBTWJxCw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wu0pWfdD;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789549320;
	b=npwqD/+Huz/yM1m+Xvsy87H3RA60Li48B0d4pAd7rLsCVwBtdtDhh1a2/WL3U7ZdIlWx3q
	FRCwYD3pZFUI7Zh29O6TKByar89GHf4qcr6H7KbDznXln1WddUoNpnTt/zQn6qNFYPbTBa
	yyKTl7Wp3FH4FU//jUxbbSYoj2ayO/s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E6613602D0;
	Wed, 16 Sep 2026 09:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DE81F000FF;
	Wed, 16 Sep 2026 09:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789549318;
	bh=ztMMMMv7bxzK6KlzZ8FgpSfa4Wm0mxmludXZFP2zroQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wu0pWfdD20WkmcJlHU0fRgfxFv5iUvN0ccfoP7F0VMVMYwoHsEoDYfn+nZMvEzV1m
	 KgsAJCb4zn+2o0fvKGnbBgVbre5Es7my0jYMg1cdlyvgH0yxuNUuZnAuZrzuEwSaZF
	 1yXsXOcY+4mY1yMSu//HjBM/KuFq2cuIsI8Ci83ETN+356JpDar6y/fUY4GlCRgC0N
	 +o1s2o/YNhIVKXnP5KjUeBL1NTnQNOaFH1DEQN2ZwHIrNc+TnmM6Ln6fgymfBBoCWZ
	 IGr8qm2BKp7AH7SO5nZrhRqHVCpNWTmOdiwF6Ins4wLxpoEYYHgWxPfMkHNfAg+wWW
	 nENUQt62KGCVA==
Date: Wed, 16 Sep 2026 11:01:51 +0200
From: Christian Brauner <brauner@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?utf-8?B?VGhpw6liYXVk?= Weksteen <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] proc,security,selinux: let SELinux block
 FOLL_FORCE for /proc/self/mem
Message-ID: <20260916-begossen-tischbein-abgemacht-e7dada3d1e56@brauner>
References: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
 <20260910-wohnbau-bezwangen-wegziehen-7a32dcf237b1@brauner>
 <CAHC9VhTE82bRRSXSUuMOdrfoMh=xOb5hDvqiKWzBKD1urab3hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhTE82bRRSXSUuMOdrfoMh=xOb5hDvqiKWzBKD1urab3hA@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35BCDC000A
X-Stat-Signature: gpmm7w6to6451798p1gg6dymhta6mne9
X-Rspam-User: 
X-HE-Tag: 1789549320-724222
X-HE-Meta: U2FsdGVkX19vla6lkiBq4+BpV5vLiCBj5iRNs0LN1TAkpl6oHsgqJDXhdR2r40T6xYcG/ZzP+zLIKHWiwCzWFv4dJn37WUGJ187ZyqoMPk8ubG7i8R23yBbbquuDljFFNwZY5wJdb+feKQl4AIW0Y9HjDbHHZZzhVtTxg6M+6ekkHZCfCx8yp7b9AzggIa/Q3xZ+VtJJKpv4Zqn1yxQqVb0v67UWTiruj2PGebNc6HpTppCELbeLUUTsKvabSVN3r/hqn99ItkgE9cJbhbIR3oy8WSlaxi9kO3uAtQxS0XwlBcJBnJhY1cJwC/PgKQG7jg/5tiArbndX4w6SzKDWPEkB4U/VfSBlYougs8piDHkVd1zF8eDNanWX9NU7z8VgS023PyYVdxa6kfEECrk5uq3Vsa+0Joj5HkOJCLDkUhR5Nunmz/zRLXOsKsB3+7eLbfBbkkLQf89CQkN806F5Hj3Ewbd0HVCGwe9V0Qq3Yyzw6ZRAFDhy+5Ap2Mp5I09qXyGUiNvfGbAxOCXJT1D4dOxHj1IscDplTBhRE6Vy2eVQJTzut3mQENUU3L/YG/n+zA3thTRTgm9o+XYglIOrHcFAOwf0NZyALDWCVape9czLI890XN5qizybObLI8q6LRC/kv7mSFuT0v1zZDvmezUMS8FaVHm65OgRgqbVVhsa6z71G/fHYpWi99SgsbBotmH6Ixm6JvCSVdpq66yZIY7jn3jp2FJpzV1pXUHd0z92d7DFzKPzKgkB33HnvQS/iy0B1G0xeQJcF/N8/Mqt78ly2crHVVQxHTTjGWxIQJrF87BJZeP+/7Gk5QqlL7fe1+K4JN6IaURUZow4phHYky3ao8Q4ltv9Kmt8GNYZGq0KVg/1mMu4AQ2FwTz3ax9QlUZmRtmP/+6itg/jz7bF9OQaRaZIu6/1+G45dtutwa/8smQCwtwU0wkZVlASRiK0wnMl4N4FFqHyt2tOEpXK
 8lmf5fz1
 cm2k5anhcWVxEQCPfB6dVY6ut4a6yt/u93EVulYb1InLjwfCp5HMn7hrh2QCdhPhELhnTIy9lr6SFOSgWTGRJn8iZOZxqdIB3wn/aSopUMAEpnvKhe65TktunemaJfCWeW0Ks+TzZpv0DClrv4IEclFPLFV5wsRVbxgqw+hnOnUHNPLrKfnKTL/K1S6G+UvMyNjFuglOl4Oh4WFZLAtiV55Cx4KxXUZHNsdnuWkeq68xNSg/3Wr2h1zJCs7VwdAB17XtY7SacV5cdVo60bdVFMn7epfiZ/3C0omCdisrU6i7gvVhCPboeJaZVcf+RcCq7vXsz8F8yVHPCOXLplMlx6ujs7kwDPDJCploQq/YqLhrPPHnBqAFzeLzpJmyVYKK8vxQCHzUrSwzhcidP/9ka+a4Lu+8RFtr5CtgWDtnwPPfAdwsqwfdAR0CzyVwWPKfScyGkVx7V8c07lE3X658q85sVNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 01:05:39PM -0400, Paul Moore wrote:
> On Thu, Sep 10, 2026 at 3:48 AM Christian Brauner <brauner@kernel.org> wrote:
> > On Mon, 07 Sep 2026 23:00:15 +0200, Jann Horn wrote:
> > > proc,security,selinux: let SELinux block FOLL_FORCE for /proc/self/mem
> > >
> > > The goal of this series is to let SELinux prevent the use of FOLL_FORCE
> > > when a process writes into /proc/self/mem and the system is configured
> > > with PROC_MEM_FORCE_ALWAYS (which used to be the default behavior, and
> > > is still used by current Android devices).
> > >
> > > [...]
> >
> > Let's move this on a shared branch that both the vfs tree and the lsm
> > tree pull. That's the standard way of handling dependencies between two
> > subsystems that want to route code that touches both of them. Branch is
> > stable.
> 
> For some reason (/me looks at gmail) your email never hit my inbox, I
> only noticed it now while reviewing Jann's patchset.

Oh weird?

> Christian, can you explain why you merged LSM code that I haven't
> ACK'd?  We've talked about this in the past and I think I've been
> fairly clear about it; I wouldn't merge VFS code without an
> ACK/Reviewed-by/etc. from you or Al, I've been expecting the same
> consideration from you.
> 
> While I don't have a problem with a topic branch for this, can you
> also explain why this topic branch should live in the VFS tree?  There
> are more changes under security/ than fs/, and unless I've misread
> Jann's cover letter, this entire patchset is focused around enabling
> LSM/SELinux controls and not necessarily anything really new from a
> VFS perspective.

See the reply on the bpf thread. I think this just a misunderstanding. I
was under the impression that with minor tweaks v2 was already acked by
lsm people.

In general, if a subsystems hooks into the vfs layer and filesystems
that are directly maintained by the vfs layer then the vfs tree provides
the shared branch. This is not at all specific to security. It's just
more pronounced for notify or security because hooks are accepted
layering violations that place constraints on how vfs code itself is
organized.

I think this is just a misunderstanding that would've been easy to
clarify without the kerfuffle.

