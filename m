Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21173FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869646B0088; Wed, 29 Apr 2026 08:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83FB66B008A; Wed, 29 Apr 2026 08:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72ECE6B008C; Wed, 29 Apr 2026 08:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F1A76B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:49:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16CAE89526
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:49:48 +0000 (UTC)
X-FDA: 84711575256.13.990BCD2
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 387A91A0015
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:49:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ata+Ugt2;
	spf=pass (imf19.hostedemail.com: domain of huangzjsmile@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=huangzjsmile@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777466986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5bSR5azA7mGT2MIdoQg1s83NE5CNtJOIyCxYjmIHOvM=;
	b=2tBdQIKzKo7p/5dYI04rPBhhl0Vc9O8dAbnSUgBsEiMiycj3vc88/Gq7z5IjEVwx9PP9XK
	25aRnPzg02IdcgFpkxEXLzLg6jkdq+hH2z09bzt6IRhVQZra9vzcaU4Lg4mIbX2f7wOM8k
	LYxPeRGF5F/hjOfasqNsqOgeYGw6pJk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ata+Ugt2;
	spf=pass (imf19.hostedemail.com: domain of huangzjsmile@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=huangzjsmile@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777466986; a=rsa-sha256;
	cv=none;
	b=V9IPKXZPAl1MiPo+zgyzzvGAROj368n4GmdEa53FtavgZQpkkg5Bfm06NSnT2NeysFmRSr
	2F/9UqZZ2YIAERUpANlQPZ1xykE6SjABl3+GU7aLsDKY1pkcMSmKjS8mnfDbrEjkUkvQjX
	mC5ynUZlIkpgKLZiSCJAgAKCgCVKHIA=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35d99031e4eso8824819a91.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777466985; x=1778071785; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bSR5azA7mGT2MIdoQg1s83NE5CNtJOIyCxYjmIHOvM=;
        b=Ata+Ugt27QEKrC2MtBn4iVxNqT90lN7Ch5Hmg6AXN/rR2qfhCbsrNEDIArMopdkoI2
         uUoT2aAwy/JO0cEKV/kylYnKPC0711JSvdDm+8OjkX3qk39xLR0fFNuyHl1mclpmNUjl
         wnaJ86SyXathH5QFDu6KULhxU7zDpqAQk0t3hrtIE/5sHSqekdsEn8hdyTp/S439/xkT
         RnU1HCSpsIqmpdEZ11bYnwV9Olj9o5CaIqdN37zHadg79SDoUnEcm9yDl2iiHcZW89eZ
         d4mSsZ/oH0KwNcPWR/kQpLWSoGzfhjKs3kVTloZ4mZBNpUGWryKP0WxUymPF5WxLqTXr
         s+jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777466985; x=1778071785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5bSR5azA7mGT2MIdoQg1s83NE5CNtJOIyCxYjmIHOvM=;
        b=ocdTe4Zdp2Ro3YLJl53onHL5qvhxULgcEyAZruiYWmUw5vTbRA0lJys/dRYcOIrrCK
         BGm5INY/0hT7sawHdZOtmWzRbWzmDZcZsBCHU8s4EkSuJ3vgelq0aAhaygltRncXD0xK
         c750PjRK3F+daEs2RJuURm4JWBz5D8w33dVOrTowwjCJr1oGWc0W+GTQNFO1F83crrus
         zHXpqWEBmdYIdH1MYTMqjFUYi3fPHj0JSWg3CnyZVHm0/ZeIy+WktIbaSM/PBrpCIRt6
         OOu0fetF2bxafal6pq3lqcGu8vjSWF6q+0IAvHoAVI6vKgSLprcgIDrmbAoohj2smyn5
         b4/A==
X-Forwarded-Encrypted: i=1; AFNElJ8r6JUPDFRK4BoHBjSBKWhhOsbX2JhQY16YJ8PLSxOFkBavkLqkH80+MoYez2zXD5iyKMjvgk41Gg==@kvack.org
X-Gm-Message-State: AOJu0Yx8ysJo66yhRh9r9B/9bji04I5UhSuw7l+GuaWfc6KlFwjzP4PZ
	xWm1ib9IWtQJigvoZ/olEDzmX5JWN5M+035uff3gouTLi9yVQewT5vEC
X-Gm-Gg: AeBDiet2HWkFxW2OwNsNwh7rid5DKaNZGncq/rZdSxFjPBn34bKKku5R/cDGCS1U7rL
	kM/hsmtT9uZI+nn1WFYzu9bTlod0RZq6OCC8CiUo3H7eV1kwXx1heoXRQF9/M4ct74B4NXc2WS1
	rAm/DINGxkZZ2WXIYspYiUb1UKmFTsBPpbXEmPWqz2CuD+sHQ3YWOafM74amWwM3MeA9OooHKhf
	AthQpsYy0WB4l2OWFukNggti1JIT0HdnurA+3pE75mFSnap+lCEcDtiJjVsz8EakC4anuHU1aeF
	dpnHC/poaxgzI2yYWV8CehAMcSZYu14b5QagS1Ypr0+dt/krYQ5pmo/59qW/MYNmQvDT+54X0VC
	keNJyWMQKICqzOzTGDZHIFDLhYqhBgLmi3+ou9S9FUfEN3nA56/0NC6/M0OyFFlK6AsF1xXkmnv
	yFZKIC7ZFLYtvAjOiGBnFCwswVeBhyj2camnxq3fJshncHT7hCY3Mq+8dz7ENPolNUgseGR2U=
X-Received: by 2002:a17:90b:4a8c:b0:35f:ba3f:e04e with SMTP id 98e67ed59e1d1-36491f9e5c2mr7752679a91.11.1777466984987;
        Wed, 29 Apr 2026 05:49:44 -0700 (PDT)
Received: from localhost.localdomain ([14.116.239.36])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364a2712b97sm1318509a91.2.2026.04.29.05.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 05:49:44 -0700 (PDT)
From: kerayhuang <huangzjsmile@gmail.com>
X-Google-Original-From: kerayhuang <kerayhuang@tencent.com>
To: baoquan.he@linux.dev
Cc: bhe@redhat.com,
	flyingpeng@tencent.com,
	huangzjsmile@gmail.com,
	kasong@tencent.com,
	kerayhuang@tencent.com,
	albinwyang@tencent.com,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/swap: Add cond_resched() in swap_reclaim_full_clusters to prevent softlockup
Date: Wed, 29 Apr 2026 20:49:31 +0800
Message-ID: <20260429124931.452003-1-kerayhuang@tencent.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <aeuOuj5rHa6hgLga@MiWiFi-R3L-srv>
References: <aeuOuj5rHa6hgLga@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 387A91A0015
X-Stat-Signature: 6bn3989mne1aa5iuuf8obrybn7qbjytw
X-HE-Tag: 1777466986-753068
X-HE-Meta: U2FsdGVkX1+YQe6cfXaDmYfP3mSt9O7BwdTEccALmz6ERwcKFWFEifWduUF7dcLRwMXFjzdAOsFC/0Gqp68v5FKfM+5i7vc3iTH9rMUlAqfh7wIQdwItFyRh8ArrSmFPeW96ZBYrfytHF4v+77KJUR6cfw6mj/rOk9iT0ogYef425ZoJQy8UU+2zLVXz9XtPZ04wtYNT7I9e7SS9j7SrWCPLczQ4KbtbqA81K4InLja1Tt+iLegZgxp1J0Ozk37PUbOq8ADNBmGA8ECa107O0nikN6bLIgDuzoEcrPZa6G01RSUhjz1CGKK3uUX550q+t9zITyuuLchB6dkb1n/CHEzkRDw1EpRx5HbYvwY4aSiXWSo18C4U/N4O8EufSoSAG4iEjATPaRQkZjhescL7ooKBFzbItolV6m3krV3a2r+nrePf0x0NYbJcAfa5/TxAmB0Nyzp2bPg9GammEO7d08brOFEe72tqorLkcDX4qRb6ZW+zzDkKKZKWAZILPMwd2Zna2jQvS03Nm6O193MDDCTLeyfoPIzHRCjb0srrqLFn8W89l1/gzDdZJtUS3STCK2lAPckA79FRuO9QKdbXTQlmW6UtHZ54PYxQUfV/us48OzrCcVHt9s7dMc19vbuMF++Ya41HUKW5Riop0ZLxrps/w836mLpMn8Ie93OW8x81eXGVXfs1xesDsOJ7fSw3htGPbzRONeaBUC+KkzunGVN3H+dc0fWsQIIy35LlvY+wp5iXtGhAjPZUk3IvPtcxMXBN9zZsgIgrcW457lFO4Us+osH+fd41/IGb8i0cjOlSxm3M+Q7gqUoBCNFLxR2aPXsYfc9QwS2yUeeFMru2mMwb1aQjZ7zwNYlqWDNGkIn6PvrNLRbb1Oz8errtX+NEqaU3inLIN+S2szdK1gUagsKaXT1G+rfFRfYD+3XRSx/11G29z20zOSF3E2AgFNHPJYz9dtAVmEoFfEXJSnB
 fo8UMTC2
 KBRXF4JUqj0dp4MYEfzra0qpbk7TZiJHOzLM4xYuNW2opaH4WFe9gkMQm7rPc/WUjRBs9hD+RX9crNjoBEThZD7dobOJ90d4uO6no5YT+L2Xboe8swEnKPurULW3ZfybUkoJUIRv1Mn8VYN/55eLvGjCiTHsZ4MvFCDDM+Yy6+uW6JuxJaQDGgg1WHe0Sl1rMkPA+c22NRE/ClL/wREyb9LACZtMUNXXz/IKaIdYGhRRfHe1IDvVLn7AG2BXxZz+9FZEBbqltkwZIkTo1tvP3cWxRC0ZkSc3Yj1T9CSFotGkihWqJXa9UnPQqSMLT0KsQF1Ul3ftn8Q4kZdhTM8PGy1WKC+6ypMe8P0uBO+gxdLX+rgbgzC9zXtZ7H3hgZyYr5BiwJgtOv2X2SO3uRKErz9XR+9yf9O0MtRnIzZQjzePfK9LSEsQyV8UQG8C4xjYu51+Zq6zAiquO/VOv9gBzu/OWGObnmrN2D3CCi1k/Vls40JRurZCMUruM4Lb/N24l8V8N1/XTNBcQB25NYDoCCuA9ssMsnnae4uRZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baoquan,
Thanks for the review!
> Hi Keray,
> 
> On 04/24/26 at 08:37pm, kerayhuang wrote:
> > Add periodic cond_resched() calls during large full_clusters
> > reclaim operations to prevent softlockup issues.
> > 
> > Signed-off-by: kerayhuang <kerayhuang@tencent.com>
> > Reviewed-by: Kairui Song <kasong@tencent.com>
> > Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> > ---
> >  mm/swapfile.c | 1 +
> >  1 file changed, 1 insertion(+)
> 
> Thanks for the patch. The change looks good to me, however there are
> still small concerns.
> 
> For patch log, it might be better to provide more details, e.g did you
> observe this issue in a product environment, or just a code exploring?
> If observed in a product environment, what does the backtrace look like 
> when softlockup happened?

We hit a real softlockup in an internal stress test environment. 
The workload was LTP memory/swap stress on a large arm64 machine, 
with 320 CPUs, about 1TB memory and an 8.6GB swap device. 
The system was under heavy load and the swap device had a large 
number of full clusters. The softlockup was triggered during 
a stress test after about 3 days.

The backtrace looks like:

  PID: 3817773  TASK: ffff0883bb28b780  CPU: 48   COMMAND: "kworker/48:7"
   #0 [ffff800080183d10] __crash_kexec at ffffa4c1361e5de4
   #1 [ffff800080183d90] panic at ffffa4c1360d5e9c
   #2 [ffff800080183e20] watchdog_timer_fn at ffffa4c136231fa8
   ...
  #16 [ffff8000c4ad3cb0] swap_cache_del_folio at ffffa4c1363e1614
  #17 [ffff8000c4ad3ce0] __try_to_reclaim_swap at ffffa4c1363e4bfc
  #18 [ffff8000c4ad3d40] swap_reclaim_full_clusters at ffffa4c1363e5474
  #19 [ffff8000c4ad3da0] swap_reclaim_work at ffffa4c1363e550c
  #20 [ffff8000c4ad3dc0] process_one_work at ffffa4c136102edc
  #21 [ffff8000c4ad3e10] worker_thread at ffffa4c136103398
  #22 [ffff8000c4ad3e70] kthread at ffffa4c13610d95c

From the vmcore analysis, swap_reclaim_work() called
swap_reclaim_full_clusters() with force=true, which sets to_scan to 1551 clusters.
At the time of the softlockup, there were still 1427 full clusters remaining in the
full_clusters list.

I will add these details to the commit log in v2.

> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 9174f1eeffb0..74a1e324449d 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1054,6 +1054,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
> >  		swap_cluster_unlock(ci);
> >  		if (to_scan <= 0)
> >  			break;
> > +		cond_resched();
> 
> Besides, is it a little bit too aggressive to call cond_resched() for
> each cluster reclaiming compared with the old code? Do you consider to
> make it gentle, e.g calling cond_resched() every several clusters, 8, 16
> or other number decided based on your testing performance statistics.

I think calling cond_resched() per cluster is reasonable
here because:

1) Each cluster iteration already involves scanning up to 512 slots,
   and each slot reclaim may call __try_to_reclaim_swap() which does
   non-trivial work (lock/unlock, folio lookup, swap cache deletion,
   and potentially slab freeing). So the work per cluster is already
   substantial.

2) cond_resched() is a lightweight check - it only actually reschedules 
   when need_resched() is set, so in the common case it's just a flag
   check with negligible overhead. Therefore calling it once per cluster
   gives a bounded latency without forcing an actual context switch every 
   time. If we call it only every 8 or 16 clusters, the worst-case 
   non-preemptible window can still become quite large on machines with 
   many full clusters.

2) This is a workqueue context (swap_reclaim_work), not a hot fast
   path, so the slight overhead is acceptable.

Thanks,
Keray 

