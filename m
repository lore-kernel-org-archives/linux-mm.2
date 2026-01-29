Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26ECDD358CC
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 07:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6543B6B0088; Thu, 29 Jan 2026 02:17:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601A26B0089; Thu, 29 Jan 2026 02:17:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48E876B008A; Thu, 29 Jan 2026 02:17:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 333AF6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 02:17:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BDE0B160921
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:17:22 +0000 (UTC)
X-FDA: 84384145524.10.625A317
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 63CCC140003
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 07:17:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mSRrCj9f;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nlm+jlOf;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769671039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NpIB2r4Jyad5bLbMjVh9gkV77hL33TY4MUV9hoXQfUc=;
	b=pOpZl3i7uruApOG+XcDdyQ0ynwdvLp0zB8a2/V8XtoqQTclKSdQWY94GWQGj22Za7toL6d
	dR0u3MN5fJjk65jiSGt+8f2wkVm1z0uwp5/znEeIX5MyUAdXgdCPt93yyGFR3e64k9m4oh
	ahmGs5hvGIaJdtys30BFKyBiET9/CII=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mSRrCj9f;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nlm+jlOf;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769671039; a=rsa-sha256;
	cv=pass;
	b=VkrkqQgtq+Uqo6jNi/hxvMiBDEqyo92f85GHt4iWVzve46MQEyDMzZVNr3bnw96jVX6LDR
	jt+X6Fdcj95qMlwipV/BCXPxvEEFWphdLlX4E5XK78fOK392ZnlmHCyExikBB/PN6B6CZT
	716tB6bE8AGlHk3vbYWbfVHRlUzf0Zw=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60T3YUaV3744719;
	Thu, 29 Jan 2026 07:17:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NpIB2r4Jyad5bLbMjV
	h9gkV77hL33TY4MUV9hoXQfUc=; b=mSRrCj9f/rGMQn5YdDodkFOGk6qUVHG6ou
	4yRX5kdu/A0ZGz8YgLsByH0PfLUZXm5cADu5O0NMUN4gDvtWMFdnGBtAk38XlhAp
	O4GOEHDJ654onAw9scCwnOWvp8tPNYCrmYcaKCLqM+gkII4oHVNClldv/Iyqes5V
	aU3zGRmt+/QjzL5W1efLQ0RwcDogzMjp8b3I9aloCluLtYPVdqHEe0YSUNwCtdc3
	oNbWGs7inztfT/TpaFI2FTuR7z01qDP1lJKWKQIo9/pKQJf/N1DZ69vvDpPKZLlx
	wa+utPIMjJ5422uI7m6RcU+2FpFUaywoTCpRix3i6XaMoMM7IFOQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by5dj2dqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 07:17:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60T6pKT1032720;
	Thu, 29 Jan 2026 07:17:12 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010033.outbound.protection.outlook.com [52.101.56.33])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhbxs1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 07:17:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ASny3/KLS6qCnjk6tEVSYqjKLmPXNV8W9+tdMRcT41K+lSrZfwy6elGlcmX6MCb2ltCwFzOihng12v6cxrpfyLP0aaJBWmlC6h/R926HG7LuYpCV4mt5cmlzxPLZsWWLUiQGmpA29/i20Vi3L2fAb0wQu1BCfiRdp5NabL4GZALJTuFQWsMnOIWxHltFq3rZ68jg3FU9mucVbf4pAud6v7LPYvCJ9gGTd9bwKLvPhJnbiKlusj/nTYKUIxNo+s4gibVQ8ZiO3/0wLoXy8EZCqUaybDcdkV+Q51hopLXEZwVnIc6YlhbJdlEI7UB1juYICZUey8y3eoKoCg0pqRpqrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NpIB2r4Jyad5bLbMjVh9gkV77hL33TY4MUV9hoXQfUc=;
 b=mFZTorrNLrRxjjsONVn2mxPFzNLV9Nh90yaY3xhHhXzhyyfRO7inRYher6I7uFr4FZl9mbPEzgM9YzrajWANDyHw31OabaVofkrxM7pBHHY4m8+Q8tJNHUKba0tizRUNnap9HI77Fe9ucEM6KuCbkbLZ0NoFs/nv3aNATzEkRE6i5juusJIGJcDhaw+G82HM5/s5kVQnFcCasN1u26w4cv5wRBanWP3WEosPEkyN6yqlnzr/zpVhQHr0bGmXUxFRPvUwohncOC+Jh1IBsQfZKdyI5FP6F7PToOGSNE4UpJp24ena2s1ynyUvo2tROGAsj8x6eEqsgApaaGDmysGCcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NpIB2r4Jyad5bLbMjVh9gkV77hL33TY4MUV9hoXQfUc=;
 b=nlm+jlOfkyN0h5jUYzVfCfDOzhbHqS2lFF46gIKxkhjXU/dQx8+rLYqlBgDOjavHMI0y6vmrlKI00rmJCQYyWbwl5QqFJ07eFgYLc1reEINB8P5R8IVlNkSyW/ogPjfiUeHO2rcZ7H7W+2rygJtXVBTbummG4sCZYqSK6Yr3LNQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM3PPFEACE3F2B7.namprd10.prod.outlook.com (2603:10b6:f:fc00::c54) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Thu, 29 Jan
 2026 07:17:08 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 07:17:08 +0000
