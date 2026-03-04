Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA3A9EFCE39
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 19:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34DC6B0005; Wed,  4 Mar 2026 14:13:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE20F6B0088; Wed,  4 Mar 2026 14:13:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC37C6B0089; Wed,  4 Mar 2026 14:13:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC8A46B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:13:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B9EFC2265
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:13:19 +0000 (UTC)
X-FDA: 84509328918.16.955FFCC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf23.hostedemail.com (Postfix) with ESMTP id C2CC114000B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:13:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fNeUxMCl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of ak@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=ak@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772651597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VA7/XsYSppEH7lx+U0PpuqIm/IKl/Dr2xtGqZ01ItqI=;
	b=R91295K7kGE3nO3ehGPgAN71putFSEcDJThfuXM/Ko/JbRUQBeGopzcHjljKFSxR2os+/K
	vtM02R4fHegyXs0ltpXfyqjpqQGsMiwdwVODn69lx+IA6Jw4QFra0VzWio+dH9S8QZi9MW
	LMnFpOzFXmOmr5t9juipiP43zg86IQw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fNeUxMCl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of ak@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=ak@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772651597; a=rsa-sha256;
	cv=none;
	b=SCSlE450+GINMRkmua4meYK39GiSOLLNuj9IatHlsOMcmlh4jJM+IrvZmBH6KpCv/awKcg
	2yqufYCfo3CUAH1ZWqPHGEBeIDH2FKUbwpGp8c9b5ZfxCSA5v6XH2RO1TcHDaEmROLC/7X
	owHa90Di40IjhzBD8/U4ZF193fAdm8A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772651596; x=1804187596;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b+IXvZJh8ns5EqrEDMmqsPBUNkeb5a9KzDQ4X3aJa0U=;
  b=fNeUxMClk6n1AZqeskcaOzC1cE6/FHgEP1bGVFPi0ESD5kKOeU/eYL/v
   kNFxmBh/DRxPjOuFYuOy2GJ8LmLWtbhkubjS8qM/5AesEb5DqriUpzn9z
   uthENKpxg1pAkeYj2ygbyJgRxMyocy8lJLM9N00l/jS8QwpBW1GUr0ibw
   YAhR2UrLBgPYyVcCB4IxxHcNXRPAJXm9FMPFH/RaHKE6rQeBi2QOs29VY
   DRaCuI/2tQqcD3JWQV9J/pdiJJDiq/Oc5S3ehl5rB3VcUBt02tB3iKDXj
   0MiLtXo5el/VU4+yr4SlI4LyqB1esc72dGm/aEdz7O9gL4nz+tkgqhoQV
   g==;
X-CSE-ConnectionGUID: nM3gYtGYTRSxOEWWlG4+TQ==
X-CSE-MsgGUID: F5TaRZHDT1G5XbAOeeITXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="96340912"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="96340912"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 11:13:14 -0800
X-CSE-ConnectionGUID: EtL7uX+JTqS8hfh/H3WrNg==
X-CSE-MsgGUID: KnaHEQ3ETy2k40998L7Vvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="222584965"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 11:13:15 -0800
Date: Wed, 4 Mar 2026 11:13:13 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Vlastimil Babka <vbabka@suse.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH v3] smaps: Report PMD page size for pure PMD mappings
Message-ID: <aaiESWyCYikx6s9e@tassilo>
References: <20260303201556.107960-1-ak@linux.intel.com>
 <101ac423-252d-4ef8-a07c-34f5d59820f5@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <101ac423-252d-4ef8-a07c-34f5d59820f5@suse.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C2CC114000B
