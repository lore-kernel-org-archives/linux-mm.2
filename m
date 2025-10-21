Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC8CECCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:38:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F668E002B; Tue, 21 Oct 2025 07:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3762D8E001A; Tue, 21 Oct 2025 07:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23DFA8E002B; Tue, 21 Oct 2025 07:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 137FD8E001A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:38:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B688459033
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:38:41 +0000 (UTC)
X-FDA: 84021924042.23.4871DE9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4721CC0007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:38:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PIuupakf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bxx4IFDX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761046718; a=rsa-sha256;
	cv=pass;
	b=dEvQmu2FyLTbPPCVQl3d2e1RZ8rHcg0dzel6X3JP/vgHQSnHp6fTmHCN53d6VE+LUz10xZ
	SoHEXCB7c784eKqrQZTsnSH49V2TsaNbQGggeQzBF7zFGIRk4nUK73Y869CJtrkz6pn3T0
	rBSmKPddHV9pqdQJhiNW+jfHStPrXUE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PIuupakf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bxx4IFDX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761046718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2XW8M4VKdLdvZJiKX/PmeOXa5wIxmoXpOvmy/j9YWo=;
	b=g4gtohV8u8yRplF3h3siEPz2fbbzSjzTpWVT4WIWvB+fAp+xLfYwPXoUaEM/0ba4CzpRdp
	/rSWGAI1NIjX1DVKLEBwIYsXE7HZ0GfWz2SRleo4B7FkOxQVfCZalRRJMLoRwuBE8Z1MA2
	BnOxYzSQUCNzbCAXoRkdH6EcGiO1GXE=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L7uUsB029425;
	Tue, 21 Oct 2025 11:38:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=D2XW8M4VKdLdvZJiKX
	/PmeOXa5wIxmoXpOvmy/j9YWo=; b=PIuupakfY0qF6w77Vq/cWTfHaa+d0Vz81f
	zwAR2RrGbUQVEp4J3ECJg4EbpL2d+q6LgQ6yjk2fKeh0TgB6glIJN6Wgkg/8UuRP
	uIqdQ5mBw1WTXDqpttJGwxJzp/83d11GMlU1LHjCTtBldhrlPwUFRXESMxs8BTxR
	1EsRFHyJWVCgFw5lEj/ekAc8B0wBCSREyRO8a/WIJae6iTjDZEeGJviKuZeeA4NA
	yGQtjhHMRb5862wnxsGD2Za2NE8tL3Va6d+R60wx/GxUPGiSeJWUZHmtRMw5h7ip
	c88EhBbMq7zD8u3Mj26SRn76ux8hU7jSOFsLnBrYBxl0LkUWmtlA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2wavvy1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 11:38:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LBES5b035132;
	Tue, 21 Oct 2025 11:38:35 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bcsf4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 11:38:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zC4R0TkD1GdcCF19Rrtt6dtenUmUTbbQHfDFW1GAMu1ouS5GQELbfkdhBbJhV7/XKr4ZnqhDolZ1STLVsS2f2wDguPPms5jNTO741MCpxgV/BvNuVVHcoR7V52HqZLFHUE36SR29XZPN6fc4F3dgsKCVIQznhfN1jlv3Tnp+F175CZ2TONRLmE9pAuzNj1Rn116eTVYPoANI7tiROn94Jw98iL9PkSp8atjYsrCl0kKOVxUKoJRnDcqq3n40KjdJUclRn3+Vv+/DldQTNtKfkgThi6Vom4ir76hMQU7uIRzKzsOIa0UE409kuwUGCBq5vAabUJMWJ2gKukG6E/KiVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2XW8M4VKdLdvZJiKX/PmeOXa5wIxmoXpOvmy/j9YWo=;
 b=tkJ85/bXdSd1srxYORQBub3UWQeWyRsbjtgMTLCfvgDAspW/2i8KSK2F63rYGfbiXcDlvE+DDBSBP82Tdu/RtIPj76KksZBStSJCq+HJLEQXWJBl8qNMBikNTZ8LtZ/yNo0kFiltpOTe2ysWWxjfJnfdFgOlhw07nctsNOTpBTJ6+igZgHR4cTVMmyUaXDt8XSNzN4GqvUIf9Syyh9MH5oL6FcvrL18o8Sv+V04GZ2jD4cTGFZqoysnd1ju4BG+5xPM3EgSsEEVfHPu5CnLi0HTRV1xRa+OJ3s9UXN62whXZ5TYIar0CmyDzn+VB0s89P5pvyZpxdP7D8VkZqD9VAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2XW8M4VKdLdvZJiKX/PmeOXa5wIxmoXpOvmy/j9YWo=;
 b=bxx4IFDXEi2vPO32TAYFeRBLK2BX5VyBOog5iTxYO2ya7Hu8sTj9H6cl4tTJuCyvE6+gbvPpb2R4Ru3ejwhn7YdwRhWtdoSDMqEnH9rtiabKCcsnbLHId/8g3E/b+m0ZqB1jVb1NesavqlHtmB1NCM5MZsnN2prj+Upft3vd3Kg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN6PR10MB7441.namprd10.prod.outlook.com (2603:10b6:208:474::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 11:38:32 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 11:38:32 +0000
Date: Tue, 21 Oct 2025 20:38:24 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: William Kucharski <william.kucharski@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Paul Mundt <lethal@linux-sh.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Remove reference to destructor in comment in
 calculate_sizes()
Message-ID: <aPdwcpe91TkdPZ2V@hyeyoo>
References: <20251021110004.2209008-1-william.kucharski@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021110004.2209008-1-william.kucharski@oracle.com>
X-ClientProxiedBy: SL2P216CA0187.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1a::21) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN6PR10MB7441:EE_
X-MS-Office365-Filtering-Correlation-Id: 94d960c8-b326-47f4-2405-08de10965c8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dQpTDCZlNOrY4ZEfpwZyXYO2RmQ960AMyCxGI807oEzIHtf5fympMMaOjs8K?=
 =?us-ascii?Q?0Y0Rxrw2EtKq/XRBM+GmFY6P6XjCzPkjM/jJpp4tKPSl4BODYiW5EIgHq0wA?=
 =?us-ascii?Q?37e79o+YkldDnqjmXOhzgW30gW9djXDfcf2f3ooS92Jc96/4PmbvOtJcMxQk?=
 =?us-ascii?Q?6LKt8ir+mIhIj9AMMo2Lanwg+CpoSswLA0EG9kyQ09GgkhwJTnKpkAzfnHk1?=
 =?us-ascii?Q?GmSqQkYhhUKk+VJE+r+FdDGds10HeWU0Iy+gEozGtgqooVebpnxq197UdAqS?=
 =?us-ascii?Q?XrOpQ/IGzlRiyUVJ/lE8ZWC4oqaliRKD9YmMaiWYGO72AHBwTv8jW++MzCnM?=
 =?us-ascii?Q?WjNv0a+HAm3swIrNlYN3DWuxkNjLx5pTlCvdyUHInlcIqLfGMoDdnVDr8wNj?=
 =?us-ascii?Q?XXAuoTItT8ZJg7TNjz4VtcmooCJUmiw1YwyjuRWxoKSIDjJKHhWqPNZMzuE6?=
 =?us-ascii?Q?HFLg+tesRT7c6loB0iUTpmiw9hlRpUcQWkFPJx6gM6mu7lDc39rPAH0lPtHD?=
 =?us-ascii?Q?gSMd+H//puPCUzSg9NrOS/fOzzWFONkz8CFvP424nBb0xgJa4c1Lx/9F1Cox?=
 =?us-ascii?Q?FNMjcIr8yVGKgWmpz9vWS6M9MVYZnbOWHSdvNobUaH0qQLxl2fAsqpLU29k0?=
 =?us-ascii?Q?arSkXg8kZqZgT1bBlnLNLOnjPUK9N3nL9tNLWb+qbzj8PLG4erH1LBbzeiDE?=
 =?us-ascii?Q?aXa7offlvNqhZ9B8BcbMJO6Cqvxmbx1c9tV8IQ990rHPL6AxxAK9tyyoSbao?=
 =?us-ascii?Q?b0vxlDwSGW4730j0quJVk0J2yjKaH61BRDRR6NX6+ziK8zdZqbhj2fppIHFo?=
 =?us-ascii?Q?dEjMVQdYq9Ismw3vpr6ryknA8XdS64y6kieAShuk+hLGaWXDp6ad9qwyTGTa?=
 =?us-ascii?Q?npPd60Zq/T8r1MfMd7JGPcgwh50qMiZ9ogHKDat3GRZjc6GxYd5cUF8s3Ncp?=
 =?us-ascii?Q?0D/8cj7mWiaE3nW0BqNSTEHDygFcN63Yj6NUBMAue+nJ9BHXrQHFhGGHU7n0?=
 =?us-ascii?Q?y6C/VBN2Nb5Ef0R6ReRsEqmhrUfrt6XSvqbOnnCUt+dcgYgTE6RhsRxr8spK?=
 =?us-ascii?Q?nQ5OG4Pnmgurp+pLJP6hLoHzc/4a+zrwVltuF/D2NB5/n03Az93jhtwY1RIa?=
 =?us-ascii?Q?Lc6idHoEMW33nDDYvoWz/stXU+m8Q75WCMCrr6NppkcFChZkpKAqVMSSnXED?=
 =?us-ascii?Q?NFCuYHiC3s58uvYDYMmQk4vUnH7ePxTsNYvrd/pxzLrYvCQAhcZ5wROhOztZ?=
 =?us-ascii?Q?TyM5f9zYKlzR3DynXtzQZdc5MCm7glraM1bdwnC8/Gvv5Detzj6AUhu+pc06?=
 =?us-ascii?Q?jYwtCYhIaBydfGhLrv89A1uRCpDY4GzkOUzBuLDc9Ij2pV2AmhvhLs/+zAoR?=
 =?us-ascii?Q?lUDtpsydRosK1sLAEzHJyz/X40zS972SUEmM7mjsRv6d3gFkskYfF4FI0K3T?=
 =?us-ascii?Q?P9w3dl27U3nExQy4FiIUoEC3BkEWnNwayMvlHMTDoxCPa5CYFyGaog=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?taWR7xRI7mzTGPd337lxj8B6wlv0m62UTk8vBsoK2o9hp/y3if3Ymp0qsh9a?=
 =?us-ascii?Q?9ol0vSki0oHBm4M09rrPqknHBnnPjYPFw2LNiYwAXVefzO44BVG/5a/azZuo?=
 =?us-ascii?Q?bX03ZtHt8kXu1uiwfADxxh2w/jqJrAuN7fot6svgju6Zp9DN1XBPOPUD1fIs?=
 =?us-ascii?Q?6tyGZocHNhrHKs4Mhr2u1+YaE8aaibdJThnc/vWBBM9xFEXN1a3ZGXAbZNpv?=
 =?us-ascii?Q?w/Nj5u1lUl6scNf9n+dUZczNsQA7PLWGtJlbvAKn70jGffu/xFE4DJ89MhdF?=
 =?us-ascii?Q?K4jSTrglSBreTO3MZPaSMeYdWQ0V4fiscv0W+NaEhUFOGJmrNBrPl8Nt+ESg?=
 =?us-ascii?Q?+xPdARU8dytyZx0MSwmAII8kH/JhbxmUDwCqiSa3lT5NMASQP9jjHnE7rGs1?=
 =?us-ascii?Q?knn4ojgbfNdBxS2dBOcekHB0FZi8Pv/XX1FSN6Zj5ZKESNtJ7AA1kutDul4K?=
 =?us-ascii?Q?W04k9DwSMFZcu8QNFjw+E0lIVgPon2VJIel5WjfyyWlD533lysTrCTXXCiFc?=
 =?us-ascii?Q?a43uyLPeg/56tvJ7icvKjiOpb6W1vsU8ZNgeM96vk+A7czmANTkSAAILJffo?=
 =?us-ascii?Q?8tpAglQwx6P7AJ/sM2JByUaFPsrn00BdATx0aWl1gsnY9HPDfY/EOMZJegw+?=
 =?us-ascii?Q?ycSLHZEMo7L/7VsDm2KV5tlECOT9bxSv43pAyMMl3BPN1aghjCZVdVJOMSGt?=
 =?us-ascii?Q?5eYVBECvXAfrQONuG+UaXFMs4I+qkkUik02Lfhfcx22i1inY26uX6UuQztg+?=
 =?us-ascii?Q?LrqqTwJQ2VuALxEVIiSK7+zeLE9nzcs8mivgZKAtoa2uVHYAtrdvi7hnBsJT?=
 =?us-ascii?Q?mpOQOi7mGCMOX+PuCFGpxDHF6VSIHL4WYaNbdp7Oe2lQOVTfL+B6X+5joa5S?=
 =?us-ascii?Q?gpHAFY3b9gammGhnPuTBfsRxkkJBhlnKfIskpZkmXy3EfF0F2SUwGxyJnw7z?=
 =?us-ascii?Q?eopvu+/+Pkd3Ao8AuCUJ9aEp0pwnCWTf4W8ialmYl5Eu4Q7TxJZdHwLaPzZ/?=
 =?us-ascii?Q?9EYJZ6yLgD2skUe/mFDLL/QVmlUgR5qav35pTjHwwP0J0p7iXZRhbXeY/iko?=
 =?us-ascii?Q?/SgNXK7JauZNr21zMVIX1vqP7LQLsB1xImi+oEbVFYs2gL5Y7+PHfZXoHhjS?=
 =?us-ascii?Q?KCAES0+Q7V/Uu5VIoqggpythg4HTFm/M8CdFFGTI33XWmzpKGhPHEoKNdBMf?=
 =?us-ascii?Q?gxzpN3sjCSZ7oQ1+9XGM0zsreEXO6JbhSCp2UGAknWCIlfQhUDQxJTirOQ9+?=
 =?us-ascii?Q?aVCq2eNygq7o9yip3Nprn1KkBRia4DzV1x/oU15oM6gWErt7LMuYX9EP1XA9?=
 =?us-ascii?Q?q0AfGu2DFRQuS5zpMQVMFW3uYv2epPfGY2Zyd6WR1+CqXIY3VsDXv9OaFRsW?=
 =?us-ascii?Q?pPuRn+yShyZ5Obs+wNxLoA8WW7Y2AToB35z+23RctgEVl35dYS6aZd6O/8ei?=
 =?us-ascii?Q?YXq2ideofToql/RZjXCucn23+GPLInME4VweXVXxy7AGiu3XKaAXWq0EAR0M?=
 =?us-ascii?Q?YYIentlZ2EKTkH1qZf+UQrOYkXC/xiFhR2FaCSxGNQm40ec79nyhKXss3AAG?=
 =?us-ascii?Q?YgPCJ3enQqRReEqVT76sw5RTkzVZAwVKfu4fZX1K?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BLwjOddjVgALtwZpv0Rlvm0sw71dNztFKhR510ezivR93Ws8kdnhniN91LMyTVCqvEQXZnoRO6OoHjg6wiudx6cazo64/qNTd0Uf++HxY91zEHkA1lKK+pGlJyB2xY6jnSgkWN5qbBvKsoKD1eRAMo/+fMZOR252QPAbwAZ1DjCI1H47oyQV0c6QgvkEwOp8L+xwqNlJJElcMVCX8KL4oUz0BXHsQBHSBDwwJshdFZtZ1q16eAfvk35UhehciiNrE8xtfU9XXybk5l733udOgtZa6t1hfCptTpB7K5w4GE/QHya5Taka9kUxBKMNvrO06Od8VTYd6a2PShgizGY5t3IlCarbe2Xwrr9zupJP2nI0Xo+FgDi832Bt3mORq0OEzJLTrvHOwZ7px1qrd5GGr6/1NL/jgpPu0rnIyPkfbM0zQiJTcGovjoj/PvDFGzdfgwHCHidywYGDt1xbcigN1IQt1Hywde+bswi1wb+q5CJkP+wb45FcmpsAZiqvyZPCXgKKwVUap+Q+qhhNa3Sndc29cJxk+xnJcrHksK27iIiLygUrteYk1SOFZ8S81bpHKINJUh9nzFowvFlpiimHOVM0yE6tmPbaL/eU1zMV2NY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d960c8-b326-47f4-2405-08de10965c8f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 11:38:31.9777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bhmyv8pY1zwenpMcXxWR/q4xrzCr2p0LAop/9AhvH9eadAC40eNejWkHw2XDkRHdKurrwWQ4FvK29SxdGMq0eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7441
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210091
X-Proofpoint-ORIG-GUID: ej9n9QQBe0XnY01npNRakwA5bejaeDv7
X-Authority-Analysis: v=2.4 cv=Pf3yRyhd c=1 sm=1 tr=0 ts=68f770bb b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=_SA61mm6dRqLoDL8HkoA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX4ZZNJCQnSdj5
 pkwt2B+hjAu5ypwB4XXBNtLZHKNch8spAkclDW6GDSLVZoITYwIRphYlp5v+kCFmwpj17oLoUih
 Iy0zsOCpH+Lrx9JyMx36+z2NIbumTXztuRqcdbu0yt3O7cbTKWxR43W1CR+WoHsuEFSPqo+Di0X
 sD1sCfAdwLPqQD6a4ueNPkdfJznHZi1hSkBsKd2c3cGrwEpF4yG6WFVSt1HpGl4kzbPg9HyreZz
 rN/jxyAm/gXWnwMCheP3PdZa9SMV4HqptAEbmanrBytIsU6Q7vKPtVzZFOSaZvvqnr1EHzuMHOX
 kRyRx+Phvf0IBI9GQmGQo+fAKiKE1JmcQtJqV5JQCmjKRGqbfnZsPmQIUmxuz29YxMUPo423gzc
 S99f5s9GL65kmmSENr2csS7a6bY4OeBg6geb/wnr7cXFnakcTh0=
