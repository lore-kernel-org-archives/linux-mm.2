Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D42DCCFA1E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 08:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FBF78E0012; Mon, 10 Nov 2025 03:53:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA128E0002; Mon, 10 Nov 2025 03:53:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C62D8E0012; Mon, 10 Nov 2025 03:53:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E4E18E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:53:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 092F2140C8F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:53:43 +0000 (UTC)
X-FDA: 84094084326.06.4209146
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0E18F8000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:53:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SWWTnnCR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762764821; a=rsa-sha256;
	cv=none;
	b=npmddfo6kRiHwI2USOC6jMUEeizwkWjvLkYfz9JqWYiMaok2fm8grWxd+tGnUripLcQcwH
	oCMFBGdTShdYG7DW6j3x7y/hCzqHoJScdeuHrGd5WXY7NkYclwG7Yw2U4GP6osOnlb7OPw
	Ar+5PnnZeVZ5aw1Z9pSd4V7OTSVuXJU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SWWTnnCR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762764821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Ldu9p98EP72Lub2LnfLE7D8p6c6NaHeByWpsFXZ1WI=;
	b=PgQaTXIhvtSpXJiHk5BkS3CXm0udFRYZ0Ffotp8BzDWH+kNJWelVA9gCycjUqDR8RMwopY
	pFSSdcdUrAVWkINsswUbstDalJvDWuQMDOIblZKUn6gWxEoMd+aNl5LU37lVVqGi01dkM+
	AfYvuHhDOV856fBKXCL+IXNl46wnuX4=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477632d9326so20838425e9.1
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762764820; x=1763369620; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/Ldu9p98EP72Lub2LnfLE7D8p6c6NaHeByWpsFXZ1WI=;
        b=SWWTnnCRC3DO1FJnUutnU4x8AiGMiyGdnxm5W7TfYhgScRtxQBX4PPJZjE5tnibKWr
         h3ryu8fRVWNXP9wBwPSWGRX6ZfDlEjDLobY/48hw8MtT7t6kpG/d/sRJiAORUpGZMfly
         tWQkUshXCX4W7/ucNpiI2avKi5vJdR/0JQW25epv4obH/IyhD9qWrI7KThd6I69+HVQY
         Xy7vTtDtUXlHJh52Zz+sb5h1PmRU/7ennZlA5az2AeCrxCHyBI8XjlcHaTpROJMVcE4y
         CjIFHZr4ePQqZY4rkZvDbwa3GHwUre1+eLge62nyBOht1Ii8OmvxjP7Y6dmbBFCg+6YP
         4BPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762764820; x=1763369620;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Ldu9p98EP72Lub2LnfLE7D8p6c6NaHeByWpsFXZ1WI=;
        b=m8CJYzoI3qgA+5F+ldgVbi9HybugVB8ayGLJyneEShZ3HDMEtpkwh1hYQWJu1gGurt
         k5Ve6cLan1kFVCu93t+y2G+g+aaWhkykClfoyjLDc8RONgZNrOpLovEbWgYqr1QqSKtf
         vmJl4St8JuJlK8GZKOiwPixJmrDa1xgunI5il0j/u+LdxBk79UBD/oP39G0HeNhBqm75
         +jlFdXMOaWO0L/sUEVEsxcYQa5uQtKHEKDbvnhbAwxiUuaQsH42kNhKTGRlj/lDIzdNQ
         WMjD5WfV+F4KDaCp2wk0ZO5X9P4UtyubqBSSg3WFypvOYPX4ADkQb5nSO1fz7Xi0n2xk
         UaXA==
X-Forwarded-Encrypted: i=1; AJvYcCVDhhHcKDfKwWejHsGz7pmz6dSqwTM1gJsKYMZtd/jTn7hU+vJT09N1JH2fpXn9bdI8z4JbDUtwVw==@kvack.org
X-Gm-Message-State: AOJu0Yy0a12o68frOxkWaq4j1OLRUHiyark6ed1/B0RmSnhtMKhL1uKa
	b3V5wZTN1u3uC1KZ1DxrIUR7BTr6l4h6iF71a7zRLxxVS+eFdpGcLtXg
