Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28B48CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835AF8E0010; Wed, 24 Sep 2025 06:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D508E0001; Wed, 24 Sep 2025 06:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC6A8E0010; Wed, 24 Sep 2025 06:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 583388E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:06:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA63D43719
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:06:26 +0000 (UTC)
X-FDA: 83923713972.13.D77B3F4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7F456A0002
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:06:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WYWdq8lE;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758708384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3/y8atd4hTEyYwuK0YGES5vA9PwKw0/60PilfyYNWg=;
	b=5th6d2S7n3UW338NgrNWOS6A+TgLaasjyXVTtqR1yfUIXEc3p5iTsBHHp4z41vgGqf1na6
	5uenmJqL8azIcKgd/kSj8Ca7s1BsUYfEsCozfSY9tdp7BbDSYjWCrQPw5zWqlZ30ZEgewc
	SHklCpAcV+v0Kua7yN+ZgfIpKi6Sdek=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WYWdq8lE;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758708384; a=rsa-sha256;
	cv=none;
	b=cQWM+u7pXNxAX7rkDULnhTExhYuVTP3iITj4SQBLtpoqx/UJEpCkTlzY18R0AUmljGT89z
	uUDXGAx5MTNSjoJBhczEuMYI8vkQfrFeBR1cFlrqn0FlG6RFxtQimK7CRbzlC6oB2Gmep3
	NuFkOQO9ZZUVHQZvqfPU8noy6Std4Nw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758708383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z3/y8atd4hTEyYwuK0YGES5vA9PwKw0/60PilfyYNWg=;
	b=WYWdq8lEQm1EAFBU6J8/aXWTR42OlhhN0bn+4mA1Y5cX5+w23gFVl6RUd+8dRZt3lRV1O7
	x/Gn4xvkXh4PlxTVVfYsqS6/7Q/WpzzYO3eiRJgSOEiPU6ZSvgFHlg+Xpz6S984wM3apaI
	g3tY53G5bkkslmPJ72GeIokq619PB0w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-327-rrHpqReYPj-ipQOtVrH7lg-1; Wed, 24 Sep 2025 06:06:22 -0400
X-MC-Unique: rrHpqReYPj-ipQOtVrH7lg-1
X-Mimecast-MFC-AGG-ID: rrHpqReYPj-ipQOtVrH7lg_1758708381
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3f384f10762so1859139f8f.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758708381; x=1759313181;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z3/y8atd4hTEyYwuK0YGES5vA9PwKw0/60PilfyYNWg=;
        b=uNPfn3wgsxKc2bswhHOqjWwOrhFSORgdZvma1q2+VU8sN7cBwsrHSqsviOgyJlPPyt
         M+KV1N2DDSWy3dbUb+fgI3dNnyq/X+rDBuDC164hEUMilfFXscJqtrGelD2kDU9xnZSE
         /9T7yF5S6zgyJs3e+1326c+Z3sSgq2HBvzSZJG1yDYnf9g8jPNA+MtjgkEROLbAeNrKu
         tQcOPu647AyOXwM0+MRSCbyakzy4oU+MyPguGktPGI+TRiVIz8G1M1qHXbUi6Clla7DZ
         idvovPhXOFD2AeL5bZWITI5th3X/jUVoYt1KuiuCsyV1kspHXebrLBC7pYnO9gyAU//g
         g11w==
X-Gm-Message-State: AOJu0YxgwXJ68hEUSRZNe2AZwETrzeAfsMjMFBK8Dijh/QU1Y2KQEYyU
	hs11ZYsPUsOlPZu78tbj2J7J8ZMpbnYz+d3yAzzUNxeqOnask/OSfvl1UYOYNxwW4YCqN5m52Ht
	NXc5CHFQu0vE4N0+IphHA8mFnPhNM+rrjsMAimjuSDu5qo8S2My4n
X-Gm-Gg: ASbGncugjXqmbX9Nl1DnVn1KY2abbVDeGA5fNJlxxmHt5pmX8MSelK8xzQv+uNSHhGB
	VilvUmH638a2DFhA8YJIH/MB2kHvU1OmS2+UNBCZcsd47OMI+ohLZ+vHy1xmM3oknmzi7+ZYZ4j
	JIolDEhLP1LdFvcYUfTNgtd3wxwKtZfYqh+Th+swv3+VKomlwU6DHHQSoDMiF8+w+VJQHtD9TaX
	jLkABEPerbvsRBxP4QMJHtpRlNYbAoTcliVbdMM8onNA8cnTZ64WdYrNHOtgf1EIrfeKu9g6e6M
	YGtn+1b3/51wtI/iekpzRh3M/+E8/4ToAsmiRydVvOnDvmE2bkJpsjEEbFd+XJ+SvMIdL3P7OQv
	73MRz1H+wYPFEnEQ6N3PNNBObT0qqWodzK0bMwqVeNLbsbvsBX3WAbCnJj3F1c03QMQ==
