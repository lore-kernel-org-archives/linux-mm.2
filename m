Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42071C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34C936B009F; Mon, 14 Sep 2026 09:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5EC6B00A0; Mon, 14 Sep 2026 09:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19E566B00A1; Mon, 14 Sep 2026 09:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBC656B009F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:16:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C9AF1A0150
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:16:46 +0000 (UTC)
X-FDA: 85212417612.22.D6500A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 96C701A0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:16:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D1ns/Acl";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789391804;
	b=hLAFLZQ49DJiVOr+htwnOl95fW8QRiw9ZgchGkUhz3Anxpw2cLm1GNV0vieDedn3yjCw/b
	3axloTOHY7EM1JE/RmNJwFYovnDi/N1ogkdAmf1R0PkWCJI2ULRAvj0EI4zPtJFP2f2GfN
	NKpLS68s5dNZDsMlTSvJrRgwfkgVsCk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D1ns/Acl";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789391804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GBiUgvbmJL61I74QM9PSZC/060GcMY573CBk0CxwPMI=;
	b=WRF5C5BAZlcUf8a8RqZWBuiC0iFJ+HIumX/l9OOunYWfcfLPdjZelrIBiu53iGPEQC0rD9
	qMCjiQ1rb3dDJhJPVCmtb/8PLxQ5Dk5yNhYNnLU9Hma3aV3ZBj3V6SR6ZYP6s85JOT9fPA
	3hZS6x2DegqR79z7h/Vp2dNFZbJt+vg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6E83418BD;
	Mon, 14 Sep 2026 13:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596371F000FF;
	Mon, 14 Sep 2026 13:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789391803;
	bh=GBiUgvbmJL61I74QM9PSZC/060GcMY573CBk0CxwPMI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D1ns/Acl8NlyCRfAMuWBdUlk9ePUqsUljWh5lM0l3HYkKNbt99m30YPVy3XXTB0X9
	 g6QifLZRIQ55Gep84FzTXk+L9VwsWHjuH5uNzAtcDxgSMgbUoYFMjJ2fEKemqdKp0e
	 32Q3xIJ0TpxMTJP0yJJGNiwIdY4eJKc+wkw84y/1drlSwMSYM4G8gpR4BWr7nksKmz
	 uboaHlq1lPNdhJv25gZzpl/XDiVuaZYqok5NGNEYa+OMHNPMJYG4WN4i3dlxcbwQ5c
	 QHL9/Z8evXRsbBQ3TRNDWEgr8AfvtxjYqzhl+Vn4asvB2Xsf4/2sdNodFsSNn6d3sC
	 Xy18WgXGzq1nA==
Message-ID: <a373d76c-6ff0-4ba7-895e-343eca9c564e@kernel.org>
Date: Mon, 14 Sep 2026 15:16:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/16] mm/hugetlb: use direct assignment instead of
 folio_change_private()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-5-848550f7574e@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260913-remove-pg_private-v4-5-848550f7574e@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 96C701A0002
