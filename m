Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F6E5CA1007
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 04:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323D06B0006; Wed,  3 Sep 2025 00:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB096B000C; Wed,  3 Sep 2025 00:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19B456B000D; Wed,  3 Sep 2025 00:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 055D96B0006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 00:08:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9EAE0858EB
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:08:44 +0000 (UTC)
X-FDA: 83846607768.07.814D979
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 26541140005
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:08:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OSp7XEM1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="gdFQL/44";
	spf=pass (imf26.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756872521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdN1ndzotNSa0cD8K5VaWRYxVkjBM8zmDwKUNrNDBL8=;
	b=Fxyc2Zmn4TDkrGojhZy7z7cjtlkQ+UQh15TBYnZJ6lmKBy+UkfMGIO9VVm0I3iEPiCHtO+
	JQlxC0DwY7Espqdt8uooI4BEGsfLAPafZCfpWEhF9nGHrQMgnLnbXptUJWX7QGkH2rR2Zf
	YjRVOJoK1ui0I6txWhLvBMjx1OVjyUQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OSp7XEM1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="gdFQL/44";
	spf=pass (imf26.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756872521; a=rsa-sha256;
	cv=pass;
	b=0j/AAOrllZzE0S1z/AiECUGJ/vR5GS1CgXpxTdOtyCS14hzMVNaT6uOd2yiWq4LTcujVJa
	RnD9syngHn7Hj/ToZ9SIUcrGuzrJ8MmTqfbX14250whDJyLXEeZm0RurP+oABc+9dKrJCe
	rl231rR/CcYxETEKJ1Z5j3rFovxlppw=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 582MNL1H000567;
	Wed, 3 Sep 2025 04:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SdN1ndzotNSa0cD8K5
	VaWRYxVkjBM8zmDwKUNrNDBL8=; b=OSp7XEM1Rpx1UcvlPJ8JMb2G1XqPLQV9hb
	lS/tiPpTCp/j7oECDpsl+vYtN0e+vlymJRRcd2p/H0jLBPHRwzT7bLaqDC6PnMXx
	yUiC/5CwNbgwpG7m9BJYcJPwkNAqjMxcFvziggQrifzkNhDwNlB1q1ZpSsOIvTUA
	pVW9SlSDk5YsN3IHete1PwzZILQfmfLo9BtryKkCG941NtJFu1BG0+UOFkfJnf19
	ypv8Ljc/+C3YcNS2E69MPbs1iz9RvsIAtFnjlvJPHiFQweH520NqKPtgGoCcR7PQ
	A0B89ag6k6PSVp2yTHGP9dKKCk4S5Pn0UsB8tdd0wSFU3mj9+bCg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48v8p4muke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 04:08:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5833Sr3Y030940;
	Wed, 3 Sep 2025 04:08:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2081.outbound.protection.outlook.com [40.107.236.81])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr9xh40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 04:08:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RjWPz7FE/ZjqliCCyjUSaSYSIhDSXjIs57GNIabQAYU+1ez86hXcizjdpTGQJs6UWWDgqvzruECvlTGNmpiTiMCVCK3npwJn9jTvCz7g+H4n1NCmblqZm6kvPP5uLOwBl5aMdch/HO/Z31YtXTz84A2HzNJe/qOSuJ8RgDdNM7JrgOVaNATN1sNef2XPml3YXyRm/dzXuyTM9ILDgvx04Ls/T/R2GT9smoeOLr7JKbZeR8KNvJbKmqubBQM5YIZs6S5ShqLC47BXZ3m/NdpaQ1NG8ugGqg+sgdWGWg566vkFR+JABn9p7BZd+8NL233AyW6oVF6BG5vBd3U3yThVTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SdN1ndzotNSa0cD8K5VaWRYxVkjBM8zmDwKUNrNDBL8=;
 b=eUMjg4HKTOLjyVuD1gh+CmF8FNzWDtI83GqPFvIDpFa6Ta7S6IfBC8u4v1bfNqCvOO/OZwMqBAlf6zyo+MLX1QR3tKUN7mZ78G/LHWSQCJH2ut5HtVx+OoGvDIkbmow/PLvn0CWGE6ydM2DClO1nvnycRWDIhPYUYNbJqigROPWogZk94b/3tK9XQoBOhur67UDGs45dFXdekXhWQIHWWxKhtasMTzSCEWo+NXP/Oftgl1PZDcR2zF286c6Q3kEwXg1f0ewc6TSE2cfk3iSVPPFs9TmApFTg6jkfRx6GrUVxhgbqrVnqxImuf7DHKGM5MtvrD2zSuFFD+xqjyQkcew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdN1ndzotNSa0cD8K5VaWRYxVkjBM8zmDwKUNrNDBL8=;
 b=gdFQL/443RHNzvEP9eiToFwHIKCeSI6y/1wMNuZqNZEUa+ICdB77ZaaoA6naQd+bc6qo6bAuJTiSblbBppKCl3PBd5TY7XsRGUWAGSbWTSSmptIRbHah9tS96FWTlvukwm0QQ4ABVqtSQuhBO/E1ctK2a73BTEGjT2sYhxGN2mU=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ0PR10MB4511.namprd10.prod.outlook.com (2603:10b6:a03:2de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 04:08:06 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Wed, 3 Sep 2025
 04:08:06 +0000
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
 <20250902080816.3715913-12-ankur.a.arora@oracle.com>
 <643f5482-cd34-4534-8cd8-69f32482bc27@redhat.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v6 11/15] mm: define clear_pages(), clear_user_pages()
In-reply-to: <643f5482-cd34-4534-8cd8-69f32482bc27@redhat.com>
Date: Tue, 02 Sep 2025 21:08:03 -0700
Message-ID: <87frd4p49o.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:303:8f::31) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ0PR10MB4511:EE_
X-MS-Office365-Filtering-Correlation-Id: 241ff2ec-236f-413c-4dea-08ddea9f7b32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?omL3Xy6auyvDzF5+easq+5rCRfC49JsMhr9ea3gLQQdXHdoOv3V0q4MrZaHK?=
 =?us-ascii?Q?ZVa+exZrf2+pIiQkR+MSAyC+DwrntiMW3p/07KMkdAvpgW54vx/Qx8grUher?=
 =?us-ascii?Q?zMY9YKqCR2r9b/G2eLgpEYAb7P5Es4Vwt4jAMnn0bAqhjfkMPl3j2ydRfcO4?=
 =?us-ascii?Q?ZuVlqa7OtuwmYVFYarItEwSaJCPydZR8aLZmhwZqmeSFLPcNVx4vEuhdtJoC?=
 =?us-ascii?Q?NX/Kt7Vlo7rCTPHK8lFfjzRv3DWUdqCZhUyVPSBNCM+nz0IxFrvLeAqCHHRd?=
 =?us-ascii?Q?cr2PBEI+c+1Tb23SvVlX+r8HvIFK1cDFNOMxwsjhrIm5cZ4NgPEnyvqoSf6y?=
 =?us-ascii?Q?S3y2K0Y5UddvjZqq5j4tZy6LLtRD3vxxgCAhgJEI3V2ql50cqQk0g5It2lT1?=
 =?us-ascii?Q?d8bvqIX97dJQi7FH/9uWEPR8TYNY0TBwo14Hdpd8D/jX1Z0/Ck4xYL1LWSMf?=
 =?us-ascii?Q?myi3i8AlVg4j9hFYZAxooilhHCLgdjq48T6ih21LHKoS6zwppGcjojBd1nBn?=
 =?us-ascii?Q?m9lDd7gsb4fvIeYhMIoB9XsLw8fn4BLJHSAKOgheebItZrDu+2+ntAkI5rqj?=
 =?us-ascii?Q?b4LYXHBBOz2zTUih1C2K0Oe5zy7/VG4sQp9Y6Jz3I5+g8jPQzSJad5fSWl8u?=
 =?us-ascii?Q?uwYgJ4ORLmWh91FIR0fM9NSH1Wa6bTApAm6BSoLO8myCimqzcr+oYiqzwwua?=
 =?us-ascii?Q?0SLFDtohRlIoxpKVmsVghYPH12Xk6kkGAMzONAw8RTpsPusUIFjfX/kb0jCr?=
 =?us-ascii?Q?+0JwOTZKQRUtez94uq35XCAZ2UGdfZLhyHGDT8w6nZBswnJEqgsMFExQtVVJ?=
 =?us-ascii?Q?DY/myCz6Gj6OpBMHs06Uf+TyAh4w8jnyn16xCuPDBwNCxcaLGJOTCxvsKg3c?=
 =?us-ascii?Q?lX4eoSK3UVVnWJv+E72THOVco2P7qySGQAkWsfVhNcplMfzH17AMUiYvUKk5?=
 =?us-ascii?Q?Yr3KTXKvBmYjWmyod0t0mnjQBPy+WUR1yGsC9w2XSc/YHjJTstcDrG4mla34?=
 =?us-ascii?Q?CkUBEIErB6K2T1bGW84UFgu1w99mu/vVpAAj6dbPzlyUz7NorefjPVoO1wcu?=
 =?us-ascii?Q?+Ji+HXsSd5Dxt3+nPuUMjSfNbhUa2rEFJBzMx00urnCGJqyAEb7jrP0MO1N3?=
 =?us-ascii?Q?5pR48PQ8z+FUYgNX3PeCWF4sF3jv5J79dav1hqzbey9BBTRTpzif9MX1qGB9?=
 =?us-ascii?Q?c7kGB2hGjFjlIcAe7TRUs3LlVzf8Hani3403nWue2XNwLQkq7bJUKyBySHoS?=
 =?us-ascii?Q?ogIVFW5ZRM/5rS0tCt5ny3KL2eAPyBLoLUEY7fd4Vvl1HeIJs7ABWVO/MHTH?=
 =?us-ascii?Q?L6zMGQ6PFMhpcUl/c6ET1ZqUzRBD6DhX+N0ZhiJlJZ20f65IgCv8g7wFIRji?=
 =?us-ascii?Q?b3SiVb3I+Y2+UaxK5ywjhGDq7+YNv67E13fG7TFPIyZgoq+8gg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wG9khyR9DNNqfkV205IHesJzrj8MRNYqozH1RRWRK/EH9MqESzbJFHg5NJXa?=
 =?us-ascii?Q?aSlSLg67rVMZ2VAG9iBIlOM8JWyW2JKJeHMuXsZlt/kwBdUHBJTSPBuFlN/N?=
 =?us-ascii?Q?sGG6U2Oo9yT7jYicT+/U0E/5CsdPjrByJsCQVoE2pOzanh8GD+RLu3AP1b0n?=
 =?us-ascii?Q?Yt7NCH6vf5pohlv3WGakG2xxvzgTaSsAwUaaM+560wZFW1qI0SrYX2T6dDDi?=
 =?us-ascii?Q?stj2EMDq3mbPeYAERr9AHw0Q6QNWPCGra2XpbMzxLvX6dB29JgA6Re5MWjf6?=
 =?us-ascii?Q?buTFINEPrjS6sQjsvNxNNbmr4P7N8jcDbMcZ7QsaWKm56raZjxStFRZycWoq?=
 =?us-ascii?Q?fyRNbC+vvDMnoYcHbjhi0UXnn0gwZbsabV56pz4VuW64CLXO6VTJzL/iLRI2?=
 =?us-ascii?Q?Wa6GDWmN0ODQhJhpV7lb0Kc4kQFmOYuByNwCYqSC1hpfwmAO8oC0Mkjln/V9?=
 =?us-ascii?Q?3UhovgyvAvEsPUT+F8fE7u6b7E0MJygMHD1aLuXAVX7yxVbmr26j3Q0sc6fl?=
 =?us-ascii?Q?tnDWt/n7h4jis5kISML4DumUiJDMiT8f2qq9a6/3teIqBKLqSX09bEBqoXc2?=
 =?us-ascii?Q?FJ9bxE78e8MwQkYrHf+gRoKs5H77ywCjy7dHOTzaw5A8I358VK65kcZfgU15?=
 =?us-ascii?Q?qGuH+SogG+zN4kP7zJ00rbS1cCxwiVc2Zn+wCKGqkX/ui9zN+rjgrklm5yCV?=
 =?us-ascii?Q?WLsAOVPfgzzZx5ouFYTMgA0Jnh6ghsaz6IWNiGRiATRH4GdZlSAJYkixrQy2?=
 =?us-ascii?Q?fX/T22oFW4ootxwtEuywp1tUdxqIihVlW+KzgJ0qLyorok5+2zwjWxNEXCnH?=
 =?us-ascii?Q?O/sdTnbeBDsIGoQdiwcjYL7/6fMaYyaWKJ2KZ4go8W8gG6x9we6snUBg5IJp?=
 =?us-ascii?Q?ofEE7bbCA2RtrEnz8d1cDD/SEBBSH3Sh/13jKNeab4fEkloLw5j2jPdkHNFU?=
 =?us-ascii?Q?HMBw92eszPrDvrbFOkXE7zQz4ZpEn7m/Wx4Hgp0dOBm3trZrI9CX4rHEFGwb?=
 =?us-ascii?Q?ikEZWnV2s1d/XVelVpPIZC38B+vc5c83oYm8kSJYRsjbyijGuJHJNUHWwC1J?=
 =?us-ascii?Q?D0p2mdjX0tDrpGrcVU063uxQ634LVjhahls5kBPBQxWExBGDY/i6CogZB89P?=
 =?us-ascii?Q?MW/WL+dl3XV9dCWXE+UmC4N6rwwSjb5dCGJ8zoHEgIdIxoNNFjkeI/H7aAxV?=
 =?us-ascii?Q?hGF42vlYexH0xeBXvCxEgyvYYXOAdiUkQnHwIIJa9O+ub41NzvEbCnHvMnoO?=
 =?us-ascii?Q?0ktPuUrf/DTN7vbsXkCYdbX/RD/uqiYIXxyTwQaz6cMnrRex/Qgw2MCtiuLp?=
 =?us-ascii?Q?W3WTuwR+JsPOgEufmrLYNjR5M6a4Ytv+ofH5EdJPbcvD1clNxPM5nmZGrQUz?=
 =?us-ascii?Q?54yTVv05Cz/eWT1wx8v8LZasP+xT7s5ED9nsGRyp4TgrwO6B0avGOPP4o3rX?=
 =?us-ascii?Q?DI82UGU65adPhcaitNajdALjyXfbjdHG4JTEoJiVaEg4fWeAVuIBwN1nCEXQ?=
 =?us-ascii?Q?EoFdztSxIPSbctModu8OPjOuCzpKPznhrTr53jAnt1QKagmBVlu/xQ7ep7+R?=
 =?us-ascii?Q?duBlqi6M4iPL4Qq1HnUtcUUbhLHZcGWgIFVz7xaUumTO2Zad/xOQqMBd+v3G?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wTi9CCW3WCejRDXFrOO1LWQBOSsXmtEASdq75jhMjN/ALYpWWOX7KQPNI5OeCSSR//yKLShm2Qxf1Ms7cD0P9lK4gRGigBDG3DvXaLA8cY5pT/oraZZFt3FM6FL3LKgRPR8RzbAlSQlpg0s466jUB28lEkjZ1PTyzjrCG+il7PklfonRXHvbe+WJO69GHzyrH3/uSaDiARhf40gDWWi+BZ6EDaeVHInblfaElBM+RaCbYpG5gmDkry9jrRLBOJN2pqiVX1zHhCA2aUxxXDYbn5wQt33dYXeg5K2N2X639undaN/DdrmLGmMwJKxEiVHxClrTRIk2GURH8a3+Sa1l6gTeH/qd4wJEa8WRzz/xLbbl/Gm3FiWrjs314zghT7X7jkMhKuR5FM3BfezeORBqFJhI/n0TBu/jyDD9wdJyYf2Rga2FLxM6ZKk18dKy5wyRxqe3k+3lh2QECzCIR/TCR7bH0vmlqxNwPMZKChXsGHq0OTEFQGXegIvgyQ17tqE0SjnNww8zKxzeSaOFdNLRW5D+keuC1Yx4WSIEgUx9UTm1nJVY4wsnhVH6eodlmHzRa2KXnfGHkdSoJCHwd35PS4VflXTW2p5gR7mkOnv7DaI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 241ff2ec-236f-413c-4dea-08ddea9f7b32
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 04:08:05.9271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7pUFiuLSdvOxxnIENFbr5VcOcCHqVP9TAAXYZpp7JrKa9LAYGvQh+HfBR3MYIUfjoH3mTlYyH3jfQ3K+IJd4rVfXxFBD9GxcTHc9Ruw686o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4511
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509030037
X-Proofpoint-ORIG-GUID: 8_jWFIkzP2bhjQuS_1eFUbjXo3jyXank
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDIyMiBTYWx0ZWRfX12cri6dxazoc
 m8OnZJXk+lbWK2LBIcvNDVHVq4Z3t0V/533t5efTNEoOUGgsfKjghAqAUN1+f7dNm8uhKPMjunp
 s9N0DAVYvQl5TwJYBm3T0HzR6fmqD1cPcmD6cOAUJDmLe97lG15G+7fY2K433C+tPdwgbY0ILKl
 iPxDCrlHHxYkqfgouJH0Gg1cHkPgdBBkbBljQPmihd7uO47DOWlS/nQ0rTVD++FiMMDenVGk3fH
 R0Li4lFy2gS8DZz/jPmrI8CxXpPyPAQeqcpzobJXISO5m3+FjZtTQSJJZ29FfnoWf95YeZwvUs/
 T+pgU+H93X/x1ZFBeiEWlggisEx3kxTuLKGLr2sNs7cyPGVM4LF8YbPefxSIZhNTebpuLls8VwG
 UDRpUTcGcqcBVevxxKna0ZHBcA3q2A==
