Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F06CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229478E006C; Mon,  1 Sep 2025 10:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2016A8E001A; Mon,  1 Sep 2025 10:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C89C8E006C; Mon,  1 Sep 2025 10:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ED56C8E001A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:41:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 952C0C08B4
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:41:27 +0000 (UTC)
X-FDA: 83840944614.23.D95DA7A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3024C180011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:41:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=afChcF88;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wMB6VDhp;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756737684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2TkoRrjDeUiwt99GNzEiBYtgbLqB4NHvG1ZgJmmjqs=;
	b=61GPIbvQpBW3/JWQAOrspQiOtMx/BEDFR7ESyuPHr5xLxxkyn4Uivrinr5fC2ciHNR4GuU
	k8GrqZB0Gp/FTLo7nxEioFwdjcQSS/NXlPoEHOvjlo1fat7DlMOy0hFStGjZtXVzenlF9E
	xXTRdVwVZ4mIOAMxQNeNkq5Zqn4qvbI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=afChcF88;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wMB6VDhp;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756737684; a=rsa-sha256;
	cv=pass;
	b=0mIVUSc4BbmApsSLl7965uUVCTRUu6oZO28bi9eaORhdt7zIolg8Z47rvpj/DCyVsQfOeA
	GvUZK5YnONirgzrawSY+FFV5Qj+7TI/DpGp5RlszlHrPHj0tp/O4Bj2aL4i5YCf/trWDL8
	901UKWV+30qy1RZljX3CeOUJHGYzJ2o=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5815gYuC001092;
	Mon, 1 Sep 2025 14:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=d2TkoRrjDeUiwt99GN
	zEiBYtgbLqB4NHvG1ZgJmmjqs=; b=afChcF88DtaZ+xj67vRPNnltCphV6ToPEg
	KJHzLN0zWyHGMnLpfUtoXR87XukJM0V86Ib8sIZEpkduwwYgo8Er6kC65jtKkoq9
	fpU3aE/zO7lZUI2haRJeHkzsGfBH+ZW23IxROPYhPK9Aj1TwRacefJm5vrCud1jj
	sp1y/e5/pPVhYWpo6C1T/R0O3JGQDn6KJ7KrgyzMft5C/3ivigQ2CpfWN4PCDfyp
	3Csmi0p/4/mXNb4R2vL+o6xvq/YPVnAu7uUvJAYWgng8BhnO2bWUlj5GXKfmV6Ip
	gZSaiqo9Ww6XM6zgRs0XoXpV44YRcqoeXnh9S8BzfrBXusOfd8iw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmbaj4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Sep 2025 14:40:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 581EU79D011711;
	Mon, 1 Sep 2025 14:40:53 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011020.outbound.protection.outlook.com [40.107.208.20])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqre7u5e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Sep 2025 14:40:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HGZhrHuPIhRRx6rnqw5Q4e6qc/J+DTnmVtiGlO/39OPMWLSw/5aREqcU62JDe/wsJEtrFLK4HyhDN0auSLOgqNFnvPIBZScvrO0jB5HZwcvEVNl8dO06ajl7MBRZ8uzOBU66B93xdMMQOCm56vQBR7u6BsIgU94n+qvvHNFdRl3WKUgqpXd+I4Gh6cmUzBGJJil6wXC8G4VlVe1pwQFset7lXKnPSW8NYGdVoQoSzQtbCa6ko8gaa1l1b/SfqJT84ZK8iduYTXta40VZ/oIJlizHiF/RFYJY/vMG+gv/CCuCtO9BEtbPji6t8ibOm2XM5HdlVko5XT6iP/MqXVb5XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d2TkoRrjDeUiwt99GNzEiBYtgbLqB4NHvG1ZgJmmjqs=;
 b=KsVXZFSIORy0+rYgswFTEFTjImZXB+x5A4Rkm/OZ2f1iUBe7EhAPIQS2jTiUJUnVmWpyxdAVQ6e7Wriau5cyu5qtMP3M0qcy4uShKVbhCznG/Uvv15L6HqaxQUU/kS80Mi9Oh/uKQwrlwJnLuGp4Qh8MTAAtuOTl8+iVZEcIH8wC+LWv+bx8TTkLttrB8xheFP6PLE8O8qI1MmSf745BVtTS3hl93+45FDGIwr0mJ/Ar3n1nw2OGOy+ebPgqDdeOs88rajKMt/7PNEy7j/Lfv3TVZHUotGqSxpk5/0TdoLUCEOlQVDmZ+roDCNekL0JEyPELtPPfQqp6JBG5qbkmFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d2TkoRrjDeUiwt99GNzEiBYtgbLqB4NHvG1ZgJmmjqs=;
 b=wMB6VDhpTVSnOK4B/ekCsIkeD5UimJwuXGYOnUG3g9jWrKrpTRU//cybKxvT8Tycy0xmedFVRI0B/2b/c9GpMEhPY3Qy7XH9Ex4WoiGzeT9PrE6SD7lemSFiRsYJdf2WKPmv72I3zoK+eJf8oC+5xzhcYNml+qqmO0Rizr/tOe4=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA4PR10MB8709.namprd10.prod.outlook.com (2603:10b6:208:56d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.22; Mon, 1 Sep
 2025 14:40:49 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%3]) with mapi id 15.20.9073.026; Mon, 1 Sep 2025
 14:40:49 +0000
