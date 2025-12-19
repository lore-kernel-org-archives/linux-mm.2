Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D15BD74951
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 04:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4AA6B0088; Thu, 18 Dec 2025 23:13:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CC96B0089; Thu, 18 Dec 2025 23:13:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EECD6B008A; Thu, 18 Dec 2025 23:13:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA576B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:13:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C995E579F4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:13:30 +0000 (UTC)
X-FDA: 84234901380.09.804619B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6AA6B180002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:13:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UNzJStBw;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XnynmLM0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766117607; a=rsa-sha256;
	cv=fail;
	b=q9OrXZvzjDL/SwmAhNfpeaKlvuyYmz6fxp5fcAHrC0WNkMiiA8tJ5BLtsE/G7wrTUy/x3b
	iWJdxC8FbcSSjryT6W4AB0BmNq+liL1kdvspWgvYCTsiSoLmML403Dv0yNY0OV0/mA852d
	sQX5vF7SsL7au84Dyq8Z/6oitAYweMw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UNzJStBw;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XnynmLM0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766117607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8itHUmn2pkNuo5BXjvohrXfpjLIoSzsFnFdJ+2Qdio=;
	b=ol9ckpx/tViq9geERV9cUGCkMRMEQ9DXCdtie6t8qN0EXZ3bshKk4R+kqHtIL5v3WkbKEy
	AqA+jSlxrgeB6xO7tUVyKoOuF/YWGNkS0q5yWsDll0QyBhlm1aEY4gRKboRWq96YqoHdpo
	o02nZeekrHQrFsWucdoOkatj1qElLy8=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJ3EYT22840969;
	Fri, 19 Dec 2025 04:12:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=u8itHUmn2pkNuo5BXjvohrXfpjLIoSzsFnFdJ+2Qdio=; b=
	UNzJStBwW8Moy/6dkZrBWYk+IG6M01rEfEMRoLsXmp0t+lGh2RzUHa1iLsNsKCVY
	h/5KU/DGTeMYS0gdqcigKtlqTCKNJnlYeP464JTQYRT3p9AV6v6vnpb9cbzU4TUB
	IH1mgLEcPJxePpr+PLjanA4eMadYnQEsHnSjZDGsVMnederNs1/4Te0GZO2Yb1lQ
	V0yKqq4JEaz8l0g2SvW6BrieK4yFhg1ipM9RGwlJUh9IuWy73G0Ztfr33cpPbLsB
	IrIOszpMl3QXfytx1pNLXdKz2lzyziirUnQD8QCCNE6j3vHO+0HP6ttkwMfLlX8e
	u7HwD7BJPJFzjebGmMamvA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r2cgf7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 04:12:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BJ3leQR035201;
	Fri, 19 Dec 2025 04:12:58 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012059.outbound.protection.outlook.com [52.101.48.59])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtcw2j4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 04:12:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aMU/5LZX34KA53GVL+QtkwrbsnYAhmxX/Nvmy+10YvVDmmGdwILhuJfnIKZt32vgHRgBuJCbaxcuMPqnvTGIXeveeodZmor2eNknu41Zw0j3lj/mp3dPc8tF4OfCIiI9pzM7DwtxEaUjAWx1Rmd/bOdvWEosnE1DoP8sBLeF2yoxVAoVGgFCOvOJg07up/C9rQsH4xl70ZAUXgwji/veI3TBZBWZPngH+X8W0EvfMqP+xTIcmXfCRUCUqcnh0W3j6D5HW1vHfaUq1d4RgDO7SDsktOF/ZFM7687RvxlDHQ1Kb3rVngwzYyThvB2PDYHfg1+hkZil/sCaQVblFqVVnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WM5YuRh+ECMRCevHbsaxrWh8O/yz3Ps+4+/KyXZcrbo=;
 b=jYcvgrDWnYGOvKdHYL4sIrCT5FAje1sn9MMRethx96U5KCpUROwUywOWv3gCi73/b9ZaTwDvpYwap2wFoI5Qkk6TcCpIlTjSwcaZkkRXsl6+p6GafR6Hj+MOOaLbDGO8Wef095wHAJFUyL2zdfqUgnvbYPI5qy2fgi47CkTa5JbK5gDwl2zWtXE7AkClwQfys/B8XratDor8R88ujCz7gnuOsrBWQmb2ka97kWt2zKKKx9kQZNX+d/XRuL2b2gGL4rYKybxsRgx+DJulRA/abE93DNk7bmKpKvCTAqSjq99JpqaAmRmGiAglcm4yz9u/Gt2i+D4LXojuauvZw9mQOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WM5YuRh+ECMRCevHbsaxrWh8O/yz3Ps+4+/KyXZcrbo=;
 b=XnynmLM0fkmQIKPE/dYb4r8TyL7Oi4+1c0AQDgoCGFlRz3hMeCjkt1Unuk6EZayEboi0EgkmkdNVvz71im2N9pUEq5wXnQQBMEEzOpp+pPMoOillk9jKulvxltsFhlv7seTUn0Y+V5EK3s5AHIff0dIneED1QZJcstkwNIYfWVA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH0PR10MB7409.namprd10.prod.outlook.com (2603:10b6:610:183::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 04:12:54 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9434.001; Fri, 19 Dec 2025
 04:12:54 +0000
Date: Fri, 19 Dec 2025 13:12:43 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, hannes@cmpxchg.org,
        hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
        shakeel.butt@linux.dev, muchun.song@linux.dev,
        lorenzo.stoakes@oracle.com, ziy@nvidia.com, imran.f.khan@oracle.com,
        kamalesh.babulal@oracle.com, axelrasmussen@google.com,
        yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
        mkoutny@suse.com, akpm@linux-foundation.org,
        hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
        lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 13/28] mm: migrate: prevent memory cgroup release in
 folio_migrate_mapping()
