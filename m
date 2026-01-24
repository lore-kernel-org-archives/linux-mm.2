Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E2EDD715DE
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 10:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863266B05AD; Sat, 24 Jan 2026 05:59:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838F16B05AE; Sat, 24 Jan 2026 05:59:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711DB6B05AF; Sat, 24 Jan 2026 05:59:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9316B05AD
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 05:59:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 006A9139FC9
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 10:59:18 +0000 (UTC)
X-FDA: 84366560838.03.734B15E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8ABFC140007
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 10:59:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FgxvEChg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pxX1YsVb;
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769252355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VX7f81QyBjum/NVUeIyMq3FxYMdh+OvZbCxF0gmR1pI=;
	b=TABWkCAe9f6TaSQh8WmfiSF1X3rr2A1a0j7e4m2lclZDb/j0Qk0hHFqryGlqdPO27NyCkf
	DK8D+Xysyp0E8ZxbzElmVasN5SR5G1jmQStzleT8oNovdUSx8rqaRMVNRP6RnEo+oOHEos
	cv3fL2M7bBO1J4K411sVNJb0zG5ln0I=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FgxvEChg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pxX1YsVb;
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769252355; a=rsa-sha256;
	cv=pass;
	b=F6giQNcQla7Lv7sLKjHLwrfLoo2e41g0AUFEx54kd85AwiGxyOBPo1lrEMvYFgTJEOOR2u
	ZT5WQxokbV8mwHUBrqQEdqMymzexaY0/+PxSmIGXKpWMI2FFRdBG12HN8SLvlaUjVgdKDt
	jLGlUjRQb+GgmPiJWEyDHVn2hxDvCAM=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60OAkusK560979;
	Sat, 24 Jan 2026 10:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VX7f81QyBjum/NVUeIyMq3FxYMdh+OvZbCxF0gmR1pI=; b=
	FgxvEChgDA3uW2ngh+q3u5jQOxvXhxnGZqoAxY2JeKQLdu3cBrmqZFHDCsIo2U/G
	w230HN3mXwxHmoaf53dyatcXA9ttY9Wdkm6hbmXA0qc/OlCZTmIZbaiN8Q3PPMAs
	3k98AtcdP84Y/qX3I3xxi0WRwV6eAux+ar0rixuYwIFxQ8Ug+zhJxxdwSqdho3R2
	zy2W4JMjYXzeDb8ApsQDqHLGu/pgqH0AxxkZs+60OdBmuyVBxgqdTDRybiRYVj8w
	P6EPpjrOGxTpydIYrQp/S+J4k0yCld0Vl/yidh5W8nmXpyJ3nebY/g0RfNnxuWa1
	rOKY/L7fQUdz/10F+yDqTw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmny06u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 10:59:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O8AHPP019814;
	Sat, 24 Jan 2026 10:59:05 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010039.outbound.protection.outlook.com [40.93.198.39])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhbkx20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 10:59:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QfgSebBi0pVukO5sordencwtVzs+vE9Veayzkg/jzL2OvV5AWustj6f3khTjMcYWYku2vRfcvA22Xl+DXpV92THGMcDMbA+I4I+tk1EcrKc7MHWbtLutBel3QutXJfavlklEwar/9QmEU37RIe8/mVB9QVk0OZ1GbS7P1/3eoGvc4XhnMIeK9fzuTp8P165LFRNVj2AXMnIivLDzgMreUyp1S9T0d1/UNNhX6GfrTZSOqpINyF8V+42PB+6WRvYVSqX6ZTU1mWTou8y/JJpV8I+whgbOE1rkVXYu9lrpemR7SOTnE4Lfw02pCTRVw8R4FbupmCiu9/zM8hHSQPnM4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VX7f81QyBjum/NVUeIyMq3FxYMdh+OvZbCxF0gmR1pI=;
 b=EYteh+5SjEqn/m7FPjQFaH2KqIx3Nprexk3y2lYmVOIYXMpi1qqIVjW6LslQOmg2go2I8LVkYiWbk7jhjbbtaC/Jpqprronfa161afymPqn42W2ebs+bp4uuUmQueYGfTppqejt5JlEJfZ+xbr7XEiUOeGcTpj2/abzF4P8Ie4I6zX+dr+pu5soW5R6M97SJR2BrFWbY2+OpioCDuFtiBjVxIOMu7pFtNKRIqXXOElDQFuGGPP46dFqNOmiit+Qp6K/ielaGl9IQtAVhkzSNAwcMyCVFfT7TEJQgWbgCKLqbtQrZC3nSoEfiFH+fhmXO8nefYqi3+mRCelgXSnVjZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VX7f81QyBjum/NVUeIyMq3FxYMdh+OvZbCxF0gmR1pI=;
 b=pxX1YsVbSJiaersAWzUgZyyLgUvq/yFgUO5ZfAR5VOye01g4vHO5/9Y706gouhMJRy9/TiK7iSCip62BwWviwqRefNg9//ld+YYJUcJxRJhd0IvB06UTpCYozB/QxHWCrL65IuMggaN4PbaoSiNBozpkETFewmGxJGWe2K8ZCm4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BLAPR10MB4916.namprd10.prod.outlook.com (2603:10b6:208:326::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Sat, 24 Jan
 2026 10:59:01 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.010; Sat, 24 Jan 2026
 10:59:00 +0000
