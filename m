Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632C7C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 14:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E087F6B0095; Tue, 29 Jul 2025 10:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8FD6B0096; Tue, 29 Jul 2025 10:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7B76B0098; Tue, 29 Jul 2025 10:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5EEB6B0095
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 10:22:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 744451A012C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:22:52 +0000 (UTC)
X-FDA: 83717518584.27.5C7251F
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4588C4000C
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 14:22:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=xXtrFjrs;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753798970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COkIEuiWzegLgJMToflCtnJ3/8gZZNZmKmrpqxdoDwA=;
	b=x8A9Ix2bIo2uIhx6IdIorZy2SSuf2BHmDVg58ixaLX2wy4gEmWPOIYg7+yNlpiA38pgfyG
	iYxTQ8TYPbzZGg7kCH6fWGO8ciCUt9Cz7JrngPL0sisuFqE9cx+0Z3dOM9a1jVkk5Hv/lJ
	WJ1lchF1ul1k4GWwVdi5yIOeL/5h5jI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753798970; a=rsa-sha256;
	cv=none;
	b=WzFx2tIwb24uWuvH7G0akOQfjClVOxdd70ARYgO6MP2IaEZOdKnIoszG/OAZyzXcAxaJxL
	NjPlhu13F1Js9OihOFKDWtz2+kyPnehb90wRFgK6BjcX8FAUkP4OcMwczTMT4sSNlyfre+
	xoliASFedpcmKagK99PR7nx+gSOhDTU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=xXtrFjrs;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4aba19f4398so66835601cf.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 07:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1753798969; x=1754403769; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=COkIEuiWzegLgJMToflCtnJ3/8gZZNZmKmrpqxdoDwA=;
        b=xXtrFjrs8hqiLmO5d0lhq2SsgESREu/xY2OWSEqsxCZpayfl0F0/2TURMa97T2w0Tn
         2aS+V64hb63Bseivdbfa4g5aSRlsxKmsefmGpuDp7ZjorJQG3gRDPDmFt4bXXngJ7Ucf
         HC9fj/WwlMGfs1Elm3ZZyh7JhimPLxNmFfwmL+43Q/JYMvCWAh1cLTUni00JFnMqQWoq
         UB3ukolTsOg94FX6bYWymT/tk4oX7M1u+lrZ0XkKBlnlg1zv4Y9Tydj/GDnaYyIfA4cV
         syMGp6jHrxh3ztjx006gQhVvgDVcE37cY2eiKBkB1vZZWq/3uxeUc+/Xby6FOIVDoa1u
         cRGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753798969; x=1754403769;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=COkIEuiWzegLgJMToflCtnJ3/8gZZNZmKmrpqxdoDwA=;
        b=L7J02S6wUlpaF5bWtEidP6SkQ3xJcId6VAGXs948Niayty4RAyVd2vhQbrudjduEKn
         BSfzZZ/siaDI5qBhdSLyt1n8J9CRjVCN186Wo8LtQqJxdgE4VhxChvrvtxHuPFJ2yV2a
         /Gq2B1Sv7mO4J4LyzeIBDoin6ZTfhrTOGecyloxuM/4yOlo0uEOPUYkY1k4/mbqfZgTh
         3R/OJqqyPwF9M19jlu6acocQaadhVbNefMQKLFVUytalIZIExPo4gxhD1rjzfxYhFgB7
         JP53wYLYOd5UoZn9qMN6qJHCWLMkT5ZG/ToYzDzgSqVOq/2FcqZBXDkY/L7rw4DVdNwE
         HPXA==
X-Forwarded-Encrypted: i=1; AJvYcCWDWE5iuw0Ds6+RX5lsmx1mxm14zjQgrRDXEiYtS2ciI4YF5A/7IYfjrs3+hMXM9hJ7dHR9q7TXWA==@kvack.org
X-Gm-Message-State: AOJu0Ywp34g3790HycCseyvD3yNQtLg7WqKp7tB7zuKH1i6NHDOlHpwQ
	iIpM79guooJjdMJ2HC6r0kXSkdt/zUDvkQ/aTMr5MOUnX2NkDo/x3eIUDizoPJVdFyU=