X-Stat-Signature: dyy1mykorzgoy73pkxqqeby38pw8j9y5
X-Rspam-User: 
X-HE-Tag: 1772651595-546519
X-HE-Meta: U2FsdGVkX1+RfD/f3QaOoqhtoqGRXVpQdiHvDUAe4S4PKIPw6zCd3ZCeH/7Fs4t4T3S7rEX3bih/0bWcOXRypfd/uzFuYSpfPYvf55jmpTnGBDZWOLQkN6s4D4RVCuhYK/Gg9QZbgPFkfRj+GvjS4xk8HcfoLhNuwcMuGjurM9my48jeEcCDDUnhXEWnfmOHJX9EVqOy/Qt+YUHLEEAv2UCGEvEQk7fzq4OUuST1z8HgzQop0XrrMFalg8zC2rQK8DSn1f0mGdQKx+/xw2j12r7yxCKQ/scrEuy2/L8FH6Macl9PEIGuT7kIaSrK8ulVmrMazPXC+JiQCwi6k9INxyNm9RX+iISPcRXbRDXkZc2SxDjeGt4zcjt3WAG3x4TQ7P955sdRhwyjdZXzWehg7Y+9sqOPTE+0FbfwQ6QVim3P40zp/94jewvEn11ogaUSUXg/OCV5DJyKar0jXUJ3NzKuL2jhJKwRAhfH1Hl4996ZGWaQN/n4BqSakVCaN7eSklCvhxZOFpJbAr6mqGxZhj2JcyWLLJeSXIK/URDhjl9pCT1m2y1OBjSz1Uu3uFrha+/uI/hvVdxQsxHb6ZWNi5wqRiqN1a8ra0B0nuImCEIjkDAHg87ys3/wQWvrVM+SfQpM6benuKe1gc5dPCrDh1LPTAPH6/O1yKYUfiYcdJpHjA9UXo/ddhoEv0wiqR8aiMxG+gPJoQSxKvX/uD/FyhpIFsSlRZ7HCxfw1kipP6V32lwqy9lF1TPqVuiK7+6nQlS5yUWiLxR6NAjDgBnrGJSFM61YEFH9bHBL9nP7NNbjuia8mFszFzHjDn4c2fMTpRqflDKcZGwIGypM/9mkP1efV+G+eWK08dweGTEXE9ra8kaUZv55ooII7M+yZvSEb6IrtHcO/BB5PXj3qgQqxbq/GrFS4/hW2dXhDirJ6qD7Q0SALjgoEwzuplLrPqoxdITGtMePnAtYHsLNte/
 6wxV39bv
 cTu7fAD9/KKjMEGPs9FIywjHlQYjOyZ0oAtEBxclX5UiAkIC2EV1cmV+RSVsmm/WIP8grrf8C14nu/PO4cUdKR8O/i6Y+lJN1FkAqABbXi/7YLZwseappdzfB0eut+hdL6CMqo+8gHIlieEs00hje9J4nHNY6tMMNCwMtxAGVFJHRwhn8r4WzntGyuEt4LKAQhcs0U0uEWUV1EsBoY8jGthBZBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 06:29:09PM +0100, Vlastimil Babka wrote:
> Why do you keep not CCing people from v1/v2 discussions? David said that
> already on v2. It seems rather rude to me.
> 
> On 3/3/26 9:15 PM, Andi Kleen wrote:
> > When a smaps mapping is only PMD mappings report the
> > PMD page size for MMUPageSize instead of the base page size.
> > 
> > This is a revised version of an earlier patch that tried
> > to report multiple page sizes, but there were many objections
> > mainly centered around compatibility for mixed page size
> > reporting. This patch side steps all of this by
> > only handling the non mixed case in the simplest possible way.
> > It also avoids a problem introduced with v2 that page sizes
> > for mappings with no pages were incorrectly reported.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Will this be useful in practice or just confusing? There can be e.g.

It might have saved me some wasted time.

I found the current situation confusing!

> misaligned mappings, or other reasons why there won't be 100% THP
> coverage. This all or nothing value (IIUC) seems inferior to the

s/nothing/4K like what's there today/

Yes probably multiple page sizes would be better, but I'm not reopening
that discussion now.

> counters we have that say how much is pmd mapped, so I'm not really sure
> it's worth changing this.

The other counters still exist of course.

I don't see how there can be confusion if we report the correct page
size if the mapping is only that page size vs a page size that is not 
used at all.

-Andi