X-Stat-Signature: wb4zipc67btuu7ptytre5sshwbxr47dk
X-HE-Tag: 1789391804-236080
X-HE-Meta: U2FsdGVkX18DDcomidpy3Ck2wx05TILMnwgUvo5UJI4utnIHLkRsoha0YqSwLk2nTzIB+6DYfr+/wrO3BaQCj2dfBNLV0bS9NCN7CA0yI3bbJuJyC9CbQvSkc2LM//0HludJGjv+D1yPrC7+DN8DsiUCX9VcCLubz0hFJwBtwSqnm1g1LeIQr+bbTkV+UGblgy17Hxflo59quqvT/ZBpAuoZ1lHVV7/jd9qmGlkIlFd/RDmezvrZWHnQ3vLWPF3rME7ETVYV4JBljEdade6DSml7+Ke5L4Em/7xI7Ul7HUQcxxRED4aUYFfzAgTD1wj7nwwgt5kPp6Bd79Lb/un457WyY8m81oaBAzEJtkM6kJInsI9XTNh8KEQrjd2z5vN5YQ99vcl/HldM+UyT0sbpyZHv5r3npe1AmwShI0oq5P53Qe4Gcy/xS91UzgufSD6HmdNPfFYiOhL7MiWvcgvbsmE7swuAPKrHWsYEKRTJsI/BLeWTQVhgEhK60NWX87cOXtXZiCE5uTZpqIeICQ2TdCZlGGgiQ70rZ/kMas6kJwTP3ic4vuQn3rPxHTI7QWPMJZgFV3QDtel2faQ4Q5JJz3CYCwE25/tDNEO3BkbGpnMDZxomNCDBO280ixyei3CHVroJFcOpeQ8a1dvppHDr9jZgxxXYJh9l97whN64wcoYnmh8HROemD4pKGggNSCjXvTBQfncvIBJj7A9UF+4wRgBIgrN9MizGWAaWK0F7Cc1iom1jLs8EZAXVQqT/4BBPitYoRvDYgIxBbqlrBWOpEI1o9p9Ek6D1mNnG016MGfPZMJlHZEJpdTZxvX8Pv6X3I4q4rsRGo+VyWQmJQ5Ih+xHenQy7t9s1MfUru5CfU6R6RYwh2tTB5kioIOVWNOKRBOUVVObLrz48ze+gyz4mpw78oILGEucd2VckNpExQtI8YwmJRw5QlByr2Xz3JYwfOrILsHfn7lTIO05NTej
 gQ2GbT5o
 Rv9na+9B68MvK5t7f9p7fIJsylTjqj5M0pUQYepZ/q+WBVnksVLeqPk2NHDpRqYcm8qk4U/SU7Vd9zZA5WcWFBtdf2GXzEwSgVEYC2jsEYt23JNQ0je6wDAK7CZAdNQpPvjNc45R0nwvEq2GtG5pb6p5f8zTeexhTl5wJnLvC2qzOynLcyaH1TQiMZvNJbK6eMOs5vKAH2StuavzlF1um5TAoik8wAzRe2tIu9Q2F0QnRZcEtU3hrlPEpjR+bP/UvQXoxS1itX1qwWEilELr/gOpxfbLl9TQaA8zags8t/5S7MwWz3Z1ZvTT19O3bGi4tnPTqxuhEHc6BMzRS5H3uocTm5M2B71LWjTblPSby/sNIcjwukerJ+30sumThsMKs8+7BA14ocgUO96jXKfeU2MI7kd2l9Hgf34LSSqz2UZJUP4xn4Ko/yXRs9xtxUT+sPne+xQxp2nd4n//VPJRLGFGrtz+fUKGY4NIM/Ss9g84CjV18326YHT3TZ1hMJOb11qbzWlp22rWDKwWW8Sc8khJHUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 04:24, Zi Yan wrote:
> folio_change_private() should be used along with folio_attach_private() and
> folio_detach_private(), where adding and remove ->private content requires
> folio refcount change. add_hugetlb_folio() simply sets folio->private to
> NULL without refcount manipulation. Change it to direct assignment to avoid
> semantic confusion.
> 
> It prepares for a future commit that remove PG_private.

s/remove/removes/

> 
> No functional change intended.
> 
> Assisted-by: LLM
> To: Muchun Song <muchun.song@linux.dev>
> To: Oscar Salvador <osalvador@suse.de>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/hugetlb.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index d3a0650ff6905..8d551cdaef9db 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1446,11 +1446,8 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
>  	}
>  
>  	__folio_set_hugetlb(folio);
> -	folio_change_private(folio, NULL);
> -	/*
> -	 * We have to set hugetlb_vmemmap_optimized again as above
> -	 * folio_change_private(folio, NULL) cleared it.
> -	 */
> +	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
> +	folio->private = NULL;
>  	folio_set_hugetlb_vmemmap_optimized(folio);
>  
>  	arch_clear_hugetlb_flags(folio);
> 

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

