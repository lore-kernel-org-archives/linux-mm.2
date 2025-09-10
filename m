Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49ADACA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 01:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9511F8E0009; Tue,  9 Sep 2025 21:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901D58E0002; Tue,  9 Sep 2025 21:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2D18E0009; Tue,  9 Sep 2025 21:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FC728E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:15:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE7C91605B2
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:15:16 +0000 (UTC)
X-FDA: 83871572232.20.5B49269
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 76EAE180003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:15:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jMk9Jl3L;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nG3sV0EU;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757466913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqt0J+sxnk+vs4iQVEE9HG5Um1V1ux3iSH+D+F7U4cY=;
	b=2imKuxmdnND9ASQN7v42U83Xlm/EmQNkdmyGgrENZhfEOTQ5t0tXo0RSnGw7MRwRtY6fVc
	5Efvc8/NFqH76gcEZduyLWPRqw5mQO3/JXnmnAr3qg9XLiw5g4FQxUWi88UY2rgO/M6nRm
	re4uKu7+xu5aNkJW9jTY/9Ro0Cl7M9M=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jMk9Jl3L;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nG3sV0EU;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757466913; a=rsa-sha256;
	cv=pass;
	b=OVcAxTNsHGMXNeChQ4bzDbgPJN6zq2AfFLkdOaiX6sZosvuWqO/wuJMW8E2tm/UlAKg2oJ
	vhZqoUbqXGRYn9yHrJbgAAigM+CoNzlmW0l8klshNwGfK6O9RWg3VeuXvsD2uHngv/BYL7
	iz3OvH0x/TyxATzkI1NuU7dBi8ZuKpY=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L0ZH2016819;
	Wed, 10 Sep 2025 01:15:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xqt0J+sxnk+vs4iQVE
	E9HG5Um1V1ux3iSH+D+F7U4cY=; b=jMk9Jl3LcrXB8ZAfi+IkxqwzP4C59dgDQh
	t2+x7LPfYThEv8Qzf8U49RRRYuaAgpuQ6NTzwvpUGm4DOjVNCwZd0YbG1sjVKtso
	5tT1M9TBzyK+DFfUzYT1RlnN9ac8R4ZUCkwYAEwHqpsXnTelBIUVEys5KAsxGkkq
	PQQ5WU//fTvaqmqIvOMeRciDoUPiEs2AYJZfSTPnm1k3x9Hyj0qc0OFKRuCYfj6W
	gOqVfDM+UgC5bo0Btz1YDco6WK2ZCG2k05LKNzS00PKKqZE8MRBteE4bXW5gNPge
	CpDbqiECZ1g6s4KLqUNZOXaqr2JQeFaAmpvF0ThvGGyZTb0/MOjg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922x932dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 01:15:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589Md74B038950;
	Wed, 10 Sep 2025 01:15:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdac5ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 01:15:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NzPGQrG1onTEq8kyUEly8KNL6H+OPBX3/KVQtuGsqG+OvGc6aLoe3Okdf+JJlLRao9mdYtX1YKhtHN6H7zref5FvE9G8P5I5AkVCUMrFaL5kpRcfBa+ruOXq3hP6lGCbXso8D1sEk3tkD+72TpOb6wIQmzLQJLheYCWuxp0RtH93WljpGHskqT2hiV7gZRHURRMUlQCv8/Sl2EChXYCmjr3GSMxZS+WDjjoCmsusTpub2z8mLohT/QnqgxaNbrF5Uw40xTZOEtHy9Rm1exsmOHhemwM3iAvp+7bAwVHywxnThvGJzvJSG4FLQqSx+bd64ObPsoeWNqnsYRKkVGVg+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xqt0J+sxnk+vs4iQVEE9HG5Um1V1ux3iSH+D+F7U4cY=;
 b=Rj/zjrMuL/QV4RxiMFDCyhiiEAsifYOE+mPs5NoIyXoRCnC8CXCE1sSHRxD/Y1FXkhwF5m5Q4IJqxCud8dCV2cmPKwZmUljBeah9sIc9Oc+P1tinyyNH8Bs4n55R5jIc0zSUlfOcQbcXGsl882bzrhsAQUTgnYpOWWReqtqRCAJ/TpaAmc+g3Zz07tottwNVTUmAiGXTxQPAP9H/qXiAypa8vQT2+F47/xArq3y5itLC0d1IS8hftgbWrAZc9cBx3uJCgdgPmOxyz4BD822TJ7Q6YPSXxbm9NWS7qB5UfY5ktN4W6kY8W0dYrmG+Khp33I0sbQFNrp+zP4d5la8hjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqt0J+sxnk+vs4iQVEE9HG5Um1V1ux3iSH+D+F7U4cY=;
 b=nG3sV0EUFRAQRgbTNnHXJXzesKdbRoMOUP+DEimsMt1VWKMHr2AEfiwC9VgmW2MjngwUx4/5fNomUQmiNpd08veWnZqDoI9j3t/dQ/kfnQkJlou0keCmrQwHfuF4ADbvpErVUBWv335VG83ufKcUGoZ0eZMmavH9Gtu//MR6/dE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ5PPFD796AA27B.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d3) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 01:15:00 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 01:15:00 +0000
