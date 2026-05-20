Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B88E1CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042706B0005; Wed, 20 May 2026 04:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E8A6B0088; Wed, 20 May 2026 04:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5696B008A; Wed, 20 May 2026 04:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C82186B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:11:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 752A81201E9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:11:33 +0000 (UTC)
X-FDA: 84787078866.06.678D525
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id B527340011
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:11:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnkpa3Fz;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779264691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXxzzbCeNo3sDfk3dzWGFhN8IehnqsFdAWbxh92ducY=;
	b=8EfQ9YMByx2HoVc/3wHcNNlGS+TN9y6OKEr5QCWxYHa+seLT5+jhg+w80LTie4qjhgiWhS
	MCFRj8oDWvrd6X2ExMqOZn3NwrqDhkEUuHr2t05PL7ITtc+pWPhEaCLYELxwQIJvFlVNvp
	TN9D/6jxx34FYVxh5ztmdFem19mUaLc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779264691; a=rsa-sha256;
	cv=none;
	b=JdVACnhgVpj/g5kB97r1Ro3tTZjPbG4YyHji8IW8kZM1Y2I/Dhocm2JqHWrIjL6AXazOQC
	u426n8rSQ8o2paop0CMiPfdroA2qPsoM39VSIiuwMa6P/OSE9STuFmyRu0A2wgGBwbuDcT
	fdQm/MUFdaQuNI8Fii6zCmw2WA3RVKk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnkpa3Fz;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1089060129;
	Wed, 20 May 2026 08:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B3F1F000E9;
	Wed, 20 May 2026 08:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779264690;
	bh=CXxzzbCeNo3sDfk3dzWGFhN8IehnqsFdAWbxh92ducY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bnkpa3FzKkUUdWFG0smRQZfU40dk46M5NgdqdIyfXEPD1h20NL7bKr72VFJoHgNPK
	 Zpt0f97bM5yOlAFtMWk1oRJvIjsf1+ECrk3QzWUIz/BWNXDJW0ZYJ2FFouGZZmuMrM
	 Wo4p0Vkb6/RLl4doyo6ixLI4oE7LpahGy1KRkeyMwou5u+LN+Sw4rNKaJQ+5yI6oFf
	 vB2uTeyCpF+Vdg78uiOeOk2xvyBn7mhcgugFMKCdMzmjrO0Fwf6NwhxUTUhIuawNn+
	 NrJZl4Ke/LYbTbo3EkZd4QjkXwxp4OdeRjoSgwxJx/swz4bFwcKMo8A4KVWXBu3sjy
	 W937Gs5yLpfaw==
Date: Wed, 20 May 2026 09:11:20 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Yang Shi <shy828301@gmail.com>
Cc: Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	surenb@google.com, akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <ag1qo0q_bfePgOzx@lucifer>
References: <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <CAHbLzkrOSoh-jmR=uaNvx73n_wn+vExoKY0UzH5zGcfdAiDbNg@mail.gmail.com>
 <agxfLNuLCAT3F4cW@lucifer>
 <agxnJ8R-G3CRjeTR@lucifer>
 <CAHbLzkpjOLrdRSUF3-G4d9uz6tn6QYwgB66UU9bud5WHr5FWEw@mail.gmail.com>
 <CAHbLzkrTF7w+T5mGsQuDRuhnTk6evTKBNRcH4oS=nRcUg2zpsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHbLzkrTF7w+T5mGsQuDRuhnTk6evTKBNRcH4oS=nRcUg2zpsg@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B527340011
