Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70249C79FB6
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 08:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2E76B008C; Sat, 12 Sep 2026 04:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A40C6B0092; Sat, 12 Sep 2026 04:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093596B0093; Sat, 12 Sep 2026 04:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4F376B008C
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:48:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAF461A0487
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:48:39 +0000 (UTC)
X-FDA: 85204484358.23.3B55435
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id E023180003
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:48:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j4o9B888;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789202917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4VBvSxEGrUfJJhcCbVvt54AZ/dw8YbEqxSSPOGIQHY=;
	b=JMA3Nbfo2qB2Cl+qYxIZGFdKijLi7jvTKV9txfMh/KaDsaI+nzNHf8pbz0AW7FBo4VZo7O
	jN/m4izcezRXe0lXUqrcsSNnTd0OV/ILQIa7no9LsZGyOjPGu8bcu0E4a3K7sxmxnku9Az
	L73oBz4I30Zx2eGBruVZAt78ohyf4Oc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789202917;
	b=AelZS0voBfo7q2S0KXiIShlfrc1il8cwYIYB61JtBaI7KfjLXQpcOqTPnoEvPHPyv3vvYt
	mqIXnI3mTUp4dWle9G0gZSIuF/sCfaT2ttD3nXwK6dcG2X4KGiACVkhjq36BJW3hso/e7G
	5JZxpRv/au/wAphKadkFQddeTN5m/6Y=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j4o9B888;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a9cb66f7b4so664312a12.3
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:48:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789202916; cv=none;
        d=google.com; s=arc-20260327;
        b=PZp7BQaKW8kOHI93fsDLqM14b1DsZmKxlKhdtxReMk7cresL21mD6fg77wrA54rG/y
         6EFuq1gXPy91QRRySUSUSS6OLGpiZJ0T/U68a83in9nzNWcyCc38L8e8BT78jmsZMJqw
         h2pbSPtfiUMFDB/5TgkQxQQKy6TKE2AFBd3GpN5XyLX+7SW15X/NBX4cjzt3uodvo/5K
         omg8UTyM1DuWz3YJ9P7qDYG1kxq7FUG1K43nILbKJzVqc5JAOFT0ot1pui2RklJVQtc3
         Dd3DC7SpqVZYGoOiozXDr5+VeSA85RcYDNbj7/gf/T6y/NeQOuMaFNkI94a7XJrFnGxr
         8J9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I4VBvSxEGrUfJJhcCbVvt54AZ/dw8YbEqxSSPOGIQHY=;
        fh=6X33o6bHdpuPF4WXhe+cc3GS+lU3WWF4l+O5TI6pzcw=;
        b=Ygwx+5qugAh1im90Kf7hr6Qn/dh1vPAtFwX/HYlctjqBZM98AvUcQ4hjC9rs1R5zXq
         T6dVc96zcv1BtDxfaJyBSYz0Tl3VLQuLFM/S/eOgHChMBa5S/btA1JhCLzWlguw8+ZdF
         JGDjtz8Q5p8IUeSyxANAy7afMqIzKBmzvIaI/KuFeixjK4PGj8u8mywm/1ZXrm8huIJu
         NzO2ue5J17NNcW6XlajsuKjtxKCnVJ2n7Ymo1hmRvh+JwpvbquQnLehV+JCq68emlKNI
         rNBrNyVw0++87deiCVSr69ji5JVb/yMRmPXhZpvNGWVgrLaCD7FIsisSJUVwU4Y8t7wj
         +ozg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789202916; x=1789807716; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I4VBvSxEGrUfJJhcCbVvt54AZ/dw8YbEqxSSPOGIQHY=;
        b=j4o9B888vwh/li61oEdjnPTowhhQGA9xC7L/dArL2Xi+lVTro8ZTVF3HS+KaSSLAW8
         R8j00qU7Qkuj3gM5E3Zd3bpOuE433JQIlWix/LtYKMgEi/VyXFo+8DmRm0dCWpCewb0m
         bGFpNG/fZFvMRMEncfr9zJg+cftjUTS8JZTQ+DhWgHdDKTGeQnG0NoHXZgszzAwdX0pl
         Kc65wHplgK8XQlG7Vqt+4YaUuU0HKjM/YQ2BGvIRQ+3Zr9wU9lpF+TRcH0kl9i3kG25F
         LnwJ0g2AtHc8A2jrhGhlZBZT7p9v8ao0UEM9V1XJQYysr9SBt16sJucAXruGRGN2jogn
         9akg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789202916; x=1789807716;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I4VBvSxEGrUfJJhcCbVvt54AZ/dw8YbEqxSSPOGIQHY=;
        b=c3WeXAFJZHkwa9GKw3kb+aGi0J4P/Lh7esDI0BUkf5/Bek8YSr8F/k1avFkKyTwn67
         h8+hEW42kS5lAAVwnNCoZ+wiNwrZbWMWiKwD/wVjYnymRDRaHZLNu9cXG17KNJGkCL0c
         bE4fEJ5//jg7K8/v9jIibVNp4dQgghAeSQXw0DXw+5ev+oPPhsXYqAGeOgA9w7PPQNRW
         YKojAp9wi1Mq9rexGTIokvL/R0rUDI8RWerCavoSf1Ts5qrlngMsNkPKWzlmGXbv9gNR
         9wDKfcGjN4L0zjeVCpt6Bc36aEDdfAyFvQJXMPMSObU9kTTMh1rXk1EXkN6sdIjvJcQf
         qVyg==
