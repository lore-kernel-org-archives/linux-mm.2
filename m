Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C75FEE73158
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 13:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12EE86B00AA; Mon,  2 Feb 2026 08:11:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2356B00AD; Mon,  2 Feb 2026 08:11:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5D96B00B2; Mon,  2 Feb 2026 08:11:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC4C36B00AA
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 08:11:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FD0A16015A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:11:21 +0000 (UTC)
X-FDA: 84399552762.01.B3445A7
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3E8A22000E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:11:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JFJN+vTs;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770037879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JsWhYD8Ccn9O07ciy26zVsalLPwSPT50YwVsz4kOkY=;
	b=sAE3/jg3ytD5nacxTuPou1svgUzS+an6pilbERu0GoDNRNfgjuyyINDMUcVCY9jUrRvtzD
	q3UkTOnehWTLNFz2YZGIWHQjQYeqCqqAiO6IcXg5ZEZBLzNbMjrg/qOlDC4tccGLzZEHod
	ZgQogMKruuEZbCpAmyRY+FEaY8T8kqE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JFJN+vTs;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770037879; a=rsa-sha256;
	cv=none;
	b=S2t1eqgVcSM9oUDKPtynfekr4WOvVuA0bbb0tSj8uDwphtWz1v6lq5RtawmYuz1RUGVuM9
	xUu3Rzc8bODRdHu1H7A1noFEBgNwfBZHCuydaBynmjyuGeDJy6nAFLMaR5zPyFUX2yCd1x
	ZIozSqN3RVmsrwYbu48a60//3BtKNT4=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42fbbc3df8fso3407212f8f.2
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 05:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770037878; x=1770642678; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8JsWhYD8Ccn9O07ciy26zVsalLPwSPT50YwVsz4kOkY=;
        b=JFJN+vTsBcBPXLEk/7jY3HU7tWYSufQgszHGkogIK/HKmvimGyJhkhv2Tdl+FLvUlG
         do9ng/bt9qrM+b/VM5GCQS9gE7H0CBBzHGnnXYGJLsbmdqN/64JLZegVuGlbRVKs9ltn
         Eb0iesUS8LPdImTsrgOSjR0WiaHwVg6idRPggFTvRQQx2712PrwmtaTtw0L4lzyemJWQ
         xhTpEezsqydy910tezFCWdZ9dLYvNr7f9LgSVynhHKHDFyiOEYWbO4vG3eJ9F6LO+Z7d
         Jvn3RzhCZ1R1zxtFXjtQyc0xqrdCYg6D3Zl2pq2G6IBytDbB3qQspT8KVhF/l3FWlh2N
         edHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770037878; x=1770642678;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8JsWhYD8Ccn9O07ciy26zVsalLPwSPT50YwVsz4kOkY=;
        b=D6ppvwo3qs7Jxt7XCyTLR3H8Di5A6tHv4DvOGpsc4QdAoIS1rWMDrI/abzINp+iez+
         BlzpH2E/s5p+z++EX5+aodfqPZ1P3Prb+m8LqjHyamy3fUj6kjMUbfr2WHTFIlJmlDyb
         B0WOrfkYFDIgVuoxLWi2mTiSCSG+Ye4CQkKazwF3qvmf0mVkfanA5sQ1VErR7wNT9u67
         BjPGQ7q6uaZ2PuAXWwuqNwx+NmptkFz2dt83ELUg83QHf81mnve6xrdirLjTuLgmCIzG
         NthU/GR+/wVWTP36CC/HZ1vVER8hDNr2TUBcWYywNfn8/ep1HzcD17hS/bvoQgDTaYFV
         6ZUA==
