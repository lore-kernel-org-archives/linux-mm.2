Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1B3CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512276B0088; Mon, 28 Sep 2026 05:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3196B008C; Mon, 28 Sep 2026 05:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6436B0092; Mon, 28 Sep 2026 05:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 11C116B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:51:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 898A8C014C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:51:29 +0000 (UTC)
X-FDA: 85262703498.26.D4CFBF9
Received: from mail-dy2-f14.google.com (mail-dy2-f14.google.com [74.125.229.14])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0C7F440002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:51:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Qn1aqRfg;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.229.14 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790589087;
	b=KjNA/hc1ejctbyGcHXdWHU8D25H/QIC2WLBBlQZ5bHXwM0W3LxM8c/58EsljmU8GuJSRJx
	VafcTnW91k2fsi1rHIyhmUrd6ZkSCw6+SKfb/V1d+oMFGeK++brtXT8OEd2klJRknALSm4
	vWB/khJzKsLxz+1xcvTmnTKimDVBlMI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Qn1aqRfg;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.229.14 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790589087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1HXVH+r86enel9+rQTBOES9ysvhe0ZUHDob7OwbV1g=;
	b=3jdMIRUG4BcWfKp/Zehi/GCgIU4aayb2pLLU2mcXbD6zH1lgdLMyMmszQT8ZVbCqJiDRt8
	rvPd0WEM/0ezQM31TtV0YXG3cx7JY3F1wuzwUEQvBQc51nRqAlRvlPxX79iL2/TaZ6Cb3i
	BoiCjXnTxHQ41CQgzgMgxLy5Hwvgwlw=
Received: by mail-dy2-f14.google.com with SMTP id 5a478bee46e88-328664b7528so2688695eec.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790589085; x=1791193885; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=u1HXVH+r86enel9+rQTBOES9ysvhe0ZUHDob7OwbV1g=;
        b=Qn1aqRfgzJT8tzpTfQ05hhs60taJM5g2Ki6v3sLfAsNyqqb0rRf1KfJXhEOQdVrLb0
         i1RD8hvhiXGphEJ/qe4Jgo3BGRQESfj3/UjzGpV2PlYKMrNUfhcyRxd+U98pBgX6a5bR
         FiV15/ynIaY4NE9kvYqP15nL0txBx/HoIeSh15IFVj8GcS9RT82QG5GjZLaq4WtXVKLH
         KpBQ4igdX/jLaCKuUInijFQNa6keMOP3aGK2CTQcdQ4m07uU0OnRDP9P8BEJmZxiRzOe
         R1d1txFHQYdafl3Z5oHLvcBEgkVPd9TsgxbVuEKH/8pQBHSv5I3DsBxTZ6rd90jvu5Hf
         7Epw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790589085; x=1791193885;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u1HXVH+r86enel9+rQTBOES9ysvhe0ZUHDob7OwbV1g=;
        b=jfvrYd9dFNORScXrFqLiEGsTCPlfCpz7sPEws3h5xj6fwDx9J22yVkvFC0Au7XoDYr
         3DMSVSp/FAZgLMENBmwj5gPy2VojZX/7wRPmDfEuOsHXDColc4HTDBbrFE0J7/kAF1cA
         Cd+flpnFrnoMhiq23mn18kq0sKkcIR9/qNNZ5lSFOy9SYrIHLeDGwFo8651c6DWxMkPk
         D7twOgbrabFvCZgh5xLrT1NBaBIUGkoXfsmtHbEv1LiniasA/j1XmjloEPoY9ekr+SAz
         9SjxUY/M+lbb03ub643J3kdcg8Pa5atywcRROvSIsuS7rwzuja8z21QP9JiMMMgOAUqR
         J4Mg==
X-Forwarded-Encrypted: i=1; AKwUvBzpg6pVP0Ruc7S65B7c6GK3b1y4MuEuKPuEnO7qzR7o+HA2a7avZE0/4lvcK/mBfv5cNwwPpcqAxQ==@kvack.org
X-Gm-Message-State: AFq9FYK1jBOuV4DYfBBkaVMMU6qXKiIA3mF5f9Yt9WS9CFLomkcBZa1e
	8u42FfGtXuCVi4JrKSCEBFAcmgNoVt5ZELZbMao3cYEGMqisGWOWq2AeJsGeZ1I41ls=
X-Gm-Gg: AYBFou1XdVY1JdpUp3dlmsTmTCSKjtGrqjmkYZWfn5ugL8KbVCw8wiv8OS70qhRaZvf
	61GCM6w6bZQ7R5yVu5bUuKkqmZ5MENF6COXz/sbyIHGFYwZzAiAiwUjojpgt/p9SaDxb2y4XTTJ
	at7cBimF9mZDMy44jBKZjyoiX4vdKF10PR267gHABLeat/EDEN4B/lsvpDfOvB5ZRmJh7KuypTn
	p57IE1RJmQKqo3YNSbbayMFlFTFNssBHL86LKRVSI/OaWF2zJQRbXy/15thMqHgRGffGweQyrpk
	NjC0AqFImqKXWIeTaOGW1I35+4rt5IJYO8NVHWxT7DO3kGySS5bQa0NOIV43ij/nPs7vePGHFnV
	3jIQAhGM4cfL3caxLTObsVSXWNe9D5ANWXqqZMxEGkISvUDmD0Q7ORrPIzFBCcwtqF4HJlSlvz9
	kjZyRTfva0tuh8vEeih+hsUkg/lrkXeBnKGhMxaOTAf1s1iby3WlWwdmZxNRnwlkkfrYz95sxu1
	Xp0s4sZz1S/STQaSHYf
