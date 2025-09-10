Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E8DCAC583
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385A28E0003; Wed, 10 Sep 2025 07:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D9F8E0002; Wed, 10 Sep 2025 07:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C328E0003; Wed, 10 Sep 2025 07:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 10B038E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:08:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B53335B717
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:08:03 +0000 (UTC)
X-FDA: 83873066046.01.0D73A0B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2D6D9A0012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:07:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ewcFsjsL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fZpF6JpY;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757502480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v48cJT5Lxw3mLkTs43rwQnOXQQgkUpUsuH9dM8jQHg8=;
	b=tW5qmjlKnINr4mK3YIT0ZR9DfqSj/bEZjiYjNavZHHNm9WRbMYcu25FxAAt0vOutwu0dl2
	BDYqsbH3aKG0+ThlgW2gGtYEDWzRDwPhcW0qteiIhV/tkWr/gsHOPrnRGfb2pqaBp4qpaD
	465mmuVlwjutw/VpZFnmefaFdmaOPTE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ewcFsjsL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fZpF6JpY;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757502480; a=rsa-sha256;
	cv=pass;
	b=2c6TwDOjA2xbyZ9aI6OfuKvm37rOS+oHCiso5Svh+LGJLHjLzN8+Pkr6/2Dd1/KGbU8vTF
	ggDB9CaC4xe4htCr4/GZtn+/rEVRbSa79/o/YD1CDB9thHmtjH2FhdRMWg1i3q6vvZOFLZ
	50TgoRMri6N7l3IrLAbYRHym4wF8P/k=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58A9N70G010080;
	Wed, 10 Sep 2025 11:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=v48cJT5Lxw3mLkTs43
	rwQnOXQQgkUpUsuH9dM8jQHg8=; b=ewcFsjsL5Is6kXRvGgPiNLVUojfQCCt2Vt
	ScNtSvmXESjXDKWzuAzf1ToNQDytSmRCk63s3xV+7vY8ASzADk1pbcDOEmGAS3aQ
	VHrHoaQPmFQUDwvkdGo8fTjIlLST4ow4EJWWyDpz/kBVenEa7Myd3EFjuVECx9x1
	qviN9R/BEL0V1PxxLiQ5MVzr/UWogBtH8ZWLf4+U+u0pZzQYQfScm/r7+E8NtjrY
	UZZa7b+I1SF/6MkidiFceZXvFynOW4jWo1d+5+q1etTLaz9Tz1Iacpmhykc+e6nB
	Y407PfxTYAiEnRDNG/hrtQcjHmbav/Uw5Mu2kVF8ovjwGN+Of29A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1m21m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 11:07:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58AAnj1f030633;
	Wed, 10 Sep 2025 11:07:54 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010026.outbound.protection.outlook.com [52.101.201.26])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdauba5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 11:07:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ef2fU3jLX3vu6lpXtfhpB25Ps+ZKcXSm3cUCrYDsHkJVvV44NaMIdnfvO+l9y3Liv1guOpadYpiG/zqY2OLm6ib7nckBzZ2n7vODnBj8Uci+r0metInc7irXRGJRPLyG4xRdXNvVI+cIrbCGe3wroZpkqs+REk342Iz2tfMEk8UQaORLauIMabJyk8+CT8eIdP9/y6XMH3j6//vtjfNnuWcuKHbaHtYFoDfz1y8VObpWp86J7GRL7b31Y/3HGywycTeGAP4tvUA+C8EpCoq5e/MIQfKsi5xUOKJTLE5WUNxaTWZ4iA4LTvaKZJBpuSPtAutpzKqodcLFch/luk63Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v48cJT5Lxw3mLkTs43rwQnOXQQgkUpUsuH9dM8jQHg8=;
 b=eTvoIIM9EMQlbBGimH/TxOn6VzaEHP9TnWRIP2Dqz9lp0hf9VkAVhhiVtkVwy7DXh826B4/qOjVO1iGUhCevyKQrTFZlhUmd97+hwdmEpLeqFuIOItwD0tHWL4O4OWHcXoj/Qm6VTS0oLfFVMgfawyGME3fsGYnTHWaqHYAuomMpERtxIidy6lsYbtTl8msH5x3gtXlkOsmCVrcVjJrZx3I8ocfr4ClUjI92u9svrWSnKh5hlEPeWC3338T31qh301jBqM1u3xiDLtJm+tmQVSwggmzLFiKmBAFl6vdp1uL+5+NDtuzcCI1AYv7kIhxO5H3hJ9Zo4Ai5sjnpyUMdGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v48cJT5Lxw3mLkTs43rwQnOXQQgkUpUsuH9dM8jQHg8=;
 b=fZpF6JpYJTBXk+KP/IlBv4sz5EJuMz2UlEjaaTe45mwj/2/nJpR2/L9szxK0JzQCotAQuiDB2ZwbNnSj7bORjuQHbEHa/i1NGBmrmPDhNnFXbmFunbsr7jyS9F/DNnobKrGqX+j1tmEzhonUG9z4BeIwD2OGO4LazUggIIOdxpw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8514.namprd10.prod.outlook.com (2603:10b6:208:571::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 11:07:52 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 11:07:52 +0000
Date: Wed, 10 Sep 2025 20:07:43 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH 04/22] slab: Remove dead code in free_consistency_checks()
Message-ID: <aMFb_0UmHg9yiYut@hyeyoo>
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-5-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829154728.3397606-5-willy@infradead.org>
X-ClientProxiedBy: SEWP216CA0123.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8514:EE_
X-MS-Office365-Filtering-Correlation-Id: 87ae36ae-96e2-4071-91c8-08ddf05a4938
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4ucgSQGOY2K+CcOjp9SpwXpCDPd+BAPmFYXck+kDD1tw4HEN3uWojUYbf3i1?=
 =?us-ascii?Q?Q4iz+SIZZ62vy1tTQN5F56IxRoHpA9gr4YGRBq3LiIMzwpXHXaXLajRrpMRD?=
 =?us-ascii?Q?FZE7wVkROcInevSAjSdHyFdkM/kn5/sj5hD/WE3oY4rIW/0RCy7etIo0FM15?=
 =?us-ascii?Q?I+0N3QpKfGAFa9/KZz6+dwBrGARNovFa1JIRJl/G1p0pmWu3q2z6PM9fbjvN?=
 =?us-ascii?Q?XjQKOP0tBzFNMLS7EFSkZnnoD+SsVJh66CRArkhCKlAowHM9K6EgWhIljWkn?=
 =?us-ascii?Q?We78wJFbngpir4CnoWfcc90mUjcJZubKNVTDUZNSdYYMdMWrhoILJBtKCFRJ?=
 =?us-ascii?Q?ob1pr1Oj3SvzgYRxAUN24GKbRsn70D2OCGFHzeEQ09Sm6X18CjFCW1aCbskD?=
 =?us-ascii?Q?qGQxTJ7ZAEIs2cbnppSQCCbNibmqM9Ccyr63dzSC/xM3YFIKsiWlrVG8BeDC?=
 =?us-ascii?Q?+BYnj4QeR/LjWc3X6n1VQ2wLjqyXpkXjAGsnv8rnTRN8evxGHxDgyTpXLxjY?=
 =?us-ascii?Q?igzwc3Pg8o3Sm5j79SoKx4mc4cl9jW8EDFzrr2iGbPvVt4WQymKQP/QtXmO+?=
 =?us-ascii?Q?9T2RW00jaQvDhuX8IPIX0uq0e9mk/dYCzeVApE4Ty+7IaxQgAIXVljEvZcHr?=
 =?us-ascii?Q?AiVkxJBun1ECi4GopDqcdHO0uBIzlp5PAJG8iOTKEPt6BK/HplEYZBfAr/LP?=
 =?us-ascii?Q?NgdE0tLLNQC+PScgy4FO8QGPEBsbYmksuFBYn4m16LRfb0ImiSm/3svbLR7G?=
 =?us-ascii?Q?PtWH5Wdak5JvWYU6+wmtfDfoYnmnjKTBL1OxqlYfvelJSZg5M1yelGkM4A4X?=
 =?us-ascii?Q?XKN+aPwNKzsYV2u/ye7dJlWeLv3nvJ6hA6ki30fhjvJ9aGxaZuqXCQGVV8yb?=
 =?us-ascii?Q?oJdTxuM5YziUVu9vhKFwcA1vd5JPAN4ymltghTJyRhZdl+kYfq5XbuyXHj05?=
 =?us-ascii?Q?rjjXc/TGcfr9UPJh4KdNYMkkDrjOLbMZLGvGr7SwW+5XBgIIgdqAgHdfnEQy?=
 =?us-ascii?Q?QHHAUiuftWG+Oe8CnMUGoQ0kz1YcCWe+6U3MABJ6IfXJAUhjfk2a8sV/ldYy?=
 =?us-ascii?Q?I5PubvYC0/PkdX3xyOPL64YMtKCwA4jrP1xNLAUHoTOgl9nsJdAMoatuO3DW?=
 =?us-ascii?Q?d8Kl9wMUj+93MZiQoF5rpYfgl+W5NR4NMXr0orL8/JcEzd8sAJ/wanzSureP?=
 =?us-ascii?Q?4MugRpvlUpggnWyaGRPfTNk0O2vHHpFyo4qFrP3Y22k0nRnEuwsVmir6tC9J?=
 =?us-ascii?Q?qsdIn9TvMx6JM48w+divbcokouviw9fuwIzk+j0GeRIhUNYFDD/Xky4Ik7l9?=
 =?us-ascii?Q?DNXPDcHRj3Lz7nvBaYlpUICMkvmX+nhlh41UkTdpgIwgyOMGvICuOACoKrVG?=
 =?us-ascii?Q?aD3sNEMEdYSefVusDATWAJmqqZFLxTph5EUggQQQJyxLgDAMJYF1bW67NPAi?=
 =?us-ascii?Q?jikfXalioGc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U8/FUEZPkrHpJ7EsrYPvGgXRFxnr1Ht4EQ4AWaZQjzsNZ7B4orhbiQWy19R5?=
 =?us-ascii?Q?PXB9WleKJutd1R+TH3UhIB6yLjj9iscc1xdRtpDGhSfytvkMAKXYICFTyI9M?=
 =?us-ascii?Q?rnKpoAXa1YbMyBKVlXbL30bbmqUsDoyPPHN8FSzg3GL4FzW+HYHXa8kw5g8U?=
 =?us-ascii?Q?vh7pWNa/MzfgTN1ZtuABWy5+5n1XvtlHbw7Dn/SHxIVCdOmZf6fLlbtlbtU0?=
 =?us-ascii?Q?4vkVANFnSa5qDQaH0L3ph3UMj17snlEflBpQnlqeDeWGD5DLY+RpMuj6VwE5?=
 =?us-ascii?Q?CKgvpxoppL4q7h3JEJpX6VxKrv9yzaapPrezjjnH+PeYWc9QOHqv3wSatkhp?=
 =?us-ascii?Q?lAd9/Kuae19Ht1S+cTH2mZyE8XThzBM+WiYrHRJvMiK3AAXW3671B/DDB6uT?=
 =?us-ascii?Q?1Hj35YPmOijyv7/WYEaxQaAIAnYHq55NUDar/rWyse0kNiDUaaUXem0jrkdV?=
 =?us-ascii?Q?L7DvB6zEgJ/rGuIurB2WCVzprIchDsrh5BK286m/mkSU20Nn/UTopkUagulq?=
 =?us-ascii?Q?K07OpSAyM5ZZKEY8+6x+xktoBusvXt6dnsCWj9h6lm+8Rt8wQl4zSaixxci2?=
 =?us-ascii?Q?hF64lEc/RfiwhaIpz3WkTV9HMPEXNTb096T1DKNf3T4jdaFBTOCZLitFJYek?=
 =?us-ascii?Q?sgADyTtw1xJhcEonzXwQDDfWbwgb5HBI92GyLBZomiuAJyiGytYJPWDRy87G?=
 =?us-ascii?Q?VvvRRFwdd5Gi9CP/7njMuql6lOhENhziUMdhpCK8JMmWyMgVeFXV1E3WfYw4?=
 =?us-ascii?Q?mmDhZdL5jYWnTTPmYuHARALPPoG7f4l4PWLmt3y0L7gtUQsAgl+df2uUU97C?=
 =?us-ascii?Q?KKOMgRN2y9164plt8sUpvLsubva1QRFfed5CRSsbJrRih6GoX3MVSO4T8Tq8?=
 =?us-ascii?Q?x+NkJtJZ1IGrKN4fkG5inLJJHJ1SnvtelYi2RhKAgyJ66K77KN/jqriVvKuH?=
 =?us-ascii?Q?1DjwKalgoLyS8xUNd5ausEqFGtwGWheJhTR1hla9H6szCWOqie+BLC7Q+bFH?=
 =?us-ascii?Q?DzoVfJAp3e7uagos5ZO4vE6bAs9jTHCvouMYmFaVZYfWHkeSyZvoq7T60Ux2?=
 =?us-ascii?Q?+WaV06LHUVVzL6RbzQZAYi8UhpQLDNYbtn/jXCgqsxBF35swGacPPuEg4aKW?=
 =?us-ascii?Q?Ma5OGfUxE6wVilwAwmKU6COd6ViPhp6Lbe/VGSIIeEPviBG1yje1MQXuFmq+?=
 =?us-ascii?Q?zFRzK+Y43+Ua6pkWva21baDOhxdUv2lW3pqRSDS6YP7MTznAGJ2AJ1F8It86?=
 =?us-ascii?Q?U7T7Y7sQ0A31OwSJ5ldS+1rrvG+XiR+jyrlY/Fo2GXa8zivKtxaW5CXcBrtn?=
 =?us-ascii?Q?TGhpHezdlHRh0O6LZauU8Jqm3FR20nccM7u/zPtopCxvvAaqHb/VJIWbJrWn?=
 =?us-ascii?Q?cS66fbc0emsAau1OdIb1Fxf/ncjtwwelj549VaU7VMgONAzYM5GDQu679LY8?=
 =?us-ascii?Q?ttFEJX90lnQFAowCqS3uQR5c1fdbJT25yAMzsDxIwQzE1cjj5GbVNpKRsQ1T?=
 =?us-ascii?Q?tCojOmlf8/N6rRH+gXMqmtn1ZCWDDE+tDdkDk16DyxiZ/oen1qi+G+Jdzo3d?=
 =?us-ascii?Q?gQ+kCzIboDyEh7FohWpOJabTzQyZEQXIsOVQomAj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0AZRPDf/LucM77zfavoMgxCwiWOF+1orvkPY9qVrh9GkmYnLo0Vo/o0bBMINRQNjmN5uY8nYuJv7sLhlP3az6Y4sqvv73VJwoHlSW8Fb+IRFjuN57zy+u77vsg03vs2KO0pXqSV8+JDEXDyCTmB1dxloFab6riBD9DsvjQCN2TJcfKaoFnQAxq/ojME+KQD1MFTs9O9PBa4WhFsgQDxJNeCY4IHejvFBAA868bSoQ0d1tDKU4WkPt0Yx2uI5v2PbezfZOnu7t2g5sx/KR3QIULu+l2gJ1tUKt/CjE798dLpE2u/DOlnMGSPpZ/qx5JfnGmp9+LoaCGs+e2WJdiEQkgWjkFcwM0uKquu1vyjfEMg4YPnz30e/ZNrKLZaRN7SoKOgZBmjJRZqruKNs2P8vGCJ6WJMg9muVKfLmdPvIsxxrx/czo4R3ByrJV1hST2lvFnT8IHV/tV7IGiEo3vWzp1eFdx4VvmFkXrbQkygvInLdDbaG6xIcHFslodwTg5VvsqmHkyegxxBDS7AZ/V2aU9lTrHvgJk4qLCCkDZE79nozLqHKBumaGIdB9aD58o9LPcjd1Pxd3y/k6FhC2jIbyw6uv06iKra96vkzmc2Iu94=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87ae36ae-96e2-4071-91c8-08ddf05a4938
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 11:07:52.5128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tvfyHs/LRzrMXWi5+u6sV4m11e6mhA4Qex9kyK2EeYLZZF3WrZ20ZEYchHTFAWo48gZR8XZCxlGrnyOe1dw9qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8514
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509100101
X-Proofpoint-ORIG-GUID: 1y94mTnmHDHJpzwMRFMPE_FxWfFtmRd1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfX2ImOp3OSUFQa
 6Eo5YCsRJAG4iJ+hKFQWgMNxMPUUl57qNH8Z21A0G3VQG2oiVeWzdiFgEI6IS+kulnLPkdjJl7h
 I9XhQNMi+4HQjkSyUzfsMzHAJWSIspy6I6oslguStYklsTYWhCs5wYekdT7D8OD7HMGz++xa3i1
 ojh3LtZMicFYb5UeFYB+0mABhnkpZ9wZuVgx652R74Gox+Y1V443A9vQ1xZLkg2VcSLAOfPbzWQ
 grFgBTd/rJF9BILkEb6T3VxEbQnWLUjRXUP+S9qB/T5yeu64FcPSDfiKJD6srj8szB/7bsO2VXc
 9iJzVOQoNgP7lzDvQR3FCiVtJMVEZsSyjXIjysgvgcPLPAbklE8WjkaAsgOab0mOA8ygaVx/Hxv
 BwCdNAmI
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68c15c0b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8
 a=GI2RyibovFxqC9u-leQA:9 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: 1y94mTnmHDHJpzwMRFMPE_FxWfFtmRd1
