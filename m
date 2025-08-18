Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365E5CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 15:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7FC8E0019; Mon, 18 Aug 2025 11:54:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99FFF8E000F; Mon, 18 Aug 2025 11:54:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8675B8E0019; Mon, 18 Aug 2025 11:54:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75F188E000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:54:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25C9D5BE3D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 15:54:46 +0000 (UTC)
X-FDA: 83790326172.29.C9AA3B6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD9971A0010
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 15:54:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MFXdvPmJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jDWN5ev4;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755532482; a=rsa-sha256;
	cv=pass;
	b=7uR/SlCs8UUV/2qP8kNvEYtfNOTlumTMYKoqIJwXeLS2mcIwLIlgVJYTynseESe+70gHLe
	F0I71y+tlAiiC/mvByDmlqLic16FFlEeKdMtWoALxKaF7Pid0BrjxzUvzD5f3G504RjStS
	za3WTPkrIaMUn2UhYaMSomFNAEqcyJA=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MFXdvPmJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jDWN5ev4;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755532482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DNwdcgR5C7z4pysrCypTqgayMXW6L/JXfTUEMPDaJkU=;
	b=UoP9UeWGloHwGqsgmEXXUtnsfHgv2mOVWGZXFA0uPMCh17mxUTNyHacy8e8wGwg3hNJzTb
	Kr9ggy0s2ViMpxAQOt6ErZ9ckB7v3DUG+MUL8NHHgo+U76YJnuyHt8GQ6JsMz51eH/o7Zj
	AjEWvvTS+Q+F79JBgqfQpMn707/0Tho=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IEtnvQ030290;
	Mon, 18 Aug 2025 15:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DNwdcgR5C7z4pysrCy
	pTqgayMXW6L/JXfTUEMPDaJkU=; b=MFXdvPmJOJnFbrot9zbfDGr93yGqi31u3Y
	OyfH8UpM+WpLdQNqo6cfhEq2D5b+eSYvsLkEp9zs+UxCiL+yYZ9hqU402NO+DQaI
	hBCQCD/JzX+AvL3ngtX0OZyh+5lFu18OwSEdNKLPpPfVi7LfiRrUZDeNsGtV2DJY
	H4JIU/GdfBCUKuaMwG3pQjbc7nkQwS0iDG2P1bww31UFGLKEAYfOU9+TxJsx51G2
	+vb6ALbaphSUrwgKT7KCsopHVgeellwhCAclSzmyghw/RZ5lnRKpS4hVnrO7uu3g
	H2cszY32bNDVLWi8vQNwNAl81EiidGX9jyIIFLQawh8PDYjkq8sA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jj1e3ejb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 15:54:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57IEuY7D003433;
	Mon, 18 Aug 2025 15:54:28 GMT
