Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0399DCD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6646B6B00AC; Thu,  4 Jun 2026 16:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63B586B00AD; Thu,  4 Jun 2026 16:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551666B00AE; Thu,  4 Jun 2026 16:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 434E86B00AC
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:14:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04E1C16200A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:14:17 +0000 (UTC)
X-FDA: 84843332196.29.F22ED93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 421001C000A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:14:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUSWvnjj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780604056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDKImhxSIS/fNprfWQIRF9/bFD0CG+MEzEYu4ZjZLR0=;
	b=GHYVGRofn+Qaby7+4i5DD2z13g1qQ8BYAPLhQJsqo/z6WVEkQDTrRDyKbKTz/foe2Bwlqp
	BWppRfXddKGtgyr0sKQShyxk5NwVz7eKJRYMDX1I9aWSNwV3TIEEOfJ4CZrr6tJxRHRsqK
	xp3nV03mvPTht5p1G29Q8O1BfT9313w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HUSWvnjj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780604056;
	b=tsfkcimfYRfrPTtHS1Vax6T5lacQnFLyOQ7KNwiVPMm9ho26vN7jXz81+9uiZif7t4DNxT
	9Jw2GjLBF3ZWLc0cFOw3eV7GeOKxmART1uvEJmprNZAKeAoECJ1gKIv9KZikqErsDMBJys
	vawj+R7g0R+UcRs2KNnbaj+CiWMDbCw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBE4160139;
	Thu,  4 Jun 2026 20:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411F81F00893;
	Thu,  4 Jun 2026 20:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780604055;
	bh=UDKImhxSIS/fNprfWQIRF9/bFD0CG+MEzEYu4ZjZLR0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HUSWvnjjP2E25THnS10KhqGscgSWfXPY9OTuEU2lXvu8sGjibTgS2hJh1c7sVR233
	 ZsSMfrGf5wan4J4lQaBQPFxwxHEfkZB+SyslGH0qiD3tupaMJGOF+xfVCXrdCa2nop
	 bfZ4DrP5VtkcSumcTB7mPODx29giM+ghh+FTkROTaLEuAE6mh6otpO2xPVgZt2DqVC
	 XWOJbv6sA3Uf/sptnzfc7WprUW0qPW12ITimONL3qIMyuoyGZsERZkyT7yyp4AoXjJ
	 JSPLPuTZtHSv89xBRY2E+XCGkG/WIy0HPLdmYvkNEYRY8uN7duiAc2vqNKEQ6Rg+2N
	 1E1gmpx/gdZhQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 22:11:16 +0200
Subject: [PATCH v17 04/10] rust: page: update formatting of `use`
 statements
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-unique-ref-v17-4-7b4c3d2930b9@kernel.org>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
In-Reply-To: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Igor Korotin <igor.korotin@linux.dev>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Boqun Feng <boqun@kernel.org>, 
 Igor Korotin <igor.korotin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, driver-core@lists.linux.dev
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=908; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=4RyZCw8fL1vZdiYtCKnYPrhKo0dFDXqsJU7kpadSv3Q=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdvpNRczTi1MEzbEqRlUSeyXZWfTU4TEqBFL8
 dQ624Rhe9eJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHb6QAKCRD6UCkIqsW9
 0GdUD/4yqmBAhNqMpqX2A7JxCA0GG24Vbr11LAL40KqFhbTCAdt3gGkUa/a9Rz9aqi3vkCbe/ST
 FnkQd+bp2YQxM1v4HvkNdYl6bMHsOvU18ZPZoCGKvZQdn0lKxUF293/3c9nt0kC71fWAfWL4wUP
 uy/AgLXJiQ/bVHs8H1//ZL7q//UZyzTjudKIDdn/EdREN8oXJP4QpPMHfnIzWC61sddwm6SZq1X
 7VkKcUzxtOBs75BHWPMXfiC3Xg8KePSbkgSlhLUO70BrcXgRRSLmRRKacG6XS26Yz0me2pRnu7b
 cbjUrbadHMO3LNeUwdHuQjW+WEvIrm1sTyrM0G+4DxAuLLKNhoeiHC192iqOdYproBsGzIdxZ/W
 CcTR5LugyvvJIpEIvAXhvq2C8XTPF3dR/lAhBfHr4vph7dFDwfsiucAQpcXJSOtQ7coI+ZX7Rct
 JvnjdjshEue1W9UTO9m5UWjnXARSegihnwosgjfAX5rft8kqmQ8bOKDDpcHvHZ3qVnJWK/be+Oe
 aq7VqUaKnUOsvjxnxfFEc0jDhigeUxIZUPxZrJeTV1ak7jdJAjZNBIC+vvQ72+hBMXRMIclDCVe
 vviPbhfux8KOliVlfgAoDzFODyHymtIfsJkBJBNpxpvX3P3KI581baQQA6LqlsWWHywfzYv01nt
 XV4VKoWPUlCeb/g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: db1a51w3rcs891od6c5p49hydmaphubo
