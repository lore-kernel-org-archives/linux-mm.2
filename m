Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA17D606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=heQXmhNv
Received: by kanga.kvack.org (Postfix)
	id C80D76B06E1; Tue, 24 Nov 2026 08:32:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58746B06E3; Tue, 24 Nov 2026 08:32:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B46F56B06E4; Tue, 24 Nov 2026 08:32:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 891A36B06E1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:32:55 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 252A0160B64
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:32:55 +0000 (UTC)
X-FDA: 85470103110.06.F8B3EBA
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013065.outbound.protection.outlook.com [40.93.201.65])
	by imf03.hostedemail.com (Postfix) with ESMTP id E706620011
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:32:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=heQXmhNv;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf03.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.201.65 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795527172;
	b=wn4ITTOdh7otO58qGL41mWgIgd+OSbZavA41auQROZBNWSE/5o2FWGSto0pkAsYFtmdi+g
	rAw9M3rgTu+jUWCyLXULYsP+Tz98PEndNz5ADhfkuQCRDzcv3LnXTPdPkTXDh+wsY0NWEE
	7ugZEeXBTyeE+TXaY6Ue/wFp3ViqlVM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795527172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jx6/iZupPImBn9d5Q6xuznU76VtEEfanhryYdrgn884=;
	b=PWO5gy1lxR75+GbGZ563Fnwvdyhfg/bWudy12643PI+POLK5bp66LRJhVGpUtHIJ4Ms4Zc
	1E07E+8Tb+sSTs9kLES7LBy3FoB/+gTJsu14+xu8xlRUsV0l8nYkozEsvClaKuAJeovkt+
	jHJ2+PVLuwrVSbQ8AdS1iz7hoN7VmqE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=heQXmhNv;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf03.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.201.65 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ypWJLPsWBXzKnu3MMSd/n7tf82KEaja+ePa359IwcUxPkbWnxvRQcR1VR92QoZbzdBkqWzT4t1fQk9OVHOROFXnIcIBMOS0RWIj1PDPu2d2JWzdRgCxD1R4bYFl25qVfLbILzL9EmYjnL2EdYC5P/5IIW7ty86oq3iuK+4e/NtB2ZC7ZF9p1t7bMtEMJHRdw/04yjtubZHh40oyzMB1RraJLUgQ0LU25rdBjhtAI4RkVrao/tlqedunwQf4wC2VhNFKruk1XupxjPHIKe2sgFkm7Wt1x1KDUnbnpOhz80n7VKgXd252q2Mv8U0YWOvx5MYknG4fXRIJd4/NWY6eJ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jx6/iZupPImBn9d5Q6xuznU76VtEEfanhryYdrgn884=;
 b=sajOBr/FxTqAV4O/V29uZ/5/TJIwhjXjOGVvEtrlJ/He+u4vySmP48M6WbFry/kXQsDNhho+h9raAfSsb4QS+FIl5F3X7pmvWfLPDnLP4hMKyglDpyaHyuikVRBaIJd+nsIojDwjewVLIidO/Bar8HlJZYhduBQQSscsu0lsskk0+qgx0Sk1qern+nN5WUv8HrHkbv+XI89jxIsLY0XOTO7sHI95jJ5SWDfhPebMPp1QlJU22JUDf3WucGJGIH6+hin2R6TfnyHxlbNlXZYMsqzcmIB+HHIy1sKLXxUnb8/X/wqwW0ERGnK5dWEdGzKCbewnu2jjp41+CMTn340mDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jx6/iZupPImBn9d5Q6xuznU76VtEEfanhryYdrgn884=;
 b=heQXmhNviaEb3b46Y2boY29By3ndZSzGM0nAlJ0Dt5UUfoDGTbSEuSOsO5JZ+JLOPAQtQ6PbSIlKJlvxzrlY/5McDfGReWxBdu37lXtHw6ycaLnljaZx3XCswkELhxb907DQlcvm6JFAFQseidJ6vdtlWyrFSvUF3em52cV00oA=
