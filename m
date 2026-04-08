Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16087FD5F77
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 04:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01FC86B0088; Wed,  8 Apr 2026 00:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12F56B0089; Wed,  8 Apr 2026 00:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E289C6B008A; Wed,  8 Apr 2026 00:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4D596B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 00:56:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7967F5BBDF
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:56:28 +0000 (UTC)
X-FDA: 84634177656.19.7C839BE
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf26.hostedemail.com (Postfix) with ESMTP id 34791140004
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 04:56:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775624186; a=rsa-sha256;
	cv=none;
	b=SB3lr8WCzrIKATzHnUUHHiS4yvCTjjuJlvtqpmQWEfNw5mIORlAZOKxMMPT7hKUlcd5cKI
	56cslCalSw+V95rEUGmmKb7sNi2pAksg95iljD9AmEvQRIM5Uk7ESIPxjVBbOaE3069BJY
	WNd3g8VvyBCPpJlKTDWb5bsAFx01CIE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775624186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MAJbeMRDDxAItV7hO1b+8Cj35xMqD5zIordHjGBqXLg=;
	b=Z3hRYJV+BgJOwTMIrpyewZRtkpswHhAJSOqn1WuohiqJIdulsUTT1Y+cl6noc44q2xD4VV
	rq6p286oACdZwT7JAn3v+KpE9imCfcdwyMPmuVBANtoX6meY6UqHfr9tKQNXjr/3mUpfSk
	1BhhjzPnyoDYRq4yium0nFgdGylvZqw=
X-AuditID: a67dfc5b-c45ff70000001609-7b-69d5dff35c30
From: Rakie Kim <rakie.kim@sk.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Jackie Liu <liu.yun@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Andrew Morton <akpm@linux-foundation.org>,
	kernel_team@skhynix.com
Subject: Re: [PATCH] mm/mempolicy: Fix weighted interleave auto sysfs name
Date: Wed,  8 Apr 2026 13:56:13 +0900
Message-ID: <20260408045617.318-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260407141415.3080960-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsXC9ZZnke7n+1czDa5dtLKYs34Nm8WuGyEW
	z7f+YrT4efc4u8XxrfPYLfZdBIpf3jWHzeLemv+sFo8OFlp865O2WL0mw2L20XvsDjweO2fd
	ZffobrvM7rF4z0smj02rOtk8Nn2axO5xYsZvFo+dDy09FjZMZfY4d7HCo7f5HZvH501yAdxR
	XDYpqTmZZalF+nYJXBm/nnxnL/jIU9HQ0MrSwLiXq4uRk0NCwETi1t3ZbDB257c5LF2MHBxs
	AkoSx/bGgIRFBDQlTrROYu5i5OJgFnjKLHHt7EEmkISwgJfEwcNXWEBsFgFVifdnDzKC2LwC
	xhLNZ09CzdSUWLfxFlgNp4C9xLNFK8FqhAR4JF5t2A9VLyhxcuYTsBpmAXmJ5q2zwZZJCHxn
	k5j+fTkTxCBJiYMrbrBMYOSfhaRnFpKeBYxMqxiFMvPKchMzc0z0MirzMiv0kvNzNzECI2JZ
	7Z/oHYyfLgQfYhTgYFTi4T3x40qmEGtiWXFl7iFGCQ5mJRHepPrLmUK8KYmVValF+fFFpTmp
	xYcYpTlYlMR5jb6VpwgJpCeWpGanphakFsFkmTg4pRoYjQ+enVLyv9/zk8D+R/fn3zr42FFC
	ZgZTqGVPhCD/Np384NZ6TtN1jZsvnHUJaN9Z7nmk+8CxeJVWuz3XnV523FuzLkfP6ChXqMS/
	vyyLDgmJLr8if/TnEY57bhLXfpdvlAtMuCvX+NHsdNu9eTrN0reeL538sWjtjN1Xjyx4yqW4
	IiY1vGbhRSWW4oxEQy3mouJEAN9CIl+EAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsXCNUM9Rvfz/auZBq1HDSzmrF/DZrHrRojF
	uSmz2Syeb/3FaPHz7nF2i+Nb57Fb7LsIlDw89ySrxeVdc9gs7q35z2rx6GChxbc+aYtD156z
	Wqxek2Ex++g9dgd+j52z7rJ7dLddZvdYvOclk8emVZ1sHps+TWL3ODHjN4vHzoeWHgsbpjJ7
	nLtY4dHb/I7N49ttD4/FLz4weXzeJBfAG8Vlk5Kak1mWWqRvl8CV8evJd/aCjzwVDQ2tLA2M
	e7m6GDk5JARMJDq/zWHpYuTgYBNQkji2NwYkLCKgKXGidRJzFyMXB7PAU2aJa2cPMoEkhAW8
	JA4evsICYrMIqEq8P3uQEcTmFTCWaD57kg1ipqbEuo23wGo4Bewlni1aCVYjJMAj8WrDfqh6
	QYmTM5+A1TALyEs0b53NPIGRZxaS1CwkqQWMTKsYRTLzynITM3NM9YqzMyrzMiv0kvNzNzEC
	Q39Z7Z+JOxi/XHY/xCjAwajEw3vg45VMIdbEsuLK3EOMEhzMSiK8SfWXM4V4UxIrq1KL8uOL
	SnNSiw8xSnOwKInzeoWnJggJpCeWpGanphakFsFkmTg4pRoYUxdv/sg4W2eC872dtc9Kdzyt
	seG2YH324fcxDo0wW9fwPQp33Mykp6wW/eLfnBo5P33W7ufnTyVWL4vKlPX77bnIuveZmLWt
	7uZZ/y3mNIZFyl6RnhiZfze4I2pL00dvnh0LY/MiFkaZlZ1qD/G8Oalrrdiq1PZDx1iPWL4s
	2HT1xLTXbk+ElViKMxINtZiLihMBsWaQjnkCAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 34791140004