Date: Mon, 1 Sep 2025 15:40:35 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
        yuanchu@google.com, willy@infradead.org, hughd@google.com,
        mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, vishal.moola@gmail.com, linux@armlinux.org.uk,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, davem@davemloft.net, andreas@gaisler.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, chris@zankel.net, jcmvbkbc@gmail.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
        weixugc@google.com, baolin.wang@linux.alibaba.com, rientjes@google.com,
        shakeel.butt@linux.dev, thuth@redhat.com, broonie@kernel.org,
        osalvador@suse.de, jfalempe@redhat.com, mpe@ellerman.id.au,
        nysal@linux.ibm.com, linux-arm-kernel@lists.infradead.org,
        linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 04/12] fs: constify mapping related test functions for
 improved const-correctness
Message-ID: <8429d6ed-012e-43d9-b6da-c02766e75ddc@lucifer.local>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-5-max.kellermann@ionos.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901123028.3383461-5-max.kellermann@ionos.com>
X-ClientProxiedBy: GV3P280CA0085.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:a::8)
 To BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA4PR10MB8709:EE_
X-MS-Office365-Filtering-Correlation-Id: c49e0ae0-920b-49fb-fd44-08dde9658b08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w7Q/9Y1L1yJPlMBgJ30hU3Pd1VJnxRZ/uySBWuEm0uJzEzTKbfhGlv8AA9Yw?=
 =?us-ascii?Q?U1/l5dTvtsCyxEdiw6zNpXXkhmvlqJ67eT0YTJnrZEF38oG8PwS8jw5tHnnn?=
 =?us-ascii?Q?ElPuZJlZYo+KVbU7stTenegmLle5w6RlIa32ZL3TgH3MYwsQp2yX88cbCJmu?=
 =?us-ascii?Q?ZHqXSMI1EcmV+oX0VbbHGvIpbVYorESlrLjkLQ32M6pxjQUaSlzbIL5mzd9H?=
 =?us-ascii?Q?1Zjv6L4jWOgw7SaSUZ0HDl6dGg7tCJNHVR4PEWGpkDSLM4cKTw2q0RUbnyLW?=
 =?us-ascii?Q?JINA8UWsiOa4yD2eHZzMDNvZa2mNIWBIQQweoWWk8hEr3L6q4E1ZVGvFv3n8?=
 =?us-ascii?Q?jIShKXufkzrlLtiidIk9kpZjxq9M+S1NoSJr/RIzejiz3cmQFFL3Uw9H/R7B?=
 =?us-ascii?Q?nLHfzNGv/W0eJ1ywuLUu5FRhEvpx4LOtPSif68kfz2BjOLp1asYJbPceb4Tu?=
 =?us-ascii?Q?ykyFyg2Lj5tGRJ4lsHkzd/bYCversOteusOIovmdZxvNv38svCs7S09Zszo0?=
 =?us-ascii?Q?Bt38Bv0VK4axliVGtl3y51zcw8vOqv/XPKSrBEZzVkRDNjiU18J5S4/0o78K?=
 =?us-ascii?Q?RRzVwrbqWayH8nhJrdHoq+EtGVmj046J4n9sOHr/CRFIZ65ejfGnlH1qtbqJ?=
 =?us-ascii?Q?nkJFy86idMrciE/vbwxNkrj+iYAhtJ++mThKy7prJ/KRl3++kbG0akPc2Niq?=
 =?us-ascii?Q?DEGPpRBEEAxLUqE0hLWMySYTH0J9vzLqmVoCRW19fgxZGivjoT226xoCGBxk?=
 =?us-ascii?Q?oPdTqgcDdaZ7yeWNpgs8OleThQ9R+hO+CsX0tb3Cz8URqC1HhGU+HmtdTxT4?=
 =?us-ascii?Q?NmpA6YnSeB4iCGVLIK1dOn+4dSFHFdsAMKZTgURK/dYtxbGHksV0a4yxLATS?=
 =?us-ascii?Q?/iLBeRHyJe0Yg87AfDkD0ZHOPmwrOuvq34BzV9AmVPgUHy8++eoq4+8Ft6Jg?=
 =?us-ascii?Q?OH9SqegURxbZIEpeCWpLq9N7Kqb88Vw2rh2JhC7icRvv2GJWPPXPlCY3BUdh?=
 =?us-ascii?Q?21qnoqsISCPjA7sycR1Wuz3W19BNcfgoiTI3DR1N5FAwXE16BVWWx1ZJDzVX?=
 =?us-ascii?Q?cu2PjLydKhNlcjyoc7aGeXjJEQqTCHxYtGJVfhuRCkgwhx5QuLLC+qGmmKLH?=
 =?us-ascii?Q?TRAjxtjIGpDUuUekT3Sny3YGH3YERrRD6Iz0n6V1PCY8V2foGsHoXKP5KakO?=
 =?us-ascii?Q?yKLfW20cjWZEsW2mfEVxrrN5DA+9gurijNfMywEhNknHMs+sFJ1XmtCWD/dv?=
 =?us-ascii?Q?DDMvzCFwOOW5piMtXjapNpK0PWiaBJX/PAYDNdDbfntbkAozvmXvH+29mc+q?=
 =?us-ascii?Q?nOXLRn/ZFRvgU1IlNhBCbIYuiq87UXgfeKqrUp6YJ9OWRj6QnACEyxzQmt3K?=
 =?us-ascii?Q?ykmXo5kvmqpXrj36fELLFnZ9abErtykMPuvEGeSVyOkkzJWRuz3AmKtAdSSV?=
 =?us-ascii?Q?Ns7GiWNvjP4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ktLgDKBPGNfOwWv9vs7bEiZiAt8zvqdSXxlwxWKuz9KbZgvwIyFiHocQWvZt?=
 =?us-ascii?Q?E7jPYrzAQh4jljMTc1H5WBjwuj9qBSIH82IEMvjO6eXt69zC8Swu3dw5/83W?=
 =?us-ascii?Q?3K8XcVBo1ewh4C5AHhivt+EuNEQOGp97w3aC7QiyBve7Q4poeLS7zv2Anc+p?=
 =?us-ascii?Q?AarTOxT+MUkKtGaU8oiBZXX+valkl/HP6O+zPZyx1BrG/C8moA03vL0fRhd0?=
 =?us-ascii?Q?wWXoyNep9OI0nZqDsAV/B/xU7ZNGsxl2lxEb9xEs06QThu56h9dz0jliZS7q?=
 =?us-ascii?Q?vm346OGUX3CmCyxVPjHLr87qZFxQZPWH8GZoNDl35mrri8J9BMYThSFcSw81?=
 =?us-ascii?Q?fA3eYomIHAfhoN0vlBkzStZ7WR22KxITLctfeZV7vKFA/6uJWRr8971u8C4A?=
 =?us-ascii?Q?uYEzsHoDkpa/SNqvgPkALwuKWImRbT1RnkWVAM9afWHYkGI6y537a3fETh67?=
 =?us-ascii?Q?cWRFfwUXBy7sAsnhFq97paqr95WydydyRV4z4O9ja0VtuRnfvF/vXcry2JcM?=
 =?us-ascii?Q?O9s7awc09ccyi2hSiQtTmy0jdnCkYjPWKlK2GGb9h8ym0zliNOhYqerX6xpl?=
 =?us-ascii?Q?l3GhZwue3PVVh9p/FigPnUU5yu4PcTw0xyLca4bZMZNPYX7X3oFSuKj7xds7?=
 =?us-ascii?Q?zXkz+kzyS0Jee8Y5PAHgiZ9RRL48PpWuSvOnHFdrDsLV9+M/Myg+f+gs+B03?=
 =?us-ascii?Q?Cudf6JeJG+++YaJ2wF+7Z1mMi2UOk/qCRwLxApyds+zLJbhXumkLUWJm/arb?=
 =?us-ascii?Q?Z7jmqrFdyP+7CZOOBqo6RLcK6ELZZ1FrWkK3oN/Y+MeuVGF0/aSWSj4fJ6ZZ?=
 =?us-ascii?Q?3J0QBH+8NNSWItOkDew5C+KChB6LbmrEUL42yAyfyN115rr8Uw4QnkYeMIWy?=
 =?us-ascii?Q?M5yzSRRopIJMcvELriV/D6YtMcZkSkJ+E7R6J+cQ+l2X/p0E1SbQzQEDWheM?=
 =?us-ascii?Q?E4ysuGVm8iH5tQ4aN4hQyaJ0O7t0KrGPcLlAiuXF8NAnhV8snjAOJ+7AlDH4?=
 =?us-ascii?Q?O89k4B2OI0qGTYdK9+U5oG2K+Rjgo/xDFFlzIKzDfjoS4gHH8eb5Qzulk4XE?=
 =?us-ascii?Q?g+R6hO0Y7Elnp9+hI7Cjk5ZMArAMqlgWAuHrsLen2Y46Wk+BpKohkU1yrBnt?=
 =?us-ascii?Q?u6jOeslZwL1BC8zYObRiwc36+pWiEKFoQz1xBRG/Oo7WSxzl2J1icoqoVpTi?=
 =?us-ascii?Q?iYcs2Ig+flAx5oTjvSvtE46xTJ/RYHTh7VYcY+NydhVvsHXCroEczE+rllti?=
 =?us-ascii?Q?0cSsvyzjU4qIyVVlnaBoCzR+MdvsAmfBBUMWT9SVRX87VCZG6AL+eBhOnzXM?=
 =?us-ascii?Q?+V/qN8lukOaKPoE5m9UN+dUPrDgvYAmNZY1m1wcDB4Yvkz4ua9Lui/QkHJAN?=
 =?us-ascii?Q?QzOQRY34NJX0NAoNWBwH4jkHcLq7wK+S32eYFm25/4ZacGg8Kaiz8/X1xklg?=
 =?us-ascii?Q?Lch3F2+/0eIW7JWAxAkLrV7Cz7V39ltGBdt7b/NwJOj0/gePKgiIWLFBnT0N?=
 =?us-ascii?Q?S5jLlBKsxnIY+bDNH8+zEh8O3kYzsFT0stFervCdpAX1CuWTyRu5egpM19RA?=
 =?us-ascii?Q?4s4rX6YXNSflByYZN/EPBSfhUZx0ibb3xQUu+Ge3zovWVkJY5TtLfU3eNZwV?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+2mvz8PLF3bJHPFkkcexIyhbmb9kl182jlm2sMfsOhrFuWa8z6uT2i+nR3AOopnBfgJIyldZ9JSJQ0S/lNhVlC8fSWqW7uWxEO0clG2T3IVKlo+kq0uKR4eAzUmFgtH1cvdHg0ZYyVD7L7HXUhMj3QtELBtz7m60HNM4+conRUReGQA/sxsnThDo/4qXRHHWGlojs7iXaZpsH+xfUAjGwQUNxyUiR/3Y1Ja4mkJFNRChW7W6oyegw4fnfILWHt3mu2y1YBoZIzuiwUOl5YwzQ5twracfN17mTdwPwGg58SM0pGyAmak6d5sCWDtfyy8oO1vaT0ICETiV81bVQ9IKNgTzjrHF8PSRW7cRX+6yBy/nl4L0/T5bLBkNRfolOQmQK3IqXy+6esVL2Xs78hc+RyhFyCAwW14qym7r3MvTxW7oSDnRFxpgDa5rjaw2zXaWXAZfxnpdHL4AYab4QuEoQymtFefSRngGnTon18I0IaSvpiAeYQCN6gZatj0vsPAt1RYRfiJTJub2mf5EShHXYOnHNcO/J006yAyEqLIYrTYC/RrVfXm1PvjSZG/W3LTYo+GdepJE8sjoamq2ugFiH4oFEAIRB+2X3U1mfcy5L7U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c49e0ae0-920b-49fb-fd44-08dde9658b08
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2025 14:40:49.0636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HlH+RJOFj/N6CfnqRLJl7PCDeBg9xbuwW21+5t7yyvco6nAMz7eCYNwpriqGOxLmoEsJVfTPRBMJX4+9sYZWMNBXTb4v/EtkLQC27M0OBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8709
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-01_06,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509010155
X-Proofpoint-ORIG-GUID: W4JEM_13Des-E5y-VPxsZjST84cUoXhD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX/KA/Ml1x1V23
 9dngfJV41nPA3d+bhXWH4EkRfVZ4QFHt68i36zWkYz1m53+3BrR11RT4Cn3jyPf65NG35HtayUY
 C6X5JvuuK9qUb7BrtFHJ5cLyRV9EyHWt9G7668cWiYe6ZYX65AZnxBiJWJmgmL8zUwvgQFeNEiB
 vSanofXXjPZMJS7LUnaIAhgcyn5WM7EqjlpEHN0d56Uwm7mx+DX7hSanfgEN4adDkZzcG8jQKSY
 ge/oiVNf7WGyZFzUx/JGgunA1GgVRiBepPpwcUXYHbmWoZaabLGk+cF4OSCiLEGEhsfZryHwmzl
 FSNr8meV9X5fruGwLXhW1bcDtoc+BYnhoNELnUJpmcUMDY89JKKb8pEsq27lULILD5rrOho80gV
 zgrBoCtXkCgoxcpmaCyYcb1GjqeelQ==
