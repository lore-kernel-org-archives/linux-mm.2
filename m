Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D84BCCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417B58E0018; Tue, 21 Oct 2025 05:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EEB68E0002; Tue, 21 Oct 2025 05:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B65F8E0018; Tue, 21 Oct 2025 05:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1911B8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:25:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BED181403C9
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:25:29 +0000 (UTC)
X-FDA: 84021588378.15.D626A9B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9E7E42000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:25:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YmhGC5CU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=py0XAYsd;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761038726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6V7kyUl+ecmKhJSSShB/JWaEt0fk920hlq9uDX3ewXw=;
	b=ZibJ2CmcjOwVnA6tHses9EZ82JpjvOGZgYWSKVbJM6rx6oM8+UWJ9eZ5kDNWnQAVdZLFb6
	oTwWsWQxLw4V+j8ald2b6k93dNC6UsnJ6uTBQakL+8cYqFendARXouGwpl1Q7cKr+raydx
	xiTM+GVg+HN7KQJev0+d3hPt0n4B0iQ=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YmhGC5CU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=py0XAYsd;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761038726; a=rsa-sha256;
	cv=pass;
	b=o1iLG1kYsbvgWlLEisjX3ULYFRQ/BW4h2AVywl+ddxSlufhb0KKXgygsJeB75Mq9tMusbO
	xQSs3ObjiiFVjxIPp8rfWv0vFmn9XCr1GpWDWzjY7a7jYf78QTKPKGX/FIBjtGD2WcYmkg
	DzIykU5qw6HcKqv/k8ydwhWYCInaSqM=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L7uS0b027866;
	Tue, 21 Oct 2025 09:25:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6V7kyUl+ecmKhJSSSh
	B/JWaEt0fk920hlq9uDX3ewXw=; b=YmhGC5CUdkVkOBmxbTkkjE3m0Ow4v1VA3/
	6aG32t3vopGVgNJ+vXvvypsu+FbtLL0JOeR/8sKng0tlJw3u4GGF8Un9tvI3TUuT
	KrKCirRdEkIxJ1O45dcgrfc5NjPaTOcKfjpb65PVD6naKPyd9h25etTD3vOkJv5N
	el6Sp5NtEsOgenuqOmO8GFxzL/Z5tUrRC8b9ptaJYrFFS2iiGo9RvJ8ORsZT5Nfk
	BjXXqR0m5fFufWDShNnhrnkk4HVwgy0EmzoCHigs7dDqVyBSoX8FzDbKd/tW5LIC
	Q36yu7KDr+YAAPrdHBSuv+OIw7H8BL+mUBDBKxScVffCMyMPpK4A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2ypvkw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 09:25:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59L9M0c0026038;
	Tue, 21 Oct 2025 09:25:13 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010019.outbound.protection.outlook.com [40.93.198.19])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbnt2v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 09:25:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=csuiwDu8HxdxNzges2RsYVAgNocg9a1G0fqJnlx6MB+zBBfscxBZOWwcFOnGa+yDro5YSUo/bCHWtiO41W5i7onAe7ult0xeTevfFnsHgbe1Q9eLa35av72CAaDrI5iVRvxMsOvxFmmGJPJc5eDSM/oB/UWzQuS60aY9ElI3jjz3CgqTcyZuyGGd2Z8ALiHGBzlD/Iqph6yrCHKN+KIeIQMxBzhjnotgy6tq8gil2SO9u3PWUJMFZIQVYlhX983EfMqPxbJjj5Dr7X3GCQbcqyPZj3gjBdy6N7iluKP0toKxgG/+yOe4oZ78jHKQj/B5Mli4WsCyyZeLlt66A3zzQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6V7kyUl+ecmKhJSSShB/JWaEt0fk920hlq9uDX3ewXw=;
 b=DfgI2o17VrEKdI6lleSw//fGTL5jQao1xZlzORwtn4ZfMVhY/h6mXq9hW+k3/jybxVcxv8KG5j7OXiAp0F3QIdWEtTS5i2+5G1A8FmqyihtlSBa5HuxMPfLf8Y1PmRImRC/oOddaz/WYE0e2ecrOXs6DM939KK5W8bg62W7OTZY5zpvEV68KHkR5DIiWpri7uOuWwrvuiCBlFbvsaTq6RulKenGEyJEaWx4HjytwigmvOUTznRTXkTDlkCxhwpOgni+gufm531r0f/wq1kud+VODYe8XocjUgIwG4llg7eMR4VKTk8//jzxg6v2fVZte/1ctFt/Ukbk7ulQq0Tqjkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6V7kyUl+ecmKhJSSShB/JWaEt0fk920hlq9uDX3ewXw=;
 b=py0XAYsdFJDiF8zvnvzuOZ5sKNKb9gmCsGp+NY8SXB2rZRsz954GOU/eBXoqMXlsljgU9fMVrPM5To3pV31xIAeQsOWCCf8QKAA6rqJ0C0DuJwqZtrenFSTxSKDb4J/kZ99Xh1ND/yios5uz9K9iEyHVP5D80i/6+/U29DLDIUw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7942.namprd10.prod.outlook.com (2603:10b6:408:209::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 09:25:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 09:25:10 +0000
Date: Tue, 21 Oct 2025 10:25:08 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
Message-ID: <944fe458-6391-4cb9-8719-dbaf69f3958d@lucifer.local>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
 <335895bc-c2ef-4ee1-a423-06c673a67147@lucifer.local>
 <1a97f0e2-fc97-4257-8540-cff06a789e32@huawei.com>
 <5ff1ee06-375b-4d5b-b513-7b8cab4e8139@redhat.com>
 <f1d3d11b-6ac8-4747-b2e7-952d4fc3e09b@lucifer.local>
 <719c8df8-b4c9-4a6a-bedf-d62becdb09d2@redhat.com>
 <759578b3-d582-48cc-90af-491210ecd90f@lucifer.local>
 <3ee89484-9cdf-4c50-a5db-79b9f2ca6886@huawei.com>
 <967f61db-0ee3-4257-a44e-69ef15ced012@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <967f61db-0ee3-4257-a44e-69ef15ced012@redhat.com>
X-ClientProxiedBy: LO4P265CA0184.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7942:EE_
X-MS-Office365-Filtering-Correlation-Id: 7824f6f2-36ee-452a-a5e3-08de1083bb3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a3Ws3sJ5JkbSPF8bLYWVD0iQeNTUQ3ULt7LL2NnymazeHXHxg5vdVIvsluSs?=
 =?us-ascii?Q?TOS8RmrRcj1BDgBfl8Wd+LFsRSumvzmQ4vwV30RuJt2k3krj1pcwigvRCmvS?=
 =?us-ascii?Q?heZ2u18FendJ9LZr83k0LE6E6Ro5dksqAyl/aN5mzoQ+7IBxYNg0vQjwUFMM?=
 =?us-ascii?Q?djKmeEvcx6Vc7Ldvlo/cuwc+LNRDcwwleYC2ei/22j3sXBKBIPu2oDzhJTh8?=
 =?us-ascii?Q?zH8t3UVsXc5h4DH8ghM0kxBh/Ij7EDJmNSizkqb50ID5UhxEATDGbGno6xZO?=
 =?us-ascii?Q?GvoePGVieocTFjic103VzSPkp+YXbGMwX5DFny2KZYTCB9z/8a6kcoXukK+t?=
 =?us-ascii?Q?jdLWwFxiiiowNmi9vXxwyqAppEyCUKQWLjYT0ZnvFoLIA3cV0kYvlJvKoHrA?=
 =?us-ascii?Q?7GhFjsnt1asQaVcQgU6BHGRNqoWIv8QyFLN7V97ak8I3Iyuv9RalZLbuqvzk?=
 =?us-ascii?Q?cBQFWtW74iuHK9HEzAqtk9HOQ9p585tw3xKdxn9wYeVHjLNSKeLk078WJtS8?=
 =?us-ascii?Q?jBG7NmwCUzNTkoURs9LyuTlwDMSITZM0Xe/THpbp2Ef0xPXGFIFGnH4OKwfl?=
 =?us-ascii?Q?A9DuhlDhOz2+KTU72BHRatuShtClm6UIt+mDEHStcQy7COoMhbNAaOBFUKyN?=
 =?us-ascii?Q?c/eR9G8IvIRh0YH3u3hHeZxn2n89bxQ/hwWwmT0b2LyHypX2Qg3B0O7i893b?=
 =?us-ascii?Q?8PQX3YtYXHPcNFU2FUV5rBzFr1nmqDtTuOmqfzzCKb0mmFwW61raeO7hc5eX?=
 =?us-ascii?Q?KT+8RA6Sn9gr5cKw+H7bQTD3pVpFNtq6QQdsboFqFN2TB/RXjIzmKihyo1XY?=
 =?us-ascii?Q?Np5LfvSoaVxlf86PNh0cvJj7eWpYy/oYNc4OUbfzFI3sfLWc3myQGsUeQ6zc?=
 =?us-ascii?Q?CswfQOBqj7qyE5cDFfwtGa09tslfjl1AoPonyOLHqOVYd+PBA4rI0U9/envX?=
 =?us-ascii?Q?V15FBAxR64MtA55esoDyBb6PcitLySCk7P7kBJKQ5O3vlaxigg80AzQE9Zzu?=
 =?us-ascii?Q?d4p2QtGhlR3K3C3KUE7XWodztoNmcxRBVaTipeLancngdbwy+RIj9ZQ7hEsq?=
 =?us-ascii?Q?UBKTIfXkYbHhIkqB7RDr8M4CMIYWzsRbaioo0GJa4kNp5ZQydAwLHtHl2znV?=
 =?us-ascii?Q?vRYId+zjUlvowYz0eIHA3SqehcMdso3k7vekHQgcbee/GWNrwUcMZxfA7/W0?=
 =?us-ascii?Q?C6vqOvKBpsVUXG9+8SwCpQyHn+xFLw52NkIWnr9pS6odX42D4lfI+/TdQAEg?=
 =?us-ascii?Q?0ojTRYhymdpluALZXCyDYu05ukMUevXSkNCMSwTHb4tIGiI8Z5vo00kNwZv3?=
 =?us-ascii?Q?V8WbEG6xbM6grTWHtf5HpITuXmis9alF37alCuTfLESvYtL2lQOA56zApELr?=
 =?us-ascii?Q?nJlyjCIdkZpKq7GPiW1W3Ps47VWJQO692vieiLatVL93sBoI+h7sFPNI5boL?=
 =?us-ascii?Q?PBehoAoT/C4TP5drVtjMLSBWWxI/mZb0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6uXaVpRUknlpX28mUhzx+0ofK+klz5k5S+tmPexBhKYHcavvt61VTjPsDeb7?=
 =?us-ascii?Q?RREGfca22MMqQyOV0X0ll8nqTsux0xtbHOcl1fO186y7l8X2ZjWCEzM0BdNM?=
 =?us-ascii?Q?DFsbvo0ZnKWVEJ73aZ5GEDxEAtZkdcORo4hE6E+lWFCrk/L+EAWYaDb7fS1P?=
 =?us-ascii?Q?RZXMQ1rjGUi07k6pGXn21JGZyNIuOqtkA1as8Zfut5DxsmHgnqLvpBnDxVpw?=
 =?us-ascii?Q?lkFAwggptUlv2fxEZdl2UbN6TAICRVw8O1Oy4Hw20tfA7y0pDfcOzAzpGF0I?=
 =?us-ascii?Q?LrvcfsApD9wZubIdLHEwKA3/M0SK/wwtpXHSGWCtoq7tG/FGzytCpTeUeNG4?=
 =?us-ascii?Q?XRCCSQ7B0m6RDOucIdtR/BAtj0RxNopqsny/r81E2pBzQq6Bqw7DzP5npsix?=
 =?us-ascii?Q?OGE9DiRMwgTmEXGPyj/3y244K+7VJj17o1fDFESg9lw59zexwwRYT1k/sGA4?=
 =?us-ascii?Q?GXQSqXoe3l8HbZaQPxoivR3IJuxAYmo7In31yt9XgouAxpPHdLDVAQLNk0aZ?=
 =?us-ascii?Q?AgO8iZKgc9dq3e74U5Ms737uzHXoz84dDwOTtNDbky28EIAxG0lOXO1T/pII?=
 =?us-ascii?Q?BcbV66gKUufflcILRU/1byYWHwB7o6uVS+NRMAqYU3hQBFdN1y0U6/R3cnYo?=
 =?us-ascii?Q?FbAYfu3cqkSZDs9amOLySdKonzRh0vXSykSQ+sjArFKE8kpM7Cjjf6zruEu8?=
 =?us-ascii?Q?dAltrmqDMFXkZ3cc7J6XGyMIg9PgO6SJCznlJO7DyaU37WC7Fn75I62cM4PW?=
 =?us-ascii?Q?cgvw7D7/IiHAwcRsjokP2DPj7XWuQ+lrOIjRjrTkdzbM/EN0JVvpgMfikOpA?=
 =?us-ascii?Q?Tm9xsxUCTsowV83OB9bjcHfwrWA6P3iH8nIYM5V4HkVmIJC0EBmGtuLtQSTW?=
 =?us-ascii?Q?H2OeCZPPAQ7HtCgUt+gTskMEKh1fVlFPtanzmcbeHxCRbF8yGWDr3S0n7iOM?=
 =?us-ascii?Q?wkFyrVL+mJyfS+S/3rJXHIhEBci8Z8olUfinTvI/alo3m8HOrhrNA5u+xUxv?=
 =?us-ascii?Q?Ba2sC2A/wH+RGHmn9vRVze/AqaGsN5Hry/jF+4c23BJ4zRai/CRX4tolKPNg?=
 =?us-ascii?Q?7C+ZDBtFCLba6tEFT2dBZE6DQXAq+s33+9BO7XYMom6x/D1m0SrC1itU7Tcj?=
 =?us-ascii?Q?DfVKIhA49EbsEjH74+rDflCM03wS9rLMhQ6xpYkg0cu9O0uwy/f9m3y0XO4h?=
 =?us-ascii?Q?Fwanzbr9d5yNBvrP5m0Ju3kIlOTECjDYnSRx0fxmh8QtSHAS/1IkroiYBCqA?=
 =?us-ascii?Q?hQR7ZOsHKTyjM8jTqjjKyTlbwj9pGlFpgba9cwNJWj41WVGbXvyFgTbMQ9Ue?=
 =?us-ascii?Q?USIsw4mBA9SiuvPThuRAB+iHtQNldBQRdCtB9ApCjray4PGscozjOBWFWQ2h?=
 =?us-ascii?Q?kLgVdtWT6souOk4axkA6+M7TTkneuMxun89XlGS5EFTJhOuHOii3ttdRCfB/?=
 =?us-ascii?Q?U6GH5JAB8nelPmWuc9m453SiztpNwFKFBJSDudngxbOfHc5Gbxhiixx7ArWT?=
 =?us-ascii?Q?nHa+b+0UYY+vdYXwBxhAXecj4XtgV48xvcI1iRBGriai6Yt+GHegtEz2a6n2?=
 =?us-ascii?Q?A/CYMBXG0jizk6aV33Ww356L5CxLhCokSiwgZ+WRMd1LjCSt5Jt1Pet6AANk?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RzzjBKq2Q8UUspM6vvltijjugb68CRiGQXsSsrtPd/JMFVKCoaUvtx5+icIsMCNQwCGBm96uJ/tkrCyw40Ev1fEiCr1lQ5J4f3KgKchURtkMreWUFslSLvlPw5wWdDlI3adB0T6imSZDOklxCVNKhKpnqlouWZw6eFvvhFkh2w8aJdVWEi8Md4wBkdLXJm3M2ojBLX01+w/RJ1ta2FyeWdj7dNy7fFP9Jht07dwAOLmfEnLU+6Ch37STRd/J5Qv7qV0eVBI3jLjIstATdyzY80+VgZNqU+Azy3S4V5T2x4uFMC6uVFiSjpr4RSOvpZ3/1rOh1bUk93WOYcBJOWxXpUeUmolDyjy3/D0NQXHID0xP4htIiSYXxmWZQMr/O3oJypnO/YsCq7wlfAvn57cDVemwvF1jL9o/ksdos6hA0/eomctfl28psNAjadPBoZdrrnkGuO5gagZuEOlyQ5sIC0lAcu5vMHcjEvujxuzAleq/TGVbjbNCaXsvpnOkSjTK1qPN+uRL9HgnuLpgf+Mz6GDMtWSM9Pc80jx/poBkihS++6SD2jXmN7IQby/YHGaXbnG3XYFxT84QdjAEyaQZtFg7XN0ZTzvGG2ajQvGeV1g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7824f6f2-36ee-452a-a5e3-08de1083bb3a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 09:25:10.1703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lqn7TR3QejHsbWPn5qsX1eQdBTN1V4yvbZtqMowvhGJZvpP6Jjy8g8a8LDt65U+RdGbW8k0QAb1d18qy5TY/VX6lC9oHJr1/+ZhDdQng1HQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7942
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=824 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510210073
X-Proofpoint-GUID: -46Jyh7UCcAZ89XIVk0l3zBn-60o0RVa
X-Proofpoint-ORIG-GUID: -46Jyh7UCcAZ89XIVk0l3zBn-60o0RVa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX+wzPdXvlmsMN
 DSlc+1IiwWh3kjlunOARcESu2Wb7BeRemTepzUitR9yDPuaGWUFaXTp7keG1M47jQMDGVMeOV5I
 EmJAnnQ7PVfe/jCn7OUGBmSZYh8f7B+KnPYHRdMZdG9vUaR2ppeio1ks8YQ46f+ebTjPnG6hs4n
 wAL29SVSniojFuxMm5FE5ZqU9M0WPxHzkcxWNlgh97kFoAKDp5bvKTI5FBUzd3mzgqpyvBfOvmt
 OcyhVMJhzeWQUVK54zktgc5FhCD6rdhFyjTCthNn91Z121EDAhH5xVHSWh/u5euQiopI2bEiNG0
 EMIJ/PDRnlNIDbzr/6iJWgplZkJzhaoLbq5o8cPoPf13OaOu5B2iYFt46Pd+df1U2PVUNxkr91e
 wYaElNqt4m1SSEER/hyAmkq5YMxskQ==
X-Authority-Analysis: v=2.4 cv=Nu7cssdJ c=1 sm=1 tr=0 ts=68f7517a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VovGFpdUqSxmx8-8AzEA:9 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Stat-Signature: wdfu5qqjknnd9n89tn4ehhecbqxroq13
X-Rspamd-Queue-Id: 9E7E42000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761038726-979377
X-HE-Meta: U2FsdGVkX19lqP18Cx7XUs5PMna0jFauLOMmRKWpYQE5xkojSoh2MT/zju4UoCdVcz+xixSQfIsPXYKPqwEzYIVguxHLXvi271CaJ9wKLVQa7FaxEWxoNTDELcMI7/yaJ0Fkd3oM9fcXHMF8A0EH7NHnaI90b90uckKSiL/oeGMOx4pHaCWH+5Xx5TufSBci5WMER7h68BXFg5b73XlXWO1sPFz1dE4sLrW9tHORgUHbEotAuOlQzfAEpx7RVgAuwOZeWh1AqO95LlqpIxZ0dHhF8F633qcSW/jZmoYVgtMk78dhXxzFK24LkYRS0lFjPsVLsZ0bmm3VC1D4G5W+ZF/3oVrP/Zff0DMrvAXjWUO5iAer0ML7/b6E3JRtSG+tDZfjR/yBnNLd8pM+YsthATgdkGIH8TpcofIhIwqjsx0+eIIEjbzhmzC1KvP51qcAtuAstS6XGpjf+6DsiHwsc2cqEwkFZj2QVVHXd1GxjHBoWbNuH1K2d+JkoMFR4zX3LOC1kPe+ibt1WJkwW7eXepYTJAxSwYeBYqs0aELevfVAxWpRi67du8p8vtom6UYpGcj/DvUWSNferynTf35+WXePFMor6TKulrVePIBN1S1YrrGpnB+y8EgAcpIEno/I4NR+f5gEeAGSoQLcoGoCy4RJ2U3ihLvXKc2AZmLnM6X9gmL4RU9Bsqm8FuXr2BhXvek0VtAOXh/ctOgqyUwkFF+rLwf1HTq26XgAC6oXBUx7wX8MbDC2GD80KBrzTT1rZutQ17c5B85s5ah1rj0wAxRNfRaM6MNLkGgYo5lZwlPLe/WhGUJCqeq6deal4TdicMgkr+Ow6ld8DeqoHygDpghehEtYH4A9ScCeBBgdWCZAkW5ugrvR4q0PRrXdd/OMgOuJy5jjZwh50RhB1avvq/GfwEPzsSH3VfRNFtTvr/EQ88UNyOM+UrFlu+XW/BRTItKbSkhWE3elcpOJU2x
 GrTxgMUg
 85Nfl0XdBNUVKLma5bF1p/hQQkzSb3vrsVVPSUd4InFexZKHsNttmAFz+7Q6sAu4OEmHDa9K1EQd/+H0tR6F5eU0G7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 11:13:32AM +0200, David Hildenbrand wrote:
> On 21.10.25 10:41, Kefeng Wang wrote:
> > Maybe folio_needs_protnone_mapping()?
>
> I think prot_numa should be in the name one way or the other, because we
> also have ordinary PROT_NONE unrealted to NUMA faults.

folio_can_map_prot_numa() semes to me to be the best choice.

