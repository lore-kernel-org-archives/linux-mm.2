Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15E31CDC19A
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 12:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C0116B008A; Tue,  6 Jan 2026 07:59:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496D76B0093; Tue,  6 Jan 2026 07:59:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3BD6B0095; Tue,  6 Jan 2026 07:59:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 262586B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:59:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BEB9A8BFF5
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:59:20 +0000 (UTC)
X-FDA: 84301544880.24.27DD0C8
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id B7266140004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:59:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=g4CxlVLI;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767704359; a=rsa-sha256;
	cv=none;
	b=miBpAjqnfvB3cfyWxqAIPESUDxp+ovkhrt6Zj/9yo2TMxgs88ER+vScQOkl52wlvdy9Nkz
	QdagBgIyF1HEkg0jWtYljVesSewHtZbIQlcDz/s4LQnqz37AetXfLtDQ6jiBJ5off/cBVS
	2VzJ1YPxDIlmmp1CtwBeYHRsrD+cQVM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=g4CxlVLI;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767704358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rISpGb7Ers/CHc+2Rz3qjUUFoRTwyiYj07UN2exoddo=;
	b=Ubxq0gblNl5R+Xxi+dtzdotZW1W1AP6VyO6DuOCpllGtPmd9gmG8ITK2X2GDp/+V1+q7zQ
	un1MVdSBcIEhXvzrwTw1HKYXJHUCiwmVK5Wuw0t6ciCPWqUpSFj7Id6LkOy6lLj0zgIw8a
	R1Obj9qvleNZGYEJY7N4GQg2It+qTLw=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4779a4fc95aso13156265e9.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 04:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767704357; x=1768309157; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rISpGb7Ers/CHc+2Rz3qjUUFoRTwyiYj07UN2exoddo=;
        b=g4CxlVLIB8H08JTsfmoUS2SEcSS+J8GmGMBztbZxum79B0I8UfW0sPxd6YjVyBDHIQ
         fAq0wafMUMEEpr0RY9SSe6vVFN7tz/4NE95REC+YKfui1z3u3OjlRosBgMF3gOSAuSDh
         Yu+P3CBljkRpvpuUg9z8Sz81NnIR+IuP9ZBKKUBV4ErYDt1VYXBWxdhVMT8WcstqFFt5
         SUjvjp8jWHkEAl6ERnG2gldyQwNfle8GEDKRqMjjWtdZA6g5HZdpYQy2wjMQTNxLXiq6
         xuX/SllzbZOzGbYRNaehwvpqVdr0NE0MkZgID9x5eYz4UsGT9prvECsjldMr8QjRaf5W
         bhKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767704357; x=1768309157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rISpGb7Ers/CHc+2Rz3qjUUFoRTwyiYj07UN2exoddo=;
        b=GrfERXMNjFFXa79I1BYKhibehULYSYOxvE58tEIlKJMKHAsNzQ5PiMoyZUxhXXQpAc
         gimthugb25VGHfZPMkasJztKyGNfTv/EaH5OcSlYdP7XQelLSEa9VtwdYDNAkfGYBVFi
         6T3DLSA1d31AkDV9UtnhPAZXQqTGD0L2FCD56lMzAvVs4urR6ukcP6oStAexjDb+lKe7
         Jxwo5scj/J0QYeG4RqjklrPJJvhZ1/fxM5YSCgdv7UvSiftqYAm116ZjMunJU4aYuheu
         S50j3n8JgtjGVN26mZRD7apg2qBLBXe0VvF0WAXoiBkiTzherv4aidcPyqA+ZTHqcEyJ
         k/zg==
X-Forwarded-Encrypted: i=1; AJvYcCVdN5nnzMLUVNex6mWjcHKln5fR9opblMgoDyDiWu9tiWacbpl2GkV28RVddttrF/vppZ+W3lqszA==@kvack.org
X-Gm-Message-State: AOJu0Yw45nNvMfWDi95r/kPgyDX3W8Ng7gnumwsDIxu8aRlwCRhp52cE
	/9BV7Tq5Sk6uRZGl/VKevSK9fwG6cw9eWLRFFkWKj/JBb4L7u+NVBUUhhcL0cDhyHgYUTNkY0Nc
	et9Ot
