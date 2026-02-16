Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F945E81A25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42AD66B0005; Mon, 16 Feb 2026 10:16:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9006B0088; Mon, 16 Feb 2026 10:16:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B0E6B0089; Mon, 16 Feb 2026 10:16:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0EEB96B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:16:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B42FABDF55
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:16:57 +0000 (UTC)
X-FDA: 84450672474.04.F0E7E96
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4A33314000B
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:16:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rX+Pucew;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mZmZfyBX;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771255014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1g0FLvEDGJWRcDeMEHAdLuCpQz9uQlKr8CBUJqXdeHM=;
	b=t44qpjwQir3ZuXQdpqH8HYsvDk7eMuMyZOeMQBsnomvQnGAdfFvpQ1uSAxrKPxqiHJjVO3
	tCeCs9b6aS8upKp5ZpiHek+fSti/t/c84Ws+0VatWbIeec2ZOqMyalTrWlsc0luIP/CrdO
	AdtjF+kV67eZ4Lxk/wEB/wnPF2rMI+s=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rX+Pucew;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mZmZfyBX;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771255014; a=rsa-sha256;
	cv=pass;
	b=YxRkE/nMV7ZMgklHRramdnj4F8w4v8wmVn0f2Q65MotFTKOFWo7nDnpTLBCIjai4VAfTb2
	bCecR5k+DG/ATuf2tevnu1a3V/YhvLl+mOapaGiXGPvBU5kPBDjoT4Z2kdUlFSj9kFjCHz
	Chb+IS2bsUgkx6U4nTFYdCQOHiXECNI=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61GESp4r440346;
	Mon, 16 Feb 2026 15:16:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1g0FLvEDGJWRcDeMEHAdLuCpQz9uQlKr8CBUJqXdeHM=; b=
	rX+Pucewz5pi7XIy5CUPSvRE+sdmkcYaWvn5gtOo84kgzdLnm3ObDpn7QDN+D18s
	6H8NLFbQXU7GVFHpV7Z4nBw1JNNrSefb8MFCTfiYkrIdPzoxAn5KpbqI5d2K2A83
	rb0fAtfnRiKuXRTZljmkXvDZMVVIPLeuFokkG6bc9Ogd2L9VEA/XoPczRdqwfIAj
	OPLFmhje5VkFVLQQp5+8vEs2RF5anmq987/8iJYa86UNkjNe213ffnKwevfgzKJg
	K3ayBrnh1r1aLjctK4WZhXAhwjG0DDTjKZ9dkdXDFqJdVNaWV4B65FpmFix491eg
	QY6B1Xt+FF2ciqLdWVF9Zw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj4at7p8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 15:16:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61GEdTav023027;
	Mon, 16 Feb 2026 15:16:26 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010061.outbound.protection.outlook.com [52.101.61.61])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cafg87e8b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 15:16:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1mPKfPEXt/w5vuNsNbfyZmga1A6sQHX7iRk8DQWY930AS4lomibocGJxJX+UQqxv3SHr6DF3IurGZNHmmOsiXbjCAsScCLtWdJ3o98mmzg7WPXEJZAvgu0D9+x902xI0K2GMR6SgJcd/8FchEeL7m9va2+deCI4c74KcML7nJ3Z7axRJLX3+5ihusO50JvFVRjs6YSCiP07oiScqA3yV1vU3guRTYllxVjQvvDRVBx6Sj5C4fORekBU2RUutD8g3SZoJWtZtAZuBI6PZHk6nj4aQih7wZNo5PBMzDkMdlwL/PZ9adek4N66EHhXhM+4CJvxTFuG8H2BYxqluQcuKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1g0FLvEDGJWRcDeMEHAdLuCpQz9uQlKr8CBUJqXdeHM=;
 b=jdQaIXFLV26Ie++tb0GnOIMJhFHEVw0Ok6I7VoWqZ6yJ5GhtaIEtRK1EjGYJgp+lYK8if1Z04ChWztFgoYybKO7pi6gbEFnaCcvW10lz9gAR+IbCPViJJAaDkrf1NbUB8NL3bNtqFw5HTzmeBaP4JcyAeseam2SqGD6/YolPD8FhxGTNLV586lnnsKiaFlbun2i09ClVy+yZO+xfN1bI6dt8+CwthfEznB8dc6OKTIrhMjkd2fJSWlSe+iJXkJUbyLcLnngGS7SOR9d2l3xtDtnHQuWOttBVQtjOb2p21W3Byg6oLN/Cua5pQwS7pMFHPaEEVC8gYv6W0JTkVd7qkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1g0FLvEDGJWRcDeMEHAdLuCpQz9uQlKr8CBUJqXdeHM=;
 b=mZmZfyBXiEuYT5kbSHqeO9PId6GoppCeXHy3q6krXA89+tWOj5SbuDhlM6UEAwfeNLj58a9qlTIt1QGc9khLPnj+qCmfwaEs60P7cI0xqb3j7AFJbxH1U//QDWdEE/UsUxSusLdjALSaq7QhD/tEk/fMaMWiIiZ8o0DuMYhFeT0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY5PR10MB6213.namprd10.prod.outlook.com (2603:10b6:930:32::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 15:16:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9587.017; Mon, 16 Feb 2026
 15:16:18 +0000
