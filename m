Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9429C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 13:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390416B007B; Fri,  1 Aug 2025 09:40:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3411D6B0088; Fri,  1 Aug 2025 09:40:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2088D6B008A; Fri,  1 Aug 2025 09:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 095906B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:40:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8924856677
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:40:57 +0000 (UTC)
X-FDA: 83728299354.02.DB525AB
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8BA0F20003
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:40:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kuka.com header.s=selector2 header.b=SXaH21kT;
	dmarc=pass (policy=quarantine) header.from=kuka.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of Alexander.Krabler@kuka.com designates 40.107.162.59 as permitted sender) smtp.mailfrom=Alexander.Krabler@kuka.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754055654; a=rsa-sha256;
	cv=pass;
	b=LGBezHArGzx7wLGd7OkZ4tVeQcdWTNhpRxt9XxUjEDJ0xDGE3TLJsBrwcgX29c3l/lu7Z0
	UmoY052dwIzpoSgivp+kIqiQaV+vkbMj0y0GDeYRSyg9TvWBr4sLLtQHrW2l9zh1HOElTx
	89HmqvLm5OVQ88XFC7qNhL2AMRSAQfU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=kuka.com header.s=selector2 header.b=SXaH21kT;
	dmarc=pass (policy=quarantine) header.from=kuka.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of Alexander.Krabler@kuka.com designates 40.107.162.59 as permitted sender) smtp.mailfrom=Alexander.Krabler@kuka.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754055654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FmE2FiadUilQKuPiloP5laFBAVCWpDzAMOhoUj8Sc6U=;
	b=cHQRbLY8B04mWfbLGc8JfL4+MtzYX+1kFRwWCCTjKVnf6j1jzTGjK/8BnLC6wYYxR/fRFp
	Wz8U6pTZ0AF7gxwN4yAouwqfqOR7JBs+II/4RtBtYZcuCucHEzKaZc3wxAPr7d/rbGWP4s
	wswUnxNURXc3Xi68O3n98kfGkUUNLF4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kqXRC85nktktt6eej0U4EjomyfoQ4VYNJHhk65avV2z5tXCBtjBeR3qQFZIan+Uv+nFgpOu3xX89p9wekpxhjgryQCDDX5SuU3Wfmi0oL9U/jFP26BcNOhfMqXZ7TqHgucmwuV0THwBvyZn0DMljuZZO5BxL0gVDtq5BPhShcsru3aKE6gX/4RO3DIKZmaTiACJmolaA1WHgRQtGgFK8xlJCt+9h71dvjc/BaJCeKOPLkRFDdzQMPEzdC+V2GTee0N8XuHhmPgCUlcnlcCoFikoeRGoDSyo/bZS6CKf5IpkHzKwlHKasWjCIFasiyzsum74+bOcr7cxhlCcic2wg9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmE2FiadUilQKuPiloP5laFBAVCWpDzAMOhoUj8Sc6U=;
 b=ywH0FYsIB6hpPCKHj1tmRMO5eg1OywXpLByT/jIo52cbYYZgCVbvKSm5B2KdZTwCa8tOe0bg/LrfIXiYRdpJR6uY6Wo2SCJYbnOjWOLeJhEfcyA8qFDS+VLAkTwbzjyj+zHpBb9Gd7yprE8sQHgUbjbMov8Qt1TDc0uZGBLS6+nKWAd274DKIoj9jveNY5xswT7b5V2O/B6BHCqVEA+Tj1xcCtTTtyxT9gJx+TyYzUc50nu3WIwu//syBbbxqDwmqISJ4ZZlGdX2fgX1hvaKhzP3ur+a91Rkdj3PfEF0vLY1RDTZnGTIQDWHLbwCoq5YjkfTi4cPVOWdbY+lLTYVZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuka.com; dmarc=pass action=none header.from=kuka.com;
 dkim=pass header.d=kuka.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuka.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmE2FiadUilQKuPiloP5laFBAVCWpDzAMOhoUj8Sc6U=;
 b=SXaH21kTXd2OJQ3KibFortZGcfnBTKGkJF6dvQ+5frgNJSuE1w8JDLVSxipQbahRgoe6YR2yrGL8NqhdYWAGt/RrWFGz0hGuH/HQU04ra1bPeCYI7EmzAzYopd+HFJK48PqXk43VASkOi4snVd/dZPf9rS5iT23o61IJuqnCqM78caeCzTCqjjr5i5q50s1bmUJbYQhMa3pclYmoeHDnQcScYEndRleDtHnVQu7pIQrgwMbzjwK6IiNsHDxdq7mliQHoBPTTfYfdutl7+35wHqZyfajdlfl0jLPmS3ACdisArlMLGkdDVUkKpYJOxbRaM6ntp1fKs9hJhrnH9TDz+Q==
