Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD5E9CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 12:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502718E0019; Tue, 19 Aug 2025 08:41:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DAC38E000B; Tue, 19 Aug 2025 08:41:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F03B8E0019; Tue, 19 Aug 2025 08:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE118E000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:41:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF5321606A2
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:41:56 +0000 (UTC)
X-FDA: 83793469032.16.0AB169D
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id E5DC240005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:41:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=n2gtu5r7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3EXGkaAkKCNAw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3EXGkaAkKCNAw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755607315; a=rsa-sha256;
	cv=none;
	b=XzZJAuqEe+0JTIVm1hJK3n723djQV5S8ALoGCl3lXi5FfktF1eRoa88XI2eY7bD7DxbAye
	/zwL2fi4Cwg1A0R2LrhVWhNR3g4W7u+6oEzmlv6xwZjqjkTNM1AhiZG7fzgMyILyL4dnmi
	O0LDMfKBGjxowrGZ0ZgJf/tpMxkACIY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=n2gtu5r7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3EXGkaAkKCNAw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3EXGkaAkKCNAw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755607315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZPu71v4iJrj40UYhCf2EubxUaw6sgyARKI4hkp1H/4=;
	b=b0iwYhbBSnnjHCLNMSBMH47TA2gUT3oJus+YxKvbjC3RogEy0+I9jizT2DVTxnJwvjfeMW
	6si1FlaIknvVC4+xcxXfufjKMMW5JAgE7wFqUwEgFRj+TciyIBvyjMqd/hqq+QPV/ByWoA
	hmvXbX9PIq4HHen4b3biTnivaeFNlPI=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3b9edf5b346so3779964f8f.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755607313; x=1756212113; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jZPu71v4iJrj40UYhCf2EubxUaw6sgyARKI4hkp1H/4=;
        b=n2gtu5r7lpExZvOqe6vpfW2vlcPpo9oiY5xmvb8EuP6Xkcn/GfvyPhrBtGcWjPEmKz
         DPlQcxIT4piSDJgph60YPZl9j5VhF7uFT+DNw8wIXrfvpEXk5FUn2JsaLjB86CxD+uft
         3DinqlnIjLQN17D/AOngJRwIloW5I2JEgwp08+WfBnXvK4KwZmoNRBDG+nUsmO7Yt9dc
         LkS2Ba9D3HqkR4MgrFJHuKPMA1voj7v+uBMP4CTrdfKzEUDl6p179XRhogkoDq4xZCkr
         9+DQHcqIqSjIdyWP7Vt7hYy30VrBeXmM33+sGu3GWMovGzqpNhgLzV4s5DknY7A4hfQU
         O+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755607313; x=1756212113;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jZPu71v4iJrj40UYhCf2EubxUaw6sgyARKI4hkp1H/4=;
        b=cA6gwMhcI0LSCwBkVVtg0ha382qX5bneiE1sNfC+pqmwB9VCECEpm/dQpkjO1Xljzo
         XaMmrK3UmIeYbmagI+jsagg9tqcIGlVWBPGR/MYEac2r2z7EXZezO05Nr2stueCdVqvs
         uL0xakq52OqRi7KDlNw1fANs9oklOyK8vig01voPtbHT6HiN9OJKJna/A29a3s+cQ35C
         P+Kp9sUM8CGdinwFUA7j/sM0xCJpNRrtDpAoVafVKKEz9ECw/0ixkyMkCuQCteWMVAj9
         g8ausBeUJaNz/BDuKPt2dE/zEdTkye+ozupP/0Jk3jgF2+fa3+OZdAGOudT/4tUyhEhb
         VBCA==
X-Forwarded-Encrypted: i=1; AJvYcCUf/vp//qAPSAqf6zhAxPUPVT19zU62YerfgudB7fMd2Cq2BtmkRxt/GKhT0JoPKaVR8i7NAoBhvQ==@kvack.org
X-Gm-Message-State: AOJu0Yzdyc0KmwnW/J9+R4hd8Jslo61oU1rfz25UW+pevw8+q4BrwZgS
	znXSChJY/fqpqEREX+cEvk9t7H1N+3GGlYPan8SFY3L3yaHjwcKeMf6Pn5NsQVwR9rvN5x5Fruu
	shkV35SeEIVgQeAhzKA==
X-Google-Smtp-Source: AGHT+IG4HvCG6xMAP0kc+KeWFDcdVkf0VrlLc9RsRO55bsIjMgWKuo8r9NDS3JOpE0Jihm8a/GII747UxtSnXhc=
X-Received: from wrbee4.prod.google.com ([2002:a05:6000:2104:b0:3b8:e8d5:b8d4])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2d08:b0:3b9:14f2:7eed with SMTP id ffacd0b85a97d-3c0ecc315fbmr1499787f8f.56.1755607313087;
 Tue, 19 Aug 2025 05:41:53 -0700 (PDT)
