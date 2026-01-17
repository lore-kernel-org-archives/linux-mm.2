Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D07BDC98321
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 13:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10C16B0005; Sat, 17 Jan 2026 08:11:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BECD6B0088; Sat, 17 Jan 2026 08:11:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0E56B0089; Sat, 17 Jan 2026 08:11:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AC096B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 08:11:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B31D58BE7
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 13:11:57 +0000 (UTC)
X-FDA: 84341493474.30.91875B0
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id CBE7640007
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 13:11:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dSr5OTd+;
	spf=pass (imf12.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768655514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTrHmEc1BYd79fY4MjqTS6sMPKSqsWTUhgoBbfphsL0=;
	b=W1WSsFVXGGGGRcg31fBYjqi1TRyKFawdU4M7HfiViJUSe2iuZxkgeXZZTA2mtIyu0L0tdb
	KmN3hFqWJnVOZ7ZS4yQUVoBQZT0c+gkwUNf1o+MINrGdZ4bztbg1xdDa9EnpML3RJ8NFE1
	o6qM8y8U4+ZdLPeqfY9Vmaw0f6QUAs4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dSr5OTd+;
	spf=pass (imf12.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768655514; a=rsa-sha256;
	cv=none;
	b=SDrMzLVBYVVDISgL+xbIFQazB7ZfTnON1Uaq5YHQYUCNtbDlAlED/VeOx824SQKpAFq7CZ
	G1Js7Ca8OP8RZMA1LScIUuHfh8xLRZW5kdKfYcPSy8JjqUSA3ncqb0AfzQKgOGczjRnJGR
	Ih7QlLEYN2HugnV2QTdo7OYK17jcbVU=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88a2fe9e200so27647236d6.0
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 05:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768655514; x=1769260314; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BTrHmEc1BYd79fY4MjqTS6sMPKSqsWTUhgoBbfphsL0=;
        b=dSr5OTd+KaignguAy2h3SyCJ2QW4n464YkmyBRirq7+65CBGmkxPPonN8gL3v5WxUx
         ZnYCgsGzMfwaOPJXv++XqKjei4bnB2ocILwV9q6InyyxEm2jaPnxERFPC5mLyBCRzT1+
         bOsffVa2R8+O813jzhTLHidnGC6H3mxcqDqLSLthsOOr0dcwRAiFfpcF3BJnDNXFtgee
         mtQPTjn/Ga5XpoWX9ox3xI6iQjyuCrk6lMJV4fKVOJfVQJwgPMUaKiyM9GgmrrjpkPYH
         C4U+hHqhokJiTOHwq6fU7KLh2NC8bbQJwUlxA6f97uA0UAfj6jWYLOW8CidtKRuuZ6cs
         LVmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768655514; x=1769260314;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BTrHmEc1BYd79fY4MjqTS6sMPKSqsWTUhgoBbfphsL0=;
        b=wIP5cyL/gbPK9v0YZ47968VWtUSWaPFZwLhpjsXy3LarJZ15+MFGPEV/1RI5iZ01OU
         j7yE3YFUBkmCTQRkM9YEAME3r2yodhnYo30ZJSUR2zPaKmz5aLLd4jMALWWAsxLzTEIb
         5AqZtU7u6SlyVdUWFmcYasaZ7Poagkv38znJmwoTCm8rjrTfUkRcUjkWBSORnyaeUtNU
         qtkhow2Ryd7Q9cvXovYzaDMktV7UDJYyNoLT6EGJrjsUNP05K4GrBiL9PE4g1Dpc9SBA
         YaRQqwzv5unf0ujZjKtBgtgi95dq02re+IalvwrbtFDbGLCy8ZTv06+BN9hp/3lu7aMs
         UMiw==
X-Forwarded-Encrypted: i=1; AJvYcCVju0+nJYQCyN4oU73/l7f+XS20JODGwqJFo9Meg7O/MtR1/lszLebI/x2kqbCtvQoATtMMXfFeEQ==@kvack.org
X-Gm-Message-State: AOJu0YyzfZmF3kyhnl4oJN5OfGWI/ZmdKygzB+ynLfwB7KQkTvZ0GWEh
	MT4799hx0OWJzTzsQAseiS0LBCT42HMfARkCnE4CU/uLUXIA95Ox/+le
X-Gm-Gg: AY/fxX5ZXlRvTFRDMmFgGv/uxgVA/sU1RpqB0mOKiRCq6hva3OD7runothfDsYluSJy
	u1JISAV0xZQu8+Pc737/Vd1kYamaR/y213qU4iXVUBxnA9aB8D1sAU4e7rwzochKtg4Q/Phu105
	3ggaY1g/jG4vAHvfp7WR8Kfw3CEa2ewB041GdQhoxwf9u/wBioA1XP8Rv91OSfyCs53NxejMkrD
	eSETZ8LdEkYeim+RdpbpSSLwzs8BAeyPCbtPkFjaoaWL/4EdGVSHjaL0s5miRuQObITueLBQou2
	rqqW3aLF5MrUzvJtYZ7ybs3pny6uuKqqbzr+zzahoXrHTo+2ILi3V0Xb2BkWtdvHYIv/IxWVVMc
	7jHOT1OB4wO9uL/AGRbh2dWfCy2e44FeyLXzcp6VUBFetxsHFjWQ3zstnETMocMUshcxcnUQx3D
	4I5nhOSmqkqgrxmJp8/SraBwXW4KrtwuQgXjTTnzKpQ8TOftfg8us8iVESMxZNSlG7d58W6WxxX
	VAQBvl48TMOh4g=
X-Received: by 2002:a05:6214:cc1:b0:892:68f8:aaa6 with SMTP id 6a1803df08f44-8942dd29578mr77537336d6.18.1768655513740;
        Sat, 17 Jan 2026 05:11:53 -0800 (PST)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6b22bb7cbsm154629785a.39.2026.01.17.05.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 05:11:53 -0800 (PST)
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6D76CF40070;
	Sat, 17 Jan 2026 08:11:52 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Sat, 17 Jan 2026 08:11:52 -0500
X-ME-Sender: <xms:mIpraatouuzYmY290PICbgo-cUjJ8YERdLYtdps-8CE5PUvoFiSQFg>
    <xme:mIprafWx7i08mFu3COd79g5ZIRMx-wD1ke3oj52cc39PGqEq4IrdHBt3_JL2nPlnU
    WO9zfBF8ucNXitKVaiJbrcOdOIUzJySLi8LPKISqiDsQjNX92jNpw>
X-ME-Received: <xmr:mIpraTHqN9021MJgEklW0YJorHzIgFQZyHze1He0zNc-KbmczYITFscF>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufedukeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtth
    gvrhhnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueevieduffei
    vdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsoh
    hquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedq
    udejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmh
    gvrdhnrghmvgdpnhgspghrtghpthhtohepvdeipdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopegrlhhitggvrhihhhhlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehprg
    hulhhmtghksehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhhhofihlvght
    thesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepghgrrhihsehgrghrhihguhhordhnvg
    htpdhrtghpthhtohepohhjvggurgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghj
    ohhrnhefpghghhesphhrohhtohhnmhgrihhlrdgtohhmpdhrtghpthhtoheplhhoshhsih
    hnsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrdhhihhnuggsohhrgheskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtohepthhmghhrohhsshesuhhmihgthhdrvgguuh
X-ME-Proxy: <xmx:mIpraRZ0E7gQgihiTBQGdk8NJzk5LHjpDnTsajNwQqCynVnyNvCabA>
    <xmx:mIpraYEGZCkdhSLth-YP0-uFI4SBokX8bsf6KZSefEJ9ZP1LCK-8tA>
    <xmx:mIpraezwNK35Y-fH7Km4_s8sjxZ88bvhgy2T3d4O0SuvtsnG1uNU2Q>
    <xmx:mIpraSFY3y_AZlldHk6dUC5yFgvZYgveNpl1JLcNkKFgoy1vEiRCoQ>
    <xmx:mIprabvE9lGOY8-3epT5PTdzFEn1xPI2GBg5_OGF8Og5Nk64i3jcIzXQ>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 17 Jan 2026 08:11:51 -0500 (EST)
Date: Sat, 17 Jan 2026 21:11:49 +0800
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
Message-ID: <aWuKlR4a-VJhBeWj@tardis-2.local>
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
 <aWrSkAPFkdH_tvtN@tardis-2.local>
 <aWt4muGXbe7lBmXt@google.com>
 <aWt8Ze-otTkexNIe@tardis-2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWt8Ze-otTkexNIe@tardis-2.local>
X-Stat-Signature: 1ip7a5c4ki4c4wpobji8zud1n1syx4on
X-Rspam-User: 
X-Rspamd-Queue-Id: CBE7640007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768655514-25633
X-HE-Meta: U2FsdGVkX18FKPoew1J6NKtIQfFfWwCbKda2rhK9i6x5nLxmlQJ90kYC38YQ6N6968XeBXUoT1T4qex9umV/yOeQw3QNzJdcKY60a9ejKjlPnLeH7MrVvw5kexbHnt1sZCEMNGMnHfMnCdBtazqJxhPTHjNtoXwKjEOGxliABCJqAFefoQ91i5kk6bofHaL8sAihcvdIzaYUNpu63lImzsC2BwTVJNnzBv/jF4cdTp5crmgeIqbJgxagTPed/qrw03ZLxfVxa4osN6FLag9KCCJFbkqgqgsGabs421CI6GvQuT8n10irigoNkghmhX091QRCeSBpy3JbD4NurqxW4Wh2MS2EocTdyFgPDh+t9qOYg54Du68HIQ8qbLnrk3xJQJcGipt+uXnOD4d5k7IoayuECAMh7LmfpCSYBk2a/wlLqlXoN8GNPRvgKNnRUKQgsyolWXVfvj/AJxv7qNU+elMP+5URFrV8amUjbbqM1mzBynjZq2/R7B8LHvIso5mPEqaaKoV8vf0V8t9VgXvD4lW2N5kzlxKQIIUqUQz8iU9pXXd0IFIdRFPOQGS2/7fDVTWnQEjXjjg9VzXCxcK6/HqIynVDn6ACy7fOOPGZlNg8XDGz0PaEmNPql7NEpPtzsYb0/YgbdV3ymecEWPfGUfITe9+KOtMWXcXmhUi85ujGOr1RLk7jSbV0/k5CNGM4amqY89ip++7MIwD1wgoGuH9iSCkZ6E3ZnQAwStWpDuqc+gcG5HluMuvGU7hjpREoFQgYsAVJoVYjkMXainVhnRjRm85YJEBrbVTrZhgTzup+NE/ENLN0oWFj1dOjVlzgo76Ib0EnN/XF32Y4AWCNjvb/5MQtptdlNNO6Tt5JAnM4upgm/fS1gPqAcidQaw2lfOlbhp7joue9iaqKALQl6h3VH1HXII6C7ze6UYpIo3aHJI5cX8yLAqfkTbaLcPb7dNALuEVtD42Btj7nGqs
 ydgZ0gyM
 kuCu+1/ENMqo69xbC1VGHfetlvKOf/S3iu7V0NRKh9GzEJJF/gc9z5DmDKVQkcoWPDZ975rMo5PaCAF7um+VlFxQOLXwrDlvOS6Ac3D8GzJQMrZtmCYsBpBT3bXgmMwWrMSs8jYhxAOmljANL/ep+9B2a+Ubo3ns5o4b0iB5NLt1GFPj10uR+NJHRSLvAYnSDl1PBLlnMn7I8OIYdUx1QXolk9kb5Q9bxmXz69t6k0dZiYrAaXmM3sgHPNc6UdhQ0vTJKrCQU8rubRJDu+dJj7LS1fYnLOrD60ye8efBOmhTGUUxmzbeWS9zfAwS61UBl4xkasUMu8WfWia1OyOPDLtegNbRg+f108zsV3iW8CtqlGDZnsI3X/VZIj/7PSB9XAkm4xMPU9+sMs61g00QanyDe1h8oW/wiVib3IjIVO01cmJwiQHprdN7eTt2Hojy/hGypuE60ZotGBBqF3DtBXnv6xUHp8mK20BGUPKBeltqJMSEfCD7OMSq9vg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 08:11:17PM +0800, Boqun Feng wrote:
[...]
> > > > An RcuBox is like a Box except that it lets you obtain a &T that
> > > > outlives the box by a grace period. It does not allow mutable access to
> > > 
> > > I think the `RcuBox` can be folded into the more generic RCU pointer api
> > > [1], e.g. Rcu<Box<RcuBoxInner<T>>> where RcuBoxInner<T>: HasRcuHead. The
> > > benefits are at least 1) we use relaxed atomic read for RCU readers
> > > which guarantees address dependency that RCU needs under LKMM (while in
> > > the RcuBox here, we just use plain reads), 2) we also support mutable
> > > access as well.
> > 
> > 1) But mtree_load() does use rcu_dereference() to obtain the pointer?