Received: from DU0PR01MB10385.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:322::12) by AM7PPFD74AFDFE2.eurprd01.prod.exchangelabs.com
 (2603:10a6:20f:fff1::7ac) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.14; Fri, 1 Aug
 2025 13:40:50 +0000
Received: from DU0PR01MB10385.eurprd01.prod.exchangelabs.com
 ([fe80::27a:7a68:5d97:fae3]) by DU0PR01MB10385.eurprd01.prod.exchangelabs.com
 ([fe80::27a:7a68:5d97:fae3%5]) with mapi id 15.20.8964.019; Fri, 1 Aug 2025
 13:40:50 +0000
From: Alexander Krabler <Alexander.Krabler@kuka.com>
To: Vlastimil Babka <vbabka@suse.cz>, Frank van der Linden <fvdl@google.com>,
	Mike Galbraith <efault@gmx.de>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Dennis Schimmel
	<Dennis.Schimmel@kuka.com>, Daniel Braunwarth <Daniel.Braunwarth@kuka.com>
Subject: Re: Realtime threads delayed due to kcompactd0
Thread-Topic: Realtime threads delayed due to kcompactd0
Thread-Index:
 AQHb/SUMECAAoxVz1UW75TJas4YXXLRMmU4AgAABygCAAIeOAIAAeK4AgAAXRlmAABqvAIAACbGH
Date: Fri, 1 Aug 2025 13:40:50 +0000
Message-ID:
 <DU0PR01MB10385C08C119276D99A234D978226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
References:
 <DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com>
 <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz>
 <026de9fcd4f0ed17c2df95c4f7c56b878a844012.camel@gmx.de>
 <25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz>
 <DU0PR01MB103857873A56FD121984568148226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <c48f2877-4d37-4310-995e-fc5c2ae9a366@suse.cz>
