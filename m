Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A424E7BD81
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 09:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13B516B0005; Mon, 16 Feb 2026 04:59:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF516B0088; Mon, 16 Feb 2026 04:59:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8E2D6B0089; Mon, 16 Feb 2026 04:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D03566B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 04:59:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5BC51160C4E
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:59:12 +0000 (UTC)
X-FDA: 84449871744.26.42A0054
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011021.outbound.protection.outlook.com [40.107.130.21])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4B1D8180007
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:59:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=F1MXo3rW;
	dkim=pass header.d=arm.com header.s=selector1 header.b=F1MXo3rW;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf24.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.130.21 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771235948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ty+3epNN581HoMWzYFQ3C5GBD2Muwt4FWLup/QUOb1M=;
	b=BrQ3CHjf3vtP6VwYpa7V1Q7UCBRzPQZxdy7i5QdZG8qXyGnXDKdPKQYIA4lFgrcEXzHEkk
	hi8Cjrctm3WzVX7CPulVpRElBh6Vzy3zvvd7l0lVgbhue0eDyfyGBKotWWpfG74vT6VTCb
	Y6W5tIFqNC4rtwu6rQjONzEHL0BU034=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1771235948; a=rsa-sha256;
	cv=pass;
	b=wiyhqeiQhCdyEC8NcvTNnTpf4yIMHS5nbRpXt+67Qq8flu0zU8WYIn0eKqTRoyM6KVINMW
	b0LrFDz11Luii5Gv/YOily9EN2Q2lY0ypnLwbG1rMY0gjWCW8W5D9oAtcCjdNRM68mQbUK
	DqcctrFuUXwGR8MfY3q2nPGBq9c1HgM=
ARC-Authentication-Results: i=3;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=F1MXo3rW;
	dkim=pass header.d=arm.com header.s=selector1 header.b=F1MXo3rW;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf24.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.130.21 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=J2XAKL4L0ErIPYB0ZgM+Wdl1D2439SnnPuf8qcwvgsBkrCBHXRTurNaWPdKPkc695xVb7AMMPnOzjNC6Q/VNYwZgkLSyqY08CrNVaTLIWJfczpcYkvsegGyj0IkXnf8tufUfz5Yri8QPuxbUIFuLaO4Ae/tZImq5i3r5s1QTCED9KraK0sHgl/LO9kYyja/g2xxa7pBaMnSalNdDx+U35a5ShE/fKy1SFT/D+oHddBeZUis6UhbVO6PegT5Rs/3EDtrCBFjXLI+aYDBAMGnPVhWFxDI0BoX8moTZe/70Zcpfb8KQrmOoQs5MZdSylvk/6GaHWY1mb8mh2hYf0M3/mA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ty+3epNN581HoMWzYFQ3C5GBD2Muwt4FWLup/QUOb1M=;
 b=NjIWzabgOYrpZIF0VDO8wSLwl083d7/WUrKZU4ojPEQ0W1fxeyKgNmg4pUryZFJTJ3WlAAgwKQC6jmn2qc1UGZYwhE1+6YAqUhRe0tu82fKn4G57lmg+gADkUg3o/YbW5YyTb7kuuHosOm7XuXKp+8D17/DSO/kqRmgsrUTGFNZ4/gRds+KklIYaMEDDQfREw91E6iIsxAV5N9ipfwnpm55wgw6iVjZH9yTKjmQhPtWpUZz5wyXmBhsyt63wmaXf31X+4S/N5B0edTAiMS1xyyUuu4k94pflfDYoimlpL+Ddhu/fOzdBuPbaJKHRWWTeWQSQNUK+XBbeXOGor75hEg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=intel.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ty+3epNN581HoMWzYFQ3C5GBD2Muwt4FWLup/QUOb1M=;
 b=F1MXo3rWn7u/o4lIBcK2wz5+YXsV+Pj8hABdDH6cbKlk6dM9wVxxmTA9QhMtMD9rtqyQOWsv59fBjx91prUpEkZgA5LTKn5/cjfI5W/xqwRdpdqv6dlw7vpJ6GgxI+78OKS7qGngeHyXJ0SmKXy7AcT1PDvLHnbVbErHCy3U/Es=
