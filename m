Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F0B3C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 05:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F211C6B0095; Fri, 28 Aug 2026 01:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8A96B0096; Fri, 28 Aug 2026 01:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E364C6B0098; Fri, 28 Aug 2026 01:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C35656B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:27:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62C26A3D1A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:27:58 +0000 (UTC)
X-FDA: 85149546636.25.4501789
Received: from mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 19A56140003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:27:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rNezcEDw;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787894876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8sVamOYfxqyl/dRasO78xw5mgGe0v1vJ0F+kjbkRts8=;
	b=yVizj47wi2vLg/CLniLauVq6XxuSGeedKBlx5BM+TQSCoOMCOefa6xTKA/GZzfZkY4v9Td
	zHr8Yvn27kMnoJR5VK+CQ4GCBCU/f9XmlHlDsiwYoZj/J/mb68F2hpKokVt7/7arhlnmzx
	dewrcvcsG1ttTMK0fal1S6SqAVai3lw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787894876;
	b=PT8DwVciwwXIzmM4w7pAY+YvyvQ7yqiFjkvH1q2KTZGEOAgJ9cmneXjWOckjv6p24UCrJ8
	uf1ilppiG/ohnkMtWwt4CCFOIFh1DdwBJFmK3wcMqfoKgN0BMYIvMKL8TN+0ohXh/PMQ8g
	ml9GSNjd846pulyrkyVc6h8aUW8kuPk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rNezcEDw;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FdxCCuwCfd5vXEUA0pRD/fI4XxAtR3tWCoY7QnXONYE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787894874; v=1; x=1788499674;
 b=rNezcEDwMejRQuIEh3SqVtAYGyqI6sF3XxkgQHbB9oc6+zCnnVXHNCmXmW6+8TkQQ/EzFUf1
 q0nCM/4ybx9QIxYIRVjTLsdL7TF+tpG/8Dc8yyBqKOcFAm3iZ9z6eKmd+pLHRAKDIY4mpPTjf9G
 EMoTHJ4gQ3JOHbsBEnGi/BAI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 1ed8bbe29e3740d6;
	Fri, 28 Aug 2026 05:27:44 +0000
X-Mizu-Trace-ID: 1ed8bbe29e3740d6
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 13:27:38 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, stevensd@chromium.org,
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com
Subject: Re: [PATCH 1/3] mm/mglru: improve readability of isolate_folios()
Message-ID: <apEcSl6dNJ6wsOWs@MiWiFi-R3L-srv>
References: <20260820045603.68809-1-baohua@kernel.org>
 <20260820045603.68809-2-baohua@kernel.org>
 <apD9QqyFGRoGxyZA@fedora>
 <CAGsJ_4w_c2mf6X7PXHc7W4+jQ57un+eewfh9K1dXha29Hw12rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4w_c2mf6X7PXHc7W4+jQ57un+eewfh9K1dXha29Hw12rg@mail.gmail.com>
