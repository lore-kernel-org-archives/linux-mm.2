Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A39CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 11:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E998E007C; Fri, 17 Oct 2025 07:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF638E0016; Fri, 17 Oct 2025 07:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190028E007C; Fri, 17 Oct 2025 07:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02FC98E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:26:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C6E7116F32
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:26:30 +0000 (UTC)
X-FDA: 84007378140.08.9CDA057
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2DCB780007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:26:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aQuSPNO0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iRafJqMl;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760700387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GHsqEPWALDFTMiH4ZD4M9c+xc1K/ddjKVZEnXkYiQo=;
	b=KPM6vQjdIzor9D6y8WVXzamQaBkOr+JGwiL1AGxy0NmFmTt3WpsJlWq0xmmjT06QVd7qPc
	nUCWRSX6Dg0gfa1XBgNTNy1FuOc3GJRf9OPp3SBqx6cOhvaD3ow+CqFqk4NI1PiRWOhXPU
	jiFTitO0o6X5ucTb4aiCdvvMB/YSMuw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aQuSPNO0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iRafJqMl;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760700387; a=rsa-sha256;
	cv=pass;
	b=xoMkUjgxr9X4ISj/EFuV8GPQqkBoshKiAXbA9z4g4VAJVMmWKLVhdrrXBDtoUK2pdZ4rov
	j60KcaBCqPRh6a45uMHfmy/HEXz0ItrjVZG+ywUiyNi96YR7uDwNXzm2kNKGtzqAw9G0AA
	bgNvdsWtMvMs5FyddqLORoQovvtMbCc=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HAgGKG017824;
	Fri, 17 Oct 2025 11:26:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9GHsqEPWALDFTMiH4Z
	D4M9c+xc1K/ddjKVZEnXkYiQo=; b=aQuSPNO0c5uTX/rZwL1XBR41UKPebGjyzU
	1SoYwTHatjlCHtGpm2nML63ozlgWwozmFgxZabojD0WfIFeBUDCElO1P7pGdlWBH
	7GGASDO6FRwlfU4VX7htVDxbjA1tASsZipU+cMxzPJCuhJIJG8/aqUreWt8dizXg
	BeE2V9Lcw0shMDiP+GyG+WmOSUWSCrhmscBEbavcGMoy6djSgyssm92PIJBoAJ7g
	GQJj84KxFEuKlJyUBK6/JZ5qz6xs/odT/rDPgTEkdqsuldTbPlqvRd8DM9OVVotG
	6ZWmPHiiOH7uLQ8cNr+iwAAL6trqbQiZMRovVdiY6/zOyPkkU/qw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdncaq70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 11:26:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59HA09sb018050;
	Fri, 17 Oct 2025 11:26:18 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012035.outbound.protection.outlook.com [40.93.195.35])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpcq73t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 11:26:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cIBdsICrD0esMBaRcjyGAVKi42y0/ChZxJghYBH46a106413hbXy7mP/J9RYtPhrirZjCdRd1DIQR8wl3kbkVvVveaz9B6KgnrQQ0AlnvH1vdy+Drv6EgfdrV02deOncMpmHRockq5+QrMDFu/5G3a4J55+SyIvInby4BS7VdFA/h+DsPPPiHXZrbDCBQYB6WSxJPJISALh7jhYDtrvQpvz+o5SZrzdDFzC86od2awKLiFfpJy8rEuU9lHNKNNwGPRnR10s1aqL0AhQckN+DKR0i9Qb4ZoyvQfnL14TQBqmmELLFpTJ1xWDYbIiWpkPKCVcUp1JHqZWmf+14K94pvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9GHsqEPWALDFTMiH4ZD4M9c+xc1K/ddjKVZEnXkYiQo=;
 b=NIEzUGX/MD+i9o+NQp9LqKdZRaGVoXQYUnUZvJT5ji7kjNHzWQhJxP/XKgcv8lWj7cITavPP993Lq3nxvrRTDzPw8qoqV4pA5rQY7Oe/e3CHZ/zruPUmW8aCynca20Q8FO8gAUpxsVLgHGiZ1kxUtlaFFnAxfOcRsobbbPD4yC4BrANCbNVDUw/WVIWA31oYaxxuKkzcuk9Qr6Co/VA8u9OGsiH0FlpxRrjRiL16NFGUmnWI90yfHkJ6pWylbwTRTweU4y5kVsa3N774w1lShTJ8IMZOA99ewnPXwrkPJNcPqgjtnYe3SnpOfGvdaZ10Fc2eCA9koRKAUDymUvTZ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9GHsqEPWALDFTMiH4ZD4M9c+xc1K/ddjKVZEnXkYiQo=;
 b=iRafJqMladwhLx0vXlS1xOpO2xXjJsEaEv1j286tI/Tl28PT0K4i5stS1yPs6tn+EUpNUR+P9ypKzRa4/hRi++8jva9TcjzI8O7v4alDWnVfGfEP1BLRG4mBJK4is+EL16RUKDMSoQwG4K0CzMR8Y5bdfJItayXAj7lm9x6gcx4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB5197.namprd10.prod.outlook.com (2603:10b6:5:3ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Fri, 17 Oct
 2025 11:26:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 11:26:15 +0000
Date: Fri, 17 Oct 2025 12:26:12 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, ioworker0@gmail.com,
        David Hildenbrand <david@redhat.com>, Dev Jain <dev.jain@arm.com>,
        Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Harry Yoo <harry.yoo@oracle.com>, Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Barry Song <baohua@kernel.org>, Byungchul Park <byungchul@sk.com>,
        Gregory Price <gourry@gourry.net>,
        "Huang, Ying" <ying.huang@linux.alibaba.com>,
        Jann Horn <jannh@google.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
        Mariano Pache <npache@redhat.com>,
        Mathew Brost <matthew.brost@intel.com>, Peter Xu <peterx@redhat.com>,
        Rakie Kim <rakie.kim@sk.com>, Rik van Riel <riel@surriel.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Usama Arif <usamaarif642@gmail.com>, Vlastimil Babka <vbabka@suse.cz>,
        Yu Zhao <yuzhao@google.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.12.y 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss
 when remapping zero-filled mTHP subpage to shared zeropage
Message-ID: <1befec2b-e50d-44fa-8259-b46a1ef56416@lucifer.local>
References: <2025101627-shortage-author-7f5b@gregkh>
 <20251017085106.16330-1-lance.yang@linux.dev>
 <121d5933-16d9-4eb5-b2b5-2edff9b36c16@lucifer.local>
 <3390d129-e540-42f0-aada-0c8b6fe96f26@linux.dev>
 <384aa808-1893-4f44-9c76-96a21c1989d2@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <384aa808-1893-4f44-9c76-96a21c1989d2@linux.dev>
X-ClientProxiedBy: LO4P265CA0038.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB5197:EE_
X-MS-Office365-Filtering-Correlation-Id: 105bac4c-9492-4861-7932-08de0d6ffbe6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2WVXc4OmUOn7gRWxQ7jrH8lQmoogLR+92FAudl2fP84fqexsiHMgMP/8osA5?=
 =?us-ascii?Q?tktEKweX4w7pTAVy2NKBWfZHOZ5a0Xy+azg5DBynsVR56JCtCVzygbThcjQq?=
 =?us-ascii?Q?ynrgif3uH9aDKn3Q3ssJ5dYvK11XcY6GqfWLy4BAsxTgjBobaVZF9LfnyRfm?=
 =?us-ascii?Q?cm3Tqyx0LyveJ9czrdlLCAA+bJHi4ZhRdfnbNO9CRJI5EeexqFXk0Qfkug9q?=
 =?us-ascii?Q?UmcKsscKIkOMNNqP6MNI5Jyvu5vhcgnYT5PooqxoPziIzjZA1BQoSgOxhHSe?=
 =?us-ascii?Q?8rZdj3hs0VJvfRaje+RxY4ku5ov0x0ruOsPasnpfyTssO4MilYOxFdS5Pcow?=
 =?us-ascii?Q?0h8TyX/+KwifCWkseifwkNrw8R8Ve9WhrEaTb95f4Oh9zFTw7/3SPcTt959K?=
 =?us-ascii?Q?nYwIeG9X3apmHkN82hZYydIFod8er98olh6YUTwxTnDLa7hNe+m0OrTS9ydh?=
 =?us-ascii?Q?e9miFwKctA3AU3tnbOTAq4e10uhBXc+FdzToG9p3O/+cRa2MGorIDlyg7C/q?=
 =?us-ascii?Q?m3ruWMxYmYxLviSDP9Dr05+go+LqEvnIjORwDtubAo/HSUHXk7h5bHAN0Cfm?=
 =?us-ascii?Q?uL+Z/fwh+3PnQy9G98gRJ34hYDvJeVuHxQfrqaA22f3OT8xIaQgAKl3YQ0PS?=
 =?us-ascii?Q?nzCUYTbQ6U5RZciNIPSUTGa9VWl9xdZVN3wZ3liaAmopYyIW7gSvrY1FjFBF?=
 =?us-ascii?Q?HAPwjOCca3hAi3NvFb3Y0cN521f7z69M20wIc2TG4CtAW/MnWCWG/b6m2KvA?=
 =?us-ascii?Q?ndb+NY7RPEUyjSkxmII0AnTfCkzUvTjwWVFzhZ6SYPfOrEjzMVXtwA8Gv8mo?=
 =?us-ascii?Q?9+uLa/w43TxynDThkJakAfNSPoaQY0HGoU1NJD8E0plJ8lskX7OjOdI2/YI2?=
 =?us-ascii?Q?A6uVElok3bBza7pUdLrp6dIRkr86Phckp4/ClsB1+IZnnkksVG2scmYHZlDU?=
 =?us-ascii?Q?3PvcAqubensNpWt8nBp0PIoiORJmI7Uk3N0gts7BIlv69CnK66OvaHVnN/dH?=
 =?us-ascii?Q?UpiQqnx+o+z5R2o/7LK+spzhioVa4tgX6qmsV/ilhIC7iIMUEnyoNapbvG+L?=
 =?us-ascii?Q?p7rBJaHHCKKhQadi7Z6FnmCjsba14RErWzjd/8mGoM6QUIbr8omu2j7LKotW?=
 =?us-ascii?Q?DBMFYthhktTV+gE8cdkwM7VIQTAz19oni4wlSkaSs7oZCUy+fN9tg/nzvK1h?=
 =?us-ascii?Q?A4cLa7NddmAoGJndf2khRolMH/VhRTIxSVzgCZnDcdMST1dVX7SvQ8OC6rkG?=
 =?us-ascii?Q?vbGaX8Gg8+/9y3t/ykq83y4e6NexprFaqMXcPgmGCQmI4FAupkH4hFMvMj9/?=
 =?us-ascii?Q?AjgP8PEcPVqRUwA/VMflmq1NTL7LJiSnxMWIPNEQfDwTnyW4kOsKYpXoiBIT?=
 =?us-ascii?Q?/djeq06DWnTtC0WQzWfISLvGj7VQPIOlkvgRp0QxTycbIOr3GSt+eoHpVrgN?=
 =?us-ascii?Q?MFyyVsSu3UoDsS7Isz9dkoXNvPt1Ja0X?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q6YtmHhN+VKKSKVZLaX9Gd50R1hqx9oCM/HigM7SpEYc4lXsOiPKVUZ//PZi?=
 =?us-ascii?Q?9Nq0gSa6ZAByq8hZ9ciDBVdc8IFj4awRuYsup8TmwXtNJQnUWwQtzTBTkNEO?=
 =?us-ascii?Q?kLfCnu75+tu534Zk9e2h+2wG6x7W9NT5QEklxSfctvvn0VxSNhmf9t35UxI8?=
 =?us-ascii?Q?+88+5W4LIloC2Cr8UNW/BzwX6dI6gYEpy3PGXDikH0KfDCvjzTbXCCBTBlLu?=
 =?us-ascii?Q?Jrst5Qdaph/oNlR/qhsTUHIOuqNXzrVmpqFmSyDV3Ejjb9PvvUAa/E+ZJV+u?=
 =?us-ascii?Q?thf+LWJGjUtfVnMOJfoVI3ICQW8X+7BR+pKZFF1sSFsZyUlBEngCUtEFevTy?=
 =?us-ascii?Q?y9/48l5RsdjRtHD5m903VjweYy9fXgFYaB/58zt34HW2vZEsOXuEwzXi2f27?=
 =?us-ascii?Q?k1gPtdBvkMQIdwFTvoaPS+eszAts9VCYPy5IyNd355C4WKd31j9QuvkpnKjm?=
 =?us-ascii?Q?ACb5U/4kq1AuL9uJaeeqoU5khzQOi/f3Ra8s9e/YTXQYVEYclUcLhQSfh3Rm?=
 =?us-ascii?Q?g7AZVYFSUKIoLOKxjpsW9KXZHR71nnYCWOmvSkuJ2ImDC3H/5IziHkQWk9YR?=
 =?us-ascii?Q?vGEJ+lpmzg3tsEKbURjZhrQKi88cP1NKfw1D//YLgU8U4dwtP+RjjlFNlgP+?=
 =?us-ascii?Q?5ciVfKX6GFf2muEYfr/qWd+y0B8GzdpM5b8WvATX2X+tV2tgs7e+PsiFxnjB?=
 =?us-ascii?Q?hoZ/hSra0xDXIPIvk4WjuMcfBt90f8OAjhHBtWGiciVOPPtGSkql6VSaxt68?=
 =?us-ascii?Q?UKDpXU2ZhVo+ngBqkH7Yq4tivYbsriLgI2FlbBQfXb7ktl46X5dSVN7J604H?=
 =?us-ascii?Q?nGtAKNBE7xxZQAZUBe3QeNbvIwspKu2nodvJHVbpcfOmcad9zLtmBmwIp7GC?=
 =?us-ascii?Q?JV+81I9xTu+vbYlBsx0YtiUh/PQKR+Kdf1eW3BepxV2qaww/JaOHcgNH8PIn?=
 =?us-ascii?Q?NSd3mXK6kVHy39+4C0ZQho+sQ3gVdaDfjC0LKnPOT/9NmNkH7uBF6YUPWEZQ?=
 =?us-ascii?Q?v+YsvxVAbbN02jr/XQ3qn+VVLL90tAPQgc7eXZWaCilCtbxhgwl1Ommz0zAS?=
 =?us-ascii?Q?A42EGOYEa/BTUMsAeP11m35eG0y5L3bD+u1NWxok0oU4Kw9bVOHE6nemDAXj?=
 =?us-ascii?Q?EJyKoxooN34gqjPmWPlyg3Qn6qF3NJMQ6/lGhdABVsZxj+Mqmfh5QsVGkU1N?=
 =?us-ascii?Q?Z/1faQRe1IQlmJjkprlQ6DXdwA0ZQl88NmoEqBM2WIagRyekHnqvyrlouVrd?=
 =?us-ascii?Q?W7QlOfIpbmndj4UJ/amysP2yk7lYH2rsMwLk273NzlqSG9cGFqSgF1kx3aau?=
 =?us-ascii?Q?K0xxBsz3i9+Y2GvGoMK11xImsByazm81f4R9K0GXpbqiu0OeBGKR1gskjkaW?=
 =?us-ascii?Q?lvTyIXbU8VX+JFGZZ8oS66d8lfVxMcbhQVOKjhmcCf5eM+4tKlAHy+S1hYMy?=
 =?us-ascii?Q?Ms30wcQd6cDc1mB/GFzXePS3uDqNR4kz/fY/+khzBszmVh9CP9mxBC8Xl4o9?=
 =?us-ascii?Q?m9gj1v33a2wU9yHPoHf+FGCqO92MXw9hRBTkyUyB1NWdVYIYf6FuaxqK58HC?=
 =?us-ascii?Q?peDWICrUsuloLm0zQ0jeKRiBeEHr12/AFQNz8Ugl/Ro9fsMstdA/zBtc3FC4?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hvqGUXnlLf2C8VpovruvSuBIEyePtLu2ovf+KiA0JklhBMucLVeAy4GOcOYwTYNXlnhN3AI58IujhGplMq7UAeSRNrA03iTteIYybvR7ZvBTY7yxrGa78CP92axhmVtGVHfNW73qUhFbOaMwcFyw6Gi0r0CFJz0wn/xOeaJgS66eOFapjZf1oMI4xqa1PE/GHMu0rsk/M3sP7ESjGNcQpYTdxcoUr13Husd2cFJtnpaAObpLxa1CNlyAk/gfDqxElP4U5kDVNUNi5PL9VhlI50TJSG8/jpbXMoI7YZ6L0c42H2BhafH1bPuOFHLC1wd7Xt+GMac0JJZtwqw63yP4k9WkOaKf7m9G3+dpRK+vhdfXe7IHNWPYdhFkDE21WNDIlw+Te9RerORkN0JvGOfR1HLyzOnFyC2Uf0L/8dFyu0oBFS1bqVDgW0zPgGTWZIlEjpz6JfeFLYLuao6yiFknMg8qstv+xF+t8on/TyF6/S4tjjePFXwP56iQAUy5/Q4D4dcXy+Gz3V1MfS0YFk3h7GjvXRnGtQTXLMhr5XfL2Zry/0y+k0er7Un4JI/6/yirnD7Hcy6fKc/x2Zy+B5F9ok83EkTVltfc+IJF4w3Ceqw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 105bac4c-9492-4861-7932-08de0d6ffbe6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 11:26:15.2527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fx2XgiU06bbqA6NhqrmExe06otdnk++aJLVeRllxAfxVnIgu5P0KPjs6Tdx9KLkOsGn+3iADfxWr6wGheM1UCQRZ7JPWJhFF2qjI8SuyQQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5197
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNiBTYWx0ZWRfX9FA7+qHxs/0U
 +A1KHzB4itXIqsXjOlEM57nDBrw3LrKz4rGyvtl7eyJ8gZJq+1j54R9uwKpQroF6XmlduQeQqsd
 SQYofM6+JBjg+N1pESPoDhorhFSvnlTi4omhV/QGlMTW2fMUp4UpaV9pnlgpZLu56ZjsDTzGIyT
 hpLnhCVq+cKQgLUAZpn/Ust+RBl8OUpAP2diDpNDgFV7Pd0V04fe8R66VK/PGAhUNk5DoUggNWV
 r9MPyhTSGKRovD1DnvoLmIdH9HLTYxrJLKxerqLxClssDrusgBkQ3/uZvP60FAvENLOGyI+LHfj
 PxQhTakUVMqSRY1w4bz7o8ERUa4M4/soZfiIncrAndgt2Mq9GjiyM0F2PZCRaSZrVJV2KeWhef5
 irXpZy/27S/ezjgS5eKSIlCww6vgOw==
X-Proofpoint-GUID: FSf_mtq9g7xaJNx7J5LzUf7nBk-8vOXV
X-Authority-Analysis: v=2.4 cv=ReCdyltv c=1 sm=1 tr=0 ts=68f227db cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8 a=Ikd4Dj_1AAAA:8
 a=yPCof4ZbAAAA:8 a=9q1Ckl2YsdIMhH5BkiMA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22
 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-ORIG-GUID: FSf_mtq9g7xaJNx7J5LzUf7nBk-8vOXV
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2DCB780007
X-Stat-Signature: pxgcycx34ya4uhmyq1a6hd1u89kj4syj
X-Rspam-User: 
X-HE-Tag: 1760700386-568054
X-HE-Meta: U2FsdGVkX18Xy4nwYAke57TbzSm5NhGLkFc3wPWxwsk5qcz6vYPWdkQsB3olFCMfGH9mOjny2vT//RCgedj9B86eg3cy25CenTMuYDV9RWN2x6kMwBQtobN/MztTdSmPgwBWHr9te2OJ95lkkFQlhWqdi9t+sdumQn5h4Npik77WfaGEc7zJcPCL5jedG/kJpQevBWCefAlVefxfWYfxV8I+EshjvCv4kjreJqUovKgDcLRsMjjSmur/54Aj9JFtRkjPT5+F4PbrL9Yv+cnKFzSptelnWOybJTEBek13XUB61AvdX3PtQlr36BVc4k9ZJ91SH6mHjghJWKBu1Drr3b/KkVHwtuamcKgdEYVxUqZRSQOMFVnGqAAc22hq0KQkTxrz3lURc8LFGuv9afNfukoxPs+qiiJF4xiosUL8yNiQ/pkmT2CUJ0t257mODU3qhbJH7rTcoRYlmgUzd6LLtz1BDgR3EV988XyDoImIdG9bbVYGDNQ4BV2UjnBKpHUAM+ZsdFBy9F65KHasfKnqE89tmCIzwytmVJmqfVebTAu/NZU/nHpBMTtlmEXnaFdBJCwfaCMoX7BQ/vWdf5xsnpDGfkly6DuWb82BYbMjJTmAANP6AvhdhNIoc20Ll/Z14rkpSBgSeGtEaJb6qhSov5T9njUUIqGT3eB5Fh5g3S3YQ6QekiFQ0qF0vq2q/DIAAtpg2xvM4mqYtsxajyvYfRKm8tMm0CfQTnIdqRc+U+t7kkzJtXD0R2JU38tr2FVXSiiGk+KG/h0o0R3lgZlDDothVajyfkGNiGqHK76yXC+F423KAONRL8pWrMVdmp+hrxAzln1zIkTZWMKBlyMJKlnhpHbVkbvHo/I2DyZqpl1qCmmxYRNtOM7m8axerpHILlEnDHiG0HU6rYfxuFwGjlV5OftyM2FTV9yDLcwN6yoiqAdQ6DEAsYx9UjXa4GiJjIS7J+5aCmd6R35h8VV
 fV0r8hHx
 RPFwIntVhDvekS6dC5bNHIO8N709zo1vJSYN27l49ZNWprn2zt59K4UnZaXr5EFSScHtQTFzYVDhUSJW7hLxpNYtjDu+qTSH4pFYYXfZWEnkFoLt70asCD7USCa1fK6oUcIFqTIPnyM7rXrSWmu23mViFUGfsGGUV+93cQ7R/94B/51NbFlBBjlOWPLKXdQM4vSMZEm4Biv0hXYFkMadck+voAhkV+sf1NvX79mbgIQPVHUKovJNKYcFRWmpljlgJsKbA2oSy3wqzq2Z0wRC7P2yFa0qG7rooF7SLgmK7aBb6mtVnjGN2kOeUUvrBKg+9WELBx9mssGV+z10pLErFo1gOyQ87MuNmxp+BDFJDlvcFZdFwN307itbS2xaM5cBFS4tWrsnXkEGt7URRWA2Zz5y/z6AICTEiSQF8KVjIZkm+UZOOHIk/Br5dMwuw/KBfPb2+OckgClSaQU5oUyV/9+y414n7W01qBjibVy2jDylsz4EMTJP0ODzh5sHJ73HhfJiaUx0GQ+RSR1VK12+aTQ6aW5j9bMzzxKbzO+HlpcLV0YHwZEFFkFqODjeQ18YUg8+isopOhyBZC35U3gyu1DsiS1foX0iO0NXMJ2ZSNhhSJzy3agTgEu4NA+kB8SWBRs/I/4Aj8LFkubHrLEb79E6EF+mXRlLv+H3evmQr3gd1vbUQeEnMU9i1bMwqxENdhNQGnrcyREhtlelTSrApwSjyqA9uCA9+oaFuR0Y9wAlclDC86sQpIdK5MiYgbwwrBk1Opj8onOTNN6vp/lAVRopz4ReV7cTj//ccV8r5JW8Z5/1GI8etrjRkVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 07:14:32PM +0800, Lance Yang wrote:
>
>
> On 2025/10/17 18:25, Lance Yang wrote:
> >
> >
> > On 2025/10/17 17:52, Lorenzo Stoakes wrote:
> > > On Fri, Oct 17, 2025 at 04:51:06PM +0800, Lance Yang wrote:
> > > > From: Lance Yang <lance.yang@linux.dev>
> > > >
> > > > When splitting an mTHP and replacing a zero-filled subpage with
> > > > the shared
> > > > zeropage, try_to_map_unused_to_zeropage() currently drops several
> > > > important PTE bits.
> > > >
> > > > For userspace tools like CRIU, which rely on the soft-dirty
> > > > mechanism for
> > > > incremental snapshots, losing the soft-dirty bit means modified
> > > > pages are
> > > > missed, leading to inconsistent memory state after restore.
> > > >
> > > > As pointed out by David, the more critical uffd-wp bit is also dropped.
> > > > This breaks the userfaultfd write-protection mechanism, causing
> > > > writes to
> > > > be silently missed by monitoring applications, which can lead to data
> > > > corruption.
> > > >
> > > > Preserve both the soft-dirty and uffd-wp bits from the old PTE when
> > > > creating the new zeropage mapping to ensure they are correctly tracked.
> > > >
> > > > Link: https://lkml.kernel.org/r/20250930081040.80926-1-
> > > > lance.yang@linux.dev
> > > > Fixes: b1f202060afe ("mm: remap unused subpages to shared
> > > > zeropage when splitting isolated thp")
> > > > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > > > Suggested-by: David Hildenbrand <david@redhat.com>
> > > > Suggested-by: Dev Jain <dev.jain@arm.com>
> > > > Acked-by: David Hildenbrand <david@redhat.com>
> > > > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > > > Acked-by: Zi Yan <ziy@nvidia.com>
> > > > Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > > Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> > >
> > > You're missing my R-b...
> >
> > Sorry, I missed it! I just cherry-picked the commit from
> > upstream and didn't notice ...
> >
> > Hopefully Greg can add your Reviewed-by when applying.
>
> Looking at the timeline again, the fix was actually merged
> upstream before your review arrived, so the commit I
> cherry-picked never had your tag to begin with :(
>
> Still hoping Greg can add it!
>

No, I don't want that in that case it'd be odd unless I had separately reviewed
the backport.

I was just unaware this had been taken during the merge window.

