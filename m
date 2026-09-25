Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C2A2C98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 05:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856676B0093; Fri, 25 Sep 2026 01:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E4F6B0095; Fri, 25 Sep 2026 01:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745DF6B0096; Fri, 25 Sep 2026 01:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BF7A6B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:33:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF943160554
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:33:56 +0000 (UTC)
X-FDA: 85251168072.15.7CDA0CD
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id E469880009
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:33:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=L53bZyiy;
	dmarc=pass (policy=reject) header.from=modal.com;
	spf=pass (imf02.hostedemail.com: domain of ayushr@modal.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=ayushr@modal.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790314434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2+ukOysD2I4kW758/buisnZ71NIZ/Yakkkc+BM/q/w0=;
	b=PaNlzpHQSy0CcQ2mSFqSKeHzDAMq/sTsd59LkPBI/NpKDRVam1xeXyJ0NK5nFBCjJycS9U
	93OtegSwiG1v2+xETo39ZzDj+JMeEQms12lYJHhfxhAN1Zre1XrkyBwR3uc6zRW8wOswwW
	V9UK8bDcm79FbI/IZsHs1cyaoFSw22Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=L53bZyiy;
	dmarc=pass (policy=reject) header.from=modal.com;
	spf=pass (imf02.hostedemail.com: domain of ayushr@modal.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=ayushr@modal.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790314434;
	b=it8h64769uOs/PHtkPQFAbJ6hqJXts/yBAZySIVLgfnkIYFiBETGnrb1gXA2g7JxihMH3u
	UGjiAqLFqSgiH3eH4S3rfTPJ4NOnEiq+oGzcZV5Rr89U5E8Buv/DYONvSpq7ZKqedaswp/
	mmelet3kPEFS5GrbhSBLoVY8KGItQF0=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469a3490bso444297b3a.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 22:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=modal.com; s=google; t=1790314434; x=1790919234; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2+ukOysD2I4kW758/buisnZ71NIZ/Yakkkc+BM/q/w0=;
        b=L53bZyiy5Q9H3QGFMqT0QiaxIYCXaDAV0PYuI95jrAOTmZo1PMAG7UYkVpC2LxzpXt
         InVdwHzLC5b+Fpk64DvWNC4+knbVmRIzHG8OmBriQum+KlyBlpe8MySLb4UYyNXm/qVf
         U00mwFFulADpb+HTbpJSq+rxPeANFosCgeR/+UmHy6/4fOB8HWdSL/6QcsKrbynLoWoB
         y6n+H6Ea8A2C/FEzlWnd24tC9C/odSUTk5VxbyjABVSuIe82PYlHb3XfbBbiC5hAOCqJ
         9LaGjMZJup/LBRnW93C526EKLgkzajeTEiCjBQWJolJqRzOmjXTJy1hAWBKJ/6gMOLEd
         pqyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790314434; x=1790919234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2+ukOysD2I4kW758/buisnZ71NIZ/Yakkkc+BM/q/w0=;
        b=T7SOnJ+x6mIw/6z1Vo3p0z0ouQILvLZkIM2neN9NTMTQuMRm+YrAs61iXuYmqRH9yO
         K3e3QM+sdMsZuQyumB1WKBE1mU0s82Eg/WvjV2wHjY5Qz68KzXAcJAUymT02Geq5/dHU
         k45fT/L1M4CdU2VqJTL9Qen11b0SARfOLG+/IPEtMxbbVYDbXPBuOsq0MU6PH0iSGAHC
         iSGS7Uehn+7iY1J920PgUlbJOXNXb01Nykeuf6zW/PJEZ4h2WjGi4AVMpLCIGw2fa7ww
         yvL7o13a6NdWYVaEHVFxLaTnaStKiYA0UW7Cf9u3fPwyK7hfR07pxXsH5P5nf4geRWGF
         1Uww==
X-Forwarded-Encrypted: i=1; AKwUvBxjXXYIimxSsKOxW3clt4ayAx01h/bH5CiZRkL21jw0ygjXJgHRLjaLXwzt0GSqYWxWLL0KzALX5w==@kvack.org
X-Gm-Message-State: AFuF++kQO33grUvmSQ7K6pdkmVA+SR5nLn/g1DzFpcjx0wyBmFX+L81r
	TnX7YqQy4OdPrcHO61sifG2ucnPin7weGxCks0HBKMnxzfX5VqT3mifVdLFQl5GU6R/ELqm7/3k
	Ymt6jP5s=
X-Gm-Gg: AYBFou3kUeP8SpuQhJhmPMnYjhCaEeLa/i32bXIq0MiTaUkkDpNifWknRR9WRFgb7BH
	bJZ018Iv2LvEpn+VBf45NYsQ+nI1NgUY86Rr64LYVBCKl+pzsLuwcGBkF0ErWSdF8BXbQ6nL0qt
	g8QiNu4d2bXIexCgsppv6g9cpD2Ze4P9xQonsviQbWm1n+eEbpNoEk2PFvfuwkCwZOEYvZu9MaC
	FpLTRcUxtp0xCOxHWzZXDboNhJyGPYbLcPzIh8efH3u//fsE5xBIGZ3bHDAODyi7D7368S4YpWc
	mLwZ16U4rpm3bZjTtj8tgpCQmi9qix9Y3XvHhXRI0ptUl9/sti5SUlN/dYbzEcjZgTndbeEzCMz
	+Nf3GG2aYPAJoKUYxzrMOA7v2DJ+X+bnjUJfYzC7rLWi/0Zw56e/+qq1bB4jeWBU6xTUmJJevl4
	ZtgvDuxhQTgoDc7QZMBcnLXPJ6x9N31WKtVSi2dNiGyQSneGad+BxcCYioKD6mVzF/KAMVaVnKv
	KqXS23iy76XCrwoF+txfP7misYXX+w/rRsIhNucoSETQM4zHOa7oYaPmX0N5JyykA9y50+jMi/u
	qe7chMnm1npxS52QE6wHNiJ+je6f859F+FGdjg==
X-Received: by 2002:a05:6a00:6c91:b0:878:34d7:6982 with SMTP id d2e1a72fcca58-8802d04f355mr829494b3a.48.1790314433582;
        Thu, 24 Sep 2026 22:33:53 -0700 (PDT)
Received: from devbox-ayushr-01ed.tail5292b.ts.net (ec2-44-242-192-44.us-west-2.compute.amazonaws.com. [44.242.192.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87fea88a1a2sm509721b3a.25.2026.09.24.22.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 22:33:50 -0700 (PDT)
From: Ayush Ranjan <ayushr@modal.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ayush Ranjan <ayushr@modal.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts page cache / rss counters
Date: Fri, 25 Sep 2026 05:33:39 +0000
Message-ID: <20260925053340.2067567-1-ayushr@modal.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <61f8a9af-7cdc-4979-bcc0-bcc932f7301f@linux.alibaba.com>
References: <20260924061708.1645968-1-ayushr@modal.com> <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net> <61f8a9af-7cdc-4979-bcc0-bcc932f7301f@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: rxzkctw553mhbe4sbajct838yjx68xp8
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E469880009
X-HE-Tag: 1790314434-393366
X-HE-Meta: U2FsdGVkX19BlQEdlbWJ2xcWoP+K0cGIC085DfXWFj6j8ItfT0jjHu6VhGhoUtbTKYeq+cvierAJKvrO6ejd4sG9nxGjypShekk+Oq2vx+UIyUWt5U2DGjefCYWGDg+zj2neTCkHOrYT8bCQBVB4nCIq7+3R1r9QXMf0ZQ2wFF1PANGYpNI8EKb1Crwg8Yt+Ybnxm9n4tE9ALZLiwq7+t/kQ35lkhCD8dbT/tH8GuD7THv3xKJj40qyLHTcmkghFfw97Ezy+yiBLuMeMiGikC9xIxfMk1CtL+z6DaJHunXyWLS7HW2C8KjukHZ4OCih9iSmJbO3JggscDqCvbbmv7UiArSHH6e1RUmASUb2NYuSbmplF4hSHP/tffszjhZOuMiD60uvsrvfDKuFjiGQJ3aaoxxoIRdfufOzEB5vWzw71luuCvPKmozJbjitbGTPXHizLVPcrde+1ZDC5c6qB6dk9vTd2+TQq963GwQxJQSlIW1BXWhjV9F8KJLNacD7cgv4FxwvBcenbIBTahkh8PxM9jeefz0eioY95BvEvUgttpydYb1tB0nUpkliM5c5RA5IBvlFTSj/PAMiEtX/w0qOqQ6RtiCPuLZytuOlRU/4tnEsDYV1EZuPJVDCyxpBZWTCqo/vz4fkexkCHBe1X3d3ZYoETGOEKSVa2HOOxhslkObwkfYjHQmOr669uLQu2uR7QM/BHzDFbMg8xFjUnOk3B38VwBX9ydhoBvOKpX0qGp7mjlz9jZhT1pfVp+vBHAZd2sRR6ZiixisOqfXBtM9dmNfc8bv+O24ppgrBara3oLWY2eVjIrhIM+8/6vH2KyES/x3AUwHtl3aWMA0hXZ3MRHfD6y4oJiLJjH/T4/icQ/jwvpFd3VyFbIv7GW3ipB3HCK0URLt2pWXU8O2jtSr3IGQwaKLjF2fGcTDRo4ytOWknVU/STWrV3UcCPle3Z2EuOIi5qqcIbciW1qyO
 NFvb9igi
 GG5nB/Wzq8B0i2vNIwlk18JVC99IqwtRH+gPe5XQtAiNSqkFoIjsOUlHWfRssvChLenj8xhKt18216N/vyUsxkGAT/QlNGqcd4ysuUlEMDihGOD9p2yR9mgoqE0Zxv1FqqLsQy5KFAfCWqdAAOxI8uAM4IziHw9xR3SPZiBKTeL/FfkCSFvSXoPFIpCvSdFXuErbPSFHeZs2yh2+tl+nvgW4PlseTdsWP+R7JcQzS7GH5BYtEqZ6+Dwj5YRxDYCATjkQBGT7DNw2NHRyWMUAxTamzEbtbNiv56qixjp3z82T7OWg57iB79aVidl9WfCFOOXv5Sdz+CGT994Pe7/vZRo7y2VMJ/ca67Qb+QE1Ru8ncwV9co1OfwHV0NAVDMr02RmYGl+pxyU30xZd3OjsHeuwYrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 09:30 +0000, Baolin Wang wrote:
> However, I did previously fix a race between filemap_map_pages() and
> truncation that caused incorrect folio mappings, and I believe this race
> also exists in shmem. Ayush, could you check whether that fix is present
> in your kernel?
>
> f58df566524e ("mm: filemap: fix nr_pages calculation overflow in
> filemap_map_pages()")

It is present on the UEK 6.12.0-204; its changelog lists f58df566524e
(as the CVE-2026-31648 fix), and the rss-counter imbalance still
reproduces on that kernel.

One more data point that may help: the reproducer punches with
FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE and never changes i_size
(and all faults are below i_size), so the i_size-shrink window that
commit closes should not be in play at all. That seems consistent with
your suspicion that a shmem analogue of the race remains unfixed.

> I've been trying to reproduce the issue on v7.3.0-rc1 for half an hour
> now with Ayush's reproducer, but haven't been able to trigger it.

Thank you for trying. Two things that were essential on my side, in
case either did not make it into your run:

  - the khugepaged tunables from the report (scan_sleep_millisecs=1,
    pages_to_scan=4096, max_ptes_none=511): with the default 10s scan
    interval it never reproduced for me either;

  - shmem_enabled=always, and many parallel instances on a large
    machine (nproc/3 instances on a 112-CPU box; it takes ~2-5 minutes
    to trip).

That said, I should be upfront that the reproducer has so far only
triggered the corruption on the UEK8 6.12 kernel -- not on our 6.18.46
hosts, even though the production workload hits both splat forms there
(kernel list in my reply to Pedro). So the reproducer is clearly
missing some ingredient of the production workload...

Thanks,
Ayush

