Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D418FEEF55
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 21:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 834286B0088; Tue,  7 Apr 2026 17:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4376B0089; Tue,  7 Apr 2026 17:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9E56B008A; Tue,  7 Apr 2026 17:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F1726B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:59:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F8DBC01C7
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:59:07 +0000 (UTC)
X-FDA: 84633125934.08.50D25FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 16C4240002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:59:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=g2P9XDLl;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775599145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Ee/ZQ8tkz9a0bwqeKMXmT0Qy8+KAGqETEjDjPC4DgM=;
	b=7f9fU8G3F4IhvYWoEUIVgkseI5HEaFMml5pVsAMnROWtq9fNtCB17MJH8fQNFx+D7Cz2Ir
	Q8jIqUkqHnxpzL7y4Pa28wxINe6h1pGXkx8npUM14E66IPeWIlQ6uUV2UWVkxdjx6gKRNw
	2Vmha88yspbuK2n+BZQLtl/ESg0EG9w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775599145; a=rsa-sha256;
	cv=none;
	b=owMis3LvEPICcGSqXpz/5MVfehKDNDFrEIf7h2N4WT3pSrXdEy82H+J+kPC44HMoDERvLG
	84rIUDpePbcfetLi/h40ZPouXM4Stk7sMZ+WF15Iza05CU46l5YjvU7qFq6vQBPgNyGQlT
	Qj7l9nPpoiEA2UH/UynYOd953PZJkOw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=g2P9XDLl;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05EC2404C8;
	Tue,  7 Apr 2026 21:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC60C116C6;
	Tue,  7 Apr 2026 21:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775599143;
	bh=WGjbgIP/MkAMP64vHdLKSjPCmOqDJIGHFmMl4BHOc7I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=g2P9XDLlR6fNt+r+veog97du8CFM2oid3SHVXSPSzTpzh2iUsN7eF68ktocaew9Wt
	 rJZdnIftvDAmeh+2+t2EQqQgPel4rl0YmcRfyNNOxKA+UcJLxmsijp9K39EN8obNLI
	 r9vOeBE/FCpiOGtFtxJBZJUOXy1f/6bPiKi4qTn0=
Date: Tue, 7 Apr 2026 14:59:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, Alice Ryhl
 <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [akpm-mm:mm-unstable 113/133] error[E0277]: `*const
 kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
Message-Id: <20260407145902.057044dc19e7313b21418ff4@linux-foundation.org>
In-Reply-To: <202604071509.y5vLetYd-lkp@intel.com>
References: <202604071509.y5vLetYd-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 16C4240002
X-Stat-Signature: jm1qdpdizjpbhqmcd5fbmyf4a1icdscx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775599144-607537
X-HE-Meta: U2FsdGVkX1/3C0Ps9sr4QTAoFvUEKOpIjkJ5hVyq/vFybgwApXchJNcE3EPG/9MVZaWfIdj8rVXz4D0hvVcYr0es2k821Wqkojajrg4dFjW5A1a6x2rgLIChgP4APNQD8MxzQ9rQsVgcdRpfJwayxvknwNXHFRPXjNNLk+q+ousriG+ohQUdy5hBATh+nkwlv2qe4aKMRPGRGeasJJh/EmT05bDrNEjVJ6XaOMKvkDJiWrdXfUIBdjTorKDlNXojuHWz4KUyM8+HG8jexfP2wakiViutOeFhXDEHc0+oidvERroqV3JG7rSqVLPZryY3Zw2ZFGRmgXGIhnASXRivwXXSJH19+Wzc93QdCG5lIOawRdYvDIQ1iOtd+/R4yEdzthY7PGywxYQl1EKWogIu3wxGYko4PeBzqY91wnYsQFUU6+mi84Xbm4kR8x9Vn1IXoXUmr3zurcuckC4x+6ee1mVY1jlYP0NIwfGVJSWhc5nU45Xkgjma2gttnRdLhuXMkSrrWEkAtsy6eLaYFU8KHw6JGce2l0FcOokQB0pS9ESb0HyQYQO83CzIDH2HKOgmLcM1Rnc63sLFSS6vcCt3kgrz/Lt+SmwKW5UYqJFekCbxQ5uM50AO0IzbrpvkmxGhkHGjPHBjGLf9AmZsovGG7IgkiYziXFuXnDtujOetEwS8V2FO0GED9RAY8Y8zz5JmTt+a2wxIyjbO7mNXzvE/+ozoJdpZ77rAVyqouh3DxTxbacpCiA3P9Q4z4uGc1zUC/ZrRQw8vSlohjUjKVdJRjLgw5kSVKr+ObdRjVEd/AsbisRDHvjRW5S+ZqlgevCDo04kn9+L3G6+ryfAod9kTZclJ7wUkz4NlQ7m4/i7t76hz+KFZohjA4vDSy4ASp8bWjbx8/daTqKajmhPOcaD2rNxvn6t6DzxwenJmW4r2keBsatJ61NL0UzZQDe4WDj/+uelZCryqP65TAoDT80C
 HdY5WkSh
 NvUjse2aFPlPO39oqgLLgQmmHL6YUe8e1RduJ2BNIBiLvA9Od+/CnBf8R2tzlVzqhnw0PXIGRLsued1iK4nueVaSRyQnSxk5kxL2ZGissgX1NxbHpdDfvdHWP1i1vl6kbTzC3svs9Sj80+ktQr0aoB7TiX8NR+L3e+A0uLDS+uqBS/nMcB0JoeQGlMpzifUy6XHCoPXLRUwVe+ixK9fXr8YBA9KRb1u3BZmMHzO0Lig1+enJhwmeY6FPgwu2pZAEv45WnRMhWtAwlQlLOAah1efNryBUFr+/oBarz/RqmKNse6h4p1vNOChx/fCY2+p5W/o26v5lnH3dEJpU0qOTgHuB7jE6hCjOkGrV5dE98sieeAPEKefoJYctz9LziMFgWLp/47sc6R5r3gQ/HJy3e5ZoIIyk/jclc7OW5+dXlyCA0amQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 07 Apr 2026 15:58:09 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   3fa44141e0bbd5062f2ef0c5cdddd98275d3223e
> commit: 694fc0bd3ca5420f4e1105d2dec02327cfc5d64b [113/133] userfaultfd: introduce vm_uffd_ops
> config: x86_64-randconfig-074-20260407 (https://download.01.org/0day-ci/archive/20260407/202604071509.y5vLetYd-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260407/202604071509.y5vLetYd-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202604071509.y5vLetYd-lkp@intel.com/

Various forms of "userfaultfd: introduce vm_uffd_ops" have been in
mm.git since March 6.  Thanks (much), but is it possible to get more
timely notifications?

> All errors (new ones prefixed by >>):
> 
> >> error[E0277]: `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
>    --> drivers/android/binder/page_range.rs:146:23
>    |
>    146   | static BINDER_VM_OPS: bindings::vm_operations_struct = pin_init::zeroed();
>    |                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
>    |
>    = help: within `kernel::bindings::vm_operations_struct`, the trait `Sync` is not implemented for `*const kernel::bindings::vm_uffd_ops`
>    note: required because it appears within the type `kernel::bindings::vm_operations_struct`
>    --> rust/bindings/bindings_generated.rs:74703:12
>    |
>    74703 | pub struct vm_operations_struct {
>    |            ^^^^^^^^^^^^^^^^^^^^
>    = note: shared static variables must have a type that implements `Sync`

We've seen this one before.  Sorry, I'm (still) not set up for
build-testing rusty things and I suspect I'm not the only one.

Alice, Miguel: please can you help us here?

Thanks.

