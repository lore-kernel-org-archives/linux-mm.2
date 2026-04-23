Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79370F99344
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 07:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0006B0005; Thu, 23 Apr 2026 03:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881026B008A; Thu, 23 Apr 2026 03:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7965F6B008C; Thu, 23 Apr 2026 03:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CEC06B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:50:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E686616049A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:50:52 +0000 (UTC)
X-FDA: 84689049144.04.7F98987
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0954740014
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:50:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PGndrYY7;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776930651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAQn0n2o5JV9MpfW+watOd1u204lA4QQnaZqSDSP20g=;
	b=KEU8tmfZ9OUoMNbu/rQjH60XdhlNTPf+g3q84L2P29s+VesID46QEI+/7kKKDtKysUs7cb
	cVQAmZeIj2gKAAbNLQoff9JaJyAucisD82ymjfGxYyiyBNmEjjnjrlT5SxLyfXhiR6TSWX
	iBlIthYsmhIrUsF6OrmPPFQ1zTd9u/I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PGndrYY7;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776930651; a=rsa-sha256;
	cv=none;
	b=xQy+tD0hYOWX5NKcanUV9kI6O7HrqNVQIaxAVUudoftEnUxfRpNaGKgavW9zG/FeitJQkX
	jyUhHU5IDcCvb4SxLDwVSIIXVsS+L8WHQ2/MnUCAp2cuL+zH8xyRBd/9+h/I7ouzuT3Az9
	Oyl4LQZVRBFHA6TtvG3vuxL7yNRIVB0=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso43349015e9.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776930649; x=1777535449; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hAQn0n2o5JV9MpfW+watOd1u204lA4QQnaZqSDSP20g=;
        b=PGndrYY7VV440Hzh8IUQjNXEnUD/vavtbVlwnT1eQdqq4KXiy+vSlCbbQt0OIb+iFB
         pY+A4YEyzAf624+wiejOD4MEQTOh0WgXQiO4Tutfe0/wTjdvDd1H+q0B5gKBweZAJ1qs
         xqF34DVyuzBmrnaNZxzpUbGcTzG7vFWAOdJXRlDZEHwn4siT7PLQYoRonxcdfoLJcSAB
         9gBDHXm8SWdXRBInGhj7lwPIsoOmIf5EOjebZhdi5W9OAr1XBJA8Yzq6AeWHQp7t1WtG
         BPjbN76dXtYxnxq9Hr0+WbpUsY01gezsJaze0azkkRZXAEEYhOmJaS2MIZvjemqt1oUv
         Nu9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776930649; x=1777535449;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hAQn0n2o5JV9MpfW+watOd1u204lA4QQnaZqSDSP20g=;
        b=bxogPypxCpQ5kyO7Z0MSz1DDi0Ijp0e5Dj2HKwBxYE15OamjEALDmmsj1nsm9dScE2
         V+OD91TfNpCEowH78spWcKwvHsF9kyPf6bwpUZSy2/f+sthkKMwGWhHaVqzcvGnPpLlW
         HAFqQc0+et5S69DV/UYFVONyDgzQHQI/aNIJqY2YQyk2hm4ZuRRd5EcWNtTXgEOLYGCi
         H4+deBJKa7LUdmouKaBkd86pKNa1E0D9mQ0hDnv7gthhh8LKw58XYLboI8DrWrgdfhzM
         GTdboRbjGSDApue+dIhBxoqMIleCHzqkFNdJLsd0E9mmxqn9/DkckRZRV1YTTDJxPuQ4
         s5Pg==
X-Forwarded-Encrypted: i=1; AFNElJ8uEMRpFDIcQawgtxYvfFBYQUBM0qqpO7kzqvsGfGRB4yec8Wc3JpOv2XywgCaqiTbz1aKgBwPzfA==@kvack.org
X-Gm-Message-State: AOJu0YzyQgBffJSPyW/pW2A3lKkHGpPvZfvMLQKUkhOR60DqQHOa/wkv
	2B+1VtnqBO12CP/EqAkZtoFTQ7WHR9ngKyI2Bhu8Chf9JD5eZ1M0bIOGaevoZpO89EY=
