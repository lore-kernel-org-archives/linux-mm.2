Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A80C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B63156B0088; Fri, 18 Sep 2026 17:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A1C6B008A; Fri, 18 Sep 2026 17:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50496B008C; Fri, 18 Sep 2026 17:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74B096B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:08:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3CC20A07EF
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:08:12 +0000 (UTC)
X-FDA: 85228120824.24.440A6A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5834840007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:08:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/3qZu/0";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789765690;
	b=KpC6AOIT5KOr1mMqn6djD4VIuTMHvjdQzxG2YnRtgBVA4n2DjoFBdDAXmKlDfo11QfxKAG
	Dgj1Qxt4Ef7cwUfoGxztGsNLCoUgxPLV7eEQtUbO+adbexb+p3ml9ZlSq5PcLuvUshIs+W
	aoApBlx6APjFkilTcyFGSjo7H0eCl7I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/3qZu/0";
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789765690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGY+xfVTy1ZxW1u/Kx3gEVZE7cqsRURvP4ecTB8cxGw=;
	b=DfS36Y8mJBI3FIg+Z2muZi3rc+qn9U+rFadYB9deIH94v0HGYerx21RVi2m8y8bS1LWarj
	Gr/BnIQal+aIt2K0q0RxHyFsjKPmwymcegC4JMVWrtGWA3g9qefQXSVPuV6461i9y4iy/k
	S6MmaLJ8C/yJdCZPLa7U54FLpAlFa54=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B37A440611;
	Fri, 18 Sep 2026 21:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369DD1F000FF;
	Fri, 18 Sep 2026 21:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789765688;
	bh=bGY+xfVTy1ZxW1u/Kx3gEVZE7cqsRURvP4ecTB8cxGw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O/3qZu/0W4vDewluE067eYPwTRoi7/Sue83LvflUTOyDQMCA+GWsYfKAHyuZxVm5n
	 gaME5/8jSQpLO7Jszatj6FZ2qECj0iri27vHHeJuznl6+bkKDzCWsmQi31baQIAM8F
	 zte8pfcvKXnuCiCSY1+RFzur125s+5Nxa62u1xrXz4Z+Win4Ksmnb52pSKkLnVqAfh
	 tS0U4VlGQyQa7fOcAbaTwRSBWgmZtErD2blwue9IpB8w9FtaxWy9c+jqqSxUTMWLj7
	 0gCzw7c3hPh653dH0CSRJ4Qwpm02hDAHKD12Qfy9UxCz/tkFn3DEW2ewgWLuaxIGjH
	 H5NfKly/FDhYA==
Message-ID: <3515abc6-ffcc-4530-ac22-4219e5c9aca0@kernel.org>
Date: Fri, 18 Sep 2026 23:07:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 16/17] mm/huge_memory: count only swap cache refs in
 anon folio split
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, "Kiryl Shutsemau (Meta)"
 <kas@kernel.org>, Shivam Kalra <shivamkalra98@zohomail.in>,
 Kairui Song <ryncsn@gmail.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
 <20260915-swap-thp-cleanup-v5-16-39878b37dfb0@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260915-swap-thp-cleanup-v5-16-39878b37dfb0@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5834840007
X-Stat-Signature: db8xxtyrrwu3dkeorf9ou81rb5bfubrd
X-HE-Tag: 1789765690-755264
X-HE-Meta: U2FsdGVkX18yRkHDEey3ph1h6eWW/exRAyEe73ZCyMDUewfXUkI7QZ52Wr6rFmm+e5St3lnfE8ia58oVzrCATMdSOwAFTGuA64aEcOD8KqzPYI8mYmy6IM2P/qwWdjAFf5e8AcToY344tm7/qhKuItdhoHQLdUf56UNThNU7jZH+iUEo8F0fjgQDPRz+S+hRZESPYy/WM/XDCnyrORo5EzXF3UKORD2qdRX3731/v4TjbSiXRQUeTE106of1c0C17+hpFgNqdlpeNckMsIhf76iPTe/Q8XcJDSlhE+kfASSa0uuW/uS0dxhgNtyg9QtLpuE28dqAtN0fVJdRQa5lzv9nodefBmf8TaqAwPqxfDFNa0+RtOp67VtpPA+2sEOJ8eNRmDskIlypv+h7AwYXRmUp6AUK2A/IVaESY1v6p5tQyEjEoLW/fZc7yhMBiIR360+O5gWB3UsGvG0H1gAfhpMHQhLxm3fyq073ih2BjcAIKMv91+vy2h5Wlhz2gNRksiufP3qKJ3cPy6UteAIOT7Ds3U9N85MyVFACqExy0kFlqL/JYdpuLvnGlr/kGzJSP6wUW7OO9GZPZCihEwab3wJGg681HpzJTXeZLpkxZ6IMPY4Oo9QawRI8uw+nxVsn1sWsgv4KZG5+mb/yJaUIEcaSDlk9Us5idbvXBpIULES1DIXUII06thLt1niytkXQd2O5S4TrG1G/SZBv6uULQeIkNXC4NnNvpU1kHsgS9NuQcIYZGYt9XBHmEsLVjHJHVtSZ8b/b1PDjj9u/Nli3Zf5Jn57dn5aYDBkrnc98XMAhnUpkw/cWEVnWzZMkv9vIkxCENcWUFw7VZJKvMmyJRD20+/HaapTtcLGyrKuv1h4WwdeOQA0T0ng57SQ1mNPDned73cVsnBdWjgYpb+uiBmUVI3k1Yau+UkjjlgYmNvHKzTCnpSiB5q65wNKWr0DurIf3SKmtRVn7B/F99+v
 4nyrvGXM
 q5+jlmsah84+KYD4qv7SeyXkpkxR6PdIaRmTaU6E0hvhuQm2wjGhf3qIKCW+/SpnKAeXxCykHzhs8JLHGf0GNx0UHZh/DMHIiigOEJJC1GVdVztNBa1XNCypmqfXg9RklzOGFvZLoc0+6hKZXR20r9VEsrJcppqJ83qoX0sps4IyaO8XG4W3p2Dt2Ml/b29WJ8jrFz+MEVgXqLHMV7mjHcVLSSRsJvfxPhR/iHxN8IR6vheITTBQarciuYaCcHot1l8AJWvdGQEfvjTXs6u8tgJNBMtd2n0IrxrEgfYkHwdCjD+cBMkC+0/IcR7LTcS+cItkkdB04h1Kf+w0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  
>  	zone_device_private_split_cb(folio, NULL);
> -	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
> +	folio_ref_unfreeze(folio, folio_swapcache_ref_count(folio) + 1);
>  
>  	if (do_lru)
>  		lruvec_unlock(lruvec);
> @@ -4139,6 +4139,7 @@ static int __folio_freeze_split_file(struct folio *folio,
>  	struct address_space *mapping = folio->mapping;
>  	XA_STATE(xas, &mapping->i_pages, folio->index);
>  	struct folio *end_folio = folio_next(folio);
> +	long old_nr_pages = folio_nr_pages(folio);

const ;)


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

