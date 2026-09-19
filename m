Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9DBC982DE
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 01:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6DD6B00E8; Fri, 18 Sep 2026 21:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2974E6B00EA; Fri, 18 Sep 2026 21:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D57E6B00EB; Fri, 18 Sep 2026 21:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBFCF6B00E8
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:08:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E611C0179
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:08:03 +0000 (UTC)
X-FDA: 85228725246.17.7AE72B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A9EEB40006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:08:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZI/HLxis";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789780081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCVvrn5mtkCx9ECwLg21MykICw5oc97e2nLzAerD+CU=;
	b=QvKfUadgofuBsh0cE4lhQtU3pQS+fcJioX7bjK80eucEfzP/0Ewe7XrNJRu9CVGcqnfjoq
	FtM8RPgQ+x/5XHQp1jHvXyQJZCKzRU3WsmZy3a9iuhFrPMovlrcfdmKINjZNu/j/FQB9ZO
	I7a67yHr/MDKbgJ8itc8SFnIOTSokFI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZI/HLxis";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789780081;
	b=AWxEmTVWa2u+lEGwD/9GIEiLlBiWuIp3EGzjK3oocJmle1LCid0LBbgWkZ/AxorqK3uRe3
	ZStK9JvidhxsfNpFnMW0eK8F87OsbEpiwjEIb2G/AIXERstxFTkZSCbrDuET6gPcWAs7hG
	yuIvY31Nhpygv7F1oJe2Qp4ZOzUZGvw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D20B3405C5;
	Sat, 19 Sep 2026 01:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F237F1F000FF;
	Sat, 19 Sep 2026 01:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789780080;
	bh=RCVvrn5mtkCx9ECwLg21MykICw5oc97e2nLzAerD+CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZI/HLxissH5hH5VDuH3i089DYmp1O3fYIaNM5DY+R8eLixtF6oEfmgvWwTDISc5Cu
	 lSJxNKR+PiMkM7E/ggWhXKL8bAZTJykq9gAFzWPcEeJSMT+cBw221CQCg++mpeeKWa
	 Q+HChrw2Md+Hn7cEiTTTeGbSy8KMbFw7vpA7JgePLvxRgp9gldPIbOqhQRWAmYbqv1
	 zVC5+RMxS2a+AaZBSxPsETAIUTnyir1hMq3mnVXIPWllAq+fAdvuqbbwT8cHZZOl39
	 k9gjA9y2umYl5zfYUz3a/1fkzNSuNRdJHO0oAecMarTmeXETMCQMVY1hWSREuJBLT1
	 CknYk/ge24rgA==
