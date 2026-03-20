Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48366109878D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0FD06B015A; Fri, 20 Mar 2026 10:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7166B015C; Fri, 20 Mar 2026 10:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FCB66B015D; Fri, 20 Mar 2026 10:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2646B015A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:38:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 359D1139A4F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:38:09 +0000 (UTC)
X-FDA: 84566696298.08.DF1478E
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 25741100005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:38:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="O0d9fj3/";
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774017487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrYGBaCqeFK6sS78naoBvFlPLrxLzAYh6LesIJsA+lQ=;
	b=06xK5WaecKYcVrfqTQZsHhUPaF6ol0BCftHkF+RRJwVbBo8SYDtXMXSVyO2HgM3yv68s8M
	yAz2QYfmKeV8Xx1ZIAGUSCAbs3DEW+1o0B20NxWQueSd1WmWecWQKpZ0Kw9vZ1g89JWXW6
	z2WYgo7J5/4RWpZq7taGuumLvh45drs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="O0d9fj3/";
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774017487; a=rsa-sha256;
	cv=none;
	b=zaqxFJlA0uZ1DaHz/FTZm1ufY2201n+Q8Mki0DJz/hy1thYaVcK8YOly/v55huRMwy41gF
	YYYwtjIB0Zo4lNc6L2+D8EgmuQ/E5X6WVj+5qh0MAWgbDYIf5aNHKq9g6n8X6y4MrkoP2d
	XBC7zBea6DfHJbYetSr4lwlYKKWfvmM=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8cd767d2d70so174428585a.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1774017486; x=1774622286; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IrYGBaCqeFK6sS78naoBvFlPLrxLzAYh6LesIJsA+lQ=;
        b=O0d9fj3/XpjxuAGgurR2ZbLLS0T51Uf4DYIL94pqH+7LNC6zQjb+sI+MrfU/ydcN1H
         yzOBZTtt7yfkcbvrVk2T2NBL7bYpjBuhCZGNW5+DZPqRQijs5/SJOEtaJXKvP4P5swct
         U22huD6gLBOgfgxARKbLWEKoDR06xGJ0bmRo2qo9L/Mqq9TvC4S0fZjL3iV2N98tnIb/
         xFr9t3/xxVKRiP+x6/ejTf8ZH6hbobLNPPoLnk5d2prjBh7PY2bYwf1iurMz74Z+usKP
         5RcKamhpH6Kgc/s4jIrwwtIYn2fjO8WIlTj/ljOGXf/5pHRtnt/xHjuGEe+nuadxd8kp
         3YNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774017486; x=1774622286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IrYGBaCqeFK6sS78naoBvFlPLrxLzAYh6LesIJsA+lQ=;
        b=WMH9/9z6/giob809bJXyiqzLxCQmPRWLqK1dDidG9DsBF4CV8b0XHw9+lkGCEza4KU
         lCB6SCLLL1Y7mwPFmvXx+cqPbuI8RsPmvFIswSENGrXdZYpWSeMihUXbFv6qxFdFIu9m
         r6XkfQ9X71NW0Q7CqnysomRPta6lIFPVSIjGTnvY1cIti01wqKGsTbTxJ+Vah1peRcuC
         REjH6T1AwVWj2Xi+fWdzxbEb5PeqXQxSwIlFlN1gS+Ma2ej4VxHPfx1ikgWJGyQyvQf7
         d2mZHHc1fPhtUTc8g6ASusw2IzOlm8MxuXbbx12szaSXG/y+l1KgKa/Pxp+gAvZsF3Fj
         F/Kg==
X-Forwarded-Encrypted: i=1; AJvYcCXjh6fqw9J2QsnGr6W+Kd3SNZgfnFqeu+wGoG3Xhe9/FwhnXLvW+TSToEO42hLjuC1zCxOge+HiFg==@kvack.org
X-Gm-Message-State: AOJu0YzMewbVr+RpigZSiXbaGbni8v6pf2rkajP/VU2UZiRCCkvPXstd
	0TnYXaf9s2DAE221S0xCw1MQm7SBxgBi2zqXfDy1IqmS7vtUOMooFi1HJVoix0ugHD8=
X-Gm-Gg: ATEYQzxW+CAg441PtdPARMtUTdz5+MKW7qVLUzUUJ7atFI3AC5zOcNS9nGiTH8Kdzh1
	wv6NUhBGf5q9FtrXyP37IDHHeJ1EVhvmk2l5nvqAV+oDpff96CmqLYNatA4ZmQI7X3mIjgwLgd9
	fqFJwKcsSAVQ2uREnqz7AzjPZObs7xAqtGeRftXJyfyUIx7dWGE8LUuspI4HG6bNMoAdiCNYpDP
	Dww+3knd5Q+cmskmoYtJeiLgPU4HiocbyW+afvR86VF38N8qgWW9aWmzoOnsm/BaGdB6l/NjDKM
	Fjui0c2Qbdb/XBK1F4rwIrBpnB5d8j6dTq1eIn9PidVkEXcbZErxZtaXFuIl3DR6abJF7b8KBZ1
	Zij3jW17IKmvvTQ7aTb3HkrRMToiSw7jzbNFijkxyqbe/R4uCmT7ExSjCXp4yyRCLXz76t1xsJx
	cBXeWHn/+AsNtfY3u69LqBRw==
X-Received: by 2002:a05:620a:2547:b0:8cd:c011:dfc1 with SMTP id af79cd13be357-8cfc7b66345mr471071585a.5.1774017486070;
        Fri, 20 Mar 2026 07:38:06 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc9089bdfsm176182585a.31.2026.03.20.07.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 07:38:05 -0700 (PDT)
