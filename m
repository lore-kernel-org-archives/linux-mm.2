Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57EA7606A320
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 22:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PFvSnOch
Received: by kanga.kvack.org (Postfix)
	id 392756B05B2; Fri, 30 Oct 2026 18:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36A476B05B3; Fri, 30 Oct 2026 18:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A77D6B05B4; Fri, 30 Oct 2026 18:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06E106B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 18:54:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96EF91407ED
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:54:22 +0000 (UTC)
X-FDA: 85380797964.16.5E98EF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CE21080005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:54:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PFvSnOch;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793400861;
	b=BwmUyY6b5MqQOTJFoDqHvS0UNrE0QDeC1sJmCATqRdhMq4ByUQnMmOrVL0sYKo9LzTPsE4
	88Po3nIJtyDDp1fpVHp6OHZyQOUy81G9CxwLV2L7ePVUwUDBvHSB16kSWf68jfZikDNC/O
	2x2CecpiW2U6aFKLqMffGdUEhUVKpVk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PFvSnOch;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793400861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B4oUzWtr+h3zt3CPlzIuso3ePnMgdYDn2x9olNeUBOg=;
	b=eecFwfrMSd+yNQnM6yDfstuBSxax/DBJOMZzJBJbTGqvbI+Wf0UklvUMihTTw7wfohf8Y6
	gO1kVbvlTlzzfyU4kWi0ghnvyabMWxfzL/u4irsD3NM9BPh3u6IqqfAJhqqfzfaWnGaXXX
	DRCvDx0S9zt9Q85SnWb1oLf7TsTbITQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67EB8601EE;
	Fri, 30 Oct 2026 22:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70651F000C1;
	Fri, 30 Oct 2026 22:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793400860;
	bh=B4oUzWtr+h3zt3CPlzIuso3ePnMgdYDn2x9olNeUBOg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PFvSnOchgYwfhYQGiUez99CKhmSXHfQWtwDa8ha9StJx+R4Lnes/u2+NSOfu7IbJJ
	 tSnVGA10DWzHsHpPeLK6rlselFeZZLeOMMGkareStGWpHPlkq1qrNxLviEUHPHZQDD
	 xsrWz0tIc+m4A1pfMQ5m0NJYG4PvBUrdQMfqtTN8=
Date: Fri, 30 Oct 2026 15:54:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mani Tofigh <mt4022@columbia.edu>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/swapfile: drop a large unmapped swap-in folio in
 unuse_pte()
