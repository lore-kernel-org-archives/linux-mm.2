Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB67C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D976B009C; Wed, 23 Jul 2025 05:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0DED6B009D; Wed, 23 Jul 2025 05:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF316B009E; Wed, 23 Jul 2025 05:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F89E6B009C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:58:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC2E4133887
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:58:38 +0000 (UTC)
X-FDA: 83695079916.16.0D7B3A8
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6AB8640007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:58:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XWNdkWJ9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QY1gdOk7;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753264715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Vj0oq5hZmj4lxgEIU7YkdjFKhw8gp2l5JfrKR9nZ2ZI=;
	b=4yJksRYaKXwyzDnEGjIZCDoT9ONi9M/Xc7wBB0WkoBIf/ELZb8IHHpQXt2b8xqL7kKo8jo
	qEyWX/HQxMSG3DkB/9dmCqTkBth5k76WO/pJQMGIaxW1TLoFtPV2GH6MYs3+7UDlYW7RTW
	uWwMJpvbxA5aWXR46p4ZbnvOar0wJ5I=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XWNdkWJ9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QY1gdOk7;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753264715; a=rsa-sha256;
	cv=pass;
	b=Z1GmXW8RJWTNr/4jMCRhhIo82fe5zD/in1iRAbt/mwzjpydIUWGSGmpNAJeAnsjEobQV3f
	dq4rRYckrnifJ0rlHcQUDFPDEkmg53XXLS6+zUq5ByaqiKVbf0YULDajJq6aRHFNZdaRyv
	Dr/rD1Am6ihdxO4fxSJJ/DodqqQYppU=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8NHHX032711;
	Wed, 23 Jul 2025 09:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=Vj0oq5hZmj4lxgEI
	U7YkdjFKhw8gp2l5JfrKR9nZ2ZI=; b=XWNdkWJ9xCH2MjrVQ9Q9HhMUzBtkNSpZ
	DmqhDPeRN7TzWR/clgxebPO53qQEyskIFXFuYeG/GNkEZT7M8siz1OWoiT0+T9ov
	L94QBJtYQN34c505yftFRPxLbvsNDfWhFuyXUmCwkU+Hwm4jz9uVCMWuSfWZ1cMK
	Kb4zLDwXxQQ6B+N1lb2Vvr0VTS7VhH0ZAPKxvTX9kq5UcdEVIOSf6axqW0SBitbt
	xN5Yzd18AgPu13OVayLT2sUT2Zt/a8y5MrVh3+ah3aPfIKOx72syZxjlBYGDg7gu
	A39fjFNR4rC+jJkAcmXWWwj4jyA2RPGb63uL9/dzyHvOlJixf4c5iA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48056ef6nj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 09:58:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8hngp005990;
	Wed, 23 Jul 2025 09:58:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tad7mx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 09:58:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RayjxtVh5vXLjlQWYTPzeNHZSoLMwPj5TgQYRvf2sq7UR6AtWVuvUxjqiHsD+rgaPdSkwyN5hVNHITSHUJTWUZxaSUGBNbzrfHB3B+7Epu/P9njUHu6GoyRJ2JDt657XUIFJctYVum/Si1A+dD1fa9t+3h+Nm++yAsGO6fT0tw6ok1oTLH89h1FE58Imm14THqoEaLcsx5MMfYCWQbTY7zeyg0GrIyo3pz4wQASR16+mnF2u90yjCtdzIxDOr53xpnkL4mXWAOQfc4ZBkj+GqyFb/on/qseVJvgExpFZLEX2kAe+RJNEyjYjYh86OycwVO4emkFvrWoiK2xJMW7/Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vj0oq5hZmj4lxgEIU7YkdjFKhw8gp2l5JfrKR9nZ2ZI=;
 b=bv8NtBjKkQmJbpQK+JhNqFF+Y0DNIKx7xjZ4Pt/KCLjqPVy7mX8hjaXnixd6Z1R6wye3yYDYfi8n3ZM01MB2oc4Sr+EBCNE142Tw3u+dkST+SsMcMQTfrc+iry7p/puoFx0fA74XteyF4IN5uKkoxVRwT3NpyEd16+59Ze5L0G5of+ePZC8KJHnPWp17GzSz9wbJUHTKq+4qNQPHHiEJUZSOCItyHeIwPSQctR3edJJxGGPp1bdjmLl4WDbyfIbR5wuILGdIrChJzVR5WU3/O26xZzjmxMt5IO7uH+h7mmqGxNeSr/gtaJ3H8EDCnr/gX1mUwOF7G1ozuCZB4rHc6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vj0oq5hZmj4lxgEIU7YkdjFKhw8gp2l5JfrKR9nZ2ZI=;
 b=QY1gdOk7M6cMmXThQTVXsItj0pXfysDxrGlXKJ5FzOKu2qDbVU5zHN3AElbvajpFJLprSkADKoj2KFYe5HQSlL+DYrejqKJK1x9WcDAgEDFF6BnX8fkDxV3jI9nHQq946npfc8f+3wW55ykKrR22BWLlekR6s6IVMGrhYdUW3vw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO6PR10MB5586.namprd10.prod.outlook.com (2603:10b6:303:145::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Wed, 23 Jul
 2025 09:58:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 09:58:28 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2] MAINTAINERS: add MM MISC section, add missing files to MISC and CORE
