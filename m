Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56932D2F35C
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 19:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8B9E6B0005; Tue, 13 Jan 2026 14:49:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B63246B008C; Tue, 13 Jan 2026 14:49:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3AF86B0092; Tue, 13 Jan 2026 14:49:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB526B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:49:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A82D1B105
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:49:23 +0000 (UTC)
X-FDA: 84327979806.24.DDAA0BD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id BC4ED8000B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 19:49:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F8p+1Kb1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iGVsN134;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768333760; a=rsa-sha256;
	cv=pass;
	b=FgLsUS4QFwV3OMH6TBjL4WjVUPz4IvV86KNj8bVyEstGUwbUT+uxWquQvI0rOkvipvw5JV
	U7l/O1RQSDG+vhsWfapLVW962ngWA82CyK0LsG59ApqbTOUu1iI34DV8Uq7sU+jUBe9ecZ
	iRWyqHiAXtyGVsQeDNQmKvJRykwPfBA=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F8p+1Kb1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iGVsN134;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768333760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guEm9AGTD8uIGXNCwoykH2Ct2lR5+lDhIg3nhftawzE=;
	b=OCCi9RzdxKkZoXiBsHS1mkiKnzyYrj4xleZrSTd0paHTlxl98yKAMX9iUrQpUcELH8GBm2
	HwFRwAmJnyX0J7Qe0IFIJyAozCAs3h4Gx3mdXZoAP6qPZ3h2jmAE/ZVmY/X1iTwPUhh2BQ
	grKRj0KJ/L8imfpSrT1pu34I90Ve/K8=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DG8FI22418908;
	Tue, 13 Jan 2026 19:49:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=guEm9AGTD8uIGXNCwo
	ykH2Ct2lR5+lDhIg3nhftawzE=; b=F8p+1Kb1fc2oQnIWZU7L8xBU992X4Ri4RT
	pzTC5FHJ6MLgBMZgu4G85gI9zJcHZHxTfzaO9NQQ2kohuHQ+DhFFeXQfNcEoq01o
	j31WyR88l05X/TrVdxCzbIEXyyQCzNjHnXLGQFEus5w6jlygniAaQixQSMjteoJq
	GOtiXZJTC2XQiAJaXXXbMA4pldy7lISLyaXJm+TQeDXDmOGpUcRHDdI8F7HnndX1
	Ahx7HMnirJ91CP03J64eWnPJqWwDVamGat3qnQkON34TeFkNc+T7+tp8RBuiD0uU
	/0R6fmMtv9YqaX/Jdi9Ddx+OOIJZ+YGDDQKbaxW1hg1v+GSoA5WQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre3v383-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 19:49:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60DI99P1001833;
	Tue, 13 Jan 2026 19:49:02 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010024.outbound.protection.outlook.com [52.101.193.24])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd794xyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 19:49:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZZq0q5V3OKVHnZ44I+grJjdCISpWG/2R3/s3M+gUaEWt48GHkB67WnStfZFHtIP53cQmjXw/Kbrq7HQ0pWzgS3X0GP7616jd5Sa3zHcBeccehABNBgBREU2Lpna6u7p7h8UryzD//1b0EVfZX71+VaLX2J0hTrg3Up+Lz/v3v8iwVyAU4bg8YUu6dRLghnOoGbuGmkinSrs445y6bKy+71KmAK5qtwwzzR7PtmLXE5NaEgIKFWjES2dxgeh0s6OtBC/aOl5SyaY8/aJnwUGYvty60pyQBr3lIZCVuTV2t2VJiYi/zXktp7/z4PoBelSW0PsxEH5H/GOSnwdjcd6q7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=guEm9AGTD8uIGXNCwoykH2Ct2lR5+lDhIg3nhftawzE=;
 b=caj+3KbqH1rJgrQjRLxUWnTTvG0Rnp8EJfnLsThQhwx5yfnM37DBW24TXWYHYehRdKtzv8FpIQitNL+6IpFLJyx7DtqSQIIGT0a5vydwW1CH0/p9GRyHk0ThNYgsOy6Rpia8OBlZoMkKT8RJwokkQW9WDXQT9Or3M3zbWNgUYz7pi9ICyzILySfdOawc16vmUyTHd4geSBSexKjAzm6+YKq8W3dn6sI0ZHyhriSlhAyzWqabFna9liyz2zxeo8QVqS1+2LE4bKbcta8cQieAaDJvR5g+pEr3nYK4nRnzre1tE6HizX2f2P/qr3hyoa8qCYBPw11t91tSSh84UuUt6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=guEm9AGTD8uIGXNCwoykH2Ct2lR5+lDhIg3nhftawzE=;
 b=iGVsN134wUHGqE8zzEBhCrG7G+v45ZtbjOLqC5Jb3Y9NLYX0pgIh2xjTy86FwB4pn1z26am7TIW3X6NQ9gftuFEEIrdy//SU3QMzolf/QcQNTW7meoTXc1cPPWwbm2MRYXSHl1y1lO6ugCQFqwvvVL2BhKWItN9+PNM0H7aNtlk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB5814.namprd10.prod.outlook.com (2603:10b6:510:125::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Tue, 13 Jan
 2026 19:48:56 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Tue, 13 Jan 2026
 19:48:56 +0000
