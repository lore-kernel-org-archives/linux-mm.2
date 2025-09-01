Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36771CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A77498E0061; Mon,  1 Sep 2025 09:58:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D99E8E0006; Mon,  1 Sep 2025 09:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8E38E0061; Mon,  1 Sep 2025 09:58:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 777308E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:58:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D7BC13B23B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:58:53 +0000 (UTC)
X-FDA: 83840837346.08.0385BFA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id D1ECFC000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:58:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RL+v7zDV;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756735130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UPcea11oImlNUykreQKcnkewIQP8bQmzD1K+RUPYzZM=;
	b=05+GrCyWIX91/WtG5MSnR4SL8FBSGIDsVfLLToqGMOdHRXb7Qdq//N7wS/8364YI6z9bUo
	KOrkHFzgniGDYjVA2hlnDNS3jJnMn/qFfN6dIEKXbvF9QgjHWiNFMJ8gXGc/TLVM8IQmCe
	hMyi+8tOlUzAL+UHYojkxaQ8hxkcm9U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RL+v7zDV;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756735130; a=rsa-sha256;
	cv=none;
	b=49avn9QtHsPHsXtjvaz98hy7I2nxOAXbp8e48GvRy3F1ZKX8Y+PaZk6b/7ZYO8LQ/kXBj/
	NptWSZaamTK/VjG4q/LyKWOLbyRxh/LWjM0E6m8DdkCnVnDd/aCdYgEq8qswh2oQP+TBzN
	6gDLYgOmwvoyUUulRiJ1hOKQ7BFBKrs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756735130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UPcea11oImlNUykreQKcnkewIQP8bQmzD1K+RUPYzZM=;
	b=RL+v7zDV7J/Ll4II1ItZOcMGJS/8DYdUSf5jujPPizsuK3w3d8Inw7ccZgiRupgD3C3PfA
	DiEsn/Gxkxsuw0c5QTAGquC86R/2xf/LlvaKADXX9Hc8qhW89J41rcSp8LtIs1k5MCK55N
	wuMcnHhR6B4IPkK7b5npWG4mtdtooWQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-100-pcttYeDFNpSw8BaayBwiEQ-1; Mon, 01 Sep 2025 09:58:19 -0400
X-MC-Unique: pcttYeDFNpSw8BaayBwiEQ-1
X-Mimecast-MFC-AGG-ID: pcttYeDFNpSw8BaayBwiEQ_1756735097
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b8af0b8deso7061865e9.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756735097; x=1757339897;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UPcea11oImlNUykreQKcnkewIQP8bQmzD1K+RUPYzZM=;
        b=NHwazwsgvZ+WkHS5EriSqLQfulFKa5b5H0YuXtkN58w2Ss1uPYjemEVkZJ1vNgbJZ5
         qqxuKqRlnCiwW3wPT8n+QbcHoA1HIg6HT+NY7eDfHfOW733C0Ga1gLesG7/c75TygYdy
         XQB6X4gARUi/oZEetaLmS65ftwoolCzZTODMjl+1itdSX8fzpjgWVe+q+NgTnvpuWgbq
         buHCG1Nl0GEcIrnS7xkpWy/fHQeBD0bTFFsPDMctA5c64rou2Qw3xYpOIuGaSOU7lQZ2
         vS0yXbs0hFOWfkO2iXrZ8y5KOrVmFSuhdoJVS4WnatGrFPmt6rZfoUI5oyM27PYZjzI3
         w6TQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvmOoec/kFEK+9Czf6YCLZrLsI4BG+iEnOkSisSkXEyiFniOZLwDRrPHvZWB1VIOhDye/3VmO/Gg==@kvack.org
X-Gm-Message-State: AOJu0Yy6Xcm6B7AbYYqNzS9gRYrwkR8kt7MDiGrud9Bfnc3kxmZ8hiVy
	hoc2PNscY+job2K6oaRkLtQzNeW1oM6ezh+kChKu8jnr24MUUi+uimjUhHQKrR/fnOwo0AkAiQC
	YucAMpS4Rf3J5KpPl/sZi5BmldcqKqfQHjFN8dd8qRNJUOG6dtYMk
