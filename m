Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0570DD0D171
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55D986B0095; Wed,  7 Jan 2026 15:38:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535756B0096; Wed,  7 Jan 2026 15:38:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40E006B0098; Wed,  7 Jan 2026 15:38:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 277596B0095
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:38:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1E8F13B0E0
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:38:47 +0000 (UTC)
X-FDA: 84306331494.04.068EC66
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011070.outbound.protection.outlook.com [52.101.52.70])
	by imf05.hostedemail.com (Postfix) with ESMTP id F2E13100009
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:38:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V0kAFAxk;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767818325; a=rsa-sha256;
	cv=pass;
	b=hDwR9iYNkXd4E6Yf3FRYQyBkgnRs6RC5idHVgd+cdtLSFAPCLmr9OMpcfnhin43vZxSogX
	4f7djsrE3iw3zUaWqTjRMIL8NrTqFqDhz8As5ZGHsnTmN1auh+bU2B3qXnk6/z9iCd5A5h
	c+/0W3+UD93HJCWWocWkpubWjeGxcNg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V0kAFAxk;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.70 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767818325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9sN7KSEpoSrEpyukIu+HQIxhBQAb9k5e20WycwnDkQ=;
	b=uX/TllIPCws2o/kcDpFQ0tTNdsSS6lPWN/Px6QVVvPYQQst6hwA1sIfTs6XSKu2IfJMelB
	7g7kAa9T3HJQSOA2F3i8BSIISvAjuSC6XGQTlxiFyxh4eJmkN6VFBzQbM7IT4UffHHnyJJ
	FdajVkgtvcbNQBOdDYZAQJbTyRTM4jw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C3DytUkyX64h3qGMkb1kARJ2p5Nu69fVXioPCZXy7ote0YLR8h+bPmKyvB0W1RGtlHHjy5hAaEz/7h1Wm8payTiCg87hgptqzdFkUhtPjXZfQ49xw3GOcdUsfQwJYWGmbi7C3w6quwkYYpx5e/qoKbxJOU5NAKF4f2+aIpj3RXkEEzpxU1YQl8B9ny0GgV3IOchd1jo5Z5Yun0wpq2EzKO5KrPAKfaJDBE25cvuCFYijw+8TB3RuomnI0GN3pwg0X2NQzV/jjfYVimU6ojs2Lm9/AoQzF5eu+s0vz3yExriZxobiwyLU4WomgCpucZxqn05BBeThUmveB+rcioOciA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i9sN7KSEpoSrEpyukIu+HQIxhBQAb9k5e20WycwnDkQ=;
 b=JuU+bcjsU1NDBaSl8BNEFm5nikeZbuynz/lEp8+5kSZKfaESzQZlHirj+01oSGlXMQQYO8h1z45ulsoBPpOuIaXViaqBgVLSd5gjNpXu69Rg7IE6Rck9kQrEhOy8hE4vhDqWySqHqtEku0yOzGitkehDcW122pDawKYSQ2vWt5y7eIfa+LJICCmWJjjahYpVYZQkulC/QUZG6REY8bvRzNl+ePiXe5kRZCkMW3a1jZfUu+nrtUtLq3C88kigQ3O4OqRI4XA4L0lONf66eqBwf5fp+jH5/Fdn35QK/Vv9c1moWJ/Fibt+RTknuwuhOt3CyIJAPo9THFG0rBXuMFKElw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9sN7KSEpoSrEpyukIu+HQIxhBQAb9k5e20WycwnDkQ=;
 b=V0kAFAxk4PrWBSouPEgHQIdprePJvjQ/+2LX9/7gPmkjbyLHkzDKR0a15q69KaY4lvTKRsa0GXbP4uB2cIpL5SiEd2vOZovvpY40xpUfCgjln9gr2FHrh+MROq5f2iB/kfIuzX9cs2zOp59kFmuErSzyAlMl21jxWkXl6rHKqX3IKk60agyw435NgnMa6yO0HmfCxelc0gQ7V/acmCV7JmHGA+ZnS6Ba0IHwIjFkCCzV8S6Hlygp5/JQRQZjeSXoAkM92JtD259EK/QYzlbJqvfgAyx3RMUlXQNJCiZMgvStKcKNodmAI1uOydKuxlaNvEw9jR4fIAQGo5bZs3vfDg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM6PR12MB4436.namprd12.prod.outlook.com (2603:10b6:5:2a3::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Wed, 7 Jan 2026 20:38:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 20:38:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: Francois Dugast <francois.dugast@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/4] mm/migrate: Add migrate_device_split_page
