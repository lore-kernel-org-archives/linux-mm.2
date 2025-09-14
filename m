Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE0ACAC58F
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 08:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6C18E0009; Sun, 14 Sep 2025 04:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4872E8E0001; Sun, 14 Sep 2025 04:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327C28E0009; Sun, 14 Sep 2025 04:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2918E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 04:47:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F09A6119466
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 06:22:11 +0000 (UTC)
X-FDA: 83886860862.21.2ED0959
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012043.outbound.protection.outlook.com [52.101.66.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id EB8D9180003
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 06:22:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=nNwb22eb;
	dkim=pass header.d=arm.com header.s=selector1 header.b=nNwb22eb;
	spf=pass (imf06.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.43 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757830928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MN8Nkio0JiBU8I3nltnT0Q45WZSWvc6MhzY3Vg2vdkU=;
	b=0L9nFl5JeGCKGp/fJzgypa36LVCccFENTnEeamhMJtMiynCai218+9uMexUWsYkRuAMR8u
	iwIkqzqxskqClcLw41EO0f7oejgW+uS5adahW/XQh7MXiHg2xB8LSk3pLZMBXzKGe6QWeJ
	x2HYqQeVEJoBmraXMsqN3jhpgDMS0/M=
ARC-Authentication-Results: i=3;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=nNwb22eb;
	dkim=pass header.d=arm.com header.s=selector1 header.b=nNwb22eb;
	spf=pass (imf06.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.43 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1757830928; a=rsa-sha256;
	cv=pass;
	b=PaGffwxm0SYc7XJBOayIrJEESLGKjxpEAx87K2OGq0VonYEqkoWfHrHqOFZonHQqJga1GV
	B062L9GWBORf8yv2Il4XgtFXe9/Xxn27YUao4I/kICQEwhi0rFGpzLe4XYY3iM8dRCS3/v
	ELe57K90OVm5raa/oaufgHQ1TWyBf40=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dDEDaAouVg3anVx3P8qIdo+f8hGSbQVA5FZwwSU7dvE0/Lp/bPc1gKfXUwhZ+JYB+xO8wVbxLBGAdhRlLQAtVYv/bc48pls5mQuY9j7aWJdqGcdGHuGZR3fmmrtYo5HdZqq+Q3lpoifi5PwZx9a+o4nt0xx/OAjqzA3xC/oqF8D9EyO6jswyJREoNDkdJzw67QcQfyzJmVGKuMdZs8Tr9l4JTuDjz78RMHEfBzW2hIEr0dNIfhP17mkdB54+bh8BSqOsVxdaTH32/oGpYzF0IG8xe5CfbFjq4pbGOv4ZqS+4rniXVTW5lBt2394NWckOC+YDNJ39oij3BT17K3XrJg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MN8Nkio0JiBU8I3nltnT0Q45WZSWvc6MhzY3Vg2vdkU=;
 b=VPPtoLc+tJqpAzov3IWHwr09LwZALSMEBJO56VR5AaW9BOgV6rpPe7KRA9BRNF+4//Wc3S9Qgs2IN7vPUMzZ1IhxvyRf+g8gjB3NAmprXlfhMImGdcnFu0zN6Ks0AMbasmIXTjN/rXzwwqn/5oTi6Z8Q2/LaZtmCcN+Vs/nyxuhB40PPFBERu8Ystrmee1n6hosTphyv4kHAxBjgAbuVv9x+X19Nyrm3mR6vB25GlUvxdPJQmwNEwF55+qtcnSbnnFWAqB1tPLHNvRIVh8soqs6E5htKJdK5aNFzHimY5YezjftHpta+4eIHgx2iIqr7Y0TGgHuC3oFLAH/Myg97eQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MN8Nkio0JiBU8I3nltnT0Q45WZSWvc6MhzY3Vg2vdkU=;
 b=nNwb22ebL7fJaDg744G9tLhFzX2JpIMo4MgrAaplv00OJuzL7NxXpe35GYUYmNM0XAT0UqVU1UXM/5W8tzUhEN78mG4lFM7avtfvSJuWvqNEU8tgf54pRFJAwn0+S7vvclm9k/r9qyFf2XVKwrGDgaFBYHbFUqN1EpC/8yAomig=
Received: from DUZPR01CA0224.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b4::20) by VE1PR08MB5664.eurprd08.prod.outlook.com
 (2603:10a6:800:1ae::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Sun, 14 Sep
 2025 06:22:01 +0000
Received: from DB5PEPF00014B94.eurprd02.prod.outlook.com
 (2603:10a6:10:4b4:cafe::78) by DUZPR01CA0224.outlook.office365.com
 (2603:10a6:10:4b4::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Sun,
 14 Sep 2025 06:22:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B94.mail.protection.outlook.com (10.167.8.232) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Sun, 14 Sep 2025 06:22:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=luBs4Wgsnv+ukghTfFfPOuryQAKXXyRWHGYKKN2zukFAfaJAw4GSgbjbXJdMc6+QT9hKbMzGwTx8WagKZBWk/zbUX/gO3uOQrzeALUhf/TOd4gPzRkw+pmWBVI1teK2SJpDSgKK3V815SiRdyKbQCAL5CKWjp/l3HnZ+v7u2dXbS5CYCKXgesErNHGrHrHioo/RW61cnibbPqIyjcTiTicaHm+cobZU4rRNjjDOmvIaWHPOl5jClkk26acEjNHR87YvHj1ZbvbuLwhmnHSDptg/EoG5V+pwOXn91TE0mqmeOdZyXhlNy5ynK2jQ1fB/yrHrDXk49wlyB20siIXvoPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MN8Nkio0JiBU8I3nltnT0Q45WZSWvc6MhzY3Vg2vdkU=;
 b=BSgN/0twlIhqb5wtNdvi5K3DL/J9hXjWOJcNBZMqYOhxSSbEp5RWpxfsE1RFY99fXSHoX/oKGHD3oRLEhJbIu1Ej1ce4dAlT+6vhSfetor/lU38ElhGnq579EZ6xWTX7PTv79dH5ZeV2E0RuKi0lR8JCufH/p6+uw4x2arxEXXeajB7C6710e9EqIXN7aETeEsU9c8AkmvTyhUOuBjMQgJMgAq1I5qPWwikxf8hdIV0zN1YmXAMc1+jO9ZEFYALRlYzYeoVWGYK9EoVWaF6IwzhqF81iZgx3NYE5LY3mVsAi7YevMLojgNXuNkoXPdcIZ4I1P2e5mtGn8vpznogQOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MN8Nkio0JiBU8I3nltnT0Q45WZSWvc6MhzY3Vg2vdkU=;
 b=nNwb22ebL7fJaDg744G9tLhFzX2JpIMo4MgrAaplv00OJuzL7NxXpe35GYUYmNM0XAT0UqVU1UXM/5W8tzUhEN78mG4lFM7avtfvSJuWvqNEU8tgf54pRFJAwn0+S7vvclm9k/r9qyFf2XVKwrGDgaFBYHbFUqN1EpC/8yAomig=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by PAVPR08MB10330.eurprd08.prod.outlook.com (2603:10a6:102:325::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Sun, 14 Sep
 2025 06:21:29 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9094.021; Sun, 14 Sep 2025
 06:21:28 +0000
Message-ID: <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
Date: Sun, 14 Sep 2025 11:51:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250914000026.17986-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SGXP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::15)
 To AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|PAVPR08MB10330:EE_|DB5PEPF00014B94:EE_|VE1PR08MB5664:EE_
X-MS-Office365-Filtering-Correlation-Id: 03db5c18-24be-4a09-deab-08ddf3570406
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?c0VuYjdLN1JjTVJYeU5JZ2lVRHkybS9kc0NGQ0VIb1ZRdzIxSmxnWExWRk9I?=
 =?utf-8?B?bHdyTjl6RjJ0R3g5eWdZZ2dtWDFCU041NllTTk5GVXJpNTc2TjU0UVpxTWVk?=
 =?utf-8?B?YkdGT1lRZmdINjZMemNaV3BQMnpUVmtja2lMN05HUVY2R2U2SW1mRnE2S21F?=
 =?utf-8?B?YmxjMDMwVnJuOVViNmZ1elhqOGFlc3p0OWpJRm5BVXVwNnh2Q2F2NTVyNHNv?=
 =?utf-8?B?UkkweGk4cVlyTTZqK2Q2eE9RYWp5TGV6ZmhENVBaVU10WmN2NGhab2RjcFVv?=
 =?utf-8?B?SmtxTUIxZWNlaWMxcFBHUkJKOWFuOTRReGE5L2pDaXUxYlBsY1VkczF2VTds?=
 =?utf-8?B?YTNMNWMwVEViN0NPdjlIa0k3OVFXZnhoZitTaG1YRGdLRmdHV2FDaGJWK3FI?=
 =?utf-8?B?SFNVTXQ0WkhZV1drdEdPZU5zY0pNNEREVllkR09RM3NydHlyZmdjcjhmRDND?=
 =?utf-8?B?L084bitsWXFWOFlLVDBxN01UeVdpYU9JTHFITjcxeXVvandJeS96Z2hwOGE5?=
 =?utf-8?B?UUdhTFVRL3J3dDQvU3o3K2pzM3RwbUQwYW1mSWxvelZ0RGNBMTZNejVUMGtH?=
 =?utf-8?B?MVR2YVB2RlpVVW1Lc2VKTkorc1NWVFdVODRwckpSYnNjRmlzL0lXQlFmalpD?=
 =?utf-8?B?bGJodVBzeXhkMVZMc0hRM0hIaVVjcmxHY1g5cjRhWGROeDRzUGh4UnFvL3ZK?=
 =?utf-8?B?bTdLRHpQaXlNOER6ekdrTUxFVVhmRVFCMzNLQTdITjlrVFQ2NjZXdWxHYlZB?=
 =?utf-8?B?aHZOY3UvWXFrOWV5bkQ3YzA1WEJVeTlHcmpTc2lNazN4czhyeGNvNy9YUFFk?=
 =?utf-8?B?aWJwd0VMaWhLUStxSVQ0U0crNWpiWnJneVBJa0poRkl2L2xRQUlDSDJGMU9i?=
 =?utf-8?B?eW1qWTdIdjFya2lWSEdZcU4vRjNwL2JNU2EzekFNQzBNU1NVcW5BbHJFQTdy?=
 =?utf-8?B?OElYcitiNHhyUDZTTGZUMzNzTFBkdXJzWWVwWW9WaHVnQ3NwcUVxOUpSSUZH?=
 =?utf-8?B?MURGbFdoS2RQemVLN2tIcVBzT1hhZi9KN25CUnRFY0ljTW9oZWNTaUIzZEZG?=
 =?utf-8?B?bDY4bkFEUWwwdzNpZi9tQ1EwQkt2NmVUTzhObXNFT09VZXJpYlcwVlQvYUF2?=
 =?utf-8?B?Z3YvVitpN0dObHEvMUR6T1l3QUtDa3RaNzVTeWlhZnB0ZTJ2ZlBVbEUzVTdK?=
 =?utf-8?B?MmNwSlV2S3lJY1ZiWUhXOWxUQWZzb3E1VXZmNzMxd2dEdjByNjV1RXIxMFY0?=
 =?utf-8?B?Yk1mNDlSNnFKblNPVVRoM3RYZVZITFM2bUJvbUJlVkFGNlJPdkdoZHJBSG5N?=
 =?utf-8?B?dTFwVmFyMmJldkh3QlVCYjI4b1VvbkpabG11NG16QWUvdkduK3k1MElWYVZr?=
 =?utf-8?B?WVc2UnRQbG1OZDFaNDYrQzVid0k0aGRNYkNOUk1xc0VCMEZhT0R2dk5wdHJW?=
 =?utf-8?B?VkJtbmlHVTBqVlFkMWxDV2VBVEVYbDhrTmVFTG10M2Q0eTV4ZklmWFVreEM2?=
 =?utf-8?B?NmpxKy9aRGxnOEhLcm9kcmVsNHdzY0RyOTJXTkVhSjVoTmZETVlXcmpieGZr?=
 =?utf-8?B?RXQ4Q0JWNmNuK2FYbkJtRTB3WG1SZkNSOGdnZ3lsS3crWTlCVlVxeWJCYlRK?=
 =?utf-8?B?YjY4SlFMdXJQdjVMVnU5anYxZFJobmd5OVVCcjUyYU5CckFEUVU2OVhzTjJH?=
 =?utf-8?B?czkybEJ4RDIvKytMLzFyR3RvK2xYWE9QVkpZd1lTQ3dTaHpKQTVwSi82ZGNX?=
 =?utf-8?B?V3kwVEVza1lITU5pQzJybkhWN0g2dC9obWVlM0pJWTlnVzJhWEVycnhYZnVi?=
 =?utf-8?B?K0hPdVFORWpFajhNZlVLUlpoWkFPanYzNDBlRWlXZGxiZldUUzJZRkg1L0ZH?=
 =?utf-8?B?c3NBYWFCeUFTRThxSjhTWjkxcnp1RnU5SDVFSVV1cmk5TUMzM2ZyOHhLUFov?=
 =?utf-8?B?TmszZ1RydmtxMjllTE5ESGxuU0w5Ym9UTFVJcjV0Vm1xbStNaGNwOFozSkZX?=
 =?utf-8?B?bTRzYlI0YTN3PT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB10330
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	eb888ff6-8169-4785-1a03-08ddf356f094
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|1800799024|14060799003|82310400026|376014|35042699022|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aU02VG8rMlQ2YTZUa3g4Rk5nelNDNmcxSnFuU3pqU3VUNU02V3lWT3JQK1hh?=
 =?utf-8?B?M2FVTThPdWQ3TzRPSC96MDFjeUVwM2tIV04wbFJYVTB6dSswZDM0LzdkWjFl?=
 =?utf-8?B?NHloNDZRMjh2aHdoWFdZNDVHVHoxVkZTaWV3Um9KYlhwdkZ3VlJYbnlXS0hO?=
 =?utf-8?B?ZnRJTWtxbmppU2RiTnM0dStDMGI1Y1hTQkhqWWxSeFZySEhWSklqVSsvWE9X?=
 =?utf-8?B?NnVmMWx0aTNOUXNuOUI3T2JNRTVLNXNBclBTLzdQQjBPclloNHovTHpyMWRa?=
 =?utf-8?B?NE5jYXpyeGVscVZlTWErSkZ2bWp2YjVDdUhDZW5yUXRVN2F4T2o5Y0M4eXFN?=
 =?utf-8?B?bnkvcWtqTGZjRDUrVVkyR0pRYmJPWnYyUkJRazN6OElubEJzQlljbFdjWUd6?=
 =?utf-8?B?dW9CT0N0cEtsZFdGSzJOLzduQzc1YU9QdHpFZVl3bTdGZWY1RGpTQUFNSXZC?=
 =?utf-8?B?aXRra2s5ZTJPYVFRWmUrNmRRUGd1blNyeWdQNUF4aXFIaXAwWDB2Tk1jU2Na?=
 =?utf-8?B?cEVjQ05DMTZvTEpVTHZDdVRtbytrU0l1NjlIMGs1djZ5aHhCeUM1bW0wUjIz?=
 =?utf-8?B?ZE5WWkVvNXV5dnBqUHAxVGpNUmxSODAzY2VoZml4NmZlbUNRMWx2cmRkTm5T?=
 =?utf-8?B?aXM5TnRrQmFMTmU5cVM4TzNDL25JdFBweVBldHFGR2EyV3RZQU1GdDB3NjRB?=
 =?utf-8?B?eWFPaVliNW5kdzVFb2FLSWRjYzY1cE1pOEtmckJoSGM0d0s4alZEaFdjT2wv?=
 =?utf-8?B?ZkRBeWx4M3gzalFCNHBnc2Mxd1BnSldsRFF0bkM4U3ZXWUhLTHVUajV0NTBJ?=
 =?utf-8?B?UjhmY3NBMkU2MmJScFFrYlhKaDg1aEZCSGU1dFk3WTJBcTdlZDhuYS82czk5?=
 =?utf-8?B?ZC92TWdhZHlaRHNnN2kzdWRUN05yUjlGcVRCMlpycVZqRk1vdy82RWp2R2RF?=
 =?utf-8?B?dTJOS1lpcjJpSHpaWkFqbHFWNE5NOWMzalBteHNnYURMbnM5Nlh0YXI0ek1n?=
 =?utf-8?B?NEpjZ3RlL3dicGQ1ZWZsK2FqNnV6VGhjR1VwRGFLWUN5ZmN6RUNhZGxaVjRo?=
 =?utf-8?B?cnVlOWUxMjRkZVB3L2NORHJZM2tyeXFMQUZFUUpsbytRZ0tjSGJHWGFOM3JJ?=
 =?utf-8?B?dHFrRWV6ZTIremd1UVUvMG56RzZlcGttbC9FR2I3d3RqS3FmbjQxSSs4K2tR?=
 =?utf-8?B?c2c4Mlo0RjBPNmRXRU9QbVF3SWRjN1NNNHp6N05abXhlVGFKeGNBZk84NSsv?=
 =?utf-8?B?WndBcG1EMTNRSE93NGJqYmJWZGdtRExHSnYzN3RjejJTUkZ4dnhxZ29YaHBP?=
 =?utf-8?B?WTg4K0IrZUhjd29NNUVScTlUbDMyMW9SL3hXd0hWajZmeUY3cmdnZDd6WmtU?=
 =?utf-8?B?SUp6RzVOeExuUEZNY0RzMktKSVBtVGlORjM1YnpTT3lIMWovNnR4NnNzNU1n?=
 =?utf-8?B?UW01RHJ3dGhFenZUcHBCRjFyLzl4T1FYeDVmaFcycE1rT3VaRmd5d2c0Nm91?=
 =?utf-8?B?UnI2dVdKc1pQZHdkcDh1WWUwUXlMTE15NFN6TjU4VHFLOVZkNlJmZ2ZSRUJj?=
 =?utf-8?B?Y0xoNXlFR2kxa3l4d1loZXNyRHBVWHpoc0xGc2hDcy9ML08rNVZKWE1MQWZC?=
 =?utf-8?B?ZU9FdTlteWRTWXdlcG9FdWQ1bFFiOWhoOVdnN1luRFMrcjV5ajdiNExWS0lO?=
 =?utf-8?B?YTc2UVU1eGxUc0QrYWJaY0RMZ2wxTDZMR1J4K2FSL29EM1J0SXhySTVVbTN2?=
 =?utf-8?B?UE9aaVV4OTRJL29LV1FESTZKUlo3aFpQaW9tL09WV080Q1lLM2N6eU5ETkZ0?=
 =?utf-8?B?U3R1VzM5MTArQzlZd3ZIOG9vUHlZYU1XWlRMOHBITHR2NUl5SXFkNXB3SGpm?=
 =?utf-8?B?TVBCWHYyemUrM2NnUDZvUjJzZmt6cHVSOSsrRDdEVWxreVVrRjdvVURSazU3?=
 =?utf-8?B?Yk5LL0JJaHM3UWpMR1pkZ1o1cVd0UE5kK1I1UnJvUXFQMHBKblhhZWQzQVlO?=
 =?utf-8?B?QkM1ajF6Qk9JSUZ1VGRhamhYb1ZLWFllazdBRXRidmN0aktDcDRlS1ltYW44?=
 =?utf-8?B?Yyt6VmYxTjR4ODlYdFIxZEZlNXRrdVIwdkdpZz09?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(1800799024)(14060799003)(82310400026)(376014)(35042699022)(921020)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2025 06:22:01.0758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03db5c18-24be-4a09-deab-08ddf3570406
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5664
X-Stat-Signature: cwpd5cfrcm4jq63snf34msuzoep1zipo
X-Rspam-User: 
X-Rspamd-Queue-Id: EB8D9180003
X-Rspamd-Server: rspam04
X-HE-Tag: 1757830927-893959
X-HE-Meta: U2FsdGVkX18keJRg5QfNyQkMFzwRRIhupFS/nN0AGL2beRE5MuP0xDTVotQten5UwA9BV8xyVBB2iBAno4A2TrKi/6cAkwLm7hguTu5ETQzKPu7v5Lzjex3cYbMnTI6aD/f4k666UOnukH0BPufiVfPcF4DLL+crmMxNcSsMX4Ig2pVKqvoLqEefrIOhZ3HdKgZSOMiQpv62BJ4c0pK7rdEPw5svWKIlczG9vK+pGscrT8NXGGgUvThQ4J27zvZuWgiEsqAAGccVmH+u2sgNtQJL8lat/tVAc57cUdTEI+fmxD+pgaxWFdGw0NuIPfhErBzYNX8SiaKYlxnKCWFB2a1N0wVNBfbtX/Q6NGFZvf72ukOHbzrfxBYV9e4YFqbo1bVQWzm9i7fC2Kg0m/bKahJ++UrLExKRckXE55C1gbYnUPjRIjljv4/D4fX8sSExFoMXGk1awbL0KOywvQB+zyVuSi2u7ktR5fKCgX9PlcYAdHTKBP2HAanJ8N4rNqPQ8ZTR9xhlaO8qi138QtjT5eTD8WXnqIJcpRffY8cJY1D3QJcPo4gWIxLQMkwt58V0w/VH+vhjVCWowMwwaCDyhQoqmBhc6ZpTzXbn/tEZ26TjrWZJWJuRKuMWSAZgufyOZMbF6iNxChI5nSxhbSNrEQwD+NZxQJpj55dh+Y0FhtLCoC6k38F2XQbQ4/vePLR8sYqOp5h5nuT/FUwrGaorClzq3f4KGYggaNnhjPvj9bUCspl5vQYuOjP+wSNu5HnbjLpiV6kCgQzbHwXkW1zuxFjjMAguGoY+qAHCDVOODLVDVYEW0KoubGTMp4JPVRYb2vEQCvpmytBgugo5+xLJZEGR4NtkeTekPcUR3bkeXVFZ5tm/bW8BPKJgxhnYiZ0sI+XGSrdZk/H2Y1lJG12j4I2CDhVoauESbuFSCdKUPna/YnQt5pE60tdPtaEHjxhUB2KpCLK7cIbyR2y7reP
 53pIq6TG
 MsdbJlFzttHoXFkBAYSIftYeNJwB9v2+OM4gDTQl70m1aoT5AhctTf/r+G1aZgkteGh5oNFiDaMw1Ha1wHcn9h/k/3n6XWxq4N4AUFGmI/rYuRhWbykG9ngdEJGgfHg7ll/9Bo2BBGzd+M3d/SY2F9Ookmxqf6Ch9SDYb38XJj4Xnl23do6rwDvCcTNaud/U6FE/7zR2zyGvpteSqV6wekgzraGZsd/ak+qJRGeVHXnWPMMk7WeIWGqRR6hv6ngw3WKGmF8B4RAN5DYlG2dKE0UFxWGJ8U9Q4Tx37VutNrdALVcfSNVhbK/LIJpjxwsn+NNuELqtEj54JiR0XoTtoEsLcUMrvVI9XerftDpKrZkJTLXiOCvSvDJAc4+Z/H3VnbU9nDKIbFS+UmRbb28VYRSMZfzDgHs1g5/5FQJnI6ixygzIBz9ffGBQfStxXxi7n6BaYogyfpxIw/P6DbOaI0DyrQ45sOS3olxTlsQZ+3frTSwNLGNX6yykq8QBqto+kOTq0fa5EQZCcyu5Nk+5JhyPz8mkDaJLj/quuXv4LS8nIjcn7UpbhKkjPtEL4LjAdn8DxOdmIWZDcAoyf2NOC9fhukYixCgh3rnF+VSB48a+bF+M0CrXRCKBR9tCE/MjsREcuPfaWYBpYlcV+xG32zs/gUpN0iWrIzPymGtRBu/ja/Kdj2kHNCSlU2KQvlFIiL9xnwqOpAUd0vx9WkPWFzTB5gDkMmBA7rFGCQ4uZAQpBd2sBu+Kul7DFzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 14/09/25 5:30 am, Wei Yang wrote:
> When using mm_slot in ksm/khugepaged, there is code snip like:
>
>       slot =3D mm_slot_lookup(mm_slots_hash, mm);
>       mm_slot =3D mm_slot_entry(slot, struct ksm_mm_slot, slot);
>       if (mm_slot && ..) {
>       }
>
> This is only valid when mm_slot is the first element of its wrapper
> structure, otherwise a NULL slot would converted to a mm_slot with
> negative value. And current code thinks it is valid and continue.

Shouldn't you fix the code for the case when you can't find the slot
in the hashtable, i.e slot =3D=3D NULL? Like, if (!slot) return.
What you are currently doing is just ensuring that if slot =3D=3D NULL, the=
n
we get a legal value of mm_slot, and since the code then operates on
the basis of mm_slot, everything will work fine. I really think this
is a workaround to the real issue that you got slot =3D=3D NULL :)

>
> Current code works since mm_slot is the first element, but make sure it
> won't be disturbed.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>   mm/khugepaged.c | 5 ++++-
>   mm/ksm.c        | 5 ++++-
>   2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index af5f5c80fe4e..668e74ad33b7 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -108,7 +108,7 @@ struct collapse_control {
>    * @slot: hash lookup from mm to mm_slot
>    */
>   struct khugepaged_mm_slot {
> -     struct mm_slot slot;
> +     struct mm_slot slot;    /* keep it the first element */
>   };
>
>   /**
> @@ -2382,6 +2382,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigne=
d int pages, int *result,
>       struct vm_area_struct *vma;
>       int progress =3D 0;
>
> +     BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct khugepaged_mm_slot, slo=
t),
> +                     "slot should be the first element");
> +
>       VM_BUG_ON(!pages);
>       lockdep_assert_held(&khugepaged_mm_lock);
>       *result =3D SCAN_FAIL;
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 2ef29802a49b..0d486dbdf7d3 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -124,7 +124,7 @@ typedef u8 rmap_age_t;
>    * @rmap_list: head for this mm_slot's singly-linked list of rmap_items
>    */
>   struct ksm_mm_slot {
> -     struct mm_slot slot;
> +     struct mm_slot slot;    /* keep it the first element */
>       struct ksm_rmap_item *rmap_list;
>   };
>
> @@ -3842,6 +3842,9 @@ static int __init ksm_init(void)
>       struct task_struct *ksm_thread;
>       int err;
>
> +     BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct ksm_mm_slot, slot),
> +                     "slot should be the first element");
> +
>       /* The correct value depends on page size and endianness */
>       zero_checksum =3D calc_checksum(ZERO_PAGE(0));
>       /* Default to false for backwards compatibility */
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

