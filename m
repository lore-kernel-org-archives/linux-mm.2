Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B07CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 09:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6633B6B0088; Thu,  1 Oct 2026 05:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613AC6B008C; Thu,  1 Oct 2026 05:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DB436B0092; Thu,  1 Oct 2026 05:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 278286B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 05:52:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9419F1A0339
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:52:43 +0000 (UTC)
X-FDA: 85273593006.26.0E89458
Received: from mail-oo2-f43.google.com (mail-oo2-f43.google.com [74.125.231.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id CF05420008
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:52:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UNqxWk4R;
	spf=pass (imf31.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790848361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1xY9QxUKpHNhbTr+dumQ0I1KTTJGdnP4miBBZLDZIWI=;
	b=C4zEGEsL4zj1lEJbUY3DhMBYwQWI/ZeoUYpt4LDi1xK3lUucNmUxM1zpU70hRnuxroE0GQ
	RnP7MzloqU64webIAAaqhn82OCi+6ZRDzO0ZdVL+JIDcoJMP6mKu1pkeH2uebg9J6aTt8m
	y/ToZ59VK3R3JZ+nR3RwGVXYp3JV8w4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790848361;
	b=EY30lBS0MqZRa5CQRsgVub4g/ETKey2AW5zzIHi+FyFsKqe2r09e7lytY6+pE9w6nipJWj
	qJvWKA/BMcLN5lLYUBvo7PDjJ7oAiQZrJXLMF2uSrMde5/6HW2nJjFy91mWYJbluvpbLqp
	lNYKw2hJjO5FXCzDv8EtwYuG+cynN9c=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UNqxWk4R;
	spf=pass (imf31.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo2-f43.google.com with SMTP id 46e09a7af769-81b02c279beso224940a34.2
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 02:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790848361; x=1791453161; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1xY9QxUKpHNhbTr+dumQ0I1KTTJGdnP4miBBZLDZIWI=;
        b=UNqxWk4ROUuJ76tixCW2/0dGigz8KjcxzEEDgjDj4QUfgkHmW+Tc3QAP74iBbL6Pgh
         xiSXGrpXATgVS85s/tPwpQJ+5EViX8T0RV5E/7UZ4WFF3rBoQ9C3EWvDejBXx8prqlDK
         nh5vLnDNYiZQw58nlsvhXyyzqQ27v/rD1Dmem41BUQgJNmxFGMNmzvM+B1CxsObfh0F1
         zKw8/3xcqQEWmucGbsAX+ffiIe9sg0d0IMD7pvuoW+jWLjBq7nyIN4gq2gwkKIc0RDLH
         3F/3gueS+G9z5NgQHvcgOQh/ghELVF/wZYi05AnKo7xPTtowtyajZdNE108VIjS9i/MV
         m8mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790848361; x=1791453161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1xY9QxUKpHNhbTr+dumQ0I1KTTJGdnP4miBBZLDZIWI=;
        b=MKq+HKP+86bxXDbN8qwm0kW1XBlfzF3XWhRZuwC8sizWtdcMEPw6TBzVg9DBTya3VC
         1KIcR2Ah09GRct5Apij/50Qzzf1UdlNTipD378X9WKWOZ5IbBA/Y34rTe2SQe3yra+G6
         X5bFfjhuj1Sxn3OrCIWPnq9GVjGjjsuR0ox60//Yi+UePSTHNlnKAaznQdCtuC3dnU3+
         LEFSAESNznYTuaSfjeyompuP6WbMayPefPTXqrEz2nJv/0ee5halQAmXFIFNy8/HFCwi
         Xsz8RY4oGpLSVa0oanMBk2JKqZ8MkQtOP3X5v3WSHuw1uPAZN8Wo1l8pQdsfBCloJg9X
         sByA==
X-Forwarded-Encrypted: i=1; AKwUvBzvDPNkrZgohxW3iP3DweFCuLLY5fg3HVK9tUqPpInmYcRdenPmk8FQj8wbTTRvhhkvLWw0xQ1Pzw==@kvack.org
X-Gm-Message-State: AFuF++kiVBT3Q+7tCPCKOZxul5cu31CNkP4K8qO/yJ7C1n4sJCvG30pe
	V4BViw1Bw4rYlTFrsAjA2HgOtbay9UHlW5AY1vX9lphd/GF7uLQN6wXj
X-Gm-Gg: AYBFou0su/qZISdRB+lOvN94tHEo9yrvzzR6TLveIdZqvV0yGMdU8ATef1tBDDRgeOn
	DML2sXHyHnKnC6BJK01t6xcC51fBiEH8Gy+qUUJIb4qxtLJDxpTiH+GxlVWFlA7npbO8xRU0qZh
	TP9OIiMTEiTrlVbmFOSdG1fuzlVFneQgy8YbCRB3uO0RINp3JOmvxmicuj3NOFBJkdSFu66TyrC
	yVGN4LU06CYqXz817a5u1nYfeAXogf5sWrDlruhOHmx7/g6EE6cKWMfiQ6wtzJqJZLtjZOCC2k2
	6uPrXl0RqQITWm9/zYTn+5w2vGMP8mycNpLnG2qAbiEVtwdH6RCy4nfZtqY1E6HkTKiRs0klEDo
	LvriBqLK4MsTQ9Kk3t8urO6JP68vBINxOzr2QkvgU+c9bz0/0DDgOF7B9DWAcOANtdXrkFMurEu
	B9lbMiR+mA58kJklORsIND0gXFJR7j8SNu1GydctcpCWCA/mSPJasw7UIUvbnukwQqmZZ049UEw
	cJXEk6HSY9AIPAtwi6E7cFqKeGy6Q==
X-Received: by 2002:a05:6820:4b0f:b0:6d9:979e:22ad with SMTP id 006d021491bc7-6dcf6122b49mr4129246eaf.54.1790848360630;
        Thu, 01 Oct 2026 02:52:40 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:59::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6dd988cf6cbsm2306361eaf.13.2026.10.01.02.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 02:52:40 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/swap: submit the last readahead batch before unplugging
Date: Thu,  1 Oct 2026 02:52:33 -0700
Message-ID: <20261001095238.2417205-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261001085730.2029773-1-alex@ghiti.fr>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: t6ht9j76ihsq77g3xogfimb7oupdu6e7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CF05420008
X-HE-Tag: 1790848361-832119
X-HE-Meta: U2FsdGVkX18Mc+ox+YrEO9U7SRGdqMb5CHn3bNn9dyILMcRfiPhAnOS+dmZ4SRLMeCMRrdh22YhpLVxyIhidBMwPFqFVa2YgOr2nzOO+G5SgjKS4GHRMpVTinOaPMshVnj5n4yjPZpe69JFp3ZqMr5rtH+I+w17dh+huKS4aXfZkqh9eNeYLmVd0kmb6wfAvi5WKSkm/QHNroH9hkVoNJl0M17ibExjyN+jZyWhd/5yUPuGKcqz7OsTuTGbhyE+SsQXHvMFJ1tNctcGvAt/VzvrZEAOHbfXGE/33mTcMPqBuBykZIx3+zoPEdvfRRqUcihn2kRu1V+smgSbh2HOvRUkD8g3UvSLrbdfPCM5WirftauQdo9rrZm5issc4x6SWcgOTZpXkXVk0nPdYECJnGhveroibq1y+P8ClG5qhg/k+H7lfx1Le/1J1BVcMLx6MwYfhmzSVTfOd0GC9cNr0Y1dwaZFlEKrfE0HW7hzxfg8kOJmmARFsopNvK0BePfs2toMpB/YbsKWg+J0pBZuFNmh+ZG3rZ3xk1J8GME80QXSKloP7iCCD+WOteKfURuU9PuTbTN201G+wcyi8a6XbEZejyvsj6rYTUb9Cxs/t9g70c8RnUOG/PIgaU95OzmC0Kqj7JXYhd9yO4Aw1jy+N12ruAK72vG4HGPLXR5BGmV2+2zCg2f24kiHh8wLksLhrGi42ZFL2brzzmKGXCbKku/Lx2JKMuJZQP7jY7r1/6MM2AJWrk/9jq3ICAkBAE/UsaPdB2bUcCfcubIrL9wtg59j6j941z92pm6bKNWis+9elHO0aZ6eKCGxfs6ymxAH5HvCBrzXNsoadWiRJ73psaPxqTyRmMKarjvqngPiaTQAa49g+aWqbZ3I60VIekiqlDJiwHu19yL6HD5HbwwyCQyUjJMQW3srpBg0vGx4banWHf1ePjtMZmzLSLbWRkUOE5NiGIQhlVjVHlBWFghc
 7swh/OfT
 fZzsL8cO9OZHkNnFeSV+AZY03SVUFGNnWHX/zwuK6qCDlYnNTKETDx1vt5SJ77yT0UEV0buGgFdNm1Zo2nUtLXWeMKVUwaeiISCL8czgTpMew5Y1+FqqN8ftRST9DeDouhFgTgs1ShzDD2rrdwN2lO2tsY8j+fu6+u3iGoMkxKE8qFaL9skp8FSsrYLrdSirka+7MxQoh2xLQG1lRAecEV+zT3r6kXnI32ay543zteZ4fbN4BVrTQZprQ0q6qCA1oO85soY8tbH+Deo9Www3ZuVrrUmyFz/mG6dYMQwbqGihc6vv1lrnyB4LGtujr7DRz3273ArnBp8YPGnQLie03/WL9RRSLysHviIIOesGreT3b1mtWMkdzr55Erf74u81+/gyuzSOr6GhZDkdsl/83/yXNDIukdxQ2YdaIELVlNl0BWuILUSe8czPqpDkcI9UrjmU8uvJaQrKZwzLXqMAJcav08i650lzujQXbDOCjXUQ4h1OXz3SIourN6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  1 Oct 2026 10:57:12 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:

> Since block swap I/O is batched in struct swap_iocb, swap_add_folio()
> only appends a folio to the pending batch when its slot directly follows
> the previous one, and submits the pending batch otherwise. Batches
> submitted inside the readahead loop go through the plug, where the block
> layer can still merge them, but the final batch is submitted after
> blk_finish_plug() and always becomes a separate request.
> 
> So submit the final batch before finishing the plug.

Hi Alex,

I read through the code and this looks very reasonable to me.

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")

My only question is whether we need the fixes tag, it seems like
dda8fb68b590 is still in mm-stable and not merged to linus yet.

Andrew, what do we usually do in these cases? I am wondering if it will
just become folded into the original commit or if this should still be
standalone.

Thank you both! Have a great day : -)
Joshua

> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/swap_state.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 2475ba29126d..ebef568cd62e 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -906,8 +906,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  			continue;
>  		folio_put(folio);
>  	}
> -	blk_finish_plug(&plug);
>  	swap_read_submit(&ctx);
> +	blk_finish_plug(&plug);
>  skip:
>  	return swap_cache_read_folio_sync(entry, gfp_mask, mpol, ilx);
>  }
> @@ -1019,8 +1019,8 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>  	}
>  	if (pte)
>  		pte_unmap(pte);
> -	blk_finish_plug(&plug);
>  	swap_read_submit(&ctx);
> +	blk_finish_plug(&plug);
>  skip:
>  	/* The folio was likely read above, so no need for plugging here */
>  	return swap_cache_read_folio_sync(targ_entry, gfp_mask, mpol, targ_ilx);
> -- 
> 2.53.0-Meta

