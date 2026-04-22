Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A801F94CD9
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 07:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E235E6B0092; Wed, 22 Apr 2026 03:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB4D6B0093; Wed, 22 Apr 2026 03:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D111E6B0095; Wed, 22 Apr 2026 03:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF83B6B0092
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:23:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D4AC141268
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:23:29 +0000 (UTC)
X-FDA: 84685351338.10.A34EABC
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id BAEB620005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:23:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="duT/Gt2f";
	spf=pass (imf03.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776842607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=6GXQBvjZucb9BRi+RMNkbcMHqj4d7NoOUxb7617xRyM=;
	b=SYGJKgyI5aNuHhLtXAofXvJaP9QYtyfQHOpjhAedsZuG6sWvpbE4pG9Kb6Tby7XkZKjyFI
	s5992V16aBgWstDZRDCeBbj2EyHo9Y7vtp5YTvUR0+dUhPKafGy/TfU3cB/ZTDvhHntmRm
	yY2koOApqzH49idGorUjfcwW/k9YvqQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="duT/Gt2f";
	spf=pass (imf03.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776842607; a=rsa-sha256;
	cv=none;
	b=ghmSckIrnbPd7DsE8KiLpxhoR+gxDS4xM3SJMBIXSSWQzyODkSX3tofMjxhH53MatFd6gg
	3Siz5snc7Udnu5bd9QbPKM/xHqJ0OckuVOM9IHGjtb8T5WL/9hb2stfvU21NmO97APbJkN
	O2OYeaMvJTYf3PURTpdZKOH14Iwhqoc=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c7971d0d97dso3078632a12.1
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776842606; x=1777447406; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6GXQBvjZucb9BRi+RMNkbcMHqj4d7NoOUxb7617xRyM=;
        b=duT/Gt2f0UJo3eImgBjCEVvTOXnDRZX9cTOS4LCdmBu3Qed8BRV9GyToiPP8oThGQj
         4mOPN7BIEVVUOupUsLDY5WMonXL8QR8+1jtCaUZpfwYYUx/RSXLXQN5EDq1N7lh7NhvM
         ZCMZUfzSFzVtR27LcEzIhYQfROScexerqXrlsyrX/eUgYy36pN2JWU3ZY79EZQCNE9PW
         7tlwc3s9mOfRm0E9BCSE87RheNJMTd6Ol1b1mlVAp7hTf3Zh6fYwhsSZK1qDb8yfFe1T
         Shr5/3GhSbbcCZbYFaoU7CmNdPfEwfLylxdIA2HIOPGm+GA1ZOv2iVOW2nRgr7hzNslO
         95YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776842606; x=1777447406;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6GXQBvjZucb9BRi+RMNkbcMHqj4d7NoOUxb7617xRyM=;
        b=DDGRWSbpQlkCrnqfJwBQo57+wmGllGY82cv/XDm11GGUZG+RAQ/z5VSpmre1fiNcm4
         9TfFdqD3GKaA1UwYD4D3YSHIMPFAVhljTbKifBigKveMZMnxCoxzmf7ojdnIs7YaYCK5
         Oyq8PaHn8nacsZO+gB//c/YbJwVpvzsSWV6sJwV/lJAgQj8IF7R9Iu16UMww3FKF0RxM
         jRJTvuXYCqucsEXyP2LmHeZirKeFNKAHgGwD+KOTo53+xTq6yOCW3cw7XpT/gkwaS1yh
         BcNhIMk6IF1ICPOV2EVLdcjBXXm3/+pLhud6ATQ5CM4+rYeX7F1pMoMFP1W18G/UKGv/
         FU6A==
X-Forwarded-Encrypted: i=1; AFNElJ+75sSJ9Ugxz4ywpNTzBQZNiw05DPi768cuwrHmQgJTjS9tNqmGTG3Q+Uq2QTpniFsOOy+Z3F7uIw==@kvack.org
X-Gm-Message-State: AOJu0YwtJbVYbodhIH4Y0jpzqzurkFNMqBjFPxBWH06t75n9AYDV2yeL
	ed2LaVNyogbHHmh33/gV8qKzvRCwr5snuVcb0KWj9KlgzTbOCMk233vW
X-Gm-Gg: AeBDieuXNPGBqpka9yykHs7viTrmjcrFfPKsZQcLT5y10+5hvILye9TaWCO5cpzSM6r
	cjsBRseK9+HzEoXIAlclB8qEZ+MffpyRJ6w53z83VZIN+JZI/lTSg98Ck0YUuEbKICUjAmHRyXe
	2nsi7ah9bn9PWVNB6nI7Dqye2jteYZWrSkKceHBPHYANYgINi6ZzKmP9gCpD9B9Wo6I7rKG/443
	kz+6zRRBCwP5UnjQH84R0E1ZIAzO3i1axbvtyxKwgGVF/sCwWQcZraqOJyJgtf/vDTb3Z/oIvpc
	VX22o3bORHDVpyrNE+QjQ1KxJyj3sNscxSzqpo1tUHdkTkBjTItXLvDqCsiN0lD/bb/3ANoJAz3
	PQdcOBQ286VH1uu+6RY1FGEPMpuyDQuAbj0ex/e46xp+RZdMas+bNeA+Ku5cICWfy0WBCnF0/Vw
	lJN6HlClvygRs0WWVLXamSqvd6kwaNMBXlR3IHwpsdC50=
X-Received: by 2002:a05:6a21:9992:b0:3a1:76d3:c1b0 with SMTP id adf61e73a8af0-3a176d45c75mr15445512637.22.1776842606435;
        Wed, 22 Apr 2026 00:23:26 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7976f8f370sm12580681a12.7.2026.04.22.00.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 00:23:25 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Pankaj Raghav <pankaj.raghav@linux.dev>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu, andres@anarazel.de, brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered RWF_WRITETHROUGH
In-Reply-To: <02ed5bfc-7ebf-41ee-bd8a-c8e030c35bca@linux.dev>
Date: Wed, 22 Apr 2026 12:10:20 +0530
Message-ID: <5x5jts4r.ritesh.list@gmail.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com> <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com> <kvxvy26jblhx6sijbhxbpzzwltfoskwkv2suqhop5dq742fn5y@5tlws6pzaol3> <CGME20260421181614eucas1p119dfe990221e6cb397d647cf24dbfa1f@eucas1p1.samsung.com> <aee-xaUCWMM4EV7Z@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com> <02ed5bfc-7ebf-41ee-bd8a-c8e030c35bca@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BAEB620005
X-Stat-Signature: 3wcioex5uq5f5r9c3qtx15ihsopj5s1e
X-Rspam-User: 
X-HE-Tag: 1776842607-481804
X-HE-Meta: U2FsdGVkX1+REMhCYanIViMOpbmZnitq006AGdte+7CiveBr6H8Ch6BV8wchaRScfEYHdxroIXP5cbcUd7EWyzJUt7LXtF/r+FsApHEc54+gWm8oz6A2Rp1AR14RWypA5leGbjg1m1/tEwZnYaZCM6sqnXmG0VR0uugj17U7I7TCYmDsf5QHI3sp0aPlsNn7NmYge/EIUwr2Ytnr3KP2KBIqhFyZ4xQ0DRPJLPsntznDGESdXJcL4IiOtoLYz/Jv8UcHTqXlCorVJcTGLMcvLZDsC5B82KgsB0cGEpISNhD+OxO+VaCIEZXeTlDx5ZV0SBlVJ/USFtBksJ0mGILnexQbIdj4wZmiLaZVL/VfU0r+43jhmoYeH6TVhY5FL+xHcjT7iwWtTRT4/Mcq4oAoTNfvAaiBilM/SSBxjVJHMvaFmEcLARbl9AtpcykJM5xukvl99TLUZ7IWO/ygr2hkKpUQXFU3kHRqUAWb+8bLghZrQZZsk3bZELC/rKrD55Jw1p8QEN4AXDqlcmwHyE5mBAxfLYkNhYQ/j/BnNkEzgs1ajYJh0igTzDc/MXpW9qXt+dbFJcfG0MkWA35RVxUHUXKskuB2Yxpe3eY4/VZg14utNRi8KJhRtlLpTCW5g3xbGN/JC3aiWUkXGamPfRkGvh2Yx1vpZy6PlDerqzAg3qC5vs13PwuZzyF5OPOHE6ahxHQZAE7yuABROPPs5kvUuRsTk1c7ecrxfPcArOB4hhR/8AuiYq7rme0QX3X98xCW/gMo07xHKUkmvtAOUx3jap1KBapDUdUi4DDbxGZJ4ufi06eXuCWFINnd8hKDvZLYXwuYOAgsCEAZDvDDj04spAAUj84D++/hJzwE2i+rO5/IfbMD/YM9j8R9VLeNTsvwDSGDHxB8X94ofZaD1CdYljHVlsqb1CJAKcWk+Z66kRfBvTyT/29TuPog2k7wWlALvadzhI7kvUYQFgBrzKh
 JEuFH2sG
 bhhoLUqTZz9huhHRc07isxUx1bBcz4+dWhw65/Fcu2FNaNsC7/6TQFX69kxpOPZLjjoRQAxoICzaQYONdHOPRJfGROvu9HXfjEy0Ao5NdNxxi8vJGTSMxesccHoqBRyil6vGeWt/2SAUaOUJRLMzlZjPKseajdrGTRQ6CkXCs47plf/5Dv6qVnOR4wuSKC9aBh4uL9GbykXjqXB0kyM+ZDO6v9W9r5cgsY6AgoF7XuuCrMFBi9SabCL7t2EQcRXNHVmz70yU8pIgkiFV0KHae/D6rv+uAiJWz6wq2eHgpQf2XK3kWqDfxtty63ZxkA6Z9FLx9zNW7SDDTnWVFpDCLvWC3BhAWiTPAEXXyQGMh0Gyb/CTvoO5PWKltIxeEgBBAc2APEyEK330FZo80F72lCJ9QXSzBBN+2az+8Vy+04V31JydQN6T7MvhIxWX+EkUnlPRuBN/eMhsrx9AE8MMXA5l8xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pankaj Raghav <pankaj.raghav@linux.dev> writes:

> On 4/21/2026 8:15 PM, Ojaswin Mujoo wrote:
>> On Mon, Apr 20, 2026 at 01:56:02PM +0200, Pankaj Raghav (Samsung) wrote:
>>>> +
>>>> +	if (wt_ops->writethrough_submit)
>>>> +		wt_ops->writethrough_submit(wt_ctx->inode, iomap, wt_ctx->bio_pos,
>>>> +					    len);
>>>> +
>>>> +	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, REQ_OP_WRITE, GFP_NOFS);
>>>
>>> We might want to check if bio_alloc succeeded here.
>> 
>> Hi Pankaj, so we pass GFP_NOFS which has GFP_DIRECT_RECLAIM and
>> according to comment over bio_alloc()
>> 
>>   * If %__GFP_DIRECT_RECLAIM is set then bio_alloc will always be able to
>>   * allocate a bio.  This is due to the mempool guarantees.  To make this work,
>>   * callers must never allocate more than 1 bio at a time from the general pool.
>> 
>> And we seem to be following this.
>> 
>
> Makes sense. Thanks for the clarification.
>
>>>
>>>> +	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
>>>> +	bio->bi_end_io		= iomap_writethrough_bio_end_io;
>>>> +	bio->bi_private		= wt_ctx;
>>>> +
>>>> +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
>>> In the unlikely scenario where we encounter an error, do we have to also
>>> clear the writeback flag on all the folios that is part of this
>>> bvec until now?
>>>
>>> Something like explicitly iterate over wt_ctx->bvec[0] through
>>> wt_ctx->bvec[nr_bvecs - 1], manually call folio_end_writeback(bvec[i].bv_page)
>>> on them, and then discard the bvecs by setting the nr_bvecs = 0;
>>>
>>> I am wondering if the folios that were processed until now will be in
>>> PG_WRITEBACK state which can affect reclaim as we never clear the flag.
>> 
>> Hey Pankaj, yes you are right. I think the error handling is a bit buggy
>> and Sashiko has also pointed some of these. I'll take care of this in
>> v3, thanks for pointing this out.
>> 
>
> FWIW, I got the following panic on xfs/011 (not reproducible all the time) when 
> I was running the xfstests with 16k block size with the writethrough patches:
>

Good point. I don't think so we tested large blocksize path currently.

Ojaswin has been running fsx and fsstress and we didn't hit this
scenario. So yes looks to be some corner path missed.

Thanks for testing that.

> [76313.736356] INFO: task fsstress:1845687 blocked for more than 122 seconds.
> [76313.738751]       Not tainted 7.0.0-08885-g97cbd56b7479 #43
> [76313.740650] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this 
> message.
> [76313.743311] task:fsstress        state:D stack:0     pid:1845687 tgid:1845687 
> ppid:1845685 task_flags:0x400140 flags:0x00080000
> [76313.747137] Call Trace:
> [76313.748000]  <TASK>
> [76313.748830]  __schedule+0xcc2/0x3c40
> [76313.750129]  ? __pfx___schedule+0x10/0x10
> [76313.751479]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.753214]  schedule+0x78/0x2e0
> [76313.754334]  io_schedule+0x92/0x100
> [76313.755597]  folio_wait_bit_common+0x26a/0x6f0
> [76313.757156]  ? __pfx_folio_wait_bit_common+0x10/0x10
> [76313.758873]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.760508]  ? xas_load+0x19/0x260
> [76313.761693]  ? __pfx_wake_page_function+0x10/0x10
> [76313.763386]  ? __pfx_filemap_get_entry+0x10/0x10
> [76313.764948]  folio_wait_writeback+0x58/0x190
> [76313.766499]  __filemap_get_folio_mpol+0x56d/0x800
> [76313.768085]  ? kvm_read_and_reset_apf_flags+0x4a/0x70
> [76313.769899]  iomap_write_begin+0xea7/0x1e90
> [76313.771304]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.773016]  ? asm_exc_page_fault+0x22/0x30
> [76313.774427]  ? __pfx_iomap_write_begin+0x10/0x10
> [76313.776100]  ? fault_in_readable+0x80/0xe0
> [76313.777476]  ? __pfx_fault_in_readable+0x10/0x10
> [76313.779106]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.780765]  ? balance_dirty_pages_ratelimited_flags+0x549/0xcb0
> [76313.782861]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.784457]  ? fault_in_iov_iter_readable+0xe5/0x250
> [76313.786221]  iomap_file_writethrough_write+0x9fd/0x1ce0


