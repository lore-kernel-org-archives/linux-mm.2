Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59876C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 19:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 895158E000B; Thu, 28 Aug 2025 15:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8455E8E0001; Thu, 28 Aug 2025 15:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7344E8E000B; Thu, 28 Aug 2025 15:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A12E8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:00:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1DE3B890E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:00:56 +0000 (UTC)
X-FDA: 83827083312.16.07D00A3
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id BC0654001C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:00:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jPlwWlFk;
	spf=pass (imf01.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756407654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uLB2ySJxURxeJ2Prp4OMsSE1Drdas7+Ru1DscCOUHP4=;
	b=McpMqOnQGdVpODR5oB0HOECQEQ5O3fJYr9vWh5JOfyDJBmn20cGzdAwOpxheOEtrkLfIy/
	k6/N8OxMN4J7E59OMLp7mbSExGUx/8yOfrOYAfre9z2BMzIPIoXuWdQ2U41aGUDPwQAlGd
	edtkIylzjRgb8X4s6n8IQbuqLKZy34w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756407654; a=rsa-sha256;
	cv=none;
	b=ZaSjsulXbMSTng+Y1lZ2f43kScZocvqzkRabEK4YmiVm1MfnGRAHkky8/9tKDo7jB5DDYC
	nuExa0MZUsedk959dTIBqqT8Phc4sfKh2T5+OByZMhv5OrjUfAu2slaz9gTMCFqdpHqx6v
	da2Hh5ioJPQAVxALpaGCb/gfPMYSfCs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jPlwWlFk;
	spf=pass (imf01.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24622df0d95so10248675ad.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756407653; x=1757012453; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uLB2ySJxURxeJ2Prp4OMsSE1Drdas7+Ru1DscCOUHP4=;
        b=jPlwWlFkGfz6kVF2f5Xn0yxQrxoM/daSWgetHXzfry427QQPOzlgmnEI13oVYNIdRM
         P/dze8c3U0XSgxkAFdG5szbcQ4FoJ8iHAtVQJCUv3ZwWQnrhZikwMqbR5lXAbZH1q+cc
         Zr9lpBiyKDTxZfXBODKZqZkOqoGUyMzb24uVH70lMqx3FCk9fXlEWVQCMFIS1xvrAxlv
         A+z3CEYS823qoe9LNOG9zDhJW6MGv/uQc3EKYTovgdAamNcfYjnMDmz699rfZC05B41k
         b/9Z6GBY/2zzNH3dbWNHS4VcSXthI2gIEQZMmLtVpUgwF+MOG3NwU0ZJvrUoLJrh9fES
         4ZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756407653; x=1757012453;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uLB2ySJxURxeJ2Prp4OMsSE1Drdas7+Ru1DscCOUHP4=;
        b=nP1mcoXhiyXZIz4BGo7wFMH6uf9lBIhdr1FUi3Acuv6ATt3mudGEeFkluJ66PofuZj
         ittZAWnG3jgame+o9hb8USWkLY7x48A5oWuJBa7iHXqI6vV5XgtMvf6h0RyY5gnd1jH1
         73a8jNCB4qD0JPACj1hM7xRTLaS+N0M2hmfNjIgy7lFod/YqlSrqhyJ9xW5u7Q+4Tv2i
         v65vV/rIIHay94cFEpFblNIj6d7Cs5YAwVf56O0yHC1RP90dkjxNgOnXRIk5lGp4IbsR
         HCxQiJg3fAZ2Pu0pwucNNxo6iP4PO2Y6xTYIkuZfiNh481liGPYi2PUBsp6WanmeLKEW
         vfpg==
X-Forwarded-Encrypted: i=1; AJvYcCWIvJcnDk/jh0BzohRao2tycf3fNihrIIhQmlj6h9UR8uOJfNQnYTk8rr6m79V/sQsgXaXvQbgDqA==@kvack.org
X-Gm-Message-State: AOJu0Yx3q9cCVxMSd7InYAHWgHdrT8MWrIoSgcNXKr6+aZKbTd57P8Ie
	aMXTYzRvffdp4i6EvoEBXXtQJiueGut51TrovrwN8BfjBHYjYcJkTd/MYmF1x9EQ
X-Gm-Gg: ASbGncuNc6dbgDUMoXeXBPtGrZImtyBUHkwtV0XTVwjHCGHhzKOsrP1BDRXZ7lkdUoz
	IdqyLzag6vqHpbWWjWKK52sHKu42pAT2daBxRRJSGNcrA7q3/JKVamXXc8gY/1n1ZmKqjBY8AXd
	DtAekLcFHo+IELqqsyVn2Scb0LBFedZPpz5unk8HrgkszX0NljGTARqVba/Olkok891WCYpUwDT
	ouZLs9JphEGEfRMvNWrhaRpQ/NmA7or6b3VrKmTJ0V0Sa3ITKaTgodIXDISP8swmmyQeITucD12
	xrVQp9k0BQS39+AxCVd4C+mhxxGmSOdeo7NTX59OH3dZCGB9cJ3OkASrx+WSFcU/AHYpedJKXZO
	GkZNfbMf2TvnQGfyORQZ3VwDa1etFYaVEdBqLwMftb1utfJBVqoA5y8ZGTgGcG3QBGTY=
X-Google-Smtp-Source: AGHT+IHW/KVZ59F/LWisNOWscaunifwOLuUYn75v+mJnJQp4Mv7Sd2maSFNmnAHJcLWsDxVxAIVdRQ==
X-Received: by 2002:a17:902:f78e:b0:248:d917:a57c with SMTP id d9443c01a7336-248d917aa6dmr44946385ad.40.1756407652864;
        Thu, 28 Aug 2025 12:00:52 -0700 (PDT)
Received: from mitchelllevy.localdomain ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327da8e5ad5sm405729a91.18.2025.08.28.12.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 12:00:52 -0700 (PDT)
From: Mitchell Levy <levymitchell0@gmail.com>
Subject: [PATCH v3 0/7] rust: Add Per-CPU Variable API
Date: Thu, 28 Aug 2025 12:00:07 -0700
Message-Id: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADensGgC/22QQW7CMBBFr4K8rtHMOE5iVr1H1YVjT8BSIamdR
 CCUu+MEKtHS5R/pva/5V5E4Bk5it7mKyFNIoTvloN42wh3sac8y+JwFARVQo5JxTIPsObp+lGy
 p1UWjvVVKZKKP3Ibzavv4zPkQ0tDFyyqfcLmuHiQ0vzwTSpAEBrHimqjB9/3Rhq+t646LNjMaS
 ipeGeO0aaDyZI17YpbuiX76NBT4h6XMarbgwTMqq//pq5BemZrKlnRZacLmuW++Px/5e8wLDo8
 F5vkG/0Mdr18BAAA=
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>, 
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, 
 Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, 
 Viresh Kumar <viresh.kumar@linaro.org>
Cc: Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
 Mitchell Levy <levymitchell0@gmail.com>
X-Mailer: b4 0.14.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1756407651; l=3695;
 i=levymitchell0@gmail.com; s=20240719; h=from:subject:message-id;
 bh=yzEqjwShKdy3e5mR1Q+9kCEEyTAmDJsObfl1FvhOcqQ=;
 b=szSZ6PnGo1rOv2lpQujKqFXCXBiX7rWi8n06tjC0VQVqwcm+sm8wUQv0Q3w2KlYaoSTSlxz2F
 5CveT0mdIMoAkxde7vCtqtupVWOEbUbtFz9UY0lasC+pM3SlbBXFrDH
X-Developer-Key: i=levymitchell0@gmail.com; a=ed25519;
 pk=n6kBmUnb+UNmjVkTnDwrLwTJAEKUfs2e8E+MFPZI93E=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC0654001C
X-Stat-Signature: qpiwgk3ysnjf4krwj6coxn78yypdj6o5
X-Rspam-User: 
X-HE-Tag: 1756407654-353450
X-HE-Meta: U2FsdGVkX1+shCkwAs1EFfyDmuyqsspBHckoRmEIuAKIXe5BWEV8BQx/fzkyZMaC6QDlttTeC0q7hJ0A4R8/6ReOdNAGlA6M1qwsxMgFeegpAqGd9fdyOFCq4l2aiHGTx13UVGmoVu/drZ4fK8j1wqq+G2G3e9p7xfHxI4d0VtrNZ6IXsMRfYBk3Kf1+CpsALniqtmWaCuuIleor6gfX37+xdHxEh//uy3UsinJdtOd58uArB3qzDI8vRiFm2vb+DBkUkWZq1VCufOv1mLXcyFYAwOxfOTdCD/yQj/1Kt2SxDouhn8Yx2McUBbWVsX7NMQw5dMy1tYbKllx1Nppj4kyUpN51yQplCL5FeOT7TSPnBh0nYyBm0CwhUCPaSt7DAJuxc+//my+p9xNbCX2c+KorFvfwNe5WQWHiOLV9ebB5bGPkb3U7zCNkjULUPxjqt2VdDGaiD8nGOBs4YGhWdmNZk6c/P7lK4tEKUQfyhSYGSP+IBd1DMTsdiFnmvG56QSmnxc6uNQLVtW4VxnMc/JutQ6B9stkPeDsubizxJfgGnyJURME9uGmfIo79HEFJ6+yFNwqYFtLcScgnV/RPHx0ZoU4FmQYhfWhQqJzF/V+2OM/szYnMHdUEQExbi9JFTOSk6sSRTytIso2xbIbsolqTRxwNGQg8M9Fb7j3PbDXe2neYKz6AXTRtOtnbKmnsojSsE9KDDvjDW2VQ/5arHzvuwhJpY1X0PwTWPej5//tgPywQ/Am1ZBo5HGfmcbfqd4X8N+95NFNY6z8FEyzFUuax1F2HXxIVc7yyF3MP/quhMlig/IAHwYnFao8xR3uAxXZQr4oS8MUpRXALZoak1E89eo3WmwvWvmDQ/hoXdkcaj7hgYUdtI5DEaTSEh3UxJeNoKh+B+/mhPLjlYjFM8fQoLT2DDpg1Iby6fs7jhQlRgWDn0mRf2MJPb18hf8fy+yk3btgKCnUvJRFL/bG
 xjsoJ+3/
 OMFJCTy2F4Uxh3oGqzQZZ7od/PjiwEYwBLwkJNRe1M8DBglMXFk6emV63HAcrze8dIaO8WyjYEyXA7RgcJuyFB9shbjfQaM56myTP0/k+XQgFRtj4vqTo6UO0TEn5QzvqeUc+iZm82601I/JofKby281u8k6j5GPJC6pw45bKcLNIYQqdEQasPriXHYHAElWTI1ORmy4uD6rdUas7hOTwpRHJ9ytattFlz0kXl3AsyjiXA5E0gcc/GypqtxFRgo+bnzwNf9a8wrEZhdPtEIBfd/Z1M6k3kUDMLfn1hBG670Yymv/qDsKSo16LAQZ0zaVAcWsx2LpVGuprHjVolAxpFSs5SwE1ZUCL9OTLJiElg2J2v/Ssc2O+vM6DfQ0o5ST7DvQAiOXp2ufGz+6MUV4usv0NjUYPd/vZwGryzefDfvKSOYzVMe7/ZBAAhxIhV+2nmFj49OzesA/2jPxron9I6133rFeNfAgeLXyA6DL+g39SzvoY750PZQpnfOiP3B1WkLQ4gjdGe8OOrFE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds an API for declaring an using per-CPU variables from
Rust, and it also adds support for Rust access to C per-CPU variables
(subject to some soundness requirements). It also adds a small sample
module, samples/rust/rust_percpu.rs, in the vein of lib/percpu_test.c.

---
Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>

---
Changes in v3:
- Add a `CheckedPerCpuToken` that enables usage of per-CPU variables via
  a `&T`, allowing for a wholly safe interface when `T` allows for
  interior mutability (Thanks Benno Lossin)
- Add support for non-zeroable types to be used in a `DynamicPerCpu`.
- Remove necessity for `unsafe` to get a `StaticPerCpu` from its
  declaration (Thanks Benno Lossin)
- Allow the declaration of static per-CPU variables of types that are
  `!Sync`.
- Implement `PerCpuPtr` in terms of `MaybeUninit<T>` rather than `T` so
  as to keep all invariants in the `DynamicPerCpu` and `StaticPerCpu`
  types --- this would also enable `PerCpuPtr` to be used in a per-CPU
  type that does lazy initialization.
- Link to v2: https://lore.kernel.org/r/20250712-rust-percpu-v2-0-826f2567521b@gmail.com

Changes in v2:
- Fix kernel test robot issues
- Fix documentation error
- Require `T: Zeroable` in the dynamic case
- Link to v1: https://lore.kernel.org/r/20250624-rust-percpu-v1-0-9c59b07d2a9c@gmail.com

Changes in v1:
- Use wrapping_add in `PerCpuPtr::get_ref` since overflow is expected.
- Separate the dynamic and static cases, with shared logic in a
  `PerCpuPtr` type.
- Implement pin-hole optimizations for numeric types
- Don't assume `GFP_KERNEL` when allocating the `Arc` in the dynamic
  case.
- Link to RFC v2: https://lore.kernel.org/r/20250414-rust-percpu-v2-0-5ea0d0de13a5@gmail.com

Changes in RFC v2:
- Renamed PerCpuVariable to StaticPerCpuSymbol to be more descriptive
- Support dynamically allocated per-CPU variables via the
  PerCpuAllocation type. Rework statically allocated variables to use
  this new type.
- Make use of a token/closure-based API via the PerCpu and PerCpuToken
  types, rather than an API based on PerCpuRef that automatically
  Deref(Mut)'s into a &(mut) T.
- Rebased
- Link to RFC: https://lore.kernel.org/r/20241219-rust-percpu-v1-0-209117e822b1@gmail.com

---
Mitchell Levy (7):
      rust: percpu: introduce a rust API for per-CPU variables
      rust: percpu: add a rust per-CPU variable sample
      rust: cpumask: Add a `Cpumask` iterator
      rust: cpumask: Add getters for globally defined cpumasks
      rust: percpu: Support non-zeroable types for DynamicPerCpu
      rust: percpu: Add pin-hole optimizations for numerics
      rust: percpu: cache per-CPU pointers in the dynamic case

 rust/helpers/cpumask.c          |   5 +
 rust/helpers/helpers.c          |   2 +
 rust/helpers/percpu.c           |  20 +++
 rust/helpers/preempt.c          |  14 ++
 rust/kernel/cpumask.rs          |  94 ++++++++++++-
 rust/kernel/lib.rs              |   3 +
 rust/kernel/percpu.rs           | 239 +++++++++++++++++++++++++++++++++
 rust/kernel/percpu/cpu_guard.rs |  35 +++++
 rust/kernel/percpu/dynamic.rs   | 127 ++++++++++++++++++
 rust/kernel/percpu/numeric.rs   | 128 ++++++++++++++++++
 rust/kernel/percpu/static_.rs   | 132 +++++++++++++++++++
 samples/rust/Kconfig            |   9 ++
 samples/rust/Makefile           |   1 +
 samples/rust/rust_percpu.rs     | 284 ++++++++++++++++++++++++++++++++++++++++
 14 files changed, 1092 insertions(+), 1 deletion(-)
---
base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
change-id: 20240813-rust-percpu-ea2f54b5da33

Best regards,
-- 
Mitchell Levy <levymitchell0@gmail.com>


