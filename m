Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724F6D6E2DC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 20:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0CD46B0088; Thu, 18 Dec 2025 15:05:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBAF46B0089; Thu, 18 Dec 2025 15:05:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9BF66B008A; Thu, 18 Dec 2025 15:05:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9F5B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:05:54 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72D821A0330
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:05:19 +0000 (UTC)
X-FDA: 84233671158.07.4289CE0
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 660F440017
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:05:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EQmlkq5t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766088317; a=rsa-sha256;
	cv=none;
	b=cZGZVkb84yqfIWXVYTbQVN7giuz0SQ2Id8Sb1Vx9kSBOzHFX9MNaSr435/Ccirc5iwUIMy
	2t3/JmtVYK9Qqb/l+M3huFQrYJ8WuRA2CeQjUsn5lkdJxBDvfzFQ4+vJbqs8vG1zr5bD2D
	jbOptw9wDTTsxybFrSaWBzqs1ku3ywk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EQmlkq5t;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766088317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2w2+c+YKiYKr2r9Xowor6oYCm9+yfeKolfOeIUsbJQ=;
	b=QOKDtdxRAP1xaq2MBpXZkS4rjPmyaTnBOoV2PSUV7VIF9ao3aPcSpxcOTQ1fKjgeL233tx
	b7CZte4w+UTMcjMmzCIyNqHMyqAXIi25UpIiXeHz7ZrhvP6tMe59cyR/o4M29GK0V0gn7a
	ea74vHpCAYheduEBPpQxmWDXt2x/QBM=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8886fdf674bso11539616d6.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766088316; x=1766693116; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K2w2+c+YKiYKr2r9Xowor6oYCm9+yfeKolfOeIUsbJQ=;
        b=EQmlkq5tLenj1DncIb/KBpWNk0wOot4qb1f7atU9WqBwcMSA2XTnBb9AAMpKISNAJw
         1vjcMucI1TrxSVDbb69Pzc9+1yCa1g/k0otOzoatKpa4IN8CMTtdrTuKfxagiTfO8RDR
         nLHBiyPUv2uC1qDcGT9nxUMFaH91xSBa+vGJT6iQx1FjydJHdcNGawWlIv/Wn50upEOo
         5yuv9i/ADp+1p7zxKfUkt8fm7IgvBLvEq/7sVQPnjBUbjbEKYmJUaOEeYTkS8AtQBcYd
         ePH9bH8RKNEPj1HlefPO5UEsdmnYnc7K+EQ9LvzT+wW31iTSvcASn3nxLI02qyAlp/Us
         +JIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766088316; x=1766693116;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K2w2+c+YKiYKr2r9Xowor6oYCm9+yfeKolfOeIUsbJQ=;
        b=ogS/KijvThAGVdsi/X2jM9bIrh2PNvdjz+qVEeePTGizeoQWofQtV6sYo7C+xuAUal
         WCFHrt3ivCZpPZ6v1GqjRo2J5Ataj6IknL2ITM+7OFnMLMUL9Qz827c6R8G2Dd4sfTur
         hS/7jTa23XznmYukTIx4Ap4e1l3FDQM2kRlRtwdHjT6yF6Rp7GKPkT+VznUrMgf2XcF/
         HE4TP8XoYEWsAn/ie2X8W2z+IgI2eMYW9Yzyt81C64H6PpDTzyym+pA2RqP1SlQm/FEX
         nzHoI0jQQzwWqGepnpXxisZN48TX3BhLTFA8XWUE36rRxIYKqQMfNXLYJ7FNUVOcH6QS
         iJDg==
X-Forwarded-Encrypted: i=1; AJvYcCUPVrxeT5q5Ag4Q6CGL+ObMAkLqPDh88xhWHgsRrf2t9537WABr5O5usALe3rzHjzNldV25H/iLaA==@kvack.org
X-Gm-Message-State: AOJu0YykR1qg+17AJDgyKxxEU+/W1TmluGe6+E2GSY6E9sUYoD4W7lTU
	ZzpjdBkw2M+wXLuWOySNjzFIY/jVqnfD+mNIf7m2fCxZ+WmMrNejLI/qwWGB8PDHKCW6dUAnDRA
	IjCZVkpQTPZM1ofXBaVF0DobKxjRVL+Ws10lj
X-Gm-Gg: AY/fxX4FEXJj7MsS9HT1uc0RDQVgaeif2o9oACfRnTi8wyrSW5Hv77ZdZO02JOiGTBn
	Qus8l435JF6PTGbVQIlIqxWZF8S52BA71DjMurechQqbgM2zo446Rwo5NostbeEghC6zLSUZlhj
	Ki47IsOw95giLMkGsqU/QygjJcMfue218EU0cDf1W3Am+cTxT4VgDMjsy1lbNqrTjNsLzpi5Bpt
	Sca8+981M3joJl93ixuxhdhw5tmH+B8wr62Mfd3xK/l05udmVj8cWZZZFA+tuCTG1Lr1w==
X-Google-Smtp-Source: AGHT+IGfIU5RGxtASwu3bgpX3b92cFmnR8DyddSN6GsrTR4BnDx7NubHp+pRDhWWPTmxwurkx7B44lRP57rfNIwWyMU=
X-Received: by 2002:a05:6214:4e07:b0:882:4488:482 with SMTP id
 6a1803df08f44-88d84434111mr12774246d6.62.1766088316168; Thu, 18 Dec 2025
 12:05:16 -0800 (PST)
