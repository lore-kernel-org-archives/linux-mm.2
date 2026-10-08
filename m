Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FBF0CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 08:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CE426B0092; Thu,  8 Oct 2026 04:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6256B0093; Thu,  8 Oct 2026 04:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8952D6B0095; Thu,  8 Oct 2026 04:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58BDF6B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 04:00:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD2FDC049A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:00:24 +0000 (UTC)
X-FDA: 85298711568.22.66FC7FC
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id B3FCEC000C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:00:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=O9aYAq7j;
	spf=pass (imf10.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791446422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEGNX9o2ekofmi3CaUGlBm2/+Xc2Ba7w+559DPi52mQ=;
	b=rg4d8myxGdg+Y7qjJgaqIECguhYL6bvHxl0Ebj+WNCOfFC2e7F2sLpSjeJpGkKTe9j9bBZ
	U+cO1pO0uwMzYdaemU8pF9E8tvdSxSSnxbO6xPd0cyKCnO3A+FYpdnQs8gDFOj9xtSD+H9
	pBEuPYU9PRQeVYMKFABCCcUPnr/uzyU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=O9aYAq7j;
	spf=pass (imf10.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791446422;
	b=o248sswKmj+HAERyTBPuqC0GlGA/eFJNvYA1XFiuy9LLgWHVu1Yt+L5Rc8TflchZAUqeto
	W/txxqMM2pxSPk7hQgK13X9cjzmwNOF8AboH33BmtX5TD1lbN4I4kYCL8w2XTKkyHkcxxc
	5IGy4/tb8T6dlDLL+rFC6LME9x0DXlg=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3a886d6ad51so1978972a91.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 01:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791446420; x=1792051220; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CEGNX9o2ekofmi3CaUGlBm2/+Xc2Ba7w+559DPi52mQ=;
        b=O9aYAq7jlaspyI318ukN4yDgpoZJcL2gA6PPSOpgxDMD3eCe1/UHEIb+9ciu6iOQEe
         R0Y+R0eiQTnt5aWQbmkTp6cabLns0DeYAAR7LRG4pI0BSN82TG+lsqZKp1/OSmsG081M
         uB/uQFtzygSHfxmS/IdFF7ps7otinFaC6OymC+l6x32fY0xUHHSRaeapdq8GzEG3TUzy
         tmzmHyRXfr/e4ExdYM7Ysv/hjm4/QCZiKqyMvLZPEWLYUuqZ0ivuUIdPzhWmEqE2ofl/
         33/SldylxIVjtV7n4EVUS5/KFKlkDbVWVv8OgsprekyDv4UQhC5k6zbZTwUEgkTLWe94
         OGHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791446420; x=1792051220;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CEGNX9o2ekofmi3CaUGlBm2/+Xc2Ba7w+559DPi52mQ=;
        b=jyhz1Wnm20kFS7q17F92Ad+c4QpkGmXvyEqZ6116CeP4t5qxCSbI9SDel5ju5sqtnZ
         nNcXLeRcb+ZTM9c3kVUBCGz7A0LJOy0+V6pO4YK+XSg/HBxPLHFuetj8WuT2c45cswBL
         2n8D0J2jrxHw0KSiIg18EbtMRfv4Mau60dqBBHMzvBB1yAVVre8M/e11xyfUC86tyZgd
         w8oMdqVY0bqN6CfObib/krcs+FAbTSPa5mbTzAl//2+Is3Sur269A6GVH4Z+ZzaisllI
         Iodac0bxGGd+rkzNdSYXSz25OBQwASD4fH1HpuRUGvQO0lSOc5Fn7UOHKbIP+WGO0hYh
         qYlg==
X-Forwarded-Encrypted: i=1; AKwUvBzXBDnzt5Km0PqdGXMPq5hQOKZjeuoBC8CZQAyjmfM69nerkao6rFH5HhCy5TE7KIH/pIhT9W+O/A==@kvack.org
X-Gm-Message-State: AFq9FYJxfweS1TFgrVU0NlrgnU+VDqqS92JxhCj0ssvGeyE4DSRM4z4D
	BWmGETjZQmNcwLAqTS8Oedj6GTKEqAPRxHyWppjLW0JitCnSJ/3K/+KeZaDpBDVfhGg=
X-Gm-Gg: AYBFou1f/0SSRq2273Z6UlJHhk0nupb/W3Ihp+7CVC+T5z6tI+sAdcNUUxtr/JsSypl
	4IPq8EMOBj9uBwkyaT/A6NXVPvOly78PUYDhf9hPKqIB7ES687M5uRUuYPDYjMsJiFXJn8oMu+z
	TgWv3gVrkf2c4hUrBUJzvCtif7TWvCKjC2hkqhXszJTDzmMT315EGzEtN8ilPErD86+izE5JSDf
	pS5gIHzJRBwq0lQvawvOn72D9BYbH7jHCu/Fm7dIzxv5s29dTzJzZ0T8/kf1W6LBV0QCoDha5iq
	D4j0AusZGrgwzHc3eAPRnsDeYBSiv5F94OG/VAuLvhxJ2XIgLn0OErKVSFMviPH5w6JWJyhYWwm
	5ZA5UYf6nbLnpeRQb0v2AEhDzZw/rYtejPZk3n6uD5uQmG1Yeb1/GJbOgCxb/i6h9R5Posy7ID1
	ybVU9EARw+91A90xeSh7gaoE9x9h5KLFPebUUDSoWLrklSy+vMsOox0I0pH87JgNl7omZ65pp1A
	ZtasmFTsf0evs4rAH/JI8Kspdvp5Xt7baQCTkXzodXWRkjgyXQu
X-Received: by 2002:a17:90b:534f:b0:3a8:5d1f:59ad with SMTP id 98e67ed59e1d1-3a8a1b04025mr3670596a91.43.1791446420072;
        Thu, 08 Oct 2026 01:00:20 -0700 (PDT)
Received: from [100.81.25.52] ([61.213.176.59])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff7ab32bsm3141344a91.3.2026.10.08.01.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 01:00:19 -0700 (PDT)
Message-ID: <c4d76912-581f-4174-95a7-d0ecaae79d3d@bytedance.com>
Date: Thu, 8 Oct 2026 16:00:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
To: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, willy@infradead.org, tj@kernel.org,
 akpm@linux-foundation.org, Boris Burkov <boris@bur.io>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
 <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
 <aroIAqoCNDBPlB2A@infradead.org>
 <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
 <5my3hyw54ej2tw24dqnacsy7xppywdjovvnwvrevmczsllzq7c@berxapmobgfa>
 <asNfNHd-kcsI4B1S@infradead.org>
 <bsb5vk2s3vyqglw6bv6pgpoqqvkho2p5kfnskfwfban5azi2vt@sceqd6t36yai>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <bsb5vk2s3vyqglw6bv6pgpoqqvkho2p5kfnskfwfban5azi2vt@sceqd6t36yai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B3FCEC000C
X-Stat-Signature: oya1uwaser1rikop5rn9g5f3yaxmbyeb
X-HE-Tag: 1791446421-508932
X-HE-Meta: U2FsdGVkX181kxRcl/C3+0IpQPBJD8oG0hUHtd7HdRIggMIEd+XU1C2UeINE2wijKYz59sKxz4cXjcxjNifing41FktQsk0h+KMEggmak1issSC2F2m1MrHs9vA+L/dI+iA/GD3XkWXjlApvZ95o0n2DM9FN11WF5Hj6FlR8EiVGYFmnoT6AIzxflBhlu+THTVoZYnZXIeF88DvsRXjArEAsIqrzraefYEYTSupKzWTkz4y7ThbFqt3+mo3IxK+4VdgVZnpH/0467o8RPkGOBP3Wb2+j2VzFf1XV8acAHm39exacTNQOvmKjt6VFZIa/BbzukIhdANrpZtp4XpLOeloM3JiIFLl012F7GCQSNSRik3ojHG3pk923urZcIGubP68DNp8Pw+DrnA/VgVFKOqmWHwDAxWsSLw+58WEJw157BG+eolk+XwCvAH++ifYx4ZrrO4A50Gt24zCbA2pDooTSnnHkJD2wrN1G+OyaIM6skV9O6Ox56VN0tQkhqDLfhlxbibhiSOBSOUv1e/xLiKFKuvNpZG65zGy29qtAqaF/8XLnRBasBSz1o+Znmg3Jrors+/Ot45+FZrjaBNkl1OY6xVEGbosLMMuufVMYLCTYQqodyagoKru6gwuFrPw7iOOiiB1f+k6W4lxBcCycdER3nBAfnWXOLbaYl7ZIHhKxIi8p+ESqeufwwoLtmvgySiIDzKUpByEP8wcIVZLjI5lTZNQbmapzo2gFd5B0aaUpihdKGetewTYTDcX5M9GZgv0WHJ75CDUqyyMdmZ0ewHrs3f5Qd4iYUheABuWfjnJhuAFjboIbMP/FJhNw8IvrCVDcV6hkRsjapFKWSXXIWn2Pb2eXt+Qep44N3MunXlPCoXDhwn3S36Sh4AUEDp572stmT74fmANjuSbDB+Y0Ascgw9BDrZoXppijNTl0n9+E5rYpb37pPoilnuRRzR/GXWyw06vmHnOqVEqn7m+
 ohuhOqOZ
 gUTSRHGAQ7GYBI1Z+yJJN6B+ysV/dhrsIJolFTHQMqkI882v0mw0f9BUpyc81EuAk7fJRL8wsw7sClIbJLmv+nDJoCyXG2Gtm8O4wQPYEtb+/4BAtoAm59qFZpRs2w4f4WxhhTQfdgVlbiSngDKWPcsS0Y3lxoYR+/lIlGQ/AYhZOlhW6L6iYa4R8JPr9p7ozvEujTTLJ6lfcaZ7e0W1BS/oXf0jDBNY4PB0kpbX0y0Okr/yRPI+93xVMoTSnad5OnHKI9ispP8koy/P5ze8lz34j1oDuf8xUcpWXJ7vBZNohq0DSOV8srxtMQxid9FDS2AXlZwRg/oNOfuRXeclaFzagWLyDDG+KKYgb5y8Dj8cVbWpm53r5T3djxz74kTsiy2EkjsgTxd7e8epKyykJGFRRMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/6/26 12:25 AM, Jan Kara wrote:
> On Mon 05-10-26 01:26:28, Christoph Hellwig wrote:
>> On Fri, Oct 02, 2026 at 01:10:42PM +0200, Jan Kara wrote:
>>> FWIW I share Julian's concern here. It would be fine to use AS_KERNEL_FILE
>>> for ext4 metadata but I think just unconditionally setting AS_KERNEL_FILE
>>> for bdev mappings will cause issues because some users may be using bdevs
>>> directly for their workloads and they could still expect proper memcg
>>> accounting to work in that case.
>>
>> Agreed that it should not set unconditionally.
>>
>>> We could set AS_KERNEL_FILE when opening bdev for a filesystem (and remove
>>> it when releasing bdev) but that would have to make sure there are no
>>> folios in the bdev mapping when changing the flag as otherwise the
>>> accounting would go wrong. Looks it might be doable but getting all the
>>> cornercases right will be hairy and overall not very appealing to me...
>>
>> I'd rather not support special case writeback code just for this legacy
>> fs abuses bdev buffer cache case.  And we basically need to tear
>> down pagecache at unmount anyway, as i_blkbits can change, so while
>> we do need to be careful, I don't think it really is a major issue.
> 
> OK, after some more thought yes, I think we can make that work.
> 
>> We might be able to restrict to setting it when
>> CONFIG_BLK_DEV_WRITE_MOUNTED is disabled to avoid the problem of non-fs
>> shared mmap writers, as anyone using a modern kernel and cgroups really
>> should have that disabled.
> 
> I don't think that's really needed. If such writes are happening, they are
> *very* limited and done by a system administrator only (as they are very
> dangerous) so the fact the writes will get charged to the root cgroup is
> not an issue.

Hi, Jan, Christoph.

Thanks for your suggestions.

One remaining concern: while ext4 is mounted, buffered reads of the raw
block device would also charge page-cache allocations to the root memcg,
bypassing the reader's memcg memory limits. Is that acceptable?

I've attached a preliminary diff. Does this approach look reasonable?
If so, I'll split this into a formal patch series.

diff --git a/block/bdev.c b/block/bdev.c
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -79,7 +79,7 @@ static void bdev_write_inode(struct bloc
 }

 /* Kill _all_ buffers and pagecache , dirty or not.. */
-static void kill_bdev(struct block_device *bdev)
+void kill_bdev(struct block_device *bdev)
 {
 	struct address_space *mapping = bdev->bd_mapping;

@@ -89,6 +89,7 @@ static void kill_bdev(struct block_devic
 	invalidate_bh_lrus();
 	truncate_inode_pages(mapping, 0);
 }
+EXPORT_SYMBOL_GPL(kill_bdev);

 /* Invalidate clean unused buffers and pagecache. */
 void invalidate_bdev(struct block_device *bdev)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1706,6 +1706,7 @@ bool disk_live(struct gendisk *disk);
 unsigned int block_size(struct block_device *bdev);

 #ifdef CONFIG_BLOCK
+void kill_bdev(struct block_device *bdev);
 void invalidate_bdev(struct block_device *bdev);
 int sync_blockdev(struct block_device *bdev);
 int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1279,6 +1279,56 @@ static void ext4_flex_groups_free(struct
 	}
 }

+/*
+ * Account ext4 metadata cache to the root cgroup. This filesystem-wide
+ * metadata is shared across users, so it is not naturally attributable
+ * to a single user cgroup.
+ *
+ * A bdev inode can contain metadata pages charged to many memory cgroups.
+ * Dirtying these pages can trigger foreign writeback of its entire owner wb,
+ * including unrelated file data. Premature writeback of buffered overwrites
+ * reduces write coalescing, increasing disk traffic and consuming bandwidth
+ * that could serve foreground direct I/O. This can hurt performance,
+ * particularly on bandwidth-limited devices such as HDDs.
+ *
+ * This does not depend on CONFIG_BLK_DEV_WRITE_MOUNTED. Writing directly to
+ * a mounted block device is dangerous and intended for system administration.
+ * Charging the cache from these writes to the root cgroup is acceptable.
+ */
+static void ext4_bdev_set_kernel_file(struct block_device *bdev, bool enable)
+{
+	struct address_space *mapping = bdev->bd_mapping;
+	struct inode *inode = mapping->host;
+
+	inode_lock(inode);
+	filemap_invalidate_lock(mapping);
+
+	if (!!test_bit(AS_KERNEL_FILE, &mapping->flags) == enable)
+		goto out;
+
+	/*
+	 * Folio removal uses the mapping's current accounting mode. Remove old
+	 * folios before changing it, excluding new raw-I/O cache allocations.
+	 */
+	sync_blockdev(bdev);
+	kill_bdev(bdev);
+
+	if (enable)
+		set_bit(AS_KERNEL_FILE, &mapping->flags);
+	else
+		clear_bit(AS_KERNEL_FILE, &mapping->flags);
+out:
+	filemap_invalidate_unlock(mapping);
+	inode_unlock(inode);
+}
+
 static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1387,6 +1437,7 @@ static void ext4_put_super(struct super_
 #if IS_ENABLED(CONFIG_UNICODE)
 	utf8_unload(sb->s_encoding);
 #endif
+	ext4_bdev_set_kernel_file(sb->s_bdev, false);
 	kfree(sbi);
 }

@@ -5852,6 +5903,8 @@ static int ext4_fill_super(struct super_
 	if (ctx->spec & EXT4_SPEC_s_sb_block)
 		sbi->s_sb_block = ctx->s_sb_block;

+	ext4_bdev_set_kernel_file(sb->s_bdev, true);
+
 	ret = __ext4_fill_super(fc, sb);
 	if (ret < 0)
 		goto free_sbi;
@@ -5877,6 +5930,7 @@ static int ext4_fill_super(struct super_
 	return 0;

 free_sbi:
+	ext4_bdev_set_kernel_file(sb->s_bdev, false);
 	ext4_free_sbi(sbi);
 	fc->s_fs_info = NULL;
 	return ret;


> 
> 								Honza

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

