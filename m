Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7D8FCEE334
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 21:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC586B0011; Tue, 18 Nov 2025 16:35:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16CE26B0062; Tue, 18 Nov 2025 16:35:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00DE96B00A6; Tue, 18 Nov 2025 16:35:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA4876B0011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 16:35:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B66A86D74
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 21:35:07 +0000 (UTC)
X-FDA: 84125033454.21.DE60107
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 008F6140003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 21:35:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=c8Y7+HIg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ex7zgS2z;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763501704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxX0WvXE7Avxn2Vg3yCriBQYX6HNn26oc2YhD1+DUc8=;
	b=vIcy+TYgYFRBuG3/Dd65xlpWyH8tOF67NV2fHDVhxB2/Rx+pZ7559kYwOWX7dv90adMIh+
	wavATpDIlarQ1iAyEpsB2GtP9PTvNnSw5Mb8cKUlS0NRyIvEVvrBNU4pkGNlFednlI/C17
	XJ7Zq445yeQgCBIyOS4s16kyE0PzSyk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763501704; a=rsa-sha256;
	cv=pass;
	b=aye4/DDN9kSE89pyJNDFznngsIc4NhVrEL4dJNzNEsMsJol+f86rAPcs8eIMUZm8he9k6o
	8q0DVDRJZ3Ypgt6BZUEzHySfdfVWJZfrMvVWOdzpgPKiBPwjEHu4kOeqAxpzFr+CmOVPWt
	bQmDvVimxJ5cWrAvmPNz3Ll2GKE7U+s=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=c8Y7+HIg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ex7zgS2z;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AILNf9j020603;
	Tue, 18 Nov 2025 21:34:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RxX0WvXE7Avxn2Vg3y
	CriBQYX6HNn26oc2YhD1+DUc8=; b=c8Y7+HIg4O6iW0SIas7VR/D7LLQE909A32
	n7rZo+uJtlaHn8riv4dOR9QBXnW6NTykVodDPOaRX19RjCu5Z/of3Zi0YEe2AWFD
	SJ2f4iQ9bmwi5PeZS+3l5SbNhXsq/lFY3XfXTDzLa84d/CCXs1rZ7XWPD4aOISQ+
	UBl8uulPo4S6OFwSa5TaAl1tcYA/a2OjyJD3JlsH7WNQy1mSfA0PibC3TiM280d3
	9vBPT97DoiaJhjF2icL9tv+0M6uQ6P0EEUaBdKtgnB4WaG/1FUn/b1UqXSsoAMg/
	Hp0UC5eYc9WDk4G1episnrrAcxJJngbKb1W+Yy/JekP5s25DTkEg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbunren-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 21:34:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AILJjgR039834;
	Tue, 18 Nov 2025 21:34:19 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010000.outbound.protection.outlook.com [52.101.56.0])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefym1e6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 21:34:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ynQ52LxGnpNpnwuUKLJghkhKryezm/Wj/GT2OPf1QwNc+aaQupj0SqNx199gGzWwIKd0UGcZgXADP0AWYU/W0QESm5YwJsupHiL3eh2yMhMUbQ/kPUygmkHREU4nkk9RKtfApK9g4PCXjX819f7ztrwbKk3bJw5jNSuDOKSDLCsIaRmQfTafmh/e0PNtOilt0Bnu85SKGmfeSddSRUEPUMRY3HtJ+JWzrGXRCn6jZaRLSc9caVNDwJmqQogUPMO/7hahSANF7UrxjvpQZcfrFqsS2HPJS9jvKb2qBNNdDIBdiItaJIA8TL7JMvP9wvAFyRlceZJ9yFknKsZ5d3V1eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RxX0WvXE7Avxn2Vg3yCriBQYX6HNn26oc2YhD1+DUc8=;
 b=zLO6LLXghZZmfrQx2qwoeeOW+85R0rrbMS6LZw1EVDxCxAyNUyXWn+lPthXOibdu8HNUalmHxaIsM46E0qUJYjw1t1HNyx4TZXu5UVpujPUkKZJHI1NHfzEwDQIYS13QnX9TR90/6lLtwa2fI9P7yyJWFqwjRI+wj4nxgXQZ+sOXJyel2hla0GwOtwBPtXm7k2v+LCyW98zNmD0nLuqrZVkvFfjTYhVdYwDaAJiNFG9pkIwNwOmWZaMXuKyu+1ghGwXPEgvYHOap+TUtm03rb4yxJ+LQoSfPQ/eu8a2hfX8Qt/SUZ+qc1JSGf/fTi2fMflth6KweGbTu5v36zlK4Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RxX0WvXE7Avxn2Vg3yCriBQYX6HNn26oc2YhD1+DUc8=;
 b=ex7zgS2zhzJg4h6NZjaNHvMiM/HeqFWwuO+nnAOus2/+1NM/BpDjfz1DIEMi6hzNrlQlQeiXG/jplGJpX5rnKVGGI+ERJzKD0OtBE9ROFJELuwq1Iq94FuhAiajNpQx2LtNEghQVWGSn+Qnanc4jMLawy2/oSHeNciO/obqXe2c=
