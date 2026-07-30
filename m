Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 734F8C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72FDA6B00B1; Thu, 30 Jul 2026 10:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E05D6B00B2; Thu, 30 Jul 2026 10:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7E36B00B3; Thu, 30 Jul 2026 10:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 440A06B00B1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:15:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E43EE1C0134
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:15:10 +0000 (UTC)
X-FDA: 85045639980.02.9488467
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011069.outbound.protection.outlook.com [40.93.194.69])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0691340019
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:15:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="S/9+G1at";
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785420908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eERiE8wnyd3Vf4jQoIXzNjZm7iIuh5bkzNJdx04yT2A=;
	b=IIi3nS9Qct0KfUxPp0cE8TGf25YxbqrxLdbW+p+05QWHwlHISz4PEBRmsVxELVAXqYBSOI
	tH3GR2xxcNQHkA3CWAfYBg3YoUWn0WDPTSYBgy4ha90pcPHbIReJ9ZMhgOsOAzxOfsJbIe
	ZppkjsD5acx50/k3leqaaTsGfKJA2ok=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785420908;
	b=uucJHW0f/xtmH+IQ46Kb06PudZa3ZnKFYYyJ2KnnpMG7NQUfg7P0uQ5iGM1GYF+0/dHP5R
	bP4S1oTSpf3ng/ZJnozQ8vDCKRa+sVCjNxvJZkpC97W0lEfPkLVhaMSp5wfkdscTLQOjEq
	lRBxUvOGHGZH72Vky645+dXCylbd4CA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="S/9+G1at";
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ML+cjqMDSbgD+/9pw2Q5F8yYdIITmol1im6Y+DPG2cGKkubRa3v40E8+WJeeJ+NhXJ91xMKvhORD5I3R2tPO5I13DWG6EhpD/AfuKcrlRTWkSPr5JuYM4M99KRHn+kwa4WcLjSsVKcxC7G+MadVDS699NrIfW/TI0uGG42gBgstNsiziwg6u+AreN7wASXPfYtMfWe/1UPf2Hh/gN6gE84fu2XyjgXkdRHarLOC+tE6E6MDT6/AOX/IWV2/RvOlcj6c/QFevi72B8evuSAtjZA29QFBFubWhfXyUuSUHVLNftjYziPmcS5YCVbKGoTnCqh3rJyRIn3+nGJ1vImOCNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eERiE8wnyd3Vf4jQoIXzNjZm7iIuh5bkzNJdx04yT2A=;
 b=D/x/MGwcn/HBHlHOKB3ZMRsKMoR9r9mPlhXijTauE7BWVL9XyA+M9oS+H1Kf7dE7mK5PHln4twcupO1A8/yctWWpivBOJ8IYu9jfwF3ni46l0yhR1MTAjU5WNUp74ivt26/Z1kWDQNXUpFCYUQmonqaFBSvt19rmBpI8qd/p3DHQlW2gVQmMtYSGcQMAC2IuanKWMwtJ3TsipF+v5UHuaENHnYihS2o32/EXYDuEPa/aLofE5ut2eQrgalionj3STugcoSRURC5PbfsvOPqE5lp03udyLOgqa78/diG4p2AZ/hvv/SWMQoHYukRI93HF/SJrg8qhuDm2OnnmFDzC/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eERiE8wnyd3Vf4jQoIXzNjZm7iIuh5bkzNJdx04yT2A=;
 b=S/9+G1atcZ8UBd4HupsO7BxACd9D/sMMEx0a/ZeFw9XCaLDdQuJrsyIm5J/OqJTr+VynY8Z752sdaUjjYb5iyy/sec5deYzWQh1JZ8r2V+EZ/0pfrgaM9/aUD6+nndEHu7wSQibkD2oW5mqmLCx/6M3eXW4Y+x+hTPaU7e58iaj3YpHR7DLUBwM0ZmlFMq6JgNVNbzlPOzENXWyy+cVapACym9TImyHk6r4OBkbnk0sy/OMVzHyD1RjigaVhulvI4xQvo+xUelO7mV5iXSbFL28WaTM/39sBs1/U/kVrZOyJ8Six4BWFw859N1FEpI65Z7X3MdaewlMpY8n0oXuxxw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6558.namprd12.prod.outlook.com (2603:10b6:8:d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.14; Thu, 30 Jul
 2026 14:15:01 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 14:15:01 +0000
From: Zi Yan <ziy@nvidia.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH RFC] xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()
Date: Thu, 30 Jul 2026 10:15:00 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <F1505345-5A3F-4313-93A3-D80A2C0D2603@nvidia.com>
In-Reply-To: <amtcBZ-_QVRgCd6b@cmpxchg.org>
References:
 <20260727-add-gfp_account-to-xas_split_alloc-v1-1-9fae6bf64838@nvidia.com>
 <amtcBZ-_QVRgCd6b@cmpxchg.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: IA1P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6558:EE_
