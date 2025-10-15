Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42656CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916088E000E; Wed, 15 Oct 2025 11:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ED228E0005; Wed, 15 Oct 2025 11:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DCEC8E000E; Wed, 15 Oct 2025 11:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CAAC8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:33:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3961F1DDC32
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:33:16 +0000 (UTC)
X-FDA: 84000742392.29.226FB57
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id B0924C000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:33:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oAZGgLqu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pWiNIesc;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5SEyXpicz/7b1jc7im4fqIUhPur2irjpYXbibtGcc4=;
	b=XRZGKPgKiSSIYCzg+P1Cv/RT6Znt5bnCNxhRQrW1cpZmCGTRhcPXh5HlQF6sf38xmtqYs0
	eycsVG0ezJgynJBCzptggos+tXVpMtE9DkfI4zZtZHa8fUSxu3WbHF3kn/q9BGwSiUnsoQ
	i4BSXLWKQy4WBC1RV1s65dDjei8qVZU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oAZGgLqu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pWiNIesc;
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760542392; a=rsa-sha256;
	cv=pass;
	b=sLUccn/itjOjPQPpMHl530FK69WzImgAWqYb9JRtaVi1GT9t2HVhIy5tJM0+cu/o4xAv2L
	A8kKS025n5vYB/8q1G+/VtIkBSiNT9eNyagK/frxrjRBjWjoDjRgql7lHxFd1YA5qBchoK
	CeyzikwEw3dMLds8i0tzERCPbiHK3rc=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59FEu6IU007109;
	Wed, 15 Oct 2025 15:33:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=m5SEyXpicz/7b1jc7i
	m4fqIUhPur2irjpYXbibtGcc4=; b=oAZGgLquv49LCqXXohEg0bouJDDw2e0V3u
	shHmYZqjPRKz+GkGFJCYosB2yG6cHed2i5BhgiMqwBC1g9LcO5szTbolbnf5esIt
	KRjDX3quX6Bvht9tDOWKuxXmSKgu7PWSDZb+pu1no5TTeQDyTgxCRO23GbKup5pB
	QBLM1MQqNnEhe9z2gEDk+8QxXi7gA4h4teCeuD8VE2MKLpOIEG04j+GZh0P+kUld
	WkZ7G0UfS975Iu4lr0LFadAkIQQw2Dq2QWNIbyhzjZFtYllVebn7qBqiAswV9uT2
	xMSYUdWHYDIQdGPKnR9HcZHsdizNCV5B39LeE09yU1i4I+IwDZ8Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdtypxhe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 15:33:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59FFUu3E037187;
	Wed, 15 Oct 2025 15:33:02 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010011.outbound.protection.outlook.com [52.101.201.11])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpag7hp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 15:33:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iuA3/XBKEmzWWWJyi0uRuRO7ibo5HvocWd87D7P/6+OCOgZAt/GznzLR7oPhULyHPWhQJZsCBcMcF/uDSV2Lk1MuQCf5RCnfJ69WjbYK+Og2SR+YAQrM2U3pWulQn66g6y3v52AoyjF3E6wb8frmoQz8FsqasXO4qcX5Jog62cPne0yftWY6l1437Ie0tPL7gJ5bdKMMYsbgb1rHGNFS8n5tDOWBkOx7ocCsdDXfTnGG/aD42es88i4jvSEFxHk5KlkoLjKcoG91O2g+cUNVZSJcfTXXOFuMD8OlgetofxU6QRBUCzHVXLl4tFL/GTEqyFJytxwzRBciMFzSaNt9BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m5SEyXpicz/7b1jc7im4fqIUhPur2irjpYXbibtGcc4=;
 b=RclWKEcsQK+XN0DbxSG3CLxm2iulaQIHO98QuxXNjI32eSLEIV8aiCmtCexQDe60VpNczrRxCNh2CEXl4aKsNV2HedUGb/DiFiuCwdDvrid9LK3gBHP59qPOKnf0rviquBxCsJ1c7CkpX53atN3Vbwpd5HzEy15MSVLtiIBv1WOEzA7jVzJnBdC1eZkEX3LawddtmqXvz0CJ3Nm6pqG5103d1kcSdaLsSeO56N46qIZJILv+y+bLEx7bQwmT+ojNf80kr+BJT3n9Qv52xEE5cH/YnNB8ZTjFD6SCxnLw6rvhSphWqHT7dMPpuM4mJ+oRCWJN3zWT25kp0Q4gzgtE1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5SEyXpicz/7b1jc7im4fqIUhPur2irjpYXbibtGcc4=;
 b=pWiNIesc5veu5OraA2Qew/Adx0uxQQthTGTwpm1kMGOtE452Zrh2kwF1fsmYui+zaF73jpP3nPAZ6cOcFXJ/0fQC2RDgV8HyctWRI9nvW35wfoyMxZTjlhMWnnSM4ys/Kg4PzE7dxCaB10pT1YtH/acXkkrcG+aSE1+76eLACdU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB5745.namprd10.prod.outlook.com (2603:10b6:510:125::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Wed, 15 Oct
 2025 15:32:58 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.010; Wed, 15 Oct 2025
 15:32:58 +0000
Date: Wed, 15 Oct 2025 16:32:55 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v3 1/3] mm: mprotect: always skip dma pinned folio in
 prot_numa_skip()
