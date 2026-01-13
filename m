Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3FB5CF45DB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 01:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D87156B0005; Mon, 12 Jan 2026 20:13:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33EF6B0088; Mon, 12 Jan 2026 20:13:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15CA6B008A; Mon, 12 Jan 2026 20:13:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B0A006B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:13:04 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 430348EBE8
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:13:04 +0000 (UTC)
X-FDA: 84325166688.06.A819853
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by imf10.hostedemail.com (Postfix) with ESMTP id 36524C0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:13:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="eM858/TH";
	spf=pass (imf10.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768266781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlMW/sAKlnR+cXBQJ/gvV3WofZmCrfNSqPBMfs9dIiI=;
	b=htzA+/XD1iZWjU5TFtSQ1kiceKxbpMNanwDhbnZeXeBoSYAecvP0jXgxett11KI+BTGlTZ
	H5/gnFaxHpmEDYC9l8RDVORxHE4eAn+MIdr944TpTfNdAxxmYOjQpCDAQjyqxW9S+N6sXV
	uTF3rnOLfKNx8CsT2cctRKg/+smxRkw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="eM858/TH";
	spf=pass (imf10.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768266781; a=rsa-sha256;
	cv=pass;
	b=tpUn1HmOZsXr0Ng7yEy+h+Bfmt3COy0i2PsQLs8iFciIDQcfETWAHrPKMT1Y5iJ9xgp5YN
	xn0ec+35mVQeECvzF+P+xbhED5yIfaimQl8skHpsh59QNrtryrInX7qtS4qamB+JEHbZAO
	VFUKvvlwUUQRgENVR7q3A7d4P4P/lsk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FB+RuBH3SFKBByRbgRbjgIty6CLDppINTkvQ2RY/NuM7sZ4HhS+9RtJMGgdd2CQ1olx0OAo2fZLTsteYm3TMenWJc18ux100dHiqzPf4JYtK/iRR9vmoYhxKUJZ4x2uFM0wg1o+DbWBjwPL0KrC7V05UzAFJ60kDOZgzE7POc3oeLRYUhUaGJhN+iWjZj8JTn2yDonlG3KLjsSps0Dx9ZOhFfgbLZmvSrjqT39Gi5k4sjlv2OtNi3/kvSpKI0X59Rzr90Z7f2M13ORI78ABJRq5/syfFWqK+CUtkVPO+rey3nMVrobP+QKXz25NvZBq5nCCZ+fQcDqvFboD2u4MJmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GlMW/sAKlnR+cXBQJ/gvV3WofZmCrfNSqPBMfs9dIiI=;
 b=q+KIGZtqZDqkrDp5rQRFTUG+Eo9sn7OVq7CBV2AtQh9uB+S+D/W9wefUtcrkVDoEiktaUozyi9miH2TxK/bYgpBXxOBFWm4NWB8oXQYp+A4C4FxYIPp5n9A2oPzA2f4lc56Nd6smix3cGxg+kg0tP1Z+1TdwtJpvXPRDE8JruPhJF0th92bRs7rFXrGcqP2/0Aj9+zHHWz0i7sXvb6cfmSeoUZufXZSetGyxerxvzqLwlCcGU0q+XNHKxiPSUjoS93T4JCZy4DvXgynNIfcrIKxHV2znEVujn4MJJpbwrCen+r+cdcd/ynZVUyh1LbM0sB30btJaLRt0+PfqiMtxWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GlMW/sAKlnR+cXBQJ/gvV3WofZmCrfNSqPBMfs9dIiI=;
 b=eM858/THy2cnhL46YsBxKLD6q4Gug5/tea3RpQWP3oerlrWTmO4ihC0WyKgJS80daqac40nwZEvPAJNghs5tQdXI1luaRUknX/eIcQexhxLP6gER2YF16uImb3hsFHX3cDEVG1rVPXtO0ztmgnZzFKvWUCYMQ+n7BwobSx9WvbL3owYPtvevIizGOZRNKg7pZ0ET37MR3MBaoiOjELpaE+qMJXqWztTB5mX7yUX34Px+nvmyzU/msTeeWoipjVOEP8E5NU2qQBRy+ak/NU12BsENXTV9vYd48EB12bsFZaWFyT7FpjLhL+YLeA9VaWDPCUIEcm9Qb6hh8d1cgcoMrA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DM4PR12MB6039.namprd12.prod.outlook.com (2603:10b6:8:aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 01:12:56 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 01:12:56 +0000
Message-ID: <4bdf72ea-0b59-41c9-beb4-8072163d567b@nvidia.com>
Date: Tue, 13 Jan 2026 12:12:42 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 0/8] mm,numa: N_PRIVATE node isolation for
 device-managed memory
To: Gregory Price <gourry@gourry.net>
Cc: dan.j.williams@intel.com, Yury Norov <ynorov@nvidia.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-cxl@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, kernel-team@meta.com, longman@redhat.com,
 tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 dave@stgolabs.net, jonathan.cameron@huawei.com, dave.jiang@intel.com,
 alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, david@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 yury.norov@gmail.com, linux@rasmusvillemoes.dk, rientjes@google.com,
 shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 baohua@kernel.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev,
 roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
References: <20260108203755.1163107-1-gourry@gourry.net>
 <6604d787-1744-4acf-80c0-e428fee1677e@nvidia.com>
 <aWUHAboKw28XepWr@gourry-fedora-PF4VCD3F> <aWUs8Fx2CG07F81e@yury>
 <696566a1e228d_2071810076@dwillia2-mobl4.notmuch>
 <e635e534-5aa6-485a-bd5c-7a0bc69f14f2@nvidia.com>
 <696571507b075_20718100d4@dwillia2-mobl4.notmuch>
 <966ce77a-c055-4ab8-9c40-d02de7b67895@nvidia.com>
 <aWWGZVsY84D7YNu1@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <aWWGZVsY84D7YNu1@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0174.namprd03.prod.outlook.com
 (2603:10b6:a03:338::29) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DM4PR12MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: b81b34d3-b566-46e1-c002-08de5240e25d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aWJzb1dMZ3VzSkhlVFJmL2RhaU5seE9nT1ZxK28vNEczWHpjKy9lOGRBa0xy?=
 =?utf-8?B?bkF2NTQxYnkyOUYrZWhHRkxidVdHcnl6dVkzVEhuNTdBNnBzZXpSYlVRUFJj?=
 =?utf-8?B?RGNIbmpydVA4cDBSRndXelo3MCt0YnQxeE1Ld0NQZ25QSit1amRJcGVqQ3hX?=
 =?utf-8?B?VWNJVy9ud0VYaGppYmJiSGdGYTd6VmlQTDE4T0Q0Y1lIWHphaFpKNUN5dVF2?=
 =?utf-8?B?cGVDdldPZm8vbWFidURmMC9KdXFPUGNlRkkyMVJ0OWV5b3ZZZ05WRWswZFlp?=
 =?utf-8?B?a0JmN1U3eHh1TWVpRjR5aEN4dkRSK0Ryai9UZklMUyttUm0zU0xrT1hGckxS?=
 =?utf-8?B?SENwdmwxNkd5c0ROR0VlYjBxK2tJMDR5ZzRHbnViM2VRaE5QWW9sYU5yaHcw?=
 =?utf-8?B?bEZsL1VISEUwYllhOW5oNDZhL0hlL0FZWDRBYWVBMnFqaHV6T3NpcWFOdlFS?=
 =?utf-8?B?Mm10S1RQaEh5WCtEektieWlwdDJveEhMVDJsWUo2Y2xZZkFoZ21vUzNPcmlO?=
 =?utf-8?B?WTZxMldjZnZiL3BtZHVpR3Z3UkhTdUkrY2FYYlVQWEtoRGFGanZhT3FZYVdu?=
 =?utf-8?B?SWFmVitEbUM2cGdOcUlFTEROMWhvVDh5N0kwM0RaQjdqeFRBZTZyYXR2ZGta?=
 =?utf-8?B?MVZVTVFkVnV3NmxIbDF3cTRPWkRQK2Z5UU1ZdUZvVEhoWncvUUFsU2g3dmJ0?=
 =?utf-8?B?NUxEYWxTT3Z6TUlid3RpMHJZMGM2OTE2MnpLNFpYb1pBMUZOb3VrQWt3RmNq?=
 =?utf-8?B?ZmZnYm1ONUdEbk94NnJ4UzFkSmNtb0xPdWxiU2JWbE11QVhURExzdTVYU3ZV?=
 =?utf-8?B?RzcxRHR4dmNvSGQ3cXMvblBMZ2lua1NwZGJOa1dtR2Fod1FzQUlRUmVRNmY1?=
 =?utf-8?B?eFIyVXJrVjFXYnptQkxoeHRmRVVodGlvc2tpTEdreDBqcGhYVjlzcWNGbEE1?=
 =?utf-8?B?RDc2K2xyeXNUQ3NKWHQ0dGMzSWJRai9UQnF2ZWgrNEVqYmNQK3AyWTUxOVdE?=
 =?utf-8?B?dEV1dldaam9qekw2b2tPaXRLQW1UR2hIcmhHNll0TVBaQWMrek13S2YvZWtn?=
 =?utf-8?B?M2ZUWTFXVHNGVVlTWHdLOExpaDkySDB5TGJVUTYrREMrS056S2plbHBjbm14?=
 =?utf-8?B?aUt0TExnY29SREhzTXBqOFdvME1FTlhCZkxxdlZFY0pWOFp2UUF5ZnBTNkNG?=
 =?utf-8?B?VVFiVkx4ekFQL0ZnbDcwYjFhcThoN28wS0NKRngvdUR6QWRMZWp6ODlydmV0?=
 =?utf-8?B?N2x5THFhR09MMk5BbTlkU3QvcnVtdGNweDJpLzBhNlZtcWtxeGxVYkp5T1hZ?=
 =?utf-8?B?V2x0L0FRV0RkRHRFY0F6dzNISUtKRW1sN0dzRVFma1QzWnZRS21OV2lCcS9Y?=
 =?utf-8?B?emY4aWJ3cUJGN1I5M0F0dXNpV0ZWaXM3RC9HeUhyK1p6WlBXS0VRRTNjUmo1?=
 =?utf-8?B?dEpqdHJzTExHdXYxdU43eVlXL3BiWTM4NjdDZTkzeldNZVVkYUtWZkdkdW1N?=
 =?utf-8?B?Y1lmWStxRmtKekJkS0pwazh5YXlwMjhPOVlMMzFKbXZ6dlFmcFR1eFBoNDBY?=
 =?utf-8?B?VnJYdlB3TmdqdWVSeUMycGdBeTErMlRvVTNVK21TdVB2dThCMUxQSE8yM1hM?=
 =?utf-8?B?T1BmWC9zcnp3N3VVTmFRMElwdFdUbEVlL0ZUU2MwTGkzZFBZK1g1WndYNE5x?=
 =?utf-8?B?Zm1GYWF6WCtndy92SHhQZXkybmM0SStjZExVcFVZdFNiK1hzOFpIYkI5MVN1?=
 =?utf-8?B?bHJDTEFCUGFZWWFZZXVXdEcybUxYSWdwbkdaZW1ZcklObW8vUlFFWDliSmpU?=
 =?utf-8?B?aE5hRnJpNlJxTGthejFzZHZVRUlLNHpYRWwvVWZ0dWlIdVlmOGlwbWtXMGFU?=
 =?utf-8?B?Y2FPRHFyVHdkOU13SGRRbjVXVDdDa0ZSaWpzUWZBdjhTV0N0aEkvd3hHdnRn?=
 =?utf-8?Q?jZhGU1Lje4xAJ4YDzWZJUtYyfZtwp53J?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmVqQXQ0NUt5UzNJd0hPaUIyazR6bnVIMjhoeHpHcEF5bm0zek9UZ2dMYkRp?=
 =?utf-8?B?UTh6YUhyTGl5ejBLcE4zWVA3cExNU0JGUGFPODJmeWs2Vk0vcjcrZFN2N0Iz?=
 =?utf-8?B?SVlYZEV3UWdGQ0V4bFpxdElVTU9oR21UOGVHMUlYbDNxYWlqTnRybFVJNThh?=
 =?utf-8?B?THB6YzVxTTE4dWRtUFk3MFgzOHZ0aXg5YXlUWklrUkVXSzdlSmQ1eVZORlB4?=
 =?utf-8?B?VFRDZFBuZUQyOFp6UXZvMnJxek5DOUJES3J2ckRjOFBoeXB5MGU5dWs5ay81?=
 =?utf-8?B?Qnd5bXRXdzZOb2JhT1lnTytxTGJPRGpTWGh6am9XSWt6ZEMwMDhQRDFOOWEx?=
 =?utf-8?B?eHBBS3RJTTNrK3dCSkVSaEFCSjg4VFZ6ZUlzZW9YTkhhTEcyTG5UTnlyTVBP?=
 =?utf-8?B?Mjg5bURSN21iaFlJeXpQOTlJYjdjTm96N3g2d0VQcVpUMEk4NVRHYmpNSEx2?=
 =?utf-8?B?SEJ2R2ppN0NlaGRWdUF2M1Q1NThBd3QvU2t2Q052TFZVSjlzVFN4STBLWmlt?=
 =?utf-8?B?Z2ZUWnBMbEdmMlV0UEtvaEkzdkszbFhXUnh3aHEzN0V2cnNSYWpBdElsekc2?=
 =?utf-8?B?SDVTSEV6VWt2bU03TUFhKzgvOVJjYmtpcXpWclMrd0pnOXA1SUpGTWlGSFRE?=
 =?utf-8?B?cUNMUG1KblNjZDdEWXJMbGF4aWk0NVZzeUlnWlNZeHc2SDFqNDFNWTZoNGhl?=
 =?utf-8?B?bEtWOUNPbXhKQmJYb252Z044MFZSOE5XaXBEWk5nWE16SkxCL05zZ0I4T05V?=
 =?utf-8?B?QVVzdE5XZ2NYVmRzeTJFQTRESlhqL1MzMFlNZTB6aXk3WjI5ak0vU2J2MFFR?=
 =?utf-8?B?cFVMM3hpZ1RGRGdpU081ZDFXRVVVdStSN1ZEeTZhclNVbFUxa2ZOaTFENHhZ?=
 =?utf-8?B?L2R1M0VjVXE3bUdxbytMZzdXOEhsWUFFRldjVjVpeUs4N016WUFCekxrYWZY?=
 =?utf-8?B?b1g4bWNJU0k5LytJcXpuY3F6Y3VLMHdnSmJEc2VsUnY3VDBFdS9QTGp1N0dI?=
 =?utf-8?B?N1BxRnhsS1lBNlRTT0F3VnpicEk2NmtMditVL0RjaWxscTdqSWVaQTA3QlVK?=
 =?utf-8?B?aGgvL1VXS0FRbE0zSy9jQTBXMU5tdEQ3VGZiRlBGS0ZPNDVBVU90dzBlZVJl?=
 =?utf-8?B?MUw1QzlramZ4TzErUkhZU0ZEUDBQYWZ6VWVtWndHbk5vV0tqbmJlSXpkeTdo?=
 =?utf-8?B?bG10dENrMXBGamxuZ2ZwSEpKOVNWQnpBSFdhRCtGYnlwb3NBd2FaQXEvd0V4?=
 =?utf-8?B?VHB5MmRVS3VCQ3pDMi91bURheU5rRU1Ccm5oZ1NMK2xnWVdtNDJDWjFDNWk0?=
 =?utf-8?B?Z2tRbnI2Y2VUUFFTaU1lNWV0WDAwSkFvYklOSmk3T281TENZd3ExWXEzTHFC?=
 =?utf-8?B?U0xua2U0SGZhZXY3Z0JLS0M5S0dIamE2Yy9hRkh0M1dreXlFZUluZFdtUW56?=
 =?utf-8?B?SDM5MUhaTnYwMVJGNzdnZ0lRUVJHZ3RBVlU1Ump0SEE1SkpaU0FEZFBFcVYx?=
 =?utf-8?B?NnltbTdvNDd1V25IY2oyakNMdno5eGFZODk3YTlscy8xZEc2cWtXRkxkUjFW?=
 =?utf-8?B?cTkxSzd0Z2V1czhHRWpVd3VtQnlYUWxNZTFRd0ZTSmpHKzVZU21DWWlvdHUx?=
 =?utf-8?B?bTlXT2g1emxuR3hrTmgxUlhUVG4xSW5TYmFiMXd3MW5HZU1rcjhpWDdGenBE?=
 =?utf-8?B?RnY4V0hBS1JXb0E1UU1Xa1A2dG40YkhHc2xkRTdNb2xFb3BBcm15ZDBsNWw3?=
 =?utf-8?B?U2cwUmo4YnpscVdzdkJRYUM2Tk53VmlPQU1UUnBnYmxKQWk0clo0dEJpR2Zp?=
 =?utf-8?B?U2lBUmtDWGxZaU5jT1NHa2o3dlV5U2FzUC9DL1Qwa0xZK2FqSysxVlZnK0pk?=
 =?utf-8?B?cWRiK3BOelE1Sk8rTk5DMDM3RDlHNUpBM1lKdnB1bEtEK1hsVEVsNGt3eGVN?=
 =?utf-8?B?cnBJaDBibzNrT3cyRzkzWHN1cG5pQWNUYkhaNWZaOXhRcHlSWjFDTjJBMGRE?=
 =?utf-8?B?VE45QWRwV0N0dUpjWG5PcUlXZ2hkdURmTTRZTUEzS1luRERUanVHM3pNSzVB?=
 =?utf-8?B?T0dTN0xiak5zRlA2citLQ2hrdXV6Y3l6eDlpZnBhdG1oa29ZMEdtU05lZko2?=
 =?utf-8?B?aFpRSmwvaEtiMXFUaEZQQ21VekpnbWc5VnJmdytheVA1anlHTk5OcDBrazBp?=
 =?utf-8?B?aDVZYmIrRGpRUWRMY1dPZWc3dlYwc1hycVZIV2czSnJLTzBkZEo2VjBRL2Fo?=
 =?utf-8?B?WUUwSW5MNjhQL3NGWUMvWjM0bGpqM3FCdGhneHNHd3RGemlNYXlDWHpCOTdj?=
 =?utf-8?B?Nzk1RzFsYnhzUGgrL0FWZy9tY3RpY2syM1pMZ29PbGhwcm5lMitGeU9Lc1pR?=
 =?utf-8?Q?YumIbdpAQaq5xmYtwRn334ONKv+ZIX9BUVcVy0l/Wsnxh?=
X-MS-Exchange-AntiSpam-MessageData-1: vsx9M4aKgyLL9w==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b81b34d3-b566-46e1-c002-08de5240e25d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 01:12:56.4157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q8cqOPaMMRs+FScm39w85l2DQHopit+9IRs2/GX0zuTly/zPWEDdR419ZMVQEMiY+8HyEuMfn8zOwPX0Vu/n1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6039
X-Rspamd-Queue-Id: 36524C0005
X-Stat-Signature: w38a8abu7fw3zq8tyxnu87h8bhuxggax
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768266780-911112
X-HE-Meta: U2FsdGVkX19xPpjGFKF42tVSmdv2/0M38weh6y41eF1vdMVm8xpuClxX++2DPymJ3enXQt8UU/EYFrcaVbLDKdHLmuiPI8ZrEm4VnLbpFzr/Sgb0nRWeRM+DXwR3g/HI/vfEgjhtD0DND1Y1Yf13rQPPL2RXCuJZ7jiBke39nH2UxO+96l0c3lAzUZ80E+0n/gWCpEvlKmD+5XEY+FHSVYZpXyvf0AMhsMkhh/KmSJWGIq0LAkRKuhJCfdzXjmNp/H28RvfaopocsJpXeudgZF2/6BT4q3SMj2wuOezRc0AqofybTgStE+lSVmAIeYQuZRScJXmCcpqpmMRJUfuvdFyyIYXiNwWW/F7bu/KmmvZs3RwqGgJITd0jFXBqyP16g9hJ4RZhgBMLEvzcTB6WS2zBjcQXoPFV5YDKq99RRmciJA1JgDxDp+8dsoV+ht77N6ZSC0BA6U2Y8sShkr9751EWxwHa4wAKhEV+L+Bm/gRRij1fogbE0gWbpLUoVvM+7YWaoxsF6E1xjaZ26FdQcCVmDtK2Qu8kJ6tDLRQtPraXsheqr2S/IUGvI2k7CUKL9ixAfjfvN3PNLnUDWpe2jpBeItC/xR73/ZNR1GvxwP6yAfPno1i4dMGNF4XBXezWTK5N6RroptDt1OTJeJWAUHk5laa+j5b3gmsonGiV3cSUZBC8OJpwd+l+UaZApI04u312xkFo6cGkoubsOWtDjQH/pNV4DkHovvi1ldcoKwAMCg27AO1UHSGCOJzLLj7zsFRiCmzMnOFJuVfb1l+bz16za0r9DMqgM6YpqsUJqOM4NWtFhhm3K7P2HpJjhpUtFXkKYw+uCSNpMPdRDZL841NyStfte6Mbn+nj2DLOzDqCbBk4L3z8uTBrh75G/Vpuw1iqDHjkWTKKNMEFSPd5QvIiSgzFLVQPON9fxjS6evkif2FUdgcAY1NB2ihLJumEjqDiV4+K60XqC+VIg8C
 65fdtvJ5
 RDSVZCnjaL2gFQI7Idp2seght8lYDQU6Cbo0q/fJ32EkHzFlbS0jyXNi8UahiRku1GrbAlqnz0YGvH7RTNJZyh9UU650D6fMSseC9INJuO6yzVfdeZNfxo7aUQWc9g5XXR7uFP5CvIwbGknLCa3AyjHwYK8jG1BQnFZJDq4uUKVEnT910vaDh+APo6axhrD/OC3kRF/AO+nSDBYKyKl2Gvehl5vHwcROPNLHeOLZOvfhF/a94wdOF5ypFvFfZC6IBVIIe74MNotmzRONwK3qXf8lHvyXWmaJFBEWVaSLQ3O8o0fvpGdg/ssQRaDtOIxJtJXy51RP3UquhFGX1kKat1YyYPUOUJ0IcufFAEaXJd4vwy/A5tl1gyvYI6hLgrt5xU3ffzLmcXxY1ntTJVx2R53m5JTaLY7dw23gDA3doRHT1OsW9h9fNuPNEx1dvHztKAh7pAlX3Q3DOWK0AaqoyD+ka7dH1c0ybmhEtfGU+eR1yMr2t2CoqkLjXwkch/FfshiwKFs0b3Y28fl1R7sCSy/wtivU/4Erx9nDoKvxU51i1k/s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/13/26 09:40, Gregory Price wrote:
> On Tue, Jan 13, 2026 at 09:54:32AM +1100, Balbir Singh wrote:
>> On 1/13/26 08:10, dan.j.williams@intel.com wrote:
>>> Balbir Singh wrote:
>>> [..]
>>>>> I agree with Gregory the name does not matter as much as the
>>>>> documentation explaining what the name means. I am ok if others do not
>>>>> sign onto the rationale for why not include _MEMORY, but lets capture
>>>>> something that tries to clarify that this is a unique node state that
>>>>> can have "all of the above" memory types relative to the existing
>>>>> _MEMORY states.
>>>>>
>>>>
>>>> To me, N_ is a common prefix, we do have N_HIGH_MEMORY, N_NORMAL_MEMORY.
>>>> N_PRIVATE does not tell me if it's CPU or memory related.
>>>
>>> True that confusion about whether N_PRIVATE can apply to CPUs is there.
>>> How about split the difference and call this:
>>>
>>>     N_MEM_PRIVATE
>>>
>>> To make it both distinct from _MEMORY and _HIGH_MEMORY which describe
>>> ZONE limitations and distinct from N_CPU.
>>
>> I'd be open to that name, how about N_MEMORY_PRIVATE? So then N_MEMORY
>> becomes (N_MEMORY_PUBLIC by default)
>>
> 
> N_MEMORY_PUBLIC is forcing everyone else to change for the sake a new
> feature, better to keep it N_MEM[ORY]_PRIVATE if anything
> 

No name change needed, I meant to say N_MEMORY implies N_MEMORY_PUBLIC or
is interpreted as such. Consistency tells me PRIVATE and MEMORY are
required in the names (_MEM is incosistent with N_HIGH_MEMORY and N_NORMAL_MEMORY),
the order can be a choice, I am OK either ways, but I prefer N_PRIVATE_MEMORY.

Balbir

