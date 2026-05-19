Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17308CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 07:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549386B0005; Tue, 19 May 2026 03:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3DB6B0088; Tue, 19 May 2026 03:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F186B008C; Tue, 19 May 2026 03:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 191056B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:53:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7EE1C01A2
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:53:41 +0000 (UTC)
X-FDA: 84783405042.21.8DCD3FF
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011064.outbound.protection.outlook.com [52.101.62.64])
	by imf25.hostedemail.com (Postfix) with ESMTP id C2617A0002
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:53:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=aXBYR2TS;
	spf=pass (imf25.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.62.64 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779177218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcTGYPJyddA/87hdIBe9DbOLClP63BESwxE1z6U6qqM=;
	b=qOVd/jc+HQcGLeBPaNxcf2TJvhr4hjwggSlTNmfg5fiGXRlXs99/QOISJTVtYETFnTjwaa
	6QBtI37vuTl6nPEQk5Ed0pCM/6l3YVmw1BBZlOLHH5UEeq+D0us/52LTkUIRI9/geAQ8y3
	55Zo/nAZP2FC85Ncaxd4y2x6c2BIpmU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779177218; a=rsa-sha256;
	cv=fail;
	b=dmxJUgd2mq3FlqMax5/43+bWGVXNqyhkDzMwPzq2dt5uZoCggDSdcC8PpJMNqUoQ+VaEdu
	w0aluCMwZXPNLjtZ/9ErobsoZkIKVyH91FK6T5sH5FK7JA1kGDSZXU40o3SNmOV8ebOn/h
	w9vkCuctSmwcJJjdUEHPrpFavpwZ3e8=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=aXBYR2TS;
	spf=pass (imf25.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.62.64 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C47NOUgzALBfz0G8PfzauSOb/yWfHD4bI+kRvS4ogba7hwJF2nibpnz/PRctzgr4ZyoXdeHsPS9Yg4q2K9CQlP6tXyziWcxQOoxcUP4Q1n9GUESoiXHUSyxy+hPVgRS8yGe3oYWpxiWD3s8b3F8xLzkz5pqxuTLGSYveIBDZ/LONtlt0MvU/JjBM7rPmy3XGExY+W2jteKch//adhrwhGa0KS2ufiQycm70lWnIujBMlrHDijYStO5P1dHgg1GHR9tDuYwfSVcCMZvu9ptvrkosVxCl2np7DfIYGmhnuDiTH+dFqTH+OOq/dXmvu89MmJXRyTtHHLOB1d5HHsx9reg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcTGYPJyddA/87hdIBe9DbOLClP63BESwxE1z6U6qqM=;
 b=NFAVMv826SgnPgqwrkZqcIvU9fcSqYXwvzGfm4GkfdiDFUbxNWbTYvNRahfUluh4MfdTe2nC/Et5ECAUZBQeYbfE0/ZRXwTgp+t5/bdFPi7oH0aOXwHUgIDb7hQ9sJ6YqHdbw1/VIqG0+ZAtr8+F7b9cooTmpELjR4Ld/OZuaIYu+5jvkvaq6DmhEqpI7PNAaWPKNq56+IghnWo9c+jOHxc14BxxzeGMFXbH88UkqcuYevRNOxUip1VH4uZZWM8PDFG7W97Vyz0ww+MjZCM/fo6MN2VDGFajql6ZWnSYlQ4VhP/cdVanEb1RW6vU5ukPolPGZQQycucl9m+dDQvKhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcTGYPJyddA/87hdIBe9DbOLClP63BESwxE1z6U6qqM=;
 b=aXBYR2TS1RROtj2D0au1VJy5cKdeYY7yPq6ta49MvxDFoW2isVh7OPtvZKALEonjsit7IWW4jxToy5DeUwb/lqwwo2+fGTRe8zxqa33eje/356qXv+1EibXyWJAk1x7mzvKCmK2849V/zDvqa7ebl+DvHWvzQRcdEQndVuk6yEc=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SJ0PR12MB7067.namprd12.prod.outlook.com (2603:10b6:a03:4ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Tue, 19 May
 2026 07:53:29 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0025.022; Tue, 19 May 2026
 07:53:29 +0000
Message-ID: <9cc79977-9a42-40eb-bfa7-460881c1e10f@amd.com>
Date: Tue, 19 May 2026 09:53:19 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [Linaro-mm-sig] Re: [PATCH RFC 2/5] dma-heap: charge dma-buf
 memory via explicit memcg
To: Albert Esteve <aesteve@redhat.com>
Cc: Barry Song <baohua@kernel.org>, "T.J. Mercier" <tjmercier@google.com>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, Shuah Khan <shuah@kernel.org>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri- <devel@lists.freedesktop.org>, linaro-mm-sig@lists.linaro.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
 mripard@kernel.org, echanude@redhat.com
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
 <8ef38815-6ae9-4359-86d4-042554357639@amd.com>
 <CABdmKX2uwZ12kYJYPJGfWxuMBOJS=64b1GRj72tfB5D=NKM22w@mail.gmail.com>
 <CADSE00Jq_uvNgvxgPze0mEdUd+hF4-DPZkHy0KroWHZzygf4WA@mail.gmail.com>
 <CABdmKX3DhejYBis9htLDnzPrG7vuF3R3URLVNEbnyd61SSsx=g@mail.gmail.com>
 <CAGsJ_4zyecY6E-=Tm4_couT7uoM9LMcFdTMUPkZAjj4zUKE-dQ@mail.gmail.com>
 <cb84c2ee-9de1-4565-b2e0-60984721228f@amd.com>
 <CADSE00Lc42s2bzXzV5D7t1Enf56u4BVj-yXLp3Yxhm0=qMPvuw@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <CADSE00Lc42s2bzXzV5D7t1Enf56u4BVj-yXLp3Yxhm0=qMPvuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0309.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::6) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SJ0PR12MB7067:EE_
X-MS-Office365-Filtering-Correlation-Id: 2afa463c-406f-4c66-c463-08deb57bb6d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|3023799003|56012099003|22082099003|18002099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	IOe1jomYCeJ1l4P9ZTKYM8vM7bZTWJKmIBdDvTmJLW+TGJjEjFIa40HVPgcohH8GT9HsxsAZcBBJaThIElUM8C4nkRnhUtwOLmicloq55YiUWm6sQ73ro94k/3I5YnzW/MN53WRjp9pX87aJHqgZqfZ84mKHJmgMAhg7Swoo7OXq0Wud/leHc7ROMaUKt5VkH5+QwPmBVvXAWG9BC+ldN0MwHooR9yeQ8K/gIXZnZc/q9xK7BPWTUrMjuRbbwNcTQeKaTx/UgOP7cNNoWXD5+l6skntTbDUajGVfAjLPIFSw3GMp9F2K6MkgVbvv7FrQWbUZ0cUznVmRqEUwLI1PlDbHRFMfbOUX0avg/h2x9U2pWdZlMVTmjnxnSzMeySdXe0g+XvyZccNfccZ70zIAgj10jvZy9eVJFefw+hhcBzBrZBgN67oZ1bP15x0mzubl1tWAz0u/BDDp9c1r0bJgD33Cz0/E33eDmf7l/BLLJubHphtWo8SExM5Mk1nQAfpT3kl4YpczlY/Ri3pdjVFx0dz/sxecehDAZwk2bXMJEqJhZccGbRpJaKwU47xJtwiaMHTaxG/yiDBtL4DMCgVO8+gGRQKBgMeeyRIbXKhKdlBK90cBZPyRJfgyxjnSzL9osDXUg7qfwMBF7DLdy0cZGElalh7TQO9qcO0sKgyPRIx21EQhGd0sZd8yY3gvx8rn+4HjhuA2M2Pc84iiArDTgg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(3023799003)(56012099003)(22082099003)(18002099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0ZoaHhlbjhCYWF4RUxJWDV6dGY3VVRXSStXc1NzY1ZXdVI2L2NBSlIwZVRJ?=
 =?utf-8?B?NlJ1bVRoNWlzVkxiUkJVZ0xxa3BXa1ZvS1hTTUM1WEtobmhSa04vQ1F5VzM5?=
 =?utf-8?B?VU02MzRCc21BSGkyY3dWc1dBUjRqdjlNZGUrRFJQMEZwV211Y2ltN0RsL3Yy?=
 =?utf-8?B?U2tQa21JQ1BWbjNxejdRKzEySm84dDk0N0h4TXk1ZHR6Y3pkK3JVcjN6RHhE?=
 =?utf-8?B?MFFaVkJUVmgxWDQvV2F0emFHTGVRVmp2VmlmY2ZtNDRaclpoV3VnTkVzRFBr?=
 =?utf-8?B?REhBRkZZK1Rrc2FsSDc0VkJhS3JGWjdqS1lRYlBtdEVKR0RtV3ZJNUU4b1dX?=
 =?utf-8?B?bWQyRVgzcGJlR0lEMHl1b05IUzZ4bTNCVmxBQWFlVzlwYTZKRTdVS1ZzZEJo?=
 =?utf-8?B?eWxvaWs1dEtwKytIRmRISFR4SnhhbGdQSVRwNHRBUmlWbmFhVnhkbmdaN0RH?=
 =?utf-8?B?NklUNjlRMnFRM0xTb0ptcU9IY01iSWltVHVLMEduMmdubkd0aUMvN2NkeUtE?=
 =?utf-8?B?ZFZzSCtqRDlmdVFxTk00ZnAvR2xBYlBxM21hUUN6UDlUT2E3UkUzamtFTkEr?=
 =?utf-8?B?enZoeEg0UlJHdU5MR050cm9odTlNQkNwdGtzNnZDU3RISmsyZ0pITWpWa2V4?=
 =?utf-8?B?d1N5R2NoTXhvb25uemRCRkNwWCs5M0plUkhhdVU0aEhxQy9YU1JYc1ZPYjJh?=
 =?utf-8?B?Rk41Y0JLN2ZSTU93RFFrOGhQb3d0R2dVKy9PZko3enk5aU1wTFVaN0QrVkJ3?=
 =?utf-8?B?TnRuNWdSejU4V0JSWjBnbGpBZGkrUTk4WWFWak5sTnpMbmdzTTlOWWRjZnpO?=
 =?utf-8?B?TzhIdTcwSUpOL1gyMFFlTGpIV3FGdndGTTZJTHJzd2trcHhneWRZbFBLaHpp?=
 =?utf-8?B?ZlU1dkpmSFc4VGZiMHg4OUtNemtTbzgyWHZ6RzdjRG9MTHJiRlZMWFRGbDhi?=
 =?utf-8?B?VUdpODc1MDRUbFhUMHBob2Q2QWRDTytRTEE5bHVEeENpVkQrTFFrK282SGhX?=
 =?utf-8?B?R0VQTHl0S2J4YVYrdjUzSnd5MFNKOWxsa1FucUl4aDhxY1ZmMFJWVFZQeVdz?=
 =?utf-8?B?ZzloVkFBZWtIY29NYWxJM21ZVnlSMG9vM0hOcFlKeFJrZk1uSnE1elkzYm1O?=
 =?utf-8?B?Y2I4VWtFeTFEeWFxMitrY3FZRnFMbGJlMTdmWnB6SzRrMHFPY3hqUHFsSkhj?=
 =?utf-8?B?aUltYzZSUFgzdUNzcVJIa1NvUFlJSldHM3RYUUpZU2FYNGtHK2RGcWRmeGF4?=
 =?utf-8?B?RUsvdE9jQ2JzdHBnWUpvb3gwTVlJakNKSDhkSldVek1GSGUvYnVaaTROOHov?=
 =?utf-8?B?UElOSGpHYWRyaUxkN0NBYWNaM09FZGhvQVVBR2N5L0RBU3crUHh3bDFxN1M5?=
 =?utf-8?B?NDdqU2hBT3JYNkpvMEVDRzVQVmlZNC8rMC9RNlcrQzd0cWNBOXhKMnZBMDVj?=
 =?utf-8?B?NkFwaEl3SEhMNTlPQUJCVXF0NkJKODZ1UnNtWG1sYys0UWhwR1VlSVlsQ2dH?=
 =?utf-8?B?b1NsdGtIS2czR1NHTmowRGI4MjdldHIzb0R6RThtVmhXRU9CSXlMSlRWdVhu?=
 =?utf-8?B?eW5UZVF3RXY4V0lzNU5xM29yenIxYXpoUG9PWjgySU5XeHh1bGYyZy9HNzVh?=
 =?utf-8?B?WW1zSng3cEgyL2ljMzI1SDJuc3dXNU1zWlU4Tm1RdEY2RlVaaEMzc0tsSHZN?=
 =?utf-8?B?dlA1VE9qbG1hSzNFeTNxV3NmS01neTJyY3FzbWpNelpTak9QVzZ5VEp1VEp1?=
 =?utf-8?B?eVpDSWNoYXlFcUJHclA0V0tSVmtnR1BuMHZyUXBkVzgwSFBRT0IwY1RZNXMw?=
 =?utf-8?B?Mm5Ka0FVSEV1cHVhZU5hbzNYQUYzaU9heHFaejNaVTFwd2M2cnhjdDg2b0xo?=
 =?utf-8?B?dysrZHZtbXljSmVPQ2FGWTFNSEtJcUx3L3g3Rlp4Vm9nazRtR0puVFRWVFRy?=
 =?utf-8?B?LzBsVVhBcUd1OU1pNGg5Yk5RbmtJZ2NjSkJyVVg0bTBpRTQ5SXpiaEdzT2RE?=
 =?utf-8?B?dXNwWUtGRndiMThmVlR3bzc4RGJEb2gvV1hBK05xQ3RLNkpSenNad1MwZDBx?=
 =?utf-8?B?c25haU9hK0lqcGVOU3cvaHdkeXRMYzhwajJWTzhtZnRLMWxTSW80YWhacDFm?=
 =?utf-8?B?d09LZEw0a00vM2Nyak9rSUVoc2tvN0sxRzk3MkVSYVpkNTE0UVhOMmtDUllS?=
 =?utf-8?B?RTN3RlN4dmNIcFN3eHFyUnFPbVNUZ0h5SUV0M2twMmFvQ2d3TkFjazJKUzdP?=
 =?utf-8?B?MzZhdnppQnE5KzJ1U3d2TnRmdFBXWWJOZzRmSE1zOVh1bUQ3RWp5Mkp4dFNh?=
 =?utf-8?Q?GEFllYyeNyi5uR292C?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2afa463c-406f-4c66-c463-08deb57bb6d1
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 07:53:28.9599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lHKflGocT50PZGGGXfuV9j2328lwMnecTmWPNTA9XZje1JVfcupepggejSGFNoqF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7067
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C2617A0002
X-Rspam-User: 
X-Stat-Signature: 3hjj77t4chhagkst35jfygh5t5h7ifir
X-HE-Tag: 1779177218-534462
X-HE-Meta: U2FsdGVkX1/NEW6Y+qdFg7DXEn8TJVZUw5A0oFJRQWZEWAtBBXOjNQPI8+7czykgxgeCmn0Pz0Fm/lAI0rrikMqxo4JS7T5/eLqDEDMz9nY4bnMZ5q7z9XrCvl93uG0uVoW65p5f87g1qV8iGJPPOdkUgZH2Yclg3FM4dcy5gPI2yd2cOhC9NpljOegV/M96A+bpWpLM1nTX+H0v2jUtGOIutaWEhVdxElh5BuOkt7kQvzsHfq0LG114S8gwmr11D9t0hMf04CHXw7tLxjKvGsRBtu5Z6qnmAoYOt/X5YHUqjsq1+ZhP12TnxyYeLJA+YuDReU5q1bnOucXSSCTqGpKlqBcsMoXLG3qPaBv+SVVNntT+Hg5K1KpR5w58HfW/+isXXS0KRBq8K7LPD5hItxdHaREQN/qBUf/KBrprFEpM2ZAVVF3rhPDKn4wUqlBALDiPQ1q8nAomjh/kMQXAqtpHhsEb3u67iwQsS/1KmBcsyIPUl5idqlG7QbGl0xc9OKx6ZS69ItCY5VWY608+nTM6/Unpv/sVxUdZrlSTRA4fZm2WB/HwJZuCoepSfrOvrsHN5jOoFfunq+0chonMP715izHLQT9Hcz7kBuj6VhFp3uWvs9E1QY5KBk+/4kvBCmYSh8vAfdmBadfbExbf45fxZqFElHhCxp9kgFlYqZiVbR0LoNEYOn1q6eBhD3b+H0Qb0kQNuyEYWrMgu3Ld4zs83oNKSHih8TnQN5+Mn76ry7rW+WihO4BSIlx9gbdRJsen+UB5F/lUrif5Dc7//AwY65ys7ESaVSWcLbKKuXbOMEbxKtuxAUnulqThwLqn/YucfFHfQSd3oZQbE6upGbvgghA3puU7XNRyzalo/RfFmTt9pirA7m1titInxoXN1d6qZ8TJI0gub4AH/mTRu+CYQl+1OXEWd80/oLaqwZ5CVG7nEUMnUyiYN1pq5Tb7pO/CeHX/9ifss+e6Vwy
 5tWpj5lX
 /yOQCfFVwOXI/+JfREsZRgOksjwii6cGJwLm8I3ut6lqp5QdVvaIlrOQxrQnW9bUkbwxTLQuZOHBVTuoMTxrGHbeE/qjjxtgmISUyDFqzWu8Nx+mUqqgck//4y8BnENoX/KNhKe71DKso2n+PmA+Y84sXpIToyF9FRYrXGPTlbyr1BE6JudulZYN9odjuooHagdCyfB1RD/0BaUwVzs+g8uPKjBPajcfJ3djPXWfQcrZdOUGe6Ebw3h45GBnnQ/hp/SxQrE3OVPf697YXjyeP1Yv3fMuKfxSvAAv7urjMrPxqvBEfzZFl7fj3s+a34fu/f8zSUtYvW3USrrJdtutkwbxD6yDaVZoyciLCP2WJ9bX/NCaFdupBgPAgHc63apOwhBAvxCSZiPMh/UPivon6j/GvWCePmGp9Dy2mWkHe7yuJQh398AO4qtAw0LItJ8Le/Q7PUCd5stIajAjevSF2ItnKEyv5u5cdQO1h/Z50GM3TVHDk+vI/y7oF8ajD95tKa9Z70rrtS6nNb6+92nOtu8dNu2zWdLtYgJeQFgNemIVACnCepRtDWgLFBCIg+qU8e7IN+YP/QuOukIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/18/26 14:06, Albert Esteve wrote:
>>>>> udmabufs are already
>>>>> memcg-charged, so adding a separate MEMCG_DMABUF would double count.
>>>>> Are there any other exporters you had in mind that would benefit from
>>>>> this approach?
>>
>> Well apart from DMA-buf memfd_create() is one of the things which as broken our neck in the past a couple of times.
>>
>> But thinking more about it what if instead of making this DMA-buf heaps specific what if we have a general cgroups function which allows to change accounting of a buffer referenced by a file descriptor to a different process?
>>
>> That would cover not only the DMA-buf heaps use case, but also all other DMA-buf with dmem and whatever we come up in the future as well.
> 
> I removed a draft adding an ioctl for charge transfer from the series
> before sending because I wanted to focus on the charge_pid_fd approach
> and keep things simple, deferring the recharge path to a follow-up
> depending on feedback.
> 
> The main difference between my removed draft and what you're
> describing, iiuc, is scope and layer: my draft was an explicit ioctl
> on the dma-buf fd that the consumer calls to claim the charge (see
> below), while you seem to be suggesting a more general kernel-internal
> function that could work across buffer types and cgroup controllers,
> so not necessarily userspace-initiated? A kernel-internal function
> will need a way to identify the target process, which sounds similar
> to the binder-backed approach from TJ [1]. For everything else, the
> receiver still needs to declare itself, which the ioctl accomplishes.
> 
> ```
> # When an app imports a daemon-allocated buffer, it can transfer the
> charge to itself:
> int buf_fd = receive_dmabuf_from_daemon();
> ioctl(buf_fd, DMA_BUF_IOCTL_XFER_CHARGE); /* charge now attributed to
> apps's cgroup */

Well that thinking goes into the right direction, but the requirements are still not completely covered as far as I can see.

Let me explain below a bit more.

> 
> [1] https://lore.kernel.org/cgroups/20230109213809.418135-1-tjmercier@google.com/
> 
>>
>> The only drawback I can see is that DMA-buf heap allocations would be temporarily accounted to the memory allocation daemon, but I don't think that this would be a problem.
> 
> The main reasons we moved away from TJ's transfer-based approach
> toward `charge_pid_fd` are: avoid the transient charge window on the
> daemon's cgroup; and to decouple from Binder, allowing any allocator
> to use it.

Yeah those concerns are completely correct.

The application should not volunteering says 'Charge that buffer to me.', but rather that the daemon says force charge that buffer to this application and tell me when the application is over its limit.

> 
> Technically, both approaches could coexist, though. Of the three
> scenarios TJ described:
> - Scenario 2 is directly addressed by charge_pid_fd approach without
> any transient charge on the daemon at the cost of one extra field in
> the heap ioctl uAPI struct.

Yeah extending the uAPI to pass in the pid on allocation time is not much of a problem, but you also need to modify the whole stack above it and that is a bit more trickier.

> - Scenario 3 can be handled by the charge transfer function without
> changes to SurfaceFlinger. The app or dequeueBuffer claims the charge
> for itself or the app, respectively (depending on whether we include a
> pid_fd field in the transfer ioctl). It also covers non-heap
> exporters. The con in both variants is the transient charge window on
> the daemon.

It should be trivial for the deamon to charge the buffer to an application before handing it out.

> Both approaches shift the responsibility for correct charging
> attribution to userspace: first, 'charge_pid_fd` on the allocator's
> side, and the transfer charge on the consumer's side.

Yeah that's why I said it would be better if we do that without any uAPI change, but with all the uAPI we have to transfer file descriptors (dup(), fork(), passing FDs over sockets etc...) it could be really tricky to implement that.

> Deciding on one, the other or both depends on how much we value
> avoiding transient attribution, and how much we need a non-heap
> generic solution. With the XFER_CHARGE we can cover both. Thus, the
> `charge_pid_fd` approach in this RFC can be seen as a
> performance/strictness optimisation, eliminating transient charges to
> the daemon at the cost of a permanent uAPI addition to the heap ioctl
> struct, but not strictly required for correctness.

Well all we need is a uAPI which says charge this buffer (file descriptor) to that cgroup (pidfd).

With this at hand we should be able to handle all use cases at the same time.

> On the other hand,
> if we agree on the end goal of migrating other exporters to use
> dma-buf heaps

That won't work. DMA-buf heaps is actually only a rather small and Anroid specific use case.

We have tons of other interfaces to allocate DMA-bufs which need to stay around because of HW restrictions and we do need a solution for them as well.

Regards,
Christian.

>, and scenario 3 is addressed by adding the app's pid_fd
> to SurfaceFlinger, then `charge_pid_fd` alone is a coherent/sufficient
> approach despite the uAPI change.
> 
>>
>> Regards,
>> Christian.
>>
>>>
>>> Thanks
>>> Barry
>>
> 


