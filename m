Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9C9D6CFDC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B0C6B03C7; Fri, 23 Jan 2026 01:25:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17DA6B03EC; Fri, 23 Jan 2026 01:25:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06096B03ED; Fri, 23 Jan 2026 01:25:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD7866B03C7
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:25:53 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9708AC188C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:25:53 +0000 (UTC)
X-FDA: 84362242986.15.B589F85
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012049.outbound.protection.outlook.com [40.93.195.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id C103914000A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:25:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NyeP3h+7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.195.49 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769149550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJRKGijDy281u3FFBQFNlpVMWwAgnO4o4gEkUuYonCE=;
	b=gWJSZQLeH3eElbMa886kvcSjeqX3kEqtocL2ef2axs9xsOreacPx9kh/YpZnDvuGDmwxRz
	9DRDOL8po8QzLh80MdBl4uMvxrnG0Rj6qpZ8kJTRtCIQKPveHBW0nCVNxnsN0i+b107+qz
	XyUGos/7We5BRsgKmV8YpFAyEmQzuns=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769149550; a=rsa-sha256;
	cv=pass;
	b=06ekS0T23V3VDaZ75aAqoMCnvU60GNNV9lRuqQavkNLgaiBiOV99f/GDfutS+kwzwk9uPA
	HW817SeyZw3d2yRsYg38WtP4IMeRbYUQF8Ox+WFWUrX621TyWDvc04oQh+fLRsrQhB+Hma
	dWpyrEWSwa5djC+xvOTAw+IRMRP1cMc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NyeP3h+7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.195.49 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NGgv+RejmHYyW0jMISSGTfDmv5EbLzLJ9F6rUK3cH7rwhTc2rZlhL/EHdtMVFNDb4tyr+iMR73Ujd0uGNqhPOVSRIeQ285alRRdViSTAQd23hFHrJAbUBB1mDXewfZyKGZhMPQK1GpNW4XEumU1V71ojbr75rlhAoq9LshqiJ4BkrrDlBd9qO+89lYk1qSgqFVjhXOcNgQvlucJEuX2aTeIpl9Yg2Tz6n0mPXtyRcloYhUhZv8xdtZXUJN6R3YYHTOqqQj0NC1eVY8wOgzVFp0Qu7CM0cNfbNr5CKvvovbUBxtW8a8JOkMT17zN2156TU3MH1K11p62MKjXcDndT6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJRKGijDy281u3FFBQFNlpVMWwAgnO4o4gEkUuYonCE=;
 b=W0BDjLvC/a+DfrylfzRwdBQ+1i86YIQ7Gs2YaYfGPTzdw1JN6TQOyDvFsZkXiVZ7riVz6qe9/mf0uBV/MHHj1hvLYTmcb8zz/HTYhKucR4gcwBsYagoIlygeaQRKVwCbk/gndEyaXlgST1jZNdtXBBPUu4bvuuFMmvIcBmx/dopg50UAHovVNbL9a/aygIShVLY87FDNhGOI3N8pdT7WH+I00uiYZEody4iBwph8LwEgYtGM1HAXo66gZJYyu1h1dlYHDzy6tM4SFUPnP0VA/euT4/dac5XhwUK/waIkW9y/2YK4R0mwD4djdAOZIXDa+IyRFNw5eaCpXTvcGyhrpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJRKGijDy281u3FFBQFNlpVMWwAgnO4o4gEkUuYonCE=;
 b=NyeP3h+7xaqd9Sc94XwpktoNdy2JS0OBzZPJoOq/N1vAeKSk/CWLYaUJXYYUnMe6B/B4xsHNivjsEFGaGtof5sBYTmHXg1okBjrsXYHL+WrTYrKPSRDnM+9xd5hKfNhOBtWmDFPt0hOKLSe4iJH1DHCZ5HyBBXgwDIuH+nRG1ScCnvA/Gw5k6qRflIaeKMQ06SwhtGbZv8GgKCTUrIdaSbcbbH4dwr09dhZxE7OvCh1FCqXnqwgRgyZ62h234/9AkRxjTghV1/ShM2sIVe8pmrjQUFUZA3bEmrVnk8fNuHlWtmh7YmuLBAeHQniGoffVx+2h2q7tRDr6i4BtDMCADw==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 DS0PR12MB8020.namprd12.prod.outlook.com (2603:10b6:8:14f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.11; Fri, 23 Jan 2026 06:24:23 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 06:24:22 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH v3 09/13] mm: Begin creating device private migration entries
Date: Fri, 23 Jan 2026 17:23:05 +1100
Message-Id: <20260123062309.23090-10-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123062309.23090-1-jniethe@nvidia.com>
References: <20260123062309.23090-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0152.namprd03.prod.outlook.com
 (2603:10b6:a03:338::7) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|DS0PR12MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: 39f25c91-e68c-476f-d320-08de5a480c2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?SH9CfAR6FJtJBsqN/p0iwChxvE5nPF5fcbX/G7B8JmDd1CuuP3A9kvedHkgi?=
 =?us-ascii?Q?Sm5uzYFZUMG8JKxmXAsvK02uZ1oaNPhOf3LcUKg7tsC+48PpUdttfJ1UYOCB?=
 =?us-ascii?Q?cXlevDI8DsVTNd6UOa4a3XW9Hj1BDeQUJXFApzTVv8VMKQdO0znxkf/PMrKc?=
 =?us-ascii?Q?Lvr0KqGimRw7AB8HQG42KnJClhieb7eI5tfDv6p9R2mCVvwUPIRR39+2DHZK?=
 =?us-ascii?Q?w2b2KNUzLqYDkeE5dHhTxRJWNQuCjdhH6WKSuoH+blqULzX1BitkEdfllWPf?=
 =?us-ascii?Q?iffGevZ6m9ophCTaeKjYeojnaHoZdh6kZzmJP4tuBUNCNJePgePXfbny8r+Q?=
 =?us-ascii?Q?Np43k3z7E8ak9M61u4/Kc3sK2/sTb1dlOUltG9z4BrYtOY6fBkbwRj1gq+iV?=
 =?us-ascii?Q?+1CPnwlC7Ytx002vhqDuSdrLq4BqK12jZkqjXPDo/HImnEcGSupS3AAV9kTi?=
 =?us-ascii?Q?bwcYc5cnPpVAKqeLPx1zlFjlvTxmvPeMQTufBXoV7aHE2WL/7sxqxw3sA5L4?=
 =?us-ascii?Q?/UZJYXfADSOyHedJWW3AH5AGRl21FLgpgKudIiQ/sgNzwDz+S9KVTjga16qK?=
 =?us-ascii?Q?ZG2QFHp7RtRtVnB1JyHY2AQwSLib2TPtz0GH2qSG/12CB/Y96NfL5i6+FYwj?=
 =?us-ascii?Q?jE0qJSSIOIEitHn0EEGPrqCeMtHjozrgJLO49PuQX9MCU5xePtTba/89/mhu?=
 =?us-ascii?Q?KABaDfQX7AUNdNZcAWmX0PShtE2JtMNr1wvZIxb/paGWkO/N5YAHmbNIb5F1?=
 =?us-ascii?Q?4E0gzOcSeZ80mpIcNeGcjkV+aex8O9KegNgtP+vQG4rQ8d8itFxiJBEXt3oC?=
 =?us-ascii?Q?M45FxYsQ5nnUtqtS8sdT/dEkPRmsDPJUT7hkyhv27c5TKWNfdlGmbL5Rr2zQ?=
 =?us-ascii?Q?rRfhmh7zmkCykYCUO9ZPZ6VJ6WpZJqQB4p86fcYnp1/dHS8n301d/YDtkKUF?=
 =?us-ascii?Q?8KlxKsTyv5vSFyWktb0aR8Z8L6INQcZLdp6wDV43dvQojDx5zG8lcBGzK97q?=
 =?us-ascii?Q?QCiPPlwfwKPJ1j/zSJJ6y0DmpF/TNQA/zAKGtu8BFhvsH8BcDKYdzUra9/G2?=
 =?us-ascii?Q?F7AJZfZ3+ZTHnrBRHtEVMBS307bJqpVKhbjmpXqk2dDZQpbe8k3AxHVbx+1F?=
 =?us-ascii?Q?QM0VMgXtGSvmr8xq/9mUaJp4UT74QTEnVQyJxbgMJYlF60DqFeFTVsfcn0Hw?=
 =?us-ascii?Q?inKMrExIKX3/hG1XE4+kDkr6RYSy8XQbcW1cBKAPLzz80SrKJLu/hUnA70XW?=
 =?us-ascii?Q?dYGYzcJpIln7qnnVRxFdTHqzQGA6YiJDTyDnu+JFOaoHuhb7JfeMgZ4999ek?=
 =?us-ascii?Q?jbLC77wX+iGifw3G4H1K/pRDe/vV0ajctDWqdeevdBmk2dEwmnmaU2GXU63X?=
 =?us-ascii?Q?JTmxy82uDI+Sij61eWI8jQiPV9HDhFQKwy7mkrc/D2vPet2aqq9ZnF+GqVcc?=
 =?us-ascii?Q?b4XuCf2h/H6MUvf/wTIiUFVDI+SGeqkVPefrpblci2mbQo1QTgEdEc7RgkAc?=
 =?us-ascii?Q?w1I3GPW96piLS0eYGvM1X5R2NisaOX++l7Q5DmjAaJ3pjOLrqT3+MHRIFX2p?=
 =?us-ascii?Q?ZtYCgaEW0vyQF3CMIbY=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?UDxsSYvR3+rWsQll0qtAhWHNxVvRvP8t7WvEuTWX+2tP1HzOPKeSmLZXM8fp?=
 =?us-ascii?Q?U3JiY9VhsmDg5opcoIaldP4xa6UsgLDV/hTSF1tHdcXX3l97EZXdzlvRkd5d?=
 =?us-ascii?Q?BMgP2H15TKOJhJi5s08lOUP6+wKJoE5VFyrDI6+QDU/sGVOeSi4Pkp+iSSqm?=
 =?us-ascii?Q?ys1pZohzdxO9Ni9SjQTY67w396Qfdnxqk2IIshzVXPmn5YIMxVdq4ctTIkJx?=
 =?us-ascii?Q?b0S4WxlfYjKb3X9H1fjt3206pmnBpdWWgrfeJgk6Tf6Ku5h/IX2CnRcwQ2EE?=
 =?us-ascii?Q?9Uw5nNXDzoVb4EWq7R8c9yxLjiyDI0WgCIn12ToHAZfST7EneUbt2maUhub9?=
 =?us-ascii?Q?NZKdV+Stqak4gMXDyLa2MMiUj2r/wYlywnrAwYwmoFeAIGGoBuFUnLlHgz9t?=
 =?us-ascii?Q?YZmgWHMn/TPdKN0+zNmEYwE+XAQBwxHGf0zs9IHO5zhLEkUQT6Z6jJBGMBov?=
 =?us-ascii?Q?0r4YJVRz5iZOeguvKcH3Vqqjb33KdoiriT4SlZByAioEWFLl3HvEXu9W5fZ/?=
 =?us-ascii?Q?cS6Pue/Evkk0zuZ3NJ+wA/kPi8kT9be+CmpxmgWWx1hIKpC/07/9oh1kFCKC?=
 =?us-ascii?Q?Yl6BIUQddjfoAf38zT+2rxrpGfBF4Xj1q4tvvejbppBMC7nIZ32OJNRHyHOA?=
 =?us-ascii?Q?io6TOgma4p1GhW4U1wGsGKtqVq6nr/uAseliWcuXelNrTMVxZsj4cHR497Dd?=
 =?us-ascii?Q?yyMc6q2pA3Y3w5BpTKYMnpJJWOR4aBnvzvTHk4TqX8cVDHQuq1uVyyTV5B7O?=
 =?us-ascii?Q?QUjEnAyRKa4ekznxqok6b+KnwSVs6x70tc1F7TDQJwomxCN0urg2vgrAfLi6?=
 =?us-ascii?Q?AKqoIa8C44LdKldzCruZ3DU74UCIQ2dQgf8nk/wiM+tADSE4n8OD4w+EKDyg?=
 =?us-ascii?Q?JxKaqC7/uywUdUFmi+IcRJq89gY1L+24OsQMM7zJ1SPo/zwvNxZzhlYNY+ed?=
 =?us-ascii?Q?rH1N1jIjUWTh0Z2yrYODsj5pByK4G8MryrERkWMTtmK7jScUj25HeiQMHIDU?=
 =?us-ascii?Q?D2xCjh/yLZUdBO7zyn7UJfX5EJ2KGExyh776PEUPHydAQfyNtW8lXtCJ9SNz?=
 =?us-ascii?Q?jZmT0vzv4W0LNHsFOXeawWPRXmfoYPw96Rmjw1k+QVBA28sKN/iMTotv0h10?=
 =?us-ascii?Q?J3wTkXJwN46mS30BO+g8w+XEKXFNBHRtnvVoMYvpmfwBje2YTdY5CwKymqPE?=
 =?us-ascii?Q?TLds/mZFeZwWPo5lNni3rrdeCE4ghnYCQRqLf+gJomifyPnU/ytdAseQ7Gjy?=
 =?us-ascii?Q?Zo/4w4Sil8ItS3skllv2ecsgqycMPOczhQJIRaDzrlQMadH5HI54pP9z0ITI?=
 =?us-ascii?Q?ZVA5DODWwQXoeAxVrDQyzMNHMB3dKSb2zBYQyCRisdVVGH6qZAG3CwRXLjjv?=
 =?us-ascii?Q?8tR1cb3QtMzl7G9lqTqYqGniaDdN0kMbqQZvOj7SZHNNTXyLw0LheLFdLtHH?=
 =?us-ascii?Q?vDBb5/Hafqs4i9Qp7PwRWJmWMM8WtAkiFnevYOwhrP/TEHWJxcTmd0P98JvL?=
 =?us-ascii?Q?BWuac9xBVRODcjEF9X9CkQWTHGituU8dPOqpi3VCZJcFOF+KiGEYihSp5tj3?=
 =?us-ascii?Q?syosOfvzucumElK6FyaMsOttLdR/MUfbzx5xRjdXXuwC3o3/06fBO7TucXcU?=
 =?us-ascii?Q?bI9PcqP7bCM7jegkM8h7g2zBc45Pp9U7/n5cHLBaYdhVOlWZW1YREe2IIiTA?=
 =?us-ascii?Q?d4+7vw+UfXe1uRiXxpodkrqTks99N4I9HSt2ULaTM0xYryxcP8mpFIOdeo4Y?=
 =?us-ascii?Q?tbwFSjivJw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39f25c91-e68c-476f-d320-08de5a480c2a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 06:24:22.2519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KNEiXOdYbiSJnz0SoMv5FhVodGtjVBJ4aJMoXZOL2h4haGw4nrf8gsSyw/vvQNNdUPcAdmXRf7PIEBPw7p0Dcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8020
X-Rspamd-Queue-Id: C103914000A
X-Stat-Signature: aot3modia9x7h18m986e6gp75fsaj6ke
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769149550-906899
X-HE-Meta: U2FsdGVkX1/Q6YoFqJKuZ0WALMpdjDNvPut1utUvvsHiEGTBCwFCWoRXt1TJFFQz1zmZK3or4FDmZq5Cv1SuJNLOuTdIDfcx/ExJm93gjZrzc9fHPxvfwwnwiAp+5zWEbO+qfErrtF6Q8BY/eXlAbh3PPH1pfbAevILiGMsJjGMfiwazKKWgMbJ3nLpjpue1jtzdJrpbxw1+qeOWQc77MA5K6kVtAu5/PKf49tLpPe5axba3cPqrneezsdNYHwMKOKpibQ+yXVHjnRYEW/qYVsMqjaphvHXBF5SLOsoFj4y495a7sxnFA3k5gdQZciMAYz5e+raPhJC/RTmKlQjQ2v1gpGFIfmt+oU6g39TGLWmdF9JLp6TB8k0uchnIZLvidaSv9stYdT+hPJyGgP4QKKZ9y1L08mTcVKo6sdnUs8Odjzf2lJ7zPbxrH7izqTd1W7xMHfUkpY+wLp7dRUe18CcIfBPRVM9n+1/oF7swGJD1JJlqdL7tVk9Lap/+eQF6GdzK+ilPhi/ci6IpPm6ekSUup/tSDby08O0o/gHVwqe2rDy6PnE8a1YGUn9b9XF+4ZliP+mV9Ga9mIS1LVbGr0PH0t7AE/TpGedn9zP81i3NejZyJbvQGf55b5CeBGccdar3cov4yElC18P509c3iN127M3slX8qGwVQTtoiK3FRATJ1L16N3e3i1XM4tk6Davc1MH3qwmiEuRc3zqk+N5k7CRKmyNlSTTWaxLi0qMW3cNBn25c+BCdNt8ugk2tqZkN4V2qiJLBCHpEq3UqXKkTvbzfj1Sozram/tOhktQQ1MR9JbRAjD0pCNAmSATRgALb2TaG8hxOheDO2GQomhtuqahLjZxw2U8m0cN10fa6a3QuhGpLhyQ+YJhIIQB/vvmz3RPsnWJ11ou6gPqzJNSGwumyknBvfoVMhnK/Ejbz7DKLWmAEmFFk9LENzMlJUaZppH3bTyA5iQB35JSZ
 xvYJHsw2
 /O8BllYQnHtbseinNX4owAyGztg0k7msJ1dq4Vd2+LongEpWkx1updZZB8HE+59S6133uyR8Nys9WyfV7ESI4glw9MlNXg1W3pp/ySltlVhSXskpHRya1gFk30B3iTEFFTu+nwA43M2llpIK+GnB2BT1AU+iAtrseF6HSrB0ihQBwyQbscFSyg8r+AnYXn2FK4Gg9li5ZMGEbyXOTEciRSKDsK6tdQOxpadkX/spQM+zVL/3xOGJtUnbNOphYXTe1V/LDfzQ7daCcxXKnbMXv5jA/WLAR/ujBMfKa/fMcCxl2Gz2izI1QsBsJ9LUp/urGiz6lJKt3q/jsVEyh6R7ZOqG7fzTTFlhXk1VAFxCMiUyHKHNv+wPI25XuncE2TYE3XcY3yuDbRRryOmTt4Dc6IQaNTFzHkCOE6QYHEPklJDWQ2yPoekYwZ62D9NvlRntIewt9pYM5CKp7KSv3w8Co2YMdjHLeG/boXcF43Tn9seyVqpKBuwNwX2kuU/7LvMvrXFH2vDmC10HdC/GHvXwV6WS2DST3aCuBwCqw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the migration entry creation helpers to automatically create
device private migration entries when invoked on device private pages.

The corresponding softleaf predicates have already been updated to
expect both migration and device private migration entries.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v3:
  - Provided as an individual patch
---
 include/linux/swapops.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index a70a6809e9c6..2591ed914d22 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -205,6 +205,10 @@ static inline swp_entry_t make_readable_migration_entry(pgoff_t offset)
 
 static inline swp_entry_t make_readable_migration_entry_from_page(struct page *page, pgoff_t flags)
 {
+	if (is_device_private_page(page))
+		return make_readable_migration_device_private_entry(
+				page_to_pfn(page) | flags);
+
 	return swp_entry(SWP_MIGRATION_READ, page_to_pfn(page) | flags);
 }
 
@@ -216,6 +220,10 @@ static inline swp_entry_t make_readable_exclusive_migration_entry(pgoff_t offset
 static inline swp_entry_t make_readable_exclusive_migration_entry_from_page(struct page *page,
 									    pgoff_t flags)
 {
+	if (is_device_private_page(page))
+		return make_readable_exclusive_migration_device_private_entry(
+				page_to_pfn(page) | flags);
+
 	return swp_entry(SWP_MIGRATION_READ_EXCLUSIVE, page_to_pfn(page) | flags);
 }
 
@@ -227,6 +235,10 @@ static inline swp_entry_t make_writable_migration_entry(pgoff_t offset)
 static inline swp_entry_t make_writable_migration_entry_from_page(struct page *page,
 								  pgoff_t flags)
 {
+	if (is_device_private_page(page))
+		return make_writable_migration_device_private_entry(
+				page_to_pfn(page) | flags);
+
 	return swp_entry(SWP_MIGRATION_WRITE, page_to_pfn(page) | flags);
 }
 
-- 
2.34.1


