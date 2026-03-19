Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B0581075273
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 708506B0433; Thu, 19 Mar 2026 04:24:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68BB56B0434; Thu, 19 Mar 2026 04:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552D66B0435; Thu, 19 Mar 2026 04:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1FC6B0433
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:24:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EAEEC8B74B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:24:19 +0000 (UTC)
X-FDA: 84562125438.18.FDA89D9
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id D95464000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:24:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TRSeCyDA;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773908658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5V6YAkrWNnqXNX+5hq6I3lGeubcpIYjE1TNWAVeFtuk=;
	b=g3M4RyYt/4WIXV/CCGZpeJcEHJBtU/GhyANEWTmFNS3X+K5eKQ77FW0d+gkVlPhYGLTqGK
	X+vIvKJ0Y+24prDc4S926d61aVagdt4oIHCJi3HYGs1hiUU8t2PlZObYyvGi9dIXt1LKlX
	N41TnQ7WWgZnTE68scZYi7SV4vfp3bk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773908658; a=rsa-sha256;
	cv=none;
	b=m6qaY4PjiqHJpBs1WtyNt5/k5kz7ahC9G7IMZbEr48fA71rH4j0rEd3dNxMrkb/pCDGTLt
	V5H7rq6i/nk47/xIDAALp2teaudx8eEVioKkVG319IjSHPrVIxZqQC8p8oNLGoSvq/krEp
	PUdBCCrF+IAFIqVmJCIcQ8gnauc0vog=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=TRSeCyDA;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-483487335c2so4683295e9.2
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773908656; x=1774513456; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5V6YAkrWNnqXNX+5hq6I3lGeubcpIYjE1TNWAVeFtuk=;
        b=TRSeCyDAMZh7BYyc9rOtFSdJVU0jNEErULh/1k1CyyGWXowW0b4mzObzDxzzMpWu4m
         6LH+Uxrt5XzvzSM9hWzPATVlqD/u2UzGEbcNmn/GJ0uyGg7973cXip7MoG1sH47zerIq
         U4I66FSSG0MHdP9Qlg8HThaWMReewcVO1JaZCGjEX98+vwDawhpuLoEzAI7UFz8WXoMF
         UlvVhm6GIDKrfDEUM/tU7SqeqBX18eIlHXl4R8xYWJxvT7dYKOQHcBO2J4zRpoYRYXOc
         A/VHHAM5Azjf4FUAy2McZMxR5jAZ/Ul3/lgXG+QGioDk8BitOvQyhCkb3E0hrCMD2gV2
         iBXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773908656; x=1774513456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5V6YAkrWNnqXNX+5hq6I3lGeubcpIYjE1TNWAVeFtuk=;
        b=W4GY+9lsnfFJde2xSlJXn4YxMBJD4SRI6hbiCi1Lu4EqPjV/uddnk9XydWWl3dje21
         NrhHfURsbb/CURPwH4H/wvBRziGyGRyixYyaDfo6VO3xZgKYygObTNzzl1a0ARNke/xx
         6pVpHRvwI99H/JadGqq6hSzrX0E9l9kW8fPqU7gkkCN1QpandFJy2CpF7BzBrrscdCqV
         qgvwVEfYDOjsu4i9aUl09ory2eRk8L4zBZRaSppaDNejBavYkfloDHm4Lh/VjkaWPq0s
         UNWMfK3wDOi3OnF4XJIpQ5eufI20itkyuUtVaLdb1V6C7hHVQc5yJ4Hnbr2D7V+jpZ1Q
         E9IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeqGV5Dg642QXV2/v1/JdZbONRsSoO9OO4JgqhK2PbJUPekea7gZ4Zlt8LcX5mf1pGIWkWhw9zFQ==@kvack.org
X-Gm-Message-State: AOJu0YwOfqM369pOosvafa8ToJ3RZrgfQYhYjBxxYlPQ3AywHBRmFEGP
	2+2if5mJsm953c3/Mbc4AxOvZIwkvisxKXz1PZaEvFxYOcHypixVrSOBZ0gZ1+7cSmY=
