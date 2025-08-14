Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60E0CA0EE8
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CA5E90015E; Thu, 14 Aug 2025 09:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67A9E900023; Thu, 14 Aug 2025 09:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5697290015E; Thu, 14 Aug 2025 09:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45033900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:04:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C82B140657
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:04:12 +0000 (UTC)
X-FDA: 83775381144.16.E6C56DD
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4C8E91A0003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:04:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BvTHBHdP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 40.107.237.49 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755176649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByG3rd199MAi55+iK54XyCOQjZbM/19E40oHHdQcm84=;
	b=zvszCdCy7gDhkkLoJd3ftvdqEr1+igXj3w1Cpfr2eCJl3PIniWqNpLk0nFRPT6TM57fAf3
	1bbm1S8RLK3qOVzOpe07d4hLOM5FAFDYieSXeprie0RBi/pv8ThlKVrNZGo91CDnp59DJb
	TzyMWoOSn7NGWepzX1QdiV8XeziKWlQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BvTHBHdP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 40.107.237.49 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755176649; a=rsa-sha256;
	cv=pass;
	b=e7Z6s3IIzDPPAZg1bozxxNn+iUmr9l4jqwsExcF6WENGrStRPbU9ux/mLhl++89CRdnBno
	sHxZxxGDUtAqpXD4y9FABZ5tAzHZb+jFJy6ffqrm676UbucEcrFf0t6R7gMEuIn/Y5Dvlf
	ToqqOVU/RQgIcAsbB5tZrwbSym43+pY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bKBN+aT4nP02EGaQXNSTmH4eHXU0EpEwV5raO1jiXEnrBPLpYdj03tyImNJxr3W4rGKV3LQmSs6ZXzdEtUJAz0HJPNKTSgDewUaY9ZHKmJk06Zf2BTO4r7bL+nzGDvw1mXpglXUjss+SX/+HrVuvSJaWnkaI3j+/luZw1HVYj/WUqoIRNsHZarIZYSXCkL1jKwBRMn9Q05f9PAat5lg/suG8szVFbJj16ES3aivl2pHMBYdBj8GiBwWmeUB6/wH2NsW5YMDM8N0D1zbmchsAJrbd4gXMzK0q90a1cqvz0dQI12wDnBlkEoN32umX6MmsKcmV87IX+G7W8SgX/Le7Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByG3rd199MAi55+iK54XyCOQjZbM/19E40oHHdQcm84=;
 b=OADZ9F7IFLx1G+jTD8XXlneBsVR4WRuvkp7YcIx49MmCLAQ4sWOVcBIqxanA2DmuibV/jJCejxPtxmBgTGNfM3akbWR4AUHylViqJSCAt0xZF5QDp6QOYqjyaylbwvUKv3bavWeKKj6BJNImO9OL5y66Lj1/1JWX5jFahmPvbGvhnnmyOJEQI9ME9Yu/8rEW7HIKkP6cz+t80Oor0P69UWNy5dKgVICds6ymePAHQGYJfwgo5Jbnl0V5WtKJ7rNI8U75CUg6c3rM0IiWx3uBn3K+AMF/aC3SyBoyZ3XdWyuYzGFelGQ40ydy/PcI59ETbxpn/6LUbxti/3ewdEep9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ByG3rd199MAi55+iK54XyCOQjZbM/19E40oHHdQcm84=;
 b=BvTHBHdP3usLCQDLMS7LwaKMNg+M1C9bGQ9yNL2IdzOflxrGWUo/B9lyb9oJzVVXijIM2Y1Kp+fDfz4M7OSGLu64Sr69TOP3Idek7Omv4QXKEWiYggzrcp3U3CMh2ah4G2HRdueAkmrMoTc5vGJuF6OUqD4LLpkNwR+9MO5yvPjdtwThYlRmmDIqDJb5EmQizEngjsfcvmcSmqBhvnknT/DKWSZy1AVfLisvU3yNdjU19eJDb4obmiZdgifMyg9MGTtBgEvZwo0sjSFkm1hCBG3p9PtRO+Kbm5U3HNl5hnrJLYbxiA01hRXrAJkRtB2VKhw/Ct52GF3OnqiRiAu5/w==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH0PR12MB8462.namprd12.prod.outlook.com (2603:10b6:610:190::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 13:04:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 13:04:05 +0000
Date: Thu, 14 Aug 2025 10:04:03 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: Re: [RFC PATCH 1/4] mm: use current as mmu notifier's owner
Message-ID: <20250814130403.GF699432@nvidia.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
 <20250814072045.3637192-3-mpenttil@redhat.com>
 <20250814124041.GD699432@nvidia.com>
 <2da9464b-3b3d-46bd-a68f-bfef1226bbf6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2da9464b-3b3d-46bd-a68f-bfef1226bbf6@redhat.com>
X-ClientProxiedBy: YT4P288CA0090.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH0PR12MB8462:EE_
X-MS-Office365-Filtering-Correlation-Id: 8868cb21-0c04-420b-a244-08dddb330c32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U1BOQ1RkLzRYa04reE1WUGNVdUJQelIvdW5VSmRvd0w2REFEZXZ2Y3pmNVhW?=
 =?utf-8?B?N0tBeHFEUFdCYXZwOEI3ZmV6OU9ZQ0FVMTRJNXQyYWE5OWoyUTEvRVdIYTQ0?=
 =?utf-8?B?VWdpZE5BVy9EV0N5UW9yTWZuTjRDNm5idC9PYlhyYTc2eXQvR2tyTkk3dkFs?=
 =?utf-8?B?T0M5cVByZnZiQ0t4cUhkQklmUjZjMk9aeVhFVi9qR2VhNmFZQWhPTFhCNFd0?=
 =?utf-8?B?cW9kdUtnRW44OWk1WnV3cU9SOGhDeTEvOFNuMS9uUDh1YlZaNVF4RnNUZ3JE?=
 =?utf-8?B?a3FJNjl1MTRzOXR5cVBXWW1rWVpveDlhejBvUTI2d1EzaHUwUVFEVStSSi85?=
 =?utf-8?B?MmxId244U2ZlTzdFZkJDRmlQYmQvZDdNNDJOT3FLVUFWT2YvWi9peEpPTzBJ?=
 =?utf-8?B?cHdRMTJZbGl1ZlRwSmdOOWs0TE9PeTY2c04yd2U5ZVA0UFJTR21WdkxXdVZh?=
 =?utf-8?B?ck9rY3dZSExkVklxeXdyUnZnaStDTS8zRWViNUJRZG1mMHdvZTFnbWFhTXJs?=
 =?utf-8?B?UjZXNjhFUVpIdFRuc2hjZ0FHYWF3QjZ2c1pSR0dSTGlHMmUwMG5uUHJLMEhB?=
 =?utf-8?B?b1FNKzdEUGJBZnFHbFVwUVJkTHdNTGNPWnlwaUUydHR0VHkzdHBvRElqZWpH?=
 =?utf-8?B?ekdNdzFZelZlR2F4eEJkSU9INldvVDZKSlliRkMrSDdZNHVoQjZYaU5MeFQ2?=
 =?utf-8?B?RkFYOVpjbVJ1VVpWVW9GeWRLT20xTnE3dUI0eXY4emlMaGVYNmJBZkJqZjFw?=
 =?utf-8?B?SGtxVFIwSTBKL1haUHBGcjBDZ1ZkMTZNK3NUTnNOYmQ1Nkg3a1N0N0FEenBS?=
 =?utf-8?B?YmtKV29qZWJPQ2xDRHA3N3djRHM3cVliRUhUbmZDb3JBeHVkOUwxZ2xoZ0x6?=
 =?utf-8?B?OENuT1JHRGltN3BVaisvaUVBNk85OFUxYzE1TWNSMVk5bzh0NGZtUmZYTUZu?=
 =?utf-8?B?YkhpT293WDlnTkRXWXF3RkdwZVFxZ2kxZVBQbXhvWk0xTnpDdVR3dHJUc2Y3?=
 =?utf-8?B?Z1MwRFlKZGxLQ0JwaGQwSk4yLzkyOE1NM21vRmp5NytzWXlMWVkyNFk3eE1Y?=
 =?utf-8?B?MFFvWEprOFRmcjNkZzMzd3MrS0M3Sm9qK2RMWFVRNkZ2aHJ4K29GeTVQcGdn?=
 =?utf-8?B?ZFgrQ1RLR1JZSnljeVA2VnZDUTUxNnhVYjFPY2VIVVF6Z0lleGdKU3ROVTlG?=
 =?utf-8?B?emVwUDZnckpDMUxza2wzcjZDYlVjTjdKdFFBS3BWalByeXU4OFBpNXNZSVJT?=
 =?utf-8?B?Y3hJZldwK1pNVjFPVVd4UGd3NGgxZGZ4V21hZ09IOFZ2bENZMnU3dGQ2THRC?=
 =?utf-8?B?aldYMG93TVJMOEpTcFRLVFRTTzJVZzVad2lmUHBPWGRqUmVZTno2OGdEaFhS?=
 =?utf-8?B?U3F6RUE5bHRTQnFSRGF2UVcxbEI0NFVpdysvNUQ5UFMzTzhJbGdMMENyQUxs?=
 =?utf-8?B?Z2Z1d3BVc25aK0VhL2JKaVk3d2NHSGF3Um5kNS8vOXZZYVVSUUtxdmNpL3M4?=
 =?utf-8?B?Lys5VzVDc3hFTDBueUpKbGkyS252VmhkNUxERk5GYmxQRElLVUFmcEV6S1hY?=
 =?utf-8?B?dUxGTWx2RTl5T2RkRW1VSWFhZ3FRaDNyZkpNVVNmcU5jWHQ0Z1RpbWhWL1VR?=
 =?utf-8?B?U2RDZHFHUGFZdmhrOC9UV3p2YkUwenJ5MGRudVhBU3kwVDFXazA1TjRIUXJT?=
 =?utf-8?B?dUNVcWNYQStkVUk3TFoxVXVod0VQdm9rVG1EQ2JPc29jTHl4NzRiOUpUYUdD?=
 =?utf-8?B?eTJyQWt5VW9VRmRSSWIySkxxQUg2SllOa0Fud1NLTTBselhoVWEyaXh1NGh0?=
 =?utf-8?B?aU1MUnhNdmRtK0pnaUFUNWRkTXd5UndBakg4R1Fqb0VaNUd0dTNGTGdCbmpM?=
 =?utf-8?B?czBCb3ovNXRPR2JOaWp4OWhZVmNqN2N2YktYMzRyRXRpT2NVc3B1L0dJbVkz?=
 =?utf-8?Q?XNpQdmoVzPw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UGVMMzhoUDFhUHZzeDV0TVB3elp3VUZtYnpGK1hhTWhsUG1tNWV5akJXclgv?=
 =?utf-8?B?aytaWm1aVklsSC9vL2huOHRWNCtETGpoY2tYQ1JiSllnMVpXTlNOOXV0aEtJ?=
 =?utf-8?B?RlgwK09yRDVkQks3Ry95NHIwTzh6NTdhNk1iaXRTVHR2TU5ueGF3NnhDSTV1?=
 =?utf-8?B?TUZ3cVowWjlUcnU3cWN1ZVpnWmVLRDFCcUZQNWs4Q2p1NnZPelduRE02blFh?=
 =?utf-8?B?QXVLdHdpYzNjMHFBRjExdFRJQ1JEK21rNWpmNkxDVysyUWhNMmpud1U4Z3BE?=
 =?utf-8?B?NDI1QXk1VGsxWjBGZjg0ZUhVdlpOZ29FUnpYa2hlMUJXMFRqVzAwUUVuTzE0?=
 =?utf-8?B?M1BYRWhZcWFaRmk5aW1pMXBMckgvUzBBTTYvd2lXcUhOb2gxcXhvZWg5U2ZB?=
 =?utf-8?B?b05ZdkdOS05BTWRWR0lFa0RBRHlPT0hsdUlBR1MwRG1HbFVoVk9XWmJrVVhC?=
 =?utf-8?B?bFRDTkxOZGx4VGhTc3JMRDNGYkJVcEJWVVR6QmYrZCtETjNRQVEvYy9GT2ho?=
 =?utf-8?B?NGdoY1hQa3g0cC9xOTVZc3ZaYzMrRzRFcE96VjArelZaTXpRWEJodWNMbkpp?=
 =?utf-8?B?WllFbkhWZDRUYklJQVlYVFpmdk9MdzVMYkVEcG51aHg0ckw1YVp2cGJnYllx?=
 =?utf-8?B?c3cwZk1LTm9hbkJoY0NVUXJPeVR4SFVnODh5YnpuVE9Yc2J2K0NYTVJreGl0?=
 =?utf-8?B?bVk3MkJGTkpuOXhldEgzVHo0Ty9DeVhOd3JKbkN3cmp4TDdLa0RrbXMrY1Fp?=
 =?utf-8?B?Z0hxenNvSlpVeExNbW1XRVpMOURuUGkvbzVsK1VNNGd2SnYrSm5zNkVBU2lM?=
 =?utf-8?B?NkcxNTRDdjV6SGRwUWdWclFOZnpzaVdBZWJvaGNjVHpzanNTcGlyekx2MFcv?=
 =?utf-8?B?K1VxS1hXY3RYMm11R0ZzbXNNQTVBNDc3WVZ6RHhrNFdVMzlhdDZPTkR1bWRp?=
 =?utf-8?B?WTRQcTluUTlKbUxia3d1V2FQTHNSNUV1ajBubUlialdSMGNiU2padVBQOUcv?=
 =?utf-8?B?eUV1Tlk0Z3B4NVBNaENVdHFNR3BablN1WVFPUjcxRU12MEo4c0ZWNWFBaHIz?=
 =?utf-8?B?aUNmWEtGSzgwTnVKQUJ3Ny9vdUdKa0Z6cTYrWTZKMS9hRmFlNW1JR292aTVv?=
 =?utf-8?B?dnM5SWNBQ0tWdWNuWVgza0x1T3BsdG5aZkMrL1dSYUJER24yYi81NHQwZ2JK?=
 =?utf-8?B?RjBFZHdxSytvUzZnTWVsajA0VnNwUlh0eVRVVy9qNllmVjUwcDhPWjB4cWMv?=
 =?utf-8?B?Z2VrODUrNDZveVZ5cGpya1FYQkZJL2d6Y1pLa1IrWWlVQ0xDMDcrWW9vV2Nk?=
 =?utf-8?B?U2tmNml6c1RRUmwwZ2NENkVrTkQvUkNHRHJtZTZwRkVIVzdwbEFPLzMvbG1n?=
 =?utf-8?B?QnBPenFZZTNTN210bW5WdFFKQWVrbVBRd2ZacEI4Q0hLd0NFTW84b2crRC81?=
 =?utf-8?B?cVpwdnRPeXBzMmJIVFhtZUtXREdqRHRsUDVNeFUrT1lJTEpEQmFITHlubjVV?=
 =?utf-8?B?cTczZmt4WG5VYUs2Yk5PTnAyZ1pvdU5aZnVPNXZST2k3T0x2a1JlWjNLSlBa?=
 =?utf-8?B?WXI3Q1AwUnBCaVY1blF0QWNubjBBc0pOWVB0Yi96ZDlsdmxLci9Yd0l1WXRl?=
 =?utf-8?B?bFZscnBWT1ZxNmIxUDNoUmtvMHJEREdqOGpmclNDaWF0SXM3L2U2SHhmUS9K?=
 =?utf-8?B?OFVkWmJIc3lsNlhvVWRCdC9CSG01eTdjaWdsZlUrSmRaZkd3TWtpQlBlZ3pK?=
 =?utf-8?B?QzhMZG5jcWhRcVFMempudXAwTW5YWUVmaDgyeFNVcHYxVUl2NU5kR0JYSG1Y?=
 =?utf-8?B?SzdyeXhDNUp3VW1IOXUwVk1CQnY1Q0QrV2toZkNUbW1PZ0NMMW12d012c0Rj?=
 =?utf-8?B?N2xXa3BVVWF0Z2pCaDlzMFhpSkNCVm55VFlEN0ttS3oyT0VBSEN0WkhPeHNW?=
 =?utf-8?B?Ly9VMEg1cnpUdnpRdDh6emErK1RseEpYKzlHTjFmbTJKNmp3QkVUSEtUa1Z5?=
 =?utf-8?B?N1Z5OS9NNmhuRitURXE3T0JzT1FpYVVneGZhYjIyWFdzQU5Za0g2ZENJdTYr?=
 =?utf-8?B?WW81aTR3SVhJblM5WlVFNGo0UDRNekpEbm9vcnBjQXloY0ZQbjB2RDQzQVJW?=
 =?utf-8?Q?GdVw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8868cb21-0c04-420b-a244-08dddb330c32
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 13:04:05.2895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R9Kbqh4GtwzWUqXjHctUPFI2O5Xm4+V7fIaLIJjFE6PSbiByHIlVKnMHE5IwAUSz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8462
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4C8E91A0003
X-Stat-Signature: 7b8tbwkcj99cscpoe564e797yo634tmx
X-Rspam-User: 
X-HE-Tag: 1755176649-349216
X-HE-Meta: U2FsdGVkX19CF+XFH0rw4fioXjIU1Vgbn+zqnVxn/zY8H1FoJpoCLnI5S6utcyBAy1vTFtmc90nv9RmPPKBfPJwaT3gcmiDMCjI5VtGduZi7RHAQ/jJT9pbY8l4PrKgBuE8YzXhm3nAIKtQQ6B7C8mGR/7qoQwx5qXUtsKo+tI49lgedwyRFDn/pqsFGCBfr2IHe15L8LoxxlR6wgykd9Etwc4U95AEW7rEC1dXsr+gICc1coGeOkZB0GrLr+s6V3f6czwCsTU0Rua7JYf7wSqpLXawySbO4rmEqsAq5MJj601grWnRdkRABwGANd1ncPWZRRYXkiu3wvF5kEVZpNTpuoac5JgPKJOE5wmVOoYvJrQWSRBdeEFVM3fn442QbCKrbUO0LuOhlwJodJ18i0sqXEHr631LB4nvMa6N3vQzmginiMb611CApQc6MGbelHzcMoPNv1nl7nZr/T+6dZYi79lN4E7RObUpNqkXZj/QqVp51hZXzlquv+na9YcG7VtFJNit9nQfeSJ1N5wTZVdw09blUT/sNdWytqy9Wd50loaRW1mZhn9C/twi9deBBLXedusB032m3bS/1BlXxqR5Y1zzA/TUAKQ7rvkKjlP7h4e9owMdx135Sc7DM8Vgk4V4mCyIZcm+F9JSfOUFaZluiFMb6bpntgUpMi2mTMu9z/S0Q8Q49NSsUmHpR3xz9+RipxcYV9pp+m83+XbTae3yuq64/wXFXlvkermgcaU7aqS825EnV1F9ymFfzNtASdRHoUuBH0GBQJPO8wA5s/eHIf8VysBVvXdoZKgm+nLozlwcttFaTKwOPIoOmYOGVWzzH6vgRouhUeyXLbQ25yAKqCiojY1NG5ou9PALJCdkS/I6orWxLfwMmnbJx/I2fbMzQ2y/4KAwUxBJA/DSGb7eJ5JrNuXwW5m5fnyP1jJju0nvyFA0owCCiXSai6jxL2oYUUevc8cjm1hQBuBc
 2Uu3Xu55
 WPNt7loBEJNMX/SC6nx38ahOIEpu5REQAOqe2NqQeXC95u+JIQTl28t1Mw13w7gnh/ctoB6PkjoEvoCH6/Kh88NfwlbAC93wGX2WribfDEl/cszW3bGo/Iy1I+HFCpIPkubIeinfc3nqxOFEYYBkY5k2xxUrCHMYE53tGFVcleAX8Dzz/GFdJinaJ2zNyd3ddpXZAOgO1GdUsnvNrcq2iagfemglXR+IYSKVlBd/hlsCtqbA2EBDXD8UfWLvZuA7e8I5Mktac7Z1jFSYBCnJoadoipo5TbzI7Y7/sPXizgayLdfqATnnrAgMZZS1bDDcj6t/nGD50oD9dL75Xt3jwRysjj5poTjgtqFyCV0ceEeG8vHCucWlcrM+FRhhQzNTWztdH6KFEBg2W91T44RlzO768/B9ZHyC4VO6sb1YcZ7HqzzYcACmus9SEJ5f5XY4I36IOC6WLLfGj2Z7kTaS05u5HX2pScZ7ityFfxYfdCKLAn5lAyTyoQkXoc9qKIvNFaP1r1kuC2mk1LMb+aIj0wFc1+b/b/W9DK5KwmC35w87yFHr2l2eztQWNwCuSMCqCIm++
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 03:53:00PM +0300, Mika Penttilä wrote:
> 
> On 8/14/25 15:40, Jason Gunthorpe wrote:
> > On Thu, Aug 14, 2025 at 10:19:26AM +0300, Mika Penttilä wrote:
> >> When doing migration in combination with device fault handling,
> >> detect the case in the interval notifier.
> >>
> >> Without that, we would livelock with our own invalidations
> >> while migrating and splitting pages during fault handling.
> >>
> >> Note, pgmap_owner, used in some other code paths as owner for filtering,
> >> is not readily available for split path, so use current for this use case.
> >> Also, current and pgmap_owner, both being pointers to memory, can not be
> >> mis-interpreted to each other.
> >>
> >> Cc: David Hildenbrand <david@redhat.com>
> >> Cc: Jason Gunthorpe <jgg@nvidia.com>
> >> Cc: Leon Romanovsky <leonro@nvidia.com>
> >> Cc: Alistair Popple <apopple@nvidia.com>
> >> Cc: Balbir Singh <balbirs@nvidia.com>
> >>
> >> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> >> ---
> >>  lib/test_hmm.c   | 5 +++++
> >>  mm/huge_memory.c | 6 +++---
> >>  mm/rmap.c        | 4 ++--
> >>  3 files changed, 10 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> >> index 761725bc713c..cd5c139213be 100644
> >> --- a/lib/test_hmm.c
> >> +++ b/lib/test_hmm.c
> >> @@ -269,6 +269,11 @@ static bool dmirror_interval_invalidate(struct mmu_interval_notifier *mni,
> >>  	    range->owner == dmirror->mdevice)
> >>  		return true;
> >>  
> >> +	if (range->event == MMU_NOTIFY_CLEAR &&
> >> +	    range->owner == current) {
> >> +		return true;
> >> +	}
> > I don't understand this, there is nothing in hmm that says only
> > current can call hmm_range_fault, and indeed most applications won't
> > even gurantee that.
> 
> No it's the opposite, if we are ourselves the invalidator, don't care.

I think you've missed the point, you cannot use range->owner in any
way to tell "we are ourselves the invalidator". It is simply not the
meaning of range->owner.

> > So if this plan relies on something like the above in drivers I don't
> > see how it can work.
> >
> > If this is just some hack for tests, try instead to find a solution
> > that more accurately matches what a real driver should do.
> >
> > But this also seems overall troublesome to your goal, if you do a
> > migrate inside hmm_range_fault() it will generate an invalidation call
> > back and that will increment the seqlock and we will loop
> > hmm_range_fault() again which rewalks.
> 
> That's the problem this solves.
> The semantics is "if we are the invalidator don't wait for invalidate end",
> aka don't mmu_interval_set_seq() that would make hang in the next mmu_interval_read_begin(),
> waiting the invalidate to end

I doubt we can skip mmu_interval_set_seq(), doing so can corrupt concurrent
hmm_range_fault in some other thread.

Nor, as I said, can we actually skip the invalidation toward HW
anyhow.

At the very least this commit message fails to explain the new locking
proposal, or justify why it can work.

Jason

