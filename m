Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7359FC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 20:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011586B0088; Tue, 22 Sep 2026 16:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05306B008A; Tue, 22 Sep 2026 16:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3E06B008C; Tue, 22 Sep 2026 16:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B6E446B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:55:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1092F1205DC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 20:55:55 +0000 (UTC)
X-FDA: 85242605070.27.A577BBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0772580006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 20:55:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NLiwYckP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790110553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6x3aoighk00gg5seqMKSj2yW50gaB1L65MJicSOd8A=;
	b=l3ZdyYxDSlsYcgprh/2ps8hG+mhc5lCPr5chp+Qzujyl2/DF1gyReSnT+sM4Att9fYmuW+
	OpTZZUxPrv/pNrmx1/mtGHeqC5lGYBoEdGeJqpVsli+YOx/l/ZEmrGsOc2MtLJd4JRZrlZ
	lIXMZZhNX9RncPb1d2O4l8AL5sQUAb4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NLiwYckP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790110553;
	b=bJ3dHG6oQgHAaY0dp4j4msZmWxSbF+bEoIUYo/EUhrNFxgSSM809ajLHb+4D83G2bOqWVt
	T4cxacZJvt+Ywg0xCxgbQaX29erDl8zZDWxDzL+PqVSuY+eBq07AaHCTo90SYn7TYi8+VB
	zPJdDI4vKEt8ioBiX0Yhzh62uFX5/J0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0844744512
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 20:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35A91F000FF
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 20:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790110551;
	bh=p6x3aoighk00gg5seqMKSj2yW50gaB1L65MJicSOd8A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NLiwYckPmHCO/uy5zqf5lUKdmRoC0FecvuYfjX0XTmcncIecz8LFB7bxxq34up+6L
	 Dg7SxVV+rrstPe6rGclYkMEmeo8FIM4EXnMsoiObCbvHLDZvFYf/ZW+CkEVJIG9ypY
	 zXO0d93fFfR2pPuXAQZfR6MfekTRU8y9grvpoHv21evU/XPfYEXZnSWiCEcJ9OvjkW
	 dExF0cQqb05KXJ1oCasvasjyNGS/1TLu7dHJTIwEseesrldMwQkB6fh8ZhnDZPkqTg
	 /foHCR7mIbRN/2plKJrx2lBD6kyxOWpXAX8xPvyy7kqCPWy7q3S7GPp1AT+F+4DwvC
	 i1HXbC88SjTaA==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93a2dea320fso29989685a.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:55:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxDS9iOqV5K4XmOanuo4fFIvx4G6YFtJAD7wbHFNv4pgTB2NcxIN7ycLTFxeQcd8y/UbVlmJ0Au5Q==@kvack.org
X-Gm-Message-State: AFuF++kIPsn+yNBhM7c99HR4zAuIQO3mhFPHZPsoXSnLAzucUipIlayf
	uOx4kD5THpPCWzV9YPhv06bxBdEQHY5UvNNiEFF034bB/cwaG71hhg8t/kXJvFMyj0U6XR05fUZ
	yC2hMHX4eiGA3+O4qqbRn+8bsaq8P7Ng=
X-Received: by 2002:a05:620a:3197:b0:93b:d79b:9a5c with SMTP id
 af79cd13be357-93c2523ced1mr99421785a.61.1790110550897; Tue, 22 Sep 2026
 13:55:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260921152449.629486-1-alex@ghiti.fr> <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
 <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org> <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
 <2e695c8a-4212-42b5-bb51-fbe1aa162e1d@kernel.org>
In-Reply-To: <2e695c8a-4212-42b5-bb51-fbe1aa162e1d@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 23 Sep 2026 04:55:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z2nakqBCKd_uAn4bfub99r3NJt2spOUx-K0M7bHW3_-w@mail.gmail.com>
X-Gm-Features: AcwNN1U2jjkVaezVAxwcNpi00SANdjvUN0D07XxKUusJlvcnrdo8G4HZCjz1Os0
Message-ID: <CAGsJ_4z2nakqBCKd_uAn4bfub99r3NJt2spOUx-K0M7bHW3_-w@mail.gmail.com>
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback completion
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, willy@infradead.org, 
	jack@suse.cz, liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, 
	jannh@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu, 
	hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0772580006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: i7pujodxr9hr3ti7dsjg3oci7rcwnsmk
