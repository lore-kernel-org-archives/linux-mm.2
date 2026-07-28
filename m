Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C335C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 02:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4ABB6B007B; Mon, 27 Jul 2026 22:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB586B0088; Mon, 27 Jul 2026 22:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9E806B0093; Mon, 27 Jul 2026 22:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89FFA6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:11:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FE0380267
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:11:09 +0000 (UTC)
X-FDA: 85036557858.28.4EC01AE
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 49EEB1A0007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:11:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MHYr6sty;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785204667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLHDrhMW+o+sk8jL9WKx28pORaiwvHk2tgWPS/i6EXI=;
	b=ApY8iW5JQOlbmghPF8Eg+W8tSFso1IU+lNO28eFCY0dHuHAUH5T2rlo3UeKuO/8cg7Dbe3
	FXexcik06jW55ffKfopkfsUJCp+MQCYPi4xyVPg90EsV9OPSIT+J9koHCcAbHcTVmvLCKi
	SqzD2QpoxfT19n7R8J46aB3JViFpg7E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MHYr6sty;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785204667;
	b=uoI8yTxRi6r4/lf7T8lHSwyUqrgCMLRE3w7jbgG8Mgp7l72IfzJM/tZ0e+J1rWKjZ8oiQZ
	GI4ncuBLT2nXBqVDfc3JbP0IUq1gMTkphu+yAbgb+/sj0jUURg8zrMSpgkwIXz+NVubZOk
	br8GArGykF72heRpbXuHWSfPnbI0P0o=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so49395305ad.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785204666; x=1785809466; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vLHDrhMW+o+sk8jL9WKx28pORaiwvHk2tgWPS/i6EXI=;
        b=MHYr6stywUR45SohOp1ZyBiZdoqdoNbSDYKMHcwJaOqWCUlr/N84wPoefpjz52r5eU
         Wrew0M2PX6fRypxiH3AX9atLMq8eT+IOIbtoNZWJvhEWuQAT+lc1ZPAZzXr4Cs2yxu19
         5Q7xZuM4dw/qaZzQUnxGYXrkQ+Gqlg4HkbO1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785204666; x=1785809466;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vLHDrhMW+o+sk8jL9WKx28pORaiwvHk2tgWPS/i6EXI=;
        b=T64wjoGe6XPw2YFhlY1iei3OtYfLscdqqkOmY4XO3He2H/E7fVF/efu6VmEMJFS+E1
         3/5fmR+0bUihU808CC93xvPhkpQhdkBNu/hanOrH16mZnkfnjQj9HAIFrW84XVej2I/b
         Fmc51IEYanPnlMw0HTrbqKGlgigGoCYFiKhsMETXhD04ARlLu8yBjr9RNVb57Y68iISt
         Y9KxAF6I1ubBK4Mzhh+mghvu8T6eZhJtweGdKW91eE5/zbiaj3Zz/h4JwOhRoeyvf/Cu
         CYqNteW7yJXYY2u2c5TADFeT2BPeBpM1XY997kYEjcno2Q9AM/GVLlbABClz7AIm1gHL
         1Jow==
X-Forwarded-Encrypted: i=1; AHgh+RqX6qsSU8eT519pO/TVHfaUVw1Uh35U0H3j0mXr/4Ihq+A3QVX2IIM3ukWq2V1ifmK4gmYQ1aqShA==@kvack.org
X-Gm-Message-State: AOJu0YyDhCOSOlcjAoFx9nFg6xMC0FfoXIRNYDE4owMXXJX5wFY7jNru
	CB/LhnTUa6z6286Cx+4eybm0CNMp+K/VM42sB2chuSNHczPkzWDKkLEglDBx37rTLQ==
X-Gm-Gg: AR+sD12b2pbGg8sIkMqXd5FQGLCHLJ7QuIC24vohZHmfv6cNc0YMYXQUrffBRQ5cVgf
	aF4HsxCxubt2B1XHbkz0yKQo68/EKHa7ztM07BEp8Yqbo8W/qbcYvdrT1EtiZ1VFWPmnt/GCyJU
	PrkW4NAiaxK2vvz8FuciPVtCpIwy+++NmoaHqHjphfOY4vGzlPcsNgAoRbzkVu0w2AP4BQMxYpT
	41HyJUVE3npGQKmlmBqEyOT18YlrRld8GGobt+Ob5JjveRYYtdK280H0pJgF1GqTU6Cu0w4wHM8
	mG5e4TfcQEcGiPxHYisOQ9uDCkkRv5oxtSRLPDdQcGj4pxzfJGQHcDtiFBS/7X5DlUK9l3fFbxX
	fxmi2ChYLjR3L+2EuSSYWTPAvQLC+LvX1Iclyw6oIOM76IUyaApVy/aMkINvgDdHVUNCPe9ex6V
	Ba37cdTe8k42rX+NHODgUG4tVdsu7fuuani6OuILX5Uw==
X-Received: by 2002:a17:902:fd87:b0:2c9:e9c4:82c1 with SMTP id d9443c01a7336-2d015f02158mr4270555ad.26.1785204666054;
        Mon, 27 Jul 2026 19:11:06 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:f891:e0e8:e2c3:fb20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde5c7678sm43424635ad.18.2026.07.27.19.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 19:11:05 -0700 (PDT)
