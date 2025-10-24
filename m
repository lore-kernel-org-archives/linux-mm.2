Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B44CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08C98E00BB; Fri, 24 Oct 2025 11:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1738E0042; Fri, 24 Oct 2025 11:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA89D8E00BB; Fri, 24 Oct 2025 11:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4EE28E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:34:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B13C1A0EFE
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:34:03 +0000 (UTC)
X-FDA: 84033403566.02.67AA24B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0CB961C0011
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:33:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NZWcM5uq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xOfkh2lw;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761320040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cztPWs10c/+tu5AOMsOXR9m5OdoH6m0PqtJxu50c3dI=;
	b=yVVSGOON9amu7RUMlzNP/YJsnGdjPoabzApeEyolcfMD9VlAGAy+qOV90TKFVtEGskovDp
	xSnIFglTjceBE9PuSnR7ROQTEdgwXn96uJaxdiF0m9gWXR1YvkUqyOl1aid1doQVHM52ml
	/cLzXpq/tETjsnHXWJxrevP9i6lRVXQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761320040; a=rsa-sha256;
	cv=pass;
	b=krdLZ1Tw6p6wVXFtZ4VFMltjDllfGfvLb7yQmzmf0xMTwWxeyaeJA4ag/qP23k5E2urIx2
	qYSNH2YpffGoMhQwI2iC0sD964S2PLWrC5jI9OyxIrtogQ1HH3/ACRkkXM7vZFu88YRznF
	FeabEL2AR/lodKIPJUsJCoFvGOTdKKY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NZWcM5uq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xOfkh2lw;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59OEgAB4011455;
	Fri, 24 Oct 2025 15:33:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cztPWs10c/+tu5AOMs
	OXR9m5OdoH6m0PqtJxu50c3dI=; b=NZWcM5uqvQIlc2Pgo7akSHwbcn5iY6iBMg
	G27S3cjmjRi3U+AHS+8fM6GngFgKGIutxYBUWXz9Ik0Oe5aK+MdkbKufq+IlPGJz
	4yG69QR0oaFDb6smXpAPmJy+cIVsAmLaSGv1IPoJS+c9zHC3POeO8/TBzopX07iQ
	77TpQ6X9j8/q5UUMZAWm1Ol68mWGuAe3rCESHTP+ziy+aekqwfOtsH2YlU+IeT6I
	b9DVaeabPLsebmh/uhHsKF4RiERTYor/BFK+cjTkXfvXDXnnH//ZqhlCdUXIG5JU
	PtEqMuBQr1x4Wm8mOYFhUI0oZsfyCZy59JIMinGE4mMUmMMU88ng==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xv3k53vc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 15:33:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59OE9cgj030461;
	Fri, 24 Oct 2025 15:33:52 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013059.outbound.protection.outlook.com [40.107.201.59])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bh41u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 15:33:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WC6yvRQWM0U7D0/iSmjuGp5jTwNmaXNzVxNy8bmYsDvIzkJ4/8NHK46ioGlNbubipC/adHuLXzTPKNjDpPHXNgq2ZrYX7ubRrOroDq9tC3nzZehWAPGuKHrzhSOy53VHz6MyqjBOGPwImyk2YmgJ1ThI19Mz6UUvd1gc4tHcQDJnEj4EGfEUncgJ0HwVKp92BbI30FVEaDsWy0aQJbTHfRGnLQgW0ExTkxvyN5T7qgiDEniKq4nnkpoj07nxvfUfp24uNOWCqGqNYYsgTIsUCqsiS4YCrqyOUh9W7oc3IQbjYPQsaRPqr2VPLm/X3OZVaeG9/tpsx8De19vD29gxBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cztPWs10c/+tu5AOMsOXR9m5OdoH6m0PqtJxu50c3dI=;
 b=VxgWogebETwxAdIN5iKtO7nZkpx1uppjPz8NmdYTrBtbsG9I4yj2reOY2oW6DVa7SypfSKAQkz3CGnqLP1VqCUe7EihP1aBJHMOR77ABV8c8OChRu2Xv9QFLH1WuMwXH9Wy57Baq963oq/9EMtrU1SX0c6qMy8YNr9WYCCUH1RWdd7yzWK0crH78kioR6rZ7zWMgw2v9vtHojzpLCTzqrcYssG79dmeHkl4TbiyR7dmrTfpSWymC+ZLBvyItABRKiAfeBgwqowLdbkaKTuI3CZgtrfdYjylA4Qg//vg6J0Nwv9XNF2luyCdtYO+dgnmAQ3crkQjhTbiahk1FuiHo8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cztPWs10c/+tu5AOMsOXR9m5OdoH6m0PqtJxu50c3dI=;
 b=xOfkh2lwt5JK4Ej/oWDqzEq0oFEdqYJMl3iOU5SZYq1Z+R156WoQfgbf54feRZ1P0fnctJDzLe5NFrHEZWcBH338mzndMYUjuuE+vCqLdC4a3BVNMkNtL0wJJyt71CAFVQHUOI8NHHYI7UMAF70+dBSAkKZL/EU7W4FaYCOvt7U=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB7360.namprd10.prod.outlook.com (2603:10b6:208:3d8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 15:33:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 15:33:49 +0000
Date: Fri, 24 Oct 2025 16:33:47 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
        linux-mm@kvack.org, wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v3 4/4] mm/huge_memory: optimize old_order derivation
 during folio splitting
