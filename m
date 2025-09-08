Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D199CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 17:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC828E000D; Mon,  8 Sep 2025 13:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745FE8E0001; Mon,  8 Sep 2025 13:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60E048E000D; Mon,  8 Sep 2025 13:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48D538E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:50:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 066D014021F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:50:50 +0000 (UTC)
X-FDA: 83866823460.15.4CAED8C
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 17F7B100019
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 17:50:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eVl2qHQc;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757353848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dF1xj2feIA70FeXCDtnqFCxI24aighX3ylk5DZ7hmoY=;
	b=7zSjzRAzF4VT74Njj7K9g5osCJHfiRYx8Xs4Ey6vQMCARPiNX+pqS0UHOpzCIrT5z8CwoY
	TMGZfZfGo84CEFyZwHpe35zhMMzTZnZOFmzx4R60NAgo2ZkrkRjKFQZLw+T/kUQ+2BxChq
	KXBONp932ovybpjivB+pttZx5b+rOmg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eVl2qHQc;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757353848; a=rsa-sha256;
	cv=none;
	b=WSAB7zu+BKqTbUd4pr8hT9REu7g1wWmbvsGhMAI3RsQOi/9tTWPiKr42ub7Kmu7Ty26ey7
	2rEKJQtbi4JZePKuFvhkestbxrKmHVIcbBLxN+9J1pGpYIJxgr77/xw0jHAQo7j9vva4qe
	CKt0kqZ9jVdoNKC553gKAMGRaN55lXE=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b5e4fc9b4fso24842191cf.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 10:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1757353847; x=1757958647; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dF1xj2feIA70FeXCDtnqFCxI24aighX3ylk5DZ7hmoY=;
        b=eVl2qHQcy0bLdyaI16ZHNoRzIZLUpUAthDwOlTKI8kkUflhwrxJT3vhmt2X3ViYuN1
         cbvvp57KdqIZeZGHah743yPuH09sXsovI9IWRuKFQa/UV0mIlNihPm2PsfRcfpCr3/Bi
         tv++udFtTvc66S3+pkY8lc2cVktxw7FSdHyXVA06rcnAIwL5MAYA3g1HNiFRGSUl8mhK
         UmtfVZaJAo1+qI9ZeIwB6j4hwnzBB7nhmxrHcEgP4Ir46/Kbv+6CLE3IzwZ82DkucEer
         QzinG4R0i+CXfjuEv7hd7yAafcCdW6G1u5OXqXWQdfxvfBGfRIOFohkMdjnfAJOyFTgy
         fNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757353847; x=1757958647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dF1xj2feIA70FeXCDtnqFCxI24aighX3ylk5DZ7hmoY=;
        b=ve5lYI3bFwpeLjhRsv7+6cEzt4BGVS5M/BWhudO333q/HnlVdtYIB/uYrOHbh9Y+hr
         wuUMBtAyGtokWMjZekxfod5ECv3tA4132CEMNni2YuOwVcUq3xklKnj6YFH7Wr/3usDm
         +BxD/MCP7K/OyHcDYsQndXVpRu7hQVrn/5x1HTNak40bh7B59jngBaQU3VZst30z8kOA
         HjEVjFWC2OWIM+HvnSry2fjtp2CCtkMIHuNqNwXf0RsvO4C0mEl1u38Yyl3JgiEKOVsO
         QArulKhDZoBjX4AALsLx2muiv33uuo3BFRB15sx/CuryEeL0NoMNXjynbPjqEdC8Jw62
         yMTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzwpDSPvQH8P54cOSG+XrSFxAaf5bEHuvSEhs5Ar3eHOwBOJdwQotoOL7e34Fk1LcZxrzWLSih1Q==@kvack.org
X-Gm-Message-State: AOJu0Yxo7PMWW9BnfwlnhkpMv81/cm3PgDyvdAQw0ph8w6dUDo/veRAZ
	84XzH6OWJwLVg3vLo/7IUBDAdZ/d0Oltp5vMm6tYYMWb4JOlbul/c1MGwhN5UI/wKGA=
X-Gm-Gg: ASbGncu9VpXsybt48JhrDsfkP6KrTMg+yKTTTqJK2KfK0/w/jZBnGx+DIhCiqtaA4Jx
	7DiLrFSYkfJq+WnorWZyEgPoiqVAProRZPdZYxb4+fj1P/xkOI9DkvdUOVlSIDUgq+EIRMvz0Ys
	qXNSCRT2Z1O7I2DncSlMLhDngaNIV7ZaUIMLoT+15+j+S640GzzWeIUR2FHMkXDKTpbo0LoBrdS
	uox1ppyM5TKo7gAzReMAtNzHX2ySX+K2nPX7kpILhVX1Z2298Irbn8+aiiHyTSKDNVRTEfYLU/J
	EMdRkJSMD74dAuvNuzA4YJ8LHPlyB9A5rYGwgxQKBIhVzsO+Hvl1Xk1pj7J+cNyeHKFXSIWVL74
	DUyaKMvGMle5j3mealD1WjSy9K4OoYAItn56lp8Ivml4HqEg/4HvSLuxj4bZKrPD2vE1eYeUa04
	vvgQ==
X-Google-Smtp-Source: AGHT+IFv6k94O5ab+utE872MZVk69x6/YL7XE67E6+Q/rJaTrlxps7XrhdhFQdjVAkN1VDp+aZrbHA==
X-Received: by 2002:a05:622a:1495:b0:4b5:f60b:2079 with SMTP id d75a77b69052e-4b5f83ae2f8mr98864861cf.21.1757353837787;
        Mon, 08 Sep 2025 10:50:37 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-42.washdc.ftas.verizon.net. [96.255.20.42])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b48f756d16sm102123611cf.34.2025.09.08.10.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 10:50:35 -0700 (PDT)
