Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F18D1D48A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 21:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 723726B0098; Thu,  8 Jan 2026 16:49:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CD846B0099; Thu,  8 Jan 2026 16:49:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5D16B009B; Thu,  8 Jan 2026 16:49:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 478FB6B0098
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:49:43 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1ADA81402BF
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:49:43 +0000 (UTC)
X-FDA: 84310139046.15.BCAFF32
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013027.outbound.protection.outlook.com [40.107.201.27])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1FCB7140003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:49:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=EvQFyc6k;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.201.27 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767908980; a=rsa-sha256;
	cv=pass;
	b=HFHvxmSw27KRV4TyeLsSo/FtvXR2FTB1TNMiLUO/wrMxOghTg+MRFVbZb0/eYQDX7+n6iB
	2+35BjvN5bcqJPXb/8P9+mYTer7/s2l9ieryRhPArNpvYKIZr/AbJqkPlIosEg9deqqCg/
	c5dqdNPMS6TAX7PkhvL7+pkGHKJF7v4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=EvQFyc6k;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of Michael.Roth@amd.com designates 40.107.201.27 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767908980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQAqARBm8/DgZ7okd3vkWHlf6BPdYt5c+i4z/JPQweU=;
	b=YodWwgWm5ZXn3uT05OUpk7lfkJHeowHt0LgeexN/JNEGzIgZLmUDJ1VovJDl/1ClxPK1Vt
	4NPbkBZJNKqVCOUqu2lrX0HsSh9qeaKkWdNOZhGIno5aQk8i0DOSpdv8k1zMjlp+fjqXAy
	0g5NRG5xIy7N+jAZIAKUQCVrfl1PQBA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uQqDO9HRblBcd7GDIYAr6GzoB9RCl+buLrwc9vhr3GhLr2S02D8DIjTrJMqD5RqOBm2byrHvArZh2LyK8A0cisaUaHGyYgGYFZ0nS/0mishUK3dOWXHEBHjCQAQ3fPJ69LocuTMU75hdttctWJpIVtR9+HcWRrxyVToD1yyhoJ3/vxfOdgAuij6qJHy1+lw1CR4x2edV4DMGYIXDR2lHXXbYt+JzKGjdR56ZRS5g5IO0efnYTrWRSP8gBjf3oSz78XfVgS2rgt3CI8uvMBD4Zl3j2jWsAndI/gP2iXyPyxcjqzeWVCYn8XZoi0TC+uHULBbJ/ql7woADNioNFPNIqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dQAqARBm8/DgZ7okd3vkWHlf6BPdYt5c+i4z/JPQweU=;
 b=XMlookRtkO2HBRT1NpiJCyNuoZP2mCd4eLIPsXq1ZQVM+iJimG7nyIKRALfaF1loriNH724qlE/5zlr4pj61lxCYx9yY8KkHMNDhsNXM5DOdxZ9jzhd8zaTqN1Lq1vSZA6NV5vrW25kQn3e/4ipgyuz05b/g2opJ1ZGNR8B5xq+nCFjSLXS0e3QaPqOcJrHG2YzD2kpdcr5IagRpsUXb3AZ4ilTzZQ1rZZtE0siX4e7TvIaMIttRqfByVE+sqWdyrOLgQpCxjLdftaYPX73Dmb7sLPVjOj9PGIoNBncNWUVb5k5yqJhmfmf5/zgu/8Kk+iu7HJ2DBS7w01IGxS4YtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dQAqARBm8/DgZ7okd3vkWHlf6BPdYt5c+i4z/JPQweU=;
 b=EvQFyc6k/fmAgMKAgNnrRU+kGyZGpsyX5YJrklTDw2uv4PGlKIboeYn8oCVL+hMvkm+Uc7Kc1pnLbG7K9h/LfkJ+LhSC3HCfLoFFgInOILmDOQ7hL2FOBsZhKZeBMb5RGRzgsZytH2X+ALnhzHxjLPjkia+xAdRtCkU84xFeSAo=
