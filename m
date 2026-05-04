Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F1CDFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 07:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6A26B0005; Mon,  4 May 2026 03:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3696B008A; Mon,  4 May 2026 03:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4426B008C; Mon,  4 May 2026 03:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5A26B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:51:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF12A4036B
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:51:40 +0000 (UTC)
X-FDA: 84728967960.16.7F4DC07
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0C5908000F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:51:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BwFUlcLo;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777881099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bm3fGVRDJmvzKcGf6LzNIYgcMVEhDfTh7xuJQzaCqRs=;
	b=0GDZ/PSAeDVc5yXI9iWm9WOwZtlPSOvDakMrX6n272s2yNzNtu2umcM5iij6q2QgGuloCB
	1qfl/CwcQ7/LpiAkhauIuMYwenJ2OtRhXUvWBX+ZGW+40XmC11rXN4SCeyWdJbd44Nb9g5
	0At6reW209OzCpolhIj0tWcP8Za1jfY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BwFUlcLo;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777881099; a=rsa-sha256;
	cv=none;
	b=X0/v71nGqew/YyWf9sFTSIfM9DBX8TlHRgcBh6DLhs9UH89OraCefMzALqGNRtaSurHm0l
	HyvAStgLd6MbTm5KLzLmypLJfAvl8aZnD6etvA+UmBRZb5pEBDLy6qPoyoFQcQTC+QxmwD
	SGaynZL5rsj8IHmIg5wcFkD6CCtEu1Q=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4896c22fcbaso26568335e9.0
        for <linux-mm@kvack.org>; Mon, 04 May 2026 00:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777881097; x=1778485897; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bm3fGVRDJmvzKcGf6LzNIYgcMVEhDfTh7xuJQzaCqRs=;
        b=BwFUlcLoC+oQbf5Sdsth0zkyZw4jXyMUwdPuKR5DdHNSuv4Hl3sYZPMEBJudI8yOO4
         AVhuWOHs8Osinbm6es5R4WIjjC0QsQ4rdUb7Zt/z9fCta6/xIl7YlpMWz9Da7fNdsAYb
         F53IEHMEXO4iE+tAGRA6mzWncfl1xK3Kzyus8EznUdZE8jM8umeFqpw5cVQBvBW9pEmr
         69jP9/3hCiHbLXo5aj7TLY06XUoYRo3j/nrgeja207MaCK4rPWTMM+2387Fg2L7iwZ4X
         7CebonAaPzWoYiWTRGnyQVnQfZarYpYGzaHJ5kInHwynD0OAlSHZLG7cuI36Im8Xrnpc
         8Hkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777881097; x=1778485897;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bm3fGVRDJmvzKcGf6LzNIYgcMVEhDfTh7xuJQzaCqRs=;
        b=eGwkv9HP4y5RlJZKwjXVLcZhXVUbjjaLR5IoKpJ/lZJiLSdlQlE1xL+m3xpvdS9uqr
         UNNlV6Fd0Ic8zCtlVuIlORjsbF6sVEuFK6dcjnFjBscbF6zBQj511s8oCX9ae04mgRA/
         8YYKoq8SijSPeRzQPw6G+0fzvHAHeJUw8xvN90ruFT6CIqXGJ0T1zY1hc0O0PlwDmIkq
         7/2jShyqiul3oB6DdxydPL+4e/ATPbY2hrGkabOjvkZTqomFlrkXiQeqPz67sojyprIb
         xm1OWepx/yJ0tncihEnQ9kJhDI5eOkwrU6SD6VuAs9YZd+4IaHWUAoKvPbxc7BCd1ubw
         vVow==
X-Forwarded-Encrypted: i=1; AFNElJ/H0qI9ppcuavUPT7D+sG8SvifgX6b3CaYOE0N6BVK6mVaNEdJsrhzkAz2kzf5Kf6pSgAoa0gE05A==@kvack.org
X-Gm-Message-State: AOJu0YwclmzO22kNj7IcUrhsasUjVrF9Y0MOjtRQidOyEC6c5uSw69in
	Utyyng0Y6nruAkjHpB7HN3Zu6iRM7BlwchYNGiDA55obo3HpgIvHeHp1Z/JMQskPuss=