Date: Sat, 24 Jan 2026 19:58:53 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>, Petr Tesarik <ptesarik@suse.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v4 02/22] mm/slab: fix false lockdep warning in
 __kfree_rcu_sheaf()
Message-ID: <aXSl7V7wyiqP5dPB@hyeyoo>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-2-041323d506f7@suse.cz>
 <20260123120302.TsiVMAQb@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260123120302.TsiVMAQb@linutronix.de>
X-ClientProxiedBy: SL2P216CA0118.KORP216.PROD.OUTLOOK.COM (2603:1096:101::15)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BLAPR10MB4916:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f63c679-762f-4c6c-9c84-08de5b379450
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bFo3ZVkzTm8yRjcya2NmUzMvVE80N3haM21rSEYxYkRueTVicFFGdzNlbnN1?=
 =?utf-8?B?czBqRjZ5Zjlwck5WblBudlNJWUVqeWlRSEVOa1V4M1duRHE0Z1FMdVQ1aGpn?=
 =?utf-8?B?cmRyS1RLVUJBTEFtMkRBQjBrMVo3MzcvMWxwQ3d3bVFrbFFTVzBGbU5IRHhJ?=
 =?utf-8?B?bGlMNUQwU3ZMa29lc0JuUk95Z1JLRkt0ZDI5Q0t0aDZ6MkRIV2dYc1ZxTWFV?=
 =?utf-8?B?RS9GL1phRFV3R3E3bm50dGIvTVZlK2E3K2dudzdROTY3VGcyV3FxSVVOT3RR?=
 =?utf-8?B?Y083a3FNck1UTnlQNGVETWdQMEJOWnZvekxTdmVsTE9BaXM4aVc5bVBTaHJD?=
 =?utf-8?B?dkJDMjEwdW1LWi9LWDdGZHk0d3RxWHM5cGo3b2xmRERJb0VydE96UXNSK084?=
 =?utf-8?B?b0RScW5oUFNxQ0tHYlh5VVhJTDIyUkdlRTVOTWdUZzVKSVk0eVNIbENlbDdw?=
 =?utf-8?B?T3M0MDRnYTQvajN6Zkx2bnZWY0dkbHNITFlUUVpHell0cjBhYVdlSWlCTTVL?=
 =?utf-8?B?WlUwSk12dmhqaVgwVG82M1VQMVJrTmlBbW5HRldhTlZMK3gvOTZCcTE5eFl3?=
 =?utf-8?B?WWVNMzVZQXAxSUhuNTF5ZmNXSmhUZ2s2VjFwSjlMVmVmb2lHeEVLUk5lRlVE?=
 =?utf-8?B?dkR6SW9aSy9rRHhuUmlmeC85Y0gzN3dBN01qT3RLTE93MVZYVjl0UE1BbEd3?=
 =?utf-8?B?ZmlkWkR4bDhyajBtaTNvdnVQNGQyMHFaZnhJbmFQQ21HeWZWQzFjWDVXZnpF?=
 =?utf-8?B?bTBMLzdORzhoS0h6ZzBtejVteXJKZWZyRElFVVJRK3dzNjJrZ3hjRmpQVU9D?=
 =?utf-8?B?NDVxVVFjN1RvMURyWmd4MEwxRzZScFljVVFONGViQU51RGJzcXFtZFRpbGhL?=
 =?utf-8?B?UVJ2MzF2UzhZM28xSjJqWEtWK1JBNnZ0cFBBcDJwU0hRMGE2aXZXNitxYjNI?=
 =?utf-8?B?L2hnc2xPMUVGb0sxd01YR2l2WmJreDEzS0lsUkx6WnU1aERkRUdMclFmdndV?=
 =?utf-8?B?Sk41OHFJd3pKUWlpYmZUNTlLTDRqOEs0NllrMmg5YkNZRkRsWlBYaXBOMEYv?=
 =?utf-8?B?WWZjODZMcWJVM2lXaDNOektMbzVkWm1uUXNDb1lPcHpwVzJLb3FBL1U4Mk53?=
 =?utf-8?B?UUNLSjk3R1l1ZzFCSFE1MGhHNkxsT0l6U21jdVI4bUswOGNHeHZjMVRlV2dk?=
 =?utf-8?B?a0ErZE16R3p2NXBENFcvWUdSMGdXeU91ZHI5NFN0VE55OWNNSlZFSmY2L3Mw?=
 =?utf-8?B?TVhRS3RvZUpMUnNqdXBpc0pXM3JRTzk2cUtkM0JlcnBoaXlEREUwbzFLdmdl?=
 =?utf-8?B?OGxLNE5jWjJUMUFwdmJGQzdwRGErc3RCbHV3dENZUkg5b0RXU2dYY0pWeE1y?=
 =?utf-8?B?SU9vOGpGZ1RTODhNdmlNOFBKVDczWkxmZHJPK1c5SnZEdGR0c2VscmdwU2FU?=
 =?utf-8?B?R3F2SzhHMWVnTWxHQW4rb2JZOGM2OVJiVGoybkplVEp4MDhYNDZ0UlhJYlIy?=
 =?utf-8?B?bkpZby9rTVNSVEhrRTdEb0dTRXFscWNnTi9QSGpVRFRjc05WMmdZYW01bmxF?=
 =?utf-8?B?MlFOR09JR1NzNlViQWoxTXJrUzV0a1NvVXd3Z3RwcVdEQ3NsQk9XRy9MWVNy?=
 =?utf-8?B?aTJxODFGSXRyMWpVWDBkSUdXTEIrMlFuTFBtUHQyMmpNQlR3NXkzWHJlRTFs?=
 =?utf-8?B?eVBEYUQrMm95c2pXV2E3RDRicGE5OGJMSC95REwwRzYxZm81SlNnRldUWXVB?=
 =?utf-8?B?T2twODh1bzZzQkxKREgzL2ZoVGZDdVUvTk1RdGZheHNVdk9ydk5ObGVhV1U3?=
 =?utf-8?B?ZnVPaXQ1MnFxRk1HQzh2TjV6ZDd5MkxFV3BIZldONEFrSGJndHBzWFJKdXQ5?=
 =?utf-8?B?UTJKS05RN2JTYXRwQUpZUllKSlY3WWFINHlwNGFtZU9JanE2UU9paVVoV1Vq?=
 =?utf-8?B?ZGdGSjJGN3lOYzRmZC96U0NIcEM3cjY1dmswMmFMUHFBbzZsSk1xWHphVG54?=
 =?utf-8?B?ZmxDSk92T3YrTi8yWDdJbFk0cjBic1Z1bEt5bUh5aEg4M2NWcjg0WjVrSjVC?=
 =?utf-8?B?eCtrQXZia081NmdsQnhLK3htQ2VxMTNIZG5tdFpUTEhCdVVIUW5zOHlLbmVC?=
 =?utf-8?Q?BZgo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2wwY09wd05EaWljRjJrZHpmd2p0bWJvS0tBUDdSVGVPWm9JSys0Q1VldXpK?=
 =?utf-8?B?Mnk3TmJwV2I4RGhmbVdHVkNYNGVLODFpYzMyMUxzODVvbnkyZktreVFPYWlV?=
 =?utf-8?B?T3hnOWhPZmlOaTRPMnUvdWFSYUYzNFJiL0dmczdvazJmZ2tSdkN4djV6S2oz?=
 =?utf-8?B?M0hEKzFndVRiUk9Ea0NYd0FDRFFaZVFBNTkrVGdEcUNSUWg5M0RnZUQ2aDBE?=
 =?utf-8?B?TVdtWXc3WU41MGQ0N3kvMWd0UG1pZUZkaXkwWVl1N3dpdzBZeEdzRVlLWUZZ?=
 =?utf-8?B?TkxmcTZuYUJwVkIxb1pFSk5aSFJ6QkRMMFIrRnV4ZHlranBzS2FkZVJ2UGtv?=
 =?utf-8?B?Y3ZRRnVtNkJtZU5wREdDeUZxWitTMzdlV1Z5S3U3UjVadEwyb0Q0M1IyTVJU?=
 =?utf-8?B?c2tTdDhGTkpQQzZLWmJVT1NVUUdwdWUwNHdLUnAxcS9UUXFGMlNoSm1RS1d1?=
 =?utf-8?B?dmNPWDh6dUFZenRVQ0ZtdmcveHlQaktNOFRKQ3Z5Q1lOQURHbDhJN245dXZo?=
 =?utf-8?B?a2NxWUNYa2ZhaCtEQlBNRWgvWit1QnlSYWJMTEdNem1LcU03Umt2Qlh3NEdQ?=
 =?utf-8?B?ZEQ2bUFkR21yL1NkZGc4MmJ1VGlTYjc3cXhJZC94bUNBZXcyc3c3TStEVk0v?=
 =?utf-8?B?dFdnNm5kSG55Wnd5UlhoZ0JaK2w4UEhsRHpGTVB4TGY2bFBpbGhCMC9iUVE1?=
 =?utf-8?B?aTMrRHdRaDhrQzdMSU5VQXRpWkxmRGFYRUt2bHRIUC81cWsvZDI3ZG42RUtB?=
 =?utf-8?B?eEpORGJIZlloOUR2RnQvQXpxblFDYVlPSXNiRXJYVGRPREkzNTlvT3FMbHlq?=
 =?utf-8?B?Vk1TT1VXeFIwZElvR0dtejFtakNnSUVBcjNZc1lqQlF4ZVJwQzAwTmYxV2Zl?=
 =?utf-8?B?SDVLaWRQeVpjaS9TeTRCcUZNcFM3dmNmaWhwOW5wNUFuRVZPZStXbXBEZS9Q?=
 =?utf-8?B?U2I4ZlRYZmIveFNXa0JEWW1ieUFvVnJyZjhldGt3cnhlaUpBTVpPdjVzNlBH?=
 =?utf-8?B?UWQvdEZSOWl5d1pwRjdrV2lwaS96dzJ0TTlhaWY0Sy9zN3FkU2tZQzB0cnoy?=
 =?utf-8?B?ZklFV2I1RzdkNTIyYzF3RGY2dUxodjByaUZQMWpqV1dPTTFMZEFqQ2dyRGQy?=
 =?utf-8?B?djYwdERKYkZMYlp4R3d2WU9nVVZtMkZnNk9ucEpOUjdQaTRSTlMzVkxOOEZ2?=
 =?utf-8?B?K2w2UnZUb3VmT1JkK3lrazJYMWZxQThHRVpHUDdkWDdsZW13bG5uV2pRcnZ4?=
 =?utf-8?B?bWhPcWlNZTUrdkZ5ZWNOOXpkV2EycW9HQnlkZ3NuM1VRdURXNW9MTmxPVVNQ?=
 =?utf-8?B?WER6L3RUQm0xbjZoTTJpTEtVc0JQMkpPNVZ6OG9NcFUxZDJ1V2pSMnFkMGFn?=
 =?utf-8?B?VHF1UjB5YlNma1JjZExydGFQWThSS3drN1hIV2ZJNG9jT0lrVllTQ2tjSGtX?=
 =?utf-8?B?d3doR0JLak92VlNGVlkxekh1NkhmcEhrb2prQ2xiVGZOU1NQZFdFTWVUWHhp?=
 =?utf-8?B?T3B0MzNndmttb3RQMXJoV2IrSFpraDk1YUViRGF0RlI2YkxnazNud0dQM1Fw?=
 =?utf-8?B?cFd1UGcrU2pnakV2Y2diNHJPZlVwbzllM3JaN09EUVZ0eGUwMUlaMzBTVXRN?=
 =?utf-8?B?NEhZbmJUeFBwd1Y3YzlMbHRzbWRza1lMTzhsV1FaMnEzRzF6VDdrMWIvV0hZ?=
 =?utf-8?B?TFA2OFFFaVh3QlNpcURUTStRQWxYWDU5bHlxckZnMEtEdG9UWVBzeEhoSng1?=
 =?utf-8?B?R0xWWDZNYkZJd0xweG93UUQyQnpDekxwV01XRzdmT0JHaVJUcjd2K3c1aEJp?=
 =?utf-8?B?YlJuaVdxQjJJMThPVWpkdUlGNFdOb3hpa0lNTUhQOEdoUDM4SFpGdU1UV1VB?=
 =?utf-8?B?c3lILzA5TEFZaHRlZ3k3bHBLZGs3SVRSTU5iempSeldrVmw4NCsya0E5NEFj?=
 =?utf-8?B?cDROU3FTcHVPTmJHaFlGMHF1NXdsOHU2UzdHbWttYTkrY3FGRlNxTmo2ZFJW?=
 =?utf-8?B?aFUwZndKZWlvZTRwTG16Y3U4NWFabnF2cDZnOXhMU2x5d3ZDQUdIeTVPc2xv?=
 =?utf-8?B?NXFQSklWMWVoeGtVdndEdzJkS0w5eXVQeWc5OHdXbzkrRDljWHRHL1R5T1NL?=
 =?utf-8?B?YStaWnFyanEzQnN4Q1lEeFNCbGZiSjZwS3JYVzk1Y1B2dldBY0plVm5PRTZR?=
 =?utf-8?B?dnh1NXQ5cyt1TEtHNlAzTm9hR1hhSlpBMWN2SkhUSHNra2pzSDhWbjJHaXl4?=
 =?utf-8?B?cGNZbEJFa2pSb0h1bjNBS0hERkZxYWIwVkczT2p0YndpU3JHZThlOGMxMnhZ?=
 =?utf-8?B?Q1hNeDhodzM1QlFWRnptNE4xemR3MlJPRXdWMUQ1RmJWYzBNblk0Zz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u9MscleD1DGi6TYRgEDQC5suZVcxpeMENjqmzQTDTtQLGJwKLoqT2DODrL5ojCdyVb0GTk2+XqrQalRwIld+HdEf/l/ZE90mn9tp71TGCykgqUknZq9qCcjz29GNwZUy2vNWp97SkyhUQnLziJpNLTgl6LJuUvE3QGPzMF+qLzHu3JHRQdQSp9F6I2GBqXxKhCUBBPrOw4euLsCQT6uKr1gglpTe908kXBplfCYK0pUoC1/l6iLJVsHdfLmrAbh1iy9BUgqO7CCLjx8uHYhzomQYEiPSH5L71wnzcIaYUhvMZ1gv0RD4q7eWoW7xTEK6N0yIg6zTfbjEYxRWL1OcVe8Rl6JCCz8aTkG0mSn/pQ7C5yivANptkFCYT7p9/CylgavA/cUpHpc2AX7n76RWHeTaNciBQ3KakxwnkZFNAAYn7i+drTpx1roBuEalIJaLf5bDrtrNz2QADMZiF+ld3RfiXedsgJEQkZPSNutx9DxYc8SlVz1d/03XMvZhcvMXoYX9aArL9vD6L6karQ3xQ5mjcFlHG4AWA96qvYdLsKjsFiFBmw6zwJx99HkegMRTau86WOBEZ942/TDwpCejzKflhDARsDmt0xA3q2j5jAM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f63c679-762f-4c6c-9c84-08de5b379450
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 10:59:00.5872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UIkcPCy4b1HdZSDF9RF5vOATGrl1RRBydiXll4Lf3iSKWPRX2yidzQolH8vwI1+ttL3F1PEX/RWPTDLNHH139Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4916
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240087
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDA4NyBTYWx0ZWRfX0Pyu0ahOv250
 oScvGS/nY+FKJa4bCDIp+dwwSMcWFKzBOP8PSxZ6+FAutdZ/UeO+sLHEcBGU8q5MyAlnx5tT8I4
 5EmZIxX1b88T/APPIkuR7RwefN4767/XI3mz2PpqgU/7Oa49uUK3ufyFBOHyw8oSRV4LlYJEuf2
 +NvownC0pLAjTrT6UTt+cdUyKF1WDpKLRdMI8DRNAWyfkey+/neq9Dpi/knwo+OBqYF9wrq4ApX
 sd7jg1D/wHRc607XEckRIog+6vG3ld1SMu5MhCbz9Sa50ev5x/Z0uNTbDCOQMX44k7CoQFX17ai
 rrItTJ2B9aStkBpmlrUtOxijHBc8uPdLz+/AabFwh+me7ZKK6d687G3iSV0WWr4/X5iz+rqTDbL
 RFXxAz6JTYMuPCoACJ5hPksYmA5fq1/+oApg5+4/vdinyWOfqsBs+DmV6r5tUqFp0ozTRJ4av7K
 5NyVlyIhUn4EFkyvaTNJB0qN6HnvznlA22rw+tQM=
