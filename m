Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43ACCC98316
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 15:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193B46B0005; Sat, 17 Jan 2026 10:39:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1418D6B0088; Sat, 17 Jan 2026 10:39:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B7D6B0089; Sat, 17 Jan 2026 10:39:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E018A6B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 10:39:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82FFD8BA22
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 15:39:53 +0000 (UTC)
X-FDA: 84341866266.11.BED039F
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6226620003
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 15:39:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HixiUkt7;
	spf=pass (imf13.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768664391; a=rsa-sha256;
	cv=none;
	b=XkxmLhScsikxbVg9RRqv9uo96ky/Nmc2miusQ/NsrNcg2JP/h49WyJ3GY4vbWruVFAqGAQ
	Zq4F8RdrrmguXS5pY2rF2SHrq18BONvt998Ybup3MhVzYYX+brMF3LtuS5cboVjN3uBrQ8
	D4eidP3gXpHLITmMXUad1ZtimSBCKXc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HixiUkt7;
	spf=pass (imf13.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768664391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MsFwJU0uorXcDejUHSz8mT5Xd1nNN5P7vGbzkPiWNoc=;
	b=ojUiqWttrJGH6Guk6a7rRxDBE5FG81hYjDGQDhQs4R4tByf03EkVRFuryGlMHckY4spEev
	DoEA/SmwzhRNTv42oRYwKZ404PVGffHwokX+dYF3KykRjLPzxYM+jX4giYKU5KTS+ar6yV
	XOM2zpXWhmYsa5wvMXCWpGnInahi9qU=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8c538d17816so400880085a.0
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 07:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768664390; x=1769269190; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MsFwJU0uorXcDejUHSz8mT5Xd1nNN5P7vGbzkPiWNoc=;
        b=HixiUkt7BH141bVWA5VKC/xM4EfLAGnLti2tMhT+SLlifC6TXuoujqcPo0MwkduVom
         Mgc67+27Zf0lPnskvlG4YVmvFifBCCZqY7VZOdZB0Jwq8eLtdGAFvzdwbjkXsj87zPLd
         x1ANWjWvzVL6sBoEmbNgEMUgQZUqyz0sWEHpmy/UwgJoxXcR8iyzPDXbOwmW5T/8k6C6
         jOXV+194+ZO+vTbiAdeROgvOEt5lvxEBDgOmbGhaRwdxF3jBFcI8wUt7IYOPpbI1wk9v
         pTCZSxI4Beyph41h1vrt+Xm3KBp1lgEqfOqguDabFUBHn6y2pngMSzQQX13PJA3BkA6h
         C6YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768664390; x=1769269190;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MsFwJU0uorXcDejUHSz8mT5Xd1nNN5P7vGbzkPiWNoc=;
        b=qcen4CWXCCmYJOcbnCocgscRSFurI5n12Y5uBovBlCoHkQn59yXDIgVcCGia6e+iRX
         qFoFp/qB6IrDN7T7Cw3ZUfGOSmIfRAwxg4iWMuOC0W2T9duTSzILDW/GzuhnfBvwPMAl
         RDIdzgNbZEyyYySiNn+ZFsP1hNyhx48qi9TT9jhZLuR2y/2WNIf3JSuY/eHBJ9VmxH3r
         4XkmOrvP1iZvx0f6rcdIIxlAHy1FdPSh7Q7TWr8sCBhbc99RNcXE7OQ6eYN8LmbuJ/jP
         H2tumeCtoqNT8BtdNIpR/IbTShj62n5Dj2jz3LFeLKkuaYZTXLooH02bgfVTmV2VtQYQ
         jbHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGZBED2Ly/OUN/P4iDz3wbLR+jnDTBZQ2QVORlSxXs4UqNTlg9zQArx0XvkeuMmWb/y//IfRE8aQ==@kvack.org
X-Gm-Message-State: AOJu0YzfpT7FLQzMaQfDwwWc9MevsMYeTVWGgx8DiNV+9Y95xLqeRa3L
	D5td/NrdL4TszGwgs044OU+njVc80mG9bDJuguVgumFqxT2Mrf+u6Y2y
X-Gm-Gg: AY/fxX4kDMpuGu/SH8tuZxp3WJP63XjHD+uuKadayzD04sWtAuGCf9mPhMoWpEbtVm6
	s81Irg42OyKs9QSJJhcC4Ik+PPCVWbL2dzUB1eSuiUY5YiTQXs5noCWeaAvQFIXRkGJdkRNrZOB
	pI6EdxhbHa49i7JPMdHpkrY/8P4BbH3my0lvBqRiSGsMTDgttqHFOEpCyuzKQtaMBMCRpS5Dlbh
	VC9VAfMS7lQc14Mdje0YDU0/li7IQCyiyQ59kMOu8bABhfGiF2FMI0bkFOBKGfTcnW7DPWdofzX
	kfGUIidaccMK5a3MOEdONNdUb2pOD+rTFMWj6v4ZZaXKV44TGiQnArgm5HN8BIx7Go52VsIphbY
	CjGMU1wbSjxTsp4Ubzzd4AUrVeyU447xHVQNoXmCtrAQfbuFNI6ZbX5jfS0OuVKHCYadMhcMk+a
	YBFS3raN8u6gR+iEC4XtSUMuumOOjk2jm4bD66WtFE1/X3yfK16dU3+q4V8zmNHzYOZWPyypfjG
	waifp5UbVleuro=
X-Received: by 2002:a05:620a:128a:b0:8c6:a84e:2a2d with SMTP id af79cd13be357-8c6a84e2ee8mr540589085a.31.1768664390250;
        Sat, 17 Jan 2026 07:39:50 -0800 (PST)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6a70f1fe1sm448624185a.0.2026.01.17.07.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 07:39:49 -0800 (PST)
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id E79BEF40076;
	Sat, 17 Jan 2026 10:39:48 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sat, 17 Jan 2026 10:39:48 -0500
X-ME-Sender: <xms:RK1rab7rMRnYmsuxO2M1OdMHbLRJ20HzxQGGz1hSxMBvL3L2kKxgXg>
    <xme:RK1raQyTGMwWDE-CnPIbW4LvN47vOtGrZw5YPszRdp09rnr04-lKWyypz0OfxziFm
    h8sTsqbwxqJAunQsRoo1wmXXgA4Uo2a_BTBE3yCIRm41oDwmcW9>
X-ME-Received: <xmr:RK1rafxqe0j0nt1CDDmhNxFXOsqrVhhr9viUfCa1T363Z3G6Z80GHbkt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufedvudelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:RK1raYWsq87pmfvRbXi5JFYKA_KCUBH5rc8-Mh499582NEFspw52aQ>
    <xmx:RK1racTHO9OTXGWTd7Wnhwlih0XeJmAB1RGE3NlLFjGVsnwaNSHX6g>
    <xmx:RK1raXNseBlDOCe-yq54TrACSTafu1k1JEYQ2xxtYpx1H86yRv8lQQ>
    <xmx:RK1raZw6CtwWC6dWv9737pBYAt5rbNe75kHWG8wKFyHucpyyabEaKg>
    <xmx:RK1raRq1F5u7Sb-JBFPV5Zyr8y0nl5XkLXjd6h2Kjb2wBYoAbWbfzQfi>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 17 Jan 2026 10:39:48 -0500 (EST)
Date: Sat, 17 Jan 2026 23:39:46 +0800
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
Message-ID: <aWutQuJAaBXG2JY1@tardis-2.local>
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
 <aWrSkAPFkdH_tvtN@tardis-2.local>
 <aWt4muGXbe7lBmXt@google.com>
 <aWt8Ze-otTkexNIe@tardis-2.local>
 <aWuKlR4a-VJhBeWj@tardis-2.local>
 <aWuOtUa0mPDrnbke@google.com>
 <aWuXHkGZlMvr0uxD@tardis-2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWuXHkGZlMvr0uxD@tardis-2.local>
X-Stat-Signature: nq5tj1qsxmi7yifmurutfob7ckkrq4m8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6226620003
X-Rspam-User: 
X-HE-Tag: 1768664391-643541
X-HE-Meta: U2FsdGVkX19oxYfVGWaY9/+AdmBbNgXVrzSOB7W5wsYXyL8o+vewnECPmvot7fmjv5vN+tOya1BPYYpXOHzxKy4l6JT1oybtS3lbeuatj3uz5qYGG1brqaepXAGsIPxFO/CerdEqS5CT68eFubYOrmJiV1lTJvWcoQjinlQnGgPNCIE+NrljRiuY4i9W8t+crMrNLGk+mzqQDu6VkPrhq1PH483GHugDqDyRE+dOIA4ohYuDf5K5SK2I1WtU+aYbYL0w5oOwigXSPwmMvd4jremF37973aSBJXdQsi1n/QaGJsNs2sjw4L98iWNUK32KNYGqFLHpjAdNC+wnupg57BlPTT4w50WyOYYMKqWf8qZLm7O1nHXLgTezXeCuz040BCWoTYwXNUGX1FZbVFzV7yJVprt7xdCW8bVhTfAxGWLo00ih33UoKA9bdsJ4XEM1dLBoDcdh0VZIZ6DdGqPgvjLH0hrPbvXRLj8AkLYkGVr6nWQ3vQ/+mrdpjzCXt/CnWUVyk56TcEXJcSiu5fFQcwVzxKcyKx8bLZxxGO+yAaRw+++qEXxp90Uh3EOUneL8NdjmyTmrrTytoINLUWg5L2DdElwlTQ+bsj6Rw3PzMfZHoqIo2ODxzET80/+am2vGPtpigPfMr/LGeP627xALEnSe7g8LYIpTzqL8MIUPJPtBqCVpQabUWKngXwqUSNuMl9Lz3+ENXiUmO2wn91zcUIjaWWTX6voU/mlj6LAJ2zOXAAmKE/AaQuOGKkj7vVtjl2/8Q6sYcVgPbSm3CMLoj0rGH8kRarWDORhNHvNjoSY7yzaeZANlqPdvPAQebgs2ft5LLe4l9TIu6RKpSKIWhmh809pOA2rotI0Q4saaIye42FD/a4AZhL2hY6KTy087jgz3SAR+jdi4JZVpUH3IpnGpvhWItGOlmjjJ3/Mhh0fve303PE25cax+l13NRrEkmYYlRmLF1AQnpYbhM+H
 XZp5Sdef
 DPh+KUt5MKugYhhCQn7J6VeJ5RpoS0wPexT2EyxZ/CcmBXPz8MKGiLKduraGzWKp/Voc3/CEE1cj/+3xdueP4oJ+sRN5DxciUOxkCakZfHp9gaUMH5XPQKVhZLMqV7atkgMJHoKWn5y7UNMHfOkiD2pB5oQemnn3KEJ5Dmnh0bo+Q0i5oSP3dlxjlT8XDQq0oZc6HLdF1XbkyycQgqL4HZEv9XaJ/FrrtGPcgN8WhpCsCL2r9SNtJ2HugHcWbnGEaW22XZEwWMgCQArr+EBggB+K9PXYXqTss05Z4oL+DnIJMJ8kz2fxIiB0rBMzTTdnpQrG9nX26dzFDaPp7s/Fq1j45JaOXS0gyOJN8izRJhjTql15jI3Rs1rAO4jW/o6aZyFKZly/WFQ7l1vh5ysl7MEuu5XnTt21IS/1RGaJLjcTZZL1/rGAMe5duS90rLx8Yw1v3DsLYwBAl9eWQl5l9T/QEOaqi45LVeU0xB/tIBWSfzm2fkztXSDxjfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 10:05:18PM +0800, Boqun Feng wrote:
> On Sat, Jan 17, 2026 at 01:29:25PM +0000, Alice Ryhl wrote:
> > On Sat, Jan 17, 2026 at 09:11:49PM +0800, Boqun Feng wrote:
> > > In Rcu + RcuOld design, RcuBox is just a Box
> > > because these two pointer types handle reclaim + accesses.
> > 
> > How would that work? Dropping my RcuBox<_> must use kfree_rcu() or
> > synchronize_rcu() or it is unsound. So it can't just be a Box.
> > 
> 
> RcuOld<P: ForeignOwnable> will call synchronize_rcu() before dropping
> `P`. And I think we can have an asynchronous drop pointer type like
> `RcuOld<P, Async>` that requires `P` is a type like `Box<HasRcuHead>`,

One blocker on that is Drop impls cannot be specialized. We probably
need a different pointer type like RcuOldAsync...

Regards,
Boqun

> and the drop of `RcuOld<Box<HasRcuHead>, Async>` would be `call_rcu()`
> or `kfree_rcu()`.
> 
> Regards,
> Boqun
> 
> > Alice

