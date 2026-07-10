Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8CA4C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 07:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B56736B0088; Fri, 10 Jul 2026 03:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07936B008A; Fri, 10 Jul 2026 03:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0A46B008C; Fri, 10 Jul 2026 03:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75CDA6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:21:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F162D1A035A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:21:42 +0000 (UTC)
X-FDA: 84972022044.20.3BC94FD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf27.hostedemail.com (Postfix) with ESMTP id 69EE340003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:21:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EG41In9k;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783668099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tMZA7Ws3rlw1G0ZXwy9XoS5RDd2g8Xl6+8EcJ4VHVYs=;
	b=JPMf38RZgPDJzwVbt0wVojjYjitXcS9WixLw3qnFygxyauJ/IPFlz81o7dtyzOR1VlRhCs
	oVXVDH5WmhTTfZheelG8s5lnp4PAzxbFrouYsZWo592heQCNEYaVr/4cWCKelom4p2lVNH
	XMg7/jE76m0HTNpjLyqd4/6nD8rfeYw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EG41In9k;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf27.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1783668099;
	b=5kcOAdSTfIuvLIuWGEbGyD2s1CB2G97X8PCK70vR0cgjLOxao2JDrPjlqodgTflyHDqED3
	cTV2/7DqKrujwqH1AAI2+OJipR80EotKfOwpyXFBhpaXEP4DRTc8MJ/1iwVFmQWsZvWH14
	K5jFPxc8+pIpSwUM7BJO1ZAxtQTJDPs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783668098; x=1815204098;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=25xX0HsOIu76MVNpvrQBfeVSNfJBMCD9X6e3Gza6uP4=;
  b=EG41In9kv3j7r1bWRcc3sX+RNNogrtyChwv9YgQM89bzLMR9nYsj5htw
   S9lVBY2dRXDK9F+pnfRN7yYlXHjzNvizC3X/SCp22vt5wIwmBp1jxU3sa
   pmJtWrhqahes0KlECN2IqywyxatGKnaKdbI6MZ9xnsewaOX8vsHuJsD+h
   xZiN9qIpRVezIU6p0pHUqzclDU5VHJAlcEVNmvj4laL486be70h67dmEf
   7uN/KJFoYnjJ9HD6+AuC67qV8zXy9MwBiwJ/CBftgdwt8HamLb26hsD3K
   SvmF9S4+8OR3eye51qoLS6H7kaeJLN3zSVRcltirctYImu87j3eEgxO/g
   A==;
