Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05535CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 17:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490CB8E0005; Wed,  1 Oct 2025 13:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41AE88E0007; Wed,  1 Oct 2025 13:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329C88E0005; Wed,  1 Oct 2025 13:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BB308E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:56:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE6F756983
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:56:29 +0000 (UTC)
X-FDA: 83950300098.13.10F5A2E
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id EAD1740009
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:56:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=rR7ab9TO;
	spf=pass (imf07.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759341388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RPq+VgOKsxNu+oCprJxr+nljWMfU2DwvZUq2//omNlQ=;
	b=yB9JuN38kCRjwK0lj/ilrJAfDOl1JDUTFNQe+Jg4DfokynSH0R6n177WgU9elAq/Q5+FS/
	GyxlFLbFzbzsSaxk63v4WaKCDRh7DUCn7u7yNbGn+v/BS0E8n6hhXOaGOjasHhdHuwjs3A
	LlQoqJYxkmk4LWNhi3ng8GSxbjSFviY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=rR7ab9TO;
	spf=pass (imf07.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759341388; a=rsa-sha256;
	cv=none;
	b=CC/jVE5JUzfVyI0MSknk7EvxsDfarYOeKF2UdSj2e36OXhecVUePCTyOvtefxgPxGHQsMQ
	6b47E3pGgLiJMDmNM/Zhhvrzukvw6r/4ptlqU7Z8pBlX44OwkfL3QHs7Q/B/kxaIgYjruF
	Ld5n7DIlObYvOsgNYhTeJB/KpApy4PY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RPq+VgOKsxNu+oCprJxr+nljWMfU2DwvZUq2//omNlQ=; b=rR7ab9TOJwxAgwL9Z26MYBb6rI
	idhwdt51Y1nFIEVoY/Vr+I2R+5B1j2hbhnT8E/s44Zs4FW5FkpH55UPJQOInO7TXmzm+gm/Z759jR
	Q9C73kLG8AIc9/jeJPgnIFN0adb7xIyJVp44+nPVAbCAoqxfVhvyLP/+Et9wxg1JMWwlFH7oZ/3GI
	wHwfg+R321O2ydmmhX8pa5w8QYCLGeaJY1g25AMmAYLNXN4JuIvp36bx48PxDIlLMot/tDkDk1iw9
	IzNIqEAbr0uwtrvkceROmB861h37vEC7ggvB8qB1FyYyThWjw3WcQ305lwCl1nKpnNkdl5Pt3bX/P
	oHtEa4+g==;
Received: from [179.159.118.139] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v413r-002xd4-67; Wed, 01 Oct 2025 19:56:19 +0200
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH v2 0/5] mm/page_owner: add debugfs files 'show_handles' and 'show_stacks_handles'
Date: Wed,  1 Oct 2025 14:56:06 -0300
Message-ID: <20251001175611.575861-1-mfo@igalia.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EAD1740009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: sxmxppb7bhx6iqh6kyesthz6hmntiwg9
X-HE-Tag: 1759341387-940095
X-HE-Meta: U2FsdGVkX19T2V/TaqPg7I1EA15mIdsGF0UL9PkB2pbf76/5BQUSz/fFW0Bh3/qnAUolk0w2IWCnfVOwr/wTb/uGv0Lsn88T+GZZS6y1W3Q/ni7RlzbrQhNozF45BryFXDgwbYaJWeYOKuAzQpPHJrprvkaVQTDsLUCYD2E7+W1AsxQYdw63c0GRXFSVYto3NmGp+eupXyIyicNnf5Xx3i+hoGiOsIYXe6cDTrJsUZBrnA+mNKXxFkQ3eKUHkKpl1XFBqZDBanY0mfOtBK/iWnH7gPToWsnmD62is7dVwdZzpX836bDtlJp9hxhoOJz1EkRddtSGwrekRoVGwCHMcU9MCSLKhjf7bgTXHoLs4bqoEGa+BvhkjiXEt/vKYh6tY2yLyTFE0Zv44tcdb/6yKWZO9s9E/ZsJQauwT1VG8JOnKAeqSytAIXyBlybPQ4xUc3jYW7M+n9UKDRQf7qZuzWInOXLRUptMM2SumVGBwVP76r53T9Pn+z3fMFIeGa2L1af93DIYb4ACQHtFtHa1XwQ48KWOm0iI44XE2077npPatduCbgN4GCyPYd9EmFT2nc8ciZolLUI41VCRl8N4ols0yoa9hmJMYqrzhnIZWxYGQWNyc5Ps/s+O6eoY55LiGcTLfYhFsgC/S/OPeo975yuHKIrPG3nFm2l/u/ewq4eKOAMBsy5uv0v9kQ3FD2XfdClmqc222FlwBJ29u878cDWcIDUOZ5AJpquHUX+fQz1xsGZnHprpaLkrSKJePghRDxz/osXQijRjsQdPu35nwHgBrRb0rZkdSheoE28WMHiUBQwZ68vFANgY2ZR/2l8KDyaOBoCewJoBK4ABW3jJVq2RMxR6m3O5210nxG4vrQit1t0Cjfa2RwDWnADD3+u4DX3cu51YlMF+MoBstAlCgCOB9IhXGJUtd0Kq3nCx77YUBoGcPPoOCNSjYgoaV/VvYCwKhFgdnhiO8wYf/XZ
 kJkR0SHN
 JUQnBhl/AuhFGogY5rXFfhEeniR6ikiFTHEZh6lNCyPnIPCyppx5UxhjJbYL6UM200fHI+SNvz2AR3662p6z04NTU23WiV4rUCODI6XsMyCrbMrOD8u/Uenoa2kkoaLwrnTFeEo3xpTXa53CEAhtGx6mmXq3Y25GOrdQUEZZ+d08N+StBMy/KrB3rBvQKUU5tICb9ZVavK4500PeepKHuxy7Wl0mOiri0Q72r2UYeTPCuYcJYT/LtxACSOT15JONz0J8kr/1n+mT21KURH7Npne7CFIWKew8QFi701PLur+VEqTKLv/5NdHL7kgv4AxJLrcu2voEFRsLQT6UHuMiyy9PHrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
 - v2:
   - Make context/usecase and hashing in userspace more explicit
     and add an example in the cover letter. (Michal Hocko)
   - Use different output files. (Michal Hocko, Vlastimil Babka)
   - Add context struct for plumbing flags from debugfs_create_file()
     down to stack_print(), avoiding more struct {file,seq}_operations
     for the new files.
   - Simplify commit messages.

 - v1:
   https://lore.kernel.org/linux-mm/20250924174023.261125-1-mfo@igalia.com/

Context:

The page_owner debug feature can help understand a particular situation in
in a point in time (e.g., identify biggest memory consumers; verify memory
counters that do not add up).

Another useful usecase is to collect data repeatedly over time, and use it
for profiling, monitoring, and even comparing different kernel versions,
at the stack trace level (e.g., watch for trends, leaks, correlations, and
regressions).

For this usecase, userspace periorically collects the data from page_owner
and organizes it in data structures appropriate for access per-stack trace.

Problem:

The usecase of tracking memory usage per stack trace (or tracking it for
a particular stack trace) requires uniquely identifying each stack trace
(i.e., keys to store their memory usage over periodic data collections).

This has to be done for every stack trace in every sample/data collection,
even if tracking only one stack trace (to identify it among all others).

Therefore, an approach like hashing the stack traces in userspace to create
unique keys/identifiers for them during post-processing can quickly become
expensive, considering the repetition and a growing number of stack traces.

Solution:

Fortunately, the kernel can provide a unique identifier for stack traces
in page_owner, which is the handle number in stackdepot. This eliminates
the need for creating keys (hashing) in userspace during post-processing.

Additionally, with that information, the stack traces themselves are not
needed until the memory usage should be resolved from a handle to a stack
trace (say, to look at the stack traces of a few top consumers). This can
reduce the amount of text emitted/copied by the kernel to userspace, and
save userspace from matching and discarding stack traces when not needed.

Changes:

This patchset adds 2 files to provide information, like 'show_stacks':
 - show_handles: print handle number and number of pages (no stack traces)
 - show_stacks_handles: print handle numbers and stack traces (no pages)

Now, it's possible to periodically collect data with handle numbers (keys)
and without stack traces (lower overhead) from 'show_handles', and later do
a final collection with handles and stack traces from 'show_stacks_handles'
to resolve the handles to their stack traces.

The output format follows the existing 'show_stacks' file, for simplicity,
but it can certainly be changed if a different format is more convenient.

Example:

The number of base pages collected can be stored per-handle number over the
periodic data collections, and finally resolved to stack traces per-handle
number as well with a final collection.

Later, one can, for example, identify the biggest consumers and watch their
trends or correlate increases/decreases with other events in the system,
or watch a particular stack trace(s) of interest during development.

Testing:

Tested on next-20250929.

 - show_stacks:
	
	 register_dummy_stack+0x32/0x70
	 init_page_owner+0x29/0x2f0
	 page_ext_init+0x27c/0x2b0
	 mm_core_init+0xdc/0x110
	nr_base_pages: 47
		
 - show_handles:

	handle: 1
	nr_base_pages: 47

 - show_stacks_handles:

	 register_dummy_stack+0x32/0x70
	 init_page_owner+0x29/0x2f0
	 page_ext_init+0x27c/0x2b0
	 mm_core_init+0xdc/0x110
	handle: 1
	
 - count_threshold:

	# echo 100 >/sys/kernel/debug/page_owner_stacks/count_threshold
	# grep register_dummy_stack show_stacks		# not present
	# grep -B4 '^handle: 1$' show_handles  		# not present 
	# grep -B4 '^handle: 1$' show_stacks_handles	# present
	 register_dummy_stack+0x32/0x70
	 init_page_owner+0x29/0x2f0
	 page_ext_init+0x27c/0x2b0
	 mm_core_init+0xdc/0x110
	handle: 1

Mauricio Faria de Oliveira (5):
  mm/page_owner: introduce struct stack_print_ctx
  mm/page_owner: add struct stack_print_ctx.flags
  mm/page_owner: add debugfs file 'show_handles'
  mm/page_owner: add debugfs file 'show_stacks_handles'
  mm/page_owner: update Documentation with 'show_handles' and
    'show_stacks_handles'

 Documentation/mm/page_owner.rst | 32 ++++++++++++++++-
 mm/page_owner.c                 | 61 +++++++++++++++++++++++++++------
 2 files changed, 81 insertions(+), 12 deletions(-)

-- 
2.48.1


