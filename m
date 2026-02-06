Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EE4EEE20B6
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 17:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44F286B008A; Fri,  6 Feb 2026 12:04:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F92B6B0093; Fri,  6 Feb 2026 12:04:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282AD6B008A; Fri,  6 Feb 2026 12:04:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 136716B008A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:04:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9B001B0662
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:04:47 +0000 (UTC)
X-FDA: 84414656214.06.F0BFE9B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 37EF32001D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:04:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FNyizJ1b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Y0RNETYP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770397484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sj8ZX2sgAX/kINLxdC63a2gAD960rt2hkQBDdL8Un2A=;
	b=2p7aYUSOjLz7yE6q8t2BKxcGdsxVkYxtltSmfPeprL/7Iy1e1KJc1y2DzwRQ+0DKpgKwSY
	POQyIG3/Men6sSeS4KUXpyc6LF9kTKeTM629MOvcfbLolTkuFuDOh8JxndRtMJvbWJRWhq
	jVN7TVPqYusaDlGuEnKnYN392q2lYwc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770397484; a=rsa-sha256;
	cv=pass;
	b=cWc17HJdalfWOW7MnAZntcJSCyqsIG9eLXLaxKzjP5Uii/PK0ns7GyCVxVxQsc8QpD3DgA
	rMb3KkK39W3dRIKcwgz3HZBuJNHGiEWSyLITnowgUXg4HQ9aMlXvY09ux9j2j/TwHNxSUZ
	kkHCTpZeGrgQFXBEZBZRtx1qORctLNE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FNyizJ1b;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Y0RNETYP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 616Eva8i3198928;
	Fri, 6 Feb 2026 17:04:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sj8ZX2sgAX/kINLxdC63a2gAD960rt2hkQBDdL8Un2A=; b=
	FNyizJ1bnuyJtoSQmlZSsd+rApBaZwPmfNCrIWDTn/GYYf9knsHUACNUrvy7qUN0
	iyvDB42RtEpWOqDVhgdImDXI5zbHDHlOOp5zScaEvTeAXOcoJNybUW7hEPqQQafr
	VbixBmQQPc/4wLKyCMbc44W83Su1wDvgRdI3wdNhDCFxJ0jfvU/CAQVW36l4SOj3
	MrvYEV5jwN3G66dbrxFL6vsshILmySrLAakyfmTMEejqz4aDc1OvR/PelgLC+Y3Q
	8aiH2avErPi7zNdbsBM6iZJDji9hlGUE28b+t3O+ug1MWlM3coAt0p+wH3qxAduV
	rF0aZ2sxD9jFr8HQNgbC1Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c50fmhhdv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 17:04:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 616G1su1006708;
	Fri, 6 Feb 2026 17:04:24 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012012.outbound.protection.outlook.com [52.101.43.12])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c257detyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 17:04:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xmT1OF/mbo0413mNlAjFKvIfexdpLukLbNsmTkJ84BJavMitdBKPUfKiAKCCdeV1S6qa4o+twHjS+H2XHTTtYdxVAoH+Gtnj0DGNdICHuJsRbJ03s4VrMmfUqVxugawTuyu5HGOS+3J78Nr590h0Y/QSKjWDBeI9h/j4hnW6YKnhoeggDOVepuABZ8RGRWMLIkcng7lSq9XefxaM6FaQa3Q6oyVM6fs82HXkxVxPXqq+9bw8OvOBlGqH/b+UxTbQa9rCFu1Tsv0CXcrtPx5hPHud70SS/xsfQiHvOOqfE3Jj/GiZ/hNySSya0EceHfPXiiQtXgF+Hq3rojIP7xL1Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sj8ZX2sgAX/kINLxdC63a2gAD960rt2hkQBDdL8Un2A=;
 b=pK1Az6phDG1fVHH5qmY6g0FmyUdYyU6jQw/OGQpyIJQ2xwoZViwRv39XfFJJs6tygYVbVreq4EmWpiDX+qYjc4qHV2WCD7l2jnqiEfMqUc6BJlN4KgjnHCrod+//MsBkMd/WgK5IlkFs7IwCW6A0/95vrc2RS6vpbviLpkVoHhQE/39nwl6OFa6WgdOR6aEDNhbTdisBGdDpn6+5orU2D1kWUbKAyiPQUENyrcz2yBJH34kpwNvJ4EuKWJd94RGgPqYG8S0lY32xR3uEDA8Ttju2+C1jzp5I7GiaZdlbfd9ozt8h6oJYMF3ytZ1lvUbUPMh+zJtkn43vA6O03yyXUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sj8ZX2sgAX/kINLxdC63a2gAD960rt2hkQBDdL8Un2A=;
 b=Y0RNETYPCk+OUbre+QCFniYYuBqtKbPV2eVQt9KBFuWpSNz7IMjfVnOl1xXyxOZYR1gpKVLtR6qZWBK9Ny5ie+6IKK8N43v555IrcdAR5v57Q/tCZ+iFMEB3AxSrk1eMmTPxIk7qoih3NZBbDxQaAjRYWiwfMAId+XCImHy0ZW8=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 IA0PR10MB6769.namprd10.prod.outlook.com (2603:10b6:208:43e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 17:04:21 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 17:04:21 +0000
Message-ID: <02a755d7-fc08-4b65-8f31-d45235596209@oracle.com>
Date: Fri, 6 Feb 2026 09:04:13 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: reject unsupported non-folio compound
 page
To: Miaohe Lin <linmiaohe@huawei.com>, akpm@linux-foundation.org
Cc: nao.horiguchi@gmail.com, ziy@nvidia.com, shicenci@gmail.com,
        david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260205075328.523211-1-linmiaohe@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20260205075328.523211-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:a03:180::25) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|IA0PR10MB6769:EE_
