Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB7CC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 23:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75CD66B007B; Fri, 25 Jul 2025 19:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70E186B0089; Fri, 25 Jul 2025 19:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5496B008A; Fri, 25 Jul 2025 19:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB526B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:00:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C072EBC181
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 23:00:45 +0000 (UTC)
X-FDA: 83704308450.28.EA145F3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 137218000D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 23:00:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nYBn6XwI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ttWqP7tP;
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753484442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SFh6ERCLfOz4oH9EfiVAnE5QJB3djnXErOnyWQNrkYY=;
	b=J1k87K9e2PJ5ceBfeU6PCX7LDZUf5zO3rOa+U/83UTVuX0fDlhYA011jT3oI7ymvMNhouv
	7wW2N050UxvcIyK3HCfr20dZW9h2ZbQ/+VUvx8C/+ZDC6VKVYuGOv4cQAM8wGbl1RvHopK
	MwYXFYMhjV2vhytnCwSlLuQ4vTz7ugc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753484442; a=rsa-sha256;
	cv=pass;
	b=rUxuoSzH5G0gDTc/VKvJsh+c228DTA2ETl/yh+xm/YPBb6aj2MhPr69M5aG+ho/j7ipn3F
	VV/1XuSUEtHXxP3uSPiwvOJarQqZPIgZRPRJ0PbF+sTPwQgePHxU5PTd3OxnMma1CzjH+v
	dmA/uNPKsjWCHbOll8E3c6LTxENlgT0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nYBn6XwI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ttWqP7tP;
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56PKgfDJ021600;
	Fri, 25 Jul 2025 23:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SFh6ERCLfOz4oH9Efi
	VAnE5QJB3djnXErOnyWQNrkYY=; b=nYBn6XwImzxPjASvZAWlIUFwYyBDE6tObk
	StOgdMgi0b3QR8YtOkVFbm5jsZQlbjKQJjtmcn4OW8nlMPwEIM5VvIaJuYw+UYaK
	gx29fc3KACoiSTuSLrXG2MwDB8Y366I9nG2UwsxotlAHojmLNW3KdSnQxFNxSfmC
	zMdwxbylzlAC4dmN9P0cIFTVJfMRKOV69AHwKxj2eZlAGSNynpMJgjSa5ck9PYkk
	/nhEZbaYH1m69Gd9oZ7+1nEtUqSnnvxf4ucK7/mPQ3rKgcHHfKnm/X6HXHzCFqLO
	BAhRlCw54F4DGt9r6QL5kv9FCYWKvcgXqahvejSvQ9vWtkhO/tTw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1n20sw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 23:00:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56PLh8xO038352;
	Fri, 25 Jul 2025 23:00:35 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tdp6u8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 23:00:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h+SXIx951OxF5H5nVVpv6kr4RiiCsU/c7NJAqEMZdrdSR9qg/WKQlV9DepwKpUoLV9uKHm9d4Tn6A7GpxiUlntzRHFYAV6mHFa3bjobU/ccbg75qTSJCgj9P7Qzf0DQT3zeTwqFGK4OOXZykI/HuI1Gs1ywxJBuQX8YRCV3RDM28ns6wl74KvdCiGerk7lsInUpZbP/OBd+pblFLbHw3Wl0lCF9zdG3RkiN8pp0KTqtU0UVs4af8NfgExxCQVVs580CgUH0S14cQlmT4XmWQLSepkZNiWp9M78LH6ZbsFRLShHGJarzHzfWbwurv2cCDzlkUVKMnH/LlGx9Sv6YGyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SFh6ERCLfOz4oH9EfiVAnE5QJB3djnXErOnyWQNrkYY=;
 b=dw4UKxWfNBnkGmwwAMgWTlFttcnZcgHNaK1Q/ul/uQbdJhqFVS/DRqomJt1BYw6LtMeWXeFTBGiUFJLVmBsMTPoptZZTCNenx0CG9CGazNauLbcdptiEtFQKgJTmgm14HIBbMtTgAa3dmqkDdXZMRiFtFTUFKY4lxyrR1uLYYM2IzbixAf20acldIoDH/3/eVHfLlDph2ZkE8GX6dlay4/RlLgy32w4WNXuVtf1HdOAJdU5bBD7GSpgka0ZGFmdUqusmZZNY1GSOzVKHR7zqNdjsf24FMW8jIQL8AfM5+Fk0rBBVjV4N2Xm7+mNoPMBMhXvNEz7dmPQeqTNLxzQM7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SFh6ERCLfOz4oH9EfiVAnE5QJB3djnXErOnyWQNrkYY=;
 b=ttWqP7tPx7NM2Q9oZLqcxzL0XyGbyjKlsBGYJiCjsukL08xGyQJSk/+CkG0cL5sSz67KJZIRqG8xqrGkebsIs2gpz3wG+GnhDr5ikOgWLXeh5O8rFqUxIAmbjNZyZV7gcXVLNfeprKrT+sEuUyZOTTSyNpUxervKpJCoIm57ZNk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ0PR10MB5647.namprd10.prod.outlook.com (2603:10b6:a03:3da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 23:00:31 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 23:00:31 +0000
Date: Sat, 26 Jul 2025 08:00:21 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Li Qiong <liqiong@nfschina.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: slub: avoid deref of free pointer in sanity
 checks if object is invalid
Message-ID: <aIQMhSlOMREOTLyl@hyeyoo>
References: <20250725064919.1785537-1-liqiong@nfschina.com>
 <996a7622-219f-4e05-96ce-96bbc70068b0@suse.cz>
 <aIO6m2C8K4SrJ6mp@casper.infradead.org>
 <aIPhGvYgF0oC8kDa@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIPhGvYgF0oC8kDa@hyeyoo>
X-ClientProxiedBy: SE2P216CA0129.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ0PR10MB5647:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d7f8bfb-ca6b-4d72-5157-08ddcbcf0e05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p+GMBnZ5Sh5co11e4UWOLWxuUF4gyEBObbXbLrtn/ZDBAO+diSxNcE6inhi/?=
 =?us-ascii?Q?uGcgkdMuYxQgrEFxQeK3LPlgZ90ZBqJPMSoy1x8RB8p3ltufJqckYU/TMnTP?=
 =?us-ascii?Q?kOUtVJy+gjWNjSOB5u/gdn9vV0q0w+0QQZcKM1GN95dXZ3h1jPSTWR7WTIGg?=
 =?us-ascii?Q?KKFYKuAJgMoJVclSy6Er1Vnl+y33xwyCk0W1NqpuPqg3GYCw86cPW6i8bJLx?=
 =?us-ascii?Q?TKj1uX2wz0HdjSB1qMJN0JWnwJvcmx4gA1QXUtTCK8ID6ZEiZ45fMmfcRAzg?=
 =?us-ascii?Q?ghtTnfYDkupaAq5ZGfj9CWuYA0Ry/FrxeAG9fr0VSEnusiQbPOkm0mIEPzkq?=
 =?us-ascii?Q?ay2/ktulqcLMEluWuxDLtyMQwzSF7rKabw8f9XvY5YBdy8TN3WbqIwP6F1SW?=
 =?us-ascii?Q?RoZ9LhQJLUYHX3mcwYh7woIaFFMwQFBRi0K8F2LQXSOEvCEQAtOsDQP8+471?=
 =?us-ascii?Q?3LzD37ufPHX/Atoj3/so6RuE9jZHXEQTxahoBLgmccge8/DRxnNTDt27STbc?=
 =?us-ascii?Q?t64b/lpIntZiA+dq+VYkd2od8oin7YQtXJS7DSCq3MSyV4m0BnHaXTCbz/I4?=
 =?us-ascii?Q?vBHNgHTd9shQ+XJwoOWwrlGmHJu29VtkbXkchMgD0w+JbeVsrKtGAhwK+hk2?=
 =?us-ascii?Q?/NOr+dkPTkhGdjZliga0BmuHvF61UOcynlSvaSTq5Onpd+0g5/52A3P9n/I6?=
 =?us-ascii?Q?tgiR43E8vllqnzVRB3EhnXfjbrRXjhLrJa3iicN314vWc/C/Yd63W2ym9KIX?=
 =?us-ascii?Q?8Rp+IfQ735vdvA+sVD7oOahu5tvcdsacKxrCCn68iShuIWR96Ho8cGRMhmiX?=
 =?us-ascii?Q?d4Dqbq/kyonLA3ckvtghr3l/aG0n6vzb2Ha/UxvFOiimLtQPZapf8mbbf0h3?=
 =?us-ascii?Q?8JE/Y2EZHeOfTtgkBFAQsCcVwx2NToAnKlWA8eHrYCzlom5dzF/c4DUQcamB?=
 =?us-ascii?Q?BfPRXmSFeZjRTl88EM0oTUf6MkLkusBwYgFJExJOTnjFzIPAKMwYAgTty/uI?=
 =?us-ascii?Q?45XUmc4wJYhRSkJR04iPklWGjLu84Dv7KT9uypbXQ4ucXpVzQ5UKZ0tIusXe?=
 =?us-ascii?Q?jM1bt6KIu7EcldY2ZnHfjAIVMDJHS046zI5X3y4Y3qno8adlzm0L24hBJPJR?=
 =?us-ascii?Q?39uZNFY0kH7T/qM7sma8MXNmAy1nmxIbnr0c4SbNrhnZhlVNlkGBiI4EOXjx?=
 =?us-ascii?Q?Xnb21rNpbKl4wJyCGAoL3l+lhtfIFhGTbkW5rG5AgTPf3HoLn7HMC9lQ5f03?=
 =?us-ascii?Q?aXSDTK16cmIDl5KlErk3I/pCxuUhD5cosK3c7mBZ419DT29Kc8imkFE9o7xa?=
 =?us-ascii?Q?mOlWxeqUuVIa/Qz0iDxpraCA7JNK95PZS9ZpXYENk8zTRKop2HxRBlgBTnWy?=
 =?us-ascii?Q?TGsbhTtLaNTQs9XAli0EZAd0MAUuNq30gttxJnT5AGQ/uJVzq+fGffshUXs0?=
 =?us-ascii?Q?nA6MyfLXni8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MPTKjbfXXdsF7oCv4dlv4mGQPkr/rrZD+RNW/mqtjs4CnEfKPylJIdYr2a+h?=
 =?us-ascii?Q?dZxmCbB8wCm+UuvHAi2omst4JFplhybGUGKFNVZ3zI1MbbbcpHSbC+bHb7Uf?=
 =?us-ascii?Q?iSiscOvk1zLWDJbnF34eEqrsZBiTx9qHPuUGdwx+zVCDn5C1JmU+StafnMNd?=
 =?us-ascii?Q?j9VTm0vwX6nkGvqdIAH+3qItze1EEm5De9UJIY8Ym8Zh1GfcJjVLI+Ubi4LK?=
 =?us-ascii?Q?TkxSz8i4d4bX0s4MSXzHstI2aMRkqEEQpRj9JBqGDizrSFwPbMdxf6Zj+w0M?=
 =?us-ascii?Q?8OJ7bVHVxJIWrKx4Sb0+Ye1JT3pp5Z5dwCV8jUXB9NGjKHm1MYRvpaVtlVhK?=
 =?us-ascii?Q?ImWeHfeYHll6cXcua9l5JycBfzMZNU24jtLUbINeFDqV+RLC+8ZPwf9jn7xS?=
 =?us-ascii?Q?iaucVDlW93/Kqe/bbCIKZ2Ogi7dsuqEygy7MWn7y567L0/sm4SrY6vLHH9+1?=
 =?us-ascii?Q?IvqGwV9gU08ipx+H4x8lZ0VA1lb8SvaGWcAKc/gHKWwndIq89pqBU27Loygm?=
 =?us-ascii?Q?X6elRY/LyET0wTRsHXe0w7FbcNtTy8Utohbo/tEi2d6WH46lgMtEYpAnzyoV?=
 =?us-ascii?Q?bgToRxezxNsxZKE8Z4AhaIk0nAHN4xP9Ln7Xzkphm0UKLhWI00/McbQ+XjnU?=
 =?us-ascii?Q?5k63gCBB43yFhpHgVTST7HPJlVHQqmRXS0lGAqMc260rBDNF/MNbNO//rlGB?=
 =?us-ascii?Q?h5RJFF4Ofyi7bAVfN266iCJ/J+3WslUAPYYPkHInYvAcpvIPFwOud1nU4XpL?=
 =?us-ascii?Q?ejjGATeCtPEYlEE2lo2SQR/EYz+gTkEvJp5inAO7nEBVERgxk11gtfj7jlEw?=
 =?us-ascii?Q?er9IZrkxjej4Xn4Vfor8OVEksNZMH+54+ztUGY+285yO7abC02IbMRa4x83p?=
 =?us-ascii?Q?knd52+U6R5etNIJHt753/yWq85aoUC63AOLfbKEI30eWHfvL5/6jumsvSxbk?=
 =?us-ascii?Q?tl9xM/iQ4VSbPZSwCi+ahbqULLrkM45BLylFC5EJo3Ggf8Ha0Agg8VE1buui?=
 =?us-ascii?Q?wJryR9QtkPlM5k9imDeTdiT82A+PmX64AmBQmNwE9iWbl/zNnwoY5dShcI+M?=
 =?us-ascii?Q?IaYw1QZLuYeTKWWoHf3uaJZL7ZJeEfSM/B6Hgjvw6OlnD8kyqToG1+8j41/1?=
 =?us-ascii?Q?9Qj7PCsZuo+G4daS+6LLY42cLRDh8cSgyI5fy2z+3RyW5M6V7Mk46ZRLQ0Bi?=
 =?us-ascii?Q?jrBgXwniddeC9bBmvJCfp2PddCkB1j4PJJ5EBVPmUvl8ChVrBYAOjm9Yu3pw?=
 =?us-ascii?Q?ViHTQJwy/BsMaGb5doTh+YzuSF7kAvBT6tsUgOjnVPaTBYgF7GfIUsQkA3uI?=
 =?us-ascii?Q?aY22OryenTlgD6waDdzG7JdjAh1ZU+5R2mb06tvFmVZfXE4TQCMF6tbd1M9h?=
 =?us-ascii?Q?ODEqTkxqLrIYXf/5oMnH18ArjFAldEG43XxcbF5RppQsPtaO6moBzzTQEyMf?=
 =?us-ascii?Q?fCvOIrYC6YSACSUXXv7Gwd14dGlp3U19cZrhi0u2AW162ZrvEukFGbZE6PRc?=
 =?us-ascii?Q?hKG45Z9aBePIiDj2aYxol0MyGxtfmVO1NDmkC7/y+ot+WIdk4Kh0MDMW8XFh?=
 =?us-ascii?Q?cShEUxH8ZTloe4vnsknLJi6u57KhCoQ8HmV7dN2T?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t15DROPpVr9QqZE7ktJUVpgkavKxKJY2nHuWJOGG+jJc2i0I6GMAG3WOfAApDC3LRh/LLTeV4W7HQa+nUyF7COwHNRIJ6+96BLFa5vZmMDpockZL57ZMhl+qlzgps9FbKos1crLiJnN6Ff8jZMLJ0W6IN/bCvruc4XiMqT6OXfirARJFgz9aV2Ee5UCgBFNdMyZbtd3hvOr7vexIiRH8eyK6ias9Q6D07Ug3FBC9QIMMz3BtclTgkN6bAA8u/svk5Lu4itNZj80tWDjcTFnOIVmsNUEVTwCs9mxE+SzSrklcmG3BxeckpGcz6hiFp0viPZQaKTpPrXaWIcBFsYETWxWMc2lQOYIldHCJQAqfL7ESsZuSsOORM2UtYW1gSs/x4Qczlp9AySekZN/Ho6cBVDAMTmiv58M+8QZmxJGxMvlhRWctg2HkuA1J66xj806DUn2/IGFEusmxKFmJioARovJDMkDo+pf5qDdGbRRP6ZX4zbX3OQyZR7yMKh6rJkzXjZteqOhLrUlmL/hsNpBUO72EdVFoX9Yc5a7QEiL74mfC+6+790L99Nn5zAd5FeMzeFEkgzBFTR/OILmJeGlFNsF3xh03VHwG/6XvTqg3ACQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d7f8bfb-ca6b-4d72-5157-08ddcbcf0e05
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:00:31.4046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V2WSvk0sZLdMTuVBgPqgz7P4Oom/kdyMtyNFVq5JkfpW9yPfY+l+UcIBV/IsCaQJqY9FDcrjccrNNi/QzyMUcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5647
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_06,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250199
X-Authority-Analysis: v=2.4 cv=ObmYDgTY c=1 sm=1 tr=0 ts=68840c94 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=UDYOwdoAtdH84hfzlSwA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12062
X-Proofpoint-GUID: _1Q0TGd7lczfeFn4PANcdhOt4IMCOTus
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDIwMCBTYWx0ZWRfX+rHYHizd1vEU
 cloyn7Tfo6IgXMXOP6dX8piW+el6/53fOgdhFxFEHTzAI3lMi8iVh9mD/0ewJLj51WmTL/KRysQ
 WPwTfRw39DmKyipzpMuPBAlbFG+eqb37fH9JrBtUhTVoLZtZKfple7lq0at0wGmYkSj2ZoT+72w
 Z7VcBW6lpNonjaXg8N460IcYZ9SAsY9sAzSF+fKIGmousALUuEOvklG4xbe/6+ZckNo1HfqOU5t
 +FgeNGgw7xImRDxZgn8GDvzF1VMKar5VYB2E0gOuJpeZDe+sShY26e1Wj+CtR2Tu0tsaoHewKgV
 6w3/Q33TMukI+GeGl9geYHnNYN0KtQm2K4HYeK59v2GUtagI+MJPRlnWpFcub/eeWXBfSdJhfmP
 jeqtBVJjEURGSoSl2oqiQVdJgTE4MPShn28ncnWswo8B6mCrjGFcEWi+Mj8pDSQ/caxButVy
X-Proofpoint-ORIG-GUID: _1Q0TGd7lczfeFn4PANcdhOt4IMCOTus
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 137218000D
X-Stat-Signature: dfrensqozcgy9ge1pp7oib5bh4dsckm3
X-Rspam-User: 
X-HE-Tag: 1753484441-226515
X-HE-Meta: U2FsdGVkX18z5MFXpMjdNDGx9eBxz3T8Jc+/3XnGbNxey/MpdT4FZxtUBVpK3b+Rp9NpMPSQzRG0aBF2D9dinkwst51mQKC3yfiFo5pfT91UefGk9KbIJwEcR1TL9sNZJ8XRw/KAh8ewPatWJCjyaA6BO+++yZwM4va4gsXQse5fupZGy8xWtVYEnsmekKXnD+TaPziFgkRleJY/O4uHT3aDt96YNoigjZUjJ4Jf4R1G2XryWG96tH8K3sFS56zpOiaGRkj7sjq0yEiW6cX+hQE0zFZ6fYGqcL6hZA8vDue8MVcz8XQWUsxftOFHRttvdEN+4UTg3OUd64Id17Ximw8Ddx7xh0qfhduDAbRcFwDnBtxZeEosPY85Gpczx1qJJoG8rOqEgbWrkZJ5UyrwBlpcD4rw5Z1AyZO0869m9FpS5mzuft2hUjbt2hY5gf7+XgaCS5XTwCrFitneCbl4QN8Dt63tvfwFRJoknRW80HIVDtP1pnvMaU4LqKXNnyKRjiTM6RrE+p+z4CAlQiUbAzXeM3piJ7AfoDZNDKyXyCzHeImFVDGNN9XVcDYXW9UByOjoxbSl4rVjA77gpaLFEfbFbbi5dwXhyTn5KGbejfer05MrF8ItOKTvPzmMohueFlyLQVsWyrDSKG+TPdXgRKfy210DeZlbLey7ly44ulHDF5l7CBfbRDgl3IN+AHS8HrcHMlBCCTeqrMRgt8xrkAzXTihhTr1PgSiw/j+Q8ViJrFscyOJdgPufg6p8yFXkA8cvmq2TFVNPlVxEvR1NjnqpKyuWziTytTNocVMVY5u4E3YI0mqnItkU2IvgnD3FNLhTFKMMZFJ795fSdm1rvi1WUprKyXYjS2/rqrfOOqrLSB4xUaOl0a1nwjCOdLwhXWP/zXd5BS7jldYyOGXK3AEFABf3Pzmeqx+sOeaFD6eNkWoWvBkEiYBfIVsgIOqCy5XV0juDrL0swZfcRc8
 J/Ei2WiV
 MWcE35RS5Sz0kvkd1mYEYCCtD9aFcwYJRxPqLZ+QsQCYdZEmlCAnkg59cAunpAqqyXDLsu+9uNraDjk3gRVtYDX08rz1+ju+XivD6PXNk6EzzizUtr3sddahz1prkC8fq3uggtU5s9Y/ftP/K/5O5BETQnZ16+gNVCTa6nmA3KEUH9S2/KYK64eHY8S18T9FTuF4d6yWP+XZ2ilRWDZTyl6qrAIu4UCSM1qAphvms2UlyEF5nTkHRlxgMwYQSw9lfHoOCUQzEDsAIG2uCbFjbPG+2sjMdXbvVfFSzXoFCCcrDjcHxSEmxLfQ49/pAs7XIXDTiOSFuG7qAgdDzjqQnZgenDdjVmE0dOYd7rP9ypoEAThjiuFVQ994opodtgMiJeIs+Fmeam+wNoHLYU8lWuWQmzrjRg7KJG+PemyPhjWMu9nNSEIE7sBG2WXuOOP3S3/dNfz6HdYLSxWTwzNEt/6H7fCpj2dDPbdH/2QE45cy/0GXQphNVHzz0s25NVult448dU+7Gs0oAaG+OAAmFHjzP0tr+erfvvdWU4PVTN55iRtSeqgRdRqTuZxPsc1kMciyCMsVXsyveUwky7xdan0DHqvms9imLohuneXx4tZnktgiXhAKS8CTzIv42nt+iYnRd5FnKvMOOWjgOCtdYi130srAt7UUfuoMIa4FjO6B9ebtU+iZdacOFfUQiSYbuJ2Yg0BK0K3h0U/Zype653R8y8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 04:55:06AM +0900, Harry Yoo wrote:
> On Fri, Jul 25, 2025 at 06:10:51PM +0100, Matthew Wilcox wrote:
> > On Fri, Jul 25, 2025 at 06:47:01PM +0200, Vlastimil Babka wrote:
> > > On 7/25/25 08:49, Li Qiong wrote:
> > > > For debugging, object_err() prints free pointer of the object.
> > > > However, if check_valid_pointer() returns false for a object,
> > > > dereferncing `object + s->offset` can lead to a crash. Therefore,
> > > > print the object's address in such cases.
> > 
> > > >  	if (!check_valid_pointer(s, slab, object)) {
> > > > -		object_err(s, slab, object, "Freelist Pointer check fails");
> > > > +		slab_err(s, slab, "Invalid object pointer 0x%p", object);
> > > >  		return 0;
> > 
> > No, the error message is now wrong.  It's not an object, it's the
> > freelist pointer.
> 
> Because it's the object is about to be allocated, it will look like
> this:
> 
>   object pointer -> obj: [ garbage ][   freelist pointer   ][ garbage ]
> 
> SLUB uses check_valid_pointer() to check either 1) freelist pointer of
> an object is valid (e.g. in check_object()), or 2) an object pointer
> points to a valid address (e.g. in free_debug_processing()).
> 
> In this case it's an object pointer, not a freelist pointer.
> Or am I misunderstanding something?

Actually, in alloc_debug_processing() the pointer came from slab->freelist,
so I think saying either "invalid freelist pointer" or
"invalid object pointer" make sense...

-- 
Cheers,
Harry / Hyeonggon