Date: Wed, 23 Jul 2025 10:58:23 +0100
Message-ID: <20250723095823.21940-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0014.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO6PR10MB5586:EE_
X-MS-Office365-Filtering-Correlation-Id: 65ec3e3f-22de-48df-a3d5-08ddc9cf78da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wbDNi4nZHKGMfcfS4HwGiwStNB666TI6vUnf0R70HdfHf4L7kAJuLD2ITjpK?=
 =?us-ascii?Q?iTo196aNoRTiBqVpCXc1JEZ9UCoMV7T7MrloDUrtfrqWgafxLm0/bb3fMO1/?=
 =?us-ascii?Q?nZs6PaihRZGF2Cr/pGVu/lfbpRSJufuyd1eso6CHfpjQzuoXNurmcqpMKMvv?=
 =?us-ascii?Q?VrMcioPoOcJN7inwmX8qAF70WnHdjRTa4oKl+EVoqsKOTygVdCh+tUPNJZMM?=
 =?us-ascii?Q?5/6dR991zB1nFWMD3JyqMmvEv8e7sMMum/CiFmL0dUQ/9M9sz+Ixt+sej5+Y?=
 =?us-ascii?Q?oHRzpegSKSP3b4zuNxRn/azFi67Dh3K3j3bSzKAJ9R5DOpjBRaSMtPxBGpsy?=
 =?us-ascii?Q?010x9P4+KFezONj9RTeU2XeKm7ONZHpW6If3XQ5NSgsvH7C3N6PT0q1GFYuY?=
 =?us-ascii?Q?g8YQr2UsG9s0kqR89NFozL3VY6xmjLQK7AWCLA4Oec2E5VCLqhbee4qR30b7?=
 =?us-ascii?Q?6LoYufTYF41nV9yCH5X1RWOy7DQ4IxfW7Ig8y/UW4ZUNt0l1MjFY9UIrlQNK?=
 =?us-ascii?Q?yutJNzrbqVPs9WQ3Qp4qaZx2q5jT7/0JECs2Vr++rm2jMUg5KnLijHNIQCgQ?=
 =?us-ascii?Q?6ocezlHdATawTnt+XS7PRwV0+X5X8fkrvKRDNM6n2Vbi5DXdqkHGdcmacxvM?=
 =?us-ascii?Q?ZG9Z3Erc8BxQmH3xGmCSBm8IJqzR4gtBRzZrNh56shXR4XF36HHtGQhWVWWG?=
 =?us-ascii?Q?YDy3utJDYyki6N/qgIy/yXrN5xj465j83s7FLSPge0o62z4d1hGTnqxmvLpQ?=
 =?us-ascii?Q?2+bGdzBC488vn6XdWAJQSq0JghGG5xYx+UoYfYEeMmAZJ4twC4LRa3AUiCS5?=
 =?us-ascii?Q?K9nnfCb0xVp2RgurwaVlzS5ND9ZpTBQj2u0zszrzN5+gBB8E4gTr7GJp/BcO?=
 =?us-ascii?Q?rpmL9bKa/UgIf6j9TXOUPswyrTLFgtNPzsdOJvhyLQQd/hJlRm/JJTdTjC4C?=
 =?us-ascii?Q?Q3rmDZTIXBDZKmIOQL+/yGpxdSglrDbFQECUXfLiXFo8rtxbpt8FQG9p39JS?=
 =?us-ascii?Q?84DxQDxFAsYuTd4Xm0Lx2q1CfnugwrH6MU8MwSy3PSLz3Te3ArxCDnymGN1Y?=
 =?us-ascii?Q?NzbaLFw1D9RgmxlHu+cCngrfE+k12XeHGxTDDsbhRjzVLWw+7gTKXWvn2RAc?=
 =?us-ascii?Q?kk7cgPLMMrDHgsjF57C2t5cm8j113YAM7JZjzv1YFPgFnpLvE8lEwaeIWvSz?=
 =?us-ascii?Q?uEUkN7yqL9cq4/NJMrRUIITUE+9ioXlA9GLdA+XAcsWcmsY8IbQ9Vf27pUZc?=
 =?us-ascii?Q?yT15MO5wqwJbpZf++u8CMBan3e2DEaa429MIvID5U2gIBCkpFIMg2y0v439H?=
 =?us-ascii?Q?hT6aZ9eQe5vbKjYwPJPlsUJIusIdKX7dQRJKa8dXPGX94VowG5lnWOCwvj5c?=
 =?us-ascii?Q?BcEhrmT+3lehsHV5GvWY+JXaKISU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tznDQ1pfSs/tobnOdA9C5I6xENlJvWwQfucWsi7oSCTlUKD2QM5+vxFhXt30?=
 =?us-ascii?Q?3zH3khKMQ4c97BpVdbe983AMZP0qQhQsCTEbaSvOZ18JxJVjCLX6Vpai17DO?=
 =?us-ascii?Q?rUHOO1FlqiPvEOS12YKOYg85TVqqnrUBdCMTs/xHczvQkTHPDc6bO6TV+HU6?=
 =?us-ascii?Q?C6/lGbnPFIWAVkA3f3t/slKNhDfrdtNvtCNXgNTyfW7rd2fpZ+amfhxnTr8B?=
 =?us-ascii?Q?lfvqc1f1NuuXHeVO/7EmfSqZlUPaihzlz7DIqzTZnP1FRXupZzMm2+MuetY8?=
 =?us-ascii?Q?rhwK441e/HQP4eFCcSyVONr5h2NQNWuD1USDzBljdOy+EqjY1xAtuQra7+C+?=
 =?us-ascii?Q?P/1DHFZfYQhVRhoKMrClzzPWlldAkUA5owJTKOi12FnnpWIG7JrTLMejtSUn?=
 =?us-ascii?Q?P/Xex1/LbaJ9YjRxYMiMxkzmw0hczUquJFnrLMk55f2tBONbIU6v4wkTvgEB?=
 =?us-ascii?Q?c3Jv04RF6ZC47cOQs6cA5jQ9ttUQqK5/XtdPdY6OgpC6AZihRzG1LXpicJ/E?=
 =?us-ascii?Q?ncwQ2q/m6Fn3TiNE59WFIrtNIcsPIiEHp2I7Yw+2WpmBghc85qK3sZ+nNnau?=
 =?us-ascii?Q?3izuuu2v9Os73fSRWQS9SrRjfYNf8HCSs2UgrMMWFYEQY4d33SQ+wJItM8zI?=
 =?us-ascii?Q?I7eTlU4UQwdfBIWRrpC3O9SP1rfBWbbUE+wa3edxkFWVGpq7lFjMbMOKAfLa?=
 =?us-ascii?Q?9fJJ+bBUmp77UEVw2Is3lEoKXV9JpjXJcS/+LTjIRPIsR3d9VWealEUBD7qo?=
 =?us-ascii?Q?KHdDgYqN76nNJ0BOLotUMrZTtMbHw+8M3QYUWZQvBJU7FrLkm/dm341MMj8+?=
 =?us-ascii?Q?TyfSuNBHySeMcSJh9iMh94jE9nZgZkk67UFJY1MLJ3b0IyzWrYpRN7UjuM6i?=
 =?us-ascii?Q?+pY+yGHHe+FDbxkdg2qwM7L7ndHTxRmlga2/2zOAQMM5/VnqgAueY/hxeiS8?=
 =?us-ascii?Q?CYcnHm181c98sQb6of4em3AlAoHInUGwsjaUYyTJf2YEPVyCcFnYVgsmWyrS?=
 =?us-ascii?Q?V5Tx7H6Z6agbFJBKukwXtk/aGffykbvFjEJvPj4DrAbT9/ZgtIG2A5TBIO2+?=
 =?us-ascii?Q?Tt7Ru3RLWtePJt/Fx66nud+EN9ihvbuWb99ZLB0VWFPJWNiVW9SW9TAo4Sbc?=
 =?us-ascii?Q?ea4eOHv9GO3jIhhj0KF0RUiD99LWMIITzA8yoPFSIxFZIkJF8pC5G0148AVg?=
 =?us-ascii?Q?b1mqKx1RKURho5hSxKs3Y6fUqh+73+oJUJ2XkQ7utiUvyXLODpTnF+zJ9slI?=
 =?us-ascii?Q?L5rQtqQf6cg9xGDDrS0zEhh7cImPkvUKYmANwVsJth8U3t4PfV0Vc7ippUBv?=
 =?us-ascii?Q?fbm0YK1PhWKBgshnWLPnsqm/Ixw1MC7jMnV0aPlZKONloGN1/ksbL0tnvZqo?=
 =?us-ascii?Q?I/voTexWNMD1fgxwMg32VMMAl98IBIxuH2pi/gRos8SxYY8MHUw2cg9/7xPq?=
 =?us-ascii?Q?oL1F0jqhltAQDwDzqx8YOYCz8IExWmL0Q7Ub8EgKDNB5XqSQxW6/RgHv1bPF?=
 =?us-ascii?Q?7tfI1yNmq3JKZs+6UbEXVttXQs8pSC2y2RK4VCPu+d9YbdnFUw3WTt2XYfk+?=
 =?us-ascii?Q?ICgAHrbG7Y6PLSzCA3ujHBFOtppN7v0cN4IPrICfv+W3SolH+gnoxNKIZ+zA?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/WPmiWU85PBchNgUEgAho4gqZWrwU7/Yb67Zs0r59gWVXpvR0ol3yM44+uETG01UvLpSUNNdNw3xrco0rx+JaXRpQqyi6bJ6vPAlkoruk8qS7PETdujfQqtNdwUJ8LA3np/KfB8LwCKIIQP+EO3IC0cJ6j6l80WpIKv+W1TfmhR3W58SA2zBC7n36DTuGF/+5AJssSpA3hoqkJkapdhqfusQJiEH6Bst6ndHTn8jy+KRTU4CnuA8hqSNECr0OKqWL6X3F0a0tQB6As7jm5bPbl6JdLCBBJR5MROg4tjBV4Xi54PIA3QRnlcXJ5IJhdpD77jutpoMnMQoDMPxQ4tAhUNclvkNgU64tzdZwfHwdH3ULJtKmh0K58Ae0RnY6kI8ci98L9sk2I6v6ilbmIZUUCufazXj5ByNM0FQ4+JyNpcqWDMRMbXmBmq6MFQhskQGCUaLtmb5aqkQxPaaLD11L3mXg0YlLLh60HMnDydMsMKYYOny5RVYoMhQPIagWN9N7kDuUSe4kvhZJ2rXcEmqZIQ0Yr+/swXtr13CA8CnSw8hiNQueGWnBFV4DSinWk47Ue1m4jfju81iQcd7VpW7aIYWXiWeBixjmHdx7wqDmpg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ec3e3f-22de-48df-a3d5-08ddc9cf78da
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 09:58:28.0106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OWqLQxCIdKF8Xcrw99Rz8B1vfTsH1v/GEUp/ERh16FZ3xJzDwB/JykvATONEypX0SqY6JDJmdIhwld918eGXq678n/GNy0ItniSJ8zAFZhE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5586
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_01,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507230084
X-Proofpoint-ORIG-GUID: L66Dsg7ncFLEvur8XfEv24HeC6kkIfDB
X-Proofpoint-GUID: L66Dsg7ncFLEvur8XfEv24HeC6kkIfDB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA4MyBTYWx0ZWRfXxTA2acgbStfW
 vQW7oYF9lcAEJZjjG4ESp04m8Ui9fSskwlzpmVVzjhDUr2lOGgHx1ujC+sxFB3niUmxeo97nVa7
 Bid5exymd2Yl3Pj8YpmKoaxgSUfKYkffEVQrj5ve7ksczD6gKg/BALbpS30/PhKDum+zrW5YuYR
 1xEZMM0/Jc4E6aa55O08x/a2ZVUomrx6r2WZISQu0kF3cGF2OH/lKtiAt86J3HA8Fjg4hKSw00t
 XDc4/KJfVPM4QVRkBE6Ptx62c12v9fu8JoT5OSEljXobiCZYWNdDb5udS1P4+qufGNlAhksqxH6
 xnxlnCaaQj0iDn5a9OYHjJ4V8F4A+Hfa24qr+7NgEXvm1ddwGc9kTk6IOwNM9xr0lWZRrmMkPNN
 n5VcK33GqY20RfRVN9H/r0XOpqbKj0pyVbIVvyVWjkGchrU8Xneq4gOrMb5pqRV8qXv2cj+b
