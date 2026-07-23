Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D48DC44532
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 00:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51A426B00CA; Wed, 22 Jul 2026 20:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F12B6B00CB; Wed, 22 Jul 2026 20:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42E5C6B00CD; Wed, 22 Jul 2026 20:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE6B6B00CB
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 20:01:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94ADC1A0366
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:01:06 +0000 (UTC)
X-FDA: 85018086132.26.DC6DAD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 88B27180005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:01:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=F7EwcYng;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784764864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhLfu+qb9+ZbVfQ4M/Qb3L+ARnj/pFSJ2wSRIvxFmUI=;
	b=MdyJQZDomGjtJd0kWgGf7IkzjUznqaXARnbho8PDT46Bst2uoepJfi7xV93GjPc6beywCV
	b+SwtAwrdIibVnGtdaL+3acktpFABdgaYD6sCSVb/wvAcSLkJmcio8e7sdNUK2EFS8VpMY
	SXWyUMIyRzLtyUGlW/10TaP55hjGwHo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784764864;
	b=Q5WMlv7D4r479Egxc1yungHS1klUM6xUNIo7u8LrP039V+j6Xw1FsiEXwTTPP1c6He0+YD
	qcgKEi/sEC5Uzxd1YYCOwLZnF9WZIqJsTxot7KpCc1fhTTL1+GA1q+b1fXcA3V5Ub5nXHu
	urwBtQwWaZQybnb156vzR5VVDrAsFtY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=F7EwcYng;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C65D41B69;
	Thu, 23 Jul 2026 00:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB23B1F00A3A;
	Thu, 23 Jul 2026 00:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784764863;
	bh=UhLfu+qb9+ZbVfQ4M/Qb3L+ARnj/pFSJ2wSRIvxFmUI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=F7EwcYngtr2B551FXjgZaCrFDkakh+6w8n9mXrtSvD7s//zcF4ULJmxeqaPBFCs6o
	 8k0PoG2aQSzKbpy3U3KPpuxt/TGDkN2WO2zm8UmvmVJoNqO5/WiuNgK0gVyKfytK8T
	 Rl58QsjgPDd2NO0B27pJd3X3OOV5095ix9DJEWQo=
Date: Wed, 22 Jul 2026 17:01:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Ye Liu <liuye@kylinos.cn>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan
 Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tools/mm/page_owner_sort: fix --sort, add module
 filter, improve usage
Message-Id: <20260722170102.43620a3d4bec61e738018a82@linux-foundation.org>
In-Reply-To: <20260722023726.600200-1-ye.liu@linux.dev>
References: <20260722023726.600200-1-ye.liu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 88B27180005
X-Stat-Signature: hsouqdb149o5sox437z5ihssik4qtrf1
X-HE-Tag: 1784764864-412604
X-HE-Meta: U2FsdGVkX18STUjZo79ZRLLA+foimaoK1lCEXQSH0tZOQIRRkwKTJMsCfPGZ7DsrFPYF0/9e452VMrbWBEodrkwYpJPl+CfH8kOizfRgCowrOKTg07DdBZWe+MrJUKUgD/BmPqZuRzDFV+z18W71nRdCh3xQBqwPiaRSJQrX0Jn5xBMxIFccWjv41r6j61yBJFKLP50NLTguhEG2+yxRCicd3HirVK8eqVIF/v3f40b4ch2lJOCvKGM2pJXmxrs6F6c7N3cNsw5wzagyg7yaoajpPJv3lupKvXY9aKWQ+Qlrr7CoshTiB0UW0CEW2k5RrBzBgGJzShSkJ3id/jKQ0KVZBRMKLUQORTKE/5FSxT8mLMQvR6F8JRi8rC1v1RzRtSdQdC1IUCjRmezCoL6QlFlQAndwc0/mQAmQMgblc57fAB/z1TziIRtCH3zK/zLbMGYGA6xnZr6SLea3ACp33jDgvA4ojBpzP1fATcWjiAXLiIgfFP8dfAbr7J16q/X/5AyGV/JsmILfMMzpiYJWY1rdL8idPV/K7xebYfj8jQkhg2UVI8l0kUGXogg+gZ5JLrtcRC1J4l05duzjXuUYPSPeOve48rIoHxMep9KrdBxxf4S0GSa8nrpPQ396UkRNdM+giTEV2DyjzJF0DD1t9N84HEHUXzUZtJfns1oNTMURskPHUqzjpS6B0KTzb9Foc3F2cPavCipa5rvULzIu/eIIUidlJFLexYR2iQYVbNP9tW/8svqDfYuQA3QcLHEfNKOHlSmpdlX5qN+lySZXP7MDn4Sd8szw6ATmi0MoWQhoeyTIptFdBzs9OBc9DjCe8eoDfODX7/FPcJ6cBy+y3pbq0zoe/h1X3WM+RQyndZSJmGfH5n0bNSzNOTGksQgphxc1yx7lpvADB7mTFHgzHjQeHHwGiSLI7KM/cTL/T3T6SebMDbDZQwXOMT1bxX4VrRzDil6kr5KXl3DGnc7
 OJN9Fw8J
 2JZimsWH+lbzZvgw9AderZsrIEKOSmWiAsj9zvJAWsTqCqjYm0SgrxYrif3M5V44/t12DuW1k+H0elK5TQ6+vFjlbzwZdZMBcCPtzxbbmK22iM0NBWPCWbK62zZArQjiU97BMh8u2j2fmJmku9I8fFu4Jb2/Nvz/2xBHjEQdaayMbLl44u1hSgbYPmMcmDNGWJ6Uem7ad+MOmJLFyUnWhKT+lEVjQw2aV+Nnr6Kh7qmONQy35IZOH3Xetz6h1TSfCXEZmTYR9xfFP3YqnuV/Z6N0JdVakJkEiHzOlxIR4JY/0arkHlyhymOp/1f0QkiIrJ20bWym9NUA8iPHJwuwhobwqPgjJFqsFfHmHthCsxTH3jas=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 10:37:23 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> This series improves the page_owner_sort tool with a bug fix, a new
> module-name feature, and better usage text.
> 
> Patch 1 fixes a long-standing bug where --sort was silently ignored
> when used without a short option (-a, -m, -p, etc.).  The COMP_NO_FLAG
> case fell through to COMP_NUM and overwrote the sort conditions
> configured by parse_sort_args().
> 
> Patch 2 adds kernel module name support for sort, cull, and filter
> operations.  Page owner stack traces already contain module names in
> the [module] format produced by %pS, but page_owner_sort had no way
> to use them.  Records without module frames are assigned "vmlinux".
> 
>   # Aggregate page usage per module
>   ./page_owner_sort input.txt output.txt --cull=mod
> 
>   # Filter to records from xfs module only
>   ./page_owner_sort input.txt output.txt --module xfs
> 
>   # Sort by module name, then by pid descending
>   ./page_owner_sort input.txt output.txt --sort=mod,-pid
> 
> Patch 3 lists all available sort keys with abbreviations and examples
> directly in the --sort help section so users no longer need to read
> the source to discover valid keys.

Thanks, these sound like nice changes.

AI review mentioned a couple of things, at least one of which appears legit:
	https://sashiko.dev/#/patchset/20260722023726.600200-1-ye.liu@linux.dev