X-Gm-Gg: ASbGncubalm36FjEKRv05Awax5UPE7yxzLR+QNMruZbHxL3b/EE4b+hVaooA4o8ynyF
	MyeSiSdTP2Gkzys8HJvAasvo9iIybNppwi1Qi5iQX/eYAs5uXckK7rcz81H4u+b3rxtgdAwkuhQ
	LvZfYSb7E4Zo3dlU1c189adZG5zeR2/Wy1JQKDrciKyoGhelB1Cvod1yuRDfxhyWngPDVkKTOjN
	WqBXAfySW8jCEtWtcAhlAz0mWwsi32CrQ46n0G4nsVFVk/oiXg/ut6ef4KpRIyRpZFvfoOO4gAO
	Lg8hDW6+bBiv87C5xP81oEfYNpSf9aB6Hhzs7NIAnB6Onua0Xvu7FE1L4Zkhmrhg25PRUMPb0T8
	RaGtoPudcfUlg8g8ZntgjZtZ04cMSwx0B
X-Google-Smtp-Source: AGHT+IEUceVkl40iNUbmH8CG0B9SvtBCZGSM71xkMe4dIMOtKKEAU9bj+x0vh8grcAXbbZcW59/UVg==
X-Received: by 2002:a05:622a:3:b0:4a9:7725:b1be with SMTP id d75a77b69052e-4ae8ef406d4mr180745941cf.8.1753798968930;
        Tue, 29 Jul 2025 07:22:48 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-4aea7d724d0sm38853931cf.23.2025.07.29.07.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 07:22:48 -0700 (PDT)
Date: Tue, 29 Jul 2025 10:22:46 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
Message-ID: <20250729142246.GF54289@cmpxchg.org>
References: <20250721203624.3807041-1-kuniyu@google.com>
 <20250721203624.3807041-14-kuniyu@google.com>
 <20250728160737.GE54289@cmpxchg.org>
 <CAAVpQUBYsRGkYsvf2JMTD+0t8OH41oZxmw46WTfPhEprTaS+Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUBYsRGkYsvf2JMTD+0t8OH41oZxmw46WTfPhEprTaS+Pw@mail.gmail.com>
