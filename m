Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E58C0C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93DA6B018E; Tue, 18 Aug 2026 12:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43966B018F; Tue, 18 Aug 2026 12:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34686B0190; Tue, 18 Aug 2026 12:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA31D6B018E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:43:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3ADF1401B4
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:43:54 +0000 (UTC)
X-FDA: 85114961988.12.3EA5977
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 614FF10000B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:43:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Fh60n490;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787071432;
	b=rmaRv1DzgbXdku6hBSM/bJcU/lZmPrcIah2z+Bjq63GnXGo92kMgVGNGBgmnR4Ay5xT5Ua
	jSJztw6yK3oW9GOgqZaaAT2Z1QPxC47wc6kg08l41H7wgUgX6vGTzNPJdn9lczoxr3HuS8
	0Xw4w3BRTCvGzrJBssmc3ubyzeHn8K0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Fh60n490;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787071432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSPw/8r8Y7BIh1YcWJP4P9upFW6BW+TUQ3tuOxC68Hc=;
	b=uLkdTlWNHZDAhvM43T9IsQ4qEaEUjHJcjcsQ7MM4jCZ0dc76wJ2VcSoAZFz0toz052MdRe
	ycBn36v9LPLAZ30r6TElTXdQ8yZ36SkWDWZIktIXMuDl04vo2e06amorqNIHhgSbOsuAMY
	vTOzFeuTd8M5byyZP2iumidUG2/3two=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-496bb7cdf51so574535e9.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787071431; x=1787676231; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hSPw/8r8Y7BIh1YcWJP4P9upFW6BW+TUQ3tuOxC68Hc=;
        b=Fh60n490pUwirWd/SjPB+9cKDQhZRV3yARez/EB07ceMMbC8+yU8B4P+3sV9LqFt0H
         34KW695FwKMVnAs+qm52geN5gz3XFoIv9plHpniFJG3sug9FxF5/s6Fd5hz3qt1sD4At
         6RM7T8XODghg1WPOwRyEtrP9YrgN+dVWmsDYM/vfXRgr7qOuwFQm6Qwu+AsI+hIH9oO7
         WQrLnX5roMVqcDO+/wbGFaIZ76Z6LhPkY6P+nLttFfB04fakfY7SQZoIA4yn13nJnXW/
         3WLt95YTlDuibbo06B19AWYaQQrq/S+H0TDTcOTDmv9CUvRsgRC1CYyCXT2Zt6PwHd7+
         Tjvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787071431; x=1787676231;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hSPw/8r8Y7BIh1YcWJP4P9upFW6BW+TUQ3tuOxC68Hc=;
        b=PAMbHRcb8DiDSN6pT63Lz2yVh2mHe1eOAKPolORWoVBCapvGLdHjNo98zXUWtq7db3
         HQR0LzsTNn6jBv8GN22gqdkT0F8uxCDuy1s2dmJisx6Nv+EbQCnBJBcAKtdTVl6zKmQp
         H+KXJIGxFs68cumvz+J++Vr+1oA8zLBm1D3inl2BrxsaM9JLC37HTL4H66X4bxPOrpjq
         wI5BEb3GFKPvyJWm9f/8UBTnNg8lnuDF5u7mDbfhga0Mrt1lnL1OBCez9kf2q7n7Ce5d
         kp3hadh/6lIlejkuyq+XjKWdNV11301zxAqPL+gIMUBZPrQ8HQ4sBxFs4myHV/+2wzF4
         Jb8Q==
X-Forwarded-Encrypted: i=1; AHgh+RqeHxIvHrO4yO9OcvUUEhFK9Nsac2JRitEPgDD3a737hx3QGJhHGgNzcajjWusyJRsillScD4zJPw==@kvack.org
X-Gm-Message-State: AOJu0Yzw26F+Sl35ksGJlXAwRcFuoWMX3sQVXjRnRqDMvjokOv5usoXI
	AMQHRLPXY8HHBFeT7ZPWzidiicwVN8D4g9uoHyn7jfbqu32FDFOIaxSV1rXMeh4aoGs=