X-Authority-Analysis: v=2.4 cv=doHbC0g4 c=1 sm=1 tr=0 ts=68b7bf37 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=_2jW0KM6d92rkqGiJZMA:9
 cc=ntf awl=host:13602
X-Proofpoint-GUID: 8_jWFIkzP2bhjQuS_1eFUbjXo3jyXank
X-Stat-Signature: cbo5efmu635mwgauzoimspok441i4ptn
X-Rspam-User: 
X-Rspamd-Queue-Id: 26541140005
X-Rspamd-Server: rspam01
X-HE-Tag: 1756872520-365915
X-HE-Meta: U2FsdGVkX1+80QVImEBcC6nyrJwOpPDOHf019NFzIBcjAsmrWxNq3g8ugh3P+JAevKV4nCp2MKlAs1QP/LkUEU90JbgL6W3fT2Rvq2skgTZfXRtPYSk3gHd7nROClbejYmqYTdcYkW1L3hJ7Wic49k6iqYJRmUCkJPMQBAQipZPMxc3em0ibiHTi+pQY3eWPpPRZd8wRhuv4LH6cVDE08wirRQhHjTXU9aKJOZ47zV1I51W1nPYPdnEBn/kqkkNdt/C/R5lnWYYDsh+F/Rcno2qVKRckFO3CNdnzBbX98HIiKP85O9MCLZoW2O1Xi2UKX65uAWMYDs/CFUL2Jrt1AqnnMz8+OM/6/4j0nfqOStZQiYkgxr3cBNLz1MKs6YwOfhVgK1d3YXHbvJCGMg2BfypwveiHPb72/l0yghepj2fmdyHp4bTacraR8fUcwEWrnBrgabb7hbak3wqVdYFQxhnBQk9eJVM+2DSU5mRDJudfOMjLSSO7M51WuacrY7YcfeZGHGIeLdGt52N5r6qC1ux0eB7ShK21IjTZ0SF5KBPVFPFSk1ZA3ellNvE9JpSsf6dECO1260qg0FtjhmaD1PsDXBwTx7qJTuSNb6hfvfIzF476AY9+iukXFCnkGk6vDp3dlbGNpt6FBQvMmJhfmeWrK92ZlobcH3oD5VbWiq0YgRJ3r8m+YzrFld4gDUkkMhVLO9U8dF7VeH4TlanA9BkwGsOUdbcYTqqW2n6gwFea7Yrk4iP8basb9EJ9NqsPuaoMHl4Jc3Lcntgxq3KU/A0Dcrb+RMdhqdTSFQzNHBUXfV4+2YITPzcEttsJK+3zsSpYSLm9BMlbuq6y1au09azZmqFLV2RZYaVaFP8X5Edlg5tHel9EkcaXyUw3+jqlEsP45MFYSm19H696WhZVn6DwLTYICU5PVQ7Y1Tw7fWHlQSSWgt3b88hD/Y7J/VBOI8t3Ij6adjcm57WFmBm
 Rp8yN+Xi
 hNnknN53cR3KxSW0jLIvZetBZMufkmMlIPk4Vya4rg1QTDXctBduD4kR9dZA3Lne4zoh43RXoqUqVHpQUVfYRGIln7QWyjc7Qn2QelUtuAGQU3KuDQuNVzHACUwGpIQpSrdAN7zjq+DdpBMw1arHWUbgf/4Lu9rIO7ZGJ/UxjqVfcqBrF0M/vqiwGo5AseRoUBpYDUAU9RtqxDjZhNWJRBvvG3OiqP2d3MIKs4uImrZdDdCNp+PQwnUPJW99JcwMjfkgJcJuDjhAlRqaK8OJcgsUtFmQx1kibfrQdaVeDCGTB9hLsJIAIH+MS/71j88rghCUkn3x/p4xNkaFgd1CuWUiJ+loZUHTlm+xAz7tO8xfVEu7aWFb7+ya/r+ZhI2R4kFM3YMgK+kc2Oeb9pY0YcQk3U1ffLTvQcwjMF+eG1zhbzXAuakf0Xt9dACQMEYJrA7XOXy1lfF/MVpooGcaWlUIAWwXM9B61eMr/FuCp2BTxtgbgABf9dMUYT5QV39xuzf7Ehw7K2J4LrRvIX74nImzYPogcwKYVJS9j1xGBS6kOtdB9b+oTGg19z5Ax4KVtl18fBqUqdsARS9Q+1AaLg8kWc7aFAsmxfwUX/A4NOzPpBkI74sPKIA34SrGW8ZU8L0ZboFf20oq53SKZes8JI4mekEnria5owpbAFYGK2Xg1gv9bis4HfVbQRaxwoZPBUSKdcm9bxho4qyIG3gKeNsEkWQ2Ju13Ayut8KCveKMoqdqXsr7Rr9q6N/4sem0Yz6NDOj3vO62lLxkgwCsdHuqnyft1htO8PD1uMqfHSQ6WiFFk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand <david@redhat.com> writes:

