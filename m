Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A849D5CCBE
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 10:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE0F6B0005; Tue, 16 Dec 2025 05:29:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA52A6B0089; Tue, 16 Dec 2025 05:29:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F7C6B008A; Tue, 16 Dec 2025 05:29:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5276B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:29:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27A6A1405AF
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:29:32 +0000 (UTC)
X-FDA: 84224962584.17.3B39D6E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id B4418C0012
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:29:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RfKYkdV2;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ty6OobtY;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765880968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f28tZ03Zxj6GNmYMMHeAY8j788ocpK25JxTtO4rzR0k=;
	b=twMDsHyitD7E8oK0dWuO2chNvdprd8+/2xhZFjzbMFIIuIv666Ner7Z8K6qXlPn7TwV08H
	VJ2dGzANiZlEvgrQ2LyuTyRR/644F3gcmL1sQsr0Wp4RLZDnKm6g2UzqhfQWMM0zqdPSNM
	mWhxD5g9p+qEFbFkQSbHQx9hSVWLcEA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765880968; a=rsa-sha256;
	cv=fail;
	b=F1EPC/arSIbrGnl1SSu7f47paWQXspjlH8la4792FOoffmMq9xZPNjj6u/VSFLfmDcWfqO
	4E+Auh3VUandaYXj0248U7IKZn6fFzazaDmIgD2qfSOGyIw8TyTfQQT3+oGRKFHWM9x1x4
	sWiOVhV8kug40Ptbu/fYPQ9oqqsrPGw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RfKYkdV2;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ty6OobtY;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BGACTCK108338;
	Tue, 16 Dec 2025 10:29:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=f28tZ03Zxj6GNmYMMHeAY8j788ocpK25JxTtO4rzR0k=; b=
	RfKYkdV2LWnrZT8DDEgEbHml449hww4QZyi9HCWKF/xVf9pKnO4j9OVUAZ5ouiDI
	4c2U9+l/7iZ0CtbO1CW1lhUKjIsQMDRo7eKtDobuApuKnVkIsK7ZcgGhqor/yZLT
	A5Of3x9qetmtbZm68lsFX6EgX8vrXvbq8lHlK9ry/56SLdC/TVCi0VB8NOkOZHDD
	LncSV6MePmgNCilk6hFm7tMdZ3u0kB+2ptCS+wJQDnZ3x5SZN6BiilHhuO6jsXFf
	ao0y80rBGCLJiHBzNFSFJHz0E+wTmqLCJXtGHwfeOMbJbjCKteX4c/j4VKLmrGkj
	C68O2H73/B6WNozZTVTMmw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xx2bpca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 10:29:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BG827MG025211;
	Tue, 16 Dec 2025 10:29:16 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010016.outbound.protection.outlook.com [52.101.56.16])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkaark8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 10:29:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lUrEJDmj+GkCOdJD8mofzOlkisBMdkiW9w/abZsKQE6SyajUZH/A73vc07WEESXLMkO9dmlTo8IQrKQnH15UXNKUKyBBTKzlGwqq6mkZIR63mLndqXmJQf4GScP0fptZl/g7E7VCck6x9n5D1KCKmxVxfSEg3xwaxeq/k8o1MTWu9xNNKLMVHLEQ2zN2avO5oJSiFVjotHDSLlxPhUjvlaJS29zBXF8vOH/2aT1aXEQQBW67aOwssIkMoq1xFFkrpBkHfJ/mq3diRT/MRiFWq6B5RECyHyrFGfZXlirjmMJ+lqwRSyJuV1yFol2pAgtJvR3yWpPUqH/GG18leWKDTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=soYNotVCcwXNve36lHxUozslbqmW9NqOjNJ6khYQrxM=;
 b=CfngiGfGmfIrA2dPx1YTeCLFIWQbZIWkm+hzQoShjc2aS6zv/7Ruo5C2sLZu7oVzNN/b0A/D+M+lbKE/kNjyV7NG0ucu1ransk/K6px0usmeahvZiZVtYhMBKe1wIaHuSmX41sGEXIfjeAGQt27MQWZwJzVw3n9i9KqBJmgpTEvS4ZicaQT1S1ldoAg/BGX0lgZWk2KbwZBkALNqZ17M82XXm4yxY0yolL1Kc1BloVXcnjWwar3QN5RNUqfQmbii2yy6Wt6yVXdru4wT0usVcFzhnKk+RsHi8bR04k2WIID0h74XrdnMJXbz7vOXPahkhUlHnIanwmAnG2pgEGsQrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=soYNotVCcwXNve36lHxUozslbqmW9NqOjNJ6khYQrxM=;
 b=Ty6OobtYaSRdcbZ5///JQKEopFUyaNL/Dwr+zQ3DEwnn1TklqnD8FBQ/AWTVKjMjiLiIwJJze76S2pnzbxPUctJkjOLpWoXbMmfmIVl2omZ5sqyGnWM/bwSLT2hZi86vpnaUSjYCUiq5uhGH/jLJWgTzMwNyj1TsLJuFQRNhdmQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB5062.namprd10.prod.outlook.com (2603:10b6:408:12c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Tue, 16 Dec
 2025 10:29:13 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 10:29:13 +0000
