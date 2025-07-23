Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BECC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2A46B0098; Wed, 23 Jul 2025 06:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A466B009A; Wed, 23 Jul 2025 06:36:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9FE66B009C; Wed, 23 Jul 2025 06:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7C206B0098
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:36:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CFA7131729
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:36:58 +0000 (UTC)
X-FDA: 83695176516.02.BEEED3A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2AB9114000E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:36:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IvHzO6I0;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GC/2LupUE5wLX6ukUG4xRAWyfgxjbwSSK+8wvyo+VGw=;
	b=6zUwKm1Pe5tMiVPcsxcUGkuhzZEzbcHXl2H/Z9M4us8C7sYIDb5NtT1twedv5DIRsJlkw0
	6nB5rAMDk2kpdrgGzY9xjDGNna0Zpm2+kC+O91ZftdILoYrY6SmOtOjkw+MptoF3CPaIJR
	heoWDt1s3jr3ynVcSH3cm4ZFGiDuzm0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IvHzO6I0;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267016; a=rsa-sha256;
	cv=none;
	b=MjdOUFQJHNWzQ/kbiWXpaxW7wJci0p48vZqMKZMmn+rESNTsyPvoWbMmFotsnzXMEgrnpG
	H6s8UzXKTmcMGaIyti1xWovl5lNbohQGp1lq6LpOURfGacqil+PJMF8BKYa8pPOjQkOYzy
	ri2evH9UpB6WGpwgB4MKCrhaAbFCA4g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753267015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GC/2LupUE5wLX6ukUG4xRAWyfgxjbwSSK+8wvyo+VGw=;
	b=IvHzO6I0ryBth2DgumleJ5Tv9eUaqurxz7WpzquxhakfkHlfDkY8incdSoBOPwAZmz2a1Q
	3RiOtuV3R5uPP0T5VbJ41SGk8fBu8FuohFS5SRw1pr15ayf2LpOLElF/PHCx/wbXVuFqu6
	u9tQ4s6KR3HQN3VtnQ1bFtGHzv5eDjU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-7oEZ0AuHP02KOu2upbUPpg-1; Wed, 23 Jul 2025 06:36:54 -0400
X-MC-Unique: 7oEZ0AuHP02KOu2upbUPpg-1
X-Mimecast-MFC-AGG-ID: 7oEZ0AuHP02KOu2upbUPpg_1753267013
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b7691b297aso489458f8f.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:36:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267013; x=1753871813;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GC/2LupUE5wLX6ukUG4xRAWyfgxjbwSSK+8wvyo+VGw=;
        b=A5UBk8lfmUZfjUOm4w/jN/9v+jOU2d9BPIUn6Xg4yprGeteyrg4B3p2UCihIKLOlh2
         7LlHhER3NE8A+lvXvLUMwiYsQKHFIMd6fLQHx692SRiaoMg+/ftFj1KEYPtcdz/dv5AA
         XcRkCDTUOlW/8h+xyfUiWPKSPsyK1J0osH4hP6IKuf5w5fU1LF3qlKBz7zBjXbwKZRdZ
         EwfRnMgLD7ruSyCG33Cvfz2RWsHrXt3ECeqLgQvs42C9+rKx50tbr5BSmwSy53FN+nIE
         sGboFBlVROy2eN8flUMn8HJ2FT1LsOaK1G18dPTYDAlQZ7GTWpyhXTd0Fy88COhJwAjI
         2eNg==
X-Gm-Message-State: AOJu0Yxx+DFNEfapyXaGk3hs+QFuZZ4wWOAXQblcDzfpNMNAYZrKFkcA
	fPqphZ9Dj3LudnTLgZR0wDyQKQEUHc3MgzjBnl79SJmM/d9KbjHrmE4RmEP1ykaA9LzIZrMX8QB
	XTgHAj+vZmY/os89g3Vml2pJwTcvc5KZlNbAKWV1TzpRUqKAhC2c6x5oEPg8dAV0=