X-Authority-Analysis: v=2.4 cv=Ef3IQOmC c=1 sm=1 tr=0 ts=6880b246 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=1-S1nHsFAAAA:8 a=Z4Rwk6OoAAAA:8 a=37rDS-QxAAAA:8
 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8 a=zzIyDT9sRKWamUAvEncA:9
 a=gK44uIRsrOYWoX5St5dO:22 a=HkZW87K1Qel5hWWM3VKY:22 a=k1Nq6YrhK2t884LQW06G:22
 a=WzC6qhA0u3u7Ye7llzcV:22
X-Stat-Signature: u54z5o5r5boep5j53a6t9834sf1wh6iq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6AB8640007
X-Rspam-User: 
X-HE-Tag: 1753264715-209109
X-HE-Meta: U2FsdGVkX19Lv1+d2WfEnCdlm1/hOHECNEhw9LFrmYvFhhpT2I9wdNztGd0HxrwlKvAG4IWJDIWUxj4MtLi6UKXdNe+2VHFY56iuI/dysAEEyP7sxRsTNGUSthu09HsbJMJCymcfYIWCYFzU5dVyti1yPbqeXQkOddAXv0PheEJMXU76DnOAIo0ubfzvbVthLQNhX++FZjaGrUYR3asY/AHVmL3HZeMA5M+3DOEBWtBD6LCMnoZdiWkkK7itnjO5bgF0l8Z+ix18c/kby1QZbgN+RlybwSn9kv86alOwNG4GbXnzR0djJ6RRhoStf+hMbfnfoQGKvLOdx2mdkjHxmWq9LWRqygZYoM1JzIYZVDdwPUcYuJZRdgPd8Mgi3axBpwuxBPUXCsaMiYdEckZAVUW5UbHKnLb1ZaoAF0dIVAzlh0P65DskKwX60DBu4Qo3f2hZ1dzptVLvikumCUh9QXQpG5C4c/n5Ue+HuBQnG4y3qP6L5g+o/v5z2kgp3lJx4dRy011pIuTHXTNagiZtorwWUI8D2i9teF+c6uI7bVuskpz/bySLycV1KR8F6wX2kOPhHMxfm8M0iQa8Hj98pMo3ESbI7IYbtnWJb03ZFPgqTxVvHB+2QpyRM76ieXs6ax559W6e04daS6upJMzXsCYdSjzIF72qJOdfFAE/ij8Levt9Iydv414WGb3AVkeRdcfoNtgAuUW0TKF83TAtkiDF0h5YHuNHTkZugLU9vpUmuqwUCtzYmUhkafQC50ZxjIPD6bcuBAHfObXaYQGRLsS5RnsN/mbYJIpugSRiLkd2ols5UTBY8s5KmFE61wcnxk/JuotJgU5aSuMz4SJld4Q8ooa+guKWl6ZKkoXeEMZoNapaQtB0XuRUftCdTG5jY8oc/lHopt6Mhc3b0AX5UDHysciQGkAHFbI81wW459oO10UNrRlkbwVF6fHDYGhNSPsNvpyGu8Dahm/5bTc
 bWb8V7Vv
 sqYgqYVlIpUeVhizQqDOSKJzzKZJwxsClPFZ53UkIdFOk1E6N9NYSqhMRIZyKEFADin1J2YhYM6OsNU6iwFaQRjkjUaF62xVGsAp6oS4CgOzzVtB92jSEObAQkAjcmvApRb1X9hgbbU/HSHbmh69PU2F3rVW0SWBcll/XHnS8FV6ib9scGrKtHhSjYFBdqO+oX9/yz7FvxA8PRb5POuBqVZFPgyxiaNuOiB0lKoga1f5hMxQjowY6EebNwHmkMWrNpTzwuLsMf2ZdxvuvZKm1TRJsrGwzNa48hweOkemaFsr/CD21wVjG4QMWWj6glIpyC8mP52SWpQLAhB2VHGnr/ETeVM01QibHjyRigu+JwYaTvqeHJJZC6joqlo50AzUgtcVr43o0CD5hzKtGGEFFTNy+QaWw5SHBNdxJy+J1Ixab+qg0rHkM2KM6+TUkcofd7fQF78GcpxH7O3NFT6LVvnkTGFb50Gd2yCYWea76TjINTfhOqgyLR69OIdv5vKy/2L985dFjDNmIwJklMCRHiyFgNxDkgWSQ0cAJrhN8tGI5VOj5HkfHbocFigoKPYAdU8ZCTJ2CoggiA7odS2rJrtEYheTFrh8ZiTLZSCEgjNsmRRv1jsC0Gbb0Az6b0tGa8av4nwF6/WWMAm02DjTQddXsuUrr0s6fDcutw3rDo6/A/GQo+ZK6MxRE91qo2+NQSUajVvSCP0cPFgQGG1A4Qvt6jvrgpj6RTTpIbrl0OD0RVyV/W5Ivlp7V7dE7Lqdf4FzHJjKckhGvADcCKwQYGQQaFnLjBPeXGNNXikibFtPazlSTUQjmYwOICLTu60K8zZkfRIFA8Ye3H27evCKnWvKt72OLT/NxWNKgppkHw5lS3DQ7OYPqvyzdXMrExIRBiGXYwMIAINFeMLg+itJRvP/76btb5cjrmtJh5nHQbfDcIwG5KMLiRVx0bl0Hgigjk+HmJTjQFwFGAdhqZYPJzQaod9i+
 YJ8YnZNL
 1PHMEedk9kM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a MEMORY MANAGEMENT - MISC section to contain files that are not described
