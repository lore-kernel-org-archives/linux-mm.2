Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 825FF10A88D2
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 15:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7246B0089; Thu, 26 Mar 2026 11:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF276B008A; Thu, 26 Mar 2026 11:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5B46B008C; Thu, 26 Mar 2026 11:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE0306B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:24:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AACC1A0D92
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:33 +0000 (UTC)
X-FDA: 84588586026.23.E498BDC
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 94D4D140007
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fuBggW8B;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774538671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bIk59MTMskTJurRtc6jFkcPp9I+cldWKz4vCxcp4e8Y=;
	b=xGx0cesRyc+JaMFhresxgyiCK7Z09Lwl88hCRLllzne/50JK3aBWDP6/nQ/+WjtOZr27IS
	Sc1AtFF5C/pOngn8JVLiaomSYkZ4vMOOI8ybUf33RrIGDwP4W8D10CokpFebMXoEfagqGY
	Ytp3AwddVI8oAHjPTpy6jjgQyVVJiWc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774538671; a=rsa-sha256;
	cv=none;
	b=DIYekTpe24bO0qFAOLvLI40cfauvsboDXRQdU+MP1CkEnqfADlTZTS1kttCxPcSOQoicCC
	zHX81RRouaO8oJh/SL9qGjRsZDBWUM68jPrvlENSroStFIBycgBhvlXsJVNRE4dfJOCJx0
	ZdkTtvG1MeIqM/i2aWbNuUTyHDoLSD4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fuBggW8B;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-89c6f61020cso21631066d6.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774538671; x=1775143471; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bIk59MTMskTJurRtc6jFkcPp9I+cldWKz4vCxcp4e8Y=;
        b=fuBggW8BP/LTv1nCEh8qA7owDQPuB2alNAVAcXQ5h8wPCHIj1L1DuLqFl5vk0aVnF0
         Xsak6WT0MtYQUs83jt/dMaxIubPVgCIQ7J0x9VjWXLE9Z/R70gKX30OwtwQvJ/mA/KZT
         uxKAyRCJp4EisLBnlXWuI5dNOzOWdZf0eDhzTjOILdORdgfviTieghE2yGqTcNFwRSru
         BBiNqCnjWGw7sljXzVVbfMdiSocz77QfypX8jkdQsAlniiidQuH8DPq84VDG2XyIa53N
         EykmH5lbAiQvLxi3VpPlEJzG9sPy2BYymNm1NsBkOLKj2px5V04AS7hxQvNmRmwnX65D
         LIMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774538671; x=1775143471;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bIk59MTMskTJurRtc6jFkcPp9I+cldWKz4vCxcp4e8Y=;
        b=T9bPtuVhlgIpy3iY4PgmbyuziMq7s4eQd14d0qIAT7KZ2uKOjQMzc7tmyErk0C2Fjj
         Zcw5lxvsdSqdFurjzgWaFjg1H6SdBMhUzylYWR20ZBNBrhekn5ZJe5H2B4w+mGka62by
         COc7GhNVvDUhKlj0CAq8SEH29e9XSvUFfgxUQCM4V6iLyby2O/lIyoiJ1+qjl7w5lEDe
         s1MXMEGwSqweulp6wK5hh4sjOy/reiJtI+U9stzT346eRawuh6c3z+m2K2DuiWicq6Ek
         6YKMgYteYKh25HTgKz/aY+lNcQCjgTietyFPOUIC6xckxOyl76+nW0oFLO3TWge8mTE9
         eEMg==
X-Forwarded-Encrypted: i=1; AJvYcCXjtboUIMNwAZ4v/BQYcOZ849Hp/wD4TX94o0rQfYqnEj2m0r8FEE+K7Nvh+0SvEeQf0ZaKtfQcjA==@kvack.org
X-Gm-Message-State: AOJu0YwLSEh5miLePRa8L0rqBJLg/FX4HtYnRe/mnWAmfqXiK582myxy
	AzlDa7fry0vwC4QmB5ptTvsPl0IuKZEgr+qqH5PanZx2dJ8LbWxepbxjCDwYV7Ct7gI=
X-Gm-Gg: ATEYQzzy8H7+NvAOG7hBkqTU3AlTExlRXfdH1hjBJM6jHxuqqNDO9dY7f5OaDReKVvz
	wtsjW+u1vjdSkYvFNQaCyKZFOvwGVzqqlMtlYp1ZSlZq70m5BrfO/iLXoPN8qg1v5ijcQhqg16a
	jOUhSzyFMupjnGz+HZAljM1vGZHM7j+xsmt+36ljxcvoUql7KnRdnfrEHHjcfMXVShkRCCxBaad
	NoZLuSrwVWI0uMf3eh2tEjE4jiSMwDdhABdiB7diDqdp+TX6ZH7jdd6DD9z/petol1TgHB3YXW8
	02jWfCFEzZMCAaguGy4X3LH6PRXI+Q+gCpbYJhfrHuVdytBnX8GVVbel/BYYZWSFaAFof+trVZ0
	5JbxXrq9hfmHznZfrsQRxjJxAjsd74hGNxbXuhH3tDHTI/GEXD6DZ0Y5sCEeBn1TRx6tGzqL8oh
	HWpu9u+Sdd3Ui0HYYMDaYVTip3pvACAbI=
