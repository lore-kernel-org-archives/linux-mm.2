Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13268CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74028E002B; Mon, 17 Nov 2025 12:35:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4AFC8E0002; Mon, 17 Nov 2025 12:35:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC57A8E002B; Mon, 17 Nov 2025 12:35:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B62548E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:35:16 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 806FB1DFE6B
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:35:16 +0000 (UTC)
X-FDA: 84120800232.29.49FA548
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1BF3D160014
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:35:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l8CCl+M+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=StTb543W;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763400913; a=rsa-sha256;
	cv=pass;
	b=XwiSi5KbdyRDrif6iRTuNMSd+TVRjbG6LXYvJvyA9v+58Hd3YniLYLhrH949BJiFLle3uL
	/OkmC+sjT+F3+0JQ/z6Xw/PxBl4iawDEgA8bXizIjHTS1mtjWf7sIrH7TRwvzwnjsdex8p
	naca74lz2hGWUIUeErpBa3znd19vxa4=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l8CCl+M+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=StTb543W;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763400913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UsRCrYbsHeYq0rdc52kDKO+tL6eedFghuvT9oyin8r0=;
	b=qTjCARdya4awmIRs/6j+pNR9mPjiwzYNMjf98oBjy0GLWAw1G5GsZCudk4UTRUnL86u+/6
	0Hns8SwOK6x0w97S+ghcIuHNGOoLEOM57yG4gHELtWB1vGYXF220tVJYpnPVR00QjJ7aVg
	5gyKohQfxQQwN6PbsxUiwHSpbMgTXl4=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHC8Fa9011802;
	Mon, 17 Nov 2025 17:34:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UsRCrYbsHeYq0rdc52kDKO+tL6eedFghuvT9oyin8r0=; b=
	l8CCl+M+6nbCrh5uazgyd/QneuTVH/j6Lb4h8gGbYngillbvFjU1N5KKLubO5APw
	2ZreTsMwfBes6PIoB8giHrFT9cduRrklswIAmDrYIt2rp/LLnm2du46v1gpmqWiG
	A8iqRxbrrszdBVfIdWI2PVfgU13nFFA2hfF0pM9QravFmXNTMhsYikqfnUUQ+j7q
	YaP3cWANiBRwIYF2MRG1e/Mu5CZtJ8etg7JWhN6LK8+D3fTUcBSxRWmgMz4xFcty
	hQLzrSkXdVzoyYARow2dT7pRi1KdR/rrN1S46juGgeN/ktRgCAH/fx/YXMREa5eh
	pQ1mhTEE1gQ1w68wICfj1Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej9030sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 17:34:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHHPvU7004274;
	Mon, 17 Nov 2025 17:34:54 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012007.outbound.protection.outlook.com [40.93.195.7])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy7qsgg-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 17:34:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aPsrzzt+XjgyBT6/EbUj0ZNuoukS0T/PybSSfIXYO8yi7W36s6dknj44HcaxdaOe07kiC0T6cuvfE8bh5iEMShINfT5lUqG2Pp8RGlcpz9Tq/jW19wXNb55vniy9Frf7TkYcSAmxRbzzrOxDAdTUPQt+mgLatFdCg1ML3IPNMMGySFcOR2Byf0gFr5Jeec79A55lWRoAg+tLqvRNxVwlykNleJu2hR9iI1zz3y1v29NzGGjATwb+l7E87BrhF9MYonZtl41aUiO9Y/KlTTe/C4ok/EOjhAge2H0u/ffG8YWfM4KvtqeCX7ldY7EwObO7rROumT8qpETngBLv2m46OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UsRCrYbsHeYq0rdc52kDKO+tL6eedFghuvT9oyin8r0=;
 b=yJKkmJMWP+j1eGU7i7H5edTgC/c+p+aNrQLjqYFKiWcenP7vt7K7eVAOWklJvqYxeBsyfoNYNaj7CuEtY3y4+wuuOprFRUmG2AII8ySU4TDdsQ1U1q8N/2jWoqKFkFrJPDDqbVvI/4A3LtRVJPLHPt06H2F/gwY+HIdQRjzOm+CEKP1FnU9OCWlyUJdMaMXZWcdX4PLvOQJO+nkJSB8ZDLeBuRby+HbTjaru8gej5cIQmjdjI+I41J8gx1TxPfagm+SiE8EdZ9tibIW6u8btmezOaUuHabcgYaDwuJzH+2X4ePul1sOu3iBGj7W/6p/f7HpH13TSrzgqLnS3r+9oiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsRCrYbsHeYq0rdc52kDKO+tL6eedFghuvT9oyin8r0=;
 b=StTb543WKX/yWB7scrqye0D9/Tof3GgKvDXnc4VlblA5LSOr83v+ZAAI4OtRtr7OhqQFUjvy6Qs/YkpIUcKVVJ2PX2mBTHRYCu/8EKHU8lR7feSMwLbANCigveWETgi0YJ7RZSyctw9PP/X71UjTFpouyFzzgR8Bm2gMeyzDUj0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7944.namprd10.prod.outlook.com (2603:10b6:408:208::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Mon, 17 Nov
 2025 17:34:48 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 17:34:48 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm: propagate VM_SOFTDIRTY on merge
Date: Mon, 17 Nov 2025 17:33:38 +0000
Message-ID: <955478b5170715c895d1ef3b7f68e0cd77f76868.1763399675.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1763399675.git.lorenzo.stoakes@oracle.com>
References: <cover.1763399675.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0223.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7944:EE_
X-MS-Office365-Filtering-Correlation-Id: 03879d80-23bc-4a77-5f15-08de25ff9b0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?98DDmldyeuDa4GNr31mofAUvqkWvC+HSpsm56qylxoMkm4PGRkOK8jLqwt4D?=
 =?us-ascii?Q?jLdPVP2+gZePypE2ttoLoYJW6QHd+e6C0V0gR5iZII39HmibQcimEqWXzmCm?=
 =?us-ascii?Q?/6EkivTnYj7d1iJ/VGAluQtoz3/J3/Q5ShPkvuR+XEIpnzEV+uVhGbxtQpCr?=
 =?us-ascii?Q?scFAC4fZHNzqMjpBiTp8zc5urpOmIfNzb1CmBQDuCb80rEcgM9QkKGqcqJx1?=
 =?us-ascii?Q?h9dQBaee8WXk2stjT9R8FEtl8E22oHlgUN8Uw7dJlQWhz9Pz2hMPN1A6Va9f?=
 =?us-ascii?Q?+Mz5em/lwRsP2ltngIHMZjqMdkT/9yCgUCx9XbwVzhNW0GBvZb+o1iPImf0T?=
 =?us-ascii?Q?AG8cvKFyeiwMQc1o12kCgkGqBNqw7yvJZZ7mSDNbCR3VfXQY0GE2EazJGy9Q?=
 =?us-ascii?Q?U6YyZvIJ/gOAnEYvIIYBjT46IhYVHIYI7qOVpgYmviZ0/63uFawnGCBhqVbK?=
 =?us-ascii?Q?Wc5eplJEVArgYiCtF7jr/mptivycWGvRnaIp7GiAJo1c9woPED94O4rDAuY7?=
 =?us-ascii?Q?3MjNXuSBf8heF8KrW7CeYRsKWJWzlhH7xhhWcWgiIU7zczDq7ycwXbEEOmiT?=
 =?us-ascii?Q?Ix1A5eMTq2WbbHqNL5Yy2GOCpRSRjKbceWhlE49gH5MrPngtrxCweVBR5RYs?=
 =?us-ascii?Q?fSx9C+iTvbKhsE72YytzgCa8jqyqJRYV99aUnVTPzoS6jzwtjL7aX3Qm9AiC?=
 =?us-ascii?Q?uG4Dtj+KfWpast3VOO5/Z9O8gYqBKVOQ4T0zQ5d/r01Krbl8FnKyQ4QGBscw?=
 =?us-ascii?Q?6VF9UxCk1gUV/aQ5hHvnTYPmZ7XCfhkdjZGRI0DmH7OSor88RLM7yXxw6vfD?=
 =?us-ascii?Q?p6UiLt7LtHDrpajxHDKLR1TDhHdsHfhBPkL3LqVMPXnBRAjbSts9s6F3E3aU?=
 =?us-ascii?Q?GxYGG1fX4RGu/Eion14yhb5uKQnqtoGMlyCe5qI6UFyrD30begfGlBFCCDLV?=
 =?us-ascii?Q?HYzPorDbJO0WXFWCgNK0sZvnO4AVKaSlOgVKrfWJZpWv+8EEIXaUdfBlIbak?=
 =?us-ascii?Q?WPRbUuJreFlEqTlcyh25LBhzcbnR88sOGnRYxq3/PwGm74N6Y+OGAheLj1tz?=
 =?us-ascii?Q?TfI9+J9cQ1/eDbFx9usxEGbwEJc2MYI/rY96aK++n+37YzA5IrzPbe7b4PfK?=
 =?us-ascii?Q?SWVK/vnbPH3QmNnyFpuf2U06ry7SFJTGCWNUuODyfoPZ4TkrTeY3yA+o3XvG?=
 =?us-ascii?Q?aT632cc3Z9J/SgH3SfNP9vcNawjbTv5+4tejarSDdYJN7thlHW1w+f1n9P4o?=
 =?us-ascii?Q?H2AxwWoBE8xwMTf9sHXRmtnG0Hy1YdDAyxFlicETXi+7rERMFMBTQIEDcOX0?=
 =?us-ascii?Q?TwfKzUTzsDuTr6di6ApHSiJXMNCoMs/eHHmJaiYv2Qw035OXXmE1Sw45PDol?=
 =?us-ascii?Q?Tz2+EWEMVHb0jo8LXtBjy8GKpnGsDMlb3Se6KQk9nM7godiS792QPnIZ1L+/?=
 =?us-ascii?Q?CQSgmqK0rSEMOwhbu4tQMl5dSSnQheOc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nWcW7wmgbWshyez9ihleVd+jOcQQKWjlN3YJopP/jNCMOINyb8t6O4PKblIE?=
 =?us-ascii?Q?b7Ee72M7Hqzm6XXBVgHdQXZAQqpFTlb3TbHlmgR8Qv5nHtc5F6HD3Zh3UGvW?=
 =?us-ascii?Q?1urcnlGv4EIN7wKTtl7VbA+QBKmw87W7gp4l0otIcyo9yRTSTJ9MNurr6KAB?=
 =?us-ascii?Q?JxP2kmyxzIq20397sZQ3G2iLRvM2uI5qNhs1q2AXmEDSJ/bMjNT5GTx2Du1u?=
 =?us-ascii?Q?fjebLpyIp/bbDel2uUwqmiPaKHMJScqU6VsHkpaTchAC/ngate5dd89Mvknz?=
 =?us-ascii?Q?P/5AmOjSYUM9riyfPb0NAvpRIg99vccEck41Blm+WRhOK9l40XOqcHX3WZ12?=
 =?us-ascii?Q?6IG3V1fV20enAvG3O+EAIP+E+QJ6kF1rx1hXfnqKIIwIWE6QyDHzE72w/Zj1?=
 =?us-ascii?Q?l/czU9Wwg9R5KazAbJXj04EL7okdUy0dtbUiS5kmjhkBQaQSite+RexkUSWU?=
 =?us-ascii?Q?XStaG8/ig1hRfSHahyz0rB80sCxIFZ/0wOSG7AvSYAM9vTeeheibyvM1a9FS?=
 =?us-ascii?Q?PdH7Ib1bZZveBbavA3w8JFqnuWfK1fV4aa9yUFtVeha5KlJyCtWr08SPMfcu?=
 =?us-ascii?Q?WGXRkXuJdN9G7nkmRG80wwoJkLyT2do83smb1fwD23RtqOwP1xrhwnIJP+pI?=
 =?us-ascii?Q?AMhsiIAG53XIr+8snStB/QReDIq2BYsI+60SUoTrsPQtM5vGw1STGoy+9KQd?=
 =?us-ascii?Q?UI4Vtgl9kOaX/J/47pIdYpGLKjIVJ+6kKljZX+qS7yfA0dKQZbRg3tf6fL+p?=
 =?us-ascii?Q?IUb/YrBcFpl4TiKTkMNWsoL74d8+XhXpa5wDX27DgCobOIf1QHOiHndvaVEW?=
 =?us-ascii?Q?Hspwc6+3mavGMXN9FBLzoH1DH5LB8Qip1TuAcd6RcKmA/1vOXrxlyY4KQEA9?=
 =?us-ascii?Q?ibUlCI4ufG4JY+60gr5pSZl6uo6TgAN0PqqE9eBtMae3hAySZdaXL3qsHV+/?=
 =?us-ascii?Q?O2KdpXbgmvuwiV4TYm0vRBhCGnRTwlWlD42jgpHfKfKohzhavUiJWbspwc+o?=
 =?us-ascii?Q?PkDqRCnmc/DWY+Bp/ZSBYO9lMufTEWP0Hao0gF6yBZYp9UW0vTIo8soIrhSI?=
 =?us-ascii?Q?Q07X0WT40kSWRIIFipQ/rFGxZOIXZ9vmX00tv1unL6EKsnBcideWLnUZnkbE?=
 =?us-ascii?Q?QTwoOxlwMXvhf3dI6moDf4O6+2i5/ks8yR37TmN23DXJrf7MOgesmh8jy9Ho?=
 =?us-ascii?Q?Pr1qST2XeMHjpyK7xxbRjXtcNKPwk/7yS2QqN6zv4HEISozK9DFay5hmqawT?=
 =?us-ascii?Q?HMs1pXZZQ6aYlIEZy0TMZ3TNAmfiUvCzyVIGBVDh3MOJTqQihuTFiNn2MLi9?=
 =?us-ascii?Q?jk+3m1Fgm8PYm5+E6Wz5h7gomnJObnxb/V6XyrA1GkB58lH1FU/v5523WQUb?=
 =?us-ascii?Q?aOg58Ov1yylQ0hTx4feQDlGtViQjgwgu/F1jKsxPSi/62uD6gpEQwS0Q2yoi?=
 =?us-ascii?Q?9wNfweJgHEiucayv57PowF4ubSzGUQd8wSImkQhDpVM3ABvicVYi7X6qfC+y?=
 =?us-ascii?Q?tg8Lt+KVfusoceKIxbhj+OgZpZJlhLAn1az++N2gNC5canjaVQK0LNuI74mN?=
 =?us-ascii?Q?yRNy4HoXovdd+PRfP/NmaV3RTUylqTKskbB/xOMe4IDpBqQFsHp4BICo83yC?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YavZyErKkRCdnt/wu1eBIyxIS4rwHyuypqN5u2DrwHTlnN4W4A22oAyKfX926zaHEhBKZPnhPH4ROBqCSBJCKrA5bJmrJ+XpoCBJYlG106XDuubp5kSoi4mfI8wnxsBSGYqvRRdLDh5Nwj7gKlinleSMO4XRQ7hXUqisBzbcTTAw244UFBzgF81tqII2vZctTu55wt3s+0ExxQH1zGi89rOJMQ5XosQe81NbSux8wFxtJ1WYc4YcX+8yrFJ12OmTCNGEbgQOFdEpUp6nQNQqFMLSLxBeYpnWANubQf28+E9TqMI9aS2IZp3JVHKQvARDmgQhx1P5eFVc+jcSKeIlIKQwCFp4ssIrWiUdfzBZ1SfshmNo0RIg2U/S5avbd+LRqnWUh8R2+ni41tccQg8LS3cGQSXF1wOIJFiLvxMJHXls/TiAIRzy93PXsOUBELQ+IU3xKmj8WYoBpmUoUFYehaPyJIReifzMYiTd2Iho9G7+PIW822dfSt+AwnJXgQutz7z1bc1Gk0GyX4D+ZyGTUqV1uw/JRWSMHm79QhjY80m8yTuqePJgQk7BAMbUwcK4KKqcFZi5PmBhZJ/Lz3uMoffg5p+bwCDublnXU+d9UhQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03879d80-23bc-4a77-5f15-08de25ff9b0b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 17:34:48.1870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W1iXNXtLA3j0YmUQsc9cco9NmSFpaKjY64yKTp7yG6UxcQhxhq79fHSZFZ53K5Ri7fObWRP9dOAU7m0h5FtquXHDeccm67iMaFQ4yGQ/ltw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7944
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511170149
X-Authority-Analysis: v=2.4 cv=OMAqHCaB c=1 sm=1 tr=0 ts=691b5cbf cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=Q1rnGyXiy6mPtF9hYIQA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: i4rBokD65iIEIR8M5c4ymK56BMeOLzUk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX5gdgRed5QcW8
 Askk0jpUy6jA5ylzcPUMDxtJp9ZtZbZ8zYwLaa59LaaklsuHJgX0qnnUthnmbz+SBT+Bbl9kMfd
 uh/c/9hIg0LqGKP5+NKSsUnh4HToD4AkfxB2wsGCa3klnqJY7sFE6l69vY4O25htjGQzuhU7mLj
 benGHm9NnOYH8NpKNkz00kF8UJLmHiR8hl+8p7E/AS2nnQbGxd0RPKNOHHwrlSXIBbvTvTgRz2O
 GpPt1l/MdT+TPBp0ehgl1RNUkj9ET+lo573Q+RiSZKyom0HcTUuRJNOdd5+vTj3byoRzBTp7lW9
 YIPjLAee+d0kyNPE33oIi1qDHAn+HZ/NahSYbEbFj0ET8gp0YJMhTch5bJFrKYO8E3luzvEiBC4
 8HT/VxNL+Yy5hEMgH4XyFpO0fPk1WA==
X-Proofpoint-GUID: i4rBokD65iIEIR8M5c4ymK56BMeOLzUk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1BF3D160014
X-Stat-Signature: f1531yzpfkfmy7743jxctop8ij6zrie3
X-HE-Tag: 1763400912-488629
X-HE-Meta: U2FsdGVkX1/ChbtdaRFFF6f6HLvF6BMV2Twt5Ck5LLhEH9bbhkO+VI/Yuf7NV4lR59wA3vCVfNyJReopjUJJ5Hijcj9eFWZWltgCeu00QbgDgbsUXGgh15M8FkcsNsTH4JjN7ikA0WON+BUBzeXnsffkGOaFxJ/NrWTlJJkH3xVg1bQmjUffNUugILt5Js9qjv2pZS+N4HoSHIbSuKo1jBXNy0UdP5q6A0dz1hACoev9nNG8PKdNBZjjs6NjT77IgJzqQVZBKzFfhBk9gC/wPBjU4NmjaZqfv7f8d3MFRmjukymXZIukhkhl8ekMDMHXKsplAkV8LuTIuIENJbkIrP5P9x91WSt91fifadJ0jSlNSTJgYX7rWlqTR1y7u18ZlAubR6SNopkjIMUp0ELP2xSj8L/fLMWoxrMEy/66Quwvb4qd4X0B+pihJ2ZXl8KyY/CcI/qxnIyqmOjeN8wjSYGBw9UyWwjKLQ9x8vCejcdPSPnWAAq8NxYWaeXtlesXO3Gjz1B5dwrcS06joLmiCZZ59ARSdTzhf+sk2xf6fPiRGJ8RuWJ0WZ+MA/GmHCwot1DPn/o5IFcmc+ml2xiRNmhWyLvFAKbhhuTdYFIBrGDukItScpLOJLXcXMVaCvG8ns3zDmjFqwUYmfosR0rIxX8pYotBdqkl+6OILKK3bMnYhaUERG4xEISvSiANcYqMJ5x30vTxJtV1gX6v1JQ0Pi5jOtQeEmmd0EjsvNmjqSqbbbMTBIfhoIU+JHW0eONtTS0wT2XKNuAWPUuN+erFsZoaPGeo/mNQxAN63C2i+wcUAXs/cvru2jr98c0CENmRR9w/wMhXCqO1ZVb2/AJthGSPnU5e4jf0/bBdSFnqSQTx2W6sN7CIf5qcsreuK30Kj7GO67Oilh9qNQX/yGqYg8A2Zz/9JQ4QG1Hl4JMabhUwc21o5b1h6uTEscmVfdTVe/Flf2LxWvm/Rqi0iZt
 BwSujied
 hnjBOdMXgYSep5BYjBr2EMRB/MXVQZXrX2C7+fQsPePeY6K5DA+HB0eGl6Pd0NPBMjz2XTGuUwOxCjE9wFARks43QwmJoOCMeTNGPenxcCGcOTJfIb3WeIcfx/s2qXcwDA92oqD4sy0M/pQ19AEzTB/B+ODqpPwkzpthMKNeuX6aiUEXNN7gHFw4QFyvlFoftM9wUPZyv59HulC+iYMlnkl0FW7vQtAiy32h59cJzUIUy4S96DHirUnEK4Clt4d4t36uQ3DqOQ4HWOWNFf8on1JURbdReq8AfTB+S0h1uAT6SCONpUphUqtO9l9x6vPy9jNyrKPqvXU3KP0eD8vDuNi+XfB0UOhMqzcvFO+gnvnF3g7EmADYSdXLcaQvVmqAe0EbASlZzfNZgNxUV+orq7odci5ORZRJKkZFBolHrmU5FHvdasX9Z2D4kp4CVq8fmQ9MOcaPKAt4roV9tHhZgqVcBQfKfuGinwfBpQydfIzz7jokXR1mzvN4Zf90CzB+MtGKRGSSmwI0D4pYpVhFGD9lwdjFaK/UDjpVZZq7+oMkTY+O1gpi3ME9dcnW9nFwS+C9EeVNHHkUOHrCpe894I4g5kO8B8WfNBumYdeC4llOyqEW7DMeaRNr4xQe/ozDyAZikq7ttew1w/HiyRLzSUgE9C7cFvpaMM53bvAhxAuLY1C4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
establishing a new VMA, or via merge) as implemented in __mmap_complete()
and do_brk_flags().

