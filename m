Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F5ACC79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227246B00AE; Fri,  4 Sep 2026 11:14:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8946B00AF; Fri,  4 Sep 2026 11:14:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A02A6B00B0; Fri,  4 Sep 2026 11:14:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5DB66B00AE
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:14:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 694A9160148
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:14:58 +0000 (UTC)
X-FDA: 85176427476.09.ED8D587
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010021.outbound.protection.outlook.com [52.101.69.21])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8616B1C0005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:14:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.s=selector1-NXP1-onmicrosoft-com header.b=JYp0z4Fc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of frank.li@oss.nxp.com designates 52.101.69.21 as permitted sender) smtp.mailfrom=frank.li@oss.nxp.com;
	dmarc=pass (policy=none) header.from=nxp.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788534895;
	b=6Ly2aNvsM4AuSalYpIZ08lDkciQPzVkxSJ0KiB1RukBI2ePiB21XKAmRhALHXUTF63h8PA
	AGERHpwK3l8NzoRTr+LKBB/w8HUTEuX+fmcibL/U5Ppz9vnxXlKsUXJBqDV9fmHJ/tPu6P
	fgcN8eGIVY1Fbwh11vUMrk2QrAO6Irk=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=NXP1.onmicrosoft.com header.s=selector1-NXP1-onmicrosoft-com header.b=JYp0z4Fc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of frank.li@oss.nxp.com designates 52.101.69.21 as permitted sender) smtp.mailfrom=frank.li@oss.nxp.com;
	dmarc=pass (policy=none) header.from=nxp.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RQW4+A1fl5pj8e11/MObeV5hdVuZfVkT5wgR48pbh8=;
	b=bupyhy558gN1OLeQxDt9hUZcrgEtUPG9DvhMwgNPjBg7JJ9h6BmDfGl4MrQq//g1bXKFeL
	7srJH7cuU631yJeJDrRzT9JuQysUl9LcvUKY6YOahkoSx6MDvcfFVmZoJQlJi0IA9zXWPx
	PXkMtmmuU/xW1vwfjlpcGkphJTKTNvE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IkKi7M+/1OOHAse8ZLtU1WeOPKGEn/VGkwO4aROicPEzPehKfMyz0/ea6BJeb0KDne6e3Eu/G5rap1/LO3EXcBlkj7C1ZWc/z/87VRixALnX/v4Ov3U3n+y2bZXalzDjM4zwzzP8ufVISpNxufUROXFx7sgu5CplYJTSKtxSPGe7z+UYj7+XmkaYjQm5yYT9srRYpK1lO8vAh9/P3g0M38BdWdeD2iCYHeK1iaubF3eylpPQKKoXa2RwliS1jW6/Ee2nt+52JYnGP68WCf00vsGHk/5mbMrhQ2FlpZf2THB/MbowH14Ar2dpmLvjOq4Qt5c0NSOK2QL9aC6o3HZ7lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3RQW4+A1fl5pj8e11/MObeV5hdVuZfVkT5wgR48pbh8=;
 b=rmfYtDG2PVCtM5s77WOgizhuUUOQBwXOvaCCf+QePKEt92NavHOCQIweIQsmlLxYBRttZwmBWX08+J3rsMCc27PiuQriTbVY+sg28Iny2gLvpE4jvxuuusOhJAXhqgMVRxJNqyvDdNJqCwPay1D400+YV0TQaWmnXFnWHvVL1QoNg14ehM54HPfd5JTtI1BHvZHxlYPndS9+/70D3TtW4ONjBOVCN4DUZxlATFUyBGL42XCAedz3M1QyHQj51oACeS2vypcnrpPFwX+3N1xkkpanXaqCgO0L7ikVNJkBqkyg0W7psyowGoMgsArE1KpQi0c49cX6I1IB3lJw4IOvPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RQW4+A1fl5pj8e11/MObeV5hdVuZfVkT5wgR48pbh8=;
 b=JYp0z4FcN/bYRxlPys/Aiw3R1takbTHWbgmEoZARey7JLU+ymIwKyX1c0QWMQoM+7oJvD9EEBVXdBcdYJcAvS1Xrh7sbDFJi66vgUT9qlZH4N/LMpHOSUgrtiAi4uW1DZwZYFDf2zYTWEgbnw7RMJJcs7Ssd1uNrvtw5Xbc+9+VgbTtLo7r7W5LRER32MidsTmmPB770iPB0hq1uH9NgRsTUhHZWW0ne5e2hCHLd8PL0jdkU9pmY9C4RyYytsAbrTyKyXuUz/P1wpfnb/0mj4BDvuJyqsh45C7ObamvuAeiWTIYy7HQdaOP39jHo1Nl92jKpLwrdRQlpavzJHQ2Axw==
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com (2603:10a6:150:2cf::9)
 by AM9PR04MB7554.eurprd04.prod.outlook.com (2603:10a6:20b:2da::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 15:14:52 +0000
Received: from GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c]) by GV2PR04MB11799.eurprd04.prod.outlook.com
 ([fe80::2146:83a2:5329:b7c%7]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 15:14:52 +0000
Date: Fri, 4 Sep 2026 10:14:44 -0500
From: Frank Li <Frank.li@oss.nxp.com>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
	harry@kernel.org, imx@lists.linux.dev
Subject: Re: [PATCH 10/13] media: imx7-media-csi: Don't use GFP_DMA when
 calling dma_alloc_coherent()
Message-ID: <aprgZFqkAOfkTL-d@SMW015318>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
 <20260903111836.1777265-11-hebaoquan@kylinos.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903111836.1777265-11-hebaoquan@kylinos.cn>
X-ClientProxiedBy: PH8PR21CA0014.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::28) To GV2PR04MB11799.eurprd04.prod.outlook.com
 (2603:10a6:150:2cf::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV2PR04MB11799:EE_|AM9PR04MB7554:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fce04a9-6aca-42f7-7c63-08df0a9744b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|376014|23010399003|1800799024|366016|10067099003|11063799006|4143699003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	uf1AG0ZJRXbgPS6ihGik1zFf4tstthGi7IxDSxsPKAQTUmhsMwPoYwgVeV6u/8t1jW132/O5rpb4wZkVGEkY9b17m0DqFQ9w9/jikIcUkFhLXqfsE79+OxWdv9sep9buIOzT2iTD0Gm2w4hG5chE4lS9FR3g23dSgXfWhSIX8k+p63KW8pdNce7Pm+jk0ie4qZFi/PQzEhBjbxk8Y4EeLQvHq+21fTC+4mhb/TgoqbDNbI98vH24fpBXPMdDPAKc89VDZJn+oq20S+pUtP1ViHd8sJHpwn0VyKmZN2md62WSYxERwr2aByJh2ZmkhiC10caQjzQvCfSPA0bT0vPgm66LkqZMBEy3y231P2t6Mz+BvLtujPVBtnSQMd1PbPSxN9IVQ3rD1TOaBedmNFfBrdfKw0bfLGV2XjIeFBWZDITEP/y7MDBk4mccw1zTxsNDnGuDAHsshorJeQ/GODX0sxrv5WJLh7SdRLJUGXw3MR8hvuwN+cXcRlJNTl4u8bXpuc2e9PadjV4/ISjWahqkmXPrTazJPOmy6swoXVnmysI/I8ikXcbv+zG1a9wrziD9NrAsMMKKfSgklCTCJLGRCl3m8ijaE6ksaKlJ+S0QggLtH0EqxOqXR1fDLG/wBPkqkAUze+Z0mYGYdJ31UU6GBVlhzHS/PVHiEX2tbOJvuzg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR04MB11799.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(23010399003)(1800799024)(366016)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0OIetNp/Y57RSmxoMt/c/IeX/EoDl6Meqm3FDies87LwWF7vLhzCAGLONgz5?=
 =?us-ascii?Q?vXt7MQuFn5ohTBLCWzuTrxD8pCwqiUHBPdzYdQ/bPfolRJiO0vjpDGWF0uWU?=
 =?us-ascii?Q?yP67u1sm6dKaLxmh+E6ftSQJzAFN19ovOxQrp0QwTqytu5coMkRiU08aWUiK?=
 =?us-ascii?Q?Mm7/7Ml82rYUNM9gQmy+BJJivO8y0N1Du7jDl0eUG7lGw24TmYwQDYLcTMxk?=
 =?us-ascii?Q?NINe9sHFSYhZkeHIJ9QIAe7YHCzLcJcv6X0GXSOIKHnSUlp1p3MsBK1xlRtc?=
 =?us-ascii?Q?J5/1LVS+1PmdRJV8r8eL1KCuKzYoeao5RFXFvmDttPwTT7rrjCIw9E1C5Uzn?=
 =?us-ascii?Q?fyTOmntmw0VFzXSqT/zEt0jOIF3ssVTLSLz9rOC3I6Tip5n+HKd76UofLFXx?=
 =?us-ascii?Q?tCtJaKhMhVeQjsG47BjiKoan4hyR3W01rOHZA1VdkmJhSPwQKBHTHYtV/CdE?=
 =?us-ascii?Q?jREL598qUt+Wr9fzJsDw/2yggGfzlUwL+keJQc269Nu2/gf0FduRynu52M7F?=
 =?us-ascii?Q?P9mDl2vQ1mPlrsGpwDZejS2cDW88vfazQ+hdtp2PZfdZJh3Uq0Sxoh5FrC5I?=
 =?us-ascii?Q?Nh4P2rYNXXZnVpyBS2zDhP7a7PBIrLgmLt+Z+51woJuPcOrt7X/BUBJ5SbCO?=
 =?us-ascii?Q?TE2rTL7poZvBx6GDQ/VLbDBkfENWKFDNKXV4EHgsiIaHrgwyV9naLc8R3Aha?=
 =?us-ascii?Q?FuhvXkREtG5N1h+CCIlWha9YBEScY4TOU2B8HooCiZGv3Xu6NF/sKmHMWcY1?=
 =?us-ascii?Q?jVf+ogre3TsoA3uE612fww+junXGb9xREL9s06N9aG8QKMmjonwsPe+hJ9Ea?=
 =?us-ascii?Q?d1/5y/vP0uzhqFzep6OYfyYT8U6Q80/Nrh0A2yERXGru9WsjZNYyLIeNqceT?=
 =?us-ascii?Q?fMdIm25BTtmln/lXdlc6Yubp8J8Bru0ItDQKpvziNWcXWPgnDPf3vToJx4KC?=
 =?us-ascii?Q?yh0hqop9ilcpS9lm3LdBD/ShCKWwOjBzFbBq9SOE3c/Dx9WNhEF/P8HeHyon?=
 =?us-ascii?Q?GGJBD1t0KnbijgeYZggFKOwrGZXBDdpoAjSC1Le2DyOS20Bjay0g/mU/K2jA?=
 =?us-ascii?Q?UyVbJGltojPDn5FptQwjZxCLCSVk+jsPgTdnrysvxFeqbPWytF9+aA/h5KY+?=
 =?us-ascii?Q?kSqLQdNaXw3Jnt3riOnr0pzNzcMv8WwUjxZlBlfUwg27JXHQ0TPWB9D53O2T?=
 =?us-ascii?Q?AoksKuMU5WBT+rP+YKcLN2lY/0zrWgS4dysBh/SBeJUclz7B5FDSImF+5y9t?=
 =?us-ascii?Q?IsJFsO26JYaoDESSWInxE7lbRHfacGQDDuFZqnZV9hWal/wI4tVvHKM5QGQ6?=
 =?us-ascii?Q?zJfCY+Zklfei6GtPRF/eDK+evMiuEaQouSYoOHUweGncEss+Yiyh6VwongiR?=
 =?us-ascii?Q?9CGjdUNNBdRQisU/TAPfyj7A5H4kxyIWcZl/7wNz1tf49njUF7HerArvZ5eu?=
 =?us-ascii?Q?7K/JiLyXNgFLP+k5apS8QExEg/haYQg1SDt4RnN+AL+LxMEAXviv9iIlE1EW?=
 =?us-ascii?Q?tNEzxfAgkr3qzpz2vIKoDj8zCjjMP2cSQ7IamZTNrjr7XVlTA6IjBQuZWzTZ?=
 =?us-ascii?Q?6+lXthGxYlIjCNkUdpaWCdd9If8J+buWZb7rMKQkwHVfmkjZlYIIjXvL7vPZ?=
 =?us-ascii?Q?z8iplnhB5+n4yVvf7nqlCX1KqXm9AhIItKLRz75l04OhVRlNqGOpjsdUSElZ?=
 =?us-ascii?Q?rWo2LtdvWAYQ+hS1wa0k/ruOPp+eGJywLsoPvl2dX1KGr0gbjEM583fAHP77?=
 =?us-ascii?Q?vwfq2G1EpuvXnhWHeukKXPRUGZnyO/xFtOC314RidskCCx2I+7Ed?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fce04a9-6aca-42f7-7c63-08df0a9744b2
X-MS-Exchange-CrossTenant-AuthSource: GV2PR04MB11799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 15:14:52.1872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51qewxH5d6Koqqb/To2Jj3+gIhIIahhSquIye+AO2GnGHVIkr1t8Fk0C0Sp9W+UdFMeQ2aSx1WDBR/EvaO1VVRSx9Dl0tccYr6K5KUORwNJOMaw3vaBEtSz3MvY6IJvq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7554
X-Rspam-User: 
X-Stat-Signature: 1cjywwn7qhc1r6b5ipp96zmbza93knz9
X-Rspamd-Queue-Id: 8616B1C0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788534895-399194
X-HE-Meta: U2FsdGVkX1//B/vAM5hIkUVtv9cF1V1jXW3SVNDLApImc/eQURX3zRFnKAKbAJUNiPWjF0WWCJbkE/HvAN5i95/qWGAzCFEgUzNaMcV004j3mQ4BKbsxQRn3bd9zks3KR29nwnoQuwYDR74yey3dOFlXgX/WNro2/3J8v6V/1+MpJD30dCvlzAua52gTTmgHEqMEErrYRuha6t3nWUVe4tZRAQh8Fj6xcqr4EorgJYaYQ6vg7M56rm5cpoKamOvLydgLg+XM6068Whn3GFzw9GV3tUh8kHc2T03Objm97EqVd6p0VrfFRFmPV4R7zlGz7UAgDKKdeJGKFOE2J2nAQWgGuSVApV2anQ2ijmZ1d4cfijLrXMBlYjURIgbnGz7jl5yJ1/Thcy1feLelGYGGulbU8/Cf8ChmxpuGXLeF56jJC0xBP2L/K9HvjEKzOsPIJByEM1e/oOK9LGyTWiyLDQ6Cn1GF/tMGD/hFfLqljGFXra4SW8+kfEV7kgxNNgKBd0ZeVLXE0hp4X68TaDRVdPYK1vue04cWMLJGB6gwc3ja+sYVHYt2qX6tuzaRUTGx45jhBpZc6Vh4HLK4WiYj5UfTU5iXa5dLcF5FPgIqpwVAdrL7bTVZLMPphrX5MQobpkOLuv5RMARr8UoOK1wpiXsxjoBl8YZEHv0EksJIZX60AuVZ+Owf8gFwrRWK9ljkAmO2NLP3IWjgPbIvS2li8eNukNKddwKyj1toXRq7Q5D4H3AyDX46OHoIpsNgNLefg5QMyMhicreSgXgE9fABXyCk3OTatiPzD8bRBxBSNR3xwH6g4sVx71yKak678z5mJwLFGbnolmFf9VPYDYaAQ3YNokofkYSDdhkFaOEFs86eA0a5/s3CV5csWU9BcP6GTxNQbCj+toamNHPo+yBg4bDSmLS5q+6Y8xEuMq3fkx0j3mVfBGBBZey727UWXmxJjr+u2ySPZVTlVKtIEwm
 N2MCDUcF
 f16qc3ExVjjWjTOoHwWISGRxKH/zbcrrIY44ZU9QfGrZ1cGOT7Nbn0Me+5tvTYlmHIimW4+Zfs8F7gAVgZl3zFklVMcwvuGglK02LFOJ4cNb0Au+PtrejBf2MlS3R0/y6y8Pir8PbrIyS69+L56K43nISZtMT+I7/YiR6vW7cTFw1XNsxDHa3ttV7r4Ag/LV2ULjp0pwfCAuq0hFZ3xyztYzUnZXsrrR7SkXFWw08pag71toRxtEn10aAoBXBGmCUYImPVC4VvfhMBENDyhuhfBTSPxv0iN7TkoTj9ICqBC35DrNBlnJO0Fx2AKyG8qI0DHXDp7vLCA7WQsAKy8vKsiFweXsUN8gLt5n2TrtRWRjnrej5OONHuVFNG1Iu0Blw8j2TCf6nirFhFJIGcYNgy+SzjkedwGzOH1PxkILUWmMVy0MlVYpV+MdV4EFknbePaqZhHoXP66C3PO7ew5jiOh8Y9sTewO346rDGKvu5IdCU12YpDJ7joqEJot6Cp4zRHfbBfVyPXyc4jCybuEfDEEHPbbeETOVvaJ6uAy6bAwPQ5EDFpmImyr6I+pC7GODn2PrB+MKBZzVHq213T3AcpSu52TqU2xURDqWZP57vHyGVIY69M9JDfO0lvvB1+lviMHEdqCAnf5qeiPVXXqibMBjXCnyhI3Lx9S9FRxWy+c5PacYqYfAPY/hmiZl6xjUls04g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 07:18:33PM +0800, Baoquan He wrote:
> [You don't often get email from hebaoquan@kylinos.cn. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>
> dma_alloc_coherent() allocates the DMA buffer with the device's
> addressing limitation in mind; the DMA core picks the zone from the
> device's coherent DMA mask and ignores GFP_DMA passed by the caller.
> Remove the redundant GFP_DMA flag.
>
> Cc: imx@lists.linux.dev
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---

Reviewed-by: Frank Li <Frank.Li@nxp.com>

>  drivers/media/platform/nxp/imx7-media-csi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/nxp/imx7-media-csi.c b/drivers/media/platform/nxp/imx7-media-csi.c
> index 7ddc7ba06e3d..22c0cbdc92bf 100644
> --- a/drivers/media/platform/nxp/imx7-media-csi.c
> +++ b/drivers/media/platform/nxp/imx7-media-csi.c
> @@ -466,7 +466,7 @@ static int imx7_csi_alloc_dma_buf(struct imx7_csi *csi,
>
>         buf->len = PAGE_ALIGN(size);
>         buf->virt = dma_alloc_coherent(csi->dev, buf->len, &buf->dma_addr,
> -                                      GFP_DMA | GFP_KERNEL);
> +                                      GFP_KERNEL);
>         if (!buf->virt)
>                 return -ENOMEM;
>
> --
> 2.54.0
>
>