by other sections, moving all but the catch-all mm/ and tools/mm/ from MEMORY
MANAGEMENT to MEMORY MANAGEMENT - CORE and MEMORY MANAGEMENT - MISC as
appropriate.

In both sections add remaining missing files. At this point, with the other
recent MAINTAINERS changes, this should now mean that every memory
management-related file has a section and assigned maintainers/reviewers.

Finally, we copy across the maintainers/reviewers from MEMORY MANAGEMENT -
CORE to MEMORY MANAGEMENT - MISC, as it seems the two are sufficiently
related for this to be sensible.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---

v2:
* Propagate ack (thanks Mike!)
* Retain MEMORY MANAGEMENT section to contain the global mm/ and tools/mm/
  directories and remove from MEMORY MANAGEMENT - MISC section, I misunderstood
  how these catch-alls would work. As reported by Vlastimil.
* Update cover letter and subject to reflect the above.

v1:
https://lore.kernel.org/all/20250722192704.164758-1-lorenzo.stoakes@oracle.com/


 MAINTAINERS | 68 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 54 insertions(+), 14 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 507a999f1955..5a9d4c57add4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15741,22 +15741,8 @@ S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
-F:	Documentation/admin-guide/mm/
-F:	Documentation/mm/
-F:	include/linux/gfp.h
-F:	include/linux/gfp_types.h
-F:	include/linux/memory_hotplug.h
-F:	include/linux/memory-tiers.h
-F:	include/linux/mempolicy.h
-F:	include/linux/mempool.h
-F:	include/linux/mmzone.h
-F:	include/linux/mmu_notifier.h
-F:	include/linux/pagewalk.h
-F:	include/trace/events/ksm.h
 F:	mm/
 F:	tools/mm/
