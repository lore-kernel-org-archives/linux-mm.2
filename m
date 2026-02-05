Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E892DEA7960
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 03:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F4F6B0098; Wed,  4 Feb 2026 22:52:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CB76B0099; Wed,  4 Feb 2026 22:52:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39CD36B009B; Wed,  4 Feb 2026 22:52:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2140B6B0098
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:52:27 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAB79140399
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:52:26 +0000 (UTC)
X-FDA: 84409030692.14.FFFEB36
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id F30464000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:52:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a3uCmzgZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=j2aWeVKw;
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770263543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XjNc9LWT/qxgqkS04WksTnquaJ7SGoyjrMUzy2k4GvM=;
	b=DKhRxah5S9LHxZk0I16kZvZjWgLCDu895VnzdsBybF8KbFJ/+ga197MnlJHA1VOS9T6n5X
	M5rfPfKDwNF8V6zXU5PRjngRHFnEA3Ek6QmUATAhvScUbII/TfkGvrrgyPZt1GoucdCFq6
	tL61N48Qw7Y/TVWxgIf2Bs+7J4BxrCs=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a3uCmzgZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=j2aWeVKw;
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770263543; a=rsa-sha256;
	cv=pass;
	b=U2Cv2Z3t6cI2/xn+ypFxL6x46SwjKPNEnso1GU8R7lubVvD1jK4EYTuthwXpktpkhezHqr
	qvmvxZWmlxY4Cz9t2ivKpXy4/jhwix4bbG2CAIvLcX3kxh6nP7HbCeEE6RgQrTyS8wvQEE
	vCtYpd2VPRmTBKbK45qZnD5m6stMtEw=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 614N7nxw1717984;
	Thu, 5 Feb 2026 03:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XjNc9LWT/qxgqkS04WksTnquaJ7SGoyjrMUzy2k4GvM=; b=
	a3uCmzgZZbnrojFM6PRZ9thRIewm/JtnI93zb1kAMB2EEnXEKlZn1n6UqmJs/AMx
	Lr19uc4WRNBtlACd9Mi77kFy+iVY3t4jSCpXYAYnFbj0mbYtMTv3H9eCiJThaFxp
	zNHn/FQDyii1IVVSj0bmouDWJuOV79E+7/uWJjcVPde+5gIbTUTSey2KM+aFdQda
	JkGkhT/DrUpY0OBa8Z0TWmqp02CePSpqP2g6ovkgfdT+OqvRWlO3b+NRgq9dHRZ3
	TdpYze8RLNemVbDcbT08dU9ip/E2s62E7lHWXfVtAUgaRjNJYtd9QiivtoCYyXXa
	W66p08j49N/rafuEIyRAOA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb32gd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 03:51:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6151KRNf037239;
	Thu, 5 Feb 2026 03:51:59 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011064.outbound.protection.outlook.com [40.93.194.64])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186ce0ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Feb 2026 03:51:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zi3rDfApq0y2hlL7hM1uXoZl8Mvhy4/1rQQ92oLSwLKNFe0KPVEhCIoSb78V5n2WYMsXqvEPbcU6GVHeqUXJ8MUh5vEx4kckmdVf2toDJ+uvRCn2oJLzyEx8AlERyXKNrJcrhROzfMzWDcoeF+/Cmn5/8VYiHzBh9wHqOJ+6gTMddiguu+EdWf4snV/m037Lw3GnxL+60u6jKgXEjaS+gbxF/eUq8VCsoSa+vpGXswSHqXeLWsxASQFmn1T10879bZb7a+N84f46iTowi2P1uw1SNHu1QCd8Qt1agIlXwMjrqVDytgEoCbDiTskczJHSgBx9JiJuGvE/Bt5LQA3rGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjNc9LWT/qxgqkS04WksTnquaJ7SGoyjrMUzy2k4GvM=;
 b=sXsJskUFGhH46eLKx5aS0go36qZtbpDk9EEW9BMKZMZroccbyRLUCmq5BW7uW3zePmXhGPwGIAbATvDPDz4bS1bGjYnUFKvsR/roT1fEg8Q0O+R9yIvqIo9hymTw3uiYnm+92i3FfVTZ/9c+L+cOzenr0+1SHcvfapID1DHTxhsK1IzmTJlGHU04QwcommQDXMmZw4/fg37smBDm6gg4g7KMmGp0/56sjSY+0MWkI9vt+sckRQr7Q7njz7xUFYWiJmNUcsEfosvo+O0XBbhRD20TapqbI35bjsAhIV7L3HVnKrMwoWPqnpiFqaTtNyEl7tbAXi6QhEvUqvcUO4HOxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjNc9LWT/qxgqkS04WksTnquaJ7SGoyjrMUzy2k4GvM=;
 b=j2aWeVKw6Rh2GIORO5yEPRVk0JoE0VLXLoJhOoYc4W+4Ologb2eg+R+VFsapizDkC5CEwGAzsBqLa7PDpICAXMdftqd9vIpwLw+KFnyLf2YMpj1DeH1alcMUAp7y5/KRF8150NiE3ecPcRLw2OvYOckaNzuB6MFuueZjVGzOkfU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH3PPF63308C95B.namprd10.prod.outlook.com (2603:10b6:518:1::7a8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Thu, 5 Feb
 2026 03:51:55 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.010; Thu, 5 Feb 2026
 03:51:55 +0000
Date: Thu, 5 Feb 2026 12:51:45 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, David Hildenbrand <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>
Subject: Re: [PATCH] mm/memory_failure: reject unsupported non-folio compound
 page
Message-ID: <aYQT0ZowmggdApWL@hyeyoo>
References: <20260205005603.274383-1-ziy@nvidia.com>
 <95bd5396-256c-58c6-62ab-ae95e0cf371c@huawei.com>
 <7A895A79-C569-4EB3-9C4D-75C1635B9DC7@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7A895A79-C569-4EB3-9C4D-75C1635B9DC7@nvidia.com>
X-ClientProxiedBy: SE2P216CA0151.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c1::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH3PPF63308C95B:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fc00ede-76d9-4658-580b-08de6469e7ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eis2bHN4bFZYU0xOZVB4eEY3ck1kVGpLbk5pSzIvNVY1bG5wOEQwZUY2Zm9p?=
 =?utf-8?B?KzRPeVVaVVh4NEs1aXdZOUlmai9lWkNwU2IzSUhUVXRGUlgwSFJpNDFOWm94?=
 =?utf-8?B?c0cvTWhidUM2RHFvQzNYWTZ0cTRidnNTV3lIdnRtT3NxcVZySXNLakNJYko1?=
 =?utf-8?B?dU5MT0t2RzJtSUZUVitJNVZpdHlBZlFrMElnK2lQSlNjR0hlQzRhc3NHaDFP?=
 =?utf-8?B?OGNmcVUzaU44L0pFaERkTEdyeHBaZWRDWVpSVG5RSW1BZlU4ZC95elF4cS95?=
 =?utf-8?B?dnBRbHh4SU85dGNJWDFFdStKTU5VK25CU0d0bWhTQitVd3FVcW9pTDhKVXVj?=
 =?utf-8?B?ZVZRL2wwNG8zUlVrYlNxTUtzREpIOE9kcXZBQWRxRjZQTDA1RGR1cys5V2w3?=
 =?utf-8?B?T0lKOU1vTSsyUnI5SndYSGRYek1lZnF0RFVzZlowN09QM2ROQmdBVUpSL0I5?=
 =?utf-8?B?NTV6TThJc0prY3UxYlBEeDMrdjFhbzlyYjcxSjdndW9TQUhjemQ3bUxTc3I2?=
 =?utf-8?B?VHpzQmRxclg4VCs2UjR1cmYyeGk5NkNPMkdPWGQzQldnKy84enU5aGczUU1n?=
 =?utf-8?B?bjV5VitXVWU3b1l5S1pOQVJabGkyZlJ4RmEwbytwR25FM1duZ1pSTE01QTYx?=
 =?utf-8?B?MC9qTndQL3FsMExIUDNEU0k4NWpGMU1RNlQ2YUl2eXNwVXJsU05hdjJaL21h?=
 =?utf-8?B?NURMK3Q1RXRQRmJTZ0N3a25Cb1psaHBHRTNTWVhScjlSTkMyU3ExWjJOMVow?=
 =?utf-8?B?aExncnVzb0N5NThPdGhMeFpuVDdQWWJicnB2cFU5K2FTMUdBYUpJOFZ4MEYy?=
 =?utf-8?B?TWh2Y2xGdjJNeDJSbG5nc3BHVWlwSzl1TktjOVU1WGNzV1Q5K0RTb293dWJU?=
 =?utf-8?B?d20xaGMwUWRFMkkxRXBUbEdDMWc2bWxVcXBoWU1jRkdWZE9hU1lqYjR1UXJk?=
 =?utf-8?B?dTVZaDYrOXpTWCs3d3ovR1ArYmZoUklGMzZOTUdCTG9hOENpRkdCc1BaclVJ?=
 =?utf-8?B?SHJwYitxdmR3ZG1vV2c0WlF4OHQ5cWtSeGszUnc4QkJIanBpUUNMazErNTYy?=
 =?utf-8?B?RlhoYUpUMnhEQXpjQkdJU1o2U3o2K09pTjRKUHR0MkViUHRlWi9vY3BDTHNB?=
 =?utf-8?B?ajJ1MHJsRVBXcG01MHJ1UmFnTmhMRVd1MGZ6QVJlRE80YkUrRzRpRTFlcGtj?=
 =?utf-8?B?OUx3MjZQUGtocFBrUy9mZTNGN09ud3ozcGUrcGhDU3dqdE1zS1dDNDZWYVZz?=
 =?utf-8?B?TmdadGJwREtiMUZHY2NXaDNUbVkzU1ZnaTBYQTZjK2RFMUlOUTY2YTc0bW1G?=
 =?utf-8?B?MzBkTStsNzVvZzBWWWVhU1JqK1JYT1UyNnM4OEhlWlAwTEFPSXVpR1pMWXVk?=
 =?utf-8?B?NFd0dG9heTg2QWpKQkd0djE4cit3dDE3N1lKRW1XYkdMSEc5bVQ4ZVRGZDdK?=
 =?utf-8?B?WXA0UnpSZTRiTENidVVTTHZLT1pVSEhjdnhMN0Y0Z1BncWtiLzNpd3NLb3Jm?=
 =?utf-8?B?M2xMODRsUVFnbXRKY1dSSGNzakJhUllvcTZ1VUM0SlFSZUpTeDJLY00vNGE5?=
 =?utf-8?B?K1JsVnBBaVVNQnlsbkk4aDJ3U3ZTd3NUaHAwdWsyNHBGYjJIenR2SEVDZEhQ?=
 =?utf-8?B?cC9iZmk4OTZFaWRCR0VSSGxrVlM2RnRlRGlmUVhwTkt4SUZ2UkVycjR3VWdm?=
 =?utf-8?B?YVZyWjJGZU5jemFTaTEzU29QZVBNeVJTYnAyTmt2RncrMnZ1NnV6UEpFZVpV?=
 =?utf-8?B?YU8rT0F6M0NDRm50R2VHZjdkM3BnTC9XT0tUUmRrdlZPanR1RUNVS3hQelRV?=
 =?utf-8?B?WlFMU0loZlViUVIxemkzZit0WFpUa2hXLyszbnJMRFNmZmR5R004QU8ra2ZV?=
 =?utf-8?B?d2lqOXpFeXZiam5VSzRPSGVKeWhRTnEvUjNBUmoxa0p4OG9Kb0pGTk5Ebmhw?=
 =?utf-8?B?dytSaVZZZ2Exc1lFNUVRRVhrUUFuQ2kzbjJ0SU4wVWRNMmdZdkw3UHpzczlJ?=
 =?utf-8?B?V1IvSU9hTlUvNjNXM2FlN1p0bTU0VDkrMXBpZ2I4ZmQyMEZDMGVpcXlVSDFN?=
 =?utf-8?B?ZmdoOW1qZHpRempUY05FR1YwV29mY1pML2Q1T0o3NkdKWEV0TmFIMldFekVK?=
 =?utf-8?Q?0UGk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ynk2UWFnZldoUk1Sdml4eTd6eGJKdU5VdjlsNlJYVmNITWNkbG95b1d2Uklh?=
 =?utf-8?B?aFB2SUV6SXNQbkFiRGtIejQ2bmRLL0JhZll3ZWpZOGxQeGhZd1RXaVdNVTNh?=
 =?utf-8?B?Nms5Q3JQcENPWFRHSEpFWmtqZERUanZucjZEbEdYLzlHSUY1WlBLWnJjY1Vn?=
 =?utf-8?B?RzB4OFV4UEd5NHU0OVpvdmlPSm1BRjBmcyt5VUVtT0pEeURVeW1sQWE3NW1I?=
 =?utf-8?B?ckc4QVVWRFZmQS9uemNMYS8zMkVUZ0R1WU96RERpaGFKYVJnaStPUWoyRnJD?=
 =?utf-8?B?WHBqN3gzaTZEbkFjNURTZFh5MUQ1Slowb2toNjlJaUNiL3FzSFBLMncxdEJT?=
 =?utf-8?B?OHQ3eGc1V09SWGdmdEs5UWlsQWZYK2luVlhEWDQwNENYK1JBL1Ixb3BCZklD?=
 =?utf-8?B?eWErdTNRMWc5Y2E0cVQzSVMrQkltTThjQllZSkpIK1JMUzZCM0ltempjWGNh?=
 =?utf-8?B?YlZza3NlZVFVL3lFelVULzc4TjNYQ25NaGJlNnNjdjBFeHJ2eDZZNlIvckdr?=
 =?utf-8?B?WXZFaGtCZVVHbWwzYm8rTTF5Wjk4UnU5aGVUeWR3QzZISTNUZnpqT3VWVWV5?=
 =?utf-8?B?SUpHaGJGaTVKZnJiQTN6a3ZpWm1Xb1VlTm41QldNYUlpL3JjMmtjVFkvVWE2?=
 =?utf-8?B?U0RzSFdUQmxGS0tML3BBaFZoSmoxTHlPYUlYbWxpVFJIWnZvQlJ3MTJ6QW5C?=
 =?utf-8?B?bUMrU05uVmcybHpoQ1ZsZmJSWm14bVh5K0g4U0FEcjhSZGxpYUNSdk1GYXRk?=
 =?utf-8?B?aFlJWkJ0d0E5MUs0ZzVrcG45OHpISDdPTjJjblNDUVdVTU9Ed2lHeWlnN25I?=
 =?utf-8?B?NXc2N2pMRWFMbngxOWNnZUxaMHFSMSs5WnpES1FucGJOWkFlMUIrT21kWHAr?=
 =?utf-8?B?QTVpalE3aW10UWoyRkFPakRMZGFQQ243QzJOb0dMcS9rYlBORVdyNWVMUE84?=
 =?utf-8?B?QS9jd3J3SGVOOThjOUE5OVRHbFJaUmpvQXJjeldhRzluWEQxN0xQWk10RGNT?=
 =?utf-8?B?VjVTeTBTVUxRd0xiYkpnTWI4ZXdhMmtvSFkvdHBZcGV5RVlIWHlpWEtPUHZP?=
 =?utf-8?B?UWtib2pxcjd2QndVUU9jQmhoNFBVNzQrcGtLM0ExeXprUGJoSDFCbVMwSDRQ?=
 =?utf-8?B?TkkzbjRKT3g2algxL295SmxYandneFBaWU05SnU4Sm1Ma0FrY251Z25KTDE3?=
 =?utf-8?B?ZHppdFdSdWNkcFNtc0lmWmc2L3VtczNFdDZVcGNiRzJpbXRHR1pnNzhNVVV5?=
 =?utf-8?B?bHE3OUNCbzNYelVVdDFqaVAwWHVZVHNDMVRNMWo5ME1RVkowV1RMaFdZSGRW?=
 =?utf-8?B?NWIrN2R3TTFQNDJqMkl6ZHBVRE12WVpFWTFMeGNoTGhtZEh2OXc5cm1QVFc0?=
 =?utf-8?B?a29jUXA0cHV1OTdpa1p2TzVYUG9ROVhVdVVRRHZBc0tJVmorNmg0dDREb2R0?=
 =?utf-8?B?YlZFOWNOd0VMbUZwRTZUU2NVclkwV3A4Y3dIRGpkRXFrdEduamNFSG1uYk5B?=
 =?utf-8?B?MnRNbEFSSEwwUTd0b1N4SllRQVlqc1c2cStNV0JzS0tZYkdpSklmV3gyVWlQ?=
 =?utf-8?B?VG9hVFpNM1p6dU1wT2l5d0dKVlN3SUxEZVBRb2JjdXdIRUx1dFlWd1l6d09M?=
 =?utf-8?B?Q1RaUm9nSU00c0s5aUFranVab3dndUhVS2xmb2IrcGg4SkQ3TlNoWVB3UDFX?=
 =?utf-8?B?VnhOOEZwNWU3ZE1QbSsvZEtmUlk1cVR6bktVNXJoc1lkeTlsM3NXU1QyNHpL?=
 =?utf-8?B?ajFFamw4OTFib2psaWNudjdvaXQ5NmdCZ0hucTBVSEVEVE5xT2RmTWQwUXRy?=
 =?utf-8?B?ak1iNVpqVERLaXk3SFZnNnZ4dnpmNkRoSFc5c05kU3VUV2t0bUFldTJoQlEw?=
 =?utf-8?B?UjA4aVI0Y2hTajl6TWlVa2Z3bEVyNk9laXpnN1NmNFN0eTlvaDJrdDRaMG5E?=
 =?utf-8?B?RS9SUk9mT1ErbWVEY2JTb2FVZFhSdXlpS1h2WE9qQmdyRDBLTGFuSE9leS96?=
 =?utf-8?B?dlhZL29HTWxOcHlKeVpjcENJb1V3OUNUTDlsckFaK2pEZmhqZmtoOU9CV3Fx?=
 =?utf-8?B?NDJBUU9xTHVsWXZOeGpzTjZOZTcvWWs5UFhJOXV6RXF0SVdKL0xKL1JxeHZo?=
 =?utf-8?B?OVJKT2V5NXd3OFN2aUc0Z3lMN2lBdDFzb1p5cGdDQVRERC9mNTVnaERGMEp5?=
 =?utf-8?B?akQ3QVZtMUwwSUZWMmlNWjRMdm91YlczQjh3dmt6SEpQc0VNbzdac0Vpc2lH?=
 =?utf-8?B?YXN6SWNPNTZJQlh1aTF2bFFPQjRtSHBCdE9pMExBRWxoTU9JRi8xSTZ4UnBq?=
 =?utf-8?B?V21DR0dJdG9TSTUxMmxqQXFBSml3VkdkWWpld1pLWjUyaDFZaHVBUT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pYRZyO8NDJsrAqHXSf7pigRV4J2qn5D9PiT8eZeHJzD8x8Tg32a8or5HkiKwszNPKPioKn3EEGmn0k9AcKK7+a73Y9EOWO6HoaSJyoOA8FZXW8LQbaufz9Aon1oIxBH81KanX7PorRVKZj3uK+X8xoVcvjDlFcv12tyJoCS1LQk0dLzbSsrm1MC7soy3KUPGiBW2UMXYKy0tPfTrVUwN5fI1tqJn4iLk6aehGv52V9eIh9F9LwwfLksYVHhh1Y1MxTritmRPMV7X8dgGZpiOx1SRF6QkYiwNwb4wM6phtKaOo2ijCAnDqiAEM1BfELv9H//AqqJarNXnnZzwgvN0rs+hp4bCgneR8Xhyr4wf7I9S9KO9ydhTl4SUZdwR3Tj5CfC5/9z6VnTbsnkPIIkmb+GKZoeDVm6FWi4kTUF2pJdQ07/QrPMeN4M6k5ckZxTHruweC76fpyj03mqQzyO55eOVhn3Nq4LV+Lx7UUIj5ffzYKsAMezor0bIBvZpnhOv8GxO8t+aIuHXSpg1LXPkISjpBdqgZLfl/x5mqLo8hqZPMTrFwQrP9n4TGvcKEOLAHruwmJfj86x2JDq8uyCQyOakzIjSVNq1MbDN29H1mgo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc00ede-76d9-4658-580b-08de6469e7ae
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 03:51:55.7617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q9EiGjXbat+T9hleJYZ2OruUkyy/Rp0Mze3kZyJjNVCFEO9s72kpVG9604yp6A4Mmolj7m5+dSHVi/N8ujTuRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF63308C95B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-04_08,2026-02-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602050022
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA1MDAyMyBTYWx0ZWRfX8zaFoUtJoHvh
 +ytnGqm9BviZOfCA5dYvC95ixP4ePCCPJjtx4ZwKWJ5yUp5hemn0X54QY7XR90TC/htWznxoMRd
 LMo7nDbpHo9g/Ojb5H7aUthh0jRfb1mVJUsVj0Xs/zkRELDVSFnjVSLUUvvswWYdUtd7wQAKPor
 zWv7RQP3gqP6Z6wMFglQmLC27PLABxwAO9tPaLbiatncEb+xMAi5Sr/LHTRZ/HcOnPF3BKhfoVG
 5DA/euI9Oog03ZU66BtgDrkyU0xaH/bpIIcxd+0NBvWv6RrbIsf3e5XAxFILF/Tj7jyNJB+OTSD
 RX3WcVJpSqnp5VnVQg/LdhGNU0rCp5ckgLlJi022a81c7FhfChKRCXf5EXmSyuhOso4Mj9dvkfu
 RNtHKhYOLIpgkHWzqBtJhVGqYBVBWba5L/Du8LvHYgUUiZXpA7+mRw065yHGTbxZpO8+OlTG07K
 TQcYguUrwqR4eyOZF8A==
X-Proofpoint-ORIG-GUID: 9WmNmJ660n_3oBXcoDTD6Zb1wFHMLFtI
X-Proofpoint-GUID: 9WmNmJ660n_3oBXcoDTD6Zb1wFHMLFtI
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=698413df b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=UqCG9HQmAAAA:8 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8
 a=8g15mBpW4lo3dyMFA9wA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Stat-Signature: qrrrut3gj5biemi3becnxnz6nqud7ec8
X-Rspamd-Queue-Id: F30464000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770263542-750536
X-HE-Meta: U2FsdGVkX191Y4V+YkNns7vTDCuosITFYv2S6GMZDeGM/kgogWwNeF90hN7aI4R5cPY5KhW/wM5/1fnPf6IRou3gVX8WzuP5BSxkgaU6wSDZyTyOklxz7/w/PZ5TZlMkZXfqmdydlHGTwkPLySRjpc+UYX5xeq672Rt1+MovomRWwOM9qyiobaRl1u5/VPJYTqRgrlgGThdFzIAsee+MlffxaccaLpfTvXOgOpmNORAC+VJe/z4PVTMWofkrvUaGbmDCAZdoLL6jPBOd8RB9s7oFBeZmcJ09d8wkX2lgHSblJNKX9GvL0rnE8dbaV2NqL1NDpIJcvYxq4wrrrnfKTVXa9T81WVIRFdpl5MbM3ppJvVpmJ4XDGQt1TteppDXehEPO6Vz+BrTuX0JXfoyLFYy1RtE/rMAk4qh1LT1K6rDg8bhsHa6b/Pwtb1aQEf7QQ9RYuVRasD4tnc+elhh6w/H6yH2X5nyAWR6biKLitkDHgyTL8aw08SiXKrr7K1xYTDizgtSowuDZVohwxmECxqa96tL5PGqFnAniXUc5vOYrdnqsw+5AjDCVl0dkGYxIPiHkaMrzCqRIHEC+eTed3MyFZsyqYU1ZpQr9h1v8noKBPl/3r1j+EQ0nVQ2RQu8e+xMEUfHWbJWxdNlIapTHEm6ne4DXcf9daGKZIMesL7v2QamQBMn+1JJuivj5GQVjrO/m5UBF9Uv32lR9hgo6hclmH8vI3Kt6kDytp4ACPX2YivfUAI1H4TuhClAL3jqwJGoqAkk5utFPM2YDJbTgT542Rdm+UtnNwWKEY39NJUiB1HOih/3Ap5AqCBp/1THPFEQvjk5bhEXqEvLbocqKgW2C+a6ax0qzj5t/4Ad2DxmeGU12DDIyPVOP3W771tEfz8i8QeJW2NPcVJ1SAfK8y+LZ6Osc4THGFqg6oZXFXJ5j/T15kyN8JAkh14XOT4Fwop3JueTp4Pmf/kixccf
 t/x7/zfm
 dkrQGSzRHRfXjjYPyW2kwdzg8c3itUcvAMelbMZuiuho/4n0oib18Z+NoxjBegWyuL5oQ7Uufl3e+YqfHPkD0ww/yYNxlsXyA6CeY95yLwM4FNv59a28QSN1CaL7zN8ORzqYgPulaxBGZVAs/eYY/tWu/BrcTOASN+eqpCPghRA3WZ4B19zhDqD4iGphtmWKR8UjFHu6FPgN2bPazYQXNrYlYL7/3EnYIT4Hslr5tHZ57OP0/ZP8i28xAw5N2hglZFnn82apRxn21kwUsSZ1zVxacbFyRMEQQXg/6MnFmGX+gFEwaJIUmbetx9+y1Ptc+2VSDDYTdC2syX3JijxXn3SWUsLsvcEanlps6o2aDe+5NRvP5WWeZVsCpEol0KxtaZ0QM2fQXeyi2GRTZJjrTG2+BmfuQRCbQ3INZt3X/dnRZabk0ymX0abtgoi1Kciaj8Hzp8/MunpqEJX5YBEQJnBPkWGvtoHllXtVbOSOTtXhtEEUYnKABkcNAJDnzGViVD6NTxJg2Ql1rFkOx1RaY9h55gtlZAhPlGaw9664txm8ziQ9P9WiJPG3kvsEHqSXggJKNeAitqKpkIANNsJ5OfDmTvi0UMt+B1belvIAB2WUUASJ97d6bBRxW3qEcEnHQSarFP6Qn2rwuNHspLwmLJglyRpsYMqMzjXMz1esYRlJQpqzfn0GKPf0VkfPEq/C2+N+mRNA0cktywAt+rGRnvv6vE9vAyDAIpGWBH5PIBcbPUWvdwLc+3nHAe1kj1IVRD2M970lm1E7zgdBU180cidt9Lm0Yc7fewBCcWh8q/eeiRGo7wqAOfivJ+rIkR7OH5AJ5vci+sHeyHf6/K0OJRA7Q+U85iRzZ3GUUogqzT04yqmWpMOOvydXQikZi7eJHjD6ig4TaCI9hkPQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 10:40:22PM -0500, Zi Yan wrote:
> On 4 Feb 2026, at 22:25, Miaohe Lin wrote:
> 
> > On 2026/2/5 8:56, Zi Yan wrote:
> >> When !CONFIG_TRANSPARENT_HUGEPAGE, a non-folio compound page can appear in
> >> a userspace mapping via either vm_insert_*() functions or
> >> vm_operatios_struct->fault(). They are not folios, thus should not be
> >> considered for folio operations like split. Change memory_failure() and
> >> soft_offline_page() to reject these non-folio compound pages as
> >> EOPNOTSUPP.
> >>
> >> Add PageNonFolioCompound() helper function. This function is functionally
> >> equivalent to folio_test_large() && !folio_test_large_rmappable(), but it
> >> is supposed to be used on struct page. So open code it instead.
> >>
> >> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
> >> Reported-by: 是参差 <shicenci@gmail.com>
> >> Closes: https://lore.kernel.org/all/PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com/
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >> ---
> >>  include/linux/page-flags.h | 16 ++++++++++++++++
> >>  mm/memory-failure.c        |  9 ++++++---
> >>  2 files changed, 22 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> >> index f7a0e4af0c73..2fe8047f42a3 100644
> >> --- a/include/linux/page-flags.h
> >> +++ b/include/linux/page-flags.h
> >> @@ -1102,6 +1102,22 @@ static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
> >>
> >>  bool is_free_buddy_page(const struct page *page);
> >>
> >> +static inline bool PageNonFolioCompound(const struct page *page)
> >> +{
> >> +	if (PageCompound(page)) {
> >> +		const struct page *head = compound_head(page);
> >> +
> >> +		/*
> >> +		 * Without CONFIG_TRANSPARENT_HUGEPAGE, PG_large_rmappable
> >> +		 * should not be set/used.
> >> +		 */
> >> +		return !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) ||
> >> +		       !test_bit(PG_large_rmappable, &head[1].flags.f);
> >> +	}
> >> +
> >> +	return false;
> >> +}
> >> +
> >>  #ifdef CONFIG_MIGRATION
> >>  /*
> >>   * This page is migratable through movable_ops (for selected typed pages
> >> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> >> index cf0d526e6d41..8b6b5950bb66 100644
> >> --- a/mm/memory-failure.c
> >> +++ b/mm/memory-failure.c
> >> @@ -2440,9 +2440,12 @@ int memory_failure(unsigned long pfn, int flags)
> >>
> >>  	folio = page_folio(p);
> >>
> >> -	/* filter pages that are protected from hwpoison test by users */
> >> +	/*
> >> +	 * filter pages that are protected from hwpoison test by users or
> >> +	 * unsupported non folio compound ones
> >> +	 */
> >>  	folio_lock(folio);
> >> -	if (hwpoison_filter(p)) {
> >> +	if (hwpoison_filter(p) || PageNonFolioCompound(p)) {
> >>  		ClearPageHWPoison(p);
> >>  		folio_unlock(folio);
> >>  		folio_put(folio);
> >> @@ -2945,7 +2948,7 @@ int soft_offline_page(unsigned long pfn, int flags)
> >>  	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
> >>  	put_online_mems();
> >>
> >> -	if (hwpoison_filter(page)) {
> >> +	if (hwpoison_filter(page) || PageNonFolioCompound(page)) {
> >
> > There should be no problem in soft_offline_page(). HWPoisonHandlable() check will be used
> > by get_hwpoison_page() to reject PageNonFolioCompound folios. Or am I miss something?

Oops, I missed Miohe's email.
So it's rejected because it's not on LRU.

> I did not know that. Why does memory_failure() not call HWPosonHandlable() to check the input
> page? It looks to me that HWPosonHandlable() is more appropriate than PageNonFolioCompound()
> here.

soft_offline_page() unconditionally calls get_hwpoison_page(), but
memory_failure() doesn't call it if MF_COUNT_INCREASED is set.

(MF_COUNT_INCREASED set by madvise_inject_error(), in this case)

-- 
Cheers,
Harry / Hyeonggon

