Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F74810FC456
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 02:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBFB26B0088; Wed,  8 Apr 2026 22:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6FE36B008A; Wed,  8 Apr 2026 22:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAD1B6B008C; Wed,  8 Apr 2026 22:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CED7E6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 22:36:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A433588F5
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:36:25 +0000 (UTC)
X-FDA: 84637453530.26.D126452
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id A2D5340004
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 02:36:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MFIMmAGa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775702183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lw0Tv+5NbELb9GtHhwh2AbG2K6I+ORA+QMsewcCrAeQ=;
	b=xwHKEQ7X0g+XlyWbi7D5AzXI/LZOSdsZ+ozovJYCuvXQnSqHnEqguMQLZEO/X5n5HmL25R
	nEsZwKGyrzexn6Qnl7D8J6pXJ3JZlW4k3ZL8DNzMgEQIHjLq5dSKmuk34K+mh1rB7iezbj
	ZkgvA9vrjFPP1bfQdj87wiI8iz8bmO8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775702183; a=rsa-sha256;
	cv=none;
	b=CWn26fx2Gp2LkrA1sRlWAufY0AbuzQDvv5WbnkPjyNGYg+92l71cOe51nBVENDaEEpfycD
	lCXD8YxgN5H8/lAk7UEeQvkUT4dAZ30Q1QuJiNcH0ufXSc5Ll0QK2RD0ABiXxzBNdQdcnu
	SbyI/CygDxgaamO44ume+9FHJw6+FRg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MFIMmAGa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2b25cf1b5f0so3184055ad.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 19:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775702182; x=1776306982; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lw0Tv+5NbELb9GtHhwh2AbG2K6I+ORA+QMsewcCrAeQ=;
        b=MFIMmAGa+4mioDTCqpppryb6JrX8iiBFLUELWahUEEk/plmR97tqeTPv0Tr2REYqfn
         VQME32UjocZBpIt9Z663v1Z8oiLN39UTQWEoBxbS+nVikx7bapRUSf3z+tfDW8fLKA6Q
         Id+IPcZ4FH8KDWW3LLZfc0oE2/83NsFTAFropKPUUzKHpqUmsx4YLQXyrfJHJsdvmJs7
         nxivQnhXEa/8OjwCPoOgCPYmW6ax5YzchQE0Vp++6nE7fyJbUFXMezZ2rgvwZbz8AxK8
         DN8WvwO0w14emZfD9Gi/44mF51HE6UTceNJxhNzXGG/RZkJDSg46AlfF7szOxc0nI8Sb
         qMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775702182; x=1776306982;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Lw0Tv+5NbELb9GtHhwh2AbG2K6I+ORA+QMsewcCrAeQ=;
        b=eUi20crXvy2j+2+0mpzvACsuB0ZnZtK7nabIv7yVXmGCBdP897nYkRb3ztq3Qbutzi
         gbQNle1/Ygbgw8+JsK/C+uZXFttJz2VDdok2dCmHxoCwERIEV4MdMikyym75io5efnKB
         xW7y0UnaVKknRg9rqjVsFVoWx6OlOhqUj3sS+v9WJpy6oWsoJ1BlGOj2pK3VGUXyGHgT
         nODUuzHeFZOOp1UUybHe2piYnjgVIucDFbz36aM2cS1onhxsMuwSuHBXjcex8Z/IGxWe
         MUWT/U9jLrIPoQMV81s2THiv/nAXZgQWy37N25l8qSzY1AY+OnZkS7eP2m4+Ujo/PGiq
         lDFA==
X-Forwarded-Encrypted: i=1; AJvYcCWVCXEbTb098yShpdUSubm8mqwlnvwSIDP3okpt5OAgM3+zRzhd/JjFzMrXYhpmf0qAsOsbXpGjRA==@kvack.org
X-Gm-Message-State: AOJu0YwZwndm5VuiB1iMkJcqJPNvM2cWy5nYkskMakCNHJwbrNO4MGI4
	bejXcsntcBTpq35kHKEYVFzzhQWXpUXuHm3DakN89UlCmXhKrdq0vNxp9/u0Yg==
X-Gm-Gg: AeBDievRefbmGbDsZCPjgSDI2EYUWnpndDL3dwZesKAa1DBRcIN6QzwRVSwmBah6YHC
	a7JELxZ2bHy4y4qgQsy4dYR+GyvoOVVMx8JzVarPXbc6txfDY4n+AxEYMeXV2NJBaKNzOREZBb/
	IRytPYZhlpYLa97AR4rxouuYn9ZxylT1fozh92OBPn7UTYcx8cm+2NN5dEj0v7tUpoEvQA4El9L
	8mUmfCQHpG5WgrMpdNwLk6YAOLKR/ZF1iul0INacREcbBfTdK2L6RqyFUi8Jzua/I2SkywdeBDf
	yWfPw/mfBXtEd+NtJKFMiB4KT/hb29ZdUDReLG7LR5g/2WCLIsa34C+6OR7SJFBeg8zYooZtADB
	3vR0G9XsESMJk2xAiKltG6RmWlHDg9Uw31Gsd1M6aE1QCTmLqqBcpQJw/UQ7oQfYBXST7fjGv/O
	nDWGggK+t7sFKasAM1sSEUYO1Y4X3MDB0o
