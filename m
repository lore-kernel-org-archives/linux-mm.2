Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65BB0FF60FF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC60E6B0098; Tue, 31 Mar 2026 06:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9EB96B009B; Tue, 31 Mar 2026 06:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D626B009D; Tue, 31 Mar 2026 06:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 978A06B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:00:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49CCB160C06
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:33 +0000 (UTC)
X-FDA: 84605913546.17.A4AA8D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3CF4240017
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OoUjbDYI;
	spf=pass (imf11.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNBozYzj9Sbc+MEwD8TJBQ6n4hdsj2+QwjgfhuYcibQ=;
	b=1dddEc6LAMBCSKnP+Z8L1mpMwdaCzrOT7E4PtlN0d2AX3zJQOcRq6stmh7vA44wK81VJgt
	zX5GzU9IuoUcJ647IABgi87bsU2Gr1kjNwyiYarZn54+lleZp9KnNlxc/20SXrdjyW90e5
	lRhWV0MD4K/ZavQlja9FJLT6KVRGE78=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OoUjbDYI;
	spf=pass (imf11.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951231; a=rsa-sha256;
	cv=none;
	b=Q2AVqtFHdrzk7NQcEQMtNY1eZsXmCtQZE8MvgnBNgLs6p5AOqMSgyXFepdimIUa+rcyYx5
	EceSkCJt+Eb0Ac9uG4nYNOsNiUvnRQi8dD7oNAK9PE3cs+pj7YlA7d4mvttyv5oVJ4/JOE
	6UfG4tIPNrrt+XvXzsW8xOqwBRo2Sb0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AEAE260123;
	Tue, 31 Mar 2026 10:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBE4C2BCB3;
	Tue, 31 Mar 2026 10:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774951230;
	bh=FW0dQAbf77gP2JI3DUHh/5HKOkFfWCP2QQfOOyILTUY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OoUjbDYIQaQ3VSdGFwz8NRODvH9y/n3Kkmc5lP4aaipNKjSHtzPw5pFG8oZBl2/gI
	 5mK06fcq0AcR6L/LGS4bToqUCyKZUejqaLW7JzoKZlbCefXVWzV45V9IpFIlfqucWl
	 6nsG2TRceTEHqy6fbfjhcfWv90GPOEt027/3adzAiymJ6u8qygO+SCe2Xpzv4OtN77
	 QRFrJ/2Ex/myw6Zu3odAvIdWHW4MEE/uPKHyHmWn1IFAStzHxyVvrvqN7PoNpIGwgY
	 OnEKmBZU/HrGi4Vpb1ux4jkASJ8SYex354JGDwvITT1XtE85z3C8XOXtu6fwXR8FEn
	 AAHytpNI+yrjQ==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 31 Mar 2026 12:00:12 +0200
Subject: [PATCH v4 3/8] dma: contiguous: Make dma_contiguous_default_area
 static
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260331-dma-buf-heaps-as-modules-v4-3-e18fda504419@kernel.org>
References: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
In-Reply-To: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1745; i=mripard@kernel.org;
 h=from:subject:message-id; bh=FW0dQAbf77gP2JI3DUHh/5HKOkFfWCP2QQfOOyILTUY=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJmnZ+s/e/ZI4PqR9yY/Xv2e9P7GTx+Hqt23ZZsm/t3/8
 m7MtzMvkzqmsjAIczLIiimyPJEJO728fXGVg/3KHzBzWJlAhjBwcQrARK5xMtb7e4p+fx8c3r9n
 ecNvh6Ritgs5Ik+WW3MbPvTVv72DR1/owof492YHrXdNEOpep3SVlYOxTl/UReeju8LsBc7JSjd
 Vp3o+v/dEV6GB+ckzZz7BWqd/l3UkL1xIyn4UvvJHes76jRlKAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Queue-Id: 3CF4240017
X-Stat-Signature: q5png9bk18x4jjy45oytct6e7db1zfks
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774951231-549634
X-HE-Meta: U2FsdGVkX18boo5QXp/gq6me2+PUi3FB6PvOEFMwyTHchoV0b40GhD++fnezCnWnMohrcCcOUcuxaTBO0zJPXvUmLTUHNDTY1WEvHo006saCwwWfrv8mtJo3gk4a/uJ5dJBPwjKEEi5a+1FmM4zE6wLDeNdMwfvztsCJzziCXmGK+6pvXYX6cENbh1pb7RgGJqruniQqnjCnP0trnm8NP8Rsaqg3IA+CxFMQnWwpBq1Jee5fkQgNtCYX1UoeIawusIsEVYZIpyv7uaUv8/hccJVn8q6uxBy2UIBM9VQxSMP6mqbLIX8jtOVOEM209vmEIjDd0UvP9v6YQMNiAG0S57TQSD/0l34uEeR4c7bdR8bsZHsxepOgmithCITmOIPDkEpLeW4OfJ86hWrcVkJVGy0xgjMgRAGqB9cB29VTrHS83oKkDk728Nes92gTuNw54ZXdnxgzykdCyUn24y3alLNrLnDG9rYnkAdPvi5LMLxv+HWN/4lDOjL+1vHOahKEOFo73IxAftEKi7vabfLOFCilHv1YhCM8w1A8JWS93KRhDz5/LuIKXOn8i2Urr8DcaagYmxAiRTao+gEMFAJU+DkPqhEy1M511y4pIoUatyiKtsmcJF7+jnuN07C1X7LVvVWGdhgXuUvVM+TTfDQU8U1hgj4j5cOwaxb7drS5WtyAMISION3akFTpcH4T2U4q4RrMeyrdtZcxy+ZxKA1nv2ghy2/y61hXLPWVJKWki4PX10rVhIMGQnLu2MAUadWfP2b/Rk+ivPdz8nKCLxbEsUZEqpeOnBhJ8Hle70KDw3LQAGIZOwdNGQ3vleWtV6dQUyVuQ/+ehhb8OAnm2ueSkMgQssqXzPJnWTi/JRK3fMb+ih4LCplUUhxrmzdzOL+Uj82lm0xCYBP5m+Q6xJPGwGeo6M3E3Ccf+7cxJ/LL0Ar+h6gOJSfBGrAL6ZCzvceDJL4oFlH6gg0enxPYsWX
 Xk99C4z8
 7ni+dz9CHgBzl80X4R+E0oiZUMH+aJtUeX3ucYXFr2bRD6sF1RdGlQr5Vu0HFZCbv/EFI2zJI2LRnXK3SedMcPhKTjMYOpTYqit4x24R1AJ5tPL4K9mqjbtrP8Z/cAFU1WG7zyKBWTGKzeTwBIBsOZKpqS2rxb6AR+6hhbR+ktbpvOBARX4ljeORZ0RvgAPj3VWgeFlzGja07Tsu46f300rRw6+DmWnjhrvrUT76eCsAVi8ysU6+DGbYjlPdxQCiMizrBfg3xJgHvM1Z30PuYO0y1uDAsHJn6B/GpxjQqQi+dWBRZWfAYjshjHULoX4fNYrAc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that dev_get_cma_area() is no longer inline, we don't have any user
of dma_contiguous_default_area() outside of contiguous.c so we can make
it static.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 include/linux/dma-map-ops.h | 2 --
 kernel/dma/contiguous.c     | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 8604106c0c01b6a9dadc45263f3b1d9ecfacd4aa..bef279ebeae7de59dd504e631f47c64d7e223736 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -89,12 +89,10 @@ static inline void set_dma_ops(struct device *dev,
 {
 }
 #endif /* CONFIG_ARCH_HAS_DMA_OPS */
 
 #ifdef CONFIG_DMA_CMA
-extern struct cma *dma_contiguous_default_area;
-
 struct cma *dev_get_cma_area(struct device *dev);
 struct cma *dma_contiguous_get_area_by_idx(unsigned int idx);
 
 void dma_contiguous_reserve(phys_addr_t addr_limit);
 int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 40a0ead24979cfdf25e4779545536a5438e26356..fd8d3518a2323f0a631fb185ef92a24c35f8d25d 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -81,11 +81,11 @@ struct cma *dma_contiguous_get_area_by_idx(unsigned int idx)
 
 	return dma_contiguous_areas[idx];
 }
 EXPORT_SYMBOL_GPL(dma_contiguous_get_area_by_idx);
 
-struct cma *dma_contiguous_default_area;
+static struct cma *dma_contiguous_default_area;
 
 /*
  * Default global CMA area size can be defined in kernel's .config.
  * This is useful mainly for distro maintainers to create a kernel
  * that works correctly for most supported systems.

-- 
2.53.0


