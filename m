Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A5E1CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 04:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23AA26B0088; Thu, 14 May 2026 00:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB896B008A; Thu, 14 May 2026 00:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107486B008C; Thu, 14 May 2026 00:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 006B06B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:10:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7E0E0A0418
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:10:33 +0000 (UTC)
X-FDA: 84764698746.28.EBAB2E5
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 550A1C000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:10:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=uber.com header.s=google header.b=6t2TvX7u;
	dmarc=pass (policy=quarantine) header.from=uber.com;
	spf=pass (imf10.hostedemail.com: domain of haghdoost@uber.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=haghdoost@uber.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778731831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZyvinl3RBbw0wPTvpYB5i7OkQNZ8q30qzuT9enN60E=;
	b=3DKTedcsQabXxWKFLnM9Dq2Dy3Jdao7P35+U/iVDwi4mH76f4+M1arh+G9qPjoHj+gbx28
	EWooxY7I5RQ9Ui/k82YV3UfOoA1nVtU0egiOOOs/BB15QEOSXXMBrknQ3cjbUv98dndTgq
	ZqD6qv7DmlYgOBjIoJaXdkFt8Ut2Zus=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778731831; a=rsa-sha256;
	cv=pass;
	b=7xlyYrkLXVXfpPtfSHCrRAjgzrZ5Nkrjdqnw4wpzmFsbdNUlBPUZkvZEwJZRa4pSviCVWB
	iR7wgHH50pGxwKl7pAvVQrMh9bQnVttASlUTwUFTJg+rwcEEpfn7OUKufXSs7ejtMZRtLi
	H3ASwlCEb4ipFUz7WQMiywsR8SFgmHw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=uber.com header.s=google header.b=6t2TvX7u;
	dmarc=pass (policy=quarantine) header.from=uber.com;
	spf=pass (imf10.hostedemail.com: domain of haghdoost@uber.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=haghdoost@uber.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-672645dbfeaso7470442a12.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 21:10:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778731830; cv=none;
        d=google.com; s=arc-20240605;
        b=Sgtz7SPfJx8rSfRLWYlChgq2CVrKhlSPEDcuAVNhkJ97plUgOeES+91wr+ZZYujDAW
         f7tHke1ZJU51H8V6LOJ26DckqGVNGfyi+BlVsOLiC4ghrn28fne2JBUuPxlO9xa9qExy
         yMzle1Sb5bloiy/h6kW02lkRQdASHxdYaqeCwmT9fNTr/1PipqH1rRw5ZqDMl5wXhBB3
         sayZ7l+/kZ2r/G2E/TvHKnnFxYQOTB2h6y7Ds6StaqI3+A594RJ74JfVu0ZFFIwcZDSw
         4LWdtf0xjx9TiG5XKPlCfD0rg3Arlt4281GC3+KVS8H5JglIC4uN7BB/iERPedu6iMwX
         ConA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IZyvinl3RBbw0wPTvpYB5i7OkQNZ8q30qzuT9enN60E=;
        fh=nQVWu4Boxt4WfzKwGJkA+PM0dhuLKE2NZGpZEd+C7lM=;
        b=kv9GDkGteKtRcuXc/wsUO7lMGdvfuIiAuktqvF39ZXDyExNGFVjqZCxF36jt580OaU
         0jwWxIDbccrT3+oEX/LYqittOKbYAHHBRHSir9SdRcX4rXEudzGcCRpZU5oxl+IRHTFm
         uT8Ix5RISGZZm0CdkLdVL/xiyh8XH/9QbqSA62JeoDS8pAAXKHlBitjRYaXjNZ3WAUsI
         SEo2fypopMoEGCXEJZsuAZX+TzgEkURGbyk5CbBYcmBEvUArlr+kAL5/LhlqQqbFW46h
         lMfrHhLq/Mo5MRS7gOwCC6Oe2R1fAqe0BhuioMdDoEFS5pQzy4xLR/posfaQG5XVPiDU
         C6LQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uber.com; s=google; t=1778731830; x=1779336630; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IZyvinl3RBbw0wPTvpYB5i7OkQNZ8q30qzuT9enN60E=;
        b=6t2TvX7uAEpL8w6gxf3DrjRfsUpZcGI3kPNI/xVL1kv8VqzidTD5+FF0FizU7UE5st
         LFnuJkEFhXV4WVgP/rSCNtevxRSyngSNLsWqIkTFh9GPYTcPS8lr3YkU3dA5bYY+J8Tw
         MGgM5Y/lV/4tdwQavd8v9XlLVbL2o1wWGNhek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778731830; x=1779336630;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZyvinl3RBbw0wPTvpYB5i7OkQNZ8q30qzuT9enN60E=;
        b=Gd/LUv90hW9tiooStNHVT0DYe8ZmJvch7ZaowfrT4gh7tb60/38+d3xD00bv4V4cXG
         P6+7tg5OvlgVMnqHTWxHub3ukPLciOyU3Zlz8pI9UVDbllm6s17OSfhiJy/pqWKtHf0l
         RXtu3VOrFqkzr+JpZd591dVzCTXfaMu/4mO/LQbAAJJ9W6D6M00F66W6ex+xXN6rROsv
         aT7u+Is3BHeW3t2B7DhEVdeAZNaN0dt3yFcI/pMwsfT52A79VU0T7looj+Kxf7vgsgJO
         3KcUkmD3w52hYMiHdztibK+ovt1Av30lM4pnW/WjHC2+xt/5o8A6NtxNjh1GiWTMmfsL
         J1uA==
X-Forwarded-Encrypted: i=1; AFNElJ+E+cWddXsKy+eRCqpk/80/8s0z2o4o1uEDTHU1iG8FWNBf4AltBW57mGWAhTxpW7aASZsHx1SC5g==@kvack.org
X-Gm-Message-State: AOJu0YxiD7HLK4npb6pvltkdzBhYherfFFebJykS9bZ/k/t9+e+Vf7WN
	RA1/Sab2N+wDN7jxdQRpmbStUs5NouqWIJCxEJdd9qO0S5FqA/uRlR9G/4r78Wac7XKBmymFQ3G
	sRNbVpHijpTCcFV2rtCUbBF3JCTwN/kBsrp+aFE2TNg==
X-Gm-Gg: Acq92OGf7v6tNZ+gxTftk5tO7Hi4f3FCCthuef6dKqyJSkxx9qa/GGEX83UdwyvAfb4
	vcVY3wPvqEJdMAH3tZaFqyxZ8Z5K4TmEk5zhQCtV4rCvM4CI/LrtmDdm5RCYGwgJ3mJXP27GVId
	XR1b/Y7O9i5RD1IQNoras5s4uJpT5o7uV7CUs24dkrMnxfilBjXVj3uFt0QduNFF4o13cyL0afJ
	rRKSCqdd9/4rZb/M/gWLPsfSKOK521hQIuRjEtmxEn4Y0V1vo3//l738S64NRuDdzC/b8TSbIE5
	8gl8NHWF3SoSxHcpanrMZWnLi+vxKYCn8GpC/Vw/
X-Received: by 2002:a05:6402:4284:b0:67c:2674:a57 with SMTP id
 4fb4d7f45d1cf-682a64e44ddmr3155758a12.0.1778731829214; Wed, 13 May 2026
 21:10:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260501-rfc-memcg-dirty-v1-v1-1-9a8c80036ec1@uber.com> <pbwzmyglpz33d3k63aopi5vlghz4jmur2k2g4res6mhktuujhh@rmqooz6bqaao>
In-Reply-To: <pbwzmyglpz33d3k63aopi5vlghz4jmur2k2g4res6mhktuujhh@rmqooz6bqaao>
From: Alireza Haghdoost <haghdoost@uber.com>
Date: Wed, 13 May 2026 21:10:10 -0700
X-Gm-Features: AVHnY4J5GZ7JBzfRkA-sfCo1uEK-ixoCcB3uvVHBJUoZ4dZkaVGCZkTX2MJ_bAU
Message-ID: <CA+w=M=RkewNB0Fc=KNXTrOnt-YABFy+7ZALLmp1wQOP5k_=13Q@mail.gmail.com>
Subject: Re: [PATCH RFC] memcg: add per-cgroup dirty page controls
 (dirty_ratio, dirty_min)
To: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Kshitij Doshi <kshitijd@uber.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 550A1C000A
X-Rspamd-Server: rspam04
X-Stat-Signature: dzb5g478o5983u73ygwjk78qwbpxxz6b
X-HE-Tag: 1778731831-314389
X-HE-Meta: U2FsdGVkX19aWXX/FscJF/e/wtLciGMEW3ev04WHXDw65kEoA6RprFyznRSw1XFtXiBkDzZlnDZAQYPot/rE1fO+Zl0pfcsef5PvXj9Pjngpxrpa1+aoWgcUFiZRrJdEMlirRRhJGC3GuIo+W5yyND+TKlbxMt2dQ3MBj1oNv0fVcVGKLipgvZDz7Tsp7caBy9gHvmhm1UC3jh0yq5fuffGnt6/NM1RxasYWWTuiVGsSWrYGdm1fluZ2mYP+lCyVGNxztikaPbwAXAA6qojipUi71uqdj4uKWHq7uabrcMT8qR9co5Nk4GH2wcVOePy5sIdES+t7sc8LmzYMRjbsrazy7vm5tnI6I0cV0aWfV1QIQW+1NLMkWAH4QshnXstfVLCgybUUSVOvgG8VJjirmWcBckaY+dVgVx4nnI58FIErkRnHLLOGhliNT84t7TWple8GdL1LqsjooUYkAJXhl10LcwqiD/8GcTokk/ebH+5/fWVRC5K6rILSfJH8ovxz1gaC1i4y3pZNBhNyowr6Z2R6l1+QienIoBF0Z95xXjzTDHpYszSfp1LyEpEE1tgdziGqZ6mTXSCL8hDi5tcT6L/ekLkjw0hyUxDMk7asmDuIy4ru+tNPvblYVZ5Eq4NcPNngKK0S0HT5tWFjWeGNsGp2XKh0nE0+CivBjuMd/nf0G2FmHuBwqthyLXRdmyyT+2scwfZAymvSqiutVs9vDoFEFyonx7v+ENYP04GGtUi+Rgjx6+cJfe2wOzzUiUVJikOGwUd2Yr+HIXjkO6j4+feJgqPTqHSDVmUqnndNVg8NPGYTLUBFepzlnOIswW7c/u58pvwAE30am6WMI+eQ8fL0Xw1mYLyOoUMJUsQB3Bk6ydFLgCUbG4gKoIo380T5BSgpVy2/9EMJGFsGp4Qm+ilS0jHQ3V4VGZCDiqr6qu1pXMQQq7GPpKjT6eJcFgVw14tLPQJlQAW0MM84YKc
 6HUkbBIe
 jSGzDOdUcDltpFMBwU05tJqWWGCKGYqTAmAnZw75hAdJRXgh+rDlwP9K5cZrWlrB2qcdWED8frn7PG/TrT4t4iM+jLNHuCEOF7cVKDQXsslHUzjdL4yIZ9yV1m9CuQR/Sl/W3WaFK4IW289V2G6QBm9mWEKhQLFpiTQTTbln1Yxw1kjVTmYfh4CaHKzs5+5SdBk15z9j/eJ7/hWR7yGt4yikt5rd+hLscmpZdmvamdxM2fGZpy9YW4FryGB/t+5skcoKaYKpXkigQIbzL7ybsUlBRGvPp3I630pYSp7iEJeH6o5/rRuO5WYYWQxrWRGcuchHExclpcQyLh+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 06-05-26 16:21:00, Jan Kara wrote:
> Things like motivation actually belong to the changelog itself, measured
> results how the patch helps as well. On the other hand stuff like history
> is largely irrelevant here, frankly I don't have a bandwidth to carefully
> read the huge amount of text LLM has generated below so please try to make
> it more concise for next time.

Understood. Will trim for the non-RFC posting; apologies for the
volume.

> ... I quite don't see how a multisecond stalls you are describing would
> happen [...] If we are below freerun in the memcg, the task dirtying
> folios from that memcg shouldn't be throttled at all, once we get above
> freerun we throttle by maximum of throttling delay decided from global
> and memcg situation [...]

The stall is reachable even with the victim's memcg well below its
own freerun. The freerun shortcut in balance_dirty_pages() is an AND,
not OR:

  if (gdtc->freerun && (!mdtc || mdtc->freerun))
          goto free_running;

Once gdtc is over freerun (because the noisy neighbour pushed it
there) the shortcut does not fire, even when mdtc->freerun is true.
After the shortcut fails, the per-task pause is computed from the
dtc with the smaller pos_ratio:

  if (mdtc->pos_ratio < gdtc->pos_ratio)
          sdtc = mdtc;

When global is the worse domain, the victim sleeps against global
state, not memcg state.

> So can you perhaps share more details about the configuration where
> you observe these delays to innocent tasks due to another task
> dirtying a lot of memory? How many page cache in total and dirty
> pages are there in each memcg [...]? Is the delayed task really
> throttled in balance_dirty_pages()?

Yes. Re-ran the reproducer: stock 7.0-rc5, ext4 on virtio-blk
throttled to 256 KB/s, dirty_bytes=32M, dirty_background_bytes=16M
(freerun = 24 MB), noisy = single fio job doing unlimited buffered
randwrite, victim = single fio job doing 4 KiB sequential write
rate-limited to 500 KB/s.

Per-memcg snapshot during the contended phase, ~10 s into the run:

                       noisy memcg     victim memcg     global
  memory.current        47 MB            21 MB           --
  file (cache)          38 MB            14 MB           --
  file_dirty            26 MB           1.7 MB           27 MB
  file_writeback       1.5 MB           4.0 MB          5.3 MB

Victim memcg holds 1.7 MB dirty, far below any reasonable per-memcg
freerun. Global dirty (NR_FILE_DIRTY + NR_WRITEBACK ~ 32 MB) is over
the 24 MB freerun ceiling, driven entirely by noisy.

The victim writer (fio with psync) is in fact sleeping in
balance_dirty_pages(). One stack snapshot during a stall:

  [<0>] balance_dirty_pages+0x5c5/0xac0
  [<0>] balance_dirty_pages_ratelimited_flags+0x2a1/0x380
  [<0>] generic_perform_write+0x194/0x280
  [<0>] ext4_buffered_write_iter+0x63/0x110
  [<0>] vfs_write+0x28d/0x450
  [<0>] __x64_sys_pwrite64+0x8c/0xc0
  [<0>] do_syscall_64+0xfa/0x520
  [<0>] entry_SYSCALL_64_after_hwframe+0x77/0x7f

Sampling /proc/<pid>/wchan at 100 Hz across the contended phase
yields the histogram:

  104  balance_dirty_pages
   88  hrtimer_nanosleep    (the fio rate-limit sleep between writes)
   12  RUNNING
    4  p9_client_rpc        (virtfs, host-guest filesystem RPC)
    3  d_alloc_parallel

The vast majority of non-rate-limit samples have the writer parked
in balance_dirty_pages(). Victim per-IO clat in this run reaches a
3 s tail (worst single 4 KiB pwrite blocked ~3.0 s) while its own
memcg holds < 2 MB dirty.

I'm happy to share the full traces and the reproducer if useful.

Thanks for the review,
Alireza

