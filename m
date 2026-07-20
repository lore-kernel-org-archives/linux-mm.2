Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EF69C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 08:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782BE6B008C; Mon, 20 Jul 2026 04:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735016B0092; Mon, 20 Jul 2026 04:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 625BC6B0093; Mon, 20 Jul 2026 04:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6526B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:41:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A57F7160522
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:41:23 +0000 (UTC)
X-FDA: 85008510846.14.0600377
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf09.hostedemail.com (Postfix) with ESMTP id 40B8714000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:41:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf09.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784536881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wfXJcMKtKrsTuzvzxG/TjSgbFVimIKdLnsUWtczA96k=;
	b=DdkZaACitBHImdgKIl+r3IFB+2ju3VUXWp+fM24HgkCMVd0R4VTsMH+c0AwAVpKVWam9/u
	eGh12tRKZGjMnXik5Uqe6OjArT/ptyucBKZLX1Uve8pAarmMS3NbvWjjqtwqp8fPQ42n+E
	7XNjSuRKTVdtc7cunkMgeIzGWh5Z2u0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf09.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784536881;
	b=uBRMZwg6rCE7CmKYm6SN1zla00hNXBDuWfXu9uUsOqT2QfGPqfvaMFz1iVO8fyU5dUcQxZ
	iQ63N2IAhvX1/cGn6oa2dcQQsYSK3xK47JKy0LzCb1/CXQNxs1VHPEDsyw30I9Q1TfrMvw
	WoBo4BP/cFx2vPAycKz3PsiMAjb1+38=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4h3Yrh4K3Kz58fdL;
	Mon, 20 Jul 2026 16:41:08 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 66K8f6CQ014816;
	Mon, 20 Jul 2026 16:41:06 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 20 Jul 2026 16:41:08 +0800 (CST)
X-Zmail-TransId: 2af96a5ddf2490f-81b13
X-Mailer: Zmail v1.0
Message-ID: <20260720164108387NvWvBxxTPdY-K3EVodBZZ@zte.com.cn>
In-Reply-To: <al2Y2YrGJceZ8agI@fedora>
References: 20260719113701797vZ3R8NxiqYt8dEfeUxtON@zte.com.cn,al2Y2YrGJceZ8agI@fedora
Date: Mon, 20 Jul 2026 16:41:08 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <hao.li@linux.dev>
Cc: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vc2x1YjogcHJldmVudCBwZm1lbWFsbG9jIG9iamVjdHMgZnJvbSBlbnRlcmluZyB0aGUgYmFybg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 66K8f6CQ014816
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 20 Jul 2026 16:41:08 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A5DDF24.001/4h3Yrh4K3Kz58fdL
X-Rspamd-Queue-Id: 40B8714000A
X-Stat-Signature: uxdkx1eq1orxijqm97kh88fr6mojg4o7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784536881-318222
X-HE-Meta: U2FsdGVkX1/Y5JYiqlKNW+cbtBHfGH8Uwt1SyHBDgW6BxfoX+MsBj/pYEDX9QnfnKolfVb8kVgKogpATU73eYyFCfs4yrGAOVBEnG4u6YQmu/KiPwQ1Y3JwnEc0BH5RWZwzii3GLtBpZDJ2B6EyHCUOOh8haTq0uOSZo/U5QVn7839LA69EMdnTmnZ3hUGS3QoR+yFHeSy70HcBQpSqrgP2kaffx19f/AuvMuWrR9yTF2/N4Vb7tqYuteU4jNunmzvlRnaPurUVgAH1zJ/MW96DWt8Nq5cLS1PHNOfaq1B9PYZAkvPZAZUJysqgxzCVSSXCZ8efR6NPTx8JqJ9LVBFzXvGYCLbhdopoIqqv7D8dAJ+evra+Z92YNl66mjR06KNkq35WwmGNjhsS/If71UL5louKJ6BarrkuCaaoPL4HRGV4FMREPkq/GvLNdAwFxg2na2Lflow2X/SDGxDnqmH6lEbQ2NkISM6PJTWDzuTvzMryqNNMLuMUt9RTULlIPxXA/wAr4uIwUrS7xwJkmc/yq6zxT1MOMDbQiRXct2LqIsDaHObK1o4oJ3QAhZ3ENpDyasCIWYInE9s3xniLqAzU3HjLwZFo39hS2QiPF9cBj9jqxeZCTOcQ5BNTbUeXqojpPb7tUojl0Ghuv/gvnNpHZkU2n5epmcWmpYQ+oDys020KdqMmfMMXciEDBTgsobIBVz0pmx+ztIifIbzDtRLWbiV6SF7W7QI5CijH/LIx4A+IBx+713PS1QohMAFPDDulZeS01fzJHnHv9QB8PzB8mkdE6g7p7Mhz44Ig+SNF6LkPaMqU7qB7cReKOOhzAL04TM8uF0O18iWspKtZkf0RMWhTf95TqASOQCuhL4duXx8nb6hThBycxt/SiGABWcokG3dsIguxDu4vOrjS9voH5m4lzwFkfpNM3/JlW4UH0Qa5RKwzctyAGIBdZV+j3gsOHEa9HFCiQ5vEJvQK
 FEfyQTnB
 E3gIzlU8oRt6E5kTeX4EAYH5GnPbs6P8xV0+dY5k9Ztd42DGMxC6XrZoHFCgLvnyQ1Z9i7425EfzHWs3eUhL7mRewjky+qzDKkcvDmenOyp8U6FUdQVWBJSXD2ODoHl5aGPQYjA3hAkWCx4dDBW/QfawhMZRz6DQj6JmKxveZxmSLtHl2QO70Pyheqjz3epPGaLeJ7dgUD35TnHOoRM3DKRLs0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hao wrote:
> On Sun, Jul 19, 2026 at 11:37:01AM +0800, hu.shengming@zte.com.cn wrote:
> > From: Shengming Hu <hu.shengming@zte.com.cn>
> > 
> > kmem_cache_return_sheaf() may refill a partially consumed sheaf before
> > placing it in the barn. Without an explicit restriction, this refill may
> > draw objects from pfmemalloc slabs and consume emergency reserves.
> > 
> > Add __GFP_NOMEMALLOC so returned sheaves are refilled only from normal
> > memory. If that fails, flush and free the sheaf instead.
> > 
> > Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> > ---
> >  mm/slub.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 53b4976d3831..34f17ecbde87 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5123,7 +5123,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
> >       * simply flush and free it.
> >       */
> >      if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
> > -        refill_sheaf(s, sheaf, gfp)) {
> > +        refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC)) {
> 
> maybe we can add __GFP_NOWARN as this is just an refilling attempt?
> refilling failure could be acceptable.
> 

Thanks for the review!

Good suggestion. Since refilling the sheaf is only a best-effort attempt
and failure is acceptable here, adding __GFP_NOWARN makes sense.

After taking another look, maybe we should also clear __GFP_NOFAIL if
it is present in the caller-provided GFP flags? Otherwise, the allocation
could retry indefinitely, which may not be appropriate for this optional
refill path.

--
With Best Regards,
Shengming

> >          sheaf_flush_unused(s, sheaf);
> >          free_empty_sheaf(s, sheaf);
> >          return;
> > -- 
> > 2.25.1

