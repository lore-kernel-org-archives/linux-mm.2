Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75D9BE64007
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 06:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5806B0089; Mon, 13 Apr 2026 02:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456916B008A; Mon, 13 Apr 2026 02:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36BD46B0092; Mon, 13 Apr 2026 02:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 280A76B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 02:20:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F8B21B9347
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:20:27 +0000 (UTC)
X-FDA: 84652533294.29.D05398F
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf12.hostedemail.com (Postfix) with ESMTP id A98A94000E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:20:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776061225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v106t4GvlM4YFD6m5WLnS72LnPu/65YjIbCtc5W2Qig=;
	b=GcAtjJF940klYdytI+qchYx4hjA4OVZXF4WkrTrWusqQ0XHwd0yVy5eaJLf0qoaigbJX+7
	+EESetvxvf6VA/fhvOdI40f3wM31nZVbgcykRJpiRcOX1uZahPMXG1/1n8NzgqyFkENpGg
	EaMpKX8cWjb/fQTAze7GXlqI7O4QQSQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776061225; a=rsa-sha256;
	cv=none;
	b=WcV5s+OKPTSexsZtBHcK2IhGQh9hRaoDIhpMjWLYO+mg+lr9g2740e+ZDE8EBXJPypvYri
	uTuTNiM/ieJPfcXuHKP6uv1V5LSckujHPn+UHtfDXvZxyMvBkvM1nCBlH2P60evnAaKoJU
	4KB/c6ISXOqC8w5UBOjrs4WgQvAzp4A=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fvHMR4m1sz7QYS1;
	Mon, 13 Apr 2026 14:20:19 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 63D6K80N002563;
	Mon, 13 Apr 2026 14:20:08 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 13 Apr 2026 14:20:09 +0800 (CST)
X-Zmail-TransId: 2afa69dc8b19fd6-934e4
X-Mailer: Zmail v1.0
Message-ID: <20260413142009771oJn6KdfOwqg6hop17-6bF@zte.com.cn>
In-Reply-To: <adx-2p09xEKz5Zdb@hyeyoo>
References: adxm5az9EfHr2aYg@hyeyoo,20260413131423382u868NVr2RkcvDe0Ii3ERj@zte.com.cn,adx-2p09xEKz5Zdb@hyeyoo
Date: Mon, 13 Apr 2026 14:20:09 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <xu.xin16@zte.com.cn>,
        <yang.tao172@zte.com.cn>, <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NV0gbW0vc2x1YjogZGVmZXIgZnJlZWxpc3QgY29uc3RydWN0aW9uIHVudGlsIGFmdGVyIGJ1bGsgYWxsb2NhdGlvbiBmcm9tIGEgbmV3IHNsYWI=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 63D6K80N002563
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Mon, 13 Apr 2026 14:20:19 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69DC8B23.000/4fvHMR4m1sz7QYS1
X-Rspam-User: 
X-Rspamd-Queue-Id: A98A94000E
X-Stat-Signature: gdzxegm3sdiy8x3ihrrhejda5uh7mu5f
X-Rspamd-Server: rspam06
X-HE-Tag: 1776061224-748559
X-HE-Meta: U2FsdGVkX18uuNhJtKqEykflnU9qyrKv4yiecTu7VESxLKgYfGwxCiyBVRn3xhtLpqBFw8nDIXU5wbtSnnd0dQjEP+OYVm5za7/fs+HoUkWVSDMLXUqjVg6reEh8nb2/8qSo4wuS/THtpPgDCyyfvsuOBVKqJOiOhDPOykEe0/K7MRXe5YjJcOgtGBclvk31mA/5V4YMTKiT2pArO2QiUsRzVcQu8b3wRis/5e0pr/i/BDZmW0TIceWx9WNX2Y2lCVLiod4q0cBlim0MWliSho0d7prhk7HQUR5h8mGztvpfBcz1Xosgq6v/hFvsntOMBfbUHCQ11m7tBCu0B7AdnYo9LYwd18llODKCYDGjTj5+cjCqIi/QPZajQ4XBMkjJOwrzk9XSquF/8BbJYj8zDwbZXIHPIlEAue8HXtU7GPv9aTjkpvyvVxQq7Ptm/Ezz1we8d6EllPIECnM0CQF9tAB1aPHlBigsKkH8PvsV/M4lctjzQu406F1JM75PxRmbJFdU679wSGThhvz4n95ID36hZLD0KKlnW92DjqqUwevRUJsDpyU/SsbyiijS03+y229/MlnYNamOyNJkdQOXDMg+J1uicbONGSJqmBTSi3n4IKa2BzfmTu4LpwuXWFwltL0CZ18IAmf/a+xN5p5nWufj0OOP7khG7VnEg0GUDxZiqQA5LChjwZ1nXltl0e6/59oQdsXSiixvKLzgvLgtv4fq4/hJXS0patYPADKmPPo6GVdMkCDtusmMvIw6rqB6CUlbLpWUvsH2r8HL4v+HW/YssukkBgK+Ap9xAvFpwHaTc/di/OvJMfc0PwiWEHOdmZocNzSElqJ0dSnIkHoIPsXzkCnwpMACJNersQsV1a7/q1eIm4eUiXaQaSg5xK4fZqfwWhu0nbK9AMa+w0l6dRqSUxPxMfbE6gQiivOFUE01SSW6ng4Asd99sStHqFowKno7Dd2V+Sfd4D+WXfu
 /sLwJqMT
 /MoyrVq3FGewkkdVllTLM04MNdfEDIXuDf12Nwo9EqtpaxXYg+wqXwWqHeIAxfjJOJU581CNBQZbxUaS3ux0XJI6O5GBfyfpA0RWkXEEc3Gl3ftKtkfnWyNvgmHifllvkaVUxqHGuRrndlJvQ/oEz7Xd4XKXpl9OH3pAgcDMyXBYJEXq6eF+/HfuK1MkdGXuqjuRI1OK077vLIjYFwvD9YGtC+ks2c4H4VCBI7/UGvlFWF5jAciqgnBEheA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> On Mon, Apr 13, 2026 at 01:14:23PM +0800, hu.shengming@zte.com.cn wrote:
