Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50909CD13D2
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 10:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65CE8E0005; Tue, 11 Nov 2025 05:56:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF7D8E0002; Tue, 11 Nov 2025 05:56:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE268E0005; Tue, 11 Nov 2025 05:56:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 788ED8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:56:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E9691A00E9
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:56:37 +0000 (UTC)
X-FDA: 84098022834.28.548A926
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 89E9640012
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:56:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKJFap5K;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762858595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjRq0YRtxMoRBmf76gnK3sXsLqWZGz3LL8//ivtwijk=;
	b=E2rcF7vuUPIKtDrohnFO5T6hmEkN4ktvEp86VYf/gYPOawEz3KBFps18mbcaGIPK0XvuWM
	nUFEQACa3xbNLVpuvVqb+lmiWiHPB7H8ZEMOYwBfJ+6kLpU3Sqrf1SdMZF96h61Q/rfTtN
	QUDLyIekW66T/xTvNLJT8+EdEszcEFA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762858595; a=rsa-sha256;
	cv=none;
	b=shr8tuQjkUUN/GKZP5jVezyJrmQ/MYf9CVaZJXbC8k3It2sKb/34H9vu29/edCHL9KNKjI
	Hf7RLoWAawVI3shl8t5Ji2j+JI90Th6qsj7mbyJGKcvhoTWHWI1MI8OYAxKNiT2Cqc0mC/
	Y5Q44NIrW8l1m+9/rrDzwroQBwlOJNs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKJFap5K;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BF0FD61909;
	Tue, 11 Nov 2025 10:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313A8C4CEF7;
	Tue, 11 Nov 2025 10:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762858594;
	bh=LLE8UQmsCCogkZVKSd1TLbVt9gs72Jh93jqozm60ebU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YKJFap5K6aImcv2glJeiNMSpxrwhX6LrxJE9jB2o/nF/WyKkn1WH6018FXJoi/UCP
	 kwILmx0XpLJxYnaUhsyl42/On0deramtMNIHMDakZ3XBWX3DBuNSISALizcXkP5J1g
	 As9tysDbaFlf4n4MhlGm4iCSknWQmP/uRA7y3UcgxHHrHNeSX1vdVQgCeGvYZzT/xd
	 4kN6IgSEXZHZeuWLm2Bdu2rfQ3za3HSpRsHwoEVGtapRsGF7Y0ZMbazAjnKP+Hw6s1
	 1ehJojThYLaGzj/AfbW9ZcFiZLxCIHI4qKUiP0ztlFxRlVs0DdQDmb3wCyvyfh4liI
	 CUKpd3rfxq+1w==
Date: Tue, 11 Nov 2025 11:56:27 +0100
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Ard Biesheuvel <ardb@kernel.org>, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, neil@brown.name, 
	a.hindborg@kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org, 
	linux-usb@vger.kernel.org, paul@paul-moore.com, casey@schaufler-ca.com, 
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Subject: Re: [PATCH v2 22/50] convert efivarfs
Message-ID: <20251111-tolerant-profan-0aff1cc76691@brauner>
References: <20251028210805.GP2441659@ZenIV>
 <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
 <9f079d0c8cffb150c0decb673a12bfe1b835efc9.camel@HansenPartnership.com>
 <20251029193755.GU2441659@ZenIV>
 <CAMj1kXHnEq97bzt-C=zKJdV3BK3EDJCPz3Pfyk52p2735-4wFA@mail.gmail.com>
 <20251105-aufheben-ausmusterung-4588dab8c585@brauner>
 <423f5cc5352c54fc21e0570daeeddc4a58e74974.camel@HansenPartnership.com>
 <20251105-sohlen-fenster-e7c5af1204c4@brauner>
 <20251105-vorbild-zutreffen-fe00d1dd98db@brauner>
 <20251109204018.GH2441659@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251109204018.GH2441659@ZenIV>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 89E9640012
