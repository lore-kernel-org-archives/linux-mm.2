Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CADC5E63C8C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 12:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A956B0088; Mon, 26 Jan 2026 07:57:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027EF6B0089; Mon, 26 Jan 2026 07:57:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21736B008A; Mon, 26 Jan 2026 07:57:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C40686B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 07:57:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53466140777
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:57:33 +0000 (UTC)
X-FDA: 84374116386.06.8997331
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id EE395C0004
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:57:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SUArpBOF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Sxyavcy6;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769432250; a=rsa-sha256;
	cv=pass;
	b=3uAkOd+a5bxA2fmxHrbIunHIMm02vX6BJ41/KvuGwleMd3lqA87IZbDjf+3F3ZwIUSKJ1K
	bIKbJDeJ3S57liwADnDzwgMxEMyngwn5evVh2PMzzw8GSuEEg5YBAP2cWJbVqsY/I+19Im
	YW5hPcdT9pYQiRJ2GHKcM53SCDPhklw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SUArpBOF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Sxyavcy6;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769432250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4rGsF6VDzJEI/IUM/oMbpkEkMw11WhKMEN+soVCqj0Y=;
	b=Q2v5puh5QkYXzEmtSjutMAULLB9ajYE5eF4tLX+RprEo2XeByAny2I+JqqCBqoiDZH7+B3
	dxscXjmeVeisPlrmHxEEvFYib2reQh/0lyPqosoJA0DIYR+Tlwar1oSgcJ2Qi6yTxEO/iv
	8EMDvvZQRW0VR0CmOgGXT18Qr2w6L2Y=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q40CpZ814956;
	Mon, 26 Jan 2026 12:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=4rGsF6VDzJEI/IUM
	/oMbpkEkMw11WhKMEN+soVCqj0Y=; b=SUArpBOFDEqCs5Q6Nn1DySCMBRWIuGLj
	TdvuMQjxd3UNGEBF3Uq9w6wRXjSi1rw02wJjxaeIJA7l/Hwv1+rsm/MJOrgl4+po
	wKDbSbqnY4NoGLN9tLtwGuj9wMjbZNkY04RCOlbDFSHYCJX+dHeHkeJu/JP05VDw
	RMIejqoxdOfrKwIVDW7vRf3017md+XDo9byBnnzPe02SteCL6dDwRWt6au9yxQ1S
	aheBySAWag3m7CK3DJl3gD9Ws0w2xE/JtRszQnGDxcQg9LJLPdLKQ1YjrZUjymOF
	sZhUTSt7IAMC/EOd8cb809WFQoUO5ny6DWlp6vnwI847i/az9N8A2w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmgbssxt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 12:57:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60QCvHoP012130;
	Mon, 26 Jan 2026 12:57:24 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010005.outbound.protection.outlook.com [52.101.46.5])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh7x4eg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 12:57:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qPRFLhQROfO6M5mvohbEn4SEmYy1Y178aSwsrFXyiHmabFicyDEzDP3lgsLmu5TK42IbWImJAoJmzKzXJorutxj6/yEFFweX4L2/I7a+45uryu8ZsnBPRyEkGXuC3jVIym6wTh/y2o7KsZzFE6UY5Q+H0Y2nqJ9MdZKWYoGjHWFJIMM11F9RuyDncqD7IAWE6p2E0mrzkQW3Sazd/qVC/TGzBmnOAltnMiOqTOk4oGTAPeRtXW4chhJ1bxp2iT0cfQSyfBTpMs6591BigzXDcayg/Uq6jD6wHp9/v/WUN21P5LdP26kZWwi3/8HLZBlJjQgmYvaOs9Gu8gftjJXlLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4rGsF6VDzJEI/IUM/oMbpkEkMw11WhKMEN+soVCqj0Y=;
 b=NbhZZVeg1rubzvbT1xVZWw/D5tgzqOrVUqff6jFbEMqhu9MjfOPC0KGgln2TtW9WeezkbZb18A0RucNmbyd87oUYPDA21nwFyTy9NCdgAlQFWb/m24Azb1EtVMA6AooRMzRWtCBzghWt4h0XJ+Qn/wSeah3ltNuSdAKTuGMT9c4HP7JKtUFn5tJJtMjMFQ4slG+I4Pw3mVrhbRkDQi7nc+fRZfhVAjflMyqzxPp46eLPCsvOMl7VpJypIv4Xq7DLBFYLXHffwWIKkHlZZZ3dk1Yr+RTozsL8LHOeAyK72V2mMgi6yeFwikRplnatvfu8MVve+g1u4ZjxnjV/00EJWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rGsF6VDzJEI/IUM/oMbpkEkMw11WhKMEN+soVCqj0Y=;
 b=Sxyavcy66gHbN5VabxFQ09lwETMR3C0mP6pYJa5hMRA5pkvXtdPuLatVOYpjAHL7rTjiWByaToaYoXGa6BHy4dlihkOUOYEgYjEx6yCayjw/fLQo3H1vj9OJtrXe+9jiVbSeYtvp1CiLoV9Fc0nJfPFNIOL6oIsj4jMQtzBInF8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB7982.namprd10.prod.outlook.com (2603:10b6:408:21a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 12:57:17 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.010; Mon, 26 Jan 2026
 12:57:16 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: linux-mm@kvack.org, cl@gentwo.org, rientjes@google.com, surenb@google.com,
        harry.yoo@oracle.com, hao.li@linux.dev,
        kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
Subject: [PATCH V2] mm/slab: avoid allocating slabobj_ext array from its own slab
Date: Mon, 26 Jan 2026 21:57:14 +0900
Message-ID: <20260126125714.88008-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0072.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bc::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB7982:EE_
X-MS-Office365-Filtering-Correlation-Id: 12571aed-7085-4cb2-79da-08de5cda6e5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VL24dg4q9a+4Ef4AOkGMjfiq8XlWsqCGlbrmmSfskoT5mjoejH9skz44HVQF?=
 =?us-ascii?Q?Yaag9SVP5Of3l0HmCPJbEy/n2Yy9m/D0FBFauu3qYE8UQLmmwNGJP7qi+Igb?=
 =?us-ascii?Q?ynbdvw2Doja+IN7B/OYwUD4znRa4E4R6OMviq1faRBUluON2ciPbIQgW0psm?=
 =?us-ascii?Q?8s3I7VearkTmQcq6qU4T16iDu2EqqwMyMs9TPY0zBnAxl0F3zcI2oaJ0BV+a?=
 =?us-ascii?Q?Kqx01/Ck3j0FD9kDuklSocaf3J6XjjWmAJdTgS4S0QrNf7iihUza9yAofesV?=
 =?us-ascii?Q?ESyDoHVo5wKS2ANQf7tmNB830ETHXTO+GYmO22kuWKiZOwElav7hLKgfYrD0?=
 =?us-ascii?Q?p5G5Dy+FqXN91+oxnMObKPuRPmyHUY1NMWRrgHAcT1YyPCO1EmMjTebxJjVP?=
 =?us-ascii?Q?UYSAOW8tmRkVg9RdA97bsn6Lrl+FyumaN0dLAkns6DpRcjWyiI2VP+YDuFa3?=
 =?us-ascii?Q?kVBU2UI3yO0feAfaYvptpJyzFhO90i3r218WYChV/4HQC8EuwwsgBBkv460J?=
 =?us-ascii?Q?+9DQOUQ3vhUpfF89ZCwa7yxrqqNsobP/vo5wEssnmuJcvZQ821k3MZHKJpMA?=
 =?us-ascii?Q?c8ey1cF0XG8I6yOpbYLauHOUepgyaurM55dcudOMNKHun3AcYOAv+cDFbTwc?=
 =?us-ascii?Q?iccEeKoxeOMsyfgPR+SkT7SWrGOqYp500zrzThVAsujTgGaXyti7QglRK16S?=
 =?us-ascii?Q?cUAYMR9aXIsV8sla3Ed2r4fJK8ScaVNI+tuQ2P4eUQI8ZbeYGLpk+p26y2wQ?=
 =?us-ascii?Q?4t8rODF7PAynYdD3H94ZfCifDm0JrE5R08yRRNi8urTGKRPrlTDyXgEA3UVK?=
 =?us-ascii?Q?dgGXXzBjh3yoAK4GqDqwHZCx1Y/8Yy+V2CGxnT+zjmDovWQ7/CSpvrEN6hVy?=
 =?us-ascii?Q?7gYkR6bNweK1astNaZcIHHcJOn4wtOJXbBBqOsK4Dno9lqoNbMNfUa1FK6rU?=
 =?us-ascii?Q?c3VcvOD4/manUChGJqQHAyYO9hnVLh5Objh5LCghRfEzaWbgr8VAQ2FC1Okm?=
 =?us-ascii?Q?pYny4UCzv0QQWOQk8dbeHyWeXtwECuVas/MlnATawfVr/KUlyf5JkjxMRjcJ?=
 =?us-ascii?Q?TguKvII8O/Q0/IKeR2uSw94ARZfW+0+08QIk71zfnTV/g1UWprDZiCIuWQX+?=
 =?us-ascii?Q?nrb9H6l38GF70vdt8tLkkDjW/VNIisfIR/EGGHjngHEIe/C7Cy1yC5b4MadS?=
 =?us-ascii?Q?/874+ys2zmwGfrjNpQ+xIXhyB83o8Elb+7F1aBgVIAp0VhDAWC5qdgTOgIp2?=
 =?us-ascii?Q?vPquyx0VYwKs4VlcHLGqC2q3ZdfAVban48um5bHClFzPSj36mu2ashw4czb9?=
 =?us-ascii?Q?RuISufhMIpKwADHU0SaQllVGQljWQ9qto0CwrnQjACYTXfARWIKYTkHWdmd2?=
 =?us-ascii?Q?fr+MTPK/KUrDCHtY2PhfKtIpLRbxvAcfnenUtIzGu8654K+6H5KdN+K4YT4i?=
 =?us-ascii?Q?fxJUGYddnZ6RhptcxrYr2PzNCtWq9WX8JmKD/gksbjQUzwKtG1pYeRMLItXY?=
 =?us-ascii?Q?uMKtm4WYyS6tcM1t7csN/LKuw+LsdZNPGI+pnO8Ss7pG125i1TLf2O9BOQCL?=
 =?us-ascii?Q?hjFfrsBoqDtkMwognrjdT4UKSpxEf8oPw6UFaWsA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R4dVBr8EPGlCBEHhgWcOnAsUXTNhlyAeCUiXDlEoEk5TWmJa4RwjYFxpEoRW?=
 =?us-ascii?Q?RJ6TsXhK/oFn4zUVblwmVRQF07zLApXx8jlaY3ya+0rvjx7y6QJro+X68LJe?=
 =?us-ascii?Q?Plt0YG/VnPCHXMlgmDC6KlvDDCTs8tC98O0JKU+n86fM+Hx2HsEQWnxQvlCT?=
 =?us-ascii?Q?/vWqcPJo0eLMSFpHSyy8DG7qJgrDnp2HVAfIdWma1RNRxma8RU4jZAROUXRt?=
 =?us-ascii?Q?zquIwkiDWZqJ+k7gK2bPNLJw6HfzE16We5LJhemZv6okLMTd9gEulTMs3KQv?=
 =?us-ascii?Q?NOrMs9TYHU3ZXi5YnGJAhGRYjW0TlhxJwP5dTSWefY5UL9XMQTDit2s4AYcD?=
 =?us-ascii?Q?+4sdgcslsiPao//tBmRoea6DpoLiW1IUSb499Yzy8eHCeFwu/jyTRWDlfgvU?=
 =?us-ascii?Q?/V2949Y1OKRGD2bZknGFwuAgnVyGM5nhqbac4OalBc56mSO+Xkc9orERtSAo?=
 =?us-ascii?Q?N3DQwTgWhqEFNs/fnX/5Vd931PixEVKLD5/G7qMr8kqBREgv+2ISH2PkhmIu?=
 =?us-ascii?Q?qRmcAjr6/Ciqe6i7BZJ78iymah+GinASW8HuaSQvDWvg4ZWNetosVaHtRm68?=
 =?us-ascii?Q?I7KGE200BzG+14MliAefahtFP4+0/Xyozx/irzFj6pxmUKiPlzpXI/J/CZSU?=
 =?us-ascii?Q?eccB8tUBL8FBu1hPXStOZbE7LABI47agUZGP3T9XOx934v9FeOegjXruhpEk?=
 =?us-ascii?Q?+Q70I/YE1ndvZImJ/QDEMpSmhK+McBV1ydRH8K4g/ginHI/e9NP5s16jl2WJ?=
 =?us-ascii?Q?i5C7emkMMoDND7yICkwSBjyvRpLxBaC/A3wTybj3gtuLFgTCS/uFjpTTZhpZ?=
 =?us-ascii?Q?ZeznMQqqdKk1NrU3Sn+3OIUXtmuk/nFhvqaFT952rswrRozjr9+3pvyDd+OI?=
 =?us-ascii?Q?WsIdldASlwXkQQzGFQBBqAy/CSOGKRon7RH5WzwlDBrvQ00hs/CuHoRK6e6w?=
 =?us-ascii?Q?wSYftXIhLLT/OHQzlJMUQ+R0HKZZ8a/MmrMuVsFzKj0dI+qREHy261IfSRvI?=
 =?us-ascii?Q?iZZlD3XURk705jOs0KdKBoB5OcFlGV04RatVE1SSAJI+kZYvObjkT23Ia4AZ?=
 =?us-ascii?Q?4mY9GyeuFxHSINOCMCIh3MVK5Ex30L9Nohf8dOlJdBhgvXN87nIyZdgbAdVY?=
 =?us-ascii?Q?4FcOYaVi2qga/t+OCvVZ/NLYAP7ritUAzzFx9VTIdyVXznYe6yR+VZrKIZ6h?=
 =?us-ascii?Q?pOfyyxgnXNZNjyRHlqF8OY4uWuCSNnqomIbBM1sP0RRqUc4NAU0nA8lttp2I?=
 =?us-ascii?Q?CNOkSrhASHNTuJ9Nf/T+Sf6siirk5tT1hVbzdaGhVnN5SrRXEqebalPDYh3K?=
 =?us-ascii?Q?BYgSVtObzbEj/KcVJ0aQEoukOh+dYlCcyTkRNuxOvsrrYfokdB8vGKdc2w3w?=
 =?us-ascii?Q?GgzNxiWTJDKpMvybT+MtPCqdcwY0Pe8VRJkVNLpMWR0op5wOJysmGR9xHxx6?=
 =?us-ascii?Q?C/jmV9ytKU8QHsdqkyDhy1qbHTIHLuRGakDK1W0rzLT3stY9yif6Oc1u7Upb?=
 =?us-ascii?Q?z+UWlcrDOHkvcwx+nIA1oy6bOKzYOIcq6HvPxdDxMHGArdyhtjmLoiKbZHOU?=
 =?us-ascii?Q?E3bUafAyCiCauRCxKOykFhOGLo7gQ7gLDTK/LJv+1nKJ4m2KjX1d/wEoVcPH?=
 =?us-ascii?Q?Mr9FK1aPEW+SbTDrd8ihf6Ctp6UDpJWuxSHjcHDrqwW0pq4MRtysYk8fARb7?=
 =?us-ascii?Q?uTyKBG7BOkLz/qrvbyItS906e2bfTOtMQRYs63WlyWJa68R8A4bXW2ysNcTC?=
 =?us-ascii?Q?ZvPucTpKgg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZO2RjzV0SIposUq1i5aNgtJrkEhn3keCUITuI2rhn4d3+tw/VgtcEry5HM8ENOdTUBjQli1hOIPVAisJ7Tzg9XeB+aWTmfwQb+xjlMZnxDbfe4r2lzXJsnxwUS9eZ/cYwDFEeLTACRQIsGrI40Jdf3E9Vl7ZgT08sgn44yTR7pimfAZnhM5s5Zz05rePPxlR3+1jHqFFiPvpdtCJWHs/zUQUPgMnECULaveenJ7sKNdhHVW9bL0ZC6deUj/bzBzSzlgege6Fg5WTSYaL3YHqzVh0ZYlirD2g7eu0XlPXJ4YKRTjjnRlQ7smnlSBS7hM5lsG58q5qCXF64CJ1suAy/RotWZFiOIa2+5QFPdG5EILD/qLWlqmsTW6H/O2u/9TCoQ/eDFuiE0KxKAjTXT+sthMJ+SfG6thb5k/3w7wIp7qwuwlQY2KVvWd31+QwqAsL71KpM3y31vp281//m9BqhBJMn7HgxbmgIwIppNcCzd/1SDAutyFIUSX+VwVD9IHT1REVCKFkShUyIGzlXzllC8E0RSnu56x1KEe8Lo9ktoJTXkTBATeGo2a4bfWs2VZPk2b1lyFfH1fPGb5nCOVFU4WY4fmjuK+d+xyIxilwE9g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12571aed-7085-4cb2-79da-08de5cda6e5b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 12:57:16.0231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+zm63R2AoZa6FzHktJkAEA8K13PR0hCERZyaqiGhH7U3yqXzjq3qPnl4wGSGEV0v7VfO7NgPZD6/OC7Gs2ENA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7982
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=875 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601260109
X-Proofpoint-ORIG-GUID: e7pgZunFAxL9ye3ofuzFmpnOIlUuQ5FE
X-Proofpoint-GUID: e7pgZunFAxL9ye3ofuzFmpnOIlUuQ5FE
X-Authority-Analysis: v=2.4 cv=AqfjHe9P c=1 sm=1 tr=0 ts=697764b5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=yPCof4ZbAAAA:8 a=r9yMGVhzXb-e3HBZQ6UA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDExMCBTYWx0ZWRfXxgl0v/DG4Cxg
 kKSk1wuWr7NdbpAOZ9J1ikdeg/i2KntPWbdTwPKmDk18hfSCMhDeQ8Z5zUiR3CB3kSay4YTJ8R7
 /kjSIPeSTT93/scjmVNLW63iOJ37y4TG5B57OE6f9252pDPSHPn2XtnDOtqQGm0GEnWSPbvJrCz
 dNvp1LM5OXXD5GR5qMQiYSie0t0EB5HvvYGAOlgIcrG1aTpF5hfiFP2qPKqo9lWixi9srxvKblt
 CA7Q1pF5ib6cfliaXYaA8dtgOynJAN+dbN1CCVNJ/jEn69ND36FVxvi/3HEles8NsegIsfTBZYe
 L8AXA/+DsPUsghtyB8zW1NkeWkqXR+Xm/r61ITH7AYi/Mci/eegham+I6GW6achW0a557yKUkOH
 0uUYP6hos6nhUAmtDzpxhBAJNcW2INP48egtq+7bTCEwgoBAUJvbZtlClvY3dN44kPhHiw4lCDZ
 zSHdHW2Q90oi18EJMAQ==
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EE395C0004
X-Stat-Signature: wud1ays3fhf63f88bbhj8a9mypx7wwbn
X-HE-Tag: 1769432249-899878
X-HE-Meta: U2FsdGVkX1+spBgKi9sxjfPcOviNqvjRThBEwy6nrzFuxh0ytVVUr9etHiKEGMICgc1C1zMUVG3rKyeNJPL1J1EG3JweWeqqzMyTSlkQ+G81mveZRj036QOiIBu+ty/+U2DR0MABLZA6FBHgNXESC3/FNmhLv1Y4DmuuErs6TqrIFDItqadwM0fbEjhqYqjV5c316hxUaAJO9D08vbhASkBMcZ0wQYwywjanrd0qBBeO/lColnWqml1s/JQ7IZaBRweekwt7CZP+jHiOJYuDKcKF4bIogt5efGS8DWGzGi2tbvVePV4X0XUVg2d3xr/Y0FRq7EkVZM5vcqbjyLbZamuRbInWQjtqJPDpWTHErNXRqbUyE1F9lPeNcNk6hTGLW7d8ESM+BvETbmfGm5M+RYtwr7ksXpEGBW4+wrPsDVNQ2AU/inoglFvqop4zpnfTxBCNvtMuZjGXrgT2yh2HkquucbJLAiwydFVedSiW5hEsZZNdxoP5q4klV1bilvixy7WhWzn2ziwldGq597oUPiPT0zWUFMgZee7Kdmeld0xCyMFBv0f1+Mwfd4g8Y8Oit0jjWQ0umV1R5TDe8dRuh4/a04h4NsMkWY6FCteLCQM0OfpAnoG6GCCdTTn9F3wG7FvIThAVewraTzCZ7H6KlmjI5xVHPieL8EhImrSRmVBwEH2kVRuZoQ3oAhSo7tFFzEFW0FmUuqjmenOlOcT+KYdUh00Ic+WupDSvz288+ql8hA9NovBLt4gNbcZSfA99EQA5MG2+J5j3enlQqV78YhYYGYWsTuQ3VWmwLFi3biY5lZMprD2dSqmTzvc77ZanuWq1Ut80Elztmz0a+kw4wadHBAckTBjiOyN5XBhjJ3UJBGnonBqAEN3zaX0ZHuGD4DIQLmqQABnwJK/XMRaYfzKlcuSGV1RfeLWOJu4g+IclPwP6nUEWZ0HLmFqVU4kwkfX77Lb6FIepeGQi7P2
 oTj2NNzH
 j/ue4dGig2I/g35ll5PIrR4ZNzF3kMyRg8w0Uxp4apDxsV9ig5ESQi0Lq1PVU5MWIcl4iTEDkoiD/H1alpsBZp8p4Twy92bXo36IMZDo8iT+bbna536pffMwOegK0coZfyifY/RYAQi/rMRMzDz0OUME4fNU8TapuJn/0KGUaT9S6bjUyXEj+izxJjpu6cOr+chUe8PzkKXVcABU1xqUxzqcYbrKOYMDCxTT+lKhDNS3qAugVriPH4PzBKi31YsDc7Hxt9zuv/KJXrHkMU0xvP8/mIVhb+L5hT0rWHL4w2Kn0jv38GWSsk9R8EAy1sJ+Vnc/RApKb6Cmp+gWts0NIbx7MW5BZahq7Z1k9cHZY05WDdrn8t4g3BhxxuS9d5AX0nNxIpJRKK2dm0maS8PNN3F54cQfLYMRo5asJJTX+l9zmMRF7m5bHsPDeXd/+FcCyZ7qZdcmge6UR6itIb6eDsozPlT18ABEFG9NXY+yMnvjtRWSqGtJHORegenruXLpX8XrSQNEHfVoTu5SAnXu24rpDceRa1xYG7Va8zv20be8LB9EelLU9OzfmPeuSQlbpvl4Cqwg0edYUjvEgINUGvgs/rXWZ+K8TkLLVFiGBseNodJGuYhhPXen6Tp6feNB4BbNFm8JG6gkLa1l8evzQoP3zck4VtJ5Ef8oCynDUGUp/8AT0HI+JZqAKbutcq7rTW74o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When allocating slabobj_ext array in alloc_slab_obj_exts(), the array
can be allocated from the same slab we're allocating the array for.
This led to obj_exts_in_slab() incorrectly returning true [1],
although the array is not allocated from wasted space of the slab.

Vlastimil Babka observed that this problem should be fixed even when
ignoring its incompatibility with obj_exts_in_slab(), because it creates
slabs that are never freed as there is always at least one allocated
object.

To avoid this, use the next kmalloc size or large kmalloc when
the array can be allocated from the same cache we're allocating
the array for.

In case of random kmalloc caches, there are multiple kmalloc caches
for the same size and the cache is selected based on the caller address.
Because it is fragile to ensure the same caller address is passed to
kmalloc_slab(), kmalloc_noprof(), and kmalloc_node_noprof(), bump the
size to (s->object_size + 1) when the sizes are equal, instead of
directly comparing the kmem_cache pointers.

Note that this doesn't happen when memory allocation profiling is
disabled, as when the allocation of the array is triggered by memory
cgroup (KMALLOC_CGROUP), the array is allocated from KMALLOC_NORMAL.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com [1]
Cc: stable@vger.kernel.org
Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---

V1 -> V2:
- Simplified implementation based on Vlastimil's comment
- added virt_to_slab() != NULL check before dereferencing it - because
  (in theory) it may be allocated via large kmalloc.

 mm/slub.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f21b2f0c6f5a..5b4a3b9b7826 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2095,6 +2095,49 @@ static inline void init_slab_obj_exts(struct slab *slab)
 	slab->obj_exts = 0;
 }
 
