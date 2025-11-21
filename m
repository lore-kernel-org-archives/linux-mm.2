Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89D7DCFC26F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 12:43:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638D86B002C; Fri, 21 Nov 2025 07:43:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610A16B0095; Fri, 21 Nov 2025 07:43:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FEDB6B0098; Fri, 21 Nov 2025 07:43:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 391696B002C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:43:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D21941A0111
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:43:39 +0000 (UTC)
X-FDA: 84134580558.29.EC722D9
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012071.outbound.protection.outlook.com [52.101.43.71])
	by imf08.hostedemail.com (Postfix) with ESMTP id B141C160005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:43:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=P83cwmJo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.43.71 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763729017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eglzifXkhlEye6B9Qnb+9GFB+ajcipdmrQxacTKLMKs=;
	b=DRcXlVl5Y8H0VoELdOJ7KY7WTMndV4qDiKU+uh2GM2jhvhOaMRVX0s/N2HPN8BsxNopRYA
	YH3dycKo6McyIEQoNPtjK6dd3Q/vLAzzmnvNSs/jKtJAO0u7zocj43v7iKCU9WaWLXDoa4
	5z3pdrop2Q+PbY+xCeGF59gqZuQxdZI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763729017; a=rsa-sha256;
	cv=pass;
	b=wsu50bLkHZF/nAdjNbJ9GpQsJSyfjsBRiIrzOSddMudISU9C/5f92SM2+SCzmbjHd4jy3g
	EQ/npz+Afu+uV04B8EMvawr77QiF/GlPbRs5eDL//Id4hIrOC946tt2BMxLnj4vKwaypBl
	nwozIEIzTsYM5utHyMdvChWHGkj3GBs=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=P83cwmJo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.43.71 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RkFysoD9xpQ27B/HulI98WGrkKAIme0PTEukpG2ShxWLrc8AFwz3nvqhkWP+UI6nzCabHx5oBYfL41JT3yZ3XDAgvcjQEMAy6jwaDm2nGHfA8VsJW0mXxC3W5mVMh9z1SpNXmgs4E7TYinP4DkJ7gwZvRgUk/srHV9QYrnfesSjsF9r6dNyl+fPSnMNlhU9B4BGs7R73WTJMGHRX8/0ZRi9WMTJ9/D8aV4PENor+34o10YbMMAuIUvfoUl6tB3rGjoN85Rt9ky1Mp1cHPjVz1u54auhi/GoaWSL+8Tgf1j0lsqnbmI/OyANnvAacNBC6ZoS3ZWZR8CEv7Mr2zcDTUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eglzifXkhlEye6B9Qnb+9GFB+ajcipdmrQxacTKLMKs=;
 b=Lg6HyBCh+GESwRNWIdN4IvZm5NeKGFi0+soxAuhvxw3TwsznmX0cULET69EdAIn7zxtB57wUi9wxXjltvcteA9TGasnCV9WumLWL+zks6FhcsqRfN0N2Kd03eFMd1qhGPVHpegN8FcedQIKUXWxJryHpf9zR+cy1xsbd0aUe08YWkAqdIDJSqKuyT9SmRxmkoT4mSyPrxmX5MDQAi3CuSOTIM18VWtFQDZwMcujy2f5qmeKKUWjNpBpZxkK4NvrdU+kJs0lBn4v7DMuWxa3Zx1ByAQqMJEyM4uoIqek+ZqL6Z+6+ZqDzT27ucyQu66i1uebrvEOmuIlDRRJdIJNo2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eglzifXkhlEye6B9Qnb+9GFB+ajcipdmrQxacTKLMKs=;
 b=P83cwmJokHKMQGXcPMFvEro82rkfy6wHwaQNvBeGcaay0WbZuTaKyEQXautO2v3byhdEBeWXOUko/0vrsuChQA9J5C/eUx7wLVRgq9LGJEV2hBSaWZaX3V6HUwjvHT+s4MQNZYazg0YBO5u74EszutjV+4ZfWYvklbhDxcAaNbQ=
