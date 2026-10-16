Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74383CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CD8D6B0095; Thu, 15 Oct 2026 23:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57DD86B0096; Thu, 15 Oct 2026 23:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494126B0098; Thu, 15 Oct 2026 23:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0B06B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:06:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92E78C028B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:06:23 +0000 (UTC)
X-FDA: 85327001046.20.D0E8766
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id B5F6AC0006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:06:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nf99ZRPy;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792119981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJ5h2DXsBgi+drliVf0SasZjdtc6E51DgIAS0CDk42Q=;
	b=1yoxN0bsIglJ1Y9oqxe35YEQz08M5MqkigvM5GxS4hBNY/LgfuJHzR01YZCYbu0OShctZy
	7B6/LLjyerYvY3qICPFMdJwKp2BYtYNJmy5VwW/foRvHta2LhiM50gaCNdpni96FP50kzs
	tJDLM/VIdmumRcUq5WiHSTfSWdRqi8c=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nf99ZRPy;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792119981;
	b=Ag2ZYHoUdTGF1e+43f3i3YJCFubaCj1cybPv1d3oRiqghsE40LUpskDT3FpT+ZCrZ+t+fr
	jXHbqNvrw1ysOICwAFEPvPX3dEz9J0HRtscLvwvhKdGjbOhcnj0Op6zx5jmn9/tsFtRLLE
	XQ9DRMWQzdnic3kyZ+0WvGaQEffgjCg=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b1aa377c61so7280386a12.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:06:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792119980; cv=none;
        d=google.com; s=arc-20260327;
        b=EC63E4ATdw3uymDgscdCByi+VK8znSn34f58podFbaIX3f8D0LR4SIQcVa6jgMV34H
         RmcBqMpg/TRr1GoLcwrncAsfDyffEtqHUzp9r7Ik7D95eHJ88H3yF8IVmKzsEaFPOIN6
         on++lA3pBjRXcTUO+lcLRi0kzBpnl3HH6viQCJTSOccB+m96TWMuMazcS+n82hKQ7HaY
         5UQNvfMGSy3LgrdJMjhzTOh70Agizfrl4uc38OLSL3gh5IAuNdaTwk4gIF2NAKUgLdeR
         xLtt1OYaqNt5QctuHqPJw/lmiCQy+QMOWxMsP8wDMyr5rObRd9iPoAxZJ9HvuN+ZQDRl
         Spyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oJ5h2DXsBgi+drliVf0SasZjdtc6E51DgIAS0CDk42Q=;
        fh=pYWVRDA79s4loiPF82nyEGOto5jww/yicL5o4JtV36s=;
        b=LsUNxCquSSxrcmpJxISKBa7w/w9QhTkpTvRNbNgYaCBH1u7qNcdxN9MAcsPbbljk/M
         J3AVKe2zBIBR0r/SJ8BxEK9X4c1+KipqNG9OqMtFB5C6Uo6s5so5MTqDeuGUfUXTzgAu
         hPaE+wk/3lqYBSqk27uITw+RuCrFYp2gZnYAM9hRefxPKcPCCUpTIufQV15+/H+TRRTd
         1VMJusibO5nU6pgtgcBD+GFES3emUiCjHISCSthbGXfMLltFKUdrYqxVeWfXDUehe2Mn
         fWDZlZ4rQst/7GNZ2heXJCWlnsxKauQhLpb2E1KVVxqEYghjp4uxCDFymmzGTQjnNrdR
         sR7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792119980; x=1792724780; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oJ5h2DXsBgi+drliVf0SasZjdtc6E51DgIAS0CDk42Q=;
        b=Nf99ZRPytMT7rE/Cvu6eOKazNxOin5JTllhyy1T21emWaCEXgMi2DeuiX3CCE2UhPO
         Dq3bHGRf4cKScOkDFXZ6JdnTI5e/0dgKQLigFBeRCQSR+MluB5ojxqDUBUpmM2JZLxrc
         mBpUTy16QmPQKEHd1nwnpYYSK9UrWr4ed1TOlrbBm4Rv3PDobVLrke+PQsGzeZvqs+97
         ZemE18Mr5aOkEEp9xd8SC7sLcOlU4cHsDg26llLfSpa1S6HKTIErmmIcRIzSB7oJiO38
         1CSAGU/fYyYjjWy9mfkqGFLV3MECkhQcokX/W/pLFmVmTlFP9wCDiyXZrBvqMvj61sra
         r0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792119980; x=1792724780;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oJ5h2DXsBgi+drliVf0SasZjdtc6E51DgIAS0CDk42Q=;
        b=YEXZnK4OjFDF3EInqqaPg1h7QZsHcncXr2xciNxpt9Tv3ocPq/n406r+uwf/jLV4ai
         cs/kB7t+db/RQdRNg39UX3iL7Zd8ewp/QY9iOLSzODKJbhemgb+byW2CGVr9V87ztXBH
         LHoYxwGGr4UDVbXmgw7mSVQh42tz9d4ZyhZZeXz82DaRuDsoFlWhqUDKqwHZKkR9H17b
         7QF6IWv6XwNAykWxgLgVCQNYDdpJ+p6YcjafdZF25wqYNE1NSwq+3x/KpV39m9DvBkHO
         oLs/6tQR6XzRtV0UKzPu8J3noEQ3JHT+Gow6HMQGfUL9YNGs5nNXDz0dhnL9ME9CHajy
         bGeA==
