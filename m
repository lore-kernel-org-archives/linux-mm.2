Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77594109448F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 20:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18266B0134; Sat, 21 Mar 2026 16:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8AF6B0135; Sat, 21 Mar 2026 16:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B71B6B0136; Sat, 21 Mar 2026 16:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76FD16B0134
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 16:26:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A15BB970C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:26:49 +0000 (UTC)
X-FDA: 84571203738.18.AD70D60
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5E406120002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:26:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Vf5alblV;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774124807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0tEq3kR663AZN+wJIQdRtj/jb9LMYPMsRdvJZPaBgUg=;
	b=dNYRt0QsygpfcqpGlPivrP61Ce7JEhh8XiM5A078rooDQ6DjA/aisSZBnFgulOphPvhaNj
	WDHppXhq8KUDQVSp5aUOm9fqwgRuyzSb5OgjBGM+mVSbmjZvxWYbyCUKn4B3g3hF88oxDl
	gns2m2JlU3ugcNG2XCqBe+vnEs3e6eA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Vf5alblV;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774124807; a=rsa-sha256;
	cv=none;
	b=Pktg9vX5OIqTwgEE917CVAcwIWfWCTOYsNH45MZcIjK7+Q91drimRBGHzrYkLEsFScGo9J
	X2tLD9m7CU/g7ycHC5wxJ0/u+/qVeE+BgM3OWAKt7cbBGz8lGfDzeONVbyoqX6NThZ+tCK
	8rbGBRQAi3j0CNm8A/f1KLlJIKpZLt4=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cb4136d865so212732885a.1
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774124806; x=1774729606; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0tEq3kR663AZN+wJIQdRtj/jb9LMYPMsRdvJZPaBgUg=;
        b=Vf5alblV7RZVoFavpvArCd6Mxylnvy6rv7eh9Cl93wzF3UR7nZLnq6/hZet3/hQCID
         2I6JDimyeP1iCZqHpeHyga6us8EeczdvkbPTj6nDZxr93zjuYNpTnkGEgExvj8R1QiDI
         st2FSen5R/i9AxM/zPts0HnZkHT4WYJDMaVbBCHmcxzMuMQyiSZZHT054jhNVJN/0R5T
         NC34hrgA2p4jvXewzpYAySqObW+PJQ/huB++CdrVe+EPX+I8fhnbrOM6xS/nEZMGNtpi
         d/+ImeQHF/w8TB4i+JEwb63TX3lKKe40/22namWwlj9sRsOklDBgyo5yC+cUr34VZSmy
         9yHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774124806; x=1774729606;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0tEq3kR663AZN+wJIQdRtj/jb9LMYPMsRdvJZPaBgUg=;
        b=QRE+VEwxtqzeFCmBpV8UCGijGZlAx+SExMiiQ8EMScF1DxtbrqZTeU/1cItd5ODJnJ
         ZVW+mxDl4YhKfp5VTnsv9ILZyg8QFkuQzifJ77ngRHc74Gdh13+XSkPumYvbqY7Tn0ux
         KVwLKVqYSDcrb3KBhdtkbe/GEZO0NzGW0MFf215pEsmXB1O17JuJNG24xYDKDiCHP+dy
         7UkCaCeVLuWvYDMyUqkNwvEXfEJgY5PLj9GAcHgwkK+LcxH133pExZREaFEZ+l+SVg+j
         h+JHbX6BMevVOXulBLD9qbTCmTlNU/DG3ewyXyIjA4arJ7e1h8dgWCjFgpLtQpQbM7jM
         LBBA==
X-Gm-Message-State: AOJu0YwvGGn69w6eHHeLBcNJGQddzdbGRrd25bvEObXvQyIyYa6Gt+aC
	NCaYSDwmPDCCbTBJsEyPbTJeeNLg+QLr+mvSDZ4Q72qy6cRY5zHS0dv+WpV/5KVPgn0=