Received: from BL1PR13CA0422.namprd13.prod.outlook.com (2603:10b6:208:2c3::7)
 by CYXPR12MB9425.namprd12.prod.outlook.com (2603:10b6:930:dc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Fri, 21 Nov
 2025 12:43:31 +0000
Received: from BL6PEPF0001AB71.namprd02.prod.outlook.com
 (2603:10b6:208:2c3:cafe::d4) by BL1PR13CA0422.outlook.office365.com
 (2603:10b6:208:2c3::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Fri,
 21 Nov 2025 12:43:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB71.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 12:43:30 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 04:43:30 -0800
Date: Fri, 21 Nov 2025 06:43:14 -0600
From: Michael Roth <michael.roth@amd.com>
To: Yan Zhao <yan.y.zhao@intel.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
Message-ID: <20251121124314.36zlpzhwm5zglih2@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com>
 <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB71:EE_|CYXPR12MB9425:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a2999c3-0a1d-431d-14c9-08de28fb9379
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4pCaYVQgsT99/oN/YOwVuL+NLdKJbF13GJSChHeLzEQPtgKGStN75NM4YrME?=
 =?us-ascii?Q?VqPFA9/sHkjbLIKmIugaMAdhpeQfgWwZwq7PXHcuWet8b5IWpagH46wDnuiv?=
 =?us-ascii?Q?2dVg0nR7r9MAhwhhdwC7KqmnygTlTtORaCkC9GHeRsOlaMgaEeCDlys8qNX+?=
 =?us-ascii?Q?IaPxtoACy5lNAyNlCGLkIsPlTyPvC7viZL9r+d78MgRVWo0qMRAoJlvW4APw?=
 =?us-ascii?Q?5wMrepsCRrfGsmok+cY8TiP97D8kGdVQsK2HjALzXCjRQH+YAylPiwxwao0f?=
 =?us-ascii?Q?2h/LIIzABHFzLQ13YolSvTBbvyLyL1Hrq5/kBbRqOtRLH2Ih1lK6kiqvsj7q?=
 =?us-ascii?Q?gALVSkULlPOTunzC+r0SlwS1GwvUzg1vWmnuA80ZGOPLckgPnfHZvZyIDdMQ?=
 =?us-ascii?Q?7kiJYjoNpJISXGy2I+hNtRt7cUnVuC+8c83Xef4NOXN+j2luzAsvw55BzrFk?=
 =?us-ascii?Q?pKX1pIL42chdt8USISmEUGw6Sx42sI0wCAOW+lttK3KTcghCGlHFqwQwyUP1?=
 =?us-ascii?Q?ovJOH3EhMAzVD/vyoj3PmTkaivwcho2OcxLSOuBiV8s9NKRnsapX8bFOYXO8?=
 =?us-ascii?Q?BjcHMN/R2JQUmD1TToliWJisXReW3gJ/r2TUMSmRLFiZyMq76JSrddjpVJra?=
 =?us-ascii?Q?buREry9T6m6YWNU+7DObW7AHtRTbuY788Qg8JU5tOioMCqfsVc/xvUmNKD8M?=
 =?us-ascii?Q?tSFJ4znSrmxkP9Q6R+Q3BqsuYsePeRCcHv7SqzcD5mmjsZv6YD6lSq8kKyPw?=
 =?us-ascii?Q?kG46ZZVWE43dhI5sWgrB3cFAlEZlvDMtzZk9zUSa3aEERyFDEXpb0RohC4oF?=
 =?us-ascii?Q?ZpVtt+JSPGW/9WbiLrGnVCJA4uf5ORE+8/fbqEWMpIL5hilk+n+1ifsyTKQN?=
 =?us-ascii?Q?JB7hs4Yvj1UITsqjh+wdz3nwSoFWK7vMYaz+nhlRc4VQNWsYO23IhbDDQ9DH?=
 =?us-ascii?Q?qztn2tUg85gWStC1syPCzkU1/bQt9JazDhCR0b6MKvnoWU1iDLhOcLgYi3uU?=
 =?us-ascii?Q?TIXXyTFLrtvxryLXc7YxANyYpBa18a9RqVUYdWVb5K6Y5fjAiOAzpTVc2qHP?=
 =?us-ascii?Q?YSWqdD210ZbLljvtGVO+h2pJaRr3gXj9zPw0Wu4YiuMEBh29rCQZkTSODekX?=
 =?us-ascii?Q?6fIn5bIeMZpAMG1bqQeSGxdGiwYQqBvOA1AvlSGgTnKhJ/UlYSdMCzBCmaz5?=
 =?us-ascii?Q?580PR9dP3+JHOJIjS7+eUwmMS54lD5CbYJdD86S2nWP7MTzUnaVdpr4bJel3?=
 =?us-ascii?Q?7dfRp1GYreZEStQL20MdfdCR9wBZRDItNC0g0tjGNpjiUiGYQJBIQv9AhhOR?=
 =?us-ascii?Q?cNX96BEHQONpXmiQiPfAriQdrEDnbUjfIKF32l8OMgBfbjh9JGyraX5LVhPU?=
 =?us-ascii?Q?tAMKolVYQts1iTEQJqNfFvTeWNA2bMPRYK2kOtE48E18WYbfEYht3i386F5m?=
 =?us-ascii?Q?OvswhSvxZKiyLmEKSoRc5InyPy4/jhR+NFrxHWQBf2W3lSJvgpAhG4zcUYG7?=
 =?us-ascii?Q?MdV81PxWPOXA39OP5au9RYwvy9xMun6GcEx3cbfvFtLNEH3GQpzxVtr6K7R6?=
 =?us-ascii?Q?INZbmnPWcM3ONK4H/kE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 12:43:30.8841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a2999c3-0a1d-431d-14c9-08de28fb9379
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB71.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9425
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B141C160005
X-Stat-Signature: jgyf1rn3t1onungybt4qx46teu3uuh3k
X-HE-Tag: 1763729016-476462
X-HE-Meta: U2FsdGVkX1/5gUksMkezGM1A5esAIM/PuOcA2dP/Y4aZfcdaQFX5MeZ0UXbGFPiA740VeM7H9A64tN0P8RaxbBlo0p9jU0KBovuyh30DSAwcgRid28yg8Tp/5FsQ4dxSeNluZz6SeZAu6osCINMP1gLg3u2Drpch/9st7k6ws5RikAmU3OLfGDS6xJ7rNhJ2IgUVN3h406SMvF/BD54bxbT8VPL2+xE6QElUNbQxJGY3f3oaVExls9Zxr2TKmv93E8YlR+UBF6IziffKiCefLnNOQLw5Q23pHaC74q9C0tu8Ik/CJo+EckRAti+aTUo4vE1vuVajY9eLYctpq6KfM+fpR6GK934a4uFtOWb8n/HBbB3sBXnAr50Vxc8iwliS/dmOf/aoYWp+mlp2Mgh9tOTu1R04A2lgs2hzhaYG20VUPcBb8wD0sUdQcK94a5xIl2wKHVoBNg6wUd6AXUX8+MQAkysYo323Sfcx3zQ1nm4P/xPn4ddP/J969rcFhRBEkRd7KtnWcjfzV5cvPEdwwYAnnxuWAxDhNjXMi09P4axPmtS06Y/iohdEqVBlFzFFjVK6eH6IWqZijBWyu7jcHSwYRrwF91Gb90cq25EngmVL/ulravIHlUDSlotecesVS6m2SAKhasYa+k41epBDDOe1YGpqr3h7IN+HzSq+X5WtK/hspDQ3gbGg1J+tqoAWNziKFWS0Ub+zyIeEH1C/5CzUtse9+2Jc+a5L+BODWVxTodygVSWepRSSHc+PMLnBFsUpCJsUxqHkBVegaismvnwnzCPvCc4HqRsb7t6RShOnYwItis+oM4BpUkzWhPLVgzLF1TUd7Y3r72OuGnVADfOJORMyHzzqU/SH15YBjk19konfZTYW5GmfWDdtErKROircTFl07GO9f56i3YbX/Xqr22xTajn5nfK7MvpywTeFIm6FSctXU5+4K65Bti9do6ZS57iFVpuZoiTkTw3
 fo7Zqoog
 wuf/M2yD7skgr2LEQGoqGx5QJII/qQC3Mo0RhmB1pQ4zr2NfF5r8Z3wbDIDDaKbCBWIbb7MsY7kxMadI0T6g0rn3E4l7sW7mJiH08fOJkFART5Ne1gbfvUV0nWEUXGd1l0nH4GAaz6nn3V/6dNESZdPGQeZtJKGfLcplE15Zg14wDPeQYFn3PxJ/oCziKG29AP/hTDNU4UbIvrdJKJ75VLVx2IjGsThYZO5X4Eoo6mI3F6dc/5TBlMk5EDxsVzdCrHd8fxI9+SndZomazvgZO0QfaN6SqXg5eKrnF2xtU+tLPAf7HiK+uAVG7XSdvS1TEK1C2/JRi8cdQ2rUjhlp254pIXRStqIiw4LqnMsSY+/m/FUhQdDJtZ3uZQw8SWHWzViRd+POHCEFsSmnQOsAy/TtEGolrvaHpFMdd73S3mjiBgsHVZksLVhT9HnsQpQpisplAwZi4Z6oXm12UPFAWu5fdZ9n+WuUrd52Etj4OLSXIpC5wo9znTuxAsTAZR7O5UMMDV1KnBH+jMhdaCgCl76OgqYIceGVbxwuY4gs1TWV25nKBiW1zYLZsQ8OtFRE7aTjYtT6VA1pSEng9Lf+PqWxtDnvujiwTL+/OoEzVb0Sr5S9Efcb1lU8grMYGtcjqEqBzYNq1Y/spvDDCZpNwoGV6Ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 05:12:55PM +0800, Yan Zhao wrote:
> On Thu, Nov 13, 2025 at 05:07:57PM -0600, Michael Roth wrote:
> > @@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >  {
> >  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> >  	struct folio *folio;
> > -	bool is_prepared = false;
> >  	int r = 0;
> >  
> >  	CLASS(gmem_get_file, file)(slot);
> >  	if (!file)
> >  		return -EFAULT;
> >  
> > -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> > +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
> >  	if (IS_ERR(folio))
> >  		return PTR_ERR(folio);
> >  
> > -	if (!is_prepared)
> > -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > +	if (!folio_test_uptodate(folio)) {
> > +		unsigned long i, nr_pages = folio_nr_pages(folio);
> > +
> > +		for (i = 0; i < nr_pages; i++)
> > +			clear_highpage(folio_page(folio, i));
> > +		folio_mark_uptodate(folio);
> Here, the entire folio is cleared only when the folio is not marked uptodate.
> Then, please check my questions at the bottom

Yes, in this patch at least where I tried to mirror the current logic. I
would not be surprised if we need to rework things for inplace/hugepage
support though, but decoupling 'preparation' from the uptodate flag is
the main goal here.

> 
> > +	}
> > +
> > +	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> >  
> >  	folio_unlock(folio);
> >  
> > @@ -852,7 +843,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  		struct folio *folio;
> >  		gfn_t gfn = start_gfn + i;
> >  		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > -		bool is_prepared = false;
> >  		kvm_pfn_t pfn;
> >  
> >  		if (signal_pending(current)) {
> > @@ -860,19 +850,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  			break;
> >  		}
> >  
> > -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > +		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
> >  		if (IS_ERR(folio)) {
> >  			ret = PTR_ERR(folio);
> >  			break;
> >  		}
> >  
> > -		if (is_prepared) {
> > -			folio_unlock(folio);
> > -			folio_put(folio);
> > -			ret = -EEXIST;
> > -			break;
> > -		}
> > -
> >  		folio_unlock(folio);
> >  		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> >  			(npages - i) < (1 << max_order));
> TDX could hit this warning easily when npages == 1, max_order == 9.

Yes, this will need to change to handle that. I don't think I had to
change this for previous iterations of SNP hugepage support, but
there are definitely cases where a sub-2M range might get populated 
even though it's backed by a 2M folio, so I'm not sure why I didn't
hit it there.

But I'm taking Sean's cue on touching as little of the existing
hugepage logic as possible in this particular series so we can revisit
the remaining changes with some better context.

> 
> > @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  		p = src ? src + i * PAGE_SIZE : NULL;
> >  		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> >  		if (!ret)
> > -			kvm_gmem_mark_prepared(folio);
> > +			folio_mark_uptodate(folio);
> As also asked in [1], why is the entire folio marked as uptodate here? Why does
> kvm_gmem_get_pfn() clear all pages of a huge folio when the folio isn't marked
> uptodate?

Quoting your example from[1] for more context:

> I also have a question about this patch:
> 
> Suppose there's a 2MB huge folio A, where
> A1 and A2 are 4KB pages belonging to folio A.
> 
> (1) kvm_gmem_populate() invokes __kvm_gmem_get_pfn() and gets folio A.
>     It adds page A1 and invokes folio_mark_uptodate() on folio A.

In SNP hugepage patchset you responded to, it would only mark A1 as
prepared/cleared. There was 4K-granularity tracking added to handle this.
There was an odd subtlety in that series though: it was defaulting to the
folio_order() for the prep-tracking/post-populate, but it would then clamp
it down based on the max order possible according whether that particular
order was a homogenous range of KVM_MEMORY_ATTRIBUTE_PRIVATE. Which is not
a great way to handle things, and I don't remember if I'd actually intended
to implement it that way or not... that's probably why I never tripped over
the WARN_ON() above, now that I think of it.

But neither of these these apply to any current plans for hugepage support
that I'm aware of, so probably not worth working through what that series
did and look at this from a fresh perspective.

> 
> (2) kvm_gmem_get_pfn() later faults in page A2.
>     As folio A is uptodate, clear_highpage() is not invoked on page A2.
>     kvm_gmem_prepare_folio() is invoked on the whole folio A.
> 
> (2) could occur at least in TDX when only a part the 2MB page is added as guest
> initial memory.
> 
> My questions:
> - Would (2) occur on SEV?
> - If it does, is the lack of clear_highpage() on A2 a problem ?
> - Is invoking gmem_prepare on page A1 a problem?

Assuming this patch goes upstream in some form, we will now have the
following major differences versus previous code:

  1) uptodate flag only tracks whether a folio has been cleared
  2) gmem always calls kvm_arch_gmem_prepare() via kvm_gmem_get_pfn() and
     the architecture can handle it's own tracking at whatever granularity
     it likes.

