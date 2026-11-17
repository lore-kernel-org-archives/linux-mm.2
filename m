Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78DF6606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=OpuGfhe6
Received: by kanga.kvack.org (Postfix)
	id 959506B05C8; Tue, 17 Nov 2026 02:07:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90A896B05CA; Tue, 17 Nov 2026 02:07:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81D986B05C8; Tue, 17 Nov 2026 02:07:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5148D6B05C8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:07:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B61101A036A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:18 +0000 (UTC)
X-FDA: 85443729756.07.D249D58
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 15BF3120005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OpuGfhe6;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899237;
	b=PrJ3t7gZILgq4jC7KpXygRzyRcqRRPIl5Pb0smxS0PguuJWKp8I02Hm/yIV1hplpZb7Gt0
	hOoBNJcCjOdOZYcBShT5kuSuJBCe7dUct3LbE/8l6/y4QesWNal5htWU2Jnhq5jwVIvFhw
	kqpUHLls1OhXkCylRAq2kiaa1pQHpkk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OpuGfhe6;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=037BP7LSN4gD0zQjrB6FwBIbxukPEEKzDg+C42Jifdw=;
	b=Bac/aCIxaeN77ZeN/Tcq43m9CCnQa+7sJxlAuo4GyW9BqMviwfoKlSQce2BpMpR11x73/L
	XlnowHEWyRVq3jvSfqfGSRH6rSTWeIzfFnxpMFSGSD7uVv3YooVuRtPCwBxvY5SpuJ27Su
	Mj9uTDDSlbu1FtcBcfuvrZasTxhnuRo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CF431688;
	Mon, 16 Nov 2026 23:07:13 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72E9E3F763;
	Mon, 16 Nov 2026 23:07:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899236; bh=ubPPA2iriBEKz9Li34H1P6Gjby7HXyDV/7vIdwZFjPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpuGfhe6W9DIBiXUJhTBR04nun2AmUPAaokxv/1jyVMXPblNPmYtiBM179AACGujk
	 ol3M2Fi/dsuNQqbHzFc4TU6C26fgzcv6r2SySrTx9kjrj02VP3QKNRpKe4++jPsBA7
	 7tjkGgaefzBrzBWuJmNQ+srM3RKLPzoJCegI45ag=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V3 14/14] arm64/configs: Add d128.config
Date: Tue, 17 Nov 2026 12:36:13 +0530
Message-ID: <20261117070613.1183243-15-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 15BF3120005
X-Stat-Signature: 67fb7k6j3bz91irii7r5mrco6qkde7u8
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794899236-212226
X-HE-Meta: U2FsdGVkX1/0usKLjwSJVMCh22LzPxWaLlhMQPWdZ6Dl9PbhssdUUkffiWa+AqklZmjkMEdvwRUJDlOxojNyRakaFETSLfBSW8mMKnhm8MnGgtesEWYK13K/uPpW+1X/26LDgOLtaVdcqBahnkktSAgDe3Sg6nTKyqRfqXbZW3fMbluy1kdisVRX1FgypBfK6OvDdsvhaoj19vYMFig6dWhEKzi9jgW2FfAj90lRYc6x2ZuCzleHu4xav790RMRdpxWKEIY+DtvWwVq+3jm9ZecO4J2ZCUvxq9B/NONQYhx2LQBf8UFzn3r73D6B/RbEgsOhBqycWKQVkz4dtvTBwTEsHN1eeiHx6cl98xP3fzbWt1AAXJQUg9QBLlUM5gHBOzGq9xKTAOcmAdN841EZMTlzcYEWibN6jfo2BJbYFhJiWXyJlKL14I6RkxJ6eRPkjF/f5hsG2kBcCBkqst1AVgNzKxnLGvTReQCMK54APCPYx4ECK2kHUjXw4xlZIDUtnxiu223HHy5lwx7J+mSsN7F2Uvgg81GnyI8CG/X/F55xhNxqYbJXhGIbW7Wc+KTGEvuUc1SIB4+tdLNpOeo6ze8DnDEajsS/yNdy1jHOTNJGza6+Uz3n6Ik+6Tm218ajczFANOjow+wpsp3O8WOTT9zOTjyEIHQrM6ePgC7hUnLbalJ3gdQKMFQTsUbT30VUNnb97UQW1JcvdkG9X979LP7s2nqA1lluiW17bryjsmm8dvldQoODDAOsyua03FJSJQmnBrI3gpnUEI2CFr6Tzoi5VIrArJjJ66Q4jI8oqyzVUjVhCFDsy6Q/xtiYrPWmZK1HLMElavQF9Obz0pLeTxn1S4qn4sig+EBvP86G8sSGqsskdXcSfnWnk+N3Ykc1ujgINsqjoedKiIt/HSpwR2KCKVoP3EBfOrE+ACBpxZGc6pkp5tt5ZQpCDGBaP3wI9VGKDIgkPnCS4WvfAkf
 /OP8CeFs
 Fk1ekuABcqm1szbC8JGggXWuUNjt7ajdNoaLWHCFxp/ZfQEi9SS+LoHxjAXIx5RZr7DswyZ+0UgF9Jm/txWuN8sze0LwKZl42o39nJBQJyP35ni7Ms797WtmdR06nZjb4zAEvXWvzuia0bHwiZz0CfP/p/xZyc1AuvB9MKP/6SjLXvQmy0D6aHaVhArcS9X6pVAWYW5AUj4jJWvRzvioy7jEwe/9hifkWzazu+umZeHlY4YTbUQGGlZDd+6il2kCO9rPtSAIgJy/tNmRxOA8Bg+7/v42up7ioTHCmMr6/7i7SFfioQus4Uc61CKYiX7rukh+aWrdero5c8bjRpgLl4WSmY3Ow0FjSn8vRFgckj0+laTJsomKYta/cuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 0000000000000..e0a2d7bd8f204
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


