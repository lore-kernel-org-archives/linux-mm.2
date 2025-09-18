Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB881CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA11280039; Thu, 18 Sep 2025 11:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9AEA8E00F6; Thu, 18 Sep 2025 11:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D15DE280039; Thu, 18 Sep 2025 11:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8D218E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:29:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 592ABC0246
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:29:35 +0000 (UTC)
X-FDA: 83902755510.08.490BBD7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 09FFF12000E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:29:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lMcIuhQm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HaGEH1y0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758209372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIrZ/EzdpYEyCJIX9/pJD8GHVkt9YhpsPfIRn4YyriU=;
	b=5jL0bRYzKGZkpxvQ4CsX3VlbJnuU663ehkNd5AY0Dxn4E2PhJb61dB9xetz0wZPDdYMVi4
	Oixr7cWIeo4uFVFh3wkwFEcczev35v5fY5/MME7OE5iNdtBbQQIbhKcTLU6nFo1482yiX9
	2TEFCcasvoWExtcDbppM48PTBw06sg0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758209372; a=rsa-sha256;
	cv=pass;
	b=tEPaGvDK1NjFDGKwn4Xjm4Ke8iw3mEqmK0qjJp0T1q1kfycRx11xvuf/YbHTo5t+mDpzks
	Y7v2MqFrlc5FSaXhzMTzC0Uz+jIvGynjl0ZlxRl+28I1ay+8wZaaNNZZpZ9ZofKCINZX/D
	luci2eGIZmjbpIERjntzADe9SFT8Hfg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lMcIuhQm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HaGEH1y0;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7gqxU019440;
	Thu, 18 Sep 2025 15:29:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pIrZ/EzdpYEyCJIX9/pJD8GHVkt9YhpsPfIRn4YyriU=; b=
	lMcIuhQmB8cKZ74El4SZad+8s0iyMkdxgfFFyK9EANTZcbObA6/rgWKFflYfp/RT
	Vg5luR02JRAe4f4nTxrF9qszap7uW6KriUReCmhwzHo3CIjgp0klsTiNCS+Q96Ho
	QmIDl8172e64meGkYCYHqAC2kJboxELnixu2AC5uW9ipEZcRLZuIJRJdH89zLsgh
	1cVBd2mLqqswHkBOMCQsVfCbCTXc1OeX2yhQvOwsHe50P/ywLSxOqRpvVMcNtX5H
	nQr5fbxB9ShysT5rCQu9FWyZDyCDVawpKJQYc82DGbQDI2rVulUPGX1msrKjJmFW
	fVbh/AmUPuzDDvLxXpVWmQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx6krhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 15:29:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58IERXKc033739;
	Thu, 18 Sep 2025 15:29:22 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011037.outbound.protection.outlook.com [40.93.194.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2f8dvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 15:29:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z2wkjiFQXskpA74CjTz744+znI4ieHeMqdZjeI1ehbA0/aB09/E+TChe568xTWXV2D9Prf9f9ITyK01Xqs9cs8/tP+zJjb68IA/1RZTI/BO63xFNC//52NHE+FH2ApCBm97MSDS95KrlrV0dqf4YYuWaFEs+oQ2Y6JaHKXGgAUmReDxhjYc30ELse1vtnud9Ui4nNhWJNXrtKnsZU92gqbQlu3GpmAmf+qdPos6/3MrAWu9jqLVRA/VerZ8cT7zw1WaLAYYOGem+0hBDesMq5qC1W3c8O16n9AABnJuKOx0XUsHyaeO+WRl2FcYqh6QySrnKlvhLXIqWXnMbpIKesg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIrZ/EzdpYEyCJIX9/pJD8GHVkt9YhpsPfIRn4YyriU=;
 b=V2J8MKdvmh7KJAwYjbmeH80qxl5t85457pGUSzFD4pNlzPyWUB7M9vXcIBWa9UrWYt+nn1iVJQEMMyqqIKrdXtAviNZ54U00Lx2bG2EvBeZVXWrjIRR/R1l4JQV2IiDywBSITpFCK4H0AlE8zCn08+c2wzojRuCHptHrnX16ojhTdXTdSGzS10cYWxoTJaZCrAwPUwBR/IgrWuaslGl8IGR8VEEnubDFEJFeQKc7Eq24u82oQaN4tVTjIao/v6gt/69f0QDMJDyBXrpjVN5ZoKPrl/Rxebf8TJdgWIjTYPxuKY2ynuUb242LOSlKu6f2KJzcUFK9y1eL2Yd8aASRPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIrZ/EzdpYEyCJIX9/pJD8GHVkt9YhpsPfIRn4YyriU=;
 b=HaGEH1y0Bhs76tbxQtw/V95tDuoF1ZBO5gTBjD8jopo1l9+ei/qJM0gOJUFx8H0mHVupdgQYw/6Cc/uPhNvXPbmBQTi9iqzahX254cZh2Yn2RAliph4RbAcXYV/7kgP4Fl/QMtz1vk+RfG08pVHtD/SR6+eX1XYlymtTlBypq94=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB6649.namprd10.prod.outlook.com (2603:10b6:510:208::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Thu, 18 Sep
 2025 15:29:18 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9115.022; Thu, 18 Sep 2025
 15:29:18 +0000
Date: Thu, 18 Sep 2025 11:29:14 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        paulmck@kernel.org, Jan Engelhardt <ej@inai.de>,
        Sudarsan Mahendran <sudarsanm@google.com>, cl@gentwo.org,
        harry.yoo@oracle.com, howlett@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, maple-tree@lists.infradead.org,
        rcu@vger.kernel.org, rientjes@google.com, roman.gushchin@linux.dev
Subject: Re: Benchmarking [PATCH v5 00/14] SLUB percpu sheaves
Message-ID: <vhp6cqq6gx5xgs2ueo7az4wobs2rddjsucjwlxckx3us3p3pey@s62u2ruxkjw7>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, paulmck@kernel.org, Jan Engelhardt <ej@inai.de>, 
	Sudarsan Mahendran <sudarsanm@google.com>, cl@gentwo.org, harry.yoo@oracle.com, howlett@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, maple-tree@lists.infradead.org, 
	rcu@vger.kernel.org, rientjes@google.com, roman.gushchin@linux.dev
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250913000935.1021068-1-sudarsanm@google.com>
 <qs3967pq-4nq7-67pq-2025-r7259o0s52p4@vanv.qr>
 <f5792407-d2b9-42b3-bc85-ed14eac945ec@paulmck-laptop>
 <d1ef1cbb-c18d-4da6-b56b-342e86dca525@suse.cz>
 <CAJuCfpEQ=RUgcAvRzE5jRrhhFpkm8E2PpBK9e9GhK26ZaJQt=Q@mail.gmail.com>
 <aMpE-oSjtlDU4TSl@pc636>
 <CAJuCfpHQ_JedSRHKKoYXyVzaFOm=dDWzgFZwqerfEC1fn35j0w@mail.gmail.com>
 <CAJuCfpE48n=QM0nY8yE3drqZU0wgC76=70EyftL1WZewEcykyA@mail.gmail.com>
 <aMvx9GKgIWtrkZ_R@milan>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <aMvx9GKgIWtrkZ_R@milan>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0434.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f496c17-7e91-45b2-ef4a-08ddf6c82218
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUVQZEg2ZnpVYjQvSUpwRnBPL0EvOGJBOUtQcjV4T1U3ZEh0N2c2eXYxUEZ2?=
 =?utf-8?B?M1RVRXJnb2p2NWw5dHFRKy9haEM0U2hPNGU2M2NVd29GSFNkVEQvU3ZmeFF1?=
 =?utf-8?B?cnlZdkMxK1BsWGdoUzNoM2hFQlFnUGpyRWVmUmJLbk1VdzBEKzJRTjRKNlU5?=
 =?utf-8?B?cHJ6a2plTHdURDROKzVUYVBwenZVWVZIQU9ldHV5RFc5dWNGOWZLMlU2OHZH?=
 =?utf-8?B?bGFyaGlLVUtESkhPblpzYi9yVWl5QkF0bzl5dlNiYlBIZXZ6ZHFmZ2ZZM2Z4?=
 =?utf-8?B?Z1hLYjc2TWZhOUdpRDVqTlF4OW01OUNUbTVHcmNVakJFME9MODBCeVNKM09F?=
 =?utf-8?B?UU83OWJhYTBqRmVCZzZLV2E5VlMrUW1DcnNoelg5aDA2SEQwNmhkM1RCenhy?=
 =?utf-8?B?bmZ6ejZpcWhOTkwxU0M1Znl3R05kOVE2VnVtQithV1h6OUx3RHNaTkd4c0xW?=
 =?utf-8?B?V3pranhTZzR5VGVma1RFc2dmd2FhWmFrY3RWNmRBSHl4aXdOSjZBd1Z4Skdm?=
 =?utf-8?B?MXJQeGhiT3BnMmZTQUwwTnhEWVR1QlZoZkMrR2J3N3U3MnNzN0NQdFowdnJM?=
 =?utf-8?B?a0hzSnAvcUZnVmdxcWdPbWxRcm5aK00zb09oS3VLNVJiNnNzd3pGWStyZzRl?=
 =?utf-8?B?QWNYdE0rQkdNRHI4dGFjL1VKUkc3eU1CakluOGdWVWkreWRJQjBSRTd5bDNl?=
 =?utf-8?B?VmwvWDF6aldwUkNrS0pkL2J3b3RVUzVIVWI1TEVFSTNzcE9udE9ia3p0ZDVj?=
 =?utf-8?B?WlBZZzVlWlhwM3owQlFMekVHZ3lpUWlEalVGenpGUVdXakQwcDZkeDVCMndO?=
 =?utf-8?B?SE5idTYxQ0pOdjRSdWJIL0llUnA4TVZvcEFvTmlpZmp6UlFiTEdqZVhjNHBL?=
 =?utf-8?B?Smd1RU90aE5lVlpUUWlhZ29YU2RzMnh2bnBPNHByRVd6VzlIL1YwV25jd3Ex?=
 =?utf-8?B?QVNyTUtWeUJtaXNDS1crVmFmSFBQZmZJUEFwVEVKOUtLNmhrVWFDRE5aTW5u?=
 =?utf-8?B?RzhIcTV3TTNHbUdmajlFYi8wNy9KVWM5aHlVL2hHVE1XUWJZd1pibnltV1VZ?=
 =?utf-8?B?aVY3bU5SNjBKUWp3UTF0dTdnb3hPbWxTVVlKaDRqSk1KZkVPbm9pM1A3UDNO?=
 =?utf-8?B?UTRUQXc5Y2NqYllyMHpaUW9CVDBXY3NMUFhXWXdnUzR5S1l1TWpRNlgwQVhK?=
 =?utf-8?B?RlBHenl6VzNWM1JvdFoxcE4zdDRtVW1ZNmh3TWJvSGpZMVpHczFPM2d6emN2?=
 =?utf-8?B?QWRwZjlXVGczQXhsR1d1WHBGUDV0RHhBeXB2SXBqWlZqWk9odTl3Qmd6WGJj?=
 =?utf-8?B?R0Q0dHVtRzJHdnRXT250d3R5QkprdjdwSmoxQ3VlUW5TUjNRYXN2SFc5a2tK?=
 =?utf-8?B?MU5nSnZBNXdlMXdhMENvbVpUKzZKM1I3SGg5Y2x0WmQwZ1RHN01HbFFxQTcv?=
 =?utf-8?B?R3RFVWx0ME4yMUF0bzU4bHFqbUZZNzFZeFBTeU9Kb2YrWDI1VXQ3MGdCeWVC?=
 =?utf-8?B?RW5UWnVRNDZxbmh3aC9nODV2ekFVRVdwc3h4cDJNRW5oanY3eC9yTGpBUWhl?=
 =?utf-8?B?RUxRbHN0Witkd2xodHMvbzd6SzliWkoyS21KNUlha1lmSlhCUWgwQ3IwR2la?=
 =?utf-8?B?YUU5eXFqcjlQUGNpSDRab0JKdTdZOFkrWDhSTW4yTnhKTDN6NG9TQzRwZzhm?=
 =?utf-8?B?S2s2ZU1LWHZqTlViRm5nSWdidTlkTU9nNGF5NFNibWRXY2ZwZjFVUnFqdDJ5?=
 =?utf-8?B?RHRha3kzdElpM1JuczJFd2FWQTdiVnFWazVOSXNoaGJVdDZVcjc4VXZqR0hM?=
 =?utf-8?B?cGlxeCtlM2l3QXNrdHRYbVdJcXMyM0ZQUUNycUQxeUJxeWdmdFlzanpwRldB?=
 =?utf-8?B?Wm5JOWJrZHk1emVNR3kvaUFrQVlpNFB3RDhIMlRQZFUwd0IwYTNqbk50YVlG?=
 =?utf-8?Q?Ubg0IAd8T6E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3o2cWt1SDdzZVNxSU95cVVIdWhkcHFQc29GcDdJdEppQWR1STVwTUVHZTZt?=
 =?utf-8?B?NUNCVmxCalFUaUJ2Um5BU21tZkNvajdqVEJDOExoZDBLdFZHQzZ5a2tITW5X?=
 =?utf-8?B?eGt2L2ttc0VpV0NsZDFBbkNIYkZ3VWhYdjZFMndTZXlYTVUzSkhaM2F5aTA2?=
 =?utf-8?B?aHp4T3MzcWJxVUVMeGdPVnFwazE0em1XQ0RQRnF5Qk0xb1hCYnFEWFRNL2lT?=
 =?utf-8?B?QTdpR2VOTTByRVBxZTVMaHF2UGxFdVBpSjQzQmpnVEw1YyswTWVVWjJYU2Mr?=
 =?utf-8?B?eEplUDRIVGY3cFcxSXZZMTNIMVlDWXNMVTE1VkdPd1oraW9RMk1xWWM4cnlS?=
 =?utf-8?B?OFNFOWhLeU44NnZuc3hIelVUWWFRckc5SmJ1TjFwcDVzQWVOTnk4cGJ0SUZk?=
 =?utf-8?B?bUxnNGpQSzlZRm9QMUNWb0o3aUFSS01xYitXR2tkK1pUYVRhWHlNS0E3clBU?=
 =?utf-8?B?eDZkTmczTUM0bXdidTE2TW5sa01LSnRoRWU5WE9Gb0dXOWU3ano4WDc3bnZj?=
 =?utf-8?B?eFFDNDlvNmFnLzVxd1ZydnA2L2R5WDREZ2pDcUdiMWdaMHN1aVlZc0VWVmU0?=
 =?utf-8?B?MS9uTHo2bEFvWm1BV2VBL3B3OC95Wk41SUxYeWN3aXlLNFdSSTRsMVBGZi9R?=
 =?utf-8?B?c2JSNjhxQzBSRmpoc1IrSGdEQ3RsZkZtcmVRR0g1RkplaHZ4UC9UcEdqemdW?=
 =?utf-8?B?aTR3VXhDbnh1YUhoS000dWhTWURJUitLU3lqOHJJSmtXdWJ3WlEzZDBSaGRQ?=
 =?utf-8?B?U2s4bVM2Tng3K3FHNTZlOWtuQ1JJczFEUjBVY3Q3UkpCRTNmWjF5Ky9yWEc3?=
 =?utf-8?B?cU9sNkIybG44VWVBZ3NDekdEbDRnd0lmMFBkQkRmMit3S1VCRmhTOXE5TEIv?=
 =?utf-8?B?K2dsUDE2VDlwSTRvSno5cysvY2JidWUwdkNoZS9EMEdLTHlFYmIwd0hqQnZH?=
 =?utf-8?B?S0RRZDI0WlJuMGFzQXNaS3NaTXkxdWxxOVBUcE5mb1lBSldmcGUyV05SeUJB?=
 =?utf-8?B?WjJ6VG9mZ01tUUptK0JmZnE2ZXdwWml3S1lIaXJQenR6eXR3cnB0K0dFZ08v?=
 =?utf-8?B?QVJXZU91cDRiUmQybWE3WWUrNjc5MzRuZzE1MWZrcFBpZ0tWZTBXcHdTL0tl?=
 =?utf-8?B?TkNsbENkNjBya1FtQ2Qrb3NKY2hBQWtFbUluOXQrTTlvMUZ4Y0NTbEpGcGtV?=
 =?utf-8?B?aWxPMnBtVjcvK1VPNU9YVnFhOFZiU2k5Sm55LzhyTUxDa25LbXdBMzV1ZHFW?=
 =?utf-8?B?QjNIanpqV0lMUXZRZ2dVWGZoOUxhaFRmRWJIMERwY1VOTmhSWDRtV3VUSS9o?=
 =?utf-8?B?SDIzeUlReHQrb1FNZUtCeXlETzk1Q1NhSFFacWhLYUZ3KzdQZm9pak1GbjBK?=
 =?utf-8?B?TG5keEgwUHNwRmdkT05TRU1PYnU1clZPb3VrcE16VjFWcGtxK1RGWVlEcUdY?=
 =?utf-8?B?dGlNbXVKajJrdXJ1U21ZT0lwSGdndkJXSXBaYjN3bWVGRjNNZmVRcTFUQ0ta?=
 =?utf-8?B?czBXZWNpdkF1NzZtOGxDWHFxeVlzOWNiSTdyNTFTUE44cnV4WTBBT0srYmtL?=
 =?utf-8?B?NFNIRC8zRU9Obmx6eE8ya0k2eUhjTHdwVFZpZFdqbWgxanQ1N0ZLVmg1Sk5V?=
 =?utf-8?B?YmZPMHVQTjNUTGtGL1drdjI0dVluT2hyV0prbTNBeTNERk5JYVFYc1NTdml0?=
 =?utf-8?B?VGNrOXI4UGhlOW1JTnpZcU0yMUlDbFY1R2NKZENYRFRhMklXMHZzVUVKbUlv?=
 =?utf-8?B?UW5WZGlKZmdIK2xqclB3bFVVZmk1NkNsVzd0L2FnR0poMGQ2czBMN0MvYVJN?=
 =?utf-8?B?MVhuVHNEU1hNemhVUHNvNjR1QnYveklBdC9Pbzk2MXNOTVF4RlFveUttSDJS?=
 =?utf-8?B?WEx6aVc2NmFBeEMyVjRrZnFJUlp5WFVFRUNJSlRqbStFV0Y1Y0FjZEt0T0xF?=
 =?utf-8?B?b3dnWmJwc3ZaOXJvbUZEaFppRjMvOW50NU80UVNBNmh2L1k1SkZOSWc4emFt?=
 =?utf-8?B?SDdlVzhmcEdUL2NZd3psdTRJYVZUaWVQU1crWTRkK0FZYTdaVnduOTlneTJP?=
 =?utf-8?B?SzJkTEl1bm1kcjFIbFQ5N3pvbXo3ek9NazFlaEllREkrMGNsME5sWmJ2NXp2?=
 =?utf-8?Q?NVr6Az1e1J6dyUdF/SxLvPzOg?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WXmvfDs4rQxppGgTUxkkZGIM+etNGsHskHNpYW1dQ6O7SsIXrGm9rVvmnDrWMR564ncM+H24BL570Zqa0M7C/nQ1qpVTnTj/WyewmD1ldU5GUrU4iPAsad+d3/4Jg803DU7sfTmSJCYj6YAyueTiwLXG0t8tIs5wYQVJba2UV7jJJR+IBzWSp75v9TgtaR05QqjdvYIK1GdcZjil+OSOjXfeJFKPhRDgLg24K3s4d4B5Zr2lFQj76VRcxz7z7qrDNclqFkG229FJYAN6xCP1Lzm9ozfW0jp4fLMcWkzEQn7LkzdZyEAhhvDZ8xyUmYAnTFd999DT3R6j9CFCE0SYmTh0KXQPoLb0gM4wZrUCgif0MOb9qWvici6vVbOc6NVktudbPOl9bvIUFo0CpQ6OEU6wIyqeRB2UAxWqWnJen9mrlDuLWOyHAheu5Acd58q/LxZzqFxuLdJoKCJidrn56LZUsh72FXhor3aB7AUM9XNZ55zJUU5860SE7ZzJt3JpbYt5PIgnAzZVesW5ZxkN5jb2ZURnxvOj9ZjZPne1JUXwKTT4u4zp8sVhNCTxOf0y324bkWjir4la/hADAZhLW+lGsfdt53kx/mKigCeju9g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f496c17-7e91-45b2-ef4a-08ddf6c82218
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 15:29:18.5529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qY0eoHtCLWafYkAhv+VylMpiih7o+d8iV/PPXdazdRPUKpD5JPg7ss9LV1c01F8FTv8BLIGo+8I6avesPQVvsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180136
X-Authority-Analysis: v=2.4 cv=TqbmhCXh c=1 sm=1 tr=0 ts=68cc2553 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=1XWaLZrsAAAA:8
 a=Q1qIeLTNnsjay0MUresA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: UQ45rOqV3Cblvgur1Ft6pTh81KfPTA73
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX4dH0X3Z0TJgZ
 ARcX4bUwYF/6Jo5K+3eKusBKRB+J0sqyj8JmY0BhXBYtwZye43O5dZu4MQOPeKvYHVT393Y2nvr
 e3Q+Vulc3jFulnciubagUfufuvjYLH2TURVMnmtHH9t7ZE91WYS0NzRfGdXwyN91MiftcWNB2WG
 v7qBg6sZ2qL0xwTAJ6D2rmchkelPSwCDBD5WY5Cj5T1ekv84gsJLoI06LhLlh+JsoTOt6T1vNOh
 82+6yaINT8pm6CkG5LmU7Y+gid4wmxGjmZtfvhKUOopQ6Xb9ws3ThCPZjhHoqGwYZmSz4VeIr5s
 wzDqLH1EPGhWEpJuOiIE1cErAC0jTEu3OnQiEqvGstynVZSV2Vqmv+xxE7HYj+MJTlSe6W2Z8RE
 le5BJAo+
X-Proofpoint-ORIG-GUID: UQ45rOqV3Cblvgur1Ft6pTh81KfPTA73
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 09FFF12000E
X-Stat-Signature: qm5w69r1bx3fbm6r8b6nfio4fziao941
X-Rspam-User: 
X-HE-Tag: 1758209371-943632
X-HE-Meta: U2FsdGVkX184/w5/n7KyTtFH75j9Qip0zkSANMVuHAs/Sjkh8p0bnIwNX1kOcgfq9Y5AsKKRY/1IztZBg0C6rFYR8cRChIZW9l6Ce/586mWHHl1bco1EyP6e129SdV7HgBb7y9CgbaHgz5XxbBEWI75RMPFkLpYZQXxzueGVaI0MdivjKDx7hooBGkFoPLccYTwS6OzrOp5dC5AeEI0WSZvzYKSLAGf3zr3EKnbLjnQ/7GOHWo+TGCfArS7hl8u/NJvTWtiULD66LtCyV5qS2HPbi9M4lkH0GD1kzPGLKYJLHjSHVTzLVmgJVFs8AUGTQMFD3CaKdVFJrAVwK7xFPB1VLrENKF2t4i/vnu2KvGD+AnJ5vRSMHx3oPZMw6gtSGrglCR3y3Se/K8W3PGG/vwAydBOdHZDMh4UtnHRCbWC5fxKQ6/3A6FoHR6iE1oTrrAWNX5ENofJrPhaFYi590iDkII36FFeIp2ste65Jfef2O63D5bqc7LwQeGBPw4INJTNLCC0PsafgnOjporV3TN4YHWK4am4kHvBvLIfF/VRAmw/p1CRH0X2yYMap/9QXkeFUUo7oMxXcV4Txoj6WJmqpZ35vy2B2hK9FaErDp4f38snQxA6+1e+b1q1/kd9kpU9VhNL6gtV0QbesQr7jEmoba3/HhQsVRmargKOazYRpCc2M9Tulu58KTHN9tBdbL2/T9OERYh3WO/0BirOA4Xom67PvQ9S2zjQjQhECMq3Y8tl/a7vaXnBHVYptNvdDOHjNJ/SyfjK/wUOURjiQqxo93qxYYCXYPIQL3fXoeilGXb/GlQdh/App+zz0gnNYGlO+oyqZ92I79SFwZfF2yZZwa/QPt8lr75tc4kHgABbpoZBMiK/ssAqNVXhIb3h2GEBr/636azCYiX6wo5IfG8xRszUVZ2Y3BzjqLaSXApmH+pZYcUh6SMAWchaHT90vXSvk369GAr5cqT9Fn2I
 3+SdSUh6
 PLe0DtdDjCS4y6SDKOOrcoTy/MDbt+u6AucjqwI30EiKov+U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Uladzislau Rezki <urezki@gmail.com> [250918 07:50]:
> On Wed, Sep 17, 2025 at 04:59:41PM -0700, Suren Baghdasaryan wrote:
> > On Wed, Sep 17, 2025 at 9:14=E2=80=AFAM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > >
> > > On Tue, Sep 16, 2025 at 10:19=E2=80=AFPM Uladzislau Rezki <urezki@gma=
il.com> wrote:
> > > >
> > > > On Tue, Sep 16, 2025 at 10:09:18AM -0700, Suren Baghdasaryan wrote:
> > > > > On Mon, Sep 15, 2025 at 8:22=E2=80=AFAM Vlastimil Babka <vbabka@s=
use.cz> wrote:
> > > > > >
> > > > > > On 9/15/25 14:13, Paul E. McKenney wrote:
> > > > > > > On Mon, Sep 15, 2025 at 09:51:25AM +0200, Jan Engelhardt wrot=
e:
> > > > > > >>
> > > > > > >> On Saturday 2025-09-13 02:09, Sudarsan Mahendran wrote:
> > > > > > >> >
> > > > > > >> >Summary of the results:
> > > > > >
> > > > > > In any case, thanks a lot for the results!
> > > > > >
> > > > > > >> >- Significant change (meaning >10% difference
> > > > > > >> >  between base and experiment) on will-it-scale
> > > > > > >> >  tests in AMD.
> > > > > > >> >
> > > > > > >> >Summary of AMD will-it-scale test changes:
> > > > > > >> >
> > > > > > >> >Number of runs : 15
> > > > > > >> >Direction      : + is good
> > > > > > >>
> > > > > > >> If STDDEV grows more than mean, there is more jitter,
> > > > > > >> which is not "good".
> > > > > > >
> > > > > > > This is true.  On the other hand, the mean grew way more in a=
bsolute
> > > > > > > terms than did STDDEV.  So might this be a reasonable tradeof=
f?
> > > > > >
> > > > > > Also I'd point out that MIN of TEST is better than MAX of BASE,=
 which means
> > > > > > there's always an improvement for this config. So jitter here m=
eans it's
> > > > > > changing between better and more better :) and not between wors=
e and (more)
> > > > > > better.
> > > > > >
> > > > > > The annoying part of course is that for other configs it's cons=
istently the
> > > > > > opposite.
> > > > >
> > > > > Hi Vlastimil,
> > > > > I ran my mmap stress test that runs 20000 cycles of mmapping 50 V=
MAs,
> > > > > faulting them in then unmapping and timing only mmap and munmap c=
alls.
> > > > > This is not a realistic scenario but works well for A/B compariso=
n.
> > > > >
> > > > > The numbers are below with sheaves showing a clear improvement:
> > > > >
> > > > > Baseline
> > > > >             avg             stdev
> > > > > mmap        2.621073        0.2525161631
> > > > > munmap      2.292965        0.008831973052
> > > > > total       4.914038        0.2572620923
> > > > >
> > > > > Sheaves
> > > > >             avg            stdev           avg_diff        stdev_=
diff
> > > > > mmap        1.561220667    0.07748897037   -40.44%        -69.31%
> > > > > munmap      2.042071       0.03603083448   -10.94%        307.96%
> > > > > total       3.603291667    0.113209047     -26.67%        -55.99%
> > > > >
> > > > Could you run your test with dropping below patch?
> > >
> > > Sure, will try later today and report.
> >=20
> > Sheaves with [04/23] patch reverted:
> >=20
> >             avg             avg_diff
> > mmap     2.143948        -18.20%
> > munmap     2.343707        2.21%
> > total     4.487655        -8.68%
> >=20
> With offloading over sheaves the mmap/munmap is faster, i assume it is
> because of same objects are reused from the sheaves after reclaim. Wherea=
s we,
> kvfree_rcu() just free them.

Sorry, I am having trouble following where you think the speed up is
coming from.

Can you clarify what you mean by offloading and reclaim in this context?

Thanks,
Liam


