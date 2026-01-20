Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AA2FD2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 08:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2CF86B0386; Tue, 20 Jan 2026 03:43:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04AC6B0388; Tue, 20 Jan 2026 03:43:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABBCD6B0389; Tue, 20 Jan 2026 03:43:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93DC06B0386
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 03:43:41 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 338A1140430
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:43:41 +0000 (UTC)
X-FDA: 84351703842.21.F4CF398
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id A39BB1C0002
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:43:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SM6pNC1i;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WxMdFkAT;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768898617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hwj4S5Z8gYrcHB1xia1t7+GG7HjIZOfKTHx84d9Uok=;
	b=FPVNWu0iH9rAGKy1OihUlrPbj6OheOePvdkpLWTD56PtMMdjdHw0UKmjAbAd8r3Ys1Bsw4
	1uVDzC4Kl8+zmuXGOscEW63VgKTOR30pvMHGMKvBgqhH1IaMdhA6cx2Mft+TLsk5r3gk6+
	1y59PjKpF6J7zLJ7oOwU4yYhU3dqlVQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SM6pNC1i;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WxMdFkAT;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768898617; a=rsa-sha256;
	cv=pass;
	b=ITMYvT6naQP5Q4hwgdl+v9epjthghuTe/zSejuKVzrA4v1SckqVfznsj7TPtPBq0MIUmMA
	VVAsBg7lKlTlanVboFILAST1APYSOzgVIu5o3yR/e6xb9eTB1BltiLl49BmrtCl+IEiiGo
	AkoJILNeonwk5U3NUUz5m+ZAkPrOflI=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60K7uoLA3429730;
	Tue, 20 Jan 2026 08:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/hwj4S5Z8gYrcHB1xi
	a1t7+GG7HjIZOfKTHx84d9Uok=; b=SM6pNC1iNiQg2RMPgHXNU1o6GO41S65pxJ
	DULJMnbSAH2n9IJYyMg8AObeSyv8fnIPVvTZ046iP41sLezxe+iYbEzAuWwAQEzT
	NglXM3Zuyn6VYRM0Ga+kJEivEk+G0GWbb1WhYuUWYArSe5fm4MpkXBnNZa5o9uT5
	WWylJOx+MivQ5NprfTms2BfWraMpUmGNh8LYtlUfmTCK3yY878BZc9yqp5/LFTSD
	P5UEiz0z5owwMWbX/xBbZ0SKf2LfFtiDkr/VFYcLtvoe6elkwePJrBEDH4u3ovbX
	Azkw+hUj/1r2vnotqOydODZbr8DQz0dfEwSbIwaSgZ6lqFdF32qQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5k68y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 08:43:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60K72oOI008362;
	Tue, 20 Jan 2026 08:43:29 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011004.outbound.protection.outlook.com [52.101.62.4])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v9awqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 08:43:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OW+HM+nr74xUw2hyqR1DfI+qHiWi4c94d8QKf0NvEwohe0hGWsTLGx+W5gIsHNIbHbBsiK+skJcv1uWufQVz7Si1d3bowkAMpzazGqQwhpCZrJm2QyUY7eubR8zIX14Fo3EV7lQsrz7/Zj4ST/ktajadTL5BdA+1hQAffmE/NWicBOLmBiIPpnmpecgit6RGEodXQ4xAJCCNBjBmoIi2D2pfpPh4MHgQT4VqZIQTmx2c8ALUhMD2Gqr3a619veCx2bv6DB3NVHLqU/LDvBFKsJ3ZPySNn+XIRwrxsq0au98i4iOTFqxJMjN+36at8RKVVJ//iQHfCzCevkbRcimhoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/hwj4S5Z8gYrcHB1xia1t7+GG7HjIZOfKTHx84d9Uok=;
 b=IuSFn6UkfYQ/Wjdweh4cD22hJuG1zpRFIuFiFufbxjN2E+iS35kZna8aUHEFbSJzBmnKUhAk3sxtA6IO9sr7zaXxrR8+GtthxswhEoX6ut5CLmg2Niru70GUtYf5pdh4ywXRQGj110g4nhJ+dhtkAmSn6rDjfrmi1YtpER/2wae1TQcy6i7F1IZEq/vrMUESDhDf0SziRk7s7CBN2nF+u+rlwQ5CzOlHnu3UVNXpA2a9WfgbvrWVveVhjeDkJSv6tRMOfYxB/nJ9cYvorl3AjITPKR9bz3ySwavGKNScQZSS6rvudtConPF8ojSw8M3DeCzljh7iQuEvqIyCzVlwzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hwj4S5Z8gYrcHB1xia1t7+GG7HjIZOfKTHx84d9Uok=;
 b=WxMdFkATTBApRn5P4p89TdBnNNRjZjd9nV51Bme5geVU9CNnX/D+9MEauMW8x+hSm2SNQvPskwOx0FfDqWtUHkgCY04KorZAaFn/V+wRreqxGpbtWV3vnfy7nWarrJLyyc+VcFIinExx+eE4diYN5Belk+NK/DU3RSY8IOU875E=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by LV8PR10MB7872.namprd10.prod.outlook.com (2603:10b6:408:1e7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Tue, 20 Jan
 2026 08:43:04 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Tue, 20 Jan 2026
 08:43:04 +0000
Date: Tue, 20 Jan 2026 08:43:04 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        aneesh.kumar@kernel.org, Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH] selftests/mm: remove virtual_address_range test
Message-ID: <8acef9ff-c5e2-4111-9437-f50b427db061@lucifer.local>
References: <20260116132053.857887-1-lorenzo.stoakes@oracle.com>
 <5957ae48-87b8-4981-a6f7-8113141e7b6b@arm.com>
 <f44fdda0-80da-49a6-a9dd-75b9a46e1f76@lucifer.local>
 <e71ffffc-8623-48d6-88b7-4684af4534aa@arm.com>
 <f7ed83bf-3554-4bfb-8d77-30ed4785a4a8@lucifer.local>
 <f5f92d9d-d65c-444b-8357-17cca7ec176c@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5f92d9d-d65c-444b-8357-17cca7ec176c@arm.com>
