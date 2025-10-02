Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55CCACAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 00:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5D68E0003; Wed,  1 Oct 2025 20:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD868E0002; Wed,  1 Oct 2025 20:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AC418E0003; Wed,  1 Oct 2025 20:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9B78E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 20:39:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02F955837D
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 00:39:02 +0000 (UTC)
X-FDA: 83951314566.25.A90CDC3
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012062.outbound.protection.outlook.com [40.107.209.62])
	by imf29.hostedemail.com (Postfix) with ESMTP id 36E3C120007
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 00:39:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A0eWSotc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759365540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JGSVUna2rSMem3R3CazjTmA5+U56QfPD6STKNwCngS8=;
	b=R/8GkFBhJFemk5rtaj9fQIWTJM+GdqJBK7TPLgArKK4Egpsan6EeuNlSr5FvE/GGkVVngq
	J7H0bxqiqogYRQujFRxVHId3XdmoO55JjaILTowdJqyNa2m/yJRWAY7cHLq31a7Ndf6S3+
	9RDnd6+mBfh0kQIs6/X4+qXu4Jrujb4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A0eWSotc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759365540; a=rsa-sha256;
	cv=pass;
	b=5smtqB38LoHhJRsrJKpcjOxRczHpFTmS+gSDRwWlgmsj4w7p7ymbWkO3aqaobVYfx4EeWZ
	Ixav5lUImzgAsmSMImhhnthRdI+K4lthYk3uz+QZJ1WbH1m5fYPlGs69YSKUc/kS8PZMWR
	LCbi0nQbzLcNxFQX37f7xwKUAgjFKdo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gl7cLh/oUBixpIrGxBikx01MNHlgBjx4U3miDUReR2VRPCR2e5xjkjUuABPCw5YbHtZ6iAWVkVZwPyYXffq3nMPoP+WafGJxpL9pnCxJSWcqU9DwNcfgzQxYRuJOvyYTFGQ2etGrY7OxkBnUmoDjs39rE4tWebcepgHqC0G1iI/siHOeoMv8oOV8pcHsA7e080tqRMup3ZtIu+zgqrAnSUDnGZAq48g00TorrssJBMH4RQnWd7dqS4M6Yc0/9sdFCPOx3a+x87lwC3MsNsMkGkRARlW5mDXWLg0n/uWXZPk96KCDIKnbYsi/IwUcWfIPOxc3AaMfYI2c/CutspXtZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGSVUna2rSMem3R3CazjTmA5+U56QfPD6STKNwCngS8=;
 b=rvCSoDGokmucsdYJy0THg2V5nxMnbJdjaFK3xan7J2hvukbb/AvEEcosTvVWLtSA5M1izXuTcHQepapJfEG63gcJADmlcFl84uNmNaDAD0Waxe6jqJgRTIWENuxRoUzrdkkxXEKBIfRkIOXFQrQXisOMRm8ZxqWJSOGwroZ3mQJCm9Uz1PiZ8yVwS3vvA4zKTEw5kAG6CBHhx6Sxi2q2zIigXtLd+VuCS60iekPiJupdT3tB/SZW4uNk82Auw6BQsw29f3pNo1O4hxj7ySawVbC5iDTjrweF0Q+1kpKG08A78St5XMNs2fzG9JOcc7tZEwBDv5oyqMZJ7qSoqYH0PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGSVUna2rSMem3R3CazjTmA5+U56QfPD6STKNwCngS8=;
 b=A0eWSotcucYSQdtFV8BvdxwDBuCDSjmCnR3mnquEtHSB+m9coJpg1rYjhiiIecQNP9QDNrYaD+EgcpC83HUhTKsK7F0dcClmprFrHRy01zvmQFjRYU60gPVzdYGURX9867KFds7oYf9Y+ZFnyHnGRXB7AH21amVhDeMnCXoPV7aJsVpoygtyHcpjLbuStrfvAGrYBHQxzKWzV/GmddmRRMnqY5kbGGURpDSVF42/zLkSGHmR9WXJ5DBgb98b5fsXbQ6p22j9Jnywv5QK+StsLDSvalGfIbvR9r3fbFqjrNK2Xqen39AJcduw1xguUu6w2lqrgOJAJClg9nvwo+BMKQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB9203.namprd12.prod.outlook.com (2603:10b6:510:2f2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 00:38:54 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 00:38:54 +0000
From: Zi Yan <ziy@nvidia.com>
To: jane.chu@oracle.com
Cc: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, david@redhat.com, kernel@pankajraghav.com,
 linmiaohe@huawei.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mcgrof@kernel.org, nao.horiguchi@gmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
Date: Wed, 01 Oct 2025 20:38:49 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <637BC0B5-B911-4A79-8107-BD7CDB351660@nvidia.com>
In-Reply-To: <2afee6bb-b2f0-4a86-ba8c-d33b0b477473@oracle.com>
References: <68dcb33a.a00a0220.102ee.0053.GAE@google.com>
 <2afee6bb-b2f0-4a86-ba8c-d33b0b477473@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR21CA0008.namprd21.prod.outlook.com
 (2603:10b6:a03:114::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: 3933833e-b6d1-4113-c172-08de014c10c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hpoceiO49Kytaqyqr0dwBYH1mAe3KLGYH1GIoUP1nxcBqM/3wMOLAVCHdoJc?=
 =?us-ascii?Q?Z4oGscbDK0ukcR+BFbO1nxIuniaXNy5Y0oINMEOOZ5o2rmeQ+/9sYh7diaVV?=
 =?us-ascii?Q?ifz1TnqwXc2af4w068FT4lPviZjoTW7Zn5n63KRUvAS5M/eZJuJg2VK9JyhR?=
 =?us-ascii?Q?7nhUsGV+PGE6bL/Z5Yc+2HYCfxJId/pkf5TszF0fod3VaTX6O0SyUOAgtSaI?=
 =?us-ascii?Q?+CUGx70Wd8IRqnsbMd7Uo2vSNWtOUcVnJntspOND0rY5Jiud9OZabtRvJd4v?=
 =?us-ascii?Q?FzfHpBUdmL1TL5u9VxdaI1rXtS/wCBlAwYTu9OZlPHvComWb704MrMrXg5k4?=
 =?us-ascii?Q?JhrcdrU9ClPPp2I392krWITN/uXlrtUPwhwSGgPJqpef3+sqhYoVK6i0CBPY?=
 =?us-ascii?Q?FwdKovsZRDM67wb16MgiUEJNVZPCJ1Fh5y7j++tdi2x7jSLtxZNM3goCI6oP?=
 =?us-ascii?Q?FahrKu6wuiKNsOVtni0F5okBd2J/9bPHTVS6DcUGBzo749WNzC1Vje0N/TUe?=
 =?us-ascii?Q?TlKkiXYpfXMqkQ2cFX9ccHa+Tq1gJRRaJU6nycN8hPmwgnB9V2cNRu/ZJGqf?=
 =?us-ascii?Q?wQj7Bmi8twbEfQEzgBeYgsJsgrv1lQaGUlmVMY0gYdb1k3b5e/jWaIB5HY0Y?=
 =?us-ascii?Q?3V1chmyzon0PfzapdNi1gi+BHpKtDaIwe1Gf7JEwvY6r+dDqOcTbspiXK4WP?=
 =?us-ascii?Q?Iwv+kcqoHyjhPQMJ7m+k7DHfgVvidZd4yTfhYFWVwbYylWp8HFJCFFe4sh5C?=
 =?us-ascii?Q?ZKte5p2g1XOeuRrHexR4o5PgPmKTbS0R2bKwNB3UKSGSSyAdCddZ5iZ2TP3O?=
 =?us-ascii?Q?lUJyDz3kSKQba/FZvhN/6Z3CNzRoIDxRi/fUh7sZBJQTmjh6FzkzHfcC7pha?=
 =?us-ascii?Q?ZjnahinLnqT69XWiB2VtNQGsqG+zSVreaAP7Zd9iJRPQD+MYgACQTY5j0Qwq?=
 =?us-ascii?Q?yzJ9pkaqkT9NW6D2BUoP8QMGD+1fOnsyqPbl+tz2tsLLYbxn3Ts9CW8KKPP6?=
 =?us-ascii?Q?mRR3vCRlFQrITBHrDq5+cxFgSLKhWCi7elmVFf5MsbKbJz/8J2O3ew1Piyvr?=
 =?us-ascii?Q?n2Ad7VtFBpFt1zXnndwI8wC7zp/DXAweKoCRUaBtaBBSP0oiaNczkPHngKD4?=
 =?us-ascii?Q?xGAM20juqhTFYbpntoPiKV6En4JpX4Ucc96QOI6ElDn9qR5EDYy9O1SSKpeL?=
 =?us-ascii?Q?9bnH6+C0aZ45gy9of2JVMK0gFFSRaEuiHRYWCeUQ5VO+iQhYs3natrdELizT?=
 =?us-ascii?Q?9DHVxEVYobqgixIqD0bOB9LXjU1+kDyyLJse5ZN2nlAvZAMyJCckjuNTMS4R?=
 =?us-ascii?Q?Qjq3aWhzSQ6+1dVySxgNcWBu2sADEdnaw0FYBxnCZuYfvLRX+a8sOsCOMgwK?=
 =?us-ascii?Q?aCP40nRDpvUSGfdMv2iBRWpkbC8M/0WfIfW+amGHMzrNCc1huw3jTSN2DaG1?=
 =?us-ascii?Q?8wfMwApydmW2FFxRgQjZ7KYr7Aqp8zDnHk+UKE9L+l8agh+os+/u4w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QNJxyDTYukPpnkHN8HAAea+2bboZ8mM53fvHsRFsk81zdlMHSbMc8dK9Q5Di?=
 =?us-ascii?Q?q2dezP5gRpko1N0NvsfkzM66piNYUtUlhUPQRbT0VNMCzDGYzsInYNsAHSH9?=
 =?us-ascii?Q?kEV1NCxfve8d3+iSqrRQeL8+THmezXYSlJh5GDraFxzAvd5ZnbomVhlliA11?=
 =?us-ascii?Q?wkczbwwaLL13EBFpEMlPWPwteoQyNTTba4SPsyzwiPEjiXumMrb1rcUbR49M?=
 =?us-ascii?Q?GLULNbaA1paMvA9feeKt2zvpuf2/Tl4ya5ri9hK0hwOPMTcV2EM+l9B51YoC?=
 =?us-ascii?Q?SVhSAjZHJUrbnWyQkGc27zmPcL0XOXsAGlbB35VM8rhKEnU/Emt06Bd6QPgn?=
 =?us-ascii?Q?XrC7MohdwIxfzR2U/vexuDVFwiGPEZ2T2CGLIihQBTh7KxvtcWEy5y4mhUia?=
 =?us-ascii?Q?Iw6Ub2cJ3wjnb+3E0uJFxC2sQ8fgcmW6oq7M6BO7NFNepWZSo60pfa/oHBTK?=
 =?us-ascii?Q?FE/mmK+0oM1cmV0VGLDe8zVaKSk2Uw81/7lCnj3mAoJUftjW1ZPgC8sdo+eL?=
 =?us-ascii?Q?Ffu9tqWQYguLP2ERkZGPAnALydXlsvj/D0Hx7VmImx8z76+AbXw1oKKVOPxK?=
 =?us-ascii?Q?yBs8HSkvond8wz0wEvapKOwEnHTp8G55BZwDeLzRcjyY89LeVkx0Q5Er0HMD?=
 =?us-ascii?Q?TrPs9s5E/+/mfrJI4H070y4QlcTHwe2LkAcOtlN+nvsUvX7hL7JcdJNVJT0M?=
 =?us-ascii?Q?gGvberEMDuA61qe0FusWLKKe26eEN0ETZgu7XztK9zhsHYx7D/MnguXzOUfk?=
 =?us-ascii?Q?SOtiSSZ15uUEFWe5SaxfqP6edbCHTSVPfT9+Mq6rx3W/sC7k+VBUuy/BYsDd?=
 =?us-ascii?Q?qrOYj5t6k4oZQ6nu8UyZ4OvgIMgYCNQ8w1kkdJ0iwfA1j3j1T639DeQIHrWW?=
 =?us-ascii?Q?mr4T6C5DLEDWae71J83nylPywcJx+h5MLenUvcPVjVpWAG/1iM7tPYHsXXM/?=
 =?us-ascii?Q?tCTKnmtY1Y79aLUDwSoyDo+y8CpbeHzLsAPZGteELhhV/J7E+/dUfx1z/Qbo?=
 =?us-ascii?Q?eX8pSxri5LDDwgprcIorezsRasVGzkP+7008iI9HMNql9HcXyDGHG5Ch8rwC?=
 =?us-ascii?Q?CJSL6tCSFOn8d7Ydd1NiZYintnI1BJnml1rzZbpGNq5qCDGT/Uhdq7xBvD2R?=
 =?us-ascii?Q?qPbDoRyjjo/UjT/eWz5WI7S4zTOSIEbf/8CdECW/1b5TVl/hrn6yP9xS/Zhk?=
 =?us-ascii?Q?QjxgqyCpyhVRASXZbOsrxbDIlNev35DZZ1kNnJ94qU/ppha8PbJMUve21LwP?=
 =?us-ascii?Q?C4+Gk0+tCGHrGQ8Umpm/xOaUcEJ1eX4yDsONPte3S9k96pLjVOFfguKfYNBP?=
 =?us-ascii?Q?EHy1EBnHK7E1shVngtV7PVWU1NE/ruaC2fS55b2D/fkmuUkFirml0X18/9K6?=
 =?us-ascii?Q?RtKhmp8W5nl9PCuDsoIa0G8HexwuoSEIYJSX2GHV3b1hSEfHm9cjMu1EyPgP?=
 =?us-ascii?Q?Mrp8Prk2RWmURVCpoF/KWuAPvPtKmzVDxozhCDQOgGzmJVj1mdbUWR16Z272?=
 =?us-ascii?Q?I8G1QianZq9eFThbOFqnoyeSWngdUYZXS+N52L3WSjk5yDJecqjpA3BlaPIJ?=
 =?us-ascii?Q?E5T7fy7fLU3/1lJicYE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3933833e-b6d1-4113-c172-08de014c10c5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 00:38:54.5138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P9YiDxL139RSWFIZSkTjC2pCzZpo86PPUvLL3UAytmVg5bYkV9HyLwyo/PVOs6ci
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9203
X-Rspamd-Queue-Id: 36E3C120007
X-Rspamd-Server: rspam05
X-Stat-Signature: 6g95h63u9kr3brm93q1sq5dkjrwyxf6k
X-Rspam-User: 
X-HE-Tag: 1759365540-992844
X-HE-Meta: U2FsdGVkX19vOgne+fwYqOc/npB4pexlQSDfZc1Elf0oO52UGLEcBN9GETwQvc9C3Gcvz+oNWL5xXH1aZcx2h5qyW84RvbZRMzrR0CRwi8sMLXIi4VqXep3XxWmIS8Ig3lvJ/eQEDHfXxpfy+F52n+99iofTi30nsR8pTRwxkuKGaCN4ogh63ir4ypgtuLwGhvAp6noF95jGsswiIe1n1zARJpqH6WlSuFW9msobOKZ4s8z0yRNwkQTQh0/TrtBNN0iF8NBA/lzCaktEu7+eSjcIk8gK+OSrqjWYmSil7MAfCgzwp6XD1DRrNxwo3byYqISrvUFsUxI15x0jWiBo4ESPGG+DE5tPR1zDZwbwSztRQ8DT+1uT4aolIHeDO3G8iPP+HJLKuxeF20sVPLbKr5+J4OvKSaxUSK1R9d+Xh7Gzc6ca9QgsczKQ2cX67UPCc+XiZ867K7o/7cNdXUMtATPMl3COrsfn2yREhD0SWGiuQs3Kr8jfsQyLcssWwansx4dm24IQ3WLi1dIrrMa+4u+ObQF4oDmj4i6xBbGIjR7KuAXFjQS8SeAZ7nSSwJ+TaoI381d0DTTaOr6oqXw73iTZ0L6KzDT2BeFDY/pw6zzSQCn5j6xPYR2dsEjAhiNIQpDj2iXo8V8M7GjwegI3cDDWGnPJELJzB7WX/5FKA3FqONbXEIInWWq+27bvYh2V88DUx3gEJGvUT/0wFP/ShyEY8T02ObqPhQoCSXv88JaL+TjaBhmmv/ZuTnIBE/c0EGc04JWpI2XW6p3OEkejVidhwZz5vloCCwtBbqmPryG+6moD55o32E728+TW+NQVZ0giQFcHIRsmDrotNgfateMf0WofFYUdeRqbru4Eh3EgHTQ2aigm0Nk0Dq+175hiL9LuD01mn4cNfar5Xj/DWFTEeSYJeoTNyL8osIhD9ZptWvf6Z2e2aawbcsPudG6i62ombg4sH61yZYxTuVl
 SMHgpIpO
 3gTltyZw9pQNEE4cn2mhjhDMhadcPzTixOrCajWZFqGr72ZMKPNE7mmfo3COFzLjmlGuUrCTAre4beHw3IfdhNPVg5JDcFBv7tkBS+0Jjobyq00ca0N8lfTte0/KToJusPvmB5UDdFbQMq8LnBJoa8x8Ar3OWA62mipr6LynvbXbanFt65FfhxZbEvapaP36yGpYuTtY7VkOse++e0KvQgaMFdAj0kWlIhAE32Hlj7AoFaW1C95yymnE4IXIRenXkUcmzGFyY1MXE7LMW2erTxvx7oe2JulCFO1mEmY+HBZTDHhWJFE43hRRhE62segSKwcBQrvQZS655YpU1ikyxwHwzNcfNY5rZbfqsIyZc/vm6fT9xOM8k4fJjqXwU2RzP9DSJyoQHYQn35fg7I/l1RueXZpcx4jhWR1h/SSmbUsNc/Y5TRKLtMVNGEHnPlf2QEACp+ND1hnz20sv2MBiiQGL2l4ZNXZeW1dZcD+aLqoUdpPFRezajVs9hCY21FYxbudlTHCXuMpMyILF9NtbG/w/odFWHC1NT7ZzwXEc0jEfcbMQoOZ6mvtEfRmgh/4fwRfOvrz3LCba1eu9aDY9aL6KN1h8xpImdY4kyRvsZ9r4/Bxd2H9RfAqFfzSKB3rBCRZrH9aR2Wv9+NsFH5gE9oliaJC3DB38JL34A31Mxuss0Q8238A4gmmTsvMSf7fCEV6Fx3zd645Nps4louZ6yxCv2erWmlewDKPenn2gEtPLS1pd2DCkgkNMd1zvqq4bTmt6R4ckM1bofk4/PV7LAUeenP8zrv6dXFhYZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Oct 2025, at 19:58, jane.chu@oracle.com wrote:

> Hi, Zi Yan,
>
> On 9/30/2025 9:51 PM, syzbot wrote:
>> Hello,
>>
>> syzbot has tested the proposed patch but the reproducer is still trigg=
ering an issue:
>> lost connection to test machine
>>
>>
>>
>> Tested on:
>>
>> commit:         d8795075 mm/huge_memory: do not change split_huge_page=
=2E.
>> git tree:       https://github.com/x-y-z/linux-dev.git fix_split_page_=
min_order-for-kernelci
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D17ce96e258=
0000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D714d45b613=
5c308e
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3De6367ea2fdab=
6ed46056
>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b=
7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>> userspace arch: arm64
>>
>> Note: no patches were applied.
>>
>

Thank you for looking into this.

> My hunch is that
>   https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-for-k=
ernelci
> alone is not enough.  Perhaps on ARM64, the page cache pages of /dev/nu=
llb0 in
Yes, it only has the first patch, which fails a split if it cannot be
split to the intended order (order-0 in this case).


> the test case are probably with min_order > 0, therefore THP split fail=
s, as the console message show:
> [  200.378989][T18221] Memory failure: 0x124d30: recovery action for un=
split thp: Failed
>
> With lots of poisoned THP pages stuck in the page cache, OOM could trig=
ger too soon.

That is my understanding too. Thanks for the confirmation.

>
> I think it's worth to try add the additional changes I suggested earlie=
r -
> https://lore.kernel.org/lkml/7577871f-06be-492d-b6d7-8404d7a045e0@oracl=
e.com/
>
> So that in the madvise HWPOISON cases, large huge pages are splitted to=
 smaller huge pages, and most of them remain usable in the page cache.

Yep, I am going to incorporate your suggestion as the second patch and ma=
ke
syzbot check it again.

Best Regards,
Yan, Zi

