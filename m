Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CCDFCCF9F5
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 11:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049FF8E0142; Thu, 30 Oct 2025 07:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3B68E007D; Thu, 30 Oct 2025 07:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF2978E0142; Thu, 30 Oct 2025 07:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA7528E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 07:00:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 758B7140ADA
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:00:25 +0000 (UTC)
X-FDA: 84054486810.27.41DB11D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id EDA3F18000E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:00:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Hy0PyhLN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dfUBrgRG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761822022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCdNDUWvRAHU5wKUrH0nyJJXkpLMAQ98DVjqYliI/Ww=;
	b=02vt85oVdtDjXpEZC6C1ion/ArRhaVODYKhxuukVjN3VrxQiz14F6JbponOH7SWHZn22aY
	rW3d5zKXZEpjP5bkw9fumMuuQRtds+VREABF1XKzWN1T2FWGRvAB3S/x8uWvl9mbMfaXGV
	MIJ2HGgUVnUnRBuByXJt3t1wjR45dPY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761822022; a=rsa-sha256;
	cv=pass;
	b=e+PAItE56N0MKi1cL9KwuYp8cSjqEnMbql3ZgtTUU5NujdwLVnZvq7MDVtmUCWhghPxDAQ
	m2c5Cyt4E9IxBJWURYyVtcEYu+SkFnocsGWQhmmKFtZNMjHE3CVJaW4ihfCqBsZtQfqdeM
	tJF0d/PPyendcI3YNoH2emehR0iDXyM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Hy0PyhLN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dfUBrgRG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59U9ukTY012799;
	Thu, 30 Oct 2025 11:00:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kCdNDUWvRAHU5wKUrH
	0nyJJXkpLMAQ98DVjqYliI/Ww=; b=Hy0PyhLN6wJm3+jpQRTZCSYi1G/4ZLzoas
	ZBZdKDgCVe6YT98u+EiOQFrp8DbF5jx2dBR8dICIu3CqB1VkgFhT5QoDjjHV7d0i
	54OP+E97Beje06p9IIiUV/EoabNnUJ2HfGY10mffxJIsVduW/GdujHRbE7EEa1cz
	YN+qmea7xJY7o/wmrwD1l9LlovmeLrnkWL3Cv7phShvkXFtc6T1OWlOO8Rc/6j8b
	V1sjI64wQAzekTG66yBvsg2aFsbJzKnDWQ8jyzMHpwU72MvpueIK+Yp10M0SFg/W
	jnfVw/Wd1pEqkJQ2iSA9PchzICVo5iwt0HjR/GF+ppkozmsFV50g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a430x8dx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 11:00:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59U8oF9B011288;
	Thu, 30 Oct 2025 11:00:16 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012027.outbound.protection.outlook.com [52.101.48.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33vyfqc0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 11:00:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hT8cXB/GrenoSDo3i188n4d3BiLeZsRyAmGSD2JnP4k31WJ/pyRGcm/csoDl2X1r4ZOfIel4QPBDGLXzGhHk+ZOEP2oPYdGOn5DFfYTqyvhx2fVck6rD2J4KZ64LfbJmaC3uMWLC9M+ZMBJtvjuQx2EDrS0TvcmsigmhAFNn+wa7soZfMnTeJzVOZ/BLYU6gzSnNTc/MjupO1hiYvC/rjon4DaMFb5h28hdZFF6V0i1gobMd8bjiHgJ4VnBmXdz6izPdD6Vix1lVI31s9WGjmwmFBd6M4k8htsdq1kA5ptBrGDcs42ltcCCdQNq44xCGXb1KE07kSPhZsYcJn1gpoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCdNDUWvRAHU5wKUrH0nyJJXkpLMAQ98DVjqYliI/Ww=;
 b=AIvQqxNCN9e3YbO7ccFlcwdxmbfX0okdnDbEUAkrt3ol3fBo5er6MPxaIsmRq4WU6dNroFSW3eYLQaNs9DC54kCmQ1kJUn4DMVXZePCiI0RU1ltG2f+oBrINzKu/jTQWCN8aegHbn6IGi38GRXqhtZ0Xs3/6cPZLtBR79a5+kA8IdNRtOau4QS6vqzZk6BX3NImF/Zg5KwOW3WobPSa8Lqe94eZ6Dzl6LboaMPvDbtlpD7M+mW1SOmSsIQxXiA10ELFYfjvFcHtcXXP3jedab563ize9KCNnIy9w6yWtQamKgZpbHvet7a+drXVbM2kN5W55oBIpRYiaCwKkFnKumw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kCdNDUWvRAHU5wKUrH0nyJJXkpLMAQ98DVjqYliI/Ww=;
 b=dfUBrgRG/AY5OCfjjfx4cqXhLzinLq4YphHS4xnyRCsiKfC/EaTRB3V/nR8OpSvqpIVS+ztH8hNENQB32TxmRLCds+AcyCWkC0P2xXtFr5nY7yw4FmwbrD3TfB7tPmnrkgVAFj6CXClAlTYJAh7hShl0i8B6Tgo/5N83S274+wc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB7508.namprd10.prod.outlook.com (2603:10b6:8:17d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Thu, 30 Oct
 2025 11:00:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Thu, 30 Oct 2025
 11:00:13 +0000
Date: Thu, 30 Oct 2025 11:00:11 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Israel Batista <linux@israelbatista.dev.br>
Cc: david@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
        osandov@osandov.com, linux-debuggers@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm: change type of state in struct memory_block
Message-ID: <320170b8-fc25-4253-9a97-e185cb985486@lucifer.local>
References: <20251029195617.2210700-1-linux@israelbatista.dev.br>
 <20251029195617.2210700-3-linux@israelbatista.dev.br>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029195617.2210700-3-linux@israelbatista.dev.br>
X-ClientProxiedBy: LO2P265CA0164.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::32) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB7508:EE_
X-MS-Office365-Filtering-Correlation-Id: c2c03741-5a33-494d-dc1b-08de17a38052
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HBq4ryQpTD0+DCQTfTns6pt8nYwbsWJbyKBxTWb0iO6HKwtzODD3JT4VidP2?=
 =?us-ascii?Q?Ke0o7LMmHD/LEulAOcFMSZBNGYpcnGGxW0zYlDZ9ych/a9GY9GamK1zZPDBv?=
 =?us-ascii?Q?yAJ8OcUUfuKjTRU73X+TEFrTajRHaa3DMgZ9WHU37+cOt2Y03FhFhG2uQQ4f?=
 =?us-ascii?Q?wQOQKKiNcWnj7Eu3pw8usI9goa49DeOUNzCAvOpbotAwExtluFXd3eYWniSo?=
 =?us-ascii?Q?0symXqdU2Mx/qk7NHNYzhkeIkhIq2AJEMkr+AFR8AWw10dX0rTRqykpIW4+d?=
 =?us-ascii?Q?SdH0+RKvp/JFrH2k4uMt3GwpoZsdbiXez2ZcpkYA3hOcJ/hszN+BG9uOJDYH?=
 =?us-ascii?Q?BNC3DR+jDArp8WDNMAeLwWMEyKovq7riYKhhFtZq2qExQCeR0D/QFf723l7/?=
 =?us-ascii?Q?K3r2a2yFWfBR9Xqd9WaHm4pGYH4Bxaj950DelJ6h9HI73uqw9Y9blvtXUF/h?=
 =?us-ascii?Q?nRd7OnLwRTYRMiS9ResXXa9EqMf/wpVlAnOW1UIBGpRDzHQSkcvnrrhRGQf4?=
 =?us-ascii?Q?OkD0YeJokvMU/+SnZNXlfgxHHV3aU/YePWtuU0AIy1cEfxUZZmvsVkXdz7Td?=
 =?us-ascii?Q?LFFLAvXFtKe2/7Fr+ylMeE79sB0BQEK8Oy/nKlFRiKdXFzxiB48nfbDS4D55?=
 =?us-ascii?Q?dpB1PTjPb3dqpAyiISqJSRcPlf4V9MllUB1AY7pz2DhStlwkiTAyxtks9bwZ?=
 =?us-ascii?Q?wdgCImr6XUihhth3yUy8fAkaUGk1SbfdlWl66TzMDXrB5iIUsbZeQ4hBMBed?=
 =?us-ascii?Q?VfSb2PyYdIbJVR1y+UoaxWNCTuwIgi0rpAma6k4VKJNY1uqvYql0uvffXygB?=
 =?us-ascii?Q?Jjmy2VeoHIRr68DOwdmhjAzZmPCfsWuv25Lpa9uavVn36lutaHAYC7krRcGD?=
 =?us-ascii?Q?xylRW6SLHsiPVtWtrtvmijTGJy7r3vUzB5u83YNkpMPgZI2gOwcYE8PmXlt1?=
 =?us-ascii?Q?4HiCTpCQ0QM9LjXyqy+MahsWOZ8W9wXSoolx4uwqU7wsdF6kJX3yVoTKf3b7?=
 =?us-ascii?Q?EfG7qaLH7Sllr4v21tM7BmRp0nlZjsdoSElDep+SivUVtw/hwWt8GRmNERvR?=
 =?us-ascii?Q?MYvVcTdWLu5WZvdL0ytB13SBNbtIn/R+x6BSD43eHJH/FOz4m9VZj+f+tgdj?=
 =?us-ascii?Q?3tbtKu85KYN+fmqg8Dvd/ddJoeg2pw+lhoeMFaAPTVvhKA6/sj6M3Nedechg?=
 =?us-ascii?Q?yNGidQ5zeCEu83A6SnK43jpnR0d0NaFpWR8YflSBfR+765DNbX0xo/6H0OE7?=
 =?us-ascii?Q?AJSI2qCJM66dxuwtXkzUru8hptLDUCzlNl/mOOvmR/SPQS/ccSlb8losgx1w?=
 =?us-ascii?Q?5lbiLTWAqjk/eGc49EwNc9dJGodjcK2V4773CKCOkEJq3kFoh8KJRw58A4Og?=
 =?us-ascii?Q?13aTql6bG4h3vZAv/AWy2NQVwog1qJ0gDiMXWYVC03f+YPDkaeVHWPlddESx?=
 =?us-ascii?Q?gNu9aK7TNtLNJH1bHImTHqeG2bvSUywC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BO9VPrzkuLRgW6YVe1+F5/THJoqtzFnEX2kAt8rtBJjG2Jj5xd1qcbHFsmRK?=
 =?us-ascii?Q?p0MVUoi81MQvmyBOyLUQi8S8F4NUX3aZqzDi82apBCfuSeHOEvwlB9raZTNO?=
 =?us-ascii?Q?AN+E2lgKKHSIyio3T5JB2Pm7Kpg6IhYB/dHjFfLsCvd68N/dHJ5URKHq5DRx?=
 =?us-ascii?Q?zyfdOHbefNnMJKGFX22+Yc/2ZDYyHFYGhIDAqqSudwVtmee3IHsrtghRmf1F?=
 =?us-ascii?Q?9gTFlmEz+F1qIk1zluAPmkSTg/ZmKl0n3/QaOf/oDJJBx4tElQqUxRAz55wi?=
 =?us-ascii?Q?4B6gtW4VCdv6CxMtnARIboSXlJPJtieJ4HMI1yobWKnjysPop2wKuP/qld9U?=
 =?us-ascii?Q?JPNEsdEZZv/2RHvOwksitgwE5LWBwQ/nLB4NjH3DiCOKwCfaXKN/2DcN74K/?=
 =?us-ascii?Q?QjoVnvkkEjIwkWlYr8QJGL/eJJ8AXGaL8nqtxj6Nz71Ie2gAr8Jmrn34D3lQ?=
 =?us-ascii?Q?6vlLmgwHlvbTrgeJn+D2BplwJe1FCxpWHfoFtr3m2FGTZ5fVVX9DcGYrl6xF?=
 =?us-ascii?Q?D56bqC5gWbXTDxKL7Nm2H4mmc0lSxefpoCkdwr1X0HKwFO4K8VNMV5grT2Aa?=
 =?us-ascii?Q?w80Hg3bZ5ZUAK/WECrqMV8TE0qRz5gm+c/SBQIjIRbddhXkgugqAGAd5Thho?=
 =?us-ascii?Q?CkGV+poAYmzyMtkBjG+2NMa8HCg39UcPu64fv4n74Py/lhvzv+joGUABewyn?=
 =?us-ascii?Q?DBn5WTiVSzIqgX4+o0evts7Wpxb/EluzJgnIEIeFArIKMsTnlviUI/zFrIob?=
 =?us-ascii?Q?Fc398mThH5vDCAZKHzwbpMpru+V/o2gAL/eg7t/K3vT4beSeMNZdCcwQ3Qlw?=
 =?us-ascii?Q?zbWw6s4GD/XcbpYjIXE8sa7Yw2VqSN2lBkoovwCKAGFfj1/cfcEokUACmXwx?=
 =?us-ascii?Q?+xOCg0ZhMwEBpgKIU3a1l55kawKnO9uSRvubCMJz/c7GMrkeTcCDDA9MVay/?=
 =?us-ascii?Q?Ino0dCyEAtkG5tv9tFU+ratIOG2g+unFVVQKhHldsUQd0lsrHxo/VMhdpi7/?=
 =?us-ascii?Q?oi4UiTTCcLhoA+PCCJUQgMm6RM4qD+4yi1HFjngnPS1nUpR1vmSQWo39m2Tw?=
 =?us-ascii?Q?Da2XM7g0Wj3onS0FF6SHjPjRLtr+iRrdS/Ofevb0vWDthMkFe8Db7Rn8GlQb?=
 =?us-ascii?Q?dLshYVQDqZVL5kKQW0y6ZrIjq/l1EJerf39os1QlrMxYp6/OZIDKcCqOPOes?=
 =?us-ascii?Q?u9wgdnf4LuZ3PDP3j9F7MiaudVDI/A5CcuFJ4JK2cSznXOhbwFE1qntMHxen?=
 =?us-ascii?Q?mtxQZHZBPWRG046WiAJ5LoYq68NQpv6d6zYLH7V3YgSb6RJIFnR8D9cmWpTm?=
 =?us-ascii?Q?CPWEPuzFHUo7VsdsrFGy8AKM/j7KgI924RF98VWvTdJluB18d49Pv8+J8yZl?=
 =?us-ascii?Q?54KxYyVAqSeoUOmrYCbKbPZCo1KH9bz1n91bL8q2mQzVudoV5Ia/Uf3xckwa?=
 =?us-ascii?Q?XRgM0UTIVsRaxi56m8e62RVV86/lKI6Q820IQomGxITJQ69bXdJMY36IJzG1?=
 =?us-ascii?Q?oO3/sZyEOTwFRcr+D7bdjhlycuo9utlKoeNe+a7w/GJyxmp15f556YQbYT5h?=
 =?us-ascii?Q?G/6lOIFIXJhQCMGa/Zugba1kx1Ph6/1Ds1wX3iJkA4vyeYc9H0i4DMf1oV+f?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	U+SJwYhtNVC8OVNWYdFvkbYhFYkmonGj3m04TVquWXDqYwOZUz/zbO4KOp2XkIWBBTZJ/XGCilyGohOfjxS1mPi4T9nuiisewtxeD8xzO4KXjeZ4/0hbbjpI0V2ZuK56j5VnQ1XNVMtgFx0LopKwvJVupAaM/KyI+yVCCiFlka+imKIYAP83fQKN8uyPQE9r3y+n47MVbAEV7CgSdnElODd4VBrFWk5uRqXzEdxa19snvDA6kmQZ73mkMu3BpVw2SxVPv7q0yagL4PiEuf3Yz0GcWbo6faQRXk2wOlMwu9Tp4NHUnEVxEbfOqGRcQTYyx0WL11k5Ot9z/7fTCgV1CzK5r+lRNDdY9IvQSOrhtoDG4Rc9mdnZpvWxmxTczB4J20/d7/ITDCD0mmjJBk8VabGizftuZwP7Ja57Tji9zKZHkIJMeLD1+gGAF/pYgUGPcA3dOe4SiB0HSXJTq0Gm6z+nA0RJGSp06mTJVDGuwBeh0WlAVz3hpapF0GLdAiDrwPQRLzT+9KFJzNZn7JLxU8mse39GZNEut33+nCmD5j0mI4CArn7kuxdoibxbwF4yIOYROPpGgTGpZtOR5gDj+yGyCEJ6simO6diaASr97OQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c03741-5a33-494d-dc1b-08de17a38052
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 11:00:13.3768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JOOlycZL6ecWL2Hp2lVidf7IR798nHPvuwC8bN+dbPw+wC8Kb3HNxF1/QRQPhN+OJSKuP9c6Y9r5a6mpn6VEnVcfjpi9ATz91B81ZPeBWj0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7508
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_03,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510300089
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMwMDA1MyBTYWx0ZWRfX5Gf2wZIMtDAz
 Qlkqbx1igGqMsbyc0eejPdRRKzqrLWadfLSKdJoDbyAOtgqHk2VqLrJ25nZ56UJCmwg/GnMKrz6
 Y4HYprN4J/NTTZgtFetdY5wIxpS6ZtDyzbRxfrT6KTCiS60CdMOASZ/HUNJsrvYCruWNilO/L+n
 owqJ35748WYiBwyjORjkKGfg23mc0ZBTJL+wAdRPN+JIqC/T3PVJZnwNLOCb+tPIuN/pQMfRlXI
 R4Hl68Wh9zf+TZEm6dgEdZaFhh9EnmknpD30iWfNqSQJjFe3F9EbHrn9O74DCtV2lACUGk80QxJ
 4D3WQnSQ+nTgqPE4C0N4lHoLkKbyA9h6vK43Xuz1ygNbTwbRBdEGITSYylCfZ11ZuwIcjSsip7X
 cs/2F5fdhUzONxvkloGtmh7F6HCKIQ==
X-Authority-Analysis: v=2.4 cv=F7Nat6hN c=1 sm=1 tr=0 ts=69034541 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=i1VDJLL8ALoyPO76PwUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Zdesorwvx71JbfjnIqAYFKTj4xpd10zY
X-Proofpoint-ORIG-GUID: Zdesorwvx71JbfjnIqAYFKTj4xpd10zY
X-Rspamd-Server: rspam05
X-Stat-Signature: i3ken5ii7niytprbmty5cyoz3mts3i1x
X-Rspam-User: 
X-Rspamd-Queue-Id: EDA3F18000E
X-HE-Tag: 1761822021-341028
X-HE-Meta: U2FsdGVkX1/BVaEmTu6mDV6oG4VoK6zGRQG9rUkClbNFN0ijzGkx62RKyrqVhZUWYit2z90HkBqZBlF6sxXLyXT0S+uJxrc9SXwvP7xDgdgDKyEoy5y+303xL0j7HXxA+ZgsYCe8P3X5vJGcu0UYRm2uu8fdkACZaT4NtFkpV5sUHbWb8219fIRL1Cjt09OeM78P0BhLvhL6eWdkhZ5WQomznCDN6rP8qZUM1Z8PjiRBQde3cwv1nUoXpmB86R/mB5L97L/tEiS/PC8zpSSnGgPlip4RWFQRk0uixxQ2dPJs5wErasVBexKH0p86+mWNh8AK5iuBtXeGqVzZlUWnBXg3mM2gEbsanXIH8flrVX5I3QoU4TwRtnUcHdOxLMdM2gtSo2ZDuMKQFYQt4FDSVyDjNFhzDE+vXU1s07yAM9ewp64LfcxqIJThSh1TKyTk4j9aKwPih4oRLVmblp2e+gtRvz8E6OSNbF1ZmU2DbInYOFv+WHb+ku0qfmNiOLyPnB75FqLwenNx8suzFlfzNwZhCN0ugbQ5TG7F+f3q5rNtvI/d9lDNDH9cyRiOXdDgE8uz1DSpAq76tIS1PGCUnUEpeJ4npt6j0K9ewZsg7+/hBeBwYrv4h8KqUT9jmnFa+MQgFQliafcqzkRsPXqmLtTj8oCcPzOqN5SHjE5iEX62c5qZK9po4rpsGCi51ttfAMBuQz8MMRWsenSJCczN97R+y22mNHI8qJxs86xicwskzPSEhxzf2zI6JlGUI3aGKrMmUvKwZ0uE4V2zJLjETHGa3+yxwkphqemFza1sx4A4EtHoqX1EThCwy5O8+RSt8ksb9EMlLnw29wI/rd11OYsmpJ4lLnqIL8BJEm0y+vUC85Yt6fjBAWXrueuRyAZz78mJxVJJz7pm6hveTPMLOJ4G5qF291YPBR0VmTWIzd7GIR7I0lpZMRWHcb4zvNq4Nm7isHLyFm7uaWNgwL4
 Bsl5jTB9
 +LP9bq16+FW+ME9Va2JDJWvyCu6PKaqM5CRdXKrSLofLcPjJVFGzN2yfJzfKcerwC0Y9aRZu60BXBTW2qkM+hJcHLeXaLkzw/WoCxc1KO/uqsTOGzRVdcNlciyN+LpSIXc60WRsbnOGeBtY8OMPUGYTraR2Y1uVVYwTJQtvJ6uXjWDcKcwqH34lYKKcop1odnZSrYyF7n8lbSkmLrny7KGufhfvfPE+1UHYfYoF9pEH7rYcxYKWF8EkIPu2AB0plDOqaXOd9kE2Fsh3fJHWXgreL9iAegBXcXJEot0rRzEvLC+0YOC7QPeYHsUM5YsHgwSDi4yrX8VZa8KHCEDHOv7q4mKQcAgyS2vTIP6kn6k1kxL3E888iP9Tw1wC8u7eonsTcNpgFtk9Hikwc+4vFiTg2gynluf/ED9gwCBFbBTvH35aYYIC7O2lESpvfulOVGcL3l524wBGziDMzAS1s8Erf0YHIpZl/Q9I//cuc+De1llU8uWAILW8jRmJD8xImjnlRLsNlCd/XpEvikFlzgB62wg5NbTV0gdyKHuGiWS1kgyVrySG6j3XBsziI/42YIO0pXvEwoM7ZE16t46Kxt4wuAE8lh27PuvMIj0SSGMqQ3JlcnV0RdDQBUc/qnX4wYXfuQXwNrKBluEFZ6oUlrB6NxeYbcQVJC3KJUIEQxch779JPV3U8zkw+13g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 07:56:30PM +0000, Israel Batista wrote:
> The state of a memory block should be restricted to values specified
> in the documentation of the memory hotplug API. However, since the
> state field in the memory_block struct was defined as an unsigned
> long, this restriction was not enforced at compile time.
>
> With the introduction of the enum memory_block_state, it is now possible
> to incorporate the desired semantics in the field declaration and
> enforce these restrictions at compile time.

Well I'm not sure how much is enforced at compile time, the compiler treats
the enum very loosely as if it were simply an int. BUt it does make it
clear what you expect this field to contain!

>
> Signed-off-by: Israel Batista <linux@israelbatista.dev.br>

This LGTM as a reasonable change though, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

On basis that you fixup the formatting issue raised by Randy.

> ---
>  drivers/base/memory.c  | 2 +-
>  include/linux/memory.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 6d84a02cfa5d..3d17dd774947 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -198,7 +198,7 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
>  		break;
>  	default:
>  		WARN_ON(1);
> -		return sysfs_emit(buf, "ERROR-UNKNOWN-%ld\n", mem->state);
> +		return sysfs_emit(buf, "ERROR-UNKNOWN-%d\n", mem->state);
>  	}
>
>  	return sysfs_emit(buf, "%s\n", output);
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index f4e358477c6a..36d733283329 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -78,7 +78,7 @@ enum memory_block_state {
>
>  struct memory_block {
>  	unsigned long start_section_nr;
> -	unsigned long state;		/* serialized by the dev->lock */
> +	enum memory_block_state state; /* serialized by the dev->lock */

I doubt it will be an isuse, but this obviously changes the layout of the
struct.

However since this will be an int and you have a bunch of ints here it should
all pad reasonably.

>  	int online_type;		/* for passing data to online routine */
>  	int nid;			/* NID for this memory block */
>  	/*
> --
> 2.51.0
>

