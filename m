Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D93E9B24D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0C6D6B0088; Tue, 24 Feb 2026 06:10:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB97C6B0089; Tue, 24 Feb 2026 06:10:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E806B008C; Tue, 24 Feb 2026 06:10:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 861776B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:10:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A47F58BD83
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:10:43 +0000 (UTC)
X-FDA: 84479082366.21.43BF9AD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 142E5A000B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:10:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iBPyq7yU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U0W0MJf0;
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771931440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VSiuuhiwucQgwmmJlz/qLCzTKjQx+eJpcbCDA++WqY=;
	b=FlGtEcWM9OPQ48wX8XlKe/6LqGyDp3PViqsnYUtcjkjoDEHF7E709ZHwtYZfrKEbnraYAx
	BjdhIR85cFrwoGjGqrPTRUuDV1XdTb9A5yTe0rLDsitjVjyInGWGzXEUegYySlAipMsYi2
	Q37b/QovgAo5O9n6Mq/wQ4vIvuu8jU4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iBPyq7yU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U0W0MJf0;
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771931440; a=rsa-sha256;
	cv=pass;
	b=SbO0rnsSW8TIJlQ6BBOMhdgR0ATSH5PsWxyIF5TufOFV5WQmxXChzezSI/TV1166MxvCL5
	3wPJagVvHrG6uA4hnuQQUKLu78xbdq8OecUXHjcDrtLociAEH1WyEPQz/XfvNkw+aPq0c2
	zDguYaaZqmnz5OZDeaPXh+VPxbaO+xo=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NMvMOB2590015;
	Tue, 24 Feb 2026 11:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7VSiuuhiwucQgwmmJl
	z/qLCzTKjQx+eJpcbCDA++WqY=; b=iBPyq7yU6CFDgprSu2mkZk1D0VKIkNhe2q
	Dn6dZbkJ076VBzOHLvoYt6ukZOQEjNuXNjxO41gVD6pcAT1DYUK32nKH7/h74ME/
	pwnU0gkHbdA+R6hJ6pFSZ9FXARXHvTDIW3M9TDKdQtGX0nvI37rJNtTM1Jfa4MpB
	hrzER1Vd2l89czaB9e/po6zT/Hq+nwH6O8Jf9ao/hjib8998ReMesAkE+v4DsCjf
	G9BBap9eB/hysdlR2YWnE0FR7dngGRJGOZe3ggeAbFoO0fUC3zPGStuKichOMG4t
	KVHPYR0UocIAxyrPpIZQYjc9MBxCvcVJXVXe5WAAC1GR3IQVxFKw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf4k5uysr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 11:10:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OB05Fw027848;
	Tue, 24 Feb 2026 11:10:31 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011013.outbound.protection.outlook.com [52.101.52.13])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35ek7dv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 11:10:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bfQHUdF+HsTbLZj+P/YDW+E2HfqERCSQKD7ZUrxCK+junONMEthyVTKCAgqNc0P596ozoM7lrBKckguGBMOWZiCwo+NKTFKcfpLvxmTGxjsAmXj7Ub8qsmnUPWVNdqkjcAjkMUlP9sKSBPonCSl1vZlLjKC7779vIs32+CLjrqomPMoAJ+rhZDJeVVWYUIbb8oy/cqL80DonmPeSnwFr4npY0DDVQD5COBih7Y8WKyvG5jImkeH7CfzXxMzm2sUe2NzSvvB3RQIqIjmQtRKAT7rz+igtGxmzYMegLwPgllU6Bx408g5x4ih1lZ0eyUlqlNPlGUBdxurHw9EvScPI2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VSiuuhiwucQgwmmJlz/qLCzTKjQx+eJpcbCDA++WqY=;
 b=vXdT77MNADqAL6SjVOcJo1mw4DtASKwU+YQbU+kOgkZOilMK66bMC5LuJb+95ZRvFAOez1V9vkvs6yaQrCFRsULXflMco6F9CP16PrueSxo/LP9wZG04iCu9l3TGdTk2AWFJmNj3oV+dgQ+26t10SCwiRcunh7olP3065FbynFb81WIaJ+vmSTyhqw28MfF/sG17JHYSu3ndoN4VzluITs7E96zbfjm1w/adpfnUNXHaYWQYhoE0kTZBrQQkNv5qPeLW5nZwTn6NlYyQaW8rCnJv67DNleVziZmZacQuIyNbcassUigjfEco3n2Ac6QizpXi8Qcg+zUc1PYOSCCK9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7VSiuuhiwucQgwmmJlz/qLCzTKjQx+eJpcbCDA++WqY=;
 b=U0W0MJf0HhQmdPQPeS4sQnmv/Rfba5l3AKKwDTXhy02M5VDozxbd8zeI0cKv6Mk1Z8Hv5JyPs3o4XYEtcuG8bBnXjMfzleH113RR8af2+bsy7ka64fO1DgbpyFXzS0+KUPF0gHjSp1d8nLAmbuIl8nBx23q0kmE0iaF4EWGOtCc=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ0PR10MB6327.namprd10.prod.outlook.com (2603:10b6:a03:44d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 11:10:27 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 11:10:27 +0000
Date: Tue, 24 Feb 2026 20:10:18 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/slab: initialize slab->stride early to avoid memory
 ordering issues
Message-ID: <aZ2Gwie5dpXotxWc@hyeyoo>
References: <20260223075809.19265-1-harry.yoo@oracle.com>
 <2d106583-4ec6-4da0-87ea-4ecad893b24f@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d106583-4ec6-4da0-87ea-4ecad893b24f@linux.ibm.com>
X-ClientProxiedBy: SE2P216CA0104.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ0PR10MB6327:EE_
X-MS-Office365-Filtering-Correlation-Id: 84542164-7404-40a4-cc99-08de7395507d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6Irv2H54Pj3oTKe0TwAWvuywY8DwRwAv2X451x+jeo2sm+DiOIPL3NHOG+AY?=
 =?us-ascii?Q?c6oCMlKCDc5hnlVRFt4i298sk1cGltOKd7NsqhECYCHDt1thdWm+k03oDEsV?=
 =?us-ascii?Q?pEJjHeDQMiLrFBbS3/g5r80VdrBzLicvIAS1oGjP7rtrRQkrmA5WXFuaGlqg?=
 =?us-ascii?Q?cNSLzb7vqrzUrRINXW4NFHnz5iZldYXr072IV/Gx0I2YCi3IMkTtmQOTi0YZ?=
 =?us-ascii?Q?a9I7dBHe2KOPPAgWRZfwRbXBu5N6boCMTI9zSg40/0aQdBEqwWOOxtijlAnY?=
 =?us-ascii?Q?0RFHcHEY1Bin2e08zadbHSLUK8U7MJUgbTp5ZWua+RI0TYqEgmPEpjbcA7Ue?=
 =?us-ascii?Q?P09T+z4KkVefstREaEQR+OWbQrv3vx0E9o32/DSpFVotxFFAOlQGZ4AKlxmL?=
 =?us-ascii?Q?qCNDFmx6czAp3kpa+b5f6D+/IXs4zL7C6VlQLptEN9zcKdoCUHnnQiY6J4W1?=
 =?us-ascii?Q?B6XDN1Dkj5X13lA0Kq296bCRWkPgDiibL/xDrnCUHqnkf9XPNcPLIfi5SX+x?=
 =?us-ascii?Q?kEBJbEU6fnGvuGfAUZp+9nY6q8BZBbhEpQBazb5d1yHwW6fI8oUoH5th/Nf3?=
 =?us-ascii?Q?T9RiMBpAWMpr+zjxmzvdMu1srdEmnlTFIjEQiMmO93ucl5h4Dk3UA3rUhJs+?=
 =?us-ascii?Q?jir8R7g7hIzGlyvK55bCwhBMDBpO6GGKS9uG4Ni7t2HA9/Wg/6v0QRmc/0d8?=
 =?us-ascii?Q?xwWqhdul1LOcdtUboEltW56kCaNFnGHlbGuD+rvp4I2GT5C2vkUxOghZi9j3?=
 =?us-ascii?Q?J+78qfcZ3bAvI4XUd6hbwQk3H1zdB9vOXhkM51LwyFJQJ9MxbA5mdC1WDM9Y?=
 =?us-ascii?Q?kMmM4G2GWdtNLm2Lkg7pUqla0elNBacgdzvcomFjhoMn83aD53mFHf3Rkika?=
 =?us-ascii?Q?U5GAODL7H0MuBGyf6EGn43C6LO3ddeMlMV5+h37zlTFPjnD86q6NVcfeclLQ?=
 =?us-ascii?Q?y/9CIdihehmojSzF2lc+0O4hJVYY2DVe0Q3YVSkhHk4H4Fd7xxVgqbavD6le?=
 =?us-ascii?Q?8pHPRhps6bV1lKN93M47rKCdq4A4hgNVARGHxnCnKjTJfvvFJJaklMuyTYDX?=
 =?us-ascii?Q?ddM8TK3SWU0zH/knLjUKkSQYyJPuuO37Wkaci5XcZi5aTw5wNbjlniTqMYrr?=
 =?us-ascii?Q?20kXAgJPhA3BBNl7NrtgSydFwaY209Lt5O6BG/j0lGoZFweudYRmkacgN7OQ?=
 =?us-ascii?Q?XabdAWxFtjyGgD4uN92o4H2CRoBxPar9dYa9/FFg8i6nSxbp7IuCSH5PmZGS?=
 =?us-ascii?Q?Q3MsOUJmKF6WVK1RFkRVxFs8o7DGH9P0QzVDS+0hYpAz6Lcfoyadh5VPi30n?=
 =?us-ascii?Q?2J3dGHZ7miC0439TYAezxxjGHj1miKbbn5REdr2WRYg9kdhlUBh8e75ZyYU5?=
 =?us-ascii?Q?gVorS4EfPw6XqegKYniit09373lo5FLR1ZDt3qxtyixEX16UJyh7Sopa7Z4Q?=
 =?us-ascii?Q?fKIcyIKQPmDjVfKyyhI7IfeoWZWeHwbrYtJIhETh/uhODnspeOArJJs4IW4D?=
 =?us-ascii?Q?SB7gS/B3/Me4BW57Zau6rgxVTAQxtiDX2GUQ3NC2saXkzSfHp8mgzNajHgob?=
 =?us-ascii?Q?7sM1euct7bClyZAVpAfSTIjDJSs00ik3PkXruURf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a7OsvGSqpNqtQHID9IikW1sGQfXvyWVVvMTEMy/wr+EsmfkJfUPWh+GP4emM?=
 =?us-ascii?Q?wnp3wNE6p7dpTJ4fRfcUQXHWEcBzPAVLhd6FBhuBs7r74Fs75DiCkha7r7/l?=
 =?us-ascii?Q?GWESkK8uXebDyNBvAYeHbg04JBJ+43zyenBTsio+P/ZQF5CNFKKukOsdIVVB?=
 =?us-ascii?Q?biHk4lwLLc32ATJI3S8lJ9EuV1LKGtqJJsil9ZsOvR3Y8JbEtsCI/X3w396t?=
 =?us-ascii?Q?yWlnBlSs5B1NfX92kuprHVeQ+bEkgAiIekleNa/GI7QDyQfRjb1rtkz83cCg?=
 =?us-ascii?Q?Nyh3MHciOqTjJdob0XOR1R66eAg26I+jNWrpkHub+bSVmvhsHxEpzTNI06Tt?=
 =?us-ascii?Q?OY9bRf/1Wk9c844LcgA+66VhkMpzLO/IM/ZNuPHRjLK+9iSRH5/wjBPZm3eC?=
 =?us-ascii?Q?8X3DUFoWWAU5s8p5bTjLVKs9X6pSg9THTZQd6LjKVUkXXo4IGWsoPNo+KXiU?=
 =?us-ascii?Q?P065wxHDci6mM1dceq49cNYOMzDlZYivoFKYx5iGhdoN59ZU+fL3kOSmWeCL?=
 =?us-ascii?Q?Sqt6EqFVUpsXHvPOMpYszoUu6bLpneqPt3Ag++88obPFtbo6ZeZEuAKP38cq?=
 =?us-ascii?Q?1yKByLwbFHU1ZE5j3TX1wFcqXlr5je5ZFRI9SFjMJx7ECGlbtMotfNKc1ogD?=
 =?us-ascii?Q?CNazane8Rm9HIymVEH+Pf8/0wGBfloiE0uSsKixYEaOWjYSe7j+K3MOz+b34?=
 =?us-ascii?Q?DvAg9+m3WJdIA+0b4+TMn3CWegL/NE0Fdj/0GcLSuPxmlZoX7E2qBcWS5LiN?=
 =?us-ascii?Q?DKLZO1Z6xPDNPvuYbqhcmoQbPadyHLowxHDnSoSbvcleVyK4cIeNowAxSsEO?=
 =?us-ascii?Q?agSaBnI87+uRtlzlgoiXEL4dENp7tusKBhZvYOUCEJ+W38GWhKk9/k1YVKHs?=
 =?us-ascii?Q?zhDInWUzMm2s1cBKa84yz1EiTYnW4abSCmLZc/oRklQyWDrjBpYQ7SV3lfgi?=
 =?us-ascii?Q?p15Of4ytgKBI3Z4W0py6EoLo0UQa+HcPwjkXELoFdeUguoZ55V64KFr3RyvB?=
 =?us-ascii?Q?RC9gIACq6sP8vhWKcFt0EYcHNxaqbGgpiD4I/tT5UDeV6aSdzXJu5bEX/Owr?=
 =?us-ascii?Q?rVmfX0caJICwXhYCuNwLHHE+BNjZa1heOsOk/C163iIi/A2coxLLzpjZkE8w?=
 =?us-ascii?Q?4Q0jvHhe5orylYLmdGX6uh9U4aOM+ShzKk81Hxtsw2mxmr70TnIg1Rc+AedD?=
 =?us-ascii?Q?TSlnFDMN5wXjT3/M+P13qXlkfS+xeEVrGl2Rs5Xh5gM8dLaj8E33JWZ/Rr3S?=
 =?us-ascii?Q?6rX7Tt15NebFqXHM7ki/0BZgnG91gA06gCTTSaS+hXyBdjnEJ+YdteWkka8P?=
 =?us-ascii?Q?1kf7Msrv4tc4uj1Ngok4vWClfCd70YCyIJdARVN7qdMIldzavWrVNlpbSgPx?=
 =?us-ascii?Q?9THeI1q3gVAwKjvmFMQ4ZDtBsOWyNybdn+aLIY3OGpetnr0kXr12DyPGoJ0a?=
 =?us-ascii?Q?gRa5bNKAXzmO2Wqg6uxTqvpObOzJ9+5VzOTSnTLD0NNI+dKEkSunRu0gp/hH?=
 =?us-ascii?Q?Poch0uRGR82w5acMRIE2cAWroTvjN8M/G1NbkuiO7wBsgs/lSVTmIWNkVrKV?=
 =?us-ascii?Q?dB+oHjcuBzpe3t1iHCUyWhsheMN1ShfRUjrNbgoD+T+JIyE+1WP4/wZDMM7g?=
 =?us-ascii?Q?t8vMD3HsnlCfslQr/PgZrYUNdYT+Hk/JSer6lyWTIKN5wGgk2hrvsAdxeaed?=
 =?us-ascii?Q?PWXqpasPf9WL4bKXIng4dJS/2JunKhJVu03iYJQpm9z51yBJU3/hepjoO7FY?=
 =?us-ascii?Q?oW5neZ/ZrQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZcH6FY5KVOEsQq4JhWlfpggC5fH6bfn2VrljZPtOMpZJcY3z8qTyfzFjGyAbLoX+xYW6mY52etR5jFzrkpSamW/C4TZHNdfFBf31mh9F27sHlogoCrciawjfMyhgdgpdnDRmHkSsPBwtMPMQ4e8VVF7+8J8FNtNiN4qRvtB9jhoUaRUqHlnMYgheodcAGxk1NBJL7T3N/v/zUs+c7R0T8W7csvZbX3eQcguYHAKFJHMDblQNH7+jiBW0zc838uZhIhnLz+h0nIU0LUvOlCZS9C1rXD7uGdo+aqxbZWpFApi2ENYUb2G9LrXAIC0tvREtG2hyER9JyqQoMNTm1l4GGZQhYQfl97vQkL9dp6l7lm6nn22Nd4oyLIe+rc5Zx2t3skYvux9xdQPG+ZElSUl0OGSL1e+Mwb61T2zjdxiw1Gw/Np5pUqU8EACcDqIH+wob31AOHixbbF2QkCbVstENlscboIMMi6Bi2J/zd2p6vE79kbZJubc9RWUe0D45JFJmUyEVS/aO549O8ih8lx+dIRh+Uo4u037VzfrJGMPtDwgPaD6vH6Ughduku22XbkLrW5UHVP0MugbgsFyVrzuE4pELiZJo6/wYp0s84UKB6Fs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84542164-7404-40a4-cc99-08de7395507d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 11:10:27.2103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Il7GwREjbw8zEj+wVWZucUBZpFusxYxll0oEK19dtsffbDD8u6u+b6kyrUPqCiDEcwF2XlsN/oBKJYTO/aHAQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240090
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDA5MCBTYWx0ZWRfX1TchxaMfmZhY
 i5RdHTwluSihHmlS7Dv5pygAXwcw1Ni4QpUm/0dWkkVej6S9uASNDXxFEng/Cs3PNFXG7RFw60g
 1Rpbw8iXP/q8krb6SbDTJMQb+3yQbvLeXXMNZcJnSl8y+5zpdnuwDahkP8nwgoiN0yc2YotOunt
 MMv13+Eo+8SuIOD6yMN2HNVZYI2K6msqcsSxTv5pujeEvj9wR+eTWL9s/cUCKxHpHLPGfC0vpmp
 avwsHVuBs0lj2e711UuJky/0P8Q7m+fc0preQw85ykGLjn+f0Qh0GvHUGbiyd4pn4vzMtGxXnN2
 aRUot6vX6GIyhtEIq53lxg0d216JToRXaZMaSutqFl6kdP5u2EcOG72MN6yG3r/VF9Le+bSTAWR
 s465dvgAu/ZX081HHjwazLzEIedpefiI5ZyopEabbqGtJFbtX3Enl8UGHUW1gbZLXCC3Ple3nC6
 3PNbSmd7UfOXc/xValY/GUSkepn/qgLU1ryyhOCI=
X-Proofpoint-GUID: xCjH2QyvbPNFCo62fOCCrAITIuGKLCDA
X-Authority-Analysis: v=2.4 cv=b9C/I9Gx c=1 sm=1 tr=0 ts=699d8729 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=BrOIIaLph3aAxMYrsNMA:9
 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12262
X-Proofpoint-ORIG-GUID: xCjH2QyvbPNFCo62fOCCrAITIuGKLCDA
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 142E5A000B
X-Stat-Signature: e8tr5p7774s1iw37gyb9ej7668g9e366
X-HE-Tag: 1771931439-638984
X-HE-Meta: U2FsdGVkX1+9dQXSbTYQepSRS0XI8hmgIxjU6ZPfkPqxKG3wg0kL/0Wobg4PgkBkNk77kpZvf+H3KxMQad1YnjKw4vFR9wHGBqVB28vDIIH5OKTGhrXal9DGjX4GsszdZboWRRnLnUEIb+FzdND2h1CFePSovfJLjRm0AFJSYeHqBqiBbiiBk0wKK4QjQXWhP2sROOPNDGYqqBG7F2Oi55JHQWZtnKX+AAJMcMxt13ZAsHrr4C0Zq6IGoWEF6ENgJu1Uarz6IEHVjF1CLEx00K/GsmfAZCuGYux5iypo3X7DkBSDN6+OJiIzsMQzi2NaOtgGQIzVHszZ/29e8sz2V8cXkFB2y3wAIfo3FYuwN3NazvwDAdalG47pB/ZnInzH3TsXL0ynyzjkctoovk6/GRxREkel9QZ0gp7BJ9bfanwtNMRObqmEPA0hiXfQBeZSP/ng4A3Aq5cw33iMauJy+YHh4q4QLFc2PAZ2TOgIH+dkPzlXi/kBdGf/xKrjBSzJc+oUUkGLIGNwYClnHBoIDjDI8Wcfg8/QPkjV+nD+6YG35MSavIERCKJb9HVHGn6YopyG6JzOqT+XXQy/9Zo+FJPt6wLB9aRcIhHIlm6t4jrOuq49jQjSj2EAUmFWeDxXNPBjzyVLxScu+p8dVF692aIN3jb/Djq0bTFcWlkfNNehUiwABRHxKdSFLxoKg0zSYGpvaXkZ1Mw4AgJnOEPjO994mVoyOraxH8JuzHcJgBse2P4Cg76PWCZiBbsuzH3vfL6TK2wadhG/xPwTbyTUbx+Oc5Elw7i/NjJkqNmqXmaOSbjw+2UfB/e4JdEhHQ/6VsoTxq9UZUDNEM2BFFxrSIwTWHlub1Il2S9WizZ0dIdw0NeQLm62m9DFPdRRqsMKvYQxuyYhEYQnmYx6MbkSIErpJhsJhUlI7Ydt7ivFxDeQxrYtJGjRlbrKenfzxkHVqOr+dt6pLFZhLuuRpIK
 7Dmvx7qS
 WH9rD9XQXmTaAxMne9viMU6OrPend+xlmYj7Jp6m6LbnCJWy6926nWwBC12OV8OS5ujThBOgwDDZVMt+glzgVp/D9/FX75tyRnWVy2bKp0QWaTp3QZa7IDMI81kNf87utSr0jdCN1K2ilknjWp4XBtQVH7XGEYKrctbQ/k4hh8W+1Znbtkpns9+zWc40hZSG6PRsrOOEtS6oiyks4ZO8vqHl0/CRJw15V/PxVImr3HvdjTi81XWHoxAS+XBEUqsVhlyOvAO9tx6kBwA427mShEj7UPjGRQ9HKLEI+lasC/nAhUZ1eFjfP63IQHbrHiSTwIra+m/p9iynmDMG+cjnwJ4rkrq+zr/ahaey5Tl5W/aZj7I611LacpDTARbC0C1MBXmeCNiLh2zJ00BZQzc3XOU6kvbTcYpx8NvXkgIkUoBTHUOBZKE97vQjGE0q84pRUC+ikYBgxBNbDzRz+rous9Mu2+DuctH+4HzoMXN56PQ6f1XZTYmiw0sMxboouf2lUriNBkXK7R7zZPC/Paqx80f18ySxjBypo8/DUwd6oJf8roSGFIUkNHoxZUpvJvneb323kForc6x9YsE5HF/70uSPexPjrbjxJSkGUBVX2REQcOKo8QyCKO9ILCx0oeZv1t9GFeSd0tntiyU1jIZOMdVVdTAm4BYaRBcBlD7JAaO0xzkZn3/5xy8Op52MKjd6BX042eNRZWs44pKKaatdTuO3zJnDjeJamcQuMzvRGoZv1uC/ONRPZEtIvFYe/17/MupEnBP+iPshSbgVs1WBoov3XXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 02:34:41PM +0530, Venkat Rao Bagalkote wrote:
> 
> On 23/02/26 1:28 pm, Harry Yoo wrote:
> > When alloc_slab_obj_exts() is called later in time (instead of at slab
> > allocation & initialization step), slab->stride and slab->obj_exts are
> > set when the slab is already accessible by multiple CPUs.
> > 
> > The current implementation does not enforce memory ordering between
> > slab->stride and slab->obj_exts. However, for correctness, slab->stride
> > must be visible before slab->obj_exts, otherwise concurrent readers
> > may observe slab->obj_exts as non-zero while stride is still stale,
> > leading to incorrect reference counting of object cgroups.
> > 
> > There has been a bug report [1] that showed symptoms of incorrect
> > reference counting of object cgroups, which could be triggered by
> > this memory ordering issue.
> > 
> > Fix this by unconditionally initializing slab->stride in
> > alloc_slab_obj_exts_early(), before the need_slab_obj_exts() check.
> > In case of SLAB_OBJ_EXT_IN_OBJ, it is overridden in the same function.
> > 
> > This ensures stride is set before the slab becomes visible to
> > other CPUs via the per-node partial slab list (protected by spinlock
> > with acquire/release semantics), preventing them from observing
> > inconsistent stride value.
> > 
> > Thanks to Shakeel Butt for pointing out this issue [2].
> > 
> > Fixes: 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
> > Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> > Closes: https://lore.kernel.org/lkml/ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com
> > Link: https://lore.kernel.org/linux-mm/aZu9G9mVIVzSm6Ft@hyeyoo
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> > 
> > I tested this patch, but I could not confirm that this actually fixes
> > the issue reported by [1]. It would be nice if Venkat could help
> > confirm; but perhaps it's challenging to reliably reproduce...
> 
> 
> Thanks for the patch. I did ran the complete test suite, and unfortunately
> issue is reproducing.

Oops, thanks for confirming that it's still reproduced!
That's really helpful.

Perhaps I should start considering cases where it's not a memory
ordering issue, but let's check one more thing before moving on.
could you please test if it still reproduces with the following patch?

If it's still reproducible, it should not be due to the memory ordering
issue between obj_exts and stride.

---8<---
From: Harry Yoo <harry.yoo@oracle.com>
Date: Mon, 23 Feb 2026 16:58:09 +0900
Subject: mm/slab: enforce slab->stride -> slab->obj_exts ordering

I tried to avoid unnecessary memory barriers for efficiency,
but the original bug is still reproducible.

Probably I missed a case where an object is allocated on a CPU
and then freed on a different CPU without involving spinlock.

I'm not sure if I did not cover edge cases or if it's caused by
something other than memory ordering issue.

Anyway, let's find out by introducing heavy memory barriers!

Always ensure that updates to stride is visible before obj_exts.

---
 mm/slab.h |  1 +
 mm/slub.c | 10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 71c7261bf822..aacdd9f4e509 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -565,6 +565,7 @@ static inline void slab_set_stride(struct slab *slab, unsigned short stride)
 }
 static inline unsigned short slab_get_stride(struct slab *slab)
 {
+	smp_rmb();
 	return slab->stride;
 }
 #else
