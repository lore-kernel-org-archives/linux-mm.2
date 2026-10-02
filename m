Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65F0FCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 12:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8786B0088; Fri,  2 Oct 2026 08:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A96B6B008A; Fri,  2 Oct 2026 08:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1989A6B008C; Fri,  2 Oct 2026 08:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E12626B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:05:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5ACC940721
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:05:57 +0000 (UTC)
X-FDA: 85277557554.27.50DBB94
Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7B43F40010
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:05:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aEdl5x83;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.99 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790942755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59ow6xTzZEIjngnzpCRDDNtxBrP9iJr2uOu5/gWZ8+c=;
	b=gIJKDRtnlNQ7FWu9Jm9/2CpateI5MQq4DccB29iO3ALX06jrWR/IKl3Dgg9CKdm5YqHwTX
	ROTzynjAXgAAWBGwJVCdc0FT4s2ePbARBwqZginZ0drxKvUJGY9zZwWL8IazjbY2aEaxBx
	TUrrxJcUCg505p3fu7OrWITRsh6hJpE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aEdl5x83;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.99 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790942755;
	b=OeS+zBOyuVaJOISA2ID2YHcqDx8ejD/z9KQHo2iePo0xeilj7kP0dIr4OrWSwq+4AZFx9p
	jIvbQD63yuIRk5wCu2qFJT1OnO8SplDvCTCBb/eP2Fj1r+D0w5FHGA8eSjUWznI6T1NBqe
	TldfNq7r8f5zFEAgmIJSJ9ClWvm/abU=
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48b0503e39fso1944416f8f.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 05:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790942754; x=1791547554; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=59ow6xTzZEIjngnzpCRDDNtxBrP9iJr2uOu5/gWZ8+c=;
        b=aEdl5x83fst9St4dsvBgkspROvIy1CU7/iJhM989U5sXZo5VhDxIlotqZrJWomjWL4
         Y5SA+7zXZqQHEqecd//ZMeQ49tJLxSuh5dWFH3yxKmsHn2yUofbR23Pe3nXxiIFTtc21
         GImhrjn27C+CllSkH/bngSvo2tb9jjDQdBrXbg1NN1OVKFwTp0qguOyZgOZFrcmxu3uT
         ++k6bHQLc79HkpYUmltuvzmzLfkTnHW36hJDtBN2IkYr+7G/vdFoC84knyKLKvq5IZ4b
         H4+93pssuiF0Qh5KunijCFiHF6qXdrvKsrDUN/8Pbb4HXrE9T9Z6eOdV+dx8h9og67//
         RYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790942754; x=1791547554;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=59ow6xTzZEIjngnzpCRDDNtxBrP9iJr2uOu5/gWZ8+c=;
        b=Rm6/hJLGqnwFAmJVrbw0lpOtodM7JL+aOVcxUS0kOe57uXPqK+4MyblNXlvD8unTLd
         nEJzN7IpL/SZ+2Ilrfw1YtHpBjlYbQIIS9FWUJiLxfgJqcOQ+2wm1L5X+PTctqORvd9l
         FvVcOujxz3tO3z2KI7Mt30gKNIKTDHYacixtcl+yEmTVZaUUoTjuEZxRtddkTttLEBR6
         WyauE0nQ/YTE3xdwiiok8xHZIrCiaCN6nkX5312uNgGJn1C6WYfH/Jemc72DMo8EBdbR
         eLNev+CXDk0tGUOd3vGwmtTboQuZrYnqhTOhQZuYatjtlOcl1jFbtnDSV8WlpVXzeq8d
         932w==
X-Forwarded-Encrypted: i=1; AKwUvBxmN18Je6b5JWIZYgU0sWosP8x9JbsegUwFknQjGTXTdAXKmDXnIjtsNnYV1i66TU1v/KGLn3J7Rw==@kvack.org
X-Gm-Message-State: AFuF++lWo84tZLimg+NJ+ZsJSamQuvXLyH93fuMUtDFf0XoFd0vhN+Ys
	5TKEAFVotKyymIN/MBmZE4zm0JAtFzlEQXS3oECyjfiorkqxZfMTMG0xh3asBDD5pvQ=
