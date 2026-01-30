Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F85D49C7B
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 08:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759DE6B0005; Fri, 30 Jan 2026 03:39:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706E06B0089; Fri, 30 Jan 2026 03:39:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B17A6B008A; Fri, 30 Jan 2026 03:39:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 495056B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:39:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E16A5BA19F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:39:04 +0000 (UTC)
X-FDA: 84387980208.19.A4AB536
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2CD7BC0010
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:39:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=JzKqtQtW;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b=VNIVhwy4;
	spf=pass (imf22.hostedemail.com: domain of "prvs=483af0c49=Johannes.Thumshirn@wdc.com" designates 68.232.141.245 as permitted sender) smtp.mailfrom="prvs=483af0c49=Johannes.Thumshirn@wdc.com";
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769762341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EOJ3qQfOyZMkTtOPwSAxN/vUpWBc5yp0aPUXzTvoHI=;
	b=GAoP2KeULhuCOcqNgW4pNTZDmkbAP9DOEMT5okv7qAlWr1JvDKHIG0WcuhI+qDi/gXcUWI
	z+viuIY1Ydi5y6lpleqYNRcpRsCXqP1ZQ/NJd/QL3G3+5dud24Zy5wa6Fs/pUyzsHZeRwd
	D2pIfYIpRge71Q+li0NtFw30tzTZ+Gs=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=JzKqtQtW;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b=VNIVhwy4;
	spf=pass (imf22.hostedemail.com: domain of "prvs=483af0c49=Johannes.Thumshirn@wdc.com" designates 68.232.141.245 as permitted sender) smtp.mailfrom="prvs=483af0c49=Johannes.Thumshirn@wdc.com";
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769762341; a=rsa-sha256;
	cv=pass;
	b=dcIB5//BPaDmOFbo0OmJKaZ1aFegWT2MmmsSaSXketevCFFhWH3nHA35kl5rp4X4e2ZHOp
	rXTbEhihSVxxUua836odVF11I9+m4APPHYN2vFzYjCZ6BZQA7882i3lsuXX7dB+MWx/tjt
	84ig2ks764UbuxNt4vsAmxdzFWI74SY=
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1769762341; x=1801298341;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1EOJ3qQfOyZMkTtOPwSAxN/vUpWBc5yp0aPUXzTvoHI=;
  b=JzKqtQtWSgRShQ2wC3E0rvhBga1jYzr7Erb58YcA14WIGtlrTPzEWk2I
   HwaZAI6N4/UWMS8yf2a1ML8+g1mqmejjrah+EwhINxtZQdbVYLLO0ER3S
   DZ2RMpaCXnvzrZxbspvUDE3Cogv1l1oSYUbcVfiIgdURaAam8goS11r0A
   0tZ6l3u/k2QWqjdUGy5aXOQmtbIiIwbaP1SIsRXrSsWMXUdOQi+Klz+zR
   q7BKDTrl3oIte1WiViuJMcbOTePtM5zGmnVn5eMFoBrY/mDmZYuh/1unb
   YJxbRwqtiCBwGCjNzd2pPkftUyR6YB0YUAnll8Qhh7oDPDPo8ylRfhIng
   Q==;
X-CSE-ConnectionGUID: rnRru1t9RLOmFxVMX+1JwA==
X-CSE-MsgGUID: nLoCieRIQEy8AFjp0M4Y+Q==
X-IronPort-AV: E=Sophos;i="6.21,262,1763395200"; 
   d="scan'208";a="139772386"
