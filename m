Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C1CACCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 13:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D038E0008; Wed,  5 Nov 2025 08:46:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64F08E0003; Wed,  5 Nov 2025 08:46:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA17E8E0008; Wed,  5 Nov 2025 08:46:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB69D8E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:46:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57A15C0366
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:46:18 +0000 (UTC)
X-FDA: 84076677636.17.9CFEA31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B104C8000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:46:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ShpmD5CE;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762350376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEmg21q/bTDjej8FQo7XnPxvi2Y0z8JlB/H39ewNpd4=;
	b=h0TH4gkFrPghMoM4hwIe3YidTBBHR2dF3SJ54a7wuqJAJ8WyqIHIt5PG/0XL3GwYiVPrzv
	4d1dSUP3L07fLRGKJ1wtOBoEoT41+lYPj1vd+9D4JqIkFL85VeCAqvx/xUIpAWehWv+Q8o
	c7BEgH+I4Hw726a6Q5HLEcauSQL0z6I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ShpmD5CE;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762350376; a=rsa-sha256;
	cv=none;
	b=gbzxxFcVMwfXnUzNaRargQmNgJT9O8HyTVCJJUy1CbFEYm0rDS2bOTv6OUljAdlDaNYGYm
	q4SvaEGlVuk8M936vb4k9i0JSuEn2QmHc6kpq7/FMXgg8gWo5hVTs04t2uosae24BMWskX
	zckU2AOIJrdBoCZkegqGXwIz39RXhsU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EC5C860206;
	Wed,  5 Nov 2025 13:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88442C4CEF8;
	Wed,  5 Nov 2025 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762350375;
	bh=PBw6f127nni3oALBZyW0JgdvwP5qSqzJy9SAmndAriA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ShpmD5CEr+JOX/hdyLmwbKn+7N/84QMIjLE9j2cZcrRvpVVQ75tjvns2y5AtNRjNB
	 Yz/cddtecY9g6c5niROEmlZIGG5XZUkdnkP1ukuBnc6gReYjrQWthxBdx6AWzSPCto
	 H5T2MJQ6JwDB5soUuJR37OivkZPbAKj+jm3MbBvvRUCLje5nBaF8qyof8/avmrOrQo
	 AetMggcJiBTqXIIqRYQO2peEzYuk6WbKzeJQmuHBsuyC0xrt8ateYNVpRjsDJ2WscG
	 uhaFUjmftREcVGApZjqCE58fnFSyfg3U6HCIwJGFbq7P1TvBbf4A89/uShbWcEdej8
	 m/GMvmV69qEFQ==
Date: Wed, 5 Nov 2025 14:46:08 +0100
From: Christian Brauner <brauner@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, jack@suse.cz, raven@themaw.net, 
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, borntraeger@linux.ibm.com, 
	bpf@vger.kernel.org
Subject: Re: [PATCH v2 22/50] convert efivarfs
Message-ID: <20251105-ausfiel-klopapier-599213591ad2@brauner>
References: <20251028174540.GN2441659@ZenIV>
 <20251028210805.GP2441659@ZenIV>
 <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
 <9f079d0c8cffb150c0decb673a12bfe1b835efc9.camel@HansenPartnership.com>
 <20251029193755.GU2441659@ZenIV>
 <CAMj1kXHnEq97bzt-C=zKJdV3BK3EDJCPz3Pfyk52p2735-4wFA@mail.gmail.com>
 <20251105-aufheben-ausmusterung-4588dab8c585@brauner>
 <423f5cc5352c54fc21e0570daeeddc4a58e74974.camel@HansenPartnership.com>
 <20251105-sohlen-fenster-e7c5af1204c4@brauner>
 <305ff01c159993d8124ae3125f7dacf6b61fa933.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <305ff01c159993d8124ae3125f7dacf6b61fa933.camel@HansenPartnership.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B104C8000B
