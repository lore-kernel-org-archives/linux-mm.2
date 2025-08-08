Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3547C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 15:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442696B009C; Fri,  8 Aug 2025 11:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4195E6B009E; Fri,  8 Aug 2025 11:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3089C6B009F; Fri,  8 Aug 2025 11:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 207026B009C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:59:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B946DC031E
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:59:43 +0000 (UTC)
X-FDA: 83754050646.02.9F28021
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2045.outbound.protection.outlook.com [40.107.100.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id E8A754000D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 15:59:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PD3QLmze;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.100.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754668781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/yzOv+VFpS24c+g9LQElbT+rPKCV272UIPsqgV+I3E=;
	b=IQ9+0JUAL+iPeJuT60OyN2ThdKeK7IKCOdq+7SVlfkCHBPSs9qGpIx74Q3qIowanqgGJZg
	31kgb7BhVGlEAG+xOwtivKSm5M8h4oJSel01oZ/M8wLLihzqVT6PHvM9p9Np8up8plQgaF
	hKQn4jQTdKt94svrRlKxObDETXuYxS4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754668781; a=rsa-sha256;
	cv=pass;
	b=PWC6yE9pETFSexAbf2oEkbxjaKY/tvM+DzYnULjnxq1yQzmx9osTD8I1M+WFcIRtvBu2H1
	9BgKeVM18BqehqxyRIcyorIuKtSHWs5F4Mqwv6VqBbgGuFNuyCjAaBl6yA4q6AwlQB6XJe
	N6epcQA8CKjU4tu63N69wdcWXHHXcVQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PD3QLmze;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.100.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gOXTCDmpFCo4xHbEpGs7eeseTm6+LEj4jtlGxuG7Mi6I/h16ZLz8+mWeFE5QkaDZRBnE0V7K6VoDzARlq7Pw7dnRA6Bf4kD+ed5kLHWGsbnOc0cwalejr8J2ySVh+5f0YuZdc2OrzFmGkxGRk2VZlydhyCksTiuZpTF1uiFfYxit1fXHWgPkkNwaeW4rN3MdjoRCVAyvvVi+XThSMRwXC1q+kSGKEunpIxB55xDAwG/5gxfVgoVce5aICDfcRFhKYxhNdIMOQ4nTA5+R0122KknvdOMR5oyPTzfKVHnuLtSGzzsVyCPZczC7EeNzhTbEGvImQmh3sr+IgOcTyq1yGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/yzOv+VFpS24c+g9LQElbT+rPKCV272UIPsqgV+I3E=;
 b=AWUUuxYS4n2pPHIVsQhDbYWdbWTcc1CRY1qI9XoZWtSwVlCdhGxko403PjGzYhc0qfiM278W7xqNLPY1Du29aMQCDFh3m8JA/CaA8ametJLXMHVovtkShAeFKZSsRl2c9vTyn/FOYY/KXZSlRKrmyPqwmNM37MWh33RUO+8xutKqJfKXtsJIEXZhk1eeo0znby8mhBfg6FvIbkZSIE1xGZirahgb8IO0uojsV+Zap5vZ72xheCx6As4m40GwDkRYYCjk2wuENbfy7xGLe7g5D7iOaR+URtxSCuDFvTl1UvfOve27y6n6tybYMc3kNbH0HooH00m5NEJwGb2bSkzZXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/yzOv+VFpS24c+g9LQElbT+rPKCV272UIPsqgV+I3E=;
 b=PD3QLmzeOH2cmu8fLCXg4F08NzKVcsyM3xrK9dpFXSC6V5xE7Azm50hF7FJ2QHRCwhNq2tCzXWtTzX6LaKulnZTy8CyrCrnurBQ2SFoK6q9t7sRVq+8+I/wutASzRZwmTs1nywJjtkx3bVMQxmZIrTqJ+Fh/67A37860cZD2/dhczUhDM6/tYTOYoJ6xzq3/a9TCdF8x8/wXzjYeWI8JvC17WQ06hJ49W6fXpbD05sMrHHSbN4Zo+Pn9Iqgrsm2EkBUczVyUoAILgDyUSpzrZnr/fzedIX/gdLQQ2UpsCzaNq0QTngSYKR8GIShX9eBZ903pvTjPjqYCt5hFxMt+Dg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB7541.namprd12.prod.outlook.com (2603:10b6:208:42f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 15:59:37 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 15:59:37 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>, <akpm@linux-foundation.org>
Cc: <david@redhat.com>, <lorenzo.stoakes@oracle.com>, <dev.jain@arm.com>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] selftests/mm: do check_huge_anon() with a number been
 passed in
Date: Fri, 08 Aug 2025 11:59:36 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <207BD61A-5561-4E8C-B867-D1CFCAD37509@nvidia.com>
In-Reply-To: <0467FDBA-A2CF-4CF0-ACCD-760ECD30BA8A@nvidia.com>
References: <20250807082707.30647-1-richard.weiyang@gmail.com>
 <0467FDBA-A2CF-4CF0-ACCD-760ECD30BA8A@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR15CA0017.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB7541:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f0ebe15-93ee-4d87-9a82-08ddd6949370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jCoKOrSCWiAOuNZwLlMIFk+1Mj9GUkCMH+kyPoccsRmJd2XSbU3VMItbqPSa?=
 =?us-ascii?Q?WqVm0QAlc4bLaFSCgMbEIdmkqrHi8i9LEEXgyuIOacck39d3GOgBMZKvbGKg?=
 =?us-ascii?Q?A9P9MnQ7bnCM33yqzEbgp5AJCIZJaJvfVgOdW+CgoFsIo7Os0mkCWjWn4KNq?=
 =?us-ascii?Q?ffKKPaZhSi8PzEVgtWRMa9CX1HMSeKWnHQjA6C1Zy9n/cLDFI8WAPol7lWgr?=
 =?us-ascii?Q?VnRl1YdYLV3QaBMIwTiQElMBj4m2QQcE4c3IvFpOr/wvNCU6DT54YskGZQ2d?=
 =?us-ascii?Q?luO7VOSE2VSyser0rkkJtCbeumyd4NokD4naajFXDmL3hzs+NQcZ0QJUEOsf?=
 =?us-ascii?Q?Ev6yg2BfC++uGfT8SR7XjAzaCFj78rf239IRAmIIXSuN7QlKlhmFvm135AVs?=
 =?us-ascii?Q?uy0vohlOKkPAtLd/jG4VPZbrnN4vysWMon8SAYePD+jjG4PENqCuBtRAPC6N?=
 =?us-ascii?Q?ofth1VnjCYwDOQmPqaHbvojI0ZG2ePuGGbPt60V1Z8yCej/uXCuDnGHwLw24?=
 =?us-ascii?Q?uR/phbuTBcHWNvtzA49OvxcoAZa42AOfw1KyJgpM8j9mNAdl1fFemOcGJNes?=
 =?us-ascii?Q?jsnAbQJEYHxzHUBE+EXzTzgTbGOa7nn+n6uO2xmqqcocv0iKFxEN2fFTlOgg?=
 =?us-ascii?Q?6873mnuVbxFRAtQee7KiSrZ85yNupkQIYMWe0Hi9Wbxk7T2ISFyu47xU/apY?=
 =?us-ascii?Q?Vg7Nve2itPdZ5pjrshwP5l3fuOMgjQFy2EVQ9SeIbWz9NwUIs0NG7wpUpG4U?=
 =?us-ascii?Q?qZKyM7sXFHSuJg0aWg1zbbPrgZamkXjrKErHOyRfv35z/1W5qfK0l++vqYdo?=
 =?us-ascii?Q?CawcByehj4P03Ek+qsaRgdCqQT1dlkbvVv8SAupub3KliLMP744d8Gexz4P9?=
 =?us-ascii?Q?gajsjpeqqv6JR3xC+OMWB/Pp2RZIHNnUCyroo+tvT8gqBhGOI6/Vl7xSXAuu?=
 =?us-ascii?Q?QMfo3W0/TYwB/ou3jt+4Pjf27uFkaAI/RoL5Q0rXNMTy93JY13pMcV29wxAE?=
 =?us-ascii?Q?oC51FJRf+lAdbN2oi6xR6opNiRY0B1GUw6nl2P2IrH62gtzd33Udmyyj90vK?=
 =?us-ascii?Q?JAg6NOeTNMD+k1PpvCK7OLefDoEZEgSrit0Hw6nuJdooAOE0kSUwvWIBhQXM?=
 =?us-ascii?Q?iEAqZQhRey6n4UblST81dQHsln/iwbKy/in5pPcsIiPT06VF82YWXKhg426x?=
 =?us-ascii?Q?jXcRQVX5+xsaIggPej+NEIB+Dvrsgi6PXBhF41QoqTZuhEmoes2UxREPb9pQ?=
 =?us-ascii?Q?tf46GyZYu+C6cj2ukUq8e9C09q6Na5M4i29m2N8OTgxqxL7//pgiwJjsT8Pi?=
 =?us-ascii?Q?r4jPzDRrDDW+8godGsgR0K9qE++MPb4/NZolVaoIE4eRRa5nACA77yEGaq/z?=
 =?us-ascii?Q?as/74a8u+nvsEltNYTXiuJvMyZA/qABxM4rvATPDQA970TYzrKgE0czohH4C?=
 =?us-ascii?Q?t5Es88RouNc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wKXkcyjx8rrcKtOZ2iZ0XUn/aEqBr0Km7fuXKH5leY98TtypFd8lMVNzysNj?=
 =?us-ascii?Q?eXgFAY4Xy/W7Ze+CCRCh7JUywH5ndT/lOkoQzRWUEjRZv27kB86CBERFxAou?=
 =?us-ascii?Q?DSVxh/vhl5m//fA7cs7hY4e8/BrrpVNRdNy2SE/CXTSxeVcUACOS2VHZZTee?=
 =?us-ascii?Q?xvAa00IQu3Zpta1RY1O28Ic0on0QczaegQqF4pQmCVBIbz/J/foy46GAKIbv?=
 =?us-ascii?Q?S4Qn17HA7LZ0nyasFq+UHodZ74wmM4lM7aPX48RxIP3WLQxaybE/Wp/2Gl/s?=
 =?us-ascii?Q?HKVDJWJaNY5s7f4JkFWCs0EpBPu4yyC2sLnQ7lLlai10Y4wYnzB2eOPyiEHT?=
 =?us-ascii?Q?7pYM7MPdE3bMRp+YJL+Cl6/6gZNsmaru22Stawd/qSZzUVCanQcLtyjl6xyv?=
 =?us-ascii?Q?/KEaQGvypGPBKI5CsZPeD45NGy1yoZnA+DJEU+ghs7uNV9p5Z71Zr1qnXMJz?=
 =?us-ascii?Q?XRtpDli2KtXcjXtXP0vH9xCI6NyPYa1vtQU8I81xyN16fDF0n48c+dVVVOJv?=
 =?us-ascii?Q?/twOvreqDtpKaiztqpVAFl5km6ip5pF9DSKOZemTSnLlBXjTp+7UGYlEpTxG?=
 =?us-ascii?Q?erQ4nG8SPw6Jyf22CC16mQkq19Yky09XNHA8ZAFclIUfTgEuBR5PEt3R2TM/?=
 =?us-ascii?Q?6WQBeX3ty3F8XchqOVVpu4tM1VPa63lVDq2Kl17h8Wh3kJBVXDMwwZCQ9Vjy?=
 =?us-ascii?Q?ngM9S/tYKgMybgaPYxtBHMHQDbucHKmXSIW0jk9y80qT9P0SMS1s6rnTO/3l?=
 =?us-ascii?Q?AnxtV3OD0QYzHLsyRBV1jY+LEzwSrS/ztsWDlSadcqRn+2pA0ItwIuCB+pm9?=
 =?us-ascii?Q?ZJ4jOl4X/657GNWOFMW7d3TPhF8HFRY+0rEOaP97NIyZuyvGmqGPRCSk5Seh?=
 =?us-ascii?Q?wef0DOwfik63iWgKIEi5pxlcbk+CVfBXvcwdunzOGQ3uftBfxqzEYAW+FsTn?=
 =?us-ascii?Q?MOKYpPxLTP8TnPUuhfKe2mGz4FIIATeP6HdpliVEZvSuG5wU6xGEvM2Ph28x?=
 =?us-ascii?Q?+EQYLSQ8cRLcxkp8VjNYuReKKHdfoEWlAWHsMr3JxHx72B2+iRAbeffMbkbc?=
 =?us-ascii?Q?ENCfH2EVUkEcEcwY7z1Mp6E5W2u51jpr65cUxB4l8kit5oAF73B93C69QYG8?=
 =?us-ascii?Q?WZNa0I0XZT8Z5RQmXyAnyRwNLuxL0s1zH4lrzNzniiGqkGopObNwMRzj95Zt?=
 =?us-ascii?Q?p8WSudkbHSihM4xt22j2me65GN/DH1/t4rihpBv2V2V59MS/DsQ+Dh0cSqFK?=
 =?us-ascii?Q?fB0iPGq797JKYiRutw5YdgFftZms1QAsUF67O28VAqhV9EH9q318wL4hJ9Fa?=
 =?us-ascii?Q?dFDj3i1gy87oFmYwARQ9pus8Dx4p9SiPtbW/9zPlvWU8DHgJ7wJUrS7vHHVt?=
 =?us-ascii?Q?NSpEwOv6zocc6sJIzI3KKBBRXiunKfnvHAB2X5ciGHOxlCWk5rMIbGo/SP9k?=
 =?us-ascii?Q?U+vWdXz7i/qri/Q6aqEezh5Tk4pKyBmFRJvpCEmE7apguFra9VumWloWnoYA?=
 =?us-ascii?Q?ql9jnrir5Gr3kIPOuCLvFYY31ITIepBXyOWIeb8XjOrl0gqAirAdohWJt+CI?=
 =?us-ascii?Q?iLEyzIvBBATelZm7WPxSoU0yTWjYvPqD7HZzUi4b?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0ebe15-93ee-4d87-9a82-08ddd6949370
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 15:59:37.4777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jwom8XbuuqkbxTW+JxfiA/IQNQs9t7umQAn+EzQuSOOILtEWdrx/9ftRuYdzZPSP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7541
X-Stat-Signature: yrszpeze8qry6ifd9ef7nrpxq9napokx
X-Rspamd-Queue-Id: E8A754000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754668780-819782
X-HE-Meta: U2FsdGVkX1+Mf1UDMMVqNhzFAfB3o6knglcIybTABQqZ1hU73fWLqucS/LF+ziMowWxwiFNH8GR3+voUoG6Nywu98qJsNZl+wZzLFtY3WxGIDs9DCSGhos8IQn+JXI5/h+CyFVy9Dn1c+or79SiEhzeFIl90CkjvEgKUo+CUqfYeauAkDLWQ3TkSrw0gyW+6ATkICjJct42lGHr16bzts+S/Abl1PhPzVRBNtD6hRMPLkGcGLIWMS4eyRhuBT4GMZyKo8nxuwT8nA6d2nq+1mPIo4DliVKdWYq+nWEJC2MWzdzu8Jk56mJHPBz8g3i3vBERJt5mPJOF1BU2YCoR/DyfdNA6pkdXp4tH+YLXBI8uDJQVvejx/RE6EjTMfgNbLpbCe74FVs93SpChiWElIgXny/lFpBOW0qNZRnlD0qSm++JEpRDoM0o76Lo4IlruRF9abCQ2LXF+2SiirQbpKjwy1Iy6ZolqruCAzXSNs8Wuccut7OnI5VPP23OxdSzPXP5K/VxtfPwes+U+iB2epqQRNRjrNDlcLUcfue2uJBZn367CdwnaN34VD7MDK6LCzFal3YILDimKfyZFtqrZiH+cU9brIoVJfuQZx4uy/26cbreviuIeZy8St03FSXuBDMX76x9diBGUHN+//4iXdn9oR58MuSdoLUpm/qfz8i8vXKCAzUS3QTmfjfHshaB5AMBBIkCUdAaRzo8kMLuTPbNJPUWZlQateQiEaC/KIQtHoxFwBOG17uZwGfa5Jy5JFcbeK0FH0JwF8/tnreEzHcBi4zL/Lw8K7xfo66MTC8GR2PIjEcDgxZC1aPJgzkzoZ+umUnRKQdAV/HVNL0AtL+ZfCeM6nfJRY9Q2zmUaH5HTcQCSGyesEWb0AsfMx+ermQQHE9ttVUR+lRKXFxfpxMxoT+IjkQdaLAu7hbZaOmJtdj6aQx7TAgs8b6AFJzdf42vIUcpSV7PWVS/h1iWY
 wgneyRVe
 iluQsLVOyCMzlHDl7u/mX0w42pIReEffYopDvKnFf8fCplf1S4p8eqOk1iQy+7ALtp38FylJKL002YSBmQwlUlEW1lLYdnnEGR1WvVGs39Hmv6dYUZ0ZUKRtpTfZR+Smfj7scu3xjHaSD/iPCeeyG8DPBCwXSSHqjFKaAtN5M2ocreno9mNhbq+cacRe9fgqYY8/dvDgZWLUnKhus69LXB+Rqx7IMpd4l5nAGx74SD77I38hadnu+DTPsXA0gkPJZ14IW/SCWuf7q1+DMB4pJJg9ZrWkcbF3DT/bjxlGzvFFs0KRSknbuC6+Vjqid7gzCK0JDk1m9dug+dtZwODz7LrsKryWFm3VYK8gF11v36kujeBwf92Fdrg8dXEEfO3YOHjCGaSfE9MbmNtRB+k4xUkOS3hwbEd6VSG4VYIRgQD++D117WPVFb6OBau/QRU8CRVIA4Oo5q782EtjHBF+OBOYHuDdY6w97lqWDiMdyiuqATrYVMx/cAnfr5wD0WmGacWkiNYWhGJkH51tuT6q6zSGNV5mStmO1YKw1dsBorkOC6+SOWA1kx8u4a5cJTKXJKj5kIqrVTYkWveG5aCTKHQHqrYCfmepmr2OBKyZSWfSr3Ke59LoP+exAAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Aug 2025, at 11:56, Zi Yan wrote:

> On 7 Aug 2025, at 4:27, Wei Yang wrote:
>
>> Currently it hard coded the number of hugepage to check for
>> check_huge_anon(), but we already have the number passed in.
>>
>> Do the check based on the number of hugepage passed in is more
>> reasonable.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> ---
>>  tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools=
/testing/selftests/mm/split_huge_page_test.c
>> index 44a3f8a58806..bf40e6b121ab 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -111,7 +111,7 @@ static void verify_rss_anon_split_huge_page_all_ze=
roes(char *one_page, int nr_hp
>>  	unsigned long rss_anon_before, rss_anon_after;
>>  	size_t i;
>>
>> -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
>> +	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
>>  		ksft_exit_fail_msg("No THP is allocated\n");
>>
>>  	rss_anon_before =3D rss_anon();
>
> Which commit is this patch based on?
>
> In mm-new[1], verify_rss_anon_split_huge_page_all_zeroes() accepts
> char *one_page and size_t len but no nr_hpages. This breaks
> split_huge_page_test.c compilation.
>
> Are you forgetting some cleanup patches before this one?
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/to=
ols/testing/selftests/mm/split_huge_page_test.c?h=3Dmm-new#n110
>
>
> Hi Andrew,
>
> Can you drop this one for now? Thanks.

Wait. It seems that mm-new is different from Linus' tree[1]. I wonder
what is going on.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/tools/testing/selftests/mm/split_huge_page_test.c?h=3Dv6.16#n109

--
Best Regards,
Yan, Zi