Received: from mail-eastusazon11012042.outbound.protection.outlook.com (HELO BL0PR03CU003.outbound.protection.outlook.com) ([52.101.53.42])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Jan 2026 16:38:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eukYOKkkmbHUVWqEDEaRPnOLHujgjTZqLSWV/Dpwshm4a2ic5yXp5rnM3x14XdEI8KRuD0RlSyX9QCfpBbmhglvy9jOOHuXhm+vXJbKaUycx3v/KGR7j2i8N5uhZ1AjsYRqyWOQrlpEZ0ZlZY9wkEAPGThCqpKWjt7okUW/cBkhcSS5oKS5frLf4QALQlUM6intMnjufaMVmxuJpua+z/t6FC371N7SNTELj4zRe0vpLXaW7lRz3mtaqwzWFZWwPBAWbvkjwuO+FhSkoZdjBwZLecpyMIVDJjWVsA9FwkU/lgZHPcWSbQ9d8XjxCI1QwulLOMDq8/PWAVmMJCHfKGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1EOJ3qQfOyZMkTtOPwSAxN/vUpWBc5yp0aPUXzTvoHI=;
 b=aIPmtar//75fcxNVk89dNgM8v5WXYmW/sS3lXocQgr+Yn80JlrLLD9z1Y3EJPiiz6DgcB2RsSfH5XG9Db7OByk80e79mOTbA09GWD9YFkkbtNkiylGqBlLlDeajM9XmqyS6x3l4Gc6o34kStOwODF1R7/bKwAwBkrOW4V+Ypsh0bJ7b7rkPMTP0HLY4XROq+dTMleTHYWg0lRtMVur9aFdBCms9U/zCfxKSCryixcqa1anV62tEtYKc44/uodxGl9L/Sa2vN26cDJEsVjR3L475eNqthroVdXzoWk9K9qGw5outnY4bKrn8XQ3r8ybwGFNe5M36is/oaGkzrF2xlqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1EOJ3qQfOyZMkTtOPwSAxN/vUpWBc5yp0aPUXzTvoHI=;
 b=VNIVhwy4vrel7YkciPanC3bBg8m2/0P9rnePje9o9FmPQ/Pdy5aLNi/35/7y7R8oRxDdk0QgWkjzJWUKcDqgkX3hSKIsjyDrJe9fC3v6dwo6E8tWX7A1XwFmXOGvjDCGUi7Q4UuLRFMnkoqapkS0J1qdPSS9gUNYbF16xfVd2No=
Received: from SJ2PR04MB8987.namprd04.prod.outlook.com (2603:10b6:a03:557::20)
 by IA3PR04MB9499.namprd04.prod.outlook.com (2603:10b6:208:503::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.10; Fri, 30 Jan
 2026 08:38:57 +0000
Received: from SJ2PR04MB8987.namprd04.prod.outlook.com
 ([fe80::2209:bd98:89ca:9421]) by SJ2PR04MB8987.namprd04.prod.outlook.com
 ([fe80::2209:bd98:89ca:9421%4]) with mapi id 15.20.9564.010; Fri, 30 Jan 2026
 08:38:57 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Snaipe <me@snai.pe>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC PATCH 1/1] fs,ns: allow copying of shm_mnt mount trees
Thread-Topic: [RFC PATCH 1/1] fs,ns: allow copying of shm_mnt mount trees
Thread-Index: AQHckUZBQBlr8/79K025dKByB3nheLVqZTKA
Date: Fri, 30 Jan 2026 08:38:57 +0000
Message-ID: <60f683fa-bd25-4656-ae53-fc247962bac7@wdc.com>
References: <20260129173515.1649305-1-me@snai.pe>
 <20260129173515.1649305-2-me@snai.pe>
