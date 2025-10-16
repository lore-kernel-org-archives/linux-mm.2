Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3542CCD19A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 13:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008BE8E0010; Thu, 16 Oct 2025 09:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB098E0002; Thu, 16 Oct 2025 09:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76408E0010; Thu, 16 Oct 2025 09:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF7698E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 09:09:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51A741A0329
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:09:34 +0000 (UTC)
X-FDA: 84004009068.12.EA4D0AC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id EE5264000D
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:09:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DhYGcnZT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Gg3eJxwS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760620171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MnhVqrw7ezkgwmbC3kZ7mauizXJ4vBZGeBtRxGUUXt0=;
	b=ICmue4vTJ8D20FxVD7L3M0PsQsOfT2kKV2d/URtTFyom0Rc9EIBE5L8XVkODH2+uI515+b
	Mrccm5zUb1sj62TpXne5L12I3YJqTFwh1jOar9qCA6mE8sGh/zsuGHorRJJCkPbBNy9mOq
	5MDN7wki+nQc97MYxkK07nnUaCJI/Kk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760620171; a=rsa-sha256;
	cv=pass;
	b=UVGyBUS1zD20xY7oXqvHahIiYxLfH43PChC2hHMX8J2yeEvHZU3/Jw+4S5atglRmIRmifP
	8vq9fF6dWj7+ebHJhUA4ydSfOkp8YZ60BfpsxI0vmhK7extakNDOkyPGmFoaqRA+kh+Ok7
	ijd3gw0M0VNOX3sXyTUJCU0BAGjH/xE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DhYGcnZT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Gg3eJxwS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59GCuSKb018886;
	Thu, 16 Oct 2025 13:09:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MnhVqrw7ezkgwmbC3kZ7mauizXJ4vBZGeBtRxGUUXt0=; b=
	DhYGcnZTRjzHKi1AwGTN4+/87K+bg3vQjX2yPoh4eqJk2lHkOg8Ln5V36HHYk9tG
	tYEKwxA9L1RsY/3STeV12eCQcc9IqHChGyJtWu+qytm/ewKQW8zncrLJl6ZcqSii
	EKazn5jFvBr0W22wQqNJfeyur2HmrkjAkN+SqF+pIhtGSUiiQSHd3gf23vgOK0je
	AA9nf07ziigly+hV1GwosDQuAm22mAs51qMIaJ7vCPHgaRraBtnMweUAzBkyOp3B
	TBl/oHfzsjU+PSBeSmqYkQfHzM8Inyl/wFfO0FCqQPAugjFHZyJsWdr/wN6NDZk4
	JEJOaiIPR32v01th4MmVNQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdnc8u0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Oct 2025 13:09:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59GBK2Rx037875;
	Thu, 16 Oct 2025 13:09:24 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010035.outbound.protection.outlook.com [52.101.61.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdphpqas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Oct 2025 13:09:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qlojdodPISGzffccf9yK/Y2N1RgUURdBHbmWZov1fENbBqJO46uNwkt9Hm+s2kbsRtZWQOgZ0S6clWHcp4/zFmjjWJu0FcErXUkfyxulKO/dlyxsya+/aW/PNEUlplOnhYQsGeHdDtxu78Rf3Kc1VebWCVImYJju0wvOy2L87451PNfU2HG8IlvGEE+tSlTn3ZahHaVHdxq/vEROJin+yXYzHDUxYBx4MWYcTPRWsCrhMV9kKN1MTronfNpuMO0VybmZXL0pmvUBxTCEYib37cZ0NqIwk26Rc7/0fTM0Gk/Fyt2NAzEf3WvMj//deqLWp6dI5IHeikoejYGaupyV6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MnhVqrw7ezkgwmbC3kZ7mauizXJ4vBZGeBtRxGUUXt0=;
 b=eSFSnwwS0Fu+rWXIyLtwvI3TC/v5LzDL5HHQIzSeUb+z88HeTYCtU3ZM19qJMueuczK03vtZJ2aJU4BolrGRjl6hO+zBn/0Uw0MejZgQun3feFk0rExAvjiErLx8zsIfVPPPnRSOfWi0Bdb3qngMjLOqFt1mMGz9OtVJNhlL11wrSi+GhOYlfdQmaGGEP25P6/uifMrN9S7hEcUkEGxbaECjBAIHMwFjHJ5VUFq0dR2aW8TSfPQFwTGAo27zmPINluamTDRZzrDo65+vDQ7baFHMLS7kRpuEgi4OnZeFwfElHrB/rHFR/WndzG2WcdM6juAMgjCv6qgeGd9HwCHdtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MnhVqrw7ezkgwmbC3kZ7mauizXJ4vBZGeBtRxGUUXt0=;
 b=Gg3eJxwSg6pbdi67FhcyTZ5CHDJ0ef5UbthnQ/GjYDU8g+A73modABwFlsj9ZSLOq+jP3tNVZAUz7WFfL7lsC4cGqMo7rcSVPlZblLIH8hTYTXz2akPJUvjYkVfhBzFqOMbGW17Plf5XhV6JLIrQ11fuW1XxcFM0EB+DOjCd+KA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW4PR10MB5837.namprd10.prod.outlook.com (2603:10b6:303:18d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Thu, 16 Oct
 2025 13:09:21 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%4]) with mapi id 15.20.9228.009; Thu, 16 Oct 2025
 13:09:21 +0000
