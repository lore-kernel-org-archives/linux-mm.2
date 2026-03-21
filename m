Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38774108B8FF
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 02:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770946B0095; Fri, 20 Mar 2026 22:57:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747D46B0096; Fri, 20 Mar 2026 22:57:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6851A6B0098; Fri, 20 Mar 2026 22:57:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57D9D6B0095
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:57:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F00F913A342
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:57:54 +0000 (UTC)
X-FDA: 84568560468.15.885BDAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 81148160003
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:57:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dIFbPnmL;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774061873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGgW8w+NXIF8BvauIsqchMWNaoh8JnrZ2OUR2eCxL7E=;
	b=7BRHJbS4VbqztAFnXQR5q9h9z9nkYYHpoQZM3BftA7oAB1VKq2yMrtCpCpeNGsp9cbVgQ9
	q108coB1TZ0kT09HxlT0QvRJPaElojkpKzP3C7C8YbVsZYtgh5C97ezICl9G0H+77ZDj7x
	7qRpFlb/EBPaLVh82j5jv1k3Tb68Bf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774061873; a=rsa-sha256;
	cv=none;
	b=zjEu3RG7SDC3+7IYjHvpgqZ0wWLAHG6uAi5estxjRmAHgqkWK7z//YqcVicjqq7X57qm9a
	MDNwV1oF2KZXvJa3dfpf7RHkJoy5WdsKmEQ6PKFs362wsuDoeyAt4x0npvYDABwfcJYZzh
	5jE+sKVmaYoxKWF2HCjYMKnOq+qFxGQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dIFbPnmL;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B731560126;
	Sat, 21 Mar 2026 02:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB81BC4CEF7;
	Sat, 21 Mar 2026 02:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774061872;
	bh=3Ld+Bo+s4N7G21DAwj9B2IqP3mz/F6xhNWlb3jU1350=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dIFbPnmLtC6W/10EY5wh5URryJ5bF4t87dTPXyy84knzzJN/XXRse9csZSst0Wiv2
	 c265qvRFZ1hXF4zPxBb7YanL3ikCcrnt11Ji08HSmJhwmhMERR6m+N7/dUhZrLZEqD
	 2MBaYSzpzlkhcrB5SjQ/5IWIsbs77evtcLrZaV2U=
Date: Fri, 20 Mar 2026 19:57:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Chris Down <chris@chrisdown.name>, oe-kbuild-all@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: Re: [akpm-mm:mm-unstable 433/449] vm_util.c:133:14: error: too many
 arguments to function 'pagemap_scan_supported'
Message-Id: <20260320195751.5b08b3e32ca835c3451d7bcd@linux-foundation.org>
In-Reply-To: <202603210319.P5MPyTEf-lkp@intel.com>
References: <202603210319.P5MPyTEf-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 81148160003
X-Stat-Signature: ohgsfze68x64aohh44namt581im1y8z1
X-Rspam-User: 
X-HE-Tag: 1774061873-221206
X-HE-Meta: U2FsdGVkX18XddLLw801J3YvrgR126olvyunNsb+2/7hLxSKdcNBBiJ1xsNqFi1cGNbWTZeYSNDLfoQ8SeBMcZFOlzb2wOfTpa07rlIiVuR+wEw/v3/LBHLeLqGuqgOXwyyS1oaRYnz4TB1WpfT1FJUyjKXD0Ha3yXwEb1BPq/ZnbL53zTmDm1dOmejMSgTMEEErXL6UWHjpItAFlexOPwSjlKMr9zMA/NJdAtnFYu+vTrw86GgV5V/ki66SDNGkOEe+czTV6mACIyYA7bs74tE+F1eMHS4JK5AUe8w6gRRQbiO/7hhRhxKGFYSl/2hmgNoQJzlUTFuS9cZFq8YTaT4He7RPpcf/lo5cO10OuizVQHFhEjkFwPpUdFz93v3rtn0uPvvmVxL2nnlx5fb4Ou7SDo358TSWlwIU1opaFf4bO0svv6NZvrj6gwio3l2lmry8EUJQiuh+epkHQzBp++cFbFVTaJGyEzxYPWJv7mucgR4PgC6etyA8HH95lPDfCUl3OfMfsY7yrH/9Hi94QI1JKuHKUGvzs2VC+bXtMCEZPMbeVuFIuFjRGH76zz0fu5Shbg7Fyh2ikGXELL0uG8H+G7uGGB2YdXkhcQc2FsP+qaYE80burLGMRl7kRIZCjho8GtyKXAH3ZuJiR7blbxWlD++sisTN7qKUFJ8vto/kKGgnAM3gn9d0bzgiqGHx0RI1z7SCQkQB6e1SHUo1xkbuluMLCAtYwPRfIuO/ewslTtbkOkr+pjk9Sck6mZhzL/dzvoUYHDO8dTTbBr30bIiMDQgARhO+rQhio2QpI7je8TLVSUT6+De3ixYhAgFwdIn8FfhcQa65u0dcu4qVMZeZ/1A5zh695DeFlTrxhlAkNVfwvyQN3piDaKpiusIORzRzrdwi6xQaKvIiS6SG2iW4rk74lOhuCJLZ1ybI1qrWYcprbXmqaWZ+NLBO54AbfOk492SmSzCfwU1rX5H
 AOfRGrw+
 kyQDzSvmZEHmf5mlB2HiYZ+0bNnb8uuGHR5nS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 03:34:21 +0100 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   28edd9c5a25ceb76c2d4e55bc5c37acd7eb0fc92
> commit: 6fa1bf6b010deb50b35d2b2a7c97e7e229f2747e [433/449] selftests/mm: add UFFDIO_MOVE huge zeropage PMD regression test
> config: i386-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260321/202603210319.P5MPyTEf-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260321/202603210319.P5MPyTEf-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603210319.P5MPyTEf-lkp@intel.com/
> 
> Note: the akpm-mm/mm-unstable HEAD 28edd9c5a25ceb76c2d4e55bc5c37acd7eb0fc92 builds fine.
>       It only hurts bisectability.

No, there is no later patch which fixes this.

> All errors (new ones prefixed by >>):
> 
>    vm_util.c: In function 'pagemap_is_huge_zero':
> >> vm_util.c:133:14: error: too many arguments to function 'pagemap_scan_supported'
>      133 |         if (!pagemap_scan_supported(fd, start))
>          |              ^~~~~~~~~~~~~~~~~~~~~~
>    vm_util.c:70:13: note: declared here
>       70 | static bool pagemap_scan_supported(int fd)
>          |             ^~~~~~~~~~~~~~~~~~~~~~
> 

Thanks, I assume this:

--- a/tools/testing/selftests/mm/vm_util.c~selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -130,7 +130,7 @@ bool pagemap_is_huge_zero(int fd, char *
 {
 	uint64_t categories;
 
-	if (!pagemap_scan_supported(fd, start))
+	if (!pagemap_scan_supported(fd))
 		return false;
 
 	categories = pagemap_scan_get_categories(fd, start);
_


