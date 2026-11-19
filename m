Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A4EB606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YhIDgp/g
Received: by kanga.kvack.org (Postfix)
	id 656936B0620; Thu, 19 Nov 2026 08:46:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607156B0653; Thu, 19 Nov 2026 08:46:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543D96B0660; Thu, 19 Nov 2026 08:46:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7B26B0620
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:46:58 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3179AA0B07
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:46:57 +0000 (UTC)
X-FDA: 85451994474.14.26B7098
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8BB7B4000F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:46:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YhIDgp/g";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795096015;
	b=e4auFH8HcnTgvVk9R/Txxc0Z9U6LLWklKO8DQqdBuT0HhVIUODKEPra2F5HxcQx2KhnYQg
	uW93BKdpELcnJP54cQO5NABtcoOn0naRS4wlr3+JhH7FanJhAsuvlOVlOloZdnuYe0o10z
	bcMGJBb8DlBOhWMgcxwUAWiOpc0uJ50=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795096015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2A5NZTqls9QFw63SbXMQUkuhwEvR7r1jIlMHqoli2s=;
	b=sKuiw8XzM74cocWZCNsnLqtB5vozHrdNCDvjnTfMK9kynVnigt42QkzhjAPyY1fd/VbEA7
	KDCSsRvo6x5LBeNybTn5ZJ1BTr/YD6KzgYLYnJ0ZZdYrk9CEUYZQKI+OikVP8kEpCmqbcj
	oHcoecSmieM68q7Xrh1GpQ5XEWyfaCM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YhIDgp/g";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD11B62383;
	Thu, 19 Nov 2026 13:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313681F000C4;
	Thu, 19 Nov 2026 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795096014;
	bh=p2A5NZTqls9QFw63SbXMQUkuhwEvR7r1jIlMHqoli2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YhIDgp/gwt5U8Q6JNCbruZo5se2dpM1Q8YIhAT57WtkPXD4xwr/p+LwXY7wlicBvS
	 o6yd4ag1x9MEtMKQ75XVgiI7Tk32WHCyfXRomq9cG7Rzs+s6tF37ypHgjIqaSXQYAB
	 Kd8/Mnx5S2SQx+65k5CxWUUFlat1w5dL4wc03TCpgrygAKr9BSjKc6T1fCPGWG0mlT
	 8X9JAhUfqcIBvEn98AXqn35feK1kOaEJjhdZGbnJSPNxz0QVWnF1Ts2Tp+0gX6zb/M
	 5sHqYMwcT3KyQQ7/qyT72TpdSK2LRE9zZBusN/26f5RSKXQC0PNzodiTjrlyH2j1Yw
	 y+PW2/jGyyY0w==
Date: Thu, 19 Nov 2026 13:46:48 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>, "Liam R. Howlett" <liam@infradead.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 1/3] mm/memory: remove unused
 vmf_insert_mixed_mkwrite()
Message-ID: <av79tKo4-uM5oZbh@gremlin>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
 <20261002160535.661399-2-ekffu200098@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002160535.661399-2-ekffu200098@gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8BB7B4000F
