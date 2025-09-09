Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B20F3CA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 00:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091078E0008; Mon,  8 Sep 2025 20:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069008E0007; Mon,  8 Sep 2025 20:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E722B8E0008; Mon,  8 Sep 2025 20:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5BAE8E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:32:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79C86B8122
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:32:34 +0000 (UTC)
X-FDA: 83867835828.01.68D6D8D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B52B40009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:32:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="GpqP/klP";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zSRDhNu+;
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757377951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VODCTmjX132Q1vQUpUNy1QIjfeELAhMh1aiD8l8TiiA=;
	b=MiNfZ7U3wyim/v4tU1xLy/A0xS5i6KSW5taDx3yPAc/7arLrzxTpHN+VukWgzcO1tQnR82
	/Qo+2uH2b2v3HxfrA6aXpzZa4G0sAlr9mQcfrBoqirQWMwxBLsBEPT82awiHAioHO6lNFl
	NSIqTam8ThN/xPrYFQ5hWbHJsb0mR8A=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="GpqP/klP";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zSRDhNu+;
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757377951; a=rsa-sha256;
	cv=pass;
	b=7g9W4TcEXMgneFg1QGw8XjQ+UHrutRbaGPMR3jiTKWFt3M+r4U2YcD/f2svzFQpIzqJvWW
	toztOanzbert2aipORdabyNTvHPh3hahGNQqd5sghAWKmv12ry9995wrPlDQMyENDp1BTp
	JR9LOghHYrbwKp+QlmgDmO/1a3oEa7Q=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588LBlf1020698;
	Tue, 9 Sep 2025 00:32:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VODCTmjX132Q1vQUpU
	Ny1QIjfeELAhMh1aiD8l8TiiA=; b=GpqP/klPb9eV67kXQGljgbTZT2wXNojoDs
	6/aHPLrUdU0Hslg5ms23SHZDpOsW6BLWpDprjqk2Qz/reMqlV266m6m4IQnQc/gK
	auz8nVK9lYwp5vkjF3mLdepKsFxov4P1j+p3LkKn1//ewT18CFi3rj0d50EmdnPR
	YD6MFp/jayJ4r1dtE68fV4ee3LK4Q/5yXhsttkX67RncyLzjieKjGgUU7LBUtI1S
	aFWoIx0n0z/mBCS3YboTdbEbkZpuQwbDjpsqg5x6s3hrC+ssyAm9mu9YGqYYncSr
	oEyfflQHA60J6D2UEgDt0srAQaY4SYa7fXmA4IftK5PkulCt2w8g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49226srskv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 00:32:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588NLNdF002973;
	Tue, 9 Sep 2025 00:32:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdfdcuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 00:32:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fHHi49ZvrCDnGMzDdIA26+FStSctB1cCErOfM0j3dZ3ZbewFyyBGF3my97bmXtLwGDb1XyqRYWwH7hSWQlK5No96CTWViHhJwWtcvfEfJqmLEeAbinQF4N3x9rKL8szCugyeAZRrsAloeXyHcCB9fkRzhe32JhQyn+4WaB6IIzDPtB0BN06JS8tl/KolLul+6pl4TTQzfA7fYMV/gEQF64n7GPVG6DLhxhwv8w9n7DKlI3vTaejPQDEVXM90is/vUHmEfCN4WueVD6c8zQ++15a9wsIECoHSaxyIfFHvPxmiUX36Wr8J8EFKPCY/rj+0eq06EATg5SW+WIldTGtplg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VODCTmjX132Q1vQUpUNy1QIjfeELAhMh1aiD8l8TiiA=;
 b=eJY7mXtfKkVU6RsX6caCjzq5JG3RDA/ePzBj1p3D2ojiP60kLlqF5MnrRXBI4x9CAUVKPsf7GnQbCy1QGyILhny4Ge0IS9O5L4Nd2+d/jhJKZpc6ndtLrXT4ma+23ALaV+I5wlq7TDMG44vuRcOKxfUSXkJt+YmqgnXLhFj2TeJAn5IS9dKF2J+HdB0LNi5aKIcgfcKjutQt8lV4qbdw/eE9wKsOalC6r1PW/KBBWczpcCKV7dLHEE9zDqWdFdLSn+6ESYBEIj++DhzXxb/HGSd0BezObEdMbZfPaRGSYolO4E5amhtc01RDue5upJtq6822ypQpGz/YZ0qtaIX4TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VODCTmjX132Q1vQUpUNy1QIjfeELAhMh1aiD8l8TiiA=;
 b=zSRDhNu+MJJSBuP+GV4ckNrUnpwK1zZCHpRgwt050OFL5KTbiDja37jsbsqB/H+v+g94Kop4ZQUOv/emmYEftld6DldSlNtc9awKkvPSlzDJPjPAhnP7/1v1mWVgTHUYrZxafEgODzWdszEogFTZMgfA/J5Bd3WE0xLqF+Gq8Hk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BY5PR10MB4132.namprd10.prod.outlook.com (2603:10b6:a03:20b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 00:32:26 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 00:32:26 +0000
Date: Tue, 9 Sep 2025 09:32:20 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Rik van Riel <riel@surriel.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add Jann Horn as rmap reviewer
Message-ID: <aL91lCqH3f_a5EGI@hyeyoo>
References: <20250908194959.820913-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908194959.820913-1-lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: SE2P216CA0149.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c1::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BY5PR10MB4132:EE_
X-MS-Office365-Filtering-Correlation-Id: a78b69ad-b2b8-4a4c-7a7a-08ddef3859c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9QB7bkRd2sGjEo2Z0RH5foHr9aRSfdXPLy21oBn/95uYPwEacVCdJUjJhJ42?=
 =?us-ascii?Q?R81O633Yx0atxiADSXtGT6zTQ6EOlSzV/FVhcJUTYxKwxS6sZaoD4Gcb/ICK?=
 =?us-ascii?Q?G0JG3WDzLhbwOaqOtgC57T/YA30GLN6X8usqnro9GlMCDtyylWAfYQokCRHM?=
 =?us-ascii?Q?WQgYy30xnjmmWWPpZ7UPkhh7DPUGyTYqfebzmwHAXHzyVvu+vwckw/8V+F1c?=
 =?us-ascii?Q?x5I8HAOjhkbO2Lk+cGtwYXgVaM0L0ilCinprRSWierke58xj/3Sy0OEwk8+G?=
 =?us-ascii?Q?A7urCfwuYoIRRrlckqKs5M9dL/KzZTdhufRfoE6UQB94Wls5A+yYa+0z651o?=
 =?us-ascii?Q?HVkw1yy3jmtRmVGQ+gQf5luslmkcipP/2ZnScXKTOZk9IR3uY7g86tmRTUfC?=
 =?us-ascii?Q?FCRquz54L3TCimiLfXtztbnxVlglNB+jvfuVNlGEEVYk7oSMhGZcYceYCNMO?=
 =?us-ascii?Q?LTFKVQ6ZVV6T0blIAlwgXem2yPJT7uongPohhkGw7cXF/HkFGMvgvacEDVbO?=
 =?us-ascii?Q?JV1tTbS+So78rllZ8sp2d15O+mTXhRzl12rUTBmDVeH0MrOPML03A9jm5a+2?=
 =?us-ascii?Q?WeuSo6n8TXv8TQ2aqA+C5XflG5Z1ICeDV0hjqh6ozwoHwVCzb/TeS6TOLRbF?=
 =?us-ascii?Q?HKePOCRKAQugw+DIvkj00tfr37xib68Mo4tnBttxQ48GUGbW+VHeYgEg1ciZ?=
 =?us-ascii?Q?haGwGA1kQppEb+7XbWJ2OGZ87oY/MYwOauHkWqJl3ExBfD9FHYh05fEORPGA?=
 =?us-ascii?Q?5nrioAFibbguTCXy6IO01hLOU/SzNs1N6K0eiaE+mnN8rvzeBZQZsr+3csrx?=
 =?us-ascii?Q?nsCLcA68bIHMJ0T2+bkrRrvj7uv5WxzDMXQzwUB8IDon1vl7jCTOV5MXsdOk?=
 =?us-ascii?Q?XKShc7j3OmErv8SSMRJ8FXeR37zyvRJqp0kKqxPMyoplAN+zEhp4kCUMtidi?=
 =?us-ascii?Q?TshXSIeKim6IUhXTfkhIol6ElmZGMxJWlaQptwatVD9MbewgBQFSbIqaDETS?=
 =?us-ascii?Q?62G1dTVU/BhIuC6s3ZxCxsajIo40nsM+ZGSDxPZhdTFuPiN1+6hZgrm2MgAK?=
 =?us-ascii?Q?/4GPqD/Z9zEZiHyPv4KUtM+sOKOFHQ83XGBmzDCriTzWIMSA2JPuO5I9b9x/?=
 =?us-ascii?Q?IhfUYFb2W+9TrDsgwk5Kw3RMgXj2pfSp//YwO+9hjndjyahMofBwgi4L6s80?=
 =?us-ascii?Q?eNCnJi4w+vZHi47dS7RGfgYJ/0wFmJmHxaXd07faktDf7DE2pZRQOHXn52On?=
 =?us-ascii?Q?BEP/payohAwqO7dRGXoqGM716XSk81JVWtv1minhfphkn4S1esn3J/EQ5d59?=
 =?us-ascii?Q?KHYE4NLnK2rt3rduxVRJazTZ+npqW1GP/o+rG4ke6d2wI926TpxqK6J1Qibv?=
 =?us-ascii?Q?N1pOuisq96tHz1SOl423ZS/hWg0DEyCtjXwnpxiDyn0VPCjufD2K804AZWsD?=
 =?us-ascii?Q?CzslQifTQXI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+4Vc+TkN/Lv8+fvP6RVoVM54O5tE1RSA/u4o80f2dajVVfrntfR34v7Djd2q?=
 =?us-ascii?Q?cvugxR7c/kV1jPTNmVRGE8BpE0pfFqeaiFX681dLSLtPwCcitJK+H5POLxFi?=
 =?us-ascii?Q?vzs3y8YJVpWJzaQgJAdiizUJQwMryX0utCH6SAPfpRGGTSKJpHzT3SvJzlU5?=
 =?us-ascii?Q?9iaYVlGsbvHgzGL1jrhCqxKFEk4DWvZvERi0PI0BhtL9h8+uMjgt4wvcjHpz?=
 =?us-ascii?Q?CQCUuCruNIMZTtLyzASl4yaUJwMqA7KAPhqy5ko+Xyp0hI7F3QkDsOam1mXa?=
 =?us-ascii?Q?yaHrsO0jan7ivvxWECpUusmYtVUW9ohXjNATfvvmfuYw60Q43MT470kSm3lE?=
 =?us-ascii?Q?yB2Khb4BVp3jXyxs3ZhkDSaNyCQqdqy60K6PdbQqrUykbkCsvmvcwnMtooNm?=
 =?us-ascii?Q?/xiwCqqnrsBYN1YfzGPrJrWhilUw9WTHvXQpdeBKAHodV4MFAJMF3sZP02ix?=
 =?us-ascii?Q?QweIjLuZlwE9rhjeoeJRkC+P3tOS8PS8P+KEtns1y9S2o9zyJVt8FvRrUSS1?=
 =?us-ascii?Q?OdP1OleL0W8RDbOuu60GFGhyRoz0gATTp0qLTCbtso3GATkoOBtHFh50OsEx?=
 =?us-ascii?Q?Wxt49PirqZNwy7qaxEvbKAYLWpmBLTqzn9t3rErcBH83ehzRbdhZitnp+Mk0?=
 =?us-ascii?Q?C2MSSqSRaSwanCdkyRcBirHBH8vSsWbBMBW3X7WnCAgloSq5vFZm4C7PGUoF?=
 =?us-ascii?Q?vKflTdmL6DgMqrtB38FYVjF6FKtriD0tJ59F8hC5Mf6zaLFrz3u1SpolHarl?=
 =?us-ascii?Q?xlwK8WI8h9toIX4l08Typ9myWgdM2L0sbfa75Du1XDkl0vUzk+KWCN5vVFn1?=
 =?us-ascii?Q?wh5wRXWARdL+RkCy1tFUWCATcJ0mVVHUOPPfoCxJFlMb6JLCXE2BBJ3K//S8?=
 =?us-ascii?Q?v6S72rhgCWJ+iPwhxNL14RdOOE+D75X7xkOqOkuaFD1mJqO3iAqXVscnvN4S?=
 =?us-ascii?Q?n0wN9IyemNE/lndI7T7T3lflWjN7EY3hDke4fkhcPrgAbjrl+cIPLRH8MfKp?=
 =?us-ascii?Q?0hZlg8EHKfc40cFC48oL8YLbszbir/Lc3QohtR79miBCvByrmpzh3g2GQXOw?=
 =?us-ascii?Q?7cSJmP85Dz1sj31UqrI74SBpNmiYwi5lxCL5lU6DY5QyHnqBd3n2L2hUjDXf?=
 =?us-ascii?Q?Uaqc6dkm3150lw/Y5IAy5WvI//mg2m7xoodmoBjRuSGk4/SnfbRbrAquOnix?=
 =?us-ascii?Q?5/M8YwpicBrmd59LFtt90kuHtfyaW3vku0HeVNJoAkARAX1S8t6p8H9LKUEr?=
 =?us-ascii?Q?PEpZ19sjAin66ODbzO81KRMJl/ZYKwlEoRqoh3WM2fa9QnX4qBUXQIg5Gin9?=
 =?us-ascii?Q?K/aXgnd366t5tIs9VSYZmY9plfdi21Br53vCw4gyffvwlHAixwm3Spj8KAX8?=
 =?us-ascii?Q?trNVHv5iKSV7d+7AMr6Hj80vwd5tl4EfbJnGjq3J3vqGP0tozGQneVacM804?=
 =?us-ascii?Q?h3bD1dzEOLRPlr5gfgAezi1TzGUwu1xC5zgP4FMLU2DjRsDGGsGD5Y1mse38?=
 =?us-ascii?Q?caYJJzVCLI/s9MWO7wxKVHxJMN6RCg5QYCVpQwrDGpbxQ9yBlmx6Jh3VnsCU?=
 =?us-ascii?Q?OZCD1f3M4vE9td7ljRYEc3LIlOmiLDb5tW+T+Hmh?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+d99ZaATZuy7GY1gQN786r6V7rdYhl/LMBcoqmbEyUKrCCwejrQ+Ln65sL0oVeExmsT6GC129vVQFTl9/2skFLe8OUYF/1ibCJvLK6lizRa8P+UQb1Xt3CiZ9VRBgF597KtRIyQ26tqKhkRhxQoFzqyDt3bXiiHuuDAv8eBRBqDmGFbfolb81tYj0rmcV7qekclVFMnlGVvXh9/5pLz5UaR4eDs4riIIDywui8C0jCVy9jpMGDcw+xAIJwL6d/EqfuTkP8y42WSA6CAECtWjGGXmP6370B01pSNo7q+rwM01Dv9VxxrFPjn/LT1eRfvpFGuqz7dQbDcGhI0Jh2vZQGug3Is+CgZvlrNhIhZ6pBLvS3/0GRdmj7/096WO39JFUzGw0uAOWDUTZztb0JYyhGWxQvMK7YqziG5FO9Z0u72t9ff6R1bIEc9p4FQct7RpZm4rb6SqdIdzJQLQa9f/KUPS3I5k/Xg7Qr5sJKz0XPLdlblc65H1231V19nNOcdxH8/6F5Z6yzp2RbzMtc1ejQHZ8G7KGhCEwWAeA2sr/8EsqWBzYH5UGY4UvyMUWz2POH5FRInsrP2vdnuIRgYQ5U4j0dFozEcqDzHfGmkFDaM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a78b69ad-b2b8-4a4c-7a7a-08ddef3859c7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 00:32:26.2751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U9L1KibD4CPBxKfgp3pJ+D9onZ1Hb9fKZapjA00C7atGTGF70aIbF3sWIIhXeh/3enDBJnClh4p+CIxybIe8VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4132
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090003
X-Authority-Analysis: v=2.4 cv=QeRmvtbv c=1 sm=1 tr=0 ts=68bf759e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=JBU-24PaHKBSD_OOYAgA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12084
X-Proofpoint-ORIG-GUID: CueswuyfY4I6kZjrzHOj5Md0V9sfm7_G
X-Proofpoint-GUID: CueswuyfY4I6kZjrzHOj5Md0V9sfm7_G
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OCBTYWx0ZWRfX989f51R2gMwy
 xEe8Z2BN5CrIIytMu5ZziCYCO5rEKp7XjU0eiYcyN5t+klPkG59AVa7EpUoSVm1mMMDDOnEXwpB
 B/bN9AU6FLQvS+Z/n0UjlLrEXW/ozvDlSWxwuV8lXsuXm4K+y9LAHl25YmYRCt8CFkgI76vN68o
 Q01uzWGrpU1YHQgDq3Vrfo1ydVoGcRKZMKp9M8rx38PKaGByEgplKfF3s5bedHHS9+79kMTOCVF
 bqFEcvbIuy1sD1TK1fUQmkjzNrk/bWJJYbOqtsTMD8WWqAJBbwlPnix3SHrSdlAhbc7HtaXzWb0
 mGVOQlCiOa5HjzFbZwp3gjaB8AJCVUeoKI+JkQvjWHt2WrDXeKNfDH5Sn1Uq6MSTZrcM9Ff6Hx8
 PSGhyJnbCa/oWHjTPobIVl5sfTIY0g==
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1B52B40009
X-Stat-Signature: c9ct5579iaricf5f1ejuebxfsdfqb7uw
X-HE-Tag: 1757377950-411848
X-HE-Meta: U2FsdGVkX1/DSLbXeWTD3KNelR+9RMO0gH3w2MjEnHzZkZfAQFgrQZH53mqgcKr3zbSVtRYeQDujvx48yvdvDJSZHELc+5A9PyCC7B/4V5yngxNalODUxO7FOwjtTHmgnMnHGTu3372Q65Mxb/mkC2csBq7VlAPQxF/2lHVTAzArUnb1qzRoCZY2KdfimnSQ9HsYaXJURM/SC9Qaz/biY2iJoLSOgSzuHEbgybY2Yb88119D6+3DXyZidMyicNa9iK2x8Wei+1ivfT/+B4WM3V/0yor0Nasi8aznrKIxOGsZWrzKtVMAPIN4x+Ud7ByFW2amrHkIqJhUbmjb+bTjHwACqmJeSy9+SzONqwoJNz+RX+OZ6aDb0HUrmANqUUc9P2xlh7w8RJQG6j3eMTxbG9mk1e82sozN6eAbmKf67Vd3o8JRoTCzG4UqbdItzDswfDGF/9nwj8diHVsQQzbTqWJVZyyktD4++MWmcB1MsMH3rTs/zsJeutgqs1bBGVHWz16iIDOYVz1PiG9RDpvv9Mol/utE68ISf1zG1Cvj3a08eCiAsQllA1O4vhZGaPfh4gVhw4f3LLTBTDEKxS/LOgezqfDuc8eI3TNm9VVkaoUe+9OC8HY1HD87m1JBVFFM+aKdzBQ1SHuxCrhVnCfGZMqAJJhI5R0k43gPfDK+tsNQLn6y2fB1ray71qM11EthYHNxbp9xfqKvjW8GrVXO4i7rlDMv4WFtpeRXoJwQ5wdaXQBhKDtPVX18uSSUyjecPMkQ9gPTt6EVEwZ+mKTnjmVt8uO86v6X3acZel1TNrms5m93mVkQonQOKDI76ermnyCXM01yNXMf1cE07MauFIMP6Zox2OHayar9+sC5CKTfA65Zno+Y6uOwOuQ8TNlsy3gq7Q4JjIe6A2lovKR1WKefctFWP2TcfzErcOEjKMnklMjgU79FaFt796mPrNAYRqlEViE5kkqxnkwo984
 6YvhQ8cL
 1IWWVYJfJjhG/XlkFPVUh/llBgBUYzLss6o3aRWX0ymgXtlWq+EEFU8YN32ejQZs2erhQYzeJ7Bsob47qRbSbLJgfXcp5k4Ndn1QVWTPQKalGLojn2etsCY4zCggr7DtC5sFbPpVeBrPgOxXWudCJjG88hmZTis3mo4hsfJk1/HesPoC4Fh+TcA0Y/grwFwRerhoGvTH5j5TdZorr61l0Y9uUyq6SDXda7+qtv6U9Z9fXc7RueztFRsKZKUwQeCg9Eh6cydpFnFVFGXIjyys/bkW8Df4tnqNgKGm5v9GKoJyZhdmgg9mwSgnLq/qbWefN8dL/DFnecN8DLxc00xBCsJmifq8ApbDobPkxl3wZUYHBiAKKqqLbzHRd/ef+0vJyHJa0+V9zz/i/AMlA69KCDoF3WbyW5DNFLf2xmgXqVQOBTLu2XIcU0CDPkP662faCQ9Ed+MgBHuOt6zqVDNxqVNNXl+zwXfEkV0nKyXqXtvun9lqxWcoRaOUC7+ITa8aLL/+mj11ZD6z4tqnUwQPl56m1mV8wSHNepl2ifp2cvHRtPg/d3u/HYMvGG153qRoZHRHxwYvAJuwfyZYniViCuxqaj9pKnsvakm0wAUKF1DNKS5oaWWPXdb5y2is2BWGxqyz0prFKREUwU05M/UVFWpd2eTSxN5NH/eWpJ35sui9UJWNzekQj31S4cfoGHc8qH+2DLrUVNG0jaTTmvlPChFO1gjBaXGf3KG0NJ0UOZklrOSRrtj2gaUDB45uoP91bYTg7FaIHdg17p4bi5GOwlbGJjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 08:49:59PM +0100, Lorenzo Stoakes wrote:
> Jann has been an excellent contributor in all areas of memory management,
> and has demonstrated great expertise in the reverse mapping.
> 
> It's therefore appropriate for him to become a reviewer.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
> I spoke to Jann off-list and he kindly agreed to become rmap reviewer :)

Welcome!

Acked-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

