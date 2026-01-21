Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68559C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12DF6B00BC; Wed, 21 Jan 2026 11:57:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A3E6B00BF; Wed, 21 Jan 2026 11:57:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B60CF6B00BE; Wed, 21 Jan 2026 11:57:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A362F6B00A9
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A6CAD3655
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:06 +0000 (UTC)
X-FDA: 84356576052.29.3BE5543
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id D736A100004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="f/GYMYaG";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hQRoUMzp;
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MR7uPXwZ2+qW4GqAtFuWdYc76VZrpAB9Uw8TQSQ+BO8=;
	b=UayThfxp7DnOR/ZgHxTqI3qf7PI01WiSeQZieVwuNWKuDMA5BBjYWEqlFX+4IC5Wt/AZzv
	OcQbKG9QE/3FCjrVM2ZvzxUbOh5yxG/HtITbQ8yTY6gtm+YJeNbXlZZBC2ngP1XDKwqq5H
	quL250qI7UMPNWnOcMbUDk3ee01na48=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="f/GYMYaG";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hQRoUMzp;
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014622; a=rsa-sha256;
	cv=pass;
	b=mpQss6sA2ifSL7sQjdoeIjDnZFllIcbLJ4184B61iNu24iG+TlqWO6MrVfZHecPbVCSPcA
	aNVddSM4F/CTTpRSAPKd29ngGmXqlU2QpFwSP2VZo8zzpG18hbePPyE6P9+rl9qmkKlU7G
	upiDli6Shy/51CiDdnTe5I8BfNhBJ5M=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LCiLQs3523936;
	Wed, 21 Jan 2026 16:56:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MR7uPXwZ2+qW4GqAtFuWdYc76VZrpAB9Uw8TQSQ+BO8=; b=
	f/GYMYaGiho/iDqBong25LEZ8oP7WNoWX405tUwbofHxzgRHmRJ/mHXTHACPhYyW
	8A+kQFChVcsvEOV0ETJ95rpmjCPx9M+66DDZ7hRqDQY0VYK5E7A/Rwtpmxn5AzZv
	kFA0FO7zj1UXfCQ9Grzy9V1892robdjvYIRuHTfTs1FlNf3Zw7G9ycMZlYk6ZUZj
	j1i0knqUYHHDSzQWAorjg4KklLd2wcTrMOPe0kM3E1PD4yPBBlWjXfVgRXgWGzrk
	bR4iOoIe7wtxZ4H/VvOQeezZE8yA9TOLaKxWXT1SMmyDwB/wvsSzMplRLPvvqFJP
	/tIIU6whR50CYnp857d4Vw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qee63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:56:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGKKs9008437;
	Wed, 21 Jan 2026 16:56:53 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010004.outbound.protection.outlook.com [52.101.56.4])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbhsfr-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:56:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qMVuL/JUImnxKBmNEzrxaIngopcXnDXdKyWybbED/ck3nJJnzKl86t/2XclmeqJDFUryQfGsqBVks5otY66N0fVL+ChzQiwhkAJx/bNe4cHVVkCeFQ2/XVfVKwBkKzuqy02Hw37jJ2XBIQA2+bDNtwjAsRT2u8rCy/tqkOHbFIQ0rAJ69oa5DAp8JshHWP+uesJMrHoJ5vYqe/50pAWUzm7td1bnEvzHK7Zw1XW1eystVS8DVSWog/S/5CF3Ss8q40gRaJ0EGXQKjCnWI7a111rXXVUU2L4Gh5ZojtEYd0msnpJU3keyo7AG909rNEdPTFIcjHpSHVxcwQd81sIR+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MR7uPXwZ2+qW4GqAtFuWdYc76VZrpAB9Uw8TQSQ+BO8=;
 b=MPcDvXQFz4frFm2L006U92KWKPJYysdfwVBUz3v2DIVlhXQKjH/25DCgtj+mjk5E/7GY8EhjiSBxmcxUWvuC1FAuGkSDRegAYiC6RnBfsSNW/ZAZhm9Dgd45fmoqW6TMkwOgImZ8xeyzH/9d1biEUg2N7uJ/j3ENcReDyA26Z3rLD7Q1+J9SlbFRvIY8dQsv278XIrFr9nzRtQQt6dmRDsMGTtOP4EbxMQ8tiw3aZkZd+ni8NEcotGhO24pJRTwA8WXmBb5xpWr2LZxxmOTmr+A0benbvXO3T6Gflk+i68gLEAsCjAHBiHKDPd14kKCH2m70vz3Pljpe4NuCH8pyqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MR7uPXwZ2+qW4GqAtFuWdYc76VZrpAB9Uw8TQSQ+BO8=;
 b=hQRoUMzpP9aEMws8ml3F0M/cbymoijJZRnvBem+RdCmv/QI1L5BuoBsUr69YCfV9wSlDw02KUozQyF+Rw5kUpHGdVFwBbfCwh1isyoiT0rSC9iqu/HTbySucFkbJ49m2E5+y20PwEXBZL0WmoSLZ9sIZLvomOV0t1dO6Qau24Gc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB7712.namprd10.prod.outlook.com (2603:10b6:806:3a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:56:48 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:56:46 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 02/29] maple_tree: Move mas_spanning_rebalance loop to function
