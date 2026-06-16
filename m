Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3FF4CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:40:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C353F6B00DD; Tue, 16 Jun 2026 17:40:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE57A6B00DE; Tue, 16 Jun 2026 17:40:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87226B00E1; Tue, 16 Jun 2026 17:40:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 670246B00DD
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:40:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C111212023D
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:40:03 +0000 (UTC)
X-FDA: 84887093886.23.021FFE6
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id B159240002
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:40:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="LOlbX/Ra";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781646001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvNzegJ7+heyexsBUGAQ0jwoVUjk7efTCiVuRf1VOy0=;
	b=GSlF9hYuxhrFknEkh+li7iz2HBJcDsPLOmoeHqep29hLtjRNd+Chlr47rgWhTt8JJrWGnP
	OX3dt7+ZtOw39PbSCWMJFyD4oYNzAsf2Eqs26rQynpE66HL9tYV7g4MV1Pfs0SOke1Z1Oe
	ill2dFKtU5MNIKhDn3+T7B6g4jeaVtg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="LOlbX/Ra";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781646001;
	b=rtPvwjG7ffIyNkEXPeTJOKm5ZFQRg3ylUUKT757mqaSz4yP7kvPBhkdUySdzp4AW5sccvM
	Geg8magee/9NWaMB5x81PLnsUOjfQwaNT+AMk6+IBXy8Nu70vjxnqzzq0HgWK6AytrS6ip
	+9hrYnre7sNO2HlclHNaMP+xPBWX1GA=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-13810b63a1aso11279020c88.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781646000; x=1782250800; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EvNzegJ7+heyexsBUGAQ0jwoVUjk7efTCiVuRf1VOy0=;
        b=LOlbX/Ra1Hy+HKKxp+WbausfgxciqkfVfZXJ/+LAdIk7FXHhecbnlyXQdP/4Fync4K
         rfbL2KvMZPwTJdi+VR7AK53v0W0OLc6DPLy8GOlJQWa3lDULUeqGF0JME5s4dIIJWmxp
         Ihaspjlrrk/1TgLjVSnV8caNoQP+dCqu49V+tluhaMGw71AMEmn0IovuJ7bkgQP7+ARf
         aGW+imavy3KlqKERbm79bnmkVbZyE5xPn7/A2suEc9lA2zGfcreIRtga2dBhId1s+mnq
         dc0tKEMBooMaZ9i6UcvhvOME/kB8y3oi6lWTOQbL7mda/QSAIT9kdAPbc5rlKJ8DD6z7
         fDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781646000; x=1782250800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EvNzegJ7+heyexsBUGAQ0jwoVUjk7efTCiVuRf1VOy0=;
        b=Vn88bM9V65YRyRzJFrxT5s/lMqp9caP//MMYqcu6lANsa3E1dICIoi6XdF/nVjWSeH
         ZkNr7svI3+Ok6NLtplnUwb8ZUCCYFf8xtl7hRZI73W0L6U727eD2R49uxsE/fbcT716Z
         KKwggEaY49/0R+5S9S6Di/+5QwItQ37vuHsuCY7nbrA8Dij9Eer75SG2Wz/AAFck13ZY
         1rlj/eAZ4DkayAFwXpQvuWqVyHeBqGGLEXq5lyjwmcOuAwf8KzNRQb1kXgd5Rw6ADJMq
         mcrqQW6FdCEwJCOtN4jM2Lcrg8u1oPb1joNlkqfBYy2EH7g5I7S1+omvp7lSjE/iUs4J
         y2nA==
X-Forwarded-Encrypted: i=1; AFNElJ9luQlVEViSkiiCfo6k9GI/0wzs8WNGrr43mublRkKx498TXglHFNeenk8gSGe6AUsgdy4o9bL9Wg==@kvack.org
X-Gm-Message-State: AOJu0Ywwz1wOjG24fsQdjUxCXLK7nC/+63WVXO4yCp2i1a9eem+CQLCe
	DF9kNfDUccHiWYpiJbda4tiiDf7Ox9YH/oFAYjAJnZ+xydsBCiFKDbCOGUKXVtGcAM7bhDPqkOn
	I4c9f
X-Gm-Gg: Acq92OEFsDAj92Di3uelwC13XyagjiMJIPlWL9x9KJy8eqvfdTLTh0siUZLyKwdqh3j
	73ZvkAF2GpEqWnBvGY55AduPXpc+H723Atd9KjGIKMesMq13FCQjGX86chexjWRaZy6grLKfuJS
	EV76NQkqnBWLwhkz4mkUDYrhq5U/IhY/oTb19hhWdEK8hFUgo2XowfHdtnPSX3dOcIKv2ZoBASi
	+/PuOlo4tG1jdaSrO5JMJnvRVGYFb9mYCUwdZpdGLn99pZC39eXRNudKCqz8kGukULaPFjM5c+B
	LTRFFGmc4kzneworh+Ykrl9ybi3/zhTBrqBFARV5nDkkuNfsVovrcLmwEuMC0UOzf1ojS4qGf6B
	F0p0N49Y1hxzEXUQ52udsAqszC9FyQGbASI5UDTFLcxPSxjv7oUJlfNnfP7+00kUnw6F4eFPom7
	/t6KiaBhY5zM4iACl6Dq/P
X-Received: by 2002:a05:622a:a6d4:b0:517:7e3a:5ee1 with SMTP id d75a77b69052e-519916d65f2mr43449041cf.1.1781617631680;
        Tue, 16 Jun 2026 06:47:11 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:500::3:437e])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb84188asm150577021cf.29.2026.06.16.06.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 06:47:10 -0700 (PDT)
