Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE43AC79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2B516B0088; Fri,  4 Sep 2026 12:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADC816B008C; Fri,  4 Sep 2026 12:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE1D6B0092; Fri,  4 Sep 2026 12:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7F36B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:39:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8350120129
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:39:02 +0000 (UTC)
X-FDA: 85176639324.12.3A22A3C
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id BDB0340006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:39:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=XxSQ22se;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788539941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPJNCIJctbxrL/gwwpLp4isL2IQcKA6SZn3cTOfdjLA=;
	b=zJI9dn6DUi4136exxpFQ/SOfiJE8p4nc/pjwjWT7MIU4Jg/oen5t5SIe/Mv8FWvJnFhSUP
	m6+IjViOuor59HogTLuygwjcW9WWhIkXvlHveR29ssi2K+bDyjSITVDIKBZSJCcL0kANd7
	tJcSEjfjisz3+4lFE2vMWVS+0kWsJVs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=XxSQ22se;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788539941;
	b=cVX6EK5h47qI1enXsm6P5ZTnfx4ey7stasi2wJVI0ClSLYy2id50D09rmKw3X/nzvGWPvZ
	ZTVQu/9L2+uEtH2eJbhbO0pgO/CqiYXIk9/6dKAUQSksNk3+l1uru3ftQshn9HZff5hzqy
	c6s3u4+CVDxEx72MH4f7W4S1carHL78=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-90cd96389efso16318286d6.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 09:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788539940; x=1789144740; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BPJNCIJctbxrL/gwwpLp4isL2IQcKA6SZn3cTOfdjLA=;
        b=XxSQ22seVmKpFnj56wlPoCoIENbUOwbl+BAqA1s5OUXyX4qf0luNfejEYMBqpdVqvR
         hRg9mQlR7Gb1l8I2gQmfae1j0BCuqq6luh1ZMBgxxDSs/iTDENiFfCgyCVZSHYU4VzkU
         NrCKBQzLd7fRo3bBY5Xh7c9FJ2Uvf7sJndFNSlmzL9lElLL6rng+u1YtJBKlkYLb7Jr5
         h5/TnNCpYlm8fUd/X7HaomNPD+Ta4sFgGO/k7UfEsKYLVsd0pz57MPEuTyxbX0E/UApK
         Rob2pZXvXYezR6J6Si2GWPtQYORme+MDS+V8oDmPTiLmg21KgPNgRRQxv4Zpr2FZuzsZ
         sNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788539940; x=1789144740;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BPJNCIJctbxrL/gwwpLp4isL2IQcKA6SZn3cTOfdjLA=;
        b=V3A88SSD/vPOyT/ttwHoT6YI6Dzd9Wu3K19RQt0BbgfnrfF4HEYKC1LQ7UOBzVPYMe
         MPQuQ8uuYHXLQKH7X3G0OPiiVoVLPRCeM6iXSeea2fFaV9UsUq6uJXD/VTr3hKwXLVmK
         KXndnDNg/ZfT+Rq1MslEMgY5y05jV/fiIqNd/leK8UA4Ifi2hizP4rOy4b8Z4afGW5hZ
         3HdjWDYTgA37pP4I/LBN0SKvjychyr617mN2V168Th4ggOI12z/JIF/1WPmD+Y3ZwBLN
         eJZ8Eooa0j0HCIy/sYr78d+0q7VkiUrK6dI0lnqO04OPMbdSK+ot7effb9AeZSOWyKJf
         LJxQ==
X-Forwarded-Encrypted: i=1; AKwUvBymp3oWzhAh42Pm5rUq/2FY02/W+Qs+kFnTSEYnGfP8INhadQuKVnXBeOflNT3BDNTv3NezS4IZEQ==@kvack.org
X-Gm-Message-State: AFuF++kVcN29oDQ9VwBHUu/sCrWf/T40W/hVHB0EyjNqjIFsN1U2wjYG
	xscPgFZlRAkjvUbuhdtnF0dG12/tDO13g2hiddPx97GjRiN8AVjAPahvSMWtLIeEHU3iaQDBN47
	SoAi059Y=
