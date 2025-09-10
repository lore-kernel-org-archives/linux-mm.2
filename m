Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30E91CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A638E0008; Wed, 10 Sep 2025 07:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411C48E0002; Wed, 10 Sep 2025 07:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9E78E0008; Wed, 10 Sep 2025 07:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 153658E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:21:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B520ABBAB8
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:21:41 +0000 (UTC)
X-FDA: 83873100402.20.DC98006
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3684E14000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:21:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rAClAZW3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dzCQqfZc;
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757503298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+ScrVNXyz+uvfK6MLckqfaMmlZx7e9qB8zDPTM6XiI=;
	b=iHauMSYR6EQE/o0dEAJJrInt+b2RxQmWuBlsOH5E32tHx2UcoBIwJF1fHXtaJo6t92Hg1d
	hC7F11MIFLcrfl8M0kyPbHFDL/tSohFK0dMdCpq6RvHow9KKbCozs3prGdpzQ0SErfFmez
	/Tezi8aZPaedCLRkkwo9YoyBsN+E550=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757503298; a=rsa-sha256;
	cv=pass;
	b=GgZzivwE1kgZqR4etOzV6ODbXpdDqMd5mSy391r4xp1kJpT94TlQ4qj5HblonXWjmmlJVr
	xLGcRh3oleI2NB+0K9B6hy7cHj6ak0xpDOqRIJAe0WGPUqignHqVS++LdoYWXXGeqwlqIt
	K4LwRP+N/6zwsVMBVnPxvoEkDky3ULI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rAClAZW3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dzCQqfZc;
	spf=pass (imf09.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58A9NpvW009291;
	Wed, 10 Sep 2025 11:21:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=f+ScrVNXyz+uvfK6ML
	ckqfaMmlZx7e9qB8zDPTM6XiI=; b=rAClAZW3BDyXE3l2rGyczSA2dY9GmY7elF
	T7Pv/bAXa+XzystCj+n7U0Hxb4uFEDopgIWJJgjzb2j1gFVXP5+txpnmnqRZjFe+
	88ZSO0CUoaVvRYbXitmThdwq6nq/esf+JOvObNEDo0cB8mwduf5ZmHAApblA90sC
	+X+j5+3aV35Jg7wrCj5Va1s4xoe4O8uait9KsmJO/VXQKAOh+VL0xb/LkTrbUXwf
	D4+h9RKRuYnsd4Kez+S7BoxZCqoWrcx0ULSikTzyfT9t1C3W/hMaXiEch0gMnGfO
	a9vgcqJMAIaoJdR7vA+E3vdbIhCG7pf3zoKRpd+O1Ei3T7yxVIyQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921m2uxk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 11:21:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58AAE4b0002972;
	Wed, 10 Sep 2025 11:21:32 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012027.outbound.protection.outlook.com [40.93.195.27])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdhd8yt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 11:21:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u+VyJyOJjm37wHXGkyctS1C25vdF2zuVJgLfoathmJSsaJQRNQrXmknMYoaK9a2tvrRycWCtxK4DCMZxdBkt6mEeqKgkLKdMvD4O/KQwEtjSLa/ZfYrNWP03necqPIcgLh5ISq1Wc3gO+wFgqkJXSz31axIdZnONACYhed+YuXmEE+AVwu23oMMhiw8Q5KO+btQbG+Tv8t0jmEvPfl2iteWgAxf+YNwUr2U83isO4iUDZMkYZueKEIQtUk6NkQOretcLQL6OQGomPVaIsC+1VRdac/wFe2yUNUZsO1F8LRk0lUUEyfJB/ymZuCtZ3lrakRAsgT+/JiQOHyZttlJjrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+ScrVNXyz+uvfK6MLckqfaMmlZx7e9qB8zDPTM6XiI=;
 b=dcBVFFENgAqKIR5szekjj8jZrSQlFfkFlDXHYRx3Cv/rcZYNl/J7WLESNwTd5ufS94eYsv0WPwiS3Z6qGCEUImmvmwWZCIuuosp+K8tEvzRpUPcSBcuVQ6c/bURqe4z8hve7fNBpDTlQgUsAUCkBwKustUje32gLfSt4FBNL7I1ZlpNp9PYoao3rMEgouztHuAKlKAEeB2AnkFQ2sXTFyXHy0V5aZu/VvvpoXOjiuJ/OVyVdr2uPkKIIOU4eru5qp5AtEWdmxx1IHzb3QDqvo7QrUCQgJWz6T0V0+cnyDCm2qs0HYvOAcBYQii2IKtxLuFRkkvU2t9YyuoA+lKjM1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+ScrVNXyz+uvfK6MLckqfaMmlZx7e9qB8zDPTM6XiI=;
 b=dzCQqfZc4zit13q3c/R749baQn2XqZDpp6Shy1zOWpdhNLGOJbqlzBMqgTpkAkysdbLUXytXZ5PufPlXoF9YcaAvSPLBnGt27QPCrHuIeeqi3dnHKAdTvWuPhiUIbDrEq4CQ2nGQxKrrWLfghued2pAA4C72PbmEzQvD/qOyzuE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW4PR10MB6486.namprd10.prod.outlook.com (2603:10b6:303:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 11:21:29 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 11:21:29 +0000
Date: Wed, 10 Sep 2025 20:21:18 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH 03/22] slab: Remove dead code in check_slab()
Message-ID: <aMFfLqkXcZTNv_p5@hyeyoo>
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-4-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829154728.3397606-4-willy@infradead.org>
X-ClientProxiedBy: SE2P216CA0207.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c3::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW4PR10MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ae10cfd-c41e-4efd-28f0-08ddf05c2fd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MYVMDCOfGGpC1NvQvWBTe0EKpNuk6o79KM6hiySR2mPTfGWKD2bt63Tm/Ryw?=
 =?us-ascii?Q?Zt6AjtIuMuT48ixNQJNfZXV4Z5uNbZa0vgrhNe+V+9hHQWf3rgw/RJ4ScwVs?=
 =?us-ascii?Q?39zCLuTYeHfvsWw9DsUq4WAPlc80DRurkvv4/ROvvF4mvMwYt8lD2N7nv5WE?=
 =?us-ascii?Q?BDfEDhFyVo1nOTwvPGATXEtehl7dUQtYFVJFZoDLfpMyPwkCSHGtXvtaZ/lj?=
 =?us-ascii?Q?PN3gjBna+Bny6qQx+kurvEjeYE/yOTrOK85tCPVazfPnzoMUG91jUzfeHa0l?=
 =?us-ascii?Q?4tIpMIp1Q9DqBFYpKjSFLAyyPSzOEleH30ZZykBe5DAeIR62AFKi8RaH+TBv?=
 =?us-ascii?Q?cNC1h9DQ01cKlowCFs8XkUNGemAjdW5yUWB0B0YBtZnYGid2faLJKMnVi17X?=
 =?us-ascii?Q?ZJAheZ/FnmRrEcc01BN1kK5CznjbzmAnT9NybBNI1fwxMhvzfkvY3snn4ETq?=
 =?us-ascii?Q?zOX5+tCEBhLDtEtnrdE5NosaYoODMJT/NEbXSByFidM1iSPRKp+kRxxW5TaV?=
 =?us-ascii?Q?6TcUL3phRYAQOXT67Sbvg/ApAdAPOT8gDJ5pOHJDYex8eQntMogF/0gwoEWY?=
 =?us-ascii?Q?R5Fee19ps1w/YYLSYBQXd9QyAOvsWaA43S3HwqdVHebpT2cdRPK2t/8EEoKg?=
 =?us-ascii?Q?86MJ0BB9zqXwl0ePJXFvsMIQDwNFXWcGgCIUaVyDGQWUjaF7Oc17BG0tZg9r?=
 =?us-ascii?Q?FiMVE7TqMj6hr2L2GQQf1jHOwr/eA2ldIxKdXAWrTve/5mfbVcIdo9QAIMA8?=
 =?us-ascii?Q?tlMp0+usnIjuMiSDx5WXPbDM05io/WaBYZea87iq464jytkM1zXqWTmrZDCS?=
 =?us-ascii?Q?/UDULmMQwI1Knh9q1Xv/1LhoVND43Wfpy0x2/2wFzB7n6YccrxQ0FXuCW83B?=
 =?us-ascii?Q?0x7V9fPGh/v4WYC0ju1WAIU/k1OtABkGbpsBe4R+8IAPkzSVxztCUSSXSJ/L?=
 =?us-ascii?Q?943MYoUlohFdPz1t9Z77Zp3J3Q6e0/R2K3K4/ynvxB5LX1ZpVfJdIYmGk6W+?=
 =?us-ascii?Q?sI62tMOyK2ot02pJJC301FAgg9QvJreubuIYDjWyx63UCtZu8FYlnjBbbQIJ?=
 =?us-ascii?Q?phbm9vgHV/G9I3pSDQ5DUdQIF5mvaeiNENZEOAAxtmKDxjowNDdmyiF8BolP?=
 =?us-ascii?Q?YwwLsQaxrv5wqnnCM4dYDxtxn9eB1aBzBkoOSvJxf2LcgfFErebISvqNbVgO?=
 =?us-ascii?Q?ZjTXeVhzRH0ZKRVgRQTMdNfhrHfFDAv/SC6YRcCgPRcgVCP9+fzWO3XgmEZk?=
 =?us-ascii?Q?jghYePacy6Zes+M3f0v3grI9VqgvB+J2x1l2l8cFSUE0/SDGfM9jxsAZvwoO?=
 =?us-ascii?Q?iDPV4gJm8SwGMR3ywQ///RmM5wwzGbybnTWa2qofUCzotOq4DXs6otSQerdV?=
 =?us-ascii?Q?/9njWvsQ1oQ0fvclN61BtwekYpM6HhYghZlCcKBLTcFlWjbMhzj+mavry65I?=
 =?us-ascii?Q?5l8N+vsP+HE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1aK2roZMQCWLaQNkHL8CWy+5Yowc5JVbFU0BbYtK4FylIQDhbOfySricNDLK?=
 =?us-ascii?Q?fE1XbLxNrLi7BLGGGBThGKgYAnU5Zk5LJxIQHFGgjyyeB6Z4rPJN4rhaQWze?=
 =?us-ascii?Q?ALdPMB6ZLgLQLtUfc6yK5rejjQe/biSpDT7JcDe0K3ZcqO2/fqMXF9UvPsaV?=
 =?us-ascii?Q?62FP5sQiythKNK3vFJ93n8xWyJ7rfziZZSagY419Qkvrnp7gKsAlXwWUWZMa?=
 =?us-ascii?Q?GZOWCErZKgFMvw5DB9qJnQ4xiVAg+P7hSAhR2QuuvNxW4oHUxeDgpP4w++Lp?=
 =?us-ascii?Q?EAJEQX/lLI9n5dmeGX7IdvKlSSKE3yeMoFE7IPBTIIvXItAkCqlKA0LSzxti?=
 =?us-ascii?Q?H+xf1QtDUVaYlI4c8bhSJ3X/Ywn86LJIp4dfEfyrwazG0PUOofeLgf3o5stv?=
 =?us-ascii?Q?O4GNcBA4ngwuaXKAzAl9G5QE/kB6DEM+EBAOiuebnePavLMeBNLYvTLtJIu7?=
 =?us-ascii?Q?qcxYdvO/AVMQNp5cT5SqN55mvl6chGls3HlxQYN7SOLqxFg/L7sEKpeK9etm?=
 =?us-ascii?Q?000wl8SBBTDdLilhlG9CABLKrIcXgmd4PnFvjgOELbMZfkRo4D7h4YNh38rD?=
 =?us-ascii?Q?7JBNlUfu7vsFbfYlWq2hiELJpmGnvnY8uWuFbWHcxJ7Qabae7qc297ltSe2z?=
 =?us-ascii?Q?Ra2r0sFm9zkuMqOw+x7X145eJBgu88geEHLcFFX3ZdriPYCkPZCas6jjQ6Gu?=
 =?us-ascii?Q?86Aw1IsLrw7MOQC4W9aNC7slHPgcSel7aqKimILL5KQaywwHsQkIv3Y/j/cv?=
 =?us-ascii?Q?Z0jjRVqIrHzfIq7Cbyx2R3xF+zTVeS1r5TUzZSyjiKZdpZjqBo4fPDA1YjZ2?=
 =?us-ascii?Q?8Ygd7kjaVIjXwLC5V8JpvKZxcnQ0PFK5hSynmaZJYlRmJnTj9D3zpaQZ4oZY?=
 =?us-ascii?Q?amYiY9HDDnDv9oAgALFvYiwB/jjNy5sK8+lkae0p8qMstHx7LjuXr2/9/QAf?=
 =?us-ascii?Q?XI8hPkucvUOSitWimSuaTZB80TY7FhpuDQjktAEFQuPNtRWODno1oVwNYrbL?=
 =?us-ascii?Q?G0rr62juf5wfbdgJBKPNs0EWgyh3GvGNGnOvJI126NbK0WFYWl6PzssRY8WS?=
 =?us-ascii?Q?gZxEcXkK+VdTelubghO6W3MlDLSzIlVn/daUgGMH77gof0xY4kwh7YJi2bWV?=
 =?us-ascii?Q?nQnk/o4Fc27S/Ol0iul2iiS9Sj1uhk/0W8PwoCHY6byIEpSgRGcgam8k45bz?=
 =?us-ascii?Q?zYXpmZpBtgRXqE4Nwo8nv/LRShI8ciVZBVz3xDFblOoz+P2y4A/BRd87WiDk?=
 =?us-ascii?Q?5k8KCRVQ3zGvLnV45M7Fcgn5mI+5l3FsjUx01qUH4JezHmTqAstVAfCj1IqZ?=
 =?us-ascii?Q?7UKUmI45dPC12Brco2oQDDDtqttDwVUVWhuOT20c858MnnKXhmJZ8WaDLIGs?=
 =?us-ascii?Q?Zdj9eP0ap91JlXMNVNF5UlY5E+6yM+mCtbd13DoZcmFRChMAtCtSq6TAbYOK?=
 =?us-ascii?Q?vlTmYEVNBeQEDFP7RuRogMjGDXtWyDNjFwpJoVFLjvpUm0tW7jvzgEp0L6iD?=
 =?us-ascii?Q?vqPqigh35SAwUC2EPc6j+99bYVSuXzSxKChFwGndDA9yyHZ7BV4jAlaRcEIF?=
 =?us-ascii?Q?cbOb95LKpc2+EwkXNBHsEutw36e0RgqvRdOBd/Yz?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2J6HFPElnMA+FO/NJ8pzGXg1qOxuy5QeqI96wLOM03mjdatwpyyj7aesup4Iz/fNmeQFhA2b4NelRepjM1GxY1lgIlGY7eA2dbx2ZDKGgWUrV/mTeiS6ZDAnvh/TIIMdXaN8crk+gGzpltXvTYSdYZdd0ncGTs3QkKIP4R9C6R3mHwI2u3HQl27VhgIo9GN7U1pYfTs3XmtCPSZayBhUkt+/u3P5fbaUJ0wnqG025udHZCNa+FZMRGWmbq58Xb4X80jGZP7aZL+6q3ebcQTnkb28AQUGRuumtCVzDYqy6XckMH9kV0/KQGjwOUTrEKfLVuwTchNDVcC6VWpjrJX17Db/vWyGmjSXcBoRpMJ6qfB/vms9t9zxhmfOyhpJQ0kwxIJsQiN+AIHbr1zwn+zMaFqQd9uLRuIJ3gzaKYqTVXXHfTWD21it/CXGvvcMvxlU/qTxxElDRzG8F/i+2nDqGf3u30nhdjsQtqZZG/4WucIfNIbqq4RV4pBcnjoPG/qEowA1LJzv6814MJLwtUqXxpX5WZrUlg/3Chzu4SzHvA/s0AAmNog3MUu/4w393HzrDOpDwrQlFgNa92HA3j19PIo5FwyUIT23kiUReZ64Dgg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ae10cfd-c41e-4efd-28f0-08ddf05c2fd3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 11:21:29.0515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 009gP7OCXwla5WKykwcBNY5ge68or2117neJiQ6+RgXa4w0xMd82YQEww9jU5u6hJlE957fqvU8Cgg2PUa4CRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6486
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_01,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100103
X-Proofpoint-GUID: viiaF0u4XjLa30bVNt2PYlXihpL_SZV_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MSBTYWx0ZWRfX8vCpR+ViLOly
 6j+kiYmXRCIGwLGh2csP6yGoUH6CkMfM0XP1pOCxO/eJZWJuKgR45vsprhXcwrZPpZNmH4c3skQ
 0t2qlobs+Ca3feTo5PS/nUPOP/AK6FsV1Lb0ugOgzdZCb3Ifgs4nT7VA57FJo8a/woBAgubOM9x
 BG3Z8gA/2ghHNGnWNb8Zee7MnxEr/3mMtAgwAXspprgiFANv6obWg7NhM9p0G6mS1oxmqb4EtzD
 xOJB0CAC26U+U5cwunbeFCUwNrAi5ol9htvjps12e0FI0k9oms0AD051gpavmgk8Xs258FyhlaW
 7/XOH+wG43dr7T3DSNECFcaQ2p/23hydTV5RWMbYCDgWO5VZYI52fTOjc5GAtC3ggf0HSUF6L9Z
 wH3RWZnrriEdJKqnjWfsa3lx62EoUQ==
