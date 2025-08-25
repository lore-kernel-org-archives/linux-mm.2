Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C95CA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 05:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22FB66B008C; Mon, 25 Aug 2025 01:22:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0BA6B0095; Mon, 25 Aug 2025 01:22:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8EE6B0096; Mon, 25 Aug 2025 01:22:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E87586B008C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 01:22:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4803B160202
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:22:30 +0000 (UTC)
X-FDA: 83814134460.23.81E5FB6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id CB1AD40008
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:22:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FAZETVFz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="bES/biKw";
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756099347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swbXPLwrMSf/wxmfJQh4EYM0VYT6WADx+zAVnLSOnw0=;
	b=QVJ4GwvsCJLUKxNY5wIWY/VFz4RepN4c9J18YVzfBeX1ne11nMmUqoD0Xuv4gYOfGlvod7
	sEztcvn3GdjVm5ISSYlZn2U+S2w1r8YW9wlaJWS0SjdhOs+z0VdpeFACwNa+pHN8ssWfq0
	jaXvC4ZSgfB4+/xQ7MxSt5/16LbyQNY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FAZETVFz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="bES/biKw";
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756099347; a=rsa-sha256;
	cv=pass;
	b=Tl2jjZL9tsPVTxWKkdicEejEa/kEmhfhvwpVcSHgoysv+xRkBzVasAtipeiEOx32QVfQy5
	wf+AzHZGkY0W3vy6ykHpnj45hC8Nw3TLk2UAPrIkR/E1t2YvUQTTmJSHxs1ctwl7Ih5cew
	p+0ZYJ4hdjo2EDwq7JiCX+zr2JxQLnQ=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57P5Cev2000598;
	Mon, 25 Aug 2025 05:22:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=swbXPLwrMSf/wxmfJQ
	h4EYM0VYT6WADx+zAVnLSOnw0=; b=FAZETVFzMeTgNZ51jejtmUnKVnsLRLbLWS
	f1ydMQmXS5oEK+qvGWk/GaxVS9Fn7t8UVbPVl7rHdVfq7y26XciyqO8qP2G2OuD2
	8FJd3OaDdH3Y/p+thIGFoF26L/PMJ6unZPMeZNpihxc0WoHnuTyA8UVEv3UWqwCg
	nGJk68m1SVkr5dzW1/HihyuWeJndPzlTFCC3GyKYjaGfAMvDeg6OfPd9I/zXsOoV
	kll63tsPgkgks1ioFpyW4NC2om0+A0UR8I/KxNNC1hBNryqQTunJOyL3JG29hu82
	/JGHnoU1ydDMSGcMtvnDCwYDilhSwat7FB1M7865u87rbsufJDDw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4jahg9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 05:22:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57P3f0Ws014695;
	Mon, 25 Aug 2025 05:22:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q437r8gn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 05:22:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FDha/Ow5Rn648zxMd5QfyaJTTvCR9CEbCryCzFPbKlkgIXSugYaVnFpHZHuhwSgOY2VCRAOQbZt6A6SJXSftUS/NR8E3/7TGtC2MY3x2CLBSK26SU9F8yXnFntg5XhpEQNk442jv45lt2mHBk3lZtkvJGXVIq8OACJh8HN5MnwWWR8Lj1f+PoabJpaaMzskO3QVyX2YaEKsflwj3WJgGLnHC5w+tKuMZ7QzLfAPgwkJ3OwLlMoHUIafucyUfaOEplC1MAqk3gVnSQIot/S0VTM/u0d/Ez4zzy/gAeDVE5v5Ml/GQQosU4/WGPSjPqex0X9F0FLM5C8keeT4+qWShTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=swbXPLwrMSf/wxmfJQh4EYM0VYT6WADx+zAVnLSOnw0=;
 b=ynfcby4nrtNii+7ypl8JHax8SHo0dxJC3pKfmDg5N66R2588g/VWQJPZctVlP3MzO+kirTLCWDRY40HER15stqJ9Cx0eT7/XJ+4YfyqdxmH9uroSdqHFQrzp31u4DYhp2x2fh56htzLpovi4aEUq2GyzmO18X1GUwmqRUephqskf8Adv6Re3cElkTqckWARHtzPjaFySgZXuHiflSXC9zazAe1vP4WSBw1w8nlAupYZYBLl11agnNNZY47toR2JK8ypSGdMt1RHIRgyauqwS4zg6OprDRjYQpm9QbtrdoGzUFbXw28tAOMxVxC8jGz+jDZtssb2aC22TvkwXXE5x0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swbXPLwrMSf/wxmfJQh4EYM0VYT6WADx+zAVnLSOnw0=;
 b=bES/biKwSZHrZIpMSHh/rd1YTkAS0GwvIigNw9kEiDa5fL8jcHqkyqta1ClIEcyCjScTPx+QQUvJfanxLkH4OtdlSjlpCgx9jp52ehQ6OmJ0eG/tFeK2/TD0ImaZVMthhRW0K2zQZbDqTwwDSsZwZEc/bFtouYFwfpyrhpfD0s4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA4PR10MB8541.namprd10.prod.outlook.com (2603:10b6:208:56b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Mon, 25 Aug
 2025 05:22:18 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 05:22:18 +0000
Date: Mon, 25 Aug 2025 14:22:10 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH v5 09/14] mm, slub: skip percpu sheaves for remote object
 freeing