X-Gm-Gg: ATEYQzzYyPDwH9UCoBV1gZZWK3GkqOs1RBjlgtu26wVpQblQ6HVqc7HboaEi2RFFNRm
	+eUFPxNMBYpM0RxQShr0fThOxLTUeE7yXbpTh8EPN8oU5QCfSmMdroUWpHNV7UJ28RzcMXwiyna
	+W/QDvGWjO1Ci3w/8vxrHJKWlnuJ2q1xc9bilstsYY1/DDaGuk49MbfzA1eMplvW6Bobh7dWCKP
	OWSPuIOzqr4Urq0au6LWUSDw2YyTtsuv7Icq0w5TwdGJGxuSKWUMWD4oPu+NfR0MuQHSRv6lIO6
	upXviRyOg8PtTR0zjOIcbTOM58XF7iL1KRFgZ72Fhm57p7VTk5lsod8BRXBgmD3SUafjEW4pyVY
	Qu+IxiWZMD6C+xdgEsjeOG5K6YoR6nlDmELWUODPd8TQIlg99WDafKyMPrIg1Py7WRGwbk1iDsq
	Nn9Lg5ERl1TAmyabZ6Fd0nxeDqpeMg4Ba6pA==
X-Received: by 2002:a05:600c:3f14:b0:486:f8d6:5dea with SMTP id 5b1f17b1804b1-486f8d65df5mr32233575e9.19.1773908656221;
        Thu, 19 Mar 2026 01:24:16 -0700 (PDT)
