Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E41606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DYTWaPyk
Received: by kanga.kvack.org (Postfix)
	id 988FA6B05B1; Mon,  9 Nov 2026 11:11:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939E26B05B9; Mon,  9 Nov 2026 11:11:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853206B05BB; Mon,  9 Nov 2026 11:11:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE4F6B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:11:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C441880756
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:11:48 +0000 (UTC)
X-FDA: 85416071496.03.5081E4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3288740009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:11:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DYTWaPyk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apKKuKLeW7fYkH3re1fsKWBUmMYFNZXZBCBlzYMpJB4=;
	b=KCl0c57qncLL/NqTg/TVPueSUNYcn0fgV19gbPLlv8X3RjBLS+VZTo4hBBIp+s6ew5AjOp
	SX8dTYXd7ZXCu5mmImSaBQKAzAbFT9cu6P+bc9mX5HHLFDPIVjgbkARESGya3BDG3Ht3kE
	dafo/UuFT9AA+cnH2Iam9ShIzyNAqXk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DYTWaPyk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240707;
	b=f1Al+U8Jmc09zhZONlN7eZaXatJR+Mtuf3VenZQav87NJHI2JIh1dXYZUheHf1liMgklhC
	tqal5OyljWvRiDYGeNy74Ml1F4ojiOOT+hyZtES9Z0b5wzgjGweEPTMjV93LSRA0T26NEz
	irrS+PkhHv/Nh8L9bzkuj3hDFvu9Xjc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4A6360E07;
	Mon,  9 Nov 2026 16:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FE31F0089F;
	Mon,  9 Nov 2026 16:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794240706;
	bh=apKKuKLeW7fYkH3re1fsKWBUmMYFNZXZBCBlzYMpJB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DYTWaPykIpx6JkYTBw++lHZOecG26/qX/H5ir7r9wPn+ghcrQc51mpO5nyJBjswdE
	 2CfWBYOijg97eQqEQ9UUErtUun8nYwhrrTi4/rdAWiqVFqED9q4yjqnLSFs8g9lbpJ
	 XcOHjYSmqOVZxHRjLFVcsosDR2AJWhHkG8BReGvtnbErXGteX4+B2+z3n7z0Q4crq1
	 sd4dtejnQqbwIWQC36hk1dmXJMFw5J9ksIvgmwogTeIqqWlRaVybtENmL3qlUyRGzc
	 sx4IJJEx5i9cu0LI2yjNaF0Qv95aR08j8raojJJsjFQBdmOy0oYNyi11QeqpGh7UVr
	 22E6X5TErFvgQ==
Date: Mon, 9 Nov 2026 16:11:40 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 1/2] mm/memory: recheck PG_uptodate after
 ->page_mkwrite()
