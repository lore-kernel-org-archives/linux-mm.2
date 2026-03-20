Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B841091931
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 00:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F42136B0095; Thu, 19 Mar 2026 20:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3686B009F; Thu, 19 Mar 2026 20:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA7E6B00A0; Thu, 19 Mar 2026 20:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBCE46B0095
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 20:07:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 768191DF7E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:07:05 +0000 (UTC)
X-FDA: 84564501210.16.DF25E55
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id D71F54000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:07:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qb7Ou8S2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GECi9BL2;
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773965222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wlbb+gVuHfxx15SJW2cFuww0YJu5S806O8UngPbNb04=;
	b=gA+zB/ip+cnyiNQRwCzuicr8uzhpRQvYAXrun4Evk61IXbvfSPiOFlA4+kp7jYred5NGA2
	NAcq+Xwz/wRyiY+FgI4Rxs2wajdqUOBa14gc049D+VD6PWLwR7Trw12KKjzP+e0zwKED9j
	90/DwGOmbMMoM7KzF+rASnTEwH0X2o4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qb7Ou8S2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GECi9BL2;
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773965222; a=rsa-sha256;
	cv=pass;
	b=KLwECDkA4hyO3ht2kI7jCr7i1FdLgRR+cW/SKgjS8kNuGj5COAKYc1UzmwklLTGiqUps1w
	fld0tYRiNEAlD+qbemstuKpFkLGImpGGjTRG1kzDhb+jvTewFCPwTa7wAuDBrTcozXQ6fF
	1x1IBPegpm4vRR6pd8Oyfit2jhVjLvI=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62JGkffc1712055;
	Fri, 20 Mar 2026 00:06:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wlbb+gVuHfxx15SJW2
	cFuww0YJu5S806O8UngPbNb04=; b=Qb7Ou8S2relpvyXpJ792TbPs/gTjdNysbb
	ZwVg95nRsDf9K2CsgHF9YnQWuch6lNCZb+rwGjxbsv7A1t8dI2KQ4EE5XoP5N1cd
	l3wjXP5MUYW7iblAPP3zovAiOnSM5Cd34urTJzjY7AuUuFyKa4zVBujM4i+oTfLS
	cTiqtycchdXk8lGlc97BogFja4TgIKEbsbG0NsDATaavnIXZw1ZbH7i4GfPAoVPV
	tLUQUhGRfPFuGk4+Nworpa7kbjaM83OcQf3KszK3LlyDTOW77E5r2/UiYm0Ndn7g
	nrBCuJtBeBeY0KYYF4i4VjzMEZ5Q4bFkgmJ9e/Pl0ptWZDefcKww==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyj68tjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 00:06:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62JMENqa002815;
	Fri, 20 Mar 2026 00:06:47 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011001.outbound.protection.outlook.com [52.101.62.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4quhsq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 00:06:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iyyCjRr5SrsNcFeFdG2igvYGoa7a5OOYSI+DQkz8LkCO7/LWzUILHuyOk0mDISY2XYkhiMHW0yxgGRupQOhaQ+6tVMCgrS2LlSR6EWiLNbvgv4kHxlBI9EAbkMtMIT0euZ4PTq1LrmoX16i5rAf1XIQTXLKqChtspQ37L/KGHlv88qlZU0r2zexnj2RnPJdkpj7Wa6yTgyXOgQU/LaBiX2HX6Fe6+OERCfKvTv43tyYjRpYCFgqmeFwhWD3pqyUSvTxTbUF3npMabyRvTZnvOWupcvFJ2Sxr8q6G1zHe5LstLavtcsFWQ7DLxVxaKs7S0Nbek62tzjJ5tx5eqRBAGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlbb+gVuHfxx15SJW2cFuww0YJu5S806O8UngPbNb04=;
 b=XwDRbYMlw2CqxrxZlgpMtJkAy5bzbOqcCwWZhcduI394eyx/FP/iJGkqP9Q08qG9TnlJ0XTNngyXZPoOXLlJPgpQx5aO1N/EXOnp3Qtf6p2sEJIJPZF+lZnOpY04WrdX4C8HEL9nRqrVYBqCnx9VSAvdPGoleK6CgFgzBPfoKpR5MHObqsrvUH63zB1YDTnfxhvSFQf1/kpVEnZTX/6qB6CUHHSsee2bI95nq62ySIcqi4952RkVZzoGzBuCWny5zXwcJdIUmj9evY336WKBhVpQ3Ka4r8IwHH0XtLs7mRHMLL4vzEutXCx+9FO20d0Z7sD6abAs8zC04l1sjk+VnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlbb+gVuHfxx15SJW2cFuww0YJu5S806O8UngPbNb04=;
 b=GECi9BL2DOHDb0fZUagkvKbHE3PkYL4b8ZP/YKfl9iJL/0F8KZwUt92iLrOKG2Y5ysgyNDkHNI/7uO4gHdf0A0q68PL3Lu+4wvFWFWbyVvyYQmMhlJK/HaL+RdzlZsEsxiVPkHlygEhqj9e+a3t65ZT9v6pEzgWzpngcGISm0pw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB5796.namprd10.prod.outlook.com (2603:10b6:510:da::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.20; Fri, 20 Mar
 2026 00:06:43 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9723.019; Fri, 20 Mar 2026
 00:06:43 +0000
Date: Fri, 20 Mar 2026 09:06:32 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, chao@kernel.org,
        jaegeuk@kernel.org, jannh@google.com, linkinjeon@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, pfalcato@suse.de, sj1557.seo@samsung.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Message-ID: <abyPiI_4bCRGQLBV@hyeyoo>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
X-ClientProxiedBy: SEWP216CA0065.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ba::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB5796:EE_
X-MS-Office365-Filtering-Correlation-Id: 4185f1b3-d54f-46da-71ab-08de86149114
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	G3Izs7bF15nzQnvmBxUPW2iWS7ikRM0Y4c8pWpgxw1wwLBN058IbswDiXBMciajF8I2Vh6cMHO8xU6WIuGFG6kZPMsNGUyQe9+1XYDc59DWaJ8sIXBxQ+u7BMP3aavbrCyubrTNT3S8PybYFaACFxX1kmJLuhSVYn1jBmkw/M963m2S5/vqcH3/u97D9PJxHmAhcc3+fTurUP0J3tbzFKWPAVwT675c/nNVhDzvRj6uaDOZD0kaOcwB/N3gHd5jVVeJkQqcF88N/NqUjteNKwM3TtCiq1Y3qkmCcdk2nq4n9Tvh6D898MNEpETYTEvf1i/J50YPM4VNrRZKahw4OeklwPVF0Lscl7eQPrnSQigFd+JVDkzuSduzucTqeH0l7sw+JFVnkFeyJGpbY7/PAql55sLQ1j5E4G2JsjDpKeYFZ1hL6vMCaEWn9GAN6ftaNlwdt3W+7UXcmzj01oBXGFLbZZLeW0fQxVNGD3/cA0q6Rim6sFc1ru7yezSDllHPECzGOur6vtwB/RG15r9yFGIMcVZkdr9FHkyvB/jwFB3xA8c4cDr/CxYWw7xpjtdiyNKd/6+6F6qVzVZiuwh8EfqowUB09MGxnWgriZx0j7xlx0vZsOgrhgMuEFnzUdi392lT+ONDrF3pfJnHWOD0Nsswl00ph3r9vhpTCRAYidFlnEN++GmRreV/5eBeFgefelYM8FyUw0zkdeQtn7b+Sia9h3Xr08l1TLhyw3cJj9vI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W/e9MAMSPpT7zehfxCdnWBtz8Tvxd9rcL4CE/9wqgTnQcsPH5UgxJX2OuryU?=
 =?us-ascii?Q?ksS/xx5ge9TxJBbEscqTOnI68H2K0mB4Q5I+UzVrVWYYVELnrT9kHqPyZgKI?=
 =?us-ascii?Q?TnNfUddUKJD5I99rY1Uo3XdvXP3zqZKzz6zBduDfhRfPvk81pfBIMQXG7f45?=
 =?us-ascii?Q?HqxqJbjKkqPtPKB+CJynnhmEGQWG8V2ciMCR4Yb9L/FdsE4ZzFyjZ4JMRJ+g?=
 =?us-ascii?Q?sM79+bczDpLqKv1iz8hcdQitCv48Z0lGR570NfsfRjgPlpzd8ciDnemscqAf?=
 =?us-ascii?Q?QVIerSW5OQCtaYgTc8x8EvyX0aamVisn6gFooDSXRX08/U9oh7zyFwTFWeox?=
 =?us-ascii?Q?pn5CYKkzh/Sc4+JUj8Ayfz+3ia62AUqnP133ly823kvadvK81wke0KVZrr3U?=
 =?us-ascii?Q?+kQfAf9Byk8CoN489PekVJzOqncl+o5uIDFwXPncGExEDOPEJ+Ql0zqZlrS2?=
 =?us-ascii?Q?QKfOFFNXDAAfhV9RHkYz2q664C9Ytu/CjdsIuqEFFC2YnXi9kG27K7e0gHk0?=
 =?us-ascii?Q?vIg2g05ndQIrLNebh5RCtg3/q4o4pUgErbYhrxm/FefRYm5jHYMvsAEIBXyS?=
 =?us-ascii?Q?rvnGOoHBd5bJyRN7HX3dTobnss1CY5nvAB7oswzBXnx9XSERvYle0htVXdBU?=
 =?us-ascii?Q?y+BgFe3FOXAvw+5/IClzfX+u7DWeEi3+9Ln7kW+jEw5v1VEDPjx5DYl4e8sO?=
 =?us-ascii?Q?MSH4jjybLfDgF2lbXvwLgmvBtJsaZCkw9mNvMYZaCpS/lh4ZXu6R77/6HpvS?=
 =?us-ascii?Q?XHOKNDWigzLAJKYo/Zf53A+neR0ZaLcwvvmaNEkkAb9WBeIywSSKEzWD4Feu?=
 =?us-ascii?Q?q6rlIKV1/MJ1WCAx5JLjz3LapPfwKAWTfutAZr6+qhBu2DQBT8osJuG1bGKZ?=
 =?us-ascii?Q?DgzBjZQ/mJqkqeb0TZKygIc5GxY/1kKi1Y6wsc5YT0z0jxKg3v7GYkExM3ki?=
 =?us-ascii?Q?ZjORCAai+Au40K06qTBp6edPGY3dMFFodY5KenlW1Q8aC/tlLvqu2W8ApOvc?=
 =?us-ascii?Q?MP6IU9h01A3HEinNPb2PIjcrj2oMHpa8DCnC7v5eQA2vnFWZcbjyPWeiM6Vr?=
 =?us-ascii?Q?8d6XvgJ2AB6iIndVoxTy7iYiaayNkQpEPIPZS8IVGImfqvFLuYaRotkjsC3w?=
 =?us-ascii?Q?Z3GeUa+HRKZHalGPNTnBTZFBi1nEoUs3hLfaK2bLhJ0+M98hBdf36cv4aykw?=
 =?us-ascii?Q?m3JNElPPi6OzRoMPrPg+SlIhegG60PL5zoNA+woE/8ZJDm68FXHYxIoScedt?=
 =?us-ascii?Q?P00DDUIVQRtyEqXX1Vvlos0O0842rFjK9C41WxUYJUVheWCv0wgTyxzGmft2?=
 =?us-ascii?Q?GGwxr0XmJZNR1KOfjARuFjMCxBLnTSJdUJf1j51ui2KDr3tGXMf3nSMxYyxz?=
 =?us-ascii?Q?jdkKBBwQgNF17d07T/68q1AQSt2QXoDd0vDDypxZP78WHog2Ap7NJXn91iVc?=
 =?us-ascii?Q?qat6L0wBDivqS0+s2+5DnyJXwjBGSMG8NFBks/MZ4/O/n0x/KzuipKR/CBAC?=
 =?us-ascii?Q?tTtgOoG55EU+I8Ry2HRIommr34fkciSdl6ac2Iu1R3TAeuDW8E17O/vaLNeF?=
 =?us-ascii?Q?NYTdcEwIlK/Z5PhAkP0YwLER+GV2CU+aHez4a6ROZfbyV4ef9jmUZ77+F0OH?=
 =?us-ascii?Q?3CxYdIjus5IIQYRjWGYaUvB2gX2gw/9nuoeJj+2yLLV5gHo01kv2FjsFiWB2?=
 =?us-ascii?Q?9jT/vEcUZAdHPpnYt5blla7PW+AejHbSHEIPMiMaj8bk5wwizQsdLvG4jfUG?=
 =?us-ascii?Q?9y+vg1wtlg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	NWogYNiP+2tw5pn4fO2LGkHF3MHvorNy98Zo8lvSSUzlzxPSXr15yLp1kS2TfTIZ4Gf8gTv4KU0GPmxnViKNnM/MBtifbLS+vGwSU3SCIHzEacLbMrT3ZbBdsW9CxmMiX6dAkgoNtCjoVLCFgCITOJ2qXECniWSMe7zYYd8SgRUDCBZUitYE2u497DVPaKXjpGreogKN8v0QF8N/BncX3DiuII0lYVuOcU0UaEeyWgh6EjHn1yfdgmqQKMjTECjRZGRP49bMRfTlxYjbQ67zVghyelrFi+ysArYZzPIQn7pXzUEn75iDbQE84K0XCtqkzSmaQAc4iFwB2MyqqP/GNg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EhB+Fv4fw9OwgW/Tx3J2qnZuA3LCB/dyLtzHLZsk4SsTDT6/Hsn80yXegEd8v5stg4I3Xtzhs2Bt0J+Ye+BHALOHXlob1xzLpvIeO803lble8gQzkyPEQfLEx4V468DBJm6cNZ8Pz/+JwKObe2vhZoYx1lI4wuo36XUGtj2Oon4rZ450Qas5kysEV/FKbJfwS4tG/KRPNTggKylDxX9aIUlPGu+S4Ma34GsFKjdCGryTJioL6cePG1O5c7Hkd+a76ykSxfVVnqN++CefgMcsxFGnzbVZBeyliOwmaWoEiMjXpaMO+OOPNcmYpTV2QMihiy/N3FXzyMcB1P1lO0P/9X+/04FO4jDkB8lIAC1YGk5Ek8dZIdC0K5JqIe54E8JdgulWaDJVWW55mgXc/yKGG/fxsc3+/BJUxXgLcQ3eel13T+K70GNTfxdDlrChi0Z3SvTrsQYUnhLVJHJ/fanmdzXTc6nBeaFkkM08daRG8u8LuXo+Dn+4avAmYAAqc6OOHcWdd5PYjdmVbSN5avnMh+UbsWPI/wDOdGvac4xdvE8XXfO0WfISGNsfNm2JWsy+2QiGZIw5rc+UlNkP/1AfoXR3NS1TDHg4MHlyidjU7tM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4185f1b3-d54f-46da-71ab-08de86149114
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 00:06:43.0722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/eOiu/iBA7br2pu12B0YJNIE8eBf/s8aoZUuNQznm4bVnmmzo/iXFO0h5ifYxEb0bQxdDWXv+FcgHFUbypWSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5796
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=991 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603190194
X-Authority-Analysis: v=2.4 cv=LKFrgZW9 c=1 sm=1 tr=0 ts=69bc8f98 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=ZIbLfP8lhgRlLMFKtsMA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12272
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE5MDE5NCBTYWx0ZWRfX9EHjrK1Dr5AG
 nyt+8Hn9mmhVNNkDWqJ/Z4kVx43WOpPWPiDZjc4KkzYFT23PfylywhdLzhrUIs9+gVwzutpwoGL
 eQuE/YG0d4LCvdWIAtdxmJlgi7JQkR84L/GNKFUWk6nvvAzbkwY7wGd/4DFoTtIJyskR0s/nc0C
 OfFlRUI5v4STFLFxflJh71rOO0psYevMgr95Xp+R0HOCazK7B3XvRZtWH5mRnPJX5y2uqkc4jM2
 UONTYoV/SFgY9fJq5Pbqj5EePPQDpL5O1S7ERbmck7BgGHhV3SSXlx06BXrMyiSark6gq+eZ41x
 hM2qsWOTOOVjQmE1A+d2YtV+nz2oBZcCYpCduudpRAQHpP7ADWLtvrRzWSSWXlFobp+tcg8LBB7
 DaWmkWKBrbLWElhqmrHgD2CYuK2ReGV+F9Mk/abOqwZAPnMqMgmhlpGc8k87FuA69X/rhYQlcdg
 MOEGBmgxqjTG8eQf6xAq79apcywi4+u3xEhP0pGQ=
X-Proofpoint-GUID: mjN-1lYizngOezivitW0GKXXDpaE98IZ
X-Proofpoint-ORIG-GUID: mjN-1lYizngOezivitW0GKXXDpaE98IZ
X-Rspamd-Queue-Id: D71F54000A
X-Stat-Signature: xz4ifg6qa6xuxxk14qx3umwp7k9yuj3d
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773965221-341009
X-HE-Meta: U2FsdGVkX1/PBxn6fCp/XDSzBIFb+B+CsxurVBWioVtfG4HiZcqPvmr6Xt8qw+Pbqb7ZRLwVH69w3b59ttqXwaClqU78XfcRA4J0MVSxp5SlE+dasMm/OAmBiZyGhBNOnXoqBWRIfR6NuwUW9PWuC6a0aZpbNYHNPgm8XMzjjOcdHGfaz7KUJE3JjJOvNE3XwFBoleIm3thKlgXmSodwWXgwZ4JCWSmPPJ309MAgYyPzrKJStS4L9bNQO/3IwfDOJEW4qfVRH1j90+ZZ8/jlxnRbftccxAiSPFEdWYsnnNhz9joH0GCrE/M/P01DXbRjuXgmiKOGoFQt76ilceB/+0K0PZyuyGnWIcHU7Fxa34xQpMfyIl0lJRx3zY9kmKBjWJnu+nzG7ceWydd3yQhMYPWZQb59XNFydljveS0XMWQrYd6Qzdq0n9jTHFM1xJRrrBclCTOseYSURgxoqxTxyGp3/4+NMHy+jB6qM1Nd5g6sWmlvWULcdWtuYqMhPF/BarN8bXEwtm1MIDZ1JJaLa6RrGjxsA0NPlZ/u/IESqQaXjQKY5NVadfiYjY5J5w3vDA1u69sHlUJTagR2aHnLS6ObF6VSkicd5kPeZVak4FrwXGnuwMIK58F6uw5QXwA+98GkDfOg4yowUmoP9apBB436ndtkhF63SXoO0y3n49xOydgQcf3F322Ezv5Ki2dvK0Kjm/eyGyqvwBLmFUTcmf7FsLkkT6XVLip0woZMWyjCNgEaRBLh/3LNnm5TycVRMGtbanyP0MbS2kW6rHszZMxC3/d5NQWgF1x9CkqCEPyd/NHozD/Hy1zS+m7xIrbkCv/e+way94IYfng3nuvLHSXDrZwHVFBgrB1+fhX+uaTv3bbyDJHQhBKFfNjlK+ktiE9N2GoVrmYZorSOKqfVHRH9dlXR+og9U0KSqSvMfYjRrK7a8vp60Th9HtPY1nL8P395ge6TvwLkeuiLGvv
 zB+tFqmo
 0OfzTe/UqNcwC7HhF2VTdb4v/sDpK6COnZZ8QJeajnik6zO82llmSDB9f7OvstZlcRr0cuBBdrk0y+lInjAv2h1OiHlBFwZLBSCEE2yY+zj8vLL+4Sz4RnOy3uKMMaesJxtpTgoknpJr5LbLUxhg1QEp6K2Y7xuo+AMPFl/xTE6ydSxUnsEG35LP+6y7V7qVAqG9aC+DJpzBDAfWX/IeLlaiIBBHjJjwDn9KBvpyUHX497Mh/lOxXUeEDkcHrDNVl8dJs5gkHr5/vxc5dr/2ruhT+1TxDmW4uj657bJkZA1UNn76SvA3GwcEf2JpMatv9DnMqwLWa1Y+I9OwVJiSF96CQmwN1YxBUu0LoGe3piqusGn3y5g+BS13c9Zf1+J/A/wuJC+VWI0nqymGQgZ4lmwZg+g3KDkRvbqcLZ8zgvO3lbpOZYzrfF+MG2xGo2DZloCfoTZFNpd7UUc2EENGd5aawpCRTibHIoEMEypMICxODvV+frdJgbZyG1blFuLZOS/SogVvHnBShgbHFarmfFKvT1/sHmBuAFKc3qV6tkLRubX++7Mak8WWxFuVQ16wg/F8K41lPAz/OZEauZUk+jFvPo/ltzeZ0+UuUhL1TxlkvfKAEKAX3BHZvVYchjOLWQ30nySxek5XejPAh/3Rm3fnICExhTUdXfWQ1dW6tV9AYtH3AfCchSVupYlypQhyUgCZlZzcT5np5JylBkK3tSR5COGlp9dYyh4bQKWBP9mV3L5CNWVQxlL+aYHaTg+Qi8tveY+f/hqX3MzHxJLBSFnopIMyNwIxluOFyI75hFerOXzEsmrl9orlUzdR4r7oSQMwoR+kh5AGY97jol+chbwdag8jSJBEf7DWa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

#syz test

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index d79acf5c5100..b401954f72a4 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -107,7 +107,7 @@
  * Kmemleak configuration and common defines.
  */
 #define MAX_TRACE		16	/* stack trace length */
-#define MSECS_MIN_AGE		5000	/* minimum object age for reporting */
+#define MSECS_MIN_AGE		30000	/* minimum object age for reporting */
 #define SECS_FIRST_SCAN		60	/* delay before the first scan */
 #define SECS_SCAN_WAIT		600	/* subsequent auto scanning delay */
 #define MAX_SCAN_SIZE		4096	/* maximum size of a scanned block */


