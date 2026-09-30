Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E611CA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 10:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2010B6B008C; Wed, 30 Sep 2026 06:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D91B6B0092; Wed, 30 Sep 2026 06:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EEB66B0096; Wed, 30 Sep 2026 06:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9F036B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:18:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68495120768
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:18:39 +0000 (UTC)
X-FDA: 85270029558.29.E104632
Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7395640008
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:18:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=otE3ZSiJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of amir73il@gmail.com designates 74.125.228.96 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790763517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqWINpH2l++yemIsiJMfBHQQztSFoALzePZUoHg8GKk=;
	b=IqThdpxy30X4zBNJ2OcKiLlB99vPHOVNOaxcLhtdXpvW+jtf7tRAU8h20oS9skkGHO4LYX
	Ik1qSAH39MddzlF9eGeH6vwLBY+b43guQ09Oh+KV9L+ev3W8Kh0lLzy3MmGPI47Dazs4kx
	MFw03FvdWzDu0vnHsR/QZLcNOadwHAM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=otE3ZSiJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of amir73il@gmail.com designates 74.125.228.96 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790763517;
	b=tKbYrpSGS+z9ZseSxUxEv5TKJXlpQlWRHgoaNopQaNSMM9/KyKOu1sdcz9HlWmG+31CeEc
	+qSKr5DyriIZq6l/X7cOo4xyGlPh1FPPZhyAvL+FKTh38YxCIfsVc9SLEnN4k/rMQbNjIf
	tsPZfXOxyW4ZdLCe9b/CJbcG6fMiYR4=
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6ad186afdf4so1389487a12.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:18:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790763516; cv=none;
        d=google.com; s=arc-20260327;
        b=ftiXRcrgD+gT7OV9EtQKQZQZ71XApnylmWQfRb7fxuLqrfDlR1ixr7+gccbf3TPlGY
         zYCqnCvMibIrggOpuGsRjhBguaCRwUxPId4QgeSE8lnDg8RRMz/jw4AaYvTNPk+yfDiV
         zafKF1tfM/NG8X2sSbpDvaw43e60tEMC5kwbTiHONc4T2x89Y6m/XcNfk07cOttPfDHH
         PTgeLk8zg6ZVqgJ9uLYi0yyQyRtqOVMFcR9EKQi38vXyJAJgnU8Zr2NHEzxfO68OeMRp
         BZPDNwscDbzLY2sOqCenROy+aqypvVja30QtMkRpto18VuFnmtHiJHrBg6c7Fuc3USCA
         g/yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vqWINpH2l++yemIsiJMfBHQQztSFoALzePZUoHg8GKk=;
        fh=T9l1VP6p9PmMOlw/FgOgUNpciywpFMiWR+/kqxFrynI=;
        b=pucgXwTry5l/TmG+wUOusIp7Zjz0N3PYVBlyxSB5gMHQJ4+uXnVkNLgbV8b3jgP/c2
         4V7vsn5ukAmcmeZSsmMdTo3uDG6rvNNyhxXl7XeGZaoWrTPjBtVJ3V5u8lOLOBEbbUxn
         eXUmepAsrFvBSkgdu9+DnsLd5gznUkOP/+qG2qjEuQPuZLHa2r5pLU8Fny1Hp4GkGF3t
         NZqjdw1M1oJ6yU0daiZlPuJdlft0IoTJ1cC4bVMD+03ZKE8beLgbzXho405UYgGUOW9x
         GC6/goSZlO/1xaqWyz347y8Ik7Tx0WqNZu1r6tEuVqe6J/UfCdVBp4pBkoGY0Qpl0+0f
         MLfQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790763516; x=1791368316; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vqWINpH2l++yemIsiJMfBHQQztSFoALzePZUoHg8GKk=;
        b=otE3ZSiJlQ9LAUNHpv4639h3ZQci3Uh5kovxTiAGUjuOSUNUoCR89vZI1xAtBZWwLp
         7J9J1/Emm0gU0PeNPbeMLLWJL7opvDcVD3E2+NW8NLfxx6n002oC+IU7wGumkpbaQh21
         Fgw0FkRqOuh5tP9IkBn8UWdA9SknzBpOUNnvoixsRaj6/cM+JGykuLEthgOeYSMYpJtu
         5QAfIFYLRocZRq7uhjLwZR+D7xqHD2vz79hEmGpG5JxkISp8YnRgPtFH1kiqT/QUqXyP
         BopgkU2Jki1aZw2AIoX4y/NhOEkefL9YFvUj/ZMTr2013TekkJ6ip0wrrBDgT3J2O5TL
         UCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790763516; x=1791368316;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vqWINpH2l++yemIsiJMfBHQQztSFoALzePZUoHg8GKk=;
        b=bTXtg+Wm8EKfropdizxtvjfWoRjxkDvHpBGeN6+aJ56mexiBYGn4GWwMCGYvBifqsb
         Uz1hBaDtS1u7WeS994wbbexHJBHv8klcx/1KL4KsyI5HsFB1OsWnv4G7owaH08OBNKzZ
         TWT+Mr/hciFx69+WT4h3gUG6HFROM9KsOP7WpPzBaBjI6lsOblG9EBL/CEuh3XkVqdqe
         ss/2Rlg34Ou1XnK7KF0MGS9+Y1HzxxO+P5yGpsmaZs/GlVT1t9X0FcbhSxpqbOxacAui
         abZsRUtFSmiB98upvzf2loytfuQjDLXpzap00ELBblC0pxYfamrAzxSYypfdANCznjLb
         ObKg==