Date: Tue, 16 Dec 2025 10:29:13 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Samuel Holland <samuel.holland@sifive.com>,
        "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
        linux-riscv@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Rob Herring <robh+dt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v3 08/22] mm: Allow page table accessors to be
 non-idempotent
Message-ID: <9eda3825-64bf-47d9-ab4a-0a536b2d6474@lucifer.local>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-9-samuel.holland@sifive.com>
 <fbfef7fc-4030-462b-b514-498eea6620aa@arm.com>
 <c2597d43-d909-4259-bb5b-9294e4069385@kernel.org>
 <af8fd275-a34d-4b2f-8834-9c85dab2bbae@sifive.com>
 <a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com>
X-ClientProxiedBy: LO6P123CA0007.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB5062:EE_
X-MS-Office365-Filtering-Correlation-Id: f5f872e6-cc2c-4f15-6270-08de3c8df528
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?57PTSlCWWeEX/n/SaXjOAHIAHHh2XmOT8zOktFI1hLiSVewDuJfsK1sqV/?=
 =?iso-8859-1?Q?Ui0ljygh3MC7kN4tkjgUUEUQbvIyXFK63ZUFlaEod/HyquQDirEzo5eER1?=
 =?iso-8859-1?Q?C50m64/uAT6eHB0pIJRGocFNBdM1X30eX1aagiYa0J3i/dHgh1Ymk4EaEc?=
 =?iso-8859-1?Q?WdHAkXfiKMpXTY194fapI+W8La8TnJZYegVKSN2EcBikBC4PYHaBRKWOwV?=
 =?iso-8859-1?Q?umMQyoSzWLvUNauAH1K+BbrpnLL00aHtBfbaueuGIecgHNJzc04mkExnQE?=
 =?iso-8859-1?Q?i+QPqLaa9lXN+7Wp0TGYeAaZ7TV3tq/o4Sj8JvJHUepaYyBPZwV6Bf3EOc?=
 =?iso-8859-1?Q?EfklrFy0njFMMa1oi543bTiKTws5Hd+lC9ezn+PoLcENGdgO7jksmntewi?=
 =?iso-8859-1?Q?OUps6dHdA/dxHyQnKfhc2xXOQO8gi+m+oaCCFs1XGaAP+96hIQqpiG02vP?=
 =?iso-8859-1?Q?rKCepiJPHN6d2LMfoAziXqz5hiouRX2d0CZJuI+q9ifL8BdKhBtF2NweJC?=
 =?iso-8859-1?Q?VpV83sSk3I+p4sP5DPq3gL90q6zK85nVVcIpxfiY0WkG2d2lWhekiEXzxD?=
 =?iso-8859-1?Q?q0I66eO1njerbVGS0ALhAJviepsYF4Si7nkebKU7/jPYcOGdx8VuPhpyW0?=
 =?iso-8859-1?Q?1b7z862/p1AEHPTI19WJMbiw0eoE64Te0Yfbx/Zq6QtQaftLEDGdhzN5l/?=
 =?iso-8859-1?Q?lEyn4QDOviEn1PsBM9u4WzOVyBJvahNV+RIdDTI1Emz/V5XI8yxsCthIXY?=
 =?iso-8859-1?Q?pi/gFF4H9iuVWHfYKiPQdxok2l5PkLR8ogvQC7+jWa0zWiNZOz/d2eUKZD?=
 =?iso-8859-1?Q?I/5ynuvn5GxX4FJloCWgZTOo2U2YyBBxIUufOXVLhduzbUZmVMMc0yRapA?=
 =?iso-8859-1?Q?G1SA1FCnlm14L6yacDy7uQFa/xH2tiRum6orYG4gb8usxccS69CP1Ey2j5?=
 =?iso-8859-1?Q?/yQPnC3vWN8i4KRULIiuHSEut5bLMfGkfNNvcsiwq8/FakxTzz0TqApdTV?=
 =?iso-8859-1?Q?S/lE3qXUONe5UtWVS1E7+MrUQp5YlFJLzIyPOw4993dmWIpBvgJjlBK5Jy?=
 =?iso-8859-1?Q?I9WWkfAhfK9oQGnWM8mYKMXdHy5Ad8Ck9NsyjiorJm+ZXGgoFw2zAxSG6I?=
 =?iso-8859-1?Q?+rwXO4U99UPcWFfOeypckmucVLpjFBLVpTA/7e03bAtq7cvYfWGBFgB3bO?=
 =?iso-8859-1?Q?oQ8R/h3nLlhHnzZ+245Oe6vh1jk1NwE847KiqiLts6nqVbutm6gYBu2LZN?=
 =?iso-8859-1?Q?ihf/in0OQek8A6eFNPUcTRGh3XlR6bC3PmYlwql2nrV05oUpsaBzGhZi59?=
 =?iso-8859-1?Q?Oo+sSy4uJECz92iPN3E94Ej/V7+Q8PtvhiP3cXn/OdEWmabmAD7SCKsPZN?=
 =?iso-8859-1?Q?PjDcSbPIU5Jb91qOnIxlJZ483o7f+53ClmerWSETBOS28EDIsUCjhWOh7I?=
 =?iso-8859-1?Q?pzYVz9+a/I1QHbmvcTBD3qjWLCCxGmJeeTxMJvuHKR7mRVQev4lp1aKOjR?=
 =?iso-8859-1?Q?m073daPH9bqpH2hVeoQ00R?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?Bl6WtUw/JjEwk4gqFoRIMEpVa+EHjlXSgKX1/VTHoE3Cqb1QIchqGKChV3?=
 =?iso-8859-1?Q?SiKB0o5l+lFibmv51YoNLrs6riHFLT/fiN8tHBa73jGPQ8l73QGwX2L7N9?=
 =?iso-8859-1?Q?G5cGmj1iJoOxkETqRtz4hA7Jyfu23k+/3zxGyUaByMIM1Xwx4E0mSJiPar?=
 =?iso-8859-1?Q?lMVek7GUnhm0XG0aUtUb8hPcjajuiWiLpO/9tW/2TE9YeIr7uZi1PpOJ1P?=
 =?iso-8859-1?Q?SgXSV+MbknDOgruL+t0zODcXklOfVjGXyF4Hx7lGrqgIqlcxKbUnUJhbQT?=
 =?iso-8859-1?Q?89k4IqkgvvrSaICcZgUpJAIdmh8eu86D3o/hJae1DoLYXi3db0af0XPOCz?=
 =?iso-8859-1?Q?C+gMVQ31vHsseemKtdOMGUrO6eP5BfKNVII+7DzvuuAEzTpyem5ssQ93aI?=
 =?iso-8859-1?Q?w1bJ/gpTcOgDr8pO64HJ4oQRNTvgKujGCrE7Dtf8lv5UpYYfHogRqpfiF3?=
 =?iso-8859-1?Q?p+rLElXQg0C5+tp3J6U/p88dlfJB66bH51s+FL1J8j33vOo5p08roggIqs?=
 =?iso-8859-1?Q?i0khsJZJuuKdrr/ICgnJjWBEFzNc5XVily36Hciz5G0J7k0jq1qPqqpMl9?=
 =?iso-8859-1?Q?sRgLuBLuTTtyBqmUihoBLUp/4OwdlUpPhXSNQ2mxH8VeAlzgImAMO6+vki?=
 =?iso-8859-1?Q?KXfaP5UjeYn3Rojy13V+l/5J+En8IS1QxDZC6e/wtXUjhF1544pgsmQfRq?=
 =?iso-8859-1?Q?0RjSENXm2BSDB8WKOx3BnOZdtpCNWwTOmiaGJtDEHFKfhBZkLpkY7EDpwE?=
 =?iso-8859-1?Q?13WUNXopllIYW7TLXSNwnaPE5gdAqbJBBecWcU7dyXLVUrT0yBh9+dEDIO?=
 =?iso-8859-1?Q?cgEh/zpiYKkdWPi7IgKAtPoXJWoRUo9xOpecJS/jnc+sIQs04xF5hHoGD6?=
 =?iso-8859-1?Q?0EoMnNnvaaYnid4srhf44MHzKlARtN6/spYEaxh/JF5jxtZLbAHu/K/MZQ?=
 =?iso-8859-1?Q?K7TRvnmCm9/rBeSpeEwwyQNbgTjqDuy2YzB0AqpbhP1lVFI43nLqYRkdKB?=
 =?iso-8859-1?Q?Z+mbkMJ+J8141SdyMsH+Dl2ygJi7XMf0YZRyxe43JYcYWHS2yzvoqLAuAZ?=
 =?iso-8859-1?Q?Pyq0PDpPxyeFzi19NghDm26ChS+cGc1L9MMTpPdqYDmNj2H9gUgP+rOYtU?=
 =?iso-8859-1?Q?aJIDxrwfxKo9z/UtwGfn4WEJ9dJBfnJYcXdnKf0qC+qf5sVX/AhJ3IXjKP?=
 =?iso-8859-1?Q?wgDaLqKZpw3M4HrtvH3sz8WU3XiyvzdqoX2a+ss5Rux4VXgiZ2GYUtQmOX?=
 =?iso-8859-1?Q?D6RFiSyoKc3IVWkvzpxbhL4ucHAFhu5bDWl4sVS8eofTcxucdGreLddk4x?=
 =?iso-8859-1?Q?RYT9S8Xx/1PW9NiXfR9FDkNLJEMemBGRHmiUZfq+TjAf0Fow1tE1Dkitf/?=
 =?iso-8859-1?Q?zh3AL2XVkluydXLyUgZ6zvl1T/IlkZkc+BQvE936kUkN//8rEXWqFqZrVG?=
 =?iso-8859-1?Q?F/imO8xB3y6dT7uFD+bakSjwVeq+ZL/hqj4zafJPmsG6ldr/t40N/sQG7Q?=
 =?iso-8859-1?Q?U544DKGg9LTQcLOo4TCKKaK65vAL1Jqak+HlgdHDQj9vkO0scZWr2tu5IQ?=
 =?iso-8859-1?Q?TY3UDKJEtxsDUaeV7hp49FPhaJLW6aGG3yYksoI8//z54KAjmRpjmOELso?=
 =?iso-8859-1?Q?vd+UFhiieEt4bHYFVs6p7XgW7peEcxNvkCTlp1TSyfLg4FvyQ3bKX0LQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9LGOlK21pSydjI2fjwDCn3kg1TD/BO1yqICUf0wlgQu8yQhNXHqg1hfzXCqWb0d/NVWailvHwE9wkS7V0BoA4UnYYSasyB50GXD96QgkN3/RFjWHP5lwOejDDmpE8GaQue1twXiAj1ZGFLN/wCR8GoJt47zWWGtmWDvOH08z5+gJw8qS1JDwMRZLfPZitltFHo6IqRYTme9rDMI4+pCQpJqO2GnhTRNMPFWLX2pAOMQlQHJ5B+D3yW+CWeCM2GWP9G8i17jDoRS2svv9tPOZSUFLE+yyCj6iVT6krVsY9GPlByAEs8jGIj3jSqZu8WcxzuDLU5Pg7+di9kiHbvI1KCSt/PdzfHHdT3PGu9SyTIR0jNVSdHA0yiiqcSue9KtEoFQ7Ywkj06SXAwmVHzqSG68eqsTFcuTCXM9MXU7dAm67LDGuI2m5DJAQJerT+SyQr/fa1yRx7AHtTyemOGHNxIACiVd8NCXlwqeIEpPqIRKJBp/kaFivne8OuAzOxJqZzOB6uhSOUjVtjU5AM/oDbkThOWxBRB1fksZjHIS9bS53s3gCs/ebYjJL6jiccMLWsOjSugqWkUW+5+lga/dYdi4pAlXMao9Bzb88KnzphwI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f872e6-cc2c-4f15-6270-08de3c8df528
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 10:29:13.5351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WMYtge0W6LsPt8uUl0vayq+5hNVX8QAcEzKXoNO3o2HbAJJSiDWvXHV2SgLeaLDx15MOTazpTfSrfMVyOQGtafak+ChPAciAN1m3hKYdYi8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5062
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_01,2025-12-15_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512160088
X-Authority-Analysis: v=2.4 cv=B8W0EetM c=1 sm=1 tr=0 ts=6941347d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=wWuqYZlNnyJbCNu8OxQA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-ORIG-GUID: b0PqJv1IrcYH6jw5kAKCbFLpXmODzn4R
X-Proofpoint-GUID: b0PqJv1IrcYH6jw5kAKCbFLpXmODzn4R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE2MDA4OCBTYWx0ZWRfX1MMr9AuFc26B
 C+gEd2jQQL9rV4EeRYrEUPfvOFyTbRqnhH0UUfiZtpaPLNCT/vkkjV71PE6XQRMlCDOTbVGgPXP
 qb0geQbX03TUnbQdfeM9hC7DYZWj3sU/IFwXYp8pBs/ZTJhDm0TnZIsjUlmtN25gxzgFA8ubCqO
 vozUFgvCsXw+Sh0RxnVNkiK0V++r6ZWERpmB3KQ/xkx1IJl3k9QgXAgorKHssU+tkm2SpL2AuCN
 OawU+APgm0xX1Xd47ARipJdhMraH1mnqGNeNc08WIPcWMjPjIXizmMlNwguUxBxZ7fUI7jLldjp
 udON8OfXt9S8s19YIxqCxmT8oBjlY0VSXguJSZ7XSDRym3i5lC1MpGKgSH5yU6v0yFnlYPiZTmW
 HogXlRAFkf14+6IBSWmpJnFxnTANng==
