Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1FD4D4117A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:34:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453696B0092; Thu, 15 Jan 2026 07:34:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411466B0096; Thu, 15 Jan 2026 07:34:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DFF06B0098; Thu, 15 Jan 2026 07:34:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B2156B0092
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:34:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3279B8379
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:34:49 +0000 (UTC)
X-FDA: 84334142298.24.7E2B5F6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5253C180009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:34:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Iy8ox7a+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="duYToA/D";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768480486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Efm5IE9hSVtBLG7XneEmVHnbcFWALQnM0FGhOS1EUxE=;
	b=Z4P5gld4utaOXp94YuuK2j+1t+SXPv7GDnr2aaZEZvWFaALvLtG/NhQsT5dtqwniONipsT
	BXPxrUkHwVay+DTuCl98UsDbQzG4PSeYmpuH+zMr3hy7lgQWaJqUURs8CZBptxZFjInE9P
	Z14uoXiVgvUY80kr9D7r0wUKB7Azd7s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768480486; a=rsa-sha256;
	cv=pass;
	b=V+D1MJgpvNA5pQiuCdg+q2NpCjBSLLFY3QHmQ3Ft9CfYgNrAZ9pYhMifQbyZ4ggEKCEpjp
	ONi68WFbnRQk6/S5JnPCvNgSoa6jFtfvl0pzkEaiWLyazJgrc5U1vlurrbY9cDWknAnqfH
	vkKe7CeTUGUruLqfvEIAgAzslDAPiGw=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Iy8ox7a+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="duYToA/D";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FAMV831295786;
	Thu, 15 Jan 2026 12:34:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Efm5IE9hSVtBLG7Xne
	EmVHnbcFWALQnM0FGhOS1EUxE=; b=Iy8ox7a+ZqUlnbPM5pN5r6duEH3glxKH/A
	ZjZeUrCZFD/4eQiYuksBrZTw4iq708+TEm9UcwifbEgBzF3NWi2xh6lPluvm0hbC
	T6RNv9tlbXLmSjeCuJAmhhEKgaPv5nD6HPS/hlxtvXQcrvW4bvcmRCzfk/wCcCuk
	RubgP5UK9lZ6xWAItWyZkHA0G2rgLyyo6Z9mUV36wYE/YUBYBLgljB/grNH7CeFw
	0evv/powZI31CllktGbelhqDKvpIFJGqrBdeviuzQYDRl98UWyAmbcFDrMpxyU5/
	EU4W5QLWnx7T8ERiakDoSKvsRAgAlaEH3w2HdU0jPghr8N7cj4vQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc2yr6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:34:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FB1aAM008248;
	Thu, 15 Jan 2026 12:34:21 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012012.outbound.protection.outlook.com [52.101.43.12])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7b1j9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:34:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jfRf7V8ECxkA3v5okJxXJJ61YP6acO+04HGTJZwr2Yl3TJ8WuLa2CeAHoA/Hl7e0PrcSJzJtM0NtSZcTqCCRDEX+i1bsqBCWtm8Qly85DnWSdRoAa+wv1r0XoxSfBSxj655jroI8P/2VEbiRCbIlutv66isXF67n4T5ZNGZ+vEqis/HD/Cl/3VxAVcG9t3ujonz/jTOwwpV07XPwaGHt/xrWqPa5G76ektrO2w4Iu4JloavquDb3/7g+J04RmL1j6ZdulPKMYLDBluLv0iS7n0QUUODeP5nGAwyAR2kfDFQ5B+XpnJAORTj2MJnhOemoQSwjO67+AQ24AZ9sOoSVCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Efm5IE9hSVtBLG7XneEmVHnbcFWALQnM0FGhOS1EUxE=;
 b=vx8stlKGc/37hAOOU1fxFCXH2Yyg7p+yYpRINTZJdr6Xeu1roblqMmsv9DDAuB7E8MIP2m0EvbiMyv5rmy1inRcQoKEq7ed0fEwxSsBVGz9jK04+Uc3SG7Axe/DWPdaSqdTleKdtcuf5q1B7pHYyn7UIruR6qtMGlxaknZMc6rQ1rlSBs8k2Y9DsKfpp10DDvkgiQXAh5gztPsIyWpcXMoIlS190fD39qI5hCOJXVKh9rqjnMZrSV6eLc07JX3h4gRxzX8kCyHUJWLaDCokNWhwC/xOgm2AcG3RcvTFO1jITmQkDiH8qendSEbXsm+y/bhb4Tl4GexJguzko5aftGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Efm5IE9hSVtBLG7XneEmVHnbcFWALQnM0FGhOS1EUxE=;
 b=duYToA/D1mupSRkE5dZ/InOQaeC2HWGtwva7wxkQZmK9IDBiIYyoXyLZLHI2TIs1RoI8flXhlLbJyj8Ja3vckyC0L+jWKBUGOjcttVwZvzJpyY+ZLT+VGbf2iCPgkhVhB34Hrf2r7/PVNQjpXS7laeLlMSANstbI5aQJV+SJGcc=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CO1PR10MB4801.namprd10.prod.outlook.com (2603:10b6:303:96::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Thu, 15 Jan
 2026 12:34:17 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 12:34:17 +0000
Date: Thu, 15 Jan 2026 12:34:20 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 17/23] mm/balloon_compaction: remove "extern" from
 functions
