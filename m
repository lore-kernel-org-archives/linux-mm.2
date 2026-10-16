Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F64ECCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823616B00A1; Thu, 15 Oct 2026 23:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4286B00A2; Thu, 15 Oct 2026 23:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C30F6B00A3; Thu, 15 Oct 2026 23:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 496F46B00A1
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:13:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C45AF402C6
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:13:10 +0000 (UTC)
X-FDA: 85327018140.26.1E7DCAE
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8F62C1C0005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:13:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=kB8VpIqd;
	spf=pass (imf20.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792120389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j1zejq32/tNyzbLvGPeykcuEeIhlm8wIUYy4N4oErp8=;
	b=yP790hClkdOMOZqZZiji7IEkyCFS5NbB/n9bTCS1hYcKCqCBWvTlq8UaVx1k/gU5lKu9hS
	XbXA7y1MLO0WSu4uW/Hbc8Zggf54Uuy/OFLCDzHyIIGvBdbeAB5e0J/irBJK+I7GC42tDc
	AVO5lVLWVGRyraAzPfr9mYvzg1Jpbos=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792120389;
	b=k8DwqOZRjDJKd7AAiC7UsSe1fm2cEzh5gYjL2Po98VJipNKAK68e3LbG7H6y91I5rcm17K
	KMSMcyWHwmBM+19+Lu4mnZNxta7B1HT+oLSBfP0djsOROUDRJizq+wlIkWqsIMmy/NNnvX
	zLDtVXASlEg0QIO5CHdRhsig9craWC0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=kB8VpIqd;
	spf=pass (imf20.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1B4D840E00E5;
	Fri, 16 Oct 2026 03:13:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id mBnfSpkapakG; Fri, 16 Oct 2026 03:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1792120383; bh=j1zejq32/tNyzbLvGPeykcuEeIhlm8wIUYy4N4oErp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kB8VpIqdOiSX5ndcGB5+uU2Je2QVle5SGwgxBhwgniqNp9KofZz18qF4uDV4wnO+T
	 pCyhS8I+l/+1AOywZQDj3LtXIivTBSsM3EC53sEhbEnGH798zR4FFpU8hCrlz9qMVW
	 HcfkeKAnWl646osI6j9i3arBLszg8R9ZwM7Yv28dOn8y8Hf4m+YkqFWRhgH0u+lw4s
	 SfeIs4BdY6IEbtkJwhJze6bp4AzmLAEifPX1qCLM2iCEdCrZ2u78Qjznjqgil7MJr9
	 5FstuCvxUuc97mEZYep78dkzCxhKIKNtV9rONqXGx6HNP3w5tklqxbaRD2n+RKJlVU
	 6bISq/NbxwTeypI5eOHDEfPv1or030WfDf1ly9eeehXfY9IER4cnSTwmGcHkzDJ+T1
	 4V2xcf6XRCKfLFIQYsR35IOR02kgE+oQiVJmDgPAIO+HVqgLEGgLZ+iNTT3QC7GumZ
	 DVIvweDQ4uR5roSmA9bF9CroTe4Vw3rHt8waFgu+quLoWzueRK2uNi23M4k1DDFaa/
	 FRGq2WXcia0qwHHeDKG0OjRYavT3/OdnZ4l8TVYRLqyUmFC3OEEPv7sfLs0esSMNaI
	 6cRCHNI5GqjB2EDehxXN65fJ1Wv0gTObeMDfdV3KTcewuUuaQpELmCkVTQ4sTqHBd0
	 BOzgUgp7AVq/i9IMKc6+sXjM=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6130B40E0497;
	Fri, 16 Oct 2026 03:12:46 +0000 (UTC)
Date: Thu, 15 Oct 2026 20:12:42 -0700
From: Borislav Petkov <bp@alien8.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	David Laight <david.laight.linux@gmail.com>,
	Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, david@kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
	luizcap@redhat.com, pbonzini@redhat.com,
	Tal Zussman <tz2294@columbia.edu>,
	Matt Fleming <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local>
References: <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
 <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
 <20261005132113.43548696@pumpkin>
 <asP5xK4axiUk7jun@pcnci.linuxbox.cz>
 <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
 <20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
 <20261009090042.39ba9c06@pumpkin>
 <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
 <20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
 <20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8F62C1C0005
X-Rspam-User: 
X-Stat-Signature: 881q9zgy18u3gkwpcpasjs837kuifoxi
X-HE-Tag: 1792120388-150959
X-HE-Meta: U2FsdGVkX18TTvx+RckhB3l+47ldiDT05SJH7RlrYciFFBH6IWe6WqqC0YQeSbuZV9PSatRdGHkkvJSAdN4obACJqrmjgQdL+X8U4iw++QRzge7y8zKyLL1UgtQjza7wYO0MU8Ii3+56RBQRjaFLF+fZs//ROQRarG8O8oxTyPjNsDswR9BRK4Bp6TKeYbzabyqO7VaKLwUjeHBZS5dcybujkDXMlKsLTbPFx2Tdn7tDUNl+sgc2BiSzLbyaWhbykKsknosxLgmnhkggZNDcxxQ/kIcyBO9lTpn6a/wCx5d6Dtyj6lzlGny4eBO02JMDWo9N9ffNTRIbG/X+Quu1uuTH4EcmjtL7MxJ38pnU7atwVwrVh6uwPckz/lLKPiIyWodk3OpbzsrzJZtOGeYk5EpQNe34QEsIQvKrXXuPLIhezO9NXyIilY1EV0Fc5Q71r1QNqyWEJS27QKn5XDqQDhQZo2tjEyjfPk2qC+w4KoxBniMQEhqJ3DMQP+mFyFBBtQRFTbGtFAU2XaNOCqvnI96qw4es1DdQJ3XXMaOTuMH0SqlFlzauR21B+Op/CkeYIUPuZeadQj4B620D70WPaOUNT2ejUcGE2zO4B2yCjSDkaBjlzDCSXJ7S/pLvEthM/5k6KSAhFo+rfu8P8sZGRYhY5jVPRxO3K02qKrYfwRuDQGg3UPuV1jXZcObSUCtktSjdQVm7qI3AoZUlBtp1mSs3cCyHkQxN17yNEpKEc/C0hqFPNiWNcx3ZSbi8fuvUkUxC3yS1QwqJcfdwPTGsKhXSpyu/INAXWtdmbwhRCg72UQXzO9urFguMF2/qKpbdZqUvohzJeP9EgYig7TjYdw5HICgt7FWAh3ITDvPrfBSgdt0yWv3ZmqpxXbFN9Nzz3Zxh3s/kBknZd18FGyGuTPtQ9CF9IAK4ZXQoBGW/bXbb5iXqHLQmbFZKFs7nWUmVcCS6Os4DKQkMiUfkLyj
 ql1z1B6t
 P7bXXx/zezLOhFxxY37chKuzUKGKDUUiRe/mDZHPtPOAQ45P4uUiDOor+ML/0JEkw5TjePDpxeulnAbgDB/FEEC8UKwqhnSNLEokMWHKPjLHGswRb9Y5OnAdGUsyF+WGumXovD5GX5btAfHfrrz/Xxq/5R2dyM9xlbw1Vez4cAbUH7RNVv+Bpw+FFi6UWFr+Z2HCkYaTABV7KJLb2aynr9fX3bo3eX3L6K8M0lzRScGEC6oS4Ub+YCj+DWI6HVyJ+chFyG90/II1SGHCmGiAiaQHFSiUwb4FMP06LBLf/bdTNg8P2x9ZBNOH+DQZ757D3aWulVQMczKJ25hUn7r8S7BvOlNPYFlyiQyr8qPChBkwO5P4+yxsE8vCWKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 05:28:20PM -0700, Andrew Morton wrote:
> fwiw, I fed a lot of tokens into $LLM and it suggests that 55780d8a1dcc
> fixed this.
> 
> If that sounds sane then testing 55780d8a1dcc on that 6.18.x kernel
> would be useful.

Hmm, dunno if that LLM sent you into the weeds. Because I ain't no virt guy
but if vmcb01 and vmcb02 and "L2" in that commit message refer to nested virt,
I don't think any of those crash dumps do nested virtualization.

But hey, what do I know... :)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