Date: Tue, 16 Jun 2026 09:47:07 -0400
From: Gregory Price <gourry@gourry.net>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory
 Nodes (w/ Compressed RAM)
Message-ID: <ajFT235iYsSJ7nbR@gourry-fedora-PF4VCD3F>
References: <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
 <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
 <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>
 <ainFROZ3WrGioyuY@gourry-fedora-PF4VCD3F>
 <aiwl4kCG814dpX7L@gourry-fedora-PF4VCD3F>
 <9f1815b0-896b-44ab-9e6d-9316d8f11033@kernel.org>
 <DJAGEUY8S09F.3V3HF570G85OF@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJAGEUY8S09F.3V3HF570G85OF@linux.dev>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: fkzawxrz9ecqx5gh33py6npta794fyau
X-Rspamd-Queue-Id: B159240002
X-HE-Tag: 1781646001-703667
X-HE-Meta: U2FsdGVkX1+Nqw2l5OuJZYuxwwUz8monBwM8fBSDvi1f8G8TR6pdywE8F9ZiLSn7ZMR3pANyYDgdGTRGD0DLi/uZqgrp9Sb6M43V2QcWb+DlxlufY9hPcWC0NWh5L7xe3wvHuZ3+llHSmy4B6gxkIKckFu7nevFFaMLuomvRV76Kk7zcg5eTfZikWwsYe+XZD4YDomdKLlvnY+w7jVhvDvm3iu7OneXQwSmnDOt9zOMfKTe8y2EWvUMC/3WOAXUuOZHE+4gSDO2A6GGgR1I4rEJysKXto5993LFHGw03HsBUOVh2Cys7gN1ejKXEzkW7Wz7vq4HN2J8fw0f+gV3WH77LDnkA8BQ3dDv1nHoU+UQDiuxI73BahbawtWCBS/WqU6SBUaNL8gtOSRQIjIjcFojPvHRWjwdVa+m1iDO7RtFalB4GjkZaHaMA/zszAbRfl2jCr1BspACEyJgfVP1myId/Lw/AcX/zEhutW59/V5DGt2UxvhaUW9FwfDT0H2nWcRfYoNOz9fot2i7YSTfu+582O06WWv9t59ykfFC39R5q62Bm+lcvfx1LDIn78nHazQfuTiM+UoO4SZEkdz585Xp+2i4apMvdPF0V8ZFIeTCCjzycNL8SfUGrJ9AxZbTMFQB8daY8C6xaeTnWo2xqQXp9zaMaN4dKHe7C4J5Myai1pYcDE8fcCmZqdvCqIWHjvHThWPPraHvtM0UANSv+FhKmxwx+V4jt70+7i8PNErWUB8jn3r0LhiQ4+k0foSm6cmpKRZ37inO4u1R46v1BwmfzomqrZanTNiZOGHhmmfb8EOEujLLsx2ZurhM9r25sMxyoUoCwxIA3PxoufMOr7GcrFI9gtnkccEI5S9iT4aXex5d9m/rqcvjXXPA5Pmdp9jGd8xdOTHV0mECgPTj3FgraOVlC0nZeRMdqf6cattSBLM838dPb8a3Ipsn1ACXj92Vt3vFqoSePV9zHkaI
 +Hbskmaw
 hLUCb0CyZXVUu9hEPX/COnilCBJddxpuMztMtmUQi93U1AagGwAwkkcDLi68WBV5+3ogR0ddY4VSy5H2CYLs0pND0MRF85og9nzKoy5oes63Zh2DkPHcQFjTV96bvf8KqqWHI/jiYWT+32PGxA8JzeTU9OHJd+ybSMQuNwFnk8kVfYQZG3vfKHA36vteP+ZfBtN7Fs4h+mOYOupyf7vPUdvlsLdF1nKmSPeHHpmF0wOMgCzCuoDL0cjeXC8ZBgv49oRybWNUyCTdgPwGptmtAH4eXvOiBt4HCqPWoM65AaraEoQQUJevwpAezb9jENDNq+1LiWdDAHlNKOrN6adcbmJ1q/IKX42bJX+HpNZ37TjfQtwu5fEzfoR+dJI68u5lG3NMCR47VjJulXMRD/4iPPvL49Jt9rPpKMp+nmmcKw42sccHA5LbVsIxNbVmEq+gKPZFM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 11:57:42AM +0000, Brendan Jackman wrote:
> On Mon Jun 15, 2026 at 2:38 PM UTC, Vlastimil Babka (SUSE) wrote:
> > On 6/12/26 17:29, Gregory Price wrote:
> >> On Wed, Jun 10, 2026 at 04:12:52PM -0400, Gregory Price wrote:
> >>> On Wed, Jun 10, 2026 at 08:59:59PM +0200, David Hildenbrand (Arm) wrote:
> >>> > > 
> >
> > I think the memalloc approach is dangerous due to unexpected nesting. There
> > might be nested page allocations in page allocation itself (due to some
> > debugging option). But also interrupts do not change what "current" points
> > to. Suddenly those could start requesting folios and/or private nodes and be
> > surprised, I'm afraid.
> 
> Minor side-note: couldn't we just define it such that the allocator
> ignores the context when not in_task() (and warn if you try to enter the
> context while not currently in_task())?
> 
> (Don't think this would change the conclusion very much, e.g. doesn't
> help with the nesting issues. Mostly curious in case I'm missing a
> detail here).
>

I looked at this - only solves one issue and oh boy is that an obtuse
confusing condition to understand.  We still suffer from recursion in
reclaim.

~Gregory

