Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9DF9CCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 00:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FAC18E01A7; Wed, 29 Oct 2025 20:52:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182FE8E0106; Wed, 29 Oct 2025 20:52:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3138E01A7; Wed, 29 Oct 2025 20:52:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA5248E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:52:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 704B689194
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:52:01 +0000 (UTC)
X-FDA: 84052953642.12.A9536DA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 17E4218000E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:51:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gSNN1Vro;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BcUr+qXg;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761785518; a=rsa-sha256;
	cv=pass;
	b=Fg+XgbPnFTWoa3tfY2oSDurAAaDGoSwT/C+79ZoLTaz3yVEc5YN7ayaQCUavTUHK7QVh19
	d4U3pfcwJhn4g7W7z1uIdSgRxMDpzPtXa6pT3zYKb7u9dFh7K0M6CX3KsX/NCVgDl+9/Za
	kYcO6u63HfazOVVKuWvZqexugEvqjTs=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gSNN1Vro;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BcUr+qXg;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761785518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfteQrHv0Wz8x6jcCfBVzY7wQJzBjcIOnVRg4JmHZEQ=;
	b=yf7Pvzpgo+B7cIjP7btvCl3g5F7ROreM2sHSIieam5XLilY8KsfFX5JCwbenrYqruQ8KgK
	Acpqr4J74eH3gLIllF7C9pWeCThzGPA9Id5LLDokLp/pLxV5FE6DztVhrQGOVpjkOoweJF
	ymt/SsbNeBx+0sFSpvPOuWHZejv93cc=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TKKITa009170;
	Thu, 30 Oct 2025 00:51:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IfteQrHv0Wz8x6jcCf
	BVzY7wQJzBjcIOnVRg4JmHZEQ=; b=gSNN1Vro9SPYr35DRUcpXpD5WnzaI15UmX
	hU2HzllnAgj6QtnIXFxBUwNcGZ1hN4s+pY7q6RIK1zdgBzFSE9Uh/5vpjuL8YD9U
	GU9gl4D1AuibqdfUc0zAp3HVwyUHphBWZmKH0uBUGNF0WQP+H+QKWDWN46+1Xjzx
	1ly2WIu2pkZamgBKcQxvuvOJwV+7ur55OHC9l7U3/+ImUT8dpZ4uW1fwOqBda2y4
	s7Oa9CbIl70gRcHjiAXx8qiI2/SV4SHqd7XMEMUJtS4JvJYyCmgX3xIQWtFMxAKH
	isg6WxXYYkyY099tp3dwR7HmbEaNNX6FWVNNWTsRxigox4WFM3BA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3cv9ahsh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 00:51:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59TMIIa1021188;
	Thu, 30 Oct 2025 00:51:48 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010042.outbound.protection.outlook.com [52.101.201.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a359uk9m2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 00:51:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HviorVYmihLZjgjapX+U4o+28mRVQp4LNaDc3uEH5fvvu1wTD2wUqZ2IJcbpVUQqeaIn6sE9xAFY6/VnS4U7QD5BG4gwL5UMrGxu6ggUshtNfOTbJ3nJ9z97AyPlOg3DqCNNfKzIMDtUj+MyL+U8DmbDTUTg2SL5tLQ4b2fprN/jBzTkQjiVFH6ZRQzzD6yu1DMAkCQNnqVk5ZYdvefCQ2J9DsLzU/gexWYfoW3IgzqIRjix7Z6g7HAHoWmbBQiXx2RRp4MGT1gkIaR2s50K0BhYlqlVwAPrwp9OdwvRPq5VbvAXFr86SKBu4ewr+chJCNhxlTZ4ykzVMUBU/UVXwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IfteQrHv0Wz8x6jcCfBVzY7wQJzBjcIOnVRg4JmHZEQ=;
 b=tX1tc07pGZLfXeJKv6B3jkbV3KJQyfD5bfWxs0ktpEtY54E3ZYQ0A1o1sx4N122kCXuOp5rZavzN8WZuTrQ2EHJHChQQ6an40fdMiGzhItKUe95lebw844Ns4+FTJBp44BafaJH/iCGyGmPCZu1KFoEGcqiTdAsnTnJiB6tiACwaG2us6Hr8Ar14zsNrzw7hwhTyc+bgmnxncgBu//jthG4UF6eY0iQ+cBVPpW8ijtWXzbkgFKmzZKsVwQl16v1Zmmi2x1O8X+0oaMLyVHx1bOhJfzR9Y6zHXm8S3tfYv3vSbcUX5TkUI6iEpsBSzUe3+KarJ2DDdkxMGh8aUWykMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfteQrHv0Wz8x6jcCfBVzY7wQJzBjcIOnVRg4JmHZEQ=;
 b=BcUr+qXgaz3OMjG9w15ifq6gxyVtMOgmgMjLYCsa79ArlN6aSnAB6irNRII0EvMmUerSeB/9JZeLrsEcNSbCG/T+CQGBP1MrES3ezh6VtT4Wi/x3QjJZMCb4E1f13yVJuHmcxvQc0EsfKpcJAe401nTbsZ6fVw0Itw8NJV0kF9w=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB6806.namprd10.prod.outlook.com (2603:10b6:208:42a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Thu, 30 Oct
 2025 00:51:45 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 00:51:45 +0000
Date: Thu, 30 Oct 2025 09:51:35 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com,
        cl@linux.com, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        shakeel.butt@linux.dev, surenb@google.com, vincenzo.frascino@arm.com,
        yeoreum.yun@arm.com, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V3 7/7] mm/slab: place slabobj_ext metadata in unused
 space within s->size
Message-ID: <aQK2l29EczfwYQNZ@hyeyoo>
References: <20251027122847.320924-1-harry.yoo@oracle.com>
 <20251027122847.320924-8-harry.yoo@oracle.com>
 <bf8f2ed4-0b3b-4ddc-9ce9-0d0b1a64c914@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf8f2ed4-0b3b-4ddc-9ce9-0d0b1a64c914@gmail.com>
X-ClientProxiedBy: SEWP216CA0121.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB6806:EE_
X-MS-Office365-Filtering-Correlation-Id: 383e6020-232f-4374-b245-08de174e7f78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sPGK5bU5YQ2R340GJ6ECQwyla58W2q6sNc4mToBxv8LHssDv3o74SpeUviD6?=
 =?us-ascii?Q?SyR6gGGmInwGewWDaoM1yZZ/jfJuD+groZTJ2oIHBGrdmeSWCXvgJG53xBOl?=
 =?us-ascii?Q?lyNPbSvSSQqIbR522ktiQpJIB1pJzJd2f7+fnldPpjWAKiqjL7ufurpyxL6L?=
 =?us-ascii?Q?C1AaMqq3xZZnzvv1ahXfCodtAEAJrNzqEBV2mGhC/Ac5iFHnp50AKwj907qh?=
 =?us-ascii?Q?KZqtEF/2yGOshT811+ISHR487PWqMzSGtk9nVEhKR6DMZpIA+6CJB8QeqQSa?=
 =?us-ascii?Q?wCd3mCQsF0ETnTHw2Mf09D4uTpmLvjAlDun4D/4jxoT1jWVqM96ObzzfV0kP?=
 =?us-ascii?Q?cVZB+EtCtRhcXps5xAT5nmM209pbxUaPpJr9Xqg2wK2yAatzaRh9xtES1F4K?=
 =?us-ascii?Q?W6kGYyZqF0oLGa0EE3mLK8anHMRhKEjjdKhV1rE095CRors9X/EY7iXnm91a?=
 =?us-ascii?Q?hbdfqMqBwgqflMFLAUKGK4iGBYY7eX1GA76mto90CJuIKjz0V71Ne0dHJIUd?=
 =?us-ascii?Q?ERRxC6zmjUUWSBnV4I83RbAI1Y3TErjX+caCDMoOpKUFvOqpyB3ZOCARqr0G?=
 =?us-ascii?Q?YpNJLwjyXeG/tBZtTS38gO3rx30gN4W8b6uKR2ba1kQjZGyXh2CPTOnYbY0y?=
 =?us-ascii?Q?UlYOcoebimGJJIv4qkLXHqqxg9ePs4I86VRviF2WqKSwMNfjVhdDMM74UQzd?=
 =?us-ascii?Q?iIIDgleIdEmdABbuj9PmyjayKC2+45X7BxhxNLwP7GNAmVb5UKpwOmENgCVG?=
 =?us-ascii?Q?Z+4EMtbsCxKW01od32kI+NXIAI0kE1akmOtf0UdNHiAz9V9c7EeuOP4CzcWd?=
 =?us-ascii?Q?TFXh+0DVTqxK9xSu5SREysdvRPjzKdzXRPCyShbUagqOxO0h2daxBlt/tVLw?=
 =?us-ascii?Q?nl0HQ+NbOAZcaRk+CuNT/QTr+G/yUoFxMyhClfTUyozdJx169YvFeZxlaOWg?=
 =?us-ascii?Q?pEmJoCQoqkuD/hCqHeIVFnsQ7enrtvDlsHfsCLXyfF/VCD+AQOV97orHvZ4M?=
 =?us-ascii?Q?xn1epK0zXMu05nQLsxmQIsf4//+4gwhoJjeRGt5qCi/+8nEstYHajNlM7aCE?=
 =?us-ascii?Q?3JeLd84IDVjgVN0NvyvPJF5ckDgMogFzw2yTPj+VOMFQHRjOAPPBN8NfxdCo?=
 =?us-ascii?Q?I0x8LwxU7V6lXNEBtxdRVJgofoDu4dW7KtKKovgxwbdAMaNe495CAHb9iEn1?=
 =?us-ascii?Q?CmFCxl/MA6ygiIsn4q/QXBE1LcXsWFgWTKV+MQgePZdfWkPwFIxhyqCw9frB?=
 =?us-ascii?Q?VUbsqOj9dryHx4EiQU+xkfEqlMN6+tyIXb8o+pTWTuGyn6mrqSOCTTsgr1As?=
 =?us-ascii?Q?h6vd3xBLlIB0j9+eWNxiMCH+3eQpXBBkdl3GR+ZWVIRv1EQf6HT9VVRACZTE?=
 =?us-ascii?Q?XjZE/MHVNFCsapAhudjGvJl8EJMlJsGGELVJrAP4Ll9zTZfSwCikCSTUmKs9?=
 =?us-ascii?Q?scStpKFrKZC6pCRKJZd/LAZBQ+Ja5WmB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SC9oKXY+P2B5KSQYe8hlJXHPT4DNimKN4SEwoVNmTBN9L5xj1uyXSGYH8jbk?=
 =?us-ascii?Q?CZtckYmp5fNHfXw+/dg69FaQAcY+sbVgWDxRC5wx3uHu/ibaFkSK+tDjpOLP?=
 =?us-ascii?Q?2YC3fJh+I6ui/Eow7+dhvS4cnqKlqTPDlBZZ7PSm+KHBeLSeQ+5BllkznftV?=
 =?us-ascii?Q?JNRK+yiNjE4Z1jf833WftOZyrZJrIxm4ud8X1p0DBIA8WqZDgRob+2r243Hw?=
 =?us-ascii?Q?z5qHCJpEavDpkbXw+NfZ+A8RHi+41C1ZCSq5LYRUkjhv4rSmKATLJo4J3Gqz?=
 =?us-ascii?Q?P64wOa0jEXgI8HtTfhGhNQhGZcSZ46JP6JXOVWSTAODHmTjPtqYhefyTkI73?=
 =?us-ascii?Q?ac18/mfyLYtEBYPgWJF4JAYzSOsKIhKttY8sD0k3q3+WVfNvey2DmabxoG9v?=
 =?us-ascii?Q?O5pX0ZOHJKpUlESnPldSm4T2VCK0CeyP+hTnJr8lnWZhvri5aDyf8J6nY0lt?=
 =?us-ascii?Q?ZlLxI7Tf92XJG5u4xAgOJVd0bipIF4dwRjLzBTK/Kfp3j4jwCH1eKsWmfbcq?=
 =?us-ascii?Q?XnDFugpscSbzjOYZEjTYDJDhNFF07lsJlKj+nn4xAIcyu+L9fRwG3+EDcsT5?=
 =?us-ascii?Q?AX12KGZTsaxHryK4CQYMhzAIbcC4mGaMeTexDUiT/F5Sgo5NrPtXIX8km8dp?=
 =?us-ascii?Q?ZYDH56WqRiBPSVcIZkVzSyT+UjBXZwTDGAVGE/g/+sYrPw3zedTbE6LFMpvd?=
 =?us-ascii?Q?OLIEd09pO5YS9C91WVQdpVAva1cfsU0cagNTWODZkCFFjztCV+PQ++KmtHrx?=
 =?us-ascii?Q?7DSQsLNJRsMsocAZ7jX+9LZxrlTnMPXZnd1gmj6eFtZAnlWSj3KjO9ouLplk?=
 =?us-ascii?Q?mkZKeRX71LSDLeMKVwndxZJ6O1dUIbNTx7n2ls/TbtANsSzbS7MeirPlD2xN?=
 =?us-ascii?Q?8ddLQSEHDTLsuc+LX5DHregYMawdejdTgNMYRiSxUb+gUVTW0cNtNLI1r+NB?=
 =?us-ascii?Q?/+Y3woO1atGyfJmYszOkzG4g2S6ex00LZln4/2c6MHd2HDJgzq28reR8m1+j?=
 =?us-ascii?Q?G8nB4sPLUUVs3HLPgGUg4GezmFZV669zjgvechftSGuN+aTxTzL2A3Du6DmU?=
 =?us-ascii?Q?VQ551EEHGyUJbXUrAWi9DRMJfEIsY9RN9p7RJwoyH/OQiIepUYxxwCxFtFF1?=
 =?us-ascii?Q?xfIQe1yYOn1oupwvvlt44Mqzc6xJ0LEpGp2SSY9EyZE9yORCJNxpw2CTzqIb?=
 =?us-ascii?Q?o7Xy3TC8WzfLReDsOrWKiiq0YMl0u44Pq5zZmjss3YLlUTtPHnTKuOrUc+dP?=
 =?us-ascii?Q?eYbkh4lmRB4sJpsf/IZsLEZJ8awaBjwS4HPfKRFM+2xCVOOYoUQ/vcC9Bydj?=
 =?us-ascii?Q?Pkh2EMYJbc1p99FSBN5UXBnhMHpxzAY+Mu47aEdVnEowI+MJbJbTfcyL9dUE?=
 =?us-ascii?Q?gxGPtuJG3fa8cArlTwNCUAvioJ1vh8bY5JkFPYQFJR8iOJlUzxh0gwUV466W?=
 =?us-ascii?Q?m/Ed14M+GYIRtz9ZQCBHp5cP0qxf+XCBS6UT07YainOjvKf8ZsnrtlDk3TVr?=
 =?us-ascii?Q?rouXjeR2iMqKw/krL8WYy3MZIfrHeQwonsHUMf6q856vtOlEsu4Q/LN+qKgS?=
 =?us-ascii?Q?aN8xixXIjuunvYptG7xkElLv2DfPQ17u/VG4d8UZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gQ5RSeV9orc/2+XSnhXHJz42W1cV3tI4wbtCRI/dwD3g0mmFzgb5vOJCF6o+agYUtnvV3LYtwE+TxJr6kOCy2AabSb+UAsYOhaWZY4iDQZXSOJsllyLkLGcu6DjoKdnJT0AMmp/6kibAL+1INlyHXaHxMm8f3JsIlG3SXdEZanIn15ErGmDkIt+yIL2EFTKi0rMMu+gcUOG5tu24trMGgIERsJKD52Xf5jWWUrBOOn9qsvmzyvdhgOTN0d9DYFdrOOkpvbeZ4OjFA1et8Kq/UHvcMI1Ss3/2HbYGpds1q5I4kNsGS9Rok2b49ZQ39a726vrhoHjoYQTtAnGa0n3B+sXZskbUp0jfxj387Sq/8RBP5iGzHCu72HNlPTtx0ojomcMtS59BrePAvU1eiwied3FemTogRh5vpQF85+nLSEZiV6cEbLLfeUxRFsyBhaWhD3oZ3HTWxTSreIGUZgsS2YJ3/D7H9vVezUYdFbDRa69PVQzYumgJTs/JWeaEaNd4LBaMeYFVhgyVmcpUdyfAwue+8exIK/X8Jkc305P0JSLORgK33KuER8Mdf3VMTKsK5d3GVTzG3lVbsb0QxPyprBhGHolo4HZpmC4/FEZOrA4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 383e6020-232f-4374-b245-08de174e7f78
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 00:51:45.0995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +SZTW9eaMzIGIyIqGlPvGfbguKJmbbaJo2dcKPw0uKUFuIEsAkzahSGA0lSRTdlh4BcncBvYfoMfYAbcJaG8RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_01,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2510300004
X-Authority-Analysis: v=2.4 cv=NfrrFmD4 c=1 sm=1 tr=0 ts=6902b6a5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gr1hNu0iyh34fsq8LAUA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12123
X-Proofpoint-GUID: AkjoK5JaY8u9BeNcZXlm89M0Zeel0Xrq
X-Proofpoint-ORIG-GUID: AkjoK5JaY8u9BeNcZXlm89M0Zeel0Xrq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDAzOSBTYWx0ZWRfX5SCOQzTYKSD3
 l1tSLAWb5HuL+eLDVfIu9kep5+V1sqD4Sb1jN4P4YqkQGw4pvHcnNJkkq2dR92zf/9TNPoECTjA
 +7B9MHMuOaZ86qzqpsAZlW5d9yx9sEAUjQet8Dg78RlFCveWQ1494tKfXBtBNfDP0n+3qYEH4/k
 twt9Y0PRb5dUzJAegU9Ni0/c6OqTegackV0UYhGAzw6DROMrE9KZ0PsIwM4atNkqSUv+CfIlqoC
 hfUrrTJF1pVYV1VYNTju5/VY4LkOv+90NussGiO+te6uvvC9XulxJKxE59EwlVbqVEop2gKAkjQ
 Y6rNXgcQu9jh7V/hpBtibR24CkoGcvN5dWiHwvKr+FKk+nzKZCylwFTNYkZR8nTjBE1RurECGFp
 SNqp2cr/oOCRyE+1L613XLvYx8JOGVFrLmW37FBUneE3fTXvB1s=
X-Stat-Signature: 43i7rninwuagnx7ofwgxrgpd7i8rq7wx
X-Rspamd-Queue-Id: 17E4218000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761785517-770923
X-HE-Meta: U2FsdGVkX1/CxJ3a0W1Q+Lv/gKUHW1brn3DTnNizI6KCxnSSNj8wNUYTI4zkFnsxplil37WpoguvaAwA4fxo33ScObZL+gVsqI+V5R3c8FWVcn8mH9zpdcTVJzqXFuqc/EfftPGB9HZjHhmXUmRd3U8IHbKwHVQGMc/m4LCRUa5bbH2vicPMlAe1+AzkguK+qCgSpMKLwmRihn15ZxezFk/X96fdvdUfrAAD68cD6prnCztOsppASJVW0+rsDwPUuYhPqbx7kPQ7+BQNCKNOdkGqa+xDNSUKxig4I8NTMsfNhoiEP4OwYbGipT2ODci6Qho5DU4rgJVsvtA6Lnk5Co/6avcWoXXiW/J8Ps+NtxJ57tIbWg9H5QLRYR2eEU2SWQgsqhHrCCgEPmOOwB3HpH5PEC3ySxukasKbCXeOI0m4RiRLL/qBPoN/3OF9aoaOGMDX5wv99OnGShcVCStoUmPP1BUQT4Il/GA6/DVXPOoPevr8SywW5EMLYAhGOlhnPLWQWLlycRSv0fIshM6zNcDLgbUx+gnEM2TnrCJgCdQdQofdIsF5WDLkrFoFSFHTQ7VBrNTZJ8jmvkSxfNxVKvTXZ/a+Dt+sp71sbg0erR8x3Z4vk96fJcyAEUCFgW9uUYSdahfyvp8mn+eRnRwV1e8HSNQpZGRZcw2r602GCDQYy6aWemli6lpK6/hYLqio2aWZ9lYn/OeynM8wNHMIn4aU3VDAtgVRPbYzRExaX1lE4OiH+llyaq1z7SrD423Lcwbx2zdegAlLUqKV32vOe/gFyExT3bq3dRdvKwdy5BEZN/kgn2GLKV2+fyUAK19xUdCgPygeCx0na3jRJPvKXIaN7JfZGJYGEOPZhgvNHTHRpqKFaFyEneef+9QL19MW31g6rlA53inyC92VnEVu8xloq+GLbmdIc38GGpC6gsyKN96WRQ6BllIlXqJhuo9Ub2bC1O/h3XqhfwZcOhy
 KIiofWk/
 ieHOAWS/eunkzgnyTNn0/cDROWUQa/S3B+1QaF3GgxdU2TL3MROmlMWHO0R2L+CQNoUXRk4owUeTTknrxk+oqSXe47PfWpWheKPDfI98mNcOJ9arcGUCcUfJcgy7JRbQDPiVebqeyACyOkvLw2ZDYMg2diTt9ukYeGn8XCoYKhi9xS2O/aeFj99ZpNQg1tm8UxDhWOwk0Lg2D/spzFMKC2pt6OBl6INoysO217H/s3akg7teBzqMeccGY4GbriSKsWv5CL40HgO6EOw1npWtXCXzu6sfLzLWPE7CmuMH5ZhBVny0Q+h6d2HaZxsOa7dNqCOi5jNZlB24v8AJt/ekBGU7RiT1poWgKozJarSNXfBvXMTklpFl1r3u6p+rMUYGirQWt8qkCAv43azwHijRyW+qIXrKnNUXZmZHEJM0EtpT/vC/gx7UbQagQYvL2bFPqErj9AVPkLbCzSN5Lf5ID+hoGbBx0XGxQNnfLuFIP0JcY+LAKkkaiVusx3CL7WSv8i1CsDKVy+tgaIeOENnzXgeOVvdQT0PPCtJzJhlYGUX03TyzirAOlcr/ra0VcuaBvmCMhrUocLddcyO9V8a/hzTE5t+dcRI2XDxXOys9RP67PbIGoWkq8SsiA0f30iA24hSGDZfazitsWBfhY0uhJHtUjYGj/rZIfgTmNYn6ABaKgnFelBvGTn8Vq/5KpuKU8VYBD+iIF+Pm/hJXL/zZGV4w5qBOppewfLFfuZdBOw7byKh3rVzf6NctZMGo6DCgFnPhEWJcYn4b7lZuyQpRkJzjCTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 07:19:29PM +0100, Andrey Ryabinin wrote:
> 
> 
> On 10/27/25 1:28 PM, Harry Yoo wrote:
> 
> >  			slab->obj_exts |= MEMCG_DATA_OBJEXTS;
> >  		slab_set_stride(slab, sizeof(struct slabobj_ext));
> > +	} else if (obj_exts_in_object(s)) {
> > +		unsigned int offset = obj_exts_offset_in_object(s);
> > +
> > +		slab->obj_exts = (unsigned long)slab_address(slab);
> > +		slab->obj_exts += s->red_left_pad;
> > +		slab->obj_exts += obj_exts_offset_in_object(s);
> > +		if (IS_ENABLED(CONFIG_MEMCG))
> > +			slab->obj_exts |= MEMCG_DATA_OBJEXTS;
> > +		slab_set_stride(slab, s->size);
> > +
> > +		for_each_object(addr, s, slab_address(slab), slab->objects) {
> > +			kasan_unpoison_range(addr + offset,
> > +					     sizeof(struct slabobj_ext));
> 
> Is this leftover from previous version? Otherwise I don't get why we unpoison this.

Oh god, yes! Thanks for catching. Will fix in the next version.

> > +			memset(addr + offset, 0, sizeof(struct slabobj_ext));
> > +		}
> >  	}
> >  	metadata_access_disable();
> >  }

-- 
Cheers,
Harry / Hyeonggon

