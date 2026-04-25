Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97CEFF8860
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 14:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150F56B0088; Sat, 25 Apr 2026 10:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1014E6B0092; Sat, 25 Apr 2026 10:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B396B0093; Sat, 25 Apr 2026 10:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD81C6B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 10:25:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAA76140366
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:25:44 +0000 (UTC)
X-FDA: 84697301808.13.E0A9C33
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011051.outbound.protection.outlook.com [52.101.52.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id CE97140007
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:25:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hPJKK2Pf;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777127142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjW9nMNlWVake+kcQPIDos9J3ZwwT2oOw8pf2epLCFQ=;
	b=W9t4Vm8qbosfs0eRA1h0dGWIDQBDvoBItsquuwZpODqKexXjnrn/J7mzqXLtnzIvQZN6JE
	GeI8twvJCsKQJpJ/vqaQOp5gDthVnZMWDA9lYLiTbxTWnG1gOE1llDPw6CgtCncKPXPsAU
	dXuyAIbt/Jvg7FDyleNmjAQeluiylvM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777127142; a=rsa-sha256;
	cv=pass;
	b=6Rowxu36JU1Q9EgvO5wX9pSolFKc1CVw7nm8BODdID0pnM2w49ECd6IBT0guMsCnh5I3Mo
	febwUOADBE6ykUzyOdx0EjtuAYhOOezJqDOwRYqWmiNsUA+t5oNTss75nhUocDhgp3CU8e
	vXgTvTyTmvQRCkfEvPSgZtAqPgUAIgE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hPJKK2Pf;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K/irTzBU6rKUQfaqbjtrgitY9YyJkW71fw6cKq3756tshwLOwO2nkin6eyRypfoMe67sHNoIa5KG9p2lZrQFX+eDqT105ZUMvKGW2VwXkHF0f+mwzAbcYC6Y0puyMF/y6yOUKejX63pP7N0gDtt7b9qlXmUZP8o1FL1JxGc5M21b4mtIlMz9WKyZeSYyiiZjzOj2WW2y0SAQu0H0gVGXDS+jJri5mUcefgqHAWZveRKDRLbNfHsEb/3GUuy0VIbHP6N4Jq6JbaoZDkOUO2M+Y9hX2qEbUoWq0UX8p4l4G5ej/6CHiC2ZRS1FPn3KXN3VzlDjJtPKetho0mA4JZeBYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjW9nMNlWVake+kcQPIDos9J3ZwwT2oOw8pf2epLCFQ=;
 b=eiEPpS2TYzftKzbOnlbpY3OnTk1fzm3MEPfBj5/2YzYHpRBPA3Lv/KdPJS7o7AC136NA6uiy85UDzQoT5Fxq1VuRrUOPAvzQ/oa7cZt/o5jtKvJSVFlKQpdvp62Bfeom3jwyUGKcUogN0hiV/Mn/X7lM3njV3WDYj0q5NrqbUKPjOTTHzL07FB5p5bFUnbaRptklZ/ZITV7B5dXYNxCzlVsmGE9Q+yoQMuIOsQhL2AlukJOc5OKf6KEOg8+wsk8lU9pZ7umpJUz/E1QnW/n2Ugf9hW7RA8ftZ6IRnrfD+l/gb6JguvtkuQnWBIXIOoNSNolqo30jATJmhUaiG4xjgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjW9nMNlWVake+kcQPIDos9J3ZwwT2oOw8pf2epLCFQ=;
 b=hPJKK2Pfi3eGYAXbZqdLNdrlu/Hrqx7J4glqiJvjUzO/Yqow1N51CeQVwyl5Q/HtS2BVFANONH7qy6zbX63KO78raWvtgs4snVUTSVrLFUaxLYOFaFWNJHoKNwJuqu0MQum3pCT/juwTUlHWQpQiRcq5HvSd1jWk5YOl4nTYdLktC2ycSgKnIP3DvDN8e1HL+FPQVQAxtH11wkigh+C6i3lXoBdYcIYw/PCY44X6Ai7TyxvJL6d2NL9aV5dOlhIHdMqswFcyesoiBDtlw+CYSoCrVsUfcYogUtIU+8DY7nEPyzndDj7/pNWxOKKY0lMIFipp8znajO8wp6F88XMbGA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB8430.namprd12.prod.outlook.com (2603:10b6:510:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Sat, 25 Apr
 2026 14:25:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Sat, 25 Apr 2026
 14:25:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Youngjun Park <youngjun.park@lge.com>
Subject: Re: [PATCH] mm/huge_memory: Fix outdated comment about freeing
 subpages in __folio_split
Date: Sat, 25 Apr 2026 10:25:34 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <DE2A2028-30EE-4BA4-956B-49694A57EF8E@nvidia.com>
In-Reply-To: <20260423034917.8234-1-baohua@kernel.org>
References: <20260423034917.8234-1-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0P222CA0004.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB8430:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e184d17-b544-45c6-74d7-08dea2d68442
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	3cLmHi5ZAf2jopAF7btB1++5DTfu5lW2c0yDQrUe7CdHSEvCa+iz38GaTyUxI1qKD4127vZqz0nsWR/LTr9CD33z5FdDAfM3n4ofcHUWNcoWta2db4G8vB2pimLV6lZaVQsYiTpjLhZFGkwxkL5AcjSC78d7NQpQ80tB6zm6JLucfvArkXzXH0wVIcxcRuzcRL2c/dFHs+T+bJ+hVgLq0DijPhm5h2knPCId8KqW1gh1jpRc08p/+mx0CIecK0S9mODbL2s70sF9ARF7DgY2ctycY0NniX9mX4KZDlj08PWVR5QWq9Z+XOBHLNeHJmCMkM36AXq5UDCLWbRQ17CHz9Lw2wRzi8j0tDX8rhi87ases2vAL7Gt7OrBtjNzPv65atkgnudnOr1hnuOYE+3cmXct+Kob8rMKCNiYuSPy+BTPzncRi47S85zEXoAj5r2vXwD2gI3uB1Qx2CIpCzDox3H+KGAxej8yaI01eN0f6e4+3fOF7W1xyDwfckgf4Ft+HJKDG+hvnYb/kjfiPZwGgr9SiH8UyLjLnBGMMwxbBOt2yuIDkjkcGlXZxTly315Prf5lrI+JsfJrR96wWjaPldap6vy6mibS9QN6JuzWhE4Y8Hwk1gCpnDxEl9RlS1KDr2RXY6aQ7VfnBzjY9ScaM3/HIaQYrJ4O7vAitBlTpXGRaaL2oeOoY56FyccXNiejEcDWV1X8mcF6SV2fNqiV0JH8K5i2rKmFiHkc8ca2QY0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmNteGhPTEM3aFl5cHlGazlodThQeEthYjVUZmczRkFYOHZtbEY2bFpXRnl3?=
 =?utf-8?B?d012c2ZkOGtibFNuU25STkxZSmx6MXRtLytxRmErZnhZQ2VobnVKU1BVS09y?=
 =?utf-8?B?b3cyTDlYOUdsbDFzN0pXQmRVamZzQ0FMcnA0WEZqcEZLQWdyOWVFdzdQZ0tU?=
 =?utf-8?B?emdQdGk5SXkvQmYrT01DSTBkdXB6RC9wcGs4bnl4VTB6L1FsK2NkMTZpcktr?=
 =?utf-8?B?eGl0V2lLTXJEVStSOWt5V2s3MlBNUW4xajRYMkVYWmF1MTFQUXNBNzR1SkZk?=
 =?utf-8?B?NXFjVWJlTjl0cVlXbUFRdDdpaDBlbDc0ajJnMTRiTkFKSVJCSktvNm9GU1Z3?=
 =?utf-8?B?Ky9XVlZlLzVJbnZhVjkwWG5UcmZNYkwxVmllSlAwRXk2ZEY2M0E1dlc5MmVx?=
 =?utf-8?B?NTEwbEozZmRyRUFER2dFZkxFbzFjWHFmSHB0UEc2bStaTEpHRHprV2VLNnZs?=
 =?utf-8?B?WXhTbzlkbkswVUVhM3NiaWxIdHJ6dlU1L2d0eS9IeE1md0hoVnUxNHRDSVJ6?=
 =?utf-8?B?bWV4blV6WVowOXl2UDdEZi9tNWt5SUVRSFRxa0pZVFlCZ1JGTVM4UFB3Qjg5?=
 =?utf-8?B?ZlVyWkZJVkxPSG1nY3FreDNROG9UazhpblEzK21QTmJ3VEN3aTdTYnErazZO?=
 =?utf-8?B?VWloZ2R2T2VsekViNUhBRHNpTDhLNlVwc05xSEppOVU0d3JKY0F5ZkhvTnlC?=
 =?utf-8?B?Ui8yTGFJWnl2emhHT1lTNXhwdHhkc1ZiK3lUMFRmQ0ZISmF3OFFhL3kxM3pp?=
 =?utf-8?B?TXhhZmgrTVAzL3ZYMk0xb3JHSE5pS0VhLytYUlhLeG1XZG5hNmdEUUNjTUti?=
 =?utf-8?B?cDlEZHFqTDZsZGgwL2E0Q1hwTTQzOEltcFhmY29VNERuN0ZkL2xUc0pOeG9s?=
 =?utf-8?B?ZFJLNGp2VDR2aGE1TVFiVmYyck05dUEraklFblFTOS9ha3RRTVFkK1ZQSDlG?=
 =?utf-8?B?blVKY2l2d1h4OTF0SGpUUWE5YzNKU2tmSFh6bXlUb2FxZWUvZ2xQaEZTblVS?=
 =?utf-8?B?UGpqS0Yrc3hPdS93MGVUeDZpaHkzS3lQUi9pVWI3ajZmVlJBZThaTVMrNWUr?=
 =?utf-8?B?VGxuaTJSU0d4VTYwYlZzalZnYnNJVm5EN2lMemZXV3l6UUo0bEFFV2dHYVBj?=
 =?utf-8?B?MnJodkNRTnhLWVZjSDRzclAzbWEybFVvYjFabE9hNWhodWVsVW1SL21iT0F0?=
 =?utf-8?B?SGQrcXNQam1SS2FtUnNGV0lodDM3Qk1qQTRQU2d4MkxObmJ6NURVWE50NDZC?=
 =?utf-8?B?aUZXekxqeHozVWZJMVByNnEvdVh3d0xaOXd6K2VyOE40VnNQSm1JZHpQVDd6?=
 =?utf-8?B?bkNsV2ZlNEZQM3NwbExzV2crcE11WmliVGM1ZlQ3Wk14VnJiL0dRTEI0Q0Va?=
 =?utf-8?B?alRhNzUvdzJEZTJYeTViWENmYStXbVN5VElWeVR5NjRTSm5iTi9aYm1EUkhX?=
 =?utf-8?B?ZEFpNWdwWU5pRkJiTkJkemNVNkhWSERzZzZ2a1JDQVRXcUZ6blQ2ellOTEsr?=
 =?utf-8?B?MGRDaVY1Tkd1dnRoVnBEWThuRWxVM3hDSnNMbGFyY2ZBczJwdHhJN3dXLzN0?=
 =?utf-8?B?QUREQkh1ak1KMWVDKy9TNXBuZkhIbk1JRG4zUUs3ZThxZm1wcHV2cEtueTgz?=
 =?utf-8?B?N0UxcmY0YmVac1RKRW9vM2wxNXJOeXl0dzRyaDd6OUlyRXZaa0dlWEFrQ0ht?=
 =?utf-8?B?dTQvNEJvQWxRTEg4QTJIYS9GdTV4Wk5xSlZMb0VMRkR6YnJ1dy96RDFvQldU?=
 =?utf-8?B?VjUxOHdtcUJ3M3BvWXh0eU52MGdEVmdPbmM0a29ibHA3WURscTc3QTdWSytK?=
 =?utf-8?B?VGlzVjI0VlNrdnQ5NE1UakxmMEtzQnQyS0FPRlhDRFR2OTBRbzVFV202NCtG?=
 =?utf-8?B?SlltV3B5a0l4b2NGU3d3bGVDaTRVNjZyMjVWMzdQa2NIM05rM2VzYXBzcFdS?=
 =?utf-8?B?YStPUzB4M2J6SXpwbzZMQ3JtSXBJdUdvTUFSZjE4RzIxZFpTSVNwRWlnRG1B?=
 =?utf-8?B?OXFEdnFYMnZMS1NNRnJQSGdoQytQamllUWFid3NFMUQ3eXRJNER0RmZNTTAx?=
 =?utf-8?B?aFB2WjRZWXFhY2FjRitjZXlsQktxRG84dDJPOC9kVHl4NjFyMGtMUXp6V3JC?=
 =?utf-8?B?Tkk4N256RVVuY2NXWDhvOUJMWmJXczFvYUFyM1Zsc0tkamlkN2lIV1VyMmlT?=
 =?utf-8?B?d2F5SjUxZnV0dkVjdmVDQ0hvOEczUEx2bUtZRFRTSGEvMVpObGREdEFqdmJM?=
 =?utf-8?B?QXJiQ2RsRlIySSs1YlZFMjlJKzhaSmZuZDhscUh1ZlhGZm4vVVlHWXJTaVor?=
 =?utf-8?Q?n/fv3AEl10YYi2y0bt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e184d17-b544-45c6-74d7-08dea2d68442
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2026 14:25:35.9729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f9rqJ8QjCW1NdgXi58XCui7AiR0fCO/0DW9KYCPypORcyDrF+n2au07bWamh2Mdw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8430
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE97140007
X-Stat-Signature: 5bw8oyeg53mo96epp9ghhje7rcezq845
X-Rspam-User: 
X-HE-Tag: 1777127141-534936
X-HE-Meta: U2FsdGVkX19MWM4MPPohc465zV14XFBpbxro+XE7O7LCexYsSOD4+8Q54KeKhZcsoXMa3biRazMi4unikzTgb9zG2UAbKiyyIGeGIYtnkK7cz7vDeo6/88lNfO7ly5RhVPsjttednM7Frfg3tVW0cC3M5NVdy3GheLxsmEXjXvYSqe6GEoOeoDEZsuhFCV6NLeIgCyLq2EIBBvI+QwVVtu5fcT4HgOEz2K5NcZIbWEA4spnwXAsYk5Q/fAt0g10gYbuvaX/uNiKoNnU3CuPoJmS/7Po8SN1esankCGGPkb+82aXxCy/EPTOWgC3Xac5NfKYJghlcKe0j5sueCv/VZMSZpK1YyBMo5PXjuvPE0YBPJeEG0pumOlhCpRI6Lh6yZJfAz3G1qz1fdQZnyE0yPSCRIpNatk0EsI8YhC4SuUxcfU80upTDCCV35LF85tlw+KawJajhQyJ2fVRRmHbI7Kkr8Akyf8MwsWK1ycgVB3om1mlxlpXuCP287pqQXngoe4qZA7EK7P3jDK7DVVF2LgPXd2W16FN/64tTy5o63Jf1p5sC8wyWo3dYCYPEUjPNH9gjqeynjTebyw1iLBJ0gUGyp+W+l3W04ZMX5VSWnh3TNRJowHSaMgC+WP8Lwke8SFOfg/2pLhYwdntGLO2AvFM1rg5rSV807PgcsscRdpNADhg436tqsFu7dweQ59Pbn9yZd74g/G/pD14RzNMeaXbtSMNCHptPR2FwfQ2Ts1NttBWGb4LY2163R/YxkvIE7AhZYH+7ZP1/kzTg0eVCimxns8C1vJKkQWm8Apwm6T67kvK3ipFnTiWtSXDx89C1QnnewMVeransxp4HkDp+VveZGABuyJBFyzVtLY2kUyXxtJZTfRPtcmdmGq6+YPCRed8y9q27+ZzaHUrj31tVuwRlI9JdlmAM1DHOrn+kZ6WaRv3Yv3J8RRxWImikO3ZEiWxbyZ3/4sVUbcNi+KS
 FvMlS6qM
 vNrlJiVCcHzjBLHCWcLcxweMvf7Hs3KeGLec2sS1dLBtfNDOOlmoHKT04TUqNmWoMjHQBEiC7T/q8H7321i/Pu+ntEaj6WbBQ5QwqgTIu7Gjjj6PGPBNMvZc9nZZuDetCwHhpD1um58kU77yyp9GicqrgDckeotOq3u3ozy7l3Os9YfAHDz7/YnkOKAZzC8huVG5OsoOwHT7GoUOTy4ubj2fjnbiD+pgiP3OmKOAn3cynEM43wMptngphnaZgoRblzD1pVINWs8t1PCQflhaVrRRVpHDdAt2ex3mlNkqTO2QesC/s5qFgLIkI0TUdsNqqJr80NWSDKj/6r5Xa09+A7ZajB4cHfyzJE/TO09d60HbxNbL+yaSDwRbh8RAgYYuvMkos7YyKfOozHkjCeKyaCAn07ENEhTgRuA2TuC88vT5yxMjSurA9tu/5rqzWtNtDBxjsMCaWAml03NOFmTYzYNbsZKyODCC/wbEXqsSVzQfCq2HNlwtAnFv1Ys5TGJFCyy5IVlsnxLLg0YdkF2tWA18krX9UFIdP7RsPO0n/sse6T4xWPwUq5V6FljOMRU3YCm19CKsCDCyaOcyADIEYgNw7wENsZSCvy4woWofpft1OMvX91H06qPyD0YP1MuTYMsAerbN6QvLwoZwcRAv/0CAdwfrvsr4u+VeYxBhtZcwmrin+Iu1dEqUwZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Apr 2026, at 23:49, Barry Song (Xiaomi) wrote:

> The comment appears to be outdated. First, add_to_swap() no longer
> exists after Kairui=E2=80=99s commit b487a2da3575 ("mm, swap: simplify fo=
lio
> swap allocation"). Second, partially zapped folios are now always
> split before folio_alloc_swap() to avoid extra I/O, following Ryan=E2=80=
=99s
> commit 5ed890ce5147 ("mm: vmscan: avoid split during
> shrink_folio_list()").
> Fix this by making the description more generic.
>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Kemeng Shi <shikemeng@huaweicloud.com>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Youngjun Park <youngjun.park@lge.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/huge_memory.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..4586f3ccb133 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4190,11 +4190,10 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>
>  		folio_unlock(new_folio);
>  		/*
> -		 * Subpages may be freed if there wasn't any mapping
> -		 * like if add_to_swap() is running on a lru page that
> -		 * had its mapping zapped. And freeing these pages
> -		 * requires taking the lru_lock so we do the put_page
> -		 * of the tail pages after the split is complete.
> +		 * Subpages whose mapping has been zapped may be freed
> +		 * earlier, but freeing them requires taking the
> +		 * lru_lock, so we defer put_page() on tail pages until
> +		 * after the split completes.
>  		 */
>  		free_folio_and_swap_cache(new_folio);
>  	}
> --=20
> 2.39.3 (Apple Git-146)

Acked-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

