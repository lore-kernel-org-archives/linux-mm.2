Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88506606A33D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qx3j5nyu
Received: by kanga.kvack.org (Postfix)
	id 7DE586B05BA; Fri, 13 Nov 2026 17:23:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B68D6B05BB; Fri, 13 Nov 2026 17:23:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CCE26B05BC; Fri, 13 Nov 2026 17:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35B4A6B05BA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:23:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A460A80113
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:23:12 +0000 (UTC)
X-FDA: 85431522624.19.24FD83C
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id C9FD91C0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:23:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qx3j5nyu;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794608590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lt2oCclDDD+rP94lJg6vk9k+uikGlXnAQ4GsrH0NNrs=;
	b=l3yI0HIur6WveFwiMVUWvvdtPlAnRX5AtiN69z0m9Z40m7VoBhSEerFrNWuz1W7/A6HUcu
	rm25WIL6BCxG12el6EnllvZoSrfXSqciNge6Q9gcICEhoKy8kmPxEKG+GnnwSNnBpRPgrl
	01vTA0GW0djh1TXX+X2GETB0VGK8ZKA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qx3j5nyu;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794608590;
	b=Fp2PzW6/SFAgCGaVbgPNJdc0fY/LFLJwEtIrOiQXma1OjoYPUOFuiRug+C+ZpG5JtIqP/X
	dcnoRRIbQ2XYXggaiYPFFxJYsYBTj7uNGRu9sZW1FcOOHeOy+S2fOEolty9MCwouuJyAw0
	YcripInrDlLw5LL/q1yPBe9weiT9d0Q=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b4b9ba815bso3868057b3.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794608590; x=1795213390; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lt2oCclDDD+rP94lJg6vk9k+uikGlXnAQ4GsrH0NNrs=;
        b=qx3j5nyuds5zrHHtCnE5h57lmS4VicQLU/83RHd4/x00uLz83qpBx5H3JwuPtL6np+
         8HGivcLgxG+kWZmK6CVzqXqw00y5D/I+ihIppDP9tkPSxVCDAg1mQaYrDgBNu3GMbhPA
         Jlyk4gchJ7aGFs4rcMRB2+xHMuGen77P5tlcS5aOlu/m3u3Strj93C8Aga0UZ/fVjEU5
         ef3wfK3e2NvEkxn1JkO/YpWK2+RBeYtPsBus/CAd0QFebk6JRVFFJ4reVJHDtz94GUFy
         /35AP9xtAv222MvN7AmYiYN2VmYoX4PNEis/QE9XewXWsKKX0FN2QjHZusiV4Xe2dNYL
         GsXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794608590; x=1795213390;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lt2oCclDDD+rP94lJg6vk9k+uikGlXnAQ4GsrH0NNrs=;
        b=iQXFy7vrwMPThVI1SOrDvSKiOsQxvvdKvylMlKX+B501GQN8OBJo9tX/M9/+6ZhZ3G
         h+Zsb66aPf7R36qTZEfAB0n7jMAggpeZi5TFIHOx9vmycNNTJdeLHsHxJtugF2ZUpenT
         Z/yYtO84HhVgNBUlKLo692jxzfHF6UQNsP0dvH39WF4BlZqAAQekdiXN/4h5gPHVa8OY
         wUY5GyeALrp9+drhwlq5bTioObbEe0EBmyT7aKCTXxMN0yGubBmK14ntuMzIIpols1E2
         sqSGMccs5JOil8W2+1lbeGvNKiDdAEs7usyn9wcjAgjzot2wsM8jiSO5Qc2MQP6EK4ng
         4QaQ==
X-Forwarded-Encrypted: i=1; AL+hErEIoRWY4Sx3CsA4VMG9BUufJ9qeMrhPo8lUPYjr1g5hyrjScPI8l4WGrRAmh20NzLwmwjqJlnt1UA==@kvack.org
X-Gm-Message-State: APuU4Z+T3yuzbtQPLfo2IghCaNRX+w3kq03tSyotdxUC6Tv/BI0Mntro
	eJ5L87fFKEdgGOr867kKdsK97JVdqK35sxqcCbLjuPjaC3OYoWXJyh9D