MIME-Version: 1.0
References: <20251215053050.11599-1-21cnbao@gmail.com> <aUQJEa643lQAGK6s@milan>
In-Reply-To: <aUQJEa643lQAGK6s@milan>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 19 Dec 2025 04:05:05 +0800
X-Gm-Features: AQt7F2raxnY_WBDzIdYwiT21G3LhQyvH-Z-k4m21oQXjYaLgAcLMtZPi1-shSsA
Message-ID: <CAGsJ_4zwqbg889+CTtO8XLQZu+rFs-m6+kANKO78-TAf4zjjaA@mail.gmail.com>
Subject: Re: [PATCH] mm/vmalloc: map contiguous pages in batches for vmap()
 whenever possible
To: Uladzislau Rezki <urezki@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	dri-devel@lists.freedesktop.org, jstultz@google.com, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	David Hildenbrand <david@kernel.org>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Maxime Ripard <mripard@kernel.org>, Tangquan Zheng <zhengtangquan@oppo.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 660F440017
X-Rspamd-Server: rspam03
X-Stat-Signature: u3mizfs4ug3xb75xbwzph77tmz6kxix6
X-Rspam-User: 
X-HE-Tag: 1766088317-776492
X-HE-Meta: U2FsdGVkX18qpq1tYfP17+8/G2mb5DEwMCX4lVLioD1gRbbGufbRL8yqIKnIJyRNp23t2MdwF+Likq0W5CBCLKbti+epmkfP4HJbk3hl4aB9U+ZcPWNTd2ANA12Ec+a2KDR+xku7eI1l2e0t5CO+W3DcwUba5C9lxTu+LKnSR5700T1kiYvLoWtLFmYYHXzmAaBlBE7X7CBeql3s3MqwRSm8v79SG6Cqzz/eCbhHKU9Le5H3YgjvB0kWv5H8OI+6hi18NSaHdGbf3YAYaXoTSK3Rd6s1djSPUs09HH6OvMjFK1lRwQ6//EAeErFZXiCEmlR4p+dCmf66n2wXM4+lQx3fw0E6TdUR+L2iTZDy2ay7vbN8qs8uUStKE73m8PT+ftDJUKHGfAFaoI9kDwfK36XCn5TGLR63GaZds+W9J2g+wx/IAbRcs7X5aTU1/7DNqr1OmdRGqMi5Ne1aR1FzjzndWI4ilhPJIU9sj3HfI7PNLFY9p5bEH+XmetFERD3AEzOHANIjGrVc+G8uSHdk2dplMKGPtNTRc7tSmvC3GUXNFxQ0KDioFllK2JssPgy3KzboDI4OcUXFyzSp1Vcr5MIq3jVJxNaxBgjQzTXuJP83DL7ZHh01zU2VM8lAWIwCAokT8jYe0YFi27WHOPY//VMxiQpFfiMrd2P82dpcYMc/zmyMywrED3wqXLFsZF5/juOqbgtThKkDinzuNBDx0YVnsu5TtanFZ8r1AcYmooeSFjM57JEjEBl1a/39tQVT0iFzWV6K8FJjnIqP5Fl2cHwb8j8UpTEpx3resdEuEtfjpJz+Mvoxvau8/7Onm9aztLupxG33RX85Jx+xEzpuq8TWOiWf0BQg1x9yV0Q78Vrhsyj8anWXA8bqphWa/vrSUeSMJjr8ThAPwL3Nwyho5okelbwdSMWx3s7j0hzxQ6xGrXnXNHJyFbnKK/bS4jmftJUU4aREk/UNvCgdbUa
 JAeq2eHI
 V2WOu6XnfGtfKIocGAY/m///9I8XjZpvY+q2M7X74/d6vqgmGe9orDa/QZGcoonY1T8FbuMe6lCMBkg9N36qsvSXpONsEbxjCLD7J8argWoULgdu5RYvg+c60zp8/hgzh+D1DuVHmu2nGS772rqCg3KeYl7emqXmGroMxmaJEORIvxjMXlLZLXj64hGOYOoJkwJ2ce+PbEb9QLk7vvJrBbALrFBHfIr5Aqxf7TakhfE8adDZd/fZChtghOQYP+U7RKEUEq7iu+nuOmRg6vOX76qnqMvgfq8QI8Vod6EO9EwuYZqoA3qTm9e0+PiR9dm116Xw3Ye8ZjVy4A34gdHqasosdADPekSCJbGiCHewH7l5a1nA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]
> >
> > +static inline int get_vmap_batch_order(struct page **pages,
> > +             unsigned int stride, unsigned int max_steps, unsigned int idx)
> > +{
> > +     int nr_pages = 1;
> > +
> > +     /*
> > +      * Currently, batching is only supported in vmap_pages_range
> > +      * when page_shift == PAGE_SHIFT.
> > +      */
> > +     if (stride != 1)
> > +             return 0;
> > +
> > +     nr_pages = compound_nr(pages[idx]);
> > +     if (nr_pages == 1)
> > +             return 0;
> > +     if (max_steps < nr_pages)
> > +             return 0;
> > +
> > +     if (num_pages_contiguous(&pages[idx], nr_pages) == nr_pages)
> > +             return compound_order(pages[idx]);
> > +     return 0;
> > +}
> > +
> Can we instead look at this as: it can be that we have continues
> set of pages let's find out. I mean if we do not stick just to
> compound pages.

We use PageCompound(pages[0]) and compound_nr() as quick
filters to skip checking the contiguous count, and this is
now the intended use case. Always checking contiguity might
cause a slight regression, I guess.

BTW, do we have a strong use case where GFP_COMP or folio is
not used, yet the pages are physically contiguous?

Thanks
Barry

