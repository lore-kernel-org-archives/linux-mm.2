Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578EACA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 15:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CF4C6B0297; Tue, 26 Aug 2025 11:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A78E6B0298; Tue, 26 Aug 2025 11:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86EE96B0299; Tue, 26 Aug 2025 11:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73ACC6B0297
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:11:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03F8A160186
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:11:22 +0000 (UTC)
X-FDA: 83819247246.01.32B837E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 686AC40003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:11:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TBNsI78I;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=caD2ZaOp;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756221079; a=rsa-sha256;
	cv=pass;
	b=Wkw1+LpKruRtDFxtE+EPOJvnREGfyGAA7cczVPR+kMWy7y5LzAR9mZrg+AK8+8/maGAoLS
	q88PjSoHvVVSu6b9IRLsc3wjvwcAn6YwgSab9N5a6zE5aNNYpdZ8pvm2hcbcKD3Cav6Y69
	43LTfIVlcK75rylCg5VSLqGjn132zJ8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TBNsI78I;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=caD2ZaOp;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756221079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cg/aMdSHvKnZVaFGGF0RHAAAw/K5p/kcpWxPuPm5lYs=;
	b=lfVpKhyS3BeAwXc4FX73gC2s8DNwpvlof357YTZ4kI5mDVAX/Oke/pAMtUIGJfGgTvT5Ew
	rfBBCWMPDvXulXH0Z2RzDuOM3nNva+jTmyorbXaVihMbdTGU7UsFFwC2+tEucbY1c0XJdL
	ZAujGjyjSj185dUbadmpo4aIy6qOKBk=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57QCHmUQ024768;
	Tue, 26 Aug 2025 15:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cg/aMdSHvKnZVaFGGF0RHAAAw/K5p/kcpWxPuPm5lYs=; b=
	TBNsI78ISEECr8sT8iEEPN0saGhm600j7CBFvD87/2mH9+U1uF7D2a/G2Y62GjmT
	lU0jstR9f1HA75sgS9VCq4Op8akovyEtrxM/oJsQqqK1N3vLX4+BORdNjlOuP9Tm
	090+0M1TBQJ2PZSSWAeyhAQGJjl1nhegBjkh5z3cFyH1/EYCojIeYCUDa6jVW3jz
	fz2Bw4KkcoPnMfDe1KCyUpgimOjkj328JcEUmtZe+kuT5X7NmvBgSoOz+5xjEh1P
	vqXK/vxCOc9t7iHXjkyMoe8RcV07dKok9CUqz3Gnz7pbBJwvL9FjOetqi+fpfps+
	xIHLK1LmxevAf0V0qHlXjA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt4rhp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 15:11:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57QDkUde005062;
	Tue, 26 Aug 2025 15:11:11 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q439u73q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 15:11:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WlamOsIbq98sbJWuCLqzq6vnnZXYRcRo4WCoDQTqyQ5AYPbAr4V8HmGMoOjPx+BRf3mHdSufKNSJOMHbz694YsOd7Oxou1A3fJ/zKwjNKpmxmWlK+ERAK8kWupcoTmpftxTVMsW/ss/AH+E9scUb1mB2RCcCU+9H+Wk1ZmwjlWsZjQVDQd01PkGrrw0bDWK6uyD7yVpqH4BHfhGmgWOQK603Lme3mmNaPfzpF7kiRZKvhBWQpXXuqjSSz35bKDNUInBZgUQKz+8BtOmpNT5AbTLlCIqyEdXdvjtBouwPl+moPFsikemeWu/F0M5hJNwC/bXZzXCLhWptw7dQf0oWEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cg/aMdSHvKnZVaFGGF0RHAAAw/K5p/kcpWxPuPm5lYs=;
 b=THvSm58dTkLFKa+1kXZyTJdvj5M0FjaZfjbVouNUQsKMOXN0Ly4M3XwYnWANC3CGkl+H0iAF69Y0d0HyhUVKlMPOqSBISFj6u97zYuaR3iU+fym05AnLNVW+Hd6BFYEp+vddAuog8uiLMee9hKT5iJGj/jiHNhxVQq63JE2vdHX9KoSAyx3UsTjhONrMxNRzwG4Did8Rx2TJ90xRxJmdWnmf3a128FsgHQYDAGGXFXUxZ40h0S5gpvCf/Lr4xrdubZNnmTm2ywdk4gJ6WyLlp+JhZKWLj3kr0GocSLDUtIKfS6pujeCmeo3q0Hxo0JBbPtfa+9yGVYBH3CP/ghNatg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cg/aMdSHvKnZVaFGGF0RHAAAw/K5p/kcpWxPuPm5lYs=;
 b=caD2ZaOpqmhISZivsF6FAJ4BMdvNt6dPar9tYnJbofX057OZb068mm1kkMvreQJNWz3O4SjlvUHiBk3qyw0BjRt2BMnWZucKgi8e72N+RWqSMI7RlmsstdAd0+zEWdls7OdXSdrAbseyJkfv8yPXLEP12iP3vUyGMp6fpT4UsIY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ2PR10MB7812.namprd10.prod.outlook.com (2603:10b6:a03:574::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 15:11:04 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 15:11:03 +0000
Date: Tue, 26 Aug 2025 11:10:49 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH v5 13/14] maple_tree: Add single node allocation support
 to maple state
