Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B13BFCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 16:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E396B0099; Wed, 24 Jun 2026 12:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936646B00A0; Wed, 24 Jun 2026 12:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FFB06B00A1; Wed, 24 Jun 2026 12:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53B786B0099
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:29:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C64D38DA0E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:29:15 +0000 (UTC)
X-FDA: 84915341070.21.A90BF58
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013038.outbound.protection.outlook.com [40.93.196.38])
	by imf03.hostedemail.com (Postfix) with ESMTP id C77EF20002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:29:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=hFm3+vv4;
	spf=pass (imf03.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.196.38 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782318553;
	b=Yp7yW+DdHLpSdMW23KiddSxgN5wfbbGwEchu+TVSQC3BdXJU7glsfAcHd+lzP8xlNHFl3z
	/w0je4ddlljMeQGU7rLoPMafHGKnjH57crk4/ThqFxikXwBG+kcnO05dyxhlmqZLo5U71C
	L1tgn4uH/qwcO/7qaG1YdR1uR3E7Y08=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782318553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYvpL7eYQk/wyQ/i+jCH3W7s7dTRghENXFikMoEecxU=;
	b=JbssTgTFDCcwM0Kfqf3o3Rvr3BXUWgo7H3xaLa8nkkTP8BAVj6DzCiKPtQJlYAPrW5kmRX
	jEsTex3HG6eCNFxS/hockJJqa+nPpXJhkPeDb+0rqUy8T1oMU/YhLnm4C4Fg7fgv9TnuEa
	+JJ/HrvOHgODBLV9EYOJ189Y41pou6c=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=hFm3+vv4;
	spf=pass (imf03.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 40.93.196.38 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K+dgckwmJXGP89po7QR/yCgVu3gsRtgeyFqr0O7sBgyeTteZfakm86TTAmAH1pq+p/VMp0oULQKFF/DQZp4qIAIVhNF19f4XxBuOQdFgM2WKn7WUnC16SlVEJYcxLzNAyTZw8jz+qrh7b8Qvw1oYZCb4Bq/EE1PLW+MKkCVym4EnTj22XEi7SFbp0bJnO2B0n/mRmUPyRG8WUi0BT3W2na0VnEN7i3so7Y6uEluFkkgP1Etg/+wscJvuO5r9Ypi1/T9dW6jJBDkZCBIaKezvks3luD6N9Zk/9wsCspyC3mqsemhIC3wdEy/7SfaPg7OzvaRzIOPLlij/yHcxJ5IiVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pYvpL7eYQk/wyQ/i+jCH3W7s7dTRghENXFikMoEecxU=;
 b=s3zXZkVa0x7h9dX/7MF6H/r8ek31YAEU/dEczD0DwjAFQrd1xHKT5qyLEKoW1MvaR04gYeGec5Jc37NdIEfYiW/E7i9H1CBmfFNQZFQVJZp5t2frfWp4wSQGo+quoBN8KLtNyAQfpUJ8J1jhdolgZ8c7BQob2n2X0aj7XKL8XlnLrzhJJN5TQtsrTtjS7Gdpd2bzOg0nEis/xab1V9xDRnrvCBVXFLoM9hAX0bWeWvPNgjRfynA9J8GfBcrxM0PRXcc105LOzL+BtzoxK2Tj9vaE5vLx3zSaFmAWQ7tR9Ty2TafxElcNcpxZdMY0tRW0Wz46UCIAqqbPIVdxRI7HBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pYvpL7eYQk/wyQ/i+jCH3W7s7dTRghENXFikMoEecxU=;
 b=hFm3+vv470cDTRF1rwHD2e2UkgmaSaIZQgIkoTKT1U6mvQnPosn1rk4cSfBk2rNUaxXCUnZPPb0JRCdXc1Z4j4T6jJ0/Iv0vC+hJLHQGhzLurYm08bwm3EwKcpbuOFP1XYbEuVwEQcfcZBUFsg7EPGTK8WQfxWOgK1b/C50nSQw=
Received: from CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22)
 by SN7PR12MB6840.namprd12.prod.outlook.com (2603:10b6:806:264::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Wed, 24 Jun
 2026 16:29:08 +0000
Received: from CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6]) by CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6%3]) with mapi id 15.21.0159.012; Wed, 24 Jun 2026
 16:29:08 +0000
