Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E6DCDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 08:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A18C6B008A; Mon, 22 Jun 2026 04:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878B46B008C; Mon, 22 Jun 2026 04:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B60D6B009E; Mon, 22 Jun 2026 04:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57CD86B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:37:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6FE0C281B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:37:52 +0000 (UTC)
X-FDA: 84906895584.15.405E209
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf19.hostedemail.com (Postfix) with ESMTP id EB2F01A0009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 08:37:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YL6ehpGb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of jani.nikula@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=jani.nikula@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782117470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qo4MYLhP7dlMp2m7GIjE71Z7pTs4vkTKqFa8g3CH+3k=;
	b=wl/1NyuYgFReEFBMc9mzIQU4pWDjkonGPLKqy27PKIwvy8greVY9l/wmkhv13KR9u1dgoV
	UTyhsc1u5Vx0PBlsTolR4K9DklfMACefbd2cQJ3EMHdL2RmyUxpGzkIvUlAzgqXVDp4Oov
	nxkgj3EABw7gkSEfPIV438bLdZ4AgC8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782117470;
	b=41VUEpiNznqVWojGtyW7c6UF7Rcr2py9zApm7tiIS1WGp9EAyvg/cLhZCOWHMPNbA2g5iB
	iMwvkWTdVUm7D5x3lKzLIX31gdySIBnEZlJkNS1P2poXbAvJD4JwosyR8gJXVlqFwQiOhE
	9S+JzAyvQa3N2OHZ501PMdpfISUWDiQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YL6ehpGb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of jani.nikula@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=jani.nikula@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782117470; x=1813653470;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=o0XPey02pNHXumHWa6TQBgjgCeS/R84YiOVlMcvQRTw=;
  b=YL6ehpGbk/QW745FcrZ+I3xFIuehdzCaHwtL9O+SyLKkpjQuOlxtvapq
   TJhNwoHvYeMY4FHB5qb+u1f7/SFVfGulvyuzD69U5v7kgVtWZ1VDK0nHg
   apqvuT1o6M1NhZccNGbd5Vunqs5/8YRnizBW80BW6PSUtawb3P3ay/KVY
   xAQPvVvJ1tE40Jb3gnneRJ+kNqOcOuTXCwZ4+TgNZ52HspVcn2pDaPJ6E
   /Kurj1XsUtpWGlOKlJIG1pl16AViGOWmYkIY8WM0ZIvRH9X+1tdWWUrpa
   yXd1z9GgLjhJ49n7eeeEthqHZ21vMIW2u41bKIJzYL7d3vla7LJURF0qH
   w==;
X-CSE-ConnectionGUID: ySf19rP2ROmRElU2HNT2eA==
X-CSE-MsgGUID: cusGuS4hQoyx6B8g0gYEzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11824"; a="82844705"
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="82844705"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 01:37:48 -0700
X-CSE-ConnectionGUID: 51x2ahlxRfadoXyoUtL0hA==
X-CSE-MsgGUID: PGIuZ8mzSP2g3MT4S82HXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="254255860"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost) ([10.245.245.82])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 01:37:33 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Jens
 Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Christian
 =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>
Cc: David Howells <dhowells@redhat.com>, Simona Vetter
 <simona.vetter@ffwll.ch>, Randy Dunlap <rdunlap@infradead.org>, Luca
 Ceresoli <luca.ceresoli@bootlin.com>, Philipp Stanner <phasta@kernel.org>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 audit@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kexec@lists.infradead.org,
 live-patching@vger.kernel.org, linux-modules@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org,
 rcu@vger.kernel.org, sched-ext@lists.linux.dev, linux-mm@kvack.org,
 virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, chengkaitao <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor
 state
