Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C5ACD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 07:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760806B0005; Tue, 19 May 2026 03:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB066B0088; Tue, 19 May 2026 03:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A7A6B008C; Tue, 19 May 2026 03:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 420DE6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:20:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD7B71C0BB9
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:20:00 +0000 (UTC)
X-FDA: 84783320160.21.03941BC
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010058.outbound.protection.outlook.com [52.101.46.58])
	by imf08.hostedemail.com (Postfix) with ESMTP id C8FCA16000A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:19:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=o4o+Dfrr;
	spf=pass (imf08.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.46.58 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779175198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tToTDeZ2zH40MRA2cGhy3MJjH7UDbtc/xCc9lAoPtb8=;
	b=EvG68srkBsOIT7RNeLp8H4oZNyMM5QSHmPBdWhfEOLaKMI+cd0Hvfbyh1fiR4ZKteRG17E
	5d5VznQOSywLtxYDyWpttUVGPil4TlzM9x1cLnDbEE2XKdQMtZYwfr/uDbcaSsDW2grHbY
	0Wg6t5QjBrCDeqSCPyUUBaXyazVFwbc=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=o4o+Dfrr;
	spf=pass (imf08.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.46.58 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779175198; a=rsa-sha256;
	cv=fail;
	b=n4a/DeR/IUXZa2jl6qw+JETopz77S36XcsvslUtmRvUOLI0Pah/eukwN50z9Kv4Nye7JNT
	bp4eInkrgi2LjUpuR8xYpwHEdrMhKm7bnAOxFkLsjUGjxcduBVUTrsIfHuSYRHEAfd5MyD
	LmXWJRFoSzrgbNXbiHOnbgef/G/dK5U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gaufHFBZAHVSI/VBShSBeOlGIUVwMMT9kpMMv27PMvlizc4QLLFsqFoJtlMeBp+drjZUzM67bmeaYBhLYISAzGamdpc24EgZzyrJI/8NcpPtjb9lusVNHrZLfWCThCI7qCf4RZ1I9o9G4QhdiZpautUg/G+jRrUkHsIyyQva/UXDHRB1a6wl45gA+V/twcOcWcYApnkOpDdRnq61UFweS42DHkEdMGKMbLwZpRpxh3kUi/ku9d5TAI1E3y8yHrV63//YdeGTqQbSfntW9jnm4tZRa9Uv858k69QrROO0XB7wzOsPz1m52O8xlkeMx+OM5PdnP6MHfx5QEhzi/Udrdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tToTDeZ2zH40MRA2cGhy3MJjH7UDbtc/xCc9lAoPtb8=;
 b=WmGVujBJGade125jNVwoX6GLNGdxsSi4N+ZDEI4e5B5cNBH40r0mSc1ER7Fr1nOrm+0BLgsbPUi2SsfZtossPhL11Hp1s+j79iSzLkFmFIHFOrbAxvJEmbfQhG7qiq2wXXNUxYXkmaq73eoUd8/fpjPQ2WMf+9bEJhYakq0Higez3B8TL/5l7tg5vzAfTW9WkF9k6UqmB81+NZXO4mZ8yZbYi2fARjr5xHz3SZ6EdnRjUT8Dm+DI/JXdKzXL9gCgrMrIDOELI+YoYNZjsrI3NLzw8v4gAyvH936Nbw1QojwLuYPAaC/25M4d86e0ZNg8QuZCFeLTxFNvlkmAVLQQ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tToTDeZ2zH40MRA2cGhy3MJjH7UDbtc/xCc9lAoPtb8=;
 b=o4o+Dfrrp2PpwAa9dqIVZUzhLkHOT3W/xw9jMm0Vu9waFJREy0SO20gX/XWkC2bgRys2H6b6J8FA2fUR9NmpX9K87IrU4WUHCbirhdUFgVkd+2IMOJJi51wqB+wHX8FmiMu2hyPrv3MucCShijUn+wS5dwvUW2AXycp/53FAoTQ=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DS0PR12MB6439.namprd12.prod.outlook.com (2603:10b6:8:c9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.24; Tue, 19 May 2026 07:19:51 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0025.022; Tue, 19 May 2026
 07:19:51 +0000
Message-ID: <01b6eefc-c107-4f8c-9d7c-3b86f54cabaa@amd.com>
Date: Tue, 19 May 2026 09:19:42 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit
 memcg
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Albert Esteve <aesteve@redhat.com>, Christian Brauner
 <brauner@kernel.org>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
 mripard@kernel.org, echanude@redhat.com
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <20260515-hinschauen-effizient-9e3a05a94f2e@brauner>
 <CABdmKX0d6Zsg+_TxXjB80UZR23ZvXzxYoWzORgwmx=ZiuE+Nzw@mail.gmail.com>
 <208fb820-d8eb-4832-a343-ef8b360e8120@amd.com>
 <CADSE00Lh95ygoXGKJGsYvQGEsFV8sVmwEC3uvh8M6r3ERzaJwg@mail.gmail.com>
 <88efe10a-8b93-4a81-8279-4a5559d0f17c@amd.com>
 <CABdmKX3yZubjDKbVqwrjHAiKyj_ioHzOoxd0wzFbJK=PAGOqcQ@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <CABdmKX3yZubjDKbVqwrjHAiKyj_ioHzOoxd0wzFbJK=PAGOqcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0127.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::15) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DS0PR12MB6439:EE_
X-MS-Office365-Filtering-Correlation-Id: 79b325b6-71f2-40fc-25d1-08deb577044a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|22082099003|18002099003|56012099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	mLUr2v38XyeinR7+AM0mNNIaHEsJJMGTMxmOVFouuHDR5XuSIIdC0fsvDF+oDXznz/mfFBjAUVSIfYOAKTd2VvMpxTjxU1OND6EUQmjZt1pMbHjVZnNVi3V3NdZqoyxWzwt/upkNWtM6bd5Ax/mau+KUvuSm98kq9tk5y9nZiHLXcI5hGA+78iR6vEI4Rl0ZWhZ7tLG0ZMx8WKuNywFPG8c9nACDpk20mQzbd85tiCSRUumOj0ZuThij48KwJHu2DBuKpnxYaXxRHxt1tBr0unCn0Tp+/Gt0AwuaVximnQ5qsM3w9IhnqMeizEdLyQ168wl8eEAJ7P69k1Ue0Hg1VKJiRClZ0M2YjANdMdTlYaoHneqrqdo0b1/Hkp6ftuM3P3A7Ln5yFJ/ySEURHtye0sAcxPrs6nVvpX9XBs3vrje07Sp516r8UGv0ZL/JxHopUP0+CuUganBwH2ltMSYWktGWMVjXGEMKWPh1PXV8/YK3Gpome8iPZ5ZZIPP8/mv6jbeWVMmzwpHneDu1s3Cl3y/GwrU41DdqDZB61tEr7mtlttwefzrR7shoJbABu7S/eoiFRd/Vm89ynA76Zqk4bsXnYpYrBhu9PDi/wTx+PK5P0JXlWf5NLyxBfZano82NG1OQ//1/nJPgbkwDUGMdlznfrZeyyw5tRzNdfXoGQiR2ZTCKdhrd3LZ+B+avGStD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(22082099003)(18002099003)(56012099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXc3bjJMK3F1QW0zdHRJc0Z4U0t2K0tFa3JkTWxVenVnYjRLRzNBRXpSTXhl?=
 =?utf-8?B?Mng4c0duVmYvZmluemtUU2wzOEdFN1YxL0FtZEE2NmZEd0hvanBrSG5QVHNv?=
 =?utf-8?B?MFBqVHF5SFZKMXpaa1pOYkJuellFc2tKQXB6QnNMYm5FSWNNTkNBK1VYSXB2?=
 =?utf-8?B?TGUvbmRQMEVOaTBHZWtabnM2REs4VDhxWGcxZnNVWmc3bTBsaVZKSTJ5Ymlh?=
 =?utf-8?B?SjlCMjJNb3RldlZEREtldGJXUDYrdTFHbk8yUXlENHJoaVREV2VyZkJIVUZy?=
 =?utf-8?B?VlNUSVMveEp2WUlvR1AxV3ZGQTJqZTRNZEhpNkVJZ01PWmcxSzRWLzkwVEIw?=
 =?utf-8?B?a1pjbmFOVXJ2S1poOHRKWGxqWGJUSmllN1dsR2U5S2lxTUxZaVRGcEFWV1o5?=
 =?utf-8?B?enRINytxLzliaEswakR3am9FOXY5clp4TUtlN0ZMNzN1YWc1dlU0Mm1DSlU5?=
 =?utf-8?B?d0w5ckRUZGxwbDkzQ1ZiZFEvL0ZSNG4vV3ZhM1p4T1Z0OU4zRnBTTHNCaG54?=
 =?utf-8?B?UkwzSndRWWtzMWtzU1BzSy84TnVuT0pCRXU5Rjl5dk9xY0FvTkZIUmhzTnlv?=
 =?utf-8?B?dHNXQitwMzNrZXI3ZE1adkNRcnYvNFNpMDI5c2F6aTc1REJGQUlDaGF0TTg1?=
 =?utf-8?B?akcwSVh6R0NBVHljTkVYazhnUTIyK3E3VlZoeldMTUFuM0lQWDVpUlROWDB4?=
 =?utf-8?B?dVFVUEZLZGtKdkxCWFo3OHI0bWMrVXlBMlVQdUJaanV3eFNBVDFVdEpSeTc0?=
 =?utf-8?B?YUprL3VZeTZ5Y1hnd09tT3VnVExTZ2JvZHFzNDVVaFl6YnMxclRzR21uLzh6?=
 =?utf-8?B?VjZ6ZWhwRmdSNXFRWEllRG5NRGdtd0RKNHJBNTdCTlRrY29mMGU1ZWprQVVD?=
 =?utf-8?B?Z0ZBVlhZbndEQzNCbHhJejlBRVhiWHFPSzFJN3FHY2QvVVFGS1dBSDZyRnVS?=
 =?utf-8?B?VXBFekVPM2E2amVDZ0JwbzlzWUtSTFJMK01yN2RNeFBaU1V3OGlrVElVei93?=
 =?utf-8?B?YzgwVVJwc2VEQ2VOazhEVEd2MW5LekNEN1pWQUJnOE1BNFdmc1J4UWZBUVZT?=
 =?utf-8?B?aHUrRFE4VXJFYzR5VEJ2SW5NTUZzSlFNV3lTRVNGMitybCtuYU5UQ2NzSDJP?=
 =?utf-8?B?OTMvVFZJRTBZOVlFZmQ1SXJaTTljS0JGQ3JVSXhYM1FzdlcyM2ErWFpDTS93?=
 =?utf-8?B?T3RsWkFKSXQ2alQ3L1Vtb2FBbUJBMmpCbFBQeGxhdDE1bjNNdk1WOUVKZ1VS?=
 =?utf-8?B?Y2wzWUhrUFd2cC9EcGNkaXcyekNpTmdpYUFkMXNJOGlmRU5mQk80Mk9KZ1R0?=
 =?utf-8?B?dmY4N3hzdHJmcDJSODc3NUFFaXhzNnlsNzJjZHB6QWFNTnRKSmVRKzQ1MTFX?=
 =?utf-8?B?NDdXdUtQMEVJQ091YTEyZnNFRWFiOXRMQmhWNVhLNjdTWHhCd3RGUytqSHFt?=
 =?utf-8?B?WGNPcFVFSWU5akxEUnBvRk9JY0dZcmg4VGJUN2ZHSjlUWFRpdkxNK0R0VlBF?=
 =?utf-8?B?OTdHaHVJMHkyL21xNnVLdHNQTDNVT3NYRjVyeDRFR3lFUS8wZDhZSmhsY3pq?=
 =?utf-8?B?Z2ZNNnBnL1p0WVFEZUowSUxEWDhFejJQYkRGNFd1dFA4S0xtRUM0RUd0ZC9Z?=
 =?utf-8?B?YTJERjF1UlVaWHYzNUVsU3FRbnF0Wjdia0lMOWFSckMvWkV4NmVTbGMzc01S?=
 =?utf-8?B?amlXQTZJVEZBM1U5dTdnSHFFaG9QR1p6MVMwdURmZStxVzJHVkJzam5teWUx?=
 =?utf-8?B?Z3oxeFNEY0ZGREF6V0I1ZEJFeXdEclJsSDhFKzcwQ2pzUXFwRTNmMmE2eDZn?=
 =?utf-8?B?MVJkR29IV29LSndGNEgrU0VFR3N4a3MwbHgxRENKZVdVbXdCNjUzS1l4WE9D?=
 =?utf-8?B?VTNpbzJuRmdMN2pmWjRGOGRyclZDak5PdHd4K2ZBUy9EOVZlalkyNlRkZ2Nl?=
 =?utf-8?B?bWx3RzVGYXJJekh1bzgyRVpxWVQ0V3ZrOFNIZFpWUWIxeWlHU28rNXprcmlI?=
 =?utf-8?B?eWtLNWhoQ3dZT0dNaXhTSUMxaFl0ZVB1VllZY2FiNGY1dHNZWFhDZjh6Snh0?=
 =?utf-8?B?T2pkcE9jYzJwSW9OWVZMbFY0STRZVjNsOXdkbkFYb1lDSHI0azE4cTN2dXJI?=
 =?utf-8?B?RkhKNUxoUnJ0MU4xd1J3YjczMFNJdXJMbDVBMjM2K1JKZXVGUDRpRnZrTzdi?=
 =?utf-8?B?QjNQeW5lSks5MGtzK0orM2ZXNnNkVnl1VHRFWE1pcWoydjEySjg4S0E5Z0pl?=
 =?utf-8?B?b2YyY3d1Z3ByRGlHdWliRVJuU1JjQnNsa0psb1BwQUxET2xqUGprc3BwSm5r?=
 =?utf-8?Q?KglzcuK24b/j83fFn0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79b325b6-71f2-40fc-25d1-08deb577044a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 07:19:51.2634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vjdyUJPUFOfj8iHsCcUFp9eHhhXekCHrPW5VnWQOS2jXhN2da880tFCuH8P7EgMi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6439
X-Rspam-User: 
X-Rspamd-Queue-Id: C8FCA16000A
X-Rspamd-Server: rspam06
X-Stat-Signature: ma1ii3kn6yjjtfncdko1t9e1m3ufhzpe
X-HE-Tag: 1779175197-187108
X-HE-Meta: U2FsdGVkX1/KlaoqKPixKwRjvAzCoURtuvFcTPt/d2jh2ugVbOcjI66SsQAItE1wxDa8oVEU0NNITR2ZJ4oH7ape6+vr9ehN96zGDTgRtszFyMgodySHxeIi33g6A0WeTbJnb8aOElKn8Vw4KmPh/bWYqfWOPfZgIy770HZFyu6z09q2Hc/W+BpFRF3e6mF/jC1/6m8d2mE+9MuK4LlpvwxBtTcmm+Mq6W+cNO5tW9K20OsdWHVNIA7G9BXAia5/fLEpTnVKhe6n6cGv7JWtQc1VsuP4x8SgnnYedt+0J6+2Q03pIHZWrwbDXFr0HV1KgfVVhJWwSXImWdrtLb9qokNGNYoZWpPYQ0FiFloQELHdZKV7toaFl8OKOHC5Zya1jc2Zxzj2pIUTEaUEJVvok1y9eYbM7gtYg4lut8hF3GMz2PZr2ws/Mx9ho2pqhGpMKsbuc9Lh1rUqaTvWb3FtFI/2uqY5iAk6cRfWXRgQKIffsdXp2KIGXaCPN0xBE3RSvIf4Cm/h7KqsuqANFD8o6TNkjLP93Fo/BE9fBhFuK3eomqL/P8NOFw0Afk8koxkxz3tT45ukxWZsg5ZczkTohRHC45Ti8iscix52tzejjDJvdzEiN35+ybjENJU15qDtwPbylJvXziTancUPAIeKaWi4TUZEZkLEAkrYfmMJmDZm36uKh230FMksQFaOr8la7xwR8wBMoqnKLo04JVR5SkFbGY5HDs1jT27gAiAK7UZ8Myblw2bKD5m/cnWdCKQ0a4z8Gl2SXvsIKTRi40Ms/LMFOCxa2lF7EgUhXN64x1lQ4OMtAeNzHsWrk7SdTIIRi1vVwBhUidAbzCyRT5o3IG/U6yfE1Zgxyjkfn47jB8XStw5tYqVANYXl1vcCJhDjVERkvzGsLawfqKhlYCj0TzXY1VUpSKvs4aNFVu768xIzL7I94mTy+/SGdpxwXrupGRUG9PCX/1sdFwAAkRj
 vgk11T6e
 28x4t41qDZaN6zq8xQr1TeJfzkSvK2XyNDUzsPqAOr3mHGMQpssAcQlCKz8StKWv+wbDNI/TuArPu+/Z864cWGEBgPIXfzypSbtxdal6Vrvw9OYGAxRChBWLt61i03SZpDEkJ8zONnqNUDjL9ASo1CDBEaEfCzXqD5L7h3dOlGJokvSLXCs3i+3gxAi5VJazmRhKG0h7sN6MmILhufUExySCy10zkQ8QWk5AXIJqEsNMRN8URJjDxPAh+GB1xjJhIYA806c4NQ6qB4AP8pWsA5TspqXeM674hDUYo/Qkv56ozGGPKYsZHs5a7BNcpohhxnXwZ8DswIMbHF0A+nILgQRB9DdyyhL1NhFmm86JULDVH9o+NeKrDQL0qCwYNVDFFe7VPrq46B+w0yxHU29GFzSFkaCdBdFRbzAfBv3nWwG8iyvzfearjAAsrS3QiHV2PJoWul3VJYu7m47MuZFs6tFyliOvipplWHzx3mlegFHXZTAJdXZhfx1UGVMbuJfJ3OLW1x/FVxDuWdLtUJve5fBd1Qdfr5p7YYO+F3751TIpiVoIl7d2AHbb3MAB4tEvB66QpXq3l0f9A9S8USGyafQSlMjUCRYIeoQ9p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/19/26 01:39, T.J. Mercier wrote:
> On Mon, May 18, 2026 at 7:07 AM Christian König
> <christian.koenig@amd.com> wrote:
>>
>> On 5/18/26 14:50, Albert Esteve wrote:
>>> On Mon, May 18, 2026 at 9:20 AM Christian König
>>> <christian.koenig@amd.com> wrote:
>>>>
>>>> On 5/15/26 19:06, T.J. Mercier wrote:
>>>>> On Fri, May 15, 2026 at 6:53 AM Christian Brauner <brauner@kernel.org> wrote:
>>>>>>
>>>>>> On Tue, May 12, 2026 at 11:10:44AM +0200, Albert Esteve wrote:
>>>>>>> On embedded platforms a central process often allocates dma-buf
>>>>>>> memory on behalf of client applications. Without a way to
>>>>>>> attribute the charge to the requesting client's cgroup, the
>>>>>>> cost lands on the allocator, making per-cgroup memory limits
>>>>>>> ineffective for the actual consumers.
>>>>>>>
>>>>>>> Add charge_pid_fd to struct dma_heap_allocation_data. When set to
>>>>>>
>>>>>> Please be aware that pidfds come in two flavors:
>>>>>>
>>>>>> thread-group pidfds and thread-specific pidfds. Make sure that your API
>>>>>> doesn't implicitly depend on this distinction not existing.
>>>>>
>>>>> Hi Christian,
>>>>>
>>>>> Memcg is not a controller that supports "thread mode" so all threads
>>>>> in a group should belong to the same memcg.
>>>>
>>>> BTW: Exactly that is the requirement automotive has with their native context use case.
>>>>
>>>> The use case is that you have a deamon which has multiple threads were each one is acting on behalve of some other process.
>>>>
>>>> At the moment we basically say they are simply not using cgroups for that use case, but it would be really nice if we could handle that as well.
>>>>
>>>> Summarizing the requirement of that use case: You need a different cgroup for each thread of a process.
>>>
>>> Hi Christian,
>>>
>>> Thanks for sharing this atuomotive usecase. If I understand correctly,
>>> the actual requirement is attributing dma-buf charges to the right
>>> client, not putting each daemon thread in a different cgroup?
>>
>> Nope, exactly that's the difference.
>>
>> The thread acts as a filtering agent for both memory allocation and command submission for somebody else, the process on which behalve the daemon does things can even be in a client VM, completely remote over some network or even something like a microcontroller.
>>
>> Everything the thread does regarding CPU time, GPU driver memory allocation as well as resources like GPU processing and I/O time etc.. needs to be accounted to one client which can be different for each thread of the process.
>>
>> The only thing which is shared with the main process thread is CPU memory resources, e.g. malloc() because that is basically just needed for housekeeping and pretty much irrelevant for this kind of use case.
>>
>> The problem is now you can't do that with cgroups at the moment but unfortunately only the kernel has the information you need to know to do this.
>>
>> So what you end up with is to define tons of interfaces just to get the necessary information from the kernel into userspace and then essentially duplicate the same infrastructure cgroup provides in the kernel in userspace again.
>>
>>> If so,
>>> the `charge_pid_fd` approach achieves this directly by passing the
>>> client's `pid_fd`, without needing to add per-thread cgroup
>>> infrastructure.
>>
>> Well it's already a massive improvemt, we could basically stop doing the whole duplication part for the GPU driver stack and just use cgroups for this part.
>>
>> Doing that automatically for CPU and I/O time would just be nice to have additionally.
>>
>> Regards,
>> Christian.
> 
> Hopefully I'm following correctly here.... So you are duplicating the
> GPU driver stack to achieve remote accounting on a per-thread basis?

Not quite, we are duplicating the handling cgroup provides in the kernel in userspace.

For this memory usage information as well as execution times of the GPU kernel driver is exposed in fdinfo for example.

> Does this mean for GPU allocations you currently have some GFP_ACCOUNT
> magic in your driver to attribute GPU memory to the correct remote
> client?

No, we just expose what the kernel driver has allocated for itself. E.g. page tables, buffers etc...

When userspace allocates something using memfd_create() for example we just ignore that. 

> So this series would close the gap for dma-buf allocations,
> but what about private GPU driver memory allocated on behalf of a
> client?

Well we would need a cgroup which isn't associated with any process were we could charge the GPU driver allocations against.

But good point, charging against a pid wouldn't work in this use case.

Regards,
Christian.

