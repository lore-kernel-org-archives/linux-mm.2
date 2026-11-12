Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 443AA606B352
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h/r3xrdE
Received: by kanga.kvack.org (Postfix)
	id 53D456B05D1; Thu, 12 Nov 2026 06:26:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDF86B05D2; Thu, 12 Nov 2026 06:26:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404706B05D3; Thu, 12 Nov 2026 06:26:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2EF6B05D1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:26:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A092A12054C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:26:14 +0000 (UTC)
X-FDA: 85426238268.17.A5D3425
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EDF1B2000D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:26:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/r3xrdE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZ4lZp1oW2s0U2uL8ErHvlu8up2Pjx215zhjtPcKJ2Q=;
	b=atSjBtGD2Hy5kJ/ga/ZrMoHQdsN8FcqLp/b8WENyPnmNGgfOfiprx9uct4+KI7Vr6cGS1h
	jO0hbkUA3Ff7NlY/EkFuDwhl8WxRHzGe5e7+UlroF4qeemdtFGvGcuLnFOdItH/aXMidCJ
	KYAtdAdA5hW6zYOszU8+UpHd4RifotM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/r3xrdE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482773;
	b=P9RTq0UGg7kglA3p+7XJsEZ08Fii2ItVuTWw/eGqw3ULormZN/4t73HZG+/gY7l15anlIY
	zHvsX5RevJp7MSiRLwgD7tHKQ0G1bSOv+GGbVe4l0jDUU3HzZIAkzG67+Fd0gPuyqGDQpD
	fc471uF1FqWVj2Buyarbaad9YERB9x8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39F5941325;
	Thu, 12 Nov 2026 11:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC0C1F00A05;
	Thu, 12 Nov 2026 11:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794482772;
	bh=GZ4lZp1oW2s0U2uL8ErHvlu8up2Pjx215zhjtPcKJ2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h/r3xrdEhQleZV4yGgXPVqBfanfjsSKJ/g60PP/OJoc5XviAAJAUlX2KuMamvkihO
	 6S5H6k5b1RNd4xXJLVJ91kcuCCQCZTXO1k+1hQn6/O+7RvV8jNjkBRJXIlQ1V9idnR
	 9XiRe0gigvMNyWa7iIbigaFbf2JOHB8+iOYN0Ye9RreZ/JWwevZQj5VfLzPUXudYPN
	 9zN8Zh9SPvZmpMfi3VkkfJS4yMkZoVwR2dg8Pxff5QMrY76ACoV9Zd44FOHqSG8vPH
	 /mQ1HwpQ/1l+8doGR2M/t4fFEC8tmhl4Zq43fF36z8VjNjv8+aaMf4c4pJisKk9Stz
	 Dl7K858NfhsuA==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH v2 6/6] ARM: add CONFIG_VMSPLIT_2G_OPT option
