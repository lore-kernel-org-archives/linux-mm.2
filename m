Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9D8C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B389D6B0168; Mon,  5 Jan 2026 10:41:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10806B016A; Mon,  5 Jan 2026 10:41:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12E96B016B; Mon,  5 Jan 2026 10:41:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91E886B0168
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:41:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 407261A0193
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:41:21 +0000 (UTC)
X-FDA: 84298324362.23.DD98650
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id EF41AC000F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:41:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SWyXCarH;
	spf=pass (imf10.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767627679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6BA1g1a3pdykyjLkvUREMTVpM7/WCPoUOv36P4M2nY=;
	b=nAC7tcTT8sMyNJtHRsEoZf10OLwQ9CWxX7w2UER9iFTCoDptbIw2TP4wmotyRIj2wuJrpp
	YqWQHP5SrjXaARYA99M+mfU1PpIWqrlPnpFehSPj7zcqgANcO9yWbP872Z0hmXi+GNG3n1
	RhPz10DHNq7Om3dLwJ+WnzehIa2q9Bo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SWyXCarH;
	spf=pass (imf10.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767627679; a=rsa-sha256;
	cv=none;
	b=Dk2pTM41DWOo8Ze9a2KHlWPU7fPZ70nkVBVLmIC211E6BVHsehXX2bmn84J74zxKfKmcne
	+xoYTK3I7seMzY3O4PbeiL7rqobj1rHEp8qr7rUycPhmo025royZRVtbBqnRRI/OI984yH
	X6Iv3edal4tyU4DxhBezWvpX1aXcF+o=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88a367a1db0so242333216d6.3
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 07:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767627678; x=1768232478; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r6BA1g1a3pdykyjLkvUREMTVpM7/WCPoUOv36P4M2nY=;
        b=SWyXCarHpBGknaUSg/UqN2hcc02/BOh7hnMjgTZc2dvwAjpzP4HQ6HZKwS/J4fvGWA
         3PiyvJj5a0RT5GOKrdfwfe1bxDNhaE3Up8chh35mmXn1bTqKGXfOOyLFnuKnRGf8tFlM
         mncdcrDHYMZkImRP4Ao0DTk2lPuBH/NmZyF5re8iN2/t2uR01OwXZX9Ewc1fQnB3kbGH
         3RBMX63LXll9EOkDF1qTzQxjqiH/YLwSQZ2O8uZGKSxddCjZtPu/YnFw+aCK7EJxbpEs
         eTTP+90VqF/E4y0sbJj3IELoLVBubOxzaIQXa7qvlmnbNciVOAKqFCQtG30YkEh7MXJF
         XU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767627678; x=1768232478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r6BA1g1a3pdykyjLkvUREMTVpM7/WCPoUOv36P4M2nY=;
        b=cSn6LB8pIeilVQXitjF+OKnzUIgoKNMiLZ8cbkvLkhof2/3B4WXm+wnoeMsGnpgSzW
         DrJcIYM2jb6b8GCfqvGYQUY07ObUn6leAXwaPJTXIiZvYhZn3A/SVZt/eQ23kCED0BhM
         onngkkWysREI6SvHqnatOl/vsZU/a2/RTx9HtZPShEvxNJaFOK+L45WEq7sKrb9/2d6B
         KM5CEY0BYdkjWECFjHd/3AeZFlAUY244ly274PtEc/hIfe5T8jJqp5K7wmOSOp4EF6SB
         V8fP8cudVj0NThqJ5WIjFiDgWlCmlQsZSEB33fR50fp0HUqFYG97jAbgvIq1aa10TJPh
         X2Ow==
X-Forwarded-Encrypted: i=1; AJvYcCVSRlzCQsu7TVJ7uVidsCyGuMN+O/5dZ5HMjjXQAWUL0qL50NliSLuS1JRYDbmkV5IQExHXsLFJ7g==@kvack.org
X-Gm-Message-State: AOJu0Yxu5cbIn8LHbZeOEyRxkvL/ARrarOGMogELcNyYWbyCm16/hMjg
	1M9K5hR6Qbh9X4AdZsDlmpkBmIupB3/zs4WYWQgrdBd6dX/wz2oiYxCL
X-Gm-Gg: AY/fxX4e0RH9/4VR8lX9ZGfr4bm0R+ozntpQakdilmjO0q2kFCMVQt2cwKj9OUqw88O
	uslKv+lO/dPocGNXDjWelM0kjPwsgpeVmiWjGHhys3MB009cWIT7YJeeGXzTemnd94EaYkBxUdE
	9VxOovEO1KW9OTbBu8HAWgnE9EVRgLwY2yhCfTilO0sKZvCY1luYHtSyQoGkPU0WjkOESozdNlb
	ndBVPlpJWVyMZQ1D8dAXcUQQIPF8UhpA1Q6QZa/vfBqcDelaBOnzjLPeDW9dKHh18EUEfGAKyjz
	W77iEPQbFEF1fm0JWdnnwqNqrz9DtxgfUbUKwKB9+kug/VW3UvmGqf7T2aRWRPg/FFKecMXvpHl
	uLMpx3esQbRrX8/UzVAd/ffa5LybqSwQjq+5OlMylSb7Ajc+E52gKoVqGJ09n0U0JOh8zaKOwsy
	X6EWPvJBxQQJbXHDLITrQWSy0a8TahRmZLyOtepHfkA1jtNOKp6DJzqEdbbKAsobfhC6KrysCZN
	itIIUqn/jJhkz8=
X-Google-Smtp-Source: AGHT+IFcWhopwSaKjTCty9xmTi8J6nU5610w9dE8RcpeTOSxGCXk1EYPkRdikqmONExTL9dAEe+Esw==
X-Received: by 2002:a05:6214:1249:b0:890:4f86:495e with SMTP id 6a1803df08f44-8904f8649bamr161313626d6.39.1767627677769;
        Mon, 05 Jan 2026 07:41:17 -0800 (PST)
Received: from fauth-a1-smtp.messagingengine.com (fauth-a1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890753ef0f8sm1464776d6.14.2026.01.05.07.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 07:41:17 -0800 (PST)
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8F0F5F40068;
	Mon,  5 Jan 2026 10:41:11 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Mon, 05 Jan 2026 10:41:11 -0500
X-ME-Sender: <xms:l9tbaQl8adq_q8oemVdp9py9aCB5rEYMUXGPUHOfxSENDh0M6SOSiw>
    <xme:l9tbaVrCyG7LEDf5sozj9kkhyLQ0sPqK87jUAC_qJfbekq6ICe_xe5QMuMoTjEKUA
    tB0zjAhiqSBWufmhb_KP365bDbxKmKQ-BUeRDG7AXs90zPIyqpX-w>
X-ME-Received: <xmr:l9tbaTuvJMNXCwyVLLEQxwAkDuZHya194bV4WrOdHwOVBYRN60UCxK-j>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeljeeilecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhnucfh
    vghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrthhtvg
    hrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveeiudffiedv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqh
    hunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieegqddu
    jeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvg
    drnhgrmhgvpdhnsggprhgtphhtthhopeehkedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprghlihgtvghrhihhlhesghhoohhglhgvrdgtohhmpdhrtghpthhtoheprhhush
    htqdhfohhrqdhlihhnuhigsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epghgrrhihsehgrghrhihguhhordhnvghtpdhrtghpthhtohepphgvthgvrhiisehinhhf
    rhgruggvrggurdhorhhgpdhrtghpthhtohepvghllhgvseifvggrthhhvghrvgguqdhsth
    gvvghlrdguvghvpdhrtghpthhtoheprgdrhhhinhgusghorhhgsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehlihhnuhigqdgslhhotghksehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtohepfhhujhhithgrrdhtohhmohhnohhrihesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:l9tbabmkDu5goAML_Vw6wQks5sr1-oqWVGEVyl7SpncPG41qLq8PqQ>
    <xmx:l9tbaZEvXpCwph3gfl5iq-kHa4fsrJ-e6g21CjltgBbR441YOY405w>
    <xmx:l9tbaa8pxEfCJ2_idKerH3733Rocx35rGJlDBn4X7HlKs2MkaFUX5A>
    <xmx:l9tbaW7nR-qjUaIEByc4-kPNbC8tpKXp-OM_EvS1h_evQ7bx_68mJA>
    <xmx:l9tbaS4UkZJm3L0Tu3phQb3ItLU_OD6WXZGJ8xIIxpleNVBlr6HjnmTP>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jan 2026 10:41:10 -0500 (EST)
Date: Mon, 5 Jan 2026 23:41:08 +0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	Gary Guo <gary@garyguo.net>, Peter Zijlstra <peterz@infradead.org>,
	Elle Rhumsaa <elle@weathered-steel.dev>,
	Andreas Hindborg <a.hindborg@kernel.org>,	linux-block@vger.kernel.org,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>, linux-clk@vger.kernel.org,
	Benno Lossin <lossin@kernel.org>,	Danilo Krummrich <dakr@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,	Paul Moore <paul@paul-moore.com>,
 Serge Hallyn <sergeh@kernel.org>,	linux-security-module@vger.kernel.org,
	Josh Poimboeuf <jpoimboe@kernel.org>,	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,	Ard Biesheuvel <ardb@kernel.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	maple-tree@lists.infradead.org, linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vitaly Wool <vitaly.wool@konsulko.se>,	Rob Herring <robh@kernel.org>,
 devicetree@vger.kernel.org,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Michal Wilczynski <m.wilczynski@samsung.com>,	linux-pwm@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>,	rcu@vger.kernel.org,
 Will Deacon <will@kernel.org>,	Fiona Behrens <me@kloenk.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,	Ingo Molnar <mingo@redhat.com>,
 Waiman Long <longman@redhat.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,	Lyude Paul <lyude@redhat.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	John Stultz <jstultz@google.com>, linux-usb@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Tamir Duberstein <tamird@gmail.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 00/27] Allow inlining C helpers into Rust when using
 LTO
Message-ID: <aVvblLp8sjFB7JvB@tardis-2.local>
References: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF41AC000F
X-Stat-Signature: pqwmbagy7waky8n6d6zci5xk3h4cp57g
X-Rspam-User: 
X-HE-Tag: 1767627678-764911
X-HE-Meta: U2FsdGVkX18I8TWnIc/JWbRJn60iVr/yLTXOBTyWLqeSRwdaA9aohsLiKr/JVpzX1N0TsZ9EeKU8T0IhEu4Qkby28r48147Eda3WKVqkLLZoencGno1EcxegYb5zzA2QRmWKj55zoVBOfatS0oHLyXvK1/F6F9OWCdBMF91A37AWuIe9fb+gT3UF3raWWiljcL0VX77udrZ9w/lIyKK+JxvPvx00xu51djbpcPDEH+fH8DHVIeQUeH5NWsbH7v3rl17p2T8XAngij8Q4KEEtnIuvRgAJ4L4av3E7UdgbzPHasLzie6AtjBCUi5t88kUIg+APzO32SV4dOAOv0KjmXgUnSA96UD+jzmuXi56KuTWyhhp7o9/5tLWZxZgA63TAEkcaXdt52UeWfYCvNkKZUunwQx5r1dpqwo/dnPC+CMGQsCs4lEN1Gn9ptMY5OZo/ZrCpevD/cPk/5Vbz3j1x8eKYrEx7dmt8Dafx8rKs2mydi/PNy7FLtqi/Heb9FgG2WxSJT+GuliBeVAqNKgV/3W4jcPC8xVr7wM8GWTl4nyb0I8Wu7lJgK+B7IenSMSszoO7Ix3I3+pBVGnLsZz2ss1SM1bTB/8K4bvYET8bJiED27/gYwo8HaJPLcvbxHeFJ5xkwyOQaEJks5NNWTjjhNg6c//z3TYtHZ7pen94uoM0Er7vCAHaHjw86DJiXUukyIzH7LCR/ZZl0uQmR2yB7fhsdEMJjFSvgLCC+v8qpQBWd3cD58sn2cOw0KQyAVJcfvNTNpTIC4IjOb8CfECHVLMm4oa1jyaCMFXecnlgp4Upks1bWY0F6DsTeTrMVXYlKQiUZjNRjYJHUW6gQ8ibF+B5Lk9OIgSQepsyv+IXiKWXR90M6DW9yi2EDSmXChzbhe2AwD/QhXMrbYmL/FcgjrwnyDZD/a3vOCB9fu4tL5p7j300X4sF0FW3WgYlyf5zpTA18+NHnfP16T9naBtV
 mRQOo90R
 s8gbiccrrfMQymfT6oe/AgM6Ie0z+Drxg9d8G+yRl8GVZWyoNtznDx39LBy5oZh48FYo1SYuIDO5PDa0ea8TdjhCNueNdBE0nwv0zF9cROR2ZjivLD15hDR1KZuTS8XCgR2rp5n8VcsJQ0frbV9Eiw1GaHYJFwOhZsnSrbM9Jh0NforO/FH5LYzSe5HxII0MfU7L7Y1im1TuUHPdxte2MT187CCPmI8LnK5mA9pknGzcjygnq0kfw5wMMLrpjambXuvYSHVehKWwbTcgrNCzLwlytKaANDMW+yhs90Yd//6DxftrW8Dfv1Gtvd8vvyfmMrarPt15U2z6k4gbRxDljzdVVPqQxzmRxl4nwS3GOdP+5h+geJAyrdyOVvPq8KyyYBxiSjLu2fnXv/+LIWJeejaOi2ZcxZZUQ7QsUsycBGm+rEGQQFAK+cF+okss8hdkg4hjz27VsxdTI9xhWTku0DIJnHUAYqNzlxFd4p3r06PIFNesRHFk8pKbCp+Vi22nizJLtZzfb3G2c5iQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 12:42:13PM +0000, Alice Ryhl wrote:
> This patch series adds __rust_helper to every single rust helper. The
> patches do not depend on each other, so maintainers please go ahead and
> pick up any patches relevant to your subsystem! Or provide your Acked-by
> so that Miguel can pick them up.
> 

I queued the following into rust-sync:

       rust: barrier: add __rust_helper to helpers
       rust: blk: add __rust_helper to helpers
       rust: completion: add __rust_helper to helpers
       rust: cpu: add __rust_helper to helpers
       rust: processor: add __rust_helper to helpers
       rust: rcu: add __rust_helper to helpers
       rust: refcount: add __rust_helper to helpers
       rust: sync: add __rust_helper to helpers
       rust: task: add __rust_helper to helpers
       rust: time: add __rust_helper to helpers
       rust: wait: add __rust_helper to helpers

Thanks!

Regards,
Boqun

> These changes were generated by adding __rust_helper and running
> ClangFormat. Unrelated formatting changes were removed manually.
> 
[...]

