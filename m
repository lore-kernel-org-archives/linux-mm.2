Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC655CF64BC
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 05:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210F36B0030; Thu, 20 Nov 2025 00:57:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1746B0031; Thu, 20 Nov 2025 00:57:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D76F6B0032; Thu, 20 Nov 2025 00:57:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDF0A6B0030
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:57:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A56E012FD63
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:57:57 +0000 (UTC)
X-FDA: 84129929394.30.713C736
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf26.hostedemail.com (Postfix) with ESMTP id 79E1814000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:57:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="P3N/NWoT";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763618275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L6MKSMn+gPJje0YAdZP9Sjm6pZAcX6O5SCvFZXOun4Q=;
	b=5VCZnfFtDkFAzVgaIzQpjmkTIjwArFc7XIT97pn6XzHP/cvTX3Pfy4KSgMGM+lGtsS4p9E
	UDRBH9guxN+Hu5U7MhQ2LVkZ20+RWeJQUBUmMy0mS+Zb1saWY0OsZHfhGh5VUWqoAeEnA7
	3dreIXyE4JxvJ0C7Vt94qWbwmDR6co8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763618275; a=rsa-sha256;
	cv=none;
	b=f243RWfo5qYa+fiF9+jhKseUdA92e1rGZlUY5LDOLvtUzuAlQAbVx8y8bMSZl+8Jp0pgod
	hR9DvXMkWBNiHJ1d2FOs8m7KaGACjntHJZiAkJIN3d8NQMm6E/JAhRVuhsm8QvUYvvasDi
	9C7ucJ64hchY5k42fqfBYcXq01V+/Bo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="P3N/NWoT";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763618270; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=L6MKSMn+gPJje0YAdZP9Sjm6pZAcX6O5SCvFZXOun4Q=;
	b=P3N/NWoTf10B7yVZUJxg7qdgkHGzDw3fdhx4HbAf7c6Q+TeJxX7ooRELd/tP+iISTe9moR+o526XN+ZBM8IoFfafYsheoBKFiUKvsIFUtoAtwzvDy9CwnjE+zctLqNukrN+qbT/e3ilJ5gvG3i3rwdFqsCOGLt4ZZG0QuVMiUg8=
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WssUDVg_1763618268 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Nov 2025 13:57:49 +0800
Message-ID: <0a24875d-4f42-4f2f-b1e3-9c3187052e18@linux.alibaba.com>
Date: Thu, 20 Nov 2025 13:57:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] tmpfs: zero post-eof ranges on file extension
To: Brian Foster <bfoster@redhat.com>, linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>
References: <20251112162522.412295-1-bfoster@redhat.com>
 <20251112162522.412295-4-bfoster@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251112162522.412295-4-bfoster@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: aazcua4f3wgydjbkbgwprpthujz4ie8w
X-Rspam-User: 
X-Rspamd-Queue-Id: 79E1814000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1763618273-811795
X-HE-Meta: U2FsdGVkX19TvwrGbtJaI+2dsxprAnBhNRAqIMSTlGhPhkaxbrnmQPWtH2QuCtlQd20MqQVVwqTDVKBhxxFAMBGC43MezRChSuTqlJkKpvxhiLMrDm9qnQht98p0svFK0IH+IQTmWI2iaOhOJEkhM8na6rJEaE57lTuhYqB2p1+dzSxIJ4/bonGN5NH86qwA+a/e6V9n2O0NQyzpNYU1gakoJT+RKwxd/TnRmXG6GV3QJmlsReOmCwQn0gNXclyeBUymvA/mCXMI2VhgUuAU/So6QVmoIiscXjjuOvFzSudXsvUFAvd35HZp5K2a9pfYWK8HBTAwUmuLelU+nJcv0UptiyWm9nF07oH7OIWSc7cBAeVAe8m3mAI/m9Qq/DUq9uctH08NP8vheRuFJ+XXIUpwZqmfIeaWDu44eVeKeTVWwkDEA0hoA3Z7LUKqSNWnaxgXGJ92JVfZJEF9T0Fh2qR4P6K68EV8mZWffhlQB+JkYAZDAhwl0c7Ql9D/6bCi3oQj95W5E1fWyG8JVt6hNQ518keK1AGsf3IR1LMQBy8y9pM2rHdMiWeJmDiznQjNBo5ANMNCVnAoCdq14BYVaXRuYxtHwI1wy7NXGDIDIfyUgatStORnXp0i9o1b4iMLV9F0MQ2waQsThakC04rSyeGYJyBeVMHG+vZ7JpgWunP+KDxtU7+i2ZLqFabyEitqL42uutBEWs7xPNykPSU1kDgooJOHvmAV+sAvs/6KWY1SMKyqPXXZ6gNrHIte7ShlQgKMcv4ZeRSrMoma6jznYjxLrCvmthhbqypmlOj0k7o0q2ooIHXElZLAyQGLV1DN/WV4I4/wvtOlAgtgEvEReCAwilXbuC659+W90i6w6N0DhjhM4WRoqemJUMQoXLZLOwn0VGRKQohoAqriSuuoiWXnZK/6Y2zGDx03LCdE+TEZWboxVtXYkUkBGhZOV4OM/GfdZKaARiD4o29yqzm
 dEduzOh5
 nvT9xg7SPJl2cuP1Ei6fUs5xYSOoa/QxqqXkX6FJbplfboK9E2gZMZxC5FM/XOxEolaIU9mVZ6sbFTBbVZpmm8OihfJi6RQaUFahiJHxEuEfPSar0b4n4d1OVTFgS5I6rYO1zszKd5/rPl226aee3u0WjEoYswPtMFVw71hFGVs4bMlS8Y+K6mIib05tTAzjuUwGQPjECJK4lBqxipurPeT21RVPdCqfUEnea1HUeZcmM4u0rtdHRUXgWwlaTuS8gBwT/2CZHSvAyanl6s9GcSZxBeyiMwPb2noftdFqUUiQrV++GNb71vXAa8LFD+KeRIjoAqxUpomZ0qKxvAymBkhWN2WCpp+SVFxxE7PYndv0I6btbUFIK+lVpeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/13 00:25, Brian Foster wrote:
> POSIX requires that "If the file size is increased, the extended area
> shall appear as if it were zero-filled". It is possible to use mmap to
> write past EOF and that data will become visible instead of zeroes. This
> behavior is reproduced by fstests test generic/363.
> 
> Most traditional filesystems zero any post-eof portion of a folio at
> writeback time or when the file size is extended by truncate or
> extending writes. This ensures that the previously post-eof range of the
> folio is zeroed before it is exposed to the file.
> 
> The tmpfs writeout path has been updated to zero post-eof folio
> ranges similar to traditional writeback. This ensures post-eof
> ranges are zeroed "on disk" and allows size extension zeroing to
> skip over swap entries as they are already appropriately zeroed.
> 
> To that end, introduce a new zeroing helper for proper zeroing on
> file extending operations. This looks up resident folios between the
> original and new eof and for those that are uptodate, zeroes them
> before the associated ranges are exposed to the file. This preserves
> POSIX semantics and allows generic/363 to pass on tmpfs.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>   mm/shmem.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 79 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 7925ced8a05d..a4aceb474377 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1101,6 +1101,78 @@ static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
>   	return folio;
>   }
>   
> +/*
> + * Zero a post-EOF range about to be exposed by size extension. Zero from the
> + * current i_size through lend, the latter of which typically refers to the
> + * start offset of an extending operation. Skip swap entries because associated
> + * folios were zeroed at swapout time.
> + */
> +static void shmem_zero_eof(struct inode *inode, loff_t lend)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	loff_t lstart = i_size_read(inode);
> +	pgoff_t index = (lstart + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	pgoff_t end = lend >> PAGE_SHIFT;
> +	struct folio_batch fbatch;
> +	struct folio *folio;
> +	int i;
> +	bool same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
> +
> +	folio = filemap_lock_folio(mapping, lstart >> PAGE_SHIFT);
> +	if (!IS_ERR(folio)) {
> +		same_folio = lend < folio_next_pos(folio);
> +		index = folio_next_index(folio);
> +
> +		if (folio_test_uptodate(folio)) {
> +			size_t from = offset_in_folio(folio, lstart);
> +			size_t len = min_t(loff_t, folio_size(folio) - from,
> +					   lend - lstart);
> +
> +			folio_zero_range(folio, from, len);
> +		}
> +
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	if (!same_folio) {
> +		folio = filemap_lock_folio(mapping, lend >> PAGE_SHIFT);
> +		if (!IS_ERR(folio)) {
> +			end = folio->index;
> +
> +			if (folio_test_uptodate(folio)) {
> +				size_t len = lend - folio_pos(folio);
> +				folio_zero_range(folio, 0, len);

I am curious why not zero the whole folio? Since the folio corresponding 
to the 'lend' is also beyond EOF, no? Otherwise look good to me.

> +			}
> +
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +	}
> +
> +	/*
> +	 * Zero uptodate folios fully within the target range. Uptodate folios
> +	 * beyond EOF are generally unexpected, but can exist if a larger
> +	 * falloc'd and uptodate EOF folio is split.
> +	 */
> +	folio_batch_init(&fbatch);
> +	while (index < end) {
> +		if (!filemap_get_folios(mapping, &index, end - 1, &fbatch))
> +			break;
> +		for (i = 0; i < folio_batch_count(&fbatch); i++) {
> +			folio = fbatch.folios[i];
> +
> +			folio_lock(folio);
> +			if (folio_test_uptodate(folio) &&
> +			    folio->mapping == mapping) {
> +				folio_zero_segment(folio, 0, folio_size(folio));
> +			}
> +			folio_unlock(folio);
> +		}
> +		folio_batch_release(&fbatch);
> +	}
> +}
> +
>   /*
>    * Remove range of pages and swap entries from page cache, and free them.
>    * If !unfalloc, truncate or punch hole; if unfalloc, undo failed fallocate.
> @@ -1331,6 +1403,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
>   					oldsize, newsize);
>   			if (error)
>   				return error;
> +			if (newsize > oldsize)
> +				shmem_zero_eof(inode, newsize);
>   			i_size_write(inode, newsize);
>   			update_mtime = true;
>   		} else {
> @@ -3512,6 +3586,8 @@ static ssize_t shmem_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>   	ret = file_update_time(file);
>   	if (ret)
>   		goto unlock;
> +	if (iocb->ki_pos > i_size_read(inode))
> +		shmem_zero_eof(inode, iocb->ki_pos);
>   	ret = generic_perform_write(iocb, from);
>   unlock:
>   	inode_unlock(inode);
> @@ -3844,8 +3920,10 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>   		cond_resched();
>   	}
>   
> -	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
> +	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size) {
> +		shmem_zero_eof(inode, offset + len);
>   		i_size_write(inode, offset + len);
> +	}
>   undone:
>   	spin_lock(&inode->i_lock);
>   	inode->i_private = NULL;