Received: from cy4pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11010054.outbound.protection.outlook.com [40.93.198.54])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jge96ax5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 15:54:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EBjip3Anhv8jwfJe/ovRO5fH7OTqBbI4apyG/p6tnOhfWT43jf1Ad4kbWwtGZ6s+OOBJYRoEZehOJghBPTyEINXlj0spOVtlzPB+JLWrgxdV6QtH52Qp7vCBilMgFKeT7vBemhM9YYOqF3CPuoCB8Hk7yPoGoeJP/38ebOjImTo0wymYv7X5OKjCGgRtiQZVIVdBimul1D8LCCFFAqYKNmDKkdPyA7OwCRzei7hO3QxGOA+ae1pqm1HdqLHkJ2vxTQewyXGSOKtlpuW7J8S+pIU88hH+j6r1v5payd3EFthSjOBnf/w2LNAD8A8mbFLCwn7JXNXqcKnS2m+hXBRNeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNwdcgR5C7z4pysrCypTqgayMXW6L/JXfTUEMPDaJkU=;
 b=aUKbq6vAJaPgNqf8q4OFMhQLV4LIGDwV9nlyOBsy9cp1JiM7uxqX8QmMcHHtp6P94UnYs8vWH81p2ZJQ7Zrrcm0mVla6ynDQ22KN+eKm5oatpVuI4baGWsvt1Vr0thRk1nH9ujSkJTPQ7H04h5ZUL3Hb5LbxcFHiYzxI7AwANN/S5GdUHpSP+nQ0L2vMiIo2QCbS1i6Qng1B9UEp6OzQqsjlAJ6/EUFdNuUTk4J9qHmL1SAv7o5au3OS8XXNsgpHd5tt9rJSii5VS/NIuneu4meJMrxZcvV/Rq/MD+MVQtvP9PHuz/Vmp5seXEKzvRCATSzmo2mErRQKVCu2XZt0Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNwdcgR5C7z4pysrCypTqgayMXW6L/JXfTUEMPDaJkU=;
 b=jDWN5ev4/QSTlXYjBlPPrwKwGlffKsMa+bUBzwxoh3aitEMUTLtiHj3RRqcO2khQPF/PPPwsmyOTs3Z/KCY+eyLymJVXrgd345ErShVcUF1Hgvzyj9jeoErEQmRbO/4Zks7buRpRlIt7UooJdnSOWaI1W0WasQBfHXDM/zGIq6s=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA0PR10MB7230.namprd10.prod.outlook.com (2603:10b6:208:403::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 15:54:25 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 15:54:25 +0000
Date: Mon, 18 Aug 2025 11:54:21 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 4/6] mm/memory: Add tree limit to free_pgtables()
Message-ID: <myuowejmixaoxdulcqdjlscdma3zagek4u7rorn3ncryvsbze4@4j75fnafe6ml>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand <david@redhat.com>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-5-Liam.Howlett@oracle.com>
 <c8f402b1-386e-4dbc-9d4d-3e5464d2ed61@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8f402b1-386e-4dbc-9d4d-3e5464d2ed61@lucifer.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0397.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::16) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA0PR10MB7230:EE_
