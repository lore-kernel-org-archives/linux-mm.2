Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23846CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 03:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EC9E6B0088; Sun,  7 Jun 2026 23:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D066B008A; Sun,  7 Jun 2026 23:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B37B6B008C; Sun,  7 Jun 2026 23:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F04AF6B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 23:32:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B9604090C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:32:13 +0000 (UTC)
X-FDA: 84855322146.26.B393E10
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7CBCD140003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:32:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lhur06mW;
	spf=pass (imf26.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780889531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hVEHUeXPEsnvmIwfhxm/kSVMelwzxdhJwmVWg0LJjCg=;
	b=h8cg/a2FF/k2fWGiQBgfyJ5i9UEyREx0kVykxYjlU97zF9vlSbbZ7REPNdxfYO8NoO7PW3
	ugcyr9QOKL2uofGTAtS0HFsCRnIRQJOehDv44NBzK9yBjRPRgVVyOk4UxpCtO52JjuyumB
	wV+Z4GMNOqIXL5pa8O65CbpGvG6VRis=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780889531;
	b=nkw0fJnbnVA8I8UY3jKxxTxI92/ati/GccY5qh0mS7APKBlmu7gii6S+d42MB/PiqHNZCZ
	fe7zIOJN3p53grIxWZ0kOdJ3Z948vUazvYjgeVcy8m5xXCNZLMZ3d0RAajGF/QqKlS16U5
	lnNEva9I1xgqM5E2eERNgUXZ1QPIC0w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lhur06mW;
	spf=pass (imf26.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c0c2d8b95bso25880685ad.1
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 20:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780889530; x=1781494330; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :mail-followup-to:references:in-reply-to:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hVEHUeXPEsnvmIwfhxm/kSVMelwzxdhJwmVWg0LJjCg=;
        b=lhur06mWtOkQBv2nFMQ1cuJbHeg9Nl0rqiWFG7Bpw0cVkgD65vOIV0gO/8ArKCmQWn
         ecIfXGUj3s9NtUX9BrLtqNKzQQRArKZ6779StvpEhVC859Jj/UyineHS71xmQmxXdk9B
         LSxDys8tWo4oNrvawJa0cBIQSlKwUhZO7lMcs5h+Vyv5AZF7ZlUJsCCCoif8PqOnmbPF
         Y9E9etjIrSvltbx3/PuPslEKW09urv5relov/H+AOCkPaX4CJw+qREb6ry/BF/ptjbCm
         j3YF3U7rVtmttYlAeeYivWPw503WRwclTRMPKC9GQMfBHQJIAz6GatLeUHRb1FFMAcyN
         B8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780889530; x=1781494330;
        h=content-transfer-encoding:content-disposition:mime-version
         :mail-followup-to:references:in-reply-to:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hVEHUeXPEsnvmIwfhxm/kSVMelwzxdhJwmVWg0LJjCg=;
        b=MHr79xryLRFZkv6FemkM6M1efiMEvvKc9yJa9aFxVzA5m56F2djAVfPV6JFLE4ROH9
         lYFNZ5/Ovi3dYsA5uQaNzrPa8L5Ufg0vEIxn5Cgts/ii+r+hxrI/LYj0BCupiKuQp8PN
         DlkOHW+Tn7W1Q54aJpeVUyIwVT7lDkhXWsRD1grSi88erqvSVOHrnJRELYz7Su/xocd6
         80WnINVZsgXYM44becE+yMVIdSJtHgTbwP+aWEyxeKbX+HqGzysH72hXZI+UoSCtsDUc
         IbDQrh//C26vWhfKatTd4BAso5/ZeC+Z7n2EUDM0pTI/o9W7hqg6D4i0BesqoWBaWzNU
         zTjg==
X-Forwarded-Encrypted: i=1; AFNElJ9miIRBQJZp87GObKxCT7DSyQw2yyWez3qCCJ7dnERwbQoNCBfIjOU4pkZddI7joJsbTAAUiAy9kw==@kvack.org
X-Gm-Message-State: AOJu0YwE5N/uC45Q/xnffrindXH6i3nlg0gRS8MFPV1pHLBjVHXJEd5k
	AEHROyD8uwwciRIIFu+50MrmkxZ1KnPLwEwRMGg7xLNl3NwqmdePWtzc
X-Gm-Gg: Acq92OHLet+xh/6NPhkfO59xJdOzqW4k7nFeM7jwFFOOQtgfyLpoT0HSWgL4Jghh4Af
	+Yc1imom2vRqKeD2c8HYhCxExAQoFkfHNkcBePk61Vufbn/LfNXQjQ9w5oCSch5/6tDvDbIqe6Q
	opzaNAqrPtJamoRltxd2OjTIfns1RnTPLk6LqTQ2QDvgS17OUwhe3eLPyN3OoQe8M2EieYw0tUN
	WjixBr33DoQeElxwl1mpB7klhbn36hTzIaUJ5eE3CU+sM6g+h/2tJivwHz8/lS4EyuPIt37zV2Q
	Yy5VfqfvXOLSof8nrZUssB92rto+bHkeUZ/WqYUuP7R/T0olUyM/vZ8a2j7Jq7Oqn/P47QQRE8c
	/F2zm6mwKa56YWU7ycI5q0mQTA+QyotJlew0jaLHc+pVUFFqY1CVvhY/ilES1rZOd1aWCOK3l3I
	RD83XXaIpzNjWvcM9FimT7wFsXjWWTR0YYP28yGXfPGhL5+mE=
X-Received: by 2002:a17:903:1a10:b0:2bd:606d:b342 with SMTP id d9443c01a7336-2c1e881ff09mr156981155ad.26.1780889530187;
        Sun, 07 Jun 2026 20:32:10 -0700 (PDT)
Received: from localhost.localdomain ([116.80.91.208])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16649d2dfsm163430945ad.75.2026.06.07.20.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 20:32:09 -0700 (PDT)
From: Cunlong Li <shenxiaogll@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/vaddr: drop redundant mmap_read_lock from damon_va_three_regions
Date: Mon,  8 Jun 2026 11:32:05 +0800
Message-Id: <aiY3tCGC06k46wOG@debian>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260607173644.93883-1-sj@kernel.org>
References: <20260607-rcu-v1-1-3c9f5995a3a0@gmail.com> <20260607173644.93883-1-sj@kernel.org>
Mail-Followup-To: Cunlong Li <shenxiaogll@gmail.com>, SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7CBCD140003
X-Stat-Signature: uw3wc833bhmf99htxszmogyc5f1u3gpr
X-HE-Tag: 1780889531-10663
X-HE-Meta: U2FsdGVkX18GJEhdtSx6IBsR5OIx/V1vH548E8yraMcnf+BMRI18j454umrVRq/F7OputuHlPNo2k/58Fno72ajdvl5l7PolsnKN3bfGpYzlZDSh3epXrzB/Z/9NCABNgI755XzP5LmycpYLwUNZ+bvAbxGswEAYJdshM/HD6TL4N0uActf6qxB7LnyO7r+OpXbcLZa04h88oqn3pJCisaCvU4wKvuGx1h7euRFBIwYjpNZV2NK1kfYTZHRtK6E4sFDKVOED37Nr9szCutYbwI7YOQqj5nbwWZ4zGnxkpGodj0/KHMC6n9Sqc/PdwklqoUK0HyIDfirSRCs+V7B28lsGz4mxWGoV3BhzkdZc+oazCmorQIIu/di+/Ghwh5D/6TKya76jeyAgEhFjWpnFiMFSO6U6voKt8IfZ1Y4090c3bl7lDogGv2agNLXhytXHjEzITc9DKtPcuT86Yqc58k8uHz5fQcE4h5ZkExuBmGCRz3oV8/yG8JE8//gHnMu1fciQ7uvm3UIUL2WDSURyvKkGTtRxIAHemVE9D/wDiFbvALtaaANH7nwn2Gsf6N6ltrWgSwoKh2E0V92utiEv4en40nkYXVkYKkuY/ioJnJlLs9tNwMEoisAHSUlGSeKrYS8WSk3aF22jmgGwTgR2x2UeH9KCSsiwIzMvwcGGUD8xF5f0fpKnoMRmAl1EEVVPTDK9/QHSO0ojUOG6054AhDYg5+jKLUGK57IEhV0LWnmsYiokFuKkn5eI3t9Kh1SBBQlIv6Jw0PA4gelM/FHpKCgiSMddkGr9ARQyE2jYVNzsSIwm7ciT9M1683N4vixxQeQ6DoqvNtxM1CMB/7myTiTC/x/vNEKu97/pUGpoaerp/G9nJD9C9OA8RhglO1QlWXV/5ogKPpn+UeTZHqwSPl2H/ggNrr91i9ciyBG0DdqBwNbm9bVoAaAw9XB16D7vUqEBB8whSMbgkXKBDQa
 n+kNxVT0
 gvT+hiWdLgtvZ6xlOLEg4/tf/tkegIIJTsHB9jve4WF7PaHKhmaJMtbAjRNxGcdjQJ8g4fWoUEnWaqhxH2Kr4czkJ+HcMGoOTgNeMbfSwcXBYy9/im1Ak4l7OWpOuEP429bGR6UVhnJxqek+XDQoLc2sn5xlLe7JcBj3VGgyPPKc6QW0dyzW6+qNBdZS4FjyGcdlqyYAR7/Fd36S2CurkLX9Zbcf8otZdeMoitaqsjtU1KJ7M+HIVPHOsMJIikQKpEhNx+idH8+RPA0xUEJL9gXbzMYe/dX4yxb/95p5l6pLpIzcMbgT4uGzy9cSfDTNOsKdrGmuNxZ6sanEw14pWM0ZmqO3hNfL7wEFNtCpF2BVHnB6q6WhxczHBaE6965ds6BPK88gzCMyY6d0ZYJEFnZeGY93+qnmbMl46owCxGCtBX4mC31faYfX4p9wiTEFj4SLnnezHa6EpSvzaHRR0OHXWyA81Hp4FY0fibfQsKacpKoY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 07, 2026 at 10:36:44AM -0700, SeongJae Park wrote:
> Hello Cunlong,
> 
> On Sun, 07 Jun 2026 21:48:52 +0800 Cunlong Li <shenxiaogll@gmail.com> wrote:
> 
> > __damon_va_three_regions() already walks VMAs under rcu_read_lock(), so
> > the outer mmap_read_lock() is no longer needed.
> 
> The function aims to read a snapshot of the virtual address space.  So I think
> mmap_read_lock() is still required.  Please let me know if I'm missing
> something.
> 
> 
> Thanks,
> SJ
> 
> [...]

Yes — I understand this path is meant to obtain a snapshot of the VMA layout.

My thinking was that an exact snapshot may not be required here, and
the RCU-protected traversal inside __damon_va_three_regions() already
makes the walk safe, so the outer mmap_read_lock() might be redundant.

But, if we want a consistent VMA layout here, mmap_read_lock() is the
right mechanism and rcu_read_lock() alone is not enough.  I'll drop
the patch :)

Thanks,
Cunlong

