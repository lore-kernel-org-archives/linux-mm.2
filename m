Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4401FCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807776B0088; Fri,  5 Jun 2026 05:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF1E6B008A; Fri,  5 Jun 2026 05:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4F56B008C; Fri,  5 Jun 2026 05:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8026B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:35:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E671F91FE4
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:35:46 +0000 (UTC)
X-FDA: 84845351892.19.BAC733A
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3B62A20005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:35:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=iDfmlnHG;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780652145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zlWtZOvWgDoHJPvKqfNO3Eu581+nJ0SQLgmcmlXuYXo=;
	b=qP1RloDV1pFNNHxPrRZ1dKkCUYh4BX5BpGkxqt+Lu6hJrJdTNqgOyExk1yg/+86+EZwU9Z
	uc6gmjR4SmfFQFJd0631/yXzXCrHcqtZK/CRoQvmtjEhdUmEiUfouh/X3atQ28gzgx92se
	cIbcTKkAkgaMJgXXmV+yK0HsiQ1Xr1c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=iDfmlnHG;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780652145;
	b=oLjJ6e+Et7cS3Vy/Quov1zXAHfss6YOsFiX8D1igP+gaffvLrNmIVeiQO+PKB3HIdsj3Cm
	4KCF13aG9MhHHuQfu8We8xxQd5zTOw8viww1MZ4V5Pqx7n2zMDOh+9Lpp6j2KFtXeS3obQ
	jYzGTF4pWgVa4s5xga76Qrv9tlZwp/o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zlWtZOvWgDoHJPvKqfNO3Eu581+nJ0SQLgmcmlXuYXo=; b=iDfmlnHGeVi2uxrYd7Tq9kWHf7
	K+WPKvGVHHa1tIf0LwmKs9t6/v/nnGtvSwPhfytbVmDXWmmWoGQZ0v+rByRdaJA3tIYblFmqS4nIS
	98Z4UbeAaVVIl+Em61k1tTXgScPOGnTtzUtQJtrQwgD1PqQHt4ngV9dPt3ik/u4d3jEtfaIbZcX5K
	RByY1L08ON2pVGaR/VGq1IWlKHSo7St1+DxGWLp/bQpwVnMcOoyXYxg89tUNddrOlhJpYJWly3+/Y
	XDvflUXvtQUsfaQ6nXNNM45oijiggEAwFb8SE4JJxSWoB1kQWoNtuYqpklQHvV56wUan3+1Jdh/6F
	LoPIbzrg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wVQxe-005CEJ-2i;
	Fri, 05 Jun 2026 09:35:31 +0000
Date: Fri, 5 Jun 2026 02:35:23 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, Lance Yang <lance.yang@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH v8 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
Message-ID: <aiKXrovzrNN-gExm@gmail.com>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
 <20260527-ecc_panic-v8-2-9ea0cfa16bb0@debian.org>
 <19f968f5-1289-f573-4406-e5c91dcd8923@huawei.com>
 <e3d023f1-ab6e-4424-b304-55f1294480c3@kernel.org>
 <33ef8821-c809-b7d1-ea77-6e8a07a6e784@huawei.com>
 <21732071-14a1-486a-951c-34de97b7c757@kernel.org>
 <4b27467e-935f-5587-2f48-5a794c30a592@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b27467e-935f-5587-2f48-5a794c30a592@huawei.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B62A20005
