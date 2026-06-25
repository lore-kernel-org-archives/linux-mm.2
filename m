Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7173ACDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 13:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FCB56B0088; Thu, 25 Jun 2026 09:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D46A6B008A; Thu, 25 Jun 2026 09:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4216B0095; Thu, 25 Jun 2026 09:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 288936B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:36:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E310A0115
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:36:31 +0000 (UTC)
X-FDA: 84918534582.22.59FEBEA
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3C5348000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:36:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GVyAP0qa;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782394589;
	b=fTsWvKE3ULs69gOQJKguV0oFRBfKWnQPhHgDuz4fNWdG32dIAGpJc2lQZSBwf/d/0lcFwm
	k+nNiocnzVzK3IG/w+nRZUnbmGyY18U2ZJu3aEOCFOW/fEWXns1cnmWe+wk5cwuYCw+dhO
	Wa5DpBW5vnzwfARzd9l7NUa6CzbwLK8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782394589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALlzMSFTkD2qwY6cH7Q83YaJoqNCS+acziBP11A7pe0=;
	b=uF1yZZhoHqRRADHpzdciXtk14RzV1D43gvH/djVakh5zT4FPyQmsS6kTbbbfGSMEwejPxn
	frDFlcFqTudPXzywvueB0hnRb9gGkkRaJUsy7yLcjck6BpPjNjZxbGyvH8jmtCI3eA615y
	UsPyLbXPouLyf37vsurqVGKhrMMn2NI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GVyAP0qa;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.53 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8ddd7bad263so20801616d6.2
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782394588; x=1782999388; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ALlzMSFTkD2qwY6cH7Q83YaJoqNCS+acziBP11A7pe0=;
        b=GVyAP0qa4KdaV8qk1PNyfkM1M53nvpMjf+t4keBG3t0t6z935tQMoFTP5qgM5mC85S
         B4nm3o78q/OXPRbT39OGI4xTCt9O1DgPzZaHKV3jW7ukcaS2WU3lDeASD1DG5+32U1tw
         mfCD5TWZByy/8lYtnZzKuJMnQyE+JOFN1Orn97IJ9OHfPlnlIrYLHbL5lQdGsb3BUCZ7
         2u0uIDmn9EoB2Cle0R6QvxYFqMvm/IMQsAO0w3kKEa7L2meQA+9xXKMdXRJRtyzowR84
         mUACxpGafDq/gplH4UtIHp7zLjU1VKzlL3h476h/iPACzsk/Pw2AHYyxvx3OGdgRVxWL
         nOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782394588; x=1782999388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ALlzMSFTkD2qwY6cH7Q83YaJoqNCS+acziBP11A7pe0=;
        b=sMKfuDePnS39ajWWcw7t04Zj0YUFuXJSPGf+PmJ+2th6DQXn8f8Fn99DTTkXO2UQJP
         kd8WaQuKLCgxKVyG8HfDpuOAWEREKqPSVwedRI+jnQjO2C/KeVd+NvLlCrquJJKe5HMS
         dmmqxfT4AiRsiTsIFV72LoQ0OKoc7qU9sET82ziEuodrHJh36eB3o/1WRbAsc2dnyc+h
         NSvn10KHMtT7NO5M2L6Rtk/oLkYiw1gCwPJhsQSkaNhwZpy0KWOi5LF5t1iPIHcSoZUN
         idrJrF5z3Jfan7Mg2tWqitnrantOSty9z1Rk63JJgbuKFSZeoAKuxFaeyywOxhgNj2UA
         HRrg==
X-Forwarded-Encrypted: i=1; AFNElJ9qvBCkf60Rb2T8Nq9CoA5XHjJ88AcK54fJsyNspM9hZjjiGKRbDe8bdfRKvmqRuBjahK+QAbnXOQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8v1LeJ5pwRBDRiGN7hRGDZwkrpiNxeiCSPFGnx7N1Ti4oTRqY
	JyaUkGR+HkxvEssjbrkfOiBMlpQ46clodhe6yVmS9nDtR/Hr8a6/BvqD81Hqhd2ifFw=
