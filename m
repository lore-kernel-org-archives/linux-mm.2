Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F7FDCD8CA8
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D784A8E0008; Thu, 13 Nov 2025 11:48:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4FD58E0002; Thu, 13 Nov 2025 11:48:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65EA8E0008; Thu, 13 Nov 2025 11:48:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B0A748E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:48:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 53A6C12E894
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:48:47 +0000 (UTC)
X-FDA: 84106167894.22.F8FC89A
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6B23EA0013
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:48:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UqmywQwC;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763052525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtBw2QaKFUcY/ykNwr991VNkMXbEXUIubxDUCz9u1I8=;
	b=DgQ9SQTXqkyqtXvT6Jo19O80wIQJE0kHpLbUfNbydq0MNVNhozHefaWYCJUZTNGC2hAj2l
	l0a8N95fswPwXbheHRBMHmWnwLRUscreilLzHL7Dmx7nKzkOdtVgPc7pToktZBWZzR7s5U
	01EDQuvtjyCYP2/U7XMjBMZFaJmOhl0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UqmywQwC;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763052525; a=rsa-sha256;
	cv=none;
	b=5DCYCGF+LsgIXzNyDAkc2TN/n9OzU24FnkjXqCWfMM53GCjaaZMcgihIIYIV+gIK3l1CdO
	nT8Aqg+dETYewUfto8NQGx4G7xOH2d/I/po4XqF2ygg6uNgl6c1A1j/oygzj/LlX2W+ObH
	oWHvvCcd5vJHn9MsU/v7+j26TFGcCbs=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-298039e00c2so12686105ad.3
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763052524; x=1763657324; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KtBw2QaKFUcY/ykNwr991VNkMXbEXUIubxDUCz9u1I8=;
        b=UqmywQwC1zV0xYE40BvR4IdKN86FHuB/STQQHqO2RPQm8azLbILNDgXtLHMMF9aN3G
         T/tAnkW1+0AHirMXSMcFib1q2gpMa6TvtOw7B+Whi9EAOkI7Ob5yjCt4kTjFoNe8/Rct
         GhUF+8p6tKP2UXu9kxKJOWDJ31dcJ7zGilbNheX9ApbhKDGOzmEOLBh9WXc0mplD79Lb
         L79QsXDfWAxhfaq5YpYkK3MKWAgdps3afEunQTNVwz/4+waJ8zbmuhC03E5igVcodmDs
         bOUw/0hOkMKg2lBmuyRfxJDASZiLsHZjalnjSSUY9CXCYIg/WUCtlGSBsensz0i+4Dsv
         KwjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763052524; x=1763657324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KtBw2QaKFUcY/ykNwr991VNkMXbEXUIubxDUCz9u1I8=;
        b=lMwDhUJf4tkv0twp7JMv3WWaY7X5SAa0QB5V4Pt8Ky7c3MvVCd4hQn+7RorBAprNB/
         2igLKzX51MCU7f5U1/alY7vt1scS6S8dc2JwF5FSgJALlHMxprt5TRxY4oNUT6cJnF6Q
         w7+no9WnSUVtP0zGwW3FsRlNAOGZa+ZCtCDXPbntS7IRkItmXn291jP/Gv/jm2U82aG3
         Dt9jHM90nMpFOfpVORFRxU7G1H3IcrO8ye/sfArm5TgGoMWYka/5bD98KeDwVqSCUHsb
         PMLWArEiXjxsxmB2vAQaGzxELMWDOxwa8zYvSz8hCApgVzJ6lJgk29bWNur+okGL024x
         dXwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuFo5WLip4ORMpxILeKypGF8X6dwicVtcYf91nPhF8JY2IwtUQdZkHfRxYDpEGLXAciPnnGsBuBg==@kvack.org
X-Gm-Message-State: AOJu0Yx143kxBJ2ByZ7mbFo/WSEjIgysDNveB70P7G+6A9iwMcaBT1UC
	f2mgPSr1/tBIzfXBQ8YRXFHHLuE3lLCHLUDNOo6M190//HlFdOrKksrPkiuefQ==
