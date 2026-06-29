Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EDC6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 19:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64EAE6B0124; Mon, 29 Jun 2026 15:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8B26B0126; Mon, 29 Jun 2026 15:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451316B012C; Mon, 29 Jun 2026 15:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 091256B0124
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:43:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C5BE8CB70
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:43:54 +0000 (UTC)
X-FDA: 84933975588.23.D8C882D
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9874440003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:43:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SjgmbZAh;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782762232;
	b=Mk3PK7x+NO0ztQxmIV+KD+ONRwoznoWqfU39rFYl1J5tIQIqwhfpVu8xjj9mv8rbou0evN
	rkA8JmmjVecRUOOfK1OEU+0Lt46Fa210ha2FC8XEcOLBkp736xBcmg76th+8n6NFwZwAf+
	R+a+xTMGl8UK5pXtMT4YoxtFYc79vVc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782762232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YpO9o8eBWwEDpQBKixvSvSC+ysdTw08zIfmp92hvBSs=;
	b=u69ltjatEPn6HaMU/TawmXgDte+nHEFJLYMEmouGiEj2RAWMQVa4CGRQXgTSQbQLjzm5SK
	tzPBedLu6JHG+VVIPcrvl7d/At73rUDQaQ0c0X85PHBZuNEmJwayesLYHDgSz6e9TQ+bTw
	t83NXN21EG72X1r/+0OhB47tSH8xw5E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SjgmbZAh;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4924593f45dso48542175e9.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782762231; x=1783367031; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YpO9o8eBWwEDpQBKixvSvSC+ysdTw08zIfmp92hvBSs=;
        b=SjgmbZAhHE4+LFpR99HuJPLLhWoZJUOuWBlzwmxmFj+pKw4OztfkmSxtCkJIEBQwrP
         G2GFlkc4p5XEr0cUwLUz6A+6hA9q/rdmBmWapE+LRceg/XgGRcjE5D5zSfyBZVVXHEml
         uF8HbMbSh79ewN2nrUou8QLBiQPh2MOlfX+BE6oiPBwsCj/NW84WJblt1nkS7g1bSk0X
         Gh2QavNcryFOZiJzSvk21ovMLIEiu+8pyYIuUK0li2wsX7kpxhOiJi8Rr98z9qqgBG8j
         kE+BNm60OjXwdiYZrQrUEwzWpEHLOYQvZ4bECcxJxeZLhjbU5oUEwP2QzgDabsDTihzF
         XUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782762231; x=1783367031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YpO9o8eBWwEDpQBKixvSvSC+ysdTw08zIfmp92hvBSs=;
        b=tQe1mZDEnxZyUaf5GJcCBAyMay8pcbUIT6fkuh4+yi3Y+VVg4jYjc9b94WkBIvqOgE
         RUVcXzj+Vap/X/UQ6exgwyah3Xcz+9kLpszu7w0BIuirmq8v+TzVwm0TYS66MgtkQNnu
         YxEmz7ocyPJjFCoj7IY79Wip9ao9DdCaJ3Op+In+cZf77Ya1SPyRZM1IsHroQNXdoKPW
         4G9RuzoFNWIZ9Ie2JgNQLqgYBgSKOQ0tULPic6jcGDZ8RF9OavZp9XQaZHK49MWvBPCN
         TtUpgAPsrfyqxVyr5v/Z4GSzh8RsPD2U/oOjinDukiYEmXZk8Fvpcp0bpLaVbFBIlx6M
         La7g==
X-Forwarded-Encrypted: i=1; AFNElJ8GQzAlyfeti1xA3EZMQmGOAsdu+kYjMSee6WY9CPFHNH2fGJ1fNNcqW1cD4TChIa/8MH5O14RrEQ==@kvack.org
X-Gm-Message-State: AOJu0YwhY4g4H1meiGLHVyF6DCGAvumM6sTgEG3bmqFmupGH1UyLK7bC
	jgCs/k+k9G7MAB+YAc9/OWTqGXAi65ZSsSVhZZkZdMr5g0SWCQ1u7PG2
