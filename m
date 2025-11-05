Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB791CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 13:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1250E8E0007; Wed,  5 Nov 2025 08:16:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FDBA8E0003; Wed,  5 Nov 2025 08:16:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039818E0007; Wed,  5 Nov 2025 08:16:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7B2F8E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:16:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 820981A033F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:16:29 +0000 (UTC)
X-FDA: 84076602498.20.7BE70AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BFF7EC0014
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:16:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RnQMpaiu;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762348587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ouVtuTIKii7y0Bm+84FshZp2YdlyYBJAL8lq4Poc/k=;
	b=Us+lZ1o4oJXSO+F0zeFXbfrhnyeYzW2eAYW1uQphN8eZ5A16iarce10xipRxHp1tq39pAZ
	geNP9rZEqQwSRzwBvFgshEl2j251l2YO1FQPTUN4ZmNghILnQOqVqlrGOMhQ5I3LfJPtM7
	8zHswVPwS37F6V3drdGxMdEh9aoz4zw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RnQMpaiu;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762348587; a=rsa-sha256;
	cv=none;
	b=zVBnjtar1IPzzbmi9BuASeP8oETLZ4wHLo/4yUS8EYCYEXx47fTnDLRu0i5fDV22gD/nz+
	Jd0WZ1boDC4OWPHtF8OsTr62hVtJH9nMeo8b/ugnLB763Jpwq2u6xJz6/XhxFTqHCBJw3g
	1YWX2tRZPyzpuXBz4c+M80pc05k1BbA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 90D20408E8;
	Wed,  5 Nov 2025 13:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C33C4CEF8;
	Wed,  5 Nov 2025 13:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762348586;
	bh=OBvixuYbeAnNVseOEocUtnf2AaLDAy6Mj92/tM/4EB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RnQMpaiuAolZlRt+GOgY8wQUOoEAqEsvvBhNHFfabs3tgQdd/42dJ4BLpf02azCs7
	 9f5LkQUq4/5I3J7xDoN9f2Nx12Ii26kGmzAPhXZW/DkyiUxqK/+qYDcLH0dpCdJpmY
	 I8bq0drnEp7lJ+2zecFyc266utJI7C9jUyFuiMrtFTL+vFSpS7KNPsYvVYBWs4X+93
	 JUVuXLg8R3tAigRVRdNoNIG0ah53puDwO3NtTUAHN+zuI28jyIbNTi77g/EJ7W3ive
	 Tobez7A38LaBkvBroJdXPCHcMoub+yGyJRZsEjNuf6bMVUL1xt7dr+leLrQHcqjThU
	 RYeTZ6wKB6HKA==
Date: Wed, 5 Nov 2025 14:16:18 +0100
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
Message-ID: <20251105-sohlen-fenster-e7c5af1204c4@brauner>
References: <20251028004614.393374-23-viro@zeniv.linux.org.uk>
 <66300d81c5e127e3bca8c6c4d997da386b142004.camel@HansenPartnership.com>
 <20251028174540.GN2441659@ZenIV>
 <20251028210805.GP2441659@ZenIV>
 <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
 <9f079d0c8cffb150c0decb673a12bfe1b835efc9.camel@HansenPartnership.com>
 <20251029193755.GU2441659@ZenIV>
 <CAMj1kXHnEq97bzt-C=zKJdV3BK3EDJCPz3Pfyk52p2735-4wFA@mail.gmail.com>
 <20251105-aufheben-ausmusterung-4588dab8c585@brauner>
 <423f5cc5352c54fc21e0570daeeddc4a58e74974.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <423f5cc5352c54fc21e0570daeeddc4a58e74974.camel@HansenPartnership.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BFF7EC0014
