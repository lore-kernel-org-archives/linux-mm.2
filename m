Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA2D7CCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 08:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3DF480021; Mon, 27 Oct 2025 04:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEE608000A; Mon, 27 Oct 2025 04:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDDF180021; Mon, 27 Oct 2025 04:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7D898000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 04:20:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CA0D59536
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:20:59 +0000 (UTC)
X-FDA: 84043198638.18.A7E16FE
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 96C4D40007
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:20:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ouAvak8X;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761553257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8i9V9XN9hg6qjjGZ1kzhc0nrYJh0IgUWRXxrYjVsEk=;
	b=VHO4Mp5UfDpo3OU0GbWXm482GmW3LTMWp+P0tRL50+Sc8aY1GZ7LKSJdVS9I0vMsXhv0dM
	vxoVlKLnNN7pcjnDfFQHkT03y3dDdNQeBYkY6A6uPCn2tXNLtXHiPWDRmXPxZuQVQb9w3D
	nF6X5atc9oU8Jioc+NOIng9G13Xe46E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ouAvak8X;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761553257; a=rsa-sha256;
	cv=none;
	b=Rfg3Lp7TzCeI2uFWl3YWZT3fd6ikd0J//VxkR0jtN2JhyOuyhN/G04HbJAop6Z3VN5f/k0
	qVEPuBKpKuJbc0NfJB7GcoexVMcoln4zdeh2wt6vzBQbjn9bRi7hYS5B+YrPnN+VsY4Ua+
	Yo45LJdtD508d0pkAJwFyDQPOTv6Sic=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-63e0c6f0adfso4366890d50.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 01:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761553256; x=1762158056; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v8i9V9XN9hg6qjjGZ1kzhc0nrYJh0IgUWRXxrYjVsEk=;
        b=ouAvak8XkzcFf1tLoHO0CGZVyH5Lc82O/lh3/ddH9EuDy4ho74QXoc4d9fiKp7kG+v
         51stP5Qin6qCy+NXp3gFxPojtLzf+2HE0BRC93ssNZHLAhLGYCozAsL/546+gvVPCf7U
         B8fhRTrby1bMiThEtfsvYTpvsWM9hLzrVdoa5Vt+1b3IAV0GyQ8CuXCCRv0Bhl5nmZzO
         6Zg24EKEzDJlCfm1QN2ignBH85FAKFNvJ5CJKZ3QKFZcP8t43PL6Nn1o96F2mNAr+67q
         TBUYmXpK3+sM8PsNF+v9DfF+xCrwJJZ9wf5fvdjGSQ5yFxuSe3wMdb4YPBAAv0AswpQ/
         Y2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761553256; x=1762158056;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v8i9V9XN9hg6qjjGZ1kzhc0nrYJh0IgUWRXxrYjVsEk=;
        b=AeAcUYNHOuTWu44eQJ7uR/xGMcFIckfOovD8icF8cFQpHixb2TESpmcePLkJI3B6hT
         Me3cn5I0U6FxFsRW4RKOCl8wALSoo/kTAA9J5E3bsOERtE83+RXrRSbWHP/zHbme5LeT
         pR4aHcwFqUIGetR8tOJcm0saHMwGhHIAaQOU5zix+vkafs/eml2suldm7wI9v4WFDtbT
         1f3y28Z55a0cAZQEjR7JP+YWThuGVFxGKAYI3Y/hYORPBZ4YYH9HNGCCKDQTbyQdilAt
         ycsq/C0lCql618VDxkTriBg+QiRgufstkVc1GkhdhyVKlpCfJ4dL0PGfj4dZtoPwaPoo
         xBGA==
X-Forwarded-Encrypted: i=1; AJvYcCU3bNHGhthGT6irEl48b0/MP4Ku1bz8h5u3WH15d7wFRA8RPCEkBEB9egZ8hc3YDAplRaPWkPmbbw==@kvack.org
X-Gm-Message-State: AOJu0YzaP9h0kBP/aD7PVgNnj61FJzEv4saQJYSD+vacZFuVgma2CDJb
	BzZaMuMb3eJK9qdoTFO2v08Egve0iTMjp1nXK9jCMckNIkfS20sFfghevF4F5I0wVA==
