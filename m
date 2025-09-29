Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60FCCAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 16:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001548E001B; Mon, 29 Sep 2025 12:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A158E0002; Mon, 29 Sep 2025 12:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1188E001B; Mon, 29 Sep 2025 12:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C86D88E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 12:52:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AE2FB981A
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:52:17 +0000 (UTC)
X-FDA: 83942880714.01.AAA47D3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id ADC4318001A
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:52:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fgv73mPJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RXpUrw9S;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759164733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8I79+B6ts/ac2HkmgrxFMJSiyZjIy/XCvd3fz9lOKg=;
	b=dr7HS0J9F9QMHtuQrI5Jzie5KeaOqIxp1L49WTFzh9iBbnsff5m7LdnaTFa5NIaQFY9Fdo
	7460OAcKFsyQ/39R+zqPgxu7jCrMO5G9Tjy4mY9h3+1syQIscdkKlwoEje5762rywNYVYj
	UoUqi0Oqhas+gmwnspmxhxWDoikaWlk=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fgv73mPJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RXpUrw9S;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759164733; a=rsa-sha256;
	cv=pass;
	b=QaahFSr3o1egaMG2o0gTBrYc7x7HyJnIWX+BLK1CEMwPgX3F4s9x7yivU3TDCvN0QkdzLs
	9Bjylo+RoGEWGoCElLAcYoX8b4vOzJZVaeWs3T2mdrgnq/WGuuMky4B92a/qm4bjfcaSN0
	R8JtOroVV0OQcu9Abxxvlzncm+oyoV4=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58TGih69025095;
	Mon, 29 Sep 2025 16:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=G8I79+B6ts/ac2HkmgrxFMJSiyZjIy/XCvd3fz9lOKg=; b=
	fgv73mPJmiKyWl/eDFA624b/UtMxewXAk3djDFsluXnBYEQqG8Cf4o571K/eVeE0
	H1CJbtLms6lcHSPKSHyOa43jlHC8nNsvwi166EVXx27JpgLK1C6OXgVt25dP1Ulj
	0zKaZKipiV8uvUY8QP0K9hCcUEBVQRJtaOUC4kg41HmPwEEPCVbOVGnYMRL/3sKc
	MmSLWSyGRCFT6jGfqEgK5pMxtg1AU/TyCHt25O9Qax0N+qrd/pv8iZUYIwFbKbBY
	gb6Y+5SWeI5juLnl25MtRzx35Zh1unV0mN1PI69uOmFHZ8hGOU+GrUxiyBYfxowU
	/ajVhmbNjO5W3sJ5O0SmEQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49fww5r0hg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 16:52:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58TF6Yl6007200;
	Mon, 29 Sep 2025 16:52:09 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010021.outbound.protection.outlook.com [52.101.201.21])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c7q068-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 16:52:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i50I8o3Gd3OSw/A9rZGZhxMq10utjNv/GlxNSCkQcDndibyk0FmJ2HRrhUnBekoUijaiUBvkKsWSjU2WjU+4i96QBWgduMDqtH1B7uveXJ69A2Dm8roVlqmv7BGRCnViSf/PKjb3W2dm0pj+Qk5QupKH1cxtIq+YV3dvvINrJOq7LRhaD3TR72JnZXWeF4tikwpGutsx/M9bE68Juzm5E3di/f+0D5cG28M8VR13DLkPuR6VEwFL0YVGa2OU05Zyu7KG/dptgZng7k7ER6dElVf1UQ9QSDu28BG00GVdz0swY7J9NpLvzWAeLOn1i1bVbMaTrshQRIf8a1ybQyL2xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8I79+B6ts/ac2HkmgrxFMJSiyZjIy/XCvd3fz9lOKg=;
 b=nIT/Yn8JBegr16NrwLeWmYmu3jbOABTrunlaVRAMXPgGCGHcd97TzMoPG1Pk2Cch4+mCTIxjzJb3/dPjkVP8vbPzVRZ5j97zlA1k591bq3YZkBE1BqYhd7361vqk+fbXRVFvfiLgBY1HmkS71oQh0hzfCVHQhF2jTTrCQlp4WEdlW740K8C0yH5gwwangiTQStJ/aKoq6AKK6JjRTctpYZ1rG42NVIW+OKbQRZy9G/lVwhft91MToU0ZKXhvwkor6RRX31tS3fVKV5YhhocRV6+b0c5ICKBQ0JAO2SL7UqwgXT9yymEvAp2TpJCwA47SdRuhLKBxgbNGUvTx5Fu3tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8I79+B6ts/ac2HkmgrxFMJSiyZjIy/XCvd3fz9lOKg=;
 b=RXpUrw9SqJ2RUKhspns3jOHlcwtp5DAT4rgwhNI2lAK54SYY/eHBcg73B9d7zRyXZklh49DjU5bwMKFTf1GcMsg65di26TCe2X57XDaz8pYyaWhcApLQ9C5W3QkDZ5FSzYmO2pDpnm0ko+5qDIboBciyd7ZpVQWoN6OwcCaW1Tc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH0PR10MB4923.namprd10.prod.outlook.com (2603:10b6:610:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Mon, 29 Sep
 2025 16:52:06 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 16:52:06 +0000
Date: Mon, 29 Sep 2025 12:51:49 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH v8 21/23] maple_tree: Prefilled sheaf conversion and
 testing
