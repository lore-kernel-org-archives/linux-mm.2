Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02073FF6E9B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 22:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E991F6B00A0; Tue, 17 Mar 2026 18:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4AAE6B00A1; Tue, 17 Mar 2026 18:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38FB6B00A2; Tue, 17 Mar 2026 18:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C324F6B00A0
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:54:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7426EB913C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 22:54:05 +0000 (UTC)
X-FDA: 84557059650.01.AF49F97
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7C7B92000D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 22:54:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=BtWw0eiC;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of yunzhao@cloudflare.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=yunzhao@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773788043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WuZBsh+s5SrqXpiwYWIUnhrYft2HdckwZzDp0JVX5Yk=;
	b=1QYqwAJyADUlSIKQzyzGTZG8YNLyta8FBvb5KVPLIdK5weIRIr7FSCffjP4eL47Tf5+a1T
	QGs6L6O1rnrO8VZRoZc8lGi4cUu3DlD177uTpwjQ+csNGRFzgqiKQQQopBwQ3xRer7L4km
	i0jk8vVRYoNZ7/bGJexgmpx1TuqT1Og=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773788043; a=rsa-sha256;
	cv=pass;
	b=nBc9YVIaSp0joaqhkDx99KiAO0ixWTYh26DdDeILYHrmRKu72Xyq8RVmU5yzz6QxMA+A9l
	/vUhxpJESpjIJFwGWCRQMwEPmB8sVbWr74XQOZ4ciipQ8RYKUciRJkJokdavV99voj5gIu
	VezelyjUVAqRSTM0qvw3tl8+hbkZHMM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=BtWw0eiC;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of yunzhao@cloudflare.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=yunzhao@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-67bb5f989c4so3850124eaf.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:54:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773788042; cv=none;
        d=google.com; s=arc-20240605;
        b=h9UpIvOSkI8VRaPTt8ByoeIikrByjlJsxyyfAJHlh62C8jTXoUKnnvx8c5YDrPGkgC
         gYblP9k001it8onoNkZLbK4KpWH6Jhk9MstoB4q/s3gvXT6ce4FRqx9iPrZJRmwA8DNf
         gn63LS5ooGtfeb/8QX398fjocRBJRY8MyS21EcA/RfTp1nziys4EQgyU6RcaQ4usf483
         xsB4/QLX4Pzjnnr9ksTXOQ6k37Ao81F2SHg/kGUFbFS6jc5AjS9d25zOpeIxkWaUtxs/
         mB3j6XROR1d5qhlmHx+PYR8EagpoO9AIJB+HpLCD97Xc/Zsyxf+eB6gHBErlfP3FnpF7
         xXXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=WuZBsh+s5SrqXpiwYWIUnhrYft2HdckwZzDp0JVX5Yk=;
        fh=n1IFgfNulkeVpNpmkh/cuZsvniHEZy8FqFiEytzxKqE=;
        b=EyRAXL7uRRmzsjF54ZBcu1PngU1IwVyAPXRdw4OA4pS08W8iYR2ALROfhk0CBL1wR0
         C+xWgCHARAxl1FEij5psDgrPaXpjz2vrYhehqom5FxmEMtk9i3JL04qMRv/HHgz6m+0H
         TeMxwADDpM2scjTfKNy6Al47mqyQsHVTyIPQti53NZLoTfo0JJkTsDI9r6wEHQKXVrv1
         XNI1cMazEcs+uTlY0RGBegUbJTtDb+fUNqLf27vX0KKIavgFQs1/aenrXVSb8yFBVlkS
         eqHmBUNxU8uWSJmFdasuxXw8aSvoz3oFc21yhnJAlJ6zTzVfQH8MOcuAAWgdfy58yue1
         0rSw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1773788042; x=1774392842; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WuZBsh+s5SrqXpiwYWIUnhrYft2HdckwZzDp0JVX5Yk=;
        b=BtWw0eiCK2U/Or+qIp6yyj0qXKsezkddC4VK28dcWv3jqEyOE+tTd+CTthTxRAyFLj
         4zdFurB5ahLzi/D4F8mF+kP8BRpQdNgUhqAfLQz2sNAgGyfSGaIOoJnBnqism6VlrKqu
         TJTe65EpXWe2siFTMD1QcGIGUfc5PWze0n5uG9G030P/Hl7E5EcTmJkmASV3ccO2Hp3y
         eyD3xeW3nUZDVVCGDbwffkl2WXjN0NfHdI0/drPW//7nQsl6KYLuWIVUQ8v2DkTLJbQ3
         uYd2WgoNSZB70J1Y7u6K+ngGm2YI+EofplfqBQEmodNoSr3Ke0CMZ7mP2u75l38A2W0j
         plWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773788042; x=1774392842;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WuZBsh+s5SrqXpiwYWIUnhrYft2HdckwZzDp0JVX5Yk=;
        b=Ic1tmXQoqXHcoSTN2oVWPlSSMfM/tyHi5HYQL4RUVqvY1a/Fyf7qBMfM9ugn0ZtFXo
         54M5s5DrEmIZ3pY/7i1M01LMtahrPa/bpehniROFIswXFjUhEOD9towqpHVQco6UZofA
         1UY9jTdpZ5IcFK1hKizd7hG9xiN0QdRYzxMMFpjVZdNeeMGp9/8izy5LXu2KzHVx4l9C
         duwr1sk793EstQX0nKL/gN9t7z0bWPvmOfdclFEnb7ZmGCBTROU0hOKZlcGhiziuQiu/
         jvSxKcaZTkpVLlZ4gR3zdp5rkn2w9zZXVfQv6l93iWTYOfSjDKLlNTMYcmA2CbiA4gXC
         yUEg==
