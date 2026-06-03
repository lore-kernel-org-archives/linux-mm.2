Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C25EFCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 16:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD2B6B00B5; Wed,  3 Jun 2026 12:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6DC16B00BA; Wed,  3 Jun 2026 12:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C766B00BB; Wed,  3 Jun 2026 12:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1AE86B00B5
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:20:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B8411203F8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:20:22 +0000 (UTC)
X-FDA: 84839113884.16.14CEF14
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf25.hostedemail.com (Postfix) with ESMTP id E0136A0006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:20:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=GisXoFoe;
	spf=pass (imf25.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780503620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQF5anc3clInAXcjBfKS1egNzzHrFhfRAKh+Hd0L9uo=;
	b=GgfGdaHi6g1LiZYkDcbdhDF0sqiuoP04gy7709uQ6tYEqrF4uIiGlpMM0y3hUhVgjnAdzd
	GZpVfk/AXqi/z5kF/5kjOM+x5hjv5JET04hYp1mtB1OpaCWXk3R1CiCuLHtqPtRMrBwcCR
	r2GN7RhnuxOE0BFz0tM2caNS+WATAgo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=GisXoFoe;
	spf=pass (imf25.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780503620;
	b=LiNylUNcUehPGcTR8SbbwNVKCe9LVWzqI0UwA/Z5/XDdMmqW/YcejKZKgKdhceFwq4fV1j
	w3TSd71jv3MPVPM9v4hzjjUlHpVtWLSCpINE23qKtB2nxO8i91ed5eWNtrV/E4i66puYWF
	fKml0E5xpCxa7nV0sAex3OugCOY9jh0=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BD55540E00B8;
	Wed,  3 Jun 2026 16:20:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id fgZAnMZvIDEE; Wed,  3 Jun 2026 16:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1780503605; bh=KQF5anc3clInAXcjBfKS1egNzzHrFhfRAKh+Hd0L9uo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GisXoFoetprH2QNiza4ohZ5H5fYeZ9K6vD6/cFL6IzfaZaNrK/Vo43IkUWAhbwf6+
	 77oeu3mqF8w6d7Z535vvPvr8t2ixE3MrIbXilf5CnkP4RXvGqk2ZUr9Z8QU96HTyf/
	 Dmq1iHKmmA1OskVhADdGIj6/PDxBxqjZRssbaRcdMQ9GA6NJZLUAFAXQA9UeKNcg6w
	 MKlAiVQ3i57S/StJRLYwloNvirlJIO3/Ng5Yh+phGb3RWCXYWHQl7mykvge+FJKS2Y
	 CYM1GiCzPgf4Hq7E3OsgqjOcq+KtU6GKyT7TNGkFVIO02o2aj0efXaltN8eAflP/rG
	 YeCO76N1GeyAkpZN3OfexfyRL0fGhxjQmEVtCoa5i14tGYB5iMYfsLtwvmRtqGYIV1
	 GjtDbP50cI0UfAtcRiIzu4r8ffvk2OdRibREg1edMqEWA6dGZc0A0qi3u9SmtEzSeu
	 uJb2qzuKbbh32Xct76RUGJtBm5Tkbg8l8r3GSsl9tGIfJoi/o+621202vZJTAIGw9w
	 ZRvHZBL1gCDdtGkIfImM/27lLzWJ0+hEScKxivs8px7laLlIwy2jNEpdOX0OZrj4UA
	 TgLftwLm80mKZFU8RhUtJRnW4KnZtqayhk/JttXGfPnRJBOhWeDIUD63tiWYDyF9Z1
	 f2FdWuAToTow5Q5k9cOKUoyc=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A7F4E40E0031;
	Wed,  3 Jun 2026 16:19:50 +0000 (UTC)
Date: Wed, 3 Jun 2026 09:19:47 -0700
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
	"mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
	"Luck, Tony" <tony.luck@intel.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"xieyuanbin1@huawei.com" <xieyuanbin1@huawei.com>,
	"Lai, Yi1" <yi1.lai@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
Message-ID: <20260603161947.GBaiBUI7C8WWPwD84S@fat_crate.local>
References: <CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com>
 <b930678d-a1ae-458c-8705-7ca9680d4cb6@kernel.org>
 <20260603121707.7eccb9fb@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260603121707.7eccb9fb@gandalf.local.home>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E0136A0006
X-Stat-Signature: o7g1e4q3k74g9tjayxzfcikze7ic4mht
X-Rspam-User: 
X-HE-Tag: 1780503619-106427
X-HE-Meta: U2FsdGVkX1+STy3XlYIGUppKrnpTeY0raOpVsamy9HLCDiLF0SBWtT7Xuh1KL4EU1+FcFDNCEwKOEUCBN2KJgz9OX/lfcaa2+vtur8BPnAyDOQspYcdzgGhh0pJoIhIBnEiN57W933xFv3LHiUlFZGqMrnlU83mWzI8c2PLG/uL7D8EFjJGFJVrqd6qOtgEhh6gVwBmEaz7pHofm67CqIJ0L5OweALmgejXWa9fK1Y9jh/gPjMwpUHEbLXn2TAYxW81dd9Wx7fvdVSDRUEPJ+oowBQmKyvsG2IHVrFfEV0qqQvroPLKthDs9Ntzi1PAxEsJ8yh6eS6pKGtiN/CLI3qRXY5YumTTGOM+H8unbkX+C9yCzq70kuLXUbDGlT3xPaOy0EFjCnxtKa9YdJqcnxQ1UJFoq/oc4aQRegeHHHoor9hVQFZJrhSsVFB45AH538b4L2+vxB/lqP2/njp1YWamrzaNv/Bzfj0TrpydrnVQm3bzXANieW1P5jWhvAv7DY4i+nvjfJx5B6jvcU+r33XGEcayddsj7MaXyhPhZB9uqsJwpR44UR/C5s25IeyQJBgt+RdO32STnnTbXOmo1gqMqH+I8ipiVX4sgp70Fotpdw4bXBjK70F/IIaTm5m9p+/vYp8TpwFCBuu/2d/f3Nd3C1omglY7vrlfCpH/1QTSDHKjK0Oom3D2/BvaSav16FraGO5n46MQaMFzihOUppbODoEAUlmVcXA8V6f9WAytJIi4x+Nwn2trAJ0SnGIcu4WQfjLzHk1tKf5vmlT6jA2vB3X0NQUF64xNVElDS523SYut78G+XQQxOmKIxcxo1iBeSMtBkmGlVVJdJWlwLHwAfo2hlc1TcPjRxHRj9+g4e5ghPfwvnxbnBHC6sOgjO7+/+m59Eqeo2mUuit/JsVNFNNJQ/2O03pgIIMOuwmX6IVZvmB0ttfF73Rwm6Q2Jppvq/kgeFDndvrCdKDq1
 Xoc0iSGz
 WwgGMMdIn4Uzzu+jchII8dZ8Lc7ZqLKwHHlH/o9sx7SUYKlrTSFsrq2F+6fZToC9Yb+oD6IQxtC5OfaI9UCxfGxYbJaznG/BinGv+ORuUMLC/sCKvlSXY036C0yaQdvI5Z6JPKGHvpcn/UZVPN1ifVxK3s4lStb3ny4Rqkx4z591zAdVgYMqLRjYY33psIfYe4/CgTTuO1BXMDpKnZaLQ3fKmtRZw0gcUP2Ikfo7yeo+H+NmxsapA0JdXepGIqFppjGXsEsfTzTW4hpBknq7vEH/cMKR0k3PjDPiFg+kUcF5d9wfQDpjSeeWPtqG5sqTf7TC6vegktMI8mcpyZ6/ldDfvJ8TyR28Cyainiq0qWWROyj39ZsgvSxiHz7ycdxHTuj1Hz1rmccdB/ZTdl5V1eO+aurGCp4YvK72PUKZElyHDMUhrppEfwkEUBvTjpXXY1JocpaFGyIe8njn6t4B7b+HXQZpR9PizNRyKjq0aMsol0eF6F7sgcryQtiYnWaxtRE5wV2OGRZ+X8ckYEDLd0RADa9SSaBC/l562nZ3P7kWshG7uiOBym1fPHJuY99miURWZ+DXxEGlgjHKULAZBY/2hOh8oypPDCzBFl7IBMAzW/Xk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 12:17:07PM -0400, Steven Rostedt wrote:
> On Wed, 3 Jun 2026 15:44:54 +0200
> "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
> > Likely the latter. BPF [1] documents:
> > 
> > Q: Are tracepoints part of the stable ABI?
> > A: NO. Tracepoints are tied to internal implementation details hence they are
> > subject to change and can break with newer kernels. BPF programs need to change
> > accordingly when this happens.
> > 
> > The Kernel ABI document explicitly doesn't list them AFAIKS.
> > 
> > There were previous discussions on the stability of tracepints [2], I don't know
> > what changed in the meantime. CCing Steve
> > 
> > [1] https://www.kernel.org/doc/html/latest/bpf/bpf_design_QA.html
> > [2] https://lwn.net/Articles/747256/
> > [3] https://www.kernel.org/doc/html/latest/admin-guide/abi.html
> 
> Tracepoints are not stable or BPF programs only. But other applications
> they are[1].
> 
> Adding Linus as he's the Supreme Judge on the matter.

I *think* tools or libtraceevent can't really anticipate the TP namespace
change so we might have to revert, I'm afraid...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

