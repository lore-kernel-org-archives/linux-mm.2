Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D31CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 12:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942C98E01F0; Fri, 15 Aug 2025 08:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9201C8E01EC; Fri, 15 Aug 2025 08:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8098D8E01F0; Fri, 15 Aug 2025 08:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5628E01EC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:00:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC428114CEF
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:00:04 +0000 (UTC)
X-FDA: 83778848328.06.F1214A1
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2048.outbound.protection.outlook.com [40.107.95.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id E52BBC0014
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:00:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GwESd73f;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.95.48 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755259202; a=rsa-sha256;
	cv=pass;
	b=7yNbtlz9ef+SW3a1PxdoAJQupxKcT6SfMH2jgJjXYIqxyYsXuy+4m5oFmIYwQuYV84fP/R
	ZtquksE2wrRnU39QKnVU1HCgowX8/gkxp3UM8dX/xDr+JD6KP0uygpzW8aOUz1KhRi+XUn
	ERe/rZPDUVedUFm4p7X9cPUikerMfNg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GwESd73f;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.95.48 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755259202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7+nu7vsio7/twL7d8MxecShlDFfferp69J30inegTk=;
	b=Pmte+sDdPQLvA6iMrs3/E1dQlb7c7JOtwiNB08w4+MZJjRKM32c92FY/+Cp7BsAFO42nJd
	yEJC1NwRlytiNt39xnz91PpCKoXK9XIOfepfVMtiQWqXW0k6+AzUvqkQL7Yj3klOhj3WUk
	xqJ7oXq1k8K8lkd/lZeU7+6B9CpVu7Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hyB3OxV93kj/4ItlGEVn8n7tBrSw5YjiuNcWGXkxtMSArqadP6OKGyHCaDGLKASGtm+f1ZiJADcCYl+1MCQ3bYZkLA5dEOb33xNJxmUa/ILULOkOiY4yLO/+9XFAXlcvhDspqeshTOCEMXPK/rIRPb1AifGCC2iJb2q+ReMUSWHd3O9X0/i/xSsdS/3v5uU9vJCq7maP/DDTWhGzt2eDEV/gikd6FeGm0Dtje7EhHpy/o4tdgFcY3rs3LXBgJ//tQL1tzW8a1VEF/B+XpOY2EwlLzSZQ6y+3lqn3MZNA9h16vtegfxTGGGlyE4+3Sz0QDMwkLi32EToE8VIAAqJl3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7+nu7vsio7/twL7d8MxecShlDFfferp69J30inegTk=;
 b=dRt3N/JQ7hbOlO4Gav32xf2tTKAtTQZP9662PgUySs6G4mGefuQeTHzBw1F4SBNjRyny7wuD6E9+TdjLK84U3hpxUf3WMgbzYpkYPv23/PLwstybrEE96/GtFF9Zc2kbtkSvhMZsq5o8836S8mwkgvnUEtu2e3DRA57leWsSkXfE1e9CSXPxTUaVO46Gp/bD9WeEb0J+5SnqUAznkUAPjc96j7rS8TIlZ/6YHfS5vbe0/XaT+cAHCGgq81wXk95NBh25AUtULItXx8diqntWe0iqfS9+uB33we764VAIRX8p1qPWN/PlyeSugaUUf8MF37jgsJdoMKCoyY0jL9Nzxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7+nu7vsio7/twL7d8MxecShlDFfferp69J30inegTk=;
 b=GwESd73fcW9ID0fmu1WAOCjjFNDePI1Ox3UUnzdo48FIP3oWyTEo05kz0jkQDx0RYsm+Dzx8OcU/Y714LkDkKldSbo4ZKvAJX7gTqlNu5pONM8Tqy41kIXRwUijKOaEdzo+jNS9hz8Vpx+kEHSb5YQzRI73Z3WwkMH1LN5PsHgVRi2bHHMO3o49yy36n5qV9sGxC8Oyl9jG4bSm9FAnKZgcccYH1h9z53ZFNlq+Pu2Qc0YNaO4a1qsiwc3zqB7yNjz82PHRbwiZ5XB9ONaL6FTxx4CSOlbMmg4qkheET0Pm5Bqqxou/KnHEVRO15t2lSzyQ5mbCeTDSvm49G1i8mmw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH0PR12MB7908.namprd12.prod.outlook.com (2603:10b6:510:28e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Fri, 15 Aug
 2025 11:59:57 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.9031.012; Fri, 15 Aug 2025
 11:59:57 +0000
Message-ID: <fa0690e8-ad88-4ffc-9c63-c1d8f3d60f47@nvidia.com>
Date: Fri, 15 Aug 2025 21:59:49 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/7] A subsystem for hot page detection and
 promotion
To: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
 hannes@cmpxchg.org, mgorman@techsingularity.net, mingo@redhat.com,
 peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com,
 rientjes@google.com, sj@kernel.org, weixugc@google.com, willy@infradead.org,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
 nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
 akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
 kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com
References: <20250814134826.154003-1-bharata@amd.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20250814134826.154003-1-bharata@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::13) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH0PR12MB7908:EE_
X-MS-Office365-Filtering-Correlation-Id: b5aa29b0-34c9-4ca0-1d3f-08dddbf340e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YkxxaFlWcTloQnBxUnRtYnNxaW9yWk5JYUxCNDA2SURWTExwOTI2ckN5N2h3?=
 =?utf-8?B?WEVsc1VId2h4NExRYUx2OWVCYmNaZmp2aHJ4UnRMRkpCOXFpZENDWU5CWmdp?=
 =?utf-8?B?bG1OY0k2VTJLNDVKamVCV0Z4Q0VkVklRRXJCTVQ0c1p3ZDYwUHRtTlkyQTB5?=
 =?utf-8?B?c3dNbVZsS2JvVHoxc25hMTM4LzFjQ0luZUlmcHg4N0pFZkE3Ti94TXViMEd5?=
 =?utf-8?B?NWp3R2hxdk1Bb0pJU3dsYS9PbWNGanpEQmJILzVkOFdMdmFQTThNM2ZlY0Vh?=
 =?utf-8?B?NUNxdlpyaGF3clhmbnZCTXNKb3pWSElSb1VPczVJYmh6YUtueGc0RERudkJR?=
 =?utf-8?B?cTBES0pLbzVWSDd2UDVjdGQ0VkhsT0lXOWFIcVcrWDROTW4wTzNNYkZ6d09S?=
 =?utf-8?B?czFXODcxOURNUGhMUkNqRzRzdnFtMGpKMlFDUkxwcXphaXdSTzVmS2k2RzAr?=
 =?utf-8?B?NDlBV0V0bG95SzNTQWNiUlhRSEcxTE9wTVRMOFFRVzI2YWRCdzhPekQzRjg3?=
 =?utf-8?B?NEx3L3lXb05zU0xsZFFwOGhhUzZpbzJVazdULzh4Tk1ac0JuekdkUU1LUmw3?=
 =?utf-8?B?OWdRdTgwMW5mSjdmR0lycC9PVWc4RUJRNFp6UjVDRTlkaEo4N3BWUVJaTGRT?=
 =?utf-8?B?TFpuUnkrdHNaaWxrMEN3VWVKMVVoandYQmFha1R6WVQ5bnFUQWMyY0tIYWln?=
 =?utf-8?B?cG9HSVA3YktRWlo0bS9wek9GcHBlQ1RqeGJvcC9pd2JzSEdhTFZ0WXphbUFL?=
 =?utf-8?B?M1VveCs5SFhlR25keVNuYWFMMEZQSWxvVWVyRk5HK3JPNVRKM0ZnaThpWWNq?=
 =?utf-8?B?Vm9qWm85WG9tNEJpVkxQREQ2dTdTdTdFdUJKNi9GSEdrdlE4a0pOcmR4V2pB?=
 =?utf-8?B?UFJ4UzM3MkhJMXVPTTQrQ3VVVk9wRTJBK01sc1lnVXZsaG5DNkVLdU9LMHV2?=
 =?utf-8?B?VnNjTEJTc2hUaTZ3TWQzdFVtOElXQ1Q2OStZTE94ZzdqQzhuYUR1dUdOVm5y?=
 =?utf-8?B?Ui9TMUptMlR5UTFoWFdIRFdKcUNPNkM3a1VyVGtmMDBHcVA3U09vRm5IdXds?=
 =?utf-8?B?M2VLcjV1WjlENmEzNUI2dUV3QUlmOXdRZzNpaWpNUGcvUnFJeHNXU05rMXpH?=
 =?utf-8?B?Rm9aSFFhalVtUGplaFBVVThEVUsrQ2NqWUlNK2c0cWdrRm1ZdnVSS0o1RHB3?=
 =?utf-8?B?S1U2OFVzQ1l2WmlUYmc5QXI0YTJKWVJvalNMWTdhM2hhSjQvZU5VYzloMFBY?=
 =?utf-8?B?bzNMejUxWXFPMjUxNDUzYkJsd2hsSHdpM0hIeDFTMjU3QzRIVXVIYkhISU15?=
 =?utf-8?B?eG9vaytjUGloZWU5S3Vnb1FMN0x4REt6QmRZK0Y4dHVlN2NJSUIyRkJ0Y3M2?=
 =?utf-8?B?WC9CVE92R1RjVUt6TGZQVkNHM3JENXRyS0ZzNjNVT3phUmp3aGh6aFFNVExz?=
 =?utf-8?B?eW1uOGFYOEZmYmhpUTZEbUNKcWxlRnhKQUxVYWJwN0E4ZEE3bEM4VGN0alRP?=
 =?utf-8?B?MytSMmtOc2syNTc0cDlPMzN2eEpXcXpXYm1Bekh6NGhFT3NkcWduMkp1MVpK?=
 =?utf-8?B?MVE3Ymp3ejdORTdNL293UEJpK1haUkdTdTRZbVE4bTkvK1Jjd203djkvSVZs?=
 =?utf-8?B?RjlSRHZhZVF4WThaSEpzM0xISVhZUVRKZUVkcmsyemE4V2Qxa1lTM0hURWly?=
 =?utf-8?B?aUpWOE5qVzUwT0srRnNPcGlIcE4xWFgydmk3aTh0QzRzdnRFRjJhK0xtRUNV?=
 =?utf-8?B?ZkRXZmE1ZFc3SzhxSmJIS0FYWmJtOHFDRUx1bXFJUTYwalU2ZFkyT0RpU1hU?=
 =?utf-8?B?aGkxNTlSSmovMTdZM0xRSkRRd3kwZlk4bzBEVlh1NzZmazhZZENLNFFUN1NG?=
 =?utf-8?B?OE9qNS9BM01xWmNvQkx0eEIyOXlTb3hTL3J6Vmh4dmt5Rm03cjhGcWRYQkE4?=
 =?utf-8?Q?iyGJrZq+Uxw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TkIybk4zTG42WmVkMlF3TVVnTGdxZFRtdUVGUzF5R2dWd0tIeWNGMXFkakdT?=
 =?utf-8?B?bUg1OGZPby9zSFZnY0kzbjM3ZWVsSG5JOVZDcmh2cDZaOTNlNmh1akQrNjB0?=
 =?utf-8?B?SGIwWXUzYVgyeHhhSDhmSHptSG5LY1ppcmJPWm0yVTUzRTlyT2lFSTRWVHV4?=
 =?utf-8?B?dEpleGVWWCtuaHZSR1Jwd1M3UUc3cG12NHBzWHNSS0RCT1I3Z3ZraVpGdnd0?=
 =?utf-8?B?TkhiWFM5dCsvWTEzRkpDNDBrVGZ6emlTRzUxbXZWL292a2lCcDdlVm1ETUlR?=
 =?utf-8?B?Ly9LNTQwbFFuWDZSRmhhRityblJaRnBJdkhKaUl5RVU1MmU0bC8vZ0hZZXBV?=
 =?utf-8?B?RCtZUDFJQzRTRUFyU0FHMXVFcnp3QWRIR0k3bG8zNlZTZXdHUTJyZVd3aWNy?=
 =?utf-8?B?YzVEa1lQK0NoS3I2SU91YUtVU01ORVhoM016UjZVOHFPUThIclFtUjFaVlBt?=
 =?utf-8?B?Z3pzUE5Pc0Y4THczOURzRkVwZ3oydFVJbU9YRlU5K1NhUGlmTkZBeE9RYklN?=
 =?utf-8?B?STA0eUtOVTY3Y1dNN0lqVzB5QUNpRzAwQ2djMlUycWpFejcrM1ZrWTNJWmt2?=
 =?utf-8?B?MFBrT05FclE5MHJPRHJod1p5QlBBOXFMRW5IdnpjWFRiTDA4cWRjbkVkZjNn?=
 =?utf-8?B?QU1XZWZZWUUxU1ZESUUvc3pUL3FTRmFlMU1VZnNIQkNHZ05nOEFITnJQRSsw?=
 =?utf-8?B?QzdndG05U2x1MEhrZ043bnZ5QTBDajF1N2o0bXg4VHh0aTlOSWdrazRHWVM3?=
 =?utf-8?B?V3NhQkV6Q2pFbWZRSTB1WVBJK1R0cXYzSlJsaDAvcnFvaTlOeEo1cTJPK2hm?=
 =?utf-8?B?aEN6RzIvWkJHOFNVam42WUxoMnd1NWU4RThEcHBvMHA3dWdiL2NVOWUvZ2ty?=
 =?utf-8?B?am4yN0NRWWRuY0JzNzNTRFpaeUh3bTM2VUJvNjdFMUVFRG5EN0c4Q24vZVhz?=
 =?utf-8?B?NU1jdm0wamI0QUhRRjFndzJUa1EvRnRac0xnQk1UdkY0dkgxemM5UVNCQWsx?=
 =?utf-8?B?ZEJkbGdpbU8wOUxqVVUvVHNOdkRzQ2Mwalg0eUsyTng0SEF0SXM1UkZQcDJo?=
 =?utf-8?B?b3pNeHhCMXZIWUUrU25pQWZNK0NTdVdpclFEakU1NnZCSGlnMzRuUVpQYnhz?=
 =?utf-8?B?cDAwcDVHRGlLYVJoUk41c0xzQWJwcFhNdWF6Qys3Vmh4bGh4Z3U1Zno2VjBS?=
 =?utf-8?B?U08xaHJnbU9oTDZ1WmFGKzUzVVdqUHpEcVQyRElQL2pKaE1SeDdqR1V3ekFS?=
 =?utf-8?B?ZC9lazhUWk5FSTZEUzE5NkQ2QXIwOGFEOGd1SGgyVjlJcUgvemVESjk5TU9S?=
 =?utf-8?B?ODhBNm1ET3V0TWIzaE51UVVGMnMyKy9RTktSSGhOY29mSzR6cXA4c3pGdU9r?=
 =?utf-8?B?ZklUcW10VStnNmM3RjFwY3FOKzZsM29xaW1mWFBzMTNnb2Nlc0kybXVlMTRo?=
 =?utf-8?B?SEk1SzdJV0NsS1d5R1Q5TG9mSFp5RVZuMzBlMmFmd1ZMUDF0ME82ZFBraXIw?=
 =?utf-8?B?VEFUdHovUk5lTWdnN1ZiY0lMUkRyVFVHTHl5SHkvcnNQeCtuTkJYV1dvN2h6?=
 =?utf-8?B?NGtGeExvNk10cTcyUGRWdEl2YlpDRnJXOWl0U0Z5cE03NlEzcEdrWnZDZ0NM?=
 =?utf-8?B?UlNabFVpV1VuTVA0LytXcDBpU0VtQmg2SGo1K0VzbFpMVGoydXI1dGRON0hH?=
 =?utf-8?B?Q09jVHdmcVo0T3ZRYmVHdkx0RTEzNGlpSjQ3S1B6dzc1VTFpc29XL25NMnk4?=
 =?utf-8?B?TnIzTGgwVUtpektxR3g0cXZSNTJBV1EvRTNOK2wwb3JTYkF2UmRBU2J0QlZy?=
 =?utf-8?B?U05LcDZUOFE2VG94V2dtc2Fia09Jck5uRFZSaUE3dFQzZnRCZ2M0eDVFTDVT?=
 =?utf-8?B?blpwUjVBTS8zb0xobmdRdUNncmU2N0VqZmRCNDRYc0FTOXFabjlHNVAxWC91?=
 =?utf-8?B?S2xmcjMvRG9teTFmU205eWE4RFJBOU9VZjYxM1NPdkFIUm04WXIwRzNnN0d4?=
 =?utf-8?B?MnlGWCtMN3lsdm5PMHg1UERjcG5naFNwMnd2bVpYVGlHNUxuQklxc05IY3Y3?=
 =?utf-8?B?dWx4WDlvSXo3ZzFaWHhpbjlxOXdZclQza2FQZFhka21MZHkyUCtMdUoxWUla?=
 =?utf-8?Q?NYqcf3UVQ6HIxLCziQApaG0vx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5aa29b0-34c9-4ca0-1d3f-08dddbf340e7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 11:59:57.1082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BaJj6asqqwfW1fFykKdq09L9H2zN5tR0VtRY7B0mpHEIy71lW8gVIp2BkUNdS2qabxYvs8ard5eItQ17PVNEfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7908
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E52BBC0014
X-Stat-Signature: fxhoa6jt9yriy8q3cnkj53z3rdyo7e7c
X-HE-Tag: 1755259201-974455
X-HE-Meta: U2FsdGVkX18BFv7vMWEJycfIcsF0PIPO+Yozpzg/1PQrl6gQ+a/JXd+82XwiMyBUSBzZG+Kt0wOssOyTmrpF5JIVGYkrC5Q4geWPApyoZQa5pvpFaEX9JGRh3SOVFIukJF4Kb9nhlGvnNW3Y6CG0ToASET/vFn3q4AudZZkXlSiNNSPGpZ0jBsrQEjs26sTqB5zsdpQY8pkuyvj0CoEP+WqCY8tTWvzrphYPtULL6hWF+1D1FdMH7jd3F7EUOoVmUIIP+kJZ7HyO8dOM8J8LIwSvy5LFgYvXd+7Zp8NImKf1oxPduy75bIxnlmuvwcP6wUA8Dk1NsnVOESQFrYIOWWGOCWUQpct8tww7jPvThtXq07ct+7hs8r083HkjnWP0ppXroXQ4ziC7cPgRLoOdoOX+EBV40WHEoMZPpJwf0tiMTKFZW3/8YxTynGk8NsdDJyfFu18rVJ3Xn45g7lywFRr8N2KqVnKVKFD9aN+ZZQMYjVt5YnNUVn92AQCBN4N/YC51zOJIjtJ9b+1WIBtYAXp5O1HkgZFSSXWfKUwuvutDiQlJnyQI8Qb/YgJv6sDJ1oQqf8V6edeL3fnQbKeek5gvJ49WqYnyRoijpDy9Xoy0ZGhGN7ObDg9bEfxu2vEZS4EyHDuXE1sGR9Tt2/khHd4n4C4ZVijshWltFKN7dqvHENJLZmzBS9XOI0FTqnNhrZ/tJIJxCkeWZCg8Z4Co9MI4xfhINFwpXaqdm1wbGZx4HK5Eo4nMUwTUPD5r2u/kPr0+8EfPiVuMQQX5gUojRgpnfZmGlGWED9SB3VbehJKjydXHPvPDnSclLqLifM4ECl20Q2iG/33ULszwuNAnw1O8KjKyPTFL3lU1NNYGjoQhORaFnO1yvvTqA54sDKUPaw6cDfSgeTCsxpyfxglR+HgzNLDMjlhe3Na7LPn9ARz+YDVSOlCXlCM/KNegOrTBtWyPo+Jp0KKlmRn5RXi
 2rxHWOcv
 CcaS4vBYCQ26z4oz0Q1/yAe0pSM08EdQzJcf7ui5fuVb4tsB1esyrzFHhEhXjf0GO2ysiqHlAAXU3bs5Pl6wsoGU5y6r9oZdbn6QO20A96t4JaRX80qmGonrKQM6ktggaNidUWVm9ZW+sWHzCcdu8NlJ3id1OCJavBept1dDn5JUYEjbMYEC+eaxKnH2daNmcP6eRDtNWMV1ior/H7SLqVtEywbh13ahbfvxjYoYyi60XqsQV/M34hJN3zaO4ijAKtKRd8CLjvLpmE77TbxW+Lvz8KWEqwJGHvd5Y3JAqmYmAfyxcqdSSceYTwDmGgr8gsH36WSiVaWNBu6hnAfZnUqq7WMSzMDBIAHMr3yy9ZSej4uQ1gdy0JpQeypAtHJT3498CIwWcemIYgT6aZKDbVAnfOm9j+N7eiuf4I1/NCfL/AACpazyoNjCFhRiGGiV7cm1AHu4JvbX7vxZYXL+hsxXF4EgVsllGjOBYntRMPmuHfvcijjpTuI5CSAxsx1cKCvNMMts4dI7AMFRTZeprc9FnaJNJpisKsmBE0UHw5VCf7AEK1UWaE/L0L4RJanGwLSJVajpZccNDfXV5dxqXSNgRCfILi+kvsTOI+6qtXXslPmE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/14/25 23:48, Bharata B Rao wrote:
