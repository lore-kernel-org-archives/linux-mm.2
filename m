Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E29E4CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 11:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391358E0019; Wed, 22 Oct 2025 07:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369128E0017; Wed, 22 Oct 2025 07:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6258E0019; Wed, 22 Oct 2025 07:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1E08E0017
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:36:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB06E1407B6
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:36:33 +0000 (UTC)
X-FDA: 84025547466.22.7A67276
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id CE6C54000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:36:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761132992; a=rsa-sha256;
	cv=none;
	b=12PqQd9eSkYU6+GOA4HW2dhaVhVoQvbanNeEz48YK+tt7cClapRYr8vT8ZsFjtxGdPsi35
	tiY55e/ghCkmyIFguDJUhpyQcuIzPHQnoLVzd7kFvZ3HwalPJJMj9lMyLcenJPlzNlxXiY
	o9LlOtwa8flc6aaU2fArG6u13WSQ3NA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761132992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9hJzU76UWLSEHecEoTDWDljYi7i8+QRQpEBkRqVDe7k=;
	b=5GOZF4I8cnkein2tubBERspaLg6Hzphi8WA0nxrXCl40uluQ/83P3/26kvlnRDbFrIxdpN
	QJk+KYfP9uIFsbv1TLVCt3kMyuo5PxbSxko45m3PxGZ4pFlyo7IjGk6BVQkovdMlg0mqGl
	weUJ9rBn+/LdBjrswVk1DRcB0bq6vOM=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cs6XS5yH3z6K5kg;
	Wed, 22 Oct 2025 19:35:04 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 100031402FC;
	Wed, 22 Oct 2025 19:36:29 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 dubpeml100005.china.huawei.com (7.214.146.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 12:36:27 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Conor Dooley <conor@kernel.org>, Catalin Marinas
	<catalin.marinas@arm.com>, <linux-cxl@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, Dan Williams <dan.j.williams@intel.com>, "H . Peter
 Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <james.morse@arm.com>, Will Deacon <will@kernel.org>, Davidlohr Bueso
	<dave@stgolabs.net>, <linuxarm@huawei.com>, Yushan Wang
	<wangyushan12@huawei.com>, Lorenzo Pieralisi <lpieralisi@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Andy Lutomirski
	<luto@kernel.org>, Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v4 5/6] MAINTAINERS: Add Jonathan Cameron to drivers/cache and add lib/cache_maint.c + header
Date: Wed, 22 Oct 2025 12:33:48 +0100
Message-ID: <20251022113349.1711388-6-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: 3iodfbz5keyhae593p7msa3ryhpiop9m
X-Rspamd-Queue-Id: CE6C54000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761132991-812767
X-HE-Meta: U2FsdGVkX19386o4mPz2y+bRSjzSQK6HNlYXMCaIjtaLHLsXta3nzQ3271EXLal/DdleUNIjL7h0ySkP8JIzumDLsY+vok+RK1+MNjso1G/4mVhJIuQRop6DSzAJtZy97TnCfsdQRj85/ZGA/GsC/32ZdvNnYeTsLLPuWAER8rDqJq6BTjCmZm8VCg2JaEXm+6zthWfFbYBafKxTt3PGrgvR5E/9F2So8gZWDOGdHq4/bZYKc1hWHZberSibICw8pMovq2OAqcllUIqtETsOPYYfHQ6vYdOv0sQ5c5xHb9xZxvHBX1IArN9snGQh/yxg+ov4bppHGv1QxNO1wed5T5wGS6qZ2qT7RI7eNufj4RhwxuwRH2St2OLRDW7HN7AztwzS6bde2SM0oBG0Y/D5sOHoNGPQFu5DVVtvra5PVq5AaM8+iS9mo55pObkAoCP5SciW38xYVvkjAqPxpsRDrXcghjOF5hw1uFOgDizDJDXRuKWh4yjl2RT6HUbNLbIvX10yCIG8qQPIr0CgsQI0GNGbVE5ZOXfYTHPR8rTRfG+41uhYgUHCIn144k85bsjzjD5UhXGjV25OQiEidHvEg4YrUiibL6yliKctwHbJnFq+Z1yprI/OKhH+XtD1xTayiIhnyge0oZYlXBJIV6yt/5AiRXr+uSICGVEDZGPuiY3gwmSOFFxCV69A/sAoIlZxfN/DEYNNXjZWajAYR+VeMhr5q9aUwRxJ5Uw30hXOuqeoyTK6FbCnksGBaH6EZjeZU1hE8yAAlIyDwa5qcoyggZeKnFZRrriXEoAgPAWUWgQMwTa0CB6ge42zOEMu8XDorvPNPGRPNLhzV5kxj0CpCsQRUt1XnrKLotQB0O1Sw2F2gAquUyyC6M+XH7KHtXS952/D4qr6gW3YkdmSQN4ETrR8JLB8oFHYZIhbyr7Wco1Sv8kXdeAiTP0xt55y3jnFWTs+F0IbdM1yBqb7+Gj
 IaXH3DcF
 4oCVLE5Rbf7bY7hgOKTUZCzBPeC6pb6ZAlPikNTWjQF/oeJpITo+v9K38qqCZGlgqXQywpE17Crb2woy4551RaVNZl0x27flIZmwJmPFCUYqMlsN/qvNtccaByGF9iOoubQfUA7XcW1uix10YIG++fqFVciqjD0k0j5bPElO+X62LCt6dYTAhrt27lAhb4Zbz7D75yE/NpnowKUaJi6aGBHE+H7btySe5gYrJ8oBXzLTBUxqjteEH1D7+QoQYC6y9WOgRQAHWGnMPf2pMY4fP87NWEPoYwzRzO2smOp090yOnFVzxL25YKgiAJL/5aBEG8wG8htSxNpDkTpvj/MIudh/l7Zi1Ki4kcispzyyiZ8pcROwBq4TNfDE4hg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Seems unfair to inflict the cache-coherency drivers on Conor with out also
stepping up as a second maintainer for drivers/cache.

Include the library support for cache-coherency maintenance drivers to the
existing entry.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
v4: Tag from Conor (thanks!)  Updated commit message to make it
    reflect the added files.
v3: Add lib/cache_maint.c and include/cache_coherency.h
    Conor, do you mind those two being in this entry? Seems silly to spin
    another MAINTAINERS entry for a few 10s of lines of simple code.
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 46126ce2f968..b517f2703615 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24417,10 +24417,13 @@ F:	drivers/staging/
 
 STANDALONE CACHE CONTROLLER DRIVERS
 M:	Conor Dooley <conor@kernel.org>
+M:	Jonathan Cameron <jonathan.cameron@huawei.com>
 S:	Maintained
 T:	git https://git.kernel.org/pub/scm/linux/kernel/git/conor/linux.git/
 F:	Documentation/devicetree/bindings/cache/
 F:	drivers/cache
+F:	include/cache_coherency.h
+F:	lib/cache_maint.c
 
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
-- 
2.48.1


