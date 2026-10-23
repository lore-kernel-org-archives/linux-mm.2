Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A96C1606A321
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=j5Mye+ph
Received: by kanga.kvack.org (Postfix)
	id CC2236B0384; Fri, 23 Oct 2026 10:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73C26B0386; Fri, 23 Oct 2026 10:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3A9E6B0389; Fri, 23 Oct 2026 10:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 885766B0384
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:05:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A7A11A041E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:05:44 +0000 (UTC)
X-FDA: 85354064208.13.4EAB939
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 24C5C1C0018
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:05:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j5Mye+ph;
	spf=pass (imf18.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792764342;
	b=MOZ7y4AdB2TN9Phmo0aqr1xApeX+csZFxLuSe2qG/7RuUQ+IzcEbed5PbjgGchTxea5v2Q
	fqu+KU88gen/QXG/hQBjNLAHRIa+MsiqlXW2tLzNV6PBdFHn4GLp7C4y/dn+xnNXRbNZJq
	xllss4Hy/LuCCJouXpm5iwO0dheTeD0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j5Mye+ph;
	spf=pass (imf18.hostedemail.com: domain of krystianmkaniewski@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=krystianmkaniewski@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792764342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BUJVWluZQW/qDMSCSzMsGJRAgytWrmfDDzAkl2tvmys=;
	b=SE8F8XFJ9xbcONPm8RdF8NtPNHHbNnFlPz8P9+luGl2OuJzJYgdrov7u0/woNxe3IqBJwa
	YRIzJhzcCIe1o8ofXsx+SZkEtfadIcmSl1HIJsnVGBlrYjOfXwP07faYRMAqg5d7El5Eg3
	C3713bE8g7vhiLWN/tMANXjiyDLBlLY=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c43373ae89aso149117866b.3
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792764340; x=1793369140; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BUJVWluZQW/qDMSCSzMsGJRAgytWrmfDDzAkl2tvmys=;
        b=j5Mye+phnF8zEmkv7OQi+zlUc7ouLtxbvV9HveZcJl+Bf+dmPWuuQMtz23s5M8prIh
         7LHbbIpyfWCLjKYhdSF/Wi4XZU7oLp/SI4vyDcci8wL9482NVX6fv7YSscneS3HwuWBP
         MEs0FMV6PUSCtnalTi/i6NsTAMv5VOlt/TGnYhGVWMf/pCAjfNWLEqnoKLtCkRwxsogd
         Zvm8W3yYnP8/JJpOwxWBMnftliRTXjrUeTh1YOm+TTMWW1H9PvMI9ntSqaj6fIY3Zo3P
         mxu3wCTuYDnQVH+aqsL5IYdQkHfE15dlS8CREuLvLsoMZk3IrnrGg5oZ5nECZfMY959V
         4FZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792764340; x=1793369140;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BUJVWluZQW/qDMSCSzMsGJRAgytWrmfDDzAkl2tvmys=;
        b=MoX07lCKES8RAaYsVLHs7JvE0qWeRjLaRVV5SxxNwNkAb0pO4Xcj7ehBuJye1clkPx
         f76IaN+rcyuJNDL6Z0cu7pJjHrA6mC0T+qvXXGc3vAX1MQL/Mb+9m9IPcTHfcAH3pPmW
         7FRjviS22i9lfJy8RUuvNJGq2kpTAWY6ZRa2b7MJ7IlkrM/2L5/SPyATtJ2fzVCxDdyL
         pw8u9O7DkqGRsbeLaHaOKOe3OS/zl9ifbOM0soB3pBcvNFbpxvhkKiaa4+6Ejn3mh3ky
         ILF+i2MQVcuUPfVMiaLaWKTTpmSlWas6q5ri3ZyCH8fkdHDtvn6uVLMbMUed/TsLpcI7
         6x6Q==
X-Forwarded-Encrypted: i=1; AKwUvBzFyq7eutUtmTIEkcQtuMZthbpNKdRm/9U5xdgct9ncAT8BMd9oA6gz8LzQZYwm756t3FLxzZ4drQ==@kvack.org
X-Gm-Message-State: AFq9FYIUXz3L2qitbH4rO+y9nqKiZP0Po03IlcEET011VFlx+AjUVICU
	OlK8ZPy32rGLEh2EJR9uCNffedJfam1A2VtT3tgppcr99AMdKy2oRncZ
X-Gm-Gg: AYBFou3artH59y/Y8Rf58nOqgnVfvlLA2AITzL7Mu/wNi7p+BPvxeH2GGBrXlNBxZYR
	OonToPedDSYVYQbbfqOGdhoOGmFWzoJcC+D0qcIgHCF6ee01QSSQcrzSM+NJe2rXG+2eOIteHJN
	Z696cWBE82mXBK1ibZxgPnWZDioqmEj73rR7ctCh65oOWCHiXkhdxbkPn9k45u29LXwbB1hZlG0
	qtQVZxEUdDkcSDEUKQ9wAs5kaYfHi5D2/u2UwrT3pVq8XzpUAM2OZOItVOKDmIrVSJKkzEMMjT/
	OWN3rKKzROu4e/sbW/sI55CV8yOPqiNSir0sEEwTbRNeclDjgDb6pfUEFSfigTj4YeWBrKQ/OoC
	I0tTIL8IYzY5Um7e7Lj12BrrFdgbOBPH1dNZdoAZw6V3xpKBz/Soi0VIcH6Csu6uLrdsTGnyGmw
	aQS6b/99B+vj0wzTZeI4VYHDJiXk+WOgwEXKEawU2fyU9s+nndI2bzkfYX+oz1pFW6PtNN5N61W
	bTY2ftzUY8whNOUPVwAFl3ipUmKBjED2hpg+IqlOHMHVRoWzBciU/olRTBlEJVJjLS52oWfkUhD
	XcHcz81Kj6RD7xgsHkn3+zycv2Hu7geMhzM6E73yU7+xC3nGCIwFtnRNGeWVOF6VgQTjZdmDMra
	hdQsfbvfIBl67aPmVSFA/YNaBncv4NmVwIloMb9AR+Y8/p69Zr1BZUZfjhZHvLWsGUHd6GefFqP
	hNcw2SsImXfDftsAg=
X-Received: by 2002:a17:907:930a:b0:c41:30be:4f84 with SMTP id a640c23a62f3a-c46a90ae916mr376211766b.9.1792764340190;
        Fri, 23 Oct 2026 07:05:40 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46b8ba181esm4707666b.25.2026.10.23.07.05.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 07:05:39 -0700 (PDT)
Message-ID: <7a212208-74f2-4d79-8ca2-a1502d0e0a1c@gmail.com>
Date: Fri, 23 Oct 2026 16:05:38 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] kernfs, autofs: fix pipe lock cycles through sysfs
 stores
To: Ian Kent <raven@themaw.net>, Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 driver-core@lists.linux.dev, autofs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com>
 <cover.1792577179.git.krystianmkaniewski@gmail.com>
 <649966b83b39fcdd25e892fc3c6732a1@kernel.org>
 <22d41f2a5546d3bc90a1b3ad24ed3656588a854f.camel@themaw.net>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <22d41f2a5546d3bc90a1b3ad24ed3656588a854f.camel@themaw.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ykecakmuj8tuo6cjbc76aa8rzkajc7kq
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 24C5C1C0018
X-Rspam-User: 
X-HE-Tag: 1792764341-241652
X-HE-Meta: U2FsdGVkX18opggF9HULNUIUUUu9XFbjuI6jrs41Mcfx/4stoDvJhxdsIXpAyDbVublq5NmFI96zS8GlAzzkyIVJ0a+nlaObBUkJOVr+Lo6/EGTtvfLCYFCZ5kcovhqEOlDtU4EJYkOruJ7xNvKcZv9yo52tQiDT4CwtpisGBiT33+KfPbm+DHlJ04ckYqDOGl/ClOYvvEdu0tlrwqTiHmpNXyPcOmq9qARGiz7vzBD0uZDlkZtoFQG4/q1nbN5Cn/8pyn/lCOxjstYQ2Q2PNsMWFtvIxTo3KaEM05UcmX5cFb4+mDcZtPta2lvGQXdfx6TIOjWvlEqysH6TdgxElZg9fZzHbAnHSkF2pS4A8AzheI51UlXB2fnn3DnSnDPQ1eQ6OnfbwIiVUVK49LF+JjvsKakCVvYKtGRCLWffhPHDk6mEf9L7tTxrtMU3xPVzbM7Rb7zkLFnbavJA5Tgr3OwzNK0hBlRPrKKFVL9tnCS2yk2LltlqaSbwrE6V/nPNVa98usYi5qq0sgMj5sRUc0lGt64kR4zMwuWQCgnEUOHkyTifk7jehVKMafGG11/OmsDMa+2z/k5b0DC6msqZa2w9m91I3++uTH9eezIEvaOG41xKKSpk5CM3742UGTOx/RLPEp2eb7ZZXxPKnuhQCinPoBSN1OzIbCEvYO+M8GdyikHpczoF7SxagnsUjvJ07CO4ny9OGnotU3CxjT7cZNoAS7QUspMCTUhBnSUkHX/pmXS8P0LlQtiBuyDujEK+nM1IxzhtitT0TnAVK0mOpfbyeKkwv11JzIe09iHikMPBtYh2/bOXcOAyNo8NCZ2GL/guTb4ZGbh8kjPh6r9KX0NQvGpr2CeZ1Qy8mE69lJCp1DctlN/eab9fhCZ8da7H2seeBfsxvnIWfHImz4zs3D/VvdzLlLdlvkKt4rxdMC24fcKap7XZjdcrbCYypOKD6jUpeskuEUZ9NpI2nNa
 bYpp6Z9z
 j2kGWEONUNbiGOu/dbdF+vyk9DVHdCgvlA6LCXAG8n0dKrxAR0v7skTwXag3hcYGvds5SCK/VOFL/OtSZ2EWTCh/496WXg1Jh8Xp8D7ep09kphkWflfyECm6qKNBD1r70ycRz//ceswKt5pOI2KgXx90EVOzUN8rc9GvYjG+Qg0LEfwh9yGcKaXTLBFaBr/Xhijbw3Vz4H1AwP2GdElh3auLTEPZc6CrbMTAhRLXo9lFswOVu+OrJukEAwwRqIggr64ngSmQjH9O3biOE1usQmTh16shgkylQDF9SCVsWY/cnvWtzN1u3EOBDLAQARLFC/zDyy0Glj09eHmMfZCqbLxyjW9c9jCI7DkaTNxys9AwIOwxvWm2O/WJ4IiOX/CtPWCC/h0ovskLZ1Xr5qlECcyO+TsDBcToRhbodK546zvTSdv7gnPTQRrNbXz1xnJljYoRN3DA1fsVJ7EN0WIwWgFT7B73SAvCyh35XI59iGU5Tv+ZoEpGT946kmJ/1Nchq3GvIF1B/mKWUDrWjMRbEJNBtJvPlVhhRYkQ7gUe+BL/Nkmbqk1IaLVwlT8Eh2YYBDw+B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Tejun, Ian,

On 10/22/26 04:46, Ian Kent wrote:
> On Wed, 2026-10-21 at 11:48 -1000, Tejun Heo wrote:
>> it doesn't make sense to change the locking scheme for it.
>> Can we just disallow splice on /sys/power/resume instead?

That would address the direct case, but it would not make this report
go away. The lockdep report combines two separate operations.

First, the reproducer splices a pipe into the cgroup v1 devices.deny
file. This records:

        &pipe->mutex -> &of->mutex

It later uses a normal write() to /sys/power/resume. That records:

        &of->mutex -> &sbi->pipe_mutex -> &pipe->mutex

There is no splice into /sys/power/resume in the reported sequence.
Disabling splice on that file would prevent some direct deadlock
cases, but the first edge of this report would still come from
devices.deny.

A complete restriction for this attribute would also have to cover
both splice directions. With an O_RDWR open, a splice read takes the
output pipe mutex before the same of->mutex. Another thread can write
through the same open and reach autofs in the opposite order.

Kernfs splice support is established behavior. Commit f2d6c2708bd8
("kernfs: wire up ->splice_read and ->splice_write") explicitly
restored it in v5.11 after the VFS stopped providing the implicit
fallback. The pipe has been locked across ->write_iter() since 2014.

I agree that changing serialization for every regular sysfs store is
too broad for this case. Before preparing a v2, I would like to
clarify the intended scope.

> Not only is the description hard to follow the example is flawed

You are right that the cover letter was hard to follow. I should have
described the two operations separately. The automount itself uses the
normal empty directory case.

The reproducer creates a detached indirect autofs mount with its own
daemon pipe. It changes its current directory to the root of that
mount and moves out of the daemon process group. It then writes the
relative name "0x0000000004000921" to /sys/power/resume.

resume_store() calls lookup_bdev() on that string before trying to
parse it as a device number. The pathname lookup therefore starts in
the autofs root. The new negative name triggers the normal mount
request for an empty indirect autofs directory.

The dentry whose ->d_automount callback runs belongs to autofs, not
to sysfs. There is no autofs mount on top of kernfs in this
reproducer. Kernfs is involved only because resume_store() starts the
pathname lookup.

The change which made this path possible is 1e8c813b083c ("PM:
hibernate: don't use early_lookup_bdev in resume_store"). It replaced
early_lookup_bdev() with the normal pathname lookup in v6.5. That is
what made autofs reachable from resume_store().

> The other possibility I was thinking about when I saw that report
> is to disallow file systems that don't make sense for automount.

I may be misunderstanding this suggestion. In this reproducer, the
filesystem which owns the automount dentry is autofs. A restriction
based on the filesystem owning that dentry would therefore see autofs,
not kernfs.

The lookup from a sysfs store is also not unique to
/sys/power/resume. For example, with CONFIG_BCACHE=y,
sys/fs/bcache/register also resolves a user supplied pathname.

The exact reproducer records the lockdep edges with different pipes
and different open files. It does not deadlock on those mutex
instances. After sending the request, it waits killably for a daemon
reply that never arrives. Related setups can deadlock when the daemon
pipe itself participates in splice or tee.

Given these two separate paths, did you intend to prevent only direct
splice operations on /sys/power/resume even though the reported class
cycle would remain, or should a replacement also eliminate the
lockdep report?

A per-attribute splice restriction alone cannot do both. If this does
not justify new kernfs infrastructure, I can leave it alone.

Thanks,
-- 
Krystian Kaniewski