X-Authority-Analysis: v=2.4 cv=KORaDEFo c=1 sm=1 tr=0 ts=68b5b076 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=UgJECxHJAAAA:8 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=n3OWFlr7c82Z2jJLSCYA:9 a=CjuIK1q_8ugA:10
 a=-El7cUbtino8hM1DCn8D:22 cc=ntf awl=host:12068
X-Proofpoint-GUID: W4JEM_13Des-E5y-VPxsZjST84cUoXhD
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3024C180011
X-Stat-Signature: dkj4msah5zuf4h1r4r6d14hsuhdmuk88
X-Rspam-User: 
X-HE-Tag: 1756737684-465449
X-HE-Meta: U2FsdGVkX18cjofELKuLiI03wHAppnK40jNplZ3J9ERH3AuGh6/Sn98ORKjk7hXVgCisR8ZMmzvwlqH6H/wKv6T/2DaHBp2KwlByVQe2mIgl09LeZbEh6YUs/FGTiKjH2eCrHiJyObnYivTbWTgwO5L6Iq+aOavSaEHxPU5fIaz0Q+9+uzPTHvQN1BSuSnTb9X0r8R7F5lBdnnQ0pdv/eD2EGNpIoKvqX/ZJYomVG8DIDAO0qbVbwQQyu83+2mdk0RDaVDQc+tPg+AA8LucLkFMgs4zenrGdmtluM1NA3lzqeY8tmOqCxwUVbMwNSPFYQkqR6obzXhy5FOYaStitwvWowFaaoidMh1afcailMymMgXreQ8/MI7/MmsxzTmVrbW5C//Xw3f2Rlj3xgy7DQ3BkTrCEYoNh/Hrf+pEKFugkmOvO+PrF3K0hTRP0FXBz4cSdl9F+tyaz1YmqAIbReNbP23dcpDly/bQEZaBd97yAXPB8tve3J31ONDTayzkjSRvNL88qMipN1HnmIWNzcsfa1pRCV+X+n7HgWsQ38yDMWoJG/C8Xv3XhzKfmlm1mJL++SK0Yod9VFZ09rs7lH+e6Vocb2XDTsoGZlGnXHU6tQz/E7BggmQ5RLHone+PUkRWwtnvaTnYlY4ZZmh3u102JdFZn4uSzNEoJbypc/3ALvf/c51GKyWVWOIa5SGpVl28gchaoRHkzUZ9KIjODxnGYu+na1PoPmyNXwD4iX7Ue27EckkM78UNjRSpY5yuCnfcAtI2sClhJl/rG6jBYdOQJPUpaoDKFvCmORcMLWshQDhXnZIwzVJJhfEeIgv0puX5+84fU8LfF8X7EmTpFOv0AHC0R7yTF8N/aoyq4HL75Auwizon5M+NFdAi4JvyzZRoA95mAF/8aNzycP0DOSjIxMcmAl+zKAzvQX4p2X/d0oPvjQT8FMUHxFRJ2Qw45NVYKHHNfVcc3pleKjc+
 pYKmTLJj
 T5usqZXxKSZkaNRzml6INcKKgqqH6aKvy/jay1UGi0HIfAK65onlLjAvWfEezu/AezOhMl0zg7J/F6SY0kiCFAYDTjnD1ETacS+FGqa0kYn9GwNfpYyBwUk70phomvYU7nskNuI5lg3x+mhPmhJ39GVFSy7q4EdVIGuI2Gc7jxcQoidoH5+V8COyzOdl1tO0/S+3urT/S2j/xavgVyAt+8UEy1zmCubl+BIMwX3XKimk4k7ZSI0GFr+ReNLwSfka8YuWcl2ALqaL0voESGzQgxN1aT9do8xJA9uxNUkjxmOtxoqumL+bn4VDxTAOSp5uZCKQ6f60XOx7cJwGw5D/ye3jruj0aad9SaZpDcJ1P1aES0pITGXiOsP6bTdxvV0JYMwuXi4VYsS4YvQAZEONc6GOvaAQt60OonTLtmSmZ5kC1rzBWSPVkEtYpYOeLPqx1sH0OVcDpwrQCfWSjtUt0d/POgeUBscAxKd6ADuAzz5t3tJpIMZWumF6V20Cp+H/Ax+YPQt0l+q4C/FajUK230qT3oV42EV4jBIotkKdLbprUoPVdXC1D8l6c0gQBHcLZmsCzikI3qEeM/Dz8WxYHvv6d5CesGqmXab2yGqXIJlHJ2h5+jmEuk7uaZrsWdPod7L+SLTrfVA0pjIW4yCx+MMHY8ZSfWbuBiS1JXbyJW6qcbMXibF0CZcSNhr3MUZbCfGTY2PQDicPfChlwDkQUHjzCd242GB490IprlyewUVsqDCyQoUyhPtb7ikFPerWWMC58bHXUG31Se+IvxXq6MqltjuF0JHrDkwSZ5TxmBftu7HSNWGP6Gtb1O2aKE/kPsx+Jhz73D488tRsUB238YkgKLvqBUUAkaamC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 02:30:20PM +0200, Max Kellermann wrote:
> We select certain test functions which either invoke each other,
> functions that are already const-ified, or no further functions.
>
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

(Again, on basis of us figuring out whether we want the double-const)

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/fs.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 3b9f54446db0..8dc46337467d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -537,7 +537,8 @@ struct address_space {
>  /*
>   * Returns true if any of the pages in the mapping are marked with the tag.
>   */
> -static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
> +static inline bool mapping_tagged(const struct address_space *const mapping,
> +				  const xa_mark_t tag)
>  {
>  	return xa_marked(&mapping->i_pages, tag);
>  }
> @@ -585,7 +586,7 @@ static inline void i_mmap_assert_write_locked(struct address_space *mapping)
>  /*
>   * Might pages of this file be mapped into userspace?
>   */
> -static inline int mapping_mapped(struct address_space *mapping)
> +static inline int mapping_mapped(const struct address_space *const mapping)
>  {
>  	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
>  }
> @@ -599,7 +600,7 @@ static inline int mapping_mapped(struct address_space *mapping)
>   * If i_mmap_writable is negative, no new writable mappings are allowed. You
>   * can only deny writable mappings, if none exists right now.
>   */
> -static inline int mapping_writably_mapped(struct address_space *mapping)
> +static inline int mapping_writably_mapped(const struct address_space *const mapping)
>  {
>  	return atomic_read(&mapping->i_mmap_writable) > 0;
>  }
> --
> 2.47.2
>

