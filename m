Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE4ADC531F9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 03:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41FA36B007B; Sun, 26 Jul 2026 23:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0666B0088; Sun, 26 Jul 2026 23:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 273956B008A; Sun, 26 Jul 2026 23:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF2AE6B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 23:06:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C6D91C0DA5
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:06:43 +0000 (UTC)
X-FDA: 85033069086.19.BD05CED
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012059.outbound.protection.outlook.com [52.101.48.59])
	by imf04.hostedemail.com (Postfix) with ESMTP id 45EA340002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:06:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dSzRe7Ku;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.59 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785121600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrYIAlATyGGQgEstFIEBKNSUVTrY/DoiUtpQqCosY5Y=;
	b=SVJKMWIRZOxWw8qEWkY67cIyKJpOx1u7mgPtWGhHgID7jqI6QTscZPzET7LtUpo8mWRQZh
	1IFqpu2oTTbrFFze0/aNzrwftRibLpzXhQQLgDeB+5ONP3aQRJ0hTYRExyVK9jeoteE7Qh
	N6bTEMPlDKEPOMGJWR3Q/5KwNGtO4vA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dSzRe7Ku;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.48.59 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785121600;
	b=I9Xwc1tCESVqaav9uBKvfq1lHmVK5hBtr6MAo4o1uEwoiEcrZx/cvshS4uDAtbYlj0I5Q4
	Z88/85jBpxg+CbLQWDXbxidzpGYtkheWyuaCpOsBX+YqyJ3bhHRc9Gtba1/M2N2qiAbzo/
	LzNvsEHe2Esn87WS2c4vhSyZcO0so68=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sHJFWvHltte6U95PbDI8gNo/YtHN7jP64SK7LqR4ABigwQbywdCAigdRUz0wR2ZcP01wamIN/6UFsRT6OEgWo5kUh8pnTxHJciwdlCaGQG53uES++kyJmY4EBxQtbel62lOq8SxLL7OsjCx5TIBc/+UXtkkCbstVtqJ0/GuMitp0/Kg0ueVNIMoLsNQl9/gb1o6JGfq4pavI+H+ifOCrU97oBFewFFcCwUZYT0/9xsP/EhIWIwqqhwZHEsWhAAEKgWVQ+L3BGbkSkZBUa2t6V2P4CJyYSa6kajtA+YxrUd3DdhfdEkWlyvw0S683jdnBMG9obvt8TsEdKiVZ+eDq4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BrYIAlATyGGQgEstFIEBKNSUVTrY/DoiUtpQqCosY5Y=;
 b=sHQJNteoIXkReSTaxq/jLapgEY9GXuFKaF8Tc4buomviHzJeH1vHNughH6YDSdk0VvV0o56ZJ/ARVnZJ6g423yQlgdooxWlP47b98JqDrfxVpxnCyG1pc+tAORjR6AGQx2mF+59qGfMCiHpxizcFdPwNEZk/ze+eSRhcAPzNF1oofDXFT2Po6bV1Cy7gXG1cH7YyymsByF1FXrmAv+A1OWYmzRO/gB40AhBTkNWsMz+BdaREOQ4ecnKSpl8lKdsF7vmO0crFqeXBq6QjbsmxOdAfKJGb7TodkKtuaPahkJt2Q0HfR+/XfpAU0rmlp8XnmgGqtw5sElelY+DKed1sIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BrYIAlATyGGQgEstFIEBKNSUVTrY/DoiUtpQqCosY5Y=;
 b=dSzRe7Ku1ALNWZGFb6puHOUAY7Yk3tmOJN2RtE3S7STOh+AIg6IEzXJTjInA52XC9uU8tlP/OIKhNCizU/a1nK0O1G4Jao+FeFv3v0WinkdkVaIbErPOvlfS+fOhrcs3VpBJ7UAhgHsrwBxbKwIcJRn2Gl6Pj86GFu/Hs00EsRE1N60tSphJvNFyCHA0fMMv5m78cZK3TKuky6vhsbq04srA7MF/jDMc1POpPJHZ7NvncxAv7j6Uy7b2Vd0d11hdrin331klDoOj/fcr5hOfhz47gmk5Chk5FL3dj+arRrjUy6TT+QkGYWED4U9XhqD2tretNhh9KXqQIYmUSJVZWQ==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by IA1PR12MB6233.namprd12.prod.outlook.com (2603:10b6:208:3e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 03:06:36 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%3]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 03:06:36 +0000
Message-ID: <46941695-5ab9-44bd-bff8-e871e780a628@nvidia.com>
Date: Mon, 27 Jul 2026 13:06:28 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: Clear stale mapping after freeing
 swapcache
To: Arvind Yadav <arvind.yadav@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, ziy@nvidia.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com
References: <20260724082702.2531024-1-arvind.yadav@intel.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260724082702.2531024-1-arvind.yadav@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWPR01CA0231.ausprd01.prod.outlook.com
 (2603:10c6:220:1ea::17) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|IA1PR12MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: 17ccc031-c599-45ea-9532-08deeb8c11e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|366016|376014|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	I/V3alJeKyak7dKbSH8JaNLBJP81JoLyAnva+rNav/iFkxH/9eGtCb2jbqa8ZY6+WbQCjgh4JjZfTIWwDL4PDnQXISfskHhqM9ecK1x8vFYbdF2u5MuQu66vjWqn8Q6zXVgOhgi6ZTTd1GFja0Ep1fzUhJ3eeiB7eRuRMtfkOmdXeNIeuJWzCyq3lZh42N9MoHUcXIKGPLqzxbWK1phx6Uk0DERHsJTwwxwK6Afgf7xReKwRF612+Lebo2Bi1Xd7jbEP+AFhgndKJTqLdBCGVFSyqELIL8Lm/u3pCTC83HZmYwcl4NkE8G7cv4UmSRbo2s5tsoLUOJ/7sLsvCiTOMd3Qhz3891vm2QoaPDtvFV6vwXTSDX7DhbzrOkljbd/UQl/0jXkjcuLUbylN1MnA6XLeA6rJlNvo7jKaoYRjs9uMzAAr0TtihTZYoPIboX3BqKHClHrBjKu16/OaCajCpBG42ujFZeoFNuhcCtYD6/W7g/iUFESayzppmapl8xlilb9sV2n8tD3alO4A6DOzdzD5HWyF8rqT63ODueiTT+PBm9/R5kVUaSXZAk9e5hx1s/SE/SDlLUDUwAswDu4SJpFHRSUXziyMVpPUHneyI8ue37z5/MgUeX0nO63elacZFOkunfcWQcsvoe9PHFg1gulHas977PYiBpwNK+SEqs4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(366016)(376014)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3EwYUhjUHFlWEVXVTNIYmc2cUNDTG1ibGgrT2VGRTk5VXAvSVFkTFZ3M2Fy?=
 =?utf-8?B?dm5ySnZjQmRYMlZVdnloZFVIVGVGeEIrSmJPRVR0dUVaMUw1cFdwR1R3WlZH?=
 =?utf-8?B?MTJERmRPUWhTNEhDQUQ1bkZPc3BtamFvdzA5V3hnaTc1c2JmdlB6djIyUjJZ?=
 =?utf-8?B?cGsvckdkWDFqRmJTWVF2NzBBc3hXQ0gveFpOZDhteWMrSDAyRzVtTk8vVm9y?=
 =?utf-8?B?b2NXWUVRdndWTDFHaG81ZDhic2lFVnBsVFlsZUFCb3IzSENQNXVKZTN0QWdR?=
 =?utf-8?B?SUpSa2hvQTBwTlNWQ0dtL08yWmhSMXh0R0ZOOUhCc1J0RUxJaVpxT2tDZXFu?=
 =?utf-8?B?Q21KaytWSk1KSHJLQVpiTmwwaG9iR25iZWE1VEROeHpNUWl6enR3aVJkTjFJ?=
 =?utf-8?B?Z3Z4aWtLRzZHSHBDUndQTnlLTjdDYUMvcVZSWEVvSzZYL0ZnUXpaeEVBc3Rx?=
 =?utf-8?B?L3FzRHVJZk8zQVp0OTRiZ3ZJcmxLdm9ud1VkQzZXMSt3U0lncUFRbm8xVjFw?=
 =?utf-8?B?QUpVanNrT3loTldYY3N6UzRQZ04wSXVyWEI5WllZV2ZvOFFhUWVEZlRWZXBE?=
 =?utf-8?B?NldGTG5pNHBWUHI5ZEpQTDk0Umh3N1VzSjZFTzlVaE4wR3E3YVMxeUFMWjV6?=
 =?utf-8?B?bW9INDdHd0hIbGkydW5nVXZ2WTNUQ0Z2WWR3N3FYL01ib2dhVmtGLzRpOG9s?=
 =?utf-8?B?bElza2cxbGlQUG9SbmdsNnp2cW94eXVMQmdxOExVUmk5L3FJY2JSZjN4TTN6?=
 =?utf-8?B?MUF6STVVaHNTR2JXYW5oeEFaMjJ4RURZa21OdnNqQVY5aTdHOFVVRWlBMVVC?=
 =?utf-8?B?ZFEyTjg0THpkaUdUT0ROcTRlTGtDTDROY0JEU004a3lLSTd1V0JvNk5SaU9J?=
 =?utf-8?B?SENHZWx4SUtmeDhVRW5aT0Y0ZFY2QjdKS2RDd3ZuTGRHMXRkKzB2MW5xUHpv?=
 =?utf-8?B?d0M5N0swcyszaEYzcDB5eU55dHo1RDhvN0U3b1JjWVZpeGxRZTNtQUpJUThw?=
 =?utf-8?B?OVpnSXRPWm1yZHZwK3FYM29oU1YvSFdPaGRteVNIUk5yWndHbHVtK1JxK2Mz?=
 =?utf-8?B?N0I0YjV4VnluWjd3Q1hscXljeVBxZE51Y1BEQmthZlQ0bEFPaGpCd21qTFd4?=
 =?utf-8?B?eTBab0txbXJ1bkZKalNybHJ2eGQ3U09QbmxUS0FKSFNvdi9uQWhDcVlFNHZa?=
 =?utf-8?B?Ujloa29walFCUCtsb094ZjJuMVIyWnNXaGZjOFREKytyaUp0WGJ1QUl3V28y?=
 =?utf-8?B?a0F2Rm1hYkdDMWJiM3VsSUVlM2lIQ0JnYU5hY2hnRlVQNy8yTVl4NmFqMEFS?=
 =?utf-8?B?cWdkOHFpeWg3Z2NWWmlMZUY0eTdhWTQrdUU2S01UNE1SQ2RidGx0aXFBanhJ?=
 =?utf-8?B?S2R4Y0tMZ2JxQmFyUGQ0TDRIOStReXp2YUhHMGZDSno1SWEyaDc2R0RNRko2?=
 =?utf-8?B?WHJYMGRSN2UrYUdEa2tEdmxIZHdSd05FbGJ5aTNhaHV3RERyTFBPcGQ5WEVw?=
 =?utf-8?B?V1k1anErMnE1RW1JZllkZmU4Ynp2aTJMZ3pDa0xXZnBtYVVqZHVuT0JFZld3?=
 =?utf-8?B?d3Y0bzdzdjBseXkyRnNnOFNueEdYUGZjSlV4MVhJcG9nZUc3VWsyTHNLK0JG?=
 =?utf-8?B?cnNWRnU3WU9QUVRWaUtLSXQ3ZTdVMXdHZk9PTFZuTkUxa2pmWmQ0UU15NEsv?=
 =?utf-8?B?RGxnRFNuYVorKzk1WCtqeFBxeEw3YjBubzRwWFRERlhzbkRiOGNNeENOT0JX?=
 =?utf-8?B?OC9JbVh2aXdoM2E5L3lKL24zdktOMWw0MHJWUkluNml0SkRJdUNIUTdFZkpy?=
 =?utf-8?B?LzZxRXdwa0YxUGpLajlYMzFMTDlML0dEdFJpTEFCWmdmR2lEK1B6QXRaUUZy?=
 =?utf-8?B?Tlk2WFVId0FtS3NGWkppN3NiMjJBZU9pTUZGN3FTblNBTWhOSzBxZUNCL1dr?=
 =?utf-8?B?OHJDWHdENUUybkwzN2syMkxKdnVLWW9UMHpBR3BkdzR5RFdRaTZnLzFRdHNh?=
 =?utf-8?B?cW9LWGN5RWNITEJsNkRIUHlLaTZ1YU5GWGkyL1BPSzllZEg1bVJ5empVUWcz?=
 =?utf-8?B?aGE5TEgyNlA0TFBlb1NoTUo1Nm45SXAwc0RRS0hCQVZMSXgzNE80UmJFcC8y?=
 =?utf-8?B?ejB6cjd4RkRhQ2p4djl2cHZ1RjZScDFzbHdtWHlocXA5eEEyYkcybEZTSml3?=
 =?utf-8?B?V2E2bWkxUXBES2paSUo4bVRkVEFZV3dHejFXZWtudXlIN0ZNK3k0cDhGNkZW?=
 =?utf-8?B?WStuSjNrRGZXbEtCM3FacHdnM0RDZm9WTzd6RVk5WVEvTWhSaFgyWFJnVzNu?=
 =?utf-8?B?SVo1TmxQZG5DRjhtUEYydXh5NHMwaXVJbmN6dWo5RTVXWWFsQ2hXdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ccc031-c599-45ea-9532-08deeb8c11e1
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 03:06:36.2406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ogew1ipAaXkF4etjMvuDi68C6oVJCvl5tVE5GKqkYZo3/Ho8GBHejk+EOhgYuMwMjnbFW7DkS8/M865Z06KUtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6233
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 45EA340002
X-Stat-Signature: wrsqmjmkjgbarb1wbxjcke4f4wej54fk
X-HE-Tag: 1785121600-503591
X-HE-Meta: U2FsdGVkX187bODEldk3PV8rQ3LfBSAP+1nGO4KsFgQ+L4DnGkz9Q1x2pd03eW1Td9bk8vQtW+fUJ5PbBo0Ke98BdTFvd/nfViHBvwTJ0Low/tvBgoDENK3UdhATw2naJBWWlVX1O6XDU31YgowEemlCG26JBdcKaefgE0NeaLtcmkUGqNlswrBkcFvLXAKr4/EI2rxuh6+FP1m4/Hyu5QgW0CwhKIdJqbJ6/HyC1TytLehr3eTSN9K/6pPJlyQyFLo0BjF6xzh6jTmqFeae53AIvJ0XLsUaEC6z5Vbt3ZVcLjcmopit53TM+EO6JbRqUAEHcfGRtt6ov/xANZj8X96FNwdM5sYW09f7yovLUcDoIRSPQKf/EgnXD9L6xE20n2GUyNW9EkmoG/DKRY49ydzKZXBrUCa6IlQQg1Y+15f9n7/Cy8Qquhx/oMA/Fw6q7areO8zcBsSfuCAtvo6QdJndvPvlNKpopIvvU5pvzLsrNs1ljwPAOgDAS0Ebje6Lwclg1vhImUoTu6tleNOdTscf3P+6S1z95njDvjCnk2dclkpEZizs8JCU7H3oe/sdezgqduXpUhqVGUB9kHNnq88U29uIA+vAFEcegWH0qmtpMe2hdPFx0JF0fZbfhH8PeH/EQ++Wf7yY7keNpi5ShEDo0co5oLssWQR7TmhUMdynOP7Wtoy0ohh7LmbQFgVXWxdtz2G5rmp2qU48qx5hxBecF1kTO04oC+QJhQn5KacSStr4y2XvYRBMwo+tVnHrSVtcsNWHlZObuZmiA8Zya7XbXAhXSr/fjH7fZxYZuYNqO6FtgUUJ+VFDPDLNsvu+VtAXH3OKyYh8uE7kIuINPwW8Xt0jb/AwXW58uAYiXv/1xupgHyN298/pN5IMIzL4ioKzLPW6iQ6MBzReMGo8EE/7ucCOfwzf/3Gh0RjaZhpQ3GOgDAEqXPh9/xT7wgQPffW0tZyLNrO/gWFfFbx
 WCvGN/gr
 7knBn2FOzZH8gQR4rfQVyHR1WLVNOwJtOQPt7v8htsGyrp6XutUZHJcqO6yYz38lv9KEqh79/12AAOkxvwWBX3AEEL4Nkut/0twZfdJ6mf50arVW8oMMFzsSv8ekDeoVdiHmxUJ5iyMn3XXsqHV4cOW5DvUN7LA+z5hJ8GLjus9/yv5ODt8uMTBzluofzVKYtGoyrKt0kRNDAekOBEvbnvSbW9GvGXhwKvT+S21NnlRJCi/qGjy1U5FrM5ha1QSykfB+tVd0Y0IBB9MKBKlwS4yetBDcX2sfThSgF/B4dRgVMXFyr5FIxl9hU8wY95V3rI14TzYIkmEJrNX9H/tfSmgHuyVdB8tJbPh4VhlqJH3P7EuXUTO/Pw5WOcgWZTY5ayXKBso338Q7WRCYHKfFPk1vxFH11iq2BhDMft7gPiJrWXYix/lvUMk0AZg0DAuLt+I5kIjoKRy+FzohubAxm26r//7qL/lQf3WGJrkaAPdbG9AUnJop/lg/tzsn1q9ZR3vKPXlv54jlsQTPBnBGd/+aO8/nm5/1+w2oOxVQR9mSdEAp5cwj1fDefHnnh09I4tvg0fdwEVE5B0HZEgivym8w9/ZWwdPz07ALk9hnvHcGif3qSWyxThAoHHEsVPCAO0Xz3vcBJV9+JGv0uojrt7Kg9eAFgeC6xd+Xm5ceAlcLNzSE7ThKST4MNrxoCsqi0oi3tQjTsrNJVMRxVv14HwR+7h7wFnNmYluFndaXMwnyJ/ChTinpIXRLyffQgT7jBZXNUU/jYPVi1IN/eNu981N/VxIBtkFTAOPvJL0q/n7YQ+6PX2BOXtZ3Tar3XqLuSRcLD/JO46A9K8lk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/26 6:27 PM, Arvind Yadav wrote:
> __migrate_device_pages() reads the folio mapping before calling
> folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
> from the swap cache, but the saved mapping still points to swap_space.
> 
> Passing the stale mapping to folio_migrate_mapping() makes it take the
> mapped-folio path after the swapcache reference has been dropped. This can
> cause an invalid swap_space lock access followed by a folio reference
> count BUG.
> 
> Refresh the saved mapping after folio_free_swap() so the current folio
> state is used during migration.
> 
> v2:
> - Refresh the mapping using folio_mapping(), as suggested by Zi Yan.
> 
> Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
> ---
>  mm/migrate_device.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 554754eb26ff..ae895758b72c 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1204,6 +1204,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>  					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
>  					goto next;
>  				}
> +
> +				/*
> +				 * folio_free_swap() removed the folio from the swap
> +				 * cache. Refresh the saved mapping before migration.
> +				 */
> +				mapping = folio_mapping(folio);
>  			}
>  		} else if (folio_is_zone_device(newfolio)) {
>  			/*

LGTM

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

