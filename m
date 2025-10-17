Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6E52CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 15:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9712D8E003F; Fri, 17 Oct 2025 11:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FBA18E001F; Fri, 17 Oct 2025 11:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6631A8E003F; Fri, 17 Oct 2025 11:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 391F58E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:44:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED6FD56C07
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:44:49 +0000 (UTC)
X-FDA: 84008029098.09.6A131DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6E7D8100002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:44:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="D/khKphH";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760715887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BVJziZzaH8Jv89B+615n1DyHlPylee7tmV2DtP3EtTE=;
	b=Yszov1bQTBmqrVg+vUXZyCCYroOWWE673wMxvRs6JpLG0qPnsXFaxiR8iKVUTaE/XkOPq5
	lzc2KgWRMSnYWQpYX1ITwaY1wHfy73zVlyljI2RNvro6C7xc0Fpk6MdDwH+zYn442vU0/q
	HN9NE7vVHhLOA8dOr4t3cjFkzZfNyi8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760715887; a=rsa-sha256;
	cv=none;
	b=Nl1kix3yHfZlHB0xntladNM4zW6br7mhWc907C9HmU32HOz2K9S1JJNYi4AYx0z2jckMbp
	Wpv3E8yq5wACoGjw9rONeDXqdSfyE5h7s0fXrJVNUO94zxQYSs1NXvpT3hirRMq+6+CWqK
	L39gSf+WOCxgOMGOEYK9Y57LFS4i3vM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="D/khKphH";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760715886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BVJziZzaH8Jv89B+615n1DyHlPylee7tmV2DtP3EtTE=;
	b=D/khKphHCWH6lggQ9Teiv8AyUXjLGL/p+fTpHjSLpUvSP53KzmHWR7w8CKCLGwe29wqN/O
	WYG2nk88jyHgbnmqO3o8vn5YvNiI0apf8U65hZiIAX7uWkK0duqQm2jaYFwJtfw0SQVkoR
	1mpSLMLYb3bjuOWh0WB6TXrxmeXPQl4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-qXLDisrLPWatWSpDkIMP7A-1; Fri, 17 Oct 2025 11:44:37 -0400
X-MC-Unique: qXLDisrLPWatWSpDkIMP7A-1
X-Mimecast-MFC-AGG-ID: qXLDisrLPWatWSpDkIMP7A_1760715877
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-426ec5e9278so3245686f8f.0
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:44:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760715875; x=1761320675;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BVJziZzaH8Jv89B+615n1DyHlPylee7tmV2DtP3EtTE=;
        b=MUhcMEnvrmJ2vGPT5C7QHmsdDQN4vBB96R6igeq0ahxou41QRC7V0NsZmeELsmx04L
         ujNCCzilpek7UVgK7tna1KQHFZOxJTGhg1S6YBxPylWDt6hpbywFtOxutKm0+c+Aqykv
         7/zmgssHF17Oc65a2H9ueH8db5P7j+XtANJPyx3nOlGMtJL8NwJni96KHDZvYNPxFbuL
         CsZ0IocGSwxBOMlwZJJlc20K5B3dEktXC3EW0DfTTQOTmOWxToSjDsiu9YSu8D0CWTiK
         QXFW0TAgHtnxuEVqB8G2HLXQBK7OK5M8F5PtmzrFHqXr/iCuYM1o3KgzW97bvMVmwJ84
         PUYw==
X-Forwarded-Encrypted: i=1; AJvYcCXh5pu+WCkGxiDCIgVjqLnqDAS9UM+5BbqfyOxZP33tO0a5o4uCfJzrLT7wuL8rOordKn991bYf2Q==@kvack.org
X-Gm-Message-State: AOJu0YxYYzMVeX6SjjILrbgHta5Xzhu5holeMLqpTzI7gKyZcj6gMAPp
	EbODLLz/jAkZpAuVjBjQAG7Vh1yeX3F/xOJbJlCh7kiRMrh4zlS/sMJnRLhvqHSS4vWKnib0T2P
	b8wku6zZKbZByfsuf6nQw0HNlIQNzQ7N/XRb8RDuYJG6eY6tjalxF
