Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E11D8C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A436B009F; Wed, 29 Jul 2026 09:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B72BE6B00A0; Wed, 29 Jul 2026 09:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB26B6B00A1; Wed, 29 Jul 2026 09:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 880EA6B009F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:54:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC132160682
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:17:50 +0000 (UTC)
X-FDA: 85041413100.08.18BA2C8
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf01.hostedemail.com (Postfix) with ESMTP id 19B8140008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:17:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Z6ePZNkp;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785320269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4zFAPc+21MITv4dd8ElNkkULP/O/tRrJgt9WcudjgGI=;
	b=A2NVqzDnunTIz40/GXrG5KnFvt8gkzxdE7w1lQqo/lpaORBH07OR5JzNcG3hrH50WvXJFU
	N8h2ACFV9SxvV8LQUT8UXBl5x/4X+2WVZxbz6DhIYf6Pm4K5Ob0eyZLIBkCmm5D2i8Gm6t
	FiIAD/lWH7d7tTrfcyMbDUFXBEwnoyA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Z6ePZNkp;
	spf=pass (imf01.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785320269;
	b=kT57zZVNFYzatDEUSYsVMPFEvO3Iuqhf1DuMfPPcM+Zmtg9F5iTx6igEW2KXVP7lrtQ1EL
	qnJCDhgg/kTtuRnukuFmG542yRcKRUPb+aStKRQsvp29eBmXdwAY/u7weKUGgtzxolg7av
	S4YvGlMybrry6d1pSc8BIHeKvV7kwAo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4zFAPc+21MITv4dd8ElNkkULP/O/tRrJgt9WcudjgGI=; b=Z6ePZNkpTROPEHa8pGFfMtqFxK
	eSOION+l8gFyYqMBw9nHA1xm4vq0Cz7xUpPyRa9afGxlLDBnvcsW0GQjTqeYVDHCQkDAjg2xGG6QI
	yfsxRYTyO/DuD9whEFTxX8FgN4ScH4mpD++Y/jcF04k2aiaFLruOO12wCbR1LTBGhcbz+rr8EVO4M
	nt98u9Jlq+cNZlpXqEnOH/I1pK+uutwvoX2VMKyrZ/SbiIEcJiCEaLPkM5k1hINZzIeh6/fw8Fhfz
	7KXask+L9LjalX+pBDnUzV/fg9XX0jG03MsKHPDNu5p9YFCd3yRd7UOlgzEjL2c/cgRB8rtVUjlqp
	ncqY0D0Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wp1M1-008NdZ-0X;
	Wed, 29 Jul 2026 10:17:37 +0000
Date: Wed, 29 Jul 2026 03:17:31 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, kernel-team@meta.com, 
	Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH] kexec: keep the next kernel off hardware-poisoned pages
Message-ID: <amnSy6PFh57T0buv@gmail.com>
References: <20260728-kexec_posioned-v1-1-160c81d180fe@debian.org>
 <16c18549-c9a1-ba55-91b8-52d9368ebbc0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16c18549-c9a1-ba55-91b8-52d9368ebbc0@huawei.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: 19B8140008
X-Rspamd-Server: rspam01
X-Stat-Signature: rjxhudbo7fm7neq3zz8pmkbrz4yasijp
X-HE-Tag: 1785320268-951465
X-HE-Meta: U2FsdGVkX1+CtW2I8fM7769nC1tJWsVGtK5roVFSrqMLSkkYKKScSPCNVP9TsS4t0SCfZWyRdjzVWt59ecvdMO1rS7abYtGpVX8B6CP1Sofl0w+zgzYpIZHmgXZnsZnn3Dy5zwwPSnDtC9TaynIBB9IkB6F67Wrn9g+4UMC/XntwkJco1RdXY2vgZbxjCotTWpI3QHn8hor4MCZiUeGLEGe1o4/c3yUfJpP/iiTteI0Sf0hTtKFKieFHCGFTGWJ13Ahl0Quzs9X4NR0vSJ7vwBpZAF9B8zt2Z5oE2CpymplEJV17kJGCeKLviivFpMw1ZtjqIvcSTBDhEs0UfbhZJo2iiXC8+PiSL4yk0CeVwaMxa8NldD9AF1bMKH8Yi07L0e/LPc3DBYVXQIQBwGEooWVyhvUsfIVwNGFpPeSdPOIPZK/KF/9OFr+obP5nHmlHzVu6RfY1frvTLc/S02M6rWCfEIcwZdcOXb8WSmGxcGq6ogTacmJnbBM0d8dWqFTgzRzQXIrzjAi62e5lbkq1dxmwfOaBdu631QJeLFjdwHj4WN3mc9S4ITqfj675QEJ8qo++3WQSinaVjCrT1Wva8hGQmobduzLNa0v/O8QsHhheFA3XFLvb7oP6YsIs7rN490W96X1S3n8TC1UxfffuzzA/vD/rQUzXfPvYNxUQynnwMNvXKwPItjr0QSbyWgidQrmAAB60aH4lfFFpQOVhrRJSh5HfJaBztKXEDlYFTVjD3rFCAiCHsiQUYTbXZlprg/WkiuGXEU/36Go6ARbGLRUZMUGJc3SNtZPJYA6XZu4lMRinU8LaErpgjYTArO48YNzRrr9y0xgqLdUfKZiMD1xm67t3U1RVCIlwDLN6iCqXLsSFl8/vwhA6d50COvmOXbODjEM4QY4SdxbsCsFO0Gno9O3pb3fkLLA4WKrLXyvfFuwkotUAQnp2sKpYb20IM+gez0LH0/ONO7ZGGoF
 S4cq/yi9
 sNdrxxcPjJQYobLVYXukocnyFbZOHYRSLNEcV3q9KFb5Pba4vwJHodcS3g5LwMf1JPi7a7BQV+6CqKIj0Ccfb+KZPZYCh7WRIw2iStlt/+JVNlE4CN4tFfI9bmVE2xb6h/dndasJx8mzqCGoQPVHx/q/3PSGV90QpYvLNU0z4wCi/rYTEakcnJZI22yZd3pJy6ak2efL4ib6l0DFDk+v4qQnQ/KIMvZCXJLs09utrjdI9MDHrJTb5oN9cl820eW45BgmN7ulMdVJv2B5hCt64Gn+rkRxLf0tCs56LGzNhgQBozqhww2NGKlw2gF62OzeMt6AKeLDgY07u91w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 05:33:17PM +0800, Miaohe Lin wrote:

> > +		if (pfn_valid(pfn) && PageHWPoison(pfn_to_page(pfn)))
> 
> Should we use pfn_to_online_page here? I doubt we might meet the same problem
> in [1] if pfn_to_page is used here.

Good catch, thanks -- yes.  An offlined but not removed block is still
pfn_valid() while its struct page is uninitialized, so PageHWPoison()
on it hits VM_BUG_ON_PAGE(PagePoisoned(page)), the same failure as
commit d613f53c83ec ("mm/memory-failure: fix
VM_BUG_ON_PAGE(PagePoisoned(page)) when unpoison memory") fixes.

I'll switch to pfn_to_online_page() in v2:

      for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
              struct page *page = pfn_to_online_page(pfn);

              if (page && PageHWPoison(page))
                      return true;
      }

Thanks for the review.
--breno