Date: Thu, 29 Jan 2026 16:16:58 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 20/22] slab: remove frozen slab checks from
 __slab_free()
Message-ID: <aXsJalZN4qdFze2f@hyeyoo>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-20-041323d506f7@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-20-041323d506f7@suse.cz>
X-ClientProxiedBy: SL2P216CA0123.KORP216.PROD.OUTLOOK.COM (2603:1096:101::20)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM3PPFEACE3F2B7:EE_
X-MS-Office365-Filtering-Correlation-Id: b80a278c-71b6-4d8a-29ee-08de5f0669cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1csfLsWPBDv2ZtMio0nWElVqocna8crfyH4v5ldXbN1NwVEaHG2yEGGFt5JJ?=
 =?us-ascii?Q?rKAKwzy3hQ6HJYWtf7Z4OeUr5bg69lVVV+7L0CZXJatH7ANwr6EPgS7DeFkq?=
 =?us-ascii?Q?21V8yUqUk3dZ5VzuSVFSowOJuuDPcU8qlAtfiJlu0kxj/gGheJLE6U18CB/9?=
 =?us-ascii?Q?a9/59SzEaJP1vFLpKAwDbVdo42w/C/67/VxYdjXE+g/ef1dTtdpRf5GefGZ1?=
 =?us-ascii?Q?wzSxXWaqoGDYi2ab9ambeBNbvPVTms6vfEu3knJlitrp0/pKKOeVyO4LqjOO?=
 =?us-ascii?Q?pz88i0LTrWqCka99eYo2FHSrakcLSofNPk3RpgX0KEkLLdk6E3IqYlyYIKwd?=
 =?us-ascii?Q?4f6S/ktioMng+3TZ26P9y3fvj+CVMkrel+1Ewqqh8uf1ZEmDBmLfbHWFx6bi?=
 =?us-ascii?Q?uqUmrpCNMqAkt3ZWhKCBo4ikew7rcQ2zow4R2ZRDEAsi+p5rHOfOgAaDCjeW?=
 =?us-ascii?Q?LnMLWA6zAVcfwo82M10NbKlqVI4Q4eNch34nylOIXbPQ8+1PT1yOc6HOjPd6?=
 =?us-ascii?Q?IdMqJ6HLKJMcTBtYiv5eWZUXaMUvNBnNGxPgc0HFqcTdiOSvy5df1hBY1qWA?=
 =?us-ascii?Q?4HDrg7+Il3JwGP1PbDTfa4/l24NtH4aeno3IRSn9n5gThdpjnnDDOEZHwsp1?=
 =?us-ascii?Q?fZbpBUB8uYzhm9yPvjTEw5XV+kZsCerEoxXY7kpaczEcxSAITIH3/lu2Hgnr?=
 =?us-ascii?Q?ZRXz14wzL7NjHooJo77jMWHlPuHRNrGCyu1hGtWOAlUPwMcnZasNwrY52n4E?=
 =?us-ascii?Q?jh342bomAhIoEIbWme4h70+V2EqgZaOIFIzBVHxzn8SalMiw28fpc/OYKyup?=
 =?us-ascii?Q?Blaf0bYhMOKUMRe9ArdnMihNu6kkRIhiqG6Yd4kb/fm4AjagV6S0g88Iqh7V?=
 =?us-ascii?Q?GaVkU7IzzKiiuvX5UkH9+Xi2LWyBKT/O/YMDNSCFoJkuaum4mqr/CRs6bDkC?=
 =?us-ascii?Q?fb7yaD0V26Vt5y4JsLZdcBHWfVes6cFeUS0EpV7mNVMPuW2F6ca2jIVDkm2n?=
 =?us-ascii?Q?LC0CFbOlNNU1Zd3O+6XX+amaz2tOf3ENWc3fCWBvlDhASuwews5XAMS1lUuR?=
 =?us-ascii?Q?85KP1Zd+TaCh3J7cM3cARGn5ql7JJDPoVLvn/OrjA/lbAhiIdPS4WU6MvTAt?=
 =?us-ascii?Q?ifd8W1SfyLAwpQNIOsG6MwtNnNntD4mBUJCQhHNEUe4desBmjYiUOqjPjvIp?=
 =?us-ascii?Q?MoluSdkspdhIzzycoKFyf0kCrq1YzSaWUTt5x0SL12Msx13wVpGQnP+kuDDp?=
 =?us-ascii?Q?oegmQC2rBnzHKZRdaW1JH8iN4oY+uJraCo/8dfTTT4jaWI1tTvf8bhWLPROm?=
 =?us-ascii?Q?fRmVin14flSRk6c328S1t6JO4j9dEKoAnnQEQ+p5VNsjZaTxoyp7Rren+3lM?=
 =?us-ascii?Q?EM5d6QBOwJlGxJVK5g3W+kr1/p3s5L5fZlBmPlY7xvf3W8VKVB+2+Vz10PNt?=
 =?us-ascii?Q?rbGBcu8ve2ZT7GXMx0ZPdW0kX1zezCvPMw41bPaIJrGzSaWwfwapT95aP8pK?=
 =?us-ascii?Q?LmWJRJ2My5MSOrKbpQPoPwZxNE9qdY+aFAaff5OYZlWpN5OjZtg7KzXzyFut?=
 =?us-ascii?Q?AA5YYgctdWoSqwOyvS8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pV1TtgOuy44fB9LiJ5zrEm9DZ2C4L/KECUTdS3ucyAXh9V8CHzHT2LtU5Yqy?=
 =?us-ascii?Q?CZfg5Vg1NrcrH0Y/+VKepDG5mxUmj0I2sVUZjoQtTIyZSxttIjSzUUsWdx1+?=
 =?us-ascii?Q?ng/v3TpBNvyRjWpBCTm3WtAd020ae7VJ0aljhpNf9o2OvSTl2OYVCEohi2Ru?=
 =?us-ascii?Q?tl947L4ExozKTcmAbrU0NMozx+atVxYQsFlRMPGZgJLKDJgavjGE2B32YgrP?=
 =?us-ascii?Q?c6EwzS2ki7EJENq+Z47x+u0AHAm1vmfcfZd7zEk34s5GPsVvJ1wcW2cVZ5dF?=
 =?us-ascii?Q?f5CekZWbZMy78X6BMxmHuXhqgr9nwZc13oGCAjQO8RbtnoKTUaJc34v/NrLI?=
 =?us-ascii?Q?urg0apqk4mlxJ7oQhVIh8nN0SaATil8BwHSTH61lAibqZzdpiCbtnhWJ8rod?=
 =?us-ascii?Q?qTpyj91EBHom7Uyzbld8RJUsQC2dL/k7bVuhSyXxeoCkzR8nLyvyd+7gt9p/?=
 =?us-ascii?Q?Tq+4JZhZwC7V3FDeFQadLgcmsaGDnK+Z7RZorMC02m5plO1zYdsaSlcSuVRB?=
 =?us-ascii?Q?e/y8dtyFlBiZX9egbXXUQ/L9URzEho66XjtqsixtJRHqvULLbhEj5d37puhn?=
 =?us-ascii?Q?UvLq2WNs2TJj/R7vmJWBwu77snqM2d1A3zPuJ/8H1//Wm5XvrdtTKXaHYBya?=
 =?us-ascii?Q?UUbURH/EDF9VNLB684vqTpySOW27r179ChIscux09eUWvAgDN/H9QFkUn87p?=
 =?us-ascii?Q?di2NZ+MueFaGN4V9E6c1tN8pEF529LDtkPlVSZstEFMkkGwE1pQVQ58cOepn?=
 =?us-ascii?Q?fPE2ejLHf59aY+tm2zMPGLDUP9HIWTIoh6I5LIQErQXii+1KHUEaoWHypxGc?=
 =?us-ascii?Q?v3yLIUG30Vkh/6xyI34Yl5SvWohZ1+p00z7VGye3pl4nVpyKjO7H+CpJIhcb?=
 =?us-ascii?Q?IdczAH5vAwCXAuAUFS3B46+TQgIVRPThdj4vJvPKh/sxEAE7u7kQ+/IEZ7Vs?=
 =?us-ascii?Q?rXElP8FLNosMgWqIlMViMMDhZgI0F0XtDYIUSTHMil9hqcqEFUa0JzJdRf4X?=
 =?us-ascii?Q?zbyD5SG1U0+deDDVnW8b1yzfXsWApzkrLw+8wuPwKcrhC92Gvx0TqCEItQK+?=
 =?us-ascii?Q?eADx7yH4fnfrgihQ+9etj6L3RbeZDqXQqPkXwffDjR0BrmQXIjt9CMDe9N6M?=
 =?us-ascii?Q?UPyTmfD4xP0rCPCddq8oV4CDoRghudv2jw6kEjnw3WqvhWhj+hTUZ+axjB4U?=
 =?us-ascii?Q?T+VxTHnqoW8z4KX8GGjR6WrYVZkhKQRA736NSysitj1/I2HhtKGlWhQwqnjN?=
 =?us-ascii?Q?fZr9GKTqZNyKVcblHqQaufB68oN3UVGshStwEJbkGWWe3X/lS34CjkexKRfg?=
 =?us-ascii?Q?+XSpYXvr/OVA7NuUg3LwQ2r7lX5l0vH+sXVLDl/zZt5oFEug2VYE5t752bY9?=
 =?us-ascii?Q?f7uLHKoBojTgFOiyEhWfGp5TQcy/rIGhR85GBQT/lX+xYLvap8ZOY7M6zGX+?=
 =?us-ascii?Q?WPZxs9wUM30AvSQZnH5owwq7C2CJlZn///2dMyZPgTE/2gAfBg0b/+aKID7q?=
 =?us-ascii?Q?t4CcY/fBG9HZJOuJrAj0dAA/h1Bwp4cmhCLuAeo3M4u8GTPEBquIwN/3Edw3?=
 =?us-ascii?Q?xTjh3p+Nvom8DyscuJdoOWAIoHuDg1z5OypTWQdw2LPpPkMznQQI/i9M/58H?=
 =?us-ascii?Q?j2/eW+jYrtAVeXgvRlmUSbhvn5Wguq9QKgvW3C2oXUCCwdixhvvA6L9qSHFZ?=
 =?us-ascii?Q?BSwHAdd+1HahP3AIeYC+R7WML5xeRi38oAzo6LB8aRiq7lVeJWfu4606D8LW?=
 =?us-ascii?Q?HfkF1LzeGQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u0LFikNkSGzHN3BOxVhYA8gUj0ht0Y3Eg4bxeKp/EeMVlvVRhhODd65XLWhR+J6KIcZEB5rmnQ+PkE7X4a0G+ng+y7y4A/+ml+pkt3gz9QjWl8TMF4v1IFmuVWH6MerXICx2IjRcoxNELcErpDys9DRzcXNE+dcEOBs0jlNENsqG/heVLfaRZSl+C8XQ/o+X3vyJBJlsh9dN6q0f31C2aiCVcrmUc4oMp+e8hXpe4I1vytQt2mB73uo4sGYPT8NKj9pLmIXWNPsIIqfbN7asw6N9u1mS7z8eV0pyOWXM0G3ZMu5N2n3TuOrSvr1xiPpFuDGlH/WTwrkYusZzH50b0v2rrUICuORKl8t5YYXUQ0B6i5ZlhNjFs61RpiMl5xz75HTZ9P8hOEcijU7gFZ38zpDEk+Cm6c9WNH7xN2IhDh5VJZGM4BI+0EmZ8La9Fu6kNIEE2GXoiPRhk01AO3jVpXyjDLAUKAL/iywZr5q0BTw/wj5Fiv1CxbV+PdrUwZiZ3vdI2H5iOSOmT4rHYelI4Ch9jK55K7AtXoPphkI35qbODj3/PbBZKAz6eNpbah6LmRnWTRmZZpKJ/0D0A84ITCy8aO/ZMzneRGpjrMJHErI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b80a278c-71b6-4d8a-29ee-08de5f0669cf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 07:17:08.6529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mH1rJsHrpjXhaqtB7ZZaxL0EhxqK4bSRLh/h0iy4aaxUsdZsPQUH3p8I+1bOFFT1bK+SagNgIVKxj9aimHMtYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFEACE3F2B7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_01,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601290042
