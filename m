Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF628CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 15:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7E168E0033; Fri, 17 Oct 2025 11:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55908E001F; Fri, 17 Oct 2025 11:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6338E0033; Fri, 17 Oct 2025 11:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 936398E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:44:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3FE7A5708E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:44:49 +0000 (UTC)
X-FDA: 84008029098.02.381DBDD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id E42FE40009
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:44:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fAPZjRMp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Xq65Sdtb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760715886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsuN9qtiaMg2A3oI6vainAl5LH7cdUcqS8IA5fqX30E=;
	b=K7azphk6O0lJZQhWnHd0HEehH2JCepnUs/AK8MyFOKFysw4zdKBpXsV1eEcybhYXFv2det
	Su4A/NwQJ7pJblqnbRTzGm8cnD+xnUIhhzRNK9aOZCprOPp2e5unwruYT335pwM4rAWeQT
	h5RP2mcxrR+qZrgMr3TfUgBpKoC3k1k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760715886; a=rsa-sha256;
	cv=pass;
	b=elY9GHQqPGuIt0cW6vjqa23H6KuRR5LNEiD6P3dQtyG8m8hGppvjmteaqITspTDXak1qTz
	blZTmm5Wng8i55IXslQpBR5jCPcEG+5TEEQ8X8szVA0SE1K7UliaXb4PXcTTLlZnUMzCGk
	NAkUd28Ke8Ty0lDE9TOwL/KHsLjzbfM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fAPZjRMp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Xq65Sdtb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HCdfWn021125;
	Fri, 17 Oct 2025 15:44:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VsuN9qtiaMg2A3oI6v
	ainAl5LH7cdUcqS8IA5fqX30E=; b=fAPZjRMpfgfr9Ijb7ZbBT66SJzY+WyI8GS
	jU2ygr4qwC5EzvVPXkYf+9YNnPPWEO0sRMqSH5QkqtIDmMzOIH4nUCeWm6X0wjj3
	Rf+svh8apyJtN3i9c50tIzgWxZzH2anS1hqb0fECSz34cgI8L55+FrTIK70wR+ts
	FxaBmDeagq+PDlzFjOKs4CPryXa8ld1dLwYSPki2NjN9OI7oIQPe9h9Xf0y/hCwl
	pQo2XKPc0PO43Txu23ArJawR49hl23WPc/dXQ1zo8FOzoL1yBoEJbUh4MK6FIV7Q
	AZrRGDEHQprT8U+8TjDBWPvvBUvHdluwOkUfi8vqilCFAnrfB7fQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ra1qjab8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 15:44:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59HDxVga000767;
	Fri, 17 Oct 2025 15:44:38 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013066.outbound.protection.outlook.com [40.107.201.66])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpd86cm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 15:44:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U23diHjU5rxrnMGkFzjZHPpF2EKMzsJnUQdVE+P07//wnxpMyJ/M3XQE31Be9aU+tuoknQN9j6URHtgUq8xFDzwkGlk+N9xmyLCZkg2/hE6zyxxYaxkg1E4YBijTd/XrfxbrsOHqyvQ08yfDhESH5QLbARZzwdpIFB2GBVbSquhhDE1N3uuqZoPTGwM3EpCjq2/Dx1f1xRhuOeiMrh4Ps857ysw2DusRPaw/he3VSguJVfvaPrbE5dwlBRKS+MIxPs7kuHV9497seLsAzjii6va1lICGAW0pq94vJFqeKAiQk9MQQhfTQVBm0I6lUhC2/FEeLZ9ZXN/AbsZ+1wXYvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VsuN9qtiaMg2A3oI6vainAl5LH7cdUcqS8IA5fqX30E=;
 b=LjwBpW7DKpUk3ch3w1uOsB6AU/Zq0mSKPcWN59GL3qdlD1xHlntCgRY2U3YuGA5BgNrYvK4Wj4AkXMLv63i1C+LrrI0iLN1TIlrkE5FEe//HMggQjHdsa6xYHUFFe19qRs9Bbwx7ILWmm7zZ2ieAGj+jPpiTGhQ0DIlSU3F9ZC//3WqFU9/0COTfc95Kxali23RC3t3Aor/HfynKji6iJlINqLEUGuaX+VSSiMoVJqOpb1VFY5iiWwPRqD0/EtLXVcBToZLuYcKs5nMolu8+XBhcBEmFj5dyycxvDuW9/WdISs7jE93Nnqv1Eeyw8sGfUL7jvb0Rh/tD3yPB1w8PLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsuN9qtiaMg2A3oI6vainAl5LH7cdUcqS8IA5fqX30E=;
 b=Xq65SdtbPoAD5Jj1UcdYPRQdOpViTk8mEK1RPyRjdCenNJPBrCAr/NP+uMgrWuLKeQduWkpg5Mt1pB1U2D9Ksx7vyVeFAmo7HhkUbO01xxmjyIgPd6CV6WKSzeJvFG1c8Mz2ys8BCY8DdM0bot97vSPAnHspE02J0yu2HcAz0BU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB5197.namprd10.prod.outlook.com (2603:10b6:5:3ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Fri, 17 Oct
 2025 15:44:26 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 15:44:26 +0000
Date: Fri, 17 Oct 2025 16:44:23 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: guard is_zero_pfn() calls
 with pte_present()
Message-ID: <699b143a-cca4-486c-a4ad-d0be561d4ab2@lucifer.local>
References: <20251017093847.36436-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017093847.36436-1-lance.yang@linux.dev>
X-ClientProxiedBy: LO6P123CA0036.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB5197:EE_
X-MS-Office365-Filtering-Correlation-Id: 87693c58-2975-45ca-2f59-08de0d940d99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?swZ3Tu5Lzi5l2xxoI8ivk83defNjas6fK8N3CK/Q6SyXxipHJn7FooUriNDe?=
 =?us-ascii?Q?r5u9Ia/eEYoP/bXUnViAjhJWvgZoEeWhMq67L2AwwUozAIQ77mKse9stx7um?=
 =?us-ascii?Q?dereZuSqYn25yU/mRhQkSyH8ptzAcGc2DG2WX5+u52/Z1RAtlHVrfmbXJr9j?=
 =?us-ascii?Q?XTSKC6FxGhQaDJhFv/RQGJxyeEYmgL6iYrOubJTtN9P08o7W0isnjq732lCk?=
 =?us-ascii?Q?OI8WRbqxUsznF+jMD5n42/77xeL3iYzTgEu968j10xa1w8YL60Gc4cQzuUR8?=
 =?us-ascii?Q?JLeeI0kmRgFhjuQUvFcM2QKWpg7Jjnsl/yWUnr/Qzom72i4Pg/SHNIMsbWTk?=
 =?us-ascii?Q?AFFytvxwh6iomhiP38mu4YtnQkBYogcMTgVLzdYarEXMdMI1zpipsC0JfuKK?=
 =?us-ascii?Q?RsThNInw+p6FAPaNseG8mU6vNp99JVPNV34QcwoVsCRrhC+6MFKMUBwHnKpm?=
 =?us-ascii?Q?TmwsTmWgobQqyC2ezKSqeWIqRzXSmkzth2eZRIrlu2c749gUmxv3NpsJ0g8G?=
 =?us-ascii?Q?fWXLEYGIESTfNJCMM7Sz0qIT+f7ADxe4Ptdm47EDMYaNdEvJ8YAEC/w11lD4?=
 =?us-ascii?Q?+VywRhZTXFRmfrFxIhktd1hY54EIapnxcGOTxKdP06r4TA0HdMbGPUhc0OsA?=
 =?us-ascii?Q?djJkfWssQiFwj9j6GqLXCZiTSoIVrRhv+fL2A8zANlVhDnaCDBOKkRzNIuxV?=
 =?us-ascii?Q?64zEihvjfNoY3ABPurWd5NMe/I7TmeZDl4FMtzggQWrL9FypYILXDy0/Tjc7?=
 =?us-ascii?Q?DzgZeH6b5sQ4qHZKXgHvqeC0l3M/o1TAa0zsN2fA/5W83Zomy7VdxvTT3pLe?=
 =?us-ascii?Q?q7QIAD9N59OxO4pGifD+EvMG/UtsYai+MaePldtSDfzNQ/GP2X3Eip8NHdpl?=
 =?us-ascii?Q?NKLud7Pjph3YH1DgRkniD9AiH/5cEZsM2rp8LwJ13DoBQRaRLtIwQD7F5lw9?=
 =?us-ascii?Q?2v/JqfZ4TCvVVT1B4m79CMaA+tEm+JeCs75KhxCnn6h+NdqROJkbcji1oUA2?=
 =?us-ascii?Q?OMp5Ihh3fo+E7Vn41OBNsnznyR90rXxxy8PbNQpRZ1b8wH9NsCkUapfHsqmQ?=
 =?us-ascii?Q?Np2RQSAecnVK0MD4IY51qP2+Z2EBzzzxyBt48yFDZfj9udZskeNuo+F3j9CY?=
 =?us-ascii?Q?JsTBX7vwj9sEwQN7vrMHMWx1aWJr78yRhlaDHpThXR1VWBgXQY0bG/YjAl4P?=
 =?us-ascii?Q?MuIv/xpP32sE0tLR176BWTeNm5+cVA3lgRGMN4p6zVpVu7jksk/QU1St4fGo?=
 =?us-ascii?Q?4EGpvkshfVA7t8k0it/JymNXvVKjjNeRKwPHAaZWWJ41A3BVxcMjvKTTgKym?=
 =?us-ascii?Q?5YwASrK6SBSXdGW3DvpfrP2pDl+ValtQBA3u2RJDRbHHOlK2dCYV7eAiHX1l?=
 =?us-ascii?Q?3e4Q9G2dy5wAHbsyhmGnOtWqaVc1oHsA4u8o67f9OeMQpbYgPxEGfH4H6py9?=
 =?us-ascii?Q?uyqcrLQbwosJxETvXfcDUvW+q4SsBBpbWhcnxRv+7+u9iM/OBelzkw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0ZqMUN/5Jyi20vtmN8aIoeyrPxjPLtcmNcP43S4s4vbzEOcTWu8MDuh3pryD?=
 =?us-ascii?Q?9TcMtR0iM38viJK8YyX6M5/6doh7bN1bkbGKXuLpA1tz4yhxMkI4vOmk22eH?=
 =?us-ascii?Q?9kmcSf2WfD7q2g/icRFr6rh+7/RNslyzafvjUvpEmHFZTiyQ1YVykKsd8ukS?=
 =?us-ascii?Q?8R93qTzZ9OnGPNyBuHEVYVxy7SL5sGKXBEzEpW4RDJgmMtJMiogDlgaKkWiy?=
 =?us-ascii?Q?sbrPM9ffmcb+z1d9k7dSNxzwUfNDMewAQ7ksTOHDFk3y561k6DY1uW+h0KBK?=
 =?us-ascii?Q?QGEI43ZHdPN5JWDeodp1tWVe7DdVR2toLtdy4hFZKdvlnuJ97DcmjRNG2bTy?=
 =?us-ascii?Q?VUMLc1J0nY3gt/wBb5q5AgrX3we5CH9sBaCFjeOrVE24fNx6PiUvoe7h6FjF?=
 =?us-ascii?Q?GgF2ZOsIFIJoxMYarRmHSLQOrM8mrcWWdyqV4Ofa1WzjZxNJgfb0YeCKfFjI?=
 =?us-ascii?Q?T0gWvx88em6yapzWjRdihXwVtctir7RdUkTUI1Qv6zFHMKu683AZW+3fn2I4?=
 =?us-ascii?Q?LpfvymghQDYQuU3+GPwAa3e7BQzIPngiyb689txLWlaY0b4+fPzB5WVwv6dc?=
 =?us-ascii?Q?t3UF9PBXqDsxfo3lYXNNQsZY0bVaUIsQEgRWX3PL/aIdNtE6A9AETeQsc5Y5?=
 =?us-ascii?Q?IXoF1LOlJ0KNTKHOLRG7EShf+ct/Kt0drdYGgFZOb0kKXqgvSlzZAZrmz0D/?=
 =?us-ascii?Q?RrcqjlYgdz63+jjszGqvN6kLu8jNJ9nYJrK6X3IRDOJ2l7AiPFNhoN47hMYk?=
 =?us-ascii?Q?qol3JY4Q/QRQKtQUSeHct7IOSWtAozgdQQKlc5pe2vYOO7x7gDsbjEGPGv4R?=
 =?us-ascii?Q?yOoXkySIWt7EBVIIAmBvZXn2mDMc1u6Xb2Wy/qWKcdM2F9NwZkQJOUxZ5FJc?=
 =?us-ascii?Q?lc8CsOLXYmnJT19GDQESgsfatxmrtqSMcn0KnYWzQiV/e7GZNy5aoET73NPA?=
 =?us-ascii?Q?37i7lqAMANIg5saOhrHuNAoLYdPbzqtdCVsvzmn5HTkrOb8AAOgGpopcAkGp?=
 =?us-ascii?Q?37WXdII4yLq9HgIWLGg9U26R926EDHsLVuW4yvGW4c5WgLOJlQgUa97KNUk6?=
 =?us-ascii?Q?Zt2w22BEdlgALBx0aDf5J0vEa9/O+qhK/NWuFZ+2W2C2yI94ti+uZikp8cAK?=
 =?us-ascii?Q?zS8OwmXTQ80UMX27fpitMnutYagEB/CwY2kQzHCHCjfSGJDb6XbDt6opVl41?=
 =?us-ascii?Q?f1J66cS5IVUhnehsQs9iCdsc/VZVUIpDB/nziazqqYmNmYXVe1tFnl8TlcjN?=
 =?us-ascii?Q?Z6DnvgPWplSbpAlDysqjo6qNhBoTxdQsNjyZwAiQ7cz+uDeisvmCaAJwCvfs?=
 =?us-ascii?Q?RBFcFALXM6Os+Yp2AVcw+WygRbYLi7quaENFwGIdPx1aoeXQEDhC/xRbS72l?=
 =?us-ascii?Q?DkFDOaQCsdlOK6q6YQOPf9DYI/wJQAJSfS2o0jITd/XGK+cdAmo4s3OjkFbD?=
 =?us-ascii?Q?3XtemDAAzlmbm5pC/Y0j10ThP9zF3TWunc2lzTI/e2wnYbZ2d7mVYS0WAkjH?=
 =?us-ascii?Q?80SWl+yf4ROPhvbiEWSrzZg/3Kk/QHvWBK+5HzEvXJAwwYTYRSLoV4zILHrh?=
 =?us-ascii?Q?4rHx3EO3XtrFXRWADTzFpdckge7qoGZzQ+exsGxn41rMx8TTReiikYgG/9zb?=
 =?us-ascii?Q?+w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9SFluksMBpZJPTk1DdIn7r8ieADWTtFG8aNDWO7LVh6VwW6B4yYqAqk3Cx2xAbOxAtAOS2v+Ad6Mmk7vJhF+q2nPp9Y945b6jRUORUJx9DN5w9JWqV1doJAULTWGR4LcgQQVa6ps0Nk/1wWsN4BdX+eLQ6zRTQiNUN2hk7YIofPqJ6bGrlm45QupOG26ithOjmxDOw14j5NlBSb6db+Zatk+KCV55MTmKH9d99SbHNl03VO5TYWAGdYFrznhcH4T8txomv47EBG7+v/EVffLmS0Erib5tFS1dg8z9tV1ku/Kdw0smtVUIcT0MFfF4qt1cXgUurOicSyuzHNIb1sBNs6oHSMqMHeh93/60belR3+/xz6zNu9tki6J46a74D5IlFi6NRhXaIoRwdqX0wB4zVAAkDLQkL6cP9jWT2JTSK2NFelu1TxtkgoUsPwQuqLlb0q8CnflWDfUngdDma95bDyIG4zxtjTUmWD1wM6w7KUr+9grlxt9cDG4zVTspK19FTX+wHuIwPfGU9jBUvaiv5QsalYZRMOqm6nXh30eygBQcPud1xth0KziGBfNoYXhgex+CPtOKitYF9t/ltf1C+pq6yXyymfzNDs0FDxc0BE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87693c58-2975-45ca-2f59-08de0d940d99
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 15:44:26.8280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g+NLHglTs59ZzUNyWyUzzam7xTH/Uc8sjrNFwfHDs7hRujznZjqpMPAOdR8FKIOszD9AhMlk1sJrsewJjUNlK1smj6sjHzqaq4DdhfwF/5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5197
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510170116
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA1MSBTYWx0ZWRfX4wtaqoJDOR4m
 OWQY82s8u8hdtyS9pClvtyNvrJGXn9nWJIc8KorhKXh87CXPa5Myhb1ci6ORUxyncU0Yzv2ItPP
 dstW69LYWi6STEoDS18s+ttSHK3I7YD9wrwSuHVO1nVQzklri6V9bSDPIie/nLXaaD40W2vr2ep
 GHEjBlPd7dIsRZvM3hCtX13lYpntdikDXKuS4sCIs/FqaCtZtlkQOXX2AGWX5xNdPpaWo0AQWtU
 aNQ+xKRdku5ox0phCt1X0LruMWA2IJ65BKSNoJY2yKmlSSW1tXQWARlKRVEX+NM/I6V1tH1TnIV
 DqLzu+2o/rgWek0C8E+oq8g0FLwJ+63yXxnGSfrMwSEtvu52FhhH/UI8E9NvVwhBlNKEMRr+bo0
 6M2ZULr1L+EZCA4WwYL9JEWYmyFH9g==
X-Proofpoint-GUID: Mf1p8d08G3VBT_0TP2juSFSWrTSbZOvQ
X-Proofpoint-ORIG-GUID: Mf1p8d08G3VBT_0TP2juSFSWrTSbZOvQ
X-Authority-Analysis: v=2.4 cv=GL0F0+NK c=1 sm=1 tr=0 ts=68f26467 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=7CQSdrXTAAAA:8 a=SRrdq9N9AAAA:8
 a=pGLkceISAAAA:8 a=MABzVc6bJVNaSsDO9jYA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspamd-Server: rspam05
X-Stat-Signature: p3aofu36d1d1c3rdnd3jinydumz6cz9h
X-Rspam-User: 
X-Rspamd-Queue-Id: E42FE40009
X-HE-Tag: 1760715885-922390
X-HE-Meta: U2FsdGVkX19TRDFsSRj19wZWZNH8yt2FbFK+xYT+hcHlKTX/OFidq5OtBfwrRt5fgZyrhxcq89oaH5bKp23wvAk9N5i78bwjGbTqLtgXVnLuCsw64ctGOWzqQeI6y6Sj9qjoBbt+e3WpjOif+iwUl7nANAclARYmfPDWhg0QbBeS9JV7eTjwDRsoNHIPBnOramHT/PQweWQVWZPqfxGvJhkAsFrgMofiEHl+pQj1QqG0awCCFWp53omYmRAgV/r6Vh9/hgVh+2pxgXXgGhSIk1XF53VAIlmY8aeVYP9Vrc8VCP5YdiMk535mRJJfwOGQ3RYNRwZtV+pYOH9FW2R2Zyd1/8HlOvzzfFa7mmXtrR1MeuZig9BCY0KH6GvMXutLjF3e9sWuUPGUXg0o16xA7F0cQbV8aJoe4CqtYFLmWwEZYgcmuXBcmd8a45enkjTOR6uClt+AqlA4Yu4WEQsP4rz1nVDfTHrDloJ9A/xUrWkNrpScAKznxENgtKFEDHBE0w8f/+DE2R8KU59h2HKD1z1C4n98LEiNccu2KFrjjpAQbz9Cm4VgNQ/Kj7731S5cdKLMm/m79VnJQl4o8OFCmt8ewls2aBqxY2DgTCTEJzPpvZd1ABxVDvTUrtEHJupvKj65E53sCWAvoEuzOcQyaW2JKQ3nb0qGwF21IIJOXVGz3LWTDVcGRGrR+Bs4tZaiqgAwvnLfGS+KE7BPt0lc6wQtkbHl1I78sQ6Ff1u+e1uTRTqy8eGYx7pVct5MpeJ+IinkhY/pkSbeTOVbFhcrIaxvtpyToMH7+JcPrIFDUGEHlf46ygjSPKdNGIhj2dqb8fYWpe5iyK678LH/TuIchAmzezWhA8yqv1ubYjQaLV+SQ/FROZgOefve+yQ+q/PHgfILEpipS8FL6iFeIdOjC4qVbnuhhUUvYTCspESfuAPQ72o+ga95QKTUgSc9jBwNOMnmUoRaOmO5LLhGKzx
 lK8iMrqj
 yAecN+Y6saZe4t3UD7xGD0tVXPQ8v9fKxEWbb8GhUm55h7NrdRP+8xCZ559WQukh/gvOYP3i/MorzIVzFrvnYv3DWIzNwjL4qfdS35JLxJbq+3VVPbBiQSE6cGqEGF0VFqeFpO/nZgmXlVwhrwP6zV+3mO+WEB7he2dwrVADkf64MCLiKD5ge4xAe0w0HuzRoWji5LK2GKY5sMwolnNtEx/kS9ZAMypIWLqCSdh9K+ECigZ/OlYCdI/k0r0/hFbtYqEDVFlZpcLMJV869e4ZvtQwznW3HX8A+5NpxQAQyVgTCjylIXbdN3sa3lFsu7DNYSpj4XRjpYlnTqokc+E0NxUk1VXNSmvRxRBGnM81vsLOOvWn1IEhP9ptA/cczdEqg8lrNR6G9FUIU7P6n8dDOgIQV8wfqyQCRO13sSs1c0zYstlolKpfsEAy7+ROcC73gxRtV3ZciB2v60OdGWngE/nNPyqKcO2KiikBjPHDp8+VfkK3zIiAx+zQsC9Q/ynnHogWYXOxGEUV5w6VagOnYyN7gOqI2MDsGs52uy3l0ZRhsmtCCH64BQYx3EJk/VGKer8tb3+Ku1BvfHUh/wQRdmQ/OgdbH8/hIffsLnct2oESRCy9yQsNiOpOjgzxHJmIKrC95rO+U5BPNqPieZZ8YCNIQRRFwSSswg4IdVE1BWtSjchVf6h+HDiE6+vwiPy0r0wUSTX9mjtK2hzdFTQtJbnyYgNQgkgjSxLk+ouKA+Sjd7075rVIc+KgGNF9D6lkA62uaOHPjKTZDEB6cRgTBc1xNGZPKDnDifA91SlqgV3Y23rrT3tVF7MLdgRDKyilauABFnYsYpIk1qDFLKVfUsGGQOZAAm3Ke2+rB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 05:38:47PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> A non-present entry, like a swap PTE, contains completely different data
> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
> non-present entry, it will spit out a junk PFN.

It feels like this somewhat contradicts points I've made on the original series
re the is_swap_pte() stuff. Sigh.

I guess that's _such a mess_ it's hard to avoid though.

And I guess it's reasonable that !pte_present() means we can't expect a valid
PFN though.

>
> What if that junk PFN happens to match the zeropage's PFN by sheer
> chance? While really unlikely, this would be really bad if it did.
>
> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
> in khugepaged.c are properly guarded by a pte_present() check.
>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Not sure I really suggested something that strictly contradicts points I
made... but I guess I did suggest guarding this stuff more carefully.

> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> Applies against commit 0f22abd9096e in mm-new.
>
> v1 -> v2:
>  - Collect Reviewed-by from Dev, Wei and Baolin - thanks!
>  - Reduce a level of indentation (per Dev)
>  - https://lore.kernel.org/linux-mm/20251016033643.10848-1-lance.yang@linux.dev/
>
>  mm/khugepaged.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d635d821f611..648d9335de00 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  		pte_t pteval = ptep_get(_pte);
>  		unsigned long pfn;
>
> -		if (pte_none(pteval))
> +		if (!pte_present(pteval))
>  			continue;
>  		pfn = pte_pfn(pteval);
>  		if (is_zero_pfn(pfn))
> @@ -690,17 +690,18 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>  	     address += nr_ptes * PAGE_SIZE) {
>  		nr_ptes = 1;
>  		pteval = ptep_get(_pte);
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +		if (pte_none(pteval) ||
> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>  			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
> -			if (is_zero_pfn(pte_pfn(pteval))) {
> -				/*
> -				 * ptl mostly unnecessary.
> -				 */
> -				spin_lock(ptl);
> -				ptep_clear(vma->vm_mm, address, _pte);
> -				spin_unlock(ptl);
> -				ksm_might_unmap_zero_page(vma->vm_mm, pteval);
> -			}
> +			if (pte_none(pteval))
> +				continue;

Yeah I'm not sure I really love this refactoring.

Can be:

		if (!is_swap_pte(pteval)) {
			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
			if (!is_zero_pfn(pte_pfn(pteval)))
				continue;

			...
		}

Doing pte_pfn() on a pte_none() PTE is fine.

Obviously as theree's a lot of hate for is_swap_pte() you could also do:

		if (pte_none(pteval) || pte_present(pteval)) {
			...
		}

Which literally open-codes !is_swap_pte().

At the same time, this makes very clear that PTE none is OK.

> +			/*
> +			 * ptl mostly unnecessary.
> +			 */
> +			spin_lock(ptl);
> +			ptep_clear(vma->vm_mm, address, _pte);
> +			spin_unlock(ptl);
> +			ksm_might_unmap_zero_page(vma->vm_mm, pteval);
>  		} else {
>  			struct page *src_page = pte_page(pteval);
>
> @@ -794,7 +795,8 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>  		unsigned long src_addr = address + i * PAGE_SIZE;
>  		struct page *src_page;
>
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +		if (pte_none(pteval) ||
> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>  			clear_user_highpage(page, src_addr);
>  			continue;
>  		}
> @@ -1294,7 +1296,8 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  				goto out_unmap;
>  			}
>  		}
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +		if (pte_none(pteval) ||
> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>  			++none_or_zero;
>  			if (!userfaultfd_armed(vma) &&
>  			    (!cc->is_khugepaged ||
> --
> 2.49.0
>

I mean all of this seems super gross anyway. We're constantly open-coding the
same check over and over again.

static inline bool pte_is_none_or_zero(pte_t pteval)
{
	if (is_swap_pte(pteval))
		return false;

	return is_zero_pfn(pte_pfn(pteval));
}

Put somewhere in a relevant header file.

Or again, if there's distaste at is_swap_pte(), and here maybe it's more valid
not to use it (given name of function).

static inline bool pte_is_none_or_zero(pte_t pteval)
{
	/* Non-present entries do not have a PFN to check. */
	if (!pte_present(pteval))
		return false;

	if (pte_none(pteval))
		return true;

	return is_zero_pfn(pte_pfn(pteval));
}

I think I'm going to do a series to addres the is_swap_pte() mess actually, as
this whole thing is very frustrating.

Thanks, Lorenzo

