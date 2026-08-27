Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 504CCC61DBE
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 02:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AE5C6B0088; Wed, 26 Aug 2026 22:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35FCD6B0092; Wed, 26 Aug 2026 22:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2758B6B0095; Wed, 26 Aug 2026 22:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 065026B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:20:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16B881402BF
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:20:04 +0000 (UTC)
X-FDA: 85145444328.25.E87D58F
Received: from mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
	by imf08.hostedemail.com (Postfix) with ESMTP id B585E160006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:20:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fQlFDKff;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787797202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBDlirJu2kRBukLWu3W0R5/7aDZzvymehEjPSrr5//o=;
	b=H5XeBDCcVX3HdsNnBsFEfJ1TejUddWMJGPNMQYoa3n4mRs3S5rYP+7wpeZx4hMuflgR7UU
	7iNC3SisZul9j5Pa8o2ETPDeJ3rFt0H7XokXj6Ry6tUC7A1YxHkq1GSNIddbzy6M7LRcFT
	15GRXScwqYBxLOaV4/cmKiP+SDH2uMg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fQlFDKff;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787797202;
	b=v+rNzDa1VtFfaf8jSQ1V/QGwoj8qk4KjM1BDeLMuM3YcaF706v8MzwF5T0C3pM9uFW4GYj
	bApu/mx0Sgro085zXE5+gsR95JlTHuuq4BF7NVv6n82PdXIlTQBcYA07aQwXdcqGdnaKGx
	TjMXOVHQGmbpg09LAm9TGOBVH0/r0rs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/TpMjyqOvhWTUqglHXSxKj5Hxf2i55OsSPKaTfq8kvA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787797200; v=1; x=1788402000;
 b=fQlFDKffFBrIo/FYQSpPhrFF7VNlj7tUNVnHMzfBT6RasPD59cnrjMvXL3Wy/seJ0uXt2EE9
 6h6mUspDhd/wJPlWRcRq3VHGv/JZK3s3nSrsYS77OEreUh+2irxrXztQrbfdRl4g1PBHvMwluyA
 co3OjbRm15mm5fbuapjjc5kk=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.160.239)
	by mta11.migadu.com with ESMTPS id a789069183687cf0;
	Thu, 27 Aug 2026 02:20:00 +0000
X-Mizu-Trace-ID: a789069183687cf0
X-Migadu-Flow: FLOW_OUT
Date: Thu, 27 Aug 2026 10:19:54 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, stevensd@chromium.org,
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com,
	zhangbo56@xiaomi.com
Subject: Re: [PATCH 3/6] mm/mglru: enhance cold/hot inversion handling in
 inc_min_seq()
Message-ID: <ao-eyroFfnKzQU8a@MiWiFi-R3L-srv>
References: <20260821102538.22642-1-baohua@kernel.org>
 <20260821102538.22642-4-baohua@kernel.org>
 <ao6qTTtk2xkkeKob@fedora>
 <CAGsJ_4ywk7mA1xfk=emtqby1UAwFsaH9PChmk2TuZoDKrMzuXw@mail.gmail.com>
 <ao-I8rYv_G5j4wz4@MiWiFi-R3L-srv>
 <CAGsJ_4zoXvyXG6-qAH+=nv6V92w_U_tk78YAPKMihRniqvTe8A@mail.gmail.com>
 <ao-dewgE9XAfP0rU@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ao-dewgE9XAfP0rU@MiWiFi-R3L-srv>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: fd94ogpjy3xo455u5wkyrkqtyffnqzck