X-ClientProxiedBy: LO6P123CA0027.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::19) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|LV8PR10MB7872:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ef86c0b-35e0-4add-6061-08de57ffed82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?muQC8VgezR/CipHZUff53Stu2RjTDLCKO4UDer18D9HcdmmsylAAdYoQnvNc?=
 =?us-ascii?Q?FK5AmBreNKfA1jR7Taest4eG8n5AmSFXCh+gm5nSeonblUxSTfpC71xuE4jN?=
 =?us-ascii?Q?fNuLz0hkUlwshqAzOrXM4erSBcIeQuEqhwzYc9vGRTb98BSUcedxItD+R67r?=
 =?us-ascii?Q?HPYUeoEdD95fHLjHP0ZHDPDhdV/an4P1PZcBcrQGjfCa3XLMh4TGwIaBY29E?=
 =?us-ascii?Q?Q3yKpj9bP0+CdK2p5Kh54ilCl02k70cTg/YZ1eMwICNS29MER8VukFnpL+Ky?=
 =?us-ascii?Q?L3wbeA7g41XtTBYxBMUWgixOQOQ5oKqfRsDra3EVqFcaidvvxyukttZ93eom?=
 =?us-ascii?Q?FGm0wRsI3WZd6cyJSoIP/v7ydxavGqrGf/TaSb8U0TB+3uwhB0e2NBwk/FOB?=
 =?us-ascii?Q?lChDgwblB/tWPDIXc2bkfiYq+3bz6w9fT46eXz/k6dAJX5sZy5/FIIwViTeV?=
 =?us-ascii?Q?huMSAl8WaZOVR4Xb1P3Q8JpRX0EPbp1BdNSjAFAEKz0dp3X3mq3zvwWu99cw?=
 =?us-ascii?Q?dkXs6fuR+mNdWQP+2koYHUhCMzXTT+7qDPaQdLPD7zkED4OFftg13AD0RJST?=
 =?us-ascii?Q?agJlg/IqvN769rszCN3A5H2bSU8v9cKOnayexXOAt4ygD+VFOJgo7OXAF0/b?=
 =?us-ascii?Q?PCuOFrAfN4dyDiTwoP5qVkOykOoFgG9Nn6o87tHeAB2mHd2l1GO3JzF7yrcR?=
 =?us-ascii?Q?jcD/rQYZhOCWZHO/K/xniIkYgPKaj3ILn421JgvWTQhEeaZO2K0Tdy0bbOL4?=
 =?us-ascii?Q?1Gbh4+ShWewfpCv17gOH3zpHvxP4sFHY4HdAKWY2P1t2gJ7GxY9wbo80j+0t?=
 =?us-ascii?Q?HzqdDFPq1g272irfM8vQNHTpc8Ag5oem6VUSXxWxivg0F1TPaKY/rBc/EOV2?=
 =?us-ascii?Q?Iayhpwp2DITrwVCkIOziEviI+iqC1xthtXYdh91RWmzv+ONpaW0/YjIhgaaA?=
 =?us-ascii?Q?12svkhbRSK4gArwXG5ywKAXSHxYBk2uyAaa7H3KVbsGL1+Iziu/BuGhKdQYO?=
 =?us-ascii?Q?ODgvP3eSQatGHQHpKAUB9D7LClAs+xFdM0tKGKWLJEGbrinTAvzqqZGToVpR?=
 =?us-ascii?Q?KYELfnadPojuxeUESYtH920fzWIMIvaeerVTQ0IOf9cKKTtXjjIAW9AEJjpt?=
 =?us-ascii?Q?cgcDpQf4CPRtE5nVkohg6UdfAQ6yJOgLSP4RgFXuVombdDmoY7x40Qw2+log?=
 =?us-ascii?Q?gJmc0BF770BMvKQ/mQBjAInlSZsy/qBa6CPf/kbqFwZL3gDqhl7e89ADrRGz?=
 =?us-ascii?Q?jshW53Oa+eLGsh5Km91/7owug4ZWwkQQRxbCu83cpOJV4hvdguMl/Kt6AHOt?=
 =?us-ascii?Q?+d1d74+2G59u60dPnG8KEmn+4Q9zQWfbkdzolcUpVLlHdDkzxt7KpOCSU4BH?=
 =?us-ascii?Q?UWlKHWRbASL/ozNlDWhFheu95Ff3p0kF8kQgjwlgAVEuc1ZYFbzfEmna89OE?=
 =?us-ascii?Q?ptCEI7rNkEZyHP2DxYALDGSzxNBnBrgN/rY//mxk91hb8wyMU5ergpfjEvpj?=
 =?us-ascii?Q?dH1iBxAl83Sh9t+jSi7pkkrAi05n5Qx1N4OATw/3nVolrs+2f5RVk+/6ic3e?=
 =?us-ascii?Q?fs+R+xG95Gz0ox+bot4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4c+Koim/KQpoAMAYLinUovDVQL48x8Ir+ToFUtVa58MwczKmJGIk9qCkw+WV?=
 =?us-ascii?Q?Q/1UwbhaBk9SABZWHJ59gSCdcrfpUqjxIyJMrN/YBia/QuN1FxlOMmw+d4xR?=
 =?us-ascii?Q?/e/s3tKUpO2y+YvhPprYgC92q2qN8F+PLvNQAtLCBNuilujAEpqdQ9AhCAyn?=
 =?us-ascii?Q?Vc04JM8vLOZcfQOMxKhtBHDGG9dU3QOZGUk8lxVyWPtGJi8gErFRAXEYHWeQ?=
 =?us-ascii?Q?HWZDHVZzVGvswpVB4FG+3K24R7/XV90PocuUe+6g/1RGo6FRZPkNLoeharP1?=
 =?us-ascii?Q?RMukqLFebKhS0ESc90t7FCj2JT3rgMYYPZJ7D9tG1nOuySxhsUuJ2xn2dIOU?=
 =?us-ascii?Q?hQ5YKmE3+Ijz4/uN2F00AG5Q9rkdfkW3j/fNrbgy38TGY6jM0007c5pGiqId?=
 =?us-ascii?Q?OEwkhsfgQBXGh5CatQ8WOEsnR/E/FFuTkRkXur7GDNEv4cI4dB2WiYkoC51u?=
 =?us-ascii?Q?Tbk5UE2xXRynJwWbdzJKDAQfjOx90xYPKwIE/OcOEDvWPcMLLfnpMqw6iWRI?=
 =?us-ascii?Q?aDbEjHYJsDk/yRcO9pcHNcR2eIPr7uAvdoHZOFLeUrMhs+KhmAklydpxw7IQ?=
 =?us-ascii?Q?qGbDbZsPxDeAwZ7i13dHYl6gLPQWgCL//fSaCSGqbDtwALhGiJdLX6DmipuE?=
 =?us-ascii?Q?pqERaPLrX1YARl6iwufNv+ZMP8AY121rR/rHaUPUP1Ta2jkveOouJIscUj6I?=
 =?us-ascii?Q?Okemm0f0vawFg+n72SYzFMcBxDZCw2bwc9CXdLqI/gxYJ1nZt+YgatJlPUnA?=
 =?us-ascii?Q?+FSsSPa9i74JllWJs9IZ4dtjBwxodvQULd3kV4h8GMSzedPNPJyNAwCbinJO?=
 =?us-ascii?Q?gFxRHR03cqXuflQvCnYaTD4WziwNJ3Xov4bNFRNBWCpFM2B50Lfj4KfkCfii?=
 =?us-ascii?Q?np8N3C3Xp4SQtFYyVRsmwaNyktthwZpGOm3f/xM/vKbw7+A3zAcMrOuHJL5n?=
 =?us-ascii?Q?xEb//83fDZpxmlTBr9fB33uhrr8U2KKGvHQq1+VuI7S4Md7mKN1blTDpGP0h?=
 =?us-ascii?Q?Ilg0t4cu2P1S476ji7oKKVaLRhPIcopiNII6mc+6wquzKTfPDSRaD/WDhwMw?=
 =?us-ascii?Q?BH1qr1aDeOsQ9yMonDdfHZkZxZpEpndyShtxOZbIlcALS5Xji7H3PJLSfeST?=
 =?us-ascii?Q?p+SeezGHbapOn1dW3zQf6NdFZI1zN549pL/e/LrI6z86HhnAX6gcYukAyBFk?=
 =?us-ascii?Q?aWHKp7N2yTi8QTPOzzdjDgLyHYgPYAsbEfYMWngFTUJFWtrilnij1pAD6xQb?=
 =?us-ascii?Q?dHm3XPJxY47e0AYm15wA2O4XySrQASCeY9uTdiitQZ587nTqgKsO69azS+GR?=
 =?us-ascii?Q?dQgAoA1DTFyyCoHABIY4Z8DipyQP3NCdkcITvbyv60u4mPxyWDGkbcwfLdiW?=
 =?us-ascii?Q?QwTYO/Oye+HrNsnwDCCCbV+PsprJoFo2AhUA0V001oIDhuFU4iDtB+H1vGzH?=
 =?us-ascii?Q?5ZfGprSCbPYW6AEmEIlrAARh3px9QRknFWoNTcK+Lmsxkl9PX8jA+Vona41u?=
 =?us-ascii?Q?Q5K9vGyZ1Od4WeZGDS+bbs6yW6GBFtxnPvJEIw66CEdFIvjnSsStIPCTjjQt?=
 =?us-ascii?Q?Qcx1kocYmxPvbB4hc+VtERo6xJpjasTLIiMB58q70HWOV9Dr1TIS/KDirqgj?=
 =?us-ascii?Q?89+ASn5w5FR0FIJgQNm2wAJR76GLETMFrDx7Tv0H6hrvFJLmOTWwJniTy4HE?=
 =?us-ascii?Q?IXj+C91L8TRx/hFmJfFoqmraiiENMXHA06nndNW9iDFuoxXZrwxuXaDCcTq2?=
 =?us-ascii?Q?PBbXrhh0aXRuLyl8yhxpQT8sHTHl7Hw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fH0Ft/MkkBG8+dJvQ7dB0VGUMo46bw+oziprd58dKl3m0yqd0zmlTCU6E6GXlSNIe7TC7lAKKpRFzykyrd5zHIxesgkeqifr5mynbesZmRaETeFin3oquOE7dImmdrH9l9UnyqMtgEeofbC+b3lcDKY8kBnWueNsSvhc9Is5KQDj+yrg2s5SKxgJFgFNDr/RLPDxrrnn1Ztx1KxlZtuvtGfkFZ3/DW6MEXtxi9m/leV99wXvdic9w7Avs1grlJ0sm5svPJdKPNiErKrjDS53e08oPcZLGpuyw5aX+pjuqRN7EJ+3gCZXj6ZXXRD6ujkNiAxinb1/sk56xvXiZ02pgyYx5aG5eTy9YgFJ30LAvxO0shcRCc/mQoD06O7MkZKcMBc7t6pRN3UJy64uuigG+cJwpC8pqC/Wnt76XhUZmqPmg12lMEjHruObIpnCXvXSlrHs2xZwBrBy9ZrnraPfPODjgpPS/woI3vKSa8rKMCJRKoBxOxKSKi6ciCnMRL16mCF99qfZ5NksoWDMcA8muADilQ49VveF1wUsSTNJZHOsMBV6z8Lta2PynwCOyW+JtDIUjYWBY3ERGTSAgCLjo4kXV5p9F+zME6QYbXFjd50=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef86c0b-35e0-4add-6061-08de57ffed82
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 08:43:04.7014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7VoWTQDFhufQCwfwBLW0Mcg4wEI0JSK5leg/TMAH7C49AzdwfnPAuXWMwGfFl5aVxx5JEY0A+WO1GqJ0fo1ICYc9xkVTsv47dvp/Gv/Xn8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-20_02,2026-01-19_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601200072
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDA3MSBTYWx0ZWRfX9naY/qqsK3u3
 mH3urqaIPmFFbRp2/mpQZIM2PaaHK2CwzEba8l4wX2UWq7v5cBywHbM0MkP4Y0cOI7teBHdrmPd
 mQbDwOHWbwbeUA8+8QMUQsTD4D7b1uo0vlsIv4XNFsViCaU5Rds9XsdVhUQTDDh3ZTEMo0Ea4EV
 pQLALVD6ScZu+121402CXBqI8Abh2rQN4WMIzGV3l0w8saQtHJXOdx9qvnCjp5xYRLCIYwr4iWV
 Py1t48MbfQpL2S7dVegN3BSPiraDT7cgTaHBm2+wsko6F5fD2T58E/TyW0pGroyPASQtdXDvulZ
 ohYTG7idskFhOD0Pe4G3lM7ffSkNsLWtcFGTSRZZnzeAD1vcb/MMIo2kkdSLV261Xd+r1k2lAd4
 uaD/tkFop2rOwogXneUe5KmQPl76UvOinYut/qBbNJDC57sDTnFSA4U+SmSPFoIPQIi8pDCeXhd
 m2c4DKtgfJosYUi4wUw==
