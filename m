Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE42CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FA518E001D; Mon, 15 Sep 2025 09:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AAF98E0008; Mon, 15 Sep 2025 09:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84BEC8E001D; Mon, 15 Sep 2025 09:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1CE8E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:53:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B22111A399
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:53:07 +0000 (UTC)
X-FDA: 83891626014.01.DDB0055
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id B5B684000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:53:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TeCecidt;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLlYJinc0dfQVpvH1UOH7RnaSWYBlLeAZhMVXB0T/UY=;
	b=UUSQNTzeavmH0COenYxzztkr9VJQtatyVbs0/kym+w8f2DQsnp6ZoEXd3zgZbQvGYmiVWN
	YO1BVlIHnyXsRFJOkyFRAOzl7z4p3r17Era0+AHLkbtZ53R4C9ls8Ae3GPg3FozWDFw+p6
	+pU5XtC9mxMbkylJ2bUeimWqVIVTcdI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TeCecidt;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757944384; a=rsa-sha256;
	cv=none;
	b=OpFADwDBxxZEiWueylSXSQ9EqHbcl93s4ZDnGHC4BjqdosNSlillDVhovnQ7FwmiuJyoOB
	UiCOolzJ2aF/Nv6goCsiVSdm8L+G5IqXXk4qtzhCIb6EJXz2rEeFd9yNBpE82bWILLxgyj
	w+CnG8XlN1nlMeyoeS7ukUzsdDFCKPk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757944384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WLlYJinc0dfQVpvH1UOH7RnaSWYBlLeAZhMVXB0T/UY=;
	b=TeCecidt2hZfddGwJQRQT1Tc4OARsm0J1scjdDxLaNDNoyJPRu4uwVHI6t4lTsp3PKnwBh
	xy1d5GhYmyNcoihglV6Mac3oMEch6nH8MV/RJG8I6rl8OMSPuEfAZQCuXFE//4jy7QskvD
	WsieWLCIivaFZmOR0dXWvsERZP5XeR0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654--PoXBe4OMX-ME__Zka3Y3A-1; Mon, 15 Sep 2025 09:53:02 -0400
X-MC-Unique: -PoXBe4OMX-ME__Zka3Y3A-1
X-Mimecast-MFC-AGG-ID: -PoXBe4OMX-ME__Zka3Y3A_1757944382
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45de18e7eccso22864535e9.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:53:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757944381; x=1758549181;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WLlYJinc0dfQVpvH1UOH7RnaSWYBlLeAZhMVXB0T/UY=;
        b=LjU+WVqDU41S12cbdCupUunt24R0AlcK+ydSJ/GqthFtAuiGKJx5qTfcimk8woKoMP
         TWe9mnqf+dbkR7ZO9onA37hQO0rUCsB5N/8adjtugvK0RY2D4t3rbZrnxrp7yPyqK7FE
         OAEhJdACW6qFxRJczniV6zd/IYVClJHdUgWYlNcHq1ki6L64jMq+oeizZ58Ua06SMvsP
         2FU0mcAF3JmgoGJciOfpdQV9zmEzZS/DVgrwl575sdHnR/1FqnhOZhLcwJUHIB+cjPgI
         wecrDNacuasoPagjxE3kiug2rHih1+oAAC0J7cJDpAk7WiPBQvLaz0gu2Qq5mTiXV7l5
         cDJg==
X-Forwarded-Encrypted: i=1; AJvYcCUFYc2j+kWjcoUNfcGZujWfyOOZc9uPQ8L0k8YYEg+OlOEluNwzR/OD2AzSSIXroDgoQuW2J2etmQ==@kvack.org
X-Gm-Message-State: AOJu0YxtJR5kWHH3jZQUkQD5rIgcVOcU099EdRvBnSTBpwK8L7mlgGMg
	6ZnCfRabsAPUxRRrov9KT0G4/tMOtgxJ+iL8e1/b4Lh9/zKaphvH8z/3aWU1V0EKUefTpmwx9ED
	dSch1y0iDW3cII8OEwY0sI84ZCOwQtDkwnuDwUUBAD4eYyrwljNh0EeqM/9yd
