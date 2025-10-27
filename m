Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 712FECCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 07:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8999C8001D; Mon, 27 Oct 2025 03:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871168000A; Mon, 27 Oct 2025 03:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7126B8001D; Mon, 27 Oct 2025 03:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5596E8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 03:21:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12AE712A588
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:21:22 +0000 (UTC)
X-FDA: 84043048404.29.F0ED634
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id A529920007
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 07:21:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="P/RH62aw";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=snReQzCH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761549678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9XHo23kl9jFl71ndUjgS6WBpe+v05Rrvgrt4DeBSA1I=;
	b=HqSOrqHLyTg/+FPdNx0FQqB6HfY/063cMNQoPVghLicHgf3X6Xwlgp+MDCC33djvNeo4IE
	SVs6wVzJp56aTXros9yyxz9iR8OxVV2T/yaF+GKFqZRUuHl/YFMVT41ncYnO01DPqvBdIK
	C+BNjGMvbasgTZduIPJW6vYG5nYIin0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761549678; a=rsa-sha256;
	cv=pass;
	b=kOTdtepVXvA7mzuTlrhU/jvFO48tHqIOwavllYYLdzK3ge4U+GJFrvTSuiUYaCPpr7EVfs
	tpdJwcBXWsK6iP6iwsD5CDJonlE6Eu5Uc98qOODRrFAGpIfDcTqi7EnDY5ta48UZBcgI0T
	OjDZK2N2wYepR78/2WirBdPS9d58p34=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="P/RH62aw";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=snReQzCH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59R5iHE3017102;
	Mon, 27 Oct 2025 07:21:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9XHo23kl9jFl71ndUj
	gS6WBpe+v05Rrvgrt4DeBSA1I=; b=P/RH62aw6W602hBJUlzSytdVtH31azNHe+
	uJFhR+Qy7oJMBA7uIlB/AUJ8FFuPSSbRaOySgeFwRHp0sXOKyXiHNbWx/8RLHOIS
	slScdUw71n55HEPzz+g8hrVAZkN518+b1xBG/qQ6gxjPUq6HvptDXiQ0A7nqA2Cb
	pptN+TBWDVFNSb+9BCpjbX8zncshpCiQnyUVW6rnVFoWf/Ls04lwr2buqLYEnB6A
	MKn5isUoOz4QN/fqow+PFJImluIDk0AC78wmYGWxJdEkap2IEuUnKQbay0y7PuHf
	uQ8So2ov40zHxbDkTUWyxkY8DiHTRfYeR01dtUGGWkzZM1pspi+g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22uu8588-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 07:21:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59R5F9CH015247;
	Mon, 27 Oct 2025 07:21:10 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011058.outbound.protection.outlook.com [40.107.208.58])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n06e8wu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 07:21:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=frLwZLSm4nhVCyp31bn4EeVyepAN3JsVduAiRx/i3Ad9nqRYjaQJBfANl+MZy5CYS9o4yoo7GC2fOMAVCs93LNhOMpWNUkgoFBWVzHlwgFwnmJvbhRZrCAr/aBlVRIPtZvulUtwDXsuFVTDCWE2VGA3AM9jeC0Mjbp5X5xbPEWOyPBWssK2/2ByAZ6/XyVtUhlahzdvtpLCVJ1oIXH8SIvvty4ySOnMVE53YvJzrKVa6I7P6Wm+MconunB6Rj0+Ghv2rvL3AU03PoGhTg3+308xOeoZdF667kJBl+5TqiLYBjNK1INVB0Tc6Qcg8VnHYKn5IhzMEWHbNbSkVHH9Ung==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9XHo23kl9jFl71ndUjgS6WBpe+v05Rrvgrt4DeBSA1I=;
 b=xKQltUlJt+v9MdUwvrt09cZ/X22LU65b9twpoPC+305R2zjy6IACJnjZipmPGkf8vAYNCLLOu29TJ3rL5KsDM1QD1EnFGJf/XvvsvcqPt3nmiRieLhD2DaaVYxag7ZtrZ00BeYqHixI49KGNAXdDqSfrvYzR7xP5rBbz21Yt5X5kXoBnE0Gz3RbfgvbIPUzH4Qlb95M9eGRttFAktkY5A7yRQ2FFpjXLG/KM/x1JMjUv+5wJ2nBu11p0Z63xxg6sdjOaV+txHKzL1ROteoNlzOVZgfqfpvkckMHJ9nFKQAJ48OY75P38oLrdW88dzPth9wYEgnIMULSkzwGpx5Hfew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XHo23kl9jFl71ndUjgS6WBpe+v05Rrvgrt4DeBSA1I=;
 b=snReQzCHX9ZcsysRG95GckteGJqhGz/0YHUHHT9wm1NNAZd8SBSj9hyClJDvso+mE2eLdSDAjfA/s0WDQJ3/cNuwJusKT2PFHMrhp2RN/vr/IOgNnsQgLa+OFg4roLERsfOz7jj7HO6z26mv5YQBY+VdCfYTATUDduTdnNDHcGI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 07:21:07 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 07:21:07 +0000
