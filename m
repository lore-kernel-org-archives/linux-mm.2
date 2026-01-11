Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D46EDD25030
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 02:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366116B0088; Sat, 10 Jan 2026 21:34:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313926B0089; Sat, 10 Jan 2026 21:34:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21FF56B008A; Sat, 10 Jan 2026 21:34:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10B676B0088
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 21:34:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9CA70B82BB
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 02:34:11 +0000 (UTC)
X-FDA: 84318113502.27.6074455
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf04.hostedemail.com (Postfix) with ESMTP id C9F2B4000A
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 02:34:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LeS/cM1u";
	spf=pass (imf04.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768098850; a=rsa-sha256;
	cv=none;
	b=D2uFIGAugtNpAy0hyHdiN6d+/Za9n6WX0kAS6DEbt+xJOvfZIVSvmc4h+8Xc5182x+ecIU
	mNnbo2kTTsvFFDEc8CU8xCLvGtZECgebZIq3/0NV8jIqC8RF+suP3IWFuKIO3xc1L7OsYm
	kfGLOX4iO+0zZC2at68eg/Gdg3aLC6U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LeS/cM1u";
	spf=pass (imf04.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768098850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/cq7IxD3DIIiFhsSmoe0bARTECHzyaMLAvMPQNM/M/A=;
	b=MIwpV0HarqOx13vzpz1R2PNVxRAK0MpDUWtwRw12fbCj9qFQaA7+4oyAJcWrVF1B+qovyI
	f7+roL02ElTWA3u4MsxyTc4d5Fs2IYtJ3Yg0gvqUd83YoVwJd/0EMmHR3co2HjXdgMhSyv
	p3q+LHSxbw9Co/+jYimqbKhNdktYq+M=
Date: Sat, 10 Jan 2026 21:33:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768098847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/cq7IxD3DIIiFhsSmoe0bARTECHzyaMLAvMPQNM/M/A=;
	b=LeS/cM1ugGnb/f5grZFTfWuOJNPjVbdRFcUPGaJoXQLwKCq5DRHYdbj0rVXizu1q+oMOny
	T4P1LJHup7Des3tQiG7UQORjN/zkmkZCra2ZWzG6O8jTRw7zPonueYqFLKVwhRPmYS3F+f
	UceqMSYahPgoeXUNsiyl1ZmcsWGviMs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: ranxiaokai627@163.com
Cc: surenb@google.com, vbabka@suse.cz, akpm@linux-foundation.org, 
	david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH] alloc_tag: remove sysctl prefix from mem_profiling boot
 parameter
Message-ID: <aWMLQkvushKidjQQ@moria.home.lan>
References: <20260109062419.157284-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109062419.157284-1-ranxiaokai627@163.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C9F2B4000A
X-Stat-Signature: kdkftnar4mb8dag4h14jr37iksqda3gw
X-Rspam-User: 
X-HE-Tag: 1768098849-266662
X-HE-Meta: U2FsdGVkX182I5jWc6k81aFmZRP1sEG/FikIfqHwbtUNcIWwkbupt2utXh64yLogwxsolRhnClosIuAZUozXWpS0K4r8pANheG5WbVEKBfBNzUrEcfaCIPO8nHfCfRX7n/jSKNcQYNB+/akz9OLh4ZhkwBSm7daRu72NBXej7ob5LoQ/ClLBKFUT0NAcJZdqNl2VnWYYxJj/38cdux+NAMnShc5q8Y/B7ta9CzaDNWBqDqfAxb2+KGM/cI9k6xgS+I3WJSIaNUIW1HhjHLjEgPWg973Z+m1Ze4+6qMVraTYNZHby7ZLFSGAs4RpL8v568GrOVysR5fjKr6NloclNvmShjIdnlQXeuHcrhIA8jPE2CZ6tgXGxdikbT25VhWIZLLHqs+rdu91rTBhn6+hjlvwX9FAPFcZ9vjPPgzfx6Ha7vbpuC2vLKzXC0Ur5bSahkjMQw5MC/LYnpJg2sCGQGnmub1t3hOThQZ/6R3IOxgTY0TdMCRjKIlmrVqN+1V6VKQrafmR4DqD0s3EI2e4LUoI34laZqDg1nM1MKupxiR2oIb5T3tDMfy+6VXTMmr36ce1bIVL79IL+E/9vh52Nd/PogAQ7/Ra1DPgIjpf3gTVXYLEhg3sI0/7IelTWcMCw4R7vsuYtoqKk11npZbvv2ahjf40+l0D8rOpyXIYgvxUaCxZ8h/yF3+7neyxMbRrrtoUzZjEJqRhMU4ESfapEXEqgG15AZsM70RttoUO2QcJ53szRPRts9ZV0GnEW82wwPAYKgFjwpecBrUVMF/79GnMtsEyXbKTa8M280N6zuh2oOvFxWHHx4Udvq6SmwyGbvec3RQMF4nCj7ES+wJdMlw6LJUBc3QgXN+UlwZXj6c5vkDTdYNHux+OmJ495Ui3+++ER6fIJDmWdwAwwcjaQWbFvbV/bDTeYmQPWczDe6zFJ8hgrtooefE/yBpiZ3MXY3vAxAmV/OnkxPYe334b
 RlC9qJOo
 VADpqG8yquJHtpoSTBPP5p8Htb2Hrl1qYAe0el/EpmylfZ97XM2JrWR0NwyPLkyzwKNsRPGYccDvYBdfpMB/L0fV8JwCeHg1JDOFt38sHX3IsylOW37xSRvzstJgLU5YQA/O7Joy+4qJRQFHdHPXw7BUs8wcswSg6k3dpLKfts7KQr9yzfVrWme9EbpqB0rvxNju+5od0dX4FglMixmC+a9iNTCt+lFcXtKKbv5Hxf8KHtzb3IxGmU7I90ZeMs8vdYlyw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 06:24:19AM +0000, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Boot parameters prefixed with "sysctl." are processed separately
> during the final stage of system initialization via kernel_init()->
> do_sysctl_args(). Since mem_profiling support should be parsed
> in early boot stage, it is unsuitable for centralized handling
> in do_sysctl_args().
> Also, when CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
> the sysctl.vm.mem_profiling entry is not writable and will cause
> a warning. To prevent duplicate processing of sysctl.vm.mem_profiling,
> rename the boot parameter to "mem_profiling".
> 
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

How was this observed/detected?

My reading of early_param() would seem to indicate that
setup_early_mem_profiling() is getting called at the appropriate time -
and then additionally a second time by do_sysctl_args(), which then
becomes a noop.

So the only bug would seem to be that the sysctl is not writeable in
debug mode? There's an easier fix for that one...