Received: from BYAPR11CA0048.namprd11.prod.outlook.com (2603:10b6:a03:80::25)
 by BL3PR12MB6547.namprd12.prod.outlook.com (2603:10b6:208:38e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 21:49:34 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:a03:80:cafe::a) by BYAPR11CA0048.outlook.office365.com
 (2603:10b6:a03:80::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 21:49:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 21:49:34 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 8 Jan
 2026 15:49:33 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>, <pankaj.gupta@amd.com>, "Kai
 Huang" <kai.huang@intel.com>
Subject: [PATCH v3 6/6] KVM: guest_memfd: GUP source pages prior to populating guest memory
Date: Thu, 8 Jan 2026 15:46:22 -0600
Message-ID: <20260108214622.1084057-7-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260108214622.1084057-1-michael.roth@amd.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|BL3PR12MB6547:EE_
X-MS-Office365-Filtering-Correlation-Id: 70b234a3-00fb-41db-b173-08de4effcfdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zZLBAOdbrDEYVEX4MnpSWDw/tJJK1TPKUIxtGGd7fNyiJWeiioYZ0RTS45KO?=
 =?us-ascii?Q?ZgzA1e/BkZ5yP4sMBf2Imn0u9fMXcUAGFryvyO7dO6JsRUmHPiJG3tOgCvnW?=
 =?us-ascii?Q?HBp6DJVXGW9KYr3thmNOTLtjfmNHzsYWxlDEe2obVZ+jLTjwZxNprWqwIoEc?=
 =?us-ascii?Q?vWfqpW07URdnMQq/yiLuLmPpEdHyFRR9Tqt2kjs3Jyqg98AzxiYbt0e6tIa3?=
 =?us-ascii?Q?f/qESHOCg7coupMjB8P91r/Bzb3qTYgprj3/PEGoC+/A6gZREdAJqaDp17Sm?=
 =?us-ascii?Q?1vNptfngkHristPsrowjFGEUGsFmMY2C+uxNuMkdgSERclcFi7hprflXqoYd?=
 =?us-ascii?Q?fkUPvvgGPw9SmHvtEWCGL+jj5xSxZ/wMQ3mam4LlqtjahDOQwgq+vQ46cbq8?=
 =?us-ascii?Q?wLsQmADoMK9MJvdGVVmWNkTht3y6SetS6CU3FGEnvAkIVaKZ4zlEpQl7bieX?=
 =?us-ascii?Q?nPwWA+G9UUSC0dnW1nXpaG3BeGacNkLkIFchY6prjFNmGZd3DylkD6+uh61G?=
 =?us-ascii?Q?3Nvd2Rv6s+mZe5Z4M8LUIt5zv7glqYG089fcbl+9wBfY1nvy5Z4+1iyXuPfZ?=
 =?us-ascii?Q?4TxQjprIKhP4wgqjex8sZG9n9ij+jAIXtACaY7TiTZ8tn/WBvmAdjX17BXWQ?=
 =?us-ascii?Q?EdsflgSxFLP10FQZhssjUOVfDBDTkyMYMAuWVhC+Uu5+HT7KZtRROLO940E9?=
 =?us-ascii?Q?avIKvGMznvnoDkwdTI5luWmB1FhAD3vYyqViGZqAnW82dmzS7wdIMkQDr4KU?=
 =?us-ascii?Q?hgK1XqgyUw3assxOugVUpoTG2M0pqZn5Wr0C7QfPVxXwT9G0N6+YLXPrXFm3?=
 =?us-ascii?Q?Mbsxn53JyYJdno+qWZh0azGIU6EKcm3+ui4H1ubLlPVmgEoYNolqsCdvEWxd?=
 =?us-ascii?Q?6ybthUrRgWF+xgwCif03hkAHOY72PwDdJWRFwzqJ0fzuouGzrRr5HOs522+4?=
 =?us-ascii?Q?WubuOXQplNKmQ0tW8yq6S2wIlhfTlf6VBLCpllA8eMVz67uuq1CllgPPT12m?=
 =?us-ascii?Q?mlsNz2Q2p2Bh7A7N8YGZSgYK0KNfrPyEHmluMPklk7ozb1RqvlUK7QuA2z1B?=
 =?us-ascii?Q?nfY8JM9ERhmOgaYSDrUu00AssKPj5fXmhV3WxYKZYJlYzoFApwBy8O5XJwgl?=
 =?us-ascii?Q?17G0H2RQihAymFgpfmPNUVOjA15zFBTyo9h5LcbnPpev9Y549T3iq/4gSawZ?=
 =?us-ascii?Q?ojEgBO2s9sjR/uI6S3ZIktxk4Bhsjao6IPFqFZfoFouT8jEsDxxUsYBAyfmf?=
 =?us-ascii?Q?lYB4JEkK1VZl9ehg6yMcSil3l7xSG28m2bqFk4HiTRHB/gaqDAvlE77IPG28?=
 =?us-ascii?Q?gX0pupaEuDH8WcWp8WfNAghtltdL+F/gX0A/gar9G78YA+ziqKuWsOb6/ur0?=
 =?us-ascii?Q?RWKPbqHpjfwFK2+jFWgzziJTVVhc2MAwiU22Hvn++rRc/t6fUFrh7XYhq/B5?=
 =?us-ascii?Q?MV4j/PePztOsWjBgUgt8UfGl4M4NrGgECZyKfABPylQYnpR6nB7A/8bEjgkH?=
 =?us-ascii?Q?wOcCHTF9DEWrtKCR9BEoiZetQpDFqYrZRaq7ejBrOvuEQGcXXx9t+XNVfXh/?=
 =?us-ascii?Q?KrZq161mT4P757YHByI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 21:49:34.3006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b234a3-00fb-41db-b173-08de4effcfdf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6547
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1FCB7140003
X-Stat-Signature: bxou5ejjxj66yoiuusrbdjx4nm48aosn
X-Rspam-User: 
X-HE-Tag: 1767908979-938612
X-HE-Meta: U2FsdGVkX1+/YsSAhVskuBHt0mlru5ody7a/ym7FJ/yVsHNKVnH+E9HlCVgnElvqmmLb/5j+q7YP/9NStLowc+I1f5+eFKLmfxJt3+aYH4EzfrIPwMaxxcM35M9ixo2ApA4Jv6LetouUpzS8bd7ksU14Aol1bTmbsTFmtJpNUDzRDF/2Sx/conKHcb4VPpmOeJgvMgeJ4NweBpT8FBgLxXnPMBDeM3Lsh5x59sq55qk2LWHoYAMVKTDYVpeh6ynsvq8tQNcd3LLzpgdtGGm+AfPTDnxtqcL5qQBS1a+8MF/bHZZzIQzOzlbEKmaRGBh9LxclVi2XQeNcPn35RfZzePAiTOSz9OBc4sY+gdVMFO085YtWMRDFrgSr5u3358V1skKyUsSW9ulG3ZvUTxMbJMRTcfXfIugv2zKOGBTo+8nf77kKn87Yz3tjvGdurT1ko5ITobtVPBOCJhODLVuxZMhKXTrWAghBOerdAjt4iMZozUkjU7PMbCUooDqOSKKlgoOKmTZ82E+s8tkPrIhC0YxHRVJZAXibY+ORygSoUGAJcbC9C38vv5SIejq3172q2gnqzaLRP/ibc7Znbuy6zqUoRrr9by9mwuAjySprGb6dEhMTNdiD6OfEuzb3jA5igem9EZfWR30HLNayy5orT+YK3gm1J9KtGVFFXO0p8s/ymU1TXResLj7rQEJTEoS9GDBYBZ1hIt4Z1l35NhQ1VAfIR5GH34JaMc/qDUdZNqxTbMFqOFwhKdb0leEAmd05kUSZY1h77tkDkh+o2IaynDgYtJsKfNBlmpKPj45bjqNw0O5iYObip5JgMVdQPRxM0EYYSaAwSEFHdZGaXCqsrYw4PqGXGtaJSJ7wtBMPl3zxFi8hQoavkU1SE0iTquh539JUAMaHmGGqUvQ5IulNEql11xI0pol7Gb+MT1xk6rkrVJcsW23lCkE5tpSKwuu+1qMSO/rIr8b0pnhda8J
 PYILU+bo
 ett99wPpeDSPk+n8ObFcfnqg8FD2GVZRaVoiP+F+dWMY/WZ2NhlASjAvszI5HS16A+3JH7/hP9Z4PR/RhpvvuzsE0JN94liSQCbipB/Xk2CbWQmPNL86dwmEK1Zh74LTzWX8W6G02u88I18668n1Vcp3K/kHV64/BAkBxRR9FSINJjRlz8ZFq4PeDKct/fkavnoPIV3gvNnBegmN+IIj539AoKRbLpqUt/opgJYV9APw0RBhEJWuonkF5wlBPSB+pzpVAdFKo38W8du8ycKaimMZZR20vwld/W1Eh5f9Ma4DEKAY/W0eE/M1SddIj9N0oSvGukJO+0k0e9c/wfAOlojksPZa7uCXh+xgu4Shk/atHQqxztC2EElSOqQNXgsMPBA1Z8SDcj8oINHCkm5WBcVPkhmDrsmycdacHIjHIUiidfveMhdNaz33pTUvJhtAbbConv16Ihee8Z7X04k3MJHA2PdTygXmTOUNAV9WbRGs9xdE4Zte3DfGl5FRwBJENMWCs5skx6I8rtHwqh2kTnZ4wTV1NY0nF0D3UZG2lOt2CBdPHCEK/2r6oCwHsddHRslxvdNdJRToeg15LwyVqCZJ5YA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently the post-populate callbacks handle copying source pages into
private GPA ranges backed by guest_memfd, where kvm_gmem_populate()
acquires the filemap invalidate lock, then calls a post-populate
callback which may issue a get_user_pages() on the source pages prior to
copying them into the private GPA (e.g. TDX).

This will not be compatible with in-place conversion, where the
userspace page fault path will attempt to acquire the filemap invalidate
lock while holding the mm->mmap_lock, leading to a potential ABBA
deadlock.

Address this by hoisting the GUP above the filemap invalidate lock so
that these page faults path can be taken early, prior to acquiring the
filemap invalidate lock.

It's not currently clear whether this issue is reachable with the
current implementation of guest_memfd, which doesn't support in-place
conversion, however it does provide a consistent mechanism to provide
stable source/target PFNs to callbacks rather than punting to
vendor-specific code, which allows for more commonality across
architectures, which may be worthwhile even without in-place conversion.

As part of this change, also begin enforcing that the 'src' argument to
kvm_gmem_populate() must be page-aligned, as this greatly reduces the
complexity around how the post-populate callbacks are implemented, and
since no current in-tree users support using a non-page-aligned 'src'
argument.

Suggested-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 33 ++++++++--------
 arch/x86/kvm/vmx/tdx.c   | 16 ++------
 include/linux/kvm_host.h |  4 +-
 virt/kvm/guest_memfd.c   | 84 +++++++++++++++++++++++++++-------------
 4 files changed, 79 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b4409bc652d1..0ab7c89262fb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2268,7 +2268,7 @@ struct sev_gmem_populate_args {
 };
 
 static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				  void __user *src, void *opaque)