In-Reply-To: <20260129173515.1649305-2-me@snai.pe>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ2PR04MB8987:EE_|IA3PR04MB9499:EE_
x-ms-office365-filtering-correlation-id: 83fae997-0e44-46ed-962d-08de5fdb026a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|19092799006|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?dnRXdGxrUVpRTjllS2s4RFJiSHBYUlZxdytDblh3Y1NuSCtuekNGMHFWU1Uy?=
 =?utf-8?B?MVpTVmQ1SGdBZ2g3K1B2UTFZTHpMV20rZnZNM3A5Z1VWdDh6b2NMVndMV0po?=
 =?utf-8?B?Wk9WUlhSdUhMMmdMVWFWdVhjNFk3VjBFUkZUbGU3ZW42TjRkVDRDSThHK3FV?=
 =?utf-8?B?b0pHWnFBSmJocXQ5Wk9taS9SUDVwQ0NESmNVR2Nqcmt1VWk0eUM4L21DeEZp?=
 =?utf-8?B?NTU5VjdqWHNTcGd0eFBMUEhDOG12Nk0xR1pGUHJlSGpyRno1R2M2UXBWUjBi?=
 =?utf-8?B?cUdidXJEK0hIN0VydlRvRVdmdjg4cVIxSTZZRnIzNDVpb0wrYjBXNFR0ZkZv?=
 =?utf-8?B?anllbWdUYit0cndjQlpMWndxTVZqamY4K2xpNEVJUndTT3V1d2VrV0FncVFB?=
 =?utf-8?B?Um9EK3l3VnZDa096b0ZXTEV2VDVvck1OSGZRRzYzZG5rczFKZHF0SmhrWDFW?=
 =?utf-8?B?MXVmclZZNnNPdFcwaitEWUxLWmV6WWtjWVYwVzRSejRyS1hTckhXWE9FVEda?=
 =?utf-8?B?ZnoyN3BaR1pvNjc4TDZkOXFGL2RvL2NmYUtRYTErMXh3OXprNFZLcVc1Wlpq?=
 =?utf-8?B?bk51YkZQcGhNRGVsQStyNlZwRCtBcGxsQ1RnaEhIek9nMjJxNUFxRm93U0JZ?=
 =?utf-8?B?ZVFRU1JzS2JaWU0yYXpUb0NFRW1lM3VMeE5iWEdsQWF6dWhWUmk1KzFRSTlx?=
 =?utf-8?B?Qzg0NXdMN05hOEpJMWVKaTI5U3pFR25tTzJCUEM3T0pNSG0xWEtXVDRMUUJV?=
 =?utf-8?B?SGRQR1g1M0R1YXFtNExNTE12Y2o5YmdLWEZHaEJlSVRzSHFxNlljUHhKR1Jt?=
 =?utf-8?B?S0wwV2NsV09mTzMyeEZpMDY1V1hmS0ZqQWtLR2JSaGRrazE3Wlkya04rcGZs?=
 =?utf-8?B?UUZGTjEyOTNUdlB1SDhvVldWVmFrY20yT0Vqcng5Q3cxTEloU1pZKzRaY2Ir?=
 =?utf-8?B?QnE5NjMrRE1NU0hCbFlrdmRPS0tPSTd2RndpS1ZlRUU5cXlUU1p4cEN6S1cx?=
 =?utf-8?B?azhnQndqWEswUko3ZkNOVUVLWERFSUxqNDVHeFY1TnYwN0xEVFArT3dzeCtR?=
 =?utf-8?B?UGdnQitoVStxWlZ2M0NXRFRRZ3I2L0lUSXBDU0pRc3pGN2VnYVZYSWRyYTVl?=
 =?utf-8?B?Rm5HMll4di9wMzZHQUZUcmk5OTFya3UxTUtVdFhZWkkrOFFNTGUya1dkVWh3?=
 =?utf-8?B?WTZERGFCYTdvOGJzNTRtWmJDUkYvS0pSa0FWdUZDaFVyUGNGTGttcjhQNm82?=
 =?utf-8?B?L2M5RzlDZjN6dmdFYUc1Y2JhWkJyVVV4WE04ZTRzN2xQYm1heFFJcThaLzZS?=
 =?utf-8?B?S0N5b1VIRlllU0xucGVEVDV1dVgvc0s4WndydW1PQkY4SDV3L2pSOE9haG9q?=
 =?utf-8?B?RGQwL2pkNmhlMTZ0R1p3M2VKd2pQSmtFTXRwZE9TZC8yRWwrZUNZVFlycE1L?=
 =?utf-8?B?UVl0NzcyMEk4YkVkM3QwNEdOQ2s1WnczRXRJamoyeEZtVnZmczlHWU1aM1oz?=
 =?utf-8?B?NkpkVTNQZ09oRjdZd3pMaVBjOG94L3I5cHdrYitTc0ZRd1NsRHdjWVplMEsx?=
 =?utf-8?B?eW8rbGh5QXRvZVI2NGRTYUFiZlZDdHE3S1c3MFV2Vk1xcnp6RStWSGJ2M3Q3?=
 =?utf-8?B?dkNZeVFicm9FVG1BWndPdm55MFIwYnNYdXZjY1h1OG9NU2w3ZTh1L0dwRFJh?=
 =?utf-8?B?VzRMdmJWU1ZZN25wQzBMTGJCbjdxUnpQMWtTWloxL0xQWitTQnorclJsQTFF?=
 =?utf-8?B?QlRiYUR4c2gxemx4Ny9RM3ZnTWF2dTRUdFhpcS9JSk1XMTYzR1llRlErNE95?=
 =?utf-8?B?MW9jbGQ5YXUxcDJFdlV5anY5VFVhTU5zWE1ENm1wcG04RGRiT24xMzdMWDJG?=
 =?utf-8?B?eWd0TkVYY0UvVEZ0MFFqQmVSMXd6K1hhWGJCdndUQWVFRE52NzdLZDU3aEty?=
 =?utf-8?B?ZnZLUVNSbDRoQ0pVQ1M4VFJ2YzB0YzhldEhlaUJtcnI5N01ocTFUY24wdlA0?=
 =?utf-8?B?YVlrdzQwR1FTeUk4S1pmd252V3pVZVZ6M2ZGUXlkVU1vNVYybjBwUEhuUzFR?=
 =?utf-8?B?WCtzOWxrN3B1OEM3ZDdjTjJlSXR1U3JQMDlEUGFSZGhMbE1JanppcExCc2pS?=
 =?utf-8?B?QnozcVlGQUY2cHZqYnNvRXI1cjh5Ni9LR2JMcGoyK0lpT3VIOTNTcTRGQ0s3?=
 =?utf-8?Q?BZv9Z4pU6+wmIQXKdJuOSi8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR04MB8987.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(19092799006)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eDVsZ2R1TE1nNUdqVzRTM25qZ0VCT0JQNkNMb2VzYjB6SForc3VVRUE1V3Vr?=
 =?utf-8?B?TXpVdDRLWWR4Y3VpeUFPZHZMY1dvcGJpZEZNcGlmclQ4em9ZTDdENlRQZWdr?=
 =?utf-8?B?NmIvRFBSTWVMbG5aVFpBZXEvaHJWQjV0eE5Xb08ycHp4dFFiTERhQU1TSzlK?=
 =?utf-8?B?dDEyaFlOZFNzY0dvcW9RZ1RsbVo4cU1adlFaZWh4cnpZM0ZITjlxQXFtYm9l?=
 =?utf-8?B?MlRjMGNpVjdnNmFjbHdveDVZZks4ajgzWE8zdHBkSVUzSERYVm5Tc0JyU2pj?=
 =?utf-8?B?UGtBTG5wSXBHb0RnQUsvNG9oaEV3emk0SjY1TTVlR04wam9icUhUSCtpUzlO?=
 =?utf-8?B?N0tSaEZPNU5NRDNVa3dSTlQ4ZmNWODkydFlVN0E0OFNtemJpWlZiMjN5T2d1?=
 =?utf-8?B?aW1xaGRXMzVYbExTdnVmZ1J0MlZ3cEZSYUxxZHhIZmgxMzZwekNkZmFmZ3Jn?=
 =?utf-8?B?bzVjZ0lDbWJ0N2xjODd4eGFUbUhQQjhqdWpkVjNDNE84Qk0wQXduRmJ2L1pl?=
 =?utf-8?B?N282bXZhbXUzdkxBZU8xejQ0cFVrRTBZc3pqZ054VExWTFZJQkdGR0F2TWFz?=
 =?utf-8?B?NVoxQ0tsMW9jL2ZNWlVlQytkSWRaMkdHZXluSmJXeFl1bEhBR2Rza0NmaEdv?=
 =?utf-8?B?MnVWdlZqdHdGeG5ncWYyQVBBN2REZlM5NW9WM01NampDRlhOeTFtMkRFMnc0?=
 =?utf-8?B?L2RBM3NmVUJ6TzBOMGNicWk3RWVnYVczdUJBcUVYK0pyMXNHOEtubUZuUkxT?=
 =?utf-8?B?TzlxSit1a2oyNjhoSVFZUG5VVmV1SmlQakJnNmdDYkU5WHl3U3Mwanc3RjRF?=
 =?utf-8?B?MllRd1RjUUFrRHpTVlVvQ05zOE9XV2o4Wi9VU0FEZ0FuY3l1Z0FIc05LUjF2?=
 =?utf-8?B?MDBLV0cxaG9GSThyeHVPUno5UjJ4b1FyN2hCM0JsMlFJZlZBM0lieDhZZXpV?=
 =?utf-8?B?US9lTEdJUnd0WFJtOThmdENFbXRJS1Y2ODFUWlVER3JBTXJCUEpnSjR5YUVs?=
 =?utf-8?B?TEY4bnB1aVNITnZoZTdxeVhFTWZFdHNJN0taelpVbVhHV0h5b3d3ald6MnJl?=
 =?utf-8?B?VFpvb3lxbWlDTHU3b0RJOGcxeTNyMzlXOGxQeWk2VTdSUzQ3dFBkTHFuQmNZ?=
 =?utf-8?B?a0JQUWNTTnBvY0hBTEtUVXVGZ2pIMmE4dWhFWG5SanFVVHpvU2ZsK3ErWXdY?=
 =?utf-8?B?WGtmaGJiYW5OR2lCZGFMQzhWWFZiS1kwaUZWU3Y4TXFmR2RDV2ZBSnhsS2tL?=
 =?utf-8?B?YzV3MHQ3L2FaSnBkSU9xU2JjM3FrV3BlQS9yKzU0ZmpNM2duL1VzUk9jQ0l0?=
 =?utf-8?B?ZlhoUnM1NVJsako4K0NrQnVsejdxWGJOK0RSdnRSS05oN1dwSmV5MGhzcE03?=
 =?utf-8?B?NXlBWWpRc2hmNjY2UFZSVmZJT3QyYXdHcGx5eUZBYk03UGpjdnY3THdoaUdB?=
 =?utf-8?B?YWZtNVc2MGQxNjlzdmx5ZHNuemtkRFJMb01HTWRta2VnTWJkVGN1NHdlOFFi?=
 =?utf-8?B?UWZ4cUplZ0JXN01leUova2FYdWFLOGE4UG1oOVhOaisyY3VBQ2I3ejcyODdz?=
 =?utf-8?B?VnV2WWJ1VzVnZHE0QVpBaG9UWWsxNDB4NVZYQTBoNjNrTEdHN3RMQUlWNlF1?=
 =?utf-8?B?d0F1eWRxY29OMnkrRlRZUEMzS0F6eWFmUjhsZElzL3ZEMm14cUt3OS9qMUps?=
 =?utf-8?B?TStmSGc0SUlxU0dGOVlJek1PQTZjdE5SRHlOQnBpbUZGNkVoenFMTVlEazRR?=
 =?utf-8?B?RGRmc2IweUdjUHpVZFZHRXk3Ymk4WCtWL2hPUjhUMXNqb2doWTFsOWFOMy8x?=
 =?utf-8?B?SytxYVpZczI1eFJWeXM5b1NHdkt1VCtQWkRQWHh1MVhjd1duc3I4ZTN3QXZ0?=
 =?utf-8?B?b200S2xwdnY5QUtFV0hXVzR1K3Z4Y3UwWjhtYWJ6czVUaWJ4bmtGMjVBbDFk?=
 =?utf-8?B?UGZiZmRHQWQ0cG4yc1plNUwrRHQrOXFJT2xCQWdZcm1Ed0lCcXNYVmR5WExI?=
 =?utf-8?B?bnJBSXdBLzF3amhIZ3g1aVFJQ0g5V2R0RVpRMXExZTc4NW5UOEd2SE80T3BQ?=
 =?utf-8?B?WW5DYkpYL0dyK1RDeFJnU3pTUVlKOXJ0RVovNDg5S2NFRGdpV0xNbWE4MVlQ?=
 =?utf-8?B?c1JmMkw0QVhodTAvRjNGdE9kak5GRkk1cWJVcnA3ajlWVEZNbVlGQzVpdTF4?=
 =?utf-8?B?b1BjdGxkZ3ZFS2srSWdzR053TWlLTlJMQ0w5ejlUYzRpQW9EbWJPY0t1Q2VO?=
 =?utf-8?B?TkMwMmpPeEtuVFNvd0NrdkdGZjQ1Yi9QUW1tcnVCeEc0cC9LeWFUSWtFeUE0?=
 =?utf-8?B?MEtNU1JpVERySHB3bWJXS1pvU2hON0owN2xZSTNPTXVra05MTXVWeVhucHhD?=
 =?utf-8?Q?nWsev4uYnnQ9U0yI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <31C5CA7140B4C541AD3D7D888C2283AD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Tu95grjdIcpm1VP8QXPL2+taCvijAzS7FEdK5USHpQXVqrURaqqR+DpqziwB462JOUnuEs0MciO3DF8VcVzIDpe4TwWT0Y4JHmKNphy4gxuAjAqLg7L6TdWMikzVhJQGiAbUpC5AkaUgbB6SCFGx4q42zOw2S34DjYfOMOTGhOIrYXXGd27dgw8RRMvkksAMCmjMCELy1svvnvhG/Gd707ljMRDj3S8kdYjXa/kzmFZ+us5wQ2OCnnBChu7jduviXtL1sQHmSZUwJxZ1OSB6G8v3nr01XLEREylVGJ6ByZ1HoF14PQPVcqnhrHjOtZoVVOZcvlSgVsgHPHFDDoQNKLzl2vzhnC1Cqdd1EPS+wz1JUf4hozhFee0kqlUmGZz6VVsEWQ4vtAIv0hOEqnuppzPvPVfTOzUkS81oiC3m/HAYgfULYwcd+cNILzAZpkXkVOIQcvVU1pl0P6GO2e+6CtBOz5ZS6T5Mjd4dXkBLN0WfXd4kF9X5i49R95xB4oTGsM8byiFr+8jdqlGeU9jHi5qDs9FHBRdrdXaw3zf6UWlZvMR43zcTDG2f/AU92OooeIjRIbzR+hnUferR0ILRcA+0uigz11h8Xe18AyYcjgTwX5zChI0t+21/qL6Dqhz7
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR04MB8987.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83fae997-0e44-46ed-962d-08de5fdb026a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2026 08:38:57.5874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PQAk7JFWrTFHQWl2wmi8/sN5/IbPD9HfEY7R5b3Lvma9vSL75w2DnTdpf9d/s589pCj0SaJ4SNT+Yl6QXph6RfK6aLW3sRTb/KZoK7aojhU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR04MB9499
X-Rspamd-Server: rspam12
X-Stat-Signature: 4z4pii5jr3773739g3zsytg8au89y5my
X-Rspamd-Queue-Id: 2CD7BC0010
X-Rspam-User: 
X-HE-Tag: 1769762340-394200
X-HE-Meta: U2FsdGVkX1/LunIwa3IVWiNg94lJPVepLX/NbNTO3fqdZsyyWKyJOYuN+XVciyXGCE80VykQuh9lENrQiL2YvXeX9vsn1MB/wgYTEEQzOVDKQ/J+TPSpu6bmWLEd6UyKx3a81xztQ11ZVlTYYVvq+jp62MQtmKVG28ybkP1IlxdEwjgd5XRK0lxESfDNT1GHKVdIfuj9hXd0Fht9IJFUDNOuSZQdx5sdPd1b2xFntqLKDHhKP+5ZF5fqGKFCBk8XpKDEhws2rEHvje5YCgN9ZtDvQhY3nerOVWq25/srn5J/JNBwKTbdpLje2J0Nwnzp6fWAOpbEcAX2p7DG9ia490bmwYALGft82kc4H9uByyZqICcjjT1BksKXAjSasDponm8nbJ+cYrkoEzmztLHsEbYOdnKVch5s3eb+xZLZceG6lzxKZ5uHNA69XAAyNsHXabnNW1WgT7Ci1vqSu9c48HYtcgYYDnpGNMLlOlk2VaYTUAZlVANdY35iM7IEBsco1KOi0UNKOsapMjjsbcaAsR25d7j3oMgD7epfNwmruQ0sMuBWCxzNhqKdm0Pbi17uCcVtH+gF6iZakpPh2+VjYGjUo0CIE5Gi0hi4+j2EFZ+NHixOMX3ada3VfOZcWkGVTbnqdM18UiN+QrxfxAcJ3srlHJHkgVdD40VvMUck6dVUD6C7JAURmzZFuI9yik+f6pi8hua/sTq+h4z7h1y07LvM38WpUXsDrGCojif+IBbgUwHoBzIq+EN07wT8yS9eMDWmR+MwD/8dsLRGgCgd6D/5YtDlMEgY8nC/dX+B8ofwZgpH+2vdgyditlepfoyEpj6Dw5NSUJvTsQ9nPP9TnbyVIHrszvY/IYS7n2PrX2F+Cz5Tdi1lNHlo9R6cMtWSvqfBEM1viJUlBdDeejOJ7uPiOjWGWqTfg2XkRtulWyfspWdnTJBl9NijXcOcEHWMkPpAU+Fndt42C5x/iDy
 EZ5xIGIL
 ChlLhDXir6nd2tMqjpeIKED+0RRnptM8f0ZGU74KV8HiQN9MyziZiiVpVnHXRHRCszn4npbZH35wShi5fk/9Ut49AXENGPYA6ROJmqkCU0VLLRBuU/nubyme6w7cOrR1WO0c+8MQVAMWf4/XIzakDaTyukWhiBSGqrGktcjvQgkMU3+n/SaoN6SlS5bIjxU0daza3d2BJhAiM9wQDu3s49T1MbYrOmB91R/pSrXnlzVPF4Oh0aNFcf7+nfSjpcInx1ltcJhbixrs4opRoeNAaHwJNAbzCRg7AMRecfAakZsSQUzKatsp8UROf0FNFbTz/UF6NNKcH3tiv4TbDF1MHcGZ7XFxm0g9VaQaGK9H2sYPHsTWtRlf9DNFwXES9N7tWl7YKb14g+MGxszPBJrcsTUDK9xJ+Uy1YesYPFoGBMqTuyH1MTD70+5kWm5CbmVRlRh/gYwy3ZuKu6AGIQzmXZ9TX1DYCGw/2wctiZVuxAOm07OjmKhrhsQiR3XHwvZEUWbmieYvlO/oemMvekefv8Kd6GVTez5+pxvUiMQNcjIxf4Mc1379uUXKK3oKMjgBIYR06QvPO+8i8LZBR4Xt35WehJ95Pgof1lXOljHH06k2TMYn8vDgg+rTRsiy0X5K93t/J64hyH92Li+vlFNcgaMP1C5gzERKwmmfnvFy7ps5LS2ZhhRgylhb+9nfTgDgvn9yhQKmwNm6nNLAZaVewpHHI2Lhu4m5QnNmd8lH2xy133wKDt4BFjoYNMywbIkQY+qpi8/RJCUBOdPkAJr90gQjiCKXTDsCQ/PmMgKCLVdmgcBDKFBYdRMV65eQk3Gb7QRjV9f/cSGN0lqhR7atjIqPLKKRTWU0wp7tv/h6nF5Q9elk2PO1QyQkvzjglExY3XPoQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gMS8yOS8yNiA2OjM5IFBNLCBTbmFpcGUgd3JvdGU6DQo+IGRpZmYgLS1naXQgYS9mcy9uYW1l