Date: Mon, 27 Oct 2025 16:20:56 +0900
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
Subject: Re: [PATCH RFC 09/19] slab: add optimized sheaf refill from partial
 list
Message-ID: <aP8dWDNiHVpAe7ak@hyeyoo>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
 <20251023-sheaves-for-all-v1-9-6ffa2c9941c0@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023-sheaves-for-all-v1-9-6ffa2c9941c0@suse.cz>
X-ClientProxiedBy: SEWP216CA0103.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bb::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH0PR10MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 197dc4b9-faf2-4f15-f9ad-08de15296500
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OhSRtpXhtnMoxwUPu0dZ8kA1bxKvy9Cu+64bN38EedoI5pW0RoDZPuYdP661?=
 =?us-ascii?Q?O1jVOrtV7fUqSjx5mbk7DWiVXcdBCd1cpvOADLq1PCWjeMGKMLrxKpiTIHJi?=
 =?us-ascii?Q?i9Hd3EyFnfu2MFnW3vl58Agd/PBpYVU2AGu0KvE4RSU9EgK0Oo1AiAbUHmgW?=
 =?us-ascii?Q?fQZmKhQKxjvGbRMNEPmxVlvnvtxbOQK9crW39Lq854AbJMHNBQMIv6c1tg5z?=
 =?us-ascii?Q?uKj0b7yCowrY8AKnRqqAUhzq7Vmb8fLNZKVCXByfTN0u1Pyf8U3514Xy/LPH?=
 =?us-ascii?Q?CanJSSELKBkqrCfVDhiWl3tpnVxqavyJ6PKenAfn5VsgsX2JETt+tbkhqQdJ?=
 =?us-ascii?Q?lQzFIn1F9lE09seRI7/0HCePptyLrix3NEhdOHy3yN3mAQNVYwV0aLMUuDf7?=
 =?us-ascii?Q?4NAJpXO/UIYTYS2yynzV9BRXGiCdgZVHi/XZiuwjECkYn/w+AFaSLtOXQeu+?=
 =?us-ascii?Q?esRCKAKquVSunC3zw9yqpuM1LMGeCz9VBz4oVQYFsJpkmhsZiFPiyir2D+wQ?=
 =?us-ascii?Q?lYbfoHqJU6S0Xpqmx82YG6aJxmK2chBMZmcnMK/5UvKuUh3PyAMN+WjzEMA7?=
 =?us-ascii?Q?KXxM/M2jQz2SN5UIqqqmvoHAX9Pl0LoXnqt/zZ+1wS480WxH2dtAsDLzCMED?=
 =?us-ascii?Q?yMbSfnPfB656MxeIx1GL1aD71PkntV13idnNLFQSegjT2RfZkg8ul5kbPc37?=
 =?us-ascii?Q?vQW2M6imHmdxYMVP4xCrKfUSO49FeF+LvAhpD2ysxhuinfr3a71wTHJogMj+?=
 =?us-ascii?Q?sW37LHNPzZslJQaXBPqs1NySYJwZtJWJb9louWuWa1VpqiW6Qac0xcHIWn3H?=
 =?us-ascii?Q?XWXZudhS4Iz6ykuxTNG6dDKqMTikrjDxkaXRAel3f/7ELBJUIK95VTL5V8kZ?=
 =?us-ascii?Q?3sEZ0KBr8kUNNyh2t2qjew/eRuOO0bvI3jfWJpF9jUM/c41w3ZPSBeDKvYi1?=
 =?us-ascii?Q?ZpYnzg20cKA1ahAAcXUzcvNM9kcwkdQXZCMNADsZlNOP7qPICQKel5yhiZIS?=
 =?us-ascii?Q?jweAtQwImPYgOI/lBCQUyyJM4EybCzBm30qq8leKJqQFlnKAju9rQHyg6rYh?=
 =?us-ascii?Q?ix03U/4JoPJbIhTfodQqLNLvMwCHTeiYuqUCIUxp0x0jUUjKO+4WhsKm4NKy?=
 =?us-ascii?Q?RGPH3o5JQpI7hQzsOTvUQ8vC3lvtvtRh9yCZk/da7SdyibCLjquG6Eixps27?=
 =?us-ascii?Q?QW0k6OQ4CEnAKPadlz4Ffa7nnuunwv5RYFpjET5VZvW1AdLLIhPsHc2wIfeh?=
 =?us-ascii?Q?3lxPy9hoqBnEWDsnMVpNJdGLeDGRvjDsWvCFMNZQiNxlggWL6ZcleCwq8sCo?=
 =?us-ascii?Q?okz2G2h8NZ6RGUzF3qv56fNFK0ryrON2nnBQimHnIUWL+Wyil3npz1jBQNnc?=
 =?us-ascii?Q?zSXS0MS92GqHCYa7n7mZpVhr7Gct/Qgv9VnInmLHAvB2w+EuqWloh8oF70Eu?=
 =?us-ascii?Q?YqdoDvbv9GlCQMn4pkCJj7n/qxG6kbjr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9WAQz9d8SbiCRNp822PEUvf8GME2gj4E/MnhVTkDs+khSf+Hl7Nci0WImaP+?=
 =?us-ascii?Q?iQOUfz/winpr1P3lHKw5/rdaPyEDYUBqLzWcDX+IvvW+wL36GLRDu2G8GDWP?=
 =?us-ascii?Q?JvLD6Rp6butZgbTWMrXA98PWipxaRovWW0QCxMeWFmJ/g9MV1St5IWe9L82f?=
 =?us-ascii?Q?hTnYu3MUXpDGdtA/eOCjYjXuOUOV5hfm1ZnVOY0rBPAMibDllMVGjZlbjgIj?=
 =?us-ascii?Q?KIs2fCulwKjP28Xhkum5SdkWpTv1GwbWV6p8dYVE91nFPrCPwcQGwU+3vndq?=
 =?us-ascii?Q?z2mY2Xk+445CepWdSXIlqRPAAmwNGI/4vzG8A1SAXnbYeNEcgcH6qKrqomOD?=
 =?us-ascii?Q?EIYuipNqVrMGE+ZN648Bnmpcr0cih3jBLoVHhtw5MyI869aQkToTm8DVYUiD?=
 =?us-ascii?Q?DBsCyULyl4++MYyw26+ejOXro7394gdw7inhRnJXqeHF6vA0xxRLB4VgqCAd?=
 =?us-ascii?Q?3qg5T3i/hUNHkv10rQXbxVNC4q+NUWa2EG7hU9KqBYchKeanG9mo0mjDCewJ?=
 =?us-ascii?Q?zlWkGlcQSPN/Dy7TISsap8kJy+KvXN3o0tG4ltZYxQRW5y8/RgYChjr5JsPI?=
 =?us-ascii?Q?lCAwumkWMSKyKN9cL7EUlpVdRq6kg6zzcSgRa6I/Vi0kuun/ZWceaMHDLJwP?=
 =?us-ascii?Q?nSNGV1s5oQMTP2zHliJw8ltBUjm1LmGBqnMeg/0E596sbqikfXcTTCPKGf8/?=
 =?us-ascii?Q?tOM0rpZxCWi6VhZX9WwEAItjQXG+sn9P5YCdsWHFcCucWKYc7K2LwlX546Np?=
 =?us-ascii?Q?6rV5QOzFg4kEot6yQ4Vc8yA2/hV6xnQgjEadkMjoJw/QMZBEcvy5P6JVlV3d?=
 =?us-ascii?Q?RAay2+a2t31GpiJ03fPo0NuqFhlJ0jPsP0ilh6wNBqbtOoAuCFljv7ELlRdV?=
 =?us-ascii?Q?ALXWTRtXRfux7M+l76tE8qIm22K7fhsGIYCVR3mtrUfd2xHToEPLddu2en2D?=
 =?us-ascii?Q?CDCdwNSMW6YwgrNkYmSPqOH2xpBkSDQmz78nvjsAT4fMl9yY/ZBGNbU3cAHQ?=
 =?us-ascii?Q?a/5skuRp5y97lZZw6gVsZWplA1/yQZttUmgsjC9BmhrXmXs8cNqcyuzxmKSS?=
 =?us-ascii?Q?MeD+WCMyDjnsY9O1r1nX8ClvbcEHvtuZMvdcD9qWZHNC3kHtPUitWf7dwENu?=
 =?us-ascii?Q?YZjZc04ShNc4+nMR4vyZHWHPaNellKX2k97XjWVw4lqHc1I4qnl1X2gbbiBN?=
 =?us-ascii?Q?IAYbqZtiyJpVVr/tHW+eh6svDs5LUtPUnHpmqJtUXh6LmQJi0AwuRK7BQ0c1?=
 =?us-ascii?Q?sAC2emd0VdKWQtV0Vae23gzbiDQEu48iUnm7r7rkC/U3RuYwzb3yfM1qjJDt?=
 =?us-ascii?Q?+oympsrSX1MY4UeO9YWAohFlEUiVW0pOIR1uZsh7l39IHogZ2R7Q4wZ/sihL?=
 =?us-ascii?Q?F6xCD5nVAeAH1YRH5rYzVEHhqZb74bBN1uwMy1KQ2wFYhGo0gRe+laoE7Uh6?=
 =?us-ascii?Q?yEQvL4H9Pyc219u96LfdaVXkfQbwQz1C1AiZ/ai4LClfwm94Z5m3JpZJ0Di6?=
 =?us-ascii?Q?4Es8a9qy5FcDAny0/fdMm3W2DQVI3+VDSm6tYUZbLznbEUj7qGVr9XSmQP1z?=
 =?us-ascii?Q?ERdsZlCGQFkDFrs9wOmR6rMXhyuIxC1kovA41MpP?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gkeNiepovnIvmrtKvaDRpALBRYh+KWvP9C1ViyizkxoqXLSnhOhavLMeKzHE7Kf3rTi5TivMH1bu90glv0x7aKb7JJzgdq7pZpXtYg4G1ONGvRfuVU0vNwz8k5vRQcxXqHF9uOKBWnIZVsRPYCpzAa1hNY2tPS/vHNQ+4w+GhI0EOiqbv3QSt25GSpAG2AW4Tru8izXOkwKXbxQmgnJdcNFUTUM+dq0UHWtBcR5afRrmi+q7W0fBZIrwWs5mB1pbN0WEEhnPaJnwk9c3FJsqy5VgZsneKZJuq0oVKLQs+KOm7CqzgTymZQ76YgG/RUMNocJBa84ah3DEdJb8eg/d92WM+/RfeByszki3beWtaScUlC6L4cO/z+bauGnqD5b+f+v0lMv5FL4m52sd5109tFPzaYMs0LH9/p0VpSaoegcXm3QwPwVTN7TituPDifdQvk1ZDanHYFgyU+ABrktGj8EGvozhjmWluSwdx3DbFIbcIShqhjJA2tDfoZa5vWLZu9/L/yJAaFPI7RplrK2FLvLIUU7rl6edRVgWoGMfEjGbBsGnsZINxbafFdflb5BViJ5z+PR4xjxWodInjdt0SxHvn9Wk4nE6QgKcK6LkXwU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 197dc4b9-faf2-4f15-f9ad-08de15296500
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 07:21:06.8732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gQntjGUUl2lauhO5IbOF27ARrUuyTn/dWYUbdOHx7MDJmuCVG3dfua+lbpu2VOy5y5opL77gMCDQbvakwD2y7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510270066
X-Proofpoint-GUID: a6u_QsXN_4jhgIk3dpjj1KQPy0BrEaQw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MSBTYWx0ZWRfX2UFeJSMXYXX/
 DMID1sXWi3yWrJmZbliYPnW/dXXYnYVOzrOw/fHmBrLICqvSb574U6Xp7tqWMR/P6+xALkHGGdg
 Fn8Ddf/Lds4kA4nsVBRAuayJaZ5DnyWtUtSGpDit5DYg0lyNsFwDDcWAmCi4IqI7INHOVwhaDfX
 TPLYYxNBFO9sHfHhTC4J7R5Yn/3IZqqIEv9wjVpk7nI5kBImhRpEAYcku9JtmuRygifrpA0l2Ef
 ZFTaSrUCs0JxPCOvz3hOcRRgFW0P18Fl3GIJISfZiIZu8521khpaqBkWFv/DICw2rC6XgN2oIGb
 6r8iduTFLYvs9V03fn5au187Jowl8nvYx5HpJ+2URH9x1Mba+eQ/RlxpaB7u6dj3wUXdWSO99yl
 YNDNWFDqPwuEjBH2n6urlFohtVfN+A==