Date: Wed, 21 Jan 2026 11:44:59 -0500
Message-ID: <20260121164526.2093265-3-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: c07f6fc5-b4a3-425e-d0a5-08de590e0fcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RW8TBlm2F3H+HAh4ulHDO93W3ROQiii+u4hjAOcXbi4RJdzZYXExgb6N4m6D?=
 =?us-ascii?Q?3T6aMR6xGSLjB0gR4VT/DnCSi4hAmk40hw5xmNR5b09ZoHroxpFG8eBNcFxK?=
 =?us-ascii?Q?bA11FgiQjt1R+FgmB9NpMBUU1xnw9AL2Gl+kdI6T4bxwRsYBnhOvHRcAwpxt?=
 =?us-ascii?Q?2G4b6VZKogROakNXgiEJ2+h04EBXzGOPfcCeNJQfXOwc5cuWf4iUqaZIV+4X?=
 =?us-ascii?Q?rs6p9qMQdq/If5PzK6eCu4p+sq+umVR1hEFwnPDxzC2+XuhE0mXMbSxIUdiR?=
 =?us-ascii?Q?NNeN9YGvKSpKxGLScbUHUCW5aXlKZtz8F0xyZLioJieIWjEcH2VDLg/3r7+3?=
 =?us-ascii?Q?ZdA26vaRyWOqEArapXL3pY9r7QIY7LhGWEEFTsqvMoLOnyBDPqXJh/t3Tuz4?=
 =?us-ascii?Q?AGbKJl7mtY7pGSgS6rM2eCdM5rbfORndgERWnRotTPOeBLAWHS33J9VpLOVc?=
 =?us-ascii?Q?DcX05MmXX54KLuwXuB2lp3V/MljbAUCyf3Zi+323Lpiolv/oWwqHlETp/d47?=
 =?us-ascii?Q?RREh8iMrLrOJ3WGWVas0IKKQb4iekW+g9zjW+UgcCQHzIdRWSrnpl8HZpa7b?=
 =?us-ascii?Q?5HpSZztb6QFd9oZhb6zaE5UHLF9Mn3RxJ7/X9eqomf34lV8llR6bShpkUx0N?=
 =?us-ascii?Q?fbBTb8226Fu3peXWL58xDtTm9klCDC52NvX+r9B8l6IL8SxW5JffRRpeXsQg?=
 =?us-ascii?Q?bz2WDd4Oe1C8C3m+y9yqa8JZw4hP3xhU77e240HUwYLxXK7MW1rdh6R28ZZp?=
 =?us-ascii?Q?mCZg/Wi5HYpGXvI3p1xlOMr/9l9xTTnDrrdS0z5ZJ7T/nT6HCgycN+4NBlyq?=
 =?us-ascii?Q?gSvnN1FkkYR6kDDMZuVeRMDGVW1SSWTry2uHYJDk1r/ReRRvvJbsDEij9zOI?=
 =?us-ascii?Q?rP27u46mJRjjFSMnSZvOLeBSj1firj3/fLSdBdky+YDCnTU6rIZHLbiNXdlb?=
 =?us-ascii?Q?Uo2lsBChcyrjVDYF7XFuhi7/hC+9kXwYy3/Fs7JsuD7ab5LRZ3npvgCUUxGC?=
 =?us-ascii?Q?+h1Qd3v1xJSoz3itYBlUApelBQ83RvRGfjnEqSTBqp+8fYBnBHUUljg17zlh?=
 =?us-ascii?Q?MjhyWHCna5etPSlm4Y7TR4beujkavpyobYk18fCwdlGZSni/2j+LmwvOjhnK?=
 =?us-ascii?Q?gxNuqvVk5Q2jwMZt96t5CsdQbM3DLjre5oYpElSGxZxqyHxCxovZPgVArqPe?=
 =?us-ascii?Q?AR6tb08919DpTOidtww6q6Jb0HYC4r8dbFvDUOXDrDhAe1ei0fCNEW1aNUoO?=
 =?us-ascii?Q?ZtkgY22kqmqaNoD6Br/DV5Ou1BGmhVScJZDYq3UH/FDgNmZuB0RwJkK30fdd?=
 =?us-ascii?Q?F0xEo+etYgHMb993lDeLhxB3SHhEB0ttgNzoS0XNK8Td1SGSGov37PKApKE1?=
 =?us-ascii?Q?rttfWxxTyLOoClLYE8/Io26CSfzkyRtW+m2BWTgNRU0TV0ccvFhGHaFi+c0m?=
 =?us-ascii?Q?oilZUnEaKwdFtMokTVi7PWBLf2q1wyq8usoXOQ3jkKUp/jpwvPVIh/GoXeZ+?=
 =?us-ascii?Q?imheDESWoMILtnsNBerju0xB1FC7zfDtI61F5a6waN4NxtoZDNQg8CHsVXVM?=
 =?us-ascii?Q?NAcwiyX24Ye4FkW8W/g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t6nN7v6yoqzYmYFW5ZSUe/oq0Zmfr7HTRyNp16Ec5wi21sfHlgEw/4+BXWqF?=
 =?us-ascii?Q?o+dzthEHf9mdtyobdDVPP4/3+GSxXcH9cERUmY6gTbrB5a/hb69OcXNFDAl8?=
 =?us-ascii?Q?d9VDBu7nNJazq+k5raGvGsiDWPcS+6Q7SxG4PDkZY07mYOhgvItMgIXCb60s?=
 =?us-ascii?Q?Ea8Do1ddhDgJuhHjM6JVIxznGNNUbLvTqXwa2KXpyu8MFFqn+5pn20+2zVre?=
 =?us-ascii?Q?pLyhiN3aWvgjpRhuwUPu7gJCduIMPI4kH9XTkXdULu8SO1a3xsbXyIsBes/2?=
 =?us-ascii?Q?iAq83KVPwr8F0A/PhcW1o+rhHgCIb2bIaNdyKJu/sh49h3QNo4nBQZpsWIZ4?=
 =?us-ascii?Q?zyA/Hy4jW7U88uVUwZce2p94LxBmEF+YRErGLsm/N5vqYEFv0lNJxKLculon?=
 =?us-ascii?Q?tds548/62eVgACZCKQsKcjgwucOKYV9LN5A7AOzetgxs1gGf8MsV83dbhOy2?=
 =?us-ascii?Q?Os9dN+yJD1/H4qek9WSzXpL8UkgWZ9W+IwsrxcRDL8WnrJXjXKPapJNNb2qV?=
 =?us-ascii?Q?rgQLVWq+O2BvDaqCDmJnrfg6TMNoJ2asNeWkGRtLltdJq7GIieLnObyoY64M?=
 =?us-ascii?Q?KGX60kZXZg0oCH6b2q2BeMzeXHmW2EoVAZDDeaVjNW3bZcmM1xISW3HwB0rF?=
 =?us-ascii?Q?Jjr4dQOi7Tr5dbFLUYQb+6dsy1XwiKlo8gVXLoXC3rzyYdkh00leFDX+GD6R?=
 =?us-ascii?Q?NYKnMFjEoZjdajqblwboljByCMSbv3+JQEKdtBFfkgX8Koj1cyQf4RczaXwX?=
 =?us-ascii?Q?sVoAPPKa0qIINViGYiOY0ezBfswNES3KMaNOtj2DxAVIGlYMaj6o0gtQGY2U?=
 =?us-ascii?Q?Ff4kjuvixczRlVloVKjIqEKJfxny5lwBbbYHiGZ7+ujhcKL6SPzD3FqTJkob?=
 =?us-ascii?Q?01pIBcN3JyqmuRls7/Ql7moAPsXWLEmABXUHaW8lOmPDBI2TT94vALnhBSog?=
 =?us-ascii?Q?Iy7P9Sox3t+rEAUMVpkicYxVfr/C8mSF7azMn5JWyso4TVHoBoEdlRy2doMS?=
 =?us-ascii?Q?SkxbYEAZq9JTBgXT/xAnIT4cxMBTOG8pHPD71hpMLh0V8AsOr2uZfUdzVE/f?=
 =?us-ascii?Q?3HPY12IYHRAeUH72QFx0jhVCZDsUtyFz57UxmwCWd9rEZOSs7DqBgPkWbAxY?=
 =?us-ascii?Q?UKRX+jePsoP+YizBe94YRborGmDCOFnLYMOE688ed0kixWVslt231H3j9oxJ?=
 =?us-ascii?Q?JXVyyqlfbRXq6VNepgB48e65gFXoaBLHs5Pf1NXUrEKfOWC7nJ4XU27p7e6J?=
 =?us-ascii?Q?TSZ4wwMCLrRWv4Juyht3VI/fe1AzaNZpMnxYTxMNrxScsvT7OuxcbgVuhna2?=
 =?us-ascii?Q?xqUrggfqmFjn3eoxouzsJwldz2GnwyDRE0Ji7sZhGNTlPG7wptaTC4zulYcA?=
 =?us-ascii?Q?tBIfq/eQwyVFn5e7pqR5b6+vt6cwc6NGDImOJWDY0EiHGbH57E9YuqLNrAVX?=
 =?us-ascii?Q?w3yUcehV2mn/axxWjOa939LDWNZvqLUimN3hj15ycB2WJq8E2d2AE28NOP8X?=
 =?us-ascii?Q?E1KDlGUSmcsOmcDVw+zBPcr8EgkrxfcHfo5HXK/7jl+e2zdcwZFs03Ae7m0E?=
 =?us-ascii?Q?XlXDddUb4hJeKGe4maymwyJVDrag918FzzcPcw0CtQdiqIC+y2kmpkpQCMt8?=
 =?us-ascii?Q?VJ2f4nB4DcdU9Am+Xr+H2VKO20HI51kHiFRHYykfverx6NkK0yFguTjz20gq?=
 =?us-ascii?Q?ig5tfP1GN8cL7YemkSgXMienDuteTGB2GJQoYcYNIbIq/g7R+IaYBPv7ftJn?=
 =?us-ascii?Q?n6s0LUjX2w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5KID3C8Q7K/5zIAn9G6e/L1fE7h7h8pUSYTtfeb5UfpKhT5yFCewvJOlv2eH6GUgGMDjKZvSUSKJIsSX3C3Saj4lt/5Xrc+QYSHj4oxj3uvHLwWnw+Afc9U10VWzveIfHub0HegTIpJMV4PjjP9qJp4arJdPH34x0uj1s8hNbMGswSIiBC0+LGalaI16DDIB3wnOLZAX03u6wyruWFWuRQsJkNMqqwDfGbw/KidXHUOHDntHZ3oSTvMkgEksLwXlHmOC/QTZjtOf+ceVPYLbFJot1CDPgfV0r16KLuVRsW3t3bpMSekxSYysWe6lOzO3TcwD1p8Fxk+5XaxnHzbdQ/4crXtcYPdnqs7sMINZTEAFElbF72yZIVubb/VNVOH2OCQDbNX7GwQK73P3prgF5tWzGq/sraTDJ35tzogxF9F4fkhmS1TQhnMWTRjEyu5zO6904QOX+pm/V858EWMYUXonbYjvnpMf60N9JaPJbFQTlrjb5k1S/LqGIDUH/fxt1Vxk6jIo1PkpnBqukhcv9a5yphdG4sk49VFXyGXGWY4lkqh/yGsI6BzLYzdOnq9LTRnWLAXZXNJb/8WE1zrN/aCJzS0pTdwqTj33mg5gWs4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07f6fc5-b4a3-425e-d0a5-08de590e0fcd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:56:46.3994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJ/pOYAyE+mYsYtJQw+6qPTVDb3CtBGV6Ak6/ps9gP/IZCgTJwqMcCvcVBZrQgRbfsH2T6JkKDKFPUr+Tob2Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-GUID: BOl6E3kzhWbjf3R9ljiIaxorA0qJQkON
