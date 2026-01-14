Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6FC1D30CDB
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 01:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C3526B0088; Tue, 13 Jan 2026 20:19:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99AFE6B0089; Tue, 13 Jan 2026 20:19:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847F86B008A; Tue, 13 Jan 2026 20:19:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 736E56B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:19:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CE108160319
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:19:20 +0000 (UTC)
X-FDA: 84328811280.10.47A165A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 32CC5120008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:19:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sKmRFBbQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AfzrR1qt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768353557; a=rsa-sha256;
	cv=pass;
	b=t1IZpLl8aBtEs/UJ+RdFUyFM6MENpzWV/9k1m6xPlqWlu/D3ecufynEE7HGVVx3Y1aa+jy
	HRYRANhtX7F7IYdNp/pFmJf6sCC2d/LHoAHBwaikPk4t82akpTXQsz+GxXvAqe//3VfUhK
	2mWUOpCjYuDrR9tZ7eK+mvOaC+o+PfE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sKmRFBbQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AfzrR1qt;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768353557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8HQKKtCxEr9ZcQtXvRt/MFwzNleZTw1g1itEJ4QMQzY=;
	b=Ox3zs+3WI3CO6Zn+UMPSpUFCgErtnMgkmM7phWMGYHRhtvrAjE0T0bpZ7DlbOLuwj3lOGY
	X628zTJ1C980NREnilGyyv4GPNyHffHMGdEUvZ2DWyIr0kfCuTMi76jEoE9eh4K90yuPW3
	bNp15Q7PP0MuXzSmj5U4rMlG3wac5PM=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60DGAZx12419471;
	Wed, 14 Jan 2026 01:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8HQKKtCxEr9ZcQtXvR
	t/MFwzNleZTw1g1itEJ4QMQzY=; b=sKmRFBbQVaf3VIPCWEAWae/v1IPPk1rywm
	Z/ztYNbnB2+EMH2lXkSrHkSoT8FnyGk22dzxEA+IkuJcqsCRqYNOtRis4ReBcPz3
	MOouWEURF7hDpIgHOE/JCg2IfSd7JlXwUHZd7CzPFeRVWYBZ80ooyHwqkmUR5MBK
	nGbOhkblyinvLtf+ut1nzNatQW6TbiHdqVJPc0SMUw7753EcdCyPbdd4IDw6IUPQ
	o7PdBHnrt7kL+qWZ0dV2n+tCddPvKt0qmhAylYnm/f7x+lO+WRA36QQMjTmQiX8/
	ynPeuUIas2LBBKvfvGltO2PQaLhI6RViCGH1/Iclqr3eTlxfcE6A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre3vfyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 01:19:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60E0WvPq038038;
	Wed, 14 Jan 2026 01:19:08 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011025.outbound.protection.outlook.com [40.107.208.25])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7d7acf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 01:19:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHxYy5dNPGLcYPsK6ni1dkV1q9Dp81cMZNg+h+5cJ0uSS1Jd5lLO19Fs04uchH+jGL3StivwJFYWNcTp0uaK5RFYZ39W6855ZayYRdjGZE5492SVVVl/YI4gxyiPiLz0Py7V/LyuhtTbwE7kvMDHBWGzktVEYCKf7odRYZvkqLqMMeSeZtqj7T1sKQw0CpcV8MV2798BPyec5xwno4+dTn6K1w+JjLtOdY//cSMqg0EgcVWlF6aQQkJMRscLvin2Xe1Qbagjz7fBZfUTCbeQkeqLiklBCts5S3GEDj30P70ZEO0BX7az2SFWW/PSQeE5InU+7+v8XUVJYRsH9gRgBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HQKKtCxEr9ZcQtXvRt/MFwzNleZTw1g1itEJ4QMQzY=;
 b=PaFgEp+1sI0cS1c0zWVQDJirDkb1lC42B7E3op3blA/4FeOFUdm7VYXR6bnjuZc7Mv8za1B+d1q2bj00Jt83ZOQmGbq1u3jLOUcPYCxAmrLA9mJqlXGAIWyKMlDhuJ+DxhRhCQ23ThGQFdTwMARw0f9oqdsgJoYYUuQT/+orfh3kOCkHCdxPZb7YALUDe66GPy3X4JBFoBajG9Wj2t8r83g57i0pKLXUvrUw57yi3Deih2ADC6ojk3Jtqk5LqwKEkDuzdgC6VMESOk/1qwq17nWBC8C3SWN9PXtYuPWBu9AeBtomjNuhVVkX9FhIy/S7by249jFUk0FgWqCGTQx9pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HQKKtCxEr9ZcQtXvRt/MFwzNleZTw1g1itEJ4QMQzY=;
 b=AfzrR1qthgM1Bp7ixHOTHW6pqSP44EfjbtguBSYfJM7EgH2GgCN3zZhodUWma0cgPjj2chjoz0znkiCTL3j/fOZlr52m81rD18b2urk+HfOxy+THXnXST2NNW/24+W1Ahar5j1QAEsKGI1SM9seUDeEAMy7CjbgpXd6eVPCndU0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH3PPF57C8E5D36.namprd10.prod.outlook.com (2603:10b6:518:1::7a4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.6; Wed, 14 Jan
 2026 01:19:05 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 01:19:05 +0000
Date: Wed, 14 Jan 2026 10:18:55 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "open list:SLAB ALLOCATOR" <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT" <linux-rt-devel@lists.linux.dev>,
        skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
        syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] slab: fix kmalloc_nolock() context check for
 PREEMPT_RT
