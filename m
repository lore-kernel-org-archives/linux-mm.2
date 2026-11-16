Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BABE606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hrDpF2Xa
Received: by kanga.kvack.org (Postfix)
	id 0E62F6B05B1; Mon, 16 Nov 2026 17:59:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE976B05B3; Mon, 16 Nov 2026 17:59:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF2D6B05B4; Mon, 16 Nov 2026 17:59:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3E586B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:59:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28555A792C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:59:27 +0000 (UTC)
X-FDA: 85442500374.16.2A3478E
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4B08D160005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:59:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hrDpF2Xa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794869965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z51ssyJ4msyJMPO5cu5It/w/N6kkoJUIReQl84tAXVI=;
	b=HKklXrK20M3/yRbL6+VunPIliQtWuuUCHa5QNhuZJXIMRL3TtwUoIo3/PwZVnx+OtIdqFk
	oTO8DVZYSNH1ojFRQxTtbjV9O/PzyVL+B1XqZ5GRQcVpt1HXzlAAakPsW0AA26VigAw/aE
	4qS646QtHD0klw6Ogt0igYXnXn7oXVo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=hrDpF2Xa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794869965;
	b=37cUThEVFKDY5WUX65xaZffCSFb6QgiLjwrtnTO+OL+f/QtrECQmhEpZbqYxUUgC9fekkv
	zuRgzI6cc2YaQvSTXvlyKWo4FYdsv3OEmsUmpZJ73PAHFuTRpjpVmYqYs8JooSs0+Ut/Dw
	SMUnDgUqkH4Vz9tPhpQGlFO7bh9ecaU=
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-4ada9579947so2879702fac.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794869964; x=1795474764; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z51ssyJ4msyJMPO5cu5It/w/N6kkoJUIReQl84tAXVI=;
        b=hrDpF2Xa5YgZJLQq/XNJ/qvoSRwP7NnE7MivzBIMhuvMebiNYsiqml03tTeYqMjymw
         pIac9/tfxPeBZXgR1u0Bmpkzkouu4L4qm3GS6Rhf+XPI31NtbftV3DgL9bSt+g2GfN4a
         s0MPnU5j2Xh1z1UAC+6nj7ElgBiUlqOGB004S1EwXEpNl1x4VOqFymOKY6mPw2ZmVuKp
         KPdw2meafdUEX0g5dtn+VeaO9N+/4uTYj7nn33QJNN8YHifTk6gmcxVApHrccplLMHHN
         jtNZyvopOBfRDCx8sYK8FDrOYcAsZaGbCOKHpw/3uqv+jiccF095z2hhW7/A/TxQGHn7
         g8hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794869964; x=1795474764;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Z51ssyJ4msyJMPO5cu5It/w/N6kkoJUIReQl84tAXVI=;
        b=uNqpDv8t8Fdy6Un+lmAmoiR5A1z/dYtUuE98fFJ1DtdT0POpNGgk4C/67tnOCQwLkm
         YDD+Sva4mbWdPMK11BlO/nTCJ1H+dK+Nz9qJGIfjjerPiM5XvR0aeLD+5UH9Ip3IDvTz
         YerO9DLRPbvX79qsBNm5udUpEAaCIYZL6bNDADEaSo4fHqw9sxHoDb9eOwuEycQ34WaF
         74XFXk3R9ModifFoTNtyZmQtwwszOq3m0ADEdmjt7Z4Ymqooe1tkM2z5J2H9tBIliCxP
         fQgCrOcKwwetLsIzUme17qy89622Ya1kPwXTyqTlZ7g5Km/nDdKlBNstM2EFhVXK1rIu
         xyhg==
X-Forwarded-Encrypted: i=1; AL+hErHuPTszjVI6AznyvkyM1Xg1lBGEeXt1XqSFxde4iDlQB30RcWIjAlRH+u0V1TY/Wt9pHvDLmihwaQ==@kvack.org
X-Gm-Message-State: APuU4Z9sY7HvfRWzaIuDG7l7AtVZUHfsL9JJGCUyIK+I3pR8c1/lMkvs
	RtSQn48UqNszHvadAddSiZzZ1PUZnb8kqSQ1SzSJPrx4QD68zMRIaY1N