Message-ID: <8b911825-ec90-4de0-ac92-cc7f69d421fe@amd.com>
Date: Wed, 24 Jun 2026 18:28:59 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/9] mm/memory_hotplug: pass online_type to
 online_memory_block() via arg
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
 kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, alison.schofield@intel.com,
 Smita.KoralahalliChannabasappa@amd.com, ira.weiny@intel.com,
 apopple@nvidia.com
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-3-gourry@gourry.net>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20260624145744.3532049-3-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0024.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::10) To CY8PR12MB7433.namprd12.prod.outlook.com
 (2603:10b6:930:53::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7433:EE_|SN7PR12MB6840:EE_
X-MS-Office365-Filtering-Correlation-Id: e371f856-daff-4ac1-0a3c-08ded20db753
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|18002099003|22082099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	T8PE8bGlXIeE5DMfWh5egFJUP/FQQecH33Tmyz+gW3QQfTqC07D4OxRYXNONApg7IlKJ3WvhUBC0St3VfgW64am9LH+nR9/Wi4d7E4K2HWigKWdduzTBBDyG1E/6i+ffIzv+SZekeJf3hRFknLLy//0egRee9LECNdYHo1VpIVd/ovfyj/BkOF/SUe6lO/7Vw3YQY3KzlkqsL8jvBjEepHxXZNKs68wYPcSN08ksscglHk7Pl6WLcl8fDPStrIz+9q0s5zk7KJVd+8IUItF5YHki3QwTBnn9NNwo+tieMUiY46zb8stZTEwVyAxUVggd+mArQ6OxkwukzkYNs4gLhlh2FZXWMikdZh4Bt7EykvGhTZ4VV/K3BdePjP3KJREpveDJTwi/JhTtVv3CWnk+O4yPVa7kuChJwYdw4KpFegxSeKgKSu+Te4dXAZk0fMZAeBTIXnV2R/r1Lfg4vYHKcx0VkOYQhA9TLuhAcFsOfAzPvKWzRB+5fWlffKR1aR0/1qROsbw+lspg67SD0TEOdF/OMSCKS7e81K5UuKFySwxTIDOzb+UM92MrgV48PhgzeG/le/VA0D9mNQDxquNPSMWrO63xhgWuRS7fIaObrCVNJ6dVz/OPil0FsMIFW5iZMJdjfDfFMs6jXlG1e1INI5W75BYwq/gHCc0sj8w18/0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7433.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTVYNWtoNkhQNFczZ3dBb09KS0lFZHRyQW9Cc3pzeU1ScTNMTk0zTm9FbXl0?=
 =?utf-8?B?L1BoRDNaRmZvZDhMaytqS0F6WjZoQnRrcmJEYzFpMkRWY3dWUGV0T3RkNVhi?=
 =?utf-8?B?MGFRVUd0SDJWbkhtNklIYmowUnVLWjNHVVZtcEoxSzNJb3EwUU93eGJUSGp2?=
 =?utf-8?B?MzBRclpDaTV5VE00Rzc3WjRpa2lyMkJ3dnNRVEVFdlhGRFV0cXN3anJoUHVj?=
 =?utf-8?B?UlJrNDR0SjBqRnk4T0pGZUYwN1VlWHVvd3JOL2R0V2xNZmtUTzNYS05MV3k3?=
 =?utf-8?B?NTdIeERoZGtoN0t1akd1OTRFdzZNVUVpL0pSdkVSdkZOOUYwYkhLUjNta2Ju?=
 =?utf-8?B?eHJQZWhsUnlQak9zVnFCYWplRmd6anVBcmwzc3BXVGozSi9GUE1mc2lNcHZB?=
 =?utf-8?B?Q1JOL0J2WC93R0c5UVh4RjI2WkU3R2pLaEFxSjJJV3hucy9HNkp4L1ljNEVS?=
 =?utf-8?B?V3lZbk5veEU1dGRJMUxKaWh1VmRMN3FDQk9NMWJ1STYwc0ZLQitDY0o0dDZ1?=
 =?utf-8?B?N0YvdGV1MVJCMDU1MklURDBpaEorWTlxQzJBNHV3QWlWd05HZWFBRmlBdXNz?=
 =?utf-8?B?cEZ5aFY5UUNYUEJ2RHJ6RTZ0OXdvSjRkRy9NSm42QXBVcDVJY3VFZVFRSjNS?=
 =?utf-8?B?TzgzSjMrdlJuQnBHeEtueVg5MVgwMHl6ZGZ5dmt6WEJtbmZjcmdTajNnbEVz?=
 =?utf-8?B?TC9wd0c1ZDZkKzZzOVBINm8weXkyaGozQzd0OEdNMzlnbnFVejZEVHpDRWZM?=
 =?utf-8?B?TThsU2JpOVI3eHZkWnVTbzd5cWFUejMxWitFajd4bzdXekVyb2dDSXFiSWFZ?=
 =?utf-8?B?Vyt5UmFyRnZrZkZnVHdGWjhYYzlkZVVEb213R2w5N0pseHpBRkgzNDNZZjMz?=
 =?utf-8?B?K3J4L3IrYWZwbVRnbDdMRU93eDI0WWZUSkJFMERZVUg4UFBBSlNORW1HeDhw?=
 =?utf-8?B?OEg4VCtPWWl4V2t0amc2bTQ3azlMUlc3OFovcU8zUURrRVcrbTJqQnZGNm40?=
 =?utf-8?B?YzVocUQ4RXZwL0ZTeUllc09aeEtMYllWNklKMVd4TG5aR1VsSDJzNWszRUlF?=
 =?utf-8?B?L09UK21icnFUWGtkOWNJdHVpUVNESnZXTkxVOFRweEVhZGNPT2xDckRmWEl3?=
 =?utf-8?B?WjlZcmZ4K2RVYkU5eU9Pc2wvRTBmNlJGOVQwbmdKajBoOUM1WGxTQ1g0clVk?=
 =?utf-8?B?Y0tuRjdiRmJIbWFFa3hReGNZdWJVcXZGN1lsSk94RzR6N1pOTHZVMFVQYm1C?=
 =?utf-8?B?VSsyc0tKczdpVTY2MzJyRkRTWmVueGZGN3pHK3kzZ3dWWnZLU3hhc2VXTWdr?=
 =?utf-8?B?VC9qZlZIbGd1cU5SRi84N3l6K1ptNU1XK3V2UVJtRDFFNExranh3eU1OZmcw?=
 =?utf-8?B?bkN4MTBmWnNkTFE0ZWZITEc2bzl3TUNqbEZRaFhnV0p5emxmQ2dDK1J6QUM0?=
 =?utf-8?B?blAyMm5icEFNR0pMQWk2bG1LaW5RTE1XZ3FnbVFBaERJcDg5L1l6Y3huU0Q3?=
 =?utf-8?B?Rnc0MWtleUt3ZnlFWWcrdnp2K0JiMTFicldNZzNDdVcveTc2S0srSWJPR1FL?=
 =?utf-8?B?UW9WSzIyWVBpZVF4bHQ3WTV2TzgvZW9XTlYybnltTEl5VlBpckZNRnZEaisy?=
 =?utf-8?B?bmN4K24zdmxpU25kU3FlODFMZHlwb2d0TXFNM1BpLyt1QTZEU3FnRk9PZkFh?=
 =?utf-8?B?S0Y4NkxaZGZPVjEvZUlnTUlaMU82L0NFdVQ4TkcvRVphMDRUNTdXc1U2cytP?=
 =?utf-8?B?Q05hRnhteHZTeEU3bTdiZHpBYVRBM3hpOCswSHNaYVNqV2FXR0h1M2h4a2gv?=
 =?utf-8?B?cHRjTmxmUzlrcFZIaVVVcGJVcnJvcGZKSk5oeGV0QjlhUjFIYktmd3NBaUlC?=
 =?utf-8?B?L1laR3RqWTBuSUt6bE1RMXBPOFhHNVlFdEdDNEpKWW80enRvVXZqK3UrNU1K?=
 =?utf-8?B?cUxYa1pZR0M2YVltbDJvdE9xSlZTY0RmbXM3U2tMSE9IUjZzQ2Y3K1QvK2hQ?=
 =?utf-8?B?cndCRmxJVDdKWjlXaGdCUi9VNHFnMG0xQ0NOUElhMXdpd2d6YTE0c2N1bDJp?=
 =?utf-8?B?RzhqMVFKUUZNMjh4WldNcC9VNzVCMUNoQndaTGFjMVlvR1JYL2syUG9INmt3?=
 =?utf-8?B?RyttN1NBWnNDZ3JhNXRlR2dHQTk0MWNCa01PZXZOaGdUU2lhK0NxUXBVWWUx?=
 =?utf-8?B?VHVQTFIyVFVoVE9CVEZQZlczVitzMkE4QSt2MXVEd0ZlWGttbDdhZnkzVXYx?=
 =?utf-8?B?dUl0MnRFS3BQN1FuUGtpRk9LZC91QzdBeGxxYy8rMnZIaG1vbWtYVDlEUG1L?=
 =?utf-8?B?SDdZd0NXMUpGT3NCdjhnUU5ieCszeEFqYXhuNzFoYm1FOFZBc05sUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e371f856-daff-4ac1-0a3c-08ded20db753
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7433.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 16:29:08.7946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CzkX0WRzWyTeORPS1ycDMoz67e9OVQWCMenjRzKedWVh7p52+wKWo/7lF+fa+Msn6kWvhmj0H8P4snFhHVa97w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6840
X-Rspam-User: 
X-Stat-Signature: 44adg7mico6pskgb9cpwq1wzrgbhtjmg
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C77EF20002
X-HE-Tag: 1782318552-976486
X-HE-Meta: U2FsdGVkX19nF1Pgy2E4jWgu1+2FkFUOB+BT35rdZCPleCY6vIFD8PIqSO+BtF9+f5jlbVateAeV7AX7e3ht6XeOrKGPDPnUJql6ea4lK6sZClP+lvbJttv7NKQ1kXzA84t30IunkLcqjklTFbJKzv/QUX1VrMxA8geTuxAdDmmDIhL+4BT4im1sC6PWAOM6QGev+sSINJZk6sRcTitVSrmLPFZDwN8bSe7TVItIXaJBNiHYkoAr86EqoSiHhsJLf2MCbmJDUKOJ2fjfm+gaQc1FxeSrWuifaH/VsMJP6bkpqbveU+OmS3ZEqbbHgXbWXlE6H88ZG/6fFyroW9oPcfxrhT8giKpm7d9Yz2OB1q7EUaZRcbLmh8ZM/VKLf9JyF5rduT4zcBoGtT9mw3zbIvkVQtAQ3Suy37CGg2XwK0Gg+jb3uXDudrnYPqf2XJtXpYnkv/UXtjUjjrriuQYb7sHVLcicIl6+918KGw2Z1LwILNDRr/R8dP0b4AdB/1w1fKsL+70Wo/592ydambdB/IyZViwKc3CvTboCtdtH4eOo8mYFHsfLiahSvwep3ILBv0tlnH5seTQAyNxDFoVSYFqjYsBRMpzToYFNdq22mq6Km3kZ7yur4CqKxswfUORSbcwjxUfTlLdWJTJCH9w0igjLTGijtxreD0qbDmSCuIayd4QyYMGdVtiT24xpF2X89ktaFjV2hXrIFe3EfT8UkE89bDB/oTj1/7wdpG5rUHZIFD9brJ2pYfOtFyRJIFuIpcd5KWSGR+kccHksjhuz0UhkpxR0Bc7GRc9lGU2zCvijcIKe/vb9z7qTbPi90mtf3mEwidSx7SG0g4lmUhJ9yzlfda8zLRUgbE3Xr4JafvybgHY2NSi4wnIuc4VkTB5kR/wXEqBbB97K7vo41XxGjb1C4dqehxccRtBYPocEzUPgkjSiUBmM4/7d5tgECr3vzZMWyBPLEZsnaL0GIsh
 Deq6WjAm
 m3orNVjXPKJEiHlfAnH3xD8g8/1SOddB6GXnzjnlqYnJnOFEqSxN9kW1Tf+JYhK9jEAr5tsh/FnzpAbixJKID+K48UvC8q1uakpbMLPJ2pbyr/K+ULbvmJn8ItbnOuDc+89L+/ms707uDl9HMuoTlk8mMROTpz6Zn/7SSz+QgqPyOHmR2R/XDMTDyMVKKL/iMeIALpro20kHojqvXwR+kiaGX9Nl607mUAjVguQRkZPdmPNLSIWiB435mnPR0YJC2AykDfRNUPrvmqONBErRO0fHugcgcLC+6aAguh7kEzcGlyiC1kMemdHCo2bmUPV6YMbIn2wweof5W4yGkGXxV0ApMVhHufubvdw8v1iyZWOBrzV3RjVU6lyZHEyxbo3SDN4bhanWeBqUA6jDhK/zVkWseZducP90WSA/HoctV7uO3ppfGxvcG9w4+u9bmcDju9bWehjHJzhcPaMCxYuYZaeV3wY/u5pZysc7Jd0d4iQktQRzBMu+j1FErU1K3pX+31TrpEHodSDFzwVyVBjgJBlEpN/RuwXxpJ2EKzmE4IWtxTv0ooV+J78epIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Modify online_memory_block() to accept the online type through its arg
> parameter rather than calling mhp_get_default_online_type() internally.
>
> This prepares for allowing callers to specify explicit online types.
>
> Update the caller in add_memory_resource() to pass the default online
> type via a local variable.
>
> No functional change.
>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   mm/memory_hotplug.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 7ac19fab2263..6833208cc17c 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
>   
>   static int online_memory_block(struct memory_block *mem, void *arg)
>   {
> -	mem->online_type = mhp_get_default_online_type();
> +	enum mmop *online_type = arg;
> +
> +	mem->online_type = *online_type;
>   	return device_online(&mem->dev);
>   }
>   
> @@ -1494,6 +1496,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>   int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>   {
>   	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
> +	enum mmop online_type = mhp_get_default_online_type();
>   	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
>   	struct memory_group *group = NULL;
>   	u64 start, size;
> @@ -1582,7 +1585,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>   
>   	/* online pages if requested */
>   	if (mhp_get_default_online_type() != MMOP_OFFLINE)
> -		walk_memory_blocks(start, size, NULL, online_memory_block);
> +		walk_memory_blocks(start, size, &online_type,
> +				   online_memory_block);
>   
>   	return ret;
>   error:
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>