Looks like, while we were in iomap_writethrough_iter(), we ended up
looping over the same folio twice w/o submitting the bio.

So this could be a short copy case (written < bytes). I guess, if we
have a short copy, then too we should submit the prepared bio in
iomap_writethrough_iter(), otherwise we will deadlock when we iterate
over the same folio twice. (because previously we changed the folio
state to writeback)


> [76313.787978]  ? __pfx_iomap_file_writethrough_write+0x10/0x10
> [76313.789991]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.791589]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.793314]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.794932]  ? current_time+0x73/0x2b0
> [76313.796132]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.797276]  ? xfs_file_write_checks+0x420/0x900 [xfs]
> [76313.798786]  xfs_file_buffered_write+0x195/0xae0 [xfs]
> [76313.800243]  ? __pfx_xfs_file_buffered_write+0x10/0x10 [xfs]
> [76313.801775]  ? kasan_save_track+0x14/0x40
> [76313.802843]  ? kasan_save_free_info+0x3b/0x70
> [76313.803908]  ? __kasan_slab_free+0x4f/0x80
> [76313.804894]  ? vfs_fstatat+0x55/0xa0
> [76313.805835]  ? __do_sys_newfstatat+0x7b/0xe0
> [76313.806899]  ? do_syscall_64+0x5b/0x540
> [76313.807829]  ? srso_alias_return_thunk+0x5/0xfbef5
> [76313.809052]  ? xfs_file_write_iter+0x22e/0xa80 [xfs]
> [76313.810451]  do_iter_readv_writev+0x453/0xa70
>
> I have a feeling this has to do with the error handling as we are stuck waiting 
> for writeback to complete. It is not reproducible because it might be dependent 
> on the state of the system before this triggers. Let me see if I can find a way 
> to reliably reproduce this so that we have something to verify against once we 
> make these changes.
>

Maybe we can add a WARN_ON() too to detect and confirm that this only
happens when we have a short copy case.

We will give this a try too at our end. Also the error handling pointed
by you and Ojaswin needs review & fixing in the next revision, to catch
any remaining paths where we may end up like this.

> --
> Pankaj

Thanks Pankaj for giving this a try at your setup.

-ritesh

