Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4318C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ADAF6B0088; Thu, 27 Aug 2026 04:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F226B008A; Thu, 27 Aug 2026 04:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64DB96B008C; Thu, 27 Aug 2026 04:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30EAA6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:57:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92FE9C036B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:57:39 +0000 (UTC)
X-FDA: 85146446238.25.E4FBD37
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id CDC3B140003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:57:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OLLYJWxG;
	spf=pass (imf09.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787821057;
	b=NLGfgcy5xgMtBvysAGrCwYLX4SkXZl04996ySmiq2YSfdfAwfEu0qebhsy9u9y1wj+81Ch
	spOHUQGVQUqErL5rW18QzbA8hCFoGBuh4mhjCd8npJzFuWEQgTfnB7PeaAxr9APkeiGEm1
	AfDLO7WVmqoFX9nCkBkA3BT+ISJ2o1k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OLLYJWxG;
	spf=pass (imf09.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787821057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjW3UBtBE/XmT6KkSplPYiM6V7zSUQJYuA80LoB2NEA=;
	b=GunmL1nNLlB5fj0KerjKtzaCuLF3mfju52LQsaytXnGTtQVYwP9ZzHnU/5pm9YTjg2DPHJ
	p+Gnf+zY1y6PdXMeynW6KbRMc8KBlpaad4CvLJRTsGQXArnlh35H4U2sYYsfGpB7TMafqB
	WoyRTR9QF95RVNIPwpLAp0ZoHdzHQkM=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cc891373e0so23989175ad.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787821057; x=1788425857; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wjW3UBtBE/XmT6KkSplPYiM6V7zSUQJYuA80LoB2NEA=;
        b=OLLYJWxGF6XrB1sMGFdjEEjpFArh9zbe4J2frLRL7jpAamL5n9MBedVKQoD6BO4/rh
         pONjFj60u6U3n5WK9NR6xG6ZSQnWyYSTmBuoNw/kHd8IlSuylbD4AZNJ12RHLNOezhSC
         24xsb5Y4C21pwcUCZ2b8AY4VKz3ttIjYC0LBHdRJJd+gJD//g6MztzqQ/gcvb1GD+exO
         HqXVf2WZ0/+gz6FT5qDX54KenKh8bDF+8NJEc9CnFIUg4ejRjlJ07TwNi/41dLVXZZuj
         AHaHhcxwxr5mZKVBHTtagZuMqSIJH8f+bqU1KJW3ll5z3vAfM63X46sIxim3otDuhuwZ
         auMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787821057; x=1788425857;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wjW3UBtBE/XmT6KkSplPYiM6V7zSUQJYuA80LoB2NEA=;
        b=QdkVEojuudJDctxDymrBw3QjwW9WCpsjUgo2XRp0Jk5DhZMCKbkoOWgW/mdgMzMlzp
         EeuzFNGpfkX7GWS+mzCulNVN+33fa2Eec94OPvDgFL/+BomS1z9RefqL+nfkJLetGMKH
         dQQWOtWQMQViCTCtOkP23RjNoSODKWA9m+uwxjw71RWd3TNzcmcOsI5oh8MjXUZpbfRi
         o+0tPevnATZtejI46F5pRMeoEeKXSdp2WifPgMpKMi3o1NvMlWeziehAsJ2bAt7SvOxC
         3TGkx03kHMf3SWB7NFz2o0vzDRiySd1lVJqQOM8/XOr3lomcuwxZTU7RuQJ5EGJZv55d
         nGQA==
X-Forwarded-Encrypted: i=1; AHgh+RpnM2C/9tt19jwrD9nQrFlGRZNUOd7krFdzjxLKRunDgvJeIdgg26pebP5xS92FOSJQnC+dOhQP6g==@kvack.org
X-Gm-Message-State: AFuF++n/pZa24Rx+RU3BSZmgtg4MRfKLzlriUUO0It3brvlN72OP6MKH
	gXJCSato5l2FaqVaLU779NlOcsAGEScLTfowzOZLSgjYyvokcoL5vxb+
X-Gm-Gg: AR+sD12ALK5xQDJ3ZvAnF/ssrw7f8dqAlo/Rfmx8CyCpu0g1bVQtnYTB/wpYFUEI9Jd
	IEC2ICgwfqVmlhoysR8wL6AZ23Ub0P/j9PqTobayovwz42C/yWvUvtL5k7uSsM7RcaFbAzjhHS/
	sWVGBTdBvy2z9PGCC0WpvqjoyHFDlt2J8n3hq2+mRmyEoiaoIKqzvM9FdN8ZIOt15uiaDnRutP0
	aoFoRK3g7yrL+lr26Pl+KsPe/492FuZmFW6c7izCIhnEhTKo2vCjkydJgE7Hi5jNfjPQcaGaoSb
	t+eTVm28GOOJrur+uRXmWl12a01YmYtnEz/Ldrm6bWjWYaL4FWcEm2YS69F5RasyJ7T3HceP9G9
	lpN5CgBvnURjISkTtcX413x57Jc5F0nbbm7+z3t9cRDU3bgu/CraMm/CqFX3DzAZ88TE72/ltf0
	uuXx62/jEdrCjrou/6Hw084zLjX08AGda+IW4ocZzeicUXY2XfEkm4Xo2hhmD8KeSIYRsG1RGuF
	qrrQozvsb6nkDiyDCFGK2QTUyGt8OmToq04lc7DNVeA/V63OmTLxkBzY/jOoQn7Rxf+U41o4Mm/
	iqHr3Q==
X-Received: by 2002:a17:902:c945:b0:2d7:2edd:d140 with SMTP id d9443c01a7336-2d72eddd21bmr80438055ad.3.1787821056640;
        Thu, 27 Aug 2026 01:57:36 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d70493caf4sm15181155ad.8.2026.08.27.01.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 01:57:36 -0700 (PDT)
Date: Thu, 27 Aug 2026 17:57:32 +0900
Message-ID: <m2v78wueir.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: ljs@kernel.org
Cc: david@kernel.org,
	linux-mm@kvack.org,
	liam@infradead.org,
	rbm@suse.com,
	akpm@linux-foundation.org,
	luto@amacapital.net,
	brendan.jackman@linux.dev,
	liuhangbin@gmail.com,
	corbet@lwn.net,
	kees@kernel.org,
	broonie@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	wad@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org,
	geert@linux-m68k.org,
	daniel@thingy.jp
Subject: Re: [PATCH v2 0/2] support kselftest on nommu platform
In-Reply-To: <ao_541nBaa3SJS9F@gremlin>
References: <20260825015945.141739-1-thehajime@gmail.com>
	<f2ac9432-4fea-4007-aab0-ad80597b284c@kernel.org>
	<ao2Tl9CLL7WjHYun@gremlin>
	<bb9a3add-4849-4928-8b6a-0afc0c73b112@kernel.org>
	<ao2l9Ao7BQI6uRKC@gremlin>
	<m2y0dsuf1d.wl-thehajime@gmail.com>
	<ao_541nBaa3SJS9F@gremlin>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: kbow83txej4gwptapammzqndgzwtqbgf
X-Rspamd-Queue-Id: CDC3B140003
X-Rspamd-Server: rspam06
X-HE-Tag: 1787821057-868157
X-HE-Meta: U2FsdGVkX18Pp3eGWH9O9xnCTstCQPxtxp0A8n0MzKVFGqI1w/fiKLKEkD04rpUAML0UQDq4uuRZqbA0u1jel0itLRaDfTmZxshO2KkrO+6+T62mBQvoc7CMV+0zI7A74b5lPOtRqmJlGQYk/DO9bDx5dkLH0EOQYqFA6WkwzJrjUmsDnIyC6eu0cQGvHVUEfMF+waB5Ry5ZAbGbfp2NqoTbx8BBn2XTikh8LK12AsAm4o6nOkCr81xJf2u+qQAkh8n0ION+NC07O9BocF0U64fkWfpzWWKTybjKN0ugeQKzXjZsygxbZVGip4lhpZwS9HWHgP0hOEIA7a2qufBjXlDR146UDldTbvVkBGQ1p3W4l+mabxs+Nskp+hiDoYkyHRSRCRfQSlheseRkf2m1Uc2xZogGDhWWOZv+dWEdnnG60i82BzIe9VZ/eF6k5Nd429cTI9r1eo/R6a8UNtqcfYLHBFJX5eFeYAPSWvfHnjYCzYmiEze//g2Am4qM4ry8XLfHf0nHnnOOive60pjgkYtUR6lDX73iNQzl3LWXGjGQcn/71AD2I31asLGFuQEepfKGkCvCmILjEVXgkRfUY1AKlFW+NwIjhBpRUFpZNs2NthRVv9UiSTG0s6WcrJlyKvxOZdd/8l9I9MGNmDTn69/zaCm8JQXSR908yohy9x6qgjpUCRQ/ATf6LM6XIVoJfomiLuvgQZdbfMrJQDD4x66l2dF+w7K47Qjo5Jdp0ap3IdrlRHWYC3S48JoTP0btmxv+4WexwFvEak3pWNlRTREWfwqO/OZLZ3eiNMfvG9XKbEydR2VNBbTDhVNYDS6flqouMeUdGnJL68uoXq0gipRW4M5C5i9+UZ6MeHlVwoHMRpQERx9+VzMy75/WmvNLY97ebLoKEC7YQDAMnoclSppnbyL+6ZWkhcX3X0Uh6trdcJcFwpcAk0F1SD0wCCyMVhXs2v1oQPsP02J9Ykb
 ZTUAQXMW
 b282ZGG1w2pDEeZ62eIClsJ+gizylDFja/a6O+f6gL6S3YauuK3l29XFXJBN8Hiqf5xoFMlQtfH9H0fxiuFV0FJq6ZPv4+tIlwH5ReXtV8P/kQxAvWjqNehz8uX8s1qBSjNMGbV0o1ySDvXiJ3ioNqYZLmA9GqC1uel3K/9+oIMFsnN7p4oecYjZ97mvCBAAi0pZiklU/8QjytyWhrWFd/Wk/QC34JHRfBouUsTxIpNJx3ctC9G+acZBhUOgzJUWQDmgNpUAr9wo2utxEuGOuNM84Tv/jdKJqIrsMoTrmmJI7dEp+caYzCZybS9wPPO8FcxIsREHXzTfS+MmTOFVsMAoh8JOakmb6sROh7jqNHr4uAV2gSPP3Oe7QSAi7k5TDry7cskbPeAkHTHU8G9wL+HhuoM0Ee3Mq67LpXYDPgUgndxr34Nlqw9HQlAej+J8l7/oa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, 27 Aug 2026 17:49:58 +0900,
Lorenzo Stoakes (ARM) wrote:

> BTW did
> https://lore.kernel.org/all/20260723093633.140989-12-johannes@sipsolutions.net/
> go upstream? Or another UML nommu mode? I've not been keeping track of all
> that.

The current consensus (IIUC) is above Johannes's patches are in
progress.  Another mode which I was originally proposed is postponed
in order to minimize the impact to UM tree.

-- Hajime


