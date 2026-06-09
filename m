Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 642B9CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9496B0095; Tue,  9 Jun 2026 10:20:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA96A6B0096; Tue,  9 Jun 2026 10:20:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0FE6B0098; Tue,  9 Jun 2026 10:20:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC4026B0095
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:20:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B8838FD53
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:20:57 +0000 (UTC)
X-FDA: 84860585754.08.0BA586A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 61DAA20006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:20:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g3gv9Ex/";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781014855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXeHs0fX+QguaS/BbXywnYLEbCaziSGt3K3M6eh74os=;
	b=SYjkVYj4a3m/MA/RTUo8UZz2QPUrT4v5srJ1Yc7xhy2QzQfZN+fW6T+OGTmwVTzJooyPR1
	gTFf+Ljnz5M/XAH4+JfC0WM0lRIb5eIx5IPonPBnbuq+5vxKcGdnXsP1uDYfEK5+7AtC+k
	HhvecwKlKX64FB4W5rRCu5pvlgqhiEw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="g3gv9Ex/";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781014855;
	b=gt/FGxzCJohS5EchE+gmjuX4U5YTCo0g4d7kwD7cG7UGm2z6cXuYUFhQ4dJLaOfpLcx8XB
	WdPWWLDZg8YA1Q1aVfulGfMp3kGUuPnmRexogxMQcaZpz2DYKVNQnhZUmYBUTnya3pEgdf
	6mc6r1ZnPCBaV20mnrA0rJzRKNMJlIs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97D654198A;
	Tue,  9 Jun 2026 14:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D8B1F00898;
	Tue,  9 Jun 2026 14:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781014854;
	bh=TXeHs0fX+QguaS/BbXywnYLEbCaziSGt3K3M6eh74os=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=g3gv9Ex/sWSWA2ZX7TaqjGvfTx3SDlT81SNAf1CtYeG5uDDRP8QuaqIbtzZ+oUuzX
	 tL0/MtZaqlSasD02wbjE3w3rUuWVx6d37p0SDR76LFaHzxpjg/8qx0nytuheWRbFmF
	 baP+pwsIYxbMEBfHwJ9IiC0XEo9weTjpxdP8US3l5zmqdiGK+xRNnLXRL1brrg430Y
	 3W+DYUXciL+0NojSKuJySe6CUoXvbH+2iF9VSzSxcKrVb/9P0CpDwLNzViktRLOke+
	 ueEri7bUMDRZxY75YfCU+S+jbquzMJJRX2zZ4Lo8MDJa6YKRfd5KdTvVRk6co5rGVq
	 c3/oHolCSDAfw==
Message-ID: <dcfcc52e-7e1c-4940-944a-faf0c02672e0@kernel.org>
Date: Tue, 9 Jun 2026 16:20:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/12] mm/rmap: refactor some code around lazyfree
 folio unmapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-4-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526063635.61721-4-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 61DAA20006
X-Stat-Signature: 1wibakdpbkmmubs8bceaufq8gqfdosfj
X-Rspam-User: 
X-HE-Tag: 1781014855-269773
X-HE-Meta: U2FsdGVkX1/wgWst4U8asZa2LV5jys85BQ18/nhPw2p8TtvpJkhP52FdCf2YcAd1TZ43vMDt9wdJ/y5tLjJLZ3+/srImP+MwsJptRqtHa50IPXAzx76SLGpNhOOK4xJLR3f+krpCyS4Mnf9Xw5wLzUI9ZxJpDm/1ViUz9AiLGUBAiNA0qpR1lV4hIXgp0ndufPIwFh1dml2HaVQ16yGBNtcTpUUIisqset3INcvh8xoV1I/kJOTeZL8k0GwWz0Nip3vhWdtxkk9mv0TFvSzuE8dWp9DLldkhyT5gA69lPVwMH16tKXFT3oDSNuOWHEn7W34tNo7FTqa7pI2wo3Rxvuji8rKFIZeK6X7lJUVHAPr1u3ps46II7hMaQv9j8z2FntorKsXw/uUntd0P5v5tYBVqN5v1u3filvs+rSQRAwQYzevHgOl+GX8dzVe6KmF5brCB9jjBK6oT7Cypx0APhzoI8ScaIJSsihj0c2KoLveDcFjIQdmN/CcYKxNZVhoTn8McVN/O0ta5ZKixNgt6IYqofiipIACZmyQdpa6lHGuTdnIzGdJC1Mr3FJcN67tboA3rxuYvkV4v8SlUQRDYAs3zwsDisPCAwgRKKyyNw2lXf4F19f1GrrFvtFhNaL4/2eRMEP2lEIMq3qiYA5Od72uoTq+PbOecY/NxQjv/zuwKPntDT4NXaKRt7n5W8AHWz6dNjb2xoYIFcwBpOAjSHqQhn2hvfM3qsAJm5anJzmu+jXzp1b63r3d/twd7BVB8z65BZQv2teSnYKhJWq3cZRz/+qq4YilBzZYTGnWvJO37zeiHcDRxk0z2i/1nWPdRc4tM2bXLwwhkXeWJUy19wrjUy8UCH0sE+KlSO1zd5UmD/zSd0fln5VcidVtZ40kw/H8c66ExV7qvnxP9LS2KUv/8ZScZ+m8JaL6iVLY1mzvpJYQUHJj/rbc6CadTNTnpIJarT1JT1/Sx+bqVkDc
 zzOVsCZI
 GySgWKHTeumA2TokL9uB3VDGHP7m27AD6HtGWqzLIgtiuwZ7IMol0ke64cTXHXova28RcOop4N5RFw5aQ2WJ7QG3Vo5OCdOSH2es7hPpLKkaRfovuXHqOA0/jzJ8aIU4T8PA7eoGLAYvQI7O1Z0I9IElr+BlE3YzZUkCYStsYgCYDsrfaJbZGisVsYQQm6cdHhaf1ajIw4XQhzLwjiprAvx43ollvka/6dqRifGd9Z/+Z/Yoqb+b1K/lwDROWK3q8uKU7Gk3zYzZhw1E34M0e+qPtaqUMzDkDij/T0n0yTQ9bwieAwvFJdz9mCZOELYSul0Ar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 08:36, Dev Jain wrote:
> For lazyfree folio unmapping, after clearing the ptes we must abort the
> operation if the folio got dirtied or it has unexpected references.
> 
> Refactor this logic into a function which will return whether we need
> to abort or not.
> 
> If we abort, we restore the ptes and bail out of try_to_unmap_one.
> Otherwise adjust the rss stats of the mm and jump to a label.
> 
> Also rename that label from "discard" to "finish_unmap"; the former
> is appropriate in the lazyfree context, but the code following the label
> is executed for other successful unmap code paths too, so 'discard' does
> not sound correct for them.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 88 +++++++++++++++++++++++++++++++------------------------
>  1 file changed, 50 insertions(+), 38 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 06ab1158d4cd1..12bbee57f20da 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2093,6 +2093,52 @@ static bool try_to_unmap_hugetlb_one(struct folio *folio,
>  	return ret;
>  }
>  
> +static inline bool ttu_lazyfree_folio(struct vm_area_struct *vma,
> +		struct folio *folio)

Nitty, but I wonder whether we want to return an int with 0 vs. -EBUSY instead.

Reading "!ttu_lazyfree_folio" naturally makes me assume that this would be a
success path (which it is not).


Apart from that LGTM.

-- 
Cheers,

David

