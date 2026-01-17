Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B93C98306
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 00:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482AB6B0005; Fri, 16 Jan 2026 19:06:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430716B0088; Fri, 16 Jan 2026 19:06:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E80E6B0089; Fri, 16 Jan 2026 19:06:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2E56B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 19:06:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72A3A160299
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 00:06:47 +0000 (UTC)
X-FDA: 84339514854.06.D898E75
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 25A46120005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 00:06:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QiuTfhNg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768608405; a=rsa-sha256;
	cv=none;
	b=Z3NwDBXtq13QVx3kIYMZKHyZdG+5Zh2PeksLTp2A//i0+Ylw8EvSq0DOV0BTia1lLw7mj+
	eQqrgyHAsLKd664qV3Dg1L7djtZDUsT1+UESV9s/c+EZp3muHijZWhjgsssUyfcke2QDCW
	0sbrbfwlY9Q6cHKVOtdq5dDsuq+69Qw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QiuTfhNg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768608405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDkOv8xyeBo7PdDVE07s2ucba4/fDLaQQcXd3ir6y64=;
	b=VDRySqI7/vAPT6QXmo6AaNdZCl/eXUBSp4KY1n/fFE0WpDhUzWSupDx4edL9XPxA4fOqPc
	mi6B9s6CENIUFFfCj7tBnSLf/nhy4p8EnwPcOUeDvelBIlELuYSP6iHEywATJE61bQvONs
	hZNp5dl0cUr/tpnxO3u2ychsT3HqSHg=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8887f43b224so48245136d6.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768608404; x=1769213204; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sDkOv8xyeBo7PdDVE07s2ucba4/fDLaQQcXd3ir6y64=;
        b=QiuTfhNgzRvoqHNAuMsfpVekjjFYiBC2ien53CaCu8UNwlsnBuHEf/KswFSXHJ9Uv/
         gaNbCuigyEMdtzgjZhhBr3d5NRYYLYey59vTJUT/rQaJHnjId/KBuqHMNW/Ff5yrBm6T
         gSFd4gf7aXkG78EFjwnr8esQhx4x+Q7XK52souYG7yX+87I/1/SgHQd3w7gH2atgr9On
         Pxt+lzxnX0oweFdBwfDIDDPdURprpFuX/BXG/07UTVRks91bBq/l88DeAaXEtIltKNpr
         lLTf6aOlH4KRt23mqYySDJaiGh5kfXGxOfQpQgK+GvgO/Ez9/G5qMyjtzgv/ky5ar0Kg
         n0qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768608404; x=1769213204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sDkOv8xyeBo7PdDVE07s2ucba4/fDLaQQcXd3ir6y64=;
        b=pHnYWlZwP8+sgbl5Opou3JAnIsHEidMhEsq5ETDs3ddrLHYB8slORIBeBRbx1Fh9li
         AKAmbPMClGDqdifXddXMZTKlU9YAMAf4qibAB+K+l6aOY0sHG0diTfDVj1XtALO8s7XP
         Onx1YTzEj/Tr1y9YdGfWkNpjMNWss6jTVcNNb3g3DO8VsaV63zIeGt29/YL9bpzq5prf
         Mtgp3Be1JxhzR0CO9myen4Y4dTmjG2unUpG61w7JmTSE2tH0Jwj89EngIY3c/j8n2Uod
         CAb+S4Y5RJwiR8ggKsU1qwf7OgqhTPaz3d0UPpsiEw7EFSCgaDfh9N8w6Av+s/C+HOxr
         rvGw==
X-Forwarded-Encrypted: i=1; AJvYcCUsQX5DiMKAXvc+rd2CJnYw0TlYULeYSjPjqIsL+Tlo2257wTbQ4FLIvpXonYlHSpZz3ajvwQbNpA==@kvack.org
X-Gm-Message-State: AOJu0Yw0Zw/eLL9xvIhs6K6J05Bwcm0DenDyNPb9LSSZvbQQgwnoQhSq
	Mz2gfs+Fls/fvkbCCSecsKdPrMARRZ3qcXA8p3l3Rm0qQENgTtf4Zgwu
X-Gm-Gg: AY/fxX4/HfT4n5/VoJ0doE99DCNT6weOTA+GQpZsA3RXN3CvV2ka13qdVEA91K4JisU
	GR1SoLbLxVW2PiK7lJefLnM9wt2KFWjzmO2qcHpV+7fSkj/qCg89wwCHEO7qV1rNJP0Dktwft6v
	RaqlDTVWdskcJwqkTqfH13YBJUPbA7YzniFl9fLnm6k+GvKklMPBgiZixSYT9yAuCcm9goGpGOP
	UwgpTW1fU5G8vASWkj9HkrDzO6mI1hRGkx80ZlaXwJ+JdOc+bxYl4WTSwg80sEWFhgnfANT4B+Y
	FdCczpY6S/rKHioxkORtH44/vExVf8fcfqhUE2D8EvCVU9Q2b/XF3pVm3FkQxef4RfKPvqIXZp/
	mu3FNx5qiN24XoM668ZX6eKHSvD1G4tUzDrZpZNk1RyQl6nxNFDNzaNX0i2wApDGX8gmvRljczq
	pN6ENABg5uTOkKHBhQzgnSL55vOJKKFuEaWFOErwrm5gIly0OnQDyQxfLE/jJ4p4eqkpsC90QTH
	99d14DA7AAW/2Y=
