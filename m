Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB30E81A3A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E726B008A; Mon, 16 Feb 2026 10:18:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93CAF6B008C; Mon, 16 Feb 2026 10:18:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E74F6B0092; Mon, 16 Feb 2026 10:18:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6628E6B008A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:18:47 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30E4313C2EE
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:18:47 +0000 (UTC)
X-FDA: 84450677094.13.3E95AE2
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19011090.outbound.protection.outlook.com [52.103.23.90])
	by imf26.hostedemail.com (Postfix) with ESMTP id 30E38140005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:18:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=bCP2571U;
	dmarc=pass (policy=none) header.from=hotmail.com;
	spf=pass (imf26.hostedemail.com: domain of raul_pazemecxas@hotmail.com designates 52.103.23.90 as permitted sender) smtp.mailfrom=raul_pazemecxas@hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771255124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=O1EkhvVQuK+5xNczz3cGLQUQvdFumtlz2yhZ1FY00n0=;
	b=NfzCVuPEv5n/dR0YQ8k7q7pdiENjotPgKcS1S5/us2A4mCHzH3GSpSAMi2Gyj+rSWhRUBr
	EHntiZuMTNku8TMHfkVtg0YI6FA1bSWrB+CqL1TBYarHXNF2AWvBbxLw/WutC4bAJ+9qVy
	a+iouiougTeITykbQasLrG/vq7vZ5yA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771255124; a=rsa-sha256;
	cv=pass;
	b=uOIX2mgiS7uEbBnkzodFVhaYC366LTfHbEigaD7xqt7HUdu89L4Mwq1nzviBNASyEBKXiS
	A9a75AQWx5drvGmuHINj9bNHan9CUrB4Mn0xNyTUDrl2vDvEGLHcrOVokON4Q4CmAiKm1R
	WOpJ0QDD3MB0wXNss11zjM/fGvYk1ns=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=bCP2571U;
	dmarc=pass (policy=none) header.from=hotmail.com;
	spf=pass (imf26.hostedemail.com: domain of raul_pazemecxas@hotmail.com designates 52.103.23.90 as permitted sender) smtp.mailfrom=raul_pazemecxas@hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AtX8z1UUyrPFuoREPLUZLUX0SFS9NlGG7zji7+4cUftxmT/AkD3AEVoAj4zQ13iUsA3hRH/kKOGeKD7iYZgz8voquNcjIAuH3ZuuTwTNuec4Epy3rKM/7sPLoxkUypPLLXI+MYYuTcxIaYN2Izhe2xFtzMQOl2mJQhkTSRNunZiku84l3oMf+IhRUocv2ZqH+aa+Z9QeU4r48WtW/GzBbY3ysxcFwcjx5SURF+1MBdpXeenNSmAbr+OJVXcYKJxstM36ZOjnaS3MD1SApAjj5u5VyuCTQI1mG2++RDhuhiRVajJ5KzYXnuC1fYOARUyDIwpZdZ2kGe7EN12xXKC6Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1EkhvVQuK+5xNczz3cGLQUQvdFumtlz2yhZ1FY00n0=;
 b=LNdnTiynqSsjy/Flu0pJZwfclXV59c0NYM1qCnGh+54eeYsn3XiBFY4Co6xyzLfW1Dac4wPJlfzY+zZpwt5GlEGHP4UirlpZFUUWoJ1lBVkjjxo9Y4AfJbh8EPm4pv8hy1qk6AjeulJtQr9fK6StClfAQUN0r69RKzwFn8rrPzR9xRTufhp5XOYgnMDfRxRQYm+icMYhUwkJ1X/dv8axXKG48BeIAM8D4bXIKvFfNlSf8JuNzYgJNa38AU2lYOJ1UhSW0DakORD9tMJfLfP01zhUaHdnLTkHc/JHT50VLE64pxasWtGCLnU418Y1HG8pNvlF+VLH/Pn0F2mJh7q4Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1EkhvVQuK+5xNczz3cGLQUQvdFumtlz2yhZ1FY00n0=;
 b=bCP2571U4guTCPEIoVMPGJima9yHWmhAQxQpWqho7BzaOEs1XXRWu3bYsz2ldGXRKKfDV3xu76wzPkAh+rhHsP8YHxPqvl+ggh08YTyO6fAPrRJJEZR5ZM2cpRpSb7yk35KGot5H5b6o1M5kxRCnv2Ootpmr1LrZgl04zT1mJcLEX7XJ9tnLqGfz8CI7DdyiGPSoHzcyGzO9w7McE8v/gtjVDIdz76qLUde+cL5kiysP1VTle0ZL+CRaIKpTeOrBtrBEie/agvIViD988XOg8YCnqZJx+ok5EDxeoIeMxcmsv6kKfEgIDyVkD00xwdl29uHU/stETamboBFduRjPlQ==
