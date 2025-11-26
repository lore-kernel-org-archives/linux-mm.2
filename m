Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8107D11181
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71E86B0005; Wed, 26 Nov 2025 11:01:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22426B000A; Wed, 26 Nov 2025 11:01:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D4C6B002A; Wed, 26 Nov 2025 11:01:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AAFEB6B0005
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:01:24 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3EB5250347
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:01:24 +0000 (UTC)
X-FDA: 84153222888.10.1C64DF4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8336F120029
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:01:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cUsnMuGj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CExdf8+n;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764172880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61W2NEYXas0KI47vePBYijJhMAJPVTImafK9T3j7sIA=;
	b=OORSveKtVlakgnoxbgoHJTz4dyTYl1P6B+eF2ejzWZWisFkFc7DFHMwRHttecqZ5ls71jQ
	TgLZD6NiyCG4hbYCNc0iB9DTDU27JJT0yRkkEmb/RTcAqMw32DrBACesCWex8HaX/Yh1Ld
	aQzoZeQaNC3whFKT8++d92VKbGmmLT4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cUsnMuGj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CExdf8+n;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764172880; a=rsa-sha256;
	cv=pass;
	b=QfoMGU1C+6+cUaNALbe+8TTglth9bx5IjTvm6gZDWnP68aGrqlb1m1YjU6ukJxSrmwRmsh
	kqFoX60+czyyhq2csB3StyMCgL3QnBXO1CPiamCihhAsxGq2X0/PeadDHJgxTzWILvMVJ9
	hfhuRzo6TQwixZGzW2KmOZxNfz5qwFg=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQEuDrx2502228;
	Wed, 26 Nov 2025 16:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=61W2NEYXas0KI47vePBYijJhMAJPVTImafK9T3j7sIA=; b=
	cUsnMuGjGfHNpYI6d+lvANz71MXwC48/R1e8v/vCe5B/xvsyEDwR+kIyitw3dIdx
	xX8LVnev02yf3D7Xw16PosBHLUyxQTOMypNIp6DYElI+h34SoO/ZjHCt/Nem0dPe
	ZiBB8y5/bhfSt86u7NYDA4/qdUeGYNF+Lw97HP59fD6kTOdIXCchIllty4R6DFJa
	l/Z+4HfValyRmqhuTIhNdFz7Jc8I5tVd+Tf3PgrVJwBO4xWlqhhlYPNtENnLQ2qZ
	gRDi4JDOD4ERM39dNFJLhnGlwzbgZvvYImnqE5yHXM8HI3snzReosFseNkS+M/yM
	L0aIEHUVQJ+2oWUnLzhrfg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7yhvkv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 16:01:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQFuZNh032948;
	Wed, 26 Nov 2025 16:01:09 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010056.outbound.protection.outlook.com [40.93.198.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mb5rhf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 16:01:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KQcHInCGWkqyVeojCI6afNRrew2u3TokEtDRvwl9KDmp/oDe/LUBOdMpuZ277Ynw7jA+pL1flFA38vF02vSKfKczjmkQ1WyJNsxfMqvK8vqbJL6241+LwPkHaH2IeTYP9wS4rQuIQOTY2sTES4SFkMPaVsCoFUZNbE7YEowl05x5l9JU/hhz8XRJ9x8kkJlGt0rAQ/KTt4z5IUj7F2XfmIDOT//AbMZ0OzeGjD1qMSwO+LVZNTrdbglgRbSH/P5Dmp05fggTiUCaAquOoFOHHPqO/SdDEK5zNvrjCrfhqQPqGDMwTHe337CXvkYgo2O2VW4DNOLzZBBTMF5xmR3PuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61W2NEYXas0KI47vePBYijJhMAJPVTImafK9T3j7sIA=;
 b=vtmVLFSiw1vZTmwUUxZluzkoZwJ5ATap3nf+GQhrtwore+m3jFCPsfzruC0HFqrlPNLSQRcBFOtyOhkVxvlVNCdi39rTWdwnG7c1CsT90YA4MJixJYKkBtqkfM7VRLT2rmp2uM3PAIEFpHieMc2c/9DcO8qJXN5pGSDhKUISP2M93fWgOeyLP7Wikh9Ue72U9SBEQdUCifLiuxwwPqiXIpD0UTTj1m2W/ST0s/ykzJIeEXvu8axLszB6DASUUgRMVn3BI1IOnKb4gaHKtK6Kz3tSzqq0Dk9+dzd64ijY2BkaplyVNkbIc+RMSoYyaRuTS5Q87JzMdnm55S8HKSyWcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61W2NEYXas0KI47vePBYijJhMAJPVTImafK9T3j7sIA=;
 b=CExdf8+n/LZ+LqnPEo5TqkgDO5+5imgrBv/f6aY1PpOrYZosZWHgY6rM76KZ+RXLvVgJmPVv5EgnPa7Fsx4hskh+aafeyXZW+YVzrvFE3gr8BYP7meTkLYKWkZDVKgbhTnVAaFeN4hYu6/1gJNNgp1rmTihB4PJ9WpRwyHt0JMQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6443.namprd10.prod.outlook.com (2603:10b6:930:61::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 16:01:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 16:01:01 +0000
Date: Wed, 26 Nov 2025 16:00:59 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
Message-ID: <3d069afd-a19e-4ee7-bbb9-7d15b065ab1f@lucifer.local>
References: <20251126034404.2264317-1-willy@infradead.org>
 <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz>
 <aScXSEY7v7_fcEZF@casper.infradead.org>
 <44f4d9b7-45e3-4d2e-b1df-cab8e254e54e@lucifer.local>
 <CAJuCfpExY2wYk=TuWEGGgyh3YOJyi2+4sPVd4XfNb7kZeRr2Rw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpExY2wYk=TuWEGGgyh3YOJyi2+4sPVd4XfNb7kZeRr2Rw@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0104.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6443:EE_
X-MS-Office365-Filtering-Correlation-Id: 248b5292-dd6d-4311-a25d-08de2d04ff02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZXQ0aE1jbnYvS3o1SlorRWVKa3VRNkpiQ3lveHoyV2l3cmh4WE4xclQ4SEFW?=
 =?utf-8?B?TStRQzcwTUJzYXUzaTh4U3FtZG4wYWRBN0dsV0lFby9mVmdIL2NERkJEZEF5?=
 =?utf-8?B?RmhjaE9mQlBONWV4cnd3ZkI1cTBORTFhK25yWEdmMHdrbCtSMHpHVitUUE5y?=
 =?utf-8?B?WVJKdUludloxMHlnWWQvU0xURjNGRVlscWxOcjIyT2hGR2xFWGIwTk84OC8y?=
 =?utf-8?B?S0krYkYyZXYzSlYrajNJN2Q2WGsvejQ3bTREQ2NJdUp0QW5Sb1ArdDRWbzBE?=
 =?utf-8?B?RTAzM1lzK3UvdXBMNjA2SkQwTEpUeG8rYnpLbmxPcDZzc1B4bWtRcE8zNElm?=
 =?utf-8?B?K0gwWXM2SzdIcW9kNThnT0ZlOEptc2xxTUJQSVdGdlhVbDBEelZDc0FPcy9X?=
 =?utf-8?B?RENqWTBwZVRKNU1QdVNraVBGUVcxZkY4OWFXWGdZNVQrVFdSRHYxNnozR3ZL?=
 =?utf-8?B?NGd3emxBK2krSUY4K21hdWc4QmZTWG03Nnd6T1pTZnZOZUVUUjd6ZWVtQkgr?=
 =?utf-8?B?MzFDa2lHS3AvdmR3Qkg5Z0ZjMzVFWUxOUGtyZGNpcTlYWkh3bVZqYm9Gb1N1?=
 =?utf-8?B?ekgxTi9ZQUhiYkxEYWE0cGh3aHlmSzVXSjBmQXhIQTFhdG51eEJoa0o2ZUg5?=
 =?utf-8?B?WkdQajNuekxXMm5ld3dUZ1pFV1lrUk53bWFwK3IwRHpIVnJwOVVpNkVOeHZp?=
 =?utf-8?B?czdCNUNNeVltY0x2ejdpZnlndW5MbWR1M1dwSFZzUW1SSTJhVlFacXJQSkh0?=
 =?utf-8?B?OTRwVHo3L1Z5ODZPbk1lSDgvTEVITytRNEtJYVVIZEdqV0pOU1hhSDJoT0la?=
 =?utf-8?B?NVJNUHRnZEFxSU9hWnJxajZ2aitXTU5IbVhGZCtBdUVWUkhsRmtHZXBrQTA3?=
 =?utf-8?B?S1l3Wkgvamp2TXZDaWFGdFFSVDNRQXBrWHJtb0lodjdWSTNhelIvcEdPRjRY?=
 =?utf-8?B?b1RMdEdYOHJ5eVZ4Y1hnMFRCdWNpOElidUZWLzRycUhza1RZcjhDNmdCbm5J?=
 =?utf-8?B?TnVVNlhZQy83VlkzdC9QNEMvOGs0Q1NSVWE2WWNTMTNjYnl5WTVwQUhEOVNx?=
 =?utf-8?B?OFBHWUQ5S3E3elFmOXJ1d004U3ZBZnc5c0JqcFZUMFhCZ1NjQUV4VFowUjRt?=
 =?utf-8?B?MVgxSUNoT2FpZU15L1RjRlU5Vy9YbUwrVVZLQnp1emtTa0duVHNJZGUvVVdP?=
 =?utf-8?B?M1Zuck1MUXNVRzJvOEJPUnNlYmF1TzNsRTBoS2N6Q2ZYRmtJT3VGa3lIK1BV?=
 =?utf-8?B?TWdjMmR5bGIrLzVjd3p3SHBwVFU2NTcwNi9Bd2UzZjhZNDVvYlNwZkdQeThO?=
 =?utf-8?B?TitXSDhKbUtiaVBSK2VJTFNoY0VNWkJHeXc1MysyU1pORGlQaFVQMTZUaC9l?=
 =?utf-8?B?ekt4WG85V1ZoSUViV0VYWVN3SzViQWZQaTNGVUphR3BMTWN6c1FaU0JHTHIx?=
 =?utf-8?B?T1N2djgxMzFhOEZMcUNFQ1k1TTlFWkh2Zm9aRGdIRUk4THNvYmJSYm9vTVVn?=
 =?utf-8?B?d3Vqa2JKS1JlSGhheWRLM24yd3ZKajNQY1ZQS1RzS3NYMjFEeXRNZ3U1T3d2?=
 =?utf-8?B?STNYV2t2VVRLNXZHSnBZV2lLbkpzMHBxV1NUM0w3aTV5bXlhYWZoNG01aWVG?=
 =?utf-8?B?cmV0OVNhRXNjdDZkcFVwYzBWUi9WdVNwVU13RXdVcXMxeHpiZmJvVmVkYlZ5?=
 =?utf-8?B?eWcrWG9pZFkwNWFRVys4d2k5cmxHby85ZEVzVWZ6VnNIMjhXcEhGQVBWN3NX?=
 =?utf-8?B?MjgxSW5ZazVhN0VSSnhseU1LRllZVHpOdnBjVEdpTFVqMzN4OFV6bXEvZXNF?=
 =?utf-8?B?cThqSEEvYTBNUENWYzJzR1NkMkNLOVVXUkNMYzNBeTZpS0hoRDVmN0ZUOEl6?=
 =?utf-8?B?alFneWx0cEhuWnFYSUtDbzZTc1hCeFJQeTJVQ1d5N3NFS0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1YrQVp0bDgrTUdtSlYyeHM4cXl4SEp1NW8wT25JVGtvRXJWbzN6aUZSUXRp?=
 =?utf-8?B?cU1ZdVFST1JYV2FCcGdsKzV0bmhZSWlGcThwdW1mU3FVYXZaSER6MW1tR0gr?=
 =?utf-8?B?SVZhcmxGMlY2cFRDSExWNUF2UGhnTWNraEhRQmRIWFdiSmcvSS9LMVdpc0N6?=
 =?utf-8?B?b3NIOXBUY0dMTWZPY3QrdnNOVmk0UC9MYjU2S3FNc0VwblFvenJPREJpRnFJ?=
 =?utf-8?B?K0JGMzZCYVZzaUFXa3U1Y0RQeXVZOTNZZ3Z0V25KV29yUlpTYjBaNkxSMU5F?=
 =?utf-8?B?Z3FRbC9xNnNocXVxaUo1UUsrSjRkeVh3cGgrQlpmVTZXOFl6d1k2OGRFdkI3?=
 =?utf-8?B?ZGFaZ21ENFZidHRnd3IwYnViSnA4cjA5enNGZTVSQm1nSVh2cy9nM05WZzZZ?=
 =?utf-8?B?NEhUMk80VVkzd0FoYVM2M2FZb2ZDN2d0MVl3OC90c0VJdkRBck8wSmZ3ZXBI?=
 =?utf-8?B?UXhvSllVVUF3endhMi9ISy9wMzJ1Z1A5NUFGY3VQYzRFTmRweC9RczlrY1p1?=
 =?utf-8?B?a2FWbzNhVHM3SjhQUkFzeG9PRExJY29LUGovYmwxaXd3bnlqbHQwZkZ1ZlJi?=
 =?utf-8?B?L2JvS29DUmczTGtTMkRJQUhrUHFra050UTY1R0x1bmFMWkFlUS9JWGlzWWsy?=
 =?utf-8?B?VWlIa3JoMFJFZHBuQzRsNkpyaXh0eWFjTCtkekRNWElYVkwxOHI4MDhpQTVF?=
 =?utf-8?B?dVhiK3J3ZnJZUW05QTdJVS9iZlNyelJEdUxtKzFkSW5jc3o4WjAxZTV0b1pS?=
 =?utf-8?B?dUwvZWh5bERJZ0hnUFZmai9IK1lyT3lCaDFraTFvUGgxc25ldnFoZUkxU2dk?=
 =?utf-8?B?Q0tyN25Gc0RtekpBNkVvOUhYSGZEd0xyaGlWWlVSR1ZtTHpka3k3YWYxSkMy?=
 =?utf-8?B?MDc4U2ZyejVrYm41aTNUdE9oTm83MG5uVTNrdnZsRjdZRnIwVHloVnBCUHhm?=
 =?utf-8?B?dWxlMVZNU0VTT3ZHbktFVUd2ZlNiZ3FsbDZoODUzUEFwcGcwZXRDdmFlSWNt?=
 =?utf-8?B?OXF5R2tLMExaa2hyUnFlOVFsdStra2UxU09Fcms0c0RhSTljUlNyVUhiemJ6?=
 =?utf-8?B?N3RRRVhhV25KRGY2YkU3WjZXZDk1Y0dqQ2l3V0svR3N0QjFYMzFmL2pqM0RF?=
 =?utf-8?B?SC9Cdk9nek40Q0JDTzZqanBoUXAxYUNVNzNhRjI4cjJMQzhLZUlrRzRMdlIr?=
 =?utf-8?B?WnpiaXF6aURhZlN5MythUXFBNlNTcGw2aUpWbmxPQjZCZE1VV2xCbkJkUGx3?=
 =?utf-8?B?K3IvWUdVRjlTS3JRY0hTTGludElYcmZod0NOak9yS1RPdzhMTWtxWTRFRGlr?=
 =?utf-8?B?Y2lKdW4yb3pHUGNzQ3pGeld1QXdkWXhOU3doMkE4d05zd25lakM4VmdIUGxu?=
 =?utf-8?B?U0JjeEVrVXFob3FOTEg2eC81NHZOSm9BTE5iUHoweGVDNDRBZU54eHp2TGZ4?=
 =?utf-8?B?WExIZnFJTTFESExaQXVtWkkySFd0cmkrZkM1YmlYN0cwcm96dDJ5Tmx2WW1o?=
 =?utf-8?B?K0ZYZzZwZWtUSUEyMGxmd1o2THd1MGphMWtsOGRBNk5rbW1UY2ZlWkNWTlBw?=
 =?utf-8?B?NnBHZzk5SDBQWmdJZEpFS0tJTVlsKy96SWJjT1ZUcjhxdDFDQTFpcUVGMzJ5?=
 =?utf-8?B?bUFHZ1ROa0wrMXc1Q3g5blRFR0JGZ0phQXpBL1FkdzJyWjVXNnlQUG9GWlha?=
 =?utf-8?B?cDR1bjhmekZvUE9HQ2R2NEw4aWRwZklXYk05SGxDamdqTXF6c3VxdW5WbXB6?=
 =?utf-8?B?eDhhS3VwbnMwVGEveWxZUmZoMG5xdWlTZDZXOWthVGNNWFh0bUZJVGVLclo2?=
 =?utf-8?B?UXRBWmFkZXh4eGJuZnErNGVuSXVMYlZpWjdkdks3bkU2a2Q2bHNMVDJVb3Rr?=
 =?utf-8?B?ZkxkUWFCMjVTQjcrdkVtb3FJRi9LQmtrdjU3WmNDY0xPYjUyR3l1c2FZSWRr?=
 =?utf-8?B?S0FFcjV0SHQ3a1Nlb1lVdjZYK0pPcEdPakVjMHh2dWh3VzlEL0xCS2xYNXBo?=
 =?utf-8?B?aEg1Q21PRm14bFMzU1lJZTNkcmRwd2lZa2YyMDg5THdVdVRHYzBkZFNiZVk0?=
 =?utf-8?B?ZXk5bnpkWXZtTGZ4dDJsRWVsbnVweWxDS3VwdklJMDFlRUQxMkgzMVFKM3cr?=
 =?utf-8?B?K1M3MklwSU5jeklZNlJPVi94Z0RWeFBYb2ltdnZDVS9STVU3UjFhK1JSZkdN?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sru3XmMI9pNKSI1mQdCPs84Eow165slS+lfXeimaQIPzgmD97rk3AR/cZFNsVWjHQtAyBuebwwEcdpW4Qqwx1Yi0gEr2jXvHSrd9j7GMLx6PymieLrpdwPMnOax6CnwaNIlVmPfcs7No+7tLaJ6BWb8oozCIwIotFS3SijE/KlH8J7JRdUy+s0G4o/UvCZ8S14jGs2zpfWquXh9NzDi8tq8MJgGYbDUKSZ/2KRqA9suxKLVMpmEnCFwx/mHQ8Kyw5hcsvRXlc9cWXOv4dSZqQBABjY5ZKTopnKNREkjbdoptPyuHaVemB5MaZnGB4MOYHdxOlWBNpk4RVHdfYV2zHhXIUkNm58ErM2P0icJ/eyl5miFD+LoxeD2cYReaBAlQ5Os5kMbyyz5XgH3g82CittYdMO9AAH09dAJGsQDmSXO3jMQj4zW7NxE1I1DKs6rf0IVHmmZTiJsuPgy323SYFQLcrTa7agGUX3MS5OMr+pq1VQMoLs6O128yQtwdk0r+9XP3EQBQBPj9Gy/Xn/Qx3dF8ph3UzWOPoioOF8TRPa+qDiXhy1qidAe+vWMk8vQa3xgRBDC4fsGTo6E27d3JX5KXSYpPGIjjDm15ngCJMM0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 248b5292-dd6d-4311-a25d-08de2d04ff02
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 16:01:01.6398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mkZcdgnPt+zQFuul/mX4n7pTR51FTeiFD1RVK2ny34ds0xbQeIRGhMbgO/amzpjdC7Y68kLzF3U+SHnUnA4jOB15J99//bGdXKAKxKLnNvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6443
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511260131
X-Authority-Analysis: v=2.4 cv=L6AQguT8 c=1 sm=1 tr=0 ts=69272445 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=P-IC7800AAAA:8 a=yPCof4ZbAAAA:8 a=sY4JXggKVBGmPmPqvqYA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDEzMSBTYWx0ZWRfX6JzPymhp/9FS
 /Fdge+HsCNOgevfwqHSfATJbPLldCK7BCf0eylPauuubPV0HgYZDoCJ9MXOYwwnrUtJQZXVMj/U
 nhYWHlUZZyQMESWMeOi2cszHqKHYtGs4xjNbaZOTp926tGoUJNa34ZajZbbIeHvRId5gPCqSIMc
 z0WvAIuMlHN+0sygHlsEMuoImrU9tJL14en2k00mwIpAuvLfh74iuJxooCATxi21Pq7qcaNQ8vi
 2AfIDj02Pftf71+ilnExcL/1NMGtrph4AgGPkjQFIjoeDmVygV0/DbRbiKDrDdeuFzYANXDeNPT
 DIS+7Hbc4K7ju9A3judUk1lXBhxROg0n3GEEJmbhlnnRPN8rDk2C+etFy/71uEXV3xDfFEQMkz8
 0nVfvYc7fAV1mu4V0uWe2psb1swSFQ==
X-Proofpoint-ORIG-GUID: wDrebwNUIyEymGOJOgr_TyHa8EHJN2Hp
X-Proofpoint-GUID: wDrebwNUIyEymGOJOgr_TyHa8EHJN2Hp
X-Rspam-User: 
X-Rspamd-Queue-Id: 8336F120029
X-Rspamd-Server: rspam11
X-Stat-Signature: 4g4w4tt4d1mwx745w55sksbijing44rg
X-HE-Tag: 1764172880-812885
X-HE-Meta: U2FsdGVkX1/yIRV39xJjvQJ7LtZMe3jdAXr2U1wZPx7aRYT5dYt+nbj+tRZmqMNkidgvAe9I++r+BcQXHZEnDAgIyATrrZhd3C956h23dafXNJhPYIT3Pv03gr5dF9F1Wpvgirvdn8btakF1I/xE0bdTge++1E+VqsMsJzHus7ck/t/nEsvzp2S46QEKSIQOaBeVUALvR4PirX0UAolo6Kpk0PBgO0qPtoN4bFL758Ogk17VZb6AlieTDltVWNdZ7IMDB7X+V+pbdw6RI8wDtmj3z4x+UuPIRi+riGcj3cf5s+PdsFE0Lg+WVo34c77E44eJfKEM35Ic7CUPiZ0gjS2lmbPFjelUGNnwU1++NDQCXL8cw2N8JBL30OcGU/wtHB+ib+aRp+AEUToiVbFr1Hte8xGi0fXFrQZ1kkNRxa2CXVN95CG3bX9Vkej/HMFMnGtJXrOpLGqv3geqanDiOIHaq1t1wraCG4rNbaJnpxBUS1nLig8+pNBzKnatazfM8C6KYV/hmxxIT3KLXoO8E5FVFzAk98Xh+oWXqPfaiibhUCBWuyhyfcltHdMQyBskFOAuHwvIufTpVIXcUYNWWpLzHnTYcexZUAcbt4qaCPxs+LCmxl6ZLoMhCY4siR8pxGmMGt1KOu4y+u7sthX18OVaBBFgULWGuJkUOuYwBL4zrq8iFSWp4+dFZjxqierCMywvlVJCy28YKD5Vb4BfvwjqL+f9sj0VgPsXzlT5+CoiOS/d2YJuQTqDeySSTM+70PHwAbOQKMylHBMNmo/eEFDu4rWuCLi9Hul9H36XuRe6pkSw6ykuJl6IiI/QoRpqG94oVsqzLw/7hWBpzIVDsiUCQqjHArFC40hD4GFcJen7lGkVtMsIGn8T1rZh++YfIGgxxTimkGycdm95S6iJSZeRRrC0JSA4HBjle11XXMmOOYN76MX2l1TCarKVudKm8H1gyHcgrUmJmo4JoeG
 jdpJHd/e
 7N+zs/O9TmBrfyDDa5nZE9kR8dsurJcQbr9U05wRnysFLmOqKrqFqUFf3hQj+Lf/Gx9eHF2APRxMWW45NvSmlevcdxFCHDe/CLC6NzH2QJy+2q9Fi/qJn2coVLmhxJq2kIbs6PvmgYjbveBKXXTbfMdRYEWELaoy08+zJ44cqNnSKktiwgOrLxJvEJOpenr4/g1bvDkulbz3B3qJS4YbRRkOITdJZTjSDTDiimYcjJD8Bs7n/jsrW8fZFOlFpR+3tQFd3UyU33qZVN6yOw/7cJDk8oU+cv7L5nMrD3t2oRKRXVqygUAHXb4QprvGk/IJRfxddp0Ia3LV6GlxLKguDeLpN9240O+aqE6eqZY2pgAsh8Pb5jtO9uoF7J/bAFOIeF37ct8Hy8tYxXVSImFmjGLQJXiXi90wZ0tNzFPAOHaA4gZ6GwmA/Dv4wjaQEHcxag/nJpUAKVoQVDPzYqXnRhz1vM6zMy8QmXyRZCQpKqJlwt2yW686ITD4NC9l5vc5cFf23dVn5wTqpx0ACWPWem3OUmclYJe/On4Y1xOCQkH958hqEuqzDRpDkMbDqufF0fIoSTmuJ8zLdQpRtl6FisZ7ft4DkRgcLZDfLaxI7NS/PBigxz9Nq4MbZbmesCK33yaC1zqm2SeiA9hEpztLS/nMBHws506yKSjV7YlRDFT3KpvV8ivQKSsm8VXDz/UztSoeg5OJerI2PrgBpsKmLO5zqYUD9wLezXvKTc0KboKJCp05bw8wgCwUQRlIgGD6HhwXU7zOGPyisxOVwFM19BBaSwelR2/AzQMx3HYeydHBTE52M29R4IwbRFiOaOIQr2Vqp3IQcuIFyNhhgB7e3HiJE3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 07:49:13AM -0800, Suren Baghdasaryan wrote:
> On Wed, Nov 26, 2025 at 7:20 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Wed, Nov 26, 2025 at 03:05:44PM +0000, Matthew Wilcox wrote:
> > > On Wed, Nov 26, 2025 at 03:36:46PM +0100, Vlastimil Babka wrote:
> > > > On 11/26/25 5:28 AM, Suren Baghdasaryan wrote:
> > > > >> Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.
> > > > >
> > > > > Doh! This is embarassing...
> > > >
> > > > Hand-rolled synchronization primitives are wonderful, aren't they?
> > >
> > > That's why I liked the original approach of just using rwsems.  I
> > > mst admit to having not paid attention to this recently so I don't
> > > know what motivated the change.
>
> That made it simpler to add SLAB_TYPESAFE_BY_RCU for vm_area_structs
> which improved the performance of allocating these structs during
> calls like mmap and fork.

Hmm, we doubled down :)

Hope the wins were worth the complexity, but obviously the horse has bolted
and I should have asked more about it at the time...

>
> > >
> > > > > Wait, why do we consider this as a successful acquisition? The
> > > > > vm_refcnt is 0, so this is similar situation to an earlier:
> > > > >
> > > > > if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> > > > >         return 0;
> > > >
> > > > But this means "vma is not attached" not "we failed to lock it".
> > > >
> > > > > IOW, the vma is not referenced, so we failed to lock it. I think the
> > > > > fix should be:
> > > > >
> > > > >         if (err) {
> > > > > +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> > > > > +                       /* Oh cobblers.  While we got a fatal signal, we
> > > > > +                        * raced with the last user.  VMA is not referenced,
> > > > > +                        * fail to lock it.
> > > > > +                        */
> > > > > +                       err = 0;
> > > >
> > > > Returning 0 in this situation therefore wouldn't be correct.
> > > >
> > > > AFAIU since we started with attached vma above, it's not possible that
> > > > the refcount_sub_and_test here will drop the refcnt to zero. We could
> > > > just WARN_ON_ONCE() on the result (in a way to make also the
> > > > __must_check happy) and then can return err below.
> > >
> > > But how do we know that we started with an attached VMA?  Maybe the VMA
> > > was in the process of being detached and still has readers?
> >
> > So we're talking about:
> >
> > vma_mark_deteched()
> > -> refcount_dec_and_test() [ ref count is zero ]
> > -> __vma_enter_locked()
> >
> > (meanwhile...)
> >
> > -> reader attempts to read
> >   -> optimistic check doesn't successfully find write locked VMA
> >   -> __refcount_inc_not_zero_limited_acqure() somehow doesn't notice 0 refcount and increments
> >     (??? how)
> >
> > (back to vma_mark_attached() -> __vma_enter_locked())
> >
> > -> refcount_add_not_zero() returns true
> >
> > [ process gets fatal signal ]
> >
> > -> rcuwait_wait_event() errors out
> > -> oopsies need to do something, maybe [VM_]WARN_ON() not right?
> >
> > Correct me if the above is wrong.
> >
> > I mean is any of this actually possible...?
> >
> > Seems dubious. But I guess right now we assume it _is_ possible. What a mess!
> >
> > (Again I wonder why we made our lives so difficult here)
> >
> > Anyway even if we are midway through a detach, the detach is ostensibly waiting
> > for the readers to go away, and our reader is about to go away anyway, but the
> > process has a fatal signal so do we even care?
> >
> > I actually wonder if a WARN_ON() is warranted to see if this even ever
> > happens...
> >
> > OK just going to reattach... my head which just exploded from the above :P
>
> We are overthinking this. Vlastimil is right. If we entered with an

Watch Vlastimil frame this... ;)

> attached VMA (which is the case due to this check:
> https://elixir.bootlin.com/linux/v6.18-rc7/source/mm/mmap_lock.c#L60)
> then the only function that can detach the VMA from under us is
> vma_mark_detached() but that function can't race with

We hold the mmap/VMA write lock yes, but as per the comment in
vma_mark_detached() + above list readers can spuriously increment the
refcount (ostensibly) as per:

		/* Wait until vma is detached with no readers. */

So doesn't that mean we can hit the issue Matthew raised?

Otherwise there would be no need to do this dance in vma_mark_detached()
anyway?

Maybe I'm missing something.

> __vma_enter_locked() because both functions are required to hold
> mmap_write_lock. vma_mark_detached() has an explicit
> vma_assert_write_locked(vma) check (which implies mmap_write_lock) and
> vma_start_write() calls __is_vma_write_locked() which does
> mmap_assert_write_locked(vma->vm_mm). We can add a comment here or an
> mmap_assert_write_locked(vma->vm_mm); at the beginning of the
> __vma_enter_locked() to make that obvious.
>
> > Cheers, Lorenzo
>

Thanks, Lorenzo

