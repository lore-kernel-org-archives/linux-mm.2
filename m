Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5077FCCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 08:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2661E6B0088; Sun, 18 Oct 2026 04:21:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215EE6B008C; Sun, 18 Oct 2026 04:21:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1060D6B0092; Sun, 18 Oct 2026 04:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3C3A6B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:21:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B12B1A04A9
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:21:31 +0000 (UTC)
X-FDA: 85335052782.06.1275B72
Received: from mta1.migadu.com (out-46.mta1.migadu.com [95.215.58.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id 091A140005
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:21:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dXWnS8MU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.46 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792311689;
	b=auRDGdu3NBL3uv0g5DkOmFDg8oHpD9lH8w2kzKRC26NaBtiZkG9f6qEj1EchziPLWSlMU0
	RiKcrGAkYV+1CFLs3kg9epTv734out/JzcWKdFj2nGtzlhtKpKFBFAoQWbX+K/hJgAGdOs
	woupDoxsmCWw0hRfEFl+xb7uDi4rifo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dXWnS8MU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.46 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792311689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkwMSjjyZCzV2/dlxYqjMjedZn/KVaTUOWj9PENo0AA=;
	b=rkI4ra7AKXtCdbdyQEVrI6xxNXigDj5bVxsOwYrhWwepXEGuQZSs8NxhAfaffPzjEO4+On
	YRNilDIZMJGkL6rP2WOxqZXyMSwSy2tILzv0TsGA1s+fc0glkjA2iYQN9nibLu7oIaaV4/
	q0F44w5kkHIRoD40XXGV60yUvS5FUYM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sN5FiXCvtsa5hp2sSKXzUhp4xkTvbR9DGPpqAMU5Ii0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792311687; v=1; x=1792916487;
 b=dXWnS8MUqti8KJSWxPrn+b7tCzZ5JZrmaPvI8tD3/kvgZ/DOjUrS/DzJZWveUzS5U1qVbJd4
 wpVYVUFTdHmkkBxHdg0kqoFiOo4zpkbdau1fgHBzM5cPBwTghff+JDmjhRzEFf0UazP8rs8tb4q
 cMF9chUoY5ENSeUMCMC1uElA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 39d921597cd8dcbf;
	Sun, 18 Oct 2026 08:21:27 +0000
X-Mizu-Trace-ID: 39d921597cd8dcbf
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
	stable@vger.kernel.org,
	mason@kernel.org
Subject: Re: [PATCH 09/10] mm/hugetlb: don't leave a uffd-wp marker when zapping an RWP entry
Date: Sun, 18 Oct 2026 16:21:13 +0800
Message-ID: <20261018082113.5548-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261015-urgent_fixes-v1-9-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-9-42796911043b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 091A140005
X-Stat-Signature: yh7std1j8onqoj77r5uus7qksjqw86s8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792311688-441885
X-HE-Meta: U2FsdGVkX1+f+JdYXc4YEFgPA8xM/56cE43Ts2omuhIfKOjEsXg+9kkPSZFg6b/+L+Mti8PCU2XW80SlY5/WJxs7cWYV3qC/LBWWZYYrtYq6+bnZMIrQ6bDw5Vc18jkwMdJgG9w3b11m/dcInh4cCfmbe60Ke5t+OYmhnk7B2S/+FMF/MU36GVhhGNX8YfHUzYEbZdaLhp3XYgxWxbdL49Z85XzCwubfF6QqU0QNtCAZJ6zgfFLNNoP4NCKnZC/dugQ/1LKVuNRSxk9Ljikd6LN71gwYrN87RE9n4BI98bM5UBC4ngww0bYRW+6N05zyvxcRgNf5tm1xYRZ8cnDuLd9KOOG2mCh1uVPiGmamBbUp5Dz7q5TuJ6z/zeDvvNHvPyCNsPQP9F7QSPbEcADaMGpjT6U+f5PzjcdzctoQKa4u7dZhzg7Y/25V36Ib8f0gIcQ28DAK+cnriayoy4tBpLiLJlzmVssCOFHUjWPtQMOQvQ1jucdrIhGbz8TjFZRmbhhIpeYP6OZY0T5mXSA+vgAqq4RQuY8TX8eE1mM84bVi3Keadtmbj4zb7w5uK0cETVPC25hCl9aYkC9g/9o14Fs+C/+Q5cx6UQfLdUL/I9zV24sIA0TjCKKAoGtDUxyY9i6jB7SUCIYDoc8mvLsXKr0JwaWiAABEsLhaSr8Bp9gnhvfzxJ6fS6IgcVoWwwxQmthcOyxXX/VewhACn89pCGLy/yMSTAK7/kWZv+G90682q6N5n/D2ZnANuDSxzHrKfOcYJSWdN7JSw7hs0LcjSB+92K0CoAIuMU+YFp/rxcsPoLsee90/dKDp+geejNT9h2rSWQEblYzEIxoDMBg54CrqL1uCvKEGikMJryyfWLR+xollHEpl79jhfZ2+SSi/fmFDc6WpixVq8vafSWTAHWEY+lqaOILw/JwAnJZm5inOPAB/SSUX01JuJGsQMshoY7vYH2bB+tahGNbM0fZ
 iTiya5uK
 kPSlDSot6hUH+j9wtRwMXl/oOKeIFZzfpgFFoCX1VDjhDk/YRNGTD+VVotB4HWY72XPuQvVRbPnMcR6aEBSD158U2RQ7HHNzFK6hKETBnm+8tVHWC8Og+dLk9mB7SAiktNR6ALo5erIp6WTmWwd3X/cSbfHCEo76vsk5sGl71oymcIbg8URIV9TPDJsbIBiuu2gUkC5Fi2Z5La7zU39tyWGXHJq2yap9lQCbUo7kWasvuiUwuB5d9ciUp3RfGD0zWIuWW2fGDnG1Ub+RVuczTNSKfnNYe54vxhDWkxv07HqynWfpS4kj3hI54P1E078wAYJLBvdVMuzwm6zNJtawIdXZB+s6END8qSj7f8602zYfdaewVBUxHYf8CegsOppwHsetoyU/La9uj3Qk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Oct 15, 2026 at 06:07:15PM +0200, David Hildenbrand (Arm) wrote:
>From: Josef Bacik <josef@toxicpanda.com>
>
>An entry that is protected with UFFDIO_RWPROTECT is PAGE_NONE with the
>uffd bit set, the bit that userfaultfd write protection uses too.  When
>__unmap_hugepage_range() zaps an entry with that bit it leaves a
>PTE_MARKER_UFFD_WP behind, whatever the VMA is registered for.
>
>In a VMA registered with UFFDIO_REGISTER_MODE_RWP that marker means
>nothing.  The next fault has hugetlb_no_page() turn it into a present,
>read-only entry with the uffd bit.  That is not an RWP entry, since it is
>not PAGE_NONE, and the VMA has no VM_UFFD_WP (the two modes can not be
>registered together).  An earlier fix solved some side effects, now just
>stop the zap from wrongly installing a marker.
>
>Leave a marker only if the VMA is registered for write protection, both
>for present and for non-present entries.  The zap of ordinary page
>tables has the same test, in cond_install_uffd_wp_ptes(), and
>hugetlb_change_protection() says that "uffd_rwp does not install markers".
>
>After a zap the range of an RWP VMA is simply empty, as it is for
>anonymous memory and shmem.  Nothing changes for VMAs with VM_UFFD_WP.  In
>a VMA that is not registered at all a leftover uffd bit or marker is now
>dropped by the zap and no longer kept alive.
>
>Original fix generated by an LLM and sent in private by Josef.
>
>Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
>Cc: stable@vger.kernel.org
>Reported-by: Chris Mason <mason@kernel.org>
>Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>[ david: a bit of description overhaul+simplification ]
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

