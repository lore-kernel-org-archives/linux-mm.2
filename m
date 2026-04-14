Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33701F531DC
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 00:23:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627146B0088; Mon, 13 Apr 2026 20:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D7FC6B008A; Mon, 13 Apr 2026 20:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EF6A6B0092; Mon, 13 Apr 2026 20:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D0DD6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:23:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7EF7E3252
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:23:07 +0000 (UTC)
X-FDA: 84655261614.08.8D8C200
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 195C1180004
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:23:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UFC+xDNx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776126185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VQJ0lkzjwz3BIme6IUcWUxOXR3vfpj7yc3fzjY447E=;
	b=kj5k/JhRuQDK7lcFEt0yxKD6Q6M/kU4DC1ZfKS6+xYtr94/zS41wgj2/uhQiajmlHari1s
	11Tmmr2gkD+SxSAAINKrCMFfqYZT+FgIbI7Y/cjTS9Iv4BlpAwpz+hVf7rpWfyU7k5Uhfh
	JTmy0jSrohgdjhL8OzcgG9Lm9hOxIwo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776126185; a=rsa-sha256;
	cv=none;
	b=cpzLnoVc3IGTMQsMUhCJvk7QS5hwz3Uj6qWYDJu1LWkigtjVVHAr2FKbRDDCAQx7Bwer6i
	lOeOP/QMau6aqfQFhc/nil0lQ17ebiGy3+nDpqUANST+KQsuOsCUMeOYuKah29hb0O/Owb
	OLeEjWw3tVE0XyfzsCdvAv8iDmVLcjw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UFC+xDNx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD874400D7;
	Tue, 14 Apr 2026 00:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678E7C2BCAF;
	Tue, 14 Apr 2026 00:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776126183;
	bh=rUPIO44OS0Rco3GvN57c0BXurHCc9flcjQqmcQyfIfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFC+xDNxVZ7H1zSIPMZdUup9eX9wkebQIij2neJzsBGlAmCV1TP3+NbVMlx0yhypt
	 ka+4TLqgz0AIa7O/2RJP0uzCvgdrht1PDh/cMt013nUTCqmxIeRcunnUF8NavZrM9D
	 VDPAJJqDa8wl6UkgNfoXDEK4dM/z8jj3XmyMsEb9b0IJpJpsGBq15dFrpmcBVesv3E
	 6OARsnGZz8qFFJvHcjGBeaE0n299WE53HUNIcL0k9mQyclsjsIwsweW3iITzy/VuMO
	 l5b8fgU0A578t3osFs9cObvaGrGfPPCfgOQeujnNdTEUf6H6izFidliLGlg+fF0i5t
	 cxYxHK78vUzMw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/2] mm/damon: reset thread status parameters upon kdamond termination