X-Gm-Gg: AYBFou3GV38zjVHn0ikqHbvkf/v7NOeYYIhORI7KYZM/q5yi/vUkR7p1gU21VIXgyPQ
	v+FLWQ9r2i9GpEH+i0/nzElS9X3dMBijDQrACdlAUEIthpSRh6Yp13jLxfDm+WCjMDIjGx3CsT1
	LsCBztL6fOYLALmH1qZpnWIYv6u+bCv4EdKiVde1/1TbaIahlgEsAbnco351XWGIMhWM3jtHGwf
	MfLLw6TnGT29J8wWCzHaEPdaYPauv+OQ7voF/48T+6woUZVwsfKRoFAB6eX4Li+QhtrE7Prq9Hr
	ES9WW+/SgCQNvJeas4OQxLH7Y6bkvapWfEA/dITgR0tZbHIoZv0tC1Q0W/O0a7v5bEaSIFHeP4C
	Jru620LguyMPR/iRTQpoe7BpnbjrwniGC0GgijKUvL2pmB0AZVwNK++NTz8w0/jS0osT/1lkbaD
	3l9YX7XRrjecQ49YQyTPYhip84/p9PvMQXf0YCOdoTibnChz3Si5I3+IK/EArCORRtWQNq7N/Sl
	2n+NM+KL6c9lURJrVKss6TiRPHf6wZqtr/5mlR44iN+sN0uDWgxY+u13gJpD2CsGo4klz933fHJ
	DTGRjuy0RO2chlPpEOWEshNt/VIe2ZYNg+J4a3nk7OfuA7mSoIy7T9e+7QWojjjy2ro/LUe2Cg9
	qyKpx7Jw=
X-Received: by 2002:a05:690c:89:b0:8b1:233d:7054 with SMTP id 00721157ae682-8b4aa2f48ffmr31548167b3.32.1794608589587;
        Fri, 13 Nov 2026 14:23:09 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa7eeaf9sm31201657b3.4.2026.11.13.14.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 14:23:09 -0800 (PST)
Date: Fri, 13 Nov 2026 14:23:08 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/mempolicy: merge adjacent shared policy ranges
Message-ID: <aveNgfkmfZ2SMWK8@devbig011.atn3.facebook.com>
Mail-Followup-To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
 <20261113-mempolicy_limit-v1-1-16688b2644dc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113-mempolicy_limit-v1-1-16688b2644dc@kernel.org>
