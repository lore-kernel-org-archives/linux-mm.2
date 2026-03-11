Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4583FD064E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 07:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F226C6B0005; Wed, 11 Mar 2026 03:42:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECFCF6B0089; Wed, 11 Mar 2026 03:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1C96B008A; Wed, 11 Mar 2026 03:42:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B6CBE6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:42:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6643414067B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:42:00 +0000 (UTC)
X-FDA: 84532988400.22.D80A357
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id E009BA000B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:41:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SqmlROTQ;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773214918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H56QLzxUhEgi6jqHY6ZmGgtMEVMNUh81uLgFUyINflQ=;
	b=QxWURY2baYogo9RNJ2jpDDtZzCodCcfqlZJz8qX8lBSM/hR9HEYhjwjizhbe0iuGV/fDCr
	g08tDQ8CTAyX8sgEcvVMBFVPTvN1mjiQG3qqgo6Hdjoi9Q29WpYnjskwpsr0s31ugHO1AJ
	OeOyZhqFNXmbMSqornSIIv81gBF1cx8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SqmlROTQ;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773214918; a=rsa-sha256;
	cv=none;
	b=ighNnrFOAsd6hTFaF9ClItjigwjhrtA5aDCWBetywa1xRp1yv5H0WTMahoxCcOKP7vb/Ur
	A3UJPGGLmsX8ilop9Xc4UvNH8+IgR7cU8/VKWXbCI2aEkUob1Gw1q4uvz90C9u3z35S9Na
	EPLGO7LaYHz/7dVgvhdUDSesORlU3YI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773214918; x=1804750918;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VOyzQxkiOrYyQ5++xZdWU53tYlT+cG5P+BjBAxzOJqE=;
  b=SqmlROTQnAANPq+ZRG6Ds8iD0eaRQyVQkj8RD8cuivLjW511rtoKVV6f
   6wp10d4BqhiQo7UzhlYy97p08Fb88G3EvQ6NKup7qa3xnJYxQYghXCLic
   0kBVXt0cN780hiIY+Qn+vY0tKBQbp0/eNls27ZeCcBjJanGA+1esDcSzb
   yvsuNQEtG/drRZOxClF6r3+EdSWW3DedMa/IwNi+RinE57bRhSQxjhenW
   GoC/hgLG1AwXFbxGEU+PniAXIpMgD6PaacsXCGvUOW1hZUqG7WjmBPIVf
   uqVkCXAo0IuKXSzoas98SEbJxcFiFJwx1mne2uyuH2CDuZRbRt8fXYtvc
   Q==;
X-CSE-ConnectionGUID: /55VQnJhTMSX6AlGZdzQKw==
X-CSE-MsgGUID: ftvOly1TS0Ssd+cXLfo0Dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="74394428"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="74394428"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 00:41:55 -0700
X-CSE-ConnectionGUID: /X5V1c6LS9+3qp302cC7lw==
X-CSE-MsgGUID: l2aL8VOtTrCZh90fqg3DCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="243391357"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 11 Mar 2026 00:41:51 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0ECT-000000003HV-28cV;
	Wed, 11 Mar 2026 07:41:49 +0000
Date: Wed, 11 Mar 2026 08:41:35 +0100
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Brian Geffon <bgeffon@google.com>, John Stultz <jstultz@google.com>,
	Ian Rogers <irogers@google.com>,
	Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v2 1/3] tracing: Have futex syscall trace event show
 specific user data
