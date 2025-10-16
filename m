Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A084CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EBC58E002D; Thu, 16 Oct 2025 16:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C398E0002; Thu, 16 Oct 2025 16:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864198E002D; Thu, 16 Oct 2025 16:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71C808E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:18:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FC9E140427
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:18:28 +0000 (UTC)
X-FDA: 84005089896.11.8A6262C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 90BDD180010
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:18:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NRTwG47w;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760645905; a=rsa-sha256;
	cv=none;
	b=Y0QJC8aZrX6ASzI1UbL3qgFJQVWcImvO1yyiE0f+5C1osA7je9frxn1GHG27LDQTYL9GHX
	IOvqVbCwM/TjpXuHhDHEIkm9cfgXozLrb0oF3FF4ee0rC9LnphOui5L7boiwk03AuyFDA4
	/hLIvLMQnW59GBSAH6MHpMQtrUGLBGg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NRTwG47w;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760645905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afe8X+RdgeqgARYQCjHPw9pHXBS1Z29SmpYHHHH9X+c=;
	b=g9kkEfA8DHPYSRZGcscoYJPXe9y96AmwqnX/CCvVqMJQcMdbzJrYYm6+5Ry+kgXrY6lSEe
	I78YhNs/OVzkqohegPTs7bCBtEm7DtwlNEdLS0pSmfQV7NFvj5+us/vlD1isItZE+eVLIM
	OGgbGRwqCcTr2h/10R0lII2aBrfiBNs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760645904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=afe8X+RdgeqgARYQCjHPw9pHXBS1Z29SmpYHHHH9X+c=;
	b=NRTwG47wlHKBP4kThwQuJSzkILQSkFBPQAhxwP/vHXGd21+enBoUNdnSR3lKhcOUFD3seT
	KPBZxRogotp7hYLMfmMAj3a4p5SQixosg1j5GXy54YKYb08NDaGoiN37BcDqMnwh2VZXAG
	9DsVXwPHz7itjDV5WkIihd7S3AyciZU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-6efSYefeNUaXMPX6U8az5g-1; Thu, 16 Oct 2025 16:18:23 -0400
X-MC-Unique: 6efSYefeNUaXMPX6U8az5g-1
X-Mimecast-MFC-AGG-ID: 6efSYefeNUaXMPX6U8az5g_1760645902
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f4fbdf144dso662200f8f.2
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:18:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760645901; x=1761250701;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=afe8X+RdgeqgARYQCjHPw9pHXBS1Z29SmpYHHHH9X+c=;
        b=gaeoDgA2lMtDfKH8j8F+S6MyPQ2iQDKdQVCc8xoRD64JnIzYbcUkK1zN1Rb/wqufZf
         mXYEpoxzUJu58b8lA1OWU+xeCkuA9ng+aLbXN6iHI5aYskAwhBZ9SZ8uuB78o4Bq4LJ2
         HORRghj7vVq8KPke8oAqZBUzTtfIcFyibculjLiOP65OsSLPa2FVNQtjV/jHK9OXFlZd
         oOiW1SqXYalLNvuRu7F4CfF4FrBpgDJx2dgDCTN9vYO6eyakFhQ9CuDP70l8fslRnC85
         8AjqwQwFvvHUJrUJnUfxpewNCz3J3eGRXUj3OBft2xBXLoqSac6NMT9SuQFjnpl3QQef
         C/qw==
X-Forwarded-Encrypted: i=1; AJvYcCUKmjwCU2adxVN5Kj4GlO5UMJjGdKS04dlHBukGPGkZP3HAPYaGI4foVA7YgsD5d+QMZDzc6YU0MQ==@kvack.org
X-Gm-Message-State: AOJu0Yy7eWFgeai/tPL2yvgIli6AHFEuONO+/iU/nYwf1HmEL9MOroMt
	SxnJWDXn+REbH/ErfpAlXLWXtPL8FOkRONaAPDd4yBNLr8vzvXpBuV7VimvhJFW9Xfsrg1OTnzJ
	K6RKlDrlW6vDxRlTBetxhuPGCf51zqa45HzibU8yyQZ7ho+RNM91K
X-Gm-Gg: ASbGncvqNAikBN2CCrVnAN9jdR3ERjlsQtGLMAAMD993/3khJm7Qxaw6ZrK0E9xevzJ
	0KX4xSZZgPtFsq6HG038Wj3+THZUCltmyUinzZsJZ49p9YE+O+h5m0SA/nM0rG7iBfdIMxmBg6y
	1Mysetngg5ngtCzdjiHCc3UT0RuNu66U9o9LetPYinUaHH7BE8chQYT1SKgSd1rSWcDxQsDahr3
	7etPn8LNly+It2A2fykbtYktzddLPgcrFOcttf4mzEZtDlg6nwbGrFDqNpWWh0eCc3KOgapEGho
	8wQMrTs4QV9rwISv+OgEftGlIVCdNysWm6cYebil5+1ViXiO9zo8XggdFaq+yW/lQKpjlNV1kf+
	fqD4uocI8QpoCJgXcuxAofmgZxI/DI1zKfsfTlT+JuIuiHvf6Ke+A3MoI67+19fURZhS/R9dX54
	2AgW/uIkNBRbbOTQccT8Fb2LGhE2w=
X-Received: by 2002:a05:6000:1446:b0:40b:c42e:fe39 with SMTP id ffacd0b85a97d-42704d963b3mr929430f8f.40.1760645901559;
        Thu, 16 Oct 2025 13:18:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpwmWox5fF2XM1ZxFCQsZe5apuhIUYpTVdIfchO1P6JXmo7Qz5WHjERWLjEtPjWHqU4GfxOA==
X-Received: by 2002:a05:6000:1446:b0:40b:c42e:fe39 with SMTP id ffacd0b85a97d-42704d963b3mr929404f8f.40.1760645901019;
        Thu, 16 Oct 2025 13:18:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5cfe69sm37683358f8f.32.2025.10.16.13.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 13:18:20 -0700 (PDT)
Message-ID: <91dbea57-d5b0-49b7-8920-3a2d252c46b0@redhat.com>
Date: Thu, 16 Oct 2025 22:18:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH RESEND 1/3] mm: memory_failure: Fix MF_DELAYED
 handling on truncation during failure
To: Lisa Wang <wyihan@google.com>, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, akpm@linux-foundation.org, pbonzini@redhat.com,
 shuah@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com,
 vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com,
 tabba@google.com, dave.hansen@linux.intel.com
References: <cover.1760551864.git.wyihan@google.com>
 <57ed0bcbcfcec6fda89d60727467d7bd621c95ab.1760551864.git.wyihan@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <57ed0bcbcfcec6fda89d60727467d7bd621c95ab.1760551864.git.wyihan@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OpEmuOt1jLTeK8-Rs_Vfk31U0w8JueLY8ZoUIiijjPQ_1760645902
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ksa6ucofntr47pwudekha7jsoxmk9gke
X-Rspamd-Queue-Id: 90BDD180010
X-Rspamd-Server: rspam09
X-HE-Tag: 1760645905-167534
X-HE-Meta: U2FsdGVkX1+JMM2/C9Wv0wG67XTqttm6iRLyzpRzq/dpUv25I/WA88mU/gUeO30qpff2kTsVFB1bk2wrumgImDrjB7OFbYkhtZvqcsG/HPmRwNrrQ4iNUounxEfyBa+XariQ+n3nip1CAG9edicp1gRpKYq1wXcGIy7+9JX2uhCQ364NW3evkmirTYaCYB4p2N6MgWarZ9JSxL9Eg7iuJFcvVDSEsisukWKsD3m8/f42aK+1KL8hy2UW4mkd12QuxvyJdKdTbDMS6w1xa0Z1/nKYgrr/oieAyXFGoqjShla2mI7HK5db/eFElaDAzFBTf3wKJ05OrRLZtOr5owQ2/W51jZWnE1Gwph6ggDYKnI8JIq+a3AMURRwqWLaJUPoJaRMfNMVIg4J9bIrArHDrkc+qvvtdY4uPJ9LzxvS6MwWm5tfVW5EmZPKBbXrbc8GjCM8hCQHW4AHwWKNIWGY0lKcj0ESJZRBqXaIhPaOI5qU9Zn3gCZo6VC4KXagGYuzyBCylDZuElFQ89GpaqdIXO3Gq7Ut68FEj+COpPftgogPJm1qcyKj/bIvGkzwyrmS/VTuNiYfIOZLCRqZdDhtbX9AHStK8zldTZKfNYoDjRgqGreHSuLZMfQHgSedcaZyIUy+enScoQARyQPAQc8IOxk9RM/ky37oftwu+5osbXQoFnwM7eMeLJLd1iR5mq0HD3LyBAvLcdboPP32eZINs3TZ/LI3g6d6PMXpkgIx0S76ptS6B2CFb4YXaLFK9QaCnZhHPzMI2lVl/QuwPpsb2StCFg/8+PRD3jf/YuNAXHZPLG2HaXVICIh6nNHsLTKFhlXNieZ2DmW/ItHszMTPtO+U5xtye42/UuKSY62W4ZIxs7lYGjtM9rluAzheOaXIv0XDUWIyQwIRD+6uqglBWQDuoAzPzJ/MCHYWOtqc366HLT1FvQyiRbyPyIZMfEYExI3xEqe/RWVZhD8qhBXK
 oODAToVe
 kmD0TMn7rh7ljTygirF/GAA5RxCDbBuBJBX1422sttKiixS720PYQeYP6x+dkcwBPFNGP4v6XZR/ztiLnBy5fh22+j4FCkjKUeEh/RwYJd5UugyVh+P9ZXT9al92bMjBLjNyivqSrSl+Odzm5pYrbJmF4zk9zFmxsR7PYzhr4rE1cqCSgzwf79R3ex4fwuJL4W8iCZRyTdEjwiBN6Ln8ukoL1gWsFQOmqgzs2MyrckJw2RiXRP7QQUw+m6HGAUmsKwTQYmQ5jyjZcrsFv6BWb5D4Go3VmkG1xtidm6ajr2rGUYQtWmvOUHtZyDL/gdgimOp18EZMYJsRUYBUnBYeCJa0sYbp7wOxtk0i18D3es5gE6wvNK3jvNG5VXNPrgByTrZXPjYF95hiNlAw6PfnlIzogE3TEJhlITRq/6zsdU4/6rTCN88bYLdJPrauojog7yWrwfqKVJ2NVwlypJiQY0jZVJC4GjsNljoNizIpfjUHTTmGhWu/GumrJI12yN3DcC90kOx3WW1QlNOXfE9AzO18MRqh8e5h2Z38CTPc8meGrG3yMEHxieo4M+wEE1OTk0O8o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 20:58, Lisa Wang wrote:
> The .error_remove_folio a_ops is used by different filesystems to handle
> folio truncation upon discovery of a memory failure in the memory
> associated with the given folio.
> 
> Currently, MF_DELAYED is treated as an error, causing "Failed to punch
> page" to be written to the console. MF_DELAYED is then relayed to the
> caller of truncat_error_folio() as MF_FAILED. This further causes
> memory_failure() to return -EBUSY, which then always causes a SIGBUS.
> 
> This is also implies that regardless of whether the thread's memory
> corruption kill policy is PR_MCE_KILL_EARLY or PR_MCE_KILL_LATE, a
> memory failure within guest_memfd memory will always cause a SIGBUS.
> 
> Update truncate_error_folio() to return MF_DELAYED to the caller if the
> .error_remove_folio() callback reports MF_DELAYED.
> 
> Generalize the comment: MF_DELAYED means memory failure was handled and
> some other part of memory failure will be handled later (e.g. a next
> access will result in the process being killed). Specifically for
> guest_memfd, a next access by the guest will result in an error returned
> to the userspace VMM.
> 
> With delayed handling, the filemap continues to hold refcounts on the
> folio. Hence, take that into account when checking for extra refcounts
> in me_pagecache_clean(). This is aligned with the implementation in
> me_swapcache_dirty(), where, if a folio is still in the swap cache,
> extra_pins is set to true.
> 
> Signed-off-by: Lisa Wang <wyihan@google.com>
> ---
>   mm/memory-failure.c | 24 +++++++++++++++---------
>   1 file changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index df6ee59527dd..77f665c16a73 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -922,9 +922,11 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
>    * by the m-f() handler immediately.
>    *
>    * MF_DELAYED - The m-f() handler marks the page as PG_hwpoisoned'ed.
> - * The page is unmapped, and is removed from the LRU or file mapping.
> - * An attempt to access the page again will trigger page fault and the
> - * PF handler will kill the process.
> + * It means memory_failure was handled (e.g. removed from file mapping or the
> + * LRU) and some other part of memory failure will be handled later (e.g. a
> + * next access will result in the process being killed). Specifically for
> + * guest_memfd, a next access by the guest will result in an error returned to
> + * the userspace VMM.
>    *
>    * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoisoned'ed.
>    * The page has been completely isolated, that is, unmapped, taken out of
> @@ -999,6 +1001,9 @@ static int truncate_error_folio(struct folio *folio, unsigned long pfn,
>   	if (mapping->a_ops->error_remove_folio) {
>   		int err = mapping->a_ops->error_remove_folio(mapping, folio);
>   
> +		if (err == MF_DELAYED)
> +			return err;
> +
>   		if (err != 0)
>   			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
>   		else if (!filemap_release_folio(folio, GFP_NOIO))
> @@ -1108,18 +1113,19 @@ static int me_pagecache_clean(struct page_state *ps, struct page *p)
>   		goto out;
>   	}
>   
> -	/*
> -	 * The shmem page is kept in page cache instead of truncating
> -	 * so is expected to have an extra refcount after error-handling.
> -	 */
> -	extra_pins = shmem_mapping(mapping);
> -
>   	/*
>   	 * Truncation is a bit tricky. Enable it per file system for now.
>   	 *
>   	 * Open: to take i_rwsem or not for this? Right now we don't.
>   	 */
>   	ret = truncate_error_folio(folio, page_to_pfn(p), mapping);
> +
> +	/*
> +	 * The shmem page, or any page with MF_DELAYED error handling, is kept in
> +	 * page cache instead of truncating, so is expected to have an extra
> +	 * refcount after error-handling.
> +	 */
> +	extra_pins = shmem_mapping(mapping) || ret == MF_DELAYED;

Well, to do it cleanly shouldn't we let shmem_error_remove_folio() also 
return MF_DELAYED and remove this shmem special case?

Or is there a good reason shmem_mapping() wants to return 0 -- and maybe 
guest_memfd would also wan to do that?

Just reading the code here the inconsistency is unclear.

-- 
Cheers

David / dhildenb


