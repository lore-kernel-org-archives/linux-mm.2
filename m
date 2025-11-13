Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F4C2CCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FDF58E000F; Thu, 13 Nov 2025 02:46:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5C48E0003; Thu, 13 Nov 2025 02:46:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C3C98E000F; Thu, 13 Nov 2025 02:46:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 181758E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:46:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C742312E505
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:46:12 +0000 (UTC)
X-FDA: 84104800584.17.DD9D90C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 75CF7180004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:46:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZQAJrSDG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n08Z4zg7;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763019969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbdMtO/Ke5uCoz6kftcUVIsP2Uq1DC5Qyz3ou68PZYI=;
	b=XwrG/1br8LqEp2ICZ/1k7H74x9mo0a+CQRU2NCBd8VTPloXm7Q9L0Z7cfPwjOV4gdlQp2b
	avMWq3KlEVVUpoa1cnckHhNrs7Y6NfhnptGg5kiZsrbS4/lmnJSiGmQqwSUFKG2Zw6vK99
	v+J9ct5Oa0wUwYrOnAW9XHnOjj+Ucoo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763019969; a=rsa-sha256;
	cv=pass;
	b=PCjzW4P1M5etRLdDBg6lcc15Sb73BDFc6getlSNNG4XmZ0oQtDiADAvTG9mtNN6IpuAYiJ
	wdYjfM3ROh+qx21FUlB98H1Xf0JveDxibADxa03djW52hKtPH+rxXzsavJjrl/otFPcudV
	4jEed39NeT098LZ/pz8J4SzO8UWSTxw=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZQAJrSDG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n08Z4zg7;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1gMB3023114;
	Thu, 13 Nov 2025 07:46:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wbdMtO/Ke5uCoz6kft
	cUVIsP2Uq1DC5Qyz3ou68PZYI=; b=ZQAJrSDG1S7TiKlWULSjNSEbqEVSe67CD1
	MYZP2jfgIYdIrKdBy/XliJVvkzJhe1h416Pc5lKFhqunHksnYCvd3V+pT1eCvVw5
	VwcCtmjltNFJ02vk+bWnDyHUjrtt9E80FzUYbILN8C07PtoYyXd+VHJmON+GKa2/
	4BDE/r7kuUAk2HkTNHgkLkeCpG7WXTO51NUbRzMoU2wwQBw2exILU08/3qMta8tj
	2IaGPce0JKQaEauPNXtpuSGZTcEc+Zk155wgXIZbYZrlSqwWQ8H9V7benag4ME6D
	CTH+c5BTIqy+IClopWOiPayXJBS40P2pomHxN7uTI5Z15zj1zZ8w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acybqs5c0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 07:46:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD6oI7Q029232;
	Thu, 13 Nov 2025 07:46:06 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010051.outbound.protection.outlook.com [52.101.61.51])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaftsd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 07:46:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F7b6ojj/CY/FrRCI24kCZJ9VJd/ucA/W4kpVhJ3j9qTf7mCLSAGeVS9Jrwm/3F5Fp8BiIzlt+oIIWKKKHYST8pT83v1va/zLBZh2ljPRmicumzDY5k0Yjv3DC2jn94hE2PEdSWIJDo0yYdiQfr1hI7NcfVcvW6Q64HlJhCwCdcRjXQFQU6ZH4k6co94jeaEou2AgYbKXIFDox5nUEYy+VcOUCdmf5iy60gZZtHjdK5MY3Fv01Atd6Lftf9UXKeMVno+quNKzXBNY9cXuGgJGCYTODbexVLCOY6i/SAMHE6bRqjljh5rhVpc6Mq63Ybq20GGskaobe3+SIQcS/omrxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbdMtO/Ke5uCoz6kftcUVIsP2Uq1DC5Qyz3ou68PZYI=;
 b=NL0i+Amic+FePe15CR6dlUwBxRwq/xO6Z/TAJZcNJuDqXwIndKJMlDWv9Oz0l9rgKNseDacb2yaaQFzcV8dLL1rUmrltRHAXnIbroZW47ERtvwJgCQH3UuBIyblpI1Pz15GKsJ7HJLxOiZ52lCeBiYH9XQUVe0kGGQ+RL9Gj1mVQVkuPaGxTqBJ9xIqaXehaI3iF01/ll5s+9ohudAGBZ9xNHe0erLpVuje0Yy/DTTcMmipB1gvH35yjp5mVuixUJJWgNvajX2MGFYVVxXmAn+WfGONLXKvNCCidl7paTUZa3EVUv+xrRa5D9Djt08WruneujgSbDSs0q8EkICn6IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbdMtO/Ke5uCoz6kftcUVIsP2Uq1DC5Qyz3ou68PZYI=;
 b=n08Z4zg7pWhRTPF7rflInoJ/epxsc5AJFV1RVn9BNWlxcQ/Ti0JNZRNNLSHqScaBVk5JKoxOYSQ9iq4Rc/LL5LGLCZouB8KkndbIBBrzbJdvPdW0zUzlRioXv9xBnDpYwSK71ZmDxRewprt0+b46gxgAXv3G8z7jX6uKE1yt+24=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 DM3PPFC82B87818.namprd10.prod.outlook.com (2603:10b6:f:fc00::c4c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 07:46:04 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935%5]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 07:46:04 +0000