+				  struct page *src_page, void *opaque)
 {
 	struct sev_gmem_populate_args *sev_populate_args = opaque;
 	struct sev_data_snp_launch_update fw_args = {0};
@@ -2277,7 +2277,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	int level;
 	int ret;
 
-	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
+	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_page))
 		return -EINVAL;
 
 	ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
@@ -2288,15 +2288,14 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 		goto out;
 	}
 
-	if (src) {
-		void *vaddr = kmap_local_pfn(pfn);
+	if (src_page) {
+		void *src_vaddr = kmap_local_page(src_page);
+		void *dst_vaddr = kmap_local_pfn(pfn);
 
-		if (copy_from_user(vaddr, src, PAGE_SIZE)) {
-			kunmap_local(vaddr);
-			ret = -EFAULT;
-			goto out;
-		}
-		kunmap_local(vaddr);
+		memcpy(dst_vaddr, src_vaddr, PAGE_SIZE);
+
+		kunmap_local(src_vaddr);
+		kunmap_local(dst_vaddr);
 	}
 
 	ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, PG_LEVEL_4K,
@@ -2326,17 +2325,19 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (ret && !snp_page_reclaim(kvm, pfn) &&
 	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
 	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
-		void *vaddr = kmap_local_pfn(pfn);
+		void *src_vaddr = kmap_local_page(src_page);
+		void *dst_vaddr = kmap_local_pfn(pfn);
 
-		if (copy_to_user(src, vaddr, PAGE_SIZE))
-			pr_debug("Failed to write CPUID page back to userspace\n");
+		memcpy(src_vaddr, dst_vaddr, PAGE_SIZE);
 
-		kunmap_local(vaddr);
+		kunmap_local(src_vaddr);
+		kunmap_local(dst_vaddr);
 	}
 
 out:
-	pr_debug("%s: exiting with return code %d (fw_error %d)\n",
-		 __func__, ret, sev_populate_args->fw_error);
+	if (ret)
+		pr_debug("%s: error updating GFN %llx, return code %d (fw_error %d)\n",
+			 __func__, gfn, ret, sev_populate_args->fw_error);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4fb042ce8ed1..5df9d32d2058 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3118,34 +3118,24 @@ struct tdx_gmem_post_populate_arg {
 };
 
 static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				  void __user *src, void *_arg)