Date: Tue, 13 Jan 2026 14:48:52 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 4/9] mm/memory: Add tree limit to free_pgtables()
Message-ID: <nns65h74umsr3ahzx2td4pxbye26ootx7nibkhihxiczoyxodz@k4z7jrjr72ez>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-5-Liam.Howlett@oracle.com>
 <e44e1da5-7ee4-478a-bcc5-7726f3b52d9f@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e44e1da5-7ee4-478a-bcc5-7726f3b52d9f@lucifer.local>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0358.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB5814:EE_
X-MS-Office365-Filtering-Correlation-Id: 717f9013-0d7c-489c-a96e-08de52dcc9c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jNLt1nkYZ6I+MUAoqeIWMo79yTqK3ADTrhfUpeVtuNWPneFku2RyJVE17t07?=
 =?us-ascii?Q?tyJEFxGlCKjTAT9HmELn81kA3LLLA/E/quJvbZOnEDk7E8zi1xNMbBuIUbhl?=
 =?us-ascii?Q?y+0CjqgE2x9/D0Qi1l7IPBF7CUOzfhRgHPcNaLI0l3vpsKi/L/9sXHB214Mx?=
 =?us-ascii?Q?dF/jpN0pZzJSLv2+A5b5Sy71OU3/Mh7A1H1mQpCro7KDE2B+ByVSKbus4X35?=
 =?us-ascii?Q?jZoVKLH46IwMreyd3/PihDYzy4fOSN/I2wwB4rQeY8q5S3eiabT63hPWVc1Z?=
 =?us-ascii?Q?V+A5Aw0LkOTvsFiGyEzoVsz4W/+uTSQwY/RSrB3MarnHNyouUUfby2gQ3duS?=
 =?us-ascii?Q?8stfmMIGrDOm7WfUN63qmbxM663CZXgDCqvNaEICLZ3q6SZY7gZMSrp6CGD0?=
 =?us-ascii?Q?iU7hCMrSoMpk5kh0xsvxSCZ5oHB82Dq/KGYremfS2Xq+4FBSv6hy/gZe/OYj?=
 =?us-ascii?Q?+P+sYld7KQ5+Q/wEmE3h/A20RJdSljpP5G4ODHBJ4KKC/xJESd4wYh8kbcrl?=
 =?us-ascii?Q?+iS453oAF/NPrUcnyAK+zQvK7QAfyjPMJ/ZJeIwrrEATySdRKU3Gr+i6IqaP?=
 =?us-ascii?Q?gy4YP6EseGH4obMciJq54mXkB1bFbdUH1fnriuWfnPh3p3sWpwpk1qYRyA3e?=
 =?us-ascii?Q?+5f09Qy1M7URnR5ySHjohJgO/nENxEoybaOsU5ug2YRwgR+lQaWy8SP0DmnZ?=
 =?us-ascii?Q?BG0QR0iEJzY4RPUm1QrxXUZOIpn25G6gz9eI0ILVIqYo2Trm5sYF7Cv0rmdi?=
 =?us-ascii?Q?goByRKX7yosHIUtRVP/cfdzl32kYZEsryx3BlGrtIkt2hebhb1bmfOAAhLqY?=
 =?us-ascii?Q?TE++yCpDIyLoH7uHE1Zd5bw93UutSGCyfK6yudbRQ34TEY6lsFv4Yut2h3fK?=
 =?us-ascii?Q?l9/zuaBUTukJqaeMJ+6GzwwxpzBkfydjTMMbggD3flYExkbPGGfKYnxPYQjL?=
 =?us-ascii?Q?td3q4IUl3KKmb+z5NLqX8QH/uY2yEW4SCMgjKPfYllm9XTdNJHSEWh/7QwHG?=
 =?us-ascii?Q?NW34SBc2ysu2Cc319SjsACz3Zmz+E/0tPULq3P5EO8/DZ1uWeIlzO7mzZ/Dm?=
 =?us-ascii?Q?d0n1M+s2qA75A2axxTsZRk0VBh2sG5ZTnhXXMKzY3hQOdDaBdh758JDX2MT/?=
 =?us-ascii?Q?7NHu20ADeEr0s6nIgg+OEz+TBexJ2HZ7fLQ81SFUVwlQupAHTBoeq1CstmqA?=
 =?us-ascii?Q?rdf7KTuf3g55On94vWFWr9NSJ6xhzNaoUIEB3ynKPPvHS2hmTo6L7ub2rSXF?=
 =?us-ascii?Q?2Bc2eaVTxw4MG00+WAsLDExqyuyzBP570EF+GBaDk0jt8n8yPzRIYQE4aeBY?=
 =?us-ascii?Q?gkMwiqBpbBN2pYK79MlHyEjor/VObfy9t9xYmJ40Pnp/cxVRtwd9dDJVf75v?=
 =?us-ascii?Q?dhe7gtoMnNfGjefRMbKMqBbZq064TJqap7rR4YPvAoE7cJKq9ZaxxmyLf9S+?=
 =?us-ascii?Q?+A5u8RCBWQPV3TYwsxRhbcVrF2GMpVFY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KTB+GeY7O8XYNK0Tp9iIUrQ2OQYoqugs2XoQH7kELrC1J0IrKqfWTHBtk2M1?=
 =?us-ascii?Q?jCwbiCPSVOpmeMPb9/i8GqhkftCqOhxrXRvuNVhoAkGdvxeeYpvPHn84Rkh3?=
 =?us-ascii?Q?0L3Hgj3W83JkZPkjQMkuByl2U1Ig1WZD8J+8DiF5sHqbzE+AYGNJ7jZNVRg5?=
 =?us-ascii?Q?Ga8pBTIry1/uhTQ20TY8f1DvZGfEMGYZfBSndfUhWLAlHMqVSeS8aMv177LS?=
 =?us-ascii?Q?DEs12F8v1vq5Pu0t//yLsddtFf/0+NakP93YRnHyIpccWjmrbLGT3JD2OFTh?=
 =?us-ascii?Q?CdNtRrp4MDZR+ElGKrCNbB3X07f8v3bL7QvYBFCpsojlENMeJXJlSO16JiXM?=
 =?us-ascii?Q?+LfxGmVNZp692wu8QaTiIuz0ih2VMGfOQpK9AWa8T/bpDmQ07e8kSYqAF5xj?=
 =?us-ascii?Q?HT2VOXOy2XBrURUu5P9q4RrCtertXjp96oVWCWR45SJHq2NTIorFMoePiTAG?=
 =?us-ascii?Q?UO3SMKuxJW8jIN4FOBtB9QQYlr8pXkkBbRy7y4/2cxR8geGC01I9JuX39Nv3?=
 =?us-ascii?Q?K9hyo0RnSHrK+aw4QME5R1z+ug+fXquD5cgsjnyYbhWe6eR2W+3FNzUVS53+?=
 =?us-ascii?Q?Z4TUoBDsmQRNn/8VpNsaymBNM9Zs48SlWtN8P5f8IHvdksMtpoaJhKv9GLsq?=
 =?us-ascii?Q?mTjpnNzPmvGworMFHNYnIgoWdsH4wXWW9dgScIS7qXG5DY8gryYfQ03muiBw?=
 =?us-ascii?Q?EMq5oRFEZu77sV44Ejsl+qKsS2a21gO3o1cb0omaipPS8cROBlU14GiQ6pEW?=
 =?us-ascii?Q?O4QP1x08nF0bP1N6y4UiIub0pralJBiulCa4H+FXEUFmwvMroAanZnFjaYF4?=
 =?us-ascii?Q?hPufE68/XRjFls1uc4S3zhaumrmRvxdsvhntxmPJxgC4ewx+NNG1FN3qapUa?=
 =?us-ascii?Q?ZfGrP8vDCt3Lx7Myp2Yfjst7Tvc/RFyZSROb0zJp1sVpRtBIN/eSmDOUQyAK?=
 =?us-ascii?Q?ZYOQqw1RbBT0zdoAnY28k1DJF4f1+0ri+ChQrH+Tr0TxVh86KA4BRWaw/X8f?=
 =?us-ascii?Q?44U5+rVuRlwfsacmTGqPSOqn9Hh0XIjshbJl/peEoM9o2BGahCF9LAzPH0JG?=
 =?us-ascii?Q?meplVkQKi+HIEUbRUASl2FhaoXLY5TjAUa8HubHgRUJSfnpmvdvnIsd3DmyK?=
 =?us-ascii?Q?DCioB+fgPkO71qCnCM55HIx3PGuhnh3mwX+Ox9nDw5Z+RQrDaZP2K5b2HYah?=
 =?us-ascii?Q?rqyRisYgSoZfL+bc1kF/82O8fWHOrDuh9SbzQTIOd94q1w9pe74aKeMq3Ig5?=
 =?us-ascii?Q?2WeKDhdsETz0wmLjxzgHVxsY0Bk7skgT6OOOsifEZp3wdvMrQhRK5YFXGBUO?=
 =?us-ascii?Q?QvzToDo14TufSMlYC/VdTY1m8nfGa8ta1xtrU+Y4QG7Q5yItwxzdk2BUv0Nr?=
 =?us-ascii?Q?XMpLYRceXekFGyulsuy8sCBNJ0iz0tnByIXQpbe467g20E0N051XG7r60KId?=
 =?us-ascii?Q?DVugWRNBVF3dd6JV29+RR3uiaMe37yEtB55cMcffeBu4dZBaBD8HMdPVnAV3?=
 =?us-ascii?Q?m6pW/yTCQGmPKlyvDbRnUquHAr18FDTeGGoPYNoQHxHhXZMXJeydIJ+AoJ81?=
 =?us-ascii?Q?5ad2U7SydfRJ7OPAx1yKATmfjfCyLP4HWDvyF8v9tPushoeFkX4GNaYKh5lH?=
 =?us-ascii?Q?b2gI+jtrpaXlPuGtI8WCK5dalZblVjP3hro+2+I3YPFyAenNlQ2F2AtgwSMr?=
 =?us-ascii?Q?noVBkiPKLm7dk3rPKA3BKpnJxe9GnSrlMjZQ1KwSqZ0GXwGoYu40pVR9rhye?=
 =?us-ascii?Q?7WRt9YGZRQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ImxbxL1B8dMIpbRizJRZCoRXfZagpzIMpK7/GKpxtCc6YPR1ZyGgBAbnyNuQaKkXJiUevI7Y4qfQGy6E8zE3P44GVGUsZiwig9DeluNEzjrJSjw7lPk2jr2JFhqBBot9NhZ91cs8TCM4kf83MoxLiZ3Cqf4wA+XPiwxzMYyZnHUixAEUzthNrFX/wzLs8UZzg0/KUMNUr3JVCw2cc1/PBSM58taN/Qn/vGncYxWD7UAc6AXhXPSs7y6YOx9gXTInNE31qM1+zkhBqHwadJZlqw5sr7cPtmiHBYdMYOgvoRniNIm5SVCZetbcdn+hHj9HWmzGufaIJ/AJ6gsXyPGD3qtiSW9vk3KtN5dOaM1xgjYFlOpuS4YxvPg3aDEs7YHxpzX8kb9fC9Ff2cgsQOIxhLx4fj9Vbh8WG2qxG6aB95yAD2AihU90AjSs1LnAZYKKFkES6n1kccZimymZ+V27JDNJMbjF26HTH3G1c0PTygvFnA7sTZQHJFvPpgzk8W4VQyqh0uI6pkfLj2MNhSfReA0CLtP1SQGQ0DShxFOuORg2qcJb43ZJOoj6Eu2FTgs8uF6shsQUgQjJ3fXxD3qBgbZTCoZsDv2Orq9YxnkuYl8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 717f9013-0d7c-489c-a96e-08de52dcc9c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 19:48:56.5773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9WRjKIfUJtXZZckIMs04uc1JUeno5QAZLHanwBYRR19BJdcqtWHZTEh9uwjFx/ZGz3AXYkF7ZZBv9kl4itAqCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5814
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601130165
X-Proofpoint-ORIG-GUID: GB-OGpXfvUIEmMcszxL1EvcOuNXMwQtN
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=6966a1af cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=OvfqWZUxsemvnu9zw8YA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDE2NSBTYWx0ZWRfX4AfgQ6Dj1tIk
 iOEYxrcdF8tLRwlG2dFeSlB7JdnnG29uiyp0EV/oJ4fSByVrgtxzS3Ht7k0+wgDcATCtVrbp1sL
 9eMTIIKqEyzYNklL3fiXl/IC0RK5wAJ30ualNJLlvp2i13fqMHYbK+1LHtuVk/EYfrb/Px8RDYW
 mLhpALfZH68vMAL6j77hpctnoIqvpq9fwv7byaLYKpMf6I88VYgEpJOLnH151298ddYkwKu9yZw
 ZDDtpQs3WfuzvrKTVPEY4c1As+iwRwNFye+fLC/IlINHpJVNHGCiQ/VRlXNK7cGlaUrHeSN0FmY
 ve/P03Jsmq5LK2jhpE6A+tc5sWAj9hUlxR1JrKzEthDu8AP8k8f4mUH92TJe3+9UYzDwBsdsx4b
 rb94Wo9VzCfWfynuq2PE15JA5CwiioWGdrktlQxVcUuqP31JmBY0fHGaGd8e7YfeRAPh7UF7ueQ
 LxjKYgzu+V3cXlyntzg==