Date: Tue, 28 Jul 2026 11:11:02 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Hillf Danton <hdanton@sina.com>, Kairui Song <ryncsn@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 04/19] zram: remove max_comp_streams device attr
Message-ID: <amgPqitDym_MM9B4@google.com>
References: <20250303022425.285971-1-senozhatsky@chromium.org>
 <20250303022425.285971-5-senozhatsky@chromium.org>
 <20260707072524.9IkUhJ8G@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707072524.9IkUhJ8G@linutronix.de>
X-Rspam-User: 
X-Rspamd-Queue-Id: 49EEB1A0007
X-Rspamd-Server: rspam01
X-Stat-Signature: 1mdz6ojj8fzrg9g8x8j4yxjs4oy6t86k
X-HE-Tag: 1785204667-816014
X-HE-Meta: U2FsdGVkX18HnVrkYSnIqyQr359Mnn34RK3mo0nUsSexyNMwG8O8DUFHcU0rQqIyIShYO6Vyv5lro1wnlr0qLjZ+rZSBNi7y7DWxscU51Srw5n6aBDyjdgv6Px7KjguK3lVIPthenzWVxzhNWXI8z8EgqW8511FxzA4MU7g8x5CX8BeproFBEEHCZSvBlcvLpgwC5tYtaOHe/G++cnj//j2wN4/xVM0MFPYnYQ7V2eTjgVgNw1mx8+tHaqrVztiDyMM9TIz8ByHqGNROuy+2n/9LFRiONb8h7a0vt3pJ0d1KNVMUbeFvUtKGEd19/FadyCZV9ydxBk5ETqTOVuyrv2kXXm4AqzXN2yRpb0uuTfrDzZFXT2Go0YBQNyp+xUlW8PPsq8YM2/bkYbKexCBDm5hv3v7W24kn5BM6CsXbEv6Zvq30FtCc+Lcg6q2KQ0xwnSWwLam5ZPmz4LieZJw7jRueLc7hpKmAo2r4fzLTF4y4GKzxMYfSVJlPdeHjHkiWHcngydN8/KnERTr92hiBa9of70aj6RkUEcv75rOEudOY8kR+RLL/Nh8X5B2Vy6NiX4erWty1LsFsy+b5VUVuwxgOcTZaibygtAIy8slds8fOOX9AMSDLU+usxiu6moLquNEgBRJudKjoBdtmYFUPVYZgAr3LB+zLG05Y7m4wma6FGwcEInOkIopbqMLUcdTun8i1J29x9HvWE8M8pacyU8H9leQi/hOgidCjSc95kSbRG33dj6I/c9voHcjmT0CYX7pXd6+TS/ky1/urDCpj48TzAqF+w4JHwp2pqC6Omf5Qbj8BlEySjkA1Filk27wF54Jk7rgzt7CIpmBAkOdux0GfAbhW9tTKkXXgTgRIm4HcnGz+oiPRM/I0cJKu5GOGPE00289dGe3IUlStuNjrzAIh4Pk3Fx7tcgKimbK/r5K7H5ZbwatSQ+0VlDKQ3m2RtsHa4FN4RV+cnXOdpYB
 M2Y6MWmM
 +B76b5wNRXOzQx9sn3SZeYSt2sEBIn8kfixc8SsOpuCxC3icTfcnsHtQeXtitgrUtG57WTlQL6P1+CAfa6ZzgZ2AIgmDzstZJFTIFrS6m/9aKspnuvSxgpsDOQp5/VXfcujcqFC54KCfTkCuCt9qtJ2I9iPoth1xgaOIWp0BB5qpLmpaOnaizT5/HHbqQFLXgnGAJSq9Qy/pEvs0WcZplJ/W3Z6J1zSCt/BIEb4kXzbcyP/xY+qrSJsnCK9BivaiT+STE6Clm197zj6VTeWBdp6EjSopdwqaBZg1dPwu2xCfUmYfGMOhlTMH9MgFjaZFRvlo8VGfInvtsS7vuYUvQS/WUXiPXn8R+eQ4MWyqklaO21LlrEqzJUG8KoY3fchPAbn52tWIEg+0N+faqvMWP/aGiD+GvIzhn3rWH5/k2XMatFkYdjXZ97iIKRW5COWWM5Yp6NBreC3HUO80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/07/07 09:25), Sebastian Andrzej Siewior wrote:
> On 2025-03-03 11:03:13 [+0900], Sergey Senozhatsky wrote:
> > --- a/Documentation/admin-guide/blockdev/zram.rst
> > +++ b/Documentation/admin-guide/blockdev/zram.rst
> > @@ -107,7 +93,7 @@ Examples::
> >  For the time being, the `comp_algorithm` content shows only compression
> >  algorithms that are supported by zram.
> >  
> > -4) Set compression algorithm parameters: Optional
> > +3) Set compression algorithm parameters: Optional
> >  =================================================
> 
> You could take the opportunity and remove the numbering. html links work
> and you could refer to a section without the number. See
> 	https://docs.kernel.org/admin-guide/blockdev/zram.html#set-compression-algorithm-parameters-optional
> 
> :)

Looks good to me, thanks!

