Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F299C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3586B02B2; Mon, 17 Aug 2026 11:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 873946B07CB; Mon, 17 Aug 2026 11:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762C46B0829; Mon, 17 Aug 2026 11:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE8A6B02B2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:19:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB206160722
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:19:37 +0000 (UTC)
X-FDA: 85111120794.04.11FC221
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012006.outbound.protection.outlook.com [40.107.209.6])
	by imf11.hostedemail.com (Postfix) with ESMTP id D876A40009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:19:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ODk6udi8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786979975;
	b=JoCJlT1wl3M1sMglI0R3ngv0NvvxvJ3jOyEeoNO6fgx0esy+DDnpMRzVsvOm0LGae5P6rI
	MNLRkmivM6I4PrxNZf70mj2Zr2sfCTk5zoy8QRsZ97Yms2R+riKXO6re6vAoO6RJoB36Hc
	KEstecneaQpoB4avheCzxVarbNz1PfE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ODk6udi8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786979975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6IMWgN66r5tR3cHCw0xOxHgzvmoXAo2WQNENDAjIoHk=;
	b=wuK50BUrbvqsTPXaA6aGHndge5sufYvxCsxUiv4e86r89lFgzgU21kLD64vRaVas8WKNNh
	1ucvLKnK1sqrtLBBqPVvNhvEtMqAmZdzlLcp4JBIT5ehNM2DAQ2mMT2sJD+39yjdvii7Cf
	G1SBMaK9UBenRY2XIKz0uGFlWG+MhMA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DrVzpCP/+WRzAYCJgERzJJOss65JYKYn9pBi35CwC1f5f29DVedrtjw8fRCd9O7fkm+M7ucI+w4CcX3m40lAa5cqLCoVbZWd59CT6EdCeGofiS1AfCGptAW8lRRT7nn3dzVXU2IyYkW6Aek2c2VWXKF4o6nemMPP7HmzN0EHL9b0oQaqJF/EZ/7WRh5cRRPZYv9ibvxnr1Xz97UCqjQyV2cVlvv0V+5z0GyPFXoxj+pjTuhUTsCepCCCCbRX6r0l6QNSzKaTDDufgySKyrHFRdC0vx8dmwNeH2MtupR6GwuFSYLwgVbgyyjpME/LWyFa4AhozvYzUaF8eCy3O9VRhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IMWgN66r5tR3cHCw0xOxHgzvmoXAo2WQNENDAjIoHk=;
 b=O3VysvxOCbS/4P8+eYFwuUjJBYBcUKiWX5qWqcv8mcZ2oo4WUv0VNknWB1XgSo2zlqGjXZMkf41sbbPJ7lD8PJnME+YKMm6QW7nPQD4G3EXxV47fypT6uG+XWpkz5pHbl3p5MD3fqQxm9wlYNTnyX/+LDQqmrRv6wwePEo8EcyAd5chNh+Jk1HCSSCSjIM9OUCzaoA62OG8eTHh1PQchs7FipTZNYJ/ppKcD8NRtK2fKoZ3xtyWkoCNM9NNgSK9rtOL2TYdE7IU4NciVxFqDIv/HzJ7EQoJiVanabD1CV21zIQTJkuAyHJe85Th9l4hYhZ6clG8Psv5l04vjbBuhVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6IMWgN66r5tR3cHCw0xOxHgzvmoXAo2WQNENDAjIoHk=;
 b=ODk6udi8WqN813GTRvV3BBr3X5gL5b5GnaSm62t+hCuiI2I2TU4mw8IthnvY9wDoltAEaT0EscNKHFxT0BEwDOuDQvMXzfKLV6e6QBIsInywBPcEX2nC0OeoIkWZ+x0Eiv8pEj5k5qvSCTWSgxTFRQHQt2XdQzsN16NN1HC7pN4pLn7B4VtNkhyhWbo0tt4IbKS7gFvXUW6pDM8qWmJgzJuZ0YQt3l64lq2RKsSu2Kn7u57YinXlThPAlDpVyvSAhBxokK0NWFRS0TEZ30gabcg998ABjxFtraPcMbiJNrBv9mtx1/o70XqE+N884DcNyt0FuyGV0w/4eiHojSjTPA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB6887.namprd12.prod.outlook.com (2603:10b6:806:261::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Mon, 17 Aug
 2026 15:19:25 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 15:19:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
 Andrew Morton <akpm@linux-foundation.org>,
 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
 apopple@nvidia.com, byungchul@sk.com, david@kernel.org, gourry@gourry.net,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com, linux-usb@vger.kernel.org
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Date: Mon, 17 Aug 2026 11:19:23 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <1ED81A86-22F2-415A-8CC0-7E9B4A4446C2@nvidia.com>
In-Reply-To: <2026081745-unshaken-retread-d744@gregkh>
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
 <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
 <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
 <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
 <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
 <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
 <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
 <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
 <2026081745-unshaken-retread-d744@gregkh>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0876.namprd03.prod.outlook.com
 (2603:10b6:408:13c::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB6887:EE_
X-MS-Office365-Filtering-Correlation-Id: 955020f0-32e3-4226-b27f-08defc72ec46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|7416014|18002099003|10067099003|22082099003|4143699003|5023799004|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	xJvtnDNNncuwOVEkLomalTVSbjkIpIW357QnmkKh7gSscoVwWC5mWLPOZ1FoUDDz/IiY1yHoK0+hkUzt3ZsMyxj8u1g+f9+oCHTVFsTCxwWChv1UWLg56J1LHkSiTre5LbU99VB/vkewx0Q4h4mz9PmtsKTM1fGshYsgN7uXvFya0TpPf/YBJfsqQlU3PIf/pmy7N/4RL2aUVjLOBHONsCeDiS8CIz2iYU0OpdZZfOOYYZT3/DiHf32hO8XRJhk/E5vj5a971FxPQiJCirW9A4trKyb+gP+dI6Fj8fqo2wJK6dOeB6tqkf7YnWm7oPrl1LdIBU5HQMqaSQEylPG5qUN0T9UG/PGnA6KO3BIdFbscKuTOJEV+CFvutJD4UYQd4jhbW2j2wJ0H3mfgc7RS9XYS67P0tMS5wUXK24cTBNoJLXsggCe9E+n9JtsMCU1qATineTNDAnNJhtVhMm6oUyvXN9Fsv96/Dj0JqwhSzAnHnVG5x1X5eeB1rqBM/4Z9Kg22U8qOAmdBUfvfL5mf41lViHtbKaDdRoGCZFl6mlLZv5DdaJsXK7Ky3heV7OKKXe9jzcA0yTvc+QEgG6K0nJgLOpQeR217VM/1aKPkQazHjLhGHGh5I2+VsY3AMwl1WRTnWpa4nRZyrxRa10YBIsmmHbaGsgfTPuxaD5LIHa4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(7416014)(18002099003)(10067099003)(22082099003)(4143699003)(5023799004)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Kys2ZjU0M2xILzV4R3JqQXFINU80eDVwRzg2T29QVURjY2lKTGN2bWdaK3Vx?=
 =?utf-8?B?VmxTZURLTURuNzB3NXJOTmYvVVYvR01rSlpteDJFZk1xdlhxRE94ODRmRmJ0?=
 =?utf-8?B?UzF3UWRVYlB3RmlhMmR6eC8vaS9SV2RKN283VWJ0eFVscVBzcEpjUzA4T0RJ?=
 =?utf-8?B?M1dwcDJxbFlsWHBXc2puOWVlSHFRZ1dncG5RUjVNaHBoUzJBSmttYW9mNXBv?=
 =?utf-8?B?UGJyekozL0lFVW1mN2tnWlpxZzRHSkxBKzhUTDhVNVdiVlZIcWdIZGc4b0tN?=
 =?utf-8?B?TTN2ZFZuSEhmZ1Y3dUhFaUt3TGtoSEZEY3hYTEVWMWVla2N5aURqRlJTRTdY?=
 =?utf-8?B?ZFd3YTgrZXhCeG5yRk0vQXJKQnA5K1NOUDRjWUdPQUttdjhOWFJNNTJ3czZG?=
 =?utf-8?B?MkVwVUxpOUhkNEdBVjNLVUIyT0tNTHU0V3FaUGg1Q092NXFyanBaNWFPT3Rj?=
 =?utf-8?B?TmtGU1EwejJmN2FFUUg4c09xYUxSUjdyWWlwYkpMU3BiZ3RJNDRXT0tUaW1q?=
 =?utf-8?B?VzU3cEsxRHVQN3hnTEZhakpjclc4WnQ5ZEJQTnhJYm5RTW9lcTlrVzR2V1hR?=
 =?utf-8?B?NGpjSzVKSkVIeDROUmV4eG5qS1NYZCsvR3BEeDdKbjh6WlBvRVhGMWRZNytP?=
 =?utf-8?B?QWVjdDJ4SXVMMEZQUW5pN085NVI1MDVFQmtTV0V5dDM4bjIxeFJvWUxiOEFl?=
 =?utf-8?B?Z09qOURrUytLay80enFsWUFBMFJJdHZuLzlPMExvOHIxMlZmeVovNm9yVzVM?=
 =?utf-8?B?bmJJNWNNN3BFTGRzR0p5MmVNUFR5Z085MFMzNmxobHpuS3JtMk1UaURhMkpi?=
 =?utf-8?B?R3hGc0pLSEk0b1VSM1hDSDh0aGFBeThqWmN5NW1ESC9abkVHUUtQS3JqdENy?=
 =?utf-8?B?M0t3bjRDQ1IvRktKUUdGWVowSGcrK3RLbTY3Mm5oNEdsWlB5UFQvL2RqWnBh?=
 =?utf-8?B?cWZOQ29BUHZ1elVVenZHQUJGcjlRTXNudkhwdG8wRytncXcwU1RtaXdDbEo3?=
 =?utf-8?B?UHhjblZCTEUvc0hJTDBqaVoyM0psakVHUzd4VVJ5ZGt5Qy9xb3pUZjJqSU1l?=
 =?utf-8?B?bFVPODNQSk9lbEExd2Y0S0FmK1VGSEswQjBkb0FXU1lpRTRJRU9tRG5jSW1Q?=
 =?utf-8?B?NytiQVl2RVAxSE1aRUd6NXcrWmdvYmpTYW9WWjRFL2dZek92anFoRndVUE5h?=
 =?utf-8?B?c1lpOWpyUWVXU0Z3cmRZUVkrQWNRK2diT293Qk0wLzhLYXRkYXlOMHFubmd5?=
 =?utf-8?B?VTlOdW03ZDk3ZERaWTk3V3pWdkdJOXhjbTB5ZU9odm4vL0ZwUGxrYitZQnpB?=
 =?utf-8?B?TkxpV0xSaDVLUDB5TE1xODBvY3kvMjZmVG5yZ0l0NS9DL2NXSmFWeDRiK0tL?=
 =?utf-8?B?OTA4emNsRmoyMGFJK1h4elhWVVNTWVU2bWVaMGZGT0JzTEpBekVqdU1mQk9l?=
 =?utf-8?B?MEJuNGlGOXR2amFDbktjbFZONjVOdjlXeFlSdW5ZaExJQi92ZW0zRHNOdDdT?=
 =?utf-8?B?b0xIZWhIbm95MXE1a1BHRHVyTUd2V01BNmFneUJkazV1MTV5NTJnNDlWUy9k?=
 =?utf-8?B?TjZUSlIzVUdQeG8wcjI2YnVvSGdDY0RveVVpUjFmbUVmVWdWdldCUDNaMkVo?=
 =?utf-8?B?Q3k1VFZTbDZSS3o2M0VJNVZyOW5iaGxHZ0hCcEpwOUI2ZVNXNjhUUWo4eG5w?=
 =?utf-8?B?Q21BN1NWcTF4Nms5T2dsbWlGUnpsT2tjSjNXV1RxSDN6QkZnYmp0YWxNZDFX?=
 =?utf-8?B?U0NhVWlIZ21OY3dDSWFZQnA1T0RpOURSVVpFbjJzQUpKNmdHOTUyQlZtbnVX?=
 =?utf-8?B?S2xYajFUVXpLNE1BbFJjQlliRFlaSkZaK1h5d2VZYnNqNHJ0Nlg0NFNONzNq?=
 =?utf-8?B?ZHVFcytvSkpwUlN0VjVVMWpaZ2tWTG1IanZEblpxNVJST0hzbkp4cWVIdXYz?=
 =?utf-8?B?YWhPeVgxRGdRWkI1SHkwalhvMEJDT1l5bHdsaXd5VVVsTEdkc2xkY3ZSRkcx?=
 =?utf-8?B?dDVYSm90bWU5Q0dmcTc3L3Rabi9EUnBiYTk3YUVzekpZZjdyOW9VaE1wNEpr?=
 =?utf-8?B?M21xeXJKdVAvWitNZk9yclN5KzdtaWpzbTNMWlZKMm9qNGhSWVNIZUtDRnY3?=
 =?utf-8?B?MjVHNlMvbU94U09pbzRCRVlpL08xQXl5ZzNSQk1reFgvS21JK2ZwZzRyK1p0?=
 =?utf-8?B?UWRpQjVCZXRycVFwYlVQeU9BL25GMnphSG9TcUNsb3VSUURGSC9NSWdMYUh1?=
 =?utf-8?B?bkJXK0RtOXozU0lvRXhRT1lST1cyNHk2TVk1dGwvdEhva0RnY0FQektxMitZ?=
 =?utf-8?Q?tAgqYFLDzLMu77+E/g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 955020f0-32e3-4226-b27f-08defc72ec46
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 15:19:25.5101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XfrNXAsH1tJLT/M5/BLdbY4RRX4QgvZVszJF9Fvcn4Ijxm2REsJn6ilzicvjc99w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6887
X-Rspamd-Queue-Id: D876A40009
X-Rspam-User: 
X-Stat-Signature: ii3hqqnnbn3pd3rt8rzwqpuc5fjajppz
X-Rspamd-Server: rspam06
X-HE-Tag: 1786979974-275784
X-HE-Meta: U2FsdGVkX19Qo/C3vVccLZ+wUEGicDm1XAUv3TGBNePTrKtqplgfgCHmxA7gU0nheR0C2JtYoUEV+CAjM4BDwLrOhnNmYlNRnOG59nJmaK14jlr7kbS3Cnk4yk2x+mAXVBOV1Bl3RMP/mYIzglCNogvcH3IYLXnTjx/ebyZNKhN1E5l81nlRNdGVuUXfop90vfrcv+xuyRn6GReIF6+IGVCzhtnwCkZml2uy3Z3dxcwAelitO4v++m85AE8EjQFKfN3WzrEhKLrmNDyonap+jwXEC6NeM5mm14koIgACNr7V2QABksQdZwlWaVLkDcp/RaycKZ5FT3VmrpdPeslSzSs1+PG8F82ADp+0v43sCb1EFRd5ynh4o5c/b5xW/72SExQ+p4yyH9s+KOrZlsCw091lpP54rKDauzXo9e7RsJC7OHjOXPNzabAkUNC3YZjxd3TB/iL4KhTQhk7XxG3WzCFIkvHY22IirmaZWwlHFVBJKu9dgLU9yPnHEoUgY+JsTnUk3OOzCg0+jBYnX/sAwECfC1mr56BHLq0vZC5zHFdKieT51+Yk96p303CRzs5JnVtGS6M59h939bUDAPL8rUSrncH3szEHb1/Bu7kWg+7RJVc8tgmKhHgw6C1Ce1m2fGYpHtLpFg9yIL25BdNhdPEthuIcWBcMIggmpBChQcTyk1BdgVilCPM1LoBQ9OtlanGDvJRchNmtWQ297c96xGjc2RE4F2yVsoaqZHxdil367yqQ54RJpRV+fG0jILK+RTlP/m7I6wN06nDVMIM1FvZNhcspUOu6IDlLURlGr8iTI8PYflxN4nIzjHppDIUAgYGhXqrYpqOztHfUJ8+GkLWysUtS8UE/OL6HGrd20+pE78vq8vxtAz3+BqpHXkgKXukD+IPztqnKG68vgVfE88mVp0hMaCXKXdsT2uAl2EDoORph0Kx2FX641xwhv1tet7hcdlQcf7uw+tN093o
 akC0vd/R
 rKNFBOupFU9t8NbHoMEBDCBlOoGUHak260ARvsnoTqA6Y4+MkFa/XInqRWg/mof8O7mxp+3eoqBlUL0aH9l3urpg8qNsB720i+wDlf5UNczBjh8vzY3g0mEwEykPgu4HWLyJ43GY69HXr4z3WJuM93QLloz6Wqg4IILs+ekBCBRGWAEnDVE+CtvP2Ko/LmzueP9pgopBDcjU5r0PaEVtUZEUCiZP0kQ37I7ZO9nsb1ByxE6rY40bLfidlS1yuMHT/PoyF0NYL+1nKiXdbZyEuuCHi0O/MOUIW7C3OiXYjpzTuQwLyReR728moKjTB1ux0jsQF/YOIQtDGSK1mtHxAXc7ceD7ilUQz+iuqhDKCpU6tE3P8aHt8cCXmPKDLvYdAUqcOkO6QutuzHUQa26FK/6Qe9UF1Ks4j1ppPYhAAj43ZDLwuBMHw7FTm2f8R/jLnM+N2XbFxFyMEelzYPxDf2+MzTCp//fobf4Yz1fgaJZeTQF3D5ACKkpd62MwNM9eBXXZSY4Bg/E32ZGxjWGROU2CkjJ+9iqU7X2/XcUjo8gnTdPcJX+/TqxfdvIPv7yo5g3ynzWaiCPjCzAcJj1FPe7NfWmpUoGkVjKkMB2eSo35/Zalm4up+IMtUf54XJdO4tdpUeP2EwnNVhdE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Aug 2026, at 11:06, Greg Kroah-Hartman wrote:

> On Mon, Aug 17, 2026 at 10:34:26AM -0400, Zi Yan wrote:
>> On 17 Aug 2026, at 9:55, Alan Stern wrote:
>>
>>> On Sun, Aug 16, 2026 at 07:42:13PM -0700, Andrew Morton wrote:
>>>> On Sun, 16 Aug 2026 21:47:58 -0400 "Zi Yan" <ziy@nvidia.com> wrote:
>>>>
>>>>>>
>>>>>>>> I prefer Andrew's first suggestion.  If the user asks the kernel to copy
>>>>>>>> too much data, just fail -- with no warning.
>>>>>>>
>>>>>>> __GFP_WARN gets rid of all other warnings, even if user asks for a
>>>>>>> reasonable size. Why use such a big hammer?
>>>>>>
>>>>>> Because on many systems, WARN causes the kernel to crash.  You don't
>>>>>> want the entire system to crash just because the user asked for more
>>>>>> memory than was available.
>>>>>
>>>>> User asking for more memory that what is available is pretty common and
>>>>> should not trigger a WARN or crash, unless you have panic_on_oom set.
>>>>
>>>> I assume Alan is referring to panic_on_warn.
>>>
>>> Yes.
>>
>> Right. That is why I said “unless you have panic_on_oom set”. So panic_on_warn
>> will not crash the kernel if user asks for more memory than what is available.
>
> Are you sure?  It kicks off syzbot, what prevents the oops from
> happening if panic_on_warn is enabled and a warning like this happens?
> Am I missing some code somewhere?

usb’s inode.c uses kmalloc to allocate > order 10 memory, namely >4MB. This
caused the warning.

kmalloc’s doc says:

kmalloc is the normal method of allocating memory
for objects smaller than page size in the kernel.

Shouldn’t usb inode.c use a proper memory allocation API?

>
>>>> Heaven knows how common panic_on_warn usage is.  Gemini tells me "There
>>>> is no exact global headcount or precise user metric for how many people
>>>> use panic_on_warn.  However, the setting is widely enabled across a few
>>>> billion Android devices and many cloud/server provider host kernels
>>>> where automated failover makes a full reboot preferable to running with
>>>> an unknown warning state".
>>>>
>>>> So I do think that WARNs are more serious than we (mm developers) tend
>>>> to assume.
>>>
>>> I do know that Greg KH has pretty strong feelings about this issue.
>>
>> But the warning here is when kernel user wants buddy allocator to give
>> what it cannot allocate, a page order > MAX_PAGE_ORDER. The warning
>> tells that kernel user please ask for a reasonably sized memory.
>
> And if panic_on_warn is enabled, like it is in billions of Linux
> systems, and a user can trigger it, then you just rebooted the box,
> causing a DoS and a simple way to get a CVE assigned for the problem.
>
>>>> So we just shouldn't permit userspace to trivially trigger a
>>>> page-allocation WARN.  Especially if the caller is perfectly capable of
>>>> handling an ENOMEM allocation failure, as appears to be the case with
>>>> usb-gadget.
>>>>
>>>> (Does usb-gadget actually get used by Android?  Surely not by cloud
>>>> providers!)
>>>>
>>>> (Can this WARN be triggered by unprivileged userspace?  I didn't look,
>>>> this matters a lot).
>>>
>>> I don't think it can.  Regardless, even privileged userspace shouldn't
>>> be able to crash the whole system by doing something that ought to
>>> return a harmless error.
>>
>> The issue here is that the inode.c code passes the user input len without
>> checking to page allocator code. Capping that is a minimal requirement
>> to prevent untrusted userspace input getting into trusted kernel space code
>> easily.
>
> But why would inode.c know what the page allocation max is?  We have put

kmalloc document says:

kmalloc is the normal method of allocating memory
for objects smaller than page size in the kernel.

> arbitrary bounds in other places where you can cause large allocations
> from userspace (like in usbfs), and if that's needed here, great, we can
> do that too.  But don't tie that to the mm core values as those can
> change over time.

But inode.c asks for >4MB memory.


Best Regards,
Yan, Zi

