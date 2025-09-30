Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 122D4CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 09:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B6FD8E0003; Tue, 30 Sep 2025 05:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666C38E0002; Tue, 30 Sep 2025 05:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52F1E8E0003; Tue, 30 Sep 2025 05:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2248E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:23:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8192F160676
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:23:28 +0000 (UTC)
X-FDA: 83945378496.24.81EEEB1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D1BFC0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 09:23:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BQXtqijk;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759224206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVTRRja56NKyfYmtJWa6t4niAYLHaXsYHEoVzq9agdk=;
	b=E01wrogPDlI9JL6iK2H2K8gWRXZx1DASBe70iLKC2nDZpU7Xl56fopMxtQ4jpl8kbpj8GU
	FOMf7slEQ3Q8DVaOXbY77dhSCf4mzcIW6SdchnYNpSInceWBpsWBWSEGTNxc6kt4gu8RAD
	xxZA5tZBGMtAgJPCwiFnUprde5xEDsI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BQXtqijk;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759224206; a=rsa-sha256;
	cv=none;
	b=MrXu8daJza/f3Y+HGo24923d2go5cJvG4S+SSOEEq/LbiXli0dSLE6EXg4NHU8FAXYhXGs
	A48cNdURfEcMdpXgukEdzFTNcncpiPdrqdpagswaZXk9gYol0rEjQXAnuE4CpJpk5tXYYj
	dw94MbN5i93wknWi1RzPYoUjtj8q1Ac=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759224205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TVTRRja56NKyfYmtJWa6t4niAYLHaXsYHEoVzq9agdk=;
	b=BQXtqijkPj378dABWJmeBpc4v+BtH0Oiu4evEAXeYMI6R2Fky3nRL5tvgFIt/ymV+N0LJb
	PpaoFMHHUO6C+4VWIaBqsPW9lmiAMcoaaJW4geSca87kW5swb1GopeunDCZa2Vd3v1mYBk
	j9JSnO9+D1BCOvZkF7kOOeVipwCjsFA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-QGhGmM79M0-KKlPs36rY4A-1; Tue, 30 Sep 2025 05:23:24 -0400
X-MC-Unique: QGhGmM79M0-KKlPs36rY4A-1
X-Mimecast-MFC-AGG-ID: QGhGmM79M0-KKlPs36rY4A_1759224203
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-401dbafbcfaso3882907f8f.1
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:23:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759224203; x=1759829003;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TVTRRja56NKyfYmtJWa6t4niAYLHaXsYHEoVzq9agdk=;
        b=EyawZuQaSjY/Riw9TruNoXukSEB5VI2zJCBxwQ0TRqvNUrsiYaIDlsrpNUZcd4+JNr
         TaFBMxXoCi1kN0SC5ol/Ij0B8xNDR7dcBNi/lxyB6JUM6WJSaggj4t8fM06a+p+Mk/u4
         jqQ9MHybQef8XVq6lsRljkF7MUmCUvJhnbLB0s4wx9+/TDp0680kfBofvWLBY8vP9frW
         qIjIzitl9Zwd2xgi9i/Nu6GPpXSxfgq6VEtQ9IIHsBgypcl7yI+xVHgXDX+WcNygqAd4
         9tItTdMLb5U++TB6XVdAuyASeW3AUU2CpwoLqGaGiSmXT7cfXzIN97KYyiMaLDhfnYvj
         SYbw==
X-Forwarded-Encrypted: i=1; AJvYcCUCxxA1+7+4/JncY/0i+PjWRh/egoQAj57wy+cFgtv7l4jr2/aAjV0Neh062+pzY+bQaMM2va7vcw==@kvack.org
X-Gm-Message-State: AOJu0YxENtTXDxSD9A7CQrGGGuaMvDCSodYcK1tBC8uJxVjlwR1z78ar
	Fh4VYuVvhCfjCV2RtMHeNMdwpjeyjdVDJFAWwuhusyF60tnos+MmS0BEibSlu9x3ROHDzeYG7b0
	MpNZ9vduqLXyq2JfJtPxOUV9btQhl4pwDMmH5h1eKEBUthFovylv8