I see, I need to change my reply to "RcuOld" below..

[...]

> > 
> > Hmm, so I looked over [2], and I think my RcuBox is an RcuOld<_> rather
> > than an Rcu<_> under this model. Though I can't afford to pay
> 
> I don't think so, `RcuOld` represents an unpublished object while `Rcu`
> represents a published object, you can update an `Rcu` pointer to
> another object, which is normally how you update with RCU. But maybe
> it's easy to discuss this with updater side code in picture.
> 

I think a more accurate reply should be `RcuOld` is still not designed
for the usage of `RcuBox`. You're right that `RcuBox` is not an `Rcu<_>`
since `RcuBox` don't have the atomic pointer part, instead it relies
other atomic pointer operations to work (for example, the
rcu_dereference() in mtree_load()).

`RcuBox` represents an object pointed (and protected) by RCU.

`Rcu<_>` is an atomic pointer that maintains read and update for RCU, in
your usage, you don't need it because maple tree does that for you.

`RcuOld<_>` works with `Rcu<_>` to provide an API for users to decide
how to handle RCU reclaim. In Rcu + RcuOld design, RcuBox is just a Box
because these two pointer types handle reclaim + accesses.


We will need to use `Rcu` and `RcuOld` where the RCU access code is in
Rust.


I think there are similarities between `RcuOld` and `RcuBox`, but they
are sort of designed with different usages in mind, lemme think more..

Regards,
Boqun
 
> > synchronize_rcu() for cleanup - I need kfree_rcu().
> > 
> 
> That's something we can add later, for example, we can give `Rcu` (we
> can add the similar thing to `RcuOld`) a generic const like:
> 
>     struct Rcu<P, const ASYNC: u64 = 0>(..)
> 
> where Rcu<P, 0> use synchronize_rcu() and Rcu<P, 1> use kfree_rcu() or
> call_rcu() (once we have HasRcuHead support).
> 
> Regards,
> Boqun
> 
> > Alice

