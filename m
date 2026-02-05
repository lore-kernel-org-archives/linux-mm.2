Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E78E1EA7959
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 03:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263436B0092; Wed,  4 Feb 2026 22:04:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210D86B0093; Wed,  4 Feb 2026 22:04:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D796B0096; Wed,  4 Feb 2026 22:04:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F20756B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:04:26 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25217160150
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:04:26 +0000 (UTC)
X-FDA: 84408909732.30.3B342E6
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 27CFD16000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:04:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X1KnJOSr;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770260664;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fo9LPvZFNEthcZXdHyGBx02jqzq0dJGk/n7BbP/MU4=;
	b=Oe4SWKxI76t9uy1q+NTS2ankr9rKEfkBxdV6rfLoIfL1s9THMoDBZ9oGcgtAdH7fHyTzIM
	zZ+2NNtM7qi1NAKIop6HgUtVGor8KiUaKZ4fDlF8WsMxW+iCFLuyBaajGAguE6CbIGnMfh
	xgGMeuie5flhj7zkE4RA1Z9jsv/Jb68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770260664; a=rsa-sha256;
	cv=none;
	b=UFUp2GOczTrAW4+0czlgBBw22qa4YofZvQteeDAe4Fx5knEhMg+P4Ut8KwPOqLmE4sVnI4
	Cs6KhPYHTBiWdOdwtWGQm8afyLTQc6FLNgazQZtf0ChMOsdyVRwCYwJ1qQ7+YhgfSq/bP1
	oZspFkwOOLGI/odrURcDbRgrOiwdvO4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X1KnJOSr;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4805ef35864so3357395e9.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 19:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770260663; x=1770865463; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fo9LPvZFNEthcZXdHyGBx02jqzq0dJGk/n7BbP/MU4=;
        b=X1KnJOSr18xwTxD3JRMA1naUnDwLBJDbvkS/NS+bj2xGbrTq2YbBQwCEJOKK6tipFh
         DeewYQpkXyYtMYNs2mGOxwuk5rFuB4f2ANs0s8MrhMKIFedJxo+Kir+F9vU9GiIcZlh6
         SVxYg9DlqnKVIsOT7uzHQhnRXNyialUMJ9CYDGThj0gc2IJO/SdLkpjz4DrbmcF5A7/q
         7pRNBz0QlGFxDq2bZ9VOoXSA4QKYo+SCLXuTrx5H2NyPu+BXzpCLWKyP63RPdvoqW78T
         bKIJXQcc5b2l5w0L6zq2yU/OmqaDDZjs9s01XcD/v4+HVDx+30PbuYjMP2bqJZ3ONq8o
         9arg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770260663; x=1770865463;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6fo9LPvZFNEthcZXdHyGBx02jqzq0dJGk/n7BbP/MU4=;
        b=vQFEclFiId4+I5h3G4be0GUC9p14fkRHFP09bSiXEOAZ63ET+ZVGlkS09LLC33n5Ok
         Tw6KbknSIa2rY9fuhWkba27tLIUOqW8G7GUfF6+V9EX/Pu8Ys43yBPTEWcKdJKVZevc6
         cd1MofA80QSixhamV1tmoqjgqJ8SBNmQIOqgI6BeWlUtSAXV0cr0e6YYSPOndaqWE+Im
         LVKCCTrKE9uVo9qgvr+HGlT+0r4/1bnGUFa4tLXWMqR5K9JeVQrzR/WAH2ysrJSmcpCp
         y1NZOZi/sXcWaXxQqdrS4EZ7te9cfGIsRyddb3F9aIWarGEGbYojczGUV+lPUTLjwCzt
         GOzg==
X-Forwarded-Encrypted: i=1; AJvYcCWN5PDwC6uHSULvZt5QA0uxPgJe6H/AGlsJNe2Wdl/9bJO0UGQVZIvHUyYR7GoGrxsX27nD8SMu8A==@kvack.org
X-Gm-Message-State: AOJu0YyOn6XDSUseDkihQ47kti/7vWWXl8C51wGOSLMRMHYoxn5rPoBe
	DXcHNyVfqEb1fhOh2Ukk+Y0KPwPamK7F9KvXTwlTxLLREBnsvfYlU5+m
