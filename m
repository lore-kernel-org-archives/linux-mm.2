Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE38606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lQ1rvgSs
Received: by kanga.kvack.org (Postfix)
	id 6230D6B05B3; Thu, 12 Nov 2026 11:18:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D4BE6B05B4; Thu, 12 Nov 2026 11:18:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C2846B05B8; Thu, 12 Nov 2026 11:18:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 312CB6B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:18:13 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7E561605E0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:18:12 +0000 (UTC)
X-FDA: 85426974024.06.1AA9FFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0CA722000E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:18:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lQ1rvgSs;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794500291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QQjy1ZXjch2DnnWTSXJwdzrveMs5n9IlfNyELVADAE=;
	b=lxVCLC71z0lOaxyrXWiQBD2vP3Va9szxqZOGFIPQGeE8GIGl0Kvsq+sgL8K6S+qUxWuVmm
	e/HhFOiD+ABBVvdtO0u0A4F12UGz+8tI6m+Fd/5nwGAetKewDFvXeVgSbAKGOOb5TWQPpu
	YclnZaxzjbJi8tT9JJU3GUAYi+fJSS8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794500291;
	b=Oi7dHm3J/TskzgP7hkLP/feNJexbxyO8vlSqu8xcJPPC5L9Lx+pxDx3yAyw6nHmCqVTKz1
	/x2+CUJHg7tZ69BQeprir9n9e7EVrMLZC9bEhfgeud/brdN+Lv8jbVzWx0Ncm6ij+TCo+2
	zGZvnsoD6Sq9gwF6Bcj7g+4q9RIVidk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lQ1rvgSs;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17D3560054;
	Thu, 12 Nov 2026 16:18:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABD21F000CB;
	Thu, 12 Nov 2026 16:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794500289;
	bh=4QQjy1ZXjch2DnnWTSXJwdzrveMs5n9IlfNyELVADAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lQ1rvgSsjdrcD1FLJt500urNClVMB19cJcS7tLNzy0snxZyoEuk5T7o9pEf86u8Ei
	 Z9Biccqvq54D0KIDA4yqbYS6VMo8cZF25pHSjrc4D2EvEa2gliVn+UkL5WqsirTJ+3
	 wtISq1nC+3juOU4Kg0f97dniVWypyNdqD06WOUuOrONrvDPuJdHyfNX/laVtprUNfm
	 xleL3VofUjD4HNfnQbnu82VXkcbPeaSmdDQxVbKd28AH+d5AgtvUV0Sw6aXroKanUz
	 zlPymZF1jj2/d53Wnm2+0ePBjSW2helQCaB87t7KaUHuyFzbmKre2uaEubgFTbxJKj
	 vkMUyRkUMYM6w==
Date: Thu, 12 Nov 2026 18:18:00 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] mm/mm_init: verify zones for template-initialized
 pages
Message-ID: <avXmuFQgroxxOfSF@kernel.org>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
 <20261109095807.41547-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109095807.41547-2-songmuchun@bytedance.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0CA722000E
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 78mbmyam7j38ujgza46uzjfbpb9bkztd
X-Rspam-User: 
X-HE-Tag: 1794500290-939705
X-HE-Meta: U2FsdGVkX1/Vug/P+luyRHG0dVazUg24TSz3hpdD0qnLbmsTAbF6OjeDkBqhB29sjo3PKjprKvrqgppUsd7HfZyX4mZ/CuYdPRIsNfkj12bRs3N1twzArSMG/EdOdJExjoETj/fUJfp5WfZpK9FCr5KeGy7rya0c5ierRAcVVEysMrQJ2EAXD5YP/Q8ft0LQPFC0axZUrEhcbnq0EQmhq30vB3B2g4JGyKulT6foOfVWFbtgGZxCQiFmBb0UCS7CAoNsAjRcSAfPJBTb0ib54wvPavgNOjPGymi0NdMSq/n2a4RddjmFiZDJdU886AYPS6zLQ2FPHKrk1/I1HR6KrTaIEUUhN3Shzo6bUB1782D0Vw7T7oTezla7pgwLVsQ0EAUXCsx8L574almAilLcnBviX15jghjhTaWriOylf5Eqd9EmTWS7zmX+xnlPYxWsm23mSZtbkY0mgJj7F3VHmz9d2PLA5y0FMA6LI+6D5nWvJPb9utOx4taflA4Vj5fqZAUMcyO+x7z37zKj8wMLBb+pOErvhjIpR9qGcN2WSUGmJFoCOMRBh6i9uZA1+2c1416QLMP1jqybQ4igOeGGwkcar2rrTZhdl8yYlq9mbes1OmGhZDvWvd8JpEdECuhMdTu3a1FrgqHvfHqO8FqGYChA0T/nShlCk4QFQWFUxULjpllogEv3acvt8bBqLAgzmQp6/xJ+sT9tOIhO1lApN6zgGxRxA2yCHr0J+33UsptJz1jnKCY23Ew3A4pTWzn31BofDjNVQMWmmqTEog13+bYLW6Tf3tky2S7KRRuXAjgxoljIkYkvwhRo1Qwriaw6z73bb/QnG8f5n06U8t17RZXFhgmLAKMQTrYnMeQgeCk5xU7mBdGD12+HVE+d+Q8xxJzuga6jQq4s51FpJr1SufZB9r3bj82KlbiwHAYPZvE9YO2c9O8HNw4EywmnY0/gr+pTrv6fy+cBk4YKd0V
 X9YGPql9
 d9TzdZoKZ4yui2kdOx5trAe8lySdHr96pVh/HwnhX2Y68JPuCO94ce272FPQjJDefwNHoWpHf8w+1jNPZWlLuFXPULD3LLzZNC/4+h24tKdowzT8awHff5RGXG+nGmoX4XS5kwx79EvrAtrr9upO6b5D3F6mMwUOh/Ycj5cJ6QKkIgpMotCKK/g/2Wda4KmsRqpOy5UHdqNjwAD9bB09OYQ0nwlRjpfOZsc7Syu2M9MO0msk3j4R+3S0BVet2o8/9zTzuAz0oGQr1+vU0I8eA9H/2X2dne55OZ4lqgzJlXZs03eQOLmbYpdNPMJqXevwQesvRJl+80/ZQjmC+y4NogyA4h64znRmbsniL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Mon, Nov 09, 2026 at 05:57:56PM +0800, Muchun Song wrote:
> Template-based ZONE_DEVICE initialization bypasses
> __init_single_page(), which means copied struct pages do not run the
> vmemmap zone consistency check.
> 
> Verify each destination after copying the template so the fast path gets
> the same validation as regular page initialization.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I'll wait for the next version before reviewing the rest.

> ---
>  mm/mm_init.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index a9d848c92678..0129152b74d8 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1082,6 +1082,7 @@ static void zone_device_page_init_from_template(struct page *page,
>  		set_page_address(template, __va(pfn << PAGE_SHIFT));
>  #endif
>  	memcpy_nontemporal(page, template, sizeof(*page));
> +	vmemmap_optimization_verify_zone(page);
>  }
>  
>  /*
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