X-Proofpoint-ORIG-GUID: X3lGaFsQ1he15CSpMhL3V2zNTNuwfFXB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA0MSBTYWx0ZWRfX+QWYmNTH/4uZ
 TP6gcYwwAmEP46nn0Tjfwa/KQiND6s6R9B6rOuIURpMqMFiXoiT6wCPdXssc+gCEq91vBbb/O77
 8ol8GTZr3a1E/Zg71DWb94MJN1QbVl34J2d+4ZmlVeIL/+Cgv3MGqtMKSfgWzXmso7BhA7LJrGm
 T0ltqehxg6mCpByfJKzEe6ckejqpb7SEuSr9Z8QtSh49Mwuyyr3ZHN8O3r2H1tWSEI/AX6IZIus
 1chKhKH3IZpcD30GtREIAiDPcBok3qKrLLOwgtGd2Idni1dwGlWdLGUfozNu+g0HqPtmJQQqErV
 ivDanoTuWK5CjDeniOehFiydWpnDaDiOZeT7QCF4kENVp5OlvLAfohreyqpLCOStevydpOXfmJR
 lFBQzRVnpm1hZP8+/CLKpFP2n1XBzM4ocGk+tKmqjtUXC3ggR3hJKOTWNnW2406Sg9hKGyf3LJy
 dqnIPPGM47jdm4vmuPg==
