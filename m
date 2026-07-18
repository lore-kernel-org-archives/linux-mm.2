Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6788C4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 08:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E05D6B0096; Sat, 18 Jul 2026 04:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8786B0099; Sat, 18 Jul 2026 04:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A80B6B009D; Sat, 18 Jul 2026 04:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 397066B0096
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 04:03:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A2381203F2
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 08:03:38 +0000 (UTC)
X-FDA: 85001158116.22.6298E7B
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013004.outbound.protection.outlook.com [40.93.196.4])
	by imf27.hostedemail.com (Postfix) with ESMTP id 669D040006
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 08:03:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=byBpDrt3;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.4 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784361815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OVqs++Auuevkzyyg6xlAKDSGjZxnJRX0KVexVR8fmec=;
	b=l6pxh8mLGc1HXgBCzZuoyyCaoiLcepgWAjMUE6IjYpJHNnGsDr0BMbGNctzo6Yc8l8IiuC
	Osz7UNlACggHEsCd1juFkTJcgbS1aRXtwycACTKVADV1gbiLxozs/AQrzTJunf56ZnhzZZ
	+ZOUzlOeoXGN6E1qn5UrRUNb0LZiip0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=byBpDrt3;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 40.93.196.4 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784361815;
	b=adt5EVvHvSJax77Z78HN5w6F7eVANqd1JeRz6lQp1J2dW5ZnY1sQ9u+04N6e6NoZku2W2E
	yTGFwugIc1LHLbqze2mxXw3GpUnt/PBnxpyoNNbLgMu+UTnWaNiLqtW8qlQHuBlcY/O6eo
	xyuXT7FNOdkI1tK/6b2mrCv88Idy96k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ugeTnpvnXV+A+q3QB9S+dIimr/KFSvZO7B5c7RWBY0smiT4JF/wllYa5VA9SSdEAfwIRaFXPrvRFF38KtcVqNTco4PNA1/3AZHWRPTzbkmSeIn7dOrf57CaN5zYSFC0c+Kxq7U3fl1LV/WHrwuKax0HaoP3hp4KKwvNwTS/E65ESbtpnwxBWaRxcUJ7K6yKZr8W84ikmvx3o13sxOSsfFKtkOQInqdgmPgxcLH8wgWCt02OkVlkZIinjcCzT8J7fWMOIEvWnELw1lLgRamavSwfFcndeUkoZ5YSMOT/gS7lnpvrzIgz+9gUugFctHJ81c/AAJoGuaqK2NIHMQhblAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVqs++Auuevkzyyg6xlAKDSGjZxnJRX0KVexVR8fmec=;
 b=xHGzn/idm5VyziPcX8s970skSz3UG2dLRFM1JOPm35jXXMuaDbGgOfff1fLYJ+jZx4cJPTSWSrI8ccevZl2067RAsJRQTaYYsRHPRgvUFMichZO3e2wsi2bN7y1mUhrLd3oexml6gWuUoxC9aZY+vZZ/uU/czuysQb5YTJo5EgEXEnu5BlfkyH1LwEacYW6X7vzSnYFcZK8leUrOHUPm28UbaVxyE62UnBgr4rSxD9Uqbdnnw1AtNx8m7LZxl7l/8qjgZgZEC5vreVaajqAvt8EQs9ga+1OVUh6ZRSSRpN8bT1dKZlrEEZgSlo5nDURFrFLEgyvirQmvoqt5yMEzDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=infradead.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OVqs++Auuevkzyyg6xlAKDSGjZxnJRX0KVexVR8fmec=;
 b=byBpDrt3IR4uK4uVUZFJuhcYlyvvIoSpbx3/opQ7s3XBNR17NWAgVCqZedRo7LXDXOCB1lOOrqb1zgREvPfAcEEtUWeJ8KFmBIcfumZs3MSNekbCYrF3LWvR+QbScXDp4npFmgwTxO1PqliqCdiPqTONs5A35Q+kzyuYrTUHqo4=
