Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E6E41091910
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 19:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44046B008A; Thu, 19 Mar 2026 15:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1B6E6B0095; Thu, 19 Mar 2026 15:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58226B009F; Thu, 19 Mar 2026 15:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1AA66B008A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:17:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 566FA1DE96
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:17:39 +0000 (UTC)
X-FDA: 84563771838.04.0D215FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A10D68000F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:17:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q5w1G2MK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773947857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRVYjwYxxWNmImovP5N6LXi4Dlcktt+S+v5JF+iP+Xc=;
	b=65KgItoKT3g6r/SPbAYgJ3U/roNYoYOloNAEADKgu/JMZyn0vgJM/R5a4gzFFziWlW1Ig4
	7fIOYOd82N28S9Fhwv66KKW27/YjdpbmTGpQKdCMZ87cBa28xwb377pLUEG+e4xtXi+grE
	jZEeohWB5+1Gu9ewFHTXtX1H8OMV2kY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q5w1G2MK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773947857; a=rsa-sha256;
	cv=none;
	b=IL0MYnHUZ9fRUD6kh0NGhB023NMdOgCoHVGXoljcZd9qMqhrjzRTS5CBXfjGda0w1QK1et
	WhNjDOlgO7C9M3j92FXTcbKI2Wr3qkahF+IoC4IkzuEeIA3pwyFvBAFyO7qidsR59IK6Eq
	Vq6+ziXZ61d9mKoEI+D5ZUvXDkLYpCs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 23EBD60053;
	Thu, 19 Mar 2026 19:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCFEC19424;
	Thu, 19 Mar 2026 19:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773947856;
	bh=xLlly0zXnvK9lciidYf/eatybLs8RCfnR08RyclSc2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q5w1G2MKSsAt7mEeopWuOqcjbQz+Ew0DNHX3yM9aCOQm8QoSbQPSaXg+wQQHdlYja
	 PmFWNyu2unQLrOWSTolwXVW9UlQKfFVP8EdQV6J05oRMhjwUHYzC7tAiaIeC36YxXb
	 FgBXsX/p1mE7KLGsZKj/lGK4AGVOdZKs5Rp7Boh4ZDtAma1u88dtjVaA11sIKSxqDu
	 598bOm60DwHfFMKOcQJII705SyXU9XO88HR4hsI3hV8FReKK8vcbFCydPG7HZEBC/P
	 1e1fsW4C+459kxFUng/W9ELqGoZ2bQWmvBbg0/k0maLrB926O8WuPa85HSd07OMZyw
	 demUq6ypNcMyw==
Date: Thu, 19 Mar 2026 19:17:31 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm/mprotect: special-case small folios when applying
 write permissions
Message-ID: <1cfe61ec-a910-4cb7-9714-410e37f692c9@lucifer.local>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-5-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319183108.1105090-5-pfalcato@suse.de>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A10D68000F
X-Stat-Signature: 4qqhihoww3j4rhsebjzu6xyn679gk3mt
X-Rspam-User: 
X-HE-Tag: 1773947857-894659
X-HE-Meta: U2FsdGVkX1/mAOkoRxsFQ0xDAd2awAunkHiVgSKoFZcOFzZADmRWj7ttMdqYd6NzJ9C9+u6ZA0SCpW963vv/ptWJh03J3mzXKzzFy/EEH42BauDjfpp89+qk4KpVDDAfwimXqgFv8TwPz3RXz4ixMZEexftZKxzdxbZ/CxbYBAZwFmVNWMG8LHLCHqxMHvs/aQQ0wEuXltttemAaITsMoshWBUrtJJhFaDbY20/6UTEzt0kPF5A1xzZszdJQFZJlqNsi8zjzI1Ty+19p9jVHS0T1G+g24uey0iDSdn44SsmEb612yo6pyl6JhFROIiHGx+meqjbL79IxyC8B3SAwDJoaGKvOOsOqlPiQ8L4P9ov1bXM/z1QR0ry/eR+kBDBhYGg9R0wke7X1FGTOrRTGAwg0YHe0papAw3wr/rtJH4yQ0YDfgq0PbQ7w6gFUt/bjSPKIhPMQ5Imkfgsb0TDPpFBYw1b9t3/e87XsZakGB6UhzGC9T3Kvxq3XV+fY2YtYVC3VYOC5wj7Ll6uUGqC5I+z5G5vhcr8W8DaovwQ5PpAb4JQHhA4RIbj7yVz/3YwTWiTeM/d504bzmvky2eVtV/15bTiyp/rmpsK4PybTVqldCnMF2IvvyUYMZue+oWxlPRx3Vk+8qrzFi4lrV7Yz7PKYzDGJKhoQxIbky/RdwIxfXOkbIX6excx5UgnLGUzYUzw3BcQw287wgk9M53YNlAbe6FDGIVC210cuGAJN+X+CKJIp3XG0hZZDPOMzdLeZRBnzY5a7VLT07ljAXtXi5Vjj2unRaihg1UrHy4plDMi2G8IMv8VfHAYndYjoD26LtIbz7jg97FWH+Fk0vd1ymfNXzg7/1BrAN3vsFOTyddTkRx/GFdVMXvkRv2nfVJl3hjuGwY+QrCnHSZ76KVtSs2esY5ErHbyNplLnErR+otCLCy4Wlsn6JAuej1G5maY+gSUmcMq2KhWiBW1/g/G
 GWmO2D1m
 MmZWBTKaNvQdQJAcfiqtMjV7o7uk59P/qj+8ICh1ecQbVW2j7/TE7Q4hDGeO/sDaZHBhBSCMaxH6dasoMKf9Rjftt9fSWuH3hjLOuMgQGeuUmlKi5FI0G22eZhK1Yp0YUdeMREvfSYbUhkRW924C6T88iyNleYi3GbtgMnuOJr2Bx+xFRAlY0b8me2XCKgK5xzK15YN0K3bMgU9KB1C2mOn3OKkWleDnfmPCS4XWPgN5n+Go=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 06:31:08PM +0000, Pedro Falcato wrote:
> The common order-0 case is important enough to want its own branch, and
> avoids the hairy, large loop logic that the CPU does not seem to handle
> particularly well.
>

I think it'd be good to get a sense per-commit what the perf impact is.

> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

I am iffy on the likely() in the same way I am always iffy on non-profile backed
likely()/unlikely() but this change seems sensible enough so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/mprotect.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index aa845f5bf14d..23a741f9a4c8 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -170,6 +170,13 @@ static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
>  	int sub_batch_idx = 0;
>  	int len;
>
> +	/* Optimize for the common order-0 case. */
> +	if (likely(nr_ptes == 1)) {

I mean I we're likely()'ing here without data to back it, but I guess I believe
this one :)

> +		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, 1,
> +				       0, PageAnonExclusive(first_page), tlb);
> +		return;
> +	}
> +
>  	while (nr_ptes) {
>  		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
>  		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
> --
> 2.53.0
>

Cheers, Lorenzo

