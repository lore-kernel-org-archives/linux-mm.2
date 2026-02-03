Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA5A7E7FDE0
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 00:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA6F6B0089; Mon,  2 Feb 2026 19:07:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CB526B008A; Mon,  2 Feb 2026 19:07:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3A06B008C; Mon,  2 Feb 2026 19:07:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 087C16B0089
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:07:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C99013A7B4
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 00:07:33 +0000 (UTC)
X-FDA: 84401206386.28.AB67308
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012030.outbound.protection.outlook.com [52.101.43.30])
	by imf28.hostedemail.com (Postfix) with ESMTP id B6E9BC0004
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 00:07:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=B3BLgYaO;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770077250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zeh8f06BhBRULjUMHVoYkglxzXE+VYfbmAKmI8LiHps=;
	b=RAgjoQp4RZIykcVviAOgd/TU1jv/v+Rps5UWrT5LUzLcNdxRES/xTjQ/7BvE2jvCPiaCxF
	mh09bWeybq8MpnolfpSLeGCTrsIMUHl8GRp38GSUFj+O91id4Z0tcognrfrYTMLkUUV7Kr
	b7hB8u0Icpkk+13ymGESNRKlT/LnUT8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=B3BLgYaO;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770077250; a=rsa-sha256;
	cv=pass;
	b=Izo/MnUQaiRqIQkn6NofVFteIVEUWcqk0DCCFWWuJtdzS3U4f7B9oyJ3TZFzdjaQV0LZsV
	Zbi2ckWgMsFM4phB1tZv7GYx5e+N8pGXME+qzXrG8yRczDc/EWNW6poN7Z5lpgihJoWii2
	uhhYJCQp0tcHpw6Z26WHx7oQaikaKGw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E5ZLiAO4Ih+oBSWaO0Fp/J0Cwcztb9rTbNNkxAOsq1xPQOMl0D97+52OmXCGPJB+xWju5htLYo4c0DxD2JRrEUrsX+NIGIepC1rmh//J1/+jQqcXvgVdXjz7Go6F8SxnS1QqKKKx/j44MCP6Rwsie7VqWbQbo7KSRph06jykJiXZJ/wXC1wRlUoK3sW7sJgsQeQDZoSdOhAJbiv7Dt0OXgR7Z6uQHhKi1KRJLd5SU+tT2AUXrlc+7XUW7nQPgCa7BiENLKVBRzVwf5Iuk7RIxxHothcj1ZJFQ0AxQsDOk4Nyjtb/MMoHRpdipDzjNLZVo1NRaa9KeCM0eplvgfa0YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zeh8f06BhBRULjUMHVoYkglxzXE+VYfbmAKmI8LiHps=;
 b=KLQXtRcle6ail6sss0CAJZNge7E+JMlvUJGxGykrdFMP/qWOZeVRD6g63IIkJ10wnT7y4ZDWdgikgERmo09JmRdz34tOvI5BU+7c+mIjZ8AqoKxjvlR3Vt3cAPP9/sStUMzAo6syT71zFYvLpTep9RKryNJuztpE42iLH0/w8a+Sg0DbxJ9JYTjVVpHwyvGDxBzbrpmcD972P+OGSJlRvNURdXcoxHEWclKV/oRJspL3RJdoJt18WRb5hjjb18WBRGr/f5s53/k5/ZNXgUv7U5gqVYIMF6DMDa4ILdEisj5drlj4BuDSvjH7J/OIDZlR9DedRHOiddl1zfFIyrPLGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeh8f06BhBRULjUMHVoYkglxzXE+VYfbmAKmI8LiHps=;
 b=B3BLgYaOavtRDfNN3yeJaO7QkKxrB+36KfnGtM45jR+CeBb8jGRLQkNaxP1gCMLxAcA5c97oo74+c0Y7oemUGhG4XIcRJT33pldK9i9w/pxcWrK7aAkBp2EflOX0/qKVHs+y+N0vl9YSgla0uLgbyN592VnfB90zny/o+OBw4CEfnavsqOMiKrk3buUGas5QjLbMEyg3dLH1/DSCRTsyVF3HzvfhJN+PjgfBoQPxlPDa3eHSsaZZtmArNClj7qVMi+xd1XOWIThBFIS9I5q5cXx7Ue/WFaoKf1OnxXX7KvK1hWUWLjhA7/BoHWzzu6VrnuJeU0q1oCNaryh40UF62g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB6189.namprd12.prod.outlook.com (2603:10b6:8:9a::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Tue, 3 Feb 2026 00:07:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 00:07:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Gavin Guo <gavinguo@igalia.com>, david@kernel.org,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
 stable@vger.kernel.org, Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] mm/huge_memory: fix early failure try_to_migrate() when
 split huge pmd for shared thp
