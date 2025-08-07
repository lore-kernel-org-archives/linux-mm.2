Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DECC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 20:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD818E0002; Thu,  7 Aug 2025 16:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384F98E0001; Thu,  7 Aug 2025 16:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D098E0002; Thu,  7 Aug 2025 16:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1052D8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:58:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CD1F826BB
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 20:58:34 +0000 (UTC)
X-FDA: 83751174948.23.BBFF45F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 16E881A0004
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 20:58:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RHP8YpcZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NH+UZiRA;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754600311; a=rsa-sha256;
	cv=pass;
	b=1GDiDpAUDFopFvSzNN7utfjbxgFNJeOrNzfvHVbv7CHDFIE+i2zKWPKsCUl0tPEG77oyv5
	1+IK+pT1ebDnniFM9ivtKG+gUzSZ4oBl3cGGkRmLUbp4ywyEEeUQmC++v1/qWaddrID/L9
	ZW+FnObsXKUQ3CzHpfz0OVyUyPWWrYA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RHP8YpcZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NH+UZiRA;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754600311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pc9maLMoRbIAHU6G+055+bfMebm6QpPWa/pEG4Jc/Ho=;
	b=LnJYOBmJ7RLOwqqTiikm2hkjKj9za0Nwq924CgOZyPUszBGIImXfo0i45QWwMEDAAjY/bH
	Uu5x948PvP91M6o0vGjGLJjD7NevHTvZrwoSmSzbBW68Il3F8TrD1H8LP8yMToVg6t0p9i
	iS60fOJsHiALJV7EWQNaoy12ofiFClg=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577KN8aV010336;
	Thu, 7 Aug 2025 20:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=pc9maLMoRbIAHU6G+0
	55+bfMebm6QpPWa/pEG4Jc/Ho=; b=RHP8YpcZSX8gneVQ45yYdbivs5yq6QrqeS
	fsHnCd/dcmF7Tkj0teC09LlcfyVbM6hBoBlMdKwoheG4QRcP+Er/+bOA/xT0/rEd
	ujTOiW7ucL8MNMBM7xAtN5saRFk08EXokysOMcAcQqv1oAWkq+HK4MF5551GkmLS
	QWPWMTOITvj0Dt2khDQPdSCtU4uG7j2w/wTBk54stI/YbpZQRF0wx2HPbqx/T/Mf
	40GbiGIFyvR6jTsJ7PJuPgDCpe+ywjvjio9poXNwbpVyJscX/DWxdKx5C7U/JuV5
	BP4c5CeHD7MmZvD5UL/3kiY+jS+qNZPZdP+qbqQakrsAQJ+0e6tA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvh510f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 20:58:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577JTSYN028364;
	Thu, 7 Aug 2025 20:58:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwp6h0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 20:58:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=It+BqsJKiiceLegwZN537UQYRr6owH2H9kkRh2q7Eca2oHdI/z/P8vkpbWOPwHk2/uBdusxJyrK9oEyCNKj8gaTBKwngXWacP3VZYNytnA5lDwyibeDPGrCbGwGZm3OxEwEPIwxwrpU2ywcxXzI8kHhx4hOQRCl7fuXwgJpe27jTq7Xq/1AO6LBOkCJZgpoL/0zF3T5JHeIshWrL1EWrci7tB2J9cuRJr6JGEYnaNn7yhqIygjOiNsr5Y/7OFDvRPzm36YEFpC9iKMwg8SiJlQk679avMlxrI2JFfsFLSm+NOuMVb73gEN5VMOkvzhxZecjc+ZWVqKCsee+JnRpxKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pc9maLMoRbIAHU6G+055+bfMebm6QpPWa/pEG4Jc/Ho=;
 b=rwsIXFEJw+u/weupXGEo7Hb2BwN0HomaYBvzT67Q94rh821K+0Dw3S7mWT3rDKZtQut/qiCfVqs/YcsK2LphcAisl4ZHGf/0ffocL01qsA6SMFNxmOxThHlhH7/l7OsgLNWBHxuphS/47TuuELU67LLq/yn3DwyRBJy6Be+3VFfQwaFxZe7wLgSmd8v21516Yyu0XTWd/SohzIubXOOpmYMChEJDJADcDzV9UjzyZ7NrC/ljHSlaDZEu+T0IoYJvnxwcyNqdUPiSxgMo9zcZWGTggLH4gJPBa3xftZ+3THkg5EcSs9wVSCJteec2W5/Q6BoTXgIt4V4sSLtacmYvWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pc9maLMoRbIAHU6G+055+bfMebm6QpPWa/pEG4Jc/Ho=;
 b=NH+UZiRAxvh/pK23zPqQOLqBm6wTLZn19j5uFt14IohK3xDNUA80uLNSlSeen2OsfCQI+PkDIKhj9DRYmwQ/c4RYa+ZSy0Vq7cYXHy6YFY4o4HH6t9qyOfBRw6yOOmm13rnoPyeL1MLyKAb0Vp3oEpxsMtQb9xmjy2KzJljO8QM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN2PR10MB4286.namprd10.prod.outlook.com (2603:10b6:208:1d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Thu, 7 Aug
 2025 20:58:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 20:58:17 +0000
Date: Thu, 7 Aug 2025 21:58:14 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Barry Song <baohua@kernel.org>,
        Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
Message-ID: <ae01c6bc-019a-4263-8083-8ab073e72729@lucifer.local>
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <158e6422-fc82-4d6c-a442-2ebe956a66da@redhat.com>
 <3fc75720-8da7-4f6c-bdce-1e1280b8e28f@lucifer.local>
 <6870e24f-dda6-421c-8df8-58294927b62d@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6870e24f-dda6-421c-8df8-58294927b62d@arm.com>
X-ClientProxiedBy: AS4P191CA0049.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:657::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN2PR10MB4286:EE_
X-MS-Office365-Filtering-Correlation-Id: 7acc2f12-fdc3-457f-bcff-08ddd5f52257
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LYcdwDwLPZFpX08fMorg+tOWIUl81c458CQTg1QUklyTXqOZ71dsvqbH8fWG?=
 =?us-ascii?Q?30ws38t6XErIcpl8pqGAL9y7jnoB7MtZac4M+h59SP94qevAi3hSH2atwalw?=
 =?us-ascii?Q?g9hfdnvjGXgi29up6vtDME4/64UlV5bnOUifLiuhWrJ3kS9uclxdlQJetPcw?=
 =?us-ascii?Q?El/g3uTL9J1IHd7/wAP3NVQuZbaeZKEIrCc4GBKddcr12iKqzynSAt3OkDlT?=
 =?us-ascii?Q?xpAdjvur6DQoRBANEjApWjCmPR9YOpFBi6Wae6rtQdV7Kp3vk8qc0ZyTV8b1?=
 =?us-ascii?Q?r9wp2JDad9VZfJGWuAa9ulbYDLQjA1GYxBpObvRGTy707Ia9UjotNVq9e5YV?=
 =?us-ascii?Q?UMhBItNry9sQvWGbMzIQORl2hUwEBYmKmnzkko4sH1sZJGIEw/YCH+FpHWQf?=
 =?us-ascii?Q?/T+05Y8bzQRCFeRu67M0HnrENJtx5uWQuzZ1rZYA+8zym/M2pWG32xFHzvfD?=
 =?us-ascii?Q?ez3MjfSNnGhihV/HW30S/2oUZ8fDJ8+MwZC73LWVpbGYI/pYPCLtK7koGGle?=
 =?us-ascii?Q?xgLlms92AbSJNzgSnfS+T0iQtCX1pMp9yGfq/zlbRsX+spq06+Pr6OKsCAFb?=
 =?us-ascii?Q?ma0QOozwZburvWfe3zhxQJ/ZahTMVgaAFrQA8WB0b0QIE7ZenSebygckYZGN?=
 =?us-ascii?Q?xXy4nARTlflYR1Rj5jYyNL4sNhK30609PChH2SW4wy5y1Va22kcIk4a/cWNC?=
 =?us-ascii?Q?bZMbjFDs7VxOhEvCVyusqLNQzs5x6EaLkPw78RD15cHkJ0hthI+6Rbi0/Rw7?=
 =?us-ascii?Q?Ma4x3l6hxiS/oiFBxuEAV+KfxeGeragGJXMIx6R2qbayhDTuqoOb/vRrtOCr?=
 =?us-ascii?Q?QGtR6Jxf14XiWB3WyIBc0wPN7I1eyCEfkuRnadd7QM2aB+ELT7hWXLKYX5F6?=
 =?us-ascii?Q?MqBTtKeLl7UPDuD54fJ97wwZvLtdPfbC9UYuraf5YWtZxndvZV4Q+FWGcRqS?=
 =?us-ascii?Q?agWEjpyPwQlTIfBOTVrnh/cXJGT7QRluEP8lgv9pW7c4JS9oDHo+kswIL3WP?=
 =?us-ascii?Q?YE3J0s8RKqpibv0A9RPUaxTCzgt5P1ND0hN0eFTk86kphdxVLhvh90T0Q+xS?=
 =?us-ascii?Q?QhDauUOmnoBJcWpq/sfWnXZzf1KV1EPE8wr1boArSdMrkgZd4b/+ynEwciKr?=
 =?us-ascii?Q?caobNLnNvJin+nGci4/JEm1aVQi6L+FJ/wV1ANhRUMdEIhIHRxN5wn26RiEL?=
 =?us-ascii?Q?wKXnbmzLQNXvuqpI1catemenMMykL8/7zRu7oK5AS8VOcKJc58WTqnur6AXI?=
 =?us-ascii?Q?Wyns/LiT011cTpFo1ck3+A1UDnVJrNxE62aneQRwR+wbKTHeZun/W6jaMXbZ?=
 =?us-ascii?Q?kpbDbR4OPNUJ6TR8gwczx8S5DER88SCJIKHLG1o6lMnDPEsjn8CbN0nyXMNL?=
 =?us-ascii?Q?IV6yC1Et25nCxhrMqIIOW/9ISXzDwshRrxs6+fSPnfzE28szDfFf3BqtE5Nv?=
 =?us-ascii?Q?8di7yhYu+ws=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aX4lmBlDZzbqx1PfU5xw9e6BeJuY34bATFDQ4OuM4ikZBJAUxc3eusGFoHMn?=
 =?us-ascii?Q?tOOqRO37QGUt45RfztslE920MjXjvZzIkKWbZlKDK6Mzmez2nHcyFqtn4rKv?=
 =?us-ascii?Q?Kc00y5DTKdzMBkYSJ3oeoHuyMINbZpWnXIvS2U9fLJ2RD+JsQdDI5pqJeSuy?=
 =?us-ascii?Q?kFMpjgBxRttQiX+B/2pz6+hkNnEnXLJD7Zlxb25jRx0qcbM48OzdPx3b/j53?=
 =?us-ascii?Q?MhDnV6V/7nTG5dnUP6OrRE/gvj1l67E/3eNiPFrIM3LojEnrR9HpDO6zq7Wk?=
 =?us-ascii?Q?H/cxVRibSbm5RU1mAjWcPd5uZNCzlu7BKWEAF7YRjobqSF11PV6g/3naKT4F?=
 =?us-ascii?Q?fOIhgR+sICJ9mcEb6+TqRsLAzf+8K+GbOxZrPE1PTixQWVR/xUiTbc3ACcIA?=
 =?us-ascii?Q?Eds6qENwGeBFUXtkmATgRL2MKvDXS3gJnNwLhT70thrsD+EK0JHAhkERojaJ?=
 =?us-ascii?Q?+ynvO3Q8mKo1szZ0jOgtmA5WpR4Dv+ztpLwrJkh9NHN6v82kIy37atiibHkz?=
 =?us-ascii?Q?Hpd2Z/kxfbZQAsjRCmkynGqLey6+h6nblZVKp/8UVmeaH0tcew1zHm3eYscg?=
 =?us-ascii?Q?D9p6tEJP/869PmmE7uwu5xD14fvrJttyeMTwtN7uvggBJE8SGTkr05P68zr1?=
 =?us-ascii?Q?MOCL48Fx/KZ1j0MZIwUf7AvhRZi4w7I548rrBYUCdF4qnP8ogOKx8eMXlgM5?=
 =?us-ascii?Q?qQc4Ek5U3/yK7w4+eQ8b2A/j3G6KHktOR6NOkRC9JMVwZf7jCA3AQuDHgCde?=
 =?us-ascii?Q?QHC80zF3pNhQ2KIuj3ZAkb/vr41bAcgF1qJ560zy4PQ1sVPAdPsz6jh7OpXG?=
 =?us-ascii?Q?cmqIS80o/emIyNN4/jNOnZfqlaGs2jbHGpY7q6UB+I+aaIrt/Ip9x1Ra3J2W?=
 =?us-ascii?Q?SCsV6cv26OCMpTfG7Fuymqp97pSHJz/20KkK2xg4g+KpAvEUbZErkl1fzXFD?=
 =?us-ascii?Q?rzH+A0Hbip78FVrrrpgVkLmY5X8xAn+QXDPgfJZeJWVqAVoUAdbOX/Uv7FJv?=
 =?us-ascii?Q?WolI01wFzsB1puV6oHYezkPv1/EpCfjdcrJy/HSBwMEPfHR+WOD2gViaew6q?=
 =?us-ascii?Q?0voiIm3HGZDuB6QKkLQ/JwVqNgb8KD4yNIk9YT8JEw3mUejT8IPOSOZs2ueQ?=
 =?us-ascii?Q?k4z8qoBLXf0bN/MokEEDsK/b6Ff5mPNlVjy/CvzjKwFdXzmL5yMkb9zcAvtx?=
 =?us-ascii?Q?SlGUlSmqKCrY723Dr3daWh3WdZYtbiDPhPkwLPoz4jQKajQAOJwoSmm77Sj5?=
 =?us-ascii?Q?aH0wg3GyNw8mXuHVSqfqPHaCH6clo0tO4wGeCeWO/0zzN2RW79bY8vKbcV6e?=
 =?us-ascii?Q?GdDd2L0et6M90ra9c8hfqgtR+0/fhQ83oB39mEwnoSL0dykujW20s2Nb6TRZ?=
 =?us-ascii?Q?s8e3wxofHn7Lbxa/dsq6J/CUW9aXNaL7Cs9U6Uk8jARFnQpMr3syoPlRqAsZ?=
 =?us-ascii?Q?nF7VpmokFkR+plZiCw1ymuuh8o/U/r3TTAlch+DGHFqPrE9GPyfTuQV2Ujxu?=
 =?us-ascii?Q?czNgmz4twMx7elMWU/p77yrOqCnXRVJ+DdWEsM3neMq9zCyw4hnBFuRZtSdV?=
 =?us-ascii?Q?HixLFrkRS9D6CriPrCeaXv7kKkdabJyJw6A7HEW4qnikyy/bVHO22P0P1Qfd?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cHN3YHcVgDO6Ldz9CX4h9Ipwe5lOK4i1+Phwx5Ky1UbnJkHHJLvJsVopmyx7NEUI9o/qqBDdyMRy94RdzHjGGCjOAYBg0W4B56Ye9lCnTDGhsqlCSjznGz94E0tSOz3XCDGOGLZXwHi14R1Q+nqRlAnPL2u0WWnrWBbhHAJHKPzmtc77ykdrb+XG/uh8j/fZYBcZKrghuevIRkTZXacB71idT/pBBybgn1fa7xx6ICQ2qWlcwgE3xKdbX1woOZ3EuaxoVtVQ6f2HDPvJmHwYjd1m5KkPFGooBWN6KVLv+heFJ2yiFnR9xF85HXs2sYfa0Oh0W+vH396qST8kwlA0xogoCXzCrZyqRdTJk5PyBP9XLwODH73FIhXoFloaHFgfJvEdeNL+N/t79xhkImyqJAPbvxrh/jHoyE0ANJUdEylx09nUVurF+HSkXbhp1s4RZtjgrQgM0jeLdadHLE+542nXHEyYG4FFh1i4Auax9NTEilF3Pp4J8LglTpppx2on57lxQg00PiyqOwzy3/uAlT4qBd+9wC3ZMkHrdZ8L8X88ETvjWnECJvAGWW/lOeTI3D/wFY7H3TkfJDNr6qSJ/Ns+8yimcY3rslryJnL3RKA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7acc2f12-fdc3-457f-bcff-08ddd5f52257
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 20:58:17.8097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1gegnIGBjNS3fTni+mYahQoc/CQBGZI1MIAyXuGFXRqTjmXCyT6eW/8+ZNC+lZUq6jG3FB2OzWpYzcIxK6lPqQFMd+dLTxkc06nTB4pe5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508070172
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDE3MiBTYWx0ZWRfX15p81VqC5gxI
 4govjaLFJuL1WPy4jab4n1oGpcErdINlGZ2R/H625ROmwuL1zLoEKyxKhqSPwXbpjzlkGTg8dF8
 wZxpJ66wyXHv5FGGmaYQfiAn5NFH3cTv+0IFniUxHy2HSplGVNNsKlB18yxIGCpDMQ6vpyZ8q7P
 9hHrRjfpV6f0lW17uRkH3A8g3J6fs9chzdpkSA2wVH35N8Cm8YBkCc9o9t7r/Q8ZulWIouq3F8b
 eVDQ9gSzsUlJ88oHDaSdhivTumuJksVEqq/3+Bunna3IFlM7wI4Eaf2KCTGOBJyFUWxumOvqFHp
 DRXTnT+av8E92teV1SMmYDAsKj3BFVbCcAB5IGVINg3iCoR7OieFEIsEUn1cM5rnBGsU0EqeHMs
 dJQdx5qO8BqSS0mfH9ka87S246WN1jRKzy3P/wbODVCrerFQh4jTGoONzmVP5+8p81pwCwmG
X-Proofpoint-ORIG-GUID: E2lzXTAQo3DqlU2DAq3UjI909IEfPXkV
X-Proofpoint-GUID: E2lzXTAQo3DqlU2DAq3UjI909IEfPXkV
X-Authority-Analysis: v=2.4 cv=Hpl2G1TS c=1 sm=1 tr=0 ts=6895136d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=q3tbDd7vbPbfCbQ1mvQA:9
 a=CjuIK1q_8ugA:10
X-Stat-Signature: noriozmug75q7eqa1jqq7pbnn9urku7z
X-Rspam-User: 
X-Rspamd-Queue-Id: 16E881A0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754600310-722444
X-HE-Meta: U2FsdGVkX1++aABEbriSsRaCb2zjSr4A+lR9YG9dX6owvwYSEU1iHFk3148yrhlfZX4ROekeY+a6eURNSJ1tZhw2mdUunORcnerNSiAbDtf0qzYdwdGd1cOHvI9bnNpNCCaRlIqGaHzc5Wo/CQy2JAcIEG/70Q6wUYFP1izb6W/0jFgXUVCJUhCOdosCI71mumfSaCmbWdwIZr7SpfmJeSNS5amMwo0AKWob/ri8yJLa8pVwBdTwmQAvKRsbSbeqEB7nNADFjnR7d2+352YjMTHzlRo5wSs1q2xfI4LUpI8f307IW/bclkBrZ6ThGI/WVPhuyndqrS22a4/+bRx7vAwkEhEalmIqzqgxRd6um+Yi7nxkdqS+Xd8H4pL93LzWuoba6z31ckKbLO5r1xp5grvJUMrcGH50zc5BLgMlTJeEbXkk+BMxP40xbgUVyJ9ySX0dKvhdC7YGySUPglc6tbnuGioay+TZcqDYZC7nEWxYRRXPLNh13/cjKe5/C1xQp3btMm2FAbJ7grlBRw9kFrmew1uD9de1JXx9o+tPZUyiv86qCOV1hqSYv7MrV4WjR7dfcnwQ9i0HoKqnIdAoiMncv4G4tdhgX2poe1XAOfof/3THNecPLe1VZP9RI6qmhFVYWLN9hHBidZYEIdfIY4C5V7aD5YIHsPdn0U9VFBMNe1TDDJVS3ouOnsmEZiIX4gtjqgIaVvaKD6tlqduKTj4bSRVJXHcgV8+IwR20xPcFJm6Uw+doTDwtZY5XYOo137GJ6iE+xZxIX5KSviwZVK+01mu1l4KpYtiQ9gmOY0QcmG37j7ZoY4n+6b7W/b4Y7pvdCQqSzIWZwTJ6W5HJR/uLec6lR6FP3Lv96QxkqEdKXotgRY/pQX0DlxUHYYRgBgQJN7txATwSh8mpUUtNis96k1FEgQ7upkaSv55SDmckIVEq7atB1EnOTXT+TiFgJsZfQGsQf+Az7zSRPg5
 m5g44ORP
 +O67STwpl5RNo3QKijw3S5R6mu2jr1KODFOl5/iQzNr9dsSOO9UlSkr1H16x2eSGOalxoE7X1/pivWcPFBjmP/fw1//Pv9t+pTHQPFzfbeWFqEUcv9nERteKnSoFVyDwGXi0Gxl6atS7GUpL6MCCI96AZCxwGiJw0oaPyi1NEr9IKhzzkSvmbw81MSXfkdTgpl7CvQjRQejoEkIEmi9jRO1ZQiTHjkdezEYAHo4hjq0ysSFnd7UDYhre3zR8Ckinfr1bEFa34naInw6OX1BaczX/isjnRdAQc9ir5J7pXvIAnfpbDHuldiSuROTnVhqmA56sWB25MW4IgsJIIrGgwRIu4A1XWeQiBrvqvXOH8A1EwZxk1LvUkvsdd0Nk4t/fsqDEywC4VFLc/ozyOJIgE0ALwLAMNZHJiKdjMP741iED4rL9LAIcKulUaDML7b7z3UAMZiQDyf1MI84CqY3nY+283bhRyeHWxYMxtREk7U9juWw9j7fxDnfzlRgIisPLoCoAmt+ScZKc4nRmat57Vo2GmpFutoYEQmwpShnVrkKIoTjlXP2kcQH3C3IJdjUKb7Qk/zCdQDGlw50VEmgBVABeWBjlSIRvMIFmbZ3/zjkuLtQvSEfNOudVfBR1FCB0dyMWaoG8iPCTrGEMhtkDhmMF8fp5Mf/G7QHgSpb5dWudpC5IQhG6og7c7wI6s57edwDEM+ncphRPlrRhbNjEAkn3EhpJCxDyWNhg6iHSkLhB3kng=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 08:56:44PM +0100, Ryan Roberts wrote:
> On 07/08/2025 20:20, Lorenzo Stoakes wrote:
> > +cc Ryan for ContPTE stuff.
>
> Appologies, I was aware of the other thread and on-going issues but haven't had
> the bandwidth to follow too closely.
>
> >
> > On Thu, Aug 07, 2025 at 09:10:52PM +0200, David Hildenbrand wrote:
> >> Acked-by: David Hildenbrand <david@redhat.com>
> >
> > Thanks!
> >
> >>
> >> Wondering whether we could then just use the patch hint instead of going via
> >> the folio.
> >>
> >> IOW,
> >>
> >> return pte_batch_hint(ptep, pte);
> >
> > Wouldn't that break the A/D stuff? Also this doesn't mean that the PTE won't
> > have some conflicting flags potentially. The check is empirical:
> >
> > static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
> > {
> > 	if (!pte_valid_cont(pte))
> > 		return 1;
> >
> > 	return CONT_PTES - (((unsigned long)ptep >> 3) & (CONT_PTES - 1));
> > }
> >
> > So it's 'the most number of PTEs that _might_ coalesce'.
>
> No that's not correct; It's "at least this number of ptes _do_ coalesce".
> folio_pte_batch() may end up returning a larger batch, but never smaller.

Yup David explained.

I suggest you rename this from 'hint', because that's not what hint means
:) unless I'm really misunderstanding what this word means (it's 10pm and I
started work at 6am so it's currently rather possible).