X-Forwarded-Encrypted: i=1; AKwUvBxX+45KCGzvXnTJdhJ8y9A6SXqsflQIGscm+0kmmuljdjpEqMnZJnDN/HECmSQfOWUleLCQhKjnTQ==@kvack.org
X-Gm-Message-State: AFuF++l00SopyiVOFLyYzisemvDYe8QA6UvFa0QFhEOUeDT8KaRgpJw3
	HLNe2bCshZhaz84R4+X+edZWT3m8zq/rG14mQEE4ijb4yLgd2t9ufy7tWuKqH1NOSxQYg89RInz
	S6mPB93erGMxXFw2Ww2L+v8iSVCTUiZ8=
X-Gm-Gg: AYBFou3q1JlVC4w/XiuSqyEVQqba4XRif1o0TUZH3QyowouulCY301RvvjsSiwT/P+l
	OidmqTsloJO7tCCamzgRyfHXemCynr84xzlbyQsJMpaVxbLKb4kykXP73iZceaXO6Z+9XiibJhX
	k2BiqKENn66DuHQ2L46i6HzNLN4pZs9K+VrIjv2FwioKH1Ed7qf5B3EG7TuqEeb1ePyR5PmhMci
	0ktR03IgOMwCholmHr2xfwyxRhhqm6St3ejYRKvBMLEnQ8ozQRwGFSDx028D+uXzL038RqU4Azn
	2MONyqmtOfwGyX9GzzGFm7CckIT/b1QnBAxs+9ElVX6r1YXfzBVCAehT25ihRPiasw3MaL/hh/Y
	pKWejd9ZK3WajAg==
X-Received: by 2002:a05:6402:354a:b0:6a9:93c0:113e with SMTP id
 4fb4d7f45d1cf-6a9b5603d6cmr3580548a12.9.1789202916079; Sat, 12 Sep 2026
 01:48:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <CAKEwX=O8i+OsP6BJXNZNk07hveN9HDT+PoyMTAU6gOc-xp0Ppg@mail.gmail.com>
 <CAMgjq7BQeQQOZMDPFJ+8LS2N4t3x53r6Nm+9o0_pi92oVUgjgQ@mail.gmail.com>
 <CAKEwX=MS-7C96i4tzBijHN=-xuZgny_wQEa_0YjfHzhoNysdYQ@mail.gmail.com>
 <CAMgjq7B7Mc7vpQN0gBknsSrfZWXdif5L7nU29YskG9mzS-_jsA@mail.gmail.com> <CAKEwX=PxZ68_4240DC8HjcqPRE0bQWGmouoqapqqTQ2b0xqpvg@mail.gmail.com>
