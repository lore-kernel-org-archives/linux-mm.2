Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16700CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7CA8E0012; Fri, 12 Sep 2025 05:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF698E0006; Fri, 12 Sep 2025 05:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477A48E0012; Fri, 12 Sep 2025 05:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 354608E0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:47:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9A3287010
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:47:56 +0000 (UTC)
X-FDA: 83880121752.10.1EBEBD2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6BB0C2000B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:47:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FeKOwD9x;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IVc5frCE;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757670473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmA5zG3gCEpdPQzhta62GkJ7J9z8MkJTi3y/KawEdGk=;
	b=ww5HbhbospQ6n/DP/QrmgUdT/fYht+PxLPwHNAF9i2iICPR9N+vwMZCdY0Z2RtRAUrbzgu
	KTYUNCFDQ8TVKMGYWvyRIYtnsqQjuZFVileANogKjDVi4/X4rzuzGdsmHJPFDESMtvL3r0
	sKCpUClXQ/1QX/MIbFdc0gsrQwPvN90=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FeKOwD9x;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IVc5frCE;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757670473; a=rsa-sha256;
	cv=pass;
	b=IMLSZkkSgVQKjelPGIcn3Y6+I1HQ6pAs3nez2RzmxE7bUb7/ZpH4CVKFLSaXPgeiXzwhcI
	i+rHjlCb9BqHzrUClCYtsugPhwWs5QzekgOJVyx1gSAlgPfU8Lnv9W3D4nfBZ06YU5JDyP
	GWEf+jc/uuQErP2L6txoYh8kRygItgs=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1uPfI022740;
	Fri, 12 Sep 2025 09:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wmA5zG3gCEpdPQzhta
	62GkJ7J9z8MkJTi3y/KawEdGk=; b=FeKOwD9xo7aD85F2aGu3jA5xjNN1tlfPdG
	Wqi1vUUIWsoqYSka3/nhGXeYEXZM97DisoX36IcuZn+b3owQ98K8FBPTpGKAqu9B
	e/EsFEvzjwauqfMkZoKemF8YBI1R/iINN54XFivj3b7BjR4uQna1HaO6t3x7CW/k
	Eur0ZvLOtcW5vsSXq4WjzCiLBqhpaO3xkFkS+sZ1paOYilD3qlrQgBpJsR+GST40
	mN1EQYNOlMPqVdM1SoIVDpFIGCc4VjlcQ6/c8RzniY2wt2+vBY9Ia0y3xNIXmDLj
	llHTKEN66CYzNhUzYagq5vIbt8Wi7mJe6wr3wjxu5f7EWBADqGsg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921pefxft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 09:47:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58C8hMAV012835;
	Fri, 12 Sep 2025 09:47:40 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012061.outbound.protection.outlook.com [40.107.200.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bddu43w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 09:47:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gv8qThu/I4CaWMYadivfvGs8aYBsjHpTVaTn5IqBtSm/5XB7bgnWm3TDBpbW1Mr7wsEafKT/BhXUsbzltEDW+6KtDiy6iZ9UTt0+Ja+mgD6zkERmP8mHYstjjuctYSwYdDIBQB5wQp8o65ndh4kQYKR2q9RVwzo0CqanoCN1pAHtfWBWsZe7agxZiMdtyg51a8i8nzJOCG+qQiOZgOCCZHz1k5/7OozACov1NfYrsEE7DSks5Zp9V0nm1OguabUqXMFiUtiUUvWVhKErqiVRXaezCrHdIguudLQuI135ZGodeMSMCGoH8fHRfo+RiKr/rGDhtsq2vu2FIUXXawdkFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmA5zG3gCEpdPQzhta62GkJ7J9z8MkJTi3y/KawEdGk=;
 b=neLerIOJ9x/FVYH+Okx4PWNjN4VbvdG8K6EuxmHLyPsGu67Mt6eVKEouSd068cRnKA0WAJUPywubanJZKnrHHya1O6DdtS2wZnSntLQqQBajUYWas8uels4aNec6usc32y+L7+T/XJAnRE/mb9Q6jyoFYZvwrlx1k/0AEJyzj78n4giiTaUt4o+oa00ViohBDjEj9b/KgXHQ6oYsNkDSZykx3HJARZxrimpCfZcU5djC4oakDoJUa/Lmp47OqrJEt5nLMJSZR/T22A9Pg1OHFfQ+dP4gMPfLupiZRquvXXVTgLvzddWHHavHQ9XtVMu1duNunmyvONTVNmiRLpekQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wmA5zG3gCEpdPQzhta62GkJ7J9z8MkJTi3y/KawEdGk=;
 b=IVc5frCEkBe8m59DCHrHisiaE4+U7zj3HVImElnuLDKrWOBTESLy0JNF3DNv+kaIraCNzC2nhm/XrGAqaAmWtryGnLnR0VqmBHaCg7+vit3pIUC7VCj5b05MUn0SjVmQZyht/lwUUAYzj8ZckSDRD/rWaC9EeqhEUyKC7WEhtXY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4530.namprd10.prod.outlook.com (2603:10b6:303:90::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 09:47:37 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 09:47:37 +0000
Date: Fri, 12 Sep 2025 10:47:34 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
        Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
        Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand <david@redhat.com>,
        Yosry Ahmed <yosryahmed@google.com>, Zi Yan <ziy@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/15] mm, swap: use the swap table for the swap cache
 and switch API
Message-ID: <32503f17-ab9e-480f-9921-72f20e3e4c4f@lucifer.local>
References: <20250910160833.3464-1-ryncsn@gmail.com>
 <20250910160833.3464-12-ryncsn@gmail.com>
 <CABzRoyZc1zHHy5eFaO5hRY=bM36xsk3COd=r18KahmrP11tpSw@mail.gmail.com>
 <CABzRoyaAA3D0nfkQcBMjZ7crUckJXXpGmYfmq6ojQC+BQUigFw@mail.gmail.com>
 <CAMgjq7CtYpe4sEYaw2carqGskvchV9Z+1yn2Wa3nMP2VguV_eQ@mail.gmail.com>
 <223c560b-0234-4203-a11d-661656317808@linux.dev>
 <d5f84730-c7c0-4059-a5b7-061a9eaebc5c@lucifer.local>
 <CAMgjq7BbYmTCmA+NPS_jQ3iWM4DJR1mkDe925qTcYOMzbGwnGg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7BbYmTCmA+NPS_jQ3iWM4DJR1mkDe925qTcYOMzbGwnGg@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0470.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4530:EE_
X-MS-Office365-Filtering-Correlation-Id: 90d9ebe7-2357-40dd-d2fe-08ddf1e1684c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gtAjL5QmPKZhlY+eXuUsslYO6aDKLozvP3vN2SiysU5oyMraGZfwOzdaZeGy?=
 =?us-ascii?Q?yxYMT8S8stWtpQh+yOUvdobNVoTyz0UxQO1DWaIqCrxYq2eKFsjH+RzJG6vo?=
 =?us-ascii?Q?EPX2Z5c63UN/wi4/nt14H//1mpDOHPwBmV0p7q8rj4fHnqVadxn+WA2dK1pe?=
 =?us-ascii?Q?qqSm3wWE3nKmff6OzwFsVJN6MfRK7JPJR/yM/4zcke9/QUoHN2PqmxpU8EtZ?=
 =?us-ascii?Q?fe2pL/5rVC87QD/CvlmJBNTifDgTvIMZJt3BGe7TqJXTfzjW1FXWbJ0Pn0em?=
 =?us-ascii?Q?pQ3xq8UlS8WIQzeGQHUjm2xH93Khid7A/XRWi8kW/vz5QoHS0J6tNdpfMyks?=
 =?us-ascii?Q?JGrxfnkWgKtAI23j+5derWozIxTNl4QWrMPvCMtJ5QOvnCnmvUXNNcqvqK2q?=
 =?us-ascii?Q?+bVRmUoKb9hYyDkTjJVLbwktvENac3uT/y/Vkx3k24olY2J0GzwvGWnzZC6L?=
 =?us-ascii?Q?nQxI29YddgrO+vRguMPZXBLUKz79Nwz9QUg8pkUm8nbNc//iCD2gEdfmkZIK?=
 =?us-ascii?Q?f1zI1WHc9+ZHDqaEhZ4Pbzy4j6P4zxOosaOJHK6WIFDPxlY+2+ygbU/abA1l?=
 =?us-ascii?Q?T+RMwxmecJjIMCU0pXgwhL/U0Evo72qfdyoDpPDnsEXlqr/hDY62Aqg6T7kb?=
 =?us-ascii?Q?myt2B1tqzMU5A4uSag1Lyrja72gBlLLg4X44c5JbwnGAkJZmNrJTo2/dq9JX?=
 =?us-ascii?Q?kmGdbutctEVrb+3RjR2W+ddcERareVe5xyp59GKpK3FJEJjgAkBBjXVI3H2y?=
 =?us-ascii?Q?eOpCCSXL9vg/sIj7T9NeC4A4D5sQ9qr60gT4R2Nrm+xh/dAe5+mhj3QcRu//?=
 =?us-ascii?Q?zx7PQZdSYB5svwck9X+8jlAlqArvyzKvgzmpabzn2eF5YV+6By6wfFHkVNdw?=
 =?us-ascii?Q?FpAcJlady2iTJ/vr3rUh9QiUBLOMKBT2QMVjnXt19GDXHUn/YdxHyNx1iD+8?=
 =?us-ascii?Q?IIVQIjw0wPIGtsnnBAeajOyqsuNwYqKSpcJAAOUwbY6qt/phYc55AYCGZfLq?=
 =?us-ascii?Q?NStF4js+/nV+CnrmlAAH2jEQO7We4reTAPtEgLlSYT7oRZiqTeTL8dmf5dte?=
 =?us-ascii?Q?hkvWd9ipvHdkFM5ODyWCNVEV+QmEsRS6bQ8fbU9OS7pekU6NIVeOqADCzCT/?=
 =?us-ascii?Q?6J0MQ3OHP+n6ANnPexDTp1EY2FosmxoHJ78SNl7raiLZ+q5e5Y2zsh0mBTPi?=
 =?us-ascii?Q?IYnVpX1VceR38gNdaqX56jwGDSg65c1A8ie466ie3K004zxKKNO1n/08asf+?=
 =?us-ascii?Q?5Fsu21Rm34DjSDMDuDci9Sr0DiIA9y200lkfaZ1keMrAZv3zaTeT+i3tX8FJ?=
 =?us-ascii?Q?F7btBCGnJIwuH/gS+aVSmYiDxt3Pu1R3k2n3yPTbfHDsE3uQ5dVAMtLDyHRV?=
 =?us-ascii?Q?YeVaM2+Hy4JoCbBsGWYucajM//wdCovXmI+7TMlTl9fKPFBkLg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/XR0TwrgBnPUiv4VnttrMIGVG8BFk7BCGlaVdr1SIrQsjzR/9TwZAEK4Iwa5?=
 =?us-ascii?Q?x7H1m0PcGN21QqUvkr7ORwfHh4FI4zZJcxsSyEuRYn3LpKTpt4hq1S8LyQQa?=
 =?us-ascii?Q?wX7grY5LONB07dbKgZee+esp3Bu3jNW7RPjQCrvm0ht+LcUKPR7ublA0DL3u?=
 =?us-ascii?Q?iYO45eTLu1QDxy5lcU94QVgJtYMAfQNJDPWHDgkXGH1d87JqKPXnxTQ5zhjc?=
 =?us-ascii?Q?sM5g+v79DcYlNKkbM4Mh1P/Vb/KyAJMqhejj7QX2gWlLqmoTiIcEXH/mXKMo?=
 =?us-ascii?Q?Hz1UCf6+iWK0x36zqKDf7L2nHjtDeL66RIjZUY7q6jISH0PfWueCuU3+NO8W?=
 =?us-ascii?Q?DN+EqxNWLpoXoJiwHncbaeaPPhau7ux/vFWxw9g44IWYWpWBaIlRJJ/mNLk1?=
 =?us-ascii?Q?RfYyxbg1fF2W7CpkksA9ed0H1YdNQzqUVyXgyyRXxPcnlmhQ+fp/dB6soCFx?=
 =?us-ascii?Q?zL5RwHISa+X+1co9Tb5uWYfwfmYqYcZWx1zNEXtR9p4KE1FQdhq5K2xptXtL?=
 =?us-ascii?Q?ku7h9fyDpp15oa74cJkJOmHJk8NrWs/7TnofyuxF2BYNmHSFVaO7uj2sIVMs?=
 =?us-ascii?Q?wHAlivfvmNOtl8Vx8W4C2voCd3KJnSzJ3KyPeJ6+7haLByQDsRNBIWNR66NZ?=
 =?us-ascii?Q?6fyR7S9vyOQvv87Lbn7rHcEqCGucsijeHlgmilSYSVLRp9mvgf29emBaEqlB?=
 =?us-ascii?Q?camLR1i+CztejamC740wpTpd11+KEz3GPrq/nLJlZzq8xGTuZ2kSIxoE4ZJM?=
 =?us-ascii?Q?35UQrUieaDOkY3/STcZSrIeZ/a1PmtogEUo8oGnUj6x+lDhWucNsdPUUbnXk?=
 =?us-ascii?Q?m4Wf3Ns7qcb1oW/eJQ/piwihGLq9Rg44A8ALTdVeVdzltVpbt6hMNpF9dVU8?=
 =?us-ascii?Q?ZtWIC+K5PvShr/B1I5bydp/OWIvYgiMq8WX622raJMPzPRmlyt/bDGOO1Di6?=
 =?us-ascii?Q?FNhlWvfKOFUMHwOOZSAGuNPXo111YGgHmrq19p+508ozkGya/ECwXAh5I1Zi?=
 =?us-ascii?Q?xY7y/sSljJX8Gtn+HSq8Owl/zq8ggGexpKJcxXav6zHNEYiRszbbRMV78gNG?=
 =?us-ascii?Q?TfM+fDUOlU0u+89EkwTpxVM16iBvIDLAkLJlhCjTA43X9mPaBp7uYzDVbfS+?=
 =?us-ascii?Q?ipvDqGvoiLF1d7+gpyTu7tH6pc2nLKX2xVEfe9WaeN9KvpdEkW1/psXO8AN2?=
 =?us-ascii?Q?iCFtys5Qz6PUOval2KCcqeO6NNo12i/JWFssy/1gLPiW+MxBh1TzQopi1Jly?=
 =?us-ascii?Q?BJlOrYUH3yTtp4x4rllbbxW47x8+E9AdmN524zwLQK6qhSEeKQ9wy2XVQwp3?=
 =?us-ascii?Q?qACoqGQa337jHxYDvAB+SCenUmVvR1WPK2uYeOV6AZeGaOhT7icf4kKISk6i?=
 =?us-ascii?Q?oZJg8HomimRsoD2ArMW+Z1wvghnVM/Ak1jgt/PAcf8ExQeUBAmYBJV410l6G?=
 =?us-ascii?Q?mF3y4kqjhSwIAbxVfYNZ5jxwjnIPV8f9V+6BnjJV41ljxVKaZsvGVSZ17Rmi?=
 =?us-ascii?Q?X4S5LGtIkfky9FbqK3GuBLuDGBydtqq3c8qDf8yJJTo2eC0WXlhKtBBlPKa7?=
 =?us-ascii?Q?3dGngkEWTSCifENuF2CfJHAFfVBEv0HO/jzUUCd/h/cp8H+MkNKc15ZP09AH?=
 =?us-ascii?Q?Jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WeZxD6SHeWhzcMxPepQ8ysLHKyZbiBLAPFIOQP2d8an7RxY79+biGGo7wVWJAJtNI3HxeChPBiYLSn8/Ykn1XFjJdKJ/I4tw7jS7DY5p+KInw7NxFAF4TowLwanA0lXWp6JwjKXGTz6RFMOOJLRoJ1u3nyLQUO7aVRrDsCp4cjvfRp+Ph0o/uvW2cAaSnczwCOdDmZdrUWUIibYqXVIWVI+IBeSwKyvBtqIRXEO+JuNV0ad7RskpBPw6LsGuo1XtiYv+ZDOjyRTVW6kQ68WGSGMt9G997DFWguH0Lh254lVfW5Xl41LYP5geFMNRq6cLqqT+sFXwlMyal4Tdo/nDn3YFxycWkLukaCoKN2SnI7iTgHVZ0sSnJDViJfs/QNHaWPnDdLGB5wIIzEX/3jzZ9GmvG4mulP6GC6rTTrSVjBKfU3kTARflbwUY2gEiPE76LuGVSV/i3KNljYg4fw8/SFOTZENh/UtQI2vx6YXJJFc+HLvub2RH9EehM+sgYMiZS9Boy6q2W1l6dl9/rb/H1kt9YVcNiuJM5LoTwqxAriNe2vb021UWdb4Lu+Ra2CXqFxqEXpd5QC+5UxwTN9vspSMMLQW4ctin3mxIZqtfQrA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d9ebe7-2357-40dd-d2fe-08ddf1e1684c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 09:47:37.6883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IW6QMr0wkyqrCIbRyxqd2k++KneAy9kePLmYGC+hDk6RpyE5g6h82pQya5jGJQRUR/w/ox28T0Ymk+25LQr89ObDgFXXOd0lM2NaKWW25FQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4530
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120091
X-Proofpoint-GUID: yhN7qLsQl-wS2yfy3GNyPX4fhep4sWh-
X-Proofpoint-ORIG-GUID: yhN7qLsQl-wS2yfy3GNyPX4fhep4sWh-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX3fvFdpVAWrtN
 ywNb0aWQSAAftv2NQPz4U+VOetGEhojcqjWQeCSb2NaUYIlhEHqKCXmc3VgrRRRPP0bRsY1Uwmn
 3+8sK7jXQvbPCq9CODy21Sk7frLVEZ1JIMdCjUGVGUsq0yCNofBSR02oay6v09qDDRaoTLxjq3U
 2pGbFoXXBX+ewjz7nN6PtWX7n9U/tL+mpqPyR7e4xY79L4JPuS2v3EZL9Zc5JyohtwK7dyEOjmL
 tPkbqnw2Pc5QUhfX+oMnLlAVOA0QFrzZ2qt+DuS/hcqc0sOGv3upPVPChThdItq3HclT8hQ4bpS
 vGld1UMRGRBYPNeHq5raCPSns9Huv1JsgkdpT6PgCa1eaBfbKkjZd+HlQtISLPqWgQ6ssLRWE9s
 dCpCyq98
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68c3ec3d b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=fYbhGPvKPZ0hst4Z:21 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10
 a=czuE3VdJKv-Bpdhw6NYA:9 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6BB0C2000B
X-Stat-Signature: frmsrhq87q3kwdrcnjcwhik7zibfimcq
X-HE-Tag: 1757670473-897259
X-HE-Meta: U2FsdGVkX18Ms/KHJiNT4AkOZ9RODW8j0PqqjqGDtihqENAqbs28C2LhOWw8E50BUEbfPnwBCtCTqeoiIDsSOht6UILllnYk7ncGrrtinWrzLmrVoqd4H7wZBOtYiy2R8e7EpnmvQYI9WYmOSK6PqDfBSHhBGgIYJdT7DOyd9R6GO68cFlfxCogEJicRj87lKyfeB1Gywnk3f/jFRkTS4v1FMCwvnx8x4KlxQcGtxoJkez1kVkEzwDWlkq0VjfoyJrduCH2wqteDmXinaD3V9/VwEc91K+bMvDiiyUZEyWu14yyL3m/qEAhshUm42+Hpkl1D8MRo4c8txuFrrpq+ckkvRAnBtVpxahZuQXAKMVxPkvhh7EY+bfqCRMlXUwSv73rCFiXIkzqvdFktkb0wHon7kru5K80urwLuhtbO9S/XGF7tlFgk1/5k9Kxa+kC5PddQPCqbjrzGqV/Hv9Shepa4h5VbslIfSc+pX74IiO9AJtYuHsUQnU8szn3odfL4jJZ0WgoVCQfPBnCtCzqMWq8kUHBCBKbiyBL/DVD1qJeMGXeXcFwuOS0gWN4+KaTGNfvPdrIwysYuX+q5/3bnNcl2+xZu3lL2RV0BThmWc6bw/twHD4gk+lnttMx2v+m6c4IbEgsYA9S4zCWdLQhMnIZdkOm6REnW8eL2VKlc1US1p7K2GQhcIysT4RQsDrFmYrimbZx/7JrzLJyUxCCD8JP397JD8wBiF+g+ac1qJA+2D36TSuTjPicmLqzKljHpkcJGGKw9czOvsINsH3AA5EB16RKdRGIZ73aAcOEJmY5ZvO3XiJD19B1iIy3gHgcSRQiSKVca4199DPKauZm1H2VYArC9FOPIgqBnNRzJPcINx+l2TCZOrf4eVjPyGSk3IZnmakrBHTO/gLME3737l1DjW7T66Qitst6LFZGJPS73wiI94nfZIfC/VS6FSxN6dZXKq7YA/y0A/BEzT70
 MiGUyZI2
 7lEC6+1OfC8c1AYrG9yEjuy15wGUOZM3ud5OuyCTOvbo/+DOmSu6RjlQVYUFXSrlzM9UP6/GZJZRwS9g8APRtM89sW3xgKpEroBYKhvs7NLP+2tZaryxjtY7w2EI621U8MlFEXXFyyIwqmJp5e6Z34Iil2R8IssxF2eJw6S5c6lKa/1zPGsSx4c7ehxw0EulWMFQIxLcpCN57tVZU/N/usp6j9Y7ty7AR+7gzXcOe7cBGcknxGf1Ha+zmlsfA4uqnoLuiiIZZPNewosM2csn+ge5xlNMoCiYkglSOeZYQkgLqLAr1rC4zLF+v8eZTNYdWNH6zrlCn249GgSPWGFpCvN1VDGIVlX+H7TrIMYrSiTbBx/dK7kOfTDlBvbeOanm+PnS9qlOhX+BKapBEbcI67fosxGYdSm2PfoPQ2osE40piD7MVY6x8khWHdYFQRlt+E0W3eiG7KTrt23EUx5lgU76PZ4QsLnfocZImWdNpA+E7Xes1VMh6dkvhxk4Xqfhl7qeaZ5TtX9fBH83ndUbk5flMBv7QN9HPBKkKWnz0H7wQ23KTucS1AY15rnT62DjP1X4GBGzd36eDQz/13tRvMh1zkzz9OJWfdVhr6tjylS7UJ8Z7N89S5D9p4lHqLuWlxPsdbn6gFgsD/G5mFAb1B5/FKQfNDipFX6eqog0/rPx8v0MGqJSyy4HSWDgIQdBRHCqn5i4pUr8c0pBXQ4dHPvilSSnv7jC8lpOKRN/rCxtkwskZHfzTJXp4OQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 05:42:53PM +0800, Kairui Song wrote:
> Thanks for the info. But I think V3 should be good?
>
> CONFIG_SWAP depends on CONFIG_MMU so if you have !CONFIG_MMU, you must
> have !CONFIG_SWAP.
>
> I didn't adjust the header in V3 and fixed it differently from what
> Lance is suggesting, V3 wraps swp_offset with CONFIG_SWAP. It should
> covers !CONFIG_MMU case too.
>
> The folio_index in V3 (this patch) looks like this:
>
> static inline pgoff_t folio_index(struct folio *folio)
> {
> #ifdef CONFIG_SWAP
>         if (unlikely(folio_test_swapcache(folio)))
>                return swp_offset(folio->swap);
> #endif
>         return folio->index;
> }
>
> I just tested !MMU and it seems fine.

Yup my bad, it's because mm-new is not actually up-to-date properly. So
mm-new build is broken until v3 is taken.

