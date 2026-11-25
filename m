Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61D2606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ig9A9fOU
Received: by kanga.kvack.org (Postfix)
	id DB7206B0A86; Wed, 25 Nov 2026 11:56:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D688E6B0A87; Wed, 25 Nov 2026 11:56:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57326B0A88; Wed, 25 Nov 2026 11:56:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9611C6B0A86
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:56:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1EC90120F38
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:56:58 +0000 (UTC)
X-FDA: 85474246116.26.77F8B8B
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012043.outbound.protection.outlook.com [52.101.48.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0B14640004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:56:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=ig9A9fOU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795625815;
	b=1anUkRXgmp0eo1JUDg7PkKj6owoHTpe8L10xEIOikXJu0Acab/mtzoHqJmXecpDDV2LZDP
	JEJXL4Ervv9h7nBJpelHj+jwiHAgnIf5BUKcl25roOfvyhYkvX4ig7zQYstdDf3hjUhl00
	/hyUSsTdQENh7USEDueNxUDSq/1Sn9E=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795625815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KbOKodvJUyZ1jKWkvW39WJ/BFDQzu540GkqbOaClC+I=;
	b=Zng1BKrE/gidp9+C2yV11zGrdLoQAHZv5roJvIJuEDjmYGD5adQuCiVMfo8KeOwarEn4mJ
	7Qr7KgueCdMo+Lr5ZAJA82Hxr4qpvFq62BduI3u1mdR1OmdZvflv3XOO6IBl84zzYysiA1
	bl4m/9J/wPEY7wWoftOQuX94aLHb0Is=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=ig9A9fOU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y2HfXNq+ZSIYbqrtejF+nVQZWoKpfKV8cz+V/bSurrJptNa99W94uMTsmCjwAt7FnHY5ah67PykpHYnlIi9OZzVUrxb6OUO6cfCIG7Dowgv6QtHuyjp2u277gouBYXBhns49g1/cRrwnLAhSOctWtJV+9kRG4PO/zZCklGPCJ9kwqjVvyyAzXk+iy69mXmAvBKINzBKZqK6k/d86unbwTEmtoLt5MfAidNHoSNNKlUj7IAo8hkgzcpYOYni4diWuQWn+saOvYaqQd+hup69UDqhwI2b+E1fv+DdpakSbrzVOYlGy4Ohib3lmCO39BkXfM3KGL9mXqJVwCscbRd6+HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KbOKodvJUyZ1jKWkvW39WJ/BFDQzu540GkqbOaClC+I=;
 b=RWADG/ohsHJBbIXsb89safOpunPrD5LD138XjGTgpPSmhM7lTx1fGtmYYXm0sA7GvD8m9K9ftmnr4HrcGybVSTuO4ugh1ZNg7j6K81Xg9Ap4l2GTOjuaMvEzXtmJSI7oXc7iJXvFLz67qG9vkHIi03hkb+HwBrUuSR0Y9sRFCLy6etX7cubWeQVT4atx+Nm3w308/8XsUcRpQclqKqy7f7l3KKOflQSvug1ajCfF6w9FvfTO05vzzPYQZ8nNmd8wPwL35ixj4rBv4EivLRVxtvo7pADfsxO+cse7VcuXmHHcP69yChO2xdAE7wgZ4Ql/KQnhhigPLIxakUJlPzMB+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KbOKodvJUyZ1jKWkvW39WJ/BFDQzu540GkqbOaClC+I=;
 b=ig9A9fOUX0sQ+2d1dBDLoGfQf7rMhmykhcWnebWantKCpWGm4/bbD/i75c0/F6UXIF6s5A6EWffsJQ7FVL00iS90oBuqRGAAjHqxp2T5jxidcATGwxokh3sOJ1YR0bOdpcNMu+JKNkKjdSIo4kGcCMyfwUwNg28oKiXTGFykKNjwBtQ4k6VVWEoOFDIr8VOd++S9hR2Z3xneI+p5FkXh4rS1jXp6etQWOaoSLUEzVrtXCA2QuM0ajdow3kcAnQKauUa7vvLGmT7PlejI13oOrPdAdEkhJESo0jpCfpPxoJMbOq7ObnpzC4cLePQk9yFHup5wYBCgMIVskJ3g7wo1fA==
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 BL3PR12MB9051.namprd12.prod.outlook.com (2603:10b6:208:3ba::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.4; Wed, 25 Nov 2026 16:56:49 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%6]) with mapi id 15.21.0662.001; Wed, 25 Nov 2026
 16:56:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: xu.xin@linux.dev