Message-Id: <20261030155419.b10056c8fb37bc784b0d2778@linux-foundation.org>
In-Reply-To: <20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu>
References: <20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CE21080005
X-Stat-Signature: tchrbo8t9ik5y56wzhpzqw5oettxisj3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793400860-866733
X-HE-Meta: U2FsdGVkX1+dR3OjWOk53sW9IsUvTVQtJZnbukzqDCdlcmzPC92vCURfMVWcVCibv6DA8wtAj+GP/+kLPIh853JFKpiPUYxTlZ55PxJmpgtiDJcSdgJ6/JmdTvTzQPVMls3kh61DFE/bQr5u1NkKxISUkkaQmhG/S9V1eUOB59IME/30AcRrdNhUla/ni+f25Gnu8n6+XmKJf5oxjZ83Azp1VQyCGo7EoX3qJwHA/irIycBDluBm4fmaoHg0rOdlnPPF9B3uHgWNa3f3iK4lpDbmksm9SMA+MVD1w8sIUKMvT4S9BB3OCkvwYYYXi2cS0eaSQq9R6iB4oUnAqIvhqU591/THQCvcX+TOq2uiyKjo8iVSCa//FWkJX/Suh3Ub3fMkWTzKuGpzKjC7PqteBbMcTldHVbzQfiGgsbLJ8SqyKJUnHQaKhV1tG0c3x81bXRxpYdzqJFE7e1tPfGZQiHE0EzCGtHATftIotz3jOIDDAqadchluR6YtN4lFf/tkS4KMzZsmK+M5rkOSVp8EOU6aFaQMMVy0IWxgO7kRQqMViUo/1/+RJ35wjHGpOKItXyMsEAp/nNZkZo5Sic0TzKgfPQ8jxk8YJS8Jwr/J4J4qyZbHts1QXgqqLsa0X8TcQwSAnRAeJz35ZqWq1RS+mqFtVyHfT3q8mHK29V3w6d+uHEr0zS+63Gwd7CEEreERWQoexBebrLy7V3yiS7+n5bHVfoGl85kEcq2DrLxCRyzTfJwBCAD4bkdak6IVrdE8mnpu2f+eb3PAGA/YmN/+GMvAck9WhTJjaIYLCNd+//FlU8tMfdqfPAEpMnSgADYSkXaW0r/L2a6T88vXuvia6akI9igz2X2XzYOjzWJkdnRijV+I24USpnkHfRM+NEaaIWjKAreLefv563K59vzo73AueKpLPNRw2d7Mh2qCpWQPGDOP5pnO7YWVSX9z05zvlv3Wy15IezLDdyZNF0r
 kD8ggadL
 SSN3WzpqUihEL9mOOY71Ja+hTxr+XNJL8pl3+0t+Cnn33IbwMwU4umKNLYOzzYTiZWYyLQ27DJx99EUZUPn6z9irgxByk4jHqoWV7rXtsL+bIwK0pWMEayvtOTePuQufgrAASBwos9Vsc5+52lh1Oh/hUvOtPeD6Vu+Pj4t3P3MMCC2itDIRjH24vrJ4nGTXJzZ5iG0r4f1q1vU1GMLKJ1wdK4lZo9RlcLNepnVGLbCx3PN+dDosnkZhb0q7jl+ICyWiuYrWuiAtK/DTsvPLeMZjJAMvtTyxL7pecC5nP0vPJqzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 15:11:56 -0400 Mani Tofigh <mt4022@columbia.edu> wrote:

> Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
> for SWP_SYNCHRONOUS_IO"), a fault can read a swapped-out mTHP range into
> one large folio in the swap cache.  The folio only becomes anon once
> do_swap_page() maps all of it, so if the faulting PTE changes in the
> meantime the folio stays in the swap cache while not being mapped or
> anon:
> 
>   Task A (fault)                       Task B
>   do_swap_page()
>     /* swaps in large folio F */
>                                        madvise(MADV_DONTNEED)
>                                          /* zaps the faulting PTE */
>     /* PTE changed (F not mapped) */
> 
> swapoff then maps it, which marks all of its pages as mapped and
> exclusive, and the next fault on one of the other PTEs crashes in
> do_swap_page():
> 
>   [    6.424485] kernel BUG at mm/memory.c:5195!
> 
> ...
>
> do_swap_page() already drops such a folio from the swap cache when it
> can't map all of it.  Do the same in unuse_pte() so that swapoff swaps
> the entries in again.  With the fix, nothing is reported.
> 
> This bug was identified and confirmed with the help of a deterministic
> hypervisor currently under development.  The C reproducer below however
> hits it within a second.
> 
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2518,6 +2518,18 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
>  	if (!folio_matches_swap_entry(folio, entry))
>  		return 0;
>  
> +	/*
> +	 * A large folio that is not anon yet was swapped in by a page fault
> +	 * that did not map it (yet). It can only be mapped as a whole, by
> +	 * do_swap_page(). Drop it from the swap cache and swap in small
> +	 * folios instead.
> +	 */
> +	if (unlikely(folio_test_large(folio) && !folio_test_anon(folio))) {
> +		if (!WARN_ON_ONCE(folio_test_dirty(folio)))
> +			swap_cache_del_folio(folio);
> +		return 0;
> +	}

Let's not WARN here.  If it hits and someone reports it, what do we
tell them?  "uh, that's working as designed, no action needed".

Also, won't this change cause try_to_unuse() to keep spinning away until
someone kills it?  Might be better to return -EBUSY and fail the
swapoff?