Message-ID: <aUTQuyUV4_ed9tSU@hyeyoo>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
 <3a6ab69e-a2cc-4c61-9de1-9b0958c72dda@kernel.org>
 <02c3be32-4826-408d-8b96-1db51dcababf@linux.dev>
 <d62756d4-c249-474e-ae80-478d3c7cf34d@kernel.org>
 <4effa243-bae3-45e4-8662-dca86a7e5d12@linux.dev>
 <11a60eba-3447-47de-9d59-af5842f5dc5e@kernel.org>
 <3c32d80a-ba0e-4ed2-87ae-fb80fc3374f7@linux.dev>
 <49341ca3-1fc9-43d9-abbd-ecaabdda6ce0@kernel.org>
 <a35751e3-9c06-4e02-81f0-c211d4383e5f@linux.dev>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a35751e3-9c06-4e02-81f0-c211d4383e5f@linux.dev>
X-ClientProxiedBy: SEWP216CA0124.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH0PR10MB7409:EE_
X-MS-Office365-Filtering-Correlation-Id: 4135ded8-bd2d-4128-e1cc-08de3eb4e255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?5bsp4Dc3Fhe2wVhGul5F7/fdHBWyTpY3QKH855shrq7gljOsO2M+Ro/u9i?=
 =?iso-8859-1?Q?0VEgRm0I5lmqZnqnO8j3U1u8l5Rm4xtaKhG2xbDRbGWjEebIHZ43XD4q6h?=
 =?iso-8859-1?Q?gAzpVVY01FVJQ8wXMio6FvMvD8LCJ7uJLg+/D0QPD3WzJgRDNwQScmiHiI?=
 =?iso-8859-1?Q?50GBOk7TbZX5arZpiOuTBH0ma7VAXMzofUQFvcwVhAUOx/RZEoEYtn62Y4?=
 =?iso-8859-1?Q?miz8j+MD7thPPfZpX7mjOPGfPVnWnaaazQAu2sjEmlxQFYhBOJ++wmpPVH?=
 =?iso-8859-1?Q?YLZkz4c+EByH9dkC2h2pkN89Q3wZYITf0mGnRS/DNyWLJgNxYxVkdG0u96?=
 =?iso-8859-1?Q?wu4XQCvllHtuHLiNrVWb4jg4ZbN4f3+r43eDCSvSyC/SGkifhPLpxPM1vb?=
 =?iso-8859-1?Q?nAxkb5edePBP23HYy8e+gbMQcJITUViZHLrodVB5rccN3g8Bu18t3xyc2D?=
 =?iso-8859-1?Q?+nrzroDy+k372D4+or0tRrcZdeWWxe6f90WSc04t/ah1ZFsfuSg/bb1gbc?=
 =?iso-8859-1?Q?WPwXagUDqu8luqq45JnlCksygac9reeLThG1rnMb8kbU2Y7/v105Lvul6a?=
 =?iso-8859-1?Q?VcFb6nypGxcDLVJaKONRHd+Jf9CLlhcoa9dBXOjSx8tu7DbWntRG3vajeY?=
 =?iso-8859-1?Q?ss7tHiREiH3/oJVJaDyu61qOVS35bZ1kmg992i1jFe4U0LmGCA5hXgcgiM?=
 =?iso-8859-1?Q?XnOTxSuo+zxFgMmrz1sqpMCyy490EOu+n2XzFv3snZ0eNShCotiUMbiQju?=
 =?iso-8859-1?Q?W2SPOeOw6W5LGOlSed32/BMfROAKGf286LP5XOLiNhtOdS2J80PHAa18JN?=
 =?iso-8859-1?Q?A3arHMj3H9SvclWb4tW7Os35CExHZVhrj95NfRPAthq1WZUyQdWgWETdJi?=
 =?iso-8859-1?Q?hsOzBcpB2NDMQU35xd2L4WH7pFYdtZCYzbOihTb3B/JxlXnlNQohVqAohR?=
 =?iso-8859-1?Q?fLTrJbKBXK+d+gdD7GjaPAFuW0hHprl/xw1PMJDp91kZONhgwQH88110wP?=
 =?iso-8859-1?Q?TNP9rCgI3WMWDtxLBHzXF9K/8oXtzs7Qeb1qdiXqGWbm+gC4JEkCyXQNXB?=
 =?iso-8859-1?Q?z42850ezmZmHz6FZ3zlz6jbZDF+qMWfP7ATeGT9FavVsxiXEJPOqpMHuSW?=
 =?iso-8859-1?Q?4wPgyzZjmpxvSKMuHxiSnP6fs8nw1EPC7cjnuPstqkjNd6YSAQU0phtwqP?=
 =?iso-8859-1?Q?UxL9cW5y/CmJHk19tlZbgdSQT3uvl2GYp/KNV68Q6PRu80ffNkOmhT1jQc?=
 =?iso-8859-1?Q?xIc+Q5/xmZzU5mghofsF7iX3qzzrl/ooyY7o+/RX5c3cDefxS4gvR+Y32R?=
 =?iso-8859-1?Q?kREPgye54BbIeMvS/SjEnAyHd6EHmujb5oUipxsWQckvFO1h2uPZP5iipg?=
 =?iso-8859-1?Q?Cv9qHXAGWGnXGyxiBw5YNu/5JFrTyT4FP6iXG63m+4SldWNU44mnC2K5qF?=
 =?iso-8859-1?Q?Qbx29JUPwXLhYfZ+tWlOwdeIr1aXKWdRywUjFYOD7KGKC/TfsDK8lJszhm?=
 =?iso-8859-1?Q?/diXUZust9KUwf7Z6z25+Z?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?12KRZwSBvCucz9LLZhHFqfTKe0H89HlI6Sh+HKbUHfulCET9wAWOj823sC?=
 =?iso-8859-1?Q?GI4qqfAfL+4uE5Glk1HLZggl/r0YlOWRvCbiaP+RHBxlQ3AnhLO4PCnS/2?=
 =?iso-8859-1?Q?DNRRKsucWutVAw6QbXFcFyXHgsUyezNXGJ6dvKgOF7lHOOMZ9OCnbC+2BO?=
 =?iso-8859-1?Q?HzPL5dxZkjERXFAi5f1GwM7WTZv7098nyNZvJO1m1KP0xjIN2R7Y/7x3X3?=
 =?iso-8859-1?Q?Md6Wzvp245LBeSMCLN3w3/bUsu2gTc9e0ZHNFySwKcf2cz4vhUZaG1rRL/?=
 =?iso-8859-1?Q?ao5AKJTIhhLqC++qFDxeL/RJfRSilrU1zSgOpmvEnNgTZMQyZsF46Sv4Tc?=
 =?iso-8859-1?Q?kxvNB0GA9AhUB/8GDPKBqfGAfwJXFs8hdWBLFD7MiEGUYL19S/xVIMmvAp?=
 =?iso-8859-1?Q?Lt0PP6daXGVR9ABWs40VIldvT9v7zJDmZDdTM3ZcGLA1t1QVJ8AJrIvfLM?=
 =?iso-8859-1?Q?p8l+IrYkR2SNjyMfCzl5ilYBAzIVPtpVQ0SYG8gSCUHOg2NVBwDGYXLKqf?=
 =?iso-8859-1?Q?OfVHLGJDOmKWl5U5HcijZzR1ufsc4R/S5tvOEmaPaHY7ok4XtWtI5RhD00?=
 =?iso-8859-1?Q?5rW0cvy42uNX+kNhYTFijQJEQqpGcd5T4rcf0YKY8jonzEcu/zTGQnXvJE?=
 =?iso-8859-1?Q?WzzOkydox1QUWfcXMyO5ICPTq9qW4SSEGpktT4hTjJgIbgTl6DxHRL43X2?=
 =?iso-8859-1?Q?W7MdF7ekIQG7yjuKEpjV9FRoRw8Mq4H7MFBlH+RmrCCp40fU4AzrKfupHA?=
 =?iso-8859-1?Q?7Ar+kWsmDMZ4mcVMVvgBdJR8ogk3gA+SQRnTKlGxQSY7/FqJKbMgZG+jFP?=
 =?iso-8859-1?Q?kgPgyt18PoPyghWnk2WY3SMiiewnwrDidfKBBZ/Hm2zHymcpAFKVwR3bFK?=
 =?iso-8859-1?Q?IHvtR6Txb782tpEkiPFxYPopnQq9KWziFg7U0mdXYdBM3UriStkLRitUuF?=
 =?iso-8859-1?Q?Lq/Ap3b9rt5D8CZJkD0RzsnkSq5cGynCB0nvONOjicBzE0EY4wrqNdqCJh?=
 =?iso-8859-1?Q?4I7mKvfLJu0pyaxgA/VsRfITHl1NZircxIFPHtvaAUsS6VM5S3woCAu5t2?=
 =?iso-8859-1?Q?8u3tEQhab6AQrb/Pq7F7dGyMwXReO9vty5jhSTnP/NZprxL0FUc3nSOt5v?=
 =?iso-8859-1?Q?wo89ZJ1h25HmU81AZQN+QAeymcnQ7emV12HR6hFZ7dYHKOxJ4UCHJqoQK0?=
 =?iso-8859-1?Q?pLzbCFXBZj8r9NIwcdBIN5MD3s0CPbYzzW8elXlWLNfevtu4O1qrE8glwZ?=
 =?iso-8859-1?Q?xCyRPeVVyRpstFxv08BaJYwGCzXZXrfiIxCOMIlxWIL+uR7MK+JcTiwFX7?=
 =?iso-8859-1?Q?Br++w+T6vD6cZw0GtwASb//s5rgJW88eRjC+gRzgJy49YRAvMZ+wS6yA1m?=
 =?iso-8859-1?Q?J/H0yeAaNGQFWAqGEMeZKH77ZUaUfRaihfw5pF/qZ95vW230d+z7Eb7y+C?=
 =?iso-8859-1?Q?2n3/XmLtOFjdZBTIFKUPGvPr/a9QN5x/7cDW1COQjbY+HfJcVHpU9O+5in?=
 =?iso-8859-1?Q?QeuV0JmE1T8fnF/BrEnwwJs65KsY7PWKWysIW8Nom6NFX8Cz0eRtqiu3wf?=
 =?iso-8859-1?Q?uWWGsK+lrxJDOPDGjn0/T782v3CmYzA2rDwquhA3gCeDeSca7sMGLfhwzQ?=
 =?iso-8859-1?Q?ITQGItl83VxgJBvSxqtLRzLCSRDHK/EQZE?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xWxBkOEcmlXFWD0Y+5HXEY2Ih0pAY29rgvLrxluwDqVnPB8oSOEQYk9lgSzLLGS/nJGUj1M3DrbRMpRii8GuHuhT+7a6oz91z0ofyCp0gsvbxo55tn2ZFhEVi6im+PdCTBR0AhLGJiBo3VCNAlyYy0jVy2t/YcITX1jyEFRcBvFYveMSNGGHldvdfWIrDkSbVVRKnZd4zrJNQ2z/xmAQx7fRulSzMnlmcnRaNmNGBMH4L9vK+pGOyr3kzr98t5azYUh9ePd1MjEptGq0NDHXrnttI9uUEBfAXuS/hu6JM6MT7EA/dkUFUxxvLuK7xehOzeLZymBHl62mSHqRDBQTLUNxD02GFhU6b5PZI9BHkU45Ayej7CynkePpgCpc8QflbjaaVJNZ011eTh5BifBfuS5IUjK+xniHq0AII5q9UEz0llHNcCnMWylMWUa6ah8zQzv+9aO0tILPti3GOKCct/79KX+5Dj27QwbjXLWD6ZeeDcBdUTle1wTgLHYgtNnH5QIlaq6mQnt86olgrY6Wr/1uXVfbJ9UUvppda2BsDbGXrhFLrfqjR1xgDhwr3uuYHm0BdQa0AgvmkGMUjmb69mZ4/s8Wmdv/WCO9w9fqYl4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4135ded8-bd2d-4128-e1cc-08de3eb4e255
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 04:12:54.6734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZC5DOvQgpioIhOYiCukZqN49Z5IPhZm8b+pVRz4Cjp4zLyF2KF1B3aL2tmOygt0n8Z+ZnPtAZOysykvG3t7hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7409
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_01,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512190032
X-Authority-Analysis: v=2.4 cv=YJmSCBGx c=1 sm=1 tr=0 ts=6944d0cb cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=yPCof4ZbAAAA:8 a=jCFnmExzB_1uawjlHK8A:9 a=3ZKOabzyN94A:10
 a=wPNLvfGTeEIA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDAzMiBTYWx0ZWRfX2yksplu1Y7SD
 qxK+kgDcO+idH9IfwQTqc86NBBA0U2Lk4z85EDFXdVCbQsLiBQ4hajVQD9fdKJi27dzvZ66/9LB
 +218a1L2hXQsxhT/0UPmw43z+cCe4r/3kj7DBUtkxKiCDusPg8HQxSkE9HwJEnjKO2Cie06w9eu
 goXlXTXh+NZsjYWvhANjjBtgCelsW2ejIWvW146lYMU3hbqczuo+zgVPB951kis0zyjJBlHiciJ
 tsxxf4UESyY5HOLqOlYxY+DDa6EpeZhZVAeDlQdi17IkcppFwtRxZPCVOIXXcndmLjgH9A6Qupq
 +YhIf/g1hqyRpINM/v5FeQ2kly3uhWhKzJzKs0JfwG5eb08qjsrxjhgjgFf7Dg2N6dbiubwM2bl
 JGKY+Zg7y4GTCjATtmPc0DMBQ3qf9qQlZ0aMVtohrPy3yYyyTMzuyzu8TYfn2qltjVOdIo5CBeT
 B8Qb1QjOe3v5FfQmpHA==