X-MS-Office365-Filtering-Correlation-Id: a7277d0b-29af-43d6-028e-08ddde6f8175
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EWZTibJBJm0I1G5Kp5oZoubxCS8RZjZMx4im9dsQx4KSori7pYvU5r86bhWW?=
 =?us-ascii?Q?vS8CQYYze1tdl/LNUtETsaPrSMbeRFkgvrNJDAm7VGvOQCAyKW3ZXK1903i2?=
 =?us-ascii?Q?baOBNWi35TN5oDfAcvqQjN3NNuTuIgwlTktCL7bv8IhI1yZYXSiiOKFRox6z?=
 =?us-ascii?Q?FEm3g1c023LPBt9o+cKY025c0xAgL8u18kW5gzGcJeR8t5yjnDjn6px4HdNv?=
 =?us-ascii?Q?AoOisPCRZWSopvd+o/XzQbps0vSRooDK/f5KCdxdwGiob48giDNWx0iWNDSs?=
 =?us-ascii?Q?hJp29/2LZyGEnlxwJaDJ/DF5lGI3dQey2UcaS2TjOENCvFUeVDJEr1NuzzZY?=
 =?us-ascii?Q?fPi8Ze74gVngNsrGY32p4FmawHIE8VCeKB/ddShuPDqZ1xNJFAK0IWhaHZxy?=
 =?us-ascii?Q?HmBk+vDERano/5mnyaTseyWfA0kUsHnhCeS6r0YJUs8wRFyE7neFey0cjqRD?=
 =?us-ascii?Q?k9SOcvY8aA8uvnXkTpkS4Pf8YtnPrbTdriELVnCMJmrAl1cVafHrTk+VW9QF?=
 =?us-ascii?Q?vIeGEkf708yz2iZ63WdaYqd8usvkwzZSuydftlAVRjGA8I9G+30+/mmqXUgL?=
 =?us-ascii?Q?/4EXnnDSvPLdN26qNcZSwuuoXO8Y6J//Wp+6E1zs9loqKLcdO0ThYF4xUewV?=
 =?us-ascii?Q?xM9R9aCGxNEJywS2vNwM0vQD/GU39iGDuynv6OdDGiHzxF1oHAfSPvw6h2Si?=
 =?us-ascii?Q?qv2kAXgpIdBxVI7TGNe6ld/s0EFBKPGUVGlb49o0hnXFGgNgrDxdxQiQ1CUJ?=
 =?us-ascii?Q?TSOje9CNlMwIJ2F9gXjVSyyj+ByU4ijqa7nLxwFa23zvrS+Y4BeiLS2vsm2M?=
 =?us-ascii?Q?+EiOgAWHw/SeMb/E/5Ky1OdVS2sXjKaAFUUqwwLWV0Xsu3MiruYEyZG+xQ9A?=
 =?us-ascii?Q?s2P0CweLwdTP1WCWjqYvX206OkgULuEhvvHGNb423zgqwnom2uRtJmYkuHle?=
 =?us-ascii?Q?v/8gmlgyLW/1q3cm5s7n6rc755dPjwv2aPvZ0k711PEyBVfhcArqJMH2OHn0?=
 =?us-ascii?Q?RgH98ti4B75ULvz/pBO4OXcClGy0N2GMD5EfIpI4p+4tzynvyD6e5Nz41ccB?=
 =?us-ascii?Q?rPAV82jGgHUIBrxOQfXO6ajYx3pg06HC+cQwu0jS6pdTms0RiRpQ9Qy5A6jT?=
 =?us-ascii?Q?gLIFu6QFBBhgB2LTODIZcSGV1t56wOB2aEW5beyfzNDT4xW3meT5CLnsRZ/h?=
 =?us-ascii?Q?mMWlZSa0uqail8K6BJLA5aYcN7jLuhJed31fuTJKKdhZDFmNcOpPdaA/hiQc?=
 =?us-ascii?Q?/YL6CAWRL/QxuxG/4q1yXUDvw01lCGrErJaHJuwL8EUIyjSUWpna2/2uscL+?=
 =?us-ascii?Q?ssTQHZv6FufK17s/swYkYZdz5H761slKLY0ufgjKzMLUjekSg7q7vA/nyZp3?=
 =?us-ascii?Q?0f+Obg6Mnul+O+8oxhMV+Qc7V2WOerJ6yqi3ec0zuk+fJUYyzSjmVYlXHYrn?=
 =?us-ascii?Q?KWLto+hxIRU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FFgQ/F4AqJJDa1FilJhmCwlq8Qwqg21OHHODs7gKyU6urDpnEHEqk7dg/gw5?=
 =?us-ascii?Q?8zSEhoE7YSkvaCJXSXROtUOD3ebuMKOcKNLsbfvqn4Sd1wJ/oeNNzwcFKhHi?=
 =?us-ascii?Q?yH+Ye3QsP+rjDuj3U8IIDiH2cDCuLFyFraiGIJHdZhdGb8nFLwQfMbAekveT?=
 =?us-ascii?Q?4sy3RHVEgb4i2zIsQ1h54oYkIUPxLuNZANjRTror843VRV5ED6qFVM3VIdjm?=
 =?us-ascii?Q?a6lljteIc4qhuDlx0Id1Z3tA4hNc97/yfpTmEUnSx2G3gMPeX2amu3G0VRI7?=
 =?us-ascii?Q?n9sEXgxyhWGCj3Bf+iNzSTLCpknikuLnHK93JoS+ZL6pgn9PzuKoBeEUTP+3?=
 =?us-ascii?Q?nNJfgWO1sluZ67iENdaLS6Y6JI3WSl0UiOhJPSaw9kstxFp9C/sHNKY+izwC?=
 =?us-ascii?Q?ZnZ19hywJ50RM+ptxw1t0syIqLiQbtWmuT2IBGbajIs4+0WRTYfJdVefZxgM?=
 =?us-ascii?Q?7C03MYSpW2JUhSY6bB+u68P7rjBa8pra+QiOyPytKE+8Vwuja8xLwdGzh3se?=
 =?us-ascii?Q?c9yzRQDficRjiYxZ+q2y4ZyUQyZo6yUlVbAh5n+AUvOzkQdO2azQ51RrYQoQ?=
 =?us-ascii?Q?NEnKTnJA26gED7hdUY5OWKNoaLwMG6zT7hLuZvcSn62nFawE+36w6pbQoL18?=
 =?us-ascii?Q?7m09WnpCPdoD3YFbB1hlxqxVb1QdwtOuHRTm7C6Ms34dX45PPNEAwpdggsJs?=
 =?us-ascii?Q?lNerB092xYTIPUF7BPGyDqTi38gtKlAvlx46eovwa9gICre+d3d5aAglleMr?=
 =?us-ascii?Q?AqmmVZ8LRuNDiZLJyiIk6j6O6GwRpwXNFLjSKTTJSWrjSIiKWFOe14eKS8n3?=
 =?us-ascii?Q?YvUtSE5DTjcP2JdprCeGtYEmNnfKSzDNnLFSYpFTXO6Og18CdOSfwZq8rg76?=
 =?us-ascii?Q?a8zmb8ghZLfikxTGxQaBPjk1kLTEW+BDZwy86jFsPI9odHSeiZ4uxXh4mkCV?=
 =?us-ascii?Q?/kKX4zbLUHZKpGNdHnz33ieLhXTJzXnKrrPcCXGfkW2bjGj1ON1p65Nx7BCs?=
 =?us-ascii?Q?CaAu23yVlVM5PqsWe6W6xpWJQgyPPHOEpFkMvbW1DuVPQX9zgFWrOFJtqeuA?=
 =?us-ascii?Q?wuTnYKYGyRwdc4r26OrY1TjB8IZsC2EPLTHkRDXThl00B2G5nLn4thbVbnZu?=
 =?us-ascii?Q?BcjCQpBulbLQbRAPr4iKBZ8i9vZ7zO3VbgM2lWQUytxHYskWgF+S1QkBN5fF?=
 =?us-ascii?Q?WkJTDsTOjGDymKf/XqvD90G5tsgwcNZ2dOo3J4WIY886tzDHt+JTUE38b2L/?=
 =?us-ascii?Q?IcBcPaY7Q1wkZz791ipMQRz75TyqxtHsPT4LV2mS0vH8FNBA8l0/h9E3I8ZN?=
 =?us-ascii?Q?DcdNMLZnKgeRXIqGVucsDIMGBE/SXf+oVyLOpM5wdu6cLXB1911FB6T9w7R3?=
 =?us-ascii?Q?DiVdRztYAP3x701aqfjJC+Gb7bfbpupJPjLSXYRqDbf7gDla3CgH96D8bWFS?=
 =?us-ascii?Q?eqpXO5UoA3ZgJ8XhlTbL1ov3746tN1SxlHjXp67JqyNcYgTw6PVZQyfZpw0x?=
 =?us-ascii?Q?qyxwIi/sKI8Eun69rvEaI7C4PAgMpnHonB2qecVcOwUzeerFYa/PmpjgS0eX?=
 =?us-ascii?Q?zHPUznJN2hVTtwE3j2bfUz7xxEuCeUG3bZP4Ei7L?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ktJTMzIgTe9bt8pwD/5QH7R1ocBlRsrxnCsB5TL4tUv+LmcpGsUAoEafam3a3IHPrx7MaQPMHIJvk6eHYKTJhTTiKT8juHkOkqU6ijy3v/sLGxFCLLu5BePfM8l8LB7SNIKC9XiNt3PjRRP4o7al2pa8C0nj9HuzkPoHp2VhvUdfhFzzh/m3OsU1bGrbc1kmHRVtgu5nbHCYmwbuk0HFTjvgvvOtYrDmsDKe9f7ArptcYECUzuuy2R4oeLIhp9VVKqeXsQqB50xHBNC2SVyBAGzJBaGKB4pOtwQPJjXSXc34QUsBhU4FMdCDKGBHyyVCgjZ4TdKpQo1SgCk7DvcFVSL9ACQIfh22b9OrrqGRKGnJaTfY6wddrVOFWLkzqnbJ1vCGgjvQfa4MOhvqaxTcMX1mGI3H4PCa2f45h4g3LgB/gZ+pYOU6m36XJOo8o/DguPv0O4IpUfFoWnclzI41l6c20Nf2AgGEiLA6P2pBVCxpzhj3kZqc1ikvyrj2g/aI7aVWZmdKtKi8eERbvlmigGifLsW+Oft+YfEBI4SYJid38ya5hvDralCQ+5Wi/LIeBkpLWed0EnGTz20tOwwLBzKBUv6oDB09wVldMelQTsI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7277d0b-29af-43d6-028e-08ddde6f8175
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 15:54:25.2406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Lr1FWRKJUQaRtA8j+4EURCT3jCT/1BRIk9Y70ru3aqBkKOillD8MQ+/Q6LyLv89vb+SRMctBrnNp9Jqye3fIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7230
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_05,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508180149
X-Proofpoint-GUID: I90n4TzhDooI8yQucQxc0CxBEJE8lXy5
X-Authority-Analysis: v=2.4 cv=dN2mmPZb c=1 sm=1 tr=0 ts=68a34cb5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=W7fSGNyg6wTEdSoANoMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE4MDE0OCBTYWx0ZWRfX2c/jZIpAD6Xx
 z80EAdpJNqxBS/JjkeMs7L5XzkjNCEODI+3HDy+EepWSMA/dbMNFmtWJI8jLDAdvj3jg9pnmr8+
 MjpRZPKRH/6YV7sPHQBbbM1qgEyUA5poWiT+lTlwatfEEwFoRrc444qKcrJx3hYsuz/BUutSWwW
 JUdV/SuVo4xt/Q8/ZFx/GA4ibtr2yBpzzRLX4xLKi4Obfm+GoBoIs2VObUR0Ii+KYnwOms0GDr9
 MDvptKn6XjWCbbMHaO2cjfU/tpMM6B0xuEpqsY6wsBRRNn5kpYgxLmAkpYf7wCQmk40Gp0GOaoR
 IPFNS6oU48ZQvq7zbW9h42eOGQ9EMnwkM3ZKD4HoaMt8+GxE03+iY4JRy2vtcYI/0LMUGfggmJP
 5i0NhaY436zb+XIDAH0nXrBf177BY5umIPOyflPK7dGlTKDIksQb3suXxd54N99ag+2GNKYy