Date: Mon, 02 Feb 2026 19:07:12 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <EF19148C-5365-4D00-AF21-B0D71E799740@nvidia.com>
In-Reply-To: <20260203000035.opgq74myrja54zir@master>
References: <20260130230058.11471-1-richard.weiyang@gmail.com>
 <178ADAB8-50AB-452F-B25F-6E145DEAA44C@nvidia.com>
 <20260201020950.p6aygkkiy4hxbi5r@master>
 <C620202F-685A-4B9E-B51B-078EBE5BF0C4@nvidia.com>
 <08f0f26b-8a53-4903-a9dc-16f571b5cfee@igalia.com>
 <4D8CC775-A86C-4D80-ADB3-6F5CD0FF9330@nvidia.com>
 <20260203000035.opgq74myrja54zir@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0028.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB6189:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f75666c-3885-4547-d674-08de62b8327f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VBJUVZUqOuyUsazWkLhAsNyBirRFoIlpNS3Qc1FhohnamKqNApAdCSES4MEu?=
 =?us-ascii?Q?WtUd8x/KKMCBrRHvkwkP5ax8B8WnaYtTikC8ZlIntMpe+OIIGD1Qy96s7Q0P?=
 =?us-ascii?Q?4+DGkO3dY61mXPwKmAVlR0oO4itwVBND+H3n+VFFWqprMthnit7bax6PX5b0?=
 =?us-ascii?Q?OAFh/If1zdvjdgMSq3vFjsp/4Z9cA3IzRlTYENJUU9hSrQYjJRo/EyS9/rBO?=
 =?us-ascii?Q?krpCvzdxjlcLz3oF0WKUhgAvNBAtjTOug5BWnUvzr7PFesX/kkHivdHHxVR7?=
 =?us-ascii?Q?qKFHKsANf/6KlEhNlUniKWygbZnrJfTGOFTwe3ZRaMXjCvYZODsIA74bOXU4?=
 =?us-ascii?Q?3sBnpsbEFYFrYjwRUGYQgw36F2CXHgQJinswnMhkn9kI2CFUCZKi2ejrHCYY?=
 =?us-ascii?Q?TanSghJoOBoFGc46YyC0389K7mtLytrS/ktYBVygWh02j5tP2hlRDG52x/hr?=
 =?us-ascii?Q?CU3dkMhZh3Zy8EgfS6gbQ9fuN3iqxaiYL2zzOPWoq6laqpbjg8gwgIC0XFgH?=
 =?us-ascii?Q?Wz525SLoL88mJww9hzWIN0n4JPf6ihJUMo3H4qk02HWiHrh4QcMnPbwE6UdT?=
 =?us-ascii?Q?BDQqGT87Ujuvo7FNOm2ENkZ5+9IsfewElXrAWMGtAsbjJWk111hraQbRxbGi?=
 =?us-ascii?Q?9WXaqqnWqlmo5uR544ZKXsgpDMl/gsUOVgOaa5UTZ+v1ZuN1TlXx4+924l/8?=
 =?us-ascii?Q?XRQywQJ4fCgnuiNXDo7uQJJCmKsVQAavMejbpBoPf+olZW7JEERnDPpOb+C5?=
 =?us-ascii?Q?MHrs/7JUfIooj91egWLHdZr8wBGXB3Q29blG4HeCJOtFVGec7HekbYTlNGUm?=
 =?us-ascii?Q?6N6LQQFS75fYGZGwr7+hmQWauuACIrLO0r9a9RN37+363Ew2nPyQOKmIYRbG?=
 =?us-ascii?Q?n5a9DDN6O6+i6vRY1nPKIlfkQYS+oVcDAcXgqzxdcZWXJ38UBvbiiTdwpWt4?=
 =?us-ascii?Q?6yWhC/c0rMybQ7xaynKc8lk64nxZios1HL+TwWdZrDdd5dFqZ7aaObtr10wv?=
 =?us-ascii?Q?9w4+TDtyCv+1MpyZm8+czfDaBB73ykJqU5gt55NtkfzkyA8EEBADRndXOwNs?=
 =?us-ascii?Q?g9sQEB9MmwhUaHDXFlllM6uSS/uHZG+LWN6xd4ZaIv6W9FZxs8+U7bsJbe8w?=
 =?us-ascii?Q?KxE2HnWxjMXYyWeUwchWKloXj6hSMZRqdkVtFDZz2DV3tv/MitszNRboSc/x?=
 =?us-ascii?Q?YWiIUSDCHwIPIAKZkFW9Xm5hcTykGXH47lPHvUMoSwR9GHw6BMRCzzMGKeqJ?=
 =?us-ascii?Q?4JitTHpIP9mt1RhkPATNiYnWfHuBZsBlhPPMgoV+Sop0iZNYns1On5VVzpiG?=
 =?us-ascii?Q?Q53lESs8PwIrB/mJXYHQDI8yi1+CuFfl03OXTTQ6Ur+ARzAZXuDLXQ3fAl1H?=
 =?us-ascii?Q?2PtkRLH0CB0BiTvWd1yaAUTKAfRBwDwCsSwsGBrCEtD4bz0hlKQ02NJ30oBn?=
 =?us-ascii?Q?qwHyFAeRettIGXBARCyzUcuFgZ/0uoyT/Zst7TXGyEnXaVaOrNwJSPutXk5h?=
 =?us-ascii?Q?cGRFnmVsxHvfHSJoH/F1qUjx35ro360R9OT1iohBFdKHxSAo1qL51zaa1p7B?=
 =?us-ascii?Q?Xq0wYiA0OVp5Iwjuip0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U90cIaf1qcM0l1JXcFaZ0MtAwBf2YRLija5zcGrqueYag3W/ynq97LJLonCC?=
 =?us-ascii?Q?ayZYSyrs4jbxSjzvDTe7FJwtqhupxUYQC2aop2bpsvyTJBwdIbirdK7Ye7jF?=
 =?us-ascii?Q?8LvVMkYa2ZEU9aQ8+qbW3eEL8EBzHjrcO+9hh9nEXAPChmj0q51es98LTNBd?=
 =?us-ascii?Q?sN2Du6KmhhD9LTcqpsqN2If+9EJHq13CX65N+oeFd8CB3aNJkactT1Dqr+G6?=
 =?us-ascii?Q?PJRyUlzh5+5K6W44Ht4Y8sjq38ttSzFIg8ZJ65tlrfWjFDxHggygLJY+7Jgt?=
 =?us-ascii?Q?11vKyybvjSLmMMKYKBRKsFJiSACenQGgXn9s1YNbGH4+s9q2vgO9qlfBkuGq?=
 =?us-ascii?Q?UvhJAok6HhLrDAwi4NppqgUJvHrumraaynhrJS7IIK5tzm6sKDYaVDRZrv28?=
 =?us-ascii?Q?OJA2Phhjj/oxDRcq4FBnd++tVsbdMyQMgyNENZ4pVvUEx5SEKBasf3HzdGmy?=
 =?us-ascii?Q?whcDmKX3SflNQzTyk9ito1JL+BjwhLaFbVfOrnfgvxeDwS19lL/spdwdGVGi?=
 =?us-ascii?Q?eECweAfV2Mk82xwPHuZEoWgMQ8BfGnnqUFfy5xlki2MjWw9LauU6Hkxzh8kT?=
 =?us-ascii?Q?vYzEaaRR/rkYIrTlVOQPXWNzhU3sDjhUqMy2FggwhA7nZvAv3RvK7DKf0QUC?=
 =?us-ascii?Q?7HBPzztWg5KMaCq/mjAbnM/CiyASbClSEPQBzI9VwiC7qc9l5+EixloejqI+?=
 =?us-ascii?Q?WZ25dZeeQ9zsgrtgdW5fS5SNjnGVfYakyYIB6uRdfczIDVmToml4ObsTJ0+v?=
 =?us-ascii?Q?60ymdex1dq7BNs8OPBp5vTMua6+zizrNrUwLDicL7I1hAJqKPQdJKKpkfl1H?=
 =?us-ascii?Q?Xrqe/57PDdktH420QSdFSohV/luA+usXQY3f0y3r9LkGgolNRhc78e1ZOqPn?=
 =?us-ascii?Q?xPluAKeB2R0TIGlGG3FT3/PpHAk3Q722pJ0s7jqCVH5swRMtcfsStly4VVlQ?=
 =?us-ascii?Q?PTlgo/D1E2cLJzuRrLbiHgvsL6OrpoVZf//Gsut5e4ZnWTvETexIhNaw8Ww7?=
 =?us-ascii?Q?fLviL80dgZgEKZgrXvPKaR7+wS9VnFDoRMd3EL4i4D70AXo2LtqFbF4eJnKf?=
 =?us-ascii?Q?c2W9EV91JTKHZGXMbYmfuoqqiQ2w+OahJq6mEyzxRPXEuwIZmfsw3CmEHhNf?=
 =?us-ascii?Q?p4OWB8THClsHvL2JlouccuXg/v+sKQry6CJCmIipVSKjNc8YSTYI2t6Q3sNZ?=
 =?us-ascii?Q?+NcG6ZppN9CngCZqRyX2GWR2MPBVQOpkx5DgETa6fHSzIxwhjgw2USEIb+1U?=
 =?us-ascii?Q?KzaUnUNrsu9wd1V98G0Rzn8tjDelhVAH7vFxneVovCZMzoO6xRNPPR6y0hWq?=
 =?us-ascii?Q?0dqrPp7XLGfdAalNVIs44meY2UxbZsj2j+DjgaJ5mRDjR2IUb/GYpG5ffGeN?=
 =?us-ascii?Q?F6R4vOAqoLX1laP65cx5Lm3LnzQ8Zx3pqMhHdGkEKUjZlUkUMpLhxTG7BLSW?=
 =?us-ascii?Q?/gXTYvXdfBLq2ko1vKwcfabEpJajilvxQ0yWsGgIHt9mI9N5nbDnHprcyC9W?=
 =?us-ascii?Q?OXGazDigr9MeN4RxDSRC3LD8g6YrUBJfd+j3y8Ohpk2Gv4XBVyY9d90hpHi2?=
 =?us-ascii?Q?FdpcUN8qWVuVhWdUKFKVm/QnpqYVz0nIQb450QMqBwsQ2XYQzSRfPRakoMdW?=
 =?us-ascii?Q?8h63oqsDKn3I7QrF4VG9TmOLEqJgeQKbMSLXKmfbLWmRQgW1b53KJOdqJJTC?=
 =?us-ascii?Q?flAjPX29pYFrdsmU2VC6ZkdHe853AKwF6Ltf+pf8gb9sxZ5o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f75666c-3885-4547-d674-08de62b8327f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 00:07:19.5068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Gg9iCEJlUXEBSk48ubCG+WX+NTYkMwMzGWUqWBEFMSWjx9kylfmd6kwiKtSf0el
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6189
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B6E9BC0004
X-Stat-Signature: 8btk4fojfb9rkm1qyjhdk3r6oy1jyrep
X-Rspam-User: 
X-HE-Tag: 1770077250-109880
X-HE-Meta: U2FsdGVkX1//4H3XomUdqn+6QxT0WgYE1+GVeLSTQkY2DNlHAmXxmphpTcYiBPbxBQoEBs7SC4JAa91JjmweBWOQtKgNJdvfjEkNqyODVVIgN/5hSKexd4PrZoyeREjGWdJWSqZr7Hrvq8b99CpJlvTsDn8jVe1leRREJr+3O4uxfCI55jI/RpALwVtoMO8SeGGLFhpMtbg77fJMyoKjzLumzwFBF/4iINtEuF+TXAQdWb+bF7k6/XQJMl04zEcxBaNNQsDhBc4SDjUQ25sxMUNttWD2bo72ADXcFKiwBUdzWZdRHTvSy87CDEXQLhScSubItqgN9g8wp/wWUnQl6a3+km5fkgI3wf1C9nNCtJGE4zgMUnuUQtVAgxL+fQqyNC1i2bdl4X1ejHkQlLHQH7VbjAl/CnuXIvqdeAMvJP7QWz6+g/v9B1q+T4lRpBqY18xUnCIuMURfckH91DL2wAvvShFU9hUIFxuSSXkgjCAW+JHsPjfDXJiWKlXfUsV+TZQv0hMt7liGHBJrAbQARNm4unt32i92HY4i8tdKlGfnKLP34hJ48R5OOHfoKm3VeFQyvrf0+K2prhM12kofM5orMo5C5n/+eTc0jm+TzZcJ3laZ5pYJu6u8iIk+Gn6bjakZwrcrUOQmU7hT5GxFwPILLdBrBo9PJiH1ZYl7ZRlqhERfLWcvYtcqEkdJByFYnPAygdJM9AHaeU3IP01uKlJ9IINIrEfJqm4QZYuJQ6avj5bLOzlIr91dFpqDZTTWCPrKJu/AgnmqS+TJ03rjvs+edmIZ2niR4N0mYyqJaPTWDh06ndIdKTSZvfRVOGPBDVK8yinf1hirfke21ZiQx4tRORvEs8lLFAjyQqU9A5KrMaeZUdCKq+H00GDkaelsV1J8+0j/XPJ4PaZh/6jBUkpdTdDNF8wTcm4IFAz9mLrWXqTRDnX2lAxtJiywbglIGnWXxDMIrYsTF+bmWwI
 2JWkBfZh
 tGXZXakcVHj1qNucpQeZK7CBXeomgElRjIw/tkrBDx9WW87+Dkhqj/+byWSv5FA2VQXwE8m6DgM+z2kQqH5OxYIiamgGe3R0wo0XBJNxZZZg1d8pqw9wzHJDgi67o5B4+HJ2Byg7IkYrKfYPyB1MthaE7+RAdcOAt5vwOQ9FnncWmZMT7P5p/1dsFrfZVjC1X6I6t57ht4iootS8/2Iyx8izwtBHcdP1Fwy1OsNx71TZM7IwDsyuGRJJBOzCX460Q8fcnUAv/y/kzELtJ9V3x4Kbl34tGCJJUMZtljxMIIjmc/s4Z9XEqOkLbF6HXKK696bt9x23iX06mRwWo8aX8G0Z76IM8wL14UzU0q6IpGvswaCS51SnCehVUDScPL7gc2gJtmH9Vb+nYYvJ3lH9EUGk22h2b8mIGKARkbFrXQuET3VmfSui74YJKJgnfATQPIznqsf9lNN3rRCm/soDOuasnozUS0rhHV0yOkX6fqj1Lbwg74iHXMMtM+nfQe0XZhMlKfriYbDzzPVdliQlxWbJPlIh4s3uiuKcT+867rCJHFExE/JdxiU9oGJzppJzALPgi6PpVe8f447YMgQBAShlfC9whZC6ai7VvlC4MsLheQI11oYYErAzBYPcRQrjtCM3x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Feb 2026, at 19:00, Wei Yang wrote:

> On Sun, Feb 01, 2026 at 09:20:35AM -0500, Zi Yan wrote:
>> On 1 Feb 2026, at 8:04, Gavin Guo wrote:
>>
>>> On 2/1/26 11:39, Zi Yan wrote:
>>>> On 31 Jan 2026, at 21:09, Wei Yang wrote:
>>>>
>>>>> On Fri, Jan 30, 2026 at 09:44:10PM -0500, Zi Yan wrote:
>>>>>> On 30 Jan 2026, at 18:00, Wei Yang wrote:
>>>>>>
>>>>>>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one()=
 and
>>>>>>> split_huge_pmd_locked()") return false unconditionally after
>>>>>>> split_huge_pmd_locked() which may fail early during try_to_migrat=
e() for
>>>>>>> shared thp. This will lead to unexpected folio split failure.
>>>>>>>
>>>>>>> One way to reproduce:
>>>>>>>
>>>>>>>      Create an anonymous thp range and fork 512 children, so we h=
ave a
>>>>>>>      thp shared mapped in 513 processes. Then trigger folio split=
 with
>>>>>>>      /sys/kernel/debug/split_huge_pages debugfs to split the thp =
folio to
>>>>>>>      order 0.
>>>>>>>
>>>>>>> Without the above commit, we can successfully split to order 0.
>>>>>>> With the above commit, the folio is still a large folio.
>>>>>>>
>>>>>>> The reason is the above commit return false after split pmd
>>>>>>> unconditionally in the first process and break try_to_migrate().
>>>>>>
>>>>>> The reasoning looks good to me.
>>>>>>
>>>>>>>
>>>>>>> The tricky thing in above reproduce method is current debugfs int=
erface
>>>>>>> leverage function split_huge_pages_pid(), which will iterate the =
whole
>>>>>>> pmd range and do folio split on each base page address. This mean=
s it
>>>>>>> will try 512 times, and each time split one pmd from pmd mapped t=
o pte
>>>>>>> mapped thp. If there are less than 512 shared mapped process,
>>>>>>> the folio is still split successfully at last. But in real world,=
 we