+				  struct page *src_page, void *_arg)
 {
 	struct tdx_gmem_post_populate_arg *arg = _arg;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	u64 err, entry, level_state;
 	gpa_t gpa = gfn_to_gpa(gfn);
-	struct page *src_page;
 	int ret, i;
 
 	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
 		return -EIO;
 
-	/*
-	 * Get the source page if it has been faulted in. Return failure if the
-	 * source page has been swapped out or unmapped in primary memory.
-	 */
-	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
-	if (ret < 0)
-		return ret;
-	if (ret != 1)
-		return -ENOMEM;
+	if (!src_page)
+		return -EOPNOTSUPP;
 
 	kvm_tdx->page_add_src = src_page;
 	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
 	kvm_tdx->page_add_src = NULL;
 
-	put_page(src_page);
-
 	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
 		return ret;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1d0cee72e560..49c0cfe24fd8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2566,7 +2566,7 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
  * @gfn: starting GFN to be populated
  * @src: userspace-provided buffer containing data to copy into GFN range
  *       (passed to @post_populate, and incremented on each iteration
- *       if not NULL)
+ *       if not NULL). Must be page-aligned.
  * @npages: number of pages to copy from userspace-buffer
  * @post_populate: callback to issue for each gmem page that backs the GPA
  *                 range