X-Proofpoint-GUID: GB-OGpXfvUIEmMcszxL1EvcOuNXMwQtN
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BC4ED8000B
X-Stat-Signature: upk1bz1u65fksnwkt6cwncu6u14kwo1d
X-Rspam-User: 
X-HE-Tag: 1768333759-227740
X-HE-Meta: U2FsdGVkX1+TBNGplz2La/bjAjV6Df055pCwEhMswA3KAe1jOzENgXqH72d7RPPhHMs3j4CmLlyMmzeD5z/6yHD6rkVLU8RQKmKvLuaroJQaNM8XutIJoCTZiiFm2+Jm0IMxlFNG3KBnmftHemS9QYsEidjRCGABCdT5hqEPQLBOHcsuMRmea7JzEk1r9s96tJEA3Fdj/Av/pWH6w/uOBLFLBQvkmheGmFbvTC3Ke6fK+wKQaDFHyBNKmS0CHUdCpqxZBkIivbkxzvqD8C+9NPT6KE1EBEa6aD1Ll8FAMOWZpIVkyTQ6kMzbCFbh3k4KISi9R+s6WpSX6gjFccmMz/3DXQ0HUFY2mEnEAtx87n8eC/Se34I6Wq23UOzYi/GOtQezvLbP7GFrlfRyxsWbINyCpLUcs1MnqLzAe3O7fiyipG0aFhQ1HhpbE2m0HQbtVfI2+eSfTbOScPoi8yNk2jvjpgMxcQih3sKV6wzOq/RNbUWCnhqkRWzUxEODSQjyMmTddOIonCD2vjAlAAnsyNlr/tI+Qfd4NDNtLIF6jZ7RuX7vZCwO68TmMsYdCPzadH/tZT3dg2xk6FIVAHhbuUNEkEFHaQLKBmyuD2wblH1Abg2ZTJH012c9wU6cJO7UaAHiCdmrmZrADW7K/jK0gCNKQJvFjlPdtsL7NrNgBKSCtxjRaHjF9MPX4rpEb1UFPLZ7P8ZXIok0UR5WB+IBqJiXTWlmp073wGXW5pWp2n/t5Kera8jH4clbI3l//EUuAwTBnQBXoQ+WlngK01AujB9A960h+IekeCp107+XI0ssbuHu0HFpxnurLvDUAwkSPRlQ+rCAemVGACzKrXCRi0TekgULhK6vSQgduq8dVJYXNlnteUFvCPxe8vBb3ZFergKpDNbBXvp9thVSpV5Ko6avMMY1mH4DJjcdiLtc7lRTWJv0mtS0f/OU6YGDjtVfOG4/AgCaXddh6LFMjUr
 GFHwMoEA
 IIgTC1h6KXcg13LMVEF3wyUj16OQkmQUczeWyCP0e8tQ/4PJ7hdXGQiBA9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250911 05:08]:
> On Tue, Sep 09, 2025 at 03:09:40PM -0400, Liam R. Howlett wrote:
> > The ceiling and tree search limit need to be different arguments for the
> > future change in the failed fork attempt.
> >
> > Add some documentation around free_pgtables() and the limits in an
> > attempt to clarify the floor and ceiling use as well as the new
> > tree_max.
> >
> > Test code also updated.
> >
> > No functional changes intended.
> >
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> 
> LGTM other than the nits below, so with those addressed feel free to add:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> > ---
> >  mm/internal.h                    |  4 +++-
> >  mm/memory.c                      | 28 +++++++++++++++++++++++++---
> >  mm/mmap.c                        |  2 +-
> >  mm/vma.c                         |  3 ++-
> >  tools/testing/vma/vma_internal.h |  3 ++-
> >  5 files changed, 33 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 63e3ec8d63be7..d295252407fee 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -444,7 +444,9 @@ void folio_activate(struct folio *folio);
> >
> >  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> >  		   struct vm_area_struct *start_vma, unsigned long floor,
> > -		   unsigned long ceiling, bool mm_wr_locked);
> > +		   unsigned long ceiling, unsigned long tree_max,
> > +		   bool mm_wr_locked);
> > +
> >  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
> >
> >  struct zap_details;
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 3e0404bd57a02..24716b3713f66 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -369,12 +369,34 @@ void free_pgd_range(struct mmu_gather *tlb,
> >  	} while (pgd++, addr = next, addr != end);
> >  }
> >
> > +/*
> 
> NIT: /** right? This looks like a kernel-doc to me!
> 
> > + * free_pgtables() - Free a range of page tables
> > + * @tlb: The mmu gather
> > + * @mas: The maple state
> > + * @vma: The first vma
> > + * @floor: The lowest page table address
> > + * @ceiling: The highest page table address
> > + * @tree_max: The highest tree search address
> > + * @mm_wr_locked: boolean indicating if the mm is write locked
> > + *
> > + * Note: Floor and ceiling are provided to indicate the absolute range of the
> > + * page tables that should be removed.  This can differ from the vma mappings on
> > + * some archs that may have mappings that need to be removed outside the vmas.
> > + * Note that the prev->vm_end and next->vm_start are often used.
> 
> Great write-up though you are missing some horrified noises re: the arches doing
> that, I guess the reader has to play them back in their head... ;)
> 
> > + *
> > + * The tree_max differs from the ceiling when a dup_mmap() failed and the tree
> > + * has unrelated data to the mm_struct being torn down.
> > + */
> 
> Ohhh nice nice thanks for adding this comment!
> 
> >  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> >  		   struct vm_area_struct *vma, unsigned long floor,
> > -		   unsigned long ceiling, bool mm_wr_locked)
> > +		   unsigned long ceiling, unsigned long tree_max,
> > +		   bool mm_wr_locked)
> >  {
> >  	struct unlink_vma_file_batch vb;
> >
> > +	/* underflow can happen and is fine */
> 
> I am taking this as a sign that underflow is in fact fine _everywhere_
> including in internal plumbing! :P
> 
> > +	WARN_ON_ONCE(tree_max - 1 > ceiling - 1);
> 
> Hmm, so if tree_max == 1, and ceilling == 0, we're ok with that (would
> resolve to tree_max = 0 and ceiling == ULONG_MAX), I guess relating to the
> 'interpret 0 as everything' semantics I think we have for ceiling?
> 
> I guess it's because these are exclusive.
> 
> So perhaps worth updating comment to:
> 
> /*
>  * these values are exclusive bounds, with 0 being interpreted as the
>  * entire range, so underflow is fine.
>  */
> 
> or similar, just to really underline that...

