Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 316C2CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DAFE6B00A7; Wed, 29 Apr 2026 11:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B2C26B00A8; Wed, 29 Apr 2026 11:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F0546B00A9; Wed, 29 Apr 2026 11:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81B686B00A7
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:37:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 146D31A0192
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:37:35 +0000 (UTC)
X-FDA: 84711998070.20.B127A36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1D2DB160016
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:37:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WKmsyJXz;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777477053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pzlYv1U5hRb+EqGNj31ZxkH1FvLeggp0wPWYwlCsY0g=;
	b=ejqZQyeofmcCVIUaLmT+HgXwVTHimkmSYMnRyBTB0v7B6Yj4xSba6CYsOEOUEgCtBNB4Ty
	T46c4ycr6COCEyIO2iYqW3ry6F76/UHk1HffNkvbW+wwVDrS0dU6MyhZhHZu2ej+8t3mB8
	+Dp9MdVJbliPF0t8B+zRMZsfuKnjL+Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777477053; a=rsa-sha256;
	cv=none;
	b=xCJ9NWFlahvdgMrYE2yMXVDe9spN/9Nv1CA3Krb3h5K0YC9M92S9pFGdTUIe4i0SglGg7A
	7yJNG93lf5nqeLzb7jOTjt+kSDL+AlWBtTuW1C/irzQ9xToag7xhQWs7BESVBG3WuCTXRA
	cEJrQsDbRJJHExU7LM+uJjoax2Ou3Vo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WKmsyJXz;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB2E2435A9;
	Wed, 29 Apr 2026 15:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27934C19425;
	Wed, 29 Apr 2026 15:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777477051;
	bh=dBcxIGB3prEt2EuN+URD9BjkYZPuyxPQexFsSFds9no=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WKmsyJXzSlFrM1KOOXRL+rDlllSB1diKpuGdprKHA6iUO5kEBlav3buILWcMzw5Cz
	 Qamb9pqLJhl7vBxZRelRsnXd7SdHpVtsYnVxtrR2A4P3BznxTIKr9YwDLkn+UZUYvB
	 UrDgmWIEz2ubQ+VTK2AvC3ETFlRFC1zMUamYWSQw=
Date: Wed, 29 Apr 2026 08:37:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, Steven Rostedt <rostedt@goodmis.org>,
 david@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>
Subject: Re: [PATCH v3 0/8] mm: use spinlock guards for zone lock
Message-Id: <20260429083730.c105bc1cff04a8e92a74a32b@linux-foundation.org>
In-Reply-To: <cover.1777462630.git.d@ilvokhin.com>
References: <cover.1777462630.git.d@ilvokhin.com>
	<13149be4f8151e18eb5f1eb4f3241ab3cffb373e.1777462630.git.d@ilvokhin.com>
	<cover.1777462630.git.d@ilvokhin.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1D2DB160016
X-Stat-Signature: 1ghsxzus3a97zzjgo9n9tswote3cy1pu
X-Rspam-User: 
X-HE-Tag: 1777477052-495165
X-HE-Meta: U2FsdGVkX19Yr0NkzIdP/sShLJyO2OhI2b8WNP4W3gYzC3DqX7zP7yW/T5YIbvDjIOjaqh0OgGd/WFHq5RBFSG4DXC6U1DZBosKTZ+jJ8YfVvsH/GcW9CFbxxx/XWleLa92I/xCi6hTnKi48IcXXjfER8HTVEejqGlp6YdywqGTtI1yR3Sl8l4FpANTyR/oGZhl5Q5o7tHbZ6J1bAw1SlztM1JJO10gN+6BpdkzILPdvKhdJsZ+DltOdRVeuULMyz76vsgzy5SPrGzp0W9vcoNrhUHAU3dZdN/ovlBh1RnvfH+DDJlUi8HvwH0PuzKvqdWvtR44wW7myIdip6PxgoJpDqfG0Tzc6J6k/LjYA3v4h7nzj/85g1E8E2ZEOhOYy9Yc+osNgp6jZhCFqGUJeo4SkNoFNqFABKZ1mD6x7PDHpGh3DwJ1VCGkRKoH+k/xL3WdbEzRjAOFouZ1uiFlPVs7VD4sPIYicc0hNCIBpUCSnUGyGbfNYyul6pH+WGnxd4Kfc0XZrcpbk5scpzUB3Za+MNLmiShdnOWOP29u0l0qAPv2A9QoUKAMR4z9FGRPNYBXMC+Swx3uAwyQ6IekZ0QRlpmBQt/9+Z0Bt2MFU4NhXg1d5nVHlk7KS0i5RaxAGDmH4EwNP3kqf/Hy6p/H9JEHNvP+qVrPb795BDU9AXlxuV5hUKCFac2iXFDw4BBPryMTWKpCJEqcs1904N+UKkIOYORN/ILbUjkG781/+8VPwn9zisyfDI5zeO7QWW0E3VvGhUOTBBeekxQel6gsn1ZxkkZRQaoCe9p6YKQYJhc0FTQyVxKWwl5QGhgwzdYyPqTG7z43k6y5j1gflw3nPcoH4OOSxYqFDua4hWztL9VFDifWlwJYXJmp4cHv2ORIWrsCVUxxbr/YPrNG3oFCn8EJ2k6wh5JBRPmTF5v/VeJH7X76F/f2gJdm6qqDG/ewbCmhhD/JxRCiqPJEJ4C7
 K+efuwfj
 EHrcMgKby+UnkcSIv8fCCiKc+AMQgiGpg64Zk/WlrAgYlgzhCAEELp8oKLi6kva1jXydQ8PJFfZGuFnzd6ar2JK+i2hCiFNapDGMCwrd8I/6k2ztIGIzMK83RUrbYvJ1N+1xoPmvhY2f03r3GLv3J5Ojq5J0AcqHfuKvxrTzijUwFgbpQ1gar+C3jPuPK0WpxglVIx85cV9DfAjY3wCAUe8VUcHrmpFJW+k2iSRb1i5viXfA48vZMqu/jy6baUoDNVviXU3heB0pLokbSbmaqFnTKYq5DOc1u4+2G/ltfssNz05F0jBduRAnJ3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 12:02:05 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> This series uses spinlock guard for zone lock across several mm
> functions to replace explicit lock/unlock patterns with automatic
> scope-based cleanup.
> 
> This simplifies the control flow by removing 'flags' variables, goto
> labels, and redundant unlock calls.
> 
> Patches are ordered by decreasing value. The first six patches simplify
> the control flow by removing gotos, multiple unlock paths, or 'ret'
> variables. The last two are simpler lock/unlock pair conversions that
> only remove 'flags' and can be dropped if considered unnecessary churn.
> 
> Binary size increase is +39 bytes, with Peter Zijlstra's fix for guards
> [1] applied (already in mm-stable). This is due to the compiler not
> being able to deduplicate epilogue and eliminate redundant NULL check.
> See discussion [2] for more details. I proposed a patch [3] that fixes
> this, but until it is merged we need to assume +39 bytes will stay
> (though it is compiler dependent).

OK, thanks, I'll queue it up.

Yet again: the question here is whether those who work on this code
like guard(), or would prefer the traditional open-coded locking. 
Michal was an ack, others were silent.


