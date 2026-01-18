Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E15DC9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 07:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782476B0005; Sun, 18 Jan 2026 02:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7295B6B0089; Sun, 18 Jan 2026 02:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601E76B008A; Sun, 18 Jan 2026 02:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CF996B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 02:01:59 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA0EFC1D76
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 07:01:58 +0000 (UTC)
X-FDA: 84344189916.16.3B8DEC0
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1F2B1C000C
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 07:01:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IdJBNdYR;
	spf=pass (imf22.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768719717; a=rsa-sha256;
	cv=none;
	b=rpneHmgKdn9wq79S0NtH22pFx//VpKmVZUtdAm0QunPQUZxQS3uI+XyKxexJmsyKNoULWn
	iUO4DnzosOv+VPv8Nz+7w39Dqo4LmW4heH8FUys9oiF/ldCA4iWlXNZ8SBAEW2Q5MqfQ13
	xzrob0Ko9PRbLQNjUqdezWJ6VDI2+mM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IdJBNdYR;
	spf=pass (imf22.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768719717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YnzSPUz1aoS143yFXVx72ftiBt4iAZjMmiuC9ed7P8=;
	b=rIYacGGdCRM9ZlZAMmcjO/uq2gIdqjBhJmd8b6oGFjDqUuACUUs1qxj3IkV2+orsm0MV9N
	ebSC7EaI8dzf4prCdwtJ3FWjjh6M2Ry27JDLQzMAxUsWcHTMei5ZE2qA4MTIgcYWE1ONs6
	m9/aju9rqO79iUnLbdOexHZ891Vtvu8=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-646d9eb45afso2739347d50.2
        for <linux-mm@kvack.org>; Sat, 17 Jan 2026 23:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768719716; x=1769324516; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3YnzSPUz1aoS143yFXVx72ftiBt4iAZjMmiuC9ed7P8=;
        b=IdJBNdYRvhLyEERjREYmQKJHtqLiFCAmgsqgri9vhc+a5vADnV2zCQMYBQ48qw6P51
         Id3390nJK0BDpByt8tuYfvYfgiK/5azNG+5Cfu8FOamUVlGHJOFaO3nOozm9bKkTW882
         w5qc/6wvcq+pJ97uiJTelF1cv9AKPv0v1tKc5UEd8WeB6NrvmJ7oALlys4fz/4GsTs8K
         xImK/K2GJOnHvRQpLtd4YUTLl7/wlpTsYbKPtSAMJvZLagqSTCGNUfwZa+jrEA1nTusK
         6Ie4+m4MHPaLaaHtQb5taS7/qi4yBcStxqf7Ce6m5QtVaBWi7AwWqFg+UT7MHY/WwjG0
         ShkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768719716; x=1769324516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3YnzSPUz1aoS143yFXVx72ftiBt4iAZjMmiuC9ed7P8=;
        b=HMQuSbdRm4s9j7ZUc3+nac/LiybeGc+ZvfVqNfLRiIFIFFh+1qsvao+7XonpbMl7Pt
         p2ghpF86m88GfCy0lD5TpyBHl2YS0wMVuh5QV2AfNQf9cOJigLT3OH80AOvd4w+spqW4
         wpIUwxaRaZID8DaEFG/oFAZGdGXgvaZsx4+KPenjex289ad4Gp0QNYY1bB1IlV77ATpS
         aBfqpkDw0de9CowNTILakVrVTrFb7Dpb2lJcjAK1z8ooluNIxT/IcV85ym8UFlsVW4cO
         X3OxJPnklMNlOJMwBdpS+UGbwOv4xOs+5tv6LbfRnigJKN7XCgqTwRwmvFQv2lTorde+
         arnw==
X-Forwarded-Encrypted: i=1; AJvYcCXIF4EczKn2LKl62rmSEn04H8BaY8jkqhV/cqJeFd3cRyeZWIYQ1wl9Ma/ypUWL8bSB46UgRY1aHg==@kvack.org
X-Gm-Message-State: AOJu0YyShiDgbdiNFu/go+1Qhspw6I3ZRQPKGJcWBlC55/OD3U3WIntE
	1yBpYz41TxouCu8XM9An9zJgHxg1FxUilnTJANBk/8pwGdMmC9zm7ZQTIbfbOqOI3wnZYo6Fnid
	wIMDneEo3z0BkunBrB+E5RMaW99nK6Eo=
X-Gm-Gg: AY/fxX42vUwrv0zI+q7v89Q8yNnjYEBUAHJTjN4MI+UvVXOMtJxQeu1GtV3i5HsgUF9
	jegh0GeaCQPb0xdo8V3oYwV6m4mHwoXQBoBNuaSwzUwcjUfBUpeW2ZO6mgL09PP0Z8WXrOzDVnx
	gu51Eo0XR8Y8cAo+As7lSSww8Pg9Dzdv+htN04+i0anovyJC8sbflfotv8X6NemaMhK03Gc1XrK
	lT8kDpidTq3gf5nQAQZzxWdLG2eG3zJ5YT4z81FmxSxgrEkdO46z7/FEGVWd6S+BoVd/n1BGzwX
	XHyZnR60ZzHf9itBRjCD3P3ndBG4WkhSe0odFwG4NQDoZx6KQaKpJ22xk0cYdVk4+HEJ3+0=
X-Received: by 2002:a05:690e:1651:b0:644:2e5b:4124 with SMTP id
 956f58d0204a3-6491649f516mr5984846d50.25.1768719716078; Sat, 17 Jan 2026
 23:01:56 -0800 (PST)
MIME-Version: 1.0
References: <696b56b1.050a0220.3390f1.0007.GAE@google.com> <20260117165722.6dc25d72fd58254cb89e711b@linux-foundation.org>
 <CADhLXY6ACKeyLrjARTTdfWyrvUdLbtD-wXiQvsvhsbGjwmUqDA@mail.gmail.com>
In-Reply-To: <CADhLXY6ACKeyLrjARTTdfWyrvUdLbtD-wXiQvsvhsbGjwmUqDA@mail.gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sun, 18 Jan 2026 12:31:43 +0530
X-Gm-Features: AZwV_Qg0s-Fmk0LdSiYD_syYS5grst0M2xrOlSOhhy_fgxLE0lSLFhW8_tjzxJs
Message-ID: <CADhLXY7FJqRLjX7X2yJfa0=iDbUAMwhS35cOEExW+qBJWAnt+A@mail.gmail.com>
Subject: Re: [syzbot] [cgroups?] [mm?] WARNING in memcg1_swapout
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Minchan Kim <minchan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1F2B1C000C
X-Stat-Signature: pijef3m1fy6jgtm93bua8umttpdbz9ik
X-Rspam-User: 
X-HE-Tag: 1768719716-976601
X-HE-Meta: U2FsdGVkX1/suJ6U1R9a26XYFTwZgsCwebZZHAbWgJ2q5RlO8O0VODMdUko6UUpHXJV0mfkYTpXdcwx5jeu3KCI2zCeBlPYT3Y4RLckDwTFMdPwVSjsCXSUOwZatWBUDXigkU4+6rMXSQtSuAy1LEBFsLBw/Zarf7TFuX4qk2N0MD6hAUMFrzk/Oh4rytBtHMWbwG0fERFUuF+HXC+7GvDNSQnVpTUEJ+NbGLyJRnDY+si8DnPqSsU9bD8/4wpkWJHg+dCKqJCYcI/xQkH683v5J6kGC+HvUVCalzepz1Ad3i06ayltJ1jkeyHj6fYGvEVllKUBkJmnUUj1R2JGy5hSHF3qQQKapjYOfNouNqIpvzRcBjy1hg3FPnbLXwDc36GdaBraI0uvg1JLIvt204kOLvWkeuLtr34HGdfmq8vJdK1ie4IlShnQiq1f899oi92guiynjwZSvBpRyd8LleyPons8H0BSNOdwZgGSayf8UV4FJOg0b5SCmD/r7LLkBbXWPC+w1hAqsJhqo8AHU4VwQgTE8FtrJErV37+49II0la5ZWshF5oi70K+9wUowoULrNnp+sRgyAgdZ+eh5W9YYOe6RyJ5D+9SM6hrf5mNUcJ0AmHGrSENjZQzOR6sjLRZID/cYiq+c+U19PgxcTBFPPqAqOqS/pEPrV8AedzPKHvAM9cjlqZ9vz0jXryIMVkAj6ngUxkYamIlui2QnWzsVMEHd3Zbmcy/In0rEpMAXEJAYZJCC/9Oj0AnxdJRPUfSLcCDgBidKTy1MvABoXUM+g0LsNARWjVCij0JTs/1Ncy4Fw7i+PspAyZBvEUG0D9jjhkObobHzh60k9J5X/pZIfrQMw1Vv8Pmzl4dRwtJOyRpc5Kc6onl2E3XDhfBhm2fFgQdQOHKx8sRG0b4rWMrsDzKNPx6ZzuzWoHClMO3HpPbDy8IMelstXjcMeUK4kVO27cHPROP9uh4dltMo
 /13sTPjw
 QyLBxIraEpb4fgSB2jIiTMYC65LN7BF+BSA2ahH8tZYRxYn952fSUdHJwyh4rAMY7tWvvLGIEL5HDtWwGwDEhLsiUad7vF3QL3fXZZ80/wMGsSlBQT7hNKt6SVPQJUtcKR8o/6VZ/sUtg3tKNpzSA9LU1UqeubR9s2hwqc6cvBAenv9lqf4rNAx//63qtr0mFjIB9i37szuX+yCeroVYJVAIfd7whzwnPUyEnjiOo6w2qhsj3w8NC11aZDB+DJsC8LUmgUJ18JpJl3ErJSY/s7L8FVtMZfCptKQonqTUyuoyfPL4KmpPn4Q7Z/ldf24ieqQprB7elNJ9EuIAHj37AhRRe6tPdue1WnquCz7f6TcAHG6RreTjEnMl/fyvalfgNW5w/IzTycZ3OTT/Yz4PGkwnpdSkZa88YG6UO825jkHn6vUmx5yqmQkFBc2mt9GEusFv8XpkMqbq7N33jldy84io7psMgs21+5ONFN+RvBd0LsLkFcbttQjKZMTMzg03Li9K4l1nmiDD8xIRUfR3nIOoISK11j3sIRIN1NbLgXl3zONJmX9trV/wuLlmo7boQhKnsWcr37cjoxwS4Uv9AoaKfdu19jb5J9PoPc+f8CCxTzklVbeYzjtHvl1/2c4qWX68LWaD5fBCPjHs05i6tMchg16SitL7yijHZTcahYts3KQE03SmQbsa/fXDZm9PbePYbPoWYt870oMDTD2LsP0zg4rzYBsPhhTNpkCZl8dfhB4DWZs9rH9/dFM1/qQ9HmFRs7n5+ur/RYBKUFviaSxChpJGAkNqSWNu50FsgdIiDQn1bNMd8e6iNfLmBlcf4jv0JpQdUccqAn9ZES1Dbvmrl2YNJMbnxeCslVPDcuFXTemRj/nwmqKmHZ1IdbKcUt6NDVN8Q552gfQZwoFJbYsGijj0J1IXhEovEyg5xs+xuptyL72kALJnmhFtQ4KUqJ76h67icFS7VZa71Mr5dinNtwaTU
 IYHRtmQc
 XRzasgyHV84iV91KxjUhCgGGflFNkCvTsFl6CTChGeDRUMhIQSvSfGmNDRQX05xE3vdk5gZBlwJcXNXye0gblTJWhxiSZDVgsLgfd0YrXfEgWIY5xvZGC/XWdg0zohyALVKaz+gM/Ac=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 9:51=E2=80=AFAM Deepanshu Kartikey
<kartikey406@gmail.com> wrote:
>
> On Sun, Jan 18, 2026 at 6:27=E2=80=AFAM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Sat, 17 Jan 2026 01:30:25 -0800 syzbot <syzbot+079a3b213add54dd18a7@=
syzkaller.appspotmail.com> wrote:
> >
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    0f853ca2a798 Add linux-next specific files for 202601=
13
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D14f7259a5=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8d6e5303d=
96e21b5
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D079a3b213ad=
d54dd18a7
> > > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909=
b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D167ef92=
2580000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16d295fa5=
80000
> > >
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/480cd223f3f6=
/disk-0f853ca2.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/1ca2f0dbb7cc/vm=
linux-0f853ca2.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/60a0fef580=
5b/bzImage-0f853ca2.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> > > Reported-by: syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com
> >
> > Thanks.
> >
> > > ------------[ cut here ]------------
> > > WARNING: mm/memcontrol-v1.c:642 at memcg1_swapout+0x6c2/0x8d0 mm/memc=
ontrol-v1.c:642, CPU#0: syz.4.233/6746
> >
> > That's
> >
> >         VM_WARN_ON_ONCE(oldid !=3D 0);
> >
> > which was added by Deepanshu's "mm/swap_cgroup: fix kernel BUG in
> > swap_cgroup_record".
> >
> > This patch has Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT"),
> > which is six years old.  For some reason it has no cc:stable.
> >
> > Deepanshu's patch has no reviews.
> >
> > So can I please do the memcg maintainer summoning dance here?  We have =
a
> > repeatable BUG happening in mainline Linux.
> >
>
> Hi Andrew,
>
> I checked the git blame output for commit 0f853ca2a798:
>
> Line 763: memcg1_swapout(folio, swap);
> Line 764: __swap_cache_del_folio(ci, folio, swap, shadow);
>                     (d7a7b2f91f36b - Kairui Song, 2026-01-13 02:33:36 +08=
00)
>
> Kairui's reordering patch appears to have been merged on Jan 13.
> The syzbot report is also from Jan 13, likely from earlier in the
> day before the reordering patch was merged.
>
> So this report is from before the fix. The warning should not appear
> in linux-next builds after Jan 13.
>
> Thanks,
>
> Deepanshu

Hi Andrew,

I tested with the latest linux-next in sysbot. It is working fine

Thanks

Deepanshu