Received: from BLAPR03CA0138.namprd03.prod.outlook.com (2603:10b6:208:32e::23)
 by SN7PR12MB8101.namprd12.prod.outlook.com (2603:10b6:806:321::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.13; Sat, 18 Jul
 2026 08:03:29 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:32e:cafe::a3) by BLAPR03CA0138.outlook.office365.com
 (2603:10b6:208:32e::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.13 via Frontend Transport; Sat,
 18 Jul 2026 08:03:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Sat, 18 Jul 2026 08:03:26 +0000
Received: from [172.31.34.103] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Sat, 18 Jul
 2026 03:03:24 -0500
Message-ID: <48321c18-45cb-4400-8ddb-fddae911eab1@amd.com>
Date: Sat, 18 Jul 2026 13:33:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: add missing kernel-doc for @migrate_info
To: Randy Dunlap <rdunlap@infradead.org>, <linux-mm@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>
References: <20260717022146.1290242-1-rdunlap@infradead.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260717022146.1290242-1-rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|SN7PR12MB8101:EE_
X-MS-Office365-Filtering-Correlation-Id: 207a614b-25be-46e8-10fb-08dee4a30be3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|23010399003|82310400026|10067099003|11063799006|56012099006|13003099007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	B12NqM3yJO1XOK19AQ6pqN9K5Mptr0MjdaSbeg08HRhYlq160lwzsIHSvlxrCpNsPtIGOr74O8Q/KduCpW8WZmNM031P6X6CI6iB5Hvff5BjV/I+eDb/W1/4bg5t2i+TM2/xS4uocQJP6+BDpp5fOxBJ4T/clykmuvJ7seHyJiysphlHyomk5CEE7sped+RI1NLxClBxdQKhIQItSCe9EXhfjQNWyF7PVWZwh2nqzm3+Vos3zr0uEOrk5I2IqhXOqfRdjo+C5qgUo9hZnCnZ20q3E40vQqgVRv3zvglBK3WcJZ/v/zIKWFBBSpbdMXjB6itoEqO4B8qjYZ9SH8UDl5myXKXxpJ/TVPGgWJC6/+c9WCZOmI4487lC6x9TIAUwBbBzVCKMbBiidSKzJCuclJxYK0MZMV/51EbR6zU//90Ygs0TkZFw2GYtKH6PfWd5aSiHLDcvc+siWT76JDCDYzvloYOryqL36i9oTqlvcYPSLVlD3cGVsthWtxGoWyu39qJf4nw9S5qQldhkx2+GJdeIB/rncv9CHukp4P+uxbN1Ky3Z0E+LGa/2OjYSMeNCFZ/7lqHYw1Ppl/R/RhSQClMxw5xWMXNHner54zMdbdW/xglYgKyZ++B+7psarzhf2px13nD3/FVSELmOBC6x/g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(23010399003)(82310400026)(10067099003)(11063799006)(56012099006)(13003099007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IKaRmwsO9S/Sdy562dEEdAMbhWpGjNwlNHKEHJjrFlDo00+Ezhav9xmRHXlSJzqv7lprhtczQ5LvSC2M36c0WNNbOrQrkefpMW0S1ulscoTK+vZGmeiSDpL5A0egVY20TND9doc08zpOzeEd/8QVeJoND43R9MEa5bD3zXjlTzNfVsgZUJGY2FtLnfuBbaiIltS54WvfMmSvq4jD9SQHMMg4DlJkRjqGgnp2g0Qy2Qu1TS9G+Y4aC0nEhN7SQW88dYluA/LFuyLyd6Xaa19NyeDJmBHkGfn/ndFxoWhYioVcrtoTCmnpI+5ZfZzqr82TilaWjSskgNhUewGG+pRYCqc4amMwYbZOMqoVJku0DshqYNw71w4ywZ6xax5BLYj8sLIGqAHHw5e+KPO3pS5lrqZBB57/lUiWSA5GRNiC+U3lc7NnanOxoJ2B1TVcpjYE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2026 08:03:26.2991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 207a614b-25be-46e8-10fb-08dee4a30be3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8101
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 669D040006
X-Stat-Signature: dcsxkppu6kmja4asj86o79qh3qtuogz3
X-Rspam-User: 
X-HE-Tag: 1784361815-844533
X-HE-Meta: U2FsdGVkX1/ZAGYqiEeBFA4liEV+5jbXlv2Ay8+mu5uAZPwQNpMolmYrk3VrUhUseR3YAFhHkyaAR4zgWG/bWyyD3SwrauQ/KGqzLpGB7cobHQhmj/lLXfdsXvIgy2lCQgCeBGmsaqIV3z+mVVtDOfoCosLeZAvR+2b5JfIIB6hhr7qP3/0kml1gIFeitF3mJJtlHvdmQfBBAzdXe9AaaNSlmX6M/DqN1IG37NXj9szVhIwNdc+oYG6AqaajbmQuobqsVxmyPmhyIbsFjDui6Z3FnbqUohGZnNkTvBtfvdwF7OsPmbWbmUYzqA72ALqw347Tnt9KkCHgYdDiOx+h6zRbg2ie0fMvGC9BA6MiE9+hOzypcg8JacukYtQj5ECH0hyntNyd99Mmf/aT0/9K0F7qXTcAK4cuXrw7zWXb5Ts7qFtJhN2d2sksycN0odojawxfwP/EYXy1+nerc7n6Ww+ruMT0+Ina0KHwsqHUKRvnH0PlsBjTJqCrhT955WCf5Qv/fpkpppFJ7LdJCyTa6HW7nRI3GnCXgJL2MlSbu6xW3iAU7M9SjXd1Oee85s1eBeGrjDTG8afW6fC2OizJyCQEVnl+kzMwcp4zknm3tKncckkdd+rmNZgnmIYq1AK8s5eX1HUGoJFhPHYzmCFIRI/aFdjigo+TOJtpMD6+62KTAUbKskMb7vpGmFsyhhcZQKbcoysBl7Ix/EXx5Z40LuT9Tvh9i/+KW3sxZDCUJDaoZfjyKI3PHfohS90CMQ0lMGpG1Iqr3puZ1DeBaoRpsZhoibpnvqvMIyJpqSWDS4Bf9az66z6+IwteHQEdUqhZtqlSYtlaEOAqi+8SPI2oe2ElPFDjZgtqYlGxFDqbQG0NVAbEMF8Enwe9VEwiGXbMHqaN/+sYJl5QjUuiuEAjb/GULMgCyWqf+wuODAuMICUmEbDunlelzRDYlgGtGqrv0FuP67aVmTi6fLFlUMQ
 zDUAf+vI
 PDhlJcDaLNSx9c2Sd9oVkgamCJR/V7Vxf9xFvbMnESn6mzbN2ULXg2Rr3fU3tpojt7TYBfcLI+lKDL3ttuv5hGapZGUMTxvsOIrekoMthZsZQyhgQ6HOlugKbKyvlBJ8vLhYHlTDgTWwJ78Pb/LP+phptcpuP7UgsyzHRTFKd4L2vyWT5ANwnCmd0MsesisC1GC9tWX0eHJ/Reoew1aCZRm4UAp23PeIErTX7324DFBBujvzBu41BLEgE7Cr27mbEfj+KxOeEFrii4ai/gNbJ/1XigG93dCLjaJ+UezaldkwMHu/7RC1HNH5FegQTL5IwippjA7UtKlHCv8sBzoZQRDA7S6NhzcY5xZsN3jPObammtoB+eP+RimDBnWWuCeYzDcsZLOh4YLh6IKOgNLF+KC9kIvVuGbTUqOvrsYCGwjPq4nUtwBtJ9UOVJZKSBS8EOXYpyxhCS3g9xIefYqOTwMuHU97bQwMpNWks+rB7BtRbj0nl5P2Wjc6OQZtpk9gtPfmGnFQu7mIzemhrEVctLBonI0M/8TQ/J5ZmzZzHuC1UY/w9PMsnRdw2j4GlFraM3WeCavrgNC+PBqB2uD6fbHu9LyJ05WFRNztZkw+K+yG0gVMfkmT4PNjIH0P3biFh3EY2G6eziokxdbFWNamgf1a3a/6R58ftBWmi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/17/2026 7:51 AM, Randy Dunlap wrote:
> Add a kernel-doc comment for @migrate_info so that kernel-doc won't
> produce a warning about it:
> 
> WARNING: include/linux/mm_types.h:507 struct member 'migrate_info' not described in 'folio'
> 
> Fixes: f3768940afdc ("mm/migrate: use migrate_info field instead of private")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Shivank Garg <shivankg@amd.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
>  include/linux/mm_types.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-next-20260715.orig/include/linux/mm_types.h
> +++ linux-next-20260715/include/linux/mm_types.h
> @@ -368,6 +368,8 @@ typedef unsigned short mm_id_t;
>   *    dax_associate_entry.
>   * @private: Filesystem per-folio data (see folio_attach_private()).
>   * @swap: Used for swp_entry_t if folio_test_swapcache().
> + * @migrate_info: Stores migration state (anon_vma pointer and
> + *    FOLIO_WAS_* markers).
>   * @_mapcount: Do not access this member directly.  Use folio_mapcount() to
>   *    find out how many times this folio is mapped by userspace.
>   * @_refcount: Do not access this member directly.  Use folio_ref_count()

Thanks for fixing this.

Reviewed-by: Shivank Garg <shivankg@amd.com>

Best regards,
Shivank

