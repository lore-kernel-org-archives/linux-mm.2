Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2276D3B7D0
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 16:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93DB6B0006; Sat,  6 Dec 2025 11:44:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6AF36B0007; Sat,  6 Dec 2025 11:44:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A426B0008; Sat,  6 Dec 2025 11:44:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C473E6B0006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 11:44:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7125F133F31
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 16:44:12 +0000 (UTC)
X-FDA: 84189618744.07.8E420E3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id DCBF5180018
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 16:44:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q78rJGBm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W5UwyVb2;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765039449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ncDLu5fKgabJdhrNgcXskh7G979sZWdZ7JtlQ/hQ/TA=;
	b=QuuUqSW5YlDqcbolb2fJ2/Vz7tkOzim2rTWI4YXydhfRZT53sIiICQqkbEkUUhn2GC9YER
	ikqUd2/G6o02llcTjFZ3vRda6JzfmNlLoCouv/nnJiNxk438CqDiDty3dZ1WQrFpq/sVA/
	FdbEE2jM22xaC8G0oZVJ3/K+jZA47OA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q78rJGBm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W5UwyVb2;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765039449; a=rsa-sha256;
	cv=pass;
	b=uVaVcSbJ29oISB8/iKKy7Mes0TNf93LXoz7dvZJgQJCFUcWvC31ttDD+JukrDWeBvRPe2V
	2gztCiFnuAMQoRempwK7BM65eWG7CIMcH2A00CpGrUj4RHgWA7IGwGbq3/FWWmUXThSg8S
	TdqG+xm5JwbTQmjBVUsJULiW+Y9jngo=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B6GbU072432293;
	Sat, 6 Dec 2025 16:44:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ncDLu5fKgabJdhrNgc
	Xskh7G979sZWdZ7JtlQ/hQ/TA=; b=q78rJGBmfDNLSODS+i5HQzNHoQdIcczvjm
	sB8A4qW2PSlvh5WjSXKWDidjKFVdET3gL/NDbQtpqquA7SAZblYs3hyRRO1t82Yj
	df5P7C0srdp/pY3YhHBsHqESyp19o3zZS8uXHTmAvTqcdWvkDIGx5zzR1rNpowlE
	AtHUpjkfmECH9EmZnaRxXezyhryoYjFLNeuEmod69T9wzlRDCRiQsNXfOaKCr2wF
	EHtmHYMsvv487Jky8P9rsFm5tIKG7WMpBIECjOYbklQRSXGIJ18UTq+d7HpAPQvI
	CUkLgHOjD9RS9rbBumj4Hn3D2iRkQx/YsDs6g81qL1aW2wf2F/zg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4avr5e0033-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Dec 2025 16:44:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B6CFsKg039838;
	Sat, 6 Dec 2025 16:44:02 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012026.outbound.protection.outlook.com [52.101.48.26])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4avaxg530w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 Dec 2025 16:44:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P5NKYyUBkban9S/bhZEWX8MYPCRC86ry9+Z+0kDc4fE2Xwsu7qgRG45cvnMzxo5Qx9TNO6ZPzuD6XFk981t9MDFbnXYkp0q2a9CORi6ESpXuH4OCJje4M70/MQ4RzGQJKsNLRQfx5j4MNtbZmYz8JzY6cTNuwWyHmINF8Q6fq5riD6LSt4feRp9GQFkF7NXKm/gw7wKIhbtKubDt0/kD0cV41gR2mYaLrqywshiP5qCNtRZ/abI+mvZg7ANEDvGWBuwQ81IHAImINnQ9sGlrhkCiPLi8P8+qonnjXOXs6GBOnef0iB7Oqpb2PCC4eI8bnXhDP3zqSquQoIrYvYiXgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ncDLu5fKgabJdhrNgcXskh7G979sZWdZ7JtlQ/hQ/TA=;
 b=UWGrWCWw2VLJ3y1PD4pmGulybp/IRfBvu+Kw5frqMeMkkmYf96dYaa544WZBACzhA9O5yEhbgMF1h6mOd3Mh4QoDgpIE5WUkY9UsT44vgZ0KX7hlPJyxLP/XRZAu18QzEPWucdmRS4ny76h7KB6BCf57fuYVh7m2YQsgIqB6pDqTwCbsY2347tfEIxeUW5hTgaIBPp7xcoBV1ZnVt2Vn6GWHEYLDRFCwLFJXEOgJFc0GpguFX4pe9WhS0pLcj/iO8avjrvghzyoO0smPw9ujbMdCaYwMGBuwESAGmE33vsm4UqnhA/M1o/6i5QGNd/dRMGK87d4TQUDhcqvoLbaYJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncDLu5fKgabJdhrNgcXskh7G979sZWdZ7JtlQ/hQ/TA=;
 b=W5UwyVb2WknKIYRhUEulcGYKf0TD054a/7jHscitzF+q4WNWBAu8h6TKWcPhsD1blh+Xgq+izT+LmPADCQ1y5mDdSkiaJwPtu27F0oe3tO3fONeXRBYgs4mj4+NA/gIq+7KInUf910W7eSSBxFgfzXaVldfFXBaDqmHRPLSx8TE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH4PR10MB8075.namprd10.prod.outlook.com (2603:10b6:610:236::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.13; Sat, 6 Dec
 2025 16:43:59 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9388.003; Sat, 6 Dec 2025
 16:43:59 +0000
Date: Sat, 6 Dec 2025 16:43:57 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        oliver.sang@intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <d8bcc6b5-eb75-4a0f-99a1-295dcb04dfe8@lucifer.local>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205184342.2cfcc73e@pumpkin>
 <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
 <20251205213449.12bf4819@pumpkin>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205213449.12bf4819@pumpkin>
X-ClientProxiedBy: LO4P123CA0672.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH4PR10MB8075:EE_
X-MS-Office365-Filtering-Correlation-Id: dac60c7e-8522-487b-e35c-08de34e6a77a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7lUTkhL+stSTzuvMH9wHjJ0AUyOPP8ByJm5xmedD+efra7hHxQmhne8zU91V?=
 =?us-ascii?Q?VZ9cxG2P2vy3NRaVNy2DXaFfXSbuAFNsBF/Avll7qZXHKTtHBsb5MsjZd9ud?=
 =?us-ascii?Q?bhCZsSUmwt3vKsqZ4tQcHQJ1DKRxdaHssoyspKqVRPcNTlzIFt25/WSQN3eP?=
 =?us-ascii?Q?qR3JkrpVSw7irGj+eOCckwzRN12kJl/eodDK071o6eJl0ZPXjwR+e7DCGQlP?=
 =?us-ascii?Q?uy3VgzK33hA64ox8te6gCie42s4QbOgCJZDaq3L4A+ggx9o+N5GoGsTyxhbr?=
 =?us-ascii?Q?b3SlcrZqIjcOp7pmnOB0dfu1I4DuRBxNx2XlBwhvDI6ISIc5MqP8E1G3EgR/?=
 =?us-ascii?Q?boL3NO39g7yHSmC+/tHmVVQ57Z32igyFcNHIUNVpE9rLf3gKJBmTQLu6ojJn?=
 =?us-ascii?Q?AI0HUimuSyS7blDCh/xA5Zm2emljYNwFUQSbcMAkcXdXh+rmFnQUvgSzrFVz?=
 =?us-ascii?Q?+JER34ADuDBlMONbqADqfqDKWjyDwCKr2kqLAjXLp7kEcX31VSOMYMhatSN1?=
 =?us-ascii?Q?XSTJ50kMm3DH+Yvl2fs7VuBfLb/snmombaBStQng777JxDWSv1yvMotTsZu7?=
 =?us-ascii?Q?nB3j4DLIlLzvQi8JGw/qv1TGoFn8GUfPab7EJq725lZESK9PHAvUddk07NIh?=
 =?us-ascii?Q?Hp2gX8FUyrwhG/fk6bJn3jIAcj7xmq7YBUOrnUDEiMFH+LMKUYciSg/IZ6DF?=
 =?us-ascii?Q?1UGxS5AaZMvQTBBoH9bnanWzT6O1Ya7ZvyGv9LjBNiU6PzLdPSNOLD250EIN?=
 =?us-ascii?Q?n6fe1HXMRS5qgm8QEaUgEGXVWjqGcaP2oSEWbq9INXpIcZnz/LdmrYnqzGKf?=
 =?us-ascii?Q?k47lbFHYUIY04xSQVAimbNktaXQ8KKJVxym3P52DfjVXMGwJaK74b/5YVFFR?=
 =?us-ascii?Q?89g9eSHsifd8wKMyv6H+eJnW0PBCvZH3qYVB+GQ2IUFrDwB8O52bZHXlelvC?=
 =?us-ascii?Q?aH5WVQLtll0Yc7xW3XJr+hQ3eoyy5idVHQqkyJy1qJUW/6WzgIHbfwJ+Jspm?=
 =?us-ascii?Q?qm8KainkV3MAGhD1vAbLmyfnVZgDqLlfgHWUBrnh3b95aVJ2u3SxvyTybhhx?=
 =?us-ascii?Q?rNlwpvxTI6DaCZPfbaZwcq1XTQuUntzUiuC3vS3FftRIfEzMPK+XnNu3NdJP?=
 =?us-ascii?Q?PEc+wm6jqyiaSaCzwbM/JZuj3aFef3IUhADMVJC/YwFyivJ9wyYdxWWHutOr?=
 =?us-ascii?Q?wt+0nRCNcs36y/cY/1JyxHojuNWRIYh64igkYpEAURXygVZh2BNv11R6rvSr?=
 =?us-ascii?Q?+Lbs4RFzgvpEjzWDwK6jSY31C1CSk4egWi4ggX43n9hxVbfeOOKLrhm4q0UG?=
 =?us-ascii?Q?Qu43V/CfScJipgm5Mj4Y/eLX0NL4B9LH6B0580HLbuWd7Q3XhKts29Zun+6W?=
 =?us-ascii?Q?uZUUJ/dTRMElExe2eHaJJj4Z2os1GZcIDkb/RN+8g+m0sg9sYZqUAlcqqz6C?=
 =?us-ascii?Q?14hv9hYCbf/LXCMb3HStLQnr6UndIVmX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lzuiNjUEKlhyN1kyi0wYH6du4Urmd1KsV/BJAhQOBs9Nc5bwBa+glY7Y7nrg?=
 =?us-ascii?Q?ctKFPIFSwu4etsDBfDN90Hny4HYAr+n7Cw2K9q3TBAV+4sot/RDQPD85Dls3?=
 =?us-ascii?Q?ErfZ985nCvo8IXwyrXafAk4jHoR2QRHT4Ar14mrBs6zOzSr7cgom99BFReUZ?=
 =?us-ascii?Q?b6Z7IDDSKRjzuyHGId5Y284ferPMm+/J4ZAapPW7oOn4ol7VLgqQ/dRmLXna?=
 =?us-ascii?Q?liHmEEZgydVcM4eMgJakhLJEnVIh3KuE00Ci4u4+3hr6h4vTern/6jLOcNj5?=
 =?us-ascii?Q?uFPLDOvFDHjBYlidj0wYmdhJsvPurHSyYvWa7bDOzBYxqmhVYfbGJrMumVhw?=
 =?us-ascii?Q?EkYIx3zs6CE2tbHRzU4fp6O/4vNZp5oIKEDZUfJbDZOBi5idr5T1s7RW/W2W?=
 =?us-ascii?Q?NJpQaS9SwsAoPx4USwnjzQlbpSBWunZqFK5TNmW0mDTOLwaMFa3EAiR/SviK?=
 =?us-ascii?Q?3ILz2LezTa8PR/Tihr+zEhgMMUUe7hUvTgcU5srkMtwrbCW7rODtt1CYBVZP?=
 =?us-ascii?Q?TpTZIP9XBmcB3u1SKGOdrtEw7wUNB70B4yDpDnD7WYqoKMPx9AP8iba6a3M/?=
 =?us-ascii?Q?Befli8AZZtKCUGHbh8d14oq7yxvvJj26JLtcorEE+R7zIYkdoStYTxYHuldb?=
 =?us-ascii?Q?8NTR372ShEtl9COrYif1KdGwgtL7kJciKDIStyHcl8/d3ajZ/q6nYMGeyZnH?=
 =?us-ascii?Q?pf54q8Mjr8FVVwKcXLBs7cnVw+3ZUvusw17K6A86yZQGeUgYGRyM/oZF+2Kx?=
 =?us-ascii?Q?Ju2tkRIqpRYg5qyn+7VT8GFv1jZgPeUXxaiwQmFUPHu/EGaFmvKEz2IRowcO?=
 =?us-ascii?Q?r48OTmhXr2T8jw9tPuaxvLv1tldmq1gdbb2+8372lJbaSfgB8TGDJVk5bZ1c?=
 =?us-ascii?Q?mN+qeRW4Z/pxowNBVBag6n6AyV34p+8V/jEpjpK+2BgRfs8M1ZI4jCSl6EOx?=
 =?us-ascii?Q?glwsglkgO5/KlueUZB8GW5Wx/ipIimQtQfWvNFDi6iz/KErttdqLIJAUzNBj?=
 =?us-ascii?Q?2PWllo1Zg+HrceLTt/mrRTeXtzvwHQ3W2IymjkD/A/8aLHocL0i61MD9mZZc?=
 =?us-ascii?Q?ntsnEzVyMEbi7fm7G4edNeGuNwKdRfkqCr6RMd+NyoeUa9KljLYOf4asvu7/?=
 =?us-ascii?Q?/PryBqJGVorHOdLOAPnVyadv7hDJHew2kNgM9+yhlTzxMeGl4Twh3NYMHgii?=
 =?us-ascii?Q?3i3RLc4ZMF+u9D/XU6/m51+YUbkJWUo2+RPOKzb2I11EGTZ9p2cGxcMa9vG6?=
 =?us-ascii?Q?SXn9GSRItYdbcnyRAR985v5Y/vYno2FgN0JmulUi8dqLDUL5VBTRwy2/zn40?=
 =?us-ascii?Q?4NygTVJoPTx9YcRfkeons4RAlh/tjyVbfibjp2P2yZFURia/NbYXqVJwlEgE?=
 =?us-ascii?Q?VDe5VNvPyCFCrw4GQqxGkl0cgvVZLDqscVi+23/eaUaZWl+dYiKUMvsyqZ1O?=
 =?us-ascii?Q?1cyRHRQzIlatNHn+Ww2UWcufrgxGBj43oOK6+Baie6Qbk7BfPYOpHRwI1BKZ?=
 =?us-ascii?Q?0X2zD0Al7Gz2SfIi3E4GgX69WbcLrQ2S6+XzgOn3wgecbIA+7sH/+b3BfvEe?=
 =?us-ascii?Q?SOOnZClIL/lwEYxVHy/2SXAN8xyeOYHWK8Y2J32oUXjd6HpyOt+T+EOlhnzP?=
 =?us-ascii?Q?czHpNq+Tt3jcoUKhmyAC8e1vtZRDvY2VKzNmR24qSRXBgh/fw1fNqJlO580Q?=
 =?us-ascii?Q?TNa/3A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uYCah5aGb/hXoUWjVejjYBGW7eQ//g13JgQ2usv1am4Fg025alD7YGHz85V1NGbwhABA+H9fDWZtpW03NQkX2o/6tPvssTh55FlPDltdEAKAaGRahMv711dkq9rfur/CeHDvVYDEmBjERoQYp7LAo6x4WkvL0err3RkrBE7B73iu+5piPvh6LNaF09eGsGab/zvktlnwd9/xQ241roLpeEZ7M0P7QBzb7irN7KYZj2ZI9ecr+xkTI5faGHBmkIZnvyuklVDM20qw2KYIKJZJERSBXsjBdml07dAumZ5nnZ4HteDSb4ox0SochOWgRdzOQzHlJoeyqF9tZNvsavisMC0k6clF6wHWNeG8Alj9GjNAuIfSBeiD07g6ge5b1c1gdVIxCM4qRisRJHglA4+oeH3ir/Lhy+kOq1mp+f8UULCUwAaFNy8YKbatGUekwhcPJCmRBNsFlWOHi2FKev5SXmoW3j9zLqC/DbULi2zJz5bxJW1Bj8gKVe/K0Os6GZztZNGs38A875ibhm+vDpiOjQ2cz7s7+GmANgVfNWhAOKqeB/tVjSrMsVvbvBHNi3T4Rlm+8JF5jth+ENWWnFya3ot6TD4vJgQZaVpG/uUO/N4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dac60c7e-8522-487b-e35c-08de34e6a77a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 16:43:59.0680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhA47ghVa+obOHSbPXn9Nn9/vXcE5nmHglJCylJXx42OBoS3AnY25mkLWLcBU+1GyXu8phNLU5ym9/FlZUUKBY6ps9VjvBcvRST1UGb8YzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8075
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512060137
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA2MDEzNiBTYWx0ZWRfX/n11We7F5wRT
 Rv4RQO0Kpz43kSqSUNkTvxJrKfMdd5NU/2ygiwtKrWhXfoUsL5azTa/aq8rzEyTOanaLebv71HR
 KsMHIGiawHlM1pLgbQdXbgPcbzZd0LDiwDHbA5g49gluHKL9F/FzP/mqoE8Gaz1FtCh2kp9tYne
 hWlykta7oBAs+MI0WLWboZxiLqRSAhK8hrZpZwK8l1ao+D9j4eaUOzMUwHYyl0Gpbewqymciip1
 81FPOf30KIfm0zXkbhiRkMOhdPO3WrW5hnjWdVuvYLjUPOxKq3WgxRXSkscrrZl0A3diDySvCrV
 vTK1+YBwbZNmUMMI8nWv4eAoeuYklfehgX/8zqoXIP8rcy47frCFcYLzsECLqLGbiDmqd6lzTZN
 NBTl5D/jPoTL+Vlyqx+8ETLN6pssamjmA8Q+qnJD/DHUh4+XvB8=
X-Proofpoint-ORIG-GUID: QbaTcTAsEJ14eQmojQVPRLFoG_H941gG
X-Proofpoint-GUID: QbaTcTAsEJ14eQmojQVPRLFoG_H941gG
X-Authority-Analysis: v=2.4 cv=MfVhep/f c=1 sm=1 tr=0 ts=69345d53 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Up1whnIK-If5Cw_EK5EA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13642
X-Stat-Signature: 4gycakwyxj4fxq66qdfsi9zs5ebdhyp5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DCBF5180018
X-HE-Tag: 1765039448-440239
X-HE-Meta: U2FsdGVkX1+0HnjWgTZQEmJLQqYTOtg1G05pN0SH87KnEpELORuoDQOv/X0YBwzDxPgtJHGNr83DC5ZfapVvy+3+BXFqgBxX1td1trPBJ/hRYfCjsvQLPUufvSw8regXgHpnAk54truR+LhQxNpZ/DOdun96Ev5tblNBpj4l5ur6DQjrDWkyvL1vw7hfjhK2OBCkwrpWPnIupypu3Aol2vlsUL8kxp4oiCKXv3nKUh41E8NdlqnXcEFcaOTnRS18Eobur2OVAt2A91gfc2NR/rGqgLs2S89jKKZcgzE2Ik0Xy+I9O0mkyvMZVLeWkX4Z5yJ23DNAPbsqhGsYVDe0w1zWtQ0JxcDFUabFjrijQAaVuV6WwkV6wk/dGnBwCZmkksGK/Ug+T0aT5qHCT1skiotP+gtnLivuJtpMaZWV47apw7ozdx/CKV1shq5Nhvp1pOgm6OphoxnDmvrb8ypKp0qPNSROkT1b03BqKR1DtTNMBxMUwwryVjCTvsLntwHst7dNgBRfOYTcN9gm3OMTVztgqwaDjMwi0HD9BImzVks6Hhp6C/IPs40Q7ZKE0sYZDqLIEtSw3CeVO0w/4Qma6tbGCl2ogv2qHNLakShalDHTWoPCKfL/iDQHvbV0W+PdWF307Ieq2FuZVBJIVXGdrrxDhqdRru/+Y7/t6+FQoL3Ns4MtN04MEe27KYDfIufkMk7ZwgmvW5bVApHUvVi+tBfS23j06YorKduhK5CT3xUToYjkSFe0A4RQPb6ZzcRHs0G+iWhDn6t1EIFtvuqpVZRWJifWuH0+IuLGnLydkCl9FpzVpl237TNcD0wPg1TV4w2KJXaZ9N5Z8O+YM7Wgnv+yF++N2aDjLYFRAGgtUS5aJz2xMg/CkMWZNtmx+/ot7ukQpklvXx9c/LzvnRv8k9r54KBT5IZJ4cbd5P8vghGdIFkIcGORWIYLZSNymiePn1o2wv6NAbZ5MpVvc8S
 rac/EYf1
 RzXC4EeE+gQHTiSv96qVU/Eo5isNphpS4yC9X4o5cOuqxPaBKTGQSsCN9Sush3vCc7Tfk0YomE96qXTv9r3l0nO2Xl8dfV75tVwhhmrr4+N2f4dljom1sZDYn60H+NOv1aoA0toLC7EH5MJfs/5kaRt3ANxnBPZwvtBixD4Y05H9c+1NAIBQ4U3FBrdHs+fzVb0JNoKuWmvIBnaX0bJfEuz3yNU6a3ZouebniDP1KctRUnF8GBiUHSZck1mCkl9i8SEn86xJOsZXOjU62xtgkYpZ606Y1OUU0xywP1N7noHNj6ZkYKu5FW3IWELclJWxn6bTsFC6GmUxb8DiQzu1eRnKYgUFhs7j8Ytmpezy43Qf4qDuS7h1ytBO8RU52x3sc85+ziIn401HBtvmbG8WiwcExvIOq4YCnq/kSeV4FgngAZ9WvWpryMDjFo0H/6PNNWvVGRda7loNPiINc8WaXpCfdXV5mHKnksVduvhVD6v2poNaXHkS5VTVBf7WED5tU4tTzrTODy8lWIfHmBJL7UZkARMApIRcv3tCvlvWmotgb9FXQovcB/Rajds6IBenXHFAmbeABevtM0wX4FdsXa9N8zaDBLyg7oU2y7Lc0+H63rf7q2x+EqGniWFKIG4VwmGLHhFSbbYVKje+H86T3gE5kOEFh0KTfxsMdTa+hdem5y3n9enm1dNz2hhNZ6QhAkLXjSrmunH+C9FuNhKG5H8KojA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 09:34:49PM +0000, David Laight wrote:
> On Fri, 5 Dec 2025 19:18:56 +0000
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > On Fri, Dec 05, 2025 at 06:43:42PM +0000, David Laight wrote:
> > > On Fri,  5 Dec 2025 17:50:37 +0000
> > > Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > > Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> > > > how VMA flags are declared, utilising an enum of VMA bit values and
> > > > ifdef-fery VM_xxx flag declarations via macro.
> > > >
> > > > As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> > > > the newly introduced VMA bit numbers.
> > > >
> > > > However, use of this macro results in apparently unfortunate macro
> > > > expansion and resulted in a performance degradation.This appears to be due
> > > > to the (__force int), which is required for the sparse typechecking to
> > > > work.
> > >
> > > Does sparse complain if you just add 0? As in:
> > > #define INIT_VM_FLAG(name) BIT(VMA_ ## name ## _BIT + 0u)
> > >
> > > That should change the type without affecting what BIT() expands to.
> >
> > Thanks, checked that and unfortunately that doesn't satisfy sparse :)
> >
> > I don't think it's too crazy to use 1UL << here, just very frustrating (TM)
> > that this is an issue.
>
> I might use some of my copious spare time (ha) to see why BIT() fails.
> I bet it is just too complex for its own good.
> Personally I'm fine with both explicit (1ul << n) and hex constants.
> The latter are definitely most useful if you ever look at hexdumps.

Thanks :) yeah I just didn't want to go down that rabbit hole myself as I seemed
to have the answer and wanted to get it fixed, but obviously am quite curious as
to what on earth is causing that.

>
> At the moment I'm trying to fix bitfield.h so you don't get compile errors
> on lines that are 18KB long.

:)

>
> Found a new version in linux-next - has its own set of new bugs as well
> as more of the old ones.
>
> 	David
>
> >
> > <insert rant about C macros here>
> >
> > Cheers, Lorenzo
>

Cheers, Lorenzo

