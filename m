Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 770FFC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CE7C6B0095; Tue, 28 Jul 2026 10:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67FB66B0096; Tue, 28 Jul 2026 10:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F366B0098; Tue, 28 Jul 2026 10:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EFA76B0095
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:31:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4FF51403B4
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:31:48 +0000 (UTC)
X-FDA: 85038424296.17.F4770A1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 70C2C2000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:31:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uxw4gS+V;
	spf=pass (imf03.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785249106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylxLw5Zvv2evU7jmmQqp6rI9pLf6NLfhr20HsnCki9w=;
	b=iLSJKrq9LKkG3CazpC4oeieZRfuELrqhno63nuUZm4rYEMO1uKe+qQxYFlmE3iJiRpJeRt
	ohIQBAJq3wkpuULsvE2VN7pynHi9F4nMny9GNnJnyE8G25Np2mreEaXPEAOi/3ERiakMlw
	fEFx9WxI9v/Xa19AJV/Z+9UlVcfElbc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uxw4gS+V;
	spf=pass (imf03.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785249106;
	b=Um28U+zPpLmWgyebqGpKyR3h0CpbjEvuXI4BL+j1+7a3XaqlxZoDyl0LZzix2QoXSg/8ZV
	6ZbR2Xi2ZVhR6KVAuunCxPu4nCTa8FKghfIoWduCyNMZEXx03lNbmf8OgNrmEYQOROLryP
	2aLLtO8s/dvf8thu7fwrmiFbyxg30Vw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ylxLw5Zvv2evU7jmmQqp6rI9pLf6NLfhr20HsnCki9w=; b=uxw4gS+Vs58Hy3vhqrWgntua5G
	zQEksmEBJvslx0KRQxb0RXudR1WgcRb/xnnRwBS9xGVyxrjJGeybLRCAQaNQ2dnlvPhJrwVHHbcVP
	aIK3TfogFkt741WzhEPW1VMnaH/h6cWazMrko7O7Is8P/AAGyfKnIlMnjhiU6VY73iLk+FL2N1I/1
	5kEFq2Ky7h7aC6sta8P2tAqPNWK8qYp7BOejIKZpNSWNWaoW43Yllxp1D45G/uS/IXIRKG2MfVbTA
	8F2JdHUVQONJdBQ8/GetX+lhN8EW45KSVbsZma0nYiVdVzZs/zNk0okjdkVXKVz/DUC2iWV5znW7l
	Tm3+dgqA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woiqG-0000000DS1h-3WHz;
	Tue, 28 Jul 2026 14:31:36 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id AF4A0300CDE; Tue, 28 Jul 2026 16:31:35 +0200 (CEST)
Date: Tue, 28 Jul 2026 16:31:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David CARLIER <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
Message-ID: <20260728143135.GG651302@noisy.programming.kicks-ass.net>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
 <20260728142108.GW751831@noisy.programming.kicks-ass.net>
 <adfffb36-9943-4af7-a0ee-0e762e47fa11@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adfffb36-9943-4af7-a0ee-0e762e47fa11@intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 70C2C2000C
X-Stat-Signature: fskozxx3wh1up79bxqq73wjyrszcggrn
X-HE-Tag: 1785249106-396171
X-HE-Meta: U2FsdGVkX1/iUDvjBzXaa+O4xCLRGhLQR5AOd2XnMiSjXQjUTOtB4KWm05OlcUQAKIDpTAAUjccF7XwZqcd6i7vfaeE8Pin1ZBSf9PRA7Vu3B2oSqXA+4E9Lrs9VRzRT20cswsI7WQTxlm4Mn6Q0gPvGOI/8v4Q+ZvTnrXY3+Qg5nuRbB7QutBzGjorwkl3rNnQt9fj8iKqJ3porqMHRpgzClwKdYduaoQXRAigAxVwL/fMrYvARmBDHekGKd3YoK+yl8aWVVnRMbksmwPCV9fvVBb58c7PU6pBlTnSHkybuk+hvTIXfJ634iYWfRt12prFtfMeGDRAz72wSWGwWtjQ5OJHOYADyUTcXpWr0rZxo5xWAX+/FQVnkjqNMiBN/YAcLpmyu5GO6cMHHNzY4t8Ao2zwxU06dbX0SfMaLKjRuuZ1XbVT/ncvoBPLVdP6LBd8lJr/9pKs5nT2A+jGACIOgeYu1UV2UKOwb/qTBGrCX4uvbZtLxN26+7T1U2gWvYw3d8w+k3o4d189k7GfgcJjNBnzrWsIuxRsK8w3hQuqa9BOdiDuE6i33GKo8S6QYI4rTmYaos2EAbqUsRWqCWz8hXz/w53Gvm8dYmOHWhKgE0lmVgQvOOwchrVETu5Mj1fAUbZSZ0wiRxN1eWrgg/rduxbhMO9akbK9Gqk4dtOwWQSBidTwnfnbfblCLW3UAlu3f4LRliYho6RLaREHUFC9xDBiBLWADJsooMAv8y82p9Ed44/ca3073aVummqAacGwXdHJiJ3B95UTHERDZRZnGzooT07rUGqfyGkwFxo9RQSnaewFxoP+Ju+/KdZOQyLJry9wqxLsPv7Uc3iTa+S8SOVUEdUN9fXgMPhP8xtPN3RGgqnZJ+aXk+hMAx2f945Q/Xqlx1eZ4Sq5sY7ZguZq1RlPg0pIHSVSDbwV4XZ86+U4GVlVyuMVNcVzq6+uu6do35ZPorLdA8TN0bJg
 r5uAvSw5
 Y3KFzWoJXtIOIhndxSamQr10bO8mGYhsZQKhV9PUESU1MD9tgkUux/ZC2Kag9BvyuszDwL/TikCpj9iToB21Oq8KMkpiSh5o9UZiCz65RASg7lYlD1TrWpikSonFzk4o3FfW114obEgjs4KIqBqkIy+ONArnCF2QpruMl1CXd6cHMJLXsUQ02eX/DHxr+xKhPfuq5h7/7gdRhiVi7idUYiKfU4xKZ5uoDq5Eafm6C6Jo19v2URCWocbLpqKXKiSj90Hh5HNJn69XMPYdRNiurmShwwa/8m+31iy9v/86et2zNfij4a9hlbfQahJGgwGlFr5BGorGI5+PaSIcU6fnR6Sz+ELnVGhY/WhMGbDUo1mobeME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 07:30:27AM -0700, Dave Hansen wrote:
> On 7/28/26 07:21, Peter Zijlstra wrote:
> > There was already a patch merged that removed the shole debug_pagealloc
> > exception. Is that not better?
> 
> As I'm scanning through email this morning, there's another issue that
> popped up with that patch. It's causing hangs on boot.
> 
> It's looking like debug pagealloc not taking the lock is actually
> functional, not an optimization. Although, I hesitate to say
> "functional" and would prefer to use much less nice words to describe it.

Yeah, lets figure out why that is before we retain this wart ;-)

