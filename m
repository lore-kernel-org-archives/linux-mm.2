Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F2B5D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 11:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31DA96B03C5; Tue, 20 Jan 2026 06:05:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4226B03C6; Tue, 20 Jan 2026 06:05:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2686B03C7; Tue, 20 Jan 2026 06:05:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 047CD6B03C5
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:05:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A48F81A0496
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:05:21 +0000 (UTC)
X-FDA: 84352060842.01.20C746E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7F162C0003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:05:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ElXInDR+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pLu6EmKP;
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768907118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFeDq3wn2J20pB5dv+acCyhG471IbSHYMVaAPuqGkcg=;
	b=bP/g/BBEdhcoSprbSVzZEx7nnIu0EizNClsR5btgemxmmfLNUb9pm2+3e1ukmOTWSV/LDG
	URmUAHimLFk7V2P98phhRwBrHzv17HoBCxUK6DTh+nxKxzPvOlFzwwWYEeIxnAu0GssAy3
	WLQuNVubN+7t/VRGFZbwYhSrDW5xVK0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ElXInDR+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pLu6EmKP;
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768907118; a=rsa-sha256;
	cv=pass;
	b=RNF9PoLG89rxB75roRGOvI82DMH+PwqAvWQnS2r6Jxg94ALBI4zKfL3iWE4pbUxSOnTmF2
	k5dNr4mkB7SeUw3fnqPKnCDhWFVJYOrxvq4xNJcCUNUQjR2KIEmOUZpP3qn7zOVBf7elSU
	laX6YlKvKA0ZQ7n1qGx3ALpKcVNgeAY=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60K7vODN4086429;
	Tue, 20 Jan 2026 11:05:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EFeDq3wn2J20pB5dv+
	acCyhG471IbSHYMVaAPuqGkcg=; b=ElXInDR+aYRkiCgiOE/iXPD3PG1r0BJiLv
	jiMYmeFjLlvUTGDK5Pjr69EGPGCmknjnqQc5UvNUVNm5cWzjPcmtvIP2etvTAG2p
	0FhOYZwQjB18vDF44Kf+YruopHEx5srY6/2I4oD4JMHuwRhD40DNGBemTzptMKX0
	ris+8kRe14umEEnhRvoc/j8Wq0ErQcDbTNnbUXDJfD9mFw3o5d9yB3FQ6djpcRIZ
	zPBsx/xfPZeigye/7NsrcgUWcQ56aMkkkcALcnVH7YepZNPFaKMTUMckwaO3Cwad
	JVNjx++HugjLx2zm8rXBTPGxXtiAoKjzqtaDWG5uueiKJwzUFCyg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2fa3gr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 11:05:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60K9SLkp038803;
	Tue, 20 Jan 2026 11:05:14 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012061.outbound.protection.outlook.com [52.101.48.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v9fsnt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 11:05:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ANBdmrLe9gi1bQJ9Sk8xf978e5LEA/g/mNIwzKl14NjcyqQfQ7bKgoAZwgYWYl8F73XoBSFgJsQ1y2kSGiEEAtg4ll6HadPppYu7eamU8aL9Bi9YmmU8no/rfP5js3wCiBMwomN5/1oXMHlCYmDL5iFhDJB7nSwt56BP/caXX7VW+uwZ+UymhqoECxHmN/mo+S2sBRFvbDb0oxSz8S4vHHYEYKAW0FOHvTzOMJ0oK7o5nhxrfaO28zk/3zS1ZdW6P0oULZ/RIW7Bbq4t9NVMfrEL+zd+5cnrNJyTMUJ97tHP7ZZnSjZjFwm9YzNzKg89Y0A5byL8X/a44RLwcrK1+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFeDq3wn2J20pB5dv+acCyhG471IbSHYMVaAPuqGkcg=;
 b=s/J1XLwcoOKzKG7i9aVFY0JWFgKJxH4wcaXdlIGEv23ONBnfJIELgnrJo/nZUC65xFt4uHe5E1CWQR2CUiiaRWus8eCnV/mLdGvVabye2IXRKMKu6VSE4OwtvtlKJsueM+zAJL5LtjTVV7aB3dL8OjYReb3KYydLGDZJTHuaawHxx9dhq6cGSTgpo3NyvKGfCu4A0T/8GeoJwg/x0kIKi6LSnkxSRudYH+/71XjAVeb6WeMPzvgWJ9Q9IGd71NYbKjJEk2MWKYmzPJaNPC/hos6wn4l0GkhYzK/BFT3GnoGmpUmG2eLRqmPP+Vz/08dQl8jC76cjsm7zhctCYAhzEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFeDq3wn2J20pB5dv+acCyhG471IbSHYMVaAPuqGkcg=;
 b=pLu6EmKPCwbsnoy5G1IbLemSbkeywW95QY2v9mkJ9wj0X9FDGgFmc8WY74I5yHUbgEcpFVuxk+aVwW+xYXQvi8T6BC5qmTEaJgD5MBgWgTUa1cYT2U7VFmkSCTQIGb0QYk5W5ECHJWR5OI/rBYNUqbiC9sU1w4JQSQq9o1gff2s=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB6689.namprd10.prod.outlook.com (2603:10b6:610:153::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 11:05:11 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 11:05:11 +0000
Date: Tue, 20 Jan 2026 20:05:03 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Eric Dumazet <edumazet@google.com>, Hao Li <hao.li@linux.dev>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] slab: replace cache_from_obj() with inline checks
Message-ID: <aW9hXxAZQ4wzHova@hyeyoo>
References: <20260120-b4-remove_cache_from_obj-v1-1-ace30c41eecf@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120-b4-remove_cache_from_obj-v1-1-ace30c41eecf@suse.cz>
X-ClientProxiedBy: SL2P216CA0204.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:19::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: 93051a53-fa0a-4d20-44da-08de5813c7d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JwLc6wid5Z7WeXTnZdUn+/rOf77mXRJORQY638u4sACWbeXmRiTBpfMYnWvG?=
 =?us-ascii?Q?63mI++sif0JZMSbB9/KCibHxRH3g8CdJcdYhhgkGRaUZWG0KTEQZ3wInm7zK?=
 =?us-ascii?Q?Gke66580i72sD4ZwAwk6prOtn/VJfCY2PGKjSeqHLoGfQqbAkqL24D+f3wv1?=
 =?us-ascii?Q?RnK54Jq5RUCpDJAKpoRbtZ8r3Rh36jfzDBz+3nNSfBFjVCQh50Ctj6qoY29u?=
 =?us-ascii?Q?W9mAku1kd30DHU/ix1hKePT+JYhR2ig79OZmg/rGXEl6N1ojaj76jI/63Fet?=
 =?us-ascii?Q?PV1Z/Tzze5VWCy0v/Jxb17EN3tfe5WsZFD/i4LPCA3+oxvajVIIW5NIrqBSp?=
 =?us-ascii?Q?z1vBCe2PdYPgLhaPlzjzMjOBsUlM+Cazg8A772pA1VG3H7XqKi14+M7s6+Mj?=
 =?us-ascii?Q?7K7i+BU9ns4zgtGVRHHFzzORaYO1yZzNCLhKiM+Ye7+DfgcDEQ1WUQhpfuhP?=
 =?us-ascii?Q?weXyU2fYossJGVpP+nO4vhF+kAYxSlqbdXx719VhZVNKkuxGKtPxQZYFzPU4?=
 =?us-ascii?Q?yOzA3cazPZ/3Qjp2p3Y3kL9cUZWGRrQdKVAulAS/ZlHxEJPs7vq4a5vc5zR9?=
 =?us-ascii?Q?AGbGM1TT0Fn1f5xi5OBUJm64DmGbJ+QpGbZRqcX/FYUQXkBkXXnJKSWTzuNG?=
 =?us-ascii?Q?Xo8PTQXgriI1ROuvxWh+I4FOYuMqjBy7tIAxg5zpYKvJBPNiHtTMa6Z4vJ7O?=
 =?us-ascii?Q?ecorww3zCd+ab8vQoB67TRiDKjHrZOBSc0EcRTYmbEow0NnHAH3LHPsJK7BI?=
 =?us-ascii?Q?jIqYXAZ8lmfucAxczwDTQM4zylIRp8SApFoeaCcYPanXcJgP34rj8hHGXHqW?=
 =?us-ascii?Q?+Xx5uaBtwCD4knSiBWgfp2Kw6rquc+xcX9b4pqIHce/QvpRbzRDTaZjk4k56?=
 =?us-ascii?Q?3v6WdqFR3bx6xBz6hRsqb6As9YiMzHY0I+f6Wz7/jXe2x3olRtYRx2vaGQRB?=
 =?us-ascii?Q?sjzUlgHxl6Af/vb1c0Cqcx12vY055UXkWaZzpMPLFlY5CklXQHJPvCNH85M+?=
 =?us-ascii?Q?0h6tf+hjMkANDc4yHqLwd4gMBF1n/ojnVQ3dKlVvEOf+frvDuaUpbVRNO5sG?=
 =?us-ascii?Q?F7BgPcZhzt2w+x1+FaQkCVUyqw/ftqZOa+dYVdjdxLxQHWusXKyLNuWYygo3?=
 =?us-ascii?Q?+1de/Y4TkYScHYoRx/0X4S9v5mfurvzu0DtIbcJLl3FIQiWfQ/FmZ9qGNOI8?=
 =?us-ascii?Q?SAn1mCCrr7bZ4uU4XEvd88FnK/9rBEzNn2Uh2P8ZCBlWxWvcuTEILmxqTtUG?=
 =?us-ascii?Q?8ROTTFx+IY9lkn9d3kTHdtMr3lkfOK49ZTVNrTJHZBpur55h487O5J8wU65d?=
 =?us-ascii?Q?Xqb1Mpk2NLzFSIFEVAsAL86LcEryee8p8Lf6s4i71o0M8QSJCpwrAT+Mo46/?=
 =?us-ascii?Q?Ab24WXZ9u8WHMo6xdyAIqBwMDudL/L7pmXOplvVvG9hN1YnpkGdtHd1WZ/bp?=
 =?us-ascii?Q?01ITfKmwpOtHjrJLuGxZ07FLNAZOu9e4DSRQXGS0jCoRQWpB7s6Ai6sH30tW?=
 =?us-ascii?Q?q57HINnDTAVFTd+mxvDSR9pb7vBir125cPpXd2o6cz0K4l/5sqDwhXQMldJO?=
 =?us-ascii?Q?haVzhneHI6mWz+fcXVc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hx3reyXx0jCamwlO8F7zCvcmglMU5Smy9/cTzuuqXdRxhlBHUonI6w34GuR6?=
 =?us-ascii?Q?rX+dFwXchpl0Oyd3QuQQdgwf+Wa3iUO+tdSsdNEoSeAzpgzqAHUQh56QIwl1?=
 =?us-ascii?Q?a7eEFqNHcKKVRVe3kidrjw9NDJT5IJMOLb9jfenUSZTExx1/Dh76Ema/7ogg?=
 =?us-ascii?Q?YOxdY7Gd38IUZqviqDIsspxHR+w6xFFm+vaIkIkN08Kkh+C1I/gEyzRIoD/e?=
 =?us-ascii?Q?1f0SeZaLHWha2iVolUEK14gH1AOAUKJP+wRbDRyDbGMnz3F0FykcwBrKTyEz?=
 =?us-ascii?Q?0snuzHRtWk2qi/lopYebt+/ZGfab3sAo3WjJ/KDxJjdgUMVZj4osqR7Pda+r?=
 =?us-ascii?Q?KMc/s6HvInwqHshieuXGEGsagrkV8kQ3yop8drrJawCK2jvGNV5LVR6G/0p/?=
 =?us-ascii?Q?KgC6RWNUMBuMgLtfsAtk6TLHlBUaXvHO8LJ4lsMRY4VftZ6e8e77W4PA6k38?=
 =?us-ascii?Q?jc4c4rhj2kQMxiKgOkkP8qH/1hbYuh87dTPVBL7L17BlTxdmgs/DcG9y3c/6?=
 =?us-ascii?Q?A5GtokxIwp3Z1rwxHmdq09hwN5duGJH78fSRsglzFCRDK9yc6KOko0cXtnjB?=
 =?us-ascii?Q?lPASBr1XCEhDRy9+V+2v6zLIIvePN7d8itYW+CPfHquQG23PS82NolGllPeR?=
 =?us-ascii?Q?Un/5Uh6GqqTUg6jsXYzzUeldLfVVVyOx4zgii/Qe36Swl/4O3VuprOfgGotp?=
 =?us-ascii?Q?yOS2ypEznTlpw78d8JY4kgQpPYkLDQnxQBOOKkJxIKnwyjWzAvNDOnTn42hg?=
 =?us-ascii?Q?fP7iIz2PklSmK/JBpqvhJehmGEBgH05RtSBoqpflrZ3PjW+ZiFuJrhn+6co/?=
 =?us-ascii?Q?fhqmvB4ffbcVm872oC9zFyQYhpd8pr1CcIYoER+Y2ONiRXlNTg0K7VLnIczx?=
 =?us-ascii?Q?DqQ0zoiaDxd8ga3hGF4TOwzomwlQ41/wlIdnb3Idl2h1thzqMZZy7GedgmST?=
 =?us-ascii?Q?6jyxbREdY52atxfT/dLQAQVzeec4VfyXqtAFOp5Jehfh81rg94+yvyyidSwg?=
 =?us-ascii?Q?CseFqMjKHB0wQsF7UhMeAtJP1nMmJTBNh6RTkz5tHDG1bYNCEgiU4itnuR6+?=
 =?us-ascii?Q?LW1vqES69L453A2LVVxTh0kTms+m5xxrFGG3NXKtWpyLSVfFPnUsITXu2VHe?=
 =?us-ascii?Q?kDDB56Jvxgpd+fBzUnBZfYpE3mZtu1t7pGm0YqyrrYva4mChv3I8baGG4FtU?=
 =?us-ascii?Q?ezLbzjujfzqikB4UIP19D9VQWr7sLY6GVTooB5aWurefld4o3gkZprQf4KHD?=
 =?us-ascii?Q?vKZ+4Mh3GOWwK+edtPPnnAFSoLTgkHA83E9JY2VzYlAVPshY3OI5OcAvOwaD?=
 =?us-ascii?Q?GlCHEN920sABGPQpoqbMAQAAYmYcuqqBRUEl9r9WNxH2yX674aDO7DWmTh8O?=
 =?us-ascii?Q?4GtBK4pu+if0NK0K9YWfQHhEssh3pIXQwEYmFq/YkZWsSsJsvipn18VvDREu?=
 =?us-ascii?Q?aUe6BgT/tGcSaVUqyTq5+0oxR1L4KLc7qx9S/0u4Y8rY+MpB4Mdd+13HbFXv?=
 =?us-ascii?Q?k5mNBVKcQe+upSTnNJjPqqHcKrDC4sxxEBIxKePVdJlQu8nAoSQW3BhB9cRD?=
 =?us-ascii?Q?6Wj1ucbzaagrlpXl4mQovj6WjLhCw9nQC1+K2xQos60yAgttZ7UELL62gdXR?=
 =?us-ascii?Q?hYX4CObsaT+1iycwvKPcnImdZXspLBlm/tsvltJ+4+V0SzWAAvk0SASEEzNA?=
 =?us-ascii?Q?ITsC8L2j3zdPSARkq8i4iOrle75qwIXKrpL2edgmPp/rY1mZU4s3ifWvdMf9?=
 =?us-ascii?Q?cYGQQAun2A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J2syAmxH3/O8ANAik+B2uFoL6BmszK1yQsCszG+vcS3n3bIeCXZCvMnWHUOreANawFb3D937yeLka7xxaLytXLFlYowq1tTvizfo8uL8f6oU87NQanz9sdijhD7GNY+o1BjgwDO/OKlc3lhCfNlBcFhjs9HkEGdzkJVKFxDlyfpBhf3rxmif5PgC0fAV9dsrQzgI2dV8nSFSCSagZlaglGtvj1iMxj1WyHwWMsLU1sLa8j06+Rx/01eM5M3nJ3mXMtSlIHit3z3NqZ/2CpjHC/tprduuCDwYrLEJDfNBJpXPjDCY0vCKbIoYooAVDTxL3toQ3dgu/+NmjYc8xyGcbvC5F4JTQK29VRRjndx2THZVRY5MBv19Kt2hPCLbq+494e/5Ef/xvJ+fB+7533bKAoa+yGgvdQngaFKz5uTpkXI077tIJUL2XW0Bv9YHgnzA6HA+Fv8oL12upj6a6dBYRCegSkkAr6MTXar/c26ZZvwkHHS+NT9GWzzGosRfX/5rWzSHSytz0sprHE3tpY7gMkqeCvSZ2ebRqKDq36R2BT5p8DxBo4R2Wl0MmzKKPjosx9o2w7abQyKViOSim6KVmeXv7Dy7NuljSihxkXi+ibA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93051a53-fa0a-4d20-44da-08de5813c7d0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 11:05:11.6090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKcBO6ydCUs4v0ZcpkrExa2WzEJQGoq6HM6X1tzQ2gd45YQKgDnBkhmRjYt7gdpsCFCTUh7ss4j+rK01juEJwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=869 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601200092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDA5MSBTYWx0ZWRfXwlUvpP7HzgYa
 5Gb1pW335/fONeOVxWIguu3fhQCBcUidEWcPKh+lmkb6js3IKAh4u+eiOWSB0kVZ21UttKOcu6G
 NmzAb3jX+adFL9N3ka0isNQybKl3r+A2R5u+1d/rLxg3RlJ7CWHOY29H2wd5rwJL0Qv7rt02v3S
 UhdGQ5Vgyv/eu39aG0DxIUiArjKvmOvxUt3/2YALQ3e/ZcSNsVcNuDGm71U3UO3pRO3o9VPo8GA
 EedK9iTikLhnHYkbr/Blwmfl5f5CwKUYdCwEvP/GKIlHjT3+U9Oz9f7YaEIZnSPpGLqvgsLEiBO
 aU6NeQLJH2MR4Mv/By8ebOizuE3VSllmjqeOr8Q4h8Cd87r12Gjuluiw3hI8yEo3hFB8jj1jy10
 dGX/LuKE8r3HXm54vp85JBWVtcjnKajAULjsJFtH3LFyLmuIRez67vCncEbveIacE90Upn8bI7u
 yHfwSLCf4aQIbqTp+EA==
X-Authority-Analysis: v=2.4 cv=HvB72kTS c=1 sm=1 tr=0 ts=696f616b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=njwmZMbRHYmMmcBMzFQA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: dzaYydOW1pRMD3WsciLImorw2Gl2a4UT
X-Proofpoint-GUID: dzaYydOW1pRMD3WsciLImorw2Gl2a4UT
X-Rspamd-Queue-Id: 7F162C0003
X-Stat-Signature: t18p89t3xja6xncnq48jmbrcyxq3oiwq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768907118-176503
X-HE-Meta: U2FsdGVkX18xJlmM9u1EBvN4o/iOd38TLVrMq3yOtTwUSRx5+q6ckhUmc7aGY/lcdzIqd31CH8TlRYekxsqlD3JaBQ7LAkwSq/gOTTEehQL3eFkUnRQXbyBK0RMYtMkHfN68yqKCnj0oe3Dt/Jbhim8bUPrThZZNMWyaABOZtp2aDLjPwafTb5LNx+WihaqzQzHmgRNILqWZ7LvEq860jGgHFPxundCfGELzAcjMZ5QulnXeiqtK2sDssfSeKUWjXuTMjaVxFTHlFFsAkTeJ+iZ+qk8L0gcJlOTDi0r5vEU0d3vBA8eqoG2VKj8okDIdUOX8+MKHbnuH23BiMfs0Mcq+hAdb7OGtvXuklhchEePuDzMSOxOhWlrK6zkJan6cf/FJNsC/QTMSBd37UrBA+CnTcKKqd56KV66LOvoDu9ikpYetnSWHz+c8pC5LIxFVn9NyRhflVrvmCfFV7ufXRPSMlUFBw2Qsh9a1wjE8/b6ErrWsNe3itTx1on3xBMVj9lfee40nTYvFKbe0Y0DLLgxmUK9MbLmrD/WANih2twgKsnSaQ8PCPFOTy8FV76a3WfhFKluqbxXtLMRHdpVFzf9Ux8bKw25vubHl8zNU02YnpYLWftzUqib97oYKXbKAJgZLdvJ734+KWSCjLMRQamqQUkuhlpoIrb3Ps2qEVR71pNhgm0ZrEr3yGOvuucnX1IB1NyHxlcrgZ80UL++9FJ9OUBNanSFUvnhgGeJ8cfEh6TT5X5b7/T7GtN1Q3U5F68iLN1VGQnfOcHfYQwVf0XmDK3lwTEuCPxiZeAmsXL+pjMBVUvWW0WFImdwFB4Ka8TfFO0mdozuh2pYAy6T0wiveQWZEdLuevoVjaWtmCdW4zDAq+0r9CTUB3TyHITQcMiLUOCsJjUuZaiUStOL2gMFXwhh8P45B382A0MEMskG8Mv4DSryH9i/OqXVmfinck2sys/c6RhNK70RgpCN
 /jOBoP8t
 vfG1nh75+RGqDmj7HxMsUdyUW0s7iApVvnleA4wi4aqCIp5A+SYHH6hPEvGs0pkjX6/0X4ZXxlQ6kCofJ+oM81C/7wL6NhiQ29xaUg5H3l1zJW/QX0TkEvBFLIj/d7vVIREDs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 10:35:42AM +0100, Vlastimil Babka wrote:
> Eric Dumazet has noticed cache_from_obj() is not inlined with clang and
> suggested splitting it into two functions, where the smaller inlined one
> assumes the fastpath is !CONFIG_SLAB_FREELIST_HARDENED. However most
> distros enable it these days and so this would likely add a function
> call to the object free fastpaths.
> 
> Instead take a step back and consider that cache_from_obj() is a relict
> from when memcgs created their separate kmem_cache copies, as the
> outdated comment in build_detached_freelist() reminds us.
> 
> Meanwhile hardening/debugging had reused cache_from_obj() to validate
> that the freed object really belongs to a slab from the cache we think
> we are freeing from.
> 
> In build_detached_freelist() simply remove this, because it did not
> handle the NULL result from cache_from_obj() failure properly, nor
> validate objects (for the NULL slab->slab_cache pointer) when called via
> kfree_bulk(). If anyone is motivated to implement it properly, it should
> be possible in a similar way to kmem_cache_free().
> 
> In kmem_cache_free(), do the hardening/debugging checks directly so they
> are inlined by definition and virt_to_slab(obj) is performed just once.
> In case they failed, call a newly introduced warn_free_bad_obj() that
> performs the warnings outside of the fastpath.
> 
> As a result the fastpath should be inlined in all configs and the
> warnings are moved away.
> 
> Reported-by: Eric Dumazet <edumazet@google.com>
> Closes: https://lore.kernel.org/all/20260115130642.3419324-1-edumazet@google.com/
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

