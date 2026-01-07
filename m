Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F545CF6BE3
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 01:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3C066B0092; Tue,  6 Jan 2026 20:12:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9DD6B0093; Tue,  6 Jan 2026 20:12:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CA976B0095; Tue,  6 Jan 2026 20:12:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B77C6B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:12:19 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D669BE988
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:12:19 +0000 (UTC)
X-FDA: 84303391998.19.3B7BAD1
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 03726140008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:12:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="DfFSxG/0";
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767748337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+i3gGFDzaYHfwvORnJ8f6KFDJoSc7Htgc7Z9TbE2xJs=;
	b=s5I6bnAU3CcBVXHuU9/EnlivXx11vILgZEk7aW0aHYTr8L9iWDaqrw5hUfWak8GCRR/l+V
	JCksQzxMvvVAIrbZOCM+c75L3yvf3PerkiAJTRhPeZPYraqqbL1OpN5buMNPUqRbT74x3n
	KBSSGqLbPZGMeGSIGt0+XJwrHPKrbqE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="DfFSxG/0";
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767748337; a=rsa-sha256;
	cv=none;
	b=egLhpzQY4Jt9HtHAYkwOitAQXDjr2PfvbhJ9qFOTLl78QzxhpmRk4o6iL/jOc/a8hJ6tpV
	tin19ssmzlrcjmpKePSej+Z/F11wKSHElutMNdF8lICDaEtVUdNq2eq4zR0vfzTPrc7eCu
	2JJswNMYaSNgy9xVAF9gXH/pWz5DpHg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767748333; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+i3gGFDzaYHfwvORnJ8f6KFDJoSc7Htgc7Z9TbE2xJs=;
	b=DfFSxG/0o/p43Obu1PgEVhTzbRkHVsp8vczq4Mk3mYfL9Ov6otXk8ux/0zf7l0tcJr/SeaCQEGI2svJ8G9OfvvqtNuKNfDg4Vtwm3igjV9xpoao7QE3VrhkcSnHNrnkgUxPNJhtOksgURbd/+QgQg0EDj9Qe+PYh6h5MvSqH1sw=
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WwWzou9_1767748331 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 07 Jan 2026 09:12:11 +0800
Message-ID: <6da7b976-2f95-4fa3-be1c-0a2b7ac29277@linux.alibaba.com>
Date: Wed, 7 Jan 2026 09:12:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: fix uninitialized folio in shmem_symlink
To: Brian Foster <bfoster@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hugh Dickins <hughd@google.com>,
 syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
References: <20251224094027.65842-1-21cnbao@gmail.com>
 <aUwcV2HhtdiXXxfJ@casper.infradead.org>
 <CAGsJ_4whKLWiw6LNexFPHTFWB1QbSrAwrBtspuc=c8fM2=WnvQ@mail.gmail.com>
 <bdb7f7c6-ecf5-4da1-a11a-cc19c77fe4f2@linux.alibaba.com>
 <aVvDcEB583Yuolm_@bfoster>
 <2b12f63b-ceab-4d3e-a06f-f41e6b1b2d23@linux.alibaba.com>
 <aV0wqdi3L67LQrcF@bfoster>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aV0wqdi3L67LQrcF@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bob84x5rugnxae9ge8d9xriipfzr5zcn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 03726140008
