Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F630EE3698
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 16:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 104576B0005; Thu, 12 Feb 2026 11:50:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2CD6B0088; Thu, 12 Feb 2026 11:50:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA29D6B008A; Thu, 12 Feb 2026 11:50:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DAC5A6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:50:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACD4C1B374E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:50:28 +0000 (UTC)
X-FDA: 84436392936.20.0D97996
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2975B180009
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:50:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C2SfLNHo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VJpCgL5l;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770915025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCDI29h9vynKVmVbGiYRiItjxxuFFGHkGfF5oJGX9aI=;
	b=PmukADef+3gWQ19+K4dRzj/Y1XgLU2eSq4FqEZAwf0l1W2GJbk15n+fUAty8qTtzLjjHuO
	OgusC5JOFKYs3PLMVfOZ2Ha/YB205VeL9ohvVrEaPBVlhTDpsWh8eTsO4hlDod2b3Orkx3
	BgYbJwQ6h59RzoOEXY0bCsf4X35AfkA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C2SfLNHo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VJpCgL5l;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770915025; a=rsa-sha256;
	cv=pass;
	b=GWk04P6s1CoefVeuHNtP6UH8LDlpegsdHAc2fwhadKUZgZIki9LcBNZVv1STeXpS9ugwWj
	HnycFraraoiXi3l5JX8jBAjj/8DjiV/NWG8mi2AAES6C9+Va2c0BoKoeJwJt88mKl1lo4W
	YIZ3AHYFNrbv0cDmJGdJJ/1hzuwJO8A=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61CGNMco1042121;
	Thu, 12 Feb 2026 16:45:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=JCDI29h9vynKVmVbGi
	YRiItjxxuFFGHkGfF5oJGX9aI=; b=C2SfLNHo8ghpzWq1CeiPWFgGHh6tj79q6W
	3JeTSWL1ERPYKM+tlezLNx3XtqDF8KKSlkdaYTTg5We+m7gWH2KZMXjQ8PZMDH1R
	/MSe9tA5HmKiSx2Iv+ImcQ+wZlVaE4rcZJN1qNmdCjMGWpRRjtCvg5yrolUrfUM/
	ERvZqsl+tK+TnQcoZgp0PswpEGH7HgarmQZIS7A5GehN+BCPjAmo+g0fxHV5NEvj
	RIH8zMEiIdbd8294IMoMZicq7M7KXHxNPgBW+tFzWslkaxr7I/raYQR0K3765+gH
	Lfzg+IMO21LojMUtiItwT20bogUYB2jvjyNQ+0XuA4n/lsqQGsTQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xfp86nf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 16:45:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61CG3mpu030063;
	Thu, 12 Feb 2026 16:45:08 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013018.outbound.protection.outlook.com [40.93.196.18])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c822b60he-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 16:45:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Of4oM/axzhSwgq5WfAZYk+z40CeLaUAp4hmR7vWTc/uvqp5Ao6GjjqAocF/rTaqYoRBjfVP/8xGjWLC2U18t32ma1h+vc2m13aXSd924mVkKRp2LjL60UlZKtrr7dmsUt3qKEiiigX/FvW4aLkjGKDktrJiEZZh1Jy4BfYOBGY//LhFbzhyO5ZTMM0PAX/y2ZHdy/nvzpaSIBVnPtAqV9o/vXmrHuBgX9VpgAaBpssS5GpGi8EnqrRWv4gdhfGgGZoquItVU3aufdNn0y6lSpYFVGfehGNMts8JEkhOdRcsfhJ+NYhvPEA0kCQRV1fKuPmduTjbR3t2amWhuiwWzYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JCDI29h9vynKVmVbGiYRiItjxxuFFGHkGfF5oJGX9aI=;
 b=R3B0Zv7COaA6FOvT1/mGtOIMmknpmSCH86K3HEp9weX4+oGeSv8c/fAnzvVeQBVyjLxXd9LRqKXsFX4db25SvFKbM7x8qlTEmkn8EHbTyYozA1G3W/iw7HoxEnyqghhboAVwHWztaxynKE+QvIgcKh2VzmRH69uA+6OxJMfO8LZsK74kwrUq25Ud1IYiGewhJOV0el9Z7dkWIi3kjCKEMoQtox2agUkxVDn4zRiIifFKePOLwsdvdSrNoujBwzrXkT5kFgQC5rviXmT5AY4qHVCdySvo9Jvak6knZOdIZ/cFkvaCz0KTgPwzzMXxFPMkci66m05kyHxeiyv43Rs3Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCDI29h9vynKVmVbGiYRiItjxxuFFGHkGfF5oJGX9aI=;
 b=VJpCgL5lL+PEclS0nUjtHXgpQ/NvKEgISfT9q8sgqWRa+HyUA3lhPfa2wm7XDT0BPPsVBUX1oUkEFzN6CzfSB27KS7y3ysJxc0uOcpu3NBmu7uufENO/PEwQ61vDUfCBcBzhSh3HwtfKFX666PZV5DCOISjqNTAK3+KcqCb1kiM=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM6PR10MB4153.namprd10.prod.outlook.com (2603:10b6:5:21d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 12 Feb
 2026 16:45:01 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 16:45:01 +0000
Date: Thu, 12 Feb 2026 11:44:57 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: akpm@linux-foundation.org, shuah@kernel.org, linmiaohe@huawei.com,
        nao.horiguchi@gmail.com, david@kernel.org, lorenzo.stoakes@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Remove duplicate include of unistd.h
Message-ID: <ajdudjqdjub7kotwm2rmfcreu62ovaz4klqjzqk2hng3rmxxun@4fba4hssair3>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Chen Ni <nichen@iscas.ac.cn>, akpm@linux-foundation.org, shuah@kernel.org, 
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, david@kernel.org, 
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
References: <20260211064311.2981726-1-nichen@iscas.ac.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211064311.2981726-1-nichen@iscas.ac.cn>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0116.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM6PR10MB4153:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b81880b-708e-483f-a055-08de6a561062
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yYrVpPiwK3zoEuQDrizp9yZimGKFGzFCDjjzsCdmiBkJhTzu11fZSTwyfLJO?=
 =?us-ascii?Q?Yj8rwAkyYKSXFlEMeQO95lw/Agsj4i3plNrXQQtXQlyFWDYre3MBfTV6MA+R?=
 =?us-ascii?Q?55IGgZTkOV+3oaEj35Fb/9qguSRcTPYXOt4tvpcpX5rpGnLj3OgkP351E9+h?=
 =?us-ascii?Q?rU6ggblfb0hmk9qTZEoxRXMf0hV5u0cV+SIQu8ALkjoKrUyGpm2wB8bAg5rO?=
 =?us-ascii?Q?FPG+rmNiNyyS1gG+/6g/m95Su3eCYuRT/3uDp/imUIzgypRoRUJj/Aupzzdp?=
 =?us-ascii?Q?OckxD2a0r8xfcgJQNJpsSInWaGLbOvsDXSV9Dd1SDH/7PK9H7KscLzzXTqhz?=
 =?us-ascii?Q?eTbB6oylPRmVeYt6l+qHTMVCeik3InhWJvLpcr55rlZBr5CwC4tSk7ZHqtPR?=
 =?us-ascii?Q?1RiTBrxstuWYHBI0KKUxi4obP6tk4x0iiMejdrNOAz2OSmeCAs3c2SX94D1i?=
 =?us-ascii?Q?oc9GdzI5XTVoTm6h9um3J7cB9t7kHME8XQf+91HQpDPgVwJ80uQ/T9wwstxb?=
 =?us-ascii?Q?cgzEwsyyi9FsRP4RCUiXP9uNiYPEUM0RSG5hrfNylHd9h1FVwmYAUsmEU5vG?=
 =?us-ascii?Q?wIm7mgiCRLrO1bcakmUeRg0gkJrbp9mFW3mlZKfHUe8c+9eYrpNVrmDa4Nk0?=
 =?us-ascii?Q?IPZFoVP5jAGVmrfEsvQ2UL0daDfyq7rM+06LQH7x56aDsA5D7qDK6ZgYMXtU?=
 =?us-ascii?Q?FD4+TCsAl/H+k7mfEOiOCbvX+m8cwX5MRY/xW+Bgrieyv+iviGbeQ7VVQsjB?=
 =?us-ascii?Q?WNMiXZ7mpmkArUafX8c5+VgC65YhRs3CXFHvqwD/WcMr9vo1msKrkpzMbHcJ?=
 =?us-ascii?Q?DVK8wese55MnPGAzmKliDFbFnizfCCijtVxAH58zm+TOJFinUaHUcjm7nZwq?=
 =?us-ascii?Q?KLfeDYyLL62VXsRFGv4r9ROBI4wu5BitO+77PEN9YqMysHaXWHHgaSNZlhAT?=
 =?us-ascii?Q?YdqZQRZiKw3uzrRIpYlHHqg8On0rl5Lhm7r4dS2VQwufPMnGH85zuoTMIKeY?=
 =?us-ascii?Q?a5Hc4GsI/UI+ORt80lPEVYsEs0LPI3NtGQswIjYgn7dvOebAc8jnnYzggkcw?=
 =?us-ascii?Q?PFIgJCFUxOnB4H2v3v0p8ABT6nD5oW1i8wh5vyRDcpSUy+ws4+4pB6EutRUB?=
 =?us-ascii?Q?CAp1VRCv8Lh3ZmC1azLdUh3+md//hSlMHlGfJdR+vRkRkOZ1S3sVQGG1cggv?=
 =?us-ascii?Q?je0YxC2rpsIopz5hXcn/pgb7Z5YpjDvBUPzU4Aomr7GmQ+OBETLFGMltlhFn?=
 =?us-ascii?Q?0etfi7X0FcTjcaC1GzpxGGFXCNrNBP3LfoWdyNCrObQTRBdd0e1tuIwpzPC5?=
 =?us-ascii?Q?jL7shLTEYqprHYS17qz/BbXAFTw1jav7muo02xmX9ZeiuZYz1WlTXTd3Q0Qb?=
 =?us-ascii?Q?y+vsY2+Bq/dEIPiGwsVmcKqhJQrJrQWoJj5PpVN0CvwVFGda1b+K2KWlxpVM?=
 =?us-ascii?Q?9ZE8t0gqepmE72Z2ASt+6yz2daSz6r9luAN2CBsgEXCZefmlcL6POkmhKjf5?=
 =?us-ascii?Q?QVKx0RlEuTNACmTeGMXtIKnYq0hsYdRBSLNI5TTXKQG/aqI88p4bKX9dXghd?=
 =?us-ascii?Q?Nq7CYIAyerNfM9d+Mr0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yb/oc1eAcx6qUU8rIeuPz5/Gm6Ocm3KfNQuWEsMc2g6IL7eRM2EQGaX4Hil0?=
 =?us-ascii?Q?8odm3A8E0rtcfdlliEqNmredis4r8uhlO2cOOPl//wTlAdcp7NhjlTozhu0E?=
 =?us-ascii?Q?LTkFg2p25c7YeU3Rb+06EXuJlwZpzZL4LmPrmna6wn65/q3IMISJ55NJXbyC?=
 =?us-ascii?Q?33PzzlsIxWrGV/koSZM8BU9mOJdWzdB9Xd7XQCy1cZV/k4jYtDk+YW1X8RBq?=
 =?us-ascii?Q?EGsRWEfu3F/VXM1uT0Th6wrdj5+w0v6V3zxwk/mOcxg1xkBUuk5YY20FPdfr?=
 =?us-ascii?Q?/W9YM/gePcUVaO4gyirZEb252uBWJOkeYuOPjwoSVxzOeDbxIeb68PXE0oDC?=
 =?us-ascii?Q?7H9q5HUWg5J+odlZiY9JGhNwQ92TBj/oHdmAk8aln1T+9lQMeN1nVAo/Lmu7?=
 =?us-ascii?Q?n/3OzQPb2YFiyhF9mg1vDdvVPgICTTmqquz1K06sTtpDGPaqFZENOu5lJsvR?=
 =?us-ascii?Q?TTy8Ug5LfR0maDgGCIgjrsmSTBuGyh51cF4iX5WfIbZUYh1BNeeFWnWecX5Z?=
 =?us-ascii?Q?CjEhKBy9Y5BmwpwsZWy6s0RoOJ5QyvFR83rwx/FqSz0y2wE41tlQhNuwEN0v?=
 =?us-ascii?Q?kx3SvVs3NflQ/wMxJ52TdzNFuxmiyxfcsIvoc8PnoB/LpJ3Lg2zjDoBPHG1y?=
 =?us-ascii?Q?mZcKBjxBvRDlIR7DhF9odeQl6IA4nBrY1S+X+BvqZQjpm5xPUBVy1b9J/dP9?=
 =?us-ascii?Q?t/+Kl60nlR2Ogv1/SbgjalmsvV1zC0tjlEFCARV2wjj4/0Dr49tBScdeQF+V?=
 =?us-ascii?Q?SQB/detBsCjcXerl7bnweHENc7wVM1oTTTtMTNUPHvI5USv+IhOk4Kt+Lulg?=
 =?us-ascii?Q?o3pfJB0QKDBwCXoqqAf9f6vASqC9OYnSjAj6+7GNTwOF5m9nEu3og9TPelVF?=
 =?us-ascii?Q?NEJ3zI5AZR9rB0GMczkrLWIEPYz39Je1TYNVLmYSmtc+ij7Z442z0GmwA5Jf?=
 =?us-ascii?Q?G6+vOCmylaFSfnPWC2vlBQWRaOHDiiuPrVd4UK4aNLeYRUREqyGfe0xjM1H8?=
 =?us-ascii?Q?0/Odcu0RvL8Jfbx8mKfCttvtMSDZyDWWEHQy8V6bUlrvWaaagchxlc4E8oWP?=
 =?us-ascii?Q?eqKnC7HdphJKZLL+3pjFkVDXl+d7Voe0QZe1G1aR0/8k0/49t1bTNvngEMfY?=
 =?us-ascii?Q?Bbf7jwutp7AqkbzylSyheGOXwrq0drrSAhutV7NzcVVEFji0oEI4AASRqxWc?=
 =?us-ascii?Q?+j9fwxmT/N7BZ/fPQjkuqdjruH0I5mLI0xePUXPrYBeUZQA9q/Y0Jdip05o5?=
 =?us-ascii?Q?tyUe/BGkYkndFKnZ7G2yd7SCdi00Rx3xYyrjA4ou/9CtNOz4WedgCo5YtsO/?=
 =?us-ascii?Q?s2TxSnfqLAsJSr68l3jt9oKD+EWTDovjvpS4rVAVxT1/BMDyX+fuemhsJiVj?=
 =?us-ascii?Q?PEvs7mxrbr+TSEw7StBieuN/Kc11TN2i+lPPAkm6vSX8O9Tuy30ihg+uVvtO?=
 =?us-ascii?Q?dsBxVbvFLXYTLlRRsao42QaZ+44t0p6w854Ke0YPe7eh3Z6xlNd91BzJAuS/?=
 =?us-ascii?Q?Qu3/fwrGb1r0VeK2KmYf0J5ekfNwyaxpPCAeZMuyHBKyxVU5oJjVIVdwcLFB?=
 =?us-ascii?Q?YXd76TI6nEOA1b2lmUpgAWIXDqlVhnfsJ1yG0SIix6XPrWjSsbJJ3wWV3ZO9?=
 =?us-ascii?Q?peYhshMqBvmGp/VB1iC9F0QQ/JWLQntayaci3BH+qodAe60KKqdji4vFks5k?=
 =?us-ascii?Q?2ysw1g+kHaIq9hMgDy9dtdRwaxisxh3OZJA+NAM3yPX6JvrBQyC5gZ1bM8H1?=
 =?us-ascii?Q?YHfi7HRELg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G0ZtF2KJaC9+mMEz3PC5yTmV8t9id5qzbez0BLyUji2aIPD/wN7YvJrwT+qnAr0loaVL0iCmcAMnQrAuNNLsT2cbcpdOfiQhlGEJHMDnLa7vqzqxE6kKMRD8BST0noZZeu0oGx4febu08VJdZbMyFWmrrZRP09bcE7V4+SNiKZlzT7DIl2N+/SzBjnm0lTrg5tvUpxfUa3hUjHeYj6W05KzGF/f7Ueuxwp1AQzxzMio7PfZl+uBQ4kgNm8jS3mmHlBTKlb/hCsgP7+vYCLlxkrjYrKtBuaFfmTx1+2UnMA30OVK4VkIroWuCZHNj2BQVuDDRH8+gR03H6ai5W+rXoQO9Py+YsBGtw9YGqhz4O8LM1u2Ma3GCC7JjDalpbsNqZRfK09Qi5sEpOlsl6aawrLBMSMX5//EzhOjDr3hIj9iEzQNXtb2UsaaQCyjzVqw2jWvlP+7ZqV4vgvEHLPAQBBguUTd4Xz4Q+LCRQgOJfkUQfwI8gowcKkgx6Nq0IWLUGdCMM42fg3saXBTEreZDLJaCu7Myn8gM9qdlHM0FiDWgNPzMIyE4sf7VCetRD4VuAstLZIyc3H/p4ALfdWThw9HVUafYKRlljLw4F2YLxyU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b81880b-708e-483f-a055-08de6a561062
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 16:45:01.0888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 28mM70FjzM9Ivb7XRG/+cOaVQw7zZX/KJMFWffWDY9iIA8H6i9eW0Qm5XEPNUrHMMVdKwcjuPYju8Wt6woQxVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4153
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_05,2026-02-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602120128
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDEyOCBTYWx0ZWRfXxe3lLAlszQlp
 4YRo6D6oBL+an/2nwWbBZK/+W8qqD2xbHMH3lLlC9HYbAjb6eQpcJjXFvmiVkx604Z1OIhlG2/w
 NwSuHQB3MrgTpVKULf1pM2GExAtAB+xHErBj/3MQI5XPqOUnvCzM0hvY7C/LREx1hKKvyeSbgoW
 Z49KhcDFyK/8OteiNGmmPNpSGGGiURk4NELgh+o017CfaQyTRdzO0WP694FtuLVAbOKNiNbQP8A
 LDjo/mH/ZVZBsFt3IoMGozJSqf/mcmJN+L35uOx2ULmq9iobdHoZhUNcG2NoCo2vWBaKwyUA0zf
 Ex2rld0MzSAyaOmIphJ1DhdGJ9QwbBHPeVFepPxdrc6Z67OK3v/zXxc4oigLRw1X3AXAF5CXVRn
 CE++iXo7ydK6Fvej9JmnxDbJKP4FoeGoVqCHZKvM919gBcBv9JwAHzpMNOoAFrAOoSZd41AYmG6
 NTRJIeZXyN4qmFm4qGg==
X-Proofpoint-GUID: Ius7zkTE9ilUTT9ePD2OfP89N3frvEeI
X-Authority-Analysis: v=2.4 cv=V8xwEOni c=1 sm=1 tr=0 ts=698e0395 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8
 a=W6w5ylEofa1PuCpTqzQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: Ius7zkTE9ilUTT9ePD2OfP89N3frvEeI
X-Rspamd-Server: rspam12
X-Stat-Signature: ginztsa49xuys8p9hpo61jbqjk6uoozy
X-Rspamd-Queue-Id: 2975B180009
X-Rspam-User: 
X-HE-Tag: 1770915024-51895
X-HE-Meta: U2FsdGVkX1+JM/YpI27jlNrYjOYrhwQl/S0nG2f5Y5JgLlr0KbTQUtnGo7mBaTaC577IinHzou+WCIn1SuWL6mev4qqroZDloNJn2RgGC+mmggYo8X3lv5TKEEYGFvpq0CSoGCbhOUlf+BB58c2shYk04Vaj7KEaVPmBj3ztSauXtii+lvEem8BFd0pIi0KQ5VEzzaPFv1Vvtlinlv4L7UC3+i7cq5uS9t3ipy1Ems6whu4HFZPNjxeXPRpbWX6trI3SQodghNoVgog9gS68wPkc9UvYs1vPWuNVP6fqUmAHlsIlSgjocDtgNHGJNfXB6k+5cC977urRbwrAeQyrNwEdDkVdRxsNaNCuK+V7SbQ5r6C5AksvwG9RkQBckD5EaJLSOtuce0fYYc2FOMjq9OBSujMl87r4Db1LoQkuB2OpRmZtesyPoHE5SlHVBN0TzqHmvB1Df3wMsSFD418EixLWyDvggQa5fS1+i5D8XvzIM8NUIogQ0hQa+Kg+6Som+ymB7PjaYXaJ5J6wPXQ6VhDGI5Rx7XsMBT7kE1s+9LwvH/tHxnKikk7Oa+JQQOE8FWcLy08RHKfq5l7HrX8ENSP9mmbWvDdux9/qidVN2uzIsGeNPdlmXz0YcrVgpZpn1RN+K93RASaNY83BnZB5YtotP4T+ls3YIHMfZmBPmSXQ2/sgcU+1Z8M9tiy6RAHG+X8w17V1iK6yB2b52I1q8GV6TaJEUQ0wqLwjeWlBL+ycVY7MY3GE0ymbUsWl++zTgjq/MqxI6ELMsLNSobQsOhdCtObHkR91Zh3wUKjoV+JwBYZXvKInKBnv355dfsHO5+4IMybcllEegkbRWrBaxlsKx8M8GmfwsoDgGAq5o4wvCT4EZqyj1JeVo+FclSa2WwQfMmS0MxytcQH1caKkeG3JY+Hp4Vu6M/JtyPoyGTE89PUTNAgTTSCnBQNgaPSKB/DNvy/Jaml4P79ihaV
 f931zsNj
 G/rNK7qYTeQdIbAJIT+VHXAbOvdnX7gHNcHRbqbEU0zspKIQl4QPxj3b9vHIksKXOuLyCVFp7fc1hXFDmgDWpBoZlWt2sDYbQNKPzld9VY+8A7CkE6h1TLyD7ni/H7yDDkOJZF1UqhadMyri6L1Ut0yT63MuoNvJ63zXcgSwDUX09o8/YKWNBrsoNpb1l7/fTSpvZDDwd4XiX8neCrfHHlns7bgEnr7WvLqdheXu01sSZ7IwinnlDzaPhFC6+HeB33wNYPJYj65Xy96CE8K78IIDytav9RpTmYzAnbbBM+pwyivvePp9H6uZRy7AhZI8l/oJbN3PUDCyi90HpvdcP4vD+ZwYGAVrs8kezjSJBETOBA32UALBXzp/4FOPQc99qTs1jHhmz5sFTfRFApWYXDofGhlhW6GYqvvDdrmMquR42OwLIOhsUxLMimemr0LJ17Erq2BQgofvFchyAxJoSwHPTY2v+ZTfF2ddPIMJlbDzA3rQjhNrn2dGHzmtnpg19JvX/AfCiGAEBVUxosATaOy4ZFPDDCSWOUH763zPyJVKbhRyoAhmxwUKbYHtdD4gfs95Ih+jjHlTzQb3VNXvvr9Miz5badKU6yOv379pJuoScNLjYszm30dE3K3bAcOyqq91uTv4k4rTndokdS03IeDU9hSWeyLhh5mxMfVL086kSljg0nSF0R6SGn3MByq0jza2S3SqAXMP8rJeL8RkJuL9dsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Chen Ni <nichen@iscas.ac.cn> [260211 01:44]:
> Remove duplicate inclusion of unistd.h in memory-failure.c to clean up
> redundant code.
> 
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>


> ---
>  tools/testing/selftests/mm/memory-failure.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
> index 3d9e0b9ffb41..032ed952057c 100644
> --- a/tools/testing/selftests/mm/memory-failure.c
> +++ b/tools/testing/selftests/mm/memory-failure.c
> @@ -13,7 +13,6 @@
>  #include <unistd.h>
>  #include <signal.h>
>  #include <setjmp.h>
> -#include <unistd.h>
>  #include <fcntl.h>
>  #include <sys/vfs.h>
>  #include <linux/magic.h>
> -- 
> 2.25.1
> 

