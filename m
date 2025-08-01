Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70BF3C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 11:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D7566B008A; Fri,  1 Aug 2025 07:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 087C06B008C; Fri,  1 Aug 2025 07:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E91456B0092; Fri,  1 Aug 2025 07:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D30966B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 07:23:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8ACCB1A0834
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:23:43 +0000 (UTC)
X-FDA: 83727953526.17.67A9961
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011063.outbound.protection.outlook.com [52.101.70.63])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6C074180008
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:23:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kuka.com header.s=selector2 header.b=0u7iZDlU;
	dmarc=pass (policy=quarantine) header.from=kuka.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of Alexander.Krabler@kuka.com designates 52.101.70.63 as permitted sender) smtp.mailfrom=Alexander.Krabler@kuka.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754047420; a=rsa-sha256;
	cv=pass;
	b=NTI6gL3uO31ZDKypxJP5e67MDFJc5EMzyZ8fFvpTm0OuwwefdN6L/08pFiU5mtn1agtJA/
	VLEVnL2iSQVovzg4JHpE9GQoFUDfDDucyGZxamr79R0zUSgoL1vDsKkF2eUcoINcdqLtye
	2KMz2E/VTWqrJ5eQn8ixVToAlV6ckHA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=kuka.com header.s=selector2 header.b=0u7iZDlU;
	dmarc=pass (policy=quarantine) header.from=kuka.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of Alexander.Krabler@kuka.com designates 52.101.70.63 as permitted sender) smtp.mailfrom=Alexander.Krabler@kuka.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754047420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enCxvAYp2RBnpD5YdyzKTQJKaFdPxVItCFe73pGs/NI=;
	b=gmCu4LJeskDBKzzicc0XazvzRnY4soOS7ntv9qo26Khcd9QnQ42fPGcCcGAyFcaewtQazS
	PV+1EdMZQuvImhNPb28SEmTSKrdxv824J884X1XfE0kV1zN3PJnS2/9vowcX7hz9dqf9tI
	NKkLA1BU1CtZAYRvxOYRvBQBAyhrUJ8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I2DxJiCsIKFz6asNnwj0tGfFl/TP8fLFBri4UUc7+WlxCY+Y0FRZXuRD0ZTr9N6p35FZmCfUZ/Pf0mK/Fk+8fYYd92NzQgRTgxVgA6P/DLB3fiKiau2M8rzEdU6xFREHrEmrYFlyW2X5dGGUHkT3Rg7BQ+g5PjGQZvyPR4cmHQQ+CvB3/96KKtiGEJgF03OkMjnZMgEvvd7fnPXVCuH46IACuuAyJ9+J6Mt0tJAJFoEASp/YVyb848mtxsKEMikNnSeBYxxDJ9deDszBGInA9uwMj7sNlgM5ZKDYLmaK9D14wkQK9DjdpZHwTchGShlY1+xqb0CD60nVprpxea6OrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enCxvAYp2RBnpD5YdyzKTQJKaFdPxVItCFe73pGs/NI=;
 b=S1iMxr0igUTRGLTKCIXqpv9DJtIUDDRxDDgtktzJgDdjdS2jl4fp+zVJTvutAGpvyold4D5W4CJfxV5abdwcV3a7Kxw8z4RWMiL6noWfK4bCrBMtvOdMZEkPARKQXeqCM8xhLxNczqngkYUhJWOJJIdHvK0Vbo5S51HsyjiEV2C6Mj9dpO8JuJt0SkibDD5w0bLHnARWt/iVvHGHYN98Z/KsBFL8bTp6iXLYYPYL2pH5RbtBqaLTehNul8m6sCMNwK70tT37697Q1nXqEQXKCv4gvc88AMjT5DAAIVX4Yv14F8KXhrvu3V/C8fdcavDz7ySc3/d1RvFDJ8P+T563Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuka.com; dmarc=pass action=none header.from=kuka.com;
 dkim=pass header.d=kuka.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuka.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enCxvAYp2RBnpD5YdyzKTQJKaFdPxVItCFe73pGs/NI=;
 b=0u7iZDlUrPttXje3ry95bzIFnWB6ls7QUoMB2HaxtPKjBm9VImTDfkmljvnDzPUpjh25lh3gXtYH3rjKwwRgzO1T4M71j+DCOP4O803873QpUKYXhpufjkPXNi9X0b43/kBqaX+Cp2s8UgikwAYgTtnqTr2n7m+grmrxvlB7OUqYLe7FudKLWrVqrCh+jGCtMwBQPid1TUjGwBQ9O1JrikY8OllBF2WZzU0r5ZfSLnYDPgKmJ7QqXrj4ht2aTsnbnLrxXCRKB+C2CkS9ywdIDpt2FUD7fniKGVPCbCbmO9iA9X/RtobIOiNRP7pLQaaWSCuWiRbpEXKbEcITdTmacQ==
