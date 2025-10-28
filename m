Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B1F7CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF048018E; Tue, 28 Oct 2025 13:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7A58013F; Tue, 28 Oct 2025 13:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97E578018E; Tue, 28 Oct 2025 13:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 828A18013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:22:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B7A05944F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:22:34 +0000 (UTC)
X-FDA: 84048192228.12.8D86D87
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id CF23F40002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:22:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JfVpsfKc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xnVksArM;
	spf=pass (imf04.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761672150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IcAu3qp0OPt8IBiaj5MUAsokjaoJj2ohwuEmhm8oKRI=;
	b=BqJqViR74JNB9+Zu4zawZKecqGh3GEYnxw+SzBPjPvWq+DrRgINSk+U5h0bCMYO0xVSVEj
	2BI7IPMV5JeUlLt69jyvF+ti0ubA3/0fCoRyUwxqrDf0XqnNEQM8oWxoK2+hbkjkkvtwTb
	jk0dp6KTq22T/WKPnFKyCQH11x7E5Cw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JfVpsfKc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xnVksArM;
	spf=pass (imf04.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761672150; a=rsa-sha256;
	cv=pass;
	b=XqoVoJcYTspC7XrFMY3RMs134EJbSIcPH9HC270fkkDmBFIGRRgv/2rO77WICIvQFYt7zR
	hNVMsNc00hxbEX9yx2pB2TDjne8ZWSEzapmSWXbg3+kHV77ciBHRpCpGZAP5rC6x5pORLM
	erwNq42Sgb4TuTwV4RpaQ9+sII61fHc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SBDX1J029091;
	Tue, 28 Oct 2025 17:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IcAu3qp0OPt8IBiaj5
	MUAsokjaoJj2ohwuEmhm8oKRI=; b=JfVpsfKcSYOfElK6QQCEqw5BHQ/vH2B5ka
	3pdX+a19nGSrBXbTY1K7j4y0YZON9vWdoT7PrVKxuna6Tn6wDvTdRr8sJvoZKlLD
	5DO994IfkS59RZIiyzOafBK7gC/66lNEy6ahG3ah8Rpib6EaoR6PXEtoRNmOmGFf
	aSLQeHo61/CPIL5RDLHfcOWnL2z9hm/S6q4DZoPy+fVMSuyHldlqkJIupF6ffy22
	Qb9GWuitjRIZ6WyccIge5/oJKt1v3zWnnHqfhMv6R429tJAHbWP6pl3VQ/GnCwoG
	XNa+yNBmxevM4H2sEWiEnXuH/DOss0KnLwDnFB2F6tvh1c8w0xKA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22uuc50t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 17:22:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SG70p4037432;
	Tue, 28 Oct 2025 17:22:11 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011037.outbound.protection.outlook.com [40.93.194.37])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n08gxyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 17:22:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PU0I/PdFyZ3MW2jXGWR9KGm4igBpYl7BCPmRS9h4we7rcfRMeK4oHxjR+YsGabS17JW2qQAJqAT6uWufCfWUW0XjleEVHJuO/3PNcbiGKAp7D1EkPPqVRlkAE1tXvTUMTqVpHZXG8p86oYaW9Z5fpRfhruPUg9pKrgSvyZDOvtgoH2WeVfUprtYcuw4gKjZ5mqhxmUlkpPBbvlZWPclyvtZXuMS2kG624yK3E1vnJYhvQetbSIcHG2Vtfvu/rG8VnE9MxDk+98Q/F2m8JeBT8/kWC4iZwkWdBEG4+vXL5Rbwida+aozLylydln1S1V2nDw+nVvh2xM+fEPO755etWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcAu3qp0OPt8IBiaj5MUAsokjaoJj2ohwuEmhm8oKRI=;
 b=p2Gct/uEKgp/nZKjGqpCcxCZ2dNTRj88TgRWYMihWLUhuihlI8VIZ5MVP+K/YvCCE67FU7AIQQj83e6svhJ3yqQnL9E20aW3IAkQTip/kV6m7H90TxfiOK+/mMdUgZTqVlpBgZycnxY1FIvcIPGqlW+jG4wbLILZTxWjgw9/m0HtAO7BcTsET3P+xBZGUDehq/Ov272wrK0O81iPWFVmlUJGxXUU/z9TINDDzA8fHRYjh6DO6r8tRPExf0M1QLvFWXbKCtOOznFqOPgFCV4inbdjguoQOhv/fbBSSxxg38Np78T0YVYM/HYfR59g1A4tR4LELRMKVWLUP3/mAU/VbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IcAu3qp0OPt8IBiaj5MUAsokjaoJj2ohwuEmhm8oKRI=;
 b=xnVksArMKQZ3dWZElAJAx+6AxzWYSrxjm95+NvSUwnen8v5NGBvqWpteL9fvsojO0J5EZzGcEl0fBIuLE6S7L7/yW0FJBgoAfpKNQLc3O523PJsxyGCYfgY8BpSesBfZBq3j38zHoG5BTGLb/gXRFTQBRinOZVLwdEuWvMyJYGc=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH2PR10MB4133.namprd10.prod.outlook.com (2603:10b6:610:a6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 17:22:08 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9275.011; Tue, 28 Oct 2025
 17:22:08 +0000
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027143309.4331a65f38f05ea95d9e46ad@linux-foundation.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 0/7] mm: folio_zero_user: clear contiguous pages
In-reply-to: <20251027143309.4331a65f38f05ea95d9e46ad@linux-foundation.org>
Date: Tue, 28 Oct 2025 10:22:07 -0700
Message-ID: <87qzunq6v4.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0106.namprd04.prod.outlook.com
 (2603:10b6:303:83::21) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH2PR10MB4133:EE_
X-MS-Office365-Filtering-Correlation-Id: 954578c9-b3e1-4d15-b139-08de164685c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jaTl8yXp2TLE5g26dUjDIiIxtf4SlMPextu3GunQMZK+v67EXZDZbO2DeVqp?=
 =?us-ascii?Q?QXG/hnJ486oVl5k75gVY0ENTMDYf+xuzP+JSlG/Vz0ZNmdUVDD4wgsn+xdVQ?=
 =?us-ascii?Q?j9b9bbS3lH1pz6BNPnSY+0v2zXrYt9KMnWNWmGtLUjOi+k6MIfFVUSOrO/Dk?=
 =?us-ascii?Q?IL38cAtSSx3PgHe5BNfP2DAx8iOJ50H5r5FSiwRh/vzTk8tKStW18FvkTi3d?=
 =?us-ascii?Q?SpAmo26ha6wtE/8lG4zEzDvPTyqF+9IuLYNf779HuBRBuBq776QvJ2Dyveh3?=
 =?us-ascii?Q?cR+uXozVT0HLt5tAgc4y7uPMqvuStCbf1Yqudb0aoT0mJnfzKR1lN4OqVYb6?=
 =?us-ascii?Q?lCOS/xPFIsWMzbCHlklmBxwpZkrSYQjIZt5FMKFX8toH16t9bK5wdRVMV8+e?=
 =?us-ascii?Q?7DVa/6dwgy5DimDVBbrOUvDD4OrM+NK/5ZmcjbtrrhRHOJKYBi1bXVhMl3ei?=
 =?us-ascii?Q?cTgk1RSkx45AHfBk6vlodBC7yhhYgPIQi7uoB78b6+q9Ua6UWDGIi/v1+N7Q?=
 =?us-ascii?Q?gRdiHtlcZp3ATvlROM9uA29kCeNG2zuW773XDFeHx3f8ZGMksT5QoN6+ov12?=
 =?us-ascii?Q?cosqapkt4wMvZ4LDGvNbmAF52YKstOR8TgYywuXp0iL0gTmL043lphesv2wi?=
 =?us-ascii?Q?CssBZffeUJI5hf8rYyjswHwOA364JHDI2jl0m9Az0bVWn6MAU4OZ6AgTFm7n?=
 =?us-ascii?Q?iM2xx/SHL9jVtW5NOb4N0E1moJIGysC0A1vhOYesbcz0wTHucaAsP81SpeTV?=
 =?us-ascii?Q?oRNY1C7VORI20RljrjZCYi/RPzoKRmgdwELdFxWfuMlRLqhLVcx63kVwtTuO?=
 =?us-ascii?Q?VYGPDNUGASKNSClinUysVbZJuwB1SVTRk58Kg8uYxoFiKMXyo7mJNhOQ6PQ7?=
 =?us-ascii?Q?7+7sdholSWdF/2ShRC9Osc0WIf3BbE+LoM+qySlhULFFnZBN1raVARxqLrgU?=
 =?us-ascii?Q?XmXaMBGXUyPXDqb8LUeVDQx5Y4/o4dkEzYYR6SM8r13dIGT/OuNUaeibHvyL?=
 =?us-ascii?Q?NKr046DZis2iQVy2nKHDvziOHpmV2M3uTKehjL9dDzgBcVqZrUsjTuMLZxgg?=
 =?us-ascii?Q?OF4PbMmfFPUUwNq1f3SzwU7ohZjtmEfPRPNzUCrcO5hKY8LpkZMuxgFv4wpq?=
 =?us-ascii?Q?Ph6r7V+TeFLRKOtKBHtQb/H1UL3jQjQjWBKlZBCH6dAgD3AMD57uGe8mCF5I?=
 =?us-ascii?Q?hf75WwCRDmJptMXXjV3KWu+fCvyULLTRHTqFaVJdjaQ2t+JPuxu1wUr7HCB1?=
 =?us-ascii?Q?ApvY8XboxN/P8td7/jJ5Y/+vfyZA6R2gdwHWiMyNB5efxJbgD92guPp8pUBM?=
 =?us-ascii?Q?2J+KjA5bZZ9JiJ1xkUnci/HSuZ+U5tt5nSEHi/oDOO2eZxnXHXzVlgbdyxpU?=
 =?us-ascii?Q?SFrndAtvOLFQLyxiCxsGfWWnsFc0ejPrPSdULTWhJy/opUDqYt3SJ9BrhFUv?=
 =?us-ascii?Q?37KFGGVwlw1gnIsriPL5FAh/ZoKrWNUdlGEDo4iDcru25j7FwhCt4A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HvJtYumVX+yRJfqdRm2p2c+julgGuhcD1ZQDMtwnX+Alo4FD/L5x+WtrHU+Y?=
 =?us-ascii?Q?ciywRuOt2lmOqyJqqE+vc+j7XzPMnIIEevcFLq/bIg5saxZbztTGPSISom9M?=
 =?us-ascii?Q?YXfaFgRsPCHCn8slOELdgbiXAqkcAAu56xy7x7va7ofK0pZshX3q4mA06FaX?=
 =?us-ascii?Q?0QM0gWzQBVuVeoFrTcWDlOD5Qkx6wNIIQ5nrpqeWqfc8x0Rzo+5EGfvPcLFF?=
 =?us-ascii?Q?DWId+selLjGE5zpBsRJ4he4YAYltAQ32sOJ5aDYdMkgfPa7QSSb3a4M1FA+x?=
 =?us-ascii?Q?WNhzplCEyTUl+OKHBSWOCMEaKZw3ELEEcNudR6MXJ4Lx86UtWvzcpJlAAOU+?=
 =?us-ascii?Q?b0b3wCw8J+1Fcv1b3PnjMrXkSDYuFz+3ZbtLRWB0kISLO3/p8eTDsHbP4/Qc?=
 =?us-ascii?Q?VB1oj7EQmuPqaWhZEMU2oFe+v+bYKKWmdcmSHCm3YlFnclQLYzBN4K7PJEW3?=
 =?us-ascii?Q?BH2ett3vBE8Cr7tFHOLMgNRJcHSfWjIe3ABZs0+Ej3J9GtmN1/VDeoFD6KNY?=
 =?us-ascii?Q?/cnvVDLH/GD88sDgY20c3pzNuVy/eZDImMH36V22jjoSHR+pLh3N/QIJv5yU?=
 =?us-ascii?Q?DuTOHe6Wm054NkPxanjJNLgLeT9imDKyPOb2+vAY5uAAZ0KmGwQ10xQzPLkL?=
 =?us-ascii?Q?n+XyVn4W7C/mpNLTvUTqiK0hJCHIT2r/3FXmnUMuGOmOSfbdr5K/PWujukZ9?=
 =?us-ascii?Q?NqeM6KYiNCZBKAHL8qgFUCRWIRGISH1wx4EhaQeOK4auKMAo8spUhLZv8n4n?=
 =?us-ascii?Q?t1h5mr97AvHhuXTxJkO1Ygt8A3feEi2wgimIQ+hSHZHhwmDqGklxN8t/x63K?=
 =?us-ascii?Q?ba7HlahTj8Rwc3LYbNHCgMb8hQoCrWmOU8HJLD8wFj2iwr4y80XqjAog//GG?=
 =?us-ascii?Q?cgNzhvgglhoVdtg8HySDEPKvby8ePx3eQJcnoDWLOhIEWA9t8XByvMGqbGVx?=
 =?us-ascii?Q?PTQYOBNLogQ3s/QGMO1n4fuA4OdNpa2LBtWV1rgyUXUWmNxml7Nf0MM0POis?=
 =?us-ascii?Q?O9REAmsMYY5wUh3QiCb55Ap1ocFW/Y0A25F7s26ji220gBVhr9vx6WPAhuWm?=
 =?us-ascii?Q?SrYkYq2oTCZN7AjaJN/vnRTbJfgIbFBPrhiTGUBFcWdze8ZVT25uICAv3lrZ?=
 =?us-ascii?Q?bvsP/PCAz3Iy453elXFrnPymJLMlZDM56nj+3kmY2DPFLQCnHZqODnMipZyA?=
 =?us-ascii?Q?eF97tK29GaKUXBrXnogMxunjYiVKaxT9d0fsx34SMYI/2RuzgFLll/b0FTr+?=
 =?us-ascii?Q?d/o+2W0gyLshS7B3DF5a1ThkQxaGNpRWqhxsa3a7r0OshnQkBpr1MbcyzAo2?=
 =?us-ascii?Q?v8bbNtoB0nlc3dPHAOEPogZjpcUzYUmgswlV+VXJoW1W0XlZibJLLt1BtrNq?=
 =?us-ascii?Q?f9yjGVqdGlOw4JUZLr7RfKCtNeFuVYV/wyETM32jWjt0hfX4/Wa5GSHx4XBj?=
 =?us-ascii?Q?KTDfugv2yN6HSYSn+i2jhEoc/7bdZIyutVhhadvZf+6ZapKYRthP0o/sVcmU?=
 =?us-ascii?Q?8a+SzaLUGnpeW9SMRlwDx4KExVVUokt8vn8ufqQl0xLIWxqm5URwox7yPKTQ?=
 =?us-ascii?Q?GJYdGWH607qQUQSRyhfbwcOv0n6fm+4HH9C8NvYh4IzIL9RP+NUIv3c8MDgd?=
 =?us-ascii?Q?/w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TKHimIpZbY3tFaH6RZ1LAV0oirGjeGBafhkaL829DvtxwC873L3hg+5svaGg+2nbV3d8MW2eHdC2EH5kyUf5fV8yg0FK7ApF30bvH+QjNHqhoaLE1aN0lUaQdbR6h5XcYZNGm26j3+IksdwF9b44gU30v3F46vYTl9jwEMv5Vtfxv1n7OeVe2wkN6YlsrPm5lfS0hF6vpViRoNaBet8wIWE4QIw1NDlYPXQAOoD3gCh9wpWL0jh3CvTfT2NZbO1DX2GlBFpv3RPYurvs0aDp2+JYIMZROeeFE3WuKZ/tkI2vP9FamEae4wyLsZ3DTMmnIjsmUeJLZJVcHGVtw8eZNKqQirRC4T23rqJGuepkRCTQTxXr+AsPFiTcBZ2wxfxm/vHknsVFDh5xWD718mp6bzoFfPhZtO44JSkXVB6H0UDctGVC7fZ97fLawciKJf8XJmKojorsyeo43v2mjyI7Q9uE9fsreNOKJlGbJ+r9K10gdeIqT7v9tcSd+3/vs+9KZH5mHKT88eVDMDMk8assTYGV349JNfjG7wpO/aSNAPHbFOg+N/ZFTrnXIqmCpsUXlW9skhZq5ziIZ7MmNv7ivheoS4oewOlHrUeqaa7Egqc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 954578c9-b3e1-4d15-b139-08de164685c7
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 17:22:08.3100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 82V9gr2Ey9vHT3UP5TK2gJBopNy/dnijgkwh1OkylI6JdbwB5jcZqV7DCyM7DysqnaA36n1/Nt7S4uZ9GFLo+sDDKhJIVZ34IyU2QLbmRIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4133
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280147
X-Proofpoint-GUID: xphWvurT9qLVucx_ktKjvG30x7IWR-9Y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MSBTYWx0ZWRfXzXXD7WxvJGma
 MXxwbZosGMXKw01gUt06WGUEhuPoHvtslaCcBBacsonWVvT134lSBI63cS/ytXP9ydrIiT6xOjA
 ABR8TPM4ekRr3QAE9Vauu4leZoepfys/dpHUxkwiScCb3hcfV+qLgSUIHrK/oaHV5mDpnfLwYCS
 Xh4X3qPU4o97CkzFYRv0Eu0ig9IyAnm2ZRFjDvXHQH5mHmr29flI96ympnZGhc5bEOK/3GoJrJW
 9UC43wQmenZot7+ubbMQr3lpYcMaeRb4j+AwvenzTEdZ3ZRKA68RWqPX6T++CsIIhV5ROI2yUs1
 6BjHkrws2q5ACARzKyktLgSOnCnW05NiG7s6LBJpy6unG6MARb9NueHAQ8QIi4lJveK40ZKx08W
 uB2S4VOM8E8G/lTI+HG7EkNjqFKOOA==
X-Authority-Analysis: v=2.4 cv=Xe+EDY55 c=1 sm=1 tr=0 ts=6900fbc4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=Z4Rwk6OoAAAA:8 a=aG1s7GWeUViGCKzFW9AA:9 a=HkZW87K1Qel5hWWM3VKY:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: xphWvurT9qLVucx_ktKjvG30x7IWR-9Y
X-Rspamd-Queue-Id: CF23F40002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rwiwz3uttybqq9twzkojuhwyfrrq18un
X-HE-Tag: 1761672150-439587
X-HE-Meta: U2FsdGVkX1/e0OYikJtJmZZFjwOJtwaNBfcuHG1WOHCGVhyV83/ckeVswkfRJJ+tQsg1rZJshBTxsuHvMFWT+cmtOeVUvrhz1LP68DBhiMpC8XYTQiSq9d6DbcFxDJymr+LxAXJuArkzVIGgt5rYv12ZvFHJMInNJkJIORtAVH96x5SQiPDw+6HxAV7ol7ozagorx9i+wrEoa4FjUMRc3yGdKAZO1f609KaphUDAT10h027cNVE3EdiKF3jUfqjctaIGjx5ZH3y6/dhCDbgzHoeUrh5JHldExcTOjpUA1RFSTVzlj8BULh/WtxgP4MVpBeboJdzRTcqkkD9H1LWaQ0edcIFSbziUsIfvaWqXkt8HTlV9w7y0euEvsmdi1Dr8mrrGuj2Ds/cOhzNLtZrTH3zcIOcfoSEKLorFIdGz9TJbBv5cg+C28J4FxA5+4bjOzwxWiZ0vDvlRQNHOepwTlSjwOTsKUHM77gNEALOz703JMoYJQDDsvlMwLwxuYFLT1oB09xe0GEz6qGShY0UpOgW3D2C5tDZZw2Jwo77FQRf08TFDZ9LTEnCQo58mvP1nMVUkEtuYnzc178suShEg+UAjNNGuBXxdmWVJDpAgnz9D6eqSlziF9H5xmca5uWaDDliEOBYY0NGnrubYGL1oOgpam/c8vAoIO4fIYi4EKi2uLcjVP/Fpi3teIED0B2JEjjXken/W+27FxipD/UYkabqT9iu9XiuEnw0TSbWQZxkX4kFUHAyJURSC5RcD/kGZKA6sl7Loq5ALeS5EsaeUAPDVUopA+U8TWtTliDJW138+kkFbq+CMy/jpJqhKnCV3mm50Nfyh5+aF9RfH9LgWgimgpTKcU+tpwV7Qljg1xJAELnJ2XNU/uT90BXN4KgJcr1YD/5Pfea9ja05Og8BG/I4uKeoQiSbNQk0IXzs7HIiwbeIa+WkahiL4ZNOkeHTJ3xgIUsRFmW9x3v3yLlp
 N//iS3WK
 m+iNM1A3MDQWreTYN6wqAZ3qgNnM1BJ1gY6Zcc5Rgn5+t6T8ObZxHLOP/VxCy1J/Mgt39n6d9B/CNHqURJT6y2mScriWQps3INNb7MoIqy6hLcZPU4S/jbHFMuxw1svqqTFQjqc9KCWXGz+kfIReJjD2SXLxtTF+iljFFFYwAYr+S2Nf/Noji6/yqV8daKDnDULywD8lyHh6qmKpRxMzzhUY5NqWzVuoYBQMXh7peIg/Xz4AyeBIKJ43yGQJI+T0/Yy1P1Y8BfP4RaxzKJYuaOsP0QxbRHRvM0ZhtprDYyq6M2PR3KN97gbIc8j5MsorlR1MiLSTjn+EksasD8Ba66/YeiEz3+dL4IE3bpXpRgC2+G7W9BgC/oXzBws5dXcJRy7BV6aJ5sKIVzAGDy9dQ2gT+ylDl6VDPbrSsoLgf63znfDHrTapi+SxPv59VbHvC/VQfeVexVNPPIglAWNy1BwaI5RIqsmyRNcMK996V7eGu/i47Xs1naDn5eZ4NZltXYT0pIfNH0e+7jzyMe+cFHye8iqH0PeXZrMdekkBY8fUwwRcvhoqBhmEAkW3+z+nQb/Y1KXhSpgJS5f8kIyx0CZXP54EclTZl6II/AiXvHW0TlX6SVEj/e6s7xecDzoghoTRjzQfK6nMOxiUAI3JDhR9o3taoTtm0XEJ23EIJ5CXTWWZTIHQDk5jlCbhub1MkV6I4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


[ My earlier reply to this ate up some of the headers and broke out of
the thread. Resending. ]

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 27 Oct 2025 13:21:02 -0700 Ankur Arora <ankur.a.arora@oracle.com> wrote:
>
>> This series adds clearing of contiguous page ranges for hugepages,
>> improving on the current page-at-a-time approach in two ways:
>>
>>  - amortizes the per-page setup cost over a larger extent
>>  - when using string instructions, exposes the real region size
>>    to the processor.
>>
>> A processor could use a knowledge of the extent to optimize the
>> clearing. AMD Zen uarchs, as an example, elide allocation of
>> cachelines for regions larger than L3-size.
>>
>> Demand faulting a 64GB region shows performance improvements:
>>
>>  $ perf bench mem map -p $pg-sz -f demand -s 64GB -l 5
>>
>>                        baseline              +series             change
>>
>>                   (GB/s  +- %stdev)     (GB/s  +- %stdev)
>>
>>    pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%	preempt=*
>>
>>    pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05% [#]   +  5.2%	preempt=none|voluntary
>>    pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21%       +144.3%	preempt=full|lazy
>>
>> [#] Milan uses a threshold of LLC-size (~32MB) for eliding cacheline
>> allocation, which is higher than the maximum extent used on x86
>> (ARCH_CONTIG_PAGE_NR=8MB), so preempt=none|voluntary sees no improvement
>> with pg-sz=1GB.
>
> I wasn't understanding this preemption thing at all, but then I saw this
> in the v4 series changelogging:
>
> : [#] Only with preempt=full|lazy because cooperatively preempted models
> : need regular invocations of cond_resched(). This limits the extent
> : sizes that can be cleared as a unit.
>
> Please put this back in!!

/me facepalms. Sorry you had to go that far back.
Yeah, that doesn't make any kind of sense standalone. Will fix.


> It's possible that we're being excessively aggressive with those
> cond_resched()s.  Have you investigating tuning their frequency so we
> can use larger extent sizes with these preemption models?


folio_zero_user() does a small part of that: for 2MB pages the clearing
is split in three parts with an intervening cond_resched() for each.

This is of course much simpler than the process_huge_page() approach where
we do a left right dance around the faulting page.

I had implemented a version of process_huge_page() with larger extent
sizes that narrowed as we got closer to the faulting page in [a] (x86
performance was similar to the current series. See [b]).

In hindsight however, that felt too elaborate and probably unnecessary
on most modern systems where you have reasonably large caches.
Where it might help, however, is on more cache constrained systems where
the spatial locality really does matter.

So, my idea was to start with a simple version, get some testing and
then fill in the gaps instead of starting with something like [a].


[a] https://lore.kernel.org/lkml/20220606203725.1313715-1-ankur.a.arora@oracle.com/#r
[b] https://lore.kernel.org/lkml/20220606202109.1306034-1-ankur.a.arora@oracle.com/

>> The anon-w-seq test in the vm-scalability benchmark, however, does show
>> worse performance with utime increasing by ~9%:
>>
>>                          stime                  utime
>>
>>   baseline         1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
>>   +series          1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )
>>
>> In part this is because anon-w-seq runs with 384 processes zeroing
>> anonymously mapped memory which they then access sequentially. As
>> such this is a likely uncommon pattern where the memory bandwidth
>> is saturated while also being cache limited because we access the
>> entire region.
>>
>> Raghavendra also tested previous version of the series on AMD Genoa [1].
>
> I suggest you paste Raghavendra's results into this [0/N] - it's
> important material.

Thanks. Will do.

>>
>> ...
>>
>>  arch/alpha/include/asm/page.h      |  1 -
>>  arch/arc/include/asm/page.h        |  2 +
>>  arch/arm/include/asm/page-nommu.h  |  1 -
>>  arch/arm64/include/asm/page.h      |  1 -
>>  arch/csky/abiv1/inc/abi/page.h     |  1 +
>>  arch/csky/abiv2/inc/abi/page.h     |  7 ---
>>  arch/hexagon/include/asm/page.h    |  1 -
>>  arch/loongarch/include/asm/page.h  |  1 -
>>  arch/m68k/include/asm/page_mm.h    |  1 +
>>  arch/m68k/include/asm/page_no.h    |  1 -
>>  arch/microblaze/include/asm/page.h |  1 -
>>  arch/mips/include/asm/page.h       |  1 +
>>  arch/nios2/include/asm/page.h      |  1 +
>>  arch/openrisc/include/asm/page.h   |  1 -
>>  arch/parisc/include/asm/page.h     |  1 -
>>  arch/powerpc/include/asm/page.h    |  1 +
>>  arch/riscv/include/asm/page.h      |  1 -
>>  arch/s390/include/asm/page.h       |  1 -
>>  arch/sparc/include/asm/page_32.h   |  2 +
>>  arch/sparc/include/asm/page_64.h   |  1 +
>>  arch/um/include/asm/page.h         |  1 -
>>  arch/x86/include/asm/page.h        |  6 ---
>>  arch/x86/include/asm/page_32.h     |  6 +++
>>  arch/x86/include/asm/page_64.h     | 64 ++++++++++++++++++-----
>>  arch/x86/lib/clear_page_64.S       | 39 +++-----------
>>  arch/xtensa/include/asm/page.h     |  1 -
>>  include/linux/highmem.h            | 29 +++++++++++
>>  include/linux/mm.h                 | 69 +++++++++++++++++++++++++
>>  mm/memory.c                        | 82 ++++++++++++++++++++++--------
>>  mm/util.c                          | 13 +++++
>>  30 files changed, 247 insertions(+), 91 deletions(-)
>
> I guess this is an mm.git thing, with x86 acks (please).

Ack that.

> The documented review activity is rather thin at this time so I'll sit
> this out for a while.  Please ping me next week and we can reassess,

Will do. And, thanks for the quick look!

--
ankur