Message-ID: <0c431657-0c62-40bf-b066-f1b0e154c82c@lucifer.local>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-5-richard.weiyang@gmail.com>
 <f1830e4e-1630-4242-be0d-1cf65f20b54b@lucifer.local>
 <9A89CDDB-7C17-4804-8240-E068EA68F7D2@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9A89CDDB-7C17-4804-8240-E068EA68F7D2@nvidia.com>
X-ClientProxiedBy: LO0P123CA0011.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB7360:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ee2cbad-21a1-49dc-f8ba-08de1312bacd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K+405TVqsL2PKHcZ6UBJAB5oEkERkdm3v/i2cHArenpFTIErx1OCfWr1Nhzq?=
 =?us-ascii?Q?4JiDh/dy9q/q5krNk5Jh70px4pwK5JNnMEd3/abBJUgOF/MxgO+lrafx1+Ru?=
 =?us-ascii?Q?akxRkRxUrnEi62VqbNDbX3ObMRR/FLP83xFb31yQyv28uP+/hJlt//Y5BjBG?=
 =?us-ascii?Q?fnc/RcZswGTYyFGL1WnkmkM6V5oW2gKakPJ7nMtOnM5d2E1AyNuyZrCLzD3p?=
 =?us-ascii?Q?CY54dh2nUC2NEIwv/ChZO740sKRDz4htPAn2jaHft19NeDKnUq+m+W2vjgT4?=
 =?us-ascii?Q?1G9YPj0WGwiGAVEUzcB6LmsCoFvHfpokg46T2Vv1PNCrwU+4YjYjr4r/CiQt?=
 =?us-ascii?Q?mBtYaqP/A+PTrIpCGpvBo8a0YjFN7EGYGO+5S0yNXD08H80qeof1jJ9qYWL3?=
 =?us-ascii?Q?FqR/yTtKiq4c0KYvQiI88Fn5ibVIs5w9RBLZynA1gyvyzhLsKvEj0RXn8ttL?=
 =?us-ascii?Q?4KxgbvRlkmMj9m/d/FOAZElc7SnYhsWisDaeT9cOW/zyv3hW4szUrp6DFN1h?=
 =?us-ascii?Q?wNiRvhSrvNSLJmtYMoF0zq8XvvgucD3mwyiJsXatkZ2qOfhxTtGO6naLsmWg?=
 =?us-ascii?Q?bhiJ/o2YuwZ3a9BX/85kxSsVI/Wc0QWNDVugR4vs9xKTlHnYdD7m9G0hbnCc?=
 =?us-ascii?Q?+JyC48oi4qWNHOqioxnwMbyBA0lCErziU66KMf3HF+XNqgM5NB5bVAWykUJP?=
 =?us-ascii?Q?sqnwcFZHflTrbDj5T465VKYBY0aS5/ezw0T+xqouJBhKsnPhZiZuwojSYvVj?=
 =?us-ascii?Q?iKEK8fjxnYiVAPH1Nkiui6tXoVehIU8lam6OLQjV6XpXj87/jZIftSUNj0nI?=
 =?us-ascii?Q?z8hnKHNQ+c2hrUqTQlTakEx1jG1i7usII/BPqDyaxJ93/E6sPOl10jPlsjbu?=
 =?us-ascii?Q?6Zk8tovCGzeORjBrWfq8vDiufrpub3lDy5+6tsY0ihZNUvBx+fmCkFFLIU3h?=
 =?us-ascii?Q?zhhZKNPSJkWYimxtcuaB4z4fkERMI9rAcyeGDvXqTHKILW8vpKiFOtNQMzDG?=
 =?us-ascii?Q?SrFRLn51hJhrb805OZNDNaglakGGAzILcm8u24YWY6cX63FVR/rUi2fe02ni?=
 =?us-ascii?Q?rcAwAmFU4YWZbxLwNrADgjaWMZ8Dj3u35FIjDQe6BIBi3o/ej5rEu6yQPoLA?=
 =?us-ascii?Q?tLI1B+xRMHm6i/bEphJ0gadhc/qprd79jDvoEiEFmS9GfozWre0BW3oSN3KO?=
 =?us-ascii?Q?c+8Nvsmt38195NdQO/rbYqxUkGemXu9/wTqpdku7yGM8NlWzepgGotMmU7E1?=
 =?us-ascii?Q?8t13LnrjXArEfn0wI+j6VWXl3d1KO51QRyNdnVNdYTtBVyU/1RcK8ysa8WsQ?=
 =?us-ascii?Q?AfpsiH5cFDOYoAuezMDUZ/x6EwWJm3Fqmt1kyOoxFwd4MW7xqNCDN6+hHY0E?=
 =?us-ascii?Q?dvhKNKiHhjuhuji50l2WMPie93hU+B/FRgPqQ1c5ewOMYKb1qGIJuS64+unw?=
 =?us-ascii?Q?qktjrYprLotqsCWOxZtOSmuzBGpJyLy8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZCOc6m2Rd0Y0qVnTWzFfKwao87w5ClU5cNjICItW69yFXAlLTvDzp/Aw1Xir?=
 =?us-ascii?Q?T8t7ac6gucNfzoqWK94e41llgysWvcdxNlDR3pzdzroGWx7YI2yTshUtjO5S?=
 =?us-ascii?Q?VwrnGp7qfCOin6jtrOcY3qSDKB8ynOxdA6AW6JB4hmeW+Sadkz4Nswk6NC5y?=
 =?us-ascii?Q?7BezijL9p0SDg9bY7BnZONQutm9YTMP3uSpUCYSMufkfCnT09WmCPmq1pfGl?=
 =?us-ascii?Q?dug9GOb4T4/bfYVy2oox9WuheTAbVCiaPP5OGnvRuayt15WSqs2onzqKjBrg?=
 =?us-ascii?Q?lisAdJx6OPftDUftvTygzXFdS1KxDEP8I0PkohmCatDFC8e+ybzKu2qJkgBf?=
 =?us-ascii?Q?E8lBhn5WLCWJ2CxnTHo+SrBiulKBZeaXlKdYekiG2ynko4DuIC4107AowiN8?=
 =?us-ascii?Q?yD9y+SIlYUe4/dp3kHgWC9kc4i5TEKX97Cy0AvkdkR413G7d+ncxLp/h/qNo?=
 =?us-ascii?Q?3InImeEt62btYvXDFsGeZILCPW9QMnn3sk2SmPGDnJbHF3kxpfde6OA4DPvg?=
 =?us-ascii?Q?6q87A7EOaGBENngXQcu05hDetLoB9qWhVe4lv+ogdnLBw6xOWkRYUl5pjft3?=
 =?us-ascii?Q?pH5aSymrgb/5J/x3vDT8enFhJmyHxUm29o0Rk6uS+G2XVE77ARGAC3OsSRx4?=
 =?us-ascii?Q?3EgpfE2GV9Hdi4dvc+/YQNO5KGuB6cm6h/MR3VOUOPi7G1Ubcfu6m52R4qei?=
 =?us-ascii?Q?HVuGOKnY/fURZEbIQEetMDqDTrxd/qfZsL7j05B4Abp/vzh1i56AJ8O8GIW7?=
 =?us-ascii?Q?GUr5FIn9tnYPRi4BjqVOJZLFxBP8wu9mqRXI06hY5R0mcOyO1uNRl5QMLksU?=
 =?us-ascii?Q?kPMizsiINosX8bZT8lMqJRPg3g8xLe2P/uwxkfERGCMkGta4aANdqCFRTK0C?=
 =?us-ascii?Q?7ja7/+VxZ3WPEyxulPvY4PLHrkc6lGgcObhEQad3Gyciv/3RFQ//EnTvHosi?=
 =?us-ascii?Q?QOTGOFqFtnot98tSu9Hnd0fQwxodgMw1t3dYPAkOFqfXqm9C2zmcyWx9QuPy?=
 =?us-ascii?Q?0NpqMXNKui7NNz66Mdt7zT1ewA59S72KhbCBwxa3tQiX9yGR6FBntLWznV1+?=
 =?us-ascii?Q?s12rFww36B55nmV8HRKsH3KzMOZPsANlTqgHXMJKwmT5ByYpU8EybZdLMowe?=
 =?us-ascii?Q?erzj+VxftL4A3J6m3XHXCm57H+5xGPUJ5FhI1GgWiq7L4guJUIv+z5xVHE5V?=
 =?us-ascii?Q?Fa2wAttF3qunzNFZy8w72PlVD3ATCTxLrZ6Y/pPlCuIGPf7xdmxJuMnmwfE9?=
 =?us-ascii?Q?+nTJIUcUBLmgDKqFjsELh9kB5BzjP/jnZN/dNfIOOkQIpGlPGaS3t6tGUSOf?=
 =?us-ascii?Q?8xiKh6TYq6+92wCmGaImSQnHO0jPMl0YQJzucGbrOFmxTealU51zlXZzY4Tu?=
 =?us-ascii?Q?v2Aafbls3jyohd9vB1WjYD9a9cpidFhHhRp97+6OoZ2aNujg6bNvgEYjBs/1?=
 =?us-ascii?Q?ryEZ7O/q4Hc1y6/1wte+dpcbn1zSbwNbPYe9iHp0ayc44f/CdR4wV+RFMUZA?=
 =?us-ascii?Q?l9hCmPJOqlh3OKsY43VKph49FIufaThLHttoJ8nxAmlURuUXd4uLP1A8DcPo?=
 =?us-ascii?Q?Lh5IMf0ZLqbq9w9nQyZcoTAblHiEBnnXMn3FUvw0HvJWQ6rS2tACP/+cKLGp?=
 =?us-ascii?Q?BQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MH8t92cWRkwL21AR+wSFTRfAc1x9APneQL3VpFsXnwwtl1dcZQiPXttLVUQ7WhiZ+Y2WGDcGfI6jC5DxDJA9pni7YyNwGGzZa9ebFCdIMyGE/LaxdSlglhhZHrIzjE9LzGtbdZ+7fYPqECJ2Tj9C+yI4hjC9attTZDxTcXKaafN/gRCglC8v1oN86P+fIlN9tZKym/39fh7fkEPr+lDW6TONpHyRbK4TDXUJ0HJvUjgyhHaoZPqmBAvekXezzXi1U4fQkLsMTJcfbyC1jBRFTsKm0axTAVA6MK8bkoGrVCfFYU1b2w0QjYmvKHXxUAQG7hrjiRiw8gOy8VsQfQRZJ3g/trnNmURKYawBLZxP3pl2f5ANPAolfJtX7j3gBx5/Hh6XAzyZTmzBFMrGggiavF66RfyYkroiJhn+0ifeX64PZ7RkFB+9KfUl/3Y0WBEZISCAENi4abRf9ZSoxjivsy5O2u3kTL897O3vQ1aruQ0mrCDKqGg5bKMjd48+VajDtLqxwzEou8Ch5EqRZA4SfpwjcovaBpae4zWS5Tsw98bJOEfFxBSpIemAfv06I0m65rZNooRUdOp7ExUm7MuB4xQid1LuN41rkpabaVEVFTs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee2cbad-21a1-49dc-f8ba-08de1312bacd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 15:33:49.8211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D/sKMVfFmxQxZPGMUydIHPv8NQiKMr4D2Lev9IEs5xR+uwldub2gNpfx0Lw7k0dK7KVf6I5DevRhMsdRg8dl3bwvmp9HSGfye3XZ0OVz5QM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7360
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_02,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=983
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240139
X-Proofpoint-GUID: fIXn-My0ze-Qp9RC8NBAiMpLZizZVxnP
X-Authority-Analysis: v=2.4 cv=bLgb4f+Z c=1 sm=1 tr=0 ts=68fb9c61 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=ZhsIjZOnyd3TpveYbkUA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13624
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MSBTYWx0ZWRfXz22r1wksF/TC
 iQsxa5wOek//ztAndqZzChdHO4Pr48tL4s/PHkmUwzcbib9SbLDWZBBtp6tR+0FsC8EUkIFFkDn
 jHzJHBd6mZpXoJ56FIF5b+KQThYAkwAE/Be0z4NVRQgxBNMmRc6QOVNMQZDA7IqZtpD6/Cgg53P
 YhzYjNcgXu+xnskOGy0U7/MCs/KS/bBCh01Gc35FE+E5pDIXPo1iTuv+uFPvpaXRArz1Kvbmn6b
 grD46CAtd5Il12Gi3H6fQluBjcncZbKuYtwEQKL/K0S354I5QSa2XiC9/gNU/m6VFukuJQHosT7
 ODQiOm4TRRcx23r5wYjX3ZRPmAJpDqxEwWvXKWQKFNO3gWEDM4fTk/glZVS+fMTUJEzZqVowSUs
 9gvxmjCRKzo2xbZim8YrDIg1SYMd1DxkrNw/O4OjuNZDvS6bu/Q=
