Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160FFC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 08:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC54E8E0003; Fri, 25 Jul 2025 04:30:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9CFD8E0001; Fri, 25 Jul 2025 04:30:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964D38E0003; Fri, 25 Jul 2025 04:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 843A58E0001
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:30:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33203BAAC1
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:30:40 +0000 (UTC)
X-FDA: 83702115840.27.5C81F67
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id A99F240005
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:30:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KP08MjGG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rK8RT7T7;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753432236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RtTS05p+YOb3WVN0Zx40SyHHdpaKJTu5hzc+vrbKmLA=;
	b=IiJ8fUiz1b1c6aOtI8ngTYGIvsNYduQUmiXfjYEgD/40ASQzKGP8f7VHVR+4XS4ZZOMILf
	W2z/zd6T6krPTuk3Zug4EuJ9MlKouMT3qkN1OcH1aPGmcWR+gADXd3Afeso+VsW33DkO8K
	8l/Lu6M8pVNOxsDFfLwJkvVPAOvOVYs=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KP08MjGG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rK8RT7T7;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753432236; a=rsa-sha256;
	cv=pass;
	b=ACUrP+PKAVQUCMbye8oxO1b9O5HNIge3gmiZs7y6lHdaBzRZS1dNuFWzbhsIjjIaUihoAv
	4j2sj0yA02Yi9by2aldVNv/5jk1ZGKMma73vp0r4hkklLW2iY1ORIb723bWK/FlOLfKbBQ
	PozfqJLopcbV8AV9n+GStRvofrU1Wb0=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56P7fpbj013036;
	Fri, 25 Jul 2025 08:30:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RtTS05p+YOb3WVN0Zx40SyHHdpaKJTu5hzc+vrbKmLA=; b=
	KP08MjGGb8RHqE0LjaWKI2XECnKK0IQxk03fdGSUYVpx4V1yxqhnBECVwIejAjFN
	DgADPyIeZLpTb3mjG9ub0ZNzSF9RbP/HK3aprjh6Y+sWAOKONgxIj21teQAuVsiu
	93cXU76mwLSHDAZVTaXixLp0Crbf/NBv/sPKNfkeyJU1+37LDv5WcWFJV+CfoxCe
	Mx72OocO+/liIrSOiTn4GlIp0GJwViC/d2fST8boyl3y1/pzrGGVe6of+2DOo3Gd
	JTwUcNALWABx9IV6o/hKoTtIFly0CtwWql8SBdEDNV/98QSb2WZxU+xr0rcv0aWF
	yBjuaos6tTBoa+Xa1pV77w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w3wgm8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 08:30:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P6Gwkn011395;
	Fri, 25 Jul 2025 08:30:25 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013061.outbound.protection.outlook.com [40.93.201.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tcsj6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 08:30:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y6X8rbo+Yx0lDvZZZ8AsAikQa1OQkZy6DIp+Sy8mVEhlC+dPbmo76i77pNXsy1SGkrysk+tf3OgjDDxfW3TNGIXShRvbBQHVuB3DGOUZDvJTFcJpwXIvddxvylJGg6Bo8oEdyBdTSRZg4tnzqBf0ihRgc95EOlo/SShNYlFPANKypX1Dy72aHd2YAL9D6apkckvJUYaCBPgyYv9boLE0VzpoPpIWGHLMkd4IAwbM27frUdC2RQAiPTfNsY7j322ihqrcVtAH712Jy/gqPbEAwO3yb/Ni6iv5kK3Pv2XqygcqHnrt4ssjuQkiG9IkkA6RN35xwlU1/kmqmNqlbu+koQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RtTS05p+YOb3WVN0Zx40SyHHdpaKJTu5hzc+vrbKmLA=;
 b=WF9UkNL0b/Odnnn1ASYXWUnY4ps+fCCrwiMc5zfjAw315Vz8IkuaoFBxfqACaRzZQ1hzy9o9KR/4lL3r/NHH117iICjhhj+mcHRuGM3TB9Uph2Hoi1t0hS+nnfpfmxw6OtF3bUCsIGS3OMktes0U1jy2QlF91mNUiLn/tEw96EH+mLZho5b/AqW0b/IjZw2QxPgcvIZ22762C9BtEL3b+34a1FIbSc4nNBgrtKQ51c3AqM8kfWSmhsc4kZqEwH99ojM/RTluK89KaN0R0aWj2bFcnO6OZMCfKtj/wlOFmSPhYkBrVQ8CdA9fmqunCbqPcIsDoP18lucVqPZJK0rheQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtTS05p+YOb3WVN0Zx40SyHHdpaKJTu5hzc+vrbKmLA=;
 b=rK8RT7T7TQGqLPfp7Kq8Gcfd+NGc0NlQYkNu+tkWfVFoDw/A1sGHarQBzc2GHY0y16v8+e2OS5HbnQDo0X+So45kaPsx2tdjOWeQ4pHhZYRt9RdX6l0BaU1hF4UgaBzq1aDB0KjLF67Dgfia4SW5rfSpKqFiDP0yIbut6PNYfxA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4717.namprd10.prod.outlook.com (2603:10b6:a03:2ac::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 08:30:23 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Fri, 25 Jul 2025
 08:30:23 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jeff Xu <jeffxu@chromium.org>, Kees Cook <kees@kernel.org>
Subject: [PATCH v4 4/5] mm/mseal: simplify and rename VMA gap check
Date: Fri, 25 Jul 2025 09:29:44 +0100
Message-ID: <dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0656.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dea34f5-e6b1-4501-3bb6-08ddcb557f87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ehrh18IjOcgAd6u6QOED7KKx9z5cvqysHkTjWFHjqeQVbSOXjF8KZnqNg2kR?=
 =?us-ascii?Q?xxRCh6gxjrd2pg6NvqW0/mNifwRV52b3K4Jymxldf1GMA4NhT1ys0etarJ7z?=
 =?us-ascii?Q?X1noO7KbDWexIUWK5Yg06GhDUWUQrjmO51BUIMLMVh0Bhm3CmngbHzJB/QNl?=
 =?us-ascii?Q?Iwrqnx8yDQbh5ijNAG40vglm2Tje6v2Mg083DlYRjc5X0aXm0UZPH8mffZJw?=
 =?us-ascii?Q?L9Rmpb3oxDGJwa52Z4ek8S8f3ynfzkzQSyzzpy9gRzng9fhXShgIcDSVCSVM?=
 =?us-ascii?Q?9RxflSTlpteK6Jig9lZXkZfUFyCjZVLUPChOvHepa4K+06yVru/cRYD2ekBU?=
 =?us-ascii?Q?X72E3GlS4LTzz+arOTtiGBeQ/IhOym6i0XJae0qmJXgpVP3phCDCeuO8aBA+?=
 =?us-ascii?Q?78F6OPqFHx8uafmnrouy+t/7CFE8oOgyV3vMDV+ESOMbqSGtx0jNU8v/qmnI?=
 =?us-ascii?Q?J5qmTuEih+hxgdP/LfN6EcMd1Mdqg5vJS8WaRohE3uKbz2JvsuM5cuj3wuOB?=
 =?us-ascii?Q?35uyaxu3RkWlFKEtivhzYdo2oxmzpXZE5zAoM01fI2d7Aoi+UrNkMq6VYtzy?=
 =?us-ascii?Q?D9PVa4XRsLHRbf/GjQT6zGqWPGZgnUkxv2IC2sNOFF5vLzKjWyreH0Lnd12A?=
 =?us-ascii?Q?dTZNOsNvu/2NB2ZDe9DeaZQoZSFUIThgerBd8Ac5jDesk+iZWBVzXWRnVU8T?=
 =?us-ascii?Q?fG1p+9l+DVWfHOeX/UCzqDs5Ihv9HHMk4wZ87w1Yq2zbNYdM1y8+VKXYItNN?=
 =?us-ascii?Q?TNxTka+1s6g8R4VlyLkj1Xv4PUSkHkvEuSoTPQerYbmsORttH4/rfgMZkSoG?=
 =?us-ascii?Q?Y3BwIMBHTWUTaX8xbSWM2V90BJYuUb1G7y3yXHEIKgT886PXbS3xgkXbZ/AF?=
 =?us-ascii?Q?CGNaLX/qaq7XbPyQ+CpasbmuHInELGWtzYY3NLozXqMo7E+9QiOHX+WbOs1J?=
 =?us-ascii?Q?aWPTdIafiOZh+GbcdYUi6WwRgi/oquJbHpNw3mqznEPeLMrLS7PrSprw/vy9?=
 =?us-ascii?Q?n1D0PukKU90xgbLLajzjh37l9iLPSyI5Fqik2KaYFWzDaZdn9YY0fjEuZWVY?=
 =?us-ascii?Q?openHb3ZMXkXrvwaFXmwsZjlrOekFScCX9YKC6aGM7Ro3qeOge/J+K07a5pi?=
 =?us-ascii?Q?jMVuqo6/HfRgU3trfrojCRQ54UF0UnLItGJqo6tpxi/xj+ulMAta7E8uQfy7?=
 =?us-ascii?Q?qT89i0Hcnw3pGF6VEWOsnTq3qx+Pm0uP/s+/2gQqx0ysMkNTctTcBdDHZfW5?=
 =?us-ascii?Q?Fy/5rqpR7GD83fppV5B5672ZPQkTSXnuixqLuuQ/Gdp69pMGqHVS3AcxD0sl?=
 =?us-ascii?Q?ztAPjWgcLOobzdB5muRtdE9Utj6CP3OHGt6PlQOivt78POdyuzhTgsAyXYWc?=
 =?us-ascii?Q?Qgc4L+BOq/X/Y0Oo96+zn884Teu/noae5dUBzmiWwPpyCrz8eWVejPtTwpb2?=
 =?us-ascii?Q?rs4NV4HWikU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o3qLGOBM1r/KYenZ57eeRLIaA9WY26cA0IUDhaBGa30q9062ue1n69Bae3Mn?=
 =?us-ascii?Q?zJ5tFewfwM4TstRi1ErluEwF2MkeiWra4kPFrcu2g2NlaNbKCXxp/sIZTQJo?=
 =?us-ascii?Q?hMReslnGNZH2arvHLpdXOVsvtTPvj5fW7GF/VVkBo+Ld7g/EeCwztJPlfzYE?=
 =?us-ascii?Q?hdiJcMRbOhLv42nEXpw+Ll8rqJIlDwJ91JMrZwaN1BYwvveVt4FXaCyXwzFC?=
 =?us-ascii?Q?aZ186Ydw3Ku2HjkFIZjaGmIaztefvSqMbmPr/piHgIWXECjMKKoTRRoyKRjR?=
 =?us-ascii?Q?B9uD02MG2YhLCRxy22RJlTKHukfv5PmvvRbOqacs3NcjE8lvVBr0M515Hyix?=
 =?us-ascii?Q?kId4XXLlC0JjlKEFIYWv8YGXTO4ItnJtFoOhxjLfvLnkGshi3BDgqwWWu2Gl?=
 =?us-ascii?Q?ujibp8jvP7Iomd5Buqih5hkV0zYMGLNjbXQefyaBAZAx1vCpe/qCMDi5F7Ut?=
 =?us-ascii?Q?CTv6usrfKWx7I6uFWvfzJuWatfTamZsZBKMMHBbYNWfA1XGGdwf2hQh3j9Yz?=
 =?us-ascii?Q?dVyVP+YC5XuNwnmrJI1JIiflmcgO/Gwzac5+VDgl6NBxIzkLsYW4MR9L7dO0?=
 =?us-ascii?Q?qAUoLxNxUtXuB3qTE02wEKcNSpj6AM1I77wRSW7wXlQ9X/CdhDASVVTTQD32?=
 =?us-ascii?Q?kLkwxPJ5v/biMINX8YghGV+jEqqaOtPCyz/RMjvkLs7gxGoYCSVvrXQI9CmY?=
 =?us-ascii?Q?xKhKBqpoenGtFsZy8vvSr4dlwVAovyia5sxKrFU1H0DRvlmkQ65IkKYoy8AR?=
 =?us-ascii?Q?6FJJwoeVrYqZBYOuAmCEvBBFI3N1hchl0it9TH6Lr4VMNdyFgvJFWte0SvM6?=
 =?us-ascii?Q?WePnsjcn28PcMM/GuO+DGLsJeWT+XWy9r0WCLZJsKPI2OqR4jd/L4iTG4neK?=
 =?us-ascii?Q?LsuqlZwFzz5jbS34Ug6OlaVjy867LvsEouDaVBisHXo65JGsWPTh7KiDQopN?=
 =?us-ascii?Q?mK4vFsn2qLz2Ykf6z0OKi7l2PY1iUbzxxW0wlUvujm/n1hzK77O16tb/4glh?=
 =?us-ascii?Q?QoNiJFrMMSULMCoHs2QzhQlepSrBviLExwSKOhudA4Zi0RrB4uKsvBRqph7W?=
 =?us-ascii?Q?I5H8qLCT/2HAYp+lfRHgQwR1/Jrg6RuSNLisDemRBzhvV3PmG/5BaVWkPIQd?=
 =?us-ascii?Q?jSFz+MGRxDjs/UgvG4OWNJUx5R/mCGBHPHFhO9jkzoC/vLzJZW4VgdZFCD5U?=
 =?us-ascii?Q?oXGP/qBRmN+5dgC86ELyrrzi5FUsHxI9crBIDKDutUcaaTy/Fqlf45lkPP4q?=
 =?us-ascii?Q?mMTi/2hvdLzR20v85HVX/4TzHus/XjuFra5+9WE0fCAKOTsdOJVJPLWyD4WF?=
 =?us-ascii?Q?36ZavKPDPNpDkT+6qfAhJjt6y75Dzqqs9c+3mqoVDixIBzWCkuyiO8qGnp3H?=
 =?us-ascii?Q?qYPiB7LwqaNIpgXpqGiqWvVqcd65iEDtWR4lJpAJRCbbcVoZ3zmgjk7tFE41?=
 =?us-ascii?Q?Hvqk/MA0huo+jQ0VO+QziKavCwLy0ao95i1WL2koDhaSsqrhlQJ1MKOtjuhA?=
 =?us-ascii?Q?Dr1GqVrpCScoGwooz4rn3mCrUHgiFCH2ywqdLRt2n/mwhDm5LjFpOh42ZxH/?=
 =?us-ascii?Q?0yi6dSz9x1SKRP6Hw0Yaxtz6oJ0m83IuIwA/Zxp1D/QFlsDLnu5CMyw8bEtk?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UXNyKlNW2qdtsRWyK7lLDt7zmybj19+e/8QdB5CtwMuhmhpRvKoD4Q4JXE/6HIgdnO8w4LntQswo/Ohb1UhugH1GPWmK/kiVDYtSv4MNS0Yg52u6SRyNMk1vcem7onJ8i45I3LCUDUGlt8XJFIYt0PLDt0pw01BGNR3iZswoklOJZsmP0qVc4LK3sfX9rGXuMLRNHQWI4834Ur2dIzpBaWpscI8GY/eHEUHbakn0u6ID6dv6FTkfwWJ3IeM+qG+kv3eDlKCi2tgLN2l13/cc+4e4peSg3VRGgSJK6frResNaynGnLIa8eC+pP5WvF8lxKd3vy73L1ylye+pc5N1aPOgoPbx3eoJf8b4rbCqtLF/TbEFBu5TOrgCwz2DfRk7eYgokkgI4V2k1kmldTpqQkF84ssP9rg2TdpUU2NscCiQmxfxdGRhWfjvKSPiJPMUIWrUsqZ8V6KBEpS5m6Mbqi10M/x2FAV/XP528riNCTSoQ51wHNlpQgZK62GCuIwPJ1QEKEMo+36lfBFTL77aBnfGy9QdCo4NigYCkhud0ClP4VNpv2P5TQ/WxJ5aKQS7fzhUdChDInfDtOjzR2f/d/hRUYavkzRCE2gdFdZAdRRw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dea34f5-e6b1-4501-3bb6-08ddcb557f87
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 08:30:22.9247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bF74lFZGOYvcn12lgfZJbw69QU/aSTXytGAXHNMn5RZ6R6ZSgDzAXPi3bxJTuBVcI9GKI0wfYBa9puaOsLe0VUThcO1qk84vBtBEZoF8KRI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507250071
X-Proofpoint-ORIG-GUID: kKYwMvUZit9rPtB5e0LkncOUOqWrX-iZ
X-Proofpoint-GUID: kKYwMvUZit9rPtB5e0LkncOUOqWrX-iZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDA3MCBTYWx0ZWRfX3Sjrwly8pAmV
 Nb2A/ttG0iIo3r3MSW5pLhLYWKqd9cBXXpo5mOxQT4ouc3yUzUnIlDGC3SeCtyeE8Kmlo45GT15
 ubUDCy+xk+UbXvsx3Tzf+Zg8VQX+Z1wCEmYgdbhaFdUKliotvPBjZ6qBNhtWXlcpgYmYXwLrrMv
 AhiWKbTqhwc8ApV2RSLWcIFN+zQWFXm3irCYh5MZ5lxU2fRCbWyqKs9MOQnHUOnNUcEXE3y4HXz
 DqGqqi01Aigq3JSWIERdIMizFGvsj0HRqfU4kFsrf+uM9cljXgpLuD+B4Rxe6357oAVsBGr4UQX
 BSS5ISm7z8B0x/7LL2c7tJn8DasUfp1cpzCLxuBLQpc0mQ1iX20L8Wkm59lq+ka8ezIJjLqKIed
 Ek4/+kyNM+8zRyiI5VrlcWNpn4TXxhvleoZkgak9xfVKJDFrjp4ZKMJ0uqeWK1b2nOL9bKSo
X-Authority-Analysis: v=2.4 cv=Jt7xrN4C c=1 sm=1 tr=0 ts=688340a2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8
 a=20KFwNOVAAAA:8 a=xwD0sDoZQghBaKHlvQAA:9
X-Stat-Signature: eq8ic8uwgxhuoibajxhd84a931tpnr5h
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A99F240005
X-Rspam-User: 
X-HE-Tag: 1753432236-963162
X-HE-Meta: U2FsdGVkX1/T6c8FYuVVzolx/sEECGMA8T5mxbizLX9ps8l9l7ZX1umS42aCcYqT3vfXG2rDq4jAuN8CUK56yPGDbWPUsrqzzBnkzeZdFN70s0YnB9h+oqvES9tVtegkDOVFO59fkRtlHkpVej0FUsQSkXCjg0C+0zaBPZqnQnMzl1mU/L6GVK5N8atA1datCtfi9vfFeuTc56NdEI/Mntm7ovsy0vNfjJTdodJeQYfaTOrUiEOs15YFX9oR8sWZulQy3ODi6lYQ88/pcHzSzjMG2H0CSG0yBJYYO8VThEEC+bzqnynvl0Oh7P9BXc/J8R5BXpsCU7HRZDPG4GTQMBJCOccn+RiwiwpId1CUAWFZ0J9CAwr9L/f1/ApH9Z1j/9lXrYluRLh7Sk8OyvsWBhrnwJzBRg/xkJTiTfgBXSj288gSpZLqsK6VvezKe6g+Ho7FsbksR+8nlEx7eoxJZhQPpFEv/IMt8mTUWZBgCM/VhrrzunIX1OwIaQqVzOKTyaiZmh+4k5Lg4CzJ5XRGA2bJp9UaLGHeBXEsdcWU9wcq2ytGyxl3dve8/Ap4+mImo7cNr6kHj/pwevs5mKj5iLIBLx0viQkNbDo8X/LDMD+fn0NBIvA1llNY/0EgKWV3xXOvo/4dZ2CgxKCE8MAMCHxqA2P/d3Y+cZ8GmQOOumeAYRwd5CwzbtRAJC31DXHRRdb7NZTn8rqcYScTGcT5jS/KwiqcalZiiM2VxXOFpQMA0DPYz8JBIfw8kr1v2auu/wuzGHIv7N5nDOcZ+TY6Z+thpAd+uekwiDebEqJDgYT4d7cOkkcSVSvrNc+QZfqo8O4BfpXMqVJc4ZJoqxMF18WNyD4KEtf/RO3PiiFtHnlXoT2viEqhuuvLOOtlYgsqhwwB5A4b5R5JZCW4JsMxmyq/pB1lVnQNvh0ulfaFXQf0iEDUEGW5CCNUnI/WSPcHNVxqn1kTZnr4A+ZnEqR
 LMtkicmf
 Wn9I4t5lsUmLDKLW9PyKDxr68J5PbmZa3WFjgHSMZhr9bHonPmF4f6W8uCSNXK1VmK1AgVIGSC0TrQ08mODk2GLgeL1tJJqLHKERWjsK7dfUKrpoTWvXfQuedT+gZZm0KBdmci+DujuIZfNH5Nd9rVmlxAOz+93YhojAv89h+31MroBv0b2OIgMh7bsJqfg4fVLBgdE7xEgEGM4bACavJ4jAVewd41/tE+1+m7dd33DDhwDsODA+7ov1SSNaSGG9GmG7v0ga2AO72MPaJ6Z2ssPirhA3DkVUc37mLJC5NdV5g7kEC/jl/MXFPGpTapECQzHMsXxuDtfNjbYUb9v6R6HyVU2svniJVzgqC7wRsp8Fqwhs36JWsvEDX66HYeoHhNe2zYrFqYo5nZ4z/KlWi45iyY1nDcLPWcI+h58eQY1/Q/+ivdMXyQj7EUSZfzuBhNeeZWi9sgNYEFQ35Wsf8m9Gf2FIUgNtSvTuoMcJLA2gM+Wv+FKo45hc0JeXeGbOkhwOwLtEVKQgvpP7IVTluYCguK9eptVp4eFmAvFuUCxzwwDfYFX8mMrd7FuivANkNQIfN3ihHGSUwXiitTf6jXKmQLcdeNtI3w0dcKsiUhJvT+qFFWctDTQC4Ou8Az5b8ymPbDRApQM79UgaNZMfQtBNS7iVC4YRbmVNUVFivr/UnnpEcXRqk2T/DiK8CKotBhr6oYfPD5jc5JNjko1qY7TShA6qQvaH1ItqocEfgAq81YVJA1rTPhMmlXY87ZatJNc59
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The check_mm_seal() function is doing something general - checking whether
a range contains only VMAs (or rather that it does NOT contain any
unmapped regions).

So rename this function to range_contains_unmapped().

Additionally simplify the logic, we are simply checking whether the last
vma->vm_end has either a VMA starting after it or ends before the end
parameter.

This check is rather dubious, so it is sensible to keep it local to
mm/mseal.c as at a later stage it may be removed, and we don't want any
other mm code to perform such a check.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/mseal.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/mm/mseal.c b/mm/mseal.c
index adbcc65e9660..1059322add34 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -38,31 +38,28 @@ static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 }
 
 /*
- * Check for do_mseal:
- * 1> start is part of a valid vma.
- * 2> end is part of a valid vma.
- * 3> No gap (unallocated address) between start and end.
- * 4> map is sealable.
+ * Does the [start, end) range contain any unmapped memory?
+ *
+ * We ensure that:
+ * - start is part of a valid VMA.
+ * - end is part of a valid VMA.
+ * - no gap (unallocated memory) exists between start and end.
  */
-static int check_mm_seal(unsigned long start, unsigned long end)
+static bool range_contains_unmapped(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *vma;
-	unsigned long nstart = start;
+	unsigned long prev_end = start;
 	VMA_ITERATOR(vmi, current->mm, start);
 
-	/* going through each vma to check. */
 	for_each_vma_range(vmi, vma, end) {
-		if (vma->vm_start > nstart)
-			/* unallocated memory found. */
-			return -ENOMEM;
-
-		if (vma->vm_end >= end)
-			return 0;
+		if (vma->vm_start > prev_end)
+			return true;
 
-		nstart = vma->vm_end;
+		prev_end = vma->vm_end;
 	}
 
-	return -ENOMEM;
+	return prev_end < end;
 }
 
 /*
@@ -184,14 +181,10 @@ int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
-	/*
-	 * First pass, this helps to avoid
-	 * partial sealing in case of error in input address range,
-	 * e.g. ENOMEM error.
-	 */
-	ret = check_mm_seal(start, end);
-	if (ret)
+	if (range_contains_unmapped(mm, start, end)) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	/*
 	 * Second pass, this should success, unless there are errors
-- 
2.50.1