Received: from CPUPR80MB8171.lamprd80.prod.outlook.com (2603:10d6:103:2c6::9)
 by CPWPR80MB7169.lamprd80.prod.outlook.com (2603:10d6:103:205::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 15:18:40 +0000
Received: from CPUPR80MB8171.lamprd80.prod.outlook.com
 ([fe80::18b5:f8c:1f:ef82]) by CPUPR80MB8171.lamprd80.prod.outlook.com
 ([fe80::18b5:f8c:1f:ef82%6]) with mapi id 15.20.9611.013; Mon, 16 Feb 2026
 15:18:40 +0000
From: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
To: "sj@kernel.org" <sj@kernel.org>
CC: "damon@lists.linux.dev" <damon@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "security@kernel.org" <security@kernel.org>
Subject: [BUG] mm/damon/core: dangling walk_control pointer in damos_walk() on
 inactive context
Thread-Topic: [BUG] mm/damon/core: dangling walk_control pointer in
 damos_walk() on inactive context
Thread-Index: AQHcn1XCaBDjR1AYvUKJXLQu2W9RNA==
Date: Mon, 16 Feb 2026 15:18:39 +0000
Message-ID:
 <CPUPR80MB817114F8F409F0293D3799C1956CA@CPUPR80MB8171.lamprd80.prod.outlook.com>
Accept-Language: pt-BR, en-US
Content-Language: pt-BR
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CPUPR80MB8171:EE_|CPWPR80MB7169:EE_
x-ms-office365-filtering-correlation-id: d4affd79-99d1-4be5-ad31-08de6d6eaa08
x-microsoft-antispam:
 BCL:0;ARA:14566002|39105399006|20031999003|5062599005|15080799012|19110799012|15030799006|461199028|31061999003|41001999006|8062599012|8060799015|40105399003|35041999009|3412199025|440099028|102099032|26104999006;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?n4MLueIo32uSHz24EEwt1bQym2QXQSgfs9aSChci21a8PTRDqQZBqANxAs?=
 =?iso-8859-1?Q?ycwsYcQoj9QVRDDRiA8HLHirsnUU55RdhcCVJM52aZKegdxGxaJWY6clxX?=
 =?iso-8859-1?Q?eXqaKHkGiERKx4WwPAmR3+eAg8vKUKnu5eVnImuV+EIjNjQRUHS238YmHl?=
 =?iso-8859-1?Q?8NRPSu12KINmpNupLWbRc28rQsM8ff2ze+LmDFRpGdsEfBKCpajQuqVxfk?=
 =?iso-8859-1?Q?59O3V5G4VqqlEtMH2lxI6xx5vrPNVltfU/oEO64sG7d893ZQ7OY2Dev4vZ?=
 =?iso-8859-1?Q?PD1HZybQEF/E0z92WNKLI4meTFHf9WpVMhpj4Mhyod/x+Dzh7t58CJhY7P?=
 =?iso-8859-1?Q?zENt9PmVaMTO2b7H/pUMMnGlGf57lF9wnyHr4GYAVzQeHjqYNcBKK1dYes?=
 =?iso-8859-1?Q?4bGoSUzaAn7GEATt870TgymWDSofJPmcay+mP1ARaNLI6d8gIZ2h6BxY5b?=
 =?iso-8859-1?Q?yvdJ7cTDX1vHk6mKPPKAfbLO1udOuv/7/RUyS16nFcAq8CrfCFrRECGlMc?=
 =?iso-8859-1?Q?PlwM8p6zGsenZANAXjuY19ExcOFE557NKSw2JRKRm3YkK1N8a6tuDvIqfR?=
 =?iso-8859-1?Q?cYvCXihuJPgjVJzCSaUwyCR6LVJ25gDzK0/0yhE9Qoola0BRkqhPdn0Id6?=
 =?iso-8859-1?Q?gAzelUKf7fiDplUdCf2q65uBK2wZ5m+gNsDR9klhZw5KfHXR+fKl98wgPQ?=
 =?iso-8859-1?Q?6FbTHwvKhhA2oBySnQ6juuQTo04YxgBiDygLmI0e4+l6afcAftNx8f7rsA?=
 =?iso-8859-1?Q?qXvdl00ILUZm3pxdB8gxpWuaBfBulVcJwfGSAEj4ufNCCs2uH3cSbv5TK/?=
 =?iso-8859-1?Q?5HgrMu8AkrhymfAthGEmyoDduGhxD3R5bUEa6JqMPq9ze7Hsmx7rC1VzdC?=
 =?iso-8859-1?Q?xGXzn+ecJkZg22JxHJGYq7n7F35pNkTc39VpkiRIlJDq7a8FA3Nw8+X106?=
 =?iso-8859-1?Q?evSLWk8MzpmWb7WnydKmSqdrWlNaPZJPNPZidg3XZMDNJlxpRRtNFYJrmw?=
 =?iso-8859-1?Q?+bqu2QbN+0mssdVg2nfn3IhBXkA1ZmRKp8HdYdeDJs7yH1MOI7nOct4gmY?=
 =?iso-8859-1?Q?UI28KdthLbjgmTcBIL9rt9cF7NWNnFUZd1rL2235TXnw6qOjd9Bub0xkfw?=
 =?iso-8859-1?Q?IcXCHqdSIeOYa9lAr9QQaJrFXawgmemHnVn7T9Qok8PYHz2arhIxmfh6Fu?=
 =?iso-8859-1?Q?2Ttjg7NdKjd6lIpC8jccX3plTA5AVYMg1ohQXb3gsEu327/o1akYi+1rnx?=
 =?iso-8859-1?Q?RL/roSXbPzM1gUEdt6rXgcn/NZknY996rggmF7yyXB4d7D1AY3YpvlqBcm?=
 =?iso-8859-1?Q?DTRb8DiqLXJHBOp4wIeNpH6LWc14OZDsdMJ+AYasP9val98zVPzSOk0PCs?=
 =?iso-8859-1?Q?ucRjAZBk102NXkyWDS+nCD6h+8lmo6+7sX7Xmg6nZ0/71z6PQdfm8b0w3Y?=
 =?iso-8859-1?Q?1aBhU26IzfK7RFwS?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?bVBdeV2spexE1gPH1TX6Ca3ETX1+VA+woQ6LqdhZumJ7YN3+3yHR07omab?=
 =?iso-8859-1?Q?EGkONOXSKqFIFbGh6fBUvcMkJTqGA/g0J8msshlI3+wb4TEBADWLEXJc5E?=
 =?iso-8859-1?Q?bEYZWW3/J7TJNPzZbwtpKhZ/jOFp0GM0C/ZegoHBpdY8Pp2OlOU967LmpJ?=
 =?iso-8859-1?Q?289uJ25zIMJt2LaHMPnmK0buHu/gtvcTOeiXceQC8nWf2XwoteYr/1OEvG?=
 =?iso-8859-1?Q?SMNX8Z0w5QRaSAS7KslpUQExCRvXsqeGoPTMYQO8mxzuNyxy2bwIRoQNPV?=
 =?iso-8859-1?Q?lNBbjCEX6Nl1OZzpbXbXL93OSgY4llqoKjVrU3wgxHoV1h4Qr5wnPjmv9C?=
 =?iso-8859-1?Q?llMwu+sBoCfhVzCMIBFASFCG95AWCV2zq3/WBIic8FTAxvPJRjrE4La/wI?=
 =?iso-8859-1?Q?O4MHJtsqzlQdGupRh+37CvI99u3ZFRbyMVVtHRe5r2bQyDZBSkCdaC+Z4k?=
 =?iso-8859-1?Q?91SrEgtS2ccR31N0bnGXc0EPDZaBnRxG0LtD9DAFxQsGoQL4OthkT21pty?=
 =?iso-8859-1?Q?++S8Iz12lkJOjfGHdjZnhCiT6jDYV4W3O9kj8+ZHFDFDXAbJEjsJ/mjlgW?=
 =?iso-8859-1?Q?btbSZKMhSRSZ3DGvnkCXLK5Kr0IpbeQW/JSyAerjg8e4FBQN90+BBWF3NA?=
 =?iso-8859-1?Q?BaDH/6nf+FVZ8iN5G2iurTLTUtaE1NbyX3jNRa63ErrlcChy0YRRAwcbau?=
 =?iso-8859-1?Q?GDXZjDv1w+NHZ3ccwQVIJEb6mi9WIxsMQ1xTz+8P7tj8LWUMR2D2vSUJef?=
 =?iso-8859-1?Q?k3uZbWnHP5W3ENHXnJMxxVnEzJJZjAm2ssRcSKzNjOVzFF8YKTNi90K86R?=
 =?iso-8859-1?Q?gZzlwtfDNzTU2UmPjUX/0DBSdl52sudputajHKswmBj0Lj9jmtH3wmyzVx?=
 =?iso-8859-1?Q?d/a60t+0b7voigeCWNbSw5/7XFu8Tmz1l7GZ4JDe9JKMRZIgzHCujE6KWf?=
 =?iso-8859-1?Q?KIp8+Piq/P+khSGrZFYQQRzLFa2l/zOt30odJKpDtGd4/TgJGRGOCBa+fo?=
 =?iso-8859-1?Q?Fygpe7ImzJUTs1SBoSuhhhH1jB39FrglH8sam9V82arEw8bqnxd2T2znsB?=
 =?iso-8859-1?Q?F7KjoKN/VqgHTxYHgUgqgq4LGdUf61rDEaiX6BN7Z7lFxCGTOx9fZv5FKw?=
 =?iso-8859-1?Q?IcMlIfHyzwDgI3odc+HN0p5afVns8BioYN4rF/2zyYdv3baLBhcDjp6/sg?=
 =?iso-8859-1?Q?+R1p5wD3qhJ8/nht6vjFrUZPUhVAh/SHm+aH4pjKXmnQ6L6yyxOo1SLqoc?=
 =?iso-8859-1?Q?cd7wT0M5nDqrV9p3d9GUPnNnTL6spsWpS0s9knrXAfPWnRc1P33fiCUSM5?=
 =?iso-8859-1?Q?B0rcQcOhBUv0VK+Y0bd49p0nEGT5+KRR57NCYfOClQBHQJ2VyhDLZ2xq/f?=
 =?iso-8859-1?Q?+AQVz4ekCqdjHZALkEcuB0OYELIoNkJ0cJEL6YfhI6L3NlYqwCnN0foVn9?=
 =?iso-8859-1?Q?G/7Mf4C2Z2dHqwhl6uTkl7vCVCKQt4GE3tchavDOrDA8ibKzCUh+zH7vj+?=
 =?iso-8859-1?Q?WOc1axHrZPWylkNYOEEjYD?=
Content-Type: multipart/alternative;
	boundary="_000_CPUPR80MB817114F8F409F0293D3799C1956CACPUPR80MB8171lamp_"
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-8eed7.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CPUPR80MB8171.lamprd80.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d4affd79-99d1-4be5-ad31-08de6d6eaa08
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2026 15:18:39.9427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CPWPR80MB7169
X-Rspamd-Queue-Id: 30E38140005
X-Stat-Signature: wf1j3ghf8qmep9uki7f8eyk5e65zm491
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771255123-452133
X-HE-Meta: U2FsdGVkX1847XO1JIwVA/TqATLArFEKuOiJypLlx4Vv8u8GPGdC4ksoeRNmemLx3HTDkGraJwN8e49ilmRXkKFIzbqsvb1kLgvLER7Wd34+2VRVAbms40y3jX0nojHzOh+AgsYpIFtc+tVDaQAgGbvOPreBKXrqMS8K35YIZgvmKG3RtJlAngb0bCh+1dge4uEoz814QOcUhBocFRNNDQ70MgeA6cW50tbYizs6HcY2sz2pR7nirhpSP1tvHNCdIgFi+6KyFgHSnfNO0X+UVyAVxwSW/HlrXq9BFbL7IrZ1Gsx076N6yjVzwFkGI/JU7sv+tSB8ae4KwGgRYJ83vk8F6zuLDeMtPEYWAy5DlQUkjZ8U9tIZc+z9CU+ZYxvWMOxRqhOQ2qoN9+3YpHg7Fk/DPdxqo5t53XTw0BHxxWhhnotIizFvmAUFzsoWg5RWdzrA56rrudutTOCfAUtFRjw4WgD311rJyOdGvYQduXoubEoY/a35C0iK5sEKR8Tl1dcmxQZxXxOAhciRpYa0SMZFy27pUDJ/G9/8J79SK00nPxa7/ww7J52eOP/mZBWZhLoLxvRFSgMvEbUDEkHE38pE/Zwugng+hssoQi55p65AKI7g+Kwp5SpJEllA+UwwZ6d8ihrZDGKnfKgB6eWMqOz4bgLaUlpe3eqdYWQK/w035oexJ4wDOoNq/uJKFRzUdLjxjabOYvWbKcAvxFN73BTHDVnfGTIV7NGCMHOSJl4on1Pd7aUaUBrpx3xZsH7dLfAMIxdQxqG/uBS4ErfdktdTerb921iqeB9qdbpYcQWZKvNf+qVFXe82NEaY5ZJDjBSE5Wb1vRTO5wWrcisVz45kDlNxBmfl68ZGhJEyWru7bgeahdOhe35VWzlqDz3U1AcGfGV9jNU4H16pRFUmWxrmIYtzNXyFnCMORHb4o2/Ay20ifUuNDxKPBqcVbOLoffX1rRTF+bK6DKLS+vH
 COIqkdu8
 31SrSKNALnc0SPuUjAYybrg+KqPJYFsmclXFn3bM743YmE9cx5s5wNdxV02W4Yu9CYRu3OmCLSs0woWN1v18AhOk9f7NBZ1MJuDmL2Z9whOD5UIyHgQ0r8v28tg5HX2w9NziOA+sNZsWKcjAbDsRnta/4+cil/Ossknp5MCiQqfXcTaz3KKsOZLls4AZza1JY9i/aLBfyVPg+8vL4WezYLEKr3jZ7uGCWpsoz1PXaMr5maDwy1R04/18G+dN2bDem2kwSA+n6/zEm0zOQEI0U+1u/NL37O6F1Z76pDA5FSlVery7icZRCrsi1eTlXc2LGExYePYUyNcy2iZdOHbKhIeKUml72TLVpKXETJLX84xwLvFya9ePFZLSALSglo18iRJ8FSKYZJlXNu0/Bu1kMZSegmXjIlM0v6kH+OTcv0wAlHZLWp7RC1MseBy2+vhCWGuHw1n1JaCnNI8xRiq83EOBzHqRqgVZZkb7K5DrtzK8hxg2W7FX+8iAEkW7Z0EBcmO0GORZGGTd5x2pKA15a294Pi2W//1yEt65Tf2yVadnmbP2US5xDezK8N5UI0eJb+OQLn1Mzay8gHhG6TNSWiH8Nr/bCguhAOiMKn6sD0zoVxIOECzQQkwRVIjQbord+q1vYxbeGA+Xb2JQJNCICj0kCd7ErMc9OMbGU/1nwECRtNDVWofA7hJIZ+aYJsPKtXzzo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000669, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_CPUPR80MB817114F8F409F0293D3799C1956CACPUPR80MB8171lamp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I found a bug in damos_walk() that leaves a dangling walk_control
pointer when called on an inactive context. The pattern is
structurally identical to the bug fixed in commit f9132fbc2e83
("mm/damon/core: remove call_control in inactive contexts") for
damon_call().

## Description

damos_walk() sets ctx->walk_control to point to a caller-provided
stack-allocated control structure (core.c line 1560), then checks
if the DAMON context is running (line 1562). If the context is
inactive, it returns -EINVAL (line 1563) WITHOUT clearing
ctx->walk_control back to NULL.

This leaves a dangling pointer. Subsequent damos_walk() calls see
the non-NULL stale pointer and return -EBUSY, permanently locking
the DAMOS tried_regions interface.

## Affected versions

Introduced in: commit bf0eaba0ff9c ("mm/damon/core: implement damos_walk()"=
)
First affected release: v6.14-rc1
Affected stable releases: v6.14, v6.15, v6.16, v6.17, v6.18, v6.19
Tested on: 6.19.0 (commit ca4ee40bf13d, QEMU/KVM x86_64)
Current mainline: UNFIXED

## Reproduction (confirmed on 6.19.0, CONFIG_DAMON=3Dy CONFIG_DAMON_SYSFS=
=3Dy)

  DAMON=3D/sys/kernel/mm/damon/admin/kdamonds

  # Setup context with scheme
  echo 1 > $DAMON/nr_kdamonds
  echo 1 > $DAMON/0/contexts/nr_contexts
  echo vaddr > $DAMON/0/contexts/0/operations
  echo 1 > $DAMON/0/contexts/0/targets/nr_targets
  echo $$ > $DAMON/0/contexts/0/targets/0/pid_target
  echo 1 > $DAMON/0/contexts/0/schemes/nr_schemes
  echo stat > $DAMON/0/contexts/0/schemes/0/action

  # Start then stop (ctx stays allocated per sysfs design)
  echo on > $DAMON/0/state
  sleep 1
  echo off > $DAMON/0/state
  sleep 1

  # Trigger bug: damos_walk() on inactive context
  echo "update_schemes_tried_regions" > $DAMON/0/state
  # Returns -EINVAL, walk_control left dangling

  # Confirm: second call gets -EBUSY (dangling pointer !=3D NULL)
  echo "update_schemes_tried_regions" > $DAMON/0/state
  # Returns -EBUSY -- interface permanently locked

