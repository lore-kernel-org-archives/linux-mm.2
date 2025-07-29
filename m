Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4CAC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 16:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0517F6B0089; Tue, 29 Jul 2025 12:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0035B6B008A; Tue, 29 Jul 2025 12:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C106B008C; Tue, 29 Jul 2025 12:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA9456B0089
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:09:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 863A6160194
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:09:46 +0000 (UTC)
X-FDA: 83717787972.03.49FD901
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012058.outbound.protection.outlook.com [52.101.66.58])
	by imf16.hostedemail.com (Postfix) with ESMTP id A55DA180009
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:09:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="DRh/uLJZ";
	dkim=pass header.d=arm.com header.s=selector1 header.b="DRh/uLJZ";
	spf=pass (imf16.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.58 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753805383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZa1ANcnPpTUtiB5LY8Ckq8/seimXlfZGfPPt7w0eMs=;
	b=KJqb57B467AUrD4EfvsZklOToRkDEl/SvXvsh/Q1Qi6jzGRpjebkv+gyFD6c34grmaagr0
	2DZLNXRUfb/AczUEwn3o95bg5nl9ChJgBhn7Mbv+1GbtvekZQCUUXxJwuBNY5mFnOkfcKT
	2S10ZEvE8rZeYkpNY9BNMGIjoVJnSHw=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1753805383; a=rsa-sha256;
	cv=pass;
	b=lTyLnFMvrqbWKavinywy9oV7WCmB7vaPwWFB0NW1hDqHuXodwqSfYm9YdLFoIFmMfu68CT
	/n3NHF6Rm6p5iTlNhbsUaabJtz4Gl6jFVXHu6bMrzqs6rvsoHc+yYGyHNG2B2CVVH5c2nU
	MRfbclUqHZxY6e9mZukc2STiBKIHdiE=
ARC-Authentication-Results: i=3;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="DRh/uLJZ";
	dkim=pass header.d=arm.com header.s=selector1 header.b="DRh/uLJZ";
	spf=pass (imf16.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.66.58 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VuuBV2fa+hWV2aqm0bAStdy6fTwqbLUrJxz1NV55boq5xdqZ5saDCFdFI0ATwidX9fzRZcHwMsX8MdjmrKyXeANeaeHndMMkCv5ATNYIJM4EDWnGzU5tnVcyi7iMFS1Jn2d8aLF529cm/0MaozXi9YfGL99RF4UdaeE31UpxvCzK/7qrtdYY9/6IO/mUwwioYHZbkYrXk9y7IPkaz2iGAbvXJkS1xonETlotiikJK/R0Pe3fUjra/OpK0WX5LvVW8uS0gmbExzN9BPpILPToOjIWyJfqvgjEROo38eYXryMoLTsz2+3hmpVrp3DoGf+3NlkK3RGO/uhjjeVZFnN3jw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZa1ANcnPpTUtiB5LY8Ckq8/seimXlfZGfPPt7w0eMs=;
 b=GH3krHwWp31O4l4K98XxZQljfsTcvGZmFD9E4ZbN1vR/rCJ7AEj0Mc1B8pvwdMeFIHIyguvMEngN6Okg/7CaEfB1Asz+vBpI7Yy7vGBKVAhWUZKu7iKs/qLOCpF+KSwk2O3WEOp1UotueDYfDsuY0d4M4q1UmmfJwFjyntH02ZMsLrd1fNe2KDKhSv3W511BTQ/0Dm308fPzBXinbHS9Bx+k+bO+xPVl6YDPJ/EAV0A2EEwQrrlOZa7Qa1HtXsIvjWj6PTkEXkjDfDuy2SXyGxhPODeT6uYw9UBtAY0W/XMAAsK3pmTL50WjgD0ZnnFkKviho9atO+AdEg8EW2Ndjg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZa1ANcnPpTUtiB5LY8Ckq8/seimXlfZGfPPt7w0eMs=;
 b=DRh/uLJZr6lzECID8E9bi/s0C9lVsyF3yLf+2LoFORWZ+dqumpjVPmbPDXoHUq+oGAU95+mb9mVtKLsGmeMo53Mi+r0pBtEU0MsXAOq4DN01qSLceYI/MB9HqDOb2uilp6qR+5KxTJGRdcHCchEW2muzp81oYTsIev+60Wd3MvI=
Received: from PR2P264CA0030.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101:1::18) by
 PAWPR08MB11195.eurprd08.prod.outlook.com (2603:10a6:102:469::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Tue, 29 Jul
 2025 16:09:39 +0000
Received: from AMS1EPF00000049.eurprd04.prod.outlook.com
 (2603:10a6:101:1:cafe::64) by PR2P264CA0030.outlook.office365.com
 (2603:10a6:101:1::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.27 via Frontend Transport; Tue,
 29 Jul 2025 16:09:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000049.mail.protection.outlook.com (10.167.16.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.10
 via Frontend Transport; Tue, 29 Jul 2025 16:09:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jVCHf4veohoMKwFY+/TvxjMh0CUs51RU08bVo4XEVgKzrjBpAIZcQ+sHhNXtTgj9I5WWsdxF94nh5izFYiOOF3eNoYpU+bgeGRbpd1HQZe2/5FVY25Dh8Q7MoxTptlIxsaFxdxczGRosBqttLgBh7nA13gOEzItx3sFq5lQq1SAj+7tX6IQVp+wtfI+Jhgc7bg8q8D2wcLlbK8dt8NOAaKc/hm3Dj05ZAetr+7OnQvQpXMryjxCvdLZ6U7Tpw3jzf6VyjIb9G86tMpvZ/WeVFnfv04fCo8POxrqJO+XGc1VoXhVFZPcMp3ySZ4dm4Y4KO4EUXvjV1Clo/BWdkBYbNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZa1ANcnPpTUtiB5LY8Ckq8/seimXlfZGfPPt7w0eMs=;
 b=tQwz5c3BIP2DyyUAmNsdiyCFVBGu6LFSpAIahQvalML5QTeWzDfsLXkARLlXtlKpiOIV27dtT+2xWA1de5eJIuP9ZrTt7jtT8LIxJBlLbnaS+2ITEigzG+DV3mA1bRCzt3hpv1eiR2/au/vH8qMnYc5PP7eVU5umoT3+0/ycUeaYcUf3htuLqT8lqEcHOHUsGnJXVaOCCeHJthmlr3/k85ONwA3NYdZdq8otAkEqBigiE7EJySjSAsXRTL/2Bz6wjlx5Wp5QED48BtHfAO+FrjJnJXLadjwDgZe7AjLyc+dV9qP22yN9Qsd7cKwO1QFFKG4yAkBeCLLLIej8PC6Z1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZa1ANcnPpTUtiB5LY8Ckq8/seimXlfZGfPPt7w0eMs=;
 b=DRh/uLJZr6lzECID8E9bi/s0C9lVsyF3yLf+2LoFORWZ+dqumpjVPmbPDXoHUq+oGAU95+mb9mVtKLsGmeMo53Mi+r0pBtEU0MsXAOq4DN01qSLceYI/MB9HqDOb2uilp6qR+5KxTJGRdcHCchEW2muzp81oYTsIev+60Wd3MvI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by VE1PR08MB5678.eurprd08.prod.outlook.com (2603:10a6:800:1a0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Tue, 29 Jul
 2025 16:09:05 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 16:09:04 +0000
Message-ID: <507cadf1-70d3-43fc-ab49-a791a2458690@arm.com>
Date: Tue, 29 Jul 2025 21:39:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm/damon/design: fix typo
To: Sang-Heon Jeon <ekffu200098@gmail.com>, sj@kernel.org
Cc: damon@lists.linux.dev, linux-mm@kvack.org
References: <20250729144414.31958-1-ekffu200098@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250729144414.31958-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MA0PR01CA0018.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::18) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|VE1PR08MB5678:EE_|AMS1EPF00000049:EE_|PAWPR08MB11195:EE_
X-MS-Office365-Filtering-Correlation-Id: 51613db3-9b0a-4cb0-2a15-08ddceba50cf
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?Y0pKcDFFL0FsdGhYZ3hpUmc3VVdkUVIrNmxDMWNuc3dQcHBFaXVUUEk2NHBm?=
 =?utf-8?B?N1IvVlJPSmhwYTM1Qk5PNUsrNVFZRjllZHpjSlY4L2NGMGZNaHpFaGk4d3N5?=
 =?utf-8?B?YXhqUmF0SkFyVXZPZFFGb2t6ZERrVXRVWU5oSzdyS3JyV2pSY0JTNFpaeUpk?=
 =?utf-8?B?TVNaNmxlOGRteE55UUFnaXFLZDA5NUY4S3VRQktFTDdEWk1jYXlBQkJ0UDdz?=
 =?utf-8?B?ZWx3QVhjMGFtRmdZYzNVb2haVjg2VGdvRWFkSWM1TXFNVitZZHFXejc0RzJq?=
 =?utf-8?B?Z29jK1FvdkptczZNeTdSalNYYlZQWXVsK041RnlrN2lmbXRlWnNVYnk5MDM1?=
 =?utf-8?B?S1Y0b2hxTS9kMGJjRmNwUCtOeVM4RlI4UHh5d3VmSi9nRDBjaGdhbDJOS3Np?=
 =?utf-8?B?YVFpenZNbm9Jc0F1b0tpU0xOdU83Mmo4ZDRNQ0ZTbzI0NjhkOW5nRitiVmlZ?=
 =?utf-8?B?YW1oRE1kN3p6UkJrb3BHdkZsVEx3REVxYW5RL1ViRmtoSHBBWm80MnBycWtG?=
 =?utf-8?B?OCtEaGZPWG1jRXgvaGE1ZERMeWN2VThOcHFQaHVVTXF3ZGtuNFliTVkxZGp4?=
 =?utf-8?B?b24weWh5NDN5ck8wTUliVVpQN3lYbzJNU1pvUnQzdFJ3Umh0SlYvZ3ZabjN3?=
 =?utf-8?B?cithMGpMeUN3VXlGWUdHMEtmRFlmb2NVTDN4cFlGSDlVdnZHTUN3VVBmcWFH?=
 =?utf-8?B?K2M1OE4rb2xBK0xpcjgrN2pQVjFTZVBEWHYyeFpwUnl5NVJpc1hBRkh3Q0V0?=
 =?utf-8?B?KzNIQ2hBemVtMnV1N0h0eXc3dFF5Y1lsK3A3YUpFVWJzUi9FanZBS0xFVTAv?=
 =?utf-8?B?d0FTZGdrVVpMRkxnc2Z2ejJaRHRoVHd1emJ6NlNLc1FKZzltS2JCbWF4eERD?=
 =?utf-8?B?Sm9rRVc5SU1LVFBoUTUzZ21NTzBpY3FrRWxRVGIzUGpIWUl2Q09UbWd5V2tZ?=
 =?utf-8?B?TExCai9vTmMrQStRWFhmWFViSVVSQkVNcVB4WDhLKyt0WkY2Q3ZtWW8wZHAy?=
 =?utf-8?B?S1h4WUxLdVBjMktSZHJKM1dUelNNVG1NcEZsT0RXMkRSMEZxN0lHL2VsYm5n?=
 =?utf-8?B?YkFGM3pqNXM2c1FPU2RpcXhDWnFkVzkxZVhKQnlnWUkyVENobVJnTjRSOFZr?=
 =?utf-8?B?MFF2ZG01UWxaVkV6blppb2lNTWR6dmg5aWpsOERCWmJtWEJVRVF1aHYrS0l1?=
 =?utf-8?B?ZVRLelhIZ0pzS2FLLzNZVnEwZlFEeXdVNlFPOVRCUVFYYlZscERXVC80cWFB?=
 =?utf-8?B?Mi9XYWc5R1p2T1o1OE9vTlczdWxiZXN2MFRsUWxULzl5aDRsOU5Remo1MWVI?=
 =?utf-8?B?ak84K0tFb01DVVpWSVAyelR2bERoTjIva2ZYTEtBcjhwSUNVbVFxMWRiNFE5?=
 =?utf-8?B?dWllRjEyQndoRG5IRmtwVlZ3N3hQK1YreUVyQ0d3bzdnZUNHeEUrY1lESiti?=
 =?utf-8?B?RHpWWExqVkhvMkF6WU5ma3N6TFVBU3FaeFJTQzdIUnJWb2tRT0RHeUEva3hT?=
 =?utf-8?B?R0hUMTU0ZTVneFgwRWRyZHNEdzJtb0docElidnFtWVhTbk9lN2VyeWVjYTJr?=
 =?utf-8?B?cVpSNU1LSGZLSkNxa2JCNWJRa1A5S3M4b3UvK0VPL2FYUjFvQkJRWkZ6Y2o2?=
 =?utf-8?B?VXM3dXplSVgvRUVWclBuZEJwR0FkdGxLN21RUmliLzBFVm5UU2dvKzRKL0Q3?=
 =?utf-8?B?OGRCaDAzZjNtN3cvSVhMUzgyVkJNTzZkZHJBV2dlREpmdlV3eXY3RVA3WXRK?=
 =?utf-8?B?SmpzaURSRHN6MDdYVHY1TU1vS1RCdkdia1U3YVhvMnphTTE5Mng3WC92ek1J?=
 =?utf-8?B?MmlFWlorOEpGWVI3UVV5VHp1bWpLK3BId0pBVjFudm9LVU9waVhib1lWTXo5?=
 =?utf-8?B?VFBiWlVNaC96SkZFY3hLTVF1S3prZVJMYkNhM3hPZnovdTNRSHMwbWZBc3l5?=
 =?utf-8?Q?aSHyJ+B2hmc=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5678
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000049.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a36ad0fb-822e-4233-3221-08ddceba3d5b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|36860700013|82310400026|14060799003|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VEp1cE1VU2RFYWozVldseHBzdUpCNWNOZzRJNmRVSlFOUWZyRWZwWnIzRDZa?=
 =?utf-8?B?M0ZpQ1RPQ1FoODYxdFlveHdCT3o0WjM1dEY2b09WUEtuWmZNNHYrWk10NjYx?=
 =?utf-8?B?UUNmbTVxazlBck5RM0dFK3gyY000d3FMa01CWjVtWkxPaTFBYjJMa01hMXRJ?=
 =?utf-8?B?cTl1SitVaWFLcjZDcU4ySnVmbWZPVTZEQmJoUFQwdUpXelFGTHMxN3IwZDV1?=
 =?utf-8?B?SCt1eEJQazcrMVBKdHNLcVNnVTR1czBRNDNOeWJQTjkyT0pVdDBVRzRIK0No?=
 =?utf-8?B?NzRhV0ZFVjBIMkk2OFViU0JNRkNmTm1BbmtqVW5oaTl0V1pBMWRjZGI4RE92?=
 =?utf-8?B?WDdCSzVnV0FKYmZaWWpBYktRazhQNEJldWJzeHpuL2JSKyt1dkJseWdvODBR?=
 =?utf-8?B?SlAwRFZMN3F4TVE4QUdXTVVlNmpPL010L25UcW1BanAzOUZMLzN0R2t3MFJa?=
 =?utf-8?B?eGYxQlpSNkZtOEdleCsrbG1lZTFDZGs5S05ZUUN1WUdlSXpHa0VKd1NqVjJm?=
 =?utf-8?B?cmF4SFhDTFJpTXBhVjhQdktoL0hMSGRJNUoyMnNNNzdLTUdtWlg5Z09EckV2?=
 =?utf-8?B?ODdIUWg1MWt1b0gvdE1oQnZPekFOZ3NOS0V6dHpMSWVQa0oxR25uYldYb0oy?=
 =?utf-8?B?R0xqcmtmTWhLdzdabWMvZFlUS211K1pHMmQvTjg5OFRwYW0vMnRwdE1EYmVR?=
 =?utf-8?B?dlhTK1R5cFhmdDZwSVE0dEJKR0tkK3JZY2xCZTdqTjB0ZVNCT1krSUVKRTRZ?=
 =?utf-8?B?WWYzOEFHMWxjb3JucEcxUG9VYUEyVGpKSUNOblNORnVWU3YxeTI1S2psZ0hI?=
 =?utf-8?B?U1ljWE9QSm5rY2ZZTFhwWTdqM3YwVUxaU0tvZUpyYy9oVDBweDhCWFViWFNx?=
 =?utf-8?B?a2JrUWlEeDRrWm9FSktGMWoyYVJ2VERrZ0Vna3lGeThFOUpUQ0RQaVRFd29T?=
 =?utf-8?B?R0s4RkF5OGt6WllJTjFkWUR4NER0ZFBIZDlHeEJ1YktNTXV5eVZvRzAzUjdD?=
 =?utf-8?B?Y2FYSFJPSHlZbE51TlhOSlJlRVNCNUhkckFKQUhjZzgxVUtMQ0wzQXFzNTk3?=
 =?utf-8?B?bjhuams3Sk9XK2Yza2dEanlMcXd6bm1ZLzFTYWl5dHdXdVVCa3ZxaUNKY09i?=
 =?utf-8?B?KytZL21kc21ZOFpZRmt5SWVtVC9FSHVON1FsYW5DeW45QnRGdldiSWdjRmdR?=
 =?utf-8?B?SENkOEVSYXZ5dzZ3TGx3VDRTZ3N0YWZLK3JBTk9qVDM4ZnN0eE90bjNRakR6?=
 =?utf-8?B?UDY1eW55aGR2MzhNMlpFOC80cHB5K0xFengyKzlwWCtITUR4aktmeHhmUXZK?=
 =?utf-8?B?d3dJV0lkaEpxWW9LcGswNEpGQTRSYnY4Zm1vY1dPYzRQR1kwejhlZzczSVhk?=
 =?utf-8?B?ZFA1RUFBZVE1ejN1UHAxUGtDK2E5WWRkNnkxeU94bnFsdkpLM3hjU3dXL01s?=
 =?utf-8?B?WGtwQTkxZnFlek0yZVhNdHRjUmVQY3hXaDdVaGFTU1dUUUNyS0JaNjlSVUE3?=
 =?utf-8?B?Y3NEczNmZFRMakt3ZzhOWFJzNVZjYlhybmNoMFc2d3lEN1B3SFhVL0ZWTFFs?=
 =?utf-8?B?d1FOYVdUTDNpWU0xclZWZXVNWEFkZGphUXFGZERLb3lWN3pmc3IrVEZFd2JV?=
 =?utf-8?B?dW0rTGlzd3BkM1JGMjRsbE5UOU8zaDZvSkdva2ZYcEhHWVV0TklPUThiQmN1?=
 =?utf-8?B?UVBqemJrVERwbjQyLzNpb2kwZnRiY3JxUk1nN1FDN1ZVSHhGNURYUTF5OUJq?=
 =?utf-8?B?Sk53S3V4aW5sa3JEdUdVUWJaQlFLdmkzV3NnWC9hVEpuUlhDdVl1WHVOWWtL?=
 =?utf-8?B?cFRTbFhyZnVPRkdDZm9mbm82VHBJWVdRNktXQ2RCbWdoeEluazhUcExRNnZT?=
 =?utf-8?B?bDE2Ynl0SmtJMHBRZzZMQUdpQ21qRHIySFQ5NmtzdnAwQ3NuNUpTMnZoN2hv?=
 =?utf-8?B?eHhCT1BjbE5KQVJhVVRLMk9WaDJQbmlzUk5HYjZMZHFqVFJzY2xvOCtwcW40?=
 =?utf-8?B?SUQzTlBlK2VlalNLYkpaamdGSmtXQTB1RHc3NjVlOWE2Z2pxUi9aK2pXQWlL?=
 =?utf-8?Q?qKaQTG?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(36860700013)(82310400026)(14060799003)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 16:09:37.0483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51613db3-9b0a-4cb0-2a15-08ddceba50cf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000049.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11195
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A55DA180009
X-Stat-Signature: wqx4ze9ww6xkp43nwqt86qqr58a3fwmf
X-Rspam-User: 
X-HE-Tag: 1753805382-918580
X-HE-Meta: U2FsdGVkX18Av4ZO0/lFOY/Mp3HYiWyMcRT3Qyudv8ocz0SgocqfrzEuCsI+wvMC1t4zdKwA6jF2c567JYq1QQ2+vCplcdhADMEwQga3hJf5aHvBuVPGU/kFZKdjjtb4oyot3WkIYNlli017ZQw5TbTp2RdUX78n0lH/PwgI1AuhiFOBWpM2aBU6XC84+3Zty4J0oohK/MJq8szve/67c8Fxy6FJ1igGL2pMMbFInJ8IVcDVkY7pND71RnjB4yQaRCS0gteTzrzmelEflnlrcp9xx9pIkMUOXoT4sFp8j+GQVP4T/EpAi9k90WkuF+J7eIlEYALrOHx3FlsNKVCF2x3qGV4eke38OL55EwplthxTqHovirVPT4VqZd4cDZO9NjuKgIEx4n+PduANePrsapOlD9nkg9t1uUgUT1zbkkPeeLv4I2SV2cXKvmuS5dPiTaWTFdQzx0BuJrHoUWZdGrYkjn+EQzEBMAZs6cqsKXA+ipyNbL5b5jtbpMiRcvDTo4U5uKIyXCGyOv/OKtjRDrONDUTj8jHqjS9OGEplj9K4/pueGtAzf8BLRoaNncvRWcqxcQsUEYnezKj49OuFwKz978hkZSlapdSFqeoIU8PsaRw0g6XGrpnerA+W6D/a8eLGxXrER80Ib4/T4izTpMf2r2/elBDO2vODJ9CM/7cp6IMRajHUw2FZZ3ROicy99Li5crg61q3oT4loe7AaAVOVURVukncwevWa7IkREWYfbjYmPS7cqn5jFTSZSFllpbT0gb8Ey3oTDc3Xde4QANxKgOeHhYfR/LeN83DHBlbG9unL7i/VYuRLqA2aREZqxthxY6h740mqU4ivzRITmD5aMoYMDoLHhBj2AT2msmoP6Xu59RjrS8ehkEGw50kNFNji25v0UGt5rLqftCdufBBOfRpLoGF1GwzMKdX6zoceS11X8gMwrR0esyMY5GubCe97tE63cRiGP6ZEu82
 yLu+Tr2u
 QCAJGYD8OkGFJ7fC81Jd0gAJiTucuXCLNwTWlt0BgyLfffA58TdxjFLj0aALotnxSR3355aV6I1o5of1b7Fe0y0oXnwa/1sOnGG9FU63PU2SnZyZPPP5UBKkwaXl/Uhr3wUwRVbmioCVtgjribHUhRnFRy9MF/BLOYNmyy8/O8p7RyTGHrAIF0PVFdMCw11NkJhBbz3PMAfe2Sl5CrhlwEi5Mtm8+NHl/vWMjMCgMITIogNGhUIWcY2l6jM2et1jG4QHlSLmyIH5ndo6BMctwgw8FdFPu25l7+mq1c33DPOs1sy6SbtecBvaEPweLgEHsoPpi31tVZ/SumWs9EDqgWMIapU4nUSCpd82xloAvcGPUgG00L1axQv7V8DSQNMqoxaWqUGhc2S1O4xRYy51d7t0Fr2RufTCarX+2L7sn2sjtKrooi2rLEyPshkh5QfOUNzbulh4Vt/nKrWIVO+pgxWPH0aEFkeWki4rpKtGyoQzQoMpvQD/WpvNWN7PV92hdkbkx9W0LCnILPo4dsYG8gLtLYO+bgcvdzQDAnCupIqENP4KMI8OqU36rmyyw/FNl6rdOfYCgkZuv6Bw4oqtwIJsMg3b6vrV7cNHBdroochEn8RiM4rt4l6i+jQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 29/07/25 8:14 pm, Sang-Heon Jeon wrote:
> There are some typo in statistics section of DAMON design docs
> - sz_trtied -> sz_tried
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> While studying about DAMON subsystem, I found some typos in docs.
> This is my first kernel patch.

Brilliant!

>   So if there are any mistakes, please let
> me know. I'll try to fix as soon as possible. Thanks for reviewing.
>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

