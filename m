Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF200CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:26:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502208E00C7; Wed, 29 Oct 2025 14:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0408E00B2; Wed, 29 Oct 2025 14:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4177A8E00C7; Wed, 29 Oct 2025 14:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 307CC8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:26:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8FA713BDF4
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:26:17 +0000 (UTC)
X-FDA: 84051981594.20.5E1DFE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D4B7CA000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:26:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ndpPn+k4;
	spf=pass (imf15.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761762376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2z56nIm+5e1IvigR9gpmQ54kGrlw/bMFXbXEDGYlOqE=;
	b=up9s/y8B+SP7aelh6hygJlo7l7hJ1gpYwZt/n2XN++Amgcmyyg5Qg5xGQ6OsKjLm+UmnGS
	bqHRsHHEW2GalgigvFWusHf8aHSmYLD/C3TSlnbz7dmKFCtFqHMCNBtKPh4WPN39bPuvcE
	h+SAji3QVhzaqrHSs4+sun8sEQP/YJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761762376; a=rsa-sha256;
	cv=none;
	b=g5L27hFYEdVzNQxRLTzJXYhYHKuKUJfmPtIBFdTTWo51hiAb0lhemxqbNtLpI0g+Thw/FA
	JCywaczS0lvEqOFP0l6If1ZLhzI1/xjKZIUEnnR5+QZzg2WeLT6Tig5ymTk3l4yJeOFy0z
	LGLfku9x2vrSV5i24HOrwAUEtWn3VuU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ndpPn+k4;
	spf=pass (imf15.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 00D3348CB4
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BB4C19421
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761762374;
	bh=SOFE0nE/iwywHZBzY2PA6i2R26wO5/VtY5Jl8lJ4X0I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ndpPn+k4EfUaw6fNwY0zWNL1ecVLo8aBHRZnSz07kFgD/dq8DvyELXxj76gXV4oVi
	 ktU0XjzrjKbY7uijyq0vT7UtIcjyb/ND1tDToftHHtDIAiRt0YVm3arL2lh8baMuAI
	 +vz8+RoK0Jww3pqJv+AvrM17kvv5Zn3eqLes/WMlFA/6VE5WWXYm60bfEKGra5Xg6r
	 thZTXHsYe14mAvd0C1rleJrkFPDe0BuI4HmI2JV5mxGnO4BhQlXQdt5qvo6Gy0KBaT
	 P6l6n7spmgQ3gWjfr6j6dtYxaD0JXVPuWt+vLn28H15m5YyfxxytbyH5B0vKNTckDF
	 7LduBId0jKXTw==
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3737d0920e6so1273571fa.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:26:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXBCBV2jVNHimeWHGYqUR7yhnesh27oGLwFfHJx24ZWp4v+xUTTvGMUi6cVQDLBFp0bwDo3+vd56Q==@kvack.org
X-Gm-Message-State: AOJu0YxFMC+yS8ZXWrvEj0KkbplQChD8rLC9gBiZ0yyBPJci2jRl25q5
	xunI0mVhw9P+KDm/GLYZgAH+vpODy8PSpNX9rhwM5lAZxHLKndmnQWd7sLlTu6pD1QBH1iYZKMO
	lMqqvcVYuKQLjUts/P+4ttUMn+7W2ufU=
X-Google-Smtp-Source: AGHT+IGWFfmJwHuAqzPgZNMRZ1ozVQDIzy88Y1FgQVzyMri4R3xOByg4mInRl7CgPci19RHNrfDbNPxS6PSkoSTGQDU=
X-Received: by 2002:a05:651c:1986:b0:365:b79:8845 with SMTP id
 38308e7fff4ca-37a023ba9e9mr11427831fa.10.1761762372950; Wed, 29 Oct 2025
 11:26:12 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-23-viro@zeniv.linux.org.uk> <66300d81c5e127e3bca8c6c4d997da386b142004.camel@HansenPartnership.com>
 <20251028174540.GN2441659@ZenIV> <20251028210805.GP2441659@ZenIV>
 <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com> <20251029180835.GT2441659@ZenIV>
In-Reply-To: <20251029180835.GT2441659@ZenIV>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 29 Oct 2025 19:26:01 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEB+W6wNDUnWeaeiuRqR-AKDwNhsoCAXokAEqRjSt7v7Q@mail.gmail.com>
X-Gm-Features: AWmQ_bl33W7u9Z27QoRt9V2mEw_lUKBXPTlGyVImKaOffP2I82t-eoqvuUfjNRY
Message-ID: <CAMj1kXEB+W6wNDUnWeaeiuRqR-AKDwNhsoCAXokAEqRjSt7v7Q@mail.gmail.com>
Subject: Re: [PATCH v2 22/50] convert efivarfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-fsdevel@vger.kernel.org, 
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org, 
	linux-usb@vger.kernel.org, paul@paul-moore.com, casey@schaufler-ca.com, 
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com, 
	selinux@vger.kernel.org, borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: 6fie61a3pdxyt6yhecdo5g7i8pz45f9s
X-Rspam-User: 
X-Rspamd-Queue-Id: D4B7CA000C
X-HE-Tag: 1761762375-909871
X-HE-Meta: U2FsdGVkX180F8Uo1MrZlhLi1T2F/mI59iS/48Fuvr1vvUq1HEx3WnuO9T8Axj59XjuCWxh+f3AnNevMAqHmYZB5wuLAAZpErRN+VLmmQ5hA4Ehdrh4S59QDhy2WTPjlZFUhRz080YyT7uVsP2pyiw2v7OZxkzAhI1fHh2oXMX0hqftfWErwsBpnBNRmV4GQCdPjE/EihjZ66yYTboBGkHrUMEFsqXoKxD4dSHapJQ3BZHx41CM7QZgirp6hmGX0CynN2skE8ki3MHG/psunJJr3ecYUvw/pl7Rq+mpGINxr4BLdchGOypDcX6Wf9Y5ZghOn86c/lkx7wgGCJdiFUTc3Xtl48EFa3o2lHhWr7fKYw921lLyQEUgAp++0+UmNtVT2KHhvpBc2d9Or6zeX0fs+MHUq5MYWxXedpmZyUIy8J2bp0fhSurUMJ/So3G9Gud90bMHmgFlHraF+ciVlMT8tWVvMbvcLWd3GPSdIxMdN5A5VS/YcFh2YX5fNbK5s1ZNqR+SdItRQFCbIlD8ExV6KClEKKXYyAH8v3bVIfnqbzmSQs79os8EHx8M30QqBHaeEpMwWlXO92tj+QX/d1FOk+SQrkyhoXTzkOdypW7C075H1HM4dILJx5LjYbasTcJtiYnxKlu1zGbKzR6+eOqtG9BDwWbCX3iMxSjXphQXAkeEntjT7On8wLvMuqdzMlxZ+wAxQsmNhQMOVUm9EODqHgEOn5UnnXjbLCaj3S6CSm3ZrQm45fz4lX/JeSq1WRtk5I1MlaWwOPQdK02FiQo3xaFdLUj+evl017fbhfWcII80Sgf7hfQJgos7YJ5/874t64hXGMKoTS13KlCXitxesqZ/FRbNu1fU/5hcgTa17pIffcpy7MFVBhgnqgCCcvVwj5KKD1CA3jyLCji4NJNXHl4umhOAPnXS1laktJDV1rsBMQtfV2g2HRo0KsBTYCYn2PI7gw9YgOXBpCJV
 oJnYVhLO
 /NYPm05PZ+MQBhVIhbfWatc8GaTNZPsIxbTWulF2gern0RU3HxNP1OClfGrLLImfNWWzIY1SIFTcrOGoxiEfrHJAmUB6fYYH+hNn2YG4ct8BqasbHzW4xMe0YyTq46l8QAc3VkegWzlUFKwtuGnc6LPIvvV3qJcvY5DEQ3hfusbdGKWKQXKKu+3l0XJDNqw/OQzIt5lWlhnNkiUnaJs4sNCk9uPDLNbfmP3+crUBG68mKKSYwVyUtLuOstAMIpjh0AbXY/JOA1a2bCnD9qwdKoimyfojMPgsVhxhuwOwBNe3VecRNH3kTKQFZZKq+d5r3Va2cHcfxZUKzjZYsHoLDmU0Omw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Oct 2025 at 19:08, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Tue, Oct 28, 2025 at 10:34:51PM +0100, Ard Biesheuvel wrote:
>
> > I'll let James respond to the specifics of your suggestion, but I'll
> > just note that this code has a rather convoluted history, as we used
> > to have two separate pseudo-filesystem drivers, up until a few years
> > ago: the sysfs based 'efivars' and this efivarfs driver. Given that
> > modifications in one needed to be visible in the other, they shared a
> > linked list that shadowed the state of the underlying variable store.
> > 'efivars' was removed years ago, but it was only recently that James
> > replaced the linked list in this driver with the dentry cache as the
> > shadow mechanism.
>
> Hmm...  Another question about that code: is efivar_get_variable()
> safe outside of efivar_lock()?

Not according to its kerneldoc

/*
 * efivar_get_variable() - retrieve a variable identified by name/vendor
 *
 * Must be called with efivars_lock held.
 */

But actually, I'm not convinced this is accurate. The reason for
locking at this level is mainly to ensure that a SetVariable() call
does not interfere with an ongoing enumeration calling
GetNextVariable() in a loop. The individual EFI runtime calls are
still serialized at a lower level, given that the firmware is not
reentrant, and so holding efivars_lock does not provide anything
meaningful for a GetVariable() call.