From: SJ Park <sj@kernel.org>
To: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+c61d6962d0b7e698439e@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] mm/page_alloc: enforce upper bound on min_free_kbytes sysctl write
Date: Fri, 18 Sep 2026 18:07:52 -0700
Message-ID: <20260919010753.88198-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <3c1598eaff225a155cdec5e92d5c97fbfc6c00fd.1789724312.git.med08elkadiri@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A9EEB40006
X-Stat-Signature: pknmojcqjodnhbnu3ggyjigqhc5buxjc
X-Rspam-User: 
X-HE-Tag: 1789780081-245435
X-HE-Meta: U2FsdGVkX19KmQtFmMOt3GIoHqB2LSGjaWeRkzZ4n6Rq9cGtKMk8N70wREBXJj0h7Z1y6BqKdLczRRoeNb6L29zgt3WnDMs0WpGWmUM0sjdcUJLoWt5pxBuihgfg6f7dlSSIhvWCnehJDqZYOG60qeGAULAv1WAByRoSbYXRstxDV9w1ZgXWvToNIfkKT2uIxIYsSRWcLCC5jM5b7gwgUk4SA+48yPcY3fc7pEpOI753o5mjtEkqTkD0mz8cQMaswgSsWQW/NzALQ6jGVYiEDYoZ1UyXPgeK2L9y9p/4eBu5w/gZKamQ8nL/EG2dO7UAKhC7aEMWb92EL9mgWVi3+i4SMwoxLADjsFjP6R8+D32aQgQr+baj1skGMQ61pHG/RL2Sa+tJ1XZoAoaoKDoa0LnOlOlw3hvtzZGyNQNFomYM+K9ngbffljMi5sOLBS92MKp1YJcnjo8Vz4T4cfteWgMyxGr4J4hj9ab7yz/DZbHVPx4WC/oMMMuYssfu9eJ8bmR0zZhIaaM6SkwMiA4X61rEJzGh1AEe4NsIHNkIG8zROn+ocijzFV7R0z2JgymXGVBw7WloA3EmHMtySCounFUL1nTcq7D/r1UJ+k4cuxt5TW6exyQG211KCVMxz4fgGb10BDMQhqp0m+33MO4OEbidXunNW3nBGLWBp02bByMtHmOQceSXIOWZA40N/reSDCv/WNSJ9dzLLLPusvv4OrD8PObMwIoaLTuwVssxSXFnqa7J4HYKSmKdQijrVw/FjlkEC3PBU9V0EpaxK6ckvtE/dyHe4JAX49RbBl50qXxSllrJzKaBsicK3XvrhnhO7hcIdrIgUoQ491Qbb5uUJZfQ1y0AU/DQywUWHdWGmj2fwdNYGkBRKfenfh1qnio8izrWXcvPEPgNsRnnbqc0mij1dNigBQAZncSnhvtOcYxXB8Gfnxv8tYLMZzJ7UGgL6/XTMNasXZLnDQIrMM/
 pc4+CaHc
 3siKcp16dKVl4ImFAGIlryIPX4X8XsdEKPX4cjs87h49ObWuSvBkJ70d2v41ZO+xYfZDdb0tOkgAsxafF7kv8ItdXAuBHpMWasBLGtsr97zlQbXE+PrBGQuL0j7+q2noCTmVNcxxoyDIwP1un8bugl9vJ4HFo16mE7zCarG3xrkP5ALsrvq4dXbcKw9OXgjfzXaFztbnXt/kHuV5/WDWK/Ke2wPV5hQK06z5Qun0iACmeoZTvdYz1f94ww5gjciOG1HhsYP1zh4TnTyU1xabvPAnovvYl8zqAR0ugNT4Egh+hZ4FQnDzP9uIFjWJmV6pqNVfz3/TJYWgpiJPAgDUaUvZRBczj6xLYGZgxwe096ibdj7pn1/RctkgEi1T0WaGWP+dlYq+JfZ/6ynGXsPPQcP3mOuW5U1zOCkim2438EMZgkNG3SKEgCmih1wdg38OuMqVTLttQo8Wboy0wZn4jGwPktNdJ+vM4/QqYjdZ6WynYNTVcracu9O50U1k6T/8rdqWR5P1baIzmvrijGZ/HX/toQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 11:45:51 +0200 Mohammed EL Kadiri <med08elkadiri@gmail.com> wrote:

> syzbot reports a kernel panic ("System is deadlocked on memory")
> after writing a large value (e.g. 3145728, 3GB) to
> /proc/sys/vm/min_free_kbytes.
> 
> calculate_min_free_kbytes() already caps the auto-tuned default at
> 256MB, with a comment noting larger values don't make sense even on
> big machines. But that cap only applies to the computed default --
> min_free_kbytes_sysctl_handler() lets a user write any value, since
> it only sets extra1 = SYSCTL_ZERO, with no extra2.
> 
> An unbounded min_free_kbytes drives watermarks past what the system
> can provide, so every allocation triggers reclaim/OOM with no way to
> make progress, and out_of_memory() eventually panics.
> 
> Fix this by applying the same 256MB cap to the sysctl write path.
> 
> Tested on top of upstream master (5dd1818b15d9):
>   - Before: syzbot's reproducer reliably panics the kernel.
>   - After: writing 3145728 fails with -EINVAL, normal values
>     (e.g. 200000) still work, and the reproducer no longer panics
>     the kernel across repeated runs.
> 
> Note: this covers the reported case (a value far above any real
> machine's RAM). It doesn't prevent a smaller value that's still a
> large fraction of a very small system's memory from causing the
> same problem via lowmem_pages in __setup_per_zone_wmarks(). Open to
> a follow-up there if maintainers think it's worth it.

I think the idea makes sense.  But I'm not sure if this user-visible behavior
change is fine.  I'm curious what others think.

> 
> Reported-by: syzbot+c61d6962d0b7e698439e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c61d6962d0b7e698439e
> Signed-off-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
> ---
>  mm/page_alloc.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..8cb62879bf41 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6933,6 +6933,9 @@ static int percpu_pagelist_high_fraction_sysctl_handler(const struct ctl_table *
>  	return ret;
>  }
>  
> +/* Cap sysctl writes to the same bound calculate_min_free_kbytes() uses. */
> +static const int max_user_min_free_kbytes = 262144;

Would '_user' on the name unnecessary?

> +
>  static const struct ctl_table page_alloc_sysctl_table[] = {
>  	{
>  		.procname	= "min_free_kbytes",
> @@ -6941,6 +6944,7 @@ static const struct ctl_table page_alloc_sysctl_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= min_free_kbytes_sysctl_handler,
>  		.extra1		= SYSCTL_ZERO,
> +		.extra2		= (void *)&max_user_min_free_kbytes,
>  	},
>  	{
>  		.procname	= "watermark_boost_factor",
> -- 
> 2.53.0


Thanks,
SJ