## Tested output

  First call:  -EINVAL (Invalid argument)
  Second call: -EBUSY (Device or resource busy) <-- BUG confirmed

## Root cause

Commit bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
introduced this function without cleanup on the -EINVAL error path.

The sibling function damon_call() had the exact same bug and was
fixed in f9132fbc2e83 by adding damon_call_handle_inactive_ctx()
which removes the control object when the context is inactive.
damos_walk() has no equivalent cleanup.

## Impact

1. PERMANENT LOCKUP DOS: After on->off->update_schemes_tried_regions,
   all future tried_regions queries return -EBUSY forever until
   the DAMON context is destroyed.

2. DANGLING POINTER: ctx->walk_control points to freed stack memory.
   The struct damos_walk_control contains a function pointer
   (walk_fn). If any DAMON API consumer reuses the same ctx after
   damos_walk() returns -EINVAL and kdamond is restarted, it would
   dereference the dangling pointer in damos_walk_call_walk()
   (which calls control->walk_fn) or damos_walk_cancel().

Reported-by: Raul Pazem=E9cxas <raul_pazemecxas@hotmail.com>

Best regards,
Raul

--_000_CPUPR80MB817114F8F409F0293D3799C1956CACPUPR80MB8171lamp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);">
<span class=3D"elementToProof">I found a bug in damos_walk() that leaves a =
dangling walk_control</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">pointer when called on an inactive context. =
The pattern is</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">structurally identical to the bug fixed in c=
ommit f9132fbc2e83</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">(&quot;mm/damon/core: remove call_control in=
 inactive contexts&quot;) for</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">damon_call().</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">## Description</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">damos_walk() sets ctx-&gt;walk_control to po=
