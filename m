Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FFCD606D80F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gGc2rdW9
Received: by kanga.kvack.org (Postfix)
	id 83CFA6B05BF; Tue,  3 Nov 2026 03:35:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED946B05C5; Tue,  3 Nov 2026 03:35:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72B2B6B05C6; Tue,  3 Nov 2026 03:35:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 520476B05BF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:35:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C145A160344
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:35:33 +0000 (UTC)
X-FDA: 85393148946.14.335AA39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3732E20009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:35:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gGc2rdW9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtLDQNeDogoEZy8VqwmMu80kkbHazW0uml5D/A0dqsE=;
	b=vAJlZWApn2nSHki4dTE8DGClYB4J9539TpUW/u+Sm5LvO/Mv+L2U0W9Kso54Mo1DKOG4jU
	f9Xrg/+srnstBAn6K6HPNnvopvfB0RJUesJbkJ+9MoWCYjLQzH+mJLRZw73X5oXOGvANMF
	HBX6DiT2aD/1sCiltPp1cTCyMTZh8nQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694932;
	b=C5J0nK8USRlJByxuK8ICyYOAJIxXbfE9eP7rJg5HJX2J3z3jek+ufAuIO5OmVdwWdZ8B86
	GJrBGvfdZBrEOAh/OAZjgl/VVcmHwh89X+qYOjKAL7NnSczMczWBkKcqvFZK2wqRe0wtrC
	paXLqqBc/FiZSkXLCK0aJdBQJ/jujeQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gGc2rdW9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AEA9B60628;
	Tue,  3 Nov 2026 08:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F961F00A1A;
	Tue,  3 Nov 2026 08:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694931;
	bh=WtLDQNeDogoEZy8VqwmMu80kkbHazW0uml5D/A0dqsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gGc2rdW94xM36KoC6xgtpfh7Js0emN9AvZwCb5wnUR5DoAaUNlYav9YOq4gvBJ6rp
	 prcXRznN3YQWdr305TuXYsR1+dOZ82olvCCYuPkiWwfwDsHHVpaU0pUAq7PT8gIlFx
	 l/Whi1/4h/KxZAJXta8YJ25jCzLAEnzMj3lQ8cPQPS+xeRr+SRI8d3n5uc8k9Ry+Hx
	 B3iz//U/i7JAnR5NlBhB8qNYXo6MwwUNcz4YfveejPVCf0fbbPFnKAKyowHux0mCt+
	 gRzm5Gwj042rC3vXZbZ5xNNd094BtZOccNWhykB2bEQ0H28MjQPGgU2MkbaG0oyjpN
	 zTiwesgLuYEfA==
Date: Tue, 3 Nov 2026 08:35:23 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] mm: remove find_get_page_flags()
Message-ID: <aumcutKJoj2EoE-J@gremlin>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102-page-wrappers-v1-5-e7280bdb31f6@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-page-wrappers-v1-5-e7280bdb31f6@columbia.edu>
X-Stat-Signature: fh68iu7owy4e3ssu3uh71ma8nwtfnmfb
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3732E20009
X-HE-Tag: 1793694932-704593
X-HE-Meta: U2FsdGVkX1+ooLDU8MOjOM9C7ZVqRqneTToRWZSy7Vj7bhVXyohBS/bScqpGrH5+Fs1sbx/XssYawqstEDnndRrlmbItifDTvXBDZq32JvhmiYk797vHXiyA8DuyaokC0An3FVPPyCRuK+X5lB/nkKD8GASVhhdii4RK/IllhhKwSbtT2bfWDZDij3LejwPPPHUPplq9a02ZRn8QxSjNSxnb4zQoo7rdwItU9H9RRMbxEZpDZ8eRCk3a27NEQCDdXGHMAX/yVW1UsFZpyEYxUQ0qXvsQ7aEpB4M6CeXt+44NUcJ9+QweTSwcuMElQpWz+5zcC1zldv3ev+LrX1PuRfD0GC+9uvTMUCDnbZHQTAu6qvjjrlhWBQ6U+yAg3SuZpvTIxeCo9lWBuiIaL4iam0kmRgJCvLNLlS6S6HnKthVgmX61uuBg+18B4H5IBUEhv6t/m89jvzjN/lka357bKWs6HkMyl/PjSKNaQt1iQgastzDt0yNV+za1b+B3RtPbKtCMlUWPTU3CR+JKDL/iwpLb4+nxpyeI+sV5NKmN5NT8K2iz9dtCL5elgHcROFkweRG8SLMLv0eiC10aJy3BMbWhNgSH5DGrIFr0iceTgIRbR/ixKj8teMKEACiDQnS8ehRQxmSCCvW9t5Tjbo3Fkd1mz3i5jU/wIiAlcuMBTlRQZFPPImUn5OcRoWzNbty70DezfMYq57TVbU3IsX+fIO7z4sYJCfEEJfPaXaWIYDDDcLUQbfz4e9hmj13YKrBXNEkw9Inf++xARJUUMv3TwzYEAq/SyqHHGYBDvzg1BB1OCWGkESu4ZhG7YNH9uUqILWjailUFmNH4DgNdqBVAjbnwASiezWIKz+UtQrEGXE8joJpP5g4Vno2ligBKZOsa5R66oC+sLTh0YGTrDRke4/9BK6pBi76bGWEdL/95FDTSC6NGFxbTniVlsN75zhda2iEI9HuHSv2UDNnElqJ
 xYsaUgrV
 k+iwACr94eZQVnbGo9wNyf9dsy5/2v3PV3K0vyNY6uPXgw6n4OYmqc6ZT2ZP8zqbxKj350tIB0RaXPPDQzFPYVZqXYLzi/gEOMgH4H8/cHJJiy/gOjamZ5SZYrj5DRMWPl5quELCo2l2VibRcneCo5iN4ahxOCI5K769l6s62txBtjbmMOnBrMmPYiIStR9SJ2u/DdfgeDQU8p3QaG4R3tD4Xhq41kVnfgdL3nHIzA7JybGjWTKKStGyIYwKMITm6xxq6NSyAfcl4mEezIaOnUqfcl98b4KturyH6w9hzhS7KGgozMFwCxxIUO9c6C2nt+2MF14BfbysAGBzYu9p4gS8D9GVKLSJdpQL9MEBkr+dYryDmJ2/WQo0yHrTyc5YzK2FkBy98jK7ck8c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 05:54:10PM -0500, Tal Zussman wrote:
> There are no callers left. Remove it.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

LGTM

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/pagemap.h | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 37b7786350c5..00e32f96b459 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -846,12 +846,6 @@ static inline struct page *find_get_page(struct address_space *mapping,
>  	return pagecache_get_page(mapping, offset, 0, 0);
>  }
>
> -static inline struct page *find_get_page_flags(struct address_space *mapping,
> -					pgoff_t offset, fgf_t fgp_flags)
> -{
> -	return pagecache_get_page(mapping, offset, fgp_flags, 0);
> -}
> -
>  /**
>   * find_lock_page - locate, pin and lock a pagecache page
>   * @mapping: the address_space to search
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