X-Gm-Gg: ASbGnct9O5/Za2cJ7bGNUY2b99WR3NrO22jcphk8zhMetp/lqEkXsIlbrpayhGBZFjO
	xRB+Ch4JFUYb2dkYCvbBKPswkhxd9Y4huOBLTR9z1zuweTM8/6JjMvXxsoxE7KfoJG/nBZ3lSn2
	rRrRCIC2U9DqeOIZD37lhtZwTwf4n0WUFJLCOixX/8m+ZyYt9DBgf0lxLoj+1IZLktqSM7ZJFzQ
	PRvVupNeuBfF8KHGTrtnZCQRAf5zpPMReY1ulsNMOaOxQa0m/ENjNvrpXMKkg8wz0b1ditJgBjC
	ICHrpy9TvnuFZqXDRsvcO9SStXNyJrWS256hrQOJPFtk6sPZCM7OESeH+KPXB9xPT08T1CfMCwN
	xRmwjRcDox4jWfqY+yxaqseS0vOnVMzYe6/9aN0UM+FsZCXxn/O7HA6pYWR1g3ZsV+2Q=
X-Received: by 2002:a05:600c:3149:b0:459:d9a2:e920 with SMTP id 5b1f17b1804b1-45b8553f0d6mr59404805e9.4.1756735097378;
        Mon, 01 Sep 2025 06:58:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFn3qnjVr3vNwl0OPfOfAX2NQN1Ov4ftn1WPYrnzUffpb/PLcS4jgL1Mkb7uQh+fwL+1q0Rlw==
X-Received: by 2002:a05:600c:3149:b0:459:d9a2:e920 with SMTP id 5b1f17b1804b1-45b8553f0d6mr59404385e9.4.1756735096846;
        Mon, 01 Sep 2025 06:58:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7df3ff72sm99174625e9.1.2025.09.01.06.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:58:16 -0700 (PDT)