Message-ID: <aWbu_3bQN3nOJ1Bd@hyeyoo>
References: <20260113150639.48407-1-swarajgaikwad1925@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113150639.48407-1-swarajgaikwad1925@gmail.com>
X-ClientProxiedBy: SE2P216CA0067.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH3PPF57C8E5D36:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c06630e-0acb-4fd8-3976-08de530ae89d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9R9ot+tHd4GRxJP4/CeEa1HIcYPwxfR6mGlgHTuMqoZeqNElbOxFjepeSoRx?=
 =?us-ascii?Q?6iRc9qv6M8hinHt9On/NobrKVCkGcPb0oeZd3yr8BTGxV2bx/N4C7RKd0g4f?=
 =?us-ascii?Q?/MzSYCBVqsY5g26CeP98f9tp4A+Espwa/FqFAqG14/lXNUTi/xzKnnPy5nPH?=
 =?us-ascii?Q?ss4aa9Mq61ihm4prVPpZWrP154OmzbjVfhZCnTKTVdTRuG+pnDt4CrL/cmej?=
 =?us-ascii?Q?etqfLOEEVmeIo6j/O4R+YRd1mHTU40OlbaefZP6DGWFKJ8NX4QgSshcOkZ+7?=
 =?us-ascii?Q?M4FkpBLd8/FIWXli629Byxb8oIaKycGLf6y0k+/7a+Yw+9fj/Gjh6B8Q2/Us?=
 =?us-ascii?Q?Fet7a703RPo1mnL3VcsGIg6tkpU1erriN7EUEMbfuB6dBbgGzwraYUdN7c9j?=
 =?us-ascii?Q?1pVnqQTBo+7qr+3edVYeMRPU1miTTsqBH7u5Z1Z7eZi/xtcdMZ9c9m3+BFHk?=
 =?us-ascii?Q?NNdtauFKBc2PvTsgeR748SkDF/GoXLj1ZMLHavezIM6FYMLNXXRxZOfyCrH9?=
 =?us-ascii?Q?ycfU2dk6vfCXgC5IoY8caF2hAiPOqsYzJ4W+Y1X90RLzST30Mh5fV8ESPXpu?=
 =?us-ascii?Q?M20PH6K7HkS82Pw8waFXKPtqnKZ+GLU1ABpk2RoRme0cjJt/WcwAtXZbSWWi?=
 =?us-ascii?Q?TFr+X9mIuRx2c1Wsocf87R1y9ha4XCo9dARt2OzuET6o7FCXnK59cVUwosF1?=
 =?us-ascii?Q?ORKOg5nN2IE8LhGy4APAcbG3kVTLHQt0FMSjxoWo93cBgS+/5i+XH/6RTH9h?=
 =?us-ascii?Q?yTBcLFIKnXAOswY0JAXt7wQaK9wnANO1tt4oCdBESBVcN2F3d+FxVCDxRcP+?=
 =?us-ascii?Q?BtckM3XuFK6mwBxvc58v5PXUjFBXVIQP5KoXF6mSTpw5vMxRLerON4COp7wp?=
 =?us-ascii?Q?+Uz9xJlZqO/0lEj07N1/tufYeOTcdadZCExqutXG7uI0hIa8IaRjca6fY4Vd?=
 =?us-ascii?Q?VeIFfivfFrh0i5teIbvgI1b85SKS5T5wmYRMrVW9b+HAgHu0XdNE7XfrpH29?=
 =?us-ascii?Q?XVQ+AUciOe4wG2D/OwbSFqgq+34zGsjofrb7mcSVtrWMoaf4q/n0z2398zyG?=
 =?us-ascii?Q?JN3tMEvp8a7fCn6eV3rPAecsogUPLYHBhEOerNLCMcXDIN1OCb/rkDow5jHR?=
 =?us-ascii?Q?GDcdsP1NPappYUA35glF90MZfZTpIeFFZTRzRrAoOmxflSIBTv+Fo075Ov6n?=
 =?us-ascii?Q?4yzUi0CO7dj6pJdJ3KFu8FyqlDBG1RnnBkpeXEe4nnu49sR+N7mpTs3p6Qwo?=
 =?us-ascii?Q?BOT/34zCKQ764pgz3q65Sh9oVBRqY85SEPeDW3gf9oF+mluWvW4AOhusXMMs?=
 =?us-ascii?Q?j/xcQaSs2lNt2MiRNUz7XlPKXulMgXxjKffusg4PBObq3KQJ6JxCXKlEAi/t?=
 =?us-ascii?Q?eFeN0BryGR9YaAuHOWSxfSzNZEXSXCkl8dary2VyvpDTNW1c/A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?E1PLpY5J2WUepXHrrOn+YV+A6lLUd/tz/RmLXsRg76qdFnN+T30MbmA/y+5N?=
 =?us-ascii?Q?aH0k8y3fOQjCXjEN5Xy+7xPDUSifcEvvwJxegoJWpluek8nkNx4nDC0KhrMS?=
 =?us-ascii?Q?NtCmM8gU8NK9QQdyqOVBIWmCsg7bUzBtS0cnp/6cLyXmOnQyzy+eDBujSdAn?=
 =?us-ascii?Q?t9X5zExSdhPI0cu3INfa+T2HXPAQ+tY/xNLczmvt+vXeoOoMBB/x2CNXz52R?=
 =?us-ascii?Q?kmMLZfA/FJdJ10el/ls7SQuGyjXP2lppkxQ0MZhbjKBSBURZgjv0cn5d17oc?=
 =?us-ascii?Q?HFA00Qskd1i6viuRXqIc5fCmi9S0x4/fsZoaXynhBuUDOXv48S+gfQ7kGNSz?=
 =?us-ascii?Q?phY1B0ErZEGQU9aDf4Ox0L6Tlx3CmlZoGCBYravp/1ui47qQvI949A0l8O8e?=
 =?us-ascii?Q?TYcSQCW1nZcVOjf9Y5bSerphSw54MTCuP2w6ScENXuzWLa+ElXlDSfirLFgi?=
 =?us-ascii?Q?Csxjez3OeO5tfCZLWF8KaGQ5FQAQqOIyT39RxqMf5SZBvHdMn+5AGj3HatfN?=
 =?us-ascii?Q?nbrlTV5fOvwBk7hsi89qlx1HGsK9bbuUonbuwH4Doja+FRWpYB9aEfznKfPm?=
 =?us-ascii?Q?8wsbp6OYuhCtjg4UZ4hKBAEDSuXwFIy9SxI+ogff6zQmNER9XmWz/cLRCrhl?=
 =?us-ascii?Q?bDMC3KpCCCVXz0S5azuy7Xmsgsl3mpxuhHHE9uH/wlDUa/Nt7hqUSMYlxM6L?=
 =?us-ascii?Q?FCAeMU9WL/AXhM1BZ0kJSAKQNBPP2C9g9LPwWvIrKzOXw73EWxLsa0uIQA7R?=
 =?us-ascii?Q?P+FhsG07k7KRbsELB1J8XYWUQoIihv6ld6h4PUP28QYPUPXLdIOKUE0ybIdo?=
 =?us-ascii?Q?iNTtB3NxSMCnVB3ywZlAGk4TNksdjPPPvsIGm4Fjan+puH+Y5ICLL6xQRePD?=
 =?us-ascii?Q?9hShFhFANcTSucbEOCRrcsDi0fH5kI5vCoGbrhOLYASzBJreCsV0G5EA2o9B?=
 =?us-ascii?Q?zK95yuP8HjCAFEEnJpArDvMmlUicT0ozEMSW6XfyX2FQaxoVTy9L1FnYdVwl?=
 =?us-ascii?Q?C1EY9OH2Yl0aDZ+fpJpNbKrTGYsTTJs5WFYLfDeXK6ve+DgvfTzN13rqLXlt?=
 =?us-ascii?Q?RwCx4Sx+byZJ5F+KTSBF37zh81hLRs0Z46mzEa+A6UrrYuRYFf0LIdx8OFue?=
 =?us-ascii?Q?sBxB+bc/mAkwOvOR2C1sh/6AKsAintmAiwYNdxcMyD79NL+pnd/UAdIuU2Hd?=
 =?us-ascii?Q?AUvvh0kIxs8OQjJg/wtAhNT1Kkpc3qE3PSJQNK/Na6hmPzlZUpqPGf1K/tLP?=
 =?us-ascii?Q?j7kyTLeD9xbD/txh8ews5kjoaigNIgoLPg9m+5ekSWS0I4KEOYhLS4/I06Yc?=
 =?us-ascii?Q?cKiyb5IYJQlytKCtitOpJ0yu7jwDIjwcPsnnT+XEt9QiHRN/4cXM05d+zwzS?=
 =?us-ascii?Q?dhbug+FDuELsG81a0oTnk9DFZKs4Ckd+Kuk7aOzPQq9EUfcioOsLwzFNWBHF?=
 =?us-ascii?Q?Dfp6BxqinbD0ojWvKGmtME4kKzTfFT32qEzf3Y/NojA3cWIP1VFtpDwutTaq?=
 =?us-ascii?Q?Sy0JuS5WgwxThNwPsqQOcVsyyFabh7xYoFzvgG4ixUHreNVpXLQpJkj3yzSi?=
 =?us-ascii?Q?ajFuuV1Rdb/mPVA2GpyLdzRm27K0mJH+hBuVyBX7MYIY7w5J1FsO0nvI6aGi?=
 =?us-ascii?Q?mQ9gUAI6tYFX2hvPX1C/STPyVpbWSU2cJGaak3u8MWMdbrztHSostXZ0SgmT?=
 =?us-ascii?Q?g0Uuerkae5Ji+ZLm/CDLOuJTvYCfIPKZEn2kKGhZLqxKrFH4ubSNp0j7is5U?=
 =?us-ascii?Q?6GeGX0pXtA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	skgg5bqqjP4cUu4/ldzPmSotUsTAUMCdDvqgleqmwiWF63aQzIgG/DU3QZbNNz6fXMRKBNAMhwzRwu60YNP3NtRvF89362N/y7E1SC8B3QkPndcgKUOijwsjUo6+2J5zZ9glm6muVsCVnXTlQJt+Y8mS5lFTlO8lsvT5jYY/+m9gTc7hRIXkNrTxWJ9OUpYxvDDaeyodE0o5XSgDJvuPWg1enkkS0jvMUQzszOcwH2ondMQeev7qXBc074KaQV5epUSS0hvKsDh0p1SAt5h01L0dfElZHq2dGq7yxSnbwj94he51oR1tFnfGMAlnw2xLImO+OEpw8E16gMqb7jv32Vmf6XrLvNSduZaE4wRnxWdx/Ys4Tq55QPpkZTHdkDP7e9wQpojc0fY0TviW6pAHwwbpKGVlE8ox2u78nT1bkZbOk+7qwciglolPkVSSnN1os3pbvlqtLXuH9VhxM9WiSMvahfZKwBfB6717906HiUYaYChzi14FJskmaCHQQCZ7A3z6ibK8E0kKysZXDElGU/dgYmowOVI0PHrcq5vOJh1NFcuUqeHAG2SHTcEdJy6BsKEdA8AdD1t2bqCkXycFPk2+q3XO/RDbH6v7Yx3p6ss=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c06630e-0acb-4fd8-3976-08de530ae89d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 01:19:05.2611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ySzi9xRjbrPdhCHYrFXrYZzH4YEEoetIZR5jeqMYOQ47OGqCOZxZJ/nu5hzJ8020W+M2qQdP9xpc6hSmirfgZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF57C8E5D36
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_04,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601140006
X-Proofpoint-ORIG-GUID: mE-Dq8H-KGLnXDVM5AQxMJQaaV-BXzSv
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=6966ef0d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=YU4pcquq95DOUhH41acA:9 a=CjuIK1q_8ugA:10 a=DcSpbTIhAlouE1Uv7lRv:22
 a=cQPPKAXgyycSBL8etih5:22 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDAwNiBTYWx0ZWRfX6Ktl4SD9UmKb
 f/yfeq11pkmv6w/t3ZzlIe0vK46YNCjN2RchVANxwV/omcqY/EwFTTToTUfAZYwpP4kWA6gP5cz
 hZ6+is+VaRc1XejlJsnvSPXz5hTAlFo4FHteijA5nLGtuTpk81AN3NgXFXMSZnDM2e2hjGXrHpM
 v6zGbHGm/Parl2iufizNooung4PHeoMmPGNECzUJ+EXsho4joljovs+E0BWHh2SSr2/nRFpJ3dp
 tIMXGfoNmR0WckG38+5dxbtTPnAlNp2ZRRMVscz0d6xj/tvowxSIk9CUzVfr5ja0sGSf0biMmI7
 S79uMjoTId2Np5GOwqhWAhAlZHb1HaDO5OXymimIhRwXlFcLHXPDYZaKMzoaPrOKkaTDXvy+n2I
 92M/jLissO1YW2vazrZYXd0gBody9u5H5rF9S5Y6KC7PXEFG9AjU0kQoN5r/QTqCeu/BqM5rXqt
 4YhPqVLeIbkPE86LCInGFmDeEbFK58y1mflJ4ooQ=