+/*
+ * Calculate the allocation size for slabobj_ext array.
+ *
+ * When memory allocation profiling is enabled, the obj_exts array
+ * could be allocated from the same slab cache it's being allocated for.
+ * This would prevent the slab from ever being freed because it would
+ * always contain at least one allocated object (its own obj_exts array).
+ *
+ * To avoid this, increase the allocation size when we detect the array
+ * may come from the same cache, forcing it to use a different cache.
+ */
+static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
+					 struct slab *slab, gfp_t gfp)
+{
+	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
+	struct kmem_cache *obj_exts_cache;
+
+	/*
+	 * slabobj_ext array for KMALLOC_CGROUP allocations
+	 * are served from KMALLOC_NORMAL caches.
+	 */
+	if (!mem_alloc_profiling_enabled())
+		return sz;
+
+	if (sz > KMALLOC_MAX_CACHE_SIZE)
+		return sz;
+
+	if (!is_kmalloc_normal(s))
+		return sz;
+
+	obj_exts_cache = kmalloc_slab(sz, NULL, gfp, 0);
+	/*
+	 * We can't simply compare s with obj_exts_cache, because random kmalloc
+	 * caches have multiple caches per size, selected by caller address.
+	 * Since caller address may differ between kmalloc_slab() and actual
+	 * allocation, bump size when sizes are equal.
+	 */
+	if (s->object_size == obj_exts_cache->object_size)
+		return obj_exts_cache->object_size + 1;
+
+	return sz;
+}
+
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		        gfp_t gfp, bool new_slab)
 {
@@ -2103,26 +2146,26 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	unsigned long new_exts;
 	unsigned long old_exts;
 	struct slabobj_ext *vec;
+	size_t sz;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 	/* Prevent recursive extension vector allocation */
 	gfp |= __GFP_NO_OBJ_EXT;
 
+	sz = obj_exts_alloc_size(s, slab, gfp);
+
 	/*
 	 * Note that allow_spin may be false during early boot and its
 	 * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only supporting
 	 * architectures with cmpxchg16b, early obj_exts will be missing for
 	 * very early allocations on those.
 	 */
-	if (unlikely(!allow_spin)) {
-		size_t sz = objects * sizeof(struct slabobj_ext);
-
+	if (unlikely(!allow_spin))
 		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
 				     slab_nid(slab));
-	} else {
-		vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
-				   slab_nid(slab));
-	}
+	else
+		vec = kmalloc_node(sz, gfp | __GFP_ZERO, slab_nid(slab));
+
 	if (!vec) {
 		/*
 		 * Try to mark vectors which failed to allocate.
@@ -2136,6 +2179,9 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		return -ENOMEM;
 	}
 
+	VM_WARN_ON_ONCE(virt_to_slab(vec) != NULL &&
+			virt_to_slab(vec)->slab_cache == s);
+
 	new_exts = (unsigned long)vec;
 	if (unlikely(!allow_spin))
 		new_exts |= OBJEXTS_NOSPIN_ALLOC;
-- 
2.43.0