X-Gm-Gg: ASbGncv6oijSbuSDpoO6VSpd7mD/6TDLpthoC+0I8w0tSlG1YEe7HuUEPooZQjPiBE9
	N8eQZb3dEBF9pgc614rMgXr4+cOdxrmkO7RSEfThZJH/ZHD7yrz/cCymobjGz+/tRkuYUTh76xp
	VJwfDJlsT5Jwmoq3boELs4Z8Mf3IB1bkPvAupyBtym45E7Twsz8g1O0VXxUvLdBwyflbpjOfkJl
	srHjAsn/XPvccg6JkPeyrYs9BynZckjWBesvGLZ7vbT7BAg3ut2ewWhczeSNdDeEbb2D/TZHQZ/
	ZrtmGwj4W8DoB1lWbfus8mm3sPsveTbnC0R72c+3Dz0KNpcln6ihPatVvJ+aupQyXiIJux96r8C
	sVnhCJWWhJfYMLbw2x2uw3pGuCnASJjoyt/OJPfhM0KfLze5Juwk8SKjP9+nXYJ+gT5HIT9uJmK
	RiY3E9bqI7JP1bUFrmo8m+Giis6eU=
X-Received: by 2002:a05:600c:3e07:b0:46f:b32e:5292 with SMTP id 5b1f17b1804b1-47117872663mr35610825e9.8.1760715874963;
        Fri, 17 Oct 2025 08:44:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWDJkKYZFsSRK7pMNDsTpLGIPelR6vKhzx3DtGXCZ7HvQlAugOuQJ9QMdp4RVSWaVNvGYxXA==
X-Received: by 2002:a05:600c:3e07:b0:46f:b32e:5292 with SMTP id 5b1f17b1804b1-47117872663mr35610695e9.8.1760715874606;
        Fri, 17 Oct 2025 08:44:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4715257d90bsm1082715e9.2.2025.10.17.08.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 08:44:34 -0700 (PDT)
