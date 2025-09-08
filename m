Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20867CA1017
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 00:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D7538E000A; Sun,  7 Sep 2025 20:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78D1A8E0001; Sun,  7 Sep 2025 20:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677148E000A; Sun,  7 Sep 2025 20:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C77E8E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 20:06:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EAB211DF667
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:06:49 +0000 (UTC)
X-FDA: 83864142138.17.68B00CF
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	by imf16.hostedemail.com (Postfix) with ESMTP id 28EB7180002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:06:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D0YEDk5Y;
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.223.66 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757290007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLlbCvAHknm1conmxQcKZozKoA3Nk7HqbpBMgZqjnds=;
	b=rDrrmnWr7LYjW4pooFF0aVClXDBjCYvWiHdyfvZUTH9XiLV21iVL0vLiqE2v0RoXThX9zK
	7xi3etL7g4ZL5h9QIA0io7npI/CiwtxVvlSlqvWT/r9mdbCel6Kr97HlhUMRKf3QzTBiM9
	fnWpIuDEp9a2vddheVnQzWAUQfdYNIo=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D0YEDk5Y;
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.223.66 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757290007; a=rsa-sha256;
	cv=pass;
	b=mXYJsF2gVHk9Ls5V2tsJLXLdLNC5g8yfRR6AkoTI9zX3+kf5i020vaeUwHs2G3OK4Z1lk3
	jXmfkfmoEARAv6B+J5dczD5luEqLoWlVgx6CN8TPk4DZZXCVRfBnpj6qamnZ9bwa4uH1D/
	g5qvkq89zePAUOOrRYqA4OvliUmI1UY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I8Y3FK1CSStJzGJ57E9VLjMT9hHBNNgstSDzizoYbSdfD0cGh5PypWJHIrHzZVrxnG/PPT7gTNkrsl3dRrAzS0vknIWt+RgmD0JPYEtEOQbuaFKtF+0iEUDDpSZbhLWSCTS1mLQj7pLoEzw3wbgz/+b1Bue4ypbfXjkWsKPoZb47IsrWLDj521vZfmymEGTfqm1r9Fl+6VFM6O3jq/gBWznUl/42SRDyp8XOZbQ6mfkrGRJf0OI2DZ+WT0AbyyEZ1eE/LZxqGDPeL/6JoFo97RxEVgcgWtE9OOVg7BKZFs/G49743AneeNObcQRed1YheHPiEfhQeZhJNMnHUebYLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PLlbCvAHknm1conmxQcKZozKoA3Nk7HqbpBMgZqjnds=;
 b=a+REGKl2+Y14y33ZjEM4E2kol1aPpMDtcHIKo6+3qToj5aQyIMPxCrfGEPsA9uZu7mYwyxSmDnUC0zy08WVt6BntXMTeiMK+D+sKz5cQ/qjXUFXmKo7f71ld0v1F38GvXTTAEtYUuLw3CwtPST8MyVXIShEjUmhLfGiRuVDdYkwHixvAbQF+dIjchk+1ZdXywfVo7SSzNipj0aBCSaAYDwnJ89L0U19CGUy+Sd8yQ0CmKii4XhlbepJY/ut6JykIl3cyNgcyg+TUguZhLHlBoSG5p9nmjIx40FU0kt8G/UYZeFCiL68Ypikw11v3wDZmzlS4QUvFEtuP8IxKSE4/lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLlbCvAHknm1conmxQcKZozKoA3Nk7HqbpBMgZqjnds=;
 b=D0YEDk5YWPA310KgmYgGwkh5Y9JTRWh+bjsLCXY4kEn32cfytqOfJTrdLmGpkri+ttVNy4aNLP/VfLVc9gIU8+PZMGOHb79l5Zm43GPZWh3kOkBL4WNSewgG6lL1Cyu8FHoycyVF83/hStwj0bI1iRTOuwX4KTdvOcHqH7A6OldeCtbSe5ubbSXmLpkmm5POgOd5TrEwlvhcIPkr0ZlnQUtMLFdXm+MGudXFXeBgavuxiYomq0VrzFimwvzgFGy5zgLe2K8QHpxKvqfLSmTSh2JAiw/9ekrpWxvdNcKCBEv7XgPz5oO+U/CKdYWWSP6zTbgT6GL2x6jVw0ppTF+7rg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS7PR12MB5887.namprd12.prod.outlook.com (2603:10b6:8:7a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.19; Mon, 8 Sep 2025 00:05:36 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 00:05:36 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [v5 10/15] mm/migrate_device: add THP splitting during migration
Date: Mon,  8 Sep 2025 10:04:43 +1000
Message-ID: <20250908000448.180088-11-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250908000448.180088-1-balbirs@nvidia.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0039.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::14) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS7PR12MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ecf0b67-29f7-4e10-112c-08ddee6b6f9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTlBOVY3dkFBdHZhd2RvRXQzMGZ1WHk2cmlMUjRPa3RQNytOcXdQaDJXTHVW?=
 =?utf-8?B?T2pBb3Z4elZhRXdFZDA2MHVCNFdjdDZvTlRpSkRpaWoraHFLNWR2aExRZXJz?=
 =?utf-8?B?N1NxalZzOXRZdlZKVGdGK2s3VFJOZjNMUFRJdFpaemxFTDRqc29sWHo0VWtj?=
 =?utf-8?B?NjhvdWJUeUlFb3NPSW53VFhhYlB4VFJ4RU5jSFhIVmdvNmlybUs0ZzdFd3pv?=
 =?utf-8?B?bnM5ekQ0UGQySTRMaFVyekk1dmVaeDJ4eDAxejdLcm1FQkJDQ2hSSGtsUmdL?=
 =?utf-8?B?NEttL01DWXVRb0g0RTdtOE9lTXorZUsydGUzQ1hRUGswWjlWZ1hsQlVTOFRl?=
 =?utf-8?B?TUpOK0VQSDFtTmxXendRQ1NqTVZyOTg5UWV1R0VkdGJXVXZiZHd0dTdmdHJi?=
 =?utf-8?B?aVZyVDR2RFZuQmFYQi90OUc4aGE5RUFhOXk5QUljcmpEM2ZXWWNwRjNEUlJ6?=
 =?utf-8?B?RGpGVGlQOHBRVkFKMFhPcndCYjJkSXY0VDJDdUo1UHV3dTVHTW9ldlgzRUwy?=
 =?utf-8?B?N1VvTkFpVmxpczAxSXFZSW5qVmgrMDFhVnNtV3o0TWhHQ1ZaU29LbWs0eFVa?=
 =?utf-8?B?LzhnKzdrSkowUHUvWU4wZmN3NnVxL0pHNkFROEtFTXpjQU8zQzBUS1BUbDRx?=
 =?utf-8?B?Wnh0VGQ0MDJGcDM0OUxLbVF4QmhMY2NvMUZiUDRSOGM0S1ZkQlBtaGVLT09O?=
 =?utf-8?B?eTF1KzBCL2dGVDVUVjlQazRRZXR6aG5PbWJCSlNaTXVEaVc5UDlyVi9PZzZY?=
 =?utf-8?B?K3pyNHk2S0JUdVJFemFYVHA1UDdDWk5rRWUyek5NbDd1N1lBV3RTa2cyN29p?=
 =?utf-8?B?WW9MalBiUStjSkxvamRNdytGNjdFamVLKzhZa0FvNnlLSlRPYkFVdWdoU0xo?=
 =?utf-8?B?SHVoVHRaY0pQY2NNelFEaGFFdTlEVkhrS1pnU0xpR1EwalErL1p6Y0NxN2gr?=
 =?utf-8?B?bCt4N0FMMEFKSFhibzN2V2I5NXBSaGplTmtVdHVESjNXY2RiRjEzbVYyOEVX?=
 =?utf-8?B?SlByamdoazFyQ3B4anFaU1JkZnhMYmFBVFlFWFVsUXpjZmFwMDBxK1kydzdW?=
 =?utf-8?B?T3N3dnBkYWd6T3k4UllMM2VyOWkzYy8zTmwwdlRUK1VoVzU5QzVEOEFyVjJO?=
 =?utf-8?B?dERMM3dycVk0azQ3TGxwTDQyZGFlZTNxUHBBTy9MQ292ZStHd1VuM013N1VX?=
 =?utf-8?B?Smc4UFZXZ244RHNWQlRCVGFidTNOd3BrSGxxNVpqbTJRVmVaSHlLT1B5RVBC?=
 =?utf-8?B?bEUrTnJOVEs2TThMOGtQbDRTY210RG9DWFFycFhiMld2c2tVYnpPTm9BNmgv?=
 =?utf-8?B?eWtabDJOdFZMQTlVTnA2RVBzTDBoK3lnSnZkT3NqYzlLSWNzOG1jeERWYmtR?=
 =?utf-8?B?SjlZU0Y2Tkh6U29WRU4rWEY1RXNZU0p0dUVKNW1HQ3E3Rkw5ME1GeTh6QWlo?=
 =?utf-8?B?V21aMEdPTU4yRTZVVkEvREdabThGbzA2dUROcHdTSjduRlFCWXJ2cmtzVTAy?=
 =?utf-8?B?amFaUFpScEhuZ3R0UW5waWxGM2lXcU40WG5lenhpd3I3Q2NKYStObHB2d2RI?=
 =?utf-8?B?UENURUFLd0JNSlZQNzgwMFl6ZHQzZjl0S3ZSc2x6dGc4NE1jbjlFQmx0RXZ3?=
 =?utf-8?B?L0JRMnZldFRvRTZWRUNETllzMllQYThaMlEyK1p5bTg5Z1Z2SW83U2Y3STlQ?=
 =?utf-8?B?TDFKS0psY3dqdUhCeWhhUjVoS0VkdVhvQTVjckJaN0VwckpPNUZ4WExBQnBR?=
 =?utf-8?B?dVMxUUR3Z1pUZnYrTG01SmNBT3F2azBoakN6elRzVjBNMnIycjZZTlVqemtK?=
 =?utf-8?B?cTF3YzVqc2ZKcmZuR0dvWWl1NzNLUHpucmdOYXRWSXE4cXNjVklOQjZCc3ZS?=
 =?utf-8?B?Nkl6WVdWUEVqa29kbG96K2hyQU45VEtzS3FaaXpVUUZDOTMzaUdXQXY0dFc1?=
 =?utf-8?Q?2PupfWv+yhU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEtnTm1HYUxMNEozK3d3eWFRVm1aNjV5Rk5kZndGSXpPYWMvbjl5TG8wTHZ6?=
 =?utf-8?B?UXh6QkJHUDZrZWV3MjdCQVJyRy9TenRNMW10RmNEME9odkVoVVNDQkVrRU9X?=
 =?utf-8?B?TVFLWlhNUTd4QVRhTU9TeVNSdHc2dElPZWlrd1ZnZlh5OVJiMStpV1hSTWJU?=
 =?utf-8?B?S2srVFV3VzNueXVvNGpaQjFPV0pQMHdlS2FrRlRZeldkdEdjUXNCTjRiaE03?=
 =?utf-8?B?cjR3QXpySDY1UFZUYUIwb1A3ZkxSdGV1K3lmS20wRDhRbGtOM3JWV1kzblJS?=
 =?utf-8?B?YkR6UE1EdVpPdzdOQnYydFNZT1NOUnZKZ3VHTi9HTG9HR3JWcWpZWUo4WVE2?=
 =?utf-8?B?MlNHOFp0eVI5cEhLb2cyWktnZ1BWMzB4U05YeDN6TUdUb2dId0NyU0tjdjhG?=
 =?utf-8?B?TFlybHU4NGNRV3lwRVdkdjZsNG1OYnJuOHN4cTVMMG1GbVl0bXVodktoSEFX?=
 =?utf-8?B?YTVyTSs3SmpnUnB4SUUvQVh1bks0TVdiWWNwUmlhYlQ1cC9BUGV3YWlDbkNX?=
 =?utf-8?B?VExGQW9wK28wWGpHUHNDc1lsalRWaE12Wk5NRVhQUXI3a2dJWG1mcElXZ1lK?=
 =?utf-8?B?cnFPajZGYm5kcWtqdGUxQThBWW44SEgxZFBHMWVicnB4UlI5Q2tDcERueU5H?=
 =?utf-8?B?QURzYWZwaFhET2tHeE00Qzg5dnBZZHNIa0VaZGF3V0xwajZGemozUEhEMUdG?=
 =?utf-8?B?a3p3MjVZVks1TnVqQ1ZCUmZtaFozekZyL0VtT2JDdWFHTit6UmFpT3pRL1hq?=
 =?utf-8?B?S2xwUDg3RVd6WDVtcTBrQmVwVU5NZTVRLzZFL3g3VXVCdFdxOWVud21HaGoz?=
 =?utf-8?B?ZVpCRDR1NFBwTmRLaStES1FWYzVKWXh2Q0NQZ1BDNlR2WHhGTXhDbE91MVpY?=
 =?utf-8?B?N2ZZdjBMRjVuVjlwMXpsWFI0RkMxN3JBMUdtR1RQRGRvenNSZHNBYzNQUU5x?=
 =?utf-8?B?UERwZWNabXlKRE5sRDVSNEhJb1oxekZNTGpjL1ZPZEtTcDVUZ1REcWpaNitw?=
 =?utf-8?B?K1dCL2N6Qk9sajN4SXkrRDJGVWZuZ2FtUURHVlA5bWdSOGp6SG5aSXBOR0Rx?=
 =?utf-8?B?bEpSdU1XQWpQcWtoS0NyNXErOTNud21iVEhGQ1hhNmlqZGczck1rSGFqbHpB?=
 =?utf-8?B?VGFFMHBTZTVjQ0FRd2Z5aFFEeG5GZmZVcXVLbGFNUmxMdUVwdFdEcEpYUkVX?=
 =?utf-8?B?aCtMODNMWVV1TzVBcUpqTERNSi90em9pV1lTUkVIakZtWE5pL0hkNXJyWjVz?=
 =?utf-8?B?TlBDY2FuRVRtWVhwd1dUa3pEUlRQUWw1QlM0NVhXQ01mekxtNUNCNGR0WnB5?=
 =?utf-8?B?NGFkMk5aazliN0UwRkxqS05MVXhiWldERUxJQ0xKY3RIT1N3Rzl3OFBmczg3?=
 =?utf-8?B?eXd1MFhVL2JBRmRGNVNTYWsyci9JdDAyZGhMN3JEYU03WldNYmlGUE9KajZO?=
 =?utf-8?B?WHVwTFR6NnBTMFU1bGU4NUl6SWk0c1hzQk54dzJQeUFvZldIbWRPUGswZ2FW?=
 =?utf-8?B?MEY0ZDNFR2V1dXZKUFJ1OFZMUXlKTjJKanNQQ2JSRDFidnNXa0VMU0x5a3Ra?=
 =?utf-8?B?ZHpUb3cxUGIzcFFGQUJFVEJPdEF6NmIwKytTS1FTSkFEV3ovVlM5TThJR2J6?=
 =?utf-8?B?NEc2Rng1L2prRzNJd0Nhdms2VFliTVdlTzIvemw4bGJkSFF3WGlyU014YlZy?=
 =?utf-8?B?czdpNVRVdVZCenJIZEhkRjVEdGVaOTRDSHJ2VXc5ODdiUzhnOGx0Z25MSVFo?=
 =?utf-8?B?cG9LSDJEM1U1QkZFKzVEZ3Z2eUtEYkl4OFh2N0dxSUhacEFzM1U0N1VJSzVS?=
 =?utf-8?B?b29td2lXQUdzZWRyaWlYMWhqWE1kRmd1MzBUNWcyVWFxZGtraU8vN2RNWTlP?=
 =?utf-8?B?Wk8wUVprVkRpWHdlYWFGYnhBWTFwTWw3MVg5M3V2SzRDVVBkR284QXV4Q3U2?=
 =?utf-8?B?ZGJjYlRoV0pPcy9meVgyVkJDdmg4eUtMbmxJaFF6WjQzVk81aFcrRHFydC9x?=
 =?utf-8?B?Mjc1UmtHZVlZNmVNR3hoNXFyWFFrV0t0VWFxcUNFUHdEdkloYXdvRHVNZGdQ?=
 =?utf-8?B?RmJJaTFNa29GTVNSdURYSEdNcVd6bWo0V2E5akpFSlNIU1VzS1RZMVd2NDF3?=
 =?utf-8?Q?wLP/YDz6d7wz5RSHKaYdF1nUh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ecf0b67-29f7-4e10-112c-08ddee6b6f9c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 00:05:36.1076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UcYntbJt9EgwHKpFPDvpf3THRsLbotiv2UKEcj9cRvH/a9KTJ2KkEYwsOVYH3qNQLvUtsglDmNGP0VEcNNEJbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5887