X-Proofpoint-ORIG-GUID: BOl6E3kzhWbjf3R9ljiIaxorA0qJQkON
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=69710556 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=KfpCAqERy7lSuQKxsjcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfXx+wn7X+S8zuX
 fnve1L6F9lBqgm96QGrBYVxq/SJPiN5u+Lc3NRj90n72FTZvg6Ss55b9KbmI42o8T11pr++7q7j
 RWH+PzLzbS89J8guzPJtMFfY204/dRd9yfeXlFS0IHhSjztpDerPBJZnMVncjuKLnovVchUO+CN
 3h6BG90eWfN/w1EUOfW9gUfm71CQG7fb1v2b1oPLJ0jz/Z5Sn/c2ngNDWAZfbLCF+1lTRTvpwu7
 RFXON11cL/UBZMoV8GuhwdDZEdL6r/Qux7kj13t95EApKdlYCg62AQsmS2LUBp6wQLCXv+Z/SMa
 T34fGt/pt5hdQoHU552JZrSazJI63M5tp1NUHrq7L7zce76ivSvrX0GVPhti8CAXPavZojHaVKR
 fFEtsyByNu4jROwly1c2zCqivG/s6wK5ZWd5owGhVRRJskpKQO7rjm7tlNnz5QFI9Oo6l7S025V
 /K7mpoAhJpW2chQaFQg==
