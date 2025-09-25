Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83BAACAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 09:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01B28E0005; Thu, 25 Sep 2025 05:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9640A8E0001; Thu, 25 Sep 2025 05:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DE608E0005; Thu, 25 Sep 2025 05:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64ECE8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:16:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2640C13AE53
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:16:33 +0000 (UTC)
X-FDA: 83927217066.11.EABF64A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id ABE4018000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:16:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sb2ZILoE;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758791790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toj2ZxJ2b4oOQ+sKDtWc0K+F9qjEsZY2B0GFhQ8OUJk=;
	b=1flQq/m7IvSAXohwzEjev/4tOYStPbbiDCztCBW4aohFFNNUl/Amyfy5l+3s1PxgAqSls9
	Ef7OY9NqLuRgdRabgwesULhmH7Ypnrcs8hf+pl5OpFLYQA0eTcpVfROV7tUIPseewEcz+o
	Zmssujdv6/rxqHyGJvCoehrF+3uuBUs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Sb2ZILoE;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758791790; a=rsa-sha256;
	cv=none;
	b=Uls7le2EQyTCDjhNVb2YrxHN7U/J9gD/PYk0k8fGKhZeaF1CT0s760015/bOPnnWWUDjtu
	d8gHMmjGrbKYvwpjTd8uB9tyR5fhQOAcJdWOQChXE5wuzAT9npXA4hWWgIkYiErh+vO/bY
	wlFuGaKy+XAAgUyF/cSvIhz6rgUrNBw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758791790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=toj2ZxJ2b4oOQ+sKDtWc0K+F9qjEsZY2B0GFhQ8OUJk=;
	b=Sb2ZILoE8vVsvABZDtP6UD5VEQ1PfwbC2txX+IQ9WPsQUr6yxq5eWNRyfKf2aQukF6aYoI
	L4/5dIS8TA29gb7TVxevOaG1UnPdKOR6MHoWXinAwMsv7cK2v4szS09T8huFqbmsWnVX3m
	yva0jJQ5r5uB3bvOGj04nozqXfwCv/c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-YxmDGpBQOqGqgQULL8ZeGg-1; Thu, 25 Sep 2025 05:16:25 -0400
X-MC-Unique: YxmDGpBQOqGqgQULL8ZeGg-1
X-Mimecast-MFC-AGG-ID: YxmDGpBQOqGqgQULL8ZeGg_1758791784
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45cb604427fso4125255e9.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:16:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758791784; x=1759396584;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=toj2ZxJ2b4oOQ+sKDtWc0K+F9qjEsZY2B0GFhQ8OUJk=;
        b=EOnU0JpdCTdF8GCM7wUzseMx9M51g5xtqylVpaRxbX9A+R3oRPsv4CN4Zk1RxP56X5
         9xW6kEnv+IyTdagbDTsK2PQryIOf5wROCyQzkP3YfQHkoJaQ8m+LfrCUgWOJE9tpxABr
         qE/bL0GVTEtBWHH9lAtxboURkbdn9ngixGOsBukzDc9SeBi4K4r5z+FMlzUUttH5PWd+
         rqp35Q/JbqgW0A/xm7SMUoafjlUKI3MlS46Yv0xK33iQ/Kfq5/f6/3dJo1lSw+oXmzn9
         Qu5rkOnyg0ABv/K7qQZXejqiXZMUVKsbxkpU2wMmvkkIONVsT9klwRkF6IUUR9QY6RYh
         Ns8Q==
X-Forwarded-Encrypted: i=1; AJvYcCU8tR2gzUxDJ63hmtzqwQK497ixM85hVEUyhJKS3VuMal/2KYQT8e8XaXjMhiemtauhkswZ4PPqBg==@kvack.org
X-Gm-Message-State: AOJu0Yyp4xMlnHrPMv/7ukYFbiA5Hbb7V0qSR6ocapKeXLCnQ5WCheO8
	smdw9CK7vIVwkmhXK/fLnqtl6ZMCQbldR7bSUryLXCLj4wZobBddL6nrXKmgh5H3wHSW+mFqgSz
	vPYSUTV23qeazx2YAp50CvGRAZmo3yKokPOHy17Xi0re7WZbsqHoc