X-Gm-Gg: ASbGncsREoPNv/NVfI/rrR5tuhNKS5haiGDBGKLkgF2bl11D4ATHoPKtI+FzySXYb1U
	Ut47bFQzy3QOxmnpLkLe7JnQ6dj1uN6pbNAsfAGxxX/mm0dtJQDGOjIILiT+FBLq+RuPVTWMTks
	ue3LWkqtqDWP0u0c+byYzDuWQZT6zxobfeIvN74lVdpAiSWX0im5u3TsGrXhJFrZou+Qh5j5n4H
	KBlq4Mv3SuR1yKyZMuZT4xlWeN48/X4Uz0RTJ7UR1js7eJ8KKDmHKtXoO26yfui+E0MrFrPLV+h
	QYC7KqrzV9BCjhXUgHUd1F+QIUUyenjBo+sTj3c3GQ3ot7XjT9ybVPV9Nn2pWe7c2umFMwYIpOX
	X2IKA9OKU0ijDAA56HJ6LB/8wIbCp5oIoquBTqaZf6m50PDNLY/WhwNsbJXb0HTH/E/JCvTH6N7
	Ay7ZePrvfmEIRo/HBpKP8pEz5IaOjFp1MQi0T7xXuqnaXp8IKSJ6UxohKfrUoilXBQY4eB4Mtz6
	IWabCOhfPg8JAcROYDRQZKoeuHVPmZpmawuNa66xHFs2yBzBR+RBpFGF4Hg
X-Google-Smtp-Source: AGHT+IHOWXilb/YcUOqkNvD5jv1JX4N6N7v+d1KUcRwDS+nMZxJhbeCpIXfmOsG8KxaFsorMfkvdQw==
X-Received: by 2002:a05:600c:a6a6:b0:477:79cf:89d4 with SMTP id 5b1f17b1804b1-47779cf8b43mr25246935e9.31.1762764819414;
        Mon, 10 Nov 2025 00:53:39 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b2dd927d5sm14179020f8f.24.2025.11.10.00.53.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 00:53:39 -0800 (PST)