Received: from DU0PR01MB10385.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:322::12) by DBAPR01MB6725.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:188::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.5; Fri, 1 Aug
 2025 11:23:37 +0000
Received: from DU0PR01MB10385.eurprd01.prod.exchangelabs.com
 ([fe80::27a:7a68:5d97:fae3]) by DU0PR01MB10385.eurprd01.prod.exchangelabs.com
 ([fe80::27a:7a68:5d97:fae3%5]) with mapi id 15.20.8964.019; Fri, 1 Aug 2025
 11:23:37 +0000
From: Alexander Krabler <Alexander.Krabler@kuka.com>
To: Vlastimil Babka <vbabka@suse.cz>, Mike Galbraith <efault@gmx.de>, Frank
 van der Linden <fvdl@google.com>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Dennis Schimmel
	<Dennis.Schimmel@kuka.com>, Daniel Braunwarth <Daniel.Braunwarth@kuka.com>
Subject: Re: Realtime threads delayed due to kcompactd0
Thread-Topic: Realtime threads delayed due to kcompactd0
Thread-Index: AQHb/SUMECAAoxVz1UW75TJas4YXXLRMmU4AgAABygCAAIeOAIAAeK4AgAAXRlk=
Date: Fri, 1 Aug 2025 11:23:36 +0000
Message-ID:
 <DU0PR01MB103857873A56FD121984568148226A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
References:
 <DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com>
 <CAPTztWYf82p6hq=Q2mVq6_9WTjRaQiH81z4idZL6MZ1PXufPwQ@mail.gmail.com>
 <71df781c-3ef3-4b26-9ba8-93fc7d4f9eec@suse.cz>
 <026de9fcd4f0ed17c2df95c4f7c56b878a844012.camel@gmx.de>
 <25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz>
