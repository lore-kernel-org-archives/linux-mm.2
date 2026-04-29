Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5FBEFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20AC16B0088; Wed, 29 Apr 2026 08:57:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BBC56B008A; Wed, 29 Apr 2026 08:57:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA9D6B008C; Wed, 29 Apr 2026 08:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECB876B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:57:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F807898AC
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:57:14 +0000 (UTC)
X-FDA: 84711593988.21.E7866DA
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012035.outbound.protection.outlook.com [40.107.209.35])
	by imf30.hostedemail.com (Postfix) with ESMTP id 97CF580008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:57:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ODIihV/X";
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777467431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ml/JjMkQ332UapRXWlF564/T6ly8qOUW7lMaH+UjNsU=;
	b=ZWTqzA8Le9H4/IPDqpcJ+xWgc7Jr7kJZtw7Mx5O79L+3GtQ8Czq4fy9ahEmO6cf4B6TNdF
	SVBZmxowy3XTvb+wqCIzg5xHN1JubqCLritwMZIYym++ExlJCCMrf8MlD19aAMqKmRcgbv
	RNX+/q51ejM8wwvl9/pPKAQl2MfAmBA=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ODIihV/X";
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777467431; a=rsa-sha256;
	cv=pass;
	b=j8NQ6ScEIFjss8DKM38Coz3diHIBolFnn6NYlXTOFGz7d8ZOes8f83yPpMjiC5JwpntYSM
	A8hScImqmDwBI31pxXoGnwy25hkn85WlElECRHL340SVGqpIQ3fSPq+r1Xw6DjwxEIBHFl
	YHObZFIC0kAjoGFwdzKiz/7c0BppTJk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TszpuuJYcA99CYQ5LazRLgmegDsJ+Tp/OpSBdRfF8JbTkR/0GgnQ35lFTMphttal6lrxF9iNsQa5eFWJMypQRciofkL3rf1Ntxq7Qdkwp1k1lRONVi9DldZo92GlvnpKZKC+ym/cws2HhEk/wpWnp+gagP/vHTASQaQWsjLXhmk1lE5IsYDHYTRpBFQoasLyQ3Cblg39gyFcRS4/MIGm4VVv+olKK7KshmyfcA0RCGLKbM5inldtaHOGi6nrSTbuHqCkE3M8GjIPh+DlF5yMKL/wakxdRD8hIJCJP8EHebBPYiZ8sAzB4XYQDlBBGjP1JXuLuz3XSXGzhksSWYGCbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ml/JjMkQ332UapRXWlF564/T6ly8qOUW7lMaH+UjNsU=;
 b=EofCq9XJLYx/o1PBPn3Qu0S8oZ/5Y9TRPMIgONTvLKw0LOYHsvdxAhzSHhw/sSiZtZ/iIYjOrR3t970ZZfgwNuVuC/k4mEKDBFW4tC50HzymjrEsRvypqHHiSYFQr1i6R0jn+iUUL5sk9dzEa8jwTC4JbhP2a0u9w3Hd8vr8xkD7vk7LyUvycpQaR+9524EPwikwx8bvs4pu65NIoVjibVwiFt3isJ+lCWU3kL8mL7tM/kfZcDnq31C8H0SgqMqRGIy8upK8sbO6nA/2WByupeRSF53TETPfWE4bRi60dn91gTmyWhTfUUfyUG0HmEgWE3eE+xpe0vGGL41tY2FqIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ml/JjMkQ332UapRXWlF564/T6ly8qOUW7lMaH+UjNsU=;
 b=ODIihV/XuWAtwRRCQ/NAh6vcq7UM2EJ8SiKmP7iW+S2j0ZkuDuM4PggFa7yFbi4wwkwN4Q8fYKi4Ad6j0FWIPWztfyP0/VHbtWlVf2B5NMAUzyPXHA4OIkmRfutc/6TIJnCS7vsbs1PMLVc5hf7EB1Hak/igGyCfPlQCI5fvANVRLMAtJ0vxCyL6WmNxTYFEDrLUkdDznLSJY2vlqWYQMHuwe+jKHcH/6wX9ImBT0jRgPgK6gR4Byp8IioMXYrm36PRUdayx8+rCC8zPDEzFRBi5KAOmNX57t2/8h7YpY/xEDiSPllt0thlz69Lo4Ijl1sJuDYL5xqitwpYrHRqV2A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS3PR12MB999241.namprd12.prod.outlook.com (2603:10b6:8:38e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Wed, 29 Apr
 2026 12:57:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 12:57:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, bhe@redhat.com,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 kernel-team@meta.com, Ying Huang <ying.huang@linux.alibaba.com>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 00/13] mm: PMD-level swap entries for anonymous THPs