X-Rspamd-Queue-Id: 4588C4000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: gmh7mpnkmukusomff51ee8xanothz8t3
X-HE-Tag: 1753798970-638907
X-HE-Meta: U2FsdGVkX19we6AoLrqheSi+huVqtmzNL+QCB2OU4Hm3jIKCuI7pFgkDPQXvouYxRcZs4nhbhlEGrwX167O9Kn38tEcJCTfQzCqx3RyMqwpagqx/tXUSPmNzOiiEA1fcdze/wTyGPXrriqqlnX5T7p0yI+c1NUhXLlMyjlmE0L6CKu19222g6leCY7WZDrbL4mD21pQe4amvDDBlhnaP+i5ynC+lyP+J8NhGOOQc/1v0hptzb+WHhSK1+qCJJCjsDBGFp3kHHQ5yh86kSBGYnPQU8G8q/IyPYlEzaJG6rXs9/ZJjMvvbG+VJi6Ds7picWWhDe6bgeH+0dtrFVmlFUj3nu2kTb7l2JuGKG6Xm6nmx1BYOwerhhrmkNUdwITQXmH+gw5/T9q7HZxvOJQsrPrX1ab1CuK7SPZqBr3BfbNV7+HwjCx8tdlpJUxLtvhz5QhlRSkTfdI0IWdr2vJEq/sJ/Mx7E8UtAfm/2YLNRheGMF20kCgIWNPDRp56F/SJipzp/fbkSBfa2ZWb88B68kH4z5RJcLexfZjeuYhA/RR8HuPOKBh0FvGVGnAJ4pQMYtBhuwM/CqigXc1V5s3Y/EhAVE0+K6U+l+weHXAQmunWiDgLwgB4Xl2+ieWWF3tlQ9k0QEzFRFXm2ZNByQGsNQ3fqFuJkUaUat/AgoYz/Wky+qffuTyhWh5uGhhSR5ZgSYmwG9UtvoZOQ654aBl0m0PBti/VXlrmDcynjx9ZmkaC5zJggI/yFErntBviSjUUioB/wiwu/5ckQt/Xy1sZXhO/oS/xqOkKITkEaEs9GOzbVSwq3QJLPXMFcqfmLYCw38TAE2yrKzP9ybj5Rpgh4OVisT4JYlY0/NGD8pcb0hce/5gbBnB+5kEkzf+7IM1n8mirc8SWkeNvAzd4+TTUkESgEEoEZEgXIRYkP+SjuOzxFATFzY882cy10NWOSuZHIyUOma7Q4mLr/Zd/Xu7R
 pxHi3Emr
 zI7b2IWyMpD0slOvAFFMB57gfby+mD6IJOj6EAEYBHtwnzsP6LDw+he5+n05HULTzOXHmmZJ6r3ttvhhVhQElPqFOXAFHX1HmiTWTibz4YLYu9BDsf/9psU52/lQtE4gZpsrPYHls3MoNmtxSVcaNjSlwLiRg6W07fNJHYlw9fs1NPZ2A24lVL538MyvUl1f9ofJ+e7yXNRNJKavNi6ABOpekOSIe6+djztsl5HE3q5O6wrDDuXfvEBYklrj4oUBtuer7xoyg2WzjTik345txKq0zfhwKRqyxtS/MoF2iDHX37SEFNAvMNjE5Mhdv776QOBFpgPR0B4IAhmGq++Lubj/0oTpFa6JL7WP0vdOTFk8PE2qkAId2ogI/Bis+gMx5DTRjE+jbUzpOose+CFw2CxV+ufNHB60xpqMaeK3IBJbhDuES6oQi4LJJRd9ZY8A3lyZgQa3zUnm9fgTBFDGY97nhVRhHd8YRnd2o71OkdIQAyrHLLM8Vsuln62ERyQ4XPrq3McTbfy5yDIj/sVqKao8SvVqUuYz8Jw+NunXHV7wyrA0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 02:41:38PM -0700, Kuniyuki Iwashima wrote:
> On Mon, Jul 28, 2025 at 9:07 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Mon, Jul 21, 2025 at 08:35:32PM +0000, Kuniyuki Iwashima wrote:
> > > Some protocols (e.g., TCP, UDP) implement memory accounting for socket
> > > buffers and charge memory to per-protocol global counters pointed to by
> > > sk->sk_proto->memory_allocated.
> > >
> > > When running under a non-root cgroup, this memory is also charged to the
> > > memcg as sock in memory.stat.
> > >
> > > Even when memory usage is controlled by memcg, sockets using such protocols
> > > are still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).
> > >
> > > This makes it difficult to accurately estimate and configure appropriate
> > > global limits, especially in multi-tenant environments.
> > >
> > > If all workloads were guaranteed to be controlled under memcg, the issue
> > > could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> > >
> > > In reality, this assumption does not always hold, and a single workload
> > > that opts out of memcg can consume memory up to the global limit,
> > > becoming a noisy neighbour.
> >
> > Yes, an uncontrolled cgroup can consume all of a shared resource and
> > thereby become a noisy neighbor. Why is network memory special?
> >
> > I assume you have some other mechanisms for curbing things like
> > filesystem caches, anon memory, swap etc. of such otherwise
> > uncontrolled groups, and this just happens to be your missing piece.
> 
> I think that's the tcp_mem[] knob, limiting tcp mem globally for
> the "uncontrolled" cgroup.  But we can't use it because the
> "controlled" cgroup is also limited by this knob.

No, I was really asking what you do about other types of memory
consumed by such uncontrolled cgroups.

You can't have uncontrolled groups and complain about their resource
consumption.