int to a caller-provided</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">stack-allocated control structure (core.c li=
ne 1560), then checks</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">if the DAMON context is running (line 1562).=
 If the context is</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">inactive, it returns -EINVAL (line 1563) WIT=
HOUT clearing</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">ctx-&gt;walk_control back to NULL.</span></d=
iv>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">This leaves a dangling pointer. Subsequent d=
amos_walk() calls see</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">the non-NULL stale pointer and return -EBUSY=
, permanently locking</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">the DAMOS tried_regions interface.</span></d=
iv>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">## Affected versions</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">Introduced in: commit bf0eaba0ff9c (&quot;mm=
/damon/core: implement damos_walk()&quot;)</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">First affected release: v6.14-rc1</span></di=
v>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">Affected stable releases: v6.14, v6.15, v6.1=
6, v6.17, v6.18, v6.19</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">Tested on: 6.19.0 (commit ca4ee40bf13d, QEMU=
/KVM x86_64)</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">Current mainline: UNFIXED</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">## Reproduction (confirmed on 6.19.0, CONFIG=
_DAMON=3Dy CONFIG_DAMON_SYSFS=3Dy)</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; DAMON=3D/sys/kernel/mm/damon/admin/kd=
amonds</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; # Setup context with scheme</span></d=
iv>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; echo 1 &gt; $DAMON/nr_kdamonds</span>=
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; echo 1 &gt; $DAMON/0/contexts/nr_cont=
exts</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; echo vaddr &gt; $DAMON/0/contexts/0/o=
perations</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; echo 1 &gt; $DAMON/0/contexts/0/targe=
ts/nr_targets</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; echo $$ &gt; $DAMON/0/contexts/0/targ=
ets/0/pid_target</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; echo 1 &gt; $DAMON/0/contexts/0/schem=
es/nr_schemes</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; echo stat &gt; $DAMON/0/contexts/0/sc=
hemes/0/action</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; # Start then stop (ctx stays allocate=
d per sysfs design)</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; echo on &gt; $DAMON/0/state</span></d=
iv>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; sleep 1</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; echo off &gt; $DAMON/0/state</span></=
div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; sleep 1</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; # Trigger bug: damos_walk() on inacti=
ve context</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; echo &quot;update_schemes_tried_regio=
ns&quot; &gt; $DAMON/0/state</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; # Returns -EINVAL, walk_control left =
dangling</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; # Confirm: second call gets -EBUSY (d=
angling pointer !=3D NULL)</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; echo &quot;update_schemes_tried_regio=
ns&quot; &gt; $DAMON/0/state</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; # Returns -EBUSY -- interface permane=
ntly locked</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">## Tested output</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; First call: &nbsp;-EINVAL (Invalid ar=
gument)</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; Second call: -EBUSY (Device or resour=
ce busy) &lt;-- BUG confirmed</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">## Root cause</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">Commit bf0eaba0ff9c (&quot;mm/damon/core: im=
plement damos_walk()&quot;)</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">introduced this function without cleanup on =
the -EINVAL error path.</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">The sibling function damon_call() had the ex=
act same bug and was</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">fixed in f9132fbc2e83 by adding damon_call_h=
andle_inactive_ctx()</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">which removes the control object when the co=
ntext is inactive.</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">damos_walk() has no equivalent cleanup.</spa=
n></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">## Impact</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">1. PERMANENT LOCKUP DOS: After on-&gt;off-&g=
t;update_schemes_tried_regions,</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; &nbsp;all future tried_regions querie=
s return -EBUSY forever until</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; &nbsp;the DAMON context is destroyed.=
</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">2. DANGLING POINTER: ctx-&gt;walk_control po=
ints to freed stack memory.</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; &nbsp;The struct damos_walk_control c=
ontains a function pointer</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; &nbsp;(walk_fn). If any DAMON API con=
sumer reuses the same ctx after</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; &nbsp;damos_walk() returns -EINVAL an=
d kdamond is restarted, it would</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; &nbsp;dereference the dangling pointe=
r in damos_walk_call_walk()</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">&nbsp; &nbsp;(which calls control-&gt;walk_f=
n) or damos_walk_cancel().</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">Reported-by: Raul Pazem=E9cxas &lt;raul_paze=
mecxas@hotmail.com&gt;</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">Best regards,</span></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<span class=3D"elementToProof">Raul</span></div>
</body>
</html>

--_000_CPUPR80MB817114F8F409F0293D3799C1956CACPUPR80MB8171lamp_--