Message-ID: <47f69b78-8141-42a6-b04a-f67ba0b90ee9@lucifer.local>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015123516.2703660-2-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: LO6P265CA0018.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB5745:EE_
X-MS-Office365-Filtering-Correlation-Id: bbe4952b-f52e-400f-35d5-08de0c001ea7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oES6mItOaWjEDed/OQwxJSrdJ54+h23a90Ejc2ePi4z+P5DIa8K902AKQOjk?=
 =?us-ascii?Q?vNCh4o7HjYQC7SN4g7PhyQ+vv9O3zi45mP4useWJQQOaAKTFmBtdwhy61JIz?=
 =?us-ascii?Q?uAzkRbUrTcI+JLnZgklvQiTvYCfyC2OGbCeoj4dPX4LmROAaObL0LmgGvEcz?=
 =?us-ascii?Q?AEWuXQSmBzLmXIYdL64euDAA/FSfjwewEDMz6FxPRMkGENVF1vg7rnBzuNOh?=
 =?us-ascii?Q?cf8oBzWAanw6HBPVYu9K1+RotuQej3HmtpIpyXU2MFGOtLMC6p2QtjOrp+r+?=
 =?us-ascii?Q?WGeOulD53WYrG/FA1uF2qtlnCC81EiFqS4tIfZD0JcDT+Xaw+ATY1Ot1LAjF?=
 =?us-ascii?Q?z3dZlHiVUc5YXySUWbD+OUlHMXqlqD91THxf2CP2lRMAdYJmY9NKTc5i3M0g?=
 =?us-ascii?Q?Z0zcDn+BfRup6uL5v9m4xb7NnjuZza53p21bKHBNYkl3CBgEEo1BDsitWWWJ?=
 =?us-ascii?Q?/ngpncE/XfEp3NgjrjZ10DZgmVoZNUdWFoEadUletvZnibVG0mtml/YNfNKs?=
 =?us-ascii?Q?b8gaULTbrgzsyKKcsKUAiOMkhq8mYZbJ8jhEqFiAJlJjmu1Zezt9QArzQhHy?=
 =?us-ascii?Q?3PYv4uVC4xaHXfVyHfQzGTkps512mGGSnVnR9WF8qJUAgK1yhM3Dm80b7ox1?=
 =?us-ascii?Q?M9f3Mm5luPVHpBTdjE8f1QTaR/mg5sVrs3xjjWQcOGBcw4VS1ZYL19CTTzrc?=
 =?us-ascii?Q?TZ1qXX7iF7KTF/PBA1AuiZCjoE2me/9mMsQ03cjhdh7VRoY6AZBM9gDwQhyr?=
 =?us-ascii?Q?bFtHNGIhyg8zAUGeLZrByrbmfXDSF3MI58fBUX/qSacpUiwxYrKYQk1D7OMS?=
 =?us-ascii?Q?dRi5kppGgWXi2GkIkLP66gILwwJ+tp7VyqdGvT01MXz+fI5wE3kfsb7ulouG?=
 =?us-ascii?Q?0lCk9Fft7lfOEAihVZfAzDS1SLnHVac75wKnmQ4dc5K2dF8Lxz7AbAxK0jDJ?=
 =?us-ascii?Q?5JXxqA0hguutOc13cu768Wb6EwiNMw8h8Fxk9qa7TB96HAi/tP+bMl0ydjRU?=
 =?us-ascii?Q?Q/MMh2DS9xaL/0ugqjcXZ1oT1MlVJvrSxZZaafI+nPiZ4XjYeRzJ2WmOvzLN?=
 =?us-ascii?Q?d2lA1nNYrfaWq9468Q4QirQA1EE3JVPsK21stKwCIdvRvw6lm5rZ2PBivdpb?=
 =?us-ascii?Q?jk1lxtLUQ9/ozmku9kAypqOwX17BqH922T7sz1q31ysEBjQVctnf316vLQ8e?=
 =?us-ascii?Q?sR1KfJ4P91HgxJmfqCUggeQpzf01tn+usolRCYfX+8i1A/jp9xswbVgknabd?=
 =?us-ascii?Q?lr9e5H71UXgSVdk/oSKSAlT06dwid2UT0Y1ZWBHxKEKXUaPgga4Mt2jCWRSi?=
 =?us-ascii?Q?VfKS05U0MTAghK997mxGwkWNy99ze32NyrxVZ/glwxudZFgmYskXYnX86dam?=
 =?us-ascii?Q?/UBe0QDqdM6mGQkAcOITZCAxvfNPcYpCqyXGWjq0pvzeCcModnDLkDyVfTO6?=
 =?us-ascii?Q?Hs6uMCdeW3YynVX1HE+lTOCvEoB/FujI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RXGUX1+LCwqQYVzk6KRG7AcRwszRIXmzerw3eBWPEi5AKGkouLh092foIAae?=
 =?us-ascii?Q?1GMYaeZlwRywcy1CwbZpXvFiF03iDuksehT9l5I71JK1xPk6DukrysVnov+D?=
 =?us-ascii?Q?uRVjyWihJBaln+enRqKaiU63lB7uaepmuit6eofDl1iLYpN2Q3AIlDNt0nSN?=
 =?us-ascii?Q?zIFK02N6G4lJ1kuLw5n7A9M19mNu5MDtWLjqBNTtKeXyqH/Y6n2DD6vukSRd?=
 =?us-ascii?Q?C75BB689c3AJN8J6u8Rp/tXuBzfPboN2lTEw6UdZYroz7bhx0CwTCt3mgHdp?=
 =?us-ascii?Q?UyaHwZ13AlUgfv4aMwv+M1mlL6gUvCMmaDROoC1SXDIl3HI38/JkJvb8CkxS?=
 =?us-ascii?Q?of2EB5/EKVdLdHyD8GcbQm596zZi/gstCPOGgwjOVhwKKFhWLjxWxUHzysTJ?=
 =?us-ascii?Q?oWBXkI1XYm8a9g4XH1jxBzOP3giit5nueQYdPaUsV7f4Z69Vbf0xDbEocKn5?=
 =?us-ascii?Q?BiJmGQGmPtfljOFqLr7Gzym2+gkIXwMPTW/OZf0iF2NHx55u5vA/n8PqIRts?=
 =?us-ascii?Q?2Akh2wyczXFmRfFg32czkv7qnPvC5bmVuNT4p3Y+qQMJaMmbQhKmeIXcLGiB?=
 =?us-ascii?Q?mHEJebYvkzuca9yOvKFGwbwoL7asFZGFyibKoMaCktXY32TY0K4ci120hhaF?=
 =?us-ascii?Q?CeZ48/+vbZVkNp0hMoJqtywpv12lH9demH5VoLE13gLtfIof3U+1YiDsMgIs?=
 =?us-ascii?Q?X/I+CZ7oU7CqXhQ7En0/H7I5/39s98oS5V6dQnjEPYNKWVcjOcL3oY5doCA+?=
 =?us-ascii?Q?6lBwdzRJISsyHDUnyt9egZ//KqUbZpkY9pSrp3w35wKVEQxhY4VbhLEKjwGc?=
 =?us-ascii?Q?ogWTT4su8CxVG7ecglIobkGONDMGwXCDBOY1ku80qQdQBSeLJPuuarNhWruJ?=
 =?us-ascii?Q?vZmwsYdAiKKRzjY6fhX0rsBHAEdGklnKbqPkGTM97IBzU/MVkfzg1FmGow4x?=
 =?us-ascii?Q?fGSbBM6bGZhadnM3ObAmDWqFfIg1Q5xdiH/mErzU8dNFuN+G7/wVWfNLrVmb?=
 =?us-ascii?Q?e4rHq6kCE87sQYj1WP9Kv0Slws1RxNOu56dqOY5gK645RA0TQxdrXmRJd86G?=
 =?us-ascii?Q?YlRdxU/4BN5HUCCeXLtGzZGbxJrVR4KxvCmqRkxYES+tHUShd1MH+ZNdbUpD?=
 =?us-ascii?Q?Fi52AFkJ6+glgT+u9VcaqKHeslAQ9YQ7ZbLw4VVLPRELQ1YuXPKchfBjeKVG?=
 =?us-ascii?Q?K9Taoee03N/qnE3tdyx0TX27rvzjokpz7+CCAap73EwNJlEdqZhtpTEA8GXb?=
 =?us-ascii?Q?HpJWtvDJlE9ZDQNAgIO4e97G6SCbBwyDTQF2QosttksqxXcT1LZqAIV3Mv7n?=
 =?us-ascii?Q?ZljqLsVyb8EppfoBubK+SOHM7fP4JF+N7tMTtNZGAZgxQ9zueMfymB6zu5NP?=
 =?us-ascii?Q?QCLYV3/opmcOemFMGPwHho+ld6wX2B18cyeOnIUT2vUZOO7LCwEDYLasPWtG?=
 =?us-ascii?Q?BU2/j93t0jNlCaApskWv+s7F9MQ5TBPPW1ojPVBC4fHwj/+E3ypzqQAqXeSS?=
 =?us-ascii?Q?65q6xu9i5pnFenERzRQgSQlxOb+b3kH/m9PnoKNY1RB6mj8jR9zKN/QP96yr?=
 =?us-ascii?Q?wNR4Sxu1TGOAhTurqn6TNYH02umbhjZMpXN8X+WUBo9Q0g5Sva1uJGmwAGkw?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qFJdwN3DujmgO3yg4tm26LLr7qX2oOIsqPqIA+1p1eVd5XO8OxRyq7Bs05dJyp5aIQrXL1ftV1MkoW3F2srWyGsqP5TrfeRHXTeejR1mWK2ixiXV0dJDN8O/G5jxv+jxM40AMip121iGCe2C/oKEzIxzxGSCqdxbkCqZyX9113vnJsgOUn+mv+h9Hta1u990QlpjBfyGl3X2+3MXTg9h7/U4O+/rHMOi4TVwwKFvyMntGsNdQ8eK2Z44imuWJAOpTcg6rWix3gyq/fhDCRaEMrrYDJV/zVVxFVwC/mJxADciXjTv1kFhRMYhDy4PYn3OdCk4tIUwoAJE8dmxnYFkiRWm5OIj2/ntb4ewJCbv0oHlhWHdl+/Nsyo+adQEkLXE1Jk16bvY4RLobaTgWoyO/yqqUfT/+XESTRpsjHaI7Y7lo2exbqA93D24n8hQkE5HWmb630kA1AkpB5HMUV9wf2BeEt3evJzKDXfcwxE3RhmbtalDk1eDwVNquv4y6VLW7Qm3/GswbeUdtGfwMJkkEoQ1j7cJivfHQ/+R/JIklJyyDlwxhEQ1cHTTes0iOPfEkHTn/3nYh0P2Q6BWSAQSb4+MsgPG4UE9+NLU+R5fZQg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbe4952b-f52e-400f-35d5-08de0c001ea7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 15:32:58.7681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M45cdOsGYoNmCIVxUGakZimDjh8fXlLv3g/X/YWpEQBtZs48Q36lVDJBdWu6mkQbQh2QJ/LKckVtoJciQEqKDLtFAQ63mi5+aurPIjBE30E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5745
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-15_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510150116
X-Proofpoint-GUID: MBPuO_lXJDHnzB-6zkPBMe___wU4ziXX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNyBTYWx0ZWRfX5VbaCME0uQh2
 lvx/7o1Q0a2DJ4sQZOHoH0hUlpyUINwDmZiuCDRxiNotaro44/p5Bf1uv2up3iCER1C/Zm6TRBX
 jLEm/F1jSwCsmDQo210xLDoHyK15FRoKo1Tijb7p5v0epJ03ioRcTRjNoqQAYDiTfA/S0pMiCDr
 FbLpMf0R+fVplR8nfvp8Ilii3c5FTD5lCSyQVKJ/TvLulGYF1rr1GBH1UeHjeyI2ndhHTuyf6FM
 +AGP8q/W2gRdW74//tz7/JRiTYe53G2U6VfBWdgaXCofs8j4R6P6OtcvMDYoxQ2OHC0jv00xliz
 ErqIGCVoWnAaJ5DcnhGfSWAlCm4DDy+SUdQhL68maf3oEO+3togG8m6f0PKdnBsq25CobvsNhkQ
 OMUk+/nHkBYqKT5LV0G7TN1I9vwXnQ==
