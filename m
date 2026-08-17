Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEABCC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6B3D6B02A2; Mon, 17 Aug 2026 10:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1AFE6B04C0; Mon, 17 Aug 2026 10:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E35E6B081B; Mon, 17 Aug 2026 10:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 678206B02A2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:34:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E14AEA233A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:34:36 +0000 (UTC)
X-FDA: 85111007352.21.983F7A4
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012001.outbound.protection.outlook.com [52.101.53.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id F3AE720008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:34:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sfgTaeXI;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786977274;
	b=WOTeWnD5G0eLDpDiXTe35jI83uYHdpNaSF58w7TNptVI8VPFNePaux6LxNrFWdjy2P3/kv
	myAZ5ysYuNhcT3loLHYp1YVbNlyXSybkq4LzDIXb0rPvRsQwxdpfp4/kkFASFviKzg0Fgc
	W55iEnEQzkd2azMYxssLrvatRS07M1U=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sfgTaeXI;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786977274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jV8Qcrd4OPseOadp9d58/wwlTuGWEWRal3OKQELuvss=;
	b=HaJSDtZ/wTrkhDqH2eHTcKqCIoE6mc3/kqKmuEtXcFPl/04JaM0Qpek4alTG6N+o3XAxWJ
	8zyLC3iMuExgg5fp2BaR2xDVT1qvtsdKaOSmS3O8+0vjaHghIweBoJf2b0lWKPhp2fO7dq
	zjL5W5rBbt/FAblZudKgfEFunxqOS98=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fUL+qT3iBLXMNUgdqKOCiw8RvueLzhlF8CxKO2e1RHj8NLZOIz5WeXe9910h4j2Ts46iCmOKmYsge684rq9KMNWyFQTIrMRZbCde5Qk43CPuFei+raqPdDIIf7uiQiXpq7ESjq6fAwb+YIx5ZfdiGfPgg4ZEuuqsNi6Mbn6PSfGs9hdAeb+D5t7nbEuYMgAIsrhpsuA5cA7+YBLszaPMDUBR8HdVSL0Els/ouNeQV5L8WBRjAYVGdCIm1bq+/Jws4OgIK5YM/DAVRzJOn9+hwHjVzRGs1akyNEb1wWxEcYPlmJgu1pJA0iflO0ODbq6nzEZFD4DCq3mgfkzsYxPC2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jV8Qcrd4OPseOadp9d58/wwlTuGWEWRal3OKQELuvss=;
 b=jEiM6eqygaOAPUeSKeI6izf+UgyX9SQCxbNL/zdFnSRV22ekblPh/CfLimFHJ6CGwE+ufcYIwFmH7ZMcItjLgF+BdjuUCb6G8/088TyE5QlGQSovIKPDbarcMMqTRa1E038pPMCZPhR/DOJFEEJ6x54Hk9kNr8a1hLmePVP9UvnWen57alzsLhINqav9pYjcPlnho/fosaupQDrE0DM5etLvWUzN6puvKoHtyMzTdrnpB0YKch5VQ6eInnk8N3EmfKGbauNnU6/ue5Xsl53jy617Vg8noS76jIAhW+knbsTO1N8MVGJ9da3XT8fqQUDomor/IXj+Ry0vKfgbsoSvgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jV8Qcrd4OPseOadp9d58/wwlTuGWEWRal3OKQELuvss=;
 b=sfgTaeXIPZfC6ycpHfVvilZtmYLzM0TR4NMPuonqsUHy1pBNfLNec5mPeCuki4GlJ0NK2v7kcLSH6XTzZrT6lwYImJXnV6QugyckIh+Z8M7Op5tR3oyBaGJpe/w0C0jQuG9wlWrx+ZcWC50MnG2QbQjvTNURGVFHVreyv0gu79lA6/9wxHTirrRifNgyrmCyC2KUj4uAp6Ao0CNQpl3TzekNRTLHjljT4/TSFPTObMIG/c3+uSiutpMDYyqhIrQTd+MuszUPLiq/nkqtpHW3I4dmo26rZl49WG8KZBmh2WIa4OTqYbappDQ3TgkSD1qXKj9I1y5L/ZYQuZDX41UDEg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW4PR12MB7013.namprd12.prod.outlook.com (2603:10b6:303:218::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 14:34:29 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 14:34:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
 apopple@nvidia.com, byungchul@sk.com, david@kernel.org, gourry@gourry.net,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Date: Mon, 17 Aug 2026 10:34:26 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
In-Reply-To: <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
 <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
 <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
 <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
 <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
 <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
 <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: BLAPR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:208:335::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW4PR12MB7013:EE_
X-MS-Office365-Filtering-Correlation-Id: 69eab42b-7369-4059-7731-08defc6ca481
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|18002099003|22082099003|11063799006|56012099006|5023799004|4143699003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	nUe6lUZQf+EgnEPbNNGTGqssMLkTywFTAidFGQPkkb9v777UmFFi7Q2gH6tR4Gi0iZGvNYyf1JMZBb4XNRnbwxmOSsNNRyZFogrYJqNVVHoh4UGAjboDYl4QrqAbGNOzpS2BH/Ru/aZcI7U4olc+kudCUI/LlC9kb7b9FdZFl224zj1UNlUc5BYvtJrxd4LB0VyuFx0kc2aSyP4q+fobnjtr/bsaHRzcGuy2ytmt0KCfD479qMOJaH/QEgHR/lgH6EmhFsaY46wG2X3odum+fOOyxc9V1XgvpZFbHZZ2hREKw7801F1j4IeZMMPsF3UMAa2HvLbPCFbxdvsVZ1YSyamUzyVvoN1R8fo7JP29a0HwtKGB1MH2Y1GdHzo2XewCZaiiSRULN1oIhR8Se5Kp+mRDnObOvZlw900h47ZUb4IqbFwsQv1VoB/g/1q3H+jFUdV+xXJPr5CAcA2hglvHTNOwPPyOPV6CBg7r45U5u0SXyxxP8Q6FqBGCi/acAX9P7tPPnAJCkVF7K8Ax+uPDmdNxZE3U1/gK0F9CUlv9PcAGpvT43PttDVSCsNQkFA1biMfV/XJZi6prWUgGi3IFAU9GGYHVtsbshxYTaCWoyj3xdyCKAddEwsIhTzzjCDHt/V/LUczMJfper3tDiI9GOP1XSzQxvv4r0SQneu+JiXI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006)(5023799004)(4143699003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEpUeFdIcitTRWtMOGhFblJiM3V6dndBbE5PVi9XL0h3cDB1Rlg3bnl0VDFH?=
 =?utf-8?B?NUNHaHZNM2dDZVlQWWt2R2lTbk1yaitBRGU0eWZ0azlWN3d3VjNGTnp4VFN6?=
 =?utf-8?B?eEh5R1YyTmtYUXVLVFpTa1dYeXBhMUJSajlGS3o5QnA5TDVHUm9yRkdJY0Mz?=
 =?utf-8?B?LzdOaFgwWXJqYWZ4U0VFRjlkQmpIZzBzRDRlS091aU5wMXlETWxhV1VEeUhM?=
 =?utf-8?B?SkVzRU1mZktsWXV3QVk3aFVPZUc4SUFPZzlMN3Zac25wT09wSHhYeExRZzB2?=
 =?utf-8?B?QllPNm5NSGh5QllsSmQrTmlFMDNTYWUvY3ViM0poZ3RpWjlrMDNibmgzek5i?=
 =?utf-8?B?LzJ4WFQrMnVzY1c1S1dtR3ZxWURORm8xSjYxaXNZa3pnOXl3UVZOMWM4dVU4?=
 =?utf-8?B?QXVRaEJQZ0tNSVFoRU5YZDl4T3VWTVZGeVJmS3UwMXRhaEszcmJ2RkVwNno1?=
 =?utf-8?B?L0Y5eEVaV2xDWEl3dUw5cWkvZ3FKcVQvSS9UYzR3M1FGUEVNNUljUnVmS00w?=
 =?utf-8?B?ZU5sMWcyRTdubTV1UFZuUXlqMHdWU2I3T3ppd3I3Qmo0UU1MOHBYYk0rNWpT?=
 =?utf-8?B?cTBYN0ZyUnRUeEk2b0hxQTM1Qi9IUDlqeG0yR1pXMm9qRFZUelk5VzdQYUtB?=
 =?utf-8?B?TW8vWU1XQnBYc0pNeWY4dmhZQy9uMnRwcnA4QU1EYXJkbE9jTjZhTmNTUUU3?=
 =?utf-8?B?c1BmVitZam5lY2FiRmNMc3kxalA4OWNkNzFmVmNkbkZrWll1Zld0eSt6bWh3?=
 =?utf-8?B?S2Q3c1dmVDM3NkZBNW12ZHF6ZEpJOHBFN2kzdEorcllzTStWUEp3WXdVRGRO?=
 =?utf-8?B?bDlmRWJCMzF3OGtsNFRUdU85MkpVYW5DTE92RktneG5YMi94eHB2Q2w5eWNY?=
 =?utf-8?B?cDI1d3NhWGZFMVBEYVJsZkFyRGxld2wydFo1dk90d3RBQVJUZllMWnNqZWx1?=
 =?utf-8?B?MjZrUkUyc3dSd2FSZmkwSEpyUU1kekFkT3p1T2dCMkxJTDJ0R1VINVIyMzZW?=
 =?utf-8?B?S3dlZVNMY1pIVzJNeU1WM0NodDNyNTVlZWw2V1dkNnVJUm1LUVBETjh3NkJO?=
 =?utf-8?B?TUxSTjQ4cUsra0JSQTNSNmlIa3hqUEdZcTZHWGcrUWRVUmZjb293TDE4WTds?=
 =?utf-8?B?ZWFFMU5RK28zbERHclNwNW1VS2hwNDYrbmtmNmgzdWhicWlyUmd4UWl2bk9X?=
 =?utf-8?B?azhmTGJybytSenJWcUVHZDY5M0Rvdzh2YXdGQkMraWhpVEpZMUR3dUlMTHRH?=
 =?utf-8?B?VVpaNFQxcEdrTUZKTGdwNzVaL20xNlVQRFVwQ2Y2MmVtSXRUOS8wSHk3UEx4?=
 =?utf-8?B?WnM4UTV1am1Yd0VVcVVxdVR1VDVudmN6R01BRG1xZWZ2NU40Z2dQMlQ4QWNk?=
 =?utf-8?B?RzZFR3d4OGk0RHM3cTU4QlN5Qk93T2NXajRncTBNY0gycW9hcUFXQmc0SXlX?=
 =?utf-8?B?b1MxOG95Vm9ZTE5xMmxtQXFxcTZhQXhvZkFwbXJIczhlZnh6aU9GcDBaUGJV?=
 =?utf-8?B?bW4wK25WeWIvMnVrc3FrMWhNM3JpWFNEWHNJNkFTa2pqVkhvc0tqU2Rsbll2?=
 =?utf-8?B?Wisrd2QxdWlVMGxuT1E0ODRWdE1mbm1GckVEYzBnbStlMld3UHRwZjhDTS8r?=
 =?utf-8?B?b251L1NkOXlYbktYdnBGN3lBSTlMdFhJNHZMOG1FRm9RSVMzanA1SzFqeXNk?=
 =?utf-8?B?TE5CRzNWYU4vVlh2VWJlb0dmOUNqKzMzTkQ5dXhRNnFaSDNMR2NNaE0xS2tZ?=
 =?utf-8?B?dGhTUi9JVXNhclh5WGJZYzkzOW9pTkN3cko1dkFOMDc1Z1pHWUcreURySmts?=
 =?utf-8?B?QkgvcEd6V1IzcnZRdkVsVEJuZURNYVIybDhFR1ExV01CTmpOWklZaDdlRE5C?=
 =?utf-8?B?YUhMaUMrdlY5bzEvMEpSNGxHOE9ZMmpDU3VtM2JqVDQ1QWRBVUszMWNubzdp?=
 =?utf-8?B?bHljNStqVS84ZkR4T29EcHFNSUtIVWgwbVdmczZEWWRSOE81Z2R3ckdCbWQy?=
 =?utf-8?B?N2NHNC85U3F5NlFlcDJLemdYYXZLajVEekRSY1pRblZNaStjRVdDNDhHV0h4?=
 =?utf-8?B?OEUrZlppNytYN21pYldObE5Icm0vZ21KdnV6QUI5Nk9EWk5jQ2dnVTlNeHdL?=
 =?utf-8?B?N3JtVk5jUGk4d084SEIxcDAwTnV6ZFd6TlZqUnFCQzFxMGQ1THAzOWNESmNL?=
 =?utf-8?B?QXpHUVorUTJJbFpkcmhSSFdhYjZYNXBOaDNiU3lIVzYyNWpwTWVucG04czdr?=
 =?utf-8?B?dU94bXR6N0M4UkQza3N5ck5ISVVuQUliWEdleWZIRGlkM09IRUw2U0NVV0dE?=
 =?utf-8?Q?kUeAVjRj/5OETmq2ec?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69eab42b-7369-4059-7731-08defc6ca481
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 14:34:28.1318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: idi598FrAoxHTNpUlCsq5qmuzMCm+DIZX7xnJ/OB/GEBZspJnO8fDww5yPAScKPJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7013
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F3AE720008
X-Stat-Signature: bdwqf5hj89sojf7g3myqqgr3mo71h8zy
X-HE-Tag: 1786977273-800659
X-HE-Meta: U2FsdGVkX1+tI2BXvObvf+bDwoNr/dpJ56m24bnPwzSVEklFttVvCPEcvEwSSD6TWTjbRaWd/110HAzgCvWPXLnpMQd4nNItc2NJKQJsa3SaJzjnkQo++L5QUe6KQO3l0cKUvt+YxuSleF31IhiWR2Pxz2VaLOl0pvgnlqw6CUgWrM5dDd6ftXG/twDn8tdQPsdwFtb21jKx1uKilZ2T5MGTlaZqNX/+pgxVzo5ddNJXLz3kdHnqPoozngphgMXJlxpgBU1uZa+iW2iIUjPM/bHhi07cR/Lkea37QyEjq+9nMn5dhmuq58YYq4D7CvZR3KZwIa/j+j+r1i93JmbCYPgKT5JEJQ2+m6gwPQOI5yKQhlkFc1LE6k+FK7wr0wSPhqPXfzW0B54oxFizCx6aRdCJYFFSPQe3KV3RPkShmX7pED57/MDbGnhn85G2koKkch6iiITMfvR1/b7f5tIlw7Ka02fLE9QHd79Dx1gmAP7VOiXEPgTcXyc3TgrNqgf4U37c7UgZsQjTk5PKb08jb8ADw3rYxP2/4jK0QEzXa0QlBFTO1AHa1ZD6LKfU4SXSJVClIvujw6BoTPdWIA6aFA56GYDrvjC0ImtdJGgI+ZdrTumHmZodUVep7w9pKBaOzXQGJR/A3Y8UNxaBtngYx5Heb4/wxHRE2aaWBVXWo7NhxduyYt1heDx0MvtBTo2T4xJY/Lnj+joCC6VKAaivMtgzmrQKz0Y/oEtwy48ZkyYR83h9NcE1/VrfZkDmjs89A49A6If8qG+C2bRKI2OGejI1kTRdF3GOv6ZqKHI6s+bbfuOw4DNiypQKzQ3UYyF2jd34Gp72ZpDcdrS+ANYS9nTisYD0pOzgFnJymaZUe46iC+E7FrUKeVDLATU/BXzk6KTOslNhv49LqGGhad2RVaGJb6u7JLPI7bBSmhZGJzkKTmCPAXtg2jtSORVt51FCsuSJsatkJy4cpteCCOg
 PjDbhBkS
 9jBuCIilug02axvzF7e5uvdXRQ9k6lXhTlroZtgnaGd1miPQoisbyKvQAgj9QEZoa4JbfivToexv3Yn7fqlK1/eGd3ccLTgP3PTEpvBLzdDFVg63HrLtTMRqzL+SNRn809HEEy+/Vlw+1CUJRqtHS61ZB7lAL92s9plfJ6OUuCitjCV2b1FMHY65QXHSurqUdt/zyhNWOUQ+TZUupVh7dWnccNkFmsi7yWeJXOngBTgz4Zyn62e71P1dMkPZgcXfzD9heUpdi3R8aIU3/KV2gzXlMWrwwiTT+6tXIMNWV9ssRBfB9ioG8Ed0uSPLaV4Kp64S+W6s/X1IRaM1Y4j2maUHSfXGkMhpJm6ry8SMi5Z+o3dFeHxvJLiJYeouFHmfYEGXhPI0Ho75KKxdarlN4Nv9QaFx4UcSNDU4zHK4hVpsZabFAwtAdzVVR17DsSP48wtnU4bmjZcuIxv7F2JAGbD4hdwCx3xLn47g/YaYdyUfkIOEo5TXE3uQeMbGA/1bNhU9FHHFI6t9b+VZ+3v3k0RQzQFrVO28u/hJcFbAL3aRMuGlqgy04Q1pQ2nMIisdmjYS9i7fHJ7FrBLq628GvaxU/KgqA+TFen++VITq/Q8gzMTR7BzSMgT5RLDoFtnWf3QDcggJe0CHCMSU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Aug 2026, at 9:55, Alan Stern wrote:

> On Sun, Aug 16, 2026 at 07:42:13PM -0700, Andrew Morton wrote:
>> On Sun, 16 Aug 2026 21:47:58 -0400 "Zi Yan" <ziy@nvidia.com> wrote:
>>
>>>>
>>>>>> I prefer Andrew's first suggestion.  If the user asks the kernel to copy
>>>>>> too much data, just fail -- with no warning.
>>>>>
>>>>> __GFP_WARN gets rid of all other warnings, even if user asks for a
>>>>> reasonable size. Why use such a big hammer?
>>>>
>>>> Because on many systems, WARN causes the kernel to crash.  You don't
>>>> want the entire system to crash just because the user asked for more
>>>> memory than was available.
>>>
>>> User asking for more memory that what is available is pretty common and
>>> should not trigger a WARN or crash, unless you have panic_on_oom set.
>>
>> I assume Alan is referring to panic_on_warn.
>
> Yes.

Right. That is why I said “unless you have panic_on_oom set”. So panic_on_warn
will not crash the kernel if user asks for more memory than what is available.

>
>> Heaven knows how common panic_on_warn usage is.  Gemini tells me "There
>> is no exact global headcount or precise user metric for how many people
>> use panic_on_warn.  However, the setting is widely enabled across a few
>> billion Android devices and many cloud/server provider host kernels
>> where automated failover makes a full reboot preferable to running with
>> an unknown warning state".
>>
>> So I do think that WARNs are more serious than we (mm developers) tend
>> to assume.
>
> I do know that Greg KH has pretty strong feelings about this issue.

But the warning here is when kernel user wants buddy allocator to give
what it cannot allocate, a page order > MAX_PAGE_ORDER. The warning
tells that kernel user please ask for a reasonably sized memory.

>
>> So we just shouldn't permit userspace to trivially trigger a
>> page-allocation WARN.  Especially if the caller is perfectly capable of
>> handling an ENOMEM allocation failure, as appears to be the case with
>> usb-gadget.
>>
>> (Does usb-gadget actually get used by Android?  Surely not by cloud
>> providers!)
>>
>> (Can this WARN be triggered by unprivileged userspace?  I didn't look,
>> this matters a lot).
>
> I don't think it can.  Regardless, even privileged userspace shouldn't
> be able to crash the whole system by doing something that ought to
> return a harmless error.

The issue here is that the inode.c code passes the user input len without
checking to page allocator code. Capping that is a minimal requirement
to prevent untrusted userspace input getting into trusted kernel space code
easily.

>
>>> You can mmap a virtual address range bigger than your physical memory
>>> size plus your swap space and try to fault all pages in. That would
>>> cause OOM and the system should not crash.
>>
>> Right.  As long as it doesn't trigger a WARN!
>>
>>
>>
>>
>> Perhaps we should revisit this.
>>
>> Why are we emitting a WARN if an allocation fails, given that this will
>> often panic the kernel?  Should we on the core MM side dial that back
>> to a pr_warn() and a helpful backtrace?
>
> I think that would be a very good idea.  Only the caller knows whether
> an allocation failure will leave the system in an unstable state; the
> library routine shouldn't try to make this decision on its own.

In this case, the WARN is emitted not because of an allocation failure,
but an invalid input to buddy allocator (order > MAX_PAGE_ORDER). The
WARN is for kernel developers, telling them their code is asking too much
free memory and core MM cannot handle it. Suppressing that means
code outside MM can abuse page allocator. Code like doing
alloc_pages(MAX_PAGE_ORDER + 1, __GFP_NOFAIL | __GFP_NOWARN) should not
exist, instead of just getting pr_warn() and failures.



Best Regards,
Yan, Zi

