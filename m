Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89B61CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 06:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5008E0003; Wed, 12 Nov 2025 01:55:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99CB68E0002; Wed, 12 Nov 2025 01:55:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B26C8E0003; Wed, 12 Nov 2025 01:55:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 757FB8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:55:18 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CF1AB812B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:55:18 +0000 (UTC)
X-FDA: 84101043516.03.6E55407
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3B7C71A0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:55:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ilvfbFqB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762930516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+2aDAgNNpvmztVWzyWU67msD40mML9fNw2pd7SfUBM=;
	b=s5tt8mNec9aEXd2Y2bqcIkw6qyJnnbzZrKYnQzTr35r/pGQhhsWTYNxfs4cx/ul8JTX7TO
	eevVDHfCOWKkyTvgYo96nJtzo98z8Fee9UF1A9RTM/+QeN2C9qHvW4i+YZZ1mUI/0Jw8Mr
	dQ5QIFRFH0YRYac73hJ57WCNgGJC/ms=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762930516; a=rsa-sha256;
	cv=none;
	b=CKo1OJVWz8jDwyw467cS8l+RJM18pYS68UuoYkqu6NRnGC8P/QFel9sbOGqrEqXXPWUxzj
	4Key5/XvsrY0eyrWZ0p1uUdrZdHsFP+ijkX+m08Q60i4+MgTdENvc7/5tqcQZab/ORNC7q
	2EZyeq5+VaA5eSKxFpdWloBYePUty54=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ilvfbFqB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-78677ff31c2so4492857b3.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 22:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762930515; x=1763535315; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7+2aDAgNNpvmztVWzyWU67msD40mML9fNw2pd7SfUBM=;
        b=ilvfbFqB2nfhHGKI45FyqNhNHJ7ILN9HrLdeaD5qWjUbe2qJMhqFRNhR9l/UA4fcmu
         FCJlSqJz3n73MDfxnK/+MuLInvzf8UT7U2jHsdNM/OhrvJETD/465WpnX1vpA1ZtIEdd
         pIICszm31cGXJbhK1ZqLGkAhSwbcOELf94HUO7LoTkq/d1txWjN+W0fBSkukVMykyR9V
         VaJIdcqW0hRiN3r64lJ3ucqpXnKB/z7/OGD1LxgQf5XGfjGDvgGGz5Ai6Pxwbq9t/9YP
         5JWisgO2KV6WIFq0ViZVp461QPuXkoX9tBAfr0ztmP5gYBbVvuc4/mzeUK7HuPXLXZ+p
         LDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762930515; x=1763535315;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7+2aDAgNNpvmztVWzyWU67msD40mML9fNw2pd7SfUBM=;
        b=DEsGr1ZwbGjneYlwrlUP9XuTmEAS8haCSp6q+5KfJafxTFQjWbjyxwozsV2xxTzCf5
         3l8j1tiLA6fyozHLsSp9ZwEClDXPwP5YaWjY/CmZx8NusG/nTUYCqDlfw2Em0k024FsW
         vfOkm69XXr3FOpgPuEQzIeVFdpBaR9cMtluAemQIx5c4Z8bK7wKxYDzJ+hr5lzDdTro6
         Y/LLxtXa0rcQ4iYnsCk8iRyFZDw86FDRwE7T/CbXdbb+oasl4aRzbULFBiiJvLi883hK
         P/ik+2uNEXjXMvnbjOzzJLVjl3zuCsHxgOVdwEF80RS6wAG/mYa1v1H+rut/cqyMhhFF
         Uwng==
X-Forwarded-Encrypted: i=1; AJvYcCXFSMI+BvH7L1A0BFWjCckh5B47U6ULhU5rwoh1g3cqqttb1tHJuogcpjYEjHgvZCT3PU+dA2ozeg==@kvack.org
X-Gm-Message-State: AOJu0Yx5W2sF8/PmS2hgeNqKdVDndhMYb2hMKgAd+VQXvziugLXQlWkM
	xXm7YrW4QEsI9tUfabNpJNrBsgDSbW0C6XcDZnPB28Yf/6wFLGLiSAdZ2OxqUMEzhQ==