X-Proofpoint-GUID: laJ1CLtleoOG3-BLC4lF0EF4wqu1m2O9
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=696f4032 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7nBJH9KIrFlrEhku44MA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: laJ1CLtleoOG3-BLC4lF0EF4wqu1m2O9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A39BB1C0002
X-Stat-Signature: 96uf98y5i7eum7k9xkr5so5poq6k7ax3
X-HE-Tag: 1768898617-943296
X-HE-Meta: U2FsdGVkX1+c8/8mvO+/0aaI1M0vhSEnee5f7SD1rMmYYsXOglHoX6dDPTY8WzbmyT4pvyUpzaDXgLRfb33oBwAiCaUYv+GWM3zkeAmco3O2wCQgL6M9I/dPNlLBoJmXScxk9CwM2D/C9Df01ru74Xx7iwE2F0Z75rsNKseb8tTUOI+Jadfm3ogdUaT0PqhN/SGmlW+DmDeaiaxAiS+NKqIzpR5Ui5qnrtERyk5W9z5msatQ4lh15F/roHOs7ZTMdYCe27PEQser7PCAd8FJlXMI/GsWygnVDOY3L4gITv/AbrUSj+N+/5nYGF5RMDf59iZcv2WlCblm5IDHj0CS0XJofAoLWQU6HkgzPmsSFEyU9eQ8sACIcb+uzrHErhfBOIsM9r2ZRYcuLzqm1LFrsNUEIv21o1P2cBKogvNZUzq9pNOJq7wX1N+yLGxH+TNnbSd5lHDEP974iZW69im6hbgExwJ/f95rLRcOXNTfi2efvDCSkLvJWk2IltXnqKuPYQSc0Y9SamImfvLRMkCACFdvX3LOQohjKbd8WJcvKB3C2SPOXXFJZgCDvRonDzyfn2Bb/mzOmQMhAfEgov2eWllBRADyr+avzWhRAjvk59D+5W+1aRPxpvgOvMr4iPid9CupSzjPrnchCswoZlbtrDEmMHU00ld3Ugb7BXwD+nLQrOI9pSJas8LAi4guX7GmBkc2LgYf/4lylZ3wuPvJNTN3EHG+cBZadVA+uyUfl8aWJOh/7asaaQXLALupBYT8qCS84/5+LyNT+Uhr56Jzq7ZtIMrJRMcHqRzsU+JQdszwjWzIt8fOW+X6wJ8j6kUoj5uQlLP4gfN4Qlt/8308kAZM3O/HCEKfCEqzO30Z6LykVE2h93+iUWvY1kR6IgMN6bahNmJd9NFIMzurIzAmWRFk8s5mLlOqa04Sqo1NKwymswN/k74Sa99fDASezUH8+KcIXJiyZjG/YCkKSdN
 1kWCagN7
 6hfR64jRnR2MrcC0zb5U4zAjtEqco3RZ0KxQuTy7jShub7tsUSmf6maACT1D0w5hniV/xz8d1Kh6jXm27eD+PZIwkqMIz+0M43/43Zwngp/IFSQ/YQp17BWWFpTNf60ZgKgINgB0nev3qdhuCPiVQBe73DJKy0DcGWQ0M8CJgHl43ZcNTubeOy0ZEmhNDKtzrZIPsXHehcXF/H5xBMN2vFPjcJOkzBbLuIfYfOKifh1J7VRgvRmH0R0ovqv3/0dQr5JLH4l0pv0Gw4TiDatcSTPjyBm9qOE+Tgd/uNtCdJCFLjAf/pfdV2My4srYo6v0xpUysj02pfPYPTzHLiDDGDSjaKLgkyuNesWIggqv3SCjhIc0/OlMuHAcJ1MmpnCrvZZMOp9trNl7uTiv/nYqxq0DUyc7la9NKX5bBDoxhjMMSBAO3DIPE2kR8WlqVKosk09WTNHNV0DsSDojf7KvKVHMpfAkdUZyoxTx2D8E1c0uitbzqqv17gCweffePMtjOv+BdAXHV9AK8v1hY8g/eeJIlSjLvlrXsmw/yWPYw/Qke45nD01zXe8dpsASS/6dGh3IvDyNBmgSp1jtFTFnoF9BXFwFo9iby+SPaTLd0GeTV27ch0TuSSwn0/+B5HQaPvTWo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 10:59:01AM +0530, Dev Jain wrote:
>

> I'll reply to everything here otherwise I'll have to repeat myself at different places.
>
> "Also exhausting VA space is an inherently silly thing for a test to do, you're
> making assumptions about existing VMA layout which is absolutely an
> implementation detail and may even be influence by libc..."
>
> The original version only uses mmap() and checks whether we got a high address mmap
> success when we shouldn't have. There are no assumptions being made here about
> VA layout. No matter the VA layout, the test will succeed because the kernel
> must enforce the distinction between low and high addresses (but see point 3 below).
>
>
> "It is therefore ENTIRELY a user-facing and kernel/user API thing that has to be tested from this perspective."
>
> So in merge.c, the statements ASSERT_NE(ptrx, MAP_FAILED) surely assert the
> user-visible API - that mremap must not fail. But there are statements which
> also assert where a VMA starts and where it ends, testing VMA merging -
> I was concerned about these. It is not the goal of userspace to minimize the
> number of VMAs while making a syscall - that is a kernel optimization. My point being,
> I suspect that the mm selftests *already* test internal details a lot, and I believe
> that they *need* to! Running selftests is the most convenient way of testing the mm subsystem.
> Hence this should not be a ground for removal of test.

Dev I would rather try to be positive not negative in review but again,
this isn't constructive, we're not talking about merge.c and even if it
contained the comment /* Ha ha I am a contradiction */ it wouldn't impact
this discussion.

