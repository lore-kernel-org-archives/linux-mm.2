Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9692C44501
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A516B00A5; Tue,  7 Jul 2026 11:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41076B00A3; Tue,  7 Jul 2026 11:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A308A6B00AA; Tue,  7 Jul 2026 11:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 701326B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:30:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1C2D1C386D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:30:24 +0000 (UTC)
X-FDA: 84962367168.18.2ABF131
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013029.outbound.protection.outlook.com [40.93.196.29])
	by imf12.hostedemail.com (Postfix) with ESMTP id ED24A4000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:30:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=W0p9ZA2h;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783438222;
	b=EUxyv7A4NsgdE4WgKs4aBr0T06SCHcg0LjJZlheoqOHm6KNbr51zUbO4yPRunnJwdTkMgY
	avhisTn+VAbrOHiQ0X7o81GtLzlpSp84Z/w9gW4G3lie6pxq7qyI6LFiCyqKcYM9nRzrWI
	4YUOA/FKBJXeuWTHARpxEd/yjOKUlk4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=W0p9ZA2h;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783438222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgRoLVgprQdjCgQ42otdQ2wHR+AiioM3EBEJgYHcPao=;
	b=TvZafhPkU1iJHEv2x8zRfztTyw/ROqk15PqKJX3mQNeVH3CJzKO3tJqraneH9v4zjHUtEo
	J4wNPTIZFMKAXudwYw+G9fDgeGgczg/6KvUfz56wgjQUklkyy1LG0kTKXjaHrZBpY7xPgt
	BvMlKhNKwTuAU137UGzE1k5Stfpcm7k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CLhorhSgIEywNg6sP9k60Z0XolrgoMSPmDjYWwnkzX7K9ff3azIYIFlQcUwYwLhmmrKSA+t09UDk2iS5RTN/iWGCQnO1NTqayjIz5cTNcwt8po5aNXjotRe/ipJTAU5tyNJYyhajap7AGqpJe0e7yGVcZuXnV8liJfHFLbmjwLK0ZcgmOTCL9D8WZDZtngwng6yIuwaJ7sHMW0uD+YxWQ9Zg6IWqV3EpQTb0ti8qcfV2mgGGuEiFpBj7y3g8+/YeNVKqZLqUYJEuRyR2y8iA97K7BSPeHW/KLXRBIIJCEKW7vk7mc/pMkxInYEueODy8ebNe0ke4f77jYQEo4VGNrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dgRoLVgprQdjCgQ42otdQ2wHR+AiioM3EBEJgYHcPao=;
 b=hRxRMaas2KOuFqQ16VLkuV+rCV75vcO2fchOjSzfQVzvatWRXPN49/JvteE8z7FfPoRJn7KcuxnLBB55rK5GpQcjM2/rbcMeiWQ0gLwUVVbpwVS4gARXIA5zyw984qVhlgUBjboAusFg5coohIETww41w9hr17j5HpK/y57cGTf88cPsEgxnApz+2GH+D6dKBy0E0LojPxfG8cFn/Qtr12OPqzIb6FZegU2Lnwmor/SBFxFaJYtuPuMqSoCGZD64RsX6wbbAGTSeoRHuAlKdRgsyWZc9jK1CCwJ/TLpFYHpAZgLUn0GlFXbG4cTvkUBF1kkgVAMryj9BK74LgieGyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgRoLVgprQdjCgQ42otdQ2wHR+AiioM3EBEJgYHcPao=;
 b=W0p9ZA2h+YYUqdamUsAX3mSvCAN5G3hCLzZhFKbkFqT3FFNluSpqiOeG2JtpJ3M8BiVqxvEC+8EkXW7HY3jHW34qmjOUoY+XIGlYBK5YPORZqNKhwOSNnpE5plMhrRG6fIjwLamXo/zEJCRl2c1vsCK6QAakLr6cIzrx1dqmiQ+3owAYR27wB8arQtLCMJa3/6/6dxViW2wB8XtG86poL66wZ2WuuTnQZHuMWykAzyn3dv7uph0qJfwW+xAItV9BLWkZBppfyG45u+98bJR+LlIBEjopkxWPxJyttqGZ595yxlToCQd81THL3rDPwqKcKYoUmAZd7vOHRYUIuMAHmw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB9080.namprd12.prod.outlook.com (2603:10b6:610:1a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Tue, 7 Jul
 2026 15:30:11 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 15:30:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <ljs@kernel.org>, Alistair Popple <apopple@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 david@kernel.org, dev.jain@arm.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 npache@redhat.com, rakie.kim@sk.com, ryan.roberts@arm.com, vbabka@kernel.org,
 ying.huang@linux.alibaba.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
 Balbir Singh <balbirs@nvidia.com>
Subject: Re: [PATCH 0/3] mm: handle device-private PMDs in walk callbacks
Date: Tue, 07 Jul 2026 11:30:07 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <58F8F4EF-119F-45E0-8B42-589070D37B4B@nvidia.com>
In-Reply-To: <ak0FtLIlTyCo_8lB@lucifer>
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <ak0FtLIlTyCo_8lB@lucifer>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: CH0PR03CA0450.namprd03.prod.outlook.com
 (2603:10b6:610:10e::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB9080:EE_
X-MS-Office365-Filtering-Correlation-Id: 3020dcc9-795e-44ba-d36f-08dedc3ca1c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xHrtdB5Z3kTUx5XMRMHL5BXF6CDscLF188CLqzV9DPTNcSXNPjBnYtOX1P2j0UsNbG2mn7fo0GBzFtN3auLFQwBJW4DGtS5jUgKP9iveUj4JPF+YV3Dvwyg5hju4+O1L5V0gtxkUGquzur3An8EqpvQ5D8vHJ9w3T6i5h68pKEwscCN3Um/S3cl/9AF9SGAAKkVADB7rwXkHnXyiNYZtOABdTHVSNoM+ymDH7NuUru+SqTmFqmgrnhVn9SulJ7yJLDhIGBD5XXq8RoCD66Sg1LyjkeREe1JiRLDlhP8ZDEicQu76Fo6/Wigd3UcaEBB8lnbMuAR7YA4GD/fM7HGDrQO72xc/EXHGSP3ory3aJgIq+qdvXNRk4+5CQyV9dT6RWecsfVfaZ3SsPTpT/iqu23P3XiqZj6ygEqd+KnFtR1DksQE6NtKCcrs/NyUpS5Gsel5Wwa5By0jBIdoLJL+iSaJ2J/vbzhZKEzjh4QewFvtSe9Xw4NNQunUl5oKJPSRc/MYks/or95/RJzCp+QAswUJr1vStnowgf7aNFQbl8cHuq5kHX4EiTRQf7u/X5/Rg4Bjc6teJaDnEWm3XxowBP1rhZNHIVNCEiqwvuAtlw0SPvRQX/zst/dATWI4GTUAEPjWITK8hyNLVIj2Xdb/d8B0fc+0/HLLQM2VLZTWrb4o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7LsU9MmBDhjb2CGaINBlqimCjgab27WXQz1WHRDIc6du3l7UMRIIVT8iH6R6?=
 =?us-ascii?Q?b8uG5HtZIJ/4TGZ99/Lr9f09TOPxXAsvRqiZBIuZszvlvEriJiEVK5K4LnEy?=
 =?us-ascii?Q?0msDRyeNHOdoH5hTWBgAG53y7SqkKb7bUfd9UImMpAvXfwafJ34o4Ydnwkwb?=
 =?us-ascii?Q?+kD3hpMB8V/Nok4BeEOv2fP+fBA39mCpQorF9mZ6ZYGz9cpjPZsb8Iyb+wir?=
 =?us-ascii?Q?SFhopl3kDDvFR+3ScyIw/qXEOYo6P1coIxzCIBLcmST/e8E4hU0O4w+vWZbI?=
 =?us-ascii?Q?S0MU7OSTDlZxQhDcQX+VkokVVl/rpeCt6CdRy+dMuJZKwoCuiFBQobP6wcIe?=
 =?us-ascii?Q?Z3LndSSUvXrhu8ZFE6PceIYo0W2mytPys0OLhcXoOHyCAD38ap6cqZRNBFzM?=
 =?us-ascii?Q?IOlVmJMAdGmXh7rsaqMekrhc8dtKwztLuyRSo73x9NGOQLCoLMKutQrYrVwg?=
 =?us-ascii?Q?twCTOQfMfzEDCHiAPh2zvWZkkUQ+v5K2WqGaQNhOiX7w5Or3G/twmN3Zo/sJ?=
 =?us-ascii?Q?0QpBUGsA9z+fIJMJhqNayBpNvLNtNfGfV5IbqYJmY8Jw9QvttgsOezclnCN3?=
 =?us-ascii?Q?G43Tcl3u/QpJLVLo9vougn2hIPzt+VxqDikEse2CHnG99X9eaTqdyT2VHkSk?=
 =?us-ascii?Q?H/U1BMDcnxXrLhz/V3tUrshxJhprk0CwKPn6WoYo+Cc4n0H14AHIPyK46mCw?=
 =?us-ascii?Q?9PLNrTdKqZIjh2gqmG7KOOw8NFlCoF7hBedkDTqSg6hBp0g7/SK0p3ow6ThZ?=
 =?us-ascii?Q?o0qb2cLOQOH/P9ff5ACzja1OxSrfV7Le+GcUy4inSp/ev+agDWzjvKw+QGo3?=
 =?us-ascii?Q?Ju3VXgFkb06e45bX2ZQvT2PGmFwPCp/ZT9nKACIAfnj6Y8gt+TQg+R1y1EMV?=
 =?us-ascii?Q?B7vIka7D64OnrXwzVeajy1SYaAXV2nqX6K1G5sEoRDioyfOBOuGQS014rQUF?=
 =?us-ascii?Q?f/A0iBZyr6VMnHL5UGkAG1QLJ9cwwzDmC7ar0xA7kDCGNauhhGbvaiuu7rvt?=
 =?us-ascii?Q?jLd1QgL15G63aKHz2SnswXb7ybRqK1SFtbPzmpHzsMY/kY9sd8NkCr5gJrGH?=
 =?us-ascii?Q?qAw66FZ8tKLKEddY48O8PpOtSap1CqYwhTr1qTYeQ9lEyDKjCIReE/gK/xLA?=
 =?us-ascii?Q?ki/q6N7KnLfF7ws+7k9qRdJbmLXuE+pK2FD9DTxTLc2YbwGKPEnt3HplpjqL?=
 =?us-ascii?Q?cmGcPAZTM46ruzTYv84C6CEltAusgKyXXBVa4w0sWfreMuvnlGCSIUY3hN2c?=
 =?us-ascii?Q?T4jMc1R+sE0wFbwdSm2yXPKaDWACFtwDYhuFql60QEK9KBHYtuSnVqGasEoU?=
 =?us-ascii?Q?IiF6B3qEf41jJ19vUW9ecOjAoOER0h0YY/vbeWKI49wCvrHuphrVtITCMFIK?=
 =?us-ascii?Q?zwyi9GiU5oNGtDbT27O0wCKK76xWkhgCbDovgtp/LGqtdbrjBMSwIDVeX1Sv?=
 =?us-ascii?Q?YcPrJr9xS/3y2YW27BOPvLluxMryEopakHXxG9qQ43TTJf3ugLLQkDQ6kyMT?=
 =?us-ascii?Q?MrJ6VlGEglJy4jthIIYJyooTjoCGdcrG2lDRrrmGp5uYcTpi5IeHc8MPF1zZ?=
 =?us-ascii?Q?P/ioCs3NmHQJpbWLlBhcDf/0vP7hwWtWVBrFkaYLO1Vo5mnE1BXl1031l3HU?=
 =?us-ascii?Q?spB+y0l3nGS4i1kiibMdx1c/lnOkfAXqHnNwHvVYN+zZKv7IDWb9GkAvAK/k?=
 =?us-ascii?Q?jW4NNvxQYjvD96s/4DlKA5/9LZwH/qEu5VIu41QWKsDEgJ23?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3020dcc9-795e-44ba-d36f-08dedc3ca1c3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 15:30:10.5302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RbiMMSgD5kcdfr3QcmJy316PAOu2yWO1+s6pFxcRR3/mN7Z2VybkgxzS+FI7pGGK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9080
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ED24A4000B
X-Stat-Signature: t5wnzzgjiwgoshxwnpnuhmxx9trzyzxg
X-HE-Tag: 1783438219-349563
X-HE-Meta: U2FsdGVkX1/Kc3jZz8HkltfaFz4qYcVIzz+rQb0CTSXmp11T4a85sTQ+xWMBRGmZ9KPkF2G6lWmBnfeIn+Hr6I6dpaKZXiTOUe6qNSv0YBFpTDXCBdrjewi4poAsTOT5FVy6eHPAyrEQULsVuoiAIYgcIODuoLkBQD9OVF6PZLB6mLJ2uzr7NE0P2JL9tTRyWMZvpwibSTkQZBwpXv/MEUiDrynDvXUzsk819cMrHzkgIe2Y04GANHVgGbWHbTIhsLtf8Rk1f6camfixHVS1bVTR2zokOgHO5A1wtJ2dgXDFaiwNmbqWussptAIEBN/9zdfQUkGc7vXzWyM+zjvSdpgLn4vy6nDB3V5JG0GLN+ExKuNT5oXM1XgKa3qivpocuqQa9Rx4adlzSEqjj9/VL6U+/obDb4lzOLQuNXhb0yGlwWG5HXbce+ncXIf7EDpFYCocz+IMg8dWW9QD0nig1jzBYcCaTsUgZXRtyF77Pggr9LytOphFJS4CKAo0susr4F42oY95/0jzb050P/lOtt4bfGNgNrD0Qf3C3yVQTPSwMGknhsmUP0jNOegXvdMHtkiEpmA/p9iRh/PRaEeZzirDkMxGNPwU7flOd3r+iRUp74z+gdnobehvWWwHNqSav9RTnBX0FmnnTgrHrNTRqVOVoqbjhAdDaCDfHGdtOfDW7NvBQ5ffLlF+JhY04315oCkQDn7Hp2wCfIyNFUcXrS8UDxkT5GZ22P/wdlLpZp8bN/QNizjmri2+uP8FvS9165hCZGMXbNwAzHrDy7ezWt4D+e5RVUjJ+HrXZ4fsGQiRBzm80ZcSGm1YZHtt1ACamko7JFf5SXY92eFuU6vzgzNcROny0BqbIbzwZ/TV8H6F/M/LHr9GvV05jRJsK2I2fNGMuaUzgPTvBlaBAJrY86d4Hia7wig6RsKy2MlNDzjISx5zWIxKKe8wZ86M2bWzlDp8x//eVrP0ckVK96P
 xbtOd9qC
 jRTmMVFq18Bqb21Ui7Zcq/z/pyzJjN8Ky4C1hll/Jde6T5Z/BmHzWqi8KIpbN3BDKbPyvtkVy3aaDLOWd7beGPKYEaa751FzfXcJTrqQ3pN33FsXILziXUXtwSuZXQFpMR1xyZB5h7xtm0jzTrFw0soJRh/Id4LE3hO4bIwEWHHGEZByTs3geXzplm7yOeAmxcsFs8oVzxVLizk8RYUJBOL57+iuT+V4arWjWfSsZzynD5Mtd+M/qz5QlhsbNx9CJpl2iUagYY0A2nZmvTgmzBjKD4/tjyNBGSXBtJiWW2x1d9qklaqKToP7/kD8XU+sEAasNIdAg8xyRAsyFJB2FBQKvJOI5j/h3RCasWIsbixVETlMWb+TMpP4Kyh847YteUBnjlBpAVgi5VFpsTebq2UFI4fIIxrq7soOS8xFvij+LKCM++I0uTpmZuVf4z/j+HzmJXse6i2rZxMHaAOm08O2m2DWsBly00bMy6pzZM2aY9M4hPNCVJdNRew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Alistair as well.

On 7 Jul 2026, at 10:01, Lorenzo Stoakes wrote:

> +cc Balbir
>
> Thanks for the series!
>
> I think Balbir should be cc'd no?
>
> On Tue, Jul 07, 2026 at 06:45:06AM -0700, Usama Arif wrote:
>> Since commit 368076f52ebe ("mm/huge_memory: add device-private THP sup=
port
>> to PMD operations") a PMD may hold a device-private swap entry wheneve=
r
>> an HMM-based GPU driver migrates an anonymous THP folio to device memo=
ry
>> via migrate_vma_pages().
>>
>> pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns tr=
ue
>> for any non-present, non-none huge PMD), so several MM walk callbacks
>> that used to assume present THP or migration entry are now reachable w=
ith
>> a device-private PMD. The results range from a VM_BUG_ON() firing on d=
ebug
>> kernels, to an oops on a bogus vmemmap dereference, to silently isolat=
ing
>> an unrelated live folio from LRU in the aliasing case.
>>
>> The first 2 fixes were reported as pre-existing issues by sashiko in m=
y
>> PMD swap entry series [1]. Hopefully sashiko won't point these out
>> in the next PMD swap entry series :)
>
> Yeah I don't love these 'existing problem' reports (distracting from ot=
her work,
> add workload, really it feels like that should be a passive reporting m=
ode for
> sashiko not arbitrarily added to other series), but sending it as a sep=
arate
> series is indeed the right way :)
>
> These of course should never block an unrelated series.
>
>>
>> [1] https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif=
%40linux.dev?part=3D6
>
> Hmm we've had a whole host of issues with device-private PMDs recently.=

>
> Balbir - would it be possible to audit all of the code paths and proact=
ively see
> if there's anything else that could hit problems here?
>
>>
>> Usama Arif (3):
>>   mm/mempolicy: skip device-private PMDs when queueing folios
>>   mm/madvise: skip device-private PMDs in cold and pageout walks
>>   mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
>>
>>  mm/huge_memory.c | 3 +++
>>  mm/madvise.c     | 3 +++
>>  mm/mempolicy.c   | 2 ++
>>  3 files changed, 8 insertions(+)
>>
>> --
>> 2.53.0-Meta
>>
>
> Cheers, Lorenzo


Best Regards,
Yan, Zi