X-Rspamd-Server: rspam12
X-Stat-Signature: umtqxnp5gzej9b9kaok1renpa6iwe4uy
X-Rspamd-Queue-Id: D736A100004
X-Rspam-User: 
X-HE-Tag: 1769014622-70056
X-HE-Meta: U2FsdGVkX1/6P2lCWq9ZbMxWVt94nFg88ANl6AkMYm4w0uqjHwrMunOFuqDLhQDykmDFW0TT/PcFOmd0eK2KbeODoKpPCnGmfrE2VxdbVYA5Nri+9lWAYx5zjxkmNwA2KU8chYOeGH1qmUsdlbz5+ZQPzlwugYj8u42USeLCTJJROcmOISAcVDAV9sxLKn0gBncvOyKaf06/YtXoZSYHmtnHvV9LjeNytLWgniwoq1m9EDdDrpqiRqvrlxsAioe3gIx+t0MOXutjS1ASRTtZosExbFloJjbYm8aE1gDXXKIjB9ad400bCigAqScSUHiGpaaGKUSf58GTU/q8fojiONmLUpcKmTQ57UctDOuu22VlPUePv6Zl3cueXEpClg3bG6A8+FsjPdSgXDn5Tej4hhmi2GO8zT0r5Tep0jjy0/P0vfa9mMlpRwGemUGVyVaX87DSlYtJylUwmqamcEqFIhoLhOaF4NpnXZ4DMoLMtyGNOo2NkZ7ryblKf4CZizBHTwSi+NQ3K4QOnDkK6IaVXV2yL93/+zaHG+iNnIKkMIgON5rUu0HDVdMzkjP1iq6ox9RUCjHTisrwzzW8fEM6UVgo1XjDtYFzXSxbJp5rC88PTrMFpAVUnOaD1bru0t/sxVnPUHNN8474eC1gJZbW6vs0ElJqJ57FRMppNzNI/DWvlLEUO3MrwMOdzMahx3QO1pryVosj0w5fP/y/I5LLV5GT6e9FXnbxCHIIe883qD/qz3nb9BnKhtdy/lTuWyv8KfRwnYhNKUKuLUgkvo38o+UkcpMudgxstxxjVgJUa+4uyhLQGybgLUI4VGneCDZELLD3eJJ4sqVHV1A254SxDRzQRtCHlOPp+fru7yOzblJ/AeOLUIbbDCNhdzqah03OvKsg8/5XPd3DT/rwMecImh4mVYY6zWQ7kVZ7cRDA0fwR9abA8wrVHQ4KFgHq81EGIzIm1ECthVHsErI1kxE
 nmH3oqw1
 NYLXsO+YEQ/8zA2VFBzzaQ8z4tXnASjjSyzWkdsrT3cMOkvXllQDiXTckTd4mlVR6wu7+IfYAZaxFvFmK9uCMtzzYd/Q8basK8EXly2HHkTvLMTedsLOGUlUaAZF4m8QUMwggk5KSzeYVgZQLb0wDVlMT9l/ARoVgXf+JeS0FG0/uYROMkbuJoFKIs2l13iDzaVtxVgpMY3ZOCckE6hXwF665CIEbC8mK+qCC4Q0j18dFnDVv7ZVyGDUrH3V1bqxuTGLvZYua9Q6dVdB8nGiblwxuNh8a/VL0JrjT/3sMu6oL7As4IHdOgTm57RbZKxj+vgpeaxdFgkKhyMtm44EeFK06wpWRl/xjHs/XOONVj5yk3VUBaK1wSls4v1MBvnvi7VluuB2H1y2dToNdWkEVu4qCDqJsq6UU58ecvwCptKVfBjM3cUx3oayY50N3zSqylfc8tfchDf8WBa7YfQeg5z0K6pQAyoMJryZ7v64UcQ734iXAcM0nf2wMA/yJoY6YrBivAWQL31w4gEsr+4acEhfiKCQjLALdzxOXvVdyam16Gv/GDEUYzMMhJ1Sqtx0wmENIH/+/Q/spWr4UQdtN6hBlrEGSGeGMINEchQBnNkhZfHE2ESQrQj/Pb8G96F+aCCWLCyuV2IIxYZTteUsjX2VcNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the loop over the tree levels to its own function.