X-Stat-Signature: xikgheefisdr5w666zhkk8mrqj5o84k8
X-Rspam-User: 
X-HE-Tag: 1775624183-598237
X-HE-Meta: U2FsdGVkX1/oJtYuKo52E4WTHLom2mdLSkWIHJxH6bBd8k0j8llG6MMRa76p96phcjuLWNR2Bh5vSNcB0BCCx3XBl665323rPOSA1hJ8kipcTKg92GZ68FV+//YIgGWW790wfRNRraBymLMeiqSBlGBr1GXF9tNWqk3EVrz5gF/s5cOj/kd3Iv4skPviWWkmg7e4QPPG2v9GjGffFkn522dmXbcIyjKg4dOZ4SQZ5+8HtFOLDHqYupAtphhw8hGjs2Ff/KXUvLvqOLPc3XFOiz8DMuVlrMr+LO9jJoEsTa+XWj+wH5WsrtNJ+c2rkv6F+UH1/vkbRrtA3iWgK/93WKCs0mFZMannhBKv3MM4PIm6m49+bdRuDYvj3m716roOBdZpYZ3NWe9+AQg/hDKJGL5L5RxHhNpuzqNoW/P9jz9DKdukZWO4RumMCSLF/On1fRG2UN6CTEXRYReyespFbGxGjuWONbMEZUtqysz7THSLiMw64Xj/sQ48pwtcu2SBZvrT4Hd98Cw4b+uAD5zo/7qvnvT7s6WPTYuGwZvJJm4nTTohEPbui/RU0svTLz6Ib6JgadtkxRjekoJDe+FFF9tLrQLLfPOhotoxbgNae8gPQNdssYFOT6RbUBDdkkC1TRuHct8ZoNsP3IOCOyXBEM4sriHCCYAM4/halKkIt3qkQYQQvguP35sU/cTPpVnLydKdVyJIXROUrI95h8J49mu6gQx44ZTBZgL1sCi5sv48PRckKA//OLuUMeSXheNzBP00Fj1or7oHU55GiIWbHe2G+SaXulHm3W4YEqXZxuyLoVlIscL/fDYq6OPuTWZoarAS2rVlP77J4bOuRhMHg1tuyRc+/hvtkn1H8IdPyyjylTtrvEm1X28bKcp4DtOnzvI4UgTRDTJ5p5v9qfuVlcxxp/dbp8T+XApZMC0bd1Yi2Tn1Gr3bJgOMBUCuNz22H2IsmCkT9AKurkkXQ6G
 VwdnS99i
 cWjNF7VLy6gJwFGenicrGyZ9OXrPewPQcZt2tDDcqbWhI/Vu3oUzaFQMWjs17BEPlibRfYmkUuttK5uoxPvk+4YpmS2LjtN+cmEib
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  7 Apr 2026 07:14:14 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> The __ATTR macro is a utility that makes defining kobj_attributes easier
> by stringfying the name, verifying the mode, and setting the show/store
> fields in a single initializer. It takes a raw token as the first value,
> rather than a string, so that __ATTR family macros like __ATTR_RW can
> token-paste it for inferring the _show / _store function names.
> 
> Commit e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> used the __ATTR macro to define the "auto" sysfs for weighted
> interleave. A few months later, commit 2fb6915fa22d ("compiler_types.h:
> add "auto" as a macro for "__auto_type"") introduced a #define macro
> which expanded auto into __auto_type.
> 
> This led to the "auto" token passed into __ATTR to be expanded out into
> __auto_type, and the sysfs entry to be displayed as __auto_type as well.
> 
> Expand out the __ATTR macro and directly pass a string "auto" instead of
> the raw token 'auto' to prevent it from being expanded out. Also bypass
> the VERIFY_OCTAL_PERMISSIONS check by triple checking that 0664 is
> indeed the intended permissions for this sysfs file.
> 
> Before:
> $ ls /sys/kernel/mm/mempolicy/weighted_interleave
> __auto_type  node0
> 
> After:
> $ ls /sys/kernel/mm/mempolicy/weighted_interleave/
> auto  node0

Hello Joshua,

This was indeed an unfortunate and tricky issue to track down, given
that it was caused by an unexpected global macro expansion. great catch,
and thanks for the quick response and clean fix.

Reviewed-by: Rakie Kim <rakie.kim@sk.com>



