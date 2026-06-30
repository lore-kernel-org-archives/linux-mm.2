Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60E53C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518836B0100; Tue, 30 Jun 2026 11:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C95E6B0101; Tue, 30 Jun 2026 11:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DEBA6B0102; Tue, 30 Jun 2026 11:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 194ED6B0100
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:29:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9465E1A0517
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:29:43 +0000 (UTC)
X-FDA: 84936963846.19.237D432
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id BE66CC0005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:29:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iuou+nPY;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782833381;
	b=0g4yDnGxrNVPUT0Bg/Z8EJkC+6XYoZhSYl/KNNqM6QWZ42QEN206W48buVKmHefrOtzcyZ
	0r0vtpGmnhXpIk/LLsWMHWTdhXWAN1jsJ1zzT2v/5JpiYB4DbI/Y2lc9Ac5F76S3QKYFo/
	sJYZm71kVTNvpXgmRY22xzBRWvLA4b4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782833381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIm8RvojPbtJ3wCuhZZrx3ZQaiWkrOs55RwJFuM72dY=;
	b=ftaVUz7IAjqbB6YvpGUwrlmzmgnp3FQSAkZpaOMSg+MXlj/98Pep6UUN8i/gTyNP2xoh2W
	nU5SBmZjEdzaib/25YlxMc9lwVzeoEMW4x7WEXLr+WBhnKe0c/eIIIITryWB38KE/EQ4yZ
	08q2Qwg+Eomwwmc18Un5mVxHjUf+NHA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iuou+nPY;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51a0188b92fso48274781cf.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782833381; x=1783438181; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wIm8RvojPbtJ3wCuhZZrx3ZQaiWkrOs55RwJFuM72dY=;
        b=iuou+nPYQbX1jAOnXj0DohsrnMM+OA4uwzEuSJuLL70g+TMj0ueoBAS/rVeHDg0b0M
         2TMpbXlUuZHnsnrEWc0LWj7LHpFOlh+qBCfr9FHh/oiYBYFSkXHTMomc5T8dxsq+8Mo7
         3bUkpzPChexTsDYpRSBLVSkaZmPiegUtgIFti4U9DaO9RAP3sCQ+LcsPkE7pID32eudI
         lHxlHqDT9k0uPo8apq+lx5PmT91KJC4llR3fH8ItRNWmr+Xujdn6TCCsmHqUNeUwfz86
         liz+YnP1x5v/VbG0IjZoX7ABhiiA5EO8joKwyhj8WZUwt+uvzq6yi/ygV+7TDYjmlSkf
         9zLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782833381; x=1783438181;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wIm8RvojPbtJ3wCuhZZrx3ZQaiWkrOs55RwJFuM72dY=;
        b=Cwa4bZT0/s0Ic9HKgQqPm6PwR8nxTOTo1ZSWJ0nKL4CCvkqQ45rvQAIhN9pDXeCjBr
         NaEr0nMgBi8bLDPS+H03t7xwfFqWUuRBycsSXWh2cmEf2Axu/YF/XWFz5r65hG4FMjXr
         T998o/m0Rtde6pFNmkSLqodaTV39zMej/R3EoB3XD1CXwDOrYyl1mvvIBGuv8xwnJPFi
         9Io9teAS3l0s+l5MxR1yjmo0ef4aZ37TqxrPUN2GXDGyfXFmUddutYcAUIk0J9TQf/be
         bCSZxB2F4uphMSEyJWUiHaxhfHhueo+k1n+e+mECKrE9va28Oy1Z5XWnLY/IGWrZddMt
         KrnA==
X-Forwarded-Encrypted: i=1; AFNElJ/NQt49aj9tUSK7YKMwKbBrtgKVSK/0KAZfZY/NlXKoUvJvUxmGjlWdALaFAT9SmDjAxe3AIxNjcA==@kvack.org
X-Gm-Message-State: AOJu0YzhiKhyS2G6Km+BfdnkX6w0ByV8AXYkB8A29T0NEPViW08goTf2
	mfQ9gK/p4Fw7WWBm06xwPkrdstc0Yfy6OhguG4pIBAhvVxQWXEyQxK7h2YA/n1Y16HM=
X-Gm-Gg: AfdE7cm6IZ4YvFeCYHUtE85P/KiwT2+c1+XAw+rnEbLhWivcZNY2z1WV9MpIwZm3YCj
	B0GSehrnpLFZVFQGbAS+xb4bPqaDqBOczgm1z1ncGx41soRIindOK67f5O29fw6V+Fo9AJXA3bV
	YG8vH0mpl6ID9SUcEeKRACuzlPllsp+MzhnunqwzVfUbZB2aUI9Z5BoAyK3UW0XNkRg6e04ygHt
	aJZwGNk4OAolsGkJkiTd1jgdDpUHRl6L8RARp8wkR/8SyR6RrYzJpW24D12cEP06QN4I7jQDqrw
	rFYTdGJJo+hhuuseJjfg9aZ5YqQoUzErLYPDYmsQYyk8EY7Ec6wLQgLDCiwZSgivPdDfor/69vn
	Wpaxj/OIKYPuZ76iPanYNtyYX2n7duB4t9kLczXdX8alqFSx8Ykd5h0PgXOAG1fNCx1b2L5hvds
	iNrAJqdOOWHA33o5D3FmWgpCxiFGIX5e8gA159yHoTz0S9cdxaYELTzd+Ll1duo90E6v2I
