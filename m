Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 105DCC98327
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 12:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CBBB6B0005; Sat, 17 Jan 2026 07:11:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479786B0088; Sat, 17 Jan 2026 07:11:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 330BD6B0089; Sat, 17 Jan 2026 07:11:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 201AB6B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 07:11:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6A9B1AE9D2
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:11:24 +0000 (UTC)
X-FDA: 84341340888.17.92E211E
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 97686100004
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 12:11:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L0YEQ1o1;
	spf=pass (imf05.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768651882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Lq+qQrczeBcVzR4njvZgDFILo49g4HfX34hwBUDSmQ=;
	b=eQGxwIXZGnFjkhxXJyVi4MJukOfPBhmAuzC7SAy/rdPtYYnUcuk6M1P1OLsSDmLiE5QbdQ
	vcJRXRFJNtimlhP7tRN4SQolw4la6NKqnqSePLWV18QGBhrh1f/IRsUObu/JuEj+9KpiZQ
	cOCggs8w24Bbe4THjpbmRLkSB00k0zM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768651882; a=rsa-sha256;
	cv=none;
	b=CfmPpPiaQ/rlW68GAV5GAeOFtMeqktudWRNMKIWuHG7CthxANEpdsy3nwnj3SUDaBDdlOR
	C60lgzx9aSwUn1qAMWNpx0DF9WbuIkSgviMKtdCGKd0uaI1S0+IWDAUgwW0wycFrr+z9wT
	+XDAhxnNDjjF1uVqHJ2HidbgBuwoEos=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L0YEQ1o1;
	spf=pass (imf05.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8c6aaf3cd62so162847985a.3
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 04:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768651882; x=1769256682; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Lq+qQrczeBcVzR4njvZgDFILo49g4HfX34hwBUDSmQ=;
        b=L0YEQ1o11q6tu6kes0eNw+RmFGSWnoCNXAyy4ZlDotqlROP6bkcV2CKoJyeM8cRPTm
         tVO1YSEnmlzR6TkzYPApWkQ8DC0R6Pc9Tq9En32oLEoQgrgY+fwVq3qt9LjbmV94e18J
         +2QaqtJIZqPqR+EV2Nj5zCLGqXcRYYok/7Lhs0Byd5JJK1OJRnZSOTC1CNSVTRChFJjO
         07TjPDGv5HMYY2SHHPSdnNmnJ1kbOi4hisl4Q6Bc8Y1QvksGOdjQyDauqswQk/Kt0iCA
         ZXdR2XzgZmpZcxDgpVMbELauMKvIKFSMTqPlHUcvFLm6hWq6BWYJA7l9qnKHW8KMtjIr
         dsHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768651882; x=1769256682;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/Lq+qQrczeBcVzR4njvZgDFILo49g4HfX34hwBUDSmQ=;
        b=PhginPqNTSRR9KXjsyulgQxg+cnLHE9eWfMn8+irQYwNwgIdV1B78q97myenq9dQVO
         ShnFfn+XJMcrHxiJVk6iJ/vKEbQ0adpAD0QdK8LLGmMl6uKiSEZNPu21OMLlLGAjTkSU
         0TJLcn+OnqGjVPraUqQSuA17rtZgWKr1qB9TZFKZTfhOlyZ5UB8BiXvjWkVvuqhavh5V
         MGXFUsERzzVItSEweMyzD7ASASe+rkjqYDJ5ZZ3UfsLQ4Tbw7xuQYEL0KAoiExjSICkr
         9vaEb75L4LvINBPmL19qXB+nzl11tiP4fmBscXd+7aTgTOVz4pgI+rA65nGbM5RTRi/U
         qOFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUf864NyYFlf+P0//1t9dSVHCcEe/CLe4ScaF/34cIXsj8fd8yI6i+alKW1vDUaUWod1TOX/gIwvg==@kvack.org
X-Gm-Message-State: AOJu0YxPV2ZJs88/61sf50Kqh54fiAAv4pruaEPBX/iK7QdqXe9ATM0P
	8093YK6ChHqV/gW/RfpCnb+cIRPTqxT9oWadLoHNyUkoCmN7Afd5oWz0
X-Gm-Gg: AY/fxX6BkteFCTykoedgK7VeTx6u50t7Wro+TyEqa7gmiEVLdxRXUad4oHUFaZI6WOZ
	yE3UZYvgRlKi917NNvpexeAd5bCTM3onkyEMAIWiOdyQnxe8Qv3rYsR2GqcY/EPU9kf3D/DOich
	JQWHYlW3+imlgURWHyaQy5Sgv1t4KB+Tp2nRaCmIMd2FRnvnYZzcUeUENaGlsuDyluEpFHGcmQO
	xnha6xu+yL5FpEskWUJiC+HLNtNSP1Ht93vN+cSgShQr12apUKKDbM7FE54X2BsPTObQM3uYMXb
	F0feui4Skv/186Yr2yBpBRqYGyxy9xdJkTIQJubjRjFhObFH+epTYE1S+/oLoJVVto+yuQxpp9C
	CXmxd5wkwTfZ1l0a3J36pUKrL9q2E0nbroLwivk6lV/ejh3DcUbwzvdZ+f/8i1S/YiVVdRo+HiW
	j4FEZlT4UlPqZn7i05g/B8rOVpzD036uFA8BxreHOIvuRP4DMV9UZUTsxArNeyxXo2Oodb+8Fxb
	5ipGFpXN2Z/dk0=
X-Received: by 2002:a05:620a:bc4:b0:8c6:a487:6ad0 with SMTP id af79cd13be357-8c6a67b1172mr836990185a.85.1768651881581;
        Sat, 17 Jan 2026 04:11:21 -0800 (PST)
Received: from fauth-a1-smtp.messagingengine.com (fauth-a1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e602d53sm45788716d6.14.2026.01.17.04.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 04:11:20 -0800 (PST)
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id F243BF4006D;
	Sat, 17 Jan 2026 07:11:19 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sat, 17 Jan 2026 07:11:20 -0500
X-ME-Sender: <xms:Z3xraV1gi4XU5VZ1UdjEbRVJ-K-d5SHO9v_4YpmgA5WAGR2q87Va-w>
    <xme:Z3xrab8UirGoX8qQwGlC4CYRO3Sr7Q0NBm6b8B1jy4BBgQ6Rgh_8VBGYVKdZgo0_A
    -rucuAxTMTJ-flcMfh62BUz_MUncuAFm75s0Y8rweC11oeCReLU>
X-ME-Received: <xmr:Z3xraTN2Wr9QQrdssbyktUFdGt5XsTeFI6P5TyzhLTQ5TpajgFEqNCZe>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufedujeekucetufdoteggodetrf
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
X-ME-Proxy: <xmx:Z3xrafDcatiCph0lMQVUj4zOc4zOzsB34irsF9JfFkt071C6GsXT3A>
    <xmx:Z3xraVOHxyvt0GpG3yd-gksjK6aDB_BOTtUFP0JRn9z8oWrfRIJwuA>
    <xmx:Z3xraVZ25_TK82Gggvd5cjFZw-kP92E04W0c5br9ghCtUhREsUbEyA>
    <xmx:Z3xraUNidwRe1bkgl5eTY9XDC82OcVstuGUMoEnsNVS4IkhwY0lPmg>
    <xmx:Z3xraTWhJUMRrpoTUMZ2v3SzqRItCe_sOUx2nK_4QC_urcV4i8uekD8o>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 17 Jan 2026 07:11:19 -0500 (EST)
Date: Sat, 17 Jan 2026 20:11:17 +0800
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
Message-ID: <aWt8Ze-otTkexNIe@tardis-2.local>
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
 <aWrSkAPFkdH_tvtN@tardis-2.local>
 <aWt4muGXbe7lBmXt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWt4muGXbe7lBmXt@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 97686100004
X-Rspam-User: 
X-Stat-Signature: qi9c3c6hyyy7k3pd74xhnpaw7gyr3h6u
X-HE-Tag: 1768651882-450632
X-HE-Meta: U2FsdGVkX18eBrMASVIq3ZPEE0TbmgpSmcJAC3sT0EntUUOQEdElaHALuWacoS+ouUh3ABvMQPqSjbYkzplGhMhbmHOz7r6W64X876dlQicTYtHv+Int6w+8q7q44eSDHHaggTnT30Y0BxeHidn/1Zr+3UXZv5hVbtsfJMcyfjbsLGiIGAAZrbaCVns71WK5Y88Zhz1sLxyIeYZI4/lV81ZARPQyUMxJH7T9NaqWkNdLiOG8adQOtlUrGzwBsuLtW2K2DWoCQWX/9eGW6+ksDNczpmFIVl2XqudUAfYZE0Pnr40NI9JyxxtKb0RIvIYMWBZhUc4U7OeeFmvTA14IX+VWPfya2ePHKoMX4L25HN9hCtJPs7tScK7tqr68f+hFOuNEhjiCcUTzbrmKOxxQzWYPOD6BjX00aSq8hvFmhTsRPIj+yzhhxuTZiw9r0GfVj72tGgJFBau6pNVMDl2aR0rwIdXYHCS4qp62vwMAIAAFzKL0plY4rmoJ3wZKdE8h870Lq7gP6vP4P2JFJvk2tVQjdUnB/KYj8bDvEL6jmlspDu/3quqpNyfpyCjK0E1gayjd1bSEFvhQj0By+71ejUY4KEGVVeU3NJE3Rznw1VpaJNuafxbkDTS/BLKybGKfdlSQJItPyLFLJVTx4y/R0fnHot2oM3ShT3WUiNys479mHc07COjfpkXpihUZmpAiJFWJ09e5wLC8sqNBoFie3jxZd68h73KHVSbPYuftVHEtYyGLuIgzRz37hutFD90CSSSA2BEvkZjOZLlZUdBOl1Ewi4ADfb5pgrFULBR/aC2Gr+YZMo0zVcM7MvWE0058AU7gPeiJIfiY6733cARRsw8zwzafu/W5WIgjarThXTxXIUn8/Ie+Iyf86AnHKnJGak5tZAfQvnwXRTsdIckzykb5BJHFMbeHHMi/WqqHjOovBVPR0oF3t9buXmlMYZfCnON3+fPeuLEIiPWH7ZJ
 R/3HhMsm
 YCBLgc2h67mHivPquEHWeRenrDV4n8X9/nfkYgc1ELxy8LQlFGZI+usVVBWg8fEU/iT/0w9KXpBYwGpMulYhcpuzAi5ibQkyxsYFt6gRfxyUT0L404q/MW+udX5/fELyZtXWbTwvI2kq4KTWE42BNdmIlZhcuubkmPku5Fn9y7YWeElQMW1TxwHFhP6XLSt9sB50HIGBjz7FMFwK14hI9Ce8DG1QlnNTsiyCTy2qK1zgReU5bpwGs8TEgLr0l/lzjdqZI4FqlHqc+KFn+uWKsDxWsvI6PMgnnFzsgMYnin+kNKa//3lPBFrlygYD+6doaPsydRpbW04dmiwVHbLWutIOKV2TBtSk0d9zluy2iQwv4ghaHoJ4/0Pz7WmvhYcF01+caAIRXrbtzM1Sk5EH2W3Z7kKw2LLyYnzg5xpp5iu6KvJLS/fVwwxaCINr4rOQMx1Huj3oLaYgyukYNIIW61OOO4Ascj0iRJFqML2Sl1nol7wSv0kRPlfZ0RQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 11:55:06AM +0000, Alice Ryhl wrote:
> On Sat, Jan 17, 2026 at 08:06:40AM +0800, Boqun Feng wrote:
> > On Fri, Jan 16, 2026 at 03:46:35PM +0000, Alice Ryhl wrote:
> > > I'm sending this RFC to share an experiment I'm looking at. This may let
> > > us replace the range allocator in Rust Binder with a maple tree.
> > > 
> > 
> > Thank you, Alice.
> > 
> > > An RcuBox is like a Box except that it lets you obtain a &T that
> > > outlives the box by a grace period. It does not allow mutable access to
> > 
> > I think the `RcuBox` can be folded into the more generic RCU pointer api
> > [1], e.g. Rcu<Box<RcuBoxInner<T>>> where RcuBoxInner<T>: HasRcuHead. The
> > benefits are at least 1) we use relaxed atomic read for RCU readers
> > which guarantees address dependency that RCU needs under LKMM (while in
> > the RcuBox here, we just use plain reads), 2) we also support mutable
> > access as well.
> 
> 1) But mtree_load() does use rcu_dereference() to obtain the pointer?
> 1) "relaxed atomic" does not sound like something that provides an
>    address dependency to me.