X-MS-Office365-Filtering-Correlation-Id: b1ef670e-6bab-4806-8a53-08de65a1c576
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTdaRWQ3aEFJR3NlNk9yTGU0SkMwTFZjZDk0dStuZmdIRHg2amhaRDdRaWRt?=
 =?utf-8?B?OERGWVlCc2VWTUJkMFV2dEFXTThQWkNVYnN5YmNWVW5tUkNlcmR1RHBsZkdt?=
 =?utf-8?B?TVBmeDF6Nm1lSUp5MXRYaG45c1dla2ZNRitwNURlaVpLZTRBTktHUFdlWVpC?=
 =?utf-8?B?aWtCVVV0Yms4Y1BuS250di94NXJ0OGR0VHkvdFlRSVRSTC93T0hSU1dZbWl5?=
 =?utf-8?B?Q1hvdVFuNmxVUlkzVHNIakorTUpodFhHSlNSNDVHN3B5aGN4ZWJTdWlXamRL?=
 =?utf-8?B?TTB3Ky9JUUFsOXhIK0xiZnRZL3hNaXpCZlRVV3k5bG54amlWaERrRXBHdVdB?=
 =?utf-8?B?cXM4N1VybXVYdUF2TTcyMTFjM0M4OHNUTVBwM09ObzdteWZNTnoya1NuNUVZ?=
 =?utf-8?B?RGJtbmdsM3BQTHk2YmRWTjFVZVAwSCtzYW51aUJPTFhFUVhpKzZYZFFIeGg2?=
 =?utf-8?B?NVF2MTZpcmNUSHRJL0ZHYUEzRnZHbnY2YU16eGlsME91OUxvRUtsbG1FNmZJ?=
 =?utf-8?B?Qi8yTUViVks0R2YyWDBWaTdEUEJzUUNESUFKdWhjSHlzTkgvT1pKWU1jYjVj?=
 =?utf-8?B?ZExialJTMlBNY2xkU3dacE9rQkU0Uzcxd0ZZbXJDRzA3THVvOGtydGROeGVa?=
 =?utf-8?B?WUx4UDRNU0ZZSTZlRWZxb3pvN2FTQWNpK1VDcm9GdnFKWEhhdGlmSko1a0Rx?=
 =?utf-8?B?Wkd5RkRLSThNMHBBZTZHOHJjTUh2dkNqcTg4R0dFNi9yNlpMYmRCRlo1Qi9M?=
 =?utf-8?B?VVJVVU95ZmZmV3BMSkxQYXdhOWp3U1VTUk9TdkYwTDdsQ090ZjNzV1N1NndB?=
 =?utf-8?B?aVN6ZEFtUHc5dnJvVHQyYTlDYi82cW5ERkFHaUtlejRoa09IY3JLZy85UHFn?=
 =?utf-8?B?dSs0Ty9rb1JQMUNWMVBjdWcwWndQb29oZ0crak1XZEU4Ykk4eXJyL0g4bU5N?=
 =?utf-8?B?YjVhd0tER0hENXg4UDREQ3B0elZFWUZuQmpnRXNnL2diNU90SHBEMnN6cElW?=
 =?utf-8?B?ZGJhdWNnSXJWUUl2VDVGaWQ0N2JUM0ZUZlRyOHVKU1BwYzdPNEJmNWM1YVI0?=
 =?utf-8?B?VjU0a2JvQ2ZYRkMxbmJGTGg5ZjFYVFVjUGsvTVpyZ3doS3grVURxRzJLZHAw?=
 =?utf-8?B?Q1g3L21OS0xPbnlvbjFGRHBIR0x5UnhnK2dpMVFVVkhEVUxRM0pKOEVlM2RB?=
 =?utf-8?B?dVFvc1M5L1FwbDUveVl5Wlk4dkg1Tk1oZkFqOUtaNlFGT0RmcWYyajNNQ2xX?=
 =?utf-8?B?dW1FM2IxbUFpNSswQ3I1TGtMSDhJTm5NK2ZudWs4TXVDSjZNbDRwNitIZGNv?=
 =?utf-8?B?OXhyTzduSXk3bGJjTGcyc2w5VFM2MnlVRHphMTBvOW5FSVpsRzN4Z2p3MnVL?=
 =?utf-8?B?V0JCTXJwazV2ZG1TbmhFQm9HVEFTVW9OSjh3dU9YS3VRRnA5TEl1VVUrSzI1?=
 =?utf-8?B?c0tUOTZJNkdjSkU5NVNhajBwb1k1MjZueG1OMGZFVnFXTGtiS3RzV1l0SkU5?=
 =?utf-8?B?UzZaY0U3dTRiTzZRRi90anlFbVB3TzBoQnFqcWQrV2lGcWV2MCswcGNpMS9Z?=
 =?utf-8?B?ejRoMlZYZURMODhmQTdFSU1uMTVZcDJQOGEwVWQzN2Z2N1BBZkdHMFNQck91?=
 =?utf-8?B?dE9XRHBlTVZJS2xTbWFGVkE3ZklJS2JraGRjTmluTUpPK3VoM2pyRGZENi9v?=
 =?utf-8?B?T2lkTlBpYUpkUEZPdVROU29Zamp6QjN4aXhZMmVvR0pFWlJSZk5STW9wMjNs?=
 =?utf-8?B?YWlVcEhaaEU0Z2dNVWlxZCsxQkVMd2tWc3BaWENMUEpJN3l2aHlHUEhmQ3lk?=
 =?utf-8?B?SlhwejFOd3BNSXFsL0RRUCtiM0tiL1F2RlEvMHRIaEhibTlySTJ5bzlvL2Ev?=
 =?utf-8?B?VVlaSXEzSW9hSDZLNWN3NGN3dVVCVDgxT0JPVXJUSWZUajBpaldWQUtzcXdq?=
 =?utf-8?B?SkFZN3BYMFpVTlAwbmVYOVREVHQyZk5xOVZvM056ZlNZWnQzeGg3eXFmQW9H?=
 =?utf-8?B?Um5rMEZvczIxaVYzNk4yRjI3M1FJUHVzUXZvSFlGdENTSlZobWJtZ2cyUXcy?=
 =?utf-8?B?L05rR0x2emdVekhUMGkvSVJORm85YS9GQVkzc2RMbVNhTUthb3cyVU90YVRO?=
 =?utf-8?Q?Sjvg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTVTZUg5OS9hRDk5YmlNODRnMHhFd3lNZnI3NVkxM3kzVGpXR1Q5cWtOYVpK?=
 =?utf-8?B?ZXBoY2EvUG44aHVkUWxtSVRGR05HQlZuZHJ1M0VRcG1MaEx3QXA4aGRCdGlY?=
 =?utf-8?B?cFRJLzVwT004R0h3L0FabmpCaG9remlJUDFidmUzSzhuQVZ0YnB1am9STU5t?=
 =?utf-8?B?K21maTFmOTB6cXdsdThmOEt0cDZEYmVYZGNnUTZtcnYyZTFCK2srMUgyUzFI?=
 =?utf-8?B?bkVkalVpTS9Rdk4xQWZQOXBDV00wN1NucG04NlNNdDBDQWNVc2R4Z2VlL1lV?=
 =?utf-8?B?ZDJKSzgzTmVVWnJjTGdkQ0NFUmQ5NFdvbXpTbyt3S2JnQ1JZcWRSNGpJTTY5?=
 =?utf-8?B?Lys1N3l4dzhnTnE1NWhxMUFrWlZmRlJ5R3drRzdTWndMWVp4Rk5zTmNPeXN3?=
 =?utf-8?B?RFZOMlFSZjd5M1NzQlhRRFlKRWYrZ09YOHhzcmFkYTgvYlk0OTZJQVd5dTRO?=
 =?utf-8?B?bVVhSURoUE1QdG9OL1J3cVJMa3NVY3AvRXY1RkM5eG9tcDNTakM1VWxNSFAv?=
 =?utf-8?B?SVpmUFdiM1lzakJ3OEF4NE14SG1BRlJOaWFjOStjMHYzblQ0a1pnQzllTm5u?=
 =?utf-8?B?OWxpTjdaSFpwaTRTZnNIcHQ2a01FUWxtZFo0aXh1Znk5K0lMcXBQRUd5VFR3?=
 =?utf-8?B?emZYK0VZNWk3WTJjdU5zdWpMRlczUzFXcWRpWU13eVRFNGFWQ3MxS1F1MFNV?=
 =?utf-8?B?OURjUnNuQ1lrczcvbGVYbk5lTXpGemhoV0o3V0ZHV1RZOFVVbmlzenJyTlda?=
 =?utf-8?B?T3piZERhNzJ5TUZRTHZoZXAzR3RCY0hBWWZyUEE3d25pQ240b0dWcVFWVEVI?=
 =?utf-8?B?b0U1Ym5zUmFXLzdhQmpsdS9XTTE5c1J4QUp5eUEvanBGRlNNT3JHNUgybHh4?=
 =?utf-8?B?VjNZelpBM0hIbEZPY0FHQjIvSGZiTmpPQzBOa0loL1dEQlhJRXZoWnY5UVBQ?=
 =?utf-8?B?NHJhclhCTjh4TUgvQmwzY1lDMTBDZVFYK29EK0hkR003aVYyQ3ZuUEhvUE5i?=
 =?utf-8?B?c1N1a0N1UnVGNm1ic1VkNTVoczY0OXdudlBrOWRRQzc3K0U5RmJSQTF2SC9n?=
 =?utf-8?B?aWZmREE1ZEZyY2c3SU52U2pTQ25URktpaWhvMWYwbGVrM0h5ditNenAwRVRH?=
 =?utf-8?B?L1owaTBXWUoyYU5RemppVDBtTThvYm12N01tcmZKVC9aTG5XNFNkZ24wSEdi?=
 =?utf-8?B?ekdWUHlaQjF5RWNqTEdJbnk1bENkaXlXekJjU1lydXFtVWpyQmZlWlhjak9z?=
 =?utf-8?B?ZFlwN3ZKRkVwcmRieEYyV2VYTFBUbjMyNlQ4SG9Kc1IyQU51RHUxOUtrRThN?=
 =?utf-8?B?b3lMVndsTldDSkIybXJBbmdCV0NrS0hVazE5MzhvSTUvL01NMDJRK1NoM0p0?=
 =?utf-8?B?ZUNRRys3MjF5b0N2VHNjODM2Qy85Z1JQaXlSbVYrMnNCSVRiOGFEUm5VYTlO?=
 =?utf-8?B?bXVDdWJ2NGxHTVZNRnRxSFc4TmxkY2EvOXdyeDU2OGJIUWVlZTFYNE1EZ3Nx?=
 =?utf-8?B?d0F6MGxuMFlNRHNXQXQrTGtkL0pTZTI1Wlk3a3pJT1k2MXVJZkZkVktBUnVp?=
 =?utf-8?B?K0cwd0RzK2k0SGY3N1ZJRmVhN3BTQlcwYXB3QkRkUitrcUZJdGxRKzc0ek1V?=
 =?utf-8?B?ZndrQzNVQ2VVd2gvclpNSzRRaDZEZkFLMWZ3ZEFTaFkrSFVzZEtTTW54ek1p?=
 =?utf-8?B?TGtOWURXUWVqb2txRzdSai9kRzhtSFhWS1RuQkVNQnU1WUMrNmJoaE95My9U?=
 =?utf-8?B?UG5NZHZkeUhMVGQvRkt3MWh1SUVTdU1Kakw4cDVLRGh4TXkybUpqOGg2UndO?=
 =?utf-8?B?THFNZG1sTmpxOWxYcVFQbkVvcWlQUWVJN2lUR3Y1OGtQb1A2bTJHQkRPYkhn?=
 =?utf-8?B?Q1JiOER1SVE4d1pVRWx4MzJmeWFyL0F1Q2pGWWlDb2VHZWROWmdxd28zbzZQ?=
 =?utf-8?B?VUM5RHhPdDRwYkl0VFphTENyNm9zY0Ewa3dRcU1iRW5OTTBJMUovTnA3RVJL?=
 =?utf-8?B?YTlBejE1VSswdjkrZjJZdlFXRmdpa2owS1VqWUdObFZNRTFPaTk1TVJrQWQ5?=
 =?utf-8?B?UkFQUHVtZ0Q4dG5QaHFUZEt3Q0FMQi9QZkp0K0Z4aXRUQjdiVTUrWUZyRE9P?=
 =?utf-8?B?STNBcUN1aVlxaXFZMGNqRW5Hclp5eVV1aVJHcWFVQWFhdHZick5NNmVrK09N?=
 =?utf-8?B?KzhmZ1U1bFZjejV0bVRMbXlZNCtSS1BYaUU1NDc5M1hBMXRQRHl1RnBISVh2?=
 =?utf-8?B?WU5mVVRKN0VuRk5vVlhFVE1XVDNnYnZrdUdUbWt2N0JRck9iSmhrQmZRUVFh?=
 =?utf-8?B?NjZOYlBmemZoOGZzWXAwbmZ5TXk1UHRocG5wS2dsNTcraDZyaklVZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cQslF8T5s7A8pxEavnT+yMSlHIAVygc4pCLj8FnbzMX2/B4iVUH1h9/BzHwBXo5TjGoR/cRMnMse7Ca6ZIG5EIEbz5wO0+QPmbsg+0VmAapUcSv5yxgOHHm8W1mAASHAuWNnWtFXs8/IW/011lahzeEI14wwoebpUU0B3laBDBwgbgFdqtlq92+ESL8SUe7GLVWx9XWj0yYhUyE3kJ+lYDA/RQMlo7SQfRka/Glr3n0t0fxxtLDe0jxDUct9pVRFMtrAQkcoyBdOCNDIipccgIy/fwlwbBagTT/9FdaFnAtPLt5n+TRkLqSTacfL0zn80jQ6T+mRzVFJPHKVVFMWpecOTRMRBvGO1mXI1a/GJ3KMPYUFbUCecaoSULAqH9Ydpfli0s6thUqJiNKZe9yljXakwF2Jw0o3AOoM6gByK0mDUErfiDhtA7hcNCaoWkfbVqfMp05XoxoG6HIpxyb4QuIW424nax+SSW1fZh+HY/J3mXrHzOtwjumZC/8Fsfj4DQdq+RxeHZVgy84diXoGjagm8rIQXUpeCEVbGGli+z1r9d6hFDspUjR+Gu80CYPk+DRnMlL//9y+u/WTVaZnVf1F5sksujOwMBqi3wW55i0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ef670e-6bab-4806-8a53-08de65a1c576
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 17:04:21.2226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmp5HF1868s94YZSS6EEC4SOL04ewXOxfXLAZtMjmkdhafaV0aZ4+/aYnsJHcFaxVgqpTW8IG/Ubdu73IC0j2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602060124
X-Proofpoint-ORIG-GUID: 8rMXrZqsfNvNBXPK7KWARRsd150bujpB
X-Proofpoint-GUID: 8rMXrZqsfNvNBXPK7KWARRsd150bujpB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDEyNCBTYWx0ZWRfX+UbryJ1WMNeD
 HucnzLZhN4pHfGDTMwCN9hFeoiHjrZWt2eZKxWrOpi5hE9TjhnV6TAnE6hTbLP+Qjs6F2ulWvKM
 kfjLTh9ZbwsVuVhrNPjz9TW+TlrEjaftABgBmu2+Pfkq8GruU88ArNOCfDIHmEx9QuHdcTSPO2R
 3ToAs/vJfQ0tnh6o7gWQJ/d6fvzMtI+oszNQTLZxNt6Dp7Z7h4ntpvtggc34yO55Dh7llg45UXH
 rZ/Z1SvyAvzFBvY3lv+xOCGCS0JvdoWK4/Xd3pXNzF0kcayGQtj/zWZgHWILihG+1cEAQ/ib/I+
 bQj5EFwdaUeyla5ON6qiWOcOGNRdHMcMS98Rvm3dR5PmdA6gUn9WFrm0jVNfd5HbNfHC0FfkI+R
 t9t48fL2MrtGKFNmHSXyV/JDGgmgq/YwfZ2m/jFr93STV9NDyjAkQPx39mUkAibnInUXEhEmj/S
 dPM4/btIBNKS30PUMRH2LfppuE56+1b94MEcUIHY=
