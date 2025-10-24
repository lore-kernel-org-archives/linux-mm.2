Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCC2ECCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376C28E00A5; Fri, 24 Oct 2025 10:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E598E0042; Fri, 24 Oct 2025 10:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264338E00A5; Fri, 24 Oct 2025 10:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEA58E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:33:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B60E15D9D3
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:33:42 +0000 (UTC)
X-FDA: 84033251484.21.392CFC6
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id BCA0A40011
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:33:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N9qQVspe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761316420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBa3HllmoLDrq9FnY3XyxI3+B1m8MLAu+gv0tRm7xcs=;
	b=NJyaTTC97MtxfbmWqZZvMhCoRtacd+Z4JzSwnZPvUJRdiSPRekOpza2oNHWZyM6eABX+x2
	Rf+ZGm7tr9cXcfAS8d/DuvQG+1+2+vuSvs9A/uzcAsUpsSWXw5UoNAs6VfbPaWsuubaUX2
	EYkvcGdrlGIM8+8gJ4zhtryoTRaeB3w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761316420; a=rsa-sha256;
	cv=none;
	b=EFXtKtT1vh+INr/a97xnxeOU25/4X93ETlCeAWnhMG/PcnY2yE/rkSTsCrw3jEHIFFJLO0
	g3EximtbtJfwUGRJgWKU+l5cOl+R+P3jCKURblco/CC4XLu7Fec7oVfgp0TGwKl8i+P8lR
	u35ybwT3n6vH8bSKHSsg6LXjDsxC0ec=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N9qQVspe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-33bb1701ca5so2111578a91.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761316419; x=1761921219; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OBa3HllmoLDrq9FnY3XyxI3+B1m8MLAu+gv0tRm7xcs=;
        b=N9qQVspezUMqtKD7jN/Y68py70eot/dLrDAlPc2XgkNL9HW5zkjSaPnhSiAyT2bUY1
         xmcwtocAUjHpOromP2qhagJNHaUoNrrWCLTcgVEbrvq2bjuYqfYbU/QRVMYwX3+DKd8c
         90f5TpLYJhD26BpWQVeYCaXeYzVvG0v0cCscMcEHilm1mrkfODUJTDb+DstzI3wLzmYo
         xZxysJcnII9YxCLjkB3GubH9Datg/lxMFd+YpvBHYmj1zVLPxtWwUrKcNXpBhWBZI/WS
         7m7nIdFIoyaIOMFXuvo5bZPmAztIQI3CRYp3nju3ELnyhr3TQ2tFKu9T0VPGbkkC2Lyh
         0HRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761316419; x=1761921219;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OBa3HllmoLDrq9FnY3XyxI3+B1m8MLAu+gv0tRm7xcs=;
        b=hFYpv4SqgZ0Wj5RQFaTNHmFBiGSm5MBr66iA2KnDMO2dgaFQHnIspnSS7iiBL8YkOL
         jIiZ+aMydxpnLdiN6gtsgzIX+FDx+GHbvYwz0odTBKOMEmH8l7osmT3hCgJazwbPtusw
         ThOmPuE6rgDdU6FvcqHPrYNYr+jxo/AnM8Ip/kiM5H6YO0dpovoSy4/U+5qXjO5l9Mcj
         pKFbs9FI/5sOHEjO4xd2uixnQnoU1/7MZ9vxcz/BkDKtgrJsTZKHN0DSSz5Zensu9qVD
         sIDvb7KnSsyWZA6ggGtQm2gjls9pej9Tk16hj5trK+ghaWO1aklGuUtTI/nG8Clr9MN7
         IPYg==
X-Forwarded-Encrypted: i=1; AJvYcCWfd5KKrMP2pDLetS8Akn6f4rI1D65hZpHLrXL/vzKL57CgS91mB0Abpq6fiZEZayz7lIKt94MKlA==@kvack.org
X-Gm-Message-State: AOJu0YyBqbEok+yTW5hYaUOjv6HSUtIgG7ntJqFU6QHamGj5SuYC+gHc
	xXi1PnIkapKYEcHZEhVxr7Q630/M+mEng4Lx+pNF7EsxsX5V1NGxVaZ5