X-Rspamd-Queue-Id: 28EB7180002
X-Rspam-User: 
X-Stat-Signature: dkb6uj9epjbwmkuennmxppiedffuxdhb
X-Rspamd-Server: rspam09
X-HE-Tag: 1757290006-742794
X-HE-Meta: U2FsdGVkX18KHnttX7VYrnLBeJnM+r1uTAdiMKUV8wCj9JwREu32f/nrvleZzFRwvbP+0yHxSBbeQ68CvLmA68NAtV5+SGAt6JkmXFXxs8HqzPM3BqdOyPfP75lw9pPmjgT8DSGO8zgDuxK2edzSwHTP9E1nVYNaqX08UsbuE0lVhWYQBJ8HVLd5xQNRfVNyapHGit1QAXng7BBS34lk6Sj7+ME08JWrmpZI8BuUTgzkjgjoE+unIHWpULzsYJkaykU11AAo6QfM5tcRp6SdOvXF9n8goJJ33ZwGRDKtDQ52sqSsk4Y2Cikokahxagmz1jFiplOf7348vFy3/yNEnzY7R1ukE8qeFxjK3xL9bCZr7FkfBnG0RjVARbrx8gyvIU03R4NJjkAr/CWbcH9mUwFv29/TFXmM5Qcs+xTupVCcnLBeIeXebEcat8dNvKSK3KNJHr1N+aLuYtRXxpOU1Ti3paWDg0VEoePZcT1DEaCfgKaBiCf/4vYMt4a8fRdLp3hDYrMLrf6Er0py1PMmwDK3w529NxmKe1nOuvAsHBPkkNC9fxhYGu90xjAFXVBGDj/GhKl7SoOZoF8+RyzmZDbw6CC2pG2UvIHB7F/6cHRWABtwpaZ0ZTpePeHTVCqanktwNKuNnUbpGfE7ql7Mm4UTIRO/k+Bqsd7H1dV+8bVpR1F29SCfyXNCjTkZ88CEwythxfJge+m2ohLcaLI2fK1ZQXpvj8PbCdp1N2/l1hovU8TcY2pg5vkh/N2UfaMr5Lpm8BFBJaiBxDGdj++v6od7zhWTEKQ83J/RibaPTV/ykSxw5nPsXl5N7E2Z9qkRxRNbKvdbMV3Nek3Njd0VpEyLnF5yeUDjQqSjvzZypSsUThE1OuQ3ABaG6/BCWs5ePlZO6ur4b1fCOGKSROqOoDI7kaK9K6S3gdmYguHPBjQ35IE7UNrcEYZpH+RdmUKj6dyLxSMJevAMwNCGjYZ
 ky6E4Ni6
 5dmgEu1gXJYm9KVjq3fGhi0xIZqRc297zv8jOj2MjWyBHflmpygTFnpYgQlshZrHM01iL2LO9iJs2Bc7cecWeZP+znUq/RTk6sEB6MeNNCJzsqXj141O+8dMhXuHgFKAlZ1JnHDyUxHGWrBgu08RvucM079fETyP5FUaRnofRxx1pgx7l3L226x23P2vTh/k+QRnBkVrKhdTVH6rtcaOR7yrk6ixasnW2lWFNgCHsBIIcTkmQT2Sqzbo8DrXCwK7VWauwGqcF6W7mSyJR2S3MkrKYu9uFIOTGtFE9kMKJQnmEOJDmENcek8874Gqel7WWy1Y0v+oCby/8LV7di/a1OvgtMdX1lu/fqMXU1txiuUIZmoZaYwtaPEGLhM02FrDEld5KcQR4UhApQabgXM2/SeqWFQmFlnClHtULdtLkgVsoa1z6pQXZNTfY3dBgXdVpP9imLzXg1Z539oGHqVUAp9H8PvAuDwiNM9V4EsplKCaXaO7H0Ndlb5z0QSz7saS/lqXKKmAAVkeX7Edi0MgWoeGJM1J/XwlON34EU1sfXXUQaU0PjwyzYcgrzUXRYOt1Z2OkvnEQJb4KgkItfRi0Gdu3J/htfMasO7wPvDzCkKQwV5kufONkEqfgmkcBZbHLopgyz5xGpRrzJkAMxVD6waP8w18HliNB8unKbMCgsH+k8tAMxxD1ai2gmzx2y/TgYqcAB/F4k4/PQmDJxmcT9DHBpTVEwcuB80sTQpqvHQKA7PucEhhLu951x1CDNpwGC4cVGtl8GLkn2XcybSrgojwBxHzfHNTQDN00GiTpwR9pKN0+RvqS/mSqlNGZAFrK/ST3+rvpoSraXQib+QlFSUQvjuAg/U9C2drRliGzhUWRrrnjxFvNZfu6LsZmaXdp6IWpOUXINkEjATJ3lDQmvzX4Idhl2/pvFk1hDxv5vH27saHBJIBFimZPirP5OCUvpyrzUCWBmJRnhpdpdSKEeTVEDJnD
 bY/GDMF1
 kAjpUoP2SXjIQMbFY5K2uXWyFdBn4BTVsnQnMQ7L48Vtq2DYxxrTAvF6CFzDqE4I/66uG8azL9VWFXp+ghaeWJKOMgAW/tXQFcuoczkvm/JGbwGwjc8+lwggrzOWuygR4McOvhI3nXwVsb0EbK987gkhfE+0KUYO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement migrate_vma_split_pages() to handle THP splitting during