X-Stat-Signature: he1xboc1zhf8f3pt31m6ix9td3zh9wu8
X-Rspamd-Queue-Id: 19A56140003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787894875-648692
X-HE-Meta: U2FsdGVkX1/y/fFUAb8iBlQlwEhZ+YK0FPelIYzPY7PrBIuQ9ZX3nmk6xdMREvfFAkK/mxduANA6OFuSwglEZzxKZOXztd7C5T9/7LxQ6kIrHxJGu990YDSgTbLGIR6k/cG2Gdw2a832iVjzLazj+ccflWr6RaX0DEejVK/VPblrgU30Exj+xuZ21W5jHrWWGOOpEZDsU1Z11Rvl9cFQ9iP0SxyKQRY1tSHnuHrNjM7GYpD713WqsJjp2IHVOW6pYMmDeHGhxSvGrgHV/CAjDBi2lNNolh2lm6uuqu5sRDdxuPDohBomcOvgaGv8ZbQlgNwm4k5h/8VSJI5THcnDLJ6YAOyoV+6enYNh8ihLpEfD3VYe+M3dUavXVaPZ1vBHmQAXsxtQulpkxkXe3ikxFwya61Vza7y53PYm8U9K6wsQ//T7+8V19ySeHYlz4mPHmhDEVEmXphYxK4pCSw1cwqn2CUyyIlsB/Lnk2t6LWcxkbKRG4PwioXy5TE5xzIGw9q5fZ0F09ZHypTBFv7gIPfSTozYZaMgGW8jtjjvNrvtWn/Z+YBvpmh+3qp6QCmoj869NNESg4BU/KBkC0+Uh45wUHzdRqnZEDLMSI8odFlPxHkbg6ysnMocKfsGi58dbA1WzlyTUGAYtofZ9N6xMF2BJslWt4pKA6dsLSwaNSrzguQwKqVfSRRIhIJXRsTHR2LcyhhsOw76GutFn1JSlbAOHFgN23bX2Ugjji++KW8J/J9ZeT6Y5qb+KyB59KWz48v62Eq+TyzWd2qfYVhvmaFp1LCQCc3udSBUC6SHPV+TcK7SwrjT0+o7Qsbw5f9xc5s36LY66WS3SQAXfAPILCh9wX8tKMM+P+E9MwnWmejodMxuUwx0Uyq3x9ZSblPFp7C44kz/BSubpgNP6g37aG3IaX0GFLe73Q9xGy03eTmKng98klon4CnNM1SVMawNoRG/HNCmNyTrME5B2iTn
 JdupP/Ef
 cvsCSdlQP8R8ciWkLw0E4Nll1utlLOc3qymimRoR9vA8555PIrtfMNTD5Qx0bSCmMSnE3BWNNh5xtsfGExregG3/fdYtm2nMt2NhLAfCLb3z3hv1z5j8EyuGTKZVsw8iTeccCqxcOVpQt79ktoSa4dY/8jGg11c6w0iLaHnFE7hIuIzals3JjzWb9k+20vtt2ZP2E6VTrlqubUy8sWN2JD3x0haU/zbdqkP0Kmcg/CU0dlAKy/R0LghdJ01kksRQvRzSo3HX6mqy1ckLpYBd1aFCSi1/38vm7qsD3tfOnU/h0m4dKHlniIAW67gaTHr9WEItp5nYnR1YobCs9NSBbO7opYYeVYO5CiD48+qjvRG/V8ejWe2rKkt3k6bjqYvmpI11s+2T9McEaIWmOKh8iult4nEUdRRj4gca4cwgz1+b/HuMzsa5h12sbdtvS+3/STrpNz8BgFLcYMW7MG5T+f1+hnVaVd3Gyb5tgdk11vFkH6eaCi/vGh1lVZ5G0wPE51UdB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/28/26 at 11:22am, Barry Song wrote:
> On Fri, Aug 28, 2026 at 11:15 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > On 08/20/26 at 12:56pm, Barry Song (Xiaomi) wrote:
> > > From: Ridong Chen <chenridong@xiaomi.com>
> > >
> > > The for_each_evictable_type() loop in isolate_folios()
> > > is misleading: it does not actually iterate over each
> > > evictable type. Instead, get_type_to_scan() selects the
> > > type to scan, while the iterator `i` merely bounds the
> > > number of attempts.
> > >
> > > Make the fallback behavior explicit in the code and remove the
> > > opaque for_each_evictable_type(i, swappiness).
> > >
> > > Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > > Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > >  mm/vmscan.c | 46 ++++++++++++++++++++++++++--------------------
> > >  1 file changed, 26 insertions(+), 20 deletions(-)
> >
> > The subject doens't reflect the truth. This patch changes the behaviour,
> > but not improve readability of isolate_folios() only.
> >
> > I also noticed the confusion of isolate_folios() implementation, and made
> > a patch to only change the local variable and added code comment to
> > explain it in my local branch. Surely refactorying is also good.
> >
> > +        * Scan at most one type per evictable type (anon/file), starting with
> > +        * the type get_type_to_scan() picked as statistically colder.
> > +        *
> > +        * After a scan:
> > +        *  - isolated > 0:  got folios, record the type and return.
> > +        *  - scanned == 0:  the type is empty; fall back to the other type.
> > +        *  - otherwise:     the type has folios but all were hot (or lost an
> > +        *                   isolate race); retry the same type rather than
> > +        *                   switch, so positive_ctrl_err()'s refault
> > +        *                   statistics stay unbiased.
> > +        */
> >
> > While in Ridong's patch, the 3rd case disappeared. It doesn't rescan with
> > the original type as the old code is doing, but return directly.
> >
> 
> right, the 3rd case comes back in patch 3/3:
> https://lore.kernel.org/linux-mm/20260820045603.68809-4-baohua@kernel.org/
> 
> so i guess we can rename patch 1/3?

Both is fine as long as thing is correct and clear, thanks.


