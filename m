Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F52CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 15:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF698E0074; Mon, 11 Aug 2025 11:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95FF88E0060; Mon, 11 Aug 2025 11:39:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800818E0074; Mon, 11 Aug 2025 11:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6F88E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:39:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF853B7A0B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:39:39 +0000 (UTC)
X-FDA: 83764886478.05.A4DC649
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 63A2518000C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:39:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Wcn2x6b/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754926777; a=rsa-sha256;
	cv=none;
	b=b/6HywWhugxunwKbhr7WmuQIDjC7Y9i2boq2NhBA44RRgUcGr8w+LibLCrEWqwcm/e74q0
	nrNHnxm+80+AUF4Vm4QFTRUam0EHwBvL4twFmK4b7ml0AoVVtYY8sxMFNo3Fisu50yYVub
	0WRQSQBu1kH53EYWSyZBMXPVth8ptMU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Wcn2x6b/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754926777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyWr1QpZuxF9B4FyrzRej7noS4J8x1+3Oa8vyw2kJ7w=;
	b=Rj2OPYF42gbi6sVwYs7hN8YfQKE/cGqAU9xbezwaUpy/4eHslGozo7rSf/5hbcco2Zj+ZZ
	swzRX8FVdvbJ+vlUKStnRJyYiZ0LAsT2aQeXgyYm6S+xt8qMWQJWSW5nCewCKmL7OFiDnT
	GW2/Uwh8wWCyMoVKKSRtOndOyv8A2fw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754926776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GyWr1QpZuxF9B4FyrzRej7noS4J8x1+3Oa8vyw2kJ7w=;
	b=Wcn2x6b/76pDQSi941HidVUE/P1bNTRRR593e7kvJWnE7tu2uEMlNwYzCnwF9fyiJyFSNU
	Ah0cBqDcIwlOfWagca+5eP3o0+nEhCZFRhwmNI80hZlUJMfPglbVpYeuCrXvawCb50sHen
	108t6CuHHMqsDfTbbqWNoMBAuTdWviM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-vK3XaSbLMRykAVxXd48Ipw-1; Mon, 11 Aug 2025 11:39:35 -0400
X-MC-Unique: vK3XaSbLMRykAVxXd48Ipw-1
X-Mimecast-MFC-AGG-ID: vK3XaSbLMRykAVxXd48Ipw_1754926774
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-458bf93f729so23696525e9.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:39:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754926774; x=1755531574;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GyWr1QpZuxF9B4FyrzRej7noS4J8x1+3Oa8vyw2kJ7w=;
        b=Y9XC1dDNZFdjQkhx+ybfq3vdlRBAn/f/6ct9IATfNeZojgbN4RKbQMtlC0K4qYYKGH
         +tf1NPye5nAClXVqmoH3wn+YsSd0aTV2pkB3pWCZIInfyQyGusKc96AYvxuX3e4lPyNV
         e1azdsv8YUnVpZr43ZZIMOwJhuLZsD4B7XZZYljAbYjaXAhUOUx8hCrjQDEdW/Azs3Sf
         LbT9NxkMiNUj500UWpbwTnjWq7FXGA31D2Y7w5+CieRAFohUDUrdMUuE+TedtNezqNgo
         iJp3wQ679ajaXxj6aptiwMdT5oidtUIGrsaRRrjeFQ5RdneOfPrGcKiIZeAySZnbF48x
         LZJw==
X-Forwarded-Encrypted: i=1; AJvYcCVLu/HpXpQMPyVfq84hF0JDIjb5iLCgDBLaLDkS/8hFkbqwxbSwhsvtRBYD53aYVmpUM9iGF5GuFQ==@kvack.org
X-Gm-Message-State: AOJu0YzcC3vMcAfawaGoSpA7eZmMROh9RQWE+GeczYDbdK5Zw+IfYsVH
	kWDCDWD7qdhSy0Yo/nKchMxcVCXvf7go25kg4VAZLC5+imi6qdL+mw/eUmP+pCK8BcfvVC9TtjW
	0NJad4/VrnaQ5T7w6NkrHtehE7JKFbwdKq0c7/5J3Z87PrL9sXmiY
X-Gm-Gg: ASbGncshV156NVsTwznY5lzYLjY76qVpK0rI379UjBGKHb4btF6ykk2z/T7EOByv1qM
	nJU/eixHc3bsuRnha0WPYFKaResDheZitYfYufgaGbFbQiXgKoS0DFrsagMmufFWmM11m8EHlAu
	PcwQU48Yf1Dew7IzoyBIpjkrayh9yeyjh2I9giNJxpo1ydIsVgBiD0raXXiPWpXPj91G/22H202
	0R2bxFVgLgUpk6/IqTFToI6DZxbqLrvoCSHmnIvJqYnaD+hMmqfnJvaQRjxraCXLOpmn6jWYUhp
	0xSTFlOjgP4vB600VIsJxh9DffEj1+Q/F8q55UvCYPxoDwj8uWu/clc96EzXNDPn9WRC7bDCW9C
	+QJhTjG2Qx8og8CEO2tGM5Ctj1/+zZb92Ummf1inOTYklZOWJLLqjMjiuyvpmyAU7mtY=