X-Stat-Signature: 5hdyy1p6yhup3p7yotpgkc5q4htomnum
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C9FD91C0006
X-HE-Tag: 1794608590-798786
X-HE-Meta: U2FsdGVkX18NAoSiSGBzDMp7S9n8bll1A1Ica7/gEUBjX8o72dc2NL9WkmFFSQQ3QRaH7ERMgbDhBUdUpvMOHvQJhdtQaLmFEvNzzez0Eczoa83eBA2865BhlnpXDAN2P77t60qCpfdJ2A5R5J9EB/gKvbFoIs86/Cc84A/iRvWN9XTDBYTj+Uh+RIcoGfHo2ws8MPDXzdeJTUu3XWzTBeSyBnAtE/ITAsG/yDbJ/nBk4Lq3btIYbomsnM6H7KRWxXyIJRmKridxcxosS1g15EX9qrJSmLj6pK1OlBK42g3D1S/8LjGeLYR0UEHuLkOIkGBIMvHK+ReKdLpSHUgpQM9Ep5TXTcIhXNMKi+U7+vQY8mFusKYVJYFL3uyLBK2viB5/buAxjhOXBQelk/s5H6vtycvIYxxCvu3iFQ8YSbcBBZoFCv179srSrVchYY3siuXUu/W8GPP0Em4MEFUFLAaFK9KzCBuYzQ08klJgygkrqDM4rMrHsa70vwPM4O7yflDC/nnaGZon2abmjZG5Vua1of3QlL/JQKCTyCx0cQZQdeFJvHStZ2KLnJH0Bjjf8DJ/zY/l9PFRUeNKZL7+Z8jtP9Lqj4QkjqoOHWbgcV919/QJPGwSvv4FFHUuzQRb86411EJuH+QBGT5rNXFZkKha6gH2uukyWf8YQT1nBi5TstfZJwp9jF7Ld3nMun+ioPyEHYdFS57vlms43fNv418xjqZtL3LMDD7nDBqHTdXEz3Vk7jTIdmqcJvL6Pe+wNdRfTYxpOlje1yEHsx+y/+/JXKW5+wcaEt9i4VpYPQ8JIUajAX/QpZGx4zBa4Csy9m+ax2nPjZuW6lX5Hc10CmBmeqhmHZ0iugpQAS7gu0C7+EUscmSMRAQK9IqA2h4VYuwrRrSBtoD0xwKSxOeBkMMrpV27ZeZmOr9dyJKdtT63KyGFff4A4Cqe5lm7HSYyDrZXhQiwJFE1I/8NPbs
 apnqTp2l
 z5+bzy55hN8YzePVaxe+G2744YzAAwvOYkRhBa1dU0qBG02nik+3r9uecXrx8IRf37S7KluH/CPN8Dy38/KV3oRML4aeG3MUoOWdQAyEDDBPMqhxc1V5L4e06psTimpZzQ3QRwitaq+IcYA65hVIGoHAxY4cq1w1FR4iep4b9+9kuhzlNKRjFCpZ8452kUVtN6AUTeg2jgPrLhUqOfTSEoJ1bAgEHg6gm1Y5yM3ep6eksoT0C4QxLuSKuXywAD2+6NQpNaT5zS0MPrzFxlY3nUdUbIrypFVyQZspbdOtY1o1nBEtzcpLS5ionlmhH+pEg1McARitPaAUIVIdWm/eACJGJOEHDvvmGcJTqe8NrCi2AOyHB/9O/Qx6h7Yu5bSM7X6DyYNS7KZAKSLO+jIroehL1FmsVXTENSPWa1qzeZuky/KFLUk+mOyu0vDQvQPXRkPk7YJQhoUHfLeG0Dr3FRj1+YQtZoV23gkiChFVM7+/zCsakuqZUlGJ34xA7uuwjj3xJJwYfQoJnz43n3rQNJJTR1rKsn2mEZCpJ0Nr8BRUpMQX+cVEQ/F45RZtpqUjQGtHy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 10:36:12PM +0100, David Hildenbrand (Arm) wrote:
> Shared policies can retain separate tree nodes for adjacent ranges with
> identical policies. This can create unnecessary policy ranges especially
> when individual VMAs cover individual file ranges, and user space sets
> the policy on these VMAs independently.
> 
> Extend the existing replacement handling to merge ranges with equal policy
> at either boundary. The existing replacement loop will then remove the old
> nodes and installs a single node for the combined range. This also avoids
> splitting an existing node when setting the same policy on a subrange.
> 
> Extending either boundary rules out splitting an existing node, so the
> allocation retry can only occur with the originally requested range.

Hi David,

Independent of 2/2 I think this is a really great change. Thank you!
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> This change will make it easier to cap the number of shared policy
> ranges per inode.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/mempolicy.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 06b90903e8794..183bc3bd077cd 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -3208,6 +3208,23 @@ static int shared_policy_replace(struct shared_policy *sp, pgoff_t start,
>  
>  restart:
>  	write_lock(&sp->lock);
> +	if (new) {
> +		/* Try to merge ranges with same policies. */
> +		if (start) {
> +			n = sp_lookup(sp, start - 1, start);
> +			if (n && mpol_equal(n->policy, new->policy)) {
> +				new->start = n->start;
> +				start = new->start;
> +			}
> +		}
> +		if (end != ULONG_MAX) {
> +			n = sp_lookup(sp, end, end + 1);
> +			if (n && mpol_equal(n->policy, new->policy)) {
> +				new->end = n->end;
> +				end = new->end;
> +			}
> +		}
> +	}
>  	n = sp_lookup(sp, start, end);
>  	/* Take care of old policies in the same range. */
>  	while (n && n->start < end) {
> 
> -- 
> 2.43.0
> 