Message-ID: <2ad655ca-7003-4030-bb2d-1c4bcfda30cc@redhat.com>
Date: Mon, 1 Sep 2025 15:58:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] mm: constify arch_pick_mmap_layout() for
 improved const-correctness
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-9-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901123028.3383461-9-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AZHyd4HQNnvRQ_slXzc5p_3NztB4Yp6E1X8erlUCtd8_1756735097
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k9msjycph7wajz8wbx6st6hdnw1qkq5a
X-Rspam-User: 
X-Rspamd-Queue-Id: D1ECFC000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1756735130-356052
X-HE-Meta: U2FsdGVkX1+eJ8cCiL9UtsnlKA4OJElXspm9CrUYiq6VOOjLkiYqYLC8siObwLSr38GEJXv92TAx/VgmapOQvR1it5sScnE5LtUQPmTJE55tsNnu6+tnV/QEKMuFs1uuaBOoz+trS/bHt/v+Iq12o+nDUTecArwiObSKLaDEnAeNKw0K2cwPi0O78thVy5DyX3bxwnX2w3GdVYqKaEPsRX90FrNBi4j8q3tQibKh4Uv2fkvIi6e073CIqiKZRp0M7yE0FoCgiyVIy/4rdLVspBVWLT50I4NIi6Bb1b2KkRAVUPWfYGBkdH10seYR5PZDFsR313AErVq6TIattmPYYWC/Z4DaglIivHsJYD4z4GlD3kZGnRkgrHuUVyXxtijxUDnV8eIlEetK49fBqLQPJW9kSQNt79pGU55aIb5HHCkgxiEQSXQHp1FigktmBTTq+2NLqrHHtUzZnb6uU18I9gbedggyTv/q0tQ8Q5Tar7dlen3969emSAJmHkqzXXGpQQ1Af5DXxevNaiY8VLxaxefDWYYst7mCoElvSW7iIJxeXWLJGJfA3idtoGmWz0tJZMUEvb20Ujnl56rk4lv67GrCZHgcLXI8Gu3SRC4JdNWwHzUbJ+5W3ZpvqeWXPzgPRl+l8Sdn8BeqjeFh4tGYQFeC0k3SGCf2kLJbPaO6k3/BDojIf5CuV2wfi2sI6oUg9KvJFVOikpEcYMBNxayfo6AU8pNeFVK9S4bJ2bF42sNKOWEJ1dQy18M7WPgjgOKmPMKUSulXnUXV+4JpKSUhsNn0QMqbuG5+3hGY4mNdXgesrB4AjqdwYOxdehQq0g6wWk3ssGJ/dnPfJ7OeAlAZzLJ+BGbvD/x6y3hwGluRAm0jfri4I22XQuzAXOLB447BX5RlCqz19kapV3Y3QFJYGrnM+Ib0TeHZ0KZ/eBXZGTEw8zOeIYIsshqk1Me9QgMKz71wKFO/lLwC/BeI3/X
 UHL+LnYs
 rIbGAQbDraz3BWmxRnXAGMCl1ASK3rrq7HJn4Yrgp7w4dzzUTqYAB3Kd3W/MGC8aTVUY3l+XhdECWW0ds3CmR3nnXfdDOPRiZ41WyQU65yIPdKafTBj+6gQdkpJqN0Z0bobTUWz2pwgXUbAg7nglUfag32ZvcNDGhLj/RheHOxdX16KiLHsjLZp9MfyB/TMSdfGHLjroQD/CBV2A0FGGG4OZGQ8SJ10Hc5x2E4mNrQyO1LxEJgShsznZTqdgtnNajz47Hu5kkPGtObHMlhujr1CFu1j4MhoxGbIOk4cDwDiPprwVQzClFC2Xyrze0L5UrtditWGjPlaOZTN8gO2SjxFJ/0aRRvbDxuWGZUnem6nu+BOhSmDTfnqqkYOmqxTvzTKUfsARZsgYbpD61x+en/cPC7CQ+xCxeDnyIDlfjIKdpUe7/dCJ2dp5a5YvzUqgwjWUkopKUT/90OhM+oRwq5Ktl4Cb3AcFMAIqWwEqHB9LZAyJ6bzHdYMtXpZ9L35Sns9Yk98KCZrnmUnTqoXcbwbrv3E//wGxfgADMbAVvr85NMDoonRI4ep6PFFiUkDoJs6Ey9Bxld0AAtS/SWcPGG+HHozs3U+QqaymUK3DYVI4lnZlVbKwJkYN/bMmLHkNU3Po4ml79pL2jLSUFezMR686NMLtdyYAvM5avQKSUDWLMKwn/QoqGSyfNCBiDP7HEjlFbG8DpY707nj+68wRx/10AykJUcZm/5GSXPen367UcjCa/oDWOa4nzng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:30, Max Kellermann wrote:
> This function only reads from the rlimit pointer (but writes to the
> mm_struct pointer which is kept without `const`).
> 
> All callees are already const-ified or (internal functions) are being
> constified by this patch.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

[...]

> index 2201da0afecc..0232d983b715 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -178,7 +178,7 @@ static inline void mm_update_next_owner(struct mm_struct *mm)
>   #endif
>   
>   extern void arch_pick_mmap_layout(struct mm_struct *mm,
> -				  struct rlimit *rlim_stack);
> +				  const struct rlimit *rlim_stack);
>   
>   unsigned long
>   arch_get_unmapped_area(struct file *filp, unsigned long addr,
> @@ -211,7 +211,7 @@ generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
>   				  unsigned long flags, vm_flags_t vm_flags);
>   #else
>   static inline void arch_pick_mmap_layout(struct mm_struct *mm,
> -					 struct rlimit *rlim_stack) {}
> +					 const struct rlimit *rlim_stack) {}
>   #endif

Should both these cases also use *const?

(for the latter we probably don't care either, but maybe just to be 
consistent)

-- 
Cheers

David / dhildenb