In-Reply-To: <25ba0d77-eb61-4efc-b2fc-73878cbd85c1@suse.cz>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Enabled=True;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_SiteId=5a5c4bcf-d285-44af-8f19-ca72d454f6f7;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_SetDate=2025-08-01T11:23:36.331Z;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Name=Public;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_ContentBits=0;MSIP_Label_717b8430-11b4-47ed-b1b2-7ef5cdca0b43_Method=Privileged;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR01MB10385:EE_|DBAPR01MB6725:EE_
x-ms-office365-filtering-correlation-id: da8dca1c-f12a-46e0-8d18-08ddd0eddbd8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?VL9cP5AHOI1o9HdDFRCHTiZzLVNb/DTuQ7Jl9d5qMaHW0/DZ6iVYuMRCg6?=
 =?iso-8859-1?Q?V+2naSAZxGE5t5HKhjgOd7n6Vcztyi+kw0Qg0L0jAONaIX89ieNvldmyFH?=
 =?iso-8859-1?Q?XuT12hPAapvIMM3IyTiaxPD1RJv6G+UjG+mwT/43b39BpObKR2UUXoqmga?=
 =?iso-8859-1?Q?N3AyEG0wP8OgRWFtE3uTBPKhHUPc5bCPESmkRsQ3CWyNK6H+oyFQr26HsW?=
 =?iso-8859-1?Q?bWqBBp+xRf1d2iFQwpvzgAKVMcT2Z2gNczGBD04u4nFtCpJXBlYcy+OnwM?=
 =?iso-8859-1?Q?yyU+x5MynSayaSYqxAnm/xtQqIJpubwFnyaw0QHjWVXJ1JqS000/xwqwsY?=
 =?iso-8859-1?Q?U17jyznKVAtm1U2godOY3of7vV1fYxdS1COm0Dujs1ywy1ra61pXwtc/29?=
 =?iso-8859-1?Q?nINHY92SGuhA3nPtYmz2iulGOcXXtdv4YxwEq3l9lXK+L7qNn9m6AImYzY?=
 =?iso-8859-1?Q?tSbH/4eMGEN2e2Xyp9vBE5jnw2qPEr6Q13NVczOwNkDeWNziQtsBoR0+0b?=
 =?iso-8859-1?Q?odrxWZ4O/QFTgVIkjETI6YVrVJIdkla3Q7WC+8PFWjM/RREuY9OG4gesgF?=
 =?iso-8859-1?Q?zB+pB3vmIiJo33N0miLOhvimddb+5NVtfPYqQmjh3VqlA7jcGrNG+qEgOC?=
 =?iso-8859-1?Q?NJ36L/MANB3RnB7In77tzbvxZJq4zTPyFoOjlM2jEQMaqgJ2pfMlfCBjLQ?=
 =?iso-8859-1?Q?YfHV4OwgzjgzuUQxu9V/yHtXgu8yFjROeL4JdKPX77TBTYV1UNtpkiW754?=
 =?iso-8859-1?Q?+XoQ57HlgI6VKiLgtV75lJ79i1V8SsQn60DF20kYvkNiud+DqjtmXJglHY?=
 =?iso-8859-1?Q?1olR2GVHf/1SdP/sQdJDusGkX+sZjP8gXN/i7yb5P/zKY9twpjmea/WMFn?=
 =?iso-8859-1?Q?iyc1bVBNAJoF83uGWbCLbxCFDaRsbhJbFpQ1Uaen+ouhnhsZ8jI4mY71yV?=
 =?iso-8859-1?Q?sdd9z3E0Y3mBYU6T/TQvMN1+gmN26qZmuX3gz5DTe/15bXrhda+NOmB8rj?=
 =?iso-8859-1?Q?LJsmvapg7Bo9TM8qRngnFyHh7/POohst9HjEZVZpGV8GJXixmovSXxdzyK?=
 =?iso-8859-1?Q?dFF1YXd0lR5gQvQebH1bTBajPXeqVWwBDu89LD/FMrjB0rrgj9YFTjL98O?=
 =?iso-8859-1?Q?tSlRDmcbc5hzIIzfcBV3cm5Pqu+s6CDRbCCp4VqLJzCxGhInUrIsJTnWMT?=
 =?iso-8859-1?Q?qJTmFFRVXPfof3tO4K545PRjnxjCzl8qvQDgqNgpSvwneNahwwZ4basSwa?=
 =?iso-8859-1?Q?ymNF7eNjq46j7hDmmJ4iqKcUmAcdoJx8VM3VG2agHgareoqN0m0YNuwR6w?=
 =?iso-8859-1?Q?1+DVj0Fsd160bdPhYF/GCltY0AbIoui/b6L052qHXDI/YI1XUhmxoujCOc?=
 =?iso-8859-1?Q?15bXAwVm51NpId7Yq0xSwRL27mjobsnyWSxW/jFpcAcXy2vhm+jn66glRy?=
 =?iso-8859-1?Q?QqJ8De3B2RiX5lUajQy18RGSo5dTkbp2YioYC6JObu+vOswrO69H/In6mA?=
 =?iso-8859-1?Q?j3vQcL+9SFsGQO7qH+LWTqPie59zNRRIWr1FD3ayhyVg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR01MB10385.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?KbWEsjtO2vfB4pp9aiulziPU2+CdhVJ8aDX4k7UATxY/c0efyE8VYc7aEh?=
 =?iso-8859-1?Q?lSVyh1A7MXht36WtQqHhvE6PeM8hSLbKZ/mSR118rqvn7wJd3xjieCMn5v?=
 =?iso-8859-1?Q?W77PCUxH+GMZZ4ZE529Hx4Js2gzQ4vORfAP75dF4hSnJsRD+QZ+ljBz6Ek?=
 =?iso-8859-1?Q?WfIR/wzo5TDzGNWmefdiWua+V9cn/9zPCitHwshwj6cXVDPo6VQJsX0Vnk?=
 =?iso-8859-1?Q?MigzghrtVWvNZigR8hZjCKgL62RBbOCeeg2FaNqLiPY8ZPVL3Ec3/WuQ3S?=
 =?iso-8859-1?Q?bsvFdfO8hMGv8a2ovX+WV4NAVN/v58lzmGvOPBb1BJAtp4ZGEBm6OybcLQ?=
 =?iso-8859-1?Q?r5e6pYRaRqYdrj56GxhVf90713PIkxoKPtJM5VHQlb7zWxRKWN0TBLxvwo?=
 =?iso-8859-1?Q?v4CP5+uq5fWymzdhh7VV+qbpHKKnlPZZjZkOwxIsnCmnNeET6MjWw2rg10?=
 =?iso-8859-1?Q?9Sw1zCK+QZHAT80DmmbqYL/WWH4jnOjYEv0PYQrf8SLD7pkN3V6XVGtaPo?=
 =?iso-8859-1?Q?Mr2b246ccF60rnmSwQSjHFEDoGxwdyAyuN6za+/wLh/wFklHubQHTDzRQE?=
 =?iso-8859-1?Q?GXEL6cG1VdGeJ82coaNXB5busTWrCxYGtvnPNjtTpV1W5micMjMvD23ao+?=
 =?iso-8859-1?Q?GZl/6/aVliAkMvsoJrxAMJJQQTNNBJtf0Wz33CnqMtyc/PlLwVDRYBmwpf?=
 =?iso-8859-1?Q?6iYjQc9PbLybghMBBo/EUgm+mHrLYzhmhDf6IeuUs5kIXSeGg98ugA6ZzP?=
 =?iso-8859-1?Q?zE9gxE8Em7wSDBIGMFsSiqK3iUik+xh2AXNoPuajyO/OJWkXX6hiukhdJb?=
 =?iso-8859-1?Q?kN08Y57hTnGCkDzT3svpBRdZankob8dRWDjjPYs0WrmGiawBxomXBpH83u?=
 =?iso-8859-1?Q?3/2NKyGAfiWGzeVL20s3pQoAcy/gyo5KxuZOC8Y2133v6v0UpPMjJWpD06?=
 =?iso-8859-1?Q?FLGEav+xHFVlN+NQicAx5OyvQTyNKrTZ8q4DLHQu893Ra/NnBj0obDfwdd?=
 =?iso-8859-1?Q?+Bs6K/lZt+laFvFg24AGVw3H60F8YGzlLrNaO8F+Pk4lwd+RbVn5KuG6mU?=
 =?iso-8859-1?Q?X8GenK4MIgpPvc4FjUVqv2J7bHFsNNwiR2SW53CAN+ATnHFs0zinsi78Ml?=
 =?iso-8859-1?Q?Ll+aUT31VO/6NHKD+lc9S20P1AMchuIvDOA1yQ9M0DasK7Vypc7dAbj61S?=
 =?iso-8859-1?Q?YsOOPDIgezsHfkJiyYfl8kZNrraKLstxd3GQ90q/1Ivg7lgaP2d+WshL03?=
 =?iso-8859-1?Q?8haYfdwJwP9nuEHGB1q8xKbnv5htqgYRpamKUK+Bhn1XEwopdR3izCbVhE?=
 =?iso-8859-1?Q?dy8P1RCg7FIEibPiYOHf27842WOkiUE4BKw04lgqFCdDk3Or0/oxcDs+eb?=
 =?iso-8859-1?Q?iPA+RVf88wX0fwGskolPTYo+rqaX8hah32hbS1Abk3NH7YAjsx2rJq/msX?=
 =?iso-8859-1?Q?ILchM+XUeiYLZDerWadak9m0x3Umi+LwPxi6MVgpU8pNRfJjGzxJ0MNlXy?=
 =?iso-8859-1?Q?008ZeTQW93Kc4Pk/uDydNibEwFpg4oIH/5AxRYyO2jloIlPmuLC8EJ6SXH?=
 =?iso-8859-1?Q?9Tmk9hfYeF702TXrNV8WhkdV4BrD4cihctjdgbSt8/Ya60pvMLwVhNVej3?=
 =?iso-8859-1?Q?pWNsJz3Fr1T8Pn3Ob/N2BVf7niAT1JYptC?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: kuka.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR01MB10385.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da8dca1c-f12a-46e0-8d18-08ddd0eddbd8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2025 11:23:37.0004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a5c4bcf-d285-44af-8f19-ca72d454f6f7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yHXY3uO6OYTkiuf9huQagpWYR1CV+bMFKoMffDGPpTDSvY+wv1ZFHwHjHZ078Se3xmaiFo7MRFJTMPr7Sls4XQfjFP9uqGFI64pwlXnkQzE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR01MB6725