Date: Mon, 16 Feb 2026 15:16:16 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
        joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
        gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
        jannh@google.com, pfalcato@suse.de, jackmanb@google.com,
        hannes@cmpxchg.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, zokeefe@google.com,
        rientjes@google.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com
Subject: Re: [PATCH mm-unstable v14 07/16] khugepaged: introduce
 collapse_max_ptes_none helper function
Message-ID: <ee1a11ac-ea08-42ea-af41-2671691b9bfd@lucifer.local>
References: <20260122192841.128719-1-npache@redhat.com>
 <20260122192841.128719-8-npache@redhat.com>
 <db10946c-9743-49e0-a845-7f53a60778a6@lucifer.local>
 <CAA1CXcBQWPD=AxX9mCOdAOv85LTk+FPJQeEudQur-ymg4vbp5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcBQWPD=AxX9mCOdAOv85LTk+FPJQeEudQur-ymg4vbp5g@mail.gmail.com>
X-ClientProxiedBy: CPCP307CA0008.DNKP307.PROD.OUTLOOK.COM (2603:10a6:380::10)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY5PR10MB6213:EE_
X-MS-Office365-Filtering-Correlation-Id: f44f9c30-f126-4b2d-2cba-08de6d6e5596
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SGF0cElESEZnUlpRTGovUFBySWdva2VnZ2wydktLTko5Ui8xTGlGNGp1b2d5?=
 =?utf-8?B?UmhzM1Y3RjZUL2NKNUJtVzFrMGRBZ01jMThVdXJBOWlYRWg5ZkVMVXI0dUFD?=
 =?utf-8?B?VFY4WFptUFJTWXhjWEZzWHNZRWtuOWlQbmdxVXZ3YVlDVXI0NWtDdGRlcENZ?=
 =?utf-8?B?SnpsN3JPd08vZ21BaHJiU1VPQzRrMXJjVkNxOGhtWG00ekZiRVh5YStXcEx2?=
 =?utf-8?B?Slc3UjJwOFowZlJsTHFyUXVPMWRXZlJWcS9PNGJIM1hhV3QwRnZXb1Roeng4?=
 =?utf-8?B?Nld1UWIvQW5qUHJoYVltRTAveVlaRm5EUkJzLzV6c0xBVGtDOGMveFc3VEtr?=
 =?utf-8?B?NjhDMkd4UjFJUWNnOHJiV3YrVEdmRlFVZWsveVkxZ2tRUE5sWVJpc2g3Mll2?=
 =?utf-8?B?aG4ybkozUWRLVSt6MUR5Zzh2T3FrZGVCNER1RENzekNBQzltRGY3Uk1VNHlC?=
 =?utf-8?B?bGN6cVUvNjdpQ3RYYksxaGs2aHJVNGxpTm0vTC8vZERvbWd3MklVQzgxZGdq?=
 =?utf-8?B?MjBuZXNkTWEyOEV5dER1ejd3ZEpTbUJzVnhFemt5c2hHUjlEMG9KZ2VtNCtp?=
 =?utf-8?B?czBhUmVESFdMOExUcks5ZWhjNDliQzdsSGZ3ajFJQWRTbGsyUDhhN3hTbWlk?=
 =?utf-8?B?L3lFZnJxYUR0WnR4eXdPNlppWEh1L2tUWlhZR3VzOVhSODVja2JpWDcwSC84?=
 =?utf-8?B?THBLNXIvbzhqK0dhb0JYamxtdFRpazNUY284TjhrUlV6QzFtRWVEK1hQWFBq?=
 =?utf-8?B?Q3Z1d1NiSkpRZGxMVEdFTS9OUzIweXZRSFgySWF0ZC94YjE1YnptYmdsMGdn?=
 =?utf-8?B?bi9ZNkVoRHF0RndldWNreEdFT0Q0WGJKQ2dSUE1obGl6M2s4bi9rRnFkTUFv?=
 =?utf-8?B?MnNPTFFqZTNPRXRwK2NwbWI1MWw5cHh2R013OXdCbTVQVEZsaXNiRW9RblVr?=
 =?utf-8?B?K0xOcjJ2dDFtYnlNdnA1QkdTaGFZNzhqM0s5UEp3dFlhbmVoc3JvaFpnYTAr?=
 =?utf-8?B?anFGWm14MFhDOXkrQzgwRWpvY1RFMDlOWC9wR1VOUUNlanpRazZMUHdId2dI?=
 =?utf-8?B?U3d0enJtWnFFM0FVRmNQaXd5TFJlQmxVOVhwYjZOeUxBWktQK3FCVVdDbkJu?=
 =?utf-8?B?eit2RWl1VVpNZW55bklWVmtlbmdZaVlOWUpGZWNlQWsrRDd1Nm50WlkzY1dh?=
 =?utf-8?B?Uzk2amxwVWdoWGhvcUI5VjVURVdlQjNYcjVmNDVRMUhXMXNHNm1xRWhDcjRh?=
 =?utf-8?B?SXJud3lRalFYSVpOUGtZVnl1TjNUc3NNRmRwK2xtUytBWkJqYXZMMmZLNERF?=
 =?utf-8?B?S2liVklScTZxMTNXNGErbmE5OS9hNG1wWVR1T0RpVEtFc2JRY0lSRTNiVDlR?=
 =?utf-8?B?N21GOE9yenlKQ0dnRDlKRU9mcUVqaFl3bVdPR0lnWGZMY2RpbVJneWJNRkx6?=
 =?utf-8?B?YjJTTi9xdlVBeFBNOWsrTGhJeWNBMkZyL3MwNnc0UjFLRFkwNW5ra24yTkhS?=
 =?utf-8?B?ZWNRZk9LQi8yZHdvVHg1bVhEN1FjYWljMjlHQmg3VmYzcWJJVHk1ZWtLZjhJ?=
 =?utf-8?B?Ym9oYWloeHJOcFZ6bWVvVnZZQmJYYVl2NHRmcmhCVlFaSXYzUENwMUdPbkdZ?=
 =?utf-8?B?K0pCUkFBV3U1cWgvaU9UYXJIUHo4c1A2V09XL21uMzN0SnBsNEtYM1NtbmZt?=
 =?utf-8?B?WnBydjRkcjQza1FMZmx5MHF3WXhoaGtDc0lKL2c1bDl6eGI0cXh1YjE4Vm1J?=
 =?utf-8?B?RGJDNGNkQ1A0WXZBNGVyTkM1eE8wTVZmc1pVK3RmaDVEY3ozS2Z3VzlPbFNk?=
 =?utf-8?B?RmhaUThhWHVkSXg4NjFidVNTa3FTRE9tci9VODdVME9vckZDSURWY0h3YWFU?=
 =?utf-8?B?bU95Lzg2MDRIYUF5cVp5UXJReC81VktzcVNtclE4YlVzMGtYZjltYXhvKytG?=
 =?utf-8?B?bnV1cFh5RUdjRHBDcXBBYnhlNUg1cVA5UEhkb29DSHhiWHpheDZ5OFRJT1k3?=
 =?utf-8?B?K0hIQVVWYUQrMVoveGNNOW9lSENUM3paSDFxa2xYK3MvNmFhSUhqN2JnM2Qw?=
 =?utf-8?B?VzJGZkNXc2VteFNhNlAxVDZnS1cwc0g4NmcvQmZRNFZDSGdhWmQvVURmNXB1?=
 =?utf-8?Q?ZL8g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTZReUlienUwK2RneXdYQ0gyQUIxODNnU0hnTXJ3MCs2bzZIYkpNVGI3SXB4?=
 =?utf-8?B?aDBwSDRwVUxQQUJFdlQweXFNMXNsWDZlQ2d1L3BOWWp0VmZ1U3hWUUo5Z0Yv?=
 =?utf-8?B?VFF2QkVva0ErMVBoVG5aMTQ3R2pIaG9wVjE0K0cyZEpWbm1FRmFIU0FITnRt?=
 =?utf-8?B?NWR5emNYc2Q0Z2pIY1dKU1pLNmUwWGNjc21DTFMwQzFSUS9nMThGV3B5cnJz?=
 =?utf-8?B?aWYxQ3RRNk9rQ1UxNnNTYlozcVE2U3R3Q0NlRVZ4aG01eExkc21BODl0bE0v?=
 =?utf-8?B?Nkw4VGRkTndsbkQwRjFwZUJCZnQ4ZXF6R2FmVHZJM1ZmUUxSTkRqK1dNTFFt?=
 =?utf-8?B?VElpdWEvNTJPakxqdGxRdWRyRkloNUZnMFJKMFdrT2xEc0xJdUNXVm11VlYr?=
 =?utf-8?B?UHJrenlkclhkclY2WWFLcCs5M0V1TzF4YTZleElyQkQ3S0Q2cVNTM2tlMGg3?=
 =?utf-8?B?eDdCeE1jaW1PRkNKUGE1RU5TS3dpQ1ZEY3JVRjhNSXVRbmxzRUpIMFEyTWxu?=
 =?utf-8?B?c1JhSXMvK2xMWGpBNkZkV0VJMzA0WXhVa0ZuaW81WERBSTRTRnZ4ZjVMWXFP?=
 =?utf-8?B?NmUyOEE5NTJJbU95dEZSUGlNaEtVdlRZK0xjZDUrT0RWVXl4S0RxaVVNVTBy?=
 =?utf-8?B?aGxlb0FoeXVxK1ZOYUxZRnBnZEVZZ2pZRHZ5aVFaVWdQMnczSjY5b0JVMEd4?=
 =?utf-8?B?b1JYTnhDZ3dFNXBlMGFGaC9DOHlxeTd2bUdQS3AwMy9pNGRyUm5Pc1RpTktG?=
 =?utf-8?B?QUdsemFlOFU1cTBvN1hwUHNMSW93OWVMWWR5QTUxYWNUNkE4WjNXQVIvZTIx?=
 =?utf-8?B?akROaElUUW9jT25HY1ZDclhHbm1ycGUrWHRGcUJSWUd1bmRzSG5HUHVkdkZ0?=
 =?utf-8?B?YzN6NU5RWC85ZDVmQmJsdmZ4Z2lORkMwNW9HaENwK0hOU3kzVUR4RlkyYVZt?=
 =?utf-8?B?MXNRaXlwbVZRalByZHMrS21ZZzdWT1c4SmlrcnVWQ2xrbERXVGVCM0sxc2cx?=
 =?utf-8?B?OGNId3ZRdzZRb05YZDBlUysrMTVnYlBCVWtueHk0VDBLc051TzB4SkphNUo5?=
 =?utf-8?B?R2FmbnUxaWE0NlBXYnRFUU1FbStjMk0rcmtZa2lHK2pDSVVIbWhHQS8vVzQw?=
 =?utf-8?B?anJOUG9JVjNvVFc0cmVTS2N3M1JQV3Y2b1FCRjl4R2ZURldpWTFrTVZHSDdO?=
 =?utf-8?B?ZkRsT1FFTlltait3RENUL2lCckVFeFFQWG1JTlVJMndwTFJZc2hsL1RjRysz?=
 =?utf-8?B?WTZoamZUM0hRUGVxaytaek5lSnhDVXdnY1cydHJsd0E0OTdiN2RVbFlLS2Nr?=
 =?utf-8?B?eCt1Smo3RjQzUnVsWVZhdDREZGNORXRvRjRqMUpua1IwMk8xNm1BM3lra0RT?=
 =?utf-8?B?bnNNRzg2SnNGV1RxUnIxVm1sZm4vL0hITmlUYWtNbTVLbHVqTysxZlNpVFMv?=
 =?utf-8?B?NnlBS05MZEhCK0tVNzQweDRYeG1UVzZ4Tkx6azRBZEU3WWJMd3N1WFovMGtx?=
 =?utf-8?B?L0MwSUNsVjJPM21kY2RVc3lSUEJlcUxCcTlQQm94cFNITGxPU0wwK1lYWDYx?=
 =?utf-8?B?bHMyMEFFanM5MkZFeDRrZ0JIMzZsTFk2OUYvOHNvcmtrOWdPaUNOdUw5RDB1?=
 =?utf-8?B?R0h3dmdxL0JQeDJ6MkJNQ2ZpR0FBTnl0bnBURUtMK2dEOXd2NDdhYWRXWCt4?=
 =?utf-8?B?V2w3ck9ic2thSXFOblBqY2NZdzQ0M08zempMS05RQ1AzTFg3b1pUc0t6TlBG?=
 =?utf-8?B?S3VPNlZrbHhBdjVrZitMTTdYOWVOTjNpRjd3U3owaHBiM0hBVmlSWDVyTVVp?=
 =?utf-8?B?TzNWNWlTWEkrTVZPQnRZUWhSRHZqT3V3YWJPR0llU3Vmb2RXT3dFenFQRVhN?=
 =?utf-8?B?SFg0UzdqSFMwMmtSdHY5akk0ZEtvSk1TaVdOYmVpRmhBWU9vMUhlalM1dWh4?=
 =?utf-8?B?SS9DMWZyQkY4eSt2WC9aNjMzTUZvQTltd1BYb2VWem1Xbml3ZFh4OWJXWENi?=
 =?utf-8?B?STR4bDA2Wk12dEtFMEVFb2NONjRUbFZjM3MxQnZnTEZkT2ZSekRQd1RNTGlJ?=
 =?utf-8?B?YWhpbFc4RDNpUVNPSWM2SlZGbk9VVmpHYUZVWEx2WFBWVmRlT2F3ZFM3L0No?=
 =?utf-8?B?eXpBSVJaMWVZUlM5V0ZRVE9VWXA2UjQrT01LNGduSFphRndQemsyMWVLTWlS?=
 =?utf-8?B?bzZCaEtKYmIxcDNackI5RlpIcTV5OHZSVU5Ja2Yrd1ZtYkljTTF4VWdMQ3Zl?=
 =?utf-8?B?dzB4RDFQdXg4aUdYYm5MTW9VVmF0WE85ZGRJanlCZk5CTytic1ZpZERPZXl6?=
 =?utf-8?B?bVpUUEphYWZXdXFrZmRha0RqWmZ3UjNQQzNpL0RBUDN6Y0o5RVFENG9FdGN1?=
 =?utf-8?Q?pRBamZigJge9HvMU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	teAORPv/AkUlS+yOGndDpfNkMCeZrWGonmvh32HMqga8SqEY9jvoU9tJxxLOLzSpDOk9PZ6GCvMqTWkZ4CTHyPBtH8wDSrKlaAsOmF6Y3p60MRSm9wzNKtDRsp2GviRRJL2BCrbP8oM0fUKDM+CbA8z0zfEMhaYs6U2owX5xCnohgPtMdUsBm6O5EgOi6uwtzfa+qXFBwTq0mzM3RdtdnNo01lWE2J0UatBK1og44onBUHhwZlWbaY1zpS2c945NcAacFazzz1jKkG3Em5jQTYwLKCZR68kSdf1PYm+o5CzEUvVT0ycoluk0gYh+eqkRvre0xkoTHmYEinv2l5uB4HodjGcaE3aDfbGidkrHpStUFU9/ZD0rGUffB1b3MRnWeHHddyJdT7G5f1i4BTxqIEGZAQSbaiuFrb5KGSz0OLetvKX7trROgClagKnM591rDtauZo+0YopnsO/i5ksN87J91WOVeKy3ENf8D8vN2pDwxGKLieJCUSFigaMhJrmRZFquJ9Za/f5xC4GtPeerqGQEqlqFYfVsEzpRwllHg+rIGOY5np2U3FEnnBR8T/S2p+/TnbFleQ9guAHFVZrnO5f59uDp6DGdK9IN97GpJ0A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f44f9c30-f126-4b2d-2cba-08de6d6e5596
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 15:16:18.4515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1QpwJmfS1aI//HUAkUT+9MrSfF/jqisKErx6Q4/GjMi5JHCHo7MzTXLgcob3bamC22M8bXAQ2Egc98IUM6aTBBgmGrW5yE7GpJhdcqBpwhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6213
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_04,2026-02-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602160130
X-Proofpoint-ORIG-GUID: 5Ma5-LEb1oxGVfaLynZCFgfu3gTZv2Zm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDEzMCBTYWx0ZWRfX45/J9b6wpZDo
 o0DgHLtpFMEMOWILWRxqzxeTaHsJWNit3bEMVYFy8L/boPrRGs3WBMhcgmJmgAKebQcWZLiSIHG
 WWyr67c1yy2y/sm115pLK9rbf6q9Pzp90HLHW+5gPC/KLsOM+iZUTF+vzM+T7TfNg+zqoeETyuh
 ekYpRbOWaDg/rhEAyrKGVbIsAyG/BzaKkdAAjnT5lsHBAvov0jy9eRmp7EIsSrTCO/Z4AxOHdIq
 1YXPWr7dytRiFnLVce1ZSa+tKVWS7W7PW+tYD1JzgeUZGEoothGLhIhziz23dWu18BIHjw2C2g5
 WV8MC5GkXln/Yb/gnvizxg8F8YXAMU2q7wvBaevk92hdLTBNtD8CpML+k9+f1FRygPbJf87DH3J
 BvwbCcFts92lacVyxXPrFTRXyg7HmQgDGVVsLHrrtc1rRLOTGBnislfDNc9FrJJ6rfvv1hdZTq3
 UFDXdAsWfDOg6g8H4hQ==
