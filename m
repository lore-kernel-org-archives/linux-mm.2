Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F1F1CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBBF18E0002; Thu, 11 Sep 2025 04:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93508E0001; Thu, 11 Sep 2025 04:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9198E0002; Thu, 11 Sep 2025 04:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B01FB8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:14:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49A008622D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:14:34 +0000 (UTC)
X-FDA: 83876257668.25.1569EF5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id D41174000B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:14:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HpQ9dplQ;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757578472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVooG23M6eU83JnmSyQPASzmmyOBZUr14IQFACUfXhQ=;
	b=jpX9Sbb39xlqt2uDX7Bkwi+MsGBXYUcl80GbFq12PPk++Kd5iS9PxwcRsoWZc/jFwpyp6O
	vDaqGmowBXQ0RVOBtF7wk6fd+9AzMvbFE2PpcP+jSPmUXSRJ0OiSUnZBGYPtokS7zCyv/k
	qPUptOMxHUWTtXUqnsgn+y5yX3QWK8U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HpQ9dplQ;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757578472; a=rsa-sha256;
	cv=none;
	b=aLdAfXr0xburM8cDTepjk4QPKzCj4eJpDG5KRHmcEHDTXy117AORKU6185N+g6ZfDJOcn2
	EeU+kO9xtN+MOd8oz70Q457tSyVU+BjHZGlxxFecolYFGs/rIU9SRKBL7znddxWU+unS23
	DDqmxSTQoL8Y7x5r5iqAmK+a3ymKh7c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757578471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XVooG23M6eU83JnmSyQPASzmmyOBZUr14IQFACUfXhQ=;
	b=HpQ9dplQWg7fHsKMYsEiyoaAWOmYrf0HbifImSE/U1ehjXqBzg+lqYho6FjAxw/C5x2SPP
	S/j3N04FlSalwxmeh/d72V8cYHGKXGAH1Lnt99lqjuCtj4UbQNge2aja/5PnUzwHc31wAM
	UhrEFg7ebcanvydkB/dR3QSrDO6rqVk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-576-jTm0ryevOFGXwKBe4pA9-w-1; Thu, 11 Sep 2025 04:14:30 -0400
X-MC-Unique: jTm0ryevOFGXwKBe4pA9-w-1
X-Mimecast-MFC-AGG-ID: jTm0ryevOFGXwKBe4pA9-w_1757578469
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3db89e4f443so283624f8f.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 01:14:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757578469; x=1758183269;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XVooG23M6eU83JnmSyQPASzmmyOBZUr14IQFACUfXhQ=;
        b=JBaJJKhnw/jAiuBtzscJZcAMtifKe8pB74NbkVYJFvKXv/5+Aq+NmwY4Z7E0uzJua7
         mHU/LwOa8+njDzod4IkrTdcXH/ZmPZxlFz3wB7DelsXmVIqlOblWICQ9ckJH8iN4ZTVp
         1N2tEnXQNKdaTiXgcSGWex78dTXmMsWLNNCPQcoQU7aE2ZpiM5kDx6iqu++OivaC8hcY
         GYlb3tQ8m7pHkkMSHJ6bjHtt3XArjmgMP1nib64uDMSOniJ/1xBIk2jZA+tUV7dLPWrz
         UuQKmZ/G5pIFppG5qZiMoa4m0qSBCExmUMZggXQrT0cf+yRvZgcE1gVRxiIH63WQKNvB
         5ULA==
X-Gm-Message-State: AOJu0YxYlChWIvg1FCrpJcNwrMhbR3ta6FU4CeZNyUjRwwvnowXLHmje
	HWY9kkroQCtXKoHd4eVXdt7yMYEGfJegB7QfnaNlI4z+kUBZlgJkk9RJKzDC6rnxpFVe4G6akGX
	xCavgxz8SB32EPFvYHgqr4l9Q0g0JCnqR39luWSbfCJSb8gLLQp2e