-F:	tools/testing/selftests/mm/
-N:	include/linux/page[-_]*

 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -15771,18 +15757,32 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/gfp.h
+F:	include/linux/gfp_types.h
 F:	include/linux/memory.h
 F:	include/linux/mm.h
 F:	include/linux/mm_*.h
+F:	include/linux/mmzone.h
 F:	include/linux/mmdebug.h
 F:	include/linux/pagewalk.h
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
+F:	mm/folio-compat.c
+F:	mm/highmem.c
 F:	mm/init-mm.c
+F:	mm/internal.h
+F:	mm/maccess.c
 F:	mm/memory.c
+F:	mm/mmzone.c
 F:	mm/pagewalk.c
+F:	mm/pgtable-generic.c
+F:	mm/sparse-vmemmap.c
+F:	mm/sparse.c
 F:	mm/util.c
+F:	mm/vmpressure.c
+F:	mm/vmstat.c
+N:	include/linux/page[-_]*

 MEMORY MANAGEMENT - EXECMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -15844,6 +15844,46 @@ F:	mm/mempolicy.c
 F:	mm/migrate.c
 F:	mm/migrate_device.c

+MEMORY MANAGEMENT - MISC
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@redhat.com>
+R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Mike Rapoport <rppt@kernel.org>
+R:	Suren Baghdasaryan <surenb@google.com>
+R:	Michal Hocko <mhocko@suse.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/admin-guide/mm/
+F:	Documentation/mm/
+F:	include/linux/memory-tiers.h
+F:	include/linux/mempolicy.h
+F:	include/linux/mempool.h
+F:	include/linux/memremap.h
+F:	include/linux/mmu_notifier.h
+F:	include/trace/events/ksm.h
+F:	mm/backing-dev.c
+F:	mm/cma.c
+F:	mm/cma_debug.c
+F:	mm/cma_sysfs.c
+F:	mm/dmapool.c
+F:	mm/dmapool_test.c
+F:	mm/early_ioremap.c
+F:	mm/fadvise.c
+F:	mm/io-mapping.c
+F:	mm/ioremap.c
+F:	mm/mapping_dirty_helpers.c
+F:	mm/memory-tiers.c
+F:	mm/mmu_notifier.c
+F:	mm/page_idle.c
+F:	mm/pgalloc-track.h
+F:	mm/process_vm_access.c
+F:	mm/ptdump.c
+F:	tools/testing/selftests/mm/
+
 MEMORY MANAGEMENT - NUMA MEMBLOCKS AND NUMA EMULATION
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Mike Rapoport <rppt@kernel.org>
--
2.50.1

