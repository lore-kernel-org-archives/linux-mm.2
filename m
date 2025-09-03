Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EBCECA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 12:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFB5B8E0012; Wed,  3 Sep 2025 08:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AABC28E0001; Wed,  3 Sep 2025 08:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E91A8E0012; Wed,  3 Sep 2025 08:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE8D8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:58:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E7695A421
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:58:23 +0000 (UTC)
X-FDA: 83847942486.08.04F3BAA
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2B20D40015
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:58:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KqPvARNc;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MC77pG8YTMZbdsVNvsxb7MX4BGndC3HL8xv81scZppk=;
	b=f8nrUnmHL5fupe2Au490VBJViqP+KY+k9+GrDN4yPT1oJDiMiqekaPvJ0A0uJYLNW1tJso
	z46K+OL9Ucm+RKFIKqKJ6AKzkHvxnAEfBJ+//2cUO1kbzOWZWt5pY7HWUAGV3RQu+G647y
	TNqi+HdwCVz78jrUBfchS0NFgjBRYzI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KqPvARNc;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904301; a=rsa-sha256;
	cv=none;
	b=hzXDWDHhsJXrj4Mjm4QJ75tz6+9QF204UlZ8yzPLOjTvo+wXc/owmTdJKP0ZNUAE/DqPbj
	6i7ObU8Zci5KMRLhowSR/x/Ew2wllA//EkG0pPPLnXBTxRg4ogL3a4h1NBdCrnKMYw2M1K
	qSTzXikPM1GgcFq+08htOMyTLfqhsZc=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45cb5e1adf7so5927235e9.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 05:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756904300; x=1757509100; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MC77pG8YTMZbdsVNvsxb7MX4BGndC3HL8xv81scZppk=;
        b=KqPvARNcvXis/7cH+9U7DkVVlAGRflRnNSEXMnammEB/1pyfhK0P7NIYkoXcImXLH0
         VxklNYs2dbwneGUpT3mXOmo7Up1YVqfDLVKJCVEOHAiFEjnDnuL9+HNKVeBW+/wD21Sy
         aFc5B2BQ+zpxvezhRnRbn4MYDhyD8mZqs8Smb7Ju0A+iVzT0sZSBYlCZnw1eHXSVlYn/
         3naDic8y6muYa9icJyzFct1FKDvWWfJNr8JPp1bQy+XP3jLhgQxSsFvFdO2nntNy6UTS
         Ru06SmtP5bF5tUqA7Jls0IcP2jt5qqctVz/zmMmXKqzTWnKsEv5nFoE3L7fPclpzQq7i
         ao5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756904300; x=1757509100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MC77pG8YTMZbdsVNvsxb7MX4BGndC3HL8xv81scZppk=;
        b=nT8rJTG/dQ+ltltkV8lUP3HfCGX0UBPGzqawyCEnLWda2JNEDEwmlcJ3CApmjJuNQG
         hR897cfeTXCxFmPmhyqtr30EP6xyJw21M3h6ILfdqKdSCZzba4mFDcMquSIBhMUKx4kL
         Pq+y+1fJDmVUH2TUq8I982Zs36imlwpEcc8qpMkqvkNm0g9EvRs6AyBEeOqmHaXw/1nh
         kUf6TSSnBe0rS5mwXqNlfIk/amEm3zy4LzEnzlH2wxnh6ZyCgOYr27J4P4uQuPcEVc/e
         ibuHbKrI6dvIuc6ubSFnacwy7K10WLEbXTCAQwsZ/XJo1ksVLBt/3ltcW3Pkp/gQoE0E
         q78g==
X-Forwarded-Encrypted: i=1; AJvYcCWLCri5MbaWwKPjtL4Xdv72l4FCqSreIydr5RXuio9O2kw0kRjxEb0p+Ji7qI7ex4NOlm/RMjjiXA==@kvack.org
X-Gm-Message-State: AOJu0Yy8ZR3OW8C7mVMSKvd7+EiABJ9eLcK939hEr1dlaQQNENBanlbi
	+THxD99YSjGUi24gx7tgXEBLZNWelVnHkJTDVwnOD+7UjWsKM5L/KalGaqBJzSP4ebE=