X-Authority-Analysis: v=2.4 cv=SI9PlevH c=1 sm=1 tr=0 ts=699334cb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=oDpMrTkGYTetUCWMMwwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 5Ma5-LEb1oxGVfaLynZCFgfu3gTZv2Zm
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A33314000B
X-Rspamd-Server: rspam07
X-Stat-Signature: aq49tfu6e3du5r98wmsqfoo4x4zcggd9
X-HE-Tag: 1771255014-425363
X-HE-Meta: U2FsdGVkX1+KfyvGc8sXct2y53xRyb7Xtl3WyhC0JJGuD1Mn5Drk2Ed6xH3AcXZHoPV4+XE/lU2evEwSvUT5KzJa+uHUiKaX+5mP3SyQHt3lGsKFnMQzsqsF7Yq/Lg16z6p7GoBH/oHv8qlEs6ymXYdOp+5ZsB0UY6PWtA9y/eE/wUnMT5iKp766ce0uL1asVnHnlwGOzuZ69huKneLcwPnV8YFE9Td3YB3bXMP7Go5GPV70FeV9Gsr+TSj/K0TrbH1sctz+4JWe0JKDzGPZGR3ay1X/HkFxhYtgLmsshSu3i0q76qN8QAL7jW58dRph/BoMJ7VVqvuboHVlFaoeCELhrGDG7ZQEA74CZwPyx0gWhfZ9HXU4T9X6YAkHsF4y5+cas3JaGOlw3lm+c+n9m6uz0c6RijucdwogT2zZpf5TriqLq8PQ+pTbk2M8eyXAO0uz8A2VHnN4cUdV2xVLo3hO5C1DqNJfzlMbse00MY8mO24UhbT5Xq6ZdoxTWnxSdFN5Vk7JFNs5T1YtUBk7AsULKj8WZ7IyBhtdiD/KLCjUllb6ZEJRvOn4cOSz1v36uHm8goRKRK4sHvmyoytn23b5e2HFymeR9z9/4AII2+wKNyTAGuK1p5x9laFRSc/WIkZPZdFTwNRU7auJlXww/USdXGQrCTOhszM8mSthRFUEso0fdmEqEuSTFlNTF4pYdIj9dYeFYvIup0Fbk8lHJQ9uwrRdhGGkwTOfDWPyqrpV4t6A+gs4zjN/DlKh7Mu2i0PRp1kEr4G1dznkB/opf4V70m++nRB+TRGuqNMQn+pwBU9cXla5vRKWdt5DDPKuwgrhQ610J6Xw10P7A25PFR3aTWELRvDjEQzPvTjkr/pEixgBBIwx1VUtQciEjO7AG0RBPz1FtzabpGaxbPYR2SXD/U29n93I4x3td4kiV/wKI8SyjaHHyt9CdqhfrkOqugL4YtAyepCoE49cLeR
 9WCQ0jOh
 sln7CvyDxcQIf326R+kEZfg6rpZDJqfBLyWT/FJBr6mISHWavJ6/inp8XqPt81sIiwYoqSY0X7ow6eHSYQIPQqx/Iu+4Xiwsy0NQnKMoT25vFxn+D3tNSoWkED4TgPYFORN2oL4X4uBwpju/ozRT+vpsOGWwePkVadCFix3ywr1+8zpOYXiLPcDky/CG8pzb8jf6rlGgR5IgQ8B5fcGkiARyEZ3ehIA5E86iiYnKey/Y7cItvnVU4QOADU+aqhO5N4nes77TuS9zSWEbCdrecZx0UFvXcHlu3q0DPBh9ZmDnDyUgHQbDvZu261JEVtezCV2cuCRh1kGC6W3JUx67tX8uJliqmpdVluLwUcNlNakB8foT2SAnNHRL5u6aOgPKa2mC133yaUvGHCbC7g9vMpVbtqTUo8M845MIkP1bvWKdTdqI1v583aYCT0A1/1mdix3BReErSz8bv3rGaY69VM+IxWSTvw+uiBFuac0ZFZV7oG/8J9QrctLvAvdVyoBt5G+wccWxBf97EwD4EZdYzbhSPjZdilZ1f13sqSAprqjrNHv2SFriV83AA744kmjDMkakP8m/HfIUcNg4vifYWs1CMB5SJ6CQ6P+PhXxwFDX82waesM5Czq7bVuxzkVQqFlWw/Q3+f9ZByw/Y7q6LupV4MhXaDv1IVsc7o/+ULTEt8xxefGq7r0uWA7NScudisA0ate6z3EQripOog2VvkTesLNPrZ/VbOdvQa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 10:44:03AM -0700, Nico Pache wrote:
> On Tue, Feb 3, 2026 at 5:09 AM Lorenzo Stoakes
> > > ---
> > >  mm/khugepaged.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 42 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index 0f68902edd9a..9b7e05827749 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -460,6 +460,44 @@ void __khugepaged_enter(struct mm_struct *mm)
> > >               wake_up_interruptible(&khugepaged_wait);
> > >  }
> > >
> > > +/**
> > > + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
> > > + * @order: The folio order being collapsed to
> > > + * @full_scan: Whether this is a full scan (ignore limits)
> > > + *
> > > + * For madvise-triggered collapses (full_scan=true), all limits are bypassed
> > > + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
> > > + *
> > > + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
> > > + * khugepaged_max_ptes_none value.
> > > + *
> > > + * For mTHP collapses, we currently only support khugepaged_max_pte_none values
> > > + * of 0 or (HPAGE_PMD_NR - 1). Any other value will emit a warning and no mTHP
> > > + * collapse will be attempted
> > > + *
> > > + * Return: Maximum number of empty PTEs allowed for the collapse operation
> > > + */
> > > +static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
> > > +{
> > > +     /* ignore max_ptes_none limits */
> > > +     if (full_scan)
> > > +             return HPAGE_PMD_NR - 1;
> >
> > I wonder if, given we are effectively doing:
> >
> >         const unsigned int nr_pages = collapse_max_ptes_none(order, /*full_scan=*/true);
> >
> >         ...
> >
> >         foo(nr_pages);
> >
> > In places where we ignore limits, whether we would be better off putting
> > HPAGE_PMD_NR - 1 into a define and just using that in these cases, like:
> >
> > #define COLLAPSE_MAX_PTES_LIM (HPAGE_PMD_NR - 1)
>
> Would a shorter name be appropriate? COLLAPSE_MAX_PTES_LIM(IT) is
> quite long. Can we call it MAX_PTES_LIMIT or KHUGE_MAX_PTES_LIM?

Yeah sure re: shorter/better name :) to be fair my suggestion is pretty
terrible, kinda just getting at the notion of there being _some_ define.

But MAX_PTES_LIMIT or KHUGE_MAX_PTES_LIM I think are unclear.

MAX_COLLAPSE_PTES?

Cheers, Lorenzo

