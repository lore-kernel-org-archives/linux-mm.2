Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63B04C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 261D56B0092; Tue, 11 Aug 2026 11:36:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB9D6B009B; Tue, 11 Aug 2026 11:36:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08E836B009E; Tue, 11 Aug 2026 11:36:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE8706B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:36:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 292D712052A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:36:44 +0000 (UTC)
X-FDA: 85089391128.07.B434A4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6D2A2A0013
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:36:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NsOLbXpL;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHMLR6xuxSPZ908fxtbe/tdVZZ/J4lEAh3gBorqvcfA=;
	b=T0oAextgSxxf6f3d4ORzLpwMvoB88j003f2dH4a1zs853fusnMXEtXADVOQNBPL8R61xq0
	SQ6pODqGdGmemhANdd8F7W/YnG5EHTONVtFB+R09B0Ux0Rp+GUvpcD6I2mSyzH1296aOYO
	SryGnKvL7NVbELpWU1IDYXe5Yw4VUkA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NsOLbXpL;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462602;
	b=Dk9gQZJlfb8VRyD1kJRKO/ilgEANdkBt3jQGNaPTWewHdPSmPpt+Kgy+ewQiMbcZ2+J/9C
	j78uYzeADF5tmYdsNKTgQn8haAAVO6ZaqHtffJMlGRTsS+A/9y3nfvNUTlJR6zwGwzn9OO
	23LDeYGHbLzNeKn+OQizRmTu67saIjA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA478600AD;
	Tue, 11 Aug 2026 15:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E974B1F000E9;
	Tue, 11 Aug 2026 15:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462601;
	bh=EHMLR6xuxSPZ908fxtbe/tdVZZ/J4lEAh3gBorqvcfA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NsOLbXpLfT/Ov/jvdhcuBXKyzAlb3AmcKFLCjPYeMH40+dTnE6yEA9uiXAbFaziI5
	 p37LVW+/BiNAPyg46izhkcwejENkde4JMXqPZX1cchtXkZskP+2GDzjRyayHnc+wgy
	 wJ3ByTaZeG0//7l05wstX2POaLuYyQ98/iAgrHHVPL+6cTU/VYy3lkb58iLxab7K4y
	 0Jt62Cf5PbnhdKx2ENtTSnnbsFzaBCxVb+my7rnZ/V7UaRsUAxUgOE+DK39dfDxpnu
	 QboxeUdIK3CfdTZvtKximJ6SIPoU5jM4Jgk0Iw4WkOkBYipCfEaPFf6khLjeiaX0tT
	 KRlQ7ARoRP9nw==
Message-ID: <da69545e-4b80-4cd0-8d70-a73023445e9f@kernel.org>
Date: Tue, 11 Aug 2026 17:36:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm, swap: distinguish a malformed swap entry from a
 dying device
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260810-swap-v1-0-375ef0767206@debian.org>
 <20260810-swap-v1-2-375ef0767206@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260810-swap-v1-2-375ef0767206@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6D2A2A0013
