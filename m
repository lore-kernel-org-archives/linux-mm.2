Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37744C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 15:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0F48E006F; Mon, 11 Aug 2025 11:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9078E0060; Mon, 11 Aug 2025 11:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C059A8E006F; Mon, 11 Aug 2025 11:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B17A88E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:10:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81CB61601BA
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:10:17 +0000 (UTC)
X-FDA: 83764812474.17.0924351
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3C3868000F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:10:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TGwI6NLk;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754925015; a=rsa-sha256;
	cv=none;
	b=rnjbPvXlcy17dvxBlbeEGbzyuWoU83UZy59k1wO0QLE9ktYeC6TOwT45cBjU4I5ywagdL9
	XnZ9WrG9h35+AWuWG97sw4wqKdtykReBfpkmXYCxo58/mz1JzcB/IfAj9tWRbgTG4DDEfM
	awMTZe4uoF6YZDixFTRUEzlUm3MThJI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TGwI6NLk;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754925015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntsVdmbsLWz6V8V8Q9f2cPiogugMbEE80AxdHYNmJ+M=;
	b=8DVXWyukOgyHnsPQDnx8TEx2lMbsvTezyorKJuyrKR/rHmeADGxznhnf54eru0eLXfM25S
	cYnhk91AAvEEsZZCdu7AfY16pz+ZzKIcV7+wHjpeI+c8LS6uD56kWoyiWpfXOCZtRUvs5s
	n/tBW6pv7+3HmZEUM17FNTJRiD8eLng=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754925015; x=1786461015;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5zT1AiufQmdFoxK3k4uUGhgeuApkAvlocyRFSIML/z4=;
  b=TGwI6NLktRBKmMO3/UagBOqBDpDyqHuVJIRBb6dd2ibBINbY/JC0aFeh
   BtbDUTn5hNvZjNknQMBXPM4LNjsz9X92tmd266o9hBZvbJI/5Qu2/Qv9D
   ekbjLi+u/i0WKyrqiPfbcnDtm6a5K4JQ5WqQKLMSA3Ob6bi62o3zwp8n0
   NyhnqoCWZZFNpLrEJ5Xrq0jFXWm0G633kwqPUdWptYNMJoxJJaX4puHow
   Rm/y9rdw718tWFRfjJpRgl114pccKInummfgTHtLqWD7ab+M56ThAS4ez
   S/b6goqB47YLjw+HSQ+qsl3+x3aoVuQQMX+sGXzsGAozngxYW5LTyQDDk
   A==;
X-CSE-ConnectionGUID: uNdAyQyhT2GoIvAL0ANTsQ==
X-CSE-MsgGUID: zrbctqh2TU+vxcKD+Mwi6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="79750524"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="79750524"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 08:10:14 -0700
X-CSE-ConnectionGUID: e80qHBrnQ3+4tIioB2Gvuw==
X-CSE-MsgGUID: gQ9FGlJyQies9g8Zki86eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="171290349"
Received: from black.igk.intel.com ([10.91.253.5])
  by orviesa005.jf.intel.com with ESMTP; 11 Aug 2025 08:10:07 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 7E14494; Mon, 11 Aug 2025 17:10:05 +0200 (CEST)
