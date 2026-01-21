Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B052AC44525
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 13:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B0D6B0005; Wed, 21 Jan 2026 08:14:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E096D6B0088; Wed, 21 Jan 2026 08:14:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC03C6B0089; Wed, 21 Jan 2026 08:14:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAFB76B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:14:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E9C38A7BA
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:14:13 +0000 (UTC)
X-FDA: 84356014386.17.CDB7CB9
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3C8D4180005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:14:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UgTDjzcm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769001251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HQDkqfe8wWRgLYxMvvzfKdW4MZONwsks3Mx1gvqFM4=;
	b=T9eNbWlwtxCKnm4gFp1KD4tv7UyZwx1GJri/LxBXgS0D/YqH/W6T7nezHt/KNhNZZXg1LN
	tJXTBIM+NRSdyLL5u7WoXzYq8Uq0OEhDcXSFgMAKXIKZrocOJbjzWa398e5gObadm7QRH8
	PW7FVi6KwyYYlbnZWBVRS3dtx/DAxY0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UgTDjzcm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769001251; a=rsa-sha256;
	cv=none;
	b=LCoqzqZr31KFGXYnI/qmSGjfd1Su3jKb/nf8Gg4xoePcf4UcfoqfEi3r+TiVXTnm48oqMU
	lmQACiVb3DoELYuw+ezPym1T9+WHzLO6+sRt2UIZYJxviT+wr0WIHZrnFfawhfcN+ai9zp
	tP1BWcbpk2XZjIMr6zKCSa0fgm01mSM=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50145d27b4cso67811921cf.2
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769001250; x=1769606050; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/HQDkqfe8wWRgLYxMvvzfKdW4MZONwsks3Mx1gvqFM4=;
        b=UgTDjzcmQJPmBnI52//rpfbm0xTdNwOOiE1BhYv3JcV0nIB+ikekZA2J4xltXd7BTr
         pWd4AWg0EB23P8tqAj9CzaBHYwq2vGjolzk1VKlTJ+9wxgI3yZInOJRHrmN2Nnc3F5cq
         MYbqlT+dQ8H8KhtG5p7aoHozQ9E0XGM04cWCveg8XHqdLvDGGq54XkF+AAoeu9xeLXT7
         mPEf3vBtVpAYb01nVTSXo//xhydRCu3qhgcbnL5M/ZDECyzzddAUvZaa9DZeGX8JPZzW
         KahSOITEqR74ktfo/FhbrW2bcl38+EBIL9YozQXca2Dr8L40zSmj6m68OWKzjRSR6h+r
         pvHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769001250; x=1769606050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/HQDkqfe8wWRgLYxMvvzfKdW4MZONwsks3Mx1gvqFM4=;
        b=f6DG9+qee2xgDJYdNkXJbPcGTn9iDk77F94LXZ7fKi2n+vExu9gc/uirmr7oTWww0d
         qe9JnAz6/fSe3SuKEIBns+1bo1vz46d5Dph6DFV3hBNN4m/KRHXhVyffmgtEkp6lV6tE
         ug60YLBvdZNI0d3RIAyuPrcAtb8SVmkMcUnv63rHVfCq1JiiO6wJw/X2TpWcSpd5VlBQ
         j59jPWbC5BCualHnl6GA+Fdjrcng8L1bIVW3hUKtq/Ub7fcpDh7GFt3zjISkG+28yEfi
         vJ4hSIAt0z9XSLRP2q7mC++XVibL4ujkSzy2gXpk43027Xq5Tn3Z1PIWlvQL0isykeIS
         Cv3w==
X-Forwarded-Encrypted: i=1; AJvYcCULlz347aYufolLXDsGXyVdqivDBDZ8F0N+mUow6XqvlCT4k9nk9qwX37sXKgln4DL4laJYk/WKJg==@kvack.org
X-Gm-Message-State: AOJu0YwUl8eofbbv9X9QXHmvBP1BG1Nu197HwIW69Dg5M+WbBy3fCalE
	t9y2NZMNGPE+Q/povWXs3rnPIrvSF9IwNfIP2UjlOP1LXT4xkf3hBdtG
X-Gm-Gg: AZuq6aIAvd00G1WG1Ni1dRJegMNezc73ZwxjmK3QW8NzcsDc4JCqs2NPy5hVtbH15iT
	zv9OMNUhx2n8jRodxN3ldZNR6RatztkatlG3Rd7dNuB5PWs1KLSXp6JQxo/x+1VGiZez2TDPFAc
	l04zDF6YqEuSG4EHrAO71bnENpxOjoABCtNeYb5cU8oqjDborDaoxDjjZ+kAC0ZVLUgrWX+CO/v
	mVCPinuCn/5cym6jA+yQy19GWItOHEuJYu92RKAFVcaJfODpUTSbdnHuZeQo+qmsa/i9ciiKFO+
	tQg9NCwv/YAogD3Ri1ijAN0Hlcc0d9vW3byqVnR8jh0I1aIWDP2+1wARJa4pdYE2MtNKS6tUgKw
	MAckpbOa4huGrDteCzvB4CTcNS96AgD1QjOrM4DfHWBcFoh5XHlgHTjPeNnR5N323Tf/P+4xx0O
	lXoUFUa7zcaU9CasCAUKOOcGtNzjZPZDHgbLi6fabHPbA04wVSpDpBjoMCDPzFB8rieuaAiv0if
	KDWbcNKtzLT7PvgRfiqScqDOw==
