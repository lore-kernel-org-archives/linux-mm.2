Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E692D1CDC6
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 16:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874EE6B0005; Sun,  7 Dec 2025 11:21:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8252A6B0007; Sun,  7 Dec 2025 11:21:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ECB06B0008; Sun,  7 Dec 2025 11:21:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 569486B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 11:21:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1824E1A0732
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 16:21:45 +0000 (UTC)
X-FDA: 84193190970.25.D09A535
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013051.outbound.protection.outlook.com [40.107.201.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4B191180003
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 16:21:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jnXqLp7l;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of jgg@nvidia.com designates 40.107.201.51 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765124502; a=rsa-sha256;
	cv=pass;
	b=Hy60glmTk79gQWdkx3OLTzBG/LYcTRxT8WjzExV4T5cTy4xHQY3UlaEOY1JTsfaZ6yFLqK
	hZbZ10EJ1yRHPv3I9LDRB/OWVtvn2uLqMHcvJ1W1d1B4tWnxaYC4Td4n6F+mklEerqhJcL
	k1m+653mWykMIngKj2bhPywLkHqAax0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jnXqLp7l;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of jgg@nvidia.com designates 40.107.201.51 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765124502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+9zOeLqKUTykIlZzRtwRSZltDt/lRX8FSvuSr1GAMA=;
	b=fmzlMHC/5OJaoYi//bEFcriMi9Dn9Tk2PSorlepj7+S+87CUVWyJKhC44fKoJSygHt3loF
	8PvPXhS8EdeTZyQvKOcjYxbo+EiFR6pxQf5kGXvMBfAcQLq7R9gAdsWIwkXfjRrGcFXeHF
	Ev9DCMF2beQtjVSdVDsqgEq/pKckMks=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c/mq8bJBwifPYMUwFB/kP0vM0sEq99K2TBWULtOSjaR77qdVClDQVWxfu84+9f+rE1UUGMFCRhd46yBFu159b8iaRlqxo7DNPb+Nk7h20hju+G91iJTQKH/fAI9YlVfbZdIHPA/bLQkfT+CvvGwCZay+cy2l1P11+wxJzVw9MEvfrtpHK+h3nlz4+SrxhspwLgRNzRRXP30IiIMXjMSyIY1OyrV/HN74eJG+CYS4o0Prenvxcqm2GPTLLQyG+/guFLeY7sWniujxVSuaqSsgY7/z5vzrkQuhj7t45jyPvwjO5NggrklbKnGNp2UA8K/AUQs/EuKwutEW0AQSkXF6SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+9zOeLqKUTykIlZzRtwRSZltDt/lRX8FSvuSr1GAMA=;
 b=l66VJP3nJq5LKqQA92YYsScCkNGrFooGlZ/dE1Bi/Nq5mmDdk5PRpP+5HeaXBbY4XhNr3vSf8jXc1Mi9Li5uI34OZQzKCo2HZn9PQ8R5UyRtD/RVP4aLILTIQX0ZE6SscdSf1PwaoNPxVs+fWJY17hhYd5Dv6JHpF4QGRfPiktZeuh6muzAAoTnZucoTMKJgbMVnllZ/77fjjChSVzwTvDaJ1MAanHdmmpIIPrk9ajnCLwGFEdGjOSWRjxMmQ3n9KAOysbBErTS7CheLzY1sod4Eiz/pYFDiYSLrRxF3EDz1/5ETgrydla0AiSkUX/mdomaQwMf3hY/SyzXf7k8gcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+9zOeLqKUTykIlZzRtwRSZltDt/lRX8FSvuSr1GAMA=;
 b=jnXqLp7l6pwAoGuvuFDWGy2g38BYDvqSC8Cs/9u9QRzsk1w9P1iXIovPMDXN4VE+6QNl4n1Auygy+BV8G/3uZ0VOW6EkpKsNHWb6RB/XMDok6SIA4EZkNzh2RqKhV7viI3AMUo5KBuh4jQNVmMm46RfKTGzhVJ2MATPy6Z4Je1mxqDTsqCMMJiUNdmLxVdkS/5T/fhEl5txrPYEdUFn+XoPQGPam/l6+czrlVhFR1/FpvQ1morRVwkzSVD/QpqBNF6Z3eJJ/ktHm110Z/laW7wTCuevuAPwp7elyYnuZ8hiRR+5rNlieyBs3z8KDwJjiFR3sw8qcpw1QAtJNN0uZpg==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SA5PPF9BB0D8619.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.10; Sun, 7 Dec
 2025 16:21:34 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9388.013; Sun, 7 Dec 2025
 16:21:34 +0000
Date: Sun, 7 Dec 2025 12:21:32 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aTWpjOhLOMOB2e74@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204151003.171039-3-peterx@redhat.com>
X-ClientProxiedBy: YQBPR01CA0040.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::12) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SA5PPF9BB0D8619:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a75c673-5e87-459f-87ba-08de35acb012
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/H/ZykLUIV87ymUi4yfiBsj7WNbOKc0Xr2GS9o5l88KbRNtAccc0ViJU7oiT?=
 =?us-ascii?Q?5Mpp4mOLWcxfuujozYvq4bDc90AElSLu2vq4fu/ZdM+OAmLVtep9eljKafDV?=
 =?us-ascii?Q?GVU0bGmpOxhjEaCw5A+FfhpDdaycJGBN9K9N9xgqhRuXSaApYKgYQz44aPgh?=
 =?us-ascii?Q?ajwNtWbWNnBJFV/2I4IOo6OIVZ5RiUoC9zSaTG1P67heJoxwNS3bR+HQzaoz?=
 =?us-ascii?Q?dgwQaO41HkjnOoJmXYtfyvFv4xSM34QDXIHjVYeGC5w96YFu10JJ8f0amFRh?=
 =?us-ascii?Q?Sxp93uH7SZxh8QBPDrKNML2ARkRJOqAAFiqUbiM/3I2KtdgE2aDZQLwmUA/T?=
 =?us-ascii?Q?jy/SYrocEd7DFpzS4oBq5hdYNfUoaAnMQ7WVPdNrvYHTZ1qzPSg8zg5fXHMl?=
 =?us-ascii?Q?CGroreKR/VcuU9RQNSJzafNJSQp3B8krdEbqJaHlRYrKGn8MQjPYNz2JCrvC?=
 =?us-ascii?Q?C2E13ODrNMIwFXj87FIqXp7aaO3zqgq48lThCqsbTVvIUl/l4c60F5A7QTq7?=
 =?us-ascii?Q?z+QJ1RWD1JvwR2Tfe/yR+sB4YMGLZGIfNBYmprw/F+2M3a7lAT9eJvrGtH3G?=
 =?us-ascii?Q?mJreUEK5Xjw+myrK+solWB8dUCBRgvWPMiEYfo6wY9Y9aaVkgT7KNsBPEdd/?=
 =?us-ascii?Q?zUsb01VaQFneZ3Y+Bapwz/bIgax3W+FvBamCZFKB6Vgh/oXBnEPfDcoZwpBP?=
 =?us-ascii?Q?X06YqlBhKUP+HSQPOxIHc1pMsJ/z85AaYTgwwcknVbYEI9oIjHTmt8s+sinC?=
 =?us-ascii?Q?gCp1PcU4cQA281+kf4xovP7VZcv4gFZd6n9TrRnvgoFY0ya/27U22v2omdvy?=
 =?us-ascii?Q?ORKaKlnQCU9xFM/mhOhqJkTPx2tYKhKzwIbxzT5AqJNqZlh9Ma++zP8wXy8p?=
 =?us-ascii?Q?VzBvh7lVlwe5ulpJp5BKesY0rsCMGPKqape93GUynzPqR3K2sp/9OWfbB8of?=
 =?us-ascii?Q?GGEa4P1HKAqcN5A6GJCEiBb7sw5nsM5YFaOyQwqE6qb27+RL52DID2nQnqGJ?=
 =?us-ascii?Q?hsoKUveDOlgdAoEoH/Vp2LqBPkmTeaKrpxaA14sQI4XVdLZkbMDQGFvxAdZu?=
 =?us-ascii?Q?lneIQJAALItkjaPZcGoaU9VguGmslHR35ZMJxerbtUG0UzpxrIRldGTpsHGY?=
 =?us-ascii?Q?X8c3Cj8tiE0iPGyK5vucCWRVIQEbnz6OgUcZG0x0pVHb3WoJsCWg5UX6bG+t?=
 =?us-ascii?Q?Yb+xrvcwv1xrc7raMleD92phgFOMRTe674A1iDUiIcZXpZPYcLBDsGbm2Hdy?=
 =?us-ascii?Q?BZDVg9nbgT7l4COHnBiejzIdb4bvD3mxhrjH0ixNLh8Y1OWcMCFnNcRaznwO?=
 =?us-ascii?Q?BJX+gmehdcLZWgfmusz0zay4GXO8qD1O5HNFlPloVFR1LBdaK3XLuCeDVFdJ?=
 =?us-ascii?Q?QelWu5TPBr9cSn8DQ6TZb29iGgz+Y+lYlX8xWqwxSKCaaGnIXHqGsY4FF12G?=
 =?us-ascii?Q?95DxWvmNKyQDIPX/QHi0wCV0bA8e+g18?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UcIe/kiEAb4Hfj1x70Sepbx4ulT0tb/9bg9ybYZH/kvPF3EUAnXT/ZyDeQy8?=
 =?us-ascii?Q?KXDMXo68L7q+PiQUf7Hx9JcgJoVH+1wMOJx/KngpQ+nAvJQxTWrA6tJn2VTX?=
 =?us-ascii?Q?n0CpVGKXB4h/2q3j3gRYg8m0+fRA08DOhOpb1fgWOKXLSzUWN0woxVRQDlzk?=
 =?us-ascii?Q?v6lW54mAGNbhNWYSZ8ocL+NWpKn0HXGbT7Svh/UgL6Evai9sXzJBWln/3aNL?=
 =?us-ascii?Q?LgS95R2OqTt3hY/TUpoDKMe064+0OdTH+C5jYyS4CJUhP5Q/g0hukZMBbu8V?=
 =?us-ascii?Q?LgOXk+Wz/uUunkSgR7TkZdvtKE0bGNXoQ+sjHpUC+VADU3k1xB7hhuadzMSo?=
 =?us-ascii?Q?//6xt2YH5PLq1aMH52byUmcLE5q4atJiSH7E1oSF0aKxMi7ZIg25VsxcNpcf?=
 =?us-ascii?Q?W1h4zsvc7s8HuoFhcCZL+nG+f1d2maEuQtDzWMIXZDP60JTHhbSiRM3K0VWm?=
 =?us-ascii?Q?tUrApnfFZdALTZ7QS1jBEJxnjDZktbQVw+GueHN62BxzLEY0YMD0WJi8zn8O?=
 =?us-ascii?Q?UtdaSaKYXAevmyx4v0i3zI9RWfHi0iueYi9Bi7goydMz15A4kTb0kCqmcMF6?=
 =?us-ascii?Q?VJb7OErKiLz20s4LmX7fxCIYZ5k/Hee4tNfSIJ3e8ey2m1rrcZNVP2kxfbgr?=
 =?us-ascii?Q?ByWCW3uxTlExGqxyvbRl19mHyWu4bOI2KPO8JxdPANvtVYtq1AqLUnOiFdBS?=
 =?us-ascii?Q?rsM2Bz9mz35rAKTMoAJRbHZUzvz3Esq6ckX5xgwniVzasTxCSZRb+tEWcTR9?=
 =?us-ascii?Q?zcX81JT8CfiSwnkEMlh2jMCmSOR7RFSTi2E3tPkZBwYQWoBTmuD2OJV4a6uM?=
 =?us-ascii?Q?v5kSwbPFNAsr5/kYHAyh9LPK5d+AN4mg5FkRU1alGWcFyYTwZ4+r1Y5cUbMi?=
 =?us-ascii?Q?2zYQOilzWaWa8DydMGI7UMrwmHpQLAqk4kFXa8quqmNgrREKxNwFK6BgLeg4?=
 =?us-ascii?Q?Vqhxqp+ihJfPMMI6kiYybYQRMWCko5d8HrkRtsZloIqoIfkJ7Q8k7jDzsphC?=
 =?us-ascii?Q?HKJgjNMjqGoe+uuHw9xCDXdP91pgtS5MCM5ijNChWPbvXs+nkCcafdcWAruS?=
 =?us-ascii?Q?kSNahCowpSwPvKzWQBJGgp4XVC20zaeHgJUjPQ5yjgpsuwNK/4QptUHdYkJD?=
 =?us-ascii?Q?mUlBVOxy2lrEELw/3/lxWbbyZiIgXeFrNV3Ey9N682lAkmo5t09nkkAOYM6C?=
 =?us-ascii?Q?Q4nfwDxtw18tL1IRIMQeEG02q5CeS4yL7tnxROo6Hfw++rGDGtebLO+QkZd6?=
 =?us-ascii?Q?pC69Waifo3muMTfTxz0Zwk/WlrtWPWtgMugVMeuDN3ijkH0eg648i493yD9H?=
 =?us-ascii?Q?U/ZI6UPicRese5jAB5kqnpnLvvJViklomy0a7irHDe0Kq3SP/TRCq0ocYZGf?=
 =?us-ascii?Q?IMDH1OaydZXxajkD0gf3+0oHeysPvM3MQubuP6oHd/o817ls0DAfJNet+oxX?=
 =?us-ascii?Q?Gep9MXELhYyVvN9WZi7vVgYaWm08terLkYMNSmpsSnEvjGa3R6hHZLWAuUgj?=
 =?us-ascii?Q?KYE31OnAJk2ji9rD58EQLXzIIAw52Gv/tP6HIbxhcohbZWLiICR8Sf3iLEGZ?=
 =?us-ascii?Q?8kwwnuUrJWnnrjL+0bFqNv04Ap8CZMp0yHT1OI2N?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a75c673-5e87-459f-87ba-08de35acb012
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2025 16:21:34.0807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J842ZeDnxgE9cx97t/iWG0lq8H5pfxgI5u7n7WKuh/sAofHEtaaS3nHb0CEauwGZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF9BB0D8619
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4B191180003
X-Stat-Signature: t9y1ig6d16d98d696kdqb6adhkj3571g
X-Rspam-User: 
X-HE-Tag: 1765124502-604484
X-HE-Meta: U2FsdGVkX19NAd+zZNH06tvrEjK4bwpjFWTlcyfgjNfTlfGc7ZpwSeQ58+6FKpSeaN3w21A/59q0rI6FLz4U4Q+PSJz7vAe/BpWhR3af+PewwKm38Whg2o5jM+1frtk4J5S2H9vO4nkyXC0evmF+0ZViqyq+TCJs2kVMeV0biWjKT8wNmXCeGe03XiTTj0v68Y87Y5n8CaDuIT2zFa9JqmKQuzbP67oeMmOJ0a76U364sEBQcXGelxdrsch+R3wKrC/gVrUkEEObs0K5z8avP7A5Vfuq/fJn1RkK6LgIMLXGRmUd4V7C/xPNqS3GGnBmdyFvWfRQsa2gL5JXwo3u6aqlYfNRvD6Zn9xyoZSf+rwxWZD2+yEbbZrfRtMuOjv/w3riNpHQuH4CfTye3Pqh8ubRcJmN+zojlFIalvsMdXUvVLNLlnnqNWQKxxnn4DNq9qWGvZR7c4K/SzyJNopZhr6vO45WkzwuZ0KgkM7w88bX6j4EG1QHE0dE6FN85Hxz2Vcgmbogwdf8nheAXso1p5msc3IktuZ1pgDepl0hZJ1DbvwTQvwH5KDO3W/+IJmyI0CrDXgAKP+RahbSHy45/rDITfbJjLXNBWkjhOPjlh4bE3tLD0qjJXmtLKRNqMF1Z4hh2npwz/KXKOL64BFQC+t1f//yTLrLRFKIUHUzmZf541M1Dieb+fVhujDKYB7tbZG8KIggnDBU6L6tMC8FiBVQd3kEYx5MMN8Y/3Evt+5Et4Za2OTch4Oey3rZJE22kmu91SxdK8/kIWyaleRpDYcib/+jyw3TH7C2QO/X3H83n+HE1UIWoktkGeyRbpqltQQmH/TzdI3xZ4x2SjvUJsMMZnQs/ZQ0XHt/6juESmVsPccsVoCp1T6EcfpaoqjFCsXz7+rLTMDa7FvYd9qdMjgO7YOLzUApBkHEX73neLS+PuJWMHbQe03uQrbrjWqYv/vLeQSTrAT+A/3xG2c
 MNmDXOjK
 KEVjgI77Y89eWPhcCLe79RQHVKyTMU5XIbPwVZWFKCi9QU3XvKtGE+EbimYLwNhMbH8DiKnROI+Q/uAVosFYl7UKpsdv1YOz+maWe0PLBmel7f/O7zXt9tgQ6PxXnhfc27YGtB+gP/IFrG+DZZ74WLeyDj/X9TL2QtDSYEPTb5QBHXtFTNHsR9O6r0vCWZMZ/9zmKZvJTW/eS1gCOW540gxK5ien0qM/nmmkGijlfKGpVr7e3GjMpY6OocihGDT8VJIBRhGBCrhhAZXm/psTTa/E8rMsFmGyqYBB1NGfAtvzXcgx25Ru+xd2LuVTIqiQjFgrvcr8pR6RozBur2zW3iJcz4gV3y1vHJlc16JUbNuA4t+LBIK1767o2GYRi15mgnCnMAGLIveOn9lp0qYv0cpIK0DTcDNPO0DUhSB3/DXYukFVmi+m3b27lDQcli/bTdwi0dfFIZPnTsrAmnaUqlnp9a9yi+ZzDz/2zoqDKH5cEbbwWbRTy77052bVzVSWPbKu0UpuOJCtVl5t9bnyZwpsKBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 10:10:01AM -0500, Peter Xu wrote:
> Add one new file operation, get_mapping_order().  It can be used by file
> backends to report mapping order hints.
> 
> By default, Linux assumed we will map in PAGE_SIZE chunks.  With this hint,
> the driver can report the possibility of mapping chunks that are larger
> than PAGE_SIZE.  Then, the VA allocator will try to use that as alignment
> when allocating the VA ranges.
> 
> This is useful because when chunks to be mapped are larger than PAGE_SIZE,
> VA alignment matters and it needs to be aligned with the size of the chunk
> to be mapped.
> 
> Said that, no matter what is the alignment used for the VA allocation, the
> driver can still decide which size to map the chunks.  It is also not an
> issue if it keeps mapping in PAGE_SIZE.
> 
> get_mapping_order() is defined to take three parameters.  Besides the 1st
> parameter which will be the file object pointer, the 2nd + 3rd parameters
> being the pgoff + size of the mmap() request.  Its retval is defined as the
> order, which must be non-negative to enable the alignment.  When zero is
> returned, it should behave like when the hint is not provided, IOW,
> alignment will still be PAGE_SIZE.

This should explain how it works when the incoming pgoff is not
aligned..

I think for dpdk we want to support mapping around the MSI hole so
something like

 pgoff 0 -> 2M
 skip 4k
 2m + 4k -> 64M

Should setup the last VMA to align to 2M + 4k so the first PMD is
fragmented to 4k pages but the remaning part is 2M sized or better.

We just noticed a bug very similer to this in qemu around it's manual
alignment scheme where it would de-align things around the MSI window
and spoil the PMDs.

I guess ideally the file could return the order assuming an aligned-to-start
pgoff and the core code could use that order to compute an adjustment
for
the actual pgoff so we maintain:
  va % order = pgoff % order

Jason

