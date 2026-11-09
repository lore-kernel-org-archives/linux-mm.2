Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB78606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Mp2Lbk5l
Received: by kanga.kvack.org (Postfix)
	id 8FCE06B05B8; Mon,  9 Nov 2026 04:38:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8858D6B05B9; Mon,  9 Nov 2026 04:38:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750686B05BA; Mon,  9 Nov 2026 04:38:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 489336B05B8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:38:27 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1FD31A063B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:38:26 +0000 (UTC)
X-FDA: 85415080212.14.0B639CD
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 66A1940002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:38:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Mp2Lbk5l;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794217105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vMJSg0lmacnY+UcGHVNgSDJi3N4uyY4O9jJ0C/cw0zk=;
	b=0JmIEtsCd2yqxgrjmCNCSweRyTnykkqlvcxTUOUDCgMjfC0Wt1yYiMkMHSjv1KrruUXNT3
	vIi+G7KueMWt4W+vs7aFfWz3opRLXZm8YlMJotHb/KRa6ADnb1ybOsv90J7O5Hg6Ov07Rm
	gtNPuvbe3xJZzak0WczAYhK2OqRUNLQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Mp2Lbk5l;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794217105;
	b=ZAvSCEHTqwchFJUu+4ZMUaW9M0o9rjpV+ENlVOlqctP3S6so4nxY0GxyKTwTz1L88dyMWA
	viKCk4Cv2tItgVW/j4XUs0npX4K9YSvqDYAqnWExDw1hVei4OSjXsLATQPlGHchUdJu0fC
	h+4RMPKZ4rnMOMlvvRToaqumyGZys+g=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-36dbde64409so1175767eec.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794217102; x=1794821902; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=vMJSg0lmacnY+UcGHVNgSDJi3N4uyY4O9jJ0C/cw0zk=;
        b=Mp2Lbk5lR7ytHDvG143mWwPNne+A2LiO0Jg/IPEH21ctK5G57RXvmUMA+jfnywodcj
         zzlWTNHATIkZZqsaVG1b9fvS+5ycr6LK6luWEfNBq7AvgHcBbPASJDC2d1s3RqWn1lCk
         SJZ5vOU+KZE/ViWXcka+WaA9e6rPJK62RLrR7A7DFnyAOLYqd1W9ZtVP1FnYRtLfM2DU
         ghyDhL3mkCLh0iTrVvLOzFSr4hF20tdmcloI9tEGco6dX3v/dhWwiF6kp2mjNncszBVa
         1vRFYhgidHnq13rAlYo/9/HehklQ8moL3XRuIh1E/NPvh5WqRKWqKbNe1Gs7NrISTgTG
         alKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794217102; x=1794821902;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vMJSg0lmacnY+UcGHVNgSDJi3N4uyY4O9jJ0C/cw0zk=;
        b=0hB+tINRMz/c6flKUfR01OQlpn5UqPFkUkhTQG0tNK55V4UxFcPbMtHOreksAeTV+V
         0GISo/vlNfYgZTRBPGn5pa/fl44FyQEb03DtUkhJnX1UCenOW4Qe1S7y2qNw/nGFFp3B
         Ley843w+EEPCkZEAAg/6zv9stpJ3fbKWI2CRDxfLTldCauKmlDcqgcQfMfdmsqvqMhSC
         iga7RkiZHqxLibVwDmHKyt1DZNUuaApMbq4Z3sLmnaiupq1i9Ql2udwQ1OxBFaJwkzTP
         xmSUtE0wfTX2ScZJbHoB3btuJh4Ei5sMpekObE6u3JwYhOQnjWjkep0WAK41BaA9jJA2
         BYrw==
X-Forwarded-Encrypted: i=1; AL+hErG5bqKMmtV5fCGCaDa/FQr/b7CHLMBG3C50yR1KxPnd22lHEgZN5UR0ePY25bCDBuPmfwMRv+EWiQ==@kvack.org
X-Gm-Message-State: APuU4Z8bA0BjUXjgKabPnFPU/7cmmZuIOgPrrm5t8uuWxV1y4LdgBUvr
	U95avN8N4me4c64elTr9FM+9lAd1JpqhWAWkQ92o+qqr5WPSy5UHcPYLve1OLPDyT/affIH114a
	Nv6zGIZc=
