Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3637F5A8B8
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 20:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1086B0088; Mon, 20 Apr 2026 16:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9622F6B0089; Mon, 20 Apr 2026 16:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850F96B008A; Mon, 20 Apr 2026 16:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7455F6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:11:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF52E8CC59
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 20:11:01 +0000 (UTC)
X-FDA: 84680027922.16.61B62FC
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011036.outbound.protection.outlook.com [52.101.62.36])
	by imf05.hostedemail.com (Postfix) with ESMTP id E6849100012
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 20:10:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ud077J3u;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of joelagnelf@nvidia.com designates 52.101.62.36 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776715859; a=rsa-sha256;
	cv=pass;
	b=olXfI2bTtQqN9vloN1s36qsPOX7glqVPrGdltQgbaEQUNtaqc0h/d7iPwNEA/X8a+hfNzp
	8bGk+OKRv43jd7S6Avho6Sj9Lq8qQvtneioIyO/xQTY5u4g61YrxuS6h26EY9AEqk2MxfN
	s/tbXQV+7Jcl6Cwwe1aCEb3cQYvuxQo=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ud077J3u;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of joelagnelf@nvidia.com designates 52.101.62.36 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776715859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=k6vkah4oKTnsVsKENe/dzkV+z0PiUPQEtsDfBoSG8Vk=;
	b=2JfhcyRX3SZ/nY4InmYOMBa98yOPDOFd6GhYRuQDvKbiikRetVSaSUlbEjOKZNnLo9rGNY
	GxBBHw8MjxgNbAMP72whMgFDIcr4jk0KEu8seuY0q+qOJnLcgUsQcdtMWka2rMC6IXCucl
	nOI/I5eFYyvo2383u9hODr8y5QAjFpE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sZrIkjG/PJCeM7pkdI4LEa5opMZg/9PIX+EcJvsMjkvHA2ZHw2hw7AL1Hotic3E5BndGiNkxa6SvzZWeLIzrTTP3+oEKIzdDL0OQnYl1EezWx9Iw5Sq3g8EUtQ8AERr+YCxTJYe65AlPjF6/movPJDE/9x+qwTrFh2ZvhtoHiTU2fCF/z8GtIWfHKNnsxEzomiUH4hrqMKqCVXLHFDfH9q8wWlKYs3+S5NijOGeq3bjpvMyRj1QdSgpeFln7kYB3m/fdJ3q6+wY0zofWjHkJqcsO8AGu4vpeX/L1Q3lJz4XZar/bfCercPNo9M7T1ANIZ2OHqlrKsY1T1pwQ3p1alA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k6vkah4oKTnsVsKENe/dzkV+z0PiUPQEtsDfBoSG8Vk=;
 b=ULW4lrDjr6U7jpNfb8RkWA+TmK0vLQ5D7gaMtvjm4+zIuHEp74HQ5ry+VnqCSRwcV7xG/RiPSWmD/0Z/fJuEGIfTGn5qC0LDnZd4QoGiJNHC171Uoc32lMHS5Pdiuf8qJB/CPV/A15j3z2uOTZtNTQLh06TehpdDaKaylwq233TkDqSWfodaCE2nIDtMCtqA8b58e1D3LP8JS3CQG448+PxqGOjywKNAj1xa6mn2r5SUKIBCXEiwU9jdxqJuOJcsa0L/mhtf49VpCCE9urjzNaD4lkTFU5QHbpvhNjJLdqeG7DXHYxuyA1eiMVGVQMI6ieE2w3Q5o9WSXEnorzzhpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k6vkah4oKTnsVsKENe/dzkV+z0PiUPQEtsDfBoSG8Vk=;
 b=ud077J3u4Q+ZEeWUS463jOYu9QU32/j0qB1ytgSdvk5WJh2Xk2FXu5+J5hVCD/sMRtjrXT0K9SUnZ5Ae9CgTXuLUQqeFUnlbKvuZA6dRho1ug+Fe6D3OhkJFcYGe+k8GRPJ0lhGTWEiuXu9iyZoJD4vlhjuJsRrmLOUl5ifOoeltgvdDmor47TLJdlmjqqgdseujLg1Bh8fg/8J4IXD2GwAcdX7YAop07LcrF0eMOcFLwKtaG/ufJhOg3pPkkcrqk2n7g1cdAPJa+DJXOoAIyuekZ7tX6Nor3oFaw/8SKssvYjpeeC0QX1XKxrtEoTU94ROxCM6t8Cw7A1VszJfg1g==
