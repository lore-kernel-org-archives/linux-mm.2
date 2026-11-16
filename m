Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7EDC606A89D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cEpmx0Dr
Received: by kanga.kvack.org (Postfix)
	id A3D3E6B05B8; Mon, 16 Nov 2026 08:40:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE3C6B05B9; Mon, 16 Nov 2026 08:40:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DBDC6B05BA; Mon, 16 Nov 2026 08:40:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68E4F6B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:40:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF7E78059F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:40:32 +0000 (UTC)
X-FDA: 85441091904.14.E392009
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5076B140007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:40:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cEpmx0Dr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794836431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5x9NAjwyHTj7gs1TvGr/q/XVOTeFRW8sCriRzxuuRiQ=;
	b=qAft8TpmzOUJ1Zm1skl95yDLPAEap/jZY2d0tvXsJrNx3HuC+GP82qv8k+q8sUXp1BedVA
	h4RNDniLob8ifhMGWj4aKhnZ1AntEy9Vxeh1M0ViX+g3dWlwrv8s7+glfJ5LUNIomGxf0A
	J7YUbCTfNX0eoP2E5B0em9GJPLsTCCU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cEpmx0Dr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794836431;
	b=7yIRDkQNLKmcFmFab0t0GvJsAVj2AbaxiAvPHqLGj1xnJgnh8Bj9UIy/qbVUjcv4dBbWE/
	8BQ0Cn/lqhd8irpRZIr6bOvx6q1KpFNYIb5eycxkdZdhcZ1lAKIB23Pgqc8YvTg0SWFWXw
	bSf+8lNU+5OtwgUSZ2T/qYEZvgfW9RM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 806414015D;
	Mon, 16 Nov 2026 13:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063801F000C7;
	Mon, 16 Nov 2026 13:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794836430;
	bh=5x9NAjwyHTj7gs1TvGr/q/XVOTeFRW8sCriRzxuuRiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEpmx0DrzH4kQYgsIkL897GpxshBlqigkorGhJo3MJ8+VZnRor36BETgWpSsikiZy
	 a+x8UHIWtb8HhghpobzEAAnBRXwpM7ExMD864dFUseejt6SABl9jVOVY8hbpsYksHt
	 OxKRMzN6vkTW17vcw/CXflhsSrldtO9M0BDqg1zI1vvNTJ5w/xJJrhEGAjXo3PAe+o
	 asCk8iN5LZmhUgc+SRGVQ7Ae10QCHG3Toi9Lx5Win+W98o2Z8z8bDZzU8jXRbTc6EN
	 Ro84Nmtnjda6fCuTuKS+Yt8KSnp7JkiMTeC/eySOLWugBM2N1lFSx7ak8+ldOAsIPZ
	 ehRje7JdM3o3A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tarun Sahu <tarunsahu@google.com>,
	David Matlack <dmatlack@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 2/5] kho: build KHO objects into a single kho.o
Date: Mon, 16 Nov 2026 14:40:07 +0100
Message-ID: <20261116134013.1636689-3-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
In-Reply-To: <20261116134013.1636689-1-pratyush@kernel.org>
References: <20261116134013.1636689-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5076B140007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: ryqf3acb1wocjgg74mkcm65z7sfuyuma
X-HE-Tag: 1794836431-676916
X-HE-Meta: U2FsdGVkX19SvEWHfZrdy7Sk1rXU+rY5PnHhlmQxbu29dvwQ+sT8Jd2c1un9evx+31ofVxgLj4nuP6LRLgSpSdQjHDMPkjP7cHccgJaP9jwYTvYHP4d4v4EAm7KbsZFORQJ39escteCI4TrBOfihFL9Vj4XDnbR3ZXBMcDnN7HNSpXqM9OenfxiYHRk6LPb3jLQFlTgbNIG01eF2ZmyiZW82xNsf5IvnAWrgpR/hD88ZNkBfovefbCIGK7hoQbEg6HEPIbbsnYxJ7JvfOLzFJqALalNmDPKxJlWWTj8Hn1q7lEtuMqztAJDEzPJhGjcdGkY4y+yYfiJN3HYnpwwFeScxAtXlO7RleDC/cOFQxxptdahncLMyAYt7xmg/w9UcgUSOYqiqxMZ+TSU9vnDc/i8jnJRPkZnqI1Ji6hk/7vk2PjnrGuTXW4B4NMbVddndva58yJPfsrIXgpY1GLMo+eSq7vj98KtIVg+SPPKUcO45dvE37P+O0c/wW5r+W4mY2AjfayDY8G2v0XRdAOCCUtvza52wJPwteRW8bFHJXStFgAHtwzpL68OfDr6ydgsGayzsFHbiasoeJyYqkzRCu8gWHjAt5y9fpGoFwKaCI/Vv2md2rumv+kjbig3rMRV4iD08EUY//ZmIe3SqexBD9t4yKe9L8RvTAgFOadUlYr9BUT4GYH/4eraqVfgqsAOzTorRedjC+B0UO+v5ghdfma3lJym2RccM+098R9pbtrXBOV8oUUNPB2Y/HL+qm1vP7v0tlbK9SWMlm8t8brjJXZFVqXubWP8Me2y5pog4OjtJQwJ6uERJkJG0k4hDZXocYlo4aqTaygvGGkf/Mi8qHsEsRn1sfRF0kPau7uwF3nr5eewTNDs1UEFNw4NxlFCp6bNEF5kCARx8aq2hpQx9Z/VXztH4Q7i+0ym1iCSHYfATeVlCzQNsIYuVAqLiXtP5FvJrM97/lGqcdyA7pVn
 QOn2KCeA
 Ozy/Crb14vh3YEifOL9NMab/jZOjF5PBlT/ZRGKtOSJ6aRXHVd1jnAEcAdlf8H31mo5xgkte3i2spDs0o27Z++bIyksOuNzpc6y/DLcY3PTuEO2jYSK+ddw1LviFtQeFJpv48vZu3iH+746+vhXKc136dFWKZB0uV4221SLugnGjc5+akuHWEbn5O/Hoc8B3Pms3uMXcG3mM0Cq+kbpz0aJgO+uGVjLS7PC+5LOvSqRE9TI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

kho_block.o is part of the KHO infrastructure, but is currently built as
part of luo.o, which ties it to CONFIG_LIVEUPDATE.

Group all KHO objects into a composite kho.o, built for
CONFIG_KEXEC_HANDOVER, the same way the LUO objects are grouped into
luo.o. This also gives a single place to add new KHO objects.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/Makefile | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index d9f4694625567..bc679905ce3f2 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -1,13 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0
 
+kho-y :=								\
+		kexec_handover.o				\
+		kho_block.o
+
+kho-$(CONFIG_KEXEC_HANDOVER_DEBUGFS) += kexec_handover_debugfs.o
+
+obj-$(CONFIG_KEXEC_HANDOVER)		+= kho.o
+
 luo-y :=								\
-		kho_block.o						\
 		luo_core.o						\
 		luo_file.o						\
 		luo_flb.o						\
 		luo_session.o
 
-obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
-obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
-
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
-- 
2.56.0.611.g1030f0b940-goog