X-Authority-Analysis: v=2.4 cv=Xe+EDY55 c=1 sm=1 tr=0 ts=68ff1d67 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=P_QNuhrjIwveUDUciLkA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: a6u_QsXN_4jhgIk3dpjj1KQPy0BrEaQw
X-Rspamd-Server: rspam05
X-Stat-Signature: rmdjyhswtw7rxo3igyoigqydmnfofrsh
X-Rspam-User: 
X-Rspamd-Queue-Id: A529920007
X-HE-Tag: 1761549678-162129
X-HE-Meta: U2FsdGVkX18FF5AOKCF7d6dbZsnSQS8fhFQBuu9zIGAfM2oaSTkI9NxNDY3Wt2f4b3nwFJGugD7RWhrFClnnTX5jq94o7bY6naabg10B1/ccv8/svmIWWRy/31P+gIK2lPDDUYoDWiPfU3uq8MP6iwkCJij7wKIhwjzpqBPwMA4DRYC772ZsL5eAO9odCWwEVJJSlrOL0Mkt/F/cq1cHmjArVjpCNwHwo/R+j+lkDoL2pDt+cGqGl806e8/G4CAOSsOa0oQM3vSLxXbNSzu3DKRKDbnJfPqsCbS+YOmoyd3L4Jr6dqvq9hJpNXJdq9yS9Uu/ilrsscjn2VmXcywahUzvgtI4FP9YDbcplOocPvBFqpI5ctSjIZQxxrPisbE8weZJBj6R0hfjp+bR57Aikfd9zorsCQckSMWV0piXjR8rkkdBz+MIOPg7wOJaoIOS0KhsyXK82b3fv/4Y/cg1y1OUS6CJoEyfOeRJ71bjrOARFrrGzEfQmnG/pmMDIzwmi3849sh9E8iUPB833TtnqZCKxCeTJTpi/x0WFo+x8yVm1g19G1jI6OCa4li0g8sI+qEubFctJFI1mik/tg1SK5r2tgkWbl7ckHelJIGr74nWWijLtPihjFzvCI9U0pKtSFKB10ee4Ro1dzI6jKEwHj5UImb+N7AZ46hnPE5aJaYZ2zHkhKGpSg+T4nn85yCQEdQxkvd4YnQa1NLtiEBEBW+efSS/pwhg+ZtvdDs7SWiYAN/w54UjHCQkVbTd39NrRPIWfaWU5v5xY14lAGYGFABhNaOxJKVZMl8vxzZ+7ZIIc1Z+A3+BK2ITQJQlabzj7wgmD9lQyAfBP4ZKZdtNKA3MIYxlT9QIk2mFGG44Zgx3sVImIjq6czAOM2PzN1XdnOmFxHkEVMDfuk3hKKiVLzl15EDYehbpLFPIsEQHJ30Hhp7wqCXSY3xQFYVBPic+oi5tW+iVmfdXc8HxfmA
 E7FPs0V9
 Qno7VrSbkvKUdelsnhWhLWH1NKfwgAnFBwu+trmWJzjHxYbF4v8ITZg+pztoiCOX1MEQmLKpSg7+U77IWQoVxxc92YX3EKVuRfCxcGjcqvDyUMXlfpEkRLGKPDn3YZ5YR3brVKUEMFbs4V1BstOgcM9CQ9BkO3gleYv8w90j/5CkYTW3X9Z554gvOERRd3Ovu5aLwHb3ZeNG4Iu99thl6GKqDWCp0oVZoEcdPcKAQhmfoyNtwnbOTvFx16D/yubVd36g8F6txxWHwTqJ3yPaUg9p9c0SNyPslz7XFhC4rBqnW1K7BTidp1/9wLHm/6knAuPmY23W96CtAfHQBjP0Ads0T/HGtkVVdsxVhFkTj5aaFOFDDeixi2eGHXY1kTgoGSMSTkHVP6TuAxXsFMwtQagl0MTkSjJkohbKETZPhMh0PIR1D5QezDr3CFKXDWIetPffIUBTTOQ90uQGIGY7J9yvZk1XpB4YrFr0FAr3py47jZnR4gs6ZBO5MgjH+gC6BIwV4RjEfZ1pP82WVgWWB2ULRSHiNeV4vgEcyjI/SAyxfpBsPRxaEDUR7KJlfTO7paZAKDbPGCVIR2NK/xKAhmB17OGMhOKoT+v+I4IznZ9H+QHXdSY1+hH8SxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 03:52:31PM +0200, Vlastimil Babka wrote:
> At this point we have sheaves enabled for all caches, but their refill
> is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
> slabs - now a redundant caching layer that we are about to remove.
> 
> The refill will thus be done from slabs on the node partial list.
> Introduce new functions that can do that in an optimized way as it's
> easier than modifying the __kmem_cache_alloc_bulk() call chain.
> 
> Extend struct partial_context so it can return a list of slabs from the
> partial list with the sum of free objects in them within the requested
> min and max.
> 
> Introduce get_partial_node_bulk() that removes the slabs from freelist
> and returns them in the list.
> 
> Introduce get_freelist_nofreeze() which grabs the freelist without
> freezing the slab.
> 
> Introduce __refill_objects() that uses the functions above to fill an
> array of objects. It has to handle the possibility that the slabs will
> contain more objects that were requested, due to concurrent freeing of
> objects to those slabs. When no more slabs on partial lists are
> available, it will allocate new slabs.
> 
> Finally, switch refill_sheaf() to use __refill_objects().
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 235 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 230 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index a84027fbca78..e2b052657d11 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3508,6 +3511,69 @@ static inline void put_cpu_partial(struct kmem_cache *s, struct slab *slab,
>  #endif
>  static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
>  
> +static bool get_partial_node_bulk(struct kmem_cache *s,
> +				  struct kmem_cache_node *n,
> +				  struct partial_context *pc)
> +{
> +	struct slab *slab, *slab2;
> +	unsigned int total_free = 0;
> +	unsigned long flags;
> +
> +	/*
> +	 * Racy check. If we mistakenly see no partial slabs then we
> +	 * just allocate an empty slab. If we mistakenly try to get a
> +	 * partial slab and there is none available then get_partial()
> +	 * will return NULL.
> +	 */
> +	if (!n || !n->nr_partial)
> +		return false;
> +
> +	INIT_LIST_HEAD(&pc->slabs);
> +
> +	if (gfpflags_allow_spinning(pc->flags))
> +		spin_lock_irqsave(&n->list_lock, flags);
> +	else if (!spin_trylock_irqsave(&n->list_lock, flags))
> +		return false;
> +
> +	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
> +		struct slab slab_counters;
> +		unsigned int slab_free;
> +
> +		if (!pfmemalloc_match(slab, pc->flags))
> +			continue;
> +
> +		/*
> +		 * due to atomic updates done by a racing free we should not
> +		 * read garbage here, but do a sanity check anyway
> +		 *
> +		 * slab_free is a lower bound due to subsequent concurrent
> +		 * freeing, the caller might get more objects than requested and
> +		 * must deal with it
> +		 */
> +		slab_counters.counters = data_race(READ_ONCE(slab->counters));
> +		slab_free = slab_counters.objects - slab_counters.inuse;
> +
> +		if (unlikely(slab_free > oo_objects(s->oo)))
> +			continue;
> +
> +		/* we have already min and this would get us over the max */
> +		if (total_free >= pc->min_objects
> +		    && total_free + slab_free > pc->max_objects)
> +			continue;
> +
> +		remove_partial(n, slab);
> +
> +		list_add(&slab->slab_list, &pc->slabs);
> +
> +		total_free += slab_free;
> +		if (total_free >= pc->max_objects)
> +			break;

It may end up iterating over all slabs in the n->partial list
when the sum of free objects isn't exactly equal to pc->max_objects?

> +	}
> +
> +	spin_unlock_irqrestore(&n->list_lock, flags);
> +	return total_free > 0;
> +}
> +
>  /*
>   * Try to allocate a partial slab from a specific node.
>   */
> @@ -4436,6 +4502,38 @@ static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
>  	return freelist;
>  }
>  
>  /*
>   * Freeze the partial slab and return the pointer to the freelist.
>   */
> @@ -5373,6 +5471,9 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
>  	return ret;
>  }
>  
> +static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
> +				   size_t size, void **p);
> +
>  /*
>   * returns a sheaf that has at least the requested size
>   * when prefilling is needed, do so with given gfp flags
> @@ -7409,6 +7510,130 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
>  }
>  EXPORT_SYMBOL(kmem_cache_free_bulk);
>  
> +static unsigned int
> +__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> +		 unsigned int max)
> +{
> +	struct slab *slab, *slab2;
> +	struct partial_context pc;
> +	unsigned int refilled = 0;
> +	unsigned long flags;
> +	void *object;
> +	int node;
> +
> +	pc.flags = gfp;
> +	pc.min_objects = min;
> +	pc.max_objects = max;
> +
> +	node = numa_mem_id();
> +
> +	/* TODO: consider also other nodes? */
> +	if (!get_partial_node_bulk(s, get_node(s, node), &pc))
> +		goto new_slab;
> +
> +	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +		list_del(&slab->slab_list);
> +
> +		object = get_freelist_nofreeze(s, slab);
> +
> +		while (object && refilled < max) {
> +			p[refilled] = object;
> +			object = get_freepointer(s, object);
> +			maybe_wipe_obj_freeptr(s, p[refilled]);
> +
> +			refilled++;
> +		}
> +
> +		/*
> +		 * Freelist had more objects than we can accomodate, we need to
> +		 * free them back. We can treat it like a detached freelist, just
> +		 * need to find the tail object.
> +		 */
> +		if (unlikely(object)) {
> +			void *head = object;
> +			void *tail;
> +			int cnt = 0;
> +
> +			do {
> +				tail = object;
> +				cnt++;
> +				object = get_freepointer(s, object);
> +			} while (object);
> +			do_slab_free(s, slab, head, tail, cnt, _RET_IP_);
> +		}

