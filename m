Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED374C2A09B
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 11:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2072B6B008A; Mon,  5 Jan 2026 06:41:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4966B00D9; Mon,  5 Jan 2026 06:41:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B72D6B00BB; Mon,  5 Jan 2026 06:41:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EDEFC6B012C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 06:41:44 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67C3A14241B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:41:44 +0000 (UTC)
X-FDA: 84297720528.26.88810D3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 28EE6120008
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:41:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qywi0RcE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TTm8rhe+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767613301; a=rsa-sha256;
	cv=pass;
	b=b0h6gvEsHIRBQKzJ8V5CIwxuTQ2tQ0nIa05qKRfumz+zfEa9whqHxubK03RefcUYyNLPDq
	dDgdZRD6xrqShElPUhOXOnW/RgeMhWN74toB1TB2yfpiuC/MrFK870N6jtg1sfJwC0XRD0
	ic2S1WDOk2UIUs4VSUTsV09T10DZOt8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qywi0RcE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TTm8rhe+;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767613301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W161e/+HVitHaEHT/T1wPGnB5BFo7+WHwuQIyxozR5Y=;
	b=UL8w6RSrF8kOoKRZ8OSDMaFzb4mGMvSb+aPQXf31DDHFVxbmpTPJTr7IHz+EMNbm/xNthk
	Hagb0dLln4yOIiC1RwSaDpKv/0ShXNKNoQqICZ/YbJ/ogOxK80JT6zcF/T7luuTkQeJuuL
	IKa99KV/mgZ0Iu77foUyttReiaDmoRg=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604NdkAE669159;
	Mon, 5 Jan 2026 11:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=W161e/+HVitHaEHT/T
	1wPGnB5BFo7+WHwuQIyxozR5Y=; b=Qywi0RcE8fIJTXjPP9CjrGCQs58RVgSZ/Y
	J4XxjpuWoiXTQ0yVUwLcssCRGkIfx2tVtYZhfYMbba3u9nfaOGLmxPID2Ojh23Rg
	BwvTsEUykWcjaf/MGeN0uT46VYewYe+Oq0KADsRMzq4S4Q93v9ITnl663Vu9MXKe
	PVmGL+cUdcOth8w9a1TFgjk6iCP1VyoKBG2efQkxla9t7KT+BByfbmphMaxC61zs
	T/3RcrfDmOxRyBeLzChig462YQQrgVTlxeqEaBYa+3jp1mdvlGiIvEginM4HKPqI
	eJQxnOSYexcDnX1JaTpDOdc2zH7eQ5pEDDjcQSWyciYVzxrGux/Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev2jhmhk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 11:41:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605A3SH3017556;
	Mon, 5 Jan 2026 11:41:37 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012045.outbound.protection.outlook.com [40.93.195.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj71g8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 11:41:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=alMNsql7I7e/g98ThfV5joaCYXDfnWRmtrM5+U+Fv48jW0+usIq1ikjApeUwmurZFVL9NpqGI+KA8VWE9dcvGac8MwzLXPinoFZze6BiQhsxXQrteo7MnLdqVSIyJPwzQYF1mrYnRnxZSdiXpactWtLtBF1YxNkmZgvuLgAX/BxUo+ARLLZwAwfLmuT77LcRVZlmKCMx9qc5taUuxST8tjpTnSFVyaW5IKOk5bmV0IRmJS/Hik0iAXIXC6O2bhbXRzcXF6k20MpoF5/9a6Rwnk7L6yFuge4EsMHgJMg7aP4ogbjLhHZWhnzb8hwcSGsQM4Yc/kDK7u6K4Oumgn0RIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W161e/+HVitHaEHT/T1wPGnB5BFo7+WHwuQIyxozR5Y=;
 b=OdIK1t1LgfO10b/NZMNN//EWI9hEBwrUCVLqifxTRbs19uwZpLGI5VjpRlo3W1XZtQ9MyVIVj3Jc2QiOVDXB+UJ3Yh9R+Lj0SkuCZVc5DOaDAVTUjAc3P5YJgWCG0YakxJpKPRmmNsing8q4v7wYrBk6kCap59cbwzVfDmeBb5M7FLTx+y5epCvOn9c43gk7gUzg0OkF/wvM11CAiAHICxww/Bc/3O2exc85sv5mJyZZBN38393ElfJpnZE5qxKufn9RgafvvTWxY5wgFqUey/jk9QakJUVlvv8+PRUMY8PH0NNfDGUvpCwIZH2nNQbtO7Q29iipUzooPvDBP5lnEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W161e/+HVitHaEHT/T1wPGnB5BFo7+WHwuQIyxozR5Y=;
 b=TTm8rhe+1bagTmNd6OCErBtvdjDqmJui+1xoB7TOiO+AmsdwnNso2xfDMsnxXGWoQCnmClgo02nZcpRyHxI6PU39SLgqu/lHc2i0st9HlzApGOI6RX/sg9vJ+LFCq42SSmEFrzvL9z0ANpS8LGW/2Kzu6wXJvdpMTJgbhunk19A=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY5PR10MB6191.namprd10.prod.outlook.com (2603:10b6:930:31::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 11:41:35 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 11:41:35 +0000
Date: Mon, 5 Jan 2026 11:41:37 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v3 3/3] amdgpu: don't report an error if the process was
 killed
Message-ID: <7ffacc33-9233-4fa1-a7d8-28fb3fbb8061@lucifer.local>
References: <aca0147f-61be-30a3-eff5-cb981222aacc@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aca0147f-61be-30a3-eff5-cb981222aacc@redhat.com>
X-ClientProxiedBy: LO4P265CA0312.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY5PR10MB6191:EE_
X-MS-Office365-Filtering-Correlation-Id: 037f2030-3456-4da8-4002-08de4c4f6134
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HJUqvtQRtY1ZG9mj16/yzyYLA2BkBmVt8WjsbrDroMg4hJhVJI/3G4YyXVhu?=
 =?us-ascii?Q?ClyT67GQWZROyvxSNeS6CKIWWogdDglFczQ2d0L7oWc4PlsOOAgwJpZmx3uK?=
 =?us-ascii?Q?MfuS1jkd8WVAkiwGpFUT7B3lU0YbFde82FdAdUe10EO1c7J9sHEx/p77riHX?=
 =?us-ascii?Q?8rESD5eFt817jkaz2GveJf7c8vp3chcUTq392FINd46RCRJRpK0lbYjzh5Fp?=
 =?us-ascii?Q?1xv1EgxhmfZPedAKbq2EYOqhIbCOnidy1Zh0BdLD1DQ1curzBW9AAG/wzuFE?=
 =?us-ascii?Q?QHxnJp4O3Eq9guScovI5TNBnzp55QbRX55AHntDHlxbMbuvtJev9uRu522hK?=
 =?us-ascii?Q?4G8Ty9wPUytYMiKlHKx5LSGCHVCUOIOrvpFW1GLIGt2I1LH0tAkpzJrd71dw?=
 =?us-ascii?Q?6M6Wa/KM4A2wzPCGt//kjIXPV2pmjLFM3zCuwflhcP5WPwnqyi/S/qC0CE2G?=
 =?us-ascii?Q?/lQklDrksRUo6rwE+YdOrv3YijJDs6CgpOOhdcAWq3DfmAlfiVdptg8/SmQ1?=
 =?us-ascii?Q?CzHAI2CWrDREp9eETYBbwtQrOaExTgHG0w2fzeqXc1m0cIRNAPDq/dL+oio3?=
 =?us-ascii?Q?A2O7Uab59+8a0tSCRiLLN/6QCRYMb410AFQFhsiyr76se5NrRB60VUTFCLGw?=
 =?us-ascii?Q?IFTx9K/ykubQLartq9C30s8zLUrpIOhPS5v5fGy4TmI2ya6moOfhnSyiC2GA?=
 =?us-ascii?Q?4/sQE9NNUVPF2wtjKNss9k77eX84VpnH7/aS8k6f9wXZ0xdig6bWl+pmfwtU?=
 =?us-ascii?Q?CFhpM01AmTV3piFtFp/vt9nTX2NUI0V9hTJGy20vpApPkBwbTaxU6hNMNRC+?=
 =?us-ascii?Q?W5xdT5KhtWXnaj/WwJbF1HO4uBHKMzasw0HyyiMZwN1hFZR3J/yEC7zIGZjr?=
 =?us-ascii?Q?ns5IZJ1FsBOZMhlB+iGb8w/QWl43p4TqNFPgIODl078QGJT6PFmBwDRFk4cV?=
 =?us-ascii?Q?m9BVNOUhSYEn3dECzXIG5O9Kk5WO1Odb6YsX3Ox/vJC0P7ht17gNxA76KY6p?=
 =?us-ascii?Q?0Iphl3QgFC3sJFjf3JMb6XQIr4IhVn8OEJXhZhKp2Fwosn6A4IvhbWBbVqAo?=
 =?us-ascii?Q?MtIQbT1ZyqyxKM1dnpYHBk9Ijllj5zFytnNPsubufrNs487DECB5us1rO6M/?=
 =?us-ascii?Q?LmVMz11ugj0wuYbZYG6hKXguNdCM30vRQwDYGRiCro/fWO9A5dpqvvvCTQCD?=
 =?us-ascii?Q?++3fzsDsLgzTJFI5Zsvqe/rFUBK2+JDIUPQbqkcDkoqE2veLu1WYfmraPErF?=
 =?us-ascii?Q?cyJubRoWvXiiIw7dUezmaRUKMn41L9aFCRuxdAeRiHFfS1RoIHv5VFb+mR/P?=
 =?us-ascii?Q?iv5lHIm6AznZm5DEKqD9BkGTBhAxNWS9QBKIQCIWUFO5wN1SdGNvbA2rsw/Z?=
 =?us-ascii?Q?RorgkTuurZMFET6hHZyRjSKJnTwuoHiDVZAGkm9kV/7DakP1OM9xy8ForqKJ?=
 =?us-ascii?Q?6126WUSFlB6nGxTpyYhDo8dEllxZc1ND?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hu0LeP+kFVjqgLg8ahMEmWS3Sb1Cu5d6Y8JLcomaOLg22PO40LJHEQVaek9f?=
 =?us-ascii?Q?PJyEErJBFxaBCzcnIRf4VIIE9H54ZQmS6rWHFrbhbbSpulEOqRp2HufvKqDq?=
 =?us-ascii?Q?WfvQsdnB1eGHXAMMVdKIvxXbSsUnYmo+6u72Giv/K4LUisyQYjLnm7jtoRU1?=
 =?us-ascii?Q?a9h0TfK4Ux52kRyoJP1fUGBd3rz3JYcTACnFw5vqATNOYtq/DJOMKzX0iCvU?=
 =?us-ascii?Q?Eo15L5g6m5DzA6b3KazV36Myu1PwbLsp3Agx3IoZh2FmCGg4iornAU+JJv4K?=
 =?us-ascii?Q?qPPAiheBwEgCSCzxedERq0S98T9omkLzTFLRApxpDUAT+5zi5cBSYscPqaUD?=
 =?us-ascii?Q?DoIglxRFGxo7fB0nfKOklITGW4omJgLbe9jbv03bF0u8M3o8F9PYlUKsctVW?=
 =?us-ascii?Q?e6aN8KcxqXdbRSwRsF/5/UmfUi2JuiVRw9K8CZi8KI2dq8WAmAbhCGkzJ73s?=
 =?us-ascii?Q?5XdR22FekxUpImfi1VYeWp/CqQvWTLVXQlATJN6h2hzz+CNvf9/CjhMKA6WR?=
 =?us-ascii?Q?FzVWTcxjBNsF0dCqfxumbWurnN1yRhI3N748CveS3rADnW1NbZybiSKC2aKO?=
 =?us-ascii?Q?3fKku/WGpb2IY0JSTJzED0Q+ly7xXXz0ZR5OTP69x1lV8zyguP8LTL8ZpVEj?=
 =?us-ascii?Q?oDZOPSELHjTLAnms5FMUr5g/jJJfsmSofG9JA06KlQtZWP3rVwniEfDSwVNE?=
 =?us-ascii?Q?qdYgWhL10UJQA5qvzdUadXit78ZgRZj0iWctAFROQm53wet2368GI1YBUNbk?=
 =?us-ascii?Q?4kvoXdiZtTkQq1dq1db42O7lshT4kv5Qy6NlprKwJJ1/hOhmULUAVobAAxkj?=
 =?us-ascii?Q?kATUAegbM2VHdvHC3CZQDjiUpZlImUsMR1UaVXe54kyX6cvnCVnlVsLqgYMs?=
 =?us-ascii?Q?IceBD0uU5Ci7vSEMkbuqnwz3Cjjao+0pcGp+Hd1gflGYExBnidFsdmq7QG/G?=
 =?us-ascii?Q?/RnWG4mKEaZ7ueS+/rXTPF3XzAVCLPzQp+B2E5iEQJRV00gREHdwHFvb9TxN?=
 =?us-ascii?Q?/Ledec7X0m6ApiadbrxDCtGTLqLvMCdb+lHgtIiNavtGmT/ivk6yo98P2XK8?=
 =?us-ascii?Q?u/WFephFgiStJTn2/5S359cqNcDM+MGhBVf8yxe+ISiEkugkd5qO+wym05m2?=
 =?us-ascii?Q?7L48/wsojgmrTdr5XHausELrjXpy4q4pDxRT56l7EnS79nDrYVjUIRv69cmp?=
 =?us-ascii?Q?RT5bQu5niWyJMEh0XX31wqZckVnPnnQwVEE/e2xY3VQ606DqweXU7+GW0Oxf?=
 =?us-ascii?Q?dfC5Jgu3ByspdaQwdGO8xvDcIG8KHB0sthtEaBn9MvmUZ+ZY66uFPRQCXXz8?=
 =?us-ascii?Q?Gb9Po79cLm+ZT/S8uScb7/8W0iy3TdE8K2C5OYIXaF4U2MIaMQqOV0YwM155?=
 =?us-ascii?Q?7T/5+P7Z+hVUV0DVuSXTvCM00BUiZzbzsf9gvRxZuiX0+PRlF5lcTknwB93L?=
 =?us-ascii?Q?TLIAUZ6qc+Adw/T5USg04XosYSR60FSGyKioqNbJ7X5TpoxXDBKxvncJHIpr?=
 =?us-ascii?Q?NvtsX5fXVyLUVjo6Ugeh1EWJaSfdkybD6vVfvZuA5shUKKYEBBjTB83220fE?=
 =?us-ascii?Q?+boTLH6tkqSi9erO6/BwzX6Dw8XzNdILIr5YEeler1fV14qbexIwCfsMKTgB?=
 =?us-ascii?Q?gZIQGJlwvyPjjOFF0J3hjVYIB9WtOuQhkpXcsGVDxNxsOHKV4agoU1GBb2xR?=
 =?us-ascii?Q?U1I1dZRRjTN0e45YAKw3cDVlSDJ3AGviRXN+Jh7admN+YzdaNKc6/0ZHpGPz?=
 =?us-ascii?Q?u5fri0CSyV3fX/gjWlhegmzN59m8cmY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bj5nB3qAgHzrPl0ESQ1+SHiBAicJTpuhK50i53Y4ApYnUEqqw0IdSBqrJdDUAUsvekCY450B6nICPQEUov68daz+aHzAezp9E6/40v1dG8Vvn/EGSdIjCzH5P2w9NqooMiOwCTjtfEkl9J3CYrez+UOxs63jWVZER6FAzm5S0eWLhqjj30+QD+7/ZlJ5ZIn/TH5ZbAk82x1kUHkIsVkLGzxQPfrbNFvnPsVcPRZ4rRILnID8Oa2pqYsSIfXL7ASsTWSJu+IsRhvrknhQRXunBCAA1E1gtAz3UqtyGWBxWh9OI9OFqwC7Wj3c4UHeJWFCinESUjcg5cxBAQKm+obfoxdINVyaK9sXGgUlA02nSwRSfbXJXy+QYooS8G8wHLyhRkifoasBokW9fesFP67vDxkAzH/R5FySGIzM+KwBsxUIwqed0+xuIxokdEt58xT0ney2URWatmZ6L7WvWMFB6AAgC57VUKxfzPu4k5mlbHju1Vh12oW0HYorfBjeqhPQLESxygNt1cK64SDxx52hhc++QV1y8SyQT1azQs0u5YlkN+ltpDVvcYIYCMHR5zn0hUzeip2b0dw4STB3/lgw5SwAvmzqbuqAMqGITqFjp4Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 037f2030-3456-4da8-4002-08de4c4f6134
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 11:41:35.0994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oCGRF98XQUGj7V+gN1W/3SjoMYn8/ve/ZH6u63CxUcL7i89inevCuQVEdgEeZM6MjNRfaYFi/hJm5MJMdpl3DYY+69zEh1ScjDcQPR4NaxU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6191
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=505 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050102
X-Proofpoint-ORIG-GUID: Y9g1brANaKVlllSx-npzsiDnN1E_p90n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEwMyBTYWx0ZWRfX1SIaLXrI2bCe
 f13o0shEYgyfT9lqJlCqGX+lP77RffEduPAYKF0dPxupKDUFpgpJxXrqkqEyLmzCmHqml3zAVnm
 TYmyjNUsjX+q9KPUUUd1mQD5p0SlFL6ZOJjKVet16cL8AVafxcNpfTP14DUYUI4nMlGqDkTbYE0
 k1C59jPDLQP1PFEdql6gaAOU9vtrnOJxW1u0MCJAEsrA+t5Ia3H+fXN/jbEmOAGHXLG0/2mzBpe
 iKx2JKYyLMj9ILHvJGqDaIQ/YyFZHu/LRBOaEhQGAH3p+hCbv5AGG7jfn8GkuOc4/GDSg/0dvpB
 3GVUdECU/pTtc2d1hA2s4KdRRHcoAcqTa9jB51akXuuz1+Cr8NKw5Ck0YAwEwW2yj6mpGKjl0JZ
 qkehpbpu2MJBmnE9aFZylpL0UxktTRc6EAc+bjfyVfvWRwm20LQXZpanz7auqzSwrU7xWnDpv5S
 n02TnngXLS5ZPAN4k2g==
X-Authority-Analysis: v=2.4 cv=A9hh/qWG c=1 sm=1 tr=0 ts=695ba372 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=95lX09yStPcFndA2:21 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=sKhKwa9BSwNbsTyuDSYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Y9g1brANaKVlllSx-npzsiDnN1E_p90n
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 28EE6120008
X-Stat-Signature: exwaop47w7zs37ghurmqmcb7g9wk44bt
X-HE-Tag: 1767613300-667261
X-HE-Meta: U2FsdGVkX1/OhnpBGiUF+iXpq+Gh0g1CyvKA9XwLQ2CBDkpbmiYBpPdhVTb/sl4MKrQy/KYLd7pK7plhiSw7OWfjbXEsdOrZEG8iWHhQr7fWRibXk/rBxKYZHBVM36cnEO/pjUpbsN7IaSfXNDZM+PbWR2PhR7Kjv4iv8aFug+2XSkW9ffcxJZVL/TrNWTuBav0e/g42vhmKZE4HGwVnFXwhHPMke12m+aFHHKxR8RQ6cm6bJJfTy2nhLTbsrRNjgH9qyc1f1G7KY/118w4JixhAOd9NxpqHL/5fUy8k0wAULUuliBU/Lf+IGexHyhFznKOX/B/IeaszlZUt2DH9J2lch3bEzx3TsrUVcoDZgR8fYJld771SEvdOJ1r0nOixoQk3LLHIeUwWHTxA/hptdVmvIYcn9lC6h4kqU7r5FZ4E44l8AsJVtFKnr25p41G0SZI3+fguiGboYMNqRw0qXBVA6cqpUlQxb2yVbQL6YR2yPcE7VEh1FPKVvIuActXcW0l2EwF07bXZwPqBfocN1EiK+m9Kvc5ukg+XtWvKzbNoiHzBFnxV73w72ia58HnkiZiNlWSFd8UxC80nqvkgYB+Q7kelzbIr/HjYoLYkhKiSu9j/u/phSr+Dh3ZsDKGlZTSWqj06s+6/mOQAxoGHOZabz4cj8dskVO5EWzE+Vp36e8K65UqTtSra2MSVNi9RkcfzihIWtd23I2LUE4smXl+k/69/rynLBly4roJstYhM2DGsNCLSAhtQajn/GOEpBkUj8Bh3VsUBe/NFNS4U9FH7H4K8kdbFc+udWSgyeFQU8A1HawkM9MvgFsO9r45hk5G8xrhPzKyQp2/luoLgS5OFjfJqK8OzGEAnYeiVmv1ylxYmMRBdloLW+PkF69be7XPRWsxQtOfj7+6LbF53eyZfgGr/PZbdiWu0yXA84i910ysEKyA9fkovh0+lv8S2YEYdE+LrFbw+4PN5Gbo
 X0otr2bK
 pKSo4aer676BDfFJ8AAsphVE4b6MVx4KrRPo2kmPbgJAoRGODhrRfJvLIDrtNORQfl3EL0RqAo7+rIqvqRDprgjzMdpYzL1n8s0x4hQHAyd1Pc4O7jM8wazxB2Letgoa0qT9OLAI4Sbx6w7lanliHWszwwma0luVPQPNlLvrIPsdOcd3+MPLenPf+K9t41zsT4rJeIEuh+CHDggG8kfKIo3nrF16pcxVcKbEHwYwk6zPomED8cqrVfMixPBPnT0nUy9eFDON6XwwJg6P9bK9SJhEZRJqr0dll7gpcYtS/4Lo2Ic+X74xehhCvj4k1d9jLNMNGAWAMwjPIHnVdYRlT50NbImlCOt+a5CVXgtM8WCG2Qu6MNa2eMzVLO2Pj7ELTu3210r3T+hYUELrbRI7UVU70PfBeziTmwD618VWBNfFywioXXhFplr9e/kOsFrazV9juzMg0iMBndDn206lCF7D6/ecEu0VO1+8GmzQaXD9wWMhh2MSdoiZSH0XJpwEwqsWP5kdhwhzWlxcxnbaGmOKa9b1PYt+42spjCgBhQkeQXTmwHbGe1FAxhSImyVqzfKNdHxvuMlbkxFi6K3M33cBNJ4u0fNkq26E6zwreqsBVdgsOJfNv+HpEWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gentle nudge to ask you to please thread these series emails properly in
future.

Use something like:

git format-patch --cover-letter --thread ...

Or b4 or etc.

This is a nightmare to try to review without it.

Thanks!