X-Proofpoint-GUID: 66La2Wgd1IDhRhVGVC5DvHVmP01-JzoH
X-Authority-Analysis: v=2.4 cv=cZrfb3DM c=1 sm=1 tr=0 ts=6974a5fa b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=NvNhq0AuJz3OI-n_XeAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12103
X-Proofpoint-ORIG-GUID: 66La2Wgd1IDhRhVGVC5DvHVmP01-JzoH
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8ABFC140007
X-Stat-Signature: rwomepn15y8onysk6s3d47ad876gk9ti
X-Rspam-User: 
X-HE-Tag: 1769252355-297664
X-HE-Meta: U2FsdGVkX1/BFAfUCoH+LUaq4w0LeGGJHKKa2ZBz/zebhwHDSAtHag5MgdlfwsDUl2YAf6rCX5VdFeWKO1sXCvt0xlDEcmPw9hxbXJF4fu6asO9u7Hevw7fHpddq+cxLi9daL5MC3okSLLVFFNwlwByhoyGr01lw6PdD5/lthXwE/i/hfDaWr2rx8BtBC2enDgG6HLYSrw0isdCKc0Q6aoBjFFYfashwLD//RfGRszePp1l79HqFFcQrJQObIBD5mXppKA5ovuP6JKaPKxxfrZqFzuOAC8J4SZ2sOC6j7hcev6ze4jp4y4unay5XAE6sojdWhLRWPwjESBGC+jdrqqOpm+7A+Od5YmOjrJbeZCyVRD3pJ6J0khs7EaqSlHsFrsoeM6fNsORT6iEPU6RsbjzkAbsA6TX7U1MWBXJ12xvCltZH3mrs5p3v1GmjImFwC60K/pSV45ifsxC490HNwNLJ3c53oU9ZA0tcjGI6o58/DsVs5i2j6LlAld6rrd7o49yVAe3Bhwj0qqoSD044nndopiH7FLDotWPNJOL1ZCdGT1ab/xN3E3qqAvgoQ9wIkGTZehh5DtxK2hIAF03uMNLEGd3kEt89z/h4n2I3Aaz+NIzHfV22gub7lvlpbMouDlRBKhLd1FoP2t9gJF5E7vGMgB2Rlc03F/ANLJRXn6UfZyCDe4hMX8HwBbe0pkI3GgMdCftX4fBgiDecLk8RmY9p3I9YMBcbItIfzpGycD3AmOT3MF9ZpK6/+a7FqUgeaaQU7bRvkz7W5bg0mG+/jq+u2Ubn9ba9ccs/1txJkrizkVFGUujVLNMB0TyVGqOnwqMCB4YLvt4i25bKChIXhTV3Q3jL5RFSCD7OgfHQzxfPnkRXu/CnUJfm/V8K1gq916Em4aSsO6OaOBC8+pS34fU17+xDI2AB/qmA2AGpnRIF1ie8Smy5pijrL7oRSXOnChErYQJP0njV2cQoBk4
 jaOuP7kB
 DDq0Rm76vQHL4ArGBjF3JAuDUH2XpMzIaidtnLfio3vjs4dkVdm4ieDJ0G2aEqP/XbPxHbuoJy1Od8BdsP1EKiAudSjE2ZL29Nw4WHPDFRuHbWJ3hsEyEQPD/sEaHxjagLrrnj/5/WUF0qIibDS9Qemhrd9smdQiDTc8augk2W/rkz71nZniY1mRMU4X+JnmeDQz1+GcZpgzfy2kbeRl2r+mPsG9lSdM+V7VwpW051TCEFsr/kqBVxLPisyAKKTZwzWDPmjECyJPU8usUaLCk5p+7CtPWzoRQaDeLLMR9R1mdV2X1y7kuC1dXYozCln95GCLBXeRxxKh34ZkLHNOUQZpBNLHoHQpHaB3YZES548yDaZdGhQ+y3x59IT3SBhh8dVzVw0gyA2RPMUiGfEmxhqzQ7pfFACZDTcYfAzSgm/yfmg3k3mPFP4gMU2abmPOqhG0Fqmkuw74F6nnXqSKVzJKuEDSpoW61olH6+cxyOfNUWoomzB2RLswD4xhUV+/E5M419FyMsxc5fYuhyvn4o6sjxO3auMpauE9tN9sSTpAp6GdZvjpuZffq8TuSSkTQpkvH1S2fF37iuPlResE3RMigXesEtDo4FnuXwhF5Z0J7SaXqq52+UYQqoToihKByP1XPuT888xbM5Bi8KFVgmE5P5uaN89GhbX4EyAD+3mSyrLA6dKhQtPnF20qqRNLaw782HMBPUZetWrVqPRwM+BkcVoUh+hnT+0NCwoLZPfHAYxI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 01:03:02PM +0100, Sebastian Andrzej Siewior wrote:
> On 2026-01-23 07:52:40 [+0100], Vlastimil Babka wrote:
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -6268,11 +6268,26 @@ static void rcu_free_sheaf(struct rcu_head *head)
> …
> > +static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
> > +
> >  bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
> >  {
> >  	struct slub_percpu_sheaves *pcs;
> >  	struct slab_sheaf *rcu_sheaf;
> 
> Would it work to have here something like
> 	BUG_ON(IS_ENABLED(CONFIG_PREEMPT_RT));
> 
> or WARN_ON+return?

I think adding WARN_ON_ONCE() + return would be good enough.
Could you please adjust it, Vlastimil?

> The way the code is now it relies on the check in
> kvfree_call_rcu() and tells lockdep to be quiet. And since it gets
> optimized away…

Yeah, it makes sense to add a warning to avoid future mistake.

> > +	lock_map_acquire_try(&kfree_rcu_sheaf_map);
> > +
> 
> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Thanks a lot!

-- 
Cheers,
Harry / Hyeonggon

