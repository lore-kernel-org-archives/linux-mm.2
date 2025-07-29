Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A426CC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 16:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CC7D6B0088; Tue, 29 Jul 2025 12:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A46F6B0095; Tue, 29 Jul 2025 12:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193676B0096; Tue, 29 Jul 2025 12:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 050E36B0095
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:15:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0B1A140196
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:15:00 +0000 (UTC)
X-FDA: 83717801160.03.3307E7F
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id E614C8000E
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:14:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YSuDEWe9;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.54 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753805698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F9qKqHZDJcJVfiAK/2/YOt6paMHG9ktFbefyUqugiPw=;
	b=n2Vv1LpndZ9ENapkE2Uy0WPCqV86dxoL76Kv/Uv02Fg8jXlzsSWZbugohlbfCR6PcNKFaW
	sQ8rLt43MC+7Od8SD+rOnojlZkglA5VP7Ds8FRpXouHpIXwNIC4jhWmc8Jmb2HK853ASG4
	Fc3Kc1M3CpHTRDJz7hDgoajVvnSPD9E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753805698; a=rsa-sha256;
	cv=pass;
	b=VrRkt2XTETkLlJNhEPIhkOJaxxRDU8ghvlGDs9NFPnejmB1bfD58Y1HqTmrJC61cLi8ykz
	y50SV/a0WtMf9Z++aWk3HrXfbh8IkaoINjuqQo74tlL2dtWHeY4+ebfZ2X/dcTkqJ0R6dW
	eZtmt2l7NE6cod950x/zhAfPtho1Z5U=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YSuDEWe9;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 40.107.236.54 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n4GfMfOGahqgjcilcD0nRseVdxVhGfIAAiSEEThcdCfY5XyQNM4MsT34B5ceHOXOGLybessNTn6eKYnbE0Ubsp/GzKx1nfiXCYHKi/9Au3IkWmmQTzmY6L2oohjUrU6+BZFfBobgQufFJF0rlD7NxuXMr9l+PJN2DGFlnts/oR+opZ5Y1bXkqg0ZrPXobUWEcoszAQNbDBoWmxsyyPOtYstvxMdmPDAb3MCiIj7UgtAmbSAvD/jsVtpPZnumwmJ37Ph1XWMytr7PjgzxSZml9uMnFQkSXFPphRDqpbVoJLSyPAdlhe7WGSWscefkspxMI6hwQam4KHnHbT3pk+swIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F9qKqHZDJcJVfiAK/2/YOt6paMHG9ktFbefyUqugiPw=;
 b=PbXtSowIy/DwvxRue2Ftm8+twPNrtSnj7Bw7/PUpovvZZU+s0hwvw2ivlsXexah9dIMgqaziad5ibNvktENGOGBHbIoiXgADcunsMi8h8R18kVbsTSahY8X0uUyQn84lOQQiMDSEUuV5/ja1xEO4YwbXlSiAReZdzUh8C55QJpUhprc4flkpH/VJtG2ZwggoktHwl3848jYoi0eZ+wEKfVmyYRlImejsICF01rp157NmS21PlUlM8FgDeK1gzdWan+ZGQNPXhULtMycgloCIf4t/Uw466VLLCnN5j8hLGBKXuDDpYNWzBnK5Y4pYdJBAKfuVYb3LXPLMVa5H8EddKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9qKqHZDJcJVfiAK/2/YOt6paMHG9ktFbefyUqugiPw=;
 b=YSuDEWe97U5AoWgTJWcpuLJNyhmwZ5TLIG5om5ve4tyv9siAThtZYXO4CArdqqidRzyU3Zq+rGSd13gdDVkV2Bfu2GAYpf5/Ad9pQiAv/rKFMTkAdPFb+Ksx6N4edSqhvYSSyBOTUe103dTkk57jea5b6d4OHflqaeE9SdiDKhUwDI/6361uAD0egz/0KDu4xRbRAm+XVLmxnupwmREEJVf+e4eKcNUuOxmih8tVNK7Ekq2gM1Rkc7jYl6w0pOtNAG1BFBTBAmlYnVkLDC6Ea5hjpUWQSf1A12Nz28ngvkDEW61yvelahdah401yc6s4yTU9F4ZW+sY7mCJW/6uZzw==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB7977.namprd12.prod.outlook.com (2603:10b6:806:340::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Tue, 29 Jul
 2025 16:14:52 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8964.024; Tue, 29 Jul 2025
 16:14:52 +0000
Date: Tue, 29 Jul 2025 13:14:50 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v2 31/32] libluo: introduce luoctl
Message-ID: <20250729161450.GM36037@nvidia.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-32-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723144649.1696299-32-pasha.tatashin@soleen.com>
X-ClientProxiedBy: YT3PR01CA0033.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB7977:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d3b6d90-8227-43e7-86c1-08ddcebb0c48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q43NiE3Aw2Yj7gBJIFDF4Uehm6VahR0Gtri0zmsBNXr5Ydqrt/GULOPKhye+?=
 =?us-ascii?Q?8D96xd/oLd4QRpKKbYJZwU/UtkPL/n1m2eBwq9SBLNkXKVnODP3U9S746nVz?=
 =?us-ascii?Q?IEqZEbFlKKCJfAYKuL4Gn/LDVeuqsENZNnCGgmZCydh6b61QneuO3PSclKiP?=
 =?us-ascii?Q?lJHXVh6iixEncqTcTUqpkY4aRx4z08yGxzmSFbDIiGLTjdNpDPOw5xftwIyA?=
 =?us-ascii?Q?ayiHrZqfI8ho9vKFUJDk93Ne/EbhQ0xEXjfRbcPOO/nKjFoVjY6pIhPo0DKs?=
 =?us-ascii?Q?j4+JzcTJP8a6Paj9CBCcO47AvvFqzQ20hVNtY0NfKqEHumLznTORKdwIDcSS?=
 =?us-ascii?Q?HVvJeK3j7kfDSsauQyV2mNnAGE1lcSD3Wt9iE8hcVlIA2nWYAOvmKcD3cJUR?=
 =?us-ascii?Q?dBuzGndLSc4vqqzlJNwzEQnVRXA/Ol158Q23wR2+VBEkVcQGnDDb2JcXLAP+?=
 =?us-ascii?Q?tltFoz7VX4ppe1yExp4LYIIKcvHc+W46w4b/JITYCHGXMk+r9k1jjdKOnOTV?=
 =?us-ascii?Q?IlfmetS6BE95OzGYeSrTkcS54QHvlcSkFsCM5MYo1rcEXcZ3FRwJS/0+LVt9?=
 =?us-ascii?Q?KkZ8SDsJAhenOstk10QNbjpgvT6yko55/1QiJfcDp2iN9gx0bYqsj4XmOyKf?=
 =?us-ascii?Q?EhJWWn4HLoikkX0JrWyBBeExwoCVyJSnfUSyL7UjnnFfLPiO1KgtjyOtIBJH?=
 =?us-ascii?Q?TxOpvCiXcAkkC2gpMQioY2JVaToQS2iqJcRRD6fTCRY3s2FAc9+eCAoSZU4T?=
 =?us-ascii?Q?uPl+LOIYKQFmm9nQBkjbPvSA8SibLAmS/kF37SXJgeONDu1cvjf9EqQtxfRr?=
 =?us-ascii?Q?FgZduLIidIh4EjThfcVuj3z7vlXZmENXxcBzi+jjHufiV7NrAe1zgPLYyPEM?=
 =?us-ascii?Q?AKSUJAvwGhetsgC4INF00+IGrRAmAcjh3rWSEfM4kUbsjPwiix0fsAKcs5x+?=
 =?us-ascii?Q?e3GHIOO5y6cIiPfVQ7ABm8o+8Ed32Gzyit9v1lqZ+1WrREGKP4c14F1p62+G?=
 =?us-ascii?Q?MPf5xL4p3tLP/svNL4dsTbnNElYJ4pw/edBOnOrn+SBCa9GE6KAWO/FXyhJA?=
 =?us-ascii?Q?jivwAzUpyvRUiWRBNOL0k99OvxRJ4i8x9Hx0po+DcqT5JTMBkb1GmLAdDY3l?=
 =?us-ascii?Q?NjLHbI6NGY9DCoeljtKr/7DON/Od9tm+AwJC5YUlCPuYxnvwE2oIsUEnR9uC?=
 =?us-ascii?Q?yYibiERjfRqSfCWf27FuArcB2d2L2VYlDR+xrjnM2Y2OO/jumEof0o0SUb0r?=
 =?us-ascii?Q?gUEWi9IL0XavguYB20ww1/UzCByHDujtIvFyNPdT+HTxxBkv0H84s0rGqeQq?=
 =?us-ascii?Q?39btJXtGRWliD+r5G4CCJUtDgBNV0sHPhPZ+PHuF01Lo3m13DV9IG7sbE/yV?=
 =?us-ascii?Q?WvJA5GDc+eI8SS09l57RJDKUBnheCwnkOCarUG0x9w7u/9U8Hg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oLU0WElHHLWhUFv537evEve3ujT/2eJyWXyGVufqPO8BQi6SrUeYRmhE39Ye?=
 =?us-ascii?Q?SR0bIz0lNbwCdc6hqyvZAPKte7ulgapbiIRWClz1lq9B37AmY3w2RlXHgxNG?=
 =?us-ascii?Q?kGUrCFS/54N04459/dSObOUW9/8NqbampVQj3NUSHs3NIY4wkx4bRZrPZfFy?=
 =?us-ascii?Q?lYrtrjy4q29ZlU4iiXvVsfbdehqOvjcFF5Z5AJUtTo8AdZRtE92dtTjs2+/f?=
 =?us-ascii?Q?NSdDsx18CE3ZQO2sYzbBjUFD+phLGdg30lf7sFGVY0TRuyZ+e5tfoTeL//y8?=
 =?us-ascii?Q?LEIVYOcvDpJGJZDG8dLv5YhKoHIgJNj4YRNqcs0EyXfkMA61xd+v6s88SmjW?=
 =?us-ascii?Q?JoHnlvz9FXsdwEH7n7tkjrwJTkO6Jkeq7/cRTzzBAzE+vsK5oHZ94yBsGiOz?=
 =?us-ascii?Q?UiZWZSOHaBa+YD2hkbsu/rNUsCwI2e4LnIj62+0JkNjrbkWJHRjey7FfVDSy?=
 =?us-ascii?Q?AMg0OlSBLQae1oSNSx2AlhdzJuC8dg5GQ5w+9yp4Rst+v26D1v8jI7unXN9S?=
 =?us-ascii?Q?Z/fFPRnZyt18x9yGmk69GLEeZsA+NeMGIv/5VGtiv+Tdsb8T6p3yTTIXP/VW?=
 =?us-ascii?Q?O63Anj1kqsUz9ZdM3uWRLjg1T2Soe+8rfLIJkKw+u+figFqte1s701iXjb7S?=
 =?us-ascii?Q?D0ICoP9i8g3si/x95mGZKKvQdVr/xP3U4fo+dQmoqVJBMi77/mmqFZ1pbPxH?=
 =?us-ascii?Q?vtJ27dc9Tox1PWpr9P4sb/ZiTW0eRGoDC41vM10RcvX7v5GInFU6H7GQ9Jev?=
 =?us-ascii?Q?h17WEAmN0I6yGUL3UrhvP/YYy4DZTZwGSMbOxF9LtUKF22Nv1DBcRqR/2v5T?=
 =?us-ascii?Q?tufGXT5n6lLQnB1XVGO3mCMsLzUMgeRQPFrcwT9N6r6EJuM1qm4KabxOTQRc?=
 =?us-ascii?Q?1LxmqPPDHEjNHHTrmrXUWT/fOL0nHz+XsbB5jWjPAmoxYO4LE6jiLcku3EZ5?=
 =?us-ascii?Q?XfgZmAfELCfij+673PIVZJ68qpK4i+ot5qZcoaaLSj3zbxV0tAlDtVXb+Va/?=
 =?us-ascii?Q?dab6zDTfeyKEhOou0KUTz/KPrTCZ3z5fz5oBzpfdjrJLQOR0+DLW6EcNLbhU?=
 =?us-ascii?Q?VXoW75x7L3f1UGBCo+UvGPEWIpyQtFJU/Yr/CM5GYkR993Brfsjk1n3jh6OE?=
 =?us-ascii?Q?Q0M5szF3h6luK/f8e5z4X7UXvMGQ+hdW5V35itGJa6D+9AElucEqWGLN2D8p?=
 =?us-ascii?Q?OYXvhptgAvyIvog1dPgisyynVybSDBcl5CjThA3I1tGjmoQrEArXhjh9uE5p?=
 =?us-ascii?Q?le8osWympCEQBFG20cY5OtCIz4RxuN3IIvZHeaCmNlf/nG4jNqeDfCbpragu?=
 =?us-ascii?Q?eWckxnE7Tlrz1F+CkBruwSWUUp9yi+QsLjegaU1PuKsWeP5D0Vu4P3f2VgyF?=
 =?us-ascii?Q?V5lAc5lslY/D8asH7x+0n6DXnNSxBZMVz9wpPUHl7aEBuBtS/SLRb1bO96bv?=
 =?us-ascii?Q?cOnSeJemeTobmLliAWeK+zApxp6koDXFb3mtgf8qaBxK0SYY05JKv1sYgVcT?=
 =?us-ascii?Q?hkmSC0j5VTVseye8W6mNsfZ0vuWOburDqEp/LqYlyBnJjMUK0h65ars5QvN3?=
 =?us-ascii?Q?mS2Bxco2xMcB5dY+jlU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3b6d90-8227-43e7-86c1-08ddcebb0c48
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 16:14:51.9084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rx855FEugsLjWd8jD+DHhLtOzytw+KMmRoqwkOnVz+sisqdyE9bQne71//Tt020N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7977
X-Rspamd-Queue-Id: E614C8000E
X-Stat-Signature: mgdqww4cisx1cq75ee57tp69htkmkoya
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753805697-229683
X-HE-Meta: U2FsdGVkX1+nPDuicenyT87JEYkVoJWRQxB5mpbtFNjVEWSEi+o92JKlSazSHjX+QhUQ/xns1yZFfXOwRC4xWUHfZUIN1FE9+VFfO0/UQhW0Tja0OJTMoPnt23EFWsXNHob8UOw0HgoF4kSD7OMCIWnUMnFaCEqZDY2gP7KuGEJxG4wApPDcxKrkoQvbxR5rjTYD/yO3aABNOFS8ua0MCTWuFS15n59tBnD3f4sFyw5jCG4VfNThqXbCZOoikkLjS45WcP14EzmR5BZQKfaru6GUzSyOF8TA0c3WcQ+hl73zJbeJun9pSZofvHaNiA/hsY8vTBDDg0YBaQsEnqc1HjOvnaQlyM8JO6lAzfB+HY1VK/AFZE50zqnilr54+DQiaSUKTwifCHu1AmzkQRmgTRMR8Gc+fr75ALjddE1zkznckRkov6xsB1QfMv3MIOC2MZ6GKw+wyQB+gCAlmM3yvdSK86sFXzsTVOTQYCNuP9fa8OsWtOKnes8LGQOaWQbAwFMV7gqx//3L9UIuYgxA9oqXUSvxOLny4j6NJVh12qlkNJsjEp63dT/VM1fFEDe+y+jwZ0mM5AIFL5dcVpkL/3bkfnQ3epkirKB5pn30pxyeLOfxJf7Licl3zVSobpYgoIqtSzoC7SCifT0bhbNUOsO8mEoFqjpb0e6evSlqIo1wZgvpwh6kEN/RZgx+Hlg4B85L1xr2mrcq8WIgcQIq+8c/nGo0bA6QWOH6w3Owlx2mTsKW20s3MR48UMT/8tZ2S1kj4JipO5IXNIg7qD1Kz7lfVZCmrQSc0hjbYsMw8j514aJu/4+IqQ7f8V1zAPGiAxUuC+wyVLHwLaEGWhSX1gGVoRny9Y2kaZ9gwPASmAvBkl9iGEwQ074eJnFYf2HwUlhjGwRyj/cpU53OWRKaklVgdrQ5ePfnRBLgEcwEd8e6bGAjkFcTS9skF0UqlyARAoDM+QUPs19I3I0Vduf
 YvGOIaqu
 swskOz//T89iOVnxyJpKqhdfugP6gz6D0YtbBPjeVjZgvvd29KNOA3p1UXd4J/pqGvpLzf8YoCX34vAymZ96le+1vhldWkLHbi0HxlinY/0GU6CXKxdjlEl3KMmDdrYQGajnmuQz8TNhdM6BW+N59MDhxgnp6DSh9jdnwqrrUeG5Ko/rlbGNbBsWyyq3kC+iCrT8iQ/oII8lHYW+Z9/uNPExN3Qtaq5HU7e6ThX7GAZApNDvIsg9gnt8g7i2VeisR9P5lKzNFS7e59ziKa7MGiSy2OB7WoL5diU6Fkvo1URqm4SGwbFjh0GKLxOpMvS2uUe16iwZBCZSzbWklwydguZ5VCXV4yzaO3hTa2pISKW+T7VGVCx8sk1J7u3ffEXR70jXKenZHdxLnhPz8tDpTUnQAvTNnqYE84t9bbAa6UlpieYfGMJWCCwImTVbSXZ/cikkOOsM0Z7IX5J6SCmfKAkMR3r/EqrdnD3YcBf7Pl4vYc2gEIS5dAcK9GwI/pCTFC41j7jG9SjbqZAHRvKF4EkSnYXbieC7DmgS4XedztEN1ELPwLr/JAeXR3s2hPmMEjCE2tx7BxGlVK0xZ4iJIK40Uk9HxVgPWucDPp7h62hQm57i3AsuRqw3U6eHd3FHcZ5Ff
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 02:46:44PM +0000, Pasha Tatashin wrote:
> From: Pratyush Yadav <ptyadav@amazon.de>
> 
> luoctl is a utility to interact with the LUO state machine. It currently
> supports viewing and change the current state of LUO. This can be used
> by scripts, tools, or developers to control LUO state during the live
> update process.
>
> Example usage:
> 
>     $ luoctl state
>     normal
>     $ luoctl prepare
>     $ luoctl state
>     prepared
>     $ luoctl cancel
>     $ luoctl state
>     normal
> 
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  tools/lib/luo/Makefile       |   6 +-
>  tools/lib/luo/cli/.gitignore |   1 +
>  tools/lib/luo/cli/Makefile   |  18 ++++
>  tools/lib/luo/cli/luoctl.c   | 178 +++++++++++++++++++++++++++++++++++
>  4 files changed, 202 insertions(+), 1 deletion(-)
>  create mode 100644 tools/lib/luo/cli/.gitignore
>  create mode 100644 tools/lib/luo/cli/Makefile
>  create mode 100644 tools/lib/luo/cli/luoctl.c

In the calls I thought the plan had changed to put libluo in its own
repository?

There is nothing tightly linked to the kernel here, I think it would
be easier on everyone to not add ordinary libraries to the kernel
tree.

Jason