X-Authority-Analysis: v=2.4 cv=IrsTsb/g c=1 sm=1 tr=0 ts=697b0979 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=LwiVl9ns5TU31JiSBR4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: X3lGaFsQ1he15CSpMhL3V2zNTNuwfFXB
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 63CCC140003
X-Stat-Signature: xbd8b7837qzqyqa9ypbg3bwqdmtw9r4q
X-Rspam-User: 
X-HE-Tag: 1769671039-69503
X-HE-Meta: U2FsdGVkX1+kPDWLWasm+O62YThmqZ4dzS0IGHDwFml0hHY4cDYveB1/J8Y5d7J+yTSdfGgORjNEdEYeG/6JXyzCjJcoplA9Sjo2It6KE1IkR5aBzO+c7ySmnnKkmZiY43fB9Cv9MqNUauO3v5Notdm9RzV/Ekmny5VyFC7jgcqGnJqowYLfTz645MwNEwvmAK+BCJXCT7YqI4y0z0RTIExoA1sOuv68ClDXMrrhTNckYdj1haags0zVunhUMpz2xsOxn1onHhy/023Kdx5z6+zH0DNkqEB8TeBdfVp+/PKd+4zVu3RPakNY1HnJOK9vxBDhK41bfq6SA2m4D2/xasEiycMJUWPmw4KAmb8G/wQdiRO3fWYEBxQsdvy5uBM9lr7WHho6eX4/usW+RcszUW6cgN7DgMcfEU525mwPm8/wWMPid+8Z+Q5PrQf9vr+y2ienHYGt3WvFi8PbGKCU6IgTpqypBMzx4J69+QJQ106kAoDpONAF+41W45+FWHFBEYrYeZx1G5OEsLW2VggqGTHI6WcEUxCHbAicbirBxL+VKt7FbaUxaKDBLuGzbw1lNwqIV5iH0lpoLv42s44ffgV/HQIrNeR2a3tSZ9d2ur+d1jYwSplt3KtoTuqHd1mmKGSKu7RBMYrX1SPWtTFdKrEtIbs34Id018cjgePIs6efvrrNwM7+Fbic38pXyIlv+Wvn4ObpZWciwWbHw5LCfm/KEzYZquxo6XvHsqK3O1oN3d71G9hBqY7nJXGsUa/PxLGIO3Qg5iYZbvVaiYd9LCBtFUCPwhV6q2bFdV/QhoQ75Aas41mx00iULcqv2Lf8A1cnGlNQjfbV6AjEpcV1I1BmZHVlQ59fjBsVXIUATI30ZKOLul5VeB9jVluaJZ1seNFBcrJoPlesiiH3XaNR9zFHrplcOcIORIrrT3saShuuoCSLIn4gnd7bAIk0y8QXYPOx+tsRZu9cLn8QYeF
 GU4jBTCe
 tLkF13Vs6QhZpJXaPLJCUrUyoEM9y9pw+md7lprzFHd7DMzyKafVHD2CQYO+8FAzk3PqDje1RlTOArRwtMt3omtIxZmNbxEhI/dTJ38VXor7YPnk/HYXFT/tgDUUYLyRpvTyfDwuMeKnqP120QbDDPcI5Mj48pyE53won+ff4rnevfnQW/1ZeAnl1v5jCH2y+6L5KyNBkH166cQIIJm0AoJM9fpbU+IazWRicRpUizPfNh+R6nptSKjoGrhmyn+Y13DX7NaT0gxpa0Bra06K26Diz0FRWf+kRZ0jkIpVeIurXbc8O6tZ8WSaq8Y+ZSAfp2eJihbedq4NRBlgEI6/3ekkFc1TZ92gz2/IYXoLDBKQW5GH1ElVAuzKmX/BhrL8Pp2CrhrkqbBZ0k0k0ivdiPIbFyOzhPiCoVBC5p0cNOxotWEIQUvk0GfB/mxQkl2oXXQu+oHk9gNzJtpt7PqmsRkGJu1UGIcQ95SiBNhPvS8xZOeua+ziBVbavvqEACVz7YIHvjGS05Ugc/wNL5VDxyV7SI3JkchT6lIUj6s/s/yk530K6C4nD5PBslcencifv8+Yd3LF2b5PFwbjU/HlpuDe6KsuyXypHrzUJ8NiZJxGA1Up0a90cgyyPdFURjfJidgBGJEjnhleRm/NyDMRkk/FxKgJCJidWCizZw28/K13WaF28SsTE0XMrCsFOmpW00RhjsSI8WgR2QReyf2RxUZ9kbwlpK7ClJ/F68XPSO8Z/ZyIFZN69GONRsV/1I2Nwa40k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 07:52:58AM +0100, Vlastimil Babka wrote:
> Currently slabs are only frozen after consistency checks failed. This
> can happen only in caches with debugging enabled, and those use
> free_to_partial_list() for freeing. The non-debug operation of
> __slab_free() can thus stop considering the frozen field, and we can
> remove the FREE_FROZEN stat.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/slub.c | 22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index d9fc56122975..3009eb7bd8d2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5145,7 +5143,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
>  		 * to (due to not being full anymore) the partial list.
>  		 * Unless it's frozen.

nit: "Unless it's frozen" part in the comment could be removed.


-- 
Cheers,
Harry / Hyeonggon