Date: Fri, 20 Mar 2026 10:38:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jan Kara <jack@suse.cz>
Cc: Yunzhao Li <yunzhao@cloudflare.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	Jesper Brouer <jesper@cloudflare.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: balance_dirty_pages() causes 40% IO PSI (full) with no drain
 benefit on 384 GB machine
Message-ID: <ab1bySbmeidrQfoN@cmpxchg.org>
References: <CAAnvDSwOoEOkMEDgKUcHkx-SdmZ_ar5AbVy4Gp-XT7i04ON5fg@mail.gmail.com>
 <z3quejtbpkiizgmvu2pjhqv6ioyach2wszen5slkau2hossj7p@rk2ftlwbdfw5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <z3quejtbpkiizgmvu2pjhqv6ioyach2wszen5slkau2hossj7p@rk2ftlwbdfw5>
X-Rspamd-Queue-Id: 25741100005
X-Stat-Signature: eyuz6odsh39azrs5bfb9mo7cnyymqw5r
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774017486-149441
X-HE-Meta: U2FsdGVkX18zsx04mfSRT8bDK85D4jH1jCbAkeJDyOz4L2VGaYH//DIz721dEAq4//ugChoweESWwNmogEpvHd/0V4D7x297Jt9slf10ITyMmPkm1MOXNASB3bPAaE5SSeWjMZV3dkr5W1sENOuRwLjrBM0dG+VB9Po+9Pgx4jQkFdfgEnU3FnqPo5rLmS1+8dvNWaE1YMotAZuCeYk7mF+XgUXVwuz0KVjgOb7Xz/oY4oCj8TBBNCgSL6cZraVoxv6JXYopuNui5AmIpsDRACDk0KUwDz/FL/GD4V8yVu1a+fOXJpS/0cSp62GQFlT6x/8/ASeo1v/zx6BmVchD99pG+nglteRWI7AgG5kwA6CbI3d4rIYw0udQiVoQPu1jG8Q7w2M9YMmIjREd89LJVEadMQRpQfmb03kFLMPBq1uzaRxnnobwnCUpM+7Gxwmimd8ilUGOlTVlpZjwllLSScggWbq4VadVePkWCUZg80yaEwq4b22x15Rr+h/GwPXHcI9LkxS6Tkn94GB89w3uERjsRY/WLixwsAi0wVgnsKSxjEspj5YloIaDaiTu9kX2GqGIpyax3mmdCCRYt2JCbudAVX0myFAvJT9YU/0wj1IDHnUY3xo98vk5/mobLR0mZ1r+XXnvmV1xDWS/2P4BgPQd0JlaSRWFpiVZmawHtEiXHAXCaCMTpK7vYI5CtvljvcAdxUwq1IdwTf4hxcotrDnBO9+fHUEne+/nCDDKBexmVB3mptVKlCwV1FNUDoo8NuBwJf7+BTO9oXOUzZECvwtUBKpKxAY9TkSSAniW/zcvr8R2hdLLUeZtf5epBsvpP+YXOc/XtjovRMwAZQ0wvuBOnufF7weWwAxca2WUZ3fN3QNJFR78pCxWVnbVBEfp3PWB/z0AqeRmJrXBZS0X66flIN63fQTXgMYcFFwwW0gKVWBBe6yjPy1+TmB8STTyK25KjY9PKOximsSRBR+
 lYdFGM+8
 NhfVuLa8HIQ0qHz9cyJSQgK/wCSb5EOtkh/+VXT2om+ufmE7yVB5P1JGya11i0esjCJXuql/FHvj7Dd/UQVZBWBwjJkyK/n3yR/FwXups7K2W9F6SlZXCRL5j2uXYnwJvNrY5gjapIlVGBeNVhtuIFcuBRXbw9U5UrFEmwTsM+FEvHTt2NJ7D6vQyGJIfplcVrHPws5J9cjsXg/eem3GcBXLYQ1WMEL+3JRuRGmvkwMFDFvNEW3X8+HTbgS+NDAwNNSaERx5fw1kwuarMgBalEZMr6ppXYYEsLQB4JkiJZKBO7Vg4NPEHjdPmO3j8nvXlQQQ+Gy2UmmomF7SnVMnzGfNbR9WIvon78vrYasUG7nyBXThF366F0NL7wicu2NJ0yyKO3kkOmgQ7kVdopbGcTA74mrMOp6xa/0ljKWv7qZB1Bsnu/2W3p1jEa0KPUHRBRxI+SZeB+aNqgkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, Mar 19, 2026 at 12:58:51PM +0100, Jan Kara wrote:
> On Tue 17-03-26 15:53:51, Yunzhao Li wrote:
> > 3. The freerun ceiling gates entry into the proportional
> >    throttle path. Even moderate sleeping shows up as IO PSI
> >    (io_schedule_timeout is accounted as IO stall). Dirty
> >    never hits the hard limit in our case. It sits in the
> >    proportional zone, but cumulative PSI from many tasks
> >    sleeping short durations is already 26-40% (full). Should
> >    the throttle path be skipped when sleeping cannot help
> >    drain?
> 
> Perhaps bumping PSI when dirty throttling kicks in is not ideal measure
> (because it doesn't necessarily mean the storage itself is maxed out,
> besides flush worker not being able to saturate the storage there can be
> also various block layer controllers arbitrarily throttling background
> writeback) but again I'll let PSI guys to chime in here with their
> opinions.

What PSI is supposed to capture is lost productive time. IOW, it's not
about device utilization, it's about whether tasks are being held
up. That's the information it intends to collect, and it sounds like
it's doing its job.

If you get 40% IO full pressure, that means during 40% of wallclock
time, the only / all runnable task(s) are waiting on the IO resource.

It *is* influenced by suboptimal device utilization, but that's not an
accident. That's a real cost experienced by the workload, after all.

