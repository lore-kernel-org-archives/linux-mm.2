Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32EE9C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 10:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D366B0093; Sat, 19 Sep 2026 06:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E0E6B0095; Sat, 19 Sep 2026 06:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064956B0096; Sat, 19 Sep 2026 06:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D90156B0093
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:13:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48644A020B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:13:58 +0000 (UTC)
X-FDA: 85230100956.22.A3F3B12
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6C8FAC0004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:13:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="tCV8/ZEq";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789812836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XJTuK5kALUji+9X0i+iV+iECiWWDSlkrTGs+gBR2/Hk=;
	b=N0Ztu4MiJ5T2IrQemVLbQOtD21+j4+ZCYVIqzXEEljhfIjLzrvMOwFb0kjCg/1BkAiE6c5
	S7flgVo6STTuiOZKSVL/BpZcHmh49UtPC7SpC+iU1obpLw15WTn2N18zLI9Q9W8kgA+bsi
	Y57IfFKT8sO6WR+1mgA9v1nbzhd6+Jk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789812836;
	b=s4i7RtKVzp58mUyb+8CLcOigTMLycJ+Vlo77Q4DhjeYNuXCe2B+XwRuAmX2YMaGKikyVwx
	hqwMvGpODiX4Dw86U3S+xfeelaSDjKPOAKCMu5VecnNkRD4wlOwr23EckKaz0FS0cnpVSN
	KaFMlMSBUf4c1dSIkQg0sf89Sm1p5x4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="tCV8/ZEq";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A9120165C;
	Sat, 19 Sep 2026 03:13:51 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C4033F86F;
	Sat, 19 Sep 2026 03:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789812835; bh=I+CE+sjYRQ9D7SEGybEH6t6fkrM4V9KN8kvDc0ka/6Y=;
	h=From:To:Cc:Subject:Date:From;
	b=tCV8/ZEqWEXIyFG1R0G2wD3x5uG5Uogvfzm4XNcsTOBLttYZmAN+ZMu3H9FTuPFzQ
	 Bj7ymrY6ha+YT98rT0C0HnIyvVreG1WESpy0g4HKGCTQSdkVyCCC6Cmlbdy7SVefvK
	 sBI+vsfK1ilDwzBaS8gOFcnUx9DI1OJ7fCkGqBmQ=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Helge Deller <deller@gmx.de>,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] arch/mm: Drop similar platform overrides for pxdp_get()
Date: Sat, 19 Sep 2026 15:43:38 +0530
Message-ID: <20260919101343.1959572-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6C8FAC0004
X-Stat-Signature: w7b5jb8yddnq74438ethfzwp8q4xeich
X-HE-Tag: 1789812836-291867
X-HE-Meta: U2FsdGVkX1+ukr8TdCW9x52XAsX9GeNbmWPwQ4fb3qtz5Z7BMgdRD9gkFv565wzGFK8R239tzToNcGvPBF9RT1D2oVn3r/TVRtFX9cfdhCa9JMB3S6SsUi6OyijWskp22090FxFPJulTLHMEmq+gYd95IaNQdcLcJ0WeNVfHjaFesh1UebYYp330tuBRkAE/4GryKhR32YDdSSNI2xO/1owTUDoRtL/IToXJ+T1smtmQe/gRgAkY4Rm4rIxaKXcLYWE50isztNllVNk/XdWhVVRnY7p6dHv9afGws4sjun2Bqg7y9PaBrea39bCN7U3tWXFHQioqMc/KveuiH9QKa7dhDiKsiDzwvSxDKxtCRAq+5AZfK/tkT/yl83iS49CNjpsa4Ejr/EYRiENzKiiPknf1sHmJMhKVibyRGd/E1w9+Hvogg2qkT9doHuyRZh9wvj5vOpDE/KpYg1M6u2v2OLeBKuNz3KcnzLA63BmbvPfyE6HOgSnCbwGpXsAjFTWzH6ofLsVXkOFxvLfDrlOtaEt7gbtdUHBUR3H+5lHtNyyDSjf/mLtMBB8zZ4koxXcbGNF88kiLacZLN7K6zoGry0+yMhQA3JXGii4zrALYWYFl85FDunPDVcnAYV3vHIyAGvYULDCY4LHr+6IXjseXz8XRf1lk8rIV6v+I01XSm7PeQ5pJsRNPgPk0Hyu0iC+L/4mm0UTiRthz/L3Z7drHlyWpl5cgDHDKT2izQ++pAsfNlE0fqRtRZzdMa+lMvvq39fi8kcIj5M8o3zsYDfDrnHCi0mEDtJEbwbn1kRo/gC51GJXfK2RmE033Tw+ePF1ud1WUvuDM58bJnoZcPSVTS9D7ajF6slxV9w0q6l/ERuarAA5MXZVEeLT8OJTvJHDrt7CXU35DME/3PWVkA0x3eahRF3asz5SuY78kuoEN7Qwcj/ZVfbkJTXRJ7EVu4jQ33X1U7otvBEYHjJA5WCj
 6MqpiF0k
 QEVhJWRX/p648VnGCFSXhj1rE2QrvEMOQqtdJLMztzUsm2p3oAqWgi+PHS1KrigFpOUg9MjsPl94cTQIzw3RmAeTiis0DHlJNe7/gw4oCD5vPEqLXJinMeXjO5qNgpXLM3L1VXEWk8Ja5r5zxld20kcQ4nF2FwBRARWIbYbDOIkvqVuqNch2R3E+cEay9jdt9muoPMk/IMEJTsqPUzfR/CTWVifAa9sWFJFWj19PpVA+ch0vqqCRDDh/9nD7hz6g4yrQOL1ZRd+Tuzw3AnJYujFiZsSInJNOc2nHkQM+ySUyaxdGSna5VvMrRkOmEZ3o79b4oWb3DoOb2bjZp54mINpMx8Opd7VIPG8o6d5ZxVX2c5W9DlL40fClI+ci3gvggFxrfrmu1kRRnH8ADw8E5Ybo+trRXGFyWllzIWoQxCCp94I24sSgDqS0menvQsP6HrtQOsB5lIkkU7YfeK3bhxV1d7Y9w/J8Re4mZTGAGVA+osKP0IfN19wnYM0WgugmmubuNw9wtpnir85Ehr42X7bmXEHvQjQGgAFtHb6woiPZDVa1RFnlDBV1ALlT6YytKuD77B3NMci/yRlcLQTt10MJyIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are many platforms with similar pxpd_get() overrides like the generic
memory default helpers which use READ_ONCE() for reading page table entries
These overrides could be dropped safely letting their platforms fallback on
the defaults instead. Although it requires some code movement from platform
headers to avoid build failures.

This series based on v7.2-rc3 after the following patch.

https://lore.kernel.org/linux-mm/20260918064928.793742-1-anshuman.khandual@arm.com/

Cc: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: “James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-mm@kvack.org
Cc: loongarch@lists.linux.dev
Cc: linux-s390@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Anshuman Khandual (3):
  s390/mm: Drop all pxdp_get()
  loongarch/mm: Drop all pxdp_get()
  parisc/mm: Drop all pxdp_get()

 arch/loongarch/include/asm/pgtable.h | 20 ++--------------
 arch/loongarch/mm/init.c             | 19 +++++++++++++++
 arch/parisc/include/asm/pgtable.h    | 20 +---------------
 arch/parisc/mm/init.c                | 13 +++++++++++
 arch/s390/include/asm/pgtable.h      | 35 ++++------------------------
 5 files changed, 40 insertions(+), 67 deletions(-)

-- 
2.43.0