X-Gm-Gg: ASbGncvvMa9Ldm5mZTexXn7CJkaRjqvBntkUPuSMGZgp6zSC1x/SzD6LgLf9w1RHcvc
	L6tNwnMVKw+elHYyaSbzBuxUWy01QijH8vVE6nwfTdSP6WQ+ydtpdNBvaFA9StOB5rHY6Jj8TA3
	sisWXWfv6KZJaWnmo5IiADwJW/x2aPB/9mwhaplhkrt62oR2F5fNgE4D1pgByWVjnxeyMepAzum
	Cw9rpVFKqh+fSyli7ombb1j8S+VKJXhKSQKTdZK1DcBON/xMcVWDF9h+cqgQK599QOaave9Nz1D
	qISELZLAkhemOF6I38+Dkz9riaEaserE3mQ4M9srHT60hgVtOSPt7EC2QYwLgQQLjQKyNLTf5kQ
	hMEGb0iuyJfBPCwXA06Uhm4OeKmjXsvB1FcpK+78/NJUDlt+SaMZAEg7Bc+QiPCqZX32R0Nz1dn
	Q+IiG9LvHqu96F+3T81eOJvItclv/M4AzJJK/j5T+lHH1aTVC3eKOMPWMpITkV5F4=
X-Google-Smtp-Source: AGHT+IHqM/Dr/7zI0QdtU2XvgPWrPkn/dWWd8IC38n+KsA38rQN80+eM8sij34CR1Do2DRiLEiMI1g==
X-Received: by 2002:a17:90b:5386:b0:32d:ea1c:a4e5 with SMTP id 98e67ed59e1d1-33bcf85128emr34116336a91.1.1761316419443;
        Fri, 24 Oct 2025 07:33:39 -0700 (PDT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.202.82])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6cf4bb9c71sm5343832a12.4.2025.10.24.07.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 07:33:38 -0700 (PDT)
Message-ID: <fba8631d9159c9bd8df98e4cf33a6ffedecac050.camel@gmail.com>
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>, 
	Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, 
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Date: Fri, 24 Oct 2025 20:03:34 +0530
In-Reply-To: <20251017034611.651385-3-hch@lst.de>
References: <20251017034611.651385-1-hch@lst.de>
	 <20251017034611.651385-3-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BCA0A40011
X-Rspamd-Server: rspam02
X-Stat-Signature: mzff1t1q66ogk1b1nwfinjmbjcnujgih
X-HE-Tag: 1761316420-270607
X-HE-Meta: U2FsdGVkX1/06e0pqS2RRtu2+087Qne+GBwqTiBf98Knq6jvCevzKhdIonAh3VLmAKUCgXfFiIVUYk5T7d9ND+9ttZcBE5c61TYKnMJM/FESs75gjNmYMIUo0sbNa1IT9cYk5mapyCl/0LeSoXQRgPq3/cqBFU6Z6EkpmdPNlHJUS2Af9saFZNqjAb1GKSxR5wfixqaqze1a6Z5dYJDmMd3ByNAiQZ0wVGLyEIXWjMD8D8hCXNjV/70vDQHU9BVH3vXg4328eclcooaZe0vdd9Irz/nuMerocKWY0f0i8k5X4eAtL6cVHhzJNaqFq3cvsMyfI+rdGrC/LaEyewIYuCaN/PQCrQIu1avSOBXKYHZn8YfugqFKQYX6SxcMUFwn33WZ2h0StWQ0t2m7N090AwZvghb4GYMsQapgs061Llk0qROR0WI5S2YwESAHX6UtoaTD8+R4grDUAtLqi+bM372TFoFvQld7zo4xKha1alQYshkPt8IJDCh8/zxfGZwI3sKM2V904/ki6g8onMqdzI7McwX8w3AsbY4/LEf1H6P6Hr+NNCo1hpavNB12xkk7Vcdk0UDI/TTtk1lNUVGTGX3y8WlVUxDN1nPKkphlqiTWg7moN0CkzEceNYfS1R/8fMik4HhLtr/UeroPf5Hok83RDJ7o2bM5yIeYJr8gx10n7QaxbXk15dc3ZnS/cru8rdPleL/+n2Mxzz5MEWi/M0kraco9Tnw4mRZZgiRFRJgJ5Lq5BFaaxK4ugd2I8StArvUZCL8Dms5sihYwBjOaQylHCbU8F2RVKFapDwp9pDRY4KP+BnxVu2qG69wdpnpE82Ii4zMpAbS/aWqPQ7YEhtoSCnE9o7BPs3kqTC2qIwTowQJ9k3rKB0l1w095o29rOhAyLVl0eZ+yfR0m5VoLvYi+ffQRA71u9DbhS2VnighxGhvYyUw2UIWqrZT9B9nN4qNKN/ve3iI6Uahuloe
 8tLYgkqG
 Sz+iS5TH6GXeeXcC4wxRzP9P+OVFnU4d9s7/fBnh41o01df5bzo05AwC7xidhebC/yJLFm7M7Xq2bYEQ0sm5v/myPl6WmAOf4gknVvB2nppljaB9KhkoJIaNc4f7ZxJMKcbIE9L55nhH6fu3h7R/HegzJr7VneAQfPiD54jtEq5bNen8Kf3mwVo/Ha3BulRyR45QvllFXQUui8J1TJRB8k/fbfmccymyxn02UXZt8mb2QbIIHNhUlFHmm+xJq4WVoqOC1IAlO1sqdvG58K8SzV/ZMIR/jttWscVpqu/65Exi0QtC7/y0cJtVyBsEBeLN26380jYFAj81FuiKx810iiGKLj7/UaOVPGV1CGq8buA9WcVFCWPoQ1pPFL+ND3CH17Ny7brvlNZkrbWxxTa7kjPcTAhnjSuBXkiRh5l1QPQrWGcWkvY1+40O8Hb+aX1lL2O0uzR69PGlw/BV2WqZVZC1XgvvyNX7FTshGRVK0ysT0rm+FKBjdZbEm8M00xxrI+KGOXKH2mbk2MrNImb7dwLT8knilMhosVhnp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-10-17 at 05:45 +0200, Christoph Hellwig wrote:
> The relatively low minimal writeback size of 4MiB means that written back
> inodes on rotational media are switched a lot.  Besides introducing
> additional seeks, this also can lead to extreme file fragmentation on
> zoned devices when a lot of files are cached relative to the available
> writeback bandwidth.
> 
> Add a superblock field that allows the file system to override the
> default size.
So this patch doesn't really explicitly set s_min_writeback_pages to a non-default/overridden value,
right? That is being done in the next patch, isn't it?
--NR
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/fs-writeback.c         | 14 +++++---------
>  fs/super.c                |  1 +
>  include/linux/fs.h        |  1 +
>  include/linux/writeback.h |  5 +++++
>  4 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 11fd08a0efb8..6d50b02cdab6 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -31,11 +31,6 @@
>  #include <linux/memcontrol.h>
>  #include "internal.h"
>  
> -/*
> - * 4MB minimal write chunk size
> - */
> -#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_SHIFT - 10))
> -
>  /*
>   * Passed into wb_writeback(), essentially a subset of writeback_control
>   */
> @@ -1874,8 +1869,8 @@ static int writeback_single_inode(struct inode *inode,
>  	return ret;
>  }
>  
> -static long writeback_chunk_size(struct bdi_writeback *wb,
> -				 struct wb_writeback_work *work)
> +static long writeback_chunk_size(struct super_block *sb,
> +		struct bdi_writeback *wb, struct wb_writeback_work *work)
>  {
>  	long pages;
>  
> @@ -1898,7 +1893,8 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
>  	pages = min(wb->avg_write_bandwidth / 2,
>  		    global_wb_domain.dirty_limit / DIRTY_SCOPE);
>  	pages = min(pages, work->nr_pages);
> -	return round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_PAGES);
> +	return round_down(pages + sb->s_min_writeback_pages,
> +			sb->s_min_writeback_pages);
>  }
>  
>  /*
> @@ -2000,7 +1996,7 @@ static long writeback_sb_inodes(struct super_block *sb,
>  		inode->i_state |= I_SYNC;
>  		wbc_attach_and_unlock_inode(&wbc, inode);
>  
> -		write_chunk = writeback_chunk_size(wb, work);
> +		write_chunk = writeback_chunk_size(inode->i_sb, wb, work);
>  		wbc.nr_to_write = write_chunk;
>  		wbc.pages_skipped = 0;
>  
> diff --git a/fs/super.c b/fs/super.c
> index 5bab94fb7e03..599c1d2641fe 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -389,6 +389,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
>  		goto fail;
>  	if (list_lru_init_memcg(&s->s_inode_lru, s->s_shrink))
>  		goto fail;
> +	s->s_min_writeback_pages = MIN_WRITEBACK_PAGES;
>  	return s;
>  
>  fail:
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c895146c1444..ae6f37c6eaa4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1583,6 +1583,7 @@ struct super_block {
>  
>  	spinlock_t		s_inode_wblist_lock;
>  	struct list_head	s_inodes_wb;	/* writeback inodes */
> +	long			s_min_writeback_pages;
>  } __randomize_layout;
>  
>  static inline struct user_namespace *i_user_ns(const struct inode *inode)
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index 22dd4adc5667..49e1dd96f43e 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -374,4 +374,9 @@ bool redirty_page_for_writepage(struct writeback_control *, struct page *);
>  void sb_mark_inode_writeback(struct inode *inode);
>  void sb_clear_inode_writeback(struct inode *inode);
>  
> +/*
> + * 4MB minimal write chunk size
> + */
> +#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_SHIFT - 10))
> +
>  #endif		/* WRITEBACK_H */


