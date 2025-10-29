Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A32B1CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 22:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1EE8E0115; Wed, 29 Oct 2025 18:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91FB8E0106; Wed, 29 Oct 2025 18:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCF2D8E0115; Wed, 29 Oct 2025 18:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC73F8E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:57:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E5EDBB2C6
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:57:50 +0000 (UTC)
X-FDA: 84052665900.28.C2B25BD
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id E464610000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:57:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=i9xG7JtT;
	spf=pass (imf14.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761778668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGi8oB3x6eaPWyZqlAg1aSVhthOKt0dYgRp5suIsMiY=;
	b=PHx7ogyMOisYJwwVywIH8vbpl75uMkxg7IRXCdl8knvKv0fc850ppGzJRwaAjo6v5PiIx5
	PymN0GL9TAowBEliX8ACw6/3WkCIQn0L3XTAQNQBrZP/HjLe3A8r/JDy8VvxHQ3ohBTUuI
	L6Ucmy3hRGdpc1VkULNE7zP+DN+eedI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=i9xG7JtT;
	spf=pass (imf14.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761778668; a=rsa-sha256;
	cv=none;
	b=5m6T5CgPeCo1x4pt9PJ8YbGuVi2KcePhHVTtpWrgvuR0Qkou21Qt/RD4mdcosxVOcXjG0b
	JszIiblcvuqdxf5WfkdJQCziyTwjTCf5K0lj5ujQmQub2AP/s03FESwXCr4m7nQBvQS2ex
	BNpwd5ELSuJyrdeSZnkVnBZfxg9M9T8=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DD44C40E016E;
	Wed, 29 Oct 2025 22:57:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id CgoJpOv9t2OZ; Wed, 29 Oct 2025 22:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1761778660; bh=yGi8oB3x6eaPWyZqlAg1aSVhthOKt0dYgRp5suIsMiY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i9xG7JtTzTIMH+0L+VH1+dUYv2KyyT3avj/0+p9Xjsy7u2sY8njasttXNJ4JF/QvE
	 hXhQPge9pgGOyrlUNmd7EU2+NdfR8shMpCKkUr5gqDw0ixj99E8rFZZtMWAMe+w5EJ
	 Cx2Iq6hNXAGXYVq/do/gTO9vC5TBVigZhn0MLrGFgpwEVZeWmKftRgN3MSd07+HjeW
	 wDSLnT8cVeOdB5LyBAMtBqL3WiPLfGauv1BGSuyUoQrTSJWOjN0q4zHVtnfD59p6Nx
	 xfMln3auw9bY/TkJ7QqwpHm9aJHR4Lu5mrAFiwPASRj1rEe+VyWa8qr5PG7CRQgkGG
	 hN7jhsMHgvr53xpri79mCQOexdffhwsY88WeLoK7MvqvAsnOsoMVnqMpCkZKtTsFTE
	 8L7NqKweHjdVofADyvG7n3d4w33d/DVO+1XmupwbmE7f61CG09+wQ6FchHRlWdQaeN
	 3FoBeAjRevTuGgzYLXRoVukGgyXk/iSMvgsTPJpB33no+Y2hdoBZpozWRoUbGUdj7J
	 qCos2vcuz1p+UEPmczOFu/UrBXZnFATwfxV0yBxEmaSUQ+A1OzBQYp7+T17Z2NLNcP
	 osoR+pO/e1kDfjpu4dH/uTt8RJZm9yE+n21CIzuSQk2Ndrpo+uQa+DT9VN1LiOaa/7
	 naS3Mf9kob0taM78946kAS4Q=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id C120A40E0200;
	Wed, 29 Oct 2025 22:57:20 +0000 (UTC)
Date: Wed, 29 Oct 2025 23:57:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, david@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
	mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
	acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
	willy@infradead.org, raghavendra.kt@amd.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 5/7] x86/clear_page: Introduce clear_pages()
Message-ID: <20251029225714.GIaQKbytWNKuQC5TNu@fat_crate.local>
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-6-ankur.a.arora@oracle.com>
 <20251028135640.GBaQDLmHzCQDegBHd6@fat_crate.local>
 <874iriq2pw.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <874iriq2pw.fsf@oracle.com>
X-Rspamd-Queue-Id: E464610000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rfwdbkuxxqj93xxmsu1r3fqwpfdjg5q1
X-HE-Tag: 1761778667-320005
X-HE-Meta: U2FsdGVkX18SWuanAYB5sSoohn0Vb6W1ObFKlp5uu/cV4Ua7VfBgY4hoL4sfuLisqW/RNNl5dkdKmYqSFAfxTzLVq+tqKoBOHjQyq4NZltfgqgU2wTxTJbmrnUCASHv9YY80j0M0TrrdysBO4kCnZCiw1DT02Ige/2zi9xRjNEe2yZaAiUNiFQq52rdk6ViIevZrvzjr5gJ+WsKuNl2zKO82TMnz0XogzMHdC4vUV8x0hYEcLvi3bfUTyY/tbWDIbEa/iBf5pU2YIG8JKyVmHOfVHEG3l6aWYXDly7A9lywPdtjvPyfl3Khb8E3HpmjYs+2k8FTve9zJajB7oeIXXHhMHThEvWjvqwApeqsZ3qey5OGJ/8OQNqMq5GVmj8IXeXOWiT686Zxm75DhgvUmkTGJLwslUZSwDZTuV9OQGouKOJ/XpbjZv2XQJdxOLDVYnjnHkISDiqBwzrt7sTIXdJFM6cUnU83RQf6L1yIvzvSi9/MNLn1i7HS4mqBw8B3DJqmrxuy2vhMy1dwRF7GFWtfl7oiGO8DbjRBbTjo3JI7ZXE5wVLzFXfVgCT2mjYko9h2YAOeC2RbTHi/Zgzw7MVqrkHj98kKlsz/6+xs6p+EQuxj09ZPB3VOANbDfbbKf/cA5QU9d+m7fAbHb7wxc8MRZFSQJ+IjjxH8JmuCxPqDwEgStue48hbWlz67gD9lftg33Pj8QnjIw0xMFctC+hXklLOi3aBtrl+fB1qSco7faUIrURO3vYtScJeZzx/5XoFlo5tQ0p/7oQz69tzKhugWBhjTwZq0ztLHbThQ6zFCguTCf2/HZJeD3jQfNwUMxDd94lEiKDr+ximdyQMu2OiHu8R5EeSWhN8vabMrbZybjhoUPcllvchu+p57rlS3VpySnjLN804O3JkbBZJOLT909Po3XuIoybQL4EpRo7S1Dkyv8FP6PbOioiczq3VRX2JRWIWtRDmCq4/xoIQF
 m6J+PiyY
 l4oC5Fhc3k7LAAmFxKTOo6ddho0LEo2Ib2mVnPuqHCBLqxtmVZB2cjZmylHM45kPxmbnFRytcDmrJQ7DiY4r7OGJ8HizNwDov2abuL0LkX+8KjynW+Cvqpywyk9d6h5PNW6+ycRxTfyArpPeAPC+KcDirFn/6oJ1DzYb/GbsKTo6kkY7rvyUenpGQnTSyMTIQcLmBOsfYT+VZGobVgiy0NSZ/YRaHrHeIwBIt6EPWs+IwlE48gycaeDIJ4WNESDV45yBgAJy8siPC0s+n8E0zj8sKAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 11:51:39AM -0700, Ankur Arora wrote:
> The intent was to use a large enough value that enables uarchs which do
> 'REP; STOS' optimizations, but not too large so we end up with high
> preemption latency.

How is selecting that number tied to uarches which can do REP; STOSB? I assume
you mean REP; STOSB where microcode magic glue aggregates larger moves than
just u64 chunks but only under certain conditions and so on..., and not
REP_GOOD where the microcode doesn't have problems with REP prefixes...

> > Why isn't this thing determined dynamically during boot or so, instead of
> > hardcoding it this way and then having to change it again later when bandwidth
> > increases?
> 
> I thought of doing that but given that the precise value doesn't matter
> very much (and there's enough slack in it in either direction) it seemed
> unnecessary to do at this point.
> 
> Also, I'm not sure that a boot determined value would really help given
> that the 'REP; STOS' bandwidth could be high or low based on how
> saturated the bus is.
> 
> Clearly some of this detail should have been in my commit message.

So you want to have, say, 8MB of contiguous range - if possible - and let the
CPU do larger clears. And it depends on the scheduling model. And it depends
on what the CPU can do wrt length aggregation. Close?

Well, I would like, please, for this to be properly documented why it was
selected this way and what *all* the aspects were to select it this way so
that we can know why it is there and we can change it in the future if
needed.

It is very hard to do so if the reasoning behind it has disappeared in the
bowels of lkml...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

