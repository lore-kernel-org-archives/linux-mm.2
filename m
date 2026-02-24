Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43945EFB7E1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4DE76B0088; Mon, 23 Feb 2026 21:15:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FBBD6B0092; Mon, 23 Feb 2026 21:15:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5EF6B009B; Mon, 23 Feb 2026 21:15:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7452C6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:15:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0722FB8E1A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:15:37 +0000 (UTC)
X-FDA: 84477733914.10.F3EEF5C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id A699D18000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:15:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V2vnNSnL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tsolaKNI;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771899333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkYwLMoQH6Rm9KhyEBmE5ct8kcqfW1uRrDIINNbdc3s=;
	b=GduYggO3nzVewCW6v+DPr306oDF/1QKGsgT9ogrt1X91AHoyVIu34p5Zo9hssW++QbkEMH
	StcpEaiV2OdEg1HScZw00KVv9MWvmYNQmTPdnlttoqHQJ1NmjjwnO/h3Dd7sWqrokzzdzZ
	+YOg3yluj6PQ0Q8Z/6kJO3EGmimwyWQ=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V2vnNSnL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tsolaKNI;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771899333; a=rsa-sha256;
	cv=pass;
	b=Avz0+WxCnlqg3HIFZUTa7WGTEC3f11akMPmqCihCAJ0WyfgpvdITLMelUviT8CfS0rtMx/
	JhRRRRVXM5RktYuOXk18DfZvxpWo5dSxPYZYBCulMaRCkqHNracHDlez5YCDgJWaQFqEDe
	7XXjscC5Ur50o47jaI1o4kuL4UF/VZ4=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NMvFE34184434;
	Tue, 24 Feb 2026 02:15:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZkYwLMoQH6Rm9KhyEB
	mE5ct8kcqfW1uRrDIINNbdc3s=; b=V2vnNSnLoBS6t3cuJi+P22ouYldZBD3peK
	SJeDorz4xumu9l0OzANVzZ5eT0KD+Il5tVzogspYbz6LEilCExrq+lsMpZSL56YW
	bM4AP4mvrwpzbdqLpON2xInEpSe1kEQcIVU7TYTRZCfYs8dVhDgwdzNp8mkA2Sj4
	4cOX2ju0j38vBgigii54fkGO3AR8lFk+dKradm+xgdqA4RsmxRUHcd7VwPQGqX3r
	XXd3ijKqpSpfkoDv81dCBsThVZ1brl7OtrH8mbtTBwcMGfFsGu+VP20lAZJP8jfD
	2kwvUvTnZiso3Yt+hRamR7tO5m6Y/h7BSiTI9w1MA1PgVprHx1JA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4rbbgjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 02:15:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61NNE9MN028662;
	Tue, 24 Feb 2026 02:15:21 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010061.outbound.protection.outlook.com [52.101.46.61])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35944n7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 02:15:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aLE/fzU5w4pQ/IYWojPzA14dlFe7GBe3Wjt0NmDUeF9ZaWjsLdX/5JI3iVsxpx9A0gstnRLJ5NdDM9rUr2iJiytWGM1Fp0bLJE5/AxxwMjivnCsgLYlsRde3bWMKQvwW6IRD/WmsnTm7/b9Af0y5vywI/iuEEI5NnANflVBHegdx/pfIA5fNMoI2Us7STa2lJpLprQjNoEsmxuaL/7r35XEcsb0aR+rxgmD7wvhDumnhg7xA/HaO+7+8uyzfDM1g2V/qJj1ttd8ycYyKpONukUorfr/gffgmmYvFv5WLK62cFm65vdX9OtZ04VXHvZDe9rXtQrM+6RQ7f5Dhv9eqCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZkYwLMoQH6Rm9KhyEBmE5ct8kcqfW1uRrDIINNbdc3s=;
 b=tmSQajDO0r84HyARGHW3NLfNqvxJ5VD34JHRjvk9KUaPF/Oa8j4yezAgJ6MSb/OVriCbXzTkx/ps9VrZ8ejgfQRD4eJ0DkBAWiIwAU6r2E81Qij4EEiqITSUbfoRgHdToWMPgjVCLsYbkxADxPj9MILFyiQDfpRnmMsG33xOdb2jrFEWXfGC+yTpTDve3rE7JfK7v9WNl7hC5H+Dj3l3h19+YtWSA77CMnMgg5mql32jelifLy9rZJvKbZ13oO9VRd3aNNVW1PKtpEQktNoSi23UoxxzOpLrlAy8RczToudVWh5wSVZMGxZRMjx6/3vadWSiD1w9TXnYeeXM0n74IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZkYwLMoQH6Rm9KhyEBmE5ct8kcqfW1uRrDIINNbdc3s=;
 b=tsolaKNIwq7jnwutKqDkJ84aivGEilJIACHonBh7KDECrvrKYBhl1kk15sBCWxVZofnh8/SueAZuvkNo54iUQG2y4QOpSZljzZNyrbGXxBMv1A++Ua9vRW2gADHwHtmYwitM/tCyqmRpPq72iHmup7s0FlR9E6fTClz4RfWCNWc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA2PR10MB4601.namprd10.prod.outlook.com (2603:10b6:806:f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 02:15:19 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 02:15:19 +0000
Date: Tue, 24 Feb 2026 11:15:13 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.com>
Cc: David Wang <00107082@163.com>, surenb@google.com, vbabka@suse.cz,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [7.0-rc1] codetag: kernel warning "alloc_tag was not set" during
 boot
Message-ID: <aZ0JsUPSf6_GKSzA@hyeyoo>
References: <20260223155128.3849-1-00107082@163.com>
 <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
X-ClientProxiedBy: SE2P216CA0085.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c6::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA2PR10MB4601:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ca1f5e6-7397-43eb-d905-08de734a8e98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O3DCdqmGdRLMyXqZVKJcdHrfhheiftWHwYz6YZLsonAaIF3a2qsAuZELlZL5?=
 =?us-ascii?Q?uyqiCAait2orbonugdBeGo1yAglpnfSFtgVCayL/g7kFxwRm0eOhljnlQP/B?=
 =?us-ascii?Q?Ca6cGEL3FtLY+2FjBIpX0ttaHoDNWNacP2Z/Sa/bBYSXtJji9RoGNWbrd49D?=
 =?us-ascii?Q?/IfbsDRYyvtE2ihj9qbFqHgOe+kucgbuKmGQcu/FR5KF886f9vfPbZLdw/oy?=
 =?us-ascii?Q?zx17tILAz9cPVBUaxmY3K95LCRGfNY3CS0EL5MZtwBlefEN/nXrpa1e+ED4E?=
 =?us-ascii?Q?SMZ7eg9WV8XpPgrS9JC3Brpma8nTDX1HeoKjjAzpvAvCQv5HTQ7QEYT+D/kc?=
 =?us-ascii?Q?zZKhTUmM++AveG1aBAPVpayozGLgX6a4eVTzuhvdXEe0QRw9bnMdXbTzHeo+?=
 =?us-ascii?Q?851CFTqP5niXp8OZ91U/SWp9rTPKyVKGtr5iCW8F/fZgaQRNnIeMDuLVHpIg?=
 =?us-ascii?Q?UY8VG7eMVD0fREuxCsD/n1hFj6X8tEcNBEmPFrlSjsjzdKfTHJmkTFpsl8z/?=
 =?us-ascii?Q?hyAHEQp9DmGZjQ+JhBmRHtteksX+p1uUjmGfwFk4+/+4IFpggTIWV5oTNj1T?=
 =?us-ascii?Q?lRXmn7kD4d2DUQewqzB13k4XQ3K4bb8ahBOtiH+KNgmi6KHkTpoVaZbg+PxM?=
 =?us-ascii?Q?YUNgFFPgIW2FCML2jCpS2JcnUlH0lH44H5DhPNo8Lvao5w8NTYqZnNSRKRPW?=
 =?us-ascii?Q?a+meiK9/B0RCWt81PzA/Opq3t+6LqBF4DdwmKi5GbkxTIzRmtLmKp1tPEonW?=
 =?us-ascii?Q?OwPj0ZVMWiglplyYtnLS97yNlBMw6EjxZ2Fvoy/j+JsatJIrte80XDFmwGP9?=
 =?us-ascii?Q?Ma6dbEhQvBPrbwEttPV9f8uWktMRKtYOPsvQDHUnUZfN+kfd6PBQIGld+Qba?=
 =?us-ascii?Q?Yh4B9yI/cgrCnEFKP58o3jbGoNbLbd3ccLGWpyEXYOXLfKxnbU8S8n0IJ8BJ?=
 =?us-ascii?Q?PjFHAhNjHx+FMN4WGeDcfdSOaiRapQFPZh3L8vS9aqNxYnUZ1j4KiNxSTt9F?=
 =?us-ascii?Q?97a9YEJTX7Llx3k51XZ1fjwSB0vJiln0ACnLcL47GZHcQRfOunoasBaJFkzI?=
 =?us-ascii?Q?GpoBuZDLagZz0bgfjY0S/6wYifvuD2ZGHCIEUy3Wf4byArDPUVCDQ9NTLgLv?=
 =?us-ascii?Q?S52mnRnmcC5iX7dbUZmt8CDl27/fkLp9VQI/vI1q+Hd8WKhi4tcSEgqkJV+E?=
 =?us-ascii?Q?EtQlpkPzwZkUBI1AuJL9wg9q099GLnzB25AZkKHS1ml7umJsdpSgHjtSkEMi?=
 =?us-ascii?Q?qqLGBS0oih/i5cbF+vuwkkWwrFU/i/J9VA3sqUyZaLeuJxotV/K3MyDkbq4r?=
 =?us-ascii?Q?N2emr4BXx9klIlbnSUMY4O1bh9W5ivlVkbZoXNNPoCdl3kU6ifi6G8dCClOd?=
 =?us-ascii?Q?hvwDnMsvfZNI9DyZcYsNqJXeI3AXto5rWj9uRL4S7uboTgqdZ4ZbPehIa8QG?=
 =?us-ascii?Q?wZW1446BMlowHdlcY6jGlwHpVBGdh2qhbc69fPNXQVVN8HGl0gP7vb8Hb/Bc?=
 =?us-ascii?Q?RiEp3bDHr+91fBfpOKPfQ1mNl87xlq9/vVJGfLohDFdrngnyYD7w8tZqztu2?=
 =?us-ascii?Q?fAiYzFd1V0Q2x6UxCNE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qgxaXx7sMgMEN2I0GlZEPdC7ksHF+1jlt2AT8dHJxaCQErj15xKQCgWdRTog?=
 =?us-ascii?Q?MJpIHTUsvg585sbMtFdRKJLCTgrzziTcZ5BHaJNulIauTRitkFCeUiyeoInH?=
 =?us-ascii?Q?zQLsFC+bv8reDzDrBsyJdkAkYqXuPQYEh5Qjo/gHcPbNFXmgHWDqIVFIYjIO?=
 =?us-ascii?Q?hLuLVvf2vRfNQiXSOfq+f0h/IYkMkBu85N0cALN9UC6E219PmzjVZzo4T1u4?=
 =?us-ascii?Q?3K1y5oci4a/QzRJ3NrS7Br3dbNw+iZ1JIB5XPNjLNNUwBwArW0dDALoXVuH3?=
 =?us-ascii?Q?GZ9YYmqVcPBAOQAfi8RJKfI6GL6SPjCu2qJebqud2cu0e8OS1bfBJJMjKGj3?=
 =?us-ascii?Q?a8pzlsgDe+baltUGPwcxGycwjU9B+r4GdXF4OMZUbxm/fGfdT7hZ175dV842?=
 =?us-ascii?Q?3A5mImoqxLxZgXVYqVE3kvVpjuJccsQ1NlnqDRUu4KhddOgpI+vznnf6XoyO?=
 =?us-ascii?Q?AYtxPob0as5fQKzGMesPUZgJg/FUZIMDLFZa0mFGiPmzAZ7ZgcjVUoafOSAM?=
 =?us-ascii?Q?HZjHdbm7UsHL9+2q6tdm2QLkJjC90uPSL1nIMqmm8p12ZmajE/WS5IiWnbrL?=
 =?us-ascii?Q?+GtBaA/5gZ5CHWly1dW4q8tYiqsexBAdTiGiHBVmCR1G/C0qQFrLsczXW8Zd?=
 =?us-ascii?Q?RIOYQIGNGru4g269YrzeQxcik4gvhq4rxoBBEIdzBHwSdQ7isoqwh6kj08vC?=
 =?us-ascii?Q?oSFveF8Hi++vkQsimEoEf03xrZ68PwkXrjRvXbv/JGxObZjTSQg6VjQ2thnR?=
 =?us-ascii?Q?v92RdVxO+IFL0SkuPUOHHfZf0w+kowFqc0+eTBF/Ijh3wUjJ8VSuCwPqfQ2X?=
 =?us-ascii?Q?GjBAL6g9DE6DVo0I7qK/amVVfzxD8gOmuTdW/ipLyaMajMcG2hPDaCRKUa2p?=
 =?us-ascii?Q?s2uGn+MifP0Xnlc6+1tkc9xfukm7Ty63tbQFrVJrYOrGD2bseP9lII84+a0A?=
 =?us-ascii?Q?IVThGBeWU/5dj6ScYww+Dr4QJU8WeA/gzev4Kgg/jb/AEwaOYEW+osYgyiIg?=
 =?us-ascii?Q?xNhX1fVJptsNhV1t7eEJtsgdyiO+XHYa5v5egn2NccRDDAqwuu0uJ9saHkJa?=
 =?us-ascii?Q?94vgCmecOil08vgK052mOOQjwsZtsSo+gxJNhi0IhYqBW2gFV2NJTJneqGSP?=
 =?us-ascii?Q?EMu12mq7y11zDXwhEJSeXr5WvK/GFSDbZDq4b+e4zw04+OGPD7WgkCXn75E+?=
 =?us-ascii?Q?u4WAbVEsPjX0n6rfQmjwh8Kxr/prbMxWe6r82utdq+bE5jI695Qp2QkiuUcY?=
 =?us-ascii?Q?T9AsTB+pZUF4cYd2xgCc8LrmR6vrwbY2eAFJGA9wF0OnMBeSL8VYFHMiT52z?=
 =?us-ascii?Q?HmymejEGOrUIcOr+pcS+AyfDbkn66Ghqws3npYPQdQlxG8Ekq6Sv1/DLUUoi?=
 =?us-ascii?Q?Z6rGmJy6Dw3YASwmpc6NOH8xsbOcdcYEcCwUS246FPqw9AWpBQ4ypQxpiu7i?=
 =?us-ascii?Q?oLiryF2GHggSmvVfdEJLkt+DWFJPoL8+kVk3n7OEc3fk3isKzPQF/XjCzA8f?=
 =?us-ascii?Q?UmNudG90/OAQWFU5lO32Njiasmdvh0EbIiBzZUqYwxA+WwgtJkc3aPHXsJRH?=
 =?us-ascii?Q?dae3D1sjb6eMjKVG81cn512nvvC6Kr/PFp1kaRq3ucZ143exnzwSExnOpXp3?=
 =?us-ascii?Q?H8uC+Ko7oDEjpWV9FjhfuWd+8jhrQSfqvl2xleAO/d0E319pQpEY9Sw0COYR?=
 =?us-ascii?Q?BUQlXQtT/wWNxfSCdFJA86dP5eRG6Wxx5etl9gSfDe7eJsYV57h3zEbKCUOQ?=
 =?us-ascii?Q?NWj72JM8oA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7s6j5xlkS97896zI74yOoEhbhpqJskpluOlOf91VZA4Achce6IMT63TwI/r52P/DvU4CxVcheJiGFZuveAwLGez1lU7wr6u9CpI4TJBDQkZRvaEtVbhzEzf75cx2T5/VNs7GVi/Y9b3iOGp6/duH4gu3JYJY2sWJiaPs4EtQvgHP+slD2+kE/ATLUKf7n7uH0H0sVk7ASd3kBq1zzfuEP1XqgtpMSnd6npSzh/mSY9PJztPcakZtI/4Se48TAJG1S6ERp5xOr7iInyymgB/nD02+twdgQPUHRcJ53/xZRhV6IIlQZwVShb7s/EHSYMYwMPxBUuay97g4kMRPnRXIfg/RVdMx8Z9ZY9zLBXsyMOr8PMHn+jAcfsitZmYkBZtopmZRcVzPYuhpHLiFZ5suzHh2PP63EsIrMsekNpkeourHcL6ZVWjB7VXARnX5hEIPvTiNxcnf+lsK8Nu2DKK8ub3oqBklBLUEdk3DT+fH/Wb+xPxuy9M/i+iIXBqSxoiubmEo5IbOUPpsRG0TcNYfKie27hMnSrJc7CH8t6rJCyKduVdK7fzpa0HDDM6EZa5VOFkUGoQ1iQaHRa1s7sEuLgcIAQcltA7TTaoXaGY5q/4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ca1f5e6-7397-43eb-d905-08de734a8e98
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 02:15:19.1703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pHroXEYJULsTrkDeCIcLddWoPA5IJYVQgdRstkFD4+1TtPtEcgvuyX9i/7hD9oJxfg8nOYuSn/1PFZK/rBUnaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4601
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_06,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDAxOCBTYWx0ZWRfX1iWecVliQ32l
 93FvtMDZuIzbr+6M9mVHz6DqElUTLnpNuM8Hb9K+pnx7O/MAnko3PKS7FplRzehRjH4IRhl0kOa
 CahAkahyTo3uVGT3DwlpTvseH9pkwMMm29/xEGUOo5wbCIh+3w+pm3O18OH8YKyCjoLogaeGDQR
 ZiJryuoqJ54q0UPeqQc4vGj1lm1+FIYmZSwcCVQqbg2uKEjSOkvPT7wvp5+19ItSIWRa29VjudS
 3a7RrxuaxrJ0tUj7oEV8X6AsrLYuw4Lr2mwk/0z8vFVb4VnxugPi6PaTSQ3K3KZCQstQWdXokDb
 7uk9my2RaqdzYIAuDYYVmnbKohlCf3fgOfHXughvTOcGAPfw0ozvQpjWeUM7tiHn5sAYOTrx5hw
 Im7+N0jqj+oGkys7YWcmLno7lMSP/ZkavYOin92qLj7k/1wb/cRVsCD9v/QtNeb4CHL9F6Re2uq
 ilWomc8+u0iORwwh+Tg==
X-Authority-Analysis: v=2.4 cv=S/fUAYsP c=1 sm=1 tr=0 ts=699d09be cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=-pjvtxRF3TPFy3O3nmUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 2vPSIuWMoHbi-JOXsrHOzuqDOZIQfLIx
X-Proofpoint-GUID: 2vPSIuWMoHbi-JOXsrHOzuqDOZIQfLIx
X-Rspam-User: 
X-Rspamd-Queue-Id: A699D18000A
X-Rspamd-Server: rspam02
X-Stat-Signature: smaeem9csrjzb5ezzqqqdy3h4q357te8
X-HE-Tag: 1771899333-85803
X-HE-Meta: U2FsdGVkX18lkEUdeiCOtt4kbGMfmZE36dQ+F/ApNAVtzuQax13KMzuXnCnA9Kk1sQqhJ/tbdXhqZsTnJIFVUgx471oQHh34XUyuzQRLcmE2hQudV6GXeeyYSIlxsltCmKuvaZfVOht6JR+CfdEe90lZpVzpux7m1GPzri3JuWWFr1tjEtXDW/mPv0eGVv/drHLb378cnQufUDSE3gfvhRf8vDbYbz+ye93OXlQpkgOTH57iZx+hFMBszT4ROwIEQ1ZGY4sbu5HbNEiKpotsQdpXiDZkqLdf7Ag3lApb0abBHBujPNDw2cFiWopE2sqnsfcIjjzYh3jwkyK3bVZs19g6HagloZduXGxEzXCH06U1g6xGFN2mlVCvUAVJ7SHHwGyksd8SJu1sjmpn8vcdjWz77aSU1R1V8PNU307zedjQvs02IldMsI6DCA7W3CxnaJ9nX2NcTPJ0I2YSCbeqlpcahoJHN4Y5oMgl9Vre1d0kK2PzRwRXfSbanlItfzcl4GhQtxhoaj0KIuJEbqg8Yn1rXRcDqparXHB80IiBG0ReV1JuiJchCkAP9vMcp7P+0f+8Kaz3oKf5QxEQFYIWp3d8Z8ymPgaO2laWtITIGxjQb9CpELTM9bTZas0KluqQykS/+ktbTSF6yHf6habuSo4/b+njDGS0Jj9qonRcJNFajM6QyjO4W0hbgUH6Efq1Dk/jQJYN1B+jJuBxOhsWC52lcgc//wxP0mISboFhOjIfhGznvSGVIU32cWan9fHTyve3WChhTjrQUAQp1WqtCxyfwmkDJc1/zDWeFR4jWQLVRRujJzrrnuVx0qvsxTW0ysZFNqp4I/f34Ixrnv0Gp0JwSJEtjUcwcv0e7NzTtcpsIzP1QFxDfevuBruUSdyHKpVJ0tdRLApvB3Wat+QIDMb0mIU72mmQele4V9OA7UgSXwhLPVUcMKQA+Sb2b5i3TjhvJ60W6UpOYPnfVLE
 UHuaOze/
 H6MTci9nAobRP5S3GZ1lS8Ctotq8dXaIoeeAC0AdfwfikCRbzVFOqJU2Imtek3ryhYx5ZBwNl0DJwb9A2zoe+Nmi4BEj7kZtUYYmvsHMW/BvGD02vkgAg8XCaMBHUuzxjABsVDmed/nuJbseayUmO7sSthyt070hrQfo1Og4Fur5TCjTsEVt3djTDER4kKr7yVpPNh68Whb3f2urPSJSpOJO/jB91697NdrB4Pqod3ZJ6unXAsHBiRpA5ngfvqiFemW9//QWvNQI3IJJINGxIBYsufWvlZmxyFui/4www8aNTJD2CcDwpTP+tXV6wQLh58j1FsiELj202GDWg8wfafaMX5N+ricbS2xIgPHDe6UKhAYmu1hPSQWlg+413NP/bYda2FjmppWaeh7JgS/T3Gp8Hilb1baPDvCx21sK6nPtY0u+9S+vIFk439G0n3VlK7tF+WRyW1X26+h7Qknn2T/ildpjWdt09Vkef2lEoUOJQaY16L4rOERxzHDElus+RW0bZyp5RS9PiTDbIDAkxGkrTvtWvLTIktSCVL0Tjygj3U+DKYZ7NOaJph5bfRYDog3oAUqahKhG10SfazZU0egMeBwxJcEFVLn3AxrU9S0GLnBc5bN22u6MDnTUw1rFwB8xAxHevMMNSI+/cEoPSKJsd3eTX+8gAAXJeMCmKTaidgwNBOaXHwB/ER+BZJbzRKWnu34N6LqCotYkQzqb8BRqu6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 06:18:32PM +0100, Vlastimil Babka wrote:
> On 2/23/26 16:51, David Wang wrote:
> > Hi,
> > 
> > When upgrade to 7.0.0-rc1, caught a kernel WARN during boot:
> 
> Would this possibly help? (it probably shouldn't but let's see)
> https://lore.kernel.org/all/20260223075809.19265-1-harry.yoo@oracle.com/

I think it could probably help.

While x86's TSO memory model does not reorder loads after loads and
stores after stores, the compiler is free to reorder
READ_ONCE(slab->obj_exts) after loading slab->stride.

-- 
Cheers,
Harry / Hyeonggon

