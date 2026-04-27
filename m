Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63954FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AA196B0088; Mon, 27 Apr 2026 10:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781EA6B0092; Mon, 27 Apr 2026 10:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670EE6B0093; Mon, 27 Apr 2026 10:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 52E0E6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:26:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B2681403EE
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:25:45 +0000 (UTC)
X-FDA: 84704559492.25.53F5F5F
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011058.outbound.protection.outlook.com [52.101.62.58])
	by imf11.hostedemail.com (Postfix) with ESMTP id DEDC04001B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:25:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="2d3/wmQ+";
	spf=pass (imf11.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.58 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777299942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XX9buGiAGz0jHy3aY3vA8IUuaBn9K0+DEsfCSoKq5l0=;
	b=lOjc59V9cpT5uGZcYRW+TUFmGc1k9axf65id+hLQyVz567kKaSv6wNbUXBIdIUFVYOB8/c
	dNdMGQzt2AXEqHuV4ktYxSacJxkspR58b9srgiNYaY3G94dv679HZsjcf4rvHXGyozRZwS
	jquYAWqlb/H6eMQ+TUnVbjJ0PFrSZsk=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="2d3/wmQ+";
	spf=pass (imf11.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.58 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777299942; a=rsa-sha256;
	cv=pass;
	b=hgNDHn7+rBPNT5qdPmQ+VYLgkb+6ea+/rKhs2cX76XCyCcU1WXOMM4WxHdVhFNLkW3RbFu
	vpNHDTu43k639a4r21wSbITr9T0gGTf3znMGICffh1gloEH12KRd5E4cnQ/7fM/2AjUNSQ
	DQefEE2ubNdRW94x0BAeNcv8hcDseho=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SM6D/DYWIuwk4MxKisR8JVWdVBpcd3i/XB1oUdGzN1KgbhlMhk6KV4/FD1+kmUdi0gN1IP9v0liR2zUZ76USyJ+LTcddzAX7hEqs++ZO7c55Mat8glsNiMGwnNvmT6sow1X/Kirkwt5XW1nE3rTr8QJm6/IliRE5+Lpb2Y4oK0lpGk/Hx9dSxFBYzgRDpGQM9u3/Z3LzjQCvTbufX/phU1nV9NvcjlMUaOTrhNhV+czuTj2grA6+pX40lnstHh4bT2yx6ngf7rtCirHvEtYP3hlda9uRkbA1X7oEUrLn+RfgNherh2xEYXD9BqvqQ9KYAsRr5U0LGIwcy2IXWg6rIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XX9buGiAGz0jHy3aY3vA8IUuaBn9K0+DEsfCSoKq5l0=;
 b=LONRlQ2U/kpS8biPRMfLDVwHZYzi55n0SkrMJ/dnEHqyDyyCMDuQm4JzMjppTLXi9E+ezQuAFl2rtx8S6E65s8G4xgWpdEMc9yOywog66c4kO/AMIk7csbykipNtAeoSX+pQAh6kv0OmvBRindW0CNz4vo9We+VTBnEoAgF7TAHWTqpOQs0l4VEBLlDHaO7GFaDDeE7Zu1ywTPZ5cOCWnCkui8Tnvn8pk0xiU0FHUA0P9hmmfFGxs8w+zRZqR6uE6n7+HKqN84Pfos6SlsfmlYclMvZv+EilX2y5ua8SOdMqeCMtnF++cxNg2E8uzvy0aWs9zt7rBEkRMbniA5g3pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XX9buGiAGz0jHy3aY3vA8IUuaBn9K0+DEsfCSoKq5l0=;
 b=2d3/wmQ+KU2WhgolcGeHTeMyVzmKMtca9UF+KToUjoOUV8NAH16kW5mAcIy+PoY0eBX62tNK3tLGljq1XqFKc9Wc40iO5nqm/gxmsAvfY4XO9n+hdnTFh/uC/JHhhgKIlxML2oVUu3rOGUhOIkZJf6uMEnPOSlqtVmXWca7d+C8=
Received: from PH8PR15CA0010.namprd15.prod.outlook.com (2603:10b6:510:2d2::6)
 by MN2PR12MB4255.namprd12.prod.outlook.com (2603:10b6:208:198::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.15; Mon, 27 Apr
 2026 14:25:34 +0000
Received: from CY4PEPF0000E9D1.namprd03.prod.outlook.com
 (2603:10b6:510:2d2:cafe::8d) by PH8PR15CA0010.outlook.office365.com
 (2603:10b6:510:2d2::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.26 via Frontend Transport; Mon,
 27 Apr 2026 14:25:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000E9D1.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.18 via Frontend Transport; Mon, 27 Apr 2026 14:25:34 +0000
Received: from kaveri.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 27 Apr
 2026 09:25:28 -0500
From: Shivank Garg <shivankg@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Ankur Arora
	<ankur.a.arora@oracle.com>, Bharata B Rao <bharata@amd.com>, "Hrushikesh
 Salunke" <hsalunke@amd.com>, David Rientjes <rientjes@google.com>, "Shivank
 Garg" <shivankg@amd.com>
Subject: [RFC PATCH 0/1] batch page copies in folio_copy() and folio_mc_copy()
Date: Mon, 27 Apr 2026 14:20:36 +0000
Message-ID: <20260427142036.111940-2-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D1:EE_|MN2PR12MB4255:EE_
X-MS-Office365-Filtering-Correlation-Id: 7111b9bb-526c-497d-b3c5-08dea468d839
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700016|56012099003|18002099003|18096099003;
X-Microsoft-Antispam-Message-Info:
	Hs0WKm3Az2JS8kOWY0EFkQKXJZzOBbsAMSmc44JnVVDSaNAE9VQ9IvB/7WiuAXzkpPItCZQkIYjyHsTnf/25mZ/Us37ozdl72Ij76ZaGoaMj7vICv0afB7jxVsbjHmjqpKL90EdDTswW1qrlUXwXmHV3ipX4KGYfrSDSWtJHIwHAPHkTKl7sfpsn9KIMAugX+a9QVme5/95caZu3VkygXZbAWw54QgRMzbDlL7xDDQZLMvZEkHS0bP8lqokbJyKrw0EMXsfbKYu5uNbEGQKwlftHr7dtFl5heT8UJPFU9gr0aR0YBbfd0QKvH8/ZM5jQZYO/UDWXN+xUcaK6W2Xi3xETA3B4TEf1a1QIJTrhO9naX5pjrdjC2FafFMwNuQ4BcEnlZx73LVHuPVgIfhS+w3IDymRrDWk/oJXW42AdnwDx/i2iVSB/RYO7YE42smN885MzWWmWM08w/8koLzk/ru2mfcOZeaJ05f5iQE3ahebjda9Yybj1p9Y3dA7WaeQGGVhtmh4j6X3EvZyB9nson7pIL0ywSNC0L8C7fjJxXHFIkG05lY64H9vodx2fLdef2SciwlngS19orKpBBakPMpLuy73HASrelnDGtHR7QOuaQQqhztdc39QY89zzLRv1tgScjn6mfzpEwG8+ZqveitgKfOIKY8rsXazkaMReTPPfUa8iNSDweTQWOGn/SQe/ZUPNBnHMTwO5bGW29UaciFhYRdW1H8T9Xn+2lSZjtvIpSN9Wn7njIEnBRCBZHXtCLe0Qzp4hXphUCs5iJAnI/g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700016)(56012099003)(18002099003)(18096099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MtmwlUezBsnPGYk4oQiaaV/BOH5JnKrMSVl8c4biJKcoZBconMQp2rggs4nOMxYE2H1dgYFjKI7saj6Ozrd9GhWvwQ6kwQvxh4APPPhESrcRsrgx6Uuxmu5JDmlO8cQABkk19iawr0gcJSOToqNrFXPAxrUIPAU/b4bnEX86AOpjy3V9B4maxojcHho0ac7cWijP8GCDtqsFiL+FvvXLj5883QRh1fHQ6AJ/qKgwxAwssTPhzrNyM0tazb3DnxpYYzgUGs2H9NvA4XykeQfNh9K5T2/O8iVNc+PFXoG72ERASFQxapjug+wLlV8LJDIesXrNP1V9ru8buU4rYOnGp6khSeVkIYUBbQV6EcomCK53IjRpmZjy55kwoYhRfnO9DIXCE4P4kSjVNhpXCwWWBmZHToxdkdve22S/fSMigNRyuGnCO9pDFrTJ+l66URIm
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2026 14:25:34.3539
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7111b9bb-526c-497d-b3c5-08dea468d839
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4255
X-Stat-Signature: m3jotj41rpa63n8xqm5dacudapgugeu8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DEDC04001B
X-Rspam-User: 
X-HE-Tag: 1777299941-917041
X-HE-Meta: U2FsdGVkX19wvxgA5j7AkHeOGo4KNAc3K/bn2zoIeVCzcCjopbDz7s3l3Vts7x/sNr1DMjlBSC3sHSfVJcPYU+LSlIP8+zzbO0XPDo97cYQ8G1R8IEYqgtaqfAc3xCQErFADkFtfUzJh/6iRrbzFqqwifS23jmQkWfkp0C2bJz9pYYfIZ6/yt0lGcMV8Ilgg37LKPTzC8WLrx5kb2YJtg42JsNaG+5QiuT6k+GKzhEca7JMAw2nmkzBnu6YYcoMANhFaKRPxL/9L1b+/2B7OWgaB2tjWkBNPQ90hkuVvkIyWAsl85gvPPfOrW7i1sa4bX01K5BOa5RUuxpoBQo4gbY2jmoudYzPUje9nmYbyRW0rQEKAPCH53filnFP+pjKy/Q9M6naO7kEtvtC08mraQJ1OgldEmTe08FZcYU/TCw6WlY+lHJ5B6YTUiBu9sjFCpiv0APiuigT9urUd6JMv4VP71qEo0kaTxy6tJ7lWHCzLgqeBtIpRRCSk0lx/uLpWYC+JQympko1B1fJIKpjzPxLnZFbGG6L5DSGDqN9quVOIN3ABc0GkU6WawFhXT0WkZc2Vw7EcAO26LxV9jiojQNBVVuFd3LUV68J/cULbPBfZTrV9cca2xrTbofU3/XgtCEYKhr1qvJQErMfpgQYh9j+Z9kUWtcIjtlyeV4P8vdBJPRoC1NhmXIt2Nl4NSwTctbAuIlZs1t0MBM22CqC0tluj468fJOpN3WqqXChrJr1lJUpzTYhpMeVl0WK+V5uD1BiSrDevog+7VvFHZZaoKMvCDQ3XN8Lx+o+IjdQzhGEYiGW72l2VbcnyOdvFM1O9A+48srLKY7zSQcKnxKjG1wkbHUFzsFKyYjDMjPy6H9W0RiSJktl9lwG5ZmrmQf5LK1SSMXWln7ogOcFJ/gccBW091k1QQQwEt0BqycTb1pNX1jUpW4zVrzmqBPuHDqBWbHuVZ+Zzsx4x/gMQs8B
 OYst+dQ5
 xb0WPUo5TgtKoIrshMG3a2UdG+QgKdOj1JHPq5S0eaBBFJqCaTChOCIpbzI4cAMw9/+KMWD1leEyCd2glkFv/9HEoX2MuV5+7ItD5DQw9PR2IULhwr/y1mXibSECblQipLSWh2L8rbDNS57tH0AcvndD6TNTkrlFZZu8Y1Wl/DwUMZf0jU1d/sOm9uR08y4//F91GTiAVJT5hrLvWqLDvCdnjsASN9OPz19JPm56hM0oes0aSR8W5cWKOGOlnPOboShoq1u8WKjPiCeBUaDIgHT3IGpS7JJe7Y3ZbA/skgXH9xoFG0+9cCW8cgY8cYJ+yRpr0bQqQa2Qyd8qlGQMSg+nShHqHjQckZK0XRXTd4ojqLHkjiHVN2ZDrTEe3tK5H9FzD0Fc0EhhCJrS3diCnejfeMnlFRW0gg9019GAo69Bw7ruHKblR/gHV1tYdABUQU0fpjbUkrCH5RkUKPMA07o9ASs8W0xvA8cS88S1FqY0RJxAi8XqRSndPr/WkIetvkyIwzJfJxPdm63/uE9m3FVp52s87WV4dWGbVF7y/CTog/IY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This RFC batches folio_copy() and folio_mc_copy() for the
!HIGHMEM && !__HAVE_ARCH_COPY_HIGHPAGE path. A naive bulk-memcpy()
implementation gives ~2x on AMD Zen 5 but regresses AMD Zen 3, because
memcpy() resolves to different primitives on the two uarchs. I think
the right end state is a copy_pages() x86 helper that mirrors what
Ankur Arora did for clear_pages(), but I'd like opinions before doing
that arch-side work.

Both helpers loop per 4 KiB constituent page:

folio_copy(dst, src):
    for each page i in src:
        copy_highpage(dst[i], src[i])
        cond_resched()

folio_mc_copy(dst, src):
    for each page i in src:
        if copy_mc_highpage(dst[i], src[i]):
            return -EHWPOISON
        cond_resched()

On !HIGHMEM and !__HAVE_ARCH_COPY_HIGHPAGE, the per-iteration calls
boil down to:

copy_highpage()    -> copy_page()         = rep movsq        [REP_GOOD]
                                          = unrolled movq    [otherwise]

copy_mc_highpage() -> copy_mc_to_kernel() = copy_mc_fragile  [if enabled]
                                          = copy_mc_enhanced_fast_string (rep movsb)  [ERMS]
                                          = memcpy()         [otherwise]
                                            = rep movsb        [FSRM]
                                            = memcpy_orig      [otherwise]

So the two helpers are not symmetric. copy_highpage() is unambiguously
a microcoded rep movsq per page on every CPU we care about.
copy_mc_highpage() is a runtime dispatch that already uses rep movsb
on ERMS/FSRM CPUs and otherwise falls back to memcpy_orig.


For RFC, I added a naive batched fast path that replaces the
per-page call with a single bulk call:

copy_highpages()    -> memcpy(N * PAGE_SIZE)
copy_mc_highpages() -> copy_mc_to_kernel(N * PAGE_SIZE)

copy_mc_highpages() is fine: copy_mc_to_kernel() lands on the
same family of primitives at any length, so batching it just amortises
per-call setup.

                      | copy_mc_to_kernel() at any length
                      |--------------------------------------
Zen 3 (REP_GOOD only) | memcpy()           -->  memcpy_orig (movq)
Zen 4/5               | copy_mc_enhanced_fast_string (rep movsb)


copy_highpages() is where things break. It swaps the per-page
primitive from copy_page() (rep movsq on REP_GOOD) to memcpy(),
which has its own ALTERNATIVE that picks rep movsb on FSRM and
memcpy_orig on everything else. The primitive choice now depends
on X86_FEATURE_FSRM, not on what the caller wanted:

                      | copy_page() (per page)| memcpy(bulk)
                      |-----------------------|------------
Zen 3 (REP_GOOD only) | rep movsq             | memcpy_orig (movq)
Zen 4/5 (FSRM)        | rep movsq             | rep movsb (FSRM)


Test setup on Zen 5
===================

  - Dual-socket AMD EPYC 9655 (Zen 5), three NUMA nodes
    (DRAM node 0/1, CXL.mem node 2)
  - Kernel based on akpm/mm-new:c656c6a02
  - performance governor
  - Bench thread pinned to CPU 4

Microbenchmark: folio_mc_copy() / folio_copy() in isolation
===========================================================

Wrote a simple kernel module that allocates a single src/dst folio
pair of the requested order and times folio_*_copy() between them via
ktime_get_ns(). Each iteration optionally streams an eviction buffer
(128MB) through L3 to evict cache lines, so we can measure both
cache-cold and cache-hot regimes.

Cache-cold (2 MB total per run, source evicted before each copy):

  fn=folio_mc_copy
  direction      folio    baseline GB/s    optimized GB/s   speedup
  DRAM0->DRAM1   256K     15.63 ± 0.55     30.81 ± 2.10     1.97x
  DRAM0->DRAM1   512K     16.14 ± 0.66     33.74 ± 2.74     2.09x
  DRAM0->DRAM1     1M     17.09 ± 0.63     36.04 ± 1.85     2.11x
  DRAM0->DRAM1     2M     18.65 ± 1.37     38.03 ± 3.21     2.04x
  DRAM0->CXL     256K     22.55 ± 0.37     36.34 ± 1.32     1.61x
  DRAM0->CXL     512K     22.24 ± 0.86     37.42 ± 1.89     1.68x
  DRAM0->CXL       1M     23.28 ± 0.94     39.23 ± 0.97     1.68x
  DRAM0->CXL       2M     25.46 ± 2.89     39.29 ± 1.17     1.54x
  CXL->DRAM0       1M     17.88 ± 3.88     33.53 ± 0.40     1.88x
  CXL->DRAM0       2M     20.61 ± 3.95     35.07 ± 0.62     1.70x

  fn=folio_copy
  direction      folio    baseline GB/s    optimized GB/s   speedup
  DRAM0->DRAM1   256K     14.93 ± 0.57     29.66 ± 2.44     1.99x
  DRAM0->DRAM1   512K     15.60 ± 0.36     34.21 ± 1.23     2.19x
  DRAM0->DRAM1     1M     17.47 ± 0.41     36.20 ± 1.40     2.07x
  DRAM0->DRAM1     2M     19.36 ± 1.97     38.92 ± 1.58     2.01x
  DRAM0->CXL     256K     21.49 ± 0.39     34.92 ± 2.95     1.63x
  DRAM0->CXL     512K     21.01 ± 0.69     37.09 ± 2.13     1.76x
  DRAM0->CXL       1M     24.37 ± 1.99     38.94 ± 0.90     1.60x
  DRAM0->CXL       2M     26.59 ± 2.78     38.40 ± 2.59     1.44x
  CXL->DRAM0       1M     19.05 ± 3.87     33.93 ± 0.42     1.78x
  CXL->DRAM0       2M     20.50 ± 4.53     35.78 ± 0.93     1.75x

Cache-hot scenario (1G total, no eviction):

Even when both source and destination already fit in L2/L3, the
batched helper still wins. For a 2 MB cache-hot folio the old code
runs the kmap_local_page() / kunmap_local() / cond_resched()
sequence 512 times; the new code runs it once.

  fn=folio_copy
  direction      folio    baseline GB/s    optimized GB/s   speedup
  DRAM0->DRAM0    16K     83.61 ± 0.41     96.70 ± 0.58     1.16x
  DRAM0->DRAM0    64K     65.95 ± 1.14     78.77 ± 0.20     1.19x
  DRAM0->DRAM0   256K     68.59 ± 0.88     82.55 ± 0.10     1.20x
  DRAM0->DRAM0   512K     66.02 ± 0.50     82.66 ± 0.17     1.25x
  DRAM0->DRAM0     1M     38.07 ± 0.06     41.53 ± 0.05     1.09x
  DRAM0->DRAM0     2M     38.54 ± 0.02     41.60 ± 0.04     1.08x


End-to-end: move_pages(2) on anon mTHP
======================================

Measure move_pages(2) syscall wall time on userspace pages obtained
via aligned_alloc(). This includes the rmap walk, TLB shootdown,
destination folio allocation, PTE rewrite, and refcount work, on top
of the actual copy. The microbench wins do translate, even though the
syscall floor work caps the speedup.

  fn=move_pages(2), 1 GiB migrated per run

  direction      folio     baseline GB/s   optimized GB/s  speedup
  DRAM0->DRAM1   256K      4.77 ± 0.01     5.09 ± 0.01     1.07x
  DRAM0->DRAM1     1M      4.83 ± 0.02     5.19 ± 0.02     1.08x
  DRAM0->DRAM1     2M      7.20 ± 0.03     8.01 ± 0.02     1.11x

  DRAM0->CXL     256K      6.07 ± 0.02     6.65 ± 0.01     1.10x
  DRAM0->CXL       1M      6.29 ± 0.02     6.74 ± 0.02     1.07x
  DRAM0->CXL       2M     11.12 ± 0.15    13.07 ± 0.03     1.18x

  DRAM1->DRAM0   256K      4.72 ± 0.01     5.06 ± 0.01     1.07x
  DRAM1->DRAM0     1M      4.83 ± 0.02     5.17 ± 0.02     1.07x
  DRAM1->DRAM0     2M      7.21 ± 0.02     7.95 ± 0.02     1.10x

  CXL->DRAM0     256K      5.08 ± 0.06     5.24 ± 0.05     1.03x
  CXL->DRAM0       1M      5.30 ± 0.05     5.44 ± 0.05     1.03x
  CXL->DRAM0       2M      9.10 ± 0.05     9.49 ± 0.01     1.04x


Regression on Zen 3
===================

Hardware: AMD EPYC 7713 (Zen 3 / Milan, no FSRM, no ERMS).
fn=folio_copy  (with current patch using bulk memcpy())

2M cache-cold: 
direction      folio   speedup
DRAM0->DRAM1     1M    0.90x
DRAM0->DRAM1     2M    0.89x
DRAM1->DRAM0     1M    0.85x
DRAM1->DRAM0     2M    0.86x

2M Cache-hot:
direction      folio   speedup
DRAM0->DRAM1     1M    0.60x
DRAM0->DRAM1     2M    0.61x
DRAM1->DRAM0     1M    0.60x
DRAM1->DRAM0     2M    0.60x

1G Cache-hot:
direction      folio   speedup
DRAM0->DRAM1     1M    0.59x
DRAM0->DRAM1     2M    0.59x
DRAM1->DRAM0     1M    0.59x
DRAM1->DRAM0     2M    0.61x


QUESTIONS:
==========
Should we introduce copy_pages() infrastructure for folio copy
optimisation, or just patch folio_mc_copy() and leave folio_copy()
alone?

Should folio_copy() and folio_mc_copy() use symmetric primitive
selection? It is unclear (to me) whether the asymmetry was deliberate
or accidental.
 
Unchanged paths
===============
 - CONFIG_HIGHMEM: each page still needs its own kmap_local_page(),
   so the per-page loop is retained.
 - Architectures that override __HAVE_ARCH_COPY_HIGHPAGE:
   copy_highpages() falls back to the per-page loop.

Thanks for review and feedback.


Shivank Garg (1):
  mm: batch page copies in folio_copy() and folio_mc_copy()

 include/linux/highmem.h | 58 +++++++++++++++++++++++++++++++++++++++++
 mm/util.c               | 25 +++---------------
 2 files changed, 62 insertions(+), 21 deletions(-)


base-commit: c656c6a0242712b537ee75208d431b210ab390c3
-- 
2.43.0