Received: from MW5PR10MB5764.namprd10.prod.outlook.com (2603:10b6:303:190::15)
 by PH0PR10MB7008.namprd10.prod.outlook.com (2603:10b6:510:287::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Tue, 18 Nov
 2025 21:34:16 +0000
Received: from MW5PR10MB5764.namprd10.prod.outlook.com
 ([fe80::412:f26c:21fc:faae]) by MW5PR10MB5764.namprd10.prod.outlook.com
 ([fe80::412:f26c:21fc:faae%5]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 21:34:16 +0000
Date: Tue, 18 Nov 2025 16:34:04 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Kees Cook <kees@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Gladkov <legion@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] unshare: Fix nsproxy leak on set_cred_ucounts() error
 path
Message-ID: <64ynd5y4deefh5wmoudu6j6pud67373hf3esrm4ssn4qi3wq6f@y5ytbxbenwnm>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	"Eric W. Biederman" <ebiederm@xmission.com>, Alexey Gladkov <legion@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
References: <20251118064552.936962-1-ptikhomirov@virtuozzo.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118064552.936962-1-ptikhomirov@virtuozzo.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0455.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::25) To MW5PR10MB5764.namprd10.prod.outlook.com
 (2603:10b6:303:190::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR10MB5764:EE_|PH0PR10MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c9b7061-f498-4087-7b43-08de26ea3925
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pZr8zcb8ZY2Yz6DNWd1eLdTgJI8pr6WdJygS6DDZX5bYDT1ZWfmxSiJIGCV4?=
 =?us-ascii?Q?Xx8+bAFR9VnY5JIbDXe6aiCJoY96dHRfYd/37+eOwEMspwixNl/yS0teTkes?=
 =?us-ascii?Q?fPSlgwGMh8p1UstYnNLcFI4op+j9RKKUWxaAB8I/nr+BGusUhydyOwQQn4H/?=
 =?us-ascii?Q?OcAH7vIWSU2+pKJFOYt80JboslaFfYngermDwDCF/sEK48p9R4WgzEpRnD9P?=
 =?us-ascii?Q?1kZfgyJc4LlhmxTvcrqLlYWnY5Z9A2llcxUjD+95L0WgGbbHVVAXeHG2M80e?=
 =?us-ascii?Q?sS6BE9qRqLDcUXN0LBs/9DsqUrwbEBDOCqGUk0bU7BWxJUUSoyqaSngAdYKu?=
 =?us-ascii?Q?lpg35kaw6D2BXl0HvY3NlE49u1jSMbQFv2pZ8KgIYge5GmtHnaAn+BlG/FCu?=
 =?us-ascii?Q?Q8Z1zOun1r9Z8cF7iJLJYkB7gZXFLjXkI53m6FwXj6GZI+xMDlpHujIMfVQF?=
 =?us-ascii?Q?/jiTW+DydmCJFy4+gaHXkMxoz7HZ/VcOpdcwOW5dtRZcqxW7IVlttqB4Lr5r?=
 =?us-ascii?Q?X3xBzM+/HuLWtusjiXz47nc1Z6MH6U22OKQEgzmc255XWyAoZc24GNThVhhD?=
 =?us-ascii?Q?GlUohlarpim0oTDk5Nf9pteB/63IK+yAKHLmXiRUCB9CflMAFQHOpKpX8/pv?=
 =?us-ascii?Q?3DmfGmby2zvjyFnOoBBnfxIoK81oDAJG0sFFdLYzbsFlvAdMOvIqn9F6206Y?=
 =?us-ascii?Q?HHVtUmow5Aa6dGtLrz9jpe8vmlTmgd8g5odyr91zVqPwKPrB02pu/LOtnTKM?=
 =?us-ascii?Q?NFCbekqIb9hHTT1xOywDkcbmaUw7bgO2BkeOwUXNBzYeKiTxVkeI9eS42hzs?=
 =?us-ascii?Q?o0EvONAKUraWdW0+R5GkfbSjb8+D8vGLqqEbToNm26MamWD7btUOH4KCDQyZ?=
 =?us-ascii?Q?HQTsh2j06hwsVwFIqYUo5cW/tKDNqB6uvl8N61ZAbVsXDmJPl36lwatqN7yN?=
 =?us-ascii?Q?NqR1prlSr2NZb9PJkrrxR4VGLO+rQWyHKNMFkrQZ5GBOeM7x1jkcNo5xAC0e?=
 =?us-ascii?Q?0WB0iA4qhNs+QKfa5sebQ2CspWlghbPzGRp7Yxs5JFL8NYR+Opg655NXDOX9?=
 =?us-ascii?Q?rjSeDWL5/O0WrwI3uOmR7CAAa6gCa9pQan7FJWdprj35em/4XcA/Y2vVqjv1?=
 =?us-ascii?Q?Q72l4+LcNtOaxzeXpU0EpQBRHBmJSJncR0uX2K2s4Tw5LJQ0bdRBKsohJA+A?=
 =?us-ascii?Q?sxnGND9KQY/QOlFXD2vy+GLiI19OmwDVQ3g/ZKwy81OqEIrP5Ry9crNnJzsk?=
 =?us-ascii?Q?4Fcef236JmPKk6cPBseHiJM9xbERb8qxZjiGbIs5GTSFN13mAls4HTBwKTYW?=
 =?us-ascii?Q?pugKNI4xY/EXmsfcaBIaZ6pbLRlscdQK6v6AQyNpD1qgCllnN1baX0P5dv6J?=
 =?us-ascii?Q?40JJW7TmQYRD4wDPNfpGZx9XySpBcaDFEzAO4O1yZ9gECDs+mQ/r+0iRWAUs?=
 =?us-ascii?Q?2EMKGYstRVI6OjnE6zJ4pt6W+CfrqgAq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR10MB5764.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1APcCSqrjByeRencZVuEVFeji0+Qs1cLNOhLMOTG4ak3YO3JIL2LA8cr4s1d?=
 =?us-ascii?Q?phciGMAKvlD2S3NfXeQV/6dGVd3EJ/2ETR2RTXDGLfe4fmBXTFniHyLimyGX?=
 =?us-ascii?Q?xVIbfmYx3y45IZCGBToqyzHBmnJQ2Rhpqhn/V9AqXNqbGM5+RPZDbqrwYrcU?=
 =?us-ascii?Q?+MskK8lw5kTs+SfCLpIhmxOzlA/ry+oKIyuKMDUF1Cl7rrIegxK5oCqxodhK?=
 =?us-ascii?Q?ldk/y6C6a3vJ6tydpZbNGDxgAyK1+N4cXIHfJsXxKo4QbfEWfpH1XgWXzK5Y?=
 =?us-ascii?Q?C+zqotwqMNsZmg3XoYFw3lgQIWzg/7pa/szIhwFqBDnmeg7oWEuRTyXXbpzD?=
 =?us-ascii?Q?thx5gMV0bhrjgZ8qTSARALO6rOQBGgFZ7MeyxJYi9bQC0RrnnR7FEbbv6Wh3?=
 =?us-ascii?Q?hxHJVdww1u1u3ZCyNuRJKb04mD6R1PTyI1NfM4zRukxgSwqERkDqYZR1SKqC?=
 =?us-ascii?Q?YHw+X7dbJQLdk5IzbkWl+vM94qItB+AQbOrVNnSkOUgfOo9VmZDHqeJE/nhC?=
 =?us-ascii?Q?qqUb9JlrYpkLWtQnbrteahPAwxP0iTMkGcd+yePJBQQ8K9qkndkPcr64xbu4?=
 =?us-ascii?Q?+AevcaJUBcBWBdgoG4CNheqFGHPTtRmlEPiZkR83Y+uBhtA3TvIXD2rO4oB3?=
 =?us-ascii?Q?cJvHhxrfINyDI/C8fse6qZKw1ryeghOQsKL2ElROKVbasYBHXIt6UkU2Hr1W?=
 =?us-ascii?Q?5S5bu4DjbDetkHd30VvpRpQNhu7v0OzIZapNlRk2oSN/eQ5ovVTkAiBMvIKK?=
 =?us-ascii?Q?wkrTLGXddmpMNmmqXb/8VrElDoN17DKe9LtczYSTVKlQHHl+hRcmI73Aij+N?=
 =?us-ascii?Q?CgKwqEF1VZdVDumkCI1AI686m2X+fBv9Q743DQNams26zrNvI0agEbZWp4Mn?=
 =?us-ascii?Q?BxXpQmMznWUVVGAoNAdcoHeoxiGpaRn3jFtR3YKvs6b0ZotqjGXj2msS+vpR?=
 =?us-ascii?Q?JJolKjnXHh+TZAsIMKOMiumgxqinOPDldkaShJ7zJsLvpIWlJtWL/UOLfoB5?=
 =?us-ascii?Q?aJEace8MNc0J1SWwoI4+4Ws9kQKwi3ZYnzHN966qtJoNgOdkSyqwYzV7e1V+?=
 =?us-ascii?Q?QY8BZ/OjzhnDQiKnAycCRIz9UroAV+m6TSaw9DRvKLqZVAKGmEnjiYIdZ5ZV?=
 =?us-ascii?Q?+gfRIY8RaBwT6iwp8t1LMxEPABEoC8L0r+7Zk7KzSXO6j6Ycqig0dNorxFts?=
 =?us-ascii?Q?94MJao/D0pk4crBUgx24ReQwNAhH1tGX+rpuwDSVRuKzm0r544AH7MbG+kDw?=
 =?us-ascii?Q?s8kUczY5HSlFWisV2MOqYpry8W9v84AeZ2tq5WAX3ppETRFAJmE8YYIdXs6d?=
 =?us-ascii?Q?FaTQBfLKfHRnm4h0g7RUtus00UCYEnxP/9kVY2y/cZAFz3yOZoW+6nYS+8Dp?=
 =?us-ascii?Q?9TGiH4da+cHZlNoOHI26T9vLJXIoI8NsddnAvl6c2HK2EY9pkqjpRO3m/00W?=
 =?us-ascii?Q?EzhJtpvA4yhD2KFhWIGQjw7q4CQ9N2OGg82EH/gDUfET4pPmt3SrW2jzV/ls?=
 =?us-ascii?Q?485OMeJ3fQAi/GI0xWH4tssZKDfkcCSG3b8jOs8eqkbxNs2GXUDK/jzcLu80?=
 =?us-ascii?Q?2IRggN3uzCvoIx3fDd0ldwLt1W1MKkX2PGO3JnuW?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/RDfFaRjkmPEZCWsTnFz5HdlJYnPezsqebgV3ce7LFizAmZwzExsQg1LrJSsUPZobX+YV5nFRMa+iGrhwy+YguyxzEl052b7uENJ3+xAn99prOc4E3TEQ0TcczbYAp5uNDl5lECI+kW2QgAVxpK+4UPv0kAe4UqPO3t2KisTYdMumHDlN2yTJiYxWhfMDqwJVz8eUuSZSK4xGg00gFIpEYd0IzmwOlpS4kTOZqwv6Ji+Yf5pifB5YdPYUGNh9CyG2Lll3fkAWpSNqqgLl5ESER3b5OsZe3L+UrX0COvPRLXoF/k+0lW5hiv8MLQLsziPWj7ChgB/ikeIOktXnkw2+OppeOgqydm0T2dOKre4GAYR5NZ0mh80YvUGIV6hQFoUP41NbRYRBGv8a896Sr9p4J773YpL5IJHqDsbwIeNPGK9QDuAxOfrkHrX3u456AiHBgISEcee6Pzj9nS8cJPyM0Doj6tcfTxsn2uYvanCqS7NdxLIUjxp1Loj8Vff/poznLoUZ7uEk4tyL4QCykaeCrs3DryhcFcMDw/b03YIHfTyT4yb/LBYZ5u4hloSTh1cCKz++eFzux3d3hregCdTnEw6SgmuqMRNtG6uQe5l1Is=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c9b7061-f498-4087-7b43-08de26ea3925
X-MS-Exchange-CrossTenant-AuthSource: MW5PR10MB5764.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 21:34:15.9431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZYbOhw1ctqfP56/tx5gveg0uAojyA7gLoxr5YI+SAUcp3f7PVYsDCiEH4rcNO6t/m27S2jY6F2LxTjaDasGOOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7008
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-18_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=756 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511180174
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXzCylJXSoFH0X
 JWWoK3icxikdMgU6jJNSNzQvYE9kzQ+up9QOKSKWnO/iBqgkjQNbLQDz1A6UeNdFoDSw98qqPBF
 2nqK7tYgFt4VDDv5io8hC8eEe5jK3rTwbS12x7yKTgX0+wIVmBtHe61SxT9tH3ShKUZbykyLrGo
 XOq/wk6YsMuTo0Yi1KBF1yEgNuIEjqusQGWF1uJ5cg/MhlmH1WeatrE8q3RO0PVjKmbmeGzfx5z
 wH7OS8W/aDEcwYcV5G77XrEMTp2ncP7tC5o1ECkx+ExwMBurcgpZ1KSL49uVFFj4PwYrZKrkpe8
 dENdKt6jlGmJ/3tLEXxAQFLkjARDdurcqzN0EuqFa2NO9OWv/uBks9ZOugmG99EULKf3zAWPjtX
 ouvRGBlVjgcunxGEvaw5SyvzcS97Hxzb+kGR2VXh7Ck9yVp0Sa4=
X-Proofpoint-GUID: NCNkMxQqM4c5X2AZwHeYZ5npyYL01Ikf
X-Proofpoint-ORIG-GUID: NCNkMxQqM4c5X2AZwHeYZ5npyYL01Ikf
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=691ce65c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=TYBLyS7eAAAA:8 a=yPCof4ZbAAAA:8 a=V78TwmPrxljE7T2cudEA:9 a=CjuIK1q_8ugA:10
 a=zvYvwCWiE4KgVXXeO06c:22 cc=ntf awl=host:12099
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 008F6140003
X-Stat-Signature: mxepcw6hak9tjn96rahpjrrjw6affoik
X-HE-Tag: 1763501703-623183
X-HE-Meta: U2FsdGVkX19s31NIj91Vxfjh1CVzfSXcdfYhk+5rXk8HFySKdwbYLXw03X26+h7kK7NflDxgClX4nWxdlu89vdj1Nwq1ZaA79+ldBdO8yZpM0MUBRI+5tSVrXJy1w3msTsEqMTpluko9cx0wj7EBprzeoEj8cKFp3brT8tFycHINwIrl5fAuGjBp3SZ0yD/H2LN4fscpuu14oeOtCtS/PHtHpWwgAXK6HClsL0wIyBzrU4P0649v13R7dacW3EboxMPk53nxUifNkuFNXTxC/22AbMxpSZi7PMF68oSRZ2CgnX7pYWziOf2j72zIr0Pz0DHsEZyoeyneqnP9r/T5hguv87Nf2PdzuAVt+XECVPNzJMbuk/j6BIwjFL/3roWcXwheKnJ+Bvum0OU8uOPkfiJkKmV9ZpdarV3wMeNqFXPRxA5TvobRX+lAm9mTuZ/D+SDFM0hP4EzhWyTFYWMaQ9hB7R2iC8aC54bmayA1/Nyy/bjX3ddIRG/jZJyNjA5ctlEc7qzCbMPvnnjzWoylHOp0Hoyf1ij8WYksFrszwYQ4egOG20eeTZpQTlZzjbvb3I8N6kWXvRaNHyu48EBTf/HLqs5tciLwBtlQ4BGJyZpKPF8UI8k3ovDi5IfzxplTNACLlN8bGueDkPylDyoBLpe6oj4WaIWTiTWf2CimHbDt6KZ0iVfRfHzcU7PhwqaEB+n+cMMpM4VjTlaggkpkuqQfdBMIS+LLqnvy0Jn63trUKh67SgdAq7c8kXkhQXWYgwDfOFzRk2LyCr1ImvrLFF7VEI1SKGLbr8P3owgTLRinYf4BMexNHjq9+DQN2fRv41WzR8gMsDHJaVqkBDNhrkD2iSYN127gCv4YZ+OZygFGOk/fK04g+E77TnB2Zpgvw2KHDlM3WtoJB94abLHRV8R27BERUuF8yltVzhz6/ImJzH3WXgi+3gkXFyo82cYYDy692//xWOYV+HkY1io
 vBERQydB
 P5oA+d5Cjf0+blbIZaudsHDYdYxnUjNYhlfXO9dZF4m5gwtukDTu5Iybuc2PAgeo6XhW1dPVEw4lixnlexv7IAEEoEzqoH+ClTPkFj4wluv1cIoPZlPjJiECVUFW4pS5IrnP2b269ijYHkZCUAFBdJ6bHc3YxXQGEBZKO6XDGR7d+Cpi+4OfjIDHvWt5viTYOK/ekPDu0X7c1noOCATQ8uG6cujaBt2/m6+zHE9hcqJjoT/y5cLtPGSEoLUQpoYAWmaMLm5GWFaJKyXrFsN4py45Wwd6EjNRikLaN2Vwek04ek7SYu40cHWnALs/84nZkAiQ8wc2P4XT34Y2cQgjwIYh2S8sDb+nnZG+oIimyWnxJ8hOOg6th0EJ4neRSXwKjBrKjK8WP6p8jnbzYD4pZRs2VkqfdJE2Cfg9OGXBbKUPy8Xf/8TFy29TCOcr0iSHceO/PCbf8t5U9+RFNSZ+Tjp0pPSLx5AhWzt+PhvG7HFLqALmwnUWtK+rh7hAewd/EO/6GecX4hVlGDz0XfmqoaP2BdR77MXvmuqXWLTZHuDBqQSq+1jP018TumeZuFFE8e8ITgwmM00HAOLzYhfsZDK0MQe2BhanY1YwG8bk/4Y2NATnUwuoajd+agIX+WMx+WXUxyuIOvO4hl+afKyrWL11DFvnjLAzSqFsGgEpONP5k29V/aWXwhM1yiDjzDVaI/nIkYZX2bwp5djaHPdXsLsBnDot1m0oXuW6pjVRzMqAGLw9NU71RLbX4DfOFWr9vpDn2To4p7+6z42YBfFLo8nIXvqw7M/XGtLA6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Pavel Tikhomirov <ptikhomirov@virtuozzo.com> [251118 01:46]:
> If unshare_nsproxy_namespaces() successfully creates the new_nsproxy,
> but then set_cred_ucounts() fails, on its error path there is no cleanup
> for new_nsproxy, so it is leaked. Let's fix that by freeing new_nsproxy
> if it's not NULL on this error path.

new_nsproxy may be set to an error pointer, but that case is handled
earlier in this function.  That's a pretty subtle detail.
unshare_nsproxy_namespaces() should probably set it to NULL if it's an
error.. everywhere else looks fine.

This fix looks good!

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> 
> Fixes: 905ae01c4ae2a ("Add a reference to ucounts for each cred")
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
>  kernel/fork.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 3da0f08615a95..6f7332e3e0c8c 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -3133,8 +3133,11 @@ int ksys_unshare(unsigned long unshare_flags)
>  
>  	if (new_cred) {
>  		err = set_cred_ucounts(new_cred);
> -		if (err)
> +		if (err) {
> +			if (new_nsproxy)
> +				free_nsproxy(new_nsproxy);
>  			goto bad_unshare_cleanup_cred;
> +		}
>  	}
>  
>  	if (new_fs || new_fd || do_sysvsem || new_cred || new_nsproxy) {
> -- 
> 2.51.1
> 

