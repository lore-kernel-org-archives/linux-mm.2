Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A830BEC049D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BA346B00BE; Tue,  3 Mar 2026 05:13:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1518F6B00BF; Tue,  3 Mar 2026 05:13:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088B96B00C0; Tue,  3 Mar 2026 05:13:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7A9A6B00BE
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:13:28 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F53013A975
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:28 +0000 (UTC)
X-FDA: 84504339696.21.0C54C98
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CCFB40003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CYrAVUhL;
	spf=pass (imf27.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OirsEIxqSN0FSKMXdXTsNhTDRYSC3/fBCnGLvvix4EQ=;
	b=ktTvI5+SOWJJg0weK5Jr6pDY94wDrwx0cF0Wv3/ktfqyZI1L6NPYcOk6nbKsiVYAka2ngw
	7jbPrzZitlGgcG9pkASjnP7U+zoUtGTdRzRaY7FVhrd/S14RI1Nvkvv0M7YEKHJIiRFsjs
	3c00En9uGctvooURI5OGTqGjqbZB0GI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772532806; a=rsa-sha256;
	cv=none;
	b=wx+W8OwWodrU5yMmo7lhs8iqETFRmNq9mWojFItHzLDfUMzBrY4ynNY3PV+0XFCkv/Zj+W
	VLTNIUIwweeo0Nh3n3gzFQCjAwS9lhEelJyKyGn0qpcNVdqXzLFccmPJMUsVpwSKuY2OAo
	KG8poXlS/VjB8llbpNgNY5tFWJ6c7bg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CYrAVUhL;
	spf=pass (imf27.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 807214448D;
	Tue,  3 Mar 2026 10:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10289C2BC87;
	Tue,  3 Mar 2026 10:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772532805;
	bh=/kD6F1ZhpnmLA/clOq4s+dTJhu8QKey3+LKztnUIF5o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CYrAVUhLcajw0Hs2gmC7vITgu9E3uQi3s+JDHWTE6IMBijS9oIioAh8MReB57fC+W
	 VBChglhx2cEWfjmxfPe2urdQuwHQugtQBgVSXl9cM4LdoUzSuQA4ChjI//qRcD/PsX
	 V+jZC4Dnz3MDiWQoEBHOVX+Bp/UEkLDaun9hnvQGs02U5arp2Q7TJS6eLMBi3T+vDa
	 OJmT5m9BSWcj/GsWoTf4hjEEmJv4beLLwIqspBL1rM4HIkTxa6s/VR4P1wgB8psaZI
	 apERoK/GEY0CTLHnMFT6kxxP3t3P7GGKapmnVrC/5uxyo9ZihIQC1hN0ShuAeGScLH
	 fhl/wWxSiFjlw==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 03 Mar 2026 11:13:06 +0100
Subject: [PATCH v3 3/8] dma: contiguous: Make dma_contiguous_default_area
 static
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260303-dma-buf-heaps-as-modules-v3-3-24344812c707@kernel.org>
References: <20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
In-Reply-To: <20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1675; i=mripard@kernel.org;
 h=from:subject:message-id; bh=/kD6F1ZhpnmLA/clOq4s+dTJhu8QKey3+LKztnUIF5o=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnLtpg++eZieDDufVSmyImd5x7eO7LSXnZ2kGrvloxHM
 7ou7txV2jGVhUGYk0FWTJHliUzY6eXti6sc7Ff+gJnDygQyhIGLUwAm4hzNWB/txW9UyDu53uyb
 8NtD5exPzyyeJvI323Hl6r/5Z7PtXq1IDovoS8yS+fow87/PHIZ9hxkb7sp+WsI9Ked2lzTPDrH
 PlWdO3I3//IerfdJsgyt/VofN3JTl/Osgc/58+ZMub3YovPj8DAA=
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Stat-Signature: q1637rmt6dn5d7ckwriatmowjf7kgdfk
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CCFB40003
X-Rspamd-Server: rspam12
X-HE-Tag: 1772532806-623281
X-HE-Meta: U2FsdGVkX190trS1ueeimmNad+sWorTzItYTS23dhrg6giF99phnLLcYclGcAMqrxuAhncbKzzdNPsyhKfqwyIsBsxhSDUet74sh0KetejxWRVBfMX6n2/TCVGojwVRLehxTz1vj5mk+W5/9zcvEvnEaqZiBWMGAptf/i5NBLXokjlPhZvTqMsWojamoHfpY+ib/fhJyVYTdNT1WL4yEWT4CiXKjY+GbGe/uYJD8R0iE+jxxAKu0uP3/4raeR9q4w8zIUac84arfYBMkkL5KbTp98Wz6eo0oCUC8iUZpj2RNIk0XKWRNCltzGYpNpLot6q+qSiH977UT9pMeaeR5mBY20n3lwElxEk1X4ixcHntnoo8xrpN1W1w+wloophxqhj4CfaDYRs0yfQIX2rH/kiVJkjQ4W9Z//0HDUZAoahiXdJGNxvyeFBTnicsWRd9UJ+dAQhwgveLFWA7rys/onVvcC2eUFeV1EVmVsvr0RMXOI7+NA2m/FoqOxT+XWqKONrBnloyI7+2hErX1+j0stfsGDDxDimx1YbF4l3bo139L3ead2GwUu2/+N2my/rBgjv7U7p5H8GgZNw0CobE+ANiLVu02UitivSHNpJFS8ROKqJTgi3lT/3zyxCDHbK8ICxTgxHbYzeBkv1HcboMgHhZDJEPuWuBtniy33nAWxKTYIV9aZx/lkP0SDDbA206z8d0qmPxU6ok2mM3EBqXGwBa91Q67a6UKu+FU8ohr2rqAABYV+pTwqqgkav4mZNBGTUZkgyk6IlKz/DU/zWYl+iMEMRYfYUfpCF/0Vwfq0iDjDIPf4FUp4QSHM7XqxrVzyMvToMrp6msanaBMQL5T47J7nfsIR/JSDQtV5tDIThhCHCWjCe8QUwF/w1XRa94iXf4HAnCBLW+CgxOsYhXIrUL20zbo/b5AGY2Fhc7PhBsFxHO8Ux/x2rvyThlGI8xMVizoZc4O/rMbQpBUSTx
 Ds58+8Yj
 QdhVaODrA7b+Dz6gal+SB3murHJFe/sJAxrWpbnuN4tygr7+D+MYE2wmQ/3VJE276E7OECgLJpvpURbXQNFuntuEE04HjQiprwXxyA+CSy+o3fuTpnzZp5hwZvNHomepb4jzg7KBa8/628jxyPc8TeuIFF5z7qHs7TGIkzRcvb9H52KuESZRpxWdIUtuJbFffvDfbekwUm53udIEkJaQ3rAQzMrhNY4t3pXxc/YM3DaNfqJ3rCQAoSfECi9drjtX27aOShzI0X3ghljXVebZR8OoaGUui5+XSBFK9dYz2yyobDYY/hx8H0XXScUGjTmXHmQEJwMC3D+Q3/qKZBGpw/2koeNMmLKnqZIk+0u4iltJRBsJD1wmJY1vSodbyrCm8SVUGY1DUL6AB2/d8iY1laLGTpucNbXhjt9YF1JgS3krshrc+fBMlFGUusQi1oNeH+3j9
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
index 6b8e6a2a08e2cb380de764bd6cacb2cb24c22871..94fbf16646c105fa2e1d34d407a830bf989d4fc8 100644
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
 
 void dma_contiguous_reserve(phys_addr_t addr_limit);
 int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 		phys_addr_t limit, struct cma **res_cma, bool fixed);
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 9a9ed7248fb823105609c5db5a51113e54a40192..a4279d800d4658bf1c33b9b1da100eee1367d42f 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -51,11 +51,11 @@
 #define CMA_SIZE_MBYTES CONFIG_CMA_SIZE_MBYTES
 #else
 #define CMA_SIZE_MBYTES 0
 #endif
 
-struct cma *dma_contiguous_default_area;
+static struct cma *dma_contiguous_default_area;
 
 /*
  * Default global CMA area size can be defined in kernel's .config.
  * This is useful mainly for distro maintainers to create a kernel
  * that works correctly for most supported systems.

-- 
2.53.0