X-Stat-Signature: tjr7osxcgbtb3i1b9q4kd1bmhd76h77i
X-Rspam-User: 
X-HE-Tag: 1780652145-145500
X-HE-Meta: U2FsdGVkX19dC74V5DAUYw5J6bXmzeqOQasACYmq1DQ2EifgULqBqRWtusLQu/0eHGXT4Y8ul7auMxYnNapYGI97xZi8m3CRnCemIAWM+jvOLkP0o3/hG5FNyKqr/d1TgpiI3mIhZjQF73uYO26VMmTDJtXlOB9KiAAB4dhXy9pT1I/A1jKn9PV7Wfzb1g575Bs58xJq2L5QXIG0mUO42pFUPfH3bCQrkeYsJspumMktaFPEN58maYzncBLWuYKTMuHnTYsavIK3WpD3pXfbYh3FvIJkEX1My0eMf11cHbtIkeOvNDyO08mdeHfsthL3CjlnMP5HyOXAu/x+qlqo1tyftZgl/Kit64AswMtVWW7UdBGp9GlCtSPKW2sjtUUOExat7pn5A+avH0/O0cjkDhZaHbD/xM2GqHsjZF7ZAjamsY1Sxv9YzjZtBtu9O6UPnLY1Bav02ZCKT49siCTF1Rql0etZ38g1NlxueZRv7K7FDN4jbRZQRGYu43u5+lztcLbaaEpzRmI5kPh8dN5BPyKTe+Y7dPUKZT7gmHF/m6t65bgyXbQkxX0OMx14hOy5CI3/W0F0c/ovd1JFGHzDJnjpBKKFCHqaTjPfoDbOHkwZl8w6IA5FPSm++3IoIDte0qLDDovBnNqbwQHDQfXPvT4Qa28xWy0D/DKGej7ZHtJIpn+zLCWXKYVPC2duBoBg574MjtNpoZgx7jQqDsl19NIgCMelQ0pHEMenPkvJEk3YriBiYOnYqIeLKPTdiHXI5g/PK8xa/jRhXiUyVxRmmZBtV3EhJDXnYJrAKiW6F4NXiaMjttKUlFWJBvJL7g4d+kSYjPM3nFJUtTXKnsHMuKj8FJswdXE6lyVVLzgZpWvdtY4KC1JvjeV/3OJHqoMvVxWjmIVU6uQpbf2pqQJBQrkbz6ISYxsy/cLQ6cC7cCyuOfQ2Arl/sYEiW/GfJGMq/9gZwDNBuermvcipQYr
 aRuLt0IM
 qgSLjzj30ZG1RI4GhnCiJcFGOLoPqtOQyZE/WUho1ABM4rvBPzWv5WOEIY0kcybjrbyqN0dC/BAbUAelZ+VEKlL46jl/vRdRA9CXsQmt/QkI5dK5HmkDGHwfRZ+23KqEMh0eyLvf6cyyV3OOLn+8x4UykFjWez1RT9l4WhYr9WA4TxTwBLsgdlZL23Y2kMwippuoEAXc13OFkIcFqA9F3mQiA/BqDxAPCIzzTjrc+7pxJzw0E9aUEACCwt1RrkjPMS3I9C4jOQKRrkhAjaI7DEU9AkrMsHuKZ3Gsl9N4MT5Qpgz2j4OCqFawdyShfuec8Hn1Wdcak57LS/Do=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 10:33:04AM +0800, Miaohe Lin wrote:
> On 2026/6/2 17:41, David Hildenbrand (Arm) wrote:
> > On 6/2/26 05:08, Miaohe Lin wrote:
> >> On 2026/6/1 21:22, David Hildenbrand (Arm) wrote:
> >>> On 6/1/26 14:28, Miaohe Lin wrote:
> >>>>
> >>>> Thanks for your patch.
> >>>>
> >>>>
> >>>> Once shake_page finds a lightweight range-based way to shrink slab, slab pages could be freed
> >>>> into buddy and above PageSlab test should be removed then. Maybe add a TODO or XXX here?
> >>>>
> >>>>
> >>>> I'm not sure but is it safe or a common way to test PageReserved, PageSlab,
> >>>> PageTable and PageLargeKmalloc without extra page refcnt?
> >>>
> >>> Checking typed pages in a racy fashion is fine (PageSlab, PageTable,
> >>> PageLargeKmalloc).
> >>
> >> Got it. Thanks.
> >>
> >>> Checking PageReserved in a racy fashion is fine as well. TESTPAGEFLAG() will
> >>> allow checking it on compound pages.
> >>
> >> It seems PageReserved is not intended to be set on compound pages. I see there are PF_NO_COMPOUND
> >> in its definition: PAGEFLAG(Reserved, reserved, PF_NO_COMPOUND).
> >>
> >>>
> >>> For PageLargeKmalloc, we would want to check the head page, though. The page
> >>> type is only stored for the head page.
> >>
> >> Maybe we should check the head page for PageSlab and PageTable too? alloc_slab_page only
> >> set PageSlab on the head page and __pagetable_ctor uses __folio_set_pgtable to set PageTable
> >> on folio.
> >>
> >>>
> >>> So maybe we want to lookup the compound head (if any) and perform the type
> >>> checks against that?
> >>
> >> Maybe we should or we might miss some pages that could have been handled. And
> >> if compound head is required, should we hold an extra page refcnt to guard against
> >> possible folio split race?
> > 
> > Races are fine. We might miss some pages, but that can happen on races either way.
> > 
> > 
> > I'd just do something like
> > 
> > if (PageReserved(page))
> > 	return true;
> > 
> > head = compound_head(page);
> 
> If @head is split just after compound_head. And then @head is freed into buddy and re-allocated as slab
> page while @page is still in the buddy. We would panic on this scene as @head is PageSlab. But we were
> supposed to successfully handle @page. Or am I miss something?

You're right that it is racy, but I think it is an acceptable race here.

For it to happen, the poisoned @page has to be a tail of a live compound page
at the time of the fault, and then -- in the few instructions between
compound_head() and the PageSlab(head) test -- that compound page has to be
split, the old head freed to buddy, and that head re-allocated as a slab page,
all while @page lands back in the buddy.  It cannot happen without concurrent
split/free/alloc activity in that exact window.

It is also worth noting the page in question genuinely took a unrecoverable ECC
error, and panic_on_unrecoverable_memory_failure is opt-in -- an operator who
enables it has explicitly chosen to crash rather than risk running on corrupted
memory.  Mis-attributing one such rare, genuinely-poisoned page as
unrecoverable is within that contract.

Thanks for the review and discussions,
--breno

