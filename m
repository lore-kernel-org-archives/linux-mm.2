Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41FC3CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 06:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B95B8E000E; Wed,  1 Oct 2025 02:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992628E0002; Wed,  1 Oct 2025 02:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858AA8E000E; Wed,  1 Oct 2025 02:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70D668E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 02:59:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 152A0BC367
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:59:36 +0000 (UTC)
X-FDA: 83948644752.30.9295ED6
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012042.outbound.protection.outlook.com [40.93.195.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 33DED1C0004
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:59:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Ps/MtzGh";
	spf=pass (imf21.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.195.42 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759301973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DsmfsT5rShSAsH7ZfHbs/HULcRgsXc5ehSBKLkKjo7w=;
	b=63oMRIYes8gDgfH8DOFXDLVf1u7QHyCmW6yzjU5GVFLHaquCmO2MqHNYNK6xXbqV/bBBaz
	+dODZC03PXwmhxPXVJk99yhjNbb00zGsbisl3CFsvmm3I7jnRTyd3BPipjKnLOxxMUEll6
	nai3nY1Y9qWZRKi9+sAEiRz5pUyY5bg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Ps/MtzGh";
	spf=pass (imf21.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.195.42 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759301973; a=rsa-sha256;
	cv=pass;
	b=wFsfkDzbAi5Cr7qpvW8mxen9iQ0c8pz+I7c4WNrarZB/3YDt6CVCP/J37L5xLRKPISRhsV
	n7GLALwZrNdT4J4hrBVLar5Jt/qsetFIAGlkcO7OfWGH4iXLRgPAfAxBg0Dnk5/UuUWcIt
	3QBKBhPNc1dFfgiaARbCuvkQQG3ntK4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=viiWR72s8KauAvJZFJ4CNKu3SftI3kZHDeRiwl8yWhAQGqOng+4dBs1OMmbptuzUD+xQT9Y2ipJ2zAtaZKuL1L9Fo0eaiZkFCTrrKZ2SFUYvFFRhUbXA45bkfkHLXIPdYZsChUlhVQAW6ziThPBve4cxL4ghQnjzzGMOlihPF7KJx3Jj+fPul16lJ5uIP//gfGM2JPjfUxO/9icS+chZpd3eogFBjD2JmybAUSNPx7QsPuXC/LACOeo2f8lytDPl7YtWCFeo6Xsp3rXafCyDuSq3e8WkIdsZkKeTu3BE40d1Cc74I9tRhRBVBnJuZj4jZeEtTbv/NPEQvrVSmpbOrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DsmfsT5rShSAsH7ZfHbs/HULcRgsXc5ehSBKLkKjo7w=;
 b=RWFwzezzUdteVepkEA4FC9YnhHiFNX7KCbC44IdTJblQiICvGbB+1PHBEhu4hVUlMtzdmt07tzA+w6RTnKnMZaP91gZoKu+2n8bEw3pO37k7OIde7PB0bH4msm7woq1FA/XtTsnj9FXeIOYAAdKIJaYMnrX23hpnlcmDTzWG0RtPecTu6hSHaMhgxnJ3XoFgWrGRRVmy/MbwELLQLxC9oDZFLc0iQ/AGKXTVet0439m0fEhGhHc/X1XFuLLbvXBW8672peLWOgnEgxqOOTrWgEXXKNDI1RReLfKkcZrA5BEO6myMkTIuneVK8AQmNlrrFDLP4p46V4f3BpXu5FCFJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsmfsT5rShSAsH7ZfHbs/HULcRgsXc5ehSBKLkKjo7w=;
 b=Ps/MtzGhGPA3WQjmF7PALPbFP2SxVtAftVZThi46oDmYPKtVBSgbUKCbmsahrvaABH5Xp2ahkA1se8Z8uwvMuRp2DMz3Ydf8t1ed5vRDcu0lTRQl6NGqfjd5w4BB+OyR0OjbbzJmA/X7cTBBWfXGgkL7Y16EYpaT+5ZeGmobdBvy261MBaw16ULtUS3FN4gqKCL8LnNmOcY/y4IcM5qnUNIABcekVo1Ck2EC9CIcK/dIqRc+G/IwKXkDaiAI7spOgMUBxi4vzBsGb28vj1gPfSMLK1rrW46sD4JKGvJRTkB7rilddxOZo3+dAAGlltZGKTa2gDgGf5okspSDU+0VmA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by BL1PR12MB5779.namprd12.prod.outlook.com (2603:10b6:208:392::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 06:58:19 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9160.015; Wed, 1 Oct 2025
 06:58:19 +0000
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
Subject: [v7 05/16] mm/huge_memory: implement device-private THP splitting
Date: Wed,  1 Oct 2025 16:56:56 +1000
Message-ID: <20251001065707.920170-6-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001065707.920170-1-balbirs@nvidia.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0104.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::19) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|BL1PR12MB5779:EE_
X-MS-Office365-Filtering-Correlation-Id: f9fdf3ca-d5db-4326-cded-08de00b7e748
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RGhUakx4eDFQc2o2SElWYS9WQUdOVzRGSHlpQUl6NUtzaEpOL0dzVGgraStP?=
 =?utf-8?B?dlE4TlJyVTlFODVpYmVJcUVDUlpQcFh2R0lnejBCM0RGL2hqYlZSVHgrSXhq?=
 =?utf-8?B?OWFTMWhFT1M4enNSa3pjOGszQUdjbCtOMmVLWUJaL1VVNC9WNUhGV0F5SG5i?=
 =?utf-8?B?aStBOWFxamU1bWJ1cVY3TTJsU21ON3VNbUx1QTYzRU9LbWdRd3BpMjJhT0E4?=
 =?utf-8?B?bXgrS1BSTWRhazFvVC93eGR4N1k4alI4Y2I4TVZldGpaa0sxbHZQOFB4UmhP?=
 =?utf-8?B?bWJwZk45cXBta1RWd0UvaE40TmhMbmJ1U3N6YkJlS2NBdU5UYTV2Q1FhQWk0?=
 =?utf-8?B?MDNPT1hqMlBpOGRDclQxL1ljUlpxNTFNQjhqbnhiR0xOMWE4cXBabTFwd1hr?=
 =?utf-8?B?MUdybUV2a3VKc1RTSmNXZG9VU3NOTFlOb1I0bXBCeXdoZmZtV3FaVStSL1pz?=
 =?utf-8?B?azM5blZsOTdqWW5hZjc5K3U3dm1MbTVqcE54MjFFTmF3Q2QwRHQwTWNydVFt?=
 =?utf-8?B?SlNOUWtIVGV0d3doazZHaFpGZnlhTEYyS2VOMU5WMW1iMFJzS3RZSnQ3VkVR?=
 =?utf-8?B?ZnpCWWhHNHhDM0IzWGRZeHBLc0xrZmkxVkkxbWhzMUF6RndmR2xYUHphdUZF?=
 =?utf-8?B?YUR1M1NxMFFxWGJMbFZ0b0l0Rlo4NDBJVS8wNWN3UFV0Qy9sWTZER0tBbExZ?=
 =?utf-8?B?emxEV0lWL211MjY0VFAyOE1MUWNkTGVsYngrcmRKaVRpVENoTDdkUDY3YnJn?=
 =?utf-8?B?SERwcTdNczkyWW9oRVhHYTdoRnM4V1RRUGEydnRYYnhsTzF6dEpINkpsTGZn?=
 =?utf-8?B?QVVPWW9RN2ZMYi9idlN2S2YxQzY3VGtDdFoxUFRuK3hKUmd4UU5zbmZ2eHlH?=
 =?utf-8?B?TWtCcXRWSjgvT3hxWmR6TzUvUVNYb3RySFpnNGhGalh6akdzdE9GQnQxNTVZ?=
 =?utf-8?B?cG90RXRPTnlScGxsZU02b1dXU1ZHbGVxZmhMeUVOSnVyYURyREZLNkxzaFpz?=
 =?utf-8?B?Qko0OHU0ckE4U3pzRmxxcEhMbTJmUHd5MitKYzVsRXYrVUx3bFprV08yVEhp?=
 =?utf-8?B?eE1kTjcwSE9vY3BMM0VEU3dSNmlzUTNUVW5lNmJHQ2JqMkNUNHNPSzVCMHZG?=
 =?utf-8?B?MFQ4blVCNjlCVGlBdDZBU0F0dXRqcWhINnhiWjcxamNRdkt4L0owUUNSamJX?=
 =?utf-8?B?eS9HQk9YV2NZclVrNjN5SCtWM2FIUjFhYmZIc1V5dmhqMVAvbHpRS2tCK0V2?=
 =?utf-8?B?YkJDZ0JMcTZLNkFYTEdFdURyM3RHMHZSazgyNkJtQUpWalJGaittWERJR21x?=
 =?utf-8?B?M2JCMENjKzFjYjhOdkxLclhsV215RFZxajNjZUs5czlEQXpaZjVlME9TeDha?=
 =?utf-8?B?QnJxUXZvSnE5LzdnWUFwdmxsUzBvTUQwUEU4dEdXTWhRbC9mUHA3Uys1RGR4?=
 =?utf-8?B?UnRqM0ljTFRWUzVjTDMwVkJndG5DdVhCcWF1b2RPYVFrUUhPMkRBeUlEZGNt?=
 =?utf-8?B?aVd2Z0Ywd0pJdEJPdHIwZkJpOG5rM3BYZ3lTR1d4elZVYktJOWZVczErdEti?=
 =?utf-8?B?d2Y1em9EUnZ4MjJOTHc3NklEcUFROHBIeFE0Vk9tVTMyLy9DTlFReXdJb3NG?=
 =?utf-8?B?MG5yNEFzUTQzbS91RXU0SGd5SlNrTWFHTG5ubVY5dDlaVnRjOG45azVHMWpi?=
 =?utf-8?B?Znl1a2lrQ1NwMXUrZzdEa1pPTW12NVRORC9HZG1NYXBKWmhQenYrVHM1bURw?=
 =?utf-8?B?R2RybXpUWDZPVmljbmFDSHZuNUVjaEgwOThWejBZUEZpd1ZYYUw3VDlTTHdK?=
 =?utf-8?B?ak42NU1YUjIwd0s4b29Dc3d6SG5ReDVQdS9rR2VRWm0za2pLQXpidUgwbjhT?=
 =?utf-8?B?ZkRwSkZoUm5tN1M5V3A4SEk3TlAvT2tacVk1UHZ6b0JhT2VxQjVYWWVwRGUx?=
 =?utf-8?Q?zTb2nyiVKyhlVk88jfe2MuERQulS8JVN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkVEbFhOdDZGRVg2TTlNeFRLTjJwWWF6cVhqcldBV3hUMHB6bGlqK2dpV3BC?=
 =?utf-8?B?UEVIMGxVbEV4MkNqY1hjUmlqNXoxS2JTZjJNOStvZ09pdXlQVFJEbjMrRXpJ?=
 =?utf-8?B?YmNMSHg0QVF3ZlRBRkRrMG1KQnhRK3VwaTdoTUdUOWxZdFZnUEY5czJoRUtJ?=
 =?utf-8?B?RFFQbnhzUGhMNURiWW5aOHNJMDVSYVV0U3dFdzBDeHRTOGI1YnJTdUhmZXdK?=
 =?utf-8?B?WjJSVWxzQ0o0VUQwS0orMG1kclR4bHZQbFRtVG1UYkMxWE1MVlh4RjdCelVV?=
 =?utf-8?B?S1hPcE1nTm0rcENjSmdoUXlvL0pGTCtxakZKTXhYcWtHbTAzMmFPaEh3QW1Q?=
 =?utf-8?B?dlhtelpTODlQRjdoUkFIOTlBWmFiSS84b2lhaVhsaDkyQ3RZNTQ5cmZlY0dI?=
 =?utf-8?B?QmF2OFBJd090TWg1blBBRHBrSDIwSzBjc3JyUGR4WlJmbEgyeFF0U1ExTEox?=
 =?utf-8?B?d201T0VpV3dYd3pBWFcraUltb0Zyb0k4TDhqakR3OHAyR01ZZ1kzelJQNkVR?=
 =?utf-8?B?RGswSXhWWHk5aG9reWhWN3E5K2dYOTRVV2U5bytsTHhQYVU3SGo0UG1ndkxi?=
 =?utf-8?B?ekNCU3lQcFBrUGMyWlIzVTdRSjlsa0svelFOS3pGYVNqNGRLenJkbUthcERv?=
 =?utf-8?B?NzhoNFgrL3J6RnRrdWhDVlh5Sk11SE9IKzRPY2FMNTV6cUNvbUdhY09xOGtV?=
 =?utf-8?B?Yjg1QTYxNi9rYnh3azNjQmJWRUczSlQxVTJQbkdLMlduUjRRUWpzZHRpYWk1?=
 =?utf-8?B?T2N1dVdYRjZUTWVid1pMMzVFQ2NyYTcwVVQvczQ4Wk1kUjYyYjhibEFvaW1Y?=
 =?utf-8?B?MmdGanZsRlYxYzh6M0MyTkJxZjZqVkNRckQ4dmQ5d0o3WUEyMkdva0M5dWpP?=
 =?utf-8?B?VFBCMjV6TXEyTjFyREc2d3Q2bVZIbGhnb2VlZy9kTEx5UVVmcG0rbHdNT2dh?=
 =?utf-8?B?V0d3MXJpOEVSMy9zVWExRU9wQ3JnUUw2ZE5TNlloYjJiVXIrTWlENTV3dzh6?=
 =?utf-8?B?MStWZmxJUkZBMktQcGhLNnhPaE5hbGhGNDRQSEsrVHpoQ1BFQWVsSHVFaVJ3?=
 =?utf-8?B?S01DSFJ2c1BQSTl4N25DQlI2SVF1UXozWTZyNVVtU1E2QzBUK2VQK0pUTTI4?=
 =?utf-8?B?cHhiQXFEalcxTUxyRXhCNzhINTRpZzNyaXNnS2pyZU1CMEJjVnljVFhodEcr?=
 =?utf-8?B?MjJ3aFVtaG1oOG5pbHREa0pQWW1wTG8zRjZaeHJ2UHhPVzBsdXZqa3ZvTEkw?=
 =?utf-8?B?N3lXV05HMzU3WkM5VnNXNGNua1I2VjVZZlVHUlpHcHNJaUwrOGNXc1BmaG5R?=
 =?utf-8?B?MVB5YUsyOU9IT3hYbS9pNnFhemdqNGI5T1RDRXBoREE3QldMbERKQUhqM2xk?=
 =?utf-8?B?SURudjVFUlQ0ZEdKdmJJSmEvSkVlRjVGR1FRSUNtT0gvcnhCT0theFlpTEZF?=
 =?utf-8?B?aUFxVUpHWUhoRFJWNFRwZUZuNUlnRlpTWi91NFJvOU9nNnFNaFl6Z3VVeXdm?=
 =?utf-8?B?TmIrb0JqLzB0NU1XS0ZtOUpiUGk1SjFhbWpya3F5bXVlaEhJQldwNGlJQXB5?=
 =?utf-8?B?UzdKRGxpcW9IT1hSUDZWTk92SDROeVRQOG5QTmVtMCtXdE02TWR6QVJwOWlk?=
 =?utf-8?B?dzBjOGxGTWttQXlnemc3TVVNSmpYY1VSU3R3VVdtOHd5WEMyekx5QzRqdno2?=
 =?utf-8?B?UFJkMFNUZ1kzdzNyd0hJcThUQXRFRFlGMVhNZVp4M01xWkdEVEhEU0UvTkpN?=
 =?utf-8?B?d0V1UUdHSWNRT2hGT2J6THkyZy9SNm44TW9WVVVRcmQva25XaWEvYUZucUN2?=
 =?utf-8?B?N0ZYVDFDbDBidmdSbURFVDJPNU8vcGQvazZvYmhuWjdyWnArSWQvbjhnemY4?=
 =?utf-8?B?dDVvRDE0ckVVaTZ5R2dRU1htN1ErK3o0RjRHQ1Y3dkJPVG56MUhuQm1DaitE?=
 =?utf-8?B?Y0Nzb2M5ODFCWlVVYUE3UWtMR1dtb2ZJVjMxcDRmd2JOZElJeFhEb25BVjJn?=
 =?utf-8?B?SnhLcDF6TzNDRTBKRFI5bzIvbEdRVWg3ajBaNzI0TFY5Mk5jOFVGbXN0a0px?=
 =?utf-8?B?QXhOczdkR3RyaExHazFYQkhWanFpTkticVVUTVc3cHN1dy8yUkVwYUJSWlBO?=
 =?utf-8?B?NGxIWGVFSjJRaG8rWWlNelRWZHdlcWdHUHFPcmhmdEZ6TVkxbTlBZU1Nd1VS?=
 =?utf-8?B?TXc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9fdf3ca-d5db-4326-cded-08de00b7e748
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 06:58:19.7652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3DN1sH9LEONKuW9QCDoqDVKfA2DKWuDdIxInNAeXbw+h9TMfRN8kOFhLv20yK0vmp+MBfGoWEMMerwmt8uLO7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5779
X-Stat-Signature: rakq741s8yh5agqkbagh1x6mioz3bhea
X-Rspam-User: 
X-Rspamd-Queue-Id: 33DED1C0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1759301972-325322
X-HE-Meta: U2FsdGVkX18aXPqGzVPdQ3fadEmiTVljoD1k2Qj2w2mi5F0P7eAvQG8TFBA3CodcHNVVLhk8uben3DqcZxHFGkbNTt6Ho/e9aeMJMnVEd08erTiZttruPrSMPGS6E3nBvfssHQFLzWxgdbWWERrc0hbkdkn5jUgEr2K/SHzMkgMQaBvPPhU4CuF6PHuGlZ+/nQXAh5Df3dkx23fyl0P83O8UnKoOfKpoAAuRyjcnpy4H95CZMkvW6C0OS3+1TrvjH7UvB2DM6wrRa9zhJ0E59hPPHNkj0pr7kQr9kSXu3U87U5QXOqb9IeMeMDSpkWUjqnrk4qMD0dTVTU06/owg8Pvvzk7MZY6SZVnNbdCen8u6btuWrMOO9lEWJGr3PtiDzd+z/+w75sywXU+wxmZWa8AjotBAgbuEcCt6twSMnTNE/nWtxg04Bduvr44sgyQ+2cfUG6ZMgkKJ93yA6jS6wkvEjgOTd9BActlTfKimG+g/7ZXtcFB/Sbw7PcPUQqhm6lhPasiIYhlOktv/5mrFKNx22gkxwhamMO2s1IIlM45c/goF5jMpe++8IJb9YFHZl9gjnWOf7IzgODJgVdq8SpsGO21caoB5ud8S+FgqDHF/lkMcAB0G7c8GQk1bFy3UEvUWh/uTyVUQ3fwrx3JSURkpdF21+ftmfL3pzZKuD0Tvht7VIZwbaoVMTKWxRR1Bcqmj3kY0tCWGOh7zaA8NQkCCQin4zc3p+UMSuImo6Px6fgZEqcAws1KRAdhrTAGE3yqodlWoEYATKw1PoFWt9ShLXiGckM6orMx6m9CE5aqDbHiCUPPBXVRydK3U4zJHJTwpHAPpnE+2J5CKC/BvPs0Jz1TnwphterraCs9VKx5Ww744NLmFIDhJsStBu3H3v53PPEVHcdmuyJLjiw0KDSMGxWwpau1p0tag/RZ9lkogkSTwD1eiXxksi4eQ0960ljrSO86uViuZG8fRusq
 4Ltc3RAa
 6WgvIXftbKgNKTZ8ZWQDKCawOO28BkV3deE3J0fkJONmQQcQVa1I/ZhJL4s6O6i2vHVi/NIEs7ZVRMFqLox6FRK+gNh0CQALBxkPcm2PQKtJlfWEaygmT6UO33gTgFQMzYTM2Hi70vAL3TiJKtH+vihKFe8uB4XBeGrVbbnxWV7JBruXAYwjuiZ6/1g6nlT4LDElInsMfUTBnXA26sMXeCJjA5PZhTn6ZNdeVv0B46yRHAVlXtBuFBZr85B+pWObZliQuKIDvWHtCjvs6HdWlyRiEKpmjzhfomxY2e9BbTqPSldSk8HPhvuZ/ywR0iUo7+DryI/+hvAIit9OqmN4Pok4GwrkZIKSohwVhfOzw9sCJo4zCogAmc8IAtD93FCy/I0RhOfTh1FSkzZAD3bBt2ZiWxwbgg9HVmQFUOVpTjCgz05K9Ier8gvynyObCY7g0j/B8b23M1EiCbQJNLcDaVuM0XbauQYbi0ADHniohUovnVlvO0efMj8tWvYC0nKu316S/kPEKb8X37iH9CV2UkI2om8hTfkvB1+GqahCpxT9D+mz2vJ6G1HX6gksPZ70flfGw55pxmcOAapa6R2Vde+do+wll+gYmN4TDxqKMzH5K8FtqvRFZzyufTbGu/O/gN4HUABS1gFo7Ep4/WgOWnCo91cQ5QwfVNjn4jy4Oq4zoI778oUxihjsvFvsOOAEBieB4tgrgJYdDcVfbAwPw4t9IpBD0LvNu/US6QVa+aBzT87WVO57FuexYQR6Js2pAcDAMrqQAUcSqccR2to+rCZxD4aH5Gl6s5F2Rl/QL2ka6H9oWYXJM5B0pGqmCkYCqQYDZN7qDp7NljRtJx1kJDNF3IdQXAZgstrr79KCb8/Muk2/DXq8z6RKgUnYm7YFci8z1ocbyvGMz2TkN34l+BerQs15Ln+OJBXPmCqOiyX3lWkbkZMUOsJWuh3DrC/sEhjQWyAhdDZLvKY/LNjX+I0aLfooV
 fECqcZh5
 2kXWFG12bnInKeaYIcpSti3T6OZSx3r8lGdxLczR1bXtJPdSwxitqqTO0wQCi8JdZXar3knalOTvlTbMTDvsY6ZUapGJJ89B60sXxnZF0ATJmv75WH8Dd+d/OoBaQvKVT+chKahtG20m5AQM78k9aQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for splitting device-private THP folios, enabling fallback
to smaller page sizes when large page allocation or migration fails.

Key changes:
- split_huge_pmd(): Handle device-private PMD entries during splitting
- Preserve RMAP_EXCLUSIVE semantics for anonymous exclusive folios
- Skip RMP_USE_SHARED_ZEROPAGE for device-private entries as they
  don't support shared zero page semantics

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
 mm/huge_memory.c | 87 +++++++++++++++++++++++++++++++++++++++++-------
 mm/migrate.c     |  1 +
 2 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 483b8341ce22..05c68f5b5fe3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2872,16 +2872,18 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	struct page *page;
 	pgtable_t pgtable;
 	pmd_t old_pmd, _pmd;
-	bool young, write, soft_dirty, pmd_migration = false, uffd_wp = false;
+	bool soft_dirty, uffd_wp = false, young = false, write = false;
 	bool anon_exclusive = false, dirty = false;
 	unsigned long addr;
 	pte_t *pte;
 	int i;
+	swp_entry_t entry;
 
 	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
-	VM_BUG_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd));
+
+	VM_WARN_ON(!is_pmd_non_present_folio_entry(*pmd) && !pmd_trans_huge(*pmd));
 
 	count_vm_event(THP_SPLIT_PMD);
 
@@ -2929,20 +2931,51 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return __split_huge_zero_page_pmd(vma, haddr, pmd);
 	}
 