X-Gm-Gg: AeBDievSpA1h06JQoCsySpXHREiE88Vo9ezo66IBTCHimQUPJt08z+v6boeMxdnSRNi
	uIPf8ZaER4M4WY+cBQDGcqwZStFLAcNChQlHXZGkobYXA2fZbu1yj3ZzDy+lr8U/tzB7bNvljBH
	+scyOE3AmJbhi+9ICvBTt9jc94kh3BwwaEiU44zYxRhG2c/AfVh4p+WAhGzs3AZ8nPKH265uXwG
	21+T25aGsyfW9AMP1FoFTVeipvW+nzJB/5xWoIW8qrx1osqiVfQx5s6xNIyMN+mZsohh6RGSeWD
	I4kbTl3pwcWuq7UZUp+ZzprTJ5x0tYfhP3eB1CfL9obZaDiNCRhQjDHVgsyoLcwt16aNOG7ITAd
	/rlzYOi4Ed7TR9+JBeYyRkkq3ZqszxjsNKsV1kFSG1/6nDbPSHlPKYLfP93hkmrRV+1QLFYcWzf
	GXtOXhyKgLQ9mFhs4wARrY+h2xwnA65s1nQvqfcwaf879oItc=
X-Received: by 2002:a05:600c:a302:b0:48a:568f:ae8a with SMTP id 5b1f17b1804b1-48a98638a65mr96686225e9.8.1777881097362;
        Mon, 04 May 2026 00:51:37 -0700 (PDT)