X-Gm-Gg: AZuq6aKgGwFdJ1ptoXYatAQTQgRGd91Irm9+bnqXSwb5NC8VwQ4w88afR69+yYkKHy6
	dXwGMnoMwFul3VUsyJm4xwNTFSY4KZ1NnZpVWGbNMV6hnjhGSszaSVpQmmlVzG89WhmRoWfAmsH
	zxKqmPmMJSB3aDc4HL93AGR3yzrTurGYn1mGK943hcFhYqkX+4LCqNw0lWcGor9TqvSvi4Rr+Di
	chZQgK3Ie/QaXpZOuUJ0CVaTsWXvimT8K94mc18ykaYMiPv3PoKrtCO00AQNPmugWvl90Ce9zJr
	w4UQjL0ZcLD9Ls4bAvK3JIrMAnfF2oHB/7dXVjntwmVsn14CLnj7C423ksgp7OZCHG+N3pZhqOG
	c2k7D6zJYbyzF7J8NuJ9NqTJVEpZ+kdvZxKP6dKHnU9twf3dZP6ZtCo0vP/NR2L5CbvTZynRBwl
	54E7vGhP7k4w==
X-Received: by 2002:a05:600c:4fcc:b0:480:1d0b:2d15 with SMTP id 5b1f17b1804b1-4830e9926c0mr73610275e9.27.1770260662635;
        Wed, 04 Feb 2026 19:04:22 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48317d4b2a6sm21300975e9.12.2026.02.04.19.04.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Feb 2026 19:04:22 -0800 (PST)
Date: Thu, 5 Feb 2026 03:04:21 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org,
	lorenzo.stoakes@oracle.com, riel@surriel.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
	jannh@google.com, ziy@nvidia.com, gavinguo@igalia.com,
	baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>, stable@vger.kernel.org
Subject: Re: [Patch v2] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
Message-ID: <20260205030421.zz72iie5bwvgxlsj@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260204004219.6524-1-richard.weiyang@gmail.com>
 <20260204114217.6da3e05ee5fbfac3a5f4c16a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204114217.6da3e05ee5fbfac3a5f4c16a@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 27CFD16000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 51ddejuh9bhpzw6at3z81e5a9zxj19cg
X-HE-Tag: 1770260663-190874
X-HE-Meta: U2FsdGVkX19TG1K3zPV5Ux/qcYAAz+0yk94+dyOnoEe2WuP+y/ootch0qqE8t70xrWiP7HN9IEv3TdCewXIxj37VEzBPI1EJHBXXZ2Qvp0whoqqrxN5SFkmlig0tthCbn5zXCi/lI3hRxjWvvUFfQ84FCSenwYLe3WB87X222L5Jxy8yKOUgz3XmlaKk0zVB4Pd7H9yQdIU6QGwtl4V5JnKy4zp26v2ABZvYjOBtA1lHASH6eQgaYstxSq8+Oj7fo7WsQ9xAgykBmwdEh+3RQ1BndMt8cXi0pBH44wr+Pec49POqV+QNgJHZ8AnnpOqNMQCKDV2hNumfUMIZMKtNrv5biGXBSOMIAMU7kAl8GL2i23o/TaJ8Zls/T8M/VoIZ5dFwxtply377CcdRMLT+qJEqFfInmgzwZoDnb8U6zl9+xSirervtnDwFu1PPSlpOpquohygzUcSdYrrj2GetoXZp9hF46qtK/T58VEXbXnMCfBXtTf1k6gHDjLFzcotD0Fv/YQwW/MvucvJhERPhHoWmxQk2l1ZwGzk52FY1vPeEx//haIsNVH6BLnz35ZjnVhSIo+5XT1Ct1OTAJPQ3rxUd+p0F1DeCiNu/E8RtwIvEmOWKDK+0pfntK3Vl8cimJyjiM6lowuMaixzXr6nv0pjgbzfmWRdOdtiIiui6ZqiFYDv4QpOaZnq7kOlFjcc6LEtfpt2alj6wH5jHP/hphfm1oGKHWjpeGGBVmrMr4EmrcHAZzkmxuEhRV31Bfr5U/rLnQWrZ9G3EBgWsfZcBhjtsoUtEWs4Y3HKqNmEdYrWHl/LrwBWYE8vLfVBYAEKHxroGUpAO33najoiEx323CeIVg/q1CzozSkWgfDJRCEPM99Km6v88yyElWpFhkIbQL+8UAFYtLjEWcVoYKh9XyVYk3+gv5AkXqu6AKrub3vPJUyc5T8hI7H80E+mjiYb0eGbXWd0I6vhO7EzDQ6g
 I9/u8j9M
 gUpVDPsvtcS01fe3pj3Djed9XwlzTvdPGvuFRM0GMIXBmIwaKTJDmbMuAqopizv8iyDWXvOKK8vVICrp1fahdAKfuWfUVc+6L2YMF/M7GiiR3x16rWL7GnckI5ni/1VTnjHFjHkU6p6RyMTV81lbgPmLWm/89AlhluGj4m3hGGjebD6VFTpD8PuCrhP8AYDyn/NeQtX9t9pB2oC+TCWEjGMCJBS14AUatqG8rmFKXBg0ZACZSshgw466Qh2QptxmSmcpHh+4/frAxFDGbECy45E5dIXqXZ1LWRQf7ZF58LAh0zq+GecB6v0+YgPRbQJ0cwX2+6OfHTfGqqys8ExmC2jVjGup2vtnt2XWnpWDMyadnqqtAXCWn0SOGbmH7HbySa2tq99CdpmvenEEmJSAQQGby5ZdyPYipxoLcyXpEGrPESK46DJ1CwQRUgJaTu4j339OjsUJi3p+qImrK/gFH2oWaoJ4v+OohKUkrvV0j8ftX1+E0OwJmIEg4i+HXNPIxhd+vWr5jS7GVJjZoV1Jdks/qC8lsmi276ekao0HfMxhrh6dzw9/Vla3JTa65uRBWHoperqkDvM9kFvBftRV+jeKPjQMFLCqURJIs1Jn8N2cjSNhtJRbFn1S/yyAFRk1O2O4qFzKXJJaoyPjeXPTPzuxym7WyRrHO5s1xPZA2JxYSpKHkLw+NPDk76MdRvy30RQPVbdNnoNJK5KAkjzJxtmo0Ic99f/H6qbVgty8YOMgXn9WOhuiGVa4aweFO8LFqx4xn3jpY5wA7KdvNvutmaf6ZMMNvXMaN6/9J2+HciGtMTYZ6Avd8IhMZjdEYYGOkuqZgr3YABoL51xeDaYyWXvoyNCtp/VNeCts8jMYuLNtSYAIyBUsJlhPEv5fQqmgzTmYAsSfGi6u5FIDTohXyLBUNqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 11:42:17AM -0800, Andrew Morton wrote:
>On Wed,  4 Feb 2026 00:42:19 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
>> split_huge_pmd_locked()") return false unconditionally after
>> split_huge_pmd_locked() which may fail early during try_to_migrate() for
>> shared thp. This will lead to unexpected folio split failure.
>> 
>> One way to reproduce:
>> 
>>     Create an anonymous thp range and fork 512 children, so we have a
>>     thp shared mapped in 513 processes. Then trigger folio split with
>>     /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>>     order 0.
>> 
>> Without the above commit, we can successfully split to order 0.
>> With the above commit, the folio is still a large folio.
>> 
>> The reason is the above commit return false after split pmd
>> unconditionally in the first process and break try_to_migrate().
>> 
>> The tricky thing in above reproduce method is current debugfs interface
>> leverage function split_huge_pages_pid(), which will iterate the whole
>> pmd range and do folio split on each base page address. This means it
>> will try 512 times, and each time split one pmd from pmd mapped to pte
>> mapped thp. If there are less than 512 shared mapped process,
>> the folio is still split successfully at last. But in real world, we
>> usually try it for once.
>> 
>> This patch fixes this by restart page_vma_mapped_walk() after
>> split_huge_pmd_locked(). Because split_huge_pmd_locked() may fall back to
>> (freeze = false) if folio_try_share_anon_rmap_pmd() fails and the PMD is
>> just split instead of split to migration entry. Restart
>> page_vma_mapped_walk() and let try_to_migrate_one() try on each PTE
>> again and fail try_to_migrate() early if it fails.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
>
>Cool, thanks.
>
>> Cc: Gavin Guo <gavinguo@igalia.com>
>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> Cc: <stable@vger.kernel.org>
>
>Why cc:stable?  In other words, what is the userspace-visible runtime
>effect of this bug?

On memory pressure or failure, we would try to split folio to reclaim or limit
bad memory. If failed to split it, we will leave some memory unusable.

I would put this in change log, if it looks good to you.

As David mentioned some change in comment and change log, do you prefer a v3?

-- 
Wei Yang
Help you, Help me