X-Received: by 2002:a05:7300:8189:b0:342:e7a0:2829 with SMTP id 5a478bee46e88-342e7a0534dmr11613300eec.26.1790589085183;
        Mon, 28 Sep 2026 02:51:25 -0700 (PDT)
Received: from [10.255.210.72] ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-341f2b18cbfsm25480102eec.30.2026.09.28.02.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 02:51:24 -0700 (PDT)
Message-ID: <9e9c02fe-e94d-4f70-a21b-47b46bab2c3b@bytedance.com>
Date: Mon, 28 Sep 2026 17:51:09 +0800
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
X-Rspamd-Server: rspam06
X-Stat-Signature: zxzdpk771itgnnroi69eu1yanqbec8e8
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C7F440002
X-HE-Tag: 1790589086-975877
X-HE-Meta: U2FsdGVkX1+FdCfVSJ6Vk0gZ52UAqGc+JGJBQd7aq0V+X9eDzGf8jMfbWlT9heChj+vo7tCEdy5CoK17PCIENeRTG0/1fR6fOkt9EgiuEri4akLfRlvZtij8ci5P7qY1pmaAZpLBXydmQrXmpXZivwtGUnSxhwTZjuQ7xPeJQRddVeqg7TvhFjGOxQwZ7Y5egfxqT4XYCe9qzKdNn0OJtmirmvrrJhbzfzFq91ejRTLNmaggJiYegUF/4Z2BNKsqLbowJXkvIUofP9SvTpuBSuLawaGmaqXZUH/EWNfgrzQvElOlmf8i4AB2Nl8Dvwzlp1f2eqk7QgKqqvjuiReTryRTHbVdnamrMIZMSeueiU/79nybbwMV1R/x23psbST7dl97w9lPgi2IkdixfILjwNG2cuCczE2SdF1pD3hhIZt/UraQyUc5+AtmDRnZULgDC6rY33qjFbwThbnFCTCbf0/rlzyKwwtPJKjGGfPafnIjWJ4FJVXLUHYZzvB3vBZCdqOhIMhtPWhKyHvUUUuDCJs9S3U9U9N5LC/7p2zMopJkeQnYd5SlOKygw9R3JKHOPVD2orrlllSqhYcKrlHpObovUIXIU7n19nPI4P1y0wRFo+8xURL/gT33pwwyEBLxSggBafFj0WMx2rWzvojVVaxXAuLzr1t6jFqoCjxsHcpRDF5X8WKDi9PxetdC7Y0EActRxBMHFdzjdZoiFUS4H47CfJLusUnM81pJyVrRFDhuhLJv3aZymLDnBwunTGPXsaLS1lHJ6pre/Ku3EsOs7+TD27tKohMIsqLdwgxTFSXWVIkPltkR8L8RtRDsf19boSK1aF+urKtvvViwko1A9QTC7AYxzVz7lCqlw2u1PXby82Er8w4WZfUBO7VvVpeoPMkJyPt1eoiRcvIfZq3umy2bzJN/DoE+lvqFJAyFGOaGKPdphzl71KNMVC2XiZoakP4tcxq5yIm+zsr2VFU
 ye4Njwqy
 k+BFQ1lyBNLIY1KfyUfSpuFqWS9BH7epNOARtC0yUBWUa47/pbkgQiSP8xSri0MJMURoxQH1CvCo0+M/6BkyTgX9I2IQFH7qVKS6jCUoCrv9L662+9QWnHx96K0ZFYLvEC1cSMdl1mK0155sMGVTsC7VsM86JZQJfvUC7kPQ9wVYyNISC2PLVY21ADHSn0TpMfltv9ABfRINnkH4BTMI8L7FDAz8QFkLkhg/GtahZwBzNvp7Mt/+2b3LC9Q9Uyyjf9sfhrPPtv+ozdIN7gts11gO4ThIfImlJluRYKeFfDfBIBLWxNB9uJgBPFcihMD3KyQws9aFYp+wra5+uPFiLlTfWXZ0Nd2QzMTvce1Duw6dtO8+1NZIidhBnBA8C9ZjNicgXBueJQuruELASXTqX4ymkyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 2:24 PM, Christoph Hellwig wrote:

Hi, Christoph.

Thanks for your review and suggestions.

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
> 
> But the more I look at this I wonder why we even bother.  Trying to
> attribute individual bits of dirty metadata to cgroups is pretty much
> insane.  Why don't we bypass memcg accounting for buffer_heads like we
> always did for the XFS buffer cache, and what btrfs switched to last
> year? See commit b55102826d7d ("btrfs: set AS_KERNEL_FILE on the
> btree_inode") for the btrfs side.

That sounds reasonable. However, IMHO, the main difference is that ext4
stores this metadata in the bdev page cache rather than a separate metadata
cache as btrfs and XFS do. The same bdev->bd_mapping is also used for buffered
reads of the raw block device from userspace. Setting AS_KERNEL_FILE on that
mapping would therefore also charge newly allocated page-cache folios from
those reads to the root memcg rather than the reader's memcg, bypassing its
memory limits.

If we pass a flag from ext4's metadata buffer-cache allocation sites and
check it in grow_buffers() to charge new folios to the root memcg, accounting
them as kernel-file pages would still require persistent per-folio state.
When a folio is removed from the page cache, the allocation context is gone,
so we cannot tell whether it was counted as a kernel-file folio.

Separating ext4's metadata cache from the bdev page cache would address this,
but that seems like a much larger, longer-term change.


Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