X-Received: by 2002:a5d:4685:0:b0:408:ffd8:2742 with SMTP id ffacd0b85a97d-408ffd827c8mr1972111f8f.33.1758708381352;
        Wed, 24 Sep 2025 03:06:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJzEn1VCVJK19HBbgDZ4se9kCwYv/zC3RhWMG2sPcdOcncOjp/t/dJS7J4v/bUU1Ke6RUumg==
X-Received: by 2002:a5d:4685:0:b0:408:ffd8:2742 with SMTP id ffacd0b85a97d-408ffd827c8mr1972073f8f.33.1758708380816;
        Wed, 24 Sep 2025 03:06:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-403ec628ff7sm7538809f8f.4.2025.09.24.03.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 03:06:20 -0700 (PDT)
Message-ID: <61880ecc-7618-4688-af84-02f31e058aea@redhat.com>
Date: Wed, 24 Sep 2025 12:06:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: always call rmap_walk() on locked folios
To: Lokesh Gidra <lokeshgidra@google.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com,
 jannh@google.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>,
 SeongJae Park <sj@kernel.org>
References: <20250923071019.775806-1-lokeshgidra@google.com>
 <20250923071019.775806-2-lokeshgidra@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250923071019.775806-2-lokeshgidra@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GRyX-GgpSR0iBT5bPy7GItD2dKP5JIRXCf2WUsiA0k8_1758708381
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7F456A0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: jokht5jnxm5rpfia1gngprnty83hr4xo
X-HE-Tag: 1758708384-501059
X-HE-Meta: U2FsdGVkX19qop4SYbq0Qh/QeLStR9yizkRMkpYBc5ezeuuWgg08NqlQThy5LDtizEekJlcjDIucOxg7PnniBmnhleqz69rchu4+xDkd0KvfI9xELuPpd7H/xvh2kmy4sawD5Y9mD0xg3V58GRyi+2blWYry7Bq91Mp/Qh0z25EP8eHaS167YIK4B27MhGIXOLBJTyADmVMJ0pQ87XhW9TIXXrRwMLgJX0h7mCF5XKqOLeFuZtyvstHMMMS+2Oll78/ZZxjakavVd+aKA+vKPmR343grfw506kc241TWgcRLPZQIvnSmpgIKLPGzi01cUB+hLQpgTEb3wmQmucokm7wZERajTWrbwI5wyv/FOyeuXvZZ//ICLR9dvuNvPPJQNJog81ZdLzKFniFTV/iUUBsTUR4oApYsD317ukI0GyKX5DKssKRBTgKkyJSTNeS7UyVEUxA7BLHE+rcOKpgugY7M67VG0Zy7hXxh5iCIyEOe+KhOVRsdIJQqCTpTU+YFH80fKUj1ulLGnvxnugsdOESP0cAte3s/ZpcXKdlLj4yUVlDpQBHV781i5qPOctxDcyfWuOH+cmYoQ6qBypwe/yQeX9v+9WT52rayoeWsWL0RgpfpVE6PfHbho2wyTjhD0kB63rxrl45eAQXAHxfRD4BtbFozNEdGmILO3Yc805TsQqUAO3qQ6Kar7RPPizzeX/weMnnlWfeTfBr4nbL6UjsHO72HHo0OQj1poSki+GcCCaiUs4hq76ZqjNnSzA7RPdEgHhFcJcl2HF3YhaaunbtAxj6tE4N+Y4llfq7wJFmC9xcEdnv2dIrRcu8klzxpnR+fSkPSzaOUsMqr+peKV3pQqrTe5w6zjmUEK8siV/CKikeopljCKLzdpsq2t3edab3HrfZJpVdac3Era2pi+D3bk1AdTw416m32e3YUjEJQFZwvFcfUOQI7h3uoyE2CvQJWqPSy9pMFUjZXdiC
 9XdrmuGo
 y3kCIpirjFXBXbwHw+Ir1Z00SBJ182S8xw/lOQozSMhqfA26B35X03L2opGBZUGZVg/0BSXfEBu00kFz6GLlZNBjgZuZhiV5HmGGq1SSD4stLgqWDILYzzzR6Z/xMUsKuZJ7PYKKkr1w63SHiIzC1n5pC9tEiDFA3SEQ3nj55CxliTAoemLwz78qOjzUi9UQuAMTouYaDaA1nH2ZP6xJeZ11EaKwe1+n384apXmFHEWHBWkjTZ9nU+AUOiPp4SIqenX4gjgpj+1+Uomo9UwCHa6y46refjnRCQ+2Fu2XZ+XwQX84cERek6LfjDVBiJsS8rbkYsWo/dHBAhyb3ttqT7Dp7eCOaPXQoqwA41TME1RfjC9V3zsfZHw+rfdiVDP15IczcnKjlkHjNuZ30XG0g30BEOHkFR+e/vgTooUNnPT+uKfhfJLYrwo7fl/NEGi9W8yqcn6qMTuI1jLdGdZyI5gOaVHemBFVYJba4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 09:10, Lokesh Gidra wrote:
> Guarantee that rmap_walk() is called on locked folios so that threads
> changing folio->mapping and folio->index for non-KSM anon folios can
> serialize on fine-grained folio lock rather than anon_vma lock. Other
> folio types are already always locked before rmap_walk(). With this, we
> are going from 'not necessarily' locking the non-KSM anon folio to
> 'definitely' locking it during rmap walks.
> 
> This patch is in preparation for removing anon_vma write-lock from
> UFFDIO_MOVE.
> 
> With this patch, three functions are now expected to be called with a
> locked folio. To be careful of not missing any case, here is the
> exhaustive list of all their callers.
> 
> 1) rmap_walk() is called from:
> 
> a) folio_referenced()
> b) damon_folio_mkold()
> c) damon_folio_young()
> d) page_idle_clear_pte_refs()
> e) try_to_unmap()
> f) try_to_migrate()
> g) folio_mkclean()
> h) remove_migration_ptes()
> 
> In the above list, first 4 are changed in this patch to try-lock non-KSM
> anon folios, similar to other types of folios. The remaining functions
> in the list already hold folio lock when calling rmap_walk().
> 
> 2) folio_lock_anon_vma_read() is called from following functions:
> 
> a) collect_procs_anon()
> b) page_idle_clear_pte_refs()
> c) damon_folio_mkold()
> d) damon_folio_young()
> e) folio_referenced()
> f) try_to_unmap()
> g) try_to_migrate()
> 
> All the functions in above list, except collect_procs_anon(), are
> covered by the rmap_walk() list above. For collect_procs_anon(), with
> kill_procs_now() changed to take folio lock in this patch ensures that
> all callers of folio_lock_anon_vma_read() now hold the lock.
> 
> 3) folio_get_anon_vma() is called from following functions, all of which
>     already hold the folio lock:
> 
> a) move_pages_huge_pmd()
> b) __folio_split()
> c) move_pages_ptes()
> d) migrate_folio_unmap()
> e) unmap_and_move_huge_page()
> 
> Functionally, this patch doesn't break the logic because rmap walkers
> generally do some other check to see if what is expected to mapped did
> happen so it's fine, or otherwise treat things as best-effort.
> 
> Among the 4 functions changed in this patch, folio_referenced() is the
> only core-mm function, and is also frequently accessed. To assess the
> impact of locking non-KSM anon folios in
> shrink_active_list()->folio_referenced() path, we performed an app cycle
> test on an arm64 android device. During the whole duration of the test
> there were over 140k invocations of shrink_active_list(), out of which
> over 29k had at least one non-KSM anon folio on which folio_referenced()
> was called. In none of these invocations folio_trylock() failed.

Yeah, that's the expectation: it should be a rare event.

> 
> Of course, we now take a lock where we wouldn't previously have. In the
> past it would have had a major impact in causing a CoW write fault to
> copy a page in do_wp_page(), as commit 09854ba94c6a ("mm: do_wp_page()
> simplification") caused a failure to obtain folio lock to result in a
> page copy even if one wasn't necessary.
> 
> However, since commit 6c287605fd56 ("mm: remember exclusively mapped
> anonymous pages with PG_anon_exclusive"), and the introduction of the
> folio anon exclusive flag, this issue is significantly mitigated.
> 
> The only case remaining that we might worry about from this perspective
> is that of read-only folios immediately after fork where the anon
> exclusive bit will not have been set yet.
> 
> We note however in the case of read-only just-forked folios that
> wp_can_reuse_anon_folio() will notice the raised reference count
> established by shrink_active_list() via isolate_lru_folios() and refuse
> to reuse in any case, so this will in fact have no impact - the folio
> lock is ultimately immaterial here.
> 
> All-in-all it appears that there is little opportunity for meaningful
> negative impact from this change.

Yes, that's a good summary now, thanks a bunch!

[...]

>   
>   static ssize_t page_idle_bitmap_read(struct file *file, struct kobject *kobj,
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 0bc7cf8b7359..fd9f18670440 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -489,17 +489,15 @@ void __init anon_vma_init(void)
>    * if there is a mapcount, we can dereference the anon_vma after observing
>    * those.
>    *
> - * NOTE: the caller should normally hold folio lock when calling this.  If
> - * not, the caller needs to double check the anon_vma didn't change after
> - * taking the anon_vma lock for either read or write (UFFDIO_MOVE can modify it
> - * concurrently without folio lock protection). See folio_lock_anon_vma_read()
> - * which has already covered that, and comment above remap_pages().
> + * NOTE: the caller should hold folio lock when calling this.
>    */
>   struct anon_vma *folio_get_anon_vma(const struct folio *folio)
>   {
>   	struct anon_vma *anon_vma = NULL;
>   	unsigned long anon_mapping;
>   
> +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +

As raised in v1, I am not sure about device-private dax folios that are 
anonymous where we could end up here through 
memory_failure_dev_pagemap() and not having the folio locked.

If so we might have to throw in an actual folio lock somewhere on that path.

-- 
Cheers

David / dhildenb


