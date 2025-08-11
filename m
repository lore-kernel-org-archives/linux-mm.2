Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AABBC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 15:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7C38E006C; Mon, 11 Aug 2025 11:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCFDC8E0060; Mon, 11 Aug 2025 11:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D898E006C; Mon, 11 Aug 2025 11:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BECCC8E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:05:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5DBE681844
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:05:47 +0000 (UTC)
X-FDA: 83764801134.25.355E897
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf01.hostedemail.com (Postfix) with ESMTP id A6C0F40007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:05:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eDoBwKKF;
	spf=pass (imf01.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754924744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7RT789ogYAfSgTZ92jkJgJ+3LiLaXGaBKY0/GRWZZY=;
	b=iDAf5HUKubSl+vigZvkeixwN0zDbSM/SZ+V9uJWxb7iKQX0uhKkmzqozacDUJZUYZInV9j
	pAmhy2XnbYaCoE6d16M82HlSRji/7MqzcnhOmPZGsKP8oAgdEsS3grE+o/GeCYkhVSOdC5
	Y/kFf0dwGoyhxTJoI08r1DBBIRdEmGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754924744; a=rsa-sha256;
	cv=none;
	b=P/vH/OVrykxTsnk1ynOnkw45HkGdPh8OkeUG1PxT5kTpakFm4L5lblbOJGxKh1zYHqtVRK
	t+Lj52YLR72xVfNCDE/cbzd7PbSsQPXp2DmlAVkpbbvvW8JLCG0NVnuRGBhfCjaSxCQE0W
	POdifL02HGF/PIwkiYRgEF5K5TvTV/Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eDoBwKKF;
	spf=pass (imf01.hostedemail.com: domain of andriy.shevchenko@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754924744; x=1786460744;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i/ALEUiI1jcKPez1nkMbsZV3bmmUIaCULP31iZ/ovAw=;
  b=eDoBwKKFTOUnjUhPoxEG7MQKe0xagBusWNZY1RVcsffuhRVRsWANru5E
   N/LypkBnwCODWzQ7uIumVwB3oIQviYxjLZhOef6i0YmP4siCDOsRXIXMJ
   gIfZaS8ZzG7XQj50nc2/jGzi+bLgaLeqwvArTU1fxwmd4ytN48Y8me9Hl
   xYTMbE65VKZi88cMLuOyLnk2YuUG0+j1zri3IIVXfI1b3ruy1Xg693Um1
   1RxYacXyVOaiM3ZrJTt9u5KOfenF21N8+h+8O5paAtoqGO6kiDllMPMHz
   tEs0QpJk9ujC0BJLfZKKGpGdjl4BVlX3/4DVA0df89VrnY1LmA5+qARGx
   w==;
X-CSE-ConnectionGUID: xFJA0My/SruA+8PBNTB9OQ==
X-CSE-MsgGUID: Cx/RhIqCSKSgscvTY1tgdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="56208643"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="56208643"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 08:05:43 -0700
X-CSE-ConnectionGUID: nOIz8zmnS3q0/SNtukrWfQ==
X-CSE-MsgGUID: jQdLgscnT9ud1YMXf+61aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165571264"
Received: from black.igk.intel.com ([10.91.253.5])
  by orviesa009.jf.intel.com with ESMTP; 11 Aug 2025 08:05:37 -0700
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id CAC0494; Mon, 11 Aug 2025 17:05:34 +0200 (CEST)
Date: Mon, 11 Aug 2025 17:05:34 +0200
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
Subject: Re: [PATCH v7 3/4] treewide: Replace 'get_task_comm()' with
 'strscpy_pad()'
Message-ID: <aJoGvv5TEfl1liSm@black.igk.intel.com>
References: <20250811064609.918593-1-bhupesh@igalia.com>
 <20250811064609.918593-4-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811064609.918593-4-bhupesh@igalia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Rspamd-Queue-Id: A6C0F40007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: mpexxehrnaf3ra9nsz691q6edz94o7wz
X-HE-Tag: 1754924744-596685
X-HE-Meta: U2FsdGVkX18wAbdgIa0AeIHxBN8nZ4RsC/KaMUVH0hU5ih4mF56ZXm9mmFv2zdbc1QgORjkTUWmFVaGUM6y7cJiAyiNNIQPTmrB2HkidtJztqLUUR6JfxSgShvPsqdE27Q7+ogz1V8m9+/W6mbxZ+2iB1yenxFMPxvbc2uZNy1le2iJshAdgl3+26p62WZk3ehQwXXXGijJsEanIE2LZkadcAFx3Bgd1QqqwY1PZhE74YbpyCxZYAYtOZ/A1vGCAePTulToyl8H6M/xVq8g/KddQAV94JGVQGP4nR3QJc1fSMqXwNmWEBYjMWEuIn6LVKAswFEFxwGCMvxiKZSI1NwpHch9cN/V6Za0qEOcUaJzD4SPde4izXk4VUKj3V5leZS58N5xdN84bBD1cYuNRnQYwyddgcLZ2lgoAAWowDOjHWFp6oKuAgzlcM+D5U8C4YFd63pm/LagVAFoFmNreRQQhdo4DL6htGVIrV8xUbnOK770CJKVJ7WhcXHbTVs9J2vKPwELbH9orFhiWNZ8XRMLuluTGLPs0GpYkUb9M0OclLbJwmbunJoEMn3Q4Pt/NG7XwfbKS7XXizzLLVHxdAh1Pu3ZpeZGYj7ws7eqKWNhqZY3FRWKvZHanN7z8kdBD29LC+omXNSJhM9XgFJmnbcrnQgbQlSKV4M4gFcmC1frRiLpNtgZMkmCNvi4cEDBjuH6KDZ8jFHugt8XUQ/9eFi5v6/JEtVlfJ/HHGeGsJu6U29WImLykDvJY14z7K2eyxrgAme2czlz/fDPpU1ygIbVGFga/ljhnjZCBy6+rWVt2nLkl8V4J2fSwp//RAfXaRnbtUybIeTmT6ZvSQUODSsH1EF7Q7fsytPQJWrPtiSn7KYA7h3NhX8kU/Z7Z42Xtbyv/Gfv2sCRUAiA5y4ay2zBqQShvjaTqpjpHjhmYT//TL5elGJE+HZYu+qoPoN3B3hHAvfEPf/nUVZN/kOw
 3DDi9PT9
 MdsWJeDoyuLmYBhEs1DuROEu5IQTEKJwaYuOMKEvgOJB0d/bCJSujmuy0wOwk85LvlliXZWyasg3pRUm7iFMUZ2GNz733UBZCJduAf7Wzqv/E4DI7S0PscT8c5ywLTi4WfVBfbe8OpKH80Pw1WaYyuUEfFxz1Np65eerX/SxUqScEzl5z2KGhrY9hFuBtJDVb8eXREGk/ruYV3Cmp/YVcKXleYPva+fVSjURNfQNg86gGv20EZzGZB7nnHmmqo+7xcpd6WgZNxelR5pMfeVY8B8jjLpdAuHhhAHY6U0f5JgfJxuu+lG/GvWfTCYRT8EL+32+q+v9Gl1WMrkjjW7gPJa033r6kEavFXktEbkzzDDgXS2gDDt4iqctcFX2c3pVb6A+6E39JGCD6HkLRJSUhi5jgyTANor5p+3ABGQKWRp2HbyRJg+ZKXlK0tyfG4nlR42FwDRvr6LbGRlHNlQmM5WCWsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 12:16:08PM +0530, Bhupesh wrote:
> As Linus mentioned in [1], we should get rid of 'get_task_comm()'
> entirely and replace it with 'strscpy_pad()' implementation.
> 
> 'strscpy_pad()' will already make sure comm is NUL-terminated, so
> we won't need the explicit final byte termination done in
> 'get_task_comm()'.
> 
> The relevant 'get_task_comm()' users were identified using the
> following search pattern:
>  $ git grep 'get_task_comm*'

> [1]. https://lore.kernel.org/all/CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com/
> 
> Signed-off-by: Bhupesh <bhupesh@igalia.com>

Make that a Link tag?

  Link: https://lore.kernel.org/all/CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com/ #1
  Signed-off-by: Bhupesh <bhupesh@igalia.com>

-- 
With Best Regards,
Andy Shevchenko