> Hi,
> 
> This patchset is about adding a dedicated sub-system for maintaining
> hot pages information from the lower tiers and promoting the hot pages
> to the top tiers. It exposes an API that other sub-systems which detect
> accesses, can use to report the accesses for further processing. Further
> processing includes system-wide accumulation of memory access info at
> PFN granularity, classification the PFNs as hot and promotion of hot
> pages using per-node kernel threads. This is a continuation of the
> earlier kpromoted work [1] that I posted a while back.
> 
> Kernel thread based async batch migration [2] was an off-shoot of
> this effort that attempted to batch the migrations from NUMA
> balancing by creating a separate kernel thread for migration.
> Per-page hotness information was stored as part of extended page
> flags. The kernel thread then scanned the entire PFN space to pick
> the PFNs that are classified as hot.
> 
> The observed challenges from the previous approaches were these:
> 
> 1. Too many PFNs need to be scanned to identify the hot PFNs in
>    approach [2].
> 2. Hot page records stored in hash lists become unwieldy for
>    extracting the required hot pages in approach [1].
> 3. Dynamic allocation vs static availability of space to store
>    per-page hotness information.
> 
> This series tries to address challenges 1 and 2 by maintaining
> the hot page records in hash lists for quick lookup and maintaining
> a separate per-target-node max heap for storing ready-to-migrate
> hot page records. The records in heap are priority-ordered based
> on "hotness" of the page.
> 

Could you elaborate on when/how a page is considered hot? Is it based
on how often a page has been scanned?

> The API for reporting the page access remains unchanged from [1].
> When the page access gets recorded, the hotness data of the page
> is updated and if it crosses a threshold, it gets tracked in the
> heap as well. These heaps are per-target-node and corresponding
> migrate threads will periodically extract the top records from
> them and do batch migration. 
> 

I don't quite follow the heaps and tracking in the heap, could
you please clarify

> In the current series, two page temperature sources are included
> as examples.
> 
> 1. IBS based memory access profiler.
> 2. PTE-A bit based access profiler for MGLRU. (from Kinsey Ho)
> 

Thanks,
Balbir


