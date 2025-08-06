Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE75C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 19:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136176B0096; Wed,  6 Aug 2025 15:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E446B0099; Wed,  6 Aug 2025 15:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3EC46B009A; Wed,  6 Aug 2025 15:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0C066B0096
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:27:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5B2D140686
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:27:58 +0000 (UTC)
X-FDA: 83747317836.22.7B5F368
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2068.outbound.protection.outlook.com [40.107.212.68])
	by imf27.hostedemail.com (Postfix) with ESMTP id E669D40008
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:27:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D6zdn7iP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.212.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754508476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5EX7qsVURtzlvO6sMOUkhXd9Im3QnJIxg2r8uWhW7vw=;
	b=42WvUyOkCMODIdgNyflwU13MJE/Ez+dB45IqAmOQB/He/bxDALp2/9uovUtEcfxN20tusv
	43Twz1n82CgHHoWx+1ZiLCDGvAtqzFyQ3wur2d5X9NJFiyZHEpZXaVTdKmIAPybB3cod5o
	npFwbgS8gXzU2ho0qpzrq52DvGta6Qc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754508476; a=rsa-sha256;
	cv=pass;
	b=UPHypd+z4fqyVtOEw+7s5djNdJjjWBU3m1fXm/emxKqwMKtlN+duNVz4aaqaYad7YJzcqg
	8ypOknopaNnp3n7/+WCG9N1vZhhrqXS2rN3JTxjpzafbuWnZICATKILoZpMdNUxv4yjAIp
	XuAB6Wo4VxUjgZt9EJBu+F4exiO22S0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D6zdn7iP;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.212.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KLWkjNtc9Eq38XbNbb7JBOmXltVlImzX1NPPC14EmOJ0Ho3bQZnAZrBNUyiDZj0Kv0fH3TrXu9sHeibocbQx2BSWtNkCrlm/A3a3AhGD+oDwD4Mt8Kg8vcKrHNpy0lYCbryHT+OhFFMIU1RFPg0nBD4l/Xyr7CYLaA44VW2amTAQh4sUO+EiTKW3qw2DmcQ7j0jRgMgOC+1rX6uTiIgI/SVBZdKl1cxe7xXCzF5aV40Z62djpkfstSeB2eTE5xRoURXA1ohnGoUsBSSz9qj5e5hESZmpPiopDOIHdY9WWh21cl8ZMZi0uO6S066FxplRM0jvdlZ8JY93nXNl0JC+BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5EX7qsVURtzlvO6sMOUkhXd9Im3QnJIxg2r8uWhW7vw=;
 b=BSTb7Xz/IGxKNvZwjXiQ+exxf04rFuMskdbPDcfecLb9Zcl3IVGsCgrrwCteruSYKVEc5D6NnUa5VusMvFw8eC6C1uMZIYX1NbT3SxrEK4VcfkO9t+J5KtagzOTGQuD6ZNZsQX6niVu1/Pyp5iXhrrvXNjrVB8n0++xx1hwYhDxLWHrfUEa3oMYqyJEXXxIkdCwmK7a4lHcF1akDHp5nUIA2cBqic3UoT+uXJ3AG8HyqE/Nj2NDcK5fGTS24irSKBl31Sk3QdWdUOdWN0XCKDi3ceT382+gm1DmkTpwffEFaKi6lF9XJTvRqhhy9BxYO2eQK+GMfJcsAqkK1yYnboA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EX7qsVURtzlvO6sMOUkhXd9Im3QnJIxg2r8uWhW7vw=;
 b=D6zdn7iP8ojP5IcDLA0C5gkIMWwJCPBqrDGuh5452kVgeBt8+sIXgzOJKwNhtMnTDUbqMAQShJSjeFvLXmjZXJzXremK74rHNHaZ6iGoR5A1qIRRsL/zY8EcHpDUUCNEu1deBV2ZP7hVFJNb3kb9iNVhppIk1nE2hHRRsY9ESB9t+Y+EuuHOvptUecUl+QAO4Xy9P0pOIs8J1T7SIeXOCbeYcfHZTO+bj9GtCcmQqw2uee+MLJXQoIazT//lN/XEDmXV+VWXdAP2oXhL8rba4ADbBnjDxtZ/5/y/snNpF3f2YitNVJ+6j/VwmRfA59I2Sq1X0tyfamBM0Oxka1sM0w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW3PR12MB4491.namprd12.prod.outlook.com (2603:10b6:303:5c::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.21; Wed, 6 Aug 2025 19:27:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 19:27:51 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 10/11] mm: Reimplement folio_is_fsdax()
