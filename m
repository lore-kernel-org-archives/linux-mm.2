Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2F760A2624
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TvE9nBZj
Received: by kanga.kvack.org (Postfix)
	id 1DDD56B0614; Wed, 21 Oct 2026 02:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168606B0615; Wed, 21 Oct 2026 02:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008836B0616; Wed, 21 Oct 2026 02:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDDC46B0614
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:05:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5510140428
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:33 +0000 (UTC)
X-FDA: 85345596546.10.2FD7DFB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 77EDD40004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TvE9nBZj;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/j5EYytItjUwk1/CqHyOHSfaQ3+6rA1AecV+p7hbPA=;
	b=05ajYEr21BiN8obfBx71D9NjBv5TucjrpnOdr7tVFLWh37oGlgV9OzeqAHJ3f++W8eKqZw
	nYR4ignMt+jl2++b3UK7OmR14nvlpyEX6b27ZPu2iIgdhwmZeS6SadVYCLTbKtzr0ACTxg
	/G+QPOP8SiZYAiwBicD50SlKScAXTPM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562731;
	b=7NtEiLnhSHucAd4dZshyJmwfCL2c85ZtXgZyQJAKv0P2Ib7OtDOHjAmhBiFI+6+Mdx1ykt
	b1j1sRCfuTns+s0ND5QGLQsSfv9CFtRVodGsmUCYz8y6KEdttOoiTUDeIjWCH4MWmfJeDj
	3AZq9v87KnuPPaMzRxaO82uim+yDR48=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TvE9nBZj;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h/j5EYytItjUwk1/CqHyOHSfaQ3+6rA1AecV+p7hbPA=;
	b=TvE9nBZjFADycNCFlVfOLJXjuNejnYdwNUD4Hu7dGHijzQiPWAj6BfAQeAVs7SCDLepXQk
	1m+jzqGvcHz+j2OK+RxhTFre+9sobmLQNRb7MmJrFPs637f1vtEw7X4yKrvL5tJGYynQs/
	3nq91wyy1mdEGinENIT+DvzzeweOUkw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-pY_sT5oNNvGYI-b6iyTuRg-1; Wed, 21 Oct 2026 06:05:23 +0000
X-MC-Unique: pY_sT5oNNvGYI-b6iyTuRg-1
X-Mimecast-MFC-AGG-ID: pY_sT5oNNvGYI-b6iyTuRg_1792562722
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48e1ad3cb66so145131f8f.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:05:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562722; x=1793167522;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h/j5EYytItjUwk1/CqHyOHSfaQ3+6rA1AecV+p7hbPA=;
        b=ylsC1CMFHhswa2j4WHDq7eI93pM3reeBm4F8uOyAdnlQMluFeLofdZz51WeHlLDzC+
         Zcr7VE836g5ejQldC54iEq27R6r/QCNdtPB17QHJUKg+MUltbKdQeo4Tj4BeA6HWAFE/
         HGX8D0P9/vbpSLnJvf9XdbMsMhC/+ftTpUPTstx5KEpuGFKxYdTbO01NNpDjVgR185Py
         sdaeIAAm3GBaxfgSBnsS803l54Dsoahm3wwgr/qgknA5zeJGMxZh5+HbEJAHImxlNqap
         9ys+AbzUgrzi0o9C4wgeNiua+ucwQGw6GyVsk69ztDtjlgt5tEHwuZdFuEyFPqj4mrPN
         2laA==
X-Gm-Message-State: AFq9FYL1E2gO8e0Wr6AvTue4iY5FUSL3ymwCRaK6IGpFJHdj9Fqf5ym/
	k/W8gASRb8Fumy0xUcip0N1X7QplW+HbgcQDX0/sOkt96KaKiywOc3OU4aULdJwkc3qqOvGeGxS
	lvcnvPygFIkkRvpxe1ULaxIB0K5BB6/eoBi7mxdqHgdz+0QIHX2rtzDcbfNY/xLpPHL+4u7vsuf
	k8A0KfWYlN3eROJ385zApudHebugATU9r3G4Wc8g==
X-Gm-Gg: AYBFou3o2g+/zU2XNqbSoBbY4W+N29rmZGLmZwTtWme6AN7YS+O7+grFN2CpNTtK2KE
	B63Wz3GAOmsaVO6JGKKc4Z89fxoPCw9K8SLJTa4enmxGkMzmT4WgCulKTBvb0DQWMIc2dE4vCoB
	u4UhckSzstx/jCSoSHs3EAyLMbLz6I15H3Pd3b5Li2w4EmJxVSqcyvt1xiL7jSmMIrtUKiA5IKi
	TUnOukr5hPt/Kvj8312MXfPAvqOYpV7618sOTri5/J1wtceN5BmuTCr4Q8hPn6+HQkpmFF56HJ1
	ncbx2IZVG0S36mrTFPu8rIUioZ5ZhC4QV8z+q3QQzAwwd5zt3SG8BhxItYMIM71CBR6u59Pn/Uc
	gIPOwm6N584gfVUat81WTEClGn+pSza/hMhUt
X-Received: by 2002:a05:6000:2a02:b0:48d:bfd5:79c with SMTP id ffacd0b85a97d-48e264d9d19mr1041992f8f.42.1792562721992;
        Tue, 20 Oct 2026 23:05:21 -0700 (PDT)