Message-ID: <05d7832e-7bbc-4c73-b293-f512b4776aeb@redhat.com>
Date: Fri, 17 Oct 2025 17:44:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, craftfever <craftfever@airmail.cc>,
 Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251016012236.4189-1-pedrodemargomes@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251016012236.4189-1-pedrodemargomes@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Tg8sv9boFIheSJ_H2PvBS_E3_E1f8r4_k_iCpuxLNRU_1760715877
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: nj6d8hiq4ectao68cysityw8gmsammou
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E7D8100002
X-HE-Tag: 1760715887-884142
X-HE-Meta: U2FsdGVkX1+JwAuNyBYY+EAoPfLE5sDZlMPxwIlR99P4TRSgK+R2x+kLQmC8WdzLNIWDVloYnle+vQviy7C3K3tgPj8lT/xZEIMtVbOPSyz/ztS5MyfW+5ffgF7i76jbGFXtpt7DZaB6yCcfdPvFl/lR5USO171riAl/BQQeMzI3EOwQLF9vcZGVAbrljWbURYJ1VqyOerBvQDQUovYSHCdXYAwWxGYnftvamKzTz/6nxI7BRpfh43+d7cV9oRi4sApjY8T/8zvSQw0i8vYOYmHurqof9dVXi90mQn6DSaU+wAdQMzo34QUq9wkP4uNcipsNk/Kj33W4cvtfZ73p+8tdC5gHj+thCBZGcXukMtx6kxPFDtPMT53Xr/747GLzSE2Xfs5T1mB22l6fk1zhG9wCXItCKw04LsDnnI7HI3yU+iKS7x5q2gQIfjRvIIljLT6sh1v2OsbWfdQWCrtVmgDJ3XWc+iNusg52+rontz8eyncnkniMiyTuPDQfqle+GmSW7/tN/uTPRu3ZVuMeL8/ojx2GOc07XI6+EFkYBJnfcL+/k9aToFfVkOW6aqsVMkS7ZBio155bMtLCJ8Ukm0ft1QBieOLsOKG6YaWCYGYGOtvrZ1WsqynzR05dLgeCI19Ot3XFhicS7fIuoQAHloA3HK+nJhcC+WPnMdTL3pS54BMTL+m9STL4Gx6CxEp3aXg7U8f+Ot1HvmdzIOk3OrFZ9ERTzYhdxGmCwiGMZomEggT1fOJyucWqJy5jg96J684retuGgnyqt6JpI+tu/r8qPvq8kCbSotcA5G6KHoXgtjqvTCN2OSce24ZmAMAUE7kleCfYOMsF5tMMRm3Sjgh9APfXwWGFIz/5cEiK4uGg4D7cjpsop01yf3qDAahpO7hvJyV6rU5mc/lIea3/bHU7YOQg7/KnvHjDSb/5uoGlOEJXAyVNTmK0qLDxKsX1Ev7eX8y2wFvYYZKIUz4
 16LaBNYL
 5PKIvyyTOslrLOCerpiMbvF8/E/cJ8ttqL5VSFrm7RCETDbyl7DtXr9gOc8QLbvBYgdKokRDF0VQzDyGaINWvwSyyNVGENM9tsAA48vcJZ4EYfsPgxuGs88F4ATM7WBXA4S/SaGTgJM78FbpWX55dwFahNgx8X1hTfdQT3fk/8jEjBCWDntXU6gWpr7WJ5DmIjBeeywfY6bhoVfWNPOZaxNE9+gg7PYQgdOqyfGBNLBLmx7jupoLAxWn8JrViomY2iw22zf+UD/SVc8qMkVD3Sg4u/MAekpgRuCKU0F9tPQEVYYhQrGItZWqOQV85JB+fQcm1Br/5dKEyh5YRIDIbGOW+4pmP0s+esP6llMxDnvXfhqaG0m/EAAzB5PAMsSo5z7Z7uYyUu8kW8vGfutO/UgUPzoxTpmom5h8YpopvoWU60rlwUVJzxLiQjY30PVqD3UO4pc+NUQwNPd+89G+1xWtMz7AOHxvN3SK5ukn1Nqe+Mpp+5ybI7Oa1Ow9t/LEcOF0WyOD3/P50CYnclb1nzHS7bS8DRjkHE4wi/QlXz/FxmT7Qkh44JGz9toqrZBkF8qUyQv2Oh0zquHmsB11EHY2ZPz11Yi6V7nqIU8zr162C61Z1vR0Gu9QRbkWg0YgQChr2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.10.25 03:22, Pedro Demarchi Gomes wrote:
> Currently, scan_get_next_rmap_item() walks every page address in a VMA
> to locate mergeable pages. This becomes highly inefficient when scanning
> large virtual memory areas that contain mostly unmapped regions.
> 
> This patch replaces the per-address lookup with a range walk using
> walk_page_range(). The range walker allows KSM to skip over entire
> unmapped holes in a VMA, avoiding unnecessary lookups.
> This problem was previously discussed in [1].
> 
> [1] https://lore.kernel.org/linux-mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
> 
> ---
> 
> v3:
>    - Treat THPs in ksm_pmd_entry
>    - Update ksm_scan.address outside walk_page_range
>    - Change goto to while loop
> 
> v2: https://lore.kernel.org/all/20251014151126.87589-1-pedrodemargomes@gmail.com/
>    - Use pmd_entry to walk page range
>    - Use cond_resched inside pmd_entry()
>    - walk_page_range returns page+folio
> 
> v1: https://lore.kernel.org/all/20251014055828.124522-1-pedrodemargomes@gmail.com/
> 
> Reported-by: craftfever <craftfever@airmail.cc>
> Closes: https://lkml.kernel.org/r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> ---

This patch will need some more work.

@Andrew, please drop it for now.

-- 
Cheers

David / dhildenb