X-Received: by 2002:a05:622a:5508:b0:517:5bc1:e1f5 with SMTP id d75a77b69052e-51c10521f11mr50550161cf.0.1782833380767;
        Tue, 30 Jun 2026 08:29:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c109d374fsm20272631cf.21.2026.06.30.08.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:29:40 -0700 (PDT)
Date: Tue, 30 Jun 2026 11:29:36 -0400
From: Gregory Price <gourry@gourry.net>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <akPg4ANRetbjSP_b@gourry-fedora-PF4VCD3F>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <akKyjUbFg6ETqUao@gourry-fedora-PF4VCD3F>
 <87h5mkz33h.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h5mkz33h.fsf@DESKTOP-5N7EMDA>
X-Stat-Signature: 98zdj5o9ziyyjzobepn6365txp3znfab
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BE66CC0005
X-HE-Tag: 1782833381-721926
X-HE-Meta: U2FsdGVkX192NGgHnUn0qn8k75S2LHGhps13i1Dqs+A42pG30qTYG4Lstev1LAvlSlbrgKWnwO7VkjvY5UyDsAXSvAkRsfyKnNmqzb7P2tX5WOEMFQOcIJcVGFjJYLE0+HJv/iWQ+2UzpFIhq0WI6Ydt64qS/3PTgrd3O+HsBAx7S24/0DGlPOkvSiLEqUrn2bs0e2FGDWbs+0+XoMfwLh8l8/T3msP908dKzZ1+dvxn5XwMAZFGOC65a2EcWQcvbDg6gZi/VBra92WDcYynfuSw/j9373RPbwpIuzS623oTRLOIUt4FNVKn6BN07g6NcTZRflZHJ5i55NbpQsT7vGGWPNzyH4ql9dLEcXl3PqkGFjypMl9ZxPsNGD4+1lbSZdOAaWljFCuriScu9TszwOvdBQiHTI1GACa5OwPMhg39hbRDJgBw6wAyL0wX4UhTRUgw4+0jQzgNt3ob6JpLmE4hb8wJvJoWmKtQGOS9cAQVd+SAb4CxOLY+uza/iwsB4V0HKVTW4BOc1t37DcK6LYe/vI5DZ8pmJ8DJ4/aXjwpfDgQQNV1Z/eJqGnDj44NXGImEWTZVwPOEHhJqsCVcs48Rz4cdrvyOc0MYI3S6f47imcBXphroMAtpCYHWWgJR9mVWyW/+KwcIbhW9bpQ+tVHycgmsuc2YWw7xUB9i6OKELJ2xYBoGJcsYNKdKDyGxANUED4j0PEDQCJbmb6MQwNmO/1rdMcZG/ZB6Ynu/oczPM+M9rZGVZJVh0Uym6jXoMGTr+lJ/u69mtLWrzTSsYtWAx2EP4eCVxnnT5+iSjdGrFGKBI9+es819ZI24E30sIJcung00S+UXWqhAiHB0GBCccrPY1IwPuTbsb8xK+tQD+/kkHKDRHUCHroP/jTz2gVitQXVcl01bh1KS17kQwSiNO2l/1ZNqB6lJIAbDW5zmQQmZRRUHAhOnO2XvXhgx1Cgi9WbZMPLE8z0NUzW
 J5tYnzGt
 NETcB3SBqlHTGMxgDdu0bOBKwVr5/S8RVj1bh4PLT2Im/zvSkUGICjiRlIa/30vvhWgmGQqRWWXbCXDeq2V6eKDUD8FTC3aW8t4/I0VaIX2+kJVhv5lvn2J5Vljw3bqcC3cph7jgaLTagrcWGKW0j++RT+idboc6A5wVLfij0QfXbfNV+jF1oYFnu4/l49L7IA7YtT4+FPFSezasx/QWBbt81j+2IpL7u+waHv3AkE3keIx5mU8UCIuPBUPNZ+Oe0W58/xqN3APMsGc8BeYMgd3lf98X8Z9WtsuJqMT8YJaGdVyGKMIbDSI5REEqTWepY+eDy9R4AsyzsLUPrNaiQi2oINuhQMuea8t0WJYN/WsolJpBlykt8qOXw35XmXinJwmrKg/AvrsYETbrZ5Rcoc/igmlvCfAOSHR9kRbfs+8ph++MF7SSjxNQd8f2rKEZDxx2U+7h5c5C9dNGQZ3OFsw6UQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 07:20:50PM +0800, Huang, Ying wrote:
> Gregory Price <gourry@gourry.net> writes:
> 
> [snip]
> 
> > Demotions don't care about mempolicy, so opting shmem out of NUMA
> > balancing and mbind'ing on a tiered system is just full sadness.
> >
> > This is all just more evidence that demotion needs to be completely
> > redone, it's creating a mess of undefined behavior for memory placement.
> 
> It's hard to respect mempolicy during demotion in the current
> implementation.  Do you have any ideas on how to improve this?
> 

I think it's feasible we could respect per-vma mempolicies, but not
per-task.  That would at least make this particular interaction less
painful and mbind() would do what you'd expect.  It is a bit racy,
but with MPOL_MF_MOVE_ALL the user can get what they actually want.

I think task-wide mempolicy is problematic and generally a bad idea
on tiered systems, maybe it's ok if we simply document task policies
are not respected on tiered systems?

~Gregory

