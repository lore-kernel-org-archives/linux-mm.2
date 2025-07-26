Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F259C87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 13:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 949366B0088; Sat, 26 Jul 2025 09:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3DD6B0089; Sat, 26 Jul 2025 09:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2606B008A; Sat, 26 Jul 2025 09:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4656B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 09:23:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21358114108
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 13:23:41 +0000 (UTC)
X-FDA: 83706483042.07.4E1B1F5
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 340AF100005
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 13:23:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="D0d+ts/D";
	spf=pass (imf14.hostedemail.com: domain of 32daEaAkKCOQGROIKXeNRMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=32daEaAkKCOQGROIKXeNRMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753536219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=v6pXmOOa+uL3izdLaylEgPW09ZR5nRV/PajHQlIRQ8c=;
	b=xWiULj6J3oKUioCADi5ztusw/tpnN36Zs+o5nRsZNFlFAEzQgmHjQDtRXQ8VIty9/3HYmI
	6AX1ZwotIwzUTDhnxV0E0/V7wHRbIuf/9duSnzKzkHqkCHynY2aUbgLThTVHQzJhYiPWEF
	G+TdkIixPsAaKYcTNkluzZk6xo7MR/4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753536219; a=rsa-sha256;
	cv=none;
	b=Gl5aPkQsSYR1/HBb8sYMWBZ6mxMALa149sQGvKP9aCrssk00nByGXqSUkEYSzq/npFJDoP
	tFEizqN1hajuSdbg6wisK2685aJ8TIiXflSvj00puzvZeehYcI18jhHxdZSfU1insxV8d0
	O8VJR9sOdbh1+x8s+a7uVoUzZBGNr7o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="D0d+ts/D";
	spf=pass (imf14.hostedemail.com: domain of 32daEaAkKCOQGROIKXeNRMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=32daEaAkKCOQGROIKXeNRMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-613559d197dso2550577a12.2
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 06:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753536217; x=1754141017; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=v6pXmOOa+uL3izdLaylEgPW09ZR5nRV/PajHQlIRQ8c=;
        b=D0d+ts/DW3X2K1573JNr7EvEEciawXog+96ihYhZK7Iq8MtGRB8RfkdcsFdbZ5Vkwm
         wCpuGMfZEkm6GX9ajxi+k1XLbecrBaIVbBNe9mHKLZoWeQGrywELVQQJJ6WCJYf13SlG
         PoVeu+XQdGkHg59/JZrKN4jlhNdIp5NROdimTVsAhzQrKsc4kex37anAOfpA01htg6h4
         JHPvdTw+P/qY92RvyQsXk2tI+hSMmJac1VRDNdW0SZZRLHRQfSVahzk7i9dqaNWHW2iE
         8WOeaSnykXIaOtM64T9LEZPpCS3BJl93BpZe9ucgtQAyAN93C5uImjYW3ELE6VZU5t8/
         A0EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753536217; x=1754141017;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v6pXmOOa+uL3izdLaylEgPW09ZR5nRV/PajHQlIRQ8c=;
        b=aRB0YjYuOEGBKxD5wkGaNCXroemFudown9Wkp3ch4Tq0VwJUZYQGA1mO6lHpzT3vIp
         QsEvZo9W3nJSjAf7Bi2zXdofdy/trYyhPGl8klhsDOK1LTZaR5h82WERb2bgQmutEFsL
         s6UUY9eATbB60dNj4nM1jBaYNrkX5pGMLUJS+ON5LWcdmRibIViOoFRM5z27zLshCkvd
         oK/Ce5rW4cr6CeRDnShFX6fAZL65ab2d4NVSmNfZZo1381acZKPmyR8Rcr6xZyL6JnXe
         M31vvyTw9OvOzn0g3/RJkXze088Aa/KpuTyOlaToZ7Ziqdk0qxlSQfrR3nHsZsVLnb3R
         degQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6qXkx7r8ySNgj3eVQGc7h9Kk0NYtlKANhqN1QVOlqwkS9oBS6NOQJgcsX1SJPf9dXSML0AXGOOg==@kvack.org
X-Gm-Message-State: AOJu0Yzg+cTnTJq3ZP6PibBbiB1MF5pYhdma6Ky/m9npsdRuaid6VzQP
	ZdQBRTHxBjoUQn0uRVgywb+V8iQv21pyhW57RERar87lFWw/uUoV5ZJqzI/iiVEPkUX1uDpzd8M
	GrtFUq3tGECm0oN2h8A==
X-Google-Smtp-Source: AGHT+IHWglauExVkBXOOx026pljplAP08f0yD9Cr0BMTM6PlulvfQerRxLC1kYo6rMFl/9nKW2LJ3nTgSyP3ULs=
X-Received: from eddt16.prod.google.com ([2002:a05:6402:5250:b0:608:8531:cfba])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:524d:b0:612:d8b3:a9e7 with SMTP id 4fb4d7f45d1cf-614f1bbc851mr4834520a12.5.1753536217105;
 Sat, 26 Jul 2025 06:23:37 -0700 (PDT)
Date: Sat, 26 Jul 2025 13:23:21 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAMnWhGgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDcyMz3dzEgpxU3ZKi1FRdw8Q0AwsD48RkUyMTJaCGgqLUtMwKsGHRsbW 1AB9VRGxcAAAA
X-Change-Id: 20250726-maple-tree-1af0803ac524
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1557; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=KeWfTnh8Chuw1TOz3MzZf+vZMoN7xHrcY5K2UXkz3KM=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBohNbXAjFmBxetcuSVDw1fq5oeIc4vZTOdh9fV6
 pR1wDXyJSyJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaITW1wAKCRAEWL7uWMY5
 Rg90D/9MO7luxZ4q8pRG7c8lGm0BaifeTGvGJCGM841tyFan5WL37r/Iesg7FptBXwuiXNXSdcs
 G8nh8mXNuzffIdonqNmWS8p0kFbPb4R4tYz0TcsNf4guIAHVj+1zz+yawKWmrcfiX2k0SA1oOCs
 e6jxY4NZg7lMNniPmQmqsiWtNdV0apTwYVKKvoD/wHNr7ilTjYTLq2Rzuk1o1suKfTX5m9sGXbU
 40CytLKtb5J4vhq/7gs8ci1ijB8Hj+FMTWk5X8L4VvU5Erp/o/3RC0yfV/3sBLfSpMgeUcDMcZS
 co/TC3M429/qn/fR230bgWSiqe7tkrliKGGDukX7rn7HdZxJGhujuoNBlPjwJMwofRW667TS1S5
 brMHJKqYwHc/sxBNyOhXIhYYneB33oNA8aEC2yqksPyJTA3Vi1s6pefIxk7xGP1wu63WuvUAeZr
 6iQVwI5l/+MEyPDWI7eXplqTEgi3pJA1RFEOtpQm7Y3cZ8tZ7nbemXyfTmYNrTeHO405lqBsAyj
 ACVmdUoSWjrD11WuGRytpYHdrTZ4fMrp1Tu6GUwHcjiW3/c4Z7WvWfQX1d3Z6gZewsDKwTn+kE8
 GR+IWzTB5AFYLBXITIIggQSxm9DvK1XDDBwJ5KSVo3WKPnLhFqo3dXToMyYRTYWH59M8VhrBnUx wriUrTX8Leu4axA==
X-Mailer: b4 0.14.2
Message-ID: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
Subject: [PATCH 0/3] Add Rust abstraction for Maple Trees
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 340AF100005
X-Stat-Signature: xsyd3fm3nqeor8ghxh7zj5jrc4q8ro9c
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753536218-54058
X-HE-Meta: U2FsdGVkX19xG9cW+caVYSHJVLAbuKTIMVsYsKI0NaZzwY/5mhfLulx5z5vC3BvA5OVEeRC5FsAN7wABiPANd3WJ7yWJa2lbN7eC9S8hfyo8AdRdQhn4MsO91Rpjc0/dvxlWbO7/57449ypWrjj9KbaAQikgGcgnPLVz5vf6oEN/t4SOD+Y/WizZ84rpoo0qUWK0BjkmseXEx0wJRA5XfKWHxCAMHUO7KRdYg25n8RVI3iGhyQQRodTQ1jQEgg6xJiUWo0HDsgN2ov8wMv+7g1IWnFxoJ192Qvd4UrGS3nUWkNHvtzQnOTsbWUC3K8/YQn5oARq9GOjSA1YybwDeAPVOrwEZQlTyg6Ya7KHfGfJiRTm8nFryV8KbBDpqWma50H4rWX5AH0onVXvsgEn+K8hHFcwAjFta/OgetbDM76Egm0R9ZeMqY4Ecbcv1DvjoTBTIjlJQLdgG4uoVJQhJSZtrXksbWacDzeAbZR1JH3tUsB7qvwrVEgKBkIZMPjod3VIwf2Sx4Z+nbSXmFLPHmYu0TeCJMuVRsmPnAs3Lpq0AzEqQ/z31sEuua+Wdme2uz7Zshdev2dww2WBOpVE0fzaYCJvy+Ni1NQ2igUNHKXs8JPZkNBFe+KiV3qtPkzS8bkTI5RPnblRY4ULYib0yaYI+kMQ+mKJbgO1M9LmLwI8kQi0SBx2rfnxf9XLGWmXnT1wmsUcUbgeIAcFJWoHYsqk3WtQjcduZXanyhglIg3Dc70+3fBhxsvHgc6C8Mp+9koIHoUvsQk2K5NtmHw9nDblMowjn15veskdqQGGRui8TVWVEaz2euGAhODoivhwTOt3AcvhrDTs88Swd6jILWi9rAef8pEjoeb8VrCoJXkxTUSWhN3NDKVhmmmYE9gLc9ETLyGyCflJf0nL19Nchc4NLLitif7nWYyQ8UmAoLTnutt2FQLiGEwRzaE2LTZ0lX2LzGLKO64F/Cy1Px2R
 SCGoJvBq
 SxwBpJcRDy/7e47XrFQ+id74WXqiMWzaLWbhFYRJsZgHjWSL8iDQsiNoaMlD8PvWTcAdMFDO/4rVDBPS6Q3r2bwzwx46L3LgCgO6N4hO8nVqf12IebrIWOzXJlLz0IjL3a0oj2XN3Qwu+R7ljNERout+EX6MzAogjen4gmBNY240zyt7EaHTKfVoXZghrDGlfnKBzDKoTfTlrAFPep4pqV+njhRClKstd9reeLzzwmw4i35qlnV9cMP6C5gQAfEi9t4lyJbgEA1x/0GeeKmdLItHWH6yN2dxKAvWMzfbevYqY71cJbvnA0MK/ac0EYIOLUGH2BD7HGWIdjymsQ+6Rve7Aqeo8Ki7UeP/MUdZLyHqRuV2866P59PZ3l3NiMsBFJqsV7aOTUlhYqRXTv2EVDc6dUOM+pr7ARtav12Se5CzOG7mGVAKrsZeerFQmGFn2YiqbfdcOK57SICMXODmVzg5uhoi517smzsXYy38BGkDLCd8E8cqbBPypCsSAu0SoZR1RPPQjA+mHoc/VeMG8nCJpvPg62JDIs3tryvpTIeqGpYu3wXDLW0Q8f7/Ar2gFC3Oml6avIeRFay9aQUzPo1Ri9WNI9F9jUFb/1U8lr+RyFKxv/rknUhNZcbDj7KazHPv3Lqw25iNTAoW/C7yjy6k3aagmNVw9EgBzwNSOvGp9YJ+dvgrd5V8EWZLCrJ7HmgKARbd5CPUF2Rk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This will be used in the Tyr driver [1] to allocate from the GPU's VA
space that is not owned by userspace, but by the kernel, for kernel GPU
mappings.

Danilo tells me that in nouveau, the maple tree is used for keeping
track of "VM regions" on top of GPUVM, and that he will most likely end
up doing the same in the Rust Nova driver as well.

These abstractions intentionally do not expose any way to make use of
external locking. You are required to use the internal spinlock. For
now, we do not support loads that only utilize rcu for protection.

This contains some parts taken from Andrew Ballance's RFC [2] from
April. However, it has also been reworked significantly compared to that
RFC taking the use-cases in Tyr into account.

[1]: https://lore.kernel.org/r/20250627-tyr-v1-1-cb5f4c6ced46@collabora.com
[2]: https://lore.kernel.org/r/20250405060154.1550858-1-andrewjballance@gmail.com

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Alice Ryhl (3):
      rust: maple_tree: add MapleTree
      rust: maple_tree: add MapleTree::lock() and load()
      rust: maple_tree: add MapleTreeAlloc

 MAINTAINERS               |   2 +
 rust/helpers/helpers.c    |   1 +
 rust/helpers/maple_tree.c |  14 ++
 rust/kernel/lib.rs        |   1 +
 rust/kernel/maple_tree.rs | 538 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 556 insertions(+)
---
base-commit: dff64b072708ffef23c117fa1ee1ea59eb417807
change-id: 20250726-maple-tree-1af0803ac524

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