X-Proofpoint-GUID: ej9n9QQBe0XnY01npNRakwA5bejaeDv7
X-Rspam-User: 
X-Stat-Signature: snedhquhcm6d6iwws99zg8pyfuexgyys
X-Rspamd-Queue-Id: 4721CC0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761046718-791243
X-HE-Meta: U2FsdGVkX1/Tb4PhzUe0Mt9pyd1RESv43q3IqRNL8MIa4Vbnj3CBSKhRj6+rbVax0SsWwLFzFgFHYbVkmCm+4JyO45RNGtutQG138pqDkJ6JB+BZ4mhzfhL3vdYlhaZedmaOihvPOG/wTjdVe4FpxlbCKObMxXD1ZABRjc8nBdfh64LvKEUsv4XcWOFkENiK/dX6MJWM0tb+F7ys8LAXT55u6LOtIGa5faQU0bhl/HSRJTdt/htGfAD3oKp7yfI8d7Vlf1xp9m3/XJnM6aTAtWh3mN8ZdsMXfAxe15DJi7K2ASj1md08I7AmcbSSOz3LNiGKhJRRnjZLY8yxdNASbgvN2FzGW+V3NsSF22ACh8FHHTaRlvIOBsREJ9+q4Cwk/rY8emq1tVMz2c95/XgjcYmA9EoYGohxpcu9cHUpLNKPJe6fihPbFI2mELd439RoBIT1dSXW0PPfzgckW7YPNRsDHisoTh+pwHM1bArbn4/S0FaV1Bso7gxXtq+HdVZADq/qwv/7R3TEOh3+QbvvbDSWppdGd5zSqdNmU9BpXuNEUDIsE3XCQXLd4i2UXicAKe+KWNHhfvpVZxyPN8A86XQ84ZST7QYDJ7gqmDIS8ZmbKZcawBsdFnC81Jig2mtYmYGpHzbjCmAB5FHOxVo1VJeVi+igefoiMmYy4jkcHZd0S5ALbuDSE7kK8leF0WhKDL1yeeeUOExs8/rFnN4/DkHPaiIP+FWbDhGiQrvcWRWfZBvSA03rE09kiZwin1fAmbbbnOaIK08Jmd5tWM0RO+qUP0SVjdCdXZ5iuTNH1ASl3JBrq1xCRqGDvOW9mKI14Q73GVAcrK0cWEbtgqM0GqcQYckFendMx2pirQbXvV4QsmSRXk6Qxtm40RngPC+DDyNI9Nzoxxc3u2s2l8O4+bLdfE8FAWaZmQfU43og6cAqCOEPJ1K67DpNBkRyFWvGC9dWqRqf0ToJ5QsfUtS
 8bijDZgH
 majFrmHK1pXop7DxssMDXG6ls2RyH8w+KIjGYqYwhRFo0lw9LUt202ofAo35sasHgJZPuCwETUSY9K/0cH6z5utTfrLHMCqsZmbrAl1luRhpZfTRiyYo5idFTVUzyOlEor3A7taRrsxbw61YWtLn2bBgzz4jgen5dM6wzHedPY4YY2W+GdT1Bql61uLsVKSTYKdSbRgieofPksUKk+N9hfyBbXj/4GoDS1np7qZr+JxCXeAKGzPGaan9ozmf06S0jNyS7Bc7Zw5kkwnONSBmurR6dKqxxZVuVI49aJMQ95yN8XA5zf09atE7aKj6+0/SK1SmmoZEpoI0Bjx5o41KwffbM+jEuwqln1ZnJ63oiSb2YA+rsIWIs1nZg3Ulh+1gMQfdFFOFJn9penFeCugS/BfQMYL8vdAQb5uu0lK524k2601WObBjBzT8iXdSr6pyJDxZMFrqa/R7Eck9P6VrhT4xkfcXZXHRIhBcQjnz9sMyjmvv2xwYPN9Ax6faNJBTeWdSseB7LY4n/uN0fOV47jUJOIqHdUkDfSFjvGhpTxE+k7kip8mXR1EOSHrbgNUQaaG9W9KG5VsX44zVjbUX69mYbVV0Tv5tMPnS/n8Y+tcnZhX7lA1VEO0xxDnewwS0sEVJmGlxA8b/26rcvYH+5oUIiHYgX3gh8xeJ7afSVdNOK29Yb+63y7h44fFm/Sm3TsRIUOwIsMBS9wKtGx3siDAfk8/gi5H2OtRk9rBWOexFFiDlkfnk97AZlYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 05:00:04AM -0600, William Kucharski wrote:
> The commit that removed support for destructors from kmem_cache_alloc()
> never removed the comment regarding destructors in the explanation
> of the possible relocation of the free pointer in calculate_sizes().

Hi William,

I've been trying to reintroduce slab destructor (which hasn't been reposted
for a while...) [1]

[1] https://lore.kernel.org/linux-mm/20250424080755.272925-1-harry.yoo@oracle.com

I haven't had enough time to get back to it yet, but I haven't given up
on it either... so let us keep the comment? Otherwise I need add that
comment back as part of my series.

-- 
Cheers,
Harry / Hyeonggon

> Fixes: 20c2df83d25c ("mm: Remove slab destructors from kmem_cache_create().")


> Signed-off-by: William Kucharski <william.kucharski@oracle.com>
> ---
>  mm/slub.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index a8fcc7e6f25a..09cbbe923a05 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7875,11 +7875,11 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
>  		 * permitted to overwrite the first word of the object on
>  		 * kmem_cache_free.
>  		 *
> -		 * This is the case if we do RCU, have a constructor or
> -		 * destructor, are poisoning the objects, or are
> -		 * redzoning an object smaller than sizeof(void *) or are
> -		 * redzoning an object with slub_debug_orig_size() enabled,
> -		 * in which case the right redzone may be extended.
> +		 * This is the case if we do RCU, have a constructor, are
> +		 * poisoning the objects, or are redzoning an object smaller
> +		 * than sizeof(void *) or are redzoning an object with
> +		 * slub_debug_orig_size() enabled, in which case the right
> +		 * redzone may be extended.
>  		 *
>  		 * The assumption that s->offset >= s->inuse means free
>  		 * pointer is outside of the object is used in the