Message-ID: <00320516-c5c6-4192-9ce4-de63f6a6eaeb@lucifer.local>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-18-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115092015.3928975-18-david@kernel.org>
X-ClientProxiedBy: LO4P265CA0096.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CO1PR10MB4801:EE_
X-MS-Office365-Filtering-Correlation-Id: e24d5d8c-a847-4124-063c-08de54326661
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1eaCrW2uUEUFV7QP+LMfOdBJqWYaop1kiJQjQmro5H2vGfm9HpLj1CvvGj8I?=
 =?us-ascii?Q?dLtjsXvNnUZPpNucbeZcrhnZ8omn5TwEO04xhbXAUA1/QyRXFM1tj5f785li?=
 =?us-ascii?Q?OUCHVOGmKr0vNTa54rFT0jDJtUayFVaq3z5GTvkKVatVgfg3KvofK4xUSvJH?=
 =?us-ascii?Q?axdgcCuymiK0bWUisgvKJYIJz5PjgxWonzRdBYiAoGz9sTsCIbi0kllXZvkJ?=
 =?us-ascii?Q?08mk732FtHHo/JgZ96BQcCnyQojLflc6Fvji5EFTU++uewmrVDN6cl1QXt5B?=
 =?us-ascii?Q?h14hS+mIvgYCBWtYgNQqeUGt0IxhuXnDgbeVQAYMnU7v3aCO2z+Md31pEG9f?=
 =?us-ascii?Q?BfaHIfYWH47jWECPGSiRK7iVJX9YOz1kKsK6rjCoOGcafbxm38RbI+cePMUb?=
 =?us-ascii?Q?20L9y8esCKvwvgoyT8i0WNmIdtjr44pnRRYCbNhn/Z22Ug8ezcTF4PAfA9Tv?=
 =?us-ascii?Q?BB7jxepajfSQ91bDRGuTvnYW3kATTEsWdWpc06T0c5Xu2b0yhK/BBk3MTTrT?=
 =?us-ascii?Q?aRq8uW5QrTJ060waDeKCfT4pLt6EGEMG0cX5Or/+4YhONacwzYJQZJafP8MS?=
 =?us-ascii?Q?eypKNkXhd8He5RecoW53FSBb3wDiM6f3X6LTTk/u1k1SCtpvcewIZojYuOu+?=
 =?us-ascii?Q?mFRR4cRBl84Shnc7GlpmqhLeRWLQ0uzPfyLb6QMt4Bu2TV4l2CXJdmc+tsGb?=
 =?us-ascii?Q?8afFjU4TI7ANTsYlsEYoibzsXi3OTtboLZqkEFlHrDSl6ZLKdF/0BorL046H?=
 =?us-ascii?Q?Vxjngsek/HpzKLwxduiAiCIAPKheqsqo6UzFJWrevnl7VexlQgnCoxYmKnfV?=
 =?us-ascii?Q?3VUsiBt7BIpFSTzj3p+N1R1GAlZuZB/A6tf2lXINQfejyE5vWUHSwPWKI/hh?=
 =?us-ascii?Q?aILWLaeEtkq30EHZSZxsmO+6unQvp/GZ5JKb7lQZQVijnv+0JPzVW+FfEUFo?=
 =?us-ascii?Q?ibZdmDBInuUwpkjj3n0GammoyEkg3o7FueNPt658Hw7WtatrtVHDRiKHJZDk?=
 =?us-ascii?Q?BFaxURfhbNyX4ipNqJzNGcZ9mZENp1TQzKmUwqbt1uvGr09bSWI2xvZ3uK0Q?=
 =?us-ascii?Q?1NbqScy5cK0TNAVL1vyu9u2l0RSkIo0uWA8Cm+jKA/8vMfl9tQId+6sPKmUB?=
 =?us-ascii?Q?9r8GhJnLP9T3gaGHNVFDB0ZcXdJKcZMra7ByfHtqG2m81mnRtGD9I2vikczn?=
 =?us-ascii?Q?fXf44wztXYAqYOAWSLWSXrZPZlWqoblir3scgFi0NW1YLLcLkzJhWPaUMQwM?=
 =?us-ascii?Q?gmwC6a9kwYuUoWDAl6nV5sTyWX8gsJ0MdeNaJoBL4wvNlP5VwQ8SJvg2xytS?=
 =?us-ascii?Q?KgN/0RXpY6PWM1BN6of6LZYbqd8DGs6G9HBmW+GxRaDALfZ+vKHzOrrKSJk4?=
 =?us-ascii?Q?OwFC2nPqgiNBDBvDKUEoKR0wKqkC0sL1ql1X5BFjP3BGxs5K+2O9ehFG1feN?=
 =?us-ascii?Q?XYZvqHumx7/z7DjfaKcsmdh6EOAw39coy5z7NZRFx41BK4EGJCqS5HiL9HQ6?=
 =?us-ascii?Q?nxC4sxOHz7SahPIgc8C5pZ022J4TLMhGjadV9r58VszTD3pQard2Z48e5k4Y?=
 =?us-ascii?Q?PjVPQoJacQsuLbpqaq8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xKnjWPZKaMY3xoqnhnARmaGvm0EDGgr5uGyZlkeTB/s5ketMxwt9s9sptGWF?=
 =?us-ascii?Q?OPmDEu8bfB7DurzTR4Uqz7C7JD3rOzC9IxEETqlZjK09HCLOILpfp+1C3T32?=
 =?us-ascii?Q?Hu0aTpgHlb0rmCn5LbVTSb/vsCEcxwoVn/VmphjWl6FwtgSlbvANDEEDLYqT?=
 =?us-ascii?Q?qN/CTD8GJiIrSa1tBzqq4WjSriyDUI5JExmu2UPmGhG0zwvJFTS/BJUL84S0?=
 =?us-ascii?Q?u8R8pnpv5kEFIp4mZZPLUJR8u7+ExdHhHuevtriKwIxv8iruP7Rwf3GORD4s?=
 =?us-ascii?Q?LFVbTXbcyAPBR4+WplE9Gr+zt4nf0UXVz6/ZX+ghBqmzmqYfInNwiLDxtZvm?=
 =?us-ascii?Q?uWt/L03Cwxh2ufp41H0eqkk2HZWSq/vqaLRM1/iJzeBNqCW29z9axWBwnHqr?=
 =?us-ascii?Q?8KIPBeQakFNmeD5FsjEiyDTUBrTplhGEVyI4InVpaCEK5Naitnn+2G/hxbe5?=
 =?us-ascii?Q?3+JaCekKEHo88LmOtsxHkpTI3UmKp34x7Ir9LQD/GRt7XrFjGmRO4L4RkXDQ?=
 =?us-ascii?Q?p8ibvUuVhyDAr6ajWXv5zWS4TLRdKgcZYleHJlCgzyW7jYRXbTz7N79b5SUC?=
 =?us-ascii?Q?72S01VI7WpUUK9zOfOWI3FsoyESoUDAHLWcCe70QtWWT7CQEI5/HY2hLAXfP?=
 =?us-ascii?Q?jFSG+cVQgKEonNVleySVg0yjgnkplhw5HVh6PhHA3HSWZL+HR1SIBYGYaGGv?=
 =?us-ascii?Q?nWCjMRi/iuZOFxR5xFzqDpRfghuGLz+X4O1Gaa+TVK/OUCu+2XhfgsbCvfM3?=
 =?us-ascii?Q?Tln6z2Wol7Mi30B0XVGSEEosCNZyi+okjWT0nrKSFxnq6bwWKmMfckSeoLgU?=
 =?us-ascii?Q?FDHgGE0pSXosCuaVhjxsM1JpYvFUd+uvx2W3S6Rszga6w1DKhNLSg/X6PxLO?=
 =?us-ascii?Q?Cgp6mSK1G3UFbabAcswyA5xkSVo9Xddj/4g/aKK46cl+PpN/A53ZdqE+YFfh?=
 =?us-ascii?Q?IA0EHgyDMBC1uQuGcFPISxBe5EjLPUvTgvhTsKDSGc0w50YLyJmM49YjnvPC?=
 =?us-ascii?Q?jXlj2Gxx4Tj6WwMfPkMK4iWRD9o6U+Tk4q/ViOW46sL82Inj+CRNx4dFxqyI?=
 =?us-ascii?Q?P2i5CG9Nu43RaSbZWQdW0TrTszS0MEHwiDgaqtQPO8BawZuRX3hH/HnKeGBA?=
 =?us-ascii?Q?jKHepjKGThBnXNB+DyswhWpdz4/pFLgF7XMiuuI7ucVck0QfNQgY481/ueim?=
 =?us-ascii?Q?SRKJLxwSg/1n2xVqwUcL3aOyoFfRvwk2qU8/t4L0sLkw8laIQcxnj5q8Q31P?=
 =?us-ascii?Q?RFCJwDTDe/Rdj9cT+znxmnE+kDqNVJa+gxNe09RqFyq9EdwZ9gI++Zdd6T/M?=
 =?us-ascii?Q?7mMuM9T7Vn/fKD9s30/Uiq5eNJq6lESIDXChK7dM21IIozs6vDBh7Sc2sqXS?=
 =?us-ascii?Q?n4XC7bDpkR9n8VD8pBVRxob94vQOZNXU/iVjZWXDZ0Pc6z8vxrakUAyp5HdY?=
 =?us-ascii?Q?VOBD5l2rLA4JfycT1OHkbLGCwcbXF9ZEn8yCyyjqv7xPCjtpWj0eGm+j2Fve?=
 =?us-ascii?Q?L29qLGWCGlnmC2poNJGbVXSCxlX96rHZUCtNSs2B5AmwuaNKQAqJmgYRS8S2?=
 =?us-ascii?Q?0Xi/MqS/svJ+gKEkFjYvx2oaLQoPK4VuWSEMC7LBSP5F8j4DeYuysa3UMLoQ?=
 =?us-ascii?Q?DVSgptt/t97IuKzlfV9rdyuWWPcaiKYgmvKUIh1IF/ItnlNhSuWH02KGOdVT?=
 =?us-ascii?Q?ru5T+65H9VnS8MTwl3udHSuJXpTb1C4WtHp4dq+sEyEaaJ5r8QhbxzJRHIIi?=
 =?us-ascii?Q?Ph7491TZgBgd5lU9wuGCPOmrgft9tFI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iN4COKi92S8V0nhztzQPmuIEWrutYcX+yGyIj5JfLihS8ZIShXtfGGWOScUOKuHYyfGV5F6+u8UXuschU0w88u9JG423vk2RPmVz3RVWFmx1+RHZlEurENlD3OyvCowyQkqWc9zuaHPED8kYv3/FybPHNALfEtpZJfHaeyx/hxETuh4s/NasoV3sNri6hok0CqLpaMzCWQDjcQaG3KWHSZkPEuNeK+zD6r4YpYOtle5z/80F+4uq3a8g1jCXwuVP9SUZH3vgr6jPGdxY2gPWCdXJZknLSQIG17GAdsoN9/IEc6ZMEJ9vEPKSjdURNy89awWGtcqJcSAr60a29g0gBYpUy9vyzSWoPuqP1zCNzUm9gtHIThiSn9ly/z55yjCn1glPpT1Z4w8PmI7pxJ7qUp5yOPMcLrzQZu3LdzPOEYiXEABdpw1tT3lkTbo98uwLqQDbgsusp2oHsjFbcSzVmRi1OTZzpS9VehlxhfspdlzvL1i/ggHUIJYRsLdOPDVXpjjWjtmaAhcVmF95CljXDcihgw2mHNofA4Odlt1UUWR9+StUch/RJQ+O0HEZKgumtGbSJIfWESAlcVMp1lfLK8iSKE7gk8nhyOt+RQ2LTPw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e24d5d8c-a847-4124-063c-08de54326661
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 12:34:17.6719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +EppLx/+nr/B8R5mvOUjQAMc88n9jjG/GVhuACnToJmXj/ygIbtt4BR6TS4OOQyF0okUqkJUALKXKHkO/DZkZ2hgI725ETQcckwY7YE4Lkg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4801
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_03,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150093
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=6968decd cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=EYkQu0s06Cf9yUS4b_QA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: K_6_u8N9d2bWGxvUutzIZo9s95Yzg7aE
X-Proofpoint-ORIG-GUID: K_6_u8N9d2bWGxvUutzIZo9s95Yzg7aE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA5MyBTYWx0ZWRfX+3uSU6UvgZ0W
 9HF2vWrWyKGWmM1MG05V6G3UDOhVCfCAdOBz32WnosXIRsULji653pQmrqb9p9XI1fyhPMtwQAa
 03Jmhel6WbcEOYtXdhJagDSHKEu0gCpB4Bs0a4Lgb45WrlJXZQo0y5hJkv6Q0D8Ak3rbVvC/Lvx
 WC5twcN1TbTahcWQkbA28gjtNdMDhRLZlLEFKvl+bAfHnuQpSWgDl2Eik8qiGQwFl9z74ujxTni
 Zl7bFG2TFNofkiBFV8vXyu8ZSn27kDAIJat5ZxVx20CPrQZVKFrA7cO7Ispl7VWv7v3qOC1p4uv
 Hb3n+bObJorRbrsYV0QqBzF8KDz6RMV1fzjM2xFdgvF2XjkPzo1jnShS1cJUo+T03lZ5pvabGpf
 KSKe5T7xLAtYhlhtUiCWWQ2zwo7vIllUaxJg4+o3i0T/0DJfEcLZH/df+2pWXYTsPqsU1oOz/Ku
 KOPv9fDbC6zPtwQm2hA==
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5253C180009
X-Rspam-User: 
X-Stat-Signature: 1xot1pst9h5ofd6rbcakhexfu5n63he7
X-HE-Tag: 1768480486-893403
X-HE-Meta: U2FsdGVkX191IklM3TYFhNgBcELZS8VxP3vuh/nvKx7dMjrKEvetAUB3l4cT6DjaXR+l2iVk+yaN4dxXWE/77my8BBE+wh5F2qmY26EFkhWIkzHMDqWCfadPLFUhB29fO1Ru72lrFXRkLE6aVdNH4sQrqlE/kv4cpuO/FTEqmULhYhaz5gQC2v0BpQSWctP65qz+9JmLnbZwrL22yIoNfn5dhivRZ3BeJiRVhThk4CbG3xmFfVYeOhJbNJDNGgGLwvXVpLlA9rmf9uhBJZ45JSWa1GSHcpLX+6Ipe9m8bXc7fZHLELsUSBrsvasD1hAjf3pKwidmYCpjn7UuunJr+EiNdiM9uz/X2kF5OI4XRfOQx7XPC9xp2p7bzjvFY0oANCB6f9pzPPNr0fuCBhQbFv/tK0Xq7jZXaHGApFFDxpiSIcpQhJxOJisOQDrz+e+Uoz/GhDrRZabh6kFZHZ7/j7s/wiF/ooVW2FhqiVlTxCZ5KObzyeBUwkRAbGp23S/h+sdMgSA/XilVW9fzXiSMtaj0XB21mqGaIiuOjTHzvJT0Q59NCMsBQwOeRvIUTbztHb9qieR/PNnuzRdLnKgdD15WijM8zV/qwH9RLBFSP0W1zsTtwNDQs+xqYWtR/Px5louCj0vs5OQTn6HIMwOzK8AFa57scqa5ckicvJ5PMtZQx+Z9dkbYFjLJBd1foVeo/ZDURh5RoPb+TV014+0hwstpF8OYDKcbmIH+JpL+/85emmGFpthSyIEuaRsDonhsl3IF3kgn6gzM+l3zXXskoAISBjSNNW55MCT2gVmC+W0+oxMa6iJFSXsLP53bwK/wxGiGFj2srFUe0KKN+rjxXJXvOjfgF9e3XVjnCqVAX1L2Z9VZ4kA6xP3hwicDz/UhJ3rUMHGLjLLZmDrh08dgR+wzBzq9rjVkdIBWF/Noymgt3QQOFGUIMqLFMOHhcqs1KV0IYFpfqWT4U9+b/tS
 dQpXoGC2
 ubxeyjRZaixC/Eke4vys1rnjT87LgPnnVZFNklRw7Dw61d2Q8fxHdEPRAIDEiZsaJ6OwfL0CWNuSYsqPY2KUqxqGffAi0RknhnHQCPSfZB37DKH/OT4HTq+t9i+r0onQZCf10wMX4xijIrgkQw9ZeaJdPIkXMsPD/RU3pjwBMocRuefc2vvkLVd2kEM9YEflgEvy4qd7PpSlzXOnOhcmqH+/xfvuf5zmeg7sgDBpss+tVpThh0SJMJI+Y+MUz6KTwRjjiFoipmwTI1TYz6HlgZ9uKUN1IAkXjsq0azFySXZzTcef71R/pn3VHar950fmbgWbXOa3EJOFzL2co0cwFFRYbH+EB908Rm0wMor35Z0snWzXCYOAxW7RaV8mjNkezm/ON0/eXE7noKtpDlanxpXK/xZjJFjEwoPcHURObTskHOWNmCUocym8mwqoh9dL/RH4EyM8/yQntIAuJ5w1YRwxHp5KYB1zypSt8yAhHdF8A2oTQE2fjfP0A17rSSdmQnKooENQD4+UaZewYTHCyAcXnyG152PY4c21EyoaPOj+7rgJET2gORGx/snNzLk6OYOTuNAUc4WZM5ej0nOt5G6//EThLkM87ggrnogbMEid/OmV6obMUjhXQS4HLiFSkrwGeFzrteHvXSg60KPEetMrjQV38a24es6npgy0xO0EDntGKMtUA+APFVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 10:20:07AM +0100, David Hildenbrand (Red Hat) wrote:
> Adding "extern" to functions is frowned-upon. Let's just get rid of it
> for all functions here.

Yes, this is nice thanks!

>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/balloon_compaction.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
> index eec8994056a44..7757e0e314fdb 100644
> --- a/include/linux/balloon_compaction.h
> +++ b/include/linux/balloon_compaction.h
> @@ -59,14 +59,14 @@ struct balloon_dev_info {
>  	bool adjust_managed_page_count;
>  };
>
> -extern struct page *balloon_page_alloc(void);
> -extern void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
> -				 struct page *page);
> -extern struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info);
> -extern size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
> -				      struct list_head *pages);
> -extern size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
> -				     struct list_head *pages, size_t n_req_pages);
> +struct page *balloon_page_alloc(void);
> +void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
> +		struct page *page);
> +struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info);
> +size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
> +		struct list_head *pages);
> +size_t balloon_page_list_dequeue(struct balloon_dev_info *b_dev_info,
> +		struct list_head *pages, size_t n_req_pages);
>
>  static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
>  {
> --
> 2.52.0
>