Message-ID: <avHWhZzXE-ge6nU6@gremlin>
References: <20261109120403.82361-1-kas@kernel.org>
 <20261109120403.82361-2-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109120403.82361-2-kas@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3288740009
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: shonyw68t6dkr1s6f71o7rpk7tugu9wg
X-HE-Tag: 1794240707-136789
X-HE-Meta: U2FsdGVkX18zh3k5X5zQHKWwmKzYaRyaVO9eZONVF5q5D7LmD3MBAxbPS0muvluy8SGq27OEFSOBijcxSyI9hzk1UItiKSlpTbBCr/Qafnm7UBBePy3Lj0CuLHHsZWQ909vxad9kISre+hSTJDRFfNuD4jneFGAshI9NDmUyUFHAjOuh3inuC0eGjXvC4IttYnTDF88Vbx0/T4KKg5jTQnSzsD4QGv8GzVd2vYS+6udvOD1ia1t0vAv4TJIHRWWGanaiFBvTwvbFmxLieQOH593xzcMGlsRE+OuH/iq1gRniCZU5vlUSEJKHgNK/DZx6sPrLk8lulhtDRSLxf5iHGa3Bf5jL96iIIgo0nzCHnNgKqS6byJjOeWwAAnje6HFnfO/0dNAqy8a0Lk5hLQNkNDoJxHFjs2jR+K7Fjq5obzNuWs/6rAmcaXVf1iisR9q/A7xhbXUK1IuTKFihlIY9CcbO8uQlaUahCndkqIBDZhbQiMKn2p/EoDYITkNE+4dQTS1KhiWV7V12CMBChJryzIk3efYbfr+8SeQlEVlifnUKn/Lx4fH2jZnbcBLNJaB9MPLeesHdg+YUNEZ0EofyFhmIga5JwygvAJ7rDE736xw/4av6ZzvlBs31qQ366tGHvM7rFL23+lmjcB7Chb/XzL/9RplQXUJlFrfbX04YXxP7vrSE+NIAYDfEEChvShYPNkMZqeRtuUcQfLjJmpmuht2HMXhr/BgtCOh2h7ys1F4vO8madCYhc2wp4vju9Zh/1Tm8mIPQbV9uujiIaz3RXxtsDnPM7e2DD+rlLbIQ9oibrSjqjsmevEo67jTWWCPXxe+8oH6glP2poX7QpZVr5wQUy+8rKIu9OM+cCZcK5xm4WOSkHrxzvjI6YOD8/yz2A39/y3Wr93Pi1o6zeecXSjimSXaZnLirHRtLu/2Ht5FzSNL+jw6H6DrBSl7A+j4ABfc50Mf0QlfFftJTrUY
 JIiIYGBT
 L69BZu7UFRqMPAklXd2LRDwNol8QR+cw5j13Jfb3mkgkYBjVqOCoTXRDpZaHDdy3soSZseUvMHfCxroC/Ox4qvCYJqZEP0cZK0QMQxtkYDU8APpJhPfxQGqtZfwIVt1/09aUcMoU5nIFzFPxXHpklyH4qtku0YEMAi2djI6GvgeRrjyoiFO9ko/RR2qvICDz4gDrojQiZepDwb1Q2P2p/mxf17WjKC8kFw1jz0FvLLmEnp73D2gh0tdBAUorH/K+xhEV+FSjAKv8vQcgTprZtnAE5vZxDFjonCVtBvPDAcQNo/ZUlpeEjDX8nlFbWV6T5D+Ao
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 12:04:01PM +0000, Kiryl Shutsemau (Meta) wrote:
> do_shared_fault() unlocks the folio around ->page_mkwrite(). Writeback
> can lock it in that window, fail, and clear PG_uptodate with the folio
> left in the page cache. ecryptfs_writepages() does this when encryption
> fails. filemap_page_mkwrite() relocks the folio and checks only
> ->mapping, so the fault maps a folio that is not uptodate:
>
>     CPU0                            CPU1
>     do_shared_fault()
>       folio_unlock()
>                                     ecryptfs_writepages()
>                                       folio_clear_uptodate()
>       filemap_page_mkwrite()
>         folio_lock()
>       finish_fault()
>
> The next read(2) or fault on the folio reads it in again from the file,
> over anything stored through the mapping in the meantime. Those stores
> are lost.
>
> Recheck PG_uptodate once ->page_mkwrite() returns with the folio locked,
> and retry the fault if it is clear, the same way filemap_fault() retries
> on a cached folio that lost PG_uptodate. Skip folios outside the page
> cache: driver pages from ->fault() never get PG_uptodate and would
> retry forever.
>
> The check stays out of do_page_mkwrite(): wp_page_shared() calls it on
> a folio that is still mapped, and a retry there would fault on the same
> PTE forever.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/sashiko-outbox-202966@kernel.org/

No Fixes? Sorry I may have missed context from v1 here :)

> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/memory.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index fe72e66c9c2e..cc1d0b7d15c7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5613,6 +5613,18 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  	return VM_FAULT_OOM;
>  }
>
> +/*
> + * A page cache folio that is not uptodate holds data that was never read in
> + * or cleared, and mapping it leaks stale memory to userspace.
> + */
> +static bool file_folio_not_uptodate(struct folio *folio)
> +{
> +	if (likely(folio_test_uptodate(folio)))
> +		return false;
> +	/* Driver pages from ->fault() never get PG_uptodate */

I guess you mean drivers that return non-page cache folios from ->fault()?
Because the driver could return page cache folios there (e.g. shmem), in
which case folio->mapping would be set (set on being added to the page
cache).

But also things are complicated by DAX (of course) which _does_ set
folio->mapping but installs the folio itself so won't reach the test
anyway.

So I think 'rmappable' is the better thing to say given DAX and, given this
is fiddly, maybe worth explicitly pointing out that ->fault might return
non-rmappable folios, e.g.:

	/*
	 * Drivers which specify ->fault() might return non-rmappable folios
	 * (in which case no PG_uptodate).
	 */

> +	return !folio_test_anon(folio) && folio->mapping;

Technically folio_test_anon() can never return true based on where this is
called from right? Could this just be a:

	VM_WARN_ON_ONCE(folio_test_anon(folio));
	/* ... comment */
	return folio->mapping;

Instead?

(Note that __folio_add_file_rmap() asserts on folio_test_anon(folio)).

> +}
> +
>  /*
>   * Either the VMA lock or the mmap_lock must have been held on entry
>   * (see FAULT_FLAG_VMA_LOCK) and may have been released depending on
> @@ -6163,6 +6175,16 @@ static vm_fault_t do_shared_fault(struct vm_fault *vmf)
>  			folio_put(folio);
>  			return tmp;
>  		}
> +
> +		/*
> +		 * The folio was unlocked for ->page_mkwrite(). If it lost
> +		 * PG_uptodate meanwhile, retry the fault to read it in again.
> +		 */
> +		if (unlikely(file_folio_not_uptodate(folio))) {

As Pedro said, I think this unlikely() is probably unnecessary given the true
return case is implicitly unlikely.

> +			folio_unlock(folio);
> +			folio_put(folio);
> +			return VM_FAULT_NOPAGE;
> +		}
>  	}
>
>  	ret |= finish_fault(vmf);
> --
> 2.54.0
>

--
Cheers, Lorenzo