Date: Mon, 8 Sep 2025 13:50:33 -0400
From: Gregory Price <gourry@gourry.net>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev,
	akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to
 cpu-less nodes
Message-ID: <aL8XaWy6uBQ8iVGv@gourry-fedora-PF4VCD3F>
References: <20250904134431.1637701-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904134431.1637701-1-tujinjiang@huawei.com>
X-Stat-Signature: f33gyqr59mphnnqs3a9qf98773zmmbg9
X-Rspam-User: 
X-Rspamd-Queue-Id: 17F7B100019
X-Rspamd-Server: rspam04
X-HE-Tag: 1757353847-940551
X-HE-Meta: U2FsdGVkX19C3jci6X9mkfYGqTPl6Af52Wici343elS3PLu1kpITRmXy2KJvWL67eiKEK+5CpnG9p+GoGve4NbQLsW9YhB1UUKKUbp+7ifq1OOQ83+TbctzE3bsK/N0EgD0RNqO9ie8PshR6DkmgBElnv904iy/o5BIlBZ3nSnbO/PGyTmaIIceteiBkAm/Cce6xXys9yOkwASrFfyYk6jOR5XjJP7oEO2lXv7+47pGsrx+wpXtRL+Gcw8Ntm7RwmWbJAPHdzuK4MJf5SPNk2F/SYxmAappUleQBCbzn7fATE3bTfOqu93WaYGMrjwV+zwDhfWsZKq2fUYLgJWFtfDwQW169Q8f7OfWp2D3Przt4qve+RvPmtFs/Db9UVFrHNGN10kXcfn4GbU6HvIWuUypcz3GDHwZ5UQdWK4z5gppfas0CpLSPomeLt1VhHSOymCgePS2+86gZeRy/djSFJcTwUPNj3lijWsInxxj64d9SUPx0rmj5kcUA8VLzwhRD2aSlFPA2r09UP3sm086aYHcP+hnEsPgcg50jcoA59mf5u4N4lmj88E/KOBTiebLTABXV9RUCfizCRTTH1wEvh+ii5y3rU+CfwCXvgde0m5io3QJcZC8akeBE/jZZb0s1YW+waKtFJTlboLtM8/3oSvL6hPG0thMlN7hpGLiLgVW37+DWueWLZQWwxwPhz70AtM9ePW2AQaJxPEtRT4l61i+LzW59ZPOyI3wRLiRhEHDoyLyKnyZh36uv4kus5ZwTWikEhinENitsOatX7LN+Uf0Yfgc9RAElNtfXaLe/O43Ikzuue8QISp30b9tQuc6bejj/FpZ2MuHp3xEATXmHba2xddzBq41zcVvPyQWmBMX6GTz5oKqtiiSCMenDvFqARZ4PS0ot3XVxhwrFJdm7AXvYJJPeSgNHjz77VPizhijbA2wmwlVUbz8rFAc339A14MvP/ZFbIJ9Pn1kJN0u
 O8xUNsti
 CJRY/HSwC69BTA60s+NX6O8lp6sA79YprfVNv4mfnU2zohq09P1gE3dw3Dgarg3LSPiSIeFTea7OH3mIEctr2XoYaH5tRpCWeH6bcQTRu6dIY6P00AfOO2nej8WraBDEx2Pe5kbXG8iubxU1By55nU9wy/Z4cP6veCr2qZjET+aZ/ExA51qw6Q0w/48uHJ5PVgCofqw0K+vl1Ocf2oqA4Gy9hw8Zu700k/FZm2aBNp+i5tb+Lq+m0wuSyvAWJNmI1fpAN6us7cOYjFGlT4MN5Cw+j6lwXJkc9EGwjx529JgECxTcjt+uwSgluW0hJIQ2URkXJ4qKt8fpeatGyUgNYdXzTsr2g8wAl+9uHSwgM3JFOJIpNtcXCGQLmhnDVQUBb68+A50WmljLsSCFN4zLFWAozXwWsniYo7EGy9HDjrgF6r+Q1pYAW5xEK95ZRKmykuILg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 09:44:31PM +0800, Jinjiang Tu wrote:
> out_of_memory() selects tasks without considering mempolicy. Assuming a
> cpu-less NUMA Node, ordinary process that don't set mempolicy don't
> allocate memory from this cpu-less Node, unless other NUMA Nodes are below
> low watermark. If a task binds to this cpu-less Node and triggers OOM, many
> tasks may be killed wrongly that don't occupy memory from this Node.
>

I don't think mempolicy is the right source of information for this, as
mempolicy is non-restrictive.  Mempolicy is not necessarily respected by
reclaim, for example.

A task without mempolicy can still end up using cpu-less nodes for a
number of reasons - for example pro-active reclaim, shared pagecache,
shared file mappings (KSM), etc etc etc.

If mempolicy were restrictive by default, this would be a different
story, but I have to agree with Michal that I don't think mempolicy is
the right source of information for this.  It seems much more appopriate
to use cpusets to inform oom_kill.

> To fix it, only kill current if oc->nodemask are all nodes without any cpu.
> 

This feels very heuristic-y and way too narrow of a use case.  My gut
reaction is that there must be better way to get what you're looking for

~Gregory