X-Stat-Signature: t8utngw767w5rjbtz4qgtp98ksfhir1r
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C074180008
X-Rspamd-Server: rspam02
X-HE-Tag: 1754047420-128193
X-HE-Meta: U2FsdGVkX19n+qFHp6mtg3RDOoEzIpTFnpldysQvrmaM21PplJl8WxgI6iJJBINsKDx23gvUtPY7e260/Jr++7jGehcvV6Mh455sjctbVO5BcIpy3pTKAUngIGDIy80Dm1gpNo9X1KaA/rr7xMuUNDGppzaqrTmQB2O6uFZKcbj+QeZWuwF9EZLN7JF7trdd4RKcgVfCWQYzAbAavbeqz4/9cgikauww9TOOipQVN+C1hax3FXtg7cJ+QyN6iH2S60RVfMjFozYaBh2ayG5i9yxdSkKjAPh/i+xIl9fhi2mk/3zGDsw4Nwd40241nEDISlqrlu9cC9RPt0CV/kIsJLLBj93/y+WPVmwifQ4zgIFY4DGhNQcNrsVu3x5ZCwno8E+W1FgeaeebBj82nzLInFVzy+/nl1G0uZr5osJ/rwmHIHtoATxYvquBB1TfD23Lpr3cECp1bi280RtBLUmURJXBP70w/z4O6clmJHmszmouje4Hx9rp3SAmCM0sOBELNx2gFaqiqwrAkU93rVoi/bSnFBSZWu4CEQIU2RIpJciMbaYDWWohi0fx/cvB2A9OFTmgjHbaCLZzb5M2pqyuwpeLVaPtO4Sv6ojej7Qpr8udjZscAm1t/vn/zobGs0QIjz7aon0zHfT0YewCO+M25cP8BpYXa6l51MDpmH7KXlkFYtByO5GSEgKthWu8IQagX8nBE8NC2Qd7WjUZAbH08SPwbQHQT2GoD/VPD+1Ucsrda7jHVYM/g4kwuQHWtDeUeTQLQuMj7WkFjPmezPa1kA5uHBqm4DIsIcUs8q0pAmnW77XlR8blkXnXbDdTiyfkZXh8I8e0XIgNcdIJKPrP0+RxXKwrUvhE0H9wu8NoTOkwXn+cJsPTaBOH551OjCA47WDfYWicCQga5/3DQ1ywi8uR6Lp/2jhKqYytPqKEneV9z46gtoRtEMDHqaGOW5JJe6gTUc60o+nk+fqYCEA
 Wf3pOJBy
 kiRHUdoaiy5hH4EKwezhxqn7L8MhMdTePqz6vZwnjdEY7miEb4e1p1TCxOALHeOJHykjpvL+wp8mU+5/8gdktg0ufrzHuRKqdp5UTbHY27F8fIFpg1b55qeNo9Ac62HnzYjkSuxwQULv3ZIQ6SvIGSsjx3SuTj053kub0g4JLNY9Qf1CM8J21/R2sO72Zt8uxeWzLlAJnEQf7ngwxfWDx258XeRGC7lCw0QEZPSvnhFFh0N1/mqrakSTrlJE/yBIuCPJssi1jr4gQktKqN3AZd1Srlt6C1prtuXmGnJtUvr2gWwjUF3Y9sE3RRDVfwnahRDE4VPM79xAnAPtf7kR9Bzx8Jf2H2KxuD1FijriReQkJ3e0Y81gpzJTPC6+ooWqiC5h1DfQv2ShmlEPl6toU2QX8HwGetCMjcgnlM/uisnJlptAN8cjxOgx9MAfXMXr6+4Ej5KgEFvMJ6z0SCnl0MtP59mm6aQq//Zjcp8ZxXrd2oy5uiG1mNPqQbcdfIZ3FcUaYXB18+p2cuziRWO73/ZVVbO98uMq3dI6R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/25 20:35, Frank van der Linden wrote:
> Not sure what the right thing to do would be. Either explicitly boost
> the priority of a thread temporarily during migrate_pages_batch, or
> mitigate the issue by dealing with 'busy' pages more quickly in
> migrate_pages_batch.
>
> - Frank

I think it would help if priority inheritance would kick in as soon as
another thread is waiting due to the migration PTE.


On 8/1/25 11:58, Vlastimil Babka wrote:
> On 8/1/25 04:46, Mike Galbraith wrote:
> > On Thu, 2025-07-31 at 20:41 +0200, Vlastimil Babka wrote:
> >> On 7/31/25 20:34, Frank van der Linden wrote:
> >> > Not sure what the right thing to do would be. Either explicitly boos=
t
> >> > the priority of a thread temporarily during migrate_pages_batch, or
> >> > mitigate the issue by dealing with 'busy' pages more quickly in
> >> > migrate_pages_batch.
> >>
> >> There's a workaround for realtime tasks. If you mlock[all]() their mem=
ory,
> >> setting sysctl vm.compact_unevictable_allowed to 0 should exclude thes=
e
> >> pages from migration by compaction.
> >
> > Hm, per documentation that's done automatically for PREEMPT_RT...
>
> Oh I see.

Yes, vm.compact_unevictable_allowed is set to 0 in our setup
(default as we have CONFIG_PREEMPT_RT).