Message-ID: <4oaulium6rn7xzio3dg3lxjc7qrlt27dl2bs3dlmmkytjkiqlg@zwphzvpirbes>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, maple-tree@lists.infradead.org
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-21-ca3099d8352c@suse.cz>
 <CAJuCfpGBg7xO6-swzvk3vLhMxO+F=C6udEiNmAAC6LEA7vA9=Q@mail.gmail.com>
 <e8735d27-2917-402a-86fa-7446b1acbfcc@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e8735d27-2917-402a-86fa-7446b1acbfcc@suse.cz>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4P223CA0028.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::33) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH0PR10MB4923:EE_
X-MS-Office365-Filtering-Correlation-Id: fb96dfaf-7337-486b-7307-08ddff7885d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVgyQWFuL3k1cFdCdzVudzRRbTRGTEszckFYUndncXJ2R1lYb0pDdUs5VUw5?=
 =?utf-8?B?QmZjeU9VUmltejE2YmNNZ3JkdkJDMUc5dGtUU2NnUVNvR3k2TnR3cmV4VTJ2?=
 =?utf-8?B?OWp4cCszelJtTERRcWo5ZEJOTzB5dUxoaHI4NEJVWGxQNnFIV0d5RWF0ejVZ?=
 =?utf-8?B?cXI0MkpDcVRQQ1RHNVN3cFowdHZOWVBYVmkzM1JpbFRoamQ5SWU3aXh6Vi9w?=
 =?utf-8?B?TmU4Wk1iQWkreWIrWHBaQllRUWZvSzRta3I2aGw0b0JWcVhnN3VXZmZseSt5?=
 =?utf-8?B?a1BMbjIvSVVCVVc3M21tUHE5T0pyZVJ5bXJvMVBpZXZqdzRTazZiaWNUUzQz?=
 =?utf-8?B?SERnalhlSS9YYUlQWW9sVVZpY2xaOXY3R05NZDlTWVZIZ0xJeHZpdDViWllo?=
 =?utf-8?B?UjBmQzNJOStKNGlkVWNkWnRTUFRvYzBlUjByNlpiTi9tYXBINFlsM2JqUnAz?=
 =?utf-8?B?OUx2VHoveDN0T0sxKzFkN3h4NEVzeitGazZpaDFHay8ydUVvTmZWb1Avc2pY?=
 =?utf-8?B?cGFqUE9UMi8xMFZCV1d5bTJHRzQvZ2VjZnU4QnArdURtbHhKT3hWcmtZNi8x?=
 =?utf-8?B?Lzd2WllnQVR3dVBFVnRjYUgrVzh0YktwalpQZlJtQmI2QjNKWkFxYlNJSHVH?=
 =?utf-8?B?RmQvZXg3bFU4ZUVmYzlSMndvMXd3Zi9jclVRaEsxMFZTZjZIM2JGQW91dlFv?=
 =?utf-8?B?djhLNlVFNmsyM3RVZTF4Q1l2QWliK1VvUUQrMUpITG9tY0Rob3RHNmJocWd4?=
 =?utf-8?B?WENGeXFaZkU0NlA2SUpyaWt1ZHR1Q2I1bGJ6SEQzS0M4ZnJCdzdnVGIxV0hl?=
 =?utf-8?B?UXhvWHN3TEJhcnpqSXQ1TDlod3UrSCtqQ2lkaEtpNXlxaUo5RmZTcXVyZzRz?=
 =?utf-8?B?VVRuRzVBMDBTNjJFR1NLL1BFdXl2T2hLU21BeFFFeEtNYmU0OUozVU50T2RU?=
 =?utf-8?B?NmgvQTdtdDBOQTc1TnpTYitLcys4MTVKcVpWc01VMkdNeit1NGx2TlZXQjM2?=
 =?utf-8?B?NndaZFJMTUxLb0REVU1FeS95NmNxOTduRDlTZUlHT01ZMWttc2Y2NWpzSmFq?=
 =?utf-8?B?S2dLZ1o5WFZpbzU1OHFPeUtsZkZNWGpsejFYRmRieFk4a3VFckxHU1d6T0tv?=
 =?utf-8?B?S1RGcllCOTUweUcvRDRpd1ZYd3ozMWtLaks0anh1blNIblczSkNnM1FRcDFF?=
 =?utf-8?B?WldRNGVoQWF6bGJEMU5Xcnp4UzF4TnBYR0R2TGlhM2hML0lxZGQ5dWVzK2JF?=
 =?utf-8?B?UVhyd1dpcXlyU3Y1U2dKVFBTTDRIT1pvd201dktVTjVIQmJoMHREMGhiT1d5?=
 =?utf-8?B?UytTdmRqaWxpejI5MzZaZkszZnZXSm9qOW1lMC9tSlUxM0pPcnRWK0c2a2dI?=
 =?utf-8?B?THhkQ3k0czZub0EvdjVZVDVZcnV5MXBjbHJhaHE2b0hsVUNsZlk5RlUwR1Qx?=
 =?utf-8?B?b05NWGUxWFdnNFcrTHZ3cW9RaWtobXpldERmT054b1V4ZXcwQzFnejBCYkNJ?=
 =?utf-8?B?R09UWGdGMEdDNUw1cEJNUENxd2hnMThKWHBTQ2RkNWlDWllkZEFFS3VsZ2Z5?=
 =?utf-8?B?V1N1bEpzRjkvNEJ0cUVrYUtXSm5vemx0Qy9UaEhOVWgrd01ZM3BtWDYyZy9W?=
 =?utf-8?B?MHlIR0ozLzVnaFJpckl5SHJ3Z2Uwd2RXVWRueDAzcEcxMkhQVG5YVnVXRTJh?=
 =?utf-8?B?Lzg5SEFVMjhRcDFRbXp3RjZPU3U3U25xMldkWS9ZVElZdCtMRkdlbGFvSG9k?=
 =?utf-8?B?SnlDM0Z5VjhkNnlpQ3FYU3VWVmpKTlViQ3ZDOXNmVHFXbjFqR2w2akpFZWNM?=
 =?utf-8?B?WlVNbmc5VGNiZDYwUDF6NW8wcmFNbUtNakV4bmxKUG9FbjRvQTFzRkUrM2ZZ?=
 =?utf-8?B?N1Faa0hkV3hVOHgxTVI1OG56alZyQUdRc25XOVFOSVF4R24rUzNNSlFmV1FC?=
 =?utf-8?Q?17d2qKC7Ph9q+Qj4L1/bwkeykHlTyJbe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWVYZEdhS0d5MTE5R2ZQbmtsc3hVeFp4QmpicVkzV3ROcFNYVXU2QzZiMkI4?=
 =?utf-8?B?YjRyc3NSYk5PLy8wMU5MUTJlM3ZEVEZCVis1bE1kMDJOZWFDK2FRQ3RwRy9G?=
 =?utf-8?B?Y3FDdmxQeWNTSnNTU1FZeXBUTzV6cGpmdzBuRmNBeVZqQitjNVFBVlNXb1Ez?=
 =?utf-8?B?MkJ1eTR6OXNlVlNsTGxuZTMvQ3dodXFHVmNBdU81YWdGUU5LUVU0WFU4NUdH?=
 =?utf-8?B?ZVlMUHRmOHdtbTl3RllQK3ExNjVqN2x2S2ZCRjMrQnh4QnRRekdYbXNsbmJ5?=
 =?utf-8?B?OVUxKzRUWU4vcWMwTnFKRStZcjRNc2lJcEFXZllybThBT1o4eWdoM0lQU29J?=
 =?utf-8?B?WHdCWnVXZ3NHTnRMdlM1UVNmS3I0RDlyQU94T3JQQWZSdURuMEVkVEptbkRz?=
 =?utf-8?B?M2djbElacGxsUlU0cVlmWmEwYTZ6MWtLWVBZMXdrZDVLZlNFTTM0ajlvYlhG?=
 =?utf-8?B?elB5MDhBdzdlTE1lb2NPa2RnWktJZGlwaGRrWWp0MVFWWG81YWpqNFQ0Y3hl?=
 =?utf-8?B?TDdSSFVQb0dQK2d0ZDBNQzZ6UEtMdkg5ajJUWUdJV2piQkVWQlVsS29xNEtH?=
 =?utf-8?B?amQ0Tmx5MTNMdElsNmF5cUc4U2p1M0ZtWHN6K2xNT2JSY0dKUW50OTA4RFR5?=
 =?utf-8?B?enZyMkk5WkFLeHQrUjJEd1VOS2dJZmwzRUR5TFM3dWNEVFlhRUsxSTI3ZjNM?=
 =?utf-8?B?WXVXa0RwdE4wakd0eWxQbEdYeVNuQVVPNW1OSHBReFlEWGFjdDBmYVZvWllL?=
 =?utf-8?B?NlZSa2tjSnB3a2hyOEZOQTBkYU9NU3JRQXVlVE1OMVhLVklCcFdoR3lnT0dz?=
 =?utf-8?B?b3RxL2ZjQkZsTHJ2cmliaDNVTm9qTkhIcUVNcjdHM0hxQndZdEVEeHVVbVVu?=
 =?utf-8?B?RG5MYXlQZ1NhZWtMNHRHamVURnVzRWNpcUV2dm1tMjQwcUlIazlVS05QNFF0?=
 =?utf-8?B?V2hnU0J4ek1pUmQ5KzdDM01BaWNUelIxNkVTc0hkVXNNY1VsaFJvbDFndGxn?=
 =?utf-8?B?eUplWTdOZ2c5UloycW1ScThtLzRPOGswNDMvSTA2b2lKSGdBdHNHc2Z2YzFJ?=
 =?utf-8?B?MjFtS00wMzcreVlTeDhycEJ2eE5BRDU5N3ZhNDVXSHNYbEdBWVdBdUlKUnVu?=
 =?utf-8?B?eXFsT2F1TVJlQjBSQU02eWhQeVpnY2RPT21Iak5SVjRPRE9nZHI4YVU2Umdr?=
 =?utf-8?B?VytZeEpyd2s4Mk1oUzBvdC9jNjcwemd3ZE94QWkrdDNGdVdYZlJYTERaUyth?=
 =?utf-8?B?THZhTWwvdFRkT3Z1T0psb2xyVVZsMnI0K0k0c0tLWEJyRXltK05sSStkdElQ?=
 =?utf-8?B?a28yQTl0UGdaMHF0a2lUYi9QZTh6YkdmdHYwblE0ZllOWEpqYmJQZmJ3K05j?=
 =?utf-8?B?WXl6ZE5vNTN4eEtoTjNHMGpHZjA5UlBUdWpGeGxxTlNlWE1ER2FGU1FBRXZs?=
 =?utf-8?B?aXdoUThCNzBWZHgvUHlBaitaWlBqd2RZSFl1WC9uRVdSQ0xSVGVXOXRrYXNT?=
 =?utf-8?B?Wk50Y2Qrek9zcFg4Vi9GUmZSZHhUSGU2dWt1ZDEvdzZtaHBCajhBbkY3M3JI?=
 =?utf-8?B?UzRUNE5MU3FubEorQzZTQ0F1WGttNFBDRjVXalhuaEJRUk1YdnVRMk1jT1NL?=
 =?utf-8?B?VEpwMkx3TG5HMUtGWjhNQzluQU0ranRHcllEc3RqMHQrSUlyRGd4THM3b0hW?=
 =?utf-8?B?UER0Z1FqeVJYQWtZSEcyV1RCV3hpUXZVNU9zd3BpOXpLRlVkdURjbTl1dGxu?=
 =?utf-8?B?cjE2NFppOHBDRUFVSU9JdWVSRFd4dHdBVEZkZUl1bm52VEd1UlhIRHlYUkQr?=
 =?utf-8?B?UzBFT3dZc2ZJUWx5SkVhaTgxVEROblNSSWxGNXZBMDR1Yk1kdEhwZEF0eVI0?=
 =?utf-8?B?dFhUNlRkSDd2ZG14YXNuWjN0R0o4TDMvTG5PSWFWdnF1dnRZbVA5NWFMWFdO?=
 =?utf-8?B?NW1LcXVGSGwwVnBwbVJwbGFLNXh3WkQxVkRKV3JhTlF5SEhENEltWHhWb3hT?=
 =?utf-8?B?bHlCKy9vUHNtMUVyUkpwT3NJYVZjZkxnRGFoMGhQVWppYlcvYTRlNWxabEkr?=
 =?utf-8?B?Y08ydjgyc0JXbXUrVkJ1aytIaXFIUnhMeUpOR2E4VFBrU2kzYzYvTTE0Wk5H?=
 =?utf-8?Q?JU4JDRsHi7UTzGG9MT0Zya/HF?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9RaggUnBE7HNO3QunMxFIMRs7WtIIRY7h/0HfuvzxJUEWoNhckv1MtxLWANDMHuuPpKASZilghlIa6gKdMeHzPjpfUY+dSGLQrXm1vjvYGHSQg/V8f77YUgKns8w7O/woF9ZfUttdAacTT8y6ZES/In1Y9wSLj9Qltqvqvej5FgS4+eM8qZ3Bu1ZOGz/2z2wJh7tLm7nnCgbfvH33H003Zx/AcRsfd0FPO+7opHiGRTHMCtJ3O/HtolEHbnUO1abfD7dSLrZG/WOR/BmL+8lYOfMqnfw/H+ftU2SDKfaknRm+FwvyeRFANJQ0L7k3Mkk1m5JdE1y+L+WjNYOq1nDL1JcxpT3fNp3KBPkbBt8nAfOxShSKq/JaXp0e/TyjgLMmBm1XWfTlbQmA4B11xENY6BrRt9Pprv7HMrkW585XacyrTYiCuUDUxCUZgGj9knJ4sV+P3tRvejyY3NhqF0pAyBKU3JxqBDMSbXwbV4a6uwQTFPRhb4NlAiKZ6Kb9W40KyCPGfTT3EUNR6Gsk1De63lINoxMgx6S1Tc9yGXresM0wZymgUKWRnMvcPTJyaCojPLvmdgWXLOCMtqGQ32FA4ZKB2rMivC3aMyCoCt8aUE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb96dfaf-7337-486b-7307-08ddff7885d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 16:52:06.5863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5+ht6v5a6Y1CBSjtkZKqgqbP/yk9srdERcprocOuH7ZqirGr6vevUSgT6NtCkwDjDZyh54k+DM3ccd6I8WvCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4923
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_06,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509290155
X-Proofpoint-GUID: D3bj7lEavw4nJozY5ZErw7iuk3CwVEJ7
X-Authority-Analysis: v=2.4 cv=QsNTHFyd c=1 sm=1 tr=0 ts=68dab93a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=wHLx35uWOvnqBeziJd0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: D3bj7lEavw4nJozY5ZErw7iuk3CwVEJ7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDE1NSBTYWx0ZWRfXxDprNuImPM48
 2/TJ8hJkJeRvscbti2qNSkCwfvFrZcx/heW1XjH3ULOujJQ4t3Zg2uC0nNV5dswv1behqF05uny
 TijXzO6VHJSks/uvf65XOyrTUvuR5h9gmMmOBq7Ovm5op2GRvHXI0OBVWWrHkMMWQTUPKQr7sen
 FW1eSRfq2lvhnrCH7FkNPgL+U8LuxY3s4k0Hk5i4HPCrqmyqV5fZgU0fKGR0kQM5TEqNLI33/QG
 T7ejqWRm5HTRQrqjvzryNbXowfRzBj6YIGkWyZtGhzzQcErUcWFhrdQ/K1FBYd0FTy+Fju9b4w1
 Y26rvlHVqSCbEQsvrXtybJ+ehq8EXbI7UF4ncvuVf8Y2mBxRsj90r81fKAJ10o4Blhl0uAkDI1F
 F40ixcAZplMrKM2voxaB8NWMnpTq5A==
X-Rspamd-Queue-Id: ADC4318001A
X-Stat-Signature: iqnmxm3jbfrzcyc59yr5u9indknt4768
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759164733-666067
X-HE-Meta: U2FsdGVkX19wVLZZtPJ7tO6ZsnzotOD4r8R7L7tBK1pJgbR8IiJvhXNUrZVQ+4VVjv0xfRERjwFftZgeBE+ZeueotfmkjYEwxBItZt5xpf9eGIQI5RWRC3sEpuTsrQxngzYon6LryCL9X0ti1xyYtW97Adi2JdrbLVnGVSfptVjFpxcSPpFNrS3Cv4P3trHlADZTbyEUYT7PKLHL8COg6Sw+K2hmA2PZksAshN7KDpftAFSX/tF0DII2s0ljp+jq6UFykHosJXbefFWhLrBkg1R+lHEY8eiR3He/aCdYGgLMhaYk8hBoH7PvRdEg2N/G50oafpx8E/UJjodK1xSaug2TWUiwDT0/ndqPHkjuOWPiLKixqzYcCR527T7Tpx9MIgkpKda4B/8H36IDQtpC5sstu/P8h+YtrAneQ2p6YnFrYfhwnGFpn2akQFnQF7Q1qlbtyttP6+eezk2v71o7zEMXpnLGoyTiaWhvYFHyCKmKw7pOer+sxqGpWAGkd1O3lhsTrz4gjCSdUh8eUIcEluVvcR2R+NK7Tfi6VHZH4MsbyVPTljBcizQ99M0GiuxTLa91NTPXveTT+NoAWMtwX/kQNgKWjuDoVDSI/U2cWqU+VEr42cd2oKGUQaMFuHLyGUk0BP1lJTfuKtpyEX+JQpjkxPsYZRpmM1BHuBqjsybD0Dc8Axb/80iLQPvT6lD8Yh4xzQu4wTlEFxAMoQZCPsUpexWYN3grNnkgW0MCWSYNsfqAYjTq/5BlBzcuyrWG6fBNplo5lyrROC24yLBlecR2RQ8+VEv00ZmO4LcKhWcS3x3Mg4wNmdSKipnKM4Ptupp+ESGEM2Rz8jmNsSIskt21Tb/+8GPl70GGhW0JN24VYR26tA3ytXkXgit36MS5a3qsx7cey3UKXT51nEDvtlsNKc1KYMYh+NU76S4gn4gkq7E2cKLy97tSy42fLSiSeGjAT6ZkRFoqNhtnbtJ
 b/eJ8tM3
 H+rZP95Xh2+N7ZVFictlkZf1zgz5BMEywGRkG9ZKP7OGbAg9Omy6cTTgUQLgh60THRhfkjKoktw5jJLMS+G+AWhm1vtOeyht5rM1P1kLT1aR3BXz3iTyYu8hDyuhN5Mw6jwra3t3ZLP8GNDpip8bDb5hRMrmNIH2m+VNtOWW32chAaYUPNXDwIHLKyJ5igxfRIdsn7Z8nZsLXdk8efMAJ0D8T5DgHVUual5YvOnEU2AY7iQceyCM0v+K9Y1rQD+mttEQi9Iti1q9YDdjPmu1jnG7qPtGH5i+ishSfofLCKRA9DAFQPmVi1NhN+oagnF3xpX96DvONOQmCsP/9YKVN8E450zlis1zOlx3g8mVZEsuQyyrpXhr9xMbsUoDPfEVFA9vLTr0UYqfZTTbWuPoDyb8sYYdKmOjWee8mMjctKeFef3dCmS6Rzdk8OaX9F6a/1LAdp2hB8KDQx3TuHHaXvBWocMiJJ+hERY8/pgdb6qG9uSca8ALJHnOXBEeEST4x5iY5+NqagiCXy7tojIRtrgaHzmVz9BNhiYb68Si2qc/uJrVUkzTxf95mwZ9xEVgOiXFM93DRMKdmvrlcPzLQIh6ZbZ3kBYeMpzosewFBUCQ0SOgw1MjI1Dv0zpaSFgzWOyG+JmyVCrnhZ/wmPJO8AybxfKnNOgbl+YVfTdJtzAgk8x4OaQgiJnz8DvWPL+ZUO42OEM/welNanvL70lqBEzDGvU/BjI72pNqJWAgJk/F/IlAGDf1M09FPww/JsizQVutKTk61bFchh9U6ZRQiKLiQLe1Yxr4BmNXSD8JDuvJPx9JBVRY3vagy/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Vlastimil Babka <vbabka@suse.cz> [250929 03:30]:
> On 9/27/25 03:08, Suren Baghdasaryan wrote:
> > On Wed, Sep 10, 2025 at 1:01=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> >>
> >> From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> >>
> >> Use prefilled sheaves instead of bulk allocations. This should speed u=
p
> >> the allocations and the return path of unused allocations.
> >>
> >> Remove the push and pop of nodes from the maple state as this is now
> >> handled by the slab layer with sheaves.
> >>
> >> Testing has been removed as necessary since the features of the tree
> >> have been reduced.
> >>
> >> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >=20
> > Couple nits but otherwise looks great!
> >=20
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> >=20
> >> ---
> >>  include/linux/maple_tree.h       |   6 +-
> >>  lib/maple_tree.c                 | 326 ++++++---------------------
> >>  tools/testing/radix-tree/maple.c | 461 ++----------------------------=
---------
> >>  tools/testing/shared/linux.c     |   5 +-
> >>  4 files changed, 88 insertions(+), 710 deletions(-)
> >>
> >> diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
> >> index bafe143b1f783202e27b32567fffee4149e8e266..166fd67e00d882b1e6de1f=
80c1b590bba7497cd3 100644
> >> --- a/include/linux/maple_tree.h
> >> +++ b/include/linux/maple_tree.h
> >> @@ -442,7 +442,8 @@ struct ma_state {
> >>         struct maple_enode *node;       /* The node containing this en=
try */
> >>         unsigned long min;              /* The minimum index of this n=
ode - implied pivot min */
> >>         unsigned long max;              /* The maximum index of this n=
ode - implied pivot max */
> >> -       struct maple_alloc *alloc;      /* Allocated nodes for this op=
eration */
> >> +       struct slab_sheaf *sheaf;       /* Allocated nodes for this op=
eration */
> >> +       unsigned long node_request;
> >=20
> > No comment for this poor fella?
>=20
> adding: /* The number of nodes to allocate for this operation */
>=20

Thanks.  That sounds better than my planned /* requested nodes */