Date: Wed, 10 Sep 2025 10:14:50 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jane Chu <jane.chu@oracle.com>
Cc: osalvador@suse.de, liushixin2@huawei.com, muchun.song@linux.dev,
        david@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, jannh@google.com
Subject: Re: [PATCH] mm/hugetlb: fix copy_hugetlb_page_range() to use
 ->pt_share_count
Message-ID: <aMDRAr1UP1Ix6zaY@hyeyoo>
References: <20250909184357.569259-1-jane.chu@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909184357.569259-1-jane.chu@oracle.com>
X-ClientProxiedBy: SL2P216CA0164.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1b::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ5PPFD796AA27B:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a5304c8-ce0a-4d73-9691-08ddf0077637
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6s+V8lphgIyZa5bMS3Dj8tK/dHDKZqksdIKMHnUtKmuCahgpsvNUIB8p8BbX?=
 =?us-ascii?Q?VBRPhUsgYiaoRU0/+dNhqcMSi/0BVN4Pg9Py5RqTYF06RP9W87NNmwtcvapz?=
 =?us-ascii?Q?dM80lrO6w/aJdSKvJ28CmmNSHhtPfrdujuGe00j0WkQNxcsgIr7cklbzLV7l?=
 =?us-ascii?Q?imsmlJaGJwPqcRmamZpxAYXIGWmgQRXRc9kt9gK8HHCKH9lV/sggHLq4H4MD?=
 =?us-ascii?Q?gmR3Z81WOEGRN0CVzNvCQBh7jR47M+a/lxpDLLA4+fcMGt36ykclL7hFBTYW?=
 =?us-ascii?Q?j1cH1Dt1IGHz1lbTJx3TzwcPj5pTW2aOlmcZhduO+byKyIl8woYdEIWm1rVx?=
 =?us-ascii?Q?WaIhSSVQGDsf+V6B4+f4FP3gKL4k4mgBRSmx5kSN6tUhZ/RyxGW/hnf+zc9m?=
 =?us-ascii?Q?XhBcy1tTestSvxQ41/2thV3BQbHwSliLH1YYR/cMKG08NbfwtlCYN+Befc3D?=
 =?us-ascii?Q?LayDAwlCuyVq3Ek2pYeHB55wNYVOgDLG8it3dkAd6d4symuwp30v4a2zNQuE?=
 =?us-ascii?Q?SxaJ0r5iFYRk6+23V/BpZCRUu+cYWR17QlbtW+nQWkV1rNNXnzK706KfKHL5?=
 =?us-ascii?Q?tr2zk9LYQLy5eD/5e1kIGov60pVAmqy4CupoDd9JeeB6hDm9GZBMYzhgL2O8?=
 =?us-ascii?Q?IWVLNnBCpy5M77K5RGxckppwEbbMjQZgxkcZNyxo3waUYLf9ipo9soho3+gZ?=
 =?us-ascii?Q?01PO5QETj2+LT8zfvItrymKSTnkCoVsvzJ6bwczWl9bgZPdZkl9HatyaSxD6?=
 =?us-ascii?Q?49y+SRya2PrWvfToUl0LYML/MwafQp+Lz5HJKI7TRgnZw2SpUmDIEYOX3kwt?=
 =?us-ascii?Q?b/9uSS35MiLDNqbsHgxNX/ilGHQecI2dQqC6hMZARvBDpzgiRvAYCdtjWE93?=
 =?us-ascii?Q?wgNeKAukrKrc32aJmd9KmyaDuqYFJeabP7nr5Y4A1mIe1GTQSbzAbMcNSh+I?=
 =?us-ascii?Q?C3ebL19Hg97G8Qs4bc1MtcTpxXcadFgCKILN/salG9/GsLesQV1VFR5jGA1p?=
 =?us-ascii?Q?NaQLfjxI34YN+acOtEcdfFLe8Nebs2Ln18cvxRZp2vBJFUpND+s70owkFeHo?=
 =?us-ascii?Q?YlrPooOseZ4cPe0k9ZhxSTlRioggkB+Grw06FgF3whQsCfpj7QMyYOk50RR6?=
 =?us-ascii?Q?W5N9AaUdEPpdKb5vMqbY01d9UX/8cqV1TG8G6dStDdcbk6zD+URniCsXRhpa?=
 =?us-ascii?Q?SQEkAqHTomraaalwBpzEIXo4hjn2BUMEHKAde45MZdIxpn7PPrxWCOu9k3bs?=
 =?us-ascii?Q?Vm8dDRdqbir7norae35aWZ1dSQHSBOp2mn4oqd3H4I2KsjHhQt3YLkJ1qhEp?=
 =?us-ascii?Q?UBIzreUFRygcT9G+hTLsgyawk7vHSGJXjAGegwQ6K4ZaQesp/wdH+sRa5TVn?=
 =?us-ascii?Q?xp85NObdVAwcfJhv1aRN7EcIaLYhADwyKauIEm3I6TnoPZ/+x5D6FXLFVte8?=
 =?us-ascii?Q?FasI6hew1rI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cQsuBdYG6M+5TWyYEPrgt6mdJSZ7/N26gEThfaluafDYcHGTtJcK2x9g3K2C?=
 =?us-ascii?Q?773u549thjbSl5h2b1be5HSlxUpEbnKAGeaY6gFvDEZ7ch5ZN8YydZMM8A4y?=
 =?us-ascii?Q?u+Wey2A/ewvBJPSV+M4ITqicwMIH+6aEaARqwWGvlw1G6sIB1G8octxfr9MY?=
 =?us-ascii?Q?6l00GQEBibIf94B/CeWiz1l1qP3P7xl2dauUvBCyEPZ2WWaF7SXhefAr9Z7Q?=
 =?us-ascii?Q?+F7i4zj2RnDTGP1B7c1EtBZAwPNJOP73AcpWgh/yanUXRztFmou9e0w3O3SV?=
 =?us-ascii?Q?YXGYE9w3BrbU7AAPBtOzFErh8HdPVE32nhzwsXX2REV31JsH8Szlbvtbn9ht?=
 =?us-ascii?Q?V9BrGwAn01l8On7o/EM62ev8okon7N/co2AAnQJ1kasJoWC2Y1/UgKKHo0F3?=
 =?us-ascii?Q?qwoXDVyn4S0CRQnnVMLVhfbLYeWHPvIRq+U0o0EXjiC87J44U4tSqA+1TbeH?=
 =?us-ascii?Q?L7l40HopLZHk1X6Bxsz1v88Ky9Nowg7AHuOyLafQ3j9VUkwaKWZ9mJ1ortp8?=
 =?us-ascii?Q?pVgA38revyC7h9HqASNPXoo3i4LQi4YMKD60h81OW0J7wX8BGvI0pog1U+ta?=
 =?us-ascii?Q?baSBu/Sf8XgxBvS62/NPChdrixbpHiaV7EjvZygTHIYdFKvMat36VqpNoTIv?=
 =?us-ascii?Q?wJOZSz58gnJnDNouumfC2DyG/3RS8bVAEVEMT5FUlSBLkeu8zpkYM/nUOOr8?=
 =?us-ascii?Q?lX9KZ3Mp3/rp0cJfVC7fyTEcOh6FWlqPNOHv8PS1m6UikyoOP8TefGw9O5qR?=
 =?us-ascii?Q?5mPiv9SZbHvKX11+oFtqPuJs3UYbVTJcX1lIjmqLGy6VaRTZDo9Rp4AYY7NV?=
 =?us-ascii?Q?6ngu7t02qrDJOeZcGJ/DL8wvhSWzJ884YRedo4FkvvcCzzvsRyTdUKSQXJ5m?=
 =?us-ascii?Q?m3Bc53hrtuKMiRGJ1s9kOIKJ0dItAtMTs/vIRxjwRHXadzXBxX8ifFDgqvH8?=
 =?us-ascii?Q?mB+u+Ov8lEb3TZqRpU2K4sv02TG43DAHmGcgbDuRfPJKAtcRv1bazbpl4dpq?=
 =?us-ascii?Q?YcrAxkXP462eVShfZfrCOf3iafZsF1lxegP/fJ6P7Jl9tKuO4e32uUp3XvDX?=
 =?us-ascii?Q?5hsNzDsRN0bJQOIcxgMZzu/b7uJg3EILiWMvg4fvK9EsWI8G3zpmZLtVpzse?=
 =?us-ascii?Q?Ztq2vGcqWvZPpH7NVtb1eZYEi+9StEOurpr2X+9ElNFGoCiLUdzgmVQcyl3k?=
 =?us-ascii?Q?Eaf9FJR6MWk029JtKlMtWExeyHHeyk0zdTyE2p6LT9og4TTAWWKsrH/HC+oY?=
 =?us-ascii?Q?PAAO2j7jyDLjDb6hnEn1LULZqY4RTaqWJG1E5RmwQOZqRUozktDFGJAOGI/j?=
 =?us-ascii?Q?vLz9ZuARMDNxrGcYFQd2dsSiE7iSlnlV586gLDsf7nWQvlvjZ7LsM59tYRwr?=
 =?us-ascii?Q?qUT0e6/gy5c1d5V76lN1kmO9WnBcg7gdr0aMfGOydD4wAIbOqtjGAPYIl2Fn?=
 =?us-ascii?Q?VbGklvtstWrlCkZrL/EqzWsV1NQA1cu8VVF/lMs3lTRvRnCbm16rDNlMcx9m?=
 =?us-ascii?Q?95HK4VkLP8VPbaJBID9XeFBtrFN37wKoQnyDvfbqsYANlDfYXXG+BAqD8L0g?=
 =?us-ascii?Q?jyAdYVp355PSAAp5QFKBlwuQuuzC/FpYy2Oq5Pb9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Aq9taSoyXeaUkwkPA9t5UiW8v8OKpv+fuoCg6lhn1bKQcV9aIMjRmY0sffc+z6Ke81Ihlwq5cYisbQsZpllN4CcdQ/OL4F3t+JFQD1AgAuTihEdGGbJP3zZiKCxOMEiJkJ3rDGY0Q2R1Ekiv8y7ogeR5Gi267UjPRNa2UbooEsjG5pqi4ilKbd8s7wYQoaQeEH8deCv3K0znyDh7QGRbPIAdf+CncxT1UtruWZ3JdVNyP/0oKoQUD4pu2Ga9mgkVcCtzHaTaKnjU1SFy//ObIK7f2XcwXyM0CCGcnuQqfICPa91bMi3z1Ohm8pC5O87HG6/2otNB/t+no4EF+Q+MclMU+ILTsmb+KMS5qwXDJYyl/CTbKJIIfhe3CbCG/apa7BtmooahD9warnd3cgnw5eIZEn4DNpbBOIT80szjHERdzBwf217I+PjNs4jsMEVo1XW3kAn9kmNN/y7tVv1djDsOp/JrvZ7nPNNQep8gSWrXrCKoff8Y+5dIt3Y+KoaNZuV2tncZft5JuH4Cf1PCISU4VmqUEjhuypkW9EIMQSJVdb7hkf/FZHtXc0eB0LoXan03UoL4H7xxddrG/oyurkqdDMjVY+RCJ09cZVb+jJI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a5304c8-ce0a-4d73-9691-08ddf0077637
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 01:15:00.3082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QjQzrXWsnX/Ln7V/7I8on5jkGwOpq6ZsltKJOcBeIp4dLh4FfaoatoazEdrNdKsFPzKSsTRDdhGO5gsK8YpkKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD796AA27B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100009
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NiBTYWx0ZWRfX+5Z+dUEPuK29
 gcP2XR91EClxo952TnLHNRD/Q6f1KaNoKc3a6WAoeHUgACkwU2Bo40MdVY6uLTTW6sQlvALjvgP
 HnED/Q2QbF/n1Q8nqcwJLLR9JMJ5in3qWe3u8u9C03qQ8m/gWAB+9qZ6eBsnvcBLwfh2P11bgaK
 vp4hULcoG5o6gtCcLUvY9wRYHQ/JRiFECoSA/FKs3UWYoLC5Y2XipRIblauM4pZWnX9BZmJNDqL
 9hZLC3GqITU4OOrsWr1OaLcfrOrgj9n1P7Xo/2fVnvyxyFi6PIiCq/tXGf4XLlnCYUb0yGxhYgL
 CPXZ8805e280l02MdWzKMC3bokuGCHDX/kTqoxVVKEFyxVQh1T/6NMptmN0f980Ldfdbopu8X0Z
 C5iU44azdx9XClgSs/h5IuH9gbNSgA==