X-Forwarded-Encrypted: i=1; AKwUvBz9Eff5FgZSGGS1KtcWv+NBm5Kfd0Cw6oWtjPcf+/wD3qNNF/Q/dwcYACHrWJuco2XlLqDJklP6Cg==@kvack.org
X-Gm-Message-State: AFq9FYJiDSCcQuPO5bavEX9OzQeV+Ymko8vm3ou6xNrLIVeYQEFkJdlH
	h5vC5YROLMz4Zz7fY9AdSBlRqLzgg7nT9sW6XeZxsOnZpqaBOsVG3Z9Y+wINaqOVbU+S+gvPnUV
	LSZ/doPTJGa5NzIXn1WHd2GRfRLgsBhU=
X-Gm-Gg: AYBFou3QWaK2N/ALOUNPQhA+ELCATl6TdIEx7OvGsCz2maEkoj4ijDkaAx3x9TWALgc
	OndZv+IJEc8QsTkGCN2BpApyZd+Ifr6aSBdN+sCPLCnOAAxO+duer1V2BFYYfLXKIz8uwHrv/Xb
	dl5bvfr1nAWBG4Y5QW51whMWlvM7gi9mKNIVTc9vHd8jAt+j6WEpWotohS7tzRC4epuXBOpC4h3
	zPzMLOOQeLs/5FyZQVIFZCVxoS5BmRoww0SuJcMLTlnOozIaoLE+2w1bP0GWtp+DSatsOvF4UMI
	hPAS3g4Vw4koeeZgOlsxbRghO4MJn0hupIpFnDLdv9c/C22EE1g9/8Mf
X-Received: by 2002:a05:6402:43c6:b0:6aa:7fb:7678 with SMTP id
 4fb4d7f45d1cf-6ae19864b56mr694393a12.6.1790763515717; Wed, 30 Sep 2026
 03:18:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260911081309.14137-1-jack@suse.cz> <20260926024829.3051410-1-matthias.goergens@gmail.com>
 <cxgitt74gb6d42l4mdiztrz42xuaykfggsxoussgdmo3h2qur7@injom55qowrs>
In-Reply-To: <cxgitt74gb6d42l4mdiztrz42xuaykfggsxoussgdmo3h2qur7@injom55qowrs>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 30 Sep 2026 12:18:24 +0200
X-Gm-Features: AclHuK-3QU8Ah69f36a00phhVqdJz9uhWwk7JlN9U3fb_vS0faf30d-5U8oF9rE
Message-ID: <CAOQ4uxhdRm4mENZCArR2PW+=NQz_jzqTugz6-tBmPLvCHfPkMQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] fs: Deferred inode reclaim
To: Jan Kara <jack@suse.cz>
Cc: Matthias Goergens <matthias.goergens@gmail.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, brauner@kernel.org, hch@infradead.org, 
	xyzzy@yandex-team.ru, tytso@mit.edu, djwong@kernel.org, agruenba@redhat.com, 
	Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 33dtm9b7pu131bg77an64xaw7ymtxx5n
