Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087C7CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 08:16:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F59D8E000B; Sat, 16 Aug 2025 04:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7306B01F2; Sat, 16 Aug 2025 04:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D578E000B; Sat, 16 Aug 2025 04:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 53A4A6B01B3
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:16:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCED616038F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:16:08 +0000 (UTC)
X-FDA: 83781912816.08.7D3F5B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8DC0F1C000D
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:16:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bjrC1gPV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755332166; a=rsa-sha256;
	cv=none;
	b=kh/FzrkN+7hc/h84Cb9jP78i2fW7u3rY6IThOqYfPKE23gRd8oDaAjF8YR+pQHagP4IjnM
	LsZGpFqYJZjooo+FBynBaqd6vYvW1/mA0ffiFxXKUDEq/oJx0sSBWkQtjV7s7YdInxfnUx
	B33qPGl9jHrPpgbxaEFV23I8HUNmsCo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bjrC1gPV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755332166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ixPgA/yl6vc1N1EOYUywRtyrJmPMeh0Q/AJGU5hM31I=;
	b=mx++eR+yJPe7OINVsJA4jTM71cySnC3i2p4Ajr9UPnq0ghmi+K6YmnFeLwitlGUgw4UpEP
	NMOmU7gPU5R79ecursZGkOjMJesWG76DUUZtEMh2yxuqck/1eZ9OWblSQVfyjMu25vJlyZ
	uDV8MQUdE/XqqXPHPt/7xAzMokpttR0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755332165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ixPgA/yl6vc1N1EOYUywRtyrJmPMeh0Q/AJGU5hM31I=;
	b=bjrC1gPVDSwmwQpMCqliTpsx0zzcMa/ElITQhytxjNpTMRPUtqZfbxqTloBQgHKTDJHSig
	e32n+FeDb0E6RNd62/cj9LkUSsZxsunPj1NCF9vIfFQZQzUfE+I3gdfdfDHnwOzZea2i/o
	iq9mdjNCLdbyGLSNYNAZ7h3gU/4+tgM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-pa63ZibWMR6BGrBXdUCjKQ-1; Sat, 16 Aug 2025 04:16:03 -0400
X-MC-Unique: pa63ZibWMR6BGrBXdUCjKQ-1
X-Mimecast-MFC-AGG-ID: pa63ZibWMR6BGrBXdUCjKQ_1755332162
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0ccb6cso10800795e9.3
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:16:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755332162; x=1755936962;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ixPgA/yl6vc1N1EOYUywRtyrJmPMeh0Q/AJGU5hM31I=;
        b=W/ieQ0ViGcUqfmcHlQPGYSzPFlHRkrdWinb8JnM2KG6FLyvhAw+6UIKhy4Pr30uBrh
         jmV8zzxkG9uEW1m5nJfaG1ucU5sgDtXhZf02aCG50hLtOgSrBpgw0OvuxpQknHI1tOsY
         0Jemb4DQEmBXA/euVdsh4bXJO2TgtSYtONF0GbfeS8TaMDZgZxbYtoiz6cgoZgYScPrc
         hBnhi54PsSJBYbfNiRT80mZ6yg7NhGx5oLdyWS98sYk/sHU77RToBEy+AFA6Mhnjr9zH
         4wsXDR/v5kCxl7NmEub9nsVn6s2EOFRTzdzKeB212EQEuBbWNcIq2iWqxPy/jHGTbr2t
         mO5g==
X-Gm-Message-State: AOJu0YwLQjpy4s+98ZLsqSUUZATXWqivuMJ3CYaeCVfnqkoq8ZB85O3D
	4sHFMuZijSCm6Vxx2Xqk7wnOyTww3zTS60nFIY2AyPsjMV2yBtZsAU5NrETuSaZ9Hil0nmNrp9Y
	4f8U56N8GrKMUCUM/ZIBoIdBQzVdZEjGF5JzXiMFJdI5aicfyXsb5
X-Gm-Gg: ASbGnctPsXIG89wBqYs/A3MvSUQvJ4z6U6BwE74++zQCxrNaxPLHLoe9yJOQ/SQ2GhX
	h8Z5PwSu1WSMgeqBUtOoSd/uw6bnRF2xfk78P75Tl3shV+YJxfrmPOXrezKpL4XjObWcz8bCGtD
	leqbZafSU69BnWELlk3O17lwkyvQJC+vgBbPLyxSMliNqqHtfS5VSIB+HirMnz3mjS5TT9NCN+f
	JNNOWdNCNJaxaPYK0i/XeQ/tPR0MjURjVsDMjL4H0o7G28C/5KYyp0P38ghalT81gUkC+Dz1TF7
	s0AdTURz1ka5qHviXlLkU9DVVz+r97yyTm9HQKRkR4GqnAjwz/X+/walHcx6HrbrD6cw1X9tT2k
	rWtq9FoHHjfrEHgtRScIurTIwvAgmdtZY3KynA9keJfgyhkB7DEvmouQ7686KRicXrIA=
