Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AA28CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15676B00A5; Wed, 24 Jun 2026 11:53:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA02C6B00A6; Wed, 24 Jun 2026 11:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40836B00A9; Wed, 24 Jun 2026 11:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 802AF6B00A5
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:53:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B89A1C5935
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:53:03 +0000 (UTC)
X-FDA: 84915249846.15.EE37831
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012029.outbound.protection.outlook.com [40.107.209.29])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1A3CC8000B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:52:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JFlypixE;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782316380;
	b=k+zoXohPY4ZWRXEzZ2xJaliNlxXGei9N4fiVGklSwvSe+aVl8tk+tYr8NJaTY3fgpSJqp+
	5X9dGsQa1iXtqCo27fT3yeHue7HA9Go23v/s596p77mMlhtY18C5iD0hgrMnH0GUOd2hwN
	Ng6/uYP9UanKr9l5AeREIOLLrRYtD/E=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782316380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLnj/iQ36SUOIC/+pC59sFJeBjtxCbDGOgx2OtZGXjQ=;
	b=u6Z9c5FrBxSfX2MLUC0xlbZ38HFFfwemLl8ixMLDABg25OruDC9rPdOR1w74Hrj+zpADC9
	D3nrPzYnFqafc2fRYCjS56kR3nwHv0fP6mNhHX9iZcD4Fd8C7bMFOc15QjQZP9SDX2wsy/
	yKkwAIuKlKIcNKvOA9SFAGJi0KBFYXI=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JFlypixE;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eteb05URVwTbobEwErufR71+p/pHkrqFX3dmX1kJfrFMZorDHQPmOwjkpAC8zIRo2ldFXgCL8YyginnDZUmhGa9Uyn8y8f5z5lYCmDLNCjTv1Vkyeu5/VrzhW7uuCDqIyMZjO5cH0ENAf7/eob1h8NSTmDh1z3RxPU8zWCRHC3FJugjNCDRgmueKe/oxcOFRuJTjxDEJSLJpPp0UGUyfR1zwIl2BFiTSesEk2id3OvJQ0QATstOcVqPIH/Y5AqFWo3LLNkNKZ8omOBVp+p/GuMt8qPibXS62bQaY3ucZTKbwDAWWFw3ql4TcsKPrLLSvOZhZw1Y8uJ5Izxo0ZPWOLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLnj/iQ36SUOIC/+pC59sFJeBjtxCbDGOgx2OtZGXjQ=;
 b=jEqjZhwS497A6ikSBTnLX7am2HP3P6KVnUcadugIa1RMcAHyQELtKIr+syQzpb3yBfdc4EKXiSva0oq9HIs1Is+aXog0Yy772wbPRO7eFaQcA3Ckx2NuF9WK5yzVyvQl/rQ6H4YMDykZgxFbXmnWsz5TYQaCJXN/LqTguOQEUrLkpPCG1R+6B+SuiZO++jeIUMixQJX1y4nqDU3eTHRNGXY/3q7PS18uaSfib0hrLvNshYOqsmxpEMkXuzmk9Qlj6cjCVTu/lTBb5KllfbVj0P4G9QSZzl3Mdhfc2n7LnEXsnH1GvV9b2U2Y6iCNmc7KyCzJ3laRto8dDd3et3MJLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLnj/iQ36SUOIC/+pC59sFJeBjtxCbDGOgx2OtZGXjQ=;
 b=JFlypixENni2OB0bywf4s2M7eh9X02tNfszT8OcMQTLlXtI7F2wM+aA5l4yvXdODSUt5tcYGvXeqUqjL3QmrWT/k6hQ6uDtqDh6mIoqzYZh3toHgCnZ58CSJHDGDN0CYDTP3xk5m99pEbULhPA7kdLpK78yq4csqse6mySYVys6BeVxnkJXd6PUQvzd4HBa5NI/+xnfYxv+2WyG/qKnmyGP6n3rFV76a/YjmqLAG854hcr2aqVl9Gxupfp22XVqIXuLcovW5mnKnd0n35nV+JdOOKRDxKJDjJSjo9rOXJi8VCs7l2gwyGiFB7RWzm6gFzTTq+aU/sDtVNCCj4Ynpzw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB8057.namprd12.prod.outlook.com (2603:10b6:806:34a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Wed, 24 Jun
 2026 15:52:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.014; Wed, 24 Jun 2026
 15:52:51 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 24 Jun 2026 11:52:49 -0400
Message-Id: <DJHEF8MWTZSC.3KMTACZH7KWP@nvidia.com>
Subject: Re: mm: opaque hardware page-table entry handles
Cc: <linux-mm@kvack.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>
To: "Usama Anjum" <usama.anjum@arm.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Samuel
 Holland" <samuel.holland@sifive.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
In-Reply-To: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
X-ClientProxiedBy: DM6PR06CA0078.namprd06.prod.outlook.com
 (2603:10b6:5:336::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB8057:EE_
X-MS-Office365-Filtering-Correlation-Id: d91445b6-7599-4bd2-2ea7-08ded208a5b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|921020|6133799003|18002099003|22082099003|56012099006|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	N6ZP3/4m0+w/eI11PpfZ10kB6zcQFhH6VgzX94kjwHEN0+RI6r/ud4GqU7LRtCGtI5FYfPDFXfnM7HR/Ae7IVKPlfMkcsz+wTWNCM4HjJ/suyLTyM91bX4ymj3Guo3gF++Eq64Fe5sGhoIYOtGrrZABYwWdZGRf2lnRSACHj6dK+ZChTsgZsJIVg0mvHmwwkbVVdzMroqrc5nk//fxM/5COOcr5PUUXD89WByggh6hDk0hyycW5cSqNvBYFPjxRBr/+8CA7VtuiBsMy7nB0IOrN1evc/Q57q7OAiRrrwOd/SYTnmrAsssrGmC2SYkIvxqHfO0p1xCDSLKZDXdW7CbHayvU46NGJSuY5AAQXwnLN0+V6VbD8C0JVW7bHbqS2+kVxzn9zTm7B0TZ7jWHi46zJmxyCLjZGPPY47FEHlbFaB/yhsd791YlWC+52aQRRgAOW5AhZcZQyi+WwJDkpJ+aR+smT68TmppiekMrgvB14nZ9+LL6tjw8X8He+VcPFGQKNmjYBpybLtTP3Sdw+n+oZ4PnF4xWImO0XOkyID8+TQgnfNeDVvkPIJBqKiz+xG+ZjUw/Heh3JJWHBRDcOzYm7tR6R1nvyqlMMMo6MwHPV+xKhhCqAoWS6eEzydtxtMLYwwcCQ7vHZqtNEDK226XaRmUtpjLng1PCPw+U1aPK9NC48OYNNiZU7uyUW0YYULtGR5RsEW3qR2U4vMZayfPA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(921020)(6133799003)(18002099003)(22082099003)(56012099006)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K2FMMnBWcXdPdVYvUytRak0wSnFRc0lCVTZPQW9PTkZQVnAvSGZ4UWVpd1NY?=
 =?utf-8?B?ZldPTk9FeEUyblo1WGw5OE81eUNJVVZseWpOYkhoZ3Y2RjU5Q1h3aVBPRHFT?=
 =?utf-8?B?MXBKMlFoU3hiYkVrVjcvaG1Fb0JubzVBOHM4UHQ3Vk43Qlg5OVFjV2piUjhR?=
 =?utf-8?B?eVE5LzFTQm11VENCWTdlQzg2KzlxeXRqaWN2b24rdDRuYUZqQXZoakMwZEhX?=
 =?utf-8?B?SVVVZWFYRXg3YlJnZmNVVS80S01KSkdmL2UwTUdINnN3ckMzbVA0aWdPQVd1?=
 =?utf-8?B?cEdrbjBkemR2aDh0K1lwVUNqWDhGZlpBZWJCaGFvR0dyMlh6cEZPVVFOcklU?=
 =?utf-8?B?ampVdHZSaTFPMnl1T0N3TjNjN3ZaYjM5NExlLzcvaUxPN3ZQaWhsQXBhcW1P?=
 =?utf-8?B?YXFSWmxBOEFmR3NaT0VnOEJ0R3FGSWl4b3NhUjBBYVh4ejhEb3ViVXJweEtQ?=
 =?utf-8?B?N1plUnppeGZSNW5qTVdJWjhoaUNlL0hLZVd6YXBQY01QMWdQSGo3ajdFeTJh?=
 =?utf-8?B?Q3VJZlI2b2Z5bmZpQnRkaWFUZnArTUx0SkF1RGs1VWFzbE94aWllS1prQ3F2?=
 =?utf-8?B?OVcvZ3E1eWpBaHNDMk9SNUJDTE83b2RDSUVDV1dwTm5TT29pTXZDZWVhNkpO?=
 =?utf-8?B?bmVyczdsYk41R2FYWmIvNUpHYUhYTXo3NkNQNzBOc1Q4VG1IUStQY1k5M1NE?=
 =?utf-8?B?K3JQYXpLQXllZjhVYzhQTTFncFJYajdQSEx1Wi9ET3RSVGhNbUx1Mld3K0pC?=
 =?utf-8?B?UkVuRkVVdXZmUUJQRnQ1MjdGZ0dQYkJaSFNPMjduYmlyR1g5c00xVk1mSSt4?=
 =?utf-8?B?ZzNxSTVpQ0x3d2Jpd0tVZzMzYTE4dXlFYisxT2FCQzRRSXRXYjN3d3dheTBP?=
 =?utf-8?B?RWljK2ZxVVRNZ09vUWlVZFNkakljUUsyV2p3bjF1eWRPbFRlTDFWTVd2UWNx?=
 =?utf-8?B?R1kyRitUVGd5dkN0Q29tamJldzg1WjVKZVVyN0xLQTBBZmx5K1RsTXdBbXJl?=
 =?utf-8?B?MmtIbFNrSmRycnpqdnVjYUhPZTRzUFpRLzVyM2ppbk9LelJOY3hCcDZ2Vith?=
 =?utf-8?B?ZTRtK1pKSFhjN3lmOTVzSlRRZHZUY055cUovUkFvZGU2TW4yTUJSRUdqMmhn?=
 =?utf-8?B?ZmtEaEMyQkJJU0lTNmVuKzg0Z0E0dFJnKzY2MTNMZE4xbmtZVkFvQzM0cm5r?=
 =?utf-8?B?ekhBQjBuZ04yYTY1UmluQ3dyWlpXbVpldzFLSkpONDRveFRyaU1wOGF6Wk1I?=
 =?utf-8?B?RkhxZlhDUHMrbTRYK05CbFdTUURvSDZLamIyOU5mRXZ2TVlUWmU5ZFJuejZZ?=
 =?utf-8?B?djFzaU5BYU1OMStZWW5hZ1VxTHdrdjBJdHNNTnpCT0ZSd21QUXlKMGp3T1Fv?=
 =?utf-8?B?cmtKeHE0NkhZb05IMnM3ZlVtKytZRCtPK3lqaER6amw4OUNyalRuQkVQMXVo?=
 =?utf-8?B?YS9lZGFrOVBjdm15WlJuMXFQV0d6VnhhNUo0Nlk1YjdXMVlyRjJWeWQ0ajg0?=
 =?utf-8?B?VmtqMzdVL3Fyd0dlcWFUNWIralo5RU0zM09pTjAyek1Pay9iRjZmQzk4N1Zp?=
 =?utf-8?B?WGRmUWxjU2U3aGNRc2E5amtNekhIU1JudFZlSktZamkvQzZIdzE0YlBhL1c2?=
 =?utf-8?B?T09CMmI5azBFZmdpQXEwZEJwaktWKzN5YmF0OWJNdkhyWlBMUU9xRDVzdWFh?=
 =?utf-8?B?VTBma25DNFFZaWpkRFE0UE5DdENKbnpPaXhWN095Nm5qQUtwcXlkTjRZL0Z4?=
 =?utf-8?B?dDlIQkpKN0Qrb0UvK2xXN0x5OU16NGhRcjQxS0RqajEvNG90NGF5eWVFZGUv?=
 =?utf-8?B?dThsRDNFb05KUFlaOHdGV2IyRTZ6azlrWlFjU2FTcWEwalFsOThTUnRMUjF0?=
 =?utf-8?B?RG5wNlk3NDNwOThHVFVkNnBtZHlSTnFNNWxsZlFBVVJueU9BQ0V4NVhnRHJL?=
 =?utf-8?B?VWp6Z2M0YlJWc2lnZVhROVE5aE1JSXhrT29waE9TeHh0VVJMdElnUnZFQjlZ?=
 =?utf-8?B?NVdCRnZIZTJMdjBMZ3M3T1JHdHl3ZGpHck5rbGt6dUpXSkt2SXpmLzZSUkww?=
 =?utf-8?B?Q3NreVR4SzNoSkQ2VHZDNDJBczRoY0hCdTQwZVBCYjFHN1BlK0drVXVIUGht?=
 =?utf-8?B?aTZlQjN1Q1VoT3kwWXVTQmtjZ25maWxxb2NtRnZmSG9aWisrWFdiVWlnVW1K?=
 =?utf-8?B?NWVsejJ5eFlHOGxRZzJUV3lrVktuR2xhckFjZnhIVldHZmN5N3FCU3RMa3lE?=
 =?utf-8?B?bGhrN08vZlJFa3NOUlo2cXZKN3Y0SmU4UnZCRGlOdTVhSHdGYU5DWFdoYVQv?=
 =?utf-8?Q?1vACazOqjWTJ9AEcRQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d91445b6-7599-4bd2-2ea7-08ded208a5b7
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2026 15:52:51.6947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xn57h3QxALmvZlhgbcUul3NqbBfXE3WpZNKV0RKb1d9T4uUjh0F7KgJE9ApObpT/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8057
X-Stat-Signature: m91tee6feba7obxohtx54w8h6j51ycif
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1A3CC8000B
X-HE-Tag: 1782316379-920501
X-HE-Meta: U2FsdGVkX18v2u9gaen7SyjII0A2xNB431hoBjQgGZncrt1emHJcmHhWYZdkfVGMPZ2jMpl36OK3Fjhht/ixFAnfpTpsAN+dKZSSMXuR2FMoH51RLsGx5AnCFYURPWbE4HUWQysCNw6V2mL6EyyTMykyloubPaA1RtKGq5G1cnCOsoNuqtr8YONZppWz9uTStqeF+sgpv/bs/PPTFfO+50bUlu3IJS9j6hdalUsCNha86PzMh+PBBxouFJVHHQ4B7y3hBnpLDjFrdUhTmQgnSP9QzTgilDjxZFx4RdJnX0XRM78JOxK2LDkj0uZN6hPlQ5fdaMzsOYMLXsg4uMFw5xyW2gZV9U628ZWUgnACTwPfhPSr5yD6nfFklrjf9tp2pQoXybZA1fifMsnDzIEdhncFjqug/1WU3VcM66PZuK4CsTRhkZBgKIL93aHaV/mIJ0Mh/EooqXZPuASYmWmadxgcAdmiWKvLpeeSmew047ztkPguey80M/b2cxL+O4Gv4Sv76DSC+I5De8vTcsYHn9ojTj7qrmq0fGvQcdVKa47xSB9DduH4Z5j7iX1oo6znpMqa+/DGCh3V46urBW7p8QsGEBb0d5fEM66BHzkRDnM5CQfDvvYNw4kqj7XaWnDxLrUsRPpBVi61x4NSOrWqVmi1aWJIUKnPTTYLJIWZI7xQ7IZsP1aUy7hNnXrbYDDrUXWaA0PFz+eSvquEjR1hUuZDTXqL08ogVDQRBYhW5BM3le2HzOvfnl94/T7KKsCCWyY1ry4Dq9Ekmt1PArDjFhtO3lO9/JsBSmtI0A/0GqYfXX1mVEKNfNRUxuwTJ+NeU9vx8gurS+/jj/RLbXF0+MNuMXTUzX9vHTR8/q6uK14NdZ0AyaO3xG901aBznZGdUhhyZIkML9U65JgGlOr1d2buU5VQ3AaidxPR3VOI5gPB8i8yTp8GxO7RdVXpWtlgukoqu1o1/EYIt7wHp01
 wOcj07R7
 ceE0ECCbG7u7vogJipffGUOPeqs2PD2pZdKHWjS/hXbApjZwkJWJX5c6py0vSMfkr2xU3dNrq2rxYxXG9x3qmf+LtnL0huhkBJ/EG+H1WJcKSN6ZCVlRzsZ5VkUG1MBad5IMtJlQINWxc10CnWJQO4tzS/b3eQ+L5HNrzPuSNO3tzQAag/yDagGO+unxMDnHvvDmPAS65RUA2DVavK/92r6QudYXFSNUKeZzBdrSYb7Ih8KbiZpqS+ei1E9hQKX1LR79mZJz04Su4vAk6C+C9w4I7SkW1LCOzyFuh73vP5B+jhrnDMrXGAPNEopZ8syIxgJ4el3EiQLxOE2f/0LhCSYHOtfB6Zzgg8w8CrE3Pd1Gffi0ImEZsOIITrmJscN4U0+2h5FE8NoQhwD5kEUoMcb99J4oQBIQvcM+uozgJ2bHjy57lWIAds1UbhuchtiuNQOLIhKESLubLgOM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jun 24, 2026 at 10:09 AM EDT, Usama Anjum wrote:
> Hi all,
>
> This is a direction-check with the wider community before spending time o=
n the
> development. This picks up the idea that was raised and broadly agreed in=
 the
> earlier thread (Ryan Roberts, Lorenzo Stoakes, David Hildenbrand) [1].
>
> The problem
> -----------
> Core MM code reaches page-table entries by raw pointer dereference (pte_t=
 *,
> pmd_t *, *pud, ...) in places, implicitly assuming a single, uniform
> representation. Sprinkling getters wouldn't solve the problem entirely. T=
he
> problem is one level up: the *pointer type* itself is overloaded. At each=
 level
> there are really three distinct things:
>
>   1. a page-table entry value (pte_t, pmd_t, ...)
>   2. a pointer to an entry value, e.g. a pXX_t on the stack
>   3. a pointer to a live entry in the hardware page table

This sounds good to me, but can you clarify the situation below?

A live entry means the entry can be accessed by hardware when the code
is manipulating it? What type should we use if we are pre-populating
PTEs in a PMD page before we establish the PMD page as a HW page table?
In __split_huge_pmd_locked(), we do that. A PMD page is first withdrawn
and filled with after-split PTEs, pmd_populate() and pte_offset_map()
are used for this not-yet-HW page table. Later, pmd_populate() is used
to make this page table visible to HW. Should we have two versions of
pmd_populate() and pte_offset_map()? Since the first pmd_populate()
would accept pmd_t*, but the second one would accept hw_pmdp, if we are
pedantic. Of course, we can be flexible here to use pmd_populate()
accpeting hw_pmdp for both, since the PMD page table we are modifying
is going to be visible to HW soon. But I think we should have clear
definitions for where these types are used and document them well.

You probably can ask LLMs to check these ambiguous/vague uses throughout
the code base.

>
> Today (2) and (3) share the same type - pte_t *, pmd_t *, and so on. Noth=
ing
> distinguishes a pointer into a live table from a pointer to a stack copy.
>
> A pointer to an on-stack entry value and a pointer to a live hardware ent=
ry have
> the same type, so the compiler cannot distinguish them. Passing the stack
> pointer to an arch helper that expects a hardware-entry pointer compiles =
fine,
> but is wrong - a bug class the type system makes invisible. It also block=
s
> evolution: an arch helper may need to read beyond the addressed entry (e.=
g.
> adjacent or contiguous entries), which only makes sense for a real page-t=
able
> pointer, not a stack copy.
>
> The idea
> --------
> Give (3) its own opaque type that cannot be dereferenced:
>
>     /* opaque handle to a HW page-table entry; not dereferenceable */
>     typedef struct {
> 	pte_t *ptr;
>     } hw_ptep;
>
> With this:
>
>   - a stack value can no longer masquerade as a hardware table entry,
>   - a hardware handle can no longer be raw-dereferenced,
>   - cases that genuinely operate on a value can be refactored to pass the=
 value
>     and let the caller, which knows whether it holds a handle or a stack =
copy,
>     read it once.
>
> The overload becomes a compile-time type error instead of a silent runtim=
e bug,
> and converting the tree forces every such site to be made explicit. This =
gives
> us a framework where the architecture can completely virtualize the pgtab=
le if
> it likes; and the compiler can enforce that higher level code can't accid=
entally
> work around it.
>
> It is opt-in by architectures and incremental. The generic definition is
> just an alias, so arches that do not care build unchanged:
>
>     typedef pte_t *hw_ptep;
>
> An arch flips to the strong struct type when it is ready, and only then d=
oes
> it get the stronger checking. This lets the conversion land gradually.
>
> Beyond fixing the latent bug class, this abstraction is an enabler for up=
coming
> features that need tighter control over how page tables are accessed and
> manipulated.
>
> Getter flavours
> ---------------
> While converting, it is useful to have two accessor flavours at each leve=
l:
>
>   - pXXp_get(hw_ptep)        plain C dereference (compiler may optimize)
>   - pXXp_get_once(hw_ptep)   single-copy-atomic, not torn, elided or
>                              duplicated by the compiler
>
> Keeping them distinct simplifies the conversion and avoids re-introducing=
 the
> class of lockless-read bugs seen on 32-bit.
>
> Example conversion
> ------------------
> Most of the conversion is mechanical.
>
>   -static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
>   -		pte_t *ptep, pte_t pte, unsigned int nr)
>   +static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
>   +		hw_ptep ptep, pte_t pte, unsigned int nr)
>    {
>    	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
>    	for (;;) {
>    		set_pte(ptep, pte);
>    		if (--nr =3D=3D 0)
>    			break;
>   -		ptep++;
>   +		ptep =3D hw_pte_next(ptep);
>    		pte =3D pte_next_pfn(pte);
>    	}
>    }
>
> The bulk of work is this kind of rote substitution. The genuine work is t=
he
> handful of sites that turn out to be operating on a stack copy rather tha=
n a
> live entry - those are exactly the ones the new type forces us to surface=
 and=20
> fix.
>
> Estimated churn:
> ----------------
> Half way through the prototyping converting only PTE and PMD levels:
>   77 files changed, +1801 / -1425
>   ~57 files reference the new types
>
> So the line count will grow once PUD/P4D/PGD and the remaining call sites=
 are
> converted; expect meaningfully more churn than the numbers above.
>
> Introduce the type as an alias, convert one helper family per patch, and =
flip
> an arch to the strong type last - with non-opted arches building unchange=
d at
> every step.
>
> Open questions
> --------------
>   - Is the type-safety + future-feature enablement worth the churn?
>   - Naming: hw_ptep/hw_pmdp vs something else?
>   - Should all five levels be converted before merging anything, or is a =
staged
>     PTE-and-PMD then landing others acceptable?
>   - Do we want the two getter flavours (pXXp_get / pXXp_get_once) at ever=
y
>     level?
>
> [1] https://lore.kernel.org/all/a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.=
com
>
> Thanks,
> Usama




--=20
Best Regards,
Yan, Zi


