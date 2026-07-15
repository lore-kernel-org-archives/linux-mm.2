Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90DD4C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF346B0096; Wed, 15 Jul 2026 12:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F716B0098; Wed, 15 Jul 2026 12:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DFCF6B0099; Wed, 15 Jul 2026 12:39:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4C26B0096
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:39:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7934C0209
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:39:43 +0000 (UTC)
X-FDA: 84991572246.23.3876906
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id D602880007
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:39:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j7acuO2z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784133581;
	b=r53vNbMgbRgdagHUWnNXgaranGeIVihPY/mkDrqESVHiw4pzo+JgLAkkYoTDxty1fZbAOw
	7Ww8hrVDrmlsgMUTxRDQmqA6AiQbgvyFLXy2gtNorKDct3qlwM6p6t+E6vxDW09Vl9C5lJ
	eqZvxpab9OEcTa+u+GNP1Y1oCxGI8xE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j7acuO2z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784133581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=or7RxpRNzsjVzPQB5YJNcUrM8L7o9Zk9H3H5s18AhOk=;
	b=vCaKZiZf+5tUC/yaxhZtdtE25yVnl7/Apg31ZiQ8b3T/dCpnSzn7I9ve47yOueJ66GSACV
	Gym6QDPfoVuGG9tCjWja1+esedftCOFlRGiAF+Qb0eORtV+iiSg+x30sxnm0V/UiWaGtiq
	ogQ5iBjosAclxl+yD4qeLX/qH8bAGSs=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-caf707e3a70so652569a12.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784133581; x=1784738381; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=or7RxpRNzsjVzPQB5YJNcUrM8L7o9Zk9H3H5s18AhOk=;
        b=j7acuO2zO8NAVbhkrWRKB8GFXEeK0wADdpHssj80n2SFgFhDf8WyUZg+plg2y1Eaaa
         iwLYL8tW9bhbpglS8eEaiJgZmfOuIKpFRGIYzKZSPtg0P6GsbYG7HNJBwoGfKGjJlLf3
         kT6PiuvzJNu544bcKAxG3xydj/Ro7ZEZUhHk8Bo6tQmwGLPjTTJ/dRavi/4xY+hNdF9O
         Lm+c2mRipJ+30/8Vtpl2lqy9q+mDFvXe0aP7f/FcpV094E1GLPk7PzQXREee2tsqBi1D
         gL09ibfZzM1oWV5DQhOhV2L4hdpx6xUrJo+iXkYwA12anXUoQlvoTfGYNPVZ38wEmc+k
         dwUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784133581; x=1784738381;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=or7RxpRNzsjVzPQB5YJNcUrM8L7o9Zk9H3H5s18AhOk=;
        b=HSo6theKeoUCSxkRE1vRpuye3Q4G4c7MzbR6TMyrUWirj8gJdkd2ZDUp5VLJ+yHKwa
         S/utVMgs/v4V7RU28hHiuXm1CrnwKWSk8eXiTsvlT0n+azEo1qqDb+b6pTLMtkJZ6L7S
         BFzV0jlrhM6I9qJh0qvuco30E1Yz8aEsknl+AET6HFxokU36bHwM0cTWMgimnA+WXsD+
         i2zwfNfgD9Kmzaf4ilY6irCKuE6hjLHD+DtJMl2agAovjupbTVUhev7ylYqpk5la5FgO
         NaGOvd4rYTUBs9SC6KS+ZBcJtp5Hg7VoUloRzWHG+SLVgwsaGf5fIZNVXhVuJE34FAvU
         /Idw==
X-Forwarded-Encrypted: i=1; AHgh+RqnabsFXeA6HKMz44QzNCwC6NtEM/nKyeh7mijvOqgt2Kd9wlbXBaHXyfk8/SUXFq4oNYxnptB7zg==@kvack.org
X-Gm-Message-State: AOJu0YzapSeQJZ3QRLHzZmNcq6idZ53EPXT+5pyWM2eWC66d9i8X2gPk
	Xy0gY1ZeSciJrht/nsXNvM0Lf/XSulLPegCfbQMs17r3Aya1U0PAWmi7
X-Gm-Gg: AfdE7cmzo0/HSzYWgW1JnrpOhNb8P9t/TTNys6of0Rm4fVe4m84BOUYe9xn2pd8GFb9
	eLyxNFH5B7d0+xY0WNiarlMGGqI6X45VrTv8ptS+oUx+8w83qQIUHgfnvwabxyADWx5Wy28/Ktm
	uTh5nvVvT+A+vhKuTICGxnlCZLilXoO5+PIrycIoet7n7RjhZQA7oK2QOGDl8zIJRIfhaXqmU4m
	lz6ZxLWNt6HCwiREyzuxCWABRgQ3rx74hUeN0yA4eNZ6jcwLDnxSxUlKMk0o7Zk0/6vBT3dbwp6
	XS2Nl8blZNHTb6325Hd9JgSsQVkIQSX8UVLpmaT6sYHS6617Brx5b+IKEV+yHpFyJmP1INHUzVv
	3saeDDAVzWuyoJc1mFIWkZMrQhkRxaK5dE58QrpnV1VD/kY88V/Pn1mwJsx+xqyHHvJxLIxW4f4
	FAliIAgLrwzCDY6dn1raxVMrf+gSp6R8mdYb5uC/yIO/dggt8S75Y5KD8S7zPwujoTGA==
