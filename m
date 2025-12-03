Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4ED2D12D56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 13:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07ABC6B0024; Wed,  3 Dec 2025 08:59:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BBC6B0027; Wed,  3 Dec 2025 08:59:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0E046B0028; Wed,  3 Dec 2025 08:59:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA34D6B0024
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 08:59:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D00D1A0640
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 13:58:55 +0000 (UTC)
X-FDA: 84178315830.06.EC6631A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id A70B440003
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 13:58:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LCoIkBmx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ip3vOMhn;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764770331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8W8mgqEyvRoFqpzyVzcH262c+J3hMSTzJZFU41+MMlk=;
	b=lsx3Wi/JgOkmNEXmJXiUzoWTrNSDgFHBbwowmeghKEi24k3Aczm3KCNZWi7605alo27CkG
	OtaXbBYAokGvvHBkJmWb0/AjoxbZwNTQdjJgaibyl6YLYowciDp7wegaJjl7kWvOQAouJx
	MkomojbOqm2R8gY7aaS1zweXfCydSEE=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LCoIkBmx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ip3vOMhn;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764770331; a=rsa-sha256;
	cv=pass;
	b=20kqX8OKa485qFI1YtAdZ5OoK8uxsZKD0nHnz/SBEzjFg51UmfM0yRxHm5LFrjgeW7lY+C
	u92382yGPSbLSuonVHLvp6sVFtlXteVCEqXtKgfdkmZClfhuTJ+kpqqqPLJ2fMlIZTBc/U
	3YdKjcoaePn7vFbnUwKpUVPQ6MwiKAk=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B3DuDx12811634;
	Wed, 3 Dec 2025 13:58:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8W8mgqEyvRoFqpzyVz
	cH262c+J3hMSTzJZFU41+MMlk=; b=LCoIkBmxbN7gPF7Ux+zyZ/LXjpQ+N0lvLZ
	mg3jTWe2yJaXDezNitEi/VUrrLebECqSRsKcMz05DYUzmHvt9vccXlFB+t/o2BWT
	l9KYcylWMq/IQzCmt+SET3nokWQlaVZuKKj+bQKGM4jdrLvjVD9gnfff0OoDVeDS
	EKJi5WC0prp+sqiFk/bPt0Xkm7Fpg2iB7ftcqmuy96nMXxccFj6uAmUu3Ce6i0WT
	SET0S+il+3n44JqVJDQdbY3M5tvMKCkx7x6m0rxOyMkLfLPuETYZB2qBQExVqQx9
	NhpfaiKC5mJurTAZ0EWWz5ttmxAbp+rgIgZvavBR0soY4NyC84hQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as7cp5c96-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 13:58:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B3D05cp023388;
	Wed, 3 Dec 2025 13:58:44 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012046.outbound.protection.outlook.com [52.101.48.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9e86a4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Dec 2025 13:58:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ce2IOVqJ1/u6D+VVPfWPgNWl5CZ3CxuasmDgmacLtqkXDQ/IKpnKbPfHMGDhQX4qXSc7wMfGrcKeICW1Nt1BtthHv500uIwdsr9q4du3yU6/lQCJQZVJ8pD7m/vqEKsPqLZgQO90Oxbk+ZiRrFhfLqvWZc6lRshnLGa+znQWaAUri7dzohxIOOyCl4XrCjAmuVSc0/oCr+L1WGutwDorSJ1fIF84Nw3rEVsLqFJ7Wb5UkpH9WNSICyVSNJW5ye3tn9zpKK8N0gjzCDzOgEWPy0ZPu4bCjJ4Q7LLxELmSK4aropAQvRVJAYBqYbfzfN3pTtRD0VusM2/0XCvQpeawKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8W8mgqEyvRoFqpzyVzcH262c+J3hMSTzJZFU41+MMlk=;
 b=vIuRAB2BpmrIDRprqpNoTofCn6vXA4wPXdLGXmoC8DaDAE6B0Y1lgisCY3nhdy9uGJkhExi44Q7x9TkutWJcpoGEMcyS0HA2YKZcpOlLjv39sdppWIarfP8DdEkiuGEFmSsxcRgjs/cuByCH8yXkXQ8yjIV9i5DlSliGv5XVZ6Opncv8lUPuKm3iyewscd9NEdtsTu7L4nYjqBsMO4AtLc9TgoiQ7262qufP8LehE2Sp2Ur/nwTRQ3DYFSoLvPdqwVu++/2ErrLubX0Zevt7ICVBP7smY0ZYY/nsHrNovZTg2WvlrM7kxD1XzsXAHY/D8o01C9NjfwDXZ9ILemHAOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8W8mgqEyvRoFqpzyVzcH262c+J3hMSTzJZFU41+MMlk=;
 b=Ip3vOMhn3PS1OczbuRQG/YQddvNipGGTxsvuhnYzWfjFAJ9QXme/m7KdozhXFk+WgTEkvW+IwD434R4YPrIilTve4KgNXDvvTj92IDq7yHO7/R0pOUD3s2hw2EF+kPF/7J99/sy+6E+b/Zsg7MO8u7HcFmiIp3MLxLFkwRBD9s4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB4968.namprd10.prod.outlook.com (2603:10b6:408:12c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Wed, 3 Dec
 2025 13:58:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 13:58:40 +0000
Date: Wed, 3 Dec 2025 13:58:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: david@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ryan.roberts@arm.com, akpm@linux-foundation.org
Subject: Re: [RFC 00/10] mm: thp: always enable mTHP support
Message-ID: <54744fad-daf4-4248-8690-93b39fd6c97d@lucifer.local>
References: <cover.1762464515.git.luizcap@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1762464515.git.luizcap@redhat.com>
X-ClientProxiedBy: LO4P123CA0651.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB4968:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b24cbe4-2d1c-4555-6e6b-08de3274103a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0ZNt6t8rl+LmEsUW6Bb/kK4jFzdN9YQyr7uH1SKnPYNH8QwfeOJML+UqYSYs?=
 =?us-ascii?Q?g8XJZBWu6q6vzBr4MjzRt1/+RlbUMbWCAlfz3il1jWxG44xA0jmVKLOhocpQ?=
 =?us-ascii?Q?dCIlfsOOKB9KakEGkUZBXXXikk6haNvs6g6e4j1a0+S2uu9UTt65B42QlOxd?=
 =?us-ascii?Q?iNG85Zt1v6euJRDbfvHs9nX62NqeAtxMsZ68aZ3Q8WmNOrgTcXU5PcqcZvml?=
 =?us-ascii?Q?tbiwXM6dIbsni49XrDxihDSZz4u9BvdvBlUhss4xo5XzjDuMcCUxPfYjwVJO?=
 =?us-ascii?Q?Havhib7iXssymsnEc2q9w29nZ98fmVrgJSi3vB70K0Ewdtb0n8l2i9EEre39?=
 =?us-ascii?Q?frjKYb/PYQ37oF6kLWE/cg/i459H9XbJdTDQSHnYBvtp06qDmvHkDYINIVs/?=
 =?us-ascii?Q?TpoXcvK68fzLtf5P1hxziJowUNMho+LU/RJhsW7PN1fyFEdakLMYggKBZalI?=
 =?us-ascii?Q?kFIYsdj3SnSmOpASu3URqkElRtU91yskbyfmzqmWrkVy3ci3xk6qMWh4Y1kT?=
 =?us-ascii?Q?NVM7hdO5PSaZ4uo5E3LIfbKUYy0K1nnInD1hML2XzOt4SE71tZdNI5dJtLHE?=
 =?us-ascii?Q?uEQ87sw3vgIqmRptcLq1S2Tg8eFuauZ2brrEXG+V6dXNwnaxak599R/sDoI2?=
 =?us-ascii?Q?fFQADMoSyU7sGJ22941uYl/+aRXkbwITUWamKIPHoZqf/xZQFLZIF6TQv9Wm?=
 =?us-ascii?Q?67EpzafNxYA/vY2gmot7dTP1p7ToL8cjiZOdYTrfVSlU6RragSgyJfw6yFra?=
 =?us-ascii?Q?pkEfY2J6iQ5JxebBAPb9rEXpqeR0u0XuMfLsI03qakaGM6hQKO5n6rNm8fQW?=
 =?us-ascii?Q?6mDbi+AkkXme0LvKIhDMW0P9R2Lkh4T2bTEzw7qDBTD6BrobcCIDvm0nWQgx?=
 =?us-ascii?Q?wn5bY5lgqQ7n/GPIwFeL/X8sphvEGKfzIIYE/DJshxEk0bRnZQKroGlWjFNI?=
 =?us-ascii?Q?tNMhWc9UI/k8tTg4a4CfyufcdqgCBOO1IZxp2jVVSxgINnYAcrDOFqneEfR0?=
 =?us-ascii?Q?6p6+Rd16tgXERCXzJjln60gq/YldgvY/L0SH4NX1u6N671xO9GlVkv3FuyIg?=
 =?us-ascii?Q?U/of1wure7O5bjFb4FBATmp+DX/RBiVjMwUOlTZ0U24yxrbeMGNNrtOe5r5y?=
 =?us-ascii?Q?v7ZRTAsllZvvr1UOVmZHkT0Ve3V82mepiTffEvazcnCiluTckwswT9hAzMIE?=
 =?us-ascii?Q?d2ktneuTyyJ+ixPCJ4XZsDQrJ79p9d9ZnNwvbrXTWS89Th1/W9bvvXy2JMGB?=
 =?us-ascii?Q?HosvnNSSgCy9+XLmTsgMwk5fppcaoLLICZdKkg8eUkM9F6oTeqTSHKfU7AJ/?=
 =?us-ascii?Q?kJ9eDA2p/VeccHE57YCFkHGjLteFojkAgvGon5yGomTjdjMp1e2CPIUe43BB?=
 =?us-ascii?Q?POKJacsKwj45lPCs2NvuR2skrG1yCNyJSORQ5mWZImLaSxlzsM609F6xCcDZ?=
 =?us-ascii?Q?j5cOoKH6CLz+Ctsz3LFUpweFJuL99Dat?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uRqVwbcw+7jqsHVpP7Rnn0rf9Ljp79z/UnnuS4oA01rw8htQo+wgk+g6KRpO?=
 =?us-ascii?Q?TrEscSFtA0AM+73TQZHsRHtdH4LMfd43cbXSIzfXNGQozjtxvnQh26wiK66v?=
 =?us-ascii?Q?sBOuWM0WEwaHV+4HKwwBCIcSpnC9EGR+vbcvMJx5Ngzs38i4AaHBC7I8ahTt?=
 =?us-ascii?Q?yp7vxQU30W50LJcsNqUFGFeGk9NLs/BDQMDDF4wI3N28pLnEnp1CYzeUh0XO?=
 =?us-ascii?Q?wFH0DDM4iVMmawZE/d25L86YMPqRWiXs02eicajr5zbAPZZRedfsR3MlEZCw?=
 =?us-ascii?Q?X2jph+eFBcnpnmBfFAF3jdEdT6HascLPP21g5NKNyuZh0DVa3/JvMR6/DdZE?=
 =?us-ascii?Q?5d71xj1SeUODpgP+nifRfAmVyqLzN754wlTsYwOUjazUULs7M5gYyfnikMjf?=
 =?us-ascii?Q?YQuY+2tJsL3vImneE8CZfuMc6Ekm27jDVJaTDsYuTxgh4gwIrUHJlxvb9uWA?=
 =?us-ascii?Q?oCFo/W4HBIUAbcQu3U/V2zlBcPC6AU5c6JsKjx+tvJuIBLGtzscPjlJNja4d?=
 =?us-ascii?Q?VI/bj9K0TfXaHQKZHPOSQGw7nYvKeWScfrD5aP96btGUVvv0+ubP3YpcFDx+?=
 =?us-ascii?Q?8PM/ix3MY/STTKbBMBoPnPsuVigOeimteGL3RaHM6MhLfjkDVKqgtoJCgfsa?=
 =?us-ascii?Q?zC0wptUPfe9huBPfHgKijH+y0pa398a8bf9uk7hyoLTXoLW6U5fUHd7c7NYu?=
 =?us-ascii?Q?A2FbWnMJsOzFO/2+dV851d69mqlNyJW/Kc152jZgD+MQl8a1IriTH2hO8+xU?=
 =?us-ascii?Q?0EkimIxiYG+x4G9tj5a5MvwKg1G2iNJCUR18MkslWzLeB5zYbYi0z+Ip5mQ3?=
 =?us-ascii?Q?B/nwcO0y/JA4ft3KaIGmjbWNIJS9FzVQeKklCxgwLqf8VL9qldDExwPkV4kr?=
 =?us-ascii?Q?GNqYUE6olrmIe/VW/DEiwIWTDic2AOcAkPCKxqCb8Zr3jNKJ0ZFzJGBFOqkV?=
 =?us-ascii?Q?PmDa9MHFzvN4sJg4zzbEnTP7SHUXimsxUTlFmfq0smpeN7jDVfcd9mDrVjEL?=
 =?us-ascii?Q?NKN/uo/DKYQjeafoCjx/bOdlwYeZXLpGjNjk112mPtgHY0dyVCwoV4sCp8OU?=
 =?us-ascii?Q?LVGwqX1F67ibIiUFdfYDUCYHMcCYYvWfBU5G8hdyjY9Qsl+WQYLp5vBc+nN1?=
 =?us-ascii?Q?EoxEw6MufjA2uWDNkjDBxih/rLHPyBvRmTiI3F5n5oIw5ouvEm3/FANIUL9Z?=
 =?us-ascii?Q?XlBJNvYpMzqJ3Dy0PTz8nHr5UrxX8Y8qdK0QMLPlA0CIzk4OMTVSbef/P58i?=
 =?us-ascii?Q?s3vlkuAvV6pydijQ/4BNL0kpRQpYFeylNRvzCuNuuaCj9kGhAp9cnKslQ/BP?=
 =?us-ascii?Q?WpRFFz4e0yxJdVPzkXHTnEY9Dabg9bOpQoKuJT8otCuK8UFGc7j3ByALN9SA?=
 =?us-ascii?Q?XUYs9QtAElRMLeFB0NcB9PBG+vuRluWDWEkVOuwRy3OSe1ISuav7hEIOZKGK?=
 =?us-ascii?Q?otbGfnPABW3qzVpQ/jKtL37/sLnJofNF8R+kNuQXmGPIHT9qh/d2YMrLr83B?=
 =?us-ascii?Q?3v+7vlFpHAY8rSSPo+BRPKTOF84sm36B0oQ4gXPZomhHEcGvFlaK6jFk7xW5?=
 =?us-ascii?Q?y8oTtP0L7+/SMpQvv6IZf2Aa6C/TWMe/AAKvhtEF9ze2NGL1vzRqBUD0MIpW?=
 =?us-ascii?Q?gz5V4eLcrhc6C1zZ1zs2/O3W3t2mXlH7xg4Nr1ZBXCp99eaKKVYQXr9RW5MH?=
 =?us-ascii?Q?+QvS7Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ce6K6UbwKBiLFg1lsuqnM135yFB/jvSo/XkyIyxS/ZSGZFAjsfsA852N/SZOSLZ4+nuoKlN+Qso+Eku0mehWsTYL3QyJVwfdg1IeZz6OZZwgi2oHa1Bu5JVCcgzfiIMJGA+mTY7wZ3JcZthoLIqYG6RH6D5t9iRxAQ7k6QikcY/ZnZFY1AJ4ZrIOn7cU6GN0LT3xhRmViPdPc8hhpvEjkfkl85zLv1c5ZYY5LDM4LxFlzZ+jIQfjghl9MlJnOzKtD5RBF+A15x4Ba60nI1YWIDJCejXkH7gT2aoTa/LCekxOFF6TGNejthc5Qb6M9RANmWhhNwJnyY3hE/60bQN4cAJy0qrMFSyZFu+b161tuhbt0AWvbHWQ5etUK5gp4owv2JuoX8ApD97eYx/9rgZvI2jgVZ8W8YThh5ytmRXUAMC5WKHOcTmNAPaq4H3fXUhoA553MlPeyYphNa3Y/vLslJnBX2aCtFzXBOam2gDEpu7UIyWGvLd9vVzZ3Axy1d4ySgxbmVgfIHrBAHFimOIlBw2WeUF2KdaZ+E9qbsvbnNgrAQ33AzqmdU51qdzVU+3LNbQCenpVjwHJm+zB3lFgelMaZGLDj+UYzN1lfEDx4zo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b24cbe4-2d1c-4555-6e6b-08de3274103a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 13:58:40.3832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 71ECR2i7xsUW03tMEIqSs+c3HFeQhm/62utSHREAPEUB0sMiHpGT/kwHtfoII0fAzKpE3WS5Xy0+HimRiHN7/EfnEL6Yg+36yMJ3RdI2z4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4968
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-03_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 mlxlogscore=460 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512030111
X-Authority-Analysis: v=2.4 cv=ZfgQ98VA c=1 sm=1 tr=0 ts=69304215 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Me4g3RfZk951Y51u58wA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12098
X-Proofpoint-ORIG-GUID: OUqfI71jS1JzozaLIvpn4kVNjtlrnyBE
X-Proofpoint-GUID: OUqfI71jS1JzozaLIvpn4kVNjtlrnyBE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAzMDExMSBTYWx0ZWRfX2LEYrDsu7J9G
 lhwDBWrwHE2h+xp0WpS/VVtHa/iDARHMoiME5UaBktXFW/WcCZBDJa0kaDAs7i43eKiA8RJkqKy
 QUb94iFnfuz2+OVyRaH/9NHi79hNLfimsK8FkMAYeUK528rhNrlFpXdz0Kw+Aw5eg9/jrudEDzx
 5uv/gfc1qaXo0VJcFxG3JPBRtkdvVqFLEBI3szlS5tDLiyUpoNuxEfEeA7yeTl54eJzxRaiHsOd
 3kn0nv0OITX02XsFdEYw/mukWJQvWdZJhsJQ5rmO2aUb6gozxpKdQfWsL5p4/7+tMotgMrfxIij
 C2grudhpiDmcti+YMbshid4irFmtkE76FRnWwV328or4BpTWOU3d9p8rBmqvR/MukVHAJBXlPnl
 O1k0XpqxwL69P3HlP7Gv+ztbsppieXhwwC6YeC71epbyM5OxcX0=
X-Rspamd-Queue-Id: A70B440003
X-Rspamd-Server: rspam02
X-Stat-Signature: 54q16ij7nqbbfph8ungizzfi9kshni3f
X-Rspam-User: 
X-HE-Tag: 1764770331-26032
X-HE-Meta: U2FsdGVkX18aCq0AMQ4EcvGEbH7nBZgHnPVrDUTUOlTix38cG46s/alquxlDDSq3ViSlgcx97BztqwMFe6CaJ7rtyeksn1ElhdZ67hg14z5oTKaG7GA3MKFb53zDRI/sNhTra7OTK2aeRdTj5nz6lxS0pNDLg/Ts1FRccptt79EnXsJwbgK53ziAi6oQQKWY3KlhUkmELY1VpR3ghaUg9kOp+MF1DpUfc64bV1+EBHso55Z2acbq01dgeoK9aK5viVgRl+o+kRXYUhJ3thIbfqsEf/W1cU0JpWjRHRJEibELu8vi70h3hI/yledVm1prSj/Ie3b4STdGl05sJqONqNDc8qqrDhe4tumZrFbJvg/VVZVPHRMqNLWw06YIpcTWXswnWHrF61//667Iq4qUenF8fvPHEPBotScqu2DQKaOSoQhtsg/L4DxNeJGOeDDEjm6zP7kUcCqMzo/u9BHfL3wxUOYGWnkrwod8wwk5JWi22rtpLNla1W2jJkJdwDEvXisLjx7kSZ4EgOGgMi91e5VHJuvcqxHO1wuL8si77AwC6ubgQxn/y8nn5El/fVY4OwdBgeVGZm3/8hOihUMGbd0px6nKkUdKM+wy27wNUt0rNNyiV4TBuJuViMP8Jl69qIKtvgAnFMd/u16ACYKev7ltG7WH42g/6xrhxV0byrqiQvzJ3VvIKdYu+uWT31V/sbxDqpwKn3bo4ES1z18s4WXTlmugp2b/iq1bq9wMjnjOWJg8g57x4nyCdU2yHDbmSLRQkkmSsfAZ/MPCD69ohcrwgJnQqotp+gY+MRYmY24yGIhHXhuLuD/VSL4e0dB2idiy/9/+ODqYE8hGd0hKkyV4bYdORt337+cqLlLfBE7E0pTvC4z861S58NPYDfo4yN3V5EFTZ0hHklTDAhS7PVLytvJl9l7yVkjp94IfgM51mPFQP3e0ZVzIDIl6aa2TRaVtSUZFLFoF9khreW2
 bpIvuPmK
 M87eXpEe8Lw8Ba/LithQda+Rdkc/uy8bSuxAQRVOrlLh1TfPsGoARsmI+10zyoTxeot39wwFh+6ptRtiYizjsBa1qfm56IbTYYwoCOQAKZHl+J4kD9+30zhobJ2O8LlpTMWllExV0UDYRfssjJ0K7xFenT/GXs8FEz+2YfYE6DvLgYLzNlFjQ5GH2HQnFKZxPZscMwJ1n0poPupvtOb+v9394EU/WlldU3QMpWXFt56SQJBTYILRbDRhDtu2h7NRSHxRXtBDjyab7+XxogtiWU2vjCx+UHTyaLwiz/FYRMi9ccJt5cffsM+RypgXX8EyfHqp3fFxPvre3kFejCIUuB5sbTi5FBMbroBNI2vPfDB6RYiKseQ7sPWjR69PEha/EgQPWHdM748dxoHXFgmubpJ5K52J7Tb6yUPlb39veGcEjkku2OipHjgSNuQI+j3J7c+Br7BwLlU68SovwHnJ8mbzWx+dZhnGox2QKH8TVmlxZGRkBQaDzXQqyR/s/6KfpWYRGxin5M2VefxJrhVCO7cOW1M6ykpeN0lzEf4ja8+s7QGaCCSl94KvAW+6wmqMGVZSIpRVT0KB8ICaK1kuYQQ8o5zJYPRcpCcFR0/UgyTpfgD9Fq08hz4Lnog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry I didn't say at the time - thanks, I do plan to look through this at
some point :)

Cheers, Lorenzo

On Thu, Nov 06, 2025 at 04:28:47PM -0500, Luiz Capitulino wrote:
> Today, if an architecture implements has_transparent_hugepage() and the CPU
> lacks support for PMD-sized pages, the THP code disables all THP, including
> mTHP support. In addition, the kernel lacks a well defined API to check for
> PMD-sized page support. It currently relies on has_transparent_hugepage()
> and thp_disabled_by_hw(), but they are not well defined and are tied to
> THP support.
>
> This series addresses both issues by introducing a new well defined API
> to query PMD-sized page support: pgtable_has_pmd_leaves(). Using this
> new helper, we ensure that mTHP remains enabled even when the
> architecture or CPU doesn't support PMD-sized pages.
>
> An important detail is that we need to do the same refactoring for
> has_transparent_pud_hugepage(). I actually have patches for this one
> too, I'm not including them here because I want to get some initial
> feedback on the general approach first (and maybe it's better to
> do that in a separate series).
>
> Thanks to David Hildenbrand for suggesting this improvement and for
> providing guidance (all bugs and misconcentpions are mine).
>
> Luiz Capitulino (10):
>   docs: tmpfs: remove implementation detail reference
>   mm: introduce pgtable_has_pmd_leaves()
>   drivers: dax: use pgtable_has_pmd_leaves()
>   drivers: i915 selftest: use pgtable_has_pmd_leaves()
>   drivers: nvdimm: use pgtable_has_pmd_leaves()
>   mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
>   treewide: rename has_transparent_hugepage() to arch_has_pmd_leaves()
>   mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
>   mm: thp: always enable mTHP support
>   mm: thp: x86: cleanup PSE feature bit usage
>
>  Documentation/filesystems/tmpfs.rst           |  5 ++---
>  arch/mips/include/asm/pgtable.h               |  4 ++--
>  arch/mips/mm/tlb-r4k.c                        |  4 ++--
>  arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>  arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>  arch/powerpc/include/asm/book3s/64/pgtable.h  | 10 +++++-----
>  arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
>  arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
>  arch/s390/include/asm/pgtable.h               |  4 ++--
>  arch/x86/include/asm/pgtable.h                |  6 ------
>  arch/x86/include/asm/pgtable_32.h             |  6 ++++++
>  drivers/dax/dax-private.h                     |  2 +-
>  .../gpu/drm/i915/gem/selftests/huge_pages.c   |  2 +-
>  drivers/nvdimm/pfn_devs.c                     |  4 ++--
>  include/linux/huge_mm.h                       |  7 -------
>  include/linux/pgtable.h                       | 14 +++++++++++--
>  mm/debug_vm_pgtable.c                         | 20 +++++++++----------
>  mm/huge_memory.c                              | 13 ++++++------
>  mm/memory.c                                   | 12 ++++++++++-
>  mm/shmem.c                                    |  8 ++++----
>  20 files changed, 72 insertions(+), 59 deletions(-)
>
> --
> 2.51.1
>