X-Stat-Signature: ibg8o9bzc59688ornzwkqds4o8oo4uw3
X-HE-Tag: 1762858595-453744
X-HE-Meta: U2FsdGVkX1+pNaaItU+5/+MjGjLegB8aGV5eCuoIHXSTQWO0rCg/dj9jOPvld5EZeiDTIxF/sFs89N6tbNYvo7Ko2q4kXZDt35jJGyXwtigf9TAAzM/Wdi1/VDGgQvat7lCtYQUIMM26a7IPQ3VNXqaxjrukq1WprL3vC+mlvAOnGvvT0Pneg/ZYOip8JcU0suAiBJN59aVGR7CXAlUkvMhJge/G95y8Tf1w1JAkyybsSlUwgwQ0sKIZ03OuT+4mWYVmStP7qTGWcJbLcGMFRf8cKDC3cQMAVjO5oaRCHYIjpj6U0w1yaRkcRGw1I9pNZWpuwskINOx7WEsdDPF++YM84GbglOrJCYRJYb4ac8UI0KNw4nknX4QFKuFwW7hvZaOWszW7dKSKm7WH7/ihjGo3aY1cDDdyDetZaKjkxfNSm8t+OB/pR8wRV8c/o9jw2cJvpzNTf+G5YX2+zfVl2Slj+gAGnWV/A2nYTrQFxnk466LK2vbsysl3eajio/o4rDla6Z3frzxTGfN0qElQYWzGRFq+0w94qmoD+mqDch0NFoQCYqlehtTSrDxz5nnTwDVxb9MsO4t6onKKoWsV5I8N7oZsFm4sCas3XqyRX7TN6lPyxWY46+CjgN1/yNWiSRvYqSWipGkkATbTQy6vYn/SGmrbpPZlHQhQ7c1oJUM64WRyMo0ISh2UvygDDASOoisN4C9Llshus1KrGrBlv4rM607/PPy6yUtB5AYe1Qsi5xDswILZBTIgty6SWS2DC2l9+CS+C69/W98lFmuZSf8MhzablBaC0iAgq1DlpmrzNU+cy9kBhN8T5mxO8r8G8aGk7qLu0eKUI96XW7fuG4rgqm/8RV7nzZPsbpor/8lRRlUOcE6WZ+axY4Vp8eI1Y6uyJdb5G92eJWABnhVESsBrtKkvuGMyN6oq2dTps4nMjwHOILqKwI8FN7e+diOjHwwZZ6+4wqHYmhoJksH
 Q+qKTX1r
 UgjtYV5wsdRUKDDLxWkr9JYNPJaJrfAFrhdf54eQfSaJ4y5r8gfeAT+WnwxJSJsIZtPJx553m75uF5U3EyAvHxuclIBNEXSW1QnBRWZ4Iaw3ne3ZloB9ek9MrhZpoF9z1kKG9x5NJ5MOkRd4w7g1viqimIVXMN9NaNvCb12amRJ0MrV2qGY6wR8KEjkRJEDP7NixsndErSjn7+ja5c1slgmbDOnMlid79uw4Kig8SVzNo2otKY8bMUbGKAY9X4yQQK1cUhhB46j1s6aJ9Oftb4K3KR1KGCYorbeohIwvWiESad/o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 09, 2025 at 08:40:18PM +0000, Al Viro wrote:
> On Wed, Nov 05, 2025 at 02:43:34PM +0100, Christian Brauner wrote:
> 
> > -static void filesystems_freeze_callback(struct super_block *sb, void *unused)
> > +static void filesystems_freeze_callback(struct super_block *sb, void *bool_freeze_all)
> >  {
> > +	bool freeze_all = *(bool *)bool_freeze_all;
> > +
> >  	if (!sb->s_op->freeze_fs && !sb->s_op->freeze_super)
> >  		return;
> >  
> > +	if (!freeze_all) {
> 
> Minor nitpick: do we even need a dereference here?  Just check
> whether the argument is NULL and adjust the caller...

Yup, sounds good.