X-Received: by 2002:a05:6214:5189:b0:7f1:c596:e1cc with SMTP id 6a1803df08f44-8942e2c9a62mr63452806d6.19.1768608403919;
        Fri, 16 Jan 2026 16:06:43 -0800 (PST)
Received: from fauth-a1-smtp.messagingengine.com (fauth-a1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e5e526dsm36097626d6.12.2026.01.16.16.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 16:06:43 -0800 (PST)
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id C43F6F4008C;
	Fri, 16 Jan 2026 19:06:42 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Fri, 16 Jan 2026 19:06:42 -0500
X-ME-Sender: <xms:ktJqaZjli6pSPr0lgEwuRW55b0H4U8LD8NLR3lHOGXSYxrQbmppdcQ>
    <xme:ktJqad7Q2ebf2mdrvMxHZdE1tuosI0weMpqp_qGjTc-r_uMwNX8xdm3oVVBo88oEp
    bgbKS4Ei9V7uaoGwpRt911P4XQoj3zWdbYLgocbt0Dp-SNJt5-C3WE>
X-ME-Received: <xmr:ktJqaWZp5WMcwhlHYy7JlSwiCyzKZ_MJadXzsfsf9CyJ-qdJMK281ips>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufedtfeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtth
    gvrhhnpefhtedvgfdtueekvdekieetieetjeeihedvteehuddujedvkedtkeefgedvvdeh
    tdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdrfh
    gvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgvpdhnsggprhgtphhtthho
    pedviedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghlihgtvghrhihhlhesgh
    hoohhglhgvrdgtohhmpdhrtghpthhtohepphgruhhlmhgtkheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtph
    htthhopehgrghrhiesghgrrhihghhuohdrnhgvthdprhgtphhtthhopehojhgvuggrsehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopegsjhhorhhnfegpghhhsehprhhothhonhhmrg
    hilhdrtghomhdprhgtphhtthhopehlohhsshhinheskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheprgdrhhhinhgusghorhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtmh
    hgrhhoshhssehumhhitghhrdgvughu
X-ME-Proxy: <xmx:ktJqaac7GCuaHwgTeMm0CU46aZa71lO254tPUYfOJTYnIkQG64vhng>
    <xmx:ktJqaT5FZSWzmlGLskLIJJkJ8VeOpZRTfg5LmlEkXYGgfvDHZy1ttw>
    <xmx:ktJqaWV1VtSnPpJ4juZeUACUDbCYRq2vgS98xl_4viBjOZw038X5vQ>
    <xmx:ktJqaaZ1tQM38pJy5xhs8t_-UQ_m75VB8rd_OfxBiH4VDSrwBa0-XA>
    <xmx:ktJqaVzUQm-GAC-h9ll--b7tadH8zpOT6MqbHzKuHn-RYqIr994ewhOu>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Jan 2026 19:06:42 -0500 (EST)
Date: Sat, 17 Jan 2026 08:06:40 +0800
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
Message-ID: <aWrSkAPFkdH_tvtN@tardis-2.local>
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
X-Rspamd-Queue-Id: 25A46120005
X-Rspamd-Server: rspam06
X-Stat-Signature: x8kcgxxq9mu839r556tnq3djxh3gexd5
X-Rspam-User: 
X-HE-Tag: 1768608404-424344
X-HE-Meta: U2FsdGVkX194oGsobGeAV8XlAihGDxeGHQxgsqzFZ9unRLFqZq2UPP6LoAiGZNatNsc0kHZAiv6RwBaEhFPBr6D7icmhEkgjZG1y12bXVfJMEQ7f4J73n7Jd2/akO0d8f7pbwYQLZOVZJkRMjBd9y/geJOBG7Jpi58BHRZqiw2EnBIuVSEMsY3PEz2llOfeVkdBMVpq6jqZF0az8a0bFngryGARLZxFCx6jgGBtTrjSDt9yOAVcLU3aafPYpubfH2BIn7E2DQeieQGTRqolJCZ7wpsbGCljJpFA5YKOhk21c5YdJaBpWsNOgv7NjPKAyq7RZC4NzbRWYrwSl5XuzmLqzmO9sqfGYElhjuKkA6KH/W/jhyi6TmZ8BXcNokgKwM7aTBldPADR9bcnebjkAZGMqMaJlQhbVBRD7/rfgymNTUVQDlGl4nKjcfUwB0dRQQtZbSckDDDmX0v2Vzuh6yFny+EiWc3EbHXHHVgKIYTQLTW6Grvp0K+Mkpwg9zBDyM5Z723athpDLEnagbcSQrLTi7ddoJE8Zq3u3xtLNSNfsoMkO3ytrIMKyN78L52IJIf4BqowhU4TdH+h6aIDnRgpyvAX5P7CocBGUxAiZKCU1lLREZ1/b2VueLbbr4Sok9V93A46DDaysvADzj2Fyot74Ttxopddx7uKsikioICFkHF2pTBb2jCfFH75bc1OSPAReljU7udGcUAlI7maSIp6M7BRWPAg+obKNy7hoKRKa5r6bFMONB9750waEgvihuUk8GDnpsC6LSYPAGyz+nPiz144RMexfNzLOeZ7xS+oX0VQbt5XSL4/QbNa/ZI8WRmW4k/Auej9VJoFW7Wrw9z4LquQlPfPojksC8ljNUZfTAWO6CCrAoOqtbFQVg3E+l4AXfF9fikQNy4PK7+FgRw4pQRORy7TqKjmnTzIGTc/0Ui/97v953JsuNl6nOmaQYi6IR9Dq9UwWjl2pGU4
 H6oEYKk3
 0+iHRCdb57rap1mniTADQuHio62N69k9O0QphsfLMxmR63joGBrJyGC5d6tle7+rt8gvoOkYVBfx+aJV0QZ2dc4F+IXs7WhkG9SGjQ0pHYYaulhINmQYkXXyo91o7N7PZzZp/mUJZlI/dxePFjpdA6EQ4CRxeiMLgLpY6X14wYr+7DNraaU2WGlSLscxtUQi4ddFKa4qnE2N6t5J62YxWG8+kXxb6VC3zlecBaYrcaH6TGFu+aXW56izqOOackgiP3tCnXrntCdUf17yHTXifRVuTsQeJqfS1//KsqJbvytATO8MGzIi8V5Dy3Tg3Dlhn2nu6L/Hltl+uMLDOvXBykzRPQKD705dgaQEHGQ+m3v7/8x/BcX0GlFwWUFmleJPV7WP/MTBdlEXJX1IsXxz657r0NMtr6zsemq3Q+5nY98DDOZU/EhYUpZIG9RPfStD/3222VFULfMVMdE3IyoFQF4xdLtyBMcXedMhqdz+ee1IMeuwu+B66ZBRMfA4zdX+ZWTD9i9XF5iDH8C1ywpkJP5FozkuyKsH2+b7eQ9W74u5+SfKK3bM/psrE98wg+xtK+nUR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:46:35PM +0000, Alice Ryhl wrote:
> I'm sending this RFC to share an experiment I'm looking at. This may let
> us replace the range allocator in Rust Binder with a maple tree.
> 

Thank you, Alice.

> An RcuBox is like a Box except that it lets you obtain a &T that
> outlives the box by a grace period. It does not allow mutable access to

I think the `RcuBox` can be folded into the more generic RCU pointer api
[1], e.g. Rcu<Box<RcuBoxInner<T>>> where RcuBoxInner<T>: HasRcuHead. The
benefits are at least 1) we use relaxed atomic read for RCU readers
which guarantees address dependency that RCU needs under LKMM (while in
the RcuBox here, we just use plain reads), 2) we also support mutable
access as well.