X-Gm-Gg: AfdE7cn80GXhZ04B8lUGFM9XXOnYKC3Fxycpl773CLVsthpY65El6HvzSvuYYuU/EML
	5v9VdpNCsgXVbWeBbbqfqFBWIKkIsgj6TdakN3KcPRoY1v5+j8Z5dJ7FXxaoRLKCZ77r2sb3sI/
	OI3b5WEpxptpYmW0zFG6HTZHXjCMc+VSNc6DxBJHrAQelREkV86YDfAt9GI9r58a2ftxeL8Zlfx
	Pumt6rT1QVkaOwcrbyKG6h9gpSD8QRhpPyjg+5BEUzeWvC8ho5iVcw3nxdI4FcRXmXgm7hXs29F
	rH4A+rUR+YC85GLVpKr0wMuN8GrbyiyoBvwjTPN7LaxtglkYcoNnD6ROTWW0ESjvrVBXy/cB8+B
	ry1bP2M0XL5HbqsnuX7vM1T22QuSZQyJdYEeDvV7Fz2XLYBWq6SxVqdpsO+7exzaXG8SyVL4BEh
	V4qxh5f4OFIp8Mgd9wqWMvSFTF6WzGCJSStHopGwXsi/y03w==
X-Received: by 2002:a05:600c:216:b0:492:67df:3dfa with SMTP id 5b1f17b1804b1-493b82c5c25mr11631265e9.34.1782762230853;
        Mon, 29 Jun 2026 12:43:50 -0700 (PDT)