X-Rspam-User:
X-Stat-Signature: 494xz7wcrpihxnoqih1159we9ku9akab
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795096015-242767
X-HE-Meta: U2FsdGVkX183M0KFjojmQ2vRiEKZCANlXwvGKv8O/iyd8YEhddmVHzjvxyS5jojvUPiGVGxwWf2oItBbQCNbdEOL6bdXKvsx+FuJZNpNtwOjLQPKTb9WezSEjePn5bwDQ5/RfHzfvI5ZjuxzSW1gc5ZqonYx/UbIoPgN67GKf/+Nmwkd0mbgNqFnVWnH8+MtsC1GbqrbX+RTkxAvuoyvxcBV6ck9eo2qmTh7btPByiP2bJr0N+IV0CVkdWFPPQUAW/d08ZlsDGWPXg/gZlXn4HDilXP2+4RcSwqc9bzHH6DWGE4zZj9rvwZKraRLm3w3KRVoghKmCIHICrAjRiZLxevemd6pLhFMmp7RwFg+hjCh0CuZ9LXMjY7QaaNMwjFVjah55iqfCSh1MHUZFzcVKiCWxLblnwirn0/dbtmXPxZetoRaoW7iZAMH+xEYWxZpEBKveUAfeG5+HcUPUNKTI7rgRhL8HXV1Bibg1joez6WNdiXBiDDzK7g6ISh6F7eTLtj1EqbLRk7VBZ91xz4e9L+kirUjAXI2UwNin8B7ZeSE0qjxQCPU5wQxnHIjcap556vTN7Xdceqszt07hnQ0V8FIiNQg5EAK/BZFrnzZPWsU8gguga5/Afi76ZXj6Wg3be/Y9A9xFapTM9DL05XzKGn2OJNQcSkq7ToWixCYh6HEf4Gr8IjV6qzN/Ebvu9n5QIbLKD2tEazf/Cn5ekRa/wwVS4x76RRiMnmbFN9qXVwImLf/+QGUJ0zEWN01ae70RjHFNkFpEwbGdOtp+mWQrPvclYmndYV4gfM5f/D7J4GTO+rdHUt9GwA/l8WJhHNdoBcIVzRob8OfRrfpZOnkAn8yoJDpBk11l7A0NouO8qdfQijTdhjGRaEMsiic/d0jNZa2SnNUO8PeJs/3yWd0y5njkAukJ4OqOsfqwPrsN6TUx5qzu9cVsD3QQd4z3Dx8F7dM49hu1T+58h14ldg
 3AMbOs0u
 +P8jiS0CbFRCkWzTYIbsjSjy+O+dPMkw3OwZMoNQ1qCqtnmKtnQIQzzoXY+QyXrJ+SQSc/amhFfcCpcyw3ahUlqCjXA9Z0KRW4BLjuic6mfcKzmnW37ynVy5nWbagyvj/oGdaFdgin61HMsEVYcQ3nkU0nmWImB3T+F4wXoEURRUa9445oJf/a40mpDN2gUZTblbNGEuTuO61JcTmvYh5XRHzaMkNCjgnVDbwfKqsNasGJxNIHbdTj+1L/DjAkBMC/i3/Uo8mW3TLxW66OIu10pnQ3XExAEmIM3I4Dk006vGTovAD7WGk3npWng6LlXgDxayc1b7XM1NHZzdvgRo8sowHRyjdbAhN9sng9sgH3wS/GC/FEldt3nIH8HB/4VQYJHuwRbxi0ssQ6MVeQvSg/KdxR6DfEZd0I7RygA+HfAyAlDrjlq+SkdyR5ZzS+ktKbDzz6iQ+xyd0J6DYnMvukxHdokWBa0Ejrk9HHfJlzYXfWzlvrHhum0SA/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 03, 2026 at 01:05:32AM +0900, Sang-Heon Jeon wrote:
> Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
> vmf_insert_mixed_mkwrite() has no callers.
>
> So remove the function and its declaration.
>
> The comment above the function describes the -EBUSY handling in
> __vm_insert_mixed(). Move it above that check.
>
> No functional change.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/mm.h |  2 --
>  mm/memory.c        | 16 +++++-----------
>  2 files changed, 5 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c038d06825c3..2ac734efd4ec 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5008,8 +5008,6 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn, pgprot_t pgprot);
>  vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn);
> -vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long pfn);
>  int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
>
>  static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
> diff --git a/mm/memory.c b/mm/memory.c
> index 330cde31bf8b..4b2e4be28031 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3052,6 +3052,11 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
>
>  	if (err == -ENOMEM)
>  		return VM_FAULT_OOM;
> +	/*
> +	 *  If the insertion of PTE failed because someone else already added a
> +	 *  different entry in the mean time, we treat that as success as we assume
> +	 *  the same entry was actually inserted.
> +	 */
>  	if (err < 0 && err != -EBUSY)
>  		return VM_FAULT_SIGBUS;
>
> @@ -3085,17 +3090,6 @@ vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
>  }
>  EXPORT_SYMBOL(vmf_insert_mixed);
>
> -/*
> - *  If the insertion of PTE failed because someone else already added a
> - *  different entry in the mean time, we treat that as success as we assume
> - *  the same entry was actually inserted.
> - */
> -vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long pfn)
> -{
> -	return __vm_insert_mixed(vma, addr, pfn, true);
> -}
> -
>  /*
>   * maps a range of physical memory into the requested pages. the old
>   * mappings are removed. any references to nonexistent pages results
> --
> 2.43.0
>

--
Cheers, Lorenzo

