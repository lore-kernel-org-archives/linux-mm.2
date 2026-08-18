Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87A9CC5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:08:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4146B024D; Tue, 18 Aug 2026 05:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB876B03D6; Tue, 18 Aug 2026 05:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1F76B041F; Tue, 18 Aug 2026 05:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 498E66B024D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:08:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B347740B61
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:08:17 +0000 (UTC)
X-FDA: 85113813834.07.5ED53A7
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id E0FD42000E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:08:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q1LZRKCx;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787044095;
	b=pty1n1ic4PpRpOJ5sulZ0XGYbv94EN0J0mqn+feGynOu/rSx01DVSqlusNCP23TJ9TvlBV
	YY3zhWOks2wHMRY0Vi7cWs13EcxWBKFPXLWDkFntvxUW5r3vdHqzQGLUKJc+YPPG7QoJhQ
	vdqVL6uu3YUjDdKbpK2XxbWhSW6pdsY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q1LZRKCx;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787044095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eH2+LAOZDihNr0Vw33UUIwKMjBqap0RbvpO51o4UzTc=;
	b=EdgXTUuUP/KWw1L0UggrIbUiCZtLxih3aq9UmaCGJGS2L0qw1lku9bXlZyMWgy5yBtZ7N2
	aGmu9a9nGwbC7iVcdC9DllVGw+mUtyMPvAMVQPSKQEoOfXsuvP5AJ7HaBYlbiDap6uG9lk
	RetW6nhquxhWADeo5Jg5LgXVTzGFDWQ=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cbedd5aece4so576400a12.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787044095; x=1787648895; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eH2+LAOZDihNr0Vw33UUIwKMjBqap0RbvpO51o4UzTc=;
        b=q1LZRKCxItmilcN1Z21MQuE2JHBbjJLSFaEcIPRkKrRziy9zlMvl3wDH9yrkeooPg3
         p48unDm3fchl6Ann5ntwHi93r22D25cL2hqj1lcfRnYvl1BLc96nJR/NTkqLYOkwKAem
         TOxGdNah+Aj90fXjgY48zvMt7REY4Zf5uUodaFZUTPYBMq365XrvCyU+qYw4exNoJC/V
         uLbI0TB9CMU9GZ3VLnoF9VrgSSTuCbTLkd43oFOxpUswUnSGmJ0GinBmgYlNnzmXqB1K
         Em9xJGG1byUIq010QEkGPcK558zBluJdF5kMU5xrGbaE0kKXroK2RPNew7p3KwRI012e
         9f0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787044095; x=1787648895;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eH2+LAOZDihNr0Vw33UUIwKMjBqap0RbvpO51o4UzTc=;
        b=h70LPlnSX8+xA+wbqVGnyyDu7aykdyT0+7ZyfiqDlysg0V7h3KaUKQtDnsjQ6tV6D6
         gWzvqhvZpLw+gncjUWGQgfJyeFXS+PXHLNN84xF27GB/fLaEaAyEtogh651bpPqZniwe
         6k141aoxXWGwG+Kl+vRw8XjR65OjnslsNLrVnT4tLJFnLhJvg36eEONBP37bnEvC7+9a
         EQ6UhnPOjJyOG+ZDftnROBtrkPu4f3j7OClnKVcVSXfsKOyf4gFlOyYegjcxroXaw+Hi
         t6ss5mgfYXR7NutSc6A0bO9xy4y6raZVuWOqOZeUMsWov1teSVNXh5+W/Q6/RUHiisrf
         Rpng==
X-Forwarded-Encrypted: i=1; AHgh+RpIgKv7FHDOxn9vgZzk1zIgeWyXWYlbzwAZ33Id4OGL20qW1oKY+87VXD9fYGCDDIc/VeBP3RyCLA==@kvack.org
X-Gm-Message-State: AOJu0YxhQCz1zhHztiPZoPWzsQARf5ywxbRU+EVIht0j8IBRhpGBiCPi
	jmWo1aZg/UU+tHx9Q9StWKKBbrZTKTtjobJQR6q1nXre6VNIWqlYuSQ9
X-Gm-Gg: AR+sD11H4NDN9Wr25cW+88sP90Xx0gEQk+fK2ua6Cn09azQiYnpIHRxyb92LJJ0a0bQ
	GAzqoRba723+SnJilG0fb1J5DeIVZewU6UMlvE+eNSLete3kUifSzcSFYgP4jMk7RWx6y1CLQu/
	Jz16oFSNdP0oI04087/R4scNauGZOX6xYy8wckLA1bBJ6FRCZEuYXrIFsJnmg+dQWjOdifP6ZGf
	vw21JnSfPXCmNi34i1YS3rCzQc1xrenStRF2649u1HvqYnoMq3kCTmiwtU4jhfgybgUSeCMTVbo
	N3hlWtbdkrsW7+vn4BjH70dlYft2UsDwYfiKTyCP1LgmPeSPzKa+Pf00iEHydb7jQep4kuuB9jz
	auo4H1SamdDq1qrynfgSleuFHW3PPX4r9ncGusd7ApJ0iSXDWr2fvNuWuU5hGeutkNzt18tiUlS
	F94eUmzCJyvPcOqLn8L08Eo0GItHHhFzPJbXFcdKmm29tzcvEo4QFfzokc5uSy+1TkfMxpuhF5a
	wBDRCbQbV4W0ezVz96FwXlw85/nXe5ywBo=
