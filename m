Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B166CD339A0
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 17:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095726B01A6; Fri,  5 Dec 2025 12:53:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0459C6B01A7; Fri,  5 Dec 2025 12:53:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28CC6B01A8; Fri,  5 Dec 2025 12:53:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA55D6B01A6
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:53:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8AA231A027D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:53:13 +0000 (UTC)
X-FDA: 84186163866.20.F417BB0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 232D240013
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:53:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VIyxfep8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uLU1Oozl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764957190; a=rsa-sha256;
	cv=pass;
	b=dV+IPMubgbm/TKYfRrDd3JVytzvQwsCQ1cC4/FkCg1FFGHiCaARofkiGSVJPYB0wRxw92H
	oobTpGPOX7MKDJM8dQz7cdvgQOA0t5rDgA2WMPNQPvNViMv2zhounkyXOaBtXlKgOlQY6y
	YRybwYX0IiwtQjuSgcG0TvUjVPwejeg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VIyxfep8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uLU1Oozl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764957190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+nmWPVxkWJKhChLt9qIjhFcFcXt8I8ue5qico3RZsAE=;
	b=4b5pea+8bkEAd5D1CFv6UHmT6InSj7j7gTMpa6RfLgfR31zDt1xbYfXL8SKzIxuLqIA6O+
	9MHtJhDkV4sUSE8aEkuqHJR2oHf19LNgAy0hs5u0UjnIHYqOtCQ1BbFcPNDVGsRMpVZ1d5
	CC+bTlB58J/I8WMLJgl6KPtvs9i00JQ=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B5HIiFP143269;
	Fri, 5 Dec 2025 17:53:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+nmWPVxkWJKhChLt9q
	IjhFcFcXt8I8ue5qico3RZsAE=; b=VIyxfep8vz4P3qHfbVeUQp0vMXbtfGL3lN
	AbBgl0c+yUR4M/1dvhUoT23uWEF3AJH16mT756MaRFOcLVcKwEtf0Hs4PWYy/jpZ
	qgu0DKCQ+Qrx/IIWtG8Q3TwO05YTDbJlrUbmOI5ccB+oJkOMXaJUYBNRHf1iZjaa
	M632C1qNh7aG7nidS+1obgmF76+OYQoby+vhN72Az+jXedbfzdgLmIMpqsTzmZ5+
	RQO1YfRMCZvTgARDl4nW+3Np/JT0TAfO2Mo5BJwpOTmPnMGZJRtt3z05UpR9hUpY
	IlQCYwbEof08oSAA/oEwJ2BU20+r4LSEOsydf4yPRKfXBkUZOxGQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4av3nug1ww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Dec 2025 17:53:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B5GYcSF037920;
	Fri, 5 Dec 2025 17:53:04 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012045.outbound.protection.outlook.com [52.101.48.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq9dga6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Dec 2025 17:53:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OczVAzIjd+u5XGNk7l3TSJG9KhxkaPqa+baIqVssxWW8ubJY5jRXrgf44nfBcssP9JKVguKqBco3l3rJQLCCSGx95BYmbRpCh6gvQfMCNaEUNwWWhCLSYMQ0QBSno7HALMsGhEGr+w/decuc2EYIKOkURzUKd6L9lK1sIaw5cuLUl8LPqHog9QQP3Yc3a+ppthzpIEqc35hsdUv0GbJF5FMriWNKkkFGfvWZamvYmVTi7vLDlrxHD485aDvNnL+5TcZ8nNloEDflk9hPBwz/P1vIN0eSPaH9W/Rxq1n4uLoyAfg0yWWMArxnY1rR0jrgQgxV5Avrw+Ataoi4No4mow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+nmWPVxkWJKhChLt9qIjhFcFcXt8I8ue5qico3RZsAE=;
 b=jc4/FLJLf/sTVtqNt8Bn2r7jd825iMB4bHo8gEeojMgBq1aD1XWpyswhvJkF1qXUR1sxKaFxomuEgmLGBg5m356eyrwCI0oTqjmyMSk/KYuc2T/mIEXKgoAwGyMOdqvvfvxQwiPTTRJrF9kFLS0VJllTrlGfhIqdqLed4JFRJKpSLIbbGNzhzi2nBPJmfeHsQFq+k3VI7RYhsXC8uFY2kEDDaSFAL9xcz8Erk0/6whHGfE5bAj9/8b4zmFodv11iJB13NqLl/Os0tRXtImlH/pYi+vTiQ1rDy259x2Vs85G9okNnxkvPXBYeShv7HMmtzQg+D42zuHwSy7UF8c/SIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nmWPVxkWJKhChLt9qIjhFcFcXt8I8ue5qico3RZsAE=;
 b=uLU1OozlOinvMdasb67jIhONrEfp2oH0hXWNlG/xvQd0lNejJhUMD/PONvk6nCkzpzFs9KUX5c1P5Yb+99CZuBapn8UZ8WRGcjIeBXB/HdKP8tlhLjPdoZD76psZU60kdRKLRIlybcUBUTaT4lZlD+FsRwnXOygHaOgrdxh8SbM=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SJ0PR10MB4463.namprd10.prod.outlook.com (2603:10b6:a03:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Fri, 5 Dec
 2025 17:53:00 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9388.003; Fri, 5 Dec 2025
 17:53:00 +0000
Date: Fri, 5 Dec 2025 17:52:58 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        oliver.sang@intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <e2798174-7d12-4e36-9175-94e7e4789174@lucifer.local>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO4P265CA0160.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SJ0PR10MB4463:EE_
X-MS-Office365-Filtering-Correlation-Id: cc647fac-58ad-4cc3-eaeb-08de3427216c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?srF7JIIBGox37nHucP+gTuuSuKlGH+8gxoFgbQpDS2epIZXUpQxYDqjoUij/?=
 =?us-ascii?Q?kpdHHXcOeqNI1YHUJvUOtpIrzy6gP7AfVf2IM1w0C53re8btRkJFxjMR4gK7?=
 =?us-ascii?Q?QqtzuTr9XYPydGMXAyINagq0a5wIz2sDCtGOac6zlwLHGFfWegnmvloIMHLL?=
 =?us-ascii?Q?oJ9eIgYwwwG70xUQSoE/HUW60PzX+xguVHklJIZ2INbqOQ5i20JXMG+ZHZmQ?=
 =?us-ascii?Q?HYIG5AoSY2uQ4ORIbhDO1eq0n0EJPjf95XADCimeIPy/Qg+CZmVNNwC1L7i9?=
 =?us-ascii?Q?XLaKr9n/aoMovt/TRht24AxGvRk4AxmMHLnRWacswJoqnRor5mwWachTsx/J?=
 =?us-ascii?Q?xh3QSJRUAkMt4Eh3W/QKu3lHO5gcKJdV4ORP5yOf+VBPuSXDTzcU5Rj3XqA2?=
 =?us-ascii?Q?6/HcAqOw9k4PukGTja8OmfQOm5G4tG3X+3HbuH8758C7vl5PrgIM1Q0tzq5C?=
 =?us-ascii?Q?zE7Q/hcQsJxAuVFYnlson3ecoJeYE23aw66TCcfb2kcL4RP9/iyMd+DF8WFG?=
 =?us-ascii?Q?FbLUZfxFGlMc8Y55I2zTes8BmFb0KvsIUOJ20YTHzkYQbq5AXPWY9D8sZrw9?=
 =?us-ascii?Q?HT8ikh8rbtpPILHQAthSQlzE9gHFYb8p/ePkCpGk6nFr+PM3CLvvjczuxct8?=
 =?us-ascii?Q?1andGBEc+oslP5ILqjKXM4OgOmWPrlFk390KiA1dTNT0kGeE9Myzk5DcoS1j?=
 =?us-ascii?Q?UJLgxRJOHY4MBq5tSk9TrRKX129OJ8EUdheuqhFoNDmYMURERvo69dygDvnK?=
 =?us-ascii?Q?VUhHdXJmWHvZewcK+SAAnd+DDVziR8/V4S+NL/6AjqY01nOSVLvJP9VMl4al?=
 =?us-ascii?Q?LNNlMaDtPTmWV8zBKdO8wgRIUSQawU/z4qB1jsHXk1gVaJteuxpbTFEbPSZf?=
 =?us-ascii?Q?TlxTVUCBw0DHwd18N2Rya1OfD+SsAW+SzuNIBXFXly7p8+8bXcRHRD1GCNoq?=
 =?us-ascii?Q?pUbZdR6GDN5RLEXeBS+AAlGKD+GfXY8kG5Ymsfdh1VfwTA8HBR+FIibCbUgO?=
 =?us-ascii?Q?2a2RZZj2t3AxVK2k8D8qdXfIg97Q/hJ99t8UKZRMCzcDEUxML5PUbw1KH7+l?=
 =?us-ascii?Q?PO6FHsvA2Yra5TrlvTKGc+xdCvbxDJTc1sIJvizsU3iUWe7wgIV5csbsCp2t?=
 =?us-ascii?Q?qkvO03axeR/ocd7f0twhkUSZo2OCVVz/0+ImTiB9ijShuG/TQcudHtlYSURt?=
 =?us-ascii?Q?1lCGYCapBejeWlNPaUGSwSTqslzc7SNMpl76ZlIpR7KYFJDCjJf7qN0mxQNT?=
 =?us-ascii?Q?6saslwZQojGN6YKVu6+kr/dHem3Cuc1ovxIVEQe1QP7rqRLEKTqSyCxmBd0z?=
 =?us-ascii?Q?EQmVMBNgUOdan1Qsrh60z3nA4uRMquIBY1R8CqEWjcYxRz0OTgRdV/BG+lw/?=
 =?us-ascii?Q?UvbF6uxnTbZ329GzDZzijUjCqwKfrIHP3GaBeXR9mv/8LSyu9+4sGd9nrx8s?=
 =?us-ascii?Q?AOFxsymerJ9cVesKWsWrZjihR6BWn5PwxGaD/0sFYdU7Tu4FQdRfQw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0uPK+Sdlk4CZxBkJ4sAgeKefgq2anFNIAUoPeXcB25RoBmb39e17fXEWrVML?=
 =?us-ascii?Q?88zFEzxqXvO0FW3XxkRlKb7xQJoZn7A1tBINAp1OLVCUixnLTin2Qz35vcqk?=
 =?us-ascii?Q?e7sPO8B93quDtvdK4kOpG3yky1Pt9KiaaORAwotR8Tw5LBEVbgbr7iC4BYbk?=
 =?us-ascii?Q?JFFqEZRwj6+7HaKgTsKfiVQATXzSPEAeGZmkJb8HO+NN+3UZEQhj2PkiJ3Sb?=
 =?us-ascii?Q?wLIDRJfZTsbuHvTq1Z0rXSMNZFi6N7UC0sab2d286nIgXaWtCtEswGAnCJct?=
 =?us-ascii?Q?L6soWu8q5ObZKbKvHz8PYgsRjGOwlwB9VEYMYu+oCiWFsKtcCSIuYTDBPjco?=
 =?us-ascii?Q?zv3HJrgVtWHo/5EZvErwbG6d6zBfBuxbk4Y2kHCsT2cz6zS8hygosY1Q8qpa?=
 =?us-ascii?Q?B77EyOUyJoOuh4V6h4IitbsFOX3Hh6V11BCflae7HIir0EjiuuueU8QGwzHh?=
 =?us-ascii?Q?/F5Vtl7K3jbDhpn9yX3R01Blm4+J5gx/HoPAPJKcx9shdMosKCTFil/kHwKt?=
 =?us-ascii?Q?9eNqyDkAJqG4DJBe+fgQLYtglyPCKpmkJrtfSKDBs1ePNZHMB84nT7CegATA?=
 =?us-ascii?Q?WrzF8CepkKcZKaxb4sRLRA209nQW6Pc6NdRUVeVrHzvIkSnsmmnlgRR+Atd3?=
 =?us-ascii?Q?bY/oxTlLIvs5FmwqOp+ZtIWiva88DXv8+UCSeOKFXty36bFqzStOJU6a6WGE?=
 =?us-ascii?Q?i4FVcza3eexxPMtmbJ6JCNmpqG/VtF/bP1c+bJNz5mbYSxji3WMSoj0DZhmf?=
 =?us-ascii?Q?P9qeA4dDrNF5XKo/gaWvTXyZwXFUI+sckSENK5VSgfc2WPaW+IOOcKh2H/tP?=
 =?us-ascii?Q?OL88GhNDt8n6TQJJUm0K3FV8TP9ce6B/84qUs7NAQfVvzsg96PAyu0R4NTfe?=
 =?us-ascii?Q?1aQ4H7qiOgegIEENhi/TLW+DGVbxwQ5P+T+xeSWEThhbohUXK06cELENOFEI?=
 =?us-ascii?Q?2Sov3nAYjgDu0ELuZPFU9w/gXN2fWNirTJ9kmx8rZ9J3X2xypjloQ0eEfX7i?=
 =?us-ascii?Q?SdFehfggAS+xKkgVZlAJTojLdnD7oZGaTSupp08MBbeWG0aTK2eR2qwl1HcV?=
 =?us-ascii?Q?IWmyOI9jmTvNbd7RL1mmXLAzLNIPzLRSUihSUGh6t/7aQTdsQmFmK4KFXvg0?=
 =?us-ascii?Q?hd4gkNBbDfW/fkQqF+aPGrAO0Zm4xxO+fiRRqTwC8hBVQdCfxi/0+diGAhkc?=
 =?us-ascii?Q?zLNV2DOZR/jnLJvwiPSKyx8W96DUNp/jiZXk+jLNUdTLzJCq4+5MjJqjCL3P?=
 =?us-ascii?Q?ia7ftSmaxBwjZU0zvZ4VcK7TinMyFU3y9OFnvh75naCwCVODjMtDA2Hi4veS?=
 =?us-ascii?Q?zgfEgRcgQC0yU+LaImaWH3bQA4lpmaJXjXdiDrsqvMftfgn1IPttNrqp4C9Q?=
 =?us-ascii?Q?ruGE8TqkyIr6TRAKEA6IfQO9Smaw2ZJI+XVu2unVyH/UkJYTD80dMErYR0CW?=
 =?us-ascii?Q?R5JRCmYFSsf/jiKw5jxQx3cL8AkFTMxZrFNZvDG4QOtVoYefmV/NiVciM5i9?=
 =?us-ascii?Q?Q1rus1X+UYIu5JoGRly66rObruad/4mgEOyIfKNLwV0L16vV72XFKlJAK7M4?=
 =?us-ascii?Q?DfrnNAOKZ0DghL4rA2i/svkz2EL8q8OhJghCEQEdLlbpLJzYB3FnoqyZ26Xo?=
 =?us-ascii?Q?Y6M/cllOHCjMhsg/1dDKyzzcDdGWxZwXKQ5woelU24+5wG1zB4WyRS5725wI?=
 =?us-ascii?Q?QGPewQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/cTu8TGI2/5GAwPrudfk+KsyoWgafiZC5ThdGcOBJ2+nFOR5ntEpJxfe3VEWcgxYW3oW/iaqvcyGECBNCoD0bCsKkcgMTf9rtm/jqr+tg8/FBSOaztqZMiAIL9Qwv4uEX/14J/671MnEEGXKO4v6ZdPgh6X/zOpyVsaWcXmSB7yFpMBkVaVXrp278re3aou4j9PbDZnXpds5O5eR5bhJ9Nkwn2C+VC/skUgaEkAOE3ekU7rPd9ch1+ZHgjAKGufvFgfRA4pVXN1rrrDwA/LqzPSyHNy6yS9kial+fpX0gLl2ZQ5Wave+7tDElC2Pdu2CAui22ZllDwrguLLaN2fi7HV/N0cK5/MD6aHqSTKLY48FPsTIPi4CvahzY+Rsh7ekmp7u7CTxfSanhJGRhrIxD5LO0W/sQ3xEG1/ARvepU9Go7SBakATkxJ5DbJdzb0lBcdf7E8DycdodzgD6PayUnFASD1FC/19ndFzmmk6ot0Pkd2atGkp8D9VsKrS5TYaq1rrAqbCVK7kXYGnPNA/k5gV8xmPzVvN4R8XXO6COGr/8iQeQzE2lLkkolPo4WHNU2xVVt+EhuMbR5WZYElbq48hP45tpU3VsUSyWeAsQ4cw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc647fac-58ad-4cc3-eaeb-08de3427216c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 17:53:00.6794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2zJuLEhcfCE+0AmFiiKdwFxS94KZ8leOQM54DcPxF9kBBHymgSD67Lt2Y0P5Rft8/BK2nPR1/Qe9+egvVIUE/CcIyMGLz33jphQrQgAYnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4463
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-05_06,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512050131
X-Proofpoint-ORIG-GUID: MTuZKTni_hDHKmbPavgZfPC2GSyJClcb
X-Proofpoint-GUID: MTuZKTni_hDHKmbPavgZfPC2GSyJClcb
X-Authority-Analysis: v=2.4 cv=Zofg6t7G c=1 sm=1 tr=0 ts=69331c01 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=CWSnK2j4_0uZx41AREMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA1MDEzMiBTYWx0ZWRfX+uC7X5eszZBy
 loszCfsVYpBFutG7WgAi/f2Y9zbGexcXo8Ym9vXCKohl3Kh6OznvKpzBkekhHp7nPJMZoIilE1K
 RIlRiIxZ5qFXyeh6yXGiZRhm/xmbxmjUaLIgcGtxu6mR9NTzwdLVJNZEtNLUOX8JqB4MXaylqvB
 tmp6yuibzq4ucA9/60TH0WGctKJdnH+wtgFm3LX8zf+PDUyk5Pc1iubo6aKGJrdktCXEyPYLAPH
 yl806LYI3K2sqCWJkXDiX6wVuPg7ZUgOX7I8b09tLPPdxL7hnsY8bi07YRK4wL+WTu6niw9UMgN
 qYNe2dZstS6DSFs8DT8My2c6nJwUPXgQXjhY7uldQOtvMB/Zr0mTv6HHZLW8WEE1ZnKdKW/YX41
 sYtnyRbLBCAqYG5zwktw774mVGrloQ==
X-Rspamd-Queue-Id: 232D240013
X-Stat-Signature: 5opipik1sxffdmrwtauoz7mz3h8jnn89
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1764957189-280317
X-HE-Meta: U2FsdGVkX1/O+3TEe4WpxvrdPhvWQPo1VABcAF0BB7m4SZyD8eGOS6dxVdePGBenlGDiEkycRMS1Vqa5/df0oIqfPaIp/F1fwSI/d110i6Oh9k9wY3ncNgBjoey0fACGGStZ52IUxj6xJzr6tIAL4Ai9/NMtdu3Dkomw4tS3Vck0hxQyDlnpehVMaGnCzpdqvOiozd3YLXVOjKOtA+64uG3iZaHwozEhooV3q/pZbTgtNj9LBYLxCzYW/qHf1MTHioj+W9da1SIn9pnBEWNZYFvSLo2r6DkhlvR62BfhN1Gr/ICEGpjLIf5jmJDDRsoAF2NlIpDGigJndGreybFN73CEZ+I78ONeYNDZmWEE5p2Mvhlj9rUDyAaWbz+/yJCdVLdff9o1b/wyMTzTY9y3hUA6rEuwf/LHWG4KBWfejInYvC/etaxWAe5hkSqzWTM6Xw4/Pn2EJ8RywlmTkT8XC8wu7uiQFoPJwCw8+Eo2Lqf5bST1/wEzwTnsV9AUayI+8eUVnjb9v0qwlmOSSKgiqKBwD7Hp4uGxxC6yfhw4kRpxpaYT0O0CIQxi+7poLJ+xkoGp0ZrWE4NLJ68PIpxSBEpTlwDN8yk+o5rSOuxkmtLY/RxJHf9EAZ3o0KV44QStevKkbdKa2TjrU23PQGAEsqFgUQsdpaeCX/IeIxwWMzFB6KQcjnnbpXOUtVInvy+vH178VH/xp2vl7UZRzllo4alnyKewUJvXYq8oKnAn8bIh0/EG1U3ajQDhKTljpzRUelFl27qqA4Y+9srwn5m2CBnZuvnqTNaLxruysTLZ35n7b+iiG0g2kDfMxv+75dLL7vUz6jvpoyAQ/JX8H33f2V7TJYrLEpyFjebjfiolVWp5QO9Tz6kP/uyzn/F7OnDKqnv/YyS0LjN8wn+80B+ZmjZmCT3sITTn+Qp/UTeI5wjQLk7bWYP7SOhGlrhGT1ZkcHNqwHNbn5nwhg2/SbA
 XXdVdHqF
 0MjylI/4Qbmss3nBly+1TryG9VaGH0kkbh4d1PYVZyU7cGy6MzidDa+WpMitZayC9Ou+AMQwJrzQkAKGU/QywhqWlOMbBh6+gDynYM1p9HQMsT5A74GNUtXv5IjbwWlLrtdOihAjnivnkxcQfVHUEMZcs2KaySayBsyYzAQzTmJUuRiXdGdX6wId8EUIJhCT1wzCD6uS1Gqd1ZnUz7Ui4YQx5yZ5yy6/nlGuLseSGxQft1SKPpXOTr0CyiTqomLzhLGN1/4ljdwN2pDUmBfWaU5+1qbzK1iuRCHimAd93kT9GQQUg48EvAHEhSSz/TRe4YLOJ/iIfRmYudC9UT8r7bTjBehagkQULeJu2b8oq+d84IkxypZiAKpjQkLzSyL0Lhiv74TLaY4MM7VQ8UV3k3vM4QEOzQee5jqG2QSTOLhGGXHJ6f/IAJIWHWzhZPPxOu93uFWTiFAwIVvsTqQFn43+ZZT6xFvEmk9exHZ7LwOjDWQRSnDoOwtH/cpsA0WzMQx5g1e9oNYCxyQw1B8o5CBubGa981zLdhThnjNWJeu3XREnFn14HCPc3j9yvjZ9pnlaLk0z383lxybigCa/RHBwiwxRGa8n7CIflCD1FIqe9FMT75sL+UW+qIv9ZB3S6nBHp/oEzE+ZAYLimZK6mhGVwi+98ZGi1iPd2l6MGIJV+6D3hyHdYT+kOhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 05:50:37PM +0000, Lorenzo Stoakes wrote:
> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> how VMA flags are declared, utilising an enum of VMA bit values and
> ifdef-fery VM_xxx flag declarations via macro.
>
> As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> the newly introduced VMA bit numbers.
>
> However, use of this macro results in apparently unfortunate macro
> expansion and resulted in a performance degradation.This appears to be due
> to the (__force int), which is required for the sparse typechecking to
> work.
>
> Avoid macro expansion issues by simply using 1UL << bitnum.
>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202512041634.150c7e4f-lkp@intel.com
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Sorry forget to add Fixes tag... :)

Please update with that also when the PR is upstream apologies :P

> ---
>
> Andrew - note I've referenced the linux-next commit number above, could you
> replace with the upstream commit hash once your PR is taken? Thanks!
>
>  include/linux/mm.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a2f38fb68840..c4438b30c140 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -395,7 +395,8 @@ enum {
>  #undef DECLARE_VMA_BIT
>  #undef DECLARE_VMA_BIT_ALIAS
>
> -#define INIT_VM_FLAG(name) BIT((__force int) VMA_ ## name ## _BIT)
> +#define INIT_VM_FLAG(name) (1UL << (__force int)(VMA_ ## name ## _BIT))
> +
>  #define VM_READ		INIT_VM_FLAG(READ)
>  #define VM_WRITE	INIT_VM_FLAG(WRITE)
>  #define VM_EXEC		INIT_VM_FLAG(EXEC)
> --
> 2.52.0

Cheers, Lorenzo

