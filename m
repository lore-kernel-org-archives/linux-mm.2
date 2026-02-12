Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE9BBEE36B7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52BAE6B0088; Thu, 12 Feb 2026 12:58:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C8CA6B008A; Thu, 12 Feb 2026 12:58:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5DC6B008C; Thu, 12 Feb 2026 12:58:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 31CFB6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:58:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DEED21A01CF
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:58:49 +0000 (UTC)
X-FDA: 84436565178.20.AEB6AAB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf03.hostedemail.com (Postfix) with ESMTP id 129D62000E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:58:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YItqkGFQ;
	spf=pass (imf03.hostedemail.com: domain of ak@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770919127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a2KU0LI+KSpzCe5tkXVBLFNKyUpwRrYVFKNNI6I3Qvg=;
	b=VKDbAnpF6DlclB/svMDgbtrqr5sSrIJo5Q4SHgWC0rihP7OSlkNlPf1Yi5HD2D9NIEIY+5
	6p4hbpT+9yZBGKWAw8JTtdsU9K2pXScNMV7dR2GgStIPl2Wvp7bxjyPN/gLxj8BX28PTAH
	CIDZcMhwdvl8eKs2D/AVQlFlYNmgaig=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YItqkGFQ;
	spf=pass (imf03.hostedemail.com: domain of ak@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770919127; a=rsa-sha256;
	cv=none;
	b=BDjCuLZwzn2lu40InO/ktI06X8qWxdh3SXwjGeDb1ej9LYZaicLCRBdIfDRJVCWJ6qJJp2
	ZWLPcExLNzyLrZwfrI1YWegQUcsgdcZ9YL5p9Y7yZt2dev5xdCGBpH5Bp72gUkYD/wX5Wv
	bbzvN04+GV456rvyjwgP0G7dWe+IESo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770919127; x=1802455127;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=czniD9eVXu63A1Dr04VMk1rvEhfshkPs6aT8Ct2ynTw=;
  b=YItqkGFQVSdsxQEH6nrLcPiDw/TrOju1VQ91bznHWt7y98Mb6JbWIacw
   IjZwy3vWr4BdqYGrUy9/Mki/QrE6ZNtBme8p1JyrUhBtNQm1qC3fEQbx4
   P/75ZpAE7Y+vDAbvr9y30TiTHRfHCRrvDC3YVcrnm53chdeD8+0UKd3/O
   T3FCsJJg03heKdys4h/BuhA7ktDI8W5/NOPpmiZTtMBUzKKyhqv2eIeI1
   x0S2dMernd84amxdyPQApWx6IdaOJGoiJnhpiFD3iO1QLraqkQ1ZuF1rP
   vSP/bphBfE7uKndz6Yy2oQ4M1da3ijsWgqy+m1I3aui9w9W19Ucuwdl55
   g==;
X-CSE-ConnectionGUID: 4VU4l5WOQ924egdotZP5Kw==
X-CSE-MsgGUID: CO60UFXgSI2vGZMg9srmKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="75944813"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="75944813"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 09:58:40 -0800
X-CSE-ConnectionGUID: zlg0fuHlTWOAJGxgt4BuRw==
X-CSE-MsgGUID: fcsycVijST2k8+6BxLyHrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="216836119"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 09:58:38 -0800
Date: Thu, 12 Feb 2026 09:58:36 -0800
From: Andi Kleen <ak@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, willy@infradead.org
Subject: Re: [PATCH] smaps: Report correct page sizes with THP
Message-ID: <aY4UzC-X4a39wbG3@tassilo>
References: <20260209201731.231667-1-ak@linux.intel.com>
 <94a21bda-5677-4949-a1df-3f0d90348021@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94a21bda-5677-4949-a1df-3f0d90348021@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 129D62000E
X-Rspamd-Server: rspam07
X-Stat-Signature: quucx8s4zkr13dc4gtf7hyzb4cum9fo8
X-HE-Tag: 1770919126-127753
X-HE-Meta: U2FsdGVkX18j4y6pvZa+tXZWY/6herwpy54w2w/1FORjHqViRe7Od2qxEwI6FNotRJP5dBTqg7eIfH+Cuc2jE2B4DRSXHofIOuFz6XTOOM3QgLyBgTnYNS+UYykcAg1Itg7JRK1qSeCpeC6aLWPZ+9lSQgaHFr6uDTZC4hPnpGHtnqDuaJ37NZTEKQjTlyuvvE5mnPcRZdMgUWnVqwpoo0g8bLb1YPlD1bsWOkQnmd7Rxwg1swzk78Ekd3EHs824rMeOduSn09kIvRwjyeOKns7X0fD2Xbryzyfr7w5vrPezjZu6yY8QuBDlPZCmeVuBriR9dJilfv0dT+weCtsM7YfzoyAgBbNyJ9R2oay7w5mr6xfOw8zzfYDi8WvZQPuV6stVx//zYyHkY8NZukoALpSoqyw05GhtuGBKmbceRg8mR2XKiF+2HNNyUG+zfZZJiGyWL91PvP6clIt9bx5Lmucsbdh5kpJ8Ps64W/J/McVpxQcfMHF5arjaGOMTtsPnkCmlD8csG+rhSWfiAifUXzZ5LGhZOpveRwL0PXxsV+spAV8gieF9re4OSyFLrZ3PHaBl7veT4wUmK0hg3XD0gVzx5eNO9C8/wvWhNAdwZliN39rmuob1gg2CYo+fschBIm2GHjY1fBa9NFp5OOujOzAHCROW+8Lks2kE73f07HMen7u6RitwBBsMgkiiKl5I5zxrKakxBQ3hqbcynpQfrNtbD1zvFiUet4Kmmwp1gJb820UkM2OP7CfufI+7WsfzAFnSGgppMN5V8zL2/RpGHgeL+FBjXklX1+Hr2PP1WSXuSTStGySOumbsVN6JQLw/FfiMGUhuGX4Xl/yUQzwxwPGQS/IZRq5VEquhv7CIoF8VAcWe3CwS4ZUSp7DHbxgyMyMperTwI+x7nMW9oVL8UwNxj6T+jMaq7zJqejmZ48SXbj5MJAQByZDAZfVJENjfbN2SqmfjTIA1ySlg0ey
 x+kSONjw
 OQwJLoV4jqwXH+fVdbpagbHhjuudJE0SAdRReNnxNv8TlMmzy0muYeyjBXtEv5GG2d+rSTELEJdfiOcrAiW72gQitOTEzptSyIDSxIZuAOUsefmM7oGcocUCcU9IamQyijAZGs34FRClGS8+mAkUVGJWwHSJZThVZWSx1Zor9sCB7HudGrd3gN8QkrzcZnq9kX1V9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> We have AnonHugePages:, ShmemPmdMapped: and FilePmdMapped: that tell you
> exactly what you want to know.

.... if you know about it. I personally wasted a lot of time on it
because we trusted a lie.

> 
> Especially the mixed thing is just nasty.
> 
> Once we go into cont-pte territory (or automatic pte coalescing by hardware)
> it all gets confusing.

In this case it can be extended to more.

> 
> Sorry, NAK.

Okay then just remove the page size if it's fictional outside hugetlb anyways? 

I can send that patch too, but it would seem inferior.

-Andi


