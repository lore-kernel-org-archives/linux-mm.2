Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCB36CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 07:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 231488E0021; Tue, 30 Sep 2025 03:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208D18E0002; Tue, 30 Sep 2025 03:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7888E0021; Tue, 30 Sep 2025 03:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F16FA8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:45:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5AFD59E96
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:45:51 +0000 (UTC)
X-FDA: 83945132502.16.99CC46A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4FCD08000C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:45:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eAp3HhXT;
	spf=pass (imf30.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759218349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vceb7qiM17XunDAIdaIla5/4nlWZXJrRMpO0J7bj8yo=;
	b=ts1lq95A170EXPPcz62zQ+mMfG8S7Zn5notIyMVWna7/EJN29vGb4Obu5PR0EvH3sRnGwr
	mtMHBw7htky5LQHA6IaGiwRORSGJG2fK2mEkW6yYl7jtfwco/JJGIpeJuWx9zfQiSSMjLC
	hyDU9mFKY0rvsSRkqcHIxtz4XMOhuYY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759218349; a=rsa-sha256;
	cv=none;
	b=j8tFy1K/L8IaMgmXPnOpSdye+NyZmON4S9qLArLuSJJZ/hQtZ5U6DYhG4C4QodVKikOVxh
	8XKgYxWsOau9jdW76KTz8ZuW7m85jvxWOLPi1VwF45OWaXuIfqmIN38L+baZEnEgQDxNf3
	WL2wsDhjTxGBsfOxasMk6/xBvFKXBEg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eAp3HhXT;
	spf=pass (imf30.hostedemail.com: domain of toke@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=toke@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759218348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vceb7qiM17XunDAIdaIla5/4nlWZXJrRMpO0J7bj8yo=;
	b=eAp3HhXTHNvRI8TJWDonDQbjqZO4qjLjzQP9xe2DtjZbha4/q5mtmY6ugkqkLnu6jcZBuv
	R6kPStGmvtvFaArN+cS5soNHM9iHvpg2W1H8M0hCG89zXgeli1t1tDd4USmhbphQ3RmvbV
	pRWmlkPy89LOjhdLxVkigvqLN7ZHcMw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-54eiRDntMI-SsgXoOUV81g-1; Tue, 30 Sep 2025 03:45:46 -0400
X-MC-Unique: 54eiRDntMI-SsgXoOUV81g-1
X-Mimecast-MFC-AGG-ID: 54eiRDntMI-SsgXoOUV81g_1759218345
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b4544f46392so33807266b.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 00:45:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759218345; x=1759823145;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vceb7qiM17XunDAIdaIla5/4nlWZXJrRMpO0J7bj8yo=;
        b=I36W+cFwyadZNRj2lfd94fJtTSJstv1mMLlxm8D8zXurqvakzvXT7mHyVGbzmKkURt
         Nb1jIjpv0TvzlFwI0X1KZaWnG+3R40V5N3rtZO//Cxg9el6Q8Lei1eHLM95CFn7mMZST
         bn1w6OAvpl0uJ0e9ox/1+0w5ojx70mgJ8bmzEJQuYhm9rMg6R7nl5m/7zZ4g99Ib3/7K
         oHIm9SwVIN/EyXD2jWfm2433T0qnPo8D8RKSDj4K5QlYixkLwY3YpkgsJPiHuSbZsBQb
         tWLIiZs1am2sYoX4CD76D0YT1MkBZny+sGXQtG6cBAnHOcLzSm7XwVGDvOOB18zSOd0T
         1X9A==
X-Forwarded-Encrypted: i=1; AJvYcCVnH4Q5GPQuKQHVgdzVC3qS3ipLpYbw/iRQ9UEAYAOAJHYd0HTsKdrC2qimQzO72sda5+bHXZQXMA==@kvack.org
X-Gm-Message-State: AOJu0Yx60ofMRhmpIUWNYY/fjghvno268PiG26v9DC2TIBCb1c9Gf/c1
	NDjsJklK1q1N2gmHqM2FuFuJdc46sWZW/w2cHStSIwh01BcAkA5d1zpPvO797NXPtsPrciZ609s
	4fRNjw+0b2FWKyQgtp6O6cSS6VYCqmAL8ixhLfJuG6mz07Cw9vMgG
X-Gm-Gg: ASbGnctlf3JTCaSkiUl1X6/x2915lpRckRzwWRnH9CY5a6Lv4BQAhiPtonLQFQ+WLcw
	ZZxIyMqgaUdKAXRGlH3CpMbWIXSM/i5zD+mfdxI0fJ3KIKE4h1FRoLoivwK4ddl6L1AQFoTNRXB
	VUzkYj3qVGCPE8a6STMXgFXFaoNPikPhgAzr30UJKkZKLE8KvlgJv4j/eBTA6/JEPt4cEtfdQu3
	sjubqKyf/+6EIT6p9Vyf3rt5ybcjnS+Ub2ZNy/bMWlj7YMptDnBUBNfTkbA4w9h4J7/p6qKxCYq
	ZRLZD1Ts4741jKPWcH4blcZPJXLzp/rIzRTHLIMh/EHbDyurjHZuQ+5sIKicpM2WDdwhwemW
X-Received: by 2002:a17:907:d8b:b0:b2e:6b3b:fbe7 with SMTP id a640c23a62f3a-b34b218e997mr2161351166b.0.1759218344868;
        Tue, 30 Sep 2025 00:45:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFgyijEcuMJ8a8fkflLc/115VPCF1zLIQJ0BUnXCH1k3T3ny0OxuymgESptWICrjF2yX14gA==
X-Received: by 2002:a17:907:d8b:b0:b2e:6b3b:fbe7 with SMTP id a640c23a62f3a-b34b218e997mr2161348166b.0.1759218344430;
        Tue, 30 Sep 2025 00:45:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.borgediget.toke.dk. [2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3f945d90adsm307755966b.87.2025.09.30.00.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 00:45:43 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id A91A527777D; Tue, 30 Sep 2025 09:45:42 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Mina Almasry <almasrymina@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, Jakub Kicinski
 <kuba@kernel.org>, Helge Deller <deller@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-mm@kvack.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH net] page_pool: Fix PP_MAGIC_MASK to avoid crashing on
 some 32-bit arches
In-Reply-To: <CAHS8izMsRq4tfx8603R3HLKPYGqEsLqvPH8qfENFnzeB5Ja8AA@mail.gmail.com>
References: <20250926113841.376461-1-toke@redhat.com>
 <CAHS8izMsRq4tfx8603R3HLKPYGqEsLqvPH8qfENFnzeB5Ja8AA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Tue, 30 Sep 2025 09:45:42 +0200
Message-ID: <873484o02h.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qiB9u2KLL6_nAfbCzEDrc7VONWbemZdX2vpz54PDvQs_1759218345
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kxgk6pdojxzkuzzuhy1cttp9thbifxr1
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FCD08000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1759218349-969539
X-HE-Meta: U2FsdGVkX1+GCzNA8G9CmEkaf8x59cFIplcUkypagdvmp3FpFqpeCgf1gxEcHxqRIQFhVOR20srde5y+5Wq1PNtNsMNwd0TM2EZ0wPyYdeetfNV/+uUFqHMmObKHyIRAU7wvq2NcaPlt3DLqi/STuTj2uX/vNnBMa7L/ZXTSOZ1etGl7ImGro0IFHU5nX/3sOdDAFu+xO7Si7AW+hUY7MJbyVxVw5aCkuNI5byyW5XqyBbgkOZ1q3XoWvUcWxS1JzJnQEt8lJt4MrJoFXQHKkVism4n88V/xFfbyt4HH4Uy5p2d9DNvWujdkI8g2EaiS+26XrKYYN0z7239Kf4pNHlk7z5kil8UePAqwarVfUvZ1gdsceDa0/Yu9HlqdxD4y5vsmTGxtLuFYOS03u3mY7Fkt9EbuxMPbjaAowlc/hrTjmtGO6ibCUfw0iqtqMcrSgB/576S6ZI0LfwcorHg6ICPdbQpK2MOrusaK52iWMz4innAEitZYLy2xTFOtW7VpT/p3+0wZRL1pD8nRG+KQfEODVppmdxTfh6skBKq8NMNqFzSSK7Aspun8Vh8oqOuz5zCP1Om5yPq5ovEHtIaVbmR4r7GW+vqHfWEH44q8cgulx3aMvmvVSWpJVHrl/USypQoP/5/n+fNT/G+7MhCMr09r6g/asHG27ftl41Z0yWVJgd6AGKLKidiXBKZbCww5hcTJEutm25lvxBfx1hMZBYZFLJwRX+C2edyhs/2IZdswSNEW68KiZApj5pDUVcKcnHgAhSntvXszJS79/yVn+GnFfmGtiHU+gm2q2hIajgFFE2iHFZ16jWw/zFS1t/YFl6TgTRaFbrLw/7dNQLrzYncYbb5WBEp9dCufHlIa26D1yvD9vPGwiAwVFtplVI5YWezAzVY6ZSmzzxyfzq/icfKWPZHsuZso6GuVXV18mbcsOPiiWjRGiheyNnkOEW6WLUrJotCxAIqyKGi+hH8
 1hyNGTVI
 05h7ms/KhJw9JljsBICUf8/iGVWMffi0E7qs4UQyIPj2aJWiRfWvrccegp/GptSrpz3Zh6lKyYX/cKYNBpT4+ZCk6qPyC8raVfy1GucXdaBYQLe10EAEiImJ2nxr/Jf7mUKoJ4JdEtXhNkbn3aCudzYutkrhytPCCwSvu+LYMWZoLrJJf4zlpsLEoGL94ljyLotN6utfXxrUE5asPQyGKMQAx+yi77ekxobuNqe+q3HDQONQl/Qc7dlfSMgCvQb+VlHaN4ICyY5VWOZpM7Cfx0nPo+xxVbocXwBbuholyLK+wDzxA2OrhM6WTOtsa3G3hccKQAXUbRu8Q1haYCupmB7y+zxUVYQJjv9cIQN6JbmT109SA6LVvJhHLnRN4AhJG6ztC5ka2syQKcHmegWJOAbRlnyyeo4a+8+Q1YqgONXBkkC+dWFN0ys6i1XmPu6jOGxgVdfHEz1fo1hKr0OHgDpH0GxUL4v+MW78u0RqhGk5TUr8gJUkth0ql0bNLCUIuld2twUiO2gfNvajTLztJ7KnQRDe3uMD85zqL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mina Almasry <almasrymina@google.com> writes:

> On Fri, Sep 26, 2025 at 4:40=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote:
>>
>> Helge reported that the introduction of PP_MAGIC_MASK let to crashes on
>> boot on his 32-bit parisc machine. The cause of this is the mask is set
>> too wide, so the page_pool_page_is_pp() incurs false positives which
>> crashes the machine.
>>
>> Just disabling the check in page_pool_is_pp() will lead to the page_pool
>> code itself malfunctioning; so instead of doing this, this patch changes
>> the define for PP_DMA_INDEX_BITS to avoid mistaking arbitrary kernel
>> pointers for page_pool-tagged pages.
>>
>> The fix relies on the kernel pointers that alias with the pp_magic field
>> always being above PAGE_OFFSET. With this assumption, we can use the
>> lowest bit of the value of PAGE_OFFSET as the upper bound of the
>> PP_DMA_INDEX_MASK, which should avoid the false positives.
>>
>> Because we cannot rely on PAGE_OFFSET always being a compile-time
>> constant, nor on it always being >0, we fall back to disabling the
>> dma_index storage when there are no bits available. This leaves us in
>> the situation we were in before the patch in the Fixes tag, but only on
>> a subset of architecture configurations. This seems to be the best we
>> can do until the transition to page types in complete for page_pool
>> pages.
>>
>> Link: https://lore.kernel.org/all/aMNJMFa5fDalFmtn@p100/
>> Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them w=
hen destroying the pool")
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>> Sorry for the delay on getting this out. I have only compile-tested it,
>> since I don't have any hardware that triggers the original bug. Helge, I=
'm
>> hoping you can take it for a spin?
>>
>>  include/linux/mm.h   | 18 +++++------
>>  net/core/page_pool.c | 76 ++++++++++++++++++++++++++++++--------------
>>  2 files changed, 62 insertions(+), 32 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 1ae97a0b8ec7..28541cb40f69 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -4159,14 +4159,13 @@ int arch_lock_shadow_stack_status(struct task_st=
ruct *t, unsigned long status);
>>   * since this value becomes part of PP_SIGNATURE; meaning we can just u=
se the
>>   * space between the PP_SIGNATURE value (without POISON_POINTER_DELTA),=
 and the
>>   * lowest bits of POISON_POINTER_DELTA. On arches where POISON_POINTER_=
DELTA is
>> - * 0, we make sure that we leave the two topmost bits empty, as that gu=
arantees
>> - * we won't mistake a valid kernel pointer for a value we set, regardle=
ss of the
>> - * VMSPLIT setting.
>> + * 0, we use the lowest bit of PAGE_OFFSET as the boundary if that valu=
e is
>> + * known at compile-time.
>>   *
>> - * Altogether, this means that the number of bits available is constrai=
ned by
>> - * the size of an unsigned long (at the upper end, subtracting two bits=
 per the
>> - * above), and the definition of PP_SIGNATURE (with or without
>> - * POISON_POINTER_DELTA).
>> + * If the value of PAGE_OFFSET is not known at compile time, or if it i=
s too
>> + * small to leave some bits available above PP_SIGNATURE, we define the=
 number
>> + * of bits to be 0, which turns off the DMA index tracking altogether (=
see
>> + * page_pool_register_dma_index()).
>>   */
>>  #define PP_DMA_INDEX_SHIFT (1 + __fls(PP_SIGNATURE - POISON_POINTER_DEL=
TA))
>>  #if POISON_POINTER_DELTA > 0
>> @@ -4175,8 +4174,9 @@ int arch_lock_shadow_stack_status(struct task_stru=
ct *t, unsigned long status);
>>   */
>>  #define PP_DMA_INDEX_BITS MIN(32, __ffs(POISON_POINTER_DELTA) - PP_DMA_=
INDEX_SHIFT)
>>  #else
>> -/* Always leave out the topmost two; see above. */
>> -#define PP_DMA_INDEX_BITS MIN(32, BITS_PER_LONG - PP_DMA_INDEX_SHIFT - =
2)
>> +/* Constrain to the lowest bit of PAGE_OFFSET if known; see above. */
>> +#define PP_DMA_INDEX_BITS ((__builtin_constant_p(PAGE_OFFSET) && PAGE_O=
FFSET > PP_SIGNATURE) ? \
>> +                             MIN(32, __ffs(PAGE_OFFSET) - PP_DMA_INDEX_=
SHIFT) : 0)
>
> Do you have to watch out for an underflow of __ffs(PAGE_OFFSET) -
> PP_DMA_INDEX_SHIFT (at which point we'll presumably use 32 here
> instead of the expected 0)? Or is that guaranteed to be positive for
> some reason I'm not immediately grasping.

That's what the 'PAGE_OFFSET > PP_SIGNATURE' in the ternary operator is
for. I'm assuming that PAGE_OFFSET is always a "round" number (e.g.,
0xc0000000), in which case that condition should be sufficient, no?

-Toke