X-Rspamd-Queue-Id: 7395640008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790763517-779953
X-HE-Meta: U2FsdGVkX1+ZyuUNYzI4b6pl31x7g25q2nl/dPKqSrFzYpukW9z1lw4zGfweKJfnhQV1lTSsg+pMuvFoOVdnK+ie/ykGPmjShQ/h/Y+qsmEd80SKS16knPzxVy7rNrcK63o8pXJfsdnVJNz2Oflwm9cQ2NxhF0B9yuOqlri3PKDIqZzdyWe3VIM8eBUiL3Eg65yB8Y9e/O1sWu5SVBfbB/yQHx+E7kUw49ArTXqX2NoPFXcefA4TRmPRWioFl+JGnDBvxs94kfnQQ2AZSa+Q3PTtgxRMg5LuZZ6FL5Z4MQyd6GClSoU2TdtmQBE2sDpHUMxPu4tbXeeDNo+KFjOaP8FOT6qKf991FY+GVala6t9mSYQLy3NPPewl/qE5sC9zTGuR7nmpcS/fkkXG+7tD3O5+HEF+vBtsk6oAKmzNtWs5tZ9vtY/6vt6EdSBX02tO4yHUBtsehZZvPBTPCl7FsxTOQu78z2Ltse2WUJygPVQI7IqjlfoGJb+L7K648GFRF0r+/QzW9NKmmp27GGb4dcAoKCYfFMqfyITEpZNggNN7imkRGvLsvvzSHroPamSQa5kb8TTyG4GqDntyG5o5TuQzFRmwmfT8rQHC2xAcHF3+JX/6sjwn6iyjljEHSzQZjD5fniN6NyI2BjnELYEK8KjkhNk8BWxMDlwisFB93CTvKk9oCe996A/e9/P7t0o2oBdcoZwjOBs1Hc9aNEgfhn7Y3LkqM04Q3Fua5cXPryWHXhgde+Mj+CriU4xRV+4Zn8yzAzKe9UZrLAN1buQvoe1lcnMUWQN1i9ocG9zjQi1LQCxz4X/AA7V0ghbgAsioi04K1lSkWVzsAO45eNwgFE0jIY/9KgieP2wue1bJflvp9Uz2CHNTKdDEyMqeHfI9cD9915spEgdPbBjQwPlsWpXwTKX7Y7WtXFaED0S45PMMoykmWDEPteS+6AJQu49uXtwz5knNHbCbk4wXjk6
 StXrSVxH
 rUHIb6u9y0Gs/RxP0fuvdZCYhIkKc0UhBn1Xs1Yt3eSwjC+3iPfel1oitzgTILYA4+T7pZU6YdQX8NWNZ9rJn745q7eWWc4U/cuRKTct6b3MlpwGPBjzePHL9jDWqtf8zINy5pHozo2LoVuUub+DQb1q1EPYNUJa7zhWcyxzeULUMSADAWAZOto7OriDQcH6BIocAvEif7gYyokanligXK/f3YVTrZxAyjln7wOTYL9S977Ekzw8eATiIx0yeYpfDJ5KV83l5bk+sLEQ6ZsoHY1J6nId/jjLJU+u3MdjLKB+TPJj0Q3qm28Ds6iiskcsgnJkpNiT4mBh/KEWHe8QzOeZnn8wccnzYRdIW9rP3Kd6l6b5Nyv+o6z6xfG0YnawIxs3l4BywJj67Z/mA67kjX1tzI+crM7YQS1QqaSfcA38kN2eu5kX5jCE6f2htlSXS/ug9PuEkCtKRhavBt2WDXZ3XNLIeZdCkftNXEiaBWVXQXTMskECj7tvrpA3MExBOp7RozHqYlghAqEE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 12:38=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> Hi Matthias!