Date: Tue, 19 Aug 2025 12:41:52 +0000
In-Reply-To: <20250819-maple-tree-v2-1-229b48657bab@google.com>
Mime-Version: 1.0
References: <20250819-maple-tree-v2-0-229b48657bab@google.com> <20250819-maple-tree-v2-1-229b48657bab@google.com>
Message-ID: <aKRxEEy5ln8qcGGI@google.com>
Subject: Re: [PATCH v2 1/5] maple_tree: remove lockdep_map_p typedef
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E5DC240005
X-Stat-Signature: c9j5pr8t3y4dpkpsfx7jwkjia61dtet9
X-HE-Tag: 1755607314-306555
X-HE-Meta: U2FsdGVkX1/7MAwI6zTVmT71lXzF8BpZjQIlBBzIhwrXItNDfNxLpamzdriteDMvCu+I8hQI+oS86lra6OUmAWo5JD4gYXKMv3UWA1kPol/9ET3pDLNCXhndBYlgG+cFRXMJStT73u/EirBiAZ/JqqB3GVGRZM1m03ZQPGdeemntYo+7ZJDXTwKLFF3+HRSuMvzziFwE+iKix0RYrHSgHg8zgsRIUC5e4FFyXhNLwYPl5NJ8LUeYgaxeTqN8o7eiH2m6WyU0GeIadAdcfrSN3ybPRVn8YspZRGyx5stBb8rp0X+30eLzYfZumbxrZBV596RDhjmuUURDfvHX57mzrr+OIUsn3AxkuprEipY28oUZXaEI7+4xwrJxkX6Dsp+o7urEvxcwnR5ibtUcuviw/xbs8/OfMJIUx+Xi2ZsIaEl63fBXIEsvyGdK3SJEO8x7Hr3Z3xonfzZVCy8qyIY251QZMBzSdIhPS0IzY0DUCPjvy54QNs6n07DhBVUWOC0Qd162GpN/ho+7crnU2dYngvVf8HCJvmTLTZEb7uuWmxQyOzR3RYU1hiRQA8pGaqQp1va0MCX57+VoxxQReg7avi/SyMFCJCFMDBIO632OwQ5kGaMLS2XnHIXZGTkr5e3PiffwrnPxg/p5idibiPA93o1l3JpZhI2VopCnNE/0mQltOjIXz6D2Zm9AISfQ/dUUWDqd2Cq3ikhy6UBTd9WJbRMS0xEXs2fkFvSimBdQpAmr8bRFVH8aPVa0pywjLJuWxcPX74pRWtXwxZLDaWlMJINhC3IdBGnNMYjvGfdLvHp2PZL/TehmUsOVdEUxSGXpPwFKRlppBrCM+QiylsZhcTHOK+vOYytOsWFdXML8E1iOm9AbBaQegL+8zZ1EE8egAyFG/eD3p3ak28mkFVltSmGXxB6Rv0nDVubPUfK9MgV/vKR5BVQr8dq4W4H4O9AQapSLi32G/vat2ZjKYHk
 vw16fnxm
 BjOflVboaN+WMHO6BCdRdtlJTnkWTG52XRCd+5Bh/Bp/DTJVOsr6jkcShlgR+HMN6IReph/GANYyO7nDwv3q+g2/WZvDw5qS7DPMvAsIMe9UdZnIk6r3G7Ybhu72eiik2NSA0oUDQGKigXqEHFRz0OKOBt9jP6+8GnU9cpQsarNvuKgpOJyqtU501buHc3ZvoPGuc1ledJUZmX3OuncQh9ZSqld4TFfTbkxn2vknHyxFqn+rosqKNqBj6YPsZp5UpuOaO0uSKumMTYkgvwelIEROQvAUeE9UAhBhV+qgibN/JryVoJ+p5v7ufcKbx3LQB1lZgFNJjbl3UYla2qpM9rVPkf2GQo42J5Fpmcyoc8KUVUh+sKADtM+8HVhmBDMak/zhpEy8uaTyd8RJHITMp0t6Wxt2jtnJpGmJ7pXeh1NvyWDO9HXR+EkSYSY9sxDFtYWnGT8+oy2uTsInPTnVwG/dw75vsWCoMTxzaCnfASCMmRGjMLEvWKkVow/qf9gXvEto6eyBCQguNrvNoQhAa6RmP0yKbZ/Sa2TBNRAlnQf7/SDhBwa+T1yD5GvgefO3PRVv51NZkupA/RpP6vKhVmFGAHJA4V0qsxRm/ecwzYV1x6k0Ih4uwq5mn9sXm1nHg6EK637ATuMcpvpIqA0VWLGII8lB6SA6Lp/0IpKsl6tvVAmdbumCxs2d2EJMEZhGC4exwkV6puh+5iHitVNGWYUvG7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 10:34:42AM +0000, Alice Ryhl wrote:
> Having the ma_external_lock field exist when CONFIG_LOCKDEP=n isn't used
> anywhere, so just get rid of it. This also avoids generating a typedef
> called lockdep_map_p that could overlap with typedefs in other header
> files.
> 
> With this change, bindgen will generate better definitions for this
> union, which makes it nicer to use from Rust. This avoids a cast in the
> Rust abstractions for the maple tree, ensuring that Rust's type checker
> will notice at build-time if ma_lock is changed from spinlock_t to
> something else.
> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Ah ... this didn't work. There's still a configuration where I get the
error:

ERROR:root:error[E0308]: mismatched types
   --> ../rust/kernel/maple_tree.rs:256:18
    |
254 |     fn ma_lock(&self) -> *mut bindings::spinlock_t {
    |                          ------------------------- expected `*mut bindings::spinlock` because of return type
255 |         // SAFETY: This pointer offset operation stays in-bounds.
256 |         unsafe { &raw mut (*self.tree.get()).__bindgen_anon_1.ma_lock }
    |                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ expected `*mut spinlock`, found `*mut __BindgenUnionField<spinlock>`
    |                                                                               
    = note: expected raw pointer `*mut bindings::spinlock`
               found raw pointer `*mut bindings::__BindgenUnionField<bindings::spinlock>`

Alice