No intended functional changes.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 108 +++++++++++++++++++++++++----------------------
 1 file changed, 58 insertions(+), 50 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 0e0158ee7ba55..70ad474e6ed14 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2595,49 +2595,16 @@ static inline void *mtree_range_walk(struct ma_state *mas)
 	return NULL;
 }
 
-/*
- * mas_spanning_rebalance() - Rebalance across two nodes which may not be peers.
- * @mas: The starting maple state
- * @mast: The maple_subtree_state, keeps track of 4 maple states.
- * @count: The estimated count of iterations needed.
- *
- * Follow the tree upwards from @l_mas and @r_mas for @count, or until the root
- * is hit.  First @b_node is split into two entries which are inserted into the
- * next iteration of the loop.  @b_node is returned populated with the final
- * iteration. @mas is used to obtain allocations.  orig_l_mas keeps track of the
- * nodes that will remain active by using orig_l_mas->index and orig_l_mas->last
- * to account of what has been copied into the new sub-tree.  The update of
- * orig_l_mas->last is used in mas_consume to find the slots that will need to
- * be either freed or destroyed.  orig_l_mas->depth keeps track of the height of
- * the new sub-tree in case the sub-tree becomes the full tree.
- */
-static void mas_spanning_rebalance(struct ma_state *mas,
+static void mas_spanning_rebalance_loop(struct ma_state *mas,
 		struct maple_subtree_state *mast, unsigned char count)
 {
+
 	unsigned char split, mid_split;
 	unsigned char slot = 0;
 	unsigned char new_height = 0; /* used if node is a new root */
 	struct maple_enode *left = NULL, *middle = NULL, *right = NULL;
 	struct maple_enode *old_enode;
 
-	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
-	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
-	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
-
-	/*
-	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
-	 * Rebalancing is done by use of the ``struct maple_topiary``.
-	 */
-	mast->l = &l_mas;
-	mast->m = &m_mas;
-	mast->r = &r_mas;
-	l_mas.status = r_mas.status = m_mas.status = ma_none;
-
-	/* Check if this is not root and has sufficient data.  */
-	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
-	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
-		mast_spanning_rebalance(mast);
-
 	/*
 	 * Each level of the tree is examined and balanced, pushing data to the left or
 	 * right, or rebalancing against left or right nodes is employed to avoid
@@ -2672,10 +2639,10 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 		mast_ascend(mast);
 		mast_combine_cp_left(mast);
-		l_mas.offset = mast->bn->b_end;
-		mab_set_b_end(mast->bn, &l_mas, left);
-		mab_set_b_end(mast->bn, &m_mas, middle);
-		mab_set_b_end(mast->bn, &r_mas, right);
+		mast->l->offset = mast->bn->b_end;
+		mab_set_b_end(mast->bn, mast->l, left);
+		mab_set_b_end(mast->bn, mast->m, middle);
+		mab_set_b_end(mast->bn, mast->r, right);
 
 		/* Copy anything necessary out of the right node. */
 		mast_combine_cp_right(mast);
@@ -2708,17 +2675,17 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 			count++;
 	}
 
-	l_mas.node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
+	mast->l->node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
 				mte_node_type(mast->orig_l->node));
 