>>>>>>> usually try it for once.
>>>>>>>
>>>>>>> This patch fixes this by removing the unconditional false return =
after
>>>>>>> split_huge_pmd_locked(). Later, we may introduce a true fail earl=
y if
>>>>>>> split_huge_pmd_locked() does fail.
>>>>>>>
>>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one()=
 and split_huge_pmd_locked()")
>>>>>>> Cc: Gavin Guo <gavinguo@igalia.com>
>>>>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>> ---
>>>>>>>   mm/rmap.c | 1 -
>>>>>>>   1 file changed, 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>>> index 618df3385c8b..eed971568d65 100644
>>>>>>> --- a/mm/rmap.c
>>>>>>> +++ b/mm/rmap.c
>>>>>>> @@ -2448,7 +2448,6 @@ static bool try_to_migrate_one(struct folio=
 *folio, struct vm_area_struct *vma,
>>>>>>>   			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>>>>   				split_huge_pmd_locked(vma, pvmw.address,
>>>>>>>   						      pvmw.pmd, true);
>>>>>>> -				ret =3D false;
>>>>>>>   				page_vma_mapped_walk_done(&pvmw);
>>>>>>>   				break;
>>>>>>>   			}
>>>>>>
>>>>>> How about the patch below? It matches the pattern of set_pmd_migra=
tion_entry() below.
>>>>>> Basically, continue if the operation is successful, break otherwis=
e.
>>>>>>
>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>> index 618df3385c8b..83cc9d98533e 100644
>>>>>> --- a/mm/rmap.c
>>>>>> +++ b/mm/rmap.c
>>>>>> @@ -2448,9 +2448,7 @@ static bool try_to_migrate_one(struct folio =
*folio, struct vm_area_struct *vma,
>>>>>> 			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>>> 				split_huge_pmd_locked(vma, pvmw.address,
>>>>>> 						      pvmw.pmd, true);
>>>>>> -				ret =3D false;
>>>>>> -				page_vma_mapped_walk_done(&pvmw);
>>>>>> -				break;
>>>>>> +				continue;
>>>>>> 			}
>>>>>
>>>>> Per my understanding if @freeze is trur, split_huge_pmd_locked() ma=
y "fail" as
>>>>> the comment says:
>>>>>
>>>>> 		 * Without "freeze", we'll simply split the PMD, propagating the
>>>>> 		 * PageAnonExclusive() flag for each PTE by setting it for
>>>>> 		 * each subpage -- no need to (temporarily) clear.
>>>>> 		 *
>>>>> 		 * With "freeze" we want to replace mapped pages by
>>>>> 		 * migration entries right away. This is only possible if we
>>>>> 		 * managed to clear PageAnonExclusive() -- see
>>>>> 		 * set_pmd_migration_entry().
>>>>> 		 *
>>>>> 		 * In case we cannot clear PageAnonExclusive(), split the PMD
>>>>> 		 * only and let try_to_migrate_one() fail later.
>>>>>
>>>>> While currently we don't return the status of split_huge_pmd_locked=
() to
>>>>> indicate whether it does replaced PMD with migration entries succes=
sfully. So
>>>>> we are not sure this operation succeed.
>>>>
>>>> This is the right reasoning. This means to properly handle it, split=
_huge_pmd_locked()
>>>> needs to return whether it inserts migration entries or not when fre=
eze is true.
>>>>
>>>>>
>>>>> Another difference from set_pmd_migration_entry() is split_huge_pmd=
_locked()
>>>>> would change the page table from PMD mapped to PTE mapped.
>>>>> page_vma_mapped_walk() can handle it now for (pvmw->pmd && !pvmw->p=
te), but I
>>>>> am not sure this is what we expected. For example, in try_to_unmap_=
one(), we
>>>>> use page_vma_mapped_walk_restart() after pmd splitted.
>>>>>
>>>>> So I prefer just remove the "ret =3D false" for a fix. Not sure thi=
s is
>>>>> reasonable to you.
>>>>>
>>>>> I am thinking two things after this fix:
>>>>>
>>>>>    * add one similar test in selftests
>>>>>    * let split_huge_pmd_locked() return value to indicate freeze is=
 degrade to
