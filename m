Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95D15CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDEAD6B009B; Thu, 28 May 2026 09:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8F706B009D; Thu, 28 May 2026 09:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F9B6B009F; Thu, 28 May 2026 09:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B82A6B009B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:17:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3406DA0865
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:17:03 +0000 (UTC)
X-FDA: 84816879126.01.E7EA60E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id A099912000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:16:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e3MOeoyt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ii540/z+";
	spf=pass (imf29.hostedemail.com: domain of chuck.lever@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=chuck.lever@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779974219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdvCiKu+Cp73EXx1TpcY3F2pqFhuMY1Kut1jJX6RhWs=;
	b=Jvb3pZ8ECShZ/0QAB6HVA+/o55uHJmupCGz9K8tbe/WkdLeHVl1xEe3z1lRSJcMV2DncLn
	XqiMzFVdKZzc7GAzVH68z/yKXb2PvbeW4VBfTtVhE34pIDxxOM6zswxJhnfOOA2AcOFbCu
	HwF6q7/y9iGsfhl6gUPtdXOGCX+wi+M=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e3MOeoyt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ii540/z+";
	spf=pass (imf29.hostedemail.com: domain of chuck.lever@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=chuck.lever@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779974219; a=rsa-sha256;
	cv=pass;
	b=EKxf7iuUQu4WfZXHiS0UK/8X/7XsEj+MddObwn/urACGJOoCfk99RmHwmuFRuQ5JGyz2OB
	BlrZWd9+VnxRa7kyMdWo2Y7tWyuVFhMC7drRar5zH6Imp1CGw70um2np3oYKWKIoZlCIpG
	A2ABOnfDYZVKaBxY92PKpcUJ6UfDn54=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RKiIB83778875;
	Thu, 28 May 2026 13:16:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qdvCiKu+Cp73EXx1TpcY3F2pqFhuMY1Kut1jJX6RhWs=; b=
	e3MOeoyt9reY6LA4faSVaq3Qzv90eUKTXl/lWlKK3qLWlQTzFjHXxeNlpngtsnLQ
	/O7fawELFMaskCCQ6Z9EFcVO8PfFOui9h4IM25SiOFdhEsc/TRD8mdxT+d29g/Ll
	o3GpuZujGQfGZL+qJwXxBAt5JwPdytEBl6k1kPgzMnMxnJ489GkH6+wkXZksUg1u
	DfGUNk1RbLrt6uCUG87HTEdp3nl9CjbV8fZIOGQbIe8TV7Du2cRWt4cmYsEKyVi9
	doLmkoYrxuxSGAYKRlpJ1HefrlGjuHFHSAEYnHhcSzEUsItQGDRHCTFTLVN25jFF
	v3NV3iykF1oLcbxqXKfyGA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ee7wpgwth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 May 2026 13:16:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64SDFLrb028558;
	Thu, 28 May 2026 13:16:41 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011056.outbound.protection.outlook.com [52.101.52.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4edjseyxas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 May 2026 13:16:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hSxokoK6qpMUcttmt7qoz/HV2D/EpXL/HyYT6JUNCtusimnPhmoHR7hhfnn8kGJ8v69iKZh1GFvihd+/M1Z1S0VG4mfnvVLumgoL+EyB/3/xZvLYGI7bPOPwr5u5K+mnLHQ3z5aoIbWbakekPwAi/YShd6ZJLL1AfYs8ccMfE5VVnnINVpJ1loQgbI4asP+xsNYLvaifmeIGL6DzwDMbQXDiyzvqezzLaKAWTD/tVEJpQ4BLsNUKRqlEKWYzxDht+3fcBHX2jTMnG+iUZWWIWyxzWbyc7fuoePBvgQ1Gw5ZBHyC2a+f905qw6TAJ7GhRnI7V0XjKRAFdrRr2kl11QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qdvCiKu+Cp73EXx1TpcY3F2pqFhuMY1Kut1jJX6RhWs=;
 b=pAX/Cttk2bz1ZlYQfkHrp/uA44viSLDOcVsZX9eN+5KO44hNh2A91zx9JsG/yJzS6GRPoI0BjB+FyadjjoKrm6/aQ4nQuaIA1iSpNCT4KhdjdrxUqaREOyEqq3E63EiHLka7B9gFod+Qrkfs90lwTgIhAMYydGFMKbtVsXytY94l/kG0WuQFphzdm48IBaIGYsyWsl43NKmxS9bQsKFfjNtBtfxErg74Xv9Ryura7t2Nd6sl0nMassUitaH8Qzt3bDD1EBVmWDSZV9EpyslokwzvlFFxB9aQh+m8FE2gZ1L0iRl9LFaHoWBqYUV/825JBn1H4u6P9ZhynNID0dOQCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdvCiKu+Cp73EXx1TpcY3F2pqFhuMY1Kut1jJX6RhWs=;
 b=ii540/z+aDNdd8kNrKcMzwPMNBfHy4Yt0LoZxyoLGINScLmW7X5tLpniNbWepp2l9LhQoMZATIhqzW/ncjNrcUzfcTm58kw27k1hK3tq1Q2Ia+rDY7SfMAL1kJfHxhtNzlTrxDtmxLegUZkBspU1TP7Wl7+jfLoaEO/U++YMIa8=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA3PR10MB8322.namprd10.prod.outlook.com (2603:10b6:208:576::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Thu, 28 May
 2026 13:16:38 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::4083:91ab:47a4:f244%3]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 13:16:38 +0000
Message-ID: <93abf217-12d5-43da-88fb-81fa1e70f0e1@oracle.com>
Date: Thu, 28 May 2026 09:16:36 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: revisiting alloc_pages_bulks semantics?
To: Christoph Hellwig <hch@lst.de>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-nfs@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20260527071816.GA17632@lst.de>
 <df21e8b0-a67b-4b71-8178-91221b596949@kernel.org>
 <20260527121920.GB6079@lst.de>
 <276835c4-78d4-411d-8097-93cdfb000648@oracle.com>
 <20260528090054.GA8376@lst.de>
From: Chuck Lever <chuck.lever@oracle.com>
Content-Language: en-US
In-Reply-To: <20260528090054.GA8376@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0226.namprd03.prod.outlook.com
 (2603:10b6:610:e7::21) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|IA3PR10MB8322:EE_
X-MS-Office365-Filtering-Correlation-Id: 34d85612-8827-4fff-3624-08debcbb59bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|3023799007|4143699003|5023799004|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	VtU5e8iPY5++EDxZWc5GUhgRLYj5O5NMHun8D42+EMarjGfhbj/3qtr0+xzZQFEQpCr5BtnSsiLxIPORxTWvocg5HHKhzjVtOCdSg0kM+N6whdO5Ac0g8BFuC7sZa7Q5AZ9kIiZVMVx9mDaFBFciMuPg2Ff+hKmaPNnDr1W5HqfDFoth4Yntmb17VOMcsBHysVjrgMVCeHbizk7YNdTkMJ4wrIXRUBD77t1VvCbZT9gVNB/Hig0+FMYscqMGBCHXjw01RgrFAGaxO185DK/Df8UDmzl3cM47d8rer8v9hYEWKoGK/UG7kYUoQTGfDuDGNVpvbVYxCikeFM2MvrOzgVOEsIb3bS2IkB/A0iEr8H3Qb4+SOaEkNur6PxE8oU9QKsYbJpxxDmhyti1Cd1U7Y13NJ8+qXA8p/2Ha2e6T8qWDw5Kg9DCcGUPSvwDSnwn7aQN2qSZBedSttL4daE5G5HtasncZXZetWk2ryDjPtQTGto6Y+Or/5GtPrpOUr0f3Dki/xYkPxZENmKBZDSXaMHr0himKtgSxxnPwMpZdYDm1CoRRh9DcJ8fVa8xllogRL/cWKPXGX1W0oeE4mSoTKAYzh1Yt0EbNaSiDLrGc4rf2Ha6Czh/grv2zg2ymz/xvarshQaSYFAScX+NrsvBFtRZ7nFOtxa1dT849r6GXYNBrmIMGH52uKBlI3bbJCTe6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(3023799007)(4143699003)(5023799004)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEFWTnExMHIrbi9Qdng1bU1PS0d0YkJscm9HSGZRb1lSTTB4bDRXM0JLVHo4?=
 =?utf-8?B?Uk94Ry9ENDhLMUtGUG1zMDNnRXd4RDN2VFlHMVRoaE1xK091Nll0SExnTXBX?=
 =?utf-8?B?OFZCWHVOeC82SlZDVmNPWEJFWCtSR25qOVhtK0tXMmVxS0h0dGQveGNCOTFE?=
 =?utf-8?B?ekVldzlwZ2JneGNFcU00Y2hZTklCbVZUNjNXQkh3Wk5PWG5Vak1sd1g2ZGpM?=
 =?utf-8?B?WjJzekhCNGNzK2RMaDl4clhJQmlFdW1PYndKRVlha29aR2ZMN3V3UFJ1ODZM?=
 =?utf-8?B?RFN2V2Z1c1hJNzNQbERNOXNQSk5IQW52V2NPM3lQbytKSFBla3hYUzVGay9m?=
 =?utf-8?B?M1dSc01TbVh5QlZueTVXbWhVZWk3MGlnelljOEFGTVNwWnZGUXNaUW4yVi9F?=
 =?utf-8?B?Q1RoZHNpU3NwU0V4azdwVGRSdGQvZDYyM29WQ0FLanNUNWY3dXpxbC9Ubncv?=
 =?utf-8?B?VUYzamFDYzB6WVZudk9NMkNhcitYYTNmTEdLbVRJNXBucnA1L1VFVGgrSzVB?=
 =?utf-8?B?TUFuQjZockN2bkppNVBadEgvdU9QZWNTNEFkbDNLaHMvcU13cjZ6LzFDNDVV?=
 =?utf-8?B?WEwwZFA1dnU4RFhWQld6SkpDc1NtMldibEt1RURyVisxZnJUZExGUlZCRFo3?=
 =?utf-8?B?L0g4N2FsbnJrZEN4a3VvaTRPYjJjdEFjaGdBMnc1R0pqcUczQ0c4NDZpckZp?=
 =?utf-8?B?K3ZuQnM3MVZqdHAxWFFUWGFHK0J1VFdwcXdHMVJodTM4M0NWSW1WNlFSTFkw?=
 =?utf-8?B?ajNzbHpKemd4VkMrWVlBSk5acVV3M1BEWHAwTlUrL3FVc0J0bHhodlFVMFlM?=
 =?utf-8?B?M05RNnk0NDFUWFJFZEJkVzRyWlJ3dHR2MXlqYkRRYkpjSnM5MDA4RlRiN05D?=
 =?utf-8?B?UWxDSXRxVi84YTMzQkpNTktBdk1sZVBoemFXbkJZTmRQMHNKVnZ0M0ZtT0xn?=
 =?utf-8?B?M2piNXkvOWtrZzVDcFpKZFdwdHQ3UWs1NVA2enFKT1ZtMk56QUNpRFVlcmpE?=
 =?utf-8?B?cnpHNGJBN0dRcFpDTlc2emFVWnpjcGNVOHhOS0VkNkU4cTBMZUZHNVNvZHFW?=
 =?utf-8?B?OGczdE9adjBZZ05JZ0JFaW1kREh0K0g5Zm9MdTNMRWk4TW52OFFRTnRtQTlu?=
 =?utf-8?B?MEg5aUZWaHFuWEpiWDlUY3IxMjlWVFZhV05vd083MFRpRnF1ODFMQmtqcW9k?=
 =?utf-8?B?VHk2c3h2TndQbm1DalJXdWMvY1kvSWVHcktsMDIvc08xd043RzFZNlUvVCs1?=
 =?utf-8?B?WUFXVEFXNFM4eHJXVk1jdFpXdENyWGpFZnVKZEFQdnNyYnRTVk1hN3JnSE1j?=
 =?utf-8?B?OGVTelJLMWdNeFNUWFRJVXZONGxDUmpCN1l5YStNMkxBRzhwTXQ3NWUzTnZH?=
 =?utf-8?B?ZXpqc3dXR3NsSm9qbFBrd3hZSmFIVHV6cGtNZXBqSHozNVduQUhrOHdrT0RM?=
 =?utf-8?B?MXRSMzJWWU1uMlNtaytKT1BWbjRRRXJVWk9jdFBBbmdhQk53aWNGdDc5RWZV?=
 =?utf-8?B?MU91eWp6c2dVOWsraUlKTkpaMkZMb0cvSnJqSzJVT29WUTF4Y0pnblV2WUFm?=
 =?utf-8?B?MWpGT2ZVWGJZYVVEeEZCWTdQTVdkaTJwZkJQTEhOcU1DWmxVaTB3RVR2TE1C?=
 =?utf-8?B?d3ZGU3RuU0QzMVhqUStndkhJVW9sb0pMQkRlZmJkVTN4eWd6RVdFUHJTRmVB?=
 =?utf-8?B?VTlTSUhUUDluem42ZnhYZlQvUUxLNEVwc0VRb29IVFJqWHVKdExVT3Q1Sm9i?=
 =?utf-8?B?YmNiQ3ZHYTlNQXlzNTFWSi9lOThZWnJZaENOSW5kVzlYaHdQUmdXeXg1MWcz?=
 =?utf-8?B?dnhQeXVjN1ZyS05ZMEk0M2hHeXZLTU5sTXRlV1MvTWkwbkNUU0tWWFhYakk2?=
 =?utf-8?B?cVhkMXZDMW0zcFVLQ2h3dFRGRGZ6ZXAwSFI4ZFNJVjljSzh5N2R4QUIwandE?=
 =?utf-8?B?VDUxV2Q4RzVJeFJMcmtnZzRFUTR6dHZYSDFiUCtza1BDVXRoNUtnVENmaU1H?=
 =?utf-8?B?S3RjZ3N6YUViNjFtVWZ5bjRXSkNuYVlOQXlhTTBIYmtuM3NMc1hGQzI1aVZB?=
 =?utf-8?B?Nk00Z1NpNi9HWG12ejhkc0hMWnd2RzhNOGlUWWk4SlJEOVR4elNicC9kazI5?=
 =?utf-8?B?NkMyYVRBOFlVcXAxcUhUUENJd21hTjFDRElvaEdiRGllcWxaVE9JZ1RjTEFC?=
 =?utf-8?B?Mzh4ZGM2NFFrWEpFYzd6YnNWa29TdkYvdzhtWVhyZGxSdFlUQWpOUGJOKzNw?=
 =?utf-8?B?aTk1aGE3dHZaZzc4TlRsVlplaUlhTW1sOXJpOE5DSWV1STNyQTV5dEhLMThx?=
 =?utf-8?B?SXJITnB3ZXc2K3dIWUhtWDVaQ1c3VHdlSEhDd2N6VzlMTUlTWFMzUT09?=
X-Exchange-RoutingPolicyChecked:
	CoC2L3i3h5ZwNRioBoi9WdPrksCJv9vWWTQN/t5qKz2v0dOx1EOhstJHAKekQTD6YRiFNonTlHW2LCRNeFN/4UoYU5iZIPXIlm4Fbm4ovCcE2k7QL89Ak2nOAmkeMeFlg/PEmugMmq0hVje5yu6Yt1apMs8QmEMbHEqW0TR6Mg31vWsqANpymf6CAV/bobqN6qS0/2Sv9FDDQ7PnsrSNjODA9kizN++GCkonHo5ksnOD6Q+EHHSLdA42Gyp+BYvoi3TUg7MqPLaoeRFsGqHWFPtiBiLV3+KBFncRgKDdoVBTU5CcTBod5Lcij+lA0zcccngSPlv6f8WBTICyYdzAzQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9w1q+rYXlDnLa7A81BD1yPydd1xwqS0XRh3lZiP1yjdMmHSf5KQkGWCwbdgY77OeHH5Xiemc0OLbVIcxsr/EFJJbxCFD23Yx1Y+Uxqx1M383LpCoLrlqNwDG6fRiFYuNMVVJyDNDKiJrYXjJYGxafo4kfDzX91mB8KGQ2FTeLcs3rkYH4dUxCYsF9lOZVEDpIz/VHviqACeqeqAmjw/59c/4Co1k04R5JuwPOTt/ogFoLCIL6OIO67+gzd6uQSU7o44tvGZzWO5oOs2ggdy9rJoJa/0ZmanZbxnhKJUayeT4L10krf++vrZXc1qa7pNNvsXywyl1VW0qSGtM9D9/LSIZ2B5aIyuEfEqFsdmpt1PnN0I2SeeDpWSbvkIEv+lNQf8gM4B7OpWYLMtS4ZgZMqG13yIZYzwaQ6umFrRi0KzvZ9PAozDOeq5H2YZqGuVfxg2xRJfXOYlmwP5pjnw/p8Z1FIroV9VqZn2nxyVeEeJXqceoQMVclMub7p5/NsCso9CSzWwvXnyNDByI7hMbUlJagOKyhFdpJwdcEVTZFlXVokzVN/YeVZd+t/hhGE2LryBrejy9NEnozekk/Y9bfZRv7qm/BfXdy6DlJXxB3VY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d85612-8827-4fff-3624-08debcbb59bf
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 13:16:38.4896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tgUMqdXLw9Vtn4+lw41mKkhuGIWaRromm0alNpYH9ndNEJcd/DzmRAXli6+WvQiVUadXGKSTZMK4jg8h1R8ImA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8322
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_03,2026-05-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605280134
X-Authority-Analysis: v=2.4 cv=c4Obhx9l c=1 sm=1 tr=0 ts=6a18403a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=6P8EpRH5kqvOs-FEdYgA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:13707
X-Proofpoint-GUID: khhox8WFUx00_Igz6mvbuKzKLPkcwX4i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI4MDEzNCBTYWx0ZWRfXwQYHYd2j2WZc
 SlDSoH9D/d9bbujPtVaqQFLBqK5HW8ROaXSCsjS4o+NuIX5lKzc2QLJBoMWhtES9yc9VFu8c/rv
 c2i0piGP9v1sHonwftM8DCO/tdUvJqfe2XU6R90zQ+cgAD+DY+pOjEQkgGHMhuN4I+Wz08QiUGm
 n3tl5THnBAA9RB0QEAOU8FMzdTcRFxLB6AQu84ngiV3YxFLskT9CN64OWd30Wynxkb9w9Q6LkhU
 d91Zpjxo0G7ZZcPWB8Va4/i0AssscrzHWLSBDvNEbbYOZN9HAQV6QE0X3a9PnauEJkxvTDORzOV
 MTveGTBXAjQIciDkJgmf4ZwFFtdsLWgzXru5lwgFnPcVOuII/wC/CF7yFJQuQYeNGKZ86j/dtCa
 xrPMff91naz6P0MJ4hhY71epZSaeqSPGTRfI1VI7FmRMncXr9kASt2c3ynsqeRXUTeDrOXMpM4c
 bv1VOQr5DluUuV1QWcTegbYNxn8CmeZsHdjYnrdM=
X-Proofpoint-ORIG-GUID: khhox8WFUx00_Igz6mvbuKzKLPkcwX4i
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A099912000C
X-Stat-Signature: sy9tkd7n48in966m61mbzog1hcez6gkh
X-HE-Tag: 1779974219-816947
X-HE-Meta: U2FsdGVkX18GLFsFqaYprQJPmXOEoc2LhFP36Og722+f84N5Lwih8K1V3NDdP4OuhHxelp7Zq3cRmn4P0ROGpMc3mH02L6reWVH7SOFJyluK+/ns0HKftC2L0fRTi6yAXLWDCIbPm4clygxj6gZd0DqbM1bOKCxSmTUyLo0uNl7L2ApOQ1YAOq2uDuSLQ00DfloZB9z6U1vwEJtnka5ThsjGV7NHbBKzcILgWKuY0kakzI8rT7aqaHOlWemOZjFtQ9+uvQd2GIAE2bkj55LD56rqimPdXHCcAZusXr0HI0G5ts7P+8skRsN2LBZDmB36cjJV/i5sirG4JLZZckcWy+gZlMzA0QNJ6GV/+sBCjjLTLs8WMZ1FDaRi86cRGoiaNeQ9ni0CsyXEDMfTKvcAbY17FiqYPnCDvRy3PTbK4CoFwtjAq9ry0eo+iy2NFL/7hg8u47xojlNTpOA7KLai5ErTx9yR4lKw3at5JDXeDq8fyADjNkxWSvac21/Ud5p6tGlKyAWxCZNG3+Cy7YXEY2Lo/jCjLUuCq3b0PpARq26zizRwu8O6wGATGK1ljv8fwC+wdTkhakW1a4SXlbfv2JuslbLMXLtUy180xpilcTaLmpW2WevHKN1RMQ8xXtWlFPPRssPXvDgm9b2IcJwjL4rnER8VSHTDanw+6YTm22/eWI6y8hlBzJch0qw5TCMoEbyb3scy70NAzeZric2eY+Fyzgbz9l2LZpU4HkoIJ6jWpUyqim1Zv/Ym8AO2wXkqdSk2XIwT2EaSXC3BdKAwb0TfCbASPIQYYDZgiNuG03CECpmAWiOISGlh73LwOQ7iaAFjkpJqx649rjfPkGB9f9ktyHhMncmAHPvDMos2gs4/ivPV5duXR/MMcheEJih2h20/fkgpC81QFWwrt0MqKquloaxpC3HebtJpv0EgQ7wtpx7HiaTgXRgYG1d9szd30y3z1AWAkGkzn+d3QSJ
 gHx7Ir6s
 GxQ/x0w6VtlQ9bPsCcfCN/uVhaEe+3KzJpglUcHvfP33N2/2eeeB8rR1cUIeaaha7I36OHovjzJ4NxAzoo19+aa1QZaf/vBCRbh36/RDKuGUvjJNkz9etzP+5wD7RvGP89aMDdho/K1/d4HkfLH0bRnQoXULHwuWBpb4+Em3vxI2c23CayN+dqfdSBXiXVyf9ign7ToVuZjYoEtZUrTJUXQrW2el8B0a3ZPLpskHtrw0gWgDIb6UQR70/2dNGsDbl47E3W7PmteBLFSO1J9Qp8zC7fULl1Tcc2Tk1kUafkG4qwGo46zE1sLLZMww2snvS2Cc8hx5Afz9RntGTcEI74QIJmDp7LRgjJsoslHYaXvd+NilTvH+jDoQseojvbQiL5Fm1Z546ys8vmncqfpBhjTlo17AThXOBmdvD7gvlSDpM4UUodUb0NJ1ICxqbfjNkUWPX3akKOJn0YdhavBSibhC0KOTE1UFfUm5JoaeLZTLqixQ1/yfRw69YzDBrw2mRGSNgeYzb/dQyIi6PwR36mW9fgPcukMzpFY/OBXVBaSPoFvx0Hodfan85rYqstcBHI+BW1Cbgdmc0kp7Qd/pv/V2FHYNaOSqMlmz+uZusMoFYZzhtlsfQUOGGzp5qxk27PjBhSQfIie8FQZgB5+YhkIztmvGRu7wnSdmA4EUBzHg7+tuhP2kQiDy8WQgX4eqjOonm4M78S6BHPxMYT1rIyk4KqFmj2MpOnrVJNCBbm7yl6xNu9lrI2CR5ipe0WJcNxnhD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 5:00 AM, Christoph Hellwig wrote:
> On Wed, May 27, 2026 at 09:58:11AM -0400, Chuck Lever wrote:
>> On 5/27/26 8:19 AM, Christoph Hellwig wrote:
>>> On Wed, May 27, 2026 at 12:06:08PM +0200, Vlastimil Babka (SUSE) wrote:
>>>>> alloc_pages_bulks can do partial allocations for some reasons, and
>>>>> users usually have a fallback by either looping and calling it again
>>>>> or falling back to single page allocations.  This sucks!  Why can't
>>>>> we get our usual try as hard as you can semantics, requiring
>>>>> GFP_NORETRY or similar to relax it?
>>>>
>>>> If we do that, do we keep the possibility of partial success, i.e. return
>>>> how many were allocated? Seems wasteful to suceed N-1 and then throw all
>>>> away, if the caller can use a fallback only for the last one.
>>>> Do some callers need all-or-nothing semantics? Should a flag indicate which
>>>> one to use?
>>>
>>> A lot of callers (but not all) need all or nothing semantics.  But
>>> freeing already allocated pages is the not a major problem - the caller
>>> just has to add a release_pages call if it didn't already have one
>>> for cleaning up later failures.
>>
>> What the svc/nfsd thread is trying to avoid is sleeping uninterruptibly
>> waiting for memory resources. That stalls server shutdown, among other
>> things.
> 
> I'm not fully understanding the sentence.  I guess you mean that
> you want svc_thread_should_stop to intercept some memory allocation
> waits?

That's the gist of it.


> I'm curious what you think about willy's comment, or if there is
> indeed a way to always use the pages from the beginning or end in
> sunrpc.

It is a ready supply of fresh pages, but it's not used as a simple
queue. Many places in sunrpc point to rq_pages and use it as an array.

struct xdr_buf uses this array as the middle payload section of an RPC
message:

struct xdr_buf {

        struct kvec     head[1],        /* RPC header + non-page data */

                        tail[1];        /* Appended after page data */



        struct bio_vec  *bvec;

        struct page **  pages;          /* Array of pages */

        unsigned int    page_base,      /* Start of page data */

                        page_len,       /* Length of page data */

                        flags;          /* Flags for data disposition */



        unsigned int    buflen,         /* Total length of storage
buffer */
                        len;            /* Length of XDR encoded message
*/
};

There's no actual array in struct xdr_buf: the "pages" fields points to
the rq_pages array that contains the RPC message being processed.

Today, pages are consumed from the beginning of rq_pages.


>>     svc_rqst_release_pages() NULLs only the range
>>
>>       [rq_respages, rq_next_page)
>>
>>     after each RPC, so only that range contains NULL entries. Limit the
>>     rq_respages fill in svc_alloc_arg() to that range instead of
>>     scanning the full array.
> 
> Does it NULL the entire range, or part of it?  Because if it is the
> entire above range, you don't really need the check for NULL behavior
> at all but just point the bulk allocation to this range.
It's two phase.

Phase A prepares the thread (svc_rqst) for the next RPC, and it's done
before an RPC is ready to be processed. alloc_bulk_pages refills the
NULL entries.

Phase B is done while the client is waiting for the server to send an
RPC reply, so it has to be low latency. This is where the pages are
"removed" from the array and the array pointers are set to NULL.


Note that as struct xdr_buf is transitioned from "struct page **" to a
bvec array, we indeed have good low-risk opportunities to restructure
this code and how it uses rq_pages.


-- 
Chuck Lever

