Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D483CCC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 04:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D03A6B008A; Thu, 15 Oct 2026 00:44:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7D76B0092; Thu, 15 Oct 2026 00:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE806B0099; Thu, 15 Oct 2026 00:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 567416B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:44:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56B8DA8244
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:44:22 +0000 (UTC)
X-FDA: 85323619164.07.667FE7E
Received: from mta0.migadu.com (out-141.mta0.migadu.com [91.218.175.141])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4FE7140002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:44:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PkRYrnBL;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.141 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792039460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuFcnFpeJQ4S0usaspkxenwN7ezJLGqyCCeoAKB5Ebw=;
	b=cxVwQEe7ZR2pEUew+5aVCVFeqh4G6c4/dWJet3zIloo3pmGSgliNrUjMBjT/YeCZm8K1w2
	9a2dpJePVcYmDOEkB6MJehuQ6aSq3UBif8+0FuFqszZkynIbVPSii+ja7o+I7c4zD7N9yz
	g7CyGJ4yUsqdNXB90Douik7POcycTjA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PkRYrnBL;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.141 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792039460;
	b=3FE+zbj2+oaagOInWREpt4vA9Lo3+EefURCMKjy2gsGXRLaPHBbCpyWG7ISrzR5rjne5Z6
	ed+TXYaZxy0MP22iLtN8XHPNSN1d/VhQqzzDYVM6I1oZbWPjPyUTAPTGcGSGP2mu30eVly
	GfLQYW8rnGXihiYU8G8/gB9J3LvgA5A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aGlnLzyGCL/dDUNRQSSy9O1CUukazj9+owEk42tU4Sk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792039458; v=1; x=1792644258;
 b=PkRYrnBLZZFWCXYAxaaCVkGcKqzqvPoCx44L+E5rg+xZj+44Ouk3JnTqPhCILKucMef6WZlr
 8lrNf3OHaqDAucJFqzivscxgmEtRIl7AT8wittC7jhn8QqZFEnevwBx4KrgvxIJJpdVZIlsPjK3
 vFDh1OpbN9DgBXNCtNnfLaqk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a0904006b7d12751;
	Thu, 15 Oct 2026 04:44:18 +0000
