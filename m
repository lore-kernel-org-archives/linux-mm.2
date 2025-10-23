Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D3AACCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA1FF8E000B; Thu, 23 Oct 2025 03:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79828E0002; Thu, 23 Oct 2025 03:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98F408E000B; Thu, 23 Oct 2025 03:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8938E8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:22:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3920A1295E0
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:22:23 +0000 (UTC)
X-FDA: 84028535766.14.1ADC6BE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8F49A1C0003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:22:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PmVuvN+2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761204140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FqBgEpalzjOOdWWQ6f5KvVtDhqwHZed5PGSC57AnXJE=;
	b=sgFJqTuqtteNiK283wseaSyN7Hafpy2p+uM1hmYKfuuS1fbjegyL74OGBle3Lxj08klXsk
	0RjSfJ4A4Cj/UBWP+UvR96nzIVZs7eGizlO1KmkDr7oFzCzULLwA6qUI2W6hZNWsHmAqQq
	cg1iyYIVFD4O1QKopmwGwqvQWdknPWU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PmVuvN+2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761204141; a=rsa-sha256;
	cv=none;
	b=2/RGYlMzjXu0tu0cEdoygvisqGT9j0O1GLPkPpD0pBxxIMTeAMdOmdrTWBO1yjVxCVeZrv
	rBk5+wZEp2lHlRTfLPlDzt8xJcY8J60RuA7EX2bPtlnXhC5qO1DK2uMLG6Uc6Y8jQ3u8f8
	4UgvWuCBex6Otl9Qh2Yvan49KRxLHwk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761204139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FqBgEpalzjOOdWWQ6f5KvVtDhqwHZed5PGSC57AnXJE=;
	b=PmVuvN+2bET4VwtbL/KbRdgzVhHsHOpEzUfSw3Pfwg0kam5QOJ+hyfe32g5IBOgrWQEnif
	NHM/BfN2rtXlFlbXTKXy57cGj8HVx2CYg/JvMP1kGwKd9uvd6/KkXO+dCvQgQe++0YdoaJ
	fTbj6DRgp7U3LSONTEPZ0vBKJHrooUg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-BDya0J5-NB6n3saPA0_M5Q-1; Thu, 23 Oct 2025 03:22:17 -0400
X-MC-Unique: BDya0J5-NB6n3saPA0_M5Q-1
X-Mimecast-MFC-AGG-ID: BDya0J5-NB6n3saPA0_M5Q_1761204136
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47108163eeaso1667805e9.3
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 00:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761204136; x=1761808936;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FqBgEpalzjOOdWWQ6f5KvVtDhqwHZed5PGSC57AnXJE=;
        b=G9lv4AB7YN7oEV0YC1vSqv+6z70TvN/5Jzbmoa2eq1sRXtPUD4W7ezsQy4cMcAu9Hn
         Ak1DgTGU7N4jIemTVwSMCxWfV28b2t2z01D5S102wOkikD/ggc8ZN5dzlpfdy3yzBh6p
         /InP96EybVUye+ERsoO98tPvYtl3h3HBbb47aYDnxlQ7N3E9ccfoG0tqR/yABqlwFYLz
         sxyIB6I/30evm6Lb5fw3GLt5UukSqmFbx7vf+GMinjTWStT8nIDteee5Us7vHnKzW8W/
         upeMEUqq/pBcEWE5TgAsnkllJ/RGijoVbzYZuRW75HPbel60SzX/6fdCdbDoEVplElba
         v2qQ==
X-Forwarded-Encrypted: i=1; AJvYcCWk4XqiyZcYLcjijZfIvhP/8ckJNeOmg2xg4KAo0FRH69vEQ9tJD57KpPsbYsVfSTxIZ20X+Y2EUw==@kvack.org
X-Gm-Message-State: AOJu0YxIfjGteX+DgvqlICbEm4rQEEf7pTZw6GAc3Q4qgkqsgaqZetAZ
	Ui0bIOLb00zM5/eD7EiqKg8O7bV058cdtDjrBbi33owQuMNXd6E2A1VEAwOEjpovHgxK3pHr3Vq
	Avn1PCS0oG0w0aTI7MWR6tvCDWBseiDHkDrDA94XptLa1k85iofCA