Message-ID: <048f6173-f538-46eb-b0dd-70f1aaa79562@gmail.com>
Date: Mon, 10 Nov 2025 09:53:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ptdesc: Derive from the compound head in page_ptdesc()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: vishal.moola@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org
References: <20251110063725.3118037-1-anshuman.khandual@arm.com>
From: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Content-Language: en-US
In-Reply-To: <20251110063725.3118037-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0E18F8000D
X-Stat-Signature: f9nw6dwa9iej53d5atnh839f1pede3m9
X-Rspam-User: 
X-HE-Tag: 1762764820-300228
X-HE-Meta: U2FsdGVkX19D1TgndjjtCz2b9QjNkvWfOKxbyDDwbjs5piLn29Lql5JHhA+s4qk/zcumKMiRRmXLY9XesFF91OzBFtm2/8uo+x7FrI4upYnO8HjgPfE85W3Hso612byyygr4bfEijsXiHryl9M/MMvESkblheBCDlPFmSIWnhcqsCjpvPPTf+dAnoIzw4R64apOW3dXjpIaAoG0rCvlUZ7Rr67jwv6UjtNG+P2l8rV9bLqgPz5C7syTRrZ0dv92FX5jhQbJ8kazZYprzZVcgGNEI4WJwscexElilhAbOATgFoVP02k5DRs9ecvkPBd2PLoqRyEwiuZhnMykDAkeslzj/Gt8+3m5DyWhb8EOnUOZM3d/Qhp5dSDCYSSUkPusYlCk956gYXBHmGitenBVSrwjJYdkiiJNQ6J7YCBmArlZdO7HfSEyxcIiARuUezvDz6j28ItHFXuC3ZNcP+t3XHPwkmP3m47xUDyAgAEDt3YXB96kdh7dpECo55FVy6LGVLWhbMGuOCqM0u6KL71DcM1z2JL6Q5ukGvkE6Rv07X65fHssPhuCrFnXaGKw1QzA+9yUN9qYYJR/cE6KRoevUKh+QP75/q79Px5WPKAC7U7NOMIMSVcQ5Ilx/bQRaIh2LqhWRCmu85vyXV3lZg/+eeX7EMkj7bdtZJZQHJOU95U3n6GUxU51i0t44kNpeesz+e5Udwy2FLmr2vYGg2emAI+4s+lPMY054aiLJGDsaEQXcrJfTQmXUg56XRMwsOGFxBYYaz2M5lmI7CHi1qBCmynOEwi2OyO/06UN3kJYisXK4q977EbxayEJrYXLn9+4wimtWCkU2MdkcCidEDxC6042XwQUQbwQ3bhBIKv6mIEvQb0MfecuYhpRCV4eKpRkRdPFU28+k4IeBJ9ZyQBAEKwxghYxxUTo0fPP8yeSR1hYLw9wzq7uOQMdy3hgnACSc+f3B/Vexp/fgZj5SNM/
 PFw1NmrY
 6T3Jt6NRo39HR7WjcS3GqntrtepT6cRwdNLoLfA48aDHV59M+bfAFfJS656Om/FhVl9/efdyw6n4YcH8AMQRACqYFkIeFhJjGj11Z9SKkbrAfSb4Wn85FH2158gJ6/JUPdmDhbtR7NjxVhdDle7ADrejQvR2/0H1xUBXZqSh+K9fQy8MFbFoupNpMJQj2SGHn/c8IhuNxkla5ZpzjtXKGwVs5+kS35+pTTwP9+2W0JZK5v8SYC1j/asZdJxCcmfsFhwwvSg0NiXoSTb+ogYeeCTVTmeMFMg71UPv2Rh16OfSghFdnpMnfFfZW9Zz/hHNlHXpZMS0MZXZTxxDWeb8NGuaOl57COO7+UuUc00AqS3UycxCho0m/F82sGAIQSwSqa3zMOAT2+rtWAdB9sIgPEzWesK13WtOyE5exlcXadw04L1+MdlzvXqT6H6gvfYKW6X2tpGFlgP8PBkIOWtzOEcfvsaDFrYR7boRZ5kf7QieuFpB/L5XYYrV6bP1+vDh1J57OzZcKRrt/7voFMlArUO4Dn7kJqQEqFUbx6PJzpoWmxKZy34HmWvYGkVYEq245kimWBzbe1tA2YuPT6H+T229UNx13gdu6/0pv2reaufsjkWMvX0fx9GpyXQJ71SIBOrh1M2dfjPNEIZHGwoQROqsg6ugmWFg5EWu0Yy42FGowdrf7VcYapaObPCBrRRyS6/cqRO90y7v45/YchPbJhsTZxIocsQd+sa1TZ1she2aJPG6EvibRiwXxyWBA8hcswBdQK2v8LwD6tjbHx2qBNSw5CCblRyX71lblI/LjF59+LzW83pM+XCMs+DDotbaZo92xSkAtDZNaSV6UllTLldChkKS0f+sbZvdrOIZ2nR4X/GWkvYApEnAwsNC4UkpB1jgZgG8rQo81tpej3+cBIFLlhcY6lJ6cHOXLfrOBJkauBW3+a2OgKbwF/KRP/Hcw/IybyyZ5zJCSpB9aP7f2aUae5Pcy
 mcQChecL
 O7O5B0FrhfE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.11.25 07:37, Anshuman Khandual wrote:
> struct ptdesc (including all relevant helpers) support multi order compound
> pages. But page_ptdesc() coverts given page into its own ptdesc rather than
> deriving from its compound head as would have been expected otherwise. Just
> change the macro to fetch the struct ptdesc from the compound head instead,
> so that the same struct ptdesc is reached from all tail pages.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> This applies on v6.18-rc5
> 
> Found via code inspection. Apparently struct ptdesc could represent a page
> table page which is multi order looking into helpers as ptdesc_nr_pages(),
> __pagetable_ctor/dtor() and pagetable_free() etc. Am I missing something ?
> 
>   include/linux/mm_types.h | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 90e5790c318f..f7107bc55d1e 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -604,9 +604,9 @@ static_assert(sizeof(struct ptdesc) <= sizeof(struct page));
>   	const struct ptdesc *:		(const struct folio *)(pt),	\
>   	struct ptdesc *:		(struct folio *)(pt)))
>   
> -#define page_ptdesc(p)			(_Generic((p),			\
> -	const struct page *:		(const struct ptdesc *)(p),	\
> -	struct page *:			(struct ptdesc *)(p)))
> +#define page_ptdesc(p)			(_Generic((p),					\
> +	const struct page *:		(const struct ptdesc *)_compound_head(p),	\
> +	struct page *:			(struct ptdesc *)_compound_head(p)))

Well, this adds overhead :)

The real question is when we would be converting from a tail page to a 
ptdesc.

Take a look at pmd_ptdesc()->pmd_pgtable_page() where we avoid looking 
up a tail page in the first place.

