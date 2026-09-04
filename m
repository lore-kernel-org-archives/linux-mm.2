Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF25C624D4
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 01:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F13676B0088; Thu,  3 Sep 2026 21:15:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3136B008A; Thu,  3 Sep 2026 21:15:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB29E6B008C; Thu,  3 Sep 2026 21:15:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B61EC6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 21:15:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2121A80685
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 01:15:42 +0000 (UTC)
X-FDA: 85174312524.08.FF0EC9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 88B4440004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 01:15:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=evNIiaW9;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788484540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwQWCswQTfAMG2NQ0yeJBjoZGXNcITOCNLa8T4X83UI=;
	b=Q2ACKh7bMG3eHg1RfLYrgSLtPXa1rEhfXBNkIPLOebfIKzp2Bgm+JXoEB/VysLVz6e10Qc
	i21q3jtREH1GqZdVc7QH7Eqijv1NNVr7+VYL1iIQN+G+NzFMgnuVrsHehuqhyqMAHmZv4j
	C95chB/weTMbdTY0p9OoDCtfnoBnoVA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=evNIiaW9;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788484540;
	b=qiRkwr/XLjhZghG74MMrxR7fsJYcCb+HU0KavN/G6HiZSVo+cip7RPn5YOl/uO7hRImqXO
	BXM38Hmsaw3pTa9ez77N27AIj4cnDWtt1ICo31C0aAsmhfzPnYlxJrKgDzn917/oa2K0uc
	+HDuLzVjtah0YIDi8BqChEdpktLNsug=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0037B60234;
	Fri,  4 Sep 2026 01:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5E61F000E9;
	Fri,  4 Sep 2026 01:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788484539;
	bh=uwQWCswQTfAMG2NQ0yeJBjoZGXNcITOCNLa8T4X83UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=evNIiaW94EMcLuuA9J3Fj8ZT01CrnUAhCCd3lBbs+LCJvRtrvRg7Uzuk/R7bInvAz
	 3W+bATDKjxlc0+saV+FREDXw8HkavdZnQJ9SQnqk7JRfpjDi3C38Try9xnvh3cBe+z
	 Tl3nnrZci4Gd+DavHIKjHJN73CwKtmVMceGx4k6De28SeI+cA8rGEzJRNp03eYNXA+
	 kYYpoxtSgaVg5EsHoxjLbgRXKxfgRKce9TtFutFDCqkE023ZloAHdDFt4dQmIwmBrt
	 H1JfFI9Y2qXrYAmYi2TgV2udezEklOf5hJ7xe+5Sr0TBvjpXsDQbx/HCtHATKSce0O
	 yVD5q1XodMeNg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/memory: fix hugetlb_zap_begin() call in zap_vma_range_batched()