Date: Thu, 16 Oct 2025 22:09:11 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
Subject: Re: [PATCH v5] slab: reset obj_ext when it is not actually valid
 during freeing
Message-ID: <aPDud4tUzZ_NxE_R@hyeyoo>
References: <20251015141642.700170-1-hao.ge@linux.dev>
 <CAJuCfpEpO_HaJuV3ukDtTdw_5zCq9R0MnMexC5PoEwOcKWjuYg@mail.gmail.com>
 <0928dcc7-a4e0-4641-9381-6adf2ad30493@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0928dcc7-a4e0-4641-9381-6adf2ad30493@suse.cz>
X-ClientProxiedBy: SEWP216CA0039.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b5::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW4PR10MB5837:EE_
X-MS-Office365-Filtering-Correlation-Id: 534e77aa-2a96-4cd9-fcfc-08de0cb538a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?djBoTkZCLys5akYrK3BGTTFsTDEvaXBjUHV0b0p1QlhwNmdESHZKMDdzY1VB?=
 =?utf-8?B?VSs3WGFHTHNUdml4WU9QZkczYmV0eWZrU1plT1NQRFpBSVhsUjNTN1dvQngv?=
 =?utf-8?B?VVFjTXdwRUNlR0g4cTREbTZnSk9jMnFNZ3lSQnhJbmFFK0NxZUxsSUphZ1lX?=
 =?utf-8?B?RmErVElrL3N4MTJKY2JrNzNaK3ljVUY3aFoyNng1MkJMTERUYkhibjE0Vldk?=
 =?utf-8?B?Y2xybEtTREswTFF3R0pHUVd4WXY1dzhJNUYyODRRdzlQZHFQdklkeFN6bjNz?=
 =?utf-8?B?NSt4dDl3RU1KNjNvWERjWVVXS3JCWkVPSlIxWjBMV3hvV1k4ZDg2RVBQVFpu?=
 =?utf-8?B?OHdOcm9LbXNLTEFpb3dUdzJzby9GNDJ1N3I1a2Z4azBJZFozNmViaHp6RkQw?=
 =?utf-8?B?V3VBZldyR2o2dmxDZ3lObUxHZGFOTXRaMUl6TS9JQ1VuM2N1cWsrcHExeElN?=
 =?utf-8?B?MWN5WmZMR29sS09TVkQzUEMzQjV6VmlXOUVpOXBqZjdxcUxvRjY4NnpFSzlp?=
 =?utf-8?B?bWs4NjJGWmFEMDFWVGJqUmkyN2hzclNaOUR1K2g2UzVpdXNSRlRFUTJFSE9r?=
 =?utf-8?B?ZjNjaWJaRGxPMHFIdGNmZU4zN3RZdmRtRVdNMkJYeWRMSFFqbHZtQnpEb2dC?=
 =?utf-8?B?MTJsMTFXWjFLK2VqaGt3YnFOS0dTL0dtRy9rc2NPTGFoTW92VjdzU21vZzVq?=
 =?utf-8?B?NXJpM3h6RXJ3MFdaTW83b25lT1hMWlNPcHIvQkZhdXpCd3lMaUxaSHBrMkVi?=
 =?utf-8?B?bklXa2U3UG5MOSt4VWwvcXJpNEhSblU2Ymx2WUh5dUdDVVlpMGJvMDBFNWRo?=
 =?utf-8?B?QjVuVzM1Wm5yRUNqMUVLTEhMaUJIb2xLTzdVa0FHNzloRktLcFFVN2xDRnpj?=
 =?utf-8?B?NXRVeHZUQTJyQ0tsSVl0YkNVUGlkVnJERjF5b3daemwrK1ZGNDVJOUNVR0dO?=
 =?utf-8?B?QUdvYnU4Q0hJQ2hRSStXZ1paTWxmMkFMdEpVaElIMWU1Qmlqc0llRWhWdzhE?=
 =?utf-8?B?SzhWQU5QbFJRcWNsRFRWRnkvTVRrUWdHelo3dmE2N0M2V05BYjRxbi9yM01p?=
 =?utf-8?B?K1FBK0VzbWlUTjB3a2RyWlIyU3F2eGtMZnBZUy9xa2lOZFhINEp3Y1ZpOWQ2?=
 =?utf-8?B?aUV2cnhCdHpYT1BVcytaUG0rcnljNjRRcE51L3kvbG1leXUzNjdBeENmYTdZ?=
 =?utf-8?B?dlBiT1B6SlRMWlhqMjE4eWF3aytsaGZ5bjVYZEpmbTRIbTI4MjVGcGVIT3B3?=
 =?utf-8?B?ZnFKVFppKzFTMG9yWmtoS0lJc21EQXgvUHZCVkJoTkJ3cVd4L0Vua3AwNWpZ?=
 =?utf-8?B?OE9vSjlnNUJCdVNzK1N0ZEtuNkRBa1M1QXF3dHB5bG9mZUIxWDkza0Q5T2RN?=
 =?utf-8?B?MExHZ3RobUNCVXFuL29sSVd5TWhqYXhmMlRvUjNLbi81MjBPVWFSVVFXdzRQ?=
 =?utf-8?B?SytvQm5lQXNubTBYZ05JNDJxcm9rR2ZhM2lYQWFIOXJjU1VpeC9xYWFUd1Ux?=
 =?utf-8?B?cDZXWXpMcjd4aUpqdmo1ZmdXYkdHeC9tOWlOZ1ZmMmN1WklDaDZLOVU2QUVN?=
 =?utf-8?B?a1Z5N3A5dlB1SDhnTnFtNEhKNzVyVFFObXlkcG0wbEh0TjFlTUIzTDFtZ0pk?=
 =?utf-8?B?cS9ZN0Z2aDZLS3g2SzFpZXJnQk9iS1NzYkwvcEZabWFFcDFuVTJzTGhlODJn?=
 =?utf-8?B?cFRUdkhVb0ViZGx6S2dyUFErRWRnUGl5NXNOUko1OWp0STd3UHRicFpQdmJD?=
 =?utf-8?B?Rkt1eE1SNTRqRE5INE00bllKZGg4UTg2clAwemtFVkVObFFZSmNmV2tXaTN0?=
 =?utf-8?B?WFBIM0VIMjVVSmI4dUNnaUJJN2ZHLzFaZktEb0xocU83UGw2U3AvcTZub3VW?=
 =?utf-8?B?ZE1zUmpRbDJrT3pqdlJhdFJZbzFFTDkwbk8vRnRxejBHMmd6NkpOV0RmeTRm?=
 =?utf-8?B?MWVNdm5mNFdCYVhudDhJMy8vVDVlOXA4ZWdVc1BHYWpXMU1HclpQeEYrZzUv?=
 =?utf-8?B?L0d4dVMrbUtnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlQreTJQR01sNFROalorcjZJbVZEYmxlZU1DbGxyR3JzeUdhYlVqaWxjc0pR?=
 =?utf-8?B?TCswamVQTURVTHRYR1pMbllRRzduU2ovZDdwelRUOENCUmM2UHovRDRrNmR1?=
 =?utf-8?B?TE9YVWdrZEI4bXRpTFZSa0RQMDVsQnJmaTBORS90bEpuT2lvVUF2RS8zUWVj?=
 =?utf-8?B?M0tGdCtONEN1a3hocFk1YnNNbDBudllpbFRLTXg2UUlPbXdkYSsxQ3d0ZHJj?=
 =?utf-8?B?ZVZCekF1K1M2eW56V1ZmVkh0WG1ZWUtpOE8xTjEvTnE1VjQvZk91Sy9FSGlh?=
 =?utf-8?B?K0U2ZC81NXpab0tiZW5JWVBOQzM5SHF3SVBIcjR0b0ZRNm1WWXFSL0FHWi9I?=
 =?utf-8?B?eTcwWXZNcjRvOVFraGJwczZrM0ErNjkvTWVEaWNLV053QUpFNmcxUHVCS2xx?=
 =?utf-8?B?aFFJN2R6OFUwNk04ZjNKaUlkQUJJcytxVkN4SzZqTng5K2xudlJVbk8yT3BT?=
 =?utf-8?B?aTBPWXdwa3hsZDhqZXFOOXlPck4xTVYwSE54YnVoOTV0TW1majZmSUhHMkIv?=
 =?utf-8?B?WC8rbzlyMTlBK2d1T0RkbWU2Z3RvUEZlUkw2ZCtKWmMyeEhZTnJIVFA1YXZl?=
 =?utf-8?B?bEV4clVtOHVYcUVjZ1FacUJzRUE1QUJIOFdLb0FEM002RDVhMXJjZ3Z4dEU0?=
 =?utf-8?B?VmV5TUhJVnJaMy9sY0w5SlJTVDBoZzU0VllxTTc1NGlybVZkdExBdmp4RFpN?=
 =?utf-8?B?bGRNRVZZbXN4TjBONHdVZUlUNlYzeUNsTGRVRDdTenJwY2hoZHl4cm9PVGJa?=
 =?utf-8?B?TTJTU3Vsak5FaEI3enpBTEtxVHcwSWZEOWk3TS9oMHA5OVVXcnpSNENHM1NX?=
 =?utf-8?B?cC84MVJ5OVFtNm1QREZWcEdqb1U3T1JWWWYya1l5Q21PdDRFczEvMVhKd1JT?=
 =?utf-8?B?dk15UTRGZ1J5TnMwWkw0N20xQnpVU1pTaFp1Qnl2STNYWUxvTWhTQWNIWnZ1?=
 =?utf-8?B?aVBueVY4TysvT0pzaXZxaU9jZTNTSTdzMVhsVFhrSkx6T2dzd2VaOWhsWjBB?=
 =?utf-8?B?dU5YT1ZBQWJmOTl3bWwvSUVNL2RnS2xoWEFnODJaNEV5WDhPeWtsZGhXZity?=
 =?utf-8?B?ZUZtZHFxMHNlMWlBYUJ6WmxzUnhlTFN1YWdUSUJSQTdWZXRxdS9ydzM2ZjBk?=
 =?utf-8?B?SGZhVFVjc1l2OEE2dFY4YkN2RlFUM00wVkNLZThBcXN1ekdmV0pydlBTbCtp?=
 =?utf-8?B?NDZ3cHBtSkdzRFpSa3dhc0dPSkQ3eEkydmMraWlNajZQVjEzeWdwSDQyV2Na?=
 =?utf-8?B?OG53dmwzWGR1OTFGWVdrVk9MK2IrYTdTYk1OanJkMkJXcjV4TUhkTkh0Kzc4?=
 =?utf-8?B?anBwcmVNWG0xNExMbzhmdjRIZTJzTzZ1ZHlzV2JpUmQydG1MclNCbVBjeXJF?=
 =?utf-8?B?Y3dMS1NkNzAwTktOUkQ5dG9zaVFVUUhMbW10VmR5OVp5M2R1c1VpZkVGQjEy?=
 =?utf-8?B?akZBcVcrZThneTU3WkFjRXQ5S1BoelZnNGR2TWF2S1BqdGdDZWRHb0FMMW9z?=
 =?utf-8?B?TjViYndENUFhRmFDendxMmYvbURaMnBEa0hxdGtoVllpVHZxSktnOU1keU9s?=
 =?utf-8?B?UDd1c3pBRTh1VlZFT3hlUlJiSThWVlcwWVpQQlZnL3NNWDM0UzFxNWMxeGFD?=
 =?utf-8?B?NmlRQXN2VEg4cGprbFVVSWdIeFVLZmlBdkg1NVJHWXI4KzRITGZFZFdwaUJl?=
 =?utf-8?B?cHhlV3dGUnAydS85VUNIYlNVMU95cEtmbWNZNXByMHlSeXFjdUxuQnpCUk50?=
 =?utf-8?B?Y0hMWTRESTl5dS8rQTd2bkpKdEljS2xCZmhNOVFBUVRGK205b0F2Rm1ub0Ir?=
 =?utf-8?B?SkhtdHUzdlFZWjYxVUVFVm9hMFNYOWxnYUloSTlnVHZjSTBpbGFVajg2YlZO?=
 =?utf-8?B?N0xzYjJ4bTROa1RCSzBXbEFPUEpkeUdwYXQzcGNlZWwxOVhmSGs1UkNYWE9o?=
 =?utf-8?B?SnBXWENWYkozNEZCRHJRaS9rZDdPWGFyRFdUdlE4ZVhIRGYrcTNFSEpmOENk?=
 =?utf-8?B?YVE0WFIwN05LS0FtVmRGc3FEUUdKTnQ1WCtsbW5VcldHOXFFUkZpUnF1UGJO?=
 =?utf-8?B?clA3ak5jSHE1anZUZEtCUHdhTkU4UmdKeUFYMnplNGR6dGJRTHlnY0N1RC9o?=
 =?utf-8?Q?ZEwpgXNNgdpZGo6NpZdrgr9UZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oPC7Z2OQLrOfUVpqkrXmA8zu8Z0qX0BLtn2MNAfsUjYerYx6kTkWo5kaj/c/deHmuDZS9WitGsmxxlgMOv54dycZ49N5nGuf4DKjRVplQIyY8TVIjbH7K7+7EOvjzLgvRDT6iaFrSMD2RaEPH4QwNORIz3vlr0hWirCY53NO7z3cOsWrejJonNluvdTMN5XqzNEgoCMFHlmEr38c+CfyQLeC0xNtbvqJcdBMSUWvoy7CXJKTadMxi4lx5dpz3fnUH5NaMa4u0+E4q2VRmA+oUJrP3IQlm+D3WLYgshirGI4UjLz6YDI1FmkMWWdXIFDv4W1RZAqlj6wEBoyLGFlvE4w3cu2BiMm05nQK/XIyXKi/qFHUCwCVZwpuhgjkSLf68aXVtmrlMhj8Gi+r677iX8/WjHTG0oLmJQleyfFLLzScd9mvWJoS1AJpna7ZR4VJ0149LrlO+5sHJFS/5hUFyIf9/VW3iwASEcNa/pBzEKxe/2p2e8mXIXUzUiiEyEpHhWD1864qmtHEcA3rmooD6l8w3IREPyW/AaOzsbIxOTL/MeXTVwUqBTUSkZ4V657WyfrR6qUwQ6p18tr4XsGCrwK9wqINw7E9qx19z7pzsKI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 534e77aa-2a96-4cd9-fcfc-08de0cb538a7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 13:09:21.6194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SdgVnq/cbowVa61rjS+KGzQvtq8UVmI1RG0o9eDUMWlVliJcjGONLacScK4AU0S7qDqLONj5QLjeRoHnw3dnZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5837
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510160098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNiBTYWx0ZWRfX1FMD14adN+zK
 y2p+3ljBJ5FVbg2A1opeuoxjwb3vV6JPgDjf3NltT9EuO6Jj5hkdQQWyHxotuUqX3zHgKNjrVMZ
 MSHi8aOc4Uvc6CG2FJXnztUc0hvM3xy91crGvdR6kIeOCwnSUzt2bd0+HtYeIyvZlXi7cqOQ2qv
 +wyCvD+WSzZ5G5VbyBTtFd5KX8ReoA6NoAvHeFjzyIkMSdYm9tBgPD/zPAiFvzcR8PPvG3SdGRu
 Qyi23IeTDFcOhycQT3k40Xb/hmI1yAN7VOJKgGnF/S+vFdcnmtxNI5xcaAfNW0rPL7Rt+s9leUl
 Uw4mqH9F6tIc+JJmQgpoOG9tYv+cN5lVEEnshJtsOPZkFfr/tqQXQ37kOzSsKRVm6j0ij84Nwxn
 5ANkrdHlOn4zksTIgTn0xe4gi5C63jFP5sxoTG0J5S9v8M03whs=
