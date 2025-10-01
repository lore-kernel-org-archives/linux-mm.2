Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56D82CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 07:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B628E0002; Wed,  1 Oct 2025 03:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43668E001C; Wed,  1 Oct 2025 03:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10B98E0002; Wed,  1 Oct 2025 03:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB228E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 03:02:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6242011B10F
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:02:30 +0000 (UTC)
X-FDA: 83948652060.20.5F3CFD8
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012005.outbound.protection.outlook.com [40.107.200.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id A56351A000C
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:02:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ANPmFU/A";
	spf=pass (imf19.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.5 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759302147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IuUN4x48aHvsGyFOkN26zq8zyMzF1TyzQ330PBwCSaI=;
	b=kebJ3jSGHnyifIItARgDEB/Njzrmn5QYpzS3GREa0cDd/HQQMn6VNGn5RB45gy4W4tzkNA
	c9BQQd0AMkZeWnk4D+ytQjuOJO7+HB0/tpDCEPpp7eJOvDJeA0VCCBBZxGTPjtvgK6Cpne
	+Qy4Qhgvvrzh/jut4gUFdOmDHudhwO8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759302147; a=rsa-sha256;
	cv=pass;
	b=VMREoYVmi6TJZr9VNmRrvORl81Tuc2SZsY1fLk1vRvYUpWD8lenYA6z/HB6PuzrDmWD3YJ
	9I/pEJ3B6J6FZccSV/NdppsRj37VNm3A7nGUoHC3qpYRnyVJ8vRqx41qU/WqvaG7RrHqJc
	m3QVsNjT2cTTHwn4whiLcASz4xojpTo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ANPmFU/A";
	spf=pass (imf19.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.200.5 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AR7LpBWHxIu/FpychYq4et7HKn2NZAZqfaFagJqXFzQpAO2QXt03FehAZbKTRgVXqOdQra+/vZuAHdGJ0fhEP7Yf9oaNPmiD8YoaIpxw+rHH9pAAlQLnun4gOiCVaN/+caI1z8Rm7ewtwaHuMXvCnc06sWD/7gZOwUXzgGUQPa1XOPclWpSHoBX5WW/NPDkJWMyOYX1rvj7x/c8qFxzrVgZJPmOnmVJlSP3icNGL4XLYVR7ri0uQqYKct717v3iOm4MVIsWv3//HE84V5zPcaC7GTV3naplEFK9EufL7HrFM5hLPb5N/g2WieDlrkLASPv1qdKeD69MU/om7hyc1RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IuUN4x48aHvsGyFOkN26zq8zyMzF1TyzQ330PBwCSaI=;
 b=t/1cuYW2d0tY3v5kdGqyXfYWc8DFPfg6aGGUk9CU1G5OXChFtuLpFvAjfGhUWNHz5QO5HIgtRXRCk2tkNz6Lbo0LnWnO5rBYTwLqjY3ZzKUylwodNXrdKehFmm+RpbUI+K9rL6mUmSusBz72Fcnc9EXTbYeaiYSKJyTU93EuoPNlthhe86q4Ki0NzCWGABwIoDM5K7ZHSuxHYOv0Sw7ANTNxa8T5SLBPriK7dF7v70lH5elbp5Bpbay32X65FPmVuuR1sgEqbXqp8HuCSLvfbyU6H66BYvLX1Jzil6nc2HHCt2ECN+AfjTuIBuln112pnBj4a1AN58Z5Jv/VETOj3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IuUN4x48aHvsGyFOkN26zq8zyMzF1TyzQ330PBwCSaI=;
 b=ANPmFU/AUJIi3w9k6FQ0/10w6hEtFev6U732+mDEa+zkT9RkSx+nh3E1IRm6q2HszSiny3uQ02Mi6lzZMyq7DyGtxgmTnXVidW14xEWEn8ujpLIXWkNkRhh6dV9ciXr8qdHRxn+ciI5n9SdshzllBwiSE4ltqUGGLJgRQQhZTsBjbryywZgq0ZswNn1oN3Cplz94ZwAVEaonBkLyDNIiBuS5pjt3UmnrzCunTNP+DiRpb6/L6vo6SKXcJ+XM+PkwemEhJP89zyZGicoSoEhyQf2AG5OnLL/GDXalZWbOl7mPwz+s+y5CQDw55q3+SyboRlVXcjaBQ70IUdaom2+9Pw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by BL1PR12MB5779.namprd12.prod.outlook.com (2603:10b6:208:392::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 06:58:23 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9160.015; Wed, 1 Oct 2025
 06:58:23 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v7 06/16] mm/migrate_device: handle partially mapped folios during collection
Date: Wed,  1 Oct 2025 16:56:57 +1000
Message-ID: <20251001065707.920170-7-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001065707.920170-1-balbirs@nvidia.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR03CA0095.namprd03.prod.outlook.com
 (2603:10b6:5:333::28) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|BL1PR12MB5779:EE_
X-MS-Office365-Filtering-Correlation-Id: 4474ffce-bb11-4db7-a853-08de00b7e9ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rm1iVFMvQkhiektWY3JMdmQyTkg3NVhOVm5PTVpHZWhyT1d4Nm91U3cxMHBl?=
 =?utf-8?B?cUlEU1B4NGtvQ0EvVFlHL2dqSVNQandkVjMrbzQ3eGZBUzJuMnpUbytIUDdM?=
 =?utf-8?B?V09MVjE3NmVpZDlzS2RRQ1lrODdwSkR3dkNHMGdtNVJ5VjZqY1dGSHA5U0NN?=
 =?utf-8?B?M1A0VlY3aUxGRmh3V1JPaWxqdERlV0FGZ3ZtMi9ZS2ducko0Ty9ZcHl1UUJ6?=
 =?utf-8?B?Wm9pWXRaQ2lpcjd3WUdiTEtOK0ppeUEwRVBwamR1VUpqclc2bXRtRXQwbnZM?=
 =?utf-8?B?RTA3d2tLRlQ1d1Y2TDU1ZC9OdDFWQTYxYzZJeGtMdm54bThvVFB4UWFXb0lx?=
 =?utf-8?B?bWg3c01pZkhEOExGNXZ6bEFrTG9HbDlQWTlvUndZMnJkUy9jQUEwVzJUMVQ4?=
 =?utf-8?B?ZDRrdDZiMUlHMkh2R3dpb3h2cXRrUlNXRmxWNGFGT2xHOG1UcHJsUmc3Ri9o?=
 =?utf-8?B?cnlxdGhaNUMwNzhlVEJGQnRZSU9Fd0laTHJxekZ3Mm1udGowQzh6aHVaNE9L?=
 =?utf-8?B?NUV0WDdGTlZaMWN1Y283a3NiUGdVU1ZGdGVuZS81NEJFcUMzTTljbkxTMk50?=
 =?utf-8?B?WDdDREs1dllFL0d5WnVvNERjQjEvUkovSy95VjN6ZXJ5RkVMMnhoYzZTcndx?=
 =?utf-8?B?aHFQKzEzeGd6Z0FRNFR6ZE9xbmJ4TFVNbng0Tk5KSFBGTU0rbW56WXY5VGdR?=
 =?utf-8?B?a1B4bHplNzZ6bGxiM1UzbzNZTnRqdHRtaWxwNk82VWo3Zm05UGUzbTlHUWlZ?=
 =?utf-8?B?LzNWUzIxclkybVNTa1pJTTFhTGdXWW84SnJQYkk4Vkx0WGl1cDdRMWdVS3R0?=
 =?utf-8?B?d0c0eGZTZkxvUXZiekNwU0hhckJjcEdPRktqWWRlZjc2djZEZS8yUVA1ZTBx?=
 =?utf-8?B?a2hFVmpoSUowMktFQ3ZEME96Sk9YNExqSzVVeG9YWFFhWHY5aHlVcFJ0TGdl?=
 =?utf-8?B?RDY3ZzZ1b0w3ajdtNEVzcFZubzEzRDY3ZTc1WEl4cW1MU2d6MFdLNytYcDg4?=
 =?utf-8?B?TndpY0FzYWdMWWNERHdXWnRwK2xHZUNQc2NJN1VBM04xdi9zOGdjdmdPNEFS?=
 =?utf-8?B?VGVlbk1BTXFTMUlMU1FidVZ6OHVlS0hhcmd3WHE5QUFUY1NLTEFBbWg4Z3p2?=
 =?utf-8?B?RVZ5RFNsTEg4TUliNloyMUZTUjN2N1NpMERJUGUyRlJnNjV3Wlp0ME5mSnBq?=
 =?utf-8?B?Z3VLb0JUTXpwN3dYcElDSE0wT1REdFR6RTgwMjFBb0c0YlA2TmYwMUhBSEVi?=
 =?utf-8?B?L0F2S29sQkxNTmpJMjZ3ODJuaGgxNTZYdGZ0Wk5NbCt6aE9WNUZiNm41Zmdl?=
 =?utf-8?B?di9MLzFtYzRUdDFNeUNpdGNyZll0SUN3Tktja1FBTkRZa2FBc08rOE1lWjNX?=
 =?utf-8?B?clB5VUkzN0c4VGZpQ1dSWUtpUlJRRzRLWTA4Ny8vRTIyMjlwNGNhcGV2dnNw?=
 =?utf-8?B?VW9RRjRFNlZlTnlZKzBZMXcvb2pleXFHMFpSZ3ZXUEs1b244bEM5ZjA2M2Nz?=
 =?utf-8?B?OVRhRVpCUlN2OGZUaG1raUtESmJXS01qUXpsTzZYalA0WHRnRUpaSVhKL1F4?=
 =?utf-8?B?UHpBcU1PN01vbHZ1YTRiTlhBRUJRaVFCWDlmdFRTZFduZVdIZXo3K0F6ZlA5?=
 =?utf-8?B?cWJFZ2FsSG85NHUvODNaQmtoQmw0TVo4bzJpcFhtYk5JU3Qrd1BIM3lReTlu?=
 =?utf-8?B?bUFxdnd6TEZwdEFQNlJqbWJPOWY1RjA1UUhNY2x1Z3BSbkZEc0pxN0RsN0ha?=
 =?utf-8?B?SGRPcGlicHFMOTNNVThYcEx1QlMvS0l0TEtERkZWanpOT2xmQlNINUxMdG1R?=
 =?utf-8?B?bGh5NTVIR0VqY0RzYkhwdldWRllzYS9aSHBqZVlxZG1KejFOdXNGVnNSWW9X?=
 =?utf-8?B?bVNndlVnVUF2czZoNFJpZElySmtwWGRLWkt6YjFkS3NtRnVnaWlVVklydUpY?=
 =?utf-8?Q?O8M0QAlHqUji1lwox35pw4eVU4+NmNsE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0JUd25URHRTQU53SEIzcVVCcC9GRDliVVQzelJJZ1BpZEZzSlllK2Jza3hk?=
 =?utf-8?B?SE1abng0bDNURUdGeXl3SU5IYUxlTTVVbE9rN2N0S3RXdzFjM09jN003cy9w?=
 =?utf-8?B?eUlHaDE0RE1odkMvUEFSWGovK2htb2R3NVpDaHp3bFdwZ1lIbnk2Yzgxd3hJ?=
 =?utf-8?B?VjduVU50TlpZTHlhY2MzTkd6TXZ6OWVvTzlrK3JsNVlPcFVZa1Vlb01FT2dw?=
 =?utf-8?B?TWcwYjBhakhGVTM5MjhtOGlEYkR3QlBWQmdxR3ZJRGE1ZDNydlYvT29HU1U2?=
 =?utf-8?B?SXYxajVldjZDcllVWmVmOUxGRVJVSWcrYnlzdFNWWGl0MmpoWWxnYzU4dER2?=
 =?utf-8?B?WWZBZytzM3hYbzdYUERYTisvSGdtaFpZRXdkVHhNRFIrM2RjMitHZ1QybXAv?=
 =?utf-8?B?QlFoWS9Bb1V2QVMxMDZySFB0SVYzKys5S1Zwb05vK0RGWE1raXI2SWFrcms3?=
 =?utf-8?B?TTBtNVlUSXFpK0NIc3JWWnRQR1VHL0owRmdhcXo5S3RyVkRYNWhaY1NkSzlW?=
 =?utf-8?B?eEc5bWFZZlJwaFVHT1A0ekEvbUF1c2FUUlpQQlJ0SDhPT0ZlMHB1QmhXYjQ2?=
 =?utf-8?B?dVFYMzh4eFliSklHNTZITVpNc1hMWjN1YVNxZit5aTNWUVk5MmVFT1ErMEM1?=
 =?utf-8?B?OG5aOVkzM1FNRDY3SVJsM1FMMTV2bEVPaUJDYXBlZlBQZjZ1OThNZ0Y5Y1RP?=
 =?utf-8?B?d3JIcUcxdTAvV1dJaHhyQkFwbXh6Tk1JMGduSFl4MmgxdmVxN01HdnhhQUpN?=
 =?utf-8?B?bkhQd3ZRODVTUHFaUEhvSHlMam11QXVXM25BaEZWb0NwcStoS2FrcUZhMVZy?=
 =?utf-8?B?S0lyMEtaZGdSOG8yZit3bThyYXBsdmQ2aFcrSDM0c04wZGRtWEpKdEwvaWxS?=
 =?utf-8?B?blZrejE3ZEo4QkwwTG41cFp6N01UbFNuQ3R6aUFIK1dPK3BoTEhLcTNrQ1ky?=
 =?utf-8?B?aUhMWFZSd0dZbk53cUNVVS9YTE9vdEFGaTkyc3pNL3VPdFFyMUFid1RGR21m?=
 =?utf-8?B?OWsySXVFZ3hjUDFsdnhCMEZlK3pmNXpSRHVuM0QweXNKa0tnVHh4T1pxUnlj?=
 =?utf-8?B?R1M2a0NSQzk1QUtHWlNFV2dwQzV4Vk00QzdNckZvbWhnWXJHWDNjZWl6NGxG?=
 =?utf-8?B?TXZERHN6SEFYd3dMcjdVKzlzcXM0c0s1MU94c3JqRi9WeEJBUDFSd2hRcW1j?=
 =?utf-8?B?dnhwdVNhQnBvRFd5OSs5RG9SU2t2MGpjTVQrWEQwaWJxNTlzeVl1ZksrRHph?=
 =?utf-8?B?cFhFSDlCeFA3ajY3YzFpbjJZY2E2MFcwZHdWckkrOEF1V1M5QlVlWUZHZjF4?=
 =?utf-8?B?NU9GVy8veWRLbVdadkNsd1hBbzZMMDVHNGlxRUVlcEROd2VFVzRycWM4RGYw?=
 =?utf-8?B?Nk5pR2dIaDdKa05vbjVyV2RPVkg2ZWErR3k0ajRYU0lKdjhRemtHR3ZHeGJJ?=
 =?utf-8?B?TWdFOTlDYmI4VzNsQ3duaSs2VWhMcXU4RlR1aldTWGdIQ2ZoNWNrNkRqWG0r?=
 =?utf-8?B?L0k0czRTd0ZJMmFBWTBCRjhETVB1dGRWcWpjck1Ha2g4b3ZMd1NPWURuNmFH?=
 =?utf-8?B?YjdqVmhHTDZWYS9xQTZIelU1cHBuci9abUNoYmpuaEY2azFXZGt2djBtSzZZ?=
 =?utf-8?B?ZGNMeDc3RDJqd1AxdXJlNC9ZL3RmeC9qTkJHVWp3S282WnBhd2szS1FSd2l0?=
 =?utf-8?B?SElaLzBIL3dIb1hUZzZYSWZZWDVpNUdjT1orVWM2ckNlYitwZUpPa1pnZ1lQ?=
 =?utf-8?B?b1pUaG81V0xab1Y5WU1JNk9FQmltNGltU0kvaHVlZS9kb1B5Kzhxd09tTk1s?=
 =?utf-8?B?Vk15b1N6TXdpOG1YcHVIRTA3NWFndXlEYWtOZHpPY1FIdFFKNXduVUcxZXMy?=
 =?utf-8?B?RUNGSjNKMXFrWXVQanVBNTRCcU5ZNGhNZFdGaFlFQk1lYWs0Y2xSUWJEcGl2?=
 =?utf-8?B?UTdGeGxRRmJOSHFIbGZ3VWpqK0JYT080VGc0YmhQKzdJU1lSd01rSmF0SnBV?=
 =?utf-8?B?VzVLZllQMWFyelBzeTE4bUtUbmxRNHdqMmQrYi9xN05qRWk4bEcvQXVIbml2?=
 =?utf-8?B?WnpXWmJYWnozYkEzWW12aTRjQlJmVmlUVEIrOWJ4NTBTLytYMHZzRmpuaTNH?=
 =?utf-8?B?YjBpQWVwOHJIRmdYQUFJVlRZYTJvVUxYOWZHTVhDNzVsbm9KNThvOENLNU1Z?=
 =?utf-8?B?RWc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4474ffce-bb11-4db7-a853-08de00b7e9ab
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 06:58:23.6443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NWcQfsXKAnfYA8AS03YtXVPLIqF3dYEFOfrQBfo9d7Yd00KfoZ0NWEII8GIvwDu6quzgoWBzVv7E6j2epa46Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5779
X-Rspamd-Queue-Id: A56351A000C
X-Stat-Signature: te4khpxcfyxecrmy3ts1biogwdnjdsw9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759302147-388737
X-HE-Meta: U2FsdGVkX19NcFzuZxcBlDMNIt+lC0jOCsUQJgmVeeOxnoOQ3yVO4eqs518WQ14q7Kdc7p58mwlp8vfHe6XrnWdP/YiNSzc23S9cB7WTVKBy5qX2Y3+S4ZZtpPSpleVZRj6nECmIskLi4tauWezzIsc4ZutCwnvTOMaS/i6z4qjkp8LcQz7/kGaRr/lvNvuNqLQBPem9ujA6hot1dVxJ7WeK8QUtb+1GNPy2u+53HyDK/bzii3HE2Q+Egya+xMDgMtV8LC/qtoh9AFlK9w5l+96QxjgaohHg90i7+QWzEIQ+5PydBj2wU+rSUiNnEZVt9b3nOutgRUNYuGupFF4cqFWGPRQBUuWHs6qhIU//dt3bVLcc+52zyQ7Ks2n36h3fuHiwLZzGQaCSZzR7McdAt/erY7lSufL2juPiZmrYdPRuETWLa/vucOqCUdzDKQGj/TImqjXq1CN07iMoPRGKrTXlFzzv8QaO9vgoZenyiPMVZ0lzni8eyu/26paMDMwgGm1J6N0BRMRvbtfG7ZzI/P6t7VoDCvBYBQ1c/KV1v1dVIVGoNkwX/fHIamKJv/95MaYDK3y/lnYb4/CCrgb+tP5AP/TfMyqT2Wi4sxjWF3ir9EgNpl/Y5UT6WpxZQqwlZZiOV6VDP9qjGGjuzlKyWz3Ou/y/wNoy4xkkqtt1Zwabz6DaXY8gjq5O3/JKvEQFJQd37WjTDTvYNdnKP9OQC27tlSjnT0BwyfhIEOgcsY9igBbNfQRGNmSPGM55z0Js1RKEN3Iy66DxT6y66CltLk7X27AqSRk/rbeXZtIba6u6+lw88pht5g4y7tmkKTuACM3gfmsnJ/QDPbrWV2U9QXjtJtcj3LTjhQrBxRBmhDCMjW22Wl3LGA2alkHwN7NWL+4ZrMAr9hJ+HWb826pJT+F7oiv2muPTU3s6IadELa4jsinpE6/e2CynvqkWiLxfoRJKwHeY3BDMC4Vd1Hi
 NKPpj90z
 R5J+uVrqk1RUst8wiZyCQYP0kZRo6zGNBBGtT5OdvhmD/e3If9StvivHkGBwdcIRovLMDvUGyG9OtybcbpKNwAB6L/c2s+UBaLxmkYtlgirkIKp0e8sWBPoSlHZ/9EQb8rcm4IvcUFMBVxKWWSwD35z9nyZjm+Kl0vkM3PKjo9mjyPomquX+ueIA4AG0JuqDNM053k/MDh0v3YlSEcC4Xf6ZsONWw49M/66KbL2GyDSQsGL7NtJEGogCpD18rOsqXSH0kwAPelxGBYdxSCXtKup05tYoLDX0yVFiB8ws5D5hMYJSOOWsVyNuGY2On2cJYPuqYlGSDy6cL6iVv2hv0SWx+zDUz1irKc0qpBQdZ5zCsVAzvKZkPU0qC+St4HjaxRXtM4OjbanMiPdqCNkzx4g8N2MUrqws+MMlblPMeDn2FX/vSTvvmXWRz/mYEfR88+p7Wps6DzpYZRryrZ7sq1BCaoEmR/nR2qsfDhERMCCVsc9/rLIV5vREUKmTGX6lJUw3jmtuWn7hYT/a19VzxSlY3Rw37HLJnW4gHqtNjF1u6pqw86fSN9Y7NG2zAtO+geT8aBeYxy0fHmzvUn2j30G6y/ctWLYddva8RdusROaQfxWOr21VTyfjzY5p1gROdp2YQo2EQO8SXZ65TvuNOKGrKpb7rUCfssFJkEkkjM4XwH+8BNpVeecnl7VqZtxxJz7etahQCCEzsbHrZnRHrwUx5U61QVz0aQ6/DIuHRjrI7wn57TAYYdk7WNBklC2TA+w+QEST+3S9ENtjLAdd8iFsiSp4+TPvlw2l2QczVCf+2OtROfbyzc/8D2H2XIxVsD+QZEcB+zUrETSIwyF3vvk1tX0icVqWiG1oVF8OJwQcedtG+w+EkVM+ead/tE/IzRe7NHsUJxRZ9S+Lyx45QTdjmH2n3n6NO9VuAcWiwqi7Giejy3QQKf7Dr5dYIocw2CrEBfCm4bLkQGgjT9qAJoPLfGzSu
 3GhgLUFy
 qcEVa/t+sobC6tJibD4db2bZTuoENt2kFxDAAyEYQXuDuhWNLgmOPEKtxA65ZNrtofxenf7Ex/m12aMKP5i7ZjBPYTOUhKs+lmvFllgBA/foofJmuJvreg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend migrate_vma_collect_pmd() to handle partially mapped large folios
that require splitting before migration can proceed.

During PTE walk in the collection phase, if a large folio is only
partially mapped in the migration range, it must be split to ensure the
folio is correctly migrated.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 mm/migrate_device.c | 63 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index abd9f6850db6..1c70d937ba44 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -54,6 +54,53 @@ static int migrate_vma_collect_hole(unsigned long start,
 	return 0;
 }
 
+/**
+ * migrate_vma_split_folio() - Helper function to split a THP folio
+ * @folio: the folio to split
+ * @fault_page: struct page associated with the fault if any
+ *
+ * Returns 0 on success
+ */
+static int migrate_vma_split_folio(struct folio *folio,
+				   struct page *fault_page)
+{
+	int ret;
+	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
+	struct folio *new_fault_folio = NULL;
+
+	if (folio != fault_folio) {
+		folio_get(folio);
+		folio_lock(folio);
+	}
+
+	ret = split_folio(folio);
+	if (ret) {
+		if (folio != fault_folio) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		return ret;
+	}
+
+	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
+
+	/*
+	 * Ensure the lock is held on the correct
+	 * folio after the split
+	 */
+	if (!new_fault_folio) {
+		folio_unlock(folio);
+		folio_put(folio);
+	} else if (folio != new_fault_folio) {
+		folio_get(new_fault_folio);
+		folio_lock(new_fault_folio);
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	return 0;
+}
+
 static int migrate_vma_collect_pmd(pmd_t *pmdp,
 				   unsigned long start,
 				   unsigned long end,
@@ -171,6 +218,22 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 					pgmap->owner != migrate->pgmap_owner)
 					goto next;
 			}
+			folio = page ? page_folio(page) : NULL;
+			if (folio && folio_test_large(folio)) {
+				int ret;
+
+				pte_unmap_unlock(ptep, ptl);
+				ret = migrate_vma_split_folio(folio,
+							  migrate->fault_page);
+
+				if (ret) {
+					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+					goto next;
+				}
+
+				addr = start;
+				goto again;
+			}
 			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
 		}
-- 
2.51.0