>
> On Sat 26-09-26 10:48:29, Matthias Goergens wrote:
> > I ran v2 against its base in QEMU, on syzbot's disk image with a config
> > close to syzbot's (KASAN, lockdep):
> >
> > - Lazytime churn on ext4 under memory pressure: the PF_MEMALLOC warning
> >   fired with the sync_lazytime() stack in all 5 base runs, four times
> >   from kswapd, and in none of 5 runs with the series, which evicted as
> >   many inodes in reclaim context without reading ext4 metadata there.
> >   The workload also runs drop_caches=3D2 under memalloc_noreclaim_save(=
)
> >   from a debug patch.
> >
> > - Hibernation cycles with /sys/power/pm_test set to devices under that
> >   load, with inodes that 5/5 defers queued in each cycle, and with
> >   freeze_filesystems 0 and 1: no freezer timeouts and no hang involving
> >   the queue.  The stalls in throttle_direct_reclaim() from
> >   hibernate_preallocate_memory(), and lockdep's warning in
> >   __set_task_frozen() with freeze_filesystems=3D1, happen on the base
> >   kernel too.
> >
> > - One path the series does not cover, see below: with the series
> >   applied, unlinked ext4 inodes under an overlay are still deleted in
> >   reclaim context, and the warning fired in 2 of 3 runs, as without it.
> >
> > The reproducers and the debug patch are at
> > https://github.com/matthiasgoergens/linux/tree/deferred-reclaim-repro
> > and I can post them here if you prefer.  The Tested-by below covers the
> > lazytime and hibernation runs.
>
> Thanks for testing!
>
> > > @@ -988,13 +1013,27 @@ static enum lru_status inode_lru_isolate(struc=
t list_head *item,
> > >     inode_state_set(inode, I_FREEING);
> > > -   list_lru_isolate_move(lru, &inode->i_lru, freeable);
> > > +   /* Inode will take long time to cleanup. Offload that to worker. =
*/
> > > +   if (inode_state_read(inode) & I_DEFER_RECLAIM) {
> > > +           list_lru_isolate_move(lru, &inode->i_lru, &lists->deferre=
d);
> >
> > This is the only place I_DEFER_RECLAIM queues an inode, also with
> > Andreas's simplification folded in.  An inode that ->drop_inode() drops
> > on its last iput(), which for ext4 means every unlinked inode, never
> > gets here: iput_final() calls evict() directly, in whatever context the
> > iput() came from.
> >
> > syzbot hits that under reclaim with overlayfs on top of ext4, in the
> > same bug as the lazytime trace in your 2/5:
> >
> >   https://syzkaller.appspot.com/bug?extid=3D7f94fe3ce0f6613e12b8
> >   https://syzkaller.appspot.com/text?tag=3DCrashReport&x=3D12764a155800=
00
> >   https://syzkaller.appspot.com/text?tag=3DCrashReport&x=3D135309055800=
00
> >
> > Direct reclaim prunes overlayfs dentries, and dropping the overlay inod=
e
> > puts the last reference to an unlinked lower ext4 inode, so
> > ext4_evict_inode() runs its deletion path under PF_MEMALLOC.  My
> > reproducer above does the same: stat files through an overlay on ext4,
> > unlink them in the lower or upper directory, then apply memory pressure=
.
>
> This is an interesting case. When I was writing the patch set I was
> thinking whether unlinked inodes should be marked for deferred reclaim an=
d
> decided for "no" - unlink or file close should be happening from context
> where synchronous ->evict() should be possible (and is desirable!
> Offloading to async context always has these inconvenient questions about
> throttling associated with it and space being freed later than userspace
> expects it etc.). But I didn't think of overlayfs - I assume syzkaller
> unlinked upper layer inode under the overlayfs' hands - which can indeed
> lead to overlayfs dentry being effectively the last holder of inode
> reference and thus responsible for inode deletion.
>
> Inherently it is kind of nasty that overlayfs dentries can be the last
> thing protecting the inode from deletion but at the same time I don't see
> an easy way around it. Amir, maybe you have an idea?
>

No, not really. If you could use the ovl_destroy_inode() to mark the
ext4 inodes for deferred reclaim, but with current design this does not
seem possible.

FYI, I assume the same situation could unfold from dropping an
inode with cachefiles backing inode.

I don't think the issue exists with FUSE passthrough backing inode
at the moment, but I do have a plan for a similar construct of
backing inode that detaches on evict of fuse inode as in overlayfs.

Thanks,
Amir.
overlayfs

