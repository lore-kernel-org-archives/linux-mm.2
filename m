Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5124ECCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16098E0064; Fri, 24 Oct 2025 04:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ED498E0042; Fri, 24 Oct 2025 04:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5BF8E0064; Fri, 24 Oct 2025 04:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71E618E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:54:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 105FC13C35B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:54:28 +0000 (UTC)
X-FDA: 84032396616.10.9967536
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8FCF2A000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:54:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hySy19yn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TLO8iEck;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761296064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/aSIcv7WNroNa9Tko5OpgHXBk83LP56Dx/vAAesSD/o=;
	b=ZJRX0U5snQM7JYcIno1jCSDSJaomTqws4tYo024wCTGDmJtUn7Dz/eqPKtOQh5nX3rdosm
	3woy9tipSSElPwqVg00V+1ev5oLoPlPfkKNacJko131CEooqQfeyCtichSAOoWVQD+7YmY
	8XA189JB9Ni3Lf3oTsSPy/KoW1MVukY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hySy19yn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TLO8iEck;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761296064; a=rsa-sha256;
	cv=pass;
	b=cDTAxYdfZwcSrm2GYjT/tTTwiGIDSfxOmXMLmHEOKHyBBZzdPTVF4E4LAzOJIpPCrqIF/l
	I+qodDHDIWcuVWQ3WHxNrd7qp1K9e4hUGwOfnnJ+wC6v9XjwNhP0N5HvEhlNopwBLvD8sP
	oyJ/kFsLiPAI5WWjVG81fdos59bnisk=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59O3Nwsi029460;
	Fri, 24 Oct 2025 08:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/aSIcv7WNroNa9Tko5
	OpgHXBk83LP56Dx/vAAesSD/o=; b=hySy19ynMaO4p4HtbA6LnOptHcOc6/Quae
	UcT11KP86/T6Q0T1+mJzW48W6miZFc3SdosoTNTcesWLqnOL8uWHKQa3lEadtxcD
	A3DbWuHHqDTlmkpESGvExM1IzY7hA1xYf6cIPCw1Z/6Bk6ZX1ZofjaUp/RpOzJJo
	4JSH++syRL9CVed28ye0kXul6u1VS7imbVo9pgEe/yn75kLVO4U5MM8gdzNQV6lx
	HYJhB3mLJIIlj60DDaEcbj4obF3AEkFPP4FICQWRhTgLgj2AC9204+jGHV6MkegA
	ZdJ0O/dq1vkb/fR8hzke4CKas2IEtHqIVa1BIYI1vWhZcZU/1KxA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xvd0v8ny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 08:54:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O8UU3Y012587;
	Fri, 24 Oct 2025 08:54:20 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011004.outbound.protection.outlook.com [40.107.208.4])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bfn7ub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 08:54:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sNQEhhl+7cpHcnX6ZVngOQA4nWbBPTmes+hYvjJG3AoVnMEugKqsBdMkhKUBLJzkRaNtQ4e1CbVlzFz5jGCrg4i++6feiEZLIqUKIrvGCNGcpQkcvBgIaJNQKQSA3L1lz9F2vhlj4D4Yt/G0XOrDcGQEgWuKRb102VolchzXa3Q7A9grsUUKTGhjK7M4os6kyR3uiHrXpA8bV7N12ynuAD8/+GQrpEuQYKwaQiZfq45XWeiBNX5hNuJzMp/nTb6vGY/Cxs5ajn4fIwljYO6XuHsTi0VUi3TjGyIjIoUsOAw6P+DmZjM77KB5J+DZXSiwLAsbp52K5/LY8it9ogwplw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/aSIcv7WNroNa9Tko5OpgHXBk83LP56Dx/vAAesSD/o=;
 b=L1A3cIsH2XgvdDg2CE1igP5/CK3lLkCoWPWgYzQJN5OdOcem3LBnf1KPItbeXpYkFqh+loprcuPyW5CwQdzelkctPaamqHaazhELfVDmgXjJ2/IlfCirgVlS+FcYNelGJ7qfjscyRXivnAhFlr0ApW/Xpv6xnPXxeJz3O5ASHcSa9n6lB3X8B/muO44A31VozmO9NtsJ0qu7KmOWi1R11rFQHuGx1Ym4aMvKHALFiUrWAapslLtsqbIKc5sEBRiE5Q002Oro8z084JBCgTWaohIlBPoHVnox9WPp4+xS0ShMBO0gY5I5oUTPD2kj7Xn4BY0W6tpyreVj7+9BSUaizg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/aSIcv7WNroNa9Tko5OpgHXBk83LP56Dx/vAAesSD/o=;
 b=TLO8iEck/FOZH9ea/sbbYkckDrcXm8l/18eYRoUqUy3qhAgdS6Gm3WeWekNPBVF+Mw0GwaG15BH8mVvDli/efB3oTpisDI/z9EIkNGtKWE6MAgmisLYdmEcMvfeTPTDYoozkujddn8vdQhEOmTfAAtWW+BukpiFiwwFAIKhEA/Y=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4673.namprd10.prod.outlook.com (2603:10b6:303:91::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 08:54:18 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 08:54:18 +0000
Date: Fri, 24 Oct 2025 17:54:08 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
Subject: Re: [PATCH v2] slab: Fix obj_ext is mistakenly considered NULL due
 to race condition
Message-ID: <aPs-sKOJQs-OelVM@hyeyoo>
References: <20251023143313.1327968-1-hao.ge@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023143313.1327968-1-hao.ge@linux.dev>
X-ClientProxiedBy: SE2P216CA0175.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ca::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4673:EE_
X-MS-Office365-Filtering-Correlation-Id: dab4cff6-cb8b-4cda-2a95-08de12daea5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QQZXj3JjiyqYGDH/DGJCrtwxNh3G69lrBQfrYJfjAfpkJ26VaaHgLEzFrWpf?=
 =?us-ascii?Q?vqgSVMBvZjFwyeVx857K4imvRwipIGliRZlr86SW04QzKfMZva5/qMb+dTnh?=
 =?us-ascii?Q?IbfM34R4V+9amZ8n6TCkda9pckS3X9jkkKhK4P0WYgIf3EFwDdjo8KOeOZh3?=
 =?us-ascii?Q?KRIEgTrD1VWALxqtcORdq+1ecamSkrhoKdXt6dxF37y/fBZx0vv3STATWE8p?=
 =?us-ascii?Q?sUz+PPcT/1Hb6lvnvSHZ5JPvJd1cC6HH2GKV4Ekm2/qszJnI+HIXCrDnOfuo?=
 =?us-ascii?Q?7Ij08stZJq7GNIxX6AjB4LJkjnRGjcEXi2UTrcDswcxeJ2F/2yGfcWJFSgL0?=
 =?us-ascii?Q?6wsWxRAvcdn9UTMtOH9G7VsjP2ASiG9fWkSMrt9Cxe5lPD4H7+HJ59rFdmFq?=
 =?us-ascii?Q?+usOpI5oJW38xTRGUjuruPpke70vvnVNIivzJSG0gei8JPosdoqHu23VD+FO?=
 =?us-ascii?Q?pNinJOdCydw4BnxiDXApVGz8v361+uOG9ZLXOMz05wdITRW9R6xWaEnP3Vof?=
 =?us-ascii?Q?DWO73aAocnoW6qBwMIqJu/qSETydLCiG6HMXQc4kPYabgQXc28EOaIHNwgQy?=
 =?us-ascii?Q?KiKn/SyNM+MQiHljsIW5OAe89e+rrrzvZ0u/3zqnxX/18ZS7qpAd8inD6U0v?=
 =?us-ascii?Q?QdLdFiYVoJWs/iDpAg6kH3lqt2K+TX774jP7G+zEhqNhifFgjr480B460Q51?=
 =?us-ascii?Q?9ZO3lTuXFeB3/iswlk9AWoKitXcyL/5xES3U30idlJ5kLGGzpq6ExddyrhnG?=
 =?us-ascii?Q?XpdQjcD60G6ZQHRbocxXD41iCiMRVcJkp9qrYkJsIPup6RnIDUYrVGOvA0S4?=
 =?us-ascii?Q?+RWWCoEkX7k/RCpeuqarqaEPMaC0JpNFSWCofKWWXV+MbhF1jhz+s1qbPvym?=
 =?us-ascii?Q?mBEElCP3wiFrZA53GykUGjCFgzQ4HBeHNIyK20TQJynnr9mo3Jv1J9U8dzSk?=
 =?us-ascii?Q?VWlVyRHO/uMCz4j0WNwV1mLl2dPQyb0fpP/0dpUmc1B2XPBwh4+W564u325s?=
 =?us-ascii?Q?4jJN4s3rT6PH5IiJSp2sg4UOnLp89Ee0JcSPW9i0CM+6kInjBwnrzwL6kG3y?=
 =?us-ascii?Q?HpiBU5oOOPMJqIDtxUi3vWdpwaLxoZ0uRiNG9snD0d9tIVg+N29oXH7CLxSs?=
 =?us-ascii?Q?KX6xxCYh/qyimWeYQSiUEKnObN3BFqpT/XLA4Y31V+Um1vs+qRACwkQr/oXG?=
 =?us-ascii?Q?TKyF1nMCDh4j10ENRAleh2X+yqOcwCff7kXN4Jd/wFylmL88SYAlHhyfBoNv?=
 =?us-ascii?Q?t5jNMsOCGiBmFq7ZFHYaeRYOXbp6zW9uaoZGxrztHVW8GBxVYLK01Ndkg1Ta?=
 =?us-ascii?Q?6zabd2+IW3KEmnUA0TKdam56AoMGpGm9EG7JHlFJ0ecteCq8e1olv2dPKq/+?=
 =?us-ascii?Q?0QbcXBeZqKPymKQzyR/nr79PkafTu+U4aGinoihU2TVQaKJy91A2HPJBlvjJ?=
 =?us-ascii?Q?pf5BcYM4JF8RzrFJhHxdLbbTjcLevZEs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q32foNOhXIKp7CPXCWXVGQr1fImyG30B+7oqLb6QubQcxnBmPEVWN3xD6XQd?=
 =?us-ascii?Q?jdI+EVOHYzV5R4SBq04dGz48o/AshqbsYQPhI5VN4l+8f3DqnWM0YdnkX81q?=
 =?us-ascii?Q?kHP6+vXlZPSvIIksIRGnf9s9mHgIUQ1yjqIUJgxvtF/LQwNVIYwcbSsMXI/r?=
 =?us-ascii?Q?5HyfDkH/RF3yCEKWnYR2WeHxTCJ69k/yfdkEwQEf9fjEyQjKqrXUzGxi6cL5?=
 =?us-ascii?Q?Uv71n6KzMzVbgzTisSONuxNYD492g+Yh6pfgJ8IxueEv5aNYPoqqAQxDq2H0?=
 =?us-ascii?Q?9zj5gdDXr6xNPXZ39lGGQGlw0CRr/TnP2JxiTZH9OG+MQ2Z5qh7H8JTi2D6s?=
 =?us-ascii?Q?aKcMBGUwYfnt9fVchctbpXgp1g80JTHHVDeLRpzFx9LTBpXloWwb5cUrmX3z?=
 =?us-ascii?Q?ZFeoUFrX8KQg3BXQPcc9Ns6HPn8Ex1zy2XspmAR/vksVl2nvJZbnYSR+/ntw?=
 =?us-ascii?Q?F8uL8uRlYwsVGVQlDN9pJxCG0bDeaLnfzNhl0NnFfuogQtX6tX6Wu66o+KuI?=
 =?us-ascii?Q?93cJteh9wKJ6b7PmF2rZkzkYLQxqJIu30wX5BF9Fl6AdWZVkwL8nWwzAjx2P?=
 =?us-ascii?Q?B/OkTdYZIha5mpfVr/nwYQCuPw2wWqibgO0bhvfasK4oz4tTvHAHdsjGCaPc?=
 =?us-ascii?Q?ihICb1+dWz3TfHaysP+ih6hDll57HeaYXxseeFKK4jbnr3zrdtb3kZWLLzjU?=
 =?us-ascii?Q?U2/UDYY9XbsO90FHorLar5meLN10eBdtm/pleq7qgdKjV40g9zXMDRTGkcet?=
 =?us-ascii?Q?Z8Kt5j46OmjRC7muwD9uR92nJiN2UC+kbviggHdfVFddo3FkJFHsi5kmng2U?=
 =?us-ascii?Q?zIqCvjy/3oD1uwCo1NIrjt9cMhu+QcO/wcsq6LFNijyS94Zz2PtvgBZ4/BsD?=
 =?us-ascii?Q?2RFD9971Vh13ZUInvPYgxXKsYNJLiq6Rpoid5PY3Ll0UQOlPuh6S4WqDRfV9?=
 =?us-ascii?Q?i+sLjvatdXhbw2qUIsKJCZg3YMcdKgunO4xBIpuFWCtGTYN+C+xmAkELRzAF?=
 =?us-ascii?Q?DaD7lfd2qdFk+YFwxD4si2QxD/ED0YN/VcjOy8i0YGSCOz0/rW6g0/cpXt13?=
 =?us-ascii?Q?9mpXDXBVEJpMhor7UURyOwEmArmkreBfPcfWnuWppSCwLr5DrnZWJSXkIqeO?=
 =?us-ascii?Q?H2t/D12MY/JM81kkV05xY5DK7I79ewaitDSe6owZlAqNeXVFUSRPkvrbqQXf?=
 =?us-ascii?Q?19HdvkwN9XjDDEbQF0mG9ipN/SsYY0uUeCx/ndXlqT1cfFC8FhNn2Byn3IGk?=
 =?us-ascii?Q?QxK5cEIKewdMG6em/WLnwXQgyZGlNeEegyLeAGBMAJVdk6mgculKzt8TtuCN?=
 =?us-ascii?Q?iCbjYN8SpXRG0J8+6ppaEJkFVEXRtWQgkXJ/jVtcII33vwFymJ8xlw8H/dkq?=
 =?us-ascii?Q?ly2QxVhK2oMOcrL8lEplm2HNJcd6P7Mz4QsglB4K2YPGTvmkdDMjki2NMxV2?=
 =?us-ascii?Q?uD/tIq7kMJnw8ufahxDnudd5dKTLLtM7IJZ5AgYdrvMLQrWEk+pkh2OpZHpK?=
 =?us-ascii?Q?qXfjDM2MNr0WsjImfcvJ0YWPRNWNV06e+Azs70zsqZ2aB1U1mnODYgDTRKkk?=
 =?us-ascii?Q?lgcfnfHoms/8Am+PxQAZUiJUe5NdpkBN4R7b9nsK?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qqInB/26ten0vv6wLkXGXxHIgLn97GiatAR1DS3EL+3OmGFApKTCvWsDYEG7On11Unt+8kMRtRKYeQJJhFiAjpD6Kcqi8b1bk2nPRXasct7+okXezyYktFkkK0FMizez6p9b0Q6LayT5qtemHtOxV27ajlGK9+ceWhw9KnndBb0h/JUCkizk8afKnLMlJ4XJtHhe/4lE/HzzFXXeN2/ig4Q3X7JcWDb5UZKx3ehGBEjz8F/MGLcRrxWSkj+3khbrYiWcqn5Fijne+tXxp2mHAhJsCDtjnVb5vc2BwVkvlZWpid451kuOhZTlY64H/j2gafFH/qv43ZQCvkEweJUH1FFZOUF2cyqcItYhdWgBYblk6cq3aL2H3kGsxmicJZ9sUdNGvFMsmuO7nafc34BKsCk0Sgc1j1eDXd1xOE+kvwW3ba1IrMSK03sgViWNxEhwz3+Q3pEvIEZ+BsdUr/E8HTni6wRN0SR73uLFvU3VbvhwIZkWZ7sadfcdrH8LpjsB7EwIK/aL2YwMn3xHJGq69VLOZVbe8CF4UOPckHtFeWV2Ye8/kdvP/CtiUN0ubz6nBUNB7TwzjAjHPbtfiU5krcBjNU388UgubipHFUwytQI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dab4cff6-cb8b-4cda-2a95-08de12daea5a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 08:54:17.8669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zn+TBdNUgm7+jjYCpAIQIrnaKkgKiT8cIUNRfacC0APJgkoDCN+/lGRSuDo3LODeHiHpY3F5xim0hGmAIw3gTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510240078
X-Proofpoint-ORIG-GUID: EEQLOMIV2MLD5-teB-v_pVK3kEXTzlM8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MyBTYWx0ZWRfX0Kh6ccKMFBeU
 hIg7z2fuKQohU0wY/a6ZIWWBm4Z1w52L2/50cgtUjfXXRoUnzjybVMUpirxI9S7qWbOqg2dF5Ik
 GKYatDX+9cHSo1unNUGkYHhFEQcazThJoJ6Y7w2IHQQk3dEcKjIDjdW6xuy09urTKXL6AD90x0b
 TBQS9Y3fk7ACU6tLdcVzYR0+RVs5isQG0AI5ASAFoaGtkzH3UTSqrL0g+ij+4wlnJ0r2sQ25u62
 puQ2tHKQjyEvKx6JK0TC9r0td6QTc5rOpg8j8Uqy+cw4+u933PaThVB8fWD+gStnC4diKUQkEsg
 EiNz+wVNNpTf4J03clFd82rNniW+dtP0x4HhHLdlG+HlwrFW4KFl5fwojAMXorEwwYMQtEJCey9
 1tkRrxTXEdA0KydHnDeFABnXSJiICA==
X-Proofpoint-GUID: EEQLOMIV2MLD5-teB-v_pVK3kEXTzlM8
X-Authority-Analysis: v=2.4 cv=D9RK6/Rj c=1 sm=1 tr=0 ts=68fb3ebd cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=sitr5_EQMP3H33YetgoA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8FCF2A000D
X-Stat-Signature: 4ccqrcuj4f4e7q63ge5dttphg3o94hjj
X-Rspam-User: 
X-HE-Tag: 1761296064-494085
X-HE-Meta: U2FsdGVkX1/wS6mHogyh7VbuQD2MimuW7hh7WWZFQ6CMAD73HItx+FW2wqDeMiZDCIRSDpcMRGj5LEQqHmGnq2c3raJbfR6iGF3QT5PyC2D8KGuOtCRwR0yghjv/ux7yjgh9zMqXetxk3x4Zs308Thr6FUvzAHKX2cUfpigtM8eU01I7/E5OoqzgItDKf/Xw13Z4ipTckg75iiwz4SSnPYdDt/gZEOaoPpw5zBri2kCq1DPTRYaJM6GYL+JEuxXC0OdBetZ4hPY/rCmoRqwvHbmzaPNOtKPPFMb2Y6OZnb9zd5wQkCealbwJlBnrbku4BfSnztR68bkKObrToqYVxWPJGsCfVJsEb0iAtasH9xL3uXs8cynmCxmTUu1oC3AEeyDdh4mVYMOA+bTzCoNd8rhhioP+X56fOpavqri0u40uwsFUchUDc8stNEWt+yO7qFg3k/1QMzRE5Cftp9tqyln5nByFo57tzvnaa1wxdhix8N63lOEnsulPzMUi9ba1XC4udIcO2DY4mCi11dlBzvs83CZocmKBa1o7yReLO6PRc3gjRZQ5Te4X503v8Ad1JS1mgVYUx2hoZ4/64U9Nzk2p0DXpQAkt1FRuNaXtAVttdikPaKMVSEwfCuRtnJumUS786R4Yf1drQO+CAvpk+g5kT3SY+EbUNsfgCj1y4T7M5jJU3RgXx72ngNkK7R86EvxpkMj/J3KzBMDZT1HMsA71Xf+6nLOJIh9K9Fu5639ERMOYo8Szpx3OnIqGMmKR4N7bykfFJ7xtmqcc63p88RKfJlALdMUMMwUNx9E3Kr3ydvU6jBISSlvdtL8n1KBpbWUyV8oJnAhuey3JV5ViXnTy44EUetbrc6afA0Umm5q7a0+Uc8vWs+8yeLDkPnu9jLkZBECH4YWF/Q6nQxfwSEdyQ5prJUKn0nmUyFCQnPneIK7FZxDCxqGoXXa9VT0v1rJXvi+68+9mRxi4gkG
 YifiW/wE
 2mJLyHZkxZ4S26I0G8wXviAhUqokQyXQy6BziEXoC6OooSo70Dyjun/oOEmbZSE0y+OKp6qzeDePt3k3GDbAZNws2sA9naFj/BwWVHNlxPIZD9MiyWJwyapZ8T3uGK4YLf0vLaKmGqJIxMtdWiRbpvCcDQ+xw8zfUdEY6lOT2om+hoEyoYEUFcMXhUG0HJDWciwfluWn+YaVBHVeZ7XUyAt9PGe9dHf50Lq83MpLEBjdTKUhDNcKfIXlfofQxBdBVwwJveqJEZRlHElb5hZVEcq9K6ag4CG6sx05gc+G7jarQ8L5esPd8SSOLCHzPzTjGnNOY+NFMkJIqzyebo1J82ywbdAJTOMdZn1Icr2jpXod5DqMf7lJnO4xuLApadO1a6IlEyVYU9QX5IqqohR0/tXPNOQD5FPsfKtl2yCfu50KU95yQPpEIns7NRdZ7cOW8NUhhgx6/omFhs0W7pykwiQDEm3CNWD9aKbMU72GbVSgTiGAlTM2A609ueopUvidPapCel4T3S0Z+5dJdM9jTtJbr5EhSLMzRPAgT+tL63JMG8JIttYk/lVqa5FwSQBuPM/zBqF9Qed/Y/I4gS492eQcO2xuPwqtoSqeUHOJdOYO3+vqaT4M5NRXnLsJCdyha7gutdYqNshK9lXyEYMNF0cQETu+eCqAbCOo3GF3UGhR69qoFMEqfobPVPZUPc5l7lTDUcYGB84BDWLcK3ood/0o+MXHCibRgloifFI/ULl0dDUF4vhN35XxojbhM8lpuPkLN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 10:33:13PM +0800, Hao Ge wrote:
> From: Hao Ge <gehao@kylinos.cn>
> 
> If two competing threads enter alloc_slab_obj_exts(), if the process
> that allocates the vector wins cmpxchg(), and the other thread mistakenly
> assume slab->obj_ext is still empty due to its own allocation failure.

Massaging this a little bit:

  "If two competing threads enter alloc_slab_obj_exts(), and the one that
   allocates the vector wins the cmpxchg(), the other thread that failed
   allocation mistakenly assumes that slab->obj_exts is still empty due to
   its own allocation failure."

> This
> will then trigger warnings enforced by CONFIG_MEM_ALLOC_PROFILING_DEBUG
> checks in the subsequent free path.
> 
> Therefore, let's add an additional check when the process that allocates
> the vector loses the cmpxchg()

You mean "when the process that failed to allocate the vector loses the
cmpxchg()"?

> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> ---
> v2: Revise the solution according to Harry's suggestion.
>     Add Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>
>  mm/slub.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index d4403341c9df..d7bfec6c0171 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2052,9 +2052,9 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
>  	}
>  }
>  
> -static inline void mark_failed_objexts_alloc(struct slab *slab)
> +static inline bool mark_failed_objexts_alloc(struct slab *slab)
>  {
> -	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
> +	return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) == 0;
>  }
>  
>  static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
> @@ -2076,7 +2076,7 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>  #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>  
>  static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
> -static inline void mark_failed_objexts_alloc(struct slab *slab) {}
> +static inline bool mark_failed_objexts_alloc(struct slab *slab) { return false; }
>  static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>  			struct slabobj_ext *vec, unsigned int objects) {}
>  
> @@ -2124,8 +2124,14 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  				   slab_nid(slab));
>  	}
>  	if (!vec) {
> -		/* Mark vectors which failed to allocate */
> -		mark_failed_objexts_alloc(slab);
> +		/*
> +		 * Try to mark vectors which failed to allocate

nit:
                                                               ^ missing
							       period
							       (.) here

With the comments resolved,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

> +		 * If this operation fails, there may be a racing process
> +		 * that has already completed the allocation.
> +		 */
> +		if (!mark_failed_objexts_alloc(slab) &&
> +		    slab_obj_exts(slab))
> +			return 0;
>  
>  		return -ENOMEM;
>  	}
> -- 
> 2.25.1

-- 
Cheers,
Harry / Hyeonggon

