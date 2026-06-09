Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 754CFCD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 04:52:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6A796B008A; Tue,  9 Jun 2026 00:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1B526B008C; Tue,  9 Jun 2026 00:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31156B0092; Tue,  9 Jun 2026 00:52:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2A556B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:52:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 403E8120418
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:52:09 +0000 (UTC)
X-FDA: 84859152378.09.4A37F0A
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf29.hostedemail.com (Postfix) with ESMTP id 59E75120008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:52:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf29.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780980727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0xQ+vFfzssjZ8cSG0f+9g+vvZzY/itiUhGKwaFw9e+M=;
	b=u373kF57Oa/Bz8k23Yp6Xh11kJVKTODdQLp4kSMMWSIrjQkT42F5Qbpu2mLxqDZ67IqkpL
	gsU/9ArrOIq32LOYO/UuGvKaHWokSTMpggO3GmJtVJKJXCnPidn/IjSzPjlHaQtkmZnKfU
	ooIHJsUdfTyHbh7OC1Hcn16dGw5ahPw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf29.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780980727;
	b=XOtLMSJ7/Mx4/hBElpYcZgxdmUtjEfCLHsKl1ROW/xClqyV37E4uW2MP5vpddtxIQ3ZI84
	tMU2j5z5zjf8CFtA3HQ0wNO/p4jy1loe40mXeEpEosXWPEm0HyzfoEy9Ce1ZF56ubTS53t
	tgCtaaq/JfEsttShzbBOh0ErzhgeMVo=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gZGjF3fYpz52SGf;
	Tue, 09 Jun 2026 12:52:01 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 6594pu0o045375;
	Tue, 9 Jun 2026 12:51:56 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 9 Jun 2026 12:51:57 +0800 (CST)
X-Zmail-TransId: 2afa6a279beddce-17c13
X-Mailer: Zmail v1.0
Message-ID: <20260609125157911GlNj7g3jjFsvz1MSDjF7r@zte.com.cn>
In-Reply-To: <f6834452-a244-4bb7-8982-136f00591f87@kernel.org>
References: 20260530170711362Lxt422zijBMtOvPlJD-0-@zte.com.cn,f6834452-a244-4bb7-8982-136f00591f87@kernel.org
Date: Tue, 9 Jun 2026 12:51:57 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <chengming.zhou@linux.dev>,
        <hughd@google.com>, <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>, <corbet@lwn.net>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2NyA0LzZdIGtzbTogYWRkIHBnb2ZmIGludG8ga3NtX3JtYXBfaXRlbQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6594pu0o045375
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 09 Jun 2026 12:52:01 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A279BF1.000/4gZGjF3fYpz52SGf
X-Rspamd-Queue-Id: 59E75120008
X-Rspam-User: 
X-Stat-Signature: 58eqsnw6kakftojeacwnyqdqerfjugsc
X-Rspamd-Server: rspam09
X-HE-Tag: 1780980726-717491
X-HE-Meta: U2FsdGVkX19pNroR583stUsvJnO4hYIUoAhCbr8ehlTXSO0d6zOJji9ghy4MqcQGw9bQSFZlkJeyxRx0MILzdogAvfPmVHVZf6inZ6b+7V1uJN5gZ4vlR72eQGONBnHzt+zjbaIDBJ4243MP9R3Yjrm8KfuGIAwxhuqJ6X81gUXPDCGHGvYImb5XoMfXL2iu++EH/4OckhX9Cg6jl0yoEPMcW9xvHNV7Ch/VDO3rl1PzQqVA39o6uCWVIYvuFl5bfNqc09dWEt6Q9LPF0pkOX7ivUbpA7KnGEOY2WsuFctfd7mY50VIQqbKjfBBTbKyn+8HGjMFJ21Eu7kgOQknpvvckfEEKQFCFcekj/d625mq733E6H6RxB538CHsGrcsmx8fu0XOhEa7AMhhS50/zvwodSr5YiPf0VkbLP/SYXNW6y1yXZ4PRf08lR0MDU7xhNpFfDYhkwpXJBMM5yFQrelW4uXHPT4l19he75hfxThx7mxXqW2qa7EaGxhN8fEX1kFw/5Lcs5Kvvn67MZEBUbyu2/NIlowblrtIxDpSCDnM6ZxUNCFgR4HS/I/O5qBvxnFEKhIuDvXQy7S6PXdW0jDjQuaHGEJ5ZwrXiKFFp2IO65cAW/XSMauSAQ4Us65+PCou4mVMwPYrCKAUyCKOu2EOH4+l0rto/BvbLBL5gRRjYY3NK3/AFtuj7N7R4/oyCI7BzgpHX7S9SNBshZmQ1O60BWfDmr2fIGY/OyURENWaly/C2KQvw4g8GiHBXHJFID7H4xoftI5xRSt3uaCJO3Xyj0WEpIhIKrsirI9ZLf1FB60D8Ju70cOghEgDlaFkySDcso/5/W8FFfRmJsJdKPRHbTKIpkK8myNskadUzTNsrFx7AeGl/eTuaj7TxxbcZB66Auuk27MARTwAWczVkE9evPS1takbrzGBhIviL2R/+7hcZcmKsvB+ARyokW982W8S6R2TiWDKdwah2e8n
 K3V7SBYC
 RL7tIwfJuzg6fbftTMycvzATAMErsqSHvEpl9N262c24FyuSTWyzH+BPD6LAp9F2SBnOJQJloHvaYrSF5Pb8l8hMBERQq9pHeJyh0fbj0YQkjp8MjF4ylsUMVu0GHZEk6lvBqOogbfHMK9bhHFFirWfNbjz174xUtB79AOszFpCrymVEDW6xLNyqb91QkznOXSEjt0UgU8trer0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

> Is the "maybe" stuff really something we should put into a comment?
> 
> What about something like:
> 
> "Must can only reference the VMA while still holding the mmap lock, so
> reference the anon_vma and calculate the linear page index early, before
> stable_tree_append(). If anything goes wrong, break_cow() will clean it up."
> 
> > +	 */
> >  	rmap_item->anon_vma = vma->anon_vma;
> > +	rmap_item->pgoff = linear_page_index(vma, rmap_item->address);
> >  	get_anon_vma(vma->anon_vma);
> >  out:
> >  	mmap_read_unlock(mm);
> > @@ -2458,6 +2481,10 @@ static bool should_skip_rmap_item(struct folio *folio,
> >  	if (folio_test_ksm(folio))
> >  		return false;
> > 
> > +	/* There is no age information in stable-tree nodes. */
> 
> Maybe we can make it clearer here:
> 
> "There is no age information in stable-tree nodes. We might end up here without
> a KSM page for example after COW."
> 
> > +	if (rmap_item->address & STABLE_FLAG)
> > +		return false;
> > +
> >  	age = rmap_item->age;
> >  	if (age != U8_MAX)
> >  		rmap_item->age++;
> 
> I think with these things addressed, this LGTM.

Thank you for the thorough review. I agree with your suggestions and have sent v8.

