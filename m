Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBFBCD1266C
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 19:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D84A6B0027; Tue,  2 Dec 2025 14:37:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0166B0028; Tue,  2 Dec 2025 14:37:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5BD6B0029; Tue,  2 Dec 2025 14:37:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F049B6B0027
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:37:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21EA512D80
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:37:53 +0000 (UTC)
X-FDA: 84175541226.04.83EA571
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2700C1C0009
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:37:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O0hV3GuU;
	spf=pass (imf21.hostedemail.com: domain of 3DEAvaQkKCJk3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3DEAvaQkKCJk3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764704271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zhJ/66bq3Dhg0Aw+wAsmTfNgUiWxLNmyfbE+xmpzX9c=;
	b=4ED0vqR3k9IjDOFGAkJ83kKIHFFr5LYTz5ulIKe9zo0I/JycxLEMf7HNjQPNRI/pYO6ubU
	qmMkgY6qMgc8h8zQJG0ZlW3bFP3Uc9IPephR1G+voTLaW+yfVIY6mxpFX0jQddkI3AMGKu
	DRtlAhb1uNDLpMOGDI4w/pEuW80Ul/E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O0hV3GuU;
	spf=pass (imf21.hostedemail.com: domain of 3DEAvaQkKCJk3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3DEAvaQkKCJk3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764704271; a=rsa-sha256;
	cv=none;
	b=QUAchH62APnh4Ie0194+tnqu7dhIJ9Bxhi0fvGjZeotM2EChHpvSWoEmoC4IOdb+6yzkas
	t33zyCjQ9tYda+rLTvwTAgZerS3KMG08akuL2xhDmzAQeDNFqXeiwGtpjUZevbkIfegg2e
	uhmMQOb5wdHTZu26qL9yCCgIj6yiIzE=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42e2e448d01so1972699f8f.1
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 11:37:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764704269; x=1765309069; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zhJ/66bq3Dhg0Aw+wAsmTfNgUiWxLNmyfbE+xmpzX9c=;
        b=O0hV3GuU1Qjdv8W7yQ0hmji8GZl5FZOfjM7GuLW4k0+n/V4BfJLUQe1x4Qv4/Auch3
         KA6GQ3Kc33aKjWIHXHUik6WDAMt4w7tsMKUpy1FftLxyqxaXa7grx/pZpivhKaT/3MTF
         b3evlD4vFmjA6lj11THk+hNlfrMoDKk03x1hOu1Zi+5wwve0F8bMSga3nghgrCyYNJZ1
         0XtCQVfDXFCmBtzokY4Lb/0M8K5uYyc0W1I5NsJn2b5+Xkj4Vev9oqWkHNZtfoYnGPgX
         wBhDsyLDIg0MMgZR1/qDdGxqzjfh/9snHuKlmuSPJgSMc0cmYWQz9ifE1mGU62nwZuv4
         XUEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764704269; x=1765309069;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zhJ/66bq3Dhg0Aw+wAsmTfNgUiWxLNmyfbE+xmpzX9c=;
        b=IJExldZfNarhJREA2J347KxaoH+snamHQBf8LNNCrUO4yz9jS1GJnoZxUcBD3OPwl9
         3/Vs7/mSOGTkLYUfAJLnqDuJ2fbhHyTg/CmL9Giw0CQeJ7F+lso3q+DsleRj4iB72C/O
         N5jxR+HCvNDKkMwqSQEBO/+avHD6qQAe2la4HIMMifQgZCDdzjYtGleBS00Wqa+dMNe4
         eIUExV9NFnWaaLNXBPk/WL+LSndvAgDqXeRmPLxj3SCApAFyJzvAZ5tasn61nE3K9NnP
         Z0/hTXx9r9GN79TEMDI20Ulv/XtGUDqcKFDQwFdI+le35BMFrr7/9snaYpxeZ7WvxCoC
         QZYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFBhVR8CP2P+Gbr6mRCFujkwfIzByKnsLMh9l28zqxuCaZ1lHRB/Nc9U/5d39eYvUqOrMhS9nJ0Q==@kvack.org
X-Gm-Message-State: AOJu0YxHNtMisackqv7nIZNkDBuGP+nvv2hyHevOfwHoD+NOyPJCClSr
	Ny+EjCtN9MSq3vsAShUeoiFB3kXgpIlAdbx9N/zFkALJYQIlWe1NSq1gVPAgkaxFSGimMC7mJS1
	H8VznNPcUjdc0JkEC4w==
X-Google-Smtp-Source: AGHT+IHLoORxJFIMnvNaTR7esNyOMYjh5IgIdqpmM1jiNlaGB5DkF31Koo1mWN1Y6iCnVsE9Qgyw7dzDpU2Msvk=
X-Received: from wruh15.prod.google.com ([2002:a5d:688f:0:b0:42b:3951:1b])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:288b:b0:425:73c9:7159 with SMTP id ffacd0b85a97d-42e0f344080mr31795438f8f.33.1764704268795;
 Tue, 02 Dec 2025 11:37:48 -0800 (PST)
Date: Tue, 02 Dec 2025 19:37:24 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAPU/L2kC/x2MSwqAMAwFryJZG2iVUvEq4sJPagNSJVURxLsb3
 AwMzHsPZBKmDG3xgNDFmbekYssCpjikhZBndahM5awCZwqcCOXMB0ZadxIMfnS1bWxtjAcd7qL N/Z92/ft+At1vUmQAAAA=
X-Change-Id: 20251202-define-rust-helper-f7b531813007
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=7075; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=W8ZblEwgjuL8jZJ36a/bhPpyurnqnpzkgPSqnenEdCA=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpL0AAbiS38ffQuRjq4nMNsCbAsC2Z0/xEFskYI
 a7cs/y+HK6JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaS9AAAAKCRAEWL7uWMY5
 RljtD/0fz1OjaXVHkkiWZGm1MTTTeoRD7MZeZtSJpWwEp10zfQcriF9Tz7TiY8DRVjupa7ieL6W
 K+QIimSfxkf0pF+U85RZt8x5R0zrrPA7a0r4Czw2u898rjuZSvXB9rsMsd8s49K2iNGlMl8no4n
 8dLlxYWEysWLhXoCLey0TdCeJgWmZWEtLRFaN6a3PtKGsKPj5IDQPwWCgiJcyBf9skYFC8xnLoN
 myrtxskJJ3xSky7n1TIOas7ooGu8EP6L1qP0CCGnHx3PR9GtRbSahp4lABH8jI74mWyxI75KaqA
 e9yf1n+e6sDD4Miar5xu7Waav7mh4Wlvpm+FSeBd0t7yox6QRDaIfb300TNnYzo1UMbkA4TsjSu
 jitafYyHMfHqSaZ8Hw25YynM0XiSR4dLFJXhzu6X6CIEFlbZbNx++pCQngoNk0Iidbvfmj1MwRy
 JBZM2bXi/bb6e6iBnyXdGbM+VMwGo9ik6yIiLbuEi0MdhQ1SQbz9kEaJXP2rfRSiJxCIobwXnwA
 zcbWzlULfAo1IcQ75R/0IuuuYUNlgfzaNl2x/c5ODo5ZVsxdgIMF9rF1905CYwuTY0YH222qCZ0
 fao/NDvnvYrOIhSBHgNknvBcn+HM6CoE2Hycm48/DGMTeSqNxcbw9tlPWj5SJ+DhS/1mHLW0MMy +rvrgaUoICXqdBg==
X-Mailer: b4 0.14.2
Message-ID: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
Subject: [PATCH 00/46] Allow inlining C helpers into Rust when using LTO
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Elle Rhumsaa <elle@weathered-steel.dev>, Carlos Llamas <cmllamas@google.com>, 
	Yury Norov <yury.norov@gmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	linux-block@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Michael Turquette <mturquette@baylibre.com>, 
	Stephen Boyd <sboyd@kernel.org>, linux-clk@vger.kernel.org, 
	Benno Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	linux-security-module@vger.kernel.org, 
	Daniel Almeida <daniel.almeida@collabora.com>, Abdiel Janulgue <abdiel.janulgue@gmail.com>, 
	Robin Murphy <robin.murphy@arm.com>, Lyude Paul <lyude@redhat.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jason Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>, linux-kselftest@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Vitaly Wool <vitaly.wool@konsulko.se>, 
	Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@google.com>, devicetree@vger.kernel.org, 
	Bjorn Helgaas <bhelgaas@google.com>, 
	"=?utf-8?q?Krzysztof_Wilczy=C5=84ski?=" <kwilczynski@kernel.org>, linux-pci@vger.kernel.org, 
	Remo Senekowitsch <remo@buenzli.dev>, "Paul E. McKenney" <paulmck@kernel.org>, rcu@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Fiona Behrens <me@kloenk.dev>, Gary Guo <gary@garyguo.net>, 
	Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>, 
	Mitchell Levy <levymitchell0@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, linux-usb@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 2700C1C0009
X-Rspamd-Server: rspam02
X-Stat-Signature: w8m44cse5ek559p8fypuuy34m69s8x4e
X-Rspam-User: 
X-HE-Tag: 1764704270-401495
X-HE-Meta: U2FsdGVkX18YmdeCJaFAbZbW2sRNk70qlckq3nxpAHlGI5Dnk5X1U4IEW92Kf1g/khfY1nx/hZmMs35iz/9b+DaFA/dlmfu2tWMGrJvkHIp1yrG8fi/bczPBMG3GY38UTrhSLJClWfJM3Oj18930c0/1u0Y6At4kW0jWYbV8GL8LAjQbZQevZEyYQF5ejQGVDo+GbVmekcU+eeQatDME6TP620NJFtcl7CkgseaWMgbDWWTQs4ir6KzlgxMaa/HwWT/R0GydUmb88efKC5F/L++rwzaUa/wBSfux+i+cZdEpY39KE9NKUp90lVMUgSBeo4XOv48Lavs+jannstesEvkN+cN7FeLIWI2yL8ALZE8Mt+YVm/B6vs9SgdtL4jsAYL+az8vo4k8Vn8CPqRYXZ9KCxFv56K+uC53Mhf+JTUHhwqBuwOjaEde4lxNVlZxpc9z7ndDVlDbeR4w8T+aEa5VzntLgUC/3AjhfdrhjsBl3xgEkDx4K//CcS2PksA0IUv5fF7xzaAqBTyBIFjvj0xVPl5x0NQ4jkTnZ8ax8LiDpEmn63/EPylxUrlVb+jl6g8yP22kC9u6pAsJ6H3mDkQ6ldzaY2f1GO9K0a5UvCacLDl2KH6ErkXYUqJhsrr8NfAdlOSgCM/6sKHupedaZEtkwseJym0l9JpsalXPAafTFBJW0zlCTTj90psfmCGcIVlW4gmC8qZpz5oecg6FDwT//GM/k1jejAqd6GH8N+GXE2w05VVS8Aiui0PlRjd+bhL/7/lbcUNh3DWjw9YiAzTMfpY374xJcEyVAxQppOkCOAgLQKODRLuUhUqRpaBF0sa2OTb+6PPjXE3XGRqpckLbJjkfvkiuEB/UhLRoA9i0AqJAusenkdGNSpsR7qB/rOOqz8ujmfzr3ZwNEbBJo+XMCTAWyV5CxL3N7K80I48hnIaNgCR+h0euEU4UGsy9j+L5G07SCnHf/RZNJtIO
 w/AycKyj
 9DfuXhylrq0QXhuApH1tz5KPqAnDyvjW6F5O1tWDIObUF1xwzYMVHFdtH1WiEtY5RcFM/9VvwdSpA3gXnCLz3eiCZawhvMZrmstZ6ntBbdoCTjBQCzkA9kh6kp5G4kY1KxCnUaWRfduyw+nUPgB/PQ+HjNhjEZSGrvVcw8qSX6dp5AMsqnmtfQd8g/OUSXsKfm1x0tUxqVgjJkQDf2Er9i575f5Vn5yavBbbAQvNYvM79siMxrrt1cFNZi1cxgkE/hN5Mv/QMBupF6CI9gRO8yuQ7whXJdjD4T4ROJgjlE2PQnSI2+wnfqEwBcD3Nkvg+0q2MSvUyyuQDN9prHUkxvriKouKH65PoTcYvUioPrjgxoV0Vxoy6Olgu+9kV8HcPExGNyy9d904H8HY4IpxgGiemw6HBuxhC7UV4MxVb+q/HdEpBQba/GZ7Fuizv3bk/pXLJjQjj9W2uTIV7x331faolS0R52ygcJ7i/0Jhu7hzHiqd+RZJEw4JredHoYkzSRhD4YFg0STUM3FbW+AITckxJFOv6Nu3g9D2ckarIi9082x9S7XXDgLlaPOOn7uLeqoPG9KTV1auRzkT9UnJaVxm1HoiR8m048jUdXIf3PTAmVkykhmZ5FkmFg1ZIwaSjN0WI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series adds __rust_helper to every single rust helper. The
patches do not depend on each other, so maintainers please go ahead and
pick up any patches relevant to your subsystem! Or provide your Acked-by
so that Miguel can pick them up.

These changes were generated by adding __rust_helper and running
ClangFormat. Unrelated formatting changes were removed manually.

Why is __rust_helper needed?
============================

Currently, C helpers cannot be inlined into Rust even when using LTO
because LLVM detects slightly different options on the codegen units.

* LLVM doesn't want to inline functions compiled with
  `-fno-delete-null-pointer-checks` with code compiled without. The C
  CGUs all have this enabled and Rust CGUs don't. Inlining is okay since
  this is one of the hardening features that does not change the ABI,
  and we shouldn't have null pointer dereferences in these helpers.

* LLVM doesn't want to inline functions with different list of builtins. C
  side has `-fno-builtin-wcslen`; `wcslen` is not a Rust builtin, so
  they should be compatible, but LLVM does not perform inlining due to
  attributes mismatch.

* clang and Rust doesn't have the exact target string. Clang generates
  `+cmov,+cx8,+fxsr` but Rust doesn't enable them (in fact, Rust will
  complain if `-Ctarget-feature=+cmov,+cx8,+fxsr` is used). x86-64
  always enable these features, so they are in fact the same target
  string, but LLVM doesn't understand this and so inlining is inhibited.
  This can be bypassed with `--ignore-tti-inline-compatible`, but this
  is a hidden option.

(This analysis was written by Gary Guo.)

How is this fixed?
==================

To fix this we need to add __always_inline to all helpers when compiling
with LTO. However, it should not be added when running bindgen as
bindgen will ignore functions marked inline. To achieve this, we are
using a #define called __rust_helper that is defined differently
depending on whether bindgen is running or not.

Note that __rust_helper is currently always #defined to nothing.
Changing it to __always_inline will happen separately in another patch
series.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Alice Ryhl (46):
      rust: auxiliary: add __rust_helper to helpers
      rust: barrier: add __rust_helper to helpers
      rust: binder: add __rust_helper to helpers
      rust: bitmap: add __rust_helper to helpers
      rust: bitops: add __rust_helper to helpers
      rust: blk: add __rust_helper to helpers
      rust: bug: add __rust_helper to helpers
      rust: clk: add __rust_helper to helpers
      rust: completion: add __rust_helper to helpers
      rust: cpu: add __rust_helper to helpers
      rust: cpufreq: add __rust_helper to helpers
      rust: cpumask: add __rust_helper to helpers
      rust: cred: add __rust_helper to helpers
      rust: device: add __rust_helper to helpers
      rust: dma: add __rust_helper to helpers
      rust: drm: add __rust_helper to helpers
      rust: err: add __rust_helper to helpers
      rust: fs: add __rust_helper to helpers
      rust: io: add __rust_helper to helpers
      rust: irq: add __rust_helper to helpers
      rust: jump_label: add __rust_helper to helpers
      rust: kunit: add __rust_helper to helpers
      rust: maple_tree: add __rust_helper to helpers
      rust: mm: add __rust_helper to helpers
      rust: of: add __rust_helper to helpers
      rust: pci: add __rust_helper to helpers
      rust: pid_namespace: add __rust_helper to helpers
      rust: platform: add __rust_helper to helpers
      rust: poll: add __rust_helper to helpers
      rust: processor: add __rust_helper to helpers
      rust: property: add __rust_helper to helpers
      rust: rbtree: add __rust_helper to helpers
      rust: rcu: add __rust_helper to helpers
      rust: refcount: add __rust_helper to helpers
      rust: regulator: add __rust_helper to helpers
      rust: scatterlist: add __rust_helper to helpers
      rust: security: add __rust_helper to helpers
      rust: slab: add __rust_helper to helpers
      rust: sync: add __rust_helper to helpers
      rust: task: add __rust_helper to helpers
      rust: time: add __rust_helper to helpers
      rust: uaccess: add __rust_helper to helpers
      rust: usb: add __rust_helper to helpers
      rust: wait: add __rust_helper to helpers
      rust: workqueue: add __rust_helper to helpers
      rust: xarray: add __rust_helper to helpers

 rust/helpers/auxiliary.c     |  6 +++--
 rust/helpers/barrier.c       |  6 ++---
 rust/helpers/binder.c        | 13 ++++-----
 rust/helpers/bitmap.c        |  6 +++--
 rust/helpers/bitops.c        | 11 +++++---
 rust/helpers/blk.c           |  4 +--
 rust/helpers/bug.c           |  4 +--
 rust/helpers/build_bug.c     |  2 +-
 rust/helpers/clk.c           | 24 +++++++++--------
 rust/helpers/completion.c    |  2 +-
 rust/helpers/cpu.c           |  2 +-
 rust/helpers/cpufreq.c       |  3 ++-
 rust/helpers/cpumask.c       | 32 +++++++++++++---------
 rust/helpers/cred.c          |  4 +--
 rust/helpers/device.c        | 16 +++++------
 rust/helpers/dma.c           | 15 ++++++-----
 rust/helpers/drm.c           |  7 ++---
 rust/helpers/err.c           |  6 ++---
 rust/helpers/fs.c            |  2 +-
 rust/helpers/io.c            | 64 +++++++++++++++++++++++---------------------
 rust/helpers/irq.c           |  6 +++--
 rust/helpers/jump_label.c    |  2 +-
 rust/helpers/kunit.c         |  2 +-
 rust/helpers/maple_tree.c    |  3 ++-
 rust/helpers/mm.c            | 20 +++++++-------
 rust/helpers/mutex.c         | 13 ++++-----
 rust/helpers/of.c            |  2 +-
 rust/helpers/page.c          |  9 ++++---
 rust/helpers/pci.c           | 13 +++++----
 rust/helpers/pid_namespace.c |  8 +++---
 rust/helpers/platform.c      |  2 +-
 rust/helpers/poll.c          |  5 ++--
 rust/helpers/processor.c     |  2 +-
 rust/helpers/property.c      |  2 +-
 rust/helpers/rbtree.c        |  5 ++--
 rust/helpers/rcu.c           |  4 +--
 rust/helpers/refcount.c      | 10 +++----
 rust/helpers/regulator.c     | 24 ++++++++++-------
 rust/helpers/scatterlist.c   | 12 +++++----
 rust/helpers/security.c      | 26 ++++++++++--------
 rust/helpers/signal.c        |  2 +-
 rust/helpers/slab.c          | 14 +++++-----
 rust/helpers/spinlock.c      | 13 ++++-----
 rust/helpers/sync.c          |  4 +--
 rust/helpers/task.c          | 24 ++++++++---------
 rust/helpers/time.c          | 12 ++++-----
 rust/helpers/uaccess.c       |  8 +++---
 rust/helpers/usb.c           |  3 ++-
 rust/helpers/vmalloc.c       |  7 ++---
 rust/helpers/wait.c          |  2 +-
 rust/helpers/workqueue.c     |  8 +++---
 rust/helpers/xarray.c        | 10 +++----
 52 files changed, 280 insertions(+), 226 deletions(-)
---
base-commit: 54e3eae855629702c566bd2e130d9f40e7f35bde
change-id: 20251202-define-rust-helper-f7b531813007

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