X-Gm-Gg: AYBFou3n2PlIK36mFwAgtWwo3zeh+SzRyJZvQSza02RfZ6kVhvvZPm26whPjdsc3Jqf
	P7OnKc2F/gjdtrD+ibLNMWBY68jKgTcji+M/fkkJgJ1u81/9RkrLEnPX7aSrj0ZHTi8ijWXQgkv
	rTTYrUdJF/aMI14c08UCnmo7o3b+C4iAvrrjD6ZQFeRroW9zj0AJc83Gt0mX9C2CdmpNEHY63bC
	WVZ+mVYTL1c45cxKBshizzLR5pKnN2jA01fC3FJojLjH8573o2ncC+vp3K/1USslYZBMkiHKRYu
	dHmEWC6h6g5EGuVIGrVOm77kB+L8greWzugmm8fQyJ1pLNqJCAJD7Zq9sLgGTvspC6mUlSoPeN2
	y0cnLRgZ5zAN07b9ZsnqftPEEW2mxsrD3bYbJBtSfw3PezsXgTIbQl2fBVmt0HJy1cB4RbLaiT6
	MlxZ9jCXFhYYRt+Sl5PSoiiX3Ba3Uun1eA3be8gpXpwgHTokM+rrNPDE8e8l5TcKyHawoYjV2/E
	ltSuZ63VVleU+5pan6Oi8RjjfoM/dKNSfg7SbmICl0ICiNVse904Nkib6MkFZ9+A5aO1qUsHqwZ
	H5e2k8t2CckoYofBivMeIkbCOdz19Q7WIe0OWF4lw/JHsxIQHL0TtYzKEy4lF/CLggKjNH3A
X-Received: by 2002:a05:7301:d80e:10b0:36a:50ec:db3f with SMTP id 5a478bee46e88-372575c557amr6835812eec.7.1794217101438;
        Mon, 09 Nov 2026 01:38:21 -0800 (PST)
Received: from [100.81.10.186] ([61.213.176.59])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-372669d2826sm12719426eec.29.2026.11.09.01.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 01:38:20 -0800 (PST)
Message-ID: <29bf4bce-cdb8-425c-8090-d8d84a749a73@bytedance.com>
Date: Mon, 9 Nov 2026 17:38:17 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: account filesystem bdev caches as kernel files
To: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk,
 brauner@kernel.org, akpm@linux-foundation.org, tj@kernel.org
References: <20261008130747.2868338-1-sunjunchao@bytedance.com>
 <3xivdukdcs45x2lql3fh3pogrkeb3piiexo2np4xscmz5yk4ot@jqvlshpakn4c>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <3xivdukdcs45x2lql3fh3pogrkeb3piiexo2np4xscmz5yk4ot@jqvlshpakn4c>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 66A1940002