X-Received: by 2002:a05:6a21:7785:b0:3c3:682d:9fbb with SMTP id adf61e73a8af0-3c384b91e5amr105261637.21.1784133580580;
        Wed, 15 Jul 2026 09:39:40 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258fd10d2sm486006a12.16.2026.07.15.09.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 09:39:39 -0700 (PDT)
Date: Wed, 15 Jul 2026 09:39:37 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, airlied@gmail.com,
	akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org, corbet@lwn.net,
	dakr@kernel.org, jgg@ziepe.ca, kees@kernel.org, leon@kernel.org,
	liam@infradead.org, lizhi.hou@amd.com, lyude@redhat.com,
	maarten.lankhorst@linux.intel.com, mamin506@gmail.com,
	mhocko@suse.com, mripard@kernel.org, nouveau@lists.freedesktop.org,
	ogabbay@kernel.org, oleg@redhat.com, rppt@kernel.org,
	shuah@kernel.org, simona@ffwll.ch, skhan@linuxfoundation.org,
	surenb@google.com, tzimmermann@suse.de, vbabka@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] mm/hmm: Clarify notifier retry state and scope
 HMM timeouts
Message-ID: <ale3ydkx1xt6ruuP@skinsburskii>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
 <4300f09b-8f93-4605-b072-7c09a82cb16e@kernel.org>
 <alecaJ1FUso39D9k@skinsburskii>
 <alet21wLwM6P_Km2@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alet21wLwM6P_Km2@lucifer>
X-Rspamd-Queue-Id: D602880007
X-Rspam-User: 
X-Stat-Signature: 3ng3gbj5w3a3tabrzdt49co6oifjzwhj
X-Rspamd-Server: rspam03
X-HE-Tag: 1784133581-245909
X-HE-Meta: U2FsdGVkX1/eO2kJ+e13Zts74cbvPsqVWl8CNo9ao6pIc+Jcu8ghI1Eb2Fz19O6UcaVS4PIyMRXFrBlqf7D5/ZcfmH1iEF2SBok0behpKz0bafKut0p+qsX3wGEHk/7aEtCf2IbEW07WlYBYcV+w1+I2hKjsy9Wt6fjShmfJV7vkoZjm9xCfy81etZTPLU8EcmStSGpuymAJo+dFrNGabiPenmhAAs0Iqc25ybGrx5/P71Q4RHB454LEpK91jsTF/hp7nyU/e6tW4Ym4yn3Q54CPdqTmCXQk1aPicAShmGlepCtD/Rlx8G1rTSvFf4Z8Wdv33j4szedPgrzcgoXY/i/RgqfzWHf9BpTxP8f31bZnAsKkNgK49gjT4eHKRUkQ+Q3WAJf8dK3Qz3OQGkFoRc/0wyni4odkiyB6TiSjSweEY/5s1RVbScX31Gy/dNETA+/ZYGbxToiE+XxLxOb766C0DndMLIe7mNQxsG2tWOL+xxWSzENEoYPPSE8K0AaKGeWuJH3rd6/KOY/+sYsFtCNVGRgNyEF7MtGFHKVQU8dc8/eODsc0xJ9N+3bbdgAm+Z9iQeaNyHCZrEVBy0NnxU2Wap+gKJcLNOQs3RMfGEZ8ETBpOpROeBhjUp91OWjPohB6KAi0m1TD7mCYs8/oYmmznLThcV3uUfWe/I/EPj7ARbAyeUJAQxNLfDADhuEp0+YjFTF2B6g3utdqMau78HbweRYUwVBDD+hUzn3o8EbYb7PXBq0KE47ouGi2O6vFNJOicnEsZOxDpdD1/nth8hhkx5YtcWeN6ahDEA5ZaDbeDf9KdPsX8ipB9zekR/WJdd7f8lR5Tw/MVbw93yJlhctOH3tyCzTOw1UZkQ54nH4lyRbuYHrMbYTGdqee9c3+5kMzNUpFQnPuKE2Uh78kDjsZlow6YFlcB7oKj9+wnSBRzQjifwoygI130Axj+ZAB18KLgwEmkvGaHd6qIQF
 y7vCrOUR
 Aic4AoCVGyvPwQUe1uiyNNBXFihvakqXg4sE2ILklfcJHn3NvznaAw9sFeyAJiUbRxVP9mnwblPOJewdk/g+vzy3fa31eyL5KuCxLi1Y/gse9ltrgtC+56SMuk3gPrwJXHqtOUpwb/BA1aWPbsTlLQOhjmLgem79LYNCjWu3QC7jhYj9PwWO6Wu7p8712KrOxpNMoqve8tOJ5Bm4w/OM/60zuCfowBqht+ZqG4VU9aNCDtEJ6SV9UFtEmt6NFRp/NQmCr+i0Wp8lIJl5mgn7ydcvXWV22EgCxbHBhwmBzqAJWxbcKBr0M7k/TYnV2UoDCRaWORY1DjTnVflyiCeJhWPIAvWGjeU2j7qwdFHj+yE+RmqsRsXnlbdrucbMTKkzkmp6b2yll/rSY0SBe83X/xsWabgge4nZ9Zy51PQtJ3618P8JXqJtJwRjC3fH8ILg461KYzndsThky0Q1TYQx28Lr2Xrzofy0aer1kptJ2kluXXXxJ0ycrcCUlHlpZ96yzMenYzaLYPKI2KDo+V1D4WVceyTvPZpjBU/7z+0ORTwRh72lZ0clkHv3cNHOyCkw0jdwA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 05:02:59PM +0100, Lorenzo Stoakes (ARM) wrote:
> To avoid confusion: obviously please don't merge this series Andrew.
> 
> On Wed, Jul 15, 2026 at 07:42:48AM -0700, Stanislav Kinsburskii wrote:
> > On Wed, Jul 15, 2026 at 02:41:43PM +0200, David Hildenbrand (Arm) wrote:
> > > On 7/15/26 00:21, Stanislav Kinsburskii wrote:
> > > > This small fixup series applies on top of:
> > > >
> > > >   [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for userfaultfd-backed mappings
> > > >
> > > > The first patch updates the HMM documentation example to make the
> > > > mmu_interval_read_retry() state explicit: callers should use the notifier and
> > > > notifier_seq stored in the same hmm_range that was passed to
> > > > hmm_range_fault_unlocked_timeout().
> > > >
> > > > The remaining patches adjust nouveau, amdxdna, and drm_gpusvm users so the
> > > > timeout passed to hmm_range_fault_unlocked_timeout() is treated as a relative
> > > > HMM retry budget. These callers no longer keep an absolute deadline around
> > > > their outer driver retry loops or pass a computed remaining time into HMM.
> > > >
> > > > This keeps the timeout scoped to HMM's internal mmu-notifier retry handling. If
> > > > HMM succeeds and the driver later observes an invalidation through
> > > > mmu_interval_read_retry(), the driver retries the operation with a fresh HMM
> > > > retry budget.
> > > >
> > > > Changes in v2:
> > > >   - Kept the nouveau outer absolute timeout around the
> > > >     mmu_interval_read_retry() loop. hmm_range_fault_unlocked_timeout() only
> > > >     bounds HMM’s internal retries, while nouveau faults are handled from a GPU
> > > >     fault worker, so userspace fatal signals cannot break an endless stream of
> > > >     invalidations there.
> > > >   - Updated nouveau to use time_after_eq() before calling HMM, so the remaining
> > > >     timeout passed to hmm_range_fault_unlocked_timeout() is always positive and
> > > >     never 0, which would mean retry indefinitely.
> > > >   - Updated the nouveau fixup commit message to explain the worker-thread
> > > >     timeout issue and the time_after_eq() boundary behavior.
> > > >   - Fixed the amdxdna fixup commit message. It now describes
> > > >     aie2_populate_range() correctly instead of carrying stale nouveau prose,
> > > >     and notes that command submission still keeps its broader timeout while HMM
> > > >     gets a fresh relative retry budget.
> > > >
> > > >
> > > > ---
> > > >
> > > > Stanislav Kinsburskii (4):
> > > >       fixup! mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support
> > > >       fixup! drm/nouveau: use hmm_range_fault_unlocked_timeout() for SVM faults
> > > >       fixup! accel/amdxdna: use hmm_range_fault_unlocked_timeout() for range population
> > > >       fixup! drm/gpusvm: use hmm_range_fault_unlocked_timeout() for range faults
> > >
> > > Why a fixup series instead of properly resending the full thing?
> > >
> >
> > The goal was to get a Sashiko review, and v8 has already been applied to
> > both `mm-new` and `linux-next`.
> 
> Please don't do this, this is completely impossible to track for review :)
> 
> mm review is currently very difficult based on volumes, it'll become impossible
> to manage if people sound fragments of series.
> 
> Please just resend the whole thing at this point.
> 

Well, I followed the guidance provided by Andrew, and I believe he
applied all of the changes, including these, to the `mm` tree.

Do you still want me to send v9 under these circumstances?

Thanks, Stanislav

> >
> > You can find more details here:
> >
> >   https://sashiko.dev/#/message/alaWmUEeIBeSkmO0%40skinsburskii
> >
> > Thanks, Stanislav
> >
> > > --
> > > Cheers,
> > >
> > > David
> 
> Thanks, Lorenzo