Message-ID: <aKvzAvgwUyZN5GC6@hyeyoo>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-9-b792cd830f5d@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723-slub-percpu-caches-v5-9-b792cd830f5d@suse.cz>
X-ClientProxiedBy: SL2P216CA0108.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:3::23) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA4PR10MB8541:EE_
X-MS-Office365-Filtering-Correlation-Id: 727d734b-8ac3-4e6f-4cc5-08dde3975c50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Vtk7Y0zw/CwjMJc7eqCXCXoLHZpIPbsVMqQIk5H8tzjMubIQVeBqv3JfiDMf?=
 =?us-ascii?Q?JT+TY4JdVWsM3qJ+nK2xedwl9fJJzFN7BWY0b5gxgySQeZOhhzcMHqZjQXeh?=
 =?us-ascii?Q?fa6plQgt5+xF964jLKFFUQIZkLuzsNXK5onkZmTDMJy/fn/llzoMRbKn0ix7?=
 =?us-ascii?Q?+SIXJEZEpLt0H4hlQ1zGLn7bgtlO23r7vIkh74OT3wYENYkY2JgbYlKzyj/Q?=
 =?us-ascii?Q?XdEhELQFj7LQXzBwr18mwvHwgWO6FWZ1xNwJrF3M8vlPjbFSdHxMmAE3Fbl/?=
 =?us-ascii?Q?7rCZxGVHSzP82HhK8yy3+NcNxZ/7KVJP0cjVZ/X9ssP8dv6l+Tw0k2Dx6dXF?=
 =?us-ascii?Q?IsJ1FMHYMDQenI216CUU+4bOpJq94ZTCixMTwgNakBqca8cuwT1uPDk+TsQg?=
 =?us-ascii?Q?AMzsl6BOu5iAJOCs8+xhuB1l1Hq0363FOlbJmy3XplGJb0Atv5bpCOX7Gikq?=
 =?us-ascii?Q?9q4Xhxtlz7xbj0B7hafyxzVl7RVSCQnc9aHdWTqbTK+WPPBpFgl7AVbL7noG?=
 =?us-ascii?Q?1IB9n5AxFOwN3r5GbAHP58JKtbTNoOSePk/l9qYMrYlEaJBIHtuIq9VdaCu2?=
 =?us-ascii?Q?ixRE0veHN2tsYqmxD66HkypYVlGzo1TgCroQmB3/Xmk1R2j8RB6kScxg9UBn?=
 =?us-ascii?Q?Qtl8xuqCA1gXzG1FC38NHIGwd26VawexE74mLbCx8GOfvGH6n/5Wuzn49d1/?=
 =?us-ascii?Q?ordY3azTuDZbjbOK0ZhIGpVYKLVufaQfSyBCUvOBsHtlGjy5SBTao3Ahj4q0?=
 =?us-ascii?Q?k3C5bzP+v/oyWSSPmv6OdDHv5CtTvs4j6kiv4pIF/z2LOJnTfE5jHZ7/h46E?=
 =?us-ascii?Q?gVgDmHTcd/Lf3korql3s/R1eRaK5SvuiUF/3RN7Zwct1dZAA5ZBLq303fvQ3?=
 =?us-ascii?Q?ZuoS4CqMGYjLLC/bNVhMh/svlJ+xJJCA8EMj5CYMI4Wy6tyoyo14bR8L2hsb?=
 =?us-ascii?Q?7A9l30Q9bvGyMU3754GajYWULr1+BCOhTBFoKHFizK7c4nfMpVLb8Mjhbk8E?=
 =?us-ascii?Q?OBf66/ZEH+S9+0ffYu9ahBEVWKv2mRaKHfFSW5mx9q5tUNffBO3OuZSbqJtA?=
 =?us-ascii?Q?WclHLwiUu4c5dPDbawlWAbhWmNOAgihN9LBxsoMLsPN/D7xJtonpi7QFnRGo?=
 =?us-ascii?Q?lBT4oKlwYcX2qsstZ2sWsm1nPJnkyiqylv9k4Udn62Q9ypUCUwPKzsAoiunS?=
 =?us-ascii?Q?upAy3HbqfLC5lwO8NGf9AgaNmj+9IhCOjc02htpgkAGSrRzVYxy7GUwXm1Gu?=
 =?us-ascii?Q?HiSxMA+iyzK8FOBESEvtEE6aJm7S8zM1bQ7X0G0ajhEewEVgiGoXAmtoCa7Y?=
 =?us-ascii?Q?WfYpoR1TiqulMwfJVGwfTkke3H74tvzNoCL1rRUxUSWnfkrj3cv/1zNlg0J/?=
 =?us-ascii?Q?UtS5vxgQCq2lTvDuOGSJK4lo/+4TVdpnJpywdmjVZrFOUY6oQTJCHqfXq8jU?=
 =?us-ascii?Q?pFhLESqcccU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?71hfAwR35wSG+2AgpAsgfW/yitkx2Se2Qf6Oqh1CGy2XAEhCX+OQVMfjFUEh?=
 =?us-ascii?Q?NYyXs8cSJ/xlgE/UpMQgF8oMaMVJJoWk9UftyWkYG6QlMB0zt6dmBWO6fi6Z?=
 =?us-ascii?Q?9wzeneY1z3npf9bs9Gqvs6QAbjSu0iuOYczasNXPGV131nNdpb/mYnligq+9?=
 =?us-ascii?Q?jonL59UBLfIxH59WNWX+VGuGH9ewrosEWXr2EWfO6S411W5gmWoUr87Mrxmm?=
 =?us-ascii?Q?WFnpPCz88fsoz/leE3K77LBYs2b3p88OVE2D2H3Tkkxc+MRjrvjrJtKzJBlg?=
 =?us-ascii?Q?CAjvmPaF6QH2p8pZye/bGvnDOurqEkrWa2SteykF+cwe3ZeOIVbdGucwR8Hj?=
 =?us-ascii?Q?VYJ0Yo8ppVkU/8/M3gZt0/uB7nI7nJr9ooIWpkYZA2rxSs9zW6ryuM+mDQt1?=
 =?us-ascii?Q?wDCDULVBnS5H5lcXuHPNQEKPeVdN668e+hhiL/gnOkpmNNjFyBUZVlkYA1ik?=
 =?us-ascii?Q?+XyKH2/tNu79NCSuoYyQRAo11p04owZ+R1qGBKY6SwQEQC6egS0d1O48WgiF?=
 =?us-ascii?Q?ZeRQQEtU1H8UB0Wxx5RT4/0gVJxQzcfFPOZECGYbwIbSfy1XkSh4i6FvMhoR?=
 =?us-ascii?Q?1EfYnGKUsrYi25bPk2kK89nrl5CUd3gnT7oTseN1PXicLXbBqMSEuqS4E0W1?=
 =?us-ascii?Q?Zw35dz77p998kxJWwQ5P7vT6XqKesztROW8GPK38vrV+r09jDF8/pOx2flaf?=
 =?us-ascii?Q?azR8tUDZamBYBjbaL98f0peoayltimYaNIAMN0M1QKt1GEXoQa/QhvOLOJcd?=
 =?us-ascii?Q?95aqBkCgtD30CKbpmuDKHoBY1FBQ4uapDJmf0Uh/MXO2xJp6Fj62R4KrYKrY?=
 =?us-ascii?Q?dk9SIownATPJSrlzvkawT/JQkFYBYFadaDKNTHZNPBRbDi6F4skIq4cugFXv?=
 =?us-ascii?Q?/rnsIvS5fW9/KI8ptbT9EFhdOunBxlGq+/JeYDzImxr62oZm40uXyMCxmmqX?=
 =?us-ascii?Q?VnQIILYxrO1MBorM5xI4EHpYJQgQbQe1E3cuBpn/U2ZPxrV0snDCjlyjK6Qf?=
 =?us-ascii?Q?rna/NNP0gfPI1WMvJ6JLSySJWI+jZ9+SYdwyl/46bquujuTd4INloCG3vDdw?=
 =?us-ascii?Q?XTo+yBanmSXMTAdjihHqj6cjAlB7Q95ccVviub1oXn9PcYWuNxx5Jr50Xzyc?=
 =?us-ascii?Q?Gmj8XPaseQ7+OMgHSS4oowV4meoiC0fdvOO2mjyTgIR5YomJOX896plk8R3Y?=
 =?us-ascii?Q?9BSiFeWK/aepiCjrcZj+ukX598kmt4pIssP4gPOKbTxBie4lJKq19UytbPdt?=
 =?us-ascii?Q?aYiV1VWkHHVSett3jcYP+wlsPqwUPRv7l1BmnvQcLAB0LrVZYlkpIS911lI+?=
 =?us-ascii?Q?T1+HUlF5G/egQj6Qi7C3TMeIY1Ot1qHoy7o2mwa0DSv1OMmTU5VPgT+m0RED?=
 =?us-ascii?Q?+M58HL1NRyLEBuknQvYiCv07o3uhSAtUqidgGhZiGq0NsSXCd/uHjKUjIV7p?=
 =?us-ascii?Q?ZhDAjizF83hZzXmpo4/N2GGU2ZZnAwo4dCLPio34W11TMxPMa2GFgVUg0hZE?=
 =?us-ascii?Q?rPkqsodaQpDG463rm2KjYFPp9ef+fvGXeI7XX8Gz7SwujKsYEghMyHG5zYJD?=
 =?us-ascii?Q?1+E+wvV0TgqkTbzcZ5yn/6Eaa0PJJM8op68dve3f?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MxDHfFHldYDlI9gvKnTbYg9aoMbKa6u6xObzlVQi5dp64B7jDrb+r0llq/WTWmaM4nWOSn4QmQT9y26gjzvwBDATw9JeXWUQrRxJCusKYZGp7LOIiV2TONZnWOhUFS2XKPKDjakUFuZelw9MwVYu3DZRp0fwUsAd/HcbUIVrEaK3vsjPI9pyiPT3ag7gw8ld3kMZXBX7FXu0cni6Kdf22Unf53HT+LurNvW1WCuY+aKBT1RY/9CjaRlb2oguhho7Yg0Uz8zWqXMPFK5j0NGSyOi3tRi2YDtAg/MUIVKrJwUCTDvifyHjevedimJ+rF2aamYNKrOTEmzsI/ugMpw3FFLRpzpHRCJ7U+uXg7I02vg14g3lRuK/wDUTsknRJ6+X8sKbIBiLEQlkbIucKd9MoBE3FkEhx869b4ORWKEAK1JsdVUZcjMoOC1CfLH6wkwh2h3BQInjMGrVEsobO1qHff45mIKCM9eus2wT6WfesImbA6AC6BLjkqo9GQWti6Ywhluqv6FgOPLMPBWCLgN2Z7oBoJR+wST1gWgMcdAGC6kfdHlW5C1erOzb2a9acFAYhHvQFdGuVf7n3qo2f1a6iRaRMvEapxH9NBoI1RLDOHM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 727d734b-8ac3-4e6f-4cc5-08dde3975c50
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 05:22:18.7209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xHZIkGDerpbqV/3Vd4Oeg7tYs1G2u6c8U3qTvbQ/NY02Gx4rPvp8eXO0eakuJaMAnIV4lSmQdvonHWumSSV9yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8541
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_02,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508250044
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxOCBTYWx0ZWRfX81YrX4pS8j55
 yIBZ8tQL0wLxFZoXfCUyYhRsKAUtKzZh66wZfjXnaj19M7fLWQCxV6a0+saXXgAuuNRFSUtMLkx
 L2/qifSicXUEAJYV5NynaiRWqZ/G9aH0aptNGwLVzf3FTgFp98qS5IEYwKqg+14IxqTg76SMLA2
 EOfmlgGuYq/Ad95y3G/tDYDJS1OUP/nZxqkIZjwnv3ND9GBIZs2RXeMHyJF37DFVVDTjT14eRp6
 IlN2qMXyP/+CvPW9J+b4/+ouTVP8WQ3xOY6bDQjpy6htshs8pMwMgxgOQu058Sa5dgMbZJ4UANz
 HHz6S1/VGq4vWd+juoP9s3PGjq/nsQ3tpv/Bp4YwAIZV0XeB7ZYQUDGvR2vd6jqUOXiEpu3ciMP
 fpK5PhCsWedg//JoMlrGKi6IPzF4Mg==
