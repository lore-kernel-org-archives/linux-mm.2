Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F32C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 11:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469856B0088; Sat,  5 Sep 2026 07:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3876B008A; Sat,  5 Sep 2026 07:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BD356B008C; Sat,  5 Sep 2026 07:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E552C6B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 07:35:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81C0AA41F8
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:35:44 +0000 (UTC)
X-FDA: 85179503808.11.0C3787D
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B009C0008
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:35:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OvwYrWlq;
	spf=pass (imf22.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788608142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yu5YnN/1z/UayGFg88QtZGHAA8PYRJ3IGuj66BKuw00=;
	b=qYXmJgxjodEhQpO+STkL6A5z/3IzsMh3NTui8UyFdHY4K0tSJLEDSMGCIaYte0f5siiKPp
	gPxcw52FJaVq71D8S+tWQSJUshRsVTlTgLpU7XmuLC6DVznq6AIcxbfVIoRJ6slBzJKxVc
	Wzg66QDchJkuIIWLKUWzeZfz6O5t2BE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788608142;
	b=0QThJ21yTm1mwMmyarLciS+6elnf4Gy34lC5BJp53BMeEUAQhwmv8x2zopbal7O1Qikcwh
	eVwkCjDlxOwVfXn+G+U1HkZQ6Moj2DRU55QQ45hu2T/xW7GEnAeSr8zetN4vCm0MMf06NG
	ty51HQmS98VucDFKrowtjYVmCFTNy3Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OvwYrWlq;
	spf=pass (imf22.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84864086bfeso1695482b3a.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 04:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788608139; x=1789212939; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yu5YnN/1z/UayGFg88QtZGHAA8PYRJ3IGuj66BKuw00=;
        b=OvwYrWlqY98tz3SyMCaA88BHQ8wPfv9hC19UjJX7hCD1z9vHhLw88H2ABGqO2UNhxa
         vkcSTAdz9SdDKTpR5YdYLLOK/rM74RPOzZqqWgY8nEw4mIyvDqlx0itFhQzJlQZff8iP
         Ej9wh7sUn39V4UuREvKM6lHzqgECoSUUsW0cz86C/bXSSWW0v4T7Q1kK44PrFveJ7gsR
         6G3ASHFEjSC6T8oeu645BmrRoLzwIMxDtu7ttsZaQo0EN+rxMHR8sZEOTjbPmj9dCo1C
         JGV5dbOwCnBa80d54gEpuk1GDySw9a18iNJpQm2DapIQncY5T2B461iX+8xZWGRzKuwm
         ZqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788608139; x=1789212939;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yu5YnN/1z/UayGFg88QtZGHAA8PYRJ3IGuj66BKuw00=;
        b=UdPqqIpahr+q32ZT4OcskxwJzEhDfLiRhzNIry02wnKlrW1wOixELp7VEQmu6lKs+Y
         5l/kylxLLL/fxz5ltn02or1Sha7MKqXU5mPQatahXB1XDCIx3es5t2dL+/fraszR5And
         /aNexA/EHDFkAJ7UreRghTolXAgQTIAxLFJN+7FdA0IQZ/ddDTkLY5gGiY4A+iYOxOoa
         unPzOfVgIiHEDhkTronoZgmXdQOnMcjKfa2EkyJ/6RDGFr9GeJvyX6OFawSWHz8bsIdl
         bV+HCsxob3D/vQV3Q/pGTWvHQQsq6RnfHMMiRUvcPtGPbGhygISchXIJUZ+hxIJMf+ok
         ocUw==
X-Forwarded-Encrypted: i=1; AKwUvBxfjks/Qtkfc35XwmyXebwERiJ3BzSx9EfmXmCH79ThSXeZdifIknA2y63guXTPo9R+WyVUpBGN4A==@kvack.org
X-Gm-Message-State: AFuF++ntWS3GyWkOQzadPT3ycmlbNuxgv4Ukn1anOmkmNdM22qWDZ4a2
	ozEavDwQHew1jVBdWtxl9DZ9idNWg1QqWKx//Jg0fFWG4Tzub3JZFa68N2kBg5ogXtI=
X-Gm-Gg: AYBFou3DAqG/7hbEoOnA7pyp9VzpsZsJCSRnTxnikvjGtXHypONmZM5iY5M/NlxrZHw
	mji/4Z8Ncc4JyTrFMmxEv4bkCUaBQHakhpSTvE/sQeKXEzhlu7I8FNByH9HSJez8J4KJgZ0tY63
	VgrzcpSImi+K7FpvqwrYpzmzriS4SEsBlBVP/dG0bMj0M6XfIaZmSauESWMYh91P9QOWZFiLGd3
	E96/lNZCAtaAnz85SZfsIMQ/MhZUriCFuZNgpA6E6jhd/Jl11+MKizFyDXORqy96Z1wwq/bERo7
	xLz0pyz06EB4XABObujA+qrC8i/P3/gMJ91AuktvA2z6kMoi0MEognLjmwBDX/IT5EMo5FyDQjs
	zwfz1mlArqibDVVfAg2OqqaApj/AmaRjEJWZgfPIqK1wRMR519SuJ3+5jGn4aAxWJzjvMbSStZD
	bXekDTwafbB2Kku6QfNsnZnb/oJ/g1QYQc5MnUK12mB5pTxTs8DnTF8jgFaOYNpMYhSdaEdN3CH
	mpd+vLHtPv4P1J0cQxhUG2OkH6tg6bA
X-Received: by 2002:a05:6a00:94fb:b0:852:38ff:b4b6 with SMTP id d2e1a72fcca58-8616a76a6c4mr15990237b3a.17.1788608139353;
        Sat, 05 Sep 2026 04:35:39 -0700 (PDT)
Received: from [100.81.12.150] ([61.213.176.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8614f873c9csm2228069b3a.5.2026.09.05.04.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 04:35:38 -0700 (PDT)
Message-ID: <00340bf1-a46a-4404-9d38-a5433ca78fbc@bytedance.com>
Date: Sat, 5 Sep 2026 19:35:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] writeback, memcg: skip foreign dirty tracking for bdev
 inodes
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 axboe@kernel.dk, tj@kernel.org
References: <20260903083303.2769873-1-sunjunchao@bytedance.com>
 <20260903123427.eb0beab18ff68d4632aece6c@linux-foundation.org>
 <5f34e3e1-749e-44d1-b3e7-50e11f7240e3@bytedance.com>
 <j644hkswljrskiivxcimh2ms2zoilfptfhl7bdy6uu3tvqv6yd@m46nuyunp5ni>
From: Julian Sun <sunjunchao@bytedance.com>
In-Reply-To: <j644hkswljrskiivxcimh2ms2zoilfptfhl7bdy6uu3tvqv6yd@m46nuyunp5ni>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: egki5pycwt7b41apnebyju484ebw95ir
X-Rspamd-Queue-Id: 2B009C0008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788608142-172695
X-HE-Meta: U2FsdGVkX1+CffLRI+NitTfoMNkhxcFRXjUSs1m/JBVmBRD/VHp5ZXBQqO3vksaXQPsUsKuCFr19A4EHjaaiOTvlzCWFkhgTWqyqc/9i7cpx8bOC4Gxcuqz5i0NP45AGD+xmQbSPNtE5MN2q6mMeVwtJYWzfpVrq7g8k3/Beu7ipoqhbQJsJnYezTb2sm4/5Y0V0nCEZkOnBys6wdToJFRiuXWjUL6lcIIUA9q0q1E53ywY0N/usiW/hVQ9C3MNdot1t4Fv5dbOyNmWeh7xcecwQ32TQeMw39QRUbccWV0InWJvTamTNooo5pzMRPq30yblTQil7+IUgfFLXYDz1B/EpyfGmIa8AFjWeXtdYinoUMlybOw4Gvwfwcz+S7t0XyPMps8/gYYCqkVuLHQ4FFZzWCizGaEuSIqtI9DW6KGzjPU6rfS5sUPue9uxBykbL72jCvCG26LJDjS5AIbe9Qt3zywPFpu7gZ0P13ZlalBXqaXmQ5XcLTYFWPn/W3baLWoda7Dungr0jmJDI04PSZrlr0k3ZHD3InnfRUYrPcnH+2guQA9y8MfSbY2xtAKI3eonwRqF5Zv30/iyo0dg23wuCQV72z0DKErMx7lf9a5w/oZI5QeVcXmWU62Z2UDGmMqLFDjYP4GoyfQp3nDaBGn+qbBeJKphNB9nF2q54Trd9YAWknoo4gEWo0uzRRtnisdvuq+GNhCpwdYj0tam43AiUxSrqtiDceM1leb3TXKT8Z/Xeuj+u0oyvrOKVJsfryUFPbdar1s6IQIyL3lfzRmxaqDCI5izGQIZYK4wn21C8zeqhCInK81rVIfSqmmk6sdrTgH7s+22Pe+z8x30dsjIjq1nsGtSz26thpZ3o2MPv4qRIgKk/pcrLhJQudECSgoSOtC30lnzKkvpNRYfI7ZDpyOKgqd5N/729oYe80mwTMVXN4nwOlEKjM/ZdJpR33oIQas3+9BJy13avNnb
 klwfgG4N
 J0EEAVAqhN/Z2p9wF+20itI4s70uh37rgeD/Ml8FF6pL4h4ozD77yFVisPU1PK/iXB0Ja5BGIf98YuKyJOlgi+uaR4XEoOmvy1HwHNozK0RA6+92Aedab/icrZj5URqUP2LZ98TAExO/dj9aEqCIZnqWEwsRNtQrQY8zPpjVmVjhb641aKcFl5E16H21+Z3vw4mchtriIrPJhgq4KBuOifv/mto2WTjYuGcwNd6J1LGYX5EWQPqmmL3U9Dng77WGlczl31wkJ1IzDA/KSGMy9RIUqWxp0x/kG2H9toCO/exaWQzjUfpeJ3p8YBraz8UV8xFIaXoby/GIfV4yDxgQ5tRp2N7ZDZeNmpNcIOjwsqE+9382PMKkkGn//WS0pXCKv3pblUNo/KFsMTD10C65zu6J1wtR4FGXaFXXQ+mjeG0mpcJV67gCTBexYe8fCJ0pKYxQO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/26 5:00 PM, Jan Kara wrote:
> On Fri 04-09-26 11:39:23, Julian Sun wrote:
>> On 9/4/26 3:34 AM, Andrew Morton wrote:
>>> On Thu,  3 Sep 2026 16:33:03 +0800 Julian Sun <sunjunchao@bytedance.com> wrote:
>>>
>>>> Foreign dirty flushing handles cases where a dirtied folio's memcg and
>>>> the memcg owning its inode wb differ.
>>>>
>>>> wbc_detach_inode() notes that "concurrent write sharing of an inode is
>>>> expected to be very rare". This expectation does not hold for bdev inodes.
>>>> A bdev inode and mapping are shared by buffered users of the block device,
>>>> while the inode has a single wb owner. On ext4, buffer-cache folios used
>>>> by metadata and journal I/O can therefore be charged to different memcgs
>>>> while sharing the same mapping. Normal bdev activity can thus produce
>>>> frequent folio/wb ownership mismatches.
>>>>
>>>> This was reproduced on cgroup v2 with the memory and I/O controllers
>>>> enabled, using ext4 on a loop device. jbd2 repeatedly generated
>>>> track_foreign_dirty events for bdev folios charged to unrelated memcgs.
>>>> When one of those memcgs entered dirty throttling, the resulting record led
>>>> to a flush_foreign event and queued writeback with reason=foreign_flush for
>>>> the bdev inode's root wb.
>>>>
>>>> Skip foreign dirty tracking when the folio mapping's host inode is on the
>>>> blockdev pseudo superblock. This prevents bdev-originated records from
>>>> triggering later foreign flushes.
>>>>
>>>> The tradeoff is that dirty throttling in the folio's memcg no longer uses
>>>> bdev dirtiness to queue writeback on the bdev inode's owner wb. Those
>>>> folios remain subject to normal writeback. This is preferable because a
>>>> single bdev wb owner does not identify which cgroup is responsible for a
>>>> mapping shared by buffered bdev users. Flushing it can write back data
>>>> unrelated to the throttled memcg. Dirty accounting, normal writeback, and
>>>> foreign dirty tracking for non-bdev inodes remain unchanged.
>>>
>>> When fixing something, please always describe the userspace-visible
>>> runtime effects.
>>
>> Sorry, I overlooked this aspect.
>>>
>>> I'm thinking probably "unnecessary I/O"?  If so, has this been
>>> quantified/measured?  If not, can the effects be guessed about?
>>
>> We suspect that a large amount of prematurely triggered foreign writeback
>> consumes device writeback bandwidth, thereby degrading the performance of
>> the entire writeback path.
>>
>> On one production machine, the total nr_pages of the foreign-flush works was
>> 630,681,285, or about 2.4 TiB, while the machine had only 400 GiB of memory.
>> Although nr_pages does not represent the number of dirty pages that will
>> ultimately be written back, the actual number of pages written back may
>> still be very large because the corresponding wb was continuously
>> accumulating dirty pages.
> 
> As Tejun also wrote, it would be good to really quantify these effects -
> best by demonstrating how this change improved writeback behavior (and we
> are not so much interested in the number of submitted writeback works but
> more in the observed load on the storage or completion of some workload).
> The problem with your solution is that it has its downsided as well
> (possible stalls in dirty throttling) so it should be very clear what are
> we gaining to outweight this risk.
> 
> In principle I agree that a lot of submitted writeback works can degrade
> writeback behavior - a lot of workloads has some set of folios that is
> practically permanently dirty and if you are pushing writeback too much, we
> will be just writing these folios over and over again without useful work
> really done. Also if there's comparably small amount of folios dirty, the
> IO resulting from writeback is generally less efficient. But how severe
> these effects can get in case you describe is not clear...

Thanks for the suggestion. Following your point about repeatedly writing hot
pages, I tested buffered overwrites alongside a concurrent direct-I/O workload.
Skipping bdev tracking reduced actual writes to the overwritten file by 69.6%
and the concurrent workload's completion time by 14.4%.

I also reproduced the downside you described: a metadata-heavy workload
completed 31-33% more slowly with the patch, including final sync. So these
results do not establish that blanket skipping is a net improvement.

I've sent the detailed test setup and results in a separate reply.

https://lore.kernel.org/cgroups/apnYouiUINQR-98e@slm.duckdns.org/T/#mdc87094720abce0162c14cdf8f3d0ab218eea686
> 
> 								Honza

Thanks,
-- 
Julian Sun <sunjunchao@bytedance.com>