X-Mizu-Trace-ID: a0904006b7d12751
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
Subject: Re: [PATCH v5 5/9] mm/collapse: state what a collapse may do in the policy
Date: Thu, 15 Oct 2026 12:44:12 +0800
Message-ID: <20261015044412.58610-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261014171145.3292736-6-kas@kernel.org>
References: <20261014171145.3292736-6-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4FE7140002
X-Stat-Signature: wwbtmrjhub4j83op4mjcjjjoh1rboad9
X-HE-Tag: 1792039460-575220
X-HE-Meta: U2FsdGVkX1/OuYz7ByV7VJUgTCYqDeSEIv0E3AnQC5Z/STDZERs8tFUXKwOqkVsFIWwohleRFGjrR8veW9WPSUmAppqX8tzLeSRKAWpUI/NG5RsFn6nlIoM0BBss3lur1+6YZYJB+VJ9pmH3pQG25N2hFHjqoawHRc6IaSFkIONwOd2t1rbr3dBjMOPSDsIAlEmPuy78iPH7Uo7XJCJoQc+xZij44jBUerMogrnvHw+OxLlDwbQJ+ZWkE09CwD4B1DK8xAR+fjBlK3TvTZSqkERDxbxi+Wsvu5KgFpsl5W1KodouCTHtKi36djIIFNvoUfRu9RpU8q6eZ0E/pSy9m9lVhzzt5g3lJXRw4r83sDxkUF53fNa0MMhqYtL0MK6UTa+HPuRIZHrQXzlIf7+s7d+aC0UrFAHhs/0ZJCCkqCbPnLCDKnJzZS/38h3zfe1YyIwJi+rvc/mAqahAorljWo1aMrBzVLXNqhnoCQTAr3VRV9kofa9UYMb8XhYnobTgV1dSWHtqVkJcSGh8w1i1dz9ulW2K92CyyMCEF8KXGZUY8OSFvZKseh1i7kRBveJK8R9QDG0Jsv7vCfQQj6+hPKY2vpj7AbNOstKW/hP8CUoPMVWbvuiqi9PYbJLKlBoZrm6XvzQbz0Ly0sdsxlL2MoJDTvyz6e/qJ+tE/uCmjtqxheih02LEeZt2QjvAwuZ8aKPANM7SkHf9lo2jEDytovUAvimL58fBzKAvQSo5xQZYnKfuWwY1BEW/FgFBBd9MP6XHLtLyyF1qYnewaBSRhemmcmmTuz8yc9MpUIa1tug5GKxTnRry9GsFVQTmTWkwRh8rvwujntl7ETPhZmgqwyoJtce0Jg95Uj3NXAm5sPuvx3CmWuZpTdQYec279P2LXJG9krc7LufHzWGdTUa1ifooNOTScD0cbRwGnfycZQ4udG4wHIkkmUQvN4y7UTSKtj0Ct9aFgjgmVD3rDNz
 4gbV5cyP
 2pAJ9pC/Ko6wA4DPTS4RnmNmP059Q35lTQUL6JOxjeIvHTKsyfpO4Dbkqi9HunBFNsO9zrGLqAU3pdQ4ZlLY06PXOZ+EDyuuAW4DYmMM0PniSAkaBTV4DXiDl1K0YPCkP7JjpRr9SSF/JCdxWB6qqFGMdAbdRZWoVqu+2LWkroW9ILvpn/nWDWw4l5Tu2W405t1BNSmAyH1o3o1AIanI6uoggbQOQjsqwhX3WxPGjOetBuPGfX+R2x4ieGG6Pvg+1OraHojzxp1pFYmcblTABngrZtTWoXFbseniL7YQHV485+PQ4yje242HQNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Oct 14, 2026 at 06:11:38PM +0100, Kiryl Shutsemau (Meta) wrote:
>Tests scattered through the collapse path decide what a collapse is
>allowed to do by asking whether khugepaged started it.  Between them they
>settle:
>
> - which VMAs are eligible, and how hard to try for a folio;
> - how many empty, swapped-out or shared PTEs a window may contain, and
>   whether a sub-PMD window is held to a stricter rule than a PMD;
> - whether a range has to look used, and whether a MADV_FREE'd page is
>   left alone;
> - whether the PMD is mapped as part of the request, and whether dirty
>   pages are worth writing back and retrying.
>
>None of those is a fact about khugepaged.  Each is something the caller
>decided before asking, and the collapse code should not have to look up
>who called to find out.
>
>Add struct collapse_policy for the caller to fill: khugepaged from its
>own settings, MADV_COLLAPSE from the fact that a user asked explicitly.
>Every test becomes a read of a field, and cc->is_khugepaged goes, having
>no reader left.
>
>The PTE limits come as two sets, one for a PMD-sized window and one for
>anything smaller, so that the helpers pick a set for the order and read
>it.  khugepaged takes no swapped-out or shared PTE into a sub-PMD window,
>and empty PTEs only when the knob says all or nothing; the warning for a
>knob value in between moves to where khugepaged fills its policy.  The
>fields only one side reads say which: anon_ or file_.  David Hildenbrand
>asked for both.
>
>khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
>call.  That is the one change in behaviour.  The max_ptes_* limits and the
>defrag setting behind the allocation mask are sampled once per pass rather
>than on every table.  A table scanned early in a pass and one scanned late
>are then treated alike.
>
>collapse_file() also drops a NULL check on the collapse_control.  It has
>one call site, reached only from collapse_single_pmd(), which dereferences
>cc unconditionally, so the check was already dead.
>
>Assisted-by: LLM
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

