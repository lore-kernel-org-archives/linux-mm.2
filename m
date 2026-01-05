Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA2EC79F87
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 12:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5F66B013F; Mon,  5 Jan 2026 07:42:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47AED6B0140; Mon,  5 Jan 2026 07:42:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A256B0141; Mon,  5 Jan 2026 07:42:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22B136B013F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:42:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77A421A2579
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:42:42 +0000 (UTC)
X-FDA: 84297874164.16.32B53A5
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 869D9C000D
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:42:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SNjDn4O6;
	spf=pass (imf22.hostedemail.com: domain of 3vrFbaQkKCOEDOLFHUbKOJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3vrFbaQkKCOEDOLFHUbKOJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767616960; a=rsa-sha256;
	cv=none;
	b=S1os82o9YxnJQ2YmkbtjVYM+1RaB62Le5E99iKm6zsGwN8SzecgbRUa54G9R7PDQGTsdAD
	rl2dALLP/DKFLzDQur0DAVMndDnN34EITm1bAsd4Q6ND/hyad/JIJdHgWp8PM6OkcADj9b
	5t8gO8f8nKz16VBQVnN5u2sAKOvclkE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SNjDn4O6;
	spf=pass (imf22.hostedemail.com: domain of 3vrFbaQkKCOEDOLFHUbKOJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3vrFbaQkKCOEDOLFHUbKOJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767616960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=suTH4y/aK07UioTUbupgL2cgp19BWpg3A0c3oYdgR0I=;
	b=thix9tfaePLKj6+xVwJ/gi6tskRn1HBWz6aJEqgvB3PhkMwjqTp9Y6ZFBVgL4Xk24L5IzP
	P4WXlU8UcoNXF/Ie44Ds43w/bF8Lr1N1n3mm0Ogdrh0KEkPdkL4xcHvbnnMGKNFC5Ha7kQ
	CWDHFikB83Zmhi3ejKc2KEiFqfimGmA=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b8395caeab6so55326066b.2
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 04:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767616959; x=1768221759; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=suTH4y/aK07UioTUbupgL2cgp19BWpg3A0c3oYdgR0I=;
        b=SNjDn4O64NBZnwyUErYEHjMF1GpvIgT2bbep6NaXBJ1Yb6zeQaLh2rKzJp+IfFY3+M
         Gk3yrCYE2Bx9a0QlnsISiYfYKkwT8wfgj9wmoDzxPlfEL1fJAg1ltMXBRAmM97//itk6
         26Ai8f3IOGe0skr0K9gGeq5+zLP7os4HybHrjQfK4YAQcXP8ZSSyeO3PLPPrg1quzwsj
         dxaaACh/NqxqgzEJKo0o9AFludIWIxqjkewdiZVhnP8RbfC8M+xORZZS1qIa2jZG1Fwc
         Vf3hxA7X1ixxvoFcHzQfzxZy5F08irdRyGg90YDSSAYBNVEAbbnI1o2yf2hXARsk5Jts
         xg/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767616959; x=1768221759;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=suTH4y/aK07UioTUbupgL2cgp19BWpg3A0c3oYdgR0I=;
        b=ldwM01JKUU45RJyeTBXm7zE5zNQNVFzrX0t0DeB948df0vbR78Op93FbEy/R9hQtKH
         r97fE2KFOIbf1MNE+IQwV8mhJL8eGxerYJXtwtt0T80ILpmoun6Y1t7EKFeN9QEkjY7s
         n+3uoBFNzV4kjW6wLwF+NZyAkZ7P1PaSXstWogYaAc6onoK4BwJAXfjpmNI57Sz0DJa9
         6ki9RSSwQuJurNsyyfMZhX/MW5zUFqYtCw+PnQeKDAYIZNLKR9hL01PSZpXw5VmDjjyj
         EDRTYhmQcNxHQ5UXVpWyAomFpXXOoNnT4nlsFTdc0E5ekAxAKs4W59hUe381LbMllzVe
         g27A==
X-Forwarded-Encrypted: i=1; AJvYcCVqQhHGs1Qa8YBzhG9jZPS/GRXSbwJZuAQYn3w+09DUD+5mBokStnzegEEb18FY+Oxy4YbjrI0N0Q==@kvack.org
X-Gm-Message-State: AOJu0YwoWQsXGL+w41ufnb9kUTx2EvqSLJI9+NJIVkyCGT4rw4rMqUZe
	Cu53SYVmyN9zFUZd6rP0rnPtWM6aJF60cJxBixqZFNoXRg6xzZfffmJ0mTBGBI3qwXAbLYJteHN
	9ebPqZoE0bRxccdOBjQ==
X-Google-Smtp-Source: AGHT+IGf1O7IHkQTlTr95Pslbnl5wrFL8+HDWkBjzBEOHejeoVvO3AomqVuVaw8gUaSkcMI/MyfZHpwyBJwWEqs=
X-Received: from ejcul5.prod.google.com ([2002:a17:907:ca85:b0:b73:3b0d:754d])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:318c:b0:b80:402e:6e77 with SMTP id a640c23a62f3a-b80402e6f1fmr3924567866b.54.1767616958861;
 Mon, 05 Jan 2026 04:42:38 -0800 (PST)
Date: Mon, 05 Jan 2026 12:42:13 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAKWxW2kC/32NTQrCMBCFr1Jm7UgmoUZceQ/pok2nSaAmJalBK
 b27sQdw8+B7vJ8NMifPGW7NBomLzz6GCvLUgHF9sIx+rAxSyJaq4MiTD4zplVd0PC+ccNJDq+h
 KSggNtbikmnkfo4+usvN5jelzfBT6uX/nCqHAXjIpMxjS/eVuY7Qzn018Qrfv+xf9TXaXtQAAA A==
X-Change-Id: 20251202-define-rust-helper-f7b531813007
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=5550; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=kMOE8SG+apSYdkSF9wxqn459O1XV4mgd4R9CI30yqRE=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpW7G2KP3s3XkvuUe28vfCsN8trnhXVpe23MOsp
 r09yEuuWCGJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaVuxtgAKCRAEWL7uWMY5
 RvWlEAClQm3dLefLdyw558cl7DXXFM/HG6E0PYtjbQN8CJN5Z73NMsBCPkh4yi3buGxEDSwuLgK
 knLtqhBaD1uekLELc+gYUWfr87wmwKWNdTFPwiPPorV51hNabNaXw8G7fOYYMdF+oxPpF/1MkqL
 +h2mkAAuC4NIQrJ858OmgnAGAMmLTFdB1n+a62gCy4lbEQ+P19PHaV421HMwhz7HZ2zymicnR/I
 YQegrNv3LY5G3K38u1cG0t0TmheZacr6GTA969Qw4qbJHpcuwYXq7kxEqXbgX6m59pwD3Wjjpry
 hw/QZRKqddie8OdfN4X9hVSaRnZ2YTxS914ZbYHeNxK2aAKzT3hK7KA+iR9yICYNMqRl6tfchAn
 dbu/pDyjlflom6arj6cS+By423tUdk5jbgU5+GtHRr6jE58lI65j3HOKfdWNAGC68BugTffPYy4
 ZB6WJ7vIOjICkbpwY3OY8xNiKhiA8NRRgNDmBCtMrU4q1Z02hhm639rqkLt4Ls9fGBvO9/g97YD
 6dOKVGW4yqgDQhLSoUQhSGPZSRLMfaz9tqZ4lsyNhCq0/edLIJfsQhCRB3ZHADjjhOMMHK/lpdZ
 w1UiXgV48Dh91eOwO4H2r6iHlqp4Eydgtc/WDsVIaegqEKCM57R/ttatf0zojd8qfWcDHJyPgdD qkahi/Z6S+Gc45Q==
X-Mailer: b4 0.14.2
Message-ID: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
Subject: [PATCH v2 00/27] Allow inlining C helpers into Rust when using LTO
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Peter Zijlstra <peterz@infradead.org>, Elle Rhumsaa <elle@weathered-steel.dev>, 
	Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Michael Turquette <mturquette@baylibre.com>, Stephen Boyd <sboyd@kernel.org>, linux-clk@vger.kernel.org, 
	Benno Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <sergeh@kernel.org>, linux-security-module@vger.kernel.org, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Jason Baron <jbaron@akamai.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Vitaly Wool <vitaly.wool@konsulko.se>, 
	Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org, 
	Daniel Almeida <daniel.almeida@collabora.com>, Michal Wilczynski <m.wilczynski@samsung.com>, 
	linux-pwm@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>, rcu@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Fiona Behrens <me@kloenk.dev>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>, 
	Waiman Long <longman@redhat.com>, Mitchell Levy <levymitchell0@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, linux-usb@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@gmail.com>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 869D9C000D
X-Rspamd-Server: rspam04
X-Stat-Signature: 7fr11zbo8a8bmie4jwdf4j7g731atwda
X-HE-Tag: 1767616960-743687
X-HE-Meta: U2FsdGVkX1+8FAygg0UOItmOUOoq8VYHFJ/Ozju0n0INQuA7dXpCMyDrXeNnd11KTX1v7sZPeTyVC9L5eYAVuGx+2xmTxnX25bn3uJoRFAgg/SMWrOTKT4VY2lb1Rq9zZyvRI4JWbc/WMdM5OdqZJyF9yH5dSuIHGcj8arPCAku8GI2dzeKjdDuXrfX1EJwWv2N1deGCNLAsvRnAjeLA87bTvTX3UAR6ySvoIM5p92OmHD6m9bOU3JrQ8bEFfhD9HLLZ9ooyjvUdUhhWeIpBOzQ751km4tRKk34Uhsxguka3wI6EoA2IHreauZ07iArYUuSoANCi5aSgly0OvTTHtlQIE1W+FEsyRuNDs/4YxiCRJI2qOQknx0vtgilVY/Q7yQ9duB+2OX1vGVAXXACXbBeN12ziATPCQ9eTs5OoKkgzMNt+reFs12/k6RcPGNjrtHWujAR9DRvSFo9KQ2nV9BMj75xNHC1foJGeRUoaER0bN9Qn6XErTgqB9NLK293cScFL77OX9SAamvtfse1Nt0LqzWHCiivOF2l8hYq/j7FV+aH6TOqZSQfxSD/r6kVr8YZ0P9uWkriF793kDLiIJl9yiiJ+AjeZOikuEF6iA6hak73Xs4itNtkd8iGbCRywEb1hiWxhtH8FRLxY56m3XqB6UucUtTBsvbQ6kJrPStgeCAm01AEKipky4rEskmDNf1P+uXIghtCzzvZ+oLQr27V7Xc+loTQ8HufbfQkNw97uvD/SxYZNXxxzSvxIJx16dlZ9B5xvrt5usG+C6yShcHFp660DJJhUwmlYlghB+/HnK4fIwVW+jXq6X8R6KuKmvE4UyaQc7qet41pwebOTT77pVYsUICsPPpmxSk1CnnoM1P1CiMNgggHt+mFyXAIixuvvbAUi7lPMhJUoe+nS1diBC6JkouMmP6S9UbbGu8zvuNqxAcyyFgVINO5mfWaULvaV85Y/BXl8CYU0j5u
 cTxY2xxt
 MLZIJDB2Y3YLTMmP+tuVAKDD9Rcefx12kh77rhyATVLMS0oPfQlYw1YsPH+/fbaUnKHxYsa0UovsdUmM2B2EhxLxCG3Z9hsBhZC+rpE5jGemdyfgsqAYomQiSeGinGQLTqdlmxyrxo0Xd/txxQld4VRe9v9K4m8kF34iIDT/nBNmoRPjWguQyUldFkwEP0Fwc/3JaejencF6xjia6fT17JeKWtDSr/vhmGT8uRRAjy5tryM8FeQS4D+1siHBnZQ1ev/4Nk46G5+M/HSdVVcU3if1KIQ8+0EIeH7znhgKxrkC8gkTbuZ18U/HgWqtx+/gPvGB8b3Rw9uBnnXTgolRThrIngm5O0PumIQ0I3QrDP86lg5v2ulg+VwUZwdqkVGYN9gXs3S37CcnOZ4bHTJqyMLGVx/KE/+wHVHvCylXH7B9oVBw2LqG03fnf9u0DKcwlvMqG5i/Ne6HzuazDy+TeZakiYrfb2POgTGSCkkThv/YFcsSTK6p2Mz7lDdIDnIqWBKu5XrHs00ReOyBbf9JGw0qmwFgyYopHTGMKpOx0aSv6vFK1le4gKlU0u/7anVrviJusQ1hFPrQJ7KwpDlkqjdnyXCEv2VamwPlRbdeCE1TA0ETsTWTs+zxuh97Wy60twgBK6tSmkZjUZH8uxvmTz8vNXScHtBrhsEsuuujyUtqClwZNtq7pgztSmnUDCasccys3pK5Qo9Ctvgd8tN0VEvsd6Aavi4w4TVEAGq6UyH8KFVk=
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
Changes in v2:
- Pick up Reviewed-by: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>
- Update formatting in mm and slab patches.
- Add new helpers in files uaccess, pwm, and time.
- Drop any patches that have been merged.
- Link to v1: https://lore.kernel.org/r/20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com

---
Alice Ryhl (27):
      rust: barrier: add __rust_helper to helpers
      rust: blk: add __rust_helper to helpers
      rust: bug: add __rust_helper to helpers
      rust: clk: add __rust_helper to helpers
      rust: completion: add __rust_helper to helpers
      rust: cpu: add __rust_helper to helpers
      rust: cred: add __rust_helper to helpers
      rust: err: add __rust_helper to helpers
      rust: jump_label: add __rust_helper to helpers
      rust: maple_tree: add __rust_helper to helpers
      rust: mm: add __rust_helper to helpers
      rust: of: add __rust_helper to helpers
      rust: processor: add __rust_helper to helpers
      rust: pwm: add __rust_helper to helpers
      rust: rbtree: add __rust_helper to helpers
      rust: rcu: add __rust_helper to helpers
      rust: refcount: add __rust_helper to helpers
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

 rust/helpers/barrier.c    |  6 +++---
 rust/helpers/blk.c        |  4 ++--
 rust/helpers/bug.c        |  4 ++--
 rust/helpers/build_bug.c  |  2 +-
 rust/helpers/clk.c        | 24 +++++++++++++-----------
 rust/helpers/completion.c |  2 +-
 rust/helpers/cpu.c        |  2 +-
 rust/helpers/cred.c       |  4 ++--
 rust/helpers/err.c        |  6 +++---
 rust/helpers/jump_label.c |  2 +-
 rust/helpers/maple_tree.c |  3 ++-
 rust/helpers/mm.c         | 20 ++++++++++----------
 rust/helpers/mutex.c      | 13 +++++++------
 rust/helpers/of.c         |  2 +-
 rust/helpers/page.c       |  9 +++++----
 rust/helpers/processor.c  |  2 +-
 rust/helpers/pwm.c        |  6 +++---
 rust/helpers/rbtree.c     |  9 +++++----
 rust/helpers/rcu.c        |  4 ++--
 rust/helpers/refcount.c   | 10 +++++-----
 rust/helpers/security.c   | 26 +++++++++++++++-----------
 rust/helpers/signal.c     |  2 +-
 rust/helpers/slab.c       |  4 ++--
 rust/helpers/spinlock.c   | 13 +++++++------
 rust/helpers/sync.c       |  4 ++--
 rust/helpers/task.c       | 24 ++++++++++++------------
 rust/helpers/time.c       | 14 +++++++-------
 rust/helpers/uaccess.c    | 10 ++++++----
 rust/helpers/usb.c        |  3 ++-
 rust/helpers/vmalloc.c    |  2 +-
 rust/helpers/wait.c       |  2 +-
 rust/helpers/workqueue.c  |  8 +++++---
 rust/helpers/xarray.c     | 10 +++++-----
 33 files changed, 136 insertions(+), 120 deletions(-)
---
base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
change-id: 20251202-define-rust-helper-f7b531813007

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