X-Forwarded-Encrypted: i=1; AJvYcCXBuOgSqe8moJmLno9kJ0zXLbIR01w7WiDw0Q3xSeyC3bsSkoLBDH6GyAhKkrZhioq0+Iu6M0Hl7w==@kvack.org
X-Gm-Message-State: AOJu0Yx0mbvdyNej0UmqLarAE3aO0mfh6bewXoQJrQipJje+vqxmCdob
	pE2UXYWS0JW0WLHkrQlQWna1Y5fOj50YDNBU3paYjkFCCyn0hXHDboPK5GW/g/prFI8=
X-Gm-Gg: AZuq6aKFsuD4ehx7llu3mMQkQ+beoaNMnrH76kJMMKQsztIzGCWVQjFiptbGzjTr4VZ
	5KK5UXrtdYY0VOL2cOythoGu3NHfGf9oprGDTBwOgFBPWqSu3lMW0Xd77aErn4kF3qy1oK2WbrL
	XiYMTXRBUAcew6u1ozCJCcO1ksWqtD0LNZVBY9ovRaHgudMpkPuS/jW+sX0LHD9IxsG1yC0OZNy
	ptJ6DSDkUNYVuBdcU1pOsX58ruu/WoGwdXqE8iuFOzem0SLsQZbiJPa+avn56he+eqvo+QDwKbR
	EMaZv3z984ya47WZgNGFp+msqMTMNcsYE5qjdG6g4kkeAQ+MwLEK8+1jK8+FUKxM6JqvqIKWJZM
	PPnrbuXDqtgc0hS6NbUiwyTjE1xA43+SdVNo+qLqrM8z8jJVjVs8fUcY+d72ZNmSLckbWbXAZAd
	5M+TVBMnAeXJU/6/n1Oex+XO9vQieJNkzTnZE=
X-Received: by 2002:a5d:64c7:0:b0:432:5c34:fb22 with SMTP id ffacd0b85a97d-435f3a7bee5mr16538747f8f.22.1770037877469;
        Mon, 02 Feb 2026 05:11:17 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10e4762sm41985148f8f.6.2026.02.02.05.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 05:11:16 -0800 (PST)
Date: Mon, 2 Feb 2026 14:11:10 +0100
From: Michal Hocko <mhocko@suse.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, ziy@nvidia.com, matthew.brost@intel.com,
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	bingjiao@google.com, jonathan.cameron@huawei.com,
	pratyush.brahma@oss.qualcomm.com
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aYCiboGiXO2lQC0W@tiehlicka>
References: <CAC5umygEq6xvpDFnVnDLYLyqJV7qChEsJ_+W-KCBJ+EXj1948g@mail.gmail.com>
 <20260127220003.3993576-1-joshua.hahnjy@gmail.com>
 <CAC5umyhqbW_qXaApO8OGg1wo706GfVPuak5JwdBfBgS751Ka5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC5umyhqbW_qXaApO8OGg1wo706GfVPuak5JwdBfBgS751Ka5Q@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3E8A22000E
