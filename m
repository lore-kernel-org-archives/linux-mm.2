Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F711CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 06:06:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C391C6B0088; Sun, 18 Oct 2026 02:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9256B008C; Sun, 18 Oct 2026 02:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7A56B0092; Sun, 18 Oct 2026 02:06:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2BF6B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:06:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01E1F8048E
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:06:29 +0000 (UTC)
X-FDA: 85334712540.14.2C58704
Received: from mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
	by imf01.hostedemail.com (Postfix) with ESMTP id B9E3040007
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 06:06:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r2yw0M3D;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792303588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1muDN6GiSgYXQ/VZo3E7DKlQxGLCpvFE95jsLDz5R0w=;
	b=5BLWxgHE/rVf6uJL44jIEb/1uD+GXWoGXGD830O/uzTxw1RWNAGNjNaWa4eKhYXXdqlkJo
	ZSNnJFsKnYreymTs0l7Hv5W1ykCNye4fsHeigtICeYqXUUUqN8VJjUn4fRO692ZYCmhlyu
	NgmvuX3VqOHHvggo1QYtm27fqGp7MrY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792303588;
	b=oPkOVQ0FblVffDRp521OzkFxKcv+QFsmi9b2R80JNtXdmBLSb62ioaoLkPUQA/rNd+tZYh
	ewTRIpBDM7Y3SZ60MYE9nfwButOj6ndPrZeAUEKfNsdBtkqpa+EmVKpcXV5mqyjTuOTz9l
	gANz+CjRhzMzR10uX91ymueoVkm307c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r2yw0M3D;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=E4jhTrD/yvx1o3PE+1enlxeStAvJ4cEvw0ge3yfhvfY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792303585; v=1; x=1792908385;
 b=r2yw0M3DR0o5thzvP1Tg3WKI8ZBsbx7wKg4Zn/Bx2owQHrcPOL5dcAKrBlynblT5g/f6lhKf
 EpqxHd9ZLRMpHVzr9zTqBfe0XQJ/7QQG1aoPolOE+3tjVBQ8tNr/RAN9IRqFhd5ZVkobCF6LQOa
 eIaRpZ2Tu5YHWu3N8YvE+n3k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 294eb343e70a89c9;
	Sun, 18 Oct 2026 06:06:24 +0000
X-Mizu-Trace-ID: 294eb343e70a89c9
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	muchun.song@linux.dev,
	osalvador@suse.de,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	agl@us.ibm.com,
	mel@csn.ul.ie,
	riel@surriel.com,
	peterx@redhat.com,
	kas@kernel.org,
	rppt@kernel.org,
	josef@toxicpanda.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 01/10] mm/vma: don't leak the commit charge on mmap failure
