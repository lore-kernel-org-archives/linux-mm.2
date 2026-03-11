Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 493651125856
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A246D6B0005; Wed, 11 Mar 2026 13:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1FC6B0089; Wed, 11 Mar 2026 13:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D42A6B008A; Wed, 11 Mar 2026 13:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA546B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:15:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36B9A1B742B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:15:03 +0000 (UTC)
X-FDA: 84534432486.27.5260AC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 73F0E100013
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:15:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iZ2l1fMl;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773249301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2q7wzKf7MXg6W7Nk3iIG8zKUBAdpX+St4CadPPaeyqM=;
	b=m3coALzqImU6sLowmXVr+xnh6KyyOvP+3Xv078qdIzLe20XWkGeGErkRDOuQhawu9GJzK8
	kQaBBngpihtTRS2mSryFp6VVOLK3LkRUoO+BFLOH6/VSFdafaeuVjGrPMuLKhLyJ7lsUEz
	IDz3SpM+Gqv2Vj86vqlbNdCVfJF3bmA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iZ2l1fMl;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773249301; a=rsa-sha256;
	cv=none;
	b=BHyHRi6vFEgzemgsSpb3UjEfUubjqBcOjxqexcZqu8B2p0xqft2mUwAR3l17y3hvuTJ+jJ
	NtF6IL6LzVY8iBkLJUXBDkww5NYMyDXQccRbZXA499fO5gDvodmBnZjTZ1THalib8Qwbr7
	d+miFrqxDAsAx3U9Wy4syPoB2xc8YVo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80C65440D8;
	Wed, 11 Mar 2026 17:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A9CC4CEF7;
	Wed, 11 Mar 2026 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773249300;
	bh=yoRZO61FYITNlEYi1rmYjn/e5Esq8zl2cbKF9CxZzaA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=iZ2l1fMlCwqeuncltoGQxLM8zeEP5xQ9ZIO5MmUwnucMxgHRGb2O1WBpG3o6+pTqs
	 mWQBtpHZ3wcg33XIloQA5Pg+dnmujKmP6KwEtNB2HdhT8BO+PnYpLZHlYA3xyI/QD4
	 /h6M9IOKWSdRB3ofk32bpwfyO1EL3Z1G/QNSQ8X0=
Date: Wed, 11 Mar 2026 10:14:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 david@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jannh@google.com,
 pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
Subject: Re: [PATCH v2 1/2] mm: prevent droppable mappings from being locked
Message-Id: <20260311101459.4484214454999fbcffb361ad@linux-foundation.org>
In-Reply-To: <269b1a31-20d1-4451-b4ba-f55a67f27d96@lucifer.local>
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
	<269b1a31-20d1-4451-b4ba-f55a67f27d96@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 73F0E100013
X-Stat-Signature: i1upwki9oi3cqb4ifcw88ty1m5a5nwxb
X-Rspam-User: 
X-HE-Tag: 1773249301-676671
X-HE-Meta: U2FsdGVkX198qaboDCijJrOcoYQuKxIdVKi9TlEgJyZYsQIld7wLuQ8yMXV59Uj3WJMGN3gKykoq6vElsmDtnMMOMRGpdjCUN6C+OyJjSl4QsH0BQkltqlcvWslTWEoePncXnj0HHRhzGJEj9wy+nKGMVXo/kocuEpAt+IwaGD51+y7i4vru+XybLrahSab3B9w+xX+6rwRbLfviyl2JngDfDUi5NFKmjbf8kEJX1wteW+aKILn1RMH7srO+NsWK6t94MtiJbiu3UujIxs7r4oGwuo0npv5bzD6EYjz+Z9LrHbpWppxQWjoQ5i47zQSgochDEtQbw47h6DecAVIARZhm3HsMwqAeazlt8yZUaTVPRTT25JNkbSY1dUGxgEsu7ioEctfuDVCWUMDYFaQGmQNv1IOcBcDzLjJSPWJJzBZiN7rxN3CkmKl9+/DQKQxVy9oU5ZFDjkq3ue9OHmKr6mwwIFFft68vqJo3b0Vu4Z0zr7RF8ULyz2a4aQ2wC+Il8Z9W0A10Uj/JwHWe/bFDpzVqWsLweRPvQKDHKld0CeOQZXXnGlM9gcYIR7Pm+ucYBDfjcsftZbOzIqQrZBzZBLocsRksrNcHg8aRT0BAU2PLRuKtBx2cEps3Np9ewlRrKn8yANchXhf+DUTdPPf5AYQINOmdQIUczwvzCikyHAcSE0MjTSI4P9OYSxBMRZZIfZ4tvT0AAEXUibdl6OaWZzxR3iDPo4yCOCMmSoean7yJHW2ZJc99Vxzjlu357PGoS3+rr+cYDqoR3elhZppmhNnVPVgqEfSgkF9El4TZ2XlbjZO6+mqmbdJqomO6VyzQ8sdpQz2Pf7HBP5z80GTD99Wt65TT8Il+PXJ+WrTOeL/qd8cMY2kNqhOb4NmySpDhEqsVmoBK75SvyiJVcwhHggI0pDih9Ep0tz4EZie81oEBf0dww1ReVk5O+5bpqLs/9OqQxX4LuWWuDUFwrgx
 1ZtFXtob
 LeCvDqjpC99K6RyIwoVraFTaBpGZRc1+NA/irhvwC7lv0yHAJ7Oud023r/PPYX8FbKHZz7PdBwHH9kFAvOzj+p4ZjhSmZQn6mr/GqiT8iB9pcGbOllbW22lkagbGp8/FXV6KOLUm8nVYVaV7d+7PwS4CIfD1KlAuMT0fj5UhOuQNllQ/wd/XolDAOfLpATGEbvmZrUSTYZf3l3xfXvbRrT5TEkG9OX3H2mPz7tHmA1poTFSi7D3CMJOxp54SzUYI+ZTC310zyw1Tdp8kuqhP5zpF20w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 10:36:26 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> On Tue, Mar 10, 2026 at 08:58:20AM -0700, Anthony Yznaga wrote:
> > Droppable mappings must not be lockable. There is a check for VMAs with
> > VM_DROPPABLE set in mlock_fixup() along with checks for other types of
> > unlockable VMAs which ensures this when calling mlock()/mlock2().
> >
> > For mlockall(MCL_FUTURE), the check for unlockable VMAs is different.
> > In apply_mlockall_flags(), if the flags parameter has MCL_FUTURE set, the
> > current task's mm's default VMA flag field mm->def_flags has VM_LOCKED
> > applied to it. VM_LOCKONFAULT is also applied if MCL_ONFAULT is also set.
> > When these flags are set as default in this manner they are cleared in
> > __mmap_complete() for new mappings that do not support mlock. A check for
> > VM_DROPPABLE in __mmap_complete() is missing resulting in droppable
> > mappings created with VM_LOCKED set. To fix this and reduce that chance of
> > similar bugs in the future, introduce and use vma_supports_mlock().
> >
> > Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> 
> We should definitely cc: stable I think.

You know what I'm going to ask ;)

Why backport this?  What effect does/might the bug have upon our users?