X-Proofpoint-GUID: gY_z7mJaz-fmza_-36ixS67Jhlc_o0am
X-Proofpoint-ORIG-GUID: gY_z7mJaz-fmza_-36ixS67Jhlc_o0am
X-Authority-Analysis: v=2.4 cv=LYY86ifi c=1 sm=1 tr=0 ts=68c0d11a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=E5WGbSE0ojqRuLBXenIA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12083
X-Stat-Signature: gcy5ofnxsg4h7kh14zodbqgucdetmes5
X-Rspam-User: 
X-Rspamd-Queue-Id: 76EAE180003
X-Rspamd-Server: rspam04
X-HE-Tag: 1757466913-472041
X-HE-Meta: U2FsdGVkX1/Ue7gTUFMVBZzBHFIJRD9TCI4HvXjoBDh0daxXQenbH/L3MnWLvSI/ttvNeZy+szbwUMkyLahbkIwj5YTzBnVaaW7oB0srvj0qiYKitkhMu5N72ceVbG2trcEkBNwuvxwqI85UnU0dkyENjGtBb7KLR/Og5Nn9VELB3vCv3pFQ8RgaEFp6/D/JyxyaV24StJFiA9geP0sEXQdt1n8XAOKWjKJXPSVu1IGxOCaE0/1KmOvNQCNqRi00O+JbtFD4c1o1jFH60QvAE4YbH0+mfRw85a3pMtxm7cIqmgecBRCIxtiea2jQHIPC2d9YxAf+AVYzMzpPzohqC28pLNHhCS6Y1zY9IcLevEvcKcmrSekkx2P8EbqaBIxXyDfmnTYGpouqVMHXBcAImQWz8lo9lBAtM1ucu4iXuM39ZJWFD+CmT5ZGjd0a0dbWjtQlNPAmxk/B4DGC6vFsWCFNV/2ax0Jz95jCK6Y9lN44oXWPvScmOhqKcZBsIrvqBrlSkdX2NzYzkzef7p+lJdQhBU6GYVCABD0B2QsXOpuFd9w7mw8NAidPTLXAoIhGrT1bFMzW4vOn8yZ982pr6oc0oCwqRuanVQTgHWzTs2Bq+MNogyvHmlmx3gQAzzAkOW4pJ1V9fUSgvf3sOCqhfYcm6J2bXt+B9l/XHx0bTG54y+JxygSx+PZGDKbWnF+qD4JLbUQgzQfVaCbcU7oRjeNk+Ygg1c+nFN0oEpCDbfbg8NAEx1mKnYEX8BHDe8s1kU1D9RNlsEl7LEOH/WBTTIa7pAUCd21v8+RMaiokPm6JJmawQE1WTXeOdB9dAwAlSEtjLez7vkHzSzuaq59Cp9U9CIkD16kBGVuRZIDzsqU/A45RzEigF4qpXPyf3U1PvAeF5nhmOuMsaQlub3VYo5rx+5JV04gqQqiFUTdjN6XwNQmlVOh+EjoxBJSoZNKtv/KO3MJbmk42/dwaeVX
 mobOhwEX
 pK/S1XMpnuuxBu9uoBEy9Mnz39spuBa/kecsBZ+ifcc9hZ+7evSDM6mygZr1fJD1JXc1RM7Tcok2UEJow1G8u5sTgxTYmMwnmC+58px2CsEJD59iHnOwHd+jdTI+G7dg/F9a1OR34hHUI2sgDJGhA1NiY3UGS7etrzh6uK36wAvLNl/w2D9laVn07GTl/EkW3rrYDl33REej4UY63tw4vG1BGqT5Psdv5Ufdjq7vKIpwdz6Nt0w2FX/DSmlWXQN90KSXteTSGQrjKORmoWy01XIeEPA7TUamwD2cMsovkUsV3IQ4tQeChbRVzaJhfwYqDp5/vjeT2N7KQJx2vI30tBSJc6lKRm3GBF+mI1t4R4MNdn3n1AvDXf4fAwsEbmiFBa7KQjHK1FT6cNLIPlGHRUm1/03J/xqJweOXkB+qfuRReWkcqFNTCOjRMBdQzoPxGR0nY4EEGx5pG8Teu6E52PxdNCYTOR8sQu1KFbEVw6+2+qczReg00DJ3chNEsyWkJHjGbMkvlQnLqyyYMhy0t8tsuGlX3h9zz3j5TwpUFOpAyj86z1s+UAcqFqpQNU7tFGHjA3nv+wgpLoPk/smfX6DMBZ0EhV2nrWeq3ltK1ilQw6e23/7IywPQ3qdjm4aQH1tb3HFk/HFGwwQkfbbYWTBMG+J6WhZCuDfkJTnQSCOyhh4WaP45RD1okS3lwqY+gCPrUzUD03MJUdiZpXqB/IKEeNPC/tPtUH3931rz/VSulTEJRAcmRrQar5yXnEulAr0aMdDwM8PDXzsLmPl7cmrkSbeHAebu5pahkd2Ys5Jr3fu2UU5aUUA0lmpkx6DQr9ph2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 12:43:57PM -0600, Jane Chu wrote:
> commit 59d9094df3d79 introduced ->pt_share_count dedicated to

nit: the format should be:
  commit <sha1> ("summary")
?

> hugetlb PMD share count tracking, but omitted fixing
> copy_hugetlb_page_range(), leaving the function relying on
> page_count() for tracking that no longer works.
> 
> When lazy page table copy for hugetlb is disabled (commit bcd51a3c679d),

same here.

> fork()'ing with hugetlb PMD sharing quickly lockup -
> 
> [  239.446559] watchdog: BUG: soft lockup - CPU#75 stuck for 27s!
> [  239.446611] RIP: 0010:native_queued_spin_lock_slowpath+0x7e/0x2e0
> [  239.446631] Call Trace:
> [  239.446633]  <TASK>
> [  239.446636]  _raw_spin_lock+0x3f/0x60
> [  239.446639]  copy_hugetlb_page_range+0x258/0xb50
> [  239.446645]  copy_page_range+0x22b/0x2c0
> [  239.446651]  dup_mmap+0x3e2/0x770
> [  239.446654]  dup_mm.constprop.0+0x5e/0x230
> [  239.446657]  copy_process+0xd17/0x1760
> [  239.446660]  kernel_clone+0xc0/0x3e0
> [  239.446661]  __do_sys_clone+0x65/0xa0
> [  239.446664]  do_syscall_64+0x82/0x930
> [  239.446668]  ? count_memcg_events+0xd2/0x190
> [  239.446671]  ? syscall_trace_enter+0x14e/0x1f0
> [  239.446676]  ? syscall_exit_work+0x118/0x150
> [  239.446677]  ? arch_exit_to_user_mode_prepare.constprop.0+0x9/0xb0
> [  239.446681]  ? clear_bhb_loop+0x30/0x80
> [  239.446684]  ? clear_bhb_loop+0x30/0x80
> [  239.446686]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> There are two options to resolve the potential latent issue:
>   1. remove the PMD sharing awareness from copy_hugetlb_page_range(),
>   2. fix it.
> This patch opts for the second option.
> 
> Fixes: 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared
> count")

