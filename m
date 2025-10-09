Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89742CCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E286F8E0083; Thu,  9 Oct 2025 06:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89138E0002; Thu,  9 Oct 2025 06:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCC088E0083; Thu,  9 Oct 2025 06:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE2C08E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:57:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73E8513BD0B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:58 +0000 (UTC)
X-FDA: 83978275836.19.550D442
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf28.hostedemail.com (Postfix) with ESMTP id E0B5AC0009
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:57:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Nogi2kv5;
	spf=pass (imf28.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7r1quKn+BuTk3jaZkpXZ3gMtPbVEjL5mdTyR1kfEgUw=;
	b=CPq+UshmPWpHXiPU2qhruXav4tXxncdGx+wT6o+rHhQTwikymDuHAX+fY98PNv9buwnWZg
	Q+IcqBbCmnX7C8lHZOGzt/kJkS2kdHV+NlN2C3EZaydez9N7qFGYY4S1iPke0sclMz3aZw
	RVtPbu83zhFUmQukZaSBprCTsNv8iSU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Nogi2kv5;
	spf=pass (imf28.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007475; a=rsa-sha256;
	cv=none;
	b=V8UoN3E4MsQgsl3SbdNAsHKx+lP+8Qm0wOaolEY8Xp2IrNL74Xu9KTx1xc7H96cRxZlfNI
	mYxpgoYihyuUqoBTNtgia2MwaqX99yaviJrmRsDm2l/tYC3wdwVzSikKR743KBNPrljFX+
	iTGBeZFg3cG9XMGoO/T1MB3bNetS7ik=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760007470; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=7r1quKn+BuTk3jaZkpXZ3gMtPbVEjL5mdTyR1kfEgUw=;
	b=Nogi2kv5slHuXaoVLMdloiKCLHu4zzvmkd6BNbGnVQ7PCTWU/SQ+/OHDfS1yd+1/1d6l+0GUJoHRNAc6p6x0TRLMQ4bK6rkbjx5QwJM/VnG1cBEUzeUNkNu30ZZXuTLDS8TeZLNZHddcJ+jCIGCkwwkExzcPfE+aM0TcM6ORzuU=
Received: from LG41624401116(mailfrom:yadong.qi@linux.alibaba.com fp:SMTPD_---0Wpmiumm_1760007468 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 18:57:48 +0800
From: <yadong.qi@linux.alibaba.com>
To: "'Uladzislau Rezki'" <urezki@gmail.com>
Cc: <akpm@linux-foundation.org>,
	<linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>,
	<ying.huang@linux.alibaba.com>
References: <20251009093707.868-1-yadong.qi@linux.alibaba.com> <aOeEYHzXUVOpu174@milan>
In-Reply-To: <aOeEYHzXUVOpu174@milan>
Subject: RE: [PATCH v3] mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned
Date: Thu, 9 Oct 2025 18:57:48 +0800
Message-ID: <001401dc390b$8d074680$a715d380$@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGd0BTLCsR2DZmbflymI0KNfeFshwG5mHeetSipVcA=
Content-Language: zh-cn
X-Stat-Signature: jc43nw6jjnu3z5kxii9o8f16x4fy9bdf
X-Rspamd-Queue-Id: E0B5AC0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760007473-453320
X-HE-Meta: U2FsdGVkX1/cehw4Ysra/tT/MbbaF0y7cdjd1ZejL/9aag5Gf+llXZwwB6AUUN5jguqjOZgUEfvMRlUTSvd0QEf1KvXxf7LLOskX2fRIB76VWnexuKIZIwuS4v7OHDGJJSe5AXO5y7RaFvQyYsIviaAJlLGffg+flIipZcyesiMjNsKqiAYZ1xYVSdsw5qovsbmPAyJ3HxQdUm9LD6n5jo1sPYnXlmze9209wQylDSakUHzLq5824FxAPOhjAboid1NjJpjLazR5tqijTiSo6T2LPszJImzS3xbcLAq0CyLzdLxXdvixjTzYh9kHSltGnqV6CabMZoljVpw/fKOS5plNvl9sPALxhEto2++YD1fQNOdAOh1iLQAl+0sbLz32OgdCA3vaPjA5Zoj65Kchx01Unq3ym6etI+TMPAzDnl/iJXRRUyunFH/8o5w2riXqd+mXbLXg0bTT8x7qXkgiLhGSQbic9N3L7ce3/Tc5A6E7+FsOSsOHXbbu2jnYOrEmtXjxTcUuDOjLfTFm30TonMhnZqh7NtxBr1g8m3/WjpL7bVM4MjPRDHLWj5GIIhWn91TvqekzAil2+dKjl0GKP30IhcjytR5K7+Vm2llz1/CxQANz0OzQ8oEzTnw0bj5O4DuJs3bDn3almw94BnYUb+d6cTsoRje9yiZi1nPNe82dasNxbiWUC+reFZjnKlJd4oSP8y98/nD9e4B5ohqHbkmGM/Bwu3ju5l4o/lb45Y7AvFn312b50lDhCZl87AKWiMVggr1xQClNDOklurPHfXg+8j/obUM1gB8mUrGSz+XwjjiHhrpJwlA/Y6pqTQelb6wjidndyMKV71lnyWpHvTDC0cSujACAUs2v2/EJeyOsQm+Y7MGbv4E4HsxUi23Ug/XXy7Wr4wJfvZIL7+t7KLNpVTWTw4kMMT0yZ08t86zqkmKMRta6YpKpmO1mfExa6s70oo3hOu4IefDKxxZ
 qy9RwqC0
 afh9wuJQGj3J64ssk+AmRJcaUa6/Oop4LiqCYxEHrDK370Vm4kijCHjAZif8si7+C5O0TciNw1xByYG1WTPRPQcWFaY6bVmE3NNX4v6o2wLH4yJapkTqjyK6IsgiqtEo3C/KtbQr5M9bIoVFzXRynCTtGnoHvqzOdWlZHM7XR3Taeftuh3O1VQFCyJEGzdSLny/hvT9c+XP2686Vt7B9FYPhAzfRK0K1zws3B1W4g11BdJF1B1Z9hMXA29LtcA7e1WePPtY6bCXO09UvdBKFul2EpOmeelkRsYEge9yT7n+ClSpuCdKTQmjIhuXjwdrRu/7GEasLPcfgCVL4tPcTtcitVAHlCAYP3cPQyAk93gpYGiOUkC7NAVQbiAYBYi4RMKhI4DRe4Kkp5uhSgdisTx14/QksgwXgqNA8opPsVJlKQ3u82KiUXDoClVdSmL5AzRqhGEPu5SCLLzwAz+ofuE5KM4NaqPb+uy99H3K1GmC96ssPMuKa3FZu8hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Uladzislau Rezki <urezki@gmail.com>
> Sent: 2025=C4=EA10=D4=C29=C8=D5 17:46
> To: Yadong Qi <yadong.qi@linux.alibaba.com>
> Cc: akpm@linux-foundation.org; urezki@gmail.com; linux-mm@kvack.org;
> linux-kernel@vger.kernel.org; ying.huang@linux.alibaba.com
> Subject: Re: [PATCH v3] mm: vmalloc: WARN_ON if mapping size is not =
PAGE_SIZE
> aligned
>=20
> On Thu, Oct 09, 2025 at 05:37:06PM +0800, Yadong Qi wrote:
> > In mm/vmalloc.c, the function vmap_pte_range() assumes that the
> > mapping size is aligned to PAGE_SIZE. If this assumption is
> > violated, the loop will become infinite because the termination
> > condition (`addr !=3D end`) will never be met. This can lead to
> > overwriting other VA ranges and/or random pages physically follow
> > the page table.
> >
> > It's the caller's responsibility to ensure that the mapping size
> > is aligned to PAGE_SIZE. However, the memory corruption is hard
> > to root cause. To identify the programming error in the caller
> > easier, check whether the mapping size is PAGE_SIZE aligned with
> > WARN_ON().
> >
> > Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
> > Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> > ---
> > v2 -> v3:
> >   * change error code from ENOMEM to EINVAL
> >   * modify callers of vmap_pte_range to handle return code
> > v1 -> v2:
> >   * Use WARN_ON instead of BUG_ON
> > ---
> >  mm/vmalloc.c | 29 ++++++++++++++++++-----------
> >  1 file changed, 18 insertions(+), 11 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 5edd536ba9d2..1fa52f203795 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -100,6 +100,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned =
long
> addr, unsigned long end,
> >  	struct page *page;
> >  	unsigned long size =3D PAGE_SIZE;
> >
> > +	if (WARN_ON(!PAGE_ALIGNED(end - addr)))
> >
> And it might be worth to use WARN_ON_ONCE() otherwise there is a risk
> that a kernel buffer would contain only such warnings.
>=20

Sure, will change in next version.

Best Regard
Yadong


