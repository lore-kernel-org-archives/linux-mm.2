Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C695FC98327
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 14:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2A816B0005; Sat, 17 Jan 2026 09:00:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8376B0088; Sat, 17 Jan 2026 09:00:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8F9B6B0089; Sat, 17 Jan 2026 09:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C62056B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 09:00:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B1BB1403B8
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 14:00:28 +0000 (UTC)
X-FDA: 84341615736.04.9E03AF8
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2DE0C40011
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 14:00:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=harz6MbU;
	spf=pass (imf11.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768658426; a=rsa-sha256;
	cv=none;
	b=45hJ2NP/EWc2iPtXBYQfJ5h4La8ioMwfXkFOCQzDZBUEknRPRzGFRawU4swHrFbJ+p96ie
	H9GRt3lPY/3XvTxupUEmBJ1hUQs1BHHFOAuFrhoVGIIH8JOWetXBJ29OeatF9AXcdLXrWZ
	YfIf+t5F2WUxL+1e4GzP3fm7iiXZ7fs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=harz6MbU;
	spf=pass (imf11.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768658426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsJhzSv+BLOqNKc20ETcfR3RCpxEZPWqckGeyhc9dbE=;
	b=mpxx/tNI/H6SZeaExS9Jg/8DutIS/cxiwu+xZU2kX2SzhxTLx/x9sRk+53nrb+4ZYo6auC
	CxPMgZTIPv01f+wU7mKiByGY7PC/maWgFo9pUevJEkqrihErpPfLPmE4WWRp10D1eHHFfj
	A3Z5ddR9L35+3/8WE0dJvybtCRVkTXQ=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-501c6665144so31365561cf.0
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 06:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768658425; x=1769263225; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JsJhzSv+BLOqNKc20ETcfR3RCpxEZPWqckGeyhc9dbE=;
        b=harz6MbUitKHAnmmzDWAUjPhThyxPgSAOS/wOUCnzfjEMnTCmTvb5fmg0UZS+y5624
         lm4gjgODQTsw67OVld0hMMY5FhbK/IlR+UKtiB4l/QJmPr6E7+UMEjMXJNEoZi+J0JWA
         Y3wBY2nh6L/7axF8JkL6+LZkVH8P0wgxzY12XZuRLIHz/Fhbkorwn/ThV2NoNG8pTpD/
         GuxokmYNUmr+nBXdSZkIBLl1gfh5V5e8aujO+1WYGYj/nGYb0muxy9gC8LzjZYb/ZpTm
         q/2jIx1X/v0bt4z6q6OpHFWdHsWK8jk3b1zIAfjpsbxbq9+5UBZMB3PwEbhkqMGV5ZaZ
         l+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768658425; x=1769263225;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JsJhzSv+BLOqNKc20ETcfR3RCpxEZPWqckGeyhc9dbE=;
        b=Pc0GEF7C21+JaKToVw4t7Qoc4S/xo2ZR20CWgZUpz+zbBJuOXEbmZ/tSiWMrdyMJ+u
         IxK6kc7jukKqV8vQM2JekGO4P1mdR80v9VfOYSTM/G+f8nBppLMUxcR8I7i0ikipc74Z
         jEok9znZsnZFZJWbIOY3E4L75CUh0jCogt7a71u19ewZpJ5KrNCWp2IHfWaaEwiLucb+
         rTtjfF/mKXFUNY9z8auVx2jkfILq6GUmhq12frbh04kg32TQ6gYCNulFhDqAjk17sb54
         S8QRKECA76X5fer4pfxIm8Z3U06+5kpMfz5RxZx2rBxAH3rePTQFdA+4oBjM//qX7sIq
         zgiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUATgsECAUXKoMQk4ERWXZT81b7stN0MRCrN0SAVZ4W864mwqVgYFuSuUZDMqA0muWhU9dFjb7dig==@kvack.org
X-Gm-Message-State: AOJu0YyeORyezYeC1+/LcjV6fEctlhYl83Npk9F4YFE7F0q9QAg1nlKl
	zt+UC8gVKJ68xX3UqsG8RACRgm079wesOaBEs9r2ckTqCz2Q5CT2h/oH
X-Gm-Gg: AY/fxX4+Gg7Qh5QHeTOASwOcI5E2b4CZfyNt/gMUrisxj2pNg0GE1v0Z5adN5m0pZIN
	+TthWq8moqawls8L+ajhR3xMlfdm9+gsJxf5VjSIcNANHs+HcoBysPUpVT6OhflMFFBCVCuChCh
	cidEvxL6SiJeNv7xxy/V22gQCOw2LFYnZpYVb8TuvII/dWR2AGcYMyfygN00rP5I4LDTVvZBoqY
	/p39k/FhvtjK/X7m3ai/J/BYb9POG9wB2oNAxUt934M510zvaowGj0AFO5rnu8HJgVAvAKQwhl7
	fguQ3TkT3cWvwLYkoNLYL27Ot9M5hUk4oCBNmccAEve1tNovFEVfvQhTVEkMTTz33rmeEIkwXyd
	o+pqoTQnvzB6VcM8MCxbD3DAQdwiIPOQwLGgGOMgPuyMiD2/pLngiJ7B1QKyzbK9b8PCQF3cOQ/
	yJ3NM3Q3kd6+3bAYozGVmX8ip/EzEWjZQyjgorOn41JEU0W36RGA8/vZL5HqwjvkWoNGN6qJDKe
	4UUXuIe5ydgxOg=
X-Received: by 2002:ac8:5d13:0:b0:4ff:b211:6aa6 with SMTP id d75a77b69052e-502a1e08f85mr93551061cf.27.1768658424583;
        Sat, 17 Jan 2026 06:00:24 -0800 (PST)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-502a1ef9847sm44608071cf.26.2026.01.17.06.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 06:00:24 -0800 (PST)
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id 52A8AF4006E;
	Sat, 17 Jan 2026 09:00:22 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Sat, 17 Jan 2026 09:00:22 -0500
X-ME-Sender: <xms:9pVraQsV5oJN1rQdTdjBt-ExxigFukmdJ31P10iGGqgxfmxu05yEyw>
    <xme:9pVradVW5YP28Iir6vzjqg72HTtziJi7555HGmcQDNvzW9LFoPYdIfoKwsF8l3VeQ
    7WmYDvEfEHnliozpt5D0tTSI1BpuvXTTRATDr3AcXu6rilfGtssOg>
X-ME-Received: <xmr:9pVraZFd3U12EFPEMOGATk-3r_O4bQkXgLbIIzbMHfv5cv-bTnlE6Sju>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufedvtddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtth
    gvrhhnpefhiedtieekleduledtgfelvdejffdvjeevvdefjedugeegffekjeeiiefhieff
    veenucffohhmrghinhepthigthdrhihouhenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshho
    nhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngh
    eppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthhtohepvdei
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrlhhitggvrhihhhhlsehgohhogh
    hlvgdrtghomhdprhgtphhtthhopehprghulhhmtghksehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtoh
    epghgrrhihsehgrghrhihguhhordhnvghtpdhrtghpthhtohepohhjvggurgeskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepsghjohhrnhefpghghhesphhrohhtohhnmhgrihhlrd
    gtohhmpdhrtghpthhtoheplhhoshhsihhnsehkvghrnhgvlhdrohhrghdprhgtphhtthho
    pegrrdhhihhnuggsohhrgheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepthhmghhroh
    hsshesuhhmihgthhdrvgguuh
X-ME-Proxy: <xmx:9pVrafbTrfB068wBICe6Z8_1eu8RFdQbAF25tJ3s1Mhw3VJ-bSBxwQ>
    <xmx:9pVraeEYwpc-LLQRA86eWvNyQfKaNal5nV10_JxIpbMIQTo8-SQC-w>
    <xmx:9pVracwDRWB3ltXhAmiG89ng2m26pSJQAp53i3eqhdnDpqUL7Nn1Gw>
    <xmx:9pVraYGhLIU7S3ilSOqwWQwLErk7XMKY5amXHWL384_LETHULZYH-A>
    <xmx:9pVraZtCS_j9nz0_k3kR_mLxt3pWq345KBB8CG4oxjnLPJ6Wm4NM-tsR>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 17 Jan 2026 09:00:21 -0500 (EST)
Date: Sat, 17 Jan 2026 22:00:19 +0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Andrew Ballance <andrewjballance@gmail.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	rcu@vger.kernel.org, maple-tree@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC 0/2] rcu box container for Rust + maple tree load_rcu
Message-ID: <aWuV858wU3MeYeaX@tardis-2.local>
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
 <aWrSkAPFkdH_tvtN@tardis-2.local>
 <aWt4muGXbe7lBmXt@google.com>
 <aWt8Ze-otTkexNIe@tardis-2.local>
 <aWuKqLERqpNz9qtz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWuKqLERqpNz9qtz@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2DE0C40011
X-Stat-Signature: z31xh6d3kfasjt5h3jz8jmizceoge9wq
X-Rspam-User: 
X-HE-Tag: 1768658425-418380
X-HE-Meta: U2FsdGVkX18fLjLAO+qdqER6k/DHcl+qtZa0sTBiitCdsogPOGvI2/wz4bezea62wAkgoXKwgyBLbeXN5QGVOegKuJrJ8Oy7IJq0lcyWaxpZ8Gj3I5/vophNaiQVlEnO0FIEfxruk93BstNSVG1+DBF+sibTkFhqBgEkwAgDW5IdI8zz8svDh8YfqIwbx/rB+t/DGDiIimgYvevvD1tZVn4lEkt/GmGpE3dll4pYnYKAna9dof8krrB8rrpZN6Sy3qsPT31C+YYxFcn0WYlOYDxVDG72npDoMX+Pkv9Cpk66pT0/vLKB2D90slFamY8g3gEfpcFSBu7pLacXTDZUkeyNrHhfC11D30hzTuJhamoXK3pefCKXft2DnTiJSegm8xt/Thl8REr8Ia2EHkkO0zH9azAI3WMicNz87PKlSV24Wm4NP8FUO2wo4SvtNLVect3XbEM+fBJcyhmSTmwoNWUawxoA8VGicQUCRVaYLe3Ig4uBgehG0GxHtiwVJ85MIbL+TJdUgvKAsu/nN7kktA0P35phZd09bSq/SPGGsQsoQE4UThb+sXt+DflXyTonnr6TjopNhsSp6Xz9srmpguJjXEFyz5wRuh9W4Ys4Th/adIK4lsjZWORk5FBXh3Tywz7NGlosC2Duw7IgNxCfKUWIfTax0R/rv4zsa44ZnH94XrSCHuH8fARtwL/zM3tU5wp0qbLvb4Ao/hP1i3D38aE/bh/QUGz+hGJcDZTpTIjykneKC61xFynBBEYZRlz3X6Arcr6KkC3fxOh2dbkjlHnr7aCyIXnBVcqrwoSlcPbYqppwbZqYXSPjcU5cqHpAtmwY4g2f5/TPEi1DvdHkr4kejZzEN7qoFez89KLH8fbYHLKXM7epnXlNyVwFpzit1KiWNKh/52SbwPAv0d1t7/wyHuy8nA5HU2UMOMkUk+tEIZI9q52AmLAN56u3uMg/u1JfYnpEopn9aAshdNg
 sJPvOceJ
 bLM3fCRAQ07r1bmyHnJ98AW/lZzWkIV4CC3fuHaePMXz5y2nHg59QYVtXjXZ8ybjmTab0IiXf63cNFji1J0hO4+hzLqUHFY5R+Xhr/ltUwCXD5QX1aKlcgQN8642PZTLoVMdZny33s2Mzj8hKAq8mM8EhnmrdJUKyme1pc4e5nMZasBYQjCMt+GGDloQlhw+DXqLq48SqdnoUQulYBDWBnnxVA53OhZUUH/hXByOUkh6FENqvoLzbMGufbUYYP5w6uY51QT4Oi2G5N54Umw9OEu+pLO+3N2jlbQgcLdxDrmygMY1czq2FLGIWA+I10+EC+L01DVEcWxHwv1wY77VeCgI/XP8Pe8oZQQdwBrn3O3mgPkksMMFMCntRhOQqqRylHWJbb62g93xbmksTNqzhGHHAoiaytaMqvHSt6psurY4guIE7xlrlaxpOzKFB+Oye+ZeekWHDuYPy14ponrauYtHW6ObPF4VgdCKFkgqpB8IL2VcC8YjZELAevA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 01:12:08PM +0000, Alice Ryhl wrote:
[...]
> > > 1) "relaxed atomic" does not sound like something that provides an
> > >    address dependency to me.
> > 
> > If you look at rcu_dereference(), it's a READ_ONCE(), which is the same
> > as a relaxed atomic load, and yes in LKMM, relaxed atomic load provides
> > address dependency (Please see the DEPENDENCY part in
> > tools/memory-model/Documentation/explanation.txt).
> 
> You argued that we should rename READ_ONCE() to atomic load on that
> other patch series because "atomic load" naming is better than what LKMM
> normally uses. Fine, but relaxed atomic load is a much worse name than

