Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8617FC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 16:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80A996B008C; Tue, 25 Aug 2026 12:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB896B0096; Tue, 25 Aug 2026 12:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA9A6B0098; Tue, 25 Aug 2026 12:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A7596B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:33:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD02A1C1945
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:33:27 +0000 (UTC)
X-FDA: 85140337254.15.6580D18
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id D6E0E12000C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 16:33:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Zhhqh7yl;
	spf=pass (imf29.hostedemail.com: domain of smostafa@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787675605;
	b=Ka6+Oe10L2HSmT5eyr/6C/QJv/eNuUjlgYtqSB7YMTKG8xavNVKkRqNMI0rFAMahZXtVtH
	uEMHSti24kBHD//zM9bBNjjA/lHUOPt1YKn0ayuGo5elNZucrdM6ZZ+wxZavbJMhYB08h7
	zGnMBbvs5iMNJ0hAF7i3rkRpdJTQKm0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787675605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SkuHlshzOD+AxFcfYa+qONyS5a/GbEXwYVTwh7Zfzc8=;
	b=BoUr2iBFVVRQ94EXzLKVLo+4zK1gvLHm4d8Rjv9Yyw00wA5HT2Eg4hj4dhsJUO+Jotv+Gc
	jDNnQIhzKxK25rHNri16oNHTN1MEC2T9pcClyGJzYTrtRpXpdTXuFxi0teUSiMq9YWlE2V
	3hTpKH2b6o7knAUnUY53CIVrCJlwYnw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Zhhqh7yl;
	spf=pass (imf29.hostedemail.com: domain of smostafa@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4996e2575dbso67465e9.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787675604; x=1788280404; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SkuHlshzOD+AxFcfYa+qONyS5a/GbEXwYVTwh7Zfzc8=;
        b=Zhhqh7ylCJ+SPl//aKgvsPWO4DK7Y+ifW7YxuQNcMZcj1+nTxQCx4H2MmgbNosSR6I
         hc8W3WD/T7o/mg6zigCy4Frn4mpiyrq509mePEYFbjnbF3Aq56zwRjvcar/5XUKDdodY
         Yra2i+n2Q8rMqUElh5W5f0mRckMCtAN65LFRWR9h/DzN5FQeiscWSavqvLJJuSvMvPxA
         L3Q7HsGt7UQCNcPoM1G3eS4QS9e5FcctOpExFCWNx5bfSlnXmVhb3Br0Wm7Qhe8NCwxU
         avzA1NSN4UMjQlTxEX5FPIvqsvUsfb9dKJzJnSb9bHviYfvnzAgSUcrs1+IbWiR+VXOo
         myGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787675604; x=1788280404;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=SkuHlshzOD+AxFcfYa+qONyS5a/GbEXwYVTwh7Zfzc8=;
        b=hgUKTQENXxX5p+c1uJ0upvO/sdMvFyAMheZoBM4YCTQxmXNhwoWODtXlxqrlOWXKuD
         PZ52zHiKQXT9+dyepI964DOhE5JrR/Voqu/wks1LlcNvCBjkN9TvVFHX8GCPcSXmM6nx
         bfyNdrH7ub+m0f1LsvtySf1hZPGbsafGqFSgzAR369N++dWpViSLQTZmffG5dGDxMSOp
         uZcN/ab9QizQdsGVrrd1ViDk6Jy26jgKbRet71JGwlY2bP/PjBdsxHy/8DboXRe+jNu/
         SpUhpp1dSOmubtsyEH1GVXa9dr2of6t/+BL4FTBVrIEyszN4DvAZ+iUpUzOjOWLKv17c
         FZDQ==
X-Forwarded-Encrypted: i=1; AHgh+RqCNDd6ilgDfXw4XOsCAC1ZmwfQJpjHlhSPNuLxEn1ov7zJkMs0+WRGkqxeSBdsU9NMl2O7g2oeLg==@kvack.org
X-Gm-Message-State: AFuF++ky+Aj5LA3LZMCEAA8SlUFOcPsy2Aqs0/wy9cPT33wN5pY1ppyR
	eUeRi/vQ7gW+ltgDm+9j7C5LLJ6AhCET0SC3jkzm0kzqjbUNcXIDdya6uNwu67PFew==
X-Gm-Gg: AR+sD11g7kkbLe5v24vx0XFnoSPO2KflJbbfZ46LvGH8AiQimkxUng99PNZjrlmHVEQ
	kY3jTNiEarE9hca4lddbjGq07Yy09rrwtCL8kVLi8tFjwxRRbQQW9JDIVb+sSWnvvUgA/XAko0y
	2h2+tGFZOKj6e1vKQsKGoh/WEZuPKKBq8w3808h4PRHKCAn8PlZb7/boo4rHkHI8JSPBam9n2Z0
	0y3gzbJcXPADSQZAO4bGF+SVkGHl2VKRGNJHuQK3/FbpIJIY0s5l5AsHxq5houZ6vGMn+MAKxNt
	7EnIwqpjnWDHQv+R1uy2LzDDEpJeFVvO6HYZwoqxT7RM+XPWTQMqlTtLgKzuucphMnh5TDwIMM5
	zS5ce/TV/MdwFSzkQCrWICcSyURwiHlhlazivynpzi4Ae7I9yuHoCqcSDdWd6IQHThrYwBKHExD
	9EN9he6cvWW43At5hNRbMEsF4U4/A9Bpj/OR4f+H6UNwHEO2ydQLpZ89nj0cvMs9Pwvn/Y7brTD
	d8WTh7tKB4Ni0QA7k/KaZrYkwvkWg==
X-Received: by 2002:a05:600c:a31c:b0:499:7da3:dd0c with SMTP id 5b1f17b1804b1-499d867c424mr1003585e9.0.1787675603950;
        Tue, 25 Aug 2026 09:33:23 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499dc960f24sm217945e9.3.2026.08.25.09.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 09:33:23 -0700 (PDT)
Date: Tue, 25 Aug 2026 16:33:19 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Luigi Rizzo <lrizzo@google.com>, Jakub Kicinski <kuba@kernel.org>,
	rizzo.unipi@gmail.com, m.szyprowski@samsung.com,
	robin.murphy@arm.com, willemb@google.com, kuniyu@google.com,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	akpm@linux-foundation.org, david@kernel.org, netdev@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swiotlb: avoid double copy with swiotlb on tx socket
Message-ID: <ao3DzzFIVPdtL7MX@google.com>
References: <20260615234220.3946885-1-lrizzo@google.com>
 <20260615172535.080cf94f@kernel.org>
 <CAMOZA0KAHKsvA9yRcdrjG13S+=rJhw-Cvnw2WdLjGGY0azG0kw@mail.gmail.com>
 <ajEuUZMgS_NRmDcp@google.com>
 <ac473a83-c77f-4a41-bc86-8a857d2d6e36@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac473a83-c77f-4a41-bc86-8a857d2d6e36@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D6E0E12000C
X-Stat-Signature: oq4zyow4xdkgzhot81pn86unjgi68655
X-HE-Tag: 1787675605-468410
X-HE-Meta: U2FsdGVkX1+ls9qEgFSoyNOQDEHchtv03J+/xUBHZGo3wgKscAQbflV0k1HTA2+71LN3VjBuziz/NiB5KZR7+1AKWDk+s8x6Z10QmeZDK07N1JsRiTuul4x2NmfLXh2zgdMBoh8VP/581MGO6pRT3XNX61cKJsus31BEUjsxM78vQE0hvtx52GDQTiuJjLO6nKCliXio/NCAQ0lCyNPw8P5MkzNqovDYQibrZSA1VlnNedzWP3+LTfYF5QRgmdJ57ufUMYTp0sbsuKQXcOVtt7tTxZz2Ttc+FaB5PRAK4noW+H7khccjPgHRxYzGEVQ2Ijd7Z9dy6RSD/aJyGK0yBqNV57lyA66o+R9lx2bH2YO3AvPZ5qfPpXOxnTM/Hjh9zXAeH05ucE8n0pJ/NypqjnmhvdIAj/Ndwnn3Jx2t6qEYzQoJWgw4YkDpCrlwXAHfDyZKlGFOD/RPRILujBi14LEcTYHfM2O2PGKdS8CJGz8QbQx8WOzVX8XcKCIQJVnh37rCATbR2Ar6gxPM6ftalzSMt0U4uvVfSgZQx0TcxG+n14L5MfcZLXAjKBeBqcId9ucCGDaY27j2Be7c1ED0s/4bGLHVMgLlsQKYy2g7pXqRgnFd+V1pzu7JTD7ayMddGRSMfGVI0HLfFKiEVTJ4ro3tJUmSiY9c0pVEK+gn6mCwn2LREo5QMDkHs7ReYOGSXCRInmMwDFTJbiaauYlet7QKojv8LYarZtS6Oe6uwjChiyf9lwmCOjRq6Hni5RNBBHqCf68fMOV/nbFkm8RbTrwK385YtAewsTdvpVMehWU/byPw4D/Gn1LeC3B53LEphr3UItOfGizMZiEoD0CLW9vgeqqDP19YExArIPBGIYL/S5ZdR6jQAKsJbQEWDSQlPggdHp6pwAMfYrT+uH4tIOTd4yw7T6P3qmb8E772YwZkbs9OegYYIYEUv5x3ClMM/jMY0cQ2cVnw8Xrjgx0
 Tx9jWT6P
 Cze29CnDHCe4JwMg1O7ePpbJr9VXjT32RjmBYBpRZMrrcFkUXnFIbsrLw11MRt3bjHNhWMIXcXQtXSLjn0zD9W+GdVr3F1V1b10TXOs2D53OsmSybMSW8XK+VTGtnFgnnbgCcVP5DFSSwVmUEWvGB0gkKBS863BvwrEe1XPn6WjPd2egQXun+hZye1mL/4DQzZzsjBpliqtXZsPcx3alVM5qC04v3K7YPTflcg9SGLOnR4mA+mxtbjuZQh8eEeGZICxFasboP310oQ+L82o0ZYO43oQxUXg6HfEo3iNVN1inb7N/A59Qr4TqPcRt1JnFtFGK+jsCpM517tCt4Fzckuv7+jrWklTdL02f9plr8zRDXPIstf7TUsegR2cOlUoThjuD/0Nb4eTBQGF49LMwmvpb0kX1TmUkOcaTPTe94Mp9bKo7mFwTy9vRLgGc8yATWtmudfoU+Rit3yG1lO/B0fzZVU3Ez1iRhz/Uc9g2RLX5G44rAbCpiFljj/IvndjnM5MhKZ9NzsrXYWWb9IMZE+asHKYzWOTeD5bGKwSu68gwuiqMTlsjrsoqmTdBf0Y4czZ5r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 10:59:21AM +0200, Dragos Tatulea wrote:
> 
> 
> On 16.06.26 13:06, Mostafa Saleh wrote:
> > On Tue, Jun 16, 2026 at 02:33:52AM +0200, Luigi Rizzo wrote:
> >> On Tue, Jun 16, 2026 at 2:25 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >>>
> >>> On Mon, 15 Jun 2026 23:42:20 +0000 Luigi Rizzo wrote:
> >>>> The use of swiotlb causes an extra data copy on I/O.  For tx sockets,
> >>>> especially with greedy senders, this has a high chance of happening in
> >>>> the softirq handler for tx network interrupts, creating a significant
> >>>> performance bottleneck.
> >>>
> >>> What's the use case? I associate swiotlb with debug / testing mostly,
> >>> so it'd be useful for people like me to explain why you care.
> >>
> >> Ah sorry, I forgot to mention.
> >> swiotlb is used in guest kernels for confidential computing VMs.
> >> Ordinary memory pages are encrypted and the host or devices
> >> have no way to decrypt them, so the kernel must use
> >> unencrypted bounce buffers to exchange data with I/O devices.
> > 
> > I started looking into the same problem recently, to reduce the
> > bouncing in protected KVM (pKVM) confidential guests.
> > My first attempt was to update dma_direct_map_phys() to skip
> > bouncing and do inline memory decryption (for pKVM that is a hypercall
> > which updates the stage-2 page tables), however, that was really slow
> > compared to the memcpy in bouncing even for massive pages.
> > My conclusion was similar that we need to solve this at construction
> > by making this memory allocated from a pre-decrypted pool (which
> > does not have to be part of the SWIOTLB)
> > My initial idea was to teach some of the kernel subsystems (SKB,
> > BLK, SLAB) about "CoCo allocators" that allocate decrypted memory,
> > as this is not a net specific problem.
> > 
> An example of this is Jiri's system_cc_shared heap which is a dma-buf
> heap with decrypted memory for userspace.
> 
> > I am still looking into this, I was planning to bring this up in the
> > upcoming LPC.
> > I will give this patch a try. However, I believe that we need a more
> > generalised concept for CoCo pre-decrypted allocators in the kernel.
> > 
> There is a talk at LPC in the networking track about this [2]. This is
> exactly the type of discussion that I was hoping to have there.

I see, thanks for point that. I plan to be in LPC, so I will aim to
attend this talk.

> 
> Besides the issues mentioned in this thread we've also found that a lot
> of overhead can come only from swiotlb allocations when running many queues.
> 
> I will add information about this series in my talk. Hopefully I will also
> have time to add some numbers for comparison.

I had a quick look, I am not sure how that will shape at the end, but I
think we need a general solution beyond NICs. For example in pKVM the
bouncing is used with virtio devices, so doing this per-driver won't
really work and is not possible in some scenarios where memory is
allocated from the core kernel and then passed to the driver.
So, I was thinking the kernel relying on
CC_ATTR_MEM_ENCRYPT/force_dma_unencrypted() could detect that and
allocate pre-shared memory for those cases.

Thanks,
Mostafa

> 
> Sorry for the late reply but I spotted this thread only now by
> accident.
> 
> [1] https://lore.kernel.org/all/20260325192352.437608-3-jiri@resnulli.us/
> [2] https://lpc.events/event/20/contributions/2464
> 
> Thanks,
> Dragos