Received: from pumpkin (host-92-21-50-228.as13285.net. [92.21.50.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493b8ca8b1csm9654695e9.9.2026.06.29.12.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 12:43:50 -0700 (PDT)
Date: Mon, 29 Jun 2026 20:43:48 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Zach O'Keefe" <zokeefe@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner
 <tglx@kernel.org>, David Stevens <stevensd@google.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, Will
 Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, Andy Lutomirski
 <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra
 <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
Message-ID: <20260629204348.2426a800@pumpkin>
In-Reply-To: <CAAa6QmQme+d1rOCEMF_ySwCANsUEbq0mHoq8ijVELBU=d+qPrQ@mail.gmail.com>
References: <20260424191456.2679717-1-stevensd@google.com>
	<da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
	<6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
	<dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
	<CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
	<c070c4d6-a570-4eea-aca0-72eed319a198@intel.com>
	<87pl1md7h0.ffs@fw13>
	<CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
	<87qzm2b39k.ffs@fw13>
	<CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
	<87mrwon5uw.ffs@fw13>
	<CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
	<87cxxgly12.ffs@fw13>
	<5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
	<a1b4b0ba-45c5-4de5-855f-7474918b52ff@kernel.org>
	<37a630ef-1574-4415-b42c-1d23993c6084@zytor.com>
	<CAAa6QmQme+d1rOCEMF_ySwCANsUEbq0mHoq8ijVELBU=d+qPrQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: b4y4qrwznc18noutjmexw3h6y5gr73xq
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9874440003
X-HE-Tag: 1782762232-453232
X-HE-Meta: U2FsdGVkX1/h8KLnFp58IjTWqUEg0Hg4G9vbfd/H19btCT3dKx1yLy/MGH+vVtyu/AnfN0fpautCzJhxixfwbUxAgpU5obLJxWra6qT8e4Nvgs74SxpcO2ugyQan+lzY0jtb52ywzy3VRFX9+OaM3BFBjeWjHD49/21e5aazzULdS7fnHtUkKkHyMBd9JNGcvH4b91Pd+Ib/gLQvexwyuLdnjLH7tYZdYcECP6HZ5Lcz4nR+rxorCRfP9yYikd4c2Xo5wzBHcq7uHmrgwq3ZHKVm9TlbQ7w/J9vpPqsqZGcar68l3tcte7H05M5mxNRhvFnDUT+Pr7TsZEJ0fup2YSUojW7MFRMpqiLMfspqXtpyDtZQr68x0EkbYBa2vO9PXmY/Z77JhYFAL29StZ/YhWSPJgh9YaK/SelSHRgHwlexxXXosIfTEzC72KO0MUciYxuIOpKfwhdedfUHlJ6FghmN1kVaGLs6YG2ZQGf1Pc0G3727ULGesp0vsY/rP3+RkQX9UArQJPEqpIVtXqtk9blLntLXZWItCPWLIItjS9JhcD2hSqmh5SD+uo/jgxzZ+F/NOaNCAlsfP+ml/cP+PlM6oSN6yA0Jz5SF+tg84YxisHYRmtW/kfn/6Zeei09eeBxePIYL6/2cN7mVr/uTGB6qX0fDxxYMaHZJyVfwq3X4QuCJwPd1JJnotL6LscZGMrgLUNh7ZCuh5wNvU4Ien0svRdVUbsKE3b+dHpbG5758I0ToBAFbxxhRwGU9I5FoqhytuoIhwvama3gCRwAKjdR2I1rcfK1MEmgBb+3FF+feTyFknSjzFL/zswxHgVhTAneGjSzW/nf36C8zag3JNM86yIDOaXKTwZKz7yxVtcKMNhyNMXb5hvQpR3C/d2e2pF+NtiTWZFYqrwpSIBsVnPujbIk11PZQ0e6R0MLtZuiMtSOawJUKYYzL379afHOoB+gMbtoXjCbnSRIT5Aa
 1MikNAEH
 yefoBtdbvrQtbQnP32xqhxmQXF6wk8d5GZ3OjY1MD9QHylzSpfuFlg3L2+0hTo16OKeryasiqsGGDD1EfWlJTIDeuBEcgIyMPfM0Z1sOL4wDaGbj8MVu2yUQasKbJOilQn25eVOJGziQQNzb1LStjM8IoBejqQuE5wVzm061ZZ0Eu/hlHAX10Q9/t6sEjaBtXhGz6bYnnfxa2e/QOAxM0scMr4x0eHUF+K0U+KcIsB2x/Ua6qo0YvqRcIGbvIwoyw+D5Coe/kNm/u0ug0sFdnKD+vaQNAM7Y3g39ScP31s+qRMuJ/V9Lk+KYs/aZe2uvYAcj7tAsECLDueTPd4e8bvc5jX+TZ2FeRGPQaKcPFGYJeuIbKIUYlTmoNzXgOgEGbWAAsgGoRmt1Oxi+YqEJIR6DQpSuZaGMSODBNUyjFemWpr4JkUm9vmQLTfiUSrTYhWutPoWaAVhomLNo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 10:29:53 -0700
"Zach O'Keefe" <zokeefe@google.com> wrote:

> Thanks All.
> 
> Yes, we run with CONFIG_DEBUG_STACK_USAGE -- which allows us to put
> together information on max stack depth usage per host/task.
> 
> I'd like to create an upstream recipe for finding deep stacks
> statically by combining per-frame sizes from --fstack-usage with
> callgraphs generated using Dan Carpenter's smatch utility. In
> particular, smatch's selling point is the ability to track indirect
> calls (i.e., calls through vm_operations, super_operations, etc).
> While easy to set up, and working well out-of-the-box, this currently
> results in many false-positive callstack possibilities, so I'm trying
> to pare down the graph to get to some useable data. Additionally will
> need to know what exception-originating stacks can possibly be
> superimposed on the base callstack, for the given configuration -- for
> example, today, only a few places we'd expect to see #PF stack.
> Lastly, I've been analyzing perf-like data to authoritatively
> construct the call graphs as well -- or at least to use for
> seeding/filtering the static call graph.

I've thought of trying to do that getting objtool to output the
stack offset of every call (I think it ends up in the debug info)
and using the IBT function hashes to group indirect calls together.
But I've not got further than failing to compile a kernel with the
required compiler options :-(

Unravelling the mess and breaking recursive call loops is a separate
problem - which you seem to have hit.
(I've done it many, many years ago for an embedded system with no
indirect calls of recursion.)

I think objtool already works out a lot of things you'd need.
Getting it to output a file of:
	'func_x at stack offset off calls func_y'
would give something to post-process.

	David



> 
> Thanks,
> Zach
> 


