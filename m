Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5562CCA5FC7
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363A36B008A; Wed, 30 Sep 2026 10:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3149B6B0095; Wed, 30 Sep 2026 10:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203786B00A0; Wed, 30 Sep 2026 10:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB2966B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:14:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AAA2407E6
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:14:46 +0000 (UTC)
X-FDA: 85270624572.21.97DFB0C
Received: from mail-qk2-f41.google.com (mail-qk2-f41.google.com [74.125.230.233])
	by imf26.hostedemail.com (Postfix) with ESMTP id 719A5140003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:14:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YDgOTPrX;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.233 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84hi0KLemhvCKROz+CWHoR2XWSCpwJ13uJIUk3gWxUE=;
	b=mU/m+LgP0ngC1DoChGMkj9Ii4O29AbBsodrF0/ZqGKSiveOxnmgBuzydVctufJhPjynrY9
	R05KIHWTFhEzwliBmob4FB07necTEAbIoEv6d+vGbn84RwNk+aBhP9rjirqCJsMiInaCPA
	YhYCbxRoYKl/VYaKgSKFombXESGslIM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YDgOTPrX;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.233 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790777684;
	b=HjY/YdIzQeEH8mx/ekB0zhkzP9TjgBbe2LxeD8FJUwuWPTj6sp5B2S35iN+qQ+4rQ/76TD
	TPuHffRePtWtquJdmRg7L7mGozluID3IbXMDPzpVKhzPBPJOtg0mPgpS9ZKf/bukfMbf+t
	omwrC1NN55wiMrTtMiOEjYuiEU9Ltvo=
Received: by mail-qk2-f41.google.com with SMTP id d75a77b69052e-533245fd18dso35540991cf.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:14:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790777683; cv=none;
        d=google.com; s=arc-20260327;
        b=fn30SZ+cx0uaMhvkd80fwqhlPS0+vlFKZmDjJ6y0lUoY66mWzc+8YsKxJc8vglfGfC
         pSmth8j5RqsYN8jRvNy0X4yHzmObiRl49mDGUwjoRTjjW/EsnAfh54lS1bfyuExGECmb
         h7NvgGqDA4orN3b8PEInk9UEZUcQmV2Ie7057X4VuBrKZF59HkGMAszocrGuDeDI5UWq
         rm/P9SGrJN1F9Ohsn3CHbXl8XK5FI4UuDZy2A45FRbOgj0cEoZPsgYWN7g7lAbjwV7Nw
         ldozfXZ3c1rZBEt9ZTIKa07IlWAHZpetTWceh3vYExTRbE1kx3vu5lJlQDy7QIGuK0me
         wLPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=84hi0KLemhvCKROz+CWHoR2XWSCpwJ13uJIUk3gWxUE=;
        fh=6qmEUuKFGIqmvB4cjbRMpI5hr9bIZj49WumMdP/daUs=;
        b=RmAZECpIDklhjBY+PexSEPU3gIy9YfN5aWJbEOJtSHRyW7WclDoUEXsebFSUtiNIab
         2xHcfbe9kmh7JNUPxTnHouj2YGVSg26ukICUrX+DPwZfozeoGhLH/UluuQw2K4xTkvKd
         WXKtkD4v/0iPEgoW3796BsVNd3+SjqweuIZl1gclXtsK8GMPOiqlVgsCcDqB4+gL4x7W
         1U+KSdBYhn3AOLjurxen0c8LyWNZkpCtd32mphOcS1Do2FIIuTYkigQU0cDhOonxjJ7b
         NlpsxHCvbkb6KRPXzGHlD1rk/Ntos5jPru3C/ZrZ4TaxcQOE+Xd6flQahgI/9vGhOZjo
         Ajzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790777683; x=1791382483; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=84hi0KLemhvCKROz+CWHoR2XWSCpwJ13uJIUk3gWxUE=;
        b=YDgOTPrXya4pcOHIVKmQwSoSL9r/cpJ16t+Tyvyzrr9wVd5mSC6mf6DZRti/ls/4sd
         /60LdpppthBFz6kpA8VWBaOtZSGYVaka5Gzx/UZvYPD4hHZnJomXe8/kBb05ggKCuNEE
         GdFvKpnN4tqVZLGDAvsfoiIm4Zse7/GeGdTkKXkc3Naqv9ZXXGa+S0/zTj2QpR49kg4Z
         cpsSjlJxjL4eT/tWHIuIylrIvwiZNqBP1Kv0DfimwI7BOo2TovUXubH6haS0RhgfI7DX
         0qIWaeP7oSL1ejZydYgf2LMgLiNt38H9/YJ43F1/uZqOkwBooTp6fhXNGWqziU1qX3ap
         LShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777683; x=1791382483;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=84hi0KLemhvCKROz+CWHoR2XWSCpwJ13uJIUk3gWxUE=;
        b=qPd0sl8XVb0r4u5Ym0Pf3PiasayJ8yIStyHjXNNfvZ8/CgOwnq4vRf9x+eyTg33YKa
         l5Vwuqh+/MtSvUm88tyC/QF3omCLySIbfwBJTJdItlFRSytugfFgxKzvv4hZpobsTA5a
         QezIhEH5xq+pcMH6vtFry2lUMogXjIK/eM5FjsJbiWMqaFBY7BNr98EAjkwBGVeKyh04
         qIq/9PtPCTtog5NDPq6kXwmTiflR71HVpunetQ/kjkyghOqjcWLp9mN+7PQ8tYtfIx4d
         jgjqOWuI5CWw/Ez2k1Z3EtUEjRp58JXI+1I6DqHFqn71ds+1jMkSCLr6/Gbzu+uKp82j
         OaQw==