nit: we don't add newline even when Fixes: tag is line is over 75 characters?
 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---

The change in general looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

+Cc Jann Horn who backported the commit 59d9094df3d79.

Elaborating a little bit why it doesn't need to be backported:
TL;DR: One needs to backport commit 3aa4ed8040e15 to pre-v6.0 kernels,
or revert commit bcd51a3c679d to trigger this.

commit 59d9094df3d79 ("mm: hugetlb: independent PMD page table shared count")
is introduced in 6.13 and backported to 5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y.

As lazy page table copy is enabled in v6.0 by commit bcd51a3c679d
("hugetlb: lazy page table copies in fork()"), the bug is not triggered
because shared hugetlb VMAs go through lazy page table copy logic
(vma_needs_copy() returns false) or they can't share page tables
(uffd_disable_huge_pmd_share() returns false).

They shouldn't have anon_vma, VM_PFNMAP, VM_MIXEDMAP and UFFD-WP VMA
cannot share page tables - so either vma_needs_copy() return false, or
page tables cannot be shared.

And before commit 3aa4ed8040e15 ("mm/hugetlb: make detecting shared pte
more reliable") introduced in v6.1, copy_hugetlb_page_range() doesn't check
refcount to determine whether the page table is shared. 

>  mm/hugetlb.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 753f99b4c718..8ca5b4f7805f 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5594,18 +5594,13 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>  			break;
>  		}
>  
> -		/*
> -		 * If the pagetables are shared don't copy or take references.
> -		 *
> -		 * dst_pte == src_pte is the common case of src/dest sharing.
> -		 * However, src could have 'unshared' and dst shares with
> -		 * another vma. So page_count of ptep page is checked instead
> -		 * to reliably determine whether pte is shared.
> -		 */
> -		if (page_count(virt_to_page(dst_pte)) > 1) {
> +#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
> +		/* If the pagetables are shared don't copy or take references. */
> +		if (ptdesc_pmd_pts_count(virt_to_ptdesc(dst_pte)) > 0) {
>  			addr |= last_addr_mask;
>  			continue;
>  		}
> +#endif
>  
>  		dst_ptl = huge_pte_lock(h, dst, dst_pte);
>  		src_ptl = huge_pte_lockptr(h, src, src_pte);
> -- 
> 2.43.5
> 

-- 
Cheers,
Harry / Hyeonggon

