Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6D0A103E2FC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 02:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1AD6B0088; Wed, 11 Mar 2026 22:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14B4E6B0089; Wed, 11 Mar 2026 22:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F356C6B008A; Wed, 11 Mar 2026 22:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF7446B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:16:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B6E116069F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:16:52 +0000 (UTC)
X-FDA: 84535797864.06.1FBAEF7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0DDA6C0008
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:16:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kFxiqYHg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Lb3PRXbb;
	spf=pass (imf28.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773281809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQ3OZ4BwWSUVRHkxRiq+jhzP4o/RuT6cioXD69hxbdQ=;
	b=kmRw9WquPr/KiGOQLCQstmhnxe2GHJx7IGVsJ9AurSdIY4mOkVReiy+0KKC5qrmXd7wT8K
	4mibjk0V7WwTgJ/N0PR/qqUVmiX4ExWck0MAAYyAIBldJrXKtBQHsiCdiZT5f5s0/1V3cN
	0+kpyyTr+wBtK233jiBBRgZFst55Tsw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kFxiqYHg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Lb3PRXbb;
	spf=pass (imf28.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773281809; a=rsa-sha256;
	cv=pass;
	b=jv7/dix/o3KGsGmF1bKFs5chBgQaYDaMRuKPMFTRxMhy8K0SUJWbAhvOFsgjXzGBWsjEkn
	xhZ76ZUA9vV4+wqMa7AmkQ0W3aWEtt+E3lVf1jyPhGP6jr7xvj5bp2rZamYW868jaBKs52
	KTPQgYiGnhamHknTIqB+WJSmMRSbVag=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMMb4N1256390;
	Thu, 12 Mar 2026 02:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XQ3OZ4BwWSUVRHkxRiq+jhzP4o/RuT6cioXD69hxbdQ=; b=
	kFxiqYHgqckoJjichiI3bNUU5OMkJYuprzStCwdob02OVFF/Va5pcv5RsrjDIuGv
	afHgakZK83F0g4S3XV3Jui1TutXQHWiJzWusChlNX+S/ViUh/vXnnZ82kuo3N7vP
	93CoafQQ61tXSLuMf2XqrayQqMjKMgRdVJAIItvIYx2VTpKKl+cGgA1ypbBD4Q6k
	RiYvIZPDn9oPA2XJJa0iVvuCVlmEYeICA0DqjsGQd7noY+Y3t+Nol1xwRPQdrr6c
	qYf43u6R/0EdEaDj73ZcXGWGM5EN8/eI2aX9o8CIEz2Q6M42ADGDfrspauzHttQj
	xD7EdtUjv6gS0eEMG1PF+Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cuh4rg53e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 02:16:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62C1t3QI022295;
	Thu, 12 Mar 2026 02:16:37 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012027.outbound.protection.outlook.com [40.107.209.27])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cuh5jnenq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 02:16:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e4ogR/DxJ6RY5Jxc6sXQ31dvnh27qPWXhC4USw+qnfrWCL8XHu3ITgVBLov+dr/h7q337BsOgb9jjYUAcIDDdlt8GHIobj/t42cUa3Bw4WLmnreKyaSUDtapNp20DZqeqyajuWsrSmwNZsrsK0ieOwCzi37rw08mbSSK17Vn5soUjvAFQzAEc1RrfiF/Ik+cp/IoV9DIcaJnuNs5JKt7n54I5b3AAlWLSsZamVwWAsxOJwRaFLTpCQGIXUjVodbDGBSIVzxjItnSRlcQ0f8BMJ6Uv0waf4YjCEjqt0vsuGaIO3/SZviKqO5fQNMSQ685Ag4PuOfNgCsZNL+IbdUpjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQ3OZ4BwWSUVRHkxRiq+jhzP4o/RuT6cioXD69hxbdQ=;
 b=vCrDvHIYlfNBhSSNZqi/imnTlGFvbdPiGXU5ehis9gGYF+02MnwxXG3ZLOnjcJ91MqgO3p72oTgrQ1NGcFBf9dguC4xlqsvrA/aFECFUgpKDPYIv9v3UcyFEbbOXjCVgJ5SHR6rlkFGy+hfvswerZ89RQ/eXsH7tLEtpPoQdZkQX8VYSSn4SaS7AzqHduGLBL1/g0O+RAIjuU53XiQbWe2hgJGXOHdozgELePKrWClsK8JtuqsPKiRhxuzBRaiA0nXu+a6jb8VmN5BnHTGAAQroaYfdIbMkmsKGVd5qiAwSCRNrrkZOl21RYhI/vTIU2NGiCUwIndQnuXSB/qHeeBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQ3OZ4BwWSUVRHkxRiq+jhzP4o/RuT6cioXD69hxbdQ=;
 b=Lb3PRXbb44WmuLuPgqN74YdmQtxD4tiQcuUwRxGw6FKvkoQsqfKW9nwhPeRgwolxJRqcnpfJo/I2bulEvx1dFPyPqKLwj3OlyuA8d2JHMx8m7Wn9ZTUldWklRW7ptcQSfAy0E0A/8nVKAj6nWXi1KS4OG5OwfpGdTeK4pQ1AWnM=
Received: from MW6PR10MB7660.namprd10.prod.outlook.com (2603:10b6:303:24b::12)
 by BLAPR10MB4963.namprd10.prod.outlook.com (2603:10b6:208:326::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Thu, 12 Mar
 2026 02:16:32 +0000
Received: from MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230]) by MW6PR10MB7660.namprd10.prod.outlook.com
 ([fe80::c2dc:a34f:6987:1230%6]) with mapi id 15.20.9700.010; Thu, 12 Mar 2026
 02:16:31 +0000
Message-ID: <de35525c-4522-4117-b6cb-01d48325c4f1@oracle.com>
Date: Wed, 11 Mar 2026 19:16:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: prevent droppable mappings from being locked
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, akpm@linux-foundation.org,
        david@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com, jannh@google.com,
        pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
 <269b1a31-20d1-4451-b4ba-f55a67f27d96@lucifer.local>
Content-Language: en-US
From: anthony.yznaga@oracle.com
In-Reply-To: <269b1a31-20d1-4451-b4ba-f55a67f27d96@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:510:2cc::23) To MW6PR10MB7660.namprd10.prod.outlook.com
 (2603:10b6:303:24b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR10MB7660:EE_|BLAPR10MB4963:EE_
X-MS-Office365-Filtering-Correlation-Id: e9f07956-e4f6-4b65-1239-08de7fdd608b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	uQ85r+MzA5LrvUHpq1k6c/aPlxW3DhXyoaufufIJ28/7fdKDKAFVZoRbj24w+V4a42+xXvIZ/fxfzYKGRuF1esgmIKlq8JYH9OwU1OmuckvGsjhAIDyLceSA8UTwze0N8D83vcMhSymseaoHxftDjfpjm3A4vJcmGtiI9SJNvAkMPV6iZds/iKNwwz/c5CUgXaD8L5O1AjSArj2zxm50GE9r3ujXUGRbPPVj2XyYMif34YmhAiunqZ4DwATeSlSQ4uL6HqoSnTnKgCK7R53J06R0pbPpwJ1Y5uz7HTvhn+9iSkjzHd6+glqkv3vTnNeH6RLNfKmma1z1lYYC4IOmRUhGl6K9b5CnfP8DsUFm6rJw/4mNdpidpCCd/y4oKnATf/QflpU6Pk1appd3N7aL3RVhS200vyA6lQZNPnmlyF1kDmoInwsl06LQgoXpI3QU+xCs1bNjJmMsQPVAcaanIxHL7c09rLiR+pTue+taNt0/8yZrDH9flrZEkSKbzSj57lGM8Tyd7WNsUXq1ln/jWZO1wl+v1n9/bi3WFFq10jqPPiZmlFOzD9WgzlGumiDNE78LU4igFGv6o8Ez8+ETIYeAxcQeAIVn47vHesCFagR7AR+hmQB71HHA0uGimeH9Bsx97bVcQJxiy7lOhDmZ4rJors1ji4BIJ0vpEJf4v1yOHG3P/EE9ukL6Ez8uqDszdfcTjkNt+rFjFqQjhxLJT0sO24xIj3nMjgSUa0EApTQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR10MB7660.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2JGV1lPME1TRjRkSDBPampwZ1ZYSHBkMHNjWjVpb2FMd0hUOTRVcFFiWFRK?=
 =?utf-8?B?eXY1emtwRkN4ZmtRdEdraWpsdHVTNjJXMnlnVzRhR0E3Qm8xdmIyM1RGK2tU?=
 =?utf-8?B?WXMrOGxRK1RQME5FREhQYU5GYm9ZODFSajlMcGdpcEszT3RjeGxpREs2MTBC?=
 =?utf-8?B?RGRaRld0Y2hOeTlmMFRaTWIwRWRyYkh5bStZMkZaS2RtYkJ0TkJEMVd3a0tS?=
 =?utf-8?B?VEpXNW14bGNKT3FLaVFwOElQTEd5UGdTSnlEUmVzbGdWcTRIWVArMUJ4M2Y0?=
 =?utf-8?B?RThnVTkxZ1pvQzZiTEh0elNmbUZMaDUxQ0N2QkJWWkxpQUhTbTZCaEo5Q3R1?=
 =?utf-8?B?VDBwMXppbHNvL1pOa3AzWVJBSXN5UE84OTFyNFhnQjU0SDQ1cXE1VlF5OE5C?=
 =?utf-8?B?OXZ6aURmOU9KRllSWW15SXdick9LZk1MVXBBOEN6TjUzNWsxNitEbGdqYmFn?=
 =?utf-8?B?QkdIZXVJem1Ed0hkRHl2ZlhJWGFLZ0R6b3Y1ZE0rYWVabVdqY0tvOERubGx0?=
 =?utf-8?B?bjZmVks0WXcvdWNKeFc5YVZ1S3RVRE1KNG9COC9PSFNWYXpqVlZCUllvWUNX?=
 =?utf-8?B?NC94ZTI0K3JqMUFXN3N1eWNkQ2NETHRFdXc0akdXMU8zOHRCR2dxVHYxV0s0?=
 =?utf-8?B?T1J1M3dEd0lvaHVTRlJYeWFGTmlXd0NRMFE4T0hoQ2RCczkrbmVlc0QvcHhy?=
 =?utf-8?B?by93VTFnL1RiM2lrSW5FM3NYWWdweVUwT2t2NkhMMk5ZWXRoajUvMXoxWVFm?=
 =?utf-8?B?WC8yTkpNc0NSWVpuZHp4WU9WSGJzQnZYU0RLaVJZcGpMcjltNS9sc1M5Myt2?=
 =?utf-8?B?ZUxlMndrbzdZV3U0L1RqQ0lmcGNLTDJsaHZBWVcwN0FkVkNpNi9NbzVuNTAx?=
 =?utf-8?B?bWhRU2pwd1VQeHJYRDJZYWV2YzBnd1pEUUM3eFozc2EzaU8xV0tGZHdzOTJ5?=
 =?utf-8?B?VndYSHFlZG1pWVp0dTRNcG9nV3d6WG1lSWlNNU05VHFxeVArcWFaN004WS92?=
 =?utf-8?B?U1R0Y2I5NFpBajNZWWxSVnZWR2Eyd3pMYm9CMG9BUkZpdFBLVnZCM00vbnVs?=
 =?utf-8?B?SnVwT1ZRRkdyRVR4Nk56MVJ5MHN0YVRBZlZSRXVmWHpDSnJWWjZzM2JMcExU?=
 =?utf-8?B?Z1FFKzFUeWk3SUdRbnYxRVg3TGpyQkRyUmVqU1lTd3JRQjFUNVd4RW1wcGor?=
 =?utf-8?B?bkNSSzB6MFFKSmtaZS9YU2hLZ0hPbnhmd3pHQXBrbWR5aGZqN1FSVlRhUGFs?=
 =?utf-8?B?UTNaZS9vTDdtdVZHa1JZcjhaTnhYanhiR1doRlR0NldLMzJCL3dVSENiZzJ3?=
 =?utf-8?B?c2VNd3lUVlh2MWFoR3V3N3FiOFJDTVdaTzV0bHdGL2IwTjVKWXdIYzZPTlZz?=
 =?utf-8?B?QXRvZnl3QXZCMGdMR084RHFWNk0zU1JIK3JjVWZMUUVrZEk1eXhueVkrcVpj?=
 =?utf-8?B?K01pa2hManpnWkhmcjZBK1d6VUJYRWZhNElvWThUVHNIRHNzOE8vb3pFNU5N?=
 =?utf-8?B?R3dRNEZuTDFFR1d2dEdKckRkWFA1RDNIZmUwRUcwWkVyNm1sdzE1RXBOS0E5?=
 =?utf-8?B?d0Z3WmFFMFpLdE5KcVg5Mk42V2l2cHQrVnVjY0tld3Bwa2FScFEyanUzOEZa?=
 =?utf-8?B?WC9IYys1Q0pIamVtbE5xYVJpbWNtS2FaNEorM2o3SkEwV2htUFFDd056dk5K?=
 =?utf-8?B?dUJYaGYrWFpOT1lvcnhkU2VnTEFSUnNseVBKdlIrZXRNcTJrL2I0UUdnUnFW?=
 =?utf-8?B?b0RycHFnRkpCTW1rQ0NUT0w3SStqaEJNQmlOT2RvNHhsSHFzWDhKS0tObkE3?=
 =?utf-8?B?TDdSM1JhOHFlcEE0T2tIOHMvMGh0aldGVzJObENtZ0hZZllRS1BBZ3c2cnJH?=
 =?utf-8?B?WXFCMUVCWGVRdTFvTy9haEJLMU5IZ3A0RXJyaTZYTXgzZHo1a2laTkZNRjVs?=
 =?utf-8?B?V2t6UGtZTmxlMk9RalZCMXhEZmhjYTVFbFJKWFhDMUlsL0MreUFzNkt2bU1n?=
 =?utf-8?B?bkhLMFA0QWNRSjl6SW9PVnpXczQrSlYvZkhERk5HZTMwa2dsR0NDc3NXeld2?=
 =?utf-8?B?QVNKTW5pMTVKUWpGenY2Ukt1M2dXdlpYVWh5VDR5aHNtWWlOK0RkazR4VGJk?=
 =?utf-8?B?VldTM1ZXeHdHcUxEYzRqQ1JyL2JFcFdxL2tyTWRMY29McWlYYzVWL0tFckM1?=
 =?utf-8?B?bVVQWUl3bVJJcWFueWwzbWl6V0RZVzkyNEx2OXZrN0tXOW13MVlsdVBMZS9B?=
 =?utf-8?B?RnZGVHJINjZYbXhzODBWZUliTldUM2dCSGdrOHJtOU4zeVRLSTZvNlhIY2R4?=
 =?utf-8?B?c25VRTRJbFhoK3RzMXB2WWlIam5YWDJsQ2Y3YzNyRzJLYnprOHFmYkx2MW15?=
 =?utf-8?Q?uP8t+mR5LpwKj7gk=3D?=
X-Exchange-RoutingPolicyChecked:
	tZdv69QvDufGEoQ5zCtOEGmOZ+L7DVytDcxRGIR6XX1+F4iGyDYrdq+LIICUlHTjIzahpntJgOrez+qbunIdKem364y5CmMCVS+hbNdEYBYzr1CYLy/47uwngr81sx+1/pqXlEryfYfG7TGMzhfbj6YQ8ZQN4xnzCQvEIchzGWkwzT2YdPYt64Kd3w0tuepPoCLRguvCOiJ0noUAi9YVj/Plyg/LdlEpLRtXFA0M7l4IlpTlAp9UE8YpkniP8Er07FgHA+Ow9iz/CBWiLIEXmC2RFeaOkIiRPn3FNyfxIj3ROfMpiF90/3vRtutOMTrtLzb6OT3ZBa0GGFhw83EqMg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8bh/U5bV8eCdrGiSvm8Ti9Vx8sJ9eJ/vc2FNuETP84BcDfsj3VoEGgGwcWPTudBlO1nMt6NiKWci7aWpQZOuULSH8gpi62L/q47vfBcDicsiCN06Ynwer5x/exzfYh9KTOPBp2YMuL7KjQXuRnMMSrpJq3bp8j7VTCIRROvxboI1Te7J1fzJBo8U28wlLECpoxJze9aLXa24dCcyyfiV87gQf7XcVPlBUxIXAzOUMppib69mXWklLskEeKHDzyxD/5DmA8JhgoEk6ICEsxPHEVeKISL3lSPNTKzign7c8U1Zcbr2/6VNUc7ihv16w9DsPrj324k0UcTjNAf7Ee3c8UiEp4IMiroOM1dKJqSlD5ZD/QhwJ+mIfgH9YeGJLXyt2NdOzJYHQuNo61uVysVefhklWPeJnbIV4ud3WL1qxBYlw39Xwqp/lg1TR3Xa7gqKpIVZf2C1B+1GjRaApBVkBwMpUfKYY9xldKXGD9hWrEjn/kv24Q+bn4sIWDg/+PhsdUybPGD+TQzXkEAzxv3yxac+xrmvhuO8UGyqjl32oMi71YD+y1semv3rWqZ8vajSn9oU9vW3bIDaAAi200Y8PO2SECup7JdE4ND/S6AZWx4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f07956-e4f6-4b65-1239-08de7fdd608b
X-MS-Exchange-CrossTenant-AuthSource: MW6PR10MB7660.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 02:16:31.8758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DetlsgyEU/FhvIQJm/yu0/lYcQMSIZK2eOhF1eTvd2lS4LTYMHBMnxT6FqFKKBxc4TMajGcos0+EeKiCiWRumOz/txvPr5K6TXXhmG+uBu0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603120016
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDAxNiBTYWx0ZWRfX51CTaxuIM+zC
 oqrLA3PDVmpOe0ydz4zg7yWTTcJ/XIjtO01JVkfeLvAGA4Ln9q+OJKOsWuS5ttI+ymB7jTJ2RgK
 BqjjsJwKd56YvlZlOEIiGYxZJUJClBXMdRxjc4tzJ6aLfjwIXMcwsp+JfOvEQFfgPc70wMcUsdm
 7bOycdx/fJ6Rq7Z+ThcTjiMtaiadnBuiwlLsWvqFX39GxadYnSDmnei78yY2xL8M84jXw2PADst
 n7oCBqpD359AN+ew2V6T9Y960SEx1IbCZnYI298UAWMMGGgkmA0U/pzhM+Yoi02pYYnW13nBJc5
 tvDPUuhUdHM2PNVRof2R0d+2qbLRDKym+8o3qBE1X6JMAzRXO4P9BKOnms0NUzfmrpy7Y39j18l
 lyCb8SGkkiz3n7Sc0H7FYDd6pqReACoJfNK8fhn/UJ2daPxx8mtZd05rAiIeiu8pBouxlbrE+h8
 cj/jAFoMcQDyKfbGkNL1PvO7bXuuAesGB18paRec=
X-Authority-Analysis: v=2.4 cv=FL0WBuos c=1 sm=1 tr=0 ts=69b22206 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=KHLe_bW293oufylPImgA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12271
X-Proofpoint-ORIG-GUID: 3OL5QbK7xlv6zm6LlC0iIetqnGjeFfXA
X-Proofpoint-GUID: 3OL5QbK7xlv6zm6LlC0iIetqnGjeFfXA
X-Rspamd-Queue-Id: 0DDA6C0008
X-Rspamd-Server: rspam07
X-Stat-Signature: myic7651ahxs68qxksxaqy7qp7xu4gqd
X-Rspam-User: 
X-HE-Tag: 1773281808-185726
X-HE-Meta: U2FsdGVkX1/oKkqynkJiHqA9E5vvwAbLK+zOxqFXL/foc70PNEdNthVOy52qtt4b3SR3dOQTiwCRZbQnrCPRsnyrDBdnQXc/QghAZXTpxzqFcIVbSKbosT3LXjDSIVMn7G3JeFxYT+znfoEO/T7gtDQi5cfe9YmD7U8GSszUFxCBjQQvKixtKsPhtzrtJYL4ZFwuQRCDcTtO7Go3nCSvC1bcPSSu43/4/w2I/Tkq4UG3v76ZxOwsAwTXPcZNVJ7MA5PbyhlJW4qQhriLzLD+8vCx3WkQoI8mY6fxnS/uC5+ZVcKrt7FjW5Cl2CT9bOZ4/U/tY9QpeOxCoJp8f7GEE8oigQKkW1+2lw5XpEpmGw8tLNK7WaDWjHQZNONvCT1JJH4mvMgLGw2zY947n+05UQT6WPXdj8hzgu7o8Z3MfFrCNFd4W8297H2Yky3wPYeMiEbeENrcruYJBjqdVVoZhydyTyus3ET4GOluK930WQUgQlWvy4eRG2K82Y6vu/Xw2Ukt6Y6bj9WmK/7TRvKgktOhlGrcQGpmH2brLYEd4ZmmmBFfgPDP4O+AQwxGdyPrJqO0aQ2otzkqDrTTs0oQR706WUq0pavNcysWPDfxPI3pSWzTbgw1MaoXLrvjIiEHMlFyDkUgU0LyH1opOQry7FZS0d6hpV6bmeBnAxvyYnIoJz3iMobuSJOAe4J+/1qKqL5sNj1HqcVeBhWEe+VnNtVzFSyolP3yNUDzoc6HSVq3zBOegNDYQl8druSv6sgXdHXz3Uhk9t9olTYehC2EC5LuNEHHcg17/ohOnKq+S3tK7F7J6iiOmbQO06syOqYB7vSwt9lcS370sLc5XTCmit1OUkxqB73E6Y7dzedqqm8DwsbDC8Z+55tMf3uRqjRbZzHohZ6eu7ekKQLaX3jDo7yb3+zroOiSXPNBRxAI4Xmypdiv291VDrr2jU1lG6UGaFpazN74BGSmYLrGzFw
 yylkerB1
 AadxhqylWwR4592Ib7zqg1e4xbCB9asSPo+ZXHSk1UleOhd/ucHVKmouFjwakHSVa63Bn8fIfqOtsipPiMvWVaKqzA49en/LZe6MLUfXufRbAgg+9p1fS8nbo9lgajEEiNXVJprt6Mn140XRwAsSHSFzaKGxD7axE0mOB6V64Vxfmq7poePp4MEqyPMiVzs8mVBJVeN0aMQl6G1dG+rUrVyEhq7xFCTpm0cG2LKNkXSZT/FQEjYl6596/dSOgIz52y/KasSPVW9rcMqWFi3Vxv99nlg+ZlqkYow1UgkL0SEpavLyYFNqjLlMN4Ditu76wqOGO9yRpFomVvszLzsNK2UcwRF5j5ad3s1YWrpgKZMYZ2cj6TRKBbvZFpnFgOVjix034/t5cXfCJYjtpfpVqS9/MEqjD+p0dyM3AxLoj1LoPzAfsgXl4b/vS+8AuW12ymYe8uNFcL8a2i5YqekWfjyi2s0OvO9i90p0SzxEsESE+OyPG7eFxvrfkdkbOOtCCZPEy1olqE1D76X2g9FEySety4OlYTieRvebRCE5JHp1VqftdmUN+uw9YeWK0XsKQMsvzJU0zNBuGkGBsl/ZiK5xOPfGRpxJwWxHv5CF3XZQ7U5gAeydU3OcD96zWsNt2JH9I7sakdoaTfx0CfvFfsqfPie3ymZYt+Xj7iAddEVMiHs7v5bH3fwkJDi0kRry7BlNFDA3OR7JEkRG9BoPJgG7ndA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/11/26 3:36 AM, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 10, 2026 at 08:58:20AM -0700, Anthony Yznaga wrote:
>> Droppable mappings must not be lockable. There is a check for VMAs with
>> VM_DROPPABLE set in mlock_fixup() along with checks for other types of
>> unlockable VMAs which ensures this when calling mlock()/mlock2().
>>
>> For mlockall(MCL_FUTURE), the check for unlockable VMAs is different.
>> In apply_mlockall_flags(), if the flags parameter has MCL_FUTURE set, the
>> current task's mm's default VMA flag field mm->def_flags has VM_LOCKED
>> applied to it. VM_LOCKONFAULT is also applied if MCL_ONFAULT is also set.
>> When these flags are set as default in this manner they are cleared in
>> __mmap_complete() for new mappings that do not support mlock. A check for
>> VM_DROPPABLE in __mmap_complete() is missing resulting in droppable
>> mappings created with VM_LOCKED set. To fix this and reduce that chance of
>> similar bugs in the future, introduce and use vma_supports_mlock().
>>
>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> We should definitely cc: stable I think.
>
> It might result in some backport pain since it'll probably pre-date the
> __mmap_region() stuff :)) sorry.