Date: Thu,  3 Sep 2026 18:15:31 -0700
Message-ID: <20260904011532.61272-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903173540.e8f660dcaf083946417cba3e@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4yqpsq3p1rgxwhonwq4ktc4u9adaxmap
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 88B4440004
X-Rspam-User: 
X-HE-Tag: 1788484540-675518
X-HE-Meta: U2FsdGVkX1+eeB7RQUDNRoxV+P7CblVxVgSLtipHO8FyYyilHg0ESIN2iYHkLGMDGrzgQ3A1Vx7xe8ZzosuffEBWCp16skIpS10/HLfQfqkBKIRdodam2oIkXMpm+G3hqaSZnzMAC1qrXliv2QxuYdyQhkRYFtnfKl/owOJCrqrBtrXRJTbBNeNf674n30TPee30fFxosvRtv7RNSNA7086NEkAVNB0K82Uc3XvQFRE9wFEZfmIEAvANqjNxslHYbI+jTGblD6W5cm/tXzpfaluktsOwmJ5EQHVdZbLBjMGfI0VNhdSI/sDr2rUU84H42b38xBD/lsmsoBi8LKK9SUefY7GiJrQXDhxwyGiv4LDvf+QGDdo5WI76Gx1j/I4OW1XbxhExp/FGv0LKx4MOqGEb/65kHKSB8SkUseooK8kH7KYg0a2zD5XfiA4BeGmcmLRxq9gM2xSYtBrTGOTGoXZwstQV6RHK+dK/wpafhmWdJ52IFqhGwE+yZ1YVwQ610S7pu/Q7z1xPZQ4vgJHSc9jK2Omtm8JzxtViRUWwx0p6lTwFuTnTvy9ZYV5m5nlFDBOZ6PNynPBGcZ1FAPApDGOtW6SBRx2PtZyrd+NwHZU6o2flmAWf0oZ1uZ4n82hnZSvgb35L3HaqmTuAgrrtLOXr9XXtBPdQCKwe5lXQ2LkK413PtI/gqW1L8U8adE5tynwdtSHgCydyjds1W4G6gzskfIt5spuQtvpg8nxUockWxb0kyHIN5Scbbiu34f1xd2yXduxm0KCYanrYvfvDQyqSVyU2rezvlwiwPonbCsPXyzG8HcirIqHF2eEeylwg/q41QZSxk2asPiKUv3IhUgbkeX0xaBkTsArG2BA/iIXQ0YQbdIKS9TMXvsvWoWLJ/qTI3hPJjyu988BW+PWKZNWiCf2uEPa1/I7McKtKAFydb2vOcVw0+Vsi3c3+1E3km3E04wSYjevaoIT2J0i
 UP/LJih2
 iRpOtybgw90BejwaR4up8z7XUcQUG801fW8+dDPs6MmG9FRWn6uk8F/l9GXPoIWUtAev9BwjFx9UjnCzq1wyFB1AkcIitc+0iviHgDrZA3OhAxz8H//1NTLGv5S+AgLs4oGds64V+NilvwmwlJdc72J9S620y/IOF8LwKTkZbmq8+QboPjsLDX9g8Z4N6jmlp+ri5dUzxyDVoRrkZ1mnFnOiqFJPHp3frXcALIriMVLSQuS5CVyrJfQm7XIb6ZkQjr7E1l53aa7j4z4PirnGUxEt1Z4jt2st36aKrPdVXZPbW8M5z9HPra2mDEF3BiN3dc69pebJzBidIIX1ZHwusrfDZjBo1XMMLrbgc4wk42UqJOCz2com9J8ilHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 3 Sep 2026 17:35:40 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu,  3 Sep 2026 17:00:26 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Commit f1fc44daf618 ("mm/hugetlb: don't lock private resv_map during
> > final unmap") added zap_details parameter to hugetlb_zap_begin().  But
> > the hugetlb_zap_begin() call in zap_vma_range_batched() is not updated.
> > As a result, build fails as below.  Fix it.
> > 
> >   CC      mm/memory.o
> > .../mm/memory.c: In function ‘zap_vma_range_batched’:
> > .../mm/memory.c:2308:9: error: too few arguments to function ‘hugetlb_zap_begin’
> >  2308 |         hugetlb_zap_begin(vma, &range.start, &range.end);
> >       |         ^~~~~~~~~~~~~~~~~
> > In file included from .../mm/memory.c:48:
> > .../include/linux/hugetlb.h:253:20: note: declared here
> >   253 | static inline void hugetlb_zap_begin(struct vm_area_struct *vma,
> >       |                    ^~~~~~~~~~~~~~~~~
> 
> You cleverly pulled during the ten-minute-window after I'd pushed this
> out in order to pull it onto my build-test-machine.

What a timing :)

I just found you pushed the tree again, after dropping the commit.  I confirmed
my build setup has no problem with it.  Sorry for making this noise.

> 
> There's probably a smarter way of doing this, not sure what though.
> 
> It doesn't happen often - I usually only need to push/pull the quilt
> patches (25-new).

No worry, indeed I never had this situation before.  And this was never a real
issue for me.


Thanks,
SJ

[...]

