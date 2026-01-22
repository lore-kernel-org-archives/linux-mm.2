Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BCEAD3EE97
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D556B02B2; Thu, 22 Jan 2026 12:13:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B2D6B02B3; Thu, 22 Jan 2026 12:13:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909FD6B02B4; Thu, 22 Jan 2026 12:13:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4CF6B02B2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:13:55 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23897B9663
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:13:55 +0000 (UTC)
X-FDA: 84360247230.29.948CB0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7F242A0003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:13:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vVvwcwn7;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769102033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8kdI1og6J7L3Yky+74PNIedn05CEwcxNwVxoJd+g1qw=;
	b=LFrdvI64GBFRIowyfTjIgLgFDTI3SoVm6gg4V9KonnseYJTuPFP5KILEggdof5MWyY40ZG
	50WM71TpTjFwkVI/8ZrucROBHBt6MIYvRJbhXhhjUADJW9K2sW71MjC4nC07L27F4KfGXd
	/fCXtjpE5kJ9BiRaYDkJES6DIl9AHSw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vVvwcwn7;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769102033; a=rsa-sha256;
	cv=none;
	b=la5ia0CQIOiMjMgLT3TZsYTus3NYUd/iSuXbAXFvvlYBc93Grvyc/W5oh6Hxbn8ucAHu+b
	S37zUSSK3fuR7ISsHw2Om5fSL6WaX3kbPCvgK8fliPbwQKMbbnYHe1vdvwTMk9yXSzgV0E
	NguTh+hQtE7kqOiNzLdWBsQQMUVdd4E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C25A2600CB;
	Thu, 22 Jan 2026 17:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2411EC116D0;
	Thu, 22 Jan 2026 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769102032;
	bh=7G/QqXvcC6v2q6kq4mByfBDUfC++L542v7aEpHMt1Gs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vVvwcwn7p2eSF8OAMa7tYkMn2kTkDU/wPhaNdoQeovpIeSndvlEMTIfKF7OgArV1j
	 qCwF4mUnFifje2mTXdum7upR7dZSnWm+Tt5Md5YEmTBtT4SyYPn1JbB53Q68xYIo9r
	 Hsze7rW0ouJRsMqAxWIlCC1LYhSwc9ceYZvNUKVA=
Date: Thu, 22 Jan 2026 09:13:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: shakeel.butt@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: optimize stat output for 11% sys time reduce
Message-Id: <20260122091351.0cc1afd5d419fafa1d98b32f@linux-foundation.org>
In-Reply-To: <20260122114242.72139-1-wujianyue000@gmail.com>
References: <20260110042249.31960-1-jianyuew@nvidia.com>
	<20260122114242.72139-1-wujianyue000@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7F242A0003
X-Stat-Signature: k7cb7qr1gcartumiebcx1kxeb8fmtao4
X-Rspam-User: 
X-HE-Tag: 1769102033-232400
X-HE-Meta: U2FsdGVkX192Ol2Iu7oTdyyKO8qtui5KMadCmbmnqMurxaklN6FSzpDYExpcyLSXYBb+zWXbLogzQJBkakRtp5njbgCFVP3AjK4Hk6M0N3B+sAFNeph+oaInOGLfyzwCBorkW0wrAuxbfeNZvobpW6aHaExnXSOXy/uHANp/blchZVLLjPi4Y9hoh7C5ytwD7kQuUa+2JaAeHO4NejF3xK05+oMIaoYci8IepSwO20/VyD0j/khi9hfFb53Qg8QMgHSSB3DclfHK+9HkFBOkV75p0/7j3WHn07eMkmlh41cmWDjKHkt/rn65tDXEfIjebVAiTN2FFKOHoH+IgSogXPQewkJB7LXi9ymY6bp3Ua6/bBKriKSHSxWRMf3BAd4oq0syjIwd1ZJWufsJAahNOZyrwlvi2W4ocjiP2tuq8VphYXeb0gbzhx9WiOo2eHPtJKzOEZrX3zONzMA8rps32ZhSGVAkPpt/O1PvF4OBwQ6hJ340tlMbX5dosGPfGHTSCfesWpBIA9fkm03xgKmscinsTVkrez+hdA94+h9ZonRCpvts+C1THGcAYiwKqOj1nGqve/fzvI7Dy/Mzr09GQFl5SUPZigmF11tiyZz2O+Zp/rD0VJgOuLDNcSNyFOGMNnLfxg1sRRMXTgP5ZfxQLJ6Bv5bp39Ph0Jz17JC4gaetNChoT2+1D93SGgw94gUUCtzXvuYOiJVcFlLZT4nkPFDfUXCe2vzTL80diKIJCQCecp2oB1ZzwRUQlRlvy2247nWbv8YNn4pjoWulAxDScXeM6BgcoIgQY4FujxXxG6qJo34WiSHKlQ0Flxc87hv6C4jrKw3MgsEOmSbJV6oHaWFlzR5VG4T7tFgdYx4ACGBGXyNvptaiD59dOCf2YBLcJaBG06sW+/xt9os4+Rx+agfB7PX4M5xcDICdBNG3c8Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 19:42:42 +0800 Jianyue Wu <wujianyue000@gmail.com> wrote:

> Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
> printf parsing in memcg stats output.
> 
> Key changes:
> - Add memcg_seq_put_name_val() for seq_file "name value\n" formatting
> - Add memcg_seq_buf_put_name_val() for seq_buf "name value\n" formatting
> - Update __memory_events_show(), swap_events_show(),
>   memory_stat_format(), memory_numa_stat_show(), and related helpers
> - Introduce local variables to improve readability and reduce line length
> 
> Performance:
> - 1M reads of memory.stat+memory.numa_stat
> - Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
> - After:  real 0m9.051s, user 0m4.775s, sys 0m4.275s (~11.4% sys drop)

So the tl;dr here is "vfprintf() is slow". 

It's quite a large change, although not a complex one.

Do we need to change so much?  Would some subset of these changes
provide most of the benefit?

It does rather uglify things so there's a risk that helpful people will
send "cleanups" which switch back to using *printf*.  Explanatory code
comments would help prevent that but we'd need a lot of them.

I dunno, what do people think?  Does the benefit justify the change?

> Tests:
> - Script:
>   for ((i=1; i<=1000000; i++)); do
>       : > /dev/null < /sys/fs/cgroup/memory.stat
>       : > /dev/null < /sys/fs/cgroup/memory.numa_stat
>   done