X-Received: by 2002:a05:622a:1805:b0:502:99c9:591e with SMTP id d75a77b69052e-502a16b3a66mr243793681cf.38.1769001250090;
        Wed, 21 Jan 2026 05:14:10 -0800 (PST)
Received: from fauth-a1-smtp.messagingengine.com (fauth-a1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e6d7302sm124098106d6.52.2026.01.21.05.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 05:14:09 -0800 (PST)
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 007D7F4006A;
	Wed, 21 Jan 2026 08:14:08 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 21 Jan 2026 08:14:08 -0500
X-ME-Sender: <xms:H9FwaT6QxyGAbq02ztxJgwthcxj-ep_vFFW8_qF2wco0e4hYfosIrA>
    <xme:H9FwaYydmotzjXwsBUcX6kWw0iV39_Nra-amxLAv0A-EdzQtYcGVTdf1uTgyE7kMj
    saWb_ykwgUSto98MXuuGUCD_0gG265YL5-hO5QETwbsIsEvJ89GFg>
X-ME-Received: <xmr:H9FwaXzjSFalaBqzn87ia9lgR2N1Yjf6YsJbPNhNut2FR_T3301XFWvV>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeeffeejucetufdoteggodetrf
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
X-ME-Proxy: <xmx:H9FwaQX7al9e38e0O4NKXddNLn6d0hY0fH7ac6s5kq4fAM9xS95MgQ>
    <xmx:H9FwaUQ0N7NkeFHXrrQP4GyjuAwAU8USNw8_M8eIFD5eIKZokc9DEQ>
    <xmx:H9FwafOeAGHKVYy0YYU9_ShbhoA_0ueMN1XMwgzhM-NefIgXik-fCA>
    <xmx:H9FwaRy7ZjxD4UfFdS50NZ1LDTQwyTyiVe4znAPnA0ykVvCAKArP4w>
    <xmx:H9FwaZpr7TPPcyL4pbNxYn9iVeS9_3-cX7zxPcbmzoj4Te_-qU8Q1HyI>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 08:14:07 -0500 (EST)
Date: Wed, 21 Jan 2026 21:14:05 +0800
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
Message-ID: <aXDRHerRiM7TzACy@tardis-2.local>
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
 <aWrSkAPFkdH_tvtN@tardis-2.local>
 <aWt4muGXbe7lBmXt@google.com>
 <aWt8Ze-otTkexNIe@tardis-2.local>
 <aWuKqLERqpNz9qtz@google.com>
 <aWuV858wU3MeYeaX@tardis-2.local>
 <aXDCTvyneWOeok2L@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXDCTvyneWOeok2L@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C8D4180005
X-Rspamd-Server: rspam11
X-Stat-Signature: xd1ikbmar5s6hecgk6dpwgnosquqcp69
X-HE-Tag: 1769001251-860430
X-HE-Meta: U2FsdGVkX19uvEKgMlM+coUwgTmPNe5k4H6mhMc1ugiHWYAtvKNhh5QlCw/jUHwPUBNhTWAmzt7LBt7rY9Xa5FbqHWDthyPxK92OGc78hFoAk2LqTCM62JgzNzYIKozb9LK9KpuUDvIK8ZxcMPYBNX+aoiS1IRMsaGWce872L5/JDw6wBQPgy+LFE1C2YdgVrPeE5bRX8VHZF4pyisKrACJeyw+MPYDegLR5BzNilkW7Qh2KRxmWS/bWqkjZ549RboBIIlMkmKkkYtQA8SDvFrWV5UTRVl8b6Q44mXnhdMD5NXIn5Nsl45NnIf4kJ/xJNO+eWTJ3RfcjMGNU3JHHdUI2JABqR6EX5TglcDmtFbTfFzUOTNacQW+LDkVtsaNuIJvqUPHbC2ftSTauZWGO5CedW+pbZpL9zgSHE5D5Fux7DR+Vz9JRkiwb69Orp2gPHYnodQ8QLFrAbdStnrd79mwrNRVbFV1JNx8bkT87oNaFUkI00tlRI6gK3yHY/WUJo5ng5ApbW9m9fOUwWzMMsLVk4bxZdrjQVoYkBdvAMTzZYp5FWomqz1ubW98q9EgNsqQmx284JRmPkqRu6Xxi3QhnZrj28SmQJ5+u1U7V0dEoFDKvWES7ixFbeqoXsMX5m+vum1g31wS/VTL0zGR6AK71ZwZwIIjRC78hOzHhW8oO0DZSp2165U1MTqTMuauD3RTN/+gqi0ljjxt0IZlbQWWAtDBSWbS3j2vjSnpttD+SWL1wpxpWFEvHgmnApMW/uruaGccSuwSTH9aXN4qevqJB5i3K3B++mZWGi0ArBdKslhS1s7uddq5pwVciGZH5Ku8mZ3vE6MIZwtzvGb8A4A+SAfFeENflfunxCEya+czdBaaNwft/Q6OcVunbOhlRumLFj4IAC/ujNevd74wGKgFCzr+u3z3wQCpsvjL14zdD+d1yiB0CCXDevojE6fK7eF/wh4CGD9VyKk14F0n
 fWG1v6zn
 5n5zPe26mjCrI8ibPQx5gPK66d4J9AmHwIWZCNtUY720HpP2w2337c5axSlnuaL+dfhd0Bi6nPY3JeakM5GDY/IQw2Ze8CsHkjyMtaCpI21+2FDlrpLO8cp1gvHLzgn6EO2TiOcwMx1yX8IojU0AS3M4+QnJ39fHicoOt7ce0QrXs8MQVtayweEbcmDri3QHjSGpREs+P43y1Sshb6JIlSOzSK2ru/Jzc5NBOoH8W/BDz0E+kDzRf3RO39NoDs/C9mkB1jnFgvj5/8JBZ0UqHtXxJ1iyesG8Ac4fl1XW9V0cTmHmu7SJ9ZHm4CvmSD1tiq08JKelmN0wAS/I83G/Zos4Z5n4D2GnC36ARnsL9ok9N/lcQ9dzCKIyppuEh9EGWjtaJZ4Jms3eIvht1CpQV09Nzr44YLronrxQbCz9m97upMqr7+KTuy8bBJdYlZMPFLAcJjLGPit9bakjob0iVJFD8c2yHoB7OSuwNa7zNZy4/ys0ocar5sFo2Pw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 12:10:54PM +0000, Alice Ryhl wrote:
> On Sat, Jan 17, 2026 at 10:00:19PM +0800, Boqun Feng wrote:
> > On Sat, Jan 17, 2026 at 01:12:08PM +0000, Alice Ryhl wrote:
> > [...]
> > > > > 1) "relaxed atomic" does not sound like something that provides an
> > > > >    address dependency to me.
> > > > 
> > > > If you look at rcu_dereference(), it's a READ_ONCE(), which is the same
> > > > as a relaxed atomic load, and yes in LKMM, relaxed atomic load provides
> > > > address dependency (Please see the DEPENDENCY part in
> > > > tools/memory-model/Documentation/explanation.txt).
> > > 
> > > You argued that we should rename READ_ONCE() to atomic load on that
> > > other patch series because "atomic load" naming is better than what LKMM
> > > normally uses. Fine, but relaxed atomic load is a much worse name than
> > 
> > To be clear, in that series, my argument was not about naming, it's
> > about READ_ONCE() being more powerful than atomic load (no, not because
> > of address dependency, they are the same on that, it's because of the
> > behaviors of them regarding a current access on the same memory
> > location), and we want user to specify the intention more clearly.
> 
> Expressing intent more clearly is fine with me. I still think it's weird
> for us to not have READ_ONCE() when it's a primitive operation of our
> memory model, though.
> 