I understand the con PTE bit is a 'hint' but as I recall you saying at
LSF/MM 'modern CPUs take the hint'. Which presumably is where this comes
from, but that's kinda deceptive.

Anyway the reason I was emphatic here is on the basis that I believe I had
this explained to met his way, which obviously I or whoever it was (don't
recall) must have misunderstood. Or perhaps I hallucinated it... :)

I see that folio_pte_batch() can get _more_, is this on the basis of there
being adjacent, physically contiguous contPTE entries that can also be
batched up?

>
> This function is looking to see if ptep is inside a conpte mapping, and if it
> is, it's returning the number of ptes to the end of the contpte mapping (which
> is of 64K size and alignment on 4K kernels). A contpte mapping will only exist
> if the physical memory is appropriately aligned/sized and all belongs to a
> single folio.
>
> >
> > (note that a bit grossly we'll call it _again_ in folio_pte_batch_flags()).
> >
> > I suppose we could not even bother with checking if same folio and _just_ check
> > if PTEs have consecutive PFNs, which is not very likely if different folio
> > but... could that break something?
>
> Yes something could break; the batch must *all* belong to the same folio.
> Functions like set_ptes() require that in their documentation, and arm64 depends
> upon it in order not to screw up the access/dirty bits.

Turning this around - is a cont pte range guaranteed to belong to only one
folio?

If so then we can just limit the range to one batched block for the sake of
mremap that perhaps doesn't necessarily hugely benefit from further
batching anyway?

Let's take the time to check performance on arm64 hardware.

Are we able to check to see how things behave if we have small folios only
in the tested range on arm64

>
> >
> > It seems the 'magic' is in set_ptes() on arm64 where it'll know to do the 'right
> > thing' for a contPTE batch (I may be missing something - please correct me if so
> > Dev/Ryan).
>
> It will all do the right thing functionally no matter how you call it. But if
> you can set_ptes() (and friends) on full contpte mappings, things are more
> efficient.