X-Gm-Gg: ATEYQzzjpvptRODrApubGCn57aOr+uERWtZRlFl/EVluvNFpWjwZT0WWUPImVTMYclE
	3//n/DBYaaEUqKg0dpsZCp7/PzQnVkuPHQCWC4ouEmi4UFA2nU2AqHuPOTW46Zk7zmpXVP+LFiD
	wLoYbzumzJqO8Xi7XzQPdcVTn4ZFu925Eh69l47kEvg0RcStNuIOOl1UQ2Xu+R51YvBUoAb8ufk
	heFlLHph7rAUupYGdpqiquR6RarmCiDpXtgwrOk4w8Bd/q1atPKuulwzLWyAaPSN+de7VP3FFm+
	yW8eNL3kIc7+8bdzf0Mh+Gp9WOPhYZBma18j66jZsoDu23gmdPrRQiYfAOCm35h+TOM2TZ2jHKo
	UtBB+JaWUEwlKNNaLxuH24qn48kW7M+29cfTqJ+bQf1qVBqq/9GiLJ698vfVoDiCGg1DQCGddEh
	WA4K8aUFSlw9ofSDnJa8ICHPvU21UgOMJDzLWNjlfoxjFLApSa1XlaGC0l9lu9Grwd64bMakKFv
	BcxFlfwJQ==
X-Received: by 2002:a05:620a:4010:b0:8cf:e19e:b4ce with SMTP id af79cd13be357-8cfe19eb50emr74563885a.71.1774124806341;
        Sat, 21 Mar 2026 13:26:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc9089bebsm467118485a.27.2026.03.21.13.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 13:26:44 -0700 (PDT)
Date: Sat, 21 Mar 2026 16:26:41 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	david@kernel.org, osalvador@suse.de, dan.j.williams@intel.com,
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
Message-ID: <ab7_AVLgzLaDRcv5@gourry-fedora-PF4VCD3F>
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321104021.4a6074330131a2058e8706bd@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260321104021.4a6074330131a2058e8706bd@linux-foundation.org>
X-Rspamd-Queue-Id: 5E406120002
X-Stat-Signature: 3df4t3i9x19ta4wqcw6rxg3egt1bwbbz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774124807-576901
X-HE-Meta: U2FsdGVkX19IE6BeBOpGd+wmp6IvQXqP0XPmvcYXCT9ht7wvx7ijHZhhZB7hlGmqzlPmETKDxKz/VX2CFfP1ROzBg+thTie0pVg4IXTTjFIUbWS0ba0c0SBzeYtExg1nEvgx09FqacXZ95j3a/4p0j3H08GsZN5oTjD/IYt98lTKGK3cgk6h5Dt5MTVddbO4jE7GJwmqgOYJtTAnENEe70h3k+8JtktOwsuaqUITmIp9/oArDH8rMFraWmrvCZHSAwOrnHIPb0Xq1ox/c1ly/1gf77YnxsdFjo8qBNH7OPKkEIjFLAvHJknalB2OxLpCEblosdFd0MfEGH+n+Icn9HLMpVNReEIw2vivgT860NbmLnmZPsioyIMHjdf1+v/xj4uxfVvipvVlTav7jFy2qYxgMulHInhEcB/Kl5sYrtnNGxYW+S7AW6IbRfqCjYNSs8mdtoEixB4sDLpm3U5DYtA2AGQiFdv7wzpgyLgNDpDrGd1rUUlJqy+GW+maRMhl6Epb9BzPlrB4xSSPF0bxa4g1WdU7Zv1UGhOo9zWoj4wc6JX5REr/rMGnhgjnjN4GlWLHqNghwvCPpJqAuN0/iSIqy0cnhHT8tqhcxu0TQLNP+pMaCcnqNGVDu4bmzARdSZbzKDCDjYpIkSW0UIJk96xzhRq4Dd9n0QSVYYsnkMCzUlLpHDcjS2RIv4jt7HG3C8RFfk4V+0tFhHuLVwyqcolIaSso1rMJnvzpjl2NgcmqE7AG86sqknmsD5GLmLbf++TMbbky/UpoQZBiJdCKChLFopMbvErB9xkWyd6VvnweyuFCpudII5/2vPMqTD/l+/9eEHWzICf/13hxtnfy/Jmx49+Q9MleGEgKVq2pW0/lYn8C0KK05pEnpwND7l7UflqkjkvuCQeoHBIU0FHsu6jo+FdVRIWmJEj5Yb4hiaFphwETbuFZsIdvVt5Irp2m/QzkLPitpW3mcC5J+2+
 Lb3zlhO8
 M+pOKJnRAdgR6h+/uFr4FA0nKf0mH7uJGRE/3yJLguVfEl7RK96eON/bsvvZ7n9kRDOKBqsfwKl9y5YGfmLQIbnQ53ycUEEMtsHw2jDIoEA/xFRyKGyXIcRqi82OUpiQjqTqAc7VqWBKyTRsu+NIVSd2R6bj2z+vm3WRA5sOLEN42ui86hR7hN8NyB6nOBpE5UQK6uWDxOq9BctVrcg5QQwlWKp95Wyp5EaiaN9AyYW+5Gk224mQ8Eqh8yM2bZ137okmmB34ZBh3HlPX+oMvjBTZkxuHGYzkHxGEG4fZxwGDILs3lMP8D457sOfFGuboKCWq4HncD4Xj7yWztSn75hEj51kGbZRvm0IEB/GXOWO+KwNLYeY72sNP2ggXZzE2nJLQRjXgfBUdOYnzwbd09NnrreYlxoN1xWsngDouKZBjbSXSsyCyhHZGZpeIQ/pRwrksOytxnTEKGXOoZNMa4lZN/p9Ocp/9YAi+QMOQj61Tdj7Ej0UcngcGCRfbX65h688RKWpAyTel4bEj4KXu8CZdb2SlzbBDzE2ByI0H9rn1NZVY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 10:40:21AM -0700, Andrew Morton wrote:
> On Sat, 21 Mar 2026 11:03:56 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > The dax kmem driver currently onlines memory during probe using the
> > system default policy, with no way to control or query the region state
> > at runtime - other than by inspecting the state of individual blocks.
> > 
> > Offlining and removing an entire region requires operating on individual
> > memory blocks, creating race conditions where external entities can
> > interfere between the offline and remove steps.
> > 
> > The problem was discussed specifically in the LPC2025 device memory
> > sessions - https://lpc.events/event/19/contributions/2016/ - where
> > it was discussed how the non-atomic interface for dax hotplug is causing
> > issues in some distributions which have competing userland controllers
> > that interfere with each other.
> > 
> > This series adds a sysfs "hotplug" attribute for atomic whole-device
> > hotplug control, along with the mm and dax plumbing to support it.
> 
> AI review (which hasn't completed at this time) has a lot to say:
> 	https://sashiko.dev/#/patchset/20260321150404.3288786-1-gourry@gourry.net

Looking at the results - i mucked up a UAF during the rebase that i
didn't catch during testing.  Will clean that up.

I also just realized I left an extern in one of the patches that I
thought I had removed.

So I owe a respin on this in more ways than one.

But on the AI review comment for non-trivial stuff
---

Much of the remaining commentary is about either the pre-existing code
race conditions, or design questions in the space of that race
condition.

Specifically: userland can still try to twiddle the memoryN/state bits
while the dax device loops over non-contiguous regions.

I dropped this commit:
https://lore.kernel.org/all/20260114235022.3437787-6-gourry@gourry.net/

From the series, because the feedback here:
https://lore.kernel.org/linux-mm/d1938a63-839b-44a5-a68f-34ad290fef21@kernel.org/

suggested that offline_and_remove_memory() would resolve the race
condition problem - but the patch proposed actually solved two issues:

1) Inconsistent hotplug state issue (user is still using the old
   per-block offlining pattern)

2) The old offline pattern calling BUG() instead of WARN() when trying
   to unbind while things are still online.

But this goes to the issue of:  If the race condition in userland has
been around for many years, is it to be considered a feature we should
not break - or on what time scale should we consider breaking it?

I don't know the answer, David will have to weigh in on that.

~Gregory