Date: Thu, 13 Nov 2025 16:45:36 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] slab: use struct freelist_counters for local
 variables instead of struct slab
Message-ID: <aRWMoIUFO1tOFFai@hyeyoo>
References: <20251107-slab-fms-cleanup-v1-0-650b1491ac9e@suse.cz>
 <20251107-slab-fms-cleanup-v1-3-650b1491ac9e@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107-slab-fms-cleanup-v1-3-650b1491ac9e@suse.cz>
X-ClientProxiedBy: SE2P216CA0062.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|DM3PPFC82B87818:EE_
X-MS-Office365-Filtering-Correlation-Id: e3c373ec-2b33-4777-caf1-08de2288a8cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WAHL+svEkEGMX8ZWHdDmJAGaR8cGkubdlSo8YYyfHLeBHeRLv992DSBjE08t?=
 =?us-ascii?Q?7NYuk9V5rFudseVaDnvXA8EGi8P3fRsmqdXlMuh5Y1cbDqGKNx0LPp/hokmR?=
 =?us-ascii?Q?eTdpAQUYHLr98xhUoBAYmT7YYWcvpM/TqZ9RVrNucaQ/T9wLckRIQm8f5Jgd?=
 =?us-ascii?Q?P1GU8qfcbYRNAFN+YSzY67KIg0EerRmK2OmC7lF6obtsrcw8epgiWSiwrBrO?=
 =?us-ascii?Q?UpHwSmZu0TyOOC8mvGrZbjaq2MYLKhdnItR7dqrfsYUWldtVrhANEq8gMZTW?=
 =?us-ascii?Q?/UmIQhAGLWC8rzjqmtQM2slmlVOp0PPKz0CYgQkbt3VeGOE/ufiKwdmGQj6o?=
 =?us-ascii?Q?4hoASjrIJp5bk/cSgIeyY1+/IhZ5DYl1j4++/0Srg/x1m2QfCOcm1OZVHNoD?=
 =?us-ascii?Q?jJ3tCMr40gV7EAJ8I1ThHYKQ/nt9r/G3cGGquULu8mqz2/m+VYbIIRM53fvd?=
 =?us-ascii?Q?bYLuIW4xzytFMkQ3p4Ygl8SXXH+pa06zKcbHbH0a8zAwZeOcmmeKYGbwXOS0?=
 =?us-ascii?Q?qKRXJPYCp1J0n6MhDb7HhV29WGmw7aCNx5idHpCZ5qp8PPEMwHqf3/PGqXxl?=
 =?us-ascii?Q?5TjBYaR4sVn37EXFRX0yWHLf2A/DDp03MXUW+JABn2C4Ru/0nxgH27v3wOUv?=
 =?us-ascii?Q?qgIK7gfaZIdYQ1TAWPaNstGhBZ088jBu1Gq9SL9mlPXqlhd/uDfIRAqPNaGc?=
 =?us-ascii?Q?3T0LlD6KSCOR0/+cqie7o/kxTi2zmDb/OV6rXKRJWEv/FSm1UwR1MHQ3c2mj?=
 =?us-ascii?Q?srSvkGXiXQ/NSKaUBp0/mMw9oVO2O+tYDYg8J9PLg85XRnCAFHmZdFVtvW4K?=
 =?us-ascii?Q?wCeOgQ00d1J3uFl9kSnPn0V0G/AOLyXryxgqrMsFzacw3fB5+nuzWARyg5f0?=
 =?us-ascii?Q?FS64QvWeuliNSD7TAHOtiGREnAaFqAaDlqXj46TK9XmvuLiaNyKPYvpJU34W?=
 =?us-ascii?Q?3cSZTAqjzVmaVg74j0xmG0mlgWtUpYIaA27KWU1a5XmPm4dqpSY7uy1EV5CC?=
 =?us-ascii?Q?AJwNUZY08rXwlNsgZCOKx7bP0bzo/8fWXePtconuqFbrBEYJJGqrMv92rKu6?=
 =?us-ascii?Q?aplgNdN49498RNbAUDwD14MxVrtemqy5u7F5ZmXdOCrshRAGcwL/DXFLMqyR?=
 =?us-ascii?Q?YqwvYyCHAuETnnrji/U/KtPxvRAt2AAMSSkcHejmg+L2aVWDPWizkmxGT9HU?=
 =?us-ascii?Q?pb/3vrssM+pNdygIfSG+f+4FzJT16XLrPBhUxzehrKM26rCwh22yohGLFwoS?=
 =?us-ascii?Q?vQ1C9HePjxXMNQLed6A/Dx02UL4cnmN+kGgFI8incuUlOqQj5nQX04WAKK09?=
 =?us-ascii?Q?WurRhgdOqwP4Y34yXpw8c/Up5hnfBzkcLkLbgI79+TloLUt2UYActK75bt0J?=
 =?us-ascii?Q?bBaPu8Zu2GmVwJLIOxGTERwBcOzXAEeunqTvtNUv7nBdD6bzpuQ5walPYYHm?=
 =?us-ascii?Q?DCjz08SYMyr8y90XYMjeG/klYtALOeer?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b9VadrghXAC+k0M9VBO/XinK6cHduzXkHMXvcAyfGmpxA2GShcGQm3grwX3W?=
 =?us-ascii?Q?8qAKQoGpGkQht6h3HE48woMrBMFuROcnpdqgpRmgLQrlmOEb5BOC0RL08Ta6?=
 =?us-ascii?Q?d+YTNJPhTcFngyRGivFPyhCLxJfrn0ICOpn54pBwkpZIPITr3dRPyA/HkPzd?=
 =?us-ascii?Q?WMvhn2l8RLbO7yCgHHxVbDsINbP9F1/GSKZredYwv0UgrlqRyTuszLzt7lol?=
 =?us-ascii?Q?fRUY4uEY/E5PhRokSiVlw7GwlnWdxpsWUa8DYKUWipvY1+m0384NA/SX/RHU?=
 =?us-ascii?Q?xnKSAHOe33dF+9v0WRIpj9w4/1V4sgZjz8Sj51yJMh7MGOlT7rNDIC6MnsSQ?=
 =?us-ascii?Q?Uui97Zif9iGyJ5W8LCukFQuNhBoHJDKzhOER2N+0IOgoszKl7dX5AmTp6iZ+?=
 =?us-ascii?Q?N/pU51JwmTrZlzB/sdvYfrfYjnNVJHoV9Tx+Q2LhTnuyNJ/WIUsrk87kfoYX?=
 =?us-ascii?Q?lah4rXPx6b3TPf9T3H+IJD6VZNQR6CyLXyP3AFoyZqX0LfQqxuNPvecfUrdw?=
 =?us-ascii?Q?+h+h+ZX8orUAoFXkfbtzfDO3w6YpsrqiGFq1wDpk4n2Yz+6Uc594j8cqhEf2?=
 =?us-ascii?Q?yvkXKee6i8wZN4lkbWEvZvm6jhC2oImbQW9ZsjXpGn6rgQaJJYms+NKjkvp0?=
 =?us-ascii?Q?esbgB95sMeFcLh39gfE6BA8yKcxoitJXCvxnn8KI1rpJLUq9d+UGhLArlil8?=
 =?us-ascii?Q?HjJrvRD72wqdI63Rh3E5RcejkAYgUx5gMeGZ65eJpcjEG5Zzn9ldOUFJhiuG?=
 =?us-ascii?Q?mjjIGTaiBzPnFQnS9+F/mLZRip7anaQXyzah8Z5i0pNFcsLCuIfdUeCunPwg?=
 =?us-ascii?Q?+WTZJgYYYpExjCaiVgAw9Wrk11IDx3RiDAW9IpsRHLdCGRn50uUSyaTpFCnn?=
 =?us-ascii?Q?qwhOlcZ4xQkL4+s77GHlrDIHrOSvdWLghArOY2LcGuukQ9oL8ToEVPSVuF7Z?=
 =?us-ascii?Q?bi56y9zUkwHf/eOBc+ujHGlGXEfb5lcKwqXHsJrntt9a7tjm7i8Y5Sw9vRVJ?=
 =?us-ascii?Q?C1q3j+3h0xS9SjzpGw2lkWq2zV0RMRywRtHrVoViYqCFjAS41B3fPx+JcNhx?=
 =?us-ascii?Q?9Go9/fAmVZXil1f6Pbal9wDBgiXbZFo0O4rc9/m2gYmZIdr9MGxeMk+Pdc4z?=
 =?us-ascii?Q?wnw2r1y2sw/sTPyMEkbQdHV0ksimCHBdxHu5iyYeQ9c4eEhOwX91PIPy6oDg?=
 =?us-ascii?Q?72t28k2yBe27eZzc9cSsu8w6Rjwd7EDPaCmu4HXTkVAuI1cG0ZY0RFaioVLT?=
 =?us-ascii?Q?1XNZYu15G1WoRsur4eHgeD58msmKTs8h3+2PfvW4QyWFM3t4e6EUaObQxzxm?=
 =?us-ascii?Q?dhthsP7BsUasO8M3Pm4xldOqMV+02vde0fq7rOBGYAT3X2GZhAhlmIDzqDoU?=
 =?us-ascii?Q?vz+iHKasB7x/Np2M4MeYJUc8DqXqihJlm2avwjoXFyMQMxDq9GxrTIOT8K5n?=
 =?us-ascii?Q?Dxi2lmuTVNkSq+MVdN8FydnBuY1NjJ83/Z75Iu3b1j9VgXlk0Nxn235bIVTk?=
 =?us-ascii?Q?QE0rgZ93pT46JHVsS8DKeDkEgAMKS6jJk+Fp9kx/pLD1vnMZFKO2ZJSWQUhm?=
 =?us-ascii?Q?yzNvjPWY5CG8etjGDyNdCLatD9HAvUXKWTv1sfNm?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Nztm6MMclFVQoBQmRcm2AdZfKpN2lpOOwL1dWW31rWXSj7mfcZFGip0AE/Ru65H4Wh0ogth1psik36SG5xAE/Anvr6t5dLASEZgn66gPW5bp3PLQ8gVsEN4c25RkbDb1yAmPa3jFPSAbtX0fcm9JHhBpYfGObpTZR2CFH/ckIqsyresSbUKIZGkQ5sR6yZ3CpdA8WuXEZ3+HZTEWdluc+stqFImCraRhQJWklgBKsritapupOfopXLqwuHeP62w4mQmIoH4Sj5IeWHYLWLwGS6Z+wAk7gPeCkagMWIdcvTNKYbGtJxP01JnAgLd0XttpkexXiJtojTTbe7D/Q8YA9igBmWfRm+sl/74Dcl8JgStjgmgAV/OW7wq9UcUsoxHGhf4NNXb4jPrCuaUeFR7krMSYRF9sO0nOFKZPyOvWlsD84bFQYYYV/2l/AcuVylSmQYlzk2CJB3Q8jo1s/t76leer1Ph6kkkmBorL6HZOVtzoO+RlrZPlXrDxhYc+DbxvcEhBM94TY3KE8XdzcLSAXoZtk8xwsKsjpN0YObM7OvgdUPByCqb7C1UKUMXT4MZkzkvzoGMTWxJRpcErXYTeYikrz2r8pr0G+I3nb5v27wc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c373ec-2b33-4777-caf1-08de2288a8cd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 07:46:03.9461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y0Zq31/fbt6aXkAq1oUD8OH9zknj7hKqtSQOJqg6Rn1ULKxwmODLTfEvwj0NRgj6ankFqMEF3VnBUd2i61SJEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFC82B87818
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=949 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511130054
X-Proofpoint-GUID: ic1qEI0vh3tf3uzsH4PfEDFtslnD3mHk
X-Proofpoint-ORIG-GUID: ic1qEI0vh3tf3uzsH4PfEDFtslnD3mHk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0NyBTYWx0ZWRfXzGa49Q1JWIGG
 yhAsYGLE9a/fNG2TsDU/j6pKVHMCtaTLYDi8CxzSZHxoQ6/XUgsqLXgT+OQrLooMIsru113/CX8
 vt0rnCSbdwU0ZqbQOd3daWnvqZ5DzmaSYW2GfND9l6EsuX6voHSW+8eAZvm16TKGm/YGmufo1zZ
 yRpj5+F88bGcF9Z4WHN6osrLR6ve6DnUq2tRi/pVx3eaZX0kO3U2Lhxz4fmUOHUWSFWWbqMrL96
 Yj9PXcTsMhNGqWVybzxOBm4zoNwIVMj0bHSMu95C5B7/t/oaTt7aLe+EvzkVrE8MkuXMrhM7KaD
 iE19z6i5RDxI2EyXp4dWcnEHf9InEl4Cq0KEr8FWQ9IFmWzzxInzMg0zM4bRcMelGDK8HQgfu8d
 zDdkNecGXSSL4Puq1n0l4PPvvO3PqhBn7Un63KqTKYOQvlUK2II=
