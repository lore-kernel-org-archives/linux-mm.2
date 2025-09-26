Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4BD4CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 16:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7DF38E0005; Fri, 26 Sep 2025 12:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55CC8E0001; Fri, 26 Sep 2025 12:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9EC8E0005; Fri, 26 Sep 2025 12:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC19B8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:56:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77797BB3D7
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:56:28 +0000 (UTC)
X-FDA: 83932004856.16.5A4AB28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D7C0540006
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:56:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758905787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oy69FO5pELTawIEUifpuddedC05hKy2CShWlrXDly5E=;
	b=6F4+lZO9NqRyAJVQXPQfUFnbXVWlxvcK5Iff3NrRl058l+xRXQuUcbz4ac66m48OS0NLIl
	VNyideEcmsXrKo3m4HDfuqd2bimiZV9nMd7aJRpPrXOTQ1fh5pgvcg+WhAM3s0yjW1FL61
	waqRUzdTALhl86C0Eg3Tax+8ehiNM9I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758905787; a=rsa-sha256;
	cv=none;
	b=Wly03dA0stKEXMPJDYpYpKI0gurnVjBpRrsO0VUxklnfBNvA9nasBExg3OvERuwIHCIDx8
	nBS0PNcPMK6pjU/Fnj1TfAM2TZgnVRgAOaxY+X/B8ZY3ADk1MukdRrf/0KxXulKXWJmSLe
	9/x5VvDP28iPhG87Ruxnl3AK8AvJUQk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2191561EE8;
	Fri, 26 Sep 2025 16:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E69C4CEF4;
	Fri, 26 Sep 2025 16:56:23 +0000 (UTC)
Date: Fri, 26 Sep 2025 17:56:21 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Yang Shi <yang@os.amperecomputing.com>, muchun.song@linux.dev,
	osalvador@suse.de, david@redhat.com, akpm@linux-foundation.org,
	will@kernel.org, carl@os.amperecomputing.com, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: hugetlb: avoid soft lockup when mprotect with
 PROT_MTE
Message-ID: <aNbFtaVr8f2klqdD@arm.com>
References: <20250926162034.1785899-1-yang@os.amperecomputing.com>
 <1038c7c7-81d6-f273-6fa1-93eb7206d5ed@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1038c7c7-81d6-f273-6fa1-93eb7206d5ed@gentwo.org>
X-Rspamd-Queue-Id: D7C0540006
X-Rspamd-Server: rspam05
X-Stat-Signature: uijj4aamt81cwawm7s1pp66d6mfqpenp
X-Rspam-User: 
X-HE-Tag: 1758905786-177210
X-HE-Meta: U2FsdGVkX19ysmD/YbhwAhTBTkFJftIOeKDvk35bYe4d01Io6Di69AlTofzii3Saita8oB+OuZxdSUim9S8uE1fia7hoDN5/oOA91FVbXT2IH0x2FyPbUkPv2Q6Qpy9xQ2WUKJg7ftt1ea/9CsZw6d+1jGpbmp8xY9BXQTLE10b42iipDxINghzgXlweshIz8pZTAEF34GCZTQSySXSg+crhDXzAYE9QBqOrRWfpHxKhOC3faf0Ji+Mibs9Mxt+pI0iKVXooF8oBpo10qQs+EoxycoBeEwiae5Nallq2OlO7RbsQC5kDUDd2taJ1K1pIO0FOvXrlGd8c6mFI1KPWK60KaVTLhK3LrmhL2qsucXDPH3kN9df3CSOj87R2kGDNHFzsOibGQP11HEq1DSeLeBqMWRQeyBbCy9TZaL6/6VXfaqPjV1eztdjUx+RuElupoOBr6tnM2Nms1oQJJ6be9grj5wXaMf7hcIvf0QCvq6EqCoGdTsVsmnG9MjKFEbiEyRdMGs57P6zwkLHFyNqUBKrGLALEvgG6FaU9op/YbwCcupYwn2XBpcUzqanDy7MPCGXewFMqAMZDQZOCWzK0CLmhVsdYE+Sd4MSBEwNOhHuh+EhQo+nF8T5TmSVokHnx8CoP/77Q2YNUlaEY+dL8ynJ/wLBiE5kzHFXjdhevGfBCyxF0syL33ntFFjBDyqSVcZW34/Pr9ES/0g2P3RJEYHYIxIoN1hlFB2SQ/ut8yHNUFVSUDNghIB78uUvycoGZEHLKMywec2hd0UKsStr9OVV+tdrhRo57gJns9gR/oeBPEPkXMp3iSlzA60UlGz8SR867ki/8tS1/0C/oCAA9WUtQ+fi+QJyQHSqtrGCKj+qd6FpZFEsi3DRRHaEHeVxDMdU3nIxJUF+hat8xkv9MYriw/ElBEbXAW3Wk6nsmyNvBF2J3KpDZ+6MEejma4Ftxz/M4gxydR135LKPHgZl
 4zfJ9dFC
 dMutEytXydB4CqhQsew34RtI9cG60VEVKMfHachNhdVb5DP+oh9ZakWDTy+j/SE+WO/lY377MyNcCitsO5T2wmLcxnmQg5pplgaVgfqlg+IQZViQfoKesB6BdP9j9D+m992kyNgNNfSR8rG2lvBeuOg4rrz0r/MxeVfke2S0vr+YjesC4PTVViuN3GAKn0otqUDlLc7pCaqG9v+i5phImHkvqEkpBQG+ZZJiBMbYVRq5cpAqmHH0OSm5z5szEMjW1YVingknnGYmH2/KSVTJLtOQngGgXxNOs5uEDdyRdfopPhj2MGivvUzwv/9DJWcXqg5vtHwWA0qvjxXasutJYIn+t1NbtX3+760pg8YvxDOTCknWf+LSkVz3si/uvRmb1FLkJGVfwdwISDsqcqI1/1kCvbccJBKAIYAG+jnGBwHH1i4pmgBCagk9OjnDHqP7X/aXq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 09:29:54AM -0700, Christoph Lameter (Ampere) wrote:
> On Fri, 26 Sep 2025, Yang Shi wrote:
> > When calling mprotect() with PROT_MTE, kernel will initialize MTE tags
> > for every single page in the affected area. Soft lockup was observed
> > when doing this for large HugeTLB memory area in our customer's workload
> > (~300GB memory):
> 
> AFAICT this is a bug fix. The hugetlb path should be doing a
> cond_resched() like the base page code does.
> 
> It is not MTE specific. If other processing takes a long time in the loop
> (setting up terabyte size mappings for hugetlb for example) then the
> softlockup could also be triggered on non MTE workloads.

Yeah, with MTE set_huge_pte_at() isn't just setting a pte but also
clearing the tags. So it can take considerable time.

The fix is indeed not related to MTE, so I don't think the Fixes tag
should mention MTE (but I'm fine with a cc stable). Let's say we change
a hugetlb from RW to RX and have to do cache maintenance, we'd trigger a
similar soft lockup, depending on how fast the system is.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

