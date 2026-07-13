Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88E83C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 21:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 767E66B0005; Mon, 13 Jul 2026 17:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718BC6B0088; Mon, 13 Jul 2026 17:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62ED56B008A; Mon, 13 Jul 2026 17:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3ACF66B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:26:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABBF9160193
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:26:45 +0000 (UTC)
X-FDA: 84985037970.02.A976553
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id CE091C0006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:26:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pA4WRF5W;
	spf=pass (imf10.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783978003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5k6F2tNoLGYGAlUHWdIU4sT4ZSqv0jTiqRc+bkYGypk=;
	b=nEvOcqLJ9YH1HFQzBg6GhczfkxkYT5VKYU65H0KBNPH42fLe9UrUvwOmuBSFa71rcxbNML
	nj75LK7D+x+aYynuHyW7evZ4kX3zDBuHIff69rg/Ieoh6D0OIQrGdiDjHnMXUnSnER6bOd
	Le9RC6l6f9rIYEbKubesfVqGa0eN75k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pA4WRF5W;
	spf=pass (imf10.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783978003;
	b=rXe5Jm1SDuL6jhV/imX2bR4jAZwH8ciebE8xcmBEghn23V7UNsEbEX7MyWbJc7uL6tk3o1
	ris8iVMqzZ0g1G9uP9gBtyYTdlLSrqZGzoUNBVAED+tyzaEUK1RUn32Xt3FRBOO3ClJfof
	40qIcZrJABDm64rV0GG/t36PlJMRahY=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cacef7d299so43935ad.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783978003; x=1784582803; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5k6F2tNoLGYGAlUHWdIU4sT4ZSqv0jTiqRc+bkYGypk=;
        b=pA4WRF5Wt2hM/JxlTiU67m/kKFmk3DWVYZ1tEWj+f+A4GZCYPM0ZemeeBaBD/fgV8J
         vUnyvSlN3hS1vw0ceU/7ebObTyvnWwzJJcBeEqusiBbFZo46m9VY1nq9wNQ9FmOWfzZg
         EBqVbvCZBVyxnuAqx03kHX8XiDl9XG/yLbTSNhh5y6x15WEcSa9sPxixKIYJRvnxjfr6
         u6oyRX7kisgmpXkYgySLN6RiXhV9UVbXqz1sJRipT7zAlAGg6sIIrwaB/Y2K1kcoOFni
         dediw7msZkmxq/9Evc1DmIF9+rEeGJWvZ66Mil8k14Q0RfIHEc6+/L4ybvn5EsqcwBIH
         rtwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783978003; x=1784582803;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5k6F2tNoLGYGAlUHWdIU4sT4ZSqv0jTiqRc+bkYGypk=;
        b=e5c5sWZN3MvHb9mFQGmlKHJbTyQ1Wg/pBYpfb09tmVkI5EiW+9D65AmyZZbZYkTt2s
         i2bn05S4h/8zlsJSkX8hIjsfJ97j245RQWbPcFefl5DKA1eq+ujSAfy2CB9qSMhU1rId
         7Zjr/UUI8ij5zcXRHstM0LFiBmHL0uZS8xSgPkZVKevh4FNeJLit048GfE9kCgkBXa1F
         f6hJ2ebuj7ulCULpQxaOhBxwFswj/tl9mL0Jkz0cTFruLtCCbwLWeHxvOld1MxpDjZq+
         7xTmjKFCvZA3dx6Uu9CAz1T+KOpqWSP6lDfI6Bbh0MpZP3+WzR+iV5HH6CSIDLYkFYfG
         p2Fw==
X-Forwarded-Encrypted: i=1; AHgh+RrwqUCCBI7HShq0LiAyv5R7ClWyPtnCIkAsS07GmVSg6BhA/kHsL153sFvi4D2OfMAAMep8HuuO2A==@kvack.org
X-Gm-Message-State: AOJu0YwFGjzycN+resXf8QPi+4bIFheHRpzmg6SjL4yoP6mJZ7udaWUz
	DjhHAxJaW9kYCQhhttfIxYWT737839RF4D77vlY3fGJCRVjXC5HT0L4l61laGlVmyA==
X-Gm-Gg: AfdE7clEhwmEr5nc0jAMDWe8VdQR59hmc2GZ0luKXOgwZ27K/0LqNucL36AQg0zNPWw
	NfKJ7Cn4qfZgrCuJuoyiBpDMv/aR5sBOXve7woq8ZKGIup+3FTGM5KTMQ0hZFVd/njX6whC0L05
	Ury/gu+51OqQs2LPeb9/tdSsmRzaxtxAKSky/jSqQt8Nus7aKfaaWi/lSN9pNwB9IXHTC6quLNT
	92hETGwDo9SDna2dTvRoJvGvySbzAQm+sRq03hU+av9lVudzf+EP8m0XLnlIWwY+Za7KRE+bZ25
	KvHWjlzxNMLfSt9zFspMoVnZ5OohKBUt4yEvdgd7yoixZf1bsidvYUYqrPt3YqJbnR2C1MTG17Y
	qq2clp+BJ5bVwgcRtmpGMas/Wpmv9IHthyxps2h0rdkV3OD+zWqa/mpnlJhvEwjuSMi3srfKjvN
	yq37s/kQnoyKvI7+84H2jpV65tM00dMxh0LBHPjzf5RHOc4zkykaH8X+Pn5zHEA0xDokrQ0MLmO
	nJn2Bm5mtE=
X-Received: by 2002:a17:902:f650:b0:2c9:cb98:f4cf with SMTP id d9443c01a7336-2cee1c08775mr3093235ad.14.1783978002200;
        Mon, 13 Jul 2026 14:26:42 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bf77e4sm104688515ad.22.2026.07.13.14.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 14:26:41 -0700 (PDT)
Date: Mon, 13 Jul 2026 21:26:38 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] kho: Introduce a helper to init unsplit pages
Message-ID: <alVX_DWAezlPyU5n@google.com>
References: <20260713204935.3069000-1-praan@google.com>
 <20260713204935.3069000-2-praan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260713204935.3069000-2-praan@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CE091C0006
X-Stat-Signature: hdrb15i1tnd9xw7ofzni1gfxh7kggnxj
X-HE-Tag: 1783978003-150760
X-HE-Meta: U2FsdGVkX18Ak6FewHKPenY0FqzPIJsDawDZ/Po7898Z21unqXr+HGQ51uuoc0LPvY3jINTY2ykbrnb7J0LoF9EriYF6Gs9zAyz6e38fW9IPIhSA41TTZ0G9s8aJVyOQdEWahlo97ygY9hhHFbju5c16dOZyzTX/Ybxvj4FrslMb3oCmGIOdxE9IydrFyTJQgRMATNuk3r9+MJ5Mrmwkb1eabcBuZheabkzEVG49Vjdh3ks/vRG14zbFyzxzU6JOYU+mFCM3FrEWDrs52imEGWO2EJ9/RZjgUy7n1+afeJR57bt0MYI2S5En+HqkzoFvgrFMRe6x4D+b0UTUu3iG7evHXi0HTuYLmrF+vBC8VJViJrmWKAvSLUlT1/dM8A+prTA6+1gkGZxg38lz/OBbac+C8G6gkth0ZkXpjE75rqm131KWdSpw4M5kCUp+bIqIVlKFKjUk4fSH0wI36QJVJXrHCMpym33ozwojS+SEon1beOuytgRIFCJov5r+ayq7NUprt/ETocH0Aj575ISfcWqQ6tostAmiZfOxmwwkiuz4wD16L24v5Iw523Y21l1/Q4qXwUfO/4AvQzcOOAaHKqK4KGyXga/lwFE4K7BEePupC8jD/bXeuRsVjKOb72UIZhQN3+g1hEE/mylfAjx7Cm8FUVzGxJU/h9OyJuLLglKyCHfxEZ8oXs48ep9G4lBLh2jSo1MLQLB+dVCEMuPfXOxU5F7t5JlIIfGEZYIQc8uvdfWbbsJBo3sZJ9iB1Bcrlc5RjYFc1yozDmXF/HWhPxbFuQcHb5EzN/+myYr1doRj8fQeZM0MThp63ZClbCKAIZzgmWMqZvLexUY/X+Ov+cXvidnkIpQ5HjWMsBfzFws58RUMQSaEXW4D47WDep9+dHZug87Hm56Lg/EWtuUfesNvf9Kznc3g6JB+eTO2euz29VtTFsusZV1lqSQXZ8wQss7D77ugNSbl6bdRtVO
 Lmy0OkYq
 25PtvcrM/Cv1bXPL5+n4sEdueYmoo9DNh128d9aS5NcMb7nJg87DRARp4+HuUEVJ8F2p34PcOlp2DROdDk8+bBBWGuQaKhbdM1cZPKR99Dy7yEBNq3AO7S2Maod2qtjfWWcijGLEn5GhXGSk3qApZ2Mp9JGekI8bRkTMJS1XrLICu7qOD4ErtPiG9h+w2X+BEjmHqJDD/+QRvPiLILisp2xL9cje/ajO4yV0vfIn0YrS2e4LitI7Abklky/1PtqUXuhQBuMpZCcEh6IXSt48EBwX3whvgjmE/BJw5IQnOgzZwYWKEiuf2ZvGgtwXNdHKqvD+o+cux8ex4I8sJB+xlAS+o7HLVADbqdfXL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 08:49:34PM +0000, Pranjal Shrivastava wrote:
>The current KHO restoration logic assumes all multi-page blocks are
>split into independent 4KB pages. Break out a helper to prepare for
>supporting high-order non-compound pages.
>
>Extract kho_init_unsplit_pages() to handle the refcount pattern
>where only the head page is refcounted. Use the helper for folio
>restoration that requires a similar refcount logic.
>
>Signed-off-by: Pranjal Shrivastava <praan@google.com>
>---
> kernel/liveupdate/kexec_handover.c | 29 +++++++++++++++++++----------
> 1 file changed, 19 insertions(+), 10 deletions(-)
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