c3BhY2UuYyBiL2ZzL25hbWVzcGFjZS5jDQo+IGluZGV4IGQ4MjkxMGYzM2RjNC4uZjUxYWQyMDEz
NjYyIDEwMDY0NA0KPiAtLS0gYS9mcy9uYW1lc3BhY2UuYw0KPiArKysgYi9mcy9uYW1lc3BhY2Uu
Yw0KPiBAQCAtMzgsNiArMzgsOSBAQA0KPiAgICNpbmNsdWRlICJwbm9kZS5oIg0KPiAgICNpbmNs
dWRlICJpbnRlcm5hbC5oIg0KPiAgIA0KPiArLyogRm9yIGNoZWNraW5nIG1lbWZkIGJpbmQtbW91
bnRzIHZpYSBzaG1fbW50ICovDQo+ICsjaW5jbHVkZSAiLi4vbW0vaW50ZXJuYWwuaCINCj4gKw0K
DQpIaSwNCg0KSSBkb24ndCB3YW50IHRvIGNvbW1lbnQgb24gdGhlIHJlc3Qgb2YgdGhlIGNoYW5n
ZSBhcyBJIGRvbid0IGtub3cgZW5vdWdoIA0Kb2YgdGhlIHN1YmplY3QgYnV0IHRoaXMgc2NyZWFt
cyBsYXllcmluZyB2aW9sYXRpb24gdG8gbWUuDQoNClRoYW5rcywNCg0KIMKgIMKgIEpvaGFubmVz
DQoNCg==