X-Rspam-User: 
X-Stat-Signature: g68cayyc9j11burq6aozuq91k1rwc3z7
X-HE-Tag: 1779264691-281898
X-HE-Meta: U2FsdGVkX1+BrAjdKRR5+OEJLnGtfrNHKtJTM+2MuSJlOl+OcS/VmrVupPRMNhn/ivq6xrfUejfvfv5JEsIp8UzhtHLWTsCAcGjAOY1x5S0iVs3zkOQsIq6BOUQFcYXoUmePshHH91K/l2cOgakFcuRNLfjWF0b1xaHC8hBzZuqv2D3bTvd2WMlI2KNE28dTgzDzCa4BZf/Z0g60ifJI4UzQ5xvR54GX9tJ2lYH/iXXVAzvSSrPAWV8hDw8cX20qIAvJDJ8BMScY/lXIyjpuFlHdjpn4SpHmkQw+5xohOwZL8j/NoWl2U5VaEMHHKWpUaqcbzlAQF9uClyoFBtftEKBQAeVHJDrH3CvmfYlxDUhZ33Zj/PFKlKcVYBoPtpntgkFcMzaoSUIwEbxH29+cpFgdagjpA7EhJD4AHo25yVUsZUTIpFjb83tukeN1BO4wOVjwT9CqYTkPE6D5GG7COxmrRt5QO4TfzFL4R+7ok34tdS8k+7Ea1rLhzk9Zz60B/2d5roYEj94ofy2FnFxhXgrHxrEGCSG5cBoIoWdobpv9ien7aWNvoWA5sgOf630v2gzAWq4Q2IPxo8maGRgrgA0Zi3OEHYNRVLZnIPBs15cPtzUTG7FZHzjJXHfjS58nGo+XfBjKjVmQK6LvHLXEsa9H58wVSqV0hayzP6kUiWV5U0NsjQTDaEjW94w0TQfB78ZAEork9yueRkvMLSnWFrpqUeLfL1xs6Y6QJC2J9FnIi3bKOUfjRkwCjtLjw4iREXXGFzpXJV2iDjJT7Q/VIbvZ+dVUbFNePwTyOklQM8SzXKNFPtJdA2aUjUoKxV1q9JNK9RHo6spj6Sr6VssO+cHY8/HRPw646DOg8KgSH2em4kM1aCY4iVdJS4ZD0xgQPQEdt74o+JTPmO0V4lOdSDgoIGD+p8uWY+BjbvHVY8aA4Afrtp4iWIec0BqNlA0C5PKzI0rmnVhCxnn3UWS
 Ke1IOckf
 ktBODlXg8wM5JJD8jmfKUYG7bnTHRRMBrkJi45LPehiQhH2pjCz8qf6TSqmSdESBB4efSP9uMfvZNltCrcyEswyGFIpTXwdBqcAzbtAvbsIkrayMLAZoqmI26CeuSzKbhc1OR5vgrCbwPBOORQLqO8ageTGp6BaZp/bVDamIUyD51pG9Cmbpg8s1pC+eoMu3d7v/toTXDHwuhvola/FRbNErLlwrvY7g8++aQN2LzDq2urhKFh6sWDguwGrjOE1KVu/+h4FGhnBhlO3lUTrVqpslgghroqce7Ou/k8OvfgpYXLA6ZNUVsuKVTW4TE0/Kffg/ywbFpfcKxuwSnRxm59TY3wCt4EAqiCanbn/xEcMErMgsSzqjz0Y5c1EOYXfgOsnupXENOJ7ahJKeNTP/fcKPtKE35D8LbQMLS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 02:02:09PM -0700, Yang Shi wrote:
> On Tue, May 19, 2026 at 11:41 AM Yang Shi <shy828301@gmail.com> wrote:
> > >
> > > >
> > > > >
> > > > > Secondly, if vma->anon_vma is NULL, it basically means either no page
> > > > > fault happened or no cow happened, so there is no page table to copy,
> > > > > this is also what copy_page_range() does currently. So we can shrink
> > > > > the critical section to:
> > > >
> > > > Firstly, with no VMA write lock, !vma->anon_vma means a fault can race and
> > > > secondly copy_page_range() checks vma_needs_copy(), there are other cases - PFN
> > > > maps, mixed maps, UFFD W/P (ugh), guard regions.
> > > >
> > > > So yeah this isn't sufficient.
> > >
> > > However this is true...
> >
> > Yes, fault can race with fork. Basically this is actually the purpose
> > of this idea. We can have improved page fault scalability. In my
> > proposal (take write vma lock if vma->anon_vma is not NULL), the race
> > just happens on the VMAs which page fault has not happened on before.
>
> Sorry, this is incorrect. Page fault can't happen on those VMAs
> because page fault needs to create anon_vma, but it requires taking
> mmap_lock.
> If anon_vma is not NULL, vma write lock will serialize against page
> fault. So there should be no race with page fault. Removing vma write
> lock suggested by Barry may increase race.

Firstly, let's none of us be worried about making mistakes here, the anon_vma
stuff is confusing, and I've stared at it more than mostly, and even so I
managed to make mistakes (as corrected here) and forget details :))

It's a sign it all needs simplifying, but hey that's what my scalable CoW
project is (partly) about :)

Removing the VMA write lock would cause races with page fault which can result
in page tables being installed which are then not correctly duplicated for
ranges that must be.

And again I think the underlying thing here overall I think is:

1. Clearly many cases require serialisation (any that cause copy_page_range() to
   fire).

2. If we were to decide not to take a lock with concurrent page faults, that
   lays a trap for any future change that (reasonably) assumes that page tables
   cannot be simultaneously copied while being accessible to page fault
   handlers, which is bug prone.

3. As per 2, even if we were to only take the lock when we felt we absolutely
   needed to, we still cause risk through adding yet another 'you just have to
   know' risk to this part of mm.

4. The serialisation is quite likely relied upon by other things, this is often
   the case in mm, and we may only realise that such serialisation is critical
   at the point a subtle issue arises out of it.

5. Fork is one of the most sensitive, intuation-defying, complicated, and
   corner- case-problem-baiting areas of mm and I really oppose us changing
   fundamental behaviour here unless incredibly well justified.

On this basis, let's let the sleeping dogs lie and leave fork alone I think :)

I think I am far more inclined to take Barry's fault approach (as I've said to
him) vs. changing fork behaviour.

But I want to make sure there's not a 'third way' that could avoid either!

I am going to have a look through Barry's series in detail so we can have some
movement on this one way or another :)

>
> Thanks,
> Yang
>

Cheers, Lorenzo