Message-ID: <202603110841.Pxedg2y4-lkp@intel.com>
References: <20260310201036.542627924@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310201036.542627924@kernel.org>
X-Rspamd-Queue-Id: E009BA000B
X-Stat-Signature: qrhozd3dygt1hgb9odm4us6j6z5pq5ri
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773214916-457115
X-HE-Meta: U2FsdGVkX19Zrz3y8jQllJRWZojgHxTRXQTfbyzxIZJR2KpJ14kuUt2aVxldnC8zEWQZ5aU3UK8trr0fgb+OIUUfV6UKn96LyP82eioHJXETCJfECLvd/YPLKRJ9+KXQ4BAoyyoxrZ8VYDU2oPqYJ1NLakKkVlSFBQNFT9t/jpBpanI6N3KyEbuqiC81JM5y+yhPcBkHTY0x0Dv8SUbmB21IlVoCI1w+fUqWLwEVgHihefD9GecYgqXJgWlubhflozDYDmCcAsAvTTM9v+O4pmtRSkogQwP6yBaAfPl3gbqthYZ1Ykx0InW1YQox+rwPWIInTktNKZni09ihb37QS0shLwqsMlWH/e/XAAof1ugsa/lnMWUxW9l0Ehg/dJXYCMqTQYFywj+BaycAGyBOwn7jWXVffJ+a1JtuZ07iY/PXkYOnjWB5oXuLGeqLuC8bizNjmKFzKT+r5UZZNISAYF3IvcOgaXYLKWjfhbNMZORBy6iajejyk42f6B4JOIb6SiPZwSV3iXxNj22oOApOSwnz/iZQNqGoe2Fhzub1EH6ynHUEi+t5v10g0rWQJEyclC0srPzO3U++8sK2va3qw10pN77gGakpptucrsMDi/AAp4XNlq3kQvK6gk+XOysAiFOPLnqm8vGarvk8KaQ8y267JbBxdIKdDRhzB2uK0KNNsMCFlvH8/8feDi0VnOsOzo7gf+WxVhacjOrHmpLWAZuZzj/B6QBC3TMpUJxTLWH0ghRvE3njwBWDwUOh00LR/asjZo+504TmZWY16H37swVEWV1uuDN+dQagb47QCMhAtEHnS5cD9uTwTjah4bkQtZtzuBLr8MqLrfV6ULLg4QTEW64b/hFKsDBKPcYKMuCpC5mL67NraSm/HH+ss/xGr7FKYsRMuuPGd+IXTw3K7EfmCXiwyRJ6tSn4bYYdZ5owFH3sy4+9FI9qpD50WbGze03rBERBQFVegUPR26c
 GlhJVIA2
 bA5PZgA2l6H1sm491i9ql8DpKHcyyssujMqwO67XO4oXYWKpykrkxq+uA2vFg72adhpxGM6w4CSzbIFpk4XzYukc7+xGpj52gdoNUiLz6Ud2VkdPsup9c/vwnOR4BxUKEj2rD8gq6g2HtBy4b2iWQSYVSIo0DUdpN1JhIg4gmEbaQ/+RzZTbWbTNMjh6+nGTxYjxWCzExMNSlUQ+QhPjqk4BXoLS6YJcJ9+rZtgiPN8GHA94BuWF1UGQ+cFpoDum20X6ZcYGisp5oaFBKLrCzt0fBxA2cSngYXw2y9gqD4Vynvi/FpcIZIN1M1HLNKRJZQIVIcfvwDB2mKr+fxR2LAez//UhTrcmt9B9j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build warnings:

[auto build test WARNING on tip/locking/core]
[also build test WARNING on trace/for-next akpm-mm/mm-everything linus/master v7.0-rc3 next-20260310]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Have-futex-syscall-trace-event-show-specific-user-data/20260311-041422
base:   tip/locking/core
patch link:    https://lore.kernel.org/r/20260310201036.542627924%40kernel.org
patch subject: [PATCH v2 1/3] tracing: Have futex syscall trace event show specific user data
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260311/202603110841.Pxedg2y4-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260311/202603110841.Pxedg2y4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603110841.Pxedg2y4-lkp@intel.com/

All warnings (new ones prefixed by >>):

   kernel/trace/trace_syscalls.c: In function 'syscall_get_futex':
>> kernel/trace/trace_syscalls.c:807:15: warning: variable 'buf' set but not used [-Wunused-but-set-variable]
     807 |         char *buf;
         |               ^~~


vim +/buf +807 kernel/trace/trace_syscalls.c

   801	
   802	static int
   803	syscall_get_futex(unsigned long *args, char **buffer, int *size, int buf_size)
   804	{
   805		struct syscall_user_buffer *sbuf;
   806		const char __user *ptr;
 > 807		char *buf;
   808	
   809		/* buf_size of zero means user doesn't want user space read */
   810		if (!buf_size)
   811			return -1;
   812	
   813		/* If the syscall_buffer is NULL, tracing is being shutdown */
   814		sbuf = READ_ONCE(syscall_buffer);
   815		if (!sbuf)
   816			return -1;
   817	
   818		ptr = (char __user *)args[0];
   819	
   820		*buffer = trace_user_fault_read(&sbuf->buf, ptr, 4, NULL, NULL);
   821		if (!*buffer)
   822			return -1;
   823	
   824		/* Add room for the value */
   825		*size += 4;
   826	
   827		buf = *buffer;
   828	
   829		return 0;
   830	}
   831	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