X-CSE-ConnectionGUID: q/2bLcrWSXaSqsMVLg3Pgg==
X-CSE-MsgGUID: I68nySQwR32tcjbHSDJ8nQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="94969562"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="94969562"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 00:21:36 -0700
X-CSE-ConnectionGUID: C5JRznD9RM6xhhrdNMVWVA==
X-CSE-MsgGUID: 28/TgM/1QLKRgyFmibqPfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="253076319"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 00:21:36 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 00:21:35 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 10 Jul 2026 00:21:35 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.44) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 10 Jul 2026 00:21:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VT39Tu4KmU9GqtBnj8N4b4IEs3xBr6GyRKvL6nwHs4cATH8K+ZqJx26YCh0uEWX0f1VpIIXeqoOqJKwfGJ8P+tFe7XYMOtydISnBRyUbczNCfW8zQKXP5A4sRYZmzWUxTo0ufacxmpAK47CceMk8Hb+3mfOCO0H1CSWnlTIfloW2XHOt3MtzmoLIoqnjrcqg5LrR582+0A++quBASTVmEGwjTAWTlCC1PGfDk8LDqkqgz718ZyK+6kIZ80s6Bx/VSPq4dLFBULW7J6nImpJR07T0OQTo1Ydt7AMqk5GEe7SLCl5oS4/1l5xWqAym+hbcwOP3W7jk+QB+Qat28zG82g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tMZA7Ws3rlw1G0ZXwy9XoS5RDd2g8Xl6+8EcJ4VHVYs=;
 b=WgRxSdWv7leHEJDAmhPX2XqobspCxJKJzPmi8cZBuhQJHFbrpZI3gjKosnWoGYJzVI6RpVkBgoPh17OFqqn8x8O4Vm2ThHDkai5kMo2DCzEC5KQ0EhdSlK3hvf0TdIMqlQ1JXwi/UMVlPzxEw1I1WHSeJ8ft/8pjEJCytLbshl208s/zhY2qssHeQy0OMaSYIsQHYX0Db5ETDUeNQcjscAwUAmF+Or88HmqvQA3vPOp+LOu7gRsRXTkFgb2Or5q1KG9f+JU62zdt/Bvl+hLFWU0VMi+YrKGIdvn8oyfZLzikRWoM1T9BK0OqDAUg+jWrolad6JmA6BV2NlOUGTsDeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by DM3PPF31D2DA56C.namprd11.prod.outlook.com (2603:10b6:f:fc00::f18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Fri, 10 Jul
 2026 07:21:33 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0181.014; Fri, 10 Jul 2026
 07:21:32 +0000
Date: Fri, 10 Jul 2026 15:21:25 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Harry Yoo <harry@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Danielle Constantino
	<dconstantino@meta.com>, Shakeel Butt <shakeel.butt@linux.dev>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: Re: [harry:kmalloc-no-objext-rfc-v1r1] [mm/slab] 6bc21472e7:
 BUG:kernel_NULL_pointer_dereference,address
Message-ID: <alCddXaJ4HkjZNXi@xsang-OptiPlex-9020>
References: <202607091002.cdfe5a08-lkp@intel.com>
 <afe80d38-950e-44d4-a729-61aa65d3c117@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <afe80d38-950e-44d4-a729-61aa65d3c117@kernel.org>
X-ClientProxiedBy: SI2PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:4:194::10) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|DM3PPF31D2DA56C:EE_
X-MS-Office365-Filtering-Correlation-Id: 913691ac-0bc7-42d6-b4cb-08dede53de4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: tgfbbXWffl5Dbfty/8vlFbAWLZneUPOYSBMGo0+XH9/2q3NvGhVib8pJODAzh8DatEqsL/zKuyXnGAKXsz6qmDkFJkZc31KJxPZSG4UFuqf7/Iosuw8Vc5aJxcCh+JKTCT7+x2WBndU//sC+bSoDKc8PgEh0YKA2EcRzXWYQx2iEZP5YHdMpM4y9GCHL9Ybfbe00n5URDkouhOORocR8RfmH59HoLrlx3f/e5nyFzWwqiunPEujlOs/Yn75MGHhaOuafZiNInUF3VK6y0wkoTwVJlG1XD2NHmlWbrPVAjgK7ZRhl26wg0vAMkNpcobH9NVunSN1nsTkGVqMKtprLRLA4cg6Rmga5icb2TZs5v+d6e53cSLp3kJsh3pjLEMJr2ZBJtF35Uz9DvJO+15xJv5bt0YwP8hblTz2EpTv3WEvYqPO2PHiykPHY7RY7lnPiVkZik3uRTe8bPerufFCw4vy8HXf25rrZ4vW1BneGdzWYPwsjkSTJ6kP6rHOYhE2JzGrsFP4QUegBaTf35l8kPnuqs0mYpFU/5Xyw2RkM4hhb1d8niUlifFwtcOT3sNy3EDx7CejsOVOC1sr/1bGhQtOcNhOmoqGbpcOfkXzrNy1aASK82cDmzZQsuc7A+0Tk8lpHbB9SVKVx+Exba9dnn0m/8PBEics402dCTlsbjW4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QtKCggzn+WOe7UzlTeROOAtI5N/0pMM0PCU43+IZezIA2v7SD7QXPfLHDil/?=
 =?us-ascii?Q?lrvsM+qRr79P+xeSMj2Q1cP2/aShXxuPGYhNKMdfevV/X6GLaMpcAeFTKOI/?=
 =?us-ascii?Q?HHYUpKwaYYZl06mRlAvsbcto+37Zuere31KKw8sdGMA94zZiy2CenrKTnodv?=
 =?us-ascii?Q?j53pHIsZqSO9RkNFUma44B+lteQA7DciRMm6YQwyg7D/jvNI3ioSPbsUeQsh?=
 =?us-ascii?Q?KeUzE4FRKH1aub5IKEOQiClt/pRvriI8z8G8RU4ESyayFePdwK2B3JvE4VC4?=
 =?us-ascii?Q?eNHX3CNBwE71mSAwM3dB7LF5IazaPVvf+qGqL0KY0AtW7iFsrNBdFPXzWTAY?=
 =?us-ascii?Q?49QXyzocs1HEtpKfeJS5pa7BtVok7qUz+vbhAmvxhvmrZ1sraVMkI0c9pGv8?=
 =?us-ascii?Q?61HNNpuwmQ9nTgf6p9YTqFJSFfI8ACWTbNYII/upUx7m3t0TqhsZ5iVLZrys?=
 =?us-ascii?Q?uJkZK9ebYlDT4h9jWGL/QWc8BE2qD+awlkrbCKiQHW1O4o6S55gIHPuvyaL/?=
 =?us-ascii?Q?PKpo8kWRJverqmi6LsqxTL4g8SvpQQV41UeyIPQAz486gk6DIwgnUtbj56ML?=
 =?us-ascii?Q?qAhQsHxZqkkQqxEvDbKBF2L9eU12mrUrz5wkXNjU+WXnC8/9r4Q15x3hz7u8?=
 =?us-ascii?Q?FASXonsicWHVhh25lUY/FIHwvrwNo9AJjBEHnEhBv/g+xP/nzLc0JMzoqPRm?=
 =?us-ascii?Q?TPEjzTkcRKbYd2FCQIpYbJYlzff3NVqRVFKVcnCdI7BGYJwN84kzTdEUCvvx?=
 =?us-ascii?Q?t8FnfK7Eat+27VJw/FtcBWZGuQqxGNQk8fMsq3OWVn0PS7iMEigBbL/Rn3H/?=
 =?us-ascii?Q?8q2khkEUm955r8vplZGHb/bvH413USVjaGLNiuRwLDTfsk1Z9MJ2KxRtCFX6?=
 =?us-ascii?Q?hzTIC0xQ2Fp9hUXr04j2Dbl9gTEc1dcoec3yWOBTyaQTxpoRNaEbVLLxFOLn?=
 =?us-ascii?Q?nAbmAiYf9SqYGBMq4Y3NPpwQH/4Cn7bVD9y9pHnBRILcxgD27ZxDwfPsmsuQ?=
 =?us-ascii?Q?KeTih7fY5Tuo8/2PIlmTlEXgBHp2nJr5vUjgUrroc2Qb01npVAt4tXzWTAc5?=
 =?us-ascii?Q?gWfkQbH3rIJ/2pgdKq0cGYctoBm66FcHpOC3Z/w8zw+FBBj5uAnahnIlN0lZ?=
 =?us-ascii?Q?zI3XPsfyl09Y2HbU4caOgk6SYYuvj4K52Edi260cmAnenaeToDIUqZM2fcdq?=
 =?us-ascii?Q?/4pjapH4uRzJMMgiyGD1vhfDaTdIvY4gAX/KKZx/Oj1syAwseg1zrz2ix+od?=
 =?us-ascii?Q?mzmW26S+Z155RSYvAKVE8xveW79kqGAbk9VKGPs6SUYvvQ6z26niEDmTMiXe?=
 =?us-ascii?Q?hL11tJTWrWaYCfyPAQgiVeRU/GVajNe7t0a2yXgcbw4dbUWS6LjnWifZPkhr?=
 =?us-ascii?Q?fxSBkfVGuDdI4MtGaPSOjdbcIF1GOpTxGQYV6Lp8C33Pj/HB4hSvIEwMrnfU?=
 =?us-ascii?Q?o3a2gi+xIvyZhuz29OWdqHpmEhFfahXcEdDHbggfWdl7Fd/7nqH0mzdUVCGe?=
 =?us-ascii?Q?3U02OFq7z1xb92/Oy0wo7zs7sPdtbwHG7/Y43mCezNRnMnGIF8irHOoLVLVN?=
 =?us-ascii?Q?DlfbmiL6bP+kzFVlDPMZ8j4TF/8QmNvGecReG4jKfT0kMMhfcjeEwXcn9KRL?=
 =?us-ascii?Q?rZVc+BpbNAooe6xp0uzSpx9E0g8svRgdMf2NaSAplee/bX1mpprmv84NGOqL?=
 =?us-ascii?Q?uR4w1ItV+j/YfhWgnx6Ty5Zjbxdcicik5liIslXLYa9B9STUUlcSkAKP7UVr?=
 =?us-ascii?Q?jJTEdIHJRg=3D=3D?=