In-Reply-To: <20260622040533.29824-1-kaitao.cheng@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
Date: Mon, 22 Jun 2026 11:37:29 +0300
Message-ID: <88f34c7fa5a3d1700cc8005818751d6aa31f09df@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EB2F01A0009
X-Rspam-User: 
X-Stat-Signature: 4yhak8g1g7je38ixnek6p96pjmm63gyf
X-HE-Tag: 1782117469-251681
X-HE-Meta: U2FsdGVkX1/adzL3r9PnBhorGb4WuvHtQJWVcYfHCZht8hVrnAtTkIF/yhlAROuTeNheGEWMVliOcO7ngHEP3Fo74cwbzYioRcEYxl5X/3Qbl+YAbBwhdEMB0AjiSaVQG5apFEOIM0US0LjIi0yhXu9ZXimMC8XMm/XgRcT2iscJkBYL0o+/4cbXCMRO6/8a3tpUXiqf6XI8e4TNvwfTlHKy/F8+LEbdn3/1VyL/CQ8IKPH+K4kulc+/ugcULyelbVpYIKIa3mSYGZVnb38gJTRQPi2Eg0bP1BKn8NDPNA5IXmVdSrZhKt0GWsnUQYpbOKcYh89Emeim0SdCVmwkw0/+RHwJEBHGlfo4TsoPfZGbZJr6Ibjr7/dbede6GCatP7DAt4c0v0+Z/F2/5qIke+DNfEo/TpdY6F1yY8ooSXzpZYiLVxf5eQnGcaHmtqerZ8FGT07SsXqA0vjFHrV5UBsLOgP5AY50q8DY3rMT27hd7C8ee+rxbFzXtywk7QR9BfJSen8Oq6DmMZFRDpL9nO92WJWoG4Vmkor6KPQ0s+N5/5X+4wkExP2LQz7aJq1BF2304vOWJeG2LX1dfhvKrZbdI+LZO3Ir5CHW2xQlBRaeQHK7dHasrPHfMTJeGqPUYPrDK2a9nCGeWTrXoWiAh5OJ9u+ygEz4KJrWBJ5QNLvyf7THUAGndWUtbW+ZHRi2yFT7s4teXKGMtg8Y8k+G6+0uKxdECLSHFx/QJeqv3iWcVxSFwnHr9cspbyx4h6yziWasWVn03i0vAhTGY9eYIAvzDjbg+MhVBXFCj1p+DrKjFmB++akpkGVPY0GcerN9/0PFhW2p2BYdHt7FNUIoJF05juVgeHHLV6qjhF8Wq69x0ju9pg1OFxzDfaIj37/sXiGPLOlJ6FVWyv9KPIdBAE9JrMHqZtCA9ACywIXfP5nxUqn3xGVWyDxBsntdgb5cVTIkOOA4uTlaCkYUrXl
 OoVrvLXh
 oMFXUDqrZ4iVCKQpuDzfOYw4qZEAPZ0yFq/Km+q2JxKw+Wri9jhfEu0oVZfYO8EZJfg2rr8vvIIIT9QeHV43PvC4RD16LP33HxGR21kZA3lf1EZAYX2tPejlAUd285QBKV865cOZvmdcPLULf9PqM0cMkxjFadG5aOZu+PHaHOEIPHebypj3PK1XBVaa2y5k9jtlY4qDumkZqq4VcbfvY+8/07l9STnmISqNx+zZWceTHPnFUsJsLl3ogJK14RJYoOBMySQaIYOzGNJfZYCS34bTpXHhujeEGSTgBaw4iIdlo08N3H48R8/67b6XIOwkTIzPtH07M6+vaNnrzNhfMyWoIFv/OarRJFRrm5Xe8OH9ycjfdidKNwi8zvv378xiFBJsoqeGdfxDuq5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Jun 2026, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> Add *_mutable() iterator variants for list, hlist and llist.  The new
> helpers are variadic and support both forms.  In the common case, the
> caller omits the temporary cursor and the macro creates a unique internal
> cursor with typeof(pos) and __UNIQUE_ID().  If a loop really needs an
> explicit temporary cursor, the caller can still pass it and the helper
> keeps the existing *_safe() behaviour.
>
> For example, a call site may use the shorter form:
>
>   list_for_each_entry_mutable(pos, head, member)
>
> or keep the explicit temporary cursor form:
>
>   list_for_each_entry_mutable(pos, tmp, head, member)

I'm unconvinced it's a good idea to allow two forms with macro trickery,
*especially* when it's not the last argument you can omit. I think it's
a footgun.

IMO stick with the first form only, and there'll always be the _safe
variant that can be used when the temp pointer is needed.


BR,
Jani.


-- 
Jani Nikula, Intel

