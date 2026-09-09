Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33407C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 23:14:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B476B0092; Wed,  9 Sep 2026 19:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DCE36B0093; Wed,  9 Sep 2026 19:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC086B0095; Wed,  9 Sep 2026 19:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDE936B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:14:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 105961A0399
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:14:37 +0000 (UTC)
X-FDA: 85195780194.10.2E05F31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 52053140009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:14:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v+a2ECut;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788995675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dkruSTAugRIXgigmDvmANzyJdRXpZQBA7ft2oJiqxSA=;
	b=dVeTOnKlvcXdf8mKlFDT6ZMIBYii3niyH+zit/PcC2WXLJMV8JIUdOiducg2wW5O5BRLaf
	cUOmkf+aj32yOO3GmfUTWET2VNbwo4mYQRDPsEGoA5S66svODQBe1GjSUgn93xcryMV55j
	20t06ABeGD1zUxLFUqvoZnmakUWBl+Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788995675;
	b=eADoROGGnIVe8hT4wKF37RciAvEGnzs08D3FdoPUybWUEFYSjCffDjGa8gf8/X9Hf+YCdP
	oS7fbII9FcMI+EfmhTrQQbihGschpBEd6eAcHUxQJMAZOQnIe4IxqF75IvsRjgBL5Qqcd/
	uO5gCL0vp5fWi63fsPZG6S54F1hC0m4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v+a2ECut;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E95B600CB;
	Wed,  9 Sep 2026 23:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779FD1F000FF;
	Wed,  9 Sep 2026 23:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788995674;
	bh=dkruSTAugRIXgigmDvmANzyJdRXpZQBA7ft2oJiqxSA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=v+a2ECutAdelnbekynA/hQfWWeSGE/n4kGildm2vZBVtWBHjXrP9wFmxcyPvBwb90
	 y5ouZrgcb2X3mFepZwjXCeV0rhIUsZwQ39vQ7hqRnm4UcpNwS9hFx24JjTcDZ/I+7F
	 N4GtF6583H4YaDenL369MuTyoefuSjs7xHVvYB8k=
Date: Wed, 9 Sep 2026 16:14:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hughd@google.com,
 baolin.wang@linux.alibaba.com, willy@infradead.org, jack@suse.cz,
 ziy@nvidia.com, bfoster@redhat.com, joannelkoong@gmail.com,
 djwong@kernel.org, yi.zhang@huawei.com, yizhang089@gmail.com,
 yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating
 straddling large folios