X-Gm-Gg: ASbGncumrl6u3uRVBgvIQTA78I2ZOY4x3DNdVUfHftM9qxBBrJ98EULNJ9Gf8aVtUdG
	ukVKzHPQykxXUBpLwjJlYhllKttaB92XNzuAqBrZB/SH7svBdr1ZYge1995XaQBrI3yJcq5qHQB
	LbJGbdS+8eanu2/ibHTJmnrF5CbXm+zH5tjhUB45srkPxTpJ+P0g+eKLc2WXS+5PlYU6h1H1Fra
	gWwONvdYlGaQ2KAa6hoIuwmRzIXMuZHPTZvlypFL39QZnNHZXV8YAx6qbEYn2kHj2lNYKxQzyDn
	OKiaVPzhjnRcqou2LJk9OKhkXhkcrRu5u8XZeAwabGFWYWbbvqhgdfZ4faIKLeMV9lf0US8I6Kz
	qf08S/GRc5RZY5yhi4VZv1l2kvSp0/rEd3ceTHALG4EJZ5qeXV1851HRQSmlNCB3+u4M=
X-Received: by 2002:a05:600c:354f:b0:45f:2c7c:c1ed with SMTP id 5b1f17b1804b1-45f2c7cc3dcmr34398615e9.2.1757944381495;
        Mon, 15 Sep 2025 06:53:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHcLx/v+RcvjN7afogw7EpWBGd7QAXnqzzVsXD0ZOV8pq1yT5xn6CvxOmjMR8tWQ2JOMsAx5g==
X-Received: by 2002:a05:600c:354f:b0:45f:2c7c:c1ed with SMTP id 5b1f17b1804b1-45f2c7cc3dcmr34398405e9.2.1757944381060;
        Mon, 15 Sep 2025 06:53:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e017bfd14sm179952405e9.21.2025.09.15.06.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 06:53:00 -0700 (PDT)
Message-ID: <9c66e21b-c782-4ed5-b89d-0d7412ef3c85@redhat.com>
Date: Mon, 15 Sep 2025 15:52:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V12 1/5] mm: softdirty: Add pgtable_supports_soft_dirty()
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Deepak Gupta <debug@rivosinc.com>,
 Ved Shanbhogue <ved@rivosinc.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Chunyan Zhang <zhang.lyra@gmail.com>