X-Gm-Gg: AYBFou1Q65u9PrGn/e/F2HGu0cdGaQbW9O5OsiXb/pPh+bZDTVtIbEqnsfk+Ucy99gQ
	0efQiyA9bJesfIFwUnZQGP7ujO6u966nFpjtIT4JwC4a80BaYn4y/9pytk5kRc1sut5JUu6RgOO
	oRa8l6dE7008YJY1e2qkkI58NCGkAXNBv5NWLTjMPHJz/aoBoLjYINoFIFcoILQ573nByuwtJ5x
	q9vzrPFB5dcB8bM9KQPkpcSHRisb6LP1Uh4yF2X8Dz9eOYqtms3X14Drm/QlZUYmd3Wov7v+AFy
	oEY4DDAU9qs7o/JimV3Un/0M5iM6Abg4IEPQNiWlDeniOnLNv1EQOEz1LqEY2/zOuowMPUhM3vb
	fOUry8YlQQEj/iajXoUWuzfigDlq2QGyD2g/uVg0j1wAdAfsxrGuoaqXwECalWEFPx5t0sXRtSv
	Lzwq52wcDFS0l4Z5r4DcvQB5an79NJB3xFKC9ztRRMRl4/dGPA66D2moKcXK9mmQi4F2I=
X-Received: by 2002:a05:600c:1c1a:b0:4a1:6424:41bd with SMTP id 5b1f17b1804b1-4a164244596mr13162505e9.27.1790942753805;
        Fri, 02 Oct 2026 05:05:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::7:9b19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380f0858sm5763893f8f.8.2026.10.02.05.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 05:05:53 -0700 (PDT)
Date: Fri, 2 Oct 2026 08:05:51 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
Message-ID: <ar-b2nxDbQjcDbLY@gourry-fedora-PF4VCD3F>
References: <20260930121154.687586-1-joshua.hahnjy@gmail.com>
 <2e3f12b7-0dac-428c-b70b-07e1f63de028@bytedance.com>
 <ar0fURbLDPrphYMY@gourry-fedora-PF4VCD3F>
 <A005B05D-A85C-4153-A65D-0BDF9D8500DF@nvidia.com>
 <280965b2-c6eb-4f01-a0ac-c4fb7e518f97@kernel.org>
 <ar5eC22VfSFlMw3W@gourry-fedora-PF4VCD3F>
 <44d15437-6aae-4d7c-bfd4-296276583826@kernel.org>
 <cac17315-7157-4f97-8ad4-98ef268f1b8a@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cac17315-7157-4f97-8ad4-98ef268f1b8a@bytedance.com>