I could add a patch at the beginning that does the cheap fix followed by 
this patch.

>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> LGTM, so:
>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
>> ---
>> v2:
>>   - Implement vma_supports_mlock() instead of vma flags mask (DavidH)
>>   - Add selftests (Lorenzo)
> I know it's a sort of subject thing, but please in future add a cover letter if
> #patches > 1 :) thanks!
Noted.
>
>>   include/linux/hugetlb_inline.h    |  2 +-
>>   mm/internal.h                     | 10 ++++++++++
>>   mm/mlock.c                        | 10 ++++++----
>>   mm/vma.c                          |  4 +---
>>   tools/testing/vma/include/stubs.h |  5 +++++
>>   5 files changed, 23 insertions(+), 8 deletions(-)
>>
>> diff --git a/include/linux/hugetlb_inline.h b/include/linux/hugetlb_inline.h
>> index 593f5d4e108b..755281fab23d 100644
>> --- a/include/linux/hugetlb_inline.h
>> +++ b/include/linux/hugetlb_inline.h
>> @@ -30,7 +30,7 @@ static inline bool is_vma_hugetlb_flags(const vma_flags_t *flags)
>>
>>   #endif
>>
>> -static inline bool is_vm_hugetlb_page(struct vm_area_struct *vma)
>> +static inline bool is_vm_hugetlb_page(const struct vm_area_struct *vma)
>>   {
>>   	return is_vm_hugetlb_flags(vma->vm_flags);
>>   }
> Ideally we'd use the new VMA flags approach, but I'll fix that later myself when
> I make those changes.
>
>> diff --git a/mm/internal.h b/mm/internal.h
>> index cb0af847d7d9..8c67637abcdd 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1218,6 +1218,16 @@ static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
>>   	}
>>   	return fpin;
>>   }
>> +
>> +static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
>> +{
>> +	if (vma->vm_flags & (VM_SPECIAL | VM_DROPPABLE))
>> +		return false;
>> +	if (vma_is_dax(vma) || is_vm_hugetlb_page(vma))
>> +		return false;
>> +	return vma != get_gate_vma(current->mm);
> Honestly it's dumb that we don't have vma_is_gate(), I see arm32 have their own
> is_gate_vma() macro, but we should really have one to avoid this noise :)
>
> Anyway probably not worth it for this patch esp. if backporting.

