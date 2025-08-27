Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A405CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC9CA8E013D; Wed, 27 Aug 2025 07:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1E18E0105; Wed, 27 Aug 2025 07:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969718E013D; Wed, 27 Aug 2025 07:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 801868E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:37:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24ED61405B1
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:37:58 +0000 (UTC)
X-FDA: 83822338236.21.3C0059E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id AC563A0007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:37:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lxONnFue;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="dEjS/OZC";
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756294674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C7TnFeBn1BNEFJMsEP17Urw1y4trS6HfYCtrtAdbiwQ=;
	b=gsvibdH1AN6Mu1uwD1PF6c1spOmUGNSQJupsPb0of+RVm/fIFLfS6LhKjmmRjHLrx7ADR1
	AsE5gad71MxIaAzqKCNKCqz0kkza9e6TOToR7Xc8sBFHUXxgKFfrwEGHhT/vs+iewe/uJ4
	7E4Rm3f3v03ai2KYwZT8seOGU3WHm9o=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lxONnFue;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="dEjS/OZC";
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756294674; a=rsa-sha256;
	cv=pass;
	b=nckz/rh46rRUbDeISAbglIuhMvQ0wG9N6pv213DLLVsCMjiP3cXDs0kGIyXvyRej4KMbBF
	M0d2uQsKTd2QQmMTV6J/V0JVoYV7Cn/S9toZpipLjE5X4V5Y83UAI/DJNbaMIzoJ2k/aTO
	LRzyQlaZH4iA+YnFM9AIOATCbLGf86Q=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57R7tud2008528;
	Wed, 27 Aug 2025 11:37:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=C7TnFeBn1BNEFJMs
	EP17Urw1y4trS6HfYCtrtAdbiwQ=; b=lxONnFuenQSBIiCR6gBsGfqxUyNnv/Jh
	IKDPDpDz+pcNfXD6ZbjoqYinR81SW+XITodFd7v5JcJfTaTwFDbU2aJ8cBP24ZuA
	W1bj6NdOL3YOX82TsHc1ZNCseRy9vmTzICY4mnoC1js8yk0kMR0KtfNyY65zSePl
	rbSDv7WsyL4jWjCqeKN7Aajs+dRfymCxHe39ZoPju9qqIHE5SUu9BbDii1LxOYN9
	8NXr35GqDpKR8soTJ/sA5pYyRtFKZTwmX3BS9s7hpg/6rYmYmPc+aNoWkLNu7Jlk
	oeOBdie4P01UD6slBHZDTSB0hA7GItyJ0gXTu/txoD856aYlrI0GQw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q58s67h4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:37:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RBMhZt005337;
	Wed, 27 Aug 2025 11:37:45 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010022.outbound.protection.outlook.com [52.101.56.22])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48qj8au1wd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:37:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E86Be+zXvbIpjdbjB2mGqf4UFRC3F4wiJjj1WcMiEtefi6QgkkoVvc3iHBSZuvdeFtlPBJlxJQIObNX5o9gdVY7InQgKTTIiVJhWySOWkXVHwbj//eTm2HKva+6Uja6mFIqsH40nCckpxZisowIXX4/fW7uWPeUFnaxKXSPDRNs+FaabmMjRpRjMUpAOZ1PIc0UnAakrzqcpyYXzhYgQ/HJWXfuXtalSoIVyFe5Gf1pZoyDHXr7ueJCVYSO8Jk5CGKRkOcMp5T/KFliCSYahWOk8TMVwP6dytu5Yd3UK2imIsCjocySl2806hYCPWSTO0+iX3X69wBHBSwO/2JgzJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C7TnFeBn1BNEFJMsEP17Urw1y4trS6HfYCtrtAdbiwQ=;
 b=nhUESIJjN47CiENt5GHn9H6GH4nTB1KDk8nWkY6Ddy/Eb1xvp87Qqi0x+mCHAc45r0V/jO0FBDZpwyUAcBymbyyKVG/Ff/U08ocR1bv5Dk2UsP5fYVinvpEW6RbcdvJAPQQorQ7CMawu6ETSYXI6+T8DYVh9t8uObffkFcnFgPLhBOX//EEwy/hxanW+ZjgRU35dRCDw462DDdHibDBtSf8tJVqtA+woD2e5BiTLP64LVYDE3xXrKhHFJW3XS/ACkvOh0+9aT/gFivqYC21kclKV5kvYg014lxGNd/7DMQSy5ZpeqCBkCl1xmp29tIQUout0vLVoi2WRzOTY8753mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7TnFeBn1BNEFJMsEP17Urw1y4trS6HfYCtrtAdbiwQ=;
 b=dEjS/OZCYUabhYdfGrLWWwDi7GfIWCcTsoJVJ5LZWXv+yDdkOADReMqi7QLnt8ftgHYohRfkpqXflUoHrr717QJj8DUP5h3LsG8U8NAASa7tsowHhdhNZU3yiLkY7YjJtWuOb8oFf12w6hSOjYZ1U9UNLL+Lg7VLV8aRY812LY8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB6721.namprd10.prod.outlook.com (2603:10b6:208:441::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Wed, 27 Aug
 2025 11:37:41 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9073.010; Wed, 27 Aug 2025
 11:37:41 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, harry.yoo@oracle.com
Subject: [RFC V2 PATCH 0/5] mm/slab: reduce slab accounting memory overhead by allocating slabobj_ext metadata within unused slab space
Date: Wed, 27 Aug 2025 20:37:13 +0900
Message-ID: <20250827113726.707801-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SL2P216CA0095.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:3::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB6721:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f9a347f-eddf-4b13-1563-08dde55e219f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aDlWY3hXZFNRVkxhZmhFNE5QaHFKQlhsVmlYT3RjOVdQbHViT3FuQTN1QTN4?=
 =?utf-8?B?ejRWendEYnAzWVpyZWg0dHA2TkEwdU5oTEY5Y0RETG5aOGI5aVFEVzRORUJR?=
 =?utf-8?B?UWVRTlBWMEV6N0srSklBOVRsQzArcCtnRkpDdjcrLzFoc1VkODg3V0hzc0Zl?=
 =?utf-8?B?a0NlSERkRWxQeUZRLzh4bDBGdHRjdDZsUXVDSVUrWjJtSUl3bU5jN1ExeEk1?=
 =?utf-8?B?NnlieFc0OUFXcGF4WlluWDI2Sk42QlduRzhWU21INE1FS2NlR3ZRaXloWS9W?=
 =?utf-8?B?cnUxdVpSYmFHTlhjYlAxVm5yNjhzOUpIMDhvS3FIVzJMMWZ1MzJsaTlGVEVQ?=
 =?utf-8?B?emROTXJoTGFGL3BPbVhReWxhc0Q2WlZYeG8rY1o3bGRSbXR3THJ3ZzIzby9C?=
 =?utf-8?B?R3cyTDFhY2VHWUlPZEJIcHlkbWFUaktOM21KdzZBWnZ6VStITjlUYXRSejRt?=
 =?utf-8?B?dGgvMDJQRkQ0ZmlZU1VJYzR5eHZjSndOSDl2emhlemVTbG5JbzdkbU1Kc05n?=
 =?utf-8?B?R0l1QmRvYU43TE4weXpPcjNNTk1pUGRWNDltY1ZwY3VOMVAvdXBzOGNjMkZu?=
 =?utf-8?B?bjZsaSt1V1BVS3BYazZxTzRtQ3lreTF2aUpxbVNkditweDl6Y1E5WmtNRjlu?=
 =?utf-8?B?alQ5anZWY2RlY1BQa2g4MHNoeEg3bWdoZ2hqSEZWQVZRU2xzVXorNVVOeXlB?=
 =?utf-8?B?bFpXekZVODRBaDlwVnkycDRVV1RzUDhPN1JONmRWdWtDOW5ibW96S1c1dmhP?=
 =?utf-8?B?UjNJL05mbzVNRklDa09lZ2dlNDJ6enYvWWxuOThYdWdkTTZUTEhjU3VyYVQy?=
 =?utf-8?B?VG95dzhZSytFTHd2SzkrV2hpYTZvUGtjNnhZVXAzRVpSMFFja3hTSmhUSFBH?=
 =?utf-8?B?cFcvYXE2ZnB5MEZCWElKWFRmR3NIT1VhME5ONzYvQm1TNTVaOEdHSE94SFNR?=
 =?utf-8?B?VHduczF2Ny84dVdDZGkvSHorbHBGOW94WUp0Z2hKZjVYVWpRRTVEa2Z4R3p1?=
 =?utf-8?B?VjNnYTFiNGI2M0JzUzBPRnRzcXhuc25kRGl1TEhJK2tJU1RmSTNJRnNydTVi?=
 =?utf-8?B?WWFMZlJ2Q3FpTklYV1JBbTFiTVN5aktjeEpWRkFiVmU0cUp0dm9RQUk1dG1E?=
 =?utf-8?B?aUw3QW16WUh3NmVYMURqWXFESzVLaFFZMGhyMDhmMTk3QjNyZWlzSk5teVkz?=
 =?utf-8?B?aTNMNDFjWlJOeUJERUxsTDZVclYvNVpDUEk5TUYwV3NORzJ0ZUZqT1R5SzM5?=
 =?utf-8?B?WFpiMVVFMDlKaURyZ3JFSERORzUwQXNjRUlwSWRaNG8wczdubEEyZExxWHdh?=
 =?utf-8?B?UUQ2L3NNV2piVnptdWxnQVhabzhYYWc4dHpKM2hzY0M2N3FEdEpLQzIyRG5U?=
 =?utf-8?B?aWt3cGhGM2lZKzBvd0NnMHVuc1h5azg2MFZNMTZMRDNCNXBwRVRpelZlZGc4?=
 =?utf-8?B?UHQvNytLYkxoNFJUNm5FTk91MG5RWTFpUEYvTldyQ2JQNlV1OGlRMzZyTVRJ?=
 =?utf-8?B?QmRCblJOZ0NMNk04UnNUZUk2ZTROS0ZmL0FiYUFEOFV3VklUSEhQTE1RWDZL?=
 =?utf-8?B?OUJzcHJQSTBPZ094cy9kYXN6SnIwM1Jqd0IzMUdFVHRFN0RCWE92S0x4bWlh?=
 =?utf-8?B?dWxnN2VINnBvRDhqblpMTUxJcUwzU0Zyb09EZUd0ZEhHcUNlZTBnQ2dwT0xG?=
 =?utf-8?B?V0ZOTnBuQ1lZZm5IamxvMnFsZUFDMEZSZUFtMUlGU2l1MGlKY0Y3WTdYOVFo?=
 =?utf-8?B?NXJ4NXEySXNhdGxmT1dkWEVyOFJPSC9EWUZiM2VWZUNlUVI4djVBU05MZUtU?=
 =?utf-8?B?eldlWkhPK0psbW1nV1NlQXpMaHZaUlFUVCtKM3JiVjlLYU1FbWg1cmdqbHp2?=
 =?utf-8?B?ZjRybG4wOE1sNmFXb2dKVnFZWnNkUys4ZnMwTldsdGt0QituSUdHRVVXWEYv?=
 =?utf-8?Q?W70LtP3tWUA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VllKcDFKMisyaVNjYVB5RjExK3V3M3FScDdnM2doY2VnZEpCWlJQVGdOZnR5?=
 =?utf-8?B?Vk5zc2FSVmFmbm40aXMvNk5yWE1mUytNU3hQZXN0YkhNY0hMZGZ4UTVhYUxj?=
 =?utf-8?B?dmYzdEtmUE0xcjN2T2RodVBkVEVzRGtyN1ozeDU0MkR4SmxUbkI3UlhkbTZH?=
 =?utf-8?B?aEVHSmhabForNERERGpNc0kzOW9oakxjL01aNW1scHdoTmlYeWZWb2hxTEQw?=
 =?utf-8?B?VFpKVUVXS1FWTjVHeTRsOWcwMVBqRnRUb25SVkRPM0lUeE5icnV2bkN2eTI3?=
 =?utf-8?B?TytkUTl6RlFLQWtsV2owLy9CbVplbzN6RDJNZ0NXWXltRDYvR3VTenQ0U1Zz?=
 =?utf-8?B?bG5STnRQRldYWjFhclJ1UktIZHJWaU1JMGtNNVlkYnR2bitDc2VnN1ozOXpx?=
 =?utf-8?B?dDZwcTYrbjJ2aW51MGFGKytkdkpXa2c3c2d4MjRkbVJUeWlEaDVyUkVzdmNh?=
 =?utf-8?B?Q243SWgvQXRzWjkzM0xzajlENUoraFZzdzRqaWQ4bGNPTEUyM3hURTI4b2Nn?=
 =?utf-8?B?dXdaOENZek93ajBiNmpXTjJ3UE12ZXNMSy8xVzFUMnEyNWZKREZWM2tFZXpp?=
 =?utf-8?B?TXpENG9JOGU0SFBueG4wTHpzUm5TZzUrRFdKMEI1M09JSzlXZFRnZ2tVNHNl?=
 =?utf-8?B?c1c0NDY3c21NUE9kOThpRk1ENm1hRmNHNVpSM1Bnc21FNlUyK0tBS05tdzJG?=
 =?utf-8?B?ZnVCVE5ISWk4bVRqbFFiVE02K1MvZjY2VVcrV2diMWpGV2VhWmI0dHkyVXhQ?=
 =?utf-8?B?V1ZEZnN6WEJkOWNIZ0g0Tys0ZkpYekl2L0cxZTlFQ1RPQkFwK1VoM09iWHBx?=
 =?utf-8?B?SWFaczQ1UHlPRDFwT0R1aFM2MVcxRWNRb0JpQTRSQ2lqUmhkYmhpZDEwT2ln?=
 =?utf-8?B?eW8rKy9WMnlwYnZJWFhpaHhOLzFuYnQxQ0N6cUE2RElXWkxPMDdpMS81aGJC?=
 =?utf-8?B?MnRsdTVvNnNXY0p6VVdzZXRXbExSMFNZekdWK3dBWkpXb1dpSk9JenF3Qytx?=
 =?utf-8?B?aEJ0WGhTMkl3Vkg1UTVtdXFDOEpJY0E5aDdobFNHWlkyUkZPZnB5aVBOWUww?=
 =?utf-8?B?RVVRcVdBcTFXbDlvNnJ4RWlHNHVQL3krcTZkbDNDdk85T3NWRGI4TnZ6djc0?=
 =?utf-8?B?RmJ2b29McHJqanZEL0RhV3A5WnJheExCRzBydXhmR2FnQ1dqWVFMZkQ2ZWM2?=
 =?utf-8?B?RWVpbDF1Y0V5M0NBV292MG1PczBMamxYeE1ZKzFwOVFTM2Nub0dVN1IwcStI?=
 =?utf-8?B?TnhvV0Q1bVZWaENHUThtSW54bGorN05RYzhCUG5EcUdOM0tnSkVxV0pKYWdk?=
 =?utf-8?B?S05MMlNvRnl6eWo5ekoyS0VET0FoZUxuOHlnbHQ0dkhDNTRxbVNValZZVENs?=
 =?utf-8?B?WGdIbytyeEZsWm4yL1ZHcjJhUmc5K05xSGNUOEhZRWhlY1dnN0NHTy82dWFZ?=
 =?utf-8?B?cXVGVzBHczJ6WEtidEpkZUJGYmlieW02UEI3cUMrSVFFbWlBS0hybCt2bXlL?=
 =?utf-8?B?dkdQdmVBanRuVkxNWjFJOGVYL0tqQitlSzZjSThsaFIxWVBocytDR1B1K1gz?=
 =?utf-8?B?N2ZlczFadTN3SVFBRkFkUnNZV0dabWU2QWlWUit0N0FyblJaMEEwbHo1T0sz?=
 =?utf-8?B?WEhkelVGbmprSThLZ2VlYlQvVDVGTVNiWEZHUjN6Wm9kYWtoRDVUeXdCQTd5?=
 =?utf-8?B?ZXFRZi9lbFFrR3JPUWhFUTZ5b2crZHhPTzNKQ0xxTTdLRi80VzZTU0t4cU92?=
 =?utf-8?B?OXJPZWNXdGY1QU5TMnlXZ2grVEdHdk15bXcrYm16dThCb1piV1hxdkVad3My?=
 =?utf-8?B?VjZqaVRFYnh6TG5tSmcvYUlQSEQyM1RDVXdCN1loNFZqVmh0aWJZckgyOFk2?=
 =?utf-8?B?Q2FEQjhiWG1ScXg3cjBjaHJESnFXbzUxZWt1WC8zcm9ZdnhXOWRQampCOWNx?=
 =?utf-8?B?U3RTVnFER0JENlZhTS91VS91TXhwK2RHYnhoRlF5QlpUOWE4WjVVSlM4S3dy?=
 =?utf-8?B?SzV2UEpOb21PK0xiVk1rejV4WnBLR3NmdmZ0VStQa0ZiSEFmVmI0Q1lMaDFq?=
 =?utf-8?B?M2N1YW9XS3VOMzJMazNid3krT0ZjTmRxZnpKMnNrKy9HR3hjYVk4UFZpSDdy?=
 =?utf-8?Q?Y2uuYxRaFPsXH3JkhsVNsZHDK?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	01u6ml18g5zclnblXJC3CIV84b1nyqMEoLYxEgbdAvwVQYOH29/CaNzN0C5IDvkeHAe75eyQAeBS8XZDiG/R2SxykEUrZJHRBbgJ0a/3yqv3xlqVG6YhSBfxPBSDX7mauIxcm02qV14rVoV3X8/XYHC+FjnkupK3Tn62I7uEw/ueyNB2lg4M8sr7KxbbF8g9TdpGX8X4g1LklwJBkU1/ra/J84Iw64jdfstfHsO/O6KmA0XIEQaItP1e5nrfvgc+v9RP4RK5s5obrUQR2fmHqZaERXbaLV/R0kaQeIBDAnc3/qT1+Ba+/4sMS2HGRUS3Z4mQ3aw1FfKHvqitILbY7yqw2ZYoFH/ea74pGxGWp4AR4PRveAB9d5Bcw8U4i1F8rym8Hu16kZC8569+Q+NU5rD7yHofiKKwKf8h+5XOOFDP47Eh21K5vKVeRmvUoGrLUn6N5zGlDuDPFMjYQ7PvLAGNO9PBOhKNy9vdwRsFC3C6PK08umosMpStLnwI9hMs0GNlKlgIQ8ARyccnY3RsNEi8PdBqsb5aDqOgTA3kNeH3NeqtavaHoSmA5KrfRgWfJZTtWzktds52GVdoTPkYJt4i6598MeUWK85dTKatGKw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f9a347f-eddf-4b13-1563-08dde55e219f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 11:37:41.1959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iZMe9cDLAaj5+V79PvjOFP4K+s66dWIYhOj0Sx8+48dfM+St3X2x1yFo21Ffuzlx6V4UaW9E90/TMIwnl2PKzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508270098
X-Authority-Analysis: v=2.4 cv=J6mq7BnS c=1 sm=1 tr=0 ts=68aeee0a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=DfOWYtB-9HCnPwJefzcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: VulpfxG45Z4J29dg9sYC7VPo5OBHAArE
X-Proofpoint-ORIG-GUID: VulpfxG45Z4J29dg9sYC7VPo5OBHAArE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyNyBTYWx0ZWRfX1Vsi4OF/lIQN
 NOAFM/bVxk1MoPRS+IW9elaM5zelzWFGKbqA8+DDhfJKqmcvCymuWoPpOUhwkS7uzBJCDjwAtDt
 xpzKsgRk88m+aMQtpYNu3W1bE+qUwiQA5h3m20aNJ0l+dzDqu0cTsQxwXMan86NrDhpZyd7kUeW
 tKLgFsjbZ+p/7JkXppjGc2myD8+jPJzWjvhYENb6GMDL4WMVu+HEGQ5Jnz8dQ6Fue3rOm+SodL7
 pMXucwBWQiBekcTcVbkn/ornpq9FI6KXwBRZNN5Ieex1ZyJyMN+CwL8llmbd5MYrw9OwiX1jmnT
 OgYJ0aWgG8sukA0u150gd71T6oIDYTNx3QtTSKc4CWTB3YRTyMQBN8nu8/1NwrTvmAjyScE3BOt
 xTZ+oJb+y3d3o00RdsmJmtL/BKJ9pw==
X-Rspamd-Queue-Id: AC563A0007
X-Rspam-User: 
X-Stat-Signature: 7oj851dqgdsfjx1zja1deqkrp1itwpjx
X-Rspamd-Server: rspam09
X-HE-Tag: 1756294674-506195
X-HE-Meta: U2FsdGVkX1+tAxoLdZ4jrMk83x++8+5sgrJRd93Gc95bX3RXYTrZz2LLKMivthu+qc5aGUKgj5zRTU7icxR0ZrQG2NaOEQsPANXTH7+kV66P0RI9oxTS9NKSpbV1ao+0Dib8P08OV62RE0S/keqL69hpHgDiGQDyftPbj6ofPcRRr371ZSJhRI9hfsZXNqAuGFI5KTNfi8WSsujB3Jm1KMGNXJ+4N5Rd84HkKDBNSFWDvz4tCwWli5qgdTQxHRxxdsXSg1C3h0+psln1mMmN71UvYVMXQmAs2FcYXYABx0rkh3RERrChx/XffbLc424DFwe8omg8E/KzdcPxA57aqeu6jJa6y762pusUl+i4Tj7x79S7XWhg2HxXzgn2uWlJ1CS9oi/bK0bws/yd+jjQu0922N8tW5l1nENqmVbstRIk27rCMebFsPB0EwhdxizcZltYyarVRM0+P3xnR51NuEalz/+u+28jFdGuhHwv1D3ra/dv3msZwyQ7Av7QTRJsBv3OvqVr7rgJ68mxE0HuWEKNL4ZUD/0pfYnQELw1W7ECx+VkZpr2C7jFbkUErhwVPv3LLzrbrwKHPI8g9NfvGYza+uVJm6tN4CTf+iZJIopWmaDJf9ozmgwNiTzpMgXkkYBRVFg3ce+5YEveln1HdhbH3nr17xs0tUET2OVa5wu16/9bHgOl9Td6y0zq4BFOwav3CYz8mzWuooF7LjMGm1WwU8RKwwaDL/qiwh78QESfFEoZKeVOLhkgHTPjTWabwNlXTX0mP/RGCSOIWTmRpVvS+n1zXJuO891437kYracSRx1N3ibXlLoHxcBNYQbU3vDLjS7J8l7wj8RJO6MEh/9OOUOzNbaN1nopcPiGCcJXlSFDUOY4rSRkmGsqAU4a9+ChDmubFBHvxGXMbb5RexlU8U15rTdPmHgOmPKqo0EDvRG3LcBwsI3VkAKIg1zDye1VNgn7rJFoNWBV17D
 L0yKgYcA
 Z5rymkzcP9MChNfpOurXmJy7NOyrIAybe+0Us+7ADtlMuO8mCN0CQGRPijFdtXU3EgF6tDB3IMoTYhYtPToTILxIt2sXYeScaVrIMrEjyqoco072SyuLaXqqqisX9TqcOq4/A2GaDM23oVVjS8S1M+3C5FW4+f++faNm49AHlwNRbbAuhUeSivy3krCG47S18nQIJdQVwj66BTpVjbPdhIwh03+9kZ+Kzxgbb7wDS8+ScD/cKqrgMwDu3mzfrA0p91STnf9MfVX21yeItb4m6m4Shxc2lXrDlFiqMYwJxCTH53Cx9aaJIw3ZfC5MIgZdpEegk/maWGXS0o6RVAAhPLol2zMrq9lu0yNA3ocGgZCl6k7qumvVRfVa5y4gsHHeUWbBNGLmYncsKUMaY22y9nnR4s6rtFAwnl80wdEV57wo2xj0wqsigr9dvqXIMjxWkKDbW15iNOluN4sLtEe8ROtCnXSSC/XlfiHTozZ2WBL+wuJLfQzOVQi+u9hKFHKSDWIuC5VstcMPiQ571PaFLbw8aSb+IwyreWn4NDsY3DoHPeEf1dOIPcq/DbDFHqiSicrwMV8B769Flct2GUAtWlD0n3abuvGje7Y/DYLl8MIs91zP5vc2MAnP6CLtGX/9gkVfW8KD54D6liNhotlqwLK7uTEtcxTxUCVQBJtmps3AUqAExq2nE4LtV4jxH+0yt/QQ2SH2IkX7gCyYAb2QVbLT1vKGm4CZ5eUFOq3BNvpSCDzL2DJpNlvo8hZIzJsiTtRLaMHEcGab9ITEKVIgPx7TgyN9JucDXkWRxTIGOI1lk3OPehYrB/+jWPiKE4B4dbqJR59paQ+ZaKGQjzQ94hrCYleWovAlgr61pgfqQ+KabH1dK9FCFWnW9Gl1PKucIz2Lm+ziDAMlhNxTpvXjaQ/EgnHkTl8RB+dxI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RFC v1: https://lore.kernel.org/linux-mm/20250613063336.5833-1-harry.yoo@oracle.com

RFC v1 -> v2:
- Adjust Vlastimil's suggestion (patch 2, 3, 5), implemented case 2
  described below. Thanks!
- Fix unaligned metadata address with SLAB_STORE_USER (patch 1)
- When memcg and mem profiling are disabled, do not allocate slabobj_ext
  metadata (patch 4)

When CONFIG_MEMCG and CONFIG_MEM_ALLOC_PROFILING are enabled,
the kernel allocates two pointers per object: one for the memory cgroup
(obj_cgroup) to which it belongs, and another for the code location
that requested the allocation.

In two special cases, this overhead can be eliminated by allocating
slabobj_ext metadata from unused space within a slab:

  Case 1. The "leftover" space after the last slab object is larger than
          the size of an array of slabobj_ext.

  Case 2. The per-object alignment padding is larger than
          sizeof(struct slabobj_ext).

For these two cases, one or two pointers can be saved per slab object.
Examples: ext4 inode cache (case 1) and xfs inode cache (case 2).
That's approximately 0.7-0.8% (memcg) or 1.5-1.6%% (memcg + mem profiling)
of the total inode cache size.

Implementing case 2 is not straightforward, because the existing code
assumes that slab->obj_exts is an array of slabobj_ext, while case 2
breaks the assumption.

As suggested by Vlastimil, abstract access to individual slabobj_ext
metadata via a new helper named slab_obj_ext():

static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
                                               unsigned long obj_exts,
                                               unsigned int index)
{
        return (struct slabobj_ext *)(obj_exts + slab_get_stride(slab) * index);
} 

