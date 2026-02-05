Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E766BEC1E9A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350E76B0098; Thu,  5 Feb 2026 06:04:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D48A6B009B; Thu,  5 Feb 2026 06:04:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D34A6B009F; Thu,  5 Feb 2026 06:04:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7A06B0098
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:04:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA80B1C1E6
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:04:13 +0000 (UTC)
X-FDA: 84410118786.06.A5CA63A
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id C1FF6180016
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:04:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="0jhD/C/s";
	spf=pass (imf24.hostedemail.com: domain of 3KXmEaQkKCIAepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3KXmEaQkKCIAepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770289451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89hL5xRbrc/VbCzks41N6CYINZBf+zOJ4ZeQZ8mSub0=;
	b=vcGZNYYCgCXM+yY7+SMaST/ZoKTpRJTGg9AA5JAurKgBSrEy/e1mAsTXQG+WWHXkghitfm
	uDKakSMry6h0VTm1t075qKC51zReeqn3s5Pe0ayFQhXoNjYx+1n5mHfx/QCHNYBRiowiEP
	6ZyXvz3vfW1tMGuLZF1IBk6Zav4HbnQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="0jhD/C/s";
	spf=pass (imf24.hostedemail.com: domain of 3KXmEaQkKCIAepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3KXmEaQkKCIAepmgiv2lpksskpi.gsqpmry1-qqozego.svk@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770289451; a=rsa-sha256;
	cv=none;
	b=zDXck2nbqOFhCpG+0xhi091ITcA7Q8wJ9cDj9kE7ZwuVixOtLdeeGY/aQ/GwQkoHT+ZaVR
	pscPpNwOZNfeZOqH7yNFcdAECj8oRnGWzNIREWd2JAUjn6+lT06OQVsVI+/HyZazbjsoXC
	yW+S6FuxX+JnXzQWz2mRND4f7gYDc3k=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4806e7c4220so11261355e9.2
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 03:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770289450; x=1770894250; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=89hL5xRbrc/VbCzks41N6CYINZBf+zOJ4ZeQZ8mSub0=;
        b=0jhD/C/sUf/ihR9jepADO36TbcqllsGyjndRteO57RmFQWgczkX+DaS3THL7651pDC
         LJAs7EjPmN0pZD1Gef7hmybGgX3rXHqLSCBytETIu28YzWAn3o/8gLuvIWby2bcNx8JN
         1jTWYZBhkOIMp8GYOdFwFn23x/TvJXGY2KByigfxxPNKq0rScJFr7CurojNgqcRksoJ7
         LlAhF9XZlY+C/2bvsnrJ8OReU7fdl92RW5+CwKRXXGHKDCEqBXADp9yfJh0dEzSrMWSm
         qaSKIHswTJHFadgNaCeriNurn5FlIRBK3xFmg1DTMWEhIHQm6ty7lD/LIhhpeQliizlu
         Pdrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770289450; x=1770894250;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=89hL5xRbrc/VbCzks41N6CYINZBf+zOJ4ZeQZ8mSub0=;
        b=nxUcqDP20tgLShBnvNTtsygc2+/9zGFBvC9XZKuHFVGxm/11Ar41k/HBntqQmxgEl4
         TQMjkCqaedDFknRjgkqZS5ZoDMYt8mvGFu5zmHKX7IM/fZSoKXe9oKURok+sA2jY8Z6h
         uUtoxTG2XBTREOct3jy4lqLi3JwHMN7YEtXdP/g6N+k191k7eIPZoWGBzdP0iJj8N0Zk
         +ReYeRIqJKTbs17ITwaEiYwyWzud+jC48pB7AswzrMwshTcw+92jmRIPNdqodWmSLunM
         x9CPuslPcxaUJwK4XO37kLTUS6IB5Fm5HO5T9E1U8XH5DOpNMVqsaWjqGGK3zd5Z41Bn
         XLCg==
X-Forwarded-Encrypted: i=1; AJvYcCXHs4ahT6+iPwoo7vXCPb0EB5dzvy3sf6WbXkj8CFqUlF3T2f87k2YzP152SMAlSfcNBUoFguDSXA==@kvack.org
X-Gm-Message-State: AOJu0YyqruFNFWe8YPZA/a3B6LTKMvvjMB4ht/A9WrtScGatiwXPBYR/
	2PrIFx6NYfMWFqFIY+AVII2I2jkZ/qXBcwK+rQfEDyhUlnnXEu/45tw8Mx5/Q6CnqO4OeX7tZu4
	O/BUxLcdsu2kqJrR1JQ==
X-Received: from wmjt15.prod.google.com ([2002:a7b:c3cf:0:b0:479:2d82:5535])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:35d5:b0:47e:e8c2:905f with SMTP id 5b1f17b1804b1-4830e926302mr90738135e9.8.1770289449847;
 Thu, 05 Feb 2026 03:04:09 -0800 (PST)
Date: Thu, 5 Feb 2026 11:04:07 +0000
In-Reply-To: <d3dca137-2e4c-4a1a-bdec-63cc2477bfda@kernel.org>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com> <d3dca137-2e4c-4a1a-bdec-63cc2477bfda@kernel.org>
Message-ID: <aYR5J0ip2MdD3nMP@google.com>
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
From: Alice Ryhl <aliceryhl@google.com>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 3hk1h46x5bm35nptgprkyp8jgpehj6oz
X-Rspamd-Queue-Id: C1FF6180016
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770289451-608356
X-HE-Meta: U2FsdGVkX19wtvJpCG2XfuZ0jYChDH9jU+BWpLnz6RzAgvaVCvEAY3q25nof1Al1G/1Vz5cxOFQN8sPe+ZI8vJQWooXnZR61XyzgDFwUTC1Zypfel84KodGFtaPePufyrlwr8wGKH/ODy4we36bwM+ldsebz0KCBwaAHVrxkUvvkg0XHVU0Jl34InVkxonPVCwXbR5pAQMYJCfAVHcxlWQHteo9RS97OYRiky+g+ZM6z9QDS3AQKP4KPPsDw2oj9J2X2EgdBeTVLTZmfiCjAjvmIPw4/Bu8AqBbOvotJbBxbN3ya0pfSbwT21LrLXrpMKjnZfu2e49sCfp1SnThRjq8OTVAUSHKtt8+VJzfRufLzfQMdZLZ/kkupWn6wqx2lK9wNK9x53UvEGggnVJQpBsVkmG4oZJKphNo85MVOHT+9+5bM8yKTVKkPdd9vZ0x5nMNEisNNDsq7icjy2aDM7RiK/+S08RzIxzy/pOFJzd/KLK3gSmZFD5U631H5FG8ca6wp6WFnLyJKaIzJOH/8KrQ2PNLVOVaMBMoJv/Qn3ybJJQc1jSGfew8Lb6KZhEyqh7+W6Mr+d6Pq+oOwG9xZF8SlVaYSRvKSkK/8i+NbqZRibRKS3fYhlRWM8VTIoPItJL33LFQ92pIa5NAFxgZBOoAUeBkiqkvbKu8Mq3xhWpN0IZkw/+DmDXYGKo/iW5wqzC/1kzddyRpq7iugG1aGWe12l3TGduYAOrX38f21F3KvaLOBsY6JmrYAz3ZpbgLoagkQjad3F5BD+5ZL8sllBwBw5BO0hkiKhBCTMi6HUFNSdZHURpKlKZf1ZsYZputd1a5YnzBEOiR//pt/MIxUpK0KOCiI/1Q134nBq/TAJu9R0nyw8OIZoLzUP//yQHgfC6ZZ3rY9EPGSfk2pvXywxZqP1Fx4o4ZtgbaTGlsyjb7V9IWTwBa0F2x1RSLCth/Wqa5P5IRxEu4FhH4N10C
 c6Daa5r0
 HUHQWaqbBN0U0MNII/XWe6sDoBQyqCQMIJITV0ShpEik7BKnzhYktmdQts9zqk9W0MzcgJ7frCdLvyvGdFTZkQULuSuBPHkOBenAjdVwe3nUnFcwOl1ajbiI9klX8d+WIGv0JooDhHAbG858Tb9sUGuRRxmXREgegE+5upa/FacxHTHu43VR0QZHBMEexU1L+X3T3q6Iepa2/OJ8JyPkK/EsHf7BxErTxjIUOt40OTDQ5tPLA9sooW1Kobo7J1rH3BMgQszLj3vEkza3C8e3HwzqSbUKmIaJjAxBw3V5BM39rFkniUPyaUCA7r1LssqKn0kxC8mGF6900PH5/S2HE5QsQ3Pnp9Av3T41PmpmS02PDgq1/Qgq+pcWVlU28eAE2QVbm+3sXA28CzTbC80QGhn30OssAG43vqKWGJ2V2iSlDWf9SK93F4mSAWJ0/eKlnlqIlMilSRNdrVpcAlX6/vTHNrOb9YmPaJprJMxycKdxH5x9ZAVcH5DaXNoPb7uXxUV10Xs0aO6T4Faw4mrZWOAIWGRueuKJihDyn+xRHHvJYxXY+rkAFnrGNy5BVIIKfT6wkTU8R582IYZ+tUdyPZahcBgtIEyjWH92jEKJQ/jpWqduFpAMxvJQaq3jwAsy2t8ZE95Xu8j+x07NvlIqFs62M0NraQXO0Bio2P0J+wcHInUVTY5bQajZM2N5rJ+P7N/DgEupt3u/nK6Sg2eGWPr1Twg5rFQxBGx37+5n272fn+aoRztQCmXYNSJ0QuTclzI0I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 11:59:47AM +0100, David Hildenbrand (arm) wrote:
> On 2/5/26 11:51, Alice Ryhl wrote:
> > These are the functions needed by Binder's shrinker.
> > 
> > Binder uses zap_page_range_single in the shrinker path to remove an
> > unused page from the mmap'd region. Note that pages are only removed
> > from the mmap'd region lazily when shrinker asks for it.
> > 
> > Binder uses list_lru_add/del to keep track of the shrinker lru list, and
> > it can't use _obj because the list head is not stored inline in the page
> > actually being lru freed, so page_to_nid(virt_to_page(item)) on the list
> > head computes the nid of the wrong page.
> > 
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > ---
> >   mm/list_lru.c | 2 ++
> >   mm/memory.c   | 1 +
> >   2 files changed, 3 insertions(+)
> > 
> > diff --git a/mm/list_lru.c b/mm/list_lru.c
> > index ec48b5dadf519a5296ac14cda035c067f9e448f8..bf95d73c9815548a19db6345f856cee9baad22e3 100644
> > --- a/mm/list_lru.c
> > +++ b/mm/list_lru.c
> > @@ -179,6 +179,7 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
> >   	unlock_list_lru(l, false);
> >   	return false;
> >   }
> > +EXPORT_SYMBOL_GPL(list_lru_add);
> >   bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
> >   {
> > @@ -216,6 +217,7 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
> >   	unlock_list_lru(l, false);
> >   	return false;
> >   }
> > +EXPORT_SYMBOL_GPL(list_lru_del);
> >   bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
> >   {
> > diff --git a/mm/memory.c b/mm/memory.c
> > index da360a6eb8a48e29293430d0c577fb4b6ec58099..64083ace239a2caf58e1645dd5d91a41d61492c4 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2168,6 +2168,7 @@ void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
> >   	zap_page_range_single_batched(&tlb, vma, address, size, details);
> >   	tlb_finish_mmu(&tlb);
> >   }
> > +EXPORT_SYMBOL(zap_page_range_single);
> 
> Why not EXPORT_SYMBOL_GPL?

I just tried to match other symbols in the same file.

Alice