X-Stat-Signature: t4z488jyaorkkbeo8jf4isqxuozk53zf
X-HE-Tag: 1786462602-341087
X-HE-Meta: U2FsdGVkX19CU4/djEZpwNfp/9MDAm/A8iOp6LdRVFPqQoII5B8gr1sOr3Kx8DVHrM1UX5tEQOSn40sw4jD/gz/jJu+f98wzPxOnQyayQwpjQg/A0KkJbqnJDSsVLbq0ZLHK3v5KmLJC51g0avVJjjOBD4QJjpVYzctDfjAfHKzT+XQlyp78Vk4hNP6hbvbwSxu8eVgZG/LCt07ZeY7xhYfr9fTze6HJ6F3BLj/+JlaRR8lv/NKj1xA+lGY0aEa/Z44R3Z9a9Vb4kBp5i4DbGOHlPwcDNUtZ+J5x0ynclPJVblX9jULcS3/oDr0iMXy5MS7ZydGlAXJ1Lt0/wSiLwKlPY9caRLfAQ3iIvjHt8yqJdFrou6kgfFeTDLjlyi8CYAjORRK/pg8HM0D48vctSGC7bggtAUhUY/X4c/ZP+8/mTasGVJpCXfLHa8Xe8gajoO/wDkl3uZHd8MsxvYxzVNXChm1FqXg+1zYe3kaOKZ+8Ton+qBNmK8Ds0tpUNAe/aQgty7BMyug6Mql8ZMQqr1uxvIPwGOqsHyFgGfKWKCIt8Stb5f++YyJYFyM9lb9dEU/wDubEsDkpiRhDzwvp++/61KxgmNuqt7Ni6FP/MCAgj/FX0cKMxCH6o8MRYLAuPQ2Hnwnf40myFTNvpskJs3ckjJmuzmAFPK6c5qRmoNI3P/BK2pewaemVTNjnWhfwaeMzs8EWeFf0ov/KihsPnqBcuOdAZVSHzl9Lg0oM2xzOhLzzyqlDtGy6Vndt3iPUT2S1wrpnrt8BJxQxDiYCpzUdevtoDYw+ArHvZxptXHyLeVFilWVp/5qduafgr1ZBXKqXK0ICAs8dvXV7ktEWXS4KQUTmVA8tX9D4SBWvoxJK41P8OhNEQBWVgJoIz+HI+XMT8DjpIiR0nlVbycSW3dDewOtZ5SdZdc0j/jEeC6mEnWNJqm1rdvFHmRmDip5iN8vFfU8eW6l+X40iqfc
 /XHk7BLB
 4RW+YTRy0DF0yaCO91ZFigYF8jLguXxbFb2mKdnbJ05Qscp3X3lXKt1x1airVXcLxLBJsCWnOC2vla/uEF+I8pWJHNM/pKvU8JDezsN98aaGSuTBwtPKZNjjBalcQheTSCYrXddAjq+/cvphNfyBrEQSaXwMhKhW17R2GIxQtssdR4EJ5XkxvKLJrwh14yRTs3c8zTDGvhV3fFziEBH7+jaXAB1mi0jzkkta70zqeHGC0r0fymTaze5Hfnpf4YqoF5Ias
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 18:26, Breno Leitao wrote:
> get_swap_device() returns NULL both for an entry that can never name a

"an entry that can never name a slot on any device" is confusing. Can you elaborate?

> slot on any device and for a device that swapoff is taking away. The
> first never becomes valid, the second does, and callers cannot tell
> them apart.
> 
> Return ERR_PTR(-EINVAL) for the two malformed cases and keep NULL for
> swapoff. Callers bail out on failure either way, so switch them to
> IS_ERR_OR_NULL() and clear si where the cleanup path would otherwise
> put an ERR_PTR. No functional change.
> 

[...]

>  	ci = __swap_offset_to_cluster(si, offset);
> @@ -1859,7 +1859,9 @@ void folio_put_swap(struct folio *folio, struct page *page)
>   * Check whether swap entry is valid in the swap device.  If so,
>   * return pointer to swap_info_struct, and keep the swap entry valid
>   * via preventing the swap device from being swapoff, until
> - * put_swap_device() is called.  Otherwise return NULL.
> + * put_swap_device() is called.  Return NULL for an empty entry or a
> + * device that is going away, and ERR_PTR(-EINVAL) if the entry itself
> + * is malformed and can never name a slot on any device.
>   *
>   * Notice that swapoff or swapoff+swapon can still happen before the
>   * percpu_ref_tryget_live() in get_swap_device() or after the
> @@ -1900,12 +1902,13 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
>  	return si;
>  bad_nofile:
>  	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
> +	return ERR_PTR(-EINVAL);
>  out:
>  	return NULL;
>  put_out:
>  	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
>  	percpu_ref_put(&si->users);
> -	return NULL;
> +	return ERR_PTR(-EINVAL);
>  }
Is -EINVAL really the logical right return value? Running into bad swap entries
sounds more serious to me than "-EINVAL" :)

-- 
Cheers,

David