X-Gm-Gg: ASbGncsFFlINwfpskPShdmdTwYz5ifrCo8YyMrm1+l8bdETrBtXtBqsGfveGuhy6VN5
	Y+JdZKij/tOCHjssIoJfL4Q/PGZstYBDQtr5D/EvsyjLgFBviLVK2H56AAP5IS1IJBASFPUW0Y5
	yiUaW3EAoBCtp1mmURogfdD6lXzAOwk53XY8RslP/7hFArtmbDCXtkm74+MaA7hzzYhMnqyvSkS
	NHW1XZaNDMiv8XlP7/jB6+q4V4qbkKhBKfqELG2xIJ7p1OtXjV9lZIx0AOytiwyRnX9btSrFepp
	q3SqtUyT/BCHkNrkiqDjRtsiXAF8KJn0p0JiYLGS8aXgWFHMBbSPOw8OlMyLpoOe0AO59/n+94o
	V7bdYB4gkHsemCYdipzu+02+3unfZbq01hnXq9NkE1gjwRswvkn92bmCD+3XWIufGFFg=
X-Received: by 2002:a05:6000:1886:b0:3a5:27ba:479c with SMTP id ffacd0b85a97d-3b768effafdmr2019228f8f.43.1753267012716;
        Wed, 23 Jul 2025 03:36:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqUvpYeVB0LjNVAtGw7wtGt9ho7Oby82qyjHiMQGf36IgI7a2x1v0eqNwKNc2oJ1e6grFOEA==