Date: Wed, 07 Jan 2026 15:38:35 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <95BD5D5B-C8EB-4EFA-A895-CFD660504485@nvidia.com>
In-Reply-To: <F4EAA470-C922-4066-A115-13D6D055C73A@nvidia.com>
References: <20251216201206.1660899-1-francois.dugast@intel.com>
 <20251216201206.1660899-2-francois.dugast@intel.com>
 <F4EAA470-C922-4066-A115-13D6D055C73A@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0043.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM6PR12MB4436:EE_
X-MS-Office365-Filtering-Correlation-Id: 870e4808-fa71-41ce-2582-08de4e2cbd7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Tm50Q3JhODBWWTFwRVhCMkpoK0Q1Z2xJN0ZZRHhsL3dVTlVSTjIweFk4VEFJ?=
 =?utf-8?B?WWR0WTNqNlhmcE9CYXFqdnVUWWlKOW81d2pOcENleUVmVmdxS3RPYk9SUWdx?=
 =?utf-8?B?RWdtczcyR1RHSW5jcUpVQm1ndzdqZGU2a3o3dUl3VWp2R0RibHhHVFFuVGtj?=
 =?utf-8?B?YzJFdEE2Z3gxK3ZCMTdOMDE1UWxFQzZ2SHZtUWo3L1lFMklHOGVCVUNESW5r?=
 =?utf-8?B?bFRwTFF6c1NuWTV5dWpkc3ZmMFhudENnNU1uVUYxcVFmT2lKMDNZOUJ4NXJ6?=
 =?utf-8?B?blJmV2RXbVJURXVYS2N3MTlFRDFRS01qRGtiK2ZtZjAwTVJ3LzAxWUswK0RW?=
 =?utf-8?B?dmtMMEl0dy8xWTFmTVFEczdOSFNBU1J6Y21ZdUhjR2FJQnQ0MlkvSXQ2NnRS?=
 =?utf-8?B?VExNN01Za2xGSGUyN3dCTXFHOFgvdnFXd1RNZU91Vi9WUWd1Z28xcEVWbXQ1?=
 =?utf-8?B?aThZS2NYcXpUTTNoRzVidkI1cEpXMC90N1FoVEI0ME1UWEJaUXR2aVpjR2VI?=
 =?utf-8?B?aUh0YWVkWWhFNVV4d0ROU0YzcEVvOTJnMzkxL1B6OEZJd2F0dEZ6UGsrQkRS?=
 =?utf-8?B?TCtRN09ZVmZwVDU3SVhvTnFZZjVVTFRRbVU2NTU5ajViWlRVVEdvKys4a3dj?=
 =?utf-8?B?YVRMZmxjWHdQV1BxWTZFUXRudVlmOWo0N0g4OERjTnBHTHAyMkhJMTZOQ1h0?=
 =?utf-8?B?dSszb2grdmF6K0VLMzNmaHEzT3FIbHA2N2huaXlIM0hja1Zuc3dvTkY3ZFNw?=
 =?utf-8?B?U2lRYnJReWFaN29wd29jeDJoeUVKVllCa0pZNjk4OW52MnRaSUsxalc5bEYx?=
 =?utf-8?B?M0Y0clNVdi9JMUxmUklsR1ByMXNRQ0R4cmV4NzFDbTREQWV1a0VWdDRtV2tN?=
 =?utf-8?B?RjR6OEFYYzJSTmExQWJheEJ6Z0l1VnYzNDhFRWE5R2NjL3pIMFlOR0NSbUV1?=
 =?utf-8?B?Y3d2TlNDNzNJM0JzUUhEdFVnblJMcTBmY2ExcVNLaUhWM2JhUEtKZkpjb3hl?=
 =?utf-8?B?aWF1VnRIaVZtRzYvMVAvc0lEckRSbzRsaVB4UG9FM2xtcGQ0SGU2eEpIbEhR?=
 =?utf-8?B?MDFOYk1yVDFXVUhubU9Qa1JKQjVIZTVoNXE5MU9BRE9RVmZEMEpyZHRwcHBr?=
 =?utf-8?B?Nk1sZWJ0eE1wQktsb2FCak1NZkJDbDJNU1Y2OWExZG5YbExFZ2hWYkNOZjZo?=
 =?utf-8?B?OVdWYWZQN1RZVk1mSHBlZWJ1VlhYUUI1YW5xVjNodW9qRUtzSWJwT0cwZ2FZ?=
 =?utf-8?B?SWI4NnJtL1RTVHQzZmJGdXE0V0YwOHBwZ21qZ2JHRWNXcHNPcTIwZFlOWFJw?=
 =?utf-8?B?aHJMRm1FRy96Z0VSK2xXeXUwenZWYmNGUUdyMzVWMCs2SEtzMTFCSXIyN29C?=
 =?utf-8?B?cGNzRjd1azVXTHhaNnBrSzVPRmFpa3I1OW5YMTNxWmlNdnpzR3RnZERyY3c1?=
 =?utf-8?B?NEhNa2RNeHFxVi93dW9EbWttVHJFK1pBdWRiR05GUnZOSVRjZjM3SVdCZDRO?=
 =?utf-8?B?NzlYYzB4U3l3Zzh4VTRGOXVjb05YcVhSRDAzQUMzSmpOUTh4SW1PZVozSEgw?=
 =?utf-8?B?V2NYZU1Wbk1leE1PM0xKM0wxZHJBZ1k5eW5BVUNEclB2R2NCNUM0YUMyUlZy?=
 =?utf-8?B?ZFNyM0lXSWc3K3IwL1FNblJ5UzAzWE40Nkd3ei9YL1BsdlRVekVTRFM3Zk9y?=
 =?utf-8?B?aVQ3ZmxEaHpHdDE4YzUrKzVnWGFZc3M0WDZmdjY1WXdvdzJQSUhKbXUzTTE5?=
 =?utf-8?B?VlJDUVE0RHQ5b2N2VHI5cytVb0dHbW9Fb09aMXJkVDJ3U0p1VkQvNzl5TUhS?=
 =?utf-8?B?aHU4Y3VRWWJzNjV4R2pxejFtWFJtUzdHd2U0V1Z6OFN1VWJEN3I0ck1ZSm1I?=
 =?utf-8?B?a21kMW4ydDR0SHhuc21xcXU2TUtvNGt2V2ZXTzRaZ216Q3BGR2FCa1RTQVFF?=
 =?utf-8?Q?dt9XNVFon1LBvrCPtCPbBDtgtk730OMC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFR2R1N2RVhmejZCZDE4MW1iK3NQaGlJRGFSTHZ5bG5aeGtkRXFqcGJ4UkJw?=
 =?utf-8?B?S1NlRG1MVGZrcTNhdkYwNStkQlQxYWI2YzBONThwR0t6VjVvNFZ0bFdxQW95?=
 =?utf-8?B?YnpDMVdrKzgxTVJOTjJPT09WemwzYXpFdjFSbDZDb0lrWWZqbHBqdU1iVkNE?=
 =?utf-8?B?V2JLaU4wWFZmSjc4UHZDUlpmSXluQmlQajJZRjUvVXdVM3RMV2hVdEY3R2hl?=
 =?utf-8?B?S2lqTDd0NUZsQVJkSzhleTBsMS9YM1NwRWpEZVRoQ01URWZLWlZvb0FwS0E0?=
 =?utf-8?B?WkZQcVB4dEtIY1kwTmMxMnA0UXBmdVFsZXVsUFlQeTBNbWdNUWcyQUNSb3kw?=
 =?utf-8?B?azVRWXVnR3VaaFpsNUtiaEc0eS9zeXp6ejdZeWJmZEZMZ3JuTWNnMUZzNWNJ?=
 =?utf-8?B?K1NGT3htRWxMRjZIMXgzc1dra0RrYmk3MDZicW9NSWtFWmxVNWFqclplL3pq?=
 =?utf-8?B?WXVTZHIyN3N5NFArb3R1TEczYXUwRHNzS0ZkNjFqN1NDcDJqcFNvalByQVdl?=
 =?utf-8?B?N1BZQ0V1SkJwVlZGMmh3TUxsNDhMZGtndm9nVGs1OWphMHpqR0g0V2E2czNJ?=
 =?utf-8?B?Nmh5eWdqdG82Y0p3dnhyci95WlhLMWdnQmluOFcwcWRjTzE4dHhkdllud01q?=
 =?utf-8?B?MDRlSk1McjZRWlgvNmxxUFFLUjhqdmVhVHZYbmw5ZTlzUFJiS0ZPeXZoaGxG?=
 =?utf-8?B?VHcyeGZWT3J6UlNNU2N5N1lLaEhkMFlJdkRtN090Wkx4dW1zYW1qMXBDTU4z?=
 =?utf-8?B?UENmWGhKRFRXMEQ3b1dldFo3eXpNUkVqblpMSUxZZlZPancybU41Z2N2bC9V?=
 =?utf-8?B?dlJod1VCVTZiOWtwN3Z5ckRvRlh2OXdubmlTRXV5TEc3WlozMlU5M3I3TWRm?=
 =?utf-8?B?WVhXbGtKVWNmL3dvVVdIczRsU041UVo1UjQ1aURuVVlibWlraUd4d25CUDJm?=
 =?utf-8?B?cnBjVWhkZk1KTHdPZ1ZnU3ZpZWpkNlptSlFUaFRnbWF0aWFsVXJKYVpBUTlJ?=
 =?utf-8?B?OFRHbEd1ZHRBZkJWempCNU8wc1IwK0hPZlJDNUZXQVVRblhiNkptNFhJRmNa?=
 =?utf-8?B?MXhlZGI4U0U1OXBwKy9nODF6OTJsczRXb3VINFlELzNhVVFEbWtJdlpDNEJX?=
 =?utf-8?B?dFVuZ0I0bHJyR3RzTGZMelVoTExKMXZkTXNaQkswNkV2ai8yTnA1czJwaVg0?=
 =?utf-8?B?VlJvVHVEa0JjUDdQcG1ocUtyRGlyVTNxdUU3RGdQYXI3VEd6Wi83NjVrTWIw?=
 =?utf-8?B?S0hTaE00cUIwQ3JWbGxVK2swNW5FNWxYc2p5T3Z0ME16RmJQNS9NVEFvMHk5?=
 =?utf-8?B?UGxDVDVRa0YzS0syUTZZbENLVFFQaFR1QUlpZWduVjJLbWRPS1JkUkRDVGc1?=
 =?utf-8?B?Y2l2NnJDWTVLS3JDbWZuZTB5WDUzMXAyeW1jN0VueGZTKzdsc1RYMUI4Snl2?=
 =?utf-8?B?S1RTVjFBK1pvMWlpczFvWHlKRUVtT2kxK3NQeUptbE1zSEVEa25qZE91UW9D?=
 =?utf-8?B?MW0zTzNBVVNhUzVPcDRFakZLVGQ2Um42TVFVaVlCeDZRTWFYcDlDS3NTMW1J?=
 =?utf-8?B?SGpTVi8xQ2xVSnRDRDE0a1JsQ2dzU2VkWjFTVTZsWklXQVQyU3BUd2VEbC9N?=
 =?utf-8?B?dGtDc0NwcWhBcms4N3dXSkN6NnpEWWVTZERUaCtzNHBmV0pPVE1aTWFpaERY?=
 =?utf-8?B?b3ZXUnFVTjZWa2Z6ZXA4Q3QxLzFhUGxXYXI5dGxxUGora2cwL1VMblM4c29k?=
 =?utf-8?B?aGdZTmdWcll4ZVh0ek9GRG5ZTXMxRlBNYU5EaWhvaHpvSCtWYyt0SG9zOHQ0?=
 =?utf-8?B?cW5qaHhEc3d6VFpyU3NmL0Z0YXZ2QTdEMWVaTmM2UENmRk9ydUM1bG1Sc2lC?=
 =?utf-8?B?UksrYjk5VWEvZmdtcFZqY1hvU0lwcVliMmI5ZEo3dlRLRWFtV3JDL1R3V1Y2?=
 =?utf-8?B?a2RVK1pXbTA3RmkxZlFGbGxObEdPak1XeUszalNvaFZyOEUrZmdrdS9nUktG?=
 =?utf-8?B?NElkeVB1M2NxdUpxMHlGalZzVVJpbVdUdzhiK2RybHp1dnduVExUd0VZTDBG?=
 =?utf-8?B?QUVJT2RWSDluMkt1NXVwS0liU20zRVV4SjFFRmZLcmhjcUFDeHkzekJUaktZ?=
 =?utf-8?B?REpaZVRVUlRUZDd1RlZXaWJhYm0rc1lpN2RqcGNMTmtPd2xreVQrU0NsNnVP?=
 =?utf-8?B?ZUtGVjVXZnBqbVNYM3ovQSs0M01ZcjYrMGxId2RXejRmVllMRXdTTUVaT1pq?=
 =?utf-8?B?WDB3R1cwYXFSODhOd1NIWDlNSTI0SEFPMExndElPWVljZG1saVBQcnZ4S1dB?=
 =?utf-8?B?TTBOV1FwNGpBdG1GN2pOMGhqL2dJd1IyNzhFb0ltZkplWUxLeUNMZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 870e4808-fa71-41ce-2582-08de4e2cbd7b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 20:38:39.9809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YEf0+npxrDTdnTon4Ox9nkcA+IjRVnaxUzGPLDO9Hyo5Nt2chln1DAntBflcE/Jb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4436
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F2E13100009
X-Stat-Signature: kjbgdeeaxyiux7aqd91uduw1onot7er9
X-Rspam-User: 
X-HE-Tag: 1767818324-977668
X-HE-Meta: U2FsdGVkX19q+qbXO14l4HTc3zQAaBsOq3vMFZqvSunINCDSE1X8ozj4uqjJhtwnHDjT7fUZjJsfoSFX1JtFlPreXG7o8L2Id1Tpg/xBSDZjOl6b++BrkELFFVBZbTuzVIDdyT/Q6DcebQTzgpU4aHDoYT5ubgQWVSlBXKKaMD3tXNo+Oq4Xt8Un6brHQqiXkNLtB1dtxu8e6CFLydxEa8DV1AIEoTD4QxYwry8pdwxlMlvCB2kRNZUlBqDRRzT2ZMaJBQtmcxOxEhBJ++B3wuUET9XHdM6qTVLx3MDa3W+lk/xdszL/JaLAcW/wZUuIavOscu25O3kVIIi0pnfa/lDcYE8trYHq+tXLyOSm/wn2+j5hur8htqqSTIkJ4wKaEVOzFzOTzqxJkuOnL4vu+ELsbqBqIfP4gQ4WddIHwmBhOCq0VOX1mUxVdE3QrBwZ5ZajxjdnbTUKqu1gF3owNov+KUA8EWZIrvMUh9BDRlUrWN+leVgCwjTDv6YNgSscSrXdsTKvkZ+Cw9oCqkpQXwzo/iUtr9fl4B0pABIAeEXzKE07jesmPbV2WHzor0i91bGgLD8pmztyQDc78Gj+yBj4fGWWokFEU6fqHORyqJKK7dTCRUDQDkx5xoK6UmGPWJ1Dz5SXutxNyMs9pnVm9xUJjgX/2Cj0tRZ8I6P7sD2am4urcigZ6yVr9+2qsP8Geyfo9NN4vJLRn2wUyf3K7vBOlF3RApeHBAJUvKeq1VdCtPf8DN5Igep+Z7SzcNrPRJINvQ1er5PVprXUH/vehjksVMxK5IgQ/GaWVEyAZ2CtqI1TLxbSqe0pKfrDyIdNBgFTRYiDRM0tPdtgAli7NtBPgThOvHbbbu6nkmFtGxQVxjNJBOLg0jH4NC+Pbw1aF247lWKau/rLaSNKN2NwDrqsf7KLUyTQB5RnnEhGIoacNSs2AdZ29zK6i6tOY2Wi1DIYQ/dzutVYAVDDSEM
 0ZFPwDnj
 GsUjVjeD3nSXLvdGUGvwBZp2DcOTTzqMVujs6iLQExPNuob+3RvvY7VWeXK2hQeJbPSIcBBPHjELsXwpwF8fIm6LFPxyBuiGEpyyZ2yspL0Uip1Mx0zIv80RBPj4ImYmT5EQWm4Is/BXpzQBTK2fE9kZT4owGCJP+S2JZoxdxpSn7/s1iEHZfeQ1+OcO9zNYxzVmUfM/v6fS9Afc2VQvWFPkIhT+0vq4smYN1xNq70uPviywKAy5tq3MBFcivV4XO54zRCLcz48OULjGOuvgaYPUnQx+gVYaoxZ2n7/LsbeFls0k9RODUC3s5NK4txfEoNH+A8dU2Wy97lxVJTtGXy2SRhsaum7yOfuYcWISR0CPquLdIoxACqwjLrtKCaUfEWUEcxWFb0ekCwYrzPMD37RlxuxN0CCtVBWnudlnke4CfkWiy5GgZp2IuvUnxWGiae2ngxDNmWOQEMqCQmGwlNIvoHAP+z9z9ApiFz5e9fkryaRIH/Mi//qNU/dN7kVxK1U/f3HL2AIw1caqQ6TnZtWC+4K5LEBlW7+S/evw/OG435oSxEABxANHrV6FQ/a0o6mPfA12mJsFvHv6qIK5vh/7h7HvH2hPJ6lotuhoHW6uRMp1Hq9KcPKUnkZCVJbZMhDabT6GJ5uYY0nE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Jan 2026, at 15:20, Zi Yan wrote:

> +THP folks

+willy, since he commented in another thread.

>
> On 16 Dec 2025, at 15:10, Francois Dugast wrote:
>
>> From: Matthew Brost <matthew.brost@intel.com>
>>
>> Introduce migrate_device_split_page() to split a device page into
>> lower-order pages. Used when a folio allocated as higher-order is freed
>> and later reallocated at a smaller order by the driver memory manager.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: linux-mm@kvack.org
>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>> Signed-off-by: Francois Dugast <francois.dugast@intel.com>
>> ---
>>  include/linux/huge_mm.h |  3 +++
>>  include/linux/migrate.h |  1 +
>>  mm/huge_memory.c        |  6 ++---
>>  mm/migrate_device.c     | 49 +++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 56 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index a4d9f964dfde..6ad8f359bc0d 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -374,6 +374,9 @@ int __split_huge_page_to_list_to_order(struct page *=
page, struct list_head *list
>>  int folio_split_unmapped(struct folio *folio, unsigned int new_order);
>>  unsigned int min_order_for_split(struct folio *folio);
>>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>> +int __split_unmapped_folio(struct folio *folio, int new_order,
>> +			   struct page *split_at, struct xa_state *xas,
>> +			   struct address_space *mapping, enum split_type split_type);
>>  int folio_check_splittable(struct folio *folio, unsigned int new_order,
>>  			   enum split_type split_type);
>>  int folio_split(struct folio *folio, unsigned int new_order, struct pag=
e *page,
>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>> index 26ca00c325d9..ec65e4fd5f88 100644
>> --- a/include/linux/migrate.h
>> +++ b/include/linux/migrate.h
>> @@ -192,6 +192,7 @@ void migrate_device_pages(unsigned long *src_pfns, u=
nsigned long *dst_pfns,
>>  			unsigned long npages);
>>  void migrate_device_finalize(unsigned long *src_pfns,
>>  			unsigned long *dst_pfns, unsigned long npages);
>> +int migrate_device_split_page(struct page *page);
>>
>>  #endif /* CONFIG_MIGRATION */
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 40cf59301c21..7ded35a3ecec 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3621,9 +3621,9 @@ static void __split_folio_to_order(struct folio *f=
olio, int old_order,
>>   * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio =
might be
>>   * split but not to @new_order, the caller needs to check)
>>   */
>> -static int __split_unmapped_folio(struct folio *folio, int new_order,
>> -		struct page *split_at, struct xa_state *xas,
>> -		struct address_space *mapping, enum split_type split_type)
>> +int __split_unmapped_folio(struct folio *folio, int new_order,
>> +			   struct page *split_at, struct xa_state *xas,
>> +			   struct address_space *mapping, enum split_type split_type)
>>  {
>>  	const bool is_anon =3D folio_test_anon(folio);
>>  	int old_order =3D folio_order(folio);
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 23379663b1e1..eb0f0e938947 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -775,6 +775,49 @@ int migrate_vma_setup(struct migrate_vma *args)
>>  EXPORT_SYMBOL(migrate_vma_setup);
>>
>>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>> +/**
>> + * migrate_device_split_page() - Split device page
>> + * @page: Device page to split
>> + *
>> + * Splits a device page into smaller pages. Typically called when reall=
ocating a
>> + * folio to a smaller size. Inherently racy=E2=80=94only safe if the ca=
ller ensures
>> + * mutual exclusion within the page's folio (i.e., no other threads are=
 using
>> + * pages within the folio). Expected to be called a free device page an=
d
>> + * restores all split out pages to a free state.
>> + */

Do you mind explaining why __split_unmapped_folio() is needed for a free de=
vice
page? A free page is not supposed to be a large folio, at least from a core
MM point of view. __split_unmapped_folio() is intended to work on large fol=
ios
(or compound pages), even if the input folio has refcount =3D=3D 0 (because=
 it is
frozen).

>> +int migrate_device_split_page(struct page *page)
>> +{
>> +	struct folio *folio =3D page_folio(page);
>> +	struct dev_pagemap *pgmap =3D folio->pgmap;
>> +	struct page *unlock_page =3D folio_page(folio, 0);
>> +	unsigned int order =3D folio_order(folio), i;
>> +	int ret =3D 0;
>> +
>> +	VM_BUG_ON_FOLIO(!order, folio);
>> +	VM_BUG_ON_FOLIO(!folio_is_device_private(folio), folio);
>> +	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);

Please use VM_WARN_ON_FOLIO() instead to catch errors. There is no need to =
crash
the kernel

>> +
>> +	folio_lock(folio);
>> +
>> +	ret =3D __split_unmapped_folio(folio, 0, page, NULL, NULL, SPLIT_TYPE_=
UNIFORM);
>> +	if (ret) {
>> +	       /*
>> +		* We can't fail here unless the caller doesn't know what they
>> +		* are doing.
>> +		*/
>> +		VM_BUG_ON_FOLIO(ret, folio);

Same here.

>> +
>> +		return ret;
>> +	}
>> +
>> +	for (i =3D 0; i < 0x1 << order; ++i, ++unlock_page) {
>> +		page_folio(unlock_page)->pgmap =3D pgmap;
>> +		folio_unlock(page_folio(unlock_page));
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  /**
>>   * migrate_vma_insert_huge_pmd_page: Insert a huge folio into @migrate-=
>vma->vm_mm
>>   * at @addr. folio is already allocated as a part of the migration proc=
ess with
>> @@ -927,6 +970,11 @@ static int migrate_vma_split_unmapped_folio(struct =
migrate_vma *migrate,
>>  	return ret;
>>  }
>>  #else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
>> +int migrate_device_split_page(struct page *page)
>> +{
>> +	return 0;
>> +}
>> +
>>  static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate=
,
>>  					 unsigned long addr,
>>  					 struct page *page,
>> @@ -943,6 +991,7 @@ static int migrate_vma_split_unmapped_folio(struct m=
igrate_vma *migrate,
>>  	return 0;
>>  }
>>  #endif
>> +EXPORT_SYMBOL(migrate_device_split_page);
>>
>>  static unsigned long migrate_vma_nr_pages(unsigned long *src)
>>  {
>> --=20
>> 2.43.0
>
>
> Best Regards,
> Yan, Zi


Best Regards,
Yan, Zi