X-Gm-Message-State: AFq9FYKrOILmge+xez0FE6d8vcH8Cui/b+EANTgYLGcE77+svUw9MXdA
	2fnPw2885BxZc6ttejihbWsJN2YLpMdfOx/nBhBDzhnbNaDGtvh3Qhw4Zqe1Qh9Amueqh1ev5e6
	kqs+fqSNkrLFoqVbWuZG2HwqZlPN69vc=
X-Gm-Gg: AYBFou38bjbnjxGpUxRjavttfqRtM3p8xeYeM4glek8IQllcvkarHryTr/Zpb62X7b9
	7R+7jlHW4SMLOCtiOgYGBddmHURUQHwhtdRWHnBWBHVCyj7us0KqEbFaFxFXfqn03P7gv4tsd2n
	TBhXIlerSMq76hUSTbhYdtWm2+4M029cNrclpIBGcFhI8ZxzjXo5WHVJzT4quEIlgJkTqI4xdrs
	5b3Ph4u+MYvupQwzChCBY4EPxfdoJBwOhRn9gK8zlDPDeBsa+v7WgCHw56ZRifRWTHJ7t3IiGkf
	bkznAXsLse9qXG9gGB7RVvF42GzteSsJbUzvtVH/6ToXr92Lq0znMruaAOH0T4Vzohd1EVQDwRw
	6S7fERLybYUiS
X-Received: by 2002:a17:907:9801:b0:c29:4fcb:2886 with SMTP id
 a640c23a62f3a-c31a9fd831emr1921004966b.39.1792119980088; Thu, 15 Oct 2026
 20:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
In-Reply-To: <20261014090821.227366-1-jiayuan.chen@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 16 Oct 2026 11:05:43 +0800
X-Gm-Features: AclHuK_e-lCNsmM0w1PY2ZD39crP8DWlyZW3Ur3Jggt8rHloT5AJAjERE4NO-1M
Message-ID: <CAMgjq7D50X47JFsTnF2-jYGv7i-Nd3WhQLK-TJGy4XkhMQU4OQ@mail.gmail.com>
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path gave
 up on
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B5F6AC0006
X-Stat-Signature: 5bp8b4aagioc4icznfmcx3eg8ywdrca3
X-HE-Tag: 1792119981-942866
X-HE-Meta: U2FsdGVkX18OJQeMB2qU1Lk7uB1FMCmunqdtqN4UfUbBm68O4ploXpBQAi29ZN+xVrqtZl0rjRqiQfJEM5pXRkFcnWRR89ey94/ugR766mGIIndpfP996n7190mAeZZv5NjQYVpWRJ8yt4ehrIiswGgur1JUnPoTeeQisnbDFBPk2HQoyGL2Oej75KTUyH2x82flyOOTq642V7SPYrPEI8sNOjylh6oe65QhbeidFF9H7d2icuTV6x4Y1F2pM1VrXBw84AK3iowxKhoDLr16q0WOqfd1qzEvKV+sYIA1QZP5BOTKiKf/jTMcssfwBz3hh/tzU2X2Sa7ls0Dx6YOBxzpbgpdosf/LP4i2guECa90OuvD0OPVTEbXAtHVRD0eEfULMg30doZgRKGO7cW3XubXKRy8DNr7raD0yhI8oPZ2BPdhp9mdV3rcLb/9xJU44m0k/C8i/NlidEPRvXrY8swcel72UOXnjTlMeXL0FZ29CiKgevM+f5W+WCaGvl09w6ha0+SWHL/YUazdp+USw1k6pIqzlOHOCX+SZhJSPAAjXcXCv7UiRfO0V1ypbzrvMwLn+q+mHzGYMDPxv8Lg8q+qtR958dwFekdXmwcKm2XBW+xP+lI1DWVsfbYVDtD6B3kOr3lLo+59bMH3kPe9km7ZbE2CTWYpYiczF15gRrZntFk1EJ2vc46Zv1cyrJoBBk+FlR4m4mDQhRQZdGCNaqQAD3bN1O5aSNmrZVZJPuWwb6N+jK8v5I8UWg1eCWKZbSiER29XGVzP2+WnI4bpvAyygciFVd1uWfD7qxcIPu0ezNf1qBhSdVcaN66IjX0BtTKgbwSFASn38vlOB8l9Ri5lIxNpdsC52uc/iUcX06ZodY7U3p5n9YtFzM/4qJaNLcUgu/a9FSFT0Z5vNqSKaUUBIFf5NpPCIX6yvBwbK/JhxviYK0fMmszHyFA5RWv/FajC8BzyXC7VoTYjZU5a
 G9qEzZMf
 YmGcBEtOj+EL6DDabbLcYYXpRjKmHUq3TzCxOgyYSr2nc6X2bmlNewFSfqieSfDA6JBLco2JitNPnP8IK/EZbpL2uvwLc3kQZGk4UoRfSdnYgI/kKc3gF7qylbXS1Rd9q3OMkzPIisxWJyUhGwX94+Mogbe4RKHfZ5AKb2MeBrETDwf39V0FXca9D0n5aihMZrcEzFvegSoqp4ClrzXV3OPkXXKbWT2JggS8D+EyezUOqMQaXiCQ3f1ggKw+5Z6Qc/XpeSCO4tXLZXQc9cJ9RyL6ulFKFcdE1wWRYkOBdaZL8iDtr6QziwayS2AfbgY50wahauZdwND45FthHdPEoeTU9wd1m+TORO7dk4cvjThM9aIN13mfThbsD9GNQSGD2dHRcFYxGxwhAk1oeO+WlQTH8z3rQYiHu9DvwMWiDqgQyXs+dPPAlo6oa+yv1yNhRaIyqA/XZPYmNots=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 5:10=E2=80=AFPM Jiayuan Chen <jiayuan.chen@linux.de=