X-Gm-Message-State: AOJu0YwKInsX3qcnTs2WfALRQr7XHu6C+ikzDdLR6sGihIw7QVUEkXuL
	fnDcMvhmuCrhCLq8QhSZA9DT8N2RsNFLjs155uEotlQ1LPKfLPhmfHx0RnC4o5moKYBt4JU1VZK
	PtpXwxNwMQMO0T0EVEJXXT2JjQuwK4Fm01fHQNZGuS/Rqi1yrWIW6MKL92Q==
X-Gm-Gg: ATEYQzxKpAcXa0+3q6YeKkXYv7LBR1J9JstRDtaWDXSxcaDKLVvGIgK1mWamuHYH1oT
	zvuQnNZIaI8OW3QUjzfxv5PmqLbG4Nh6Pp/N54Hao2iNSsZAckxINwhV4i+De/aLku+NiCxqhKJ
	Q67XgRrDxeqxaTEr4Eu1wB6vVYqNknMXcsOvoo8aLkfz37vTAusLJMTbswLxOOpakOoB7VFgN9D
	c4n7bjb4Mb3ZWGOcZM8pk+whdBKfoRKS/4oFtiyiQSUCUVKsYYDj7rebXKjRzsm2out6KmI//MJ
	3lxwjgKNEWHr57Jw8Dwodswp
X-Received: by 2002:a05:6820:611:b0:67b:af79:4c1f with SMTP id
 006d021491bc7-67c0daffbefmr791587eaf.40.1773788042196; Tue, 17 Mar 2026
 15:54:02 -0700 (PDT)