In the normal case (including case 1), slab->obj_exts points to an array
of slabobj_ext, and the stride is sizeof(struct slabobj_ext).

In case 2, the stride is s->size and
slab->obj_exts = slab_address(slab) + s->red_left_pad + (offset of slabobj_ext)

With this approach, the memcg charging fastpath doesn't need to care the
storage method of slabobj_ext.

# Microbenchmark Results

To measure the performance impact of this series, Vlastimil's
microbenchmark [1] (modified to add more sizes) is used.
Because performance is measured in cycles, lower is better.

The baseline is slab tree without the series, and the compared kernel
includes patch 2 through 5. (Performance is measured before writing
patch 1)

[1] https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/commit/?h=slub-percpu-sheaves-v5-benchmarking&id=3def9df24be06fd609395f178d0cecec2c02154e

SET                                                     |  no_memcg Δ% |     memcg Δ%
------------------------------------------------------------------------------------
BATCH SIZE: 1 SHUFFLED: NO SIZE: 64                     |        -0.43 |        -0.00
BATCH SIZE: 1 SHUFFLED: NO SIZE: 1120                   |         0.28 |         0.29
BATCH SIZE: 1 SHUFFLED: NO SIZE: 96 (HWCACHE ALIGN)     |        -0.24 |        -0.19
BATCH SIZE: 10 SHUFFLED: NO SIZE: 64                    |        -1.09 |        -0.74
BATCH SIZE: 10 SHUFFLED: NO SIZE: 1120                  |         0.92 |         0.36
BATCH SIZE: 10 SHUFFLED: NO SIZE: 96 (HWCACHE ALIGN)    |        -0.44 |        -0.72
BATCH SIZE: 100 SHUFFLED: NO SIZE: 64                   |        -1.66 |        -2.38
BATCH SIZE: 100 SHUFFLED: NO SIZE: 1120                 |        -1.36 |        -1.36
BATCH SIZE: 100 SHUFFLED: NO SIZE: 96 (HWCACHE ALIGN)   |        -1.88 |        -2.54
BATCH SIZE: 1000 SHUFFLED: NO SIZE: 64                  |        -2.98 |        -2.79
BATCH SIZE: 1000 SHUFFLED: NO SIZE: 1120                |        -1.55 |        -1.48
BATCH SIZE: 1000 SHUFFLED: NO SIZE: 96 (HWCACHE ALIGN)  |        -3.39 |        -4.05
BATCH SIZE: 10 SHUFFLED: YES SIZE: 64                   |        -0.64 |        -1.22
BATCH SIZE: 10 SHUFFLED: YES SIZE: 1120                 |        -0.74 |        -0.42
BATCH SIZE: 10 SHUFFLED: YES SIZE: 96 (HWCACHE ALIGN)   |        -0.59 |        -1.11
BATCH SIZE: 100 SHUFFLED: YES SIZE: 64                  |        -1.99 |        -2.80
BATCH SIZE: 100 SHUFFLED: YES SIZE: 1120                |        -2.56 |        -2.74
BATCH SIZE: 100 SHUFFLED: YES SIZE: 96 (HWCACHE ALIGN)  |        -3.43 |        -3.21
BATCH SIZE: 1000 SHUFFLED: YES SIZE: 64                 |        -3.40 |        -3.13
BATCH SIZE: 1000 SHUFFLED: YES SIZE: 1120               |        -1.89 |        -1.99
BATCH SIZE: 1000 SHUFFLED: YES SIZE: 96 (HWCACHE ALIGN) |        -4.41 |        -4.53

