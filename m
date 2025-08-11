Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F65C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 15:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665748E006E; Mon, 11 Aug 2025 11:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60F7E8E0060; Mon, 11 Aug 2025 11:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7998E006E; Mon, 11 Aug 2025 11:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 364F18E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:09:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10F691A024A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:09:08 +0000 (UTC)
X-FDA: 83764809576.20.C421FCD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7B676A000C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:09:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O64DsFyV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t5ioeilH;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754924944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWXb0BYhSuLNUvCfRv8TIlapcdA03yDwDUTjtj4pWl0=;
	b=ACU5H/oWJpYacrVP7OVW9ZKwNhrOWy+p6vU/d1vxHz/Bt6lDtaTU7BRgj3M7pHGpcsoJFK
	WB5CZ2dv7W7bTEaXW1Koa4eRYzKWGqJweIlKyvh+G083FgooO+A9Fxs1ty3/KLKjnRSjTV
	K0ix3hJF0G2iMOiRy4YLwRryvZEl0aI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O64DsFyV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t5ioeilH;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754924944; a=rsa-sha256;
	cv=pass;
	b=2S3pqxNYYNJaJ8vv9XpWeQXTQFFKV/ODgnoaNvoseStYkCBhGEW6XQKdYFetpgOLjnjMZY
	/2+J9lS6Vaecj/wdYSKAP92MNuRN8BPSg0PdNmWhk/44Gvotugz6qXjFBqCIQYlpRhBz39
	RW13/23VuOfHyceEpxJwkwQO6XNoOWk=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BF1KWN021417;
	Mon, 11 Aug 2025 15:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hWXb0BYhSuLNUvCfRv8TIlapcdA03yDwDUTjtj4pWl0=; b=
	O64DsFyVemI8OGh2IIfJ/SwKX1S+tsDTSgWX+Hj2rYG2yMbNskGJ8d0SmpjYABCi
	5KXtDlMRnX/PgKX4VniXq31cHKfX92Ek/7r3l+IiHFgcdo+h3unPPt425IVKaU+M
	b/zDY8E15EsMkKNih6KfUih6NHBJ9SMpioNjxXUGOMdc5Ra1WFNwgGZRGUBV+f9s
	6FinX9FSgJlFeLr9x04J58AgUJuxgzV+PIUVmwfykpuIENhb7BpsiywIvs9tD+zD
	dgENihilXbLz6BrGc6FoRitbuRz5k9Beyev2mntgRIQvgqAwKJm90ghzDwZduk37
	OPBesbHy/MyiKPUqhDUj8w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dwxv2sq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 15:08:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57BEGvtc030162;
	Mon, 11 Aug 2025 15:08:57 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs8rvyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 15:08:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JYeCLiLW8N+PUbMfStxp9q9OOW2B7sGDn5KBYsG0nI3T8MDt5IeSNaHVTV3q4fHQ1NK03DL6XXNvy/IFNd87AEsXdAP1oo2xHSyeV4WBwaE2duHYRrbQhKIgEh3i+vRtApdN5SQ6X39H7A7HAp/BQezR308OoGqtT1Vk/SjtFAkLzqp9F3o/BeF3PoTf3tI5mt6faRkDGgi1K9lZYGjVR22I5Qa54g3Dp9ExwnGHRLDDK5+EJbZjscxTDZIKcjGqVvK8yOpbLbDAVrGqPzEJwGEMgTqCBa7JIIKI+2ikVwLSKADddGajlzK4DTAAEywRSKb822A4ugVkds3vSThbiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hWXb0BYhSuLNUvCfRv8TIlapcdA03yDwDUTjtj4pWl0=;
 b=S1RLAzWwLPwSoflhplLTDm0EtzDXbrQaytp1UBkzGbl5lOqqOy9WfhF6Ca4WDcQvVONgiqlADKdn08xMJx075gIs4OCsP9GQfUsXAPDG5jSnvxEazceFXmUlpLFrgqGnEqRniIIt3oubYVISKx6mIvooPXT7uMrcc3/CkTHSv0s8KvmD1RgQQ+FrYfw0jfE0f7MDy66YUSS/3DNv1ZT1lqlvV9OmAytYrtiRRI8oE7onbSUmx6iiW32Kfkpq+BQ3qaEmG2Zjuppqy0EuPs52POaoB/WomdTep5YqLOIxFtKGOkucWM4GY6OP+YDd3zp5rmd+XrnU71epBJNusqh2wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWXb0BYhSuLNUvCfRv8TIlapcdA03yDwDUTjtj4pWl0=;
 b=t5ioeilHdakRZS0rV8e+XflOIAL+EgI6wds3/e5HWCPh0oDerqMXZSSLxI3NokNUUMNVxS3l/gPRQ7nCBP+bcjySLeHQPQd85OgNR4VDirI/lbd2hUQQWehg8BIHJaSGqDm/wlVt7dDA8dDINqkSVdQc3dvoONlFpxXGW2Lfgc4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BL3PR10MB6020.namprd10.prod.outlook.com (2603:10b6:208:3b3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Mon, 11 Aug
 2025 15:08:26 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 15:08:26 +0000
Date: Mon, 11 Aug 2025 16:08:23 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Dev Jain <dev.jain@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
Message-ID: <0babf2ec-040f-4f7b-aa76-f59e80274333@lucifer.local>
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <CAGsJ_4zuEcgg7U0yCMu6ayKqRPACtvuzUsC9vUxBk2PgMzaf_Q@mail.gmail.com>
 <47ce3db2-38ad-4a6b-917a-c6300fc39543@lucifer.local>
 <CAGsJ_4w_c3AY1Nw7EhYH3rf0jjqgZ6AYLdr3xuonF9SNgWckDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4w_c3AY1Nw7EhYH3rf0jjqgZ6AYLdr3xuonF9SNgWckDg@mail.gmail.com>
X-ClientProxiedBy: MM0P280CA0026.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::25) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BL3PR10MB6020:EE_
X-MS-Office365-Filtering-Correlation-Id: 03a2e5e8-255c-474b-792d-08ddd8e8ebf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUVIZXpYbDNzVHgyeHdiMExRQWxQd2JZTXdSWXAzZVA1VTE5dTk1L1lIVHdj?=
 =?utf-8?B?Vi84WFJjWElKc1JXSnJRYTZ5TGhGRFBUZGlHdG85cHhwbm1CTzBOZ3ZkNnlv?=
 =?utf-8?B?NVpBWUVFdXdIc2pkZExVWmNHc1pDT2ZHVTlya0xWbXYxRHczU1VUYjZqdXRz?=
 =?utf-8?B?TDhUaTM5ZGI1dVkxNjY2Y0oxTTNWbG5vRzN4YXlZMHRPY3YwZDNhRG1DcStF?=
 =?utf-8?B?VEVLK0JVYWZ2YmYyWndSTytqM0p2KzZSb1U4VldHaVR0OE53OWpIRDVxOGdw?=
 =?utf-8?B?UnNQcFkwNGdETGZkMW1WWFJHbklPUjRGSmpkMDByUlRDak1Qcjg4blphWFJD?=
 =?utf-8?B?OVF1bWh3NzNvVGZVQ3F5YitLSXRyMk5NanM3ZU1kM1EzdFBPTVlLVG0vNnJY?=
 =?utf-8?B?K1k4YlBuaTZRN1VvcE9iTHAySys1YngzbittaG1mTzRFajhGSUZ6YmhpRFpn?=
 =?utf-8?B?L3M1THZrNmR1VFkxdFpNTXBnNWpmcThSSnpyd1p0SnhNTGZWNVMwZHNmWTZz?=
 =?utf-8?B?M2dMRXUvOG9rRCtjTDM2akZXblROV0pHZnRJd3h3SkdZUWJ2UTFDekZRTHEv?=
 =?utf-8?B?eUxmbW1sY3NLNUtBdGhuVVhYdks5eFd6Mm9QUGRpcGJSalVnQngvUW1tdW80?=
 =?utf-8?B?S3RENTJodVFHVzhYcTBFaHJEa3FJUm5ZQWV3UDlzSlZrb3pVUHBCL2ZUZGU1?=
 =?utf-8?B?Q3ZsT3BVK25RU1FnQnJZUnhXVm5uZllveEEwTVVxSGRBcDFRT0NwUXFhTGNu?=
 =?utf-8?B?OWh6Y1RSZ0xacXBUYXpzR0ZJa2QybWgrSEN2b2dvV1doZElEQ2FabGV1Q1NT?=
 =?utf-8?B?eUc4bHB3TStwM3JsOS9BSGxvcS9yenNOaVVqd3VZQVZnNkg1QWdkQlBDWWFt?=
 =?utf-8?B?enhwZnMxQk5uRjdHS2xDWUJoRk4yM2JYQndVazVoRkx5LzRWUVlZMVZNWnFQ?=
 =?utf-8?B?cXUzV1NaNm9uT2tQaXdHSXVBNUgzTDg4WkVIZFpZaFR5MWV1ay9QbUdYTytM?=
 =?utf-8?B?amQ5ZUh2NHhOVXgrQU1tYWtFSXp1UkRmOG1CN2Uxbm9qNmtTVWJKWHVINVNj?=
 =?utf-8?B?UVVIVStVY1lSTWlIRHBTUDhmWTBPNmJURmdCYnVnNHY5YStydG5SZkNJUjNI?=
 =?utf-8?B?RDlPbWcrbU5mYldyYzV0WmFjcmxwVnVJSnJZMTFzUStUdm0yanIyK3BIUkIx?=
 =?utf-8?B?YnFlSXExcjRjemUvRGRRQzVzWFJxSksyYTFaTXhRUjlTZHpXTHJSRFpocDF4?=
 =?utf-8?B?ZFAyd0dISHhjMXV2eWRsbm0wcjZwTkMrZExlcCtwMTZxZUkvUW91cW1NbWhx?=
 =?utf-8?B?OWtLWDExVnJldFB2SGpCVWNjbmJzeFQ2QjhrZVNuRmtKK0Y4SEdVZm54S3R3?=
 =?utf-8?B?WFZXNFlKRlBTSENXdm5XUlZhaE55VHd1bDFJS3dpaXlEZE16bmxPTjg1QnRt?=
 =?utf-8?B?VU1UZXJ6d3ltZmNFSVZpbDRjKy8vQXZrTFFrdzJzSGdPRkMxRmpDZzFzaFdQ?=
 =?utf-8?B?dTJWZkJZSXM4TUpaeFNpVjh5SkdidDk0MDFheTJJV3IzSjJHVE54Q1lKZmpZ?=
 =?utf-8?B?UXZZUW1OTkhIbW50RzhiQktqRzd1dXlnOENMQ2F6WGxyY2VBY1Z4Vk5vQ0wv?=
 =?utf-8?B?d0psS0ZwRHNjY0c3aDNia21KV0RkQjlMSEhmZ1ZKK1NvOEdsanBXTVR4WFFl?=
 =?utf-8?B?bTRVUHA4K3krZFMvNnFsSE5BbGQ2LzhvelprSFRGNVZ0T1dMVHZsTmYwNHJz?=
 =?utf-8?B?QjN5bTRzRW9EeWlmL2ZwanR4amNBaldHWXF5bUNkckE4TkI5YWVmcTFaWTU1?=
 =?utf-8?B?djljck1GSEFRRzdtdFFYSXgrbFVtREpIbU5mbWE3RGd3aHU1Ull1MlFFT24r?=
 =?utf-8?B?dFB2S1NlVHhOTWlYc0ZXbXlidm9meWZZbkhyWmJWclVrSkd0Y0pmNFoxQ09U?=
 =?utf-8?Q?h0M3imxyvhM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUJwYXZYUUkxZ2lUZzJjQzR5YnZKbCtVa1N1YXJKK0lNMmE4S1FWOENpUEpr?=
 =?utf-8?B?cy9ETU5TMWdNZUZuZFZreUVlNC95blBEMWdnWnp4bk5RYUsvbExGWWp1UEFn?=
 =?utf-8?B?S2QxSS9LMWc2Q2pET0dZVDM5WEdMbkdicUpKTDY1Q25BdVNjb1VBa0pDMkJX?=
 =?utf-8?B?T2VCVEw5QmFOUHZzUkt5cWhNQ1k2eUpKNGRGdkpQVHlHR0UxMWJPZzdiYUsv?=
 =?utf-8?B?SVcwSWRLbVgveE9FcG90SHBXUk16SzhCY2lNNlFOSW5zeU1leGU4eU9laVRt?=
 =?utf-8?B?SWl1Wnk4OC9jbGc2NUxBMFpaVkVFcUE1a3R6bW9rMys2d0VuRWlYbzB1Zmw2?=
 =?utf-8?B?ZXFaUGpEOVlBUmJhakRXbDIvU0NvMnJlaTZSTXNZNHVFMGY2Zno4SUhZcVZS?=
 =?utf-8?B?Ull6L1MrZVQ0MnZKZUMxUENjamoybDJyMCtHZ3YzSnVRaVU3Wit1ZVNVL1ZV?=
 =?utf-8?B?QytkNmZHaWlCc083bFVmQzhteHpqNTZWUmFSUk1Ib2Rob0c2QThIRUgzS3pl?=
 =?utf-8?B?QmE5TC9BYmc0S3p3Y2RyTzVnWmh6SXJOalNWU0czQnR5c0hqbTJWVm5nckxX?=
 =?utf-8?B?UU95b1FlMjFGQTJGaUprSmRaM2pSZ3dzR0t4L3pkRHRPUnoyVUM5Y1d5cDFZ?=
 =?utf-8?B?a0N5UndmKzJ0VW43OXE0T2JRQjdtUUtlTk5TUkg5UVFSZFdQTEp2cWJOV1px?=
 =?utf-8?B?eldIOENVYks1LzdSR21QOTFHR2RLN0VBdXFSUDBsUU85Ynd5MGJGZ0pzTUcr?=
 =?utf-8?B?Z0R6Q0d3LzBRc1RzcUd1L0k2cVoycmFzbWZJL3JvcWs0VnV5WmRoRUtZT0pE?=
 =?utf-8?B?T1F0enlRV3QwQ0dPeHpsV2w3cVFzWE1XRTZoZFJPTXpBc1RiVWR6Z1FibVlN?=
 =?utf-8?B?UUd5bHh4V1RuR0Ixc0MxUm55NndXRStGVyt1OTl1RFhUK3FhUzE5WnFJWWM5?=
 =?utf-8?B?dmxHcWx6QkhkM29WUFFWYVp3M0hvcGZuNDIxK3AzZDRUMmZ2WFJSOTZGcEhv?=
 =?utf-8?B?WEpwb1VBVFZySUVuNFdvTUJpS25BRHQ5TnN1OUxTUHlJbS9jTUV6V29ZNGNo?=
 =?utf-8?B?NDREUE1KUVUwZkpwV2c1WHNLYnB4RHh3WGZhaEFtaDdkaDFFSy9BSWxPTVds?=
 =?utf-8?B?aFJmdUdGRTNrR0pEK0FHWHRJUmFNSnNRcUYrQUFkMFJkTUJrU01nYU9Na2VS?=
 =?utf-8?B?eVJqSGtkRGY3aVByNWRCQWJUMG9TU0hITzVRWU9hd1lOQ1lQc09jMmlGdVp0?=
 =?utf-8?B?MDNKNGdUaEJOVXN5QUNFcXllWDd4Z3lGT0RDK2dGZnkzL3NsZlVRUXQ2aHZu?=
 =?utf-8?B?aDZGem9CUVNkSitwZ2dYZjMxeXErZHRrdGlUNEZ1cEFiQ0xGbDlGQUtTc0ZZ?=
 =?utf-8?B?U21xV2VrVkVyWlJkZEFxc3FUNXpTc1RiNkNGWkNxd3JKUVZuTC9tSm9uOXhq?=
 =?utf-8?B?Qyt4eElUaUZzbEpkblZjY1MvSldOTE9nYmlEVXhVVytJZEZVanRkK1JKd1BK?=
 =?utf-8?B?L2E2TVl4TDdsWFltRlFaNG9nb0RpTnFvWnJjR2dwdU5nZ1l4TDdDcVk1MFpn?=
 =?utf-8?B?Y2lUVHU4VlVpZ3ZUU0JIaUtCOVJydG5MSmFaNmVkQm5TODJoQkE1TmJ5OTZP?=
 =?utf-8?B?eFo0UmZRamZDODVyN3UwZVdFZExTelU4UlFXNmFKbFluYUhpVXp6V0ZwcGpJ?=
 =?utf-8?B?V0UzNTNjQkxSR2U2M2Q1NmlTdExMZ2FXcFhsNXQ0dE1CVTNSWmVUY3JScFFa?=
 =?utf-8?B?dmFUQm5zTTl5ejhsVWt6L3M0K2E2cmVWcGpGZDRJYjM2bk05VXdXSHlOTWJu?=
 =?utf-8?B?MVVUUEJTTFB1R0FZWi94UnlRbFN2RW9JK1grWnpKRUdDNWIrMTVrbytpUHEv?=
 =?utf-8?B?ZDQzRFBPT0VDZUhaNlkwQnlVbXlPZjE0UWRXenlVNGN4dmlLdUVrRWQ2OUJ4?=
 =?utf-8?B?R1FuRGgrakFhS1ExWmtkZkxNakVnTGtwR0tGbEo1alh1TUJzbjVramd1VGhR?=
 =?utf-8?B?eTN4SE1kNmlGOHh2S3JTVElyZklaUTE3dVZSci9JUno3SXFCT3JBbTlRYkNG?=
 =?utf-8?B?YXJ4QXdrZmpFeVBna1pLTThLaWFMci9Db0hRU29oVTRUV0RPVjdFTDZwS1dI?=
 =?utf-8?B?cGVOM083Q3VOaFo4SEFGUlhqMGZEZXZyYlpOOTRxbERTMVZvaFBmRlZIanFy?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Xa2EGQeuokdzI9ZFiWKq8cYmEFsNNm7XL/PJGaX7rwaH2gu5wQeU6QlfH43OREANlO9YakZfATJwmORvFQrAFqsNaXrc9s6oY4AvITdgHp0QN2T2F+6SeCShoQ1xShgvCXCqJLdtiicNge457lcm41XKKIhOVSyCAmGweL8utxUBYvRYhnBlt3VjK7KGJH03cH1TTHMEdy4KZBmjLr//y0FFKLbNQaiscmHJNZQl0uO2zURDxA8V4iStJEZiRCIYy7Ani+nO5BRbqg8Tjso37zD60CPFByGY5rOObd5Xe4gduEtXnnygKqbktOQvtqAjChPiEBGNMqqblKgYttBAslZXxDMA6xwzDsftSlPgO6Ft8htB7E3ijEeAIMgXfkaAa6acR47vjCcVMjBzNWz3miIlM/TjyQqtzxIRxCsXBDqZbgV0rEwR5eaOJMDGjYDvAVcs7HBcvfH+wxHquvoT/jBXoNhrssE/hMzoi9k84qrtvWngpzpKWsv6EksUP/K+k+O7ROlQuJt18FvvTVwGnozt4dzyUKbaKPjrN868GM3SzcPwUmI8TcZN/bc2lILh10jSruy0NP7oeWawD/W2t1zyaf7S7bZB1M7SFlLjebA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03a2e5e8-255c-474b-792d-08ddd8e8ebf9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 15:08:26.0170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1A7tZWI9XViR1j6tBNgl4EKI3H0RtEHwLyu/K01arRFuPvvN1OwgwMi+RUwwupUnCf9CsOesXz7mxzRpEyDk4TpD1TEHyPNvzJO7sKAKdjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6020
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_03,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508110097
X-Proofpoint-GUID: CNc8xigs_z4rggzW8GPXJMA0I7Y4viDD
X-Proofpoint-ORIG-GUID: CNc8xigs_z4rggzW8GPXJMA0I7Y4viDD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA5NyBTYWx0ZWRfX2fFzLIs9Is1f
 CURUxAd54qfdA04VbSrnjv/LQvgWQzHO/D0hQfvl3QHR9/HnqiA8hlrtAfOHIkPXyRp1+KuvgZP
 8WSBV+36uZ611PBZgGeOYerdwn7jFsH2Wx/7Px9TAa1l0/FqYEavrMarESRNNuyXjnqqvKts9dv
 bFXMiyhIUw1/vzpEQ2CWcIXhZVbDoKjquGAqmmLN0bLdQ3qkuSer/Uf/sl4exrYAaInVISGQppo
 ixlqQdvIk5EZWuKi0IjC0DIV+pwAVtJo3+wfhdBHbML5bElc/qd0bIK+mNKKb07zodYkJ6f+m8k
 w9ZUKmAPgkESX3NqD4M2qAI5/XD5h1Hh5JVaMqbY/Q8RF9tBH66FxTzJxNDa6WJ/rzApM46xLp5
 Bo+GB+S80qXfLf54JWb1LJlgvPUp4IeSmOD0vGqkNEBYpwsiKSs3D87As9Mfgj2ph/N/l40I
