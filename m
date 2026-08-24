Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 832AFC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 08:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83AC06B008C; Mon, 24 Aug 2026 04:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC4D6B0092; Mon, 24 Aug 2026 04:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA626B0095; Mon, 24 Aug 2026 04:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D36D6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:58:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD385140428
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:58:24 +0000 (UTC)
X-FDA: 85135561728.22.11AC4B5
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 98ED440008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:58:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QmCnW0IO;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787561902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qn4kqe1cwjM1TB4a/1ctVx91SSia6iTv/sEyLh8sQjg=;
	b=zdyBZG8TCU0+tikzZ21FV4W0JL4ujDL1+fu8jqjQQcVJt9NhgdtJhAU9ecwUj5uCEqsdSq
	AiE2X3xn2z8vPEBHAl3ye4ba9SaZFZykcJDgyseDrQ18mSL6mT/yRe+i2JxgpRI4LbNnuQ
	EsTPK5QH6nv74hFmPXn4aZJ/Unev01g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QmCnW0IO;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787561902;
	b=W31pKwGV0E7pR3KKzP7ovlSodVb2J23SS+YN3g+sh0EbWOY1NxEVq+EfRjFuONmctbYQ36
	HdBcbChW8mVSySI2jLHTOaWJQu7bEHhg3PY7AlB1Sfr6dEfNetEbNbh9lelbfxa+zvGTOq
	uqiFdjkLtpgbLMuEUCQ5RVqOTKnsyW0=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a17211b9ecso8154131a12.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 01:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787561901; x=1788166701; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qn4kqe1cwjM1TB4a/1ctVx91SSia6iTv/sEyLh8sQjg=;
        b=QmCnW0IOwP1TKVrlvVMeJlwm2Bi7d/wyBVpaf+gQAdBpLMT0Eu1uH0GWxlezonKd7A
         tTMKOCHIMnSUJ/UqgOnskswGU5mSDNCiAlJho+wJ5JOzSWpVeNBvAVwax2b5lab57YOA
         0vg5/gFffJaDTWxO9CIl+1baOm1Hi/SNtYD3IsJL7a5YMy/AoXJirtfVC7gGQstBiTdX
         YEYDCUxPGL85X5J5mSkS1hSUEOvHF37amYN81wjUgfJZFXKS7QP9i6nicXcBmoR8lhR4
         OpX8ldeLmDfgHigWng3ttYdFPdUuHdNEugXtsLxykSy+QCfHkAaUI1kgRw98FJnNcmhv
         XJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787561901; x=1788166701;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qn4kqe1cwjM1TB4a/1ctVx91SSia6iTv/sEyLh8sQjg=;
        b=G4/Z/a87pnK2xvnYeqyeD01WBJLUgDaYe4MnMgrwF0VKgPLF3U/ZcS5ZcqqJdlceCb
         naoJNQqkXgw4jemIkuh0WFcv5PXNcBS2vcpWdZhzPnlfb5LfqCPK2Wwi+F0UZW+ofs72
         j7AB3H5ZzNunKOnB+bZjOXs+wHDIrg9lAw0L5aVUk/5MqZjbOjUChVK2OBaMQjlX4WIu
         xdu9yBMI+x/9+62bp5lDuXeZYOGe6xhR4DSXq66Ev2xLx9KUHZHKu7ov4jbNT2Yu29p6
         Zejkmqa7vE1dOyQ+Q82rPQnxWZBKOtWUCsbsBgPTt+8BcDVxN1iVaKW9+KpXz131SF1A
         zkfw==
X-Forwarded-Encrypted: i=1; AHgh+RogVz6Wh0V8+O7XG5Ab+5JPwnN+CKScaUBf69NpabnZ382wEVdAewVU3zs4uCJxlNu2NhRrQWYitA==@kvack.org
X-Gm-Message-State: AFuF++krxQgfwOV4Zr5mSaPSG75UAXgwlZY1TbK0GbWXH4yirz7uLQdC
	jFzp0rT1qcKY43RH9OZtpjBlCdg96jU8sEMW3e1Hi5436mlmjUgucOSZWyZ8TCJSyjg=
X-Gm-Gg: AR+sD13m52gkTEtJJxomEpPuPOn1R/HdwnkoJOdbePqPCzL/aInGOg5wg+H6U2N3cW7
	hNzkXNAP+fTVpCDL6MY/pXtQN+jTsBWyx9fx/qZIrWBxex3hS6TnfacBYX/Sq6HOvinPBveEg6i
	K6vx9J0NgxQIfyZ1wN/wosw6WhcNuIRglDikfU4Tj9v5zKOR+Sam+0IAgjIYMWyei+6Kf0W5bOJ
	YlFk6ZzJE+vTPuuMM9H0j38wGTr3cZKkSvFeAQDEpPYA0L9gwrIH0qHXx9ri03bl86W15C0AmGl
	oJdO7tZ6s7Ln4MjzMH440aige5pDQljuQmbMdwbqspZn0vnVxyvv3fnR5gFb6Vjriiasoe8yYCP
	goyLP7bmUytIAwuLdwa6DOip+4V0CcimaCNVJ7p9Mlv2ZvAZZ0h1phMiaLd2ONMsRTGM8VisN35
	wGyrCbWsbSQOHyjGQxGSafHpl7ZgCMx34Sk8xJRP7NIjT/H8k3ZU8dv3qBezeOA/bkX+q/L1XXX
	ELdDMjjX5NJ
