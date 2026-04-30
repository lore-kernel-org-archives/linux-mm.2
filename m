Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7E37FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 09:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1AC86B0005; Thu, 30 Apr 2026 05:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2626B008A; Thu, 30 Apr 2026 05:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C088A6B008C; Thu, 30 Apr 2026 05:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE70A6B0005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 05:31:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4840C160472
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:31:57 +0000 (UTC)
X-FDA: 84714705474.16.2EB8984
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2A6ADC0008
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 09:31:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf22.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777541515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PzZSU84LHJrzgeYtCkSdszoo4RoGA0I8YmuWNL/ZEDY=;
	b=GSUqze5I+kwlZcAyEnx2pLspCxxFXFyKTCMDUtPi0mEmAALbGiisKFiBCN7UGFLXbJhRcC
	cOAW93fnNVRzTd8VdWBi9TTcfgDvGX7GDquPoaBhxZx/1+MbVXfYAnQGFp3oP6/zKDrH80
	czf2eQckJWIMb02Lg0zkxbv1oZaVWZE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777541515; a=rsa-sha256;
	cv=none;
	b=hmX4vcihmb0OR9KacS8c9MwLCVGAfkj7pKfWCjNCfXVl9mfaGhx4xa8pa6EpU3vsHV1fsD
	UdduO0UysBvA9IAmsyfyYA61+QHt7sH72H6OtHc3p5Xbsh7HRqe9k9rkSJ7O/c9bRa7KRo
	JUBv1UwgXGCFGSbw2pbCRuBZbF2ApLQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf22.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4g5ppb0NL1z4yjT1;
	Thu, 30 Apr 2026 17:31:51 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 63U9Vihd040066;
	Thu, 30 Apr 2026 17:31:45 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 30 Apr 2026 17:31:47 +0800 (CST)
X-Zmail-TransId: 2afc69f3218326c-50438
X-Mailer: Zmail v1.0
Message-ID: <20260430173147258Zuj2qxsQmxxKETc0JKt1R@zte.com.cn>
In-Reply-To: <2f454sp2hre6ozeqkxm4qrwtu675ivroaxbaikt7wb2gnqslz7@3cfb7jte6bnp>
References: 20260430163504368ZueB-81tYNin-vhramBnm@zte.com.cn,2f454sp2hre6ozeqkxm4qrwtu675ivroaxbaikt7wb2gnqslz7@3cfb7jte6bnp
Date: Thu, 30 Apr 2026 17:31:47 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <yang.tao172@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vc2x1YjogaW5pdGlhbGl6ZSBhbGxvY2F0ZWQgb2JqZWN0J3MgZnJlZXBvaW50ZXIgYmVmb3JlIGRlYnVnIGNoZWNr?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 63U9Vihd040066
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Thu, 30 Apr 2026 17:31:51 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69F32187.000/4g5ppb0NL1z4yjT1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2A6ADC0008
X-Rspam-User: 
X-Stat-Signature: jzxw7ree9a64fbxwwzfbfhbgzxznfdu7
X-HE-Tag: 1777541513-992510
X-HE-Meta: U2FsdGVkX1/M/k4HzjdNhxFrG0fG4KUJxqniooj4NFMuXxCWPVzGVrlmUoXVQVBV7ckKaK+KQ1PwXI2yGnZpbUgPgWjEbvYGpce2PJPcCOiHICLFY75arSud7W5SS/stYEMW3Ai4wBCdd44TzgUsE5skSAwUb3kDa78ibZ4DJ6jqe7zP/uhN8LoAG/j0J2vJKO+8gpGlnkYAuMa6Q6c2/juHS6ei60eAmWhSAo6+f8hmsXXbD03Yq2h/qP740e8B8n/9rdaCSAZxXJtwb+z8LZMuG8w1Wu6tV3ar/CkYdN2v32xA0mWHODKkwIHqLmKXPfaoHe8072N4BV3TqENtWYF89yQQUx9tBWVtWJ46qbmMxJe2rSW6fbqRFIeJBABkmy/JHABalAVG+yTZ4G+zYA6/z47bP9UefFjz7QVX6qJ6/OI1zWEIDERo4LOCCQ/TcABqO4M6oqALloj9o3ZymnzVWXtnYunJhJjJHcHVPIUFmFReZjajnbnDQu2jDpr5E6b2byoErzEmUVzQxkPpO3rWk+NiqOjKG18BeQISnl4Wnk8GEQDvwQ3m0PiRzCxIiekQRq1OCt1e3Woi5C6ns/Qf9YDNeRDDGN1FBKvCWYSgEFZ8Dklnb5aXgYh90LLjv5eowjkfPyTHwA598B3B+ToLmTr36ZrqPhKzmSwBUke+eeh1GskK0AGCSOZ+ze4IZcMNQX0HpwYxHD6iwpswBmyQ+SMD/Gw9hZI6vNA3cot4ExpwD5tN5DuWVzevq8eKexvGz/9anv3jYcqP77nD9luf0VLhPhgXCb2f9JScpdBQ6MhDYvlJzFrqFiLaNOUbH/QnE9zW+D+I4EeudSjWRa+ktv8j472ii2R94HCsuu/R4fPclRAThqYiZzPXj8ggjYjb3JIPQ+6CqnL7M7ul2DOo3MEPf88buZkFcczA4h3lCb85l63V2vxSKxQilf0FdQN+nUQCy9eRBh2U/t2
 qAOGC8VB
 MGNxqypkHv8rC2Yp9WgEGb0cOcAyJinECUVF13I+0XwpvZXpMsLQjscGSDu0kjJ09+jgjby5xkB5Wz1iCKuDh5JYVBEs6T+a+EbMIDAQBg4x6TIIW+yf6EKXD2EQZxEqVOoN+XAdWdmCESGtZEgn22pPkNVcALbdrvW58nZpZAMVEpI+Us0Sk63Q2mlZGwkj/eTp9doCEqUmxIyXfFeYVYM3+2KTYpQ4vOSZFL1vHPEJF4OjDtlbjeGXNm2TmNP8r26gwLz/B9iXJnQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> On Thu, Apr 30, 2026 at 04:35:04PM +0800, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> >
