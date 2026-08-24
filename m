Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C84C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 04:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88CC36B0095; Mon, 24 Aug 2026 00:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83CBD6B009B; Mon, 24 Aug 2026 00:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706216B009D; Mon, 24 Aug 2026 00:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35F746B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 00:12:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD3A1C03E6
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:12:55 +0000 (UTC)
X-FDA: 85134842310.08.88B0348
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012049.outbound.protection.outlook.com [52.101.66.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 80928100004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:12:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KfMCPvmB;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KfMCPvmB;
	spf=pass (imf14.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.49 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787544772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5XnY1jYo4cNhUMST032cuENMUAqCBvCSSptWmJ+sJc=;
	b=XMhJ51zIFLfRliKRJKxqL3qdRw/P/Gfnmt4YPj24j7Gh3U31xuYJgP3j9jF/+WKYpTxz42
	Soad6aMDaYzrRs3LUbIwcM86Lg8PmtinYE4vj5MmWcEk5fuIfObP4MZt/ctSJQ0A0tpgTg
	O7wcivDXQanmjom4MtihhsG56HD6yNk=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787544772;
	b=Yomhop2e/0T3iI1PXXIos0CPA8yVNUAFWM20CdHzGyZOcKRUDHfrwRVzQjrKmBBiliQmsD
	/ndhHhYW/lONDjoMZL4gRglO5GV5tXgM3tKLnoAnSYjWRkotJAxn3qT9QgDd65/RKb2I4W
	oK0E7CY2f2K5L72LgymMjHKPBQA+mSc=
ARC-Authentication-Results: i=3;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KfMCPvmB;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KfMCPvmB;
	spf=pass (imf14.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.49 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bsvZkenQrws/t1jSsRRvRmOxctFoRByacjCPZHQTPSAIMDD5YLdrqCn/3/yz3+NGKZEDyFcLctDgTu+hGRhvpNjTZtz72kRSDVQAm1ghhqrtbcHlLgq+iGcwzPMQVv3HxlAOTGNFwBh4qkHk/BsarQgJq9LaUxGhixU23ZBOTXKJcpkNJMMV40lVd5wZ0kMTzBPhAaJpcrAK8rxy+vl0vFqluITHXVXUb7qmoHGSrwwu5VbnBmEVYkK8RyNoEE9/R61ImRRmX4xui2rM99uC5Hn3OYfp4W96cioxlI9YQhrb1LcKJ1thGXP8TItb+KB3SmsA23yq6+I0AVOz2ii1vg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K5XnY1jYo4cNhUMST032cuENMUAqCBvCSSptWmJ+sJc=;
 b=aidttfmrCgERfvdw6aPa3vvsQJnQGrdPfQoyxHyJfAZl8RNCXSzayUGKwsgIsw9O91/qKK9SJC8Jvip0xybrtZyhJ42phGHs4DwgVrgjEtWc8LHAbYB7oYDJggQ8lMo4JcoBAM2ArD2StJD+656rvQtuOmftBcu1PkmyLdJBs5ussf7hYD5tRijp2zVV+5pH02gZrzn1Zxogi1f7Y/lfAGVi+56pb6MMzC0FFTY/bdRLX2I3xAGrWy3YYxIiqVEqa8uhjFwnka9GH/2fEpCDKnD+d0ywTVLE2F5P0YAFXWoCch2honJGVZoFkxyb53l6+B+jAx2Ht4QPERhmoZ5LDQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5XnY1jYo4cNhUMST032cuENMUAqCBvCSSptWmJ+sJc=;
 b=KfMCPvmB5ftArE52SfRWIaKk2lPoYB2alWIq3ngiOpdYYUUWHQwwyo8TJMpN7ChpNTawB1sSNPnAu38RRyWDPCFAeB9kLYb0G0TOfjuXemgHwcUDc6qj8eCiifp4TVYliUQ/u3aha1ml8Ay4ocYF24uPAR66j2ojxPXvm+w8GwM=
Received: from DUZPR01CA0255.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::27) by PR3PR08MB5820.eurprd08.prod.outlook.com
 (2603:10a6:102:90::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 04:12:46 +0000
Received: from DB5PEPF00014B9C.eurprd02.prod.outlook.com
 (2603:10a6:10:4b5:cafe::76) by DUZPR01CA0255.outlook.office365.com
 (2603:10a6:10:4b5::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.12 via Frontend Transport; Mon,
 24 Aug 2026 04:12:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9C.mail.protection.outlook.com (10.167.8.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Mon, 24 Aug 2026 04:12:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vgVlngUUFKckHdHSM12+VNVhQ7vOEpRXg2IzF5oAVzqWZouiv4j63oHQ6CI+ehWLoPK2T3h/oL5FT0HkOg3/o2lcMpxLSpnJEPLdpKDYWHh8WYGdpKvBAuJbCe2winnbc9rr6b0B5KHaDYQbRD8bK+wtkUOdR/LChK8m5CBico06A24y1qKXe+m6IAEbeqMxOl+V21GQbwSfSQcmepZ4t7udz9XkrtNdmtc1AgM0gJmI4G7hBhZE+KK6xn1Q5LpCBG7f0tBHQnpBsYvAPrzjqN+JdNx79qnZ8fgmPc8Edqp0uLQcCg64zQW7HZEYH2MTNP6oNA/vNBkaEFfKfXQPXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K5XnY1jYo4cNhUMST032cuENMUAqCBvCSSptWmJ+sJc=;
 b=rX+DxEem6QA3P/Xl+jZs3lXCdMf1esqAANcc0eSO1au8W6/LYnScg0qnymbZ2Xz9rbhAFyx0HQM4leiODd3Y8qhmT9R1J4fUt+fAtGZ1Yt98EZzSGjPjmAOB4hV25WGD45YVLlMSitqE0jEpmokqDd8q60uCTwFyA1dJpA/jnRS2Cm/uskUtL4+Jxttp9ktxPnHfufWEOQgZTYt/pDGPsu1BGMjCRl1VZ3aZQ3LHBZ9xQnlJd97wbCBrsvAzcBaj5Gp/R100uQjbzzwJhSYYLDsKgAjUlAq/pgTd3AEOjA8NI3eAusx6nnwogH1wrad/utaIJpidZ57q2OH3xWxdiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5XnY1jYo4cNhUMST032cuENMUAqCBvCSSptWmJ+sJc=;
 b=KfMCPvmB5ftArE52SfRWIaKk2lPoYB2alWIq3ngiOpdYYUUWHQwwyo8TJMpN7ChpNTawB1sSNPnAu38RRyWDPCFAeB9kLYb0G0TOfjuXemgHwcUDc6qj8eCiifp4TVYliUQ/u3aha1ml8Ay4ocYF24uPAR66j2ojxPXvm+w8GwM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DB9PR08MB8673.eurprd08.prod.outlook.com (2603:10a6:10:3d3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 04:12:12 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 04:12:12 +0000
Message-ID: <70939c0f-da73-4b24-ac10-38ffb42ea121@arm.com>
Date: Mon, 24 Aug 2026 09:42:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/6] selftests/mm: separate GUP microbenchmarking from
 functional testing
To: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260813181230.483746-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0097.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1a8::15) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DB9PR08MB8673:EE_|DB5PEPF00014B9C:EE_|PR3PR08MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: 7780f787-d38f-4f33-8526-08df0195f3b9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|10067099003|5023799004|11063799006|56012099006|6133799003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 GSfrUvo74mSc1fJAtzy7eQo7WJSHUjMwo0IaYD2P+E9lRUWADNRz1DFnDPeN3CEXu0B/205HABqmgahfLti2eNjvXc8FoY2UKYGt6UiDMgOnOx55jfaB2xSAkkBGeFRO+mTpfA3e27tKcJqxEW1sfd6mazRjlhhsPlWNHRvwCo66ZxVRm9CksRTdcwdkGbOyy9DRZ4HFryubhPqXUS5vkLT4uZMqts8lyfxb4sIbImZnkgX41rf0QBGL5S5NBbPEwEAT0EC/e9x0Egx9inQQsRB89m6mkHezb+pL7uU+Wu5bmHEOt/jT1LYXVn840GqoH+aucCX0UKN+cHHg4+JbzVaI4/00eQTAdLddIV1zWflTlbeDHtRP48oOI8jLZ3+c38Dm481ddRNCK3e7iUQ+obGF60Hxo8s5WU7UX3zpX7vhkLB5FrZbD+sT9IE10s9/5lmpYpzQxKzb2qn4u1EyOtj1L3Y3eTgjhhtmtgmi1nZY74m9mXouSTD2JwYfc77WCpEEGKjeMhWOEkzwCqfmtLw89ULpTXEdu3IQ7WWHzZ5JSaWdrZLG5H3Zm+NnV/jPbhQG9CJRA0UgnQZWPKeolNTlQeeSFycDbIpJb0jMyyRS1jMpIekbaUZhzaTvlYCW1I9NdkRx6tzMAGweUqMrNhqTvs7jH7fQZA5kyGkRcxY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(10067099003)(5023799004)(11063799006)(56012099006)(6133799003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 y3BsJFiy7MjoQQmryrj4Lsdeh8oMtLSsx+mAGyhaS6e9PdBRWtFc8ZDDbOG6gvQc3fbCfRrE+pyNHwqRma5iy/sYl/2mG16UixMPMNI5jf8ELC5TRg3ePhk2C+9c0+O0dVbGtOTyrBpQXiCd1riDUOTaNGeLmqda1QuGlem2KGOtjVXO/yecxt83TPqRgISPucbpDlLeOBXCIMxaG92cRCtODnvNfR10CadEZ5Ew9miCgsGBuQDdqMfTeSq3WXQPZhq5YL+Fq5GnV38jjPcroRevuSJXqdJ26QQUsY+MUOHvRA7ONKjbv4vBp9n3ec9Vn2YAuF7D9z8Cn4KRTc+FCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8673
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b839d963-ee43-4bbc-b084-08df0195df46
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|14060799003|1800799024|82310400026|35042699022|7416014|376014|30052699003|23010399003|18002099003|22082099003|11063799006|5023799004|56012099006|3023799007|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	1VqOYHEHVCt3bjV4WRnF060n7Mk7LrL3CnCU+g3HLtJFUAMuUWxuWJtTXSAc3h/uoXIzVvuX8oUReu1D34a689hplJ54V4cVXqS2naORkCL1AdZMhWHUEb7J6vs0ds6lPPK1h+PhJ+7OMkhKWII29MWunTRnmjyO43QnYtiLAqbDAvWCRCJQVVlhZpRuSve+Iz3RBfXdBYG7YM+D9m887zJTSPoqZfbMemPayMjLzuRrE++EgSzFSbKt8L1Rznou52wowsq7RFTjXOdXe0nhESYkunXHu6I4nHVOkzqKbaySfWsvCRJA28/XmeKpOlOwYDJkC5kZcrAYoo+MRDQXHClCclkgHxLnQpA0pEaF5XLrqIkouLMRgS/LMNcMO/vIMjtgXStK20YGCo1Lsf6OSYDy0Ysdo/S5MBdCCy1REImzJnmlQlTllv4E8l1UAk70FkZRs/WBM509wkYrJ8pOwdyyH2a/hZdXIZtV0Hj4eCEuo2ihqta+s9fgUIg98BRFobPfLMjFAkXna1g8Op04KSEcwx1rjiyf6ZmVhHGB+n+YMLKN2HlVVIuS8hHb1SSoJOLe+MpIcNd4ZQdb23TjXgiUEGi0pK8wwXnz1TS9qugYa23DJQyPCbO5ITEDoO9CUVOjssiRGGsCUqkqn/ittgOjQEo4doZVWJIKh8fO9SEoriWhDQniLDvSzZqxc3BmDJ2U6TeU6JQRnTjEQcXnkw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(14060799003)(1800799024)(82310400026)(35042699022)(7416014)(376014)(30052699003)(23010399003)(18002099003)(22082099003)(11063799006)(5023799004)(56012099006)(3023799007)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1mrWi0paaBpYkF1RTFk+53OJY87FhW0CDv8SNE5G5LxL1uioYuQroN58TLHervC8m2r9aJrb1h19hswgY/IsZYDFNkk0F3CpO6EKyj7XFharpPwG3ZVc+Z0abVXVI3nCl7ylyrCptfDa6DoABI97OkrCKpzCdUwSLP0jfF8PbkPeDnwvovUAzAzHLugIjcH3EtYBTjpr9aw2MuVqCVw+Y9H3l/iMgbKrmZ4Af8Q6H3vSb/HG2eABpv3EQ0G81NGx25uHn03KL2Cx9RbXdJALNLju9ve5APhEcYSPkVBQij7QR6xRfe84m/DTK5lylBQssn/Go9iTEpuWDxtvznMiP50ULRp2Dn65lpRRx5HqJQW9So1xZx0iVk4/m9lucWFiMXdv8xQXgcS7ftQjmbYba8wDrzWLS0dF5PxsKdD0iemSy6VClxxgtB76Ru/8aPPl
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 04:12:45.9708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7780f787-d38f-4f33-8526-08df0195f3b9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5820
X-Rspam-User: 
X-Stat-Signature: d95as4n7aftmbttzf7gb4w3mrky79334
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 80928100004
X-HE-Tag: 1787544771-895537
X-HE-Meta: U2FsdGVkX1+G4a+LzDm+z0Rc2bbJz+/hh5bQGMJGyasBsh6Iwv1eulENmiibr7fls9LaJ98x+JPYj9g7pyDpJg4SVpwnKPhKp8V9wgRYaNyJ36cc7285xGDmReHJNMMiX5+QL6tmJ7MknqyJgm/4z1GhemLdI4f7VjYBwWeSrG5rPZTm/0JP7zQtBbnTQVSk/BsEipwlAz5OzE5KFfosNFym3KUy/IMFdKbotZPGoIBJXr+8c836PLvYUFT7TWOC4rUqQJOh/4efzXNh3AHFQCDEHEqRZ7XXo9zQc7v1lZO7167BWA0ryj78UQiH1UnX1b+6vGDBALiT84MVamh64DgA1jKT5t7SA7emiAqYRzkgZQiss1ArdIBQc0GVRFtOobiJ3K4cFOuhxMlekJlHrmjTl6mkzzBH/o3VIxnj9gbZLhka7cDemCv6LMxqG2yr1xFruphqo9u+OpVDCyHSBdzn4TqoKKZEZmFotbQieobgzTUs/kFIKpLHU7o9BqA29CQt1yeC6gi9KmO71K2FIhXILryRUww+0cpyD/fixdc7v0U4Jb/TJQljIyLxBXcxS/5crqrFAoh0sE9kjslYpeIKM7bZVgfrQ4Dg1wUc+PdQLZmoxUHFMEpWQnobZuL0Act2TrP5y5e+GNOvtH9hIyvZhFjw5YOy9AB+LN4cj7x9wH9Sa/D7KwSDQ5J3WtNzUacisjgVkZEzimV6unuyIpI0iTBkyKbrt6fNzanLBMNUdOH6YkAsCSAAwosVx4HtKeOj5wZHwAfJFlozKhMbXNRzvQorYV8F8vCW0B1jIedmDfrNHhYo9bsNHAwxF/AZa7hNkIiivKw1Ageqe2R15q6GuAFZh+wp1LBoYnFpdqf3VwQoQcowEOHYUD5Ue4MCwy1r8dpM7WVD7wHU53LwE+GvpKUNS2pK+u9VImd88ZE/hZ0Mixe6d23ktGQ2nznAZTd2Q5Zo4gTDdOvIBkU
 LK7F/tgD
 7Z7aIulf7+2qpmHedwzUkQUlKRSWuzz5MwjocImhwiSu3zfZjTbjAZ7ExFP49Lt0cdB4mq4+4LRtvi35Y4y+XQfZ5UkYV4fdi4fKeYgBv6CZzWgao4ZLr0BeUZKLTOo2rhm8Mp9RJFObfqfbon9mbqG703oyyvkAw0+86YCG/ORURl19Jpx21msynPNT2LYHlisGWSIoLEmzKtBPpVtfmvCfJxF4I5XSzMOhH33u0RVFQ0N8jZLvldo4mkyZsEQKLEpFHQYFAKlRcCq60IsuOkDUy0QIuTunKYOuRHcI8XzxSD1DEMpNrV2NLqSLBUXPKc6HdZ/6KpaWL7wa0RuSjHLe3HZBWZiv9vAAQs2pBeB3KHJ9ICV/aTZ27PXU/IuIvUhurBIWRq+FzWgCJ0goueYcguMFDCpx6wql2rMOEjfzdjLdAZMij/yJtVN5SRxECcTfPBBq1QUDa5n2yyRSzY/YbPvAoRRrLhT2H55dTqniQA2GEO3Iz4cUGeCE1r3aVR5jhhgGJ7/umwb1wwAxJH5pOheDsgFmV4ztJ4LeTIRtr8vIWeDbFL9VciV3q6sIQG/Rr55NgVMQEk6d+KzmPL2jp5Pp7KpnkQ6V8fcmTDbyKhg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/13/26 11:42 PM, Sarthak Sharma wrote:
> gup_test.c currently serves two separate purposes: benchmarking
> (GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK and PIN_LONGTERM_BENCHMARK) and
> functional testing (GUP_BASIC_TEST, PIN_BASIC_TEST and
> DUMP_USER_PAGES_TEST). Keeping both in one program makes the functional
> tests harder to run and report individually, while run_vmtests.sh has to
> invoke the program repeatedly with different options.
> 
> Separate these roles into tools/mm/gup_bench for benchmarking and
> tools/testing/selftests/mm/gup for functional testing. Move the shared
> file and hugepage helpers to tools/lib/mm/ so both programs can use them
> without duplicating the implementation.
> 

It's been a while since I sent it, so just wanted to follow up and see
if anyone has had a chance to look at the series.

While here, I also wanted to address Sashiko's concern.

> --- Patch [4]: [PATCH v7 4/6] tools/mm: move gup_test from selftests/
> mm to tools/mm ---
> commit 92aa92be01707caef105298876458c303c6513c8
> Author: Sarthak Sharma <sarthak.sharma@arm.com>
> tools/mm: move gup_test from selftests/mm to tools/mm
> This commit moves gup_test.c to gup_bench.c in the tools/mm directory
> to begin separating benchmarking and functional testing components. It
> also updates relevant Makefiles, gitignore, run_vmtests.sh, and
> MAINTAINERS.
>
> tools/mm: move gup_test from selftests/mm to tools/mm
>
> Move tools/testing/selftests/mm/gup_test.c to tools/mm/gup_bench.c.
> This is the first step in separating its benchmarking and
> functional testing components.
> Since the file and binary are being moved and renamed, should we also
> update the references in mm/Kconfig and Documentation/core-api/
> pin_user_pages.rst?
> For example, mm/Kconfig still points to the old path for
> CONFIG_GUP_TEST:
> See tools/testing/selftests/mm/gup_test.c
> And Documentation/core-api/pin_user_pages.rst still references the old
> file and binary name:
> tools/testing/selftests/mm/gup_test.c
> has the following new calls to exercise the new pin*() wrapper
> functions:
>  * PIN_FAST_BENCHMARK (./gup_test -a)
>  * PIN_BASIC_TEST (./gup_test -b)
> Could leaving these unchanged confuse users looking for the test or
> trying to run the benchmark commands?

Documentation/core-api/pin_user_pages.rst has been updated in the last
patch, after the gup.c selftest is added. mm/Kconfig is to be updated,
and I can send a fixup patch for this unless some review comes up that
requires a respin.