Received: from DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) by
 MW4PR12MB5642.namprd12.prod.outlook.com (2603:10b6:303:187::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.8; Mon, 20 Apr 2026 20:10:52 +0000
Received: from DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33]) by DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33%4]) with mapi id 15.20.9846.011; Mon, 20 Apr 2026
 20:10:52 +0000
From: Joel Fernandes <joelagnelf@nvidia.com>
To: linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>
Cc: Joel Fernandes <joelagnelf@nvidia.com>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org
Subject: [PATCH RFC] rust: maple_tree: implement Send and Sync for MapleTree
Date: Mon, 20 Apr 2026 16:10:39 -0400
Message-Id: <20260420201040.1894760-1-joelagnelf@nvidia.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY5PR15CA0015.namprd15.prod.outlook.com
 (2603:10b6:930:14::29) To DS0PR12MB6486.namprd12.prod.outlook.com
 (2603:10b6:8:c5::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6486:EE_|MW4PR12MB5642:EE_
X-MS-Office365-Filtering-Correlation-Id: e32db0a2-9dbf-4e74-48dd-08de9f18ebdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IXEA1bO9eCcN8LMe2nDdD7AEccbpl8W10/hgNNrbLijhb/sikCkbSVJVjFfLLXVWafXGSW/d9a1WX8uFSX8x84pc42EhBALy5igFS74WBmooIvtpdk7hlnbg7ox/5J4yevgHKrz/wgVACJVrJidWiynJ8f8yUvTe1CRnw3TNZzmsnbkNwRPX+AZDTqMp/PDcWJk5YQnMvK3kSfRDvdxrRTlZVMHbm5gK6mvwZUkexZCrWnZJ7QJwkWgg8vafUudbhpHSFP63/c8wG6rWEvv/aXtjrMbR5hTHdsmZJHs9ElUrsFj7DMrDcaEeLb03KG3aahkniYKD7MKvDByap6r1afu1Ea7Q2CJud4/oBHyPE1c8uHqiMAnagSX52GqkfGg4AEtt0W65cnevZ47/LIBVIzuR/Cc35KbRU8xqJYSvnfZ1QDjBOu/agjU0sR5MLpYy6LpVKQQkfXT+fJ5xXF+HriGQRaJUPB5CD7xYM59vsIR3CyGvQCjyGkkNglKpjBrgMGu581HTjz03exiGlorcAKqeRkozCeMNKFhqyxpU9YPI40aOGkRENTe74xhGlzeQGj8oItJfBceaUihtzPp30oW/IcGHRgtwBDmRj6tZJOkFo5IvW2kJhO44z5cL2NfwNrjGP4pNWAys4UTMnERmmPeNucyUJA4jlCWb75ke8Zk+xxtpCAvrkfJwL5fveAz85ZmC9R6Yk1m025M8hgp2080fdCX4+Rq3lp8zfFKOI9ucgl3pk7ZPj9rvQmwIY2jDGK7C0ayXMGrEyosh6c5eiQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6486.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kWbbY5dbb323nM2w2lZhc47H5gm89ae9P6gpEDbQUSyMOGLu3Jm7hMiFtUug?=
 =?us-ascii?Q?0A6oTDfgmjtWxHeS2vhwrx3D8MlbJo6b1rb8ufGOkP4/O5QeQ5gmwDn2fzKI?=
 =?us-ascii?Q?1Sfc0rVH2n8sbeAlDqklckT83Vb0l0TtXqrUwvEFwSDz7pmL+4fhP8K93N0B?=
 =?us-ascii?Q?BE1SW2Ri2v5+0HpJWrbPfz3UUE7aBzTcjEjhlxhZMuevmVS/0Px47bVKB5AT?=
 =?us-ascii?Q?NNSU8fn0/hE/67lJTo03kcGYIrwlyedBL5VSuSo+paud08jTOIIIcBbOUNeK?=
 =?us-ascii?Q?9JuY4P9+EZcPVNm39Xihzj6mx8qXrocv1APnxbwSADSIbvcgV+PGOmbfl8d1?=
 =?us-ascii?Q?XoLiE+XVAHvzJtp4AFldsQdQGI4Fqutqyb0Dgrh8fJ76xxeFpe5/GuTy/wkQ?=
 =?us-ascii?Q?Y5dvL4M8ovj8gsp3cIekCCWfU6vw+SbcH7TadUtPLFQX5M+gGuuDxXKEcs02?=
 =?us-ascii?Q?L6AvCQCqxgSmkFh2QsTOYaweiHz9Mxoaq6jU3omrtxnS5URPLRyR/vAIdVbk?=
 =?us-ascii?Q?9f+9TZXDeWWqTGIYwNfehN6rzOMgi1P99DK3I4HFzzIOxv2AeXbAwhuOentA?=
 =?us-ascii?Q?l7JSbDlnyQQI38KAFPv0VCcIKOw8U2To8Pyr/osmYTdt+eXbC0lz4C/jG6fI?=
 =?us-ascii?Q?9vgdwVzGFWl+Bqp2VBleBdpZRBKdufRoAEKiacogjWvNP0kAOT7q1WrhlWRQ?=
 =?us-ascii?Q?2xlUTxk5f30JdV/aZiPu56LJ5CI8NTk7bzBW+EKg6/jYAdapayNn2/aJ+Dtq?=
 =?us-ascii?Q?lietCw39Dn1/o2n2OavRJkdqP4P6/dOcmGGe3g1vwyXkVrK2Le3qcgBIhwme?=
 =?us-ascii?Q?zawAlRuhzOrf/bKCHM9uBGtqFOxpbHUo2hWGUVjAjDzQ0Z73uarT+hiKiO42?=
 =?us-ascii?Q?o4J3rtI2k1Hd8/iGjeQuLctkesTbzQ+tFFzOp353B8RzNU5XG1QH+SQ7jV28?=
 =?us-ascii?Q?xNQtgl0BVfU48/B7ssEi2wc1dw8013CdsKTjdtMX4uXvsIGiV7YwRMIwxqE3?=
 =?us-ascii?Q?DCtPqSJPEficwzRyukXDqIK/qCq9iTEvng3zVucYLklbbg27FjYUDd1mZX1f?=
 =?us-ascii?Q?DjSijSSEuRGgHtFvwYZ3WYTZ/ZSAVYC6eqxAFr1CFu6QF0EB4LIAwE6QZOIJ?=
 =?us-ascii?Q?5Pw8IgIHpjc8qkf9MlcCopwV38mB8w2J7cYhARUd+V6cu0OKjCcSR1w2fMTW?=
 =?us-ascii?Q?1g1WGyjIjqBQ+9O7AqHoB8xwsovs8IorBQcm9LRP++ECODBhBBYAzt/5RhPj?=
 =?us-ascii?Q?0xF9jsziEJ0DJOWkUGcbAX3DjxP9o8j2NrCb2rtVtQxGxLxZelAisHIoSvve?=
 =?us-ascii?Q?m1gBSTRGlhvgVy0CIopFXjTMsyzV5BddBM4DT0rwWoYNMKqpCvIeb4ZEgArH?=
 =?us-ascii?Q?vqQ634upvH2NmUqTYROccOIfata8+WgjBbcCw8j162dGSjRnIWdqqoFsP0qc?=
 =?us-ascii?Q?qsazC8EfIKpbugd0dTQmmx58Ll9ANjz8lBtFDiQUORBjrJh3QS2jLrV4g5Qj?=
 =?us-ascii?Q?AGbYC5MLk/UvO0aX/YxQ13hMwFactkSVo1y5jIQs3NKkFkfUi9GoWC4k534h?=
 =?us-ascii?Q?gNL7jl1tOQdPXaSqdel5X9fDi9DUj3BIpzXqKgqPZYWbrVi7Y8mLl0Fl+Pw6?=
 =?us-ascii?Q?99yK8bZ7ryH6t3aWTIVt9+ER3xiLVOjCW27uzRyvYSlfG6gvTs0pOV1Jk2/y?=
 =?us-ascii?Q?0iTwv9KCsoyWYS4Q1Z/tujwctYFvyZ1mtr3CE49nf20/c5EXduqD3RTgnSeQ?=
 =?us-ascii?Q?zFESsWQ1og=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32db0a2-9dbf-4e74-48dd-08de9f18ebdb
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6486.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 20:10:51.9988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6pMApyMP3+hf8gl3k5ZVQQsk+q6aCW+fN5pz5yhqVFzEzTo0YD5ImQlzB4J7EHEuFQ0PN30JAEcbpe+r3oqO2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5642
X-Rspamd-Queue-Id: E6849100012
X-Rspamd-Server: rspam12
X-Stat-Signature: p37ufpjieyg541oti7yxfqaugcg3c7ij
X-Rspam-User: 
X-HE-Tag: 1776715858-109551
X-HE-Meta: U2FsdGVkX1/lQg23YW7ceU1wwVqzI9nP9K72iR336nSM6nf5S9iNc9oW0J6/uHwr891FRQ8uRMQwxBH+FMkbtjGGPzPHtLSzzzAgWtqVEbrBVaBJRAQbkT1qdLC1Cs9sCAhzcjArrNO2sChbFfq7PmUBFlmUIFJnNFIF/qe14GtF9kkXAvZJxklUGS/ndtUbETKJhqlDe8iTfPii5HeeTp+sFeSHkimJW6Hb8RdUA/fbgvCwL6XFuOpeLVtHqWak5+yea1Q29scsFf3lO1IyJavMvyXZqlU9vu0OdySTpXFoFaIAMhVbEw7jC52Jptr/FON42FEH6z+UlweoivdveiAsfmEQjYAwYgKAssFohLw4fdaSpx9YKc0oiinpRQdUhs0I9Gn3YMD+oYpyfZ1had8JJg9ymQtRrrP49jb3ibuxxd4yM7h74w0y5HgF7XZmchTUEsxmvp4Y200Wl+EPzoAK5q1m7a3alik3jQJiCoU7nRvvlC3+KiBlF6ujdy8RhdGP0YL0tHGdYquYqsxyfgnBC1rTaq/02hsddFh3p8Oo0gK5l0kaqjAC+nVIIyhTaidbQwF0cpyZ3iiBJnPqAhGbB3hQheb06rJ2qqYfR2lSFbKcXVsF3p4XxK+ETfI4cJbUERATWB8TieaJxURkMsonPJAXyrssKYmy4F/zOQih8I8j8YZQpt5fHR1vXSRXDSROqElPecYnWxwSSmAvJ0tH1UzppekglNefyfdrIND3/LfUXQJTExMENPB9wVrZgV0mJ7KbZlAqvXh3IFpqDYBuPhJ9rmbAR4s0NoefqD4h2mUZMQuCsTadB6NaJ4xUzW4MqaRjaG7XagigTvB8II8PATXRdEzy7GUwViBhMmYdHwXTPQlVjdHGcH2Me3VwqOOhw3kb/9ZwSV4/H3S+BB2o8/AIOX7KNmC2B+RJJn215yHccuAoNmhiToc2wtKrY627CXSQYE+bYi3NKpN
 pEg3/z9c
 jCIoEgof9vilu2PpnKI9+XPXHp6j0253lOxwDOt1JoIrqYXmvPDqps78QSdpnSEpbH4spV0cdykjGF6/PeGpOPPGOySk+HUBFj1Ly8qcZKOOepHhp8kqR6UNpEVRQhtCBRc0RRV41eEM9QOGR7NtJc02zORECYHyEP8rqPiS95CQpUmvg/9haMojBgecgzAvez/Nl2EgWtqVKNVIBa1oNmZP0QBbfi++BWJHEm+LBzNM6rMDnHgOhZdF00ciEg1aFI5QW+W8zqQ6IiziKkTb2MY/Tf8zmZEcHujJxWTgEplIK1/CtY8Xi8kHgDFPRK6PEM7JmlG+cyizTvc23QGqKb4Mjqr3Gy5SkweoFh24w15mUstVc6uH2Z8ZRS8aqzxJ+KNP0ol0bMqMM6T+zRkhwsbaQ9Q1U8vFtbdNhBZ2JfZLkgTKvXRovvqaiWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The C maple_tree struct contains a *mut c_void, which prevents Rust from
auto-deriving Send/Sync.

Following is an example error message when using MapleTree in nova-core's Vmm.

This propagates up causing NovaCore to fail the Send bound required by
pci::Driver:

  error[E0277]: `*mut c_void` cannot be sent between threads safely
      --> drivers/gpu/nova-core/driver.rs:77:22
       |
  77   | impl pci::Driver for NovaCore {
       |                      ^^^^^^^^ `*mut c_void` cannot be sent between threads safely
       |
       = help: within `MapleTreeAlloc<()>`, the trait `Send` is not implemented for `*mut c_void`
  note: required because it appears within the type `kernel::bindings::maple_tree`
  note: required because it appears within the type `Opaque<kernel::bindings::maple_tree>`
  note: required because it appears within the type `MapleTree<()>`
  note: required because it appears within the type `MapleTreeAlloc<()>`
       = note: required for `Box<MapleTreeAlloc<()>, Kmalloc>` to implement `Send`
  note: required because it appears within the type `core::pin::Pin<Box<MapleTreeAlloc<()>, Kmalloc>>`
  note: required because it appears within the type `Vmm`
  note: required because it appears within the type `BarUser`
  note: required because it appears within the type `Gpu`
  note: required because it appears within the type `NovaCore`
  note: required by a bound in `kernel::pci::Driver`
      --> rust/kernel/pci.rs:294:19

Implement Send and Sync for MapleTree to fix this.

Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
---
 rust/kernel/maple_tree.rs | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index 265d6396a78a1..1ecf05871e710 100644
--- a/rust/kernel/maple_tree.rs
+++ b/rust/kernel/maple_tree.rs
@@ -16,7 +16,7 @@
     alloc::Flags,
     error::to_result,
     prelude::*,
-    types::{ForeignOwnable, Opaque},
+    types::{ForeignOwnable, NotThreadSafe, Opaque},
 };
 
 /// A maple tree optimized for storing non-overlapping ranges.
@@ -240,7 +240,10 @@ pub fn lock(&self) -> MapleGuard<'_, T> {
         unsafe { bindings::spin_lock(self.ma_lock()) };
 
         // INVARIANT: We just took the spinlock.
-        MapleGuard(self)
+        MapleGuard {
+            tree: self,
+            _not_send: NotThreadSafe,
+        }
     }
 
     #[inline]