X-Gm-Gg: AYBFou3pS7HAnQSBqGhmHRkGllqN/aAPmn8wp4eXfqX95PAJpASK0BJPtDfYC+4QYrr
	1hVdGOrnjvuELwHEW4q+xjjxLQYz0sHr5BrIp0Kp2S4Xm5yQD3VoMFBaXqKehve8IYFSZsIzqkA
	V0y7QVT+Fn3rbE0BIemhwvQxAUUWE9jwhqXtswQ2AneAV/fvvOcaKVk/TCRH88WDm8Y+GKp5oMH
	+t8g5nTgPA+qcF/wRcsua3ZqOotu+uCjyLh5Y5wJGBwntUEW9DsRZmN/Bv4cvoN1wAOb0rCHoqd
	vNvL4KMwdgO0KCQpRaGWgh1TQSJhrmQyxEGOn/Ls+E03iCkyYIdARs4g+vEmaUqiIykz5LwsxBu
	T/Xmlgq6J6/ejVQqe6CxCCDhBZ4CakV4ff8Bxp2+WPXz551Gm2m2gLodFCmjK5olNIV01CEHuYM
	a1MAspQrCxw9q1P+TMXgI4UH18ZrmRw46FhaNy4oJxA8/zZ0tWHl8DLbgo8UdiC59PMOwlfzvjk
	eL3hjlIc3DgaskWEUsuRrywV/5CfhycCK7XmkoOjlMTJftug/7Fi7mhpAql44NIt0Go7r6rnw03
	i/R1UrIeXdus6CFJtYoNhVl+sUq2z1EO88IrY0nQ9fx2Wvseyo2mUe9QUEg=
X-Received: by 2002:a05:6808:10d3:b0:573:d802:faf with SMTP id 5614622812f47-573d8021bb9mr5778528b6e.16.1794869964287;
        Mon, 16 Nov 2026 14:59:24 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:d::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-56e70243e1bsm11192657b6e.7.2026.11.16.14.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 14:59:23 -0800 (PST)
Date: Mon, 16 Nov 2026 14:59:22 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 2/3] mm/page_alloc: move the kswapd node skip check into
 a helper
Message-ID: <avuKTaBpfAmiR7Mu@devbig011.atn3.facebook.com>
Mail-Followup-To: Chris Down <chris@chrisdown.name>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
 <20261113235238.3595412-3-joshua.hahnjy@gmail.com>
 <avt2RrtFc-G04JiJ@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avt2RrtFc-G04JiJ@chrisdown.name>
