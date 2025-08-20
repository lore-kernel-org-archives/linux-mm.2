Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E204CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432578E0056; Wed, 20 Aug 2025 06:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A348E0003; Wed, 20 Aug 2025 06:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3475F8E0056; Wed, 20 Aug 2025 06:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26D138E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:34:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E91C61DD575
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:34:06 +0000 (UTC)
X-FDA: 83796775692.14.A9F74F1
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4532A160008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:34:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755686045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AsjZMMtaBbupc4oGzIo3XvAEclb3sb0eigWneHj5NVQ=;
	b=DR/tdLrdyCv//yKvA7TvnfDnGEJ83kOINBVgZGHRVqX/LY53wYN82KJmGXRgftUaDiFPJX
	O1mpaX6hrNwGDubzfJqCedExAUyi4JN5WaehKx5YGxYv1EFqnNLvtVcUc+0Ykhq/UOjP5H
	N2YAJs8wzoJo5Wl+V7103Hg3yA7AmTQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755686045; a=rsa-sha256;
	cv=none;
	b=I+8fDedcr+tDnY9ZTd/rOQgdCdwJymNXGQzm8eeM4sskAeVFPhmZ3pfzJkctc1SiZcfAGj
	mSoEHVifKEigP2LwqkR/pi1RXNw7oKyg8paJ7ly5ckV9gE/r2dmVI2BLXZJykx02KHgvO+
	YMQdvbJAxPQri1T8H1K+2JG9YFguIDA=
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c6N6g74knz6M4qN;
	Wed, 20 Aug 2025 18:31:55 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 5B24F140119;
	Wed, 20 Aug 2025 18:34:03 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 20 Aug 2025 12:34:02 +0200
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Catalin Marinas <catalin.marinas@arm.com>, <james.morse@arm.com>,
	<linux-cxl@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-acpi@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Will Deacon <will@kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
CC: Yicong Yang <yangyicong@huawei.com>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>
Subject: [PATCH v3 8/8] Hack: Pretend we have PSCI 1.2
Date: Wed, 20 Aug 2025 11:29:50 +0100
Message-ID: <20250820102950.175065-9-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4532A160008
X-Stat-Signature: t5yhibc5qg9qjxj85sqx5ja71p3ae1os
X-Rspam-User: 
X-HE-Tag: 1755686044-44924
X-HE-Meta: U2FsdGVkX19j7hrtgJrOoQficyBofMxP0Qsxw7IK/DzYBF0SsTo7ezgbMaqnKL4AIKw1SPTA7/7+PCsOutcN7wqqt8PpyRDNCFf8XDCkiSEI3Pav26ZVzNe41AtgXJt4d1+L26JeSwCn9WuSr5u7/NiiGDXl8uNtV03d6d6OCKOrS+YGSCuNNfkLfKRppT/oZ6NbdpAguda8PkzPIPHT1NNaXOhXXYQhJM/X6+J4qjK31N5YxOw9kl/u2He4zx7Y3wLA8bRQZWcGGqJuM0Sop3iWSVkQOYHVt7ZyLhmrQQQW0SxRnwD7tRhT+Ry6HSJl2JAbi/bjGjaPMjWfPQTeNFlAsqd7E8oQ+9Z4faSym1gYZBv+qj6F8OBZoEMV+YCpm9jrEovrtivLbOpHlpA+HD2zZ+RfAt0MnmPVPJGzhvSO9QbWY5lAE/OKHRCUvabH8LLvWtg9ehJIw+xvbOjP/tAeIUpRffKiokdYtvfJApimtVkDa49MOzMJoX3vPZkGj7vFuF5nteKkMI0wAEoSeKA14ZAuYamxJ91QixuI1OsrwuLP2KTzBwX8VHoKiNg/oUwMfvy07X0SbsDYvPrW9vpyzYAZcWyhu47lfTIMJegCueE6uqI4B7rLGGomcaqFU3hcbnWNeNDyCjxztIIr17Od/0bbIT1NFzmhYfnP9XWfssbhrXxuBzrdXlESBXCtZMYXzjGl8rp/7hEG80S5hfep+9t7DMg+ofG2jewRYQpGle2uxOER3pYMpWQCWUZA8mz1oSHYRVpMVnDquaZLAnB5yAK5Lc8FLEBB+Zwry1gqupkrtrsHhF/Q6ZfTI1BEqPdL6nYltwvxTEMCGgtlg0Uvv3UnNFDcwEBDtHIpMsC1EvNoI7gYYlfh6KkiYJeUSp6XwJi1KAA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Need to update QEMU to PSCI 1.2. In meantime lie.
This is just here to aid testing, not for review!

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/firmware/psci/psci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
index 38ca190d4a22..804b0d7cda4b 100644
--- a/drivers/firmware/psci/psci.c
+++ b/drivers/firmware/psci/psci.c
@@ -646,6 +646,8 @@ static void __init psci_init_smccc(void)
 		}
 	}
 
+	/* Hack until qemu version stuff updated */
+	arm_smccc_version_init(ARM_SMCCC_VERSION_1_2, psci_conduit);
 	/*
 	 * Conveniently, the SMCCC and PSCI versions are encoded the
 	 * same way. No, this isn't accidental.
-- 
2.48.1


