Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66545D61033
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 17:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A736B0088; Thu, 29 Jan 2026 12:10:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F88D6B0089; Thu, 29 Jan 2026 12:10:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AF696B0092; Thu, 29 Jan 2026 12:10:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5980D6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:10:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14074B7285
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:10:23 +0000 (UTC)
X-FDA: 84385639926.11.62523FB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id A27FE1C0006
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:10:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dvF+cXhk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GxA+g1cd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769706619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNvd2otFDKTLY/7yn6/9/LlfPxzOIIzApoXg2L11Zw0=;
	b=DHATz6mAKJLibUESScBlFJIiHeke9tJ2hth3W9wdXknR/HgGs9LfXEsfObBjuchUHx1DnH
	zR8piwP9ZiVcZVZUqYW8nTG7wdEv6tLsEIjFp19X20VU0/ltYwOnE/gNUca5WDuYAYCtUi
	dClZ/qjWfEOQZKNtztw7eVdaI+yar0o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769706619; a=rsa-sha256;
	cv=pass;
	b=qp3wiUK0kyurBV3l2tVMxKwMs2kNkxQClL6o7rDZg7r2QymJBrdXNYF6rsVLN6Q6crgDZM
	hKLO0BR2TTZiWVGnlozMatsS6NnZ1kBOApHveOqFT3Wm062r33cCgX5EgMMXF8/vQtYOOJ
	KLFDFWPZLGsoFtciTtL+zTlGAK+kPSQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dvF+cXhk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GxA+g1cd;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60TDgLOI367903;
	Thu, 29 Jan 2026 17:09:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vNvd2otFDKTLY/7yn6
	/9/LlfPxzOIIzApoXg2L11Zw0=; b=dvF+cXhkV4seURp56P7QDdv0Lo8qbibJH9
	l1NddR/SSURyABRNwBjOLpP7OHzbgaJvLE+L/kVkQVU8vdkqMoETnMcxHtvznPJS
	9zduZgzwWb/fA1fBXPDtpC/EjORWrzsYtX0Dm1DMlaEPyHTMShw2vw6BNBKkaZe0
	o7iRFlxHa5M+gYkfM09S8gCQ2okUuFTf+XqvwxXovMXUIq3SX+prlAS6zxZAo7jw
	vVhD9TGYlbogT2nuaci+f4SYTPQ4QLrJKdPDkY+h9GHggItqMsoGgBwcOYoIdM40
	ccw/nguv44ZEVHi2gNFaxA5QHcFBM8HftE1V3vVkDP9cTUR2Qd1Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by378kqgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 17:09:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60TG2Fp0035453;
	Thu, 29 Jan 2026 17:09:56 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012045.outbound.protection.outlook.com [52.101.43.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhcjvyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 17:09:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FzSw2a372gcuamwitjuC+E+xwEPfUdzZCRghHOkPiSunxShAjKDvRACHB5cBr/pntGt7OTH1b8/Homen6MAZdTbC3fukvAhOQHYW8Ipw5+F3kdtvycqJamrHqP/dRcATNF+wcW5hjskiV3oGfCHrZMLr3z6IhmLcsVpMMBkbh14VIbpL4EmpXxqboEqfKXEhL2fm4ZXYpWOBxfzSqioT0HJJFwLQWrOTwsnCnOSC6FZUVMQRc4aE6mLf0RxPBOodkdAyF7bxA3wW0ecnqdSi7kRp5sEtRf/z601l9olkoufuwVJwT0/4tUy+VE5aeIrDJ8IrKoecJoLNSVhoY3HSYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vNvd2otFDKTLY/7yn6/9/LlfPxzOIIzApoXg2L11Zw0=;
 b=kjq1+/vs1fhOdEbyM53CleZOaZnEhtkkr9juw9j6PeYfvQODrkt0Urf1nEe/fpmal7LHl6jfyVpaKlmCDbWsXjUzFlVBoaqM9Rd/4m6NDb0knmwCm3L2akQJicYR6ygObJkq1BO6BYae6/XwOy+qwbIURhXjEotGWhKnyBVAhFaud+1AkvfR5ezSe/aco8Y5BmBwU8/Uqq0mprtIaCpBIrWTfMdxwAjt6/oNhjcRHNj6em9Ukv59Th096e3rrwSshiKv8HPCujpA3f+4lpIjZHScBwKMEIo3KUDUkHI1hVJO5JT3B9OB4As8PoJMxdWg9UZ4q8AghT9+ysJXF+/eGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vNvd2otFDKTLY/7yn6/9/LlfPxzOIIzApoXg2L11Zw0=;
 b=GxA+g1cd1DD88jTYeADx/qwJVS1BHGOoSRqklKgTJs/cuuHJ0KnxR0R86xN05Esx82Rgo+M9YcvNWk1YwtRVtLuvAyagavAYGuucXGmJCH7ZKJ5LJXk60e52Fb7cNriXdh57EAIdUkOmI7AR1Bl5Tsyz2tvl586QXTv+xmtYKzc=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB6832.namprd10.prod.outlook.com (2603:10b6:208:424::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Thu, 29 Jan
 2026 17:09:54 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 29 Jan 2026
 17:09:53 +0000
Date: Thu, 29 Jan 2026 17:09:51 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Paul Moore <paul@paul-moore.com>, linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        john.johansen@canonical.com, zohar@linux.ibm.com,
        roberto.sassu@huawei.com, wufan@kernel.org, mic@digikod.net,
        gnoack@google.com, kees@kernel.org, mortonm@chromium.org,
        casey@schaufler-ca.com, penguin-kernel@i-love.sakura.ne.jp,
        nicolas.bouchinet@oss.cyber.gouv.fr, xiujianfeng@huawei.com,
        linux-mm <linux-mm@kvack.org>, David Hildenbrand <david@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 10/11] lsm: consolidate all of the LSM framework
 initcalls
Message-ID: <01cb28cb-56b7-4862-bf27-07e4bf17115e@lucifer.local>
References: <20251017202456.484010-36-paul@paul-moore.com>
 <20251017204815.505363-12-paul@paul-moore.com>
 <20251017204815.505363-21-paul@paul-moore.com>
 <0146e385-935b-4f66-9e6d-51bb47ae4bdc@lucifer.local>
 <14638978-b133-457a-ae9c-31ba54e3964c@lucifer.local>
 <74286aca-a565-489f-ad2c-886c650ea2bc@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74286aca-a565-489f-ad2c-886c650ea2bc@suse.cz>
X-ClientProxiedBy: LO2P265CA0483.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::8) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB6832:EE_
X-MS-Office365-Filtering-Correlation-Id: 181e9813-eb47-4b80-4b06-08de5f593831
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZOgU4K263IjcEu85RxPd1QeqDlyGBhoRZARA/Zhk048pHf1z5vlsb4d4cctg?=
 =?us-ascii?Q?1P6u/Br6KxyItIU4py+nGPxb+N0hpyFKUeksbBPO1nqnjHoux+xge2iNPyAK?=
 =?us-ascii?Q?Tec4UAoh57TvjMMaumvgBYrm5py66af5Kg4nRqHXfYd7z491FJD0cW1F3COJ?=
 =?us-ascii?Q?W8Vb61Eki6bW4Dkjvm+juZSHl3/yoFvWR2CTRojXN5ZJH0UkyednaouHrmJm?=
 =?us-ascii?Q?2iwlxWqSChFqYnnSCAbIRZTHSdYnZeX2mJigUK+C0JtMFk862tH8t3QySVOK?=
 =?us-ascii?Q?uFz07Pe493cLTGuyTkzOoVe8Wj/kf7Pz8Os+wee4pqRZR65mhxi4mJM7WSJz?=
 =?us-ascii?Q?PCcy+ADQyRhrnGNjmHjmTDuJbz332O77eAfJFDVKAKVk8o/DnxRK8B/EWoDS?=
 =?us-ascii?Q?Q3Ve13mN1AJ7WLfTW+htJqmV/vf33K9najXIz2l/K88RBv5mRXVEZUmLEOW6?=
 =?us-ascii?Q?T5T2w57QsPEfn7p7uqqBqyOXRFwz5OnT5gZsmkG4p9VwtNStjXuUhvTOD2tg?=
 =?us-ascii?Q?vbCiB0ldasOQxGU9gPJqNSC6u0z4VCPOa5d2Y1MwWIfBRxasX3zROXOWnLs2?=
 =?us-ascii?Q?S4ZyQXaLrmackSEmqCwqiCAA739TIOZgKwVq8oSFDz3CNCDRuITJT0nFpW+x?=
 =?us-ascii?Q?b9mm6K0KYCCCQL9E7RNq5QDD5mAYagvzhOw9inhjaxZJ70ZE+eMBHCERNR6b?=
 =?us-ascii?Q?4uhTB/bSM5SfUseM4G4u1QtyGN2CI7t65l7l74MFl8RS0Tp6kS2KuGbLclx9?=
 =?us-ascii?Q?oDMbUbFgWkbEy9Yje3fceVmXm4tu8UC586Kq1iAe6zya+A7P8HAGfuuNEwtf?=
 =?us-ascii?Q?1PSvUYKnuv3LoTDY7jGFMRf+Bh8upDZsmObrPZ8F4iMnzxCLkTHgJ1D118Kr?=
 =?us-ascii?Q?i8xikVI2c2d4MmYYAVC+M1fi7yaJh04dy+hLTSnQbXb+up2m39myAL80aVtm?=
 =?us-ascii?Q?9IwfgayxYyqLHGrA8Q1KFQ6q5/r9DUbaMRxRaeN1xED47cVSWGclM1oxwiea?=
 =?us-ascii?Q?wruqDJVOJTGyscuKUp8isQ5q3x8OFYj1dbq0d/dz/WcTFYVvYgHAm3RSyp0/?=
 =?us-ascii?Q?uPs+SRpshoGUmYvw8xJq+ogYDUlQOKAuwjLcvHOwpCD+J2y5tB4/82ajS2zE?=
 =?us-ascii?Q?DZV7ElLzPzaGxL3aKBSZEntr0V/54q2uW8Oq7IVcDSUFYSREBziBiLodsGHf?=
 =?us-ascii?Q?wI8furVmSIQoj6dcUUG+lqpCJR2Fbc5V0e0uAdBsq7JAag7P6CsaDSvyzug5?=
 =?us-ascii?Q?6lLKwMjC7jOXUsIqCmmDf3DpQoyPij6z2QVXIrt2Cr/7RSPm47ZFu9ryCMlo?=
 =?us-ascii?Q?nsh0GRFX8tQfqOQQnWs+cteQFU1WPUVlFQkxhXRjITxrLLe9HgBelzmStz9N?=
 =?us-ascii?Q?7VnbGk5R80lSvH0T3rR0+D6/nY7PLQIRCRCCwEK1YR2aJ/c4tiAHTNdhX6ZX?=
 =?us-ascii?Q?iOVkY+n1iNz0Cth7P0bcJic9qTtdnjNjGbRk7/KmPmKGD6GkbDw5zzEBvpIf?=
 =?us-ascii?Q?WlyYPqi1WcoCoA9gRR+caTRAfek/bplZOfW6ARXgansvg9JOi99p/3L/MR7m?=
 =?us-ascii?Q?RZ1sdgOio/bX5Bez3+Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LEaz1qFrtVNUt2fmeAWbOTolDL7qqxe6F7lXAcFh4VtjG4kYo/ZYB7XmWvd3?=
 =?us-ascii?Q?eMHVrIFO/YuAudPyepfmuvfu/g6NZnMz7KdJUIpb2mik0hpaMBorEPKMENe4?=
 =?us-ascii?Q?pcBF3NLG5N3eOf2gDjiO5nXahIDm4SL3cVUaW0pbzstZvKzRpYP8zZzuhl8c?=
 =?us-ascii?Q?5ssi9aPSwUJAF2ffGBD18ESUnrVBghoyHZ4064tpyAEEvgn7fCDkf/fD1OrC?=
 =?us-ascii?Q?nW746DWnApIJAV3arjNv6nv9Rv5r2YgMyFHkRfpt2GHNupb+VhDFuvyqv3GT?=
 =?us-ascii?Q?gFwUNVWN54vjA9j96apv+jn7M7GBrbGFWNvCRxuiVtftYm/33ONgxqfz6nL7?=
 =?us-ascii?Q?2jIw9D7hrfmSFUmFQe2R6BfclAsl/vSgLeofBg6d3mgRGkMcKwUjeq7pPCsS?=
 =?us-ascii?Q?8Hxl+krvBCD9WWLIJhpLdOnJ3puQ98UNLHn5T4Vl/x7FBak9zC+LFYAriWLf?=
 =?us-ascii?Q?PiwjPjoLmSW+u2QateWLLccGmtTEYe0Ah03DLyjqGbat7w+dPmrjqYy2MIp4?=
 =?us-ascii?Q?8yUQ/KFwV3XR6JP3sT9ilKbpEr59gjLjEW/RlYitGhv5s7EgzLUs4AtKwutA?=
 =?us-ascii?Q?2h8CC3rmM7goiJ4CqCFryEWVo9/FGbu1gKZvARKajwPVdhAeZgmIcj3CssLJ?=
 =?us-ascii?Q?+XYEYSLTCNz3rpiGSjVfS7/Yp+nqvxQrGXA5u3UTWNjKayks9jenXpYc/ASU?=
 =?us-ascii?Q?O+8mJcjLxUBxGiLt3R9FBs2paGYh8fNaphhNut9Nigy6EyDGwgx0y16yVwXt?=
 =?us-ascii?Q?OoKv7V50LFtP/P/V2vszZvE1C/CStl1OSpesjVNU1e1qaj/BZNUemUX2AYZE?=
 =?us-ascii?Q?lu/pn4FFc/wSg9WHrAn0JgGrXKFyUQ2dOG7CxaCkrNJfd49okKY6tJxsgDO9?=
 =?us-ascii?Q?9IlAVHr95BPiU8FhNias4rPgtOouwPhDoqf/VDdC0ETQnT2zdARWb8bziAZL?=
 =?us-ascii?Q?3da98vDdPvtiR0hTf1edlZAz9KQjtE8xsZFbdgfP5PBcH3UQ50pzVKhRvaMr?=
 =?us-ascii?Q?M4H2cuTB9663jy+QjUXSodSB+CE3lqikeUG8MnM0KqFulMuWPpJVauybH3Qz?=
 =?us-ascii?Q?X6oZMLz8kf/IyXiLCLsAJNSI/hpOAK+t9F0HQC/DNEyWY4FmfpkiFb9nnL7i?=
 =?us-ascii?Q?TtTqF/SzfJ6QH0tdHBDAsw27snpDFTWGwDieS+8BuKFtpRxTg22MUu6cOo/p?=
 =?us-ascii?Q?/VPJZSS8xiCi07WQ6Kxqb9A3nNhPt3NUB5tGESkMhtGZ+LbUgVY6phDRdJvT?=
 =?us-ascii?Q?bMLP3BKo6N0LpJucqIbnGQ0/z9lhnsKyLhVQdbinKSc2Tt85Ykfsx2cg6C00?=
 =?us-ascii?Q?EnMsIqpUJv/Eb3k+xGOxifaOWG2ZuPJbJLLZa1KHt2CEsfw8Q9vCttlAkSHb?=
 =?us-ascii?Q?PiidyFUzxYBvaRpz0bDIAo61+NYeNMV7OCH9xrcZnldk5JAo+F8XrcNUvwm4?=
 =?us-ascii?Q?tJpWzeuRkZ7yOjMTiGRduQ5FrUK21p9glbWRrSFlweAUOY9ly0ZM7JR3TH3d?=
 =?us-ascii?Q?NrnPYyaN8Objt2UGM7HBCIY782LYiWzWaNEs5oQJw/UhAeN+Xo/2qJ7iErze?=
 =?us-ascii?Q?UFnC2K1f/pkF9e328ipbSqUWDJdnAzIz7Lgw3OgIqmVd1mviY6V0GEIK+h4N?=
 =?us-ascii?Q?aa3zTk9thMs2B4P6Jg4G/cYKDQ+DQzisKfBf/lOPj/BHwOGtySDs+YsIyVPP?=
 =?us-ascii?Q?fiL0dzD9J66vinKoVxzRWgoWPcBJGdJOiYSwuFEEo+es205T2Ew45ILobbvZ?=
 =?us-ascii?Q?bfVQXSVUeHHXt7me7FIeZT4VNo+9QLs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ykeEoVS7iRN140svLvo8pbguZKsKJtmQDwIcGBOao/GlJ3xiF6tQjEF2iTvbiOgeoFkIvrLBzGICa+JXI9S5AkhB5+oO4bIINm9luuL/DXD4WOJynTdWoZeoHksfZspEWNb4nldbPECVpDA1gEppYXYOG63ZcvyCx1tNtxUXiPgzwCdsbeIbh7o3VBOliAOuTf0nRXLi8s/JeCK4dy1Nlh2J5IK+H7LnXZ6jgDQQxJUkcpDAQaJXsbrKA3+awBChrFEtZgYczyLopptsshbWQZRLERw2PvWs1toPNPzk6/Us46Lw8oh20SWoRQaLLs0j79bXXHonSNpsz8Y7bxPvKwfGpESmgBp4Ow4WI7UY6xjIdIvdLGRZFSPP5CfJ45hWOYSc+3YEuPFtfjjoTTQK6gYytCkiWqNVgenfRgolhP8svTUBdyooQ/NhT2xXMdPRLwuGtzRjlSnTkcicAFws4cjoyth+WihTCNiHpssA+rwqohaaP77TJ6k9RS91x4nm9mZJMrl6w5JOmsPtnmoMAc8VB8anD3XeLRqmww9AVKfiWmY7Gdt71YaUu9+zStzgGhiTQoqlifznYqnsVb8MSh8riFcc9uira0EmOZ24usc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 181e9813-eb47-4b80-4b06-08de5f593831
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 17:09:53.3492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NgYJpQq3AT35yYDDI5aAbI21w0rn5nV29f9LwGD2HkgufDbSZGFHHxTJlpvD2ia8pDBxGmZTnYvCkHir/gMUhHMhjp5ESgg0u3dJXnWtXOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6832
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=836
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601290120
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDEyMCBTYWx0ZWRfX9kFyYxfFzVyO
 tWIMv4rGWK3C/FHf4kIGZm+Cnc5R6+bv0ZWX43bj8VxAwl7QcxmNUxXO6mmVrN1+qkfby0xBjvf
 cyxoIdtkp+ou2ngvm+EigEZRprbbrMFnmdqvWJxT1OHWRuG58uBlAI4rlyFRNrcJCRfbFE1Sarq
 5UDrQ0b1d2F5JRAgiCV3PzEOwACBLfY4dmfyjduD7xgT3Wr8fv5ZynvOjUL4fRmUH9zDd7mnrsg
 gwBnZV7So+jQNoghItXmQpLbykEXh/f9nzrgtlT0A6TazSuilfxhrCVAm56cvor6JnEQ+BJzEhW
 5mxGIK5tx3BVvwUdV7U/Xg+tof+JanwU0cWXRwFFlfJ1qN0ErENSqe07db4Qb6wM1d4xQP9Qoi+
 vRgVe4Kcnprdwl3MTXpTQxZX/BrNSVBtQQDWnHDfPPvwLTguuRPe9P/9X1w84Qwiord0D515ffA
 5/xw/NIv7x4logNH68g==
