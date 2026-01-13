Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F974D29DEC
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 08:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64EBD6B0005; Tue, 13 Jan 2026 03:49:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC936B0089; Tue, 13 Jan 2026 03:49:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0506B008A; Tue, 13 Jan 2026 03:49:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 381956B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:49:43 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6DB55C0BA8
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:49:42 +0000 (UTC)
X-FDA: 84326317404.04.794F9AF
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 617D31C0002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:49:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vavJDpx1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3IgdmaQkKCBs1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3IgdmaQkKCBs1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768294180; a=rsa-sha256;
	cv=none;
	b=KCoiKHaUlBa7D6JevY3frF4uVnNDFEiWAjfRBtnXZaqykfjqx5y8MWeq/9UcmeOc5ScIfx
	eNRqBqubFx5O43gUA2s+rYSNRUulXmtUOzBD2MEbeKtpGYs5QGGVnHbrdQfwdhlBm4Qqhy
	luOnIoR1I8ZD1WoloImmKztOcXHcu3w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vavJDpx1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3IgdmaQkKCBs1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3IgdmaQkKCBs1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768294180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jw+Q9e+3qzYdGDM4/rhL4Cf9PitNjxQFTtoPvumkEKw=;
	b=dgQrm9PjMdtkwIK3cwOUrnPip6xgDJTikcNIsInAjP1/hoAqu2HEmDHVoPiYj8/r0dCbpn
	3asmItPnS9Kg31cdnj9N+abIRzFirpve3MmZan2tcoeOrTUR1tzluv8lCKChKYHr9rTKrb
	5r+3jm6hQpoy00eoQbsEkK3h6ioHc78=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b871ea8299dso175558766b.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768294179; x=1768898979; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jw+Q9e+3qzYdGDM4/rhL4Cf9PitNjxQFTtoPvumkEKw=;
        b=vavJDpx1/rGxU19nquZSLhiSmaC2aexTpBexwxRGiGKcuH4IZj0af7r7+g/2P7zxEm
         aiU3T0hyz5Ug6k6Z3NU5sqxAwxqgwnl8KAbbo1wZ8m2aM3OEt2twOUTO6/vlG1i4hx7i
         QSh/8P4eSyGhQIhjEFudGqxDXWKoRb99hebJswjrDfMGoXDYy8ItdAjsM0hsOTuzXovx
         4heZGDnUC8cFtyuP3+1234+cr7c9nDiHo73QSC012IUMk095YDX1RTtYc7TbUr/yMBXI
         BDyMabfEWs//Ntu4Zpry3HdBkMidOtBWNQXA3T4W4iG9xlbuc9gkM6tOYWv8V3/jDivM
         TfJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768294179; x=1768898979;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jw+Q9e+3qzYdGDM4/rhL4Cf9PitNjxQFTtoPvumkEKw=;
        b=VFnk8LkjalfUB2G4Q5bobOMlgDiw2OGXGEhczqTY5tI3LCWeMyLIOOrDvvpJE2XVHh
         LyoYuC+nogjC+L6MFGc46MHF3wIhP2W9bnG7L5FEQIjWNvqLN5OVqU+bSHCvQCZuPh5F
         2YdwZH8Mvn+46LYUzdMFMrVBmIq6Mwibh+VzHWfzvsiNCWeLfFg7TYU6XICrU2OzCwHJ
         O6fWYWYRbY+AEHdgAE9bhtdb3zBojSnIWzYngY/1ArlvDU7gelIw+TqbE0KevEh8rnt2
         fILN/XrJC7TRB4/r0InuBXJxaLbesoF/Sh2e4uDP8nvk6xS5wsZmXc6OYFllzL0ZarJh
         tK5g==
X-Forwarded-Encrypted: i=1; AJvYcCXd2B6JvhA0dzzBN6b1s2Ffk2AwdYY2zI7+j9hOGP6DdPRgQk8ENesQs4nGQrUwtF12p7BgXeOXOQ==@kvack.org
X-Gm-Message-State: AOJu0YyY0Q+QyQ1p3m0dc4cXMmS0KuH6w4BdBolBrqR0dEpfeFblovTi
	6wFaCwu8mxC866CZWFh6G0dqDtfiNYRb8mpNPpqQEhYe007zKhxLjYfXgCSojKx+SHXKGeXqPPK
	24WYoHF42Y1MCIKMEnA==
X-Google-Smtp-Source: AGHT+IG+jeDT8il/eAqSDA5cuGkJbkzksYOdO7Mos9jGlhqfPY9NZ1sG85DVTJeq24oXIQZmCGGLmrtiUEe7nb4=
X-Received: from edwn23.prod.google.com ([2002:a05:6402:4d7:b0:649:8456:d4bf])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:98d:b0:b73:7b97:5bfb with SMTP id a640c23a62f3a-b8444f4f7d3mr2145464866b.33.1768294178675;
 Tue, 13 Jan 2026 00:49:38 -0800 (PST)
