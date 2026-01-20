Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00FFBD2629F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 23:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B2E06B008C; Tue, 20 Jan 2026 18:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681056B0092; Tue, 20 Jan 2026 18:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50A6D6B0093; Tue, 20 Jan 2026 18:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBA26B008C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:23:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A0741AF6CD
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 23:23:38 +0000 (UTC)
X-FDA: 84353921316.05.71B6ECA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5096440009
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 23:23:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kx8XrIp3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HJMAga4M;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768951414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGSwoTvb3lbbJ7n8wBjk4DwoI3otQgQKHc+Glfqq4Tc=;
	b=rAdV2z0eTj7mjsXV2s4f5HnXdkApokBQaXLq73O+OhbLfJeAhjQWY+02LTTPdqTGpHulTw
	snYRrIp+HdUWLEcIibLVHXUxbsAv1pH8Af3iPZRsTjUUayCHS80qkJhq5eZlep8lK3hPfi
	WD+d5qYxs26gYHkdZATaFk/PWNnh++U=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kx8XrIp3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HJMAga4M;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768951414; a=rsa-sha256;
	cv=pass;
	b=J8wu+ECKAlggApPhQba6Pllr7ygS2ihsvqojcg4XZ4DZyrBQeWpQSl+wf6U6ES1FPC10aw
	4G05O3JUNLcm1l1dMeQU65txNPfjdHgmQRmNy3ku7iXqB8Vw6ilnz0oHom9Pao+2t3Su+T
	AHZ1ldq2GnxyqOh2DjJheC8xlq5+mN8=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KIhTFU3032109;
	Tue, 20 Jan 2026 23:23:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RGSwoTvb3lbbJ7n8wBjk4DwoI3otQgQKHc+Glfqq4Tc=; b=
	kx8XrIp3W7vHHuaBxpHOW/fr2pV4Un/hV3HWRvNsNrz8xE+gikZeB0tqJZURMx+T
	WaZMtfwwSikfn34ZggUDMCm9c5mf4RsZfekO44KmNUZDADBgSQYU7uz3g+xSdJ8P
	PttvxN18HHYyjefuwDRNINXJUyowmO/cj6pgW7PQxbidtki9+Ux3+o6fNruMEkyI
	blFK3CdGjMK+oqMWcrbXXoTV0E8v1IZT1SmpmqpGJasYM8jqTiXiaePadf38aHQ5
	dpkpvCqfuY/DXqRwZ2HurZ/m3hzw9v1hLOhSQSYch1YlKkEYUjhY03CYv3skNLId
	uAX4UUoiSOkUCZ4ht+dQcg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypvkyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 23:23:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60KMiUdx022453;
	Tue, 20 Jan 2026 23:23:18 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010003.outbound.protection.outlook.com [52.101.201.3])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0ve637v-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 23:23:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sRZ3suO1p+w9HLBOIpwrED50C+xRWQ4Wh3yYS7P5YIMghgUaDJ93AMKVWbmJ5pxNye8Y+W/xqdJg2/oPeM+JqTFVGQoy/mkbrnxxLkgbdCSGbXzlfN5FuHKree95hP+AMCTePAUZFuHt4tikVphdTGCrdVwgaIWsBsS8CueuBSFsOshtzmNgMXtJqCkf95cU50qGAiuYS8pppIhl4MQS2tY5PZDrUFS9eZ4OoYQeqIwazC52Q1qtLx127Kr7GN+wTDipVqhj/8YiBjhDiCbF8DhBs4rJQKQDWfuPOaaJWSvMvzvd8+NewoXCX8C9yXLAAhz4I1jvZdM+ByA2cUxucA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGSwoTvb3lbbJ7n8wBjk4DwoI3otQgQKHc+Glfqq4Tc=;
 b=bGELnX62rZ3KPsmUR6SVWlWHARmDThJpeFhSA4yUbnuogunURaviUY9/rmr0T7DGW8LAZltsyd/O/Mh31jBOW/9Z0PhAIKHE7jGShKqOCqWUONalh8s0Aq2KnTCpaPuseUZ2xXFWo3S03dq2bB5EySxtzg0yZSPMhJlmpFjMhPNbiBQ4o4kzuUneE61/dkeyQ+4anXqGHIyhVugRpNW1CFKXywYvFtyeCvFGVKRbRQ8MqQwq9Kx5lrPrPMsZ+3JMKr/1fTV3bQAo4mTBGYTEVjLzy4x8E2GOP2AhRSAukSxQfhAEXQGpEC2Mx4K4F2vuBa21P+TerOqPQP1Qcd+J0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGSwoTvb3lbbJ7n8wBjk4DwoI3otQgQKHc+Glfqq4Tc=;
 b=HJMAga4MrSF7FOOs6YW00gEiw/nCev30V9gw2PO3zlBxXEU2mne+cciqlzpy9bDwWsmjQoT1ELTCBdfI7hHVmGV6u6tgTeWc9YArT8KHMKgyQP/jpSff5u0F6ey6x8aqj9w/mqwD0xdXhI6v9m/CCuRcQPP88Axn7yL8TiBR8BA=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 IA4PR10MB8732.namprd10.prod.outlook.com (2603:10b6:208:565::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.12; Tue, 20 Jan 2026 23:23:14 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.20.9542.008; Tue, 20 Jan 2026
 23:23:14 +0000
Message-ID: <314b6f14-7740-487f-8b39-0ed1e54b4782@oracle.com>
Date: Tue, 20 Jan 2026 15:23:10 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] mm/memory-failure: fix missing ->mf_stats count in
 hugetlb poison
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-mm@kvack.org, stable@vger.kernel.org, muchun.song@linux.dev,
        osalvador@suse.de, david@kernel.org, jiaqiyan@google.com,
        william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
        Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
        mhocko@suse.com, willy@infradead.org, clm@meta.com,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20260116203834.3179551-1-jane.chu@oracle.com>
 <958f1e3a-3c40-51ae-8fac-a185e76aa940@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <958f1e3a-3c40-51ae-8fac-a185e76aa940@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P220CA0085.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32c::26) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|IA4PR10MB8732:EE_