X-HE-Tag: 1790110552-465100
X-HE-Meta: U2FsdGVkX18Fft1ssGD7DE6crxDGg7U2BwDHB0lCQGlao28CAKh67/IdNvu78EwIR9DFGxrRl1Py6aNx5s3mR5a9yZsOHiT4WKRLgzcv2pzuuY2hoI/oA6k+A3dkrntV7Tkg+nGdDZT+oSVzx/+UuYtV5Ag1k9tH7+PtNYtY7w4kHM29y1NeK2bamYwWRbU8MH4MbZxf/T5+PGOF/p5MWLP503pC9hHStdI8I3RXda/CL8JntwpCFdLYROWSJtDEtzb/9iIh2aSFwJ6vYVOjSTzl3NG6MK/6xJlXotC4gaZ7/iJ3A+mqkNSI/p5ZYLfAV5CnxWGgIoBx+bISFK7EC2krpdXjzVd8L8Un3YsTzjpiqhyDRDQPlNo379WWgG42x0cuGu/Nq+LNSOw5FcVHD7eQzdfJ3hn87v+cbVlkAh5RJ+M0HpPD7LDATi8B71jhJHAj5k83CHG35OEG3PI/AvyM5bl0QB66OO69YtKDbT/W9IZqpupIBl15PxoCgRagETHg3U75C8DuaZrsGaq3IpQzSteghRGjuQ/BqulxhliPxwTw/46TF3teZ9CU9DyXKo22aEewJvj9tITQ9dGsuaD9alHRNE8/noqZpceSAIT4wZrfxh+v0gEu2atqMRxXwFHgJwIrEWXFCmRU0zCx93Uo5v3/wcZqWZ+AsZVfE7gDxAz2yyJTd+XBnDc6TjpedCvNNQO9rPV+fmOMuTfNAvRA/97dVSaTnKPiIQbci9mRJKbGkWGFNi/jAZabng9qnbP3nOWjYRDsPgsJNw9121QUEdz7xLMWldhXCPqiRCtSzb/ahBXAXtsV9XHiwxl/5uu6Wpl+Vkeybk89JHzANW0l+XPOiIfwVvgGWKKFwIJeN8bjNh8vUmTDiJPK34Ql7OXJMVxFuke7T8/Gf3L6pJcfmqPz4ia5blzLtK9sSy+lsp6l0CXST1Fil7Mz8WbxUf/keAxi+kZzC4kS7eb
 Uz7obuOF
 cFpdsWpNIR0y2ydaNZ7sWQz95tGmTccedRA6MLtgswQOBku7RxJOQzwIOqUOUHODpAqxIO4iDZO/VEG0Bmx0dsej5XZ+7OtwTJ6Y8VBIJBRTow+HHbL0OTmv9d58lFWWnSMbB/d3LVdUWUlqy3M7iU4GtpJ0k2F3fhQi6yEeysdbIV0tMS+DYK7E4nDljueTb15+0C2dX/0qT1o5PwXKkidCDKeomv/mV4ELEQBfXaPVvdphYBfiI3uCnicrOcWczVrKZtM6H/EKu60D5RY40wfCcJII4RyA0CUxQANv04dwEM6ZGw744B/8TbkAgbZc3vomA9615Gii+LZTuuQFB2OUJEjXc4AvfxVyk5IIzU9gsOeGtZpZm/W2lkRzNkCCDU+WMq+tNTs14I8icBlc3rUk/anOyP6/Rauu50qBC6bcVPX+JlFUpScYHGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 7:26=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/22/26 12:37, Barry Song wrote:
> > On Tue, Sep 22, 2026 at 6:20=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 9/21/26 23:56, Barry Song wrote:
> >>> On Mon, Sep 21, 2026 at 11:37=E2=80=AFPM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
> >>>
> >>> For synchronous I/O, such as zswap and zram, the memory is released
> >>> immediately after sync I/O is done.
> >>>
> >>> For asynchronous I/O, such as NVMe, the swapcache is currently
> >>> expected to be rotated back to the tail of the LRU and wait for
> >>> another scan. Alexandre once mentioned that when he tried handling
> >>> async I/O the same way as sync I/O=E2=80=94releasing the memory once =
the I/O
> >>> completed=E2=80=94he saw some regression. So, delaying the release un=
til a
> >>> later scan may allow swapcache hits before the folios are eventually
> >>> reclaimed.
> >>
> >> "may", do we have any evidence that this actually is relevant in pract=
ice?
> >>
> >> We asked to reclaim memory. We wrote the memory out to disk. We unmapp=
ed it from
> >> the page tables. We made the workload the could, access the page immed=
iately
> >> again suffer already.
> >>
> >> We should just evict them as soon as possible to free up memory.
> >
> > I suggested this to Alexandre, and he found that it could regress some
> > workloads [1]. That is why Alexandre is only making the folios
> > immediately reclaimable for `MADV_PAGEOUT`.
>
> I really hate to add special sauce for MADV_PAGEOUT. Also, I don't quite =
like
> that we do something fundamentally different for sync vs. async.
>
> I assume, though, that async writeback that is very fast might just find =
the
> !folio_test_writeback() scenario just like the sync case. ... or if we
> reschedule after pageout()?
>
> I am wondering: if we can show that letting async swapped out pages stay =
in
> memory a bit longer improves performance, aren't we swapping out the wron=
g pages
> in the first place, and not swapping them out would help the sync case as=
 well?

I guess that's because the LRU is not always accurate. There are cases
where our prediction of future access patterns may be wrong, resulting
in refaults?

Even on Android, which uses zram with very fast synchronous swap-out,
I can still hit the swapcache from time to time. So perhaps with a
slower device, such as an HDD, keeping the swapcache around for longer
could allow applications to hit it more often?

>
> >
> > See Alexandre's description:
> >
> > "Future work
> > -----------
> > Barry suggested extending this to MADV_PAGEOUT and general reclaim. I
> > prototyped dropbehind for all reclaimed swap folios and it regressed
> > sysbench OLTP throughput by ~15% on NVMe swap: dropping the swap cache
> > immediately turns cheap in-cache refaults into disk reads and collapses
> > swap readahead clustering.
>
> Thanks, does this represent a workload pattern we care about?

I don't know. Maybe Alexandre can share more details about this
benchmark. I'm also a little surprised by the 15% regression in
Sysbench OLTP. My initial feeling was the same as yours: we should
release the memory immediately after writeback completes, for both
synchronous and asynchronous I/O.

Kairui also mentioned to me that he once tried releasing memory
immediately after folios were written back to HDD, and saw some
serious performance regressions as well. Maybe Kairui can also share
some thoughts on this.

Best Regards
Barry