Date: Tue, 13 Jan 2026 08:49:27 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIABYHZmkC/1WOyw6DIBBFf8WwLgbwUXXV/2i6AByRRMWCJW2M/
 16KTWpndyf3nJkVObAaHGqSFVnw2mkzhVCcEiR7PinAug0ZMcIKGgZrg2e1cDEA7oBUjIkcRNu
 iAMwWOv2Msuttzxbuj+Bc9iUS3AGWZhz10iS+TGmNraToU+61W4x9xUd8Ftvfm+x402eYYkGIZ FCKuqD8ooxRA6TBGj0+/7Es+I9sHtiy4pyfeU6yivyx27a9ASqjSmoOAQAA
X-Change-Id: 20251111-io-pgtable-fe0822b4ebdd
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=14368; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=CQgadvNGkklTMvPBwYDBqTFwljHbuM9uho1jUasw/lM=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpZgcc3/3HGgCiJsPygaovp4f3h+AB0KdYAq11m
 5FzkkiCvA2JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaWYHHAAKCRAEWL7uWMY5
 RgL+D/0a+pQIZUSNKsrmV5XA53l45frfdrOhnIHn+PezUeJf5A+z3ZTbU5NNPjIMQXcY03qXV3l
 YnhjZJMkxQpSc8umBABPcoCc9Alw3jfNreF4HzUkGhNmxp/qQpPghe7n32sziiaU3x8C6TOEw62
 6a6SRILNrpQT8SBtOl24yKXmFrIyowpTqadpuNQTFmrwm6dH91Q6W+ROK9wlSZsr9MV1PSBdhV5
 vnQ9ofm+eeB8CvSH2gk6oSG6O2rlJvcdxDnJ3OU1AkxttFCyUQwVF2vroQlahnM6KWQZl3N92Lj
 iESRzhiEqOKqpyWF1nri52uJeX71hHawRNDBcp1PqhsaFgYWof6D90te0Chh4k+S3YtW30C4aW+
 0FvRmwgv/0+vGcvYK77dNB3zFhUmEbcZfl6f03zReMUY9dWh6H46pbejU9Rr4b1kKgm2K94D2Rb
 2BKmSNwhw1j1VV9/B3ZJO3zrfj6AB7Tiy60TmRn/ytuBFhrCCK9706lLec4K/B+aqBZg8KciG/U
 Njfk1WZ4BpayNs+l6xoEYTdUZBNlnDV7moTY7iOg4GNpFtJp66HDAXQVNpeggjea4JJmH6qPUDc
 bLRGxKWKXVzx94+kKIZjohcovwCw5+NZvwwXrGr8wJq+sQlZzWpv+D7/WerSDJswiPhxedNJmQT XRxd3mMyhBFRxdg==