MIME-Version: 1.0
From: Yunzhao Li <yunzhao@cloudflare.com>
Date: Tue, 17 Mar 2026 15:53:51 -0700
X-Gm-Features: AaiRm53XXsD9OA9FNRRdR7iAKF-aZdVZqHAn8W1aiVtyOZqm281mMdLbU0-fB7A
Message-ID: <CAAnvDSwOoEOkMEDgKUcHkx-SdmZ_ar5AbVy4Gp-XT7i04ON5fg@mail.gmail.com>
Subject: balance_dirty_pages() causes 40% IO PSI (full) with no drain benefit
 on 384 GB machine
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, Jesper Brouer <jesper@cloudflare.com>
Content-Type: multipart/alternative; boundary="000000000000299200064d403688"
X-Rspam-User: 
X-Stat-Signature: cpcjg17j5izjjdiopjm7opw7ff3syt3g
X-Rspamd-Queue-Id: 7C7B92000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1773788043-768203
X-HE-Meta: U2FsdGVkX19kD6tZY9zBSuBZZuS4TrvhLTlbpq5zzrwJhW43S5F8lhKoTlRGvsDhZb2UGqvUeZiLcoD/cKjXWSHYnnKaATL1vrtzrFT9rPiafeIZGB0Sv7pTzLbfMvuisXUw9WWS4+W4Wi7NSzNTSvoVa2sZDy+5l156A7tN0FDa3VZPl2askhg3sM+CFuEB2iOj/Nh0yBqsuDo22AVXa8xjNIKzOjKOzTa4VHohbtHnN7lJoHJxnPBrY9ySJbu1UIeGuMTCL0uIbJo/2F/wQebZIuGOgOhcoy2ixT2OuA238sTIq/72S6uc80zbkss9HFlxSY5sSu6J+ZVsc8geDW3EED5YKy/1mEvlXkVnPTrocKSpPcWaEdJG+Mh71DMw58y5ehU0wpj0ma0qleJfuEYQrV68LO6LcbAnymEtnLJjIRGyPMC3nHx3NJPVtsF74a2kysjyTYOhi0g8sH2Yzg0P7fWUOJ0P5FsbsrdU7H3k2aqm//XcEIsYZRJev06DRtcrOgkonyNb7zmMIe0Pzx1ctb++gaKF9kxsocuP3+I8pUV6fyKiAPbHJeUrzDQsiA7ut9aLYMZjk3MZgRNtV9kMjXaydGUlaCzqWkdlwMrcA5AmoP9glKaBGSYfip4NaKTbLIa7bnCmJlYoVBGY5LyVdu4kbBnskLcbD5A3r6BvJ8wkb9u+d+5sTOaXAdGSU6s+dWqZU9Zp1c6FYA3DbLy4YC9wwFXKsVBvcp5fDq52MRuSs74NKoumeXcTYNDDz3ZrIN5NklO8pmKJrsGzgGm5YnCD3xOxMjz1J0cw40lCAZQDCGBNS0v0e1t1WJ0stwzSGy6vh1vBLCpKAd3/7VBWGGHi1B5p7xmU867u7MZ6LZaziXOrpXEpnGE8XpAA5xF4CtB8wvUp2ACt4Lb0Yn0BrubNY+pQ7YoAo/XK48aLklAmCM9sjolJFxiEsa3Ib4ew/z0QhVpdECTnxjT
 YHukb5Fj
 6N/fPoCH4gy5Tj5iqWRX6S3E3K7U7v9BYsNwYU0ADw1QEEsDTsoCzHBMgaJ9xEFABTIBFNs+WpsfVZYmoeq7HuGxyQBRUvEDup5mPo1bh82SC7zSUeB8q+kMHRht5ssg0xdDiZwjroVAPUhhMjogK4B6t0/CYYXg31nKtOoUdseQ+N50n9g3fevtbULQr9VlzBOhDTuyWL/zHO9iFaFqA938p0vybXKNUJhTNmSP0/RI/VWj+hYQ18UYAPrUI+RzZEdPsD/ZBMhvczvfuuPPy4/OGUhJzkNr3z8RIhNHan+Q3t7FgRpZcFh4I+ERZRB7EjCDc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000299200064d403688
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On a 384 GB machine with NVMe storage (2x NVMe RAID0, dm-crypt,
XFS, kernel 6.12, AMD EPYC 9684X 96-Core), balance_dirty_pages()
throttles writers via io_schedule_timeout(), causing 26-40% IO PSI(full).
But the throttling doesn't actually drain dirty pages faster.
The flusher only submits ~578 MB/s of writeback regardless of
whether writers are throttled, and the NVMe device has ample
spare capacity (1,044 MB/s benchmarked).

