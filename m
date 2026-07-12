Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 508DDC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 21:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9D066B008A; Sun, 12 Jul 2026 17:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D766B008C; Sun, 12 Jul 2026 17:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18576B0092; Sun, 12 Jul 2026 17:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 768466B008A
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:17:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6A3A1A09DC
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:17:39 +0000 (UTC)
X-FDA: 84981386238.20.202DD1D
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1C21F20007
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:17:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lSGzpCnj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783891058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mO9PnufslFYNDwqPjTJ3f3FlkpnmJVQM4/pFUcrdNco=;
	b=xLvqcOtaazxs4LWRcSHdPwq9Ay+uJQrE4sqfO7mt1jbetKm1OVeainyPju7JCkDfenBior
	2B9QSnxZ6chrfuCoH1rH+czexFLDMOFQQYUQxw07hfHhUFvYZrvuc3vG1AKD5LUIxlXDrQ
	iE2WS9MKG9Mho28mse/YWy6RcOfN2Bw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lSGzpCnj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=leobras.c@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783891058;
	b=YHKMWpZ0V5WeOG8DvST77ZMi//NLd1KXhs/Buuco00YyXckIfNk+AZf1ag9YlHk3IgZqTE
	/nRrOh3QS0KiRH3zBCl5DsTqetiWu9KcNyTD/XBUHriGsNoGAIVt7YkTtJepe1SA1g+6wC
	V/b42mIWOychonl/RJFh8SziBfdZlwA=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493e8d4f4dcso19418325e9.0
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 14:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783891057; x=1784495857; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mO9PnufslFYNDwqPjTJ3f3FlkpnmJVQM4/pFUcrdNco=;
        b=lSGzpCnjehTJUuhzvRC5Loe96N3Q2B247zpvGVfejhFB/V7z9rh8BVN41QKTLrfkx/
         qKStg0Arj97TRXiF3bCR1M7sbaEP05q67axs4m8conxjHpKpCRM8VQZmARo3eWn9DVzm
         DcOzZV5iooKXPvIuECScB4QQ8is1DxDu2a1Ach0cO/ReFyP2MEdIYN4MV7+wNlmwDeQN
         6TBA84glEwG94K46vdu3N/JC7PyS5i+RBA69pK8agv10exqmhKqaDP/LB9YThkDdaZKR
         KJv8AAFb8CVqO6cV46kHcWG7knLSYgg8/DFn4N1Q4waI+Dh21sX5cgjFkHR2wCQM3JxI
         UvCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783891057; x=1784495857;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mO9PnufslFYNDwqPjTJ3f3FlkpnmJVQM4/pFUcrdNco=;
        b=fWv+ZnALiA6QlYRlkj/infTKbYiotxuXgx6AiIW6YApoi6RfD2+/4IrWr8ctbbJnGQ
         C20SrmJ/UWduFgyz0ZNnDXRF3uQFEXJ/NO4+jooOf5zXjFfUIydd/meMi1/BiP5GkCPc
         UlfQF4U+pEnr+CGhyKKskPE5ER+nvSzG5TrX0nP5NLeKP9BmJFgWaxKeAIoPegT7ifOd
         bdfbjxoD9+uFGeXGPFd+pvtstd6fJPvW4sSvQbv0ETDnCD/5/GP6zNZ+fg8dmFLvlx1h
         2kSg+cyABIiOGJ/VdKlJ3wyIXrA5hEwCYc7Bp8bh+tnj20FVTwasCWL2zyR/iDysvO6M
         1axA==
X-Forwarded-Encrypted: i=1; AHgh+RohYfGcJQHXJZ+xMVey+vBZgq9+1z2citlRhHVT/BLg4hOI3gj9vmB5DTrVS217XmkRXuG+UUu5CQ==@kvack.org
X-Gm-Message-State: AOJu0Yw3/HvZcwe67OSYP1mASXEkzSu8sx/EfTgkuH4GiXTgVXw0yG3v
	P/jTSgGkYKMiuSZp6ANPTDSoNHG16ncxRjhG1LqLyyltBlnhiisy8R7t
X-Gm-Gg: AfdE7cmXZRRRR4ZiNMIoQ3OKST+kObFirvGrZP5D8Z3+3EV1lL8S0chqenb4hN9j+XF
	cKnswmxSJflGchu7QJcb3rxkFAyRSGysdVaMZONih2O8FfR6aKeRfRgGhKRPTslO4Hi38tRGo7v
	D72B7EVRjvCW5C71u9HIqwYzUvSP9AJkgzF114fcIb2XUGNUOCM6sU5+R/ip/uYWlwWHWgDeIIh
	pw34JgbU85iqBKMdkT+6Qu3asJdVgqhCkdWZbMg3IQT9mq8IYBrmz96Ub+ixDXR4pXn9UicXNC5
	7M/axkdzA2YfXfFCgJHOhdnrO8rUxgXTxyEH7ApEL3W6WQt0MCRH8lIjXJEOzJsr7B9ECLnUwWA
	SEkHbaoafNdzFrzoz0dR0+mNDF60aufWWzzkRhuRW3+ZQPhd3yZApD+PhOqndNHwrPaw5bK2lC4
	W8FokebwXu+mhlcYuDRIlWfg==