X-Exchange-RoutingPolicyChecked: AJGV8Nc0/KA2bm9NWbT08j0WqBREf7qGJwwocBIB9bljcDBZKSnoz+hUXVgFZnsMuVIEdWDUVg9g0HTReRcNP9wHyoAPXvryHHZ41oIJlG9MT9cl7ZzyHjV8897PIE0NResQkJFwJk8f8ECsskMP/jo5fvsK1gWPgJNf246I0348fpxBtzpgkHSSvLVTO/lqwrJzw5tDsJtNceNFmPLhefeXiE6oZFPJR0uSMbrE462gCN6q+QdQcFvGPitmVf8JoHSnJk90PpKcTJodfvx67j14l7GYsELsuTbjiis0R/+zIl/eea9SOFhNAzQd/pRoX3w7pxzR9YXcfs81YAVAOA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 913691ac-0bc7-42d6-b4cb-08dede53de4f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 07:21:32.7978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fph17Auegv/P1A6YQXMCUkhryPr5nbi0zSI9gQYuYDjNx/SCrq5Z3W3vg0CeSF875/JUfP9MSiS7TR3HiDnGMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF31D2DA56C
X-OriginatorOrg: intel.com
X-Stat-Signature: iiiswka8it3taqsmwy3hp5m6waigp7zy
X-Rspamd-Queue-Id: 69EE340003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783668098-478160
X-HE-Meta: U2FsdGVkX1+4wRoWlFpr5fIHIV48YEWQm0R+v4JBF9ir+6rJTOMd2lyaNfiCxb0w4Pgv0DWqT0eq9htaXEnWo227srZyPMa1uM4T/mXFRKzM7ZnrYe81Y9NPt/KHJ5pGxujLXpCIsxA0F1EPeDAPa/8XZAUjy51yrIwGSwDapt8EheqFIMI3PixSlCc50Cvig5A3YOLQ41wFTnq9hPVqJ6H2lqTO/ZJmchcRtjsA/F7DYUullkEl4VWhhTsA+lECwdbywTnF2/CtIeKbzL6GCKrG1WtyN7N17IXe57gv9K0/p0azQ/6mRKCb8bUtQJFgFPyBmrO1f9XH+DDXz92v8i9bkHM/PKwFUp+zR06DvW0+4z0d1oZWXRnfH2+8K5xGjSqmnm1OBMpFnKGwNBV7VZzxz8xZRCjIyWDx1DC6k0xEtV7JvPY2qTd8IgX/WhMbQ5Igs5GOIaf/4IVzYqQoHrbs2482mWEMBtz1j+5IfOwM0VsLtaE6xYTZw5S6YvmbZ+ykKYSkdPLUYTOAgmO7FgFVjW29OyhzBmRbtdQ3SS24uGoYUcxmCsZ86xT9CPn3bBQ8Rol2FTrxZEiEzmLI+pxaIbxAF72ZwWLxxYohyS6od8fh7krZUAKMWwa2JAdQ/TXA2iSPrMnVZfh0cNfCUxbknG8V0t2Bk/BG0gdNvWMoLeLlcXQEU/hzwhwolCW8w105vlNu0qvuSfVai4xw1QxkCKlDDEdlb7j4+R0063KSCycUw/7skkjeAaA80hLEe21jXwVEkXvlIoUu8e2nizKj7W7CAqUiGYWzDpiU4p6L9l/TEPHE0i2LjXdWt4ncmNYR2zMtcI2fuwfeGq5bCdizR5MfUL25lQmFtmUxb0VNNuhY8fFBnRRaSCUtQhmMsxsz4Q1ho0nB7ptU8RIzgXe7lakv7s4eySqJMZLaGN6ye/y+O5SXwRCyl9UvX7fe0Kgb/lwn9HAsCfiy99D
 K21SaxtI
 f8Hb0U1hdmLj8BASlrHAUky33kSNRKuvqKmZn52RW0/AZpfLytdr1jmI+Yh9hZ+HgKE0UPrIfVV4LzBlsOTKs5/WcxFJWWmXMe5z1gfnCDXKKp7ABbpAYH0YFF0CtKKXQCxbLOnHZXq4nUZcBab6MEnQc4Wmup9FUz2PQPSA8YRGn3SRerSAnIRJkPYPa25bgP6CMjTFh8KztXx/YRBIBQkPxn2/GklG8giZg/OaBfZSl+AqOfSzd5cqhEdoGjMX/JKMMQUvb7x/lt5FD4OpCjASqZi/Zdg7T55Et/yvsNyNOuK75+X0jrT2LFydX5uMM4BHm3wsOIFJQjkWFecQFk18NGSc5jMQ9ZURx6S7SnSXpANDvChOI7Qt+wcqSzQg+E8LUhS7udC2KuNh5PuTrCioYy+bjYOFg0pq6fUPOP3M56Fm3PcedCzkxeHE/dUHRH4rxrop2DeKiQtZpfTqCHk00/mtCPiCjymDobuMxhLtScYltnF+oIphJWkOxTw4S0KCOW+JpItIN/arswLY1yl4A7KGFWIfkfDQ6VTGJp43QUi4gUOEbbhelXyavGZPIKblZ36aFf28tqBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hi, Harry Yoo,

On Thu, Jul 09, 2026 at 06:26:54PM +0900, Harry Yoo wrote:
> 
> 
> On 7/9/26 5:48 PM, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address" on:
> > 
> > commit: 6bc21472e7eb9f8c771ffdf86266aa6d9dcb1dac ("mm/slab: prevent unbounded recursion due to obj_exts in free path")
> > https://git.kernel.org/cgit/linux/kernel/git/harry/linux.git kmalloc-no-objext-rfc-v1r1
> 
> This is v1r1, and I posted v1r3, because it was bootstrapping sheaves
> for normal kmalloc only. This crashed the kernel but was fixed in v1r2.
> 
> Apologies for the confusion, I discovered bugs after exposing it in my
> tree (force pushing isn't great, you know...) I should probably have
> deleted that broken one, though. :)
> 
> Will be posting v2 that fixes false warnings w/ memalloc profiling
> debug shortly.

thanks a lot for information! sorry that our bot still cannot analyze branch
version so far. we will check the latest branch in your repo before reporting
in the future.



