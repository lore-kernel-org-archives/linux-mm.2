Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FF1BD711CC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 23:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30CE56B0088; Thu, 18 Dec 2025 18:31:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2904B6B0089; Thu, 18 Dec 2025 18:31:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19C246B008A; Thu, 18 Dec 2025 18:31:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2616B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:31:47 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B09DD1A037C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:31:46 +0000 (UTC)
X-FDA: 84234191412.10.46D8707
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf01.hostedemail.com (Postfix) with ESMTP id A99E34000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:31:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o0KKnWqM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766100705; a=rsa-sha256;
	cv=none;
	b=gJcz2BFNaGqw4EijB52q1cMMmnUed2p3U15RrHNGXuEqP4Txany6eFCd3Ol32JYTCE1dQv
	V6yQm62xEtHO2TKyK7Dz18PkA/XVSjmZOn7HRog77TaA3lc1aKhxwNgw7Y+Z/3Ttci6RJo
	Dpqb4JSRCSs6QF4s8aEJNWFb9uz4K0Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o0KKnWqM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766100705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8VKav4O69WKEhvec63CJZ4iBv1RZ7WNrH0T3Nzbeb4Q=;
	b=vm3V00BMl3QZwttekzqOFWbhPmmroUsktbi/nLGQ7WTDjUP/DjLGMLEw0n8Cl6AcsfreGx
	XHfMcn9iBwBBEturF6JOHaDoQTMF8ruNzGCgfP39ZfcEON8FaFEOixEH3zCqKLU0hInR3t
	US4QS6E0g6mh+kZdWg/7A1atby5IO0w=
Date: Thu, 18 Dec 2025 15:31:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766100696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8VKav4O69WKEhvec63CJZ4iBv1RZ7WNrH0T3Nzbeb4Q=;
	b=o0KKnWqM/yRIom/QzfkZRdzGFf/2sloCtNG9jPrrdVJCsfvcTvmpaPU6XyKV9YQKkscGhV
	4jidqPwyvlRYrdhJ0F1OXUQYSEAZCS6UKsAYFwUS6CF1GiG9jvaBQfJHxI62Kd8BCghgXI
	eULWG7FJJNf7hkv6dGB3pPe4uRpCd+I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Chen Ridong <chenridong@huawei.com>
Subject: Re: [PATCH v2 01/28] mm: memcontrol: remove dead code of checking
 parent memory cgroup
Message-ID: <qazzssy5v5qpyg3xdamruibcpcd3cry3yywicxvaeq66hejcn3@snvaivqo52sw>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <f96258f164779363fa894d3b278254e352e39088.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f96258f164779363fa894d3b278254e352e39088.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A99E34000B
X-Stat-Signature: uk7c1aubuemu81g5mu5ir6dsr6ch1zjy
X-HE-Tag: 1766100704-869887
X-HE-Meta: U2FsdGVkX1+YzKx6sDhwb76x6ga4ZJcMoV0c4F036BddE8DTpcIGuRVHHKj/5qLBkTkQ4pVfCIU13ak8etUGIbVEyUDsHr4XuFeSD1jHdwb1rf94nsN/oWuIbupV+ouzAqpwBuH/g9whJ0fI3/CHe96rwG5LbDDwdQADT3PRyBumEGQjTF9prc1HImWtfenP6OBfR+6nUWqNzYm5xnpPw4DyRQeiCFvFKVKkMJuPn8tNJcOXCpt+EJNtkroR4Un3ap0Yi9eUXE597CI1mcFGpMxROJfgtYyS/P/HARJGToWcIe9W03l2LVi3RrAK3ctLRRSlNLKAtz2VKkv8BKc4x5JG3ee+dkzGBzI5/xakMtFeDQHZTqdmZNn8Le11d3uWV0ud9Q2iMczRJwjihCP4HZZYbTHZlY4fxk7t/deXvZyeo1s9nlZ29J8dmi1pMdgQoilx+ejexpifZY/gQkdFYdoU+GmRJJskOCOyFzRZgTglSWSMGIQr6aF/GAZ82LLgmbpdUW6e7ngXkpeu4hi1sV2PSIbqRXyHYcE1ChdfKs75sRss26qjEfIZYUthhH53T9BdyibBU/9HzApVtGcxgqvSXPvs+/T/jNAIFM0jTJ01XvhUmg4XQhXhQZV3TdnK5da8OGlD0oj/2rQXvuPN4x1wXdCrF6WjIV1pXCwUkWkjPlnMhlOqLNYQEfliC0CCYjn70ejPA14KdZnPo6yHcH7S5zHTb27Np/EJoNmcE30hEgaamoDXFSN++5fajIsgiSCzE+L4sUg9kqcq8bhr3YS68CffDyuYZUhtN1NJ1S8/fHm8Wjd++0dAV+8goVyC9d7n25HCr9XWnPYIZgZxHFiuNfzwMu/8wbuP745Hf4gH53u0slbqZ47xQqj6meXBaPK9KFEsE5x7LDvltOC09P9vyWylBPKrgxPx05Bt3FzyFOey/XLHD8dZhR4bUGognyLvphv6AIxn39IPbia
 BYJaGbVP
 OivW8K4JYVpFcpZ92yPScNDh5DpYoKF/Krj5ifXU3gDarMHyPA+XidRDcfGNaDqa9XK6EJN06v9WNIiJzAhfNkjLa4djX2ioP2JVJvfmRLbqdLF3ze2FxG5TRtt82ERW6aW59egpFUWGiEFDsAx3A6qhcfHwOjnYB/osSlZ9BbclSx+Uc7QzVjbcTC/2xIiZZYD7pUrX+LkNJUsfPdDe+C65zdL63QX5Exj1CVlX4oIjplKX1dpc7Mo9wcUJL4wOY6zOfgpeEBDtrPpRmmXg9r01L/Bw4SYYIiZysMqLxRFWtkvSrhYFefqTVNu6uqk/9D5UKy7+tRljQZ2sPrxwujT6CuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:25PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> Since the no-hierarchy mode has been deprecated after the commit:
> 
>   commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical mode").
> 
> As a result, parent_mem_cgroup() will not return NULL except when passing
> the root memcg, and the root memcg cannot be offline. Hence, it's safe to
> remove the check on the returned value of parent_mem_cgroup(). Remove the
> corresponding dead code.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Chen Ridong <chenridong@huawei.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