Date: Sun, 18 Oct 2026 14:06:19 +0800
Message-ID: <20261018060619.12762-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261015-urgent_fixes-v1-1-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-1-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B9E3040007
X-Stat-Signature: 9nejjwba3erw8c19t8yint1prwugzqjx
X-Rspam-User: 
X-HE-Tag: 1792303587-751072
X-HE-Meta: U2FsdGVkX1+PIver9T2DfF3leon2iupZt6sA+1vfSyQnDs9FtuwyMotjSefm9XgrYjrgmQCcUTvRDZA/GA1bQlrbDNEAGo+1l0k8Sh2NCixtyKP4c6vfroHynywyjnJj9xLUd5fZhcoWOgdrZP78xD78v9PWrMEf9ZCPV0FZIQ1yLk3cf2LcktnJ8/evNsorvwAWf3YCQxyqE34FGghhQa4+eVm42bxR89boSsQokr4jGAYtH0Tc5V9oSw8R0r2cOQ2VV0ef77ytt4JRec4dagO0Rf8YZavgWd4R/ZjNlzgEwbqe+bSJFRtZEXr/16zEtjl0qH+Ry66+azo7Qr7qqLdWhphVH6+2nN9RstEOid034IoWC7FCel6eMNLuFDjO52bZI/oBkGHwLBy0B1sng0LYPeaX5FBxXDJTuy//LLT/NoK46c6T7jlgAieJ2ayyj88dPus2Zq5BhFOXOMDSmQ0Q/7kSxcm1SISvU8KNQJ1UhWV3n0jJ+tkAStYuc1a/d3ZOkO2tyFU0tFa1sVw1bbvUwVb1xE7yTAXaZRu4gr1NJz+MHhBqGEIcajN1QwTr1+hTzeRQC3inGgWgAF1Nyi2UgRzG26DkmAHmz3m42yHDOqXIDNTpqa9lKuZSwYq1RZkeIeaW36Gf1pPKMxQ6urqpBWcYf20104Emk6Vg7Q7qgKfnMQNnXkGcv5UVM7Xr6HPQRGy9aYtxDL2rIMehg/tFOBm+utIJ+sdl7mqKI05N9iuAEzcuG2V0/LzAWzD5YpDinpyPxwCQn+eH9iJsjL9GeL4wgRaqVQVwahRTvTETDRHT4DT7wEOSLpaRGdJKDaPLZWGta2sLy3OMzbc5yLjSAGAV9rCBKWnkTBphrFK9FvzFKXjG0KJOPNOYjIxXsxA8AY3ufKUJHpKynNjWkVQ0frAoDdqZ2Gf49vTNmYb7cWvz/6Z7UT8BzovRb/sj7ZcGHNiKQQnpPr032R+
 I68foMCZ
 b7lAwVF+KO2cwgpH8oHHmshUV9AFwDTLHXhhwoMUFdJeoMLANp4UUdKSyJh826H/BS7TTUmub7rYnS3A4Xnd+Gz/R4OZoXDejHQIZY5YmeGqoVtJhMCosMwoZOSVf8I8I8R80fo3y0atep4dViJ0YJ4C5s8hrOCl8EmvKnZ7P+4FWseTXjs/3+h4DU20xH2CekbTQ+zTlKOr2gEmENNWJL8zJczqxWnEMrgC4DNXdqNqDjNJXE4VmiiROU+NtStX4/9Tm2g7Lipn2kAc0i/he4p0Vj8/qQbGnymdApt5yLR7Nnp1zUQ1vt7WlT9dPvnI44yn74c1blXbHlS2NGeo7q1r0SbdhqsYNzAVnL3FpINm3btEDP8V5gyCW6jSEni2IhQxZ2bOWKJylFbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Oct 15, 2026 at 06:07:07PM +0200, David Hildenbrand (Arm) wrote:
>From: Josef Bacik <josef@toxicpanda.com>
>
>When an accountable mapping replaces existing mappings (MAP_FIXED),
>__mmap_setup() only charges the difference between the size of the new
>mapping and the VM_ACCOUNT pages it replaces. It then zeroes
>vms->nr_accounted so that unmapping the old VMAs does not return their
>charge, which now backs the new mapping.
>
>If the operation fails after that point, the error path returns
>map->charged, i.e. only the difference. By then vms_clean_up_area() has
>zapped the page tables and closed the old VMAs, so
>vms_abort_munmap_vmas() cannot reattach them. It leaves a gap and
>finishes the unmap with vms_complete_munmap_vmas(), which uncharges
>vms->nr_accounted == 0 pages. The old VMAs are gone, the new one was
>never created, and the charge of the old ones is never returned, not
>even when the process exits.
>
>No privilege is needed to hit this, only a file whose mmap hook fails,
>for example a socket (sock_no_mmap() returns -ENODEV):
>
>	p = mmap(NULL, len, PROT_READ | PROT_WRITE,
>		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>	mmap(p, len, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_FIXED,
>	     socket_fd, 0);
>
>Every iteration adds len to Committed_AS for good. With
>vm.overcommit_memory=2 this lets any user make all further accountable
>allocations in the system fail with -ENOMEM.
>
>Once the new mapping has taken over the charge of the mappings it
>replaces, it owns the charge for all of its pages. Record that in
>map->charged, so that the error path returns all of it.
>
>A failure in __mmap_setup() itself is not affected: it happens before
>the charge is taken over and the old VMAs are reattached with their
>charge intact.
>
>Original fix generated by an LLM and sent in private by Josef.
>
>Fixes: 4f87153e82c4 ("mm: change failure of MAP_FIXED to restoring the gap on failure")
>Cc: stable@vger.kernel.org
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>[ david: call variable "uncharged" and make it const, adjust/simplify comments ]
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

