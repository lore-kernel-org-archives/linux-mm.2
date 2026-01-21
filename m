Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9971D262B0
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 07:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5F46B0005; Wed, 21 Jan 2026 02:17:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9E36B0088; Wed, 21 Jan 2026 02:17:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152266B0089; Wed, 21 Jan 2026 02:17:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04F4B6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 02:17:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E634BB5BC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:17:38 +0000 (UTC)
X-FDA: 84355115796.05.665CD1F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 789C4100009
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:17:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FQaHZZIP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iiHVpc6L;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768979855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hapn24gIngChLkGnLAVX3SBCWaTstbF62GY2LBCQJsM=;
	b=C3Fu/O5j+scm1k2TLM3hgugkEVMoThMdF8SYdjmDqNORY7DgGFNwGiVxe35RsriaIxhTFg
	jK60xUFtSNG4tiX8gU3H51ztlpcMMijcGQ9vht0vymuxi7RH92AnDetj4WWm1GO+caFvBg
	T5/JUvHk1GMk+XyMoQTVbynStugkbbc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768979855; a=rsa-sha256;
	cv=pass;
	b=vFWYwnuSOOBpcaXTXLXbROp07ClwzOchIB6+3tvhKvQkYruxUl0ouqirrfy/hjvhfLb/LX
	a5pC3bkRJvimqizf3IsLApFZ3bmSa+7xaOitAE8Umt+LaPdh/o1rrrLrBLsFr2Et6VOGdI
	sWS1S/37GsYP9ghkc3sjtgpEOaLEK1k=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FQaHZZIP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iiHVpc6L;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60L72LYg420923;
	Wed, 21 Jan 2026 07:17:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Hapn24gIngChLkGnLA
	VX3SBCWaTstbF62GY2LBCQJsM=; b=FQaHZZIP2qNAOAYM7r2cFDy9tulb7SePzs
	YzCZTJM9OWte3mPTvm9S2Pp42+uWiGpN/Z9QrHkRfBOSN5sUOxk6KmjPKPnaPoEC
	NUtsw/C9rMBAFTMaHAm7zZh/lembtKX3TX9X6LN+tlNkYd7545Qn5EkMa3Cwg1Dn
	utEQc9SBtIcRcf4F5aOthF4C+dABBA5EvZP+UeNpYXvgvfoGG8uufRDAUMDEURn6
	PirWPIDBi6mWCLuoQhHjo3fOF9vzlARQPHSjNcEQ7c+QyPXuqgg+mg14YoYHK4Lf
	0mqndxxkWuYxverTtN+5nDSc/7jFqENTF08sZqQ5b+cZZamOpnaQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagcswm5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 07:17:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60L5nQFF022532;
	Wed, 21 Jan 2026 07:17:31 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010062.outbound.protection.outlook.com [52.101.46.62])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vempxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 07:17:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RSNTQxusI1w6GL6kTPHP6mndukJ9tVIrEz98mVLW35aHxmG+tTTVclKOnABziuf3orkdAoa+VdeMe9iqKSZyrrT+UQkVD9SnwpDQg6Q63gAX4eXg0o6C9n4WjCi66uKBcffAJ27f6YVT1PlhdZ186laSOa1MiUNpxtl4nBeuz4w5Jw4x4Pp8brc3Jp9I49bmPzXsToVKyTWaUcYSaEQsq4bpPgGQp2VRqRESwBlonI+rrIpF9ape2GV/mxBzVF+TjdtrWFKYtxxA583CmIaoO29GLAHw1nxFDONOd9Xc89L8ILEwGn/QVE8fJb3cEuF1CnOuGT/BLTbAid2dW87sog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hapn24gIngChLkGnLAVX3SBCWaTstbF62GY2LBCQJsM=;
 b=GFDwmfQ4CDrRr9LVvgfpFEbYLg6DlgVraADRQknkvIfIZNCdwLNVMV/7bSk9keUy3hdosNPhbv4Gwp+ib4kChh8PjnlLj2LjAOerAoEWblIDovvOMJZcsvByIuqXoR7n/YgBTUHb+nGIbZj+RduRfCXk//cN+e2jPAwkqTwE73xdGcw4S1o0XmIX1wNpJwryLZtYpqSp5vB5bnRCPsZTNxbsHw2SPPRrGUwioZWePNEZ9JEZLKXlvoZxWWvP57+zaAG90rNk0olyHDder4ks7UzzaOYjrBO+vUDf0WU76/yHzVGQgJ7WFATTckSBPM+dnN2W+vmIPk9ITW+T53qhTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hapn24gIngChLkGnLAVX3SBCWaTstbF62GY2LBCQJsM=;
 b=iiHVpc6L6af7fMTTZ3++kVkS4rj3jmB8m3joqkV7fUKfZ33qSjVn+QViOenGPzj6nTRuUjk5DrzYvusIqK43Ok9/DrBXsyNM5hCHcNGwCC+qX77VFLIlKlgOSCoUKCEWRmWyBD57a/fsBY1XK98Hf35Uoj5D6O6yJn4X1FtpqLg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV8PR10MB7800.namprd10.prod.outlook.com (2603:10b6:408:1f0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 07:17:29 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 07:17:29 +0000
Date: Wed, 21 Jan 2026 16:17:24 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org
Subject: Re: Possible KCSAN/lockdep issue in -next barns
Message-ID: <aXB9hHM3T_Q6KzfA@hyeyoo>
References: <c858b9af-2510-448b-9ab3-058f7b80dd42@paulmck-laptop>
 <aXB68e_DtXsr7OcB@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXB68e_DtXsr7OcB@hyeyoo>
X-ClientProxiedBy: SE2P216CA0080.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c6::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV8PR10MB7800:EE_
X-MS-Office365-Filtering-Correlation-Id: a0c5114b-d449-4682-9cea-08de58bd22bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2s/iZkr7WH9IGZ/4eb2EcXrnCREEi9dC9+eCw3wn93KxON5kKIRR7mYITAyc?=
 =?us-ascii?Q?kUupPlrCa9b5ZMI/wCE9uX9sv+/BO5FNNf9lUpucqaMOSVDlm4bwD2asI9FW?=
 =?us-ascii?Q?7BiiGYlB0cdFn20iW8oVTPtUn70NeJQfhJYoILHrDV32CQzUa4JNGr6zJ+oS?=
 =?us-ascii?Q?mGk7MqHSLU41HP9FFmvIsD0fWUcJdeyp/EnWbqsGhynDgWzdK/OwRpOsAjLE?=
 =?us-ascii?Q?EjwF7HKzQGkXNlzki5dTzG1G2YT9SAfMeALgfkKOegvfO2+8HwX35UOvG9nq?=
 =?us-ascii?Q?/1yuIMUJ1SjJBxhXE2eVovSzg+H/BYWVxp1f798BplYCzF56fKTl6d6vvEKd?=
 =?us-ascii?Q?NIpvxRZ5lO0TowlUzJRBYuH9dstFoB2gAgK5ecpiaAmfgl2jFch1eFqPFwaq?=
 =?us-ascii?Q?SPJ0c1JjPJcUMdpm60+f3BZlsB1+LHfNMDJkSAesdYdL9L1P0AavGFjGQc+c?=
 =?us-ascii?Q?51+iG2y3lknldrvnmgINfnIuywQanBIpI6L5mV6MBH9xdhFPa0r3IZD1Mx4u?=
 =?us-ascii?Q?77nJtq5t4jVeuDbpfbf27Iw/YngnLtQqWF9I2gqEGGYEA//DOoZC9T4Q+bER?=
 =?us-ascii?Q?RUnxlmxLQTRagNT2nO2BVsv+kyRGx16U85U0iS0JGaufct6Ojp4gkmVUGNQ6?=
 =?us-ascii?Q?xL81aYH70kHuZhtj0QVcVXxLaQggkXCOCchmc3jsTRRjxF9UZLYfzeb046/w?=
 =?us-ascii?Q?e3xZjLpPGcIRDi9SUjXOf+vydsS7wWDbsgzJ18NFL7FTjSELpJDGV0wJMTEc?=
 =?us-ascii?Q?bVmkDgcfPNaHuV/YWfl3KVKVLeDVAZcR5FZV+ce1juFkzRt+pXi3PY2rTIvn?=
 =?us-ascii?Q?PbLK2YWCOYYUMA4R45LLY49g9FS9agNUYC0IWPXGofXFlSbgpjoQrfwkRJ34?=
 =?us-ascii?Q?j6AWkMIcwXzk/3OvSzafacz+5BzgahsvzFKw76kzTE9aLiIlK/Nvhe7IaPX4?=
 =?us-ascii?Q?JVpBNHm12pnzVOyJx2JM0khm5InRnP0eGGt/AuIkhGTCSnfJpatOV/q5/8bE?=
 =?us-ascii?Q?ryKxXckYUI6ujp4WFpOoO2zUZIcQ4TdkdzECbxpkYgYzE6mv5MG9Vx3jShkc?=
 =?us-ascii?Q?lcWMNnL0F8zt3gHfNZBgCRWkAmaT9zf+7DUNiRWkOytXkyKnnrvAn8Q/6jOQ?=
 =?us-ascii?Q?v3CW6tfbcDjwxXTI2/yBZzaKmkaT2E2jModmKxwVspW0oZL+FEau9RORAriY?=
 =?us-ascii?Q?64kfDruHdkJdKvjSrkJb7b9tiGWtHXDTHmgk5Dt+eF58R8HtwZJTAmjHH2nz?=
 =?us-ascii?Q?BGX1rBqWEaRHMO6WA+/2eKj4/n5sRRsOxXdvxhr+Bspm+E/krG8YHJUsZ2Wf?=
 =?us-ascii?Q?NU8p9M8/FztPfXls9f9sPf1sRcnPn2ybFdnLuxCvRtfzOfSztiyTKkYiLXEU?=
 =?us-ascii?Q?p00endFAN60SckykMvcvDe4X3aLULh7zCD7sN2CohoGBbw1WaHOuuVqxYHri?=
 =?us-ascii?Q?TMmhzNhG9zv46eVjd/0inQmpOewD8B+vDnmIf6JeYjepdNPtlioBT5753LZE?=
 =?us-ascii?Q?mcx061ntLGDzeJVhpVS4NVu4NG+GRiy+gpwmIGs2y4lmNqOl9bu4btGLrRqS?=
 =?us-ascii?Q?yh2uv2NLDOaMBOdoeWw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gfR8NNkrG2KPGgT3157qPWhWYxU9aGd6Ny4q5C+zbeGOigvIk4jW3MjXF3EU?=
 =?us-ascii?Q?VOHsaEH8zf8ZJWQvnyXKXzbJF08sIpavJrqI6zDeKTDZJglI7+wmU53HghV4?=
 =?us-ascii?Q?/YTFPbBN0+mMrx224HqYifIOEu3xTCrbb9i1GpvunjAbI1b47vAzVcYoR877?=
 =?us-ascii?Q?iXt6ymbQgbwrCNeMYEI8tuaXJxooPZJGo8BjlriYPtXM+4o+EJaMDFJgTwiS?=
 =?us-ascii?Q?L4CXHCd2JRm42H30jFhH1ao6+0Q5ptgbx0OAmor5+hCOwR41/S7xQwxE8g90?=
 =?us-ascii?Q?X31ts4hrtsPj85fnFbkCUAX9H9dIoLDmVuVEIoVSlIDMInslWmB8XdtD3LGF?=
 =?us-ascii?Q?4m1CVo2X0qjxSu/grxVQ7EFM7VvTaV4F/YPF5RadrLdnMDjjJKNIBbP+gw8w?=
 =?us-ascii?Q?0+1cPCe87VjtPD0k9ssn7ImRf1YMpq6bXDdJgBwxvowUjm1tEcc7rK8kkk7a?=
 =?us-ascii?Q?irkEj3hYLH3RXRxE+9FcENeWvcKWmgwdsfO1XjxKNHB3Kqg/haP50lnkkA3L?=
 =?us-ascii?Q?949zjIpkQ9Qtd6nfHNsCKXU+2L4+aysBOdZv78K88Hn3oOVdDA8SdTikatw1?=
 =?us-ascii?Q?whtC5G0yuXC9HPe5GvWx12I/ggBH5tHrFZrk9+FhQqbqz6GXH/+zjw/pta6U?=
 =?us-ascii?Q?ZxUOIgRBjov0AWlaiIZc4d4k2XYhl7R71NidNisG9RqbUK/jX8v4ovc0piE9?=
 =?us-ascii?Q?p4H4ZuJvTe5lUYXxDt320oz3iQzUK+djdECviHGNQOayFLKR9q0WVq9wsNfe?=
 =?us-ascii?Q?BlrsyNmvH5Op45oDLQddkEN8W3tuYcK6x0xsonj0kLmK3PHjAa4nZwOWogzg?=
 =?us-ascii?Q?+bx6P06BPJnCElfWWpbltTAWN31BVcgz4qlzSGUquXkJRPm1MxJ+wUYzoQZ8?=
 =?us-ascii?Q?VHviJhK9GNHhmotJYpy3kyBWtsNaF4kQ/iwR/Iwg1fwizCnv3BK7vnhhwdxU?=
 =?us-ascii?Q?OkZ45VzSGRMCgZ8354TJ//dojhUi12U5+UJ7Ni3Vcch++ulfHNH38YXXNn5x?=
 =?us-ascii?Q?Bvb8ZgdOm+gblRuAfj3lJbHYTh1xPdKO4Fcpt2hY5DdDu5iboaIcR/PSMm/G?=
 =?us-ascii?Q?mfXS/yjtXw5rkb3y5O1jJlXlbVkfrb6e8Tsll8AmOTcC8EsBR5SldkETH92A?=
 =?us-ascii?Q?V46obxfAQT9cRx6MliKPyQ7kQhEyrVqT9e7gxgYxEFOjWL15vd6cY2iz3Jan?=
 =?us-ascii?Q?DTV+Nhz4fWuPGmJeuszcHxi2Ir5TNhd8vePjw3iz7FcdZ80i7V3/XHJkk42z?=
 =?us-ascii?Q?P/H7fuvZ1Fos7VB8Or+ko0nQbsXMX3qEwD1fa6ZAsSi7m6V4vQ2RWahpeySD?=
 =?us-ascii?Q?bz9wdDC2duhpzjaW7lJdshvoL8D0CsYJL447/dAa/LGWzwprn1smerI5Myxj?=
 =?us-ascii?Q?qWW2gS+GeH46/5deDRMOLXXJNwbD6nuCSWj8zm2ycB39zeLD7qyAJ0UGAUHm?=
 =?us-ascii?Q?Cq0di7l+9t8EIgHrtG8YlJJTtMdWjVqOqVbyrVoOUiHDhw6RlFRIWT2Eg+OK?=
 =?us-ascii?Q?S53XxJMIWZM/fUCrNJ1vIpdz4Vp55OR6EVVC3tyw40CARCs0LfNvV+65EIQE?=
 =?us-ascii?Q?YZVUzDFP1l1YhBek1jD7fXLESyiUzvdflQskii4xv+/dxxBC3lwvLgyXVOVI?=
 =?us-ascii?Q?+gYn2/Nd1wxLy8gDdrGohUHvn6pSkPtagKxKcSIgXxftRvPKG7sSMuZI5KZL?=
 =?us-ascii?Q?GTk/U0e0RIx/fw8zBpre0l1sx1DTu3vXwgdxMIyExksnIlS5u/MKY+O3XOuj?=
 =?us-ascii?Q?eLxM3jDWkg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r3WsfMbgCNzQwrq85w+Xb87omOtGGk2BItzOe8NF+5RLyIHkVPixzE5R6ZeQGLWkAaDHhpX6ddV1YIvaTes1Pv5xw6Ow4hmUKNbRc6108qnjDZBKj8q8+RP/7oon/bGKaOGQB3NT6iZ1lNNdiCJe85BY763EaYCCzf9v9feS4JMVvVsKVIZPYs44z8GIV/qX5DKIVIQX2z2IvifbZ9DOAbQHTLriD8ucHL7OgIwU0tvGSZfNTMpJFz9pMR07iK+HMuP/SjiKdcdiKLGcPbgGZkKm8S20CrhmzBOz/VRWxtuu2Bitl2+MebnJ5ObCmD9mmPAbxjEjO5FygI6MpNLKA4kWq8aqsr70pmOmN8NT2R9w59uChe3BtQaudch/jhfo73qAdb6pp8BH2CJA8NycOHIXD0v5eu22z+gC+Mwmv2TnD1C7xj/K6zcRnBk51bsn2b3PrRJnUHj7FmjjWsieKpnCT6kAceD5d3S0Nd8q4s5DNFDG1scyx5AGQ3doN2iCiHlgeNzUWmUHtJu5dPnOUQO6cnvM8aZFFRtk66QIE5DkvuWKn0yM4z2Ni36q5cqUN5lUNPxRXQdtSTjzezXey9s0L1gPrcoyeWHedxX7ArA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c5114b-d449-4682-9cea-08de58bd22bb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 07:17:28.9086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GTfvGZhFBhzEOrcVW7SDHnk1xSZ1RdE6d2F4C7+PC1m0mZ+Nm3jdAQ2BVA85WEtsdPMPgwYy6vVhzITHQpiR8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_01,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=987 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210059
X-Proofpoint-ORIG-GUID: 8DsCxGzpIYErc6KFZqFH0IQ7wHeLQhfd
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=69707d8c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=ID6ng7r3AAAA:8 a=v8emn2m4d3Hifj3eK5kA:9 a=CjuIK1q_8ugA:10
 a=AkheI1RvQwOzcTXhi5f4:22 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDA1OSBTYWx0ZWRfXzS4rkpsyx8Wp
 y+XMj6SYyuET0GDuKyRv/tUXN0VVL9dBnU7XTCOa4cpwDjXbpLltNZf79TBbRbjmiQhK0cMXHBv
 ma8hcNMkrB7HMWEypi6zJHq3ZTrf+G6JdMpFXjyWPPaCj7A1muz1s2uoOrFN6DfYISt3sdadj1V
 DhCFOeLRo8JhKMOUJZsTBcpagiai5PVBrGqRoOcBE2f2ae1i/rRHJPg0KwK8MwB4Ai5F9K9BjSV
 744Oy8kqP2AbEBobf4uiy15oZUKTu1tFokaooffU2+4pnTGAPQ1GaNw00Lb22nGp9ZhOnjUHQgW
 7mSTxRfJkKNY4iLlvY/UCEMRw6QAup9fkWv7itKvijtC7vQFSYkYZk3E+gq6rNEftoWwefMqbUX
 pRSID4SpqSMPTeYq5gW/+TSimxGhaJ+NM0hKbrU4KfDkPPTEd9FApDUWfE/bYiruTnKa0O9inY7
 n42phGlR6wuLEwCv49sW5s+JgqGyrmy8ruoz2D/o=
X-Proofpoint-GUID: 8DsCxGzpIYErc6KFZqFH0IQ7wHeLQhfd
X-Rspam-User: 
X-Rspamd-Queue-Id: 789C4100009
X-Rspamd-Server: rspam12
X-Stat-Signature: hh6d7a8ypuzsdd9tne1zpnn1nf6dmmhp
X-HE-Tag: 1768979855-808595
X-HE-Meta: U2FsdGVkX1+QXZJZDVORxbXKvxB6sZxERO4Rwk/TvdiswimzJRHsjOCvLrZ4/FRQefXGZT0b+5GdDczEl9kumt7D4izWnWkDfZga9Hph+Hf6hVESwboVv1/twvxyA9n1chYo5ATLUMMrGeqGTA/Ln1Ig7q9gCx4oeCY6TcZ+SfXwCQn2fUzlkXNSjvddr0x90MOrVqM32oFq9TcmAU6JiPrbvI4c6KJYoHSkDtTRLhaiEaCh7BZKY95L67mBtSNDByVb1Vqhi47IbczUSH4baxmRKeFzTmCDpv1KOfLtzYBbMVRYh/4uItLI1eL6fUzr2b8kdt5ybw4PvYsd7f7XPE/7M5xg762HHTlDo7s6TZAp1/pGX0A9LtEjfanXG/tBFfcykQsL2BIKW46EW+uonThFo8Lz7TzKPv9Bj6JWvsEP1GhKtODJl3UfyUuDs9J8ifyLU/Iy2bc25Dd1DfX49jR8Q2UZRLnwy0drNkKnL3T7+ekW0GaCmqFmcLaQ1Y0UNNibKU7iz/mlGYT+0slrWIyBZUwkpbpAptu8BjjsIrZ8SrJICyGy3OsTON+RHANNf2gr16+bopalKDvNYt2S9KRsor1vP44iAXGtgMQ2orHebydrlPkLUftMzHkRNuluYkVqC+7x9bE2nePiU8Ne66wgniad9UUQ6gspFAiOW0EwSlWOTBi750VJ3EsFhcuQ5eQjf5vRwNeAWXM6t158EBuVnLKC5ZjKqfkalizSvqiKZKZTpW+O5d1yQoxnuk/+yvr4EXLYXJ4wQuNRaQJovvFRlotgTzgTQEVzHbQNmQl0Zq28KaUipQpPh5kHY5bOTq7GeGtz0eJu+iK8RM8x1RBhzW5Avr2KgRdbZs8txaWj7QdT3p2IkCZ+IDvvLDQ+m++WUtmbyzLQOT4itqrkEjkCXn5ZN1DWxrPekqOAJJsrx6zLF+8Ms+twGHsaWefmLM2pHMHrnScfoYYrWMQ
 r0SDONda
 RkwZNQ57NGqTHS7IKUxMWRqDoTp9FC63ujNGJdrEjqvAL1ssQq1venX52+sp/7NRUD6G7nHKdgRSdyfY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 04:06:25PM +0900, Harry Yoo wrote:
> On Tue, Jan 20, 2026 at 09:41:14PM -0800, Paul E. McKenney wrote:
> > Hello, Vlastimil,
> > 
> > On the off-chance that this is useful new news.  This happened in
> > rcutorture's TREE04 scenario running with KCSAN and lockdep enabled.
> > 
> > Thoughts?
> > 
> > 						Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > [  253.872153] =============================
> > [  253.872271] [ BUG: Invalid wait context ]
> > [  253.872271] 6.19.0-rc6-next-20260120 #21508 Not tainted
> > [  253.875774] -----------------------------
> > [  253.877983] migration/1/23 is trying to lock:
> > [  253.877983] ffff8afd01054e98 (&barn->lock){..-.}-{3:3}, at: barn_get_empty_sheaf+0x1d/0xb0
> > [  253.877983] other info that might help us debug this:
> > [  253.877983] context-{5:5}
> > [  253.877983] 3 locks held by migration/1/23:
> > [  253.877983]  #0: ffff8afd01fd89a8 (&p->pi_lock){-.-.}-{2:2}, at: __balance_push_cpu_stop+0x3f/0x200
> > [  253.877983]  #1: ffffffff9f15c5c8 (rcu_read_lock){....}-{1:3}, at: cpuset_cpus_allowed_fallback+0x27/0x250
> > [  253.877983]  #2: ffff8afd1f470be0 ((local_lock_t *)&pcs->lock){+.+.}-{3:3}, at: __kfree_rcu_sheaf+0x52/0x3d0
> > [  253.877983] stack backtrace:
> > [  253.877983] CPU: 1 UID: 0 PID: 23 Comm: migration/1 Not tainted 6.19.0-rc6-next-20260120 #21508 PREEMPTLAZY
> > [  253.877983] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> > [  253.877983] Stopper: __balance_push_cpu_stop+0x0/0x200 <- balance_push+0x118/0x170
> > [  253.877983] Call Trace:
> > [  253.877983]  <TASK>
> > [  253.877983]  __dump_stack+0x22/0x30
> > [  253.877983]  dump_stack_lvl+0x60/0x80
> > [  253.877983]  dump_stack+0x19/0x24
> > [  253.877983]  __lock_acquire+0xd3a/0x28e0
> > [  253.877983]  ? __lock_acquire+0x5a9/0x28e0
> > [  253.877983]  ? __lock_acquire+0x5a9/0x28e0
> > [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> > [  253.877983]  lock_acquire+0xc3/0x270
> > [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> > [  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
> > [  253.877983]  _raw_spin_lock_irqsave+0x47/0x70
> > [  253.877983]  ? barn_get_empty_sheaf+0x1d/0xb0
> > [  253.877983]  barn_get_empty_sheaf+0x1d/0xb0
> > [  253.877983]  ? __kfree_rcu_sheaf+0x52/0x3d0
> > [  253.877983]  __kfree_rcu_sheaf+0x19f/0x3d0
> > [  253.877983]  kvfree_call_rcu+0xaf/0x390
> > [  253.877983]  set_cpus_allowed_force+0xc8/0xf0
> 
> set_cpus_allowed_force() is calling kfree_rcu() with a raw spinlock
> (pi_lock) held, but barn->lock is normal spinlock, lockdep prints an
> error because on PREEMPT_RT normal spinlocks are converted to
> sleeping locks but raw spinlocks are not.
> 
> Hmm... but it isn't great to convert barn->lock to
> a raw spinlock just because of this?

No, on PREEMPT_RT kfree_call_rcu() doesn't use sheaves.
Is it benign and it's simply due to PROVE_RAW_LOCK_NESTING?

> > [  253.877983]  ? cpuset_cpus_allowed_fallback+0x27/0x250
> > [  253.877983]  cpuset_cpus_allowed_fallback+0x15d/0x250
> > [  253.877983]  select_fallback_rq+0x1d8/0x250
> > [  253.877983]  ? __pfx___balance_push_cpu_stop+0x10/0x10
> > [  253.877983]  __balance_push_cpu_stop+0x4f/0x200
> > [  253.877983]  cpu_stopper_thread+0x147/0x210
> > [  253.877983]  ? __pfx_cpu_stopper_thread+0x10/0x10
> > [  253.877983]  smpboot_thread_fn+0x24c/0x390
> > [  253.877983]  ? __pfx_smpboot_thread_fn+0x10/0x10
> > [  253.877983]  kthread+0x1fa/0x230
> > [  253.877983]  ? __pfx_smpboot_thread_fn+0x10/0x10
> > [  253.877983]  ? __pfx_kthread+0x10/0x10
> > [  253.877983]  ret_from_fork+0x157/0x2c0
> > [  253.877983]  ? __pfx_kthread+0x10/0x10
> > [  253.877983]  ret_from_fork_asm+0x1a/0x30
> > [  253.877983]  </TASK>