X-Received: by 2002:a05:600c:a43:b0:459:db69:56bd with SMTP id 5b1f17b1804b1-45a21839e02mr35650765e9.20.1755332162227;
        Sat, 16 Aug 2025 01:16:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFC3tYNHjWj0KMeKalzdh/MjaeikwufS6vOtijOjsl7Nwlxk/mLPaTTfDxnVXlSUFEAcUfeOA==
X-Received: by 2002:a05:600c:a43:b0:459:db69:56bd with SMTP id 5b1f17b1804b1-45a21839e02mr35650575e9.20.1755332161730;
        Sat, 16 Aug 2025 01:16:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:c700:d8ae:41bf:492a:9e4c? (p200300d82f23c700d8ae41bf492a9e4c.dip0.t-ipconnect.de. [2003:d8:2f23:c700:d8ae:41bf:492a:9e4c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a22210ab4sm47375495e9.3.2025.08.16.01.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 01:16:01 -0700 (PDT)
Message-ID: <92b16e68-0083-48aa-b281-5c235fd91bfe@redhat.com>
Date: Sat, 16 Aug 2025 10:15:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
To: Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>
References: <20250815101858.24352-1-will@kernel.org>
 <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PcTXuyu1z_lJfeWpwrF9abLNx0TZAisTv5VRopqnzsA_1755332162
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8DC0F1C000D
X-Stat-Signature: 4rsyrgr93p8gtpb68wczxh9388wdj86k
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755332166-713514
X-HE-Meta: U2FsdGVkX1+Zie0POPOc21a7cxL/2BoaQXy3zNe3DLjmz4xxaCszjYz+dRQPQ15st4e0Sqh/JBX66q5FM8KOMwf8GpqTjiGKkW0KTA+nbJHq0DbWgJk4iFz+fDFIJBRycA7ltwvbuhsEJJfZyzSNu4NUYdzU/IPWvfFcVYbgkayDWe6CPlsaVxjIdut5jr7QGi86t3mn/YenCsTYZigBzclz5IhTRBjHvk4cjcgzYU+5ezu/irPDi2RpSO65UFIg8oSdIKOzy3nTdTZ3UsIePmIhDUlgRiAlh/0kYZoH09BJuhB0f7+IFox96/816a5GNslCM0aIrYNj7u0GeCf52xTWESqJquK3S1olE6bsOeEk+1WHDOpQg8me/PLDyAsy5rh5O6AoapE6+EEFUWmou36LCmGZXOQlxIc36uqduhKx433TxNOdW+0n+ap1wHIC8xfziGS/EVQkh6rY1oX8vbKLqbUAMNxp0ivvnIkmGzCmVAI50BqVDzjghNIKo34ylCjwl6dUbJkx//dxpzuTg3fBjVRECyPeMhRfBJG7HQ+lMd+oS3CjXNPHxM+Jw+i7D3T7ENVnUNyV9Pngnpv4avqbMpCHmA+/qPX0XqKvaOI1NVyVvCh3TiZO7QYSrtA83WKsmr4gdUAuAno9mCtWKF5UA43gcaSVxfeQWK4/g8E91YiXufFmN4g8yJ6ZBAbf7eYYPjmZpr8RtpejJ0Pi0DVPIeHCpBwekdcxSagMuTX4wuYN9WidlNt9pIUfFehtFv9bvCB8Yeme+YKPE53rNU+Y/L7ZR2zteunQX5EGF3FrV4h4Cfjz2TCi02X8D/RNdhariAqXJqbrLbEreI2sqsX9k+tmwZXv6UTLrj4W2qGWqOZllIODW1o+nSDb8q9zWrOj69hMnuHHqHAft7aD4EK+JaeoAjFRedSkiXlnLXvC3d3uYMmdn3zC1VQuXlsmcfJbYyGK0RGTc1DPpH6
 qgL9YROc
 ntzhRMyfZmtFZ+QKQSPvyNgneHdwqIWyrX8opKGXo4OlTK351qv9ZUX8+mtOaiEnwVny4kMVcSUgQwbcm1Iq4eLv1rWTOzLy46lBtYqf8avzTfEf+WeuQZ1RAWpiIR+U7sifXDZNMYYgc2gut7tj6iwkC9MpvVJtf8qR7yH+ynMZbUTjfw81UmwuInG9TF7W1nJNb+IAe4UZgVyjKTZ41YEOuAEJFBw6Mj0e81O5qyP6V7IB8nXPn+o5nzF2ct9Xmg+MYnD/H9QcZwB/Hv9NZLRGpjHl6hiRlrC0jYn2AzNkFaTn/Log4ATN3DDVEUi+L4IfGn7ogpR0ta4T8l7EytO1cgeAkiv6uUItIr4v7QzxWCjSMgMIu/+9zr4DnJpp5k0miRbO8KFyVKDE8RboAKl4DZzwqkFI9/VJ6WIJ4ycxao5T1FHt37Eo4TQgPXThR06Eyr5dSTbmhCoo3ocNFxEE+nY22s9AjRlDmrowrZP/FbLeHl3HHkL+0cgH5DrkfmFCpOJ2HrZ86tWc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.08.25 06:14, Hugh Dickins wrote:
> On Fri, 15 Aug 2025, Will Deacon wrote:
> 
>> When taking a longterm GUP pin via pin_user_pages(),
>> __gup_longterm_locked() tries to migrate target folios that should not
>> be longterm pinned, for example because they reside in a CMA region or
>> movable zone. This is done by first pinning all of the target folios
>> anyway, collecting all of the longterm-unpinnable target folios into a
>> list, dropping the pins that were just taken and finally handing the
>> list off to migrate_pages() for the actual migration.
>>
>> It is critically important that no unexpected references are held on the
>> folios being migrated, otherwise the migration will fail and
>> pin_user_pages() will return -ENOMEM to its caller. Unfortunately, it is
>> relatively easy to observe migration failures when running pKVM (which
>> uses pin_user_pages() on crosvm's virtual address space to resolve
>> stage-2 page faults from the guest) on a 6.15-based Pixel 6 device and
>> this results in the VM terminating prematurely.
>>
>> In the failure case, 'crosvm' has called mlock(MLOCK_ONFAULT) on its
>> mapping of guest memory prior to the pinning. Subsequently, when
>> pin_user_pages() walks the page-table, the relevant 'pte' is not
>> present and so the faulting logic allocates a new folio, mlocks it
>> with mlock_folio() and maps it in the page-table.
>>
>> Since commit 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page()
>> batch by pagevec"), mlock/munlock operations on a folio (formerly page),
>> are deferred. For example, mlock_folio() takes an additional reference
>> on the target folio before placing it into a per-cpu 'folio_batch' for
>> later processing by mlock_folio_batch(), which drops the refcount once
>> the operation is complete. Processing of the batches is coupled with
>> the LRU batch logic and can be forcefully drained with
>> lru_add_drain_all() but as long as a folio remains unprocessed on the
>> batch, its refcount will be elevated.
>>
>> This deferred batching therefore interacts poorly with the pKVM pinning
>> scenario as we can find ourselves in a situation where the migration
>> code fails to migrate a folio due to the elevated refcount from the
>> pending mlock operation.
> 
> Thanks for the very full description, Will, that helped me a lot
> (I know very little of the GUP pinning end).
> 
> But one thing would help me to understand better: are the areas being
> pinned anonymous or shmem or file memory (or COWed shmem or file)?
> 
>  From "the faulting logic allocates a new folio" I first assumed
> anonymous, but later came to think "mlocks it with mlock_folio()"
> implies they are shmem or file folios (which, yes, can also be
> allocated by fault).
> 
> IIRC anonymous and COW faults would go the mlock_new_folio() way,
> where the folio goes on to the mlock folio batch without having yet
> reached LRU: those should be dealt with by the existing
> !folio_test_lru() check.

Very right. Because I don't remember easily running into that in 
wp_can_reuse_anon_folio(), where we also drain the lru if we spot a !lru 
folio.

Having to enlighten all such code to check for

	if (!folio_test_lru(folio) || folio_test_mlocked(folio))

is a bit suboptimal, but we could add a helper for that. (we might end 
up draining for actually mlocked folios though :( )


We recently changed in 33dfe9204f29 ("mm/gup: clear the LRU flag of a 
page before adding to LRU batch") that a folio can really only be once 
in an LRU batch.

So if we spot !folio_test_lru(folio) there might be at most one 
reference from LRU batches.


So naturally I wonder if we could somehow make it work that a folio is 
either on the ordinary LRU batch or on the mlock batch, but not on both. 
And that the folio LRU flag would be sufficient to check.

That would mean that we would clear the LRU flag when adding a folio to 
the mlock batch. But not sure how feasible that is (e.g., folio already 
isolated).

-- 
Cheers

David / dhildenb


