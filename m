Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C099CD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 04:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51E76B0088; Mon,  4 May 2026 00:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02426B008A; Mon,  4 May 2026 00:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F16E6B008C; Mon,  4 May 2026 00:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3056B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 00:11:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16CBE1C0912
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:11:22 +0000 (UTC)
X-FDA: 84728412804.29.08F16A5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7F2761C000A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:11:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cDk5odQF;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777867879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pu1MzcUI/l6Cm0rp2QFR6z3D/O2HWrrKP5PFPjdVM80=;
	b=58RYAnBp9u/s6XYEPyHUw7YBbe2PBj69ZH6Hk0bqoDJ1pfivN9egVeTDNAhqfH5VDEEXJm
	PFWsKHXUm7zZ8LQdOERb20hXTqFxauDjjdIckvq5dQEGNUrzqX6noEW5Cs+W6E0j3xzEnp
	lK7pgbmSt9p9cZMLMJO67z9QxMAx7iU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cDk5odQF;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777867879; a=rsa-sha256;
	cv=none;
	b=boBbDn5+9zSJaLn+HP0mQyLD+U9bjffbJr+p0zgymUWYiiBndnXa9nhefmTlYuMOwuwUaY
	Ea0HYUjK2UlitnUBHfFXZkZB0ontAa1UBg8Kdf7FJ5wBZu8axVU2oDjYL/QlukW/4SxhZu
	yF0i8U9OrbH/9VP7j4GztUjzr+/LxDk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777867878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pu1MzcUI/l6Cm0rp2QFR6z3D/O2HWrrKP5PFPjdVM80=;
	b=cDk5odQFvyvKHGBt2sp8352TmCDoGENN+yb1fObvwXMqBQZOzNM8vYmwYuqF6UOHEqKDpE
	O/MeRaS6s3fAhygRwupZM0T9+ineNrvbw7DoRQmXvjGpW4QwQoxwrmox7W9rtsFe+9zA6A
	S1X6gfvjGNE5pdl9TqOrP2tQisT3y80=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-sj7Zmx6KObS38nSarPAbKA-1; Mon, 04 May 2026 00:11:15 -0400
X-MC-Unique: sj7Zmx6KObS38nSarPAbKA-1
X-Mimecast-MFC-AGG-ID: sj7Zmx6KObS38nSarPAbKA_1777867875
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7bd5c421975so50153227b3.3
        for <linux-mm@kvack.org>; Sun, 03 May 2026 21:11:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777867875; x=1778472675;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pu1MzcUI/l6Cm0rp2QFR6z3D/O2HWrrKP5PFPjdVM80=;
        b=oJLKmJOmPY5jHHWR7lyy6KHgMH5+LErBLEPYJCmC6Xb6goVwJgO4XxZFdvjlVQMrOK
         7VKhviHFl7gAew1+cu6bz4DJYctGaGo3ghCoQvXbvvXsM3YTaibuGIsO+oYRxmy9E5jw
         2wK0x9EjMN5WG9tCikZ0H+etuu1XXrsc8CfGaUovuc+6PLn8rYpyLOIdOdlzZSOFnSf4
         16Zg5GrXq/TpBtXc8d7CT14nAEfkyVfN8Pu4FZi+MQVpbl8hp+p6GwAPfADjzX221pfK
         X5efgdVKKDTHL7BsgnQKyQIGHlA3qlKDafeqScRMywhlhaytqN0aljG1a8cchC/g2tZ2
         jc/g==
X-Forwarded-Encrypted: i=1; AFNElJ92cO76je38NdepMiuJ0SLpWXzrBDVz5hx34vF3BrPV35ZDMcbF10TCKekNQj4+FuXm5pqUB/P4+Q==@kvack.org
X-Gm-Message-State: AOJu0YywPehk7g6QPiEbtNfvpjteEe41wAzgFNtqqOVbRzP6pGTw8WUR
	/TEMxCerZSBkExsoKA5g+O3ImNb7bz+c0LYQTt/y9h1oIQGk0FsQKbHupN5FAUkltP2XWhrFtvH
	49qQWxUoISZFrQ3QTsniz8Z1VqWKQQAFE5za3no3A0foTeEEQvCuY
X-Gm-Gg: AeBDiesi+shnYl4W9vS1ASLpLVp8EfnhUCbTrKVc2k6VBvNI04Wj1vXYZ0k4fbfdlzc
	NOHtXxcVcIU5rL0O3ZW3S/xsCR10lYmbk5vuITaSs0ft6ZIGdUhZoWCZPRrs2SWlWDt3kC4OtSr
	EqpRFn2YLVfc29RDBHloH1D2zL4J+I9fAK1bwn8fxwhqqyacjhfT+UCb3wpBMMKx2IGEKiy/cV3
	7SJlq/GUYw+x3XMyciC8o3KFJoKq4xHikdneuyKtOfIkcwl6/Li9fEm0jRKf/6V90GNf7fDjmWu
	0xezINybs0RfPXVcFt99WSj3tbTrEw+Mx6M6BAc6dQAjScCeRzwvsm8IO0MFlgfE/RbtXrQRnUv
	BJ6KEp3rAgNdYa+0zz5cQz6ylY5sVWcgckvOyEsc10hAlDbGAsC+9Uiw42cVQKc+3Uvs=
X-Received: by 2002:a05:690c:398:b0:7bd:8cd8:d6b6 with SMTP id 00721157ae682-7bd8cd8d855mr29092537b3.22.1777867875011;
        Sun, 03 May 2026 21:11:15 -0700 (PDT)
X-Received: by 2002:a05:690c:398:b0:7bd:8cd8:d6b6 with SMTP id 00721157ae682-7bd8cd8d855mr29092277b3.22.1777867874473;
        Sun, 03 May 2026 21:11:14 -0700 (PDT)
Received: from [192.168.178.105] (78-0-206-107.adsl.net.t-com.hr. [78.0.206.107])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6654e464sm44532247b3.14.2026.05.03.21.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 21:11:14 -0700 (PDT)
Message-ID: <1f3aedf7-9e48-4650-a7e2-5584c8b299c7@redhat.com>
Date: Sun, 3 May 2026 22:11:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/14] fs: remove nr_thps from struct address_space
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-3-ziy@nvidia.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260429153538.727855-3-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: offlYAa6XtwhXeHGccDb-ysxU9ep-A5ELqg3KG1TpGQ_1777867875
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ih1d1cqgadxnyf7cwk4fzk7pwbgt1ux4
X-Rspamd-Queue-Id: 7F2761C000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777867879-665525
X-HE-Meta: U2FsdGVkX1/hPuK3nTRD3iF+cS/LludCIc7itiWVg+KAMkWUFG2w9HPWT65qybGJI+7JUHgNcoh04NlTJEgyycEP6hJdextfDD68esjs0Di87wdPln2BudSyXvP5n+4X4OpkgS1EQrXBbpmKz5MsBTsBM3Z/NFzPbCCIeTOI3U5VKQQKW9Am/mVsLI6BljzpffPIyJlipX9KjGl6CIx362Z3u415RRzQoRzFVxbm9HXV4uLs6t6/C66EjQlCZZwl7u+IIdoYtYzBD7rhthXCBd7W/QUaULREGtvaxa5uFCKbvwXR5sIpd5cv1GjFTRqj9IMncKkgB6s8e9LNBlc9PGkNEzWO93LJodBAStafNbmEYl8fVSuVrOs8FKIRN75hGJMlEgpx10Um8tp0jP+6WmYQ2yxlchejPbyeNtZer77biPS+Vpmvghf4Pv836B4Ta0qJ9aBfm78efeBWGG3CZsmyLGu4+v3gOy3F/Yphobt8WCIacUhCsiyx4aN4wwWlCa7+as4nE7IT5VU+/WEu+mRacRbkFxtECTfEYBb8CD2CPzFv6vgSOopvLvJ+sijCxekulPgehDGGTO1y8Iyl8OJP68SErEdbAqFYcl0kffh8y9P40wm6jasYFJcgl/xFeDtcoekP4qIurnqRh7h4AjVp483IJZPuXSx+iQ1WjHv00OuoHdnWuRQymHqFfv34RQxoYQNQnx2LkH9SXCAfGPgdYcVfcZwQn8z77WxbgYx8Tm9dmHBtZBsK4BVCYxqEx08j1zu69i/qPbPy2KvPshyv+OdK6zhTYx+biAcse0emcn/gHyJdy8/KpV8/VBMB9nX9IsHfqvb+MmdahNjyPy8BGQ6PDeDktj3kpBnetlxUFl/fX4FQyNPIL1nISJVc+zVAsphJSlLxeOQKyx1BO2WfQgYlP072cZi1UUBxGML7ciu4cCaBJ5wp4vPl8DJM8mmQfltba9wqjq8M6D2
 lOs7cip1
 IwrUtu8uA7ff6zwii6vPygDBrVnOps+pHgt1g8zuxRvNtyvMZtgHV1iwK+4yj4PW4ReAq7OcWS3Snm0+JqeFPkkn8zEQaM5YGm0lyxoS7zHnq75tYMJ8XEmG4yltnQM0jt+JdPmC8TxHUOYyuGPLoLMjQb0G/Vhj/UiRxdhiPcNLEgYbmCwxAo+jK3vu9pa1NRy/j1RizSZU4YX2B9gBsNu2pPGSHqfaO7n3UF6aljW1+qE3aq9t1LyHaBoOR2k55Ax8kZBA97Na7Az1L9cSSzko7wt8rqzYhDiqwgJTzlJuRwsKqU7jXKfqJ5190TDpydrUPGybJZ3eA7hvO6boBaUdNtSgfD+6Fnrr1wkOZA/VXZuyA4CooAZybQ1+cn17e826fpiUGfc0Crd1OjE7juQSOSGMHMJ/oolhBfhfmCZcAYouSM/DN+eLM1RKCb+UskYT7nDzDl+gDlIrSQaW6TMnVv2liETRXdf9cUE5jfrLYNza5c4vuRE35l17DJMXDo9rLZDRhlLrowG0EmJyP7PWny7v5HDAHWbrB4XqeCwaQFNM7+XX6d9T9ylTH0CaFCxUiwlJAN9kix5kcQtTxzW8CiNLXm7TtZEVUCREN8x9iGOodQHF8EtAwaKSvtYLbOf6q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 9:35 AM, Zi Yan wrote:
> filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
> is no longer needed. Remove it. This shrinks struct address_space by 8
> bytes on 64-bit systems which may increase the number of inodes we can
> cache.

We've had performance impacts in the past by changing the alignment of 
certain structs. This is a rather critical one. Ill keep an eye out for 
any performance differences noted by our PerfQE team surrounding this 
feature.

LGTM!

Reviewed-by: Nico Pache <npache@redhat.com>

> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   fs/inode.c         | 3 ---
>   include/linux/fs.h | 5 -----
>   2 files changed, 8 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 6a3cbc7dcd28c..d8a6d6266c3c3 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -279,9 +279,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
>   	mapping->flags = 0;
>   	mapping->wb_err = 0;
>   	atomic_set(&mapping->i_mmap_writable, 0);
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	atomic_set(&mapping->nr_thps, 0);
> -#endif
>   	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
>   	mapping->writeback_index = 0;
>   	init_rwsem(&mapping->invalidate_lock);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 11559c513dfbb..bb9cc4f7207c1 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -460,7 +460,6 @@ struct mapping_metadata_bhs {
>    *   memory mappings.
>    * @gfp_mask: Memory allocation flags to use for allocating pages.
>    * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
> - * @nr_thps: Number of THPs in the pagecache (non-shmem only).
>    * @i_mmap: Tree of private and shared mappings.
>    * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
>    * @nrpages: Number of page entries, protected by the i_pages lock.
> @@ -476,10 +475,6 @@ struct address_space {
>   	struct rw_semaphore	invalidate_lock;
>   	gfp_t			gfp_mask;
>   	atomic_t		i_mmap_writable;
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	/* number of thp, only for non-shmem files */
> -	atomic_t		nr_thps;
> -#endif
>   	struct rb_root_cached	i_mmap;
>   	unsigned long		nrpages;
>   	pgoff_t			writeback_index;