X-Gm-Gg: ASbGncsc7veXLaO4uGU5Lm6lTyh0yPgVjifWlUU37MpAscYCHcxDnGJbsv0PHonI/jL
	Kc8nZ6z0UBY693pVum+GX51giJyXPAW/bRRhv44JWI7nSRhBOI+nS0nhKfl6NsJn4T7AO4wiHc8
	SVoJNb0P+iuWUrK115ckbGyf+gWS7I0FSmNO17FOcOorFQkTbRDPJFO+PxB8CM5HGcE2NQp7CvG
	rc3IUrzLmSOJHtPvhRpUTg0/7VR+zE0Gt0ooe20HUPcAx6qx4v9lI40f2Yz1fqv+xMygZIuDTFr
	jrmtjTf7+q8q7JZYn0uBc4J4aCVyrPi9Z1WtOxJ32dVkOEu4LER1JIlof7qxNwADdbyRh+cbe61
	nr8BocTDz3dxyhQxejyt5fiG5MJ4v60Z9mbJ7A/E7Tfj3eM82A4RFDv3o2WcZYJHjJl8=
X-Received: by 2002:a05:6000:2385:b0:3ca:a70d:5710 with SMTP id ffacd0b85a97d-3e64bedfe82mr12622979f8f.41.1757578468770;
        Thu, 11 Sep 2025 01:14:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFt9R4ceKUfDED7ekrU/uZDJwek4K4Ef3gvdIigF62yD9nDDBH02igztOXArY32htmRuKwTVA==
X-Received: by 2002:a05:6000:2385:b0:3ca:a70d:5710 with SMTP id ffacd0b85a97d-3e64bedfe82mr12622952f8f.41.1757578468345;
        Thu, 11 Sep 2025 01:14:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e76078fe3bsm1460337f8f.28.2025.09.11.01.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 01:14:27 -0700 (PDT)
Message-ID: <fc37efe2-53a2-483b-8c59-bccafae81d97@redhat.com>
Date: Thu, 11 Sep 2025 10:14:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
To: Barry Song <21cnbao@gmail.com>, Nicolas Geoffray <ngeoffray@google.com>,
 Lokesh Gidra <lokeshgidra@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@surriel.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>
Cc: Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>,
 SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
 Peter Xu <peterx@redhat.com>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gVB9ebOky_TgaAluoAe6-jbeHflry60SaW-ZyEw86yw_1757578469
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o6darnkwu5k1d43uouuaxgssc5zta6uu
X-Rspam-User: 
X-Rspamd-Queue-Id: D41174000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1757578471-722785
X-HE-Meta: U2FsdGVkX1/a72j6VL4BJyfz44FsCXUqnja7807bI14pdsnkoGTM6eF/oNKzSgyDZEKOqNeke6dVwe4oOy3yW0Uv2GVPpGLi0i0oaQ5nz7XUNkZsg/V4LwZfOcfEy71yHF9n4oCprURs97/bNgz6bW7fW2Gkh7qjkjZqS/GxWaUzXdsuBHHvNLAQmhuD6woeIi+0d0Xz/vYyBpz8dWpuPQFg+zijQELEUqT2dRuk9CaXC7zLM/1hMll66jB7s7wvZ39AgEycB+EpHq9j/J7NyfNz1HNi1EJWEw2037pOz0bpWHvthWxCobNFMpkX6ufrtjF8t2UtGmbGQlgxHELYvQIcJrC3/1AHtK2hGoq9Ec29ruMePI1xAv2XpSh9RA57neDZRlqr5hiXgOlva6RviOK3sjyQK1eRX9+lckm53b+zij0qYzXhWteKYqPWKyFZTvPbc04nJsB2XYbPFrzzAAvZIlYAHoC1krfr4aXd8MEPePVzY5ghqUTY6R/1ISsQFd7xNlwivWYFv1MM1jzdsONI/7DYidadDB2ZwsSt7LY5+ScGW6h0oPWZ4osZlrFzxx4xZPo0bZKL6P3sOklJpOxkF/CzV/XMfgYcSJGcizTm4Lzg86fVXI4dJ4tbkvtKoL0FhujWaq120r5Vikq156vmFmPe3AL7kv8YxqQypQAcxFjAZGsvMEyXIifJn7gK+AxamE9+S5epvuV0gI/6NfQOwHhmF967yPuM/BybtrQ8rAVlykB/L4aaZbcEg8GR7FjnqXy1B5aGR0EFydFqpAALKNf5pnYWO5iEghrRaqJXGwWXujCmOGd9KLE9zG1Vdw18YELpGW0N3GZCMeCC4qgsIetCsW7QbzrXmAABA7nt3GN62ze/wUNWM1eSXbNJxz65AxsqJQdWEPv7rwDiDzf7/YuY/Ebxl4Wd/8h3pzl+oz694vAqZU3oHlWyXJLpkDohEzU92NzA5oEzf0X
 +jNkmZ5f
 izlxj/munbSLt0xIeG4welAFaI+YWlxh4rzs9hR4j0CNJvjS4lO2p8nTrRiADs1cGfu8vN7/nWxqyuzWAejOS/IjVkW68E01ouuwUsVx0LMtCCA5kjuzfYsUghnDwqugjr1ftmYxgOevVv36J4e3S4LIL5KWHwoW6dWbj6WUBixceQG/E/Vv8WSYeGteTKMegIm8AXibz2wv235NsrtY99ilQpTI68gc+AJCpNNnMvN/VXIGyqyFP5BhPr/CrrKNjeRgPgKHVCixHU9LSy9z9MHxyAML93d8HMWxKIPedMhQ+2yREGasSOtPgf4aX3Ak5c9pfEZjz5v/pzp6EuB7QYQdO/UoyATu+wwkId1fS2mCw6MIAFHcPV4EKKFWR+XUD3kLcNMG7oAiXZghRqrDtX4FPjXL+bFl/xIKxPa0KiCxeqaqBsslUYn3zaamSn1ZJ1bAkSHYDqKalaxJLtkDXDSqPQSdR2hTIBOOFXlzIhSsbQ7a+Jb8AQmR0Dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.09.25 09:17, Barry Song wrote:
> Hi All,
> 
> I’m aware that Lokesh started a discussion on the concurrency issue
> between usefaultfd_move and memory reclamation [1]. However, my
> concern is different, so I’m starting a separate discussion.
> 
> In the process tree, many processes may share anon_vma->root, even if
> they don’t share the anon_vma itself. This causes serious lock contention
> between memory reclamation (which calls folio_referenced and try_to_unmap)
> and other processes calling fork(), exit(), mprotect(), etc.
> 
> On Android, this issue becomes more severe since many processes are
> descendants of zygote.
> 
> Memory reclamation path:
>    folio_lock_anon_vma_read
> 
> mprotect path:
>    mprotect
>      split_vma
>        anon_vma_clone
> 
> fork / copy_process path:
>    copy_process
>      dup_mmap
>        anon_vma_fork
> 
> exit path:
>    exit_mmap
>      free_pgtables
>        unlink_anon_vmas
> 
> To be honest, memory reclamation—especially folio_referenced()—is a
> problem. It is called very frequently and can block other important
> user threads waiting for the anon_vma root lock, causing UI lag.
> 
> I have a rough idea: since the vast majority of anon folios are actually
> exclusive (I observed almost 98% of Android anon folios fall into this
> category), they don’t need to iterate the anon_vma tree. They belong to
> a single process, and even for rmap, it is per-process.
> 
> I propose introducing a per-anon_vma lock. For exclusive folios whose
> anon_vma is not shared, we could use this per-anon_vma lock.
> folio_referenced declares that it will begin reading, and Lokesh’s
> folio_lock may also help maintain folios as exclusive, so I am
> somewhat in favor of his RFC. Any thread writing to such an anon_vma
> would take the per-vma write lock, and possibly also the anon_vma
> root write lock. If folio_referenced fails to declare the per-vma lock,
> it can fall back to the global anon_vma->root read mutex, similar to
> mmap_lock.

To summarize, are you proposing a similar locking scheme like we have 
for mm vs. vma here for anon-vma root vs. anon-vma?

-- 
Cheers

David / dhildenb