X-Received: by 2002:ad4:5d43:0:b0:899:f495:1a17 with SMTP id 6a1803df08f44-89cdde45098mr24691616d6.15.1774538670605;
        Thu, 26 Mar 2026 08:24:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:500::2:e5e8])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd588487dsm27153366d6.11.2026.03.26.08.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 08:24:30 -0700 (PDT)
Date: Thu, 26 Mar 2026 10:24:28 -0500
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	lsf-pc@lists.linux-foundation.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kairui Song <ryncsn@gmail.com>,
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	wangzicheng <wangzicheng@honor.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <acVPrEyfcE4Naz5b@gourry-fedora-PF4VCD3F>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
X-Rspamd-Server: rspam12
X-Stat-Signature: 5hhot6nsajsueuxgpioabhan7bzkw7c9
X-Rspamd-Queue-Id: 94D4D140007
X-Rspam-User: 
X-HE-Tag: 1774538671-509328
X-HE-Meta: U2FsdGVkX18zXUf94VvBWlWoVZH++7Fgj7u8tpg/vhW4Ek9gZwQW3ENRhkjKdoP7ozrQ4oQc6xL2bve0nWOQX7+6WyiLFbQYHHT8ibZKEGS6TGoDnWf9dmDqbQlCHiNDw3HhTKs7LWvuDO0u0dwjjHS0DqIAXLXo73GHxnE0k5OjbiHM9wl2PCB2ZOmaz1VzOm59kZc2BZMp7jUgpKwunDzcAHoHkBd5BZ1suxiu4T3zDujZ7pMUMOb9EqgZMBMyd9NZoCxr6O0pfEWufe15gu8J9Qwp2x7OKHmTv2w6/Vw1wk6/z0TZJAC9XxM3sBET/33S5U/cImH937PXYhWlC/8c6igcdlutzCvh+HYAIAYrOHPxMwd5t2rw9KYlc1TZF/eZZsl8EBf2Jn85/cgmB0PrMK1SbKt0AEFsP1MyvSVufc0+hxoy0W5RTFOVIgIpv31I+3u24O7jvmBDybYBdLdOvEuU1CWK+vVgsGRY/2o+GMlW541y/pB6Jt9nmC5ukmU3DLLQ8QsI3zHm3t6ZJ/xBV3CtmdgsOWQh+ub0oke1GS5BSTDDWi1Oys2YzISCz4eMTnJk4OxJWF29v4YLnd4GZirMPi9pO5YxuO7pgVJ2+7e9HBXo1dMuHA5TKHBaWM4VTdXSSuqVddzUlMY3lTDQD9tQbGryfnFFt26UtV7wuZ+M0kWr15qJsqn7HPZ9AU6U9fg8vQZHhDselJUBFS+meuyU+HFtNRfOY4prMs4QDbj6+W379NLqfXS+jA74rBQV205J5ZulTSmgoq4qXzQJ4GGb9zt7grhNs3HELoWg+A3Kb+0TubO9Knwdo8jc2v+pEGzoDIOT1uR3K4Hm1a+apXZXgBgKkzw+w0t1wMHw8NBm0nvv2elhHQ3rMCph1rbbJ7PC+xReRL/fr4uoyMg5KnEQzWdaM/tgmel5cNaNCqdn/5u9eihUGiLPkKdq4/jqt5NCMX6Cs4ldZgO
 hdhaumUW
 T/RrI2JOVIZPww34lyyK4aZJZVU2+/vNwdqRaSLcoME+ciwjiILX6R9D1BwlPJ5utIhOqhmPjx9lNTQXWU/cWMHNLKpCNwIO7G3N573SWSC2yPuCzdF/oOEhWcRHtUUDtEvOuGfpo8bntYxEyE/uNwA9XV3p6qN0bzuHsfpyKrKmN15EXZI2eebJMB9trpKIijQXwIHHxbM7fWzOQXi0zhRPKHkIrlXFvNi09ADLBZpRi5SNhVh4DPdKNWThLQrLahaWfRIR3OUE3jXoNTuminMyKdJJzPsX04LYeCGvdo+D5zCP+GiMIahl+Yaau1/qmdamo2T3u4foJCkTpQKz4odeCupdaRW0Bq5c9cVVuDpdG6hsW8wgA1MQcODeTCkcmacSt+sOoYwfIR/c4bQF+yFH/8LCZohYos7gpFHh4grzb5Qc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

... snip snip snip ...

> >
> > How Do We Get There
> > -------------------
> >
> > Do we merge the two mechanisms feature by feature, or do we prioritize
> > moving MGLRU to the pluggable model then follow with LRU once we are
> > happy with the result?
> 
> Absolutely by a distance the first is preferable. The pluggability is
> controversial here and needs careful consideration.
> 

Pluggability asside - I do not think merging these two things "feature
by feature" is actually feasible (I would be delighted to be wrong).

Many MGLRU "features" solve problems that MGLRU invents for itself.

Take MGLRU's PID controller - its entire purpose is to try to smooth out
refault rates and "learn" from prior mistakes - but it's fundamentally
tied to MGLRU's aging system, and the aging systems differ greatly.

  - LRU:   actual lists - active/inactive - that maintain ordering
  - MGLRU: "generations", "inter-generation tiers", aging-in-place

"Merging" this is essentially inventing something completely new - or
more reasonably just migrating everyone to MGLRU.

In terms of managing risk, it seems far more reasonable to either split
MGLRU off into its own file and formalize the interface (ops), or simply
rip it out and let each individual feature fight its way back in.

~Gregory