X-Gm-Gg: ASbGncu7WG3qLQAiz0MWhneMgXebvQpw4qZtQxgi7vCErC8MhFFqnMkpcj4RLuUr9On
	lOjrfKe0wfg7JYO845hEMzHTMEbyUk2fs61xmmVupi2oH3C3t5ansbmF/UPJ4XXQv1ATAWsVBxg
	7UfjD5sgdLFqyBpRHtZPflGqdz939VM3012PdBbnls30SXognXOMMPTmkwQm6ZkmKFManVy4cPf
	MmQDA280Plqlf2J1ERKXPe+NW+f0+Gm8x4tCEZx2epMxac6OtQ0Arpk9bal2DumUOS34RirASrs
	8QqtmKrud+GZSHIuw0UBT+GSHOsarwjmOxm0BWZwXiMPjzrcL8drQgrSBz4rC1OQBkg9bnFgIlv
	WoqI0uGQJOqHqBMu0J1P5n/HlGsJnI5pPbXngRXJj7F7fxEanXdWFwCkWvsZ7pKZugjzaltaicb
	n4+Fdc4Sz68IXdTSjmFwuiQdH7bPeLvbdT
X-Google-Smtp-Source: AGHT+IHeub5aNCvnanVAkTfvVdmm0rKNrZXKV+kknwHxz7AyPMKPAPWmPtn/96i7E7eHSTeZ/nnwWQ==
X-Received: by 2002:a17:902:d551:b0:295:82d0:9ba2 with SMTP id d9443c01a7336-2984ed7a01cmr100922265ad.1.1763052524113;
        Thu, 13 Nov 2025 08:48:44 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2bed2esm30948585ad.81.2025.11.13.08.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 08:48:43 -0800 (PST)
Date: Thu, 13 Nov 2025 08:48:41 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: akpm@linux-foundation.org, bpf@vger.kernel.org, hch@infradead.org,
	hch@lst.de, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: make vmalloc gfp flags usage more apparent
Message-ID: <aRYL6XVX5pfhLqBX@fedora>
References: <20251112185834.32487-1-vishal.moola@gmail.com>
 <69158bb1.a70a0220.3124cb.001e.GAE@google.com>
 <aRXeK_C44xGb3ovg@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRXeK_C44xGb3ovg@milan>
