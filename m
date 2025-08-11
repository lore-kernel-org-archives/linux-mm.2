Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1496C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 15:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463738E006D; Mon, 11 Aug 2025 11:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A778E0060; Mon, 11 Aug 2025 11:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377BA8E006D; Mon, 11 Aug 2025 11:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25E1C8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:09:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF78C1DB09C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:09:04 +0000 (UTC)
X-FDA: 83764809408.08.B2904D5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7E307100009
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:09:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OSkIOWZQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754924942; a=rsa-sha256;
	cv=none;
	b=FxpqehGRpUCMlFQGUlLy8AXtV6JRHCOTrGAxTVjskyXyhiSLOPeHeV5VbvEzC8ZnOuMami
	bdfREupmOUDErKbF+L+pzYqaFXcr/GZEMr52pKh9PCHjtCxLr9NmNyHPW//6GPffl8g7KN
	u2O6zTZ1wamGABmHax97YOblE7sUj6s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OSkIOWZQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754924942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5BfcxOGfskLNbpbMbwX4KjsPVWAUvhOCnh1KC1IjLE=;
	b=vYWA7bToe0iSbGXcy/SQFQZ5Ji2DdkPx9Vzk+HZb8522e5iudFujaRRVmBwOp6cmj56O6L
	2sN5Nj3gC+kT9XMIYyz1kq2KoOcARq+jYPC7euouNq3JzmmPK7kFUUoE/NTcVeQ7W3aMcn
	xAl0woxE25yDbCD2M0jacrFofaPs5CQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754924942; x=1786460942;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Fos2Bc+psd2wDnxAA9C+5WvzOAyECbjI1HOkUcLQeFQ=;
  b=OSkIOWZQdF4WtXR4yJZiaP3h23HctK9rnOKF1o7Qb3VJCkjDNp/sVvlh
   0/5dws5yWSHVGIlTmDvk9g+G0tIVp0+7DW8vhnG1euLCaeveL/HavAhA5
   rAWmFjC/varyuoQ+1WIuxEw2pZKeeQZXWOKVjkULo5DoNDAgjEJyjLcwW
   1f56TEmT8wZ1OGAhBYt2i4sfmimZDpjKGT+KqDXv3Wn2rICJZyJj8XOJq
   UMKkIWh3SzlN3plekBzSoBNO9L3BgnG+s0jr4Xc6F/ElYXZXbHEfPltiW
   bykYBad6lQosEIFYLL0+hazpPvwJcBqzsVVVn3Z3evaFfs0qezrr0hLuI
   w==;
X-CSE-ConnectionGUID: kn4RblLMSwmhcqFA//JYBA==
X-CSE-MsgGUID: jgcNLGY1Rsa+gh0afWk/iA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="56209119"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="56209119"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 08:09:01 -0700
X-CSE-ConnectionGUID: 6HXLT3G1QeCd5htSdOz7vw==
X-CSE-MsgGUID: viOw19WfRZm7kbZL2ZA/7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165831059"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa006.fm.intel.com with ESMTP; 11 Aug 2025 08:08:54 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id D6F1B94; Mon, 11 Aug 2025 17:08:52 +0200 (CEST)
Date: Mon, 11 Aug 2025 17:08:52 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Bhupesh <bhupesh@igalia.com>
Cc: akpm@linux-foundation.org, kernel-dev@igalia.com,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, oliver.sang@intel.com, lkp@intel.com,
	laoar.shao@gmail.com, pmladek@suse.com, rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl, peterz@infradead.org, willy@infradead.org,
	david@redhat.com, viro@zeniv.linux.org.uk, keescook@chromium.org,
	ebiederm@xmission.com, brauner@kernel.org, jack@suse.cz,
	mingo@redhat.com, juri.lelli@redhat.com, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com,
	linux-trace-kernel@vger.kernel.org, kees@kernel.org,
	torvalds@linux-foundation.org
Subject: Re: [PATCH v7 4/4] treewide: Switch memcpy() users of 'task->comm'
 to a more safer implementation
Message-ID: <aJoHhDIL6T0Zo-nB@black.igk.intel.com>
References: <20250811064609.918593-1-bhupesh@igalia.com>
 <20250811064609.918593-5-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811064609.918593-5-bhupesh@igalia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E307100009