Received: from AM6P192CA0091.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:8d::32)
 by DB9PR08MB9921.eurprd08.prod.outlook.com (2603:10a6:10:3d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 09:59:01 +0000
Received: from AM4PEPF00027A6C.eurprd04.prod.outlook.com
 (2603:10a6:209:8d:cafe::e5) by AM6P192CA0091.outlook.office365.com
 (2603:10a6:209:8d::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.16 via Frontend Transport; Mon,
 16 Feb 2026 09:59:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6C.mail.protection.outlook.com (10.167.16.90) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Mon, 16 Feb 2026 09:59:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G7e3Ssau77sowUqUclx3e6CCZN5g4SYRr9kYDLeeEUKS08xhC0sLhaiMeA9I3PwDqClk8OBBgyerJfkZEpg3Rl9jEvKCFalYjhnrmYqLxyWygbeyMqGHXyodCmQyeU1x6sqpcvRRiM4DI+VJmiltFoL2bbD61hZDABy+Zh3ZOCLcCKdg/pQ+oodMQzg4BK1KkTQqP80YNtXNgL/onZggqsKIPcVJ/YlF2Y1p5Kr5BjgBzc+zzZKp2XPbE7oEHUFzA6YJHKSemeqBcVRm9Zo1gCW7qMoR6SRQVSQ+3qjHDeqiIbijYhwt0jj7cIt68HW+l6LjF952N4pRnsW8OIkpVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ty+3epNN581HoMWzYFQ3C5GBD2Muwt4FWLup/QUOb1M=;
 b=qpgTFIZPntGXIm3AM/CRYk5VUJ9fDFEuFCHKlEHFM/MH4R9sbIn1K5fFyYltXsrpaGY9lhmWrhSkMKElpd3HPzzzi6g3rxFaMk9XeqrmZRT56CrPdcz9YIEcU7g67IYjWX0bV5OQi+1Jd+6knk5CUY9ZyyivPkpcFag/FNIQhI2Haep1ZRiFehC4zmW+luQVSAZqUONKidVjFkUf0CVy0VUbEPwgB7Oy64qKihQfazPbr0iPbxH4DAcy2cp6ERLg35N5qKHxj7nMfdmv++eCguFPAFudqtXWUdHQenmvfKQtcuRWLZpBAVil6uuCnwXTKGAQ5Pdia5MqbqFKiAYniQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ty+3epNN581HoMWzYFQ3C5GBD2Muwt4FWLup/QUOb1M=;
 b=F1MXo3rWn7u/o4lIBcK2wz5+YXsV+Pj8hABdDH6cbKlk6dM9wVxxmTA9QhMtMD9rtqyQOWsv59fBjx91prUpEkZgA5LTKn5/cjfI5W/xqwRdpdqv6dlw7vpJ6GgxI+78OKS7qGngeHyXJ0SmKXy7AcT1PDvLHnbVbErHCy3U/Es=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by PAXPR08MB7672.eurprd08.prod.outlook.com
 (2603:10a6:102:246::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.15; Mon, 16 Feb
 2026 09:57:57 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9611.013; Mon, 16 Feb 2026
 09:57:55 +0000
Date: Mon, 16 Feb 2026 09:57:52 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	bpf@vger.kernel.org, catalin.marinas@arm.com, david@kernel.org,
	ryan.roberts@arm.com, kevin.brodsky@arm.com,
	sebastian.osterlund@intel.com, dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com
Subject: Re: [LSF/MM/BPF TOPIC] eBPF isolation with pkeys
Message-ID: <aZLqIOsHeAUfFjXJ@e129823.arm.com>
References: <aY3+Raf8eZqipCd6@e129823.arm.com>
 <f20ec2ee-90f2-4ef7-bc3d-088f9ef6c38a@intel.com>
 <aY4KfM6wFaSjHWri@e129823.arm.com>
 <d6d37293-592f-4109-90e9-20b77b023476@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6d37293-592f-4109-90e9-20b77b023476@intel.com>
X-ClientProxiedBy: LO4P123CA0462.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::17) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|PAXPR08MB7672:EE_|AM4PEPF00027A6C:EE_|DB9PR08MB9921:EE_
X-MS-Office365-Filtering-Correlation-Id: f0437516-2186-46ec-5bf6-08de6d42022a
x-checkrecipientrouted: true
Content-Transfer-Encoding: quoted-printable
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?38ohGb/rU54PZgEllZ/wVU3TmrhICE6liZ6ZZWTIqZIkEU4MLTxCKjeJG8EW?=
 =?us-ascii?Q?fhNBCTdZKlTUTgF3K0+TTB5a8zqpuvf7B0jZRzO2aPDBD0pAkn3xeLh5bGyO?=
 =?us-ascii?Q?zJIsssOwWERAKwzo9KCUGzghLuar7Aee0bhjnvV+ty5SHQF4usWFbTFi+X68?=
 =?us-ascii?Q?S+pKdEt4tPqZa77pbEWx/yzaewGeZaRafeDIi8RcozyUq9p7fbaXdmpCTF0t?=
 =?us-ascii?Q?uEufi6xPSI0XM20Up1KnoxeIqmQv3BwEPBvjJVmjLhjjNHdQ83II3BF3bIW1?=
 =?us-ascii?Q?jIE/DnUV7kcLN0KfSCUhNq0ad0dLvTOVP+WvKb9SiEq63TbVU4B1tkAuj2b4?=
 =?us-ascii?Q?PtkBgoQCoCkZ8gop6u3ij30Nlv7Rz8vhmEF/9i9rN4A5XFyXebCUJbWQUQSp?=
 =?us-ascii?Q?HXgr3Vog1M3vPgxnAoRm+EzwMPyWUBUH4An/dSxHde6iO4j3DmWJIUmCLNNg?=
 =?us-ascii?Q?DLKn0vPk4Oxr3G9k4QVQ70U8u+SEpBYznnURpZ0nFVqsKXjtOv/XWYNRh7T3?=
 =?us-ascii?Q?tRLjeykKY//IeCQ/U0SndSGA1c5Q9jg5z8wAZxpRgjEBkDXGsn4Bz0jJ9Zj5?=
 =?us-ascii?Q?lVJbVrPKwR+E4qsecqNfa9/IOjoiuFd9yGgipjtzIW6qT2vD7zHTzAwTFMjS?=
 =?us-ascii?Q?8VYYC+jzgLL6NfmXIKphUaEn0FiemJR+585EutyMqM8LlIvUUK3F9blmjRL5?=
 =?us-ascii?Q?RxWIeRsZXlGJTCwrYGbqoufs7aC5POileStE7g6arjSPI/+eNMG1qH+txPNM?=
 =?us-ascii?Q?RMZYjudecUMpF8VF4MEWA3D8h2eP3UbcutsgKYRnId0BOzEhl8kcSaUY4Hbc?=
 =?us-ascii?Q?Y6WbIc8wpeSbSPUPuuMXngh3oOsQFdTpXbJQiCunsT+DvJbmGZqNIUoFv9wH?=
 =?us-ascii?Q?31pONlH30rsThxmLR9CcBB7AUOjdfzeOk4aSCUS4pvB0fGl8GEwrBEYO7Lk/?=
 =?us-ascii?Q?vzAs4+FoJ5WWrEM9NLSom/LBX4Gl8ebGu0gEbWtwHAWU6GFeSWUjHEJBk9at?=
 =?us-ascii?Q?lDPteceFWKybLyE4yMgrCWFT1g45C2TyTJgCQ/aFs2xHJfDI2i45ET/E5u9G?=
 =?us-ascii?Q?MigYoIzDFZmqeZISTlHajMP7VTamLbqlDi4Sv6DDwBckcZQgJpS+cpCeiPPy?=
 =?us-ascii?Q?fNYXlSOkTMlWWItfgodqCgA6Uf+JGlcBR4SjEODlL1rGnsS/8KcqCELRujfm?=
 =?us-ascii?Q?3LeJqdWA/V0mYT9bF9+lFrvoKS2+CRaGjWRzJynCY8d5jelG4Q5DZ2HYoUjT?=
 =?us-ascii?Q?YhtzJF8qAOrGqBYI/yVoQDYXoGqMCrKqKrql45M9LxQAXg85DCXkYyK5udTG?=
 =?us-ascii?Q?YXPTKXabkU+Zi8b8FIYyFV/3L3vL//3EkDWDu9MVW8/jnHroZFv0d+INcFou?=
 =?us-ascii?Q?XFuIFyKZ1CJRHZm8kldl8l0AnjjvzOYLgyvhnSYr1hg6rrL1w/lUspyYf8tb?=
 =?us-ascii?Q?2d0KW1eF34VrN6v6ccmrTQtEE5Aswbt5QPJKXWYnzCgZRuYDtghUf1ZTQaKP?=
 =?us-ascii?Q?xw3Z3smDo7PT40v+hYudj7WhZ0Zaq/d/jpN7DM08icS/sNT3FpDGdpCMebj4?=
 =?us-ascii?Q?lyUEHkLUrRC2PmkB1Kw=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7672
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	767914f0-7743-4378-a154-08de6d41db67
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|14060799003|376014|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oT+RymUAKiGHEWKHQkvD0RJ3D6Fio3Qz2sIU4YCGDjVBFLVGr0opa69bnBh+?=
 =?us-ascii?Q?aWlc5opdnuU3+JT5pSQUWjWnkr0gpcpfnseRwXw5FL5fDjOKGYUOCUgBwdAp?=
 =?us-ascii?Q?gKR8ClPmFV6WZtUZewrn+3etdXfVyjDLLbDeA6Etu2Dp68TjyWV9s2/k8qes?=
 =?us-ascii?Q?hqNkRgFFyEZ4F4qbSwX3zHwLUScq2Kh7Ofr4t2csoiLFn5VIGwf9LnawIvo0?=
 =?us-ascii?Q?V3zXpHJVOPtY6vOT0dIqsTJ3L4f1iR1T3DULwfb3Okvo9zCWBzBPDM/XmPpG?=
 =?us-ascii?Q?k271BEQwgiqZOnPua83wlPN/GedciKZeXPHkZbsrq1seqVRYojBt/LLCErNC?=
 =?us-ascii?Q?wIFSNjyRHlFvvkJOjxTKsRoSvpwTH8X5i8tfTyBUod41Urq3id5QZf4tpjiw?=
 =?us-ascii?Q?zrqflse6o/y23ZNlKfc2P4E32eUxlHHQnPytzSYzUErkHZ663xebb6hECEXO?=
 =?us-ascii?Q?wYKb25wI77ovN6mLP5GkHQ6rm/MaraXx0fhey42RPzwGIxwrRUL2Ex4EW4ay?=
 =?us-ascii?Q?1bATdKG493dte4MZNw3eJLcUl16CM4ujG9nCX4QA1CKDGVesiJdl4YnkXV6A?=
 =?us-ascii?Q?bK2GDRPBjHAtM9y0z/QqGa56uAw/pXhja5BmkEsqhgxl/K6tgiBnO1dd0Qmo?=
 =?us-ascii?Q?12FhBD/l+xwpcgXDfyGS2Q4SGmSNbr6dJrMJ27jo+leWks5383fD4563pvM6?=
 =?us-ascii?Q?UtgcrLbEr5l35R25Pf0AIPdRfh+oBZ8wcfxA8zmo/NIWppbSms8UQ7yUTU0I?=
 =?us-ascii?Q?nZVBEOUM4U5d/x2tpOdE383QRvILqP9TKfzxvPsFX4kkRwoTWLhKh+cRXAxQ?=
 =?us-ascii?Q?Imclq3rOMQMDyen7vzVJ2ClPCwQzpdWcJmea4EMH81SyZbacEpxfL+L9prYN?=
 =?us-ascii?Q?nM2/yvJw0O67KB6qWNv8JBhyedYCzqvB2q6YO0MxBWH8+v3yOb/L0poVlhrC?=
 =?us-ascii?Q?46g9FqWqYtwmKr0usp2mg4eE5hY/CN0neTyiEfU1+fqw6tVBl13costr7/EA?=
 =?us-ascii?Q?KPfSz251izRGulxj8292081wgcCeV/79wotBivhWjOm+enCX7V+cAVGS20nW?=
 =?us-ascii?Q?s9ykPdfdrxiZrXPDwK9K4eZ8kSNfSG5TKYZoGfNorHQkWpxH5pj7KWF7gJ/L?=
 =?us-ascii?Q?tLv2Cp2Z20qokwrPGtARvgCjNSP2zNOKXC34vPgOoF0p7M6KtoS76OKtHE/a?=
 =?us-ascii?Q?p4ixnmbNOq5Zj26DB1bAoYAWMXugVIn5iV1cAQJD7Vy2c46v4G9srHZy2hD+?=
 =?us-ascii?Q?hzH0wvGumCU3JKVqbkxA1C7nZpugAWV3vcSr3sHoh/DjwjBESIW0D9XE0gfy?=
 =?us-ascii?Q?vDIoc1hiAuqeE6QvH537eBNBuj3Vm2LbcpOx8zXr+HHNyFHM8uuZ9RkPoUxI?=
 =?us-ascii?Q?bHbavphlDqJcV8Na04GKYT5wMAIM3KtMhA60bNJhv3Q6KK3CA3HHZ0c3gLd3?=
 =?us-ascii?Q?pKEviMsVyJtcRQCJshIDGeYl2IliQEfyAbgtzTjmOQLkfP/ebHfvIWsZ0R03?=
 =?us-ascii?Q?9Ucvlit63/X082KmyHiLpcK6LVd/bVWrX/2Rzi8zLHRC2zUZSousvDadZ1C9?=
 =?us-ascii?Q?MuwJraxj6fnkrcMRym9Ny8E7cSYgrO02cMGjWeUdEp0UfyYBYjl1U/4edl0l?=
 =?us-ascii?Q?3Ut6o8P7Yq/bOv/9oeknmGA5U/b0PfGmNL7AftY5rcwI2/TaoRIa/GTU4i4/?=
 =?us-ascii?Q?KjAHww=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(14060799003)(376014)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	G/HgPCIN2KqXMCXoJ56aJMoErSjHizfsCrk2niz10+K5kk06rgHW+6s61XZloTgZlw3UaJ3T8zVm6gf76fHdLEHNRAYRL/UDWwq7CxvuYGAOaNgp02W+ChPsyYEmREKja0OTAn7S+z920SCgdLpEw6vM7g08JpbYi+BGAHI6sDu6dW+D3XuObzHVuM+ui/rjJPwa/IxiJc97q3nTJVmi6/GHhiVtPZBozb7JETiVmvTcFDXb3e9+OHaAGG94cBFBLs7ABEjcjYcqbGvuLmLSdIp+Kiv8lERVYSzXDbtptltYyb6UJM9yNK8gmniVODmG/rHvZT9TvRxQhuzIiC3/mBZCH7UJPG7wPe4uswuc8PVtKPNarFAyG6OldNWm5px3fxT7TEr2isX7g/nBZqpIij98elR3MdOlrk6fT+BOqRZVQut2v4ExirgLv5ZCfOHT
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 09:59:00.4000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0437516-2186-46ec-5bf6-08de6d42022a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9921
X-Rspamd-Queue-Id: 4B1D8180007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 78miawjm9gewr365g3okchkx4g77j4n7
X-HE-Tag: 1771235947-165571
X-HE-Meta: U2FsdGVkX1/wWbrd956HTvn65LAooKLU2AoSEEhf/vZM8FfMsmvUSqLTexmZ85TS8LqHy8ZkvO0h0ThqkB1630SeRslfbE6ol1CTMWAs27Dg+a47W7dDwfVbDLJc1gX21nJj9lE/rJnj6JbJ++P1bIb1A3mfH1GXVJToqiMRP0pn/BGnUcGlH1d7gPmNx0N374r9DY7VPqcAWFl64gBYHe/A3GoBv0bJINAAhm2f5zLJi+7UBYy3ZWuULmnzNEZoZtV7MNhXR+5gpXT4+fycBSXPKwywOj+J2ABfn5ZjwQWocy0FyfGKJWnf7/JJ5LA7GtORxJrWY+HTaCYLJV+q5gQfkjhjwkLPrefJprGgTYQ4oRSSrxzpKDCx4xmRGucW+NddKupigCGMm6+JVOo3C3ZqTXSP1EJu7Iq+3V5oe9/WV+1axvB75ssuFeBvRVGtlbx26VtE6IAb35YHhF4K2hw33Il9MLfoP7YtAk6wr/OZHxI30wmneYqYspvSoCqbuYZ/PNHkCiPW0HCmA6XXZVqkULDZFcrw3WIlvQBELKsDkn1mj+UYPHeQzlotw+SLRqKAcBiqV9upmc1KQLvslzOLDc2k9k+xWu4+awifyDxoETWBarbIq3wgHVcgidQkm12+yWsHAaPN+OZyBz1Q3i2UddOKWYJxmsdVvfNlWkpWxRjLnORZY0Yixli+zz1y6lYhaudfN+AOezvMMTB+T/lzTdJp67SYDq+xyjtZdClJ2i4quEwHDxPlpkwVinTY30Qh3mJlsaFDXtg0TqhAQ5V54AHLGw0O6iltRs7fuZQ8LhGlfqjpuUMuinY9cH/WW0ehgqBbJ/T3EhcYiY3O+24BrQ4DypWsilApKKXedMMwPrBTNxkV80txzB3gLyia00xRIswxXbnUsqb94QMIZ+2Le88gZgRGhA7ElAMdCmfe/y2rr0+I9vP97kfweiHXlgw++elIDIcjEE/cY+U
 zY2gguMG
 mE8Qe5EOQNdRw8cKWFRj4eQOF6iKk35Sni4ZttrJW2k7h9+ThxeJxkPKHO6rIGtlqZahdlyVABiRnjf23f5bKVANPK/mScnbLIJL45H2txrVr7Qq79E+dhN7nJqrLUE93Lo2AKFt1cRvt6vEr7kiidocyZj+DiT9JUaDGcXH/Y99M3qLZCxuuuACODd/hXMZx2yV35OVIULZrT29AxhdQQfEKoNiY7V9Nh5N3T2VUpKY/VMXpBEeNvJ2Qzq9PYJp4ufnpoIAKT327/y96yBc1yuohBMqVqvkspzKQp2XOFo6MG3Wy+V/23qrZ2pzuUOAwK/fHjuYxer6tyNYPbZKeGvdT57QrUC3KSaooZZbkx/4IJQbOGHLXt5m6XkTpTIE8yMmonV23Py4VQXuwHe8d+mpmx+0sgFP/fw9OXQROOznkyjFOzn9WxUeV8FMG9/k1oPwULw+wqGVE4Ek=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dave,

> BTW, one high-level thing: what you're talking about here really is a
> kind of hardening or kernel self-protection. It's in the spirit of Kees
> Cook's work: how can kernel security be resilient even in the face of
> kernel bugs and attackers exploiting those bugs?
>
> Those who buy into the idea of Kees's work will likely agree with the
> premise of this patch set. Those that don't, won't. :)

Yes exactly. But one of my small wish is most people view this positively..=
.

>
> On 2/12/26 09:14, Yeoreum Yun wrote:
> >>> To that end, this discussion introduces a set of new allocator APIs a=
nd
> >>> explores more extensible API designs:
> >>>
> >>>   - kmalloc_pkey series
> >>>   - vmalloc_pkey series
> >>>   - alloc_percpu_pkey series
> >>
> >> It all sounds fun, but this doesn't exactly seem very generic. The mem=
ory
> >> that sched_ext needs to access is super different from, say, what a
> >> socket-filtering eBPF program would need.
> >>
> >> So this doesn't seem to be likely to be true "eBPF isolation" as much =
as
> >> sched_ext+eBPP isolation.
> >
> > Our current isolation model focuses on restricting writes and execution=
.
> > Therefore, if we allocate only the memory that eBPF programs must write
> > directly with a separate pkey (e.g., packet data or sock),
> > it seems to me that socket-filtering programs could also benefit from
> > the same isolation.
> This means that subsystems using eBPF need to allocate their data
> structures separately, or at least in a pkey-aware manner. They either
> need to declare the memory at allocation time, or need to be able to pay
> the cost (and the collateral damage) of changing its pkey after allocatio=
n.
>
> This _might_ be doable for the scheduler. It probably has a limited set
> of things that get written to. Most of it is statically allocated.
>
> Networking isn't my strong suit, but packet memory seems rather
> dynamically allocated and also needs to be written to by eBPF programs.
> I suspect anything that slows packet allocation down by even a few
> cycles is a non-starter.
>
> IMNHO, _any_ approach to solving this problem that start with: we just
> need a new allocator or modification to existing kernel allocators to
> track a new memory type makes it a dead end. Or, best case, a very
> surgical, targeted solution.

TBH, I think there is no difference for a _memory_ usage between
Network packet and scheduler since most of BPF program uses
"MAPs" and this is needed to be written directly by them and
"MAPs" are always allocated dynamically not statically and uses
existing allocators' feature.

IMHO, I think it would be better to make existed memory allocator
aware pkey than make a new allocator since the there is no difference
except pkey-aware with existing allocator (and I think
this would make a more code duplication and add more complexity).

Thus, I would like to discuss with the way to extension of
existing allocators first.


--
Sincerely,
Yeoreum Yun
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