X-Stat-Signature: zo8y39dy6bh5smefd67s6j9p3fmsikd8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B4418C0012
X-Rspam-User: 
X-HE-Tag: 1765880968-642361
X-HE-Meta: U2FsdGVkX19W/+QWZNtuuAjSQPzWkrAmAR2FVEhPvvveIfW5jxBYL35MLIWnAUrr7R9UXMqzpGUwlj+KELrT/tVpnNHyskRH3begUkQ1lvwiTbhKejsp8mRLPsV3jOpy12eBeIop9pfac19hfGKyavZNXD6FgpZl3MhcoJLgENdWOATEzfZ7NLgIr4StEfxDr8leCocLZA8Y9qp1OdQbshkI3Wi0jRbnCKpqLzV0vN3vP3D4aPCVmCaPXydX5rega8ITsC+AHGFn4RX3DlIrODiMDC/i6U52I6qm3zbNHh5CsL1YtQLtzLnZfT5m0w+nP8ei49c96I8Mh0pTG7WyZBa+Yr4+KMTVtkdCvxT6QQ1K0EzqdZqwmjtzgK4T5/ZMSe12kZSAXAEC39OFLBPOLsNJNTBulxwNypuJSKf3uEN0sBpTxVrsOQrfJp9c9IEFYBZJnw/1mm5q3IRrTwBDWVNoSqePRbdQNZOcftxXD7XcuS387i02CccjaKNxNQ/YuIJ6D/W1oD/53W4YC3rJZAiskSB9xG9E3/XTq2ndrZHYUP+NhDcXrzdI22aCBEHj2YIbfU6s2UMDCLQEQrMgwL5PEjiqo+ZaR5+oaSeW2ashxfvr8IJ+yp1iUCWwjU0rZPH01xRZ9i1Lr1lxrs3omkZJRMAdmDd6zq6P50ZvKb//cVvHFhGPRIZFtsbMgq+vgSVUTAMj1ZrbNTRGmjSRB3tz4I2lPoZ6gBQdgWzN0MlQ7zWbX1H+gi4K3SmIbbGT8bOvxGMas8aUpMdFfzqqf5pr96WBo8VYhpj+WkZp3WMaIGZHtO85Opo4MTmZSmM2CoiWNRzC/SLPf18HnOgvtbhqadIlwKgkL8YmFx38+xn7CK2Ke4aMwJP7m6rt8ckwSswF1LCUUNqVjauMFRmbb+BSJZqxzRqSzk9J3eBhy1eTbqXhuQAZbz4qLB8wmb3nSWk2QiyXOfeaIekSEqD
 PC3C8QMM
 uXHmGqIPSG6EcyA/UM7NdvHAUz1+A0ngUebIuSA5ungAhBGXuifvi0vLo89/ly/XPwy5bWyVSr/WXjcs+rFQx8X7H0OCjcKwcy9fk8Ttxub4D/BESWbtvApltBbK/CdQklJk53JtTA4MdQ40kzq5F/y7npaaEnPsKXT4Oqs1X0NsEFLI+sbFvODPrvfvF/pPqQXV6J0n6U36+Ep+0dxRZ6G3uAwePbLwy0dSn2MU1OEjQlT5gM6dms2iZECtSY2/Ign1Gb2cC8f36xuTjXIz02GMov+dXY6fHiLwe+oUozGSl9hp96bnX/9HHWySmdaaskSFrnbScyJ+lc/BXxT3tndClbSepEht9JxH9RKTxEUh1dLZgRoKY4UCaNWznMZqO1CntZO7gIQx2z73KYzCl4EXWs/egMeTtgB5EUH90L1FMh7fOy77d4l+m+zCv5ITE8uaA+tLFhdgUrynHpdCwxDLzzdwECXK0Fjkald0SLqhnlLcko1lK6Z6nwYrt8GZFqPXOhMm/wmT2UqUR15wNYB9JjWTvIMYjMeTsS7xMdV0QSu98NWZIyw0onCXfSkCCSbdR8lh9JyvNRGQZFRP1/Y/VjLyzAaJGtci4yGjwXIFNjiCLVJ/jSP+sK8OTPCTQglCDXMewwPs7PtSnx6E2zAFIPcMqYhrf0VXfmbK5LGHgDzoicj6avYhASAjzAhnHt0IjtVTxocte9NnX9xX+gZ6l9AcIXTtGxKWaS+d6DOhh/qgJWH6U4MaQi6ph0sK3CSJLg6l60woLAo7H1d6bky5zFTT/1jbGWAB98w0UHE4jFyZ0XoxeipNeHym7a4ac1xeu9fzfAm2xXLoL+jUsUbK0ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 01:59:53PM +0000, Ryan Roberts wrote:
> On 11/12/2025 00:33, Samuel Holland wrote:
> > On 2025-11-28 2:47 AM, David Hildenbrand (Red Hat) wrote:
> >> On 11/27/25 17:57, Ryan Roberts wrote:
> >>> On 13/11/2025 01:45, Samuel Holland wrote:
> >>>> Currently, some functions such as pte_offset_map() are passed both
> >>>> pointers to hardware page tables, and pointers to previously-read PMD
> >>>> entries on the stack. To ensure correctness in the first case, these
> >>>> functions must use the page table accessor function (pmdp_get()) to
> >>>> dereference the supplied pointer. However, this means pmdp_get() is
> >>>> called twice in the second case. This double call must be avoided if
> >>>> pmdp_get() applies some non-idempotent transformation to the value.
> >>>>
> >>>> Avoid the double transformation by calling set_pmd() on the stack
> >>>> variables where necessary to keep set_pmd()/pmdp_get() calls balanced.
> >>>
> >>> I don't think this is a good solution.
> >>
> >> Agreed,
> >>
> >>     set_pmd(&pmd, pmd);
> >>
> >> is rather horrible.
> > I agree that this patch is ugly. The only way I see to avoid code like this is
> > to refactor (or duplicate) the functions so no function takes pointers to both
> > hardware page tables and on-stack page table entries. Is that sort of
> > refactoring the right direction to go for v4?
>
> From a quick look at the code, I think that some cases are solvable by
> refactoring to pass the value instead of the pointer, and leave it to the higher
> level decide how to read the value from the pointer - it knows if it is pointing
> to HW pgtable or if it's a (e.g) stack value.
>
> But the more I look at the code, the more instances I find where pointers to
> stack variables are being passed to arch pgtable helpers as if they are HW
> pgtable entry pointers. (Mainly pmd level).