Maybe we don't have to do this if we put slabs into a singly linked list
and use the other word to record the number of objects in the slab.

> +
> +		if (refilled >= max)
> +			break;
> +	}
> +
> +	if (unlikely(!list_empty(&pc.slabs))) {
> +		struct kmem_cache_node *n = get_node(s, node);
> +
> +		spin_lock_irqsave(&n->list_lock, flags);

Do we surely know that trylock will succeed when
we succeeded to acquire it in get_partial_node_bulk()?

I think the answer is yes, but just to double check :)

> +		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +			if (unlikely(!slab->inuse && n->nr_partial >= s->min_partial))
> +				continue;
> +
> +			list_del(&slab->slab_list);
> +			add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +		}
> +
> +		spin_unlock_irqrestore(&n->list_lock, flags);
> +
> +		/* any slabs left are completely free and for discard */
> +		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +			list_del(&slab->slab_list);
> +			discard_slab(s, slab);
> +		}
> +	}
> +
> +
> +	if (likely(refilled >= min))
> +		goto out;
> +
> +new_slab:
> +
> +	slab = new_slab(s, pc.flags, node);
> +	if (!slab)
> +		goto out;
> +
> +	stat(s, ALLOC_SLAB);
> +	inc_slabs_node(s, slab_nid(slab), slab->objects);
> +
> +	/*
> +	 * TODO: possible optimization - if we know we will consume the whole
> +	 * slab we might skip creating the freelist?
> +	 */
> +	object = slab->freelist;
> +	while (object && refilled < max) {
> +		p[refilled] = object;
> +		object = get_freepointer(s, object);
> +		maybe_wipe_obj_freeptr(s, p[refilled]);
> +
> +		slab->inuse++;
> +		refilled++;
> +	}
> +	slab->freelist = object;
> +
> +	if (slab->freelist) {
> +		struct kmem_cache_node *n = get_node(s, slab_nid(slab));
> +
> +		spin_lock_irqsave(&n->list_lock, flags);
> +		add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +		spin_unlock_irqrestore(&n->list_lock, flags);

If slab_nid(slab) != node, we should check gfpflags_allow_spinning()
and call defer_deactivate_slab() if it returns false?

> +	}
> +
> +	if (refilled < min)
> +		goto new_slab;
> +out:
> +
> +	return refilled;
> +}
> +
>  static inline
>  int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
>  			    void **p)
> 
> -- 
> 2.51.1
> 

-- 
Cheers,
Harry / Hyeonggon