> > The deferred-freelist path allocates the first object from a fresh slab
> > before building the freelist for the remaining objects.  Unlike the old
> > path, the selected object is no longer the head of a pre-built freelist,
> > so its freepointer remains uninitialized.
> >
> > alloc_debug_processing() still checks its freepointer. As a result,
> > boot can report:
> >
> >   BUG kmem_cache (Tainted: G    B   W       T  ): Freepointer corrupt
> >
> > Restore the old invariant by storing a valid freepointer in the selected
> > object before alloc_debug_processing() runs.  The pointer is the head of
> > the leftover freelist, matching what the old pre-built freelist path
> > would have left in the allocated object.
> >
> > Fixes: 895272864130 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Closes: https://lore.kernel.org/oe-lkp/202604301428.e2b8d3dd-lkp@intel.com
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> > ---
>
> When the patch did not land the mainline yet (torvalds/linux), we don't
> create a separate fix patch because commiting a broken patch and then
> adding a fix for that creates unnecessary history. We can avoid that
> as it did not land yet.
>
> Could you please send a v8 of the original patch?
>
> In that case no need for Reported-by: Fixes: Closes: tag.
> (But a Link: to the thread would be still nice to add)
>

OK, I will proceed with sending v8 of the original patch and
include a Link: to the discussion thread.

> >  mm/slub.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index f96bac36229c..af942753d495 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3690,6 +3690,15 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
> >      needs_add_partial = (slab->objects > 1);
> >      build_slab_freelist(s, slab, &iter);
> >
> > +    /*
> > +     * alloc_debug_processing() still checks @object as a free object
> > +     * before returning it to the caller. Since @object was emitted
> > +     * directly from a fresh slab and skipped by build_slab_freelist(), give
> > +     * it the same next pointer it would have had in the old prebuilt
> > +     * freelist path.
> > +     */
>
> This is probably too long ;)
>
> I think one line (something like e.g.,
> "/* alloc_debug_processing() always expects a valid free pointer */")
> should be enough (and some detail can be included in the changelog
> instead)
>
> I was thinking the FP would be NULL but either way looks fine to me.
>
> Thanks for addressing it!
>

I agree with your suggestion to simplify it. ;-)
Thanks again for the helpful feedback!

> > +    set_freepointer(s, object, slab->freelist);
> > +
> >      if (!alloc_debug_processing(s, slab, object, orig_size)) {
> >          /*
> >           * It's not really expected that this would fail on a
> > --
> > 2.25.1
>
> --
> Cheers,
> Harry / Hyeonggon

--
With Best Regards,
Shengming