The tree_max = 0 makes no sense and will be evaluated as a noop in the
code - we will fail to find any vmas to iterate over.  We cannot have a
vma starting at 0 and running to 0.

tree_max is not an exclusive bound before this function - which uses the
maple state (mas_find) vs the vma iterator, which does the translation
for us.

ceiling has always had the potential of being 0 from the #define of
USER_PGTABLES_CEILING.

If we were to use the vma iterator, then we're having an inclusive limit
and the start/end (named floor and ceiling here..) difference.  So I'm
just trying to keep everything here on the same level of reference.  We
need to subtract from both values (especially since they were the same
variable before).  This seems to make code easier to read, especially in
this diff.

> 
> > +
> >  	tlb_free_vmas(tlb);
> >
> >  	do {
> > @@ -385,7 +407,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> >  		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
> >  		 * be 0.  This will underflow and is okay.
> >  		 */
> > -		next = mas_find(mas, ceiling - 1);
> > +		next = mas_find(mas, tree_max - 1);
> >  		if (unlikely(xa_is_zero(next)))
> >  			next = NULL;
> >
> > @@ -405,7 +427,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> >  		 */
> >  		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
> >  			vma = next;
> > -			next = mas_find(mas, ceiling - 1);
> > +			next = mas_find(mas, tree_max - 1);
> >  			if (unlikely(xa_is_zero(next)))
> >  				next = NULL;
> >  			if (mm_wr_locked)
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index a290448a53bb2..0f4808f135fe6 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1311,7 +1311,7 @@ void exit_mmap(struct mm_struct *mm)
> >  	mt_clear_in_rcu(&mm->mm_mt);
> >  	vma_iter_set(&vmi, vma->vm_end);
> >  	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
> > -		      USER_PGTABLES_CEILING, true);
> > +		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
> 
> NIT: Might be nice, while we're here, to add your (very nice) convention of
> prefacing boolean params with the param name, so here:
> 
> ..., /* mm_wr_locked= */ true);

