Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BF83CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51A548E001A; Tue, 21 Oct 2025 05:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CB618E0002; Tue, 21 Oct 2025 05:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3924B8E001A; Tue, 21 Oct 2025 05:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 24D888E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:19:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B13A7880B7
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:19:25 +0000 (UTC)
X-FDA: 84021573090.28.E791249
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 60468C0005
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:19:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZMem8WV2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sUVwfYlp;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761038362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbBWweW1JYy/GfYIBvr+KYl7F/thszcPb4ICMNPVLJ8=;
	b=hZU/EZjAsg5Y+Bht4tSScMdfr9+RFu9Nvxygc6U0HC739r+LCmZfR0ZrB9pROVYkHox/x5
	iel2EsB3B8iuJMFtD0E3yog3UtR7/VLbYE88V/rIKRQS5SrO699oa1tc4PNYePoEG+KWAB
	AH/c4CCQoiqdg7GDd7eevoEEYPip0/8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZMem8WV2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sUVwfYlp;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761038362; a=rsa-sha256;
	cv=pass;
	b=oS9lM1WH+BYGYtxDmpsDzcee+3fZjyEYJCtBAoDF1FeClv90uyvhY8MGui+vSnuPlYnnd2
	W7Uwj2tlo33xAsu5qrNVqht+NcjBWz99bCyhKPOEJNQHERRVNS4+WIfLXZ8C49dbzLWCjD
	BSYJ6VyDxiL6fy4tK/rKr/9+tWmKAk8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L7uR1h020820;
	Tue, 21 Oct 2025 09:19:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=tbBWweW1JYy/GfYIBv
	r+KYl7F/thszcPb4ICMNPVLJ8=; b=ZMem8WV2WHsoxyqZ2nWogXCgrhR/ogPg3g
	/Is7zgeWlipXYwAGtofzE8do/DqeXsD+eYT18Af48dJHJ7Mj14PQ9LCRWjKEVL4G
	4jjPMDqeTu1VGkqg0VXkTq3YUXz/7xlBs9KAHrn4AjtNtqk4MwCPnxlBOyklZGOa
	oGE729o3EoUWsHOYtAMAm1soPfmord1nDW8dtHi0QQLjFQZFO9k1JZrwIboq5d6D
	pZ3wMYf6Bq+EhWb1b3NRxyfZTDgnABJKWrvOGbFwY2Ym2MwuxRem9mKwHM9lHBfF
	L5xoWroOZM+0Xm9UaSmsIVaJipZTwGSmCqP8Lo7LwX440B8DeBMQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3074fmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 09:19:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59L8fUu6009363;
	Tue, 21 Oct 2025 09:19:16 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011011.outbound.protection.outlook.com [40.107.208.11])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bcwg77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 09:19:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+QuG5+FGopDd/0TwqHb0Osb5qS5uJwwyi2ac999esmPlBaIlviTJ1xH76kNyR99F/7tF8iDUwg0a+VhJdIAV87Jieha6IMjr2jKP72A0rNcqQGWL98rAFv8GH01KaTW8HDVJQPmKPZHytu7lnZ5XNIHygLStlAWqd410/9ZcftwGUkS5/mIjyjRjkHTrmYfdnerWon5SbjwtX2340YTGLt0JS67m4RwlreOof2E9kaKaIjYeqNUz5IXPI9ZMfPe5lKAugmR6SbpXR12AYMkW+r6E8oBmlhOgiFw2hfb914cHhxXDIosqREHwKzzQqCTjwy8BA/DC4Unl4zJZV2LvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tbBWweW1JYy/GfYIBvr+KYl7F/thszcPb4ICMNPVLJ8=;
 b=W72ncvFUNgm29qrTBhQQTbr+546XvEe8aqEZk204Vc8YE8up5MDiDTfIVd5htXceEUt2Vv5MrFd+llqxIUR2haeDfZJpD5/y74cCqFehzKIF4lvfg2OT3nKTsamCyf5KOoMSdZchSxXXhQgw3p+pkIyBi2YlIiLlG7RMDd7rJeGVTBntmDS9QQ6c2yg3hb1mgbh+O1dus1AQG8n8aSSI0xkWOWgeNGCNnEPIXT9SBgCgP3JO/8LDEnTfhwXUt4cSAeXBIjpEqekkdbkWPRnCBDBkRJH49J/0yBbE85SlV2/J6RQTY8TO1yaRYp0Qpg6q1gtR+VvxBJOd4yEtXqDspQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbBWweW1JYy/GfYIBvr+KYl7F/thszcPb4ICMNPVLJ8=;
 b=sUVwfYlp3oLUfDouPvKeYbDRWK+U4CFIywqDv3Sf/nl0tLGV1r1XdgBensehKKQ5NOwulk0TOmMMgoJeTXlnsG4MrTBPJ1Fsycae/U/+jCnLzRZ8jBLRbSZI7ugSsU0RyFaXzPXf0jW3YQjeOa6uJUIXN7yIUQfsgxgVxMW8Pvk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4297.namprd10.prod.outlook.com (2603:10b6:5:210::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Tue, 21 Oct
 2025 09:19:13 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 09:19:13 +0000
Date: Tue, 21 Oct 2025 10:19:11 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: akpm@linux-foundation.org, david@redhat.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        jinnasujing@gmail.com
Subject: Re: [PATCH] mm/vmstat: Fix indentation in fold_diff function.
Message-ID: <af861eb7-7c10-404e-8441-94c625afd931@lucifer.local>
References: <aPc4I/8zXCGyiapN@pilot-ThinkCentre-M930t-N000>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPc4I/8zXCGyiapN@pilot-ThinkCentre-M930t-N000>
X-ClientProxiedBy: LO4P265CA0311.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4297:EE_
X-MS-Office365-Filtering-Correlation-Id: f697cd17-61fb-4fed-2f16-08de1082e65b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XFgh7Nz1GEH8yiOR5j6C5CMBAqJuXgzJmbi2psUHTwHKrmajNZkiMPt11DSV?=
 =?us-ascii?Q?VUtQatu9hUg/UEJzfEUfyicgjQLo2fCZw3vP2Wxsdys6E/xVzae7R4sgO1j4?=
 =?us-ascii?Q?m/BTkAuONZboB74L18Af26WKWZ5TsO20HwaIrKtQDxOEUDg5LMlfpn4Rt4Gq?=
 =?us-ascii?Q?2aJ60cUBweWrv5TRN+uS7ay5y8rJbuymIAhOh2hE4M/AcTGjnwrJ/RtFzETZ?=
 =?us-ascii?Q?OHfAvxscMJGnfev+WgE1IZZtCGwFLD9C9Kzo2zY88Wl4GT7TDvd9Rd2h3L10?=
 =?us-ascii?Q?cNO0cMoYD3x5za2eHEStjs+BXinQJ+Wr7uXHgsIoWIXHf3ZJvCbmiqNReI/7?=
 =?us-ascii?Q?cB3nycNx2ASdj/lBpR2Mhvp/7Qcdh9csKO939CZ1GGIt5mNOE1xlWWNZhdG3?=
 =?us-ascii?Q?fnOEa3jjt9nAtkAhq53UcjXnIBtx82WF7YjUJsV/hYvOmVbbAjF4rvU8ivHD?=
 =?us-ascii?Q?trCaKovHiqDX8ktOU0sfrv1mQQGome5Y+L1vpAWQKvZo8MofR/2UuNlrKToG?=
 =?us-ascii?Q?HoyMNLmAaMDCiIM7Jf9f/jv9OaBeDtMeh0mTOjpcNVtzReeKXcln1k5j0BC5?=
 =?us-ascii?Q?SuvFTIZiaVaxSlWrtFt5d8e5gDsIJzh+fH2RwBliC2QIQcu3SwvWyiijSJ52?=
 =?us-ascii?Q?vHpeO89V1rYBJujtnjUBo6yaHdbFAsE4KqJUZCKoS82DpClygr+q5bLpRXHS?=
 =?us-ascii?Q?IfDifzf7k9GfWP1DHg/QXm6Uk5ByWsVKhLMeQHcQ2xuvuzAAwOL03/LK4PQi?=
 =?us-ascii?Q?cxoD43Q6JuYxF080MOY0svn3RaClScUv9hsxPwp7c64xab8gDOpD+Yqbjpip?=
 =?us-ascii?Q?sFiRDt0upI7W+XsKtDmSMSMkfDNp+Sqw1rrwazm/zWepnFYblOgOU8R26m+P?=
 =?us-ascii?Q?QZlbY4wK0wnfANY3LPOjvfZz51XyWID0JUniSRBmA1nPF/e85CqEUP6sYexZ?=
 =?us-ascii?Q?AykuxmtNrTc8marjU/cAFSjoXW8GTK2G4rHzo5o/cNFeKrbzk8cG7GiqwOov?=
 =?us-ascii?Q?iaOmTTR0uwTvPAYybqgqMuqA98KrUjrbalFrEObYPD9SOeU/nU5unBoLI68Q?=
 =?us-ascii?Q?EAmr84dvvhg7jLwbfbA6hzhBuNjjxFBrXPSPwaET0FG11i8iFVWwVZu6g+dh?=
 =?us-ascii?Q?tEibkxCpzClCPyaKVP9qc/luvsljhwlpz1LfPmHbyhIWKFvWMOeMkc02zcly?=
 =?us-ascii?Q?Q7EnsAa+PcrdPIdSrChuKerE2ZJAZfTzEm+BKhpwcxby8xTZqfCS3r6DkwiF?=
 =?us-ascii?Q?OgH0shEzBzwv8ogP/5rGZ9xEoCc1svuar7xmmcsT2iJQxrT1Y3wXbe9PJfod?=
 =?us-ascii?Q?WfqWMM3DTU9xsfjqq+gAMSd/3jv+CoPk08bP7sijZZt0NIkheP4oZgMHOccu?=
 =?us-ascii?Q?1uTOAn7NSd2W8sOjEzUH0+lnZs/M1rvOxC0CLLLcbN5F3/YqFgdZOeZyiEn9?=
 =?us-ascii?Q?/w1BQQImtR8oAlRWMkENNC7iiMJ/cG+3yH4xitDFL+eoiVmcxeoOlv0EwzRo?=
 =?us-ascii?Q?UkBFOhsk169Q/VM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cKF29hRdvhvLmQ681KQUiFalEP3TMZwyD9h/K4OdOI/j9JAgBtwC1l26lvhO?=
 =?us-ascii?Q?GjQPavlRfDi1IOTC7eKEmio33fWSA0W5Lwvk0qp2sjRYVrpkPOA5wgMQz98N?=
 =?us-ascii?Q?JdWeXK7VZ/I9U4h4gCEpFSKOs7mqZwEVuUY/CGjT9u9n89aczmmxeFR0c2qw?=
 =?us-ascii?Q?8sRsMFpcWbQLfu3vhx5e6/Wt3j6FQA/QdlCmrAO229Mn9IImt7e3a5Ozqbcy?=
 =?us-ascii?Q?fV7dCuu3FTpf8C1i4zjQ+EfPmny3bD1Bnk6j+UNOpVqXpv3K6rsFioSWjc46?=
 =?us-ascii?Q?ah8235TR1OVbKAAmcKu8fp6QO9JMMbADlQH9zbt/cLW/oO4gzFE8ZNqL8bJe?=
 =?us-ascii?Q?kG3WMN0wGB4TFq8I00k6Xod3edCT3Qwk5n140PuDMGZSGCnQaKjl0hIAnE83?=
 =?us-ascii?Q?p0HDszwqvRKwOqrwRZHE+VpF9kbyMvETAwpq8gVVZu+lXjadGt9g///d8iS3?=
 =?us-ascii?Q?ELELw5DP7wlFqcMX3+YUWh/3JeuCYsAc62yzCkF6oa/fK/xcLjEZmm2Gjzfe?=
 =?us-ascii?Q?hUMQocd+8jSNm/CTeZqpIbyCxbqhr1uGpDDqRz6k++sxKYXR498lioZB2O77?=
 =?us-ascii?Q?zwoS9ezvmMdBKEHsRGAFTvFS561/2d4GMap0nydIPW06Eu7j3FdGCALTTzqs?=
 =?us-ascii?Q?ZXxPjfdKtMDpjUzig/qqQSgLAwwZ2yZC2aZ+KtUDIpADSyr4kreWT2D1xBAH?=
 =?us-ascii?Q?JIhAGbFnBs+tBgKlJCMCDmdPOTJIs+HdxIVN0e5W5pYalip6w2C9b2QawPTL?=
 =?us-ascii?Q?e3pqWi5+aUTk1FV4zTve+ZU7azfVLEsqpquAgElnDTIU5qhoJ7XxBeY1HPa/?=
 =?us-ascii?Q?Z9xFcyN7mNXWdq6RDMPyylEWa0zml8EprWoL+txiq0z+gR3W6sGrA26Li5tD?=
 =?us-ascii?Q?ZDuzgSe5Mr0aFUYXsQ5ebyLDoXOp1x7k2Ody6k7KGKzKmzKpVRNj6NvB7q26?=
 =?us-ascii?Q?rHuq1e8bBckptdzo0xm7GYmsIMopK1f59mAr5JdvVYFvV84xMUkfkfC9xFwj?=
 =?us-ascii?Q?hB4Uz3ZKckmvY4EtNSnegZWYTyGVbNu4g0kYkodieagEPbbI2cWMTmgAIJe+?=
 =?us-ascii?Q?Atpw/YA405rtXuZuQCs/h9OJADA/e+wj5FrYm0R89WhHAwWFXEZABso2Mydd?=
 =?us-ascii?Q?ANfi4vVVZP+QaIhfeAgRbDrj4H2mok9rItTkoxlc/z13ncGkpMXWGkzJ0N2M?=
 =?us-ascii?Q?DskpIJPNgT7yw4RN3qoLtaQ1Xa/qL7W3O6FavMoVGPqGnANGMme4Z1zwDsGR?=
 =?us-ascii?Q?WWkLD+2oZUseVYC8rlPoYyqfjEjeBFjk3yv9yqUOHmdjDnto/5VqE34htFDB?=
 =?us-ascii?Q?oYwbm8Zo9xDdAwbVQswEt/MHPwFpH0MprupquxkmFCe4ouVJ/50is7OWhe4L?=
 =?us-ascii?Q?/Mt+fs4YWmTpl/kxz5N+9rxDPNZCvJ+6zCmOLGwxqtIHPSNYbPU75WdwB8vs?=
 =?us-ascii?Q?a6ayFV9ECQORIfyeySrjeXzTiLGkn1IDKr2qEqd6MoJf1N2yZmAaesVUu6/f?=
 =?us-ascii?Q?PdD7ankaE9AJuhPyNwCQHBM61JqwpUsPOqnP7Uk7YVvl7EwD4YXBMVZp7O8T?=
 =?us-ascii?Q?Kyb91yAFcXtAmdc7lM6HK5mA573yljkr3tpC2CaqsnPu8UncsrQGHRjdJ63B?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	17TCqtnDRjOvD5BoU4FQUAZT79xgPtqfFsAYJhFATfdc9DKM5OSEcJI18HKWcRmDq5UcpRecQ8wBDAmJIV0CtwmFP/BF3vsvTG5L3m2ebmGNT+5rBSm1wrZUXZ/7jsBWxbYgKlALu/FoU22motvwmMM49wnw8H2eFxifA1ZtgX0BOfA3YrbJYgtMGIWuakW8OMs24PZsZEKbORpORuYEQvbMyocy7QXrthVnb7fvFNcOvSkgrx/tiTEv2YAr4lWTr0/SL/xPuwE7aBzX2fVMif3FHRURVH/1j2qwT/eIASOhi4w6l2YtBE75EW209SX4zQ8lK87tZLPr+GHvXvA5hV1n2zlhQFFtNkSHrpjjuwShgBODk6c85UZCTOdnmpYWzuSHCcGclPpTlvPMWP5I5QGBVkk6Xew1OD/0aEHptFgUZoapQi1tHlkOC9BoNZScsUJUDFBTdDLxxUZQhtW96hV+dOtsyJLKECltZiVSh2nWYd3Bo6KJam2i/3pPs0wljkbeYecjVd3oxosBshcETOHo01dazANFDr4CimdhmBWUzC+o7O3bAzeA3XUPiLdTbnoN9HUMuUgtlOgl7i/uBEwMP7G96+Fj5yN4GSRUsZA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f697cd17-61fb-4fed-2f16-08de1082e65b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 09:19:13.0288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U1SNxo3QXed40k+aF9gEQffUhN/Xb2vZkNmCr5XRe65Sr0xfWLtlb5rNlPL4ys2fOlGdppkxP1Xa89fd+znqWOb55iQlG4QisYG1AtpoBKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4297
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210073
X-Proofpoint-ORIG-GUID: WQfS5-FlphCf0fZ2eMDm-mQKcK408BZf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX/lkyEVAj1Qbf
 DWWWyc2MwizjewMDNd6H0hUMH7yBQ+LkG6pk4JYaYa+/cvj1hiUN5hzqspkuR7m5Hwcl4pIx5lL
 Eapdc5HNrJa0QqclvnSRUHzVvjDMihgjZKHOy/4ppFUk3zk5x0RvzQ1RhOQyknWZb/RzuRfhJaL
 zHlQiN952ayxrbaBPOC85yTzRt3XYlmCN3FUhYsF6xWk+pyI3QCziFFdke27A7G0CuQCJXFamPV
 fnYzcRibzPeJb+rNCbZpPmqCLKIckMjQhQdsuNvqElTeWAeiwPMOIiFr9JBTjGxmfpmDFOFqPRq
 AZOpVqeF4ZUSvNKXtni+NXHngcKpfo7oMw9oxqkOBEQ4tXp0EHb+g5E6qEr4OWtmg3rY6r427g1
 kZ6Tlq3nsR69iJGKupksW6rjc6ZZNpvya7/lpMmepm4D0vHWpSo=
X-Proofpoint-GUID: WQfS5-FlphCf0fZ2eMDm-mQKcK408BZf
X-Authority-Analysis: v=2.4 cv=csaWUl4i c=1 sm=1 tr=0 ts=68f75015 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=DyMV3BnNAAAA:8 a=yPCof4ZbAAAA:8 a=2ecftfDPbqYspBDr8a8A:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12092
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 60468C0005
X-Stat-Signature: ri3u9bmjxi4mtgwxb56rj1hupa4snhhb
X-Rspam-User: 
X-HE-Tag: 1761038362-374425
X-HE-Meta: U2FsdGVkX1//6PqhRxtVSJ2/uNO1WvVIrEXyFpydlIRWytoTmOBezRiCkZHDTtM7jCkgsZbGfAFA8H2RAjrGdOGmubBS7/663M9RJjnNvBo34c9PQTqtlqRL/Ps9hVD5F7yQNn0Kd2gN2dkZXlJlxVYxV+CZdAcq1QM7pGc0Du7BO8rKNBjI2Yh6+Ufr7vyjD6SUEZ2i4CoXAZ/JNTDeoI39zGq8SF7T1JF9zYi6LyndCnLVjqSDMucRSPtpGeTz6qs12nL9T21cCtPxt6CgbhFJiy7YFe4FPTFo5S7KeHT9b7flPbphLIdx3xbyPCnPdz1donlICRgl6Ih8+s+QqPCUv3aI2uPX86auqeSGXSTApgKLgC8mchhWfGkXmx3JCAbvMfT7YpL/weTqWSblR9BrQ8XIs/Kv72yosGxGkoNFmFfWbqd6QmWMbxYSyLZ6ufE9GGATtH9a5zVDXy1XUfydvzLRqkOlLk54nwBEpptx4iRsKE3eQUZlsp4Kt+h30SbR/Do0ChgkyRX7FKvZaNw2XsCof/+ZiDFVPBckfd+fFPwOBd83GOXrD6wqsL5wTU3LhZjnnMP/tcSDrvrGlZ3ysMmt0pr3GzEHXp6V8GC9DQKi4/wWjW2dOZ8fJkqSji02mLz/TvyTFxidHbE6dDfC6el5E59kJwKdJ2j2UybEtTdRj2EQjvUIzCsCLKNsZS/1hOAMi0943yecpb/+eRPOa5ltjfGs4Q1WIIo2MVHMuesNsXTjHJlt0jSEwOFBNvBeQprWhfxbywLYK2WbjDHCpKVo+JnFhAl2Z89gOi4ygHJjc6sQp4GhlwBuoFg7E7NufPNxH8gEh6pPYKANehi46YVuKFSDbKb3DPiKUrk6Fu6l7fhD50gVQxwWyqxYIHZLlXFyyMEdjSMjR/nbLiF49GH2YfUkiiEz3HcxezJDbO28ZtroO2q3eKQsd0vCVGUAolOIOWJ3TxV0koN
 W/Qm82X3
 26nB0juuCxN9UbvGUf1VEo7UMLdbtPxJ+Z4sFaK+PW4bmO/21KYVNAA1/aEQfJ0R0REl177oLwRVaHca1qpT/3o2BkHsHsMqsI0pZ5rBOask00jDWO+Pvc1wur4sn2mK7Zh+zUNbFnmUzpBt5eQsTJrgEBbJbtcrKals3e7bC/n16XqeBx5pVAm7ZmQvYJAXQEwsrMmp9RZ/iEJZOACdUhUFpT1oG9XpthJ68YmjbxmC2VfGD81qvm0yNdEJPi2Jmj79dzhq3F6Q3R8uiMlnu95yIpMOrmhlBEEE1PCcJ+D1nhb3jnnga+6Gt+kgWeedJ4U2olL5E2cLh61mDJ17tTchvg4ESAdJnGgmaOMR+Dkf4sYZJeI0mHRxuXS4pW2jGYlWHbZEaTdzYk30hI9pobeftAPjXcPF9a4P5/BaoDGaBafx6M5ddkhrfTbh/Avxt1xHvfOx9Ek33xHr0TKHHxNq/e0X83e3TgsDerVHfXOFvpdvMHLu8suZLARXSs+IXilNVzkSCOjBecY6mLI8mM9mP02w+1iWRtviRQr4xH5p1di/x91OJupDYNPh4RMNIrQo18qProOlRIVZnqUNqkpgwlDtJvUUWUdaOpdKHa6M7FR+ALrp8aIK4s9uV72oBAlln0vvTWp4njWm++fONKvx/Q0KtENh7mEeucxcEKOAKyvopFDVAdqLdhAQOIyt4aY5NWxJNKU+9eXa6OAgmBESFbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 03:37:07PM +0800, Jing Su wrote:
> Adjust misaligned braces in the fold_diff function to improve
> code readability and maintain consistent coding style.
>
> Signed-off-by: Jing Su <jingsusu@didiglobal.com>

Yikes, can't believe it was off like that :)

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/vmstat.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index bb09c032eecf..63860c3d22e6 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -782,13 +782,13 @@ static int fold_diff(int *zone_diff, int *node_diff)
>  		if (zone_diff[i]) {
>  			atomic_long_add(zone_diff[i], &vm_zone_stat[i]);
>  			changes++;
> -	}
> +		}
>
>  	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
>  		if (node_diff[i]) {
>  			atomic_long_add(node_diff[i], &vm_node_stat[i]);
>  			changes++;
> -	}
> +		}
>  	return changes;
>  }
>
> --
> 2.34.1
>