But in this case no check at all is needed.

Anthony

>
> Wonder if we should have vma_support_munlock() for secretmem ;) (again one for
> another patch I guess).
>
>> +}
>> +
>>   #else /* !CONFIG_MMU */
>>   static inline void unmap_mapping_folio(struct folio *folio) { }
>>   static inline void mlock_new_folio(struct folio *folio) { }
>> diff --git a/mm/mlock.c b/mm/mlock.c
>> index 2f699c3497a5..73551c71cebf 100644
>> --- a/mm/mlock.c
>> +++ b/mm/mlock.c
>> @@ -472,10 +472,12 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
>>   	int ret = 0;
>>   	vm_flags_t oldflags = vma->vm_flags;
>>
>> -	if (newflags == oldflags || (oldflags & VM_SPECIAL) ||
>> -	    is_vm_hugetlb_page(vma) || vma == get_gate_vma(current->mm) ||
>> -	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE))
>> -		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */
>> +	if (newflags == oldflags || vma_is_secretmem(vma) ||
>> +	    !vma_supports_mlock(vma))
>> +		/*
>> +		 * Don't set VM_LOCKED or VM_LOCKONFAULT and don't count.
>> +		 * For secretmem, don't allow the memory to be unlocked.
>> +		 */
>>   		goto out;
>>
>>   	vma = vma_modify_flags(vmi, *prev, vma, start, end, &newflags);
>> diff --git a/mm/vma.c b/mm/vma.c
>> index be64f781a3aa..18c3c5280748 100644
>> --- a/mm/vma.c
>> +++ b/mm/vma.c
>> @@ -2589,9 +2589,7 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
>>
>>   	vm_stat_account(mm, vma->vm_flags, map->pglen);
>>   	if (vm_flags & VM_LOCKED) {
>> -		if ((vm_flags & VM_SPECIAL) || vma_is_dax(vma) ||
>> -					is_vm_hugetlb_page(vma) ||
>> -					vma == get_gate_vma(mm))
>> +		if (!vma_supports_mlock(vma))
>>   			vm_flags_clear(vma, VM_LOCKED_MASK);
>>   		else
>>   			mm->locked_vm += map->pglen;
>> diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
>> index 947a3a0c2566..416bb93f5005 100644
>> --- a/tools/testing/vma/include/stubs.h
>> +++ b/tools/testing/vma/include/stubs.h
>> @@ -426,3 +426,8 @@ static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
>>   }
>>
>>   static inline void hugetlb_split(struct vm_area_struct *, unsigned long) {}
>> +
>> +static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
>> +{
>> +	return false;
>> +}
> Thanks :) tested locally and working fine.
>
>> --
>> 2.47.3
>>
> Cheers, Lorenzo