Cc: david@kernel.org, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, akpm@linux-foundation.org, chengming.zhou@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mm_slot: introduce mm_slot_next() helper
Date: Wed, 25 Nov 2026 11:56:44 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <9F5937BA-02F7-4938-AAB9-97ABD4C2DA76@nvidia.com>
In-Reply-To: <20261125084205.345860-1-xu.xin@linux.dev>
References: <20261125084205.345860-1-xu.xin@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0171.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::26) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|BL3PR12MB9051:EE_
X-MS-Office365-Filtering-Correlation-Id: 30a3b848-2009-415c-5491-08df4b1517fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|10067099003|56012099006|11063799006|261021121427099003|261102123227099003|261021123027099003|261026140227099003|261022105027099003|261028144727099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	I6jjwVMIYDaDO+X1vvY7iialpGXH8U3gUdH/+Al+Q4DdU2YrJzPyPmtLY1WEn6KpGemcOWYFo5+OttLMxsv50oTeNpu4qRxN/zPEeyHMDvuu4HqUm2IPtX3oMYT+Lp9HE16Mc8CSkJbQGsAeBQkcB2Rt3YeHNMA0y0eeUV4EvM5FbZiVvDg0qyI0dgoLdCE5BYvSTrsZy63PZS+/U6bIAvD+j04tTt0nwjC1cuXtlaHBnCP/rIwf0n3x1xHfr+hM/c2HDtBUil8x0CrmBkATSDJyiUYZpWS/TBC1E+SwLiqKTH/AiOJ1tjeDgB1rR+Nwi8jYKFIf3/wQPeDSxrm7O/aGsMmyQ1Na5DEAMlf6WWVqEEzZFpHZIRxkT1V9GGgrrL/4ddsepuwY/iaB7a9IDJmKmaN44TPyLlqVd+8cSRGiQ8A7IREaKFjbef+Oik2c23RrWFvQfCctOMf0/gK+I26Mh95Xb0JfuEjZb5ewcc0+R7UehqlI2FRCjVxB9Sm2Uxq3PMLH50gLK+0LPXUk8xMj9+nVwSNENylkIh5j3W/o02PrBx7p4jPFx5ayEPnXFe0k/7sxJUJ5hefADyDIFwGg81bHUqtw54jLOtnYsayO9sW48/6pMIbF8joNPyPD76vBVPKEOcJ1gA2AyoYOBNSO7CrqFI3Lh3CQAXqvl0Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(10067099003)(56012099006)(11063799006)(261021121427099003)(261102123227099003)(261021123027099003)(261026140227099003)(261022105027099003)(261028144727099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BYqxuUWdZSsM0PnNLTH7UAU5oCfUhGbbdSxMVgS/WkRLSHKM7k4qkoS43DiN?=
 =?us-ascii?Q?SbCvfo3bV+eRRBw6wnrDHcl7K0tGBm9qyuoFEAasATjubFHxr/AThomvPqsS?=
 =?us-ascii?Q?kqXJjRUesGyWolVOyeDTAmDM/iZQhiHEDUIWePZKJvtrAyd8cf0hopYUpkvW?=
 =?us-ascii?Q?6B+mUFLVSjv2yt29jWHYOcIeTbCWd5Zy7G9RU8R4B29aPTid3cI/HLnTUROd?=
 =?us-ascii?Q?H1Od/hBexXzeq7RiDLITCbQN7KtEGZWSfMZaJnDxHelZ60tlw43D/gCZPWhS?=
 =?us-ascii?Q?zfOqBjrZTssmKDsd9iMvbM+Yr+MUbiUIWsA+ndcz73Xt6mPv0vZSYoeZWzgN?=
 =?us-ascii?Q?wRYpmXvbjuN2ciOcOD1te5odojgMpphvyLPm6B0F6UqiVlwr/t3aDMUZY4mA?=
 =?us-ascii?Q?4za/HoTSRR1AkAP2DZF/yBAMZ+EFvGWhfwESLidqVdMKw5Gk2sRX/6MCed3C?=
 =?us-ascii?Q?UyEfZLf5HTt5LH80LQqNVonTCZei1QluzRCvkD4SmbzQ3AeLvBFyRuYu8c7X?=
 =?us-ascii?Q?EkBx+0iPrjIVK0Vx2/Xxk5ek6Z3EVDm0SIZHQJch8RtVT9CHKKs+81WjH/48?=
 =?us-ascii?Q?QjlEMi/p7BIlhptKtiDbfbVKsP4tLknZcAr69F9bhZGdnvTM25GuaQMBeH9e?=
 =?us-ascii?Q?rQ3/ez+W7NowLMHTIuWEMQCPa+06LDMeEPH4EtW11Z0MBlDd0r3/FkoqSMKm?=
 =?us-ascii?Q?qwQ3Uq3KWlfQlpvgB0Ts4tJRcDk51/LpibPw8QneOB1IIHhJvebAAKR5oqqw?=
 =?us-ascii?Q?L25nTrRWvGIvdYe+O/B1N7W0C2MQBY+lmkSDp0i59sh/bxLgxY7P6vw/D6wX?=
 =?us-ascii?Q?iTxZZzg+cqeoDu5RmQJVKCVX4AvFVtgUnAmw9iNjMuTUsXVcs3u5enxpvKIy?=
 =?us-ascii?Q?fOjNS+PbDaRcCNyRvmEpYgIVSTE4CLaEAWTOxXmfrlPfnUITFBrqE/iRF6fi?=
 =?us-ascii?Q?6CYU7Yomq1BJqpNDJzzntTbM4HOH34u/ZL3Tv6uIwzdh/5bIIMXExfHeFWi5?=
 =?us-ascii?Q?RcdwKMVzhC5RmV/gudyynxIrLZHazRTCnRzjukBwNlS8zu2XuweCi+RFXmUv?=
 =?us-ascii?Q?t4XH9+PU8mRz4GGF6hj/b8WbUhsXVSwbsNz5yI1IPsvbjPsIfA+j8hi6UUNj?=
 =?us-ascii?Q?S7o4RczCIMBrVP3VEwMgA/jb1EbcIq9ymIvJq/gsB7BzYgMmGvL3IJklu7wt?=
 =?us-ascii?Q?Ewea1BBL+B1kAOQqcT9g9ykMfRIbvVScWQlYSMo0DyduBA+zxU8CdfUEiJ7F?=
 =?us-ascii?Q?W3mYWAgCtPkEKd7XrXC+ExctRTzjoDuDhoY46fd7X0D+snjJeZcHLPr/zvl4?=
 =?us-ascii?Q?gvnq65AiJykWmnO1C6C+ly3gksGsq8lsLhF+46YCMHj+9gt1Eh6Pje1RuIK5?=
 =?us-ascii?Q?g7LZRULoSXDF+KUZQwnsNyOf0MibkXtbG05gltIAUYEVqi0xUdWirNH0/30s?=
 =?us-ascii?Q?8yP4VjJJbzHB0Qp1Q9I3Rpi+ST0PKsvW71AZYiI2Vf9xfPlu4ItuQg9qL0Dt?=
 =?us-ascii?Q?AWJF3Yn1WQ3j0TEUsWt2GCPWr0+ppkA0hYcS7sQPbxc61YEZ1sVT9W8xPwbu?=
 =?us-ascii?Q?fJ1qpCNVoRNwH6sVsOtU6ue9xtNKzbFfr1jz7g9lki0pYuhHOYrENQPUWEtO?=
 =?us-ascii?Q?E8N1n8BIw89OX9yqWFb/QVIGBtGgyGDlZL6nugW8RhgwqRUFiRuIUtZNg6Cp?=
 =?us-ascii?Q?egqz9QlM0MXqg7kBDAe3Bro9WZAwJ5IlyqcnlvNyBpy0021E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a3b848-2009-415c-5491-08df4b1517fe
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 16:56:48.0960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +2F2yXz33Dff9mFI0DfKqM6z++YVGgfz2+YdTb7ZxFtLL73xO+28KAgIQ8lkziHT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB9051
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0B14640004
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xpiz5b5rhnbnebxf1ea141dk95bwjgqc
X-HE-Tag: 1795625814-748082
X-HE-Meta: U2FsdGVkX184uvRaUaa0djg5wt8X2CfpHqFWg2iDPcG2hvP25lTToafwLplTB0V8pHAM4wN8BTV+oEIvrKgCyfYN+vhQ73XSF16roButtGrPu0gIMsd0FU/aObYvBC4aQuZfdXxBk9Cs+CyIyZ24qVi1XX4XomIfoo4ztcSxCLNyblNqeLBjJR51Zd9aH2KJNrNrkLwV075mGAZuVoEdgpyj2YR8Dm3Vu/GIDyU5d0SVGmgvW1apUUUN5CBd7cjYqJ0ZcP10/qh18ISnOCRE3LztOawH0VR8Cr6EKg8ktbJfvo4RSadGSd82t0CALDGESNIcr+9N9+B1abdU9mmIQrMStW2jyGtEP57vp8bGeZSNgfmZMQMejf08GAf/YGOQYgP0El5FapTrWF3riUuIEfq1FcvE9syPXIXRTIz8nEj1nqn+PwBvdiVC58bTVHvQavY82ssrcBw8uwjIB8Qc12NUsx4/NKFgRP5dq7/Uh1uiGMWaSOqXbPVWbXAaO5fWPrdbphwTLychEUCkkYD7pl/w/DXW4RJlTIE9YqsnQb/HMY2mMLaxtOf+8YjtcRTkiqgBcWuMaGWJq+L6kW2c4M46IU6SD+LRRYgJmvycYZ/Dmb4KFGmBO8OeGOrn88078LpLxEj7uc3fjXOJqOI0L4HiM8ON77m9P3ewC653zP2QXu6YJ2oN1FjmMZZrEDRz+IMFOTgiVDqcgin1qalb0e/MnZHT0egD+mdgJeKx4LrbHR5UmRtUf+5MbXNYjvQSm4JkFu6q3kp6b0v0Ku2DQcRRGpXRTR8NF+eXLkB5kGKpKMW57GvraKLO8JLH9jeNl6CwwM8FgdQao5+KF6b+70RJFE08P72yFZo/HprH01zEECm3oQDJZrKQT+z87drDNQZn7+fGQR2+4Eq0js7FnDkA5+ANG63jmy93AhrFa4TsTKvhqfCTNP2su6OjPRzUpBuLVO9reZkPGgyF8HQ
 dtXch7LT
 qpHLVhoGtwLOtaxMmfd87A0Yg72F1rl+z5WWxR+LKLIVePT2bMKUh0M/sFC3hbWSOAee4vwrXzhsADzuQntyGwNYMSLgqGINb0kx/uSBx9ks5YWf9CMzKe+KISPSJAsw+mN8zhnai4WSB53tuSSz9yWn9+foWJdwysNNdduaOCOWrf0Jhgl3IElqj6znYGI/VMrmVR9Vrqzlcs2M2VvhX5LiWcL2YDfSscyWlARc5kPHSPuU+fZRRdoG5i3wYYRo4468E6JHTTHw1FhcOVuYRBj/N3ID55J4BlmqnF4z/szwvQrN/oIoXY6UixAJjGHT+Ui9zbXSKewQw/9jzLMc8P9tIhutAw+kRoDUw1VEMJndbJoDer1BtoAUGbiz9GBPVs45D+/DSr0W4oZVuD+r6nCJdU6GK9T83Dw03HKCmH4ES1pi9Zf2b3Gt0FSOTYKFhaekHsBP28BqxowSFbddEQh8KPvarhPEL+Eprh2hXQVRdYkO7JrZysVoUob9J0iJMjqDWQKbB/VapqdJKv8q1pg3/bW8wdl5KjrsDWfer3I0MDS7xm9v/T6L7GwsgvFARdNptsBulsx2qPABc47D/b+wKZRqY4QwB/OQWZNFGWmSqbIDTAIAFeuYazAerRYOKnRKG8ypwxKUHoz5EinFyu35EZ74hlmNvRwKkNtXD6fS7DFAO6NYBjyeENTunhLgY4f3NCkyccBfF+Cif/9BD+XVtYoz706nGNuUq74oOAiC/k7grp+Qzusq1//EFVLpaNiKE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 25 Nov 2026, at 3:42, xu.xin@linux.dev wrote:

> From: "Xu Xin (vivo)" <xu.xin@linux.dev>
>
> Add a generic mm_slot_next() macro to simplify getting the next
> mm_slot container entry from the list, and use it in khugepaged.c
> and ksm.c, just for cleaning up.
>
> No functional change intended.
>
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> ---
>  mm/khugepaged.c |  5 ++---
>  mm/ksm.c        | 18 ++++--------------
>  mm/mm_slot.h    |  3 +++
>  3 files changed, 9 insertions(+), 17 deletions(-)
>
LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