In-Reply-To: <c48f2877-4d37-4310-995e-fc5c2ae9a366@suse.cz>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Enabled=True;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_SiteId=5a5c4bcf-d285-44af-8f19-ca72d454f6f7;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_SetDate=2025-08-01T13:40:50.541Z;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Name=Public;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_ContentBits=0;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Method=Privileged;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR01MB10385:EE_|AM7PPFD74AFDFE2:EE_
x-ms-office365-filtering-correlation-id: 481ac3c8-14b6-4b96-65c9-08ddd1010788
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?LVaoHdkiTc20in7utvq87PZj2CxFF1bGBOWTwFNnBNdKm/5vWyxv4nMKQI?=
 =?iso-8859-1?Q?8SDPnvIvz/XpdaE804V6gdzwD3wQwev3RsJgJ0ypKAybx10tnXP+i8Bjyr?=
 =?iso-8859-1?Q?+aFW+I4OW7u1IaDaZWNKViiH6aFxca4rrMz2uvgu+tgrhL5BWydeRXJp7a?=
 =?iso-8859-1?Q?rMFYWpCQ1V+vOtHW6d0WLIS1hoVw+6OEvF7KVscD6LfG5WpeXxK5Kp15LD?=
 =?iso-8859-1?Q?0m3Sr5p6vmgm38fxOykZ+/JvGwJcdrFWAjbEeHF+I8KgSn8pX3KRRxgfpF?=
 =?iso-8859-1?Q?w6HZjHm2FonIciNBJ/Q0sJeeKt8FZRQ+fmlOZc9GcziDtJFfZwqQGeW8Tf?=
 =?iso-8859-1?Q?B/GfdxFk2cINnaPUoJbe50SRbwn1/96jnezAXZzXExmzpQRu4J8PEjy4Aq?=
 =?iso-8859-1?Q?DRns/w5H35WCgW5z++AnZ7DyJzIbZxCcqD5gTCyVvh6yQYP618TrLf9DOP?=
 =?iso-8859-1?Q?bCWPv7MuFeWG8/opds/R+uTAyCD9JBadANmVHhkvqDvtsGQuTZwWAH/K8i?=
 =?iso-8859-1?Q?TKj/LjIW+3TKdZeC6uIkZF8MKmdzO9YOLqL/a91LwQfmCyTJDjZzpvlDMI?=
 =?iso-8859-1?Q?Xqj9v+Z/J8IGvSwteWGGdykIE863/U1t3R7uyME7DtZRUY/4OmApwVg/dw?=
 =?iso-8859-1?Q?ysSxLev/kViUiz8Zb0c5tkwAHseF05fbjZtkZ1JHFuBfH6+iWpbfz/PYEm?=
 =?iso-8859-1?Q?eL6+vCo5RDKH7HRC9WGF5oyKKpBUh9+xUUjaAtA3REliFwAroClGfEDSDl?=
 =?iso-8859-1?Q?dz0Q5k1bOPtN3pVsHxji50oJSGKRxvzTu+WsFe1VyWvat8ZZiCgWxkoOoV?=
 =?iso-8859-1?Q?ksCBr14MhPmWCpHe6eYXbEbErYTNVx884d8nxp0Vvigs9VOO2anO44NhhF?=
 =?iso-8859-1?Q?LhSLv8X6fa51xUa6VnDudndnMagqJaQgWVtwZ94GLKeLD1SyXeNq79SbO9?=
 =?iso-8859-1?Q?Fs5yRg53s1a+qE78YtbjpXdT/LGg3KJ/eJURuRDJ2ARtjtYxthcXKCzJMo?=
 =?iso-8859-1?Q?hY1hHpwATIlOn0+1M8+fKJR/F8I/Snnf/0m3bPG1Awddr4khp3h4PJDL24?=
 =?iso-8859-1?Q?b7QL4aghFaoI1r7PbTc2Z1rnneo5JE2TUozLV9EA2bZMjGm8edecMdoTX8?=
 =?iso-8859-1?Q?lMzG4ELgCNWqxKk3wH24JIYyZVXk+m9ej4HPZ3KplkIuYQqaEOEqG5v4y5?=
 =?iso-8859-1?Q?rbfl1Nu9JuCxYrZk7nYnqJpEVWWgcQn8PtbCzxNzcct2gSVEzUX2TWgRi5?=
 =?iso-8859-1?Q?MTadE0n6NwFH3S9J3AmqUFfkBbEJP3t8MTHn5KysplSOT0ekWWYD8tkIdA?=
 =?iso-8859-1?Q?ghNmguL2U+QRs/jEqK21LKyiUgTPFPajdodT0Z67PvPu6/x/c1oSRMlPYo?=
 =?iso-8859-1?Q?cuV+0rZe/sRxYZ60Dt5B2ADx/8YH62RX0dj4t9kDRKK1CafaZrKB7c99cS?=
 =?iso-8859-1?Q?kXguXU9jZfswD7VJEslFJpKQCPzPa6IicFud247WbNWGVM2iR9BJBw3Ln7?=
 =?iso-8859-1?Q?w=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR01MB10385.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?hqgpI+TOnT3ygyC3hnD2M3IC8hgfEqlQFa+fPK8MFXWIW1tYyHl3lJhF90?=
 =?iso-8859-1?Q?A4Lqjzo3RXoGNWqTu/7FmsL4X0fXcyp23DKPTIEdATgB7sqBJH/feAAJY9?=
 =?iso-8859-1?Q?viz6tvVlg/SWsPzjwSY8O3SM1hJq07dFRDqSgalyVXTr6c9O4KuDyjocAd?=
 =?iso-8859-1?Q?hYuGUEbVNkba2vTO7LpsRNEDnzQ2zc7lRcSHIlbpoT4yJ3rKZdG6KVz6EZ?=
 =?iso-8859-1?Q?yC6oakm5GbAj7/BaK5tuKum9L1JniojevVIrh0E5NJ3hXGN/SuYSIKP68f?=
 =?iso-8859-1?Q?EzYq6U0PJJ7R18lfYBFl2p0TpVSrExoPAgwJeQCfTdFQZDr8aEaB3p8smh?=
 =?iso-8859-1?Q?wlK+BlN/DFP4159AuUa3obCnnWZ189xyuFeGufLAMZbA5BfFoCOvnLnBhY?=
 =?iso-8859-1?Q?ZxNCpjbUAZUmDRe90M5ccWx7dtHoYkF+0b694fPig3wKAvTzODnLQPZ3MC?=
 =?iso-8859-1?Q?Q0yc88stIe+ycQqx64l5+DG987cW7sFZ8qftl/mzaEOXS86QmNMlLMZxlA?=
 =?iso-8859-1?Q?istrHGH/cD8qduJjr6G2VizfZvXjTA/AW2164+QTMlU1NzNTCfsW+WkwRY?=
 =?iso-8859-1?Q?rhft34euh8QaPHRWTEdb1nU8qamzgNs2jaqsc/O0mGzOAaSrZAZQ3beuds?=
 =?iso-8859-1?Q?sGvnnzGvq7XQZhXkygIOvAZ30Ku+I87AZaKBbMl3APLXOZv1qH2r2O087W?=
 =?iso-8859-1?Q?t7GWBoRIpKu9ZypAKzXxo05XxhffWj/ZaACI/bDbJQjV5iXk53H+bniOYS?=
 =?iso-8859-1?Q?O+QdyKrlPP7255G90Uyrnutac+Td7+p6UGI7rlqHUaa7TMDvjnqTLsiqmA?=
 =?iso-8859-1?Q?8+UVwsUDiu6MxJqMTRSOKaUygK24f2KGjPbQ8wGz/uw5TcIaighmIHQY0f?=
 =?iso-8859-1?Q?ED0Gmr5l6Om/yAximlz3IuwRb0mez3Rai1Wxs/Joxf9V8DaveCoHtR4Qhu?=
 =?iso-8859-1?Q?IzZSvDZIv3UyIpFOtTaSeUjhmd+kkT6fzxEiVU66mrM/XhQIc9ki4yZiOE?=
 =?iso-8859-1?Q?SI+jriXYtGvmeNNv9Yd0OfQNJQ6rDtDDdtrgsAR47i5+RLw/s1o/Dj9llJ?=
 =?iso-8859-1?Q?L947bJXc2SqS+HnsNgcVdB+JWaeq/CKxjXoeZPXJIGpqgdPWvav5YyU6ig?=
 =?iso-8859-1?Q?U/O1+abJwKMaLnGRG0hpp6E8H4Th7XQ/tt/HP81TUsg2eBR4rTXJvgOzEo?=
 =?iso-8859-1?Q?NyOJaVemqbr8376WqDmtgEjqKW0rbrpQbZ4vMOD3O1ldS/ylcpnz6o+m77?=
 =?iso-8859-1?Q?PPb6ZcpWyfMM6X35cOq+Gk8L3y4VFCPoM0tXkJpyuEWUpLM7A1RIPaRrAt?=
 =?iso-8859-1?Q?JaZskh0EB42IBIAmCjA10nsOg460ew1drvxW+A6Pz6H65IW9pgsPab+GAY?=
 =?iso-8859-1?Q?w0T213hZiH4ycnI4TutWfYfmTXHngVNbY8oBifzMOY7aTz2gqZFRRnKvpw?=
 =?iso-8859-1?Q?/chALXfgHnl5T/oyrEKB463kwWxc7AGrQVPkVaLQImASYrkomi3hXuvdFM?=
 =?iso-8859-1?Q?AwuJHQTNm260rNA+y3ssus9QR/0zHxxLxwTgVFDyS+MJk9VwNPUszWC1xq?=
 =?iso-8859-1?Q?+CWeVOzblElwfOoJW374UIYaQTq34nUHpbtrKHxHjl2WTQmDzXqD8ZYzEm?=
 =?iso-8859-1?Q?Y1il+AFeY5MkDqCxdJvfhOY/eNRZlzab6a?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: kuka.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR01MB10385.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 481ac3c8-14b6-4b96-65c9-08ddd1010788
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2025 13:40:50.7944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a5c4bcf-d285-44af-8f19-ca72d454f6f7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QykkPZyFhNv6+GhYgxOM03Lr6TVR+02QeDzsfEQSvmef9K+madqpfJL71vGze6Y4tv2enwNj89q3L8HOBFjv9dZ4I3Ax1WLiIUkVFeekShk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PPFD74AFDFE2
X-Rspamd-Queue-Id: 8BA0F20003
X-Stat-Signature: 35nj5yakecspby1ybgsycjjskh5wm78e
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754055654-439255
X-HE-Meta: U2FsdGVkX1/HrgWjwRoTOBmPaccw2y8cmSiD53baPARGEI853IH5FLSmo0ATVphAtz4WqQLXL2wMhdXjH7zShaBdSmmPbierW0CK+uN3Tgxji1M4uF6AVI3nW8VVNv+0FwL1LSZWWd13JrVevpNwLvXW2ZMN+xz444MPaEAZYBczJIo8sj9bJaIy03NmTSWV2g0olaLibmhdMJrv5Q5Dnn3hwCaDtNAcJ3ds8VpcOmPLnc8K3/1mBBqROqwT4xXPjQ9zng7pbeSmqaHhfJjHTFcZGsG4viVpeMfsszV9//7jM1NJZyhO+9Vh2zui8332SuMeBAlCiGtax4eCArJsAFCtC6wX98gYYcBZFjNYtrW3YDEC+uA/qcPfD6F4d4sUdLtSuqZyjQxf37gqbeajNtxnAuLaE8ZpaNKPFfs3sc2P3kqXLJmDVjbklikA76GxtzG5UuAKOUE9bsSBbYRQ2Cuqae+If3kpxEZQWeb75+xDbB9NUCps9kmwh9edJYHcSqqNmwstGzfXltosD6h5KsF5FOoFIVVDVJ5RTuOg0p2ZsPuxjsnz8pHaQPCQBksoV1W23kzSaRCokYaxkN8dc4p8d3p5uwKpLQOyszFmpFh+4fC0jM7HBaQwPjldd9ezkzEHQngm64wsHpxD32ATBttfn7qFgAfK/xn/iyeT4kzHAqfNYZIPAou7Iili1S5diE0V82PFtB9/tVU+N6U+YHhFQSbrLETRMlhmdqob4cxe7Q7dfxvanqZ4T+M7VZmIvKBzCXHnTdsPX3gp4HUu4VzcjEfwlDFDfjjwWFN73b1ir05+V7UNRQUz7kmDCbDmwJYRRa7j06MoonoZDxZVtD3P9iPws23waMtF7RIDx1r4ltnuje6y4hQhagIJF7zH0g4ustNrrNAMCQ34OGO9krG/JtbYVlvlJsl4WjAPsfD0bAC69S8/mtMSPS0GICX7Xz+QDE4M7JU6a9nfPrW
 9t/Or+D9
 O7docipKIhGFeRRVP0nCCWzK8mpwWzGwPBsB9hVVaPSVD5ZDbDuZ0piuHLOOA1eJNR4SRkp64AGXf5p0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000439, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/25 14:57, Vlastimil Babka wrote:
> Hm that means something isn't working as intended. Do the pages have also
> the unevictable flag?

I have checked /proc/<pid>/smaps.
Neither the manpage (https://www.man7.org/linux/man-pages/man5/proc_pid_sma=
ps.5.html)
nor kernel source code (fs/proc/task_mmu.c show_smap_vma_flags) tells me ab=
out unevictable flag.

What exactly do you mean?

Alexander
KUKA Deutschland GmbH   Board of Directors: Michael J=FCrgens (Chairman), D=
irk Busch, Johan Naten, Hui Zhang   Registered Office: Augsburg HRB 14914

This e-mail may contain confidential and/or privileged information. If you =
are not the intended recipient (or have received this e-mail in error) plea=
se notify the sender immediately and destroy this e-mail. Any unauthorized =
copying, disclosure or distribution of contents of this e-mail is strictly =
forbidden.

Please consider the environment before printing this e-mail.