Ugh. We do need to nip this in the bud I think!

>
> I wonder if we need to bite the bullet and explicitly separate the types? At
> each level, we have:
>
>  1. page table entry value
>  2. pointer to page table entry _value_ (e.g. pointer to pXX_t on stack)
>  3. pointer to page table entry in HW pgtable
>
> Today, 1 is represented by pte_t, pmd_t, etc. 2 and 3 are represented by the
> same type; pte_t*, pmd_t*, etc.
>
> If we create a new type for 3, it will both document and enforce when type 2 or
> type 3 is required.
>
> e.g:
>
> // pte_t: defined by arch.
> typedef unsigned long pte_t;
>
> // ptep_t: new opaque type that can't be dereferenced.
> struct __ptep_t;
> typedef struct __ptep_t *ptep_t;
>
> // getter/setter responsible for cast & deref as appropriate.
> pte_t ptep_get(ptep_t ptep)
> {
> 	return READ_ONCE(*(pte_t *)ptep);
> }

I think we've got ourselves in a jumble with pte vs ptep vs pteval
vs. etc. etc. and we aren't always consistent with it.

So I think we ought to put 'hw' somewhere in the name.

And we can also now get away from the overly abbreviated names given we have the
chance :)

So something like 'pte_hw_t' perhaps?