X-Gm-Gg: AYBFou1AQ6kncwJEvUqUYpHLEOmIyCUgW2O++hCFc4HjSGQHS2AlANsEc6FfaTTN1uH
	DfjkYi9iC7yFl9wgnrEjs8MpWwiU15+JIAbwvuMMhDKf3lQ4eYDvVoboPr6ucXbjKmGrnsbgb/K
	oNutPehTCWvzSGo+zJKXqi8o9QfIhVzFFkUm3Yx75OUGvrj2ZtYJZKlKzJqp3WPDjfADAAeluIf
	fxoqGk31IjuzguXyt5A6R3kerPze/vBt4aoZ5z/+JeSQvANMtD7JVDOsiXJbT3Y/xVNGskXfKon
	joqcwTTc9lOTDOVBaHUa1cCAsMNlPWGsx0iGJgEUDvETq02AtOm9HRJB9xLchfjh4HUmILAsP+R
	11bfaX8Cnlg2WNzn6uhr4sou7zHdf7PIjmk1sjGDUK+TuzRg796Tq7X8yRSJOP928eVpS4kzL0w
	hCK+tqpU0Cay7EYu2VyajAzRRvoHcoZW/CX8jAwOywlDFZYs1L
X-Received: by 2002:a05:6214:6343:b0:90c:c6fd:e8fe with SMTP id 6a1803df08f44-9103f044b57mr66427916d6.30.1788539939628;
        Fri, 04 Sep 2026 09:38:59 -0700 (PDT)