X-Gm-Gg: ASbGnctvi4p4k7/HKexyQkcyGUSBliJsly4fvAjMohItDZMqupjJ9VS96Z7pCdTgP6R
	JY2UuifyJGapxlhqrTxYF54U1B901HYkCsgS5wN0HYF2A0SSn5IMEPVx1zat5CmD6QfbwdHQaAV
	+EVhaS2kd4xDK9F1Tzo3edauNF66SZwFEGJmki+0RMiK+CvoNMuUpNN+1cevfwTsnx0WlXbS9Oz
	o3pN4qC+Y+YE+Z11gDFEaQhmqyd46YkroL2BLQ3fyZ8HAG+BCukbvMkABR3kGWcAHP+K3wG34+d
	jgYXdtx8/ZyQFBM8iKuJ5DKiWsxsh+a1y6gTz7C0F31YgWdE20GJCkoQWxDhJ9rCmRIviX6v1g7
	J6YKjQNPmZQUN52ysSxJ2QhIGr8RzJSLQvvGkajR7CWmjZemrr7rQXdYVb/HqgA7/lNXk6PltJ6
	S+TWFC5o/VjrGIu8bT1zrNP3PnpUcArtrjyH2CFOHEjVjXcpBh+mQTVq1Nf2YO
X-Google-Smtp-Source: AGHT+IEkrjgBL/rVFsJvctj6nF95xlm6ZoesSRoLMtXTNJL5ue1ifqY7ixGqz6500hmN62Bj943W/w==
X-Received: by 2002:a05:690e:258d:b0:63e:e3c:ea59 with SMTP id 956f58d0204a3-63f4357cd79mr6910825d50.56.1761553256284;
        Mon, 27 Oct 2025 01:20:56 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63f4c3bc6e3sm2081958d50.3.2025.10.27.01.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 01:20:54 -0700 (PDT)
Date: Mon, 27 Oct 2025 01:20:42 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Christian Brauner <brauner@kernel.org>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
    Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>, 
    linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
