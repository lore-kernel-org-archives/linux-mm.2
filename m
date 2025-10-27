Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A49CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 19:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FE158008C; Mon, 27 Oct 2025 15:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ADFB8000A; Mon, 27 Oct 2025 15:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F138008C; Mon, 27 Oct 2025 15:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 583118000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:34:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF01113A258
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:34:50 +0000 (UTC)
X-FDA: 84044896740.12.2FC38EB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8426440009
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:34:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eWR6RdId;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fzu2+IAH;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761593687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJnt10zXKFmSj83xThKHQ5JCBmUR2CV+5xy5UXpPlZ8=;
	b=vKm21QFf1RdLFdinQOl6vQivNhs3ClV871kWu73dO3w5ir1PT1wC32Ta8JdO971Clt+Y6/
	B/iVyjTIho5xdAsf3q4/g+/OX+Zpj2YrYWD1n1zQ+/zBL01g5AeXaGK/3MPHFB+g/Fh2c7
	jVomCSk06Q57zTOuZlwVUPtSSbq4Vrs=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eWR6RdId;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fzu2+IAH;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761593687; a=rsa-sha256;
	cv=pass;
	b=JHN2P7d+QtMIzMLONskfjL4d2118+ZOkkLammZE83fZ+YjUY1eHXnqYO4SVzlMwoduK0sO
	VCRi6sM0Ie+lnv+KPLx6kJQXbbmmsGXrtSuvadSwkQKZyhKN+YoQ9kgRLKXR/DHPSP4HM5
	IHUdKPhtzv35LmQnFh3hRJSwuEvLdYM=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RJUi3u022180;
	Mon, 27 Oct 2025 19:34:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fJnt10zXKFmSj83xTh
	KHQ5JCBmUR2CV+5xy5UXpPlZ8=; b=eWR6RdIdo0QP58pTofJuBdstYV7EKVjLAc
	iu1dCG7Qv/X0U3tIa+r+oO4O1fHYYXT1Eds+Uy+QB/c9M088B4MnY4HJrlMtjay3
	gap2FO6jit6FSSS9wgJygedrolRtrytMigeky4I6iOtbyX24uCN5eBAb2RdOlMvT
	x5LuMI1QIiGz4Jv1/js9ryvHVgUP5Qh/Ft30HISKzEr5EmP9JMYde6zciCFDfdCH
	VkYyyxGpUmUKLsZc1srFp93BZHhRYH7KtzNhKNECw2JTK9Zqx0VGELMGXv8Rkvzf
	skXDAsfz0kivqvHeCIs8ya5MSjeP0Has+7WFPA/KKpGhRiSG33UQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22x6ss3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 19:34:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RHpl7t035098;
	Mon, 27 Oct 2025 19:34:33 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010031.outbound.protection.outlook.com [52.101.46.31])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a19pemhwf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 19:34:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CNrLF43VyeoqPAmpB5vf7PzUFbQ3hKFPZlVnHeNJN6FoRbSuLJf5heWidCgKIMmjob9Xw8IpvhHC0e9nKq3xyc4snh+m2q7Bho9IFaWNnRkJ0RdqsksBF4EIgD/Z0mdYXV/WW2GnrJahZF6UFhML+3GbxtFn8U7+Gvx1xMLcHFSdWylwcQBfF5GgmFkUp3TT3QnZ2PsJLL/UCSIgMHOQLL9R8qFUSjItsJ/0D69/YYidYVo43ataIlWB5WQu/GdK4WV7+yuy0QYzsibRBOKF6ttdrmBV3OzHb5IO1XffHvvDM683ad/SNwyjDFLpXHgkJ3jP1T6f7Q9CeFGSj7k8OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJnt10zXKFmSj83xThKHQ5JCBmUR2CV+5xy5UXpPlZ8=;
 b=C6JWFpAR2l00FGBzBbcsEZN0LVwhVsT9yK1vD88OtgRj8K87Q5im2k4BS8xiy+zeRDXOW4loxQb91uYx0elaPL/FutDArpderdcML7j5JqySCpHu2E8lF2Y6M5j/SDcq1wkkoyQP+I4pVElBBo9gklhXhQ9i6z9LSzbHVjhmOpJvOl4Rwy8/uUayIf+PV2yZUqV8jvkYAoF2AauySsAQoYm0D6Ky0c+NKK7+wfdg1AJ/gmi/7i3l1uotNZbLujWX/AmIUgl5XhhgIaxZBlvdFdky1gAWxs+W105Gj9bfSNNrRyxcvQ7v5Bi1eEWA3SjOn+g24frvEMXUAGT+dOrWLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJnt10zXKFmSj83xThKHQ5JCBmUR2CV+5xy5UXpPlZ8=;
 b=fzu2+IAHEVCRUZa5IHCRbdGOrve6mTcV/iNsrYEUE81tkXcvjtflcDxeTd7C46Txc7SiF9k2bKR0ObZ+tyl1OvmOaWPWzns9Gfo3xwluN3O5x0THEeWOHwmb0Il6V+XkJR/DNPFHdqbaYKvorwdMr+nhS1elUD6INne8uGdkvhU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB997655.namprd10.prod.outlook.com (2603:10b6:806:4b4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.17; Mon, 27 Oct
 2025 19:34:30 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Mon, 27 Oct 2025
 19:34:30 +0000
Date: Mon, 27 Oct 2025 19:34:28 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zhang Qilong <zhangqilong3@huawei.com>
Cc: akpm@linux-foundation.org, david@redhat.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com
Subject: Re: [RFC PATCH 2/3] mm/mincore: Use can_pte_batch_count() in
 mincore_pte_range() for pte batch mincore_pte_range()
Message-ID: <5fb39e3f-a2d2-496b-9a04-0aa9d33c3189@lucifer.local>
References: <20251027140315.907864-1-zhangqilong3@huawei.com>
 <20251027140315.907864-3-zhangqilong3@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027140315.907864-3-zhangqilong3@huawei.com>
X-ClientProxiedBy: LO4P123CA0344.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB997655:EE_
X-MS-Office365-Filtering-Correlation-Id: 3557ff3c-e1a2-482d-f2ac-08de158fd969
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tf3ldVeR+b9hfA9qNsYq64R4sxbfUAUK9odNCyKF4OveXkLQ/tdcYDn70J8L?=
 =?us-ascii?Q?rWcpXIwL4kgUmKHF+9xbjo0FVyhAaKXXa8TzBC3qq/YdJHfeiFljwxOkuzvN?=
 =?us-ascii?Q?ZJtu6QZlKgr2VG8tcT0/x4HQ4cKuQXBI0h4RIFuHKjt+2mwhf9w68oIuVLw8?=
 =?us-ascii?Q?bqu1gaCNLALzxPCyOPHTISHI/xE6zhYk00e6e/orluyTfALEDB6F8mRzS0Mv?=
 =?us-ascii?Q?vyC9YNU3dFD0Ssssqh1ckoLU0kJUzFDorKDuFditXOY/jfyFR0jMYOUmYBsj?=
 =?us-ascii?Q?4Hn1654zUZy3Dyl1ljIuAaP6I7AEnJksl/OuDxUbuaurygbsBXsxSf6hWYEw?=
 =?us-ascii?Q?8qS3VkFJ80Ti6ZzJUIywBywUZMXXy+czz1igyS+svzzfJSopkfa1Aj2nJS3b?=
 =?us-ascii?Q?9y3/A1AP61EIie/moHvHXetuM8sr/ofDrD9P+PaqJaOW3kfz/oZ5IToCBPch?=
 =?us-ascii?Q?4cf9n+l05FhMjJnsdNoCnO4kvlD5nmxebOGcwIjI35MjH2CNWwnPeMCUevE2?=
 =?us-ascii?Q?Jp//+lPGnOzT08VNABHPRRt/MSrpXfHuBog1w8QRkKOVkBIufaLRwiREDsQ1?=
 =?us-ascii?Q?z/c9wr9/QltJox1+5xGrpX+LBRASI3QTQJ6OVGBAgZAEoAg9hx1wRMdsremv?=
 =?us-ascii?Q?W4UHj7a3lj/fbzHpN5IOgajDQTMtp7AQM57nTYvpBRq1BXXl5HKGtSJbsCu0?=
 =?us-ascii?Q?DZF5jgXhqWi1oCCRaRy39EZSvS6g1e3uxipPoGn/z/HaoDHbp3vVSx4g5aYX?=
 =?us-ascii?Q?5jVOvzuus4j1sqkLpOk2XsWT2o5Nmj9nhmTrkO0uWZzuVsWXkiq6k94vb/Pr?=
 =?us-ascii?Q?kzhjO/bi4RX/lMkZALZbtVxHFHcsdHM82HfaMFg9J6iWvAJsEnOHQrFXkfdi?=
 =?us-ascii?Q?0fcmXDS4S8LO3WPdUVf4/QAs0Ypx52T7MAn97auiBVTDuow/k5+PC2PGc23r?=
 =?us-ascii?Q?fn4R9gPVgUveql8rlkwblJ8ZjjfbV3PrtDGLZtyVozUTvS4R69ulbUbgxvRr?=
 =?us-ascii?Q?TSsVA59XJOZK/zqzDlhQITu7ujKzUdNzQTd2E0AQ6jdwDfWjsDVqnPe6P74W?=
 =?us-ascii?Q?zceCFs93HyUeYfZUiP8W+hdwwIWUjGRv6SmSmbjbNuX22BMFxElEtZnuXrVl?=
 =?us-ascii?Q?B9lZCONlvPev8cN7xcrt0x2wLTiZLxpK2IMOO35nkY2vymv2DvBCfTBZWEyD?=
 =?us-ascii?Q?EoYAemTuPsd9vCBgwYd6N2Yjzk6tuLf7eDQA+rNkgcUl/scj5K8PLAvk/V9r?=
 =?us-ascii?Q?Y/FlkhYl2wcrk1kfnelc+uNq2tegPAP6jdLKZyHTPa6/2eiGOvGufC7dvMoP?=
 =?us-ascii?Q?eJ6ph6srfoG7IHCxHeR9l0amYyMpWVlV3C5Vfw5FJFAyLKgkqvSlguNHePSr?=
 =?us-ascii?Q?S+hqfTTiezdH5mRD0gyqy1H4p8mxALXXYuPpFtWccLLPGdH7FOgUdMPylhE2?=
 =?us-ascii?Q?w6GOCpm/XuiZwDtFBw4Jr5k1jroM06jr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mD5xKIAThUBECg8zLRCYpoG57/G+phiye72kwHa5OatbQutLh65/wsvsdoMt?=
 =?us-ascii?Q?LgjX+qB+iKtyUmPfzy1OANHY/sE4WcEwaTrJyFIdVRhZ2jo4xu8yDQrObpbI?=
 =?us-ascii?Q?O9X90jYwQq5tBEaaluBL9qqSc0NIB8D2GPpZ/mJK5bkazx3Ko05wVFLayy3L?=
 =?us-ascii?Q?ZknGS56Icq6U8jLUEEsilLcmdCFXxVFiG74WolwTYVBjqFmMPNyzFN6z4ZJ2?=
 =?us-ascii?Q?Y013pJKPhKJoiHZ7zNJhC4y1scOSWXPUXsL3iH5UpO7E7P3hoRHwhh4Ov80X?=
 =?us-ascii?Q?f1aBoHLyqTUgDwjq8+QHG6HH+jCj9RCHK65OqD3HxwmqZNboG+DB8nB5tFPr?=
 =?us-ascii?Q?dCkFMuonjI0R+Yx1S7BlbykQ7hFv67MOLUDSagVSY70Obv3BVZn6/LbsYFDc?=
 =?us-ascii?Q?Z+O+I7cf2gei6ir/z2NUcuv5UF5CbNaAIq3tEZ5PeGHzpzpS0FE+X9MfY+7j?=
 =?us-ascii?Q?PEnvDo4AariA8HVL+D0259U05uh2GLvTOSX8RVU0zWqsM6WNTWEujrdijPij?=
 =?us-ascii?Q?BJelg2MI5vgYOR8X1bjobqpZhXl7RlyBMwoPNsOeXLwLCJlcI2GXRy7SdnYV?=
 =?us-ascii?Q?+XUOtAFtGnuO7GsRB/xI9TLtq9cEkXl05FZE4/QMgNPyIgX8xmqhJYk223NL?=
 =?us-ascii?Q?CVLNbXYP3nkG5ZjTGCmKG2TktFQ00vRkB/qsH1/cx9yYQVMZ13zJhZEmFruH?=
 =?us-ascii?Q?MIAnRj62LQPLCCHWbiSYrnUc3anSA6PPuvx5nmB/iitiNDIj3epWQzk8C0bh?=
 =?us-ascii?Q?jivTNexezZNodkWDCrJY2mwDbAQtrjSWNmvVOGBFoSLAIQBTKKwzAtU6ydbh?=
 =?us-ascii?Q?WPgCJFU2eT7YY0OoumT0Svc67gzB36A6lMHLwSQXWiuhpDa5wqYmz6rsgfBK?=
 =?us-ascii?Q?jVdAOwCm7a3o4GjOVh39HkWCN/8Mxu2tv6MmzKsgsIQ//oCRPeYK1SvW8o99?=
 =?us-ascii?Q?6Q+zV5327bU23rnh9iwruU+gNN1t8RsFed2EmZ/sFIWFSqm0UUQnjvuSAlG1?=
 =?us-ascii?Q?YbwRkvRaBsSfVUwidmYK3Cjf0TwWB+WOtpJzwriV3iafHDFkev1J4/4ap85H?=
 =?us-ascii?Q?haYZ+hN/FzzhXFxlGR5SCg6MTsNhuZp/IrfVV02obnpGo+Kyd+zp65U5S3JO?=
 =?us-ascii?Q?+SCc7zeVZ9wKEHX6WldF65UFXgfSpT7XMyAqF4oqyGdbE0ERUXRjQag9RYC0?=
 =?us-ascii?Q?tYDF6fWcouMYW4aWVbaVbh7sumlZpRuVesLnCWFC5JgQwNWYQGdLgha9s3MC?=
 =?us-ascii?Q?aViZf/0nFgeoVRq0eFQ8uE05ZgqfqkQyljeXU+7zzm9vVdm0GbVElN0S4D/T?=
 =?us-ascii?Q?Afh7P41ryY5i/OK8Ce672KYhPRnWIQwbXwCmvUcj5u/eINjZmOWHkVO9KE28?=
 =?us-ascii?Q?34K+4d7bgZsiC70kwKbznmYANFF44EfqA8St1R7RIyYzBcLi5dX9qMxrhnyx?=
 =?us-ascii?Q?6d2rdzqRtzl7G0aAJVNdNxRJJR2dTag2G6Gx/i5/UFmFYmZRq2MtnnCJOIbZ?=
 =?us-ascii?Q?qKBWHrNRzB+NYC0LjUR5FeAoxZxIwnRR+iw1goAnlg+hxLn3dhjDawWS5Nda?=
 =?us-ascii?Q?Uo2tD9z07YWu7EZizBNkNeEDa8n9cVyGvgTX/eP+C6mqkGr+v98DWMJ0CPFc?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DKj0zFj9pCeS3Z1zJJgzOqR+X32wrTeTRwzy/8d/jNig8SmSTRep5FlO2BaetkImXlk0EOfH9TeXYzCSIQXE1Vofyl6uqOezUwLtq2MAVn8NnaICJ428GdPX/LI6TzP7hKFYOZY4V/TsCpGekyQvXpZyaVmF9ur3wbQJ7HYAY29WiuEp0t5Ynpw6nUsah7WdUjLh0spFCYvkFEWmnmpZN8QpIa3lLtOKnVlzdfVvBHTJSvQHyUW31JFVRj2IBeMcQVnzv5CJYVNzv1egMmN2xflPIELENqDIQq/SRFn9csG0zPSYNJJVCZ7VslI/gpvcReAzYkdzsK8b7BIG1QKkggNRLjlNL/JCkKishoFLEzELWtipDJjw41+Jvnt+jUdcEYMLf2rTUeVfk99LIGdB1n+Gss1uispDfFnmaas5L7jMLYbMjm0kpL+NIMJIB9b6agn4G6babsTxYcxKrKlgqvi20FJQXcrRt2w1uCrd7blniK9sCIG22QbIocujtYO+i/h9mviDD1d5pRzBwn3NuOQwLyJaQf2l5Q/1qqkYoGunSm6hSc4VgR9ioCEu2XhmLFU6R1mWR+WPfLE/dP6bfmp54j/Nc0u2tF83eG0Z6YM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3557ff3c-e1a2-482d-f2ac-08de158fd969
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 19:34:30.5954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tOsWJXFzgaPgDayl3WRcJaL8+JOizAE1L+TTPB1oRntA11Dhy8ddOBGtSKD4knk93xiZewCIDztNt7dc2CWHua6o96LRhA3GJVtgZYehqRI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997655
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_07,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510270180
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MiBTYWx0ZWRfXw3bvATdeAd/U
 BrX9H/ceIAZT7SrYaUeDnowE1QYFuq0YePhBbZWm0KTjY6eEsetorCLA1f47Ja8QaWzyL9H6JtS
 /xs8Ac7kEwghra99Y/ChB8helkwaEN7XQZf/c/Uxgyy6TQmTCLiO3/fH32tllmJrk5XPCdH8VTm
 mJaSp4ftuEY3DW3yPj1iI93TrJhYko4Q+smcTUtB32I1R9Y/FahDWseNb7cAHSIZyhpQy82pXCs
 2532tL8mv+inBHWsQlKgKSDOk3mLMYddyRSHco2pG14g5yFxNEftBum9yz9RV7iIKQnZ0V0Yuqw
 nxH/DEE3sbmkem8B5O4KpF9rTNpXKgIejtpXNGE5xzd86SHq+UXiYRDiEfXtc6y56NKH0Mg9Cwc
 5Kp9IEebjlVlPimDxPCGdAAQXv+5yMIqsSr10usV4IvVtduBqlk=
X-Proofpoint-GUID: AJxkilJmo7H6U-Xyo70gNN1iDPL4je0C
X-Proofpoint-ORIG-GUID: AJxkilJmo7H6U-Xyo70gNN1iDPL4je0C
X-Authority-Analysis: v=2.4 cv=dbiNHHXe c=1 sm=1 tr=0 ts=68ffc94a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=i0EeH86SAAAA:8 a=MYVt_upB5_fBycqp3woA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12092
X-Stat-Signature: js9pgxqrkwgqj6tcye9rm7r6oqdgiate
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8426440009
X-HE-Tag: 1761593687-565411
X-HE-Meta: U2FsdGVkX18cYhbD++VAQI04zZAzIGLkU0otodRpjcul/qIV+NndHJtKa7MC4x6f35RXiID9QS/bEmbGGZbQIAbfRlesrCKt3xwQqn2TU3pjJhgfcJPfYWv98OMSmQH2gF8DI7jGL+QEBwk5k88l6uyx4MBqnSA5Axp46TuJBF158YjtpAEux/7jK0oCIUqOlYpUpj4vak1xrObfbDXjuH5t3LC7CMvK0H96/ET5155uXdSp52xQXicSxsLf8Nh6sveWKRVf0Ac4t+YRWsfsc2PMPjWO5k7kct5Ax2h9Lj6nUL7oM8ySGM3Ebj3MysHr8h2bWUE/6yTcOud/jwIIatwknSU5U2XUq2RqjatRkYZP24BPh+/OuBV+U9wMG+kPBN4vvtR8aZmzvN5z0W+mnUBpYQ0MWOYsVYMrgJZDNVBYylTiPcrlXVcYxf8twbQT/Of6LpnOJGrHgFf6gT55nZkfQM0vqkmit7JCTcd61Dg1+u9j4jkyBza99bNAThIzmrs8Djn7ejzPKywtx56G5ITRa4To/KBFM689MwvSCoUjYphs3RMtgK/1h270GvhvF11/qc6JlTC9EALmRJxyPbQlnq+iTklPpv5rSjK0IR+wOdGOdp6tvQsOeVO/kVlyksqWjVCBQlzbD2uxfRx9igHp+Ya1wPixwayd4tvfLIhqqtAm/sXwHwM3g0eTfkbCL+W6Xfb+biZsBvppYm95ejREJtu9AesAiPkj7h5lP0/2fju32TryZbn0cVRRIXbEEK/IJarWbQY1W/j/BzCU5aAJAXtTGgMm0Fkn2IVFteZFReQVB9M55c/6uujLQXQXH3AihHdTYmFwc73/+B3JsxFrVIwupY4IIZbpr5jWBRiGtJcd+XNgQFcQBzCNGXFMqbPH3ZDlXNiRNvjkj0I71McXynzvUOEtyDFdhXbJAMglCmuBRWasPkzu8vOA4rESOtkdW4vwjKNEYBZe/Lm
 1DucRr6C
 RfJ7IYgkI4/hk1dhkvELaO1Zs9U9y90CtaAeHJw1ele2sxHO9XTRt90NLAKxJP2q/5rGz3xExmF3A2ewguhejMB8YSlt2XRe2sRCxlhl3IzdgwNRu71MBWo9BrM8OhBYRTv0lcz1HtkXejYxRJzuhn7qXPvh8qzuR76x2nCpa3cHx9Tu8zRHG3H2AiyKaZEI2qbHI3CroNfd26t+p3N3w/0suZ3XjTgiRBZhy7gH2f0eRrXMqx4WBabpSY7xHFf31WSqmf6BrRDs8HjVZbLo6eqd8zDPHEvkAsRtQ/0mYNR0pD1pi/xznRvZ1YepRWTU7I/nm1W9uSeG/8isJCNhLxttRTWUwB25nMa9i3xx6ufq1q5pEEk6vacQdZhqHV/uKSrO0voydQg2penBz4hHmtaDMifNh9tIDUX+Hru7qKceQktAqN9jWH4Xci/VsaDPqsD4K4PfEN+/MyLiu26wk4LRfFlAv1cdxIEPS+350zumcMWo9PSm/47M/5xgylzhOdGdWJF+mx+MC/kscuniQiK8frhZCe5g6DuMnFAiPUrmJbcso5Fan2IFemc9SjxdTRTifzEN7b0Is1/EWRiUJO/5YglFJbDmeCfZyK7tAJ9cMQXwC6GZvzcJUpLUdzicU7QuRduoMI76Qkbg3fu1aGyY/W0qpnBP0yZXaDVoVB8aEm9CV079ix62532bB4hBxNq7V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 10:03:14PM +0800, Zhang Qilong wrote:
> In current mincore_pte_range(), if pte_batch_hint() return one
> pte, it's not efficient, just call new added can_pte_batch_count().
>
> In ARM64 qemu, with 8 CPUs, 32G memory, a simple test demo like:
> 1. mmap 1G anon memory
> 2. write 1G data by 4k step
> 3. mincore the mmaped 1G memory
> 4. get the time consumed by mincore
>
> Tested the following cases:
>  - 4k, disabled all hugepage setting.
>  - 64k mTHP, only enable 64k hugepage setting.
>
> Before
>
> Case status | Consumed time (us)  |
> ----------------------------------|
> 4k          | 7356                |
> 64k mTHP    | 3670                |
>
> Pathed:
>
> Case status | Consumed time (us)  |
> ----------------------------------|
> 4k          | 4419                |
> 64k mTHP    | 3061                |
>
> The result is evident and demonstrate a significant improvement in
> the pte batch. While verification within a single environment may
> have inherent randomness. there is a high probability of achieving
> positive effects.

Recent batch PTE series seriously regressed non-arm, so I'm afraid we can't
accept any series that doesn't show statistics for _other platforms_.

Please make sure you at least test x86-64.

This code is very sensitive and we're not going to accept a patch like this
without _being sure_ it's ok.

>
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>  mm/mincore.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 8ec4719370e1..2cc5d276d1cd 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -178,18 +178,14 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  		/* We need to do cache lookup too for pte markers */
>  		if (pte_none_mostly(pte))
>  			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
>  						 vma, vec);
>  		else if (pte_present(pte)) {
> -			unsigned int batch = pte_batch_hint(ptep, pte);
> -
> -			if (batch > 1) {
> -				unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
> -
> -				step = min_t(unsigned int, batch, max_nr);
> -			}
> +			unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
>
> +			step = can_pte_batch_count(vma, ptep, &pte,
> +						   max_nr, 0);
>  			for (i = 0; i < step; i++)
>  				vec[i] = 1;
>  		} else { /* pte is a swap entry */
>  			*vec = mincore_swap(pte_to_swp_entry(pte), false);
>  		}
> --
> 2.43.0
>