X-Authority-Analysis: v=2.4 cv=Dp5W+H/+ c=1 sm=1 tr=0 ts=68c15f3c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8
 a=I9KUxH79OwePN8KHRLIA:9 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf
 awl=host:12084
X-Proofpoint-ORIG-GUID: viiaF0u4XjLa30bVNt2PYlXihpL_SZV_
X-Rspamd-Queue-Id: 3684E14000A
X-Stat-Signature: pju9ukmaes1fwfy8fmdw16h1xcsw8zsf
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757503298-36488
X-HE-Meta: U2FsdGVkX1+vEZFyhEK+2SqUtgyrgn8DFToSGHvblfHWDhR+7a2fG+w4EjAPNGcVXC6ztg0FXcFnkKjvq2j+5FWFCOgyj2KEpPFTLXYTw9xi0BNHNQwIbc3xLDnxu61bZ0qRIVMUMaPG+LuBuo9bxCh881yavzrXqrRdRIgRbMK7Ps8DiK+CfE1zgkQ3cEwCaPZhtcx87AfzCvIm/WPoFMKkNw2JhzrA25pVvXPCzpqMuGUno/5ZsWkjs+t91UWAiL3jrX/av5/u0KOIzqAh14p63AiO46sZIM1LQGUS9NXxjHJzEDiw4XATrfsVLqkPxbnBLxR/lior+3OiMZHZaM/eNg2zI8hLuVTa1tDmsfEG2FRapiMu+w0mZbqb4zqkQ9FvIhT2JF8Hv9gGdlHa6z1i8sr24hZqiZDSQoj8P+xDJ2yOqwbxHWmVX3RuZKizAUMZlFuGVx6fvY3lqJlPcy+g5d7AawiXcc2sIYkTLIcVXL3xxV+xxi5pMoHxekxw/pBeb7aKf0Wusg5PGjnThjWL/1QUSTJHOAZr+02QxWJTRbEYxGPw1KMQ2c8tW+lEx94q/gLg+hNXsLH5NvVvAf/e9lK39obRLgpShEBlDUnrfgMIMIyD2YaxwE6f/Iw8R+awDajjPvVII2k9k6PxAXS5AFpGILuVDKVKPrcErtbGDaL0e5c4yF4V8oLEA3Mxlj85o8rKFZqc+0Yd/Z4ZuEr8vaAF9J23SlHUiTNGjR2XN6GFqkbciF2IKuiAC1SEbTDimQe7mPTgwgbJgwjrngu6SMdPyIyLoV1qAZCQYZYi472uVVjxzxhbwKEndcIa4ly7aTh0Xg4+OWGw62wh4e3hbCSJvNLaCMgDay9wvjLl1EFI8/aBIi8K9vMpej4Jb44lgUFTqgIFzVoOAQSTFvBVJuDugeLAO9QAnC2FOdEqcc2pMOMHky8tLhMq6ikrpQ53ZNLjDVJWs8JIPja
 2KE4XRZn
 LchdgzWwxi/87Tgfy83Iag/PPgLVn/IMXpaDmZzbFH9otK+DKCuKxqTrWh5UKDVTZLcEr5oKo0EPawtEleBDhvs0uq7j5yLh0iPTUWipyTyCTYulr5X1Cishxi9OndZEcBKXlxcivIyyhMU6AlaWkogMNQ/v1xj7bi5EPxhG+Jlym9cqd489JQ9+BxwzZI2hJEB3JyLd6Yfh+Uztx17D+MLkmp0VsY4/zoTwI+WZzExVGWin4zrxzaNX/Myk2tQCTVSenq8rNVpXJ3LcYg0qXTJ2q9rg8YKEkAWskIY3OOA+9NRGxcRpMCl3U6XnzoIYaiQGgQ+qxwQqxqp7CIoyZ0FnwMDYoaSWN2Jh/Emv3bYRkT6piF9iCz3Ki12VVscWq/VWqQbI79lryoA4x/WRtO0NRaR3CUgp9vMWeMQSSkz8uV1uJ52RWBStQ5n0//H/hx3xAWeAWLq0i9Inv7s3x1KVsYRI8QrpboodaQfVbIvDf8iX9e565ByCymd7Lkfl7MSqMt7ECJRUJ4zj0KjqsBFQ6EIga5Uto0+ownGCmBB2tDGb11KgD8AWfwSMf5Zv/VDnd+9Z9LlLPTFfuKFd+EuVFustXWXK8sNOXDMwXvGVOGxq+NdwuFzxUuoHMgZrWcASIwd46zwSC1/VdJsJCeKzvp12fvBGZeO+W68CNh/fuRlmkUcz5d90k82TrLupNlncRe47JU0XYqf5iUWmQMKnxFiHub2ZDd+5amZqoP6KM9gMWm38+bjnJHBLlcXniU+OrRXXLRA8tnk08llQH10/3IklsRViUXe2HXpVBz2jdjNS6LDHW0cNt68EyrSMuCCFu3TlGmmzm8q2iHIf3uQ4Dld7ppCx8mLbQo91fdcet7+szrndxlqBZiFcyuBBukWPFrX23cFN/cBqwtQCxV4+Atxwy9ScaABG+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 04:47:07PM +0100, Matthew Wilcox (Oracle) wrote:
> We already know the slab passed in is a valid slab.  This looks like a
> sensible check, but all callers assume or check that the page belongs
> to slab.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Side question: if someone wants to (though I don't see much value in it)
iterate over n->partial and check whether a slab is corrupted and no
longer a slab, should they convert it from slab to page and then check
PageSlab()?

>  mm/slub.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 8fde324cd308..6b0ce2677d32 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1510,11 +1510,6 @@ static int check_slab(struct kmem_cache *s, struct slab *slab)
>  {
>  	int maxobj;
>  
> -	if (!folio_test_slab(slab_folio(slab))) {
> -		slab_err(s, slab, "Not a valid slab page");
> -		return 0;
> -	}
> -
>  	maxobj = order_objects(slab_order(slab), s->size);
>  	if (slab->objects > maxobj) {
>  		slab_err(s, slab, "objects %u > max %u",
> -- 
> 2.47.2

-- 
Cheers,
Harry / Hyeonggon

