Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E42CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 17:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C27E6B0005; Fri,  1 May 2026 13:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C826B008A; Fri,  1 May 2026 13:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013F76B008C; Fri,  1 May 2026 13:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0FF96B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:58:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 366EF1201F2
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:58:06 +0000 (UTC)
X-FDA: 84719609772.29.EFAD80D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8512740005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:58:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cS0FYwD2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777658284; a=rsa-sha256;
	cv=none;
	b=URBKF9ulOlZaelxFkEehr1Ukwi4pVljpBPMjndFI9e/hSCw50tkceRmrQNm+KfSLuvKAle
	ZZW1yj1vLi97NvOfr2uKPmLpa4469JSrgJ7izwGT7WUMLvbItJgtidbyJcs74nRfyeKTFE
	jxY5rAOW2qNwRYFoKcPIU0VeIPcqXlc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cS0FYwD2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777658284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/+O11I2l5uEWQtHiF9iLIDtrtif7F+7W2x9HgtS2Zk=;
	b=lELcD3KSnCPMMxD20T6HpklMGUJoeyaD1JhT0xXwks6s1TkVGt2CLhYv99v0Bzjn0reSRp
	eM8QzL1FamEfZK3UUmjsNMKiJ1uO+AyNWvLyzupA6wVI7nz9ab4Wm3Hu1ZB+xwpR7BqCeS
	yDCcDjHtTmj6e7zUzmfEVD1hEsv8hYI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=u/+O11I2l5uEWQtHiF9iLIDtrtif7F+7W2x9HgtS2Zk=; b=cS0FYwD2XOEYVbuKnpFKh9ZiSM
	0EwDyUhzf4L/Z7u5RfwH9F/lLM1NhuqZPIwTkUmNl1PS4VMevXWN1PepuvnRy9E8BXEEBe1NqpbST
	JCuDyJciLjPMlOgK/msGkQ/Etm/ww5vna/xrv//xWjQSuG3YKtTWGFNZVR8+M3tsp34wr0aQKFWkJ
	uFsTeHHXdKUGothOh1mQqNx0qA+TQ+SY8myKKpSqt0cEDRnA3Sr7IVPyxsjySvvgY2FjAsXzlkA0p
	PsB/KjAACHCD+NoUMzQlqunyAml2flv3i9OPzaSZZMasw49lDXCUAuGtnBBvR4d+htLsXvVM7+CgM
	/hohbFOw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIs7c-000000098SG-2Rmh;
	Fri, 01 May 2026 17:57:52 +0000
Date: Fri, 1 May 2026 18:57:52 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz,
	pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn,
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <afTpoL3FklpQZNMM@casper.infradead.org>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
X-Stat-Signature: wbpd3gng4fuo7yej5ifwtwoux8szawjr
X-Rspam-User: 
X-Rspamd-Queue-Id: 8512740005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777658283-420822
X-HE-Meta: U2FsdGVkX1/QVBN/zx4f3fUHyomOrwjBs40MBD9DeTTawnc2alMB2lCnV/AZEvo6t1ZOYwMYChyuCQsvl0nw1+PpDfwa/P+NhCnpwPRgG3fGFRYWm12J2lrb+v+CqFoo0w6YD1shtI0PK+TAv+ezeai6YYihmj4iFYWtFEIuqB2mMdDdZnvu0W4vd+/STNgPy0XhTGLvEVrdBmBMbVXMyJWyJHQo0t2ghhiQG3ANLpwaCyRTbBYKAMqNR7deqGxwV1/iXPeFbSULPXYyz2fNrt4iF0VOewGNC1mg+EZ0U75ZI5csuiSnaXum16GWIlgDMwmWRSW5VKFh3sjgAa+GhlRHtFMQYJp+UtVbUeUP3L1T/KyHOKYzL+gggCU/LzcF/zkkb30WYGKEL+zwQuoPALMGlZ8hJ5z+jwzj1g+osOyEaBi6ZJkoWtkDMRUsn5WJIxHu+KYno45+gK+n05mE1D4Jss9QRVVvG11xaUdv0m1xzU6JeZjbCCYgYkqQVpz7O9Gg/OIpSEJmw6xbd0NRuQWvEppeVN4LRodlphd8PfpLv6T4OQ6Wi+VOJYukeuCa7YLPKxkvYGqLXNT+PFDuA4ETovDX51TdOuOt1hb3Mos5625dhk5QjVr1GlUT/SgtgOcf/TPv2oGgJXTIU/GzeO5FeN0CFc5HQss93wiPMetF+v3P5qr2G52+C8hYPC+joACzK4MhyOZgeGCikfuY9ukdrYZPmSngQ8xpXctQHuT1BJcxMVWwMB2pc9Pp60BUtI9KHKCkWMvM0K0eaA3rXmp/51VzBJZfKmAbY8yYmMI6aU5fp2EcOPQW5yFFft0EOM7rWJT/AK+RJW61TGHIi7tAHybaZ9DVkXI2cAqCnamIpzgDRygzUDN37jyPVWoP572bT4BfHE9X40FGSI/UwLt1rWeGTX4y+pj8KigY62uCtxPK7BAC+YNqN2eiJO7t6ywmybSEi/krdMKG8+n
 T7pWKbJB
 JcAeAvJwa3QMfSGZ82eQ6Hv8jX+VtxZDzm+jWKJsCDmTEU7ZFj4ujvb1Rp+ldg4ApfVhXB6b4m9i1pHj5Z74wDM0j/9u66N8NmfhgFp1phf6Vrof07wFaMX4/YoonX+PBDVF89Jn0SOZjIdjUQc7kulau5DOtYFF2WSyuAU5Z3R12tre5gdscgQPxHtCAiv/QzYIZGhuwLApxAL7MhvClsxQ9o5jKQmjDz5wvRwmMlBQsKimr8PSLiqOCZ/r5wILQmPOchpAPJ8sAiIpc1gp540AByiGwM96o3XjRZxjMl1kqZBIyGD7huGd+9KUZZVzkd3n/+/aqoRxucxVrTHPHG/20CcuTqiSzYjiHvBc2W6VkdPlJCifsbd0PTxKQdko8SabmEhD+XvmYkeb6qOGQ+OrJ/dlXTcimlYs9FKn2j3O2jBpHoIwVx/w5vdd+4CcitOqChu0NHtHZ7lo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
> On Fri, May 1, 2026 at 10:57 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Fri, May 01, 2026 at 06:49:58AM +0800, Barry Song wrote:
> > > 1. There is no deterministic latency for I/O completion. It depends on
> > > both the hardware and the software stack (bio/request queues and the
> > > block scheduler). Sometimes the latency is short; at other times it can
> > > be quite long. In such cases, a high-priority thread performing operations
> > > such as mprotect, unmap, prctl_set_vma, or madvise may be forced to wait
> > > for an unpredictable amount of time.
> >
> > But does that actually happen?  I find it hard to believe that thread A
> > unmaps a VMA while thread B is in the middle of taking a page fault in
> > that same VMA.  mprotect() and madvise() are more likely to happen, but
> > it still seems really unlikely to me.
> 
> It doesn’t have to involve unmapping or applying mprotect to
> the entire VMA—just a portion of it is sufficient.

Yes, but that still fails to answer "does this actually happen".  How much
performance is all this complexity in the page fault handler buying us?
If you don't answer this question, I'm just going to go in and rip it
all out.

> BTW, the chain can propagate: a page fault occurs, B wants to write this
> VMA, and C (a higher-priority task) wants to write another VMA. D may need
> to iterate VMAs under mmap_lock, so B can end up blocking both C and D.

I know.