X-Received: by 2002:a05:6000:2a02:b0:48d:bfd5:79c with SMTP id ffacd0b85a97d-48e264d9d19mr1041925f8f.42.1792562721270;
        Tue, 20 Oct 2026 23:05:21 -0700 (PDT)
Received: from fedora.redhat.corp (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm3413741f8f.3.2026.10.20.23.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:05:20 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v16 01/12] mm/Kconfig: changes for migrate on fault for device pages
Date: Wed, 21 Oct 2026 09:04:55 +0300
Message-ID: <20261021060506.2377545-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021060506.2377545-1-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Sy9S4FJCAFd6Nzfs7dG1WuTUKo4VQdIQEmhpGXJqMvQ_1792562722
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77EDD40004
X-Stat-Signature: qpwa3cuwdb1z5d4eqy6wuggwtw7risrp
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792562731-264066
X-HE-Meta: U2FsdGVkX19r8xuubutM4YrW9TJtEHqcOBxyypH7N3yqhqYcB/Dp2sBl/FWAas3/u3bwl4jybGNKQuqTRbG8AvP4/jPqR2de2lE1bvWKMhHYKruPI+YdZ5EJizbRZidbGPYOTG8bqr2IcWsImcQ0dCljApBhrUUsNuadhc7ogBN9eqdLJDC27zCMVr2ecFlercJGmKCsnpcdlLi+mj5Z2SJnmjLHKcRf8xaGkAd6a1Dz7JJLxSCbg4FN4jyEtFCxoCjPOPIfT9hqB55M8HPXQvISBN8IKR1aEIrIaIm31ff8pRgTgvkXA7/DGmj3aJZoBMrsKrZX+x3MrupKdrteEyv4tyAN/WzU6lltPDWQQiAYDZvYG/Y9LmRH40RoV7EsNcEy4QsenfL6A9zMeahpnU1Vx6AtESRt7DEPxMMDpyr+CY5KEjesirK1AfeEEJ3ZpiTDmqI/PdkHt4flPIon+/wfL/5yuA+564XH3ZvdTDuS2RfBuiqw/7Pc4vkPuP3kZY3ply1B9XZCxv20Uasdb7O+EyegSc7iYvEQcNBkgWp7/KMX9RTWqBz2/+iI516k9DYFgK+KDs87KGRrE5yQjYl3IZNDoT4iEP9RKMAYXJVTIKBMqcmnLoEDl79YH8kuEMoGu1vzqIJd0QS+/5Ltq/d8I1fHlx7IGQ0+VNHyESCrsauLZ5FNzKzj6ZXYvTARxwt5aaO8RQlBvUaiRCRT2kYA7ZXeHAS/85k1IoDLFuTdbxzEmPZXcBJJD0ozWi+eKsBp68s6z1sZe5f5nTaKVYhEjkGwB46iSB9tOQL02WW1VmxmmPwIdpjXOBc0MNZ/WfmlNFHc76MQMqAsJZgEmZpySzsCxGmtaBp5hKdGkwRVcIhDVm5Rsmo/RNfd9+X4lG4lya622YLaG76t79hT8/IJWDdz/VZ3zc28QiGoFppiD3bfz8rdN80pDkTr/xJJtPwu3MAJG3KzQj2Vwz4
 0sLRMtq/
 CtHzFbDvXWLLI+7C0Xb01WqPaX81MtW4n0CUHveFR7gPBTP9P+SuTAJ2gNOMVezn8kpy39t60N6b6l9OqqHNsCxHrGR79VLjhcQtgUAvfJLBvwpsdLeLtsZlOdi6jQEhlchGjDe/t8TYV9obx6op5XBFcaai2RFI92jbBwdn9BFYKlFrZjWfEiXGW8cJ/HuOtkECTLZdCwctdqQC+z5Ptw/FjvblxkzTuuYsADUVNKmTYN+Lt4ZeeoN4JpxLZVNjICyKZC2PLBt2EcwIXAfx52pP10EMbLJlVU8APysZFx0+h2CvF45J2Pc0jB+8HLalHAniZ3ZBaD/eGMDdudh/PwyeB+jNhwSoDm30raIxerNzMnKDGBgpX8xCxfdjLtCgkbP9xuEjJXwqv7PdJziTMGJl96w7E4XouFiAHZHbpVQM2JUQ2XY9MAP7M2kU5ACbAYnYyqV7vQMapSXMVgG39SvXEYVDEsG1RRGi2AlqvXIoPlhSlLRb1fdE/hskmKyIMrl7/RPNXcPjhRQ/VpN8j1LLSEPRBUF/8RD8zNcMkLedwYos5Cz5UXgLcms2ThlQPYTP9djXfxDHSoc5TknGVWivmHUmfv9XxVurzABm9G6GlipLx+j/+cywlHW8Ik/jsJJ6Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

HMM depends on MMU notifiers. With the unified HMM/migrate_device
page table walk migrate_device needs HMM enabled.
Enable them explicitly to avoid breaking random configs.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
---
 mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..b7a485beb9a7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -687,6 +687,7 @@ config MIGRATION
 
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
+	select HMM_MIRROR
 
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
-- 
2.55.0


