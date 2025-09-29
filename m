Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B38CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 03:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674328E0006; Sun, 28 Sep 2025 23:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64C208E0003; Sun, 28 Sep 2025 23:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561B08E0006; Sun, 28 Sep 2025 23:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 411788E0003
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 23:21:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDB0E57855
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:21:21 +0000 (UTC)
X-FDA: 83940837162.25.9FDA843
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6672380008
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 03:21:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LKU7g2Rg;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759116079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HzMeJR74NGpl3BsleICBKpNlFLh3HQZFamiJDXtI+U=;
	b=P14lqTrQLLy6TEDNClh+vHhho4oyc4nEMay4zWdAV04BRRKpAcd6elbVcjvB6XU4Q1ovla
	nSx3eWxjUSWApJk4ghqB9L8XRYQVUXrzHcb+CO7d+X3RZDL2sNtM+mRBrp8WCb/nXkxE4h
	ZCoiAW0igIexbznaS7ZAVesyrrppuBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759116080; a=rsa-sha256;
	cv=none;
	b=JSULhKWuOXlWsfQhdBdRI+6hncAAMwGTRAHPUmpPmFMx6ZMCz3/bl1FmDs9wK/9bFY7vfv
	oaLSWfKDSXRJqiVkl4wspm7ySHYqmwe0FzNEwD5jvRksjP305OEMjZ4D9+Sjmh53hsd5iU
	KlyROA6dbIQxBXQW/4JFBjaI2qFojBg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LKU7g2Rg;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-27eed7bdfeeso35517195ad.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 20:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1759116078; x=1759720878; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+HzMeJR74NGpl3BsleICBKpNlFLh3HQZFamiJDXtI+U=;
        b=LKU7g2RgNsuqeDzRNZmCkwCFZI511OyThaCh+XZgiuEd1puaPNE1ft5P9mnk35QedS
         uMJWFNKz8rY97WramkTLmAyZsDaGG0zD51/u0dn200Qu3/f8lHHPS1RYjm0A1MnYEfCL
         Q4YNmj4TAbkmaLVrHQ+sBmQojnLAIclyFyM6eGHpgXUoFu6EjaD+hc++ENFZGXl6AXRX
         xkGQUNiUMRR3AdZcffOcX3oEHRnpk1GVoWoOlEUlVxz+14+m3IGcKgEWkhcNqLoDjjmF
         VZulScSN5Ap+CF5f+sebSJY9n0LX0/gwB51LYEz33Z5ttDUndiZYkAG7OeUHK7Vwab8l
         /gww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759116078; x=1759720878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+HzMeJR74NGpl3BsleICBKpNlFLh3HQZFamiJDXtI+U=;
        b=fLrh/+yUbMki6gb3UOrwRDf+IKhb60CF90JHHIQwrkkuWZvHB5LEaVgKz1RZNWuKqc
         T+UJSUdHUVpIjGqy1qLCngEMzADHr/7pbffySnEYyztdEJVoSMxJ3DmaoBuS2ZCkCXrX
         ZTjixBgL2qv9PcA226Gowzj1QdueHODN59JICRs3N3BVYwFR+0y2rulT2e5hGNyGNEgH
         sehTfFBpfQSYAfkLkbA9nm8Mo5Wf3780rN5N/YLaTd0rRAScDdM3t4UILfBwYl9Y+7Qa
         3R2oL7sT76J2+f82+L5ifgWuS0IOp1f1RWgu/GHsTJlofJStFkbbatIYmTm/VVJpSa8F
         NfyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhDW5tq993XSJ/HqrMoCwHJg5wQ17+dXo2Tg0Rcwti3jIq+v8DY9T6NfZx2gAhTE89s3iQuO/FpA==@kvack.org
X-Gm-Message-State: AOJu0YxTYB5QwTqHZb/uf/uhUtud/7QQFppdRmiR3xrWmP8Gd+U1CaQT
	/fM7WM8eiD4TUAQ/ArGty0IohAzcXL4MwtT52L4h81OgMnJyKC8ssZDaFUqROHPatTY=
X-Gm-Gg: ASbGncuB7xHJHdHg8tTDdnRGkpHLkFbFJSa+zVD8dRh9h4ICcvouEB8W+UBcvD5uxs4
	w/k7HsWIgZupMMBhG02rk/yDelitX4+vhZkoTCqe0lVsX39FpBGgKuNZrQubWAi9srmYMKION/I
	yDwgiGvGtrRihTjmmZ5jn5o3gDpa8ORPQ0g5+NarGcqhlQkPhaXZysn8b1uT8XAm5wm50ZBVvkd
	pPts/i5uoUgiUPCAIsBh/CZT2lozJOia89F1kTGCsmXlRGZdIRZPeub37FPvyvE0hw5DTz2Xkr7
	/eV4eYz0NnVGff8KNzOj3hlHqLOPPh3pv4+Qe5Qz3V+FDatiJpoqrLgFa8vwvrvFzaGRtLHEyA5
	/ksKZsJ0bFgVAHPG3qdBDxFArATTKoPHLuU/hou5CoauIXOTNjw==