In-Reply-To: <20251023093251.54146-2-kirill@shutemov.name>
Message-ID: <96102837-402d-c671-1b29-527f2b5361bf@google.com>
References: <20251023093251.54146-1-kirill@shutemov.name> <20251023093251.54146-2-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 96C4D40007
X-Stat-Signature: rjtycz75qkgnwgknh9sdhbjkrj7r6z4d
X-Rspam-User: 
X-HE-Tag: 1761553257-261743
X-HE-Meta: U2FsdGVkX19X6PLCajwjM02dGT2c5AEJPUyJvyQLYmBT5Qu7kmD4H9i3i+14LH72ejk4bEPkVbT78u3mGMMX3r818UUYfq5Eku7k7LMLE2VQfAcZRKbGgmM1FVjPLTLsMDFn9YvGhWW6imo5lMXgamNfubAzpTbzsqK2DoJ+VU6v4vXS9dyUWOgex9KrWvyogyWlAtIRo/6YkQmM/tbFEBKOuyDGVY7CGApg7K/DHaRvIzGpx1pwcdxJn220r7KyGPwfCpqM809J/+gkwZXORzj7/4unqvkmo7S9Nw2/xawuLR9e6TrGTV0xXvVidiSr1E0cqAm2ADCZO9qGpizEGdV+ycK+Yl9KSlBIxdwy8/V0EV3+IKaNeWHCGmZHmU/PKuT0UJwNlZAzSpy+Bsg8v1So/MkyI9sdH7SZqnxHsE+o8TZEp2li3p8ptEexqYfPMYhx7k+ZNypWw0vobFV85uSFi/6e67xaiDct9zofXQhKCjzHrIEh0Sw11tYitbJwOqCR0+7LFAQbVxF/mUhfCeuEK166WUKocvXD71xXtT8fOkD/67CfCIpcleIYX0AgCIs2EMTtdKurkJecmWJ0hK4PaA5A2Q1sqnwW5lwSYlTPo5rXgnhBU/1QNNRwd+ERCvWgRiIFZcJVq9gLCb6GizZS6eFwJ1hhSPl8ElU69mPWr8QEJmz8qY/irWG7urUWopht6l2Q0skgbe51/UTiAmBSx9OwfiqOFQ19weqFyHi3qt1a/lyO3IXnLk/zJpHOh62OzL+S4RygC9x2mI4mdY/QGjRl8yMws/bZJANqYtevKZfXLhx2799qYkpv2Qt3q01wyBbFttYtaRQ9a+YUbd8RZQJQALCJuyRQLcUdQpl8YvA8v03UHzfcwUbVESor/7eJOvaAdyAvexwZPcjEqXUCeBaZA6x+Vad4FTpqEVJdag53G54CF1c2JUtjj49HFmvl7byAKpmfufq0C6s
 0F1KWPIm
 LDJB6b4QytxVOCMPyrML9N00IWM3UeWbCvOWdmb8wPqXkaNKQeTrdmQxmFL4gszv1yC5zSVNqZi/MeVR6Q4+aNto2xoo1cjNLY2F1sFPQF7aO69epZy6HvPkFsKRF4Pw0yhUN5r7vZPNSHQZGrESY9MRdnZq4tdWczmMYPzBi+0hUgEFOpWeShZInGl85ke5W4hIbQfb7qY8V8XjHIMxniLC1Cxnv1JMAuC8c1Px4JM9+OQEOaE5X2uhe3wecjps+WHja6GuSA7+UFio2dyOdIlVVhBIOVMUjDY9UKlSNUKHA8rsemuoykIb6enJipO566vkhl66uMJ0xASaqotoCw+JdH3v/W/6bS63JBV25szdyRCnBjtz+ZFkReJmsSvY8GKLW+iyXplOWRKYD7pXLj8/70sLJHpsj376S5kzcmPwjzD8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025, Kiryl Shutsemau wrote:

> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> supposed to generate SIGBUS.
> 
> Recent changes attempted to fault in full folio where possible. They did
> not respect i_size, which led to populating PTEs beyond i_size and
> breaking SIGBUS semantics.
> 
> Darrick reported generic/749 breakage because of this.
> 
> However, the problem existed before the recent changes. With huge=always
> tmpfs, any write to a file leads to PMD-size allocation. Following the
> fault-in of the folio will install PMD mapping regardless of i_size.
> 
> Fix filemap_map_pages() and finish_fault() to not install:
>   - PTEs beyond i_size;
>   - PMD mappings across i_size;

Sorry for coming in late as usual, and complicating matters.

> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Fixes: 19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
> Fixes: 357b92761d94 ("mm/filemap: map entire large folio faultaround")

ACK to restoring the correct POSIX behaviour to those filesystems
which are being given large folios beyond EOF transparently,
without any huge= mount option to permit it.

> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")

But NAK to regressing the intentional behaviour of huge=always
on shmem/tmpfs: the page size, whenever possible, is PMD-sized.  In
6.18-rc huge=always is currently (thanks to Baolin) behaving correctly
again, as it had done for nine years: I insist we do not re-break it.

Andrew, please drop this version (and no need to worry about backports).

I'm guessing that yet another ugly shmem_file() or shmem_mapping()
exception should be good enough - I doubt you need to consider the
huge= option, just go by whether there is a huge folio already there -
though that would have an implication for the following patch.

(But what do I mean by "huge folio" above?  Do I mean large or do
I mean pmd_mappable?  It's the huge=always pmd_mappable folios I
care not to break, the mTHPy ones can be argued either way.)

Hugh

