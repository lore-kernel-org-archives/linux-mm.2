Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4825CCF9E9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 00:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93ABF8000D; Sun, 26 Oct 2025 20:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912CF8000A; Sun, 26 Oct 2025 20:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801018000D; Sun, 26 Oct 2025 20:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE3B8000A
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:24:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E805D13B082
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 00:24:41 +0000 (UTC)
X-FDA: 84041998362.20.706CE6D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7EC891A000D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 00:24:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZPR2Zegs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pYj22ilr;
	spf=pass (imf19.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761524678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMOmnyPgupUuQiwc1mcb8esRpEUcBXM1G9TktTWBrY8=;
	b=DRMefkuNooS/lMNsuSUT1E31m93fe/xrsII/KGpL6bXLXj+J443FsqFRNh/wH0kiNnqhOI
	um9hw+CqPIqkouqBvE7lsSRAj05b6Vzd+1drh53CiaGBZromZfoxIgw4TCMu2dMn6vumj+
	ZlpFwyOgubag4aEhT2XK75t8iPEmrqA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZPR2Zegs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pYj22ilr;
	spf=pass (imf19.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761524678; a=rsa-sha256;
	cv=pass;
	b=TxiWLrLVKR3CRFy4P9zBBCokfSFrTlj4YTsk8rup2dv3H0eYZFH2nR0wYhCSwpysSvevd6
	y2vnG3y3uxGDJfYopA8XTZSeoWWwAPU6jaEMG5gqvYWZxTeOwqR7CrzKVel0sV5ijOlna7
	jskl5JCzXvcpB0JwK7TrvNi8wlnv4W8=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59QLXH6r001790;
	Mon, 27 Oct 2025 00:24:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yMOmnyPgupUuQiwc1m
	cb8esRpEUcBXM1G9TktTWBrY8=; b=ZPR2ZegsyEMfoRla8J7PaIdPUK5EwSm02o
	BefPMyETjGoVsaVwFt08RYmbXk23fu4yOGDb1E3Wog1+tfFlJdvrBxgk9f7Z9plH
	64sq4zSWPBRIQUr/0Di5rPHgGAJIGtxiHmMxcGWJAo2hAuf7NIvXq38fJ9b2Qezo
	8HMNLq9OYc4OAhL2sggjO/y83UT880v3EObQRDDFbnz/n7A7KZAMpl4jiJ99kEUn
	rutINo1HF7F1y6bU7b6FWG6gyX6hZxYmT56v6kwT+hiliDpx7mJTXy6OyAotUgyl
	0cLQbJS887qQILkEM9Z96cj2+eRrlcw1P+zKXH1goGV4DglZykag==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a0q3s243u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 00:24:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59QKMYdw024513;
	Mon, 27 Oct 2025 00:24:31 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012053.outbound.protection.outlook.com [52.101.53.53])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n06dqgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 00:24:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFvcQsg7lIYDTOgRzy9+Psx44y9nOShMPeIaUrbKQeg/U3OFazFSnLKCFpVd+WWIaKgS9RiNxAtNXrPKEqifN6x1wB/f1Gv3OuiCPMUg3zsd4Y26tu6ZjJdtOIz5xzJ0OtyTEpRxfRwn/4eCCXYwejTjxupFYzpo9YrgAhqr3rXw6FjNjd/hf60fYUFjYnIwy5CiVuW/uqPUMl+VSGEcRijSXeXya0YxQ2+94O9nEKFvReYjabqQiCW84IZ7htZdRRAuJxA3sfD0h0lfk8+1cfwzOLZI9XaHSSehMLF4g95RRo3YUkpWu1KdHEXYgaQwloHW+SN+0ulXRyQhWOSc5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMOmnyPgupUuQiwc1mcb8esRpEUcBXM1G9TktTWBrY8=;
 b=uM79Pcp0zt5y111VO+a/lpJ57QmcKsJ2xSTH/GaN7sODaHJEa1vxt/3RBzl8pfQIe3hjn1mZKjoDnmU/poMsepS5YYliKntI+aUrzWR4AEXk7MsoyUOswgYMrDrGS8BpgoK+dJbO03ZtJSJQZ63qBHOQeQ0kbhXL1nY13JWqUhx0FtBSJu/gfKiS7vTL/yTxfoviqVPqe+FJfXag0HSiTiNQ0cm7H7ir1zvpmznt1g0XPKb+43V7qYa4MVnW4grjG7ONWfZo6Wx4rVlJs6w1DQd024JBoVDBUo4mnnl1hQTzat02+PHhI5OcinKaKhBcjpucpfJBuFZshoYX5+6tcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMOmnyPgupUuQiwc1mcb8esRpEUcBXM1G9TktTWBrY8=;
 b=pYj22ilrMkmBEXrQmdJ976wKmntonjEmAXtPMJu1D0k6WzmPllsCz7sUhqz38EDgomSSflB2Hr3Wi8YWScB3BRNIN0mSzI0TwBCHt2Lv8vkv4gbn90OopGobXgvKdySe9pOoogGQHqQTlUxlVpvhB4dCAmEliS+WwjC5YLW725w=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA1PR10MB7791.namprd10.prod.outlook.com (2603:10b6:806:3a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 00:24:28 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 00:24:28 +0000
Date: Mon, 27 Oct 2025 09:24:17 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH RFC 05/19] slab: add sheaves to most caches
Message-ID: <aP67sQ2dD73iXubl@hyeyoo>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-5-6ffa2c9941c0@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023-sheaves-for-all-v1-5-6ffa2c9941c0@suse.cz>
X-ClientProxiedBy: SL2P216CA0162.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1b::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA1PR10MB7791:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a32a097-ef42-407e-f2ea-08de14ef306e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EGhHL2GLr3lNMbWZ07uryh/tXCY+ecfSZ/rqA2Ol7wBBo1vekMYFEHTAxwfa?=
 =?us-ascii?Q?pUKz/12V3Hm4OsUBGUJxtOT0JT2QUkjZSvKrTd/I0rdNmoeTFnXm+3+4Fz9p?=
 =?us-ascii?Q?M9f8Z0Ce989K1ZYgCu62zFauOwz/EY6fdmETSklFJytxQsq+fzq1V45FyH0z?=
 =?us-ascii?Q?4GMoyvHXFQFa7FtLZpV2oQaIaVsy87EcjsWI7OrqboBlpuLSMLExe+6pqJv7?=
 =?us-ascii?Q?WVjEoPeeDNqWMQMekYlKq6AUEASzzrwX2P9RegyjII8NG42bxiW/7FfHH+rv?=
 =?us-ascii?Q?lzn2B+BcUGUE5fYqh33opEXMgrLvZI55pGQP6zebUWBH7O6+ous0NoMqe4Lu?=
 =?us-ascii?Q?einToq26dwICoF7R6+PxBMlErgYwTRSensJftqnZVvCKL2v/Htbvsi0sP8jJ?=
 =?us-ascii?Q?xVCJX+phHsO80mV+C1ek1Zz2dVUYSLGXQX1W+Uv0aZMTEs6I0oC8rhmHR/ry?=
 =?us-ascii?Q?f4IrOVSGqDF+ilDwy8t8x80yzWTCntD2oDhxgGtFmrn3vZVgTXygQ0yxUHGQ?=
 =?us-ascii?Q?V/UE2wUEDdQbpwNhkpOeJ/F5yhMKX3GxyvlK9MqXb5ut3kuJYoD02Rg1q1Yx?=
 =?us-ascii?Q?dxPQGqgUtR/LK8WJOatyexypEMKvXKLSft8BMu/Hp+tzM4dXsHpqghI+DsZ+?=
 =?us-ascii?Q?RqVKl8wR/j9dVqCmEpiOQVfJKQAAc9RR+4w7Bt6zYGO+zsY+bhar4A7k302P?=
 =?us-ascii?Q?OSbIAE0uM0wLwknQoZhOS6BM/ryWBdhzSQviDXv6QLmRJz2cJZ3tn1bOucb0?=
 =?us-ascii?Q?aMpKjgUJmxvlvcVPhABGWbreQQEEy9EwHWGvnCtco4AAvhdyaCWTUH6FAEF9?=
 =?us-ascii?Q?JGaFNYBQRhQvgndwA+DnzMzCfkGQpw/N5yIOCcsB2BtljSDe9Dx+sd6L1J4K?=
 =?us-ascii?Q?LDQ9prNT/tbCJIArcoSRJ5E11TofhWVSVL6cX6wbngNXbmxVsERK1hBhTsQl?=
 =?us-ascii?Q?lrpMclTiaShPMvv7VuV8Id7TXjM0Do8Nf/rcuA0Agp+7iupigYBb1f96f2fo?=
 =?us-ascii?Q?1BXGtuXam/11kS+kJXen+dgcpCXudeAbC6VqZYAjf3S3P99RWv1jj4Zj7eha?=
 =?us-ascii?Q?OG85H58SWmU240t4ux9EeJoGlqVEqJlEypR7tMeTctQsGhbtEOgs+OqDsZFc?=
 =?us-ascii?Q?RrzFO8S6EG/gRCePgnYyOwOSSo0csq1IXVnT75wDIYeCesF6HsRkN+JT6C8O?=
 =?us-ascii?Q?xXb0jfAnE1PLUaadOzep2Ow8C4RZFLSwBPXh8NxI8LlkqVdPuxJGjjiMQ8iT?=
 =?us-ascii?Q?8fGLAUTX4V8b5y+DSSxLvuG21R8ZkXWzljvoybgZulPZyrIEjsonn/E4xHhU?=
 =?us-ascii?Q?uFecTgxp1hzTMOz1iVGpEBxOwtnLSg2ph0qOdPspH2SipbKnTTGCFozOUcOQ?=
 =?us-ascii?Q?JJVBmUbHb3Zm2e3LCR7xl7PUaKp69iHX0d1hlNnVjnxMcehG8RymSI2qsRkq?=
 =?us-ascii?Q?aFHnLcfbaArFrh9Q4eiOunSbscLQmcVP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iKdgsRFJy2F6U/n9kUGJkGz2oVpUK9bwxqrwcnjn7P0XyS6/OaVdj54qSbno?=
 =?us-ascii?Q?jRTLIoHCFc1hQnzMpd+Fv85jY5S1uqddHMEwzG8ebP5xpBdgJqWsLP9gnlWz?=
 =?us-ascii?Q?qnQUWbcZKZcXU/f+IKjfffe7Y0w9CfLCTOFgqgjVgMhztXl2PBuki0g2mguD?=
 =?us-ascii?Q?F44AmoAiCtI4fs5uvk4uqzD0kU4rylsMFIh68Ia3sBFwvKXt3fETYo7p6LRC?=
 =?us-ascii?Q?P26LQeewVBUkKMyTljTS5zZ6VchPGhNDrH+T4OX9gDhVDae77ARPpfZDElCq?=
 =?us-ascii?Q?/eCt9clBQNv5O2ze7LawPNfHROcchdmIXDz7l2UvlTAqQUfvjoMs+fGkNsDj?=
 =?us-ascii?Q?OokLvTNNY5IKne5MR9iS1h1wWE4KGtxI289nNA3JXsCp33BZP6B9O7i99icK?=
 =?us-ascii?Q?bgO+3asercdBzxOu3bST6QJH0gd/2RuQ2iwb1JXAOodJog0ilIeD/b1uReVp?=
 =?us-ascii?Q?aO4VJqtB9ds/ej7skcBv2FsYgg/cKrHv+uz0mZeJJhLuPcFoN4EHCJ9J6Do/?=
 =?us-ascii?Q?IsPt8rr+mkk6HF+hx4t95LPvuEJ0/1Wu2Gqy9p2NlBqhSR5wXxbd4Mww005P?=
 =?us-ascii?Q?0WcwKxnm8wOZzt6R7BumjenxgNVJpekk9swPGClQFb6MW4Pkpwy6vnrP/Wrp?=
 =?us-ascii?Q?4ceSCVOqQc/5g9USgnu1jvXnbquMySVOE8qWSK51scqg540MxvsEFAKGSfY1?=
 =?us-ascii?Q?vADJNU01qwLlGXg/Z+/V5GZyb+XcTZmWkVtcG1ddJKB0QwEf8jGkjhxCaIHR?=
 =?us-ascii?Q?nfhHcnZxyamU8+d2Tr8QjfMobUUcC0okcGDQ2acnDcVIWG6EiPCpWwnvqZVH?=
 =?us-ascii?Q?rcnXCeulOmSULJfYTbPNuIT27VM2IY0ok0IEIvbATedJymTHqJGqGSmZ3uba?=
 =?us-ascii?Q?wRGrl0eW8znXUlGQLK3C5EhtlGJRQpeag4fTuAq7/VB4j7/N6w7gdnIo0e+e?=
 =?us-ascii?Q?lRmZf2DzGWT6SfQAyPuOvRkocqS/JpenYfTFaHK1PaA6qwaxsxqCs7Xdq+6T?=
 =?us-ascii?Q?TNwBH1bOAcJtdSnBIEqkjQUjT+BJdxZtwiXMNLbxG2eEMCK3ThsHArHJrhr2?=
 =?us-ascii?Q?ywiUEZBaUjpFgNa/TwI4FpDnWdReaG1EnXdupKqESFvB2l1ejCqWMfux/upc?=
 =?us-ascii?Q?X2lOe6VnTHgIz1Ok9OqnwxQQ8D3GUmHxXDpp/LOcJLWiiIgCCwYb85KuOzxx?=
 =?us-ascii?Q?RcHIpcRyZ5U/Uw4G45JiU+WFOZbP/rgsgjPWD4WLniFLetLiDO3hLN0h2mYB?=
 =?us-ascii?Q?SPMD32AsNn08YlpyMf5iBq5mrnLAFKzoR/PEE0YKwONA+I3RL74XChQ0JZFp?=
 =?us-ascii?Q?1JfjMvRiE9ogqRR+4D30QrW0DqgOB1n/G0ni/JLS0I+nCGCyEUytV7648KzZ?=
 =?us-ascii?Q?HKG2cyfOhovvQffunOK+hWAaKNqDQpHaw+BQgijJQhUHQsIzKOfcU7sNrYHl?=
 =?us-ascii?Q?9aVAKSLu3uV+rzrUNLg/GYqiMFOqiYV6TgpT7YwpFe2HXA1kkCKDzgfQHXmu?=
 =?us-ascii?Q?c/QyvDOXaVSF3xbv/LOZ1prIi4ltsPG2UhA3ZsAf5eOtTspOylJ1oBNDhEN2?=
 =?us-ascii?Q?QzgspX4A4jdqbscrTbRn6oyl2nF/lK0soL+Wtx8N?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GlkUPw63N8V2ajxuwLmjtzhe9L+jQOojgPNsyCV5CJdYvsrr10Ur0dNUtOOsLhmwXdaytxM+cceOeJdBlSKfHWeuuIRJk3/PO2ybIjlup0WpMRTvUjf6pCJL/tc68P0U0oijIEeoSXrrRvYvP1SYTsN/+WV1qAwDFkRRvPsyQ6W6Z1mqiIwIWZ2VlYOImUANtB0vWqpCLYD/qMkpB+h7otdox8cAwqb6AGi7eHQ8j1A47nuwWkxM5Lnu8SuB3vCghCnnfGLJDvTliqr9eCsUm5wrB5L8XAlS1Eh4Vx4Zi9UZ5wVxYgxSE9idRh8Gwm3ONFaq6T48LRHkJA14bSk+vnTpJcvNCXpDLEekk2qzIweDXsoUoHtDAhKQPOCzdWtphzCr+USQCjo7XdT8ThJ9FiMLgbvkmrGmouILcYXPa1c7cy9ITMaA8cEc9Xb9yEMWc+W2EgfVPSt8wGbOarnQFCQj+wxF0KxKxbV1aN2ARYbfTvcy+G+uABMdsU/Qmkl8i5g8X6nce33CVUuwaycKtFJKZ/rnZigvhz3VD5C8c9Isaqb0IdtuBzY6sduYrXV1hpcXJYYFjrO/FT/qBUGWGqLXdyBf+80Noa31KyQWl1E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a32a097-ef42-407e-f2ea-08de14ef306e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 00:24:27.9526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hXBuN9iy9kP/eH940O5St2Ixxl0rlu7rWQZWkbkrYjzqLbxBmnoZZvz5CbICWdMVXwN8J8No5FK01f6XaVMDjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7791
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-26_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=949 adultscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510270002
X-Proofpoint-ORIG-GUID: QxfXJXUNKosmRNKdN067Lks3EmERh4P1
X-Proofpoint-GUID: QxfXJXUNKosmRNKdN067Lks3EmERh4P1
X-Authority-Analysis: v=2.4 cv=Q57fIo2a c=1 sm=1 tr=0 ts=68febbc0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=QznUpgGXYvFiLFJPiAMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAzMSBTYWx0ZWRfX3OurhPlKV8Hb
 kbOZW7eaWuzLijNHzr96s6WFLXAAP4W6lYJEXtPazo4cjDmoyeZx5nWTdePRLCWz5Y+ly3JCPiO
 zHbgztTXVrJ9LSDmv/sypcctqLk1FXo3RBjrwBlGmDCmR6Ld7tdu4a/XpSUZeseoyncFNJ0wVFn
 /ejCCdHXJvo5roZwDoJeaaUT0yEeY+Hc+fwsfbjZsR1TUVvyc6xaV/BtHVeFYOiic+y5CuzqDSU
 cDgUh3cJtOdl7peWQlNFuSftBXpqxQyFnAQhDuh6YJ+otLFQ1i80JM6l96vZu6U1L0QE2x55DjS
 CVG20xebHw/FDbohdN5ZJ60X7SIMb7fkR6c0nqf7MhFgQZBnZQC4HPi8epZF8QxKudqg6U13K1i
 c1CauovreC9CXw6osZA9cc9Owt3YkA==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7EC891A000D
X-Stat-Signature: udfnx9jsub5z4ndx7b1x5phb4awc35y7
X-Rspam-User: 
X-HE-Tag: 1761524678-467659
X-HE-Meta: U2FsdGVkX19whEAHYqcJrs/vIeLXXgCotUvCZeKmPLfITh+6JKf7tpwDx+9jnxogZ69mu0yaxxO7hBmp7wV7u8pRQhSkh4kmpztJP3wv+swEVh2qopX7KU408yKIM9xw+Yo1l+o2/Y/dDN2BgUnIAARqrXx4eB4K50XVPywGA+rdi5UfAfACkeqsMWsl7E8hlecuRPwvPZWHU4ExjjWNkR5fSjJPSF+jpfPQiKHv/sUUwlOj/b7CxNkes4/AVmgrnfvsg9ALCYsmzZTT/RLLu+nyzFKy2qg7fGloERLUfxpKvaXSrLT5DJPCkhKU7lIe1zCVACwYZJYyxdD8m0+YWolU7vJMlB4Aa45sDSIbhX6Tkan8pJMkoHrWQFnkjpkiVz67Ntb2ykeo5S+U2M6do6rWUh6X62/ArIqnmnbtN2U9/XSsXwxZmxNIrmePL+HOE7XrLjkwfDoSwrUFj4t6deryTM2M6GrTQzTg7KKwc0576GG2zYLJNr8v+pF5ObJew/Tn6ft9ZVqL13yELB6KRdnqW45RNWGoYUegCtJ6DgES+9DfY9KthuV6iJhxycFKQUfLecvfKi6URPVIF34WBwqyuCN4qk+v79TlSU/O8qZ+85ADXHV+DbT445h6K94DvQgsPdXZ23zb1UXdz8E760SNbUSWvSRam45owAgxozcqrvZAJCm9cm/84C6VsDhyTaj9tXD8JQ7UylMU2y8rFGHm++IaGwiwFCdPha0bS8qSBcujRAO6nQNsAasrW5xXq+5MdrK3g55LZq/qW2JqbL15yEN3jFDPv8y4Mi5F44CmX9eF488EU00DQHbeS7wHHGEwln+s+ZnbZp8kURoP0pyuMnk8Oiv2uPpaYe3Aoh84fidjgAbpMfkx5DteYFBiyR1I4bFjTxf6bVa0azJzxZAgexAxlqJeSNluR2PaRRGLjema+K74H8k95Czp3sUd2gM+f9xRgcNxTsTs6Vg
 ec4u7jqA
 NhfpBQjrRaKrTfHLStdH3cxokJCJGbEU2cNV75jl3YTvKCsqSJHwOMrXthwFUIDiZZFfUHnUQciiViGxLnthVJZCqTvOHsCn3Z3zW/F7XFPZVeJ2ssUyKtUleg7CXK/5FX08M6bZpZS2c7MK9PG45qH9z17xOjVVtxtEUB8+sif/pQ8JNRyRLmAwHAfUJU/glHw8X0fjpIgSeklkZk/N8JZgvHvcNLAjfxT43/+TY3/+6ZLMQSUZHmV6npJ0PYymK4GN6DL2Rbz3YHhHfm7Agg4uIr3A7DFv1pttmnkA9+KHzhTRA+F3hDm1ppwQ7jQpBG9Gv/R8JwKYYwUfcMI0+f1jz0/Imzv6PZKuq36Y25GRvb+q7muENimmXubTd5rJxbFXMluWLJxbjV450LwfQIwjh3sf7QqPk/Rlg4UMpKLjq3+BTIyt/AekfkV6uQuHhpXIF6FOTvdlDgm2fXxPacKh78bNWRz7btlbjITYETGgPsLX3Fu2hOWYyFvKiINFm7wjJDvS3QJer0mes0Qcayl1ssykOziLqHZhR8IlX20oczkKWjNk5EXBP6KQafZzws4EcHOQXx9r2F1z75q36HGLtGV7xh/eBZvMxcUsBuI+lvFj6AGF04LnJ0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 03:52:27PM +0200, Vlastimil Babka wrote:
> In the first step to replace cpu (partial) slabs with sheaves, enable
> sheaves for almost all caches. Treat args->sheaf_capacity as a minimum,
> and calculate sheaf capacity with a formula that roughly follows the
> formula for number of objects in cpu partial slabs in set_cpu_partial().

Should we scale sheaf capacity not only based on object size but also
on the number of CPUs, like calculate_order() does?

> This should achieve roughly similar contention on the barn spin lock as
> there's currently for node list_lock without sheaves, to make
> benchmarking results comparable. It can be further tuned later.
> 
> Don't enable sheaves for kmalloc caches yet, as that needs further
> changes to bootstraping.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

-- 
Cheers,
Harry / Hyeonggon

