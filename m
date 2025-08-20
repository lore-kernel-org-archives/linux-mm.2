Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA9BCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21EA8E0052; Wed, 20 Aug 2025 06:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1C28E0003; Wed, 20 Aug 2025 06:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90EF08E0052; Wed, 20 Aug 2025 06:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB228E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:32:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1EE1D80553
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:32:01 +0000 (UTC)
X-FDA: 83796770442.17.A5BFB22
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5F2DE40005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:31:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755685919; a=rsa-sha256;
	cv=none;
	b=pB0SbKEA23JYfwxfAadwp5orX15QGIBgdcTU4LlcixXP9MOiXEA430fgiKILJ0S6WfvpRH
	ixTszixh2cxfjXYQI3I80OopqkgM9GqgeBrlL4UYCOwm8rIB7bcDh3lcMvPUp+KVigWIM+
	fk1P5mHzf5Nr+Bj8OAxWP11vSqqOEKM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755685919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b2DcBI1bMgoVInefU/iXVbUVgVuOWez0fkUcdSx3JFY=;
	b=HMoCeum2j+Yn+U5eCVMpJfbKpvtO8CZOhE/bkB9vYxOLDIkVPBDryzuXF44Uem3BUnyUFb
	LcVPu9gqob4nHRPDsHKBEYrgPA7M8TLPoIRfqemtiouOgYqNZZfYUC5Mtk1k4rp4kzRv7s
	oa66rM2sDSOuZAKsZiMDf2SuEVHeMjs=
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c6N4G31SBz6M4q9;
	Wed, 20 Aug 2025 18:29:50 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id C69FB1402FB;
	Wed, 20 Aug 2025 18:31:57 +0800 (CST)
Received: from SecurePC-101-06.huawei.com (10.122.19.247) by
 frapeml500008.china.huawei.com (7.182.85.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 20 Aug 2025 12:31:56 +0200
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
Subject: [PATCH v3 4/8] MAINTAINERS: Add Jonathan Cameron to drivers/cache
Date: Wed, 20 Aug 2025 11:29:46 +0100
Message-ID: <20250820102950.175065-5-Jonathan.Cameron@huawei.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.122.19.247]
X-ClientProxiedBy: lhrpeml500005.china.huawei.com (7.191.163.240) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5F2DE40005
X-Stat-Signature: jbn9togkm186boyc7oibbzhwe4h4y9sr
X-Rspam-User: 
X-HE-Tag: 1755685919-59497
X-HE-Meta: U2FsdGVkX186rJScgrsSY3Iz7XNLL2jsUpRR0gOZvN8ZO/RTTwGdja/J2OjpXpgKbxfCPE8Ixi8KGjInfAAcZH3xSkYMt57YsNar0kzWw6ENUhq5dsAU4UfBs7s7G+gMdrKy/xuZTr17u3mMxapoxP4rNj8Pkn+GatpNPkkERfNAKrVdkuiD/NpSbUKMx3F/4ZrQ4zNHD0+4wBpcpd540MJprpQKTI4OUIrgyJr4y6yc5MCDc1giUNDKnw2ashwAdpThxKZg2QeByGxn7x8wT189hfBX2Rtqb1yreLIzRp1KLArGcV9F8zJ8kM8SR/d9tGwCxh1E/RljDMwaoloxMCtPu0QFeTWtPdVQw08mOP/AV66zcyzx9JRsxKvq7bP6tnTJw64loo4x/iUE7hjxqgA14WBMKumFhdKaua+ZUVBS8vdbx9F17DfSWoLd8Z8pCHYNXMS3nuyCVd5tXgVNZlxkde2a4YUYZSgp1KjAo0IEGIN7qzU1RWd4878WbQXjaEvw4CfLIMHBi3MQZh1G4ahRD5EGlh1BtD5si0tUCna5iBForvrdkDhR+L9oMS4z5vOFlckJT+Tx7w4RgyUj29/aU41EdSr6+Ib019qdMk/YtADoGIF99VSmcj7alxccIySM3JFhfcNRA4eInECU8poWJJ1FajkDV+JigvKGgYcqwva61XatzbxX/TRksayBSym8J1XVinsBOZiZQ41+vJ8v4fyNzNGVQLP46lFHTG12Ub8bNFzMR/WV/Xy5sCouvbCpLjKuJsRM34KF/ggfC88GY8+qJIVgJlJaVsaVkY/UAzPTm0QMgP5AN4D4X1IpnbRPGytKO94Ylr6UiRd/V2yMYb7ElKq1FMq2DCAUNmYpvOFiv926pCHIRrGsGpITpSVOY7Z025g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Seems unfair to inflict the cache-coherency drivers on Conor with out
also stepping up as a second maintainer for drivers/cache.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
v3: Add lib/cache_maint.c and include/cache_coherency.h
    Conor, do you mind those two being in this entry? Seems silly to spin
    another MAINTAINERS entry for a few 10s of lines of simple code.
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fe168477caa4..039d10ded9e9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23967,10 +23967,13 @@ F:	drivers/staging/
 
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