X-Stat-Signature: dpxrpedwjnsi1usonjn1rkwsqxi6ix5n
X-Rspam-User: 
X-HE-Tag: 1770037879-440172
X-HE-Meta: U2FsdGVkX192I+3ubb1Vdd3QNdyfV+EfYQViqIZsfXjOO/G+j7y8lnldLzLbPmUauHZTzj9qwE0pOXxcv3/2JYUXXLaK27oI7YL6vKOiAfHKJOEXw6vqE/xehdCDsBJ8GZdFb+GutxcWQoNR1ytRYmeM1MGns9ub65D2N/Xn9nafDrVfUK+zXftpXd/6BcHjnTHGPUC0eB0eWOoqDDzj+X+uzVeHyspYJt+ZAXVlWaAtfSXn+AqcGUi0lJKUfyj7zuvHCXsCXbeL206DOjEAf1489hTApOYg/KHa/eFtLA3X/MW3M+Xuiae3SsDjfnpa6bYjQbZSADfjVn91SjTmNkuEOVFyUpFo2nxkxWNITItLQroeWFF6ra7et0qS5eDvz1yx4EvjqBKB2q3eursoaxbDeb3JoKKpsdfk4qOearnvrSoKwGT91ymUlgkok2MP35+WJTKU9bnRknlMDsGyiQ04yADFJw125TIYFao4RAJYkRwdUCD8lcPetETIvgIDX7dOoVcnHuBYMR8R+t5UkdiGBEpNrSGXz3n432tjn0rgaY7+T1rXEyjxsPmV5WfVCwMFRoH9rgG54AL+aRWZwe0R/2dsTOHyrl6FKvkS0GEHiBs6W1bC/U65cG1ULDgL1ELTcZuq5zC3/9qkT3PEuuzbSO0JSRkdcKlEEdkU/pGlSDpaxFndkFLEKCG9kpA7iCwRXJ/JnZyLmOGxFqvi6NHbHq5XAgOKVTj5tp0ouK/HBPjTgq/Srd57T7gJhXF7pUPdWfpyUbA9FEb/oRc8c1DbFFz+ho3lHYNW5yhJZRTw+4+wbIA/QMZSqJ8VRFz4tmrfuVj5Giop+WK4xqBScwIlIdCGIzbJOdTEkpTJvsOE0p/p+Xba4ZbLopwbCwrlLjuZHqv6S9RkRgMUoVzadR2lKTsGj6ycRbVhzZqa0JI4yOp/i6lxC5j1RoeomgIVkFy33wzjFdUIRFTkc1c
 BWGCOVgV
 8QEsTVYtkT7HKlAcwlm+v4jz0+rhSOaR/I1VJ4A9gJ73rzKOZdjss6OmKDa7HJRJR42nHWkHtc5wm0bzUxpmggrLk2YvByy9ldegspzgwTfQk1s7SWSHHuBdokgph70o1i1G9VpSUV5mFYkdNdt1TlFrZo3FiTskOebqcBFXKAXYCeiVPMK2fS2rkLxjK3g4u6OTQjLTo6JeaSBPXWQeQCxW67NsDVO0flcfKkUzv+0ncDCnfk5htadZ+aC6RHmFid7y4jOfcFGpPlvzi4kWLKPGeHvr9qypCA66bwWu3uDnAZnFxEgS1v4DvQEnWfJg3C9U2/+2kg1EFQKRYRgdWlLqhY/7Gv960qQIOxoalGgSgVEhhWqtSM49pup+1xDozIUGBnkLcYUaDnkr5WDtdjSFgFrLV8ackB2FgA0UY3GzXyw/nXHTv5uGQlK1pL8GmNv+/54dSdyUgCqImIec0GwUOsW7P9KTasXjjE6odCPF7VSiPx5xegNlGjhcumN0WXDdk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 29-01-26 09:40:17, Akinobu Mita wrote:
> 2026年1月28日(水) 7:00 Joshua Hahn <joshua.hahnjy@gmail.com>:
> >
> > > > > Therefore, it appears that the behavior of get_swappiness() is important
> > > > > in this issue.
> > > >
> > > > This is quite mysterious.
> > > >
> > > > Especially because get_swappiness() is an MGLRU exclusive function, I find
> > > > it quite strange that the issue you mention above occurs regardless of whether
> > > > MGLRU is enabled or disabled. With MGLRU disabled, did you see the same hangs
> > > > as before? Were these hangs similarly fixed by modifying the callsite in
> > > > get_swappiness?
> > >
> > > Good point.
> > > When MGLRU is disabled, changing only the behavior of can_demote()
> > > called by get_swappiness() did not solve the problem.
> > >
> > > Instead, the problem was avoided by changing only the behavior of
> > > can_demote() called by can_reclaim_anon_page(), without changing the
> > > behavior of can_demote() called from other places.
> > >
> > > > On a separate note, I feel a bit uncomfortable for making this the default
> > > > setting, regardless of whether there is swap space or not. Just as it is
> > > > easy to create a degenerate scenario where all memory is unreclaimable
> > > > and the system starts going into (wasteful) reclaim on the lower tiers,
> > > > it is equally easy to create a scenario where all memory is very easily
> > > > reclaimable (say, clean pagecache) and we OOM without making any attempt to
> > > > free up memory on the lower tiers.
> > > >
> > > > Reality is likely somewhere in between. And from my perspective, as long as
> > > > we have some amount of easily reclaimable memory, I don't think immediately
> > > > OOMing will be helpful for the system (and even if none of the memory is
> > > > easily reclaimable, we should still try doing something before killing).
> > > >
> > > > > > > The reason for this issue is that memory allocations do not directly
> > > > > > > trigger the oom-killer, assuming that if the target node has an underlying
> > > > > > > memory tier, it can always be reclaimed by demotion.
> > > >
> > > > This patch enforces that the opposite of this assumption is true; that even
> > > > if a target node has an underlying memory tier, it can never be reclaimed by
> > > > demotion.
> > > >
> > > > Certainly for systems with swap and some compression methods (z{ram, swap}),
> > > > this new enforcement could be harmful to the system. What do you think?
> > >
> > > Thank you for the detailed explanation.
> > >
> > > I understand the concern regarding the current patch, which only
> > > checks the free memory of the demotion target node.
> > > I will explore a solution.
> >
> > Hello Akinobu, I hope you had a great weekend!
> >
> > I noticed something that I thought was worth flagging. It seems like the
> > primary addition of this patch, which is to check for zone_watermark_ok
> > across the zones, is already a part of should_reclaim_retry():
> >
> >     /*
> >      * Keep reclaiming pages while there is a chance this will lead
> >      * somewhere.  If none of the target zones can satisfy our allocation
> >      * request even if all reclaimable pages are considered then we are
> >      * screwed and have to go OOM.
> >      */
> >     for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
> >                 ac->highest_zoneidx, ac->nodemask) {
> >
> >         [...snip...]
> >
> >         /*
> >          * Would the allocation succeed if we reclaimed all
> >          * reclaimable pages?
> >          */
> >         wmark = __zone_watermark_ok(zone, order, min_wmark,
> >                 ac->highest_zoneidx, alloc_flags, available);
> >
> >         if (wmark) {
> >             ret = true;
> >             break;
> >         }
> >     }
> >
> > ... which is called in __alloc_pages_slowpath. I wonder why we don't already
> > hit this. It seems to do the same thing your patch is doing?
> 
> I checked the number of calls and the time spent for several functions
> called by __alloc_pages_slowpath(), and found that time is spent in
> __alloc_pages_direct_reclaim() before reaching the first should_reclaim_retry().
> 
> After a few minutes have passed and the debug code that automatically
> resets numa_demotion_enabled to false is executed, it appears that
> __alloc_pages_direct_reclaim() immediately exits.

First of all is this MGLRU or traditional reclaim? Or both?

Then another thing I've noticed only now. There seems to be a layering
discrepancy (for traditional LRU reclaim) when get_scan_count which
controls the to-be-reclaimed lrus always relies on can_reclaim_anon_pages
while down the reclaim path shrink_folio_list tries to be more clever
and avoid demotion if it turns out to be inefficient.

I wouldn't be surprised if get_scan_count predominantly (or even
exclusively) scanned anon LRUs only while increasing the reclaim
priority  (so essentially just checked all anon pages on the LRU list)
before concluding that it makes no sense. This can take quite some time
and in the worst case you could be recycling couple of page cache pages
remaining on the list to make small but sufficient progress to loop
around.

So I think the first step is to make the demotion behavior consistent.
If demotion fails then it would probably makes sense to set sc->no_demotion
so that get_scan_count can learn from the reclaim feedback that
anonymous pages are not a good reclaim target in this situation. But the
whole reclaim path needs a careful review I am afraid.
-- 
Michal Hocko
SUSE Labs

