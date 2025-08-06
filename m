Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49437C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 09:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20318E0010; Wed,  6 Aug 2025 05:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7C28E0001; Wed,  6 Aug 2025 05:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C989E8E0010; Wed,  6 Aug 2025 05:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B33AD8E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 05:13:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 601F8C0474
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 09:13:49 +0000 (UTC)
X-FDA: 83745770178.21.3BD0245
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 05287A0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 09:13:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aaxDadIb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0HHvPfHC;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754471626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdwNjCHIFeY30D6Ui5fJP+DmGIWE4QocABNiyP9MJYE=;
	b=mqCMcFOhduymIot7X1s2rZA/i6uQmMC/18zwpXu8MfjeYDhi1k1PebDsV0lAWjMFbh2QgP
	iTnu1XRNnzZuC4CdvCAikSoLx8GaRZSMMhINH0891cBHe24+hV/Ew7O93VEiSlF75FXzXu
	F6Jr9QQW8pWkKspu9Uxag7aZMfJQqXQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aaxDadIb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=0HHvPfHC;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754471626; a=rsa-sha256;
	cv=pass;
	b=bdQOVduNzwq6kFuTWz3rfgQDJR9Ft/Bw1aCGxWIakRs5+B7eVLtHsncUlqB0++C8n2HJK1
	bM4Aubm4+1UP9ByPzW2OLxOwhnOCl1Qo8TRd466D1vwk/Fzyydw8nAaX8snChkNrAkVZ2L
	MK+ty+hEQat5r7KeCuiFxSvh4Gd9FSI=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5768RdrX005489;
	Wed, 6 Aug 2025 09:13:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zdwNjCHIFeY30D6Ui5
	fJP+DmGIWE4QocABNiyP9MJYE=; b=aaxDadIbt9oUJMWxt5+FS3zsE14n7HnPcn
	4irY2o6U25dupC+4mW81ljGegO+ivA/0ttAgIP/hYdrpbOyuVQckPBqOqRRf7e1K
	n8S9PgAtAww30eQ134gWtzyO/ToG8/AetTWrqfc2ffkuhedpsrvHK90xqYOXlvbf
	AU1OxAecpuwWLsIvchgvFiNvNyAej+uadJArMegQv+HCCmkmbHuyHvvIIrplpVkp
	rqWBLXUWistXD+cXeL7K+z+OCmGgx2nKv3KZQitZriddu+8vLYAsyyN7N4hdnEoX
	9dMOW+VdBDt0admMQd2g06+g3J8cW18JX32IWX8UaKa0ToHDJUng==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvf16ea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 09:13:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5767iQ7H018343;
	Wed, 6 Aug 2025 09:13:17 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2088.outbound.protection.outlook.com [40.107.101.88])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwqs6dx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 09:13:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WYtnQYPBIDwDj0Nsrt8c8Xlo/w4mBkgS7+9Ym+dC7QcYka2Yb/iOlPGQOAjryYWohHhO2Jd5xlPVlMP8fdIom96yMasx9UaURALbQFH2O56Ew8lYLBpFF5Ui2A0CmungUTeNuu3ZPjZsnu1xN/KubGDtc7vmJXYwd2/JWXeM0SRmk3mzfa8xXkSAUDenxJVMa0qBRgyxs772XArfExihG4aJ2gVGZ/qzIydp1PsrSL1epLXr1S0+kvFUpTzX74sHP20JHHQUGbQTGA/A/9j4N2MounWh8hPp1DF8SjX+ClOZ0rO7HHIGh380KOXl0Vquyc+OnA65mrTBHVYnO4Km1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zdwNjCHIFeY30D6Ui5fJP+DmGIWE4QocABNiyP9MJYE=;
 b=eO9pQSfoYUM7cbSMUzE7q43uj2oTr9VGTHB4PEP7ku2fviJ7MFa0juYS82syezKI3vB3vRTNQQxXSG+vUQhInMwHNZGk+DZdJYmz7PgDFKx0aSoVbDVa0hssYXrcZumtCjbMsJ6c3wT1U3vlEj3t0KWCadM1Z7ncNzq/oab3AYPEOuHpajKzyL5RAgNp6Ip/8/f8mpGBTATx0aPxo46KTW4Ibm9+QwCXlKygj/YVaDBMyZgmJLzI9D206pV4r/JQ1Zw1ItQBT95rAZoGZp6Az7un+SnS89qeiAjydGeWnlolKM9VYPD0d381edUY/5bwmjrbkJB3/Ndxwkjijf8TwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zdwNjCHIFeY30D6Ui5fJP+DmGIWE4QocABNiyP9MJYE=;
 b=0HHvPfHCH7qSARDwmeOUY/anU0nOKaVCRIDFGFILU21OIqpnfBCAWz7qG8aGXpL56XrpFCAFveHwmxcpNDXKK8cgrE3/cSCGQI41uYkoy2K0BmtyCJ/vPorPNc3eBpnM9X56Ts1YeVTFYyLbEKoQnjXxNfGoElEYE39ulqANZe8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4251.namprd10.prod.outlook.com (2603:10b6:5:21d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Wed, 6 Aug
 2025 09:12:53 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 09:12:53 +0000
Date: Wed, 6 Aug 2025 10:12:48 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
        ryan.roberts@arm.com, willy@infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        Liam.Howlett@oracle.com, vbabka@suse.cz, jannh@google.com,
        anshuman.khandual@arm.com, peterx@redhat.com, joey.gouly@arm.com,
        ioworker0@gmail.com, baohua@kernel.org, kevin.brodsky@arm.com,
        quic_zhenhuah@quicinc.com, christophe.leroy@csgroup.eu,
        yangyicong@hisilicon.com, linux-arm-kernel@lists.infradead.org,
        hughd@google.com, yang@os.amperecomputing.com, ziy@nvidia.com
Subject: Re: [PATCH v5 6/7] mm: Optimize mprotect() by PTE batching
Message-ID: <9552ddff-d778-4934-9349-37c7237cbb78@lucifer.local>
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-7-dev.jain@arm.com>
 <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
X-ClientProxiedBy: LO2P265CA0483.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4251:EE_
X-MS-Office365-Filtering-Correlation-Id: ec4581d5-a9b1-48fa-31de-08ddd4c96c5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/AydgZdvxurSdMAt8g1aH1/OOJxcvL2c22+1LVYwCoIM7yZ2clWYyqQ8+BTf?=
 =?us-ascii?Q?ww69W8QMtm9DcO9+ZE5bcYZS+qL0zdK356nnXa9ggCIhHZY2ZZqI2clPBAuF?=
 =?us-ascii?Q?gJyLI1Dc1WhgTI4jN/LuYeX1bW7Lb50kGlLqjco3XZ5hM01feTTjH4sGTTNi?=
 =?us-ascii?Q?2o7XBs+Yq2748yvFKBNTIN+Lv08ru7Qsgw6MrnpMml3YfwtM0gTnPLNBB+pK?=
 =?us-ascii?Q?+1UdZLhvx6IKfZQ2Sj9ILnuh5IxdGzJ3HFOOAU0teDZxM5uPVy+LIhI41Vo1?=
 =?us-ascii?Q?tPEKv428xy2qBf+YiH0h0lTwxZFjqhv2Zk+oQ+Z5LA65RE5dYxrtChMbPgjw?=
 =?us-ascii?Q?+LZJ+l7mWIJjd2OLW4lCCEWEwkYxx/i05JmGOWFBM+P9g9KgHXG5/HBDKx22?=
 =?us-ascii?Q?0t3eeV8jmEJ1GhUt8hQdFUcMZ+QDunGMOdhYtUyM2WNjdyojD6TxB88C4m7h?=
 =?us-ascii?Q?FkjGkxx0liTDkBKiyyBAhuC5CIhZFyMJwecNJlCU82STbDnJ8nvCwo27saI2?=
 =?us-ascii?Q?BYJmJEZjBFDljIBmVRLIDi3v8tDwLIyI+CUcZM0908VaKZ0qo50BcSnS5TtU?=
 =?us-ascii?Q?Ij60V4tHXmZ/acuOFHQzkWGp9tWrXVRMkWEEfd6phvFOuczF+11wfxAqRljV?=
 =?us-ascii?Q?uS0iTJ9nBObz352PE/05dESirOF/D7PJGEiBPyYmmH5sZ/nNPH964yQ/cE8x?=
 =?us-ascii?Q?S1FYaiZkWL4rwi15GAXnAJqTSzvB4d7mVqTUzX4NxlMaRCS2/7IgymyRVACz?=
 =?us-ascii?Q?NnbSe0kVzh1/VHPen+Clio/+OsVCa65eI7/qRUdQziK2ImDEvCPQlV4cy4kQ?=
 =?us-ascii?Q?i7n6tDNkAwSyHaG8d+okNDUg9u0FVHfTU58flYGfIXztvm5xFsRXgf9vdOGs?=
 =?us-ascii?Q?RON/rvT72hf2Jaj7mnYeEk9wyYO89z/v+ejhEh9K7S/BoZ/MiVZ1D6uWQoc8?=
 =?us-ascii?Q?5bKGKLHAWj10Gx4Sc+P9t8nbGknlSP53t2qbRsB95EysQwuu1T0R3KgvQZsa?=
 =?us-ascii?Q?CjIQhsYtT8ktX5Goj3ipZzK2DaVHQi1qtK2sqVzWXohTQKL7apGkYC0pcgxL?=
 =?us-ascii?Q?+VSLJvI1EJH27f9jna6uG3+RmqwkamqwIeM03yawKoRzz25tMnTvxLjt2qEh?=
 =?us-ascii?Q?pQBDb45E0ylr5+iXGsBzfgSBk7y5XenKaQNpt/XVw40F9lCJbetCG1Jvnx4I?=
 =?us-ascii?Q?R5BS9gtYHxF++RuSLAB5gglxvkJReKJuVuoTlSEsqZnsRtbYZ9xX9f6R/iW5?=
 =?us-ascii?Q?jBMyZqoIXMKzFsrBtjMmtMxZPuK9mtPuCFQ0w+cPywUnwYMXa1ClZzVlcST/?=
 =?us-ascii?Q?iOuIOTaqCQHy4/e+hsxINNv6S+4mizbELJW4x/VXg/6sSIy2EOze3xTW1Kg+?=
 =?us-ascii?Q?3wroJt34BuF6LVwJ/ApdIs/a4TRh/finIN/v5eVdadMx2ClGpw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7Vw+YvgPD4Mky9wKhVZIySLgUZS4TMKNHjFC16kThAnGIup/uh0rWoDq4p/T?=
 =?us-ascii?Q?LCWJVLaf548r2YStZIHZKNMgckBQeETcSCax7CeJEVa4GSWSV1JMzL8gzQ0V?=
 =?us-ascii?Q?vbTkUV3KSG2Uexh9wtXOzJLf7wK2b+ilwMBAkGKV35vz8H6U7to7beYGJXb6?=
 =?us-ascii?Q?t4UQ9p3gLGW+/uUszzbS4FNvlOKu2ggObu77VuyPxiH81AiXP1VbXsaQoAnZ?=
 =?us-ascii?Q?LMNjo686Dr353MpGwcv1xPRPzjJxctydYcdUFC9CZEvSxQjS2/wXp9KmiUFx?=
 =?us-ascii?Q?fYfpZrOVHVH4pmAtf2+jylq3Z8kZygyob8fGlMLVV0/NEfv3nAg3/+CE5oyD?=
 =?us-ascii?Q?YhP2RZOmso67EiNqIfk+PKDuy9Dj3+pvi05SzRtiQzYCw0Hym4tf83TCVYaV?=
 =?us-ascii?Q?STeL70HFgUZFHEMVwNYWyAkBAuE7oQBztmWrVQ99RvUUk52zoGKVrT2ztLt5?=
 =?us-ascii?Q?enPGmGe6s/Oq3Q+WrDqmviUBD6oRhcW+WzHAJ3TvxxRle6LDQOX8Fx/sVAT7?=
 =?us-ascii?Q?3RrKeJQecY7z39p41vMPeZ0E6BUpOQFHevbXNyt/LOKepQcAnR5GFYkd+0Wb?=
 =?us-ascii?Q?HZMw+AXdQEOIY+LLooJiVeyFjK1rxFw436T51uYcAQ4f50MYHc9/D+Gi3uSg?=
 =?us-ascii?Q?ZQ7EyDmWX2rFoZcq54ZTW8hQKPqKCMB2jeWTEXLlEc5rZDnVCBy/jTxWoRUu?=
 =?us-ascii?Q?h0Y26UFta9IOj+vTfA2frwMSm+URy+jfmqzvemiEPZNp8kcMvR89vJIsROOI?=
 =?us-ascii?Q?saMud1mjhEASVaL5urlz1nVUmhxqIgZa8Db+YYHu6/MSzDn0avFS224ys7g9?=
 =?us-ascii?Q?0hdPTZiXhfLHgT/dcONm9dAU/UPElbpIuGuO1fdXQtEMF3UwL+2Mny99gX0B?=
 =?us-ascii?Q?z6xTEai4hp51JzkUNkrYwoV91U9NxOOmrLpyQzjtiFn+qqjztbaUeoNVGyye?=
 =?us-ascii?Q?5qR4BCDnjJMiGSFOSDEjXZsPeaW4kMW/9MHyVNwE6GEAqdkayfyGN3l/zxTa?=
 =?us-ascii?Q?qhqzwSefSXJKHEJCWw5v/IEyaMNQbcCL83kNE2akWMEUaIGdShrLdgOQJtjJ?=
 =?us-ascii?Q?C2rk93pypyaV5d9Ca79MmBxsQw1Zdu0g/g6NZW0wWcP5gLZUEsvrvS0x+5AO?=
 =?us-ascii?Q?E9d9GgRVG2mgqJLLCEAIKlATIqIc0+1igQ9TAqlQjjKRnEtpX9CBuJxRpzxN?=
 =?us-ascii?Q?goVMeqvuFKQBJSTu42IwJl3f8KgdKIhLSAoX8RixxTWJDrcEgZzEH0Yhtinu?=
 =?us-ascii?Q?LctRTefRhz6kAufSO2uIQrpzSW/O9ncMSV9/tleB0xDQFF7iMMFA/DHTA7nZ?=
 =?us-ascii?Q?bc+uY7jTLwfdvh97uYAG0fzx3AHqdsNI+M0OaZMv9XLGaFno6RMPdZMXXkQt?=
 =?us-ascii?Q?0n5K92zJL6ywOdoQeq1vJD+B26CZPROQVagK70buQ/wbDLioJxTV0LFtiGnp?=
 =?us-ascii?Q?/FhNuyS8lW/uswPfFXXChPSWE+Hd016BtN7kDfPHfhqXka1V0qV8JA26U8qP?=
 =?us-ascii?Q?Y2N84JtEbpu9GLyw+w1qsduk7nfNS7azo2P7gPcC4nEDZS6zBev4u7QwE3UJ?=
 =?us-ascii?Q?CYR+VPu8DWJSpuO9ni4PeoBpK/W7V20e1crYQdH5Wq2+yc9MMZ6EVU7UDmt6?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yxzP8fs6Bwar3eISGJn8l71eBAoC+NYxS+PLmLnPFQV3lc7mCsEhoqAuCWsTfLNFGhJ9jJOUnlsositLckW/DB4GpgfZpMmijyQTHeliYmbGRaRD9dHq8PiZVwi9NIvrQiGQaxTOkfqID8wIqyxFNhGYfUlnePTGqBgEUxlUz9VusX7v7DFVznRLwZx1P+DOevegArJ9k1HsC6sVgxMKh/n6CREsdRrLFhvgtYjPYa/T0FB6Gn2AW002jIY4iTb4GM08KASbCRgSxRwnWSoV+JCVA64RAOQM8tvC/lC8ocQk/55y7kEfSTtUZxc666CCPxSsIv9XkA+qZ8PQLwOawq0j2gwCjOEhh38TI/SLIMxfieAEDr/lyzIA6iovb1l5O+zFKNNziciqAOICxu3CMdtWRpm3wAjPj2ybkjQWGi1LuxiGZy+cpGH1zRtWoeyrboQBCKL9BoZ3+npidPzhspSTsDHpxK5OpSRbYh6s4a1LHkRbd+xiIoxOZqtmWJEGmvAp73N9QRYsi9R2gYK4dAhtngpub3LR0OkKVbLsFSMxxZ1mhY4+mD3VJmQqbZ7X5L+3VlN43BIP8GU25zdUd79iMomqYGv/FUOfJsYyU58=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec4581d5-a9b1-48fa-31de-08ddd4c96c5a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 09:12:52.9889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bU68gXamPjqK/Xdm+MI6Q2ihEZ2wv6Uo1jlgqop2iY19cJweeyMTjHQVT4LjqvVHCZvzCdtN68y73NWEPZvqRk9Vy6xHKRioArohzfxkbOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4251
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_02,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxlogscore=946 adultscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508060056
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDA1NiBTYWx0ZWRfX8Z9HyPVabwQ2
 1OHezKbC3aGT/6QFVFAJZhvk3qRKsSy7o3Cc0rT5eesSafwYibKVmcmHBXXqGWR3/iDEqH/q1is
 Y12csSNWqHamrtDNMvD6USRFtdARpWwCdr/ifjKzoz/FK/XOVn9ByyMyfI8UUT7c+KpPB8TjvY1
 7wsjg/mBYPyDmDd8cAlQk4O52wS07/ORzMThOhjNnqqQEg0HxJhuII9G5G8elhY9v9Si6ApmyPb
 AbZiOCF4E4w4Q99rf2EB+HaNRpy1KEjb3REByguyYg2FCkhUHnYOQGG0p/1BS4EucLDsOJBLKez
 n/Ej4nCQgxz1bJEsLjiuwzaAixhtmBN8gUt+jBBbRVoBIVVZPmtsnHzpvLAJaBc0lszvrr5w8jm
 R2LzY1iclejGKBm0fV3Xj7wnVIF9DQvJDG7ETc8Fe/6sRfILocDZjVpYRnIhEIBacefCLEoa
X-Authority-Analysis: v=2.4 cv=RtTFLDmK c=1 sm=1 tr=0 ts=68931cae b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=7CQSdrXTAAAA:8 a=2h73JUT0t-xPoLk4wx0A:9
 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12066
X-Proofpoint-ORIG-GUID: 9onIeXYM1w0DDlsw6_kvm9NxTRGlAnrY
X-Proofpoint-GUID: 9onIeXYM1w0DDlsw6_kvm9NxTRGlAnrY
X-Stat-Signature: 48bim5t1jb1x7p3khtcd8gymfhdyeuoz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 05287A0003
X-Rspam-User: 
X-HE-Tag: 1754471625-248191
X-HE-Meta: U2FsdGVkX1+c192ywTMqpEtt+vkXGF5oyCA0ZxoLbEkSR1azRwKkYW/pi3IY5n0WAY/YjE51Sr3tJac/dk4WR8ziEWVZH+SYtxaCAjgedWBMBRl0qY+h7n9MMog8h6A7gNLQ4XH/FqYc1zD/sNoaFXgt6aWt7srgpt7hkgG9khpeV++tJgPTRTH71PIz7raXv8DpXpVnf5IS/3ufULeXtKXkVuwu4EOzWxKGQz22zGEjphfnDYxsx3uvXMsLymq9ZgF7SbqZF3ZzDt6b3x4WqomsiR3ah7kCcCG6s2rpwAX7IJI/OEy1rYcwC5fofzYS+VR4Mm7Jfh6gV3xVLaEoBhxqhojVp7IG2LtzyUaZsgklgeAsdbdaEW/RbJEiG5nH4YXlAAudCjZTq22u3IOVCUkAQgH9tjbXRJ1QkuFs3pAVezS16I6b4lChqkJgqdq1FIQO0yoxS4wXsd48xchLkBdatH7iBsPNQmT1hL2lVgPzcKTSKqgS0GXy0LvL7R1zGMSgnvUTw5d0uO3ZoYoOKJtAofjHTFYuO2mkoOXzu80SsRoLHvW+wBNd9TcAnBiKjlbPeeBfdUnWLQxNnwPhzAUybEkXd/Qp42ODome/UVOg27DeJkoyOl5y+bBE1ik6iWzRaVoISRzUAI1d+aXM/OI1YHdH938sJnmLO4UWRzHuYCDGWJbkvObLVOhQonH3eScVFBsoe8fZgExbwDrRY8VNi9afxgeaVJlZe47A7EexkLGaNgdUo8JyFkGt12qKlsENXvv2Fik/p5jvCdrwSR+5N8wPGfUgyHJryLd7cjywWZbxqOuUsKeMxnDBKwIWimi58ye55/S/gGSg2ancQk2uvkZMNadWEPpxfnx5LMIpehniOt3RlK/nFDSU4/+ugbhWZeB6+NtuYBcdNiHVXHT4ncGcEq7jZSyMWblSFuFRrtyYn+UAh9kBXmfxyGfuKIbBq9mGjy0MfL9cZQ0
 fEFcigV4
 hpXYPmyGpiOuqWnJqjz025k1W5IyHA3dHJ8SFFd9QPLI+8eolmbIT3rWgVMKPW3To8J+0I0Zi/MDvKM1e5S2L6fD/7jT8j6xJ+xcrjCU9THW1H/0bHbQISMmsskHzxW2sWOX6OGVKU5g56ojmzjOQyUIDwQIM+EQKjxQElgMS5hOWvVeYftzCR8IWMTXM84QRrzGAO/fdgWauFidnbqvTKQ7dRdMfmxvKfAHqkjvwllVPAGwS0fPTnnL2SFt6fNEq9Ti84SNb+ap0xkDMgDC7FJmyTQk8kq8vi9T55mk6G13CNEWgCEu3oDiDmENyCDoVPQuNSt0ZuwuOpeQdOBTmIakTehubQSRcUQ9tLPRfJJg44zbF1OIsxqWy1MnS0uxboXnZ9AWIeiuxTTX4+3Su3idHLM1QrlaG1uqGeteEO05g0K5x0q8vkAdYMMLKHZ0ueD7qEwfHP+R+S3BMaYUmW0FkiNvReqftibESsBPN2EG6Ymg0ymyPub/2BqWe097dnTM3ywRVoiIJXgTxx3BasuHFCbF5rfVZIZBb9XQbowZbn6owZvIdib2Ua5VXY7/xlnjuiad6TfQLymFEpA738/pWTwKLuRuX5jFZnW9m51Pzxo+7Tpu0FiPlqVJhqn2YRV9qNiSd7WbmlKbyaCbXIgHKbBGKCImI+vYBBFHyp9Tv/64Bd/KojeGXLjK+JuEgvkMbvroysM3Bk6OPULzwNPR52qi5Yy6BBUqIWV5QlR4P2QMKQmD3Do949CkdSTPLuEYLobbnqLbM8AHH+pCwVWZN4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 10:08:33AM +0200, David Hildenbrand wrote:
> On 18.07.25 11:02, Dev Jain wrote:
> > Signed-off-by: Dev Jain <dev.jain@arm.com>
>
>
> I wanted to review this, but looks like it's already upstream and I suspect
> it's buggy (see the upstream report I cc'ed you on)
>
> [...]
>
> > +
> > +/*
> > + * This function is a result of trying our very best to retain the
> > + * "avoid the write-fault handler" optimization. In can_change_pte_writable(),
> > + * if the vma is a private vma, and we cannot determine whether to change
> > + * the pte to writable just from the vma and the pte, we then need to look
> > + * at the actual page pointed to by the pte. Unfortunately, if we have a
> > + * batch of ptes pointing to consecutive pages of the same anon large folio,
> > + * the anon-exclusivity (or the negation) of the first page does not guarantee
> > + * the anon-exclusivity (or the negation) of the other pages corresponding to
> > + * the pte batch; hence in this case it is incorrect to decide to change or
> > + * not change the ptes to writable just by using information from the first
> > + * pte of the batch. Therefore, we must individually check all pages and
> > + * retrieve sub-batches.
> > + */
> > +static void commit_anon_folio_batch(struct vm_area_struct *vma,
> > +		struct folio *folio, unsigned long addr, pte_t *ptep,
> > +		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
> > +{
> > +	struct page *first_page = folio_page(folio, 0);
>
> Who says that we have the first page of the folio mapped into the first PTE
> of the batch?

Yikes, missed this sorry. Got too tied up in alogrithm here.

You mean in _this_ PTE of the batch right? As we're invoking these on each part
of the PTE table.

I mean I guess we can simply do:

	struct page *first_page = pte_page(ptent);

Right?

Presuming ptent is the PTE entry we are curently examining (and applying
the PAE sub-batching to etc.)

[snip]

> > @@ -221,11 +318,16 @@ static long change_pte_range(struct mmu_gather *tlb,
> >   					/* determine batch to skip */
> >   					nr_ptes = mprotect_folio_pte_batch(folio,
> > -						  pte, oldpte, max_nr_ptes);
> > +						  pte, oldpte, max_nr_ptes, /* flags = */ 0);
> >   					continue;
> >   				}
> >   			}
> > +			if (!folio)
> > +				folio = vm_normal_folio(vma, addr, oldpte);
> > +
> > +			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
> > +
> >   			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
> >   			ptent = pte_modify(oldpte, newprot);
> > @@ -248,14 +350,13 @@ static long change_pte_range(struct mmu_gather *tlb,
> >   			 * COW or special handling is required.
> >   			 */
> >   			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
> > -			    !pte_write(ptent) &&
> > -			    can_change_pte_writable(vma, addr, ptent))
> > -				ptent = pte_mkwrite(ptent, vma);
> > -
> > -			modify_prot_commit_ptes(vma, addr, pte, oldpte, ptent, nr_ptes);
> > -			if (pte_needs_flush(oldpte, ptent))
> > -				tlb_flush_pte_range(tlb, addr, PAGE_SIZE);
> > -			pages++;
> > +			     !pte_write(ptent))
> > +				set_write_prot_commit_flush_ptes(vma, folio,
> > +				addr, pte, oldpte, ptent, nr_ptes, tlb);
>
> While staring at this:
>
> Very broken indentation.

Hmm... I wonder if checkpatch.pl would have picked this up actually.

Yeah that 2nd line is just wrong...

>
> > +			else
> > +				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
> > +					nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);
>
> Semi-broken intendation.

Because of else then 2 lines after?

>
> > +			pages += nr_ptes;
> >   		} else if (is_swap_pte(oldpte)) {
> >   			swp_entry_t entry = pte_to_swp_entry(oldpte);
> >   			pte_t newpte;
>
>
> --
> Cheers,
>
> David / dhildenb
>

I think on this series I was so happy to see the implementation evolve to
something that was so much nicer than it originally was, I did not
scrutinise the impl. details of this one close enough, but as Jamie
Lannister said, "there are always lessons in failures" :)

Cheers, Lorenzo

