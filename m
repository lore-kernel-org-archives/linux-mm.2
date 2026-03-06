Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14087F01824
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75AE86B008C; Fri,  6 Mar 2026 05:16:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68BAB6B0092; Fri,  6 Mar 2026 05:16:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5226B6B0093; Fri,  6 Mar 2026 05:16:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF2E6B008C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:16:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5B1EB9A5D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:16:34 +0000 (UTC)
X-FDA: 84515233908.24.5EC69DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 54D214000E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:16:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UMh7g+zY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772792193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/dkJdaAB+pKo1P+eI25ypsj40QWLqgHpKTD+Xjo1is=;
	b=op2hoLuWq78Wo9fhg3JJQP4dyNeqM4OYQyKWmIX7r7791QV8Y1ePQ4X9rdnXksnQy1ogJw
	LmHFduuSp2enMzmckidTUozqWYiAxSHY9M99DGLABb1D3MDd/EFmDCeUq/RBi0xcF8NQ91
	DJO50i6TVet6Xp6I6bEahCpfZegNbnM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772792193; a=rsa-sha256;
	cv=none;
	b=NBeJIn4eh3mIrjNLuy3er30KLfQdUtPQvVlEvqlkfby+vnWoNJXBCYRA/ifwvmOE/iL5pC
	OpO2sRFNNGpFEyS6snImZ1z7x+xgXQ/XHdtwySD5U+RlBFgEWH2mInHIY71C7pm9C1PMJX
	50m67UWxdhTrHDUt7p8ZZqdTsgljD1Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UMh7g+zY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D309F60131;
	Fri,  6 Mar 2026 10:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB1BC19422;
	Fri,  6 Mar 2026 10:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772792192;
	bh=k5FQ3POVWHUqSFCK1KHjIrKMQkLSCam/RT4g8330CaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMh7g+zYXegSicI9M1aLSZ+o/u9Faw6vtFXpS+dhIFChWaHhnesz2CqTrWf5lZ1YX
	 PwR/89DOY0KxCfaDF+zvV/j0Ch3nBLN4zXZ99O5x+zsLJnKtg+Jp/8d0ZrzcYbo67E
	 hJ4fiZkHg6cip8UbajFYj19bxe1E8BxOFId9YL/FGpdsypVTI0uZCX4EeT1GlBw/ab
	 v6QBUypGeW3DremKETuRvO9dxgJz/QXm1sCkZZIosBs97NVkjiLD8T1uFOzHSu9wWz
	 /ZloImQknfKb+rfKqLT+2ao8Mf7tlJQPkn+MKqx5VK5iK0Xrx6O7k0ZQZPwfkpqZws
	 H8SRiS+Qx0qUg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v1 3/4] KVM: remove hugetlb.h inclusion
Date: Fri,  6 Mar 2026 11:15:59 +0100
Message-ID: <20260306101600.57355-4-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260306101600.57355-1-david@kernel.org>
References: <20260306101600.57355-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 54D214000E
X-Stat-Signature: p999xqjjgrfkfhpax3ksrukyaaocrgxb
X-Rspam-User: 
X-HE-Tag: 1772792193-763136
X-HE-Meta: U2FsdGVkX186CUKJpgk4FnFuBFkFYQP/1FrRNvRciSG/h+2AxvNiy7ICu+0ZLHkY26p8UfJEcAExyHoM2Yt2RM8NecRhvur0v3NU1L5UbKl3nnfNyFnpLP3vIEFS0cRmOoqPDBXMiR8qSkn4moBNzw2t4P6Zzb2/xlaE4opttqngYYhuKpPrXSE3dhH25GN0GnTVayrIwP/YPN86rsPSy6WbWjCSBdkuamJhnULc2vina1QGlTysZuxSj00muuWttXVHIbCT2D9gBLy31lNhjzfFLNs8rnQZalwlRh5Bp4Iurwi00xvya3/ZMPLW09qazjQGx+rNgXrey5DnSZ+TIxfMksyPwp5WOaYGF2AEJMLinoH/Tez7pCjR06DMbtpN95IZgJ3UQrn+RVuGbWxqKD7wVsrRtKWOfTJlDs1hEPomKWysrI8RfCJrey3xQvdaxM3IuvsrwQOambi0CvEiyTGKnbHkv7n29Xxh3HxI5cpvosh1FFIFnPGkOHfVPkKmSV3WmtszeliPdqjegFbkCKcxn2B1iBLOSRHpisAWf8wBRe5gIXEzEEVR7uqdyCj0mBXlQwReojloPxYB7XQ00tVxdyPge4et/lHL+ASwZ7D2HsBX+BCn0gf+hdAeY8pexubeVoQRvQrbjEcWSxUw/Bu/bsDkII/6yiyrEsaNIwFjm9te9pVUXuWaw3ia0Hk8H6tbh69MrVl/qo2/dTqo6LboPf79f9Dq7WqW1ujKg05fp9pQ1UPZYDLxJBL+hwIbQzC4qTq4iJdlrAM3TdpHxaNcGmMyTI1GjvgYTK3mvy2NBnuAUShV3GnryoLvcz/d7THyY7dEiEceXXrJL3vBXTfXwidNKvWGGfMrkiAJLd3DZmiF2QD2XiM02V8QxRbYICY10XYdcVNvog7/PFuLXBNXy0bFoNp1GYCEqZ9rRtLJavvLWtfSKuOAAu82HQF3Ud6bkUVsBHOUgnu4c6S
 UFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb.h is no longer required now that we moved vma_kernel_pagesize()
to mm.h.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 virt/kvm/kvm_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 22f8a672e1fd..58059648b881 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -41,7 +41,6 @@
 #include <linux/spinlock.h>
 #include <linux/compat.h>
 #include <linux/srcu.h>
-#include <linux/hugetlb.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
 #include <linux/bsearch.h>
-- 
2.43.0