Received: from localhost (109-81-88-11.rct.o2.cz. [109.81.88.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f8bd5f7csm52663255e9.0.2026.03.19.01.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 01:24:15 -0700 (PDT)
Date: Thu, 19 Mar 2026 09:24:14 +0100
From: Michal Hocko <mhocko@suse.com>
To: Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
Subject: Re: [PATCH] mm: add memory.compact_unevictable_allowed cgroup
 attribute
Message-ID: <abuyrvVfWJKV7CKC@tiehlicka>
References: <20260317121736.f73a828de2a989d1a07efea1@linux-foundation.org>
 <3db237d0-1ee8-44b7-a356-f3015173f7c2@yandex-team.ru>
 <abphjNOYaNslTA90@tiehlicka>
 <7ca9876c-f3fa-441c-9a21-ae0ee5523318@yandex-team.ru>
 <abpue_k_9mjQAP6X@tiehlicka>
 <73322279-c6f8-4319-827b-938c20c96b9b@yandex-team.ru>
 <abp3-iJbazCpygIm@tiehlicka>
 <b9ceff32-1f8f-454e-84ce-b8788b3a4952@yandex-team.ru>
 <abqQtcNqxzxiZyf1@tiehlicka>
 <fd7409a3-5f8c-492b-836d-559b001a61dd@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd7409a3-5f8c-492b-836d-559b001a61dd@yandex-team.ru>
X-Stat-Signature: ntt9ho9t4b5kd8skzfo83mb7gysi4y1j
X-Rspam-User: 
X-Rspamd-Queue-Id: D95464000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1773908657-991004
X-HE-Meta: U2FsdGVkX1/MN/gPOXlg+njAlNMdL4uDiwmNR6IevmRxObJ2jV89shidtEaUl1aDsmw25Z5fNQPt1zucULgFrr/2y4Z8e6kqYSULhK96UswWJSemWl4GDq8ltMsZvnQVZGSJN8bVy1MLUtwUDJN1EJvAJ0DoMUY1AxP00MGBAy5O7XSjd8KGRGOMI+9fHVIF0dPbx/mC4+7UFuXMMDAVPG8a07ROxoyOiWEEexs6N604gW2EPE8L31/7zvjP9772CpsDHv/pAkxwi+q1++Nd+AYUNCbwV5dLIW/sPP4knN/l5fW9NVkNbaP9IWn9nPXmuqkJC6nz78lfZw7aJF/V7Ddx0V5o/DAFbl+V6v9y+fSFbN+TSTY3KPba+AO/DhkJGye5qEmQh72fohnUD/ToY6x7ZnyP0lcecMIhNOeG5GTwDTBCSTFBfUNw0nI2V8t6hGrc/PUZSoT1xELoqmjSMSjDgs39K4ZwvvBZqRwS52kEbTPmoRxri/D6R9cmD/mKljza8qg6X56qqP4LqonSH0j9CTp2jJuimGSjeg3nE7OcrAD3ftVovn5QznVOGMB/WodFxdYohT7xHKlsJcjHfKbDI8N1Y3MwnLtd5KRJ4ACiLVssQsV0kbHYbHhGj+73DLifzGtm12MfZBDYa7UCP1AfS6UmG+SfiRUJV+2xYVWRUjBP8Jdln4naS8ZEqJ8xBEJv4qpwZF2OqyXw2AuZf3nhV5Gj22WV5mx6o14uR61kP6pBWCKD6TNkSq2AG1fAPdv3uAtK6K8ywt/1Lqp5BevtjGjIPrZIPuwyJnWwMYD70m75WzUlSRMzzrubzF89M6vC7fO+Qs0pRD1d8XW0cRJtuewiBmO1yMo4bfpMt60SeA45KGFqxgIf9Tfw5PzCXlo79cLTyJuEKDIM0NzGMzZruJfmY40JSyrd1lnAas6lr7U1B3xGwAke44DZmqLKtAxWMC+1EaUTZgqZ84c
 bEGPQsEu
 CinxjJlnk/Jo5d3Eje7rrT1vYxnC7XMbc+Sc4ZOLfkJE+a2a/fTwRlHDwCNq7H8Ik3mq2tEAs+asdaW4XbpW+QuslL8ZIQKR5aMQt6kD1a3PbZpHy5OuS9BWW3lHtxHLRFyiz+yGzaHluLEfznhxV+k5HHHhKEitAnhRbRmd99A/fdgW1puVsKrVON3BIJH98jTw0Z+Hmx5SXs0Z/FNpyH3xQXeZLHEITn09K91UD7zj4HKguIJU/+yBSRDUWkoRJUIBKQJQCfMnnohpldYH/KZZm00vHDY39YnII7tJBsiIJXFSjvoUJQWov7CodNccZRq4qb7FcEj35oQc1k581I7u0SR/lm30dBCbpIuHtbdXaJ98yTAi9FI/jog6Iv2xTBRydmCupbLK2QRzkFqtWSuEMvH23XQx+lhgeEf9HRXND0ckQwwtVXT/dsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 18-03-26 17:03:53, Daniil Tatianin wrote:
> 
> On 3/18/26 2:47 PM, Michal Hocko wrote:
> > On Wed 18-03-26 13:08:31, Daniil Tatianin wrote:
> > > On 3/18/26 1:01 PM, Michal Hocko wrote:
> > > > On Wed 18-03-26 12:25:17, Daniil Tatianin wrote:
> > > > > On 3/18/26 12:20 PM, Michal Hocko wrote:
> > > > [...]
> > > > > > Shouldn't those use mlock?
> > > > > Absolutely, mlock is required to mark a folio as unevictable. Note that
> > > > > unevictable folios are still
> > > > > perfectly eligible for compaction. This new property makes it so a cgroup
> > > > > can say whether its
> > > > > unevictable pages should be compacted (same as the global
> > > > > compact_unevictable_allowed sysctl).
> > > > If the mlock is already used then why do we need a per memcg control as
> > > > well? Do we have different classes of mlocked pages some with acceptable
> > > > compaction while others without?
> > OK, I have misread the intention and this is exactly focused at mlock
> > rather than general protection of all memcg charged memory. Now
> > 
> > > The way it works is mlock(2) only prevents pages from being evicted
> > > from the page cache by setting unevictable | mlocked flags on the
> > > page. Such pages, however, are still allowed for compaction by
> > > default, unless /proc/sys/vm/compact_unevictable_allowed is set to 0.
> > > That property essentially "promotes" ALL such (unevictable) pages to a
> > > new synthetic tier by making compaction skip them. The per-cgroup
> > > property works similarly, however, it allows the scope to be much
> > > smaller: from a global setting that promotes literally ALL unevictable
> > > (mlocked) pages to this tier, to only promoting pages belonging to the
> > > cgroup that has memory.compact_unevictable_allowed as 0.
> > This is clear but what is not really clear to me is whether this is
> > worth having as mlock workloads are already quite specific, the amount
> > of mlocked memory shouldn't really consume huge portion of the memory so
> > you still need to have a solid usecase where such a micro management
> > really is worth it. In other words why a global
> > compact_unevictable_allowed is not sufficient.
> 
> In my opinion both mlocked memory and non-compactible memory have the right
> to
> co-exist on the same host without a global switch that turns one into the
> other. I agree
> that it's not a super common thing, but I still think it can be beneficial.
> 
> Some examples include but not limited to: security: so that sensitive data
> is never swapped
> to disk yet we have no problem if it gets compacted and the actual physical
> page gets replaced,
> performance for some apps: so that we can e.g. memlock a large binary in
> memory to keep it in
> page cache and improve startup time, but again don't care much if the actual
> backing pages are
> replaced via compaction.
> 
> On the other hand, some critically important/real time applications do need
> protection from compaction
> as well on top of the regular mlock, so that they have predictable latency
> and response time, which can
> really fluctuate during heavy compaction. Both of these cases can coexist on
> the same physical machine.

This is a very weak justification for adding a user API.
NAK to this.

-- 
Michal Hocko
SUSE Labs