Date: Thu, 12 Nov 2026 12:25:28 +0100
Message-ID: <20261112112528.1116405-7-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112112528.1116405-1-arnd@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EDF1B2000D
X-Stat-Signature: n87wpfjzjiq9x5m5ug3siqgjo64eappi
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794482772-744888
X-HE-Meta: U2FsdGVkX1/+olCBKSJakwKQf0CiYJipcnS4K80flnxs3OwI7Dt8Dr+Jr1M6LSEmMzr++ywS3QXLaknj2rHtaApvzNWMfySWaPe4dN5w4zvytRuLsROiCVpamjOIvmNUhJnGJ6WV2fYIZQixoTyQM6heKe+5aYhXJ9T+S3Cqk4e0mMRyXCAiqWBfANvSFTiXJtLTaWowe/KCOcxdtmgWR6o1HX3D0A2O7PHdAdOL6UOv//vEFKV7M4QzZS/tcgz4hBonJ+v0Hq1Bhq/n81j/ERSWkLdB4xmVVrzp3pTvM35D1ySK4n8HVGwzTVn2a8CET1/EPI8cwNSXFVGXtluBZzbh39EHqhoSlTZ7IwAYjKkokbYuW0t8j6BGiv92MH5qQNjyG0jClFhiVo3oIpECBEC9Fo46nZxS/RBHkTQwouzOOYyxHiumgQQ7EtddUuVHnl5lz/QfvEvuqHxt5TpPI8tePPexsxY7D1WZxkYegSLd1i2GJOPzhZLO/5snvdCYn97zOFWDWGqYawovvQT2T7dFIgUSQJ/CXVGtgAUO4ynktCDq5o3CmN9QGD1QjW5PSwxCd1vGq/DEdlF2a+//85E61u3Rp+2eFJMcS2DaFvMp4ute9u31T9rAmy7TRX4DzPNVOIMqddOgDLhiAkbRdfGml7qkIZNjOx81pT9WRTVIzH6BZM8LvHMamKUxp3sCobnIIPF/ltKxMFGrIQyuuDDxHPJP1ifZj91sGgpp1E8eCH6USpt9tiNxfefk3DgqeizSDG48ELGz2Hm4nHlMOyPZZXOXaVYN5y7Ix+E4HJb6RVE1hcOBjxPa5t2j+PKNBagSCFFPEi1QpNZEV1RJ+jcB8roNruusnyR+FM6lp7yDVTKtRK5GTyTlh1APxNI9quxQ/ZVckFnIcL+MPX3h6awiR6jOsf29SWdvwNLb5CRRnHdv+LOR91AGnAd7pctUyeZNUvp6/ntar6OhxLX
 m/p+nDQm
 +p+kd9i/ktHyVczHnq9piQZzCu+OwpIRHRIdvJIQEgDVbWpSBqwaY+NRXxoH6O7QAkEe/slU/ExEikCI4oJo0zawb4+sPc7G2VORegoBUy1zWX247CEjadrWwYgoCzv2oG+bJ2OcUcPDwvSJG8mFbDuKiMd7+nwqONZgetwj6qQ951vYoHAaA9YkJDoB17mEE3xkDY+ahH7fqBGpV8C9AaNePd8kykOM2Dt9fiUiNaYD+Pz+/AlmPNkF/K7FEisT8IErI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

Unlike x86 and powerpc, there is currently no option to use exactly 2GiB
of lowmem on Arm. Since 2GiB is still a relatively common configuration
on embedded systems, it makes sense to allow this to be used in
non-highmem builds.

Add the Kconfig option and make this the default for non-LPAE builds
with highmem enabled instead of CONFIG_VMSPLIT_2G.  LPAE still requires
the vmsplit to be on a gigabyte boundary, so this is only available for
classic pagetables at the moment, same as CONFIG_VMSPLIT_3G_OPT.

Tested in qemu -M virt, both with and without HIGHMEM enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 797705a94b28..8992fedfdf37 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1025,7 +1025,8 @@ config BL_SWITCHER_DUMMY_IF
 choice
 	prompt "Memory split"
 	depends on MMU
-	default VMSPLIT_2G if HIGHMEM || ARM_LPAE
+	default VMSPLIT_2G if ARM_LPAE
+	default VMSPLIT_2G_OPT if HIGHMEM
 	default VMSPLIT_3G_OPT
 	help
 	  Select the desired split between kernel and user memory.
@@ -1042,6 +1043,9 @@ choice
 		bool "3G/1G user/kernel split (for full 1G low memory)"
 	config VMSPLIT_2G
 		bool "2G/2G user/kernel split"
+	config VMSPLIT_2G_OPT
+		depends on !ARM_LPAE
+		bool "2G/2G user/kernel split (for full 2G low memory)"
 	config VMSPLIT_1G
 		bool "1G/3G user/kernel split"
 endchoice
@@ -1050,6 +1054,7 @@ config PAGE_OFFSET
 	hex
 	default PHYS_OFFSET if !MMU
 	default 0x40000000 if VMSPLIT_1G
+	default 0x70000000 if VMSPLIT_2G_OPT
 	default 0x80000000 if VMSPLIT_2G
 	default 0xB0000000 if VMSPLIT_3G_OPT
 	default 0xC0000000
@@ -1058,6 +1063,7 @@ config KASAN_SHADOW_OFFSET
 	hex
 	depends on KASAN
 	default 0x1f000000 if PAGE_OFFSET=0x40000000
+	default 0x4f000000 if PAGE_OFFSET=0x70000000
 	default 0x5f000000 if PAGE_OFFSET=0x80000000
 	default 0x9f000000 if PAGE_OFFSET=0xC0000000
 	default 0x8f000000 if PAGE_OFFSET=0xB0000000
-- 
2.53.0