X-Stat-Signature: pm1xu6gem98kjauw3onbc7rsrt7tt5qt
X-Rspam-User: 
X-HE-Tag: 1762350376-824717
X-HE-Meta: U2FsdGVkX192dZ7OYxnJPLIpMD+uIAMzXk47jLWCYOJbnF51RsIUAufLX+MQBZQ62R7qQvy1mXc8kkKHVztWMS3pVszx6ccPJjgP8+0n7UFkYTr46XcPmy48OWkq1Nff+b/xNQr6NbEkwRyeRYmrgOx9MnuXLxNl3DyIvdpYr2oTch9C588WTHISLhAhV8G+Nur8jmmv/hvufJbKPsOCHRF7F0KosxnT0S1ASnJDtFcroIZcz7jxM0nUOY7gXXYvOAAucrPzHCZpFssy3g3vKOFI0UO4wtmPSDLTWZ0yLSBEv/LLH1R53+TFhkZTb+TmJ2SYqKwxcZ9h4xYFth1Sba/t28DdBTnp0hyeVao4ybU++cXpwg9mkpHb8gG9SGLgb87vPtAEWKWTx+0CH1+6JK8DT5kL2CDqqTN/N9S1kLwMRzfLwrRVcEnKCUfFdfVjlh+ffBuJnnh+Wv4IKpDIOZoGA2bM4d9kh8z32IJlD8bajtAg1/6GZNUF2yfaLhFFxl7/tP45jKDYJNAVAWbGwJ3FKIu0nvEWDGAq8S+tfxliBkzhIz39COZyIitvV4tQXoi0cVDCcgm3jiVDDNNt8X1BQ8XwEViSM51VQ2A6FekU5/eAjBYtmNurH7Pp753JrnFUXfRE1Lc0gsu2zJo+h5emGCCxfgxu6Damj1eoLKJApZI6GL3qFz4AB4n2+3cZbiGyxPGybzQn5uWBBq2n/GIyR+a/S78FjJp3BdKRpKHxIUs4C1YJUpNNoojF8Ts0rCL1EtXmBHtomG2wUtDVC0u/AbVOBAdFz0POsaM1jhzyyG+1HHg0Slk/r0b9bzYLOkfuYdhrnUIuLezhd23r9MTXGm7XRnB6EuGWh4m8WizxCGt2BOQmMdOrAFv6WVmOJhpXrYuE6ttlEiVAnOQMTwnu5znIFKVrjiRobjDaHHm+cyFKMYBYe6mCqnfXZN/5O5MemfseTPgRW97M7P3
 f41C8B9s
 YoWXNTEW5KEOABUkgtMCh+niGgTJUcE46mhQLkp0HyqnASyAc9Tm+a+6esKXuaEkvMZ0fiCo4+E8Dw+7U6Ge0L+50fMxOIoUZeC5PJph+JXGBAXcEEM4x0QyEXxDqK+dz+XquPFOc0OO8pKK+QlecfaeNKi0H6zQVk7O8d/kSLq32zVVVYd86NBDZHGM0qtZacy2gxwomyi6kZw+9Ttd91RiRO0hbvnCwHGadF9+9wwfHi8ugYnOvttFE38lrMnAk/v4gfnrzJeBXfRPR0LGwXOwtSUxxDbHfLSEPpmMdfM+6nOYs6OkYeEAY1ytQIJCqFf+try5P/R8Cxpo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 08:33:10AM -0500, James Bottomley wrote:
> On Wed, 2025-11-05 at 14:16 +0100, Christian Brauner wrote:
> > On Wed, Nov 05, 2025 at 08:09:03AM -0500, James Bottomley wrote:
> > > On Wed, 2025-11-05 at 12:47 +0100, Christian Brauner wrote:
> [...]
> > > > And suspend/resume works just fine with freeze/thaw. See commit
> > > > eacfbf74196f ("power: freeze filesystems during suspend/resume")
> > > > which implements exactly that.
> > > > 
> > > > The reason this didn't work for you is very likely:
> > > > 
> > > > cat /sys/power/freeze_filesystems
> > > > 0
> > > > 
> > > > which you must set to 1.
> > > 
> > > Actually, no, that's not correct.  The efivarfs freeze/thaw logic
> > > must run unconditionally regardless of this setting to fix the
> > > systemd bug, so all the variable resyncing is done in the thaw
> > > call, which isn't conditioned on the above (or at least it
> > > shouldn't be).
> > 
> > It is conditioned on the above currently but we can certainly fix it
> > easily to not be.
> 
> It still seems to be unconditional in upstream 6.18-rc4
> kernel/power/hibernate.c with only freeze being conditioned on the

I'm honestly not sure how efivarfs would be frozen if
filesystems_freeze() isn't called... Maybe I missed that memo though.
In any case I just sent you...

> setting of the filesystem_freeze variable but I haven't checked -next.
> 
> However, if there's anything in the works to change that we would need
> an exception for efivarfs, please ... we can't have a bug fix
> conditioned on a user setting.

... a patch in another mail.

Sorry in case I misunderstood that you _always_ wanted that sync
regardless of userspace enabling it.