X-Rspamd-Queue-Id: 6B23EA0013
X-Stat-Signature: xyyhrhn3spfo6bn8t89my7kn67gse7n6
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763052525-509122
X-HE-Meta: U2FsdGVkX18SXhEDD8iczVSU4bC+hM8U8rMuZAcivFwl70Nmb4Qnz73cQCPiC6KfBokY4BbY+IZGWvVsdn7jn+qigyq44NPKqJh9h5yvEhJwh0NQsCnxe1ikoASjk+Fh+SNf5tKlLnHHr+jlbC5bJBY5603sppdR3zOsGXT0JIzb4roBNYsuvnrpA8oRe2NagSOfdljTzG9Hm4UwsX9mZ84ilGgR6fWPt7brkdGuHpR+QGvHT5L3w/o5R4XK5kT16LEoOrJtGLj/HBkh9iVH0Fbsr0U3yHY/6Bl/DwNkDATFlVjNqRsF6QnbfrxVdVjF7KmKeEtAOM2VsuVVHydY6NwQg0F31iKhQXQN+wujddsZiW5dx4qoipje5kkKwsBqdv5N4EVkgqVQHhcu9oH4pDnyoXl7tw1jBmZqN6ipDL4ZLJBw2JsfsQnD+j4TKI2VrH88CU7b5KhojFxdbuocDxSCmeEP8ao8I+xUCB5HoOTyLcWVnqMWxOWUE45HjfL45ruew9LLBBwvoP/Islpnu60DqCAupWuDRz/8HgJOXk3KgOHcfe1owqu4iTA3DKqdcpDVrbpSdt+y8MLCRyMxHD3wRt+V7wAtiX/5Be71+G5NtOg0jehtcj8jbxkW7/3fd3jZcRK0urMVIdzmxqRWYmwLPYV3vW/n6lORFALjVP/eSekALgCjumksM+HRyik7FjcGJJXX3Mj+v9+6QmLxDSCcB+zUal9ZKz1B9KrlF8F68hziNgNz5Yh3oDTpAnW4mirFTE5A0Rmo4bCD1aw8WO+t3COe30FbGhIt0B3Kjw2tZocZGcJCo4b92YEPJ2QIfTn0fwZv2AOLABvDZQC8eXTdxiqeLGz8dCW6zrcexiJv6zAC+hEOgSuTiwMYuMeHe0vd+yqTDFBzgVMuFKvQImgqW/ASzr8BlksGtsqK/jsidX7eMTArOiJzPbIcdcBOjQ4zIi//h6MENzaGUcB
 QD6+1Rck
 H5SN1joKCW8uAB36kIMh9+KuyJ5WoQU6o/cvq8YA4missjKZWPqGABmZ5FERKXyvBTq4h0tKxBxUDpehYz03PGgCfxLQqowJcE7VosonzQTJeH9lMmUYMOiTYVJieJHS9VIguwP8uJBrv1Md3pxtcO4vY1sf9hUdK3tqiVzcU9W5GJpIZy7miX3MtL0u7EOMB8X8p8eiZ9P2LPcf5x7uZojwuIJUtVVBIZmeUMq7IoI9z+xyloG81cRiVIH6kmND/xvUsuDRt0gC/AAjARtg7B0MpT7Ti5Il3vht8LsD8Q9Aasnk6qKO5KIyQ7IiPdQ3f4bTBVpDzXEjZN8bABqsP7KJx09X2kNCV/Ej9cb4r7kQv4D1U+2dPOggS0LIFTnN8Rqoa8yDcJm4sp5W8BssRrv/X3/e7a14jrjdzAOrW6KG9YxN5QDjJHi05rcf5ud5M6kCQ5IJDr01N+1cty+aFbQdFWItytYFJ5disB78Mwstj1B+XMiaMobjsX7sdEYdNtLNRKYuW2sez/VaPGhLw8beor+iSayzr0hv8mM+gNfvaSsA6XduPyTDT3v+yeOl4oZq0Cd6PcN12Gr96eP7ZFJJ4rgOfc7VW05N7ukj8Bb1u7iKtHXXyFnLWTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 02:33:31PM +0100, Uladzislau Rezki wrote:
> On Wed, Nov 12, 2025 at 11:41:37PM -0800, syzbot ci wrote:
> > syzbot ci has tested the following series
> > 
> > [v2] make vmalloc gfp flags usage more apparent
> > https://lore.kernel.org/all/20251112185834.32487-1-vishal.moola@gmail.com
> > * [PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
> > * [PATCH v2 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
> > * [PATCH v2 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
> > * [PATCH v2 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
> > 
> > and found the following issue:
> > WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> > 
> > Full report is available here:
> > https://ci.syzbot.org/series/46d6cb1a-188d-4ff5-8fab-9c58465d74d3
> > 
> > ***
> > 
> > WARNING: kmalloc bug in bpf_prog_alloc_no_stats
> > 
> > tree:      linux-next
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> > base:      b179ce312bafcb8c68dc718e015aee79b7939ff0
> > arch:      amd64
> > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > config:    https://ci.syzbot.org/builds/3449e2a5-35e0-4eac-86c6-97ca0ec741d7/config
> > 
> > ------------[ cut here ]------------
> > Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
> > WARNING: mm/vmalloc.c:3938 at vmalloc_fix_flags+0x9c/0xe0, CPU#1: syz-executor/6079
> > Modules linked in:
> >
> Again bpf :)
> 
> GFP_KERNEL_ACCOUNT? I saw there have been __GFP_HARDWALL added already,
> IMO it is worth to replace it by "high level flag", which is GFP_USER.

Yeah I'll replace __GFP_HARDWALL with GFP_USER, and add
GFP_KERNEL_ACCOUNT. At this point I'll just add GFP_NOFS and GFP_NOIO
as well so its easier to understand the mask.

