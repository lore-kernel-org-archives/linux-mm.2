Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B8FBC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 01:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46446B008A; Fri,  4 Sep 2026 21:24:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0056B008C; Fri,  4 Sep 2026 21:24:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70D06B0092; Fri,  4 Sep 2026 21:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FCB36B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 21:24:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05A878027B
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 01:24:11 +0000 (UTC)
X-FDA: 85177962702.16.6D8C25C
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010063.outbound.protection.outlook.com [52.101.193.63])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4EBDE180004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 01:24:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PlZSRZEh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of jgg@nvidia.com designates 52.101.193.63 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788571448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vo2WJswMFrbVkXxA03wbntMlJhQJN3eN3yMdRHVrVAQ=;
	b=QIiDBdVkXORtTPDrgsA2txyd4ws1ocZjJSVLU+RYyKMbpQ5+9dhJLLwud6jJZo61uTe+t6
	vJoiQljeZ0QoX4Fpmm8lC2n8fBmbnXgqg1xzoSpc29x4/sUxgnQ5oqIuDcj2ROCRjkmlGF
	OUU6q/8AXO6KjfT+ZLocRwXpOjTpMl8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PlZSRZEh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of jgg@nvidia.com designates 52.101.193.63 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788571448;
	b=XmrnsOxR5sDoqvR6tDaPhKLHjnc0CNmFFvM5n/0QBKPISJcg6i/897/dFQOurbCAKNZd7i
	YHzKNWmD5xI3oOARg+Jyn8Z60m0W/UjyeG2YP9JBHiVJeEYMEjTk/stIEHZ+u27k+odX5T
	JBYXK01oJ4LcwL3jKO0EO0FIr0QY0/Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wW56rLIZoBms8qTVgcPXCXbK7UeL9hLucZkTAqN6uJ5ZGaFSuPudDP30eaC32dDZygCTxDs/bNNZjU3rYtf7XSZznlS/A9yOY771s/jtSOR+PhHY9kSIhgrODYNxxnJdGO1DCjG0SuKfdOOeeGwiZPq2E031phrWLY/fX18DRFNDb7FKVKRgaaVve9pMaCUNg86cqXSRhHaqj7oSGOEbvJzi9ZZ+HICMye8HNPw5xb4OaRb23paDMXD4F+lB8Ftpn2qDu/Yz3LKHatm258nSNCUSdKiAaFI8ZQBM9r2GfWY415o0MSrY3WmatvsD4kcHIXl/6zT+ICoUk2KQdkY34A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vo2WJswMFrbVkXxA03wbntMlJhQJN3eN3yMdRHVrVAQ=;
 b=mZlfLwtUflJSFEqhvroNnVmEJVtJ7IQyMdV30x36D1R/BxSDSWN6Aa1ETwoT743f0/tXQQO0FF9IjQK5BldYEa3dxhw+X4nmydJRxwhZ9xxKdY2wb8pVKl/XMjpVkU8c1Fc0469DkxD37mTqX9jabkyaUPF1VkAYLUgjMSrTcgaqmXXP8nOQ4zWdYcBCKiGIOERKJ7C8KgB+avuJDdZkaiHY9Xa6FgSKmdEQ5fVaNdQcYLQmsgEGsFWO4vtGnc5JV/4Z4SsITIwF1rXuxE6t7SWO6qTU8/BcP+3gFafR+8wsPBYa5wU3sX6uhJc//KFUSlFa62lRFvR3Y8YNNLiYpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vo2WJswMFrbVkXxA03wbntMlJhQJN3eN3yMdRHVrVAQ=;
 b=PlZSRZEhJBbtAisKV94ciQEoRq/TghtgpsU7x1KHeuoyiyVnwvpnXDL6S6o7ulOOtkSXyHSiOEvVRrVPB6oP/0rZ1fKQH1s9PAs3Cg86RxF+GuHfyKUSWTtG8kQ6OKeC3Dyw0dbRmRywmL7Z7z2imtZAhtmkEbPeiKuIs6Mrc+Y8c0BF73YbBNIldZzP+zHZfQZRj/HLuKtnSZ1MUiO2HHQr3JIjAeuPjDGnQUkAxhAa9/QNAHDbD/bLfBN6jkBkUdbJaQOKvvQh6YX1yFQvg4hFOMpM0jHjpdjxqxjkj3qpN3cgIi68PE5l7vS0ilb6PVj31Q+gMGEh4msS0/29rw==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB6001.namprd12.prod.outlook.com (2603:10b6:208:37d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Sat, 5 Sep
 2026 01:24:04 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Sat, 5 Sep 2026
 01:24:04 +0000
Date: Fri, 4 Sep 2026 22:24:03 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: Logan Odell <loganodell@google.com>, arnd@arndb.de,
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org,
	graf@amazon.com, akpm@linux-foundation.org, pbonzini@redhat.com,
	maz@kernel.org, oupton@kernel.org, seanjc@google.com,
	bhelgaas@google.com, alex@shazbot.org, kevin.tian@intel.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
Message-ID: <20260905012403.GX4157646@nvidia.com>
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com>
 <aptFFYqcSiBdMLE8@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aptFFYqcSiBdMLE8@google.com>
X-ClientProxiedBy: MN0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::26) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB6001:EE_
X-MS-Office365-Filtering-Correlation-Id: 81f139c3-ac02-44ad-66fe-08df0aec5f6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|4143699003|10067099003|11063799006|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	LdfjD4RvQZXTTXNl4UMGD4BTxi6Ua+7sLSu/tqNwEOItjyKFdNBQ3JV9XB0Pyh252uYBYsS5sCWFFx4kIM0iy6XBD+mQLjRo9t32F24tPIx6Mpv7u8T8/d887qw5MvQYNntrcVQClmW/Gof/Be0L/0KT0lMnvPXlz7GXpUL5F0jKUpm1QUXGY9oFg51UNSx/dzkIGP8WlhfRUKk1kfRfPv5w0PC2ANsgXWOWRRzJjYNFc1k9JDrKZP22Z9eZrQWnDxYenQrthgy+AYksc33cD8v7IhdKB41AU0N/ho2DIBzaw1nrXa0TwNKeYnL8xCvAjoNyMf//8YqzZEerlRadiSUSS9vqH1NSM2vEidHPGMSNuH4+OhGK7KcaX6+vFCmw6+xJrBRyxb5Ct0SZGNarM3M9k7/CZ5i7JPecpMs5GvHHCJ474AxTVJY6YuTOLmQvqsZB0Ykz0ZihMwQ1EYQ6PMlqZvqZ3YiQ5Ywv06uBoH/dkiL+nVza1z3MrR3STQRadg2DVovNKWRB/bO9+exGUXgQUTRcnDOBBcg55YcrM+xeAMtCEqamJuFi3ouS3GsLdfVLlUNSCebL23jVlZIRsY9yZO32A/xLvWvUspH0CbUHOqKioRUqsVvj2snPka+AOW5WGR9Pkew5rSc/Mo8AsRqh14DvkKVBYKczsEbCQ6A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(4143699003)(10067099003)(11063799006)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qbuHUp63eMJ6A/YT2KIsT6s/H/Pl+Z9LCDWeNq7V2byqf6KJuLdaKra6Wtcc?=
 =?us-ascii?Q?t71fCbp6CPp5uUQuQHkLsAQHEhpr02rLHTv2DFpCz5DSeQ8w7AA/PI7S8qHL?=
 =?us-ascii?Q?jBOV9UPlxppFKRplmp4DGL/PNM5cs10rZrgdc5xnvwKAykhz39QDrJ26VJS2?=
 =?us-ascii?Q?vA343+CDCOTKK1svFJRLDWs3HpsfpY6Tk0N42FroHVUUWuYUSYYII7y3F/O3?=
 =?us-ascii?Q?K/guEnJaKZxTfh4Qkl9P2za1yFq0KiV+hx+1NwVJgP10ke59v2p+LXSJ3Q7R?=
 =?us-ascii?Q?FnADhHXquvAowj7fEpV8O0SIYWxSRxx+IO1LhBTMSzv9ur3y7QTtQZpq4kqw?=
 =?us-ascii?Q?X8I3cWjDka2caivRsNnArkdeKag/dd2ijQV2FiodtDKANRUsbilnJVKU45jt?=
 =?us-ascii?Q?+iVf2W+42UcBoItG3u6tHgQmh4UtWo2pxn7iyNUqE1Z3nf72D0WVKgmszX1V?=
 =?us-ascii?Q?tpSqnOkvt1S4ldb3eTTmkMJw6JMsu+3ps5LPLbCc+rVtpgqxPr16Pb41sTQz?=
 =?us-ascii?Q?BTvp+FnLaKnR0m8gWfEgzoZp0oOi1bxg8QMs65kss61PuhaKuWRDJpTIo0pe?=
 =?us-ascii?Q?aOJjzTTESw0QjOKnpRNqCavVfdyeKyrS7trGB27tR41gnREwl8uXcahq97M2?=
 =?us-ascii?Q?IYbjz2ezV5L0Wle1uWo+qHa1B7ObHBIt0rnaOSUrkgtZoJ7UElnJP8UBt6wj?=
 =?us-ascii?Q?u/ibRXHPTgtI9kw0LR2D6DS5Y5KYSWaMRxh54NLU4HYESkitG0tS1pHhUwLb?=
 =?us-ascii?Q?Yk1HM5yTlXEcrlqc7QznNiDx+pS0ycg4s+q2AskT8ilMEE3pwLOcd8SEQ4cK?=
 =?us-ascii?Q?AYUEkBnEksfB7EsNQxhafftZrT3qTlC4kcaIfefs4XiOZWkvWs1/ykYWRCBw?=
 =?us-ascii?Q?zuhvXuWOYo5AeJGaASwtAtHKKV8a6I/PGXK7jRfIi3vSrgf6Bmw/Nh17AjCi?=
 =?us-ascii?Q?ddUtPyG4xUDLFkKD1+UvglRHPuhk8nBJ88LLA1r2+7h8HXX2DFxCJwlUyfZE?=
 =?us-ascii?Q?aKSDFeREofYN36lCAK2UaFaPHK2XBQ7qqJfsQwSAmgbcx5u3NjTpfLUinPUm?=
 =?us-ascii?Q?y0PGUQ2eC8uiqR2X9BpyrQoUOUu7Bd13Zhmj4pYNAnkDiFfxyL7m7Olu+cjL?=
 =?us-ascii?Q?LAjLg7L2R4uJm3IkwT4Rh4iS8QGkmsvXO1YgbnQoCMsOLdgMXZh/dBxHJ7Yr?=
 =?us-ascii?Q?itr49d0CPp88gktVPnzD2J6uazH3OPUlebREDF4zo8KNzUVKY2jt9P3IbMkZ?=
 =?us-ascii?Q?RTSy/EgZOiGRc1t1mfRKF0nivGWDGc/0P7aTdzyGZ/iq5h/xGiOcFcF1xvpq?=
 =?us-ascii?Q?40CTlooL4/EONkeaorZMWL9VNiNoaO+huaBR9b/yV0lSBM5pr/B0SSiBPJ3W?=
 =?us-ascii?Q?UWd8iqHIAVuwoLJpay75WkUrWI1p0Xaj2grGDjkyrlTqlmbNXHDieVpLgAA+?=
 =?us-ascii?Q?ce7sBRg23o9c63qWieK5OXPAQsTQ3XDrXv69ZpCX8ewyCe9PNHEAEpQfE7Nv?=
 =?us-ascii?Q?TjiUocVI0YZ3fhbNElcq+j99pSWDk8biwIwX5WSJ3zpk32oHZriC5tQu/kgt?=
 =?us-ascii?Q?ygNhOTsKA1tWSDBsufNyGGnCjrl91QfJ4WXyHQ/dtDRfBcwHo+CvKlz92c6d?=
 =?us-ascii?Q?Oj/b6aRvharo8Odv682hbVk3rtlISdMWCjKXiJ4ot/k29/0rMfdYMIoJN/7K?=
 =?us-ascii?Q?F49H3U1NSRoh423Ti1mWVtGS38VaAQMbj571B/ZyhQ6UAG7W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81f139c3-ac02-44ad-66fe-08df0aec5f6a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 01:24:04.1260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szBZiJuW4B5U+brVPCjjBU68P/y0E05hscp7/USCLLMLFIXwEBfflJZDVQTcLGX4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6001
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4EBDE180004
X-Stat-Signature: ncdzq7ydcaq45f5scf4bg387yrpapxdw
X-Rspam-User: 
X-HE-Tag: 1788571448-858101
X-HE-Meta: U2FsdGVkX1/z6t24CdJh8kxDnVfF3SDf3CTx19kW2yC8kEHLGuCxKkqL0l0eanRMXgF2HQSx6EBzCE6DcMzmWhprNYOW2lHh48tIG4GWE/fRL+PyINnmJRUoSD6DBQzD9GCkiFuej2aowG5QVD8geti1iobibZowapkr/jYemEpxeBhY6xWZ6ZkJ+jq9v5N/KnDAexkYZfWan/FCn+hxOtkbwIAf/CTCM3nj6xeFloP3fJ662LN0C1BBgvOZTcJWUlYBIUnZ9Ifvq0l/5EcrxX4+Gy/Fh+opv104ziSJSJe6Rk11Iq5s5wkPMF17BCq2qQQ3eCp3lKgKZeY7bAEFeYDKWZpKtFaODz7Lndmc0xqsnbUWsWVebZWb+UcflnbxN+uKCcoFw3KBqKX/7bnurCK9AYUlqlhdhGDSooQLUBeIBAUe9pFDL4kcZ1qzc8fmg0kl+Uj6py/kCI4xTDfeSFmhwHMMpMULYE5POLA+kBySXKDC2SV43tX2IySSAgZYRE39gJQowtemLAyqPcdbdwOfEAGjxAkzSKzySI61Om8wQwaFWHVNObdwfkmDHs2wDNGx4IJ3m/tzYZpHhDYlMfXK9Dg2hQQioc/9RW6mzQzltAdQGIn8OWc9wZjve0c7wexWn0NWBtY+nslZlDWi/lrnD/dOcTJgixBzR0AbjyoBQKl3O6m+YNnPjKQJa6TdrfWPhSLmNuHb6vqbR2MgEkkM84Z7A8Swy9fDlzIzfu1nRyHnRbuVBYTVBLctixAXWBQw0XASefTomb6OZnhkyuDFFYyYWyq4wzfFtrGo1oq6NhMKAnHfgbLIVAz+XRXh1goHIMH73iyHdxItRjfZZBFxDzdJwL+SA4kBTrv6685aKvNaSyxTQmuy0vyTy1J7YOGm4aR3xpZ10Qr9q3Kqlfl/jilqYFq4YvQbI81Xg/1i+cuO13rvv/P1uBkkARtQu+9IRNTTCfRuqDhG92Q
 ZkG4iXNT
 nW4zkgmZGmoKmuADZstTCN6nk+29kFISysbGYuzvxtKzRk2XvsrdmzqVbZdnQGWZeGIShMUok0fMLoSH5UQvUSVROpx6hGfDvY0BYvh1sNvbSOQwCXCbZ+oae9najCJiLb7ZcO7kAHLVwxMhBvZAocdaOJ+UHJqEKnCgPFngWVHe4Uhx+6REzdLCj0LMr8yuZyh+jhXoMI8E59VTr7ltWCQWnHHVZLdckxGB5LaOWJCJ9dfk4fVNlkkkNfyCZbe+Uv+0XyUjD8JU70ZjLezQS4vkqhWhrqJ7BGLBROMOIO8z4SBwMVrW/ZDIlBiIYLXSY0QAP+E2Lik9LKjtwnKyukzH9L/AoJ7UJhNniIkypeoy/O7SJAhiy03EpYHHr8JQzQVLxMmXB91MqTyGQ3r2gdfrDdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 10:24:21PM +0000, David Matlack wrote:

> The proposal here (which is inspired by the KVM UAPI) is to ensure every
> LUO ABI struct has 2 properties:
> 
>  1. A field to encode options/features (e.g. u64 flags).
>  2. A way way to grow without breaking backward compatibility (e.g. so
>     we can add new fields).
> 
> Each flag can mean whatever it needs to. e.g. It can indicate the
> precence of one or more fields (i.e. new fields in the struct), or it
> can mean a field now has a different meaning (i.e. union in the struct).
> 
> This would enable adding support for new features without breaking
> backward compatibility. Downstream users would have to ensure their
> kernel does not start using a new feature while it can still rollback to
> a version that does not support the new feature.

This was never the biggest problem. The main issue was the functional
behaviors of the kernel that cannot be represented simply as data in a
struct with some flag bits.

Like for instance kernel A supports memfd folio sizes far larger than
kernel B because we fixed MAX_ORDER. You can't fix that just with
simplistic flags.

Jason