X-Gm-Gg: ASbGncuQuIV1ZTUSLmxok4yUReAMVfKnVMnv3tY+okXl+3/aIpgJYIzsooF7yINOQr2
	7QQH8BRG736WSz5PcwavJTDmwwk4UuW9dsBUe/BgAlPJMtHkuHKDbLlBHZ63k3OqvrW2QV3KkzW
	c64Prhu5JLVZj/R0+0CiOqxuNBN/sTJCGSoQntVNaKQKJrAXWX5SK/996CYOsYLAh52tEK8sMrz
	vZst9OprCmup1bm3HODkDRXP2kUtKzgdKV3jaBx0DugdGTcotlBnO5cKnKtg5jzprho8Vii/lAN
	o7VvEEbsKrWQ3tQjD/Vts8Ei7QBc/c3ErkHLN/+sCAMWQhsreB5dzxbpeR974W7Rha74TbXQAPL
	bVp0bwyG4tHBsC9r8SjkUA+rxNbV/LM9CZm93ZmgHmczD0ZKaiSH2/oXEL1JMRrvYqA2j8UDMeB
	+ekDyVtnPSpZB2hQpyOc0h6/zbrDq3XYd8gkVEzYY28E3pHZmsUxS55IXl7/IzGe/PbO8/JdyKv
	szHXwIUpg==
X-Google-Smtp-Source: AGHT+IGlVji64Q31PvxWDCE9wnYJAoL0csM/OHEk9a+ewKFIhSRNh79LwM5t6tm3Rf59bL7Nc/bffA==
X-Received: by 2002:a05:690c:6f8c:b0:786:6b92:b20a with SMTP id 00721157ae682-7881363f6e5mr17172437b3.24.1762930514888;
        Tue, 11 Nov 2025 22:55:14 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d69c0455sm39373027b3.37.2025.11.11.22.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 22:55:13 -0800 (PST)
Date: Tue, 11 Nov 2025 22:55:03 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
    David Hildenbrand <david@redhat.com>
cc: Deepanshu Kartikey <kartikey406@gmail.com>, 
    Vivek Kasireddy <vivek.kasireddy@intel.com>, hughd@google.com, 
    baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
    syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/memfd: clear hugetlb pages on allocation
In-Reply-To: <20251112031631.2315651-1-kartikey406@gmail.com>
Message-ID: <2a10f8c9-dbdf-7bac-b387-e134890983df@google.com>
References: <20251112031631.2315651-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 4t1qf1bgh7im335jea41gq1rye5gytzh
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B7C71A0002
X-Rspamd-Server: rspam10
X-HE-Tag: 1762930516-525834
X-HE-Meta: U2FsdGVkX18BfcydVE/xjPbUcgVFgfCUYcNjB2QxVEkOay0JQFt9N6UlsBts20qQNCGbanjdgSaALF5g1KhME1NHLJ8U4X2QSxRKmRARq7n/q4pg/8ObSC6y9o3JOep/g+Xhykk2j1IqN4chGcIDMlmCFqchp3ghxCOl8UeECsc5c+ccGnnJlXsNl12EVU9A664+9dkN9Kj8Qrl5uOgAlRxse6GAg6O+ZUTlzgOJpiN8qPKPqLvIBZfVWvp/UzRFbV89z1rU1/4EsA+Qo8eC2mt7TaZVC9YHiL6toB6Ven31nJl6MVRi2f4xOeR87xV9xeLoM6MkAp5zcqd61Z06PQVXqWhSkuAlg3Zg+HnEHNuxewPM0+lxkkaKWP3/qrNOp64yODSwdlj+dDgnTp7cUuMaMvyNxgY4Spcu+YIDrcfFEl+Hna59A420zYegCgQ1DPAGje7NyUyZPlQBfintKvMUh91rIbkDxNspyV+qa2nB+V+IKNiyP2aG3kUd9ACsrnRcw1SEUFybgxcD00wBHirZ5YzFIP+2QXpna2WAxBEY41sroKVc8xn6Lnx05j4Ob7LcFgeMY/ioIX9cB3HMfRUDWphisS9IK0iFgNID6bgNXlD4xBN5/jvdBz3MNmODr41N0wzrBSMqfDktVs0gZ2xFU8XiFqF93/Lbua5DnD21kJmj/mk8s0P/d1rBIgkNfbJxw5xfEabHAgf5SpJmB3l1dFKQPQBoskWakO1KdLJPh5TCkYAvgeORB8zuNHZCex6gQy4P9V4IcdOOLzOPyT7IfI17r2V2yzzh7LFrLkO/e+/PdBvUQDJSSukAa/hRd9IBFZPQXFHagaRE43WygdBVako58Z5N70sDGCgzbV9qUQ1hafJ1PwM2TIyF0sCpTEh1EgwvJvffrHVrz+f9mBhKFpK62HM0Ek9gRZxzsPXlx2bda8YaJ3cRvlob5B9K7rsEZ3mhimVE8syixAy
 DOxfoYOC
 nbeu8t88A+TOIQ08utE9vOWL77ytoTlDJjmauP6H76a0QZVyHCT05pLPk4Bl66UMDnB6jWbxy3r4lxI8jGXPs7HDWzh8wBb6Su7/QBOQyMDQ0D3EGjtdDpN9hS/+LD6ulxz5YXKkHbqklKJ6jnMZhct4ji8G4D0HgDyog0SLRJJIwzDwXl9RR+GgDDvbWsmkFG9FZu2kSRmnGK94cm8/ZWpo3OW5Pdsls1N1cQUZlkvFgQH62CzoMtIj+LvRokNS3sE1Wj9ez4MOPtMBOGIJqwdF0A9toSMSkZcxxmpwMuaaCcghsodmneh5/gSmLNBUGosj4kBEYq+lfU2WzSZx1X0Xv73H5Tz7pqgbWsvYi22kn2Bte/OcFQdMGWFm3iaIhehhqWiQQWPmk9FkILDdJwDCxTiV1lmtj8Ct5lvOi5EwJhjlk/gjmW/yg/z7/pmjjgfqkHgYBUoZy7j6EQz1NHa15wb2VFgofBA2y95HxXnx4w+5J6/hskGirHLJ6dOrFNiYLr4iib7JN8YP+DrWoyRFgYoWKXsffCbkh9lCi/HK6sIdFBImYbcsSkbsyRjisofU6EAyPVXZM2h54fixq2DCrYKZEEduzm24e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Nov 2025, Deepanshu Kartikey wrote:

> When allocating hugetlb pages for memfd, the pages are not zeroed,
> which leads to uninitialized kernel memory being exposed to userspace
> through read() or mmap() operations.
> 
> The issue arises because hugetlb_reserve_pages() can allocate pages
> through the surplus allocation path without the __GFP_ZERO flag. These
> pages are added to the reservation pool and later returned by
> alloc_hugetlb_folio_reserve() without being cleared, resulting in
> uninitialized memory being accessible to userspace.
> 
> This is a security vulnerability as it allows information disclosure of
> potentially sensitive kernel data. Fix it by explicitly zeroing the
> folio after allocation using folio_zero_range().
> 
> This is particularly important for udmabuf use cases where these pages
> are pinned and directly accessed by userspace via DMA buffers.
> 
> Reproducer:
>  - Create memfd with MFD_HUGETLB flag
>  - Use UDMABUF_CREATE ioctl to pin the hugetlb pages
>  - Read from the memfd using preadv()
>  - KMSAN detects uninitialized memory being copied to userspace
> 
> Reported-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f64019ba229e3a5c411b
> Tested-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Thanks a lot, Deepanshu and syzbot: this sounds horrid, and important
to fix very soon; and wlll need a Fixes tag (with stable Cc'ed when
the fix goes into mm.git), I presume it's

Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")

But although my name appears against mm/memfd.c, the truth is I know
little of hugetlb (maintainers now addressed), and when its folios
are supposed to get zeroed (would a __GFP_ZERO somewhere be better?).

I was puzzled by how udmabuf came into the picture, since hugetlbfs
has always supported the read (not write) system call: but see now
that there is this surprising backdoor into the hugetlb subsystem,
via memfd and GUP pinning.

And where does that folio get marked uptodate, or is "uptodate"
irrelevant on hugetlbfs?  Are the right locks taken, or could
there be races when adding to hugetlbfs cache in this way?

Muchun, Oscar, David, I think this needs your eyes please!  I sense
that there could easily be other bugs hereabouts, but perhaps the
lack of zeroing needs to be addressed before worrying further.

Thanks,
Hugh

> ---
>  mm/memfd.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/memfd.c b/mm/memfd.c
> index 1d109c1acf21..f8cfc2909507 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -96,6 +96,12 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>  						    NULL,
>  						    gfp_mask);
>  		if (folio) {
> +			/*
> +			 * Zero the folio to prevent information leaks to userspace.
> +			 * The folio may have been allocated during hugetlb_reserve_pages()
> +			 * without __GFP_ZERO, so explicitly clear it here.
> +			 */
> +			folio_zero_range(folio, 0, folio_size(folio));
>  			err = hugetlb_add_to_page_cache(folio,
>  							memfd->f_mapping,
>  							idx);
> -- 
> 2.43.0

