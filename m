Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7F9606A331
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=SoV2q9DC
Received: by kanga.kvack.org (Postfix)
	id CCD216B05B8; Thu, 19 Nov 2026 02:12:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4FD66B05B9; Thu, 19 Nov 2026 02:12:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F1F6B05C2; Thu, 19 Nov 2026 02:12:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A7B86B05B8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:12:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 084DD1C43E9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:12:35 +0000 (UTC)
X-FDA: 85451000670.01.A262F18
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012027.outbound.protection.outlook.com [40.107.209.27])
	by imf05.hostedemail.com (Postfix) with ESMTP id BD6CE100007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:12:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SoV2q9DC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.27 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795072352;
	b=VZhYHzXO7t56m/Z37o8bavqW9H6jP9feHsdBg+tLdsf/yVsC91uv5t0addwaRcaQGcUPJo
	CakDex/tFJAoek/CbaHNMrvprXxxlHSP0/aI178HoQ/F1VxzuipzBO9nd6m/M6979zC/M2
	BCegMLBbZumiAKZCeAqPTnNQ7XeZVo4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795072352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMKjG0R5C9cY8BZydqoRUAEpSU7luNrWagV4Iz6/IXM=;
	b=j6u1TzaXwWCja2nxPMuY2ZMh1qL4klu2Mh08Gwcn0oSATe5PEgeZuDUPxoHJ/Gr5XDdj/U
	Nu+5gHGwrC81AYBuTFADsCP/5txcpKctb6o+/xA+HnNT4j283S0oALskUhVr12Ta8rMzTV
	BUpSfN7H5ayaNieyKUpzCwBSpcSIyM4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=SoV2q9DC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of shivankg@amd.com designates 40.107.209.27 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dlk39xB3zlPAv9kEpsRYjy8t+nNRZt2qbPQZ9XzAPx/o5220FT5ou/k3hptsB8VPEd2RxUmyNtcjEIt3KM2i+PuBDRx+PWJ+RBNYhAhrsP6h3h5P906MVwraDyE55iCjFQN805rrrS239OZ9Q1YdtmNXdJU14WOEu7iz3mnL6X9cLeEbvQt6L+I9ZeItM7XWJSDXWFUF52zPvKfOwNEEtokqFG3R/ke92MYX8Cpz9Xl2AKAyv9sNorsklS6gEY/ZVOMZYd/QRDTSMq1CyLJh9q7tKgVTFjTcGUK/jjXAWfduTH6PT0Lpvj+Yqp5uzstft/5KvpM/RCh+NXTeDffUTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nMKjG0R5C9cY8BZydqoRUAEpSU7luNrWagV4Iz6/IXM=;
 b=C+68qaGaeN2HdXlFVyUheHzRyM2dkVILzaW1TO+gyqleOBmu6Q4Q3f2YqqkAGD9QnwGAOVOx8TCCurfLxoPCxZIxQyE6tUB0vBKBZ/RuQydihamdlwfVgRlJNZQM0Gjy0NwRmdNNsyQOxPAE8U/P45Sp2BRsBSedDblewGBXXE4sH9ttMKUNJ5zcDv6kOF9JOQygafveKHxNi6CqWytYkigbI3Yd7TqsHY5Le73fSE0tQWvFNjnd8Z1yEmRrt+Ih+d+aV4PJ+WLPm6NeFLWPy7UB4YyH7q/5UUtRy++lQeOqMX54tBLWxFSz3A6kW3VEZK9St9k8RyVgO+S42xZfHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMKjG0R5C9cY8BZydqoRUAEpSU7luNrWagV4Iz6/IXM=;
 b=SoV2q9DCfSfIwSUZxZrgb93LNh64NrqzxnILmN5DzgUFeXes+eHEkpaOvw8VRCTLb0DcO6yNnlZ8AcdzRhqY0F/xHTqzwN4BIBJ48gPNgo9sKBRZGkDU2UNgJ2eYjcMGTQSxPf2acTQVsJnAtUmUezNW0dK66joBrlgk0I8ntOc=
