Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DBDDC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0124D6B007B; Tue, 11 Aug 2026 11:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2BFF6B008A; Tue, 11 Aug 2026 11:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41F06B00B8; Tue, 11 Aug 2026 11:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C09AF6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:34:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 458FB140499
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:34:06 +0000 (UTC)
X-FDA: 85089384492.23.074C29E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 78FB2C000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:34:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qssw8dT0;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9zx9F86ODxMocgs3Cx9yqxuZHC9DLV8IMGjCFwby75Q=;
	b=1i8xU4iRELq6Sx6T03GIoeHrrf2DtDx3jfD0wm5Go6e0+lBe2ce+53byK+mu1Ke2YjrlEH
	4Wqn+3Gw2bX5rvCJpKIeltX1tCh5UuibTg7nbfSXy+VBKv0FyzAzHLItxHTOedEzoa9MXq
	PTJVnqZHEJg4w2gqJ2afrmTaU6M1vdc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462444;
	b=f6/zUBHLn48ADH4nK03ccj9KQyjTGbNgE6ILMzafC2+aImrLOtL8YoBtUAGEaiWGZ7itMq
	jQDuJkKY/e3F/d4i66YBeO8+xp7KXGEtMu+0BMNuUeSXzKmQ0QmpMA9vfElnCGF3OQvokr
	xK7ikCat2RVpCTJzLjUAbM6nxD/pfnM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qssw8dT0;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95EB5419A4;
	Tue, 11 Aug 2026 15:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4581F000E9;
	Tue, 11 Aug 2026 15:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462443;
	bh=9zx9F86ODxMocgs3Cx9yqxuZHC9DLV8IMGjCFwby75Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qssw8dT0WkKvvpdTggpRb7eUdAovp1pB0nM6MlMgnuiyWrVPO4Q4/y2KU0ZRS/7hf
	 5NkPvR77+Lq0gvrTKypc8M46P4jXyhRWWd18IVl3T/OMH5Xdhs1wmmSXqhd5Q2lK+X
	 WJYcnob3dActNYR03X5xEbChQfNV0WYKuU3YUoKlQVPCWFTJDaxiUL9IHnE3AA1dS6
	 2hmdB2NWyLjb69tWpSTyNeWfipViZPBpUyEW9DkwdlkWHebq0X8fSIzq9wA8lBLajq
	 rzpvwAvpKqL/VwVCwLn12ZUsXdt32JnvTZywJkpUKlAfywMCQbKMFoj4utyUsl9/6X
	 Yo7vuGmbv3pEw==
Message-ID: <a2e220de-19d4-4177-9703-0e8e5c57f269@kernel.org>
Date: Tue, 11 Aug 2026 17:33:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm, swap: ratelimit bad swap entry reports in
 get_swap_device()
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
 <20260810-swap-v1-1-375ef0767206@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260810-swap-v1-1-375ef0767206@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 78FB2C000D
X-Stat-Signature: ouw7hrc5ekpzgrpsz11fzbunaratkbij
X-HE-Tag: 1786462444-610936
X-HE-Meta: U2FsdGVkX19tTpFvpqgnZhXowAoGjegfL/UyRIuI6OaIKRIK85Sp0zBgS980ttuuBPr7G42QeMCc21Fc27NqmfD8MxeU9n6ODS52iEYbEhRs/iyYMsjmij4RiKacHGExzu6ZDpgQFO93LmFyf6x5x/JS36aFiKYo0EolcobsyoM/BZFsk9jH6W/qVWb6bQau59/aq6Aum7VLckCKFsgqdvCsvBAeg4SfW4LzeqMhofFJD3rWdl80wwvM0dBgkNkDxpXDSKMGMYWjLHnjUm/Jw0DPLCD5kcwgms58i4qBx8pPgQ+V5FFda1SLPD2BeDIQezUopanK2goq0dwohBxdwdH5BqwMEYIVWIuKoDcicBAaVnxhZgmpnxv0v5YXf2V0ukD3MFJUbVKdYUB5yEabqmMhF7Gm3JRvbaj+874DyP1FNot+fYdZwZVFYBtfR8VJ1mKG8CDOI/kmpwaX6MCONBGKvctqDP1tZg4zLShpKC/fZwM0W+4DxEa+A4K/QedC+IuiOD+MAy6VsCTGTS/LVfnOAqb2W50rtzJlljmzGNplrgfRv0Jxtr69BG4O9Pt+w3Phmscz2vWkrjG4w8XDkDPIS5SfAJMytKUiW5zud+QzX0wM9dz/spaywq+WB1znMZpDFIS4oau56Wp+ITN9JeAATsFLZ2g85a8oqeT4B0o4plghCAzyRFT7jxPfw69siTgtsXMxOfM4GMl8t7y71kPyCWHdJhTcIZ3suWV2wEcjP7/utXRW1QJCoCMjkB7SJ5k+K8RmH0X+fXzF/sv+6Z2IRxNkjsYOTCsjyIFo93t1YIUPRlFIEGCAxp35LQjWCB8n7xO2G9X3E8K+zAjzgEGF6HQpv8yaMn4fp4gmm8O3OFDoOx2X34ULd5CwTbIA0tmbJz5tGmxrvWHHnrrkokxBQXFtKKcJ/mMwCN1iVDZd4E9Qm5nWzDXqg2Es9vomImyfclOIVXRmCXlPo9T
 lzVgJgIG
 heeq7xhhU5Q0fvG++Is42erg9v0mNJKee5qBYMONK/oq4mMc2aLajiDpyr2fmvZ9HPkQBKlSFY2OBnuNopJLMKGxTojeFL7915NO4+IE+8/iN1NMjQWnZU0q8gUElGN9jlyL4V9shIh/p2Lo4iv77nFhzIK2BJBm3KhOMhgxqY/0KAGASCgMyTriGeoKqjy9QPu6g1qRt6uHEnkFUniwxr2EX03fqUcAck9ecvvPYSB77Fb8NR8eKGwq+2q/zfW4wtIntU7EwX1DI3FFC/F2RSSJ4744ligmU/EV4MBjXgJlzIEO4JbYPW7Iswzus7z8hOl5tF+uY5i98CHVhxptb77DlYsayI3bVOi5D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 18:26, Breno Leitao wrote:
> A corrupt page table hands the same bogus entry to get_swap_device() on
> every access to the mapping, and every rejection is logged. One machine
> logged 6185620 copies of the same line in a few hours.
> 
> Rate limit both prints.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/swapfile.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4d4e3e3059f6b..9ab11dc24e4f1 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1899,11 +1899,11 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
>  
>  	return si;
>  bad_nofile:
> -	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
> +	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
>  out:
>  	return NULL;
>  put_out:
> -	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
> +	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
>  	percpu_ref_put(&si->users);
>  	return NULL;
>  }
> 

In print_bad_page_map() we use something more advanced
(is_bad_page_map_ratelimited): essentially a burst of 60 followed by 1minute of
silence.

Couldn't some of the stuff you drop here (different entries) be similarly valuable?

-- 
Cheers,

David

