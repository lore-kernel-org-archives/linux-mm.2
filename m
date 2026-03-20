Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FCF91098787
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0379D6B0142; Fri, 20 Mar 2026 10:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F316A6B0143; Fri, 20 Mar 2026 10:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40236B0144; Fri, 20 Mar 2026 10:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6DFB6B0142
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:10:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64753B6FDB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:10:58 +0000 (UTC)
X-FDA: 84566627796.06.F7467A2
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012067.outbound.protection.outlook.com [40.107.200.67])
	by imf05.hostedemail.com (Postfix) with ESMTP id 93B42100012
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:10:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=l3m8yt99;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774015855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ti8XBouzRe/C3irBBNqwZWGPOp+UdPPnFTWwLPTHyeI=;
	b=Ra+mg2A5op49uMr12rqL/ZNrWShOYsYMaj7/CrE5QC+3LlJNZskFrEK39NOCehbxTtd6hV
	3k77nrLv5ogZalnnhWKYWsolZbQV941ZT047h6fKI2RiMgcsScIiHH1qjDR/4voLtOwbGl
	uQScKqiB9V95X5f89gqkfICUqK3nkUg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=l3m8yt99;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774015855; a=rsa-sha256;
	cv=pass;
	b=EKF/TXHeYyMlhxna2e8tqLRwmJhSZX4vlIQSj1YhXveukikaabkovJjiZqN5XKkLqqxOXQ
	CEBWNkSrF8w33yoecO8y9bUabGyJK1UFPUZfRli3qPdZUkiGhHDSeDFN/MPSHSjq3uH6cP
	z42FZHbs0Huv5R79VK/5fqfmOP4Pvy8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W5/GbKVQorpNC4GD2KMUKXfNnc+XS8iy/M1AK7CAW1SngjIZAVj7AtZPl1pFlYtlIaWBppMmrqri+7bNgrGjuGdKkXCEyzsms2Kx/L3dgAUWrfFNew3wrY+btYuVWnTcrRTc0esBuCnF1sASkoPrvBTX3H7vpFEO/q0S1hDbXYYhVZXLZCL/DRtM00ufDH0IzXFdTzSiS+yH8J+qZ47e7RGmibcYxdSRBrM7MyimfQo4yr04wOX2joPTKOLG0pOI0Nep4aK+xJWK9uPZisx8vR26qzSsySoAwokfrs7jh1I7Z75UeoMaJBNPCeVcFu/GTkmQ84OzLGj9dfIOj7UTiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ti8XBouzRe/C3irBBNqwZWGPOp+UdPPnFTWwLPTHyeI=;
 b=FC4SgznBuCVKC0hgPFZPCtH4V0UbdJZ+LwF29ODDKn1KokOBMiXhZVFVNMSaXGlJHAOTXCDhGyS1Aq+quYe5RHTY6IyK8dD/ZhqcreMb6K6NO+7GBduRN1wc3jWGhfVn8rJGSfa8VRQpsnptut5YCZJhr0EkM6Ty7nZW6SLQprgPTUS8Pv3g50xyZhsBwV6Il3JoJ/qoTAxY6jkekMhQlDaitPZsKzySpru2xusaMMV+Zwovmbmw7zhJOc5j4oKYh2NH+LNM8QPql5j+UILt4oBWOmFTdqBLVvIA86eXjPfhMgdiSW7PKmDqEpl82zPmcM3v314W1U7J1PuHhcLvrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ti8XBouzRe/C3irBBNqwZWGPOp+UdPPnFTWwLPTHyeI=;
 b=l3m8yt99eSbyu4O+h3r1zZ6++IjvdpsL8pptH6At/SnlBKfbDSXku1cKgiN8O3v20w1fDJdW+ljJZeGV6zy8ZTQB+2sEViIoXVKUb4k4A/R40ibxZM24pCSa2W8zr3+GnRveCOvF0obgESAkJJ+lN+4nPmoY/u1NAHhoR39Ypv2Cg/CDpn1eJoOkp8imJQXpJDwPVpGxZAlpwKNzW1RSVoEDza6yaiezH+accMmKDlwZGXVi/3xk4TNN6PX310buJ3n2Vb6D5MED9OQkVvoucllOoAsQ1O7YUbDv6qxvInsBhabJ0N7euTNqzYjMFh8gprBI7RFvvfpWgDPkjPFhqw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA0PR12MB4494.namprd12.prod.outlook.com (2603:10b6:806:94::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.9; Fri, 20 Mar 2026 14:10:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Fri, 20 Mar 2026
 14:10:51 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/mm: add folio_split() and
 filemap_get_entry() race test
Date: Fri, 20 Mar 2026 10:10:44 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <8B720FB8-DE4D-487A-9AEF-AC204E9F5755@nvidia.com>
In-Reply-To: <20260319194118.3eb42ee3c507fd0ce2cd66bd@linux-foundation.org>
References: <20260319190409.294523-1-ziy@nvidia.com>
 <20260319194118.3eb42ee3c507fd0ce2cd66bd@linux-foundation.org>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0007.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA0PR12MB4494:EE_
X-MS-Office365-Filtering-Correlation-Id: 834158a2-1051-4641-de94-08de868a7e17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|83080400003|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cRExSmgCnb+8m9ob77kU6c4+5YfPVPznhfu2GXN5vSG05wByVUEQ0qrIwtyR7B9vnL7/Z9/h+jEApZKJlMn//b1C3gQS6q4DhO9Ll1vnkdS/TqOA++UmJoZ/IjK/grZVsTOVUXSGZRICw4p2sngjI056FdP0HUEToDkIVnGVsBP6+Q6jQDEjzY1c+6Sbli1aigyk4oWS9SdZgh5fOs5gCTguWLTBIy/5d2oPndLg/M8BWNlS/5JyzCnTiWjd8b5Wav1wBF/eP5GEFykTYEuUhyOGKrAyXaLh7Rw1XE8y5XE/2YDYo/G1+ha2FwOREBhR9iXT+bRHzrqb+3evfMjRRSjETXRFb1OxgiDW+I7Ie2Rb62mu4/Ly3UD064RmW5Ii8Iyw4cei22C5MhlrUCQ76pohzbPemsv5a9zLKj7wbOX0vC3I26SCNb1v9Y+l4cOooXPk396DR0vqZgPw1heey0WTZnEXrXf2hXbKBUB9AejCk5JbqHKN936fIK2SroV6RCxkcm1e32/LkmOZjnTR4T4KzkMkGpHT4slXrpDSQt8xRvfScf7hc4fnaT0UVk+tYNIsBRBwTC9vKrsMRGS5IlildrlX2tOd+a4xUCHHgndQmAYcm0rypmf8zdvjQGv8mq8MLyXaGlyuXdaE/0YqzmDw8QbJE3b1cDH3fOE+bKF3KCaFavzftYVufAlShKjHji9CBliY0CQEqp8ziXCqArwvB6KDv7usv0gYaw6MdEFHm+7gRQ0XZN6m4z4fukqxJTatkvw1MWQnrWeiu1VUHtN7kJI4bKd71CxT6ZgNS5s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(83080400003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4m20GYpaWlDnZaVzbyVz3yA5oxf7HbrffTW3vtl0ExXb/aHVRZy3Ztvk+m2O?=
 =?us-ascii?Q?bQ5v9ZFukYjopi7aFeRQ77Kwg8VG7nIPl0gBDfTarJ8liwNtePYhgPfmq9fq?=
 =?us-ascii?Q?2z7TU7a/475nrtoo4NtVddrp0bDYnDoOyci6KynmzTt2kXgyg7DEj6L6Zyla?=
 =?us-ascii?Q?8BQ32SHMmo5Tuq5oW3sl7mjwY7D8V0MN8MsEyCij2KddZId5RWcTn91g+6Zs?=
 =?us-ascii?Q?dvfQ0xv8OepRuDY5+pTj9QRGxPGUUg3xSNBZXurN1qVREAT1npEVfJVxyDl6?=
 =?us-ascii?Q?tnswRE1VoH3YmZjBnqHqpxpL6z0zER9QvJCoj0/u8et7KDNCLGoFGWfcXqpU?=
 =?us-ascii?Q?dmkQlc6F8whZmr4wXv+fXEpPNJoh5QYMJMdL8xqG6OLqRUFRyKDZ4kcac6u7?=
 =?us-ascii?Q?ddHCUET+RV29fYKbQtdZCgfKB+VLbuf7R3r7zaC8J7bqrIMBVj2TVQiDJG52?=
 =?us-ascii?Q?oMeRYihq+o5PHuOZZTk/nqkDLQ1rCYb1e8pXGtP63gGP2yH/oewKD0dUeeRv?=
 =?us-ascii?Q?nmMFaqjDVKqsuxfUlRVRF9chcjTVAtiC4gTnyV8a0CNE8ruzk7JN3n0LPyUv?=
 =?us-ascii?Q?MALAWGam8xt4JIWfElLYGolpqqT0uRn+/Dv8RT8bd9OMMver9tKMVo86ovT/?=
 =?us-ascii?Q?0YvuurD8ovngIsyV3YB2JEyP/GAMf+Dwz74Qfjj18F9GuKwvtRyLFnLAiBAg?=
 =?us-ascii?Q?FJ1pzIadb3lRIb8DTxG+z09fVACH/MjuYHBH7qivzaEdRxmoMYjp8KaddMiu?=
 =?us-ascii?Q?hPxkB2SC9fIxKHnfK7bC+sEME0KGW66w8C0S1j/8w/d+ScKEiSd0LV9/3Rtg?=
 =?us-ascii?Q?jOQyPwaCXs5mstwAYZTNr+Fpg/qmkANT7An1DfxzWvjgdJr+Lm9NgcrvvLn3?=
 =?us-ascii?Q?wUSGtA+YZw/H14rqOMv0GSXR5xgEgsK5MyAwpuxms8ySpPp+hoMWg3XzsHiz?=
 =?us-ascii?Q?5Z2/IuCWoXlZk1NVjTTTG1Fr0VH8KSgeZJD0lLz/5ES5ERo/ADK8S23YxZDV?=
 =?us-ascii?Q?ng+65H7fvhKpgSMgGLcnQvl6/VM7xZ8c3zi3uunEivJhjSdyrmYG/jyvqUfx?=
 =?us-ascii?Q?VYFENhp15SH2pAu+0OUqRVsnr50HCdWzh4Pv+wY7XErT0vNfP4N5KiaivY+A?=
 =?us-ascii?Q?dqKYYpinOKcbQwbTR1/IF4uU8uRdztCQT98DTm5EvNuYFdSl6RPIE2i9HsBN?=
 =?us-ascii?Q?AZVARkFIRKhhanNJjp52Ugl5AXqAFJeuxidk0StZeH4u0FN3w/ZpPN2MyYMU?=
 =?us-ascii?Q?T2NFM2ApC42d2J/dIF36ShymQAHq/Yx6nhpXFDPxOPVp/0NgMeAKA6ZkVEgN?=
 =?us-ascii?Q?OrXdvwVAGcYxyVS2Fxx0l83A/21z4VSGdBO194sidnhXxVMKheR+9v2FniJA?=
 =?us-ascii?Q?EuF9oJoBOYe4IhNJECH4ZHn6aEYNgh+8tmDHomL42TNcGkpZIYxBCcKW2/9P?=
 =?us-ascii?Q?UyYcjCoBGAn4Vx7Bfuqnq6SzH+Y1kakgZC/P+lwOFOd+956RdZmjEnQTdmqo?=
 =?us-ascii?Q?3JOP1ZedhK3WuEidrn+a+TXisSn5ILzzMkAqOL63n4rhR8NK97l68SfpiVZW?=
 =?us-ascii?Q?jX833bzzKO7jUIYHyaiQt5Y44CFkAyFUdXlT+RT5oletvTkJ6/+CoGKb75Pw?=
 =?us-ascii?Q?JD30Gy1sxYvQMZo4RwvJbs2VcK9tOlb89bcZHy1RwGRByTgnuksiB72lZZmz?=
 =?us-ascii?Q?l7Ykz2AqaG//natF8X9nW7EGtA7B4dCFFtZplf0cs0eyXvUlE9mcmjS0Z7hp?=
 =?us-ascii?Q?eCGloCWdVg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 834158a2-1051-4641-de94-08de868a7e17
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 14:10:51.3718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vct7KF2hqvCnOi8ULc7nbkIEhAvnEDwlxnZ0hLzBKECVJmzgdQbezd1AwQZlIlwK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4494
X-Rspam-User: 
X-Rspamd-Queue-Id: 93B42100012
X-Rspamd-Server: rspam08
X-Stat-Signature: arj9494kpejmshsjxaghqfhxzj65gfsc
X-HE-Tag: 1774015855-583466
X-HE-Meta: U2FsdGVkX180IvuaPsIMK/7OF2yQagEz4/MD4e2RsmB6uOZt0eaq+kNiYsfnBtP8gUfZX195wusat0gP627KSgmFXtLYf8feWSqK+gf34BrNfnLdEUhiDpPN/mzEFmq+fYNwIvWX4+aAs/QLO7CSy/U/8nGrf4Le5ffrx/+0p1VbovrDRLzk75Nin6hLnNagvBraQB1xiQI1hHrCfGFaIC55txwrheCFY65oteiKbIW30YENdwEvpbgeZXeriYWJUWeih4zsLpGPE1tDPCA3UIhNwxj0B6b/DQ3z6SGNZbfX7uY0ICzl25phU4B61e7IWu4XYJxJ0KMi/mXwZPu5CxpsNj5BCd7oI/zhdu1P50XXKhl7lnHBAeiy6dWd9DOr5OjGCZpraCGiEsK8+M8P3gYyWTi4AyxZAyCdpUWWqECq82sA8fMiCGBF2lsFC2sF6DqvESWopxaSRFmjBhBxmCsf9LyRjscpy8x0aU//8lyHA4ufKlnPYz2clOHkwsHYZp/omx6jHIhfsn9V/vDV/Jpna7Kop2Tev0uThop0Y7ag0ctobyZSyvDGcCY64lqqDhszDz3l+t2pNZJF+6kfh+WMNFhKeVnjP7Eyjv2SilZMMu01VF4DuqAv4GBmD8Lf70ImP9nHatAe2D/A/amGN35aaQn4sjcLGFilBuU2J1bI2wGbn7u0HVU782yw/9uYO4pKgIZgpf0DfbRzS2tox1yR0LbtYxrJYd3FpbBQSGRMJ6PwP2QR7trm8ruJgaQ+Y8nddnPmrV8BeX9QFzla8TpJwSFxfGUTFIYH8NW80Jhz5ZjEJg2+2obxpVbgshtfkZ359Bo1vA/FSzOVenqzLrPmrUPUTeCo4fJHVvpNpc8NQ9HQAZ2CCCu81QYPTar/uYjm6OUsTlAlUTLACANNkF0i20Q7MBdoTFs6bx+lSd6KUDDU8fdzl/hcivOIvCWOAHg2Ky0yKr32gUmphSM
 mIUKzCHY
 jRF3OX9tSW3639YnAh/aJoqf4t6QQz/XWSkYVCZW/pWg6vPdsKbLS1UBgcB3SJWSafMYh9EHaVK7n4lp8abZQnDqXsaaU1nBGC/ZQ6sbPYeyVKUyKX25jZlkGh5/mPRWhPKHcnZ8/R7+1TNYdGNRsMHQ22bgdXDwlOrM0z0W1mTf/DW3kn9IYUm9+PVVY9VzqkgNJyPCQIr5SjpIGQvHCwP6i3Xse9aXjQg/k1Oif+oUO+oggBL+irsnO9/LV1PEjMnuUZaQadERdjob0NIPdH8IW82Uc7Wj5P86w6H3TAEpz8necSw4cBx9K/ODmq2oLUavIXxSY0tMvUS/YH989VRHgm2TOwugByqvHLGkaUtwnrRDMZR28XW+gmgxsDq8nvLFuZz8mthQsmUKabmYGDtpCnV6gMJfi5iKbFxhevctt4Zjy2aGpwqVCYtTiVvld/9+GrBn9kiTlT4g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Mar 2026, at 22:41, Andrew Morton wrote:

> On Thu, 19 Mar 2026 15:04:08 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
>> The added folio_split_race_test is a modified C port of the race condition
>> test from [1]. The test creates shmem huge pages, where the main thread
>> punches holes in the shmem to cause folio_split() in the kernel and
>> a set of 16 threads reads the shmem to cause filemap_get_entry() in the
>> kernel. filemap_get_entry() reads the folio and xarray split by
>> folio_split() locklessly. The original test[2] is written in rust and uses
>> memfd (shmem backed). This C port uses shmem directly and use a single
>> process.
>>
>> Note: the initial rust to C conversion is done by Cursor.
>
> Sashiko has questions:
> 	https://sashiko.dev/#/patchset/20260319190409.294523-1-ziy%40nvidia.com
>
> (this is getting painful :(.  I hope they're worthwhile)

Q1: Does this test actually trigger filemap_get_entry() in the kernel?

Yes, when MADV_REMOVE triggers folio_split(), in remap_page(), after-split
folios are not mapped. So subsequent accesses to these folios will trigger
page fault and filemap_get_entry().

Q2: Does this loop advance the index further than intended?

Will fix it.

Q3: Is it safe to call thp_restore_settings() from a signal handler?

There is a theoretical hazard but it is unlikely to happen in practice,
since it would only occur when thp_restore_settings() errors out to
use printf().

Q4: Use %zu for uint64_t.

Will use %" PRIu64 " instead.

Best Regards,
Yan, Zi

