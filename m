Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D34606D815
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=gYuTBWBu
Received: by kanga.kvack.org (Postfix)
	id 895646B05B8; Tue,  3 Nov 2026 11:25:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C506B05BB; Tue,  3 Nov 2026 11:25:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7830F6B05BD; Tue,  3 Nov 2026 11:25:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2CF6B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:25:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF3C4C0464
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:04 +0000 (UTC)
X-FDA: 85394332128.27.FEB5206
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011040.outbound.protection.outlook.com [52.101.57.40])
	by imf28.hostedemail.com (Postfix) with ESMTP id B2AF7C0009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:25:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gYuTBWBu;
	spf=pass (imf28.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 52.101.57.40 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793723101;
	b=VXiakew7VAlIfS1rNalQbxIfIGhG6Zq/Za4mDgEmhJsdoQaP+Ocjw3Pbaq6FR3Rmsy/E0h
	Y8RHLGRfOuAvq9CXhQMh5D1pLJLvSZP80u5VYgxPJXyjEBZ3pDvMjoy7cutpltjPrqVp7Q
	mFF2RmV9XpQyilraUzTQMvY6zdk/5oY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gYuTBWBu;
	spf=pass (imf28.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 52.101.57.40 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOOqBcSjsbY/uSk3m/QRiRLOIA01HChh1VM1B6chXCk=;
	b=MPWGno64bvl/huqme3rc7Gcv2QxKQZJ/j4/o74FPjYIj3/ffLBmgjwTdkTRYwH+ksItaOV
	CZY0u09/tvtSulwk/jOYjD2GKDcY4WMWHETq+B8gN6P8UWAZW7+lvF2Pxu91c84sP283Rs
	Nh9yKf/Kyokt8y58gRVPR1QIlDf7nCc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nR2BhCw2PlTq8OQfiww+VN7UccnA8ywGW4sXPFVkjJgf4iK+746Uyk5CApPW3RX1gIiNfJlNj1L0t8+s9+jSivL3uVZDmPoMDKXrlpzgO+RmTJmIHefCaXRTXuv0xZORJ3f3J7ezMQO2D8kYjKLzKSMiatY80O7FAfVka11ohO4Mme84Wmf9N6FloGmErV+HXN9gTCdgXyfg8YtA7Ji9Zh8BHsef1BAFo2HbycRbMnfxiBnA3bSqyRR4ToxJ1+JSCbpgtdKa1zeDqUaq320r/Qa0w56WDqeYCIJKQxhPU2VCT9dDJflL5bJSSGF0gwbUMRuThLx75xM9UzMo3F2Drg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOOqBcSjsbY/uSk3m/QRiRLOIA01HChh1VM1B6chXCk=;
 b=jAkafMbrODkh1VUIa2nAfZjz79lYm0QnfPOFcBZXXepjSJU4KzaccbnwmEJ0Yz6cFJTNqoOk+THI448zgiu89pg5G9ZEV3hpddD0HWSNPIwEOOY95Dn5zNTMzms3kXeSQDfYPSozNHCTjvGs3xblljijC9T/8p9Oidf8W5fdl2wCgpGJDhuNVZ9N9NMlI/C36hIVVoT6SQUaCqT+5nL1o4qVSgMcOpxJRJMyLgQq6ZZDm6nxKFG/dGvFsnuzhCrRH4ITVjeoAyXPooizPzaUkB+szRImWDqccmOkxc05YRPW7u93mhlVYFoOH+Ih98jGvv9uhL97imbEyoq2LCXGEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOOqBcSjsbY/uSk3m/QRiRLOIA01HChh1VM1B6chXCk=;
 b=gYuTBWBujDogFMnmv95L1Z3p093mbcZWrpEYIhdRPcuWfBy7Zu6vT32h5Gd0EaXdGNAyOhD9uDtE+98U7PIX400cgXo+Eeky4OccvjuzBlxab8oGz7ZLKqyr6SYNjemFkh0Pztd8x7WaMAlFdPRduFONZ+088C7lRfDfYsFCrj4=
Received: from CH0P220CA0030.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::28)
 by SA5PPF8DEAB7A29.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 16:24:52 +0000
Received: from CH1PEPF0005BD5E.namprd02.prod.outlook.com
 (2603:10b6:610:ef:cafe::f) by CH0P220CA0030.outlook.office365.com
 (2603:10b6:610:ef::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:24:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0005BD5E.mail.protection.outlook.com (10.167.244.247) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:24:52 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 3 Nov
 2026 10:24:52 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 3 Nov
 2026 10:24:51 -0600
Received: from xhdradheys41.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Tue, 3 Nov 2026 10:24:46 -0600
From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To: <robh@kernel.org>, <saravanak@kernel.org>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <m.szyprowski@samsung.com>, <robin.murphy@arm.com>,
	<baoquan.he@linux.dev>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <iommu@lists.linux.dev>, <kexec@lists.infradead.org>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 1/4] kexec: do not place the next kernel in a fixed-address CMA area
Date: Tue, 3 Nov 2026 21:54:26 +0530
Message-ID: <20261103162429.2053989-2-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.44.4
In-Reply-To: <20261103162429.2053989-1-radhey.shyam.pandey@amd.com>
References: <20261103162429.2053989-1-radhey.shyam.pandey@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD5E:EE_|SA5PPF8DEAB7A29:EE_
X-MS-Office365-Filtering-Correlation-Id: 69808556-f2aa-43a4-10c9-08df39c6fd77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|23010399003|36860700016|18002099003|22082099003|921020|56012099006|11063799006|261022105027099003|261009223027099003|261022115727099003|261028144727099003|261102130727099003|261102123227099003|261021121427099003|261026140227099003|261026121527099003|10067099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	w11FTgRXCywOPfZMJXpjgaf+KrEh4R7TB2Q0k+JMOOcpdX8JLvugDaBu/CPReF7coe4IWWUrDaKUF6Dd9FGMfDTf6qeFFbizZAZpIvxQzdv321e2GRwT92jKu3dsTO4LPHwmWxYy70sRc4FCEcto67xG/tT88Z7vK2Yclo7K3roVM6FppKrlTGmkjMqS/3qIJhods9bUiM6XwPqvGapFGcIZx/XCOOftOqJUmTJdD4rqw/yauftt9R88qeb4scWE/BmKy96XzfBYMgb8AcYw5SJ93RQSXbaNYWkCE+W+jWsKEG0RQe0OHKdVUAnQ/fV4/xLaMjkxOlSoIV3sZ5wIQfU0ZXSlm7rdVIjjdCT6dv8B+g0nrOLQNKy8aUY9q75Hrd+vYeWt48ZdGDFVKdshptSheGLHianztK1VH/uPYqr704JeqTfA7FRR02Ogw22zXk4JeBQYp5OGK3gDGaikMl60tLSzOFXZtbTvxsfrPokKhYhQVfuspzHHuYqKIMKigYs/RVlk1cDlde06bV8KeC7cefTciE7Uhp+M93DC7+DqacasHiLUztuzxjIUjzSSLTB5SaS95QJGhS1e33GB5F4zW2sL5DICFIEOMxQdWdLr/cJ8Vug59PQRaxbTZnu1B3hXbMzarzFWbox3dE8UYCmMdqQNpitbfaVUbdnY+BOD+h/+xbr6KfAoEVM8JvqmdnYD/gJdMwhdYvouvzzQl5HX54D0lISz2na8iOyo42N4UiGOAQsOx7CfGpgDDrVI
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(23010399003)(36860700016)(18002099003)(22082099003)(921020)(56012099006)(11063799006)(261022105027099003)(261009223027099003)(261022115727099003)(261028144727099003)(261102130727099003)(261102123227099003)(261021121427099003)(261026140227099003)(261026121527099003)(10067099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yx32ppD7490Hv4LXRa/cJk7A4kouWQeEh5WmwZeBNpJ1oSI1pd3O02ZPEZx28i6IqRCPlb3Jc0EJJa8gk0LGmFnxg9gnRK6GVIjqoQgCxeAKDM0d1dtCrGkG+jQ5a59nuIxvWVkZB9sknQhNB25iZRKtGTkA54hHWcsceLk8lgiq+7oAAO+CrRV1oT9SB9gxq2gy2MAdt1ukitI/Fb0ZYavAZ0SrbGrgiPo9pU/SIOnu8U1BtixaS1wJ68jF3fwYeAsoUkEoN2LaGy4fLLa8uAEcN/c1GTR+typP5b22wNEdJ1UbfOPSLKp0e3NjL5NHEdbXU33nQ63BApPghry16++d3N8XR5Vuw3eQKVnevDAMXKJHiQ9EIlccIYpqJjZ409MUitCBCuC/xFAOMIT6OfGBKG4EIt+R7/RlgqJ/DEOEV6Tz67wntsiRhPNQhHCN
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:24:52.8094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69808556-f2aa-43a4-10c9-08df39c6fd77
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD5E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF8DEAB7A29
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B2AF7C0009
X-Stat-Signature: zcgikz6mh8muf18tgmemynse6wwh8kft
X-Rspam-User: 
X-HE-Tag: 1793723101-426730
X-HE-Meta: U2FsdGVkX18kobsET1r25QhDNdiTp5E6Ga7tUqyJp1mf1tBh7hbPgquekJaamAiWDFYeQLehI+nAST0g9FWHeaGQqvx7/a2gJpjO8ExudL1kvXF0x7NtIKOES7Vxha6qZrzSORlin8rU/N5CjvaRAueAckOFU2bmYA2exMSeSU1AJcfAB7hlGIJC3511gkZEImzIwSIG5TbEDsV6BSrkm5Avjeth8xbESWZd6UFVmi7iIyOA/azriZFLn0t/B5EVsxKB9qppRJHor+oUDFCgU5xAX7PHWa9h/X/LhQL/zoaYj9wIctfe7F7StjdMoKOWB9twRpvhSzPJ/wkww2X3Cgp2GSv3Nv3Q4U/9amoYFCYBvUN0DQpS08Wo0RbS4q+duwiBIIIxrNbGfw7EkdWorpNuV6wmC5+QKqotTcRgbnz0ZFL9iZmm1ra8l27gmV2BU44+QTeNcXMiVhnKG4+mHSLbmSTjipxt2tEKGRvZZEwHKWm3YwjVtw+cJJmd8QxVQ2ZXySnW2PBJS85MnCLbnWAlOBBv2uH7BnNvZ4w72TcdfvsOgpmAdkH3Z2/AQMuA+JJeeMkuI6cOLGuObCvVkk4vsJz9bHqu7eTDxjD/YVRH1KhgpJTvmrS9muLyBcOQyLqzWXlj2gUs8+3xF7MSC96s1GsDpBIMenKaKdQcjjjXqolzJ+EViObUW0SW0hTnLXqfYu+Y7cpBAdgvWOWptOfjgm2Y0PgJ1RyQZPZY5WFemAqEYmxvY3qnyRljqgy39C+cr0yLhfxSt6WbMcysGq+qwR1d4AfK/9xviJUAf3aMUaKxXq5lTeLPOaGSVwkTEZXifIEPU4yLzMQNYFm0QOWfahiS1ZDWs9nuV5JlVyt+Bx1HbT0NkCcZWQsVulDEbJrObUn5ZoVtZUj+bs2DAZs3zfo3hpoS6GKY5sqSe+C4NJfr8iXZEyEYArsa9/Fwt1Z4VOOtNxnsvJfTyIK
 FdfohNTA
 X2tobKGxugISMWHqqOmEHZkErzj2i/+uKEqaboe2caq7Wpul2zycqyzUabr5eXsoC8Ua5T1dK6q3TeKXPLcvIdxrv8f2Tj53gK0uVoCxpPsBc9fTmlhQEybimYR55XWV0XdDMMK+U1BwKHO1SjshK4dNkrrUxsPhxtFBC7NjTZR+PLEd/KQkzuAdwTbCRvIfoIwsSLqw6ZM9X4T+fIzDOj7cFFyHkppA8OoYs3M/P1YthZidB/sgPSuEoFAIXTx1Z46N8E2WaCBzldCl/D2B2mo3dscztq/upRqReCHNOlGlZiNMhBe6FPTjynVSFpIKzFGfHVZrt6pitbiUkxM5cwWjxYF6yd83leoLTgVDDyETDNG8rKuPXm4Q/x70BulFOmvivMzKvVv77Uj9fYdB4DvEmsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kexec_alloc_contig() takes the next kernel's destination from the default
CMA area and the next kernel runs from there in place, which is safe only
if that area does not exist at the same address in the kernel being loaded.
For a device-tree area it does: the loaded kernel declares the range it is
executing from as a shared-dma-pool and cma_activate_area() frees its own
image to the page allocator. Record in CMA_DYNAMIC_BASE which areas CMA
placed itself and accept only those, letting kexec_locate_mem_hole() fall
back to the memblock search. "cma=nn" works, "cma=nn@ss" no longer does.

Fixes: 07d24902977e ("kexec: enable CMA based contiguous allocation")
Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
Changes since RFC:
- Use CMA_DYNAMIC_BASE flag instead of CMA_FIXED_BASE.
- Drop Pratyush reviewed-by tag as there is implementation change.
---
 include/linux/cma.h | 10 ++++++++++
 kernel/kexec_file.c | 12 ++++++++++++
 mm/cma.c            | 16 ++++++++++++++++
 mm/cma.h            |  2 ++
 4 files changed, 40 insertions(+)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 8555d38a97b1..d4683a4ff3cc 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -61,4 +61,14 @@ extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
 extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end);
 
 extern void cma_reserve_pages_on_error(struct cma *cma);
+
+#ifdef CONFIG_CMA
+bool cma_has_dynamic_base(const struct cma *cma);
+#else
+static inline bool cma_has_dynamic_base(const struct cma *cma)
+{
+	return false;
+}
+#endif
+
 #endif
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index b668ce8d68ee..763dee85558f 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -28,6 +28,7 @@
 #include <linux/vmalloc.h>
 #include <linux/dma-map-ops.h>
 #include <linux/kexec_handover.h>
+#include <linux/cma.h>
 #include "kexec_internal.h"
 
 #ifdef CONFIG_KEXEC_SIG
@@ -691,6 +692,7 @@ static int kexec_walk_resources(struct kexec_buf *kbuf,
 static int kexec_alloc_contig(struct kexec_buf *kbuf)
 {
 	size_t nr_pages = kbuf->memsz >> PAGE_SHIFT;
+	struct cma *cma;
 	unsigned long mem;
 	struct page *p;
 
@@ -702,6 +704,16 @@ static int kexec_alloc_contig(struct kexec_buf *kbuf)
 	if (kbuf->image->type == KEXEC_TYPE_CRASH)
 		return -EPERM;
 
+	/*
+	 * The next kernel runs from here rather than being copied out, so it
+	 * would declare this area again from the same description and release
+	 * the pages holding its own image to the page allocator. Only an area
+	 * this kernel placed itself is safe to use.
+	 */
+	cma = dev_get_cma_area(NULL);
+	if (!cma || !cma_has_dynamic_base(cma))
+		return -EOPNOTSUPP;
+
 	p = dma_alloc_from_contiguous(NULL, nr_pages, get_order(kbuf->buf_align), true);
 	if (!p)
 		return -ENOMEM;
diff --git a/mm/cma.c b/mm/cma.c
index 9ec1d1fd5dff..9c53b2b70dc8 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -55,6 +55,19 @@ const char *cma_get_name(const struct cma *cma)
 }
 EXPORT_SYMBOL_GPL(cma_get_name);
 
+/**
+ * cma_has_dynamic_base() - was the area placed at an address CMA chose?
+ * @cma: Contiguous memory region
+ *
+ * An area without a dynamic base was placed where something outside the kernel
+ * said it should go, typically a device tree reserved-memory node, and so lands
+ * at the same address in every kernel booted with that description.
+ */
+bool cma_has_dynamic_base(const struct cma *cma)
+{
+	return test_bit(CMA_DYNAMIC_BASE, &cma->flags);
+}
+
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
 					     unsigned int align_order)
 {
@@ -519,6 +532,8 @@ static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
 	}
 
 	(*res_cma)->nid = nid;
+	if (!fixed)
+		set_bit(CMA_DYNAMIC_BASE, &(*res_cma)->flags);
 	*basep = base;
 
 	return 0;
@@ -708,6 +723,7 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
 
 	cma->nranges = nr;
 	cma->nid = nid;
+	set_bit(CMA_DYNAMIC_BASE, &cma->flags);
 	*res_cma = cma;
 
 out:
diff --git a/mm/cma.h b/mm/cma.h
index 68e574b0f951..4703e0958b01 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -80,6 +80,8 @@ enum cma_flags {
 	CMA_ZONES_VALID,
 	CMA_ZONES_INVALID,
 	CMA_ACTIVATED,
+	/* Base address was chosen by CMA, not dictated by the caller. */
+	CMA_DYNAMIC_BASE,
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
-- 
2.44.4


