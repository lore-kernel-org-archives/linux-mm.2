Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01981F506D6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4418A6B02A0; Mon, 16 Mar 2026 10:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 418C36B02A2; Mon, 16 Mar 2026 10:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3253F6B02A3; Mon, 16 Mar 2026 10:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2279B6B02A0
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:05:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7675B7426
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:05:46 +0000 (UTC)
X-FDA: 84552099492.09.6F6CD9F
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id EDD861A0018
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:05:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ivylAtgw;
	spf=pass (imf19.hostedemail.com: domain of 3NA64aQkKCIUjurln07qupxxpun.lxvurw36-vvt4jlt.x0p@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3NA64aQkKCIUjurln07qupxxpun.lxvurw36-vvt4jlt.x0p@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773669945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPjHmgruixhmkQjw04sh9Mjy1u+NZy/GWXT+thsthOE=;
	b=k6Jm5wgpZK/RBVZpH+fdhX9R26lw3PM/CADQOEfwzEixRgI2skbfNaFCoF9Hl8ADoyd49n
	0VaiWbe+r6zarmRNeT0vokyBz9kY0W2M/18Zy68foP82LllLjmke+O/OV2p1g4thfF6sr0
	J0urZragr5bMMh0/YFQD2Qow7WLT7ag=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ivylAtgw;
	spf=pass (imf19.hostedemail.com: domain of 3NA64aQkKCIUjurln07qupxxpun.lxvurw36-vvt4jlt.x0p@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3NA64aQkKCIUjurln07qupxxpun.lxvurw36-vvt4jlt.x0p@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773669945; a=rsa-sha256;
	cv=none;
	b=y/8satRJstUEauzjsj6MADYqaLMVopMzuWK32LJSEFXNjezXeQxor+7vrI3Qo6uoKfbIdQ
	rYF0JuINA2UVk31iffqCUmdQDE71D09hgXbZuDJcRKZox7FpeelDXiaqT56YksRx3gaYzs
	KZFgEGyF8MvEH3P8FQw6fQmkaZKhmYw=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-483786a09b1so46122255e9.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773669943; x=1774274743; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KPjHmgruixhmkQjw04sh9Mjy1u+NZy/GWXT+thsthOE=;
        b=ivylAtgwxGhXXx2MLPpM0l53BNNHxkIWyxp2Et1x0oMZ5Py+DBrsZU7wT4CNMG+ImE
         sGEx3wc1CPof9tt/CAw8mfh9SqQFhNMjCKr914SqdYAvLX+TrDGq4aKg5ffsToxGWnfl
         FsGLFTNWzO1N7HB9CAx+NFwGSyJibcnrqvQ1P3uM3QcBJgcuT1y3OaZwRuVa4jIhn/+y
         9JTDwTFlfanLZluyb5ouRyexzikYB5s0yVrThJ5yhndGiVY/5y8Vu31DtHmu7pmYEQg2
         cg/uQXr3bB9mf19YS869QGghhNfEMnljz/6OlGx5iGn/2oFhK00wWv0Fnh9K3tu8z4bL
         bOgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773669943; x=1774274743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KPjHmgruixhmkQjw04sh9Mjy1u+NZy/GWXT+thsthOE=;
        b=lhnWq4uyx6VJoW+m9YqKK8BZy4sbi+tpvwY5OHIixjXi/rx1nykYxnyb//Gy92ZDmJ
         rDcX7kM+1ZhZGRe7tdEbWO3rv9h+be/9mgamboSid2pjQ0SR6UhQ7LbJngxs7V/wNu0P
         61BWdK5cO6mEEOVioyeMVrKStxuiMWTEtnbVI5j5lmLgDdEPBtPNv8NKdC/loMgm1dNB
         HY5Za0mlf5Qp184Ofn+LIxgbifQqjqh/1U3VftsF2Rr87OvEfjBsoEnRm5CDxfGXnwQk
         Cd5S7H9+vIwDpHL+cnb3z/46C3k0emUzNHeXCP0HNp/f6DF7rj7LuQjQfIBW8FQBEcha
         hJpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUv6lIWeF9hCFIq1do5BAf2AfNNWb1aK2pdTRnJKzhs0jFP7CmtHjUYkm7GkNd5OOMkKUCUZKgdQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+m5BGEOKwrCKoPNp8/0MVxpqt6S5KNAxhLCM9wkc6qENi7ISa
	sY0pXyUaQVJdjX8NsLZ62OTTOpfy1W0drF80uw+U0aJuEigA/kd1hqVzqV7mn5OPlhlhyKQkaQu
	CfZqYUBkA0XJmqzApag==
X-Received: from wmqy12.prod.google.com ([2002:a05:600c:364c:b0:485:408f:802f])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:64ce:b0:485:3b34:2f62 with SMTP id 5b1f17b1804b1-485566d0c13mr212567075e9.14.1773669940884;
 Mon, 16 Mar 2026 07:05:40 -0700 (PDT)
Date: Mon, 16 Mar 2026 14:05:39 +0000
In-Reply-To: <87cy13swpw.fsf@t14s.mail-host-address-is-not-set>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-15-de9a7af4b469@kernel.org>
 <Y7WTRL6v0WsR-DWju2vumM1EBu4KZgQzE0VJul7mK3pUwD6ba0UuQO8sclDzOaeLGGh9u3WG5iSKq9T3kQqH-Q==@protonmail.internalid>
 <abfe2LbhLzXiGCkA@google.com> <87cy13swpw.fsf@t14s.mail-host-address-is-not-set>
Message-ID: <abgOM3k4hmDCSkon@google.com>
Subject: Re: [PATCH 15/79] block: rnull: add `use_per_node_hctx` config option
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-block@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: EDD861A0018
X-Rspamd-Server: rspam07
X-Stat-Signature: 4ue345gacmc5uoyrdk3q94gmmn78hixi
X-Rspam-User: 
X-HE-Tag: 1773669944-105501
X-HE-Meta: U2FsdGVkX18Cag5q8CT63iTXU5YIoG6kZS5Y4hFtEQ8FUf6QZkiA9SC/XMKkPks+lWRYQeadriRjc1mazZm+GTl1kjopPjFbiTU/ZmpqyJARPr10feHT11zX5SMeUNQv18tX59EYzUaaGUKLgvLkGlpG/RpLLp8mW1x29Cm8tsGP3WkBodgVShqZEfo/arFehbtEm5CBN9pGRkps0oCsY1+63JykT84QwGCZCRgUBjKkr3kZlhTh7F+a6sS2XXYiIb/2fZN7HRBIVT8Y7ruY20HsPOKvXXgXSDWl4HOJUPjovGoHg5UIe9g/ao9UcSu56Txwvh/Y+dED1HnkSTioIvm8wUueu64dzg0qPxYwmxHWFE5SxK5iMldhi2WBGFchBTNKk8wqRT6bV9692uE2VbKgazeYNV1e+tIMcaptTFK/viXGcYuSrLiiyxesCnFW22mbg2YarPKsTZ08zfiA8YR7PtN5t2VJQnCo/yVatPX5I0arxwLtLFGz1J8gLMBQNuXW5JIk0doM7k9ADBFVyB5m4I+NSiCXAJVi4U9n0oM9MpN/b48igJ587KNSNY1tacIljYS8kQ2UKagikIC4XMtOgFozoV7IZhUDDt+3/3pxjOIXqKRaCkAuJG0N3XflGVU5A3soWcbzxEF3s1w8yGooX93Kg6A/RFNd+ohFawN2AOFS0/l6MN4b+8txrPf70CpMGoDuDf4tZSvUsv5NtUyO1e222w305jRnZ7FzPXpLw/m/MIvhrOH6P3PadvVzmG8J+uvEI0Z+bo/DRzb9DgFpHAl2h+L/0/kr2f2FA9Uf1woiNrza4wIlqeWJLw0FNKM9ry3SsIwFkmSVMuFjNGHJAyNUS9cSidXUxViFRBEEZTIjwS/dnVT4RPVXgmWgmRIuJ8bcnzZcqnGT6yU9dHR4Qmcy4735mRo9ac/iqlDu/b8Kpj4nBIxP5GyplAR0YjZpBPm3xJhrosG5vBc
 VIW4pQCf
 9IrPfETw6/nvQM+npUVkDusRpnjmpnwYOITATl1pGGCRqsQdlZOM84w9AsL+YeZLZXk2FFUfZg+NWW7odKcMftUM/d+6ZJg5CcRJKv7T8snFUtJcFsdPxKpLXZ2dMuP6QRVlL1ZCjg+0W0FWImzerlqnoJ7I7tnWnmGB5ctU1CaTrzi2VRqIr82d0p3KaCrz43LKGz1sP2QTiW4xGY6mwXnDFMQnl8IE+OM7CZ8wcjUpUbQ/c7ToLjy+BFYmZqvX+hf8F3xj2vskJCDfu1ZvbeMGHBnpbd8bFWi0Xplkp/PjjxrHhpS6O9vq7HWcT4lNvD24LBg3vA2RrzLTa2TpqXRsbwLkJfXeHvGkmcYRyHKxSrQBjo4ctAPayBkD2SvptuGEHkL4Y9fDQOMMIoz5qR9RXP9faBCddIYv49fAqo15BoE6c/SDGkuLjDI9ttfKkr9ismP1trLVxBrHIFiJJeFZcDeJrGOH1YHp/6kt3TcX5HU90dS8z9s/bmUppY/dhon7Y94No8VjvQLJKdF66YX6zfkS6YS9RwTnBYLN7hOHM0ipf5kEKYr9eNvUR2SfpKgtZdutj40yNKCdFjYnBbu2GuT26AVSLRtJbNAnbw8m16Qds07auzO3yZX02qhdo/TBIv9fzzEyHQuka0OxTQwjtyNlhTvnhRIgxknvqwYvEC/72ocwBbd1Iw6MR0SjY7uD48MppImncLHmwr2nkQeo+h0r7wp2pxwJAgHtqZ6Wk6FeRl7Db+OL5Nr9yWahj+4vQTgo9C6XuTqg+S/n1TkyCqRC1X4VN/00XuatCHSLGEa87QM8nOk8ItwLTMB8z6Wt+tEhuQ9P5vq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 02:57:47PM +0100, Andreas Hindborg wrote:
> "Alice Ryhl" <aliceryhl@google.com> writes:
> 
> > On Mon, Feb 16, 2026 at 12:35:02AM +0100, Andreas Hindborg wrote:
> >> Add a configfs attribute to enable per-NUMA-node hardware contexts.
> >> When enabled, the driver creates one hardware queue per NUMA node
> >> instead of the default configuration.
> >>
> >> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> >
> > This and other patches make me think that module parameters should have
> > value() return a copy of the value (and require Copy). For non-copy
> > types, there can be a separate value_ref() method. You would avoid *so*
> > many asterisks by doing that.
> 
> Makes sense, I'll send a patch.

Nice!

> >> +        use_per_node_hctx: u8 {
> >> +            default: 0,
> >> +            description:
> >> +        "Use per-node allocation for hardware context queues, 0-false, 1-true. Default: 0-false",
> >> +        },
> >
> > formatting (rustfmt ignores macros)
> 
> This is intentional. The line gets too long if I pull it up, and I don't
> think I can break the string in any way. I think it would require
> changes to the module parameter macro.

Just keep the wrong line. Checkpatch will complain, but it's standard to
ignore that checkpatch warning in C code for long strings to keep them
greppable, so I think it's fine here too.

Alice