@@ -2581,7 +2581,7 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
  * Returns the number of pages that were populated.
  */
 typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				    void __user *src, void *opaque);
+				    struct page *page, void *opaque);
 
 long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 8b1248f42aae..18ae59b92257 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -820,12 +820,48 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
+
+static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
+				struct file *file, gfn_t gfn, struct page *src_page,
+				kvm_gmem_populate_cb post_populate, void *opaque)
+{
+	pgoff_t index = kvm_gmem_get_index(slot, gfn);
+	struct folio *folio;
+	kvm_pfn_t pfn;
+	int ret;
+
+	filemap_invalidate_lock(file->f_mapping);
+
+	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
+	if (IS_ERR(folio)) {
+		ret = PTR_ERR(folio);
+		goto out_unlock;
+	}
+
+	folio_unlock(folio);
+
+	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
+					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
+					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+		ret = -EINVAL;
+		goto out_put_folio;
+	}
+
+	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
+	if (!ret)
+		folio_mark_uptodate(folio);
+
+out_put_folio:
+	folio_put(folio);
+out_unlock:
+	filemap_invalidate_unlock(file->f_mapping);
+	return ret;
+}
+
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
 	struct kvm_memory_slot *slot;
-	void __user *p;
-
 	int ret = 0;
 	long i;
 
@@ -834,6 +870,9 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	if (WARN_ON_ONCE(npages <= 0))
 		return -EINVAL;
 
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(src)))
+		return -EINVAL;
+
 	slot = gfn_to_memslot(kvm, start_gfn);
 	if (!kvm_slot_has_gmem(slot))
 		return -EINVAL;
@@ -842,47 +881,38 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	if (!file)
 		return -EFAULT;
 
-	filemap_invalidate_lock(file->f_mapping);
-
 	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
 	for (i = 0; i < npages; i++) {
-		struct folio *folio;
-		gfn_t gfn = start_gfn + i;
-		pgoff_t index = kvm_gmem_get_index(slot, gfn);
-		kvm_pfn_t pfn;
+		struct page *src_page = NULL;
+		void __user *p;
 
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
-		if (IS_ERR(folio)) {
-			ret = PTR_ERR(folio);
-			break;
-		}
+		p = src ? src + i * PAGE_SIZE : NULL;
 
-		folio_unlock(folio);
+		if (p) {
+			ret = get_user_pages_fast((unsigned long)p, 1, 0, &src_page);
+			if (ret < 0)
+				break;
+			if (ret != 1) {
+				ret = -ENOMEM;
+				break;
+			}
+		}
 
-		ret = -EINVAL;
-		if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
-						     KVM_MEMORY_ATTRIBUTE_PRIVATE,
-						     KVM_MEMORY_ATTRIBUTE_PRIVATE))
-			goto put_folio_and_exit;
+		ret = __kvm_gmem_populate(kvm, slot, file, start_gfn + i, src_page,
+					  post_populate, opaque);
 
-		p = src ? src + i * PAGE_SIZE : NULL;
-		ret = post_populate(kvm, gfn, pfn, p, opaque);
-		if (!ret)
-			folio_mark_uptodate(folio);
+		if (src_page)
+			put_page(src_page);
 
-put_folio_and_exit:
-		folio_put(folio);
 		if (ret)
 			break;
 	}
 
-	filemap_invalidate_unlock(file->f_mapping);
-
 	return ret && !i ? ret : i;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
-- 
2.25.1