No red flag from the microbenchmark results.

Note 1: I suspect that the reduction in cycles is due to changes in code
layout rather than performance benefits of the series, because when I
applied patch 2 and 3, delta is about 0.3%~2.5%, and then delta drops
(as shown in the table) after applying patch 4 and 5, which doesn't
make much sense.

Note 2: When the kernel was modified to allocate slabobj_ext even when
SLAB_ACCOUNT was not set and memory profiling was disabled,
the "no_memcg Δ%" regressed by 10%. This is the main reason slabobj_ext
is allocated only when either memcg or memory profiling requires
the metadata at the time slabs are created.

# TODO

- Do not unpoison slabobj_ext in case 2. Instead, disable KASAN
  while accessing slabobj_ext if s->flags & SLAB_OBJ_EXT_IN_OBJ
  is not zero.

Harry Yoo (5):
  mm/slab: ensure all metadata in slab object is word-aligned
  mm/slab: abstract slabobj_ext access via new slab_obj_ext() helper
  mm/slab: use stride to access slabobj_ext
  mm/slab: save memory by allocating slabobj_ext array from leftover
  mm/slab: place slabobj_ext metadata in unused space within s->size

 include/linux/slab.h |   3 +
 mm/kasan/kasan.h     |   4 +-
 mm/memcontrol.c      |  23 ++--
 mm/slab.h            |  53 ++++++++-
 mm/slab_common.c     |   6 +-
 mm/slub.c            | 276 ++++++++++++++++++++++++++++++++++++++-----
 6 files changed, 317 insertions(+), 48 deletions(-)

-- 
2.43.0


