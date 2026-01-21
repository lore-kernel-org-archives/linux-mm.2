Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CA32D262B0
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 07:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B004D6B0005; Wed, 21 Jan 2026 02:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD82E6B0088; Wed, 21 Jan 2026 02:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990066B0089; Wed, 21 Jan 2026 02:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83DD86B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 02:06:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DF801607D3
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:06:52 +0000 (UTC)
X-FDA: 84355088664.11.BFEBCA0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB01320004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:06:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lHN6S6Or;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cP+ZNHuM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768979208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hosC37p3wNzOYBA+dJ0H+J2lP50qcbdcuapZ0PPqcw=;
	b=XL0QPheCCERICoToF6xtkp4EVwpQ+NnJaL5SJbY0fimQGx8Ekqs+NdL7WFAKXvYC0SIyAr
	/DWlMz5+BnkH1nsNOtR3Sqhk6vIH1dqUtRkcRewXK3L03FP1uY6EKpiMj9XNmVX5SNVDJ6
	6x5RaZhaH62+1vXPFuk39YNaNexraoc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lHN6S6Or;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cP+ZNHuM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768979208; a=rsa-sha256;
	cv=pass;
	b=6OSBi0cLHdkxi2VX4vKfRoME3L6uTsy19De3gaeQ3NG08Mk2pfHDZXZGZkzdYuSvKGTsVX
	K6Rf0iBDEeNhpxAakW8sYS3h2fckBybH/tRn5Icv9+HN3+jCSpAKsbF+TSqZxgWG26hWjy
	1X2GOu/kpYkp3/AZiZ0hGiXN39Rok20=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60L34M1A3266582;
	Wed, 21 Jan 2026 07:06:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1hosC37p3wNzOYBA+d
	J0H+J2lP50qcbdcuapZ0PPqcw=; b=lHN6S6Or4jT+VrYfe7NIkq7i5Oe9T9mceZ
	pzffKNCgcIydvKQyECAeWih0/7i+bi/G+xArUk8oo9ZdvsR0DgTFgpYqT0Qiiulc
	S37Mp1XB5iCSO2y9OjKAmCf8piIdhBH7m21YzttfNpTc5pOv6/+Ltoy35C716LTf
	wfioZGzTgAsAExPxIvtwP4t8YfdvmmyVc29hOSiuYzi/buuU/sVAQ3Uvu8TiMfPx
	pl9Nv+8Od+zL5rhALc8N2ZqE1uU1bGUIIiIzI8cJ9RrtSkHLdRAuoEH9RSj2rmlo
	nGxBAqHB9ofoxJthnTzzdeR+ExQbp9g7eMYMaM6tDtm9ralfyXcw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8dbe2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 07:06:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60L74fUq032204;
	Wed, 21 Jan 2026 07:06:40 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010064.outbound.protection.outlook.com [52.101.46.64])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vemu7d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 07:06:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ml1pBKBXFXYtJjDevoyozr9RuziD8wnEqi5Lp3btq8x4fVACZrPOAjKFDGtD9UaICJTrOdwh31yDDcE6G6I0vscI2QSHLFE7juUaLWLq+Ww9jUpq27btjFChF5F9ERSPiye7UpHf7qlKdKbHalS9/YuAZyqCrN/nGim5JNIYI1MzUA+iBxZGs1bgup9IB4k/8GpuQ/P3C7LzCdpmdfiDXfdW5AQ10YDQuUe2izX/e+SXej/3eGgsDUHkW+RABiA8xxjB4OaeZehakXFUnbTBTNpjoKsK+SeAhLYv31N3Ynh7SsE+HXS8oIStwFMp8UVbbtg8xQsAOeFxGI+IJdHdPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hosC37p3wNzOYBA+dJ0H+J2lP50qcbdcuapZ0PPqcw=;
 b=Vq2H3E1CAZSbiQtL+jwPnyPrn9zTkhsurnjbM6i8aHlxCQbEW4TSh3Ibj4pPAKeSuviPIyn4clBALSG6Dpibsx8+QJaEJ+w5jyLopuMq9WPXsNpvZT2kBaDNXHXrFHf3iCVb43m2ovxd/guEflcA+kgX68AJUhQ7IGX8mD3AUsOt9byS2mn+gnr1qIKHTJMd4eZ36aW3oX2Wv+DYCKpIj4sigA/+3QApFL5SaOO1ZAJi3gTJHmhuLPbb9CUoaCECTWGt657/s55U6fzZAYDlNadYvenRXgT92lFc8EFBWF0Sjsb6ZMGSTHwFMIU4HtGBLXkWxzYIEpE8LTh0eTO0lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hosC37p3wNzOYBA+dJ0H+J2lP50qcbdcuapZ0PPqcw=;
 b=cP+ZNHuM1I0+OMEi93WpgAPkT6zg6anC2lNo9BAVFWUeQv+lSPninD4+gzARmelKcHh4+kbbrxNr7By0F9YjLTC0zImQD1yow5da0GNCHN0rc42voIH3rpIyGUmv3Kxfrynb3JBp/pdB81GmFrdolnIMN8CK6igsQzU8ldRdjnM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB6224.namprd10.prod.outlook.com (2603:10b6:8:d2::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.9; Wed, 21 Jan 2026 07:06:32 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 07:06:32 +0000
Date: Wed, 21 Jan 2026 16:06:25 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org
Subject: Re: Possible KCSAN/lockdep issue in -next barns
Message-ID: <aXB68e_DtXsr7OcB@hyeyoo>
References: <c858b9af-2510-448b-9ab3-058f7b80dd42@paulmck-laptop>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c858b9af-2510-448b-9ab3-058f7b80dd42@paulmck-laptop>
X-ClientProxiedBy: SE2P216CA0176.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ca::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB6224:EE_
X-MS-Office365-Filtering-Correlation-Id: afd32824-0cba-4d24-c379-08de58bb9b3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IFY1Pmy5C73qTkPaduBM7qm9m6SdSIhUcYR2whBzV8l/ZfU/u5TlfOA5g4MG?=
 =?us-ascii?Q?LcgoZf1DzJVj8lWxfs0EgmSUUU0/Sx2VXgli8xEWLWllDV+z1cIxeJa04uNH?=
 =?us-ascii?Q?KFFDtkclug9b2LgKGiODui1KchcEtlmKMbI5Lmrju837WhnQ/nmfhTbiefmB?=
 =?us-ascii?Q?Ac6mt/hjANKUjkJnrahjXAMwsq6xUcV2n5MbXbBXS28pevL2ydvaA6/ngWWb?=
 =?us-ascii?Q?9VClQMakh2N0agUYKOCW4hpGZh9lC3kfqn15DRlWSQd7gyVqC2XiqYisufj4?=
 =?us-ascii?Q?rbw2QAo39XU+TNmp3jrTARYQ2U8U0/qdJK74QApjb019iMfRrIEv8HWByU/Z?=
 =?us-ascii?Q?rBSIwHp71zYRvzLXW7spg4rkRwCPcPhdE2UHp5FSmtdNHtAYBvIwotWWcnyx?=
 =?us-ascii?Q?zUtDW3n7VY0XB1TRS1ZGwp7bgEMgyp6484DUWvkIkMfcwWJL1XhhF18ExxsD?=
 =?us-ascii?Q?mabBX8oclQzIkwm4yA1lFXgm6xgM/+iYUGZlk5PncA+q3wIEQI6VQnYdPrnR?=
 =?us-ascii?Q?L5+ayHN2IA5oqI/0uUB9JxjJx0n+Ehi2DzHJ5sxCSmJqdBxgA5N9u6nSeJiF?=
 =?us-ascii?Q?FhLcaLK3tna7WL0KOsyfl2lJ+lJ2xeqPJMJSzY+EMSR80Sjc65VZ/J9oELdc?=
 =?us-ascii?Q?LEQ6LLm3Hf9F+DHq9MxJGmyKz2ST/zdS+DmZIyvwd83oMOCRQ/NTtd/v2H4W?=
 =?us-ascii?Q?9wD2ardhVhRprHbyscTLb1yuA4VNP7dXtEsEtN6uwrJJi0dHn11/WUYS65pW?=
 =?us-ascii?Q?P0v4YmrH+Se2v8R83aKyD5WuJMRcPYfRKcrJKZKFjxvSuXKUZ7f8N3LhQ3UE?=
 =?us-ascii?Q?kTbwd+LEmAEdjHSx7AtGDokvgcVbOmJhXICBgU5oxKFaQVJb5jgGKJ0ODNvr?=
 =?us-ascii?Q?YX+xTu1J683ucTxb6+5QFUXPqKuJEF9ZKv+n6C2KLCpnIJYqZev97M6kTHDp?=
 =?us-ascii?Q?6K2YjmmbvA1s5JwgU5w+k/gFT23bUebcXQ25aaoJ272hyXLcROLtZ2bBtiD9?=
 =?us-ascii?Q?TqCpuNq1cXH4Bm1/6xoKnq4IJ+VCecrWFJccv91sn1TUPrVFppHvzi2WIMV4?=
 =?us-ascii?Q?pEbvZ0xbgAsCOGjVPDukdnkmXXJ8ZqtgspDPNtr3aB0lemfvu10WlmPzx4cM?=
 =?us-ascii?Q?dfNGg85hoH5AtqkYVHY5bNs6g+gd2iv7mRNM/l7fIU9GGoqSABidJyYn7GlB?=
 =?us-ascii?Q?710443z/pbHZ2h6sg2AoLOzZPtHflOiVXASULNAGxC0lyspJIo2iFhnZcznw?=
 =?us-ascii?Q?QjDQ5OLaCsFrunUtUV+6wqWnAyIKKaZdpRF47gBTGXaHGwWKMDKkSe6kcJ1b?=
 =?us-ascii?Q?aEoAMP7UxIC32xa1Nn18ggdQX1mN0Bv5y5vQ59PH0xlKTfpQChl7ODPXEOWc?=
 =?us-ascii?Q?40bZUBkKZMZJnJ0pyZsGR3+1POh1gTIpV7U2/MjMchterGMNhrDDl7qBAQGS?=
 =?us-ascii?Q?YfsPUEVmCPZ/AcfT+AXDJ73f2DYfHWZ471spFG65PBwSnE8++snavjFvHQch?=
 =?us-ascii?Q?tsapSjhU/CcbKN0tp/lKuamr2hviFolQGFBCwaZ/fcaxIccvBazpDMp0bgsz?=
 =?us-ascii?Q?ISyRd+wn+J63lAq74QY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H1rCDZtcHMSV5b43+oJdmGiW2udUxc5odUAuS4y8j2BkKFQFNNL62gElzk2b?=
 =?us-ascii?Q?g6JtFywMOCgL2Uu170sPGAtLdDOHelloID05kt1SuJTl5iKzzdKTXQY4HyR2?=
 =?us-ascii?Q?F2UHitGr7OMiQl+g0sjRzqYgb8Awgju/VANniJ9+aBQRAHMk38tpYM+hPPhU?=
 =?us-ascii?Q?p7amR8l2/ShQKrNxQ4vEYx+ZXTpwe3pLYYXlb+a1WrKq+fM0cprYr2pf7GvL?=
 =?us-ascii?Q?pYtiW7eM96yLU2FP1rfPS93xuwU2fV8wqAIUAeSeseRoK5TS4QyTZfKw0lzg?=
 =?us-ascii?Q?RKxKWxMGf8GvmRNM7hHEhD7JRqpYQMmU4O77bg9xMALfvLD6JXtOGLWGzRK9?=
 =?us-ascii?Q?L1A9IGilx1Q57WlRgs/x+mtZTdB+BZ2yU2YSJ3/NKQ81JFvHEZT/rbLxNZ4P?=
 =?us-ascii?Q?qzz/CAH519Xh1eM7qHEBlDeroTgpVoia6gMjQqWr69f3GDayqMlq2ZXBVyr+?=
 =?us-ascii?Q?kilRJK9zqDFQNi2Pp5q2cNjTHs+deU6AsCVOQi8OgeB6GFKjqINNhvZBYF/A?=
 =?us-ascii?Q?0GelyggqEiiofIlRT4v6yfWBh5mnOSejqVTSPWSApuL3+9Q5fTPGsLe4f4Qa?=
 =?us-ascii?Q?QZxXYMdh6PJfP4OmUR+wQ1i3VrtQLppIH9W9aoJ16gC8hG855OxJyucrzhPs?=
 =?us-ascii?Q?IyERquDWoW5dks7ck8VGWRCy1poEsdTf8/b6gpKRwwfhrp/wIXoFGXtyzCWD?=
 =?us-ascii?Q?mIzeuXI9JlYPQXvyiA5YGkw56FdV9LbxHUHZ0fB56tMCrKLf7bGKtsaetc8E?=
 =?us-ascii?Q?jWqYezfYDllrwkxdiVpNPbqZjxWh0XZg6RYcuTePa09j9gwjDOPWezPH9yVF?=
 =?us-ascii?Q?OoX9F2Bhp9vTtBlDz6xC1h0VFqDXciv3yIZzvC/EwZexXPTferCcWBJXiLc+?=
 =?us-ascii?Q?QWEROKQxDjAcxnC/i4zBr7N+v81kAh0g4JNJbwWAzDQzmXEfrclPsfo1p+Bq?=
 =?us-ascii?Q?ZAI+mDoRSlwm4ApZ6bufPrWKB5d2BN0o2j7OCaOkIDcgdm2h/kyVRegVdYeM?=
 =?us-ascii?Q?jtw3QWSr0mvbbjBGiXT4+IBBKmmvFMK2lbX9C4ypqz+e0i8iOx6HsSbcFBUS?=
 =?us-ascii?Q?xX1/5SqZ+WOcmgJnapa3sbR+cAMQ9weECVrRIVHBzUvZ4BCpfooa1noWFzWp?=
 =?us-ascii?Q?U6hRwRHR/0FbVt2HQIf0mcSuGDxn4EyN51KFid7v5pWsBuy8dtR9dGw+nfy9?=
 =?us-ascii?Q?9YgNYS8L6aACmtCo9JzysMqMBpDbrOX1lLYtGpTv6poxPZIou34PuzIox0/N?=
 =?us-ascii?Q?pRza0S7HkaPRXGeSsKPv3MPt00xplr8MMsHWLsGR4ECCyW6XWWOxyyKKOJsV?=
 =?us-ascii?Q?lNsul93TvCLAE+ntVWATv6ZTiq81MK3dL6429HPYvNRkpG+ZBHuo7+VLQKNc?=
 =?us-ascii?Q?D/AlBu0W0VsHXF8fFXp155XvRE3CJtBazgmz14a7d1fMi/qjQ+VpdfxMS+Km?=
 =?us-ascii?Q?otBFtUNnw5IiisbF50aOSLa3DryhAn9tISoZCBjJL2GpDgXgtj7vsBmcBhNg?=
 =?us-ascii?Q?QjYSkcNRX6QxDbyc01jRtZ550ZiXwPM+BXTZTsK29UmZFKygjYe+/ssP5ycx?=
 =?us-ascii?Q?e+xZ6eyhIBZHcOQxdmFtoZsWWyeB8ksYDEx41keIiNQJ4VZAyFs6LJvjllz5?=
 =?us-ascii?Q?Xjg8AgC5GvNjYeJ3+1/ehqgz/dwpes36IUO91l4uN2B7WONacH1QwL6xN6VT?=
 =?us-ascii?Q?ds2L05AbPMVT+SJNca6rhXVmz0seI83h4bWdFamqpvl+/yekPHgGOfl+Pf8I?=
 =?us-ascii?Q?I8IPQur6iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tN0uh0m/9KzuuNTZxBfm+OyLuoja37F7xRpOsE0cIF1958UIbYre4BPXDDLm2gf6heN7ImrhGXfq4OZ8+ZckLfmduFQK9Z5AjVjH42lsUCZq+Yb8tkONa8D3RLnAVjkk5qg/BGwg8Ly7HXF3IR9VcPzXx8NSMCbfUMJSKEupV+9FikGprvoDZ1GFgeOmPMdD3d8B4+fukdcyu6vB7LimnJn61MqnDedOZZ2z8wRnK7GZU//4hwu2WHZJs1Lu/RFHrmCAijkFtOkCt1+T3KCr+pY/6uO3k03tLsOZSAWbB73qwizFBC5bx9VMH74NsaefadDbuP8Dvov47buJVNIxjHh1vOqQVZoFTllVmVYWuzZYdUCTop7NdrPxfD7gl8sONo74BOKOuI5mdacCkHgju6yh+vyk7swlhKEJ1EKn+t6fxsqPVwlrD16a/OqWz9vaWg4uPQxgaoWKAS05DFhXnR+rz3QkScX4wmjBDP1z36VTI6O42/d+zZLmTCcQnn5/7qrszeSoQdfguyjD1Md4XHcswtpwtFBEavCMtDJ3t+9B/m+RWpE37D0WLhdkkFRCmB7wZfZXTlWWr9ZZ+GUeFUgdgcIShfiZ20YI4j7Togw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afd32824-0cba-4d24-c379-08de58bb9b3b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 07:06:32.1426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4/icSye8CZ4AorelzG1fQoBupECZ5M9snFHT6iMhEZCrbXV4esyJkY9GsaOrv7Viyly26QqBOkzII4DVnmQ2Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6224
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_01,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210057
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=69707b01 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=ID6ng7r3AAAA:8 a=5jfoAYnut1TXzkjeaYsA:9 a=CjuIK1q_8ugA:10
 a=AkheI1RvQwOzcTXhi5f4:22 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDA1OCBTYWx0ZWRfX7GxetUF7gYZW
 Ut/BRac/8CKfQSLcetnGrfWS3mZsBCPtUDDlMjRQDXVNb4eMukInbvu8J4vOmnld1tukDxyendn
 BpqqJyR+6KU3O/hoHqNXRQ2CjbM2mDvV3Hu0tRySB6GfZRpztUD0N60umr/SBQt0XFL/U74QA3w
 xgyslSL6rEBjOzsrXd04jBw4ghNGRA88Nb7OKtSq/fhrbFDjVBguaVVm2rl9xiBFZsLa/AcIxqe
 bzduS44IPxYicxnVB9dflbsxw6M4l76yUX51tcKjUK6FYGbDPZd2R9FB7DbV8J+sojD34AFRa82
 cQT5/JRvyvtxF44ylvLQkDPJc12V2qP1APeiRBCele09IKIFtrt4eSqub0wddOaLqLQ9oYZJ97W
 L5+z2DMhhhSMiIOi5IXys925iIEUHkUKOR0mNMkY/8lrQrh+lzpRAGaoGMuU+yPY01/UY0avjqC
 w97IUnBJ5yBaKOz3I619QV697g35awPXViBRvF5E=
X-Proofpoint-ORIG-GUID: SclvJvKtTKvv1vD_Nk-nGumrmfzgDytu
X-Proofpoint-GUID: SclvJvKtTKvv1vD_Nk-nGumrmfzgDytu
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AB01320004
X-Stat-Signature: buza1tms9azhecuk63azhzonxuird8y3
X-Rspam-User: 
X-HE-Tag: 1768979208-860619
X-HE-Meta: U2FsdGVkX1/QD9tFj7LF1aefnBfP/Gh+UrxOCM06bfp7g8AatVerXtygAPhhLBbAUCeboaPTx/emndOhkY6xCZEPGxv1vGB4IJebvFRiNtaIenHMPCsNv8ZGdCyDmu9uDBssBeKfYnaN4yr9Wm9J6HtlXQKJnLSV1+uwfXRcDZdqbxcL8O4x5ARMg8SMWt1pKvt/G1lp6s16I4AU9DqSQCZtzTH9UmD/B5I8tldHojZaa9RmCqhEZqf3FGrqcG0K1ppMroVurV2gpWM7eQS9TlOKjaKESZ+VQyaJXzH52b/LrwfUkeRxc5/4Psgv3xXclhOV4yZVQf9VGu7+LBCNge9HqU/C1v5EL4l8s91TEv3YUFzRIb6tyPyd8J6vuC5TcMU59OlmE88hxxGqReH/2yd9XgKPJ4/EFie0+F+fOvNKRobthMPV0ahQqjjZuWGmkFOaEnR+Y33t4Fv1PcYoLQj5w4D86YYUNlPgLq07ZWQQOqBnbiTPuLqIbuGVG9EhONPMU1IHfRIMmLhvp8JOKf8oBXwr7eYC7VJiIR/0V9ckSe/d+SdJA47jLruQbYxWJ016/Atx+9OzLW6KrYv3Pb+XZDEq/904qaDF42XSNOmOJn5e/79cM+HZafnnSqQ3E+h1U/FEyOBQKnqJeE2c36JOr/U5w+UIck/On8Uh4JDucHrSSC34d4KrAjVLBxKXFMPFrhEPGx86PXix0XLI004fS+9vNyd/Vj39QwEEOlEqGwAXZs7t8DT+Q4vkNXCVGvjXKiUiheEdSS3Xo+o1vTSvWDD14n8EEUW4j5FUHlTT0CV2fVTF2E2FfQ0joqF1uSPUhp7nxnRr82aemwsO7JobWt5KOHat9MCVCDtdkbWRCVhBpw9FZy10FNJ6ksodCtAC6fz2/eG8rpJy3c/OmG5CWWpoyEAkh4nLLIXk4+LQ5fIN6ytS9x1AOQ5mhfip/6zO9qCFuDAs1irCMwk
 I2ZfPo3F
 IQmot6FSdeTsNL1DNXp2DHzjXm3AQA+N0t7L1yoxr+XOqtZdQDRA1AEsnb0ZN81jVqxZiklmjJai5dRer5RNx+Wz3wqQrjRkmutNC0a3u9mjqNC1b0U8YXDKdISF1uT8RVRYTfnWHNp/TIz2No0BjfqlfOscp3uFr4b/q7QQTz3aL5CXZUjRyiBMift/Nodl3kVHeT9Xmdwe18s1QSBBGM7GRMBUIRTdFcsctDrV1zllmlrHJdbcK6gG9tL4SZCVJY7rjBbfAPVn8ncpdsfJq6bN/eck0/sM0hoq5Rlm3PjiJ3DGSlcpL5SbegpXfKrxx1WzcyHOrhNmVJ1O6/koUDgtnhLhbfO2XV7TbQ+YCJDqh0i4ztsoqRjLgtqSsIqFD6Ts6qKQL25UDJ50pF05pQ8rbEPec+tV/X1t3n2CNor7Bjlo+wLICXm1HXi11tW//fvmB+ArAT+YqiSb7UKmyMk7wV3J9Sfcr9zYMj3spnry3I2iDqSIuN3Wdsj3mrhv09ZmdneBWNiUu0rAZWG24DBDx/SSMx82LiuByNY0gcxDFnHJbiH1PIOvRgdGvi6cnxJg0ez0nLMtGPHHpvQFCwJtJMylDbpIPDK/B4OhxZuVdgf6egsuYpmxzXSGubMp+BwwRcKZzKdqEKBZiUyPOUlSvuOvY6xT91h0UlndS3phahOTURYKXVcFU1Rb7iB8sXXBnuOcQw9Cfm5RIIzoT+6qJYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 09:41:14PM -0800, Paul E. McKenney wrote:
> Hello, Vlastimil,
> 
> On the off-chance that this is useful new news.  This happened in
> rcutorture's TREE04 scenario running with KCSAN and lockdep enabled.
> 
> Thoughts?
> 
> 						Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> [  253.872153] =============================
> [  253.872271] [ BUG: Invalid wait context ]
> [  253.872271] 6.19.0-rc6-next-20260120 #21508 Not tainted
> [  253.875774] -----------------------------
> [  253.877983] migration/1/23 is trying to lock:
> [  253.877983] ffff8afd01054e98 (&barn->lock){..-.}-{3:3}, at: barn_get_empty_sheaf+0x1d/0xb0
> [  253.877983] other info that might help us debug this:
> [  253.877983] context-{5:5}
> [  253.877983] 3 locks held by migration/1/23:
> [  253.877983]  #0: ffff8afd01fd89a8 (&p->pi_lock){-.-.}-{2:2}, at: __balance_push_cpu_stop+0x3f/0x200
> [  253.877983]  #1: ffffffff9f15c5c8 (rcu_read_lock){....}-{1:3}, at: cpuset_cpus_allowed_fallback+0x27/0x250
> [  253.877983]  #2: ffff8afd1f470be0 ((local_lock_t *)&pcs->lock){+.+.}-{3:3}, at: __kfree_rcu_sheaf+0x52/0x3d0
> [  253.877983] stack backtrace:
> [  253.877983] CPU: 1 UID: 0 PID: 23 Comm: migration/1 Not tainted 6.19.0-rc6-next-20260120 #21508 PREEMPTLAZY
> [  253.877983] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> [  253.877983] Stopper: __balance_push_cpu_stop+0x0/0x200 <- balance_push+0x118/0x170
> [  253.877983] Call Trace:
> [  253.877983]  <TASK>
> [  253.877983]  __dump_stack+0x22/0x30
> [  253.877983]  dump_stack_lvl+0x60/0x80
> [  253.877983]  dump_stack+0x19/0x24
> [  253.877983]  __lock_acquire+0xd3a/0x28e0
> [  253.877983]  ? __lock_acquire+0x5a9/0x28e0
> [  253.877983]  ? __lock_acquire+0x5a9/0x28e0
> [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> [  253.877983]  lock_acquire+0xc3/0x270
> [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> [  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
> [  253.877983]  _raw_spin_lock_irqsave+0x47/0x70
> [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> [  253.877983]  barn_get_empty_sheaf+0x1d/0xb0
> [  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
> [  253.877983]  __kfree_rcu_sheaf+0x19f/0x3d0
> [  253.877983]  kvfree_call_rcu+0xaf/0x390
> [  253.877983]  set_cpus_allowed_force+0xc8/0xf0

set_cpus_allowed_force() is calling kfree_rcu() with a raw spinlock
(pi_lock) held, but barn->lock is normal spinlock, lockdep prints an
error because on PREEMPT_RT normal spinlocks are converted to
sleeping locks but raw spinlocks are not.

Hmm... but it isn't great to convert barn->lock to
a raw spinlock just because of this?

> [  253.877983]  ? cpuset_cpus_allowed_fallback+0x27/0x250
> [  253.877983]  cpuset_cpus_allowed_fallback+0x15d/0x250
> [  253.877983]  select_fallback_rq+0x1d8/0x250
> [  253.877983]  ? __pfx___balance_push_cpu_stop+0x10/0x10
> [  253.877983]  __balance_push_cpu_stop+0x4f/0x200
> [  253.877983]  cpu_stopper_thread+0x147/0x210
> [  253.877983]  ? __pfx_cpu_stopper_thread+0x10/0x10
> [  253.877983]  smpboot_thread_fn+0x24c/0x390
> [  253.877983]  ? __pfx_smpboot_thread_fn+0x10/0x10
> [  253.877983]  kthread+0x1fa/0x230
> [  253.877983]  ? __pfx_smpboot_thread_fn+0x10/0x10
> [  253.877983]  ? __pfx_kthread+0x10/0x10
> [  253.877983]  ret_from_fork+0x157/0x2c0
> [  253.877983]  ? __pfx_kthread+0x10/0x10
> [  253.877983]  ret_from_fork_asm+0x1a/0x30
> [  253.877983]  </TASK>

-- 
Cheers,
Harry / Hyeonggon