X-Forwarded-Encrypted: i=1; AKwUvBxISQ5cx74kPUIsLNT6VJcYAGIjE78OicAot2m/Jgs5t85K4Y23Z7bFmTPPmMR8GnAqqDAWW470hg==@kvack.org
X-Gm-Message-State: AFuF++myB62zMDw730MTSJYHVz2NuSU1QnqRmy1/cGQZnYqQ22dBO+U2
	utsG7UsyE3HtYeW9pIddU3/TdWBcDdojLh1X6SYMr1wh6oxWYre10wgGrnUiLm7OKd+6sP1+t5Z
	6g7VX4XhHQdtQNfrldqbKlsAMyukdDXk=
X-Gm-Gg: AYBFou2l1p/HvHId8MT1tU010PLUaWY+Zeqejc7JNScNFgi2erFZG95MAkNDzST5Pp9
	VjcYyB+7TO5dgxPcQgcBasra/Mka3jz+kamJ4sHrpwF7NW0PIi6/yCYcWMoB2BWLuyHac90sXcl
	UUSD8RCsl1cjlG5ZQZTDut0e/gQWK53I0hXY4cTWpTfoP/0gOCfcXowmlFCETyghcKP1ahYDwrg
	d8PPaVjKWh03d2IyennUrEz32wqi8406+2L14Dc9TEMPSajTRUaJRP6wllSxOF9oeFjn5FRzBE7
	OObYGym9rwOZrs51v9CNrNE2xRERkWijtDnG8abM2xRjQMC8lWjuBsG6L8AWhWqjkkk57Nb9yez
	btDvGPdJWPoTtTZ9xkmEv5S9+4Fy9I4JKhR8yUw==
X-Received: by 2002:a05:622a:4084:b0:533:33c6:e635 with SMTP id
 d75a77b69052e-53373c75c75mr24641151cf.8.1790777683553; Wed, 30 Sep 2026
 07:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAAE3jtcL_CZJdcattCwe0RraKnHcZO=UknxEUQVG858ouZCUQA@mail.gmail.com>
 <7ebe4591-2306-4b5c-b83e-6a2e34b52bd8@kernel.org> <CAAE3jtfeKJLSypScqRAEEgvO8En5kJfpbcFn5X+LQ2YL+xz_vA@mail.gmail.com>
 <85aff663-2131-47da-ac04-8f0799a49b91@kernel.org> <CAAE3jtcRQ407P9LTbg=JOwhABQRViSaq2XBefnDdNWiD7PxvUg@mail.gmail.com>
 <1ce9cf3a-15dc-4815-ba29-2e22b05206fb@kernel.org> <art8EKRKMdwSDCkr@gremlin>
 <CAAE3jtftxMkCfWJ77W-xvV2x7jdAN8C8kyofYC3fEivM-Cq6UQ@mail.gmail.com>
 <arz0auULA33fqoWu@gremlin> <arz8Plu6J4YOTi0a@gremlin>