But in our memory model, it's exact the same as atomic_read() (see
tools/memory-model/linux-kernel.def and search for "atomic_read"), so
why do we want to have both? ;-)

> And I also think we should consider using an implementation along the
> lines of what I shared for our atomic_load() or READ_ONCE() or whatever
> you wish to call it. The perf impact of helpers makes me sad.
> 

I'm not totally against that, it'll actually help Atomic as well, I also
hope that we can use `asm!()` to implement the cases where
`{read,write}_volatile()` cannot cover. However currently I would rely
on helper inlining to resolve this to avoid duplicate implementations.

> > > READ_ONCE() if what you want to convey is "has address dependency".
> > > That's not what "relaxed" means!
> > > 
> > 
> > Also note that my previous reply was explaining why we don't need to
> > call rcu_dereference() from Rust, because implementation-wise the
> > LKMM relaxed atomic load provides the address dependency. Depending on
> > what we want to do, we can limit this address dependency only to
> > rcu_dereference() and make it a special case, this means we disallow the
> > address dependency provided by the "relaxed" in normal cases. Or we can
> > add a Consume ordering (a type alias to Relaxed) that makes user to
> > explicitly use it when they rely on the address dependency. I think
> > either would resolve your concern about the name of "relaxed".
> 
> Yes, I suppose that would resolve my concern about the name.
> 
> Well, I do have one partial concern there, which is that the wrong name
> will show up in stack traces as long as helpers are used.
> 

I think it won't be a problem since in LKMM, atomic_read() and
READ_ONCE() are identical.

Regards,
Boqun

> > > I suppose you can argue that the word "relaxed" means different things
> > > in LKMM than it does elsewhere, but I looked over the doc you mentioned,
> > > and there the LKMM calls said operation READ_ONCE(). The word "relaxed"
> > > does not appear even once. If we're going to change terminology / use
> > > new terminology, let's at least pick terminology that's not
> > > contradictory with the rest of the world.
> > > 
[...]