In-Reply-To: <CAKEwX=PxZ68_4240DC8HjcqPRE0bQWGmouoqapqqTQ2b0xqpvg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 12 Sep 2026 16:47:59 +0800
X-Gm-Features: AcwNN1Vvr5dRguutvcgehjz-XZkuALg4SjwQULHioJZ7yEPwdeM7nc8UPMPMn9E
Message-ID: <CAMgjq7D40KGRjwpFMH4x4fhJ18OQyZwPtovhc8Hm3Y7+__d4Lw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3fxercgzqbcr8e6n1zz6e5ua3uehcqa6
X-Rspam-User: 
X-Rspamd-Queue-Id: E023180003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789202917-717995
X-HE-Meta: U2FsdGVkX1/O/SzWSajANp+nZ3E+lSM4dCqvAbIAVs6d2xrroi4DZWDC5R+o+AgIMe6zO+X7y07huF09dP5O8XLF54tHVzoHSszhI0CaOWkgqPa13V6CAhKsvK9Z+7L5F0vLA7cH9QoIibMfwnQBNnzxRmdGisQnDqVSu/mVAkWXnNx3Uwid+1GrtbznXAn0gu8FgujZIiRBF0OKTkn5J5XwyWCBdedkJfRRjn1d7h1wcx2FvJRzv+ClxkcTLX23zKctAz+vqLyvLHnmyUhzQkkM0OPlOROZVtFH+LK4siPgDsl39xsSq9y6Ry3SKo9mMXyo8cocZFaTY9zEpQVC8yAutrHjSEqn9Hicy6UNmjuSds16Gwt44ylcaZVtckXSS5qXrEuOxLQ4UmauueMRTpeFxY6BMG5v8sVfjytlA+rTTw2Ndk5bcDj7FJ72xzRSzqX+llAV6M1fdj0hSQ/rYbLo4XwQSbjHF1qdEGahdQ+Z7/qSIVMRtO+cgQGyMMYHaSk7Y+Id0N4X7LNUZl1gFWTuUO3xKG2cUh+TO/aQY0QqNz9d7FQNHQ0IjxirwPpg4i5hdQVGZw8kBNav6OLycFtnHtA5QGOIKPyRp1X59sDW3bXn+pB9gcZa4RZx2KmcxfL5gCVY6/aJKaN4/XiApGXBm3hSER8gkaZPU4ZF02ePT//C+kDV1fC4Tgh7Zop0r+LD1SYk503Kk9PbEIIJIQotKX2puUaZYMiAjtDqod1tsndhQSRUJo3lM924hAqxeenrwfBmhiWIwE0MGM6zZ25weef9CMu6GmTtAj/0xNpAzAao8DmuLNB2XWeA7E16otMxk4JxX9OapenJJ/LcwE+v36c8oQpDni4PNZwMQfSuQYyskKjA7l3baaJL5vWCAXJlaESy3Anmk19WoE79/4ykK8KqbSuBqHKZP4zqiRVwCNHtPZ5xvQSFqZgNeMjMC6JmAMsDzK3/OuJJQlg
 0g/multC
 kXV5vDsnk/nLmgFpATBnsNuvQ18V2jvjC460viLZsvsbkNad5DuyCjjzIlubWzsKxYH9v97fQFVET9rGdjf/vAvUmvkiHKkxu8F9TUXKyRHBw4KKUJbb7f6XQdURnJ/YJPzGMoTu2rqPXNz88yjbQnnEtNmzSdGZDs1B0NjvIWiErYXP4KlsV67cca2Qr0paTCMIMV8W5zSyhCDg+jrAxttZFST6g0daDqkZX0o2veY3qdIdZskFL/nJNVwdK28RJykeCuMU3lZ/WI6IeeRYuA0v9QAlSzFlKIi3hZSOM9Oa/Vc1KrH4iaiiPXTLlNq0tVOR0A1cV5miWTJAh8167vYs1ai18Myqateg8amoxoGZ1Giu4E1kh+KudULvPpkUUhACfZ8y+Lf0C62dmTLz00/j9iwVuLI6tfznl/hFr+RbxKKqnO1feBidlK66kvcebgql4hIlpsr9jZVvERDcWnHVDnBta0ZARBS16GYzijOXwKBpP+E2PJOWZ3qn3U3CDiM5KEIYD7z9l38w1xp/6PuKW+B39hWNenwMc1MeoEn/RBSm7m68r6F9oqaJAqEIt14c8PWTYOG6GueU8r3EDniUIGPlbDr3VBcca
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 3:04=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Fri, Sep 11, 2026 at 11:14=E2=80=AFAM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > > Would something like this fix it for you? ZRAM users will not get
> > > vswap indirection overhead at all, because it would bypass vswap :)
> > > Down the line we can revisit this decision - for e.g, if there is a
> > > use case for vswap-on-top-of-swapfile. There might be other interface
> > > that makes more sense.
> >
> > Hmm, this interface looks confusing though. you mean tangles vswap
> > with zswap through the cgroup's zswap limit? I originally expected
> > this to be a problem solved by tiering, skipping certain tiers seems
> > much more intuitive. Maybe Youngjun have some idea here?
>
> It wouldn't be confusing if this is something users don't have to
> think about at all :) My point is that we don't have a use case where
> we need userspace input on vswap-enablement on a per-cgroup basis yet,