X-Received: by 2002:a05:600c:c494:b0:459:db5a:b097 with SMTP id 5b1f17b1804b1-45a10c0126fmr1610685e9.16.1754926774347;
        Mon, 11 Aug 2025 08:39:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlf+7BcvARxFRQk8Q5EGLD08HwQZfsUf/AwyhotSUn7XHRyNjGYRhhAvp4S2PkxpNDcQl2fQ==
X-Received: by 2002:a05:600c:c494:b0:459:db5a:b097 with SMTP id 5b1f17b1804b1-45a10c0126fmr1610205e9.16.1754926773715;
        Mon, 11 Aug 2025 08:39:33 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f06:a600:a397:de1d:2f8b:b66f? (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458b4f9e952sm399513135e9.9.2025.08.11.08.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 08:39:33 -0700 (PDT)
Message-ID: <2e8df53b-d953-43fb-9c69-7d7d60e95c9a@redhat.com>
Date: Mon, 11 Aug 2025 17:39:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: swap: check for xa_zero_entry() on vma in swapoff
 path
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Charan Teja Kalla <quic_charante@quicinc.com>, akpm@linux-foundation.org,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250808092156.1918973-1-quic_charante@quicinc.com>
 <dedf7436-9afa-47f6-b676-88f2dd8b638b@redhat.com>
 <f008107a-2741-476d-9e32-ae9fc0f81838@redhat.com>
 <29e080fd-5f9a-4760-876a-a6ccef33129f@quicinc.com>
 <fec5ad61-7caf-4076-ba81-7b454ec7018d@lucifer.local>
 <9178bf98-2ea7-4ad8-ad43-cdcc02ab863d@redhat.com>
 <904f85d0-acd6-4f47-ab45-fbf18b80f1c6@lucifer.local>
 <7e7bfd05-434c-40b7-98ec-8ce352a8147d@redhat.com>
 <fd35dd5d-95cc-4c37-bf72-52a27fe822ac@lucifer.local>
 <efe3aogdw5wxsn46xyy2rrqui7oghyi7elam7aiv3c6o6hsfbx@ee6dayztcy2x>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <efe3aogdw5wxsn46xyy2rrqui7oghyi7elam7aiv3c6o6hsfbx@ee6dayztcy2x>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y-H_v_uKjPWFe7S9k7XFzFTt4rRddT8ALXu6abNUnP8_1754926774
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 63A2518000C
X-Stat-Signature: gsy9fuznxmegxq4stq6eenge6gignbgp
X-Rspam-User: 
X-HE-Tag: 1754926777-444535
X-HE-Meta: U2FsdGVkX18czdOptRIBXoit+r15dWX4D+c+Vk5MHmXWa/KHVraic3yf3TqtvWWZAQEQ7VkvIqF+UhJJyU39yu1u2YauvlvkA2bjYJCrIgHGXsjEfcHbXjQosYX4tBedA6nJpRN6NJ9M4dT4bBrsWQMxwgOt+XQm0QgokqGYbhp2QCuazW4B4po7BOZyZQWAmST3OL2EgvVf+dzXU4oNreZ39yPvT0XW9ible9hTKCaPNDPqS7Bj8RmD/S5Xh2uI4VDIRlsbL84u9RL8B7fgwHn3P5ZsIxx3rHFvQmlvDHHqx5hP3C9X/oNW6u5vubAqkfyNKL96Th0ifyN5mjOT6sS2Iv+t+5W6I+do6NV+i+/bZIEGoMyMdfFksBJCP0nk7bRqcX+FH2XQzKk9V9RQGePxfzdLKHj+hZD9pos0V9Er0QRtoOWyI/C0j35mHW6X99kWahNxbanDnNmYWSpb9S6iQrrLcmF5Oe7diQF/N+5eWx7mJ50y3ho03/jvSg6Wc3ejkCRPAfMaB2n32kMblE5bLmC1zcdLr5dlcrbkSTZLs8vZOuiCIk1CVF/qPjF8x0+9mIvaJHTmlGYuaTsZRUw+PNbLXieUp/D0m9TSsMYidFiey7HUwIw6N5vgyItViNN9RFA7Rcvkp8Kgj0hovOfYRe1o5YKl7pr6vopbJ04dhowBR9p52RcG/T0jpAPgnbaum6SqDi5zaZe1xDtg1uHOFgA2I/t5H3QQgR1Hi6pXoalLUOT9POzPABgmxiQfC12fBELXf6RYYRtmJOe9DCSQHd7lOlV3ND9GFKbe6WPegxtZWbKfqox87LgaaT+45uH4Xnp2YrbtY1tbnWn5Elv2b9LlQ/Dkov2jl+4TI7xrLpxn/TGJycVr6veK86LOPDRLmg1s9gJZ8oLu7eV14esNnl2VScksAsydAp1SnRWip5zB6efS1GZ9dox4W0zGRZb/GKowsACFOnwSrvw
 QjXPUCLr
 M2E7hi2C2FoxjUq270xOIs1UNSb2Y3v3GLBlzbkKq704IwcCxnaY5AYcjmQHtjVb0AQ9k5CiGFh18/sb3QJtiEGaV7plqzWJl8ir5GCKQkVR1Y/ohUNVRnY2H08p/QKDyLWPCUxTXQE3Pzagd9Lby/ZCcx90pSJ2phW4k7X7B3ueAviYJasnN21sNY8S7h95L1FpK2xr4zCQMOv+Y8KNRmMt1D8ES3H+D6w3sehl0kkKxbF6mjUM9WWKo+eU6/G11tRacAAD6nimXdaMUzO7Yd9wwQwH03uv7Ep6VwcZcviMOk02hGBIr3pNUtLkxhl6EICFEfxRgGMAolyitFDLhQsoVgsGJF1aMjt8+0m87qVhOnvD9+PptG8zPfi00sjsRZpY0iCUUHxwtxhly2e0ozz+R2VrD6iL0oWxzfLLRhIOjv3pnW1e8efUjqOjNLRCXb3GiNcFKdRtnEKLv/G14uJ2XfZYcojYS2ylWQsAXqFN/Pc347eVLzzrhlPoqGaQ/TAPKe+AEwDjTbjR4pFFXgaTsD3UZdEJ7N1xVLLFWkhMFNCGkVroLTPx2t3p9OoqCtatlATHdhGe37E5/9gktKBodL3cPcFoiFygLOt0ms6DD8B9EXi5qmOk0kCqjaDZ2IeQV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> I think it may actually be difficult to do on some level or there was some
>> reason we couldn't, but I may be mistaken.
> 

Thanks for the information!

> Down the rabbit hole we go..
> 
> The cloning of the tree happens by copying the tree in DFS and
> replacing the old nodes with new nodes.  The tree leaves end up being
> copied, which contains all the vmas (unless DONT_COPY is set, so
> basically always all of them..).  When the tree is copied, we have a
> duplicate of the tree with pointers to all the vmas in the old process.
> 
> The way the tree fails is that we've been unable to finish cloning it,
> usually for out of memory reasons.  So, this means we have a tree with
> new and exciting vmas that have never been used and old but still active
> vmas in oldmm.
> 
> The failure point is then marked with an XA_ZERO_ENTRY, which will
> succeed in storing as it's a direct replacement in the tree so no
> allocations necessary.  Thus this is safe even in -ENOMEM scenarios.
> 
> Clearing out the stale data means we may actually need to allocate to
> remove vmas from the new tree, because we use allocated memory in the
> maple tree - we'll need to rebalance, new parents, etc, etc.
> 
> So, to remove the stale data - we may actually have to allocate memory.

Ah, that sucks. And I assume we cannot preallocate early, because we 
might actually require multiple alloc+free cycles.

> 
> But we're most likely out of memory.. and we don't want to get the
> shrinker involved in a broken task teardown, especially since it has
> already been run and failed to help..
> 
> We could replace all the old vmas with XA_ZERO_ENTRY, but that doesn't
> really fix this issue either.

No.

> 
> I could make a function that frees all new vmas and destroys the tree
> specifically for this failure state?

I think the problem is that some page tables were already copied, so we 
would have to zap them as well.

Maybe just factoring stuff from the exit_mmap() function could be one 
way to do it.

> 
> I'm almost certain this will lead to another whack-a-mole situation, but
> those _should_ already be checked or written to work when there are zero
> vmas in an mm (going by experience of what the scheduler does with an
> empty tree).  Syzbot finds these scenarios sometimes via signals or
> other corner cases that can happen..

Yes, I rememebr fixing one instance of "0 VMAs". Most code paths just 
don't apply if a process was never actually ran I guess.

> 
> Then again, I also thought the unstable mm should be checked where
> necessary to avoid assumptions on the mm state..?
> 
> This is funny because we already have a (probably) benign race with oom
> here.  This code may already visit the mm after __oom_reap_task_mm() and
> the mm disappearing, but since the anon vmas should be removed,
> unuse_mm() will skip them.
> 
> Although, I'm not sure what happens when
> mmu_notifier_invalidate_range_start_nonblock() fails AND unuse_mm() is
> called on the mm after.  Maybe checking the unstable mm is necessary
> here anyways?

Can we have MMU notifiers active while the process never even ran and we 
are only halfway through duplicating VMAs?

-- 
Cheers,

David / dhildenb