Yup this is what I was... hinting at ;)

>
> >
> > So actually do we even really care that much about folio?
>
> From arm64's perspective, we're happy enough with batches the size of
> pte_batch_hint(). folio_pte_batch() is a bonus, but certainly not a deal-breaker
> for this location.

OK, so I think we should definitely refactor this.

David pointed out off-list we are duplicating the a/d handing _anyway_ in
get_and_clear_ptes(). So that bit is just wasted effort, so there's really
no need to do much that.

>
> For the record, I'm pretty sure I was the person pushing for protecting
> vm_normal_folio() with pte_batch_hint() right at the start of this process :)

I think you didn't give your hint clearly enough ;)

>
> Thanks,
> Ryan
>
> >
> >>
> >>
> >> Not sure if that was discussed at some point before we went into the
> >> direction of using folios. But there really doesn't seem to be anything
> >> gained for other architectures here (as raised by Jann).
> >
> > Yup... I wonder about the other instances of this... ruh roh.
>
> IIRC prior to Dev's mprotect and mremap optimizations, I believe all sites
> already needed the folio. I haven't actually looked at how mprotect ended up,
> but maybe worth checking to see if it should protect with pte_batch_hint() too.

mprotect didn't? I mean let's check.

We definitely need to be careful about other arches.

>
> Thanks,
> Ryan

Cheers, Lorenzo

