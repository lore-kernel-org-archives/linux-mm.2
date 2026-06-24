Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73BF9CDE001
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 449EE6B00B0; Wed, 24 Jun 2026 11:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420F86B00B1; Wed, 24 Jun 2026 11:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3610B6B00B7; Wed, 24 Jun 2026 11:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11D7E6B00B0
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:30:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FF10167245
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:30:58 +0000 (UTC)
X-FDA: 84915194196.10.B49083A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D1714A000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:30:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXdIc7ms;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782315057;
	b=yyMgp9G9MQMcQM4AF5HoUfV9PreZk/7DStGmv5Ay96LgdJ9e3fTXy2Hb82DDV51UHyPVG1
	ga4noPWIq3rN47U7mNXdBXJej7u4e4qJuGRPamloZ72RR+Qv6bqpBzqssbgEUw40uZIN6/
	SZI9ImN5WvVBsRsnlOB63r3TLfJCL0k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782315056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqabNweA0Dj8i+lySHEYhKjF0pB8jk6bzkAmCBn9GMY=;
	b=A736dyA4jdIMbnlokhqzrWD88ZfwDU8vT16ftsr6nzcYRQLX8wQLV5zabHQ4l9r15PSzDq
	J9WtZ12o5HDj8Vqtdi6Tbn+jdWCrDmvZCCxic+QnpbTi5s/0eawLd4MjQU6FQJSMP+ydzC
	+yzQpeyPhfBhh6QeAQhmQglILNaKey8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXdIc7ms;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9E3842AE6;
	Wed, 24 Jun 2026 15:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4231F000E9;
	Wed, 24 Jun 2026 15:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782315055;
	bh=nqabNweA0Dj8i+lySHEYhKjF0pB8jk6bzkAmCBn9GMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EXdIc7msQ6rTxV0CF+0X/FFqJXlrEDaR8fgIT8d2KbSgpMfl0erSLMCqPiGgSyFAe
	 2ECGGVfRU8Ux7imc9Fx8y7WGw+b5sDLfVM2k6d8GvUvmtKXYAu9bP5TtucS4Yeeqwj
	 FbZR5gydZsTIZvfJjpCSwguvintY0GzpYJjnAR5f/V8iLX4BG2ckBtnS0XAYWICsOR
	 j7r5XBLrkxQ7MegI+hKcUFnC7RruMYoRw2luUBeiGuiZEfY5taW5BUXjtno4YkGKMj
	 QmZ01vXmAIjQE0BekOoda7aW//bTTLrKea3uUkulav8XEDjrS2fC26oYL63kvuby7i
	 B9vRzMJAoPEnQ==
Date: Wed, 24 Jun 2026 18:30:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, izumi.taku@jp.fujitsu.com,
	linux-mm@kvack.org, Yuan Liu <yuan1.liu@intel.com>,
	David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] mm/mm_init: fix incorrect node_spanned_pages
Message-ID: <ajv4KewVYU5YzVea@kernel.org>
References: <20260622022403.16375-1-richard.weiyang@gmail.com>
 <ajk_l8cT0mIyhs4r@kernel.org>
 <20260623083507.kg7jmd7ofz3awqmq@master>
 <ajpQR0hX681OryCB@kernel.org>
 <20260623092653.yfahsc7kekuncbcf@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623092653.yfahsc7kekuncbcf@master>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D1714A000B
X-Stat-Signature: a8z336eppye3s19j41r79yw9r7on1si4
X-HE-Tag: 1782315056-537295
X-HE-Meta: U2FsdGVkX18O8BTAYaXIKQwth0sehD2eLm9AJqIRDSYa5zc5WfeJiP8ZGlZXp04A3Qg2IYT0ArWjkikdL8roDrlrtGSYCix0kmF2KZZW7e1QLXPf9SWk4Oei87JHgmeJob1b5rUS2sslUl2jL16ZSCMYdtZN5AUgVedTDCWyc2r7hkvgHmvjZMU1FbHGx7TP+m2f/idnkQpzzNpUunDOcYDuoOHAjXkYh8qCBIMd1rY8/jWpddsOuY9yrHvJehxdcI74mK+4hgY25SqCiypA36bWknKx497FG9FEDEmdTAqVqbxcLmaIqEcU2GdeOKg0X2qMeOBOBoFJERmjrlaH7VE2UasXDZHXhKwfWhImHFFnBcj3pwsZ9wc0sZC267SBM2AsUgdtTdn1k9wbqQum9BPs712pj3moiyKMCMimJ2QEPX5kUsoLMvSrMoSp+daRlhwDIuR6xfolpgsqK3FBF5TDZZR1TdQ0VmluJpishXHS68mOdpzrf1pwd/Md9Cl3Urudg/kNLLm9NkT/8eojwQXUHfYBDAdVj9EKpWOfBFpCGtAHcnicqcZ8wtJNFPEgQuqoTKsdzimFjqIH+9GfsSxdO1AHFDZA+XvpjZz+N4qInVnX551C2NJ4kO6QPPlghCqGnI28+IN/eZ5akBWxIuH7sqrZcEcBjo9zvtKQvgv4C9tiYhC+UihfXLp9KxLwCbPP8UXVmvUJuZsFG121gYwksNxdCWgcSWCLwjPywnVDhXIuyWozWgRADSvGTaMoaxxwezlQncxyvoXKbHwCelcBB3zvccwZqlqm3G2CpT6qvI3YitS3MgrRZpkxCzWOg4MQMwol8z+yxkpBCuy/2N3R+77wYA+EYZXgHZzmtZDZmgcnh6aTxDtgeaY1eDY+9buKTom4dPNecvpGPoReyPaKLwHi8+gMRwRDDg3h431VEEpemKqtsuwaE/GUrk7JYv2jNM1cAtUEjBc2vjm
 ORblxDrJ
 Kp/ynBdVjazly0JConTVbSbNhRiQ51vHtlBNvsIhxl8hMhYDLv1LnxSQ1O0bdKAwepVab0/bR/iLFPL8FWXNpWtboUVnKg9OUm63Q8Hrx8eve59MlG6pY4U2h2OyoaDBwfCy8Jt/1iT6QGuCaJossOCN1ihNSMMPgkndEVcVI6TBVj6YNeI+por8xt2/PX1srafXh1TQ3Brb5hxJRho9sSfhhT8WCozTY6bpvTyqtz1nT/pJSxSK4M0j5/DAhnURbIN9B6kQfQ7hxJ6qQUMzct50uRT0i7h4b9NNH4EnDSKtD3IXK1eb5nt3wMj7cwBNtuAg5BWczbVNuAFW5/2JMZshZ6rvHbk4O8cQuQDQsLEa1+tPFVAsGvflgizXqiXOcbYU+632B6pKJiJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 09:26:53AM +0000, Wei Yang wrote:
> On Tue, Jun 23, 2026 at 12:22:15PM +0300, Mike Rapoport wrote:
> >
> >After I applied your patch, I did some checks to see why
> >mirrored_kernelcore causes us troubles. I found that unlike other variants
> >of kernelcore/movablecore settings, mirrored_kernelcore creates zone
> >overlap for no apparent reason. I did some git archaeology and I didn't
> >find a justification for making overlapping pages absent in ZONE_NORMAL.
> >
> >So I came up with this cleanup:
> >
> >https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kernelcore-mirror
> >
> >I'm waiting for the bots to chew on it before positing the patches.
> > 
> 
> Ah, just the same as I do :-).
 
I'm going to send my version with your co-developed-by if you don't mind.
 
> -- 
> Wei Yang
> Help you, Help me

-- 
Sincerely yours,
Mike.