X-Gm-Gg: ASbGncurCJr3Zkayd380j4PMVui6rtGv6RWYE44FQOO8kMzOx63uKvDkxfAeOfeYtm7
	jZgPbd/hTlJT2eG6qJ9E0HWlFRqbgQQECym1wBoFSg5GSc8qLoSydUCzAyIXe4w1rs2KzIKCYCC
	KogEIgI1vvbdaXhCmQK8C+AhKT+hfIuYye+hBNzho81HzBMovlHtens8sFmx3g4eEcmHjyMxWYe
	+9J22OJE90mtND81ogX2MeADdJWWVUTIYKKidbLk0rGh6WmZDF+fPjwdV0tTAKaaiDID29Paghg
	/+fpmgk0jUj3u0WirKF9BOvIowvSQIyAgK0zhcBOOEsk5Yna4X7rrK7uWZYhbONPUBkr/N4G8Yv
	LUA6RrXKav0rPipxpH8rkcHDEsnwC+M0=
X-Received: by 2002:a05:600c:871a:b0:471:14f5:124f with SMTP id 5b1f17b1804b1-471179258f3mr168688265e9.35.1761204136308;
        Thu, 23 Oct 2025 00:22:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE637JmCoQPr2mlXiBFwoMgjjEzyrxQoOiysCD1cn9SQtGjECI7sz5kgwkfulxwgT/NzBgR/w==
X-Received: by 2002:a05:600c:871a:b0:471:14f5:124f with SMTP id 5b1f17b1804b1-471179258f3mr168687935e9.35.1761204135909;
        Thu, 23 Oct 2025 00:22:15 -0700 (PDT)
