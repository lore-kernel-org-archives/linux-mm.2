Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59599CC6B2E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 04:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121C96B0095; Thu, 15 Oct 2026 00:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2416B0096; Thu, 15 Oct 2026 00:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A326B0098; Thu, 15 Oct 2026 00:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7AFE6B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:36:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2478FC0904
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:36:57 +0000 (UTC)
X-FDA: 85323600474.03.33C0682
Received: from mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
	by imf18.hostedemail.com (Postfix) with ESMTP id 25DB91C0006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:36:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g1YK+Aya;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.60 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792039015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mqgxjox2Ke6PdLi+uDbx/5rC2vwEe3N7bzWbljRvMAc=;
	b=ePT4Jx62La7CqqcZnhhHMWO82FgAZo6L4wSEZWaYhannWUKwluDUUAJZWwyE/xjRFi/lHC
	5xdV4vhVFyxiUhIJb//opbZ9VhuEfo1WSghiWKAf/DdUQ0qnk2Fjqe7GA4mEG0DC6MtNfu
	jv9t2oZyKMpmxp12sBYHuPfJNLPMJGs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792039015;
	b=1NSeON+2NJQ1qujpiONjkrpM1tHIMJ9SWZYuk8czeJUJ1Wn3AholcNddU9xcNjaOcM807K
	RpoaQ4NVS5XWsP8M/m5WCwdTZM8E3AYlHjQIPNS4TOqnhpufvFNdLchCY7QlEn6Czp0lcz
	PS+tm0Vw4xUwFQlFFZFn70vTVELYMio=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g1YK+Aya;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.60 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mqgxjox2Ke6PdLi+uDbx/5rC2vwEe3N7bzWbljRvMAc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792039014; v=1; x=1792643814;
 b=g1YK+AyaEpn4uXak7c5NuQ+xq3JooAXPNCpEXMjyY7m+S9Hcse0vqci6uHRAjwbIcwZadCee
 lhWIDIbYw9j059wul0urXShqnlsryZu6TpCTTYYRxsesgb5sAa5Dy7CVAJ9Yuy8yADiHW53XYl2
 PqiccwYJpS2tYQBrEaPSKLBA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c19b6154bdd8c5f2;
	Thu, 15 Oct 2026 04:36:53 +0000
X-Mizu-Trace-ID: c19b6154bdd8c5f2
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kas@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com
Subject: Re: [PATCH v5 2/9] mm/khugepaged: count collapses where khugepaged makes them
Date: Thu, 15 Oct 2026 12:36:38 +0800
Message-ID: <20261015043638.57643-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261014171145.3292736-3-kas@kernel.org>
References: <20261014171145.3292736-3-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 25DB91C0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: bgyo7ft8f1dt1e5we9efsotq6p9wkf6d
X-HE-Tag: 1792039014-566769
X-HE-Meta: U2FsdGVkX1/Srxrkx8L1PBFzRp5FtZUJdHpBwj3QQdHtyPAQ81K4p3WYY0w30l+b5tgP+RCc4s65DiCmJ6vKn1gxePtwZB3CYGWpdKFKiMddaP2tYPi74QIi09dbmCfQWj6z2BlPR4N1pHShHdQ9oGTEvQugilpFIEMn163Xiq0ffWRj+guIYD6ERUcYI/qs1W7pkedYocMA+bSJl4nHARD4auY81E6RcxSwBcjsXJCz1Df5ybGgufoTaiWq8gjv88KhRxXcosqAJKnYHxXf+0RojpiutaGAz3MvKy9aqPYlWYTPnucyTB/yN2ualYDmLNGVkvGnKdkI3ceKpY8v1XXdjTC/KDU4WfNG0BUI87Aq3rjlfyeqzJvxe9iUlZY/vaR02ZToO7zzMLdwplyMnD79Tp68u5smgTASz0JhkYQbHE7PdmG34N11A88MtK7LstmLABWFxwwfW59oZJzEH5WC1ZZ4Mkc5rOYLk7LSUjs3ShGRG7Rk8JFc2RRsjPQz0jHSnQnDRXAw6Bq5h5QrP55KYbFvWme0ZDTZXNKGcl0U93nDHVw+muYVjPYwjeYd4/yyy5BfLFrJnxQpNdu4St4/pxWCbZ5ftXSmv4G/+7cmoMthbX0QAn6yrklZWjBTZ0qsWmggAEH/VAMGFEvoGMAdUbg04Gu/5KG+2EswKp5PNTwquclgMIgdOw35mUfgNVdKYChertCQrdrNPUdFR6Eu6C74qza9mE+ThQsG6i8plYyAa9nYZ5Z2r3t0NoBG5PY72vyVBEYwX+H4T5K70kQD/s9XA83oH2BS77TLfG3xPX4olYe/8V25rZnaQ+I36vJ6QpgO7dUtukvVjnU8EVBNOr5wm5WvJ7N+vZgF6Ei2HqiPQrIWN1DnUpeeXegRGgeRsd4PM1qbb68yMRB0eJBqpPl87E821SxTFPlKXbfkapK6yc3p3yOl0UEq4YqxHqDXgf92cglUImOyZps
 y9RIcwoy
 YoC4VLjnT8fuE2wZbS3fWhltw4lmEQzFCRDJmPilNM8PCWDnTtpEkKiXRPimFqnTV+EsEb7Y5hF22ASV27l3xdgsxECBDL+DD2L0tRSEVfbSqqki0eFE34z8PkIWOSqfjFrUBvz9kri+8cgRao4rJfti4wsX+quK6e3ocE5EuxE4HTI+E3Hi56Q7L3IQK5ORZ97O4YFrYAQpPUqVyvPeJAJ27Ndhr1PjtYSj/nCIcfNb9z2CQjZHYuVsk9Uu03Xig6AIKX7b1/60DhRFd6n4I28KufnRPeJLwzGHxfbf2ga6Sp00L7vFtb7IAHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Oct 14, 2026 at 06:11:35PM +0100, Kiryl Shutsemau (Meta) wrote:
>collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, and
>tests cc->is_khugepaged to know whether it should: the counter belongs to
>the daemon, and MADV_COLLAPSE must not touch it.
>
>The daemon sees every result of every collapse it asks for, so it can keep
>its own counter without the shared path testing who called.
>
>Assisted-by: LLM
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

