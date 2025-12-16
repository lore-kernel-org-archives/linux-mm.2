Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F1CAD609D9
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 18:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21E466B0088; Tue, 16 Dec 2025 13:40:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC896B0089; Tue, 16 Dec 2025 13:40:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0588B6B008A; Tue, 16 Dec 2025 13:40:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E714D6B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:40:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F58013BA5A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:40:34 +0000 (UTC)
X-FDA: 84226199988.28.E5CABF2
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010066.outbound.protection.outlook.com [40.93.198.66])
	by imf06.hostedemail.com (Postfix) with ESMTP id DB7C8180014
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:40:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IvTVm7XD;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765910432; a=rsa-sha256;
	cv=pass;
	b=Qy3XJ3YDFpHppROyKMh02b7DOIDU+aa6vJ0sGROw6zhS4RCseL3Enxz6GRE7MMqpxEig78
	9fzlPM14O+Za9SU6rBxIfBqDnGrjusk8arfsEFpCW0pYzZCXjvGjihb7Zpg4Cnwme9ditR
	wrBNAX0Yee2fhSUubkBq2Tw7LDdkzm0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IvTVm7XD;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765910432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2V5n7h69DBCVMrp0voFEsz0c54LR6bWvzGhZm2v1CQ=;
	b=o+A8v9HgLTw/HG3RQD9MMIwEpzK+sBNgLNHTf112EycaRmmPxRSOpnsICUOb5uwP1AxBLN
	PHX3PJHQymSiL6ZLR6wkCZ5qRnUM+Cy9tpQZ5Pok4aDzMln7ZLX8JC544os3pX5+7oDTtp
	ICD9nVkCCSnUGi9pVs1pQenehzWnhuE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ten8ygN/UoTJ2Wii6leADW2jJ8nqW7KIhyZ8hwTMwuJT3lQFoYv+sBeaRMXYbdHA6WHdhVpXqlBvVjBrUnTBpebubtv+ZphrgfUrjGZdMA8O2nKpX8ivM5AW94LDjFA0Z51+UygvtCwDyzOsH1iWEPH8GagBYulsHvR2fszQlPcZsly4/97+ViCyylOx2FjHzRD6+libOBZI+EBCpio0MjzaD2itbup9s9NLpQj3hHjl/qkGSitc/FNs3YaWTbkQzNKhr3pQnH8RImmR26BKrqqANVgUSf80ABChnypwyyH5GBA1HQJIiX4/1n561+Ea5vHEkY+RPQ6HyX62L6kVHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h2V5n7h69DBCVMrp0voFEsz0c54LR6bWvzGhZm2v1CQ=;
 b=lw960UHGa4MbGcyZWVutrGB54Au6Rau3tyJ3+RWv/ord7xQdXFu/u5ca+GnJh82V6K89L+f55futBYt31PEgvz6gu3+NvEdZr24B1F0HCWC5CaPmSdXKrsy7iibKl43Xl+nnri4DKldxXRLuBkczZN7NOL6myo8mtHMDuGhttLvnoQlaBO5dhIQn8fR1ctz4LdaPczvCbI8HM+h5mE/pVADqyUJtUx2DRYFeyN+iBzWxS9dxkyZOf+7vTwfgvkFX1jXygDVFS9V44uLvNj50raMfXaG9EcSML76oUqW5m5aeOTaKIfovbWjYC5jWaTLkP+RLjLxhJCHnOnIRBX4DZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h2V5n7h69DBCVMrp0voFEsz0c54LR6bWvzGhZm2v1CQ=;
 b=IvTVm7XD/IeCtTIl9JEz1bFVnkuRbYBFd6VO/pJZ71Vgl5Yucmbe9d+7iRIROizNtajb7INuEESl41wcM9PmRORqR7c7PPRRNTXREyMDOrjgaZn1dLdydpLobJN6nKmSiWAkq3pwzPUwHnABeMo8L12sg8rbT0Nr/Dfg4B6CM5oxBIzOgSAHhZuqS2fZ9vAWfYojMkxoxk2dXcINsHs/hFbVdZLW5Y0lkS6tpzSPswdrX9AY0WBjZrb3eeTlRPUpdE3nsoA8K6b82O4q48K/eKLQKPamIMh9S6SDECRL+dBn4KQ2kFrmdqVkt9BPtH8040dz504FAyAzG/w++4z3Wg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6622.namprd12.prod.outlook.com (2603:10b6:930:42::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.13; Tue, 16 Dec 2025 18:40:22 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 18:40:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
Date: Tue, 16 Dec 2025 13:40:18 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <4B10600F-A837-4FCA-808D-6F8637B073F7@nvidia.com>
In-Reply-To: <20251216114844.2126250-6-wangkefeng.wang@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-6-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR18CA0006.namprd18.prod.outlook.com
 (2603:10b6:208:23c::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6622:EE_
X-MS-Office365-Filtering-Correlation-Id: ed921743-0569-47f3-b7db-08de3cd291b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Sm5xblU4djlwY0pIQTZocXc0VWFmdy9URUFtQnlmODQ5am9XQnFERW93VnE0?=
 =?utf-8?B?eUprOEZJQVg0NkNmYi80dHR3eXRuREN5cUZPMTkyK3FaV21LODM1RmV4T1M4?=
 =?utf-8?B?aXNHUDJBcGI5ZkI2aDRsblJCL1dVWVlWSFRtV1FPNC9EUDRtTGtPekVuaklm?=
 =?utf-8?B?clRCTnJ1akhyV0tsa2NiUmRpdGRjMmNxdXZ1MFgvenJ0VkdRNUFxQWNaczRm?=
 =?utf-8?B?MSt4OWpkeVlqSzRsaElQS0xYRzl0SGJnaUsvcUVEQ1VydzFURk9ZTHFGdjdz?=
 =?utf-8?B?aGZrQnp5aUpxc0JPWjR3WDJ3RzRzQUloU3F4YUhFcEo5YkN3cC8xS1B0cUZ0?=
 =?utf-8?B?RTF3UzBsL0VsTHZISFN0Qk5WU3NkYjJrenY1dGZyVWdpTDc2ZmREeUliL2NZ?=
 =?utf-8?B?TlFDekY2dUhZcU9QL1ZBczRLdTYwUU9YeXdPVW1vdEgwbm9BVThIMCtLQVFz?=
 =?utf-8?B?NkFFaWs4OEdDUnZ3eHliT1RGUjFiVDVMQmFaWFh6cVFGcE93Z2ZTd1FzWEZm?=
 =?utf-8?B?NTFHMmo2QmFxMVF5S3FGRHFyWWxrRnJEYzU1YVRVSDl0R1kwVEtWV0xQVGpo?=
 =?utf-8?B?VWw0YVI4OHdwM2VsbDBQbVk2d1ZBLzMzMDBRZllUMnNvbVZSNHYwNWEreTRI?=
 =?utf-8?B?UlVhenhoaHpxNUtuaVUva0tVdDh6c0xGeUZ1bnJuaU1sWk9pbGhDbCtUMmlE?=
 =?utf-8?B?am4wZmZnaitLTnN6cFBZbDZUMWdsMTdjVmwydFJGaTAzMHJYaUlLVmltMVd3?=
 =?utf-8?B?dTdYTXpoRzRPTzJ2YnFkK1BCQjlDb3pVT2U5WkV6ZUpkRG1UN29KTFpJRnhh?=
 =?utf-8?B?YkNocGZqaWVVQTVoTlE3TEl5WFdFWXJQOStNVHBPNTdFMG5md0VjdUZoVEVz?=
 =?utf-8?B?cytPVnRNR2FVQTZDNk1lcW42cnFpb2RWakVDd3VOZE1qUGtQQUxrS1pUVXNW?=
 =?utf-8?B?Lzdvd1d0aE0vR3dWUlFzUHBtWDA3TEFOdGpJWmRQeEZBMXVJRHhqUXJTUEVE?=
 =?utf-8?B?STdnMFlNUWxKbXB2eEpJNXovTWRsMHRuWmdsQVdnR0o4WE9qMkNoOTBTWlMw?=
 =?utf-8?B?dGZJZUwvUWtCYnhtdEtaTTVkZ2VMU2IwSEdFamxISG94YlA3T1VRVXRHck95?=
 =?utf-8?B?aGFoQlg3UEVmRGM4ai8vaEk1SjB4YWI1Y2d6cDhRVTIzQndkTEtJZERPREVR?=
 =?utf-8?B?RWQ2blZLb1krNEZaWTM1VlY3c1pSZG5Mc2lOVjZCYms5b2RzaFVvT0hTMC9q?=
 =?utf-8?B?NHlFdDE0YUYzMmU5MHhWbVM5OVFEa3MvemRNSXgyVllOTFhSd1RTM1lIem9I?=
 =?utf-8?B?c2doKzNTMmlDZHR2eGdKdFVlUG1hSVh3bTRZb1BmYldJV01VT3VJTGs4K3hU?=
 =?utf-8?B?NXcxZWVpeUxsRVBoU29SK25aUnB3UWNPVnVqZkxjc0NJTFM2b3V0WjdFN1NS?=
 =?utf-8?B?OENBUkNYbTZKZ2t2cUNvKzEvbXhxdFc3M1dpN1YrWTNZVFBPdTEwU1hnaTNX?=
 =?utf-8?B?WVVzSEcxWFNVQzd1aG4yOHBaL3UxZ1I1NmFLYlJveitselJhd2p0bXdNVjU3?=
 =?utf-8?B?YlJnNTc3SkhLRGl5YThyb2hGUDJzUUpTS1ZkRzFkakZUT1hYbVpPM0RFbTRn?=
 =?utf-8?B?MTh3SC9DU2pnT3VjUXJ4ZUVTRWt1WTFPMldUbDhPVDZicDFhMXJXWDBweDRH?=
 =?utf-8?B?WmZpYXRZUGNOZytuYng5TzNHZEc3c25VQy93K3NnZkovb2NqVWVnMDl4cUds?=
 =?utf-8?B?U3ErUXNpNXg0U1hteW4yOVFqbHhnZXJ3ZXBzM3pyVGhyekhFYVBkWHI0QkZD?=
 =?utf-8?B?OHNUQ2x2MG5ESHVoRldmM1lpdEZLUHlxOGtaUUtxUlRxNmRNNUpzQmh4S2JS?=
 =?utf-8?B?dmwyQ1ExcWRSaDRXcVhCQ0ErblA1R0czZjBTMjRkQ3Myby9UMlk2SW5uM3RV?=
 =?utf-8?Q?uDAVl+PUkhuprHAP6IElMc8lxWRYORAn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUNMOU53Rm8zUUIwZ1NSZ0p6ZEtZZ055TnA4cnBxMkZyanl0cEpRSlNZWlQr?=
 =?utf-8?B?cktJOGZ4RTdRWTRHNWRWOHM1NjYvdklvNXMwNFFhOVpLMUUzanFEZGZJT1hP?=
 =?utf-8?B?L3g3WXU3TUc2SmlDcEh5UmRwWjZZaHdhSGNRZXFJOCtxY1l4Qk9PT3NxMTBV?=
 =?utf-8?B?L2VTcGRVd29mZnZIaTFlUUZzZVlzVGgvT3d1Z3diam1hai9xc1FKdGJPNUcy?=
 =?utf-8?B?eW1HYm1YSnpsUE5EVmpjS01FM2p4T3BHNmY4UEpMaWpCWEpjUVA2QUVuMXpH?=
 =?utf-8?B?MlZydWtIa1E1OElqbkJVWkFRZllMTFpreHV0NzBMd2lLZk1zQzBXM004M1RB?=
 =?utf-8?B?dXVyNEV3VVVvc0F3RVk3M002Tm5qTVVSN2JFbkk4dHFkOXlRTW1aL3ZldVdU?=
 =?utf-8?B?ei9sdThvQ25VdzZCYUovNWdJcDZ2M0hRT2pkTmg3RVE3V1lmMk1rNFVxZHFm?=
 =?utf-8?B?OHd0c3RUek9oc3hmNGMyTk02eFpvZEpwb1FwNmE0MnJKaGNvK3VvaVJ6MXJL?=
 =?utf-8?B?SXQ1anRta1V6WWpTK1dqU2UvMGc4bzNkMTNyTDlzVWJlTFdiSmtud0RIOFFX?=
 =?utf-8?B?eWZuZHhNOERZRXcvTDYzbmNNSVRzTnNhUE5WWG1xc0dNd2RqNEVkUUxybk9x?=
 =?utf-8?B?UXV2K0ZPUDNlc1QrWVliWkFyU0JtZkJVL05yY1MyYWJ4emRkcVh5K1FsMkUr?=
 =?utf-8?B?K1A5WHkwTlNHQlM0VUpIKytlOXhqNVMyUjh4dXk3ZXcrTENxY3RWRUtXMVcy?=
 =?utf-8?B?Tll4NlVIaW9HR0tXMVpyZHIwTlloemJBc05OeSs5SVpaZDIzQkIyQzFKdHk2?=
 =?utf-8?B?TnhKeEZ0OFBnMmpvU0Z1L1R0V3pvOFFLTFFIdjlvQzEzT3lSRjBEZDU4RVlp?=
 =?utf-8?B?aGFXU3BoVFBNK1c1Rk1iRFBHWS8yeXBLMmNUdjhLTzJ5ZWVsZmpGRWtPSWdM?=
 =?utf-8?B?WU9jTXlZMit2Y1llNGhoK1J5WWVHejN2WkVKa0s0cHZnektyc05HTFBrTUhs?=
 =?utf-8?B?QjVtUkZIaDZ3ZmF6aDBvTG1uU2JJckFaVzRiMGtIUHJHcE1YQ2lmNjVaSVFO?=
 =?utf-8?B?bFRtRUJ5S2tSRzdBSExIU0g4TmJocSs4d3ZLNnR6bGFqUUNXUjJMTm82UXlV?=
 =?utf-8?B?MDZpVWEvUGp4SzkyaGRyc0ZyVFpHQk1GaDUxTEx0bVN1RDJyU0VYOU94Z3FI?=
 =?utf-8?B?TVBKZUdmYVhoQ0p2SFY1UU9vNXhvR2Q1dXZIK0w2U0Vpb3Zic1VPVll6c0kz?=
 =?utf-8?B?Y0dsaTJmY0VZUEZKK1hJWVNjMDA0ZnBJamtMWU84QlY3Y2FzQTNxVXQ0RFBF?=
 =?utf-8?B?UzNKU3Y0dk83SmxBeUw4RDZzUjVaWkxYekI5V2xxMkViZjZtZC9OL2tpcWZq?=
 =?utf-8?B?OW8wZVBtdmR0RGNBNFVxak9sVDFKV29UREZpcWU5b0FKd0NKSGh5ZktyMFZE?=
 =?utf-8?B?UGgwbG1pY1hiQ1JabFBEaDZXTlExZDVQQWtmMm9KRGpnOFRaVHdzdFljakty?=
 =?utf-8?B?Y29OWXhZVHdZMitXOStTdFd0NlFaU0xxU1g1T0UvM0ZSbDE1VVVmVzhxS1lO?=
 =?utf-8?B?QVR0R2FEYThETDVtUndHMjd0MHk0aEdzR0tsKzB2Zzl3b3o4Z1RDeVg4WWJU?=
 =?utf-8?B?aU1uZ0FFeklmeERBWkRYRUlrWkNUczA3eFhwanRGMUtNSTV3aFBGTVUrNTlB?=
 =?utf-8?B?NVhlMTFDOE42ampibFFpWFRZcjFVLzJtYm5ldzc2N1JJaUhIUE84WkF0djVF?=
 =?utf-8?B?RjU0ZkZNQ3BXdHJFdlNlaWgrSjFhd2pnZkxpakV6eTc0WlhabUo4ellDZUhB?=
 =?utf-8?B?VzdIOWVMWWtKQ1cxd2JiYUtyL2taTXNwVmVENXVZSXBHNEpaSkJFKy9VTytj?=
 =?utf-8?B?YWdiSFNjYS94QWNpOGR1UURMb09KTEZHeFhyTXN6OWtmQnlKQWdLRTlDTTNh?=
 =?utf-8?B?Zk5pYTVEQkVubmxGQS9EbFlYU29Fa3IwUUFBMVFmTFhDazJLZngyUEpRcGxx?=
 =?utf-8?B?N1pHWlJaak02WGcvMVZNZ3V0RDByTDVIMmwyQjM4UHdCNkd3KzhkSC9TbUFq?=
 =?utf-8?B?TlE0S0c5anJ5TDk4bS9IYjBNRFhnRUxOdXRXMVNINWFvUE5ML2hPeTk1TnNl?=
 =?utf-8?Q?MG39j59721rT1Epk99DnSrNEt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed921743-0569-47f3-b7db-08de3cd291b8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 18:40:22.0237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UbP8GOvh8HrRbiOZxXMkYf7eg8uOlIiZVozZySX194hf7MWsWhV3R72wevAIPQkw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6622
X-Rspam-User: 
X-Rspamd-Queue-Id: DB7C8180014
X-Rspamd-Server: rspam10
X-Stat-Signature: dsg4jh9zyqqke1ynmpt8ahrwyuiwag58
X-HE-Tag: 1765910431-553523
X-HE-Meta: U2FsdGVkX1+EP46eGgsS7R67D6tIoambZaMYb4KAWoInNx15WHRdlaouDQXxqIR8X1wu55G61kSAKTsTTuLDhxTc7GK1w57xaVApU/0Dz6TsygpHZIg5o/T7QP1bNDjxq9bIG0GZXaauWmsdH7zKSSv53NPWc6vWtGVVEIKul3QHBRevtyUNrE82lFP2LiKahYYLi69R02ZIssBN36rXCLTcZECqJ5HC3oDb65JZ19dJf2lZWgmSz5sKN8VxQXBCvqHY2T9FHbHLH912YA3hNWGSlH0mR/xYr8pOg2G+1IIuQH52femp20+5yEa6OOsp8ghXfG+smkshLtuE0xkmM2pso73rejhhK7NGuHWThTWL4XuDr/e5lsiKVjI6MT+3EnR4cTvgRjF8SI32kFXMtA/ij48YIGQkfayShSch1pu7xAiNqhmENBB0EW/wXhoZ5c20/exfqE0JzS+M0lSKbzrYxF8S1iTpM5af/mHJxmczVMcHWKM8wIyoejtst7jsckQLxPtW1a8Y3cCYeGuXlByKo+v0VnYIWPT7Wl2JeUP1u/ZSYJv97/tL801y8YJtJ03auJnB+9r9qQ5QvMIPATBLKnM9/2HSjHGzuJNnz9fosfvTlWxxmW3DGi6yR4Ono7XbttUYh4CYOhIEfAeAJLF7HB2BhVEoaEFZ5kg9YuuFfDv4DE4+tkPxvCcJnjB2FbqGOrZZNpJMQyMCOfzlYNagr7TqdCKt4+rJb5vxORhqiiK8ziRw0yKl0mMmVCSV7+RdGMejeSsITxRTlk6MwktmcM/QAsZdL9f4RuMQGRAj0OQS8w20WQYOYAOFqKK6vMXjO/O5B/Q1EdZlo7zMbU2TpxEkzmxt3/Rzio6UM6NK8Pd7Y7y1WXkH4vvsVvFqscXfLL1Imuv/mmJa/8QjsyRLA/JwF4TXJgnAygPciCKnLHHffrVKmcnTTpOzRFx8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Dec 2025, at 6:48, Kefeng Wang wrote:

> Introduce cma_alloc_frozen{_compound}() helper to alloc pages without
> incrementing their refcount, then convert hugetlb cma to use the
> cma_alloc_frozen_compound() and cma_release_frozen() and remove the
> unused cma_{alloc,free}_folio(), also move the cma_validate_zones()
> into mm/internal.h since no outside user.
>
> The set_pages_refcounted() is only called to set non-compound pages
> after above changes, so remove the processing about PageHead.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/cma.h | 26 ++++++------------------
>  mm/cma.c            | 48 +++++++++++++++++++++++++--------------------
>  mm/hugetlb_cma.c    | 24 +++++++++++++----------
>  mm/internal.h       | 10 +++++-----
>  4 files changed, 52 insertions(+), 56 deletions(-)
>
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index e5745d2aec55..e2a690f7e77e 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -51,29 +51,15 @@ extern struct page *cma_alloc(struct cma *cma, unsign=
ed long count, unsigned int
>  			      bool no_warn);
>  extern bool cma_release(struct cma *cma, const struct page *pages, unsig=
ned long count);
>
> +struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
> +		unsigned int align, bool no_warn);
> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int ord=
er);
> +bool cma_release_frozen(struct cma *cma, const struct page *pages,
> +		unsigned long count);
> +
>  extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), voi=
d *data);
>  extern bool cma_intersects(struct cma *cma, unsigned long start, unsigne=
d long end);
>
>  extern void cma_reserve_pages_on_error(struct cma *cma);
>
> -#ifdef CONFIG_CMA
> -struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
> -bool cma_free_folio(struct cma *cma, const struct folio *folio);
> -bool cma_validate_zones(struct cma *cma);
> -#else
> -static inline struct folio *cma_alloc_folio(struct cma *cma, int order, =
gfp_t gfp)
> -{
> -	return NULL;
> -}
> -
> -static inline bool cma_free_folio(struct cma *cma, const struct folio *f=
olio)
> -{
> -	return false;
> -}
> -static inline bool cma_validate_zones(struct cma *cma)
> -{
> -	return false;
> -}
> -#endif
> -
>  #endif
> diff --git a/mm/cma.c b/mm/cma.c
> index 7f050cf24383..1aa1d821fbe9 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -856,8 +856,8 @@ static int cma_range_alloc(struct cma *cma, struct cm=
a_memrange *cmr,
>  	return ret;
>  }
>
> -static struct page *__cma_alloc(struct cma *cma, unsigned long count,
> -		       unsigned int align, gfp_t gfp)
> +static struct page *__cma_alloc_frozen(struct cma *cma,
> +		unsigned long count, unsigned int align, gfp_t gfp)
>  {
>  	struct page *page =3D NULL;
>  	int ret =3D -ENOMEM, r;
> @@ -904,7 +904,6 @@ static struct page *__cma_alloc(struct cma *cma, unsi=
gned long count,
>  	trace_cma_alloc_finish(name, page ? page_to_pfn(page) : 0,
>  			       page, count, align, ret);
>  	if (page) {
> -		set_pages_refcounted(page, count);
>  		count_vm_event(CMA_ALLOC_SUCCESS);
>  		cma_sysfs_account_success_pages(cma, count);
>  	} else {
> @@ -915,6 +914,21 @@ static struct page *__cma_alloc(struct cma *cma, uns=
igned long count,
>  	return page;
>  }
>
> +struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
> +		unsigned int align, bool no_warn)
> +{
> +	gfp_t gfp =3D GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0);
> +
> +	return __cma_alloc_frozen(cma, count, align, gfp);
> +}
> +
> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int ord=
er)
> +{
> +	gfp_t gfp =3D GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
> +
> +	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
> +}
> +
>  /**
>   * cma_alloc() - allocate pages from contiguous area
>   * @cma:   Contiguous memory region for which the allocation is performe=
d.
> @@ -927,24 +941,18 @@ static struct page *__cma_alloc(struct cma *cma, un=
signed long count,
>   */
>  struct page *cma_alloc(struct cma *cma, unsigned long count,
>  		       unsigned int align, bool no_warn)
> -{
> -	return __cma_alloc(cma, count, align, GFP_KERNEL | (no_warn ? __GFP_NOW=
ARN : 0));
> -}
> -
> -struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
>  {
>  	struct page *page;
>
> -	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
> -		return NULL;
> -
> -	page =3D __cma_alloc(cma, 1 << order, order, gfp);
> +	page =3D cma_alloc_frozen(cma, count, align, no_warn);
> +	if (page)
> +		set_pages_refcounted(page, count);
>
> -	return page ? page_folio(page) : NULL;
> +	return page;
>  }
>
>  static bool __cma_release(struct cma *cma, const struct page *pages,
> -			  unsigned long count, bool compound)
> +			  unsigned long count, bool frozen)
>  {
>  	unsigned long pfn, end;
>  	int r;
> @@ -974,8 +982,8 @@ static bool __cma_release(struct cma *cma, const stru=
ct page *pages,
>  		return false;
>  	}
>
> -	if (compound)
> -		__free_pages((struct page *)pages, compound_order(pages));
> +	if (frozen)
> +		free_contig_frozen_range(pfn, count);
>  	else
>  		free_contig_range(pfn, count);

Can we get rid of free_contig_range() branch by making cma_release() put
each page=E2=80=99s refcount? Then, __cma_relase() becomes cma_release_froz=
en()
and the release pattern matches allocation pattern:
1. cma_alloc() calls cma_alloc_frozen() and manipulates page refcount.
2. cma_release() manipulates page refcount and calls cma_release_frozen().

The rest of changes looks good to me.

Best Regards,
Yan, Zi

