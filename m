Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C055CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 18:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6A9E8E000A; Mon, 22 Sep 2025 14:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43528E0001; Mon, 22 Sep 2025 14:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909A68E000A; Mon, 22 Sep 2025 14:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79CC78E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:00:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F5D2118787
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 18:00:18 +0000 (UTC)
X-FDA: 83917650516.26.ED1BFAB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 50BA340012
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 18:00:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ImdoIhw7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VRxyF7k0;
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758564014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dr86CplelbbcY4q8pNpOUvRlOKvo90LeQMHkVdZsz1s=;
	b=2dddjgfAfgpnzVb4l8e4OJmJ9OcDNtjRaSmvXBuDKRHbvHwe7LQsQLx/rY5cg9PUOa9wfY
	7LddDgMXEHMVfXReqiWFFXBuIOlp4P+0vArs3Bm+qHGBX+rpTRxG4YQftYn3ZO5M2LaKZa
	UlB4ptbVFuOEm15esgMnoNRzWsfq2po=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758564014; a=rsa-sha256;
	cv=pass;
	b=IgqU7eDOX0djW9Mkur2HYJcCDCMpT6liB5FsR9H2V0AjtDXTjMugEtFv1mtxqQoN6dCLJK
	iHSUJLuPGQW3V8j5nUjNvQ+wy7UaOsSi+rN92cVOHkHkv+uJT+MP+1hQBLlcuWX6RP9w1k
	EMOWokFAAxrVarq4wdayntiqsOkfvK4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ImdoIhw7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VRxyF7k0;
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58MHNFfl027602;
	Mon, 22 Sep 2025 18:00:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Dr86CplelbbcY4q8pN
	pOUvRlOKvo90LeQMHkVdZsz1s=; b=ImdoIhw72ZDnIL8F/kdT3Hd09i3TRxiFNa
	s+yyW8VrWIN+LCeQpdx4JhvGR8iWIaVPHmbFV+Ez/hwpT08JeLTlCzwE1hnm1G/D
	JzxjCMe/CijY9/9GiqZ81IFwFxjtgR7CCGqxNOKLCxr19W1QzqB7/Ng8aj99Tq1r
	tjlmviopMxvaBSklB18p1XrNrv5BECLW8zU0gUAyOa14zme9CLXipCwucmxRoZsL
	VHj7pWmcPmI6BiUKyoKYspWCg1cxrnX1CmPYQ/t91xCPGfsKE9Cy8Cxm0sVOc040
	Rb2LnK7WtZP4N6vj8DgFFGW/vrv6XqPazPnOEto6gWyGXVuyHvmw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499k6au1kt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Sep 2025 18:00:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58MGHrN1028394;
	Mon, 22 Sep 2025 18:00:08 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012023.outbound.protection.outlook.com [40.93.195.23])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jq7dxae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Sep 2025 18:00:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LRAVzYc3HF4oS+KczpvnKgrjt7nDD+tzAFXKvJ/BAwGKIxeHrh1T6I4LvPdsXkPEIohAz8A5WAuhU7KGxjpglfSCBolgGN8dRTvtlsLQNtL75L0DDE8uDDvfrRo/DbrLTnCLKt5jiLbqdejnM2EOx7gqHGiiwUtBaOZSQj+YtoaV8yFXfdIGLyxNEZe0KzZ/HgVTh7hbvi0A6zz/xLqjmv4gGLO8CLpNk71AnfStDWUs4oZuxwLSVXjluFrCZ7dWDdr/zt31pDkq7XCptEIOPaIIlB2tAE048UDwuhI1T3lDHcb3v8Z32c3TQICj2i0vAnmesOXjXgcgxtFmnCUAoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dr86CplelbbcY4q8pNpOUvRlOKvo90LeQMHkVdZsz1s=;
 b=HXUWA8G0eeHTspPJuCNVljsViZ+BNg+Y86vmOndC3QGwIZZOX/mzVKUjUc/QaZKWPywW7Zz7ac3VT+53Fpw4BOWn7DXFoUDaK5BYe8x3gEjclgpDQuPHpprctYnD0ofxyG2gtTwKNATaHcbWlUDxj8eFnSmSAF9g8rdRCECUePrnRPa+HpmTUeE73oXig/o5tPy4AHub9p+jtOU3QwKoBeyoxaVym8TjIVpqphMMwLikS3PxCqQmkCEFrD8zUlZ+LOX680ETspqpjleMRNMeuLCcSPpJ4lMWyca2EFRkZF0pxpeEdTzKMzwDQ/wxA8QW9+WO2F4SGqB+tlpOVckJgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dr86CplelbbcY4q8pNpOUvRlOKvo90LeQMHkVdZsz1s=;
 b=VRxyF7k04riWA9CLEG0Iu78sHrcGvLctnsdAlXoLyi/B2eZkChbGqe2Cew0j7VOGTymPc8zT5qu+Q/JcSXKEFDE+09R6KlA+AgMp83slmDR8l41zsPIRXKWcqSLzysnhuHq4FoHd17VlsEsxpsqFIapKPzviR4B2Z4UFLfT9sm0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4801.namprd10.prod.outlook.com (2603:10b6:303:96::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 18:00:04 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9137.017; Mon, 22 Sep 2025
 18:00:03 +0000
Date: Tue, 23 Sep 2025 02:59:56 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: I Viswanath <viswanathiyyappan@gmail.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        david.hunter.linux@gmail.com, linux-kernel-mentees@lists.linux.dev,
        syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
Subject: Re: [RFC PATCH] mm/slab: Add size validation in kmalloc_array_*
 functions
Message-ID: <aNGOnDb0WsIbk2zx@hyeyoo>
References: <20250922170357.148588-1-viswanathiyyappan@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922170357.148588-1-viswanathiyyappan@gmail.com>
X-ClientProxiedBy: SL2PR01CA0022.apcprd01.prod.exchangelabs.com
 (2603:1096:100:41::34) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4801:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c42254c-920a-4602-9aae-08ddfa01db03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6k9WT1wjQ6eJA+oqEKNpbrxhWDqYJx5Xa/Wl54zhxFoFk6YnWMbaxu48ww3H?=
 =?us-ascii?Q?AN0bzUMZ73LtxZXS6KvuVdzIKtOh7cZgUujnaahWbfK+djT0hYXQoWmAF0hX?=
 =?us-ascii?Q?wfJbQcz2CcYOJm2QLYYO8rap/KjDZrl26V4RyUKS+2yJTpFynMiaKV6ii35J?=
 =?us-ascii?Q?ULNG8g8Kb8/s2w0U1hEtdrUQvoncnTepXh7Gsbo1w2LPE5JLXU+Jpu30/k3m?=
 =?us-ascii?Q?XZqQVJSCMaDLs3EAA9cVADsYBAKJUKChBZC/+bm5ew9mFjzJHLWApttfYQSs?=
 =?us-ascii?Q?hF+FqKvdtbvdpDvBYVGKfLwSCjaK4S+yiM3En/i+WQGPzv6To3EZDMhMA9v/?=
 =?us-ascii?Q?3uWpsWS3P3mVVk4VUn0dfc4DO2gfOZrEp7prKrIQJxL6Wxm+tm9BwLZKlO2P?=
 =?us-ascii?Q?15QNigW7HhQR4d97X9p8lFVW6iq4NgpnFiKv3V2q2Sx5MyAPTRJA9QSh6QyY?=
 =?us-ascii?Q?fNzHF8W0MNtqQX8Lk2SY8PYZ6WvcHlC1DgsLc5sA87elAcy8KOeNHyYB3f8E?=
 =?us-ascii?Q?d6KOY5TKfvQvNTpnVZ9Ygz0jVXqv98j8e8XAz0t5yrO4PqaPTF/vLCc4qrq2?=
 =?us-ascii?Q?QjmjklTE77+5R8uFemihJY1hLrd5mr8scMZIz5iBJaZ6gphWpPLStxm8UwYg?=
 =?us-ascii?Q?vPckJbe7F2W09STmFmXMJ4AvHEnvK8fKpgGwh2Q1SHZx3iyh7O0pqiI+oD/H?=
 =?us-ascii?Q?aYFk7TCW68FQjPfr+HhfnsMxVhkMXM/XHy9ZVIQI7Puhhmdq6OEnfm/MOuFB?=
 =?us-ascii?Q?h7d27tMwcLpeikWKiMvoyuIDnP/5ksLpw5rh4ii0C06luW3bCpImhChtyzdw?=
 =?us-ascii?Q?7f+SiAku5Dok2d0rOOdmZVDXcJkNtVtFCJad1i5Cxa+4JGB+bYpolxAepkRN?=
 =?us-ascii?Q?pnG8rda4momA7bkVJq+dQQGpPtCbn+Uaw592HyVr6YHMrZOj/aWkinEh3B78?=
 =?us-ascii?Q?2ZMVFQHRlduDTIhFv19s0FeGJmYsW8BV3e69ddrXeiS1iGC9ouTtbvBHjDbP?=
 =?us-ascii?Q?W4U2DUjVTjPqDLQWIl7EGM8g3NwC2ol/CEhXXbVJCEXQA52t7S0CxHsfH5iO?=
 =?us-ascii?Q?WdB3+4kdtXRwuLSXiWmbXrJi9hSIfDcDWgEEb07fDxJWhdGjnCiwi5qIkwyB?=
 =?us-ascii?Q?ZJ/2b/4E+fvOe1LrdoPNn0lxtw37KlnQbMhQ6+OQW+W39fHRyo8Ou19ix9E4?=
 =?us-ascii?Q?yWUYJViMO49TQEQ7bzObt6dNe8/8ji/Nlr2dLpJzhDKxUbMK7DEuRD4qYcXA?=
 =?us-ascii?Q?RmDfEA+wZuIxy3QKSMWMZAezcwfwH6jLVW9ivxM1nTdZkabv6LJH2zsgPq9U?=
 =?us-ascii?Q?CoESdUvFLUFagbeM4AnXX3XJWOeXlk5CmNYvvFhcs//Q6TgxxH8T48WfinMw?=
 =?us-ascii?Q?7+Zmf9s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?smmxW3mVn48W+mKx9Uw12N7zTkBJc/4pvwH6higiUS3P59OpzKVmq+We1AKt?=
 =?us-ascii?Q?K0LK+9pQ5VbvTkgx5uVtBESFzKzRmr2eXGzAcBGR42uKjZxC3g2kTX+cmRLr?=
 =?us-ascii?Q?dg0pxf4BBj5n2QlqAcxzRhkpNJXTnylKMnndgetxk/ItGNP7Q/J5K5yswp9k?=
 =?us-ascii?Q?SxtEeakKmurg7rfiPzw+bauB0oDRKBfsdBUrCVi2AFAqIjX+j4y63davBkqo?=
 =?us-ascii?Q?sLQHr6H87VyZmuHtSQVbOurbL7GpYwdEq1rE2RFq0n4I3Nc1RIWXm/H/hCvO?=
 =?us-ascii?Q?OJpTuCHB6w65fZHKkDZVwl2bPO0hKRDpEIe3d+F5srcwdfRWwBO4AwE8mNb/?=
 =?us-ascii?Q?wKrRiifgscrabzSg7RWRGcC5+gmSI6zO1VbPQHQ+2dE0XF7rs/OJkB+H0DSG?=
 =?us-ascii?Q?59nbWqY6KKrU6FAXv01crKXb4wjSoDcax2fMzrttKZdDPPgeq78nuGBsLVPl?=
 =?us-ascii?Q?8UsbB2dgrQfA3ovU6mtwC2UC0o0v9HUS9WYWv5zo/XGtgrifVWCqAmdAw6rV?=
 =?us-ascii?Q?10jzhnr9vdLZbLsQi2FxbbBPaw9w5vcgsq/aep8U4mlo8zwnfbAJpe6WK/x/?=
 =?us-ascii?Q?zqlDbf0oXoYd1NvRlksZJxqzyCNExXxENn9Td28KTapLFpm9rh68ZvU10xDT?=
 =?us-ascii?Q?j3f0dyPEiZ4Y0SZV+PEg+pi+f+rFHhS8Qek3Qa751ri4hEu5sIZw8I75Dlhm?=
 =?us-ascii?Q?qImv3V1F8F+Qg+u9LHF4gNjU9GV9UjGqCbbVjVEEUyH7UHq+Hbdi2L99ERRT?=
 =?us-ascii?Q?QPQKF/UnlNDHnZ4oS6fB11D0TQgHmSTMy1jPxzjZpkNDuKKAO4EtclT/AdGw?=
 =?us-ascii?Q?edGhDhP1c7SnetBgTsfNCX7W1rLfZJ4NMp7P8gog9uXbvmQ12a8+11pzJcx5?=
 =?us-ascii?Q?70XJJBj6/ZyuFekuHk71+CPAoNzsxqQIZF9q45KvWkWC++g/BLFwLdry2elD?=
 =?us-ascii?Q?YtvLSpSOdaSA7qktWVSfJK+9WuJ7TTmyaIJNpyzwcziYF6qtMHo0yR9f/BHP?=
 =?us-ascii?Q?BEodECH4ExAO2OF/dOEXhHkQhN/SrvhpSMFPlLJBEbKsxMw+dYuM0LJ0pbb9?=
 =?us-ascii?Q?H3J/Wodiu6w9f09/dYRTIrtHn+zm2s8gZsHaY0TGcBUuc74gWWMG+tjes1vM?=
 =?us-ascii?Q?meIcgzubnVrmoNIF10HF+pBzFg5qhvN2iJ3uu1TGJMwhJiPllpx7rNj+Q59d?=
 =?us-ascii?Q?6elId0FWZtcwPFuyexa7z6fjViJXtxUrSXgQw3aj9uO50X2q69/EyBZLlU6o?=
 =?us-ascii?Q?v25EAQAQ5dmfwHmsvBoMWYheVo+5aU2k4hN9lURrX4s19NB6RtITUrUD/575?=
 =?us-ascii?Q?Qo4j5MN6iggtmk8MRiZzUWVjULBX6xNK1/QLt+Pl9l1gPJ8h0mVKc9hfa2YE?=
 =?us-ascii?Q?FjO64uW6L9Nc+zu8xY+jnQtP0ZQnlI5H7fArM+X6nsifZVYKDe2ZIXl9CLY3?=
 =?us-ascii?Q?dXMCVj3caHjcFg6vQa5i4T54XBT/YNXR+v+bKLDh9hF4ZAk24Qvzs77u/F+5?=
 =?us-ascii?Q?nq7G2RthxEDyFG+ZMeWPsoYtWuvHFxUTg/VvLO+kdpNvjrZfwc8jrMRdT8wR?=
 =?us-ascii?Q?7YhI4ZFIvdGTA8ofWu9Ktd7GDCYiUxuTzAEb/1VX?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XBuxc8Prw/qgTLDis00Bsr6w3XCU8e7Svbv6SnIEmmz8DhD6iTfMzW5VfuQbl1sj7a1rHb+5YbplxC+FRBumco8ZRWBVV7IVCUEc+VAEdDTH8lbsAWQnUcCcPaXSoPUkf0Pw91KYkE8+OtB25spmypk6KxOl10ExUmRYhrbUlPqlyWSmhWqHyMjRFvtgLL9N3NOEUiGwmNWcKqSqDAN2frKhYTccN2i9wg/zFBGISIN4FAVMCKdVQtyNSVtuzQOJ/79PfFBkFlTT/Oo3wl+iVALEW5d3zmbbg82UlDyP0SdAOtrYtQfwyOpInxIlgPxhaVkoyuM14Xjd0aj2yc1siffKd4tpBi4qvIW33EGO2loKgAR4R7VOZ2BtYskZQl6ewBb15g3G+JeuDY8anaOj1CnhNtgJhrG6mVPcQf/DOqa4yLvbvql7wRNM78LvHT7wXmrZ9EjnNysaxAYcPOHHjldfVFkFBUrSIBgj0WdTyFeUqOkOGejDJ25R3XxwlLt/bzKCChoSXVma6Cr3IWLHWIl1uB85LrBoCxMaiNGnCj9hYBYZcGhL6PL+Tke1JzzcJzM38pOYNLJTfDTa9ijSC0nwGxzhd7XNgfWx4NOPZW8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c42254c-920a-4602-9aae-08ddfa01db03
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 18:00:03.5837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qaifY0J9igXPXqmK0Mz1Q+DEqoOeOMqLExZVzD6T7wTBYmVZfNOmRXLKUSkBspX+b/d6Uwb54pKYpJCM7I85Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4801
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-22_01,2025-09-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509220175
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNyBTYWx0ZWRfX+vLjq87hMYsV
 n8WHKpf8ZLez/2KAHrtj3eJG3wKMyied1NJDRILzv6/o2hq/nQhhNGmb/8B7b+hTAvz1FwBo7Dp
 KqVdGlEFHIpFPpNHN/yvEEXLvYANvO5LU0GNJXS847NBhQw0k/I522JeuU2jQCttJ7/Jhu3n9kT
 p8HipoQ14Q7WezcY4vfEBJcSq48J0KRv5EuslTXWdEWjU3Nhi0naYLyxD4fnpigbtKVWBrYRz1V
 ySf+kqs/k+X/4bXujHZ2gA8+qAXpBA0vpWI5ykSsy1mRd7jApdrv3AQVha3XGBcc/Y2t+VVHxqZ
 RNMZCYIvyVHzYnlojzLFkVKy2EoKyZTS4OJJOLP6o+H7NQ63/SWoVIoDDxICDwOblm0nuKgh+X+
 yfb5R4tg
X-Proofpoint-GUID: 5oN4qcdk0rmR-KiMS2gj92P9ohUePXdg
X-Authority-Analysis: v=2.4 cv=E47Npbdl c=1 sm=1 tr=0 ts=68d18ea9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8
 a=pGLkceISAAAA:8 a=u3X9V1jny4mBdW1uAzIA:9 a=CjuIK1q_8ugA:10
 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-ORIG-GUID: 5oN4qcdk0rmR-KiMS2gj92P9ohUePXdg
X-Rspamd-Queue-Id: 50BA340012
X-Stat-Signature: zcdhwepafynadxz64xq9tyx64s1aok96
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758564014-115013
X-HE-Meta: U2FsdGVkX1/SvQxq3qeIQMLBOJa9Nvyl2uaV3nqwtl14uSTUKgkKevslIUKInxOJuBztBIdCP+Ujt5gehPAfTh4t0ZGkhXmbdeJbinhALOOHeAfDwEBJuZSgR2lwT15vcCXnF1UZ0+ItxdDzvqslcIILfUkaVnqqmvzCPUH0+wijXWewTWQ1GHul42CGu3Udfrc0qAU8LbNkyKWrD1cPZ3JD57FEVqtFadB6yB+qsD11Xd6wb39ZpEaIJcEVOYtqeOKBe66cLb687/OWUBqXh4fcO1+MAu/HpFhWiWuVJf/xefenVPCBmIWvZSmyhY+oeSiDZ0mVz/hSBPDB3Yn6r++N9djHfIINSV0PISG/FczgsLUYpu1i3gECecaP5+iHwuOKaBEI56STwNMttooVx78iU3GllWaRYA4JFd+Ut6PnM7pMdMqE134gXMtIm5u5Oa4cXU5rugA6Bw3DMUej87o6StbPCiHW5cxcGYq7JVvwe7s1WTE9V4AUxFg+ypeAz5eBZGx4kr0TiJHcBdtJlgLDqMKg4UqP/bhXQqI4yNFrwRmyOxXV3vIVgAdJvUf+eBbkob8ZnNUbn0e1RoNjoEymdvPFIzrIenhlPnY64WsD5+TISAv1Oeys0q8o4Bnc/gL6u4dFuhr32yEqUvtPHO+0jHA5vnFpZTDCeZuemv+isHqBZqzWmj6EwD4sKHDOelh/ywtp0ZVj+cooTSdrcFNXmZWcWrHEZm2J3XdIFxhRO053QX2jJNSM+7lguAVNwSVfPuav2w1GmgQpY+ylkJQWgkN5Mu8pbq361OId51xTqLMtkwmUw91Tcg+kAUhZ9TGVqvdjcMMFIt3uzeCYOIeoM0Stzy8uN1RWV3UwopetENCiDnvFAEgSxtmFGWuD3Gcqkwzu36U+XdHjagDKlvfQaBbG0VEH0v8uMdPwnodSQv760mJ9boVHel61wN6zMhuH7z1fJh0VfX3xPI7
 vLj50C5F
 kzeEKlZhoRFxzp+cpnfZHqqujyzOU6+MteevOnZJ2i/w3WtgeDNNfhhgamaYG3OHhpEhABgH/nDLn+hjPawysR1U0DE/I/LV6LENUjxs4OHoD0sKtQdyRGfgLVdz6M92F2G6ISfOknxZlF/6wbK2kJ8cPKyuyYvx5J04oPxFtXYkIstzh5wnKHwkGyhnYIuH7NwRLOR/DiTud8TQxdgIlNEJpwqPN8fO9H/WGSmKo834ySC0B2cV6QHzlkdlmIdG2UE4f2hb6gUn2jczuVnOinEcwuTSRGEw6vJCUbF3bMrxUl2GRNuAmj2XaTGhO0XdfLouVM635UC9c35cYNv2Il0wOPn7mWHjgKKdvpgsf4LBwxw6SX3UDgBYeN/dtpiBXxhhtiQn2SIKjdXQOCcfiwQtsKeFiVsDLQTHdktbpX1P1Ux1rGSI2eDeHMDvLuY9wTkqGJy3ncbdaCO81lKJ2cJWq6uWFipjDhHWVubZD9uiejAgy/u2zGTw72wFVqo6Whi20ak8DgZQEzAupqUkn5zqe6TfhQJR2L0SsveLWC+VC24H6v9VPRt/Zfki3qsA3RZfgVcJ/OJifbHqENeHkh1Gs97kf7lPPMREZc4vZg7WZ9MXYxQ9LIRA7F7n4U9pNdUGq+5+mSN0GGKUGMzoZ9aQDkX9ooVxpdpkQIWQs+vThq542SltTym2A73VlU0NAbs4Df+ET+xoiHqcamGcLQN1ZGNgyVhs+fa4WbH+Nyg2HFEu3saQptcsWWKcuufCVUvq2jzclVBKjkM/DdX5qJ09U1uljfgfx7WEwwrNdUmRyD+GBMsIHHesM/GJ7ziAGEEUIroYgNjcezEvz5TCbsTwEvcAroe9zmtXHFx+XRlK7DrxRYvaPLMeBX7O2ozncDSDN8KwK9q5jAgdpFMUfIasmQ5Y1jqlgSG0YRhokYz4Ngh6r5jvb7q9AfH3bs2wRZr260FinB+btJj9g7q4ziB36GZ2i
 PR2sWWDj
 aaCzuncM6/21gDBNOfCiNFobQex15UlH3EunBTp3jUpi3NsQwwAsQ/6vodIgIf2Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi I, thanks for looking into the syzbot report.

On Mon, Sep 22, 2025 at 10:33:57PM +0530, I Viswanath wrote:
> syzbot reported WARNING in max_vclocks_store.
> 
> This occurs when the size argument fits into a u32 but is too large 
> to allocate, i.e., when it's between KMALLOC_MAX_SIZE + 1 
> and UINT_MAX (both limits included)

This is not quite.

When bytes > KKMALLOC_MAX_SIZE (8K on my system), kmalloc redirects allocation
to the buddy allocator, which can allocate up to (PAGE_SIZE << MAX_PAGE_ORDER)
bytes (4M on my system).

Because allocating a page with order > MAX_PAGE_ORDER page is never
supposed to succeed, the caller of kmalloc should be fixed rather than
kmalloc itself.

> Add validation to kmalloc_array_noprof() and related functions to 
> return early if the requested size exceeds KMALLOC_MAX_SIZE.

This is against the point of WARNING in the buddy allocator.

I think the right fix should be to return -EINVAL in max_vclocks_store()
if max * sizeof(int) exceeds PAGE_SIZE << MAX_PAGE_ORDER?

-- 
Cheers,
Harry / Hyeonggon

> This seems like the most reasonable place for this guard.
> 
> Would it be a good idea to move the check down to 
> the lower level functions like __kmalloc_node_noprof()?
> 
> Moving it up is not a good idea because
> max_vclocks_store shouldn't reason around KMALLOC_MAX_SIZE, 
> a mm specific macro.
> 
> Should the Fixes: commit here be the one in which this file 
> was added?
> 
> Reported-by: syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
> Tested-by: syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=94d20db923b9f51be0df
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: I Viswanath <viswanathiyyappan@gmail.com>
> ---
>  include/linux/slab.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index d5a8ab98035c..6db15c5b2ce7 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -943,7 +943,7 @@ static inline __alloc_size(1, 2) void *kmalloc_array_noprof(size_t n, size_t siz
>  {
>  	size_t bytes;
>  
> -	if (unlikely(check_mul_overflow(n, size, &bytes)))
> +	if (unlikely(check_mul_overflow(n, size, &bytes) || (bytes > KMALLOC_MAX_SIZE)))
>  		return NULL;
>  	return kmalloc_noprof(bytes, flags);
>  }
> @@ -973,7 +973,7 @@ static inline __realloc_size(2, 3) void * __must_check krealloc_array_noprof(voi
>  {
>  	size_t bytes;
>  
> -	if (unlikely(check_mul_overflow(new_n, new_size, &bytes)))
> +	if (unlikely(check_mul_overflow(new_n, new_size, &bytes) || (bytes > KMALLOC_MAX_SIZE)))
>  		return NULL;
>  
>  	return krealloc_noprof(p, bytes, flags);
> @@ -1013,7 +1013,7 @@ static inline __alloc_size(1, 2) void *kmalloc_array_node_noprof(size_t n, size_
>  {
>  	size_t bytes;
>  
> -	if (unlikely(check_mul_overflow(n, size, &bytes)))
> +	if (unlikely(check_mul_overflow(n, size, &bytes) || (bytes > KMALLOC_MAX_SIZE)))
>  		return NULL;
>  	if (__builtin_constant_p(n) && __builtin_constant_p(size))
>  		return kmalloc_node_noprof(bytes, flags, node);
> @@ -1059,7 +1059,7 @@ kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node)
>  {
>  	size_t bytes;
>  
> -	if (unlikely(check_mul_overflow(n, size, &bytes)))
> +	if (unlikely(check_mul_overflow(n, size, &bytes) || (bytes > KMALLOC_MAX_SIZE)))
>  		return NULL;
>  
>  	return kvmalloc_node_noprof(bytes, flags, node);
> -- 
> 2.47.3
> 