X-HE-Tag: 1767748335-717269
X-HE-Meta: U2FsdGVkX1/YyQyc1/qp34L0GY2MGw7K5umUAqWcqHkQzxjr4PHS6GxSBkS+231Or9o75JcnBRqAFTWeU1zgHjBs+hCwcgCUd7cmnA7n/Q++sSU6zKD15yXcrueaqhG1K3e3pD9B/wo1spka6DrmOk8pMOLQwphgJfxVSLJ1KFyBKGEdmwz6LYGuPOV7KAo2Sg84K56qH1XRy4wsu2MZ8GbTPmwO7Vob7hKxN+cO512jxPT3YLzLrkpWVhwi9TRTbvhPOKH7yvtWcnJNo86qlQ2KWqKbijcl/qDqxaG08TP2g3AIT/FEvbwYh13wo6RUdM8kA3Y8+oDQBM6FPuIFFefcS6LDHZkE/jMktDhOqYYnDnsdjnCap6AGY2Tk5ammw/tMhP0gCGkE+cna8+onTFaCDJNJ+wADNTRkZfWX/UJM098q4ZS+6UZ8df0MJWrLvaOJDx995x5O2Avt+H8KSCtGLX90Y+B82kTNEYCB/IS2L8sZ0vKj6ynAWjpldvecRiOFS3H7VCNNSQwNLKMeLGv9yPIrgzyqNd5LhX3HeZcR3fEp1qC9W5EaWwQykOOwnKETCxx8qK0VFdGxNuaAzrGrIVV3HBCeNiHyhrSQSbJ1J5ytBxLvHoXyZj81Ar2xR6FaVB8QPbsfJdRuHlUSdw3YBmcIqsDuD8kWrtIO1So5fGrOwcfhLTpu+4M/u6s/3JBix4Bx1vs48PxYzGvg19C9t7/T8N2YEUa46I694hynKXhYilsm5mRnTEIah5dBzJNCG89NgQjUdDnqhJzD7PGg105+D+YGdpeCx52Nfx7Fq69FMK9rr6JwjBE702IdjZRzWeDbJji6pS2oLo3v7OnEBTOi18VGxNes29IEwB1+sTHh0A160PLYna3KBCnQwO42lCb7yiY9FYFw/vvpS9HFRLqbMfLgts2XyvPKpSLAfZZX/rx7wtic1g7o5hP8Sv6AjBh72xAfy1AOgsq
 AiAvJZb0
 ojwx1bfBlpuAXT3xS+xer+cNPnMhMklJhSR2Blhk5LUxOje2RwHMVft5moIrjUucifOxKDqqaVZxpQW7ML3LhszoQn/9NraUasXJTTcd8gRojH5NA9hfYWs8EbDHYaqpVG9PlCFAuhxBSVcsgPt9HH84CFwpyu9lmRevS/tdijHOq9FfAQzsQThNtbGjfw9yyqDexJUcSkZi/yodAxgUWUj0MKX+35D4Fo4fSDXIyUiia3xI05i6oO/Ai7R0FVl4x2hFGdKGflwuqLZxiNZWh3LY43lTVHkvR9XBaTYT9W/lbbis/Imxu2XsFWjsN1Chd17XZUMdUWi0pxdF37GffvJLFOfp8nQ2B/l5oMV/6IWc0l6RThTgqCPcSpX8LBn2qe+0ag5dfTjVJEBYTsOaBnIA6rcA/7LmD01EcL+b03afDX0NRy/0mKzYW58YrGxt8ZycqX65ooJ6r7cq6MLWtqMU7ZCfMghVeW9g1H2IYt9XzRmMEdcEc4APWAJtWFV1Hg9LlUiwQ8OP+rrA9ko2sYccwbgyoZ5gBgBo02GRGhNYibcgmnNhWHLMyQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/6/26 11:56 PM, Brian Foster wrote:
> On Tue, Jan 06, 2026 at 11:47:44AM +0800, Baolin Wang wrote:
>>
>>
>> On 1/5/26 9:58 PM, Brian Foster wrote:
>>> On Thu, Dec 25, 2025 at 06:08:08PM +0800, Baolin Wang wrote:
>>>>
>>>>
>>>> On 2025/12/25 12:04, Barry Song wrote:
>>>>> On Thu, Dec 25, 2025 at 6:01 AM Matthew Wilcox <willy@infradead.org> wrote:
>>>>>>
>>>>>> On Wed, Dec 24, 2025 at 10:40:27PM +1300, Barry Song wrote:
>>>>>>> From: Barry Song <baohua@kernel.org>
>>>>>>>
>>>>>>> Uninitialized folio allocated in shmem_symlink() may be accessed
>>>>>>> during swap-out, causing KMSAN BUG:
>>>>>>
>>>>>> This would be an unfortunate way to fix it.  The vast majority of
>>>>>> symlinks are short, and we'll never access past the \0 in normal
>>>>>> operation, so we'll be dirtying a lot of cachelines essentially to (1)
>>>>>> shut up an automated tool and (2) optimise a corner case.
>>>>>>
>>>>>> How about this instead which delays zeroing to swapout?
>>>>>
>>>>> Matthew, thank you very much for your review, even during Christmas.
>>>>> I would like to wish you a happy holiday!
>>>>>
>>>>> I am not quite sure, as shm symlinks do not seem very common. Since
>>>>> allocating a folio requires a symname longer than 128 bytes (where
>>>>> 128 == SHORT_SYMLINK_LEN), such cases appear even rarer.
>>>>>
>>>>> BTW, do we need to migrate the owner_2 flag in folio_migrate_flags()?
>>>>> If so, I am not quite sure it is worth changing the hotpath to
>>>>> accommodate this.
>>>>
>>>> +1. At least for me, using the 'PG_owner_2' flag alone to mark this uncommon
>>>> case doesn't seem quite worthwhile.
>>>>
>>>
>>> Also JFYI the post-eof swapout zeroing work (still pending) looks to me
>>> like it would cover the swapout time case [1]. That's just if you wanted
>>> to go that route here; creation time zeroing for the large symlink case
>>> seems reasonable enough to me as well.
>>
>> IMHO, your post-eof zeroing work is intended to zero !uptodate or beyond EOF
>> folios before swap-out, however, the symlink folio is uptodate and not
>> beyond the EOF. I am not sure if it will make your code more complicated
>> when you want to cover this symlink case.
>>
> 
> It already handles this particular case. The primary intent is to zero
> all post-eof ranges that can be written out before that write out
> happens. I.e., if you take a look at shmem_writeout(), if the folio
> happens to straddle i_size we zero from i_size to the end of the folio.

Ah, yes. I’ve rechecked your patch set, and you’re right.

>> Why I prefer Barry's fix: First, the symlink folio is marked Uptodate after
>> copying the symlink name, but the whole folio hasn’t been initialized, which
>> seems unreasonable to me. Second, as I said before, using the 'PG_owner_2'
>> flag to mark this uncommon case doesn’t seem worthwhile. Currently, IIUC the
>> 'PG_owner_2' is only used by btrfs; if we ever want to remove the
>> 'PG_owner_2', this uncommon symlink case shouldn’t block its removal.
>>
> 
> I think we're talking past eachother a bit here. ;) I'm pointing out
> that outstanding work already covers writeout time zeroing so as to
> avoid duplicate effort if this was trending that way. IOW, I think
> there's no reason to consider the page flag thing, it's more of a
> question of do you want the zeroing at creation time or not..

Yes. It is very strange that a folio is marked uptodate but is not fully 
initialized.

> I again don't have a strong opinion on this, but I think I can see
> justification either way. If the focus is a KMSAN splat at writeout
> time, then it makes some sense to address it in that slower/less likely
> path.
> 
> That said, if we step back and consider that if this were a buffered
> write we'd tail zero the folio at write time before marking it uptodate,
> this seems like more broadly consistent behavior with other fs' and
> operations. This would be analogous to say XFS allocating a zeroed
> metadata buffer on symlink creation to ensure the underlying block is
> tail zeroed before it is eventually written to disk.
> 
> So to your point, maybe the most appropriate thing to do is cover
> zeroing in both places..

Agree.

>> BTW, as I said before, I've reviewed and tested your post-eof work[1]. Maybe
>> you could resend the patch set so that Hugh can take a look when he has
>> time.
>>
> 
> Yeah.. I know Hugh is busy and that isn't the highest priority series.
> I'm just catching back up from time off myself so I can give it more
> time before I repost it or anything.

Sure.