X-Received: by 2002:a17:90b:3e87:b0:38e:7f22:f674 with SMTP id 98e67ed59e1d1-395638e58abmr3372749a91.11.1787044094652;
        Tue, 18 Aug 2026 02:08:14 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39531fba7e8sm7803783a91.11.2026.08.18.02.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 02:08:14 -0700 (PDT)
Date: Tue, 18 Aug 2026 17:08:06 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/3] mm, swap: distinguish a malformed swap entry from
 a dying device
Message-ID: <aoQFzEgZP_ZuSP3e@KASONG-MC4>
References: <20260813-swap-v2-0-4a625ccabdae@debian.org>
 <20260813-swap-v2-2-4a625ccabdae@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813-swap-v2-2-4a625ccabdae@debian.org>
X-Rspamd-Queue-Id: E0FD42000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: rkgz96qri3agps8gssw8ei6q748bj96j
X-HE-Tag: 1787044095-841318
X-HE-Meta: U2FsdGVkX19a7x5XZGSieN/dB60Lf0esiviC0EK2qYzXfubKSWSa4O7DI6NWZWy0qn66q59YPy6V5rwNhUtqgdUbSNAPFI7giGEVPYL/N3RCo9eyA0FLG01UqfdJBRDqJq/VOga/AN3g8DBfjTmlBtL7xEJiNlhRuOATKlPJrkVfzwBojqYl6H/aCiFTU+kP07BMr688mIQO2XqNb+mZ2KeL9xWibTaYHB0i4czQZLqtY08oIO855Jgvm5n7LZjeR0v1VCMgjEj8TrRVOpD15Ke8jqgb0feB3NDffAfy4jZxcFE3qkaR6Eizif9Qqum9A06+e5i/iuIi++2lZk3wTM1QOENcPIKvXH1x4gKnlWRmMr6QLvlO+9pf5Lxx2b3f26sW6rBV8baogX3EbPk71XvLHKrY+UgysJWZ/Vv2NK/g0qIWxSjhCcqM70yXMxXU/CjLwrABfOVnMvgFe4oC8huFyO8r0dtmJjAW8bd4kR+kJMvc6AnR5p6xWnroneism763T21o90zBwL9xWLGK07+28P7+uJnVSmA/0cYipnHL3SqFTXARTkGFCg1bdTAnldmrsMzLYjRpOu3aTA/Em2Y27Hx8zej+01XHfI0eAWdjFCW1159CZNYHpOBVmC8/6EUD3bHo7Ze1xK7nK+7XCOVIDpIbfsCEkY4XBFwA+DyOHchvgVbLmjgpaKss2kte/lengq1nZGWTvVjgO4hNWjoXJo9jaRUVpj2oj68/BfF85ixemr+pBZRRSKiyrTNtuP5eVsP086W3Y169AJPOU6cfav20T00JQMpRXOTfmwweoJClvYSaFnsa4YpCv33S+mmf6sLXhwtr5R4ccZ8QDHBrWZRXB6XSfQoGeJ8KI5PK+gET328+LH7Q+fCQ+y5SyeSfZddVQ5GDu4xWK54SGQD0KqU1scU92GL9xLID5k3ozqBr4F3e9OAefAuRLX16UCnoraippwthHJ2kRBT
 YZq0W8pt
 CXbg/zjdrSI01035XaVD5YfQ30IqLocvXjwt3EHpN67JPaOcENEafXVKU/Np5Plrpk1p+w1KC9osN78X3y8agRFJmRZDmf44PJ1aet++IWiSUbZDWrnLwVnB2YrMGZwcJoeKT4jCUHZIQAAEvuiB8CQc4NsxZRZSjNb8Hx8rz2hgJHLaVchAO571TCt0VNGVCfgUmloLVkAQ4Texd67R0w3XkDEc9OhpoydKOwA5d4VsJuuR8hW6UQZgW02dcOYmJmYQE+NNcG8NeoTO/WvLTePPRi9Z58goTQPthN45nzYdKTcdCwi35xJUVNFDrrNGn3qaF7lBJibQCEw7yXjOEE6StZEOmWxKqRPh/puAzGBlcYlRgWSCctnze8U7HQhYO4tAODEA8QDcNKBRd19cxHdBVG4VFsl9i/aV5CQooXL5rAypYKiNPXacU/29cesrlA2jAW8UUuEvpr7vRo77J5MmAyja9b6bqrBQqrZq8fuonB0p1m40O9v3J996R1IfNz6WrnEAFpxJqAdbYC9msf/MbNSEb4Nh5h/RLV8w3VIKLhfolnYJdBapYka59D1JJMbfd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 03:02:21AM +0800, Breno Leitao wrote:
> get_swap_device() returns NULL for two different things: an entry whose
> type names no swap device or whose offset is past the end of one, and a
> device that swapoff is taking away. The first never becomes valid, the
> second does, and callers cannot tell them apart.
> 
> Return ERR_PTR(-EIO) for the two malformed cases and keep NULL for
> swapoff. copy_nonpresent_pte() already reports -EIO for the same
> corruption on the fork path.
> 
> Callers bail out on failure either way, so switch them to
> IS_ERR_OR_NULL() and clear si where the cleanup path would otherwise
> put an ERR_PTR. No functional change.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory.c      |  6 ++++--
>  mm/mincore.c     |  2 +-
>  mm/shmem.c       |  2 +-
>  mm/swap_state.c  |  4 ++--
>  mm/swapfile.c    | 14 +++++++++-----
>  mm/userfaultfd.c |  3 ++-
>  mm/zswap.c       |  2 +-
>  7 files changed, 20 insertions(+), 13 deletions(-)
> 

Looks good, thanks!

Acked-by: Kairui Song <kasong@tencent.com>