diff --git a/mm/slub.c b/mm/slub.c
index 862642c165ed..c7c8b660a994 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2196,7 +2196,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 retry:
 	old_exts = READ_ONCE(slab->obj_exts);
 	handle_failed_objexts_alloc(old_exts, vec, objects);
-	slab_set_stride(slab, sizeof(struct slabobj_ext));

 	if (new_slab) {
 		/*
@@ -2272,6 +2271,10 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
 	void *addr;
 	unsigned long obj_exts;

+	slab_set_stride(slab, sizeof(struct slabobj_ext));
+	/* pairs with smp_rmb() in slab_get_stride() */
+	smp_wmb();
+
 	if (!need_slab_obj_exts(s))
 		return;

@@ -2288,7 +2291,6 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
 		obj_exts |= MEMCG_DATA_OBJEXTS;
 #endif
 		slab->obj_exts = obj_exts;
-		slab_set_stride(slab, sizeof(struct slabobj_ext));
 	} else if (s->flags & SLAB_OBJ_EXT_IN_OBJ) {
 		unsigned int offset = obj_exts_offset_in_object(s);

@@ -2305,8 +2307,10 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
 #ifdef CONFIG_MEMCG
 		obj_exts |= MEMCG_DATA_OBJEXTS;
 #endif
-		slab->obj_exts = obj_exts;
 		slab_set_stride(slab, s->size);
+		/* pairs with smp_rmb() in slab_get_stride() */
+		smp_wmb();
+		slab->obj_exts = obj_exts;
 	}
 }

--
2.43.0