X-Proofpoint-ORIG-GUID: t5pV6SVKM6Q3s4aqLGc-BjwN0gIc4jvb
X-Proofpoint-GUID: t5pV6SVKM6Q3s4aqLGc-BjwN0gIc4jvb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6AA6B180002
X-Stat-Signature: ny5sh5i7miesx5k9w1j9t3t19q6iycey
X-Rspam-User: 
X-HE-Tag: 1766117607-925996
X-HE-Meta: U2FsdGVkX1+6hN0X2+XgGVuabWbVM7hVyP/qSUe+EtRcJcD8g6DVeLwoZbyRttu2OemqTNk4GQJFpq+A7x6JIZKGaPUrKlC6SKEYoI+B/jhxw56+dfZj9ZqjQAGd1zfDRlD/05nYbIc4gM034fOSxDzepccTulW2cCDy2AvPW7hA4KOZTIQ9y6vqf7OB4GtmWes1ogdXp2cbNYWGC6hB5U7SzTOlg2Gze3W9Dk/U/dA6Ic4yALPT3gNO2kad7R14pI4s3tlSZND6yonzSBKro5DwqWXn3EhnY00TMlqTCkbnF5+A40jIcDtz2/N4J7wyM9/kjFBFbyfNtw0UYL9+sGilDtJ8KCskPos6MMclGepUNNtcDPRQ4r+Cq2EenoHvsxnYyCd+3X8oxK4UDDn2L3iLlENjLp3vK5IJEuRQsxGh/eavCWMKaYTTm69bIc6hSLjsemVWlN0Y/8yg7EPXuu1xXC2o6lYXKHDLv++PYl21Hi3UOU4XP9k14LzC5n0cv5+NiwSIYJyqt9a4k6H2VVH0YGAiv7aLCSxLaad5nLFv5PYROZTHc7vPgvF+1yHWwdpjxvEyKWk/OCvJZeWoelBmwf6wPymFuDoHRAFkzGDULifBvt+yFPMPX9WKkqr0KRVkn9cW0/VZ1pPzo2XBHRysjca9shO53buJUQMWRG22d+BCCefumC9KJ/hngy6Kv6zJa93mWBOIUtmg8geW5kGo6xB1u1IZXJKs0li3RYPIQtLYmcNUOqE1l9npvXf1FYxki/GMSICNq2XPzLTHmDy8icCcLQRuQ+26fXYouuk7DMaJtZ1C1qfAg1qLXSiCBiNYfmpZ9aZSNLhTwk+crhnACT3Ng5I0SRj1hmqGxyAlygV0jQJLpbz2geSJpscaGYJuKVIfbg6m3ONvFfMPE9bxaBKW1jtl9qQTl0c8GgehEu+xcv2zE44eUWf+LuX7nX1tvv7r+850nPTQPPM
 nCLAdC/E
 q1K4CmnEaC2BLyKyq29S9APn2FWbev1oO+zGR+8xbpvyp/MLpjVjJgVJ68w8pUroye0/Y78hxaXCuPz9KNsbpD/qRLrzTGs6PiwAPv10UxVdxvlYKotF8I6iWkO6NwUPKQkWT3w9uww1LCILdvOECvz93ydtfgZ6OhRHPpINSeVXNGsXxddRVubs6ksQGNKt6+DUSwOhdwAjwhhcPAvhbW2ozuYWSQ9Cp6x/+UwftcxkA+ofYuhX64dLpigmmXTF1M7n+BC2XZjF4WVIhBY4T2pNVKQLFH4hjazj3xzi7zofa/6UmxKBTcTy4YGW7GRWxQWGbP3x2ZbPBZlYDq3p0cL/e++h/kyGwnXZk/gZwuBxmMrjCNRNB8/epUlIW1dFARyYmCZLYDqYITHxN3MhpVpJl/y8R67oCSzBLn+Or9lbEuOWEBF13jpNoPMwKlPMTK2Lt+v7EoNB7Ctd7SPMs+AFOZjoY9g9t50YUIHOB+/hLJ5wOShYnXlEUH9FqrYwtLXFd2shlHWTJJN4yHU2zq3wqPCaoLdg8Jc5e65i7A56W3TzwOcFj3N0mSuV7pO5n0QtMcaCaonLTU4ECrZ7ilNltV2kjfhZxOh6Ubil/4reasXKwLKg1pRAetSi2po3JKFNTUgPo33jTeFEgetYRKrDQq7NlR3jvj3pHTyG47khVZTvCxZB+CLAvzE2arNqdpUWi/LK6esHnuhSZxijiDHpuUoBYdU/CL+BciAUn7nxZVHDVlX5VVicOQKHTasGMk+h1++ZBkVeYOQSecQNRNLNfw4CCcyEWlVLN9xnc9co/sn3OHq3PQ00IRS/KtJU/dwVb+wljxVxwB7ZmLkHrPRQB4ysU8MB+X+cYSKn+eUegiHjzCIckccwQrMqG8z03vZMQjti7KqTjo+95NaceIMd8AA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 09:16:11PM +0800, Qi Zheng wrote:
> 
> 
> On 12/18/25 9:04 PM, David Hildenbrand (Red Hat) wrote:
> > On 12/18/25 14:00, Qi Zheng wrote:
> > > 
> > > 
> > > On 12/18/25 7:56 PM, David Hildenbrand (Red Hat) wrote:
> > > > On 12/18/25 12:40, Qi Zheng wrote:
> > > > > 
> > > > > 
> > > > > On 12/18/25 5:43 PM, David Hildenbrand (Red Hat) wrote:
> > > > > > On 12/18/25 10:36, Qi Zheng wrote:
> > > > > > > 
> > > > > > > 
> > > > > > > On 12/18/25 5:09 PM, David Hildenbrand (Red Hat) wrote:
> > > > > > > > On 12/17/25 08:27, Qi Zheng wrote:
> > > > > > > > > From: Muchun Song <songmuchun@bytedance.com>
> > > > > > > > > 
> > > > > > > > > In the near future, a folio will no longer pin its corresponding
> > > > > > > > > memory cgroup. To ensure safety, it will only be appropriate to
> > > > > > > > > hold the rcu read lock or acquire a reference to the memory cgroup
> > > > > > > > > returned by folio_memcg(), thereby
> > > > > > > > > preventing it from being released.
> > > > > > > > > 
> > > > > > > > > In the current patch, the rcu read lock is employed to safeguard
> > > > > > > > > against the release of the memory cgroup in
> > > > > > > > > folio_migrate_mapping().
> > > > > > > > 
> > > > > > > > We usually avoid talking about "patches".
> > > > > > > 
> > > > > > > Got it.
> > > > > > > 
> > > > > > > > 
> > > > > > > > In __folio_migrate_mapping(), the rcu read lock ...
> > > > > > > 
> > > > > > > Will do.
> > > > > > > 
> > > > > > > > 
> > > > > > > > > 
> > > > > > > > > This serves as a preparatory measure for the reparenting of the
> > > > > > > > > LRU pages.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > > > > > > > > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > > > > > > > > Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> > > > > > > > > ---
> > > > > > > > >      mm/migrate.c | 2 ++
> > > > > > > > >      1 file changed, 2 insertions(+)
> > > > > > > > > 
> > > > > > > > > diff --git a/mm/migrate.c b/mm/migrate.c
> > > > > > > > > index 5169f9717f606..8bcd588c083ca 100644
> > > > > > > > > --- a/mm/migrate.c
> > > > > > > > > +++ b/mm/migrate.c
> > > > > > > > > @@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct
> > > > > > > > > address_space *mapping,
> > > > > > > > >              struct lruvec *old_lruvec, *new_lruvec;
> > > > > > > > >              struct mem_cgroup *memcg;
> > > > > > > > > +        rcu_read_lock();
> > > > > > > > >              memcg = folio_memcg(folio);
> > > > > > > > 
> > > > > > > > In general, LGTM
> > > > > > > > 
> > > > > > > > I wonder, though, whether we should embed that in the ABI.
> > > > > > > > 
> > > > > > > > Like "lock RCU and get the memcg" in one operation, to the "return
> > > > > > > > memcg
> > > > > > > > and unock rcu" in another operation.
> > > > > > > 
> > > > > > > Do you mean adding a helper function like
> > > > > > > get_mem_cgroup_from_folio()?
> > > > > > 
> > > > > > Right, something like
> > > > > > 
> > > > > > memcg = folio_memcg_begin(folio);
> > > > > > folio_memcg_end(memcg);
> > > > > 
> > > > > For some longer or might-sleep critical sections (such as those pointed
> > > > > by Johannes), perhaps it can be defined like this:
> > > > > 
> > > > > struct mem_cgroup *folio_memcg_begin(struct folio *folio)
> > > > > {
> > > > >      return get_mem_cgroup_from_folio(folio);
> > > > > }
> > > > > 
> > > > > void folio_memcg_end(struct mem_cgroup *memcg)
> > > > > {
> > > > >      mem_cgroup_put(memcg);
> > > > > }
> > > > > 
> > > > > But for some short critical sections, using RCU lock directly might
> > > > > be the most convention option?
> > > > > 
> > > > 
> > > > Then put the rcu read locking in there instead?
> > > 
> > > So for some longer or might-sleep critical sections, using:
> > > 
> > > memcg = folio_memcg_begin(folio);
> > > do_some_thing(memcg);
> > > folio_memcg_end(folio);
> > > 
> > > for some short critical sections, using:
> > > 
> > > rcu_read_lock();
> > > memcg = folio_memcg(folio);
> > > do_some_thing(memcg);
> > > rcu_read_unlock();
> > > 
> > > Right?
> > 
> > What I mean is:
> > 
> > memcg = folio_memcg_begin(folio);
> > do_some_thing(memcg);
> > folio_memcg_end(folio);
> > 
> > but do the rcu_read_lock() in folio_memcg_begin() and the
> > rcu_read_unlock() in folio_memcg_end().
> > 
> > You could also have (expensive) variants, as you describe, that mess
> > with getting/dopping the memcg.
> 
> Or simple use folio_memcg_begin(memcg)/folio_memcg_end(memcg) in all cases.
> 
> Or add a parameter to them:
> 
> struct mem_cgroup *folio_memcg_begin(struct folio *folio, bool get_refcnt)
> {
> 	struct mem_cgroup *memcg;
> 
> 	if (get_refcnt)
> 		memcg = get_mem_cgroup_from_folio(folio);
> 	else {
> 		rcu_read_lock();
> 		memcg = folio_memcg(folio);
> 	}
> 
> 	return memcg;
> }
> 
> void folio_memcg_end(struct mem_cgroup *memcg, bool get_refcnt)
> {
> 	if (get_refcnt)
> 		mem_cgroup_put(memcg);
> 	else
> 		rcu_read_unlock();
> }

I would like to vote for open coding as we do now, because I think hiding
the RCU lock / refcount acquisition into a less obvious API doesn't make
it more readable.

No strong opinion on introducing new helpers, but at least it should be
obvious that each variant has different restrictions.
 
> > But my points was about hiding the rcu details in a set of helpers.
> > 
> > Sorry if what I say is confusing.

-- 
Cheers,
Harry / Hyeonggon