X-Gm-Gg: AeBDietU+VKgq1BfVB0tBY1tQ9XwhRzkhHWiJoHPcFov8JqtnWTpKTZki1Bf6Q+v70r
	EXR5OzyNcUg+56vR/XGxOI7X5cwcV88bXKprdlzySz8cvo4PSNsX+YDZXsXSLv65NoV6xEL9/sK
	VALGkgHk/GZyZLLM5zv1J1LYRgvzR8HCnyDqfpY5kIYY3NhdVvFCMiR7cARROjmcVmwqC+ZbZCi
	qdyAMsz4tZOzrNdZjI4KN9qjYcGxAGtP/8nAuQJ2AJO4z+lMFAquzOQXMEb6yZpgG2zuEh7HkYD
	p4LYWlh2dp70ii2BjvheGkB4iwTYESfewz2GzWyGijUSpcQwCMcAMyaNXTcK1O6M/x8+Wr4SwSO
	nDb1gSQt4ijl9b7448LL/mxjPfBRwUlhnNlBfneUT8C3R2JWAZVlBc/Zhv7M2kq7cYUyVCvTnYx
	QTZV15oYcm6d73fq09mJrrbBZn48H42SGPbREwAGlv57xkTVY=
X-Received: by 2002:a05:600c:a30a:b0:48a:581c:ead with SMTP id 5b1f17b1804b1-48a581c113cmr101243955e9.10.1776930649398;
        Thu, 23 Apr 2026 00:50:49 -0700 (PDT)
Received: from localhost (109-81-17-171.rct.o2.cz. [109.81.17.171])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc0f82bbsm859823795e9.3.2026.04.23.00.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 00:50:48 -0700 (PDT)
Date: Thu, 23 Apr 2026 09:50:47 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [RFC 0/3]  mm: process_mrelease: expedited reclaim and auto-kill
 support
Message-ID: <aenPV9ewKAzRF2Vg@tiehlicka>
References: <20260413223948.556351-1-minchan@kernel.org>
 <ad3ldU4DZxga_J2L@tiehlicka>
 <ad6c0DN7AGoOQ_Iq@google.com>
 <ad9AXVYxWCkHmh6J@tiehlicka>
 <aeAeqoJ_acUAza8D@google.com>
 <aeCHvYOKP1exBBns@tiehlicka>
 <aeHRLv834FCAQlQ8@google.com>
 <aeHdGf7XDjvOES1V@tiehlicka>
 <aeagUxlju40rvkYQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeagUxlju40rvkYQ@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0954740014