> On 02.09.25 10:08, Ankur Arora wrote:
>> Define fallback versions of clear_pages(), clear_user_pages().
>> In absence of architectural primitives, these just do straight clearing
>> sequentially.
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>   include/linux/mm.h | 32 ++++++++++++++++++++++++++++++++
>>   1 file changed, 32 insertions(+)
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 1ae97a0b8ec7..b8c3f265b497 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3768,6 +3768,38 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>   				unsigned int order) {}
>>   #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>   +#ifndef ARCH_PAGE_CONTIG_NR
>> +#define PAGE_CONTIG_NR	1
>> +#else
>> +#define PAGE_CONTIG_NR	ARCH_PAGE_CONTIG_NR
>> +#endif
>> +
>
> These likely don't belong into this aptch :)

Yeah :).

>> +#ifndef clear_pages
>> +/*
>
> /**
>
> for proper kernel doc
>
>> + * clear_pages() - clear kernel page range.
>> + * @addr: start address of page range
>> + * @npages: number of pages
>> + *
>> + * Assumes that (@addr, +@npages) references a kernel region.
>> + * Like clear_page(), this does absolutely no exception handling.
>> + */
>> +static inline void clear_pages(void *addr, unsigned int npages)
>> +{
>> +	for (int i = 0; i < npages; i++)
>> +		clear_page(addr + i * PAGE_SIZE);
>
> If we know that we will clear at least one page (which we can document)
>
> do {
> 	clear_page(addr);
> 	addr += PAGE_SIZE;
> } while (--npages);
>
> Similarly for the case below.

Ack. Though how about the following instead? Slightly less clear but
probably better suited for caching the likely access pattern.

   addr += (npages - 1) * PAGE_SIZE;
   do {
           clear_page(addr);
           addr -= PAGE_SIZE;
   } while (--npages);

>> +}
>> +#endif
>> +
>> +#ifndef clear_user_pages
>
> Can we add kernel doc here as well?

Will do.

Thanks for the quick reviews.

--
ankur

