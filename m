Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46EC0C47BEA
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 10:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991B16B0005; Tue,  6 Jan 2026 05:54:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93F586B008A; Tue,  6 Jan 2026 05:54:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C336B0093; Tue,  6 Jan 2026 05:54:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7265D6B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 05:54:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0647A1B7A0
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:54:53 +0000 (UTC)
X-FDA: 84301231266.11.DBE55EC
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id E4F1C4000C
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:54:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KXYD8d5A;
	spf=pass (imf01.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767696891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S72Lgbey/fnLxmYDS/ZNU+VaP8hmZ5dNjW9LwfYzt9s=;
	b=XVCXFpAEZLCo+A3V3VNA3nfmRBlh4ijpSzsFZRgVQ9UCftD3TOmJEFOmDw+gpLNVYM3QwX
	2zYBnFOlaUhVclMDJlyM7Yb4hHIS7fA1NRdef0kjd/oLFefxRR+dK3FbMa5lq73D2jb0nv
	C3XJX3Zfq9Ogdr6KxFKhfot+Y7XyjPQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KXYD8d5A;
	spf=pass (imf01.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767696891; a=rsa-sha256;
	cv=none;
	b=QfvRurMkzGBSYEegwXE5o5DQAj4YeIreGNAY7hD/nargfCVbWMRhB1jvIO6yHkcnNQSc3C
	Wkn/YBsG5pAGhIfGVaROuc3AphxC8sUVPiYPwajNr1eyEgkxXDgSjjcaQMb8CcIHooa+N1
	zABZLs1xuhjv2BX0VIpB5BSzJ2qiilA=
Date: Tue, 6 Jan 2026 05:54:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767696888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S72Lgbey/fnLxmYDS/ZNU+VaP8hmZ5dNjW9LwfYzt9s=;
	b=KXYD8d5ASOCoB2+ssLURRgJS/qHndWyXHRiK+0xHv/vfYrUK8Ekp+9rGfR8DoYqczIqSVs
	PIzvqLOSaU5PShe6FWogeoHe3bdeqdsky2hi3j5g5DBxhjohZgh4AmfbBmGjsSFNd7WGhI
	KMjHmONM6bOeuG/e4HZwv17Y3+CggdA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: David Wang <00107082@163.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, pasha.tatashin@soleen.com, souravpanda@google.com, 
	vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] alloc_tag: add option to pick the first codetag
 along callchain
Message-ID: <aVzorksJEyI0wlxh@moria.home.lan>
References: <20251216064349.74501-1-00107082@163.com>
 <CAJuCfpEtZ2Ncpa4goKUcerruB67fALJ2v2KrbWB1_PB7iwwjSQ@mail.gmail.com>
 <75285cc4.3c52.19b916d9490.Coremail.00107082@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <75285cc4.3c52.19b916d9490.Coremail.00107082@163.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: z1bxpw3zn3kh8po7n518g7onwi76mqjc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E4F1C4000C
X-HE-Tag: 1767696890-519342
X-HE-Meta: U2FsdGVkX1/p5TseU2ftQsrg0bNuYtLpgcdY0wpHNGYCG2cRx9qEcSZPsHtitWck4izGwDlqlvOAw72CikhRET3XM3vlGc/2TyCRiaMKKnJV4qNsbgLF6clR9o8EhRm9YXvoHA12pj+B5fU04NnvdBi7TlYpTJcAKUk0wPVtTjsTOCPw77O1btlq+L1E4ZVUvYIxgEmQXSTS4v1jBDxR3eggoCYITmQ5hnWK+Rl8G5QLB/18jfF6dufMpyr/wipg7LHQDwJAVKoZiAU6rSbQHu1+vK1/Yo61ftrMq+vMSAlkhmUvJkMVWjLLnTeyNN8WvP/P0V2CWgBftj9o22cPve/Fw4VwY2WDZhyCMyfUpf5/xXSTQIXV+6UmBJAk/sa82oLuOV0dTIubMgoqkc4LZlyz+fT39/nhk2LIg7KI/+EoZlwDDcwXqgr47kPX1eUzgQ+TkvSgyWcaM3IRkQyL0SqWcZnSMG3R22yEt7FAdkfAniRYLSUhPFYu5VYP0BTh2zZf/2VBIefwBC4yYD2Fa4rzDbDHpDdZLjDKaSom5/W/013MechXHfUT5TyMJFCf/GUlrF/RoNfVyOqGs62sXvDJJvwJnf4a71oCR0m0CFwP7nuGL2xX7DalMyqCsth7zmu6Vs95+OV/MC7JemeHeqGI8yX1Tro+W1P5DLgDKIHA6n5hP5kKRUFcYt11LaCjeC98GyyhkDdEft7NzijIwrjuzWmzqPYWmXU/ryBE/SCTYqqvwaZi/NVBZ3vPtXWZ2SAYtMnCoE5NvMtBUryH1UVFM759d7rSua3mEE0Het6QQAlf9+fmXfXRikxQnsp/EkMCa7xz7IkmnQNXA+w0J94OzQkbhw22ls6JCOmguNW1rRFU6eFMQhmRl4gszcjLndcEDBd3ew2AEYIR6LV7QQktxUE0/jlZ8OPgWjRWZGgRrHiM7KQKNarBFu14xvsaPM7P4Zya1S7BfW/4yNS
 VVNunLAp
 8vFBYR9je6GEuWn+SbUA7cGtK8m327bflF3ZJw88ZvJO9HcA58JJucfjeobdSygj1HWnYOAYYcy6Jb1jqtxlhydypIV8QX2dtED4tPfvX6ahL0zOAvbz9IbzLel5LYyNw6TqT43n0UD6pnHsM3fJ8ltYOLiyd3BN964XvIpk2kPtKUWJBTnQK2+SXur1MEer/2E5edeQgyC9O69XhaEPJu1FzocFoyt7uiq1lr0HUkr40Xr4Q5UanT+yjRICDS+JdjnUOzczQFWIY0PA8m2jW4wlMKlIzDDrLN/Zr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 11:50:36AM +0800, David Wang wrote:
> At 2026-01-06 05:12:48, "Suren Baghdasaryan" <surenb@google.com> wrote:
> >On Mon, Dec 15, 2025 at 10:44 PM David Wang <00107082@163.com> wrote:
> >>
> >> When tracking memory allocation for some specific function,
> >> picking the first codetag is more desired, because there
> >> is no need to track down all allocation sites in the call
> >> graph and change them to _noprof version, which is quite
> >> inflexible when the call graph is complex.
> >>
> >> For example, consider a simple graph:
> >>
> >> A ---> B ---> C ===> D
> >>        E ---> C
> >>
> >> ===> means a call with codetag
> >> ---> means a call without codetag
> >>
> >> To profiling memory allocation for A, the call graph needs
> >> to be changed to
> >> A ===> B ---> C ---> D
> >>        E ===> C
> >> Three call sites needs to be changed.
> >>
> >> But if pick the first codetag, only one change is needed.
> >> A ===> B ---> C ===> D
> >>        E ---> C
> >>
> >> The drawback is some accounting for C is splited to A,
> >> making the number not accurate for C. (But the overall
> >> accounting is still the same.)
> >>
> >> This is useful when debug memory problems, not meant for
> >> production usage though.
> >
> >Hi David,
> >Sorry for the delay. Do you have specific examples when allocation
> >needs to be accounted at the highest level
> Hi, 
> 
> I do not have a very convincing  practical example yet. :(
> I started to think about this in this thread[1], debugging possible memory leak in cephfs.
> If modules want to account its memory usage, they can plant codetags in their codepath
> without worrying about codetags deeper in the code chain.
> 
> And I noticed that some callsites' memory usage is incomplete, because its accounting
> is split by codetags deeper in the code chain 
> For example, on my system, I have
> 512        1 drivers/usb/core/hub.c:6080 [usbcore] func:usb_hub_init
> but if pick first codetag, I would have
> 20992        10 drivers/usb/core/hub.c:6080 [usbcore] func:usb_hub_init
> 
> One call chain  
>     usb_hub_init==>alloc_workqueue--->__alloc_workqueue -->alloc_node_nr_active==>kzalloc_node
> has two codetags, and its memory is not accounted to usb drivers.
> 
> If interested in module's memory usage,  picking the first codetag would be preferred, I guess.

Is an end user going to be able to do anything with such an option?

Your option just flattens the accounting - this results in incorrect
accounting, not just insufficiently fine grained - and incorrect in a
way that's harder to notice and find and fix.

How many times have you gone down the wrong rabbit hole because your
tools were subtly lying to you? This is something we really want to
avoid.

The fact that you have to be explicit about where the accounting happens
via _noprof is a feature, not a bug :)