X-Proofpoint-GUID: mE-Dq8H-KGLnXDVM5AQxMJQaaV-BXzSv
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 32CC5120008
X-Stat-Signature: qwatoo79djqsch5zpy88rqtzkuhbepy7
X-Rspam-User: 
X-HE-Tag: 1768353557-5451
X-HE-Meta: U2FsdGVkX18hscREKmOYbULuyFehM4xXAHrsINkTQULCActCAk2ae8nsKvnS7zEj9kG/BUckdxfwYT6kz9cE6vHVv1th0ChoSUbrecp+SVfCgtqzD0U3ZvNgTN8mKxJyFc0dYY32JDh6oQQC+WtnMHRCfcLSJtRwPbOJZ+TKfd+hyfymSsZPdN3N88wTAdYhQ6ZIShN0MUQHQJsvXIPH/8e++IkJnuVZUGI8JrMjWbwr+Qu+ea5Wlabpz2FDEYbOwvMkaHLIXhBbiQ24Wvpq7GpskZ8azAn1nztw23xaoOTc7S1kzM39eEsYDjXQlT7w9UQBLm4tRHtIRCJ9drSPHnBADmYfRGOnmg5DnuUljiIsPycvAF9bBROezK+Sd/RXcJj9Z22YuW17vJWXsjBaj5gzA6xasmU2DQd6CTsWIeLarcMRtl7g//lP/iEWocryoOcWv7RyMd2WDHsvW0WkzLkhj3uT0d3BpghzdNSUsBgmzc8L9kYXZ/F/vaAFzLpzuACFOWaYUetVbke9DOduCE0Pr1C6JCdCRIeXkH+HHL9qKHB1Dlej09zdC7ZFDQGlz8rcTEND7KRfAwYtNdeh3Pb8KxVV8esVP5uJ5qPYlsPuYpOM70mO7qFCex2nNG+WUX5zABUkNhBH4FtWvuhX/lGSn/xh+eBgZ+Ma3iNFBbaXgZdgU5HUcfcSETPed4ssdy0+NE/rSUMF97NPqj5m/ROk8kYVoEsd1PJKaWQxjMdDC/1Hx1LDkNanglPKeAvy3rVKMRN7aMx+OEPtpG2gUkjQNgFhGpjoVzeltXx0UEjQK7ckk8JRXwSCmHeiaEqLl99j+hIwfn4vJuGXZAyTwHQmMZLu/nOAyqtQvmzGXs2P/kwkkxmpEIKidOaZnHBLglKnh3SQCP4sTiOFBfbBZQUxSI2wfD3H70qWqvAXOuJOC9Pj1xC5NS553beyIYG7tYy2qr5OAXT9MPs433G
 6kBQLuku
 vEaswwfEG7pN+aVtNN6UmF/n0TnXvLQqh0041nVtsH0cr49RnfhMZ2h/XhXmkJYrH9SdmeepgYqJ9m6sewdF6aHwoGn7Rhljj0v+iFFu6+ewjtLvFRI8vEvFhSDDD7W8J9gU7YeGyMb7v0sQbQkFvxXxHQnR/sEJ5a/Tm4JpcOgHWE27ZAErHPpFiOUQdD9y+l3za8zBK2w0zqGFx7pmciLiil4papiVxk73k23nePFYFccysOc04/bQboGYwD/ZlAT5xO1kEcs4t9FSgiGG3EHUkBYPmrsux0IqArhFpLuQoMUezwaqDu41CGwQjZIuZKmk+alvw7hVrOseIBY3o/kMOwcC1Fxq5kEG13Zs2WH7728WBzvVhdBObAFQF2BuQLEAef2UxNk/EbvqQOJ5d3QcFFoi/K9d9necOeGg6y2+r+4RvzEb+uTFd+MFoFMxrRm3AAJlDkMCZpxWiEeNl+yOFtlfpRjCqYM07ZfvoIKdDmSaWGFI4VyJLmoJc25u4SvyUvgyxyn5Ty1bAX1UXENAljFWazjuQNBjXYQkycNY3zG7ThlyTSXDzFoAHwKHvvZM9A0sg4zoCXnDkOw6HdXHeopbWaV8rgHVIi3Usj/jzXIn+Rhj45zdVjWBU/fBjP0VKeL9nRdfVeHRa79LV70ccPHhxUhVhnfIUqsMvOOKTBkU78wx4w0JPmPmX42L+ZrID5U4gVUzd+0rPBuhJSJNf0x/or9djEMwhTYKZqNNfVT6Csk40Q0Ez9UuAL46ph0UJ3NNEDpQntKJdc3EDbsmclnS430vfDB4AoO0Htp4+f5WO8aorzkpcFOFVGPiJAU7c+TJTc6yPWi9P8Blc57XOW5KqLjmSyet8QJNBWRZyy9+vQkbRK+Qkuah7sS0WV9PPhTGOQg5c7PYoohIgcxAWfYicXQs43qQ4eb5lYWMFtSy+dDYtJ0uU3Mszwii7sMtDNJWLSIGz7JHrXYIvNJRB6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 08:36:39PM +0530, Swaraj Gaikwad wrote:
> On PREEMPT_RT kernels, local_lock becomes a sleeping lock. The current
> check in kmalloc_nolock() only verifies we're not in NMI or hard IRQ
> context, but misses the case where preemption is disabled.
> 
> When a BPF program runs from a tracepoint with preemption disabled
> (preempt_count > 0), kmalloc_nolock() proceeds to call
> local_lock_irqsave() which attempts to acquire a sleeping lock,
> triggering:
> 
>   BUG: sleeping function called from invalid context
>   in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6128
>   preempt_count: 2, expected: 0
> 
> Fix this by checking !preemptible() on PREEMPT_RT, which directly
> expresses the constraint that we cannot take a sleeping lock when
> preemption is disabled. This encompasses the previous checks for NMI
> and hard IRQ contexts while also catching cases where preemption is
> disabled.
> 
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Reported-by: syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b1546ad4a95331b2101e
> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
> ---

Acked-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

