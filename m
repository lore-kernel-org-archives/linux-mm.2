Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E862C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 06:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6B916B0088; Wed, 12 Aug 2026 02:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1CC96B008A; Wed, 12 Aug 2026 02:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBDD46B0092; Wed, 12 Aug 2026 02:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 829E46B0088
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:33:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8C6216030E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:33:53 +0000 (UTC)
X-FDA: 85091651946.09.D613046
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012026.outbound.protection.outlook.com [40.107.200.26])
	by imf21.hostedemail.com (Postfix) with ESMTP id B58EA1C0002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:33:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Yr4yewez;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of nikunj.dadhania@amd.com designates 40.107.200.26 as permitted sender) smtp.mailfrom=nikunj.dadhania@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786516431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSL4avIfqWEiLYqVbIS+A9O39Fd/inVCJxK8XPe12ZM=;
	b=VBbT1UU3Sh7eW4nEZTcKB2LcrhwDcYX6/IL63hU/ES91yEqH6RQeLA94727l6VpTtVGTKl
	lHDz4m3EIYG2rJgeX3670ain9VCjHtBuMRpwpq5eIGkmLy1NWgLgOuLA7aiEw5edJw8moZ
	JxVwLitsjwIR6M7VBW8ceplr8Yy+MOk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Yr4yewez;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of nikunj.dadhania@amd.com designates 40.107.200.26 as permitted sender) smtp.mailfrom=nikunj.dadhania@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786516431;
	b=h7hwjaQ+OTOUdWrUQDLbjfWGjwK2uj12+wRCbjAQBnQ5BltY6TMUrgzcevH8v+BEfMoPPg
	T3K+ylPzwhBIVg6t4oHyyYMke42O1/XJmHJjtODE+BgoQjRc21WBDUhOCrl5YOXdu5eWuq
	ZMkjLgf5zqEgjiWra/5u05mDu98fvt8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K4v8DHzl1k3CwVhK+FV4zDBZnBhZsLFOqL1d5GYXY6Up4oosyUVGSFLgTFMgvO03/ttKZUzxu7DKC4suKowbENh8+wyKcAvx+ZHHxrAxjjf3dWpjp8fmb4iIC7T/9Cw5nwE/ccedMeQDmzFqkbKWfXDzFYE3rW9Xq1xTD19B53Z+MBvd3xfmTpjh8AWetQ08p7lwI4nqElgYBWwVa7L5+K+zYyVVGWGiSqIGJlIuDlbJCJ5WDMb+fvtFANNQzsxuSbewltttuIxvzTUUHSNBZ/MetaSZSo/xzyjEL8hHk+TehmkFdU5STKP4l1ce4+J4Vzvbejlyf2ZIJ9Z5kW6omg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sSL4avIfqWEiLYqVbIS+A9O39Fd/inVCJxK8XPe12ZM=;
 b=eBYqQNEGngKR7XEOt64K87oVHCflpPCcnntEmRQAN7HJ4Srlkmquid8Pqvr9XPg58sE/VNRc1Q3LhRi5mBHMGJRojHddPuuNGlse7duaw8qWk3cYEDWyOoYO/rrBtimtPUFX5L9zX9CqcJlS+XP16DKsXw/UanqS512yADBsvYw9o6EvPHSfHqI6klKADUh0HcDUwxKu4qfu8+zFAEtEEJz8xVvkAVZhhQtcee1W+GUgFOdfRuyJNk3ZjmPYZvs2E27xJh23fL461T9ZsCcUNwvKJtXdIsFPBZwFslKjZOoZiSygL9+7wV7rH1ac6KCGw2lMHZSeHzGwqzWcUeL7ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSL4avIfqWEiLYqVbIS+A9O39Fd/inVCJxK8XPe12ZM=;
 b=Yr4yewez4yLeDCTtf9fFrBRp2GS1f2FUiiZdhHqty82ot13jKFlV3iLnW/EDoCBIO2s2YTHRFa9gBqXzSVA0fKmZohHWPsXSH/wrx1C9mFYOYHmbJvAQrCgpRe2buQaslWeh61y8RT6VHpn0lFg+8Hxz66XlTPUueG6qTTiBncg=
Received: from CH2PR14CA0021.namprd14.prod.outlook.com (2603:10b6:610:60::31)
 by DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Wed, 12 Aug
 2026 06:33:42 +0000
