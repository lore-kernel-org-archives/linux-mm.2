Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79CB2606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N8mR7pat
Received: by kanga.kvack.org (Postfix)
	id 78F886B00EF; Sat, 14 Nov 2026 12:58:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73F326B05B1; Sat, 14 Nov 2026 12:58:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62EE96B05B2; Sat, 14 Nov 2026 12:58:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 454B16B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:58:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6BFA1C22DA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:58:52 +0000 (UTC)
X-FDA: 85434485304.23.FA021FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 08BA520006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:58:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N8mR7pat;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794679131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HQvy3Bf+SmAOhrQqSVfFUq9G41+E/cdawcP+LkvJ7k=;
	b=E5tMiFjRiI5XuC/IEk1oq9hbvqyPBerrb7KvFNqDn3SlG6AmDhclO71Zot2OPni2J+YDfk
	nd2ZYmMh7RTqttZnTgxP01fH8dmBXojfM0pyXgpXhqy7dXYkk4yoeeI0778qUeKowTz7tP
	NWNhAC/aAum8a4Unju1loziq+YxNTdc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N8mR7pat;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794679131;
	b=jfQ9n9GOYuq4Qc08ZoSUECED1wJ47eVh50lVctxeXjIweWh8lAoa+vBsOC7pMYf3Q70llN
	vslOU/WQpWLMQz9YVieAjqgYACQs/x/2yMzxyen73GrySjVOpEJDivyY2d93IFITrLlMcK
	Wtbrjl+VZ4WYP7wd8Gn+qMM1GQJ6oJQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6330560D70;
	Sat, 14 Nov 2026 17:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3851F000C4;
	Sat, 14 Nov 2026 17:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794679130;
	bh=/HQvy3Bf+SmAOhrQqSVfFUq9G41+E/cdawcP+LkvJ7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N8mR7pat/AgWFEZudjyHd7qJBB0qQTOZWAzhwI7OKAco/3FMbPxpm7r6J9z2NrL5K
	 zZXPUFSkOwIalYeVT18FocvsBKg96UZd5zOLhGAflrdGsckEbf+bMqkdTquefCO1wP
	 eSUTsPFlNyU/yvae/e7nKC/z5iHwTytOrnpqjJW9Nrh3KEwZiH8M/G2j3RGSZILKyi
	 x0TDM8U7JFia1yyzVyYUvzq1uCt2k3vFI8O/t0subTSzLfoKO0LUQjthEzGudkGUNP
	 qQcj6uLH38Z0cXP+LUByAoxmrAp62uB/S9dh9+AR0xOn7VtX0Rgf5A+K3ipjRgzwK0
	 svq8hq1b/3v4w==
Date: Sat, 14 Nov 2026 17:58:40 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/userfaultfd: prevent poison marker loss
Message-ID: <avihSinN3BWkw2sS@gremlin>
References: <20261107-b4-uffd_marker_loss-v1-0-82926b22704c@kernel.org>
 <20261107-b4-uffd_marker_loss-v1-1-82926b22704c@kernel.org>
 <822c1c7e-bfdf-4570-bf30-08f187e7253d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <822c1c7e-bfdf-4570-bf30-08f187e7253d@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 08BA520006