X-MS-Office365-Filtering-Correlation-Id: 22fdd519-9e53-49fb-d1f6-08de587ae23e
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?WnovYXF1NUlUODdpVUl5RUhtKzc2NHlSdmxFdG83V0NFVzZObkJ2Zm5Xdklh?=
 =?utf-8?B?cE94dEVjV0dxbHNzZVBrYmJ2ZyszbTdGUmJYNjUzN29XUEhkRmVudm1HWEtW?=
 =?utf-8?B?MUN2THN4YUpSblJnYTZRaUVRYzNoTzNSai9ydlN3N0NEV0JPN2JWcGduaFZW?=
 =?utf-8?B?ek56K002WW1UR3JxS2I4NHAvVXIwY0R6aDZMOHFmc0VlTEJBOVRCTGhsWVdx?=
 =?utf-8?B?Z2lVd0ttUDhXRUdVZ0lRM3AzODlFcjR6MWxxUk9ZLzFRSjI1eUdmLzQ4bkJh?=
 =?utf-8?B?YkZwdHIrcko0am5GNzBTTkRhSXgrZy9RUVQ4NDFjZWNLRkV4K1pnYUw0K3pw?=
 =?utf-8?B?VXBVTlkxZUgwRUdlNDRGRExKM0VkMTJkQ251U3hra2xZdit3YUZxUTFFWjM4?=
 =?utf-8?B?U0JQUUxrWjVtdnBqUTk5R3JRWThUTUw5RmI1eDRVdHhES3FkNHpjSTlUSWg0?=
 =?utf-8?B?V1MzTDljSGZmWUJBZkN5aGhEYzhhK3ljaitvZVRoVUdYN1ZJMGNvblBEcFVW?=
 =?utf-8?B?TVpoQ1EwRjJkODhSRUFHWkRyTEhvc2hjVjBSSkJXd0w0Mksxa3JHMkV5Mk1l?=
 =?utf-8?B?Vk1RSE1TWTlBYkJQZVkrT2VTUE1sZXZNWkxhUUsyVmZFVUZrSjNxdlRwcnMw?=
 =?utf-8?B?d3EvY3FMRzhkS01rZUJ5UnhJZU1BK0xxRkhGSU9LaXFpMG5EWHdqN3UzVEFK?=
 =?utf-8?B?YWk3cWd2Syt0b0R4ZDVnN0VsaHZSV2FtVnROVkd1dElNYzV1Q3RpZzhTajJH?=
 =?utf-8?B?cEJzMVBKWmE4S2lFS1QrazUyWGRpUkFOVmpNVWlzTE1BejFTRmhseDltMTdM?=
 =?utf-8?B?RldyWXdNOXlZTHMrTUFyclNUTk9TQktoSm8zMng3czRYZWR0Y2wxNmRQMThx?=
 =?utf-8?B?cVVHK0p6QUdQTW0vOXlqRDY1MXZxNkpOU0QyMkFMdHQ1ZmQrK3NSU3oybjla?=
 =?utf-8?B?cEt2MDIyZmwxNlRlbjdveWlpVjRBbDl0L0RjQ1lBL3ZPOUNpZkFXSlcxSmFE?=
 =?utf-8?B?b1VsUlpuRU5CcGFWQUhFSjdidVRScy9DSTd0Q3RWYldWWWk2S3BXYWpxVEM4?=
 =?utf-8?B?ZUFGTXUyK09ocG1GbERobGhGSndNZWxYUHBiMi9lcERnRitBVGluaDNNV3ps?=
 =?utf-8?B?dkMrYWZpcVJnb3JTM0RkaURXejlCRzJWbVRBSDhiWnFwbFltMlpCcTBUcHEv?=
 =?utf-8?B?RUpraU4wRmJGV2FscndoSzJ1T0JKU1dLWGJLWVBVMHA0ZGVoNHhqcW0zMGhp?=
 =?utf-8?B?ZW1kaTc5bVc0NlVWRXZvTkpIMkhPenFwYWo2NVlVZW9hNmJuMklFdDZiTUV5?=
 =?utf-8?B?a0xyc2dNVHQ0WEd4a3dkTno0ZGV4aHJqcG5wSGJ5VkhrRDdpeFdaQTJUNVd6?=
 =?utf-8?B?T2JIcnE3VE4xVkVUdG1FYlV6V0JrOEdSWkkxd2lzdStHQlFDSDQ1OUQ3RkR1?=
 =?utf-8?B?blY1VTdHYUgyNmVhRmpjRnBGT3I4QS9GV2I3SHg0RjAvZTdZVHpLSmswSVhx?=
 =?utf-8?B?U2Q3K3I3a1AzckNBVWhmVWpqRWVEUUVKTFBhSERBVVAwUDBwRTFVNFMzMlc5?=
 =?utf-8?B?RSs1Ri9peWJGTFlGWmxBTEF2eDFHWWlkSG05dWJlZEUyRGZwZU5OaUtwVzNF?=
 =?utf-8?B?SE40T2FxUWxMZHhGRCtrSmZEenEzdXBjTFI5ejJHTFppSXE0TEEwbVZTTWxE?=
 =?utf-8?B?SnpZbmFOTGVzb3VPRHhSL3FFbXRaQ0R0WnBDeWVGZFZHdTZRcUdLYm5OUHJr?=
 =?utf-8?B?K1RZRUF3d2YzQVdRSG5WWTR6TkJKWVBXS3NDS2ZYV3FaZitEVGUyU2x1MWk5?=
 =?utf-8?B?cVFTVm9ZbUZQbWZ6VlVIZUdFWnUwZUpKYWFxU1V1WU5XRWJDbStEZzhJN29x?=
 =?utf-8?B?UzJkL0lIZUhWTHRYZmVHQ0hCOWRqN2RzTU52T3Q0Ny8wczQ4UnZndUV1c0M0?=
 =?utf-8?B?c1JiN2RLallNRnpnZ2JlUTcrS3Aydkt5Z2JnZjhOdUFLWW9lTXN6VUJYVzJU?=
 =?utf-8?B?djk0UnpDeWtBSERGdEx6QkdodU51cm9DNktVZVVFYjRpZ01UZGs2V1lwTytz?=
 =?utf-8?B?UER1TjU5TUREUldMMjVyVDFJWVcvdVNkUmZJL3EvdmVJbmJKV1l4UjQvWGs2?=
 =?utf-8?Q?8E8Q=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?Q2xaYUYySFdDVGNmUW8vb1hsUUMxOHNlUTNUR1RKNnNGTWxHYU9ZWHdYakdT?=
 =?utf-8?B?dmlhQmlTNlFKYitYbzR1UUtCdVRSbnNYbWdPb1pGZzAzZ3hBY0tnSzBzaW5Z?=
 =?utf-8?B?ZUNuUFpJdVJGK0R2bXl5UFNQL3VJVVMwNXIvN0F3bk84MTF2RVQybTFINHpj?=
 =?utf-8?B?MTk0TVBCZndNSW53cXBQaWowNlFqaEpZU240S2ZLS1dIdk5OYlNmNlgzSVkw?=
 =?utf-8?B?T25ETjV4M2J4MG5zcGtJQmdlV3F2MWRqKy8yV29PN3VBb3JTa013QlVlY1NN?=
 =?utf-8?B?UWdzenplRFJEb0o5aHhQOG5TR2RPQkVVYTE0RjlJdnY0ZFFDck82TjdBMEV6?=
 =?utf-8?B?ZzhEMFpaZmpETTRhUWs4eE9Dc3VjWVpNdEgvWXI0UEp4VjZrdnczZVVTbmt0?=
 =?utf-8?B?bndFYmY3eUx6NktCdzNjeExPSkI2WFRhdVZKTWtCaGZ3RklBZDd1QzNla1h6?=
 =?utf-8?B?Nm1oV1V5dzA4bCtKclpZdFo0TVVUZmQrRGV3QklJcmx2dGZ0YWJaU3hqNlpK?=
 =?utf-8?B?cEt4VklYSEZ4aGZpdktYcGlpSHpKckp4RnoxSzZGcHhXSk05UkNjRCtMc29H?=
 =?utf-8?B?dmZIdy8xaGViaHgzZUdZTitjNkd6MXpzNUFpb1RQK3JSYVhFWlBSMVpPNzl4?=
 =?utf-8?B?YjN0cmtnbXdTQStpSnpLRE04akVleVMwazA0NDJvYkkzeEVBRFM3UzAyZW0w?=
 =?utf-8?B?SDE2bFE4RGJoZG1lOHdlNHMvc0dpRG96b3R2OUI5bjlVUEJ0eS9zRmZHUlJh?=
 =?utf-8?B?VStidFI3QmE5TW9mT01XcDhqS3RnZjd2blQyT3UxWUhrR2ZmV1FJNkFWdTZn?=
 =?utf-8?B?NWY5T2ZsUmFDUEkxUTl2ZXludmEwVFpDTE5nRDlONmV6UG9XODdoMkFoSjZF?=
 =?utf-8?B?QjF3YWI4VjJKN2VlTERsdFg4RlRIOGU3WEF0dFlLeVRmUnIxZlIrVnhORWFt?=
 =?utf-8?B?M2xCb0pTUGdIbm1VWTRXRVAxT2VYYVR4c1QweGNDc2V5T2VqWHM0L3ZjdmI5?=
 =?utf-8?B?dkFmc1pRVWhEOElIWTA5TkpjeUxLK2M4L2l2VkowVVRVdXUvanUzTTk1RlJM?=
 =?utf-8?B?cVRYc3g2TVJTVU01enZpM0FNcWhGZjF3SUJobTdEV1N0NDNSZHNoNHRRTDV4?=
 =?utf-8?B?cVZ1c1N3Q0lhdit1bVFhdmRta0VWcEVUUkFkRnhnWnhZQ2VUbXRSYWtRL1Uz?=
 =?utf-8?B?WVU5SStvZ2ZLZ0N1S3VsaTFIaE1XOHUwTENRVkNOOXlJMkJqN2lSYjhiS1VN?=
 =?utf-8?B?SlJZVCtNZzdxY1VvOVpvWDg4QzAwYW5lblNZL0huQlJ2TWVhalZQLzZJc1hr?=
 =?utf-8?B?WFVLbGxoVHJZMEhpdmpHc0pFZTUrVUtRSDdxRVJ3bmhmUGgvV3d6L2Z2bVQx?=
 =?utf-8?B?WFJpTEE3L2hkOWJsdnM3M09FNnZZTWRDRUNsRzFzZElGb0MyZnhla2lLeWhJ?=
 =?utf-8?B?TFRwL2JRUTZUSmVHWU9SRkpqSmwveC9ZM1lTaXFCUlNET1pRWStkYU9PRnVl?=
 =?utf-8?B?dGlQdkxLTUk5S1VLNFR4YzZESnJucFgrUkZCUXVOYTcvTjl3Z3VoajNWZkI1?=
 =?utf-8?B?S0N5RFBMam9nT3ZlNk53bnhYWWFLSkdKbTVVeDhrRFdZb0JGZ1Y2bEEzZmQ3?=
 =?utf-8?B?TVJTYTRoRkRZWDBsYVp2VTIvdVFGMWZXVC9mM3pma211QUhieEw1MVRSeldp?=
 =?utf-8?B?d2JrblIxRmIxUDdZZlNlcllibEJJTFhUVzJEQUNkdkRXL09RYzFIV2syR2tV?=
 =?utf-8?B?QlRKdVpFSnJIcTdmL1lrTXJDTnI1NFZGamlQTXQ0Zjh1NWg1QncvV0NsR3Yy?=
 =?utf-8?B?ZnNseHFZZ3JaUk9ZSGJGYWNJdlBTOCtqTDJrN3ViQWphMjVmSmFaMjZSYXRW?=
 =?utf-8?B?YnVXc2hkQVZGb3lqVlh4elM1aGtKQzR5dkZrSTc2SW9OM1pVQk1jQmcvbGFH?=
 =?utf-8?B?OWU4czRSalB3bGlPZUt5WitUT3ZuMTFSUXdLTno1aEFRMzkrbXBvNVFkU21J?=
 =?utf-8?B?K1dGZDdtazZuWEh5dGgvd3k3WEFaZ29xL0NxcFlQdm9Nb2lTblZHYUVXdDg3?=
 =?utf-8?B?Y0hxb2l3R1p0bkRTWW9uS1hCZkJBR1ltYW5YT3lsUnZTREZEdjNmOXFxTnIw?=
 =?utf-8?B?ZEF1Ylk2NnlmekxVaG8waktnaWdqUFNka2c2Vnpuc0ZCZko0eGt4OHQybUY4?=
 =?utf-8?B?K0xtUHoxcDRvQ1FBVlZaRVBFWldyVFd4cUJPdjBlMG1QNHZCOHZGWThCYjdO?=
 =?utf-8?B?bkNKY0tJM3RYbjMzN0pFdG5BWG96aWd4eDFKTkIxQlU5RWs0KzgyYktXL2d3?=
 =?utf-8?B?QVBFdXgvcDlxckFpOWFXMEtMamhEOVFSKy9OT0IySXY4NHBZOVRtUT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bpRQSSa7xsL+DOZeMkQ3FETBNRymJTn9JGpzr6AvTJsH/YP0gdsF2alFiIJ8qcHSm1MfMlDG0+tIKDynE0XKLAQv/wKtJXpVK8/n7eJS/uhSKkW6hPR/pdfvV2VmGbnBHV5Z/M/oNDPFNYMgz0JrRFIOuDdhbKYplUFJw+rTMj85i7a0WDoxpKJ5NT0PEQRYQCB1WqXuwDhwllMsdOIJNJgNMnYnUnUmd5pn4/unDKjZf64ec2zMXBQ4bE7v0Mp7UEdVpP54iEUpBsEuEaBjoJ0CLyqnBoTVkwzokdlQAXjEUt2bDCVE33empoa0YZSALiEUF41PT+R41rv+AP+ruOKssfN8H2KypFBDCYxSlA3PXq/bTz7/06pXqav2E8og93JHPVONn7XvSHJZTjG9+qFLtv7gCTW7kiF0ZY+5nCPJ7s/dklzMIUTGy83LwO9AC4tHWxQtAO2vUBJ4p03gOTiUuPoAF0LA2T9rh1wjaT0G6lIT25MBc25LBpkpScBiAJ4Es366DjyO8yLcJSNd3SxBQ94I2ITEYnzZtvqqeJAnCeXpH8hpDwRlIGpYAqHedDDnwUgjVqqYg455kG/8AeBDfSudHdZLWjPfRU9S/U8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22fdd519-9e53-49fb-d1f6-08de587ae23e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 23:23:13.9933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5i9tkEzoDD/IpVzMt+IW9p9p5U8fT/70eyGZjCgssEoDDVUvVDQhzXzN6mmo0oB2ggCvpEwEbNuZY7OvGQLXiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_06,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601200194
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDE5NCBTYWx0ZWRfX/HC1FYSUsrDB
 7KqdkujSAC2VFB2w/ThUq6OT0OsodV2Q0jx5QUiG3zlpxoE5CLQrrqXluoZHlkyS9U2d4IxD5Kg
 8NnGO+GGYDve+0e83j7/57R8xw1tZviWJziyu3aMJxJxVdQc92eba11NHy62lPBbNcc70hCECoY
 Tz9TkmKXD2dVAX+dXqtxQ6Da9mPWNgIYmUERZrffsQWI8NW5A9s4Hg8zZ+yll3hqLJHj0cmHJPk
 WkhMlvhf/95FLm/YqTxGQF68I5lFCcW8W93i1xb0DpJR2b010eYlurDpmOJmlG9PvRhPeWZLohU
 r6dOmWaebH8pAX7pXa/GrN/6VYtIPD1AlQfEK1M/9NGV8TxB5uunbQJ2o/QowENRVG3hJKeEy8l
 mnhM2m66Gs3x6hd+AyNph1QsqLP5UMCNnUdzdBbv3wqGGzAEo/x7qenoasc4eg9u8IatiJvkFku
 P1C7PXcp0RVPQxefV9CYyXIwUN33B7QCagIfHUyM=
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=69700e67 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8 a=R80uGiLygrDi5ocMm8gA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: gps1EF4KF9hQ2EGzdLMo_J_zXTGhlwip
X-Proofpoint-GUID: gps1EF4KF9hQ2EGzdLMo_J_zXTGhlwip
X-Stat-Signature: adimhm4656t4dpj135smyuxbtt8xrbjz
X-Rspam-User: 
X-Rspamd-Queue-Id: 5096440009
X-Rspamd-Server: rspam08
X-HE-Tag: 1768951414-103063
X-HE-Meta: U2FsdGVkX19IwZQYn7zLk4UE6dhQyCTv1KAWgFldYkYA1ajiB5LGqIKV3Vii7BiZGIb3boOjKFnA0q9CG5tclEZbWmgUef68gfZQN0WPZrkcG6jQy6YDbHjncuG7S57o0vkRaDxol0DjdbxakQ4PsVLG2uiqFiA4zKWDvOJRjxH3olUjovgbfV0LEg4O2ggtp0RjHWoesxq1+2OUU3M47G105Ynp9x5f78IQWEX2uc3qK10Ct4a80+J9ndQerwKYlFkrg7l8v/U9q/WQXO2euL65+qHQ5qAdIv0YfCa0V+etZvQT0akW/Yg8lzO1agi+JgBDXwupxBN6IEp813aS1sSsX3BjTX9ENXA2Qur4YFmFpCdfIsPnixZX9aoz8f5DyMIGYbyjiLxiMNBLobh9DeuWDLUi6oez1XWakOjMbd/uANoUNWuA+313cSVKiEdlUVUO1hyj13o1f23dwsN/xOCmYKlFzzTrbIaCfBzYHrfWC9F7ef0eDhZVxpOJumqw5WKOqUAPMKK6Ye5Qw3hcrwNfwiXjvYHAUPEBGaw8slt6/qmV7jOXGaOHYUdg8NCDhoZ5f/K11mA/AjC1nrEoBsmZtK6qNEpJ0TXYlJq7Kive8DcdlL1qcDL16hlSP2JDXTbOY+1LKyNrW6JTL836imVb8BKi0SMhsTfDT3OqCyPQJFrtWUzkItIayDXyP4NLLVxdZKSS8TJ7KQ7YB83a95b1b9CWOl8oTh/YRU6zR9My+JxjVmrCXkmOeonofBbBdGV7xR2HicxeFFEL8pFfXEqtWoOE15PKZsX14heRGzkEvZi2eCs6NLRBJe/eo+7wQtPwUrmsaqWo0jHGn00qtknXIKJFV7SHXj7pYNLTb2YbAVidwNtBU5SgyCq10+ZNIJU49TEO1dBkAwY0CuTrqcszeHauGW5Am3WTy3hrIvg7K8ePhtSzD9ToTUmT8MDGhSTVwuKar6XDHWmKGHp
 qkUhSvbG
 7eAUhp9fKrAC6xhN8+kIhYk4pHPNCOFMO+i6tg60AySOzGFvSMIW6mn5Fbcn/3YLOiLYKBxS6kPvUWsR6OXZN85gPjzRQbuLaKHsQ+V23RYcD/XdgyZ+f60GrPtdTmh9cPvXjBHWwhc+zE0N19K1veDqRfp442np69HRqhAXyq+0xDXao3difl7i2n0Oyg468h8Ln9Vyn/rGVg/VXwYsbXAdAjIFl0LDMHcs8OanoBYWufx1B0fY9aJ5V5jDrwSGTHMX1PbzjQPXsIM17zyiNiV4bsGoeBFM9Hm4VtCGtFNVTrICfzWnux7fMOXmftxbdO9BSIm6SKpaps1IApdQjsk9H/5AF801iXwcNT/ns1wStADCEWqeoOT8SbbMia4cY44VIOwFr7Skt2Z+0k1qDnx2mg04xqZ/tI8AsYNDOdfiataOPjBMzqrIalrqYmpX0axW9clyIKu2pyeS2IdYVvkPe9vtttWt8PYMb7ncWckSw5pnOAFy33HbYwB3psWuBwg8loLm6GQTAfjpVqrieyx+mYiOUg2q7smZusTfvFI3QtlgMipORl98TmRkhvAGxq+0h7XdxLp61QVVR0Xh8tX8iLQJlXx4bmUH2V2D4YxyqyBsr2hufWudGHy7UCJsfZw49p0iSThW8JWwg2yYIuKp7CaNIZ0lnD+hRuTTZVmbMjdUsAlxFUfLi15PyUdn3eIWctMqQs58JJk2hKN3v2yln6kssaCjW5j8F9GYVeqy/v5QdCILXmZzyRVs9NeU1w8mgrWTKdKkugedXsuf8BbI3IA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/20/2026 3:54 AM, Miaohe Lin wrote:
> On 2026/1/17 4:38, Jane Chu wrote:
>> When a newly poisoned subpage ends up in an already poisoned hugetlb
>> folio, 'num_poisoned_pages' is incremented, but the per node ->mf_stats
>> is not. Fix the inconsistency by designating action_result() to update
>> them both.
>>
>> While at it, define __get_huge_page_for_hwpoison() return values in terms
>> of symbol names for better readibility. Also rename
>> folio_set_hugetlb_hwpoison() to hugetlb_update_hwpoison() since the
>> function does more than the conventional bit setting and the fact
>> three possible return values are expected.
>>
>> Fixes: 18f41fa616ee ("mm: memory-failure: bump memory failure stats to pglist_data")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> 
> This patch looks good to me with some nits below.
> 
> Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> 
>> ---
>> v5 -> v6:
>>    comments from Miaohe.
>> v5 -> v4:
>>    fix a bug pointed out by William and Chris, add comment.
>> v3 -> v4:
>>    incorporate/adapt David's suggestions.
>> v2 -> v3:
>>    No change.
>> v1 -> v2:
>>    adapted David and Liam's comment, define __get_huge_page_for_hwpoison()
>> return values in terms of symbol names instead of naked integers for better
>> readibility.  #define instead of enum is used since the function has footprint
>> outside MF, just try to limit the MF specifics local.
>>    also renamed folio_set_hugetlb_hwpoison() to hugetlb_update_hwpoison()
>> since the function does more than the conventional bit setting and the
>> fact three possible return values are expected.
>>
>> ---
>>   mm/memory-failure.c | 91 +++++++++++++++++++++++++++------------------
>>   1 file changed, 54 insertions(+), 37 deletions(-)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index c80c2907da33..49ced16e9c1a 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -1883,12 +1883,22 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
>>   	return count;
>>   }
>>   
>> -static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
>> +#define	MF_HUGETLB_FREED		0	/* freed hugepage */
>> +#define	MF_HUGETLB_IN_USED		1	/* in-use hugepage */
>> +#define	MF_HUGETLB_NON_HUGEPAGE		2	/* not a hugepage */
>> +#define	MF_HUGETLB_FOLIO_PRE_POISONED	3	/* folio already poisoned */
>> +#define	MF_HUGETLB_PAGE_PRE_POISONED	4	/* exact page already poisoned */
>> +#define	MF_HUGETLB_RETRY		5	/* hugepage is busy, retry */
>> +/*
>> + * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
>> + * to keep track of the poisoned pages.
>> + */
>> +static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
>>   {
>>   	struct llist_head *head;
>>   	struct raw_hwp_page *raw_hwp;
>>   	struct raw_hwp_page *p;
>> -	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
>> +	int ret = folio_test_set_hwpoison(folio) ? MF_HUGETLB_FOLIO_PRE_POISONED : 0;
>>   
>>   	/*
>>   	 * Once the hwpoison hugepage has lost reliable raw error info,
>> @@ -1896,20 +1906,17 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
>>   	 * so skip to add additional raw error info.
>>   	 */
>>   	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
>> -		return -EHWPOISON;
>> +		return MF_HUGETLB_FOLIO_PRE_POISONED;
>>   	head = raw_hwp_list_head(folio);
>>   	llist_for_each_entry(p, head->first, node) {
>>   		if (p->page == page)
>> -			return -EHWPOISON;
>> +			return MF_HUGETLB_PAGE_PRE_POISONED;
>>   	}
>>   
>>   	raw_hwp = kmalloc(sizeof(struct raw_hwp_page), GFP_ATOMIC);
>>   	if (raw_hwp) {
>>   		raw_hwp->page = page;
>>   		llist_add(&raw_hwp->node, head);
>> -		/* the first error event will be counted in action_result(). */
>> -		if (ret)
>> -			num_poisoned_pages_inc(page_to_pfn(page));
>>   	} else {
>>   		/*
>>   		 * Failed to save raw error info.  We no longer trace all
>> @@ -1957,42 +1964,38 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
>>   
>>   /*
>>    * Called from hugetlb code with hugetlb_lock held.
>> - *
>> - * Return values:
>> - *   0             - free hugepage
>> - *   1             - in-use hugepage
>> - *   2             - not a hugepage
>> - *   -EBUSY        - the hugepage is busy (try to retry)
>> - *   -EHWPOISON    - the hugepage is already hwpoisoned
>>    */
>>   int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>   				 bool *migratable_cleared)
>>   {
>>   	struct page *page = pfn_to_page(pfn);
>>   	struct folio *folio = page_folio(page);
>> -	int ret = 2;	/* fallback to normal page handling */
>>   	bool count_increased = false;
>> +	int ret, rc;
>>   
>> -	if (!folio_test_hugetlb(folio))
>> +	if (!folio_test_hugetlb(folio)) {
>> +		ret = MF_HUGETLB_NON_HUGEPAGE;
>>   		goto out;
>> -
>> -	if (flags & MF_COUNT_INCREASED) {
>> -		ret = 1;
>> +	} else if (flags & MF_COUNT_INCREASED) {
>> +		ret = MF_HUGETLB_IN_USED;
>>   		count_increased = true;
>>   	} else if (folio_test_hugetlb_freed(folio)) {
>> -		ret = 0;
>> +		ret = MF_HUGETLB_FREED;
>>   	} else if (folio_test_hugetlb_migratable(folio)) {
>> -		ret = folio_try_get(folio);
>> -		if (ret)
>> +		if (folio_try_get(folio)) {
>> +			ret = MF_HUGETLB_IN_USED;
>>   			count_increased = true;
>> +		} else
>> +			ret = MF_HUGETLB_FREED;
> 
> IIRC, code style requires {} here. .i.e
> 
> if (folio_try_get(folio)) {
> 	ret = MF_HUGETLB_IN_USED;
> 	count_increased = true;
> } else {
> 	ret = MF_HUGETLB_FREED;
> }
> 
>>   	} else {
>> -		ret = -EBUSY;
>> +		ret = MF_HUGETLB_RETRY;
>>   		if (!(flags & MF_NO_RETRY))
>>   			goto out;
>>   	}
>>   
>> -	if (folio_set_hugetlb_hwpoison(folio, page)) {
>> -		ret = -EHWPOISON;
>> +	rc = hugetlb_update_hwpoison(folio, page);
>> +	if (rc >= MF_HUGETLB_FOLIO_PRE_POISONED) {
>> +		ret = rc;
>>   		goto out;
>>   	}
>>   
>> @@ -2017,10 +2020,15 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>    * with basic operations like hugepage allocation/free/demotion.
>>    * So some of prechecks for hwpoison (pinning, and testing/setting
>>    * PageHWPoison) should be done in single hugetlb_lock range.
>> + * Returns:
>> + *	0		- not hugetlb, or recovered
>> + *	-EBUSY		- not recovered
>> + *	-EOPNOTSUPP	- hwpoison_filter'ed
>> + *	-EHWPOISON	- folio or exact page already poisoned
> 
> -EFAULT can be returned when kill_accessing_process finds p->mm is null. So it might be better
> to comment EFAULT case too.
> 
> Thanks.

Thanks a lot!  v7 sent out.

-jane

> .


