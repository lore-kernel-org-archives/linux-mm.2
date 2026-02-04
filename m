Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E068EE9538E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ABAE6B0099; Wed,  4 Feb 2026 06:57:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D346B009E; Wed,  4 Feb 2026 06:57:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC956B00A0; Wed,  4 Feb 2026 06:57:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B12C6B0099
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:57:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA7851AF37E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:57:31 +0000 (UTC)
X-FDA: 84406624302.18.F4D9EA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DF9A0A0008
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:57:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U1z4hd8I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770206250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bq4FT148+U1qC14uOzP98fzEOEq1xubS3TDVd9YMopE=;
	b=H7NbyBPcJZAHtWIsoPoqdqjJUpfKGy8AKx8v99U7uZrTsheVKibOUxXpbxo2dAF3fQPLC1
	PkHQcHYC4ViCVzojE8IS2sni6VU68FxT8fE9o1218EFBe6QpGhmq0+c8Ydn4A42sQBusRn
	rqalOeuYZXYvdbkSNJAN/V7220cJ0oA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770206250; a=rsa-sha256;
	cv=none;
	b=3Xri7o9SrQSLrNfFi+M5afUwvm2eFH0pN8DK2lVNmxKb5uK9RyL0jOKwSyS0SJHPOb8ixY
	RFE8A7Dp+wav9+ALK30a0UMxKDIQMQ21NE67sR/eRAvL666eGWHWRmDzuSXAlX+6RiXhE6
	6PefWOOl0Gls1JBd2Fx4uWVFHUNLDzM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U1z4hd8I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D83DD4357D;
	Wed,  4 Feb 2026 11:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA58C4CEF7;
	Wed,  4 Feb 2026 11:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770206248;
	bh=TzCUGpEDUTKD6tcoKokHDlQAGVLw4XXksTwjbV99rHQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=U1z4hd8I9kQJXi+itfVCtBC/FJtdo2Xi6Hj5LG7Il46OSLQ5DO7odXAJQzuiGUVB9
	 y66NQAOTu/0zTht1ZG+1+0xfQrb/FK8Gsvg2u8K4nXwCMmruBdMryWUVu/Ke1V9Kme
	 3t7qGdIVVtqWomrqTvfYzqPT1NpmCR4sPkUGH6HvdVqjIk1X/N89RXCKtnM0k7mLbu
	 sX++DsdP+7oU5+XkQltsUCTzmKerLx0o2DlPZbfS7stbQAuWIXAtEyOpD3b8urHWos
	 KB4CPi0IHJOMEDpygqIycM4kw+hSQgpH6l7SEQfDfbr1G1BV0FuK/cLeeocfaR5MZ7
	 5Ij8FiV9mwLpg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 04 Feb 2026 12:56:50 +0100
Subject: [PATCH v14 6/9] rust: page: update formatting of `use` statements
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260204-unique-ref-v14-6-17cb29ebacbb@kernel.org>
References: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
In-Reply-To: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
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
 Igor Korotin <igor.korotin.linux@gmail.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=910; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=TzCUGpEDUTKD6tcoKokHDlQAGVLw4XXksTwjbV99rHQ=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpgzQEkl7+qS/pt2PP2yRFmTxhtfnLZn6ju1Ow3
 d+rvWLm0O+JAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYM0BAAKCRDhuBo+eShj
 d5BSEACm0N3lVUujUIiTwHFQB9gQm6GbVAkcN4LYjjgO1GeYPWWOvf27M0+aa9z0nRKy+7M65UF
 Giz1RqgkzOM314neS17zLgsDjdI5kPPOTMhK/GyJNpIEhrH6rXqlNCzGkWMgujQlfxFKs+BAVLy
 6OzWhYe0fDuOge2p1iSf0E1tqd5QMkCkNqnT0AqykgZM1sqpfxxRLzuCiQpz9Aw06yTAHBxPZnG
 a0A/TtIqMGW/LoOzictWoS0XkKAsUWJD1tiRv3lyUT4Oo5kIq23hhauCPm7zNteDMtvG+cE9nuc
 /ZmLqafExr2i73qSNPiFE9VBc4l/BXtD1oOItFhBGkPO+wUMlOO49i0SEnnFl5tZWOWnAHK0vmq
 bdGHaHK2iwk0OOJwNzZApHaR0REnw2aaXj6jhZ3zdQeWXrrBUw55EqQ+GRE28fNjAws0TRwaZP6
 vK+HxGW8/oXsfZCQZqaLtANQH78uVaje6mQ0LnZhMwGL8idzhD/CIUyqC3KINhmexm082Wf7zt3
 js8NmNvlM7UqPBkJl3xQqIuWarXHarAW6DoQGIO8NxY1TD6Om8raMLIVuhHd4jGgeywzV6/p/To
 tJ8hg2aQqagFEHO/Hv/BUMeEn4bWIUfZIzCpOaweXuqqv+SUZFAwm4tcP/0YoMDaoNQv9XqPYrx
 l2xeXy/luHQB1TQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: DF9A0A0008