My hope is that 1) can similarly be done in such a way that gmem does not
need to track things at sub-hugepage granularity and necessitate the need
for some new data structure/state/flag to track sub-page status.

My understanding based on prior discussion in guest_memfd calls was that
it would be okay to go ahead and clear the entire folio at initial allocation
time, and basically never mess with it again. It was also my understanding
that for TDX it might even be optimal to completely skip clearing the folio
if it is getting mapped into SecureEPT as a hugepage since the TDX module
would handle that, but that maybe conversely after private->shared there
would be some need to reclear... I'll try to find that discussion and
refresh. Vishal I believe suggested some flags to provide more control over
this behavior.

> 
> It's possible (at least for TDX) that a huge folio is only partially populated
> by kvm_gmem_populate(). Then kvm_gmem_get_pfn() faults in another part of the
> huge folio. For example, in TDX, GFN 0x81f belongs to the init memory region,
> while GFN 0x820 is faulted after TD is running. However, these two GFNs can
> belong to the same folio of order 9.

Would the above scheme of clearing the entire folio up front and not re-clearing
at fault time work for this case?

Thanks,

Mike

> 
> Note: the current code should not impact TDX. I'm just asking out of curiosity:)
> 
> [1] https://lore.kernel.org/all/aQ3uj4BZL6uFQzrD@yzhao56-desk.sh.intel.com/
> 
>  

