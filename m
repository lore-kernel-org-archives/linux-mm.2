Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DEFACA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 02:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48B286B0088; Thu,  1 Oct 2026 22:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D0E6B008A; Thu,  1 Oct 2026 22:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32BCB6B008C; Thu,  1 Oct 2026 22:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 060CE6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 22:39:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73B7DA05E0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 02:39:02 +0000 (UTC)
X-FDA: 85276128924.13.C8FFF45
Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id A49D81C0004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 02:39:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FaKfVF4c;
	spf=pass (imf18.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790908740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0JwbUYYrULzWB47hYNIr342NMFY/RUwXnmibkziqko=;
	b=k+jUh5bbKdV9oFRBnvnRLheWH0Q4lWf1IPUTZgTvkJohSsqySmOBQcLAQ0e2BaJco1im+m
	UFDWdzcul2lKfOQF0mlQnZ78hGZgQqQXjXXDJubZ49337U0aHyt4IfxMpRKIJ0VkY6oGiS
	b4mzAh7PSTUPhOnQ7sZHGDjcB7Hykds=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FaKfVF4c;
	spf=pass (imf18.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790908740;
	b=CHnnI4ug+p8oLlquWKFruriM44rggC1Q3ebDgtKOSD7A/JBbRYBVJWpjlPTCqoA/5NZdQv
	3lkP6Hbd1c+LJolsX6stKSipN4F5+LisgsoDgpK3Eo01Kj2trG80Sf9iuETskHw2KGjmmw
	swBgEbJ1es46NZFIjBa0qS7n+cnRQN8=
Received: by mail-pj2-f41.google.com with SMTP id 98e67ed59e1d1-3a6e665bbeeso78245a91.1
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 19:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790908739; x=1791513539; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=W0JwbUYYrULzWB47hYNIr342NMFY/RUwXnmibkziqko=;
        b=FaKfVF4cXwwT8EryFi73f4qpreLlu5280n76NcTI4jUuvy3AHeDPMBDnAOKCAYD3IQ
         ZkeI2JkgULJNhpPe5QvD5PYLVdNSP22eRHPXb+0ecnm2o0ZUnGnWzKgt1nDnzI2xYr+t
         GO+fAwN2R2fshu15bQfF7c1qrOc5ei+fG5EnBMaMiiqBZqQWNwvsPlNlizIU5l+9z8nc
         dsYZGVQE892I44jOxfu+RYCWjFHqXNbV6PdrxYarwHAn/Kv87ab6cBJ4z5To2ezC5KFo
         CyX+OVnWGlmCjmpj1UFBRoCXrJ7aHBDVPkVkKTpECoJh9wlFYogWqMayLD/eLxCsyUVO
         181w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790908739; x=1791513539;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=W0JwbUYYrULzWB47hYNIr342NMFY/RUwXnmibkziqko=;
        b=1dzW2RHHF4Dh+xgiIKXP+2wlPU+mA/QJTsltuVi1TLb0oMxuM41AKyusamvGz8WEXi
         cIJeBFvKjwaLNsPyDFMnAEkNMUNUt7DQo4NhSw7j2Ry1Abx235vVb9QLMHkIz6ku2cDT
         y5yOKEJvl7j5fKsO25tNojDGh8Vk09TaoJJ5i4n2zeMwHn/e5kicv26DfjpokqbuW/8N
         9oY792BmgpdoYhKKrpRJbzyrQzhYgZ+Vx8gJ6JwcjuC+1QLcuIitROBYiZUgZnkdf7e/
         hVAmIso+TWr3bA4g6GBpU3xh7bWPW091EIIVHz7Y9jWZABdCwWW2lF1mQK5HrxTdjzXS
         xvBQ==
X-Forwarded-Encrypted: i=1; AKwUvBxN3CsNI4wPpElaWOQucYK+7cHKCxZOhAIsry9OsRM5s36dm+bOFEXeSLWTTHYpeQ1iwmiDaRG0YQ==@kvack.org
X-Gm-Message-State: AFq9FYIjmI3RgNkJXsz9mQFEYhJgxlc3V4kK5Ltd4h33QMp9BpDF7IER
	eywbnQH+ANNNOdgiXMb0mnQ5Xjb+ZLHDFm8teYvqkNS/JnymUM2z+PrS
X-Gm-Gg: AYBFou1Q//wtufK7QurcOFoJNDF3nq2CEUjxz1/qT+4R3/07oBQVsr6AItqheQPVn6G
	+Fm+v4AI6QZNQfJDCW9n1Fdgm//AgAzLL9QaPYmHPOEWvOoxMmV+2sASpmI+DL8qfklTU2aweP8
	ovKkabzIJ771NomSbK7I9vwSrdHPjBExHsDyjDbSe5u9DD80zZ6iQXBGVBRuh67SLPuZO+Je75+
	lkKxAA8HcKmOu31AdV8bLp72eYtp9KwPSfNXt/MyQsuj4gaiAcdqJUsXdV8kp3ukzs/1bQRKXuE
	Rj30qZV/51X4fXONgxLlHOmXb1re6jyNPqlkmij4i9pgM65YhX794o09qvRDiSh3MY9sKubgkAO
	1fy7241gJDHvnXa065ck9irDH2jRNFIjVKk7Mp6yGLxS+I+tcMg+EPJIZrsgNoMpJXaHDMb59dM
	Haiflt40perr7BL9EKcOw3tJvls5g9B363337nvt4uL3f/4OSXHpePU/2bX13jEFY23hOWjK+DK
	BQHpLqe93zORw9jmAYAEwXFeWiGCqHmqCYtHlXNHNr2F57MCCEv8wWFva4M4/5qQbEbJbVVgqY8
	ssApRMFf/pdfV9fmXNx9VwSPrUBCHAYcb5z8T5/jfoi67BfcLaYa
X-Received: by 2002:a17:90b:4ecc:b0:3a0:ca1d:b40b with SMTP id 98e67ed59e1d1-3a6cec84dffmr1148635a91.50.1790908739319;
        Thu, 01 Oct 2026 19:38:59 -0700 (PDT)
Received: from mars.local.gmail.com ([240a:61:8063:c5f3:3cbb:dbfe:34ef:b37e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4f46bc991sm6682074a91.4.2026.10.01.19.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 19:38:58 -0700 (PDT)
Date: Fri, 02 Oct 2026 11:38:51 +0900
Message-ID: <m2se2o3jyc.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: johannes@sipsolutions.net
Cc: ljs@kernel.org,
	david@kernel.org,
	linux-mm@kvack.org,
	liam@infradead.org,
	rbm@suse.com,
	akpm@linux-foundation.org,
	luto@amacapital.net,
	brendan.jackman@linux.dev,
	liuhangbin@gmail.com,
	corbet@lwn.net,
	kees@kernel.org,
	broonie@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	wad@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org,
	geert@linux-m68k.org,
	daniel@thingy.jp
Subject: Re: [PATCH v4 1/2] selftests: run tests on nommu architecture
In-Reply-To: <94759bed23f00d2044005e36be6f72f297e092f0.camel@sipsolutions.net>
References: <20260929235711.2287931-1-thehajime@gmail.com>
	<20260929235711.2287931-2-thehajime@gmail.com>
	<bda5eeaa-7868-4d4a-9026-9e99347afd7c@kernel.org>
	<ar4br2vW7yZGd3gt@gremlin>
	<94759bed23f00d2044005e36be6f72f297e092f0.camel@sipsolutions.net>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A49D81C0004
X-Rspam-User: 
X-Stat-Signature: 31aj9c3r9ep8ixrgzt975ukszyhneop7
X-HE-Tag: 1790908740-527297
X-HE-Meta: U2FsdGVkX1+8XrrGpm97c9xbbQQVSN6t0oaQiD6HZFXjxOD20ZAShEq9hx5qaIFVAkyEDK/FUqnB0roYk8HMpCbXkdOiHcQX/JL4TvRHV7mXWswrNVPX9lYTGd3dxY/dTlga6kMK9YmBnfl1WXyBZ2lF6VwvYMYJRDLkhkRHOZgk6zhgLbeZi63qz0GvleIxcilM8nLDFP5pY5gRHWeWC+s7hhnk1J/Ldu56FCIS3f0E4ItxBfqPACU65qtOWawk9adgiUraKXCzEC1fGvLQ3A9ET7wqdcMu5PWKkGpfGwuL4lNObR53KS8+mrzF6f47wBpaeooyAQ6FT78KI7tnR58Ho+pTUoiWY76pLmrYn4HRchZUq9jvvQH42K0p+lSoIAiBjIp/v1VRlyBq1p61n9UFFMcPDUosm1kka4ogHBBisdIq/PkidEpavx6ed0HKy7+Mpw4sPY6hOCJ+94RU9HaF8lGb2JWYCFXbyZpp0FRsx7qiFKwHWnMoXcZThNkvVL6SGYbwJKVaxrBvm1Xl+QyTEwaxORR5gDM24L4/S1NPqEbL2KKB8ELQ625LYfO9S/PnW/t2FocOLgTyd3LHYv/lCwhKqRFbFyrCQF8BT/NnKtIxpN2YculTeqwjX4AT2S1PZ+/4AxqJqjk54o/TWyQeco1vTeFCgsrzXXWt5ic9gD9IXA1USq0lXknQV9tsQNqZJ1GayD9lUneUeQUeqYkgLNIGMIpv2guNu4zFER+kGYtMB7/a/niDibj8JYveD9ZD1hywEkPH3tYEXApUlzGPY5WvsyMNq34wDa2FcW8HJWwLhHsgLEegqmIHfQPfUM1hybAx0LW6Z7gPzf2ifSUDc1qrcVLy1NleA1aFJRbKHGvcou0Ev5iVVZtlAop3T+7aAAZvUod561WgUqrurkDEmLHaj/YlPStzwyjQ43jZs7ZmMa28YrPlpKlWV7iXq9NOmfrG6oA1AFsUaPx
 kdk30Hbc
 QIHsO5C8NJBTfOmC/ja1fyTQef2YdVl8d9BEjMzSoPJVCXoPSiurnbsWTPEkk4mt35asH9YIq9ouJwyTg1A9aErqzlxpAkS5iEq3TxPKro50AYjM7/IgB69aWM0MNoRrsCC4NuCeflNyCvwCwjwqvV+TAUy9KawIjVsIqZwmyBOPue8XyASAmXBozCiB4DdZy9ha/G9hPbuZ+6v7pGmJY+Qdfx7G25qC23BWQDJHp5BnLLvJyZrvuhPqAAhTSYcbnyDVCmuzasiLzvQ8JXp66lyi4UlbWjHUGi6az8hxUt3gxxwd7/xeYYSwgCQ9amCbnGP+T5zWZC8jhPfa1wVPjSJ+Qk6u68n6ET6akSs/JsiAIWuQlEYRZ/M4KcV4WsQxTh/qMKtB3/uZrBkU5tOHkG0k9DeRF1GmpBdXpG4Ajv8Lp9z56WhXUI9Rybo1XJRgi9AaW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David, Lorenzo, Johannes,

thanks for the comments and inputs.

On Thu, 01 Oct 2026 19:01:45 +0900,
Johannes Berg wrote:
> > >  $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=nommu
> > > >  $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=nommu
> > > >  $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p \
> > > >    -c nommu
> > > 
> > > Is there a way we could derive that from the environment in one of these cases?
> > 
> > I thought maybe uname could help but our LLM overlords tell me no.
> 
> Hajime originally wanted uname to indicate it, but that caused
> regressions elsewhere, so we dropped that commit. I guess we could put
> _something_ back?

systemd uses uname information and our (old) patch changing the format
triggered the regression.  thus, we dropped it.

> > It pointed at something though.
> > 
> > In fs/proc/meminfo.c:
> > 
> > #ifndef CONFIG_MMU
> > 	show_val_kb(m, "MmapCopy:       ",
> > 		    (unsigned long)atomic_long_read(&mmap_pages_allocated));
> > #endif
> > 
> > So MmapCopy in /proc/meminfo tells us definitively, weirdly enough.
> 
> Hyrum's law and all that, but I guess it's not highly likely to (want
> to) change :)

a runtime detection is nice.

scanning /proc/meminfo might be useful. although it requires to mount
procfs (we can actually skip procfs mount as it is optional) so, this
is not 100% portable.

checking ENOSYS like syscall(SYS_mprotect) might be useful but I
wasn't sure if this is always the case of NOMMU or not.

My original attempt was to use include/generated/autoconf.h; with that
we can omit environmental variable or command argument of NOMMU=1,
but gave up with handling standalone build/test case which might miss
the generated file (and complicate the patch only for the NOMMU
detection).

So, specifying NOMMU=1 is my previous, though dirty, conclusion.

-- Hajime