Date: Wed, 29 Apr 2026 08:57:00 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <D3F08F85-76E0-4C5A-ABA1-537C68E038B8@nvidia.com>
In-Reply-To: <30bd8e73-d718-4a44-ac46-ce4579edfb10@linux.dev>
References: <20260427100553.2754667-1-usama.arif@linux.dev>
 <D491228B-A6D0-4B55-BC56-8709C107CB30@nvidia.com>
 <30bd8e73-d718-4a44-ac46-ce4579edfb10@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0193.namprd13.prod.outlook.com
 (2603:10b6:208:2be::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS3PR12MB999241:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c878fa4-a7b4-4705-3838-08dea5eed02a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9U7zFZTF0i9jMhltQde/ASi+V11d9Alw73NkvoZ9Pn9OuB+iFYij6Al/NhUnuT3WhLU3qZelv7S+4u1cGeFRyXXRENjNn9nOcINr02qVnhEaxTCkzj7DpwW3HO0PYwRHMOwnqshBJv19TAqiaJAydbnTvfNqlEQW70JbZqJmYbM2sqkJhFJRaZWs6w37LhdVW+M9nSrj80dl3+43noad+ag1s0IizwsWbk98nPvNIWJlv6ry4DoZCW+udPGmAV4p9zgXVjC8MXyCTPrk6fmNn8vqjwOrDu2bDIB3KpJUxy6ZyLcGKi5j0qh35uZq81HzVsYfYud/C1wtZRPTb+Sa0aVh25Wd//ZV/XI9hSN5GIJrLQJDQlgaOjZrm+Isp/VJv5G9GoECSAuXZFh1XcvMw8tKkkCoD2x7JyxXkm7V10FJ2GZYFKi1CYu8xrlpUqnfg+0L0FvK2LfO7YExV9tgNCHAtrSqIvq4JI/9wr4Nv5Vk/Rd6OcpjBlvkOpmH1IZ9vkoHxJPF4jfwy2cFG131O6Hs5AzOPtqP+u+zG8I1MZXeuiwRgZ2HJeTdU5QxFbJ1eGVJvpzcZBMob7KJeth4PdAS1GZX4ffdnKe4NjLW4y9eOF1LRuAGv8ztdZpktTrpCfZZNcN0mN7oDsg5llInVaxsJ/y4Trg211FS601NH/1biNjYxQ41o4GS1ezGvkqCdn4uzxVIiOhRhf+6il7QRE37cxQipFBnqfqTXYtH3Ms8eHUkZcgEMPNc6flGUP+N
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?azBpQIZ8KG+q8+ADM71UGj+JRYyq0lQ8etpV3jcyrO5E7uD3aR10UPEMliVC?=
 =?us-ascii?Q?HheEAIlctdvpruHxKMyp+aP6e4oJqHAqWifi7v0PFQG3cDcqN24NPIDit50h?=
 =?us-ascii?Q?xIWTxG+P8ia8Kms/CBTtJTA0l05ecprH6q0UZvoNYb7MCpmseLoqA8/yJG62?=
 =?us-ascii?Q?2zWFb/tIN+ygs4ucy8OCMPNHnIwaqEeH1qnmbUa3N+vgwkXKWjIGXdQWR9Bz?=
 =?us-ascii?Q?PCuwqAab4tkdqb5rI0Qwz/qoyh1S+eZjxNdf9cQQrhviVNucmgXJXL+KNO/q?=
 =?us-ascii?Q?jt6moWxeHj+KGUqi2dX7yguH+8ZrseTJqhXNx2x4t+mwJB8f9YhcfmeEDLzT?=
 =?us-ascii?Q?Ic302NKwD1s/XmDbZlrHq6m9MA0c4CEfDORtTYl3ofgoXIcw4XgBBRd6uqXD?=
 =?us-ascii?Q?su0bu1X55ukg34sjPtELP9Vh/X0KxvkJaBsBSdAwLehgJmQAFFlVEX/oKjey?=
 =?us-ascii?Q?KQT9w7qFH6YZLG6TzT+C+7epMtpERcZTxZzPQ5oJ1vULVIN2sdoPhBiJiYdX?=
 =?us-ascii?Q?w2BR46XRimn8hwuwnBncAsefuYD7EPGXvUuU4DbZDbOXKYnjeCtegW+hKS40?=
 =?us-ascii?Q?ujf3t9PioCdZCJ9USpQH25/+Zl28prrpXO/UNboRHueMB1k1ohkYayel51UH?=
 =?us-ascii?Q?ojnzvuoxyCmK9HROE5vtgeWHJkDLCeL8RrWVMytFJRPtyAt2P/Saggv0270T?=
 =?us-ascii?Q?MNqLmkwZaKfH5LucizvDALqKxLfQ/T8jm5cfPa3JWPRt2taGmQvFNwd0kPqZ?=
 =?us-ascii?Q?QI3rBJPxbSG0Y0xL3pA5s0C43LyoT6iK+lGzHd3vd7OdhJEzpFffp0FQXqDH?=
 =?us-ascii?Q?swiLSl2N7/lAPus19GLGz3GwsUTHVAFAQLuexbpS/5nrmoqVtiyWWHO57VW9?=
 =?us-ascii?Q?83VJ3o4QNIjK7i+7FF+ft+Obs5cTLGxKZ06kjsAsDx9dvk9wxdqr8srDRIhU?=
 =?us-ascii?Q?CaTO+ukMXY4gsIXRFN7c6EDEFWEHsd95Yz2awdlpcwb06moDebArqV1tdJCW?=
 =?us-ascii?Q?O+lmR/Qq1hsdJ4dqjJWq31qHaMBcxaulJ/Z8tdIosB2HSjyqWNcEK2C4/XPY?=
 =?us-ascii?Q?4anshEQqSdYzJO3uZk201+/htclqrTNGNqBh6g6Ey7AlyEom97BPE6HEcFgH?=
 =?us-ascii?Q?87YQkiHatS9NqxU0WR+zxziFgdM2riErksOeXqIy57P4cEMTGhiJbIg9tAKG?=
 =?us-ascii?Q?0DLTpWfhi+aQId6QEDbBeQwMQUdvvUNLdiEHC0awzpplEiWDR6X2b47AjGIS?=
 =?us-ascii?Q?SnQcw/z4LftgQib/GCIRb76P8493a3xOGlkL7K9+obHzx2n1p0rYlUkXWyWh?=
 =?us-ascii?Q?2kivl5zBObnR9GbGXcRt22ZioNJiuRmqZEC3cikLu7M6g/IvbNwdL/zPdIhi?=
 =?us-ascii?Q?jGTTEbPzPpO7/LlxOcbypgUuHJ9erVMk8FER1uC8Gtp1yEvsMhp4cLRLLcWo?=
 =?us-ascii?Q?JorRIZWAUkJhrlb7v+mFBUd4cmew7rm/EUVuZB+owujWgfbw2iYnpC4c4ZDp?=
 =?us-ascii?Q?PTqwvONxbh+x3Nvu85Z0rDxZq8AFRzzBBjWL8caJgq11NXHI13J0R4HcMv34?=
 =?us-ascii?Q?gg//OiEZLGoMhGhPrTiNLU1rFjiIB5eM3tb612oWuIQe9n2PfuauF+Plgvr6?=
 =?us-ascii?Q?mvlNWSf6oT2JXtvSyUyb2aBuiiChUBF3+dR8bsuf1O0rKRiXcnGqieLHkZAI?=
 =?us-ascii?Q?Cq/EbITQypSWk2xdLc5MtPB/D9zcRfa6DLJgLIwx2glaoGIB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c878fa4-a7b4-4705-3838-08dea5eed02a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 12:57:04.8582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C75A7OWbm8YZpQrsY2RDqANxFYfl4iweEtRn37cMRYfQVglyw30fT/PZ9wmAkK/f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999241
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 97CF580008
X-Stat-Signature: 39i8ccqnkqebsc5diiimqx5pyzapek1q
X-HE-Tag: 1777467431-955282
X-HE-Meta: U2FsdGVkX18pQucpd/qnQOV2ECRXl8AygRgqn1MrO5Zt/VehBnjyaOGZfn6TRPgZQUgAJfyrRGLTmdXLd0r+DnzxyEzOrIGmoxR83UDUSF0UaZvslquV2WttLOJirn6VIeLLTXqqOqrHncWfU3lWd9yQ/77N/k1JNHm3R0cgpNCYnp8cX51r9L0q4m4yWVKurnDam90ebYOH0hb66Wb7ML97jrbNLKs3rk6kk22Wx8PuV0TW2SkeINIpXI4VWZJHqTyD1+aJCmM036XFp9eMfWjn1/AHG+fSnk93fnN3cGp1D+MaVL/UdulHxjEZ/g42CcwJTPTwVVZCZFFKf6aUsKR/z2HZNIPzyl3kqUcXwQlR2cAtCaihBPLFoat+m6bsfK892J14L8I0kjrrB+R3BOD8A7gzEsdg4gKVxldcPhZ9HrlfVfz3KT+EAi3v9wXdiNkafMlWPmTJ7qxVmq0Uw8Cn/bX/9mCm6xAlfN1N/CkIKaVkr7Oay3coWOLnB+/tfaLsC7735SdGZANVdODgaWoI0t9aSRq4F4a1q9lCPZpbOlerg4sG1PN14SZDPk2a2/F8euU+eqOTK4jguK+kOw/ZifOqWQdsOGh+6HPMkBAuwhw9VYYccOH4URb7O+8dA2qnvjBUj5i+UEDM9lG7t3Qnk3E3D9ojDbT/bG/pWa2bIKk+wTMXXb4qBzqu87BERE2Ql7bw+lANvKoCt430yFMU5uDF/j4JpWTrOIEUsxBUb1/FNWgOhNSE2SvW7GRHh0tqrrFVKG+UemrM8V1EdOoJCCcuXXEEcVswX6xFSr6zRusMycPHNU42KeN1QI66RGZSao67H1xxND4fSTiMJExT3xy40T88e2X1woZPPxTxIY0ta1nXRfjglai892RnyfIbJlDXpGTq2qF6nhyDiZ/FhkiU1ceaMDsjqZLvYf7BN0d8OhI/5CyAUzXomjKxXxK+z5Pwtl4fsBe9zqj
 yffSwL53
 CnD4eVGANwVj2vLSfEGgaGTaYZKGXajQt5Ue4H+7VkkCPCyzE9WQhBhmIq8y/NEZWFiXNJxt4Dl0MUIkmLLYTzAk/Le/Yszy09xTkr3nNWqAVchqsTXnq8glshLzvjAlXwsPcxbRXpfNqSLmmhpsaveK2tLK568EU5yIlF4m3QhPQX5154/2JucwmPQfg1SFKMbuastbUy/fIUqS5iwLM8S0IyND+JfrcESzu4M61UiSZ7GJXIj3958+wHSAQD/VjNc9hsLAweAFfMBIPugmQWIUOUU/SWk8Fd32OqYtbsIERJrT0DOpcAs0xTtvsAG5rBPiq3q02vEcvY3q4XIVqlDukGms8TzzKKO0vMsKvRn5R+H2SqgJzziQUtJXI8qJx/EleWlblVgq+3YEDQlUiuS0jgsg7kDtr2bVLHqOBep4stMXIA5o5FfSPXhGJGl0F/SR85fz+Os4xZRcvD2CqdkPb66+oiCcMK6Hm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Apr 2026, at 16:12, Usama Arif wrote:

> On 27/04/2026 19:26, Zi Yan wrote:
>> +Ying, who did the original THP swap work[1].
>>
>> [1] https://lkml.org/lkml/2016/8/9/588
>>
>
> Thanks Zi!
>
> Sorry Ying for not CCing you! checkpatch on the whole series produced
> a really long list and I wasnt sure if people would start thinking of
> it as spam. I added reviewers and maintainers of swap and THP + a few
> folks that commented on previous related work from which this kicked of=
f.
> I should have just CC'ed everyone.
>
>> On 27 Apr 2026, at 6:01, Usama Arif wrote:
>>
>>> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
>>> split into 512 PTE-level swap entries via TTU_SPLIT_HUGE_PMD before
>>> unmap.
>>>
>>> This series introduces a PMD-level swap entry. The huge mapping is
>>> preserved across the swap round-trip, and do_huge_pmd_swap_page()
>>> resolves the entire 2 MB region in a single fault on swap-in,
>>> no khugepaged involvement is needed. swap_map metadata is identical
>>> either way (512 single-slot counts), so the PTE split buys nothing
>>> on the swap side, it is purely a page-table representation change.
>>>
>>> This work was brought about after Hugh reported that one of the
>>> major blockers for having lazy page table deposit is the lack of
>>> PMD swap entries [1]. However, this series has benefits of its
>>> own:
>>> - The huge mapping is restored on swap-in.  Today even when the
>>>   folio is still in swap cache as a single 2 MB folio, the swap-in
>>>   path installs 512 PTE mappings -- the PMD mapping is gone, the
>>>   freshly-materialised PTE table sticks around, and only
>>>   khugepaged can later collapse the range back into a THP.
>>>   do_huge_pmd_swap_page() reinstalls the PMD mapping directly in
>>>   one fault, no khugepaged involvement.
>>> - Memory saved per swapped-out THP *once lazy page table deposit is
>>>   merged* [2]. With lazy page table deposit [2], splitting a PMD into=

>>>   512 PTE swap entries forces allocation of a 4 KB PTE table page.
>>>   The new path leaves the pgtable hierarchy at PMD level and avoids
>>>   that allocation entirely.
>>>   This will save memory when swapping, which is likely when there is
>>>   memory pressure and exactly when allocations are most likely to
>>>   fail.
>>> - Walkers (zap, mprotect, smaps, pagemap, soft-dirty, uffd-wp)
>>>   visit one PMD entry instead of 512 PTEs, reducing traversal
>>>   time and lock-hold windows.
>>>
>>> The swap entry value is identical to 512 PTE swap entries (same
>>> type, same starting offset), so swap_map refcounting is unchanged.
>>> Only the page-table representation differs; the swap slot allocator,
>>> swap I/O, and swap cache are untouched.  The new path falls back to
>>> the existing PTE-split path whenever a PMD-order resource is
>>> unavailable: zswap enabled, non-contiguous swap allocation
>>> (THP_SWPOUT_FALLBACK), PMD-order folio allocation failure on swap-in
>>> or fork, racing folio split, or rmap-driven split on a swapcache
>>> folio.  Walkers that previously assumed every non-present PMD encodes=

>>> a PFN (migration / device_private) are taught to recognise PMD swap
>>> entries.
>>>
>>> Patch breakdown:
>>>
>>> The series is ordered to preserve git bisectability: every consumer
>>> of a PMD swap entry (split, fork, swapoff, walkers, UFFDIO_MOVE,
>>> swap-in fault) lands before the producer.  The swap-out path that
>>> actually installs PMD swap entries is the very last functional patch
>>> (12), so no intermediate commit can leave the kernel handling a
>>> PMD swap entry it does not yet understand.
>>>
>>> The first 4 patches are preparatory patches. Some of them (like
>>> softleaf_to_pmd() change in patch 1) are not exactly needed but its
>>> done to hopefully improve code quality and so that the PMD swap
>>> entry changes look well integrated with the rest of mm.
>>>
>>> Prep patches:
>>>   1. mm: add softleaf_to_pmd() and convert existing callers
>>>      PMD counterpart to softleaf_to_pte(); needed to construct a
>>>      PMD from a swap entry in later patches.
>>>   2. mm: extract ensure_on_mmlist() helper
>>>      Hoists the "register mm with swapoff" double-checked-locking
>>>      pattern out of try_to_unmap_one() / copy_nonpresent_pte() so
>>>      the PMD swap-out and PMD fork paths can reuse it without a
>>>      third open-coded copy.
>>>   3. fs/proc: use softleaf_has_pfn() in pagemap PMD walker
>>>      pagemap_pmd_range_thp() today calls softleaf_to_page()
>>>      unconditionally; a PMD swap entry has no PFN and would crash
>>>      it.
>>>   4. mm/huge_memory: move softleaf_to_folio() inside migration branch=

>>>      change_non_present_huge_pmd() today calls softleaf_to_folio()
>>>      before branching on entry type, so a PMD swap entry would
>>>      produce a bogus folio pointer that the migration-only code
>>>      below would then dereference.
>>>
>>> Core patches:
>>>   5. PMD swap entry detection (pmd_is_swap_entry,
>>>      softleaf_is_valid_pmd_entry) and per-arch pmd_swp_*exclusive
>>>      helpers (x86/arm64/s390/riscv/loongarch).
>>>   6. __split_huge_pmd_locked() learns to split a PMD swap entry
>>>      into 512 PTE swap entries, used as the fallback when a
>>>      PMD-order resource is unavailable.
>>
>> I was wondering how to handle insufficient memory during swap-in.
>> Here it is. I have not read the code, but the split should be
>> straightforward, since we already have a contiguous swap space at
> m> swap-out time and the split is just to enable PTE-level swap in, rig=
ht?
>>
>
> Yes that is correct. Actually patch 6 was one of the easier patches.
> If the kernel can't allocate 2M, memcg charge fails and a few other rea=
sons,
> we split THP.

Thank you for the confirmation. I will be mostly AFK in May and will
probably check the patches later.
>
>
>>>   7. Fork: copy_huge_non_present_pmd() duplicates the PMD swap entry
>>>      in one folio_dup_swap() call, with GFP_KERNEL retry mirroring
>>>      copy_pte_range().
>>>   8. Swapoff: unuse_pmd() reads the whole 2 MB folio and reinstalls
>>>      the PMD; falls back to PTE-split + unuse_pte_range() on error.
>>>   9. Walker updates: zap_huge_pmd, change_huge_pmd,
>>>      change_non_present_huge_pmd, move_soft_dirty_pmd,
>>>      clear_soft_dirty_pmd, make_uffd_wp_pmd, smaps_pmd_entry,
>>>      queue_folios_pmd (mempolicy), check_pmd_state (khugepaged),
>>>      and the madvise_cold_or_pageout_pte_range / madvise_free_huge_pm=
d
>>>      VM_BUG_ON extensions.
>>>  10. UFFDIO_MOVE: move_pages_huge_pmd() learns to move a PMD swap
>>>      entry whole via a new move_swap_pmd() helper modeled on
>>>      move_swap_pte().
>>>  11. Swap-in: do_huge_pmd_swap_page() resolves a PMD swap fault in
>>>      one shot.  Handles racing splits, SWP_STABLE_WRITES read-only
>>>      mapping, immediate COW for write faults; falls back to PTE-split=

>>>      on any PMD-order resource shortfall.
>>>  12. Swap-out: shrink_folio_list() drops TTU_SPLIT_HUGE_PMD for
>>>      PMD-mappable swapcache folios (when zswap is disabled), and
>>>      try_to_unmap_one() installs one PMD swap entry via
>>>      set_pmd_swap_entry() instead of splitting.
>>>
>>> Testing:
>>>  13. selftests/mm: 12 tests covering swap-out/in, fork, fork+COW,
>>>      repeated cycles, write fault, munmap, mprotect, mremap, pagemap,=

>>>      MADV_FREE, UFFDIO_MOVE, swapoff.
>>>
>>> Making PMD swap entries work with zswap is another project on its own=
 and
>>> should be in a separate follow up series.
>>>
>>> The patches are on top of mm-unstable from 23 April
>>> (2bcc13c29c711381d815c1ba5d5b25737400c71a).
>>>
>>> [1] https://lore.kernel.org/all/6869b7f0-84e1-fb93-03f1-9442cdfe476b@=
google.com/
>>> [2] https://lore.kernel.org/all/20260327021403.214713-1-usama.arif@li=
nux.dev/
>>>
>>> Usama Arif (13):
>>>   mm: add softleaf_to_pmd() and convert existing callers
>>>   mm: extract ensure_on_mmlist() helper
>>>   fs/proc: use softleaf_has_pfn() in pagemap PMD walker
>>>   mm/huge_memory: move softleaf_to_folio() inside migration branch
>>>   mm: add PMD swap entry detection support
>>>   mm: add PMD swap entry splitting support
>>>   mm: handle PMD swap entries in fork path
>>>   mm: swap in PMD swap entries as whole THPs during swapoff
>>>   mm: handle PMD swap entries in non-present PMD walkers
>>>   mm: handle PMD swap entries in UFFDIO_MOVE
>>>   mm: handle PMD swap entry faults on swap-in
>>>   mm: install PMD swap entries on swap-out
>>>   selftests/mm: add PMD swap entry tests
>>>
>>>  arch/arm64/include/asm/pgtable.h      |   4 +
>>>  arch/loongarch/include/asm/pgtable.h  |  17 +
>>>  arch/riscv/include/asm/pgtable.h      |  15 +
>>>  arch/s390/include/asm/pgtable.h       |  15 +
>>>  arch/x86/include/asm/pgtable.h        |  15 +
>>>  fs/proc/task_mmu.c                    |  47 +-
>>>  include/linux/huge_mm.h               |  11 +
>>>  include/linux/leafops.h               |  44 +-
>>>  include/linux/swap.h                  |   4 +-
>>>  include/linux/vm_event_item.h         |   1 +
>>>  mm/hmm.c                              |   3 +-
>>>  mm/huge_memory.c                      | 540 +++++++++++++++++++++--
>>>  mm/internal.h                         |  49 +++
>>>  mm/khugepaged.c                       |   6 +
>>>  mm/madvise.c                          |   5 +-
>>>  mm/memory.c                           |  51 +--
>>>  mm/mempolicy.c                        |   2 +
>>>  mm/rmap.c                             |  27 +-
>>>  mm/swap.h                             |   7 +
>>>  mm/swap_state.c                       |  35 ++
>>>  mm/swapfile.c                         | 144 +++++-
>>>  mm/vmscan.c                           |  14 +-
>>>  mm/vmstat.c                           |   1 +
>>>  tools/testing/selftests/mm/Makefile   |   1 +
>>>  tools/testing/selftests/mm/pmd_swap.c | 607 ++++++++++++++++++++++++=
++
>>>  25 files changed, 1554 insertions(+), 111 deletions(-)
>>>  create mode 100644 tools/testing/selftests/mm/pmd_swap.c
>>>
>>> -- =

>>> 2.52.0
>>
>>
>> Best Regards,
>> Yan, Zi


Best Regards,
Yan, Zi

