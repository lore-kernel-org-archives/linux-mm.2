Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB886D46C01
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 00:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5928B6B0088; Wed, 28 Jan 2026 19:40:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550DA6B0089; Wed, 28 Jan 2026 19:40:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4606D6B008A; Wed, 28 Jan 2026 19:40:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3682D6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:40:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2E4113B5FF
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:40:31 +0000 (UTC)
X-FDA: 84383145462.14.231F22B
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id D2ADC14000A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 00:40:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lNzmZ5VI;
	spf=pass (imf09.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769647229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwNqkQIHtdixZxJdXARWDpGYyi08Np4wXzrAxbn40Ig=;
	b=IRt9JLWApfUhJXogsDk1TCLHIIcAJGw/ykG1oG6sZjwGdviItH/qSQNMs8GVb7FeLDfY7L
	ba7jvVzKTDWyB4758R6SfAdbcPkKRAC4SY3xvNZJ19iFAag0conb11GSa4oO04bbOzTlDy
	npv6ql/TrTA21Y7Gj1HmkD44dNHUsa0=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lNzmZ5VI;
	spf=pass (imf09.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769647229; a=rsa-sha256;
	cv=pass;
	b=slfzyDIGqX4TVwjWQnOdJ3za0wceApSDvd7UehPwKet2nD4xFqpgeAfUhQ7lj/TKPrA5SB
	baXQoKhihR9qPnPoOtJ05LL3tTQ2mK6R37k9HsvsYwfzTl6at3W0TSyhy1tvRvcsHuuUYt
	/33/cTYptnpqVYHARsCsJkC267zKzaU=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-503bf474fdfso2536731cf.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:40:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769647229; cv=none;
        d=google.com; s=arc-20240605;
        b=GoUlNjwyHrVE49X0HyX49HBqD0DjXitiyknYId6tw87MptX+zB/9DITudFR1O/xrOa
         9AAVvcA/M2mqZZlt3UKHRJQgGGbhAL7VfIgCwEOWdo/KixcvI/ll/zu7mfysYhnQhJFO
         3zdnKS54tCldOWtap7ClXS+ekNf5/qH7pRoHTw1oHTmjEBYUvptKlNbeCXuynDcsIxIn
         xbRS+9nin22KJNeto/MQ9Ry4KwRzqCTkxaPLbQeGbisujBVUh01zKcXaSYcRTkrMAxgw
         UINEynwk3itikGY1UvxipkLWXeX6+g5NjzUAEsJjJMQsaFROwR4+hjWMISfzJtIZl4nF
         kg+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mwNqkQIHtdixZxJdXARWDpGYyi08Np4wXzrAxbn40Ig=;
        fh=zy4Abhrsk2OWYGiu15Ios8Mb6E97+b4AoPkb1c6f91U=;
        b=Saq8puLz3V08cRthLRnDRLCGUnnnrw3+Bj7ywdcTSaNOeDa6kbCC3EqJVKiuASEPFQ
         vAfclBhH1pEJ86oscV8Nc4pvqWpi6EslU7wc2RaVxwHAAlFq0hwP8WGQUXspnmqtGIPc
         19u2LyqKVKE59kgmFeyDfetft+Sat0/kjmfS6UfyFt33c9cRPjgJdo7CsIQWYnJmOIku
         d2T8ACe8EVe8q4+w6ERV0OVWK+L0xUU3aL6vMV7sVjX7lpgfHucvv+nwG1wM4vpEQRgI
         uk1QjfHO2u2r/wRr6TjqPOTNb8W5RC+o14VBavZo/LmoMPT0Em6y9COla1yGp4YS3jlI
         Pp2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769647229; x=1770252029; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mwNqkQIHtdixZxJdXARWDpGYyi08Np4wXzrAxbn40Ig=;
        b=lNzmZ5VIFyYDPwq67uzOJVeBbwxpdQY/AgyEwVz0DlwG/Cey6i6fSIUTye6+7/XL5g
         D5t1UvdenoQiTyITRMxqHK0hG1u0dpp+gBH+gpxK7ipbuv9xvdztbLR2ZEur/l5fIVKw
         1y6xAqM8dhXqKzOdBfyzJ4nutE9MvbNN8JxSmeXLAMnENzkpGEFP28Yq6GPCLiHXcQCA
         +n5oRInruCCoQZeT6CSvPzpSRUpVbBrUlMa2UGg1yrwK3aPKBdFx56XRPBotonfv+psN
         KXr2hTHa4JYp75JpeIH4qIJZz/lI1TBO4ra1rPE7klF1hexTWUP2KDN5hapbrMfbtbzE
         dQ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769647229; x=1770252029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mwNqkQIHtdixZxJdXARWDpGYyi08Np4wXzrAxbn40Ig=;
        b=uD7rSpTG4kyNPnJ9+gMXL48ElrOqxTTT+mR3jqK4k0ljEIiA6UFqrWhBfNLB8LnaNR
         ykU5EC6M2Ud5RjbnilQ3hR6KTlxx5bAuJvJ822xgLsEM938L6VlIjiWWrtIBCwr6HncQ
         xlBCAemGqfbzLlmBkgWV12byUdIz3mxROuW8DO2hnbrj9MITOEP1nvar2f8yqD2fcHF2
         Ql2N2InuHWkfkxqqPLCCWVBlATg1KP7e232bJb52dSnXXeBryfk59wo3LjdV0mJ24sI2
         ATAqBuYrvygaLHWwwDQAgXY6O+0hlR8ePtVAAiAztJQRHz68VEfVlHAN4PQAwl/XdYlT
         9X+A==
X-Forwarded-Encrypted: i=1; AJvYcCUtXQegSKpBADZRtKvt24W1KXSqr+B1iy+Vz0HMAu6yEbI9E6LeS3PPTnEfG0Sss9Q+XTRLkXbhLw==@kvack.org
X-Gm-Message-State: AOJu0Ywi86QeGt7lDA5sA/ZFrEPm94k6CA34Q6uir/DwsXYWeY8grRvc
	zP4rcD0qNsLV1gKTqDXwH/BGseikGWX7ImkKWIK9drXOCcijJDN4yYhgtr1wxWt5b76Bghgm+4X
	YnC4NVpKK1GGyiUjB7WoZ9Ip5Y02y90w=
X-Gm-Gg: AZuq6aI9IVXSKEUOMD8KeavinX624BVW1/2d6ui4A06LNJW4LtFuCdfqQiARt4KiuOW
	YZhFDshovmGa/H4O9JUBXyKqhlVjXxb8LH4CrFlI9d7JFxKM+d5hi7KmUTZPE3lyzqjlUIokqsw
	7ov1X6yA3+bi6WGng4xDpw7GL13bAVqlm25Dmx5NcnJbvNwHhfW+ojTk1FTuE4mO8OE7FUgOMiJ
	7pix6PSwAQ2al7Ea47yHs6BnPVbdaVGhc91poUAKyfHFb0POI8yuqfzAEu2EFOkNHxXeeD9wxJL
	0dHzgKn+98xhecog77jeNMg=
X-Received: by 2002:a05:622a:189f:b0:4f3:5658:5428 with SMTP id
 d75a77b69052e-5032fa093ccmr96242771cf.38.1769647228685; Wed, 28 Jan 2026
 16:40:28 -0800 (PST)
MIME-Version: 1.0
References: <CAC5umygEq6xvpDFnVnDLYLyqJV7qChEsJ_+W-KCBJ+EXj1948g@mail.gmail.com>
 <20260127220003.3993576-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260127220003.3993576-1-joshua.hahnjy@gmail.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Thu, 29 Jan 2026 09:40:17 +0900
X-Gm-Features: AZwV_Qj__I4vHnFSmY5jPXjrwbiwV_xAA-Q71O08pEvAwMhpfmf9VHUOS0TQ9-U
Message-ID: <CAC5umyhqbW_qXaApO8OGg1wo706GfVPuak5JwdBfBgS751Ka5Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-cxl@vger.kernel.org, 
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D2ADC14000A
X-Stat-Signature: 8nbamzepe5fzd8ejpqn3ocgy634x4iir
X-Rspam-User: 
X-HE-Tag: 1769647229-264927
X-HE-Meta: U2FsdGVkX1/uIhp5DOkvEbrRK88aU00ClvKJvnSrun8T8xdkTOpQjnFfG5n0CTG7zpfgjJ6OlLTS0E13svBCY7xgcQteYO1eu/MNOdRbjtiUDlQBFqlZ6MM1EN1ER8URV1MMxoLr81aA78XTZWpV/cmASDUVWN4pK5/wStD5asfgN7E1tLnykaII1B78N9mCu/dUoobLtnNFbZHwOReQmL4Se/hCeXyBjJ8WuI5Rdenh7tT0cFnLiY972ieIq4Fbiblhyt3fih+1+I558lZbcj2Aq4HPatwSkk126a9MJeg8e5kfSRhryjU7TbaFwjXesdF269OuDYO9PzSfGwmk3GgGHykfPnGCWGz57kZOMjUyQv7zKfb9VP36v6OA3tk4KMDOsw6FrJi2kt7knls3Jwe/EzjH/zW0HEQY5lK+kh4UqnSkiz6ZfIIS50VTbKpP31Lamh6KAu8oGuUdQPI8OuGKFW/g69RfiAvvFJmnhiOrT6crCQlZdavVjJJsihyZoakkDJR/VGufPQA8IqESXSG7INtdoPS3UqgoRk42HZjHSlHsuJxcFH9ZABn6GgKTiKkEIan7GOh/VF1xBmyHC2l46F7HspBW0nSOxcNvpPoE7Bh1vsAa+Xb3aQwjot5J1IHevzUMdKqsaqMUe2O4Rqdf3/ziYTra3t8Cejhu/A+KzkepkJrFjMqq4zZiF/BsY+ggF6+NT6EaWXU1NJIm9p93YGKMbElkScpZQFiiBSm7TcLPcBQGRB90ogshe1taq4HE5EyffBzRfZAONhrbgRfPtMCUYXcNnEL6XDVA4J/3siAQB7fW+GWvcutVBdO42ffp7PSpDoNMFULIlggM2SOoGo1K5BywP3mi3MqyY3wtO+wCyB/w36IFOIC7tIWs1MSs8JG0EC8vbiVN/vdjNA9hPk2IQQuoYCES2aUFiK/Mn79gat+DSMknUxX1JDoE16+JGNx7HRLXiKtunos
 bRXYhuko
 otvfKpAu+FHS9AyigISVZIVBaw+SYU0glSRiKZ6HGFEcGmafv552ikgYRgIe10Wj/bMOpQSbOHsBSNcV+OJssJXh1X8r7UyaAKJlh7ltQ1Wlau0qkPjZJK4CNRYzkTOTZRMUYV0+6MZQ7iUnBlwtVtsr/AQYeTf/Q0WuNQ9iz+Ju/v/NeqTCO/Sf4fP7vo9vBpDzZoR5fjqvf6B2idPbYiRu4zWfdJHlKoyBlJaiuBwMBi/Vcqj0tZQhjMn5FeRhRTyZeI83l8Sq+TTquNOnuO8e5a2+LJQPQJZea9VG/C5FlxMtFLEgWZ1cRcDDLKUZFCWypHmG5O1Djrl8Uz+f8ifEMQ+C2hJZmjsHaLr+SnwxYQX7wPEqa9a2oN2/QfVXK3KjhNJIvDtAVKzDgZABtPbOnYjAZ+Aq4Q/Idpzoq8gzCpp8sjB79KgEhyUxRnBQjUgrwcNCEp9GYBrAC2aq+JKgi0ldk+dj6Yb3RdFmTpeQRFy1QkOGSrDG1hQQ1VPAs3jdITGnbZoFmIO/+aqQ/G68lgGE5X6QKMiU1CS5bww7TjuUGU+Cmq+MZCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B41=E6=9C=8828=E6=97=A5(=E6=B0=B4) 7:00 Joshua Hahn <joshua.hahn=
jy@gmail.com>:
>
> > > > Therefore, it appears that the behavior of get_swappiness() is impo=
rtant
> > > > in this issue.
> > >
> > > This is quite mysterious.
> > >
> > > Especially because get_swappiness() is an MGLRU exclusive function, I=
 find
> > > it quite strange that the issue you mention above occurs regardless o=
f whether
> > > MGLRU is enabled or disabled. With MGLRU disabled, did you see the sa=
me hangs
> > > as before? Were these hangs similarly fixed by modifying the callsite=
 in
> > > get_swappiness?
> >
> > Good point.
> > When MGLRU is disabled, changing only the behavior of can_demote()
> > called by get_swappiness() did not solve the problem.
> >
> > Instead, the problem was avoided by changing only the behavior of
> > can_demote() called by can_reclaim_anon_page(), without changing the
> > behavior of can_demote() called from other places.
> >
> > > On a separate note, I feel a bit uncomfortable for making this the de=
fault
> > > setting, regardless of whether there is swap space or not. Just as it=
 is
> > > easy to create a degenerate scenario where all memory is unreclaimabl=
e
> > > and the system starts going into (wasteful) reclaim on the lower tier=
s,
> > > it is equally easy to create a scenario where all memory is very easi=
ly
> > > reclaimable (say, clean pagecache) and we OOM without making any atte=
mpt to
> > > free up memory on the lower tiers.
> > >
> > > Reality is likely somewhere in between. And from my perspective, as l=
ong as
> > > we have some amount of easily reclaimable memory, I don't think immed=
iately
> > > OOMing will be helpful for the system (and even if none of the memory=
 is
> > > easily reclaimable, we should still try doing something before killin=
g).
> > >
> > > > > > The reason for this issue is that memory allocations do not dir=
ectly
> > > > > > trigger the oom-killer, assuming that if the target node has an=
 underlying
> > > > > > memory tier, it can always be reclaimed by demotion.
> > >
> > > This patch enforces that the opposite of this assumption is true; tha=
t even
> > > if a target node has an underlying memory tier, it can never be recla=
imed by
> > > demotion.
> > >
> > > Certainly for systems with swap and some compression methods (z{ram, =
swap}),
> > > this new enforcement could be harmful to the system. What do you thin=
k?
> >
> > Thank you for the detailed explanation.
> >
> > I understand the concern regarding the current patch, which only
> > checks the free memory of the demotion target node.
> > I will explore a solution.
>
> Hello Akinobu, I hope you had a great weekend!
>
> I noticed something that I thought was worth flagging. It seems like the
> primary addition of this patch, which is to check for zone_watermark_ok
> across the zones, is already a part of should_reclaim_retry():
>
>     /*
>      * Keep reclaiming pages while there is a chance this will lead
>      * somewhere.  If none of the target zones can satisfy our allocation
>      * request even if all reclaimable pages are considered then we are
>      * screwed and have to go OOM.
>      */
>     for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
>                 ac->highest_zoneidx, ac->nodemask) {
>
>         [...snip...]
>
>         /*
>          * Would the allocation succeed if we reclaimed all
>          * reclaimable pages?
>          */
>         wmark =3D __zone_watermark_ok(zone, order, min_wmark,
>                 ac->highest_zoneidx, alloc_flags, available);
>
>         if (wmark) {
>             ret =3D true;
>             break;
>         }
>     }
>
> ... which is called in __alloc_pages_slowpath. I wonder why we don't alre=
ady
> hit this. It seems to do the same thing your patch is doing?

I checked the number of calls and the time spent for several functions
called by __alloc_pages_slowpath(), and found that time is spent in
__alloc_pages_direct_reclaim() before reaching the first should_reclaim_ret=
ry().

After a few minutes have passed and the debug code that automatically
resets numa_demotion_enabled to false is executed, it appears that
__alloc_pages_direct_reclaim() immediately exits.

