Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D28E9CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F16D8E00C3; Wed, 29 Oct 2025 14:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8208E00B2; Wed, 29 Oct 2025 14:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3056B8E00C3; Wed, 29 Oct 2025 14:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22EF68E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:08:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D79D712B131
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:08:42 +0000 (UTC)
X-FDA: 84051937284.27.F59E1F5
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 15D7840002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:08:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qstw6GBW;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761761321;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRO5/rJhd7y6qAbtBBfOnyjO73djps2jbwQIhCfiClo=;
	b=1AXolsce+fdC3hz4Se1PaTpT5i1OAuo/l4bRpfU5Qmg+GrVsO38ZNHXnz0WoO2EY6qywjA
	SxKKZCn/OlPRjl8F2NPdVsH4vx8bQe5Pf44VhOE44ycOYlw4Rh2Znrw/kykV5I20jSYFwi
	FbR87A20qDgrcCHemIVclRJyg4xkc2Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qstw6GBW;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761761321; a=rsa-sha256;
	cv=none;
	b=5UB5LFJzG0FgBOewS6207+ht9CmKytJAGkX36TU+l3U5Ue22vVGijelxGEafqitm3/fkqN
	m/0PWFGOpMDrm0Mv+2Nh014X4BLjwv63DqwsN3F/gAacfdSlD4q0JT2ET22NINPnKJYa35
	8sXQh6FXvo0AlVDarxlVHH17/l1RURI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IRO5/rJhd7y6qAbtBBfOnyjO73djps2jbwQIhCfiClo=; b=qstw6GBW0gz7l6/NIZ98+H0BuC
	LPcTpqbv6qZwuSaVXzFp5+8p3uItulr9RO1wyw6k1QzQVAfHUp/CtKNeZtDmZSm+sgFarRadUCpBK
	QZrzf7l+w0/cYrUWCRtQcOPwVpTXfR6WfE4DMsjuxuOQV+z0xqou2NBsCOGqqoMuLcuomyEM5NJXa
	RJQMFf1J+khB5G8o/qb4hoF8XxOYm1SETmvEkodR0rT9kGWkPtyAGI//REIRqkdUm4sCbPWkkDpIi
	qeQgTiYS1sVVgCHccSx1/k4oTcfdfgLL7bzYX5FyStzF5GG23KhpEBcGZmGVQXrQATbM/9H02+9/9
	Dy4tNtaQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vEAb5-0000000DNn5-15k7;
	Wed, 29 Oct 2025 18:08:35 +0000
Date: Wed, 29 Oct 2025 18:08:35 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: Re: [PATCH v2 22/50] convert efivarfs
Message-ID: <20251029180835.GT2441659@ZenIV>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-23-viro@zeniv.linux.org.uk>
 <66300d81c5e127e3bca8c6c4d997da386b142004.camel@HansenPartnership.com>
 <20251028174540.GN2441659@ZenIV>
 <20251028210805.GP2441659@ZenIV>
 <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
X-Rspamd-Queue-Id: 15D7840002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: o6exy78pwbp7iht1i58nsx1acpq95b8b
X-HE-Tag: 1761761320-763218
X-HE-Meta: U2FsdGVkX1+zi9lCfSGokX7907Qlbm966Us5k0xdoFuiqzexC7h9MYtHpMEYWTzTFdyJzmInKNloJJoIuoqUKpBZhpeJM7BAHgft45UhThttzgguIVvaSNouqcPwt2zJf0oT10BipUwchdS8yA6somn2dsJsBdwY6orvCqJAldWNJXEAlesutUn8lABUdVxRJe4I59vGbK1dMcvU/nyVwypPy1LLPS2kI5klilZWsh6deDRAfPrqKhaM6bAtRalvYZvV6ccoiFSjMPLU7WK26HekbV2QU+yoj/mZdjeccSB6UuDnOoudl0+qEbSlHkgGmRb60EtkcYuqpqllvuaE2P1maNJX0sduT6uLVkQ/zFOvQoGhdmCdMqMQhSscoofySZmtvrSk8HGRu/8bkhnQBEoZHt0Gbm9ePIqFuqsTKQQ5Y62AvSMqJEirXsDPwDVoYQkkSxpXyR2FpyeeXiztwvRGj/bUhwZfCKm2mdS9D89Ht2rZxrLGe6KFBXZdlT+JK9Aa9+ZEt0exMhBwgyGUjHs55vLqsu/rn/4qeJbwFjtKu/HkEpqJXElXVdfGGZrm0fDMMvF4ziNnwhRFwghaDhJBWOyXczLmPXafo0htDxO5Ge7rZ4kaqvloLnO0HD6+Zdwe9SYJL/h6XL3T1zGnvuXVA0uoq+svkQMyYNUJ9vSrfxkrdJPHAvGmMH2qPX+FM8EwpX8YC/kQa+gQgJyD216hgmhEJ6ZrIyPwZr+pF3pvasN9S7PsjYW5gJLcKkDHqzvwk+TLhAgV6CFZE/sQ6cxcFDgMrIzylClPGRAa/milu7zhrTYlQcVIteJw2dhA0wVunAzh2O8Eslqm8FHQNZsV4lQK3NyK3P3BHk3Q9ii26fETWblLwh+7H9p+hUREEBZoz43u/Brmf3oO6NlKXEgvGAKgjPinlwwpj1xDvtQGdKFls/uXYqWeVDhvWdoCMqrsQiwKcm4fYmOUhs4
 yDsPo9od
 WLJWJLKaEakL3ljRwhXiMKs3nbGVEi2f5pGCsTmak7rPJWzWFeQ6ZoapoSLfI2IK7vKGQA/GUGo5E2IZoey3ACBoOzQiS+gRMteGauC1UfGnZKDG59oiZFVfbUW9uRdnEhAcS7A8aC7IFp9Y+QNXZc8Z6tywwmGRVYJk/ODiq1xV0y1L1BFLMh4fkjB6r06gPkcPMlBOz74uQxD6o9bjQI0YjW1ichJ7B/wAdEfA6JJMiNmMtLVK7WXqd5ZBD0peiR2Cpha+1hEopy1d6ss3tc0zdrWCIxkIjjADAW5YNcVRqU7WhPRz2rfqS2ct776NU+MZ6wTcLDJ395VdHFWJaSUnKqyDPxXgi9fOy++0UGIkraBP43n5hE/Sz39GeEzovT3/svHkTSh8EdC4MKCgp6jyfiLOOrczzt68KzVvMRVtz2sS2n0Xelyul2WIIuJ/uzEQM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 10:34:51PM +0100, Ard Biesheuvel wrote:

> I'll let James respond to the specifics of your suggestion, but I'll
> just note that this code has a rather convoluted history, as we used
> to have two separate pseudo-filesystem drivers, up until a few years
> ago: the sysfs based 'efivars' and this efivarfs driver. Given that
> modifications in one needed to be visible in the other, they shared a
> linked list that shadowed the state of the underlying variable store.
> 'efivars' was removed years ago, but it was only recently that James
> replaced the linked list in this driver with the dentry cache as the
> shadow mechanism.

Hmm...  Another question about that code: is efivar_get_variable()
safe outside of efivar_lock()?