> > Harry wrote:
> > > On Thu, Apr 09, 2026 at 08:43:52PM +0800, hu.shengming@zte.com.cn wrote:
> > > > From: Shengming Hu <hu.shengming@zte.com.cn>
> > > > [...]
> > > > -    inc_slabs_node(s, nid, slab->objects);
> > > >      spin_unlock_irqrestore(&n->list_lock, flags);
> > > >  
> > > > +    inc_slabs_node(s, slab_nid(slab), slab->objects);
> > > 
> > > Ouch, I didn't catch this when it was added in v4. When slab debugging
> > > feature is enabled for the cache, inc_slabs_node() should be done within
> > > the spinlock to avoid race conditions with slab validation.
> > > 
> > > Perhaps it's worth adding a comment mentioning this :)
> > > 
> > > See commit c7323a5ad078 ("mm/slub: restrict sysfs validation to debug
> > > caches and make it safe") for more details.
> > > 
> > > With this fixed, please feel free to add:
> > > Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> > > 
> > 
> > You are right about the inc_slabs_node() placement. I missed that change when
> > it was introduced in v4. Thank you very much for catching it.
> > 
> > After reading commit c7323a5ad078 ("mm/slub: restrict sysfs validation to debug
> > caches and make it safe"), my understanding is that inc_slabs_node() should
> > remain under n->list_lock for debug caches, so that validation cannot observe
> > inconsistent state during list transitions. I will fix that in the next revision
> > and add a comment along these lines.
> > 
> > Would a comment like the following look good? :-)
> > 
> > /*
> >  * Debug caches require nr_slabs updates under n->list_lock so validation
> >  * cannot race with list transitions and observe inconsistent state.
> >  */
> 
> Mostly LGTM, but perhaps it's better to say
> "validation cannot race with slab (de)allocations"
> because it's not about transitions between lists,
> but rather about slabs being added to or removed from the node while
> validation code is iterating over partial and full lists.
> 
> Thanks!
> 

Thanks, that makes sense.

You're right that the issue is better described in terms of slab
(de)allocations rather than list transitions.

I'll update the comment.

--
Cheers,
Shengming

