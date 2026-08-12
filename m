Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 305C0C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D30286B0208; Wed, 12 Aug 2026 09:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0F26B0209; Wed, 12 Aug 2026 09:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCFDD6B020A; Wed, 12 Aug 2026 09:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55E876B0208
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:20:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE67C1A0252
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:20:48 +0000 (UTC)
X-FDA: 85092677376.13.C028880
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011071.outbound.protection.outlook.com [52.101.57.71])
	by imf01.hostedemail.com (Postfix) with ESMTP id A88734000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:20:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ErFaPugi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of nikunj.dadhania@amd.com designates 52.101.57.71 as permitted sender) smtp.mailfrom=nikunj.dadhania@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786540845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DHCEDBErF1D1EW8S1AgvnN4skuEBB1iUgfTYIbU8dg=;
	b=HFVAKaUvJTCuKMQ+JoGrrSe4Mn70JzNcWhXmW/jSzB+hCSXWKMwpkLODcmerrMONkkbJju
	oegX0+E/tdEBBielRKKSeWeDpZjJGI1iiDdFDlSLabZWSTFwuf50rWk941z+C+L48d2dgA
	8L0OF6kxOxTiv3Vir5MwO0OcsdEvOtA=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ErFaPugi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of nikunj.dadhania@amd.com designates 52.101.57.71 as permitted sender) smtp.mailfrom=nikunj.dadhania@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786540845;
	b=HCcWkeU5EO9/X0Cu5Hm3tEXi0/flWoCC6XLd2/APVNwB4GkDMMrxDjUgQCeXcLLvi0dxU9
	rOr2azadJDQdhP6vXDKOVWw8KoCMR0Nar/4ezdIB4qTNgG+89Ywbj/WDU2CdowttTLDXpW
	I8xqQ9ZGi3loBVJKUI9hhC6jGxo4RpM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a6iqBAcsUigCZQAR4FD9reMQCvbGBWzF9ux4CmcDdJOlyC4s2TrMdd97VaChTEYjQf50gSvxIAhyk6bYFRlOe7xoTio+q3TWLZ0i1/n7mF9YYQB26x1CF/TjZ6pbwVXk7h5fm8/TdJASsElcia3eg9PFSEPfoKYUhLC1K/Veu1AFlWjeZyOA2Z/8Lasi0fRqr0dSGQzXiP8Hr3sOcqVpmDdbothbwizUzhAYoDGE4t0ilzLTKadWjNRowu2u436ZlvRgIZCCdSVWSYalSdqXrvfnmyXZPSxlBNGQlR44B1HW2Jcip2hDIYAAbRMUxfeLISYmWegaXKjdqZhF26SdLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8DHCEDBErF1D1EW8S1AgvnN4skuEBB1iUgfTYIbU8dg=;
 b=nkrqGt27O/WKIJkKYiz+sj5ni83S/t/31toQy56v/EXq9t0tVJq5S5fTZqMZEk4pvhED+09NAPEDomJOJD+CcKLD6RpXfM6VnhgZyYhf6akgwl/xXlM1/6rZoYZKC0ZvFudw4Xol2/kHQny1Igs5IQ90+2glude4p5WsGiR49MltQMfF1u+MxHZThfPRmwEYO/ZjvDCJF6FVW3GZ7SxYs9mCHo4ums5H9PhYp0PMUtQtV2+g3iwuLaFjeaUCy8/apfKOi9an4B6Z3cQXC+1Ypz1CQ014zdYDwUXvVSUabm1FO3fNQqkumxKjELU6L3WjyVSiRL60RSGCG+wJV+s59w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=suse.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8DHCEDBErF1D1EW8S1AgvnN4skuEBB1iUgfTYIbU8dg=;
 b=ErFaPugiWpSwt43b9mc9PCPRKBbDZ6WXa1Budb8k1zDHBunss6jfrqTQjMpuE9D4Hk5bNwevPFdshU/bfm3i35iwBQlE2hrMJfa/bqj3gNMrTuE6evFnesaY7FSKs/siM/aT0Pq+ViXf7xydhcE+GQimsIm806BK+uHYDDI7+Ls=