In-Reply-To: <arz8Plu6J4YOTi0a@gremlin>
From: =?UTF-8?B?5aSp54u8?= <rockeet@gmail.com>
Date: Wed, 30 Sep 2026 22:14:27 +0800
X-Gm-Features: AclHuK8Ad_V1HG48hhMePSFTDZvGvOl3qgp-ofJZKWzRhJ4s6nwOTixAv4dxy9k
Message-ID: <CAAE3jtcanTUrV3xfofwrvYGCFe5o=Vn7gS66bDzuxzeGg6c5=Q@mail.gmail.com>
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file mappings
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ognh4kdw6kz9hoxq8fq9t5sixnh9f35f
X-Rspamd-Queue-Id: 719A5140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790777684-233431
X-HE-Meta: U2FsdGVkX1/hAJq4MCEQjtH9qsXsS1BKFDVfVKup8yhFa7e72qsO4uUkxnPfI8dHLAIg1kPudWrWEa8VPOM9qNEMxqST+PyOKz8BiaQN4YZzCOAuL+Wxy0c0ns9qD0BjyD/1IvN7tEUdnk8D6HAjFGM0iu/TYc2VZUyneyDW7P8ukaOFfTkI0tzB73eOoqOh3T0TMED+bdvkZtse/2sz6JvEDR0ggvBxJgfEnqnABlBKAEC4b6jJA352qbxXO9hw88f9FH+oSku9bCTXuifYroEJ+wd132tHBEEOBRZkiYtX/hI6HS/vpbE/8tTzHzq2qXmJj2DHKFK4wSQ9edflWNK+yZJIaE44dj9S6WJb/dzJq4g8i7XWmS6/l8nEP/BMLKJXemjVujYrWMZZSSHhwjb+oGbWN8JYqVX35/9ChfJRrGE9q0VGJtEpB6NK7Ko2TH+GZEucvrkMrWP3FNyVSI8++x5ycS880XM09UXDgBHoaZN/iZuyU1XD9Mdau8IhBIT7OauEULjyImkNkTfGip9vlcmk56UPHQmERa7TRAK0XnUJXew+nbHo0GXy4JXyGZeTdbA5vd3qIVzQxi8J3wktcxBfA+6XN9Y0rq4iRIu0zNG7JiGZxmst1yQO+w532PXmEIOP4FsKdH3NKphrui/lCilcXSivFQGEaKZgoPS6YQyPKdGTlf3rWRkNB5gvkopOsUphRlhhrCagiyaXEbgJWneEbILYnWh1StLvOCmjUgWEfDZnZEHodMrDLvB9Goh73AJfAZgIwqsD8L0mCKEPTuw4+B6jLqtOYeLS+5iVBpdyJZJK3lFuepn4CNRyYZofbmNirlGeJRe26oHJGCflhRtesUC+JVbbs+4Xf3RK7BcDcpn6rPnBTC3jEaluWscwvCHh1OLnSwZIB2QFAmGRt6bgbKWPxaGPlprdbFsapIg+4gIHFkWknEMCobRxGQlf3lOuSw9E7seFzU5
 ClgnIW5J
 la74Gcw/V+0Ggw3mgqSVcZ/r2TsYP6BXYMfKjjL5XdxAlqGavj97tiIWTugFlE0pe4sgG5tUdtkTYHOd3Atat0hNbUoIJpxqxlQY4TpKKh/V/RCi4Wt3xUFkIA3NIcyk3IW8IckpnHdfmC6yUHMWFGJV49kYqELZ10rp/L01aJRYaqToxRRP2THRcQ4pJV/taiGNUFtVEMIcoxGvMUJgvGdWFJqiYTX5MF+30tKoeOpkc4mTJfZJY1965LINhZjyEJuylxDvrpmnhAqkR/6/DgGTMeVZFTECcTnFAhvgv4FkmTC6AcoHaKwjsD+Z7azLLMjQeWqVn3kxLUohNLILSC2nMAi5rOg5DwMvnSv1GvCGYDK1qflcaL7oIxF65wjf/QALt4WsgSJ2K5a7gmGI3Pc1nCrAlHqli+T/Z58cKdAm+xxTbA5X8QXzzGKS6Rv5abKNU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David, Lorenzo,

We currently work around this issue by setting the global
vm.dirty_expire_centisecs to 60000.

We have also developed a kernel module as another option. It exposes an
ioctl that takes a file descriptor. For an already-dirty inode, it updates
dirtied_when to the current jiffies and moves the inode to the newest end
of the writeback dirty list, postponing its selection by periodic
writeback. It leaves the dirty state intact and does not remove an inode
from an already-queued flush.

To keep postponing periodic writeback, the application must call this
ioctl continuously at intervals shorter than vm.dirty_expire_centisecs,
expressed in centiseconds. Once the calls stop, the normal expiration
interval applies from the last call.

The key code, with checks and locking omitted, is:

    inode->dirtied_when =3D jiffies;
    if (!(inode->i_state & I_SYNC_QUEUED))
        list_move(&inode->i_io_list, &wb->b_dirty);

However, neither changing a global setting nor maintaining a separate
kernel module is as elegant as having this supported directly in the
kernel.

Thanks,
Peng

Lorenzo Stoakes (ARM) <ljs@kernel.org> =E4=BA=8E2026=E5=B9=B49=E6=9C=8830=
=E6=97=A5=E5=91=A8=E4=B8=89 20:11=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, Sep 30, 2026 at 01:08:33PM +0100, Lorenzo Stoakes (ARM) wrote:
> > I'd say in general the shape of the solution would be something
> > cgroups-ish, but since all of this is global stuff and the knobs are al=
l
> > global I think you need to think about your design a little more.
>
> (Sorry to be clear, this is - if we accepted that this was a kernel issue=
 that
> truly needed something like this - which I do not. The solution here is t=
o use
> shared memory as per below.)
>
> > And in general we've seen a pattern of 'writes to MAP_SHARED, experienc=
es
> > problems' before.
> >
> > And the solution is generally - use something like memfd, have a proces=
s
> > that does writebacks manually for you as you need.
> >
> > So I strongly suggest you do that! :)
> >
> > --
> > Cheers, Lorenzo
>
> --
> Cheers, Lorenzo