X-Authority-Analysis: v=2.4 cv=BcbVE7t2 c=1 sm=1 tr=0 ts=69861f19 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=UqCG9HQmAAAA:8 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=i0EeH86SAAAA:8
 a=yPCof4ZbAAAA:8 a=qwTfJ958v9BsXIjLZhEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13644
X-Rspamd-Queue-Id: 37EF32001D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 17awt48d6fhrd5su1e8mj94zy6o6cfoe
X-HE-Tag: 1770397483-954750
X-HE-Meta: U2FsdGVkX196EXfiVt5pLvPLtjzQEyHDDvRw0hYA64WEPaLEgM+LFYps+CUxkrm+FE2QRmNa1rE5bK44LCF4sEUymelfEoafZhXlPDoBcfFkw28uFI5iORK10gln3ZRvRrG7otfJpmmoaT/NrZY0XuJKoUZIJ9D0lwP4xSJX9lHGD4EkyWTK5JrL8ClszGI3Ot0cgkgumWzbrhuTw9Mul30VcezA0MGnGrttoSk/mElRBFChZ/VvRPKwA0h03fPHzoBtWxXL7PomGXw8dsh5X24XWvry2um0QJLJXEZfPbnP9QBPp1pUXl0VzALWb4z04hD4ehMtZgOQl0lj3Q40aEfvTini+20i66keOouYfKjDNSKU4/js3Y193MpsOn73fHw4nZp7tPb6fZZ8ZjtUgFZYuRR6OKD8/WYNnI2L2zHxq4T/YeOJX1d2WtfDlFsm9mwhU21ej+aYnqUNlTI2kqTcbtAIGkjCdaG4YW9jHxI0mLxL1ywxdi4JJh+Oz0zncrE9cv6x1ISG+E8BJwt6zG3irg/nmgQg8Gdjx1ZuqccG/vKGXBT3xWjQYVcsoh/LwVTKMQnIGWhQ1yjA7sH4sszktaotACUkjqyWszSUy7Dko8SlERt+qIUjahbjBaKxEjG6K5Knc4q0rnJQDwmvdkWtPYEvcCFV361pOCOqeSvqavdlOenhK7Q7ZHXx/KGqVcICS3qCeQZgXgx3O1ZCLE0dta2FmSj/aoYlOKEHEkjNRW2a5PuVDveOml0fjguVcWyo59wdI6IXxmUU9zqR/QzXvoxGN9/exZneN5yNZl1dAxYh+mIKNiKFSo5SGTMnbz9SfY5WOQJsvR8T8w2f1/+As3XsV638y3gI1cnu143tmU4EP+l8Fv4FU+TFN5H6cpKGDfRJJkKodzVJ2aHuTBBbhvjs2v1f17WRzeXuzLD0sTR6KlaMcW6Qw0vlX7QC7MGQo6yvXVSHjitE+Tt
 fCcqqR1O
 0b4hodxh1v7Nwl3StpR4K2EMe3aXrijE/pWUKjJ+yHS7nqKAoEQPiP3FxoUCEE/c50Q73W6CMg0rCJVy6crOc1GPhAmFxCuK9qBKENGTL9psSUuM0Vm+nuYmgaTNV++5Nzu/HydIIOy5GLsvvyqc8kD55lj+6tdkwEgy743lUPTVqI0MkD9kxtaWjHv8a6pUVpeE4sBUcyee/g/Urz7zUVSVX0Nutk8p0hNybaCaC6+JAfYrjxmcR7u4G1E3Ha1v5D+r742N+vqn8nHmpo4tjjiZbhnPDSBly8XcOl4BRMC6IWOwNU3HWsLSmV05WgjKY7mEuBwNnznXISc/23EV4xqCtfy2f14f4xX0HXLCD68mx72LKXD8H7DAz1y+mDmEs1heZm5ThuvyrVC0BedaBaOFZkakRNcgEDlm2yoZ3FjDbzawbBGA++HbK0vQ+fHzpjLIa6qh2IK98a6jKwYurSVPEZpl8Y7rk02wzVlA/gYwwIiU/RztQOUQGCVT1q/w+lOHsDB909nOGGX5jOLtVj6wL+2Uq/Hx2CLqJT/JGYf932ujQoTK6PWPS9tU06IcxxD76Xdktq31seFzKsmAvoCNbaSS6sgKQ5Msn7uJRysCEHGnnz+HHVbC8gOUZ8geV/FING4hEd0Lonk9nr89V3/QHOQsVqAWnui8Z2ZIA1BijSdodUsUIETjpxrruHyI5djP/yskcw85q0LJa9vsUPOm24VypF3EdZgbsSCASxO8iLg5njBPV2a98kK3D67c8l5/E3zmC/wM2L7VrNboHw5k01EOb6qzXHCC+Occ1L9pAg9BGUofAjrmJKsJiOtjvKcPs4rMbBX3Ur7qmtdIRxm/pLTPN8v0UFAu6ccXviB77Dc8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2/4/2026 11:53 PM, Miaohe Lin wrote:
> When !CONFIG_TRANSPARENT_HUGEPAGE, a non-folio compound page can appear in
> a userspace mapping via either vm_insert_*() functions or
> vm_operatios_struct->fault(). They are not folios, thus should not be
> considered for folio operations like split. To reject these pages, make
> sure get_hwpoison_page() is always called as HWPoisonHandlable() will do
> the right work.
> 
> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
> Reported-by: 是参差 <shicenci@gmail.com>
> Closes: https://lore.kernel.org/all/PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com/
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> [Some commit log borrowed from Zi Yan <ziy@nvidia.com>. Thanks.]
> ---
>   mm/memory-failure.c | 42 ++++++++++++++++++++----------------------
>   1 file changed, 20 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 825c706ac576..ba4231858a36 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2411,31 +2411,29 @@ int memory_failure(unsigned long pfn, int flags)
>   	 * In fact it's dangerous to directly bump up page count from 0,
>   	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
>   	 */
> -	if (!(flags & MF_COUNT_INCREASED)) {
> -		res = get_hwpoison_page(p, flags);
> -		if (!res) {
> -			if (is_free_buddy_page(p)) {
> -				if (take_page_off_buddy(p)) {
> -					page_ref_inc(p);
> -					res = MF_RECOVERED;
> -				} else {
> -					/* We lost the race, try again */
> -					if (retry) {
> -						ClearPageHWPoison(p);
> -						retry = false;
> -						goto try_again;
> -					}
> -					res = MF_FAILED;
> -				}
> -				res = action_result(pfn, MF_MSG_BUDDY, res);
> +	res = get_hwpoison_page(p, flags);
> +	if (!res) {
> +		if (is_free_buddy_page(p)) {
> +			if (take_page_off_buddy(p)) {
> +				page_ref_inc(p);
> +				res = MF_RECOVERED;
>   			} else {
> -				res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
> +				/* We lost the race, try again */
> +				if (retry) {
> +					ClearPageHWPoison(p);
> +					retry = false;
> +					goto try_again;
> +				}
> +				res = MF_FAILED;
>   			}
> -			goto unlock_mutex;
> -		} else if (res < 0) {
> -			res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
> -			goto unlock_mutex;
> +			res = action_result(pfn, MF_MSG_BUDDY, res);
> +		} else {
> +			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
>   		}
> +		goto unlock_mutex;
> +	} else if (res < 0) {
> +		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
> +		goto unlock_mutex;
>   	}
>   
>   	folio = page_folio(p);

Look good.

Reviewed-by: Jane Chu <jane.chu@oracle.com>

-jane