X-Stat-Signature: 5a9yf6jswg6nkynecdgt93kizb8fb9ee
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D6D9A0012
X-Rspamd-Server: rspam04
X-HE-Tag: 1757502479-343563
X-HE-Meta: U2FsdGVkX1+pfIuHu832oeUimZUY2Tg5si7D6nqVFeUz7MHvZw36kdvgkpQ4IalfyT6PI7kzXu75RbSLemBWBbYzvgMpEtCBxZpAHv58yQ+EUuf/RggyYqjBvxBvSXYdu0knetefpIlmqR/DFuIDLeo0h+ddx2wuY93fU1tju2gzX3uYkAcTtag/3Jb0bFeYo++sWwQpfRmMROLia+YBVloJ9TMOUIHv3buYGeFCKcbGNwnT/FpI3sT9xI6WOVKEftHMT5XjQ35Zg7qEZF/3DVTmN1eXyfIHtVHRyVus8dEFBA6uJLPSBNyk4oG80MSy6+gTS0qDsJl1lhm8sjZX8E6LjzQwj9dFJ02fdGDB7Szdpues04g+MQggS4ofiVSKZA038t243Ji/8sIs4tErjbNIg2Pji9br3YOLF1PBiEZ62lXatdpe2CGBX/rmOW81826THHRPLjgv/9CpUBxJCGd7OClEOsI53JGMV/3XfnGr0L7YrTW7VnUZPU0JxwS7juT5pX9MK/2zQQnp1Ofeifjgh+MKdolF9Wajez9qnfK058d9Qqgzp8/h2QV2Gb58ItP0ngsrSsW2b9b7u+QWu+vWb28+Ckt3Tqi4FXDiRKtk2vAsKXtFtTc6yYBRFjsgyS8zLxfcr54MCXISha46Ib+hbhStq2FQLuAZKuDt+lmp716tEeq+ea/N0O0Elb8fFzIn9tOVcimoaWkKiJCwLj7UwFK0t85lVU0qdisyZTb4CNcz2d2NjLnsIduFDLqQJETDotaUgHdAOpxeM1brxM6l6drgThMsLUHhDmwGKxpXd28bL3iPnmt5+CGJt+o6nNFRN0IQ8Y5hLJAxoBhs5Irw5FJd4IT8nVslGmVEsbKjpqnxn7GJJ3sFiZyuFhpiIdGmHYGzqqt4RH8qty8lecXRjzSwT8oI1lBsHMS+Rb7WA0of5YrgLEfh+3cNl+mEqttk4NgIXGiDAzJ8voZ
 Gukt/PPG
 pCi33ZlEaAiN2KKX5RLe6WrKhJUa2qeVUmGJiIogfTF6IZhSqj41jpXf6MuYRrsraCSQRreFK6UXMosfH/odYt1V6fA1Kc/NvFIrWKZubXuJfhK3iJRi3OHs2PLDXqFaGakKhUpVduNh40i5h7PuQSwZR8qYnwmD3kB7ZAHizQolRKefKW/cFgnL64PwxpeRjpClAxRUdoe6EfYjkwfWoRNvdIo2B+VTpVswdpviGg9qt2AGX8VCaM9phTtPYFNfUZ6KsY+bIO3uE9ifDwhlxZ+BYgGokD3TXkt6wpp89LUlDAnSO7Ti0fA8UGn5x+BaD4dVIXIdZxaIUDKl46tWv3QscV+uWmxd6jB3gb5zY/YIQ360sUpNUSPMmysvSzFDcfYM8BTb6Kswdo5Uxm34fKDOffziyNf7eBXl7TVX2whKNj5vX7GKaFwPdOHLp4vsv5bBptfUxwWKl7r59bS4jJoI4kwX5calEj6E4nHyLKFvF79AznpaOLUIle35NdCxgToLFhF9kAaGnrXgv6dWc3lwyVcHMWKQg89BCqpYFtpu5fCMtzBpchFtRvgtl8Mc7Zl3M6CXyDD8J6A2+wiZmGyLk3mpbhms0zfeMF3CVyeOPgPBxZ0Zg16jjhMfpHeljmmFKMTXMj2WTq67mAqXy0fbso2qS9awFXuqvpUpQeeKAQu0HqtFpBBKtpB+6+zk/9h3JMEK4OxlbgqrTT50eurmiCumi2iz1iLpkxhW5MYNv8TQ+IxBXep7DvFk9DubMeqRRkHQXWPD5IV/CnFRsahOAJtTPJRIiWSMk9wvKhcX/vbaKh3adQsizOsLpdoVXgmMQI8vkpIm+x7zPLK1LjoEczw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 04:47:08PM +0100, Matthew Wilcox (Oracle) wrote:
> We already know that slab is a valid slab as that's checked by the
> caller.  In the future, we won't be able to get to a slab pointer
> from a non-slab page.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

If the address passed to kmem_cache_free() wasn't a valid slab
address, virt_to_slab() would have returned NULL and it would have
crashed due to NULL-pointer-deref before reaching
free_consistency_checks().

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/slub.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 6b0ce2677d32..7b9fb7a88fdd 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1734,10 +1734,7 @@ static inline int free_consistency_checks(struct kmem_cache *s,
>  		return 0;
>  
>  	if (unlikely(s != slab->slab_cache)) {
> -		if (!folio_test_slab(slab_folio(slab))) {
> -			slab_err(s, slab, "Attempt to free object(0x%p) outside of slab",
> -				 object);
> -		} else if (!slab->slab_cache) {
> +		if (!slab->slab_cache) {
>  			slab_err(NULL, slab, "No slab cache for object 0x%p",
>  				 object);
>  		} else {
> -- 
> 2.47.2

-- 
Cheers,
Harry / Hyeonggon

