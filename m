Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB1CC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41AAD6B0096; Thu, 28 Aug 2025 08:49:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A41E6B009D; Thu, 28 Aug 2025 08:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21DF46B0099; Thu, 28 Aug 2025 08:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 118376B0095
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:49:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD1F11A015A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:49:36 +0000 (UTC)
X-FDA: 83826147552.11.D2B3FE7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6575C120003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:49:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SZcB4LVq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gIw7DOGq;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756385373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJy2og2aEJ07vCMskJGSiwGw+VmkbjRtxxQPn7HDkwA=;
	b=7w0L7+wXQ5/EIWOpSLGgetkaoG1TVgpPGFjPcrbg8yKqtcX0RQJQkCArDkgRAQ2M1xclCm
	PSdcCuCPaPKWiwbXDDHOG1yo7cm2GrNgxxXkep/55rkNUEcoRG26QSINkCMgrGUbGmtMQL
	m+0OFim1f5zO/4hSbFO7P8Twh+JuzBI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SZcB4LVq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gIw7DOGq;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756385373; a=rsa-sha256;
	cv=pass;
	b=7t8QZHYB/mZF1Do/HFAtlKokcWeF/26JgLKCTSJeHI7Cz9lNzfSI4dDPFEklfoQB0n3VOE
	z1I1dCcBkSj7lM4GM9Et0SzyGvaxY5sAykghoB6evY6Vj1MBPCSkJmFflUgibdJ6NV3+Df
	YtW9WqBlKUa9lZwoghlSFh4PjwRHaxE=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SCiqQb005969;
	Thu, 28 Aug 2025 12:49:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PJy2og2aEJ07vCMskJGSiwGw+VmkbjRtxxQPn7HDkwA=; b=
	SZcB4LVqXj8UVSW4bI8S1UjDHJR/+5Ihat6ZM08CMSf9ZkaEIezmJcHHi3Q7jAPE
	4fdu0xt02w194D/MrPGTu4umal87xPj4h3coF2qjoBm79GM1APLSjyYSFH0EJmgH
	puN0cbOldaVdlBYiWIe957HbbeWE3eT3khFw901TY/jpORQI5mZ3SuuvQkjHzPKM
	rOfolAX8/pXp2dA9Li45hPA1/EUt5xHo0ASug1ZCHM9CVOXhYBprEVwjaeRN9oJO
	HC0cl0P9e2MNoFLRJS+5uywILVHYfQoN7pbGXLxdpm+qHlUkBQ1Ry2OlCbzcpmjj
	My8NvyUADN5L6/oIlVUctQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e28hbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 12:49:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SCjnXk005011;
	Thu, 28 Aug 2025 12:49:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bysx6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 12:49:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KudXPil+ECjsLoXSX+jemUBHf52GjpsQbOdLNgY8MBdzdKS2Qs0CzjeKzMexVzLjNKJuHOZ9ft4N95G830UVi914qG+bX9kB76pB9fk8KjyxJOmtGEWvgo3b5+XdfkpNQVPE7KPi5A8OpCCyyB163kEWXF1UKHxCYh88qgPE/ez50scPDCeHwV93h2iAVsIMGiDNzep+QMccNpsDJ6idll2+1vgvO92nSlxlgeetwG7iQco4YRI4BCoWWymkS6fVeEMJKeXveVk085WsjPAB3rkufbw8oxoBZ5vU8WAFUvtU8RHdVyezLmuqPf1rgyyw9Fi8OjpNX0tyO8SxdwcESQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJy2og2aEJ07vCMskJGSiwGw+VmkbjRtxxQPn7HDkwA=;
 b=dXAHXEHIWv9Nrb63BxsX037/QrUWhbNUUD4NzU4UtmF/y5Ke9ZBZ5lEs0acIpGhdH2EvWBxqsiD3yEomnI6MK3ziFWOPq/D4aBsA4l7ZG2zfRth1I7RMdERH9H1Vrhp3r7nxhJobLTYRr+9+1wrOWnAHdETn1wTcKRpopAUT+2nX9X0Raj34HatIGgmTONQwxF4+Wf5suMc+mFE/HXvHdRceaDf+inHojQgxV7TT97tzV+nzRDhE8zqCuah3p2hPZbFxPNsllRsMWJZbTV7VIDH2kDGBWF34tRgdolNv5lXwE+/f/Yr49nTcgKCYv07QZtJ55NQy5jb7jyBSoMx9IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJy2og2aEJ07vCMskJGSiwGw+VmkbjRtxxQPn7HDkwA=;
 b=gIw7DOGqGHo0tnO/ntKSnGIcQNMFBpNaJfHBgGnj9weZ71tugiMmopfRxYcxlB2FBAxenI77Bu5ePxj9wXI2ZfJqxcKTe14G17HBs1QQsEWu9DICQKzTVFf0U+Wrz6KPsFNPTJFkb/BqZ0c5TmpRjV6OrFv/O/koqw/OAircd+Y=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6227.namprd10.prod.outlook.com (2603:10b6:510:1f0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 12:49:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 12:49:14 +0000
Date: Thu, 28 Aug 2025 13:49:10 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add `const` to lots of pointer parameters
Message-ID: <bfccfd5b-6ec5-4eb8-8986-237d230c17ff@lucifer.local>
References: <20250827192233.447920-1-max.kellermann@ionos.com>
 <20250827144832.87d2f1692fe61325628710f4@linux-foundation.org>
 <74a33635-3348-4e70-8cdb-16307f839b79@lucifer.local>
 <CAKPOu+-0zuz-t22RmENiAT7SXTMyRVeHgkCrnLK-Xt-DDxHykQ@mail.gmail.com>
 <56d18767-8b3e-470d-ad60-781a6f17f9d4@lucifer.local>
 <CAKPOu+-PVcmnYq_xKCE2S1saJ_iW3xDK1B5k=DCttoTsSyBJmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKPOu+-PVcmnYq_xKCE2S1saJ_iW3xDK1B5k=DCttoTsSyBJmA@mail.gmail.com>
X-ClientProxiedBy: GV3P280CA0039.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:9::8)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6227:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bb66943-ed3d-4bad-9e54-08dde6314b37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWF6RDBnT2FqWFpBWjZiWE41Ui9td1NlS3RjZUpKaFBTQ1FXcmtZSnR6QzVV?=
 =?utf-8?B?ekRxOUozZlYzM1ZpSHFXa2pFTFBqek42RFBtWUVaM0VqRDV6M2JxSTd2RDBO?=
 =?utf-8?B?emdaYmNMVEErOFBBRm5xaklaQWdzRk1WR1pEVFhrOCtEbEFFV0YwQlJBNlpm?=
 =?utf-8?B?QUdtZEp5cThEcEdLMDBsbGRONG5mSWxia0NJL2t3eFJ3MlFGOUUvdG0yWWFK?=
 =?utf-8?B?SjE5M1VMMHkvTUEzbHNMTDdxcXBYclVROFkzMldYZ0hZLzNUUUx0TGNoUHJn?=
 =?utf-8?B?Y0xQUEhWM3NSUUNHV0NZdUFIMTd2WE5sMjd3V0cyVklrandpaHlJNHAyVzQ3?=
 =?utf-8?B?UDdFdmxnK0VaZ2FDOUhSemk2ZUVLSFZqVmNkYmkrYzVUNTc2Z3NrYk5kZDVj?=
 =?utf-8?B?ZC9TSGN1enM5bWFrbldBeG9CNjhaZFBFRE1XVlZ1Zk9qY1V3SXVaODN1MTdI?=
 =?utf-8?B?czFzdjVnN1kyUkoyR0NqR2hEUmQxcEdYQ1R1WEd3aE50TkxJeXcwOHlaOHRH?=
 =?utf-8?B?Q1RYS2pTMFZLbVc1NkF5bnBJTzJoU1k3aE9zbTZpOWlhRHI3bGRSNkJDSXBQ?=
 =?utf-8?B?RU9GZ3dDWmduUGZVQTI5VHZycko4Q3BjZjNQWWxIMEl4WUpZY2FlVExRNDRO?=
 =?utf-8?B?em84VVd1b0lUM1NWbGdWUWt3ZjR0ZkJ6UDlKWjI4cXNZT3lqUEZsaVltOXZ5?=
 =?utf-8?B?c2FseEhMUGtQaE1NV1NsbytWRkk3ZDJhaUh2Qndud0VuUlg0cUNvMytYRjFx?=
 =?utf-8?B?Vm90WlI4TUZqdlZoVGE4cUI5cGljd1d5ZVpkdnhETUx0RzJ4Y09MaUlTbHF4?=
 =?utf-8?B?cGcrUFo5ZmFLRzNoemtCdElBcTQ1dlk0NU1OQmFEamhwNHpOdytQSkMyWHRV?=
 =?utf-8?B?NUV5M0Fib3UrUXV0S2d6aUVzSDZuQTByMExNT2N3QWpocEZJdTFLZHIxZVhm?=
 =?utf-8?B?MFVKWUY5OVVTSFJ2a2ZZWkVFRm8xUDJnemJqZzd0S1N6UWlIUGZlbG1kQ09l?=
 =?utf-8?B?UWNpdUZ3Vkx6TVJWcmo0MTBEekRHMi8zd3ptTFBiUDJrNTc0RkNZczJGUENG?=
 =?utf-8?B?WWtVaFNBWTJsZStvN0QxdU5kYlNhTDVRQlhqMDc4Qkt0d0gwYVpyZFEwMFhK?=
 =?utf-8?B?TENXVUhzaTk2YmlTeEJBOHlPMHcvNnd2UXlXZHk3RklMQzBXMVdySDEzVXEx?=
 =?utf-8?B?SEwxUm04dHRKV3ZpOXcwMlRJSW9URzFKNWxqU200aEQwRkZSQkxSWitOZkNB?=
 =?utf-8?B?bGk5N1plUnZoU05xNHZ3U3Q1dmE0c3V4RzJ2Q2JiM2F1R2NydGJHNjdvUlhJ?=
 =?utf-8?B?czRaNkJBdHFGK1FKYTVWbGFjanNCNDVhVzVzeVVsb3gxSzlmYzgxTFI4akVa?=
 =?utf-8?B?bXJqWVdZeWZIalJUeDF6Qng5ZENlMktBTk9Ta2U4UGx4dlVZbVh6aUlsMlk4?=
 =?utf-8?B?cVJJQkdZeGt1K1h1OGMwZjVmOFJZVEJhYWNOZ2FnRlJsd0RXN3E1R1RhbWN0?=
 =?utf-8?B?N1dDSWpSTUZpeTZUNVRTN0tUOXdGT2U5VWNqakY3cGMzb3Y2T0FvYUV2Tm4x?=
 =?utf-8?B?UmtlV1JaanRhMGdlZ09vdHBqN2VLdkU5RUtBbDhiRmxnVVkvTU5MeEw4bmNz?=
 =?utf-8?B?R2lOemZ0RmZjbjJQbWh1SytvckZrY2xSNUc0bGd0SnVHMExydnNCSnZCWHJM?=
 =?utf-8?B?TzJuMFFZRWFQbE9UTTVCRGFWVk8rR3VHa3dIZVZzbWVHV1dkcE5zb1V1Mmxq?=
 =?utf-8?B?TUQ5MXNjSEdYK0dKa3BCZ1dWazBHNUZrMWNmREQybzduVkhKUHpqYUNjV1Vs?=
 =?utf-8?B?WGRXRWNRdmZ2WFg1Vm9XckNmWmUyaTNEM0dwb1lKeTFSZHB5a2tmUko1d2JV?=
 =?utf-8?B?Y2dwcExmQ2pJRWliZFZLMVNMNGx5bHJsSlhPbjExaS9ESVRLQjBlaEtmUk5Q?=
 =?utf-8?Q?4moMlGgfEB0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2o5MmhOYVBraEFBWTVqTm5IdEtQalkwRXFIM292b0c3VHoyMGZWSDNyWERm?=
 =?utf-8?B?cTg3S2crbkZDeGtldmtMaWhGSlhGZ1JKZTJRR1FKdXZQaXdJZkt0cm5abXI4?=
 =?utf-8?B?RzVCalIzLy9WOWNvYzJjZFN5SVRtOEpmR204Sm9LeElLdjZMdzBUUHhQbjFl?=
 =?utf-8?B?elhNYkRTNE82a2lPMWVwU3Nnb1dmTlp0M3QzZmRxN3lpVXpzZ0FDdWFIaCsr?=
 =?utf-8?B?U25mQXlFdC9qT1hTakJWQU5yNEo1R24rS3JXUHZBcVUwWURXcGYxc0hMdnN4?=
 =?utf-8?B?K1BNbnl1UGg5Zk9jempRc1ZpM1pPYkpZWm5POGQzV0RGdDlmRElybFdSMHNt?=
 =?utf-8?B?UktXVkppSjZjcXJuMmFIZWNzdkYyNjlNL1BVU05IblpRcDhjVnlnT3MrNStF?=
 =?utf-8?B?TVRLLzIyREo1cEZPNlppZnNlUXlma2oyQUwxVWlXTWNCUUsyeDNJaWFCL3R0?=
 =?utf-8?B?NkFJbE5BY1RmWU1rV2dRblJYcjZEajJiVzYvVDl3b0JLT0lDSGRvV0h5K2ky?=
 =?utf-8?B?TWdHT2cwRmd4ZCsva0FZS0ozQkdwRFRtS0VZRWI0TE1zQnYvOXA0elZaZlRm?=
 =?utf-8?B?TDZqWHVUajhDMVR6MWNjMFcwR3NHYmVEcjd0cEI4dXQranZhSlRCOGVBRjFV?=
 =?utf-8?B?VWpUdVNSZ1dCaTlEelo5NElsdllpOGVwWFl2TWxVMEduQkV0Mk5PYVUrMUNO?=
 =?utf-8?B?clMrR25IN3BkN3NEVnphcmp6L3BIekVvQ212T2Y2NTdybkliSUtYYXoyTHJw?=
 =?utf-8?B?TTBFMlE4TUJnS2lBNmgzN2M2VFNMOUdQTzdHNnNKWEhWSGRhT3FaTDRmK0hj?=
 =?utf-8?B?M2U3R0FUby9kUVNtRVlhZkoyOXE1UmhIV2pzNVM4ZmtmbHpQaGRkWjRQcXpT?=
 =?utf-8?B?STdmSkY0c2pBN09xdm4zNjY3ZHJOQzNRWkkxUnROWnNmWTRiYnZLaUJSRURR?=
 =?utf-8?B?QXd6Zm9zN2JDV1FjRUFGQ1MxUFF2WWVHVGNiQURqRExVYUh5Q1ZCcXdOK0dT?=
 =?utf-8?B?eEE5a21Db0tNUVl2NFRpNXJ3Qlg5N3JxbVUxOUJQQTFES1h2WWhjOGZjd01C?=
 =?utf-8?B?eEFPZkxBeHVwNERHcHFDRnBtMCsycDBZR1BjdnNXRUZqUkZuRzRpSG04SXhq?=
 =?utf-8?B?YWpHT0h1UGZMSzFmaDMyektlbW00azdQN0pxbWc3bXVyNlJiOXZqeC9Wd3Bv?=
 =?utf-8?B?ejZKS1Y2clRqWXV3dWZWQzZPSE9aTWpHdnltYXFFMGtHTklIa011eTRUTXhX?=
 =?utf-8?B?cmRobUhzeXNhWWxyZUVqRmhEN3YwNlRnTXJJNXhvL0I4VkJic2FBNTZvYnJa?=
 =?utf-8?B?OExXUFBMYW95NHlwRmFMNm9aYlpTdFNxR0pQdjZVWXJCNWU3bEVVVHdQM0hi?=
 =?utf-8?B?TjZFUERZUi9KQzFVc0NBNVRDMXoxcHFYWUZ4dkM4Yk9xSTV5L3NvTmdJeVBn?=
 =?utf-8?B?YVR2eGFSNWpVRWl0SGVLYTdyZDVCaEFSRUIrWkdzMlhJOHFwL1lSbzFSUVJU?=
 =?utf-8?B?NkdET3JvVzAzZUpzR3hnakwzeE5PemF3MDVqa0RJdnVOdUYyb1c5UjNnNjFO?=
 =?utf-8?B?d3FGaDRsR1pzLzljeERacDJQVnUzVkJqZzVxaUIwUVBjcE1RVkpqd0dCQTZt?=
 =?utf-8?B?ZVIwYWlRajVWbWlSOVRSYmN6cUJiK3B1bDlnYkQrMnF6bXRCcHVBMnN6YVd0?=
 =?utf-8?B?SndPNEsxcHUzbEZaTVBHR0VMRVdxK3AwbGw4R3FlY2hHMjFSRFRCVDRKMXBN?=
 =?utf-8?B?bXA4YkxmclRxdEZLRzQ0WjMxRFloTjg5dENQOUdYZG5ZZkdIOTVCcnQ3NUVv?=
 =?utf-8?B?K3lLWnNpaklSblhiQTZld3Y4ZXNyNEkrT20xNFgwRGRvR25SUTRSSGgwcTRE?=
 =?utf-8?B?TVRSajlrZUJ2WGl1dG5NcXBqS0RhK3RYYnVqTXpyV3VXZ21RUG1yRWE0dDBL?=
 =?utf-8?B?a0QzSlpKN1FpS2JxbGlDMnFQSkptam1Cb0k2TlhSeFh2SGw5T3VZVHNsQStk?=
 =?utf-8?B?bkhzcDFMM0dBZGFSTHZ2dWtDNFcxZWg2cWxLUWhGREtRUXBSNE41eEpBR1VJ?=
 =?utf-8?B?bWZCVFFGNXF1V1R0aGNMcUsyQXRXSkp0ekd6WUZiZ3pZV0RKbjNFRFJNQUkz?=
 =?utf-8?B?RGxJWWFYeG9lUWlTdVRwVnY3MVBJbVJ0VzlMV0RtRHpBWnRzcEkvemF4U1hC?=
 =?utf-8?B?Tnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ft17XrhHAKzoyfmLxxqeVCIGr7ShNHsGXUO0FnBQ+rxboGus53GThd5O2UzX8T3JsRhmTfSsufawaC/e7ajNNtTqfSjWgHtsRUOOOga6If/nfhMEhRRMONgyPIF16h+yA96yqPQKKpNKFtq+JFBdrGnIido8oaLGljCQRMRiuWbxz1sSbxm5IMsqo/9ftyukcQAqrHComyEWgDt3PNh+Cwh7az8IQkZYiPgMnB1+cRfIsgGgXtpsIOcZ1/LOrJ7yaSJ9SWZykUYuMhausfsn/1U/XMWBNTcr6JowRz0bMoR9Hrh7wctHI7w3YZKR6eEWko7z9zjPYVXoKxK5GYb5phVvuFzpfLty++5H7TvgFcw2VsK/oQrlDDn2zcuBAckXKdyydWFus6H92E7fIwwB4TE1e+vvyVn0xylMRQ+8DFJWGqLPVTTh231d2w9fCwYGMoUieYLD8ExR62f1zq680FemcN1V0fK9VtovkqMHAtkLxUIGUEpCYi96eiGy+BElp+qVqESDS9vSL1+kczeoFgLZaZ/Htoamn3azTkhwLxzlNPHm4gnQGCbKCQKxqGHV2J1Z0cIIqdQYw8xRXgN9mLj5EueVWe7oJMtDss6Scoc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bb66943-ed3d-4bad-9e54-08dde6314b37
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 12:49:14.6807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5c9dcUdFydVqdZ4o0qpIo/JkiOKhtGE3T6ZfFasSBxuORsYzodNdIRF0sLjiok98fMJql/HxsdBnV8fvwOsWJtZ7S3owKiftcCRaaa1Bw7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6227
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX2cThgWYgAH2t
 APsoUjFvJ22R+feog2dlaJQDsSULrFh8oY9i+/2Fbzm98LGXJBW/L53l+AlyPZ9whdnPqOvew/G
 LpHzlp/jbhWo0tH0jK4v9M2PJQa6lblpPiCIU4r6YV2g+fQYrDTPPhDljLm93uir3oYpZl5JEVd
 CDMVbiOfuU71smBdajpexzIffq/UIG18cGukE4khqysNJEU0ziva/zMWVkVzO1hxc93Zjop5EGc
 osWwUWQkgBzxAxDllb9cR2c7FGGHauyUILvbVy5sE5S1CUevFvktEmoRCNFdERA44jBhflrG/1Y
 oW0mkV93UFo/75RF9SapOPAyNOpUjwC5tHlJ/vX02n8Ub5MNLUn4DSzSSnATPEmdobP4/Xzq7wL
 Fy1tH6wf