X-Received: by 2002:a17:903:238b:b0:2ad:d0ff:2ed4 with SMTP id d9443c01a7336-2b28164c3d7mr267295685ad.6.1775702182377;
        Wed, 08 Apr 2026 19:36:22 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749ce29esm233858135ad.81.2026.04.08.19.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 19:36:21 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-mm@kvack.org, Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 1/3] mm: kick writeback flusher instead of inline flush for IOCB_DONTCACHE
In-Reply-To: <20260408-dontcache-v2-1-948dec1e756b@kernel.org>
Date: Thu, 09 Apr 2026 07:10:32 +0530
Message-ID: <tstklxm7.ritesh.list@gmail.com>
References: <20260408-dontcache-v2-0-948dec1e756b@kernel.org> <20260408-dontcache-v2-1-948dec1e756b@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A2D5340004
X-Stat-Signature: 3yutc7txe5cu9zsor8cagrh4zrsxqun4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775702183-457956
X-HE-Meta: U2FsdGVkX18Ln3zbda2ibYuKmibDyuGfoiFEvK22kWJsxddJ55EcxIDwr6pCTTJMxxFkPPvkETfP+pyvHj6fEdHI609aX/T/s9H9eqrx7XyXDSy0uxgKylaELgyLhH37vNOJnrHSsQuA8SYKv0zpCdH0+Khid0mjFFhkWcdYY3478fFQ4QG9knqi+OoUw4S4m+uoOebgqpjbqdZwZDGXeuNVhJ/RNIFSFe75y0vKA6FQ7zGaNdqEPour7u+Pewyxw/3hpKP4QzFxBFm6XDaHiRYebPZSFHQYSU1wVZu4iL3KtV8aMHjaPuKXxsDtUA3JtzU0RnAgYq0CyHk/GukkIv9NWZDcDqr8IhWyL/ivMSI4DtVmcoB/TreFmNs2CYAUdDVKq/b5XTUkz6R0rmeEUfx8NMSusKb0ZksYY0/vluYWDsr3/JH4uq9f1yCiMNN4ctbkZatl1AaqlJg0S7WiWtcWvxSNjT8cCwfkbJDMOTppolS6AgyIDuqohUu8iDTFoRixw4OwhgrbPRi854ZB3dSjx/sT+JXgvoIZX10q969d+xtj8WObkEw/2IhYbEa8I/QWdqqAOqYK2J68jgOfdQEtZgJLxLUy28WDRoUNHt+75/n3r/qEU2GGEEZh1beCK0ttctdXFL2r5RdCtFYj1vMUL6GMBHuTARi1VePBUEotuno0Nj7mqgzjfEGcahC+mPuAqOnRH36yvgGhJR0hdCxWIVObhrlIJNZnfOxWg5KLLZaNYnhX1ocL6o6WaaK5N2VQOlWSL/qyTf+2Ik3suhTGNtD7KTXrAjFfBrY5zgcLB8XtKZzds8L3UibFfVz8GT5yzfT+RRxXKh2bTGinYweIbAafm4KHGvG9ZytKSG+chyLfKpcNFqPBZJnHm9E5THxB0qXRlp7RBt/rARReq5y9HcXOm9l21HTgdiifYQ2D8kpXMZJJOjD5mA6zEThYvnw+KqnDngZ8/eZ4Vv3
 fGG240HQ
 d69rYWkkTlNLf3KLuRt4bK+qTzdtOViw6bTW7NhzgbXK4ldVyZR4dbAScupjfCIB3faFciQ76mtBGvlUT8h7cGcAi9rlXObbH6tZwol2pTp5GCpDXiv55DtKK1KKS8Bq3ZYPKHAtySer1zGNNRSAUNs7rDuqfNMBf8ZltYCYnxv/N0K8c9NEpWhKKlCP5MoDuViuzCJo8BCYdL2uJlbzEDvpYfihdO/3PmUu9zT6DX5oDAzRUVk5r1F8ps6bSItp0qhK4veN7YEyfrVW8i0o8bIKXmFiztuytC0C3RpPPszdljXZqxdvCCQmRDpfkcLutqA6j2cyRRRsmAWYEaeYI/Yolt6Zxbbm4J2BcZI+qQY2dEmqAGsaL43Y1oHYnA67UwXGe/G0UD6EqTfXg1P/9hbmeRfHoTG68MrMXVu+IFlRqtEWZw8l1kYyOfKo3eBQu8+6TA56lLk6UnLBXLKhKY+16HXYdnTpDrF3RaLKigRs6ZFWuxohd44R3cnP1ia/ZePq5wOJe73YSJs7KCfk4mEYfBSslpBVis2uJ1KHEoRQ0soUD98jWGqUgHQ0veJxOTDe82l13b+FKMbqzTYTmAYcTKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeff Layton <jlayton@kernel.org> writes:

> The IOCB_DONTCACHE writeback path in generic_write_sync() calls
> filemap_flush_range() on every write, submitting writeback inline in
> the writer's context.  Perf lock contention profiling shows the
> performance problem is not lock contention but the writeback submission
> work itself — walking the page tree and submitting I/O blocks the
> writer for milliseconds, inflating p99.9 latency from 23ms (buffered)
> to 93ms (dontcache).
>
> Replace the inline filemap_flush_range() call with a
> wakeup_flusher_threads_bdi() call that kicks the BDI's flusher thread
> to drain dirty pages in the background.  This moves writeback
> submission completely off the writer's hot path.  The flusher thread
> handles writeback asynchronously, naturally coalescing and rate-limiting
> I/O without any explicit skip-if-busy or dirty pressure checks.
>

Thanks Jeff for explaining this. It make sense now.


> Add WB_REASON_DONTCACHE as a new writeback reason for tracing
> visibility.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/fs-writeback.c                | 14 ++++++++++++++
>  include/linux/backing-dev-defs.h |  1 +
>  include/linux/fs.h               |  6 ++----
>  include/trace/events/writeback.h |  3 ++-
>  4 files changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 3c75ee025bda..88dc31388a31 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2466,6 +2466,20 @@ void wakeup_flusher_threads_bdi(struct backing_dev_info *bdi,
>  	rcu_read_unlock();
>  }
>  
> +/**
> + * filemap_dontcache_kick_writeback - kick flusher for IOCB_DONTCACHE writes
> + * @mapping:	address_space that was just written to
> + *
> + * Wake the BDI flusher thread to start writeback of dirty pages in the
> + * background.
> + */
> +void filemap_dontcache_kick_writeback(struct address_space *mapping)

This api gives a wrong sense that we are kicking writeback to write
dirty pages which belongs to only this inode's address space mapping.
But instead we are starting wb for everything on the respective bdi.

So instead why not just export symbol for wakeup_flusher_threads_bdi()
and use it instead?

If not, then IMO at least making it... 
   filemap_kick_writeback_all(mapping, enum wb_reason)

... might be better.

> +{
> +	wakeup_flusher_threads_bdi(inode_to_bdi(mapping->host),
> +				   WB_REASON_DONTCACHE);
> +}
> +EXPORT_SYMBOL(filemap_dontcache_kick_writeback);
> +
>  /*
>   * Wakeup the flusher threads to start writeback of all currently dirty pages
>   */
> diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
> index c88fd4d37d1f..4a81c90a8928 100644
> --- a/include/linux/backing-dev-defs.h
> +++ b/include/linux/backing-dev-defs.h
> @@ -55,6 +55,7 @@ enum wb_reason {
>  	 */
>  	WB_REASON_FORKER_THREAD,
>  	WB_REASON_FOREIGN_FLUSH,
> +	WB_REASON_DONTCACHE,
>  
>  	WB_REASON_MAX,
>  };
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8b3dd145b25e..2fd36608ac73 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2610,6 +2610,7 @@ extern int __must_check file_write_and_wait_range(struct file *file,
>  						loff_t start, loff_t end);
>  int filemap_flush_range(struct address_space *mapping, loff_t start,
>  		loff_t end);
> +void filemap_dontcache_kick_writeback(struct address_space *mapping);
>  
>  static inline int file_write_and_wait(struct file *file)
>  {
> @@ -2643,10 +2644,7 @@ static inline ssize_t generic_write_sync(struct kiocb *iocb, ssize_t count)
>  		if (ret)
>  			return ret;
>  	} else if (iocb->ki_flags & IOCB_DONTCACHE) {
> -		struct address_space *mapping = iocb->ki_filp->f_mapping;
> -
> -		filemap_flush_range(mapping, iocb->ki_pos - count,
> -				iocb->ki_pos - 1);
> +		filemap_dontcache_kick_writeback(iocb->ki_filp->f_mapping);
>  	}
>  
>  	return count;
> diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
> index 4d3d8c8f3a1b..9727af542699 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
> @@ -44,7 +44,8 @@
>  	EM( WB_REASON_PERIODIC,			"periodic")		\
>  	EM( WB_REASON_FS_FREE_SPACE,		"fs_free_space")	\
>  	EM( WB_REASON_FORKER_THREAD,		"forker_thread")	\
> -	EMe(WB_REASON_FOREIGN_FLUSH,		"foreign_flush")
> +	EM( WB_REASON_FOREIGN_FLUSH,		"foreign_flush")	\
> +	EMe(WB_REASON_DONTCACHE,		"dontcache")
>  
>  WB_WORK_REASON
>  
>
> -- 
> 2.53.0