Received: from CH2PEPF0000013E.namprd02.prod.outlook.com
 (2603:10b6:610:60:cafe::9f) by CH2PR14CA0021.outlook.office365.com
 (2603:10b6:610:60::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.13 via Frontend Transport; Wed,
 12 Aug 2026 06:33:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000013E.mail.protection.outlook.com (10.167.244.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Wed, 12 Aug 2026 06:33:41 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 01:33:30 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <rppt@kernel.org>
CC: <akpm@linux-foundation.org>, <anton.ivanov@cambridgegreys.com>,
	<bp@alien8.de>, <brendan.higgins@linux.dev>, <da.gomez@samsung.com>,
	<danielt@kernel.org>, <dave.hansen@linux.intel.com>, <davidgow@google.com>,
	<dianders@chromium.org>, <hpa@zytor.com>, <jason.wessel@windriver.com>,
	<jikos@kernel.org>, <joe.lawrence@redhat.com>, <johannes@sipsolutions.net>,
	<jpoimboe@kernel.org>, <kgdb-bugreport@lists.sourceforge.net>,
	<kirill.shutemov@linux.intel.com>, <kunit-dev@googlegroups.com>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-modules@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>,
	<live-patching@vger.kernel.org>, <lorenzo.stoakes@oracle.com>,
	<luto@kernel.org>, <mark.rutland@arm.com>, <mbenes@suse.cz>,
	<mcgrof@kernel.org>, <mhiramat@kernel.org>, <mingo@redhat.com>,
	<peterz@infradead.org>, <petr.pavlu@suse.com>, <pmladek@suse.com>,
	<richard@nod.at>, <rmoar@google.com>, <rostedt@goodmis.org>,
	<samitolvanen@google.com>, <shuah@kernel.org>, <song@kernel.org>,
	<tglx@linutronix.de>, <x86@kernel.org>, <nikunj@amd.com>, <bharata@amd.com>,
	<ananth.narayan@amd.com>
Subject: Re: [PATCH v3 9/9] x86: re-enable EXECMEM_ROX support
Date: Wed, 12 Aug 2026 06:33:15 +0000
Message-ID: <20260812063316.21371-1-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250126074733.1384926-10-rppt@kernel.org>
References: <20250126074733.1384926-10-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013E:EE_|DM6PR12MB4153:EE_
X-MS-Office365-Filtering-Correlation-Id: 842669da-6194-4e7d-18d7-08def83ba6ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|36860700016|1800799024|82310400026|6133799003|13003099007|10067099003|11063799006|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	edAdbBq3sYu2i6EcRZAxvWon9AX1MKUnUGDUj7lF9rd985mGTzQVlbziAjGTUS2lgJlqxV0/AW8soW9ZQQX4xN7KnFdjbVTwoqP968YxzuHSq8ZtZCBqdZTs/W5NNIOWWiG4X8QFnThF60+EU2X4iGtqjZumqaIGE+z14o06Ab3LU/4NfHe+omATazyVzsjwv7fO6cnI1mkIDqU9Qu/Gph5TjmX/gHoNvl7szLT5hqWkR7xJ7hpyAFAAJg0Fkz9s1r6ONuP+7Jnwr/nXyXSc/s8Ov5XbhrpOZlDNNuuo4REwoa+87YDWqqI4s0nShvgFvCtdOrnXoRFmMt/WJ6fjc/M3dlHfYiDNSHlUt1mvOPelziSDSU3sOF+SUyB1eNdneDCYONB/afxx7RNaoSmNabn6ENUCVIgGWqievUdjLsndatFUIxpBnwdk8F8VTsZggmfaPJmLytnWgJWNutDFAkoDYypbVLXv1fefSlOFPF7oMah5NinKAFG46g6cLunR/igmwwq7SMbPKDWTZtKiz0cySxvgAmDWKSukPB0ytPOQDtPc+93IHwRFsKP/gU8TiMgkavvSNjKOCRPoVwg+SENLhUlNnGQeYCYMHND+ZIwZgnRYiRXltKb2S+HoHUsu5utwr6uWRqoDVOoEn0twMdyMoR0OOfpQ9uNGOYYjzFSxUOuO5MDcyeCYyHQcRgfpcb0exZh/Yj4dd011v+9T0A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(36860700016)(1800799024)(82310400026)(6133799003)(13003099007)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Zn4SHCgRSEbaCHZYcQplgOm2z8XYtvyI9sMkXh42XxJH9iM3TX2xJFQBkx5ZX1vmHhFt3P8TopFK9t2NsiEejXDRWS0P/IaAk5cf5IIse/5yBAzJtNhxuHy2dbxPl3Xbn6emjxySA/TiRtBk/wYHXsyuJju8cfmKmHvSGsLBcwDeDMFko51PK/D6A5pIYIe/qku5ujgsKtzW6kdH21/fL35e1K5MClj77DKim3Dk/omwhFgLQdwhp/c1Z+QGFq3MsdRQWAUarpaJRE1Wut/kWdp/uEd61/JVogrxNvRAE5pHy8buVug/M0CwMxp45EHXqMSVagZ/aTfdoL2GS003nYbaZcyQg8FHO+Nynac0LICXBvkF6PBRpwmsuGnxw3WBTWV5/MPjN3mrXwsxZQcJp+nD/ZURvJNgf9YQv8iL9qYsBrVHgAPpB4ltgwc0frtL
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 06:33:41.7925
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 842669da-6194-4e7d-18d7-08def83ba6ce
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153
X-Rspamd-Queue-Id: B58EA1C0002
X-Stat-Signature: 1e9okdmihp6df88oii71tp4pgzx3agie
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786516430-983240
X-HE-Meta: U2FsdGVkX185q+IC3hWLBLhGAH3W7sTLkQbE/IYP0Hokj6VXMwU/A/n2Cmf4oMJtEBGq9fD9PuUw3uRllrYCiemfARNp2TJ2FODcOms4es7+29xuK6NcIuKI8hZ7hsfKhgZ0oekg2bWIrdRz1ej8L5CF9PmtMCzrYy5hPAxHyCihuOsB4/jQFu/nekXiIGpmuITS1StKeDHt6r0Ya3+zkeYHFTvBrTYghNBjSloQjWrT8wkjZf0wZqwY2W7X3LsNU129uU/rsprD9zAA0DwBwTUL//0cdA8Pkyb68tfJbKPo4E7ttvMtDHlRS+xq6BSrc5GAG94Jx9tBsyps4WQuC4eV1BcpHZaL4X8kDopx1X64blAoSGgWBXWMflLq+Zp/QlDOIJTU6843vJJkKw2AUIGxAaRY2Go9ezTHNEMhhB2hxsjJiSchgAu29vZBMvPVScgnt7Tk4nfpkisaFomAMP5N1/eso/vSAvYKcijuoTlFr0dwbPVaJFuzMojCYoS7YyAS5FPCdxgTcpgTAzheXUbO29HKPFETJPJN8+iPFydOiZ/O8MoU1KsyGV4WnSU9B11kVC9fnoKJ+HY9Gdb2Q2Tqx6wjK0HXzPfcDoAGx3PtYIeeg/DG5aw+U2gczye+XxJpD0fx2uLl4OIuVW/oRN8HI4WAke0FPMCytXRqjWtHyuhPu+pLDe/PfZJlOMpEA6igKpF4TCglFle4/0P3fp4JB5fvTy9fiPBFSQmKgcQcaUQI2FDJK+rPSsi/UbMyNFdE0OgNh/LiXp9eRkhjenCBJO3V0LDgj/G7VF23LZcF9YTdxkOXp+Ku5qJLCn3iCn9sY6ppCrc1jgL9dZKF39HLLAg1j+CWeSNGQsyu4WdeM3tWLjNiKxucdtyV+tI1yNB9g3dxLcR/pIxUTeIZSANNmrRlHvzYkgdZB6h1KABy3cBn2EmChq6+r3zjqNsluNm+oAaY7huyJI48tUP
 dVWdIP3G
 dhuc1HpVw7XyD13uwNkd2Of1uSp0r/iOD0bQE160hg6XWSjZ1QMFaifV0qwxVcHWD+JhxCk6VHN2TezbWIVsbZIm8EbFPEY+z+vrAs76NNusLDjtRG0bzShUnQWzcOM00iZIxX5QOf7ccmPuYkBX45iLx6fnbemGAFzCnPL8vbkaOiNqQ9ryaQFCFbW47WV+hLT4tMTRFqh2bCw0ue+osc5sYlPMlf3aLhKe9QC8pU4vd286Hs4z9RmR0eWwYY1vsXmJvovfgejUAsjx8JC1a1my1bE1J2l4hqeVCVq8419g6S8P2mdtM7Do6TX1hUvO7pCpVgfD4o4KdUcosjvMmVXguqkJyw/QfkLxZxCE8VTG2BcYZiCp4EJ59k3etpWKfZ2KOZjDrUKzz9Hpbj1Qx1CIjWvCKrhLrIOb6u0Ha+x4fanaBfq+0v4W/O5HZU/oRVPbHiZt6I4s65JdmK0Lh53ohx+6c6cQyQoJyjaIMiVvQg3JJ3LCyDmLkra8fnZetQ8NaJ+J+h4LmvIiA4dmGecd/WOjDxBllikHg1nkKRpwKGsF7NmUX21ISwxxe+jfFVo6FTEqSl5OiZPdgSkPfrrBafz4g72ZTm2xNC+GkPTRcPgDzwzxzrDRyzFs311cORa8cuUKUniHp+OzMBnf/B90FUGyWZOra2DlT6vPLzqNJ3KU58i7irXOPgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

A kernel BUG in __text_poke() is observed inside a Ubuntu 26.04 guest 
(v7.0.0.28 and also with upstream v7.2-4c5). Host is running on v7.2-rc5.

SETUP
-----

512 QEMU Q35 guests (2 vCPUs, 1G RAM each) boot concurrently across 200
iterations. The crash is seen during module loading in early boot.
2-7 guests out of ~100,000 boot attempts crash with the kernel BUG.

Reproduced on:
  - AMD EPYC, QEMU Q35 guests
  - Intel Icelake, QEMU Q35 guests

Apparently it was seen once in the non-guest Ubuntu 26.04 environment as well
https://discourse.ubuntu.com/t/failed-boot-one-time-on-ubuntu-unity-26-04-educational-mission/85300

SYMPTOMS
--------

Either of the below two crash signatures is observed:

Signature 1 — BUG_ON(!pages[0]) in __text_poke():

  kernel BUG at arch/x86/kernel/alternative.c:2564!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 0 UID: 0 PID: 741 Comm: (udev-worker) Not tainted 7.0.0-28-generic #28-Ubuntu PREEMPT(lazy)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)
  RIP: 0010:__text_poke+0x2a4/0x400
  Call Trace:
   <TASK>
   smp_text_poke_batch_finish+0x25f/0x5b0
   smp_text_poke_single+0x13/0x30
   __static_call_transform+0x10e/0x210
   arch_static_call_transform+0x5c/0xc0
   __static_call_init+0x154/0x300
   static_call_module_notify+0x144/0x170
   notifier_call_chain+0x62/0xf0
   blocking_notifier_call_chain_robust+0x62/0xc0
   load_module+0x5ef/0x960
  Modules linked in: ppdev(+) kvm(+) irqbypass ...

Signature 2 — BUG_ON(memcmp()) in __text_poke():

  kernel BUG at arch/x86/kernel/alternative.c:2632!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 0 UID: 0 PID: 742 Comm: (udev-worker) Not tainted 7.0.0-28-generic #28-Ubuntu PREEMPT(lazy)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)
  RIP: 0010:__text_poke+0x380/0x400
  Call Trace:
   <TASK>
   smp_text_poke_batch_finish+0x323/0x5b0
   smp_text_poke_single+0x13/0x30
   __static_call_transform+0x10e/0x210
   arch_static_call_transform+0x5c/0xc0
   __static_call_init+0x154/0x300
   static_call_module_notify+0x144/0x170
   notifier_call_chain+0x62/0xf0
   blocking_notifier_call_chain_robust+0x62/0xc0
   load_module+0x5ef/0x960
  Modules linked in: kvm(+) irqbypass ...

INSTRUMENTATION
---------------

The following instrumentation was applied to capture the page table state at
the moment of failure:

  In mm/vmalloc.c::vmalloc_to_page()

    ptep = pte_offset_kernel(pmd, addr);
    pte = ptep_get(ptep);
    if (pte_present(pte))
        page = pte_page(pte);
    else
        pr_err("vmalloc_to_page: pte_not_present for addr=%lx "
               "PGD=%lx P4D=%lx PUD=%lx PMD=%lx PTE=%lx\n",
               addr, pgd_val(*pgd), p4d_val(*p4d), pud_val(*pud),
               pmd_val(*pmd), pte_val(pte));

  In arch/x86/kernel/alternative.c::__text_poke()

    /* BUG 1: pages[0] NULL */
    if (!pages[0] || ...) {
        pr_err("%s: vmalloc_to_page failed for addr=%pK pages[0]=%pK pages[1]=%pK cross=%d\n", ...);
        BUG();
    }

    ...

    /* BUG 2: memcmp mismatch */
    if (memcmp(addr, src, len)) {
        struct page *page_now = vmalloc_to_page(addr);
        pr_err("%s: memcmp failed at addr=%pK len=%zu\n", __func__, addr, len);
        pr_err("%s: expected (src): %*ph\n", __func__, (int)len, src);
        pr_err("%s: found    (dst): %*ph\n", __func__, (int)len, (u8 *)addr);
        pr_err("%s: pfn at poke time (vmalloc_to_page): %lx\n", __func__, page_to_pfn(pages[0]));
        pr_err("%s: pfn at readback time (vmalloc_to_page): %lx\n", __func__, page_to_pfn(page_now));
        text_poke_dump_pagetable((unsigned long)addr); /* reads CR3 */
        BUG();
    }

Signature 1 — vmalloc_to_page() returned NULL:

  vmalloc_to_page: pte_not_present for addr=ffffffffc0697979 PGD=28242067 P4D=28243067 PUD=28245067 PMD=3be001a1 PTE=0
  SMP alternatives: __text_poke: vmalloc_to_page failed for addr=ffffffffc0697979 pages[0]=0000000000000000 pages[1]=0000000000000000 cross=0

  PMD was not a leaf, and the code reached a point to check pte_present() and
  finds the PTE to be not present. But in the dump in else case, pmd_val(*pmd)
  shows that it is a PMD leaf (PSE bit set).

Signature 2 — vmalloc_to_page() returned a wrong page:

  SMP alternatives: __text_poke: memcmp failed at addr=ffffffffc06fc4bd len=1
  SMP alternatives: __text_poke: expected (src): cc
  SMP alternatives: __text_poke: found    (dst): e8
  SMP alternatives: __text_poke: pfn at poke time (vmalloc_to_page): 3884a
  SMP alternatives: __text_poke: pfn at readback time (vmalloc_to_page): 52fc
  SMP alternatives: __text_poke: page table dump for addr:
    PGD 1ba42067  P4D 1ba43067  PUD 1ba45067  PMD 52001a1

  vmalloc_to_page() returned pfn=0x3884a when pages[0] was queried. The write
  of 0xcc landed there. When vmalloc_to_page() was called again during the
  memcmp readback in the instrumentation code, the vmap mapping resolved through
  PMD=52001a1 to a different pfn=0x52fc, which contains 0xe8 (existing
  instruction bytes). This is silent memory corruption — 0xcc was written to
  the wrong physical page (pfn=0x3884a).

BISECTION
---------

The following experiments all ran 200 iterations of 512 concurrent guest boots
with zero crashes.

  1. Remove "select ARCH_HAS_EXECMEM_ROX" from arch/x86/Kconfig

  2. Boot with "nohugevmalloc"

  3. Remove VM_ALLOW_HUGE_VMAP from vm_flags in execmem_cache_populate()

       - unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
       + unsigned long vm_flags = 0;

  4. Remove CPA_COLLAPSE from set_memory_rox()

       return change_page_attr_set_clr(&addr, numpages, __pgprot(0), clr, 0,
  -                                    CPA_COLLAPSE, NULL);
  +                                    0, NULL);

     Without CPA_COLLAPSE, set_memory_rox() changes 4K PTE permissions
     in-place and the PMD stays permanently as a PTE-page pointer after
     the first split — no re-collapse, no future race window. This
     confirms that CPA_COLLAPSE is a necessary part of the race sequence.

  5. Hold pgd_lock around vmalloc_to_page() in __text_poke()

         if (!core_kernel_text((unsigned long)addr)) {
     +           spin_lock(&pgd_lock);
                 pages[0] = vmalloc_to_page(addr);
                 if (cross_page_boundary)
                         pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
     +           spin_unlock(&pgd_lock);
         } else {

     __split_large_page() holds pgd_lock while installing the new PMD
     and populating all 512 4K PTEs. Holding pgd_lock around
     vmalloc_to_page() prevents CPA from modifying the PMD concurrently
     with the page table walk. This confirms the race is precisely
     between vmalloc_to_page() reading the PMD/PTE and
     __split_large_page() modifying it under pgd_lock.

     Note: this is a diagnostic experiment, not a production fix.

The experiments point to a race between vmalloc_to_page() in
__text_poke() and __split_large_page() modifying the shared PMD under
pgd_lock. __split_large_page() holds pgd_lock while modifying the
PMD; vmalloc_to_page() holds no lock and can observe the PMD in an
intermediate state.

What would be the correct fix for this issue?

Happy to test any proposed fix or run further experiments.

Regards,
Nikunj