X-Proofpoint-ORIG-GUID: I90n4TzhDooI8yQucQxc0CxBEJE8lXy5
X-Rspamd-Queue-Id: BD9971A0010
X-Stat-Signature: in6yddunwy9sg1iktfhjgs1iiopt6jjq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755532482-568600
X-HE-Meta: U2FsdGVkX1+KB14Az15kKIMYN+F65eQW3krEXcy8ogquoooZxOM9AQmJWxjzFHV94XulWy3atMqw8IY0hL3DA69gakrAZgRWolxVKD4o3be7nGQoCFp8ZjNyNGoLLQdrDcxVWPHDPGM/zQSpVOKTD570wsvesQW0qRCdGtj2uk0EzpHyd+ihaUY4RKfgh6xUyhcZ0ZAYcl9Dx6xU6qSSZJOf408vlhIvuSApGyUg9EQzYhJkztyIQK9dF2LPzW7rGGPBtBGwppgRqC0YgBn4t3JO+0O2A7w/hf9pNzRtbA/8rRD8B+/JKezropg1AGiCKsl8JBL0cxHlBIfbKvusDV5+rcCQmc01hAf2E1dXiEPbYYOSq+XnBo+wyfAXdRCU2XRrSyGOum1Gx+XZ8bl9237SeQxic7tk6sUoXZYx0P38FoGf22/LWV3CXH5jSjObtZTh27XfM3/c+Gkmu2fb3bXp5uNYrvCHSMsyU4FCjKeu9MyaV68f4NzT5DWiqNbcoCWjv9UvpGhdjpS/WflR1+o1cmzIKlHRuzhAH8f3QBV5Yku6lZWfI1EG/nBt5ENUkLa9SJx4PPKJeKhGfpehnXTR3npde3+CQyo/DPRgKounIF6mARNJGtR9/7F9dHRjWRFoMXfznBvMg1u0RLNVkKx2lfb5QNBXI8a33xwnS/V6ryMLT2qyz6khg7tTF32ooRvrWspDyMTYng7x663dhEG2oMETBWqdVuiDdvNGh7KYInjNeNXgy0C+x1KtEmxb7h28qTnTMyI2eIKXWZK0q8K3C4atGr5wVC0AMRuZaR1xhdvkmU5h0ETmh3B5GJQ8xSxwv4l2MK5r0s1gbp0rc4EuMPRoe7wQ8WZBllCW1d8H65GipwwO5jwdH3kcHIYTw4xNbqsBtzth8x/QmKt0tsasBONeD8B6yg/wIfQYBAp8BFbweQ4GqzFeRJeO4Iav9JYWueN6DLe6b4dc1te
 NaexRwXa
 Giius45MVrIN3ZUFxyPag4QbJngsgQMMSDpi46MkV5OLxFXNz4WOyfLfaEKP9mRphZZUId/jIhRFSd8Ves82DncNf/KOZ+za3ir9QJNOKnbrrbZouKvpwFhJ1hoN8K6D6qkLXSQD5z+9CQPnPQ0LCxZKEPByBX02uWDLc6dCdrAvzgkhCliczLhjolCJJD67fS/OsbaaidwS9FQErP2y/yKZXG25r9c+cckU0yI9Zqn/cRSMA4opYhy44KL0w7pOtNCrxHRekyhl0nEs1lvSOm0/LMYeSwVM13lBqGHw5bpu6Id3x0f3kN9IBihzK5ld+UJuUW5qjbs7JMF6+ra4k1xGOt/xtjzg0deWDD/oUvRoEl5d7TMvUp/LGbe+Wa2eNSjOXMMCoX3jrQO6/WoXCwAfdCNT2EvnspKG78NudPMhVftUbysRQqlrSdbhXsaSbs1iKnDKywl7mIYv3vLbpRiv5nsLAqrHp0PcyQguJEq1+HkUszt1zcbaMqxq3GCN1ITf3DfWI9VNMlmu7gNauhr7Z2TlnROs81IlGdyi/qWGWVbHL1TJHapFusLKvhUIhjH0i+HA9uG2XD29Xm0bJv2vT6QpaoR2qMa2AKi1h0Pyj6qfClRgevBFLjWs4GWT5wpmXPKZ1qskvMMlcgaN4YWiOeprAvz60l6vOv4llSgFSb77WjjmzoH/vXJgqnxC28Hk+701nqU/c/KR7lubmwg+3DFnTlEl3P0M4ss8UQtxT/kf5isyAJm/5NtopRtKvxOLX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250818 11:36]:
> I know this is an RFC but to be mildly annoying, you need to also update
> tools/testing/vma/vma_internal.h to reflect this as this causes those tests
> to break.

Sounds good.  I did check that, but on an earlier version with another
vma testing fix.

I'll check again before sending out another version.

Thanks,
Liam

