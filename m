Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECE7FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 15:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B59B6B0005; Sun, 26 Apr 2026 11:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9669C6B008A; Sun, 26 Apr 2026 11:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A38D6B008C; Sun, 26 Apr 2026 11:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 798596B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:58:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21EABA059D
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 15:58:09 +0000 (UTC)
X-FDA: 84701163498.25.5E91582
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 348E140007
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 15:58:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YkviZMLb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777219087; a=rsa-sha256;
	cv=none;
	b=12aKdEBYNXuQEFAebqzeOJY/kOlm+HkY+ciyUXQaOD6oAEk9XD/VxQZpIX4kJLVIui4EEc
	RmxmVc3vuLs4RZOOEsQc/GbFURLGeiTvqGQI4ljMsq6Db6bT49pL6JChK9ZrS+NZDHvdpm
	Tgj7YVhQlwp6VwcBKebz5HyKhaqcCGo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YkviZMLb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777219087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4F6gB/xx6VdA5bb9zTaCkR+ngYQ60IUg/PkZ8TsJ+TM=;
	b=Zu9Qmv1q0vSo8cptDPQ3zJD5bSzZ4TCnHUp/xf682Y6njG7cDzVmfED6srJ5RmqXlINBZk
	CCW+x07Q9CF2U5NJfCgnZjqobr9ozVLTbjsnqBFFWR3F98FfTbjxTbHfq7H9PJ9CzfpKRI
	1X8PTGGCuocaiKe/92txSdNmHJUHsTE=
Message-ID: <e7187a21-7114-4f42-bf8b-90d6e6b54fa2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777219085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4F6gB/xx6VdA5bb9zTaCkR+ngYQ60IUg/PkZ8TsJ+TM=;
	b=YkviZMLbpQYaBN4JXqzO6Mdl1Ofdh94oik7QKN6ZWiWGSp+wJ1bysFJSq9yhwtyv4trYg3
	ALCtLJykxXf13/wWsTKyd3QQa5UvDRhVOJtSIQfZ6Y0Tc9oG2dWl6Ow2AQJoBDgifaHmUd
	t4bTDETusCI3JuxGQGprT54gSw5Jnis=
Date: Sun, 26 Apr 2026 23:57:42 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] WARNING: bad unlock balance in do_wp_page
To: Andrew Morton <akpm@linux-foundation.org>, shakeel.butt@linux.dev,
 syzbot <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, surenb@google.com,
 syzkaller-bugs@googlegroups.com, vbabka@kernel.org,
 Muchun Song <songmuchun@bytedance.com>
References: <69edca15.170a0220.38e3f1.0000.GAE@google.com>
 <20260426034938.db29d74982a8eb8463f8cf3a@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260426034938.db29d74982a8eb8463f8cf3a@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: t918mtx567ydh68y5zpch9ewoi7a5xa5
