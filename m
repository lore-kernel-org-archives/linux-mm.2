Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 077FAEE36AF
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49AB76B0088; Thu, 12 Feb 2026 12:49:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472526B0089; Thu, 12 Feb 2026 12:49:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320066B008A; Thu, 12 Feb 2026 12:49:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 18C0A6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:49:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BCC0577C3
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:49:32 +0000 (UTC)
X-FDA: 84436541784.06.6B09C14
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id E0D6C20011
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:49:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JiQ1A3Tz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="rJiLa/uU";
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770918569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UlYVfKuj79bc6Qof7i+/XS+KbQ2v1acVDrit9Q4Gjrk=;
	b=BC+5fhARNFW0jwfCS+uGHVjDnPWDj2faJ3vJcJ5rzSrzmpsrCh45jfBazRg2DlXjBkCj3e
	eBSfpsgxZ+Lmq5i4sRiCbZMc8KNBRWhdVzOSCIG+rlhLX3AEKjUKlezsTtHVEfSMIJemgK
	GZHpBUlCw8nJP5ZfTI6UwXb3SIYCPg4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JiQ1A3Tz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="rJiLa/uU";
	spf=pass (imf03.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770918569; a=rsa-sha256;
	cv=pass;
	b=ohSFXCroDe6BlrahOjpW7mCVZMPTVIHLNkEhX6oTmCOh2iqOs0jt2gcQTBFUK/l5+T66jb
	RjBy6Bto4lZDkrUb5R2bJB0jnBdrPDwGwktA96rfNSDYmMdJ077oX7xpu6x4f30WuvGwpD
	8eC4H2ANpUC/i7Zpa+z3fXxIFA3gakQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61CGNBG6591591;
	Thu, 12 Feb 2026 17:49:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UlYVfKuj79bc6Qof7i+/XS+KbQ2v1acVDrit9Q4Gjrk=; b=
	JiQ1A3TziRYSkCSbC1DV4qfG9CGJjo6sKHDTl704NztdBRHy0kB1toku6T+hoedg
	CaudRJe7DLBuOMUStpmCAT05BRtJ2iI6bBEVxVPHvO8Aro6UNWlZELvqq2DX57XC
	UYZBWQmktalhVRUCtxwqbSvcn0wGGTs5wFB88UpQsmK21BefiEl0MGqaaoRu6FF8
	vPx7HLfBBDSBtvhe4DbtprfSiIOen+gK4MWepwCo6LnkzxBY3CgUGGeXyx40mKxg
	4merHhDxN08Nl6lF9D2/v6wIKzK3inYI1BwxR/yNIwhdLOCAybY2ZxqxeGABu5B6
	q1hc44FVaqz6Nf4wtBaacw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c88qt3w2e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 17:49:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61CHH7Kq032918;
	Thu, 12 Feb 2026 17:49:17 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013041.outbound.protection.outlook.com [40.93.201.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c825wr81x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Feb 2026 17:49:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T2ACsFGz29FjT6YJju7MuvpyRJQsouenhKtNh8YbZyHqmvME0hnmIVsy5G+51QFlJfNgAjH7IFNhYIQtNtdOgQi/XsNo1d9zN3Pf1+SGv5YxxAmgpYOUHF+Ad5eB6tufydvM96JTaW7e7c50Kbx8QxobQCF0LHE6SVrMek/CST/jWQUjxXy6bPRTY4bPSsT9Gqsnqhd7IyDJuum4MfpsgeE7EJwAxW0nooouDDYoxT5kqR/mL442UFjHusF/xhNCvaZiitBvXet1zgkyjahtaSwEvtGLK2kIJaiP7jycj7CPst5RfC1/7kT7VRru8yX2GtgPnPVJLb6g1MFpTfYCSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UlYVfKuj79bc6Qof7i+/XS+KbQ2v1acVDrit9Q4Gjrk=;
 b=Z/YiqBj7RJ3SRwGCKQWLU/ZbcSFdxNLNmNxIuen0saxmjCwhb8Q75JHBaypFo6EVJedBKbGtD3Plua1y3bKwX9ENBUClK9J23ghYwJPVKroLkYiBDcgs6yBTOse2Tho5XStpJSswUa7JxtQsrwuJM1dBuC9oecjdsQUH4gZK9iQxrauLxsdp4aXkVViWp99tQG34wTqb3+hEJg3uyNm5ZbjRKUUrJrzUE+caGl+OWNER6aZ9SX3xFAvc6dA0LS0YdRfxFRp+96hWcfy5duxzVWQA+MqE9npXeXQrw7GotAeAz3hWN8fy7uxpTbHt5IGW+1fB8foDPe3OMDfENmuDJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UlYVfKuj79bc6Qof7i+/XS+KbQ2v1acVDrit9Q4Gjrk=;
 b=rJiLa/uUL1JIKdaI2kLVBZsvB67wUB5i2kbBwnIsx2Xfo4cRDnPXjzk6PC9mtloj3anFd67MjyNB+jLRwzEENSZos5q/6LnSzqz44qfFccmw3F4e9tmm+mXd84DrlN8joXTVHj8iKYBnqkHbt8p1DBcUfQ0KRTFl+mOFWVGF5N4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SN7PR10MB6497.namprd10.prod.outlook.com (2603:10b6:806:2a4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 12 Feb
 2026 17:49:13 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 17:49:13 +0000
Date: Thu, 12 Feb 2026 12:49:09 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Tamir Duberstein <tamird@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
        Danilo Krummrich <dakr@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>,
        rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
Message-ID: <aczcvsaftsh3oj4e7xvm2e2m6roytdy4u6zmh66p7fpzr3npvl@ft6cmvlogsvm>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
 <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
 <87fr77viat.fsf@t14s.mail-host-address-is-not-set>
 <fU1FEYt6-SY0KlyJy4VClCr5j6P4d5-wukzc_9TkSDSBuQNlY26xyOIprMbHEVMv-H-nrAJ1iN_9tcfIXEI1iw==@protonmail.internalid>
 <gta2wjt4tkcvyu7g56gqyipiigbmbk2ca3biqzmxc2npch3rk7@ccwzwgnk7mcz>
 <87y0kytggx.fsf@kernel.org>
 <87v7g2tesf.fsf@kernel.org>
 <_ZaFqe4HzW4GSDQTrXKDgkSCr7L9bxUh-h5QPqVlMUHSvE0oRFuZJOPi0JItf3VJXHmaX4PA4QWAGBeG73cJYw==@protonmail.internalid>
 <CAH5fLgjfSWfhUkmG6_ugue6Wp5LKtkEFJofWViJSNByq3sO2Sg@mail.gmail.com>
 <87seb6t9t7.fsf@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <87seb6t9t7.fsf@kernel.org>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4P288CA0073.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SN7PR10MB6497:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cdd2c9e-e65b-443b-c4ba-08de6a5f08b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|7053199007|7142099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eDlJNHg3aEduN0g3WjI0cWVmVGE1RWF3MWNLRmErRDRzbHBaVUF6N1BkRFh4?=
 =?utf-8?B?V3Z4dzRmRjd5SmVIUE4vK0h0QmhQeHhDWHU4cDFzSEMxQ25lZXArNEtLTkJZ?=
 =?utf-8?B?VTZKKzlmYlJ5UXh5bDJ3citWdVJaNU9aci9CbjZ5UC9VamdYK3oyWDEyNm5Y?=
 =?utf-8?B?YWNyZkRJbldrS2hWKy9wTzNlQ1lhdjFNYlZEV0lYdTlPL1dxTW1HTVlLN2Vr?=
 =?utf-8?B?OUNnOHJQNUk3QkVvTDRTRVNMMytqMTJnQVpYbnNxRGY5T0lxbjlmQzhmekQ5?=
 =?utf-8?B?NG1rajBESDJRRkF1MDRBZ1BQRjNhaXJobG5IVjM5L3FWeDR3VVZWZ3V5cnZP?=
 =?utf-8?B?NVJXeENxbVZXbUpGTklNdWhHRjRHd2dzSXRFajhxQ1M2NEFzU2VSZ1lWSTdt?=
 =?utf-8?B?YWZXeU1lNGFIVTJveklZRnF1aDFrRkRFdlQxSGUvQ3VhNkVycVJGTzY3UnhD?=
 =?utf-8?B?NGpVcnNIeTNPSlNlakw5N043c1FtclNrbyt2YWFBVE8rcWFzRGpDRlhIZTBZ?=
 =?utf-8?B?T0lnamZjak1MZzNrZkZOUGQ1ekhGMndOT0xtblBDVGVqQjVUMm9JZ2Ryek05?=
 =?utf-8?B?c0JINzY4MUN6czliSWgycSt6SjBqZE1vdk1NdUFZcW1Fd0dKcWJ0ZDFMajhp?=
 =?utf-8?B?OHhjcXFYMTZ0RHc0UWlYRk5ZM3VlYVNqZHNuaWZxd0pERTRiWGoxbm1qZW12?=
 =?utf-8?B?dzBnRkNyNDRFSWN5S1N5UlJVTEU1Yk5GRGhsaTA1SU9TOUVpdlEwdVhhYnR2?=
 =?utf-8?B?WU84V1UyMHFINmNBMXAzdnZ4Y205VTRuZEprNngxdk9WNi9ncm5jKzJYdTB5?=
 =?utf-8?B?enR5QnBpS0lxZkRnYWo5R082RHgvanREUzE1b3c5enBvc2JrS0ZSWlNUNmtu?=
 =?utf-8?B?SE05Rzg0Smg4WE9veFgvUzFOU3F4aWRyYUhGdk5IQTFqWmNsUHhzRFpVQ29H?=
 =?utf-8?B?czhJSHRkOE5ZcUV3S2JZRDc3RFdPcE1ZQStrWFovaUVPckI2dzd0d2RSaGdY?=
 =?utf-8?B?SytBUXo4MTFoWm0yLzVWYXdXL0dsVzdqREVaS0N1WVZ0M2JYZi8zQkZmT2pS?=
 =?utf-8?B?Ym9UTTdNaGV6RnJHN1Z1V2VHaFVoYXVaVUd1MU1iSHFYckZLOW5SUFFxZzln?=
 =?utf-8?B?eENxZGRTbCtZaldZais2MXBXdDNCSUFSc3llN01TRlB3MXpkbjVNYkh6aXFu?=
 =?utf-8?B?b0xYOWZ2MjFHRGhPcWVJeGVQWXBjTzdITk9RNjVFMk5ybEhzZjl4aGVlSnNu?=
 =?utf-8?B?c0E3NWVYOCtGekpBU2xwUEZkUjZjZjBSZ2EyaVJvNnRVN3JDa3BzNzBGYkNx?=
 =?utf-8?B?U1FxVElUR0x1dnJUc3F4THBub1ZINy9PdW9IMi9pOVBIRFN6UkJIY0RsRk1O?=
 =?utf-8?B?WnBzdHowZ0VJVHFXdG4vTEdKK1dQdHhLUktKL053dWZ2L3J6YlNNaXFpR3l5?=
 =?utf-8?B?K0ZHalNSQnlGeUlwSW9HY25jdVo1b1VTSnJtUGpOTmVoQ0c4R2VvSnJOSzUv?=
 =?utf-8?B?c2JkY0FlcDY1bElGWXd3Vm5ZRHRYSVZOL0lORStTZ2w3ZlJCNHRuOWZoM3Mv?=
 =?utf-8?B?eWM1NzZIdEs4SjVwbEpCdW11bDMxY2JVeWFBVGRvYkxndmx6SnpRYXZmdnIx?=
 =?utf-8?B?aC9vRU5ENHp1TzNva1VpU0hreCtDcTNwVjIvb0tHWDgwc2ozVTAzWFFoSTFD?=
 =?utf-8?B?S2V4cGpQWFN5ZjMrbzRvUnUwL0Nwb1U3UHNYNTBvWFBqVzJQekNmL0puR1Ir?=
 =?utf-8?B?UnhlN0lNQVZTazFHdVM5Y25IU3hxM296MGtiUG9UMWYvVnMyVFA1NUFURzZi?=
 =?utf-8?B?c2hKa2dmTHdYOHZlQ3AwVTd5MmE5MUxSTE1pZ2VLSkdQR3ZDRkNNdnlnS0sx?=
 =?utf-8?B?ZUZIRnJwd2VGZzlGWVRaRHgvbmRaQ2duVkwwcGttajJNVjVWWjIzVXJJWlpa?=
 =?utf-8?B?L2NLcmttTUpRb1ZhdGd5KzQvTktONHBSeUlLcmE4eDR3VE5kUCtqbldWWUxp?=
 =?utf-8?B?cUxLQlJpUXVRNllCVUlLRVZKamdyb3BmK1cxMTBLakgwUlRlQVJPamEvOVNr?=
 =?utf-8?Q?wmStz1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(7053199007)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEdVZncrTXRycGlJUmN4NjNqRmIyKy9ZeENYbFNQUFlKN1R0UFpyTkxENStU?=
 =?utf-8?B?a0ZQaExsWDJVYlJBR3RZSVI3ZHVHT1ZoWjYwUUp5VkJrU2ZPeE5vMklUTits?=
 =?utf-8?B?WkVXKzNtbk1Zbm84MTVVZWVSdHgyeThqYzgzU3ZoamhPRnVEMUdEUDhuZEpI?=
 =?utf-8?B?NWZpUTNYUnJIZDQxUnFlQ3pCdi9KL0gvNzY2K1FXc2NOOUlQNkNYRVlDVTJu?=
 =?utf-8?B?SHRMbFpMdkxueVo2bHhtQUhVb1JCTWlIUjcxL2p4dllHTmUydDVRanMyRjNl?=
 =?utf-8?B?RWdjd0o2MVpEQkF3VHhQN05hRGJaSGdmZytIV3orQWs5WW9mSXdwRGczZHVE?=
 =?utf-8?B?RjBVbnl1STgwSzh0UnZ3UDZxb2VNRW1aM2xUZGxSZVViNm1nKzAzaUhNYTZI?=
 =?utf-8?B?TEV4ZjZlL1FoREV0M1p0T0ptTS9scU13NXl6azFCbHZSZjREMzBIQWtoTDM4?=
 =?utf-8?B?bDFHMEtnc3czTk1DWTEvQ2V0bVNGUklBSXJwOHNVR3dPRXVoWkdXQXo4dm92?=
 =?utf-8?B?cU43ZHRwUS9hTDV4NU9KcXJaUGthM0djR0FKTGdsd01QOWt4SlloOS9zN2cx?=
 =?utf-8?B?UnN4bkx2ZnRjZmFJcDV3QlNURHAwQ2lLeE9GeUdkcXRIL2hoUGl5ZVoxNThN?=
 =?utf-8?B?bHMxcVhhdXFFS2I4d09xQWk3RWhpaVZ5ZjNUOUQwWkdLWnIrMS9GVGdYYWIx?=
 =?utf-8?B?VERhYzhDMkJBZGZYNXV4bDM0Sm1Ld3ptUzJnRVJsRm85Y1VFT2x6TjgyV3lP?=
 =?utf-8?B?TWU0d0ttMnBIUUNvSGZCTGVrRmxQeTI3ZWtxQlIvUGxrbVJsUXEzUXZRbXV3?=
 =?utf-8?B?YTRlTGpoK1l2S3BkdlFnS1VYdjNybDZPejlLelcyYTc0WlZZbDlHRDdvZldP?=
 =?utf-8?B?WjZDOUUrbmtBYXh2eXJSZmVSU1JScUJtdlFqa1ZvSmdNMUw4a3I3ajdLcW12?=
 =?utf-8?B?NG9LTG5QZzVvWlJsRWRSLytRYld5Y0lGVkVZRGZMMmJCdGdCWFlxRFQyOTJL?=
 =?utf-8?B?ZjNMTURjYy9ZVXkyclliQzg5cFRmUi84N2ZYRkh4STU4RWVSQ0U5RVZxdkR0?=
 =?utf-8?B?b0ZBbzVUZXEyTGZlanhTTE9rbkNiVTNNdWRRZ0JaeW5YcmRMbmJkR3R2Zmdu?=
 =?utf-8?B?blhybWFuaFBVZWoySkFLRXBwcjVVNXU1MjN6VXBUYXl5L2hVZFBFaHFTMGJm?=
 =?utf-8?B?Q1pIdnJZRG04aVB3Y1JXNmhtellTc081Z2J2czZ2ZEdMcVJkYjB5UHpld1Nn?=
 =?utf-8?B?Y1FjNDh3NlZUSGExalEvdW93U0plWTBzYUdoWkY2SkpTZmNGeWpuK3NqS2F5?=
 =?utf-8?B?c0w2ZTYrUWE3b2hDU2RlMVVVRDBvUWR5MG05cUxKVHRoM3gyVk1iKzRkRmwv?=
 =?utf-8?B?Y0ZHckx0Q21QYjl3ejk3dEVXMTgwRnhXdlByc2RUKy9wb2d3NU9ia3VZdEd5?=
 =?utf-8?B?dTJaVG16SkFjYkdLVlF4dndUZ3gydmtoeFlBcXJ2K3RqUTBNZmtBTWlkdTFz?=
 =?utf-8?B?RmMwcm1ad0pwZWp2dUxqQVpwTHBZNmwxT2xyYTZud1NnajlZb1FHVHVXdkNp?=
 =?utf-8?B?bC9qU3ltZzlUKzRsMDRTS2NTVkVTN0VFWGRjcllRNEhZQWcrOVJQUzNLOGdX?=
 =?utf-8?B?NXZ4aWV0akpVbXJnSk5sY0d3NWtWUXlvTHAybHZkUEJnQ2FDUFhaU2JWQU1J?=
 =?utf-8?B?cVNTNUtCb3dyVFBEakV5MFZwS3lqa0N1UFJob3Z2QnVPckkxTmRTZGV4N25V?=
 =?utf-8?B?MjBTUDZ6TS9IVjArMzVkdndxTnlhbTdZbUlOTndpUUlSRVNaaHRLeERCVEFX?=
 =?utf-8?B?cFUydEYwNUtmOHZ0cDRkMlVMcFQ4ZFgra1M2R3NPTE9mM0R6RCswVk9vZjkr?=
 =?utf-8?B?eDRNeGtMVjEwSWVHbVN1UHJnamEvb2p0YlJaMjRlK3E5WVNsYStNcGtDK3Q3?=
 =?utf-8?B?bWxMTEQrakQ5bXozRzJ6dmZycFNFclBrbUQ3V3J3TkpUcG9hTTlLcmFnYmJw?=
 =?utf-8?B?eVpha3V1d2RrUVppYTdJbzVINU1EVUptNjRoeGIwOG5OWDRjQ1lhNitlVis5?=
 =?utf-8?B?ZVJKbUNpMDVxeFpDYWUxL2JONTZwUisxY2VtcDg4cXlVV0h4YytmQUUvNnhL?=
 =?utf-8?B?SmkrMkcyOERoQjhYSmpCS09ESW04SDVDaGxmYVJDYTR2OUV5WWduWDlkYnBV?=
 =?utf-8?B?YkhkcXM0Vm1sUVRrY0I5Vnh6SXNOT0E5eW9tMWR2TWFVVmhjTTBpc01rN1Vn?=
 =?utf-8?B?ZFIwOVZaQTlFL0YzdU5OYzFyZmZzMms1ZmlyODljM2JySkNob2l2MzR0VGRP?=
 =?utf-8?B?YzAvTkJjYWxXbDBXNjNlMHRRMVdkbE9rS0dONmQwUERMSDB4QTJ4UT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d1rVTb3exL1viV2h9cinLx6kPqlGn9ot9MMURc2pFIOGZDMLNVOyZOHv6WsK75Budmuf6WSXBaMecScwtxM9yLwtUV1X87/nf6oNrcakmHSnyRatDOqxjIKQccP9SzVci1wTyVOV9mXOwaRwVd295u5G2Zo8Ei7aNNZEioI14pilyx0mOsbbXoIpxnlh2o2tngUddsiJj6QAbpFqqCgXODwqTedHVPFdTAPjJ5zfPSTp0H9ynQFWH9XNfFlg9fXvUdINkkA0l9MN/flsJIM9rn8gmDwAomcoUqcIFyrtlXsmVKWrg++NAjKtbHu4Bw3c/ZeO5650GBViuibnaxey+dp1rCOZH2eT6XMYwT0XkU478oVUk7O/2C786PrTQk6f9cxhnFNdF8/NDANH8BR5S3NqrvSjanXsxg/cCcdVzSUPZZi5BDNFlZ90eygQP//sA4aLuL+UBSxM2ywjXW7QGud9qnNM6M2/D8adx+PsTtPsX3PXECwvLu6LHGxJPLpI+OhkxMD5XG9yH9ackkIC4RwgEByAqC4osPEm6w2Qmvho+8fRVD0/Hq8sHEdu5vlmjltVnm21XC0X7x1jnXa7eVFj7as6J75FmvAnK7b9Vzs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cdd2c9e-e65b-443b-c4ba-08de6a5f08b1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 17:49:13.6347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Zs0j0AVf+6Sjr/mnYVDmeg5QqZTMoiks8Kn1P8dwWrF0WbV0SXpOXXmvLuqjXHlS3w1Pq1T/s2Pt85+kuZMXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6497
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_05,2026-02-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602120137
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEyMDEzOCBTYWx0ZWRfX4OxX0lJCuAFD
 DrcqZs0FPVF8VF2lR0VG4Ro0Ui0+3dQ3WdehJeQDwXylUQEjjw+tgfGMWTxxWLiYSzBYJIJeIkn
 HBI4hMtt+7Z4way9kT3ns0bW2w6iS5Bo5i0Rxhs0ycoQZbyVzUAfjwW6tOcEe7vPlgww8mUebpg
 tXJkLIHCg1WM3ciEtQRrj9/vFUq1eF17s5neTyj/bTFWhaEHwYRKvySPhO0EJ2upVdUbojB//h2
 yLMyrcH9zYJwfsmH/2kNIJ6QUwaxQ/ark/WE9/PF1HtLk25AWfmpVwuQRGnNe/bRnO5+ji3zLT5
 MzJJ5MPYzuYhNJam5Vi/8/WmvJ+GgaNNqkzBXl4sEK7YkIh10jyjAEYVxlTOUvBSoN9WVcIH/wY
 op8J84g5Pd0MGuzJyae1ZlLWE4JLTHBrg+U5ycVoDgat1WtyisnkpTrB8hTOvUJvC6uUacM1o4X
 9svDfmgXVTWVNY+x4vqDDA8SqlmeCxmQV3eysNTY=
X-Proofpoint-GUID: uOVHODorFaHVVRu8iMeGYy2CaLdWE71g
X-Authority-Analysis: v=2.4 cv=Mehhep/f c=1 sm=1 tr=0 ts=698e129f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=ei4SEBeUAAAA:8
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=vji9N4qsLVInzn_tHR0A:9 a=QEXdDO2ut3YA:10
 a=8zIOOLb7Ym0NljyPXbuS:22 cc=ntf awl=host:12148
X-Proofpoint-ORIG-GUID: uOVHODorFaHVVRu8iMeGYy2CaLdWE71g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E0D6C20011
X-Stat-Signature: ckqcpc7g5x1h1momortid88wp7oe3p8d
X-Rspam-User: 
X-HE-Tag: 1770918568-773913
X-HE-Meta: U2FsdGVkX19mNmuTfyIoSICzKNSBSYF4mFZkflUplCxOknn/9cUx09c0vXmxWQuna6c6la/jdQ0lRu4bRss5j+Q/JfsQxiBk7E/45OPWCX2XfvheXcKzGZ1nxRqeNbaedR5B0aEFaIqXiZoscs4KbRIEj9SopQyXf2+XYFgYBblT9hhtQWjrB+zJuevK5K7kTo1ZAUmPyk7swP6VSKYUMiEbkD+wgP3/CqgtrFpfiQCMK3VXp57hWgatlocZomU1URFam6McB+vDUPm4gz88ZlBEJIlEH+UFy0zQcttvbYiRdEVSgNMxFHxrdzZ/zctsOZ3y9WsmLeow7nRcXWNWRqN+uWqQqh7O6600If6b0FV4b8ZWun4DWzcaQST5dTW9oFk3xHzZNF7jYR88ks406WuGr/7XzusLNRM68yfohDQcfskrKslHCPNOXgz4ti/fo2DJKV2cg2wUasMZ4bdv5mDZhemJXgLfMLZADvR74rw9D28PZ6cllBHyUcrL3zD4OE3MYlvmf1v3Hvwfn7tchxR3qdd2BmEE0EFyswy6YZeYVNCU98GvRmrY5CDCygbmgg2sX5FKDxlofGdMo277zIt0c5BOD0q+tUQx2/Obyky67V6iHrm4Q5X1AybbjOEovbPgE0IuGVGXyfrgFtmc3vPaaOxr/3S/eCScCHShYElyL956l7g3PhbQE5GxsQI6FGlzOY90a6pd3wCTPzxePLdfbc+na0RZRkTnD0TxYLfJAzuw2UmKKfLfRvxZJaNPgfQg+OcJbb/u87qIX30BxhAraQN8AEK4XlwidsvmneFf248BPcujbgEa02VOt8fbk6ecnrjsBpf1bfbypQ9vCOzFS9xNobbPlVW6ieykDUNuYSPuy2YX5HlmhVshyQxQjYqRszxux4MO1ErFda9XjQGZ9IZ3TwOi+SmfiPucaX4eh18ZqeviYfW6LBlCyYOk4FSBbXH1oec09YlJw30
 eDzVgRHl
 sZ5Cd5T4fsmWfc11dTYcO4OWx6Z6KevWQ/u4mXdE+P+Rh6fde/EfqiEcuz9CI/QbENIHN+beugD2dc7TZ/pthn2xxH3stUMEZvE0NdJcrGfcuDzW9A46Hn4OGHxSerrq3GtcgBDGo+PR8DNL8PWrIApaJhnYcRjOfac2VwmBkAiDgal/lm1uSqpCHIh/4VnzAGGoowFi90OYGFkX8ov3q661ovPMTu3Ijx9tclr4df/MWH0bHx6rQdGheAzQKQzrw8/qLW0d34gt+wm7oK/IKtDeqaskNbx4/KM8kuLZAW4lRNwABg8Aox2yxSw8aRIuCWlrhAIRUmO11pe4F9wYEvjWeJkxira2al+JkYfdNhFcYOoUd55QIWnC58mKBm94eAgK+u3OMJVbko/Je8l7BIKIF50cdqdDq10tAjE9QaYDOnLZqcbjbszNZl1F4YPEmvTXd+RwgaeJzWgdMQvmlJswGTA6bMv1Eyt+W6g5FfLSLc+9ZZNqlVC8PGEU7Dw+CYeDe6P1yKp34FAI7xcPW8FhT8xsZalV5nX0amgrWQo/KYopIma1aiZ9N8g7kCigKPi0bv3qj1BIHqbCELnI88OloxJeLxBP4ja5ElAKKsuRjClv8Col5/S2AtNI7073Y/ZnAgQlTNes3uZOzDB4GAge9jefeowFkw16bqmy34P3lVBgguz3A3hyosGc3Bemvtjn++S8IiFuKx7RwsRpZ232YaixhwtLTTTLFXS6Np6NkhXYf6jBp5RJqrOVf6w25UP/qiEyKYVJzJ8wX+Mkv9p5MJFHw0uqpRrJq6xFsPTLSK3cLr/I4Xig1gStiNmV1XRwbA21UYZuXYj3ocHs3UXItbDzlryZQE6j3dNBqztQxELQi4cMrgMjo0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Andreas Hindborg <a.hindborg@kernel.org> [260212 07:40]:
> "Alice Ryhl" <aliceryhl@google.com> writes:
>=20
> > On Thu, Feb 12, 2026 at 11:52=E2=80=AFAM Andreas Hindborg <a.hindborg@k=
ernel.org> wrote:
> >>
> >> Andreas Hindborg <a.hindborg@kernel.org> writes:
> >>
> >> > As far as I understand, this is a borrow checker limitation. It is e=
asy
> >> > for us to look at this code and decide that the borrow on line 51 wi=
ll
> >> > never alias with the borrow on line 49.
> >>
> >> I did a bit of googling, and this seems to be a well known issue with
> >> the current implementation of lifetime analysis in the rust compiler.
> >> Apparently this kind of code used to be OK [1] but the Rust devs decid=
ed
> >> to remove the code that allowed this, because it was causing excessive
> >> compilation times [2]. The upside is that this is solved by the new
> >> lifetime analysis implementation called "Polonius" and it is the
> >> intention to replace the existing implementation with Polonius at some
> >> point [3].
> >
> > I believe the standard fix for this issue is to provide an entry api
> > similar to HashMap::entry(). See the rbtree for an example, as it
> > already provides such API.

Alice, can you provide a link to the rbtree code please?

>=20
> The example above [1] is using the BTreeMap entry API to produce the
> issue. Are the BTreeMap and HashMap entry APIs significantly different,
> or is there something else I missed?

From what I can find, the HashMap is different specifically for this
reason.

This is where my question about get_or_insert() came from, the HashSet
has this workaround, maybe?

AFAICT, the hash workaround is done in the Entry code that takes a
different reference(?) based on the variant (enum?) returned [1].

Or maybe it's about the way branches are evaluated by the checker?  Are
these different

But I'm really fumbling around this while I learn what you are all
doing!  Thanks for all the education on this stuff, it's helping me
understand where we are headed.  Hopefully I help along the way this
time.

Thanks,
Liam


[1]. https://doc.rust-lang.org/std/collections/hash_map/enum.Entry.html

