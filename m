Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B1CECD4F54
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 02:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17C056B0093; Sun, 24 May 2026 22:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C146B0095; Sun, 24 May 2026 22:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0697A6B0096; Sun, 24 May 2026 22:50:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E418E6B0093
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:50:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C003120DE1
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:50:50 +0000 (UTC)
X-FDA: 84804414660.15.0E51B6B
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 398DE1C0006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:50:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RUco36YD;
	spf=pass (imf21.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779677448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKSeg2Nza4neRSzanFebtUm6bwcAHZPjsw3+MJtuG0c=;
	b=aOKJ3Yj+VZNCdJTY1EBchNX47qjodo7gEcWoVwbEk5ufFDfvbqRmFDv2xKDo4tJG9d7/4S
	rbVbqVwt9f//p5mF5oL0aEo7YLy6f4rmYnjZGujtVhNB/VJN/2vsPviN3i30ioJ8I4162F
	lpoLAv+JyEj7WkQ3XrAtuT6hVp15/M0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779677448; a=rsa-sha256;
	cv=none;
	b=62DkhluHuwoNgmTORNSNSsOl9kehw7IHW9LXmwrFG10AVJZFtDP80C3O4JLuuPVGzqbaCO
	z6t/6DoKSpcI1UBIuYGLOqEwUNBgUwUdiIW2YSwVjNi96vbioXjA7NH8Es69kYjr8b94pT
	8KTV1chaW7rq6n72yHxVsJofg08vKqo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RUco36YD;
	spf=pass (imf21.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779677444; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=uKSeg2Nza4neRSzanFebtUm6bwcAHZPjsw3+MJtuG0c=;
	b=RUco36YDKfzwwZ1EYFDJZpKwHCUaJwYvOrIRBKKgxpJC8Lpkab2liro1D6hfei+L+WZAlY7a9MdxI7OfFk59858iXddsAgxZNJGtB7dEMVjZ5qFMrmPrBFNGC3wUJKvdKGmytNa1ZiDs67go/dhCcPaleQS0CcTBGzRbOzVgyTo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X3Ty9G._1779677440;
Received: from 30.221.145.59(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X3Ty9G._1779677440 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 25 May 2026 10:50:42 +0800
Message-ID: <a5756f39-31c8-4e8b-939f-f498726c7d8a@linux.alibaba.com>
Date: Mon, 25 May 2026 10:50:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/17] ocfs2/dlm: replace __get_free_page() with kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 akpm <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 linux-ext4@vger.kernel.org, linux-mm@kvack.org
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-3-275e36a83f0e@kernel.org>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260523-b4-fs-v1-3-275e36a83f0e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: gcafhm54ith5s31x7yin8ppdtk5sdxfy
X-Rspamd-Queue-Id: 398DE1C0006
X-Rspam-User: 
X-HE-Tag: 1779677446-373650
X-HE-Meta: U2FsdGVkX18WfFLJSh4vi5MTm28/04pfCyWaeZ09lmRBOPtZOub6I+xUudgCkuUnYKpqAAo6B+CcwSO/+hR205DGBdrZ2SZWZR16AfKhD3eiea3875fK9uxuiuW6D1fPoHhbEQHmSYzSX+Th8OexiPauZhw3qFIrvSHurlNhXulDGRDqCHPfJfjaCTIamekGw7CFQT7zeSw0oMH+w/K0R1FQxBHzhwCMKbxrU25YlsdnrkRE4eVlyzFMtuys3eV87SVXjB6SqiGI6T7C2CaIAU+h6uibqSk0+78ea6wAPl7kYlfdsc/buL0wpkkhbMkceVAzFU8xNjqHb9kWo2TQ6IMg8Ug2yBDSHX+ZvpdNnIUFC/lPNVmEYujo9nW1BxokPcvg/OMw/vOu4PiPS86hontq2SL2+OmjTC6HiVPgCUO+fCBb7o2ijvL4huUmO6ibpcnVW+dQKVhbM7pcgtJEcER6TKsKdJAX0Fl1wIArnSnuj2sgxO7vMDZhyGM7L6aelhIhry5Sua6lEIqS4rqK2X5bNLGO4SkCS4LNQVuKe47CWAtlJBishwjMYWm0PyIoWafuKnONWIdg90vYk1pwyCwEcKV+uEvbb9xeBpO5AyaaNdechRId8OW4hgYXEvSf8W1kGD8WOxqfXZH08ZpZ/aqVuIJsvOqmnLrg+uUPzP/FJCJz/lIHvW1WSwjKivAeUBv/uKY21Bh/XmUDL+UxQiCo9uRF0YoIOIA1EI3DkqtTRRmZWadeAa9DZN6or376/v8yDsAw1O2v2nA3HsXchMWK1LZpPOOX1WAGNngygVhJjWht3NpI3DppejgKt+epO23hIOE7t9bM36TppbzuQrtN6NxAlqkgO2qG0ALmf3Hb1X4+6/TaiyQFtW5I0QFKlaCShrIoWEayzDQ98ngYVMB2bMmMqdQ+ssph4L0+/FuEcnewty1G9Dzy6tO3SKOVK3pq0ZX7RVod7wnVQ80
 jWdjAr0Z
 F/gH04pAzAIxN4M2O2QYUW7WjVAzS46g25La7Mi7VS6+o/Qwo6jQnS2/l5/+WOctMWVqVmKQhfeCfV6txq4VKeiFvNkYSnr7VOK8BKkK5BID2+oEfCHNPfWZnRWLqN0UEwRSAtp0NMZHI/+Cx7jdSJr7tS2PYseKJCOS8xW8JzEmF7WhTmJutIEtgjLUkNBubGJHa0igDbDxtPqn5zako/cHpNJNdB0d+o8fUptTAgHaKk1Zka2ca7z7+Mg+HhDFF1WPxiZmpoTaOCaqP4ap3Hh63SF2VpnDrDeRhHxHAeiD36tSHmSbV/wbiKzQzdx6sCbG42XgfpUKRLQeTZK1kJfniCo1IS+lFYKPVrvjuVeNgYkRK7FAEnUhJnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/24/26 1:54 AM, Mike Rapoport (Microsoft) wrote:
> A few places in ocsfs2 allocate temporary buffers with __get_free_page() or
> get_zeroed_page().
> 
> kmalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
> 
> Replace use of __get_free_page() and get_zeroed_page() with kmalloc() and
> kzalloc() respectively.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlm/dlmdebug.c    | 24 +++++++++---------------
>  fs/ocfs2/dlm/dlmdomain.c   |  8 +++++---
>  fs/ocfs2/dlm/dlmmaster.c   |  5 ++---
>  fs/ocfs2/dlm/dlmrecovery.c |  4 ++--
>  4 files changed, 18 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/ocfs2/dlm/dlmdebug.c b/fs/ocfs2/dlm/dlmdebug.c
> index fe4fdd09bae3..6ca8b3b68eef 100644
> --- a/fs/ocfs2/dlm/dlmdebug.c
> +++ b/fs/ocfs2/dlm/dlmdebug.c
> @@ -260,10 +260,10 @@ void dlm_print_one_mle(struct dlm_master_list_entry *mle)
>  {
>  	char *buf;
>  
> -	buf = (char *) get_zeroed_page(GFP_ATOMIC);
> +	buf = kzalloc(PAGE_SIZE, GFP_ATOMIC);
>  	if (buf) {
>  		dump_mle(mle, buf, PAGE_SIZE - 1);
> -		free_page((unsigned long)buf);
> +		kfree(buf);
>  	}
>  }
>  
> @@ -280,7 +280,7 @@ static struct dentry *dlm_debugfs_root;
>  /* begin - utils funcs */
>  static int debug_release(struct inode *inode, struct file *file)
>  {
> -	free_page((unsigned long)file->private_data);
> +	kfree(file->private_data);
>  	return 0;
>  }
>  
> @@ -327,17 +327,15 @@ static int debug_purgelist_open(struct inode *inode, struct file *file)
>  	struct dlm_ctxt *dlm = inode->i_private;
>  	char *buf = NULL;
>  
> -	buf = (char *) get_zeroed_page(GFP_NOFS);
> +	buf = kzalloc(PAGE_SIZE, GFP_NOFS);
>  	if (!buf)
> -		goto bail;
> +		return -ENOMEM;
>  
>  	i_size_write(inode, debug_purgelist_print(dlm, buf, PAGE_SIZE - 1));
>  
>  	file->private_data = buf;
>  
>  	return 0;
> -bail:
> -	return -ENOMEM;
>  }
>  
>  static const struct file_operations debug_purgelist_fops = {
> @@ -384,17 +382,15 @@ static int debug_mle_open(struct inode *inode, struct file *file)
>  	struct dlm_ctxt *dlm = inode->i_private;
>  	char *buf = NULL;
>  
> -	buf = (char *) get_zeroed_page(GFP_NOFS);
> +	buf = kzalloc(PAGE_SIZE, GFP_NOFS);
>  	if (!buf)
> -		goto bail;
> +		return -ENOMEM;
>  
>  	i_size_write(inode, debug_mle_print(dlm, buf, PAGE_SIZE - 1));
>  
>  	file->private_data = buf;
>  
>  	return 0;
> -bail:
> -	return -ENOMEM;
>  }
>  
>  static const struct file_operations debug_mle_fops = {
> @@ -775,17 +771,15 @@ static int debug_state_open(struct inode *inode, struct file *file)
>  	struct dlm_ctxt *dlm = inode->i_private;
>  	char *buf = NULL;
>  
> -	buf = (char *) get_zeroed_page(GFP_NOFS);
> +	buf = kzalloc(PAGE_SIZE, GFP_NOFS);
>  	if (!buf)
> -		goto bail;
> +		return -ENOMEM;
>  
>  	i_size_write(inode, debug_state_print(dlm, buf, PAGE_SIZE - 1));
>  
>  	file->private_data = buf;
>  
>  	return 0;
> -bail:
> -	return -ENOMEM;
>  }
>  
>  static const struct file_operations debug_state_fops = {
> diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
> index dc9da9133c8e..97bb9400e24b 100644
> --- a/fs/ocfs2/dlm/dlmdomain.c
> +++ b/fs/ocfs2/dlm/dlmdomain.c
> @@ -63,7 +63,7 @@ static inline void byte_copymap(u8 dmap[], unsigned long smap[],
>  static void dlm_free_pagevec(void **vec, int pages)
>  {
>  	while (pages--)
> -		free_page((unsigned long)vec[pages]);
> +		kfree(vec[pages]);
>  	kfree(vec);
>  }
>  
> @@ -75,9 +75,11 @@ static void **dlm_alloc_pagevec(int pages)
>  	if (!vec)
>  		return NULL;
>  
> -	for (i = 0; i < pages; i++)
> -		if (!(vec[i] = (void *)__get_free_page(GFP_KERNEL)))
> +	for (i = 0; i < pages; i++) {
> +		vec[i] = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +		if (!vec[i])
>  			goto out_free;
> +	}
>  
>  	mlog(0, "Allocated DLM hash pagevec; %d pages (%lu expected), %lu buckets per page\n",
>  	     pages, (unsigned long)DLM_HASH_PAGES,
> diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
> index 93eff38fdadd..aee3b4c56dcc 100644
> --- a/fs/ocfs2/dlm/dlmmaster.c
> +++ b/fs/ocfs2/dlm/dlmmaster.c
> @@ -2548,7 +2548,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>  
>  	/* preallocate up front. if this fails, abort */
>  	ret = -ENOMEM;
> -	mres = (struct dlm_migratable_lockres *) __get_free_page(GFP_NOFS);
> +	mres = kmalloc(PAGE_SIZE, GFP_NOFS);
>  	if (!mres) {
>  		mlog_errno(ret);
>  		goto leave;
> @@ -2725,8 +2725,7 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
>  	if (wake)
>  		wake_up(&res->wq);
>  
> -	if (mres)
> -		free_page((unsigned long)mres);
> +	kfree(mres);
>  
>  	dlm_put(dlm);
>  
> diff --git a/fs/ocfs2/dlm/dlmrecovery.c b/fs/ocfs2/dlm/dlmrecovery.c
> index 128872bd945d..9b97bf73df22 100644
> --- a/fs/ocfs2/dlm/dlmrecovery.c
> +++ b/fs/ocfs2/dlm/dlmrecovery.c
> @@ -837,7 +837,7 @@ int dlm_request_all_locks_handler(struct o2net_msg *msg, u32 len, void *data,
>  	}
>  
>  	/* this will get freed by dlm_request_all_locks_worker */
> -	buf = (char *) __get_free_page(GFP_NOFS);
> +	buf = kmalloc(PAGE_SIZE, GFP_NOFS);
>  	if (!buf) {
>  		kfree(item);
>  		dlm_put(dlm);
> @@ -933,7 +933,7 @@ static void dlm_request_all_locks_worker(struct dlm_work_item *item, void *data)
>  		}
>  	}
>  leave:
> -	free_page((unsigned long)data);
> +	kfree(data);
>  }
>  
>  
> 