X-Received: by 2002:a05:600c:a42:b0:493:c77c:108a with SMTP id 5b1f17b1804b1-493f883c8ffmr70582755e9.36.1783891056739;
        Sun, 12 Jul 2026 14:17:36 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6f3c42sm307923765e9.1.2026.07.12.14.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 14:17:36 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 1/4] Introducing pw_lock() and per-cpu queue & flush work
Date: Sun, 12 Jul 2026 18:17:34 -0300
Message-ID: <alQEbpfo7mHHkIcx@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <ag3Jh-8iUdgKvw5y@localhost.localdomain>
References: <20260519012754.240804-1-leobras.c@gmail.com> <20260519012754.240804-2-leobras.c@gmail.com> <20260520134832.WS7TrMnu@linutronix.de> <ag3Jh-8iUdgKvw5y@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m99xcm5mz8if4u7h184oo8is3t88qxtr
X-Rspamd-Queue-Id: 1C21F20007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783891057-709005
X-HE-Meta: U2FsdGVkX1/8UKYuiwZpXB9LHgbtFxkZ29t9SzEkTWIxPfSb2iuGHdYkTrmAHnSpZanvMaIECaO4CiH8O0cqBPIlaBME79IH/Azu8515nPRHG/Ew26AG1Dsw/93b+3UAIotOo68xohZ+W51yo2Nt3mgBPyFJC2T7UuUTgAuDtbssM6HC9IzeMxeCb3gKcZap8Xs5TislAAnCP+EOFnLb2ZYddA4M3+tW+dShximoc7t23wi3nhkVgJ+Th+HwPMMBSG2JfLDoBcyDBza1lX0v8HdD05mIte4VzDxdlkrbAh+PQ4NyPq1MzCzPoIzTe8jP7aTIgby5Jf9nfwwXtY+e2veLVJL/2FFICnK8Zr0ceWx0cxr1Iyrv9GBd23fLdpnOEpGrHG1CWMEpx6g2QfsnSgDxU1Sj75Iv/Mj9CfbQodYJrEkmykoLhIeoNE23JjyyQ+hslbT/TaFZq9CMw7Y+8Bkqaf950wtDHpjDBZSi4JyAfQ9fAyRfSRroynxNA/1U8rgMXUfwrE0OKeFv2O6LuGl1W1xUG1Z4tCsgSRtqdKyZ7YxuQwDYGujXEgg+ja7OqCMYlidLiyoajf2Nxkcr7I1/tgCBm9No9W2sVjzNSTNL+XSU+0fiXmYs6gOnzt+GX2tk/GkxnRbSXmSLZ08OPW6Q82du5Vm+4XF0UKNIsC77WhPwGlfWT7TB05aJi8151EmBZsmV3JglmuBKjacwBFxfMAzKs/O3D6cGbUSuxdTIVpeIkKHHNnd6Otx1wCbr5pVCQJmSZTVcIC6mZybJmnsSnZyv1f12jvALU9xVK23oi3nuzr6bSJZUwGLlekJntfZvzmFcXX+8xsViHJeyP+GHTTkCVH6tnMdwFDWaHwqMZK+1CZMpDhgsA4dGCW/sDSd8jeOCAp2ZEytBZrml6GqKqyao0FcOIsE98ZYp3QaJXfYdckBM7I0XKziNQkBUDcrYBFN7MjdQL/YFnnI
 gieiGZV2
 JL6EWbrahvj5BtUyDjWQHTfl23CBPLQogcMDfTtGkXhbNp7dmTaYjPd+wkubCVRhakT8hmzkQqJSyzneyR0rkkGtOJbJam1Tdw5bQRq3kmJ+eRIvlngsObwlYYGacLkCfYyrtRt6oRS8tTbC5F8jE+43C18nQ4lFPr6GSHUD3hs+EN8AULAVVmznAbbmC4b0XJH1VNUYl5Cc0DiR8BH30ytcYlVzbu4lM3qLtNMI/VPHTV/5pymxLb/r9xiPOR+ANVitttgr+qWyd4PFQe0jcDlTjOstDoGeAgDiaGvmfeKxeTb2PNX1ye+uhxfPqIKO9tGytHV+1UVld4si6CZbIniFWO81koXmQJnpqQmrQYcwSGxtbO3SG4vJbzHFt5KIG5EItal1xaodO4t9QLvR7Ay7xKsJ5yX0EfsnJAOYFD1w8Rvc7TB5jj0NSrqDCWCqpI33FGHwdl0h+Ngr3Nl/+hyTZF3gTyN0/mgLTjCqU7IMv2CLrpo9+3ILKktc6H6hkSt6iVLKBlbXBRkxSJ8DBgmP8f8aoCjUfTc9la1FmlcGayCWXoxM9PSHXTPwWNfhV8595PJ/l8pDyMpebnxQ7bIg2TvbxDss23YGDNGG5mypJRqKHo1NL/gkayA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 04:47:35PM +0200, Frederic Weisbecker wrote:
> Le Wed, May 20, 2026 at 03:48:32PM +0200, Sebastian Andrzej Siewior a écrit :
> > How likely is it, that you you had users before late_initcall()? Also
> > can it happen that one of them uses one function to lock and the other
> > unlock in this brief window? There is no check if this was used before
> > static_branch usage.
> 
> Or let alone initialization on the wrong member of the union.

Right!

> 
> -- 
> Frederic Weisbecker
> SUSE Labs

