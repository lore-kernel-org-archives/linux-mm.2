Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42D0CCFC283
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 15:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF006B0008; Fri, 21 Nov 2025 10:03:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6266B000D; Fri, 21 Nov 2025 10:03:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67E566B000E; Fri, 21 Nov 2025 10:03:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 52DCE6B0008
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:03:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D42EC0604
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:03:38 +0000 (UTC)
X-FDA: 84134933316.12.C6678FD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id A483114000B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:03:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KCnPsAHy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Yl7HnkcC;
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763737414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/skfYXH3vFBVgm3vp+6CDcYPtaVVKtZDPELvJSU5hI=;
	b=AmQ/4d/cA6XveRyNnuRsWguQFeDPPdGNrSb+Jk5xOHgV0oWQLxA5qMN6lNXc3n3Ah97RD1
	PpWbnzzxWQDpZvZMJNWbrzYMYPRF9lPXvbgdLT74cG4T7lUY2BAatvu43UnsqoePqK7eWq
	rag5MRTqXtyoCuEkFpe4TdE6KDIDdA8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KCnPsAHy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Yl7HnkcC;
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763737414; a=rsa-sha256;
	cv=pass;
	b=0b8dnsoEc9ys1qwfogYXFMoxP3E117nEqoqYdpaxhGLqN49fz/TCa8AbqnCeWlqCavP/xE
	TIP7zEqV61fA3Q3ASwDyPpRUs3MtycAz9gVbBeGXiJZt42qjVsNZEqXn5+z86slhuFe1Cx
	tSqFi8xI9uYzN5dJZh1fsJKm8iAOGlA=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALEhENi015309;
	Fri, 21 Nov 2025 15:03:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=k/skfYXH3vFBVgm3vp
	+6CDcYPtaVVKtZDPELvJSU5hI=; b=KCnPsAHy3IuhYdAVKznmG9wpgRRWw2lTK8
	hMVQTvbU8+enG+G+cCVwMJURNLt8G6u0KKPVujdqZq122BpGJwtq5ZcuDU4HqDZ0
	pjO5JvGJNWQxXoIouexcO8UnWDblFQcvbGj0VTLxAggxFB3lTTL5lrA2OSKDJjMN
	S/XJEN8kfJik0TVpU5H7kE8GnE3bUshUs2uk/QjvhZBuVSgTTdDOck75xqI96pf0
	IIy38Gmwx0pWl4ndj7QdcWdn5K279EqBtEqL9H0THtGFIeQXaTpG6j4yBZbFLcsd
	qgyUA+8LtpEQegklsA0OOby8a8LaiL5oTeY0/fpmUrrK52OQHntw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbuuc19-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 15:03:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALEOHNS009587;
	Fri, 21 Nov 2025 15:03:27 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012023.outbound.protection.outlook.com [40.107.209.23])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyht22q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 15:03:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QlgQAR/B4MAi1Sqt71OjoMEbmdI8Z6sg4/D9SqEZQJpFKA0oTG7yxeM3Z0IeWsZmioCZDOkIluU4DutmOcOIu5xP7Y2zJDH49hQ+4zdytQHOUtHVWe39znEclXtWpqKV846MhvqguVzPzY/7pGsKiR+f+IyCivFEktW+UHH2kDMrrybax8kq0rZeS5Bb5HzUM158gnyTr5CKp6xuz56pEHNN1u6fcgmcu21Br/llqpTsKIUfl7niWVkrZSbjWgcr628MsIkHZxtoTIIFc4ZgpHNAH6GdMWpQbbKM1v2kMyKIy40PtynDxkfGXdZB/qyMYWLZAtFHdN5PGcQOok9Dcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/skfYXH3vFBVgm3vp+6CDcYPtaVVKtZDPELvJSU5hI=;
 b=UGk1EUth2cExjdYz5m08ON6mWzH6r/slpQCSpPrADdrjIaDZImbeY3/vzTKFSiD85EJqftAGn8vlP4uCXJgfhNXGLPCMO4GfFmoI5QMnaStPKynf3rjP6rex9Tnfk+mmF4d+P2YdwVcOmZEXG48wbk8Ue8tjDyxR/F84JkB0PknLT6Qp+tMSutrd3F6029o1n3a4+0iWEMSUXPknHO0jsIhzfdqniOgMIlez+yu4BXY8CBJ7Qt/5jwKpuidQK++W+tSgDI8XbE0OhoOoUbe2gi9xpuVItKXAhwmis/IhjGTD4NBSOzDpf6/rTkxdGcM8qtdQbk4Bsony0qfj5qZmeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/skfYXH3vFBVgm3vp+6CDcYPtaVVKtZDPELvJSU5hI=;
 b=Yl7HnkcC+KFJVihdR1a4eLdWfyASv3/Kxc6/Zg9MRMS1ZK+15mZgiJKqTq9cKmna0pw1AFJHRqTEwjDQiY5bCrLUpO2rnvtnYtrYfuz54VhGmR8ZE5QH6S2MgGEr1S2Updva4rr2Od4foidiCnV5NzjwPd1sxhBo3YX+G6r49Dk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM4PR10MB6839.namprd10.prod.outlook.com (2603:10b6:8:105::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 15:03:23 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9343.009; Fri, 21 Nov 2025
 15:03:22 +0000
Date: Fri, 21 Nov 2025 10:03:18 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Kasireddy, Vivek" <vivek.kasireddy@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
Message-ID: <cii5ukeq5uzktg6v6a5bnesjzenwkmnokdwvne333enekhtj4v@bs3jcbxafwt5>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Kasireddy, Vivek" <vivek.kasireddy@intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
 <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
 <IA0PR11MB71851184AA5977BBAFBD55C7F8D5A@IA0PR11MB7185.namprd11.prod.outlook.com>
 <070dcd0f-ef77-4924-baf1-6c380bca192d@lucifer.local>
 <fc85d934-bd1b-4fbf-b4ab-37ba061e72b0@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc85d934-bd1b-4fbf-b4ab-37ba061e72b0@kernel.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: MW4PR03CA0133.namprd03.prod.outlook.com
 (2603:10b6:303:8c::18) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM4PR10MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: 92eecc74-f048-4c93-2a9b-08de290f1cf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HgcTGQlza3MjIwUANrDdScbUI7pjbXMX28ehI6pWLDInI85R4wpQOOLgVlW1?=
 =?us-ascii?Q?HitIKTVizK6qbPJcsQ7Nmh1Z6IFqzk1P8PWo4kB+65L0RqW0uGjfd5YTg8II?=
 =?us-ascii?Q?GGSIwXbuCn6n4Hajg0f5IgAFmMYl8slre73l9o7BuFPGuT1PIxh5TWux5KTN?=
 =?us-ascii?Q?DowxFnAODO6u800kY9eV1458S8PcpIvOBEs/yHm/+pFhLigTovYyadyDQbPO?=
 =?us-ascii?Q?qhqmFTF2mnB6Gr/gwpR0ximrZ8s7A8Q//moau0CSCyA0OxGBTL/LptCwuV72?=
 =?us-ascii?Q?agRogA8RmyitteoYT46kHPtbwT2WmC6s5/J4D+qxqVDlbAcNmg2MUzdLPaiX?=
 =?us-ascii?Q?GuHCV/4GQTGABlbClc1VItqckXoRjuGLtQyh7WzxBPezgyznGwFTwLTq3IUP?=
 =?us-ascii?Q?Krv+cGLxtXTUGqSHn9jkZF108GPGshw2vnNLc7ZRrbP78GYr105OmLYkykf/?=
 =?us-ascii?Q?5GYY++kyN9Su/wbjYBWxW1fm17Ga2sq2pVVlvr/6K7UgNqsMeY4RW67th39D?=
 =?us-ascii?Q?+sYMji5VALO5F220r8pRIc6IH/eoYIiUr1hIL4gBEHpdWst3zjk2SinrzqUL?=
 =?us-ascii?Q?J9TLOxRFMQtkE4AfKosTWDSUOcHBW7QkimHMBklCaYhuWjb56gthP81XcbBt?=
 =?us-ascii?Q?3P4TMPRSwQPG4NYbbkvN/JoqOTSPCyay4bpTLEJc/rpPgtg3vcGRRm5IvPkc?=
 =?us-ascii?Q?Pj1vQIUpxzx70Onm8F3Y9gUli5sZ+JqXQ3w2ax12a6wGTaJTW7lbB8TY3COM?=
 =?us-ascii?Q?Sg5nzHqjdBqtQIyJrD8s8EIJZihRyD1c6MyWxCcDziIUQSPE3yKPbRp3tYmF?=
 =?us-ascii?Q?upio7EKdpmnic+AZIAkVpQie6O6ulmgIAZUbeKDdTUJGsKSB4iwvU9GXELrO?=
 =?us-ascii?Q?za5RYmRMV8eUwi7GLQ3AC+1VP6jbcxnE5thtTkykXWyAIDevI03a2gYWPinb?=
 =?us-ascii?Q?umkEFY+XItDiIkazbziU/zF2NFUYDKqODugsF00OPexDVddqo/uQTEd/b5nr?=
 =?us-ascii?Q?qo2aHbeeuZFRWqdusA83l6n+i5HYoBPk4nGE5J3mL4T5jg+F9mvaZcHxh1Ms?=
 =?us-ascii?Q?U6OPnz7w2HrHmup1iUmbakNqIZ3gbevazdHa2HUcDIX68CNYxzqevIpJaCNI?=
 =?us-ascii?Q?4Z8WJmpmEF1IscQrf4cf4z6iBx0X7I8nbPbJcTWh8wbTYfd527lTXmKxlW7X?=
 =?us-ascii?Q?UmWjazBfSBRY1NuY2qqDRPgdDMAs9cMOcWsjwy6c+OTefyhgLH4MfoBG/HMG?=
 =?us-ascii?Q?Ut0tYX6kLGbTHY9yO9SwumVnhgJPV2dSvlUomWrNgXw0YJWROjNyMvNRcHS6?=
 =?us-ascii?Q?lrIM145wouQ13OpjPAoftRvgD1R6mpudKVA9mujitZ3PDmPvtN1CYQo0OoEs?=
 =?us-ascii?Q?XJalv9fd9F4w1sOerlI0cim78GSPV9aMHRr+2hvddzqaR3/uOn0SLqMY+2PD?=
 =?us-ascii?Q?ZNFI9jTO+D4kZXl26/rrtrrsffFxfQ9w?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rW6qECervNY8pGKfsUwBv6TaFv7Pib4CSc113HD9jDs7MeNM8Xqp95SrQZHF?=
 =?us-ascii?Q?JfE3UsSjxUAUrkXfcm5iHuPL18G6dc69q+a8RV/hm7WajF6jas9IOl3H72go?=
 =?us-ascii?Q?xGAHqcrCLMqh5//W94Dk6grc4kfPWPem4LRhVcN2C/M9eSd8XeUJu03McnF+?=
 =?us-ascii?Q?B9lpTbq2OKlciS+Cmxo5Ew/EDx7bBT5lwtJ/HkXGQD0cL/pdCxAA+OW/cWs6?=
 =?us-ascii?Q?28IdiMT+Uu3gAdD0l+XKjG9U/YM+pBkMlXlKHsenJ9AQnm3+5GkeGJfimbNU?=
 =?us-ascii?Q?+o2HQX6sH7rhT1dH/D3RBu85pAaaUxEAdS2gHgyOxGNWxJwO/gb4lgky80PV?=
 =?us-ascii?Q?dr3DoX/QWS3uOILNUxiOUYwYieZTs7AAz3hgIg+inko023aTVqA5SWfn0cq6?=
 =?us-ascii?Q?4+SEFGjCI2bZZpOje6otRKs9K+5YQUDkJ+GxRPpNdsBu3hA43VCkFBXjYJgZ?=
 =?us-ascii?Q?Y64hfkLr3mBtAW4UYGahYkknHbegIyCCQ1M3b8pjjaEHxvzSzL1LW6HPnhBS?=
 =?us-ascii?Q?+0l0Yxy6/4QiGyU2kf1dGK5mjRfREoKVQVKEXj+kyxtfFlyZlYMIu2xgT5nh?=
 =?us-ascii?Q?Q8TCxIlsfU84TPdptdX9kBDM7tGXYrupm76vrNwF8SvnFNBm9fMCD9RfMPqw?=
 =?us-ascii?Q?ptmEV2JMoD1TWSKKiWDWt6tpF09jJwhEXO9CHSJAf5aj4mqO1YIBb9LsD/ea?=
 =?us-ascii?Q?7MEmIA5Abs5QgRQo35euaeOTgqT9NVPqyRe/zq00s0Top/OFH6O2MEW9sfyR?=
 =?us-ascii?Q?tZrPbLXuywQCYbyjbzttCFg6usX2C/5xLpaiwiZpyNd1GkqsSOI+6BHdXjhx?=
 =?us-ascii?Q?PNPsW85DFvLCtkpTOmFZkOgh/hbvZ0570nBRNhkIOwHtGQwfDno3fAgag1YE?=
 =?us-ascii?Q?cAQbEdMmUvVlj/SeR6IaBNkBv4zrqrJAiLTLdtFD/EstIevXmlAIjoflaVJV?=
 =?us-ascii?Q?NriawLgaQjKEhLplf5zIcjK650hSID3l8c6WFTAzhycCtxkXoSADcL45+4F1?=
 =?us-ascii?Q?/hrpf9d9f6XZY2IuE84Q8eDWd/JyszE66ApeGW7mCVMPiiGfryNy0I0mCSaN?=
 =?us-ascii?Q?7xUUnbXa99O4Na0qs4kzun2aEJBgg8s2jD5MPpgO81Gy5W1l09Vp9BA48vJO?=
 =?us-ascii?Q?pUKX2CNXCh0rHb3I3mEPaAG8vJ/qn6r5uaQjQNOZSmqcI5m9ei/FQU9CV+vC?=
 =?us-ascii?Q?CeJStz05YstScwcbXgbJePYh5gORLsL/cBIWQUJxBRoK75rGweX7U+XU0Ek1?=
 =?us-ascii?Q?rj4VTlvcLzRBSal6KVwLGK0dOZ4WFISgsLTjYnsi472c8A2B8Yyn18680XrZ?=
 =?us-ascii?Q?z9Y3O2/VOSt/rGH4De/r2Gzuik0PuMrgPdxb1cCa9G2uTlbusDkJT4wOTHff?=
 =?us-ascii?Q?RDFd0mqN/1MtbsbAKrgg1Rgy6F1/tW4lzm3Ft2ypBi5PSXu3LD9Y0ZDfAAyx?=
 =?us-ascii?Q?NUMHv0TQEpLIBS997xNNV18v6iucCa5RvtNOQ5Ha22f++clMXfgMZ/vzey8E?=
 =?us-ascii?Q?9O0Dm81nVXIJjoqX6S71phJrtwyv2izOxlRZ9JBap0PY5QANv2QG+NC+E6Mo?=
 =?us-ascii?Q?jaompWLKJUWS0W8P4ieNcoooEdz5OSOLhuQZPR6z?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jdE0NYG9ZQI4a+0GH1wGcGQONH9bcjWZIEaWMsHJDkFyB753FXhf2yPjWG8GTG/kiin6zQwYG/lhMHKRCziTRfvgIfwydbhM+4RojzKgray0KZ6jUpYXWLJjGNB4g/izntKYrV3JKOFCs7sbxeoa3uQhlzRmnB0C2CXJ18mRF1YFuXQeyPhzA2FnMpEU2D5C3L3bDrXOF+NZukw1WTJ3Jys9c9wc91GKNN/OYzv5VN5Gw/IlXwTvqEurfYWbtR3hDgMqbTtD8MnOzfeOK0/gaW6gsXOWjJFs8BlkvgxQ3gG9aG+HTdk4rl8bE/PSjwB/6OW81FglYf9zxBoFPnH8cu3ayxmD4GxxaGZajUp/FXCnM7coFYlHqBlRBJFwcrVZGGyQgk+ItC+P7SZpz2daiSDB46woDopEkPvQNXvoeNc2Ng72HLa1gBopHVZIjSOQkDj1oMeZWpoYTBaFkwnna4hHRDKFSsZ2X3//8YbWIIyntjESXfy864A+WBaTd06W1K3HHcwwAiEdtA1AL0OHRJaXSPNOhEQ9UyNpBBZUFBQwes6PUy714vbhUOvzFTQ8TA9nBtFL8sb8Z4Tk3C6x8NTUcjPIsxzWABndsJ+3Nis=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92eecc74-f048-4c93-2a9b-08de290f1cf4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 15:03:22.2780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OcRXIEl3rUpGeH940+ruMjLTJV9JOYHXI5i8qdSXXq3enDdWO0wfO8DHlrZovHcB83rH+oIWfuv8lz0oxmQUfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6839
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_03,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511210110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX9wQ0TCikNema
 czqCdR95fCNz54lPwHQ3fr1cJHHnMRgXdeeXWYj03M91zdn7AFZ486qqasBPh1kKU41POoFJqkK
 8xS/g03MOKUHyiLT1tYtQThtFH3B60/XwKnpGS/OYV6vbAuSgKWReQShMcwbWXDo2DF1sXaauDJ
 WlUcuEJwPI/KEZoIl5WNkIAPIRxUFMsfhqWe4yBL6FbRb4/JpAwDBbDxgHoZ6kYDQKCsGfqwkab
 n0VK+pgTKXr+2SK0xa0wjuqrpH1lioIuI1cXYF6LTcBJrTCQNE9caqY0zlyXNeC3GOBSnWiN3w2
 0O0h6icASzi+bOQvfIq7mlzARoR6v8FIY/rjSYsYXEayrVzYX9sWdMtv+AB3M11+LGFloXjCAhn
 We+RskdvqNx++RJ0nu7sAHbocQZl+KpFlyTeatDzx8qj/Q98OOM=
X-Proofpoint-GUID: fA79l6-uwk-Uy14LXQ0uKAgGdw-lK85u
X-Proofpoint-ORIG-GUID: fA79l6-uwk-Uy14LXQ0uKAgGdw-lK85u
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=69207f41 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=88_75y_KUd-Nq5tHJM4A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13642
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A483114000B
X-Stat-Signature: 5wigfqrhuiq8s7x1pajy91gaixtdyzd3
X-Rspam-User: 
X-HE-Tag: 1763737414-751131
X-HE-Meta: U2FsdGVkX18MobWVv4P6RiEs09YhsxDnh93rWLldwTdL2h/AZ94OO95XySdn6ja3FcilYzMa1aQi9vSAejO9Z7b4vyLl9tYcp6j4hLmDgw3wTZ1zGiDwp1TF7OcJiKoNzhhjNG4CUBT0QvhXkopWXJK7+UBELw6Ur7sA55LmTm6tLdLyoWQDEGLVH2DYVSC5PoJGRiFttMPkqJ5Fn8qfnEuKbtC4JjJrVl5eGgyRe94y8RnhzIA43rComc1fIqimjH2ZcZWFAicPZqh0neYpxkdl+kQutHNfUo57ZVTbMs/Q1ZaWeIDH9mlpo2LpoQWGaRYa5EK7J9hcrivu/2HfSP4tYHJnQqyssD0zxYe5DJRyrKsGwXgdBp+EPTZ+ueEscan9yXEi13CXnDeVOp33Yu+oRf73jzCXVOcik33i879ll4RmxesNtErU79NB0rjAtfFZ5iDxnwhylhqb+lAW/nvPYMMcjBbGXMrbk6c8kM5kMaqZWjrFE1MSuRifae+nNOeVAoFyy1UdqluZy/FGt3RAXhveRtC/b5ME1b/bStWENAhsrqZfpZVCEpdhShQ2bCo9LeT5xflw7zrf/jHOh7r51X97joMm+1UI8uloQc5qz7T8jw1zcsMuHrqtPK4PRXyHRdbAtfBwXygBDSO54Qs/tkrdD18b+i4Op/IfV0L+ROyxH0NOtIURpUNQwhT1a976KiWdBp1rq+b22+NHz2zX5H5I/dvEJZZR8F5OPy5bCtr3hDHeIN6PsFtYWO3vaqXG2nIflRna3FlJlCom04LQh9Ue7ovcd8sn8CTfNr6f2JYQJ5cK1YrPuMBN0/mRlMRb8V4Xz91ToJoRrgGjqQxYGB2/MtNhdHg3qXsf71k/oU8vFZL7c1oxMFa45afhPEPzvT+C5f0Ge+eDhuF/0sqxoNOB0q3ygNSi9wf2KK520vowm0/ofb/+LUQZ57967L5Ioi+FK1M8qg5Kkwb
 xGPdxgHh
 J2VzlEwNRRW4+QrcJHzxGFEA5OAgLB8O3OncnPDrxLhjwYnXXfxWblxarz8xkZMwMk+Yc45Z6S9SEm4w/C+Z8+WLbfWZlJQq+VaQldwJtOweZMBR8ruimvdNlBBdY0l70F4hjR8+gSrOznMju6/kBkhMC0FShoUGhLQI4LDYobgAzvDdrpmB5LGgHEnl4KuZno2nIlg0ChpEhd3DmBiHUbperxTXvKoPROQV+YMSPPoXewxRwgB6djqkWs9IWOAQ0lwvSrucGUmHOLIwiTZV85qirRUO5kTIhDPml8/H7TEWZ+IqlcVb4Enm3O7cN014+iZeor3xIYeFqs998zOMPuBewLVxFWFwywQYsZsj84z/Zeujj0F7Uz6iUGw3Q3P0cNtdhB3pC3mNmE/oo7d4+18OUPG524eAqzsJ73VUiO7Bg2/G5eHs4VdQ46w+nUW+pwILSJiLF03y9ef3SlfK0gZNT2ATRl9QkXTnKQ0zamYmCLP7P8g+lfboeZw0nN6kvatS4HK8k2Lyi6jFbmXtPmH3OpsyDEUXos/y+mRq/HT13mUaVwEbAyS0P533CIPyJy6c61KZ/TcHVvjHytWUKM/+acggsH1UyPtqaCucXHE1HZ8HegBIC0j1DIeB9B0wKHrj1oq8r96crqYzP/wkwXuyciwgmpzgPsTiIqWmehk5oT0rbCuaA/BlMMa6X1f1JebYvdCPeBFWZ3axgYBt28xqgDTKqQfu/E2kpvpACTocD8/8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* David Hildenbrand (Red Hat) <david@kernel.org> [251121 03:13]:
> > 
> > Another way round here might be to try to use userland to figure out the file
> > that a mapping belongs to via e.g. /proc/$pid/map_files, determine the
> > attributes from /proc/$pid/maps and then generate a new mmap() call with the
> > same properties.
> 
> Right, if we could find some way to just obtain the file/fd we could just
> avoid mremap altogether.
> 
> I recall that CRIU used something similar to obtain the fd of a
> MAP_SHARED|MAP_ANON mapping (anon shmem) VMA, but my memory is a bit vague
> on that one.

There is an ioctl query method to get information on VMAs since 6.11.

Check Documentation/filesystems/proc.rst for this:

Starting with 6.11 kernel, /proc/PID/maps provides an alternative
ioctl()-based API that gives ability to flexibly and efficiently query and
filter individual VMAs. This interface is binary and is meant for more
efficient and easy programmatic use. `struct procmap_query`, defined in
linux/fs.h UAPI header, serves as an input/output argument to the
`PROCMAP_QUERY` ioctl() command. See comments in linus/fs.h UAPI header for
details on query semantics, supported flags, data returned, and general API
usage information.


... maybe that should be linux/fs.h and not linus/fs.h.  The actual file
seems to be include/uapi/linux/fs.h (grepping for procmap_query).

Maybe you could make use of that ioctl to get what you want?

If not, maybe look at adding what you need there would be more of the
change you want to make?

Thanks,
Liam