Received: from MW4PR04CA0088.namprd04.prod.outlook.com (2603:10b6:303:6b::33)
 by SA5PPFE91247D15.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 19 Nov
 2026 07:12:22 +0000
Received: from SJ5PEPF000001ED.namprd05.prod.outlook.com
 (2603:10b6:303:6b:cafe::45) by MW4PR04CA0088.outlook.office365.com
 (2603:10b6:303:6b::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Thu,
 19 Nov 2026 07:12:22 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001ED.mail.protection.outlook.com (10.167.242.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 19 Nov 2026 07:12:21 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 01:12:15 -0600
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 19 Nov 2026 07:11:57 +0000
Subject: [PATCH v2 2/8] mm/migrate: handle retries in migrate_folios_move()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261119-migrate-refactor-shivank-v2-2-f4535bd0bc52@amd.com>
References: <20261119-migrate-refactor-shivank-v2-0-f4535bd0bc52@amd.com>
In-Reply-To: <20261119-migrate-refactor-shivank-v2-0-f4535bd0bc52@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, "Byungchul
 Park" <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	"Lorenzo Stoakes" <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Yiannis Nikolakopoulos
	<yiannis@zptcorp.com>, "Bharata B Rao" <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Huan Nguyen <nhuhuan@google.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Matthew Wilcox" <willy@infradead.org>, Hugh
 Dickins <hughd@google.com>, "Vlastimil Babka" <vbabka@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795072323; l=5206;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=3cFyeDx15OK/0bIWW54xS5UBpC92AWVTpMK1D0Y7CY8=;
 b=13Fvod3tNOBi1qwgUEODvKEMEFZffCbSWX/NGBS92hbEqYAIbOjgqCsmhLHmOUOLUCMUhcMBU
 mrg4ICgpDT8CTkgGtW1zI8MjGmRXlaBqIbo+zRXbrulCBNdoTY3Vjr9
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001ED:EE_|SA5PPFE91247D15:EE_
X-MS-Office365-Filtering-Correlation-Id: 981ee6fc-69b8-41bf-0c4d-08df460c749f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|1800799024|82310400026|11063799006|261021123027099003|261026121527099003|260925022911599003|260925021311599003|260925021911599003|10067099003|921020|261022105027099003|261021121427099003|261026140227099003|261102123227099003|56012099006|261009223027099003|261028144727099003|3023799007|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	p4vZQMJ6KyomwMdNjoDROmMQT+9edGB4dkFITv3fixjhr1lPAlTgUSe1QVLIkXWJpfhh6kKdcC6LNfRLOYYkPj61i7ofnfHmjeBDV7fZhKLNcLZWYSKukD3z+yO4EqGFqssYTOhgTEhUs6XIBHrmZ2Rl/lq6fKxE4RbyhoXI4dGAARRVqM3D2e3/pRaingnnakfeKZp/3dyeRfZsfJRwqYHVQJ2Sg+tLP2sfd3uU5a1ci5sxwNfQtLhSvW7gaFp4dwI1tOXBIht8PJM972gyjKnJLXeR6jCpr8/RRq4YC3EPIUWmv+/SLH6F9/3Tpa1XcK2d6JJ7HEg/ZZYX+CtYs8p3X52WGfK+4x48MAennU7RiOXGB6nBv9A5OfFMaAIutcYLmMGpbApiPasyK2pNlGJ6to6UUHb/sgqEUHQzEW72YI/caeZOKwtVmwY9bgl+gXcibmsv+zh+6iYqjlfy1ZnV/K96adMg6l24GouoZRY/3FSmgZ1lM/iH3Nd/XbvDnQ6kCzgsMPxr8zW0E7s1JwovBjEuG2MlIjr/pdv4zgNS+QSf1YoKjlKKzs9ay/Gr7XHSMB4whxJFkW2DH4plqijCB/bcAgTaAiqIKyIqSggF/0razYqiuvo5sxiIWdPm/a4FVOold53yix2JLHzivDqqpcenGi4EU2wtAPvyL2mO4kCEsb7aexsK3EHLi4KKN5G61hJSOwLsFPQyTK89Fu/ErOTZMpiEGMSCcQ5TfWYvM2zNc6LpKxU446sddyej
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(1800799024)(82310400026)(11063799006)(261021123027099003)(261026121527099003)(260925022911599003)(260925021311599003)(260925021911599003)(10067099003)(921020)(261022105027099003)(261021121427099003)(261026140227099003)(261102123227099003)(56012099006)(261009223027099003)(261028144727099003)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CekwpVlPUlgWgi3XtKxRX2aFsr23XxiyLYyhzL4tNE5aTM681UX1anEX0wdGmWWT8WmaJi0fUbOk2uttdvEL5Ryg1Yy75AnVuptSqTTy7Jm05XP/E1Mn6Q/RrjSv0nkGoa0wwxepLKc5nB4HGalIkhIZmHnuQlvkF/NdM0cMGGwSr2+Q5RZqbbuR2z6PSuAyFlC1J7mfOPwWsy5Y6BXmWudmVpLtRWZePeRM1mdkGqszjRMTLapTKeObE4dqIZPa2FtO6uylvOWpwUI/CkTqHySjNjwNs0e+VZryFTJSnlaK/fJW/alsfIB2U8K/Omj7+K31rWI1iYSV+eaABTBZnkqKQ4KMRM9vaMGPM5FfqfFFLLLnOwwMJ8JySc+VURWCjbepIEKjnzpv4xl0PXVK4QOiMjTcvY98lgyekoHKps0lv4Quoq3S9+J2RD3yAoQP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 07:12:21.8674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 981ee6fc-69b8-41bf-0c4d-08df460c749f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001ED.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFE91247D15
X-Stat-Signature: dgdq15j9ccteskgaz79ykiyawafh479t
X-Rspamd-Queue-Id: BD6CE100007
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795072351-419013
X-HE-Meta: U2FsdGVkX1+5isnqY0BSCERTXV21PRNDvArS5Kk1ON05z+MexyiHVk5a/ZJgxE2NyMUDkB/ZtW0n/IeAcEN403+7cHXCayGAJbgz5O7u7JaQHfPFduE0HtIbekmogQBn3q+fm89QRu2G9TZq2cWClAGm05QXDxu1XXMJa1DH+0971XHkXg8cyLc4d6IG3c3/Bm7vBvWGB8JXdUa6/PDZ1vhHmGVnQnZ9TRdWSico1JYnEfu+TAI40Hxr7v00hNMlFyfEb8eyhp0iKQJ7YP0XXcKD7uTLXtB+qkdUVb0PgRu4xteLw4YWT10FD2ZS3HrGHp1LmVB5qR2VgHX5KA0E0XBubLUGsVC/fw70yXLOsbalgUgt+PDCuZ4Jns2jiSAeWAKp5RONjFn7oIbQAgs7vJBmiGzzxNElWWxtNsfbdklE37hM02611XWdYJ94BWhvqhZEt7o4e3kgirCEZHk5dW0xL3qs8qO1niwJz/VXwihYONXQdMvSJ3GYREVx6dyCYWp6OhxmvLpprkUhOPDUwBkpvwMVDORqAG5QgcHCV7I8IrKE2A6bLxOQCEuz9RxXVN3NttrN3aOWz+Fhl5bmH98uqe2fnPcEIhU19CQRknrB6fIr0G7uP7iPAZmUFapbpKAKSpCPhBB1P2jNU46sAbRA/XaAceUPR08oTO5e/FujUEKLynUEKdAFOqCftT3oW62SuawhFqwkXGw0/fwD1xpR5QsiO0nrTf9xVpsII7tyUrRDZAPF3clVwo28Y1P5PiyOTZRVTFDJZ58NphYaJAPak/bumlcigsE1iid7rmFGgz/oZUphjamQ35Xqc92uDruMycnQ7EJmhJwSZOH1ZorNiRYcVbrrpNTe5duzTs/+1SVQlzEn0FH+KGowzl9PVHZj6UevqUwSmr2HmFnhZ3jXSuoqM8Ny8AkPJAtRLPeWxxrVVkxJ97CKdmzsmS7ARU+PZEJPD6bWlvP6AV2
 JPXfkdj7
 Gv9IvqpW9+JeWphI1Ii/REQeGPgTc1KtXyE1qtDIYcToPqlxVSPztLjoXr6EDNVefFdyq3e1hTVh7MDE6gVlK4YRofoRGOMXAsQmEr3heUKYRRTa4KtDfGx2EtkKNfD51I4AH6YlSz20XFHz3Mmj4/U/m6876vWiypqR28l2so/9tgRDdBc5Dq/508G7RtxcLWjUp7JMj5uItpQ9gIh5PMfwf/gKcgqGcPN32PG2pTGB5kgd2viLr6Z4M7BIcZhglxfWp2PZyvhTuIGP/hFBCSpdr0SfkDHW9EcobMpjChjIAtgD/ufjn9uBww1qu6PWyEUc8Akh49EwlRMGe+lpG+pikWsbYptRIrWhgQLY6eXpzD7RgtGP9iDEVbCveoiptyRlzraQbntHDcdPTlsf3275qOx9jsPauces+/RP5xSaAoMOanemurKKrIMU+PViDGyC9WeCC3jz+lMzrZs1e1CG9mrvepiL3ECgjn+Cb86ZrbPPOpkLhR+uDsbTQ3Kk4J/xqXwiXzEhxxdXvaOoZTzVabePxxWd+OT49oO4i/Xa9JFYZ63MTWBjBZm/wkseXPnTK+eZ1s2acjcGwrSRlx4bdb+NMS7QVgTfNduJbxQBj3Lpd32pHqXwka3VhNVKFWDnKQAjVYO6C4aZzOXQ1+T9md/LCdF1/ojlT0CwHRFrPigOJzeycAm8d+qic8xEbu+olbrmEdbde7C1A/+QDOFoAMbomOASpboXdVc6gpCa8Q25kTSNPnz9yHDMh98jIj2LG5Hu97y8fWJRTB1uFMGla1Nr0UcS9mzsPean5Y0obRhIrslFONgKDk2sv78PcyMVeujgq9szEM88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

After extracting the unmap phase, migrate_pages_batch() still drives the
retry loop for the move phase and passes its retry bookkeeping to
migrate_folios_move(). This splits the move phase across the two
functions and requires several output parameters.

Move the retry loop and its bookkeeping into migrate_folios_move().
The function now takes the number of passes and reports failures through
@nr_failed, matching migrate_folios_unmap().

No functional change is intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 109 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 54 insertions(+), 55 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 3f1639516623..1f4ddd23cea1 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1757,56 +1757,71 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
 	return nr_failed;
 }
 
+/*
+ * Move each folio on @src_folios to its destination on @dst_folios, retrying
+ * folios that return -EAGAIN for up to @nr_pass passes.  Pending folios stay on
+ * @src_folios for migrate_folios_undo().
+ */
 static void migrate_folios_move(struct list_head *src_folios,
 		struct list_head *dst_folios,
 		free_folio_t put_new_folio, unsigned long private,
 		enum migrate_mode mode, enum migrate_reason reason,
 		struct list_head *ret_folios,
-		struct migrate_pages_stats *stats,
-		int *retry, int *thp_retry, int *nr_failed,
-		int *nr_retry_pages)
+		struct migrate_pages_stats *stats, int nr_pass,
+		int *nr_failed)
 {
 	struct folio *folio, *folio2, *dst, *dst2;
+	int retry = 1;
+	int thp_retry = 0;
+	int nr_retry_pages = 0;
 	bool is_thp;
 	int nr_pages;
-	int rc;
+	int pass, rc;
 
-	dst = list_first_entry(dst_folios, struct folio, lru);
-	dst2 = list_next_entry(dst, lru);
-	list_for_each_entry_safe(folio, folio2, src_folios, lru) {
-		is_thp = folio_test_large(folio) && folio_test_pmd_mappable(folio);
-		nr_pages = folio_nr_pages(folio);
+	for (pass = 0; pass < nr_pass && retry; pass++) {
+		retry = 0;
+		thp_retry = 0;
+		nr_retry_pages = 0;
 
-		cond_resched();
+		dst = list_first_entry(dst_folios, struct folio, lru);
+		dst2 = list_next_entry(dst, lru);
+		list_for_each_entry_safe(folio, folio2, src_folios, lru) {
+			is_thp = folio_test_large(folio) && folio_test_pmd_mappable(folio);
+			nr_pages = folio_nr_pages(folio);
 
-		rc = migrate_folio_move(put_new_folio, private,
-				folio, dst, mode,
-				reason, ret_folios);
-		/*
-		 * The rules are:
-		 *	0: folio will be freed
-		 *	-EAGAIN: stay on the src_folios list
-		 *	Other errno: put on ret_folios list
-		 */
-		switch (rc) {
-		case -EAGAIN:
-			*retry += 1;
-			*thp_retry += is_thp;
-			*nr_retry_pages += nr_pages;
-			break;
-		case 0:
-			stats->nr_succeeded += nr_pages;
-			stats->nr_thp_succeeded += is_thp;
-			break;
-		default:
-			*nr_failed += 1;
-			stats->nr_thp_failed += is_thp;
-			stats->nr_failed_pages += nr_pages;
-			break;
+			cond_resched();
+
+			rc = migrate_folio_move(put_new_folio, private,
+					folio, dst, mode, reason, ret_folios);
+			/*
+			 * The rules are:
+			 *	0: folio will be freed
+			 *	-EAGAIN: stay on the src_folios list
+			 *	Other errno: put on ret_folios list
+			 */
+			switch (rc) {
+			case -EAGAIN:
+				retry++;
+				thp_retry += is_thp;
+				nr_retry_pages += nr_pages;
+				break;
+			case 0:
+				stats->nr_succeeded += nr_pages;
+				stats->nr_thp_succeeded += is_thp;
+				break;
+			default:
+				*nr_failed += 1;
+				stats->nr_thp_failed += is_thp;
+				stats->nr_failed_pages += nr_pages;
+				break;
+			}
+			dst = dst2;
+			dst2 = list_next_entry(dst, lru);
 		}
-		dst = dst2;
-		dst2 = list_next_entry(dst, lru);
 	}
+	*nr_failed += retry;
+	stats->nr_thp_failed += thp_retry;
+	stats->nr_failed_pages += nr_retry_pages;
 }
 
 static void migrate_folios_undo(struct list_head *src_folios,
@@ -2034,11 +2049,7 @@ static int migrate_pages_batch(struct list_head *from,
 		struct list_head *ret_folios, struct list_head *split_folios,
 		struct migrate_pages_stats *stats, int nr_pass)
 {
-	int retry = 1;
-	int thp_retry = 1;
 	int nr_failed = 0;
-	int nr_retry_pages = 0;
-	int pass = 0;
 	int rc, rc_saved;
 	LIST_HEAD(unmap_folios);
 	LIST_HEAD(dst_folios);
@@ -2058,21 +2069,9 @@ static int migrate_pages_batch(struct list_head *from,
 	/* Flush TLBs for all unmapped folios */
 	try_to_unmap_flush();
 
-	retry = 1;
-	for (pass = 0; pass < nr_pass && retry; pass++) {
-		retry = 0;
-		thp_retry = 0;
-		nr_retry_pages = 0;
-
-		/* Move the unmapped folios */
-		migrate_folios_move(&unmap_folios, &dst_folios,
-				put_new_folio, private, mode, reason,
-				ret_folios, stats, &retry, &thp_retry,
-				&nr_failed, &nr_retry_pages);
-	}
-	nr_failed += retry;
-	stats->nr_thp_failed += thp_retry;
-	stats->nr_failed_pages += nr_retry_pages;
+	/* Move the unmapped folios */
+	migrate_folios_move(&unmap_folios, &dst_folios, put_new_folio, private,
+			mode, reason, ret_folios, stats, nr_pass, &nr_failed);
 
 	rc = rc_saved ? : nr_failed;
 out:

-- 
2.53.0