X-Rspam-User: 
X-Stat-Signature: 9hahgrye1zh966jqwwybumeuo3kh4kz4
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7B43F40010
X-HE-Tag: 1790942755-750180
X-HE-Meta: U2FsdGVkX186yyVh7uBIL5tXjlQCdEhNjZuLqi/PhQgQV0OBS07w98dBshIAU7lu1/auLaAXZwMpcraPvm1R2iSKtkDnW5uvlkijQrXoPstZHjPaxVMERjAUI6q5WuzvLaqF5R0c2eCJNC9fPV2/tW/6Uy6oiVZx7tU7WSMZzIx91+j3rwx7DokgVhjy/0Kvt1f7InzC6Z1s+omm28sA0XlXQ1NDWBfDFyOYd4a4UEayN1mdEqh6aMngoyoN+qRpVK4OTBRr3z50DDjLck9p2a/1VxOyow3wEuKUM4tc+AXZk2Q80ZaCsnIMxKTGiwhuE3VtF7SKBZKbqOo+JRQdk6pe9O306/+b1uIcZuDzt26m83cU1V4KCrs/vfzVEd8kqnjZXUE9uO7nYQCPPIVr3jkEciVG5VzGTf/mcr6c+oLT9AOebbo2DSLG43g5KF71tQpRaJ1xlEkC6f0NBPVQRlNGd7ET++Ey0FKhh37tzgfAVwLm4iFqkGfzDQLmrKmc50TscxEqb6CkV5pwXjvXfxf9OiXrsxAztUrL1WWofumqW3+2nDvMaOSQiE3pyQHV411Z5bT0oIxdjMfu/1lFbNopcS/qARSQj28gM3l8mqnSKXb+yth0Rz+SlWQjOVLK8eOuTLOq4TwRfM/2YOFMWuVGrEZyHhV6lcTHa1Z6pjFzK2S82DWRmihOdKDkp7JZtU0VWC1lCZ6MV17mK5T6CQRsqPfF4+otTSoyVfr4794UbpJ+siQetRvKO8d6AIxSOM3oteBBIX7+Tlr8kI16X25vz4rolbLigpl3MAbxjfIttfEyMiy7P+rOdypZA0SKlzwxTwdtky1nA8Nc2Dq1elZOxcXV4mhSOXWF7b0SnoL40z5jYY9BLuz83V8PX5p5y8wJuyJvqYcAvxAEG1vTdiHgJ+4gbT5AvNoI4fxVS+svHDTpuCkTIrpEKowM/zMgXorhWpUn0jTS2KBGbnk
 GznESPPd
 vzwbIj1wCKCNx5juOU2fLRhRE6vDaDADD0fBU5LW8jSAjU3dQhMb5MM1RzhIzYMwiFKwAKeb9fWnloCBUuEo6zusRkyCE1iZ7OjD0Ub5s8GeqnQDEQvZp5ZVDQzW8goExo3Zp9htSYFDWHYdhbkof9VDA6IEDYudPuMUhb3fRifmDgEpqc0nLjjNTRjYIu/iAhtOLYaqFDKqaJvHEECe78UQP1ylkFBdKlxtpD/HDgLcjpf3uuVo8OGG4aX40CwJJgzZaZlkn5M8m2lKs637wCRhC7nCagtmo2j503TJpVIUqohQ2YUTIEdanjycHgNojMYJz+TmRlGM5t/pEt6C5Vb6IiKMjYgcR12g5dAUOzL54p8/uG5a/aMvZj7Q9LgDz13PyeO2X1mMPZWp/IStnGYV5r20MpBPV8newn+bmTE9G4U3yONAOtJROgwVAGU0yOS7JDD5xy2zu6WdwSD+7B3BLLoYvPoEFrbr7QBPsF6Xmm2osAVLoVGpvo6+E2PPsPbC8jirJ532RiJyRYQ5nfylAbFSRZR/3MKzz+dla7r3rtZFBTctOWj4NQrqMv/BbKGza
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 04:15:45PM +0800, Li Zhe wrote:
> On 10/2/26 3:56 PM, David Hildenbrand (Arm) wrote:
> > I can understand the "random initial placement will help if you cross your
> > fingers" argument from Zi.
> >
> > But then the question really is whether the app should then change the policy
> > after the initial placement was done and the weighted stuff no longer makes a
> > lot of sense.
> Yes, that model makes sense if the application or runtime can
> cooperate with the policy switch.
> 
> One limitation is that this is not fully transparent for existing
> workloads. set_mempolicy() updates the calling task's policy, and
> mbind() updates VMAs in the calling mm. move_pages() and
> migrate_pages() can move pages of another process, but they do not
> change that process's future allocation policy.
> 
> So I agree this staged approach is worth considering, but it also has
> some deployment cost for workloads that cannot participate in the
> policy switch.
>

if the use-case is vma (mbind), such a switch can make sense.

if the use-case is task policy (set_mempolicy), such a switch is
not a realistic solution.

In userspace we tend to use task policy by way of numactl:

  numactl --interleave=all ./my_program

This calls set_mempolicy for the numactl task and then exec's into
my_program with the inherited mempolicy.  That mempolicy is dup'd on
fork / clone.

Changing the mempolicy from that point requires every task in the
workload to call set_mempolicy() again.

There is no way to externally change another task's mempolicy.

I attempted this during the initial weighted-interleave exploration:

https://lore.kernel.org/all/20231122211200.31620-1-gregory.price@memverge.com/

but we did not see the need for it once we landed on sysfs controls for
weights.  In addition - there are MANY `current` assumptions hard coded
into the mempolicy and cgroup stack - getting such things dug out would
be (will be?) very painful.

~Gregory


