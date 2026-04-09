Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8648F364B8
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 20:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08CCB6B0005; Thu,  9 Apr 2026 16:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03DAE6B0089; Thu,  9 Apr 2026 16:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E208A6B008A; Thu,  9 Apr 2026 16:17:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDAC76B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:17:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 936BDE11ED
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:17:06 +0000 (UTC)
X-FDA: 84640126452.22.C4FF14D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id ED47580008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 20:17:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U+GupMBf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EHWGHSgz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775765823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvpTyBpqhhQyghiU0zw1MYWQ+RHKGYmk3Gn2A3sCVfQ=;
	b=6WHUUILLGrO/0wBAbdzhHDXzjfPnwwH2dWB3PUC+Xx3/jAf6+RNtWLlx0Vda52AJqptUNB
	2cStA0MDLyYWUCP3jcjxVq+IKL9faCSG43K1h4ci9nrTaDDOOD2j5d9BvGWBPhTuqysQJs
	xQcDbndEOHLjFYvrRwWJN1905XpK0MQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775765823; a=rsa-sha256;
	cv=pass;
	b=RQ01q77iBfiOLe7tanM65yCQT96yrZnywmB14V4eeJfTW512SB5NGCvQuwe20zqkibX/mY
	Myy670gYdI0B4JN9RF9iY35RBa4DFD+O3O53HTRDr4Zfw14IzEnUMC/C28kZT4OlPQLtwJ
	h5eCHFHcu8HgsC1Rq721shEqgi/dvb0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=U+GupMBf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EHWGHSgz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639JtfIF1319449;
	Thu, 9 Apr 2026 20:16:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SvpTyBpqhhQyghiU0zw1MYWQ+RHKGYmk3Gn2A3sCVfQ=; b=
	U+GupMBf92firVf7vn3Yg48zBY7OsUZja3VgBBKhA5xeD4iERpzgBIIbPd1YE7MA
	jJ9tOd8YtD2AU0IAksjzaSXUhAzDQ5u266bv3fMlw5IgR8z3RoTdjXAAtkTH73S0
	8+EvI1L/kGcygJKBPEpJmcTPVvFayo+o2EY/7AO10nA12FCx/UKUovs3T7iFI3jR
	5bEewvbNBCW+QSaG9njIqqZXL1XV2jGFPdXDhPASTIy6kGfGsnBnUyo13HfgzlQy
	RO9BRo+A8SIRGZ2pVgD9sQD/3SZZIIfIuHKyc6mPIHyG1iYSbOVKprdmcBePSGIE
	DCCMuWdQMcFR29iPFCb0Ag==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqbr2bs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 20:16:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639JO1LM006994;
	Thu, 9 Apr 2026 20:16:57 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012062.outbound.protection.outlook.com [40.107.209.62])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmemp5tq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 20:16:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KNBy5a/YqK8oyOR0UApLxCUdupSYOFR9KFkgOI1P97w8pP9QhZs8nn7uEPPYYkveGli25MZQcOA084iUZI5whQmz4k8RDO4MHLFrStZtxDhjGvLDGmL0Z8fvkpP+8wBt2AHL9lDzoKyQYCpH8acXmjM9z1MRa2fa8g/kHxE1soArBJx7u5jKxiGyItS1+TW99rDFKr0zQh94nsue7Rqt6/EK7BEsYtutU5Ouraty91axUWgRKG+K6f3Or28KkeVkIbLtqeI48XszOiYxFs5H5rVjp9qS90IrT4Nzr6qJIpvU0Vpdt+RjwZ8Z3KOGzzdqVY2kGv+EPyvUIcvq48iKnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvpTyBpqhhQyghiU0zw1MYWQ+RHKGYmk3Gn2A3sCVfQ=;
 b=JLdykGXmvIsPPotjNiaKzd2btshbT7s5fvkpRzHM9XdioDl52ThMW6aJToNyN9PKe1RPT28DsEUIRAhRR2e/MV2h+828eZMJ+S5UEqw+OvDNnqw6/yTTx6rzB1NP2oGHN57ADrpXJDF4VJQM4pfYEy5RC4eJegKK3RCOzU+fR3kjRaLWHo8rMDBfFoHdUOJXXt/dSsB1jN1jwsLukvqj0JBvppCJg+N+clSxVf/f7GFt1tfWdnpD38S3YIcnP8pAYO+Z3InLFs7Ysm2EQKTis9PkHwhtyKIz9FHaKHKSSt2SMyd32WNIeK1gYWsbvqb4cKp8ifHeKv7rtNpwRwXYSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvpTyBpqhhQyghiU0zw1MYWQ+RHKGYmk3Gn2A3sCVfQ=;
 b=EHWGHSgzQ3sOySqHN4gbPq0bBX1CcXi9CdjDEko8QBr+bs6C4lcqFj3skWjJ9fZ5pgXVTToQsGQAFPxIE/cMG42FbmOHeYmiumdRs8uXVlOq9AJcImZM8uDX+3zfpD0xPrV27aPZ2Ex1y1tJPqKW4OwMUpZIocp+W6ZXIrEBxZw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB6506.namprd10.prod.outlook.com (2603:10b6:510:201::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Thu, 9 Apr
 2026 20:16:50 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9769.016; Thu, 9 Apr 2026
 20:16:50 +0000
Date: Thu, 9 Apr 2026 16:16:35 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: "Denis M. Karpov" <komlomal@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        harry@kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
        vbabka@kernel.org, jannh@google.com, peterx@redhat.com,
        brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, usama.arif@linux.dev
Subject: Re: [PATCH v2] userfaultfd: allow registration of ranges below
 mmap_min_addr
Message-ID: <jjhjdtdg5o72rlff75hs5oqaqqshmn2m5vfgjuew76dmjd23le@nw3rb2zw52h3>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"Denis M. Karpov" <komlomal@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, harry@kernel.org, akpm@linux-foundation.org, ljs@kernel.org, 
	vbabka@kernel.org, jannh@google.com, peterx@redhat.com, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, usama.arif@linux.dev
References: <20260409103345.15044-1-komlomal@gmail.com>
 <d4xigmgectqbv5q5dxsrlunea3ynexa4ym4nuxy2rokrawsqu6@yfhzm3hl5nya>
 <adfDCpTH9n2lG63n@kernel.org>
 <CADtiZd0NF8=4YDs9YR6vKYK92SKYOFd0LR1R3w9ZNoZW4cy+jg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CADtiZd0NF8=4YDs9YR6vKYK92SKYOFd0LR1R3w9ZNoZW4cy+jg@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0252.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10f::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB6506:EE_
X-MS-Office365-Filtering-Correlation-Id: f60ae618-1fb0-43b3-4bcd-08de9674eeb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zK2fLatikSlsWaVoch4sBfNzo/t2tBgMA0HE+hLbQuRsArzvSPZAAB4W7WDfZyQWgWvLYsm6Ku26K8Ah0EqIdvShp3ZVjtMmZ7FAH52Hunfq4ab+sZAiiXBh/gXnTfDpi3dpveqKayPaIgH5i6Jowa5P+TJikcvOB/tXAMUc+xieq7stpgVuPoumsbPuyOsOX5ZFYNwYejrfNBIFDYd5+61RgrmAVsO9MX4XFMFIR5oKa4mY/o+ZMuNN3FNSkz0kzpLCyyXAs9R9yiRBt4tkPIejG2j48sRl8N+18IvFJK/H8Iot+Xv/WRQWg9UC20VuCbkgEvkhhc7G95DJcn6UI66gAmyiFDQXqa/N8Wwi3LRNbTZAwIBOwyKMuO9VDFpbz8Sjp3uzAumae216d8OiIwMON5i/HFltkuVmqDwjIvhtO3BulsLmSKUNAyowAuiXmhWuxIcZKYaqEiw51FJGBo9dyL/8pj5iUo0ECpDJ+ekU2jitB9QbUb1JeB3n8Qz0YJ3kYxBRgOtkVGS2ESUxjdJhrxLDH510TI+CJUZ9p6h22wEd9nDMkLan2jGqT6FMvS7hs+Sqgd/1f7HSKAXaRbp/54wB58M4i9QHUG1FmISz+CnIM7guiiwkb1OXHQuQmejAgEJCUwB8rkPr3E0iU9buQG4AlAgrPNHNH1ZnJc8wcTNEAJ9Pp/MJoufQ1m+jLqN7gIacI5f5rY8mSHv+HhxTRjnO9ewyF8/hKxbgCP8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1psTG9MbjNXSHBVcDBpSjZYb2hFb1ZYZFl5YXBpK0NNdUhHOHorUGZHamVx?=
 =?utf-8?B?bHF0NllSUXBONzd2RVBGZytOUUlVcEdsYmRuT1VieFM5anBHNUl6cExaTzdr?=
 =?utf-8?B?MU95SDNmeXA2OU5wSVMrbEJBSDBySlMxa1lXZFBSTjZpMTNwSGVxOE5vYWJD?=
 =?utf-8?B?VXFmTWNmcnh1aHlmWmtNTFN3d0FxNlllbEVSV2hlVWhNc010NnpsRkwwQlN5?=
 =?utf-8?B?b2w0QURWUVNGUFhaV0wra2NhRksxSUtsSjR2Njd2NXNGVjV1RWFIeEc5anhK?=
 =?utf-8?B?QTBmczkwbUtQVTdvUGUzYk1kZ2dUZXc0Y05UTGMvSjliM1BWTzh5NG95ZWNE?=
 =?utf-8?B?L1hrWDJvL0RtVkZOWU1waTZnQktBT0NFODBVS21iZmdPUUNXV1NpUVFQdXF2?=
 =?utf-8?B?Y0JQdVl1KzdrTzJNbmc4eG8yNDlOTnc4c05nUFk5RU1zZ2RtdG5FTzIvNmhz?=
 =?utf-8?B?dFRDYTZ6MFBZTVgwU0ZLMXZxdUVPaEtzWHZ6NWZXRHduem9xUG5KSlhNNk45?=
 =?utf-8?B?OHZTb2NHd2krdC9HQjVHTjVUakNjbnVaa3NuYnVkSUtWQUkwUGlDc251MjJB?=
 =?utf-8?B?Y1NnNDVEc014Y1pXVmtyb3BQMGg2ZjlKanZMaEQrRXZYa3E3am42a0ZqWEhp?=
 =?utf-8?B?MGRoVmNiSnFpVmtVVkZvS3lyNHpXdHYveEpwcENCWGJZa0NSMVNFWG9TeWZi?=
 =?utf-8?B?ZEUrRVJ3TlUzUS9MNUZDaktIRUtwbVpCRGxjTmFSdjZ3T295YVNUdHRvR2tw?=
 =?utf-8?B?VFlFSEUwaUxselB3UUg4WGlwR2VmOTErQW5Qck9QZFZGelZqUjdSVmozWlNx?=
 =?utf-8?B?WkxRdHVJTnRwUkloTk0zVUViYUVRZnNnc2VzRDlhR1pOTGFiWWdsYStTc1hr?=
 =?utf-8?B?MTVkTE5XeTA2cm10amY3S1FIbWdObUNNM3ViY29VRkpKV0hFb1VSMUZmTlRn?=
 =?utf-8?B?R2RyQWpFam5nUDFrZ0hpcnhzZWhHdGZlVGZIZzl2TXhYQVpic2JBN3p5RWVO?=
 =?utf-8?B?T0RDcEZ4Nzl4N29sb3RzdE9CZUVNSGVycTFoRGFzdWRnMlI5c0VwQWw1QUhy?=
 =?utf-8?B?YUZwN2gzSE9VWjZoSjJXOXAxNitMbDFtcWJnalJ6ajRaY0RjdkFrSzNjcFFj?=
 =?utf-8?B?VkNRTjdxdDBIa3puT3ZtZW5oUHlTSGY0cHNZNndoYTNGbnBPR3RWQWJoNU9T?=
 =?utf-8?B?T3c3ZWdaeEthWTQ1aTEwQVllZk9QVFQzV3ZWc1J1MHVTeGhtZDFVS0lLMm1q?=
 =?utf-8?B?ZzU2WEhrSzBTYUh0RVgwdzY3ckJLYUdCa1NocjdVcXptN21vZEV4NWxTV2Rs?=
 =?utf-8?B?aERvcEFGT3JjaTJCQVh4eGtUUkZqckt2NjRoQit6TFUrSFBBbnpzOGk4ZWpu?=
 =?utf-8?B?SHhYenIxOWg4K2E3TTBZMGJYNjZVL2NZSXR4TjBIV0h0QnB2L0piYm1OQ3JV?=
 =?utf-8?B?cVdGUEw0Q1ZDL3M3Q1hvazRabDlwY1BQU3FsRml0VDZIdnFXQ3hiaTJEcldi?=
 =?utf-8?B?MStubVlDREk5Z2xVR0prMy9KN3lnN1o1bHlwSGZRdkNnK1loQ2pPWVVJdTlx?=
 =?utf-8?B?WEdCazcxQWNTMm5RZm9Ubk9hVENjWHdsR0l0OENiOGh5eHVhY0gwZlFFaU93?=
 =?utf-8?B?S2NNMjJjUzM0RldrbFFmQVdBbUNGU3Z0bjhhUWpvaU15NDcxdm9ZWUVBd3BT?=
 =?utf-8?B?TUY4NUsrVlVBcS9wSnZTczR2SkxUL1lnMFdIRVVONFBta2tZOEFPbVFKYXpn?=
 =?utf-8?B?eUU2MzF6TVVtM0xRL3VZWDVLcnZTWkNoV2pWdDliOWRxWlFOSEZ1dmpnVGl0?=
 =?utf-8?B?VkxYN1lRSyszVkNnTGhyOUdNaTNjb3F0K2RTeGx0NW1aWVFKS0llWi9scmMr?=
 =?utf-8?B?NlFKTk1EVXM3K282dS9WbUNaMFpWV1ZUZVpTVlAwejJRbWZGU3RhSVpQbWh6?=
 =?utf-8?B?L01CRXBXQURMTDRWMXZuQ2ZBUnpqdFNmcWlXZjZicm5FZTV0UjVzemVZSFV5?=
 =?utf-8?B?UXhtUEZwUGNMeXBmbXJ2U0cveFFubStWREw4YVRuTDJhOWVlaEdYaHN3WGlk?=
 =?utf-8?B?Z0dSRks1WVF0NVQxWGZ4ZC9DSzI2dGowbDhSVTUrb0o2Slh1ZEJodG96MTBS?=
 =?utf-8?B?TnlibjFPSHgwZDJ0YWtwN2hRaW5ZTjhzcWlJUWhvUkxSNnkzYU5sTFNCL2N5?=
 =?utf-8?B?R2hna1pnL3E4WVFrZTdGUUJoSmJDY1ZSdTRHczZTRHlkdmFEQnoyUGlzK01N?=
 =?utf-8?B?WnRoNjJGUGhsaStkaGwzVnlDWUVpMEJ0QXo3K29saUxWZWtyUUxwMVZPOTRx?=
 =?utf-8?B?elZBWVp4QVdwUHB1UXRpWEE1VUMySzRsRDJkNWZkTis2RFZCZ3lCdz09?=
X-Exchange-RoutingPolicyChecked:
	LY8h6M+OMuEVFMxtdGg7ywfw0nh0JEobb+9P3kK2Q/QYLewNA596UOXXAhChLtTFwpunqfcwLkFDxz0wWXRk4ljFIuFGaTmLE7CgMgF9Xz0ePjWYn0xT1QX8g3gR/LOIiMY1qvk4DPBT32qmB8LtA1yMXg4jUluKFVdtOjez4b5992ZRIEJsv3SaEHmF0P0xbAfpuHc1/814P7wXnma8k0Rt/YRTbbh2v19AZiKbh7nMPuSgEsrs2FMcsUMmQ8Cfv84rMoByi1BiUvxj8le8ITPUWPGGRV3ONOzMReR6yN0aiqaekv/6BNzoXKGB17LxxbECJbN0cD5dBdgyBIAJag==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zvefJ/Wk7pw2uu7FGou9Qp/nti3kZpO3G2SDsanZKjJqguszAJYw08bTfDwh1D5nq6j53fC5wDXDxuBBh33N9Mx7zctVKuSVVy6T+AV9XuZu+Bu1BBKHH9QanySFOu/zTM+/Pb4HErRbcdZZlAdPAukgJxBGGraXH3hDR+88ntSW/Fq3k1rt/xwsO4FL7X44ydn8v2KqDoo6AxVso7IteWUUdCqm39u4gVwlx9aCzvf35TR9fl23cj83lj3bSGYefzllpQTVQDvjCVruyAQNdRjeE2Gnlro0oFPfivK/azng3E+nS8XuECe8Rx4VQE7Fl6rP90c9jQNMo/X/3GCZr4JJv728lZCdpCj4qY+AtTIpGnDl4ftnFXj/BQHCoFeg6cZPLB47bUmX1zkRUMdMetLRzFVVYw+/6RNskMrEp3kQdF7Wa8gD6QtsvVCBgGstcxAB8q7Kk65cOsXLnKXOekQ6AheQjkqOr65Cx0cr7+rtZShCfg53U48J7tjJchRcj8sd2GcmTD3O+cKT39m6Ud36D4SSAumrHtjxNVZXEDcuBEj4drWLs/6La8mEuS4oEU81/+tBo7inLafrQBWh8eTL6pfgKo9gMM6GBtiPfpQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f60ae618-1fb0-43b3-4bcd-08de9674eeb8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 20:16:50.0295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8zxJ6eQf7vhsVK4vt4sGkRaDeRiqTM8DGdrjmZBbh5fDO6wXq8HDEYjjySD3oK7fqywoseGBM14MRXQSoRP0fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6506
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=827 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090186
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE4NiBTYWx0ZWRfX1gth0SEgDiE5
 3ucd6DAFLU9pN61OOsRUoOHr/NK/EY7xyLHbd6hYfY7J2ZntLq+uXeOaBMv/brTc+rohjx/TYmP
 C/Fyo9nmxQGtc9736YYnckOIab416Dm7q0PwSNbC9nW+wI3XDE0RXHWuIOfMvLIruZ8EosE1/k1
 kxTnOFY64X9MaJ+U+eEYma4dO9JoFQFTSy8p2/fzeFspBv9v87PAd9EoiMWhvEf0jsctfupQGkM
 cSmXJVBaKeebx6xl7XB1fOPW4CAu22fEPg2W+vgVv9Yhn+YVtvkedMrw4/DMm1AV6guvyoNp3i6
 tfiPoVL3z4s4gpSa5E44DBmy2agoclAq1VrMqQNOzf0HIQRcAko6MzwIijCtjFofDHXtc2e0NDP
 LivE9LMC2n09zjDb0G0PNpe3enmjwe36yKP/Ednvgqzrk5GrApZVO3MRQSQnV4hQU/idV5d+uil
 Avmk7ScqvjAIX8Cv3Kv2AzB9RMgRNl6mBmEhmGQA=
X-Proofpoint-ORIG-GUID: s7GvNf_rf79_jeEhSW87YobNOmTBYz0Z
X-Proofpoint-GUID: s7GvNf_rf79_jeEhSW87YobNOmTBYz0Z
X-Authority-Analysis: v=2.4 cv=KO1qylFo c=1 sm=1 tr=0 ts=69d8093a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=pGLkceISAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=5O_fBRzw7RBscesw5w4A:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13825
X-Rspamd-Queue-Id: ED47580008
X-Stat-Signature: nsmgonzce1sa3eom1w6tzwirosfujspn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775765822-423839
X-HE-Meta: U2FsdGVkX1/nSNaRCi2Zf7Tdm7zlDRGL2srlWIo12YeQ+YLxKZZ7x9Hxt0sINqbGC5YiVOLNWoSxEqHQPfzcF1drJ9Mf1EvttM83Q7rOPG/XRyFKSmP3ysMZ79zF4GlHR6XmjInUcasoqA33b1NFhT8BcwZDEzfxvDY05qx2WeJD9RAaMdJFTApXM0hnsyXFT0lnKCgJx+ewIOJ4S5X66ou+1G8WMkP79TDJp5j8LqAGEq5bvokUOzsN9Q5tVVAYqB5sl0LXI0I1zEG38cddl4h7RmcPc8kz4LNhr+l4HtIf8KZFMXETjZHVldwRf4bZeEhcdGbbBEqnwCpYAWg0iyvnIA1oWQLZaNmUG1nmmsk1yuLMHvmffVKTSNS030nyhBrhnbOIWy8QRbCHw+r3lf0C8uZq3Aqfcji8ap5VRwu/T0wjPuGIFbkd6oOk1pIkUlnHQPCbCzZd1FdshFhPqgGlzCddKaB3Y1qlsDitHOoF/zpeJUaYvkWkk7mm8/1VmwF79LuVRotPv58dHqIOkFY2VRpYlL0JfBL0pTpPlT7AuYsGXOrpo2ift2xfCzb2JcnzszI6747M+CLEEB+zIEUt1G8gkGN0is2WQbkAwILGyUeoUgpMszlUTRbvIHOr9hvxIaJSskN0vcBSi60VPri/flulAKQSEF3sh+4AGTAkfpodk/CLa1JeqenT1RvodXsIYP240qZ/Sv4jDNuKlsaDw8bbg9XpLMahSeFfgOA0t+KiqmYWcIMxxW4IJOMDDvTgNzGJvXC422t6+/f39HYNTS8uXGJh2MWGEP0WFUi2+0em7fBF9zn9mWdAC5mzEGGCYH/TJE1mkTWnQ4oRhgx2Fx7UsRZkICtPy3+kyscFHRpzPuUWqyw/W4UoTwvoM5/SEpSB3V/GrwlDUnuS0yYYFC/oiIMPRRHgOtM/ydYyTQ7azNqL2NZwynl1gPG86XEDx3UYE770XR/QFtB
 04rDlqmf
 f0kAt7Jemgu3eIEVdj+809GELhaKm2rmNAc5fiH1+Gi79u/ApstXaLfWIGXUH2tesKxT6o7JquXichy557TEk/mxDrnriC/ONPom3X8fE8xRVNpHFN/xEhWQgwVvOlXxxY+vk+9r900G6ArtgAxTVwl6jIuGrBjQi29KXjHLjsctvJrdhLIlvDdA7Ey1STrXe/pSCkNfDROH6oIi1JydG5yfdBXsT6C9bg/czUKycuxG3VPq2YuvZRgfA/w0pQwjzjyk6M0JlAOIegC4fIwCobbFE+JrfW2aUq6uxSuqmCaw0EEBZXmjs3AY1B67qdFs2Ax8VdgaGlG5nifWtnQ81covVJRy3GxazHK+rCyRTd90LAwhY5v0bM7W/K2B60wgrfC703lhWIxgPHapvDxXCXyUmBdBqBQZND4Ij1oJai7zCVq918CRA90aILW1jwdQs08axkGzSV4PG4qyG6gIilacfl1zhDcq+JpJjug+pGNJoT1iuitE0uVTfOuA8u0sK9es+YpgDsXu5zlR8GR9I+25UKhFcFIGuzxj0oJ3i2H2cBkm39WwRCrN0vefXn9wDxfAMWmiLcSRI5Rj4D6OfjRhjrxx0zarD8Ji7bYA71ngDphqUuRrDObKr4DP/SCHwZ7FeiuIxmFhopYs6cI36t4Hi14BicEvbonXkeRqmlla+eihi0inetK8urqpIo/7gGV3jZgQOHuPf0QzMOqlF+xgi1OyTdwrFCzo5cSgL0Z0XEmA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Denis M. Karpov <komlomal@gmail.com> [260409 11:54]:
> On Thu, Apr 9, 2026 at 6:17=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wr=
ote:
> > On Thu, Apr 09, 2026 at 01:30:07PM +0100, Pedro Falcato wrote:
> > > This looks relatively safe. However, I'm not sure if we want this in =
stable.
> > > This has been broken for 11 years now, with no complaints.
> >
> > I believe Denis has a new usecase that wasn't there for those 11 years =
:)
> >
> > Denis, can you share more details about your usecase for us to better
> > understand importance of backporting this to stable?
> Hello Mike.
> Actually, there is nothing new about the use case. We simply started usin=
g
> UFFD instead of the classic mprotect approach in the binary translator to
> track application writes. During development, we encountered this bug.
> The translator cannot control where the translated application chooses
> to map its
> memory and if the app requires a low-address area, UFFD fails, whereas
> mprotect would work just fine. I believe this is a genuine logic bug rath=
er than
> an improvement, and I would appreciate including the fix in stable.

Then you should have cc'ed stable (with the tag too).

I'm fine with it backported or not.

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>