I'd like to understand whether this is expected and what the
right approach is.

The setup
---------

  dirty_background_ratio=3D10, dirty_ratio=3D20 (defaults)
  dirtyable memory: ~77 GB
  -> bg_thresh:       10% * 77 GB         =3D  7.7 GB
  -> freerun ceiling: (20%+10%)/2 * 77 GB =3D 11.7 GB
  -> limit (hard):    20% * 77 GB         =3D 15.5 GB

  Write generation:   ~580 MB/s (HTTP cache miss writes)
  Flusher drain rate: ~578 MB/s (device can do 1044 MB/s
                       flusher can't feed it fast enough)

Below freerun, balance_dirty_pages() returns immediately.
Between freerun and limit, pos_ratio ramps from 2.0 down to 0
via cubic polynomial that tasks sleep proportionally in
io_schedule_timeout(). At limit, pos_ratio=3D0 and all writers
block (max 200ms sleep).

Generation =E2=89=88 drain, so dirty settles at 10-14 GB =E2=80=94 crossing
the freerun ceiling into the proportional throttle zone.

The observation
---------------

                 throughput  IO PSI full
  dirty 5-10 GB:  494 MB/s       1.4%
  dirty >10 GB:   578 MB/s      26.2%
                  (dirty still accumulating at +2 MB/s)

  Peak IO PSI full: 39.5%.

The proportional throttle adds 26% IO PSI (full) but dirty
still grows. The flusher is already at its submission ceiling
and sleeping writers doesn't help it submit I/O faster. The
device is actually starved: writeback-in-flight drops from
6-8 MB (baseline) to 1.8 MB (during throttle), and NVMe QD
drops from 45 to 37. The device could drain more if fed
more, but the flusher can't feed it faster.

Meanwhile, memory is not scarce:

  Dirty:          16 GB
  Clean file LRU: 57 GB  (instantly reclaimable)
  Memory PSI:     1-2%

The dirty pages aren't causing memory pressure. 57 GB of clean
pages remain available for instant reclaim. The throttle is
protecting a resource that isn't scarce, at a cost of 40% IO
PSI (full).

Our workaround plan: dirty_background_ratio=3D5, dirty_ratio=3D40.
This raises freerun to ~17.5 GB, keeping dirty in freerun.
The flusher drains identically. It runs to bg_thresh either
way.

Questions
---------

1. When should balance_dirty_pages() sleep writers? Currently
   the criterion is "dirty > fraction of dirtyable memory."
   This doesn't consider whether sleeping actually helps
   drain dirty faster, or whether the remaining clean pages
   are sufficient. Should the decision factor in flusher/
   device saturation or available reclaimable memory?

2. Is tuning dirty_ratio to 30-40% the expected approach for
   high-memory (>256 GB) systems? Documentation doesn't
   cover this.

3. The freerun ceiling gates entry into the proportional
   throttle path. Even moderate sleeping shows up as IO PSI
   (io_schedule_timeout is accounted as IO stall). Dirty
   never hits the hard limit in our case. It sits in the
   proportional zone, but cumulative PSI from many tasks
   sleeping short durations is already 26-40% (full). Should
   the throttle path be skipped when sleeping cannot help
   drain?

Thanks,

Yunzhao

--000000000000299200064d403688
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><pre class=3D"gmail-bz_comment_text" id=3D"gmail-comment_t=
ext_0" style=3D"font-size:medium;width:50em;color:rgb(0,0,0)">Hello,

On a 384 GB machine with NVMe storage (2x NVMe RAID0, dm-crypt,
XFS, kernel 6.12, AMD EPYC 9684X 96-Core), balance_dirty_pages()=20
throttles writers via io_schedule_timeout(), causing 26-40% IO PSI(full).=
=20
But the throttling doesn&#39;t actually drain dirty pages faster.=20
The flusher only submits ~578 MB/s of writeback regardless of
whether writers are throttled, and the NVMe device has ample
spare capacity (1,044 MB/s benchmarked).

I&#39;d like to understand whether this is expected and what the
right approach is.

The setup
---------

  dirty_background_ratio=3D10, dirty_ratio=3D20 (defaults)
  dirtyable memory: ~77 GB
  -&gt; bg_thresh:       10% * 77 GB         =3D  7.7 GB
  -&gt; freerun ceiling: (20%+10%)/2 * 77 GB =3D 11.7 GB
  -&gt; limit (hard):    20% * 77 GB         =3D 15.5 GB

  Write generation:   ~580 MB/s (HTTP cache miss writes)
  Flusher drain rate: ~578 MB/s (device can do 1044 MB/s
                       flusher can&#39;t feed it fast enough)

Below freerun, balance_dirty_pages() returns immediately.
Between freerun and limit, pos_ratio ramps from 2.0 down to 0
via cubic polynomial that tasks sleep proportionally in
io_schedule_timeout(). At limit, pos_ratio=3D0 and all writers
block (max 200ms sleep).

Generation =E2=89=88 drain, so dirty settles at 10-14 GB =E2=80=94 crossing
the freerun ceiling into the proportional throttle zone.

The observation
---------------

                 throughput  IO PSI full
  dirty 5-10 GB:  494 MB/s       1.4%
  dirty &gt;10 GB:   578 MB/s      26.2%
                  (dirty still accumulating at +2 MB/s)

  Peak IO PSI full: 39.5%.

The proportional throttle adds 26% IO PSI (full) but dirty
still grows. The flusher is already at its submission ceiling
and sleeping writers doesn&#39;t help it submit I/O faster. The
device is actually starved: writeback-in-flight drops from
6-8 MB (baseline) to 1.8 MB (during throttle), and NVMe QD
drops from 45 to 37. The device could drain more if fed
more, but the flusher can&#39;t feed it faster.

Meanwhile, memory is not scarce:

  Dirty:          16 GB
  Clean file LRU: 57 GB  (instantly reclaimable)
  Memory PSI:     1-2%

The dirty pages aren&#39;t causing memory pressure. 57 GB of clean
pages remain available for instant reclaim. The throttle is
protecting a resource that isn&#39;t scarce, at a cost of 40% IO
PSI (full).

Our workaround plan: dirty_background_ratio=3D5, dirty_ratio=3D40.
This raises freerun to ~17.5 GB, keeping dirty in freerun.
The flusher drains identically. It runs to bg_thresh either
way.

Questions
---------

1. When should balance_dirty_pages() sleep writers? Currently
   the criterion is &quot;dirty &gt; fraction of dirtyable memory.&quot;
   This doesn&#39;t consider whether sleeping actually helps
   drain dirty faster, or whether the remaining clean pages
   are sufficient. Should the decision factor in flusher/
   device saturation or available reclaimable memory?

2. Is tuning dirty_ratio to 30-40% the expected approach for
   high-memory (&gt;256 GB) systems? Documentation doesn&#39;t
   cover this.

3. The freerun ceiling gates entry into the proportional
   throttle path. Even moderate sleeping shows up as IO PSI
   (io_schedule_timeout is accounted as IO stall). Dirty
   never hits the hard limit in our case. It sits in the
   proportional zone, but cumulative PSI from many tasks
   sleeping short durations is already 26-40% (full). Should
   the throttle path be skipped when sleeping cannot help
   drain?

Thanks,
<br></pre><pre class=3D"gmail-bz_comment_text" id=3D"gmail-comment_text_0" =
style=3D"font-size:medium;width:50em;color:rgb(0,0,0)">Yunzhao</pre></div>

--000000000000299200064d403688--