X-Stat-Signature: pef1oquemw9t1s4hbjxr1ouq8donc6ws
X-Rspam-User: 
X-HE-Tag: 1754924942-911860
X-HE-Meta: U2FsdGVkX1/5kVu4ix/EN6jJVt/3L5tu/H+ZW3//wugHQ8GbFTIo4JKC+DCePqYr84wuqekNfZPswvKdNZ6qMwfAw69aqGlywNKRXY0XXmxAuNoozdn1uQ3N1dYpS/9DPhHT8fuvZZbmRmGBUglta9A763jYkAZHG1sZTlO2JZU9RMSv+dg3g4I+E2TJ2lnajRDWbkysqEipvw7oRdV8xsZOBWNN3xOgqr95tVKyf0JsEsFw3bOnfdoYu1dugfrq9kVOqN1mHNMy5OPPG1K35PjH79kN3MLn0b5fnpMNRVgWK3cWezhv88KliIqi00xDYXsvMi6Db4Yf5P+lQHK/Wv1gx5kTCo9hUWsBoQymegGnW8JOr0uNV0BpI62osHAL8nHSWsur14fVxconYUYfaZzaTouh3SvUW+oZqDpG4uqv9ZcO5LQQP/0DldELL2gVyfVPY3Uo1y3WnOUu3RjZEbMd+/QyeKndoAei1qDJuy43MrS/wckbxYVr6qM+r+I62lRVwizShmfnyUqcC2jRhl8Q6OaYsIK0y1A/xaKa5gK+jOeoRN9eHG5N3AIHl3DFR2kYPfgzu+DInfMlkQ9NVcfn6GVJIpwsYQPjvbY5fCp/nmrKYzjsyFPKAz/USYGFjfSVN5Fr+cgOlarQaMaizGslazuvhzGtiAFk8u2+xP4aGEb4s3t30yD18oqiLS3mtVNPccSA9Bg4Ax7POmwxJ7bXKJGnL5tj8M+35xepPUYwQ9HsdmzDMsJXAoZYo1oHTdxxQNJWzQPNshccHi/6gMOk70ehzDLFHgQdTRdLF7LAoU5NlfFQqKdwtVv+OUSNRQzLvnGwdGWcCe6hN74DCdd6kIJdLNQAyUjAPj1LqFAPTgMfD2ae+2NggVw0CveP5fcoB0/svXFJtWKrN2Clc3GY9dN4qf0qrX69cRZcxmYDBCVHfR9PBHFZBt0zwX3mUUvxrluOeKRsV/VeDYF
 f5CNHu1A
 QUiyTdXbCekr924bSdO1ztp1zovFibS7C4bOx/vr60Drww3lhorLDFu2YP77yNF26rPvOinDNweD1+GdgxhFCclU10jSDOINKMGeCWrWlqR6CsZRXuoOiJKGeOR5u7JAfCh4Wvz9i02UfuJrgCPgf6TuUmK71rgHi/EfFypRQqY62Mu2or1HDzSHl2mgAmAFJhGHg6daHcLUuhdIdcHdsbDdXO01Si2BGkLvuEDfxREhdgYmIbj0VkQYX2EgGPw+mVMAWKp/r9ACOpM79F6TOxnws1rCCpRuiw2GAXYq96M/gkkrq8q9f4vziE/Kn64tPbEPptcjrVQKt/uPwKxGrD+o/sqawH4XiK/tqBQSIRIfnVjPDYQlldViBiiNj7VodXlZd+/OdRIhCLbzdWpJKQfAg2ME4u5skEfM+77auLTjghT8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 12:16:09PM +0530, Bhupesh wrote:
> As Linus mentioned in [1], currently we have several memcpy() use-cases
> which use 'current->comm' to copy the task name over to local copies.
> For an example:
> 
>  ...
>  char comm[TASK_COMM_LEN];
>  memcpy(comm, current->comm, TASK_COMM_LEN);
>  ...
> 
> These should be rather calling a wrappper like "get_task_array()",
> which is implemented as:
> 
>    static __always_inline void
>        __cstr_array_copy(char *dst,
>             const char *src, __kernel_size_t size)
>    {
>         memcpy(dst, src, size);
>         dst[size] = 0;
>    }
> 
>    #define get_task_array(dst,src) \
>       __cstr_array_copy(dst, src, __must_be_array(dst))
> 
> The relevant 'memcpy()' users were identified using the following search
> pattern:
>  $ git grep 'memcpy.*->comm\>'

> [1]. https://lore.kernel.org/all/CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com/
> 
> Signed-off-by: Bhupesh <bhupesh@igalia.com>

Same suggestion, make it a Link tag.

-- 
With Best Regards,
Andy Shevchenko



