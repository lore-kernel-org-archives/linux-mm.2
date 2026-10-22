Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C76606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 08:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=olAiWblh
Received: by kanga.kvack.org (Postfix)
	id 993276B02B9; Thu, 22 Oct 2026 04:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96AA26B02BB; Thu, 22 Oct 2026 04:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859376B02BD; Thu, 22 Oct 2026 04:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1196B02B9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:15:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4E8540778
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:15:05 +0000 (UTC)
X-FDA: 85349551770.29.251E0E7
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010010.outbound.protection.outlook.com [52.101.201.10])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6EE2C120004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:15:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=olAiWblh;
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.10 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792656902;
	b=l2snZxblz3OrwbM88aWRv+Gx0eMJYbxyUQMvSRwDt5qJ5pHkx+HQ6j2Svc3lkHiGi1n1nq
	xo6Z2XoDrS5roVkw0QIc8jCYv1mTIHxc5xOqVbx/m5j2DQ5D0OuZp0hL95ZGSXnyNm7cFv
	8xL5Qayiz5snVZOieyXG5/FH11KU/XU=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=olAiWblh;
	spf=pass (imf29.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.10 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792656902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4Ggmb2T35F4YzKlY/PinzTKbGL1YnxGJMdUAWJDf+VM=;
	b=AGaoKCUBZFHDAemY7qxkQkSG2w0UEOx4lhgrAuah6Y+c++7zZ9wZgaJjGrj9cAf579Io+b
	mb32fOBQGYLPVHhT/pyJV6NLpM26EbAEaaTPvglW0BSf+aCyskNy2mpy7CNUQmJx/ZHa3h
	K2BxqFid+9uEiR8VK+P0+chw9AhYVic=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e4TUtgdaFMYIsTZl2fdLgFrGnyUtoeYIRB6IBkD/g4Mk/pkooKCvQeISCBhlqlH9qn14p2y7wacXErEY3453EmPuna75157u8yoC06qcYVS7wZMadm5JIW3sm6RpWursk/wcg4AWpvMl+6iBoYDJmtAYOl5BnKJxcd2lYiUfBgLtP2j5V7BJHay/FujrZQSyrKvb8uinvHu/csvD7aCk3wP/oblX2nl+jV93qsajRYOLj1Tk6a9Bu/g/j7vhPmP8z+pYQ5N50iPBxtD+gCw/nS+AXESRIZvV/QxMmx36xFYOjeanABc44E4DnoUjm2QPz3qirZk+bCNtbmp7nh3FtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Ggmb2T35F4YzKlY/PinzTKbGL1YnxGJMdUAWJDf+VM=;
 b=kFApM48DPw7BtrvHlWRWb0uLcnGDDaaY4LQjrYBnyZMCku6Xy5+UdX+XaNfmPqlNdCOK6JyPF1XY+DwcCRenV6KiB2EbCf5DEw281f4gYGLUiMZLrV6IFzlIBezneRQJrstGhSdVBlyKGg8to0gXmWyErpqRN880siof5X/Q1W3EV9umepGKcE83fyJuUX+OYXAPawYj42vh20aHUwNnqC6EssleHqPFCwOZzvLrHTvBFWw7TJl4wE0e1b6Nhy+mIUw6ipog0+fQFAzHovhLr/laUXDo823J92TXBm2fqMhWlkjhFX82bBBqzPCl0KjGkMKoAzu1Gg4WBwvwjmFdNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Ggmb2T35F4YzKlY/PinzTKbGL1YnxGJMdUAWJDf+VM=;
 b=olAiWblhIu4iFZ5UswhiaoZT79tG1Ih2R82DljTc/9kCCN3IqoxxfWK0QBRRvOM5Ppo13geVsjl0+7tZPbP0+nZ4bvZFOZHm5IgQmdB09JcuP6JoC2JKVCawrPaQcgla5k/n+qS5Z31JolBDOT4v7qtD/uLiEFz/jxor4DJHFRk=
Received: from CH2PR12CA0029.namprd12.prod.outlook.com (2603:10b6:610:57::39)
 by SA1PR12MB7104.namprd12.prod.outlook.com (2603:10b6:806:29e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Thu, 22 Oct
 2026 08:14:56 +0000
Received: from CH2PEPF000166C2.namprd04.prod.outlook.com
 (2603:10b6:610:57:cafe::e) by CH2PR12CA0029.outlook.office365.com
 (2603:10b6:610:57::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.16 via Frontend Transport; Thu,
 22 Oct 2026 08:14:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF000166C2.mail.protection.outlook.com (10.167.244.228) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Thu, 22 Oct 2026 08:14:55 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 22 Oct
 2026 03:14:50 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 22 Oct 2026 08:14:30 +0000
Subject: [PATCH RFC] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261022-clear-pages-batch-v1-1-13d3bd0b876e@amd.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDAyND3eSc1MQi3YLE9NRi3aTEkuQMXXPzNHOj1DQLA4tUEyWgvoKi1LT
 MCrCZ0UpBbs5KsbW1AIWWIh9oAAAA
X-Change-ID: 20261021-clear-pages-batch-77f72ef808e4
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Ankur Arora <ankur.a.arora@oracle.com>, Pedro Falcato
	<pfalcato@suse.de>, Peter Zijlstra <peterz@infradead.org>, Borislav Petkov
	<bp@alien8.de>, Bharata B Rao <bharata@amd.com>, Hrushikesh Salunke
	<hsalunke@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>
CC: <x86@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792656890; l=5625;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=omSR5vmJ3yaZhow23seaqvygXTzvIQppRXnLIVoQevg=;
 b=TbA2pHzTPLdcYKXt/huIbOy/SL2K42TN2agRWDrtNT4dnQBPzMIky8sNuBuoH2LlthruI4dXH
 Lx+Bpyclt5+Acsf3tH2AtiiLXROClXwnaNJF5u456zS3cUGq4RWXF5q
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C2:EE_|SA1PR12MB7104:EE_
X-MS-Office365-Filtering-Correlation-Id: 582cd918-f9e7-412f-a7fe-08df30148e61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700016|82310400026|23010399003|921020|261021121427099003|56012099006|5023799004|261009223027099003|11063799006|261021123027099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	nXwBOfUNMv69hvvq4jCyIJXUtLjETF74lbqq8f7DpYuE3QF4YTHbnOLXwMSRlekNWe/D6+66w+kaP/D/M4bIDnmqauLZONje2hOS2QVsjXEIjjR/4COttnzVM/wrHB/nT4I8wle2h/5KjRcyy8FDAYtaJOVEkXoQXiiH2JAABGWhdMlLf71nipL2l2F3DdQ2oZiwSd0IreS01VflnmJ6P7/fbByKGdE8GdxC20aSnWRVp18U1GZF8Ds2fd/oGqHwztwyet8fuaOsWGidYJB9Z+vhBicO7EDpEbesX1zjP5FcY4EHTrzg08XTeyEULrRZ0AvZFgruktcm1QEf8cy4NafXUy62C8xaPg2vtxyOS76D0jdPgKKHOXhPsywPXBPhS0TB4qBAJVCSaKu/iz52Ik6/IgsmRte+zflR1YtgvCFUMbFU0UJ6SN/yYt4+p5XebraRdi5pYvXcETnH1RsZCubkjG4FcSVdO+LVmzoPVCoPQnB3Eir6vqYqZ4QQXtPxWwTWfkOqKAdimJst3twtc/PSWGBHHkr25a2QOMXEOcZmYMzlDRP72tKLGirIVkBgUo0aMe0gxcBTolhGeQt61lxg65i7it7T1dtv3MxRVgGhhFwypVtCRua7jYaEj7lgD4fEUShMkHCymHyHUpuB1QZMzyBgaeNQeqGAI4fxA48h+NbDGavOdIBoOJOca9uVE7w9Pgdd8r1RnF5jRi3T+g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700016)(82310400026)(23010399003)(921020)(261021121427099003)(56012099006)(5023799004)(261009223027099003)(11063799006)(261021123027099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kcLsiIJ92ub+8RM4KcDI/3KvX0Cj+ifYkMmdZ7rD1g6AHzuiDrSFlCQE893+/dzt42XSbK2XNGwr4QnnS1e5wtStQMb1umUrQf6lJC1S13gxDz1jF5tXW/PJfbQm9ASFBajupvkUNpGQotPD63enup+NHQQty5rHsseJiwIKyVERMuw6LNMn0s4PiALHTWZqDBWI3vamB2ZYAt30wmh8Kv6oQRov68QXdewJd2q/B1aOqGUGN2XRlaXghvbPK72TUyWgSXXDkj3eZX9KBBXT6dPT8LDwHsCGmi0q6aoy+Bt55jU4sxSLd0AMxXNwxP1FzixrmkMPm2eZask8nvnqGZ/Ny1RNU7jbj8iruwaodsm3JAUuj8/sbbUVyAF8IzPSUU4D6hJYK772H7F82vI6gi/x1d04QKLuhk/72JPOOGCBKATsjKgG27d6V81xwIWN
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 08:14:55.5570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 582cd918-f9e7-412f-a7fe-08df30148e61
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7104
X-Stat-Signature: dg5ri9tkzmts6cnemw9gf8mkaz4i4pwq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6EE2C120004
X-Rspam-User: 
X-HE-Tag: 1792656902-155641
X-HE-Meta: U2FsdGVkX1/I3iEIbjlUAsq++344xsU4TarW8CjSkj28WcCMHAj9G88Uq82EhBxs67vebOKlMHjXZOAiK8sN2IAPU9JTxRIyvAht+dyhe31g3vj6BcglN24e+Kua0dVc7hxLNi3CJ6BY/h+ZZZ16knNUyfu9IYqP7V+N7kih3gh3br7zHtg8LzLS9vft+vPn0UiQt8wFnZ2pJPz6OmHiNm/i/j/nw6SZsi9h1ua5JubpU1KmtkjjcokVlC5YGOYcYkJ72z54fBQby+ShMHE+5JDnCu7d8FzgS1UTnOwSxuwF/Ov9hg2Elx1HS6QJkPgHv5tz4+RUwAMmu1E+cVQRy92eR2HugyvrwkUlIF53KrSPpqg/v/cY9kpUvtJ3GOIT2/w4aeiHkPhX01jgMn9fJE4M6BqDwD8bhuSaNKheRONWME9pB+E7+W8iH0O7qLM0teE+bytry0XEc1QL2PcJKu3yxYuNl+LbZ0Abcx9yeFuCODOOFjdnpXqt+xKVIqffuYheYlPDZDdyhBER6VIfVxc5p6Nk86A9ELLh60vyKdNwpAR+2b4HpDG1x3vPRcYnulE7NYnLfEWcqTbxIAlF+5ZTbDSTGLuVMRQ2OlwL1fEnROVUpBBi19/CoRb3clYhjb6bt+ov5VngWMncdWEZgmVXe9y8fHpa2dv0I9sJ6rplx7HsXT4XJtf/xJ9TuL+jcZebXKAq1oin/KjC325BQqtlWr1VdwuyuWQdhPzx1M/c8P7ooPAgh8y1cK0uZjQXh82nRAmomJV9zP5ORF+zIETpOhoRqKQ2vt2QmI58yeVX1Q+/QCh1tOr1GWURvcRP9C5s4p/JAWbKzXsX1Fa6jDj5Tg76DNpxQrjPF39EnZAeih+AgOnR1NVJb7+jyhQti3REGw1gDrdE98MJvvAFwUTdjckjVREC2RexFD4LYpdn0OHHtIyernZCw4BobYFYhjVnjMRe5glDCSAq6AA
 JNiVomZb
 rZ/qw5KOhY+lyvubv1doG1gC2SAUXdbbiyE7EHFZF0PEnxZajngnNpKa5/w8AC9pCv1h4b84hOFD7skLAX1/orA9pankcvRthWx/p4CPVx41cvFSJIALvTj1c0JGWbrcFwI3Fpf/t6DABLubnVCNlzJhkVEGp7SLeJQeJBdvquMu3G50Xa3Yky7PEGfhfCiyqALq17fT52iZT8VRM70Q0i63uLoNYQ/QjMALcXm9Hdu1STjo17/YaCNur9MBS/uOk7FdeLx34Dui6gyDFY339h/z5JvDDZXVwDhKkjrLbyshw4MBwStbU++ps5Gj5PTg111CBD5fWxjYIX7W3t/jr595FA7JptgwPEqsxjIqt7vA5txCaXhuK7kbGEoKyUU+bRyh8s9gSMaojyKeN0tSWknAwylwGzZJGQZdcvFeWfg2n8cpNWfW3xt+HSY90cNsbuNr8MXkGz3qj12qHMkghnQKhJKzS1eZh9wJll+WcDWEDiavOnImpaDyCx20o35+dJu3DZMj33PWjDtVVF0r1kLaXkWZF3OofxWPt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

clear_contig_highpages() clears the whole range at once under
preemptible models. Otherwise it clears PROCESS_PAGES_NON_PREEMPT_BATCH
pages at a time, with a cond_resched() in between. The batch is 32MB if
the architecture defines clear_pages(), and one page otherwise.

Since commit 7dadeaa6e851 ("sched: Further restrict the preemption
modes"), architectures that support lazy preemption only offer the
full, lazy and RT preemption models, also with PREEMPT_DYNAMIC. x86 is
one of them, and it is the only architecture that defines
clear_pages(). So the 32MB batch is never used: whenever
clear_contig_highpages() runs under a cooperative model, the batch is
one page.

Make that explicit. Clear the whole range when CONFIG_PREEMPTION is
set, and one page at a time with cond_resched() in between otherwise.
Drop PROCESS_PAGES_NON_PREEMPT_BATCH, which has no other users.

PREEMPT_DYNAMIC kernels also have CONFIG_PREEMPTION set, and
cond_resched() does nothing on any of these kernels. So a build-time
CONFIG_PREEMPTION check is enough, and preempt_model_preemptible() is
not needed.

No functional change intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
This came up in review of the copy_mc_highpages() series [1]. Pedro
pointed out that most architecture are full or lazy preempt, so mm does
not need to check the preemption model at runtime or batch the copy for
cond_resched(), and simple per-page fallback is enough for non-preemptible
models. David suggested doing the same for the zeroing path, and
this patch does that.

[1] https://lore.kernel.org/all/20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com 
---
 include/linux/mm.h | 28 +---------------------------
 mm/memory.c        | 29 ++++++++++++++++-------------
 2 files changed, 17 insertions(+), 40 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 35f5fc43861a..1083d0645d63 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5269,7 +5269,7 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
  *
  * When running under preemptible models this is not a problem. Under
  * cooperatively scheduled models, however, the caller is expected to
- * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
+ * clear one page at a time and call cond_resched() in between.
  */
 static inline void clear_pages(void *addr, unsigned int npages)
 {
@@ -5280,32 +5280,6 @@ static inline void clear_pages(void *addr, unsigned int npages)
 }
 #endif
 
-#ifndef PROCESS_PAGES_NON_PREEMPT_BATCH
-#ifdef clear_pages
-/*
- * The architecture defines clear_pages(), and we assume that it is
- * generally "fast". So choose a batch size large enough to allow the processor
- * headroom for optimizing the operation and yet small enough that we see
- * reasonable preemption latency for when this optimization is not possible
- * (ex. slow microarchitectures, memory bandwidth saturation.)
- *
- * With a value of 32MB and assuming a memory bandwidth of ~10GBps, this should
- * result in worst case preemption latency of around 3ms when clearing pages.
- *
- * (See comment above clear_pages() for why preemption latency is a concern
- * here.)
- */
-#define PROCESS_PAGES_NON_PREEMPT_BATCH		(SZ_32M >> PAGE_SHIFT)
-#else /* !clear_pages */
-/*
- * The architecture does not provide a clear_pages() implementation. Assume
- * that clear_page() -- which clear_pages() will fallback to -- is relatively
- * slow and choose a small value for PROCESS_PAGES_NON_PREEMPT_BATCH.
- */
-#define PROCESS_PAGES_NON_PREEMPT_BATCH		1
-#endif
-#endif
-
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
 extern int in_gate_area_no_mm(unsigned long addr);
diff --git a/mm/memory.c b/mm/memory.c
index 976cd03954e3..e09a53ea5943 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7654,27 +7654,30 @@ static inline int process_huge_page(
 }
 
 static void clear_contig_highpages(struct page *page, unsigned long addr,
-				   unsigned int nr_pages)
+		unsigned int nr_pages)
 {
-	unsigned int i, count;
+	unsigned int i;
+
+	might_sleep();
+
 	/*
 	 * When clearing we want to operate on the largest extent possible to
 	 * allow for architecture specific extent based optimizations.
 	 *
-	 * However, since clear_user_highpages() (and primitives clear_user_pages(),
-	 * clear_pages()), do not call cond_resched(), limit the unit size when
-	 * running under non-preemptible scheduling models.
+	 * clear_user_highpages() (and primitives clear_user_pages(),
+	 * clear_pages()) do not call cond_resched(). That is fine on
+	 * preemptible kernels, where the scheduler can preempt the clearing
+	 * at any point, so clear the whole range at once. Otherwise, clear
+	 * one page at a time and reschedule in between.
 	 */
-	const unsigned int unit = preempt_model_preemptible() ?
-				   nr_pages : PROCESS_PAGES_NON_PREEMPT_BATCH;
-
-	might_sleep();
+	if (IS_ENABLED(CONFIG_PREEMPTION)) {
+		clear_user_highpages(page, addr, nr_pages);
+		return;
+	}
 
-	for (i = 0; i < nr_pages; i += count) {
+	for (i = 0; i < nr_pages; i++) {
 		cond_resched();
-
-		count = min(unit, nr_pages - i);
-		clear_user_highpages(page + i, addr + i * PAGE_SIZE, count);
+		clear_user_highpages(page + i, addr + i * PAGE_SIZE, 1);
 	}
 }
 

---
base-commit: fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6
change-id: 20261021-clear-pages-batch-77f72ef808e4

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