X-Stat-Signature: t59yxruz9476nuwc6zj9erjmuuaqz93b
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794679130-173670
X-HE-Meta: U2FsdGVkX18DCIpkJTmvy3vONxErYyw1DwzbVimD3cxcto6RecvIf9JHe8WduSTGN+Lu5HOv5HWOIK7NNeZ6Slb/IuCSLybwG7Ft2QRQU/4mOlS5EZ3d8WS9ZOBPQQ3mrb/1OUPLWr2AkKhoZdT/O3GyCeGf6dUZYBrrJvC4VS1/oSNyW+/eWQIlSde5dxZSJEcVmCxrioA4chBKVpERkO9d4cGHI01XKwe1/jT8MHXlZBMcPSZtktw44oQNeAxN5VHc+I3efIxgR5NenEnBu3EwvOoasEl0Ww+FTRuqZ0GLKp9DNakL5UepYLz021+456BAARAoDZL9tsxsBqqxgRLl7uZL3rCpauF+ULXopW7CqjJFPRBrut5Cg+EVXI3CiIwwxA9v1izkcWmOraYL3h2F8JUVTp7FM0pvWlE6z08PF6w8iEnDBRQOro9IESnf3QgZa0gZAJDpTii5Dg6OVmPt/teTDWO0y4BgZxguqoSIowrP92VmdB0NiVGLVX/vtbd5pHd9AkCwq9RnyttYXAyqoGMcw6kLH0dpapOU+M0WODwwk3n3uymbLyy0QbIeBotqWzYPvx9m1ZCqVb1yRkPEAwzQ7f35nje4P2Nbi3LThiQ3ZhbkohkK2YPH0ljT8h/YGsqOyyyvlYE8JDupLVwvBeBMrg01A6w5PQVBHxwf8IlB1KNyElQFqpqcGpZsUcxexoLCWYCoxb0jZA1STsWsn31Xlv7axplVTU8s603vl4bdy7HvQPJ6JBjjdOylW4ztHWqpI2c8hbuVAWp4juvusCW6z02Q+cLF29tnsY3KJc2twjjmyeVZFQn060tPooRQVoKcdOQfUxBhcqhP2pOX1rN3mxoUWxHCB3ga6kbzVFGX1aKmMV73qoRYrJJb65wgo3Nln6RLN4NwyE9Q++UVvSft1rryhs1TZiQvlhuvtFPVJUmF+XSl2Q1VHuCCDFM0NyfdQ2g3/xzsC7u
 vDSp5Gzo
 DCTKrKVFed2lRy0vF44oQd3aljcfZN3xzb6oENTW19XK4wLAnYK2yMw89hGTMB+gMAjUoEhwgDLOu/YcUkf8Mbvgv5qRgH+Is/fQSHPCLoHDzfJb3yXnLOtElQvBM+SkB69sbls9D6LOnZO6WWYuStURx78N+laJPaNNZ/zc6cy0QQ3DmsUG586ZT6MiidcOi1TMjnDrD5dqTMOLJg2DaDmOhos2pF6qSnub1DauZ11hqRUcM4Hk1dbpY1CB/DMonRO8maNY3/u2wMsdOZza15T+k+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 04:39:44PM +0100, David Hildenbrand (Arm) wrote:
> On 11/7/26 00:51, David Hildenbrand (Arm) wrote:
> > Unregistering userfaultfd leaves poison markers in the page tables.
> > However, once unregistered, hugetlb PMD tables can be shared again.
> >
> > Further, shmem page-table retraction can discard poison markers even
> > while registered in missing mode, and fork() can skip copying page
> > tables containing poison markers.
> >
> > To fix it, add VM_MAYBE_UFFD_POISON and set it before installing poison
> > markers. Preserve it across unregistration, splits, merges and fork(),
> > just like we do with guard markers.
> >
> > Use the new atomic VMA flag to disable PMD sharing and page-table
> > retraction, and to force page-table copying during fork().
> >
> > Move VM_UFFD_WP to bit 44 and make HAVE_ARCH_USERFAULTFD_WP depend on
> > 64BIT, freeing bit 12 for the new flag on both 32-bit and 64-bit systems.
> > Expose the flag as "up" in smaps.
> >
> > Losing poison markers, while unpleasant, is not really fatal, and the
> > use case is rather a niche thing. In addition, we rely on the atomic
> > VMA flags infrastructure ... so let's not CC stable.
> >
> > Fixes: fc71884a5f59 ("mm: userfaultfd: add new UFFDIO_POISON ioctl")
> > Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > ---
>
> Ping on this one.

Ack, will have a look.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

