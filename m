Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8826C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 03:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC8C6B00B3; Sun,  6 Sep 2026 23:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3830C6B00B4; Sun,  6 Sep 2026 23:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0576B00B5; Sun,  6 Sep 2026 23:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CCBA6B00B3
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 23:51:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53FBE1C25A5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:30 +0000 (UTC)
X-FDA: 85185591540.07.4D43FC1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id A8EC220009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:51:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=m0tE0bqS;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788753088;
	b=lwebWa96HdKne1V5lLrBYPtcIuuS5DwzrsxpNB2ae3uDk+WjX0KBuGGpieSytYXksFzimx
	XtYzdDjwy8cMR81Y1sHaIyLp9SSQtWaGHtiXS6PXs3QwVgsTQ2rEYwVxNmNihzA+r41/0p
	b5JdAetFqmgmzJKpKPEoPsdk8aY2tjw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=m0tE0bqS;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788753088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oyVNXwLsMJjyEGYXhmE5mBXLv3cM5Q+O+rDuyg5EbCM=;
	b=eMiujhgFHFnEtbrZPy3lxXTfeGErnWeNuCf+Ra0/nmS1ll3xP711R5iGnLIrRCCyh0GIJB
	Rx/xkf1dLIGY11zr/KzEKaPNpI8GybtGQsDf/TYvE/7CXk3/10weFhyt/OdL/mpPyFcMAj
	JCCmDiSXF0aaO7fgSgWMiJg0R9g/hDc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A0B91AED;
	Sun,  6 Sep 2026 20:51:24 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 419D03F7B4;
	Sun,  6 Sep 2026 20:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788753088; bh=DRbiHknfTdWf8cVd0fa3aHJlkJRIF0q+njt+T0kU7e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0tE0bqS8kuL6E4xKkXdBndaV9dmrJWnYtayuHMG326QpcoLZLpPAb0/DA1T8G6jb
	 DXnz+appGHYQ202Zmp2YaMc9Y2T4MHhlynyW2ZLMvNFmRT+PlxlR+n/SRfOqFkxe12
	 bGEapHLRVCvTrQK4XwEzjd8xDQXlHnUjs2nsVrK0=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 14/14] arm64/configs: Add d128.config
Date: Mon,  7 Sep 2026 09:20:29 +0530
Message-ID: <20260907035030.2839978-15-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907035030.2839978-1-anshuman.khandual@arm.com>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A8EC220009
X-Stat-Signature: gmiha3ycxsd6c8r595q3mu1qhrqe86mh
X-Rspam-User: 
X-HE-Tag: 1788753088-544217
X-HE-Meta: U2FsdGVkX1/ikqKTtMK8tKzczFx+fnZqQT1ebBlXBN52751G+kQ1KYsYPN9NjQA4nRDncUg2LbjLexbsh8DDa7lS0YkYU+W/rzV4MAuX4gQKwKUdapaF1Jp92k/A1fnZgPknXlT9pvmaVD/17/wrjaf72iHxCi4flRY4gDjzRq17FXXsRMVh4NHF+Me2vrhhoga0sI8X1tojVPZTuaVCXvH0x7fFpJoSaFK8fXWv9kzFk/1hlEIAVE9hH9zdgMM6au0QFqTlEg5MNxdV3G/z0Nh0P0/pT3viEuuGjmZeYzSLyhZRPFfcG/m6hE7lWf/vvjEgirrGKakv7izfc8uHv1TlX4n6y2gnQrpwoHbKk8JYTF4udKqg+a0WUdReBKwgjLzlnEj2mmrM5CLPEqWwXi6KnERnYjwKicO/bEIIOsj3j92cRqvU4/PrqT+4D35BagZoAmfm8LURqxlh0HfpuC6FwoWv7xx19Aex9dkKr1lQ5mVwcdXE5UhuvpmA3ON6aflFodJINcPuuwQhhcB8BNjUVD0em09napbg5T2CZnnmOWPj0+8EmwrC9S6xjTLgjrizhFlmIHf9YYp/QmVm+Xlsa8nlFWZXBYX8awPFSM8zq2LK5hWJzucthRznABWS+9Am9E1geIN7xiqaYRq8armSI9H8RT1whm7CQU94MR+euIU7lfNDk6JO3+Wap+sQIpvobYJNrOryCOgJonYm8w00SnzfBiTlfafIK/OlpefdMfsecKz45Fs8goU0foCaO2woSgYzKqMERc1DyuxG0jaW0ylYWZIxTQGw52sgNwG4E7Zws2IpjsQpTXoU9O3fzda/+xq5HYD7gLFoLFWGeIKqzALTqjapB08hxZV4/yW7ZEkHQ/S4CmF1AtYSpz+yTSP3BZhUOXKqRsuh1QzK7f991ORcyM30VqW+DD+KvJ7EhtQRAYnkvhM3QsIaDr+IXg/cOgEN+m7wLskdQTu
 DtMlYZPy
 Ss/Lux3VYxXxnG0bekaRzmrvAV9XK3/x4ZOIdG60bOEPQvQynJZd/te3kOf9EdH1/0h2YBjyabxg6l0+Sfx87Pc/EBzS0pEn0IAo4c8g7UxmPC5TvyWUCIzJe6RUEUHeUEFzAqnPiqp0qYRe2zUVIQfeExe+FMUfVcSu4u1T3J03HSwcBZ5zqTcfZjdWQlLRBNgDj5MuhbhiaTa8353wcgaQkcqz8rllWCz8IUuA5zn2Twwv9C6bGwcms7fnom5eGut976Yy/pPCl523xKCWy9ZM2MPbeuX3DWtUxWy3CMdoPoozYnx6AsBDpD7rVt593RLRoIp4HXWzP3fJ783e577j0PwZt7nfNrDfKD3YHOkwIF9Xqx3z+GG10Ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide a slimline configuration intended to be booted with ARM64_D128.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/configs/d128.config | 6 ++++++
 1 file changed, 6 insertions(+)
 create mode 100644 arch/arm64/configs/d128.config

diff --git a/arch/arm64/configs/d128.config b/arch/arm64/configs/d128.config
new file mode 100644
index 000000000000..e0a2d7bd8f20
--- /dev/null
+++ b/arch/arm64/configs/d128.config
@@ -0,0 +1,6 @@
+# ARM64_D128-specific configuration
+
+# CONFIG_UNMAP_KERNEL_AT_EL0 is not set
+# CONFIG_VIRTUALIZATION is not set
+CONFIG_EXPERT=y
+CONFIG_ARM64_D128=y
-- 
2.43.0