X-Gm-Gg: ASbGncuXOvnmw9sjb79LJoIMj55plkygSUm14XDG7bk7OhPNwNL6cE0Bwe7LgVIwxJE
	qA20Q1Yp0fGZoOKGXgYi6QbB7tKQETCWzpNbobfq4VlofFeKDzCUvF0vQh9YdunqF6C8z1MMwFe
	LkDFzy0mWavztArL4NfEUi1/dDuVEmHj/JjOR+jGFQ7xu1CaAamzEE8DDLjGJH5T1Ty0tPUYSMa
	LHqg9jlVA3navl+cZCtY9JO9EKYg8tGm9CE1SU/rwsjeDeEiADOsnnOaUw/G75BkPstmWCfKZ0/
	Oop6pxq+RbsgkX+USZ6QO5+OTghnGRnOrssPpgxNr+0hCrEaJYCp55obBqFZqDKz9WSA7e4GEJo
	48CsHYHz/h45mw8hzp3kjXd2RhkP7xOIGrT+Xv+5415YeLWeIkCvJmg4hO+O5QEYEgEq4
X-Received: by 2002:a05:600c:4511:b0:46e:1d07:5cac with SMTP id 5b1f17b1804b1-46e3292451amr28057805e9.0.1758791784142;
        Thu, 25 Sep 2025 02:16:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2p4A+NW0u3h8NbGhux42vGg83SKSNp9azU3IZCNKQ1B2shvHwE4aZsxwTXhfaWI6hnLnTWQ==
X-Received: by 2002:a05:600c:4511:b0:46e:1d07:5cac with SMTP id 5b1f17b1804b1-46e3292451amr28057545e9.0.1758791783682;
        Thu, 25 Sep 2025 02:16:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e33b9e8aesm24980165e9.4.2025.09.25.02.16.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 02:16:23 -0700 (PDT)
Message-ID: <072b8684-47fe-4a2a-bf69-f6d348f0489b@redhat.com>
Date: Thu, 25 Sep 2025 11:16:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: move rmap of mTHP upon CoW reuse
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lokesh Gidra <lokeshgidra@google.com>
References: <20250925085429.41607-1-dev.jain@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250925085429.41607-1-dev.jain@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bHIYGdlwdLCDXzEM2ZZxlZP0hOQCKag3YgaPPudZkck_1758791784
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ABE4018000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ko569ar369wnd6duzepuumthnrgs8uai
X-HE-Tag: 1758791790-544276
X-HE-Meta: U2FsdGVkX1+SHHS5X4DHIG2xqirDE7U3epiRvAht3TXz07zMiQvTQqXenxMcgWEr4asTp/b5Uk4kwXdQBdRm28zMo31hqGO7ZASgJcbnIVoycqDAgyTevXjmVRTlnSSNqcac173Iq658/927W+ptzTq90drm/K8PXKm5PEsHgAS2ltteByA+XVlvmlF7m5/6mdUjvsRPLNdb4xKzHw2ZXc/7fszMNFYnBF7B5bEnt4OKUL2Aa/lVKelcV3hzvOIcRx/5pU1+29pNkY6iJvxxbMtwgC5o1D+N5QfAWJwvekE9+a3YTd4aDMtMrA0/KXVbkEBNO5wmIX/l9wR+xa5g4vapo5SIx2xplTxFrvBPPYgZe18EIWRHG05C8h/dHFTlXP7KaHYssUQtTli5cKY3bo4jPKyRwQC6HYAjm4PiXZjk0lq+wxXIHhN+eRluOWVqPnSoCh6iP98xhTCKiML9361B8OWg7i3ar2bl++9NmKfWshgEN9iZi0AzoOMrkH8N/6XlenrzQv8Yz7GZNsJEaxHkzNvzIobsNfdgN22n4vMAo4S5Shhk7NfH/YVdtaA+EnDsCPBEGIYOtNHbQ/R5+d6E69XJHw8hUm9U+9AENII0ZWQisLXWPOiCLQAB6dcDD+WBdo7LJsmaWcSs0BAfgPUPlQTcf5TIIRlXMSw2u45GZBqE+YMnNrRdMfGeZkwydUBpZIsI/3YfGWVrEekc3i6gsuXxAsYH8TWi2eUQX+HFqw48O9ZnhJvKGPdDt30b82rmmS5am/ugCBkuabqnhnJYocPjR+o9guwZk2b0NPbEsBSZTOv2pJAbS3dgb8tX2FSMJCLEitM+pPsOUcbnsArgE5YMrGZ1tFE62aIJgVkA4ulDvcSjSD3tTVTWi2h3u4KLopMAcSarrzDxg6qt/U8hCDkOvwi1SqZwKCCSy+Ivvqk7SFrGbjPFckdaO8LbWHtDmf6AJz0DFgN/QEE
 enFyoiNI
 +2OU8aIhXdaxzRj5ywCwvz0SZ8A485MZx0XQPokYq2XfKC2wd96dtuZTpHkX/F1fwjpIW0E1dG5uI58317joMBpCHGO6OiJU7S45DhTdX0orFK9Dw/B3/q7m43o95hGQ7lQe9mP/9JotPtn2KSVegTT0vZckflIraxJ6VOV8c3g9kdCemK5/rA+yKZEsoQJ+N4rng9eOxoNyRposOV4nu2xukfdXumBL88iwUto/rYyJeLfrvFMzq64hxR3apYjvG7vl9xPcZv0HFjNS3twgmUnnFahgRF8uFuf8TMBBETufrdPkWehKTgpnuh3T2Yx3zigDz+sb6y20QWvv8OX7pTIY7+TdzqG0Crlv22g+IKICBJP271c62MX4VEzj8LYwQw+5uIYEXfekvaj86gZNKXit5bP+dw0VL2woejUoczVCG7OhzbVDc1EY1GzaHQbSeZLfbM/bdcgZwbq4yZJASak/E9rtfDAwnvW9osiCCNpe2yze/gZb7oUHSyClybsdC07LkQetnVP8AeJDDZQilX7yipVq18emm1OHg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 10:54, Dev Jain wrote:
> At wp-fault time, when we find that a folio is exclusively mapped, we move
> folio->mapping to the faulting VMA's anon_vma, so that rmap overhead
> reduces. This is currently done for small folios (base pages) and
> PMD-mapped THPs. Do this for mTHP too.

I deliberately didn't add this back then because I was not able to 
convince myself easily that it is ok in all corner cases. So this needs 
some thought.


We know that the folio is exclusively mapped to a single MM and that 
there are no unexpected references from others (GUP pins, whatsoever).

But a large folio might be

(a) mapped into multiple VMAs (e.g., partial mprotect()) in the same MM
(b) mapped into multiple page tables (e.g., mremap()) in the same MM

Regarding (a), are we 100% sure that "vma->anon_vma" will be the same 
for all VMAs? I would hope so, because we can only end up this way by 
splitting a VMA that had an origin_vma->anon_vma.

Once scenario I was concerned about is VM_DONTCOPY, where we don't end 
up calling anon_vma_fork() for a VMA (but for another split one maybe). 
But likely that case is fine, because we don't actually copy the PTEs in 
the other case.


Regarding (b), we could have a page table walker walk over the folio 
(possibly inspecting folio->mapping) through a different page table.

I think the problem I foresaw with that was regarding RMAP walks that 
don't hold the folio lock: that problem might be solved with [1]. Not 
sure if there is anybody else depending on folio->mapping not changing 
while holding the PTL.

[1] 
https://lkml.kernel.org/r/20250918055135.2881413-2-lokeshgidra@google.com


Regarding (b), I think I was also concerned about concurrent fork() at 
some point where a single page table lock would not be sufficient, but 
that cannot happen while we are processing a page fault, not even with 
the VMA lock held (we fixed this at some point).

If you take a look at dup_mmap(), we have this:

for_each_vma(vmi, mpnt) {
	...
	vma_start_write(mpnt);


So we allow concurrent page faults for non-processed VMAs IIRC. Maybe 
that's a problem, maybe not. (my intuition told me: it's a problem). To 
handle that, if required, we would just write-lock all VMAs upfront, 
before doing any copying. (I suggested that in the past, I think there 
is some smaller overhead involved with iterating VMAs twice).


Long story short: you should do all of that investigation and understand 
why it is okay and document it in a patch. :)

> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> mm-selftests pass.
> 
>   mm/memory.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 7e32eb79ba99..ec04d2cec6b1 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4014,6 +4014,11 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
>   	 * an additional folio reference and never ended up here.
>   	 */
>   	exclusive = true;
> +
> +	if (folio_trylock(folio)) {

We should likely do that only if the folio->mapping is not already 
properly set up, not for each reuse of a page.

> +		folio_move_anon_rmap(folio, vma);
> +		folio_unlock(folio);
> +	}
>   unlock:
>   	folio_unlock_large_mapcount(folio);
>   	return exclusive;


-- 
Cheers

David / dhildenb


