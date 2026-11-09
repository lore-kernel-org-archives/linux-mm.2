Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12088606A323
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 08:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tECy3jvU
Received: by kanga.kvack.org (Postfix)
	id 24AD46B05B2; Mon,  9 Nov 2026 03:57:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5076B05B3; Mon,  9 Nov 2026 03:57:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076206B05B4; Mon,  9 Nov 2026 03:57:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3F0C6B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:57:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56251120475
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:57:50 +0000 (UTC)
X-FDA: 85414977900.02.E724A9C
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6B483C0004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:57:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tECy3jvU;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794214668;
	b=iqEEGp8zNOPjwqu8szawntWBa4o3s4PN1if4dGOKRJZ4P/F47EG+q5EjQQZJAHF3bD9EYD
	No2AQywaPd8WwbrERjc0ghmEKBprmEw8uCn6dh32Z7DbC+Mvy+tLpPqnU+GjREiMNPS63z
	N2KeOKbsTYlFtTC+JfsvkolE/ktAf3M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tECy3jvU;
	spf=pass (imf10.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794214668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6gPNbhKnS4UiPYe9GkhcEdm+Vle3xI8UXMcC7kdMJ/8=;
	b=X4sL+wAx+LoTfFLpwRoEKejiHeekaxCo4xDF1ZD1eB5h5CHdiIwdMNDdObDwOmJ4nXGE2E
	dyL3sk4bFhu69oG3bR92RWXAaBJ3/pox4hV4XVB1dNIILj8jqUQZlfUPaM9ekDdz5x1ogK
	3L4HsWxRtTfEUvzEUs+q6FTUmGrhVjo=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so7505595e9.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 00:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794214667; x=1794819467; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6gPNbhKnS4UiPYe9GkhcEdm+Vle3xI8UXMcC7kdMJ/8=;
        b=tECy3jvUdq107fYbmxj7krVkltbfX5l/yPqEhhUDbCKuKiaQhtuSGlKY59eijLwhFn
         hbk30apVf27c4rJDjrz4n3R9tgTVVIIDPPaNUZnTm+jMIG1aWQGislVT+wpjZJVxZLzw
         GtBNhRm57kljFM4XUgO/DKHQkXi1O1cjRpG5daIgTNggHxuC1CyGYVRl/GIEdX6KCuHP
         QwcbY0c8IiEETz0272JeQd/gwSITIDNXyEpinDJlo+VnpXaWwXf4lOIQgA79yDwvAiva
         hnQPWpZ2LfUIq2M2spAW3Hq+3E/uhadfL1P/Rt+Q9HI1ZA9e/IXIVo/TAaKFWmD+5m7p
         ds9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794214667; x=1794819467;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6gPNbhKnS4UiPYe9GkhcEdm+Vle3xI8UXMcC7kdMJ/8=;
        b=HV6JRu+LvFulBiKDgTRMT94ZClCU4nTygUjx8AlzkUYs06BUs0Nbjmkxw19p+ESJiq
         sJI1QY5HZfSYN5a0/4RULMHsp4qKZj5cpWrE0VGRIwMD200cooQj1xyNIl8h10dUYQVz
         /jQXAFtC5zCeQ8zoZzk+mcHVnrobKnXCP7yCB4PjDFT37cJLDHJUDVZNcJpr7NJbcwSD
         nOIDdN1Y9Ay2wZaCQrhlePiw7jqJqfOhg186SrqcumXTB1k4jJ43m8PxYW5VVdIhqXgV
         8X4nyPfIfZRhBDIKtN737PDDEug1/4r/fxgdfLddgsD3HkEAP4pY9bmPctB+sbFh1SeT
         mMSw==
X-Gm-Message-State: APuU4Z8vI+H4FeXYLodqCTXyLPQvoYb2H+sjww6WYPCnwwtW8AZr8yFX
	QpxSKYYUbiKjeWczv+xLqrcMAhmaBQwa8vn0nD/g4bTIImtyi3ksoua9
X-Gm-Gg: AYBFou0OFKVOxF70DhtoUJye8hCVFUeLytD4FG+2xJbksNnrUFsIasTWu/PmEFCnBga
	FleQsVlfj23oLpTSbJy4VTSh8BljFGhpMoEwHGCAq7gZ2YrhvGOQN4s6gQb24w2tHobFbNIEUcK
	tEB2Np++5RCaV3XMsxEdLoIrt++yOFtu42YY6h7v1t5kNB3Frd73VKIivotyiD+lFN9wQLRQ2rb
	uMf9csFXNSHR+o/0k5Ytm2m+8YXvsHIzfCOV49uu0UhGoK4lJih6cVyUEbUmeOtxHpkoEFwoG1H
	1kCl2ieATVG6w0eKnrMWHUBELs6A7pLBfLSDdiayFGNUsBGKKH+U4S5VzLg75sl0C4tY002fr7v
	8s1rbze+v8s7qpFD00tEN31PjK1so7ldPUXYJuBaORTWoSAGC60hft4Wsc31dP5jGNgyOjpy26E
	ozQvZhOcL+lOMoQMa1+xec2Xyu1/JxTMB3UuchaZOxbM0mUrawtbzKfoZksMm2zYOMzRmVJxHv1
	HjydoczWowXbn3tHEslD8r+3M7vTTErxqy1IB138i+aK4qXt3X1Yjmz3L3hbxNw1fe1ykCCVrYz
	4r5MNvUuzf4SlkDWpigLLW4=
X-Received: by 2002:a05:600c:4f86:b0:4a1:fa21:fd90 with SMTP id 5b1f17b1804b1-4b960d9b17dmr61969495e9.9.1794214666809;
        Mon, 09 Nov 2026 00:57:46 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b79501502asm149200295e9.2.2026.11.09.00.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 00:57:46 -0800 (PST)
Message-ID: <a9fb2d3c-d518-49d3-9479-a25fa2cfc5b3@gmail.com>
Date: Mon, 9 Nov 2026 09:57:43 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm: limit pagecache folio refcount when splicing
 into pipes
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Steve Sistare <steven.sistare@oracle.com>, John Hubbard
 <jhubbard@nvidia.com>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev, stable@vger.kernel.org
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
 <20261107-refcount_overflow_stable-v2-2-c38f6809b106@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261107-refcount_overflow_stable-v2-2-c38f6809b106@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f6r1dca4ukyrzicw1aq81acdqiackh6r
X-Rspamd-Queue-Id: 6B483C0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794214668-217144
X-HE-Meta: U2FsdGVkX1924Aun9w27Y0XCww2WAIxpEmz6IXkgPEPjc5+/+GTIrISU/XdvR3WUl4/JwyKZeDBfxHQLQzMijWqSPkqhcuEhPZYH9FCidNwO+I/cHLKah26rHNrdjjLdlJG+3I3/qBzakIY9xJmKO7I2htJD4BVcVjT1Ndj7/TQTuYekz2qxXlU0ckx/au3mMSZeF/FXzEJ1mDTvM+f+zbjWp+026/Fq2mW7OoYJLr8o8gNqwYPltgeiHaJc9pw7TPF8X9/uNPfELTwVKJkS1gY9jqo9LOHFaNUSjTQhws0D7HvEwEvL31GQ0PhBRP0XD/xYTFi9Ri+kp8cSUscuA2Eg6Wput9zwnrLeQtVzPiX2G1feV6QHnso+tJhM4WEiy+JV+J6334VJDrgQcooMqDQQWwNCoDvBQrxMjHCbhlvz7kqJpK/ZrrhOTP6FJLncnqVgYcEDu/dHLP4dLo5FXRjNzuNddlEKRBUHR8VUI0Aao/2SYDuKWLNZlXmceKq5csU75aytYwhEHb7vX66QioDYzHU430zL50QZT9zTfdj9s8mPS+9uRViy/CJqIHN7jLBoKl9hkv/UJO2xdDOYi1AkY0YndWTZg4O4xqu+0okD627XdZyf79YgjWLLR7L6G07tN+T1BEbMHmJq/fkNBipFiT/kerk8E1gp9+YcguGzaNbTzwVN6SSbi2sy8OQf32Ly6CEpkAYZJUYNgnyDRIO4qgT7JgRhzox8S9HQpaK0NfBWMyuogQvs5cUOilUVbCyR4nXHY2l13uuk1H39IDTLS9ntNEpuaWd5dsg1YtIRSfQe+6bZK1dtSPFfzUpoDhj6lychel2ba61lUCo6u1qx6FtCEroyuW23pVibPaIqFSjMaVoqUebRSqPNccC6OUDxqLTq8c1iku4/FIBE7rMHDZ+VQzvbnQ6pj+NLFqwZsKIq8VsBdOAje7k6QVr0dh6OHPV8plzMI4/jBv6
 1ygcZ+Vp
 X3ScHef+as9hJek/XCz+kdeE8sbQmm6b/D6vPE3nZzAX1ug3YTkPH2mpDS8uIKskpLB2TxXgvkQnErBOc46LxqFV/7k7v9t48CcdLspzehw9J995wpxzPWB6G5AYY9KdDPTf9XM4M3CwOFQWNYhI+NnYz88n7NGlrhe4dI2gUgXTKCtQrppAKDfpsypUVJ81sDkQa1r9hT0HUoeANbRus0uhuUHzje1WrAjvn69bz9ehyFbsW1HA9kwlZNJiFQIjOv/AFoKHe7PjeGGsKENMsgbczcUEAy6SEAFmE7srG7s0S4XnFt+Kpa5xmnvnd+X7cRWYdbvH8oGHJbhuBNDjMdgvBYaB1nzHVO/MsdQ10M05Dnk2+eZnWQT2030maGKJKFFQDihcUqkbY3UaG9fc9yuRMaYebIKu70sk6ZAV9BqyJSeEND6n7+NlNxjf+yXDQV5b1tZfikS8FzU5DyfZUGnj8Bk94yJsxYh7de1ibEknT/0IGKkkaY+lcRTt03lwW/tf0t9Q1M5TiadoaUGYZPxvrSjLdbqULmVv+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 11:23 PM, David Hildenbrand (Arm) wrote:
> Similar to mapping pagecache folios into page tables, let's reject
> additional references when splicing folios into a pipe if the refcount
> is at its limit, similar to how we handle it during GUP.
> 
> This will prevent more cases of possible folio refcount overflows with
> large pagecache folios.
> 
> Let's keep it simple and check in the two callers of
> splice_folio_into_pipe(). Return -EOVERFLOW if the limit prevents any
> progress, so do_splice_read() can fall back to copy_splice_read() when
> read_iter is available. This keeps sendfile() and other splice users
> working when ordinary reads would still succeed.
> 
> Also fall back to copying in FUSE when taking another reference through
> fuse_ref_folio() would exceed the limit.
> 
> Also check in try_get_page() to cover pipe-buffer duplication by tee()
> and partial pipe-to-pipe splicing.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  fs/fuse/dev.c      |  5 +++--
>  fs/splice.c        |  8 +++++++-
>  include/linux/mm.h |  9 ++++++---
>  mm/filemap.c       | 11 ++++++++---
>  mm/shmem.c         |  4 ++++
>  5 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 3641abb90d6bb..4f6b7b42bfd3e 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1265,9 +1265,10 @@ int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
>  		if (cs->write && cs->pipebufs && folio) {
>  			/*
>  			 * Can't control lifetime of pipe buffers, so always
> -			 * copy user pages.
> +			 * copy user pages. Also copy folios at their refcount limit.
>  			 */
> -			if (cs->req->args->user_pages) {
> +			if (cs->req->args->user_pages ||
> +			    unlikely(folio_ref_count_over_limit(folio))) {
>  				err = fuse_copy_fill(cs);
>  				if (err)
>  					return err;
> diff --git a/fs/splice.c b/fs/splice.c
> index e6d43329ed3f0..df73a4e65118b 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -956,6 +956,7 @@ static ssize_t do_splice_read(struct file *in, loff_t *ppos,
>  			      unsigned int flags)
>  {
>  	unsigned int p_space;
> +	ssize_t ret;
>  
>  	if (unlikely(!(in->f_mode & FMODE_READ)))
>  		return -EBADF;
> @@ -977,7 +978,12 @@ static ssize_t do_splice_read(struct file *in, loff_t *ppos,
>  	 */
>  	if ((in->f_flags & O_DIRECT) || IS_DAX(in->f_mapping->host))
>  		return copy_splice_read(in, ppos, pipe, len, flags);
> -	return in->f_op->splice_read(in, ppos, pipe, len, flags);
> +	ret = in->f_op->splice_read(in, ppos, pipe, len, flags);
> +
> +	/* Fallback to copying when hitting folio refcount limits. */
> +	if (unlikely(ret == -EOVERFLOW) && in->f_op->read_iter)
> +		ret = copy_splice_read(in, ppos, pipe, len, flags);

here it can't tell where the -EOVERFLOW came from, if another file
returns -EOVERFLOW (i.e. tty_fops uses copy_splice_read, and
n_hdlc_tty_read() returns -EOVERFLOW after dropping the frame), it now
gets a second read. also, the first read already lost data. so the data
read returns different data, the dropped frame is never reported and
returns the next frame instead.


-- 
cheers,
jose a. p-a