Ah... long line and I kill it later, so I left it off.

> 
> >  	tlb_finish_mmu(&tlb);
> >
> >  	/*
> > diff --git a/mm/vma.c b/mm/vma.c
> > index a648e0555c873..1bae142bbc0f1 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -486,6 +486,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> >  		   /* mm_wr_locked = */ true);
> >  	mas_set(mas, vma->vm_end);
> >  	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
> > +		      next ? next->vm_start : USER_PGTABLES_CEILING,
> >  		      next ? next->vm_start : USER_PGTABLES_CEILING,
> >  		      /* mm_wr_locked = */ true);
> >  	tlb_finish_mmu(&tlb);
> > @@ -1232,7 +1233,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
> >  	mas_set(mas_detach, 1);
> >  	/* start and end may be different if there is no prev or next vma. */
> >  	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
> > -		      vms->unmap_end, mm_wr_locked);
> > +		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
> >  	tlb_finish_mmu(&tlb);
> >  	vms->clear_ptes = false;
> >  }
> > diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> > index 07167446dcf42..823d379e1fac2 100644
> > --- a/tools/testing/vma/vma_internal.h
> > +++ b/tools/testing/vma/vma_internal.h
> > @@ -900,7 +900,8 @@ static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
> >
> >  static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> >  		   struct vm_area_struct *vma, unsigned long floor,
> > -		   unsigned long ceiling, bool mm_wr_locked)
> > +		   unsigned long ceiling, unsigned long tree_max,
> > +		   bool mm_wr_locked)
> >  {
> >  	(void)tlb;
> >  	(void)mas;
> > --
> > 2.47.2
> >