-	pmd_migration = is_pmd_migration_entry(*pmd);
-	if (unlikely(pmd_migration)) {
-		swp_entry_t entry;
 
+	if (is_pmd_migration_entry(*pmd)) {
 		old_pmd = *pmd;
 		entry = pmd_to_swp_entry(old_pmd);
 		page = pfn_swap_entry_to_page(entry);
+		folio = page_folio(page);
+
+		soft_dirty = pmd_swp_soft_dirty(old_pmd);
+		uffd_wp = pmd_swp_uffd_wp(old_pmd);
+
 		write = is_writable_migration_entry(entry);
 		if (PageAnon(page))
 			anon_exclusive = is_readable_exclusive_migration_entry(entry);
 		young = is_migration_entry_young(entry);
 		dirty = is_migration_entry_dirty(entry);
+	} else if (is_pmd_device_private_entry(*pmd)) {
+		old_pmd = *pmd;
+		entry = pmd_to_swp_entry(old_pmd);
+		page = pfn_swap_entry_to_page(entry);
+		folio = page_folio(page);
+
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
 		uffd_wp = pmd_swp_uffd_wp(old_pmd);
+
+		write = is_writable_device_private_entry(entry);
+		anon_exclusive = PageAnonExclusive(page);
+
+		/*
+		 * Device private THP should be treated the same as regular
+		 * folios w.r.t anon exclusive handling. See the comments for
+		 * folio handling and anon_exclusive below.
+		 */
+		if (freeze && anon_exclusive &&
+		    folio_try_share_anon_rmap_pmd(folio, page))
+			freeze = false;
+		if (!freeze) {
+			rmap_t rmap_flags = RMAP_NONE;
+
+			folio_ref_add(folio, HPAGE_PMD_NR - 1);
+			if (anon_exclusive)
+				rmap_flags |= RMAP_EXCLUSIVE;
+
+			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
+						 vma, haddr, rmap_flags);
+		}
 	} else {
 		/*
 		 * Up to this point the pmd is present and huge and userland has
@@ -3026,11 +3059,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	 * Note that NUMA hinting access restrictions are not transferred to
 	 * avoid any possibility of altering permissions across VMAs.
 	 */
-	if (freeze || pmd_migration) {
-		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
-			pte_t entry;
-			swp_entry_t swp_entry;
+	if (freeze || is_pmd_migration_entry(old_pmd)) {
+		pte_t entry;
+		swp_entry_t swp_entry;
 
+		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
 			if (write)
 				swp_entry = make_writable_migration_entry(
 							page_to_pfn(page + i));
@@ -3049,7 +3082,33 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 				entry = pte_swp_mksoft_dirty(entry);
 			if (uffd_wp)
 				entry = pte_swp_mkuffd_wp(entry);
+			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
+			set_pte_at(mm, addr, pte + i, entry);
+		}
+	} else if (is_pmd_device_private_entry(old_pmd)) {
+		pte_t entry;
+		swp_entry_t swp_entry;
 
+		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
+			/*
+			 * anon_exclusive was already propagated to the relevant
+			 * pages corresponding to the pte entries when freeze
+			 * is false.
+			 */
+			if (write)
+				swp_entry = make_writable_device_private_entry(
+							page_to_pfn(page + i));
+			else
+				swp_entry = make_readable_device_private_entry(
+							page_to_pfn(page + i));
+			/*
+			 * Young and dirty bits are not progated via swp_entry
+			 */
+			entry = swp_entry_to_pte(swp_entry);
+			if (soft_dirty)
+				entry = pte_swp_mksoft_dirty(entry);
+			if (uffd_wp)
+				entry = pte_swp_mkuffd_wp(entry);
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
 		}
@@ -3076,7 +3135,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (!pmd_migration)
+	if (!is_pmd_migration_entry(*pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
 	if (freeze)
 		put_page(page);
@@ -3089,7 +3148,7 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze)
 {
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
-	if (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd))
+	if (pmd_trans_huge(*pmd) || is_pmd_non_present_folio_entry(*pmd))
 		__split_huge_pmd_locked(vma, pmd, address, freeze);
 }
 
@@ -3268,6 +3327,9 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
 	VM_BUG_ON_FOLIO(folio_test_lru(new_folio), folio);
 	lockdep_assert_held(&lruvec->lru_lock);
 
+	if (folio_is_device_private(folio))
+		return;
+
 	if (list) {
 		/* page reclaim is reclaiming a huge page */
 		VM_WARN_ON(folio_test_lru(folio));
@@ -3885,8 +3947,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
-	if (!ret && is_anon)
+	if (!ret && is_anon && !folio_is_device_private(folio))
 		remap_flags = RMP_USE_SHARED_ZEROPAGE;
+
 	remap_page(folio, 1 << order, remap_flags);
 
 	/*
diff --git a/mm/migrate.c b/mm/migrate.c
index ce83c2c3c287..11fbfe905e3c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -307,6 +307,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
+	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
 
 	if (folio_test_mlocked(folio) || (pvmw->vma->vm_flags & VM_LOCKED) ||
 	    mm_forbids_zeropage(pvmw->vma->vm_mm))
-- 
2.51.0