Received: from IA4P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:558::17)
 by PH7PR12MB6419.namprd12.prod.outlook.com (2603:10b6:510:1fd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 12 Aug
 2026 13:20:33 +0000
Received: from BL02EPF0001A0FC.namprd03.prod.outlook.com
 (2603:10b6:208:558:cafe::23) by IA4P220CA0012.outlook.office365.com
 (2603:10b6:208:558::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.14 via Frontend Transport; Wed,
 12 Aug 2026 13:20:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A0FC.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Wed, 12 Aug 2026 13:20:32 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 08:20:32 -0500
Received: from [10.252.195.98] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.45 via Frontend
 Transport; Wed, 12 Aug 2026 08:20:21 -0500
Message-ID: <e5311d9c-d086-4681-a470-f8b79ade27f5@amd.com>
Date: Wed, 12 Aug 2026 18:50:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] x86: re-enable EXECMEM_ROX support
To: Pedro Falcato <pfalcato@suse.de>
CC: <rppt@kernel.org>, <akpm@linux-foundation.org>,
	<anton.ivanov@cambridgegreys.com>, <bp@alien8.de>,
	<brendan.higgins@linux.dev>, <da.gomez@samsung.com>, <danielt@kernel.org>,
	<dave.hansen@linux.intel.com>, <davidgow@google.com>,
	<dianders@chromium.org>, <hpa@zytor.com>, <jason.wessel@windriver.com>,
	<jikos@kernel.org>, <joe.lawrence@redhat.com>, <johannes@sipsolutions.net>,
	<jpoimboe@kernel.org>, <kgdb-bugreport@lists.sourceforge.net>,
	<kirill.shutemov@linux.intel.com>, <kunit-dev@googlegroups.com>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-modules@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>,
	<live-patching@vger.kernel.org>, <lorenzo.stoakes@oracle.com>,
	<luto@kernel.org>, <mark.rutland@arm.com>, <mbenes@suse.cz>,
	<mcgrof@kernel.org>, <mhiramat@kernel.org>, <mingo@redhat.com>,
	<peterz@infradead.org>, <petr.pavlu@suse.com>, <pmladek@suse.com>,
	<richard@nod.at>, <rmoar@google.com>, <rostedt@goodmis.org>,
	<samitolvanen@google.com>, <shuah@kernel.org>, <song@kernel.org>,
	<tglx@linutronix.de>, <x86@kernel.org>, <bharata@amd.com>,
	<ananth.narayan@amd.com>
References: <20250126074733.1384926-10-rppt@kernel.org>
 <20260812063316.21371-1-nikunj@amd.com> <anxa3VjtukAkY4Cl@pedro-suse>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <anxa3VjtukAkY4Cl@pedro-suse>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FC:EE_|PH7PR12MB6419:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bb03f0a-4f55-4dce-2e70-08def8747ce6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700016|23010399003|11063799006|10067099003|56012099006|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	ZoKC0kyZYWdpGI8twWDSDDwTu998XtttPGzTOOY35QPQqCCcG65RhHQDRNhAxbecIiAiEYlOVrXzVTvUxpLCy2jrUYz3NJnBaNXOuhhy4bgoJ9jtPUfQlNnjgP6+xUkFeT3hrRZ4SnJL23gmrIpQ2+xHItGYdyq25lvhbhQDh4gh5SaXFVUrVlU+LpnbGeFw83zVAW6m85cFBWkHWFH1awW/0jZEq/IQs3/M/hzDK9jNMVTb+dKzidC2LbiQgnEq1ssOphNrQwe8tLqHF2AlryWfCAHXrN3agc4d0A3f4lxtnj3GFda+zQ+EVDepKYUbVM+Omb/osh5CgJm15svIx69ZgruAlDrlw1sOd+C/7apO1j1b+psKbxs4azSr3zHxJ5M/ZZoUpWMCXZp2xbI8HEMI9QwLIriEI2/ofS70JaYaGrLQ2B+um+/LnCuHJ7MICazpiCu2rnn/rnrVdpq/Q2qtqEjmmD6+QCn430aYyqyZAtr9bnfCcr7q9IUMR67NRwfzVXhQzF4razDSko3B18NBb5OQ2/0R03SoxNs/Fs+FnkUYAjLIBGvSis+HsSgKdEfs5V/WBYPKV8FVwL7rGk5/EZj77A+LV6i8hKihloc5JpimCwsdaTf2YeQdQGw7rUdouFro5xo43EVAuMxd/2WoN9Q9FedohT5HoOIauYmnmlqfuOsskrEcY1zFzhPAGkbar35sww1GNuszhny/xQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700016)(23010399003)(11063799006)(10067099003)(56012099006)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	S12wl5c9reU3Sw613S69LgE05fnqEQN8C8JUj1kFiJfCAuVa1XJyYTUaDrhqPPTRn1tzcfQ0XCOtxsc6fnQC+VwH/QVJgzpoF3dGGiQHMRFpVrUpn3BHQ8UEYHYmzuieuy86o7gv7Gghs3WGJzz4Jwe83FRvMj2ogFSq8SR0F+sbIXTg+VEZ+RFqH8MIotktIaWyYCPInYCymxZTk2JwCF6v9qLPXBQV4XJdMn1MIdCmPho8Q4b9UTMVMjgm7cm3vfPNPmBOIUfntLdmNtHJ6MNdODuvxcUF8EsdIjp5dpqWWV5WK9GmevaKcmCLpyRAIQE6ubz8EFpoLG3DyWS570e5S5v88LRC46K/dZlqtHknzpdvr0KoPUuepV2GXhwFUb0Hn5umiBkbbkPKufrB7krAXWDycSGn8IpNhTmYpIzlYS3Rv2BbqHVUFCqqAHwU
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 13:20:32.8107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb03f0a-4f55-4dce-2e70-08def8747ce6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6419
X-Stat-Signature: sarukdfzbwynx31k5rgrpjzwgmxet9js
X-Rspamd-Queue-Id: A88734000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786540845-543847
X-HE-Meta: U2FsdGVkX18zIL34FlI5IropE+bBZZ+ZnFt2QsHD1AxHkNyOz58R6y9/d5XUSr94psdTpt9vBS7OoeZwzZ0XA8DxK1bMGzq+qFe3vMvc6VjJv0L4/Kl1tSvqM6fJ46RZ2urh3MxIkIZ5VzSSndEXgbA7VXo/GCNKOYQcoV752kKyY6aBky3cPMsunyEHJmS7DLIz7wRltubUsNxaxo381Q8sO4x/rFD17zdga0v0SnB37cPk/f7VA6SLV172Pjonk69OCA+XTt5cSxoQmVscPomw0wtfBS7HAQu5/wxHceduHZDj5XgEkrdaUBr/PH/jfSVuXBd67Q1Z7Iucf9FeiwXxRLR0qNB37AAeqyB4U8vdZHbg6eG1OmV1adsGDKEmwmNPobWD2jCVJUmIinLba6UHs0Wn/gN+CyrVWHX3tHSiN/L8PZWTGK7qhmyut4IcQn++DOpXkfTZ7wz6cwEKvkGkfro3sswGZ89X6AncqXAlrf3XiX19V0cuz6JSO1tY9h17c+89dUT8C74wUkQWn0k2inCGQLR4Vy7OyGUEUb5K/0wpf6edulMf+K34EXv1vnoom/nSsa4ZcfzT4V6yMs9U7CMtz5OOmXzW2uvUPBCBwrFSBbABHE1GoHGCxMVRMjwGTNGPOBy6xHcy9hLS6Ap4MwjkawfXf3tnCQoIyMaiVJtIDZsm1TOYdoXUTMI9LM6agJj0uzdEC4d+850kqzCOR8lj9reBG7B+jcGhLcqaV5daPt+vDF/ta0LEwNCo6Ad13B5U+RAY9DysT91NMy/hvuGKueLeduO3YJHRHTR30cWhjF6hHbYWBXa8aG7yDEsUoow6CH0h51ljQrgNKIozL2J5UNo5c2gSB3A/YbSCXOAy1Ek3LACErFNEupPLvvB5mn+Uepya5CKC2xxzZoQ9XoWDJqp76S6WI22IB/1tv0sTZ0vqWpAAmVL5UyK1TcAX58FVLKGtUHIkvfn
 7IjgeaBp
 meSDncOfYUPHPzOvTVR/CixHXj2K3MWn0mfn/TSQyi6rc+2D+Vg6InP97Vt5Ye6pcVLfPAGbtMmbFr1YmxVOJPSZEu2k866mFVabq2mVV6+Ut6RmAFDU84emZek8esGHkob7vTmbLNbRzHJIpkbsZzWi2sd+gg5u+e1SDYlnfHRcUqh9tJGBN5/6lC3fphVLIyVDKmg8rIndEbYrpZ8Klo/Dr4UYP4h11gNt3LyDcmrxUhCTi4VCiNTaBdwx+RyErnrE9aJMwCswV1xL1CIZfNXwQF8qtr+XxYvV7MMtnWUZixim8xQfMU9dwzJ2vJbbBnXKKQqERn4XXRdWdg35TV4HFTWmYwl65pwkp0XKI1MZzb+73/kIvu9tJ4gocHEw7JfZKv31M2BLSZOrVM6yoAn/5+IxdxOHfPTBuzq+oPdttdrJGQUfz+PXAFvEnA3A2/4AiMIRlTWkpHnywoBuNoa+TPAi98LpAIN0oQ/BrLCokbam0YzNTeA9IPG/yvaW65flC4TFPPXeTX1aOR1li0GtyEicHIu8zSkaRvE7CbxptDuOjs9By68rHCqUT4Qb9dlr/YDiPrOjCdxWr3YNBKWl7lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/12/2026 5:08 PM, Pedro Falcato wrote:
> 
> https://lore.kernel.org/linux-mm/anCK3eWFMwZqq5ka@pedro-suse/

Yes, this is the same issue. Thanks for the pointer.

Will get back with test results on the above thread.

Regards,
Nikunj


