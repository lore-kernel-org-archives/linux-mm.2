Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5096AC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 15:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA776B0092; Sun, 27 Sep 2026 11:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B546B0093; Sun, 27 Sep 2026 11:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305426B0095; Sun, 27 Sep 2026 11:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 049336B0092
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 11:56:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C38A80A56
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 15:56:36 +0000 (UTC)
X-FDA: 85259994792.29.AE48A76
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012056.outbound.protection.outlook.com [52.101.48.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 353D0100009
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 15:56:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=w6EBatrP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of bharata@amd.com designates 52.101.48.56 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790524593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DtvxkrbKH5BzUKC6vQ8eHBz0oplGKGRcpEtJ0Ojk9cM=;
	b=pt4A0dpBa0mlqfMCz4Um+mW8LTi4BSoQbU8imVQ1bnrXrxDM0+LoBmWWZvl5DWvqB+uvN1
	AYCznxFGFTpIbRrAE7JBK4POWtUMYFBZi2layXRVS9tzH3ho2GAimk1IDcNsZKFfiCoGZJ
	dkUvTs9xgGAcJos08uiNFn4NVgD9mEc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=w6EBatrP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of bharata@amd.com designates 52.101.48.56 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790524593;
	b=qFZjsMTNxNoknVLbxNFoK20QlmtcNqnDch2DXrrvbCGIpSFbGYvdlJU7Zd97NZlEfmrKBc
	aBQ/0s2rcCwZy+AKXzmwFpA6HqYOMAHi26RR94bXQha9Xn3lFCKOGfaOM/TfRptcVaR4xG
	Up7M4+rZrQ7t/P8/fZERUqpAKt7gImo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CH6bqmg2TfyImYadUPNHk8oqpBb0nZnw9nnqIKyny8Rk0JcnH2dmJ1aEyT/QqR316iVuioDW7QLls1rEMUEhhoYhbuJGIVgeD2yyHKLymhFKcmXndeLvr5o/sesUHgBcFUbhmf+WwucUHlL0tiPLDzcW4yPDnQ6pMpT2gDZzFzf9W6dcBMdc9Lq7iUrMumfkEaIS9UG6E/QaaRY/6u1P0aRNSkDQyPiuqMCsNuROndwbNVS1BiioIW+1Db5wqp9bMmqz5EOjPXOiIG1YGnG8vb2ZkQvLP/TMvQ7mmRwfpMY9o9Ee7oSvLUQj/6KXkg/6+kHTVOHQoSCUDjMB8Rtobw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DtvxkrbKH5BzUKC6vQ8eHBz0oplGKGRcpEtJ0Ojk9cM=;
 b=T+CE6MnmN5eZzQXioCb42/0bTUhogyc6c969eRwyzldEN7d2aDD2z5DSwfVl2jSXHhzFHU+JgseTYu671nJbDvb83eU+wSoUwDVuZNEQKrWx1qzoKiZsKypSfD3zGBHXuXDGfgzmcN5p5j9cORQ7pczNf4TVeCYGtLULZEiXzEyjhO+FSAdAnoSk943nivM61GUNRVYDhVMkM7+GT3Yj3nrhuyOv7y9X0TOTQUwiNTb39aGH7A7fmtWl5iA/SORENgjP/a4EEvgK5F/ZNQmWGi9MlFYUzjYEooIfdLdHhooLbTMnko43IdtpBypUPaZj9q/6Dijtdr3exBp7c5PIrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DtvxkrbKH5BzUKC6vQ8eHBz0oplGKGRcpEtJ0Ojk9cM=;
 b=w6EBatrPCCgV9+Oc5oPZCtK/6zw139t70LsTydKDJTc3zuLQtL+JSsE0FEiuo7ydXnrB/xC1VQtIJF1bpQkI5LPySKcZIsWB7m+wrfR6YOWRb0ddDAkqA1dkzdPmOtyWJYPTZRBKrEo51ineTwZSb2IvBIdMQDinb2YZuGu1P50=
Received: from PH7PR13CA0020.namprd13.prod.outlook.com (2603:10b6:510:174::27)
 by CH1PR12MB9600.namprd12.prod.outlook.com (2603:10b6:610:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Sun, 27 Sep
 2026 15:56:25 +0000
Received: from SN1PEPF000397B1.namprd05.prod.outlook.com
 (2603:10b6:510:174:cafe::83) by PH7PR13CA0020.outlook.office365.com
 (2603:10b6:510:174::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Sun,
 27 Sep 2026 15:56:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SN1PEPF000397B1.mail.protection.outlook.com (10.167.248.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Sun, 27 Sep 2026 15:56:24 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Sun, 27 Sep
 2026 10:56:24 -0500
Received: from [192.168.0.152] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Sun, 27 Sep 2026 10:56:20 -0500
Message-ID: <e327855e-3a3a-4bc3-afb2-4f241a92adcb@amd.com>
Date: Sun, 27 Sep 2026 21:26:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Linux Memory Hotness and Promotion] Notes from September 24,
 2026
To: David Rientjes <rientjes@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
	Fan Ni <nifan.cxl@gmail.com>, Frank van der Linden <fvdl@google.com>,
	"Gregory Price" <gourry@gourry.net>, Jonathan Cameron <jic23@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Raghavendra K T <rkodsara@amd.com>,
	SeongJae Park <sj@kernel.org>, Wei Xu <weixugc@google.com>, Xuezheng Chu
	<xuezhengchu@huawei.com>, Yiannis Nikolakopoulos <yiannis@zptcorp.com>, "Zi
 Yan" <ziy@nvidia.com>
CC: <linux-mm@kvack.org>
References: <0c8a7227-c7eb-bef1-7326-c7b04cde78a8@google.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <0c8a7227-c7eb-bef1-7326-c7b04cde78a8@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B1:EE_|CH1PR12MB9600:EE_
X-MS-Office365-Filtering-Correlation-Id: 94122764-05a0-4ba0-7b70-08df1cafe234
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|7416014|376014|1800799024|10067099003|11063799006|921020|18002099003|22082099003|56012099006|13003099007;
X-Microsoft-Antispam-Message-Info:
	IMGtYQB9RiSKiEjKOuraMh8ja4T0kuteQ5cnmIqUHqfxM8XN7vxJXPsZ+e/ZvVmKtuuYhoUAfBUSE/4wynFRwNVM+mFt3I/HFP+vfK98c0a0HkPH1PrTd1ajA688C4cxosb/WZMam8ik6qGd34QYnxeXPBEAZmmIQ0BLzvgfXVS7N17tNLhniewDwIWLo6SQMiXszf5BXT63NPlioeNfT955VP14eucsCs+4rHoxAxbY5BdXSQ6G2lz4MHhSQXEZuSfrDXOxtl6qweDtMa/xgXhxcKK7F5G0ZFkusoIT2FfGCGpOk5TIkL9AKCKftHDRZrkOtdYABCDk1ZXMf7Gb83BFYba2qEErU5ibUKYTdlHmB1mru5YvFQ0WfHah+zzThyaNrRK7LVWOx43XAceOYkSOficbz51KN2uhID6s+w3FJ4KqT/ac6MuKsgRFfST65jHZnVKgfEzNUOl2QI5aVH5BiSW4MgrmB5RJplt+Pu+/hq1dG0RQPqvwnYeZRX2QYhqh+IG3ltm/gzpLnCb1fpITo0NocuON3Zk1RyCx9+WVgRXHSvN7J3sPCzj0UWdrxmYkgteOWqXiSkxZugpnABl/vsIzgzDSaJ51fhCuT9oyZi6PRAC0s450LzTW9k/gHUvim4wIPXe5gtxcXDF6yozI4/YrdFrX+AT3gtjxvZNSLNrUn7OLADkvHk7VWa2IjOCKVE1BVCsBlxeFlURvlA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(7416014)(376014)(1800799024)(10067099003)(11063799006)(921020)(18002099003)(22082099003)(56012099006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LyoYusdzyiwVElJpz/UR9JLckotI9JIoK+i4h2QZkWLM8OcHlWZEt1fXZQn2NbyNlC/gpmtd1tCrHsvwkqCNNjIfcqLbw8LBEgD46kGtHsnaG6VZ5rQ9u/ia6DNRc5EXa7ZYL1h5MSEO6pCHb5tWDjKOZQ7yO5CtdblOuue8Pm6tS5Lz1wmeaxNgfny0hj/mU63zt9KYN+zBhA5kV0QDS/p0+ZM4yu8m23wEyf3BBvmiL7bkLv1WqMlykweWoJGj0L6axrFm7IF6EW+Qcv15NTNAfjFYL31GC+i684yegSnhT9O2MHkd7wNl8RrMth+t+vIwV0ksXyQMaDfn0yoQ2D6ZSD4HwqlZh9LKR+GX8iGcA7E7qmXyMvzgLa0KhQfgS6eAH+4OgIaEvnoIDwxGMuPi5vW5MFD9tw22vWIqLUOj21l0wI5PQxEcizTCCJs7
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2026 15:56:24.9233
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94122764-05a0-4ba0-7b70-08df1cafe234
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9600
X-Stat-Signature: 96ugy3fmofiw1my1qtez7piqg5q17ha8
X-Rspamd-Queue-Id: 353D0100009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790524593-999988
X-HE-Meta: U2FsdGVkX1+pUcrXSupGcVEmZxitzhQH6XpI9ZD4P82a/UjmK9oV31aGMO1rhlSQ8VeymxosHNL6MbMCl5CgFkdYXbvEgfhaN2yc3T14pSCbALVkWqqaJdxZLs9zbLf0iPrzWiALKHZspLJZNtLCYnNpebUH+LnDLsDv3YOk1O3SKQMY7IdkaDu6cbQITSf38/GNKXXjptBvYLqYvd6ShJ60gIQo+Ba29kebPq5IZzFyWw2eLVbBmU89Bjb7PDt6QOWwJVE2MOaoRP9ZMaZ49JbUM5sgZ6t9SHPLgzXUlZR9NGY5Zbt2ymgbIDDpmnLHFvT6spU10UizNIffqTZ6pSvUiF3N/YtxsQls/7LyJX7MH/P/UhZ4s0T70eRVDzRxc39ygp/R/oFYF1zoGSs1HoqmWey23hAIzyLgDePEtio4H5/j3UUghOma0fdARLCu4Zl27EZrCXVTA79Xs6wlrQg/2MiAGwNIUz07G65R81JQlHHrLNnOQ+My0o8yzbQWDwvtQRWn3wJCemgvOQZZkBP4IhQyFFzK9Vlz/R9p8uHEw32rbIn7gdc1bLOJ7+oun3+vxGtu1dySPrJQMF25O3JjF530VdvBUAPTMY1b5hZgjSw7MzD3n/J9TnEvli+4VdiCMme7O0HqvRSt+Owt4/Uf7y1QItWixsPs9rYSigeUTS6rhjBi3fH0NfMNqv788yvqTNijUhZNEXYDnsnmU0zcpdiGdWScapSPdXIGvyhT5oSoiZFJxYdCSm7WZDUkItcWh2avUE4rWAOKBawrDy0QmLXoCpw+2MTCJzvfc8ZXbiOqOgfFltxNF4tk91KchBxv7bNEvOuWhG8foVV50uu1ila8QzntP92w3HNna1VISCx4I0GqimzaYgrVrPL6TzUqFKBFeVwz7aGFNVu4ktdaqVxYxpcQ9otCI4KJmQUmEDPioqiQNarS4KgbdQxWMNV2Z8hcBMD+4atuPUG
 3u1Nl5Sr
 iUHOp885DLCEtxTveNmCTivTsFTDJcB3Sw01h4bn1nONHFmHm5M9UnochZvLbx7SIpmkaT9M513yQhtt5dHAa6FMSsNlAp+yXi9U6TpUqCakFLKAbP5cc9WMOlYa3UYg3sq2+PZ8nWfkL1hHEHVHWGpVeuMIDdgQV2aQLvldTiYKpkhtzdWsBnAkk7OqAkS97EUJPEh0nqlnH03NH40Me83E8bv8Jb+HHS1GAMeh7KCOeyH4erHcJTFLVR+cVROOUEYB5e/tapwcnA3W5GE+ukAHxr9nSIT94UwMePgQPLsmzALhMT86GnmSJDhGAT8CKsaqw7kVF2b/QdPs+mNecjxOeo8Ee9xAK5NWMhPZ6GV+z8+jm0/vsoR8N9BTxYlkk+ssx2ogN1UT8AZvG01OawmauhyTum/YKnHwahdRcnya7/5mBx2rnzAdzIRiBzE7RB63HP/jNb8Jd9OFwq2gEVclWaDtC6IYv2kHwpkFgq24VTP5akQDcW3toZESrSaaqOVg9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27-Sep-26 3:13 AM, David Rientjes wrote:
> 
> Bharata, have you thought about the possibility of only introducing the 
> asynchronous promotion support first, getting alignment from stakeholders 
> on that, and then extending pghot with additional enhancements later?

I have gone down that route earlier [1] but we can always revisit and resurrect
the effort if required.

As discussed during the call, I think it would be good to have a dedicated F2F
meeting or BoF during LPC to reach to some conclusion/consensus.

[1] https://lore.kernel.org/linux-mm/20250616133931.206626-1-bharata@amd.com/#t

Regards,
Bharata.