X-Mailer: b4 0.14.2
Message-ID: <20260113-io-pgtable-v5-1-7ed771bc3d8d@google.com>
Subject: [PATCH v5] io: add io_pgtable abstraction
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Robin Murphy <robin.murphy@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Asahi Lina <lina+kernel@asahilina.net>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: xq7sa3diz9zninb6kisguas98aehy6rb
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 617D31C0002
X-HE-Tag: 1768294180-673003
X-HE-Meta: U2FsdGVkX19srSXt82kQ6ZvhHyBMcih5Yc/O2IdHFTNcUekU0Z/SZUAX4JT1fpNMrKyNBgdDAKutx57nZxCsH+UKgW4nkoDeB3IrZQMzcZ1Pnxhb4inMoCrlX6UQ3jl/CN+WSmOCP9TdxRdXBAtls6DxGvD9yDc5kGGsX+Fc5W8wKZJKHTruOCfHyVTNUJJ6k0DGATaVVa1a35SQdfUjM7iL4kcYcNok1lUaxf8K+UTbRX6vN/2IuvJ3AuVXorS//T0YS9Iub/ZsX04MZXG6fc/d8Z4O6kx1zWjAgY0Jc06qk1RAEsFfFN36jezG2gN261nAqAV/VuEIKnlcVwdUHeX7K81q5yYDPTuCim2LdcQd9yUQe9VqDxpSbyWsrXx+5alf7Sy61WWzGwOd9g3Az25L9QaSUevDwq5nB4AoI0w8UWNHiylQN/0nVbWdStiYfsUBe9OuBVYxUNiOrjYypRKDPIjavzC4ew2Q6epeoP/O6glhlvDto/trDJfAmC9kmYcm0c9pooEQ0ziRb7RbvqWa03cgdcng8k+gcAGjGJaCE6WJbryIguoBh/UzfMVo7WUlS5gdefcejV7Xu+piGd40y127w/2R3MTk7rk6h519C7fJmK9Q29scoNekEnTKGdwSrkaxq5tt51sp4TWpxzyqU4bKDA7KuiAW+JF3lkysUEfzoFdgM4qBc/URI9A+tkMEuBxe1+OJ5ic1bEF6ouTg9dTERKrQuEl2VVa8LqAXO7o5/JjrCYGyOYtFM1SYEosZnW9rHXDI3yds84Pi7ZCKIi6AYqOBD0bxX2vTM7ck4aGTPlxRtyXLAALTc6RZ9nsn7iAOICXXOlZmpq94SDjfzhdRebSF/Pkj/U7Kxi+knzCg4oilmRzUWVFkOvHDs8ey7J0vQ2aYdNoEx3M/32TrQZ66dpyP6KUNTcaIVWek2tkf/YQ61jrEPUEAM1XIMIIuZWe/iN7a6kSJp/f
 Ox1bQnab
 8mQBq/t0Oh17BEwn/k//n2tD3sGkDdGq2dy7UtcoEZ27wZ/D21PUzxeuk0Od/wIxeola74Yc+ZxlblSIvu+2KNivv4WXnMLlS81dCPrcTPVE9w8TFLy45st/UW4aVIgTCgOLSK2kK8yxX9cDLesBq57pLNxpr1p3kS6gCSF7BU7XojijOQzPIzhwTto/lBrtQJL7xKIOTydtDodhzK+uZ5ROwhgcBnvfq2+qnpIiv2QpUWDvmOKGXOoDLp216OfXqZ+/BWUFIQWN2qw6bUYypcI0sNYMmKKR36VVxZyWJof+ke+XpYp+1tZCSXM7rKLiLx2+kxGeGh9rkcMgxbM1U8eSk1WbIqjowWf6GSWhy3Loin7PUtiw2XNChIOsGOextQqf4dXfEY946HWRILL+epsVXzgjIqqbdRlw4S5sXFKgOQY+rlKOz575UUAV2ffyDryGiCEBJUNe4jx89n605P8o0konQ2HQol0ziRBq4FeodJotNpPBEdogNOPwuFwI4BiMxv2g99PZwjryOj4sL0twCBGGVQA04plT1dyB/ZOtD/Gxeim6C2VX1svbmXp/h/vQLKn1VdHNdfUvC8bEJrvpz5GWz/fvsAX3sfENMpWEx1Oo2LV975dwkaq7FNL/lPn2b9tfnnR5bieYBueob8dTwpVLvbOqCdwZa1SExjalroenVvlPGpTQSruLxAFRhJSiKDrGRyBVik7FB12/d3DITrSzKiUi6XpaNJ+P2WyVzY1eRLR9Klf5rOBoDWHmJkq270cUDsLkRZDbojolizntoF97SXWd7AXOgZEMduPi/JbACZcPrwUelrF1LU/Zajfc0PgoUc6b3ObaV/kFdKi8sCqVDQwwPxA2NEYc8BXG8JKkSX6Afn5mpSOKqMTcOB4EspV9WJMpyoqnrZLcnC60ghgNxCGrl3G6f4ScSaTCfNLjg5ajkNdc6rRA7XNXlUZH4ULLShV3jDNhpy3HefWEwEk77
 IAKT09qj
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
Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
We did not discuss where this should go in the MAINTAINERS file yet. As
an initial suggestion I added it under IOMMU SUBSYSTEM, but please let
me know what you prefer. There is also a DEVICE I/O & IRQ [RUST]
subsystem that it could fall under.
---
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
 rust/kernel/io.rs               |   1 +
 rust/kernel/io/pgtable.rs       | 276 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 280 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b11839cba9de1e9e43f63787578edd8c429ca39..eccdb937762a7545fcd5db0194ab7c1b6dfdfde6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13241,6 +13241,7 @@ F:	drivers/iommu/
 F:	include/linux/iommu.h
 F:	include/linux/iova.h
 F:	include/linux/of_iommu.h
+F:	rust/kernel/io/pgtable.rs
 
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
diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
index 98e8b84e68d11ef74b2026d8c3d847a127f4672d..88253158448cbf493ca200a87ef9ba958255e761 100644
--- a/rust/kernel/io.rs
+++ b/rust/kernel/io.rs
@@ -10,6 +10,7 @@
 };
 
 pub mod mem;
+pub mod pgtable;
 pub mod poll;
 pub mod resource;
 
diff --git a/rust/kernel/io/pgtable.rs b/rust/kernel/io/pgtable.rs
new file mode 100644
index 0000000000000000000000000000000000000000..001b1d197563728881e995c90395bf167d29dfe9
--- /dev/null
+++ b/rust/kernel/io/pgtable.rs
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

---
base-commit: 3e7f562e20ee87a25e104ef4fce557d39d62fa85
change-id: 20251111-io-pgtable-fe0822b4ebdd

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