X-Gm-Gg: ASbGnctXVr4X0WBBV563azIJBNp333z5eIhaljzdgVPOraRasgGR76PUKgsL+nTpkvm
	g3UopXCk8grLvSIzAXVNSx53otVqXe6mtoQJZvKtzZuy6DZH1dpTZWHG5BAANjeR6F9KjZYQ9CZ
	IN+H6An6bYmq14cJS+eZWvxeLfXu7P+mny6o62na5d31R2VpO+Q9Txz1pWNzmg3KfTOOb4521VZ
	ByS0dVVGl3U9IJ1n0g3f6tuWdqgWZVkWz5Y0ZnPFhCDC6bfb0Z6y81VvdLbUpvtQcI/4ABa6Rk5
	KQzuACob/8dGRPb5/dgVRc70kSSD6XC0POQOZ8q0pGIW9ehLu1JFhgQiomiPMBS1g9nF+006Q8D
	BMLiI6iiF5BvfS9MM4qhjPOy6wO9m4UnsjAAgiDY5svmpZg==
X-Google-Smtp-Source: AGHT+IGA/EYr9siPLdAQFtA01/sYfVZcSrreq7W5+wyFJ0oMa4bqky4nIByyFn+cR542vJGQDzatNQ==
X-Received: by 2002:a05:600c:1394:b0:45a:236a:23ba with SMTP id 5b1f17b1804b1-45b85575801mr117379825e9.22.1756904299566;
        Wed, 03 Sep 2025 05:58:19 -0700 (PDT)
Received: from localhost (109-81-86-254.rct.o2.cz. [109.81.86.254])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7e7f14bbsm245164425e9.8.2025.09.03.05.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 05:58:19 -0700 (PDT)
Date: Wed, 3 Sep 2025 14:58:18 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, liam.howlett@oracle.com,
	lorenzo.stoakes@oracle.com, surenb@google.com, liulu.liu@honor.com,
	feng.han@honor.com
Subject: Re: [PATCH v7 2/2] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
Message-ID: <aLg7ajpko2j1qV4h@tiehlicka>
References: <20250903092729.10611-1-zhongjinji@honor.com>
 <20250903092729.10611-3-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903092729.10611-3-zhongjinji@honor.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2B20D40015
X-Stat-Signature: d45xcct8ao6n47tbmgeuthm688nnfe1g
X-Rspam-User: 
X-HE-Tag: 1756904300-718924
X-HE-Meta: U2FsdGVkX18LhR6TTE2iT0ABufvgIRsbBmnh9Eq2+dai8HacEIKBA0B5i4pkVX1SdgA0MVBGOjQBhbce4M9l798gWea05qi5Po6zdWnod6X0pp5IiYfX8XQO1VmeLqzuO/Humiww9aOhjTp9QdqN4U6t46KC7BQ3acAhOzxiheI/FUYXytQ2KxQgrzpG4RXMXXf2g7onYrhjpgM8d28iOS8XA1GgIcnT/SILABoFD/PZ/CdfBs2WPlWZTV48Mpf8CY3a7vO9K+QtkGA/8ATG5u9GwdtNUJXP5N1UP7QPmSZTHOHKjOk7ppHNz4tqJ7lHi841B4GVtGv556YAfwtIljavtrpCERnI20Twfanr7fzHnS0TYNtOBkMwLymChKrnEAxABfJcl65lMwqToHOuBBZby6h3oksI0kqnhNvZTqa8W132/cgkR0UpYAdvRKzISHUpVaFIQSj9AYRSppcr6VFZST0rNMoxmQhLb4fJhV7xiVrlhX8TlAeSCEuInSqRH2R8CNu3uvOTMbr0eG9ecVLlGrovlt2Aifean3P20UiqjttbpZiZFMK1qv0LmTIi2PK97sjP8jcC53WANb8VxZNjOhvVAaiWKOb3JFxW2bxS5mNx57Qf5j7/dvEDt6e8WD4pIGq6q+SeAZu2MPy9tCAjLJ72hLkl9Kvrypg/n7sslj6O7dZT3ejzzRw6FBNnH8Z4a15OrtM7yiZTisfzh5rzHQOKbWabzEfWedW5aBn5FvE/OiR4+3RAGsoLnUcB+C/LPmRvWNRWFYKJdkc57fkQnlYf2uoOw7Z5Q6nsFBFa13wYdRPlh1/2QDO1OsGnjtOoP2kVzcPHjKdYr+c1PwtEzTZi0aBdO/JDrlYiqepM1PslyHAvNbbjvTwCUqsDuUgbsQdYIx3CY+iJVGMog+Ewu0tjsHXSBWGoC/5I33eLTKryOlExwAsb8G6w+LDFOvbE0qwr5qLwA4W1swS
 2G0JSALa
 1r60+jAvKgj1Rj7z9+LnZnmX5MHdQZx+3vf2Mw7A2HzUlPr1SMY5PN1A8FsF45HFr4k0oMDZt71aBphvfJqvLXtiqIKq5Pxp24BmjQsAJBr7jcaB7vRqlWiKU2qD95U6uT7XceHlB0klxE2eM9CigC18flB3NOP6k6AI6nmLRBC2khQZAGrHXhVxgv2CZ4aBtcQ+QqozxlFpuVpoOUwlNDoaB9fiGq2AJ09gPyNZmCdRsKdmbfb2n5DvHzr4FHbxpFfjIMgqo91RBmW7eq0qG5ky65Ru8DJmeYyVyelqEaOeR1fC18VYbpe68QUYw8TK85pOi+ZxxxEl4IbfRvCNkTOoNB1VqOkjZVSeZhc04i+iXraaGXpSMx6gCirxxC0Z+Gt76MC1hx9ejy/RLliFUbQHv799AgGY3QW6OEnt33+1PEO3lL96F9gU2g2fFDRaKN3nPgcV380zGvOvyscBol2Hz6f8yoB9tGCrs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 03-09-25 17:27:29, zhongjinji wrote:
> Although the oom_reaper is delayed and it gives the oom victim chance to
> clean up its address space this might take a while especially for
> processes with a large address space footprint. In those cases
> oom_reaper might start racing with the dying task and compete for shared
> resources - e.g. page table lock contention has been observed.
> 
> Reduce those races by reaping the oom victim from the other end of the
> address space.
> 
> It is also a significant improvement for process_mrelease(). When a process
> is killed, process_mrelease is used to reap the killed process and often
> runs concurrently with the dying task. The test data shows that after
> applying the patch, lock contention is greatly reduced during the procedure
> of reaping the killed process.

Thank you this is much better!

> Without the patch:
> |--99.74%-- oom_reaper
> |  |--76.67%-- unmap_page_range
> |  |  |--33.70%-- __pte_offset_map_lock
> |  |  |  |--98.46%-- _raw_spin_lock
> |  |  |--27.61%-- free_swap_and_cache_nr
> |  |  |--16.40%-- folio_remove_rmap_ptes
> |  |  |--12.25%-- tlb_flush_mmu
> |  |--12.61%-- tlb_finish_mmu
> 
> With the patch:
> |--98.84%-- oom_reaper
> |  |--53.45%-- unmap_page_range
> |  |  |--24.29%-- [hit in function]
> |  |  |--48.06%-- folio_remove_rmap_ptes
> |  |  |--17.99%-- tlb_flush_mmu
> |  |  |--1.72%-- __pte_offset_map_lock
> |  |--30.43%-- tlb_finish_mmu

Just curious. Do I read this correctly that the overall speedup is
mostly eaten by contention over tlb_finish_mmu?

> Signed-off-by: zhongjinji <zhongjinji@honor.com>

Anyway, the change on its own makes sense to me
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks for working on the changelog improvements.

> ---
>  mm/oom_kill.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 3caaafc896d4..540b1e5e0e46 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -516,7 +516,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  {
>  	struct vm_area_struct *vma;
>  	bool ret = true;
> -	VMA_ITERATOR(vmi, mm, 0);
> +	MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);
>  
>  	/*
>  	 * Tell all users of get_user/copy_from_user etc... that the content
> @@ -526,7 +526,13 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  	 */
>  	set_bit(MMF_UNSTABLE, &mm->flags);
>  
> -	for_each_vma(vmi, vma) {
> +	/*
> +	 * It might start racing with the dying task and compete for shared
> +	 * resources - e.g. page table lock contention has been observed.
> +	 * Reduce those races by reaping the oom victim from the other end
> +	 * of the address space.
> +	 */
> +	mas_for_each_rev(&mas, vma, 0) {
>  		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
>  			continue;
>  
> -- 
> 2.17.1
> 

-- 
Michal Hocko
SUSE Labs

