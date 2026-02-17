Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F029E909A6
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 14:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789636B0005; Tue, 17 Feb 2026 09:22:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737546B0089; Tue, 17 Feb 2026 09:22:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F5C6B008A; Tue, 17 Feb 2026 09:22:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD666B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:22:55 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D20C4B5B7E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:22:54 +0000 (UTC)
X-FDA: 84454165068.27.10B6E80
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id F217D180019
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:22:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nhOaqmqD;
	spf=pass (imf24.hostedemail.com: domain of 3unmUaQkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3unmUaQkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771338173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9toli3up5J45j2dd4uhudMM/Hy4EA7BHUmvoc7k8+8Y=;
	b=tgYYrlMmJyfW5qDXOtBwavZbrsdH74T30qkNCOdA70P0wLccZZiV/U/c8XUacbdXsoQ/oL
	ECIqWjoFXa/lYm49qk6O6WwIglBOhcF5St0a8FAhtb2XfL1zzyC9OpNEYorEvsdUegBvm2
	dIdwzuAT5fupxpBgQU5ndJC7RJ8GHwk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nhOaqmqD;
	spf=pass (imf24.hostedemail.com: domain of 3unmUaQkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3unmUaQkKCFMv63xzCJ2619916z.x97638FI-775Gvx5.9C1@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771338173; a=rsa-sha256;
	cv=none;
	b=sXMBThNWKMa6npgodk7DsybvekxjRo70ByU4WWdG0K7kiXhz4NgHoTyHXslbRei90mEh8D
	7sZHlpEkMkXvD7jJt24UPw6TGJ/5mmW9cpEFw3GqqqaAOMSSagVmQ8t+Cb+6JvgCQG5M1F
	DV4dSismhw987eoxr5OGh6wNLFtC/YE=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4830e7c6131so43246625e9.2
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 06:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771338171; x=1771942971; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9toli3up5J45j2dd4uhudMM/Hy4EA7BHUmvoc7k8+8Y=;
        b=nhOaqmqDvLX2T8Kp8WABfbvU9qe1d7fqoAS4XiHFK+d6i+TrmHTSuu96GkdTbW6aPP
         gWAwOB+CpR6vf29tsNMMgpuJwVK0rC7t+Y5lYFL/mL0pZ9pJ6oZyCWe4k0xTi+9MphLa
         /5QsUPlWzGVnja5t3CMJj07X2Vdh97iq47wDTPIfk0xiu3IlUbNBtofIG0uRhlaEWHaK
         HQ4AUoDEgYx8TcQkLAdNLakNUlSFN7X0amBiARXV6Qr9lEXOGMZibvdDci7bRTJUnlAJ
         i7YWkw0weOI2uQFRBPiCUD7czpsi14R4KnO9fEbSFRL9cATB5QM4Vh/R6P1auJjizoUD
         39Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771338171; x=1771942971;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9toli3up5J45j2dd4uhudMM/Hy4EA7BHUmvoc7k8+8Y=;
        b=AY+lOVrYLBp94laye7yGHvwFlw29idARa0LBEgi/wnDxol4WQc9NW93zeC8zYIOxVa
         OSrdR05dpNxEDfLFEYtvj0A15ORzNsOHQWFrq13acDax6GHrsfLE478h1mEzaF59h9Hw
         rCCSkpKwHC//4nggFPKDe0FrIT9Finqr4AEcwsl4Iie4EtHM8D0TayOvUWhC8afCz2kS
         bsKBDnU/cLl3q5FwQx+0kvXyk5MhtXge3cXb1/2FTxyqW8InygYynrFbNnn1d/fIHvX2
         QlPLSaew/kjoBeOhp5Sf+uOV3rZFbdQ3UB3K188wbNeLLL027y4Lxf7OBfv/uPLD9JmA
         8kOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeyKrBqX3XvlTje1QGCPZ+w3kMTYC+js7lWAla2uf/8q6lTYZmjnYxrZu+U8I9DeA6E4fncXnyIw==@kvack.org
X-Gm-Message-State: AOJu0YxsEwuhMWPNRcY+Y57b/uiForuqV+gITGRLROz/zqumPXts7uhx
	a3EDz/ds3NFsplbm6MzDc8ef4q/s3dNdhK3s541oveWjf+lVr3dOrG1gZ1yiGV3RaHIlLFUwLas
	leOKeceb2AMCdFOu5IA==
X-Received: from wmhp19.prod.google.com ([2002:a05:600c:4193:b0:47e:e414:b8fa])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c25:b0:47d:3ead:7440 with SMTP id 5b1f17b1804b1-48379c14606mr166623145e9.32.1771338170924;
 Tue, 17 Feb 2026 06:22:50 -0800 (PST)
Date: Tue, 17 Feb 2026 14:22:37 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAK15lGkC/x3MTQqAIBBA4avIrBtICfu5SrSwacohslCIILx70
 vJbvPdC4iicYFAvRL4lyRkKdKWAvAsboyzFYGpja6NbnCUsHPE+HJJn2nG2K7nGcN9ZgpJdkVd 5/uU45fwBLWfJ0WIAAAA=
X-Change-Id: 20260217-binder-vma-check-b6fca42e986c
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=785; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=Uxj6c/az0LdP8dZc8T2qUy7YzybZMS/bT4hkQ1PgX0M=;
 b=kA0DAAoBBFi+7ljGOUYByyZiAGmUebChDZjcwqWd8ZRbjOtAua4kbQQ1RMjHoMr3X+QKWSs7w
 IkCMwQAAQoAHRYhBIOSopRNZAcK8Ui9sgRYvu5YxjlGBQJplHmwAAoJEARYvu5YxjlGryIP/320
 NWn4fxONCqcMTOqDq7viBcZ3G6cxX5lNXZSB9kDxtKeq7LDW4cLWm9VX6fr1A56iPtfHeln2qUw
 pGXpgDCEASmiabi+l3mJ6/IK1BXXtjwvoOrtmestBi8xAHM/iHsbuLYMedwUJNoMt+PgfXy5mFU
 /epRzgdGg771b5ltgKB2pablfJ+KX4qP7bYGrVfBzBq6hC2ngTCndBsvlE8pDKnSimggXz80Vzk
 Ukm2TczsIRVTYjAOdOhlcSJgdH4WKBwZgp59FVHfQqcEqFS41t8+ESMTuCM60Ct4vgfLXebEzRc
 Zi9iZK/pDfTxfTaPHvR4ubu1GhP+RQ0bsJ+lA0zm5DSoWHJqY8rM+j140oTdjG3wIJN6aSdNJNo
 Qrf8h8aVTIA/WoP6UH/J1e8Hwgcm5lUCLvikrcxPNMOnm1C33GWY7YulmlHNkB91OOPT9l2RilC
 +lm+PPMBXh6baCKzAePnHDwoz6vVdAwrNW/koNi0ar3PmB+FMWcL/tWtiM7svIlCZHp4ttGGmfa
 PXMGPYPXwKIR9UXSg57HSKuSK/QTHGqaPQjRzPCH0L+3Hi6aXnWkFAINwen5CdEdoLAKI1G1f5U
 fg1F23FGI67l3+WChvssHlymiiakrGek7YMGUvW3VokUGzsn2gfQjMU76NnEYD0A2LfWM4HfgD1 6+PNs
X-Mailer: b4 0.14.2
Message-ID: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com>
Subject: [PATCH 0/2] Fix VMA confusion in Rust Binder
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Jann Horn <jannh@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: kidejmw59xy84yp84zyan1f7gysjnoj5
X-Rspam-User: 
X-Rspamd-Queue-Id: F217D180019
X-Rspamd-Server: rspam01
X-HE-Tag: 1771338172-377660
X-HE-Meta: U2FsdGVkX1/J7mwHdG64UmHabXlPCsrOOuQw/AMKxzqNCPJHwbkLxxXENNyVY49y53t1UIZ8svoSG3soCnuC5JbbAIH+0xcDe+2BorfzG5k4ZrmRyi6R8YPZ1V30kDtn0hDpk2uoI1T3yFl2OVJ+MKWeWMVPpGC02R7pg6kvG2ZEusb74Vy4934XN2BfRZNs3m1eflXnJLnDZUODak8Oczp92h/0D7t1dwm4SuJLNX0J+A9ejTUlMXcz352HzLCTkU3cq34VClRpkwLZ7v/pxsNzlx25GvtVii4kOIghrbnZ+Vb2YQZM7+dpzKlmcfa0zVljv4fws+dSaDI3OOgxXZeZXs6SO/RxUDY4WDyv7RwKvsN+PF+O/t045QUW8WtPo+Yg1mzMzlPxZJ+0vhyggRjqzi3O37UNJ7rJZbmwBIe+FZ2oHU4o3D4PzRsDWtbCN2/VbEZMnktHfZotrg7sxVOxK/q+dy2uI7ZB5LJivJrMQmUWaq5HlgWY86KwSSfsnyKAZ1P/DaaGEesnPD75Ove5WsBUQPNXvjYafUxdtD5DeIbMWzqs0CCHYSvDD4lSurNNdzarc47DHhV59UiKw9zByjqhQno4VbuUySAZqW4vB1ckcEF62xPv6PGs6pmqnqZl9J/MexBWcIsq/MUEtdGC7f0QRVFF+WV3j5UUaErSpp32AgtuVzGCQJxxPLrhgiuTosiNI/VbafhS6voiXe3x1PTb3p95Not7hXmfPtrBed3vTV1hA12/88LsvP0JEC1lrnRfF25Cn5hFoK8HSGsL7tcXualBExQ9j8GBu+xegCLRxVL1S5iWZ0pyjD6yl/ANgOMu+3Rs3C9h7KqQTZrw1Nl2dOJEIjWPMtI3zGnFHMXrCLgUtxH/ySvdgXfxSuglPsU4RLifysoxdhAxP8qNUQobYRgaXxO3+HYOmw4yrtNmGVChYD5+gVhCFfr8YyfMDXeME28FDL4tNOp
 2EoQvrsO
 FLFd4/TVUCgkdFdE0HW64nOCds0B4MRWEhIahdbNCvr61NkoeW0eyJMeHG7++1g0wyJRwIuLt7zO6IlU0n9YGJRxdBIsr/ZZ7ZXs30m5JtEHUjnJyrcN/rdwSZwHPRnXsNawMdCgaRfzHZQGcg8PlnmgrBivqyZ3MAdBUFxkM3SGNLBT+7oC6AdgtvWC53exqWnYThXw414in6eYqr6J6pFsOT9tMB5J8KtIaAF2GQtttT8BBEueMBfJjO0aWRD1FPlcLdHnErBbqB169ViE7iE3DBWDfC3fxNiecRlwbiYIq3ptC0QifJEWs9n9sgIyHuz33CdoE9Sdz402TE0fOASHdwbnRg1AnFYoZeYD+tE813sQhAHCJkFcRYvvSD2M3Tkh3N9bHd/0NQ5MELeJuq8nS3JAq0u+hW2NsZ1CGcahhQFwLGuh7g2Jw+3TJtNdOOraffRD3kMpI0jGvoTesM9EZ8uXHVMYLMsZ2KHBgcNqMBrjPFkeC8yI/hbkbDWNlUogCaJTgeu42Ce9cCHWt3SmlQqfXj3OX1Peueerr/SLN2rfk35wR36sjm38H8lnikM5h7Oc7MAu3JnaTxZEz+mR+QWFfHGpowanAfQJNujHk8P+tWHX5HX/NSENk5NfW+WD7c3/9SK18VuiUHc7UVCUQzeUn+91hz4GVv+wtrZVlQFk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series contains two bugfixes for Rust Binder. I'd like to follow
them up with better solutions by changing the VMA api, but as an
immediate fix this should work.

See the first commit for an explanation of the actual bug.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Alice Ryhl (2):
      rust_binder: check ownership before using vma
      rust_binder: avoid reading the written value in offsets array

 drivers/android/binder/page_range.rs | 78 +++++++++++++++++++++++++++---------
 drivers/android/binder/thread.rs     | 17 +++-----
 2 files changed, 64 insertions(+), 31 deletions(-)
---
base-commit: 0f2acd3148e0ef42bdacbd477f90e8533f96b2ac
change-id: 20260217-binder-vma-check-b6fca42e986c

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