To be clear, in that series, my argument was not about naming, it's
about READ_ONCE() being more powerful than atomic load (no, not because
of address dependency, they are the same on that, it's because of the
behaviors of them regarding a current access on the same memory
location), and we want user to specify the intention more clearly.

> READ_ONCE() if what you want to convey is "has address dependency".
> That's not what "relaxed" means!
> 

Also note that my previous reply was explaining why we don't need to
call rcu_dereference() from Rust, because implementation-wise the
LKMM relaxed atomic load provides the address dependency. Depending on
what we want to do, we can limit this address dependency only to
rcu_dereference() and make it a special case, this means we disallow the
address dependency provided by the "relaxed" in normal cases. Or we can
add a Consume ordering (a type alias to Relaxed) that makes user to
explicitly use it when they rely on the address dependency. I think
either would resolve your concern about the name of "relaxed".

> I suppose you can argue that the word "relaxed" means different things
> in LKMM than it does elsewhere, but I looked over the doc you mentioned,
> and there the LKMM calls said operation READ_ONCE(). The word "relaxed"
> does not appear even once. If we're going to change terminology / use
> new terminology, let's at least pick terminology that's not
> contradictory with the rest of the world.
> 
> > > 2) How do you intend to provide mutable access? By waiting a grace
> > >    period?
> > 
> > Please see the {read_}copy_update() in the RCU patches that I linked.
> > In short, you don't wait a grace for mutable access, since in RCU,
> > readers don't block updaters, but instead updater will copy the object,
> > atomically update the pointer and then get an `RcuOld`,
> > which you can either synchronize_rcu() or {call,kfree}_rcu().
> 
> Hm, ok. I don't really need that. What I want rcu for is the internal
> maple tree data structure, so mtree_load() doesn't need to block on the
> maple tree internal spinlock. The contents of the box would be protected
> by a separate lock (probably via LockedBy).
> 

You mean after `load_rcu()`, we could access mutably by a lock? You need
to hold that lock and the rcu_read_lock() while mutably accessing the
return of `load_rcu()`, right? That is basically using RCU as a proof
for existence.

Regards,
Boqun