-	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, &l_mas, true);
+	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, mast->l, true);
 	new_height++;
-	mas_set_parent(mas, left, l_mas.node, slot);
+	mas_set_parent(mas, left, mast->l->node, slot);
 	if (middle)
-		mas_set_parent(mas, middle, l_mas.node, ++slot);
+		mas_set_parent(mas, middle, mast->l->node, ++slot);
 
 	if (right)
-		mas_set_parent(mas, right, l_mas.node, ++slot);
+		mas_set_parent(mas, right, mast->l->node, ++slot);
 
 	if (mas_is_root_limits(mast->l)) {
 new_root:
@@ -2726,20 +2693,61 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 		while (!mte_is_root(mast->orig_l->node))
 			mast_ascend(mast);
 	} else {
-		mas_mn(&l_mas)->parent = mas_mn(mast->orig_l)->parent;
+		mas_mn(mast->l)->parent = mas_mn(mast->orig_l)->parent;
 	}
 
 	old_enode = mast->orig_l->node;
-	mas->depth = l_mas.depth;
-	mas->node = l_mas.node;
-	mas->min = l_mas.min;
-	mas->max = l_mas.max;
-	mas->offset = l_mas.offset;
+	mas->depth = mast->l->depth;
+	mas->node = mast->l->node;
+	mas->min = mast->l->min;
+	mas->max = mast->l->max;
+	mas->offset = mast->l->offset;
 	mas_wmb_replace(mas, old_enode, new_height);
 	mtree_range_walk(mas);
 	return;
 }
 