I like the general concept, though I think it's kinda gross to hide the fact
that it's a pointer in the typedef _that_ directly.

So perhaps be less horrid if it was something like:

typedef struct {
	pte_t *ptr;
} pte_hw_t;

Perhaps?

Then could have:

pte_t hw_pte_get(pte_hw_t pte_hw)
{
	return READ_ONCE(*pte_hw.ptr);
}

>
> int do_stuff(void)
> {
> 	// value on stack: ok
> 	pte_t mypte;
>
> 	// pointer to value on stack: ok
> 	pte_t *pmypte = &mypte;
>
> 	// handle to entry on stack: not allowed by compiler!
> 	ptep_t myptep = &mypte;
>
> 	// handle to entry in pgtable: ok
> 	ptep_t myptep = pte_offset_kernel(...);
>
> 	// read value of pgtable entry: ok
> 	pte_t val = ptep_get(myptep);
>
> 	// attempt to pass pointer to stack variable: not allowed by compiler!
> 	pte_t val = ptep_get(&mypte);
>
> 	// attempt to directly dereference ptep: not allowed by compiler!
> 	pte_t val = *myptep;
> }
>
>
> We could do this incrementally by initially typedefing ptep_t to be:
> typedef pte_t *ptep_t;

Hm yeah still hate the idea of typedef'ing this as a ptr so directly.