the migration process when destination cannot allocate compound pages.

This addresses the common scenario where migrate_vma_setup() succeeds
with MIGRATE_PFN_COMPOUND pages, but the destination device cannot
allocate large pages during the migration phase.

Key changes:
- migrate_vma_split_pages(): Split already-isolated pages during migration
- Enhanced folio_split() and __split_unmapped_folio() with isolated
  parameter to avoid redundant unmap/remap operations

This provides a fallback mechansim to ensure migration succeeds
even when large page allocation fails at the destination.

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
 include/linux/huge_mm.h | 11 +++++--
 lib/test_hmm.c          |  9 ++++++
 mm/huge_memory.c        | 45 ++++++++++++++-------------
 mm/migrate_device.c     | 69 ++++++++++++++++++++++++++++++++++-------
 4 files changed, 100 insertions(+), 34 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2c6a0c3c862c..3242a262b79e 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -365,8 +365,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 		vm_flags_t vm_flags);
 
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
-int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order);
+int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order, bool unmapped);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 bool uniform_split_supported(struct folio *folio, unsigned int new_order,
@@ -375,6 +375,13 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
 		bool warns);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
+
+static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order)
+{
+	return __split_huge_page_to_list_to_order(page, list, new_order, false);
+}
+
 /*
  * try_folio_split - try to split a @folio at @page using non uniform split.
  * @folio: folio to be split
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 41092c065c2d..6455707df902 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1611,6 +1611,15 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	order = folio_order(page_folio(vmf->page));
 	nr = 1 << order;
 
+	/*
+	 * When folios are partially mapped, we can't rely on the folio
+	 * order of vmf->page as the folio might not be fully split yet
+	 */
+	if (vmf->pte) {
+		order = 0;
+		nr = 1;
+	}
+
 	/*
 	 * Consider a per-cpu cache of src and dst pfns, but with
 	 * large number of cpus that might not scale well.
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e38482e6e5c0..c69adc69c424 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3459,15 +3459,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
-		/*
-		 * page->private should not be set in tail pages. Fix up and warn once
-		 * if private is unexpectedly set.
-		 */
-		if (unlikely(new_folio->private)) {
-			VM_WARN_ON_ONCE_PAGE(true, new_head);
-			new_folio->private = NULL;
-		}
-
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 
@@ -3696,6 +3687,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  * @lock_at: a page within @folio to be left locked to caller
  * @list: after-split folios will be put on it if non NULL
  * @uniform_split: perform uniform split or not (non-uniform split)
