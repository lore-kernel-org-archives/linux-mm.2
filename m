Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CFEBE8B389
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 02:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ABC96B0088; Tue,  3 Feb 2026 21:07:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858A96B0089; Tue,  3 Feb 2026 21:07:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D636B008A; Tue,  3 Feb 2026 21:07:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3C66B0088
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 21:07:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2691D160677
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:07:18 +0000 (UTC)
X-FDA: 84405136956.09.B21C0B0
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2E105C0012
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:07:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JQhs1JCx;
	spf=pass (imf22.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770170836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3XKctSvXGgVpW/lX1QkUiLVHuzybB4KcosEl9SXxcg=;
	b=gwPt5XW55qVtv6doJxdneMsI0ag41x4ejIu/YYZvuYMUUr+uxWaB2xG0+7lyptJZd4Kqbe
	6sZc63C8f87HgH4uhehi45fG20Ns8oxoQjzjxVEP8PE9v52UT5yjTd6SoSzLevtG/76grZ
	247CQ9iEyqccW3NabKOyeKqjT4/ZOIM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JQhs1JCx;
	spf=pass (imf22.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770170836; a=rsa-sha256;
	cv=pass;
	b=ygLOg2ezr4VEcP2YODCqhwgd5aYQLc19G/UepFiluokpjPyPQI/wQzGtYTFJPWJ9/9s4gQ
	IDqcLC322QHSaRh5/ol/HzJDGtfM3ebPnxZheGmzUb6ZqQrqWJrS0sjCZ6OMnRIf0urCop
	aex+wZU1ybjrvjOEMZzNn6xzVhogarQ=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8c5386f1c9fso856952185a.1
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 18:07:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770170835; cv=none;
        d=google.com; s=arc-20240605;
        b=Bz2YrctULUn3fe1rreORR9tBYgrQ/IYKaBJc+mfHEbDBIWgidlFiHXI100FPKjwBwL
         gBRgsQzNz2WBX72VUknquOcEIB0i5E0G4m2HwwEmVJv0i33UTh5fth8sT+bunFhs1+39
         SXWNNCwdYk89amifP/TTYuN8KXfWswMY/73wauEK5f0dQwbh3SaW7gByykJT1iDOnucB
         A4Ot5ps6ci6Uh6zDzhp2KMjKFh3tl09zhVRScFsWwoV2L3BR6NTXYm9V6BCYnhX86mSw
         H/vNa1Hj0/urrcNZPGniHBS1lw1K0F/KN4Xsb6wXgkVNL2h+aW8kgvcvMhFEfkvNvjDm
         YwTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P3XKctSvXGgVpW/lX1QkUiLVHuzybB4KcosEl9SXxcg=;
        fh=wxsvq6FMgmxZq2NThXEarPuzvQxca4QRebrQQssydtw=;
        b=VwEYyvuU7E36jkPXgQuDW0MQwfVkpmYkTy4z6qZIE8wLuhM7OqFBw/6mtnJW7uGMI9
         KG3LtVPxyRKbZwL0dJMqTXAdgGRlMyOwAmYoGquCvXfgl4aSXvPy9J0+wRNLdk/PoQ3Y
         p382/Cu4oP+TV2yW1/4G0wd6MUCx/9sdxcBMfTQnWyHpM56IE6IKzRJ/9OZXkSt4eNSY
         JflO2rAVLz+jgIs29pmFApXy/cQcgf9ATxvvN7NjiATmxva2NVz3z0kM/kb3RNXDkAwC
         p0MEv1MgyA6s6k3Gj7E7T7K/K0SgqBHBU0YZ63T7qef8NwdtmMPUDMQKIZnWq8JLnhUv
         H85w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770170835; x=1770775635; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P3XKctSvXGgVpW/lX1QkUiLVHuzybB4KcosEl9SXxcg=;
        b=JQhs1JCx1uI6MjN0E1KXBVJmO+FPbZ0WmUSMVzyysSX5rJyTWGik9PiWgMaK8jaFa0
         C5CTyvKlugPF0wa5yr2MXSMyCJN9ciZnAZdPZFpEZ72F3EagQsVdLz19jD+oiu+QDyFr
         JW99HOEJlDNSYQcqPeNUebCIObhCHfHgdDq78ZWZJ88bCHUx1ZIaHU2ZH0D5GWU1x6Pb
         EqR34Xvefpzcl+H9RgXH36SMX32OXPxUTHvBpQajPuiR9v7kjkfuDz1xCeo4WTjBCOu9
         lwbQOODpqT64SRoDSKDwjU1SDHbucXGyF29Vri1YpvPx4mgbAhkAU1Bs634tvgBx8n1C
         iK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770170835; x=1770775635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P3XKctSvXGgVpW/lX1QkUiLVHuzybB4KcosEl9SXxcg=;
        b=Ah96Y1nReuaddieUo8qoF4nRaVEUXtNFzN2z333t6W1kbbPB3vptfA5y8XrIdmyH4Z
         hmno2kfWZZ/nE95+SSwxibed9i/NDQcaif3N0vZdOXgKpT1TAvjmjFIzPpVIsPK9U6vp
         3E/8DIRgWz4FREzAK2/kxg/VdG9Fln2EnJR0XLj5UXA7mI25dEnpsLg4AT72X1MbPs0c
         4ptGc+lbKmcd7H5YgXDmmhKpgQvErWh6xoKPUf0s0N7YsSvosFctgg6Qyp+eDw4N5XSq
         CBXCdj6uxQR+pBhKRREvqGGWtfDQSsZHtqj/+alJ/fI7Flk4FymbkGpRThXRxYo+Oox6
         JYbw==
X-Forwarded-Encrypted: i=1; AJvYcCWj1sffYQ/IoEd3anuTMFyG1nWDeBhvQxf01fDM7/fraFrzsKnRyWnRO+nqRTH0DDcrmsGjEf7RUQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8uosKpC0p8pOBO3ig+AzkgxMppHt8/3AGOfyYENYsSIku3aBH
	JVRwEyEArSbeyRJ9FtJLMnVP1m/DRZPyG1Vajt2XXl9hOHqZMN/yx6cj5wK8KEm6o9P3T/iab/A
	TJw/YGwAS6uv8OqASXO1XqntUwYppFcQ=
X-Gm-Gg: AZuq6aKVgw5BXbhjBLcNRdfuxhSgTaZ9Q2ameahhsX/R0tdfh2SW/BirpiXzvfDnAqF
	8pXtPWnNDNAt5DM7TmwJAx4mwk1jytmiXXqXZi3o0eU3EyP03u5UCrldO6qyfcEXFuHEDw+VqG2
	Tli74Yeel7vL7sd19pewlkyZW1FIn6dWIr76wIjOUp7wI8NgnH2EkdyKv+wv1k/SKQ8ptcuMPxL
	RR+gRt69qRmHMAwNflNJ3SwzJZmWOVurg7bGyZvMzjZ/IqMfjJI++fEtxNkrP8uVsNUg2/pXkV1
	MJMnChVNeciMFMtMD/Zcp4A=
X-Received: by 2002:a05:620a:288e:b0:8ca:2cfa:822e with SMTP id
 af79cd13be357-8ca2f9f5b94mr235535285a.70.1770170835165; Tue, 03 Feb 2026
 18:07:15 -0800 (PST)
MIME-Version: 1.0
References: <CAC5umygEq6xvpDFnVnDLYLyqJV7qChEsJ_+W-KCBJ+EXj1948g@mail.gmail.com>
 <20260127220003.3993576-1-joshua.hahnjy@gmail.com> <CAC5umyhqbW_qXaApO8OGg1wo706GfVPuak5JwdBfBgS751Ka5Q@mail.gmail.com>
 <aYCiboGiXO2lQC0W@tiehlicka>
In-Reply-To: <aYCiboGiXO2lQC0W@tiehlicka>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 4 Feb 2026 11:07:03 +0900
X-Gm-Features: AZwV_Qh72QJTI4M2CEIA0M9FqVyxcZFhJhrBbyaUc7tMrpfUO9BLxMEmywo9FJo
Message-ID: <CAC5umygW8PXnS5tix-DfujhPjrRjBaEKe8ojW=y5FmqhqBfurg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
To: Michal Hocko <mhocko@suse.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, david@kernel.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, ziy@nvidia.com, 
	matthew.brost@intel.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	bingjiao@google.com, jonathan.cameron@huawei.com, 
	pratyush.brahma@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2E105C0012
X-Stat-Signature: ytu4j15rjgtc3xmy1redgpzakj8z9o1t
X-Rspam-User: 
X-HE-Tag: 1770170836-435103
X-HE-Meta: U2FsdGVkX1/wC8ruQXJv9BSbxIs4iJsZKoIKOpl4y8gis8N6DcRLd6gNj2aMsxmf/BYyYr88OxqcI7mhSgxVDJfFygDyfDcgU2jAK+cn+Cd2MbR2GdMKptucTCydYp3QhP5rh6rHCg8qcMBYztnNgetqnFYVUt+t16ptKSQj43Doq8rTklcZFnt8kRmPkRMz+fvg+Hh88VjSNq1VkUADAQPYlB24CdQ35b4NDXT7edTYbd36WJpWsRYJqtoViVDLhaDIgdHRUlVJrieBpGOHuv8Odl2GwOToNbvYVpHtBOGs2ncdw01ihfcdQ6lyt5fQPk5rpBv7bxVWBKGkfMgl36zQDzTpCHYgyKDpkJSuTd3rmbCVPm7mqZg00+9tYhLgPyohMGi4EiXRY9aJXmWVMvE61Ugc/SDRD7vgqJlGMDC08xPqtC0QeJp6CuRtud/Iux3HHwzLv97tejKJj1U2IX3uRuPX2I+v1Glzp8rCdwPL9AaCAQ5NYmwV7Q0kNgwTJLO+S0V94i2JCuer3ETRhZFSsYzun6FRJMB+SkfguCvKKhXKttObPOyc7Sg8ipIzYi9Cezsmqyd19H2acNGFAxMq0tLkTMXqosKbON3aiT0oRr6bPqViiC5eKFIyhZBgJ8mIvp5MNiyAtOVv9sFlYq6Qjo9B03hjbr9IjlRnae+3Hn/+DILaKzOrQqBpQEYX90A1Nh06QHtfLGlWFR/OB8s/ssm+q3J3UI1ENPyygJUJJVmJlXrqLvu2mzpLmvYSJtjFU9UZb1SBeBqr3IoeZ8VdW4w1KVRZ8syskWqf+XAoIP5FNBgY4KZzxhbGupSDz4dg3xknflzFAE4aaWIS+ha7zAroGUMEj8vJWY8OZcnYts6+OR8QX66YeLn1hE6h/zsL0vePGJIQUmBqTLI49xGdtdq1eEpvNhv7uV/RUqHndrG2CAS859pFhRkIHtloAOY8VYcGcamwuQbzBuk
 uo/8J4dq
 gc9Nfxs6Ob17cQMAXT6gFCE6XZRoLpplWS4JPubLVqTKfTD8giUmOHRN2sFnXNzhJ6Bn6m0M12+2lBZkIgNGoGGcDDDgpzpeTAUXRaUuFYT1+Sx6WgQiD/Sq/KkqJTPIUhiqqjaIC2IcUXlInk65apE1HmsbZAemVEOom1BpbXtUdNnBoLQDZstGJHEW5koL3JhPcV+d/QFHuSuaHZSCKQz7EshUsLOZA13AgJjpHcr2gjwFON/HSESDzXR97qRoFtNzJSS7qq/4FUfXHc9UVVrEtOXDDb4U1TL+BmazQMukqQLxjtaR6ViJyCJCv2lKfXNQTzw1QpcuVB8c4cCs8BW1eoGiLUNEe6BVl9LwD+1ZZYbbmXXCQZYZjMGUhebfKL2BSGhna1H9smiDkL8Q4oEauX3fZklvPHhgciA35xj8NdCjZ8pbLREAlUssIbOf4/bsw0OkDKXpMCBS51tqkIyupDBidqa3YnJXMBjjabrDqejZhBPDX+eFJB8FK0/L5Bq06LOkvYiSJtgBcCXjd2kC+7ae9xQKuvSZ6ND96HeL6lB65tWZCkKP7js1ox7RPWL8QC5FLwAc4MMSmh3HAY69MG0PNNqOeivszDf5ux4l8ezg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B42=E6=9C=882=E6=97=A5(=E6=9C=88) 22:11 Michal Hocko <mhocko@sus=
e.com>:
>
> On Thu 29-01-26 09:40:17, Akinobu Mita wrote:
> > 2026=E5=B9=B41=E6=9C=8828=E6=97=A5(=E6=B0=B4) 7:00 Joshua Hahn <joshua.=
hahnjy@gmail.com>:
> > >
> > > > > > Therefore, it appears that the behavior of get_swappiness() is =
important
> > > > > > in this issue.
> > > > >
> > > > > This is quite mysterious.
> > > > >
> > > > > Especially because get_swappiness() is an MGLRU exclusive functio=
n, I find
> > > > > it quite strange that the issue you mention above occurs regardle=
ss of whether
> > > > > MGLRU is enabled or disabled. With MGLRU disabled, did you see th=
e same hangs
> > > > > as before? Were these hangs similarly fixed by modifying the call=
site in
> > > > > get_swappiness?
> > > >
> > > > Good point.
> > > > When MGLRU is disabled, changing only the behavior of can_demote()
> > > > called by get_swappiness() did not solve the problem.
> > > >
> > > > Instead, the problem was avoided by changing only the behavior of
> > > > can_demote() called by can_reclaim_anon_page(), without changing th=
e
> > > > behavior of can_demote() called from other places.
> > > >
> > > > > On a separate note, I feel a bit uncomfortable for making this th=
e default
> > > > > setting, regardless of whether there is swap space or not. Just a=
s it is
> > > > > easy to create a degenerate scenario where all memory is unreclai=
mable
> > > > > and the system starts going into (wasteful) reclaim on the lower =
tiers,
> > > > > it is equally easy to create a scenario where all memory is very =
easily
> > > > > reclaimable (say, clean pagecache) and we OOM without making any =
attempt to
> > > > > free up memory on the lower tiers.
> > > > >
> > > > > Reality is likely somewhere in between. And from my perspective, =
as long as
> > > > > we have some amount of easily reclaimable memory, I don't think i=
mmediately
> > > > > OOMing will be helpful for the system (and even if none of the me=
mory is
> > > > > easily reclaimable, we should still try doing something before ki=
lling).
> > > > >
> > > > > > > > The reason for this issue is that memory allocations do not=
 directly
> > > > > > > > trigger the oom-killer, assuming that if the target node ha=
s an underlying
> > > > > > > > memory tier, it can always be reclaimed by demotion.
> > > > >
> > > > > This patch enforces that the opposite of this assumption is true;=
 that even
> > > > > if a target node has an underlying memory tier, it can never be r=
eclaimed by
> > > > > demotion.
> > > > >
> > > > > Certainly for systems with swap and some compression methods (z{r=
am, swap}),
> > > > > this new enforcement could be harmful to the system. What do you =
think?
> > > >
> > > > Thank you for the detailed explanation.
> > > >
> > > > I understand the concern regarding the current patch, which only
> > > > checks the free memory of the demotion target node.
> > > > I will explore a solution.
> > >
> > > Hello Akinobu, I hope you had a great weekend!
> > >
> > > I noticed something that I thought was worth flagging. It seems like =
the
> > > primary addition of this patch, which is to check for zone_watermark_=
ok
> > > across the zones, is already a part of should_reclaim_retry():
> > >
> > >     /*
> > >      * Keep reclaiming pages while there is a chance this will lead
> > >      * somewhere.  If none of the target zones can satisfy our alloca=
tion
> > >      * request even if all reclaimable pages are considered then we a=
re
> > >      * screwed and have to go OOM.
> > >      */
> > >     for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
> > >                 ac->highest_zoneidx, ac->nodemask) {
> > >
> > >         [...snip...]
> > >
> > >         /*
> > >          * Would the allocation succeed if we reclaimed all
> > >          * reclaimable pages?
> > >          */
> > >         wmark =3D __zone_watermark_ok(zone, order, min_wmark,
> > >                 ac->highest_zoneidx, alloc_flags, available);
> > >
> > >         if (wmark) {
> > >             ret =3D true;
> > >             break;
> > >         }
> > >     }
> > >
> > > ... which is called in __alloc_pages_slowpath. I wonder why we don't =
already
> > > hit this. It seems to do the same thing your patch is doing?
> >
> > I checked the number of calls and the time spent for several functions
> > called by __alloc_pages_slowpath(), and found that time is spent in
> > __alloc_pages_direct_reclaim() before reaching the first should_reclaim=
_retry().
> >
> > After a few minutes have passed and the debug code that automatically
> > resets numa_demotion_enabled to false is executed, it appears that
> > __alloc_pages_direct_reclaim() immediately exits.
>
> First of all is this MGLRU or traditional reclaim? Or both?

The behavior is almost the same whether MGLRU is enabled or not.
However, one difference is that __alloc_pages_direct_reclaim() may be
called multiple times when __alloc_pages_slowpath() is called, and
should_reclaim_retry() also returns true several times.

This is probably because the watermark check in should_reclaim_retry()
considers not only NR_FREE_PAGES but also NR_ZONE_INACTIVE_ANON and
NR_ZONE_ACTIVE_ANON as potential free memory. (zone_reclaimable_pages())

The following is the increment of stats in /proc/vmstat from the start
of the reproduction test until the problem occurred and
numa_demotion_enabled was automatically reset by the debug code and
OOM occurred a few minutes later:

workingset_nodes 578
workingset_refault_anon 5054381
workingset_refault_file 41502
workingset_activate_anon 3003283
workingset_activate_file 33232
workingset_restore_anon 2556549
workingset_restore_file 27139
workingset_nodereclaim 3472
pgdemote_kswapd 121684
pgdemote_direct 23977
pgdemote_khugepaged 0
pgdemote_proactive 0
pgsteal_kswapd 3480404
pgsteal_direct 2602011
pgsteal_khugepaged 74
pgsteal_proactive 0
pgscan_kswapd 93334262
pgscan_direct 227649302
pgscan_khugepaged 1232161
pgscan_proactive 0
pgscan_direct_throttle 18
pgscan_anon 320480379
pgscan_file 1735346
pgsteal_anon 5828270
pgsteal_file 254219

> Then another thing I've noticed only now. There seems to be a layering
> discrepancy (for traditional LRU reclaim) when get_scan_count which
> controls the to-be-reclaimed lrus always relies on can_reclaim_anon_pages
> while down the reclaim path shrink_folio_list tries to be more clever
> and avoid demotion if it turns out to be inefficient.
>
> I wouldn't be surprised if get_scan_count predominantly (or even
> exclusively) scanned anon LRUs only while increasing the reclaim
> priority  (so essentially just checked all anon pages on the LRU list)
> before concluding that it makes no sense. This can take quite some time
> and in the worst case you could be recycling couple of page cache pages
> remaining on the list to make small but sufficient progress to loop
> around.
>
> So I think the first step is to make the demotion behavior consistent.
> If demotion fails then it would probably makes sense to set sc->no_demoti=
on
> so that get_scan_count can learn from the reclaim feedback that
> anonymous pages are not a good reclaim target in this situation. But the
> whole reclaim path needs a careful review I am afraid.

If migrate_pages() in demote_folio_list() detects that it cannot
migrate any folios and all calls to alloc_demote_folio() also fail
(this is made possible by adding a few fields to migration_target_control),
it sets sc->no_demotion to true, which also resolves the issue.

        migrate_pages(demote_folios, alloc_demote_folio, NULL,
                      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
                      &nr_succeeded);
        if (!nr_succeeded && mtc.nr_alloc_tried > 0 &&
                        (mtc.nr_alloc_tried =3D=3D mtc.nr_alloc_failed)) {
                sc->no_demotion =3D 1;
        }