X-Proofpoint-GUID: eXyIDZoXiuCrcsqdAHWSWUPFtlmaqYPT
X-Authority-Analysis: v=2.4 cv=ReCdyltv c=1 sm=1 tr=0 ts=68f0ee85 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=d7NRWt85ZsWhMf6-aKsA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12091
X-Proofpoint-ORIG-GUID: eXyIDZoXiuCrcsqdAHWSWUPFtlmaqYPT
X-Rspamd-Server: rspam01
X-Stat-Signature: 89wgok9gsbjogikco9bpsscqczr6mxm5
X-Rspam-User: 
X-Rspamd-Queue-Id: EE5264000D
X-HE-Tag: 1760620170-205544
X-HE-Meta: U2FsdGVkX1+Bwf1BF62Q2egReNy0+j7qf8VZH/kVurntGRl6TU3bhTR+SeVo7AGJscXWMZyHg1ryLKyfVY5jsT+ZE9XQ62K1VTZnsqvqtQp1ndzr9bcWxtIvn6s05kxWjcu7H+lMp11KuPoOklBr7omOuPqRmfHqvQd2OCnphG6Jv9EJIODVlPjdk6KXVeJ2iao/YlYB3Fw64zIaoPJGb4PROSXQMNOnwpTdHhTfeXmUZr+bdYv6+/pecvaOwxaZDOW8LsITR7ADFhLAw8Va2iqGB0DKGlFzmxq8G9SNQLakfHzT+nQpwyZHDG5euPHR2EscvsGnPtu4aIaUqICxU6Y3Z3VoKohtef1pXsWAJCAwtWt953Pc+mv+BkzfdKIuKMUqBFGVDLv7aO7XYSfG7RQcWaNT67gAx0Y8HYic4Lf/JJQr65sMFRyS2Y3mI/hPOHfVwjswxyCVbPAy5ezI9hz/HiBWZXQv+hOzYpND+6WKw6jfIlV1uoc+11LvKPl7Qq14/vczS8xvRYxkuD5kT9Z5j6J6pxARgOMhup82NBZ0Cv3nWT9fSShRL35Fjqd0YCDGEvnnYpGCW6kmAPlOGyujqlZi1PHcx2rWKYurv/kvSbbn+kFHxGclWHtc5fAW57Tfq2mbS8f07Sr4LwbDKliUBmePw24FWok+7nGcR/RV5Po7wdNImYbK/ziOFJlaABt0Zj5tUzNq2jEse+XCs9YAf/ew6Rl0HThZVlI1SXUlNs6CsM7olKtkG7QAd+CG/i00uRxXGCQZ/vBn8Y8Gn3Ng1CDIMYQzMtw5kkDua8oR5ER71AeRVSpZ6v2pQXGEP7/gufhw9swzQvSf72uPxlpa70YgRjdtSbMz8ziUwpuC9NWFZM3Cu4OD3KM1r9/V63ouHOHAD5WcYGviIpQXJyDBjM6qcsp2FManww79VO6ttrInL15flEg5NUPrYW4RxP6JWBGmotzqrBOMySn
 QRpZ5SNe
 NBCFFuK/zQIOwGl1CAicgjCgGarD7Y6qpmJTrXrwk1V7yK0uHqyHi/KYV1j7s9HR6TxCorJ8iIQkYZh3j3Pht8CugBfGk+YHRk/fDyx1WVChGQOrrp0QcNG9zT52pfSosXmZf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 06:44:38PM +0200, Vlastimil Babka wrote:
> On 10/15/25 18:29, Suren Baghdasaryan wrote:
> > On Wed, Oct 15, 2025 at 7:17 AM Hao Ge <hao.ge@linux.dev> wrote:
> >>
> >> From: Hao Ge <gehao@kylinos.cn>
> >>
> >> If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
> >> But we did not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAIL and
> >> MEMCG_DATA_OBJEXTS currently share the same bit position, during the
> >> release of the associated folio, a VM_BUG_ON_FOLIO() check in
> >> folio_memcg_kmem() is triggered because it was mistakenly assumed that
> >> a valid folio->memcg_data was not cleared before freeing the folio.
> >>
> >> When freeing a slab, we clear slab->obj_exts and reset it to 0
> >> if the obj_ext array has been successfully allocated.
> >> So let's reset slab->obj_exts to 0 when freeing a slab if
> >> the obj_ext array allocated fail to allow them to be returned
> >> to the buddy system more smoothly.
> >>
> >> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> >> ---
> >> v5: Adopt the simpler solution proposed by Vlastimil;
> >>     Many thanks to him
> 
> I've massaged the commit log and comments a bit and also realized that
> AFAICS we're actually fixing an issue that predates 7612833192d5 ("slab:
> Reuse first bit for OBJEXTS_ALLOC_FAIL"). Am I wrong?

