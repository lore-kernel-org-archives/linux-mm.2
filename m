Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63464F55451
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 06:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81DB86B0088; Thu, 26 Feb 2026 01:53:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CAF76B0089; Thu, 26 Feb 2026 01:53:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658136B008A; Thu, 26 Feb 2026 01:53:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA606B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 01:53:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E84F61A09DF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:53:11 +0000 (UTC)
X-FDA: 84485690982.21.FBC0420
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7723C160003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:53:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HDSN+eMZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wZ+3fQCo;
	spf=pass (imf08.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772088788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ZAGN6xGWg6H9wls/+zaNREBk5S5mEQuIBtF3xVUNLQ=;
	b=PtU/h67bwou9iVvvcgfONdkrR7HHF/2CCiCcOeefwZ4KGUoubOctDEICgFWBcFuKKnG2rW
	vZWQ2lKTUDLS1D5CMojtWtsU/0NDeQbGb/LLYeZ95Gg5tHWJdsgaglxZqzRaTWEh+1PBXe
	cLTlgPoa2AdETnWHHPtTjpnU/breOb4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772088788; a=rsa-sha256;
	cv=pass;
	b=ojZ11BXMZ6/RokFH/bGtEsRdiaqA50XI9k2L32tDq8J0Oe4vi0SL4C+rwO4uwU+9dNC5up
	Sq11ygtUKNhW247hf5ZTcQTvvuxKZYOrO5/glaXmuyjhNHACwSb2V+aYy+AL2WdZitMVX+
	ouS8Om8uHoMCpS1YON5WHsrfBhpyppw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HDSN+eMZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wZ+3fQCo;
	spf=pass (imf08.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PNvEgx3554615;
	Thu, 26 Feb 2026 06:52:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8ZAGN6xGWg6H9wls/+
	zaNREBk5S5mEQuIBtF3xVUNLQ=; b=HDSN+eMZtKWeRpPxRZ6KlkCwLjeKoY976m
	HqslIlPoGwIumzUsuS37XYyAZrYk9vKJg9lZEqrjYD8D6Fxuaw6fsz44CrDziYR3
	1ppYc1asIpgaMtNs7r9F4YK+mlaqJnMP5xuVGcfN91PsP+TEHISJ5tScCUmeiMeQ
	CvxKA0a7Auw3+M+Tu0xAB+ZBUK6wVZjccq/9UlYqkCaXM54oGRtO6yD+4ERvPeZH
	M82th0WuyUEbiccxKEqDbaBU9rBx6pUL63eZwmO/+t/zcIuumn5P7UHpT0Y/22Ec
	hD3Q7Czqmu0flVQJ4aHpB6pQk4wltqtg1wPQx2cQmOAveNl4FsCA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3m7yq9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 06:52:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61Q5u01u027842;
	Thu, 26 Feb 2026 06:52:40 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012029.outbound.protection.outlook.com [40.93.195.29])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35h4vg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 06:52:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ND5eK34MxtFN3elCXW2eqtQtDMReIP+3b/ZrpiT1ET3Zd3Dk6tiFY2yvozDZ1g8JydcMn44w6XRthLnUGl177SCkSC407YtQUV8U0GJ8AU/b58TgemqxHd6OrBLxzmvFJmiRcNj2qvI0HLlL/ljCgYtUKFoaKY0YNgJE/Kq/4W3+SwoUa+da0OsnPbG/JGPIAD2r8F7QHmpKsp7liPokZRslUlX5uHxPFjQsKIxzSi37Dr/FIuc2h+48bogp0L9HXEzLS3sGWpayYCan94M/cDoui46I6F50a71B3EtB79SAHVNX5eNg5wo0Rtfq5Y1jAzsWDOIsmzH8xAEFoIp2KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ZAGN6xGWg6H9wls/+zaNREBk5S5mEQuIBtF3xVUNLQ=;
 b=jQ5M0op2oCD6TSEa0TuWTT6HaRcChhYMAy5xFr479aI4fxP5wGzYtvy97XFAXf/Xovg3YEnMFHorB7XRbAtOI64x0EyPuKHcypKjzKg8OONkTe7khyi12rGlAc41NpoxACDiKWFNj9iI6kq37jsZnPHRY8Y77EDNtlpt30WlJcgmPFCv/AcXdmBQ/7b6Bq2e59UZl8QAappp4yp5/u6J3mns1nn3Rv4qvl+/nsiECd6dPGsN4TMmEQPr0zyR7wmd78xBwwCAAm6UwmFnx6G5547wDq5m/f3nQ8gNuJZ3jZc3uggeHvaAPJyIx4SjYlmvEhfzWp1JpXrdybw9W2dP1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZAGN6xGWg6H9wls/+zaNREBk5S5mEQuIBtF3xVUNLQ=;
 b=wZ+3fQCoM/mht4K7MJvzUfvWd8NrlfieTa6f9C1jak9f0HXj9ieko+DxwQMkKw1axzXpwKKmChh0qbhsPrh5cxZAc/MxmQ8sFLAMoehNUnIIkdxv6uBer6b99z5aWYjP7Vy3PDOmLVMV1NZhI9UK2IhC7F1qyrEyCX2WPoIXJIQ=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA1PR10MB7237.namprd10.prod.outlook.com (2603:10b6:208:3f7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 06:52:37 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 06:52:37 +0000
References: <20260225092628.11687-1-lizhe.67@bytedance.com>
 <cc08424a-22d9-422c-90dd-54893bda1213@arm.com>
 <aZ75ydx-FKaFvygT@casper.infradead.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Dev Jain <dev.jain@arm.com>, Li Zhe <lizhe.67@bytedance.com>,
        akpm@linux-foundation.org, david@kernel.org,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        ankur.a.arora@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Avoid calling folio_page() with an out-of-bounds index
In-reply-to: <aZ75ydx-FKaFvygT@casper.infradead.org>
Date: Wed, 25 Feb 2026 22:52:19 -0800
Message-ID: <87fr6oxaho.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0217.namprd03.prod.outlook.com
 (2603:10b6:303:b9::12) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA1PR10MB7237:EE_
X-MS-Office365-Filtering-Correlation-Id: 841d4ef1-0ca0-4c00-4f43-08de75039f5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	jOmpgAn+OICnmzd5rWlbIwM8jV9eqanTjk/XBdcQJe8oR3Ba6dWhpasvR5rC9lLVBrtZqzH6eeXg00ubX5e4hovacbjMii7pMn3Hec9Eyyp06qxLhcoQAd/jSZtNcH1Z1kQJIh8jV8gGHiNg1cras8eFujV31Jdqi+2Ds08R2scI4vcJnl5DNcNQXAxpD27cGP6YGyqt1/czjqFQSA1OtkE5I/XYE+K1xaEndlj5rLenat9VL0YMAKkpxelmOL2cy5yEG5OzcYrYAhTqzfuEI80wpRlVrmIVOiuPMrw1xnOoxhG23YwJNY3rhI2WhNXoN1OQq2hWQ4RWCFhIA/v3hVMigGxjJmuZqBTxarNA9T2X1gEvg3r3evNjwDgTPcb+JZ9qpbkDaVK3vCJjUNM8yVWpF0Yg8MG/Fykcc4/bCWZ0TISrhZsGM0gLWI0nIgA4k83ngF1oEB0/71LrfH/XCnSWQ1fqOdlG5nEFPM1AcqLexKaCWmPHOKZijC7Opnk3E8YzUJcQiBKnvMTuiJ0/p+EHo0gghPe5og01jPuViokSRlxdJgb2g8mEZ7cSsna4/WBOKMvT4w615PwUzzjSDBbIuYvWuHuWmE7J5R5d+Q2aRpk407lSPi0v8TMoRlqlY5Y347u5ZzqlZZU2aQXdUZXzLS0MT6SIvVVD+q6I5gQx6CF+6uBU737B72/oKV8cCaKywUFhrnBBhf1+SzQXbNNFJnJjnxMpL1MrAfHLQ4k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?57gq6JM20cCePKsxwXo++xY9NN4nnbIDwBU/dNckaik214TCHRGu2mTqdoIi?=
 =?us-ascii?Q?0mfUCp2vSQmt/5zVCAi+aBd7Dkdj9Z69vsQPq6u44YmSJb6lEDHtpVOiegy8?=
 =?us-ascii?Q?CVj9fYbyUCapY7gfcgjFxNJQq+rNe2Cz0mqIW/KVCu7RAlbmiqycf1DWwGuE?=
 =?us-ascii?Q?7YpszjntTKt6EdVKbuBaJY/bsIA5VNtJj7vyTxv0LsKzAj4rmNTeu0b4td5G?=
 =?us-ascii?Q?Mx+f2Sd75OgFaPkHhI8vucG/fNoiN1yaOe8EOXyKiJ4UYU/u07CpEVwfBnm/?=
 =?us-ascii?Q?jy8g493owgX6DhJe73QjHYdE9Z2ybT3Ah73t7DKO2j1dW+af/oqgbI1vEVyo?=
 =?us-ascii?Q?AGyrAYMs8i2VthelvPtC2tM+r1iNdy0tKgB+H0x6IYPT8ofWLoYS6RiCyAK7?=
 =?us-ascii?Q?nmIsdU3iaISJFV2VckRTljFeuPYEpxswX9vfJ6E+5zDpYlAJbXiTdNGqzzhc?=
 =?us-ascii?Q?Rkt28zcEr/SHTOaR8o8CuOYelGsIcsBdMaSYtYRlvhOoT6BmVpyWdCc+yrwx?=
 =?us-ascii?Q?+xjR/6L4ACiEtyrVLiYmNQtD/WawmK2m2UFKZn09CZHuj/5u27HkUK+giI8+?=
 =?us-ascii?Q?S6z4jfpcaC+sjx2rVN0N7RX3ybSrOL+fkfjD91x92uf9vLQ1ql/Ix9AA4bQC?=
 =?us-ascii?Q?DrM9FMRBhZT1Lw/DOdICpQOYG6kRwPL712v50Q9u/i+BxvGFhQw5dnk+0Pyv?=
 =?us-ascii?Q?N4VY3ohtwwbgxKn/YnR/m4k+c1bjhIdEaylVSNPwY1HmunBSVEmGNOet58oS?=
 =?us-ascii?Q?51jtFJUlpRCec2wQJoDODJNcPI+qYtR6f99uSzhAubN3XVX0A15Z+8jdmYYD?=
 =?us-ascii?Q?Npw4bkr4/87thWbKmrtxfz8cgJROPOWcNoy0rT3lZtIkZGmZ2Ym5BiarIFKy?=
 =?us-ascii?Q?XhQekvchbdLZtOesD+H0nQQ7HW8PJVRtOcsejBSxMvH9UMC6jd7tL3wWhBcA?=
 =?us-ascii?Q?pMW3ByypTEYy4hJSLA+2IV/ZoF+psvSO/MTgGcHg4QkZsFUPjLHuwkKDzY+c?=
 =?us-ascii?Q?zCt2dI6um72kvKYmB5aogVXLQ8QIbu1jr7m35Y7x27/t5So8+B3e1jMZgiG1?=
 =?us-ascii?Q?itdcBmgfdapzVUt4RJvCgXvyhU5bDzuIYanY2Jx+25wh4gvfUqIfF4sflDzX?=
 =?us-ascii?Q?mvUa3/gdGaHYdw1R+U6Sh55ERuVjjJxFlgMk/9xvK+dRF6lXqH/l9mdwYbmm?=
 =?us-ascii?Q?Sl/gIraycZ+NuKlaqdl8xpjBGm7prejcSyFiV99K4bZcKrHqBFnuwX3gyJTg?=
 =?us-ascii?Q?UDbbMqArzObHE2//CPCNwGs3f77Dl8imGu2T6le+mbgvCyXEgZjdJ+G/gNJr?=
 =?us-ascii?Q?4mCwEwKl7dvKgfUjqawUI94EGvJRG53YbPozEfl74nJ1WagRU+2hHUaYFYqK?=
 =?us-ascii?Q?fmjV1L0bRp/vqi+KgW5qGX1VrU1TxgGOIHF44TisP3JqKlOXtQ59q2uANYGQ?=
 =?us-ascii?Q?I1+xBBPeDJ9peQunc/dp2lPJwy87vKviwhGUSrOtDIRibQDscRbWpWqKgYTZ?=
 =?us-ascii?Q?mrjlPKo3Xi61wPTpiwGmdKjJFjC9CsYVnCqpC/EYGJvUfkZ+INJ1fVqzcVr/?=
 =?us-ascii?Q?z8EzpjPsKH0CP/gz46jslKhHgh57yNZrbQXMECLfGHVn37ApjJQttqdZuucz?=
 =?us-ascii?Q?CnN/oOK9VzAYTgAIPivP4745/qd68FkJe+TKQw5KcMy8Rwfi4oo2TRsJlWBZ?=
 =?us-ascii?Q?eC12CA8m3dAmrpY1MfkvWrYKjbjp25G++P1S/8g2oGqBffxkABFEgWUzFZfd?=
 =?us-ascii?Q?2RfuV5bVvtd2UEHEpYVKDLC0stEuNqA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	12pxhykeC4zo87eLGa0gfbPKscyTXgTxVz2cS41qDYerxn+xNsZkl2BiE2zPRc7hD1tu96nwst9A1m1m07zXMORPentpA8NWWJGaGSq4Z+Ku+PPA9dRC14N4zv1feAFLY5y2mEuPVgH/iMBiMyOMKIaPi9iZ2nN52kKTLXh/l76xNPVWwGWWahJvK0d2RDsaHgtm03kWbsSt9kmzAZfn3BR25E1dF9q3dot+g6YkgX+jP34PR2y0VOtbqlLPEcJBMavO8fuhyFtzoWoqdXgBTaA8Uuv93XDV1UNgvgcJvZTPTSQ3jwJNj+n77xQZQJv9ACeKQX2nhif8Eo7n2cXmBv/WfpFIl1yORXZipMLWCqxXUL1Vb/2sUj2u9le0Q8Dh9TSYTyP3mH6qwcYRS4lsFA5DufDXi5SArGX77WulotDFANpA9QnglwiGL8Ghn63TeVDwkXTmE4QtjYFgAHj0FqsSimYUenZSXufuTLjUlb3/V3IxIq+WDZnl1DR0sB4tXzoBms6p3cZcOWmJYq0KncFO2aRMGSDZ5u7BsXa0dQVFDJkuzjrVlMyzbuZlIgpQxhT9E4XumitN27Az67hlDvRA1pZ04N2bK6hxgseeMM4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 841d4ef1-0ca0-4c00-4f43-08de75039f5b
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 06:52:37.6155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVK0ub+ynjPd4DBJcecQtmGdleKLFjlAYRipZXOJrWG3na8PvsWc1u/W3Jc3+5nyJR4H16MEji4DPN1eXYxQ25Jkc1/DrXeH7Dz0BOwlGp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7237
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602260059
X-Authority-Analysis: v=2.4 cv=O5U0fR9W c=1 sm=1 tr=0 ts=699fedba b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=JfrnYn6hAAAA:8 a=968KyxNXAAAA:8
 a=UrCK0kgjsPgamLM0ntgA:9 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12262
X-Proofpoint-GUID: V_rL5pDFKNYXPj5ILvvJLKVRJ0gNfadh
X-Proofpoint-ORIG-GUID: V_rL5pDFKNYXPj5ILvvJLKVRJ0gNfadh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDA2MCBTYWx0ZWRfX8w4eOIFbiIws
 q3djKHkd1s8cmxaZOlO28MmIw8gaA6haFNMAzahXNIttb1Krhri0mgdu/ErpAGGJD6Fz1vkGZwG
 gD26sBoKVwBcgXGN7djA/M3eQ9UXsJ+44c4ZMOPZ1/rYYGhKBy0+q4et+Jfnv8az4Uj7Y4cph9C
 928yqame/6aN6fgaZwsAKZ906qOa062Rpt1Di1qV3SdbQtbOdJzLYFo8UWI4rmar3Frpif0kP/+
 DEKhy2oMcMvVJb/tKXBID/koK1aTdS4CVUId1o6QWTjefxDdG8FtB/KsyzlJyDOmwPIUlzn4xbQ
 quMMiNlUSTXFy0ewpjTQfV6K5Wknz3wDwe+mX85LcnGKfGsWttZqqyDHiSl8xIEY7x2ly+EoHtn
 LNCBkw0qmDjgMNiW2DujyUizQd+GuZphBtH8QDFu3NmrJPRdIe+/t5HU1ckphQrLDutia0mPUwW
 AzKV43ZyFygo3UbgcSmcsD7vnCxP/P97Zigrqv6k=
X-Rspamd-Queue-Id: 7723C160003
X-Stat-Signature: 69j1ghtobqscmod1bibp8q7rnz4tysra
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772088788-896624
X-HE-Meta: U2FsdGVkX1/Sgz5Almvxtw9xrUG3/xfKrr+ciUGz9ZzNMVcYKcLmF03xuHSFhlvq0ypNtkmT9WihhsI3EMZHh0/Uck8TpHBkYdTmWvnLlfmtoMnngBYxfPuwz5xG1HvENvbzrnSWUEwgyek4PTx+hmfcSjQCU7HIyfOqq97nMZOWQnxrooduVqDawiDvOSPcVUYRDZXHkt7OjIIZE6KHCU7jBW0pWBxAttH/9LyyoerJqISS2PHmuHZeajtR8saERvmNVH7lUdBE8Y5btKXGXZALUbXJjVbGfYfkbmPKUNH/m+vKNi9qQvdLXTQNQhqI3IlGUeJtgzudFlBKJSTr7RlnNNpK4IlzsxoZOJSLkbN/plqKuggOFZydDsUMdeZ8ZpyfLt4Z9QA/QaWHG0TFNdWIf/Wti2c51CCFamNYQA5Zy9JzIVKl7LUbUnl93Jpz44vJ7ZeCm4aLXoP2gSFvMMIIYP//m1+fgHoRiHpRIrL94ta21oX03hg/a7fHlmRvp63I63CDAvmCCWdfrVZGfXEYgckMhTTtTSjZTs4MQZ5WK6CTzY6oWfpZ6tPMQj5hBLXGwnKfuleIjapOMPMn5IuR90YaCT9xSvvAZJ+uhFGAHFHCICTOXZCOC0fQ5vEwyRd2+5zIp3SYHGPICcmD04rr2EiXRFmGw1fNVPvxPX3e7tH04yOPD6k2ZitSPCZegkalTkx8/UaTCVZYY11yB3JgVwj0SRMjB32sBxx0HnxaFas545Q10+sVj7HhrAXFUgTnY5f9arugcuRP6yi9ygJgIPk26RuP9TYfVFFtsvww5P1vKWQcMKRBtj206kESUWN/GQlvC5u72eXgZeqZ1o/7o3T2q6zTo3LlVUH5/R5js/fBmY4PhGh2kw24d7Pr2b0mIIucP9z+se6+bUiXKonyYh6hU21ZNdxyK6BlYMMEJykhmLcJ56cGZtxtPzKL+EWRCam4f0aUbgTCDjf
 hTyzueLL
 3dPVOVmvzqMvpiX+1kWRwlwkIwylNpXXyhuwibpbEjJFD67NafMc5o2a4d2f3tW/PaZ8JbaDokztlcfATWfYh5vZEX/YMinkP03xRFKfhf0oHEFaT+c5J15BKB/Mpr0gyKJCDg+5n+l4Zqs/9e8ws9eiFRozwIRXavuJHllhjTdX8ESsV/3PxhesuDnHxdz2Vz/Zfou7tc0pAcQi90y0W+zZrbsYbcgL7QA3aK1MvDpqYpYIEAKLEz6lE/d4oi+5KQFvtxw9bsRYpS26tjf1rLqVbO2YlvHhuSFCCuVPUoe9zNQdl2F1kcIok0zjCxj8SJw2F2Y7iUrt/UReE/CjqYmz5v1YQjvpcqycINt2p2gLuJiT5/Cs+F/jfvN2H+r1AnvxLcEMRaPH8m97cg3SGhwkQUBPDevc/2W/HF+vStJnO8WrKUyOaRt8mBA7GiKYGS/5dbzn0uG+HAtDRBgyAER3Vh3SPD7wfEkJ6p0HojqcSPBueRJ0d0NEYxkla1JbCXXVWA7m58m5Kn6TE2jLPEe0yhPZ1h1DfGN+NPA+gcZUA3bSRsXLIXBpL84FQcse8WGZeyGMQRCwZlM5jPbDyuhCcr6EtrkuIX+xQXWdPJdn+6KDHnNFcako2ipQllzZd4Vi7WZDDCTHv6BW8EQCN1BY4fXIN1KY94iJo0Bj64LjVdOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Matthew Wilcox <willy@infradead.org> writes:

> On Wed, Feb 25, 2026 at 03:35:32PM +0530, Dev Jain wrote:
>> On 25/02/26 2:56 pm, Li Zhe wrote:
>> > In folio_zero_user(), the page pointer is calculated via folio_page()
>> > before checking if the number of pages to be cleared is greater than zero.
>> > Furthermore, folio_page() does not verify that the page number lies
>> > within folio.
>> >
>> > When 'addr_hint' is near the end of a large folio, the range 'r[0]'
>> > represents an empty interval. In this scenario, 'nr_pages' will be
>> > calculated as 0 and 'r[0].start' can be an index that is out-of-bounds
>> > for folio_page(). The code unconditionally calls folio_page() on a wrong
>> > index, even though the subsequent clearing logic is correctly skipped.
>> >
>> > While this does not cause a functional bug today, calculating a page
>> > pointer for an out-of-bounds index is logically unsound and fragile. It
>> > could pose a risk for future refactoring or trigger warnings from static
>> > analysis tools.
>> >
>> > To fix this, move the call to folio_page() inside the 'if (nr_pages > 0)'
>> > block. This ensures that the page pointer is only calculated when it is
>> > actually needed for a valid, non-empty range of pages, thus making the code
>> > more robust and logically correct.
>> >
>> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> > ---
>>
>> Not only the correctness, but even from a perf PoV (folio_zero_user is a
>> hot path) it may make sense to initialize the variable only when required.
>
> But now calculating 'addr' and 'page' is dependent on calculating
> nr_pages instead of being an independent calculation.  I'd be *VERY*

And the "nr_pages > 0" branch is determined by user space (in the
page fault case) so we likely will get a branch-miss there.

> wary of saying this is a performance win without actually measuring it.
> CPUs are far more complex than you seem to realise (which is ironic,
> given your employer).
>
> Now, maybe the compiler is smart enough to realise there isn't a real
> dependency and it can hoist the calculation out of the 'if'.  But then
> what have we achieved with this patch?
>
> Honestly, I think this patch is worthless and would not include it.
>
>>
>>
>> >  mm/memory.c | 8 +++++---
>> >  1 file changed, 5 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/mm/memory.c b/mm/memory.c
>> > index 07778814b4a8..6f8c55d604b5 100644
>> > --- a/mm/memory.c
>> > +++ b/mm/memory.c
>> > @@ -7343,12 +7343,14 @@ void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>> >  	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);
>> >
>> >  	for (i = 0; i < ARRAY_SIZE(r); i++) {
>> > -		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
>> >  		const long nr_pages = (long)range_len(&r[i]);
>> > -		struct page *page = folio_page(folio, r[i].start);
>> >
>> > -		if (nr_pages > 0)
>> > +		if (nr_pages > 0) {
>> > +			const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
>> > +			struct page *page = folio_page(folio, r[i].start);
>> > +
>> >  			clear_contig_highpages(page, addr, nr_pages);
>> > +		}
>> >  	}
>> >  }
>> >
>>
>>


--
ankur