If you look at rcu_dereference(), it's a READ_ONCE(), which is the same
as a relaxed atomic load, and yes in LKMM, relaxed atomic load provides
address dependency (Please see the DEPENDENCY part in
tools/memory-model/Documentation/explanation.txt).

> 2) How do you intend to provide mutable access? By waiting a grace
>    period?

Please see the {read_}copy_update() in the RCU patches that I linked.
In short, you don't wait a grace for mutable access, since in RCU,
readers don't block updaters, but instead updater will copy the object,
atomically update the pointer and then get an `RcuOld`,
which you can either synchronize_rcu() or {call,kfree}_rcu().
 
> > As for the progress of that effort, the Rcu atomic pointer is almost
> > ready [2], I will likely send it early next week. For the `HasRcuHead`
> > part, as you may be aware, I'm working on a generic `HasField` approach
> > to avoid duplication of `Has*` trait and macros [3], that requires some
> > syn adjustments from Gary and Benno, but they should be available next
> > cycle. I will probably send the patches for reviews before that. Once we
> > have that `HasRcuHead` should be easily to add.
> > 
> > Given the WIP code I have, I *think* we are not that far from providing
> > what you need for binder.
> 
> Hmm, so I looked over [2], and I think my RcuBox is an RcuOld<_> rather
> than an Rcu<_> under this model. Though I can't afford to pay

I don't think so, `RcuOld` represents an unpublished object while `Rcu`
represents a published object, you can update an `Rcu` pointer to
another object, which is normally how you update with RCU. But maybe
it's easy to discuss this with updater side code in picture.

> synchronize_rcu() for cleanup - I need kfree_rcu().
> 

That's something we can add later, for example, we can give `Rcu` (we
can add the similar thing to `RcuOld`) a generic const like:

    struct Rcu<P, const ASYNC: u64 = 0>(..)

where Rcu<P, 0> use synchronize_rcu() and Rcu<P, 1> use kfree_rcu() or
call_rcu() (once we have HasRcuHead support).

Regards,
Boqun

> Alice

