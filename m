Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31010F531CE
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 00:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EC116B0088; Mon, 13 Apr 2026 20:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C1C6B008A; Mon, 13 Apr 2026 20:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B14F6B0092; Mon, 13 Apr 2026 20:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 383466B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:34:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C768B8B549
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:34:44 +0000 (UTC)
X-FDA: 84655290888.06.EBE4E58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3C065180003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:34:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jg51ZdQx;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776126883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLHJnCdWa0Cw0/5pmrSPBU0Rz5KofOhsmRu+dPHHofQ=;
	b=Htfd8bmIM85HDPSRi911UFsX1zw5pq0oSLb/Q0OtspvdVhCHACYmm4mtmYKcORUS+wP8W5
	gx4pxPyVEY8Qy3C4NKsSQJkIewACEPq3TUgZDZQKaZr/cE0z/HIHFh7SrTbKB2DwWFdN0u
	hUqoO5VS0m4GjsFvTDCVJ/Uf8/0WYDg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jg51ZdQx;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776126883; a=rsa-sha256;
	cv=none;
	b=v8SOAMxYyMILOyjGETbgwV5bnx8eWrXsC/cIBFSQwnQq5q+OEy8IqRIhS4tyJCrCu4IIib
	+X5fRtqlRBSNwKiQzp9dJR9ZEQ/qinWRzK0BqXKUnkbAkcL+F6h9nAQLo/k27A1ag34cpl
	TBIJsWn9cl7guKkmohxzYMyjaD+ZCQM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 66A0660018;
	Tue, 14 Apr 2026 00:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBACEC2BCAF;
	Tue, 14 Apr 2026 00:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776126882;
	bh=rKC/FuSHBQjUqfWFKqtW02kqh5fExR6jEuIsswCLAQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jg51ZdQxMg5FW7/m4sfIFrbXt8FLCSi9kR/RwRMzsKhRmnFDqEdL8L73RM2C9B3wh
	 AJler8tDrsVk0/yJ6fuPr1AnNbEDbMlgCw+mNwSqFc0drWXFj8kXRyUPKOF2VWIpJU
	 /F0gwD5nupZWX5YscBMpB1wUl+5yFVa/eEp2Ch74vLWK2xbUziYv++f2miXuK6BgUD
	 0FfZx7vkDFPY+XSQ1T91DeieSxicbpAifRVRKRJWbuwGJN5Sz56Ll870Du2roybCu4
	 UhWJ229SsK4sbL6NhFlcYmRYB/HjlgcdEh5f1tbKr/LetZgP9W/1e1OAxQvZzli3+Y
	 yjms/F07QveFg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] mm/damon: reset thread status parameters upon kdamond termination
Date: Mon, 13 Apr 2026 17:34:34 -0700
Message-ID: <20260414003434.83697-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414002300.83328-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3C065180003
X-Stat-Signature: hhkxupwcpwm7nbkqozjikmcjb4foxm66
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776126883-8458
X-HE-Meta: U2FsdGVkX1/URL3g8ju23+94bPGjvnLGU6bZrBoym4Hy9uv+AmZkjgmYkZ0Kaow3v4Qn8T2d4agJUmt6ZQKIAqWFj7Vbl3fXEIK5iY1d/0L7tsq+Od0HUZWVC1Uapk2WQF7nhWxBuyJFzXZyOda3dUWhSxmZFu1KPirJpo8hmyqk+vhnhki0W1JKVBnvL1yUYhqg0Zj8u+Gj5fwxQqIgSK2OLOeu9nirPLSl6l8IIGXfoKs9uojKDHd+N58uz3hDzGuzT6xsFw0YJcaui/XD5sC+hu1iUkIzqyIaNF22ZEOCmHlFq2k9ufSSDmFCYlXLHkvCSLclxWPYFGA1sDq2UAqJGG3gtUC87Y7l6LTc+8YPjYX4DeR4ydtqB0bYa224jjy44PCz4ZzySo+g30EJyx5xl061nEAuQq/Pj8JsCZMjuO4mRP9CwrdY7M98rWhs/R+1nxonGGvvAsXaeoQ78K6SsOaVG6wk4x3RGX+gB2YeuwQ8Cjwr2PT2USWzTNHH8KvWx6Vv/TUlm01/3m6s53UPvNSmi9S0AEsYgCKboth90uYESRMCr/dwyLKn9cVkErpepllY9vg2bnfiW0+ff4rfPnM1pKVoMV7rJRFh+x7FFPKJqEuCJyuGRzQ/p9apVcfLFN+KVA++TB0LXdF7e3pIYGkzhts2EaQGPTBeA5NlCR8tj7kyYtdswpmRe3KSWaZyWN+8pwh5zw5TSigxkad5CbrdBritPPeIsQKhR03sJ/sT9qxW7RSNyebY5JdUYCTEz1tp70ciLT+uYY36R6xJkRol3NQCv8/cUcEJmWp2SniaRar9CLReU+uRy157r+o9oamA7CDjIwefW8DtxRyYGgGLLYFWazoXRpOhzqbiZHHh7QsHy+6aU1RzFoiaavThQXXRBkgn+0OAe4MB04VhB6MoHBLnRkBis+AxkPW8rzAToG8TqoDUlrpTNDlwlpqJyiZrplGckbom7u8
 KyZaVw2C
 WaHQGUMLpxUVglupeNrMioJ6IbJ+gLu5guRPgtrZkHYrw9Q2dHlQnOwqa4awO5/JliZiR+Y/MqwP94MkKOO47t2+4o/32STDtizOvopMvhAseqrmRowwkL4Lbe7uEa4Hr87UTxpD6JI4xzg73Xmv0FTgmzHX6Y/oBnu7daIF72ANLFKU+QAHaD/a/kIRxCxZRbPSVONo0qp49/x2JTyCYB87/slsaHhfqb4LVww5p+GUJ8/ifk6u4X5JMrT4SWizgdIgo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Apr 2026 17:23:03 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Tue, 14 Apr 2026 02:52:47 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Problem
