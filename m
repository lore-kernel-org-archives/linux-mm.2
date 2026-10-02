Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB648CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 940276B0092; Fri,  2 Oct 2026 05:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918306B0095; Fri,  2 Oct 2026 05:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8076C6B0096; Fri,  2 Oct 2026 05:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51E426B0092
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:24:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4FCB406A2
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:24:14 +0000 (UTC)
X-FDA: 85277150028.01.056A60C
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6ABA520008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:24:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=i8IT4uY1;
	spf=pass (imf03.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790933053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4aOyrFzh7gdGZ8/kq9sOV0yCHBHbrdKcYYOkMYs0fA=;
	b=BxzUe4C2aXnFoPepY5XryNQr3oie86j0VVXlsshK5ryvpD2bIjmD7P17+MhYH6jJCZnToi
	suyr1AnvxfcDzY/26NJ8rQQExBp4VPYUx/Agd/KN21g9D/A6S62VIGAaa6r1wkDofML3A/
	KUhSdS2lAETmU1lFsVdGnzVYjn4atqo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790933053;
	b=FsI6Nsuq7tvj8MdwqaUgkcIElHGeUeD6ybc3HxjBLw/BDOZ2Cm+GH9+tbfWqXRTu2FXEgf
	fqtvZx0AR/6jnexsBza751Y3d9ln1W33vPPlvhCqTfMPIzKxRewyCYp4hfNtIgnX5Wi5AK
	m3iQh56RdhUxKk/7jQ+cNM78NGyXExA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=i8IT4uY1;
	spf=pass (imf03.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pz2-f42.google.com with SMTP id d2e1a72fcca58-86e6d007703so3685811b3a.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 02:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790933048; x=1791537848; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=e4aOyrFzh7gdGZ8/kq9sOV0yCHBHbrdKcYYOkMYs0fA=;
        b=i8IT4uY1rwA6Yli2dyDy0EHAbECBlf052YO733MoMZbyTKaIbBdzbl3Pc2+YqbyZ2e
         bPfWdgjvmiMQP5KU291nMSrL6qf8N+rqu/vc9z5zIjya+76fB9dNKdo37pBbe9E2dZSq
         RDIhd/0efQLC8St+Sj9QZ0QDAzbVJcZIREw8Doje8f/KgFKPrGQShZ+7XcZiL7IBlny4
         M+4LunhBvDFoIfbKRWO1gxXnnkG8lTOQZmTuQs9vqfJSxQpljkhwkDiqXgZei8ZQDloT
         PaPxmmQA3r7ycbJD6EBMewawMD6XGZk6dZeAp66OllT+toeuCyNu5DJcAt1u0NrvJV6t
         Y6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790933048; x=1791537848;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e4aOyrFzh7gdGZ8/kq9sOV0yCHBHbrdKcYYOkMYs0fA=;
        b=P2kqRYQZr/mx/k9SXkuqvb39DiRDbDwBL5KnEFWLhiWUc03SmPLd8+O0WSGPdaR/MX
         KEKpt1dJ2+7F5RbDzkgfinalE9ijN8X8OJ+P8p8FOLb1DhkML7tNSQZfTIroaOkK17DX
         0i2DfLs/xoZQBftP6iwACnEojXF3vsfqolnUKuo6xbUN34JDNuWEAJ1ytiaiBn+eAnvs
         gYKISX7wh6QFIoyDzlmOIphj3if2jBq2P4DoHDO7u8AW20iJZSRbwkfF4oU+fYxmpPr7
         LXDmS37AyJufB2TjarrGDbHCTOzDADtPAwJ1kaDbniYKWx7ks9GzG4qmUS8f6cTXuLIQ
         JnCA==
X-Forwarded-Encrypted: i=1; AKwUvBwgR0wg9sXI+MS6n1oJZHTr4ym39YYkoon2vVtwpqdFqnM/znU8lqtZroAshXX3AMYISYl8sU7nKw==@kvack.org
X-Gm-Message-State: AFuF++m65jwufdvOfXogKMeT99ygUhC8DVEXLsqTYhIbMDpStAd0jZy3
	UzVLJ8JBePkV8s6tUKsMbNMiqYTfep70hlPgLWgQvy+H3oxl6X92ytBq4bUKG1j6P6k=
X-Gm-Gg: AYBFou04r7wUrh48Kl/yaPnxNgE+beQiR5deZqqRg8rcj+IJWwBmgMdADPvrMuBqqpX
	O+vyi8nsQHf0YdZwHzpnOsYKYm8DkzjAAYNsYza7XmLyaMC3ufjvLKLWwrH6wvzYzqs9/33E8aW
	0NYPjKMGNeVROq34zwiqha6xxt4sC/E66EP92tVbwZjskDixnlVHvAPpg1MMVe+MZitH9ybQfTC
	nQJld/3+qZ2rB9+WeTwNW2x6PBG0GRsytTPjKzz5zdCKJaj2ojc7sB0dD1TzC7G6TiobccB+GKn
	N8G3Vjl6T0pc6PlzEIKSCyqMBVg8TV+0/NoQMwDQuZg7dwi9OZzWrYWDaml/11ShurS+cOxr0xN
	xk5zqCo1xmFjwcuJtS5JszNokDxglwwZZsgLBFW8doGvXryyqsRpeALcSmTtmxlFbi5gfEqn61t
	3dMVLBTZvXD5fUDrjc78djvFyaBybpievPFYyWzG7WQCd0u9SHfC9e9fqUmSPKmIvvvhceyLR1W
	5YvBfv0lLt3zOdLOSHB
X-Received: by 2002:a05:6a00:428b:b0:878:3538:8f7f with SMTP id d2e1a72fcca58-88af6658113mr1963422b3a.45.1790933048460;
        Fri, 02 Oct 2026 02:24:08 -0700 (PDT)
Received: from [10.254.198.23] ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88b0c78c7bfsm659640b3a.36.2026.10.02.02.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2026 02:24:07 -0700 (PDT)
Message-ID: <903dd25b-7af3-44cc-9425-9499f50d5750@bytedance.com>
Date: Fri, 2 Oct 2026 17:23:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
To: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
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
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <aroIAqoCNDBPlB2A@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6ABA520008
X-Stat-Signature: 7uornrioc8hker13n3geczdb7dj61ea4
X-HE-Tag: 1790933051-265584
X-HE-Meta: U2FsdGVkX1+vJ2UdP20RTIRtHz5W+RWW8Fxz8HnVFZRPS77q1ijjzka25qxD9+plEZisuMelgEx+Zes/DqmfFZ0Iv75e3Wc7WxAvsSdCYU2ruEthy5s4o3/Qn3LZka4gRqHjjCCGvhioQY5VSlxvTpS2MzVe2U4+72KGJT6c5HufESMdRbb6hN+d5X0jY+Ir8pwbNSJCSe+KjwboGbmhbXO/JGTPQC385sTDo4LSYNWSnk470IwOD+givSRNUvWWFojDdO2RmypaM5MNGDT+msfQwgJRNKylTpQQnh2oLgrKoZgZIDUQOCkSejxWPpQ6xs6sdmKXJ8Bxu+AEf8TC2g95mFgWC/SsbgKWv3bhZRsPBmI38r386H1rKEcFaxvR4EapTTLzX3JpEPwPkM0cK+IMQJWEAiB+HoAlG//NCAjDytqRIVUdPifENpZSmod7IZmJP6a3G4WyIRiGRvAKt8V7nwuYnWk81Tao8vfqcv7Drj8TO2dtbx31F4G4hQiK0GVhkOS/ixOFgnX1N46T1vRTwjxIxgNVZgXJaz9CvxS8kaq8YLMIUfQ/hA9vF3uI7hnz6PEBpHIEWiXqWw9ixCd66Za2HwYpvZTYUt1FmoBscPzfrgj3yGW9ivEYBYhpEfzAdyOulCC97oTbDjJ+wgu8OjA8u8BVr1pR4qHaGv0EnUS+r9mW0gAlKvPARfecjsBw9Jtmhys/bw6vTYpxb++dKgzB0e0OJ+nfSAUNb2k0OBJ6m2PVk8CneFJrBiIccX/ygXgIGchYIYfQpzskF9cbkD+JeVuPDZg4Z4gtIB9HLFm5Gac5Ziz8O5pK+R+8ostvjRjKuFLjp7Y+7BMRKxuDtoSsSBh4iz44LTmprZNzuco/ZrDvQIq17jeEayndMJTNDg9N9WlRdaTNiUo2xmgEreeNtcLtDwbbmY7AID438MOS56SmHjo7Kg2e0IHjwz3uwgx3mrjSQ7QPi5t
 o8HylDzM
 CDI+7cgOfu7g6j/yoQHhTMas6gQbDe3YwsT66xtfhi4gl4xVZl4tnsqoOZ0gn2mo/I5Ul/5dzxnQGrZqvPgDOPNQ5N7vE4ZZsiVdBLy5XHwSN6MGldsnwU6huRgnVdjtT/a9nVYSd0SF98sAhnYJHaYT0QoyDQsvaM+gtq+3xgwuvi10hR4l5ov5DPvewnK5U0oL0nqBJT4pwzB363E4CK0F/Pd6wvYe4rimyuCCBQ8pmvcbJwbdrOh/wCP6rwXn4LMXOvhxiA+CWTwhHhbtlF4j/q49y0nFU7upNlxB821pM5jzvHmzJhXI7fnBVcO1LgqlewdgLCLoVHoDGO08nBqs9+3BZPWddgvIK8DjlavroynfcBi9CneLrhk7GtwgOR4JqqE+itCAvmuyznhN+zc3BOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 2:24 PM, Christoph Hellwig wrote:
> On Fri, Sep 25, 2026 at 12:34:52PM +0200, Jan Kara wrote:
>> On Thu 24-09-26 23:52:33, Christoph Hellwig wrote:
>>> On Fri, Sep 25, 2026 at 02:44:42PM +0800, Julian Sun wrote:
>>>> Add bdev_flush_by_dev() to submit page-cache writeback for a device
>>>> identified by dev_t without requiring callers to hold a persistent
>>>> device reference.
>>>
>>> This isn't really a flush is it?  This is writeback.
>>
>> So bdev_writeback_by_dev()? Fine by me.
> 
> Yes.
> 
>> Well, Julian is explaining that in the cover letter. We don't want memcgs
>> to hold bdev references just for foreign flush tracking. There's no easy
>> way to get rid of them so they could pin bdevs for a long time leading to
>> strange artifacts.
> 
> I have to admit I didn't get it when flying over the cover letter.
> But this also really belongs into the patch where it is more obvious,
> or even better into code comments.
> 
>>
>> As you write, we could just hold a reference to the bdev inode. Those get
>> unhashed when the device dies (__del_gendisk()) so memcgs would be just
>> wasting some memory by holding these inodes alive. But still, transitioning
>> from inode to proper bdev reference verifying bdev is still alive will add
>> a bit of hairy code (essentially what blkdev_get_no_open() does plus
>> verification inode is still hashed). Plus when replacing foreign flush
>> entries you're under irqsafe xa_lock so doing iput() from there is kind of
>> a nogo.
>>
>> So I think tracking devices by dev_t is a good way of dealing with these
>> problems. But then when flushing you have to transition from dev_t to
>> struct block_device and blkdev_get_no_open() is the canonical way of doing
>> that (and note this use is just internal to block/bdev.c).
> 
> I'd really prefer not to grow more blkdev_get_no_open users.

Hi Christoph,

Could you elaborate on your concern about adding another
blkdev_get_no_open() user here? Is it specific to this helper, or to
submitting writeback with a temporary bdev reference without opening
the device?

We only retain an identifier while tracking, and acquire a reference
when performing writeback. Looking up the device through another path
would still require handling the same lifetime constraints. Is there
any cleanup or rework we could do first to address your concerns?

> 
> But the more I look at this I wonder why we even bother.  Trying to
> attribute individual bits of dirty metadata to cgroups is pretty much
> insane.  Why don't we bypass memcg accounting for buffer_heads like we
> always did for the XFS buffer cache, and what btrfs switched to last
> year? See commit b55102826d7d ("btrfs: set AS_KERNEL_FILE on the
> btree_inode") for the btrfs side.

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

