Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D8DCCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 07:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB178E001B; Wed,  1 Oct 2025 03:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882B68E0002; Wed,  1 Oct 2025 03:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724188E001B; Wed,  1 Oct 2025 03:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9F38E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 03:01:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20E8816093E
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:01:58 +0000 (UTC)
X-FDA: 83948650716.23.C099BDD
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013036.outbound.protection.outlook.com [40.93.196.36])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5279E140009
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 07:01:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aEyfW4k9;
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.36 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759302115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qb1ex7zKroLOvP7sqJVrMKehBtT2BJH4qw0sEkMzNqM=;
	b=emVtyhZ/6hmZ7od5WfrXOkTkJhjLWwuXpisAUTRiMjk6eyJsE92GVnvaqYbOPcL4Bww4lw
	whwE3fFZRNIFhHkpqQnNgv4OY3h1eA7aKywrowScK8Z7n120g4hejI3q4jQbJ6lRt/ylKi
	JuG/y7PzBo5bwn0paoQ00ceCkEC6c7c=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aEyfW4k9;
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.36 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759302115; a=rsa-sha256;
	cv=pass;
	b=AOqkTODxm/Qah9iX4hlw6k6tmQKuRsFUY94EpRFKSABnG61poFZpFGI5bSwcks8rXYNOhj
	kE4ZG8+V98+3nAJRUZWPT2oFO16OMWQWBM4s/dYQ28CpiGfUQKSMsxr5ujJEfKotC4jOSO
	2jOzr04ABWAV9LPLjNrnGhyJJBTB1Ag=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lmzH4GnnYdjsTjde0FoNEV6Uf7zvHeA5M3SYp5Rw+kcIQWOyp0qetvyey9dMEttwlsxkmBWeaQ2TMOe68syr4V24mZEpXxOAvTj8HCkBcCcVtg/+BtMgC9GCNpk2YHPO+wdi5l+DhP/e0nWH7XBzSo98AHOSgbG6S7hMUFGaxAsWlQP380ju39Ku6AkdjeFepq1nTZd8dSZMmxE48W9QsrSeVAXWBjIINKpQ5jjV1Qntlk34M17BxTHMPPIMunKcXYY9X3tWCIQDrS3gMz3LXCUD1Oou0oYsgUDwsaHOKQ50K7tIUAqUCTEIrx5n6LfSVR+NOvuPzqBgaiRn7nEeUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qb1ex7zKroLOvP7sqJVrMKehBtT2BJH4qw0sEkMzNqM=;
 b=FL6WVQwENdep5Wb4Ox5ECebx07ElX+dx109f05g8QoX7UpDYZ4U7yZnXcEbgdL/LDPCwuCWDMRs1vfVGjjpXgMjOq6S1Amnwb5yA/1UGOzXBH2SW0PsCs0XVwGT3U6wCIPMXtBib052Psv2DHklsOMzTKUtNvug0G4ch7k9QdqvZNXsxgaA61baAxnaxBPr2aGI2D++CgY5obNH7lZJQzflZEROBFEPEycI5rLfII7NAu9DO9CdGdaix0HaN2A9IaSA6SKp2Nh1/8MIvQJXl0QyHn9koj7co0ytjlfznMpFc07mKZd5Xh/aokRCKpgiBmQ7aPoA4QAPyPEM7D9jahw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qb1ex7zKroLOvP7sqJVrMKehBtT2BJH4qw0sEkMzNqM=;
 b=aEyfW4k99nctKh/yUHWtyY4rKGQ2Wr8yG+xz4kxz/s1uBwpWKPlmKuXZsozh6VHvHWLixlJKWsIcY2Mv47qCVinRI7plSQEqWhci1KzBRMlwUEGr3RDr+Dq5FVDPCWgeHoe7FXCm/7/ez2hFSo8NkikOUSKcs1NSethT2Nytzv9rftA65/QUpjfUgS5+eLZwRthIY2dt1OpPvS98qODXhsvTzbq5+ZCkVtNtmGu7jD4ojJ15MFnN2bLkal0Db5Gn6ArSxaLFjBNCqwRZn9pr0PyO8LArEc69dg5nFQepfO4IjFp+Jx8jRgzBGK5RQO+BJgnboXav3CTnngbqPgrTUQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY5PR12MB6299.namprd12.prod.outlook.com (2603:10b6:930:20::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 06:58:53 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9160.015; Wed, 1 Oct 2025
 06:58:53 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	Balbir Singh <balbirs@nvidia.com>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [v7 13/16] selftests/mm/hmm-tests: new tests for zone device THP migration
Date: Wed,  1 Oct 2025 16:57:04 +1000
Message-ID: <20251001065707.920170-14-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001065707.920170-1-balbirs@nvidia.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9P221CA0026.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::31) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY5PR12MB6299:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e19de5c-d741-42ef-3cba-08de00b7fb40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SklQSExXM3JESXd3UUZrcTJ6Y041SVdQS2Q4Lzc3REUzVFh3UXBZSERKUDRQ?=
 =?utf-8?B?Z1Zra1RlNjhraDFleC9icW1XNlozcDZkWkNOd2kwZ0M3blZ6ZURwd0l3dTFy?=
 =?utf-8?B?dTloNVV4UHhqdm1WZjJETDNGRWN2UHJWLzdvVmVhVlNPald4WVQrUk1GWDUv?=
 =?utf-8?B?WGpOeEVNUXdXdnR6b01MWnhFa2ZxTTBpRjlMamxlVytFNXJKeVhqWDFPQmV0?=
 =?utf-8?B?aE03YkRvTG5ma3NtQk90Y2p4QXZ3YXFCNzdJVWRNTXo0L2RGbXFITVpUTUpz?=
 =?utf-8?B?TDFvL3JLMDB4enduSWVpTWhmd3dkRzM1blNiZTQrdDNsTkl4eFJUTk8yM0Vl?=
 =?utf-8?B?Zk9OY3lIS2ZsRzVVbVpXZW9VWjVSTnJCL3psYys1Z0tiRDNNZ2pvNEhLaXpZ?=
 =?utf-8?B?MTRybDE5VVlQRkt1WnhZOGlta2I4QjdKVU52UmhtWlNUa0loL3d4WGlGVFIw?=
 =?utf-8?B?RHFaamdOYTV5QmtiK3NmYUwxSHdhNGFJd05NeHI1M3Ayamh1dCthR21PU251?=
 =?utf-8?B?QnBZUEV0WTA4RVJoakNCRU5BNDNYSmQ2U1p3bkVlNngzT3pUMm5PWWdNdzR1?=
 =?utf-8?B?MEhFUEZ5MXF4cHplcGVBR2Q0V2t4Rlh4aVU2enVZckRmdEFqZXREdXV4enBw?=
 =?utf-8?B?U3cwN0NqK0xoWVpJT1J5SmlxS0wxSlFzV3hRSWdmUWhtV0NxWTFzcHZ6b210?=
 =?utf-8?B?SzFNTVE3SlVrNzc1R1R4YXJobU5wMzNnOTUxakVWQmVFNTNKTUorWU40Ykpo?=
 =?utf-8?B?SW1yNFI4b04yNXhEVGFQbUhQcWxPcmJlU0VPbFk3TzNySk5vckhHTU91V3l4?=
 =?utf-8?B?KytrbGRyc1d1WVdEZUJsVGw5RGE2K1RyQ1gyd0VmcURPV2lmNUtHcW9sUE94?=
 =?utf-8?B?RlV1SHcwU0NsNjMycmVSUDEvWjJvRlFkWGJJYzdQeU1FT3lkaXV6bDE1ZGdN?=
 =?utf-8?B?L05CaHhFMXlpSGVNbnBueUx3V1dHUzYrQ1crbmQyR0liTjE0VnN4eTFLZjYv?=
 =?utf-8?B?MHB0Y1hzM3RsZ3NsbnVTdEIrS0l3dk9LZVlpUUpjRFJ3aXo0clJPUVVIYmhS?=
 =?utf-8?B?eGlpUFcyaHBTVzlJb01HSWFwSDBkTUFVamlwdWF1QTFsQUFaU1F3VVRaUUFF?=
 =?utf-8?B?Uk1jSHB3Z1Nvd3N3SDlwblB6KzNGOXpXT0JyeXRNWjQ0TElzTDJHQW5YbXN1?=
 =?utf-8?B?Vm5qTzVpUGJZNWJxb2NCTkF4YUM4ajBLVDFGV0xTdVREZkpCblJUdGhUVWRh?=
 =?utf-8?B?NXNCVXhxVHBRckZxVnZob2ljVk5QYTZpY0tkanJXTENqSDNkdlJUVkFZK21n?=
 =?utf-8?B?UHR3QkRic2NPaUl6cTBVZmdtWHJtUXBUSjJmVGljWjZtL3lCekdnK1ZzYVF2?=
 =?utf-8?B?K0VQWTM1MGNnYkNpeitlSTl2U2dXcUp2T0kxQzVPRHhXQUNTRFhSTC8vei9D?=
 =?utf-8?B?ZWpicEk1dCtBeTNRWXhydGFZY09WaVpwV2lJWkxrbzNlMFUwSzFwK0xrUUtm?=
 =?utf-8?B?dlA1anVUZjdGVUhNMDdHOU9rbjh5cjJSRFAzQzF3Si9YcG9KRVRTUjlpcUVl?=
 =?utf-8?B?U09SYnk1QWJUdnU1NUpXOWxMYkgzYllyLytsYVFteCtSSnRYNkdRMkhhTUs4?=
 =?utf-8?B?aVBrOWNFQ3RJRXFiSlBRcHh1dDRKeDdWRmlyOEJ2d3FhRis1elhoTlVQOUxE?=
 =?utf-8?B?b1d2S0VxblVNd3lGQzlsa25wSE1tVzBSM2toaENITjhHZFBmMmxENnFoTkRO?=
 =?utf-8?B?eEYvUHRSdDBtNVV3ODcwV3VmNWlVUHl5ZU91WHJXd2t4dkF2eHB1NzV1ci9Z?=
 =?utf-8?B?M1g3ay9jd1hJWmlLZzc3ZFllTHd1cmRWZjJxZk9XN1FQOUtkVWJDck16SzBJ?=
 =?utf-8?B?WmFNMGlhanErTFV5Ui9qak1HMzl6Y1p4T0g2SmJUSWdpbEt1cGlKaUJ2VUs1?=
 =?utf-8?Q?/fStr7JKHmwM1H/mw/eYEk4746FMkip1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bENkMGJ4NWpXUjI2bk5rRnk2dUxyQ1pQRlMycG8zcmQrQXJ4d1krclJmbGEv?=
 =?utf-8?B?UTFyaTQvWGJMbjdkS1BGSmtKMlFMVGZsbWsveCt0MFFPTllIWHNZMnBoQytR?=
 =?utf-8?B?RjAvYm4xU0IzdEcwVjVmd1ljTlBUeEhrTW9NWjFob1BmaGFIek1jT0VLU2VR?=
 =?utf-8?B?UXZMSVp6czR0Q25XRXU1Tit4UXd6Z1BnajdnWU9ZVUhPdTBXUFYxZnQzVnMz?=
 =?utf-8?B?MG5QaVQ1SCtQYTR1RkFIOFJiekdIS0FNYVpBY0FCclhxaGRMbmZheGlacS9M?=
 =?utf-8?B?cUFpWDhINDhsekNSOGtCbjFsbjQ0eFluV09iY1psU3A2V0FycjVzcW1OdEdN?=
 =?utf-8?B?OG1YRE9IR0pJSGpwTFRKbm9VRjFsMlZ4WUZrU2V3OEhvV1NVS1F4T21ISkFE?=
 =?utf-8?B?VUNxb21RVU5ibEN0N2dSVW14ZXdtQTJZYmlZZHB6Nlk4ZzBBUnVjSkpubXNy?=
 =?utf-8?B?VUNORFp0N3UzK2IrVVhJSW56eHZ5NXJFc0plKzNvckNHT0JyQ3BTTGJvVU1F?=
 =?utf-8?B?aWxHRitJdnNpUHpIWHZXblRQRXJVWXJRekwvQTd1bnBHNTk1Z01tRE1NTFFO?=
 =?utf-8?B?YmErRm1URWRLVFZOdCtRVTIxeHdFakF4cm1ITkZVK3NnYlhWR2tKK0l4SHV5?=
 =?utf-8?B?K3VLQUE1THNhdkxyWitTdEl3ZmErVldzL0J6Z29lUkZVd21zL21UaDREUG1X?=
 =?utf-8?B?RnhuOUYzOFZqOVhycDdPd1pwdnlQeUdzdVl5bWNYZWd1QlQ5djcwU3krOU5W?=
 =?utf-8?B?UlVtNGpvMlJGV29Ub0thSVNZRCtYeFpmdER0cmxWK1JFTmpTaTVHTGlXNzRr?=
 =?utf-8?B?WExsaFZnRmxsR0ZrWXExNmlmcUhVSFhKbXlTSUttTlNDZFpOejl1NGtVVzU4?=
 =?utf-8?B?NDJha212TENJU2xSWUJmUGlVR0JIQ3pZN0QvN3gxTVd2RDUyUCtCTkNKOXBn?=
 =?utf-8?B?UzdkODUyOHRyZmRSTHUyNWRvNHE0QmxjQXpNVStrKytSTlNtZnNxaERyQ29s?=
 =?utf-8?B?U0xHUEMrY3gvVlZsZmN1eExuRmNKanQrZ3dNaWFpdWZvbFlpb2pIYkFMUWNt?=
 =?utf-8?B?VTdNaEVuSXhVeXIyRERGaE1Fbm9qZ2pZMlJzZTVEMmhkekFMbFowSGVvcE1H?=
 =?utf-8?B?akZsWHEwV1g5dGlWNktWdHZiOGR0VnduNW9CUGVWUTJwQmU3bklPMC90bjlT?=
 =?utf-8?B?ejNwU2REenJ1QVFkOFhTZ0ZYamE1MXFIWHFBVndMZHNTcGdLN0dGbzgyUENm?=
 =?utf-8?B?MXZLMEFhL3hCd1NleHdhUU9QQlRTdTNpM2JJRi94S0pKNVRCUC83NnRDTk9T?=
 =?utf-8?B?cE43NlNTdDd6ZzhDUzd2MFQ0Z2ptL0QybHFudm1wRGt1elNkVTR4cHZBeExn?=
 =?utf-8?B?WUlVU01KYVlVenVUNXY3a084SGxZSWt4ZFV3eDZicE5jQWovMHIvQzFubTkv?=
 =?utf-8?B?QTVSZ3JmdEUwVFRqZnRycklFV28vQUJsWkh6eTdjWWNRNy84TWJ1UFd4MTVI?=
 =?utf-8?B?b0dTM1pBOEdkdkhTMkJKa1BNelBZVU5PWFBQNk5rdVJxakdxOWFDaTNQenN2?=
 =?utf-8?B?LzN0bnhlK2dzMC9YZnRWdW5XUWt1WGdyWUdkL09hbFdFWkttOGZEOExGN1JY?=
 =?utf-8?B?bWM3c3VnZTM4dEtiM05OSG5KV2l3WUpIU1ZJZXVzYjJFZU9JY1dhNm9VZzYr?=
 =?utf-8?B?L0pxbjZxV3JoSWEyL3pHWUhBTHF3QnZ5U2U0elpxUWF2bndhK0UzdzNKbnRp?=
 =?utf-8?B?WmNoN1daNVI2WUtjR3dUSFAvbUgyQlZTNDBTYXlKMm1Mbk1PamtpWm9kMjha?=
 =?utf-8?B?cEV6dC9KY2VDeXZOWU4ycWlYUno5TTlkbUd6RHZCTkRrSGFsRDI2ZFJNemFz?=
 =?utf-8?B?Q2JkTHhUblhSOVlLMFNUYlpCbUt4bWpPY2pTYnBGWUpxcXRUNmdUcHdYL2Vn?=
 =?utf-8?B?NzUwQVlQemNtNnArM1VQTGk3OE8vS1JwckRPclQ0N1R6YnN4Y1AvbHVNVlov?=
 =?utf-8?B?dkVIOE54THFPQVY1NEhudG5tVVJlcnlkV1RYWU9ZeUIwK3J5OGpYdTIzRkFV?=
 =?utf-8?B?MTlQVlpKZnhVR2NXbUc0YnE1MjdmNFpCOXBHNkJaVlNTL28vYnVoYjZCbWs5?=
 =?utf-8?B?WVR5ZjlsM0V3YkZPSmIxVnFCdGNKcW9lbTR3NHpDQTlpWEdkckM1VzhoL1Nu?=
 =?utf-8?B?L0E9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e19de5c-d741-42ef-3cba-08de00b7fb40
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 06:58:53.0647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RMCFpZwT64uolozJ3pX0i1HO5ET+oeDj0/Q16Mg1rUj9hqXIu1dpfrdRldUbBWwS+IvRidm7xK6GqI0wGeb/Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6299
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5279E140009
X-Stat-Signature: htdhh3d3qp5rzdnyyf91s5w1w5ibdnsf
X-HE-Tag: 1759302115-239071
X-HE-Meta: U2FsdGVkX1/97sb+sQWatBhxIr6ORrmwGDJ0qda5P1JCcVlEYaVnfAPgLX7oShoVNClIndn0986spizBSOi2lR/umyqu3EyNoR8UJgvyuCdlmtiXMyNW0WZOwyhuQTkv55gaoOoCQaRW/mWvQJ6FBwsu1GXAD0RG+G0qUgABtyEvCsTSXBG/zEm54Gx5BHZkm2OLK8feBnmpRFZrwlt7bA7EcN9QaaMJc7hcN4uXl2KyYiE8DFCgk0WDYAoZ2JUpMlfxrC+R6yvBPd8N/rqpTEjvAhFBIEA8bgIxIEw6k0RX7ni7b4w23P2ZZFnuB4xLQFVQGAJrQtQjMNLJDcMQFsmelGwm9gWFIlOTrz0iszjorp/9M7EgaDiA1DmwrJHLdf9Tl1vcu0flYtBXZe5FtmshWIbr4ro0RAbHofDQrbR7j8B1t0WHeFzSHiqD+HuUpyX69Eyxrnh4fkuQAIAe/eMaoNuZ7ghfgF9or49KFes9xRlFqe7L1/cPLa+NKQ2p+QVtCamAdvS7vwxF4qlpcUBOF29/l2q1r/hCMe7jnwCZDu5YEz462qUevdP9mhAydKl7iy12yw0nPdF8y4jOdXuv1s3gBG1cn7BloFnHSuuXAd7UClstld9zFQk8lSLcx6hMd9QeYVQiCOOuRsPpa9A39U769eXHr/R8b2xoyZO3z6TPd9FFb/AxWDM/zwPVqqJ82HXaolqG05jlqW8JjKa8WbLXUWu1mfRb0sAvJkjj/t56xYlF5XrRfhdAzKUWnC3BqzmfctkI/8UBwCZgzMCTPa1HqmpVGMHFaPbZdFDcVt2jZYSW4FMaTo9JvTcXYZIwhzaJwponNlSXjD5w/xQBouUNgul/cWSC6fyIZbn3yTuSfsEuUg8Lhibnd4z/pKTv95poQ9DyEtLDL4hs5yAzSj4S4r9pgbXYR+lE+kpmFoGGvmbzOuL8uJ9hGuJokzW9mdvD+WX/Cgo1ovB
 RDcRmDb0
 MJmez8iSI8RTrv49FM5qRyRTxSy0oDY+JPEh8OhVKkS/dNn1DhnOchohaMwELAql7TIbwIIAgr/hT+5qmyyDPiu6Z3aRe+sFriCa2/o2Vx9jI4aFV7gnZhh4QVzllvG5a5KlPqvLPUqUBjfg/ZLg+ZsD64mdrzWewYwjDeg3HWk3wtXR5vSkEm1vyDuahic6ja0DwTlTlBeskfVvsqq63Bu8D6rL7IxZUDcGFxt04Ma1+4xLfbfpso5YSX8F1+sXAISb/WvRFz8AWFCbYmfPi6hFo5alvO2PTwXF4UH9RDp9aZI82FkENx2W2K4EjncJL+NSVIYs1vpq1UPyK0lebNMmrXPwku+BTDbPWVkgpByvEbEAObK4Qk/xQuelBXW8hzWBjbYgVONc6YtsRuAciPHc+hz1j+0UWs2ASM5f9w5KnpCYWXik45yU5m+v9HRlVJuKyKMpVblYZkUwKRs2KFITYXi+QgJZotzicfM4gRAYlsTZtAKW9a73emc1wpV8cjpu5yAdCF0NjLVg+M8d+dEAm/dv6HTRC3TnBOMPEpcfFhQY3/lqPHuAPDklVJGFhnkunc9peY8/ZYeKJCALwQEqEaFvtAXkLV8U7KN5LRiftMbU91w07NGt30NiEr4Oqv2fDo+LpPdp8L1sEVtdHsPJq6a4X+OA+zZd7ogm+UVnu94yob0JxQEVA/Liafs4Vmr3VPG2XA+Pf9Ux0JxF2kkGk7POI3sT7HVib1BPwPGpeMtERt+fCu6TzKBPWYO59B78/a9LQ8r75SUuVJF4Okvv208iaezoIFiyIBW0V6EJLJPiWvoae2FvL6N+RtGNJycKey/NF7FfHSEUmCaWmB3dZgpareaiYzXRpgDHUtetUy7phRtXwtOVhsx6bZnIWuSWUQh1LdW0W/AXbZ3uXJLGqE2lej2tXBL+AIof+P/44cAeh8ojd2msUb391zsatS67Ih4IkzWXNHhl63MPLFdVASSjd
 3CzWOuAM
 1xsJTYaK8Fmy2ujYAer2O3ed1eL5p4h6Ycj9mfoDEFd71Q1dCGCSLy7hpLUQK1Rsq8+AHCGATnfccUUAAXGN/KCxk8yq6vNaKsQRzVz46SU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new tests for migrating anon THP pages, including anon_huge,
anon_huge_zero and error cases involving forced splitting of pages during
migration.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 tools/testing/selftests/mm/hmm-tests.c | 410 +++++++++++++++++++++++++
 1 file changed, 410 insertions(+)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 15aadaf24a66..339a90183930 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -2055,4 +2055,414 @@ TEST_F(hmm, hmm_cow_in_device)
 
 	hmm_buffer_free(buffer);
 }
+
+/*
+ * Migrate private anonymous huge empty page.
+ */
+TEST_F(hmm, migrate_anon_huge_empty)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret;
+
+	size = TWOMEG;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = 2 * size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+	memset(buffer->mirror, 0xFF, size);
+
+	buffer->ptr = mmap(NULL, 2 * size,
+			   PROT_READ,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	npages = size >> self->page_shift;
+	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	old_ptr = buffer->ptr;
+	buffer->ptr = map;
+
+	/* Migrate memory to device. */
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], 0);
+
+	buffer->ptr = old_ptr;
+	hmm_buffer_free(buffer);
+}
+
+/*
+ * Migrate private anonymous huge zero page.
+ */
+TEST_F(hmm, migrate_anon_huge_zero)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret;
+	int val;
+
+	size = TWOMEG;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = 2 * size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+	memset(buffer->mirror, 0xFF, size);
+
+	buffer->ptr = mmap(NULL, 2 * size,
+			   PROT_READ,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	npages = size >> self->page_shift;
+	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	old_ptr = buffer->ptr;
+	buffer->ptr = map;
+
+	/* Initialize a read-only zero huge page. */
+	val = *(int *)buffer->ptr;
+	ASSERT_EQ(val, 0);
+
+	/* Migrate memory to device. */
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], 0);
+
+	/* Fault pages back to system memory and check them. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i) {
+		ASSERT_EQ(ptr[i], 0);
+		/* If it asserts once, it probably will 500,000 times */
+		if (ptr[i] != 0)
+			break;
+	}
+
+	buffer->ptr = old_ptr;
+	hmm_buffer_free(buffer);
+}
+
+/*
+ * Migrate private anonymous huge page and free.
+ */
+TEST_F(hmm, migrate_anon_huge_free)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret;
+
+	size = TWOMEG;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = 2 * size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+	memset(buffer->mirror, 0xFF, size);
+
+	buffer->ptr = mmap(NULL, 2 * size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	npages = size >> self->page_shift;
+	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	old_ptr = buffer->ptr;
+	buffer->ptr = map;
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Migrate memory to device. */
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	/* Try freeing it. */
+	ret = madvise(map, size, MADV_FREE);
+	ASSERT_EQ(ret, 0);
+
+	buffer->ptr = old_ptr;
+	hmm_buffer_free(buffer);
+}
+
+/*
+ * Migrate private anonymous huge page and fault back to sysmem.
+ */
+TEST_F(hmm, migrate_anon_huge_fault)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret;
+
+	size = TWOMEG;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = 2 * size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+	memset(buffer->mirror, 0xFF, size);
+
+	buffer->ptr = mmap(NULL, 2 * size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	npages = size >> self->page_shift;
+	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	old_ptr = buffer->ptr;
+	buffer->ptr = map;
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Migrate memory to device. */
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	/* Fault pages back to system memory and check them. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	buffer->ptr = old_ptr;
+	hmm_buffer_free(buffer);
+}
+
+/*
+ * Migrate private anonymous huge page with allocation errors.
+ */
+TEST_F(hmm, migrate_anon_huge_err)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret;
+
+	size = TWOMEG;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = 2 * size;
+	buffer->mirror = malloc(2 * size);
+	ASSERT_NE(buffer->mirror, NULL);
+	memset(buffer->mirror, 0xFF, 2 * size);
+
+	old_ptr = mmap(NULL, 2 * size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, buffer->fd, 0);
+	ASSERT_NE(old_ptr, MAP_FAILED);
+
+	npages = size >> self->page_shift;
+	map = (void *)ALIGN((uintptr_t)old_ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	buffer->ptr = map;
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Migrate memory to device but force a THP allocation error. */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
+			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
+	ASSERT_EQ(ret, 0);
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i) {
+		ASSERT_EQ(ptr[i], i);
+		if (ptr[i] != i)
+			break;
+	}
+
+	/* Try faulting back a single (PAGE_SIZE) page. */
+	ptr = buffer->ptr;
+	ASSERT_EQ(ptr[2048], 2048);
+
+	/* unmap and remap the region to reset things. */
+	ret = munmap(old_ptr, 2 * size);
+	ASSERT_EQ(ret, 0);
+	old_ptr = mmap(NULL, 2 * size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, buffer->fd, 0);
+	ASSERT_NE(old_ptr, MAP_FAILED);
+	map = (void *)ALIGN((uintptr_t)old_ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	buffer->ptr = map;
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Migrate THP to device. */
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/*
+	 * Force an allocation error when faulting back a THP resident in the
+	 * device.
+	 */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
+			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
+	ASSERT_EQ(ret, 0);
+
+	ret = hmm_migrate_dev_to_sys(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ptr = buffer->ptr;
+	ASSERT_EQ(ptr[2048], 2048);
+
+	buffer->ptr = old_ptr;
+	hmm_buffer_free(buffer);
+}
+
+/*
+ * Migrate private anonymous huge zero page with allocation errors.
+ */
+TEST_F(hmm, migrate_anon_huge_zero_err)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	void *old_ptr;
+	void *map;
+	int *ptr;
+	int ret;
+
+	size = TWOMEG;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = 2 * size;
+	buffer->mirror = malloc(2 * size);
+	ASSERT_NE(buffer->mirror, NULL);
+	memset(buffer->mirror, 0xFF, 2 * size);
+
+	old_ptr = mmap(NULL, 2 * size, PROT_READ,
+			MAP_PRIVATE | MAP_ANONYMOUS, buffer->fd, 0);
+	ASSERT_NE(old_ptr, MAP_FAILED);
+
+	npages = size >> self->page_shift;
+	map = (void *)ALIGN((uintptr_t)old_ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	buffer->ptr = map;
+
+	/* Migrate memory to device but force a THP allocation error. */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
+			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
+	ASSERT_EQ(ret, 0);
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], 0);
+
+	/* Try faulting back a single (PAGE_SIZE) page. */
+	ptr = buffer->ptr;
+	ASSERT_EQ(ptr[2048], 0);
+
+	/* unmap and remap the region to reset things. */
+	ret = munmap(old_ptr, 2 * size);
+	ASSERT_EQ(ret, 0);
+	old_ptr = mmap(NULL, 2 * size, PROT_READ,
+			MAP_PRIVATE | MAP_ANONYMOUS, buffer->fd, 0);
+	ASSERT_NE(old_ptr, MAP_FAILED);
+	map = (void *)ALIGN((uintptr_t)old_ptr, size);
+	ret = madvise(map, size, MADV_HUGEPAGE);
+	ASSERT_EQ(ret, 0);
+	buffer->ptr = map;
+
+	/* Initialize buffer in system memory (zero THP page). */
+	ret = ptr[0];
+	ASSERT_EQ(ret, 0);
+
+	/* Migrate memory to device but force a THP allocation error. */
+	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
+			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
+	ASSERT_EQ(ret, 0);
+	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Fault the device memory back and check it. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], 0);
+
+	buffer->ptr = old_ptr;
+	hmm_buffer_free(buffer);
+}
 TEST_HARNESS_MAIN
-- 
2.51.0


