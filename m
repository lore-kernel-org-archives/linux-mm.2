Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 473A5CA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 07:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC78B6B0099; Tue, 19 Aug 2025 03:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77C46B009C; Tue, 19 Aug 2025 03:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D666B009A; Tue, 19 Aug 2025 03:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5E4A6B0107
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:54:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63C43117449
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:54:31 +0000 (UTC)
X-FDA: 83792744742.28.7E3FB73
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 239DE1A0003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:54:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H8RbYvPp;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755590069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9W9Lxnwsqcb0sJAwIsuZAMV48nhSH9Z6F1jCNOWQGw=;
	b=2TkGMULyN6uUyB1RmKdZYz4HU6OGpRLDIuhM5lTIby/zlcRenEHy3lIJ/vKbbFTQDhuf8B
	VZ0B6rM5e7omrRY3Og9pwHpRcHfRJa/DfENDONVXiHUep3V2eAFUu/+DSh8Q3m4LMd0k/q
	p5rl3IuT+b2j/BE+NwtcmZTyIbJ9NZk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755590069; a=rsa-sha256;
	cv=none;
	b=5boHPU3uk01L9rB2vhZzPHuNOAtAO/SXe3qy1+Uq8AIl7AYI7nXFrnd5zl7yNZmcx7wi0g
	O0iuF+BhXA8TyHv2rp1LLSyVCLRaKKQA16+xK/c7U8b8aS/fvfdlI4QPM+EoKXM+w6A+eZ
	oWDdMndeNnFy/WxjOgEHih9YjbfACkI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H8RbYvPp;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755590068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C9W9Lxnwsqcb0sJAwIsuZAMV48nhSH9Z6F1jCNOWQGw=;
	b=H8RbYvPplxvDr+RMf3ivFS9ZpGIvaSTWv8ZMp6NuUWiNeH1LXS9PQa1AHJaKRWwL+9hUTT
	z/g0chOyVzdH2KLGo9/uN+ICtKJFAyEPSI6bbSZqASjm0mJdopYwW+6ZiPgRs2yV354gzd
	3NtNWG6aIwc4SWSFvdwX/qyLQq9m1Ks=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-cblMH8XzPkqU65QPqtILnQ-1; Tue, 19 Aug 2025 03:54:25 -0400
X-MC-Unique: cblMH8XzPkqU65QPqtILnQ-1
X-Mimecast-MFC-AGG-ID: cblMH8XzPkqU65QPqtILnQ_1755590064
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so30029255e9.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:54:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755590064; x=1756194864;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C9W9Lxnwsqcb0sJAwIsuZAMV48nhSH9Z6F1jCNOWQGw=;
        b=NEnSx/H/SYwb3l264gf2M8DVnf0NOFmWNOMd6XdOQjRBCA5epa0gYUFsiruISm8mHQ
         2tJo2QRhmo+1ne9+HvK7P7qTXDqyT6nJTzpd8Lj0MKztQNVOHIAANzGx+ZXizmuzvtG5
         gmUDsu6gIe1lIjwTXYUqyxQvKjsI/9YOSnOdmUFswo5ezj9TFpWppj8nuJckMFgqA4L8
         oQq/Nj+Cd+mfxjviAQE/3reGbxZmj15Rko9Le7GK8tMqn0LzfUjMAo/F9ru6/HmhxgsH
         YR7i/N3svJ/lXKdGOJMgI4oVYYaqSSDooF/V7jzd0a10lJA19sKd2M6uQbtPkcEXfFvH
         zpDg==
X-Forwarded-Encrypted: i=1; AJvYcCXDq9OO37z1+eC0VcU+fowB4zNRibPypmXomVdGcvh0DEhLCtlxznff/fXqISFNoZTrcKjl14EeKg==@kvack.org
X-Gm-Message-State: AOJu0Ywb2zya67J4cDE6DKZR+TE68CU7EQtRS0reRy8JaUS0ZlP28mOj
	mrpqA1M5/yVgJnOVUDyr5hudH7nph83O6ZNPkEGIBVYp5fz48br4P2vDg1Oo2oz7z/wHTySWDoK
	lPqULe+LV0nPwLErodwKUo7Pwrb4ZF+21vRV4wCWK7Qwh6k9mUsPh
X-Gm-Gg: ASbGncv02RsLVA3psGsQyX3MU5nNVySdTb9Pg9qnLjtXt9Zgbkk8vqMtoCw92juQJ6H
	BKaShBHqOYnWijLmpCdQhEO+riAwVBS1oV7M5hdS3Rwr8v5cJgQfX3PSpbG/KHMWGDgP8537Hxs
	SUftq+Og0g+KfLbdy4ZhS0N0QSKMGfZwN1xP+89QKyM9ewkC9dwcI/ol1SyoB9viGWjR+dao1Ta
	Mddih5fTOWmzjH4O+2mhbmxK/p+OEr6twkp9kkj4zxXYYTp61ak2iA8eKEhR6wHYSFcBUah89v5
	7QqmXNSrItCIR7WsYA1mzZeORppyPXj4OqyzZNOL/yhT076DQpN/tIwIl2OrwRaptSpTzmsAh8d
	k5jMDv53mviBZZsQbDM81u3mts7/PPN9eRBe/+nVexQgaQaxN59CpOhHEYE/rZEPA/n4=