Date: Mon, 13 Apr 2026 17:22:59 -0700
Message-ID: <20260414002300.83328-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260413185249.5921-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 195C1180004
X-Stat-Signature: egtxpz71w8r1es7esxiif45er35or4nt
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776126184-275486
X-HE-Meta: U2FsdGVkX1/aVWyH3dDJPZRbeNFlogslR1K28F/hQgjJZTcvcmOsZSIKTrDF6AJQ0ccYeb9t3oO+1EvLA62KL8hy11usMzmlo5hsj1Z+i6YAagsY78DB/btvwc0b2EH9HRPkDDMsNgN5RsB2uejMmLlB+KMwJQVr9GN+EZTv8Xx5Cbl2hBYibvmeCKKhtCUlCPb+9dKlGXcRgk+AXJQ/IoZfkuuDEeQDDTB1pEvmOzsKfuGK2SSddULvXLI94QsVny5GsTICS4JfmmWvThh6JdBhUCf4ZUeMdMps9xxYPHTr7GwHFJmumr5U59GtHD9r84yNmaEMH8PfzruWDWy9hahgzoAg4BzkOfVfuQjHtWXXAgOVdz0Sp0eTOsq5+4i3sVqQiJU98YpFqv8shJ6p7QAR3sBkkMHI4YGe+P1MbQ68tR3+H3jWZySK9Ay7ravElVHRvQi9xrkQnnKiWfWaEih1GkKmWAdd1RYxw5gMxVJ9vNDjqNG5trPeDVgYU2EYF2d6gzPuGX4fTEElqwjLfjvW8JZybegEkUJwK7bfGtzm2gpsGJCd6xV+bc7tFiTK4puKdoyhvLspqg+O4s0dpuNoE/JVdnQEJ8eGfk7p798QdeGhIfKz+1lpc858kzJLEC5VYuwTgaN6zwwPxlYEfs7WX27ymP4EmPeJNk/5+0gw39392b7ZKdkLek5cpuqdRJHnnE02iaWFgUuo2TCFamylFi16mEZHrogo2+AklM7Tod2qHuHS1j7E0gz+AbtqfR0IO0aV57Q/1lQz0cQI/5TDOOEd8BDdMjSh+kycuamgeNi/cdHd6s5/Jc004ndbZrVJErUH/1JVDANSLMrzuqyLKRcedqcswuy0UnKWC3BgI9h2XDL5v4w3SFKS6U7DUYJwd6A9eiaQHEWfTGITRquv7jPoLqPRU0/h71xJpdzSP1p3g48SSeG97aGMlklYKVcAz+FyOzlJ3GGBy8Q
 ZjruvCqc
 LZuzS03sGxydy6gGVDfidkHanBtZH2ccwcvJiiP68y1U+IoRpCfoWGLOUlvfy0Pj79NaNEa4VRBp0wXy3O/QNVLWZ0LpDQL3Oia090zD+wcUpCal8ub5Slr9qcKgDfj9leXS/o0lALEtCHhQkH9+NjhNCVIG4LmTv5x9MssPyISHN66XEFdJuYMqEqiJIFikngnBXCrA2oiiKAKoNtH0JnbLC5Udcof2lXaeApXkriuzvIeduZ+gRizagc/DQRYtJygSP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Apr 2026 02:52:47 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> ========

Let's align the underline with the subject.  Also, let's add one blank line
after the underline.

> When kdamond terminates unexpectedly, 'enabled' remains 'Y' and
> 'kdamond_pid' remains stale. This prevents user from restarting DAMON
> because both writing 'Y' and 'N' to 'enabled' will fail.
> 
> "Unexpected termination" here means the kdamond exits without any user
> request (e.g., not by writing 'N' to 'enabled').

Could you please further explain when such termination can happen?

> 
> User Impact
> ===========
> Once kdamond terminates this way, it cannot be restarted via sysfs
> because:
> 
> 1. DAMON_LRU_SORT/DAMON_RECLAIM is built into the kernel, so it cannot
>    be unloaded and reloaded at runtime.

I think this is quite obvious, so may better to be dropped.

> 2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
>    Writing 'Y' does nothing, as 'enabled' is already Y.
> 
> As a result, the only way to restore DAMON functionality is a full
> system reboot.

Thank you for clarifying the user impact.  I think this deserves Cc-ing
stable@.

I think 'Problem' and 'User Impact' can be unified into one section.

> 
> Solution
> ========
> damon_commit_ctx() sets 'maybe_corrupted=true' at the beginning and only
> sets it to false upon successful completion. When 'maybe_corrupted'
> remains true, kdamond will terminate eventually.

This seems better to be explained earlier, on the problem section.

> 
> Therefore:
> 1. In damon_{lru_sort, reclaim}_turn(): Add fallback logic to reset
>    parameters when damon_stop() fails but kdamond is not running.
> 2. In damon_{lru_sort, reclaim}_apply_parameters(): Reset parameters
>    when damon_commit_ctx() fails, as kdamond will terminate due to
>    maybe_corrupted mechanism.

So the problem is that 'enable' parameter value is not trustworthy, and this
series is trying to make it trustworthy.  I think it is bit complicated,
especially for stable@ fix.  What about simply using more trustworthy
information, e.g.,

'''
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -390,7 +390,7 @@ MODULE_PARM_DESC(addr_unit,
 static int damon_reclaim_enabled_store(const char *val,
                const struct kernel_param *kp)
 {
-       bool is_enabled = enabled;
+       bool is_enabled = false;
        bool enable;
        int err;

@@ -398,6 +398,9 @@ static int damon_reclaim_enabled_store(const char *val,
        if (err)
                return err;

+       if (ctx)
+               is_enabled = damon_is_running(ctx);
+
        if (is_enabled == enable)
                return 0;

'''

> 
> Changes from RFC-v1
> (https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com)
> - Remove RFC tag.

When dropping RFC tag, let's start from v1 again, from the next time.


Thanks,
SJ

[...]