Received: from localhost ([2603:7001:f100:501::2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-910406b0f51sm23891226d6.42.2026.09.04.09.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 09:38:58 -0700 (PDT)
Date: Fri, 4 Sep 2026 12:38:54 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: akpm@linux-foundation.org, baohua@kernel.org, kasong@tencent.com,
	qi.zheng@linux.dev, shakeel.butt@linux.dev, david@kernel.org,
	mhocko@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, zhangbo56@xiaomi.com
Subject: Re: [RFC PATCH] mm: vmscan: avoid anon scanning for GFP_NOIO with
 low swapcache
Message-ID: <20260904163854.GE6641@cmpxchg.org>
References: <20260903130304.GQ3004@cmpxchg.org>
 <20260904020756.4163139-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904020756.4163139-1-zhangbo56@xiaomi.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: p5hyoq5y85fnadcmkieyiiqyx1ungm9n
X-Rspamd-Queue-Id: BDB0340006
X-HE-Tag: 1788539940-864948
X-HE-Meta: U2FsdGVkX1/VzG3jXexoPK3DkbgNANTKNup/sxn3uOa6t7m85Y5VMqvY+Bb5tJO1ah3wkE/qYsKEim/3oZF1RtGFEj0BnxXcIGP0JVG09nMSmDP8jJv9lWA3zsvdyFIb4f7vm2AIJIS/+zGBPqo82H+e0htnVIOuEDBAUDorE9M2rCSi1v/KXBuiFCheLX/kWA5Hwgk9OebyCWkC998qvWg7yDKEWZcp2Al4pRcmcnsl+MyrFpvzmaOcmQGvPSaHv9xgnkBfcvZFWP3M5Ml6shsyneLhOxhAM5zjLdNK58ilDIetFzGWT3zDwOENl6CKPnlo17HZpSB4k4uCOos4I5MN8Yd3T8/Brwm9bcYtvEx2Suu3hKtySl9eEJ6cCi74jOjqIxAyYKWQj8RxBQkQmpKHjwNHFm3wH+9jR1IHaPzMhYWtl3hH+NC9cnBRGXEQarkqvu2DMZKzdnwNQLMVW1hkiCE6vEilI6Gv82SvSRTxfk5/0tSMg6+CncfFP0/Mn+kKXCZy3aLA7f9zjqLkz7isVk5PdWr7VYoybmEHBAvPKfFyE9TN0bGnQ6XlxpsOi178VIpW4xJX4zKKytNa/EMqg5F5F9v4xJF9kA71gjdiXCUY+9Vo+lCYLXiVL1DpqDGzbflf7/i03aGKAjoX3nIdW1T49DhNsN8ZrxEgmdThl1e7S8VAq7RYWpMeLLy7R4TJhjgjbninjhkGfv3ujR6Jh5Gy5OBHcXNk68ZaTWiG9ExV+7iKpdSaqVl2Ilqk57q83LQiHyBtccakTKyHE8fZe93NFh4IWFy9gxp+3cgKSFoUgbGaqKXu0YN1bEaywmEdCDOU+EgygG04q0U6ZaX0rRncHxzGFaQVZlxYQdqTvSgm1LSAptcbsMpU9MJIkStYu6YgzsGg6s+hLois+jQ2DjxGywwfXuyk+Qpzj28qqzoEMW/qF+EPm9lvznmAtyXSFUSYM5SJyJe3bAg
 BDY0drV1
 ezGHcSKcRfv1Y3QNZf7bf3Es0RFSh9sP4t4V6IT3m7DurE2nRO8GSuMWT0malSfC0Um5br9AneWw8OdD/pVycYD46+ZfORQN4Hvct4MtM1rD+i5sWXMlzeWEN6wXtkVbRvP/kV2oZsqz9mtkfZRL0BL/1VJIk9YOjdOtlLmvacc/5QRrvYYdAwrZx8LlBd72u2QiCGl7x54IF7u8Z42OGu1y8jwgwhKZ3pudrIVHPCrnY01Xfz1BJXJkTw2f8g5Y4CxqNwB61x1SfJRUB91dtiClSeiOD9OV/gHPWcdsV+kKZXNcleG3gAU2hMBbpLwWC/m6hAzkXZ0GBiq3iLa06ZwLa9uHwk5oyTwi+JSgzLDATpcx5f/zABjfppVZGIdqxKkp4Ey/QY/UxbG7rW8xvwzs67CgvMczm0LCBLgNAAdawQrUeLteTAsWdqCcljgItLRwTCTwPoLpV3Us=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 10:07:56AM +0800, Bo Zhang wrote:
> On Thu, Sep 03, 2026 at 09:03:04AM -0400, Johannes Weiner wrote:
> > On Thu, Sep 03, 2026 at 12:01:31PM +0800, Bo Zhang wrote:
> > > We have observed some cases where memory is allocated with GFP_NOIO, so
> > > we cannot reclaim any anon folios unless they are in swapcache. We can
> > > end up spending more than 150 ms looping in `shrink_folio_list()` scanning
> > > non-swapcache folios without reclaiming a single folio. This is pure
> > > overhead.
> >
> > Not entirely. There is some value in aging anon alongside file, so
> > that the next __GFP_IO reclaimer doesn't look at a stale list.
> 
> You're right, "pure overhead" was too strong - aging anon does have
> value for a later __GFP_IO reclaimer, and I don't intend to skip it in
> general. Let me describe the case in full, because the reclaim cycle
> itself already provides that aging on a later pass, which is what makes
> me think the trade-off here leans the other way.
> 
> > Can you describe a bit more about what you observed? What workload is
> > running, maybe you have a stack trace of which NOIO requests are
> > routinely getting stuck in reclaim?
> 
> The workload is app launching on Android. The NOIO allocations come from
> dm-verity hash-block reads via dm-bufio, which legitimately use GFP_NOIO
> because they run underneath the IO path:
> 
>   worker_thread
>    process_scheduled_works
>     verity_work
>      verity_verify_io
>       verity_hash_for_block
>        verity_verify_level
>         dm_bufio_read_with_ioprio
>          new_read
>           __bufio_new
>            alloc_buffer
>             gfp_mask: GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN
> 
> So the NOIO use itself is correct; the problem is on the reclaim side.

Ack.

> Here is the full picture of one such direct reclaim. It runs two rounds
> of do_try_to_free_pages(); the target is 32 folios.
> 
> Round 1 - partial (shared) memcg walk, 169.20 ms, 0 folios reclaimed
> --------------------------------------------------------------------
>   prio 12->1 (~1.3 ms):
>     cache_trim_mode is on, so get_scan_count() picks SCAN_FILE. Only the
>     file side is scanned. Because this is a shared/partial walk, each
>     priority only visits a handful of memcgs before the iterator is
>     handed off, so very few memcgs are looked at on the way down:
>     428 file folios scanned, 0 reclaimed.
> 
>   prio 0 (~167.9 ms):
>     priority hits 0 without meeting the target, so get_scan_count()
>     forces SCAN_EQUAL. The walk lands on a single memcg with a large,
>     unswapped anon LRU and a tiny file LRU:
> 
>       inactive_anon ~335 MB, inactive_file ~4 MB   (~84:1)
>       memcg swap usage ~3.6 MB, so swapcache is negligible
> 
>     shrink_lruvec() now keeps feeding that huge anon list into
>     shrink_folio_list() - ~2400 shrink_folio_list() calls, ~93,000 anon
>     folios scanned - and every folio hits the !__GFP_IO keep_locked path
>     (not in swapcache, needs a swap slot). This single shrink_lruvec()
>     pass alone is ~168 ms with 0 folios reclaimed.

Ack. Thanks for the rich explanation, this is illuminating.

Agree with your fix. This GFP_NOIO just has to get through the day,
and aging 90% of memory it cannot reclaim is an unreasonable side
quest. Leave it to kswapd and the other reclaimers.