>>>>>      !freeze, and fail early on try_to_migrate() like the thp migra=
tion branch
>>>>>
>>>>> Look forward your opinion on whether it worth to do it.
>>>>
>>>> This is not the right fix, neither was mine above. Because before co=
mmit 60fbb14396d5,
>>>> the code handles PAE properly. If PAE is cleared, PMD is split into =
PTEs and each
>>>> PTE becomes a migration entry, page_vma_mapped_walk(&pvmw) returns f=
alse,
>>>> and try_to_migrate_one() returns true. If PAE is not cleared, PMD is=
 split into PTEs
>>>> and each PTE is not a migration entry, inside while (page_vma_mapped=
_walk(&pvmw)),
>>>> PAE will be attempted to get cleared again and it will fail again, l=
eading to
>>>> try_to_migrate_one() returns false. After commit 60fbb14396d5, no ma=
tter PAE is
>>>> cleared or not, try_to_migrate_one() always returns false. It causes=
 folio split
>>>> failures for shared PMD THPs.
>>>>
>>>> Now with your fix (and mine above), no matter PAE is cleared or not,=
 try_to_migrate_one()
>>>> always returns true. It just flips the code to a different issue. So=
 the proper fix
>>>> is to let split_huge_pmd_locked() returns whether it inserts migrati=
on entries or not
>>>> and do the same pattern as THP migration code path.
>>>
>>> How about aligning with the try_to_unmap_one()? The behavior would be=
 the same before applying the commit 60fbb14396d5:
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 7b9879ef442d..0c96f0883013 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2333,9 +2333,9 @@ static bool try_to_migrate_one(struct folio *fo=
lio, struct vm_area_struct *vma,
>>>                         if (flags & TTU_SPLIT_HUGE_PMD) {
>>>                                 split_huge_pmd_locked(vma, pvmw.addre=
ss,
>>>                                                       pvmw.pmd, true)=
;
>>> -                               ret =3D false;
>>> -                               page_vma_mapped_walk_done(&pvmw);
>>> -                               break;
>>> +                               flags &=3D ~TTU_SPLIT_HUGE_PMD;
>>> +                               page_vma_mapped_walk_restart(&pvmw);
>>> +                               continue;
>>>                         }
>>>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>>                         pmdval =3D pmdp_get(pvmw.pmd);
>>
>> Yes, it works and definitely needs a comment like "After split_huge_pm=
d_locked(), restart
>> the walk to detect PageAnonExclusive handling failure in __split_huge_=
pmd_locked()".
>> The change is good for backporting, but an additional patch to fix it =
properly by adding
>> a return value to split_huge_pmd_locked() is also necessary.
>>
>
> If my understanding is correct, this approach is good for backporting.
>
> And yes, we could further improve it by return a value to indicate whet=
her
> split_huge_pmd_locked() do split to migration entry.
>
> Thanks both for your thoughtful inputs.

Are you going to send two patches in a series, one is the above fix with =
a comment
and the other changes split_huge_pmd_locked() to return a value?

Best Regards,
Yan, Zi