X-Authority-Analysis: v=2.4 cv=X7hf6WTe c=1 sm=1 tr=0 ts=69158cbe b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=GjZSFUo99zoroA9jFhcA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13634
X-Stat-Signature: dqyx5nrzfugbk3k5kdjtzooeqffm73by
X-Rspam-User: 
X-Rspamd-Queue-Id: 75CF7180004
X-Rspamd-Server: rspam01
X-HE-Tag: 1763019969-340101
X-HE-Meta: U2FsdGVkX19l139D3CwxBsq4u2/pvgE0h49JC3Lw+ZcONfm9UoHLfAQIF3OEuK5Fe6atDqNZoT2gapoYk57/XLBR1KPdxp+SJ9m6rL6WXjwuHGWTRFJl2AJP4J165g92SpVI4YXD8jFaY9A6AB2lyoLCCtxI828bIyqSTx8Vno1BHjN8XedJ3psqkrAnkT+7jQPxD026hmJT2uJOsbWkfz8pf3rwsMVHxwUVxMRXq8N7NRDxY+jJii5tyVVBjYlAq+TQhcF61KYFzjzvOZIVFGJ6MjHuI/70EhLYuJtUhXdMFgaAqaI7s7Ctx5KOPpIEV8Snjc9JEKFRgQ7k8tnn1ruMwFtrVerhXDTsXYw2vSnKcBPpZgGXGdZx77iQca4GBX69Y+NfiG+9jyE9gBx2c0J7sy7u8VXhMzZSsyYWfq4fmBsMYrsc63vZnjutEfOWv1sbsDL9j8CRD0k/to7CyMiPIjR3brQll0oMyd2leGKh3M9HizSdUBK6wKNJNnilYYbaTYQE80J/UAqf/eTJH10gcyuuUnADiuNFDmHRCzOWWOf069/DAAe710uuciYmg7KVmpUDCMNByPTvqUKG/swPZyzpJM23venESCcxgVkCRM3LOSHzym1tWGU8vx11IA2sX3oUPykpVKPux81JRL3hfMqvNPQJJl6zJxmkcqazKtcLLrnWWFH7ale8GiOz2mN++OCvf76o0WmPKVI3JOaYBQc0IRM7tTa36hJ02a2lQNCGQeuaI7tgIrQ8UHoccZ8EY42uecUUV6v1K8vME3gS765pTt6NBb1G6eJFWl7k9h74t+a89IIvpWHtncR8txXoUFE8YNyjVCywqeldMMGeWHlGm1SeMI0HxIZNUVUgOhSRoZPCwfjLrA0O2O2zvuAgCqitzD6mNVPpZ4TnD+eNlI9n64UvomrJQnMdoMI36LMtl5oebkjJZHlRMdGZMXyQXOgLioCREhZynWz
 kJDdA0Ls
 2cA93Uh+87nspjQiINRraOXy80AEqXz2kbKYIg+tI3B9ox2/IXAvG+rHnyAoDhIdnS/lrtxzqSIJoGSkUxfKZoeQWXm6uNzuJsvR+gI7Xh6Jz55Kb/tTHcyIQDPBlUFzl7TXAQON0dvtKICY568kWe3pOVNqPs5WaseM/3BG4hItPHKVc90u2p8bnX7PruggQdnoKIqzI8lNi/5NYLl6g4O62nCsqcNxVlbGPUPxx/NN6u/S6rfM/5Ya/mrSQzUtzRdz+Tu1tRonc5rywntwb0H4w3JRuaLIqe/DbQwm481USkxOJcp1S0xC6OKkju6uJxlyhdHUJd5BH2/M2myGQP6EXodc0hkwNmx7IS96EITxZmXbEJTSqw/H3ZocW6KrNQ7aYbzizcXrj4aUi/Lxn9xoWbFuYOjQ/D8cwtHd41RPFav/GsQJS5Gtl2CoIlF2PDxzip7ZqXDeRt57gl0NA9IWvewq6riMe9vHWEgvHvIoVg7jcxn3uZmZ7i5YKW/Vz76bdsI6/qaGOpilDzQ3xzu5/l/CATyTxs0cRY/avkWNN2Wzf3/YgN69TBdyY7rTp6u9m372WjdZ2oLL3i9V3qKhbGfxQNf87UpxJjEER7fostL62eTQJCfhZkrstU9KlfGYiy6Pbe/ScF+0jetBQSBILbpDUSDb2/FcIHC/Vkz4Hkd5xBN47k4fTzOos0BD2Cq3nI1SDyTlbGYSQfqGgW8NmrGk78XRTzpUi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 02:51:25PM +0100, Vlastimil Babka wrote:
> In several functions we declare local struct slab variables so we can
> work with the freelist and counters fields (including the sub-counters
> that are in the union) comfortably.
> 
> With struct freelist_counters containing the full counters definition,
> we can now reduce the local variables to that type as we don't need the
> other fields in struct slab.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Yeah I've also been thinking there should be a type for the counters
instead of declaring struct slab variables like this.

Cheers to -fms-extensions! :)

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

