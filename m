Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A32D5107760E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9075B6B0335; Wed, 18 Mar 2026 16:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE2B6B0336; Wed, 18 Mar 2026 16:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81BCE6B0337; Wed, 18 Mar 2026 16:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70BD46B0335
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:58:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1469B1601A5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:58:02 +0000 (UTC)
X-FDA: 84560396004.10.481E9F6
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 35A2340010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:58:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nlsW0lJy;
	spf=pass (imf01.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773867480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oy0njUjW6R5iexNMz3wzKCSxfU2YGWhYv9JL6HRw5xo=;
	b=DAiTAv0OAJ4btD7PI5uIJCWlr0g4EzSs+TUwaAXiCAK5HGuOvKBms8SDGtXTTp7dWTmX4V
	dWx+Z6I+0f5jN5bbN7nE+Myrx+eUE6pFY03MfRR2Ib1uZRTGqqGTwaz3an7H6472lgk8R8
	Hz/OMGhhSMtlxhAqEsbrrEtsISqP60Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773867480; a=rsa-sha256;
	cv=none;
	b=AMwKmnJch2l6gzt3VCxWss4IyfS0K4EOPACB/jXxtZ1SLTW/0b9NeAWVXT2QWJ7lKQYKVY
	Lt0JPhhtzAplrOBXFRgWumCr4kxrs+O0T0WRVHHQgaVeosjUC78Bf3jYn2DefzZSOiq/k/
	RQuFg8spfs8uX0i/1sMnGHvnOOTzMsA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nlsW0lJy;
	spf=pass (imf01.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2aeab6ff148so8335ad.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773867479; x=1774472279; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Oy0njUjW6R5iexNMz3wzKCSxfU2YGWhYv9JL6HRw5xo=;
        b=nlsW0lJyGUlOq4fQMjPOp5e0ui7wpIcQCgsNHAcDoSnWonD/QzNCkqtkGHZJ/Ze5+C
         OLAyXeYAUaGzxLmpsl0MWCJcTt3JnrpoO0Hn0bjkYbIh7BSPfhIjaaq1pI7tPIyo9wrE
         u9WTHbK6y8xnwQShKaoIaxohT+Lu4vsTsoozIpSd04+yJzbrRQTVGnnWMWoKQaEIziqo
         9HbyEZ0GTzhCKejEEa/ARkNbsjFjFgPvZl62v+opeVvSah++KJ0ndRJVWhChx4/B26L1
         7UDHVPZMXT6P4Ezi0VgGU4rUDntcHoaCTrmM/Kn0pfnzu1CUxt93lTy0xj5qxur95PLq
         HH4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773867479; x=1774472279;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oy0njUjW6R5iexNMz3wzKCSxfU2YGWhYv9JL6HRw5xo=;
        b=tKCNcsLIV8yXnPRGL302DadCtF6q2InBI31/UvB82g4+N0yzJ6Vn4xdngTqISXddEl
         7AxyJ3s7hfHf6v6cCIKpnLmEtlfwuyDhftyDAQktEOZ9pfJbn1azQWPzsL8tKoF2dxPi
         4ffbYhpjrVcgPjL83sZloG7AkQ6OWtNIW3aOKbVFXdBoCgK3IvgdeaqQfpECWspoDoi5
         q+/mkEHVmG7evXu6ZTAVGaGCNKV04sODYxqeirwlgsyesQ5J/FtHqFudKJE4DdOs0tIe
         SCrZzVl0BelZ0O/6KSFyup+gafM+a252OEo7YiWfwIfxw/+DolWAZtcxkr5RaY+x3DJp
         SfgA==
X-Gm-Message-State: AOJu0Yx4CZBzDCyM3GqZ5CdGtJI3Mzba3lyeXTTyILCgXzJKO7mEVk3S
	Gic0IXZYdQ8w2JsyTHQOzwjHAwQ0wUbVfS10qmP8kJj2Vj6/rC7egl/EnnPQDLwigw==
X-Gm-Gg: ATEYQzz+OT6zE/61XrEA4oqN5GfzKdgfKKk8wdcPJwxi1FGd4HZiJ6oDw1+2SqjtpF2
	2jLr4cGL3qyqm/Anr/IEBSTHpM6gnD1v4LUGoQynlXPHrfhtFkYY7HjDJLgnZm/nwBUbHRCnq//
	mKBE9O5VSSX+YH2VZpDNIZIM4G3NNXuvG7Zu3Ui6hZydmTYq0IQqlV26C9IUufL6odYX6qH7L5L
	R1OOx9FA/voah7pJfvHERioGr0NJ8/oRiCNs3J+SICsPn2SVHciIUAvmMIClVrCm3wnx2dI7SdL
	aVQysGgEZenT7rm7jLZWa2GGFZq+FC+Gx807Sd2V/m098YEAgFuE4NTRi+4nCRikpNt/nWah7g6
	UYfnFmKP2WDJ72eIteup4Qn9P7NOXSiFpFKR85J91DPrg4xCE8faZPLoC69RMrh4zosnFzDsBJj
	dd1+GdiCt3puKpYDDzMYUPDsnoig4nWRGzyeNBHfROyZ9bjXqqMCxZxZ2U/UTgjBaaCD6U+84V1
	tA=
X-Received: by 2002:a17:902:d549:b0:2b0:5ba3:2416 with SMTP id d9443c01a7336-2b079f9f6d5mr203135ad.7.1773867478553;
        Wed, 18 Mar 2026 13:57:58 -0700 (PDT)
Received: from google.com (206.238.125.34.bc.googleusercontent.com. [34.125.238.206])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bbad77e50sm1525460a91.6.2026.03.18.13.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 13:57:57 -0700 (PDT)
Date: Wed, 18 Mar 2026 20:57:51 +0000
From: Bing Jiao <bingjiao@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH 2/3] mm/memcontrol: disable demotion in memcg direct
 reclaim
Message-ID: <absRz4U_IMk0ofxl@google.com>
References: <20260317230720.990329-1-bingjiao@google.com>
 <20260317230720.990329-3-bingjiao@google.com>
 <CAO9r8zP5HmeE1uOZE9WxN1GyC59mM_F2JGaKLEkxzzCvnxpW2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zP5HmeE1uOZE9WxN1GyC59mM_F2JGaKLEkxzzCvnxpW2g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35A2340010
X-Stat-Signature: 9aj61rsu5ab9pjubt3ktt6zbw7xwfpa1
X-HE-Tag: 1773867480-264472
X-HE-Meta: U2FsdGVkX1/7AxBCimXyl3EPt0ubXDrT0Ck9NvDCfAouOrSdJptxOPaERO52/jyatlk7JfbVvZ/E0b8ip81WErPZ+VK8yV4xpJTRyphHX3WNkzE1M3MZHfCJFOq5uvKUWeJEC/3xkV9cKJWwQBPgHCsnoeC/mLYUvj1GbNjkPgzOE4pQYlP+c1rgxFn/pa2XslNhTFk6+kM3Aq67M72qW9+PgjJ8Wzks82ppGEvBMtfOmiWmIpERWbXCxHTecDJbJUC5OLbd2ogR3fLG4+CrYmlvuvG21cjeeQNATuyA6mIcM/9fq7p4y8pMCYEYHyMMHhSBjNqgK60J2qr3rwXQO5RnkwMHUxu3kkKdjK/m+zcdAa3+fvJSQibbferf/NKqUIElY7cjtUsBgfAeeRc+xu4euIUqEza8/NuMMb9lS+TaWmXC8fsD91xb+ARcvZXCncazrvUlrpeozs/xYLWa/0VzSxwAijrt8K302E09d0hFnolK21LG3WKRGiVB8I/NBtGzfuL0f+RVg1zEE5eVKXrBPL/a/sPheJijZeQ8wDywy5fOE1WxgyeZWwoqCFHqR5A15IPa2wbDciutTITIU2rNqvBA61ADIk/w5A08dGTggY556idhDcbZFTqctIY7VfI86SsDGkp4doyBrb2ID+UcUxxPfKrbXDoxI5PHg0GHqOvxhUS2UTU2ytwtcaM6+awNgiMjVJ49n5WPeu6mbLpInWjkH+fj4Pv7MaVfyytOxcxWMFClN7ZzRyAMK1XaGUhuOrJL8ECvY/G8H1UGxFfZux24rc0pKeqdljmt9spoBVN8WU0o3lKQWbYTEAAFkZCcesTcO/7WLQzXn0UsBEZQqq3QkduPCDFGuYEsZ+PU5I1aWkXI7wQz6hu5h2Z36mpxXlNqahUtJ/w5ZjKiEcQrGLBVC4iuro7lL3w7llOlBZZLjH2YClHt7N81g3qpI28jYHoCeGQqyTJOgPE
 ld5v0n6D
 DJBwUVI02UR5HW46ldGbDt7vWAjYmNrowo8sOTdK+Bhiv4SMTA5Ks31PkefoHukaxJcXbKhB1GLAAmvZk4doNNRKwn/9XBfkhsfKDTIJpkEc4GGve1aTTS3Hu8WYc7dGgwJ54dswIjeukiu4FIipQCkH/il5SKLN98pWhx+XawZFooqQzF1WvhlX65QSlGfN6vpJ9D1TZl3V5VoG+0hfRg7gCxoQd1o5RK7cEx5mgE5dYi82loAho93LMP61fSuqU3e04I42JcrXx/BUm1zSBJRrX2TbLVDdLvaW2lpv4hEg3anB/GtGfCJPqoJDzLmj5KcL6sN0kPzFSwU9TpLLC1zRH0eSz10AUMAHTfN/0003EWxQLN2nufViNeG8+dLMfa7MnwsRaMJ+eHw1M8xSz5n2niYfy2GF1P3wcJMDMjbn89mTqKotrqAhgBTI6EN2j/jwdtgd4+l5LKyzlIYyNX2UjL2OevtQ6Fb2bJeVci+jHEQJ1TRqxJAruV3x8+TrN7yZhVCVeUZqeF+oGEAnbIRYFaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 04:44:34PM -0700, Yosry Ahmed wrote:
> On Tue, Mar 17, 2026 at 4:07 PM Bing Jiao <bingjiao@google.com> wrote:
> >
> > NUMA demotion counts towards reclaim targets in shrink_folio_list(), but
> > it does not reduce the total memory usage of a memcg. In memcg direct
> > reclaim paths (e.g., charge-triggered or manual limit writes), where
> > demotion is allowed, this leads to "fake progress" where the reclaim
> > loop concludes it has satisfied the memory request without actually
> > reducing the cgroup's charge.
> >
> > This could result in inefficient reclaim loops, CPU waste, moving all
> > pages to far-tier nodes, and potentially premature OOM kills when the
> > cgroup is under memory pressure but demotion is still possible.
> >
> > Introduce the MEMCG_RECLAIM_NO_DEMOTION flag to disable demotion in
> > these memcg-specific reclaim paths. This ensures that reclaim
> > progress is only counted when memory is actually freed or swapped out.
>
> See the discussion @
> https://lore.kernel.org/linux-mm/20250909012141.1467-1-cuishw@inspur.com/
> and the commits/threads it is referring to.

Hi Yosry,

Thanks for pointing it out! I was unaware of the previous discussion
regarding demotion as aging progress.

I will drop patches 2 and 3 from this series and resubmit patch 1 as
a standalone fix by replying to this thread.

Thanks,
Bing