Message-Id: <20260909161433.d96c67399ccac8de27499925@linux-foundation.org>
In-Reply-To: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
References: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wu6mwobhimj38iwg1nqqs15hztunb5z8
X-Rspamd-Queue-Id: 52053140009
X-HE-Tag: 1788995675-707047
X-HE-Meta: U2FsdGVkX19oMqCrayjnC3U/b6QRM4azTkpgAjo5fMM6hvpt8+AxBxQMN6xJor8pJYKqwNnNd9Z3Yx0a6K80nhbZs80S9wkkzv6FZX4K3cct03kGgWsIFo458rZ+5YJh8OElQK5/cHFVAwEDGYgjItJ11sWnSKUjsXSgS1Gwg7oUzWi0eBVjO8TaMoYRP0qr6nHLca3D0OlVzH0f8ZWdRXOJUVa7R28PqKrkwTPP34BCxDHH/CL3vn2a13U4qdGIiXE+4WpDWUgreo/HmLJDrvDjSNlDeWftVD6FrAwDOm5S7uoNkApo0B8731Vs0QcJMDcwzx8SNV04EzOcfLkV00O2BGWmpuR7Qj7FIYtKLM0MgQD71uZ0zIrrs0ldZx6VhaZDxd+wz8NxtbkMeUzqyWNFzRTU/BStJuE1G3w+PAxrrUTKWRFw2bFJ5uR3Ey8H8SU5RLf2DVkYQE/xoTL1p7nYxSISirzaQalt/6lD54aY2+LuLvgNUs4JrkLDAzTXdwrYBMv9fpeye7zTrPhynZ3vxyN2JmymstiyJjKWwUSrZA4SwVbhkO8wl1r/hi0ZEIOVoV3y1tjcnkYVNQI6DvBxQcbmSmeCIQulKgQDVk0PtM910ltUwZobTtZjTRaWV9Yj5vmZPamDx+8jsHOa2M/hjTIbid4zbbcvA7e6ZB2Ae7p/R8aSZKSd7+2X4FTAiz7JfWf3/qzwUjDgJP3Wl0aZ/RmWPluJQGKDT0/fcQIRLhh3bWKzTftlRl0NnBW9lqppD0Y3VsPVUOEXEXKTtCxuWS34YiPmOeDPhFpLO0xstm93iDLQs6xbrUcytYKOhynLxcbgUwqiR0Qlq6ME8P2gG8AeIg80DG7wJjWVPGj/iU34wxZxwLw7fU+O/EzfeKLanoSG8bZYjIjtG486PvLgMY8/dp2ooE1aRFBDKuu49L0vSTMFqNVxX+phCMscKOQBohu3Beqblw2prZR
 aTYqcQBd
 NT9tk82zMlVDlr+uQsr/M2CX8tToknZHq8wd/t+hm1zJ9if17OVxi5PL6WKZ2b4+A/oYNjQu2mctQzrtOXU4z5kUld1QnvPpSeSxgzNz3gEtxlJ/ED8CN9T+pkCRJKD5rbAqCoVDlDkeSjZ9LgsNeLuzZwGSiDkwCe4D7Dng2b1qW8XbT4OYczANgdpro3rgO6Yd0wD3haMgNyZoSzcd0vlcqcODQBHiTxcSKnVDXLPyaG858duriHJlKBSDnS0dicC1BvEkLt8uzYUBeMnODvR+TlFoeuj4V8b081GsklQSU/uY27Mh64U9C3h5E7sg0xlr2UkZ0NLk+Och+V3/zJ9nvErIBloaqP4aOaDSwmnLPenM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  9 Sep 2026 14:23:39 +0800 Zhang Yi <yi.zhang@huaweicloud.com> wrote:

> From: Zhang Yi <yi.zhang@huawei.com>
> 
> truncate_inode_partial_folio() splits a large folio so that the caller's
> truncate loop can drop the in-range sub-folios while keeping the
> out-of-range tail. The first split at the punch start edge is
> non-uniform, which leaves the sub-folio at the truncation end edge as
> large as possible, this means it may still straddle the range, holding
> both zeroed in-range and valid out-of-range data. The function then
> attempts a second split at offset + length to isolate that tail.
> 
> If the second split fails the straddling sub-folio stays merged. The
> function returned true unconditionally on all exit paths of the success
> block, telling the caller it was fully handled. The caller kept its
> default end and the truncate loop truncated every sub-folio below it,
> including the merged straddler, discarding the valid out-of-range tail.
> 
> For example, a 4-page order-2 folio punched from offset 0 to the middle
> of the last page:
> 
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()      # same_folio == true
>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>       folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>       2nd split of folio2 fails / cannot lock
>       return true                       # BUG: caller keeps default end
>     end = 3
>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
> 
> This became reachable after commit 7460b470a131 ("mm/truncate: use
> folio_split() in truncate operation") replaced the atomic split_folio()
> with folio_split(), whose non-uniform split can partially split a folio
> and leave the end edge merged.
> 
> It has gone unnoticed because a dirty large folio normally carries the
> filesystem's private data, for example buffer_head, so
> filemap_release_folio() -> iomap_release_folio() returns false on a
> dirty folio and folio_split() aborts with -EBUSY before any split,
> leaving the straddler safely unsplit. The bug is only reachable on paths
> that produce dirty large folios without filesystem private data, and it
> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
> attached.

So is there any way of being hit by these issues in 7.2 and earlier?

>  mm/internal.h |  4 +--
>  mm/shmem.c    | 13 +++-----
>  mm/truncate.c | 88 +++++++++++++++++++++++++++++++++++----------------
>  3 files changed, 67 insertions(+), 38 deletions(-)

I hope not, because that's quite a lump of code to be backporting.

Thanks.  I'll queue it for testing and shall await your response to Zi
Yan's questions.

I see you've received Sashiko's feedback.  Please let us know if
there's any validity to it.

	https://sashiko.dev/#/patchset/20260909062339.473816-1-yi.zhang@huaweicloud.com