@@ -302,19 +305,31 @@ fn drop(mut self: Pin<&mut Self>) {
     }
 }
 
+// SAFETY: `MapleTree<T>` is `Send` iff `T` is `Send`.  All access to the tree
+// goes through the internal `ma_lock` spinlock or via `&mut MapleTree`.
+unsafe impl<T: ForeignOwnable + Send> Send for MapleTree<T> {}
+// SAFETY: All shared access through `&MapleTree` either acquires `ma_lock`.
+unsafe impl<T: ForeignOwnable + Send> Sync for MapleTree<T> {}
+
 /// A reference to a [`MapleTree`] that owns the inner lock.
 ///
 /// # Invariants
 ///
 /// This guard owns the inner spinlock.
 #[must_use = "if unused, the lock will be immediately unlocked"]
-pub struct MapleGuard<'tree, T: ForeignOwnable>(&'tree MapleTree<T>);
+pub struct MapleGuard<'tree, T: ForeignOwnable> {
+    tree: &'tree MapleTree<T>,
+    // A held spinlock must be released on the same CPU that acquired it.
+    // Prevent `MapleGuard` from auto-deriving `Send` because `&MapleTree<T>`
+    // is `Send` due to `MapleTree<T>` being `Sync`.
+    _not_send: NotThreadSafe,
+}
 
 impl<'tree, T: ForeignOwnable> Drop for MapleGuard<'tree, T> {
     #[inline]
     fn drop(&mut self) {
         // SAFETY: By the type invariants, we hold this spinlock.
-        unsafe { bindings::spin_unlock(self.0.ma_lock()) };
+        unsafe { bindings::spin_unlock(self.tree.ma_lock()) };
     }
 }
 
@@ -323,7 +338,7 @@ impl<'tree, T: ForeignOwnable> MapleGuard<'tree, T> {
     pub fn ma_state(&mut self, first: usize, end: usize) -> MaState<'_, T> {
         // SAFETY: The `MaState` borrows this `MapleGuard`, so it can also borrow the `MapleGuard`s
         // read/write permissions to the maple tree.
-        unsafe { MaState::new_raw(self.0, first, end) }
+        unsafe { MaState::new_raw(self.tree, first, end) }
     }
 
     /// Load the value at the given index.
@@ -375,7 +390,7 @@ pub fn ma_state(&mut self, first: usize, end: usize) -> MaState<'_, T> {
     #[inline]
     pub fn load(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
         // SAFETY: `self.tree` contains a valid maple tree.
-        let ret = unsafe { bindings::mtree_load(self.0.tree.get(), index) };
+        let ret = unsafe { bindings::mtree_load(self.tree.tree.get(), index) };
         if ret.is_null() {
             return None;
         }
-- 
2.34.1