X-Stat-Signature: fmxgk7ib4rxd5h4bkuauudyypezeypwd
X-Rspam-User: 
X-HE-Tag: 1776930650-610416
X-HE-Meta: U2FsdGVkX1+W0LWARtaBdCOWfD4AIggj6/Hf0RH+DOf/tEVGEqV0N0IbFQDm+ArpP5XpTvsN4L8uQlcomRzVRUumtNU9eUjqiWdrlIHNODa1DVd/OFGTH89/sd6p7eyNSWyZdj8QK/OwqsSKWwweKCtK7CDium2MfLLsMCpArbtw1tePedANgtfpfV61pBMVhQ3rOtVPfHFQPQrV3A3u8ulsz7QSZTeDnuYLatoKHgpvkV9vC/P7yYeoFMrxhuzyD3Za1Wyl1uVmhPtu9s0ysuDMTUoQvZv1M4jS1uIB5Gq4nHrHrNi2PvijWTbqQT6vffJ5dvH86MUib063yKvRmEh5ZNwL69zyPMZ/ftmfgpKa+8Dw82lqJONAb0+g58ldTaK452BYk9VbxZWiPXrUDK6hPlbKrnB3+nMtAILu7pliWajAAi+5jSCfia1fOaBfQv84twR+ozSWSXsblSKOizyctaWr+jtdNE33w/goKSeLo4d+H7tZI8MJ2nmJ3AB8GhXNRU4ssL9r9vWwapH5Ve5KR1UMmRYNz9FK+VTnjHLySqbEjBGIX6WiZcG27UFABpFswApOdw7J2FuWrrg2+iYvNdvIIsDNXcujHeS+JVqJSqEoYzE3lmIinceZ9Ox1uncILD6Z5XG8wsUK/uwbvH95pI903DLfY2AZPIBz+CPmFm8brZn4r416rX005efhAjuZV3bS7+uf+XLut82RUzMcNHJDW3hGR+gW5DKeorDbqLh8pYuO1cb55rtwmzr2Tyy2trnXXWYuz8CKu+/FFoUZ2UQACVanwx4MVnmqIGSYXh+EGymcl8mNc+qSuvAcf9uGr90kqmUImOdKkRfpjxmA9H657h6DX2f158VYSkppc80IGINJ1VC6nkl3vIY+8+X67R/kZg3/RAqPpICkCuQcXy9nlKa8846DekdMISDYg/H05+eyuqw2kmsyWAVspEuVlzSzaeq2Rqn544Y
 XZwjuNg2
 aKoGGaLmDim5YOKvhhhXkjtHU8G/8wEYOX6ovnW4w6WhuMFMx2Khs+iw1sR/DP75Okim1Oc0nzeoCX+pyhtzrQBK5Q5q3p2SH6DQVh9fwA62Bbg72dh3mxpym177YfkRUEjcz26Mz5rvKOSc95n4C0CaBnBUoDwltzzxRXymRtyslBz5rzocOxjCBHzZZOviI2cgpW79jelatZ9dkI4l0g1+4ohQjeSRnyifG0vwhbXrT8BUx96jzWWHENad/I/C0dH+wazfdqb7WJykf6TVTtkm4FquLEUF9/n8FbKkdp16aD/9j2xdqvmSgV6pXKqAVvwMsbCj8zANT+4kLFEed6lN8CUsoYa3HAAb+bGbmdscxLUdB9PqTbw0rwzOESoREn/H81ebQ3gW+dyaWCgolIH/678AGEb2iC2oyrhfhNt5hPxlctH1VfuF4nZgfRibnzXTdStSZEa7SHi+MBAX6OqLU/8alE8W0EHkKyV4AI6tmBI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 20-04-26 14:53:23, Minchan Kim wrote:
> On Fri, Apr 17, 2026 at 09:11:21AM +0200, Michal Hocko wrote:
[...]
> > Yes. All which make sense, really. I am still not convinced about the
> > clean page cache because that just seems like a hack to workaround wrong
> > userspace oom heuristics.
> 
> I see it a bit differently. When paltform decides to kill a process
> to free up memory, they want that memory back right away.
> 
> So it doesn't make much sense for the kernel to ignore that and leave the clean
> file pages to be picked up slowly by kswapd later.
> 
> In some aspects, you can think of LMKD as a more specialized, userspace version
> of kswapd. It has high-level knowledge of process priorities and knows exactly
> which process is safe to kill to get memory instantly. The kernel's kswapd,
> however, operates globally without this specific process-level awareness, which
> makes it less suited for this kind of targeted reclamation.
> 
> If we force LMKD to rely on the slower global kswapd to actually free the clean
> pages, it defeats the whole purpose of targeting a specific process.
> 
> So letting process_mrelease speed this up isn't a hack at all. It's just helping
> the kernel do what the admin wanted in the first place: fast, targeted memory.

This is a very creative/disruptive way to do a memory reclaim. From a
user POV I would much rather see clean page cache reclaimed before my
apps start to disappear. But this is obviously your call and your users
that will care.

Anyway, I still maintain my position. I do not think it is a good
idea to drop clean page cache as you do not know whether there are other
users. I am NOT NAKing this patch though but please make sure you have a
wider support for this idea before this gets merged. Also make sure that
all the above reasoning is part of the changelog if you want to get this
merged.

-- 
Michal Hocko
SUSE Labs