You're not wrong!

> ----8<----
> From 8151384e5baf34db5812ed51e2e463796ab6e973 Mon Sep 17 00:00:00 2001
> From: Hao Ge <gehao@kylinos.cn>
> Date: Wed, 15 Oct 2025 22:16:42 +0800
> Subject: [PATCH] slab: reset slab->obj_ext when freeing and it is
>  OBJEXTS_ALLOC_FAIL
> 
> If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
> But we do not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAIL and
> MEMCG_DATA_OBJEXTS currently share the same bit position, during the
> release of the associated folio,

> a VM_BUG_ON_FOLIO() check in
> folio_memcg_kmem() is triggered because it was mistakenly assumed that
> a valid folio->memcg_data was not cleared before freeing the folio.

nit: maybe this can be massaged as "a VM_BUG_ON_FOLIO() check in folio_memcg_kmem()
is triggered because the OBJEXTS_ALLOC_FAIL flag was not cleared,
causing it to be interpreted as a kmem folio (non-slab) with
MEMCG_OBJEXTS_DATA flag set, which is invalid because MEMCG_OBJEXTS_DATA
is supposed to be set only on slabs."

> Another problem that predates sharing the OBJEXTS_ALLOC_FAIL and
> MEMCG_DATA_OBJEXTS bits is that on configurations with
> is_check_pages_enabled(), the non-cleared bit in page->memcg_data will
> trigger a free_page_is_bad() failure "page still charged to cgroup"
>
> When freeing a slab, we clear slab->obj_exts if the obj_ext array has
> been successfully allocated. So let's clear it also when the allocation
> has failed.
> 
> Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
> Link: https://lore.kernel.org/all/20251015141642.700170-1-hao.ge@linux.dev/
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

>  mm/slub.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 13ae4491136a..a8fcc7e6f25a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2170,8 +2170,15 @@ static inline void free_slab_obj_exts(struct slab *slab)
>  	struct slabobj_ext *obj_exts;
>  
>  	obj_exts = slab_obj_exts(slab);
> -	if (!obj_exts)
> +	if (!obj_exts) {
> +		/*
> +		 * If obj_exts allocation failed, slab->obj_exts is set to
> +		 * OBJEXTS_ALLOC_FAIL. In this case, we end up here and should
> +		 * clear the flag.
> +		 */
> +		slab->obj_exts = 0;
>  		return;
> +	}
>  
>  	/*
>  	 * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
> -- 
> 2.51.0