X-Stat-Signature: qpu18x4fne3xe4srxcn3r53jmqhzecca
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770206249-563531
X-HE-Meta: U2FsdGVkX18gus/g01PG1Scwd8Kj8fLOrVvMo1V/Mjbw4L/6dPJ9VtQh2HrFONbHU2we8MTQwcQOBPcCFDNV+cZjQKTc0iEUbhJjB/Adx3LV2AJS/JdmVzAPpCrroAaindHY9Cy0Ljlk+nez/Jlmsr9bE7Ql7OYbC2RMFKWkVSdo4kf70GlsbhxnRLU8wNV8eER6auPu+l+0XFS+npyR2zrc/obaQt7wR0xGcngqMBnEha/xTspaFYHyNcV8exBH/1pCbnUX6ugFQOBJPvQw5CbsYL4/g/f20EsUIRftw3TmMcAJC35MeW78y3ShsKJxdXmE3jmHcM4yXILhbnjozBucUJHKxJgkii5Yh/bbh4uPBP33CM691WdCUOB8kUp6b6Si0HmVZWCy9k8kZS8b2n3e8FGNSm0R1M+B6pXGZ+0C8t1pKkCfJccHCO2u4nLbq0khMp9DDa1ssn9aeQgTrveCTiDL0AuG+95VTCQQunDa7iU/rKPhQBMIocyRyA1XKr5w1IHxcT6gyLa6434yetOGT48H0HFZazYq5f0mH5EBSpNeswaDAxeVGiLvceJ4udFDX3NDcPuF+cd+0AP9wUc0vBqhN6dCfMJjRaEuTrUU4FmBh96q1LertrZG/cn4qgZlSbjeXZdDWBdGulcEvSgAIb09IxyniYuIWSuaf7wrJeKmXU67g+o3Hb6Rd78SEOGC9MvJX7QWN5EVRt5SADstgbow711qqfxbILdulLkBFVTM6Ce8iVCTFAsoGkGJ+YYS3/1H/H4bSMcXKCrybmaQ30YbkfDoPkf3HCL85LpUZ8DdXrZSLZPFIq4mbUO+kkKhBhb2LsNMhGWLgfdsMfP6CsdfmiypDJfD9QLagzswig7C7C+9ZPNfAuQvCkqns1mAnPHNwXAwuAEcoCAaN2QvoHeRlL55/8y0Z0Tp5nvZDSePmzx3o7ZyEhltRziPtzmVxFB1M0kxlpDgR8n
 F3wO+1az
 HVMJrQQCqIESSYTemzqucn7Jg1pcdBIYgr7zEaZ+NXprWT03Xv+dYVDhvGHAyAebnMHIMo6B98L1SbVudP6h+sVaO8je6vgCmBk7vw2cR4hsoPUg60LFtxKxKAfA7eAZPSP33vYCniRECui1uWCE3uegEy7GqdaoPYngmdXa4kIjIrK1EBaX/oQfGkQU7uOsiCiRPeIBmi14d+kXcOMqKN8R9wHy/0cXP7ZxXzlYVZ3FTODGxhC5r4Sbd7HkQWCoxOTNISSVRtleF4LLxKG+vwY3u1yqs0Kyka3JU5E5QnTfbO79VUkDdMqXHosoTVnLczpBZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 432fc0297d4a8..bf3bed7e2d3fe 100644
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



