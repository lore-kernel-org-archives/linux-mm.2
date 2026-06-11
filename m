Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D205BCD98D4
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 09:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F3BC6B0095; Thu, 11 Jun 2026 05:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CBAE6B0096; Thu, 11 Jun 2026 05:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1DF6B0098; Thu, 11 Jun 2026 05:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB346B0095
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:48:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B93FEA0544
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:48:25 +0000 (UTC)
X-FDA: 84867156570.10.7B7AE19
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id D50BF140006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:48:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B43ChF8X;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781171303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5UsMmNx5K2MhulwAdPqrD4ef826gnyJGcd1eOHt5Pg=;
	b=w9wQqupN3zHCjHgd3X2r/qcBBXN3/nr6Sc8lUcl04J3C5ud7TeQtNjUCenmZP8pFEHUyhB
	uhJBP40EF/fD3ixOLs0MtEECt+aSkys88QJaB07OoEG1lyFU8+pm0HM4jI3vOVBVhDyECz
	zmikSstlpbMFYD4WZ5JGG7zJlnv9QPQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781171303;
	b=t0kPk+AXQzj9d2Dolae8+gMmkYSuLwp2PNKdggR6nRGUF/Q4BserInWndnXuLBI0MEUH3u
	KJku7aiN23nDebYoKIqnPnKEgFw/TX2jNVr7v2/ads7YGbZSyaa38ACs+C9awr/F0NSsTI
	49w8F3qsB7W61fJU5HNbwXI4p/2OTGw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B43ChF8X;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2bf125989f2so58376835ad.3
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781171303; x=1781776103; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5UsMmNx5K2MhulwAdPqrD4ef826gnyJGcd1eOHt5Pg=;
        b=B43ChF8Xu75gmSsoMfcBvubg/ahmHfhZ871OaoqELf35WXy0tpxAc5febR8yEUfNl5
         G/LKPBrgJKB8LAzktZnzRSimbwzQADDeJrZ3VinZOw5McQe+Ci0MRdIGtClKry54sbYc
         tLmLI0eLs4r02FA2Y75YZCukHNZAO/tLtbhmNRf7E9zqiBcqEgqrgt6IyvoQexyPlPDF
         ycYh8MvWdROoifdosGqQ9AdzM0uYZrb5MB8P9EnAagGjlAsb3EITvYM1BchTxWtn9qxQ
         hL/dllnobazKyuUVN78Gn8TnNM2zU2AW9MVUlyrjuImH7RQS5rst8fk6VwU9Z0lrUFXF
         eqig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781171303; x=1781776103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I5UsMmNx5K2MhulwAdPqrD4ef826gnyJGcd1eOHt5Pg=;
        b=KYz7ntCSGbwlBa4rpeEXYI17OTcqkz0cxlkHLRqYnZwMaIQwffPddCYidRCWGvI7W/
         SvoAO9v6/g9GjITObPdfLc2ebBpM3uuY7AcVKJIyODjWJXOQrYZpeYgC4UU4TaRm02hp
         PDpaJEe17/sFspDITAeeXOdLx/h08MFolgI2IVXxlu+AyHlyEevySOYt7FF5NTw6ZLZf
         xJqa1j21gu0EPngG3iHwuTnri58Qm8ODUN59yUAAynnSWTljXNU/1n18yVsQjTjcCyV6
         NlYfJN8Hlwo9bfSiNuNNK7AwLTC9UJKZM3WXt3HdeBjpPxXtRknDZvA7n6ch3je1+9sp
         4xLA==
X-Gm-Message-State: AOJu0YwDdTglhfqLEJWY5y6pqlKW+BucoH2lYp4/L2xGa9iS0xGLPMcJ
	SELI3S7Ejl9iNPHgdYgVrqg2eT4kPuwSl4VCCRgtUQq1w6XeO3XdUo9zU1KT/nwP
X-Gm-Gg: Acq92OHjvq0WKCS3Ui41cUunao0LNhg86h6LaaKL18CbcovfgBJ5xCdqBdjzdXTZ1F8
	uaOfZQkodIMVUcoQ6pD3iRmKxLYjRkA9rtpYthfCH97WZ04WyUvd7ZHxcmP6wP50iq8ZlG1NPKL
	1fNRTdvibrEZ7/ZsgR5rjIjwHqRACORsFOX++eNhLGyucsa12MxXg9Hyq87wv1BYJh5fwBeiYtO
	ctGG1k+b+uI/Fkdx+irAEbPePrfxC2Md/5Q/lCwcOnA2it/utfx4cDj+YBU3ekmiQg4kvF6CRFS
	HUfcMmCAtm2c5OvTcGwX48U/1O6WDfkf/RVMbF4Rp3b532LCSqpYvBdeZHuPSyt3PXpDYsL56r/
	NADDbnuI2u9phV55n8XfjsCgCKPc308Mr5y6lE5FwGX2wOVea25smEltu4bGybjKmr0pbtIq5Z0
	neF6JlYopls7AR/mjO2f/kUlobZRBnggCkeP8SPJQtlu4=
X-Received: by 2002:a17:902:d581:b0:2c0:b9a1:6493 with SMTP id d9443c01a7336-2c2f072df8dmr24320965ad.10.1781171302591;
        Thu, 11 Jun 2026 02:48:22 -0700 (PDT)