X-Gm-Gg: ASbGncuv6Re9eO+RK5TInOa4Ts/05R81gXeCoi5D1m1NQ879BS2ZlUS4CTdx8+vU8cL
	4nJvlsgfCrChruqoQcxiiyGFLZarSCPLT7GygDQS+Fv+h9xtavaVnTW/DIj9T91Rr+vmj0h6SHk
	GXKsXHwlHwa44H8DBfhbHmNQliA0w5BOauvoUocN77slVopgPkWh4AqQUjfJgonpgBUE8RqtgAu
	kUCy/mipi8QPEL/zzkHKXmInEef8tTolSxTWqeshho4OP6I975np9eDb9pZISHD0jt9JwEZWkBw
	7/jEU7QteME5pGlre+psNT4vV6OMPRbpL7t+3lkPLQYeZlOYpDuB9x9epmFMOe9mVCkeXG4rxxb
	v+9UMOew1
X-Received: by 2002:a5d:5f45:0:b0:3ea:a496:9ba8 with SMTP id ffacd0b85a97d-40e480ca410mr18003942f8f.29.1759224202715;
        Tue, 30 Sep 2025 02:23:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8kxKym0XL78KwB0qdyY+0naOZrFtENcl3ZdbfIV0WoqTUk+yahydILwO1rCp3XZnwKFT+lw==
X-Received: by 2002:a5d:5f45:0:b0:3ea:a496:9ba8 with SMTP id ffacd0b85a97d-40e480ca410mr18003916f8f.29.1759224202270;
        Tue, 30 Sep 2025 02:23:22 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5603381sm23402858f8f.31.2025.09.30.02.23.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 02:23:21 -0700 (PDT)
Message-ID: <0a60d99b-fa3b-482b-8171-ac63dcdf3168@redhat.com>
Date: Tue, 30 Sep 2025 11:23:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/4] mm: Apply vm_uffd_ops API to core mm
To: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Axel Rasmussen <axelrasmussen@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, James Houghton <jthoughton@google.com>,
 Nikita Kalyazin <kalyazin@amazon.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrea Arcangeli <aarcange@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
 Suren Baghdasaryan <surenb@google.com>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-5-peterx@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250926211650.525109-5-peterx@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oN3SnbdC0u3FOiMxDQxDI6jvoUOesfms3AOP0ODcjqk_1759224203
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1D1BFC0002
X-Rspamd-Server: rspam05
X-Stat-Signature: nybwmbkhqmarh9hs6nm8yy79o1ufsmuu
X-Rspam-User: 
X-HE-Tag: 1759224205-508967
X-HE-Meta: U2FsdGVkX1+PGnoQycPqezWVs5HqbQXmc8XyxtYxgFF5wn2wG70qKLzS4QOpJED2jtEXKQX0ToZaCJojV8psC5srhwRU/Z8UC8nGqpQfnjLu5jv1zGUORyCCrXlpoT7XS3NUBXQyWjLmfauGkPQ/gvLxOCmEKtv/7ED6ELFcl9NnhINPhtpVDgdx4yhDYs0zJx/YcpgEgQ8vbCegzazBTyo5w6eG5wgwSCq4ZSH97q1WuIlTxOfQTAg0aor/PDOkguhZXAoArGsYC6ku7XxDM4HSkBzinkfrrD3vUFl8J1WnSIXzqJZoiZIFrijeXwIpEnoGTACM7XoRehfq22K07FjDrmBUMJwl45G4sXqt2W4mtyUSZgA10D1i7lfPZpuJ7Zq47tZsmhuBvm8sE585/cjKrStCeVBvtmVXwXzUhtyJ3kk9+9q9kfFLZrNJTKJi4B2juhnkzGlN9kP9XUTOcBTUcd3w90uj010ETCclP1O9SGtrOuencasKAlVALHFkwac6hfh4Sh1yJoc/DkTyBdhF+xVOzQOM6C+QYPZOtEpicbnt4HyynDWkBdr3H43UJo+xAzBpHWGVCJ5HhSfGDGyFa/5KE25QKNsQJXdWBwCx1T9XmVbTogFl1w8T3saeJSQhsI7Rp1ffoH7idWbTdP9HrzFfKBVsBPF+hBKDEaAwrnEmwcpaa4oHjGe9jA0bQ51sJLlu0V+AIjQZMIF2XQhfe/M8hqovMamkelPcvspyMpuivc6VmG68osXOU9cSAxNipRayzoPQ3b4uwaKJaTXC6BRGI9gUBd3X4p1+ZvaSczeC5/9XB19eKTlCONRO4EGWGY8raiXNJYFguXFiLtVJGQah5bnTCoIyzAsH+6EYJ8IwA15jW0B5sUAFDkNo32ttU0ix1Z8VgGh5mCDZuXUYLYXaXIjid7ub1Jw4m4ziE3gqBuBtuJW5SkTdolMEOR6LwSwGBoGdz4IBZDW
 wL7YJ1wJ
 Rp8GMP8BD4PT0HtIG0nTWOpbb+1y1jFO3l9G+C6Ru6wa8aEmMjCiKUd7N6emweGU6P7OR7J8EAKJEgoTkBG91cH3pgzW6jiLzxMDVbmeN08yXaBVjoi5eaXpGy+RgggahXmzivKJ5+9rh81iteO5jrd+Pi+ZPeh60uuXvpeEEIsVpG7XqD5hEmCWxNFSk1LaOe9Fcqh/10jrHupeRDaSexN404VoTLydK0SrJ/VIGX4nekN00gifwXQU6ncFqX9huT5pB7SvCo4O62hEcpMmp8nlTKLHOjL6vOfsCWHBKFAyt7vEGZjCBFWKEq2pRWM1yKbpLWnpoXWETxDMMwXhBo+Pv2/THhfGHIvtcZEn6C0+2X/HgbiVSqHNJTrjT82PPWDQRhMLS68knmTlHm3HecylSO4BVxPKjqjilb240Q+cd/vBJI1sEKUbI3UPfp/gJgmk4itS1oRoWAz5RqMvT3Gq3XxCABGEMFL4JquUOAY2S2KcCKrxI+XqszCPvZb4pEQtQ4i2dE0miCxb4fUAt7GiJT0v3+DeNW9ER7g0pwuQ9XZHyhdzSulFJMS4kk/o8lh1W
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.09.25 23:16, Peter Xu wrote:
> Move userfaultfd core to use new vm_uffd_ops API. After this change file
> systems that implement vm_operations_struct can start using new API for
> userfaultfd operations.
> 
> When at it, moving vma_can_userfault() into mm/userfaultfd.c instead,
> because it's getting too big.  It's only used in slow paths so it shouldn't
> be an issue.  Move the pte marker check before wp_async, which might be
> more intuitive because wp_async depends on pte markers.  That shouldn't
> cause any functional change though because only one check would take effect
> depending on whether pte marker was selected in config.
> 
> This will also remove quite some hard-coded checks for either shmem or
> hugetlbfs.  Now all the old checks should still work but with vm_uffd_ops.
> 
> Note that anonymous memory will still need to be processed separately
> because it doesn't have vm_ops at all.
> 
> Reviewed-by: James Houghton <jthoughton@google.com>
> Acked-by: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

[...]

> +++ b/mm/userfaultfd.c
> @@ -20,6 +20,43 @@
>   #include "internal.h"
>   #include "swap.h"
>   
> +bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
> +		       bool wp_async)
> +{
> +	unsigned long supported;
> +
> +	if (vma->vm_flags & VM_DROPPABLE)
> +		return false;
> +
> +	vm_flags &= __VM_UFFD_FLAGS;
> +
> +#ifndef CONFIG_PTE_MARKER_UFFD_WP

While at it, you can turn that into an
!IS_ENABLED(CONFIG_PTE_MARKER_UFFD_WP) to avoid the ifdef.

> +	/*
> +	 * If user requested uffd-wp but not enabled pte markers for
> +	 * uffd-wp, then any file system (like shmem or hugetlbfs) are not
> +	 * supported but only anonymous.
> +	 */
> +	if ((vm_flags & VM_UFFD_WP) && !vma_is_anonymous(vma))
> +		return false;
> +#endif
> +	/*
> +	 * If wp async enabled, and WP is the only mode enabled, allow any
> +	 * memory type.
> +	 */
> +	if (wp_async && (vm_flags == VM_UFFD_WP))
> +		return true;


> +
> +	if (vma_is_anonymous(vma))
> +		/* Anonymous has no page cache, MINOR not supported */
> +		supported = VM_UFFD_MISSING | VM_UFFD_WP;
> +	else if (vma_get_uffd_ops(vma))
> +		supported = vma_get_uffd_ops(vma)->uffd_features;
> +	else
> +		return false;

To avoid the hidde return here, I think you can just do

	supported = 0;


Or even cleaner, just do

unsigned long supported = 0
...
if (vma_is_anonymous(vma))
	supported = ...
else if (vma_get_uffd_ops(vma))
	supported = ...
return ...

> +
> +	return !(vm_flags & (~supported));

I think this can just be:

	return !(vm_flags & ~supported);


-- 
Cheers

David / dhildenb


