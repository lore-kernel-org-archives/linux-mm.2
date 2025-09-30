Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD607CCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 15:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251A78E000B; Tue, 30 Sep 2025 11:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202088E0002; Tue, 30 Sep 2025 11:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A3108E000B; Tue, 30 Sep 2025 11:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E48CE8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:28:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B7B1BB5C1
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 15:28:29 +0000 (UTC)
X-FDA: 83946298338.06.642BF90
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010020.outbound.protection.outlook.com [52.101.46.20])
	by imf15.hostedemail.com (Postfix) with ESMTP id BAF8DA0016
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 15:28:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g8VVbI0K;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759246106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HiQRhv73wbULoJMolOZTTMgrY1RuNV6Kb4S9cohSUAI=;
	b=yAV39od46+9zvnOj9sTDNrMM+a/rvJz56LwvhL3QyQko4U3eiTf2bKN2bPUBa2cwzadVgZ
	fgHPAqzCyKb53opqaTjU1NPyncJuwrlY4Vwm8Mo5RsELr/DnCenFZ80T06NvDeXWajfOfH
	IRxgjpXPHc8qgYzsyEvb6+TQXPlkMsc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759246106; a=rsa-sha256;
	cv=pass;
	b=z1lA+qkTkNwhNc5P9ByAz/+HlqkhmzZH+hwySTyjirwf1JJbdyjfq2QiKhSpDM6MnFXYkK
	pUAsIPlU2xjapIX9CJvvINfUAAEYnyQasYrPToTXygHIa20CN2lpyHSR79yjD6ER1zkDor
	+BBU7G5UGExQ07Etsju5bWtRnn7RrPk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g8VVbI0K;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jJrjnDCJ8ZvMoK3az8yhmLb3PGkR41El5mSZzNqJITxjSXNjCt1muTf/pfHYv1s7A66pSCYdcwEMGn7tufUjbyt6Jwc6o0cYahBlAY5i4QUJvpcAyGONR6QmirRQUGHJbaOyNaVnvJIhcBMaI7Zu9/sSXWsxOXhPTFVonPKE67fJQXXvADNIv9rXiDkxVSUA6rHthCd7G2CHMhArmxL03l3P5BpWUivhL3MimadAgTvaIcK1Zs5vmfEj4a5+8LdWYpXNwLOCzMpTw7JSBh7HlvcJhEMZLcq1Z3XalTl5ods/6ir2VH9Qx2oEHKeAjHy21N4fsiN1dq5rE202nJID9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HiQRhv73wbULoJMolOZTTMgrY1RuNV6Kb4S9cohSUAI=;
 b=Y69grLS5/2OKo4iDF0RpIDkdQhaGNpwPOQVM0WxQWW0XC2AmAp5Jiw1stvxk4XFfj29YFBbQ9SFzphpdGiLWpSXtrCtRBHLH5Avgv8I80kJ6ZvmCku9baNuHk9+BJTpHXydKpEwaLU6O6vx/rHdulI7wz2qhsSra4P55No/iaTD/ijZR0WUQKwMwldZMYSh1Ar1jfNsZiCnbXhbfiI0adI4/Y4mjj8RGeIHpcO8zhTAJ+HB3qMXVT1XjCJTjBIyN8sCAC29gJzQl7Q1EZa48rrwW3oBotyFCmhL8jyH4sqty66t911vTJW6CYXSYZhryTcGnEgvwmmbbipvCboanLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiQRhv73wbULoJMolOZTTMgrY1RuNV6Kb4S9cohSUAI=;
 b=g8VVbI0Kp1vdenQjk1AQTynbaLXaJnunVsSJKb5Rt8psbPN8iTze3KaCEtcaUrEMwX1GA01ANVDR17JcvNP3gdpHyDcM3u7xUdyTiyAGrhSbHSuh10lQ8jtCmw6IMr949un8hMCoAyXjoM6a1wY+Y3bCq6SlJ1hLyakZksHX0cVHOk4ufOrYj9lB4w+pqL+tlRk/uYZIT8vdIh5vnvM9H+VVakIvg2dS3eW030XXVJWnVlqiOsc9vKxkT+C5XVL0hmZyb4VpAV/r+eVMGtrk3qveFCemFXpGB6THWOltL8iJy64a7ywEBwB2tHfgs91kYWOK1VNLjmbyUTGVGFsybQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB6793.namprd12.prod.outlook.com (2603:10b6:510:1c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.14; Tue, 30 Sep
 2025 15:28:22 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 15:28:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: Vlastimil Babka <vbabka@suse.cz>, Matthew Wilcox <willy@infradead.org>
Cc: zhongjinji <zhongjinji@honor.com>, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, liulu.liu@honor.com,
 feng.han@honor.com
Subject: Re: [PATCH v0] mm/page_alloc: Cleanup for __del_page_from_free_list()
Date: Tue, 30 Sep 2025 11:28:20 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <C317AB4A-7593-46B1-BEAB-E683BD7C1CAF@nvidia.com>
In-Reply-To: <5181a289-eee7-42c1-8bdb-7b7bb463babc@suse.cz>
References: <20250925085006.23684-1-zhongjinji@honor.com>
 <6fa0e2e3-045e-446f-8ef3-955711b6aa82@suse.cz>
 <F1AB428D-73B3-4E40-939C-2A7BAEA1E73A@nvidia.com>
 <5181a289-eee7-42c1-8bdb-7b7bb463babc@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0883.namprd03.prod.outlook.com
 (2603:10b6:408:13c::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB6793:EE_
X-MS-Office365-Filtering-Correlation-Id: 01f9726a-2964-41c4-d3b1-08de0035fde2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QjF4b3ZBdU16NVRMckpHamw3VHQ0Qk80LzhWU0dvQVMrcDNRY3V6Nkdrdmp1?=
 =?utf-8?B?UzRJSFM0NzBVT1lTTXE1RHF6Sy8xYVR4R080YXh4dm5wa3JWWFVaSmJ1ZkxM?=
 =?utf-8?B?VkM1cndTRWxOOEhycWppNm5NbXVhNFhPb0FHWDJjcE8yTzNrSnhGeG9nUWdx?=
 =?utf-8?B?U2t0bnJlaGFxUkcyUkFiZm9pK25hdlhlNkpuWjJ3UUdSdE8ycUlsaEdFL05O?=
 =?utf-8?B?SGZsRnh1K2lnUlQrN3MvT1g0MUpCbUZLdnJ2S2hTWFNTM2Uvc2RQNHJzZ0tX?=
 =?utf-8?B?U2lyMHFTViswcGU3Sis5Z3NaK0ZiNGlSd0x5czR6c3JVUlF1SVB5TWxNaFJh?=
 =?utf-8?B?bUNrYkdORit1dmZCM2ZueXZ1bmhOcUExRXNwS1g3NHNVVGovajBoWWFRRnJ6?=
 =?utf-8?B?WlRObDl0b0VKaEdOWHAyUTF3Tk9Wb3FFQmRxRUZobFA1MjErK3kydzZTZFZD?=
 =?utf-8?B?N3N6Z2ZUd1ZFVjlxak5sY3YzVU1kWS83amY3a2RkVzVCSTU5ckM3WXY0ODF6?=
 =?utf-8?B?ZXlqY296NGR1cHBvK0Y1bjJ3VmNKcWlGWjUrVDlqck5UdHB6em9tY25wakNN?=
 =?utf-8?B?dmpGSlRsN29QVHhrQ1pKN0xqQkFYSnZjTGZrNGZaRkUrTEZlOGFTeFB5QkpL?=
 =?utf-8?B?VldSSzVSVVM2K0xqR3Z5WUFtUG43a0xUa3B5cGd1R0JIL0FOZmN0U2l0YWE0?=
 =?utf-8?B?Nld5cGZsUEZOSDAzMTV3bXpxQUFid2hqa25iTEFHSTczQ0dEbmFqNFByM2tM?=
 =?utf-8?B?L2M2RWlIOWVlbkJhKzFLT3lzTGttS3pWWTJLTTdFYUVEOWM1c3VGTXpURzhL?=
 =?utf-8?B?dWFMTVltR2dGME1vMGwwQThES0FhWmFVanpXUWNVTVhjeFN5SHhuR1c2N1A5?=
 =?utf-8?B?SGlxenJBQTNKWEgraE1xdjFjSGpOeU1JME81NVRvRUVIbmZWd2U1dDViZHFJ?=
 =?utf-8?B?MXR3VktQNmdvWUJ4U2pVazY0R0NKeGJWdEVnaHRVcVpJKzJBU01jWTV4bXR3?=
 =?utf-8?B?dFQwNWpwa2ZhQy9yK0pCbzJUU0IxbnVXV2hwaU5LNkYwb0hYQ1k5RkVNbnQx?=
 =?utf-8?B?Y01oaEw2QkMyOW5DOWxCSW9IUGZMQkNZbnBYczd1QW56WEhIazBFejhOdlV4?=
 =?utf-8?B?N1ZzQVdRaDZ0bmhYRnlDS0grcW5xTStBcDUwamtvNHFaUGFSTXJhQ0xnRzQ4?=
 =?utf-8?B?dU1UMUw2OW9XSk4yWFFXWWd6bVZkYkltcmhHaFczMDk0MGZoQWY4MU41MDJw?=
 =?utf-8?B?cFFJaDA3RGlNYlRKL2NKd0lpNUZPN0JnUXQwamtGMFlDV3ZTSnVTcXMzdXVr?=
 =?utf-8?B?N2RVTlZYTzJOTERFRmxHaUpDMHB4ZTRzZTB1MmxkeFA3azJ1Z21PRXlhd3J1?=
 =?utf-8?B?ZGl6NDQ4ZEtxM1ZCRjJIUlBkUjF5QnJRc2hVWVoxQkNBOHd2bFRkVk9FRmlL?=
 =?utf-8?B?MGY3eXQ3Mm51WGVBNi9OVGNVaGJtbk14aTdEWVlrYitkd2RKSlNLRVdLN1M2?=
 =?utf-8?B?SUMzQU15TVJ3czRiQ1VMWUJPdHlTVTU4Q1JURENTZzNQeU8vbjBVZitSa1lt?=
 =?utf-8?B?WlFkYThsNHVJc1hqZ3JsVGdyME95bnV1ekpjS0t1WW5sN015VEx4MUlTZ2lw?=
 =?utf-8?B?Sis3QXpGVHZpUkVFbDB4M2tkdkM5WFBXRjdzUHZqQWVWeWMzeGViNGVmZk12?=
 =?utf-8?B?MU9WMU1JRXVoMlZYK01ycUc4c3FpZUp6NFk1RDhCZ2xuek05L1c2Q3JPUklW?=
 =?utf-8?B?MlhpRmhubHBGTXZzeVo3VENGc2tLaVVyUkM4R0pjMjZWUWNPYnU0d2lONTB5?=
 =?utf-8?B?YkZyKys0SjcyQm0wUUV5Rm1RWE96ekxmWTAwQU9mU2M5NjNZeGZOY3pteWox?=
 =?utf-8?B?QkhiVjBTUFE2YVI4eWtlSVRBVnI0WDg2VVZ0TFhYTFZkMnZ6K2txVGhidkFD?=
 =?utf-8?Q?gNfN5p3rDGypbOQyUd6CjXF0pJOZOOgF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTcyMzkvdUl5WHpBTWU2NUR1TFo5ejU3QmdNQnd1NzZrSWN4V3pUdjlwdW1l?=
 =?utf-8?B?NXJHVU5mMm9XT242a2R3b2MwNGFudnNyL21FRmxKL1JVc0p2ODZrOVA5OWZx?=
 =?utf-8?B?QTNVVzFwZzNQcE8wY3dCUzFhK2RLSklFNW5CQUxhZG9jM0ZyS1g5dmgyZ00x?=
 =?utf-8?B?UC9Od3FxcGhFZkI2T2xGaTV1M1F5a21KVjg0WXpGVjZUQkFvdGRidDB5cTYx?=
 =?utf-8?B?TW85VEVjN29WK3ZlS2xIVlYvcTZZbXptUmYySDdaYUoyVDl4c3lUUmVvMnVi?=
 =?utf-8?B?aW1rWHIvNEg5SmhMZXhoanIwbHYvRllxZ1drdEt1MkNxMFZzcEV5cVcyaFhh?=
 =?utf-8?B?Lzk5S2Y4ZVRoVDBOallpVnRNVVpOMkNoUDVzclpSNG56dXlHVTJva1NWZWt0?=
 =?utf-8?B?bEVESFZ3aFhqS21GUkJpN2NuVDZwa0JtUE5USE1uUGxxdnF6T2RoeWlxanJq?=
 =?utf-8?B?WkhLSUQ1Nml2dCt4cytENnJlQk5oUm9JZWVLUDhKbnlBdGl4SFdqL0FCSHhS?=
 =?utf-8?B?Z0JuL3ZIZkZra2VJWWlGZFIvRUpwS0ZSYWhXSDRnZDVzdkxqeTl3cThGN0hS?=
 =?utf-8?B?V01XMVZQUitCcWdZckYxNjZQYnpHUjljOWluVSs3cFB0NWJuVEdrNmFhNkNz?=
 =?utf-8?B?ME5SejZnQmNUZnJOcW1IeVJtVmpPK0JaVUV4ekY0aDRFcW95elVVMFArQjlz?=
 =?utf-8?B?NjV5TTlWUW55ZmFKajE0S04yMFIweXNvdzY0aEUyaXRSaEt3OGlqRXkybk9R?=
 =?utf-8?B?bkZDUHVJa1pzdWZLcXJOd0U3NDcvRGNNQWgwRHVCeEZJNitub2RaWjc1bW0x?=
 =?utf-8?B?M3lqaEI3N3gzOWRYVmVSdUhRaTVneUxaVmFONHNpWFBUQWk2c2JNY1JvZjcx?=
 =?utf-8?B?ZmJOT1FHZk1LOHdaaFZEaHlTQ016MWxqK2o1d1RlaDU4V2V6Z3FNeHVKS2lm?=
 =?utf-8?B?eVZORU00M0NsNk9mQmpxbEZBK01Gc2ZGR3hGUldZV0pueEVWeXJrZkhzNnlK?=
 =?utf-8?B?bWQ0cmVZSkZmbDFRMGVLL1ZvNUZ5VkNBcWRZU09lc0QvMko4SG55YVZvd1Q5?=
 =?utf-8?B?bWRiUWpLRnB5dWRxUHdNUzNXVEFmT0ZDSmF1cnpZRmNUdlhEa1NHUWZ4VTk0?=
 =?utf-8?B?S2paMWg2b1loYXZuQzBBZW15TjNtT2s0azlvaHNKMXFlaHgzNFVoWDJNVUxP?=
 =?utf-8?B?Q3NDNDdRYW5Jb1pxODhGc3lxR3hSRkt4YkpNMVpXeEg3Y2l0UVp1R0NBTytR?=
 =?utf-8?B?NEV6UDhmcmtsRzZzK2h4bW1ybjZZREUvS3hGTEwraGRyZDNKS0RaREZFTUw5?=
 =?utf-8?B?LzlJMVlRZnFwUmZNd3N5aTlKclJ2WGNWNDZrM1FGTjlGV1VadlZqOVEwK1Vq?=
 =?utf-8?B?a1VtSWhJTzhuTUlFSU9vbjdOWmI4K2xsMTh1UEFQK0JBUDR0Vm5yanBucWlB?=
 =?utf-8?B?Z1FEMWRqZ2x6WTg4bXlyckxWQmlzZldTWkt3cHlzelI0SGszL0VwOEVHVzE0?=
 =?utf-8?B?UmdueXB0aS94UEFJL0N2YjJoNy9NY0hFT0VSWllOeEVoVG9WOWl3UDRESkh5?=
 =?utf-8?B?SlpYc0ZhbS9TMG80ejhBdFh2Z2lHdVM5Rmp0LzhkUHJJeTlHWTV0K01EeUZV?=
 =?utf-8?B?WDlJOTZSZkFac3YyME9GNDl5ME1TMWRwdXgvWG9sS0lhSmxxbGNFbCsxNDd5?=
 =?utf-8?B?VFo2bjNjQWVYZTB4aExKTm5PVzJCN2N3ZFkrK1EvOGlTQXFFeEFVY2J2R2xC?=
 =?utf-8?B?TnpwM0lGT0czR0Q4V1JMRytON3I0K1RWcmd4MXBaQ0EyL0daeG1KbzgyUTRD?=
 =?utf-8?B?dTVKem1NK3lKN0ZOYjBFVDlvNjE3bFRuenlsQWpGZUlCYlpRYWI0OVpRdzlM?=
 =?utf-8?B?cktJR1NPN2U3OHRTY056ZzFQSllBb29xdE45TlRSWjlJN2dGYTZLaHMvNzZS?=
 =?utf-8?B?bllMaHhBV29KZU43M0VGRUgyMEZKU0Juak9JdlBvKzRveFlUeVp3NkNhcG1k?=
 =?utf-8?B?emJTV3RSRmlYZ25aUHRPbE12cjIzOWtvTHJrZUpZSG5qYXVxcTRxaURJS1J5?=
 =?utf-8?B?czd6RDh6M0kwOFg4bjBBd1NqdHRyR0JTV1p6Y2JMbDl2YW9HbXVldkFxTlV1?=
 =?utf-8?Q?0tuFNaMsxzSQaqdM+dkynls8k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f9726a-2964-41c4-d3b1-08de0035fde2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 15:28:22.7620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OLm+2P9SDtHgNL3cN4II4mw4vLBMYCdUt2lXm+l7WjLCQyE8mfsoGkfEWEEktQ7r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6793
X-Stat-Signature: ec6ywefsuejh8rg4n96f55qscbuno4pz
X-Rspamd-Queue-Id: BAF8DA0016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759246106-192363
X-HE-Meta: U2FsdGVkX18TzCqA8yijNOmm8cvY6FSZCbCmWPI4JnzW4ibmOQ4ZF7u8/sE5puK5Pm3KgEBQwkI7xILcMRVRY9fm672tcaqddp1aHjd8fxmLjHKI3KPDvo8bZVjmACKLsAmwXXqrydGN8/MTTmcdwh1xZyUf5oju9GdCpL2VjaoasXFWADicdupQJ6TEfAoK9ghxI8yjcgnAaUJLA5M+OVWLHl/ghq/k/gwoAdvHcg9quu37kp30RZb/XYkfWT2PycAeCQuSUeUIV/taJhI/VP8YUMthDCCb79TYxMnXW1FDQWvaVo2wOO2OpU2BHnYbL7HIG6OuHaHuj2khoaaeI6ZJm0KDJN6/+VTf8ncDiDwMMhGY0aonQ8hY38BSHC+VQ2WpzAqP45MRx1b+fxlF4iGK0eg7lMI8YM83/IAhUYwzgzreNDoY8POUSawdk1/3UvqXy57zIOPZ+2okU022jdyUTdweZP3sze/jN5tKCxAXkw4cPKiThZdmGmdC0CYb4inSo3FByoY1qzHE0CPtluUDWXT6fzNkzuBZqxzLpQTemB9Zu0YUStTp8euEmRsYg47ZOgPmslnftmNJfATe0lrYi6wWFl0gr6RuizJUz9KX+G8MFKIzuhXLlnFlKx8nxAFTmrtk0EnjwiuMshJxTQ3j03Z5j8IUTg6hxmlyBePZF6L3YoufyQYo4/sewgbHAjOThEbWTDpMD6eZ1OGMA3Ojo2d2LJ2Ofb1NfnY8wYZ/OQUiMp2c/RXvEQ+oa6tpAb14dC63PPLdAc3NeNLlg9CETgom4FpYaEbEQWEeftj4tD68MhViJZmOGbkRwJH379Uq86ReL7Xz5hTH9Q75qV6B5dUe64JzE9XdkH4uxkz7twZJJwPqeVsAkRzNlvDwd7pR27sODhnv1ZpGuECiOysnJ7WGMVfH4Nxwkk0WB5t1RMTNEiyFTT8umTVqz6ibTCMjthYEo0h2Urck2GR
 J42buvI6
 SfSx4NubtG7PLOk+DzMHlBjMNMm68o2NJnwp/Fpc+nIfWlsDvo2gbjRe/d24is+H5k3YkubmePPAyVw80cKoXs2tOoWrVH0KZF9rVfqTUj+T5dlLij77TRFfOXqNWWxnnVWUvAlQyedYuUAHhJMhhtd2HHGaWVPs2/XgbR+FuJU+mxKeBYjX7LaMd3O1s3hRUJrgI+cN9hNFz+xgyiL37Z268JR+s1pM7sJkBw4UpuDJCRRz4yYeXJDT4+r71LVld/XeRuzFDcnO+Endns+ZdYCkugvOnLl2HVsG5GAOz/4PAPXTsofZ9OfXT3BAzd2HkaLl5TGyGeBYaOStyOERGFSx9/rHIaM8/RrauiJ8OL3v60WIye85jjamlu29Cld9B/bIpPltffeEfVnmh68Vb1I8vlWoc7ym0MaBZFS/m8NLLwUApLl90Wk+lCTl3g7jVP9aGvC+hDTth7syUc0CPsw157atBvj9HeelhcdlbBHfrJ0EBZAUlbEuqW4nKwL6n8N/OF7KlkuFItrH+CCxdMkVdzLCGcfrzEZav4LYHBphNBpDg+Ax1auwpXPAUtECcZ31pjJPIMt/cjd/z3eXEeyDYWAFJySLeS3m8jx4/CCmBI2lKS1WItWoEGuPAQ8iBbxl+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Sep 2025, at 11:20, Vlastimil Babka wrote:

> On 9/30/25 16:28, Zi Yan wrote:
>> On 30 Sep 2025, at 9:55, Vlastimil Babka wrote:
>>
>>> On 9/25/25 10:50, zhongjinji wrote:
>>>> It is unnecessary to set page->private in __del_page_from_free_list().
>>>>
>>>> If the page is about to be allocated, page->private will be cleared by
>>>> post_alloc_hook() before the page is handed out. If the page is expand=
ed
>>>> or merged, page->private will be reset by set_buddy_order, and no one
>>>> will retrieve the page's buddy_order without the PageBuddy flag being =
set.
>>>> If the page is isolated, it will also reset page->private when it
>>>> succeeds.
>>>
>>> Seems correct.
>>
>> This means high order free pages will have head[2N].private set to a non=
-zero
>> value, where head[N*2].private is 1, head[N*(2^2)].private is 2, ...
>> head[N*(2^M)].private is M and head[0].private is the actual free page o=
rder.
>
> Hm right, tail pages...
>
>> If such a high order free page is used as high order folio, it should be=
 fine.
>
> We don't reinterpret the private field in any of the first X tail pages f=
or
> folios? That would be bad too.

I thought so until I see the comment above page_private():
=E2=80=9Cpage_private can be used on tail pages.=E2=80=9D

Now I am not so confident about =E2=80=9Cit should be fine=E2=80=9D.

>
>> But if user allocates a non-compound high order page and uses split_page=
()
>> to get a list of order-0 pages from this high order page, some pages wil=
l
>> have non zero private. I wonder if these users are prepared for that.
>>
>> For example, kernel/events/ring_buffer.c does it. In its comment, it say=
s
>> =E2=80=9Cset its first page's private to this order; !PagePrivate(page) =
means it's
>> just a normal page.=E2=80=9D
>> (see https://elixir.bootlin.com/linux/v6.17/source/kernel/events/ring_bu=
ffer.c#L634)
>>
>> I wonder if non zero page->private would cause any issue there.
>>
>> Maybe split_page() should set all page->private to 0.
>>
>> Let me know if I get anything wrong.
>
> Maybe we could postpone this optimization until struct pages are shrunk.

Yes, I agree. But I think willy could give a more definitive answer here.

>
>>>
>>>> Since __del_page_from_free_list() is a hot path in the kernel, it woul=
d be
>>>> better to remove the unnecessary set_page_private().
>>>>
>>>> Signed-off-by: zhongjinji <zhongjinji@honor.com>
>>>
>>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>>>
>>>> ---
>>>>  mm/page_alloc.c | 1 -
>>>>  1 file changed, 1 deletion(-)
>>>>
>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>> index d1d037f97c5f..1999eb7e7c14 100644
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -868,7 +868,6 @@ static inline void __del_page_from_free_list(struc=
t page *page, struct zone *zon
>>>>
>>>>  	list_del(&page->buddy_list);
>>>>  	__ClearPageBuddy(page);
>>>> -	set_page_private(page, 0);
>>>>  	zone->free_area[order].nr_free--;
>>>>
>>>>  	if (order >=3D pageblock_order && !is_migrate_isolate(migratetype))
>>
>>
>> Best Regards,
>> Yan, Zi


Best Regards,
Yan, Zi