+ * @unmapped: The pages are already unmapped, they are migration entries.
  *
  * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
@@ -3711,7 +3703,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
-		struct list_head *list, bool uniform_split)
+		struct list_head *list, bool uniform_split, bool unmapped)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
@@ -3761,13 +3753,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		 * is taken to serialise against parallel split or collapse
 		 * operations.
 		 */
-		anon_vma = folio_get_anon_vma(folio);
-		if (!anon_vma) {
-			ret = -EBUSY;
-			goto out;
+		if (!unmapped) {
+			anon_vma = folio_get_anon_vma(folio);
+			if (!anon_vma) {
+				ret = -EBUSY;
+				goto out;
+			}
+			anon_vma_lock_write(anon_vma);
 		}
 		mapping = NULL;
-		anon_vma_lock_write(anon_vma);
 	} else {
 		unsigned int min_order;
 		gfp_t gfp;
@@ -3834,7 +3828,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
+	if (!unmapped)
+		unmap_folio(folio);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
@@ -3921,10 +3916,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 			next = folio_next(new_folio);
 
+			zone_device_private_split_cb(folio, new_folio);
+
 			expected_refs = folio_expected_ref_count(new_folio) + 1;
 			folio_ref_unfreeze(new_folio, expected_refs);
 
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+			if (!unmapped)
+				lru_add_split_folio(folio, new_folio, lruvec, list);
 
 			/*
 			 * Anonymous folio with swap cache.
@@ -3958,6 +3956,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			folio_put_refs(new_folio, nr_pages);
 		}
 
+		zone_device_private_split_cb(folio, NULL);
 		/*
 		 * Unfreeze @folio only after all page cache entries, which
 		 * used to point to it, have been updated with new folios.
@@ -3981,6 +3980,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	local_irq_enable();
 
+	if (unmapped)
+		return ret;
+
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
@@ -4071,12 +4073,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  * Returns -EINVAL when trying to split to an order that is incompatible
  * with the folio. Splitting to order 0 is compatible with all folios.
  */
-int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-				     unsigned int new_order)
+int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+				     unsigned int new_order, bool unmapped)
 {
 	struct folio *folio = page_folio(page);
 
-	return __folio_split(folio, new_order, &folio->page, page, list, true);
+	return __folio_split(folio, new_order, &folio->page, page, list, true,
+				unmapped);
 }
 
 /*
@@ -4105,7 +4108,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			false);
+			false, false);
 }
 
 int min_order_for_split(struct folio *folio)
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 1dfcf4799ea5..32cb7355f525 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -910,6 +910,29 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		src[i] &= ~MIGRATE_PFN_MIGRATE;
 	return 0;
 }
+
+static int migrate_vma_split_pages(struct migrate_vma *migrate,
+					unsigned long idx, unsigned long addr,
+					struct folio *folio)
+{
+	unsigned long i;
+	unsigned long pfn;
+	unsigned long flags;
+	int ret = 0;
+
+	folio_get(folio);
+	split_huge_pmd_address(migrate->vma, addr, true);
+	ret = __split_huge_page_to_list_to_order(folio_page(folio, 0), NULL,
+							0, true);
+	if (ret)
+		return ret;
+	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
+	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
+	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
+	for (i = 1; i < HPAGE_PMD_NR; i++)
+		migrate->src[i+idx] = migrate_pfn(pfn + i) | flags;
+	return ret;
+}
 #else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
 static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 					 unsigned long addr,
@@ -919,6 +942,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 {
 	return 0;
 }
+
+static int migrate_vma_split_pages(struct migrate_vma *migrate,
+					unsigned long idx, unsigned long addr,
+					struct folio *folio)
+{
+	return 0;
+}
 #endif
 
 /*
@@ -1068,8 +1098,9 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				struct migrate_vma *migrate)
 {
 	struct mmu_notifier_range range;
-	unsigned long i;
+	unsigned long i, j;
 	bool notified = false;
+	unsigned long addr;
 
 	for (i = 0; i < npages; ) {
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
@@ -1111,12 +1142,16 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				(!(dst_pfns[i] & MIGRATE_PFN_COMPOUND))) {
 				nr = HPAGE_PMD_NR;
 				src_pfns[i] &= ~MIGRATE_PFN_COMPOUND;
-				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-				goto next;
+			} else {
+				nr = 1;
 			}
 
-			migrate_vma_insert_page(migrate, addr, &dst_pfns[i],
-						&src_pfns[i]);
+			for (j = 0; j < nr && i + j < npages; j++) {
+				src_pfns[i+j] |= MIGRATE_PFN_MIGRATE;
+				migrate_vma_insert_page(migrate,
+					addr + j * PAGE_SIZE,
+					&dst_pfns[i+j], &src_pfns[i+j]);
+			}
 			goto next;
 		}
 
@@ -1138,7 +1173,14 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 							 MIGRATE_PFN_COMPOUND);
 					goto next;
 				}
-				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+				nr = 1 << folio_order(folio);
+				addr = migrate->start + i * PAGE_SIZE;
+				if (migrate_vma_split_pages(migrate, i, addr,
+								folio)) {
+					src_pfns[i] &= ~(MIGRATE_PFN_MIGRATE |
+							 MIGRATE_PFN_COMPOUND);
+					goto next;
+				}
 			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
 				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
 				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
@@ -1174,11 +1216,16 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 
 		if (migrate && migrate->fault_page == page)
 			extra_cnt = 1;
-		r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
-		if (r)
-			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-		else
-			folio_migrate_flags(newfolio, folio);
+		for (j = 0; j < nr && i + j < npages; j++) {
+			folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
+			newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
+
+			r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
+			if (r)
+				src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
+			else
+				folio_migrate_flags(newfolio, folio);
+		}
 next:
 		i += nr;
 	}
-- 
2.50.1