X-Gm-Gg: AY/fxX72AvIkwcNdXQRwbyHO8rVRKxqb1D62NXQmjGLTGEwD86rMeJ13LYiq3U9qHnp
	a2xQCyBcD4+5XQ6KhPaU1pRNPXkYqh842UUPIG0G6LlXpafkyKV60Oj0DLo835mfXp63edAKJdt
	am8KZcvfoond8V2zYKsYAPq0NUIqt4Xre4LiKw015Izi83QKzc5ryGRlAHKALhEPXEyJziasdvF
	015gA6ppp5ivfLZM0PV/KMMPGRl1cMZoPmJjfNzSNp5i38iIkeysxOlvj7VRNbzZR5ddZGsWjbe
	oiyEOPNCZAae4laZ4aam3NZn1lwGY/K9LAopiiSLPi1RW9RCaIRLaP4pjWL7zAV6NbjJ6V4boDR
	CEtS5F/F0mvAmUCSjP4p4AGNndkUPpItVWoz53eS0i6p9mvdLkleZCi8UM3YeuXsiXqfWrEIxgc
	F+3XTfnV/79Z1h4aOAFSM0CZB2
X-Google-Smtp-Source: AGHT+IFf852uvGVgQ0nkdgKfOEZmXUesyAO5T04U3YI25fiDD+LhS3G4kEwKcViOOsd7mHC/fP6CUg==
X-Received: by 2002:a05:600c:a112:b0:477:5639:ff66 with SMTP id 5b1f17b1804b1-47d7f627b7fmr30582205e9.13.1767704357166;
        Tue, 06 Jan 2026 04:59:17 -0800 (PST)
Received: from localhost (109-81-90-116.rct.o2.cz. [109.81.90.116])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0dacdcsm4237112f8f.1.2026.01.06.04.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 04:59:16 -0800 (PST)
Date: Tue, 6 Jan 2026 13:59:15 +0100
From: Michal Hocko <mhocko@suse.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
Message-ID: <aV0HI2-iRXuQ4MGv@tiehlicka>
References: <20251222122022.254268-1-jiayuan.chen@linux.dev>
 <4owaeb7bmkfgfzqd4ztdsi4tefc36cnmpju4yrknsgjm4y32ez@qsgn6lnv3cxb>
 <2e574085ed3d7775c3b83bb80d302ce45415ac42@linux.dev>
 <u2llnnpmpsgarwrt74ffgo3cuwe4apdbeh5hkclzbh5gykwltb@whb7uuj7ub5i>
 <e93c75cb1a46a60ec415215c555312c82b9145ac@linux.dev>
 <gd7qbyakigogdbfxkujtc2ewwfzbwudn2l6vqkbkttv46wkfrd@nqseltiu2do5>
 <d7df4e26841d83154f2cc2487d5acbaf2ff2cc27@linux.dev>
 <aVzaqAZ5Wagh5cDQ@tiehlicka>
 <52cc0b2671b068903c6580b7431db0f22982ae86@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52cc0b2671b068903c6580b7431db0f22982ae86@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: B7266140004