X-Google-Smtp-Source: AGHT+IEwGDXGEzpy3mjwVkfIZcUQVw7aO7XPMjfQI6cz4sCSZ3/q3fA5nP/zt4yK6sg9Fehieoyy6Q==
X-Received: by 2002:a17:902:f78c:b0:25b:e5a2:fb29 with SMTP id d9443c01a7336-27ed6de50d9mr153957695ad.12.1759116077957;
        Sun, 28 Sep 2025 20:21:17 -0700 (PDT)
Received: from localhost.localdomain ([2001:c10:ff04:0:1000::a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66f3820sm114012825ad.33.2025.09.28.20.21.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 28 Sep 2025 20:21:17 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	farman@linux.ibm.com,
	jgg@nvidia.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	torvalds@linux-foundation.org,
	willy@infradead.org,
	lizhe.67@bytedance.com
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
Date: Mon, 29 Sep 2025 11:21:07 +0800
Message-ID: <20250929032107.7512-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250901032532.67154-1-lizhe.67@bytedance.com>
References: <20250901032532.67154-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6672380008
X-Stat-Signature: zcghia9i5kfx6t31qqqxijyin4k4ouds
X-Rspam-User: 
X-HE-Tag: 1759116079-510187
X-HE-Meta: U2FsdGVkX19nObpR0fjg4tDq+Ys5W5Li0X4LsD2hzxgwlnJTLMuVEZRnh5bpq/3hb+KxyPbhtPyA+JzKGvUCbo+sQVuOJQcHXa7LmVK577wf4OFn7QiGr7IvE8PhhrPaBuwWY3ZgOdL8Lp9OsPUpLXX+yxRl7e5QhVdjLtiv2Y3dbwYNj9RsOMM7FzQ8i+4HI/THBFgbtvksLu+LFIF1QRz5TWN4rf0hmrDycuXUebhymftFXmbc7umCoy473/Ed+osgg59ogY859hbvb9AE/V6Pwl9qSrSU/D2gVm72trhlgk+Ebx+t0fdutzodFSTEek9qO0fJ8UHae0FuwNNokge2y+XMCcMxJX/ePY8PDPN/Lvb0U08GM16/6JmvkipPakqlHXULRtUyxZOAIR0SaCv7GaPGT6bQ5DE+xgIhevF9DyGVGXbZel5p1ExhFGF/2N5GbRjli/FhDv8HjRQ738+PkWS0LvWqRdIST8pnXITv90qDUE4nO3dtgoTB4syELWFLX/2yNGp5ZJ/Z4C/zfFM8kFJQQIEvrZP7QKXfr2Bf+7MeMw0+J+mhH1VxKSUxh07NRUOpwMWfl34JQhInr08PYqi74hJ6RInf9ZB43DAbK4A5BLC0O2l6grPGMasG8C1zmrs8u5r1kgqAYi7Ulk9p7oURFBOfKY9aHuei5LEwZF1pksUVwhQw4CarDzwTVlIv4QW0lRsN20xlhlY5d68BBXzS9dGQjjtOl8r2ZRtE9nnGp16ehDyHW/2rNOiJkgwoiFDGQ1GMpPySqnBAZLvXaAahDFXmjP/8dQ0gvXNq9v9IOQVE528zNaeQQegOQ8Es7kK5/QJ/SCEOsv4GaXO9df2Sube8X8dYvP/rxXUjfJgYhsVcUKQJ9l9Uc0kkHLzCcKtL3VF+vQi+wtcS000egq+iHpk3vuc4ZSIWmu6e+Oc+so41xXk3OYyulfoCazv28kKDDp0mD13ZNo8
 vjeQ7Qcb
 ldZ9za0QFkb53WRXhoyCZwZsCPdf1qFqolWgGdpVRQSiClxsgDE6hbjsV+HPtPBKjsBBCkvTomrthdUHv3kSI2fFEKOvJWVbaj3e98vggfunmwsZmHAZJfdJvznC688XnmtI51myp99iQCKIXxdZET59egvGIqB+aF54+UpAX5OeGjyf7SV6JyFuK9UaAVYZz0IUfi9AotbUySXj06QoJx/R3tTZsSnkvKzTCwDfFjX2/NC2cudWD0ZkxqOOlWZXDd8mJH+jXdj03uAkg2vmLLK9K6g8sIdfqmbxRfOEHiL4dOe5YDgVtHEVIBht6ZVa0M899jxCe6z+QVd80fBj6rqrYTDsDAKvff4PCcfldS5XIkHjTODT5DBcDPt+BJqN/s1p8snqRGWtfxArTjegLaWG88vIEm6RFzHkO50oppKbWsL+obO6y566tRK6aRRKqvRwJr3eyuv8b7rU7IzOOisWd5fsSI/3Or60d8Vod6rY86QtJHzX53cwTKkyld+4JZdYJTCbW4nvMPxIDKM06GAr67RFJLKFx+Dkf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Sep 2025 11:25:32 +0800, lizhe.67@bytedance.com wrote:

> On Wed, 27 Aug 2025 12:10:55 -0600, alex.williamson@redhat.com wrote:
> 
> > On Thu, 14 Aug 2025 14:47:10 +0800
> > lizhe.67@bytedance.com wrote:
> > 
> > > From: Li Zhe <lizhe.67@bytedance.com>
> > > 
> > > Let's add a simple helper for determining the number of contiguous pages
> > > that represent contiguous PFNs.
> > > 
> > > In an ideal world, this helper would be simpler or not even required.
> > > Unfortunately, on some configs we still have to maintain (SPARSEMEM
> > > without VMEMMAP), the memmap is allocated per memory section, and we might
> > > run into weird corner cases of false positives when blindly testing for
> > > contiguous pages only.
> > > 
> > > One example of such false positives would be a memory section-sized hole
> > > that does not have a memmap. The surrounding memory sections might get
> > > "struct pages" that are contiguous, but the PFNs are actually not.
> > > 
> > > This helper will, for example, be useful for determining contiguous PFNs
> > > in a GUP result, to batch further operations across returned "struct
> > > page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> > > process.
> > > 
> > > Implementation based on Linus' suggestions to avoid new usage of
> > > nth_page() where avoidable.
> > > 
> > > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > Co-developed-by: David Hildenbrand <david@redhat.com>
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > > ---
> > >  include/linux/mm.h        |  7 ++++++-
> > >  include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
> > >  2 files changed, 41 insertions(+), 1 deletion(-)
> > 
> > 
> > Does this need any re-evaluation after Willy's series?[1]  Patch 2/
> > changes page_to_section() to memdesc_section() which takes a new
> > memdesc_flags_t, ie. page->flags.  The conversion appears trivial, but
> > mm has many subtleties.
> > 
> > Ideally we could also avoid merge-time fixups for linux-next and
> > mainline.
> 
> Thank you for your reminder.
> 
> In my view, if Willy's series is integrated, this patch will need to
> be revised as follows. Please correct me if I'm wrong.
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ab4d979f4eec..bad0373099ad 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1763,7 +1763,12 @@ static inline unsigned long memdesc_section(memdesc_flags_t mdf)
>  {
>  	return (mdf.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
>  }
> -#endif
> +#else /* !SECTION_IN_PAGE_FLAGS */
> +static inline unsigned long memdesc_section(memdesc_flags_t mdf)
> +{
> +	return 0;
> +}
> +#endif /* SECTION_IN_PAGE_FLAGS */
>  
>  /**
>   * folio_pfn - Return the Page Frame Number of a folio.
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 150302b4a905..bb23496d465b 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -616,4 +616,40 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
>  	return true;
>  }
>  
> +/**
> + * num_pages_contiguous() - determine the number of contiguous pages
> + *			    that represent contiguous PFNs
> + * @pages: an array of page pointers
> + * @nr_pages: length of the array, at least 1
> + *
> + * Determine the number of contiguous pages that represent contiguous PFNs
> + * in @pages, starting from the first page.
> + *
> + * In some kernel configs contiguous PFNs will not have contiguous struct
> + * pages. In these configurations num_pages_contiguous() will return a num
> + * smaller than ideal number. The caller should continue to check for pfn
> + * contiguity after each call to num_pages_contiguous().
> + *
> + * Returns the number of contiguous pages.
> + */
> +static inline size_t num_pages_contiguous(struct page **pages, size_t nr_pages)
> +{
> +	struct page *cur_page = pages[0];
> +	unsigned long section = memdesc_section(cur_page->flags);
> +	size_t i;
> +
> +	for (i = 1; i < nr_pages; i++) {
> +		if (++cur_page != pages[i])
> +			break;
> +		/*
> +		 * In unproblematic kernel configs, page_to_section() == 0 and
> +		 * the whole check will get optimized out.
> +		 */
> +		if (memdesc_section(cur_page->flags) != section)
> +			break;
> +	}
> +
> +	return i;
> +}
> +
>  #endif

Hi Alex,

I noticed that Willy's series has been merged into the mm-stable
branch. Could you please let me know if this vfio optimization
series is also ready to be merged?

Thanks,
Zhe

