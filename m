Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D28CE8FDAC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 18:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 191466B0005; Fri, 26 Dec 2025 13:17:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13EE26B0089; Fri, 26 Dec 2025 13:17:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03CEA6B008A; Fri, 26 Dec 2025 13:17:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3EF66B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 13:17:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5959C8D717
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:17:42 +0000 (UTC)
X-FDA: 84262430364.06.05B19BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id B0849A000E
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 18:17:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dsbjGumL;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766773060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vl17TlHAKr+9kfudvhf2FS+k6gEqUUoBDzgrBADj76Q=;
	b=zAwsIbH7Hv5R3wz4tFeE8Qa4yav7IMK+Qts6EWSHjpSr1s5/dn/4klVtxfEHqjsTtKeNCc
	VzWWWoUSV/1UvztfcFOdx/gRsb7dzg8UdWUHHaVkGKubrFC60ZiK3lYGmJqK2pZ8FokBsn
	EF885nYEajRC16Fxnj4EFi7fVYcBz2M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dsbjGumL;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766773060; a=rsa-sha256;
	cv=none;
	b=p1RpPuMe+MyAHLh44rvv14wfnz6s5dnoC+Y+Cn2+xLDhYSjRYtguCDIHSCIYUD8FOSoQdu
	XIL/fUiwusXv/tWuua+Pgmj3uOr5xWN9awHdM5IU7ngUZpGLnYzrzez91vnRSmJskNfZj5
	FvdIGQsufe0kwBeuV/+PEClib5qtsMg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8265443594;
	Fri, 26 Dec 2025 18:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B29DC4CEF7;
	Fri, 26 Dec 2025 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766773059;
	bh=I4DtpAEe9pLppwYfVT/mO+qel169pwrd/tfT2MBTRxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsbjGumLVwJc/4y9+ZeaZREUs6T3ZyxF0vAA9oRakEDJrE1taq9E2XyZYoxCNiYN6
	 8aguJVVAYLswk80lVNBnQ1KDLKR6uaYRFXDS+XqZP0zaS4O1iv6h8JLShxL3e+3bMi
	 psMF2SkEGAo0WWYvRoR/oX96tG0j7GQjK/HpnaUaaGyjn3gMpCRBhWhUjgfxdPTEAn
	 USQKrxjnTJLSBad6O/ch22wjErppSbJJUwn4K5m8N+MuZlkhDNdW1TUfwRGgO/2/7h
	 +uWJt72gBTZS92uyZC52AMfllMur92wE3WbeGn+PdYlp/xWSYOYOPs0yhV6TO4oxK3
	 lVa7lxXUXUSDg==
From: SeongJae Park <sj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] memcg: separate private and public ID namespaces
Date: Fri, 26 Dec 2025 10:17:36 -0800
Message-ID: <20251226181737.254305-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251225232116.294540-1-shakeel.butt@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B0849A000E
X-Stat-Signature: ro9rhmotci3diixc5e1ioqgji5pwzddm
X-HE-Tag: 1766773060-966294
X-HE-Meta: U2FsdGVkX18MKFOZIwiKl4Mqt+5ZI8lgI6l/cajZ9r6izGE5api3zEDeuiseJmHIiiEQkI8XfXHF/MqC6emc6o3LkDjoENIhW51WMMKm7nbo+A6Kj/ddE5EyUb8PsqXhBShNO8A1LN+MyqwsmiBA+Eb2EeNpMuMpcVt6tMi79Rd1Z2sEl0eApYvdROZ56h6JCz7DuavlAd1zjGCQqBuqgCLmeMYeNmMwvHehK+YGGJ4z2i47WnrPViQuUwBUMCxnCzurqHCAZc95RbFxucg/3DiCRh+xN899TnWJOwNEasUCtQ5pKpCs9QIqemPhW+gKn2LBSyKjK03JGYkHj4a0WaGen085oY7/bzz2URQhBUjp19ZsiKSY74LEFRDzjWrjrqIKKvpZUMO0bLKlaLYs1g8UKkB+cGR3SsrPDlNB+j1bKV/ifOeyu/4Z7vvnyXOBfioCy0buOQt9HqIt4mlAZVRafeLoY8c7jryCS0OGBVCfdO0U2bKONCvMz85shkLDduZbHxWaM67UeEWlE39/D+28/bmW4sljADor6XWfIDe3euB9glDOc1Ied9D+SageLRgTsqhawVQn2yvFp+uqXkmFHkn94EoUAB78YeWjGg+RWVA697QOKTkSjC/+wlm8ONtOSt8rmbY9w+hGLEEOAy/8LsLPgJwNFuYgAXV8pxxvgqLk+SYbavayqySQSr5ZY5EnSVN/uVIUwi5nQ97h8dPgFkA7DYzDSCmS7TO2I6TSAJYjjQS3a8vcBJWSBS4HkmW6bsSPqfP3uD9DdrqL6NKAOdK/WCs2ADarzr0PdHtdlTOIv0y2w8Nw+r0d7MIH67MPV1uafJlWrMUkqr1tryCvjfWfaIJs9dgN41+IpWLUULLDuqjjjU8HBwjJ0uFv058Nt7u1LXRMEFj3EKOSuxR+7M1WjIswuaRlsKkHhsvO6zsdIgZNZDW/6V5SuuJjNMtDekNwgdUDE0sbMD0
 5kBM00TH
 5WGHGPPqlDTI9Q18rMFYGlMdvECxT4MgWPD8L5ZuY/TppfbLzkT7MBRUCj/n+1riviRSnup4r+x35wtz0v6LGYt3On7QVlGGoZ8OGJOAkV/tLgpWeweaQN/AvOuMD9t6AVRUdOMhx8hhEE3HuqFyr8e6SKpq3T3xzAkc/j0ofZddoif6q24KgKHPHFss+zfKLbfVu5arghIF2P+Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Dec 2025 15:21:08 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> The memory cgroup subsystem maintains a private ID infrastructure that
> is decoupled from the cgroup IDs. This private ID system exists because
> some kernel objects (like swap entries and shadow entries in the
> workingset code) can outlive the cgroup they were associated with.
> The motivation is best described in commit 73f576c04b941 ("mm:
> memcontrol: fix cgroup creation failure after many small jobs").
> 
> Unfortunately, some in-kernel users (DAMON, LRU gen debugfs interface,
> shrinker debugfs) started exposing these private IDs to userspace.

Technically speaking, DAMON is not exposing the private IDs to userspace.  It
does use the ids to specify the memory cgroups in kernel space.  But, when it
communicates with the user space, it uses the paths of the cgroups, not the
ids.

> This is problematic because:
> 
> 1. The private IDs are internal implementation details that could change
> 2. Userspace already has access to cgroup IDs through the cgroup
>    filesystem
> 3. Using different ID namespaces in different interfaces is confusing

Though DAMON is not exposing the IDs to the userspace, I agree it is better to
use public id, mainly because DAMON doesn't really care about the
cgroup-outlive objects.  Also, it would allow easier change of the
implementation details and make more consistent kernel-space API usages.


Thanks,
SJ

[...]