X-Received: by 2002:a05:6000:1886:b0:3a5:27ba:479c with SMTP id ffacd0b85a97d-3b768effafdmr2019195f8f.43.1753267012191;
        Wed, 23 Jul 2025 03:36:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f00:4000:a438:1541:1da1:723a? (p200300d82f004000a43815411da1723a.dip0.t-ipconnect.de. [2003:d8:2f00:4000:a438:1541:1da1:723a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca4d581sm15775545f8f.64.2025.07.23.03.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 03:36:50 -0700 (PDT)
Message-ID: <cbf19dfd-f1a2-4fec-bee4-137df33098d6@redhat.com>
Date: Wed, 23 Jul 2025 12:36:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] MAINTAINERS: add MM MISC section, add missing files to
 MISC and CORE
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20250723095823.21940-1-lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250723095823.21940-1-lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vCqyRqhuYMR_f9llnqvokpONWbOo8_jb7fy7AmmDYCo_1753267013
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jphjx95qq7ebukuchexmzsu8wccsrw6q
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2AB9114000E
X-Rspam-User: 
X-HE-Tag: 1753267016-667639
X-HE-Meta: U2FsdGVkX1/eD7qSdje20C0wQIrFbmq0Yxx1EmnqotMCRSSQsMXCrJ1g8A5+DaPOba9Wo9tX/2zu1XtjmLiarM9ruMf+SbF0fn4bQzhYIKHAvNQcQjMyOlWjmPBFbNmqnq0nzlCBd1cyVKKRq05Rik/Qt/6601LfGsOfk8Etvoj+CDFGbIEa0EElUeS+JsC02O0FOeF4i9YG1AGk2y75H0fug7dso01Am/+zPgXmboV1CN1m84yppVdDn4Qeb7a1uvlMqpbcA64j/07VK+/SVB1xdwdA1Zm5skJe+vH8669MCy7jUqBl+vwUP3u2vxRXWrILhN1+5kLQS95dp0eSyAYXBnBtj7UooZFWQudo+gX6tUOndKXC3ny9SUYd+z8t5RGqTea1CO/vYaQagYkPCnFbppNHuDENxJuJB7KJlG6czFiQpMRT2wdBucfZp8xNSi7Vy9Mnk8s5nyNMy7AZAF1d1P9aH3I8k8XM4C193qP92PGGRIsyYEfcqG/ToUcKAMYfKilT7LUb0ba9oxQsEyY+81jlw7f3CDqS0ezjJ/LD1ZTGkUn6LOji0V5ppbp091Qec6AyeDJSUnmpz65LRRVPrwUe22Zn6NIw0Td+ahTC5ydT+HfA0zhmnJMhI9+6pxfobUY7Uo4W7psPRUgUt41GjJvje+w7c9Y3BRWgzd8SeAvJK9tYFNQecc5Bd8CM1W6OUMNg9FKxkYS2KzYOHADKYqm+chauJrCa5oI6Tu4IhzupA4QGkksVr+gxXYctl0AjWMXWCTDIz5AhD/kB/AgxJ6i4YPAvpex4G/7iN+gt5C59b/lrILXP3er/uojAZ3E3wclRI3t1goilIOQdIn78PiJCk4S0WncUTjosy7KSvk8E8yEb/HCJIcS30vaL6+MuN024QrN5WEL8d//DIfC3ZCEZv7OfIvyqTJcpi1ICMSXB7czm6wUoWVJb1lz/WpW/9gCjstRPEwL8Umx
 AWYLAGAV
 Z/BgZYe++FdXj+iZo6vPcMpUdztrIIKMrTmIb49rBG8B7J3XuoD/lMir88EJ+yjTnzWOvqRexaichJUt84sxKhtcnFARrjVIgcNZXZqFeugwt2mf8/yJ+RgRM5EqhQxEWfyNUdQ3BTihFLVhuWG4QF8VxWYDedP9/Oy6TmKAgkxKCAJ07koEfw5KIjdSrLMk4TLInnyDlBwEXJnmxNSKn+eAIJlOsk/XqjGFVVjXXXsRO0EYbEFY9+Of+GKZfC9449chMDg6T5DWMGa1ZMW4dacQEj3gLUXzvIISnKzO0YpGIeeGSCcFx0Hrm4J8IgpDaNRMk0KkqXjFQNhQRjXV56tZG45FUSuyEa5Rsa984k0c9NWKUN5wGafXs4o4gpKqNrJZkdja/TDMvF0ijjnMEKo5bcXnaxAxvg3jAz7/mxd/gIFkUgX9rXnZ7utE/PkWJJPLuFmcPVUvfIdYHNkP9GjS1gkhwna85EQFWF9BlGEpuKwqrtDT6eC68fh1LkWSQi/iYww5UAf4QQgn17i8MvQicORqvlpvN55tnaq3zLw9uAfKg+z18ZTgQ2bSBZlRFKXHNGkVRQvMeRn189pPKLBOqurM4tD5CytzPEVywTRWVYFCgVpfvDubIQlqtjR17RnMMoUYHi/C8fiuz/LFKh5xYxSje7fMBGGGGibDEl10ZzTDbY6FOFH1C5R7A8FbllpHadVqXu7fXMXFw7nT8c7I7IZ9pvhzz26EXFqwcuLm9K1+zNlm0MP4Cu0/yllTuYJEYvgZ5T59XZZv4SjQ5XQawH8rdVw4ihOt7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.07.25 11:58, Lorenzo Stoakes wrote:
> Add a MEMORY MANAGEMENT - MISC section to contain files that are not described
> by other sections, moving all but the catch-all mm/ and tools/mm/ from MEMORY
> MANAGEMENT to MEMORY MANAGEMENT - CORE and MEMORY MANAGEMENT - MISC as
> appropriate.

Curious: do we need the catch-all because of untracked files, or because 
of future files?

> 
> In both sections add remaining missing files. At this point, with the other
> recent MAINTAINERS changes, this should now mean that every memory
> management-related file has a section and assigned maintainers/reviewers.
> 
> Finally, we copy across the maintainers/reviewers from MEMORY MANAGEMENT -
> CORE to MEMORY MANAGEMENT - MISC, as it seems the two are sufficiently
> related for this to be sensible.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> 
> v2:
> * Propagate ack (thanks Mike!)
> * Retain MEMORY MANAGEMENT section to contain the global mm/ and tools/mm/
>    directories and remove from MEMORY MANAGEMENT - MISC section, I misunderstood
>    how these catch-alls would work. As reported by Vlastimil.
> * Update cover letter and subject to reflect the above.
> 
> v1:
> https://lore.kernel.org/all/20250722192704.164758-1-lorenzo.stoakes@oracle.com/
> 
> 
>   MAINTAINERS | 68 ++++++++++++++++++++++++++++++++++++++++++-----------
>   1 file changed, 54 insertions(+), 14 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 507a999f1955..5a9d4c57add4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15741,22 +15741,8 @@ S:	Maintained
>   W:	http://www.linux-mm.org
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>   T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
> -F:	Documentation/admin-guide/mm/
> -F:	Documentation/mm/
> -F:	include/linux/gfp.h
> -F:	include/linux/gfp_types.h
> -F:	include/linux/memory_hotplug.h
> -F:	include/linux/memory-tiers.h
> -F:	include/linux/mempolicy.h
> -F:	include/linux/mempool.h
> -F:	include/linux/mmzone.h
> -F:	include/linux/mmu_notifier.h
> -F:	include/linux/pagewalk.h
> -F:	include/trace/events/ksm.h
>   F:	mm/
>   F:	tools/mm/
> -F:	tools/testing/selftests/mm/
> -N:	include/linux/page[-_]*
> 
>   MEMORY MANAGEMENT - CORE
>   M:	Andrew Morton <akpm@linux-foundation.org>
> @@ -15771,18 +15757,32 @@ L:	linux-mm@kvack.org
>   S:	Maintained
>   W:	http://www.linux-mm.org
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	include/linux/gfp.h
> +F:	include/linux/gfp_types.h
>   F:	include/linux/memory.h
>   F:	include/linux/mm.h
>   F:	include/linux/mm_*.h
> +F:	include/linux/mmzone.h
>   F:	include/linux/mmdebug.h
>   F:	include/linux/pagewalk.h
>   F:	kernel/fork.c
>   F:	mm/Kconfig
>   F:	mm/debug.c
> +F:	mm/folio-compat.c
> +F:	mm/highmem.c
>   F:	mm/init-mm.c
> +F:	mm/internal.h
> +F:	mm/maccess.c
>   F:	mm/memory.c
> +F:	mm/mmzone.c
>   F:	mm/pagewalk.c
> +F:	mm/pgtable-generic.c
> +F:	mm/sparse-vmemmap.c
> +F:	mm/sparse.c
>   F:	mm/util.c
> +F:	mm/vmpressure.c
> +F:	mm/vmstat.c
> +N:	include/linux/page[-_]*
> 
>   MEMORY MANAGEMENT - EXECMEM
>   M:	Andrew Morton <akpm@linux-foundation.org>
> @@ -15844,6 +15844,46 @@ F:	mm/mempolicy.c
>   F:	mm/migrate.c
>   F:	mm/migrate_device.c
> 
> +MEMORY MANAGEMENT - MISC
> +M:	Andrew Morton <akpm@linux-foundation.org>
> +M:	David Hildenbrand <david@redhat.com>
> +R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> +R:	Liam R. Howlett <Liam.Howlett@oracle.com>
> +R:	Vlastimil Babka <vbabka@suse.cz>
> +R:	Mike Rapoport <rppt@kernel.org>
> +R:	Suren Baghdasaryan <surenb@google.com>
> +R:	Michal Hocko <mhocko@suse.com>
> +L:	linux-mm@kvack.org
> +S:	Maintained
> +W:	http://www.linux-mm.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	Documentation/admin-guide/mm/
> +F:	Documentation/mm/
> +F:	include/linux/memory-tiers.h
> +F:	include/linux/mempolicy.h

That is already under "MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION"

> +F:	include/linux/mempool.h
> +F:	include/linux/memremap.h

That will be MEMORY_HOTPLUG, right?

> +F:	include/linux/mmu_notifier.h
> +F:	include/trace/events/ksm.h

This is already in the KSM section.

> +F:	mm/backing-dev.c
> +F:	mm/cma.c
> +F:	mm/cma_debug.c
> +F:	mm/cma_sysfs.c
> +F:	mm/dmapool.c
> +F:	mm/dmapool_test.c
> +F:	mm/early_ioremap.c
> +F:	mm/fadvise.c
> +F:	mm/io-mapping.c
> +F:	mm/ioremap.c
> +F:	mm/mapping_dirty_helpers.c
> +F:	mm/memory-tiers.c
> +F:	mm/mmu_notifier.c
> +F:	mm/page_idle.c
> +F:	mm/pgalloc-track.h
> +F:	mm/process_vm_access.c
> +F:	mm/ptdump.c
> +F:	tools/testing/selftests/mm/

Kind-of a catch-all as well.


-- 
Cheers,

David / dhildenb