X-Rspamd-Queue-Id: B585E160006
X-HE-Tag: 1787797201-95150
X-HE-Meta: U2FsdGVkX1/Zv+n0gDDZmMGwbr3Z3twPlgBoG8br2HSl02LTcnb2vJbBQ+S/sQtLJTRF6QF5YK9BauN2qFALyhjeWY4H9vinvsWNv+qK/+vWz2LbXDLuX4eePszYJtJhIDinywobe/ARH2/sRzg71B9N5V2Vu0n/kDFvWAojwh9fqaUvIaNjM0eFkgobXEwchqm52a/iQVrvxyC6V/SZLgtuZouHpP+mQynE8PD8ut+6hCznAUgF2UVc0KBL52qroTjviKy9icrfMkJWZRoanU9A4G25cO2syI72ZdifCsC7c9ZVPH4t9/QuL7hngrAkoDj/o4zttViDR6+v7NljfvXZI4B9ttX5KVjdyo3yFaRCgG9iZ/ATT6pqDLrFHZP6tD4+S5lQBBiUkrAc/MOflxfu6gFNNezFQmtzNoAItJqtScz6f8VOWnWxMB7JESRFbU9ztxdbiVy3oAyJt3BL/s6Am9I0fU65gfFfOVJvPywbqTjIt9MObFzd8t4ZYKeYtdtpq5D/jgdibb/CaxV3UWj4+zCkdNmrSJtan2wjddwT9f7L3QbAm+JqQRnU4V7W9ODLuM5rUfkFi6dxs3WtzkHEO3J3F8yvPHVGDGEP0Na0IEhzwxnUbQRx0dka2/A2PjJ6ywqOWbN/UFN3y4AGuI/vPiTfAX3uVmf7zG3rldNYIe+uOTBh6TIno20rUAqlHBQOyFK9A5IHZZoacqVbiUTtKzQq+xLQ7HljpTjTRUI2s7IV3gHXXrS9oRc4O36j9/WDU+EbgsV8a8p+6+rDOEWzrbMjjrTIFmaTnGJhR+q8xsB/yfl0fuFGKZ1X1XzVFfxETfymb5YTSv9dLXEL95BFn04J9n/1mzyXgiztQP5sAXgb9SEjwJLBxyz31rzWU/zrTTqCF+YHoscjfiOu8Qv7gLGFTl59z8sit7V0XNPs9KZEHMb4YZoAHNMQ+Y1QJ3HrkAsp/Wt7q0Ymn2r
 etxcw3bS
 jyquJfVCTDT772laoDkfiPDV+DvqDgnXsX6G+2+HJ8FtrMj7sujaI8o2NchJV/dRGPFbBFiqfet8gtuuR6ipUpxr6Funr+D9AgSl+Dt7WmNNZtW8XRYTvrdp1jTe9Wpw433YVeoKkGKn7ovNeIUcTT12o6zsFX3J5JOBEM00GCISAEM0krpwGUZr+oLWHF/iXHv1QFvKju5VjwEnjZ8Z7NeskJsjfTVtgTUea1a+HlSus5JXHEc0qXLjGFwAJdIvk+8oXaqk2OVCQ/whLSIUifhWCBm/8i3y2SwU0oPc+WhW6ybyIUSjthRk4Co+w7jrnu22SGVAxJNbb+/tKXfggx6jsZtg+HMyaTWwrWJybjxJbuy/Dthstbb0JBqy4b4UpYEs+x0Boiu3+WfQVmuvK/1Ptsi5DZ4ML6Wt1ehx8Tl4ciHgQSk/WnEFRXVP6kePkBW4HQU/1a4XFh1y5l2vA+o7RN4J8YEm+/ABf53nr1okmMexEquxMqk2ABbWwltW4Jx95
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/27/26 at 10:14am, Baoquan He wrote:
> On 08/27/26 at 09:24am, Barry Song wrote:
> > On Thu, Aug 27, 2026 at 8:46 AM Baoquan He <baoquan.he@linux.dev> wrote:
> > >
> > > On 08/27/26 at 05:43am, Barry Song wrote:
> > > > On Wed, Aug 26, 2026 at 4:56 PM Baoquan He <baoquan.he@linux.dev> wrote:
> > > > >
> > > > > On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> > > > > > During aging, a folio's generation may already have been updated by
> > > > > > folio_update_gen(), even though it has not yet been moved to the
> > > > > > corresponding generation list. Such folios are hotter than those
> > > > > > already in that generation.
> > > > > >
> > > > > > It makes sense for inc_min_seq() to increment the generation of
> > > > > > folios that were never promoted during aging and move them to the
> > > > > > tail of the new oldest generation. However, folios that were already
> > > > > > promoted should instead be moved to the head of their updated
> > > > > > generation, just as sort_folio() does in scan_folios().
> > > > >
> > > > > While sort_folio() move protected folio to the head of next gen too.
> > > > > It only moves ineligible folios to the tail of next gen.
> > > > >
> > > >
> > > > Hi Baoquan,
> > > >
> > > > Thanks for the review! I’m not quite sure I understand what you mean :-)
> > > > Could you please clarify what you’re suggesting?
> > >
> > > Sorry for the confusion, Barry. I meant this is a good one, and
> > > sort_folio() has the similar issue in which the protected folios are
> > > moved to the head, wondering if that need be adjusted too. One consistent
> > > rule for both is better.
> > 
> > I think it might be fine for sort_folio() to move protected folios to the
> > head, since those folios have either been accessed multiple times or have
> > reached a tier higher than tier_idx. They are sort of hot in theory, right?
> > 
> > if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1)
> > 
> > But for inc_min_seq(), it is just catching up to make sure the newest
> > generation doesn't overlap with the oldest generation. Those non-promoted
> > folios themselves aren't hot , so I feel these are actually different?
> 
> I got your point, sort_folio() considers the hottness, inc_min_seq()
> doesn't. I agree with you now. Thanks for the explanation.
> 
> BUT no matter what it is, protected folios, lazily promoted folios,
> and no matter where it is, put in head of next gen or tail of next gen,
> their refs are cleared by folio_inc_gen(). Then in sort_folio(), they
> are all tier 0 of the oldest gen and must be reclaimed.

Or mm walking will take a long time, it doesn't matter much about the
refs in next gen in inc_min_seq() because there are a lot of chances
refs are updated when it comes to sort_folio()?

> 
> So here, I think differentiating them and moving them into head or tail
> doesn't make sense, the thing is whether if we need do something to
> retain refs of folios when gen_increased. At least, for lazily promoted
> folios, it should not be put in the tail of next gen and refs cleared.
> What do you think?
> 
> Thanks
> Baoquan