> > On CONFIG_PREEMPT_RT the default value is 0 in order to avoid a page fa=
ult, due
> > to compaction, which would block the task from becoming active until th=
e fault
> > is resolved.
>
> So it's probably the mlock() part missing since that should otherwise app=
ly
> to kcompactd.

We use mlockall() and I verified the pages have the lo flag set.
Which means, that we have exactly the issue this sysctl flag should prevent=
 us from.

>
> > ...but rummaging, seems other stuff can step on it (contiguous alloc?).
>
> Yeah, there was time CMA was just something for mobile phone hardware. As
> usage increases beyond that maybe we'll have to tackle it. Ideally by not
> having mlock'd pages in CMA areas at all. And if contiguous alloc is
> attempted outside of CMA areas, respect the sysctl there too.

Yeah, we already thought CMA might somehow influcence our issue.
We have 256 MiB of CMA, which our hardware probably uses.

Is there a way to tell a process to not allocate pages inside CMA area?

>
>
> > -Mike
>

Alexander

KUKA Deutschland GmbH   Board of Directors: Michael J=FCrgens (Chairman), D=
irk Busch, Johan Naten, Hui Zhang   Registered Office: Augsburg HRB 14914

This e-mail may contain confidential and/or privileged information. If you =
are not the intended recipient (or have received this e-mail in error) plea=
se notify the sender immediately and destroy this e-mail. Any unauthorized =
copying, disclosure or distribution of contents of this e-mail is strictly =
forbidden.

Please consider the environment before printing this e-mail.

