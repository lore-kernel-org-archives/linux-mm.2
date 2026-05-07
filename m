Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 369C0CD37AD
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 23:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A2BF6B00E8; Thu,  7 May 2026 19:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2777C6B00EA; Thu,  7 May 2026 19:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054EA6B00EB; Thu,  7 May 2026 19:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC0AB6B00E8
	for <linux-mm@kvack.org>; Thu,  7 May 2026 19:33:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 97AD7160697
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:33:00 +0000 (UTC)
X-FDA: 84742226520.13.B603CD0
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf29.hostedemail.com (Postfix) with ESMTP id 87681120010
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:32:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=GkgUSVib;
	spf=pass (imf29.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778196778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yx8JvLQF2DtX5i8OpM+EnULSototWLG5JNcoDKWudLI=;
	b=ErNAgOWdo3bM5AnUvOFV0WYgS1FbkFwkz4YHYb0W5iknlbQ6i8ZfLkI5MCs0qKL062iOfn
	kIfSc4ExkgMOx25JnHF7nveBaHuK89sTUeVL/uup5OUq6hRHW7vNXbNf5yGVPKr0W6l0oE
	Ncd86kU0+lApL6BSmT+c22vubSwOjJ4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=GkgUSVib;
	spf=pass (imf29.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778196778; a=rsa-sha256;
	cv=pass;
	b=JpGFnuCPacNyMM8jZ3em97uMeRaKqr4jZ9j3Vgq7Epa5vCHnFizMWtAXrn5cVUy7gLlAyt
	8wV3ZcoyrOM/e4XevqMx3qV4WwZzmdclKvt4V9YbkXN7F5HiS1ViqzGML75rBTq8lZNUpD
	Qcq6zlODhXv+uPZoZJP7OASiuVQ4T0M=
ARC-Seal: i=1; a=rsa-sha256; t=1778196771; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=FyCnaUAzfM4a/oh4N8AOggjrbsF2bUQSLb/CxAoRu1S+QAH6J1JJ9GYc5nfVcNtLNtAKGIlSnMD5iJmSG6b3WFRbSBhDsugClsggapEt54+wnwTVtoBObsMaPUmBhut4PIJcjIJyMWNkAKxHh0T7bOFvrfTRo7wPIdc9rBvMSzA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778196771; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Yx8JvLQF2DtX5i8OpM+EnULSototWLG5JNcoDKWudLI=; 
	b=OMOgAO7cVfPItTjB9xhEpHkzR1paHTtYyAa6QZ0pZhJJJvfqK7X1Y91TQNDs6XTU7NFMFiYfTqWOl71kc0wTN+TKMXfiKvHyI0zyyMIapkPrrVggwArPcDqFVIQXjQd+Pdp2c5RHFiglEmRGYvwbPO4pQufs4cxsbO2xLxkxwkM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778196771;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=Yx8JvLQF2DtX5i8OpM+EnULSototWLG5JNcoDKWudLI=;
	b=GkgUSVibMD711G/3qJz5u1jKCj67ghRtxDc6/G//cT4Lc1dWr+FJAvfZVpdN/xcC
	Y2TvMM1Gh56cEilNzDTW7jxq4twK7cFZJH1LPOmZf4Lm+CSjCS+AdTUbQylo934WhfI
	FHopmkuSWD/kpHo7Z/6Tn08v5ScdKYJPcnMxFLNQ=
Received: by mx.zohomail.com with SMTPS id 1778196770005837.945580734471;
	Thu, 7 May 2026 16:32:50 -0700 (PDT)
From: Deborah Brouwer <deborah.brouwer@collabora.com>
Date: Thu, 07 May 2026 16:32:44 -0700
Subject: [PATCH 6/7] drm/tyr: store MMIO physical base address
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-tyr-mmap-v1-6-eec048a23c25@collabora.com>
References: <20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com>
In-Reply-To: <20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Daniel Almeida <daniel.almeida@collabora.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 boris.brezillon@collabora.com, beata.michalska@arm.com, lyude@redhat.com, 
 acourbot@nvidia.com, work@onurozkan.dev, alvin.sun@linux.dev, 
 Laura Nao <laura.nao@collabora.com>, 
 Deborah Brouwer <deborah.brouwer@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1922;
 i=deborah.brouwer@collabora.com; h=from:subject:message-id;
 bh=sq2B5J6Q8s2C6YbTn20oeUOAg0Lb4q68cApUEcd8JXg=;
 b=owGbwMvMwCVWuULzOU9c7WvG02pJDJl/FSUvsz9WfGfwS5Jjx1Zmkz0/XLLjDbkc+TduP+ZuX
 m7UsulWRykLgxgXg6yYIstZe6Me8ar3Rrrz/zfDzGFlAhnCwMUpABNZ5MXIMC93xowtChndQWsN
 e+dY/FieVXkzatv+598ueVtq3/u4ZCrD/zAe/ySGIMPGyVksp+w6WLfffZu8LfwFz7amKXtLy3c
 vZQMA
X-Developer-Key: i=deborah.brouwer@collabora.com; a=openpgp;
 fpr=CD3F328C177AEF322D9FFF8379A829E70C5E7DEB
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 87681120010
X-Stat-Signature: t5xqk511qc5j3ou8iko98tsz67y8smzp
X-HE-Tag: 1778196778-691172
X-HE-Meta: U2FsdGVkX1/HGD6nRUDxGq8SIspqTFssEkSqoT8dVl/Rv1HxUt7j71pSCFefVzO/3b3/ogoj6yESdxeY0aLvxiPcBBvNIbkQZA/7R7LGHbDxEBwrWWch/7iRHEEBWaFouF8KAzuA81xAOVnILXgUNiPB7wSQsqUwWPk44adSAe9CwuGGzKeZjcuVN98II/ddzFz8zqlySjiIUPQoE9AEI09erMez9tpZHHw5nIPySuoMeBGXAAzBD0PaBRySif+SXI3kK1l+vKXgcA1LdP+HaXwp2W3E3ipFwWV7+6XTTbR5kuQVSIAL2+a0UjfclYdgV/cY/0cilQdoBRTIMtd2R1YjVbsD9vk/S2if5bHmZOa1WQ25geqblRjVht4nP/1+8fI/fmD3JvZsLFWVGrCMiMzVL1r0o1/ytd6SlEdIPMl4X85hLnCdpOdjxW2sZFmRKcCT4F5chtvZqJmL35TfxYHcM4RkxfNTBcKADSt4W5M7l32FYsG98leJ8DNRH18VkcczEyaIx99fNyPLcsdFTnWux0ADhHg45TqDCmgPB+pm0aHCuZOGjOs+wnZuZNGK8zEI8nyGTGbIhLx9XxbXO4CvNLwCYHi99Uw3Vor0AA3TPpBIWgnBiUMS8oNfth1YnEkygKW150h4kMELg9o/NuNa4Py6kGjXO9bzkN41L9RBt0gHtcvKVhIlSyw/2GWGXsxCAfIxeuK2p8yU8hjX5paCNW8HRYoTDmc8KOwRxA/SldPQ9x9oItK6RHCbo9f9tOtsWEOFxXmpJpZrNcnxbkYc2jJmdH4kcSpcSR1SONydJTlaYjAjMC/iV2Vr21RkDwwqFh2COzGaFvsNHXKZNub+yPmkREEhA+ec9sfFwvH2bmFsCqfMNgL2aYoMNXf21/Ys+NlODAvPRYW22xFQKchEjjL9QI/HlaVFWuYDUq8TiRxh9f6eG7JaTxuv9H67lsn8nunzEgl2lU9Aod6
 86/XG3ya
 d2y68jEJTBb0YoMNmOpEcNI46ob6Wgg8NVGiZAZkVkUxxcdpPngvPiBdAtl5GucjnQr5jFMwH0JyBgU1KrlYettQWNZga8P5FYP3/+XUKSjRGzBvqsAUrdwE7DDwBH1VYSIPs0mqGGuBHvibjlqkRqpDTnwMfKX0uzu0xN62PicvhdqQzweHTcph+7Uv4exkJETDpZEJyKart45LRnLIKSuJPNojel6A56PX6F2l9Ij8xHL6jKY5A7rM+wa/1KKq4eB9Sni5wNcnZyngf5Lx7Nwj9iVyKzcThsWxJKipnUEe/WJT5iQdsi1dXIfHtvHgscQ6Ym1X0jPUpkz/pNHBJsqd2+KJUiAau45etxP+4PgV7THY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Store the physical base address of the GPU MMIO region in
TyrDrmDeviceData.

This will be used by the Panthor userspace-MMIO mmap path to derive the
physical PFNs inserted into userspace VMAs for USER register page
mappings.

Co-developed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Deborah Brouwer <deborah.brouwer@collabora.com>
---
 drivers/gpu/drm/tyr/driver.rs | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tyr/driver.rs b/drivers/gpu/drm/tyr/driver.rs
index e20a5978eed6..2ba0a22a225b 100644
--- a/drivers/gpu/drm/tyr/driver.rs
+++ b/drivers/gpu/drm/tyr/driver.rs
@@ -19,7 +19,8 @@
     drm::ioctl,
     io::{
         poll,
-        Io, //
+        Io,
+        PhysAddr, //
     },
     new_mutex,
     of,
@@ -60,6 +61,9 @@ pub(crate) struct TyrPlatformDriverData {
 pub(crate) struct TyrDrmDeviceData {
     pub(crate) pdev: ARef<platform::Device>,
 
+    /// Physical base address of the MMIO region.
+    pub(crate) mmio_phys_addr: PhysAddr,
+
     #[pin]
     clks: Mutex<Clocks>,
 
@@ -119,6 +123,7 @@ fn probe(
         let mali_regulator = Regulator::<regulator::Enabled>::get(pdev.as_ref(), c"mali")?;
         let sram_regulator = Regulator::<regulator::Enabled>::get(pdev.as_ref(), c"sram")?;
 
+        let mmio_phys_addr = pdev.resource_by_index(0).ok_or(ENODEV)?.start();
         let request = pdev.io_request_by_index(0).ok_or(ENODEV)?;
         let iomem = Arc::pin_init(request.iomap_sized::<SZ_2M>(), GFP_KERNEL)?;
 
@@ -140,6 +145,7 @@ fn probe(
 
         let data = try_pin_init!(TyrDrmDeviceData {
                 pdev: platform.clone(),
+                mmio_phys_addr,
                 clks <- new_mutex!(Clocks {
                     core: core_clk,
                     stacks: stacks_clk,

-- 
2.53.0


