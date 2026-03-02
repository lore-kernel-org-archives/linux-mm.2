Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5444DEA4E07
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 13:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 877706B0005; Mon,  2 Mar 2026 08:57:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E4D6B0089; Mon,  2 Mar 2026 08:57:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757986B008A; Mon,  2 Mar 2026 08:57:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 634316B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:57:40 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F28061BF1A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:57:39 +0000 (UTC)
X-FDA: 84501275838.03.42022AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0DDF81C0003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:57:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RBkuiSzJ;
	spf=pass (imf20.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772459858;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/h4jEtALbtoiFDQKNH5FnFSJkhWZLKgRIhaaB0Aynx8=;
	b=XKhc1Bnr+/d2/xztc25nz154dUkqTmNgesT39g9Tel8JQZwGFozaSYpHKZuVgeGp1Ft9Wt
	f9RUt+Vqf+vmxd4AojUDDSxEZDgpkEK9JzvI0luTCeomE9kTa/TzRehd5STpqm3ryeA5Ny
	vLckp73yijf30l9klB77Bhoh2yAPpBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772459858; a=rsa-sha256;
	cv=none;
	b=gwu0qcXqXzeWykx2XiWm33Ff3jKWkN6dNvwf4Da8xIGPfUPI5JNOXYlQOu6yJXc4CqGS9q
	KPi0M0BXke+1LsOjNKufxxSyLHBdA913IndBYOVoojk7SS2kplbL15sMZCbbXoNCNgOl/C
	vCh+HJ0IPelJHBjZgRbaOjl3dBCj+ag=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RBkuiSzJ;
	spf=pass (imf20.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7265560008;
	Mon,  2 Mar 2026 13:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26772C19423;
	Mon,  2 Mar 2026 13:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772459857;
	bh=5iYnK32dzzvyJuYT0YsGe8MIZxjRwNUxLtlTWSN7ucQ=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=RBkuiSzJ19xMqa1li5Y49aF40bQSdnanfH9HcVlxyEENyfve4bLC4yca5Pljz7XgJ
	 2116FbacPCVyp6CzCZAP24pUBiC1d9Oyf7XPf+RtCGzC2P7WBPMsbOmJm+mb+f+i1n
	 pw7qQv5fUrPBHOkL0Phumx00oAC126DjVtUbWkNJLod+PyX+zV8ceBseq26SILwEgI
	 pqTOI576ZVAcBr9CqpAnMpHUpUV2pFusQ4iD1iRVuMUBE7LVxjntAS4k0pxR3gDnmr
	 AQNHVG4BI3AYdw34Wo7onzWuZB3lf+b5qwgWmYI4Nnqhb73PtVzUO1rW/iNjFg2llW
	 odwGJTyp5tSGg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1200FEA4E07;
	Mon,  2 Mar 2026 13:57:37 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH 0/2] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Mon, 02 Mar 2026 19:27:10 +0530
Message-Id: <20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADaXpWkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDYwMj3bLcxJyc/GTd4oyizLxsXQOTJKO0RDMLi0RDEyWgpoKi1LTMCrC
 B0bG1tQAsCUzIYAAAAA==
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772459853; l=1924;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=5iYnK32dzzvyJuYT0YsGe8MIZxjRwNUxLtlTWSN7ucQ=;
 b=BKgLUNX7T5+1UaP68S9aSGWliNwqbIqEeeSBcb/pPTyr3ztcYx4XwgHAxmWrHIoo4l7Tb5wrk
 MDdDsWbd3r+C2DBna4RbPECc2AE/2IPrRi4vnPjbkySXBypYrM7wwdp
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Stat-Signature: 55x8q8b5f4oxbicaajkwfymz3946387f
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DDF81C0003
X-Rspamd-Server: rspam12
X-HE-Tag: 1772459857-91195
X-HE-Meta: U2FsdGVkX19700H822tljRCLB0ESZrLdBCMGcJ62ey2oy5QjyTcfAIa+wJVHyCBwxm/VniBVjthYg3SxA23xAnaG3ejS1HnWaPEeD2mL/L+jEi/u8Faoi5nghBZO+0u6fNltm6hczpqyOOYk6WLHIHRl88DdCE4y6MpXWd8m2YE97TQYvpx4PPxryS81nRLmBCYrv3pYrwR9hu0gzPeQYGMCXvJ4RGUAbZR2LJzHWl19+4cd9FQAU8jSkWRdSgKY0wkLaEP4y9LFttj8fp3DJ4XbvvR2QIJ5EIG07V4BaNCTfCPXDDxV0HMMpO35JiB5mMo2IiWd8K5kVjLYaufITn5Vm50c3tkTUqyY7hVJiZir77EGmWpHpOn6cblVMYop14S+2fiRY+RANHZ6Za6ZbRfjXGgJTthrnBKZ5jgXUGClPAtrgx7NjF2PApkxue/YVdVQthVl640bWzHBOU7dyUoWDi3KtziaJ/hjJ8nQO1sgxfV7m/qN2+nlXywNxOwSseXevE+FwBj/0zVyXhCppEMhKUHVnh2ob4xR0P4BMVCATVbAoG+15vWXarGCndx279a0W6h62DnzPWHUA5pa/RywsONnNNpRQagcOmnEch0ltslw2rx9plBASmH2fy+1MPm+cxbPz/gmoQNRjdAduXLl7DmepchFyPzNd6IsAaan+cJ3dLuHxbzXLRaauk0AoL7pShEo8Cf4pOujl6xGM2oOGhzWII9Ml4NSlTNinwmIs1UjoAgXcKfj0nivSiknwI2rzjIjH/57Qz4Bb1fqqflVINRg5drfNx6q+3fzvuxRLyyeAVj0/ctVPEWS9Uvmm0vo8RJ5wKcjHrZS9E/DqXmj218cKsLgD/3fAdR/+eblCaUpxBIku/zrArrxhxKiR3KERjXYNuItsn9NZnrjaLDNrpUnC7JPI5m/0B6FY9Uyqa08UswGxSbtRR4nYLN6+W5l8kEuBFwlJW6FA3m
 +OQemb9G
 PAxdZnZzA76jqog7eJNKRxtypQ1umaB4VBch+JKFevgLJdXi+oo8WOGwpExb0G/dRK77DsrPgsKx3XYPLF4j4g1RQqURQcp0KJ34jFOeBBi1uxz8ZjCxeWV95vqIAeQDBoAXiWXn4EiCRt73zFrSJZ3pK3ukF/iu1p0yshb10uNz36aFeTqnQoU6QFfYw42+bK1Vhq9Yhy5Y2LhLSQaGPNL5P3AezBuhafii/s4qN5bXCLqXRShew0rbocamqUSIkrNrP+NrFlv7zJB0y3c1B1zXVYja2qI5nMiHG1WYt2c7UydY3MnQyFMk8ylfc8PIB/Mkyfh0As1Cd7uvS8HhEZ+0DTN0ZaIYhKZ7L5hkdj7VBu3dcRg4aCfedcqQ1Nc2wFsm3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series implements the TODO in vrealloc() to unmap and free unused
pages when shrinking across a page boundary.

Problem:
When vrealloc() shrinks an allocation, it updates bookkeeping
(requested_size, KASAN shadow) but does not free the underlying physical
pages. This wastes memory for the lifetime of the allocation.

Solution:
- Patch 1: Extracts a vmalloc_free_pages(vm, start, end) helper from
  vfree() that frees a range of pages with memcg and nr_vmalloc_pages
  accounting. Pure refactor, no functional change.
- Patch 2: Uses the helper to free tail pages when vrealloc() shrinks
  across a page boundary. Skips huge page allocations (page_order > 0)
  since compound pages cannot be partially freed. Also fixes the
  grow-in-place path to check vm->nr_pages instead of
  get_vm_area_size(), which reflects the virtual reservation and does
  not change on shrink.
The virtual address reservation is kept intact to preserve the range
for potential future grow-in-place support.
A concrete user is the Rust binder driver's KVVec::shrink_to [1], which
performs explicit vrealloc() shrinks for memory reclamation.

Tested:
- KASAN KUnit (vmalloc_oob passes)
- lib/test_vmalloc stress tests (3/3, 1M iterations each)
- checkpatch, sparse, W=1, allmodconfig, coccicheck clean

[1] https://lore.kernel.org/all/20260216-binder-shrink-vec-v3-v6-0-ece8e8593e53@zohomail.in/

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
Shivam Kalra (2):
      mm/vmalloc: extract vmalloc_free_pages() helper from vfree()
      mm/vmalloc: free unused pages on vrealloc() shrink

 mm/vmalloc.c | 73 ++++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 22 deletions(-)
---
base-commit: 3c4ae63073d84abee5d81ce46d86a94e9dae9c89
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
-- 
Shivam Kalra <shivamkalra98@zohomail.in>



