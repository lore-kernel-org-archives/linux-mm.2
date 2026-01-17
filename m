Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEEA1C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 14:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 308F96B0005; Sat, 17 Jan 2026 09:05:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D65C6B0088; Sat, 17 Jan 2026 09:05:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9396B0089; Sat, 17 Jan 2026 09:05:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF136B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 09:05:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B99141AE77F
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 14:05:25 +0000 (UTC)
X-FDA: 84341628210.09.676A16B
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8E8BF40015
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 14:05:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S4HbiSzS;
	spf=pass (imf12.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768658723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVIBuJm40ZFRv182tq23WWphNrxzPrOdcziw4l4EFIg=;
	b=fJSxyAico+xPbWYmD87KkfRqRjUuXCmuncVENv/luICMV4ek1alaBvALan03F7cv7Ls7jK
	v2wjZ7m/GdB85Xo/nvwFekSANsESRlgCuZaGRsVxxV2bk5N8oioEpJ5t8xmgJwdu8gWVtE
	jkOTaldkzw8PyZXbcDDRJBDxDOA0Tqg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S4HbiSzS;
	spf=pass (imf12.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768658723; a=rsa-sha256;
	cv=none;
	b=WhZ2/nB4HI/yQ8KtzXUGB4TfiUu4r9UQckpvi07Jy7HZFFNmHQdqVDJGauwv3fH9q/VAgU
	Tlkd6qsSkV/qOfFqrBz7x75yE+DZJ1YCPLVmEsQWmJtx0Dx4LmNYq201AYyA9Pvj9fCe7S
	10FvIFPagNv5Bcdd/x3Q2qAewTW+cWA=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5029fb0b977so18168581cf.0
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 06:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768658723; x=1769263523; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVIBuJm40ZFRv182tq23WWphNrxzPrOdcziw4l4EFIg=;
        b=S4HbiSzSYmkgV06wOaVJlfFRt2xhZIzHzdMQ/J/ASC3Ki3ccV3gmrGNsaM++BtfSCT
         IOYEIhgVE4dnsrZDU2ppULpmDnsptZcTa7kofnnbCZ4RINNuVaLkmNpuSpAiN7Wo54sx
         HGG781NMTmhk6WU6Ib7geuLV2ywUK5uEDVCFpoQ7Y8I2L6rC18ypC/KppuRJW9RYpuPw
         bLttz95YYj6yFLRUJJtH7Y69V8H35Z5Qj7NEXTSUPPZbDraavXXttvqGCTXql/6E/PCw
         4lpkLtkJjBpTgSG0Osa38RwzdAsJWwSMcsllgUxb3uqaOjPqh2PEF/3IrX0tTqrKZRTZ
         b4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768658723; x=1769263523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tVIBuJm40ZFRv182tq23WWphNrxzPrOdcziw4l4EFIg=;
        b=Kup4D3OJ69lvOvGkd17KUZ52yG9BczR7Va8qKjatCtNd+Muwd6T5+Jf+5bD8jkiXhJ
         Ur57m+aq+bLKmkEhT0Z0QtsS/fJjP0fqOyAGoHN8E58Tzy9crle+7DA5Ii4U1DEqJ1Lb
         4WfxC35eSCmbYW6E497YcZb6MZ7lvZI6n3lkpmw8N8Ofi6HOxoehqLmOSPOlnt7Craiu
         Fw662xtt2Bz624nwGDjAU1sm/hjV4Sj65HyDe0BIHkqwz5jBurehjw6mqtZ+YcdLoOGb
         Uh2jXIXonAVukxALNviN4J6Ax7qKVxv6csNAHCBZI+xH1/dtPB/0QBekceY05Kff4jTk
         SZKg==
X-Forwarded-Encrypted: i=1; AJvYcCVSqgrpudiq7C3rOxXj1vp5MzIvffExQX0oUeOWxO0sIU06WRtxF0WBMIfHgmo1Edda5n2C/XW9gA==@kvack.org
X-Gm-Message-State: AOJu0YxE3h04SNg3P7rs9cwWruHDqb8ffhNnGs+SR1nQdBybF0DxYjDZ
	y7/ymfgpyz8Mna0gef2aDYJDE5onwJDEvMF1uzwZSsKpB0ncq1pMOXvd
X-Gm-Gg: AY/fxX4YpbkSt5WDgoDSiqDuoAzAkrS9nsFYyWcg9pAfKEro2x9NxWjO/8ArzxsNCkJ
	o9Z8kiVRmO8IuWrYBhvOyxMRIapFV6SNvJdEKVMaSfBJKVW98DwZZXOYZlVCXWOqk6jgFLTMj/C
	L1Dj/znstSOvJa3BeUP4cUeHnh/z++5RbQPDL7Syix3+SEMSxIztMK8kogLfRRx1y27cTaZvY3C
	XY/BQAeXz/k1VKtvNSS6VHnTLgZRFWDqNoN0gsCkaB7Tx0EDEaV1h+RkrNYXQODk4M0A+lf42tI
	PdeqZJjGiqCvIEMceDV5m5cg4laQXo45/NrzHZJIgSghzysixN1iHJIF+TROyJ9I1CgB5bgRDPa
	jCCnEW99Nyfx6i48CxfpMWzElqAGh2KloqPF8nZJeun7owai50AJM2pwPBN+Nn7flB7mSmMeCLI
	XncgEqxLuuTS2j2Z5G/rLEX5UpS0uV7voeQkNzWVztrHZoWq6jTLDMlMqhnQeK5Qpk2VHNQgsoP
	Phj1g1Bhl81zne3t57JonR5IQ==
X-Received: by 2002:a05:622a:11ce:b0:501:4419:8abe with SMTP id d75a77b69052e-502a179c6f7mr98087771cf.64.1768658722461;
        Sat, 17 Jan 2026 06:05:22 -0800 (PST)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e5e535dsm47367086d6.4.2026.01.17.06.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 06:05:22 -0800 (PST)
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4C7BEF4006E;
	Sat, 17 Jan 2026 09:05:21 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Sat, 17 Jan 2026 09:05:21 -0500
X-ME-Sender: <xms:IZdrafiAFgNQQd9pfYdiNAn_YIRfMuyFBrjGkPup0owLwDDTlulhng>
    <xme:IZdrab449p3ca_-XRopq3IB8PjQVXe28Z977_lahBtkuWt9pRnOoIxjGkLGOOKPdA
    AARiSPGoZcS60fhBCrismBz7L1N8QwJQqwcHHsUbkMyuITrX30ESQ>
X-ME-Received: <xmr:IZdracbj0OI1aOsMiyu0gfOxX1nxsE_E3Kth2nLfNTSunZ6QFR--5G-B>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufedvtdduucetufdoteggodetrf
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
X-ME-Proxy: <xmx:IZdraYeWzdXBE9kPyssInmWLbGA8iwajfVCx2oxQUM6U-hIMLDcGig>
    <xmx:IZdraZ42wspFqZGpXQUnVbheX2LO_6XSurzvC9TpAhWSxvpUEC-o-Q>
    <xmx:IZdraUV7RYKVtpHoF-AFz1HCozvEgqj6oinCJyqlrMJySPG3-4eecQ>
    <xmx:IZdraQY2Qny_odfRhMRMNKCg8lyLzt8VE5w2aFVGt4S3tZLeAjQRcg>
    <xmx:IZdraTz9htCnQ2MPeXJYz1qzKH63G2DuJZh3MtunPCOeHfzhUO2DmGIl>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 17 Jan 2026 09:05:20 -0500 (EST)
Date: Sat, 17 Jan 2026 22:05:18 +0800
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
Message-ID: <aWuXHkGZlMvr0uxD@tardis-2.local>
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
 <aWrSkAPFkdH_tvtN@tardis-2.local>
 <aWt4muGXbe7lBmXt@google.com>
 <aWt8Ze-otTkexNIe@tardis-2.local>
 <aWuKlR4a-VJhBeWj@tardis-2.local>
 <aWuOtUa0mPDrnbke@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWuOtUa0mPDrnbke@google.com>
X-Stat-Signature: ynkoa3rsjj1uwm3qqcxbjfs8im1z98fw
X-Rspamd-Queue-Id: 8E8BF40015
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768658723-971076
X-HE-Meta: U2FsdGVkX1/i4Gn4Ymzk02osTeeOo2aSEhsMaErkXYbIlRXa8hWbD84UwRyP8DMTU6ADWVVQv2x7BSxIfOYd+irpDF0I0ceV9VRwgm3b1UkgiNxSjyUNMVKxB/P/nlGNCwgfIYD+f7blol0jsFwzwW6Os7YGjtmzYuszCvUcuEzGWmzb7RhJIR59JlM5dsbJ8CIhtfiypDxxwHV63Tdgp7m0ILHf5GSB10p4mnKLOUObZt5yARytvEKDsBBdglntaFYan8vk1tvkc84mQsnaEyA/Eh9kIHNiq3XceejtsKsVIUjPadaE+Yw1jn+A9ZIBpfdcKx6cSo3lgvr9hXZq38hdhQ04UfITE89llr00KwBu2dR1hhwiEYjcNc4jtMvOW8wfRbs7xuauwsnVWm75+Yn5OlyrADkJziq6Ue170VQjPRhIYJKb/5jgZf3crQVuLRxwbTbKGlsYiMA72/1c89oXNW0SmfDW0YFahTD87ABPZoQK0l9GwE2D3ICJQvG8sDZ9gR3L1gx5upSj1xF5HJAoaSVahqK5Ro58MDDTNhdNUaiC+kShNLb46VL8uVvLl+PUuo/ZkOep6JVw2le1TDdMRAKIMQYvoxFI3x31AL0srjg4s+g0YRIyjC0M0OJgyfhXXAIQ99ZFrSRnbxJ2jLwPiVETnHbSgv4lH1e4QN2WYdagS915JUeS392nlxOU+DdxdDySLe6Yn7SIk6TJV7xTNai1k31/Ges99Knko6MOyB4CI20bEUSethsTh6hl7+5297M3zHdmTPEJingecnZ22ocLeWzJvTQKMe3v976MFe6/2ZEfnsRsslBKem9vIloAvRvu5XcpFsufUyVzyZOMvAquQsqWtx1QhITozTndiqgpvISn56DwxontJbYMbE3VcAxS7fm5peGvZOKlmbxhO9rFB+cnJYr6q61JYTm+kR9I+q1sUdYRJNhTaWYAb3VAQnpP+OBYtZIndze
 Q5gY3YnG
 cdIHZCBbyoMs89RfMZr5nE6ADt2QPyUcXGeZy5RRD9oUfOcF4BwUIRIrXldAOrx/oAURZB115z2XXBBR21FTWBJtDPweAcciwxgcA3aAaaInjgNoa3ho135Sxl/2jBdOnl7cIbCYG0xMrQbDXg8L3fORBnTZk1GxfWx9k33Fwq9eKxXANPuUFxCqCAEdy6Ezc4xPamiI353/lhGglv54v1z1rLGWgk7jbXpZW5Tzp7Dj3MEU6hu+W59jczobcL9DqO5KZFDIIg/fMX8LjU8EmGy9fjRHC/ak7nyqyPqQ643c/4+z4OgMiATUgka0zkXpotUE6Q83sv1RcyNHVWUm0Io0OTjFyJOujCWYHF9b5CzddwXWi5z2d6oKIGC7tpsLIxdT6oVdoFEwgxJvSQsy+YeOtfcTyIrCuLlqB7XcPFb2OIhpmkzkCaiC0bu/z/fjKXrqbEfFIGd+EXqvk+CevR3rG3GNFuiN/9cKKh57b62PesNk+2NzobIRahg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 01:29:25PM +0000, Alice Ryhl wrote:
> On Sat, Jan 17, 2026 at 09:11:49PM +0800, Boqun Feng wrote:
> > In Rcu + RcuOld design, RcuBox is just a Box
> > because these two pointer types handle reclaim + accesses.
> 
> How would that work? Dropping my RcuBox<_> must use kfree_rcu() or
> synchronize_rcu() or it is unsound. So it can't just be a Box.
> 

RcuOld<P: ForeignOwnable> will call synchronize_rcu() before dropping
`P`. And I think we can have an asynchronous drop pointer type like
`RcuOld<P, Async>` that requires `P` is a type like `Box<HasRcuHead>`,
and the drop of `RcuOld<Box<HasRcuHead>, Async>` would be `call_rcu()`
or `kfree_rcu()`.

Regards,
Boqun

> Alice