X-Rspam-User: 
X-Rspamd-Queue-Id: 348E140007
X-Rspamd-Server: rspam07
X-HE-Tag: 1777219086-833421
X-HE-Meta: U2FsdGVkX1+r0/M4Dj37uv3GQA2EWmPUZ13s0I2jcGYcMUUUOMFpUPWQk0cfTYmBZcHa2Y8M8xq9GfBzxs+YhF+1UgQIEr9waLFaXPJELvRaJnRuvw7qvnNX6vtBqPbShlcfQ1yJg3Vve/eyawYkLVxY1K+Aia6NWFuvBUA+/Y2QiOA5EbsciCsjIDDUuBundA5Bn9juRqGWNFyjXOaqlW4prdcLX2rGHzW5wynhs44UHwKAfhTvL/Mf69ym78SfdhpZGBX/cxsy80Xv77WGzkv91QjM4pC+wBj8xyfF1B9jJrz6AJn5T1DAV9JnbduT0l6abZgMQXku07jlQaHdCc4NdqFFvDjK6RYx1gUmB2cmz8aBdTL/px5RR1Psj3PxgqD1VeEE9S00HqF6zt0JS4eekOjSMZvx9oVldHFxFT5HWvWDhs5+BKYp/mDmdSqVhp8QZPOEhpD0u1cm+kKZMIviHGgYgG49sc9EI4tawsrR7jV6WmZdN/Y27/YERWsCj432rUp+edICtO49QcUe8fq7b79qsppghUbybW+0mlulkyg+XeAjjxOpdTqAu3+hI9FQewTB4VGA1XDqC6TnIsExiZRQP6HCxC+AeJPxu3+d/QKKD8xB6OSyDd/o0OWCneTioVTs1/H4vU2oPtUu1U0UgspPhNDzhxlRqJJXMreWBlGnBWr2HesBPMlt+3elTJ85qeX3nc7aEH12SiopXZqdeRECz+dVl/qvvnJkiS/3XdfXEQvHn3s1ECZf55p3VJeMVhNS2Ov8nTcN3lGhNLstX1QF1AEDAdPPt4wuTpGCPBnXUzhkDbH4+9h/3jkV+dP3jNEgidgSEJjSBF0jMoxww/9uZwciw8V4Bq6igeErA8wCvhOdDYT3EulQU1JV7bGpC7VMRE54zo9+Tz28MVGw7yFC/T2EbtEKOD4WI92gYK1Vu3avrAIDvbzAVVDp1YEUTCtTzkXqSZTxAA/
 DRb6iCez
 ylgLQSKzpgnF+z+8BmmE22kpwz2tyMxAevl7Wg57RzfuLyCfqWCv0pL7voL819/owWmzDrLpfOwiRzZ45d5YRIo1HEJRpqeO0+7StlYKFDmC+fUssJhbYnGIPkTUicHWISv035pqBSbnny/kAqw/YoOgkel1tysEY1G/dRTKk8M9dyfkFH0ThPPvwXnP7U4w7fPUqz01V164y4bVxcHN5PcFx6hZzRfJiLQ9ILh+Ff/Jv8j1pb+sviiM65qaZjqhMR801IDS9XHbz3d7430yaWMyu9DDQM6Ln66AFrUZhTWUND6PF2CJ7OS/MKbdX6nEiO/pxhV3FKry472TNz/PKPVDgqKPc4cE+g0TswUE4XQY50eH4QOskOJ2gazWK/xOvPwFDthJ627h57Mc45GWWCTX6yrOaWVpzA6+nXqwf8RJ+hbmiRR7v+2q5GLkQ/rUc+3ja+3l73U9JvtG1VhxsfMpUUH5/joqkNdWXgJktywhu8anxcmqG4fzxmx83FBXS7LZlxTNpTiDF7RqrHoEsn2oWJUCbUNMG/u/jMWOkBcolXdxEP9diLxmnQXH8BW5RckyR/ugzHTZo394po2r9YWkgNYOvUHi1eIhPcyVVH1SZuqZqlE8wkkkrJiu7TvAR7voCjuTCcX0mSm24u/uZ0FAlF2f975JFHFlj1ibkG1Dl1JA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On 4/26/26 6:49 PM, Andrew Morton wrote:
> On Sun, 26 Apr 2026 01:17:25 -0700 syzbot <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com> wrote:
> 
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    6596a02b2078 Merge tag 'drm-next-2026-04-22' of https://gi..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=12483702580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=24c8da4692f901cb
>> dashboard link: https://syzkaller.appspot.com/bug?extid=7d60b33a8a546263da7c
>> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
>> userspace arch: i386
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
> 
> argh, that dreaded sentence.
> 
> Thanks.
> 
> Something's definitely amiss.  This is at least the fifth report of
> rcu_read_lock() imbalance post-7.0.  Others:
> 
> https://lore.kernel.org/69eab803.a00a0220.17a17.004a.GAE@google.com
> https://lore.kernel.org/69eab803.a00a0220.17a17.004b.GAE@google.com
> https://lore.kernel.org/69eafb0e.a00a0220.9259.0031.GAE@google.com
> https://lore.kernel.org/69ebcbe2.a00a0220.7773.0005.GAE@google.com

All the kernel configs mentioned above include 'CONFIG_MEMCG_V1=y'.

Theoretically, a rebind_subsystems() can lead a rcu unbalance, see my
previous discussion with Shakeel for details:

https://lore.kernel.org/all/358c60e1-fa91-40a1-9e00-84c93340c04e@linux.dev/

However, in a production environment, this is practically impossible.
So Shakeel and I chose to wait for a reproducer at the time. :(

> 
> In some cases we released it too often, in other cases we failed to
> release it.
> 
> The first one is slightly more useful in that it tells us that the
> not-released rcu_read_lock() was taken in folio_lruvec_lock_irqsave().

I double-checked some callers of folio_lruvec_lock_irqsave() (such as
folios_put_refs()), but didn't find anything suspicious. :(

> 
> Muchun & Qi: you played with that rcu locking in 31b54a5e8916.  Can you
> please double-check that we didn't miss something?


