Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F46C55162
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 01:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EBB36B0088; Thu, 30 Jul 2026 21:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69C676B008A; Thu, 30 Jul 2026 21:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2236B008C; Thu, 30 Jul 2026 21:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FF796B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:46:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97B3F1C0912
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 01:46:42 +0000 (UTC)
X-FDA: 85047382644.25.0479422
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 49AE41C0007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 01:46:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V65hgF+X;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785462401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dO3PkdIRMlkezl62as+Q47Bf7B4brhEm4xLqBToECdg=;
	b=tjcYkAPLvPEI3B0YFg0T9Gkm2nMaJg4h6b2OOeFbnqM9VNxq+LvUxEw0EsQyQHtIaqShmU
	M1xYMrh+naB9Lle6LktHKYhqXKIwWjCAQjZF9SMBzI36GmDPi/M5Ctj93J6Zon/frY1phb
	bGwRHHD6JmYHKvz5ejJj4DSXdS0Vrt8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785462401;
	b=otoFU//ghigIgUYHJTcSSwZ8mE8AcA/r9GPejfRjuB5htWr4SwbaBt+8Twm1aCmCvbpU7i
	0RPTIrm3trpegOCcYDV6a/H4WO6UPnABRX7dKUqtPuo4NWTAMDawecr5+egNfkrzBavZJb
	+1PaTsWunG3liOXP40HqafwjxzQ/Keg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V65hgF+X;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d0fa85a4-53bd-4af9-b275-856ca073bc96@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785462395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dO3PkdIRMlkezl62as+Q47Bf7B4brhEm4xLqBToECdg=;
	b=V65hgF+XXbx2tPBla+Wuz8xT9Y54R7Zr/SDapDPrGfg0JMMAg+szspXIoIhsNQMdGmEuEy
	TyvjspXsx/f0HdoLsZZ5XwcwHi9XfjLXcxZ/fIXGgSVGSHKizWRaUTrmA7BnlLZoE7h76o
	45W2UH6GaTcN/VDi96TczreZcCScRuI=
Date: Fri, 31 Jul 2026 09:46:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm, memcg: fix memory.peak reset clobbering other fds'
 watermark
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Finkel <davidf@vimeo.com>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Tejun Heo
 <tj@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260730115314.1069089-1-ridong.chen@linux.dev>
 <amt140aXu5tYZxln@cmpxchg.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <amt140aXu5tYZxln@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49AE41C0007
X-Stat-Signature: apdrq8too9ub4xxuoph9bynsjw4986xq
X-HE-Tag: 1785462400-998769
X-HE-Meta: U2FsdGVkX1/iulyBhIsOSvevoDDdM/sokWzleL+JzEhzkJZZfTKPw5/RDWHaqS97e84G8J2ohKiTagJNQwYbQVVlzQLo5F4w6kNS5gIcaF3I+uIp/YbWBBOw9py1kDkzMqs+a4gan2hNaFou3KU6MV7++gxm0l6lwUp8m63csNBk4je2D/cSOg3STUXaEEA9OjyE65nh/OsBO8pyBkd14iEzBWsibnbZCg/8UZyPYNk0gZNLQAq2noUKC3GDsH/SBFtjJKaezJBd9chpNiSiZ3kpwi9ShN5QyrQ9VJ8KMDL/cLDu8Wkc3xEX2l+7fseWRZ++bWODSNHqso+UbHf7Ku2G+TVglcqUiRIAwsmh+BrSzuYG7mL29zBDXiGFr0rVhqWkSoi5UpsihYVA1OpZzexcJKS56/s6m8j7gZes/CnZ1ewKow4IsRjson7rx3AZC4qis8WzzWaw8kx4YD2ogXa99wbdQQg8uqLpPs5ksx4PE8YwCKAQx0yAruxq42e/4+gWBflBcrr6fjGgYw97BJA+YBpy2b5YjkW/nIs//f0RkizIiCh4F6R4rsCL/ZmZ6O7WjTQw1Q40zqzylXjkabU6CGGrwT05ZbQM2xm9hgg2beU+jU4whb+MY448KeVnM6SQ+0+BO/zQCV8y3fECK74eJKQ+6UGHc7QOJ0UIPWGT1CdlXMHkMNlvIAlJs2G5qCotpb/LFQWKpZuuhz1uvcdzhPF2cStvehcMQI/1XX+KFeR4L1xblDTWwP0WfcjmarxPM7+/Dh5F7QUvqbwS5l576aS9Gj1H1NisT3NgaIl5L6JU1EK7reN5Exyuh5YZyf5myKWhaV28zXiemOMt590NvdEKGMzNaNnoop3K/ZnpmFAQwnPxKfkR0z3oLrm0MQy8XpB75AHSM6+zwICtBYLUZmSgE/KhUrWBq3cqyS7bxXjCTE/qi2cKJGYvlUrbtN945M8Vfb3Xqli9nH+
 u9Zs6VEd
 a0a3ZJzu0nMfpBy3tsOnVobjloQxrzpWAjA/Z004yMxXzffBPgLibY1vcRGQR9sVJY1scu+Wd0ynvVuKUjFBfBbbxhcDCfeKy51RlPESbf9UeU2tkui3p9CdPO/9evCUmGN1G9wKLeP5Cx/snTWVsjrWTbqCQlVly/SFeCGnNgc5LmqqHeWU+LYxx+fFpv9QpUswwOm1mXX9QeoiTW7x43mJ9cgGjPNc+ps28FC+r4GzkDAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/2026 12:03 AM, Johannes Weiner wrote:
> On Thu, Jul 30, 2026 at 07:53:14PM +0800, Ridong wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Writing to memory.peak resets the peak for that fd only. Each fd is a
>> watcher and reads back max(its own value, the shared local_watermark).
>>
>> peak_write() resets by lowering local_watermark to the current usage.
>> To keep the other watchers' peaks it then walks the watcher list, but it
>> stores the current usage into them instead of the old watermark. So once
>> usage has dropped from a peak, a reset on one fd wrongly drags every
>> other fd's peak down too, even fds that never reset.
>>
>> Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup:
>> B sees the peak (410624 KB), usage drops, then A resets -- and B's peak
>> collapses to 1060 KB although B never reset. With this patch B keeps
>> reading 410624 KB.
>>
>> Fix: save the old watermark before lowering it and use that to floor the
>> other watchers, so a reset only affects the fd that issued it.
>>
>> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   mm/memcontrol.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 60145aadfc5e..881e7c459c64 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4692,7 +4692,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>>   			  loff_t off, struct page_counter *pc,
>>   			  struct list_head *watchers)
>>   {
>> -	unsigned long usage;
>> +	unsigned long usage, old_watermark;
>>   	struct cgroup_of_peak *peer_ctx;
>>   	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
>>   	struct cgroup_of_peak *ofp = of_peak(of);
>> @@ -4700,11 +4700,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>>   	spin_lock(&memcg->peaks_lock);
>>   
>>   	usage = page_counter_read(pc);
>> +	old_watermark = READ_ONCE(pc->local_watermark);
>>   	WRITE_ONCE(pc->local_watermark, usage);
>>   
>>   	list_for_each_entry(peer_ctx, watchers, list)
>> -		if (usage > peer_ctx->value)
>> -			WRITE_ONCE(peer_ctx->value, usage);
>> +		if (peer_ctx != ofp && old_watermark > peer_ctx->value)
>> +			WRITE_ONCE(peer_ctx->value, old_watermark);
> 

Hi Johannes,

Thank you for your reply.

> Ah, because B was previously reporting the higher local_watermark, and
> its peer_ctx->value was actually low. Fixing it to current usage is
> wrong in that case. It must remember local_watermark.
> 
> What about if usage is bigger than old_watermark? Then we don't update
> the peer_ctx just yet. local_watermark is updated and propagated into
> the peers on the next reset. I guess it's correct, but it's kind of
> tricky to follow.
> 

IIUC, usage > old_watermark shouldn't actually happen, because local_watermark 
is a running peak maintained by the charge path:

page_counter_charge() {
[...]
	if (new > READ_ONCE(c->local_watermark))
		WRITE_ONCE(c->local_watermark, new);
[...]
}

> Would it be easier to understand if we mirrored the max() from
> peak_show() here?
> 
> 	usage = page_counter_read(pc);
> 	local_watermark = READ_ONCE(pc->local_watermark);
> 	WRITE_ONCE(pc->local_watermark, usage);
> 
> 	peer_watermark = max(usage, local_watermark);

In peak_show() the max we have is:
	peak = max(fd_peak, local_watermark);

I'd like to clarify that fd_peak here is a different thing from usage. fd_peak 
is the peak recorded by this fd (ofp->value), not the current usage. So 
max(usage, local_watermark) isn't really mirroring the max() in peak_show(). 
it's a different expression.

> 	list_for_each_entry(...)
> 		if (peer_ctx != ofp && peer_watermark > peer_ctx->value)
> 			WRITE_ONCE(peer_ctx->value, peer_watermark);
> 
> This code hurts my head. No strong feelings either way ;)

-- 
Best regards
Ridong


