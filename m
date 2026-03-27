Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D66A710F284E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03EA06B0096; Fri, 27 Mar 2026 12:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016186B0098; Fri, 27 Mar 2026 12:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95566B0099; Fri, 27 Mar 2026 12:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D687D6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:47:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 795FBE1645
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:47:43 +0000 (UTC)
X-FDA: 84592424406.26.BEB9B8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 965D8160008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:47:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n03tXMcp;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774630061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2GOXUcfCtO+hU/aS7MG7CRDyabivV54yc7GX1ZTR4Y=;
	b=HKjueAUFSN70Ddg0WiviKmKn91DZpwHS1RwnZzrwmJHUS6w6res6JiUEprp2QR7bLvvWPW
	7WOmFgNIAO4RjQYI9srSSAU535IiHlPmZi8q7VbzAGtSgdSAS5Wml10TFn9hrDKMeivs7N
	thRL9b+CX3MSeUh8YDwF8lsyIz66D+M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n03tXMcp;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774630061; a=rsa-sha256;
	cv=none;
	b=QXjA/6nZmKf6Y7Nve8oeIIdwhDSQTD6KjXX6nrpKvX7+eNCRNx+qvU5kd8TRF25Z6XIHIf
	j9WBnu2qivNE1Ir++9JPyMFGppSd/cPq/UnAOgJzdqTL9O4r8QXQqWRT/orTRjPN5tcLX9
	d0iUmnU/Dphdl+zxAHohC1l0RS0fpnU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F94943C26;
	Fri, 27 Mar 2026 16:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0CEC19423;
	Fri, 27 Mar 2026 16:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774630060;
	bh=zCHu6vdwFKPQuNA2ItrsbdYzJ6DJHAS5OipAXB0fjEs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=n03tXMcpjjYNt0Hx9YQwbPGwEDXWZKfUKohUo5ohPUHbPx+f8qh+KDZeTzpBbg3/7
	 LokGmm0Pw75YvFbCHRFosn/8qYVSWw0qa92DFLMAQG6xmDRvM6NK+zWmACR7qoWvYF
	 QyWcblJX4j+wv1GSRREER4cGbV/YrZaU//IBoy1I=
Date: Fri, 27 Mar 2026 09:47:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org,
 mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
 npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
 borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v5 0/6] Use killable vma write locking in most places
Message-Id: <20260327094738.7150efc3b0619e6ccf095c23@linux-foundation.org>
In-Reply-To: <20260326080836.695207-1-surenb@google.com>
References: <20260326080836.695207-1-surenb@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 965D8160008
X-Stat-Signature: opb1gntzchot5dqx3ueqh4effe1d7hdk
X-Rspamd-Server: rspam06
X-HE-Tag: 1774630061-898710
X-HE-Meta: U2FsdGVkX1/Z8iT2mnKDQmjfhpoAlcHcBt74bWHOSAcxJ3e4VfBbxsbF+JACyjvAvp/go3U+aD8do1W2BIAfBQoYArDckq56EtYGtXqcCskvg0HAPAO0wsRU9Tu3Yl6Y6uHLmOSfL1kqQwGYy6YfDSAuZcG6ERtbnIks0l9Fzn3igfeXMy3GWoHjyw5BBWcz1NpXgMTT5CcqYhRC4ksKLeSqp850Cq2Sy/8/ioVIqt0C/95EBjCYGSRv1zYm2896GUs0iTMj9/mS0jZ/cFc3NS+4dl8pJqOOdmfvQEDSEMfFbMoji/NCfvVAsrso0jq7buCxpH+6W0H0MOpPEXMMLKSgq9it5HBbjM5nSP2ueJLTj8fhdBZh7QE8WNaEOBrLhhnV8VYbMx0LwSAwIvhzHHbN22cYTVOD7ZR4CxCr9MhhdRHUUifKN6MQ9Kfw/Ihdw6PMoUEkDuqP2vMgFqsepEYWhWZJXeFLC5+U83ugIagjruzBpQUZMBteBW4xshtJeO0+TYSMXWaUkfJd3wcMuc/4ate67tnMVsM0SNlS15sNMLup4SAHog/CXY8W7yL73JClR/Xl0SZ+p++Y+/XIaGqx2Qq/WNaD9ppm9YSPwwd4Lz/sSAeyTf1duA+f/NdfrExbYeVgXhgZYw2vn0nrybuIoNihnjwGekip1Jj+OnFu3PcoCYMAUeXKRQ8GgHrxjzfJTc0eN4QquNOGtiWh9MNn2KZx3b1oP2w4Rr5aL5+JQaLIRPow2Me5eN2nVJsqMJYEK0IcjsFWPKPbeT7Y4o3fC6udqReiQpVc09vEbmsC+MKF2qup6f0eigMbGn0Z+zcRXYKr6Y8skcyvI6GA2gbRVEdyNvISO+dfUtxmWUnyI+y8oeCWCNguUYiClj4Lki3mdrv+KaX33KU1OjdSx39hqB+faZi5qeu8wq5wgZs1ObfHvju1jRnZj80vRfBmWyy2ED0hO4WxTyaUQE9
 PYMxx0Yw
 K6EUVAwUS7dQKLq+rRXp0FN1M78tLdvTy/eAtjQB68Pp1nQYLVxKeQ9OGQM/EjK4Tg19/nWb+mSZcF9UdlLhyZJIQv3nSCkdXtDIzIF1DEX9ThT6IRF34+Lsvlgkp/RbrIwzMY2pZziobCK04hECA6yZDiQRuyqBAaOnre7Yj18/933OOu9mgNvKC1SsV7kVTdq7uXedRWwvRy6IFuQqIbTxIDhaWS9lolhuQw/l2ByEYXyOhXotpk1rNFVPWXdXmsEnnlO1nrfu7PpCJa0AH7hznd+4+/h5+OTgTUgAoBCC+fdmBGbw1FM/WpS3tYOalndJj9omRUgp8tFFVg5TPg8V1UzJlYhmDeHAu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 01:08:30 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> Now that we have vma_start_write_killable() we can replace most of the
> vma_start_write() calls with it, improving reaction time to the kill
> signal.
> 
> There are several places which are left untouched by this patchset:
> 
> 1. free_pgtables() because function should free page tables even if a
> fatal signal is pending.
> 
> 2. userfaultd code, where some paths calling vma_start_write() can
> handle EINTR and some can't without a deeper code refactoring.
> 
> 3. mpol_rebind_mm() which is used by cpusset controller for migrations
> and operates on a remote mm. Incomplete operations here would result
> in an inconsistent cgroup state.
> 
> 4. vm_flags_{set|mod|clear} require refactoring that involves moving
> vma_start_write() out of these functions and replacing it with
> vma_assert_write_locked(), then callers of these functions should
> lock the vma themselves using vma_start_write_killable() whenever
> possible.

Thanks, I added this to mm-new.

It doesn't appear to fix anything and it has no
appreciable&measured performance benefits, so I just broke my own rule.

Weasel words: Lorenzo would like it in 7.0, unreviewed patches in
mm-unstable&mm-new are down to 62 and I'm a sucker for nice patchsets.

Three of your patches lack review tags so now it's 65!