Received: from localhost (109-81-23-170.rct.o2.cz. [109.81.23.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8eb694fcsm271098285e9.3.2026.05.04.00.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 00:51:36 -0700 (PDT)
Date: Mon, 4 May 2026 09:51:35 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <afhQB0CWEcflXpOi@tiehlicka>
References: <20260429211359.3829683-1-minchan@kernel.org>
 <afMnKrYT0xG_a-b3@tiehlicka>
 <afUYfpwWsUQoB9hz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afUYfpwWsUQoB9hz@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C5908000F
X-Rspamd-Server: rspam06
X-Stat-Signature: f4s16jmnip3j1r6ojebmdywmytakzhgt
X-HE-Tag: 1777881098-268137
X-HE-Meta: U2FsdGVkX1/Zj8dE8K3F2cKhLXtRzENCRxLyCkhjY/aYFVfu3qlKEtE7TQIL511OGbtZPpudmiY/LItScQDzvgxmKmyevmfJ6FBQF6rsuMuVsgVsVLZrhG5Robq7wXjlHgKeoXzjqZTCaN89wI+wc3L/l0ZGyDxivm9l7Kqd5OykeBV5EEMbpnI2LIzvU35wLChy/b6LbAV48+HOii/Wk9CNlhiCdgWhbwMHbQv3GAB3adb21xjoogJdUwP5ums0/w4YswjM8MNh3s49iCNhDmfUTF1RVWc0nszUYIE06S6LTpqADBmiY7gsY13G8KcZQMCNNio1M1iQ3D19CKfjY10xXGmRjMBFfGnro3hGqBfXnJexJWW0V3T8UfQM7ZmQtGmVm8hiMq55OWXyCXGZKCEDhkgHcawB8CAh9R6tbx+xzgs842SCjbir6jImeezHAQgq3iSKK/tnGhgrr/r6zMAf9RDL/OUnSVhW6k83aBsUKJ5vZ6fjUxoxoOqrMrg6MaMyw3zJRyNzDU7HbZ7ylSJdLqmzVPkQcl56vYeqST0abEj6RYNi3zrTx2udaGGfNRSG0UD5wn6cLQa5rlgYz+A9fvxe8w5RZ2IbUMTNSGnx/4+eu3k6JxWsrQ1VoMNu+ochPg4bQGkLWPmzUylpyaaVNg3wGr2ka1XxTkd+B8itTrfnyvX1GOAaaWm1wiuLgAySxrHzuqvbFPcYrLFt02eS8SQaIucwuoCDUv1bdD69F6m2JZisyO25PwpoCoCWH0oXRvUleTnPFGFYgXt1Yhs8E6OdE1YBbW+HuJ7oTOjSVd1EV7lSifY737ZxwDglYGpsVm0QURv1z0TTSTeqcIcvnN33hn/gX5EyExDd493OLbfU/RF3TQUoabMFwjyX0eQxQE2GaTwUoj+cVkwCRL3ZgVMqXmpFYW2TjF9jEPGK/1NNC4buMxqR78eKduLnCo62SWBeXuCKNjK5hKG
 CxsbT6oq
 HPyUrlBFIFmWHjEczwuSeV8syjVqwxTNPsOIjx9NiW8K++DNecCq0CQCO76BRuACYfpMO81u15YavUnp5TghgMtfeyvJDXWgbYh7klfL8+uNggU+yv8kl93KVsUKUlncE0MJOdsPxARBob1V8+Rdig9omE7by++qrMPa0ycM0Rul43Q4kO6bnLgDindzug+H0whwpgzisFjzOYqU8MPsQPsvbWUIIlhWxKfi+57S+8w//VBS5yhQo7V3yT7ObiHW3shsTIUaSdwTlwK2E+yCFs9opReP8o/tOyH7vw7oJcfVSF/blHRn6pCdulGiuvCuWDkUs8UqSdA16AwcIQNDYflJyucA7L2sWYFxDfJIk68DG9bZOJZKI0EEp+tVgUZDTMLLh23tul0neqMpCzmHV1eEF63YhjQphXDH7zKtdi9ZPrbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 01-05-26 14:17:50, Minchan Kim wrote:
> On Thu, Apr 30, 2026 at 11:55:54AM +0200, Michal Hocko wrote:
> > On Wed 29-04-26 14:13:59, Minchan Kim wrote:
> > > This policy differs from the global OOM killer, which kills all processes
> > > sharing the same mm to guarantee memory reclamation at all costs (preventing
> > > system hangs).
> > 
> > Incorrect, we do the same for memcg OOM killer as well. This is not
> > about preventing system hands. But rather to 
> > 
> > > However, process_mrelease() is invoked by userspace policy.
> > > If it fails due to sharing, userspace can simply adapt and select another
> > > victim process (such as another background app in Android case) to release
> > > memory. We do not need to force success or affect processes that were not
> > > targeted.
> > 
> > This is a wrong justification for the proposed semantic. You seem to be
> > assuming this is just fine rather than this would be problematic for
> > reasons a), b) and c). If there are no strong reasons _against_
> > following the global policy then we should stick with it. There are very
> > good reasons why we are doing that on the global level.
> > 
> > If for no other reasons then the proposed semantic severly criples the
> > shared MM case. You are left with a racy kill and call process_mrelease
> > approach. You certainly do not want to allow a simple way for tasks to
> > evade your LMK, do you? So just choose something else is a very bad
> > approach.
> > 
> > So unless you are aware of a specific reason(s) where collective kill is a
> > clearly an incorrect behavior then I believe the proper way is to kill
> > all processes sharing the mm (unless you are crossing any security
> > boundary when doing that).
> 
> I agree that in the case of a global or memcg OOM, the kernel deals with an
> emergency, system-wide crisis where killing all sibling processes sharing
> the same mm is an absolute necessity for system survival, bypassing
> user-space privilege screening.

You are misinterpreting or missing my point. I am not suggesting to
cross privilege boundaries. The syscall should fail if the mm is shared
with tasks the caller cannot kill (same as it does now).

> However, process_mrelease() is an explicit user-space initiated system call,
> and I am still hesitant to place that same raw, destructive policy blindly
> at the UAPI syscall level even though I don't know of any known security
> issues right now.

This is very wrong argument to introduce a potentially crippled syscall
semantic.
 
> If we really want to go that way for the collective kill, at least, we should
> evaluate signal authorization (kill permission) against *every single*
> sibling process beforehand instead of only the target task of
> process_mrelease. Do you agree?

This is what I've proposed already.

> Also, I wonder what the signal/process maintainer thinks about this approach.
> Christian Brauner <brauner@kernel.org>?

Yes, this makes sense. There might be a very good reason why we might
not want to introduce a way to kill cross thread groups when they share
mm from userspace. I do not see any as long as you keep the proper
permissions for all affected tasks. Maybe we cannot do that sanely now.
But these reasons have to be properly documented. You whole argument
that this is different from in-kernel oom killing is just not valid.
-- 
Michal Hocko
SUSE Labs