X-Stat-Signature: ewzprfthdomp8iri6jq3punth4mdn7bq
X-Rspam-User: 
X-HE-Tag: 1762348587-140659
X-HE-Meta: U2FsdGVkX186pDZA5BeIo3wpfRW3tge7F9QLbxxvZfUBqKWgBBUC54BZ9YwW1FShAtMIYXm1QNRzl67wKm3ungdlySU6kNosSTifCrRavItkoQePiu1EcjP63I22ZZq4F7UuGhf24kdk3JrNhpe2JNtSHAoTjx/vthrjCeK39l/M9VIWdalk1LkqFdOpQG1hOpm5+ORazSoru6tOj2BetR3C/8fWBZv34L6drc85AT2YMcUDAMjmf8bTGnB451xZaQofgrj6JrcD7JWRnlJnwoUmveMbJPPfHpgqriDEyUtLej5b7vLSjo3TmQ6NycJm2lgsTnlfRjNBUfkKgjxIc2I2UH6LPVWKfIvOEGMkWy6wdL0YCqLMU29qeRVHgnUFf5+7MzrE0Fbai2yQubnVb3rk45rF/VY9Jdlsq9Fmls3kMhJT8/PVhgnZlo1qtgUM1npU0pfAedl1rF8GbfsCV1fheAY4ydl6UqllQ9RCH2/EPva8H+E4o/o6yz/Qk6acUscxaVmWIcDzHuANUpHHZ/uNcKs31pIAAixgTnuqHinVCEJRZhZkP9CmGiOMDj48KQzdnsfL+PQAvOuEMN5YA64WD+c3H0NZ8uqeqJwozwSVc3q9GGWAYH5iUWoSxTuBBifTKdnNtAxNxwsxZA1Snke0sHxdKlc1DkqWCz3aKLLG1+YQd5VHyn0zYRNtp5VWHCdmOqLICI34gXZTrp+r48a/dcq9mNug6eSjNQ/ejsMusjOmzjYcJ4Un6UWK/1AHvWyMh/AD/xocHaKwEklqlmtS3lKLyVJJFeefCYQM1Lq5fA+UHlmvE+g3K5FGgMaVjR1jkkbWCCpTDgExlpIjVf4kCrO8CqKwLy+49eF5DZWgLJzgDqvGmRibAjaaCDtPdawhJ7LZRpBJ7QYGrkbblGEqR9dQJzqMTpm1ZC9/rFj2i6YRFG5u8zjUrfYYopvlu1OV+PmViJfTcaE2FPB
 ogbUUGfY
 ynjCWahj3tRqgiK5oMBNuV9jljE48FG8QCsQB2pbut/Z7+B535IsXXkxFxGWME/OJ6tOTaUJwAjLDSTNXKH/d2hYM0XDf3zUJ05+KXlOZZ/7vTvftmrmSU4rvcdl4frvAhraa2VgLKvT3UKOkhF8Es0Y1G31ph5bkhnB+O/G+Xdw5VC79VgSH9CBP2IssJ6uoCe6iBUx3pIRLTDKIS1Afwrf/8fFkaVIrYzSsEEepoZkVyWmii9i3nE2hzbLzZosz/VusKbuyHZPY74OepAHRCHkI1kUJgLRpUU8yLTro8yGWiCA7kPHtYO7D5N2Ys6IkdujqTk80HbJp880MSIjgNWHf8NnB6VMsT0LK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 08:09:03AM -0500, James Bottomley wrote:
> On Wed, 2025-11-05 at 12:47 +0100, Christian Brauner wrote:
> > On Thu, Oct 30, 2025 at 02:35:51PM +0100, Ard Biesheuvel wrote:
> [...]
> > > commit 0e4f9483959b785f65a36120bb0e4cf1407e492c
> > > Author: Christian Brauner <brauner@kernel.org>
> > > Date:   Mon Mar 31 14:42:12 2025 +0200
> > > 
> > >     efivarfs: support freeze/thaw
> > > 
> > > actually broke James's implementation of the post-resume sync with
> > > the underlying variable store.
> > > 
> > > So I wonder what the point is of all this complexity if it does not
> > > work for the use case where it is the most important, i.e., resume
> > > from hibernation, where the system goes through an ordinary cold
> > > boot and so the EFI variable store may have gotten out of sync with
> > > the hibernated kernel's view of it.
> > > 
> > > If no freeze/thaw support in the suspend/resume path is
> > > forthcoming, would it be better to just revert that change? That
> > > would badly conflict with your changes, though, so I'd like to
> > > resolve this before 
> > > going further down this path.
> > 
> > So first of all, this works. I've tested it extensively. If it
> > doesn't work there's a regression.
> 
> I haven't yet got around to finding the test image I used for this, but
> I'll try to do that and get a test running this week.
> 
> > And suspend/resume works just fine with freeze/thaw. See commit
> > eacfbf74196f ("power: freeze filesystems during suspend/resume")
> > which implements exactly that.
> > 
> > The reason this didn't work for you is very likely:
> > 
> > cat /sys/power/freeze_filesystems
> > 0
> > 
> > which you must set to 1.
> 
> Actually, no, that's not correct.  The efivarfs freeze/thaw logic must
> run unconditionally regardless of this setting to fix the systemd bug,
> so all the variable resyncing is done in the thaw call, which isn't
> conditioned on the above (or at least it shouldn't be).

It is conditioned on the above currently but we can certainly fix it
easily to not be.