X-Received: by 2002:a05:6402:2187:b0:6a3:905b:3c40 with SMTP id 4fb4d7f45d1cf-6a42f1d0649mr28255228a12.8.1787561901277;
        Mon, 24 Aug 2026 01:58:21 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a59e02a8fbsm10819638a12.13.2026.08.24.01.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 01:58:20 -0700 (PDT)
Date: Mon, 24 Aug 2026 10:58:18 +0200
From: Michal Hocko <mhocko@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <aowHqqaqK7TeexQH@tiehlicka>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 98ED440008
X-Stat-Signature: pxrmgo1uneaywy8psb4zjeudcpctzf7y
X-Rspam-User: 
X-HE-Tag: 1787561902-179929
X-HE-Meta: U2FsdGVkX18jsG9YUBAZS5lYE6YkFTj+pyCtX5hYx6X5ErbhfZQDqnUD2UkLE1AXQUxrh054GTaijknvU4qZs5OWuMTlOlOaUGcgKkD12Cnn/6gwY0ptQDARraL3q64myaRE3zUYtYdxpqagGgTavKEMWVIVtf5rEjD9kWSCiGaaslyvmbxYJNcPuC67vafhE0l/oYpqQTLPQnsZ74rcZAr3X9e7NyMXdKCgobq/ptrcahhvmV2TeE0xu6kLo1VSKfFJPqoO/t8nzRldZkdUpXhNQ/ntgsalur1kFmSmFI8BxK2EE6hjowMT8gvSuNwHqnye0gs5mCdQQZrO5MQ1JBl8GZH9mJsGESIwoknrnSfEVALvHJkK2AXhpRHZD5oSWHB8uBaQEwx86+pTvjRwfvGFh8SxxInkUmHgr6lMs8fvv6r49u7p986e+gMJLM3xIaRHtZNWIpjRa5F9cfOu6nkZDRznEJk0w9PZDLFZWF3WAhW0d/7XhRdxpqiCpTkyMnS/qQO8o4XqSqbsyb+jLMZV1J58pXJdmNk8hja4WLKhUa+6EwTYnjwxYaQqusP3KCWAjdSZn28QaJi2oX4eHZFM+SrZNmS9Xs5+lh7ojuDbpokqLJ145kiI4PiURuOmeYWoKYPJduEuPoHDcXUgZDsgnd2lwJYoZVtgVIk1jI4oiA8rWloz4IpHOifTsuLbrgNBYMIxR/7Sq1hMu2cEQWFWrsPrJjoM3P3XG53K3BaO4RFf0V8xOwfyeLIpeOTOg0n84dOS7X4B2Qv1jQl9iN07pWf80V3ZfDoSruvsA9g5bi8x7XKuw+XErlFE/XHLUXY+NXCD2hX+uJUnCeiOfd/CxmX6YRIuoA3AFVmvt6+lystTGSqxfo1S4HNGrL6pYQ9sOL5vAZ3eMKADqSlFhSmxxs1Yz2dG/dtJqmXdyyb6+Y3OSqsceB1PE0QtzbXN+aMjIGED0CjuC+VWZuM
 nmt7D8Eu
 eCVvXXSWzROPrucV7rGGNPiJtYckdIxAvgkSSkrj7d5s682a3D107+3c2esAVkC+W68malqVY+cSVzSEbWYXpGTkFh3YWU0KFCtzC3fwLFaj3xbSmy118VcIZ4VCBPYAx98W73E0BpvOE0xX4kiGHao9JtPxZIE2CqkndzP05iNBH70aMKZgqRI9B+6GVcbCO9GyuIgoTXipDxyJH+0v1TMF6PVwg20Gtl8rG4wO2pzkD07V647YbGiRiwk1yEogRbeyrTSiOcGY3l8oTxVS+X2/gPPKAkjVgoQSwUelbvLSumIjQLzpLnfA0OXR1ynQwdLLohAqdqIFeQizCW2MVaoVFeEaqzFa19D/nR8A44dxS1rA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 21-08-26 14:56:52, Eric Chanudet wrote:
> CMA allocations are currently unaccounted for by cgroup memory
> controllers. As system resources, they should fall under memcg, but CMA
> areas partition the available space for different purposes and memcg
> doesn't have a good representation for that.

Which CMA usecases are covered by this work? It would be also great to
spend more time describing usecases.
-- 
Michal Hocko
SUSE Labs