> > ========
> 
> Let's align the underline with the subject.  Also, let's add one blank line
> after the underline.
> 
> > When kdamond terminates unexpectedly, 'enabled' remains 'Y' and
> > 'kdamond_pid' remains stale. This prevents user from restarting DAMON
> > because both writing 'Y' and 'N' to 'enabled' will fail.
> > 
> > "Unexpected termination" here means the kdamond exits without any user
> > request (e.g., not by writing 'N' to 'enabled').
> 
> Could you please further explain when such termination can happen?
> 
> > 
> > User Impact
> > ===========
> > Once kdamond terminates this way, it cannot be restarted via sysfs
> > because:
> > 
> > 1. DAMON_LRU_SORT/DAMON_RECLAIM is built into the kernel, so it cannot
> >    be unloaded and reloaded at runtime.
> 
> I think this is quite obvious, so may better to be dropped.
> 
> > 2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
> >    Writing 'Y' does nothing, as 'enabled' is already Y.
> > 
> > As a result, the only way to restore DAMON functionality is a full
> > system reboot.
> 
> Thank you for clarifying the user impact.  I think this deserves Cc-ing
> stable@.
> 
> I think 'Problem' and 'User Impact' can be unified into one section.
> 
> > 
> > Solution
> > ========
> > damon_commit_ctx() sets 'maybe_corrupted=true' at the beginning and only
> > sets it to false upon successful completion. When 'maybe_corrupted'
> > remains true, kdamond will terminate eventually.
> 
> This seems better to be explained earlier, on the problem section.
> 
> > 
> > Therefore:
> > 1. In damon_{lru_sort, reclaim}_turn(): Add fallback logic to reset
> >    parameters when damon_stop() fails but kdamond is not running.
> > 2. In damon_{lru_sort, reclaim}_apply_parameters(): Reset parameters
> >    when damon_commit_ctx() fails, as kdamond will terminate due to
> >    maybe_corrupted mechanism.
> 
> So the problem is that 'enable' parameter value is not trustworthy, and this
> series is trying to make it trustworthy.  I think it is bit complicated,
> especially for stable@ fix.  What about simply using more trustworthy
> information, e.g.,
> 
> '''
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c
> @@ -390,7 +390,7 @@ MODULE_PARM_DESC(addr_unit,
>  static int damon_reclaim_enabled_store(const char *val,
>                 const struct kernel_param *kp)
>  {
> -       bool is_enabled = enabled;
> +       bool is_enabled = false;
>         bool enable;
>         int err;
> 
> @@ -398,6 +398,9 @@ static int damon_reclaim_enabled_store(const char *val,
>         if (err)
>                 return err;
> 
> +       if (ctx)
> +               is_enabled = damon_is_running(ctx);
> +
>         if (is_enabled == enable)
>                 return 0;
> 
> '''
> 
> > 
> > Changes from RFC-v1
> > (https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com)
> > - Remove RFC tag.
> 
> When dropping RFC tag, let's start from v1 again, from the next time.

Also, I just found the patches don't have Fixes: and Cc: stable@.  Could you
please add those appripriately?


Thanks,
SJ

> 
> 
> Thanks,
> SJ
> 
> [...]
> 