X-Received: by 2002:a05:6000:2c0e:b0:3b7:76ac:8b9f with SMTP id ffacd0b85a97d-3c14858912fmr1072750f8f.25.1755590064221;
        Tue, 19 Aug 2025 00:54:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG47MQ2FAABjTTxBPmZqsECDlQCU6YLlmvMBefknIf+UtmxQ2Zf3tk6D8BTtfNAIZ8f0BKPFA==
X-Received: by 2002:a05:6000:2c0e:b0:3b7:76ac:8b9f with SMTP id ffacd0b85a97d-3c14858912fmr1072717f8f.25.1755590063759;
        Tue, 19 Aug 2025 00:54:23 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:8700:71be:5385:87b8:5a98? (p200300d82f07870071be538587b85a98.dip0.t-ipconnect.de. [2003:d8:2f07:8700:71be:5385:87b8:5a98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c074d43bc6sm2574711f8f.25.2025.08.19.00.54.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 00:54:23 -0700 (PDT)
Message-ID: <408d7eaa-5aea-4490-9fd0-978c4eb94d32@redhat.com>
Date: Tue, 19 Aug 2025 09:54:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/mm_init: drop deferred_init_maxorder()
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Bill Wendling <morbo@google.com>, Daniel Jordan
 <daniel.m.jordan@oracle.com>, Justin Stitt <justinstitt@google.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Miguel Ojeda <ojeda@kernel.org>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20250818064615.505641-1-rppt@kernel.org>
 <20250818064615.505641-4-rppt@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250818064615.505641-4-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HjzwiP27AQVi3-VO-fhnxIU8bxR1gjiWuMfdA9Xmh8U_1755590064
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 239DE1A0003
X-Stat-Signature: 4knkuz1yrefofb81ii5kk7qijewyo57f
X-Rspam-User: 
X-HE-Tag: 1755590068-210955
X-HE-Meta: U2FsdGVkX19gUYBN9ru8j7ZjKbu32kuDsFsYYPPd1rXQaqKOZSvL/kB5j62SlyKMGs+xj3AQtcc2vh374s23nMA0W5J6w51zJKCpMXW1aUBhe4dQn78JbXs6t+YBZeA8/cMPFM8LoAd7drQP+bd0xn4sWLCeIzzGnydWoFVQcbdCd3xzxXZvym/jtMVN+Rz/cGiAheRBGmrIARyS3n4LLy0MpaiFIES2InSH7W4mTglZWPaTtCMjgjuUgOhqWal6iuaQfb+yCzQdfByhieioJw7pZrtx9J4SoZzeSpFHPyLVxUsjN77p86loRb5LEpFUc/5HjjfWgjRRSn0j5Rm2MD4OCRImKdGUl9dFCl+Zah1JfrFL7tw8HLL1Y8Nzcn3EQ1pnJpfkr3Kl+qv5U7Jk9NiSrGLV/6qccmYexqROrlhD96LBLUYTPZ8bNXxKfa4KT5Q8VSYgQvcz7btqfJQc2mZfVL/Uoqbh5mciAHqRgZouH9mLOoaS3WZ7/svMilO4gqKXP4d7LtlgUvpsK2h75gx/226vaVwIfE21WTjm1N8Z3jkbzZeaJCJwv8q1pfSV8V6NgG4D+fJ8k8dMzh/cEfUHhL9eM+lv5aU03UGqskH3+33iraIT9s9p3081p0SAeadJHOV+45+x87NMak/oFm208hfJMfj9J1ucrxAxFrAAMfbmtRnr2OEVZgIV2oAqwHe4Pm0Hf8DP12EooPZJlMuMLPFouF8fftmNMWHbpf1qJvobs7P4YAy2rMW1rAmDmUYMzQ1E3Ukgvqkj3xw6aIZGFKtIq1IRYTIfFgyPwgsOY4v10I8zZ2FQJ38PSreTNeuxxndXbRzb+uOUB5jQxnlWqrJ+RDlArpCDv+keKPRC+5EKBnqyJzK9n4O3mQ9ZIZj1+2v5bIH6Piqm2M9p1We5fjjDkYEcFnspjtU01W52maiEpx3X4fGo79K4s2xgS4xlR+zsiDCr4uqVrZI
 GaBSv0g3
 ArUV8xjsOdqW5qLpGyxxVLruqjnNDxLiJprXsBH7jDlW4J3KZv37yisvtpn0fKPBElr/EZnYXRm/vZaY7A2LEV5CtW5KmOabKFYw9Mo159H0shGd2tOytVDPFLWFWDLaFsYTF24dx+NZwyRqvkZnGy0kWyiThbnG0qy9c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>   
> -static unsigned long __init
> -deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
> -			   struct zone *zone)
> -{
> -	unsigned long nr_pages = 0;
> -	unsigned long spfn, epfn;
> -	u64 i = 0;
> +		while (spfn < epfn) {
> +			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
> +			unsigned long chunk_end = min(mo_pfn, epfn);
>   
> -	deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, start_pfn);
> +			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
> +			deferred_free_pages(spfn, chunk_end - spfn);


I assume the expectation is that all PFNs in the start_pfn -> end_pfn 
range will go to this zone, correct?

-- 
Cheers

David / dhildenb