You're not correct, mremap() has an API requirement that you can't cross
VMA boundaries for most operations, therefore start/end of VMA's and
merging _does_ matter. This also impacts how e.g. madvise() behaves.

As I said before:

	But you do not - both VMA merge and CoW impact API. Re: merging
	certain user-facing functions, most notably mremap(), have API
	requirements that the user must not cross VMA boundaries. It is
	therefore ENTIRELY a user-facing and kernel/user API thing that has
	to be tested from this perspective.

Can we drop the subject please?

>
> Talking about the recent commits, they can be reverted. So, the ground for
> removal should be that the ratio of the time taken by the test (exhausting VA
> space), to the coverage of the test (for arm64, it is testing backward compatibility of 48-bit VA
> on 52-bit VA, which one can argue is easy to spot if it ever breaks, and easy to fix)
> is too large and does not justify a selftest. I tend to agree here.
>
> "Add a _new_ selftest, named something sensible like mmap_hint.c or something ..."
>
> va_high_addr_switch.c tests stuff around the switch boundary. But it does not
> exhaust VA space. We *must* exhaust VA space if we are to check that the kernel,
> in a situation of "emergency" (i.e exhausted lower VA space), starts giving out
> high addresses, when it shouldn't. Again, one may argue that trying to test
> this out is not worth it.
>
> I personally opine that besides testing the back compat of 48 bit VA on 52 bit VA,
> we are testing something more important here: exhausting the VA space tests whether
> the kernel can truly distinguish b/w virtual and physical memory - we stress the virtual
> memory subsystem without touching physical memory, something which the kernel should be able
> to handle. But again, any such test has the potential for a timeout. I wonder if there is a
> faster way of filling up VA space.
>
> To summarize, I will agree with you that currently
>
> 1. The test is in a broken state
> 2. The test is taking too much time to test something trivial
> 3. It is a maintenance hazard. It turns out that the original version used
>    MAP_CHUNK_SIZE of 16GB, but then it was changed to 1GB because (this is the bit
>    where the dependency on VA layout comes) on some systems even a single 16GB mmap
>    may fail. So now we are stuck in making a tradeoff between the size of a single
>    mmap versus the time taken by the test
>
> So the better option seems to just remove the test.

Right let's just focus on that.

>
> A separate question: Do you think that the functionality advertised by validate_complete_va_space,
> to check the gaps between VMAs, deserves a test in kunit / tools/testing/vma, or somewhere else?

I don't think so as it's not a requirement set in stone as far as I
understand it.

But expectations as to what get_unmapped_area() should be doing makes more
sense as a kunit test.

Thanks, Lorenzo