X-Gm-Gg: AR+sD11Bydnx2MKrdf33hvJprUp/cSN19lpFjsEnXezEsER07HN66WADSe7uYQisVHS
	kwXdb4EzMuDtgJWzPOKSgghhgpuYLjAp7RrGIgpi8gB3b2J494ve93ody826R4UApHYv5SNfE7S
	9XT48oQqQB6iVylKxmmDGm/TCupJo1B87JE9JTA01Glg/2il43rvdw40+F2LXHVLutLFsIBWWud
	ajDab3U/mFzjcqgC0JpEqy/9M1RNZ+FX5B6f6pVzUAs7J5wkwhWYBQwzg5VZCrcbwHMv3t9/9ap
	zzMmd4hrYc/7w38M9c3BeHQqO1YIZ5jkJZ86jAAnxU5fk6vyFmC6IM/ryl/Nr71anP8oqZg7ktK
	shqeVBlFu5V2fOAYAtrk/wKnIDJ6vAiyjbevdi/2E4miGn0Givo2bpVK9JK/uIxWb0thDWDqYhf
	2e9spz8p/dnVDyoZk3PAQkNxg9Uqh9ncRaINbu4r1OgVtrgbGUy0xYsE1spe+f9ulLzBnTtIwcK
	Q==
X-Received: by 2002:a05:600c:528d:b0:499:48be:3189 with SMTP id 5b1f17b1804b1-4999fa84b7dmr197625135e9.0.1787071431027;
        Tue, 18 Aug 2026 09:43:51 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996176b8asm225801765e9.11.2026.08.18.09.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 09:43:50 -0700 (PDT)
Date: Tue, 18 Aug 2026 18:43:49 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-ID: <aoSLxSBUPbEqimJq@tiehlicka>
References: <20260817042652.74136-1-cui.tao@linux.dev>
 <aoMzchLCCz5hiFHp@linux.dev>
 <aoQNtIRvqXRh-x4u@tiehlicka>
 <aoRz72_zdMai_RNV@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoRz72_zdMai_RNV@linux.dev>
X-Rspamd-Queue-Id: 614FF10000B
X-Rspam-User: 
X-Stat-Signature: 6pxa6fisahmubqq4tw9i133dub83uxrg
X-Rspamd-Server: rspam06
X-HE-Tag: 1787071432-78405
X-HE-Meta: U2FsdGVkX1+MDZ6yc6As806DHBrfeQCog89i3b6UirWZ/V7TLiedu3YvSG8UvLHiT340RvUwl+7qIgu7viXpRRGkfEzmJwI4ALw5hH1c+lKFzu5tGXJ5TB+tqLGYbbYEF8FkC6zggidqbtyqJr3Y3wo9sVO1FKoccvefoKe3uCjaS3Cholm3oXOFEDcHlztS/vluFCQLDdiFOJl5c0PelLMGuUArYt5YBb4fC9NKxzVynKWuc9NhdnPEwG6fh7tWCSLH5QnUx66aMmA8kTAOwKMqavi2X3apR1TGNc5UAD2w+QqJeCskXPP6mm5jpNkyFWwZ+9azIWYDQrsR37fM695tbr77Aewihyu/FPVe/ne1kzYPTWuY3unUY4ZOt1eYxQ2UdPArbpOZTzN5iwAuij/VEd8vWtp+WyBqEFZi0Hh/Q8lRIUDufsJhqJP13RHrDlvCSzaNz01082efnc2s+DfUhLJaEqp2p8uYBnB6CIFlzHdUcRmZ+Digs6E2NJl36a/9Bj1u5G6hb2Dp7ffoNxCpTxl6Nx3qiHnkORVzIt2zzrTwRN335LhclKfq7zGay9FGfPmZVoMRq6NqeAXZindqitz5eNR009aRQhYaLRuceazbMDlDVS3SZ2EoI7juPzJ0qU1sofrGRdWgQvmxaeGggh1KTHqfpFFTxEDoHtltzdmVCOV+6CG8rsy/oYRmdlJL7rCdw85ejUPFh+zLxkPx+GUm1c97uGzt6I5xpkdpgMg/6Kjso6zjjAsUzTlQsutWtwYD8vrBfS2i36XxGfXMUyZRO/J0Yf1vmtyBw0i1PlwkpeVGYAwiyqo/PMX9eXdULhAb8E0je1TcIZ+ipfZ11zypZBgwdn5k9y8dcQ7Ezhnjy0bGXLoxI4N8ZfV/xdd7DrOIwJAEAXhz6X0dLt2b60s32kfHevLt/3MDiQdpbia0j/BaeBZ71uVrE7bIqrSe5PvWLmHtQsDT6f7
 ZmP523cI
 0r5v+H8eMWG0OfeBIWKZnc5SX8HwvsAPiI51vd+4+zF0ALF104GQ3AYkqMiOIwYQWvf9bwlnR1If+VrcoZpgs+pCw2YbUO6vHXkWwimDYr+r7N61U5p4BwUHuCIxkpMKR27sU/Fds/61MCorcrpCUq+W6d6wdrGXPas8439IC/58Jhh1CsfgRx/bYPIv3ijPIfGbnGi1ROh5e7Y0JjwyTKeG7IOCKtOHo91lQOV9oJ4TfMU83/k/N1bdTV0h12XOSMv6oxIPwM9j0G6yXGxKazlJT+ThcE1+tDQcdZdxI7TqhkzZEoZUnGftX3aAkyhpYhcMSX8xztulKZ60eJCUVwJlMOuQIVngPy5s5NQqnGHrtrIrzsO6DbVrpzYjbWwFrMvOof1Po+9iTDJpwhw2eeo3w1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 18-08-26 08:06:22, Shakeel Butt wrote:
> On Tue, Aug 18, 2026 at 09:45:56AM +0200, Michal Hocko wrote:
> > On Mon 17-08-26 09:16:40, Shakeel Butt wrote:
> > > On Mon, Aug 17, 2026 at 12:26:52PM +0800, Tao Cui wrote:
> > > > From: Tao Cui <cuitao@kylinos.cn>
> > > > 
> > > > memparse() consumes no characters on an empty input and leaves the
> > > > end pointer at the terminating NUL.  The only validation in
> > > > page_counter_memparse() checks for trailing characters, so an empty
> > > > input slips through and the limit becomes 0.
> > > > 
> > > > All limit write callbacks of the memory controller strstrip() the
> > > > input before calling this helper, so a script that writes an unset
> > > > variable hits this path:
> > > > 
> > > >   LIMIT=
> > > >   echo "$LIMIT" > $CG/memory.max
> > > >   echo $?
> > > >   0
> > > >   cat $CG/memory.max
> > > >   0
> > > > 
> > > > Nothing reports the mistake: the limit is now 0 and the OOM killer
> > > > goes after every task in the cgroup.  The same happens for
> > > > memory.min, memory.low, memory.high, memory.swap.high,
> > > > memory.swap.max and memory.zswap.max, where 0 silently removes the
> > > > protection or disables swap and zswap.
> > > > 
> > > > Reject the input when no characters were consumed, which is the one
> > > > case the trailing-character check cannot catch.
> > > > 
> > > > Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
> > > > Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> > > > ---
> > > >  mm/page_counter.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/mm/page_counter.c b/mm/page_counter.c
> > > > index 661e0f2a5127..d14db705b04f 100644
> > > > --- a/mm/page_counter.c
> > > > +++ b/mm/page_counter.c
> > > > @@ -281,7 +281,7 @@ int page_counter_memparse(const char *buf, const char *max,
> > > >  	}
> > > >  
> > > >  	bytes = memparse(buf, &end);
> > > > -	if (*end != '\0')
> > > > +	if (*end != '\0' || end == buf)
> > > >  		return -EINVAL;
> > > 
> > > I wonder if someone started depending on this behavior. In that case it is
> > > better to return error instead of silently ignore, so we will hear complains
> > > loudly. This looks good to me.
> > 
> > This is backward incompatible change and I am wondering why should we
> > even risk regression.
> 
> Mainly I was wondering if this is intentional or unintentional. If this us
> unintentional, can we fix it without anyone noticing?

My guess would be this was just omission. Those happen and over years we
have learned that userspace is quite creative at using those.

> However if we are ok with this then let's make is formal and make this a
> documented behavior. I don't have any strong opinion either way but I think you
> are saying it safer to just assume this is intentional. Fine with me.

My main question is why should we even bother to change this in the
first place? Is that reason stronger than a theoretical breakage of
userspace that we might learn much later?
-- 
Michal Hocko
SUSE Labs

