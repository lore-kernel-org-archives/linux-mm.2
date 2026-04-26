Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680E5FF885E
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 18:09:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A550B6B0005; Sun, 26 Apr 2026 14:09:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05EA6B008A; Sun, 26 Apr 2026 14:09:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C9F6B008C; Sun, 26 Apr 2026 14:09:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80A136B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 14:09:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4108B1A05E3
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 18:09:36 +0000 (UTC)
X-FDA: 84701494752.19.D2E452B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9FE15160003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 18:09:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Tn4vwNXp;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777226974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOUZuQ6J3rTUnMuPgtIuSHkCb0xhY9B2E8f6gvjXE/c=;
	b=Dr4X+W+5DFmx7wYIHnoe3bTYU2nAiWfgYYLcGKHgDM/nLb8eZ7YfNZlwXfgBFBRHj/l7B9
	opK/cpsPIixgM04ehNOloN2sAmy9X2Ofutk/NGTC4C4rswmPuVU7OKrhGPsNtsQqMjsKaE
	FiCIwNNW5DhWrJ6I0r8PBRJMgmPxqtI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Tn4vwNXp;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777226974; a=rsa-sha256;
	cv=none;
	b=rIByE4jP70kUFpgsu1xGaopi8bQ2AwhRuLjte29BCV1bJfBN18y5TIGNZ2ecB+mgxI8dFM
	FFHGbFd9AAYQ8farxsAiranOSDW+fIEHhG+cih3jlWeH15+OVibA3GqhZgktMWtPzQAtLi
	02c3h+R+p0y4tN/78iCX4dZQnNMGTvg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0444860138;
	Sun, 26 Apr 2026 18:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B166C2BCAF;
	Sun, 26 Apr 2026 18:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777226973;
	bh=ZpzvuAjjvIqcno01hmVZJsBQLvD+qtDCobiUZNIrpSQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Tn4vwNXpXD0czdD18/NTmJwunL37zosOs1UH00Ocy/KcnK6WpNia9rEGNrj6CVJ6W
	 hsgZCqfvMkxKSCsmMvW3VZxR94qfHIq23TChYDruXUMgDp+bYVR/ns5NZRUd9PR51G
	 y+3BTn1ZyXU+EKfrzHOH3BGHeFOHPE3Y4Mp/pBME=
Date: Sun, 26 Apr 2026 11:09:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Min-Hsun Chang <chmh0624@gmail.com>, arnd@arndb.de, msalter@redhat.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: replace ________addr with
 __UNIQUE_ID(addr)
Message-Id: <20260426110932.786047b4338843e0a91abaa9@linux-foundation.org>
In-Reply-To: <20260426183420.2216d187@pumpkin>
References: <20260307092119.20733-1-chmh0624@gmail.com>
	<20260322144032.7353997c@pumpkin>
	<20260425135737.e79c4b546d22b5ebfd96c0b5@linux-foundation.org>
	<20260425230134.5449498a@pumpkin>
	<20260425151240.2a46e3a8640fde3902461d41@linux-foundation.org>
	<20260426114938.4dff28c8@pumpkin>
	<20260426040925.b25cb2a32680bfe884431abf@linux-foundation.org>
	<20260426183420.2216d187@pumpkin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9FE15160003
X-Stat-Signature: utnmyioweypgqcrnciuw564ynoskot6f
X-HE-Tag: 1777226974-263577
X-HE-Meta: U2FsdGVkX1+/ij04vf+9+8QmNTeGdKFsxi60h+ARDaQ5Wo+Pd/IrxoEZtXvfN7dBc2QO/VqYBlZqkzLpAyY4b4xZISdphCYYuGV0GnfXOa6mN3JyOHGHJZy4Gm+X+IFJu3pb31A86Oo8WrEbAcSTtHrJ1SSZoCISl4rAp7nIXmR3Jnm0BiG3aN6kvmKJgE+PdY/vVo7Ym/2z6nTiE9jRavppeagbzcap3YPNmbpqL0rjv+zS39Ch1J7JuTSJZEl/W7b3oMzuFuigrEWLdxJtIe/Ucv4UUoAxDRu7QRoqgSKXfpxG3fVeicVwwKSv2TJJLR/4CjbObesXpI7caNfDgWTwLGQ7kRcAo7zIYeOL5GPKwaSjt6buNRTLf0LJyx60C1cyyqKVquqPFqBOVIBmrS/0DclQ9bj2n5rLwCXjHsjurHB7Kr6+rcnvt8nsfRY4oh1fhITVA98b3cfMNwoD56ce2SPzmdDOe5eZIKf0IJE8pZCLkQSQfqSOXqbrLDMJ9QoBMfULr3PDs15QPFSVWmuzO0Y/avOeJXC9rZ/G0u1tLjINyTKUks63GzFeK63h4dG1F5Mvu60x3K1Ao8SgezhZTR3Hn3TrluqNY8yPGmFZU2Pv9CV2VcXFASQZn/gZHlvY7Z3Ay5/MIjoMCWP+/LF113lGiTNrmEQOJd9bBgd1DPiAYCqkkYj0oX0vWOxL5+C5UspwVftU3YV0QKPPEqfYVI7ifJlZAQI9/RPGqTxWC/RYqoW0VtH0u8WMdDH802oId4bCwQFdmvW1yNfZ4vVTMcWiBWnC1r74Cr/53roAHXY1JSgNOWp8oWAdiZjiSv/GP+MYecfRZC20QGvzKl0rtq2SCqfGQugF7z788DeVEOsdFohgHIeK5t6CE4Rqw60/7z+eMMNjyJvgORDp2wNUu8hKyn3ikUdr2kA9IsHWH9y5uehrzUGRk6u0jK/Z0L0/pocpzVimE7zMsA3
 3CK/Vp0L
 B0NRjO3GptngGarYmuXWF7EQho5RMi6pdPcRbXR/4dP+rktkzeFbYk9k0PS5Hiu48fJFvlGyBH8uVM1zDSlw4qa2ginzT/0X4d6nD8T23Mro9HCkOBmoj77qjCNGd1PlFMN3y4n3ps7I3+YJvlhwzPe4ePpXa7ET+TwSGq1LAdKcklohBDNQwTsTJu7VAjphdExbtJT/ivRlIzbmYV3mhgQdTLK8J3ZMWJk2RXUYYfOMeucjjxLNfma0CfX7qww2ftdae/GM3QX6VdIB+BI0qVPeCpAC6UrgpUd8KZL5x1lfbYqw5LxJyBZRE9knrjn95W8Vo7MmyMAp88leTlZhjT0WnZ8oetvFyhh0Egooun7a1Lnx0kikiT9vQv4DwofXu/z6HfgjNXt/eqzWL0/27oHnJekkxHhXFCHPi5er7fnsBcaP/b9SZV0xbdiBse5YCRt3s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 18:34:20 +0100 David Laight <david.laight.linux@gmail.com> wrote:

> > > True - don't look at what strlcpy() can generate.
> > > The inline code should just get the constants from the compiler and
> > > then call the appropriate function.  
> > 
> > I can't actually find an in-kernel strlcpy()?
> 
> That is because I meant strscpy() :-)
> 
> In particular https://elixir.bootlin.com/linux/v7.0/source/include/linux/fortify-string.h#L275
> Particularly once it gets as far as calling strnlen().

Oh geeze, why did we do that.  This is the kernel - string functions
aren't fastpath!  Someone please move all that gunk into lib/string.c!

We'll still need some macro if we are to retain the (imo silly)
omit-arg3-if-its-an-array trick.  