X-Stat-Signature: tg7tskgy9xah15dhzq3ehxteig5off48
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794217103-438852
X-HE-Meta: U2FsdGVkX19ALlP1nITF0nAT56ZBMRE96enaH9A0DCvcThdl68YSIVwhwT5wYv2kzOFtmvW25NttNJVDEm56a94LF77wmg9pOOlMP7bsHdzs316O3hfjPTwh5iCqG0g3ZPZYjSrqZfUBj6Yz0GjPnYZVINIPDjUnAgJXGvCOfP45VK1Q4XglHML8ECKCu6odJbT3yXpOyHP0gbdWM1S76+G2S89Vio0K+P702dVsFVIHnaaX+zTGl17REU4vRKVNnQD6kdN/0+dVWkX/bFmwSyPj08QKhNXBxPSpBRtG41BmHFvUjY1JD1BDq8gAQDYm/O3PtB8pOmQN4PEYpRehrRLA9gHBPkXZidsev/G4VIIlk/Oj1OkafpKiFAsGvzFxJMQgC2weIaKrVeDil0J1Hqusk4n3E+jROeIuQ8ApTkrTFL38FkhxBgc4bmGZbnMATlBQwFrTUIxfoQA5viNlhEyEi2QzayncNNlO5f4rwOe0pmF4LZHu+Rza3jvLva7n7RjHeYkl23H32QnOHLdP2FhI2smkw/lUonJ9GtBhkWgBjllcMw5+l18shaByqG9aHE0q3PLUOlpHgHlIwb6s0CarmOrCHwEsb1/cza1KKUEzcF40SpmUpWMmJY+Hh7O4iNS8hfIHt4NlIFIOr/LtVVw67R8o+PmHZumIDRrpjqrwSckQ8PggFXkBgZWC8YE47sVPPkxaeekb0U7IsPHu17+cUMZ8gMOPblU3Yy/e3kiRcl64/VygVM3y0D4KAimYeOmRXUzvVFY0QLBbhd/vZgkoTK6MtXORycajD2lWHd34HZ79Fq/CfqXZbvJBC1S/DIwOro64aNccv6ULB5zF2MC7I71j64kcaIc2Kg0CZU+wSgRZJQhQwWxfEwiireaBt2zu1QOSH+NSAM3SAzRFxYGYFt/Pp7j/VyTSA1qx7RBgw1o2FqrNe9viKcoohGYUg4jOBtml4b+zKtOXWwE
 RhUqvzkd
 77OdPym/bMRgiBl8nNpDvg99NlXBQhRA2tUioG0EHeEFzQ+GyGVyhOMBBWaKHyM5bSSmeCzOMT80xIvhvAJ8DB4fjkYfZfkm9071BIvDB5OP5Iy0Do0EMrFhGv2TYOMiDzd/+3iWKbBv249qcMUxYnzAtA/OvJv3aG1+0Tqp/fHMXTdWvbsXwP6zibOWvznINbfJIi8l44Eji/fA/8qYilzirZ1E5N+1LmVBswayb6LuhFM86iOwpr9jpc2sycRf841FirsqDeg2u5R0ZFrNf/2YZWe/5MT0OiES3fCS4mNGwvWpDVaf5Rd6Eb/BG0krzCRziCDuGZCq7yV4HvnTZvoYxkdZuuvWTmwSJKeOKigSYBa6VMrO/ZRviwbkrE/BkmRSa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/12/26 4:58 PM, Jan Kara wrote:
> On Thu 08-10-26 21:07:47, Julian Sun wrote:
>> Filesystems such as ext4 use buffer heads to cache shared metadata in
>> the bdev mapping. Charging these pages to individual memcgs can trigger
>> foreign writeback of the bdev inode's entire owner wb, including
>> unrelated file data.
>>
>> Following the proposal in the linked discussion, set AS_KERNEL_FILE on
>> the bdev mapping while it is used by a filesystem, so newly allocated
>> cache pages are accounted to the root memcg. Empty the mapping before
>> changing the flag to keep folio insertion and removal accounting
>> consistent.
>>
>> Multiple EROFS superblocks can share an extra data device. For example,
>> two metadata images on /dev/loop0 and /dev/loop1 can reference the same
>> data blob on /dev/loop2:
>>
>>   mount -t erofs -o ro,device=/dev/loop2 /dev/loop0 /mnt/a
>>   mount -t erofs -o ro,device=/dev/loop2 /dev/loop1 /mnt/b
>>
>> Unmounting /mnt/a must not clear AS_KERNEL_FILE on /dev/loop2 while
>> /mnt/b still uses it. Keep the flag set until the last filesystem user
>> releases the device.
>>
>> bd_openers includes raw-device opens that may outlive filesystem
>> users, while bd_holders also counts partition claims on the whole
>> device. Neither counts filesystem users of this mapping, so add
>> bd_fs_users, protected by the bdev inode's i_rwsem.
>>
>> Update this count in fs_bdev_register() and fs_bdev_unregister().
>> These hooks cover both device-open helpers and callers such as btrfs
>> that unregister a device and close it separately, without calling
>> fs_bdev_file_release().
>>
>> Buffered access to the mounted raw device also charges new cache
>> pages to the root memcg. Such access is normally restricted to
>> privileged users. Pages cached in ordinary file mappings retain their
>> existing memcg accounting.
>>
>> For filesystems that cache metadata in the bdev mapping, the benefit
>> is expected to be most pronounced when multiple cgroups perform
>> buffered overwrites alongside direct I/O on the same bandwidth-limited
>> device, such as an HDD. Frequent foreign writeback
>> reduces write coalescing, producing additional I/O that can saturate
>> the device. Direct I/O bypasses the page cache and competes with this
>> writeback traffic for device bandwidth.
>>
>> An ext4 test combined repeated buffered overwrites of a 256 MiB file
>> with foreground direct writes, while four source memcgs generated
>> metadata and buffered writes. Device write bandwidth was capped at
>> 200 MiB/s. In one baseline/patched pair, background file write I/O,
>> including final sync, fell from 6.178 GiB to 1.652 GiB (-73.3%).
>> Foreground bandwidth rose from 149.70 MiB/s to 184.19 MiB/s (+23.0%),
>> and completion time fell from 109.444 s to 88.951 s (-18.7%).
>>
>> Link: https://lore.kernel.org/cgroups/20260925064444.3944820-1-sunjunchao@bytedance.com/T/#m55ee048deb0aad4d1f2293978f25ee6904a5725a
>> Suggested-by: Christoph Hellwig <hch@lst.de>
>> Suggested-by: Jan Kara <jack@suse.cz>
>> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
> 
> Good catch with EROFS. The patch looks good to me so feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> FWIW the problem pointed by Sashiko looks real but it's a preexisting issue
> with broken bdev write locking when falling back to buffered IO. So it
> isn't much related to your patch.
> 
> 								Honza
> 
>> ---
>>  block/bdev.c              |  2 +-
>>  fs/super.c                | 59 +++++++++++++++++++++++++++++++++++++--
>>  include/linux/blk_types.h |  1 +
>>  include/linux/blkdev.h    |  1 +
>>  4 files changed, 60 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/bdev.c b/block/bdev.c
>> index cd8323083740..766e170286ca 100644
>> --- a/block/bdev.c
>> +++ b/block/bdev.c
>> @@ -79,7 +79,7 @@ static void bdev_write_inode(struct block_device *bdev)
>>  }
>>  
>>  /* Kill _all_ buffers and pagecache , dirty or not.. */
>> -static void kill_bdev(struct block_device *bdev)
>> +void kill_bdev(struct block_device *bdev)
>>  {
>>  	struct address_space *mapping = bdev->bd_mapping;
>>  
>> diff --git a/fs/super.c b/fs/super.c
>> index 9d4025213521..7d271bb4cc6d 100644
>> --- a/fs/super.c
>> +++ b/fs/super.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/blkdev.h>
>>  #include <linux/memcontrol.h>
>> +#include <linux/pagemap.h>
>>  #include <linux/rhashtable.h>
>>  #include <linux/mount.h>
>>  #include <linux/security.h>
>> @@ -1644,6 +1645,55 @@ static struct super_dev *super_dev_lookup(dev_t dev, struct super_block *sb)
>>  	return NULL;
>>  }
>>  
>> +/*
>> + * Filesystem metadata is shared across users and should be accounted to the
>> + * root cgroup. Charging it to individual cgroups can trigger foreign writeback
>> + * of the bdev inode's entire owner wb, including unrelated file data. For
>> + * buffered overwrites, premature writeback reduces write coalescing and
>> + * competes with foreground I/O, particularly on bandwidth-limited devices.
>> + * This foreign writeback problem primarily affects filesystems such as
>> + * ext4 that cache metadata in the bdev mapping using buffer heads.
>> + *
>> + * Raw buffered I/O also uses kernel-file accounting while a filesystem uses
>> + * the device. This is independent of CONFIG_BLK_DEV_WRITE_MOUNTED: writes to
>> + * a mounted device are dangerous administrative operations, and charging
>> + * their cache to the root cgroup is acceptable.
>> + */
>> +static void fs_bdev_set_kernel_file(struct block_device *bdev, bool enable)
>> +{
>> +	struct address_space *mapping = bdev->bd_mapping;
>> +	struct inode *inode = mapping->host;
>> +
>> +	inode_lock(inode);
>> +	/*
>> +	 * Multiple superblocks can share an extra device, as in EROFS.
>> +	 * Switch accounting only for the first user and the last release.
>> +	 * Raw openers may outlive all filesystem users, so bd_openers cannot
>> +	 * determine when to restore ordinary page-cache accounting.
>> +	 * Count at registration/unregistration: btrfs can unregister a device
>> +	 * and close it separately, bypassing fs_bdev_file_release().
>> +	 */
>> +	if (enable) {
>> +		if (bdev->bd_fs_users++)
>> +			goto out;
>> +	} else {
>> +		if (--bdev->bd_fs_users)
>> +			goto out;
>> +	}
>> +
>> +	filemap_invalidate_lock(mapping);
>> +	/* Folio removal must use the same accounting mode as insertion. */
>> +	sync_blockdev(bdev);
>> +	kill_bdev(bdev);
>> +	if (enable)
>> +		set_bit(AS_KERNEL_FILE, &mapping->flags);
>> +	else
>> +		clear_bit(AS_KERNEL_FILE, &mapping->flags);
>> +	filemap_invalidate_unlock(mapping);
>> +out:
>> +	inode_unlock(inode);
>> +}
>> +
>>  static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>>  {
>>  	struct super_dev *sb_dev __free(kfree) = NULL;
>> @@ -1654,7 +1704,7 @@ static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>>  		sb_dev = super_dev_lookup(dev, sb);
>>  		if (sb_dev && refcount_inc_not_zero(&sb_dev->sd_ref)) {
>>  			retain_and_null_ptr(sb_dev);
>> -			return 0;
>> +			goto registered;
>>  		}
>>  	}
>>  
>> @@ -1674,7 +1724,11 @@ static int fs_bdev_register(struct file *bdev_file, struct super_block *sb)
>>  	}
>>  
>>  	retain_and_null_ptr(sb_dev);
>> -	return err;
>> +	if (err)
>> +		return err;
>> +registered:
>> +	fs_bdev_set_kernel_file(file_bdev(bdev_file), true);
>> +	return 0;
>>  }
>>  
>>  /**
>> @@ -1765,6 +1819,7 @@ void fs_bdev_unregister(struct file *bdev_file, struct super_block *sb)
>>  	sb_dev = super_dev_lookup(dev, sb);
>>  	rcu_read_unlock();
>>  	super_dev_put(sb_dev);
>> +	fs_bdev_set_kernel_file(file_bdev(bdev_file), false);
>>  }
>>  EXPORT_SYMBOL_GPL(fs_bdev_unregister);
>>  
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index 98e21b4cbf32..19daea93bdec 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -58,6 +58,7 @@ struct block_device {
>>  	struct address_space	*bd_mapping;	/* page cache */
>>  
>>  	atomic_t		bd_openers;
>> +	unsigned int		bd_fs_users; /* Protected by bd_mapping->host->i_rwsem. */
>>  	spinlock_t		bd_size_lock; /* for bd_inode->i_size updates */
>>  	void *			bd_claiming;
>>  	void *			bd_holder;
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 4f7905c3412b..f84dff95eae7 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -1706,6 +1706,7 @@ bool disk_live(struct gendisk *disk);
>>  unsigned int block_size(struct block_device *bdev);
>>  
>>  #ifdef CONFIG_BLOCK
>> +void kill_bdev(struct block_device *bdev);
>>  void invalidate_bdev(struct block_device *bdev);
>>  int sync_blockdev(struct block_device *bdev);
>>  int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
>> -- 
>> 2.39.5
>>

Hi Jan, Christian,

Thanks for the review, Jan.

Christian, would you be willing to pick this up for linux-next,
with Jan's Reviewed-by? Please let me know if anything else is
needed from my side.

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