X-Authority-Analysis: v=2.4 cv=OolCCi/t c=1 sm=1 tr=0 ts=68efbeaf cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=i0EeH86SAAAA:8 a=XaRIphHe35bG0mt1gR4A:9
 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: MBPuO_lXJDHnzB-6zkPBMe___wU4ziXX
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B0924C000C
X-Stat-Signature: 6hoxsjpfueasthfwuh6skafi65ekcm4b
X-Rspam-User: 
X-HE-Tag: 1760542392-755385
X-HE-Meta: U2FsdGVkX186jnYKoyXmgH9OLbC2UGnXBy5fdov9gs0zpzKRM8I0YySWkS3Xs4HYFgI5zAjESwfSXtzcfxszVGnGtEt7fJ5JifPRap7wdqSRrYJLYJ4VGwu/5SYvCRSefnqJ8Tfy27qHnj5ord8PL9EiruyN8pKWkHIVri/CYPxdnlcIzqQe0E6X7V0vVV1DfzQTtOc8tcVzZcSuPpnX9M3pifXFL2Z9F41vHoHRhkeTha0Pcn50yNqDphPZwc0Db8KDQUSFWpBpkFSAGPS3gkYKBIb2PfowMLLAuOvq5JW9pr6zRNnY2+s8OW4PjBA4yV6/aNZSpNm10lvQQQ2jyGbGLnRiONBvUK7eYUurZnCjCpQ9L9sSIqih/Hh27XH6srtToln4ve8zlQrHV/XAj4Teb0sVUQcxUxxzF2T9oa01FmxqEM94nZBEC4XAmNSXHPp1KFlDAZrMrYCx/Rvn6B+gCqPY9yp+KUFyUjVxaZzrtUw3m1Wr9xYbcShBZlHH/XoS3Iv/HLNnGrsDCJeLYLSMTeVFfh1hxxkeQPNVPB/YGYXfN1kIMRYoD95++N5VjNa9u5uvpqt8d+dLLoL8A3OhhDlZ3ycz+z663IGxnoLHdXcA4f0yOwVBZ1kGwgd3fGwbNUtNR/1DwFV8yw9/IA/JEsBkNCV0TUbBDZV6RXdrp+dzypTVnVIxRNlpk+B6Ngli/16CEsVdSvVuN4iidx3IZ+gHnRQRbjhIJJdgt+mK4EsDwR1aqf8bA2nRQL2ksvOlOplnbSsAeAVpH0h0AE9UaIONtTLFmizAnR2Nl0SXJMWT9DlavTEqcy3KehBn1jiaNMhPrTtQX9u3CFow6kmQUvn89y9uqfR6NOetecVkXj9BGt8+2s28/b/K85q7M72y4f53Ackn5lM9t1C9ZgWsJGX3epKlTaYb7CnMbpxUjumxJVnK17I9pghAAMqxhdcwM78K3m2k7/jo21m
 znEun0dE
 KiNOBlZ/PnjitPOcXTEwxJCQ1KVVdG/R2VvdMITLSaa5HkgOQ64rubcdqhh8//W2aXsOBDIEFrNBGVw2SAW4AJYZOG8Ajf6QA4CBcl+WHxp45tB+6dq+OUWoOs9PMYOSTlfgiMsMeigC679czzpKuKmHnBxgOTlyTR41GgxNlSavmEr2YIf8RcOlRciuvE7vUXs+zWncck+5vlKEeozxemgecnDXYnZPAdCjSniu2wzy3ZYSHSX0D3aw3HjRjiM7U7c8NVnI/dH2iS54RrpNPOR9SUch+VCSPPAzE6ZO3Fs3sQAmQsrfYAQ4Lp5VpiMakTXC5KCdAEm9VjSgCtoGXqgqrax4Gu5NlDOGxqqHtFks+oXzYFEYqV8qiI0DEqk48DQWCXiM/W/siNIVYa3kDFggPTcNgnpuqfZRs40MgXvLWQdSCVZBR4NGGLSWHcnuo4TmIv3/BH65HK/5ctuPYMlUolbQPpmk+FJOFfa3lC479i6XgxZ7RvI6dYhyypf77nKutCBylVPw/h3ivGObV0GR9HSuELZGzHTY4E5ZWFo/DtXurCJrKPUURsmQQV+C4EXHvQeGdYDV/U9foaJXQ3tWS81Wk7ddskcYzPJEhJGTHSiS9n60tOESzUINKy/0ckDrcsy2JWyMYpCZvfX6vIGH6vXyOknHDCnN1weKp1rHe6viV/h6ilPEeUhWWdN4qbX1jxJ4FWw6/uLg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 08:35:14PM +0800, Kefeng Wang wrote:
> If the folio(even not CoW folio) is dma pinned, it can't be
> migrated, so always skip pinned folio to avoid a waste of cycles
> when folios migration.

NIT: 'when folios migration' -> 'when folios are migrated'.

Maybe worth saying 'due to elevated reference count?'

>
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

LGTM though so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/mprotect.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 113b48985834..bb59a42809b8 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -136,9 +136,12 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
>  	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
>  		goto skip;
>
> -	/* Also skip shared copy-on-write pages */
> -	if (is_cow_mapping(vma->vm_flags) &&
> -	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
> +	/* Also skip shared copy-on-write folios */
> +	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
> +		goto skip;
> +
> +	/* Folios are pinned and can't be migrated */
> +	if (folio_maybe_dma_pinned(folio))
>  		goto skip;
>
>  	/*
> --
> 2.27.0
>
>