Message-ID: <6rvzsp6i6p6kc63acbg7hmqlsfx5htvyg5rax3llrauwwyzg4e@f436k2inorfe>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rcu@vger.kernel.org, maple-tree@lists.infradead.org
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-13-b792cd830f5d@suse.cz>
 <CAJuCfpEjaw+4Ay-Yx=unHev+M4M9FmNmz_PSYmtsFn3EToLBxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpEjaw+4Ay-Yx=unHev+M4M9FmNmz_PSYmtsFn3EToLBxg@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR03CA0106.namprd03.prod.outlook.com
 (2603:10b6:303:b7::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ2PR10MB7812:EE_
X-MS-Office365-Filtering-Correlation-Id: 44303fb2-c1d9-4385-8b27-08dde4b2c588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZzRUZGl5VVl2QVIvSEZRSnlHSHpGcG9MWHVEbHNOM2ZJVkZmNEQ5Z3BQUkxK?=
 =?utf-8?B?MjdzQjkrTGZjNkhWNU5MSnJHYUgyNXBveVpGaHc2eGNuNXNRNytjeENHZm0z?=
 =?utf-8?B?ZXYrV28zRGZoR1BKRUJQT3Fva3RMTEtrUWVHVjFUTDhSdWpwK09PbXlhNkVH?=
 =?utf-8?B?VTdpMU11Zms2cEhmbjdYTmxhdVUwR2c2R1FnNS9xMittQmtOb0Q0U2NudWlC?=
 =?utf-8?B?dWd1S2ErNzlvMVRXMWI0aDdSYzd5SzU0SWhNZXJ4dWZ2dXo5alFYbEF1Q0hM?=
 =?utf-8?B?WkZFYXJua2Z4dTdHbk13cUw3STB4WGlMWHkzSmt0TVQ3N0NDS2p5MGR1OGJV?=
 =?utf-8?B?RG9EZjVuaHQ4UU5oOUNEMDFhYWRUQzRrYW9oL21udjFSTUZuQ0ZGenlxSmhL?=
 =?utf-8?B?QlBuUEJzQXVKblFRN3MrSTFVSlVUZHRVS2theXByb1VqNnMzd2Q5dDJsejho?=
 =?utf-8?B?Z3k2VTRjbDdJRTZ1N2pkdGRJVDh1cXNsQVpENWhYSEJkZXZ1RTJ5NEdnNlMv?=
 =?utf-8?B?UndieElic3VTUmRXYU1hdUNkbXFCNVhvL1lIajFyeW0xdHNyb0dvT1FwTndX?=
 =?utf-8?B?VVlCWkpEZUdvS2g3amlJUkpkN3NVd2xRM0xlbWMzeVhQbzEyRUYyVjJoZTZn?=
 =?utf-8?B?ME1BTVdIalN3T2lrekV6ampuazdFbVhpTmV0T3NkOTJoRkRaRUF5Zmt3NzNK?=
 =?utf-8?B?VU9XSEIyMnRmdlpuaWk5WWxUbytsZ000YlBmMDlvM21JRk1aMWwxaUdBeUJY?=
 =?utf-8?B?WUFsRGNENUF1dkR1UDVxNkxCTTBCWU1QMUNpY2hpYWxYQ1VPSDhSb240NFRh?=
 =?utf-8?B?TnFuMGVIR1d5c1FKTmF5bGNYRnJMVkZIbE1iTE4raytEKzNFMFhIL1l5b2E3?=
 =?utf-8?B?RWFqTUdSLzdEeFpqWlB1cTdYOW5pc3dmaFE0Mk1tWFBLTU9QdDBXVjNqV2hS?=
 =?utf-8?B?WjE2V2xNazltTHArczVjMHZqSzhFVUg5Z1VtRkpzNk02bXVXTzVXMjcrUEpy?=
 =?utf-8?B?TWRCcDd6MVdlYzF6WTZ5QWtCWkVmYlNKZkVRckRLWGtYZWhoczJPVXVVNlZv?=
 =?utf-8?B?ZzF4QUdhNmhSaXlPM2x3RmRqTDliUVFVdXVHRDlVZDRlMTlLU3Jta2kxOHdx?=
 =?utf-8?B?djBvczBSQmoxbGoyay9uVkVKNjBwYUhlZGttTjQybzMxcGQzRGhYL2tMVkFT?=
 =?utf-8?B?OVdZTDU4YWowNktrU1gvRGZOWGNsclNUdm1heWROSmNYVkFlUkU4dnZNL0ZY?=
 =?utf-8?B?TG5JUWFwNE8zcGMxdm1vQ2FwVG1xVzlDRWcyVVhkR3N6cU95dmExMkFlV0Zw?=
 =?utf-8?B?ZDZFYzJuWkRwMCtmSnNxa2h3OEhZdWpCbHJqLzRCSG1ta1RubWJrL05iV084?=
 =?utf-8?B?dEFYUjhybEFoakV0SW1rcXFrOHdiK1RidUlGTzZmc0RobFEzQzJhTm50RGhC?=
 =?utf-8?B?emxIb3B1Rkd3ZUNGeEtVRzNONk1Vd0VNVEF5RG9uQkE1bStOWmJWeXNlWTd0?=
 =?utf-8?B?RGpIT2M0UnhLSkFlc1FlQnAvbWdCdHRjZlVtaFB0a1U4UnhBL1BGazNWVWRj?=
 =?utf-8?B?RVBxQW0zbFZ0Wjg5NkE0UXVXYnBKWlNPZW9jZlZtTklpN3JYcDNiRThuMDhO?=
 =?utf-8?B?bjBQVzFXUlRlL2NBeHMzcDQxVU1OY29mekQzdHllOUs3SGpyRUkydkg0bk5o?=
 =?utf-8?B?anhFeml0SjQ4MStIL25hZ1VWUVp2RkFZVWVXWXNueExnVWM1ekxhZ0FUL2V4?=
 =?utf-8?B?bnBKU2dTOUd3d1VMdUNMaS9ZMmYvM0hVNk15UW8rczVySTBmZG02cXpqbzdD?=
 =?utf-8?B?MTE5akY2Nm1XV2tDRzZDMUVoZEdPZmhYN2JmSHRxL2tLT3cxTHpvbXk4L0xG?=
 =?utf-8?B?ZE5SUG9CRzNDcGVUUFozZDNyOWlMZE4rdFpKR3Z2Yk02V3c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzA5Z2tJVHYvVHRnOTh0UENrWkR6SGxINXluQVZ2MHpFTHhCK1RoWnlzTXB2?=
 =?utf-8?B?RjYxUmpCMnVDVHZWcXZ6ZEFjSGFwSU15c2drSTdYUkMzMzlrS3dIMXNLa1lZ?=
 =?utf-8?B?Rzd2QjRFOU5UWG9JeGpjT0h3ZDJVeTdDcUxrOVNBSVMvZWZIeEdkWkVrMVlU?=
 =?utf-8?B?MkNmTjI3ZDNDME9hSk5KUXJscEEzMGZVT3BsQmIveG4zcVA1NXFWSVA5bEhT?=
 =?utf-8?B?RURWd1JlMW55bmU1elNFMm1qMUZXOUlMU1hYSWNBOUtMNEFrSWdQa0RZaG9v?=
 =?utf-8?B?OW8zMWY5clVvY0hNZmpnT3EwMTFwY3FGeHpjbFExYjk0TjlyYnowSHg4ZUJN?=
 =?utf-8?B?aWtrNkJYRk9JTTNvV1ZXalYyamdzc3k1K1Voa1F6dENGK1RhS2x3d2NiZ2dI?=
 =?utf-8?B?dVh3TGV5K1I3dlROZklsRmQ2WmFjaE5HbWtsb2FURW9LTU42TVgweGx2Sjlj?=
 =?utf-8?B?SUttazdPV2VKZGdYN0cyZXBzM2JRQVdOQzdLMGNKdlhGYjlpT3FMYzl1OStO?=
 =?utf-8?B?cmlqVCtFMnlWZ2VReWJiSEtnL20va3Q2U1lrNlFHbTN6enZHeFNqTVl2d2Uz?=
 =?utf-8?B?SS9VcWxxQllpeDNSNlJINWtXNVZhb25xMml0dTF2VjRhWjQ5QWUrNSthcTBN?=
 =?utf-8?B?aC9LdHR2bnhqckl2cndCd3gwV0E2VlBHUk10em1DUE1yWVNtajVnWUduLysr?=
 =?utf-8?B?bVNQTVBaZ3lmeWc3WElNUnBGTitJR1pWZ1ZnREFTTHdtWURObDNlNzE0cnVw?=
 =?utf-8?B?Wkx0VWROYkdKeVBWV3lNcEJYZmpsQzd3VnRvRzZlc0V0RVgzZVEyaDJnU3da?=
 =?utf-8?B?ZkZwS01Lc1ZhU21kZm92LzVBNTZwNGducmNVNDJPYmlJcXB5SHlQUEVVSEpW?=
 =?utf-8?B?Sk80ZDAzcFVJb0FVc3Fiakg0a0lTeEhjY2JJM05SR1NPTGJab1FuYitKeDhY?=
 =?utf-8?B?TURiMklBV2lZZGcxTlExc1NPMFNSS3dVWERvQU5KeEJCN3Y0MURBTlE5OFR3?=
 =?utf-8?B?b2dVeDRlR2Fjb1ViVmxOczFndGZyWDIxcURSQWxKSzg4T2dLYmFkaEh1ZXF1?=
 =?utf-8?B?VDFuaG9XemZYWUhPa0ZxTUsrc2dZOEJQQS9OVlVsYWdWSDU5M0tPZkxGUnhH?=
 =?utf-8?B?WVlQanhIMzEveFFzOWtXeTM1ejF6SFY2NCsvakdzbjRpWVdBbHByeDdsQkRl?=
 =?utf-8?B?ZWwwREZJUC9KQ0NiNW82aEJJNTB0UUlONzJ1dnJMU3BTSEQrUk5JNGFKbHRU?=
 =?utf-8?B?TWJYbWpJQTgxT2FTT281cnBsQkMrR1RTdnBPbElwSTMyT2YxcUUrTzlIaFRR?=
 =?utf-8?B?QS9RVzA1QkY4aGVLZTBISnF5bVBEblN1RE02eEFIVW9EYW9JK3VDSUg4QTh1?=
 =?utf-8?B?TVlXazZYam5HdVAwU3JFNDM3RUV0WmJoY1czT0hQVWtRSjZtbzZyZEpXN3d5?=
 =?utf-8?B?WGMyZzBVcVBOajhIWUlUU3o3U0hna05LRHp0c1NuWkw5MG52dEZUREU5Rm1S?=
 =?utf-8?B?VlVYOUo1cThnYU1xbDdXT1VxTGZUNkc3c3ZMZEV2ZzBReWc0dmRacFh4a21K?=
 =?utf-8?B?MzBJMW1melpMMGh1WERWMDh6YkQwbkZaMlY0YzRzYUdNeVdqV09SaitMNWpj?=
 =?utf-8?B?NXhOaU5zT3pENm43Qk1xWlU4RndLNW9Lb0VZY0VBNklJcWVBa1hmU1k3SlNm?=
 =?utf-8?B?SlZJOXlHMzhEd2V1NG9HeTJjUlpxMW9JQWg0MVpoSmJqUE5FZU5PdmxWWFU5?=
 =?utf-8?B?OXRqNTNyRmJUZWFYZk82VnpWZjdQZzRMZTVSeG1iOTlMYVRaRlVPS2xaVFR0?=
 =?utf-8?B?c09TcW85NEtWNzBhS2ljcUJCLzZuTFI4Ylo5OVhHL3djR1UzWmEyN1VWdng0?=
 =?utf-8?B?dWpNcXl0U2VnVmZwU1AxNFA3QU9yVHdaQXBiQUwyL2lQalREYU5VWWRVUVNJ?=
 =?utf-8?B?THkweGdFWkNCYXlyWWhoU1BiTnJkWEF1RDBWOHo5QnpxNVRtajQ4MG9iUTgx?=
 =?utf-8?B?Yk9IK096ZU5HdDdXMmZGL3cvSFdkK2FPS3kxNWtmMG1jKy9QQzlCODdNZ0Fk?=
 =?utf-8?B?L05IQXlEQ29rZ29sN1lwZGVUbHp1Nzd6UDlsS3NCNXZQZDE2ZkhBN0ViUFJN?=
 =?utf-8?B?TXpRZ0VXY3FLYzIwc21zaVI0QjlOeVdDK2hacDdKYXNWTHhlUTlkckZ3UUJk?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PE87hvPikRALbrGW4EjfAjus5S/gae5835wFGFyM84S7u/pxKmWt/eBTs6Mx7ggH1qBDupW1x58PR6d3iDuvtJmiW745U07L/eIxhovGNZX7RZQ1XBi3btt5jvouPPCnvc+Tm8Z0vS9w/IlPQxGmMVIJbtG5rSmRVu66DOVFpsHr/Hdes2OogyH/9flLhB0cjo7JqwyjwtqAtR/NY/TqYV8Pc+f2ksTu1UbCtWFnBcOGGS9Hg9hEMXtDVjIrgh/Fs+VF1xgm21ydi+fPylGjRQLJJIvsG8H9iiiPQSnWXqfkR2yUDrO4odAD8BMDt5TaE2V7k2h3VAM43YUwmSYT3HtNsGtqJ1Dc8iSqfnZM3sA+5bEPfakh6xzy4Wp92nC54wK1O6hOZ6GIbA0ZVvQZ+kkoZoTKOQnYgkcMR6E3ObPWnL2MOUeL4OjxZ8G5crmWVn3mVhzcuMthGkbvl4RKc2xSCFkdcEyVXFL2O1Ww097K6rGqg4sLYgn3M1Pmfh1jsvkSQn0+YQ6ryXPGTuMnik5rodjEqKb+1PoFKxcot0pilJajunOuicYU8AJYSwGwqQo82hV4tF6Gj5qZ6ofOlkLW7LQFk5Jqvajxo/9K+8E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44303fb2-c1d9-4385-8b27-08dde4b2c588
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 15:11:03.4646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AYytqbhMWf4dzmrD7wpZBL8983qTTb6vSNeORpWFerHdLyiTaFe6BdoSyZp/5U0iPB4XCqHJFhr3uU8lLmV4gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7812
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508260133
X-Proofpoint-ORIG-GUID: pzNbwEN0qAw4ayTGzN9x4suIkHPrCOft
X-Proofpoint-GUID: pzNbwEN0qAw4ayTGzN9x4suIkHPrCOft
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68adce90 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=o53mM4GuY_Cv43hm8pkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfXzlO1kqaPGYZn
 2rYEpB+W/x8AE7DJK9mn62YSj1HGOvilAhvoqx0OsDoOz9NP28N7urReJfCfggrBcfo3E3uMvs8
 CfmEj2Nn/k4hF5CMH9zHjtdMoZOb2gj4fbtWzIe2WZcmCMyllSh0guYAOy82YfTaKuSB57CBFFf
 RQMQhokmwmonPCuvpeI9FNNzba2quoBkvEfNOn2GHSDHqjQKp6KeWyLJ67gv6IsoBI+FW4JWboV
 R8gM27i0fTZY3yg8KJRZXVKRgBhRWiDLA6+qFKLJ6Ef9U7wsmIPyPINqbbblby5/sh0CwAPmhJW
 vniESejMTotfsGYkqmpuj5gp36+/ogtJJb527OpuzeeQDpV6w3PpcHxJ89PNmE/anAPa4/kKX3O
 DmftcT+F
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 686AC40003
X-Stat-Signature: cgrck5t16suaqff81tj9qzj5o7fz86ih
X-HE-Tag: 1756221079-408553
X-HE-Meta: U2FsdGVkX1/QNVQPaWdW4LutgrBJ9lgOmLDHaLpQb+iWa08AhInq5FN8Fu0diD2GFHWJ3J3MnHKejtcSvGjTuXP2q7jA9iEbgLJdNPuCtSv9Bnzj3Ez4+rTLu5RqP09RSpy8yCDEKJc2tSSKX5QyNj18G5ix0OfZM259qnHcypnoYwkaAnQGnXV7vmVENHxyVtydnltQdB/W+VXjEXILUSKDJOiZ2VF4EMSDA5MsSsm+4WuR0D/tHfPTAE/i/rA98cNvxZN8sF8A94HF1RNXAiomexoZyfCddDZRMFfpngnkjyNLjn4SadB1LwRUpPh77QYIA/aN8Zb1z0fRMyUi6UO9h0SVKm63FOvyXz/rMHYu7SzXCGlFkBc2w0u+7F0wIZ6b23hgh6HOD7yQ590oTDlEg000jSbMtJXA4jeuYk5IVFD0/Y5yIxsGTH4PjtlFuvldZ3F6p+6Y+wo4D0U2eOgb/l3MCXvjr5DkVe4pmIxF3Fk9kYQ+AHTE1s8s5s8iBERSbsw+rvUzBqs231eKTrqz1KKI4ZdK6S8WQ6rtHoyy0t+L+nO6rgRbKLwmnoRR4YArmlg8IZwmIN9Lo9HnGhU2I4yh1OtFcUchTyyjHEUGU7RF0XxL6BvNGP6c5kVhLorKlpV12BpZIMzoUVONNzIX4goOgJ9xYE1SqUYPm0PcN+JVgUQhmcAlP0slwX795K5kEXjpGJP4+smGmL8unDOCqRT8g++QLJQPUFFTnmY9wAPUJR1jklFlzIcVMfRV4VtuZ0obCV+Ogo3NhdC3Q2Jv3FS/bix79t0o7Z2lNoLcEY3eGeNRBw2xZ6LtwXbnjtadnPB8jvYCelAHQ606aVuWrT8nnCKz/eBc4jEIJagGVWDwN2Hw4w1ERXFhGQccU4eAZcbZoWI+r70qDwTus14MR/wRqqijnv6q35cu9smarCeKMAfcZgZ74qv4P4XzYgnX4OKa4hyymhxn350
 yLxUkNZc
 2sPruH5StB9x+QtqXxPYnojC+Rq7QYyBpUqaJJeC/vhA6G8S2gCaaeWci5lFHPyUHQ1x7G3vYgPmtwczuDvs6M5YoRb+R7x9zS6dhROO68uPBU5bla25q+dPjb9QpXju+e5aBNz4Yx2zLW5YhJ4g+/SE2rCk9Hx85NnMWwvx7Pfj9nrwSRAkwUz4T/LkpUnt1EiEOutumYNwNn4ymb8G6UhukC6aPN4fm642r99INi/t/wlH5FNcWn795KYPlQtiAZpI2nvwWggDfz32GWjycwQ53h9NlCcH497YFVDiZ8lzJlQckhNrIHfe2t8YCzYn0VLneqXGR/Ap5eDYdHin6jQ5JLkqJoQoxL9nxNjnK9HXTCswb0s00YYL//tN9p2ulaVhDd0+yZZPAVNzUfU0tXgJ/A87NPMIUXyeLu7Fz85adV6FXt1vRBuaCdZ+AfXuxifXv7oWdb6GWFx7qP38FhOwdmd/zOzUZg4S+/nTtNtR1S4k4IHzd5lBIJHrWrD3VwtaHQAagcoqtHXpb1R2RAd67K1MeDGMglMZJRxWiyykFtC5LLzCPtEb1XET1MsU9G3sI6oVPrTADuikgH0FHfv/gT8K1zq0jO/0Jytd05/y2Q+0/30Mmeizip+y1whciasA6/UjTpwGxhwZucHxy/WLukmY1UqR0DC283Nh+H0HfVR/0Q4i7n6f7gnuW3nZUploqnqKXY9rnm7DmjRT1feGKyYFsfSCLa61AivQcPR8X8mln6VjK1qlEFVLR+x/544dKu4d0GRnxuhAe4J8XL7IbsnGzDljvWIoIECXM7cdK/HzESDKQZ6NKpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [250822 16:25]:
> On Wed, Jul 23, 2025 at 6:35=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> =
wrote:
> >
> > From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
> >
> > The fast path through a write will require replacing a single node in
> > the tree.  Using a sheaf (32 nodes) is too heavy for the fast path, so
> > special case the node store operation by just allocating one node in th=
e
> > maple state.
> >
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > ---
> >  include/linux/maple_tree.h |  4 +++-
> >  lib/maple_tree.c           | 47 ++++++++++++++++++++++++++++++++++++++=
++------
> >  2 files changed, 44 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
> > index 3cf1ae9dde7ce43fa20ae400c01fefad048c302e..61eb5e7d09ad0133978e3ac=
4b2af66710421e769 100644
> > --- a/include/linux/maple_tree.h
> > +++ b/include/linux/maple_tree.h
> > @@ -443,6 +443,7 @@ struct ma_state {
> >         unsigned long min;              /* The minimum index of this no=
de - implied pivot min */
> >         unsigned long max;              /* The maximum index of this no=
de - implied pivot max */
> >         struct slab_sheaf *sheaf;       /* Allocated nodes for this ope=
ration */
> > +       struct maple_node *alloc;       /* allocated nodes */
> >         unsigned long node_request;
> >         enum maple_status status;       /* The status of the state (act=
ive, start, none, etc) */
> >         unsigned char depth;            /* depth of tree descent during=
 write */
> > @@ -491,8 +492,9 @@ struct ma_wr_state {
> >                 .status =3D ma_start,                                  =
   \
> >                 .min =3D 0,                                            =
   \
> >                 .max =3D ULONG_MAX,                                    =
   \
> > -               .node_request=3D 0,                                    =
   \
> >                 .sheaf =3D NULL,                                       =
   \
> > +               .alloc =3D NULL,                                       =
   \
> > +               .node_request=3D 0,                                    =
   \
> >                 .mas_flags =3D 0,                                      =
   \
> >                 .store_type =3D wr_invalid,                            =
   \
> >         }
> > diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> > index 3c3c14a76d98ded3b619c178d64099b464a2ca23..9aa782b1497f224e7366ebb=
d65f997523ee0c8ab 100644
> > --- a/lib/maple_tree.c
> > +++ b/lib/maple_tree.c
> > @@ -1101,16 +1101,23 @@ static int mas_ascend(struct ma_state *mas)
> >   *
> >   * Return: A pointer to a maple node.
> >   */
> > -static inline struct maple_node *mas_pop_node(struct ma_state *mas)
> > +static __always_inline struct maple_node *mas_pop_node(struct ma_state=
 *mas)
> >  {
> >         struct maple_node *ret;
> >
> > +       if (mas->alloc) {
> > +               ret =3D mas->alloc;
> > +               mas->alloc =3D NULL;
> > +               goto out;
> > +       }
> > +
> >         if (WARN_ON_ONCE(!mas->sheaf))
> >                 return NULL;
> >
> >         ret =3D kmem_cache_alloc_from_sheaf(maple_node_cache, GFP_NOWAI=
T, mas->sheaf);
> > -       memset(ret, 0, sizeof(*ret));
> >
> > +out:
> > +       memset(ret, 0, sizeof(*ret));
> >         return ret;
> >  }
> >
> > @@ -1121,9 +1128,34 @@ static inline struct maple_node *mas_pop_node(st=
ruct ma_state *mas)
> >   */
> >  static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
> >  {
> > -       if (unlikely(mas->sheaf)) {
> > -               unsigned long refill =3D mas->node_request;
> > +       if (!mas->node_request)
> > +               return;
> > +
> > +       if (mas->node_request =3D=3D 1) {
> > +               if (mas->sheaf)
> > +                       goto use_sheaf;
> > +
> > +               if (mas->alloc)
> > +                       return;
> >
> > +               mas->alloc =3D mt_alloc_one(gfp);
> > +               if (!mas->alloc)
> > +                       goto error;
> > +
> > +               mas->node_request =3D 0;
> > +               return;
> > +       }
> > +
> > +use_sheaf:
> > +       if (unlikely(mas->alloc)) {
>=20
> When would this condition happen?


This would be the case if we have one node allocated and requested more
than one node.  That is, a chained request for nodes that ends up having
the alloc set and requesting a sheaf.

> Do we really need to free mas->alloc
> here or it can be reused for the next 1-node allocation?

Most calls end in mas_destroy() so that won't happen today.

We could reduce the number of allocations requested to the sheaf and let
the code find the mas->alloc first and use that.

But remember, we are getting into this situation where code did a
mas_preallocate() then figured they needed to do something else (error
recovery, or changed the vma flags and now it can merge..) and will now
need additional nodes.  So this is a rare case, so I figured just free
it was the safest thing.


> > +               mt_free_one(mas->alloc);
> > +               mas->alloc =3D NULL;
> > +       }
> > +
> > +       if (mas->sheaf) {
> > +               unsigned long refill;
> > +
> > +               refill =3D mas->node_request;
> >                 if(kmem_cache_sheaf_size(mas->sheaf) >=3D refill) {
> >                         mas->node_request =3D 0;
> >                         return;
> > @@ -5386,8 +5418,11 @@ void mas_destroy(struct ma_state *mas)
> >         mas->node_request =3D 0;
> >         if (mas->sheaf)
> >                 mt_return_sheaf(mas->sheaf);
> > -
> >         mas->sheaf =3D NULL;
> > +
> > +       if (mas->alloc)
> > +               mt_free_one(mas->alloc);
> > +       mas->alloc =3D NULL;
> >  }
> >  EXPORT_SYMBOL_GPL(mas_destroy);
> >
> > @@ -6074,7 +6109,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
> >                 mas_alloc_nodes(mas, gfp);
> >         }
> >
> > -       if (!mas->sheaf)
> > +       if (!mas->sheaf && !mas->alloc)
> >                 return false;
> >
> >         mas->status =3D ma_start;
> >
> > --
> > 2.50.1
> >

