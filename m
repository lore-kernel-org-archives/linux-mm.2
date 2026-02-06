Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA111EB28CD
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 06:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462B46B0089; Fri,  6 Feb 2026 01:04:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4107F6B0092; Fri,  6 Feb 2026 01:04:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C3B6B0093; Fri,  6 Feb 2026 01:04:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1DBA66B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 01:04:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF052C27FD
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:03:58 +0000 (UTC)
X-FDA: 84412990956.10.DA15DD7
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id DF87CC000D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:03:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F0cljNnD;
	spf=pass (imf22.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770357837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snv1+tdro/8nDsA6C8wgWM9ZO2V2RnvICdRidY8H0dI=;
	b=pPjADsEv70OeWJkH+aWnKZYuAUSp7hSuaLYObm9mmNUt22w5Fq1mcfbkmiLP1KkMdFiLL0
	wWbfBcw3+snzr89kCU9gbjzoBnfmOS6IQq4Gl1f/PNmrb1Sqz2PLdNRa+8lgzLpS0+Hd+h
	K21sf4a0fLtnypm18P5fV+iWXC7jqDI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F0cljNnD;
	spf=pass (imf22.hostedemail.com: domain of nirjhar.roy.lists@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=nirjhar.roy.lists@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770357837; a=rsa-sha256;
	cv=none;
	b=B4Bh51HvJXR8YdEl6+7hlMnu1gOtNfcasC906TxKRrK7zrqn3LzDdkciiYhw4n+pqDTucH
	c/8D22mNTe5wJlic9az544qkInqUrx1Mlw8Spicev9ACu8T0OiOksV3ZhVcyCUkch+wJwV
	BG62RRmJGhxTsRYsBbimRYWpcbGvdhc=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a7b23dd036so1563585ad.3
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 22:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770357836; x=1770962636; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=snv1+tdro/8nDsA6C8wgWM9ZO2V2RnvICdRidY8H0dI=;
        b=F0cljNnDubmAbY6OZP4IL8xMQ/Svc+jZsbUfwp/d0cI5tWKavaUHFZJmuINshYiU1t
         wVwHHGsiEmyWkcKr1X0PQmPBRev0d8Ri+oaYQz06Ec1944FdWqzkXDut6wRbPh08Ut4P
         FXebBqj7lY3rVivQ+ZHk2NsDe+y401TkH01C9yOelsVS8ucgakT87L0ox/hRzPGcXrCm
         g8IQNzlAnnxaBbBJzLbOTuCtQymGGVPWUq0Kwziqn02PdLG/ppakxHkFR1QoXIUnwlFU
         u2Qvh7hiozo09wxVZEsAjpfIf3QOhswXdhj6JLK+B1ha73APCKp0Svcz7KAm+soL5Wqs
         F07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770357836; x=1770962636;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=snv1+tdro/8nDsA6C8wgWM9ZO2V2RnvICdRidY8H0dI=;
        b=MPSVZAqg+0U8valUuLjUKp5JI+yzL76cH4Jr0ALB1JHBd/kJYS384fJJlLRjChlYW4
         UEPy0+QlJzqJAvoyNGILeRkLzw1P24/feFPSETjRoqFcgaet9eQ0rkszlREXhR4qCGwa
         65ywvwSYsaoLyJrAUimyfbe5yAsDhjNq6BMjWcJlL+5ZDTqw2uiB/w9DNdJz4fnx0WTx
         GgRYUaqlkhbRlzYS7F1LZd7h3rR9iS4bCaoTLvxhcG+/873hBURynpA5t269OIn86tzo
         L5ZctLRGYczm3x+FZflDypRqhQ2jvtorTCHanqUDvU+J4G54ycZnzatbd1XGWKL+QIac
         1GXA==
X-Forwarded-Encrypted: i=1; AJvYcCWZ8bgPU8Ij8CGRYeoP7gT9/fOpwojnUCUzAkY8flHqagljYvD5ppbOU5Pgu5me2QZH8PU9pc8I/A==@kvack.org
X-Gm-Message-State: AOJu0YwFSVvwBt2hHIcOtmk4dw2UkaoJQO6/4rHU8gqqKzRmR4G99zfQ
	0oWWm6NFC5DmSTjAfow9Emg+H57wuDVu6rTYy/SgrqdFLVkqNLBMHhK/
X-Gm-Gg: AZuq6aIbtOQdq11gDVdfZrxuQbXUTOa8ULM8WPBpeQ1wfaMWAdi1YmWPOrkUJ2XMhMM
	0vGPUxonPaljjUgsOwU7zeyRN7cBq/zzirjKGeLq2Pb8aA/joBfMmnLaV6WVQ3OBbx7kGHC1IUz
	iJs4fJnPiFjlzpIw3kt3z8HtdTO5iK7XL06RvNdUpXsJ+IUSeBgF5kFMnb2ViT8/J6OMENeSLkn
	rIaG/MLvAzEoTYpIWSreJLEUliXD5jqHU3apLB62nQybnVoaiFWVUuaZsA8gkW0IqfHF01cWA8c
	BeWK5FZfc8cnrfU4EIaxqU9T5OGK6qlTyDOO+kfm7pGR/m7kP30R7uhfdKVwWwg8Pk1L8b9rChY
	rTTZtsswuOdXHG9Kwxpdj/vUZdCBpNC0pooIjnPG5B2d6puxG2+k/q068F6LN0kE0Jp52rALmpT
	VLPjw+eLwAGNXg5mmnoYNJFtqbRd48kO+x
X-Received: by 2002:a17:902:d503:b0:2a0:993b:d72a with SMTP id d9443c01a7336-2a951608a13mr19199085ad.4.1770357835617;
        Thu, 05 Feb 2026 22:03:55 -0800 (PST)
Received: from [192.168.0.120] ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3549c38fa4fsm4870105a91.13.2026.02.05.22.03.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Feb 2026 22:03:55 -0800 (PST)
Message-ID: <a0850469-51f5-41f4-b7da-4eb61d6a8606@gmail.com>
Date: Fri, 6 Feb 2026 11:33:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] xfs: add per-inode AG prediction map and dirty-AG
 bitmap
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Kundan Kumar <kundan.kumar@samsung.com>, viro@zeniv.linux.org.uk,
 brauner@kernel.org, jack@suse.cz, willy@infradead.org, mcgrof@kernel.org,
 clm@meta.com, david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
 hch@lst.de, ritesh.list@gmail.com, dave@stgolabs.net, cem@kernel.org,
 wangyufei@vivo.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, gost.dev@samsung.com, anuj20.g@samsung.com,
 vishak.g@samsung.com, joshi.k@samsung.com
References: <20260116100818.7576-1-kundan.kumar@samsung.com>
 <CGME20260116101251epcas5p1cf5b48f2efb14fe4387be3053b3c3ebc@epcas5p1.samsung.com>
 <20260116100818.7576-4-kundan.kumar@samsung.com>
 <87a16d4d9c1e568a37fa07a97dda5777e14e9a8b.camel@gmail.com>
 <20260205163650.GQ7712@frogsfrogsfrogs>
 <a017b49e0fb5b9f1a4f6929d7fb23897c98e2595.camel@gmail.com>
 <20260206055745.GV7712@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20260206055745.GV7712@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DF87CC000D
X-Stat-Signature: 87ck8m489pejgii7pxicbhgicogm9r6a
X-Rspam-User: 
X-HE-Tag: 1770357836-372138
X-HE-Meta: U2FsdGVkX19sXBZTUuTuo2CBe25789gQJbX8uZR43P/BAkb8HP5WiZrJOKGFhW0LgbXMZOEzbakB0KKlWJnTrEI+YMCPrHBnseLSThm9rLOUbBQYYeQWJixV55PjZAeyxsRX4mVsBHjB+TWIVCevVWKfNPN/Zcwvrk0cCpvHU4ixDhwvR0oV+Z6jngufnFON329lZmT7o9wkK8YWMPE8pMaykd4pV90n7kFAAkigzTczgndUSJe4HJ1xujkCKy+yXdTRX7o8qk6BQ7NSBdw18L0RiyET2hUh5fb6lNmA6cWgn9nzuqhRcBqTO6u8Q6TepC5RQeviAIPa03Zjt6JhdiiZpJDz2jpd1gQI3YfPWJR0IhmTNjtFC0mAMhkCUOBe+GZhQLw+mWmVcHEPhyIRefOz3Mb/FU3HZYOcpJUf507w+mwwc8qJ0+60XonprvsJP5YaWmKSIEuOf6WqbA0Fegsk/YmJAFxd1jyysepdAD6XnWdGv0gqjJg6x7NdiYjOpTFurospM8BFxY6AyaZIhKRqDnShfNljlUqLIfui0GquFAQtD7BVYcwfcpXtHZJGNP6+rkVZ5BvXxOaH2QypZEYdQ95q9EoSJAXTq77/eep4FHzcKbA/HN4A9TxlyDdjpaNcrNhk0+xDcZ6ATJdXDDbpKaGKawohT7htp35TU7b2YE2w1HrSdMdJtwIjvdsC6BCWtKwdnLwguFILKJF7vjb+zPmtk/p314IgJ+RlFP8lhuEkxOXKUHZ9weF4iMMMHeqoOe0VCYWFzmTz2tA6woM6vZyn9g3AqvlTDF0Hj+qUq1CQWwab0JEWon9Zr4goV8w9lvNXTUbCcb0iKwRBY4h1rK8rG2Px0F+UIhxPMAOYmesxzX2wScV6CgEWjYpoliJXV2xkSnySajFAPUz6dXHJo4wgq471jXmU2FT8D5uDxeXi0FNYSG84gFtq1eSjpB7CE373+q9V9Lo9kI6
 7z5p6fEw
 775r8YvfFc/iVBPh2ZK8oKcBBhjtlsJRX0BhWVNkJEtfBVX2lDoNUV4eC1KXXvdFDhTHXih8FSZwLWtT4zONnWaSNrhzeCiFxLaLB5+CaCGuSD8W+Ic0R9xOaSNYyxFBpqfp0fTXVncdrTr/jLc4aOcHAjwsAiXFwZR0WE7mIxraXGbQaq6SQrTk5uU57nXmenxDoZi97q4cVvZMGxIOzqxCJwuIkqjdKSyaVbc3gNdfYi3UR+HEDpS82179rRAs+Zhk3WJj4QaE71OqZvjuIsYktNI9ZJBHW7CaHxDJsp8pUJ0/HlWEfVM0AGcXL2sIX5fXQlMVDalzFM+h0O7RHeh7PBkCCP4B+ToUeuEWUZnZgn0YlDP/sX1XewAkbFNiqBlmPI5tNExtelIFcyjFQJGadaMCoO64F4JDxT7YP4hJjZgDWqoaRmfxMlY8EfaLgCuZFqinSZ05nfxi9XuDp/tnC31h28giKMJK6cRzPTwSRgPh4izzggu0ZMvs2pbAPey0ZS/Ywgf3mHvWGseHh4wFgoX9oLSn0Yx1LS0X2Fi9/fS03RvTNC15ntiXZnHKiL/8Zq2cfq+CzO8FViMXVRcOlggHj5CvP2zNZ8qBQpOaThahyYYzVoW/nfSgYGzYQHPJG2i9gbiGCPCUCVEj8ovsend23C4W8mebV7PjXr6G2NuM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2/6/26 11:27, Darrick J. Wong wrote:
> On Fri, Feb 06, 2026 at 11:06:03AM +0530, Nirjhar Roy (IBM) wrote:
>> On Thu, 2026-02-05 at 08:36 -0800, Darrick J. Wong wrote:
>>> On Thu, Feb 05, 2026 at 12:06:19PM +0530, Nirjhar Roy (IBM) wrote:
>>>> On Fri, 2026-01-16 at 15:38 +0530, Kundan Kumar wrote:
>>>>> Add per-inode structures to track predicted AGs of dirty folios using
>>>>> an xarray and bitmap. This enables efficient identification of AGs
>>>>> involved in writeback.
>>>>>
>>>>> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
>>>>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>>>>> ---
>>>>>   fs/xfs/xfs_icache.c | 27 +++++++++++++++++++++++++++
>>>>>   fs/xfs/xfs_inode.h  |  5 +++++
>>>>>   2 files changed, 32 insertions(+)
>>>>>
>>>>> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
>>>>> index e44040206851..f97aa6d66271 100644
>>>>> --- a/fs/xfs/xfs_icache.c
>>>>> +++ b/fs/xfs/xfs_icache.c
>>>>> @@ -80,6 +80,25 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
>>>>>   	return XFS_PERAG_BLOCKGC_MARK;
>>>>>   }
>>>>>   
>>>>> +static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
>>>> Similar comment as before:
>>>> static int
>>>> xfs_inode_init...()
>>>>> +{
>>>>> +	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
>>>>> +	unsigned int nlongs;
>>>>> +
>>>>> +	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
>>>> Nit: The name of the functions suggests that it is initializing the tracking bitmap which it does -
>>>> however, the above line does slightly different thing? Maybe move the xarray init outside the bitmap
>>>> init function?
>>> Or just call it something else?  xfs_inode_init_perag_wb?
>>>
>>>>> +	ip->i_ag_dirty_bitmap = NULL;
>>>>> +	ip->i_ag_dirty_bits = bits;
>>>>> +
>>>>> +	if (!bits)
>>>> Umm, !bits means agcount is 0. Shouldn't we ASSERT that bits >= 2? Or am I missing something?
>>> Technically you can have 1 AG, but you definitely can't mount a zero AG
>>> filesystem.
>> Okay, but:
>> /home/ubuntu$ mkfs.xfs -f  -d agcount=1 /dev/loop0
>> Filesystem must have at least 2 superblocks for redundancy!
>> Usage: mkfs.xfs
>> Or maybe this restriction is just at the userspace tool level?
> Yeah.  If the only super dies then the filesystem is completely
> unrecoverable, which is why you have to really fight mkfs to spit out
> single-AG filesystems.

Okay. But I think there are certain places in the kernel code where 1 AG 
is treated as an -EINVAL. For instance [1]

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/xfs/xfs_fsops.c#n140

--NR

>
> --D
>
>>>>> +		return 0;
>>>>> +
>>>>> +	nlongs = BITS_TO_LONGS(bits);
>>>>> +	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long),
>>>>> +					GFP_NOFS);
>>>>> +
>>>>> +	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
>>>>> +}
>>>>> +
>>>>>   /*
>>>>>    * Allocate and initialise an xfs_inode.
>>>>>    */
>>>>> @@ -131,6 +150,8 @@ xfs_inode_alloc(
>>>>>   	ip->i_next_unlinked = NULLAGINO;
>>>>>   	ip->i_prev_unlinked = 0;
>>>>>   
>>>>> +	xfs_inode_init_ag_bitmap(ip);
>>>> xfs_inode_init_ag_bitmap() returns int - error handling for -ENOMEM?
>>>>> +
>>>>>   	return ip;
>>>>>   }
>>>>>   
>>>>> @@ -194,6 +215,12 @@ xfs_inode_free(
>>>>>   	ip->i_ino = 0;
>>>>>   	spin_unlock(&ip->i_flags_lock);
>>>>>   
>>>>> +	/* free xarray contents (values are immediate packed ints) */
>>>>> +	xa_destroy(&ip->i_ag_pmap);
>>>> Nit:Maybe have a small wrapper for freeing it the prediction map? No hard preferences though.
>>>>> +	kfree(ip->i_ag_dirty_bitmap);
>>>>> +	ip->i_ag_dirty_bitmap = NULL;
>>>> Nit: Usually while freeing the pointers I prefer:
>>>> t = ip->i_ag_dirty_bitmap;
>>>> ip->i_ag_dirty_bitmap = NULL;
>>>> kfree(t);
>>>> In this way, the pointer(i_ag_dirty_bitmap in this case) that I am freeing never points to an
>>>> already freed address.
>>>>
>>>>> +	ip->i_ag_dirty_bits = 0;
>>>>> +
>>>>>   	__xfs_inode_free(ip);
>>>>>   }
>>>>>   
>>>>> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
>>>>> index bd6d33557194..dee449168605 100644
>>>>> --- a/fs/xfs/xfs_inode.h
>>>>> +++ b/fs/xfs/xfs_inode.h
>>>>> @@ -99,6 +99,11 @@ typedef struct xfs_inode {
>>>>>   	spinlock_t		i_ioend_lock;
>>>>>   	struct work_struct	i_ioend_work;
>>>>>   	struct list_head	i_ioend_list;
>>>>> +
>>>>> +	/* AG prediction map: pgoff_t -> packed u32 */
>>>>> +	struct xarray           i_ag_pmap;
>>>>> +	unsigned long           *i_ag_dirty_bitmap;
>>>>> +	unsigned int            i_ag_dirty_bits;
>>>> Not sure but, I mostly see the typedefed versions of data types being used like uint32 etc. Darrick,
>>>> hch, are the above fine?
>>> Yes, please don't mix types.  Pick one type and stick with it.
>>>
>>> (and yes I wish we could struct bitmap_t(unsigned long))
>>>
>>> --D
>>>
>>>> --NR
>>>>>   } xfs_inode_t;
>>>>>   
>>>>>   static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore


