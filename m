Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A6721061B17
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76F066B008C; Mon, 30 Mar 2026 12:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720206B0099; Mon, 30 Mar 2026 12:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C896B009D; Mon, 30 Mar 2026 12:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52A2A6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:58:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D60FA8C048
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:58:47 +0000 (UTC)
X-FDA: 84603338694.16.FD081B8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 011288000F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:58:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=R+KSHUsn;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=R+KSHUsn;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774889926; a=rsa-sha256;
	cv=none;
	b=XMWNCKXaWae8H5mly1QE/mxQszRuzMgh31hJ+gP4Hy5fQLQjNfAHpyaJ154LmWyvllS0EC
	amkZZT3YlQMNmiKlAL1jgmtO87Lc9L8MBzHWOEMek5yj7f4Kik5IFEltie53hVuz3kkfIy
	MAct1acaNJb1PYE6SYCINkmGjSY9yRI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774889926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTYcvaP5MEZnE+DljoPd73awiPBytEGfcZ6MHlkjhGA=;
	b=S8l0vKf7rfpChSKH51wEQlHDcuYzaTOZaPN8zckeatlRrYXYTpzgww4UgwomMJmT/kStM9
	+eTs8ELDEKtIX9kEtxaD7Ac4pFlxzGm454hFs1lcKkuLyGhmTjR1heCZBn1b/EQ6u9oudS
	0XrvnHLIT4/I2i8DThHjxcvDMRqf1kk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LTYcvaP5MEZnE+DljoPd73awiPBytEGfcZ6MHlkjhGA=; b=R+KSHUsn6FqBDM6KGGgxGj/Cz5
	bN/ZlNffp9KiVMc1nTrjrIIRvoWeIrimELIrliaHthag29/n0qpvD056G6AlgpwiekIx2e5aXWZIx
	Co0B1gG4ciOcSm0kV0C6iVZe6jiaZeSeVVs5cjJdzOONR3pPfput9jGav1GyzT0eqJPkMb2Twp8Ss
	0J1byszlS+zY6BY63OJFURoYN7LQM2/Qq/YqyO2f/YNwdVxW7075NyzG1u3op0PWbVrhJ65Zr2wTb
	N/BM0a+FKiRiiQvjkOpyi/Pfgq5zBORtaPDe10yNXJbCwIFHa+jR4sNvJ80Ze9jQF5A7FCfarA9LR
	+w3gOueA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7Fwb-000000071eX-3KA4;
	Mon, 30 Mar 2026 16:58:29 +0000
Date: Mon, 30 Mar 2026 17:58:29 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 07/15] userfaultfd: introduce vm_uffd_ops
Message-ID: <acqrtd7E6UxrX6Ji@casper.infradead.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
 <20260330101116.1117699-8-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330101116.1117699-8-rppt@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 011288000F
X-Stat-Signature: as84u38fyw99j56hqopm7a9fgk6c97uo
X-Rspam-User: 
X-HE-Tag: 1774889925-355087
X-HE-Meta: U2FsdGVkX1/sN5JYeBgqrncfmpujv0EZ4UCBV9nIdb1hpjmUl2+e/Ax2HdFUfbOkydKF4S1ruiYBuUXd8WDxrfRpUNj0MeK7oAI5MDZTSBZCboui5FCDgY1Aw2NqWRtwkQekBMXNznWVSbY1B34GAJf0+fFJifXqhXuJO/yYqnwpZO6QIAkx0Yr2lDQK8XczqeZX17vQN7EcsdAYhGMYeeOl/jxGGe1w3VyX3hcj+E/wSxchSw5iEDVuomArNwZ8RYDYAhLNC8S2HhrB1uG1cBqQBzBWYYLxCFSwwvhzJcPjAQH+HbkJNqNX/ZS/RuTX+XDXnnywJNPMkui5z+zpc0dw9HyZb9ZUCUtjB4nIxbWYSSSJ3mGeEdk6D25bQJm9Pgn7o9YJLAwjBuGlQeT0e6HHZup4haHPlbWtfcy0hAS2VjLHvjk05Ld/1ncvey0hORKOdbzCXk41o1N+T/nqpaNArxrlINvGZIL9kecn/oj61lQpOwO+3ZMU5goN+6wxCSGU071c+2RxSHQh4AJ/qdk3/IRtHpChLIOE5j27+qoHv5YZQvUK+WtfNeqO80vT6NrNUgyK0LPz/7IhcAKzMzqhCnLZenxxBWBt7tRcUnMjAgfVMrVJog2oWEHJYgCJPVGykAdjbqVmmdq0Tn3rqcT+t/xm+0orPEM7HdBJjV++x+xt7/5fgFFlOmKuROq5t9hraRmQaV48ORsemMpDp5eaO3pzMeAQ+mJ2ympLgaqJs3PQXgZ2jsiGlOWmnPMkxSj1zPfsqJRQboxLV6B+DpGNn+ZVHvJIKz8HQ9MvKUIz/L7N0QGwtuBse3fC09C6YoGKEpfdEkCjno0AEhvic0xadveAELvTtlJb3ooV01OLyFHlHcHNV5QcTsStrJZh0IAq2YG/2U1A5+MjmLOJrMr9oe+SrS/qOx/Kq65b5b57N+zmpVcKjQzlfe6yTUTU9Qk4Ze6T7JBiNZhEHlu
 CQoxXM4T
 Yvh1UhAkccYOA2A6m0XIGRzfRxmLzZ99R6MHApVxxZFPP5PCpeGFIWdqT0pOz7BTZ4XNcY2VRrnLv4liJESnNtSaJ/mM6OLqk2Wpx0wPl3fRCD0Mhm6j4GUjBWyMBrAd/5l6Pl2c2ok4e4c9AOhu/Qd9ofOgyO8+SN/pPwqI2yaTi1BztryVfVtT/DWEFvELt3bkhrWTg1OvtDdbGDHw3Mpek2L5Zv0Te6smh66hPTrQglFH4KeBRDF9ccxA24opo0ZjEqKeluEOVxtjqjTboIwG2rTppuQUX2EY2pkqkYMyeRko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 01:11:08PM +0300, Mike Rapoport wrote:
> First, there is no fundamental reason to limit userfaultfd support only to
> the core memory types and userfaults can be handled similarly to regular
> page faults provided a VMA owner implements appropriate callbacks.
> 
> Second, historically various code paths were conditioned on
> vma_is_anonymous(), vma_is_shmem() and is_vm_hugetlb_page() and some of
> these conditions can be expressed as operations implemented by a
> particular memory type.
> 
> Introduce vm_uffd_ops extension to vm_operations_struct that will delegate
> memory type specific operations to a VMA owner.

But the VMA owner already gets control of the page fault.  We don't need
the vm_uffd_ops to be accessible from the vm_operations_struct.  The
page faullt handler can pass a vm_uffd_ops into the uffd functions that
it calls.