Date: Wed, 06 Aug 2025 15:27:48 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <E7371151-6173-474A-A9BC-D3AD10CEF383@nvidia.com>
In-Reply-To: <20250805172307.1302730-11-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <20250805172307.1302730-11-willy@infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0809.namprd03.prod.outlook.com
 (2603:10b6:408:13f::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW3PR12MB4491:EE_
X-MS-Office365-Filtering-Correlation-Id: 62127de1-f53a-4f39-09ec-08ddd51f555d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kz77ZyDDYfpYZEKxYaqtjMcBQ+8pwbSXSki1RHDLYM+gIdPJZX1HgJKOWmKa?=
 =?us-ascii?Q?R8x61NjhXvLsAg9xWrzGti8uejhum+brNUyOiFSmEG93KDkZH0Qi3NoL27LB?=
 =?us-ascii?Q?azZXFgsbLmzEqSC5sftXhsxaH0yZjUls6sHlmPvGU93Sv8Ru6uVwaZjcQnfw?=
 =?us-ascii?Q?0l0yNOFjE1UZVRWeYdQzzIXFVCDTnUzPW36g/p/ERfpEYs1K2fii0vPfLk9h?=
 =?us-ascii?Q?3L/URqSDXCzWaTQE9L84Ndj0YBJ/81+YFfyFRH1LE8JIDvYrzKd9KiaxIoLe?=
 =?us-ascii?Q?YaCooLsotu3BX65GW5iMQttYD38s6PYRL9RT/+BJKksrIIy85alLwUTgcImU?=
 =?us-ascii?Q?TcWpG2hpKXmTbXug0ZKL9PuANCIzGFSblu7oyPyWXcU9qmgK7DnTuo2WnyDg?=
 =?us-ascii?Q?x4wIvk7RKmLyUg1SvaeqDcajo2y2Ug1Xb0gi2Ic6MA2Tp0WqDYfyW3+qFdNw?=
 =?us-ascii?Q?oCRkvwqtGuS5RALyCV57hLfxlpSEvKdkmskQqQKs7xb9v6+cg3grRyCU82cs?=
 =?us-ascii?Q?HXno5uwcAXo+sF6Etex6CcY9eujVxK4njV/OINPGYpmW3bpph+5FAbonY0WN?=
 =?us-ascii?Q?2KExASol24LPrhgcWq6NRM/dqnFT6Gm2xo0Qg0q45BfpJhqZ2WPnHnujjdyi?=
 =?us-ascii?Q?3elI0XMkGa+3mfO7SJjpDkPFL3rbTvG9zTNKatFK9f8+8qPawhcMTaQ3prAL?=
 =?us-ascii?Q?1Khs0aAvZjpeRSTFicwWNw+COw8RWm0JOZumwYQnuJFeehBgOboMKMQnTy0y?=
 =?us-ascii?Q?lPUHyntg63LsyRWIU/B6UF+jmJ0S1GrA6yZBFzVQJBYiogv2xGLBd7wBzfWO?=
 =?us-ascii?Q?XT10dlQjMR4cizlvhCFYCFytx/oI/OmOENR8fvb/kgjtFwHq1xFHfUQfYEJU?=
 =?us-ascii?Q?duHpX5pyiaV6qHxO6Al52xc/oQkLtZMRGsBj+jxL+Ch1QpUfp6/2Zipwb4G6?=
 =?us-ascii?Q?wDVkEEIXeBpOE81hsrbsE/LN73SPwsYnNYk7SI1OlBxLq0UNBVmNBTnTPrRs?=
 =?us-ascii?Q?d6ghPOytyUnspyD1w+kCe+kwN3gsxeILlwYEGi9u4AIUI1etqCgaK5Irynur?=
 =?us-ascii?Q?lxfBwyjExOZrB4PbY1bq2NbT3/9/TnkfSnJumSF0zt3T7PEimMDrHt33ehOC?=
 =?us-ascii?Q?0i+90g6zNnn34o9DTHa2eY4Wziz7t45ZjYnXZkE/gOk8uPth9ar9jBTDdxzT?=
 =?us-ascii?Q?0QMFVzeykT7OX6QpkG3toJRuQMpf+NRGyaFwU8JD/GIOAyNm6Cgz1ZfEu2T5?=
 =?us-ascii?Q?pectHfsJnmrtrZJ39/+UEwn2joDE92bviMhXpB7dVfRgcLvsjNlIy/OojtMY?=
 =?us-ascii?Q?TpO7aeg8SKe3/aNT5750PdbX0Uz6btU8oH3CfNauT6U8Q1tis7E2RtFxM+RZ?=
 =?us-ascii?Q?DbfviqJs7gAlZOROlQZrWVlFOQweomKfrm7obiTKLCsevDkjiLqIrGCyok29?=
 =?us-ascii?Q?vGY6wdKSNgU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O7b5M4hQ6SeZet7k5eKE83JVylH8WJNpo096qISixR2WJ81S4M2EjlW7QOWX?=
 =?us-ascii?Q?yU3yTOPpbR0WAoodqk83aHI8ss72F7mnjNqu7QjpaYuhVDO/VTeJdbrcF6bR?=
 =?us-ascii?Q?bdbdkFo+hcEsIAdOQnvrlCcSD1e0PDAY1NY77lZvnt2jrqHG4mnUPY5ac8sa?=
 =?us-ascii?Q?Z92mC2+AdvsXejFZs+zcevhttrZc50VZIAXWSkfAxsmE+nsRSfXqgVRESwq2?=
 =?us-ascii?Q?ey6hOIDQQcw7+Vej15/yMTq007Z2dCVIFTUHX5r01LLkmhuI8D1EWvjJnBtD?=
 =?us-ascii?Q?ICZMIz1H2jHTW9CGVnGD0rhpxBSluj6NC7OrlhxvvWi54rdjjGGGOk79Y1Qt?=
 =?us-ascii?Q?Tx+lm+xSFeRHJIUWIJRmi5uFRotpDK2iHqOoPpJLjFcxEV0MzTp+5qAoh7gO?=
 =?us-ascii?Q?eX22ykPpn4PcuLgXHTFdmeGZL1td23JOrwVgBsO+8gHBVFZQ5HtMm2m/pdHo?=
 =?us-ascii?Q?UcJOfCWtoPwbCBvYMCCpNnLY8zLlEYIe1OfY9Y2agZ3CxVsDnRqOF0YmOGXx?=
 =?us-ascii?Q?Rz4dcTHJ7D4HAKh++auA5Yy+tka/lT7okzzXjfeVfNkpqbl4/n60Hzo0eir0?=
 =?us-ascii?Q?TNKKu96jLyLoRnMUmHw8yVOC/frKbZ+5KmOVS6gS45cao2i29duksmeKcSdl?=
 =?us-ascii?Q?4lnLnW7aWUVElcjxA9vGTOjuxK4CVPtSib4fAMJBILLuKmNCePxZZ86DpBOD?=
 =?us-ascii?Q?qe4WMQPLHIzUzAmg9yJCMe1aBZB+15ramIH/s+YinvfxBPd8t84DRBilag90?=
 =?us-ascii?Q?ngWaR5rVJFyuZfyj1wEyQFEpL9jD81vYxBZRVn5/SdDwlu0C74NPMq8Xhowd?=
 =?us-ascii?Q?kDlIA61wjyesp3G1iWzvQ9T5670pfZd77SsOSXThNXm/4SId14o7nT8EC7IN?=
 =?us-ascii?Q?H3JC6POUd/FnyWRzFmcIAwpnVSB3Ts/uT92XN+2F4s+LGtOWA6yfa0IPobzz?=
 =?us-ascii?Q?/aNPgucfV3YpkvrvvKGQA3ml2CQfK+pN/NTYW6Pf4jL+QNJrI4unXIAMtYdj?=
 =?us-ascii?Q?VC+v8CZJHUF9863+U6n3rNiP89vN3uJE1q0tV6CxUN6ljIwOpnG14ZUM9cWd?=
 =?us-ascii?Q?OeLF+4npZVKKv8+XwGjA7cdXOJS+C10OsW6cJeNDa93W8m4eLjXSHFlQF0p4?=
 =?us-ascii?Q?TAQn2fJOi2HcS0+ssQUZiqXGd5hiRUddQjLTijP7DoLmotRjXCNZErsMqDWM?=
 =?us-ascii?Q?uP2/haFk5B3cg0TyhcENKsARQGZToAryhAiP56WKXfuX4VtBTXRchk/mRVP3?=
 =?us-ascii?Q?RFrtNt2gn0FqJabvPbZ89whaMizep8ioWol5GWIWjWqQmjDc+6mK1PtX3kdb?=
 =?us-ascii?Q?LT52tb7449JEG+BWTHks2xmy1Xlbz2CIdOdLF3PAVQx/g0knKpcB+cKyTgSJ?=
 =?us-ascii?Q?Xlwg+/LB3n8OXWa/sGU5EV8wqYBuu8lccGdDR6jujNeidHv7FopnqDR6RZou?=
 =?us-ascii?Q?AO3GfMmZd0MnIQ7VtnGj8ZR098zdAdooKxUpX8aAyehGCh/HgijcGqNRWvze?=
 =?us-ascii?Q?AAaUYm+cFyTtQcunY5HRHKbFU1RwIzrLtwS+QA9pAGUjvO59Y69+0HD7LJ6d?=
 =?us-ascii?Q?PlKx1UXy2igJorR3c3HbkXo6ZoZePsEFCop5Qrce?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62127de1-f53a-4f39-09ec-08ddd51f555d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 19:27:51.0781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I2y2Cby3ZURunXtxfiJugICzmiql7+Ym7N0A48SiznOskRdaLUpL39tKv4NhpbJC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4491
X-Rspamd-Queue-Id: E669D40008
X-Stat-Signature: 9bgj5jcbnwdjdaiuj5tm79z3r9998fst
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754508475-103107
X-HE-Meta: U2FsdGVkX19iG7zTZkodLDw+PLDZXSDvrtwceYyM3bCBAeN/CXXRqAeyOL53f0/QlmAn4HOP9S9JW9+NCU6aAafK7jQJnGcXCTW6d/2pjJhxZWc8vH9Bhv/RMrMHrZj/GYQTnFQwldsIN6x2MnDQJKT6FA2Df+t7xmxHujNuxvi7k+tvR1WYk5rkOCRQxdKAK/kYH046vct3dYwOGH6EZsgbabBDNyBeawXQm+/VFQF3R3GI5bnqeqLEiEmyYSr6oR4iqwS6QqICmtmIoYytvrC/rW/CvSSnvPB66vtWI1mtbh6G6FdLzG80XvK3v0/ez0nfOtk5j+vskYVmOCbEMu6qvh6o3IOvQ017Aj85Ol/b32JJ3iHWsFJd8L8kYOBAt19W67R0UZ5ONaM+fkWs0ZbAVGaztEIzjYqidqcgeE8k971qwjtajOgOO+tCdpHmWv+NYFlSxfEfAFIqITzWCTtFBUB+xccRSZzvJ2Hu45UiCIGV4MFuFBm+dIM+YfLiw4VQRg5k+DoPuZ/tQWyU/1Z7pt9f9CJRuO3sbBMU5j9BNWfFsWIlBzPcnhIcPqS4OAcoYw5hbiSqrw3IGtFeOK6k+TWGgKuIZCZntoGx4qYdzUbb4vD28cLBkv2luTfT5pYbQA4Rkw0DG5KB9N4X8Q5qx6dnTP+wOSdQX5IXXRGUEOKCGPQMBoUHgBztvJ4V1T9WSnEppWaJGR3e7pa0X+4QfyXNcJmI5JRomqLL8dn2Voh6VS5+KKVN670GKES+yH3tHjnFshG0eiO/8YDCCwBs1N7c/9SofmAt2EftAh0EyttEUNXx7J+VPKa4w1OTR16Reo2R8qpduK1GhqHTEatwLN5DlRM+3bmSPUj0MIE4CfpOtT3gRRgaBI+kj34sepnRLSzA5F+QJtRdhjc9x+QdalTBuV3p+kIRBIEP2G0Hj0rLEZAM3A7aAt5M9PSQcG3TswuJX73v4Y2srqV
 erf/msLi
 rBzMaeehBTY2rRHVR7c6YcIbZEAIP0tNM42kfEQcNdUUOywidPeng/qpAXJW3xrtxFqFqz2tgmppBEqypG/xlCXcspBQbphwxrvqNI6qDnfIfCt7boh4MVtgWOxe6rQM/FWaYtwle0xIEhEMIlOG6kENgga1GxwxP2aq198gecHTUnIkmM06m7Dqp9qrwo8tUaQqnAvpOeLMUYZSZtUsd7gCf+QxBd+WpG898j5Ql7Su1ppoAJyGrD1Yr+yHnWsRfoxROIxFOiFuUW/SBV40CvLQ+NtpFYb3Eheyb8Z8fq608h/UWJKHhu4R/LD4DvhzdgOvxpG4+B7zLXxdiG2MTkFLzBsOY9vtdlED+8YL6vLa4+eTEWQs/+tHD46QqU1YvGbjfqNs/xRzqDFb/pqUPiXyFzknQqiokeYsP0HfwqXAxd1B07RGZtG7HLR0b3CihVjaKFmrHynFc2KMJ3YMiD/ppWZnFMzpal3BpK7LZ8RrfsSZApZ3V5LoThWz+VPXtQozQjWdFlZMbKa45Y6HGbrTyq8NgXFpBAjPLPNVmHyEjWcU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Aug 2025, at 13:23, Matthew Wilcox (Oracle) wrote:

> For callers of folio_is_fsdax(), we save a folio->page->folio conversion.
> Callers of is_fsdax_page() simply move the conversion of page->folio
> from the implementation of page_pgmap() to is_fsdax_page().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/memremap.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>

Another similar change. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