X-Proofpoint-ORIG-GUID: fIXn-My0ze-Qp9RC8NBAiMpLZizZVxnP
X-Rspamd-Server: rspam01
X-Stat-Signature: dzcjhfp7ujfxhxjhcueogwuc7nq3yskx
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CB961C0011
X-HE-Tag: 1761320039-805349
X-HE-Meta: U2FsdGVkX19ChTIZl5VsIsBRoTWteE13PGnqZiMJpTqb0FjKQw2/ToajQ6aI2hHutrONLzIqQcFXnhDQxqcKOMRHRIfS5wQ4vBG4OlBj+SIm/tCdCDvaFGmNYv2LRipS88vbk4eQ2jcQLL9sn3v0zgPqw+0a2lRqJPPUPU63SyXt/6vZSNh4gGZxeHiVxUyROvynYo/snNLdOgiOhQiIXUNu2K25nMu9rn4Da604jV2ZDl3+qN04w8lJTvwh2EVBL6W07wX2buPgOBtuhEUA83eZReNzANeLXTRGzWgbdUIlSbDVeytjlPQdqdyHwUqmVV6UbxuXxPX5iz8udz9Dm+TsZxNnFrZldQBKfRNIFYs7ExrNDL4anC1FCk/XE6V/rZwvkXvYmr6dsiKEKf1z08/TB2Nb2guwsGF2Wwq4bUVhCvd4CQ6aJ054XUavAfq+OjBqtxSoel1Igv8pqZuWyrRVql+dNyees6Y69pOamo/xWookhm4Ad/cDPLQYCwNwy9TQ7ABux7atIIcIOqbJrpPV7Api38/ZbWlhov86VSPJltnrjfKwnNC7BcV2HMOHxXWUy2l+hR9yWLDoXIFK7JcdX8qJRoS6rijB3oJFhgINQZTEjich4Dv9x9fr9sZoAZK6r0RuRdEq29snY6bRfG+VI58SdFnPc52myd7iw4IDVxmbLnaKYvwzCleRP0044dz2LXsqAVuGo3Y4hEa9PUcMBi5mnG5GA128FZsVAW1uNWxB9mH70/RSNLayK/39DYOdwimvZEGJvEwIHilGuLpAfHfVj9KXvX3hSrvgEjtNT/gbJTHpIrQZddWQJiFzXTckXmPftCD80N+sKSEl1jwJ2H82w2leu03kkJbEhP2b1R7/9xJom3F+PIFQwhbOlRKpUhIFOpezQ6r9DCvdRLLo2R7YJrTI5/8W6PTCBJawfnejwLhQCZLAECLv9l5EYu6yvLNvXy+DZlBln54
 P33qFR86
 3PfPUY4g4d+rtYeSoi3rddHO1cupWATl2UmkXb/qxk3s+3BN7Aq2eS25lXFYwJCmrQ2zcgmT6C40dInh75ETfOo7WYC8FIxnC/du/YuoIMh9L3WVzeuaiqR2Gh/o6qKPk7qmwQA8gkJMLNpBwVQXIcp33MKbiTbJ8TV2lhviEsAc37WPXQ/zvzTEc1HLi0xohQFMEJggRxt/eXwCKMzx+qOcdxEpW3+jz0V3snFNhS3UZEo+crdhHccJYYdlO/Yc+UgqjrlDFg/Apw8UHPGFMRzSjUTOpPv7WcPdnu2TsA6+W/aflrts0Z1Rc+kikr9QFbwHwnh4MKAGo1hUPPnznAtECGPfhR+CjJjQu+gsy8nDDhgxgc2lKhiITxt0V8HxT6x+AG6T6hC6idKjFDxjva/1HIZ9PYtqlmAxWq/+jqHrDVUkXm19zec3SYUF5W09pXNOI0VXmztl4CaEVd5VkyQkNjI5sjR0/WmEIAVL9pGThWfKMSjDysyp6KjOyjsMvIw3vytuCf6dGer+x9EW3ztRmSU8/tMZxOG0bewXkvNZVfsRESYwm3n0xK0MCj3AUw04GzmEEdOY+yYoQkeByrrusS+BaKySeZ44aeQrI2GqBn9vYzJQoYuk5bxt0AbG9fONgC+57GasPP11+/3YrSvCvIn4O4MOfriHeNa3yfbG+FTu4wmafpoAGV5/BR/z1zza8kTRN2KxI3eZvI8KmRUeB/8LhkBalKOm2ac8nc0QHzyQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 11:29:00AM -0400, Zi Yan wrote:
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index 093b3ffb180f..a4fa8b0e5b5a 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -3596,8 +3596,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
> >>  		struct address_space *mapping, bool uniform_split)
> >>  {
> >>  	const bool is_anon = folio_test_anon(folio);
> >> -	int order = folio_order(folio);
> >> -	int start_order = uniform_split ? new_order : order - 1;
> >> +	int old_order = folio_order(folio);
> >> +	int start_order = uniform_split ? new_order : old_order - 1;
> >>  	int split_order;
> >>
> >>  	folio_clear_has_hwpoisoned(folio);
> >> @@ -3609,14 +3609,11 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
> >>  	for (split_order = start_order;
> >>  	     split_order >= new_order;
> >
> > A thought for the future - now things are simplified, it might be nice to just
> > separate out the core of this loop and have the uniform split just call the
> > split out function directly, and the non-uniform one do the loop.
> >
> > As it's a bit gross in the uniform case we just let split_order go to new_order
> > - 1 to exit the loop.
>
> Yeah, something like:
>
> if (uniform_split) {
> 	if (mapping)
> 		xas_split(xas, folio, old_order);
> 	split_folio_to_order(...);
> 	return 0;
> }
>
> for () {
> ...
> split_folio_to_order(...);
> ...
> }
>
> where split_folio_to_order(...) just
> split memcg, split page owner, pgalloc_tag_split, __split_folio_to_order,
> and stats update

Yeah exactly :)

>
> >
> > BUT - let's please save that for another patch :)
>
> I agree.

Yes, let's land this first and that can be a follow up!

Thanks again for your help on this series and sorry if I was a little too
grumpy before :) I cut down caffeine drastically recently and you
know... it's hard ;)

Cheers, Lorenzo