As for the progress of that effort, the Rcu atomic pointer is almost
ready [2], I will likely send it early next week. For the `HasRcuHead`
part, as you may be aware, I'm working on a generic `HasField` approach
to avoid duplication of `Has*` trait and macros [3], that requires some
syn adjustments from Gary and Benno, but they should be available next
cycle. I will probably send the patches for reviews before that. Once we
have that `HasRcuHead` should be easily to add.

Given the WIP code I have, I *think* we are not that far from providing
what you need for binder.

> the inner value (Binder would probably use LockedBy for inner values).
> 

[1]: https://lore.kernel.org/rust-for-linux/20250421164221.1121805-13-boqun.feng@gmail.com/
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/boqun/linux.git/log/?h=rust-sync
[3]: https://git.kernel.org/pub/scm/linux/kernel/git/boqun/linux.git/log/?h=rust-field

Regards,
Boqun

> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
> Alice Ryhl (2):
>       rust: rcu: add RcuBox type
>       rust: maple_tree: add load_rcu()
> 
>  rust/bindings/bindings_helper.h |   1 +
>  rust/kernel/maple_tree.rs       |  52 ++++++++++++++
>  rust/kernel/sync/rcu.rs         |  31 ++++++++-
>  rust/kernel/sync/rcu/rcu_box.rs | 145 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 228 insertions(+), 1 deletion(-)
> ---
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
> change-id: 20260116-rcu-box-7a8e4c9f2180
> 
> Best regards,
> -- 
> Alice Ryhl <aliceryhl@google.com>
> 