X-Rspamd-Queue-Id: 4B08D160005
X-Rspam-User: 
X-Stat-Signature: 5xyp6c5xpwdyysax6ec57ca1o7o96uke
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794869965-109814
X-HE-Meta: U2FsdGVkX18JPH8IsCs19EKUxDB7z61jVb8OfZnKIpPBZD6KmdGDekBbhiEF3jm+r5EXVrfeMuyhT/8UhXDTa6VzkveHYbCUTw6gqB0wbQ0MeMmcr/LLPjVcDgXAiWBIylG6112I4uQbCv0ABEoAWdrV8irOxcQxqDJ80fKyDLX4LI32UUAf7zkBba9ZtEK6hC2WaTJBdn1B3qFoPWa/rUZd3ci8u9nTp4X7xpS9q/3ig8k+xnFEzUoVVExKSRTD1bivZcAjg77jCv3n4VlXY6YKChIjWLhtRJ3JnwKk/n8fB2s9zUaGPMdoRo82CbHlUf4HmX/E6z+B8tiS/e1aswFud6WLcMTmUnJHmuJE3HmAaXAaZ4OwttJ9hdEC8pdfAhAYnJo9OAPgde/5vzq5UWyhExgU5xoaGzosI6cc+7lI1eQ06aojSF4gApNcF2Cky7lVRr6mBD3I3q9Odnq+Vz2jEUvk3JUL2qSifz1MhHoh3mHRhUeMIDw0aR9SkuMWYpgHpuWpi5FolTxhY8FMEw7nYJklyH9xyIw7fmYMyEJIYXwel/aBnLxqcm7YYqWGytu5qUMAbb3pa/pE+7kHa4+s4SWQYErlJdQrLkhD9cweXTaDfQ24x8QNRndV0AEswS5ODaefrREeKs3FAu9N7WxiNShyErguMqy5szdlKF9AAzW0rmhTMCwHPhS+d25o9utzJ74T8NYp6umUQAkeaOQqBahhOzl8ghZLNcsbSd82Z9C9BCr3ZNWjpDWKQZL+yI/4kzJo4szR4m/zoa/hxA7wYWowr6kAcCzX78jQcbSKmcdfTMwLduUGDdKirTpnz8PvB85JlGU53E9MUpG3TAa1K6k/3+AX8TgyziXY7WJDpMaAkn0iN8kT0ibKns9/b/Z6UnMq6qJqtp9Ut66b/PqwFzYcucb/KExLueFOpRasBOTjnoGNrE+UA7fLviLIIlsw8JLy3lIunDAwGxa
 iX4r7Rs9
 AwtNXVa/H2pNUd/6Lv22kPkVOepylRKr5hM06pIMvH+1IEpo0nss/fp/zpLy4A//Kvc3735l/+X2NeN8CW8IDaiPriDlmsEmfHG8EiyCngECi7PrOH4itK8k7Vd3al9fb/LjPSf2HQ5qYFR2wjV3IMMYW+hSBXQFP7GWhAEjssmsinT3gwofx721ObwSJ4wxKOhhvIybVWcvbEECTuY5x63gf69rv+fU1behpnr0Qct+aKVyy0nU8VrL1CxVr3iZrJSO41Rn/lVN104PgELZAGcge8DLJccs4G8tgNxarH2fhXxbSpFj7nJPgqJMEluMtIzrV2ZtMZXPgx1h36FMBRNaUgzQW5duP0YDvfFm7kG6YqIjttcqAGF7IO95K4yJxUHGD960U2pIbNWZ4MlgV/QZK/BD4I2lI2Yy0nFzMVKAFZ9f1dwerZTkOUyLtKMC6I8u7cZ+0cHhlpzaqBio17Am1BFUjGjgM+faO4X+BukmfxZ2uHn+8lM0Czt/ES61Avz2sZi6ukRw33l9Rh5pGOLmn5njiJ63KtrjlnW+0Gn+m6705FZ0kKhp5y3PD2zcCqlB+Y1RY3Wnvmzy0YDn2w3PfZ6xMsrW1QdKw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 01:31:50PM -0800, Chris Down wrote:
> Hi Joshua,
> 
> Joshua Hahn writes:
> >+	/* Lockless check, a stale result only affects zone selection */
> >+	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
> >+		return false;
> 
> Not a big deal, but now that the test is the other way round, this reads
> backwards against "If kswapd is already active on a node" in the comment
> above the function, because waitqueue_active() being true here means
> kswapd is asleep on kswapd_wait. Maybe say something like that
> kswapd is asleep, so nothing is reclaiming this? It needn't hold the patch
> up though.

Hi Chris,

Yeah, I agree that it's pretty confusing. I need to correct a typo in
3/3 anyways, and I think it would be best to spin up a new version in
this branch management transition time (instead of asking for a fixlet),
so I'll go ahead and spin up a v3 that addresses this.

> I've tested that this works well, so either way please feel free to add:
> 
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Tested-by: Chris Down <chris@chrisdown.name>

Thanks a lot for yor time in reviewing and testing this series. It means
a lot to me! Have a great day Chris,
Joshua

> Thanks!
> 
> Chris

