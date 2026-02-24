Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E966FEFB7F9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 07:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25BDA6B0088; Tue, 24 Feb 2026 02:52:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DF816B0089; Tue, 24 Feb 2026 02:52:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D866B0092; Tue, 24 Feb 2026 02:52:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E6A756B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:52:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D0CE8B994
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:52:55 +0000 (UTC)
X-FDA: 84478583910.19.D21FD25
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 14B9840005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:52:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="sSA4GBg/";
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KcCF7HCj;
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771919572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3uwdr5FlXYDXsAQmPkWdgL5fFSlqYRTkQrMuO/8XUg=;
	b=apkPgKCux9j9rvWw5B7r7EJows/3X0WXbBMG1ovEf/But8/xHxgZBv8kVi4+5SsPjH5zbz
	zJsrpKQwsGOJCyQpH1xG9azXwvHgl3N0/t8SedERTsI2OIpPS73i4hTZe4CUJ5c3rj7MLC
	2uhBNTKmNMH7pVhDD02yhYRKIjNHPiQ=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="sSA4GBg/";
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KcCF7HCj;
	spf=pass (imf07.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771919572; a=rsa-sha256;
	cv=fail;
	b=uJxzlShYqv3YNjvqi5OhYu2q7l7qFe2Z8xR1VS4UqpydDFqPTmmGUBKiviyNID8CGCLZkC
	7wTlayvdQOfIPcBXY8kKS5KEVMv13rjmZGEcM1gSU1yeBDcyS/CWCldlR2lBoiiROQlQ34
	uFXJnR9YjdQWJPS9qq6bktJ91rDCQuc=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NMvKff2584997;
	Tue, 24 Feb 2026 07:52:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=N3uwdr5FlXYDXsAQmPkWdgL5fFSlqYRTkQrMuO/8XUg=; b=
	sSA4GBg/vYtP8gt6qMLZykNgTaO1dEMoOlgSJAXfKZvKgmH3OURXps7TJij1N9u7
	9kY4M0b9HVTR/H1cj+EIV4j/9kZ1GKFeq6evA5qhKg4Owqu5Hju/ShvW/wmZRXAE
	8jZSnM3vX1hfWTuwIi8pN8YFRwc6x2KvSdjHzsBeNwXlWftNYX2FSwufr4KeRJ3Y
	Rtt8OzM7fj+StlZqH72/y2B273mWjE6Y7iJ+aLDstAnf1JRX6pGIF3tNaIBVCOAg
	V67g97PoGqdp0pPGIUi3toNm/qXGkukPsPb1+pJdVyV5511WGpZ/vXalKuX9nyDw
	1kQAd1Aqx1kTgt3QMX0rFQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3m7ur7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 07:52:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61O6ksT7027810;
	Tue, 24 Feb 2026 07:52:48 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011069.outbound.protection.outlook.com [40.107.208.69])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf359crvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 07:52:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Me7FbmY1HbXSb/G1+BtYu7clZBvWroduvqEkskv0o6st8TnBEar8uWCM3k3WBl3+4IosF0eBNvu0+LBO07atd1Y459KlXeNv/jf3pXQDKFRLHIn9/R+kNPlzleNuMxp7cDEhSs6nWFYvugIuiCl3fWzABdxh/ACVFEVV3tjpb2XURrXYJEAfYR5tJ+rrB8Nkhj66aXUqxyRrGnA1jGq5tDedc7Z9CPbWkRzxLWqgC0CuDKSAdlTz1bVi0iOBaqbpxvnHdhE9HtJDn+Szv2adUbcvZ2ZZmkV4G873b4SIR0T0m0ylWbvc2ZAxo176N+TxGqxXk0mdcD5rpfb4NsFEVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+BjZrfIzH8jquVjglE0vHniz+FtuYH+Ww6Kym72iPA=;
 b=DTvHKj5gkIJDJttGjL/wge1mkdoQ8WVLZtJjkID7Ff4JlWvGzF5L1AWFTAPgiu83GVMSYEVYprxx1H2H6wXlTi1FtbY834lJnp5Uz6rr4NVOSdaUI8lPGz7eFfYgiX9Ieq4xmLA+ITTQZI/pJmmNBSBQaSPXTM5s/R6ZiHpRrwHstj5Sqj/bKEJfoYQd2CHOdXhlYUFamGJkurviAIjnxemjk5Y85x3YSdsjFGmwe2i2Hi6y0t5c2udevWLKGq0JpRyrPAQv5cNcVsR4BORYSKjmO9TfLXW2vmKiOM+LGoGlZUZ2EeAMmDMNv2wG7nj6MH2WklleXw2OQsMIsXCN9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U+BjZrfIzH8jquVjglE0vHniz+FtuYH+Ww6Kym72iPA=;
 b=KcCF7HCj6S4exX3L9LlNDaWMSocubpVUizOzpRK9gfYB2/x+U2aF5zpjCV0ixtPQbMPrQUzycgOcf45J39pe3Gf0yGZGKHK4cwRYkUzH1hId9tQbEJe+liOPDpXyep5pWaLjZx0jLASkUVP/LFI1/VidbALA5gmNnMy3+Js9dlU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN6PR10MB7424.namprd10.prod.outlook.com (2603:10b6:208:473::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 07:52:46 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 07:52:45 +0000
Date: Tue, 24 Feb 2026 16:52:39 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/slab: constify sysfs attributes
Message-ID: <aZ1Yx3Er2IFgoDmo@hyeyoo>
References: <20260223-sysfs-const-slub-v1-0-ff86ffc26fff@weissschuh.net>
 <20260223-sysfs-const-slub-v1-2-ff86ffc26fff@weissschuh.net>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260223-sysfs-const-slub-v1-2-ff86ffc26fff@weissschuh.net>
X-ClientProxiedBy: SL2P216CA0161.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1b::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN6PR10MB7424:EE_
X-MS-Office365-Filtering-Correlation-Id: b00f2f90-6045-4769-acf2-08de7379b21f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?OsBojIim6QZb27FPTduB/T65uku6yBdATn8VXtIoyXC+G6HOWRHhIpYTlk?=
 =?iso-8859-1?Q?D8GxmyaUq1rhK/qzcrW0eFKKumegvl1R8Wg8Z+GZh7in/YHPHfzP1VYk55?=
 =?iso-8859-1?Q?J4m13cApmTOISQcfBwEPo+B6FtWlW/rx/Gm6kkx63pesuHBctWEcnOywge?=
 =?iso-8859-1?Q?/R3GhdvSlefSGsyp9NBu7NxVgcyVMeWs20f14fhM06y8Sx95IRBDd6qHJH?=
 =?iso-8859-1?Q?2iiYsROReOWp3k8X1+9tPDwpJZ+QDstpis+qMzNrLwAlahH4jQF5RlyDOW?=
 =?iso-8859-1?Q?O8qnkh/iWKWajDvxN8ngjWwh+4Gz0ntRIJoC/qOqC3qOyyIXQHDg1D6CSf?=
 =?iso-8859-1?Q?WZR8y0jMzqlNIh+zoGwftrArYAhb6gG61su9gAOeGyehZ131OLD0YBnyH/?=
 =?iso-8859-1?Q?/HpFDZv+Vm8qXwynxY8e1ILFA0K0TFYRXQ7rjZbgEg5ruk+w320oih0KjQ?=
 =?iso-8859-1?Q?6LxNEAIO/Vp5fHtsX0bnTAQeibqo+gt3reFUpaNk6fhLGIi19rMu6TNkuA?=
 =?iso-8859-1?Q?mJS5zOR2YfptpLRYst5DNBD/6fK4CX84aqqhukQc1wCsL+bvow+QUEfdt2?=
 =?iso-8859-1?Q?NcWnSC7vih6G67DE+Dd3zmUAkGo90ge7NrEMEfTJRkpvm3MTlm54i/3m4E?=
 =?iso-8859-1?Q?X3vaakheFEuMawCZI8T5L7NcZc/G6mIKWQpUs1TmTW4yO6cActEHx6CyGh?=
 =?iso-8859-1?Q?kX/5sopSrUxT26MGPT+J2iDC9kehSBSgdbN97O7vHFNd6Jq3cBi6pD68q4?=
 =?iso-8859-1?Q?5nwNQMehMb5Bh5pJZMTjsfDwDFV1G1ueuvwkGoMRm0Nlkz8Z8nBrfa0PcJ?=
 =?iso-8859-1?Q?1vG5nf3HBBHF5fAP1EwW94Assk+mhPB1RfDtLQANctfFOOncMjY20Fxmhc?=
 =?iso-8859-1?Q?/EPwwEnHOCftARpskDJDbDPS/GswJ2oqtTG2/DUvM0O2AZMxJbk3g6Wbw7?=
 =?iso-8859-1?Q?lUddRYRuilsTg5bnZpjeRkdfRKrwUDMErU8pewW+ZZN53Y8Fc81JElwJd1?=
 =?iso-8859-1?Q?dloRIivzFaQfqf+HR3+AF04IC3n+skJrvY5VpsNx0Twx/bSjT36NH9JM8Y?=
 =?iso-8859-1?Q?spEWlC3WTwbefcmawCg/aQZPa3KtAEOi0v6//mZLb+R+p8EwdafJFzwOgp?=
 =?iso-8859-1?Q?l6sFvSriz4J/fU+IHP2jxzx1K59gwab/Cjuw26W+DgwI33UuzPp7+Zp/vS?=
 =?iso-8859-1?Q?wWVj4rdLObexr02MmTwXnrSCsLs3MUguVXRIN82TU2ApXZ4uvsNWaN/5vJ?=
 =?iso-8859-1?Q?dS7xs7RmpnR0mrnVlhllvTsrkO4PtzgkJyy0CBMx184cqbFYsjVboBSfIL?=
 =?iso-8859-1?Q?A6+CChKSlfRikXYdUY9fs6sZHk/mWDNjplueZaDD6vMkNnaTFRTLlJeHz4?=
 =?iso-8859-1?Q?v9tS+quRmOYmmbTqydiixyCMyTmV1MQc3Iq5O8GfxDXM/FGf4kWjb3gnep?=
 =?iso-8859-1?Q?V++4vNIIed3Thwx7IzwuQCnWW5lXIgrzfoYzexFw4Jr0p+OCcrmmI6YCJJ?=
 =?iso-8859-1?Q?jMmblGrMh5Lk3f8BQvIlcuvckehOWb0GSmWlke73SPrXBPvpQo0q0T8eSF?=
 =?iso-8859-1?Q?cV1zw52WvxGLYs/J2zZPbbTEjj9xO9l5OrDOCHM0Ib+0dhkMCPGkU0K+PG?=
 =?iso-8859-1?Q?pl2f9GRLllhRs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?wXhMBOo/L0HtcEfP7ZyrconkcYRg4HWvLQD25z6/U9mRI7rrlmI2vd9q68?=
 =?iso-8859-1?Q?WLQD2GKx40q5aRPbZKSYAkmrZtj4ezuCoq3G0LopN7tanLMz0FHpP5Ps0a?=
 =?iso-8859-1?Q?6ttCxotXYOvuDEQVroPX97p9WzzzhM25+e66LF2Tuyoml27AjAQ9LnY8JT?=
 =?iso-8859-1?Q?Hj2GjUxp7Hy7bpD4YTak9g5CYsRasXVT4ld8b0+J4cB0b4SoPD7MsGA7h3?=
 =?iso-8859-1?Q?ugxi6ixZetJBdmohnsoKFdGY6GKtWNJtcuw4C2Nz0VDamVnQchJPQwoNCw?=
 =?iso-8859-1?Q?rVNVhqXNp6qm7hSv3t+PlDsmDow3b2j/BEwIPdFd6ciD33RtCHmawM1ehT?=
 =?iso-8859-1?Q?+CJarQ7mGjyKwxzDHhlHhG0zaC1I8UT1GPXZZmgZVJasrnuwK7urJGzrRy?=
 =?iso-8859-1?Q?FssDUwLijPXwdgvacXicCIjFPf8OzqAbyrfgyIzwd2ED8n4SnCukqdfCDB?=
 =?iso-8859-1?Q?1G4U3dsB4sZ7/jAZbN/IwrNoS4XTR+Gnq9cu4rsKFCK/Li+kPeJkZ/TbrR?=
 =?iso-8859-1?Q?7PF2yqwT9LRUpPUfJ+R8oVY6Vi9Kdav0n0DyO/Uvmn4bacplCFCemL4dcg?=
 =?iso-8859-1?Q?y2GkJlAxJbVlYYou3npUpEqbej/3N/1rmC3XSyduZzakByVrgccwuqd2tR?=
 =?iso-8859-1?Q?tAsHXyagUTFjfaTkJiEcVEStq4EuxF4lLfvk4RzUtYjnUs7iDnNJO2pAW3?=
 =?iso-8859-1?Q?clej19KdwJRNqhbS3Fupe7sYlLbVWCol6o0sWlfv5mcgc8AIVaF30ZMkq+?=
 =?iso-8859-1?Q?nJcI6xjV2GlZjc0rn2MdBX1lC18t0Y6p5EdjKPRdEikXxKlQQ6mOQscVSf?=
 =?iso-8859-1?Q?ul06GbafBESeiCLHSTc5C2fY188apYpXIGnB+S7N8uZ3UzpFecKNt6bqK5?=
 =?iso-8859-1?Q?puxf5N0V269qUkaBjr3PS9AiCEdZBJWcuhsCtxG4qsh9wAcCE1mQPqs2FE?=
 =?iso-8859-1?Q?8dHNwbHVU78B1PU7PiwW0PvrjAwxUJ335xTpyg1xH4qWMQpnq599jF8Umq?=
 =?iso-8859-1?Q?BWPniZXg1W+YZP9w/tCCVJ0AKWHxAGWiiaQ4b2MDS7tFb4TSx0FyMk+ujc?=
 =?iso-8859-1?Q?3Fx/c6tuSIgFaiS6J0Dmr7nRXMdyVfB5tqwKd2sdQgQRqaWjZn5nIynTpR?=
 =?iso-8859-1?Q?bpZZQIF/f9tpyP/25TEvcdlI+9Nfm020CmEZr512tNnU0oamCUACCWkFr/?=
 =?iso-8859-1?Q?AtKfMBZ0KjgzZak6pQQZt70vYLgcex9PfzNl3gUH9reg+RfadqN5ecpmNz?=
 =?iso-8859-1?Q?kR6h6h7UyfBzvydI0EyI9UsWwiGZKipG40Mw74vMghqUeHOzXaR2LbG2KF?=
 =?iso-8859-1?Q?V8U+iMAVCjLeLbcmPF4+U6Eo5+Gs24LKG1TEC4uUxsj0Ehlf6WfszITxyj?=
 =?iso-8859-1?Q?L0Q1+qhf9r5aluzeP3v/CPLJUQqDAYWuFsndcVUnJpIrlACecaEo2PFQWV?=
 =?iso-8859-1?Q?7Xu8Ho70KmkTkwbiRVUYxQoL8JmApBQz4WKzVWuPJLFt74QZK231RkrfRl?=
 =?iso-8859-1?Q?NyF5DZF57weTUpB3HhaauMkG8TYZOONE2PcdhXRL83rEDAz89DK4CHXLyW?=
 =?iso-8859-1?Q?le+vEp375/2X9V5nRfoO+ZGfgojomrbr91bDDV/EHGgIJhIlESKJ+0p1bj?=
 =?iso-8859-1?Q?9gmGOB1tE7bx4Y+66qL0xGxDCDS0MqaTRbZI2mDzy7Vd3wzzfFNc94RJQJ?=
 =?iso-8859-1?Q?ACHmZAQM1hsuK1kzdtBPtpHMPJfHNd7ULsSiyVSkTOm9azCuepWzzX+NNe?=
 =?iso-8859-1?Q?oaH3+w8PEEf/179fSa3LLYyImFtChYgBPZmpM51x04sdl9U6zNfl+GBqIo?=
 =?iso-8859-1?Q?oiTH6ZII5g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1b5+CFz66b/16Ff0TvXJ/wrZ8zo1DO+QiFX/T8640U9umgaHk+S3x5VwkbGQZlvSd41Xsg5evdxGWmx6AsEcxoEU91L1wimdnorzDPZgzU7Znc2KsJjuMNfhXeI70DFRDYEHMH95FEOTDecvxR1kUwRlyl65y8Ed1Xtau9NZnpNu6xtSnyyullCFYt4nYI1ZM3inTPBiyuKvgfHUsAH2XY1DAHo0jm0VEm0SJ/tHvjZfq95DHdyL9e6O4O4rbvkWfq4sbjqX51DxywZ7lO9/J2RAwBioAu/DnBNNaMk5xLxTt8lU7gOPHLax1mzac6qDQjIhLZOrBoxCbfyjsuAzDQOnsS4wg2KYUpsApOWwoOMSL0sX7lHqMNIcJI/RpxFsmNbovRlt1BLEZ7AWtThasoujqK3XMSY9xbZO9gnsu377KPQMbOYME57Yg444k3ZqqGkKaNGi2sKJGJ8yesB96n8e7bLYaS7s0XjQgD0goPVBf3WuJh2nmi2vbY2x/DSfM3b1BOvOyxZUpr+UtbOfEi8GZJrZJc+hjFe9s3QzL8sk8E2HPIhpnbKBDEeonUhqLGoF1U9Y9aRUR76/k44RzkxIl8O1LjqBMU30NitnSOY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b00f2f90-6045-4769-acf2-08de7379b21f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 07:52:45.0937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jETzFCGlgUeLVWz48RgG16wRz69zziZns8Mn+kgyBi/RbI/l6XRXolozLiM55BmNJW6+dO5mAlG0POYoQ4ogPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7424
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=867
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240067
X-Authority-Analysis: v=2.4 cv=O5U0fR9W c=1 sm=1 tr=0 ts=699d58d0 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VTue-mJiAAAA:8
 a=yPCof4ZbAAAA:8 a=cfcA52adaIA_wEhgsAQA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
 a=R6trLQSf4H0A:10 a=S9YjYK_EKPFYWS37g-LV:22
X-Proofpoint-GUID: tU-zwapFfks6tTOmDOOpp0t1396uHDhx
X-Proofpoint-ORIG-GUID: tU-zwapFfks6tTOmDOOpp0t1396uHDhx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDA2NyBTYWx0ZWRfX//MLfyARoDRk
 M3fF7dr41BuSNv3bCCCfxmfJ3gZyMajl/jJcpyLMUgKQNmsbGD8/+9TX0Pt3ifZUPNOK7hVW08j
 Uv/zFvCgf7Y4h/KVKzVrhlh60XRsQlXaLjHBP1KQ2S7PmZcxgWu0PmN/qoRelbnA93rve2WSGET
 sJdBX5/FsfTKypyf7152y4TMu8tfe2gtR9isyk3zCqbqUFlsfk40v7gSCD5K/fdxa7EBcsRu8SL
 awnJm9cq9eMALY1HjKfvv3aoHAVR5xQVjPHGTGUiB4dG6lk4/j1o3Wv5UPeBjHQJmnw4AVPBK2v
 GggstmzjnK6u0e2oVwsLMnME54DScazz3szuhAL+4jng3apOGsnMlb09UBoBPQAnnYQt8P7fuFP
 0ruVhvSYnR3495mCI2NYB3ofdLZgSSfJcXFtwch692jn3pfOzYKNl7arNILXjjaHQMBdYt9TZBK
 i5HCCMVd/QzgQRLeneA==
X-Stat-Signature: 4shykt5mqc4qsmz3p361nhny3uey6h36
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 14B9840005
X-HE-Tag: 1771919571-985743
X-HE-Meta: U2FsdGVkX18uwgYXAUNq/iWuLdRoVkLaDuISUbZJniOtW4BP207gqcl/wIa0ArL7TZu1hoOks6UKF3A1LjltHoa/Ion2nLBgfFY2eBoX77fRc4Nvnb3Eoh36YWH90cyy7vcIDEeA4cZ9zFn6epgBa6nfwxTe0JcPoGbBXFIy9YA7C6phK+EoFdftCgi424nQs7jlz9cwoJlnoVgOdQcH9rjGV0bZm/WANueJfq6SpTsK3xCId++hz57CdXTqibo5CHP6jG0bqXaj0eNEZYF/YHckalEujMcSUA6e11OcA2SeSacgDslnPrLgfie9MPEXVPfUJHB5nwD4URDRajWjAqgZlzXQwaZZD7pNEpnuUpYpxn1WWWvP58lQQS9EaOtjB2rGeogx39U08DihNraYh6xoNBmmsNa1c6724FGQSterS389Dny8auA+W9FmrkNMdqQL9Kpn9B63W+NfiIEUKDy3kqiU/O+FJ/W92soZvGv8o+z1bg8TkqibD8eIGjpDNzS/WPCSXfgmTDjE+sUnhk0meNpJ9IVp/267nwPNT6LTe0pukt94P4qREjCibI9s8u6xDCtu6rVF8pOVUfSRjBltwl1eCfBnwZ0bAaUMRAW6/QqfJf5s6v0mZcyJK6qbLHqZGJRAfZ04bV2Wm3BU9UoMNnuSgPKownKsyEGGX8FFMu2WYwmWYr3YC1Pf0XmucnIPZxcildopBC3d0xer+9uOhBwfwuUho671kgN7+MmFpAr6S+1XLWuD3lHFG9yHHA2RHU0MQuGzlhpQA5ZNRdr7rwp2EFSDiaUGNBnJQ0xgzqlJ8JISC2dGBBX7DIOGBdWuYTUmfIkgOl2Cbj1+FxXGLwVp640B/ZD9QENF+ZqDa/gSPHOa9ddY7KGqwEQJ4TQEJ/mVLfOs3kZAlZgkwstwLKMKHJ75sYYr96iiyc+XMoTi5v+phgGjpl9KCyL4lGUKB0gZqVxoDoe3BDN
 ihtitbgL
 Pif+mx9GUYFqxP5Kc+4mqvcmD4PB3RrBszbVqawjpKuiuyaDe/so7FZw6RbeFVtcsWwpCxOVdQ4g98jSx7/01S94Iqw9LFBBrx0/rq8k2vGYrIh6tOSS7cPVXVW1KpmhtAE4n4UXnOOYFBS/RhEPF3DKVoxgMspJWVuV7zJ9jcNBiTzTMXkHT4zzgnSgXWbgVccCdnsVbsGYrOMY64Gz2t3g3NaGmVPTuUZOyrqO3MbynJ4HJQblCuAK3M8f+x0mVcRNsVRT9XNvCxlkzxNGs6jmC45FamJPrk236K4TihnO79e6IU97R7VDJsWTKYuczn7JidZkn7a60/8Vk/1rou7zyNiEhia1vHTQHpaNaxLEP2N52KFHv5MOiwIoG0G3V06uoG4XUxruL3iSYB5fkq5j37bzsTCAmXtdIe2DcsPGNDfHC+NS0Dh0gWeUEYa9jrVol++hiphLRHrHFbA0mT8EmPunqNALURFrP3655C+hUQLcdjjpM8iV0iRKQttJJNWX7a0PgNXZlog4wwtMYfpQYuhw9v4QDY5udC8UtIYc/VuZWNI1tMl998bLvvJxe4xWIM4zBuakZnCR7kBNYMw3K0WyIHqwbvJQsnU8WZde4deYYrj+W90cdPZ4cgtIKKrNq6rAnmCS3LJ412BVmHoje0VA+qJY6IcFaEc5nKLsnQfOAyN7ejZBybtYFd161waEibhkEBz1KLtjv6TpU/imgvfi0IZdXaUR0U9Nc9CpwS3aED73WM/KineTVt7prlkKx5C7ugwoLDKtnPTJqcoivr7BvUF5jJ6AT7AJ2/uRx2iGJssyATQf0t/jJtvkTwySDihDyeqREA8CQvB6rtCTaoUCZWyebPYZC/Zsjl9CXq5BK5BtLySEDnUVlZLfJV89Xnarz3ghx7Y1S3E92Hv/mog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 10:37:44PM +0100, Thomas Weiﬂschuh wrote:
> These attributes are never modified, make them read-only.
> 
> Signed-off-by: Thomas Weiﬂschuh <linux@weissschuh.net>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