X-Proofpoint-GUID: 0jpP4Nx5otxFclIqHm5LtB8DnyLFEAeS
X-Authority-Analysis: v=2.4 cv=IZWHWXqa c=1 sm=1 tr=0 ts=68abf30e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=PuvxfXWCAAAA:8
 a=yPCof4ZbAAAA:8 a=54Tjv0WagPEaDX3YVhoA:9 a=CjuIK1q_8ugA:10
 a=uAr15Ul7AJ1q7o2wzYQp:22 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: 0jpP4Nx5otxFclIqHm5LtB8DnyLFEAeS
X-Stat-Signature: e4q3h8odn1opi5i363bjpjcbff9ujygf
X-Rspam-User: 
X-Rspamd-Queue-Id: CB1AD40008
X-Rspamd-Server: rspam05
X-HE-Tag: 1756099346-81354
X-HE-Meta: U2FsdGVkX1+B6G46SiiXoHlb3dTkJeYsKVtt7Qi4gDDeWfUWoUBB6jatzXYKll0eGv79TCXn5h5h1Z2Prm5KArJwhYTyAd+nRZJeJ6DH75oVqEwPnlLyKyv8dY//VMJv3jBJoGfZFX8tqlI96qpLCJrPMAeFUgm8NRkOj+zX/DFEoTjITwuUNET2Iv4eSYgE4QvblE9f3uk9h0oGc3eRZWkxOkNzvGlX8AjQRZgRbCiSkNn7Yy9i9Xmiyw/6+NXz070LTOS/KHVknIG8Ta57p+e8+y3l8x7HWDd+YUUkD5SHog7dIhJieo5vxToS2GjUrYezbJxA0nDPlkauNSdQ0hs3T5Qwhzdwk2PC+oDPHqUTzgFjkc/Tpi4ZUcpYD4ANN8srJumCPB2rqrx4x+Juyler60I8pnG6aprU9IdLpZjFJRZwtp1rAkRtlDR45If45BMyTtT7GvMQvm+C4q28Di84q1WELKVQJVeDlEjUb0QGmZ04sN5Ry6Vf69v+rgpKaJjsqk8zbHbLqR6/hYh0qXfdlEsTGD+g+2WRAsghBZCe79cLyGCsompT2u6ymG7DrDn6k7wugFYo61AhSNSBFN7x0DJDNBmfusOu70TntPePtdpg/d0wL2HCooFCLAvyafBfcBMokuXhHes0cSRMuyXdHcgpzBYJ8kAI3+gjJIlKUIO9KJ7oE4mfp8m6pluV7p9KFGscsrGeKkfmbigtkJGT5oAhOccM7OXNjG/nc8og5RUZg+aNcWJnbuj5tHsnrgsxpB6Du5UjxGwFI1ArVi2c0rUcYyT+uQW28BL7Aa5SFVtwe1PUDQG+TgjJVTqns4laBXRk5OVZ6dSJnIjTbvsgbfDxdV6tVpfCtxxF65mpEfRZzUKfMZAPq7ZfG+pFrCEqw+JxxfEAnhawm5EYaGsyG2a5ZVOTmw3NzNqg/JjXH92e5yLMw++z4DEiYerRoo1VuGfjR2JJVOxXitl
 ln+RpHC7
 wAsPBrxxKP6J9MHHVYf4vJjomHbX9MXB1+NkL13TKO6agsexBEYuaA78auBbUyfy+yV2p2BcW9EjDiTrbn5ghJ9Ghn7nA/AdGMq84MLKvGUUSJr1UBk+gqonOf/O+E14kjC3VWXDImxx50CNUejS2wg5hvksRjB1r6xBR5DOsC8aABX58Sh/pawnm8DNP6OhKowRAl+dqAA4PD87PpCCaZmS3Zrs0EmSZhieq2vlCVixVoTIZ2kGU+WEmKAMiPsAc9MgxOno1+X13wGpPDVjGlzXCnX2VM61euftfB7G4iWBSaydOO9urkkoo54vL7ooU9jkgEgCbrHisLkRBRmhQO76ab0txLZtgR/oaqqB60aNWmTCfklukcNTuiSOZBnkxfW6pfPuJPEncxYF70LSgin8Am5EZ68eoXH7wv/gVb5qPAbTRv/I8oTl21CW1vkIyWWxgklygEQop9dT7QV8yc2TbzOLnblVtxVoY7ejV2pkgAqiLi0v8HitmBBnnT1nW4Zq96xPzOxG/bWzFQ0FkV8YVLTnqEf7Y1LrHUA+uqUTIPYfPnhPlkGlY6BwiX4M5UonxHIVZOGJpKtVRKuimgRjXd4rlz1z+TF4YfIMnHqf5sCdMtFWsB5TbxvrLIZQhyOc+WTXnj7UYa2rzB6XZM/VSjpD7e5bgczCG59s+1VhZn6MUZA0AoT38xPeKcI/eIt2lj9iXd6gM3VHOpzr29nhxqv435p4zNT0SxXNEKDLhtspwVA0W0/Av6hG782+81UhCf0/IS5R7MQDEIpU4uz/5tj7wjJsdEdqsxXWJT4QdXINXjM0bsFXzZ35B6u3qPGMfXJ6ccDKdobxthR6k5fygbunPMr2w1c8WptG9+csP5wQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 03:34:42PM +0200, Vlastimil Babka wrote:
> Since we don't control the NUMA locality of objects in percpu sheaves,
> allocations with node restrictions bypass them. Allocations without
> restrictions may however still expect to get local objects with high
> probability, and the introduction of sheaves can decrease it due to
> freed object from a remote node ending up in percpu sheaves.
> 
> The fraction of such remote frees seems low (5% on an 8-node machine)
> but it can be expected that some cache or workload specific corner cases
> exist. We can either conclude that this is not a problem due to the low
> fraction, or we can make remote frees bypass percpu sheaves and go
> directly to their slabs. This will make the remote frees more expensive,
> but if if's only a small fraction, most frees will still benefit from
> the lower overhead of percpu sheaves.
> 
> This patch thus makes remote object freeing bypass percpu sheaves,
> including bulk freeing, and kfree_rcu() via the rcu_free sheaf. However
> it's not intended to be 100% guarantee that percpu sheaves will only
> contain local objects. The refill from slabs does not provide that
> guarantee in the first place, and there might be cpu migrations
> happening when we need to unlock the local_lock. Avoiding all that could
> be possible but complicated so we can leave it for later investigation
> whether it would be worth it. It can be expected that the more selective
> freeing will itself prevent accumulation of remote objects in percpu
> sheaves so any such violations would have only short-term effects.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slab_common.c |  7 +++++--
>  mm/slub.c        | 42 ++++++++++++++++++++++++++++++++++++------
>  2 files changed, 41 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 2d806e02568532a1000fd3912db6978e945dcfa8..f466f68a5bd82030a987baf849a98154cd48ef23 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1623,8 +1623,11 @@ static bool kfree_rcu_sheaf(void *obj)
>  
>  	slab = folio_slab(folio);
>  	s = slab->slab_cache;
> -	if (s->cpu_sheaves)
> -		return __kfree_rcu_sheaf(s, obj);
> +	if (s->cpu_sheaves) {
> +		if (likely(!IS_ENABLED(CONFIG_NUMA) ||
> +			   slab_nid(slab) == numa_node_id()))
> +			return __kfree_rcu_sheaf(s, obj);
> +	}

This should be numa_mem_id() to handle memory-less NUMA nodes as
Christoph mentioned [1]?

I saw you addressed this in most of places but not this one.

With that addressed, please feel free to add:
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

[1] https://lore.kernel.org/linux-mm/c60ae681-6027-0626-8d4e-5833982bf1f0@gentwo.org

>  
>  	return false;
>  }

-- 
Cheers,
Harry / Hyeonggon