v> wrote:
>
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>
> On our production hosts we saw swap cache only pages keep growing for day=
s:
> on a box with a 500 GiB swap partition, 250 GiB of RAM and 250 GiB of
> swap slots were held by folios that no process mapped any more, charged
> to cgroups whose workloads had long exited. The only way to get them
> back was swapoff, and with other services actively swapping on the
> same host that is not an option.

Hi, thanks for the report.

> Such a slot has swap count 0 and an unmapped folio pinned in the swap
> cache, left there after a process exited or did MADV_DONTNEED. No page
> table holds its swap entry any more, so nothing comes back for the
> slot; LRU reclaim drops it eventually, and the allocator only reclaims
> such slots once swap is half full. The growth stopped exactly there:
> at 50% of the device, where vm_swap_full() becomes true.

Hmm, I think this indicates a much cleaner fix is available.
vm_swap_full is inherited from the old allocator, we can instead just
let the allocator reclaim the slot if the slot have a count of 0 and
ignore vm_swap_full at that point.

Will this work? (Just a minimal implementation for reference, will be
even better if we can avoid the overhead).

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c3288910b3e3..94670fe82f31 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -212,6 +212,9 @@ static int __try_to_reclaim_swap(struct
swap_info_struct *si,
        nr_pages =3D folio_nr_pages(folio);
        ret =3D -nr_pages;

+       if (folio_mapped(folio) && !vm_swap_full())
+               goto out;
+
        /*
         * We hold a folio lock here. We have to use trylock for
         * avoiding deadlock. This is a special case and you should
@@ -903,8 +906,6 @@ static bool cluster_scan_range(struct swap_info_struct =
*si,
                if (swp_tb_is_null(swp_tb))
                        continue;
                if (swp_tb_is_folio(swp_tb) && !__swp_tb_get_count(swp_tb))=
 {
-                       if (!vm_swap_full())
-                               return false;
                        *need_reclaim =3D true;
                        continue;
                }


Or, from the LRU's side, put swap readahead folios at the tail. I'm
actually trying to do that and it's not very easily doable at the
moment but will soon be easy to do.

> Options considered:
>
> 1. Fix it on the readahead side: after the read, check the swap count
>    and free the slot. Covers the lock, not writeback, and the
>    asynchronous read path unlocks in the bio completion where the slot
>    cannot be freed. Two places to patch, neither clean.

In fact, readahead checks the count before starts the read. It should
prevent some of the problems but seems not enough.

And another idea, what if we just add dropbehind flag or rotate the
folio, if folio_try_lock failed in __try_to_reclaim_swap?