+/*
+ * mas_spanning_rebalance() - Rebalance across two nodes which may not be peers.
+ * @mas: The starting maple state
+ * @mast: The maple_subtree_state, keeps track of 4 maple states.
+ * @count: The estimated count of iterations needed.
+ *
+ * Follow the tree upwards from @l_mas and @r_mas for @count, or until the root
+ * is hit.  First @b_node is split into two entries which are inserted into the
+ * next iteration of the loop.  @b_node is returned populated with the final
+ * iteration. @mas is used to obtain allocations.  orig_l_mas keeps track of the
+ * nodes that will remain active by using orig_l_mas->index and orig_l_mas->last
+ * to account of what has been copied into the new sub-tree.  The update of
+ * orig_l_mas->last is used in mas_consume to find the slots that will need to
+ * be either freed or destroyed.  orig_l_mas->depth keeps track of the height of
+ * the new sub-tree in case the sub-tree becomes the full tree.
+ */
+static void mas_spanning_rebalance(struct ma_state *mas,
+		struct maple_subtree_state *mast, unsigned char count)
+{
+
+	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
+	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
+	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
+
+	/*
+	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
+	 * Rebalancing is done by use of the ``struct maple_topiary``.
+	 */
+	mast->l = &l_mas;
+	mast->m = &m_mas;
+	mast->r = &r_mas;
+	l_mas.status = r_mas.status = m_mas.status = ma_none;
+
+	/* Check if this is not root and has sufficient data.  */
+	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
+	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
+		mast_spanning_rebalance(mast);
+
+	mas_spanning_rebalance_loop(mas, mast, count);
+}
+
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
-- 
2.47.3