X-Gm-Gg: AfdE7cmUxtmxCbDpxeclnWe2G7SxcHDMsrOTDXTspQ12obqKGe1snf9tWgPmBmEyqTW
	XouDASYokWftbqp+nme9nqXTcyl0HoTgQePases02gSj5RmQxQ4DOnQ3PyDwEY976qfeJRVcNpv
	jSDedXbl8qsxjSMA7phm2BskGZ593I1PBiyNkYM9J2nBqXhypSjzGy2u4Yqawhd6ZYu66nq3xIe
	hypzHjlDFIyQk4Se9TCC+7DU68++EKLpdWGBhR80xnnXir6MA0VjHXM3kzp5NEH/ZrUxUuOG1Nh
	AG/W//EF5lWiQbrpYcRfuk/YjqBWxtnE1H7PzsbhwFhYyjZBd2AGUU38h/lcSLepC0DgmmDq8kf
	UrBNNvx9HSjMbL6dOxSmXQIqCYo7z5STT9PaqT5eOSWox15/1v3690lGhhI1ChPYZl8EKKRtF8E
	sG44aLb+gkThs=
X-Received: by 2002:a05:622a:180f:b0:519:51a9:fc84 with SMTP id d75a77b69052e-51a727cb368mr33707201cf.41.1782394588132;
        Thu, 25 Jun 2026 06:36:28 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51b12242sm69457131cf.29.2026.06.25.06.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 06:36:27 -0700 (PDT)
Date: Thu, 25 Jun 2026 09:36:23 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org,
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com,
	dev.jain@arm.com, kasong@tencent.com, lance.yang@linux.dev,
	liam@infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, npache@redhat.com,
	qi.zheng@linux.dev, ryan.roberts@arm.com, shakeel.butt@linux.dev,
	weixugc@google.com, yuanchu@google.com, zhaonanzhe@xiaomi.com,
	ziy@nvidia.com, Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
Message-ID: <aj0u12N_GzGtQT6K@cmpxchg.org>
References: <5790c4a4-d502-4180-82f5-47de5809a4fe@kernel.org>
 <20260620081017.89085-1-baohua@kernel.org>
 <4aa8350e-712f-4380-b3bf-2ff06cf2a35d@kernel.org>
 <CAGsJ_4xR0Ge707s8JAfd5Fw10+U+25_nuBGuVayx9qnxR+NnGQ@mail.gmail.com>
 <c29f90c6-2075-43e8-8f0d-0d6718a0f124@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c29f90c6-2075-43e8-8f0d-0d6718a0f124@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3C5348000D
X-Rspam-User: 
X-Stat-Signature: c3kz7z1r7mujesmgtcffbt1q9i3di4fm
X-HE-Tag: 1782394589-3565
X-HE-Meta: U2FsdGVkX1/E5vxQQ/CWeoop7ZUzIvFTrDLvUrZ5CFqxhMULZ2jK9MbAkOygqCcAiV5frzchD0Q77fIASdIvB+9BYpqFbEU3WR8hkLhASEZauG+4K+AephSiXZwxjKAvURQenbBMRq+gZn3DvxIkJWs3Z5GlYXMue6kEXILz9o4bIiU8Sgbz5u+vi63mPZoNdDeo5cdSuVsdTKBc/pSA2v9LN+3XQfP5Plo1RTL6O4y7Z/sSJZGnvInRD+LqClc5K/YFHYUuG8aCgBwjRfrMVoOxMd1GPMk+3RHojdp6LoQ/7oLok5V2L3rXuDOoNdfZI4+ZSVM1+kEwwCmJbOW2E/rScWG8FKGLRbcBHR6ERSBLxf3iubGNaW6+atDWS2SDOhN8fjlpjquiyxOa4ZtwUYgPEYw5SQwXWMpUi5NpfJucWroSl25CIOefh9SqpByvLovvTIHqKgURV/NiBFUawViBRwMOmdjfeI1XMiQmLWhW+BPF4wgolJsJbpQMq+D9E1wy7s1a9dvcErsi/NJRGR4q9+u5Ryy57q7kqhbfYgA7aWyoaS5V33guX7X/qPV+twF+WbKIjXlnDWfT0tr/DcGhfNKJ+GL43u7qfgK3r8MDNx5NtTqDaqOWYNVF2Y9eh/f2zY2m2l/WvnkuPqxDt8CtS9wykyxvkMWKo5MnPB9A3z6nEQ5jbJGv//S3GLKeZwnvFHjyWZMoYCOaBcyF37Z4rdc3eUOTBdvSBHsZsaWAl41o65//HegyUaCB8eHNAgfSJH0QXMmZk5Rypsr71l+mz37h5jS4hVeVCvOI9xdXDiztozpRErJJlyu443fce0gLHbs/t4o/0sb9nbGE+VNp4VMurg991jJJXJS2EhEpTWwXfkJH4ZqH1md6KnisOiU8weX3Q99lwg3CSPyZlL7Am1mUq2eaSeK8BVFxCnptCkE4WRptr2e5eCz3MB/DaIQGAGMHXmk+MMjH+QZ
 OXE4gkOZ
 pZJbV55JfvGdCdZWictjAfzJ9ueK1xPXgy6nSLyFZRH4JUHo758N/7jOU3fl83wtl8WaVYSzO31/mTFDWddph5USnX/vENEJPOyB33IhNcIEsRUYwSynsTu9WaunM3+yBdFnW9hSgWm1JJGBMh/RrXXnm5iCc6qgs5ux8QDUERiZ3SrKXKfEiG+uZijpHTFl5LUzLnaQ9ueU8Gyh9efaxVCctXS2LFihij1i55j5ioT5u8GEUgxpagg2wTc6nGa8ER6kprJURtTIPyqaouOS97RoTSlRWMaPaEHyKhIYi3yBya1odJQbx7SLDGjwOuuHCPF/BaRHbzFbucLiYGGht/3xRXqdgt11L1I0AlZQsJ0+zIEIholF+8bnSRCEsuwG+R/Hhltx2sr/5LuOERslXREmGLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 09:49:56AM +0200, David Hildenbrand (Arm) wrote:
> >>
> >> But now I wonder whether we would also want to check "is there any free swap
> >> space", not just "is there any swap".
> > 
> > I don't quite understand you. get_nr_swap_pages() returns
> > nr_swap_pages, which increases or decreases as swap is allocated or
> > freed. I guess it just reflects how many swaps we currently have
> > available?
> 
> Indeed, I was confused by the function name it's "free swap pages". So all goof :)
> 
> > 
> >>
> >>
> >> Essentially, try returning -E2BIG if there is the chance to swap out after
> >> split, and  -ENOSPC / -ENOMEM if a split wouldn't help.
> >>
> >>>       }
> >>>
> >>>  again:
> >>> @@ -1769,11 +1772,13 @@ int folio_alloc_swap(struct folio *folio)
> >>>       }
> >>>
> >>>       /* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
> >>> -     if (unlikely(mem_cgroup_try_charge_swap(folio)))
> >>> +     if (unlikely(mem_cgroup_try_charge_swap(folio))) {
> >>>               swap_cache_del_folio(folio);
> >>> +             return -ENOMEM;
> >>
> >> Here we wouldn't have the information whether we could charge after a split.
> >>
> >> So that would require a rework to signal this more cleanly to the caller.
> > 
> > Yep. The tricky part is that mem_cgroup_try_charge_swap() cannot
> > return how much swap quota is available in the memcg. Do you prefer to
> > add an output argument to mem_cgroup_try_charge_swap() to expose
> > that
> That would probably be cleanest, if that is easily possible. We would want to
> get memcg maintainer feedback on that.
> 
> @memcg folks: we'd like to know whether splitting a large folio would make
> mem_cgroup_try_charge_swap() succeed on a split (smaller) part, to distinguish
> "there is no way we can swap out anything, don't split" vs. "we could swap out,
> split".

It's technically doable, but is this worth the bother? The remaining
headroom is less than a large folio. You can split this one, but you
cannot even swap out all of its subpages anymore? From the cgroup
side, we don't need the limit to be obeyed this rigidly. We overcharge
temporarily in other places if it's convenient to do so. A fuzz factor
around the limit is acceptable.

But if you still want to do it, here is how:

The page_counter_try_charge() in __mem_cgroup_try_charge_swap() walks
the hierarchy upwards. If it fails, it will store the first level that
failed against its limit. You can do the mem_cgroup_margin() math
against this counter to determine headroom. An ancestor *could* be
more restrictive, so you need to finish the hierarchy walk to the root
and use the min() of all the swap.max - page_counter_read(swap). Then
return that in a return argument from __mem_cgroup_try_charge_swap().