Date: Mon, 11 Aug 2025 17:10:05 +0200
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
Subject: Re: [PATCH v7 2/4] include: Set tsk->comm length to 64 bytes
Message-ID: <aJoHzTKO9xw2CANn@black.igk.intel.com>
References: <20250811064609.918593-1-bhupesh@igalia.com>
 <20250811064609.918593-3-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811064609.918593-3-bhupesh@igalia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Stat-Signature: tyqzjf9ja5sajin5iqnq4yyc56tbk6wi
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C3868000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1754925015-471264
X-HE-Meta: U2FsdGVkX1+YhheMfWHMc/oGyyK7UdHIXIHKY9vybyRIIbY/2i/McCAeTCeRO2vQCvFiHHKhj99E7Fpw+UMOL6FUYSKXAdKRTWTayX58DpWSQfFyzc6x+FgUxDB9DByEWncYapQEJzWuuFRceZPEtSFtWaf1TlJEZAymNrjpZIoJ0X1es6mPV4IYqoQ1MY21C6fDnp4zcYHAXfQrct+fCxlCCF5U6naHScR7yZE5MRWDeaqOCyFSktuCL+oKl528izfMflyjh7akjZz5ISt97MQHXFQWnNJW14PXecD8GhGiI8vFbXjeyz1eoN2cg/5nrnUztKQeRMrKq85acWA1iEWJtqbKePlGY4HpzPxt5q9Gj3jVU1mKcYZ1AP9zqGTGjynpN5SnDAWVolLxw+BOtw+UafcCtn2gDj74Fk9fJLC5Q5r5sA9JMNkhsKbyZ6mHZiao/86t95yh45MTX35q6fH/KcJC4GJkOM+Hk9nTT7wMrrPRL57EPJX0EtpEIEz0Zjfqhd6WYXZc84glPid3YxPXrKAUkaQMrxn0eRd/3iyg/RhB7UvvXLj61fv/fFvUDpLQQs6dW89ujMlokL2/hLkYSyNMC9eB02VtLavpIq8LvtcIVPhJuDjcx6WgbPGLUrUI6dgdWliFMZgxLsln25gJyb3BEvVgevkCjoKI5r3X1LJ9JrDn169je9Xw63ojK36T7fDAqu4t/86HDOrzsulXB0fggGmFv2RngpsHLEiFXbYDiNeknsvhXJKtJw2HAeskv9bfYyhW6kLjZ8t+I1Aa6q3zMlPQ3PPO0d5lwyJqlG0FBtPjE+TpZiqLcWsai6ukjORylGHjqWrxHc+gl6Vuwpsy7+X3eNhdXXD70EjtNUpc3rfgYQedaz81G8YVLnR2UMZNPpGBJhI/rS9wHFWGiqvBMfbmrMvfNKNQc7cPqyq6+CbyE/qsberTOhoUirwo6rcrf4WRYNtWXkQ
 sIq5bZsj
 KFnoE+p6c7EuM4vqdQKS5UhaDJqtaGo6Vh+ONthl88Ugvf2K+5DiooRrbAxBo30cUkaNfOo2v8o0akHaeOivS+5hK/rFwX+bdcHMeiCBEJ1LKBOQp3zORT61/2jFAqZmT5rtNOmUI8wMxYPqHIEUlFCm/lmx2RjTmL7LAue0K7ecNjdwOUQR745jPx4Fia18UZVOpJrvqKcPbDunebnka/BQVuoXZJMPvtXDF7q9FnUDpVEc+DZZQcYJ9IJybJbqYH2XukEos2Ilzeh8IkNbn87c1ZbIcnwfkvHTbcfFwP/Vd+hluGSbON4hSBocHyapj6VlcqaZmjUrahDC+sbmrFbXdIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 12:16:07PM +0530, Bhupesh wrote:
> Historically due to the 16-byte length of TASK_COMM_LEN, the
> users of 'tsk->comm' are restricted to use a fixed-size target
> buffer also of TASK_COMM_LEN for 'memcpy()' like use-cases.
> 
> To fix the same, we now use a 64-byte TASK_COMM_EXT_LEN and
> set the comm element inside 'task_struct' to the same length:
>        struct task_struct {
> 	       .....
>                char    comm[TASK_COMM_EXT_LEN];
> 	       .....
>        };
> 
>        where TASK_COMM_EXT_LEN is 64-bytes.
> 
> Note, that the existing users have not been modified to migrate to
> 'TASK_COMM_EXT_LEN', in case they have hard-coded expectations of
> dealing with only a 'TASK_COMM_LEN' long 'tsk->comm'.

...

> -	BUILD_BUG_ON(sizeof(from) != TASK_COMM_LEN);	\
> +	BUILD_BUG_ON(sizeof(from) < TASK_COMM_LEN);	\

Wondering if we may convert this to static_assert().
(rather in a separate patch)

-- 
With Best Regards,
Andy Shevchenko



