Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB492D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 10:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49FA26B0005; Sun, 18 Jan 2026 05:08:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E316B0089; Sun, 18 Jan 2026 05:08:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F056B008A; Sun, 18 Jan 2026 05:08:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC156B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 05:08:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B17B21604A2
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 10:08:24 +0000 (UTC)
X-FDA: 84344659728.24.4695E97
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9CDD280006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 10:08:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="x3mKqnR/";
	spf=pass (imf02.hostedemail.com: domain of 3FbFsaQkKCHwfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3FbFsaQkKCHwfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768730902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Bzi0bS2JMbIu1Wq1pRi2DjrPlWSPSU+2KdETOJ9NLig=;
	b=7i/EXEaUwc/juv9+MQT/2hZuPMQTA0PX0sBIiYVw/4Yz3/Wark2+lWBWccAy+Z9RG6Nf41
	nfZsB8oYfOa2HazoaDKweaC4KDxW/ocCuS6S2n4vdpXnYr6aHYMkooWrYiJzRNq0Noek5T
	DE8zetbQGj8x1DtTxcsNmpZQS+WNPGw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="x3mKqnR/";
	spf=pass (imf02.hostedemail.com: domain of 3FbFsaQkKCHwfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3FbFsaQkKCHwfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768730902; a=rsa-sha256;
	cv=none;
	b=664E6ACx3HiKWjrw26wHgOGB+yHsGwM6EGzVpsJZ3t4k0wdY//qsbyDX4hMoO3GMpedpiw
	FKsda+NaO17kw8wj+aZrve+zfg2aZipGwZCX2RAcGREOOPpPvdDaZOGcCAYYYYJfWA4cF+
	aZSbN5LkjyCdkx9p4cCfWp9G2Dlw8No=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47ee33324e8so19901485e9.1
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 02:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768730901; x=1769335701; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Bzi0bS2JMbIu1Wq1pRi2DjrPlWSPSU+2KdETOJ9NLig=;
        b=x3mKqnR/6WdOI+Nx+xQ6zL880l7LrtAsyz8fCRTPWtWcIMwdVmptaBW5OCnNOz6Xz+
         Y4OjzkMlzSKnD5mzH3HJloubC5L3+aTzimcpKtGn5BY/tcXZfNYHkCZa8WHauGi1JLx1
         tlOcFKVIUHlxAeGVBbjQ8Lii/MnFviR5Vm2X+113zciSfpXhDTddmKXKPmp3NRRSvS1N
         /5FzKQxWGDmw/ya/Wxc2NqKiqAfCGGNZpu9T/prITmOjDI7UjZ8Jz9sOrAqI2mfIsrKS
         wXmH5L+E+rtgAoC6k95pclWCsgl2iAT6ygr7xkofaHIQIvTLDlLJbzAKTCJ21Znjv4oY
         2rag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768730901; x=1769335701;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Bzi0bS2JMbIu1Wq1pRi2DjrPlWSPSU+2KdETOJ9NLig=;
        b=CNzvZZLWXjv4PA3ChEkD1kKPowr2n1QDN3H0/n0rT6p97buhJj/Bz0mWsaIAcdghUE
         +kxlucJjGzRNiH38raIARt0dgSiyPdeAi9y1jWR90YHoauSPmankKEZQTY3CCxSNh5La
         Q6Gu+2MFbG6Cv9L9p30H9msuYt8wt/S1xlB8Q2JpBo4CSj3gJhcJtiboR26hOi3Djam2
         5Qwfg7WC7msi67YUDUPdpPAnoQ7akR2yYG3VZOmvanLVMFJnM6S6odQc/5vdohXaSz1j
         RUw8PpyB+/kWAXGtDjsYfiiSv3IwNB1sqaxyKqlpEgrchu8cSgYaFEmlT9dvFv1SgR7a
         i8lA==
X-Forwarded-Encrypted: i=1; AJvYcCV4Mk0nEJ3ouaIpCDqTegda7/qHm3rwHL2XayGp7+SMaKc9LomTF4DoH5yq+aGdIjZ7NViJmbnWnA==@kvack.org
X-Gm-Message-State: AOJu0YzjO6PbwREsUJFHS73OCqEb5T0l48imKKfJyhXGZBjrxx6pdlSM
	BCcU9UAXHfK0NY/j5kxp5avasncBsvpQjMLh5rp5lwphWBOIuERRGBQ+CmU9uYmNytPAtRvtJzI
	hoTruw1lmldVWXPffeg==
X-Received: from wmbka9.prod.google.com ([2002:a05:600c:5849:b0:480:2880:4d51])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:81c5:b0:477:76bf:e1fb with SMTP id 5b1f17b1804b1-4801e30df8bmr97176285e9.16.1768730901023;
 Sun, 18 Jan 2026 02:08:21 -0800 (PST)
Date: Sun, 18 Jan 2026 10:08:08 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAAexbGkC/2WOyw6CMBBFf4V0bUkfUNCV/2Fc9DFiE7XYYqMx/
 LsjaNQ4uzu558zcSYLoIZFVcScRsk8+nDCoRUHsXp86oN5hJoKJmuNQH2jfDdocgO6AtUKYCox
 zBIE+ws5fJ9lmO+cI5ws6h3lJjE5AbTge/bAqsir5kkbLybO892kI8TY9kuXUft0U3zezpJwax
 qwAZZY11+suhO4AJVonT64+rED/N1shq1qtdaMrJlv2x9ZvVjHO5Q9bI9uAaxpurHSt+2HHcXw AwXhs7EoBAAA=
X-Change-Id: 20251111-io-pgtable-fe0822b4ebdd
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=14766; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=/8bC89qTDsFikv7hESqFn6Tq2jauWkt3iFph/Lepxys=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpbLEPKuxnB0McVu90qr43YGJsUixy1cxF2syh0
 JRYLAOtSeWJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaWyxDwAKCRAEWL7uWMY5
 RrYtD/4hGr/Ibbd5xaBQyaGQ+TKS+3v2Bl5vxQEmKZCgsW2fQ6PG+d9+x9auMDHlLdlTAtCgZZh
 rGZUNxaREA7r9uswacgTRuoJJyMy+od8SYUn4wU45VQsNniQ6F7CQpbypL9bhcJusxnS2vHktaZ
 Li6zSFdERJIRNoCFf1OebqgpChUpJ2mfZNAA/4oJoKabDt8q12pfH85Vu4YB1W3CGbXZUokMW4q
 xkdR1LhJAYEt0u94Hl/J0v0Z0EiM5msXf/KL6ndGdk8SnYj+EE03/Ow2jcnkKvh79BTojO8i01U
 BAXL2ADLJzJ+u9RsitA9n+x7tbOgWSnaBoR3kJG+xeVDSK7oJtPVa8jWezEP9fRMcP740zs3JWP
 2yyWLA0zBu4AEZ/563X1/XW/QJemRu5lfohQscsi4a1l8l/yb9Qj7MNYODp9Zz+W1lklX2u0MMy
 GMvd0MzfUdWdgb0kKVDXgbWpx12C3TLyH9Se7Bv+UN1RWcEF/+Y/4RnRlpypNR600E9ttEwX9gf
 reEtokPF/ogDwSpfblrZYxJegKd0Pn8fCKxiY+K1UYz+jTPgsvakzynoa/f2ElGo9cceb6MBaSR
 nMOjlSLPqJXMhbDwHToey+djJybGYD+8lN5qcmg6W20WbS8ffDvnTs34fJMBVrJ3Xzx+RgNLFn1 nhHt21lC4lsU8RA==
X-Mailer: b4 0.14.2
Message-ID: <20260118-io-pgtable-v6-1-423846996883@google.com>
Subject: [PATCH v6] rust: iommu: add io_pgtable abstraction
From: Alice Ryhl <aliceryhl@google.com>
To: Joerg Roedel <joro@8bytes.org>, Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Robin Murphy <robin.murphy@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Asahi Lina <lina+kernel@asahilina.net>, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	iommu@lists.linux.dev, linux-mm@kvack.org, 
	Deborah Brouwer <deborah.brouwer@collabora.com>, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 9CDD280006
X-Stat-Signature: 5n7i1i3diier88a5w8yybw16o1ufzkot
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768730902-834205
X-HE-Meta: U2FsdGVkX1/vrF+xvlOy8d4rHVKHY1Xsmj/eshCizSlBnlbnVKww+fKpCXW1kKQ6X04xf0mFRl91kYP+XJrdKquKt4iwCEbVLm87LPCcUxN3oRpy6HUHhpADCiHI2Y3tq13FMpViIlJhbPgBX990or4zb9NcNLGvtVBWFD9a/qRfDWMkpxAfmEkS9uf4CMi2XD/HwYied/ko29CDJs2msaulwzsG5OTfV+Xugmk1XUMGw7oVBmmsBlHxZ1CaHq6Lkti0czYBfmxlsWhzEkB56kXvF+YjtSfehZIRB2YqrbOlO3JjQlCG2YlBANbddeAIK30joIxp8+XT+mjwBlnAA/I3T644KZJexgx76H9qFP0duYwnJ5riPQn/S9Bt/3lWgqzF+DPW98Rjfmf9cnRbpT7yAQGGO97EHNvpO+JZi8dlaFjyWDaB5ODCwaLQtksn8qVjlZYOuP9GGHjeNpCikdJSVqpXi2Cl0L21ckRpud5sMpOLjDpm8z3f4NsRlXL0VTsh/xp/josC2xupMog+nc4FZGjgsOOA2DpEXuRHxZRmpiTxIyOALPWDEJJIkOjgpBOhoQvtaKIpDCJ1fTgL3c31XK+KygHEWTVre5TJLhOtx3rUf0P1Tztp2/IAMFSJtmW1PdCSzW9wEGJaSyN9VsghOjvWysH8P6AUgDSqt2RXirKJCFyMU30vNkMjTnwsqYPYm0LB5wdF1VIp+l+FCepis4PJTv3fDAYLovS1xRiEPzebWPeS8kM8MqSnt1af0hXHWvGbWYWtqmqJmkEJqTdZ0kcvc1SVxeKqvVoM0IiZENxNi2dfMJevOdm8gzcTHdj757cqnnwrIMIf9/n9ieTqFEW5wpQor3qtgaRyar2awbDOOSGWzroo+m5LBumIdZNQG6tSnioZbIM/xOMAEjTl5PpJ4mRae4wdhAY05/A9uUZcqRfhAWBsC1ZYJGD5fpt2PQ+vHRXAK2bbwby
 LPxJx3O9
 OY+eqASbhfIEwMJd4oJqAn7AsAL/0P1DFBhS0qJKHEEQatnSfT8+Xmh24w9eJWNkV14ERHkveLFSXLKoJpSJ8S5BfbO8BQ2rMMZJPIpy1uKwmkNdTKuEMUl4P0L0GollDZBxcUJq5B247UBw2t93qHTCcLduxPI+OpBgKCIU/DyWIjTVLWgVqwwd0GFNwmO4gnE2s6GNy0fFzpFW09UpGpyY15SICRPkzmiiGp814pAni6EhWk9ztl6e2lE+MypmPr2fyI1SPQqaGCg6FKz1Q/LcKDSLW7I4wi5BnRO2AJ9atY7NJJdBUIS+1ZughPo2JkVBo7c71TRhl7o2gjfAWZoZ15v1aPplvLlMSROPQebR6IEmp8PGgvKjaN+KmAeqAD75HS4fBdSoMhu9vVMSOe7r87wHchEMn4YP8mdw2Q7mkM0aJ447yFrScCODqKcUIanZo3AnCbQKuj8d4fGMIjA6fQwizhxPr9MUr6mJr7uS/brWw6aQpKIKKmIpaEh11/hHGKvLXk/KFbuZ2lNPJp+3RJyzGY4eCNgaFPrfRhyL5H7gfbWf63xnZpvZonVMa8Ec9cwHx4ZpREcjwwRJ5crLUzkILS12MthwXUiqKV6zpXic6qj+2Jo3fVBOuNvWaGYrP5Y0eJwBka7iwVgJBmsEcZSPZcwSEEvF0HH6R0yhzT4WCRSK/edM4Yz/53kKG4pI1CBYMVgWYsIbIUDswBwPwfYvQiDI56+JfIFZ2D5DgkgZJMFPoh8JgG3twvX/hOjk5a4DR2J6rUpewqJMaA5EXlNvAivcS03Pseidw1qQY0eyetX3qG/1lrSPcq8AuM15HhSqX3UNcC2pGZCf+05jbmDBbmBooYyRg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asahi Lina <lina+kernel@asahilina.net>

This will be used by the Tyr driver to create and modify the page table
of each address space on the GPU. Each time a mapping gets created or
removed by userspace, Tyr will call into GPUVM, which will figure out
which calls to map_pages and unmap_pages are required to map the data in
question in the page table so that the GPU may access those pages when
using that address space.

The Rust type wraps the struct using a raw pointer rather than the usual
Opaque+ARef approach because Opaque+ARef requires the target type to be
refcounted.

Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
Acked-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Tested-by: Deborah Brouwer <deborah.brouwer@collabora.com>
Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Changes in v6:
- Move to rust/kernel/iommu/
- Pick up Tested-by tag.
- Link to v5: https://lore.kernel.org/r/20260113-io-pgtable-v5-1-7ed771bc3d8d@google.com

Changes in v5:
- Fix warning by removing #[must_use] from `map_pages`.
- Reword comment on NOOP_FLUSH_OPS
- Add blank line after `alloc_io_pgtable_ops`
- Reword safety comment in Drop to refer ttbr method
- List in MAINTAINERS
- Pick up Reviewed-by: Daniel
- Link to v4: https://lore.kernel.org/r/20251219-io-pgtable-v4-1-68aaa7a40380@google.com

Changes in v4:
- Rename prot::PRIV to prot::PRIVILEGED
- Adjust map_pages to return the length even on error.
- Explain return value in docs of map_pages and unmap_pages.
- Explain in map_pages that the caller must explicitly flush the TLB
  before accessing the resulting mapping.
- Add a safety requirement that access to a given range is required to
  be exclusive.
- Reword comment on NOOP_FLUSH_OPS.
- Rebase on v6.19-rc1 and pick up tags.
- Link to v3: https://lore.kernel.org/r/20251112-io-pgtable-v3-1-b00c2e6b951a@google.com

Changes in v3:
- Almost entirely rewritten from scratch.
- Link to v2: https://lore.kernel.org/all/20250623-io_pgtable-v2-1-fd72daac75f1@collabora.com/
---
 MAINTAINERS                     |   1 +
 rust/bindings/bindings_helper.h |   3 +-
 rust/kernel/iommu/mod.rs        |   5 +
 rust/kernel/iommu/pgtable.rs    | 276 ++++++++++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs              |   1 +
 5 files changed, 285 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b11839cba9de1e9e43f63787578edd8c429ca39..b83bd50c2755115cc14e903e784b1dae1bd921bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13241,6 +13241,7 @@ F:	drivers/iommu/
 F:	include/linux/iommu.h
 F:	include/linux/iova.h
 F:	include/linux/of_iommu.h
+F:	rust/kernel/iommu/
 
 IOMMUFD
 M:	Jason Gunthorpe <jgg@nvidia.com>
diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index a067038b4b422b4256f4a2b75fe644d47e6e82c8..1b05a5e4cfb4780fdc27813d708a8f1a6a2d9913 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -56,9 +56,10 @@
 #include <linux/fdtable.h>
 #include <linux/file.h>
 #include <linux/firmware.h>
-#include <linux/interrupt.h>
 #include <linux/fs.h>
 #include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/io-pgtable.h>
 #include <linux/ioport.h>
 #include <linux/jiffies.h>
 #include <linux/jump_label.h>
diff --git a/rust/kernel/iommu/mod.rs b/rust/kernel/iommu/mod.rs
new file mode 100644
index 0000000000000000000000000000000000000000..1423d7b19b578481af3174e39ce2e45bc8eb0eee
--- /dev/null
+++ b/rust/kernel/iommu/mod.rs
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Rust support related to IOMMU.
+
+pub mod pgtable;
diff --git a/rust/kernel/iommu/pgtable.rs b/rust/kernel/iommu/pgtable.rs
new file mode 100644
index 0000000000000000000000000000000000000000..001b1d197563728881e995c90395bf167d29dfe9
--- /dev/null
+++ b/rust/kernel/iommu/pgtable.rs
@@ -0,0 +1,276 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! IOMMU page table management.
+//!
+//! C header: [`include/io-pgtable.h`](srctree/include/io-pgtable.h)
+
+use core::{
+    marker::PhantomData,
+    ptr::NonNull, //
+};
+
+use crate::{
+    alloc,
+    bindings,
+    device::{Bound, Device},
+    devres::Devres,
+    error::to_result,
+    io::PhysAddr,
+    prelude::*, //
+};
+
+use bindings::io_pgtable_fmt;
+
+/// Protection flags used with IOMMU mappings.
+pub mod prot {
+    /// Read access.
+    pub const READ: u32 = bindings::IOMMU_READ;
+    /// Write access.
+    pub const WRITE: u32 = bindings::IOMMU_WRITE;
+    /// Request cache coherency.
+    pub const CACHE: u32 = bindings::IOMMU_CACHE;
+    /// Request no-execute permission.
+    pub const NOEXEC: u32 = bindings::IOMMU_NOEXEC;
+    /// MMIO peripheral mapping.
+    pub const MMIO: u32 = bindings::IOMMU_MMIO;
+    /// Privileged mapping.
+    pub const PRIVILEGED: u32 = bindings::IOMMU_PRIV;
+}
+
+/// Represents a requested `io_pgtable` configuration.
+pub struct Config {
+    /// Quirk bitmask (type-specific).
+    pub quirks: usize,
+    /// Valid page sizes, as a bitmask of powers of two.
+    pub pgsize_bitmap: usize,
+    /// Input address space size in bits.
+    pub ias: u32,
+    /// Output address space size in bits.
+    pub oas: u32,
+    /// IOMMU uses coherent accesses for page table walks.
+    pub coherent_walk: bool,
+}
+
+/// An io page table using a specific format.
+///
+/// # Invariants
+///
+/// The pointer references a valid io page table.
+pub struct IoPageTable<F: IoPageTableFmt> {
+    ptr: NonNull<bindings::io_pgtable_ops>,
+    _marker: PhantomData<F>,
+}
+
+// SAFETY: `struct io_pgtable_ops` is not restricted to a single thread.
+unsafe impl<F: IoPageTableFmt> Send for IoPageTable<F> {}
+// SAFETY: `struct io_pgtable_ops` may be accessed concurrently.
+unsafe impl<F: IoPageTableFmt> Sync for IoPageTable<F> {}
+
+/// The format used by this page table.
+pub trait IoPageTableFmt: 'static {
+    /// The value representing this format.
+    const FORMAT: io_pgtable_fmt;
+}
+
+impl<F: IoPageTableFmt> IoPageTable<F> {
+    /// Create a new `IoPageTable` as a device resource.
+    #[inline]
+    pub fn new(
+        dev: &Device<Bound>,
+        config: Config,
+    ) -> impl PinInit<Devres<IoPageTable<F>>, Error> + '_ {
+        // SAFETY: Devres ensures that the value is dropped during device unbind.
+        Devres::new(dev, unsafe { Self::new_raw(dev, config) })
+    }
+
+    /// Create a new `IoPageTable`.
+    ///
+    /// # Safety
+    ///
+    /// If successful, then the returned `IoPageTable` must be dropped before the device is
+    /// unbound.
+    #[inline]
+    pub unsafe fn new_raw(dev: &Device<Bound>, config: Config) -> Result<IoPageTable<F>> {
+        let mut raw_cfg = bindings::io_pgtable_cfg {
+            quirks: config.quirks,
+            pgsize_bitmap: config.pgsize_bitmap,
+            ias: config.ias,
+            oas: config.oas,
+            coherent_walk: config.coherent_walk,
+            tlb: &raw const NOOP_FLUSH_OPS,
+            iommu_dev: dev.as_raw(),
+            // SAFETY: All zeroes is a valid value for `struct io_pgtable_cfg`.
+            ..unsafe { core::mem::zeroed() }
+        };
+
+        // SAFETY:
+        // * The raw_cfg pointer is valid for the duration of this call.
+        // * The provided `FLUSH_OPS` contains valid function pointers that accept a null pointer
+        //   as cookie.
+        // * The caller ensures that the io pgtable does not outlive the device.
+        let ops = unsafe {
+            bindings::alloc_io_pgtable_ops(F::FORMAT, &mut raw_cfg, core::ptr::null_mut())
+        };
+
+        // INVARIANT: We successfully created a valid page table.
+        Ok(IoPageTable {
+            ptr: NonNull::new(ops).ok_or(ENOMEM)?,
+            _marker: PhantomData,
+        })
+    }
+
+    /// Obtain a raw pointer to the underlying `struct io_pgtable_ops`.
+    #[inline]
+    pub fn raw_ops(&self) -> *mut bindings::io_pgtable_ops {
+        self.ptr.as_ptr()
+    }
+
+    /// Obtain a raw pointer to the underlying `struct io_pgtable`.
+    #[inline]
+    pub fn raw_pgtable(&self) -> *mut bindings::io_pgtable {
+        // SAFETY: The io_pgtable_ops of an io-pgtable is always the ops field of a io_pgtable.
+        unsafe { kernel::container_of!(self.raw_ops(), bindings::io_pgtable, ops) }
+    }
+
+    /// Obtain a raw pointer to the underlying `struct io_pgtable_cfg`.
+    #[inline]
+    pub fn raw_cfg(&self) -> *mut bindings::io_pgtable_cfg {
+        // SAFETY: The `raw_pgtable()` method returns a valid pointer.
+        unsafe { &raw mut (*self.raw_pgtable()).cfg }
+    }
+
+    /// Map a physically contiguous range of pages of the same size.
+    ///
+    /// Even if successful, this operation may not map the entire range. In that case, only a
+    /// prefix of the range is mapped, and the returned integer indicates its length in bytes. In
+    /// this case, the caller will usually call `map_pages` again for the remaining range.
+    ///
+    /// The returned [`Result`] indicates whether an error was encountered while mapping pages.
+    /// Note that this may return a non-zero length even if an error was encountered. The caller
+    /// will usually [unmap the relevant pages](Self::unmap_pages) on error.
+    ///
+    /// The caller must flush the TLB before using the pgtable to access the newly created mapping.
+    ///
+    /// # Safety
+    ///
+    /// * No other io-pgtable operation may access the range `iova .. iova+pgsize*pgcount` while
+    ///   this `map_pages` operation executes.
+    /// * This page table must not contain any mapping that overlaps with the mapping created by
+    ///   this call.
+    /// * If this page table is live, then the caller must ensure that it's okay to access the
+    ///   physical address being mapped for the duration in which it is mapped.
+    #[inline]
+    pub unsafe fn map_pages(
+        &self,
+        iova: usize,
+        paddr: PhysAddr,
+        pgsize: usize,
+        pgcount: usize,
+        prot: u32,
+        flags: alloc::Flags,
+    ) -> (usize, Result) {
+        let mut mapped: usize = 0;
+
+        // SAFETY: The `map_pages` function in `io_pgtable_ops` is never null.
+        let map_pages = unsafe { (*self.raw_ops()).map_pages.unwrap_unchecked() };
+
+        // SAFETY: The safety requirements of this method are sufficient to call `map_pages`.
+        let ret = to_result(unsafe {
+            (map_pages)(
+                self.raw_ops(),
+                iova,
+                paddr,
+                pgsize,
+                pgcount,
+                prot as i32,
+                flags.as_raw(),
+                &mut mapped,
+            )
+        });
+
+        (mapped, ret)
+    }
+
+    /// Unmap a range of virtually contiguous pages of the same size.
+    ///
+    /// This may not unmap the entire range, and returns the length of the unmapped prefix in
+    /// bytes.
+    ///
+    /// # Safety
+    ///
+    /// * No other io-pgtable operation may access the range `iova .. iova+pgsize*pgcount` while
+    ///   this `unmap_pages` operation executes.
+    /// * This page table must contain one or more consecutive mappings starting at `iova` whose
+    ///   total size is `pgcount * pgsize`.
+    #[inline]
+    #[must_use]
+    pub unsafe fn unmap_pages(&self, iova: usize, pgsize: usize, pgcount: usize) -> usize {
+        // SAFETY: The `unmap_pages` function in `io_pgtable_ops` is never null.
+        let unmap_pages = unsafe { (*self.raw_ops()).unmap_pages.unwrap_unchecked() };
+
+        // SAFETY: The safety requirements of this method are sufficient to call `unmap_pages`.
+        unsafe { (unmap_pages)(self.raw_ops(), iova, pgsize, pgcount, core::ptr::null_mut()) }
+    }
+}
+
+// For the initial users of these rust bindings, the GPU FW is managing the IOTLB and performs all
+// required invalidations using a range. There is no need for it get ARM style invalidation
+// instructions from the page table code.
+//
+// Support for flushing the TLB with ARM style invalidation instructions may be added in the
+// future.
+static NOOP_FLUSH_OPS: bindings::iommu_flush_ops = bindings::iommu_flush_ops {
+    tlb_flush_all: Some(rust_tlb_flush_all_noop),
+    tlb_flush_walk: Some(rust_tlb_flush_walk_noop),
+    tlb_add_page: None,
+};
+
+#[no_mangle]
+extern "C" fn rust_tlb_flush_all_noop(_cookie: *mut core::ffi::c_void) {}
+
+#[no_mangle]
+extern "C" fn rust_tlb_flush_walk_noop(
+    _iova: usize,
+    _size: usize,
+    _granule: usize,
+    _cookie: *mut core::ffi::c_void,
+) {
+}
+
+impl<F: IoPageTableFmt> Drop for IoPageTable<F> {
+    fn drop(&mut self) {
+        // SAFETY: The caller of `Self::ttbr()` promised that the page table is not live when this
+        // destructor runs.
+        unsafe { bindings::free_io_pgtable_ops(self.raw_ops()) };
+    }
+}
+
+/// The `ARM_64_LPAE_S1` page table format.
+pub enum ARM64LPAES1 {}
+
+impl IoPageTableFmt for ARM64LPAES1 {
+    const FORMAT: io_pgtable_fmt = bindings::io_pgtable_fmt_ARM_64_LPAE_S1 as io_pgtable_fmt;
+}
+
+impl IoPageTable<ARM64LPAES1> {
+    /// Access the `ttbr` field of the configuration.
+    ///
+    /// This is the physical address of the page table, which may be passed to the device that
+    /// needs to use it.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that the device stops using the page table before dropping it.
+    #[inline]
+    pub unsafe fn ttbr(&self) -> u64 {
+        // SAFETY: `arm_lpae_s1_cfg` is the right cfg type for `ARM64LPAES1`.
+        unsafe { (*self.raw_cfg()).__bindgen_anon_1.arm_lpae_s1_cfg.ttbr }
+    }
+
+    /// Access the `mair` field of the configuration.
+    #[inline]
+    pub fn mair(&self) -> u64 {
+        // SAFETY: `arm_lpae_s1_cfg` is the right cfg type for `ARM64LPAES1`.
+        unsafe { (*self.raw_cfg()).__bindgen_anon_1.arm_lpae_s1_cfg.mair }
+    }
+}
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index f812cf12004286962985a068665443dc22c389a2..e7fba6fa0f811c44ca36b66ef21a25be4d322aae 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -103,6 +103,7 @@
 pub mod init;
 pub mod io;
 pub mod ioctl;
+pub mod iommu;
 pub mod iov;
 pub mod irq;
 pub mod jump_label;

---
base-commit: 3e7f562e20ee87a25e104ef4fce557d39d62fa85
change-id: 20251111-io-pgtable-fe0822b4ebdd

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