Received: from CH3P221CA0025.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1e7::20)
 by SJ2PR12MB8110.namprd12.prod.outlook.com (2603:10b6:a03:4fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Tue, 24 Nov
 2026 13:32:45 +0000
Received: from BN1PEPF00018547.namprd05.prod.outlook.com
 (2603:10b6:610:1e7:cafe::3d) by CH3P221CA0025.outlook.office365.com
 (2603:10b6:610:1e7::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Tue,
 24 Nov 2026 13:32:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00018547.mail.protection.outlook.com (10.167.248.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Tue, 24 Nov 2026 13:32:44 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 07:32:44 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 24 Nov
 2026 07:32:44 -0600
Received: from pankaj-M75q.amd.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 24 Nov 2026 07:32:43 -0600
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>
CC: "H . Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, <linux-kernel@vger.kernel.org>,
	Mike Rapoport <rppt@kernel.org>, <linux-mm@kvack.org>,
	<linux-efi@vger.kernel.org>, <Pankaj.gupta.linux@gmail.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>
Subject: [PATCH RFC 2/3] x86/e820: Allow memmap= in a kdump kernel in confidential guests
Date: Tue, 24 Nov 2026 07:32:40 -0600
Message-ID: <20261124133241.221719-3-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261124133241.221719-1-pankaj.gupta@amd.com>
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00018547:EE_|SJ2PR12MB8110:EE_
X-MS-Office365-Filtering-Correlation-Id: 6198d17d-073d-4ec3-7f80-08df4a2f6c13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|23010399003|36860700016|6133799003|22082099003|18002099003|261009223027099003|261022105027099003|261022075727099003|261026140227099003|261026121527099003|261028144727099003|261021121427099003|261102123227099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	YlUy3nrSYbkt78aWn00CWlEKtqERf7tX4W7TJfpCzzUJae4tVVIEGtXW5rA5hJMV2XCLEGeJOVJmJNgVDUWD2DIilJ0L5smBzpjzkn2JGQY/hzrXcsYwS5cYR3ec4YOn5syHZfFQv0q0eQilxmSaXuixd7IrMGrhMSGdiLBO+R7yTScnaGJxr3Ew3VuW07LIxyXRywv+iBK17UGFFykFSYr43rJ7E7d6dnAdzeD9qM1IKlUwmxGJG42iAfJ16JLifpaqVRUJsZJSxgZMwBp+V16J1VgH4oJMu9hmdB4+rQphT5c6SHWynEfQ6bJc0SUQc9/WHsq52+ISyKK5627FqFnEEI3gzbKxJKJyA6cQugr3bXQlYIcc0O8iVkj7gvNUrnOhis+Zr3Ll9urTXvYLP6lt77slrS6yvwPTBpEbpnq8cNgmcVpj40kMY4+HubPFq2BAfCeE1RCyCiFN+XF/0q7HWWKCBWInCpSurXt7GzNJ6iwwDdmefpbZbGe7yM0+VsZImjJEE6LDqQ+8fTND/VsCUvDRcE1JrPe7BC4cM7DjM/dvfjPzZc93J3vPrKMLND5gzdIxf74t3qJcCum2wIQgw3qeM7U3llDjiA9AsafsSRRkCnmEkATgdNfWqJxfgm4FsjenyRqkdqNFkEW7oI9h2AdVzOIwdj3ZgDdmjdUyvrH7DQjOy/xvBKzEPwNR6GURpy3BuBwAJHyVvE8VBg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(23010399003)(36860700016)(6133799003)(22082099003)(18002099003)(261009223027099003)(261022105027099003)(261022075727099003)(261026140227099003)(261026121527099003)(261028144727099003)(261021121427099003)(261102123227099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DrHkxlrEMLHwNamdYc52DTntJPW/tAdfdhyultOZ+Y2KEEGbcSuemVfsdfmtd/xWXRCk7PmFppZyVBfL+/uqqibLn+TRhUskE6i4DuiM8BFthbQVbpaNWx7mhfNV9ZsTdgt1b/OwL8GlwKHmTAQdOOxQJosPINKACePUpgVIqWEe2+qQjlWmXB4whxifU5+NjHYS4OJCt2skOVfhQpnDWZMN0PPXsAukZ3C3EsKf3Eyxbh3CYFo3mDo4RFtDlh6stBn1hLelBGghBZBGwT0Ece+GkBOSJZWoRNK0qJMWj8xIWCCkRvtwX4vNC57m8bSUsX7ke8zOLSe+t/O/NfQDzy3JiNlKgzeZWYhIL81vp+CItPrVxE5NaXQwyrKsrQi53YcQsJjL6WkmnoHWXeb8mvPQVsu1oFYsnExIixWhWF/kz4alRXJ8K3TBCTDsxo/q
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 13:32:44.6321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6198d17d-073d-4ec3-7f80-08df4a2f6c13
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018547.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8110
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: E706620011
X-Stat-Signature: d5a7a7jnebczegxiz38zr43sbyu39kpu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795527171-161254
X-HE-Meta: U2FsdGVkX1+krW5KrN8Vi+er3m/st/TZEby2OQqpf8cuefVhDbPA6ywHC0BxID41APoh4j14bKAdiGuiums/SB38kh8hDy4dqM/v6OramSIQ8aDcA3luBc966Oufor+2yfnGXlfyYudAmm6aOF6xeguUbDCvL8XNPrrlovhffMH2V9UlanhQm4WZa9NTK5UvdSrkEHP8nJ6+0waIZ9lv2ItT5t9Obrr6rTiWHMmA6iA3dCC+uJkwKDRWneRwSUVvGzs4vD8XKnrvvjFA27ROdCh1pqxXZEL2JffjugRQON+0Mb6MWpZkxz1zmLUO2W2T/tVk+QkhnNMkUlIb7qR9dWJcxu1colLmbbN1Gv3HOVH2G9j+oJgWAnQwFieuUx6eFyU9mHxlsevmug7fjHzREXYjVE0Bua+PB35fXR5Z+NaYY01f1RNEMzVY6NrG+u6fxa2y0NMloWrPFTEAkOX9FWI1y0IrA1C2oqgjyeSRYVTwwhWxEh77vXPy6qxmuH7qvy9Ma1PNb1CjIzEqhRrC56p3+T79tn8h20YgWLD9hw5+fiUtXirRk96LXSnyxtu6EQWYhLOQJ4PQPXEj+bWgvnSbLsI9pWPxPmA1ZM1Ro2CblfD4AcsIDgA6veQsilIkpyl97hUzqs08tq9PgylYStyeLapsXXXgUcBJ2zlMXLe3k3eOC8ykCW80mPfGOGLhg6oOs1yuz7ZTT2ORb2ZmI3s2LLx8tjAOypYoA9ot7FGQ9SkFR5YgtrvXxQAkqG2lbF8i03mdRUiCWu9Bge+SPE7FFEyii0rDQphdk6GF2d3v95IbCeOutUErwstuFMx4JwVWlFqaaXppHiqApPLm6+ncUNosJHTIAqkLGLw1mnUB5fhy4TMk8LwDtcSJes8FlTi+CoPnZuZgvu5w0yonWmb8ipu49Y1JXg3subxlP1h5Td7s3cFUjDB5IlA3iYKu7uUGJ922WVfRj9o5+Rs
 5V8fi63V
 HqlSsAGSBrWcYdmdCI4QJlV8KIZfW7ETtRl+DILHRwW81zICWLGrQOHeK5nzNn48ga/WsTg8PMpnZaglnUqApVO1kFW4IHy8INV6oVT08qXnHr2claFT2i00z/V5mSjuSeQ5s8V+tqzTxGdJGEqYCCkJVjIO0uq7S4klaiDrPmvgTbyKQMhPhASZDUn58lJ2n8AL4QJe147duAaPBOoZjr7ip95rwpWNuS55Aff6J+O1/pQcMgzm+IrvXiuZGSfCdJo7mb4Nmk1C2t67G3Vx2Hr8ttVJcIvOhBr+seouude9NveWz9SMNFUX4lK5xmCFJXVvBb6kuUy+kEIH7e2oGuLtHkemDa9XHHHRvy2Cfz1l/6Na8NVwaqHLxpj6SCLLtdndAg5M1+tcqzMc2pGJ770qjcDvilm+ic/TCPVhV1Lah9XYMLuoXZUEDSbnqb5xefpAM1rWb9Z4zMWf1BE0wkbbnjEZE2is/jTv6KoqxBMh+33jjUptxu3Ss3NLFySNQZELvixhSvcAxUV5fqDrQ/zxZ/x2/YHEP394LRwpJ85VD7FjYUq1jcAdwLipJVUeAhc1A6up7xk162ewJLBsPIOYsJB2VFg9QIhlP/AG8ZdQDi2J3OcT0cYtNTgQWNHmnyZCmxkAxdszZHG0aD5DHJJ7Lk6jV9msgRByoT4SPB/PLxxXTw6rNytYtnS18aiEzGGVngcAZTPoJvmMAyzG0z4SgXPzN75HqZuZkVk6nJzJaiC92UBU68xmDnFZhlnp5khqix70kQ1nupOGTizwva2/Y3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A kdump kernel can get memmap= on its command line, e.g. from kexec_load,
to restrict the memory it may use to its reserved region.  Ignoring it
would let the kdump kernel use the memory of the crashed kernel.

Do not ignore memmap= when elfcorehdr= is on the command line, which marks
a kdump kernel.

Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 arch/x86/kernel/e820.c | 7 +++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 142657be690d..9c206ad4369c 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -17,6 +17,7 @@
 #include <linux/kvm_types.h>
 #include <linux/cc_platform.h>
 
+#include <asm/cmdline.h>
 #include <asm/e820/api.h>
 #include <asm/setup.h>
 
@@ -908,9 +909,14 @@ __initdata static int userdef;
 
 __init static bool cc_ignore_cmdline_mem(const char *opt)
 {
+	char buf[32];
+
 	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
 		return false;

+	if (cmdline_find_option(boot_command_line, "elfcorehdr", buf, sizeof(buf)) >= 0)
+		return false;
+
 	pr_warn("%s= is not supported in confidential guests, ignoring\n", opt);
 	return true;
 }
-- 
2.34.1


