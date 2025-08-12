Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AD0CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 02:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94AD08E00BA; Mon, 11 Aug 2025 22:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 922538E0045; Mon, 11 Aug 2025 22:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EA298E00BA; Mon, 11 Aug 2025 22:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A29E8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 22:45:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B4071D9C69
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:45:10 +0000 (UTC)
X-FDA: 83766563580.23.70D6566
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2074.outbound.protection.outlook.com [40.107.236.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 44FA2C0002
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 02:45:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Kv0FXmGV;
	spf=pass (imf10.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.236.74 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754966707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apiVlSwc3q1Kek6WNczydp5lBFByNEaPx5lw0APHYQo=;
	b=eUjY80olVjHKdz+vdGWhZa2C4HxI7a+74j2cfAPAG1oA2crZcdLwUfQr4Fr4Ja41oGfxwg
	1m0gW0/ewIvRmYyurtuFbyLJOUg8k2tDbqPfHXuKZBhU1coxEkW24iTzZkMSjNE0CfcP79
	hjsfMiRnCOBGKTcaxoIgbkxqRmcsoW4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Kv0FXmGV;
	spf=pass (imf10.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.236.74 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754966707; a=rsa-sha256;
	cv=pass;
	b=q6YVrn/JnAY5HUhLjbeb/y6U50UIyccs+jZ4/WII33JyG9oaPnGJkaF1wEu2jNDmkhXpTm
	S60YWzImaDvb5p7WA5xCIv1KivmO9MGcRfoRUAd+LL/VjnL7GkCOLzne5NXZNPGTBPZ+DW
	i0NnI+NgPfuOtTxXWxAc+fois5dhLh0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tgejnzdwvoCtjafmnDL54nn15pysBUx9wGyCe6pHAtQgiSVuCwaqV/MQbYip+SakaUQPDmuNj2GZLx7ejD7SAcDF2u/3RxfqkEWK7WXY/gEug7K7o04QWvMh3PWV07KQ+/u7B05z9RgH5bR+YdsDkGUFHnPr0YXJ/+/akTR8ky7QB3QxM/WG+i//3fXb1zF7W4h2Y7wK6vcqjsvIoADrrRblIxs/7n8u+bPucPCXeWuSFxt0aYh0qLJfluQucXivEVZq1fk9CAr3tvnYHOiKl+B9aLG5qWLI+GiNxUuZeJKZgrgHS+Phl0ye8PH7RRE325GgRa782YMpe1mCNpk75A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=apiVlSwc3q1Kek6WNczydp5lBFByNEaPx5lw0APHYQo=;
 b=WTmLCNvotaKxV9WhukDAlFeKMbkLc3805kfF/xnwfa8C4bHqj/aGkaxGJZ6MqWPSE5tu7joUQ/BelVC0cTmZHAfKBBYF18pk+rurQihd8R1w4ynd+2cNkiZUbAlFyTrAeoky/0xv40IbXRq+ioNcmx1MAyaXgGajlaKWDQmPFKpF5g1vWBRNFKLeK3BJChYsMYc+mcij8ijp3InBdOYG1WedzF+FlDyBBuOM56GSrI/Jpixifx7zb6FQSlULWS9kANq005NeRgt/pQB/UZgYmWS+oCf3oTkfmQ6z4UooWqNqjve+T5V7LBTqnZmkzuDddZBRi4QYwArnMgpnWdbjtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=apiVlSwc3q1Kek6WNczydp5lBFByNEaPx5lw0APHYQo=;
 b=Kv0FXmGV9+FcFjmtYiB7vz/0QMP09XG95e+gLCmnCnT1ibxdw2vIaeAzUgRcHx3n1Hnip71OehzOL95/8hkMi+dEWiXznp/qqA6rgc3gZ1KHgVGoF+jD166hSRwVFtBPke5AUxYPjlh1lr0aI47B8plfJXAWJ+tU2gihnulBcBReSJNqb8RT0HGg/KQrcvMXgxvVnH++Us1QUDVNptVxrSIhEPOkpsOx9BGwuq2eEFnwUpwUdGrt5UmfAPeLiUcV7BrRWwiMbVxrtxjiigmrVghNQAKc31iyK0QZKt6BivOH7jUduNwEDcULYTIv62cge/pMcnUJDVufBs+5pFXW6A==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY8PR12MB7172.namprd12.prod.outlook.com (2603:10b6:930:5b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Tue, 12 Aug
 2025 02:41:03 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 02:41:02 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [v3 06/11] mm/memremap: add folio_split support
Date: Tue, 12 Aug 2025 12:40:31 +1000
Message-ID: <20250812024036.690064-7-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812024036.690064-1-balbirs@nvidia.com>
References: <20250812024036.690064-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5PR01CA0035.ausprd01.prod.outlook.com
 (2603:10c6:10:1f8::12) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY8PR12MB7172:EE_
X-MS-Office365-Filtering-Correlation-Id: 65b46859-b08d-4b66-2276-08ddd949ada5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZkNwbUlzVzUyeXhoUEsvQ2VmZjVvNjE1N2NLbkVSOXpBVlB5TzV6VDR1VzZG?=
 =?utf-8?B?MTdvYkpCd21pSFN3RkFRVjErVWpMTHM4YmRvdkJaTHFZNzFXcEZtaW04YUlx?=
 =?utf-8?B?cFl2aXhkZzZRRlNKb0ZsK2J3MHpkNmxBVmphblAxOEVQOWxmc3pFYVFSdEFo?=
 =?utf-8?B?eXptNlF2SlQrZnRRTXN6ZGNnV01JQjMrSlNnL3VJelc3MjJyRmgxTUNCeTA0?=
 =?utf-8?B?ZERPSmdCOVhtVjdBYWFSaGJ4RmN1ZmtOTDUrUFU0QVZIWkZiYW1KRmZPcmJu?=
 =?utf-8?B?MEJTUXhQT3puMlVBNXMyaHkxeklqUVpGK01xK09QQVdHYTFsZCttMXJITWsx?=
 =?utf-8?B?Yk1BdGgxVjBXc1R3Tm9HYkhPbC90cENmZ1Y4M1RVQUZYMU1KRnFHL3ViRllZ?=
 =?utf-8?B?ZGV1ZVhVRGRqNytoZWNlKzNwYkF5QTFOL3Q4aGJBYVFFN2VQK2ZaU281MkZa?=
 =?utf-8?B?LytsRUlYOVJ4b09jRElOOTJVUldXUDdCZlZaYlFyTkZCK1IzcS9iMUxBRDBY?=
 =?utf-8?B?MW9WbExqKzgyUW1sbG9oaHM3aFpaSTJWTGtIZXdWMzEva2VvOXpmTGQ4ZEhT?=
 =?utf-8?B?akk1cUtrN2lyOFFsSU92UHF5Mnh2SVp5RXhVZEtnTmplWUxuUWdvTlhqRnpN?=
 =?utf-8?B?cHZxR3MwWm5pTUVLTEx3ckwzQ2R5VDV1VVpwZys4d2R2ZDUyOVN4czhFang5?=
 =?utf-8?B?VE9TdWNoYjFWWjBoR3JNNjgvVHRFaEVlL01jRlJPQ2tJMElzMiszV2dtTW5O?=
 =?utf-8?B?Y083MWVsTlNJZ0ZKaTlNbXhyV05YeWd3MjkxLzJMSHBqc1ROQWJsRnJJMDVj?=
 =?utf-8?B?emJtTlppRjRTenZpQlkxWjZTOWtENWRyTzZUUWVCSVFKb0RBaC9CZmNBMGly?=
 =?utf-8?B?UjhsZ3RUemd5dFNndjdZWGJjSmNRWlFTZytCOXV2dVhDUU5MeWdSV0xVRGNN?=
 =?utf-8?B?aGFjNkEzb0RJazF6d3hvMFRjaGlHaVNKNlVHK01HR0FFZzZPNUZwSjdTODgr?=
 =?utf-8?B?cWdwcmdyTFNiZ2ltOWlzb2J2WXUwUXpoYk9JZnhDc3pNVmJES3NYS3hMZDF6?=
 =?utf-8?B?L0x3ZzFsaGFxTkhVeWo4RlN3VHNXMllIWEZwR2pweUhIZFozUDA0SG1iQjN0?=
 =?utf-8?B?MGhEQmVUeWpkWDRsOGFsTWNhM0NyYlNPM1hMUjVzZFVUOXBhNlc2a1lGZHJT?=
 =?utf-8?B?Wi95UlBkdytNSXdWZFhWdHBWYjAvZWVySFQybFFkSHVNSWhuK014UDU2QUNW?=
 =?utf-8?B?VERlQXo5RVNvbU9wWTgvTXVsQit6aUNQckJvWStoY2hxWDVOZnh4NkNvcmxI?=
 =?utf-8?B?S0NWblowZDcrTFpTQlJCQzZsV25pbXZOUXA1M08xTTArQmlkTXVPcllDUUpE?=
 =?utf-8?B?Ny93OUtoYVlJUU5Qa3hpbENQenVsSnZWSCtJTzRPd2wzc3FpQ1pCTlRaM1g4?=
 =?utf-8?B?Tk9CcU5idmFXNWVtTVhmZ2xhQXYxTnJRcHI5THNhbkdzc1ZkMWdpWDU0aUxh?=
 =?utf-8?B?TkJzWGs4U1B2Yk1SbDMvZC83V09UYnllemVVZTdIT3FGUXB2Z244MmRJS1M4?=
 =?utf-8?B?RG5DMnpTL09IVGNQK29pOHpqeWxMYmlFQ1hhRFBqN0JPRkFpMFl5N2szOHI3?=
 =?utf-8?B?WS83RGlRK0FzUmtOK0VFd1lrSUhyeU5LSTBXTGlRNUhlL0xUOUxVempQcU95?=
 =?utf-8?B?YmExNVdDSytVcldvcFJmZ0VncXd1dnFVYktQTDNpaDROcGRMMDBzcmRRMGZF?=
 =?utf-8?B?U3hiSDVmbDZoS1g5NTBTRzhsNUpNMkVUbXA4ZUpTR2E1TGJuaTV0WEIvWjho?=
 =?utf-8?B?MHhKb292bkNsRWFDMTNhZ0hrOU1ZeWUyVERDMUJpM3BGeG5WeXludG1uMkZK?=
 =?utf-8?B?UFliekZKRmQxcEY0THFyVjZlbWN4TEN0UkhHNlJzMkJxYTlmbVlFT2NGdnQy?=
 =?utf-8?Q?oiRXvhaBLpM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VlFZdHVRYTg0eFV0bWxCa3FWVUdqQUlZSjBzOXFVTWRTQTJjSzJyQW16NkFD?=
 =?utf-8?B?VmxsUFdlYitrcnRlaDd0L0s1YjhrMnNDTmhrOEx2cHEwcWZCVDdLbDlWQlpR?=
 =?utf-8?B?UVpSZndlbUNNSSsvK2MvNG9hTG1qS0Z3Um43aXdMdjZOdy8zV1gwL0dGQUEz?=
 =?utf-8?B?b21qbjducDZ4YisyY29NYlU2VkJpSHQvNnBJKzNUSXkyQldQMmErR0xCcHJJ?=
 =?utf-8?B?dFErcktxUXI1VEIrWkM2Sk9ON1k2YWRVb2NpQm1wd3ZhS3BrSFMrVjFSLzNr?=
 =?utf-8?B?OHZrMmdlNDBqSkVVWFRZTGMvcUM3UXV3Y2s2M3B5c3VzY25KQjlHSm9vMjJ2?=
 =?utf-8?B?bkx4bklZa2tpRjlQc2V3VVhiYVplTlV5L3diOUJQUysvRDk1YVhEbXFPYVJx?=
 =?utf-8?B?emhlcXF1eVpyV2x2RWZwSWF0SkptZGFKYitWVzdFbnl6YWZlalo5empBdlhI?=
 =?utf-8?B?TE50aVI0ditoMzZVeG9KUFF4T25acVVuaFFkZWg0WFIvbW0rN3ZGZ2Z5QzZR?=
 =?utf-8?B?Tk5DaVRGaFF3dDV1UUZLS0F3bFJja2g1RDdBbEV0ZllZR0xOUzBLNDJveU44?=
 =?utf-8?B?UUx4dGRXYUh1ZGY5UVRlVjZZc2xxZXdFM3lMcjFoMUU1aWRvZVlvRVFHTG5y?=
 =?utf-8?B?R2V4OEVCam9pK2plS3k2U0ExVGhxcG1uVThobUlJbWJnMWdPdGVMNkxoUWt6?=
 =?utf-8?B?RHRWQ3EyL0NTMWF1YUpGek16OGlIenZkZzRmOFBHd2ZQV3VEQzAxckJ6VUpN?=
 =?utf-8?B?bDZndCt3ODFWYk5zVGk0VnkvenpqRm01Tm9JSGp4eDV6SERDdHluMXJvVVlD?=
 =?utf-8?B?NUkvNnVnalN5SUZmVFpnM0lMVjVrRXBhMzgwM1FsdmdUZlBudms2d1VDaUZn?=
 =?utf-8?B?dDFxOXpEMTV4bFJTeldUakVTV2ZNOGN3RjBWV2Z3SHQ0bFR5MlRmTnJxbXMv?=
 =?utf-8?B?RFRKckVvN0tJcXRtQW92a2dkS1U5b1FUM2N6MW5jNGx5WHdOUGFPM0VBSXFh?=
 =?utf-8?B?bXFaQ25xZnA1ajMrMyt3NlZXY3ZId1o3bnRVMCtDaXNIalVoUUZJUHBxSjVk?=
 =?utf-8?B?S2NlMVM4ZzQ2N3ZJSmtVaHl1L3FRWjhBejJUa3E3azRPbjlYRjQxNnRxRzhh?=
 =?utf-8?B?elI5aWNxdnpJRTFqRk8rdkFPZm56WUk0T0ZpWVdMNnNyaGRqQVNnL1c4cXoy?=
 =?utf-8?B?Ui8va2VFejJuY2VZbktRMGxNaUFMOE9XbzJnb051T1YzMjU2RG1OK1V6UTFu?=
 =?utf-8?B?bTBjNHZ5SnpXU1RzN3dWUWM1ZC94eXEyNEI1YkJQUzh2cjM0VUlaU1RVTUlG?=
 =?utf-8?B?R1pXVFBBaXozVXNEOVdZMTNYVHVhclZQdDlyWW91Mks0eVk0RGYweHZpcHJv?=
 =?utf-8?B?TDJPOWVIMFNNVEJjaUI2eWdtVlZGbmpMY09raDdkWHc4Y0VzZytyYWdNNmlR?=
 =?utf-8?B?SjhqT08wZzh2WWFHWGk0WSszeU41cUtRYzYyTWJOUzZpVythWmY1RGcwOVZP?=
 =?utf-8?B?TFd2OXlqOWlOWHFaKzBZbUo1OFdtNGRmUmlFRnhmRXV0c1JndUhXckx1T2hU?=
 =?utf-8?B?Q0VyMlp5OTVvUnVkRVVaT2dvZGI2Vm5waXJwUGYyL2VDVFVHYW10QUk5L1lx?=
 =?utf-8?B?YzgzOWI3eGs2bHdvWDFHdHVIMDJlYlNWNTFHdDhHdVc1NGtRcW1FMFIxQkdG?=
 =?utf-8?B?TkJkZ3dYMTEreG82VDNUU3dVNldhdTMwc2g5NmQzS0MwbVlITlR3T2tUR3JF?=
 =?utf-8?B?N0hOLy9ucUkrb0RZRldETjZlckJRQlc2REo0czRWdHN2VmdKbkF4V1N4c0ZW?=
 =?utf-8?B?bFZGU3IyRHhHUVdTdkx3TzZQYW9JalNSZ2NQb3EySGZ3SGc3dnlHTDZSQXlB?=
 =?utf-8?B?b0NzT21SOTBxbTB3Y3VnZE11eE1IZmRMTmM4ZFhiNmhrcVRNbVF6TWFFVUJ0?=
 =?utf-8?B?Qmc1cXM4dHVGVm12SlRQemdVL1h5MTNrazdhZ01Dcm5XZU9lWnR2QkFaaWJw?=
 =?utf-8?B?THFhUHd4eEp2YXV5ZWNDR2dtMWg0RDNEZDVKRFd2Nm5YVEdHSXJEV0hubWs3?=
 =?utf-8?B?RVpGQ29sRUQ4OXZxWWZTbUFKb2EvVHorWUtWM1ZuWEt4R3ZxM2NxblRib0Jm?=
 =?utf-8?Q?R/il9pLIeh+CfUcPP7csgHt3R?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b46859-b08d-4b66-2276-08ddd949ada5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 02:41:02.8908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yubcm+FX3kT7uWGwzKK+vHD0Ar0toou9oVRdH/p6z4ZCTxFtxnsysbAUSWNOTP1QxBy55D5xsYoa7aje6bo/NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7172
X-Rspam-User: 
X-Rspamd-Queue-Id: 44FA2C0002
X-Rspamd-Server: rspam06
X-Stat-Signature: kwm9qyxezhkehenojq567p1478i8wabm
X-HE-Tag: 1754966707-442360
X-HE-Meta: U2FsdGVkX181UnHvLTvEQMBQroZrkn8IvhAisqJPNs/yXSenHFzHbuZt012qhXpcGsp1Gbp1sX0L1gHmrGbBwQTac8ncMH5l/tCTAXhJ2F3YqotLPN2bijHUBWpmSUV87Lu2ki/huRzfrCyxb+pUT4YjUYMjbd93b6VAVEeslFkAK26dgssT+C8au2/BmYrZvBSRqvWBef7QHTs0zqlAyQOwEE5HFAPVIxdwdXYEKFALAePyVSyvOjnX+W3MVquutF6H054Fo+KrRyws8R1IANwE1OKfKetZgzOJN33EGm0Ducu8BQhqowlEmerzqdfF4iRifkxkpPFJYGkFNMUGsp44LUV56c2VhcEMBvtj9lZap6RtQFZbyyp/UCwocIyho+1E+xT37puXSq8JvGMLe4aALFBCSpfyh1R9lGl/szI4E8I/frs7G1q2n+FJ4Mk3k3qSvFnmcS/pJ7QW3hQUYm83FWZUFeN8qARa+LdZTkYBRg7omvrck9lb+5SZG5PAHnvX4cE0eO8zGYYm9umoLo9pNct19+cVZU00l9RtvimrRqrGdsLFYlAfShly33WxNscG/hCQ5oAbR8/cBbkXNgFIYOS0nIoG6UEFOOGnxP6iv3oBWh3ayL0+JRpJvD0Qelrxg7NiIq7imenJsAdRzoW6EWBgOVCidQeFfoyPczLcvig2j6EsEmRoGCZV7WiXKwZn5TH3bNFGLmPbE0kfuAz8c2m7Fqek+mIj76/0fM/92GgJGXTSxuWi0pwBdScYIzogEEy/tq3XI5PZQy/6adEEtFaWtkFDWlwzCl0FOY6+T1Ua1JAQLM4qrZmXEBTTeFxKYzLhz4qGNRgVRQuqADm43RWbdiDEQPmRygoaySkyBR9uA/XcVB8g2uWcMckJDQwf12poINyailrmg9v1zAbYKXpOF/yAmsPn5/pZFnNMo45cXrWFeTP3n1TS+et35MX9Uc61tllRdkuCRlF
 IVksj98v
 IuFHvIiF0J+vHQYjLJPoD8Y+8QcHF6Y+0ZRiK8nlTvEb7ZJ3xnAqgsNfn+kaZXoOJPMAZMJuY/4G+Z4niY9TPrNzDkxgpf9q3QAP3MKzZYWPW321OtY2YMKE5Ab39RmTzzjToapJdj0o956ctGTIyrftX255sSAyOd8mR55BOIqCa1F/3nvxpKTSw6JZa6q9pIKudwZRMNLAULX7AMlCKTQ8k/BWJRBsqA72JNTPrSGPHgDKWoCNHiBuw3QU4Pdh1SnNGLRT2fULS5FAQn0LK2lDXJwFSqmvxGvL22SxNh/AWmUbi7JrkePt5fVTzzC8OGX6XkjJWW1t6oiRN0gD+Z2YfXfGffhYLJXub1Krrau6/Sb9ifEFXu6Q5wu7bG57KZ9M5KsVklv31xGSYm/WTsDoLe93TWASFg44JDDhEYb8EvVvu32PTU/AIEZ+Dk368oam6jOPyygOQUra1pDvGAwpYP6gJG5ua8punKqqS/kfinn/o8Tgn145RmgLSHDtF9pDRoGf4oCSBAkO3ejizYfCasFD7CCQyWpjG1g7DS9Swoanj1wRGyroGHho5R1LguyAt4c9ysh/2cZHC0HEPGp5TH/nHm2GwEAXrmBfpfNVuFcAiIOY1gO305uwKJPf64u7VqxUcZUK+ShovG7fJnwDPkghW5FqToZP6KH/JYPpfQTXevH2t4APtTiHrpSSt7JueIiKEP7lCfFCNHCdMzI6tmHMCU6BhNWD+DnOx0wrSWYlzplg0ewxWldQ7VrOoHFrQ6SneHI0L2S+GxhOszPhEECi0sZV8X2htdQ58FAG/HpyuePe+MVDPRhYqRq40tjZENyAOVas7dBcumnRnsq2N4sEQNyzqo1801pTr88JzIAOiEnf3NYikN36IxrvFteZpWAlw8Z5IqHG51/Iy6/pPIHI+a7IsWitXhFa7odlxAhY8pny5+O4WIiqyc91ajUfOp3qlUAcXA4tMJyRcpZ/Zj4Fc
 prTBoycE
 yRhqeJNQjtELo1+1hln+7qxSIGUQgIHLprWPDqxKFt06LLsvv8DZQNXdb3djrzMmZWX5YNfTJqIZziIMs9K481KKazW0Q3CzBimDNW/+atupVolUJ3kqmDBRfpmGY3jQovBI4h+hjZ9CWrpyss7XLlc+b1aZB1wVNm8AuL6dCU+z5HSwPnoQmg3lb5iS5obY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a zone device page is split (via huge pmd folio split). The
driver callback for folio_split is invoked to let the device driver
know that the folio size has been split into a smaller order.

Provide a default implementation for drivers that do not provide
this callback that copies the pgmap and mapping fields for the
split folios.

Update the HMM test driver to handle the split.

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
 include/linux/memremap.h | 29 +++++++++++++++++++++++++++++
 include/linux/mm.h       |  1 +
 lib/test_hmm.c           | 35 +++++++++++++++++++++++++++++++++++
 mm/huge_memory.c         |  2 +-
 4 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 0c5141a7d58c..20f4b5ebbc93 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -100,6 +100,13 @@ struct dev_pagemap_ops {
 	 */
 	int (*memory_failure)(struct dev_pagemap *pgmap, unsigned long pfn,
 			      unsigned long nr_pages, int mf_flags);
+
+	/*
+	 * Used for private (un-addressable) device memory only.
+	 * This callback is used when a folio is split into
+	 * a smaller folio
+	 */
+	void (*folio_split)(struct folio *head, struct folio *tail);
 };
 
 #define PGMAP_ALTMAP_VALID	(1 << 0)
@@ -229,6 +236,23 @@ static inline void zone_device_page_init(struct page *page)
 	zone_device_folio_init(folio, 0);
 }
 
+static inline void zone_device_private_split_cb(struct folio *original_folio,
+						struct folio *new_folio)
+{
+	if (folio_is_device_private(original_folio)) {
+		if (!original_folio->pgmap->ops->folio_split) {
+			if (new_folio) {
+				new_folio->pgmap = original_folio->pgmap;
+				new_folio->page.mapping =
+					original_folio->page.mapping;
+			}
+		} else {
+			original_folio->pgmap->ops->folio_split(original_folio,
+								 new_folio);
+		}
+	}
+}
+
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct dev_pagemap *pgmap)
@@ -263,6 +287,11 @@ static inline unsigned long memremap_compat_align(void)
 {
 	return PAGE_SIZE;
 }
+
+static inline void zone_device_private_split_cb(struct folio *original_folio,
+						struct folio *new_folio)
+{
+}
 #endif /* CONFIG_ZONE_DEVICE */
 
 static inline void put_dev_pagemap(struct dev_pagemap *pgmap)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ceaa780a703a..f755afe533e5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1185,6 +1185,7 @@ static inline struct folio *virt_to_folio(const void *x)
 void __folio_put(struct folio *folio);
 
 void split_page(struct page *page, unsigned int order);
+void prep_compound_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
 int folio_mc_copy(struct folio *dst, struct folio *src);
 
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index d814056151d0..14dbce719896 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1653,9 +1653,44 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	return ret;
 }
 
+static void dmirror_devmem_folio_split(struct folio *head, struct folio *tail)
+{
+	struct page *rpage = BACKING_PAGE(folio_page(head, 0));
+	struct page *rpage_tail;
+	struct folio *rfolio;
+	unsigned long offset = 0;
+
+	if (!rpage) {
+		tail->page.zone_device_data = NULL;
+		return;
+	}
+
+	rfolio = page_folio(rpage);
+
+	if (tail == NULL) {
+		folio_reset_order(rfolio);
+		rfolio->mapping = NULL;
+		folio_set_count(rfolio, 1);
+		return;
+	}
+
+	offset = folio_pfn(tail) - folio_pfn(head);
+
+	rpage_tail = folio_page(rfolio, offset);
+	tail->page.zone_device_data = rpage_tail;
+	rpage_tail->zone_device_data = rpage->zone_device_data;
+	clear_compound_head(rpage_tail);
+	rpage_tail->mapping = NULL;
+
+	folio_page(tail, 0)->mapping = folio_page(head, 0)->mapping;
+	tail->pgmap = head->pgmap;
+	folio_set_count(page_folio(rpage_tail), 1);
+}
+
 static const struct dev_pagemap_ops dmirror_devmem_ops = {
 	.page_free	= dmirror_devmem_free,
 	.migrate_to_ram	= dmirror_devmem_fault,
+	.folio_split	= dmirror_devmem_folio_split,
 };
 
 static int dmirror_device_init(struct dmirror_device *mdevice, int id)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8888140e57a3..dc58081b661c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3922,7 +3922,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 		ret = __split_unmapped_folio(folio, new_order, split_at, &xas,
 					     mapping, uniform_split);
-
 		/*
 		 * Unfreeze after-split folios and put them back to the right
 		 * list. @folio should be kept frozon until page cache
@@ -3973,6 +3972,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			__filemap_remove_folio(new_folio, NULL);
 			folio_put_refs(new_folio, nr_pages);
 		}
+
 		/*
 		 * Unfreeze @folio only after all page cache entries, which
 		 * used to point to it, have been updated with new folios.
-- 
2.50.1