Ha, you really can't assume that for everyone :), we even have
workloads working at different compression levels, and the tiering
series shows different cgroups working on different devices, there has
been pathes enabling per-cgroup swap device a decade ago.

> > > Potentially, but we have many users at Meta. There's a huge diversity
> > > of machine types, workingset size, access patterns (both frequency an=
d
> > > file:anon split), compressibility, etc.
> >
> > You can just set the number as 8PB? :)
>
> Sure, but with the vmalloc-array approach, there is more metadata
> overhead even if we have not allocated the backing page of the
> clusters yet. This will be annoying on the smaller size machines
> (O(dozen of GB)) to also pay the overhead of 8PB-swap space metadata
> reservation.

Not al all? With VM_SPARSE, you literally have zero overhead, unless
you really use these slots.

And even if you really use these slots, the overhead in both CPU and
memory is lower than Xarray, if I did the math right. I just ran a
quick test with Baoquan's Xswap, forcing it to start with 8PB on boot;
it was smooth as batter on a 1GB box and still worked fine after heavy
anon memory pressure.

See below (8PB xswap device with almost no metadata overhead, the only
overhead comes from zswap so I reduced the tree number but that can be
easily merged into clusters as we discussed before):

### Before XSWAP
# free -m
               total        used        free      shared  buff/cache   avai=
lable
Mem:            1464         405         756           1         544       =
 1058
Swap:              0           0           0

### Create a XSWAP device, I hardcoded the max size in code to 8PB,
### and use fewer ZSWAP trees:
# echo 0 > /sys/kernel/mm/xswap/create
[  140.289280] xswap: adding extendable swap type 0 (prio -1, init 733
clusters =3D 375295 pages, max 2199023255552 pages)
# free -m
               total        used        free      shared  buff/cache   avai=
lable
Mem:            1464         407         755           1         545       =
 1057
Swap:           1465           0        1465

### Lift the ceiling to 8PB:
# echo 4294967296 > /sys/kernel/debug/xswap/type0_cluster_limit
# free -m
               total        used        free      shared  buff/cache   avai=
lable
Mem:            1464         403         756           1         547       =
 1060
Swap:     8589934591           0  8589934591

### Run memhog:
# time memhog 12G
...
________________________________________________________
Executed in    4.36 secs    fish           external
   usr time    0.46 secs    0.00 millis    0.46 secs
   sys time    3.77 secs    3.80 millis    3.76 secs

### After memhog:
# free -m
               total        used        free      shared  buff/cache   avai=
lable
Mem:            1464         336        1136           0         222       =
 1127
Swap:     8589934591          31  8589934560

The only different from vswap now is that you just hides everything :)
(writeback is not hard to add)

> https://lore.kernel.org/all/CAKEwX=3DNYoMH8pTKeCvA=3DXHFmmNVMeDz3mxbhp5q6=
-PxSTJ5wOg@mail.gmail.com/

Right I saw that, but 64 bit of private id will make shadows really
awkward, not for SWAP but for file folios and file mappings, swap
table is actully fine since memcg_table is standaone, and we can
workaround the hieratical refault distance issue in other ways (e.g.
record the reclaim level instead of memcgid direct). I think 24 bit is
good for now? As I've never see anyone ran into issues
with even 16 bits in production.