X-Authority-Analysis: v=2.4 cv=a/o9NESF c=1 sm=1 tr=0 ts=697b9465 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=V0E6NdkUipxGV5Rk1rMA:9 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10
X-Proofpoint-GUID: Z4sQsCU8_iPTf7cPBgN_36_ObTYB7Cyq
X-Proofpoint-ORIG-GUID: Z4sQsCU8_iPTf7cPBgN_36_ObTYB7Cyq
X-Rspamd-Queue-Id: A27FE1C0006
X-Stat-Signature: tstyd14qb8n7rns78uoka4xg3ynp5nn8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769706619-966723
X-HE-Meta: U2FsdGVkX1923Wwa6zBPhnKafgo9j+OeFGagXYC07MV4rNAnE/vm0eNnO2YIvgh2pFZMtQbmcpvA01+pAr8PfqfH0hsff1EuBz/ypRXcSYC22zBGKv5lfqT5Q5EEWot4ZTKtYeNOlGfrv/eDkJgX3PPFfnps6dV83OKldBYhsk7Zl2lq3IbxfmrzeOXr95QLzd7QDEUVP7/qRK+QYFYNDfm5sSQ/hv1U2NMPJ0S9HviWldw5NoC198zoOQnectol5z+94dui9oLb+N7Crng15Z7Ttky3ug6I6iO1NO7a03eVySXA+hnUdyod0WNPiPfBt+PQw7FnLNXhWUY7xS7QTmAroRadntJPn/iJLp/BAdKEMkW8iXOWaKl02IgCIUEllQAcGsCZJvtouydgMZvAtq1JWl2Fb1NY4aSHUPHlCk7cwOyQXA/+iO1BmQ7t+qrRzGdrlWRxQjI7evHqEgeyHRJjoZfPgOGcalyeAtHFlQQLKMSGBJAXq/VqF6j/+EM1p89TjQ3tdHYWVL0exEqAL7Z+RYoi/CR5y+Q8QJ49yIICSbICtKl9MFKfpBgqECkbhgSH0ELdbYywn6PPEZn8Wq4p20HSr57SnhFkul0WCvLJZ4NmopSlF8F/HyVcdVBC0xo2HsWdOu/YfoaLnOjNTwFErJnhk7jcbVBtoHMcoTa1jXIIUGbKnMxFKgMcvke+l13A9AeMqhvdix88tLBwTjQN40khfLzBh5E2yAMXrj1HwbUL737wz8TzwZQWCwfkEOvPCswWbWG/kvoU6LQcuB7ZvK6CGCAfASUiY/NbqnYT1Y0Mja5ItKGZBKpGyGkqJsJAMNU2tWxiMCYvEskHzMBbRskQe1NT1j2q4uzBUiCbZRv29XxRNHxZSwKVBMXeLzcFabF8yTs2x2Fet9sQhCDM0BN3lC+TCPDQmMu8rQjbwq8EDONkhzq28c5I43yhpKu8z6jsXa0/Cx6MMSw
 9SDE7eAc
 picn9m9HJaDgZaALq4otReTI0g0jMTuueVLW72/yDceGAR5jw0OawvoSe3/sd88mHMefwH/ZupQAgb0GoweVZPNp0ktSf2hgwleMAoyn/XDpBbBIh3ZlpSVCK2sROThTvpiRZgrw4qL+BhmqJnPninN+LwSJlOjqrp2has0D+4UMnG4UuDfi3YE8VjQTs3aNp36qBN5PIv2WGspaRMleikXIYISPCN8gBZwEB/JZzRoKH9E6p/58g02Uo5GDwTQBDYIStrqEh5M6or4GecA41mQkUc7s4wqka5yaiaM7f3bAqtYacBBqpMSrdMNGtsSvBj7zIyQlVA9Y5yG1I1NBIT71zVtGVtDNWcetbbcFnYyk2Q/M7MCEsWvlw2ZZ/vw23WwmUe1ciBgvQwF6uUkdyLLp34XTmUG8pCP89sMy3qo4nc+L8pFg05tt+bt1Q1Cmy4pMnrUIBu9PDDthgB/iXRajVOYrjHVItluu7ESqo69Z/EpmrP35GrdFnLwalZWHx4KDNubDLJKHn7PtAeMJWcViAbZ1oqj4ADmeOi/PkK2Yv+lSQBRLFbGS/3kbjTvWyFnpfESCvt91ZY/VpHa5zTskdh7EgQe1zDT4O9wRDtj6F2flngtsykPkwqMvmHR+6FHSCyFGHRCI6ZDw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 06:02:00PM +0100, Vlastimil Babka wrote:
> Agreed, the mmap_min_addr should stay visible and applied unconditionally.
> AFAICS the only relation to SECURITY/LSM is whether CONFIG_LSM_MMAP_MIN_ADDR
> is used as an additional lower limit to both CONFIG_DEFAULT_MMAP_MIN_ADDR
> and the sysctl-written value?

Thanks, yeah we should probably actually move the non-LSM-relevant stuff
out to mm to be honest.

But that's future work, for an -rc8 hotfix we need to make the init of this
particular module not dependent on normal LSM initialisation, as horrid as
that is...

Cheers, Lorenzo