X-Proofpoint-ORIG-GUID: Nznf732a-8EazqxLiG3QQ1DMUZGIIuQx
X-Proofpoint-GUID: Nznf732a-8EazqxLiG3QQ1DMUZGIIuQx
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b05057 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=AJyuq5oea8JSSyR7u5kA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Rspamd-Queue-Id: 6575C120003
X-Rspam-User: 
X-Stat-Signature: c4koem7134pdtg9rddet84jqhhq6ghfj
X-Rspamd-Server: rspam09
X-HE-Tag: 1756385373-448683
X-HE-Meta: U2FsdGVkX19v7OtwoBuRUQBnqcsfgNH2gTi2CCPfEiuUFOAJeciYyFzoq+DOOBVLqD8VcmFWAwNaqDrZFuTG5DAK+1CZ+FL44QUF7mcv+aEG4d8Y2EbRjetYJZORS/ksUX98R48hvamAu4/SaIbaKMH1UD0xGbUMAnUFHH8qxRGru78BZIw7T45jGkJ1oO5nAm5FKQHdr9TMKayQeSP5B7ztrRqvSJ6XfVjEcfH3ZbEuj4TmQtk091Oc/sKHnZ2OXWqQ7ckvhQrBn32eiPyWIwNKcDZlDmwefXaVtTagBtACOvskphpXxZ7Cv1+1Ns8EjwvfIljQZNtNT0YIkywXw9/pPrgKUAg10SIlUGN08FwMm9atTL/C1G/dntkhTJtEpiYcY5sTocojFRndZBexfV17LuCL483pZFnJHA0ZiOu5G02l2gszlH7u4FDCBfEYQyBbam1nBOwLqS27Ci3fWAbnb9C0nMgVYWc/2P7dGKeYTrfiu0JIAFV6KkejM6LbYT7VpDzG0l1jt2AZdemrkPeJhOt2g7fCTR0bcxznf9zpre3psqOJQ+hpoTiLua+/CGrb23ERqCK2B0jZsgGfq11dlOINOKTgnhCgUyH1lWTUsvyV9+FFUIYB68mDmoOspbTVzWrttyWKqFxpFU+hbsRZXUrQhOO7yL78Iy3uEhQlfgJIAxCkxHUtS33oTgR4iexMvDHgJ93BftIKybIloNHOPbUvruMLJz4HQBoj+O2wSDu0qBtHqdXanzRdtVwZIyRWVb1/rDbrmaNbkZK3r3FcVPK0Crq4LqcKRkECUosLtjPKfscB29hLeiYlbHDNNVypq8KFc92sP6uobBG+GkpVIgb0L9onOhpHV4U8syztNvzku6H8vwkYlTeaqr6nQhbrxfJir+rny2XU9xguuzrJH3wTN2p6vTXBrrnVPObgETeAmXJFU8bMcl/utS9oIbRism/LIv1OEtlt8Dy
 XcrmC9gB
 1S+90oyYUoOkkw3lTR9XAHWNbV4sXPwdwUbnnZaHCC5vH3r9A/kFVF54wIOTE0Lyvr/jMCugo4OwyIfrUKdBql4eOFJWVnm9lM5+bM1mGkjVdFH02dmEU3TT0cxfNOyouQq4Y1TEfsCGYiNWwXA397joVLrfD+fpFZwUyI0x82DwnYm9R0+ePqoipaNXXc3USve00EwU/zQ8sIM4SsJ6SLi5ubLrzIePGyic01eaT9Fgc1GNS3JJdi2Fhsk/dl2Em0h5k0jMPBJHZdXyqakq8wzG0YRQtaLB8he8Zab1ipRNeu27PIiLAf10+JOIFCHStMrXeaTwqL3eJMY1B2MfT5F3iEHDqXOnS5mw54vV9GnngOcyrpoHp8P/GInmIhO/oWW99fbL00zgYT1tu+wfYJFKFDR/6Cio5kAGt5l2XHBZA64VvB5Re7Z/lJjjfUDwM/Qz8U/muUy7YnB7dV8MHN7uK054R7oJSc1rvIcUp7+PP3Qigh9JZAFD5odP1qWzyw3o5yQIw2j8NvVgW430XO4dHJlnr8cITe3FJL39b7tB9rwoeKYVtR9HFTTHTAAqw3zT2qRjjUeskFFO9sqNfePIUOwvzkt/clAOMwTfcfxw1WhyjZa1J9xPgv8KyEpLyEaTOwb1a+8R0ywM5mdyhwud0v5N9Q1Wi6/MD9esEIjnyVP1s+AazFbbkeQQsKj5ho/PJx9zUDoEXkm2NYciUdNEoCqjFRexpLSVHfYqXtkXxVtP1ssZte4TiUdViGNKa+urc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 02:42:27PM +0200, Max Kellermann wrote:
> On Thu, Aug 28, 2025 at 2:35 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> > I'm talking about const parameter values.
>
> But that's not what my patch is about.

Perhaps not being clear - I mean making the pointers const as your patch does.

I made all the relevant points at the top level reply.