X-MS-Office365-Filtering-Correlation-Id: 55d4d845-db6c-467b-dd3a-08deee44f1ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	TxG0NM6RbBVRdMgpVvwb57uGbRqXQ02LqBIaWisQp2a0TR/pSq/6GFKQ6GLeVoqslPsNQaB6BJL1bCgBIjP+3F192apPfoyxlmqeJYFEi2n33dGRaUZjcmFANk3l2U6tLXoSdtWRhm+KziRKy63nS2fxzZVWyQGPx9L+JkqandoQUlYFAragfBzIvpfUcBfkp9ttGc0SFsESiM1Qm18roKHPeDCRbM3UEpIRAWHN3t3fCgI7Q+AwoeHc5cwfqdHqnt9Rt+732r14aRzg8WE+XFs/SqdIUZQa8mpB6wEkF5jibiaGqlu9QjxyFoUy4xwvPVFW6/FTezJwZVD7Qt80leNcf9ZlaKzBQDJVYRhOHosQlh69WPFLnkReeC3q/kmDs5b4HfunZ7CGODYbkNW7aw68LqhmMrFB05gXZQJB4K2LqV9VSSMYvx411eH/hSn/XV+ufFejOjTchqHbYY+HH+o3J788ulp0qXqvvueD1GByhULKe2boJlzEv8uFvzRh/LwlZjV+8oMbqfJrTtMTrlmfFd8v+wI/ShfzfiwD7LOsBU6NX6MVn/nBvtTZK/vozeCu+qUr221cEKvY5MRoIk+r72VWywvVnOoTxEXQpVnHiPERKwsE9z+CAqBWQDB3FvuPfMG2UHtUQ5Bd70GhpVL1UtbdHAAboFfiRCKsmS8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KzWUxJ6TA/SwiCSAsOeQO4DZO0hm7NnTJ2QkYjaaKUWVUYduwyW0KsLa2bdB?=
 =?us-ascii?Q?6RW4g5FsyXEQRuAC5ZrfQ1kWnjbnzm48s/pcpBS9akGzBBP73Dy6W+khG9rC?=
 =?us-ascii?Q?6QQslVNqKDlZBTjBLVJbA48m9CvGuJAk59QyhxbCKMcxNUVa/2PNehIMhNSl?=
 =?us-ascii?Q?wXsGL0CUh1hFyxjfZjKM9NYdj/M8upwxyhNLetM5l5m6gSYygtRI8kcPh90I?=
 =?us-ascii?Q?rDw0hYK6SzX+q3XyagugAm7vy9zE+oEN1+2hVu00IJnZiibe60EC0/J/L27N?=
 =?us-ascii?Q?IOYLtmzIpncgQyeLVE41K1zbtsAlTJeevmtkvO3R1EIRMIhBYB4OD4d0pz7z?=
 =?us-ascii?Q?N6ZZqXaesAUamVIXC8buM7lP0EwqneDzKRIwUxkjuASoVKhbkJvrYxkV6IN2?=
 =?us-ascii?Q?G1kn8meN/djWT+Ou8oyOXPgVVmAQ41Eh+oEuURLaPHnPp9J8m221SSSUHeeB?=
 =?us-ascii?Q?uZqF2pakDp+prc49SNTqLt5IEhIr64tISwgYOVdttZDsVZ9ISCHS2nw49wSz?=
 =?us-ascii?Q?33x/gzEgH11BXY4gD5Am99rSCyFSfKmGEGKt9+8Qkq9wzb2A3IM8baT9V+DK?=
 =?us-ascii?Q?3wKn43n/oLNmLDbxbSAZ4uTytOGvmH897JZnVJhfGEVBu2vZJbI2QB5Aushw?=
 =?us-ascii?Q?4AC/887R2QpIPwcJ533L2WGKQcKS2L4eapvRylzLeKYc6wVp9/u9aD3qNUEG?=
 =?us-ascii?Q?IHm63aJ5IPflKmcCwgEuRA5M1x68lc3tzCgWhWFR9mFv3JlUokfTdy7OSiRG?=
 =?us-ascii?Q?f3mFc5t/YB8ZdMp1Y36lbNn0I8ezTduTd5GvnT1DLGvL5olCRSji8GjGMSEb?=
 =?us-ascii?Q?LMsjgg9+Lhbe1I0SrtnGxfErfdrwyP/5wigQTNQrfLqM3il+gXXeJudoN5OY?=
 =?us-ascii?Q?fPfZcxz8E8UjoFSMQuMlSPZr50h+vJhYZNhbKbdtEwrDeuFVVR66cgSqOUPL?=
 =?us-ascii?Q?GHVZXF3RUc8OZCOhCspOExJrPLl25KJg0rOwWn2NHZoRtNJCZWq4oEeuqFGb?=
 =?us-ascii?Q?NWJAHOhQl8dKviKal982ocLBcXVmCFXz49/OGm/mQBWsOg9I0dAC2o93lZZV?=
 =?us-ascii?Q?+LAb6fF7oU1V1hvlCF695W1pQ+aezXWN2SyZjnG4xA6TxT7ksLODMmkfwDBf?=
 =?us-ascii?Q?sZban52RQWv/w0TU8EJGnurSzAP0SXyupRx6XSJPLrlzAjn96A0JtoEsuel5?=
 =?us-ascii?Q?d48ojwcs/EhExSxpw2LtMIsOHL5XiVzLpaC7aphhRDZQEuRFTyqUvMNPLhBr?=
 =?us-ascii?Q?RbOkVLw6/4JQGzFOxugFabsxigUzQtCRp8q9YkxyzDjCstfnRd1c/CE/+Bm4?=
 =?us-ascii?Q?rZvwS3oRE/vbJDlbQZFmmORXETNexZfdUPSqpMkWB269nEVKlmswXl3wMJls?=
 =?us-ascii?Q?clfIo9DLRbgX+adBvaj55LAfhAlIB+MVAthfMQtDhtcHBhqvo1wwFQMsH++x?=
 =?us-ascii?Q?JR8hveJv4yOY35ObZtTbKdeC440snvOWh9+8AoEWJDU86fmuN6GCXs+eIdc2?=
 =?us-ascii?Q?0rIh09S/AfYLRhkTiGOZJ9h8BVNKJbKMnn1EZEy+NAMsolme+rb5+ybU7BR2?=
 =?us-ascii?Q?JecnjaAdCyU+dWlZWlRD2ESdBvcvLc9JYe3E6Xjd44J1JJskhragFGO2mPRN?=
 =?us-ascii?Q?GuheUxpGho/8QuI1Bx6po0ANnDns0txrD4crGvgy47F2E9ERrUsmEOFe1XRQ?=
 =?us-ascii?Q?isfWJLd1GN09I09xcIg0V5dR1lY4PeKTyXjM3lU26zoCEHRwZ3BhAaDkruP3?=
 =?us-ascii?Q?+E+Hpa+c2A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55d4d845-db6c-467b-dd3a-08deee44f1ae
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 14:15:01.4625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lruCTz9BOGMRbJT+uSpOUppH+dMi1mc4W+A/LF+W8Upgd2ZdP3jC46PoMExwAIrR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6558
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0691340019
X-Stat-Signature: 3suj8y74iq1smakxyh9i58d4mbt3s1o5
X-HE-Tag: 1785420907-610355
X-HE-Meta: U2FsdGVkX18Ys43FxFUwJc/Koe944PQ/2CsV1jn/r62UniS+BO/8qZGnwIQHdu45pzt04k1e3rwKDrUUS9TrfXsLgSzWrrRVdaueZC4WuSj21RRXuOjdZpm6g4lGBQ+ZLXkb2TJGKn1Suk+tvz0DiEHSV3P5k9RNiqviRXecePZuvwuUMAXe3CiWt2gPBY2gqpYvnAcCXGH/AOgcVvNiq7mGZiXf+yvE42OITSq/SiNTG18DP38xWJlacASA5mVVpLG5iLkkRHRm9no9ADTsVyPH+zaJFE7nH09dQ0YopTjcm2rIBYigJP8hWz2a1y+JR+dT8+E3s7S9j+4pdUvsR765RmpEZZxXvJo6dIqoHCJDT+d8ysUv/XHPFYdEalNIlwUxTcfnGBYxnj9i2Ne3MnjqwRnzT9A75I6nKdBqrglnoFRoRDQhKQXa5zMg5dWMlAGSTBJtLU31G2iFWbs0j9lYLxrOF1UUi49+sd1dmAe8MqY7wvrqCUOi5caBa5Ik9V2672MKrUwdR1VCGCTbYkOKlYoOCFsjkmwS7x14g/myRbKRSnywg7JLZwbd1p9EbMKi0XcHq5Pt4Dns309eRexh2T7J1aXPu+t3FrXycCs/xv7Fuvdpp97prX3eAQHIIMvbidGVxmsjvaQXQNjfekx0kGjQ/hRCivsNpNP660DG0BR0Z+aerrTBn+BtB+fROEkIGQgxJe12bid1H2F5D3ScCnT+hehWuu+5wiae6QWm+SaJTyKtYArWg2uyMoHOq9MPmFdnBf7e3SFweUp32NHFMfIW11Y3CKlgQhx9JWLFcynL89mLa2TyFoqY/cXOyhkuSaIe1fJny21tY4PMALuWRi0zpq/M48ryZ4tZSvzApj8IcQVc+EiXz5YHa31SbLhqat4+JrpGeu9Y/tUXvbUYB30K0U1dYOJZDsxks++HNHXW9bB9ErNeW022HFGz0Ypo8rdiHXO00vEHSWy
 PVbINUqr
 9db5X6ZcdZcH1QghGlqSBe6GRkqLJl2fzE5fTb2m3ppfpYrcR4p3d9Gs0rxkk+brpe0EanaM8fszoDwiNldBPdqZF3KaPJYatW5wCNfdZyqQrvy5CD/egMqVqWdcWfiqt2RZN79oDlaDKnNYlb94svyspalUyB4ixbqvBlqiRVYsiWMvEfrue7qQHF0HNKoZfdxXH0nsumENFcAAzZfk8YKHZPQfbYaHG3hIVLi82MWBIUcqY9VGEctqondFR+JAgT7QOpR9qIqvnRagF9NRxBQOdpfL3N/NuPwcrdck+g4zd9xVJA4VCgJ35fzLUzCtIKGpRA6AhXFA7+AYPeu7u00cuZlvHHvirAKGnSl4AvNxP2PlMEejhYX18iZ+1RBm2QW2FE0AMFADfYYvPcPwW4ju2hL3g43Hg97E2Gva5++5OlSn0SoI+KuoDsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Jul 2026, at 10:13, Johannes Weiner wrote:

> Hello Zi,
>
> On Mon, Jul 27, 2026 at 09:51:40PM -0400, Zi Yan wrote:
>> XArray operations that allocate xa_nodes, such as xas_nomem() and
>> xas_alloc(), add __GFP_ACCOUNT when the array has XA_FLAGS_ACCOUNT set.
>> This charges the allocated memory and avoids the workingset convergence
>> issue described by commit 7b785645e8f13 ("mm: fix page cache convergence
>> regression").
>>
>> xas_split_alloc() does not have that flag. Add it when necessary.
>>
>> Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>> Hi Johannes,
>>
>> IIUC, __GFP_ACCOUNT is needed for xarray node allocation accounting when
>> XA_FLAGS_ACCOUNT is set. Commit 7b785645e8f13 ("mm: fix page cache
>> convergence regression") fixed a workingset regression with it.
>> xas_split_alloc() does not have it, so I imagine xa_node allocated during
>> folio split would cause a similar issue. I would like to get your
>> opinion on this.
>
> Yes, you're right!
>
> As we had discussed on the THP cabal call, we should use the memcg
> context of the folio, as that could be different from the callers'
> depending on who's doing the splitting. I.e.
>
> 	memcg = get_mem_cgroup_from_folio(x);
> 	old_memcg = set_active_memcg(memcg);
>
> 	xas_split_alloc() / xas_try_split()
>
> 	set_active_memcg(old_memcg);
> 	mem_cgroup_put(memcg);
>
> There is __folio_split() -> xas_split_alloc(). But there is also
> __folio_split() -> __folio_freeze_and_split_unmapped() ->
> __split_unmapped_folio() -> xas_try_split() -> XA_FLAGS_ACCOUNT ->
> __GFP_ACCOUNT. So it would make sense to me to set up the memcg
> context in __folio_split() already.

Thank you for the detailed analysis. Will add memcg context code
and send a new version.


Best Regards,
Yan, Zi