References: <20250915101343.1449546-1-zhangchunyan@iscas.ac.cn>
 <20250915101343.1449546-2-zhangchunyan@iscas.ac.cn>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250915101343.1449546-2-zhangchunyan@iscas.ac.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uvNw7W68Ric0jgaBV-Tf9JTN3VkigqQ0rJVfQyiTwbI_1757944382
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B5B684000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4w4i6nu6nf7uc1gcekw3up5hj7w6p8tg
X-HE-Tag: 1757944384-260534
X-HE-Meta: U2FsdGVkX1+HThfEGhR8cZuPHJlMAb7jJ4yKLVo9ApCwfQOkSAj3VSYgmRMkh+GAju90lxC49bU8yUmgfOq8N8K3HtJGFT9rUrW2Nm4TX6TVFj79bZvEAiPvnNYIz2KPbin8krPKSi1AVC0xemk/50gSTOh6kqDClBIEUIxqcvxEab0gVdf3Zx/euD52KmI/r/kHQlAlsBepMx0nNziHXwFKJzI1fICCh1ZeoSRlkWc+euWD+dIk2SqBVpeQlBArVg9Sx+Y1EcyLGWVVicDTtmeK87DHMcgXNbw6+108MgRJqVpokSKmkG4lZ1yjHItVCqtkhBaQ5HCuDv3PPBg9bKTB6B9GGrmRRLkJUUa3PdBJlue2iyeXFIlg6OjK3Gtkawy5c4QZJULUphnTF7+SqRjw7Y5GpsBDJaqCk3okMfJTPpN22714Q6j5nvfkq1Wkh0ieLJVdH7b+sWf8u2258ApeIRazCMhNpyg5iD4la0qhpgCeq7kp+IKwCQ25y7I5KPPgTCgHbw00KVLml7Q6l16BqQF4bmrW0jxq3/GfybnVdX8UuFmUIt2vqFQfmjRMEytsm1yLmRY94dEarlmmUhRV9SVmHO9BMhy/q8RSmfuIt7/lqV9J4gX+oGuJxlQR1eU2JAA+FiWFdEm4SFL8bndRZhwWM92TpPGXPDYM73PkiW+528g9vTaRN/RB9dIrNlr0srihqMeO5Wpf86KtpdWAFEXXUoEETWuFXPBSMLEpBDmd6XwR93BEevyPzecMTqHmY2Ia6IH456cztwRjYaDxCchocPgZ+drEVRAPIrTPXful+oYvm8EQuYH8cvCrsJZW+uc36r9CA5UnaG6LzHffvSqOLu9dhN/fYlXiQqK1MreUYPmgMuQ9qTLyDun9P1fwnA91aaichb3BX7QRZMCZy+f/3R0kMmf5w9oaQivhjG9WIANlaPw6U+Hh4uV0DSSAR7aEum6FY0B116i
 zQld7IiJ
 21Gje8ewt297vSS4uvy17QrRhxN16SUA+7PB9PQq0RKH5+I/K9ZEgqwqMCAnV2+bSSpM5ZrSq3WiaQFM8yaHNGeWk4msFnXCIiq0wlLJgPTNkQ+QKxsfWVlnGNV2zILvNXLD1KNhLVwKG+PPm9S7KACQmeFbPlw9GmUOYBQBpiNmZ02Nd+ngwtHzDh1cUJep3WXCtinjt0PPBfnELgNY3xFYR01h0E10UyhRZ4x95lOhcvqQi3Z0fXR95HH61h5zXhisp9hc7Y2/o4jJNdTrDLRM53jzeQ6gK1ODn9gDDY+8LWLzrdL67fJAhd/EsocW3zsZY5JHztZ5dNsprFV3bYJJLff4g286iE8EB/qDSPNJzEKpFwv/jqU5DVhlW6NJvt8xAAYd13GNKqOSE/+jNb32VIiAUY294XjQ+tsIHDBTYQGZBJ/ZeL7Ebnf87kz7sd9fAtBezsucnSrHKvKZVFpq4WCCSpXSklt7/aiJeqqgEVoD+bTA003Pr8DsiZksaDAyTn+1vETmA8Co2QCpML54Qm3N59CqBbIHC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 12:13, Chunyan Zhang wrote:
> Some platforms can customize the PTE PMD entry soft-dirty bit making it
> unavailable even if the architecture provides the resource.
> 
> Add an API which architectures can define their specific implementations
> to detect if soft-dirty bit is available on which device the kernel is
> running.

You should probably mention that we are removing "ifdef 
CONFIG_MEM_SOFT_DIRTY" in favor of pgtable_supports_soft_dirty() checks 
that defaults to IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) if not overriden by 
the arch -> no change in behavior expected.

Then you should mention that we make sure to never set VM_SOFTDIRTY if 
!pgtable_supports_soft_dirty(), so we will never run into VM_SOFTDIRTY 
checks.

> 
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
>   fs/proc/task_mmu.c      | 15 ++++++---------
>   include/linux/mm.h      |  3 +++
>   include/linux/pgtable.h | 12 ++++++++++++
>   mm/debug_vm_pgtable.c   | 10 +++++-----
>   mm/huge_memory.c        | 13 +++++++------
>   mm/internal.h           |  2 +-
>   mm/mmap.c               |  6 ++++--
>   mm/mremap.c             | 13 +++++++------
>   mm/userfaultfd.c        | 10 ++++------
>   mm/vma.c                |  6 ++++--
>   mm/vma_exec.c           |  5 ++++-
>   11 files changed, 57 insertions(+), 38 deletions(-)
> 

Good! All relevant CONFIG_MEM_SOFT_DIRTY occurrences seem to be gone 
now, which is nice.

Nothing jumped at me, hoping this makes cross-compilers happy.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