Received: from pve-server.rlab ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16629d042sm283324905ad.60.2026.06.11.02.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 02:48:21 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-mm@kvack.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Sayali Patil <sayalip@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [PATCH v2 3/3] powerpc: Kconfig: Enable THP_SWAP on Book3S64
Date: Thu, 11 Jun 2026 15:17:53 +0530
Message-Id: <3abf510d24c8ef17bd5e324cccc5e03e548afade.1781170904.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1781170904.git.ritesh.list@gmail.com>
References: <cover.1781170904.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D50BF140006
X-Rspam-User: 
X-Stat-Signature: dgeoitk4r9m6ez3xeptum1i6rk1hg6fb
X-Rspamd-Server: rspam08
X-HE-Tag: 1781171303-887713
X-HE-Meta: U2FsdGVkX1/VTf0RRHEKb7tHA4cMdP+CEjAcjVTURRGRuviRCz8wj/zosB806LGjy/ay0koh1dzEWOZ00cbm2obxDmX6NVMAI52OupP1cS3Qed2oxM3AEQGm83QxRkvpL/gKtPnLR+GMy5f4iiw6nVrV3DDZz23deOzVvOqRYvYS5Uas0iLUeM/c7YSMzHFR5unSTE0jYL3O4/R5B5eTYCFe2sPUsuPoYdEv2jZk1bRXw0tqnETbKdFBScKHBBCAE/nlgBQBlRbgRApbLwRRT63+hHvWlhd9s6sN4PYzR75NJ4TZSLgGBV51xav/HKBiQhVyYOjBLLXmDkla/o25aoImv8LjL6n/vnZb2MjvOmJKrkjAaZUaLIrS1cNwtyJ1PDeSYho52MlLqFGyYdv5h+RWs1ewKkVva2+9MQMx7nmai6ApdXNAH1mBLHLOmgbXUrtAHLx8MkQ2bWR8Ik6oa84YgO45ihhm4NzyuKElWPLMUiHohm57kj9vv5QCFp+AFk+8qb7FyaG9d0W6buHhbxP4nhdGQ9opO4JfPkYOLX6b75VZfixeQblBvINCDQW5Q7PjOrUv3HFEGBLcRV1ODw+fgwFA/XB248862/l2Lrs8HUuQi6hPX31xgjZeC/0UIrCtQ8HX0rVKgbQuwwGO8+M7KJAe+j5SobJtBp+HLN23Em1OsV4Sa3s0H/Y/l/PJ/QNtwkMGVQTX5LXvGyrDzpJboadTPBYtGPsT/MsawT7C1yUocMbx5KV6lelt5B/grRJsKlcWYSY/PeasZ/IeVS834nx23CJ1Teshxr9uT0l+JAcgknqUSfrKYioOh/lLPXqdGueGAiVHUfRB/4tqb/iF74JkP6s8AKpro7FE0NO8J8ru+x9kl6h8Zcd3tJLk2CkdWHVkz6RPYzFuOlwKU6Ei+hSGhGYimQBKahws+BxjT4PkUFoBax9SCdFZjLTIIqE03vB/YCEfZpZP4Hb
 9cHMyce7
 Xmwovlc+kyeCyVzn3SoHhsWaH7d5GOFcvBuexul0h32PbrOCAD7Uj/HeavFXjqjewvpgWn0I22LO/zjWUhsznIYHE9ept2g1GSCfLDyXvi+GTzVgyeQTCWfcbV/8AzuOgWNtlnI+ePnzuSMEgieZjZujoE7NudJsgoNSGp06MoUtfylh2cpTkfIiKPUIBQKI887xgNQXat7LtiWrdbist18IKbLB7n6QispzUZkU9HZd3YohM44FnWb46NgtgibxMA/DN6yq0ao4YJO775QS1pGRLBl4PBVIW8e5pGPXvcE5HpRbQgIetkAz2eKq9Vowz0bTmG2S1UcTh+zjAsrwaLcSi6MicZ1lr7Zw1Tkr/ZiQv5ZmTyAvWnzLZ5Y69pfh+YsIUqFKT7+kIOHtYy64n8mnKb5ibF83iMQs+MsCqFvgBfFMSeehG80tNoRdT3wx+ARzlhZKJ1IIE7AWgWPcq1AzUihnRj/2LCKoM9GcHiOsOtGzWEfuVNRryo+PI1CfJpIyAfk99XhFtYDyjQ/N/24f2j0cc+9SXvu8u4TgFd+RscYPXuHzwqXlKj7ZaJnSzLIph73KPox4jWAtduyiCd9jgLdRxOAwM0J7A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

THP_SWAP avoids splitting of a transparent huge folio into 32 smaller
64K folios (Radix-64K pagesize / 2M PMD) or into 256 smaller 64K folios
(Hash-64K pagesize / 16M PMD), during swapout. This improves the
swapping performance since all the bookking & I/O submission happens
once per large folio. More details at [1].

PowerPC Book3S64 could not enable this before because PMD_ORDER is
selected at runtime depending upon the chosen MMU. The earlier patches
in this series turn SWAPFILE_CLUSTER into a runtime value and introduce
an ARCH_MAX_PMD_ORDER upperbound override for SWAP_NR_ORDERS. With those
changes, we can now enable THP SWAP for Book3S64.

This increases bandwidth throughput with zram backend for swapout by
40-50% with Radix and 100-130% with Hash (Tested by Sayali)

[1]: https://lore.kernel.org/all/20170515112522.32457-2-ying.huang@intel.com/

Tested-by: Sayali Patil <sayalip@linux.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/platforms/Kconfig.cputype | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index bac02c83bb3e..48f74bd22343 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -113,6 +113,7 @@ config PPC_THP
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE
        select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
        select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+       select ARCH_WANTS_THP_SWAP	if TRANSPARENT_HUGEPAGE

 choice
 	prompt "CPU selection"
--
2.39.5