X-Rspamd-Queue-Id: 421001C000A
X-HE-Tag: 1780604056-929413
X-HE-Meta: U2FsdGVkX1++n162m3q3CwYf/zw3+a8fpALS/O+Y9bt2iKK/tMyGhpKof9/4Q4kvGk0yNg76ZyO8BrDdmtt1kgear3sbbx/S+1yAwa63Q4C6VjLrb8RI11vJn/edlE8pWGAOi8ubjyRsCeg1SS8mH1hVLHEEjmtOUogWMiBklrZkfZdFNlvnfj5Vh/LEkwcjGrdRd94+90AkvARdm6A0km57XTAVfY86RHDUKI4j5nXKSPK6TaDQzsfBazyt/nJhSBaVfjSBM4q2xIjLFl/8Iga1q0vgDSGmUU7bdBXeI44BQanc0nCbkhMIJAvkDNXrJsNfFdTxpyD7TWTQDdOjWpeq7L2/UAkoqcIHhHqYui245zWaNYBANk4nBMDNnbJZwLOLzGGicknWdxWhwAj0Cw+gwL1UsKqObYtCDB+yHbHsS6SLLCew5PPPBfktcDL9msh55mxVeJKivbG9kPnDLThJizfKLNO507JjG1pynK5EjgLkGc9kfaAuEmF9OKmyqzigRzMsuTvLXlu0UVgxh4/d8NqMN2igokZmN7Ve/1W1SEO0+6HAsuAg/GTtIRNNs1u2KT5AYDF0oEQd88NFSZxDjIMBhNX6mrO0mkXdRFAACxLT6AtZPsPLjMKhptTpii+WdyuI5WZfDP8gwBdvVoRD4mk6RsNoxkMlw0jdwnNV/fiJFCyDVQ27jCsPZq4+rL3mYVTrlc4yI7AhkK6FEaK1fvGBc26K3XZGcnZwOB7l3iaYbEujaEKdbTDbvXI1dLw+AkPLfj4sccJscsVBw7IJ8cg7oT7eax1k9cn+nHNMimjtfn6PwlWeVlTsOKFNBNKCcGLglP6nWFY5xRW1vgJiKBRK+ETWnOQAWP+zoL78VMKvAjhRezTbcMz3qpMtHYHwMfSBzNmgPNxDIECcjkCp7h/cZAvyGPhfIIkBVK5k2F1qMTHNAi/+Ud8kdyj3wIOQccST+STq29kin+Y
 VuUOLIwd
 zR5OWBfupwC5RuodisupfWAUSx0B+/07kBwZ0TRuyfZcjAvilh7fI15HQhb6QfbwuBoB7EbSOaieuXuaWpi5C9aLwEz4sEw3RYs0ij8rTNCGFG3yrxwywso9bwGwQKERSvQzEJ3hpBjEyX41bAEt+eChL2uhQ4ILIoDx3oN1f69m6SLv6uvP2PwFlxmbGTbSSFskEBVmAjqFFVI69NW5vkPQex0x6LpPkS1f5mlbdFV8goNGrVBStJ0vOO5nso2CEsu2mF1ojmcZAMnm2Snt3gUgk5E+SuLF98USn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update formatting in preparation for next patch

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index adecb200c654..3bdcee0e16a8 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -3,17 +3,23 @@
 //! Kernel page allocation and management.
 
 use crate::{
-    alloc::{AllocError, Flags},
+    alloc::{
+        AllocError,
+        Flags, //
+    },
     bindings,
     error::code::*,
     error::Result,
-    uaccess::UserSliceReader,
+    uaccess::UserSliceReader, //
 };
 use core::{
     marker::PhantomData,
     mem::ManuallyDrop,
     ops::Deref,
-    ptr::{self, NonNull},
+    ptr::{
+        self,
+        NonNull, //
+    }, //
 };
 
 /// A bitwise shift for the page size.

-- 
2.51.2