X-Authority-Analysis: v=2.4 cv=KJZaDEFo c=1 sm=1 tr=0 ts=689a078a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=HFb8Z_BcDe0cQa6UeQYA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Stat-Signature: tm7n9jcjz1sdnywujwmppoy34fpghocx
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B676A000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1754924944-151408
X-HE-Meta: U2FsdGVkX19GL9QImpbEldWD21JkMrLFnUwrxssbV3xlutTBldyXe3SNjSzCFp0josQCP6lexr+RqFfPArZoCVQmOPV5/LODosGieZ7Zfieo+hOF6rp9YS0r/X9qrpIir37i550oQEcsIOPCnQr7073c1MqfPTXy2E8PufEcmHB1S2+xxJZbmCkTSupqEKiP+SKhBRDsRmbzr4cRWPpfhX+4cTruv9sKo0ZFzz2rLHdGQidapECxuYfYMIdKHxiuiy+fTNW3ZaG2m6x7MO4OJm4Gk40ZQSb/ovwJ0JuKs6PVO0HWALIbR1bLzkxvt+fLMvSQC2PFab3H7Q+yQTn/x1CFxpG2X0lXjK/SV4JzZogPVjP/hlPLgtiZgkPIJkAR6ueGa63pO/yX0J1Nu6luD38mBaxSNXJ2Xbg5Edxss7zmDIA9/KltaxmjSALP1rQJE/nM7JOyPSTkg0UxoEAI+W5a1Bcbs54meuBIbiafyJ0Ixm9OWZ1aoYbL9No1uHBiZGdg6cr0u1z+2IFzf4inG11/V4yYBpV0d7HoRtbHGLBjhUdHpPgB21qXcJMy7w1HsO9XQcIoG7BPzdRgEG0fHQnMaSspuQIx2niGGuVrhmqq+qlH4WfCcgZuwMpXFcIfyCGCpGa0WoOxne5wEuNtpTWNkDZtYnDzaA0sZaCBgB8oxj3414T2JXRcEsfbNpV+sS4YC8Tu0zW/EkxjqTTWGudyPgBhW+mtyG66XseQINxSebsvGCbvcUdUJNS1ds8wOq7Nn71QtL1XjV7gRff7daRsUTOsU0v820/fubQn6T3SRX6MyfzENo5G5AR6k64ciMtbSMs8ShkHe4eqTl77m77rZBFZb+LisO7uJdostjXJqduae2/h9iSZNVseGwm2Ez4Ax6p4MJTBxzGMqNo0AMpWg7eldVQrWoU0b9SFnLYjBfyWotc4wwaVyVcfceFCliwazowUh7Z3gcm4SCu
 XPWSn76X
 2mkHpeVIiknfcWebFjGbVWPgZSGq6U0sMpUhTVH3o4BpRmsfu64kywgcN41kdKl9sPCw3lkV2Gz3y/jaAz1zSjiNAAjowbj6BzhxOBqZW+DNwW+txQmqhL/9gluHW79OFN0Paf6C7Za/Dbtmqj6dcI7tWeCys6dtGn1Qp8EjzaAxdjT/UeXq+W0bKkzXrFaoITPbhlOPZx1VElcBDdnYIuriu6TzJ4qqfSs6Do3ck0qhkWkQwhHzAHW3Zb3JPwmM4Z70YNR4rgD1xcDb+vWrbuKIYSr4o8CdjBroOlcA2ZFx5pFtBC+T5u3yFBzzvbq0jYmGuxUqGNiyV4UODsleWVdCPRCsLs3kQc0v5iiIpvqyq/pDbGbramEo6e3W1XJk2XFM5jwPh5gT/awSbxCSReWmKpFSzZ5ADm2HhOFDHooYTn3ieQfH2fZVwSUELDsGOFI4WX9BDrMhEm5RXzZP+lnKiQZpyx7g5c4gAEJWBEDnyy97e4kmNflVJJ/X6+3iJ77RLAJWEWRNBBToOHFvQf4bY1wLG6wt4cSjs1g8JhkBMPpMIaCGazICghjJ2I4zMqDImy/+uzSZlxzagEMxn4uqnc3FNzhyvxL2XaN7WU/0OLnr/Cqr6V4hbAwSftXoxkwamOzV1ttKi1e2EptCKtOVFLrmHAVmF5VKQaKkOPJnIYSUAf5n1lf9kwpVSx5zUzhNIo6RPHxG4nqkXezCulmvRRKGxN4Pd55r0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 02:52:51PM +0800, Barry Song wrote:
> On Mon, Aug 11, 2025 at 12:57 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Mon, Aug 11, 2025 at 10:40:50AM +0800, Barry Song wrote:
> > > On Fri, Aug 8, 2025 at 2:59 AM Lorenzo Stoakes
> > > > The expectation by those discussing this from the start was that
> > > > vm_normal_folio() (invoked by mremap_folio_pte_batch()) would likely be the
> > > > culprit due to having to retrieve memory from the vmemmap (which mremap()
> > > > page table moves does not otherwise do, meaning this is inevitably cold
> > > > memory).
> > >
> > > If vm_normal_folio() is so expensive, does that mean it negates the
> > > benefits that commit f822a9a81a31 (“mm: optimize mremap() by PTE
> > > batching”) was originally intended to achieve through PTE batching?
> >
> > Not for arm64 apparently. And the hint check introduces here should avoid
> > regressions even there when small folios are in place.
>
> I still don’t understand why this is fine on arm64. We do have faster
> folio_pte_batch(), get_and_clear_ptes(), and set_ptes() with contpte, but
> are those benefits really enough to outweigh the disadvantage of
> vm_normal_folio(), given those PTEs are likely in the same cacheline?

Well in operations that already need a folio it's not really an extra cost.

For mremap() where we don't, then note given that we're gating on the hint now,
we'd have to have cont PTE entries, and this would mean we're only looking up
the folio every 2, 3 or 4 PTE entries, not for each and every one.

So this is a significant reduction in time taken in theory.

In practice - well I'll let Dev handle that :)

>
> Unless the previous contpte_try_unfold() was very costly and removing it yielded
> a significant improvement, it’s difficult to see how the benefits would outweigh
> the drawbacks of vm_normal_folio(). Does this imply that there was already a
> regression in mremap() caused by contpte_try_unfold() before?
> And that Dev’s patch is essentially a fix for this regression on arm64?

Yeah maybe, and that'd be interesting - Dev/Ryan?

>
> Sorry, maybe I’m talking too much, but I’m curious about the whole story:-)

No please always query things, it's important stuff!

Cheers, Lorenzo