However, when performing a merge of existing mappings such as when
performing mprotect(), we may lose the VM_SOFTDIRTY flag.

This is because currently we simply ignore VM_SOFTDIRTY for the purposes
of merge, so one VMA may possess the flag and another not, and whichever
happens to be the target VMA will be the one upon which the merge is
performed which may or may not have VM_SOFTDIRTY set.

Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
which solves this issue.

Additionally update VMA userland tests to propagate changes.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
---
 include/linux/mm.h               | 23 +++++++++++------------
 tools/testing/vma/vma_internal.h | 23 +++++++++++------------
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 73fc90cbad94..057649b948f2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -532,29 +532,28 @@ extern unsigned int kobjsize(const void *objp);
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
+ *
  * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
  *                  mapped page tables may contain metadata not described by the
  *                  VMA and thus any merged VMA may also contain this metadata,
  *                  and thus we must make this flag sticky.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)

 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
- *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
- *                which should propagate to all VMAs, but the other does not,
- *                the merge should still proceed with the merge logic applying
- *                sticky flags to the final VMA.
+ * VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
+ *             which should propagate to all VMAs, but the other does not,
+ *             the merge should still proceed with the merge logic applying
+ *             sticky flags to the final VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY

 /*
  * Flags which should result in page tables being copied on fork. These are
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index bd6352a5f24d..10f46a95a73a 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -122,29 +122,28 @@ extern unsigned long dac_mmap_min_addr;
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
+ *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
+ *                  references cleared via /proc/$pid/clear_refs, any merged VMA
+ *                  should be considered soft-dirty also as it operates at a VMA
+ *                  granularity.
+ *
  * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
  *                  mapped page tables may contain metadata not described by the
  *                  VMA and thus any merged VMA may also contain this metadata,
  *                  and thus we must make this flag sticky.
  */
-#define VM_STICKY VM_MAYBE_GUARD
+#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)

 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- * VM_SOFTDIRTY - Should not prevent from VMA merging, if we match the flags but
- *                dirty bit -- the caller should mark merged VMA as dirty. If
- *                dirty bit won't be excluded from comparison, we increase
- *                pressure on the memory system forcing the kernel to generate
- *                new VMAs when old one could be extended instead.
- *
- *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
- *                which should propagate to all VMAs, but the other does not,
- *                the merge should still proceed with the merge logic applying
- *                sticky flags to the final VMA.
+ * VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
+ *             which should propagate to all VMAs, but the other does not,
+ *             the merge should still proceed with the merge logic applying
+ *             sticky flags to the final VMA.
  */
-#define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
+#define VM_IGNORE_MERGE VM_STICKY

 /*
  * Flags which should result in page tables being copied on fork. These are
--
2.51.0

