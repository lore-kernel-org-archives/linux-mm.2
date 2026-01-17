Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B603C98321
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 13:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA18F6B0005; Sat, 17 Jan 2026 08:29:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D791E6B0088; Sat, 17 Jan 2026 08:29:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7BA66B0089; Sat, 17 Jan 2026 08:29:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBD336B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 08:29:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DE40C1821
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 13:29:30 +0000 (UTC)
X-FDA: 84341537700.29.0964C07
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9BF4E1C0003
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 13:29:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IZIjxBMf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3t45raQkKCNQ0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3t45raQkKCNQ0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768656568; a=rsa-sha256;
	cv=none;
	b=ZWNlBMX9y522ZdA4YIw740DBuojuR7KraM1NcRKeBQsf+ZpWdUyktwg+9Whp/OLBFAnyX9
	DaLs00uRJ3ecmB8kSLXvYpAjJ6VeSRFUOuBbUIlxRadHgMzZNztSvi9F3wzrGds02zxwfI
	ojBnAy+1etGu+LogtzqAIFGEzXgBRcs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IZIjxBMf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3t45raQkKCNQ0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3t45raQkKCNQ0B824HO7B6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768656568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGX0/BmN4QSqMec6LsJaLEgukSwhg32D3RH18NXGaE8=;
	b=6tIzC0EvBAFw5MOgN7eXb+YXrRz48BeQT7Gv/1PKuZg9gG1301vYUnaG+5DsE55AQ80XpF
	Fyvk6Ymo8Rqg+0rqrnVt0o8diWH0pAdYo+k1PmfdY2chYkK3IKtGbAlPAMyvAujXXv1WSB
	Jpy7qsuaIjyA3fu7sfLeupu9i0wDOLE=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47d3c9b8c56so43560575e9.0
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 05:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768656567; x=1769261367; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yGX0/BmN4QSqMec6LsJaLEgukSwhg32D3RH18NXGaE8=;
        b=IZIjxBMfHU6N1/u470+f85AqSqOoXU3VjFzWpoN96I25tLb/U/as6wfuuQNHmmBpzn
         lYUA1FK8+rsb2xbm7mh1Q8wRMk+ZA7/DPiia7QOpOQJKGW5jvtG0Dk23OGVUZd1ttfip
         mn9fGFX8tvhrYOaBOBW1xfVrSWOtJeVv3cfLP6fhBy/PJMZZ0c0Nu+0WxPljNlZCY+/I
         HR/Rh1IP16G2vk30P4ARWELLQCoWZRDmTECWs0P0YpJ8d/zxNXIGkxMb8v3eK8GF+xCq
         UGF2A5z/SRaf87ohZVk5AwmEQL9idhSnZ8DDAwp280lFyiX/ZjPRmXwq5/evCnYfxg4g
         ODYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768656567; x=1769261367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGX0/BmN4QSqMec6LsJaLEgukSwhg32D3RH18NXGaE8=;
        b=S12PiMLorY1WH5FaqnlSxZNvjCArLSmXQeyGYB7kb/b4+aILQbFE2f6KlYgCNVaO0V
         cPlCezzmqmL2Eys4KvwK1K52+OtgL7yxx1cHRSs4NQCpu4Ne7L2YPsFfMt1DUu+2lurd
         biRQbO74rukhf/CivZM9kos1G0CpT+Cij+iKxvWAoIlZHSqxMLm3kEskA7S6lab+r1Sy
         EN5w09ERnAYxZ1XpoMC/SLJS0GCmLbBdupaQRC60M5JNZafm9dnpz7MUjhF8KHqzIPYa
         wjwIXeanNH1PkJN4LjkhuY3/T0ofsCtFC5O4ChotO3zo6COHmbJqNxcbJJEdkA2zs46F
         LtVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWm3E9aaikIVO683UW9MeEx0S15/I+7qLrkku1Vr0wKAF+vhps/f/OpkgO6q8rPn12xJ8ncVHmoNA==@kvack.org
X-Gm-Message-State: AOJu0Yz5Bz5oKeoMcGyTZ7d2F9qpolg2th4C3dIToCVFiU9QTyWpWYqA
	Sx22S+6CpL31a2u02fBVVkR8ks/3XxjwxXOE59st4WvlcP4MdNDBXTZuCM28li4VRlZpQLcmq0M
	xlsE8NLxRgkTx8meLAw==
X-Received: from wmby1.prod.google.com ([2002:a05:600c:c041:b0:47e:ddf0:fd00])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:35d2:b0:477:b734:8c53 with SMTP id 5b1f17b1804b1-4801eabf1c9mr75158475e9.12.1768656567159;
 Sat, 17 Jan 2026 05:29:27 -0800 (PST)
Date: Sat, 17 Jan 2026 13:29:25 +0000
In-Reply-To: <aWuKlR4a-VJhBeWj@tardis-2.local>
Mime-Version: 1.0
References: <20260116-rcu-box-v1-0-38ebfbcd53f0@google.com>
 <aWrSkAPFkdH_tvtN@tardis-2.local> <aWt4muGXbe7lBmXt@google.com>
 <aWt8Ze-otTkexNIe@tardis-2.local> <aWuKlR4a-VJhBeWj@tardis-2.local>