X-Rspamd-Server: rspam10
X-Stat-Signature: annn7ts5ejoatx9khb7tfoqgj6kgchty
X-HE-Tag: 1767704358-372309
X-HE-Meta: U2FsdGVkX1/3Ldppf/1bkFKxwayJjxTKuaZ6FpDCxtSgz+ABS68WIXwdVd+SAdLb+25HGEqdwwzVhBnwSU1n7i/6vkGnWW8eRh6gPrGXa/u7WdgVTr/pN+lfmH9/uVQGBs8zJ2d7+OcK5/kX5SquMGpukFOTxz7+EoIu1vu5hDMh+DhkjuHFXpmuHHCGoe9l5790KqWxjTvW39oK9KeVV6r2FeNf8CRp5bAWDJ/akJWW9qZsNbhlBXCdIJ5ZvmEO+4aGeRUef7kpa6ZnZXmmxflCZmGnlGCKR0WQ54w64Ucb9LwlkWf5WlyFRW0+qmnJhr6chQwX0w84GtLu3zaajiEB6HJbB+vUsgTxXGQlHqlhNWSXJ3J6URMZGa0NNdhXSg2Ff55QtqurJhVyxV9Y0dtL6tvknnGqAobQELeT+YVN73NGnWk9DQ48raylHuBQhN/spVN6YcrMktf4860QLhLP5o0/7GAZVPqSs0bvhA9BS5aU+qjfbuW+IMjhDxVKMg14nM1oGdmzIYd9SMfnPzWYVe0XU8sVmTG4JDlrC36FKKn7yGuaGXegZB97qhJvZmYwPXwLK0KLgwCLF87YVR9C2q6hpXzMLRtRX0SZBrGMR3uvZcDNAN+lm5oEHdQlapIC3I9s7+kTaZM013mXovE8CosFutvq92n9Ei7wW2IdsQkROTJamOiueq5Wf5Kti5fAPein1bMkaidpgKr8cNMynVSsJSI80qFbmQRCmiCX56px5B941Q7OujofKNgKXc/QLhGrEMIAKLBk78Sm0g31QGB/BRblAm5y6gpNMj2zxQ3es+N6JgRw16Qxo51I7dbrpmQmxxrG7mO8STAwuNCOLZO/Ie6fS8P6gnxT1dVFwDNA/Khngk2u1trUjLTzsQ5rxGO8ACziU2/8nAz6cC3SRNmbeKIOBoaT7cnmdVzGk4HDxEoVoOGUuwhSmbFdJWa8Xbv7asRkcA9+m8n
 47djRmP9
 S1yHa8mAmL5x8M8HO+dNSr3Eji0efgRAKZds+t0p7YDdcUduw1eKO8kZjc0nwWNXXkcyhPKcKVnJcfGIfQh+hgCL+MRH5SwufVKSTSDfN3q6D/E38DMlqwfR8EFG8OtW+T7ik7h2FIWrqr2eXiMHSrH8jhyODRi16fUX6ZYBmD7VIW+xJcnCg8cghGMZISMp/2vJR/4RyHTw5Qe94ypYlPqglqAT2QShXF2H7hDv++TUKbLHB6On9Q3XMDZzuezBFBx56nGRvqlOzGmJZdaCrc3Syoso1vnZqevx7N65BEF+CqsA3sV21ZEn3AVm/o2u48TxLZ0WXmh1JHIyNULOLty9/qXG9NjmwkSwRAR7vrNydoKi79wKVSiKpLd9T8ve9NQCL38P22viOOMd8AXX5Tm6drdkqh+dl/hafl4MjmLUEV1zunKu4Ifujf4fHmn5JmZE5pf5FNde/cf01ETO0Sb3JC48DMp7Eh1BJeR0yqbfrXSdb1InzCEPSxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 06-01-26 11:19:21, Jiayuan Chen wrote:
> January 6, 2026 at 17:49, "Michal Hocko" <mhocko@suse.com mailto:mhocko@suse.com?to=%22Michal%20Hocko%22%20%3Cmhocko%40suse.com%3E > wrote:
> 
> 
> > 
> > On Tue 06-01-26 05:25:42, Jiayuan Chen wrote:
> > 
> > > 
> > > That said, I believe this patch is still a valid fix on its own - resetting kswapd_failures
> > >  when the node is not actually balanced doesn't seem like correct behavior regardless of the
> > >  broader context.
> > > 
> > Originally I was more inclined to opt out memcg reclaim from reseting
> > kswapd retry counter but the more I am thiking about that the more your
> > patch makes sense to me. 
> > 
> > The reason being that it handles both memcg and global direct reclaims
> > in the same way which makes the logic easier to follow. Afterall the
> > primary purpose is to resurrect kswapd after we can see there is a
> > better chance to reclaim something for kswapd. Until that moment direct
> > reclaim is the only reclaim mechanism.
> > 
> > Relying on pgdat_balanced might lead to re-enabling kswapd way much
> > later while memory reclaim would be still mostly direct reclaim bound -
> > thus increase allocation latencies.
> > If we wanted to do better we would need to evaluate recent
> > refaults/thrashing behavior but even then I am not sure we can make a
> > good cut off.
> > 
> > So in the end pgdat_balanced approach seems worth trying and see whether
> > this could cause any corner cases.
> 
> Thanks Michal.
> 
> Regarding the allocation latency concern - we are already
> in the direct reclaim slowpath, so a little extra overhead
> from the pgdat_balanced check should be negligible.

Yes, I do not think that pgdat_balanced call itself adds to the latency
in the reclaim (slow) path. Mine main concern regarding latencies is
about direct reclaim as a sole source of reclaim itself (as kswapd is
not active).
-- 
Michal Hocko
SUSE Labs