Obviously this would make an incremental thing a little harder, but could have
this stuff on top of existing logic and make it incremental by changing logic
bit-by-bit?

>
> Then we could flip the switch arch-by-arch to enable the stronger checking. We
> likely wouldn't need to convert arches that don't care.
>
> I think by doing this, it will expose all the current issues and force us to fix
> them properly.

Yeah this is nice.

>
> On the related subject of conversion to pXXp_get(); I've been looking into this
> and personally, I think we should have 2 helper flavours at each level:
>
>  - pXXd_get()      optimizable by compiler; defaults to C dereference
>  - pXXd_get_once() single-copy-atomic and unmovable by compiler

Yes!

There is some _real_ confusion about when and when we don't need to do this.

Though wouldn't having a typdef separating out a hw entry imply that hw entry ->
get once, sw entry -> get?

>
> It simplifies the converstion process, and reduces the risk of bugs
> significantly (go read about the arm32 issues discussed in Anshuman's series if
> you haven't done already).

Though I haven't read this series so can't remember actually if there were cases
where even with hw entries we wanted to sometimes READ_ONCE() and sometimes not?

>
> I appreciate this is all probably a lot more work than you would prefer to sign
> up for, I'd be happy to collaborate if we get concensus that this approach makes
> sense. What do you think?
>
> Thanks,
> Ryan
>

Thanks for this concept, overall very much in agreement!

Cheers, Lorenzo