Message-ID: <aWuOtUa0mPDrnbke@google.com>
Subject: Re: [PATCH RFC 0/2] rcu box container for Rust + maple tree load_rcu
From: Alice Ryhl <aliceryhl@google.com>
To: Boqun Feng <boqun.feng@gmail.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
	Andrew Ballance <andrewjballance@gmail.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: dzkcukuye8awku16xjcfdpoqprzabx6p
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9BF4E1C0003
X-HE-Tag: 1768656568-175786
X-HE-Meta: U2FsdGVkX18cWLPdGJOfdvR+fnBqmZ3XbG0UFHHmNhAtHoG8ORPlI050NEvPXzr2Jr5qwQk1LJyU/2FOWMr6Tw17ZWWYWn28zLRQZKOOmimtsfK6NTbhUjSTa166+6vKcruumHTkrOu3lWfFpL+RrMdp8m5BNUIMXCXXAuu7mvVKsx7rE+MbzXILO3wuC0XW9Fe99vZhj4bfcNSObwjNfQhz3+w93+caj4aJ/Telm1HM57Dh5jWLTRCjJa6SawWrVTdgZnxfTv4zq3CSb6xmUzB3C24MxyuiazjxWB+Fk6gV9kHaNkdb/q1ONI4P6E6R0dGiACooQtgIuE4O3sZWlUYWpPCUlSYHZ/36FQ9OugzXt2M0RM2wL1/8Ue4urFaz47XHXgZMh6ysWet+5Sj9ahqqRlm8oZ3OEXIVJnxnGPL0mAU/s8JRb9dH31kF3ywVMUbYv+y5Nyhaz6MzRaybkNby2Y/MJWrbQA/ZpCsl9xY4+vQd8EERuDuXl/WeI+3yOeAboCHD1uooQyiq+TDWoPc09eX0CeXwaGNsw9VNsI9pgCs4yzItG71kKEPzi7f4HLOSE2dyf+XGEqWbDSd+QW92OopA+mKSUxF1yZVLkZEzvyj2K2tsAUUu7WQVE6SFSZMV1jufZgNfzF1nWwlIR4u416AYPWZSmKLS0AOJwHyxaCW2yivQk3L+HS1XWOOQWkyRcHZkD7Z4SVoqMqO/68Ubn+AUxCxjoPBtJH+6+laiy3/il10qcsKbqV7SgJz5RS/x0dTQ7xxFLgARkWOwAOAwl3gPRuReIRl4UD9QwLTYGYYFq5wz6jkBqRs0+VnqFejNp3/Baprj6HmuvA8sSYi1dg7nvwRYQz/kE9pSKW/O/0OPOz4kzPY8qFZjaeDktlNUjYk8xsL5yKx/eeqDZTZImyrDU4b5FVwqXO53u/33vCfpIin2MM8/B6UJ3MFv+H7aMe5GwXS0s7MnUMW
 uwhNrFwf
 t0SvWvlQzRbIjBYlvFVseu/uoiCrTyyjB4imUmYoTpTfmgRzy6W7ELB6uhwruD8drEF4QfGxAFtfoF9MJ38knlrfckWaY70IPJM+AJFf6iZQJ4sOI2W8pFBuJrDyUP7lpuSoR1j5xnEZIkqdYp50g13E5AhwgAZgVAfj6u9MkzY+HgPoGn/cCq2IQXk0W5QVEXoAzoHqK79AsHTvlXfwaziDa5OpE3GZVUuRI4wsdilGElCpUXv3UUEfseUvMhNXnu58rbU1zt9Y2Jrp960OSNjC2YGdfbFa1lVxdK5hX7omvOcV0Ms6Dq9OoiKUxu7suBq8L+PA1Ta+Fte3g9f4A5SpUMBWj4JrHcMO47WZytv49VNd8NL5Yq3v/W4CbUy0sDh6gDgyhDzLbwS8LYq4Zq6jsGVgGh7GOSBGxsGBTcMQELu/0/+dsFI05Us0wwhGIBkM98lQyl42+OeGry0a3QSZZMsGuBIf54GZHUkdke4Fk3KHi8J35c3JgNprOY3WkKEbhaZer8n14Jqr+CDpR3DICQIjQasjSwbe4L01WtHnhFdGd4UcWOKeJWhxRPhDZS8RmLH+VIA4Lrj5hWYbivnfhxz29ze52Ekor7w/ICj0cT4+ha8C0eMl8/fYj4ECQdZuKwa41XGOouB9Of6xFr4pOSC3k9CM49WDAuscZaRe/L0sHZP8Ef4g4gnZgqyNhGuo9FaT3iEOKbWRbnN9jbOO8pFpi+EsIRpMq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 17, 2026 at 09:11:49PM +0800, Boqun Feng wrote:
> In Rcu + RcuOld design, RcuBox is just a Box
> because these two pointer types handle reclaim + accesses.

How would that work? Dropping my RcuBox<_> must use kfree_rcu() or
synchronize_rcu() or it is unsound. So it can't just be a Box.

Alice