Received: from [192.168.3.141] (p57a1af76.dip0.t-ipconnect.de. [87.161.175.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475caf2f142sm22098575e9.15.2025.10.23.00.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 00:22:15 -0700 (PDT)
Message-ID: <68673e95-7996-4463-9bee-45ed54387fdc@redhat.com>
Date: Thu, 23 Oct 2025 09:22:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/huge_memory: preserve PG_has_hwpoisoned if a folio
 is split to >0 order
To: Zi Yan <ziy@nvidia.com>, linmiaohe@huawei.com, jane.chu@oracle.com
Cc: kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org,
 nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20251023030521.473097-1-ziy@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251023030521.473097-1-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E-1PvsGxV8Yoc6xjbMYPpUWrJGUZCY7eti8Rtd9fLRk_1761204136
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F49A1C0003
X-Rspamd-Server: rspam03
X-Stat-Signature: gwu81hrkyjcyknsto3y514qh8h354jzg
X-HE-Tag: 1761204140-536579
X-HE-Meta: U2FsdGVkX18N0KxWIcAT54YSko2G+1wcLYw9gJp2pIR1PZPUcPBTDo3r49mLTJ0o2yXpcW1yoQZP+OTYDpoKkO1gsYZ7p7UET+aCCoYHKcjlOLfkLuG7KdNah4pDU/j4kZ6mZ0UjJFPrb6hCYw36zmfc/3ODfLiVXErK/c2JcueR1aqbrw4IX7NdYLw1S4oBJyVISKr0Z1emoKO0JpPJ6wTzRfl47+Qh0djjmUs7RZt7uc99Q5pwguu4XBK5mP8aYm5JhBJjM/X5DR4jF/BFh0i2yzKLtAwgR4pMzEu91z3j9enXN3yty7RafrfcAGDXrS8Lgitth+uJA+epwP5ur8YTqZIUAbqrj7M3K0sJoYK+yZe+dBfz1zJAafXCcKOKzW8xrDJox4eX3FjZRRTpoxA16CPbZlybz3zRuGaLcV3dQl6Vyr/VZDSRmqMZutZ0WRniLGQb1TqCgkISQGmIiDtTspHR7Yby0laTB5IyuwUgmiK3EBEFuDljwx5w65tBVgpYbknoghrLP57aZcR+Pf9IeY5K/RiWexZUvnYbj4rAOnNExz78jTwVmDUY/6HB5LZX7lUDgD0o4Bn7ZjoTuFWQRX5gm7rhpm6MN1UET8ycrs5Nl07uZ7PYc35J9a+eTtUSZFHCsJtapNcOffkUB9lH0q2317IGI7AyH8+I//yhunkrBQ2Uj1en8jGXq70R476xwGT7NkrAXY0pFQ6eoIBnBfCdgdzeQgSzYUxKuKMy8kDQfC34ZUJumJ/VNZeVDaAz7zlt91WL+EgbeJbtepG16W3IHTOMNbD1NzcV2I0nvTuNJbCjj10iahJgudYZIxWOQ7qn4Ig/gW3QKzZmQqTPTjTJiy8PPIS8D+kzx1Wu0Lff5UQCkMiH5IifnrUPhlBKmyKwhS4zfr4xxS7kv2bPs3WZtMr4ziLLB1pc6m3FVzHERqoiLcMjBqnigs6GabpOvxR6vMc+w7RT7EK
 obHtLdKL
 nEI/p3azZfHegTAhM3rwPdmNwvgYzFBjdv4Sw8RTdbK+DOkDCqk6M/OmuBDB+R9i0Y4zvKCgqsa7nLIkPrJcs19ZtzOikYlngsj6bKV0rht2+Nian2QIEUGpRqeE78kk+xs8frql8tflAc9jQ2Ka4E0Xpa9XrEZmCJfVqrs3aysxP6ohoJY3Bo5TzKqiNgPkIrTKj9kS+4Ak7AjsaZqznf+g2NBRD3V39oCZGakbYcghs2GLHhnI8FJpHH6yG4vEB6Zw0gTkwPJJ+qNDUGHlzvl5Kpvp0p4VPlcskANt1v32MWpqd2uD2iHOfk1fTiLm37rH9tACQgcGdfxrj9g7wsgMJCzt9M+zCf4cvq3cwWjq3wluC7enQeFuhlTzszujm4W0zdAXe+cUu46hphFibZzj+78dT2SNdsQh71q4JjsVxJ0NcUksBJveiP+zl17ZNi/XQf+daTv/HDFZHbRdNbJLSw8A8MxBd8/8jK/ZcM5ZZYedr20h6H6k14dsKtDOEhotii8Ure4Jm9FtisoNRrkNf3D8+QlWA4QPExFEQXXzN6dzsjgagA5BYiRq4WH3ij7UoxelCVOhbtcl9RzajeUubyfjf/37GVsIQTbGJjkdo03Ewz7IP2LGKtRCKj/RDH4WfkFptXspaZ18E2EbjgFldlk/kXDfFrIuOeF9TI1j8h4y05wsGa+M1qElMwRJKfTMaJQ2QJvF7SwhYH53StPNCEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 05:05, Zi Yan wrote:
> folio split clears PG_has_hwpoisoned, but the flag should be preserved in
> after-split folios containing pages with PG_hwpoisoned flag if the folio is
> split to >0 order folios. Scan all pages in a to-be-split folio to
> determine which after-split folios need the flag.
> 
> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
> avoid the scan and set it on all after-split folios, but resulting false
> positive has undesirable negative impact. To remove false positive, caller
> of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() needs to
> do the scan. That might be causing a hassle for current and future callers
> and more costly than doing the scan in the split code. More details are
> discussed in [1].
> 
> This issue can be exposed via:
> 1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;
> 2. truncating part of a has_hwpoisoned folio in
>     truncate_inode_partial_folio().
> 
> And later accesses to a hwpoisoned page could be possible due to the
> missing has_hwpoisoned folio flag. This will lead to MCE errors.
> 
> Link: https://lore.kernel.org/all/CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com/ [1]
> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Thanks!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


