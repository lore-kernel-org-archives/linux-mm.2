Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FA1F364A7
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 17:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2372C6B0088; Thu,  9 Apr 2026 13:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E6C6B008A; Thu,  9 Apr 2026 13:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE416B008C; Thu,  9 Apr 2026 13:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE5796B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:14:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADC121B8BD2
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:14:55 +0000 (UTC)
X-FDA: 84639667350.22.D2529DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id ECEED14000C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:14:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DgDpsfcx;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775754894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVJuJNjcm/KBYlyulVI+ymOZoLXdDETu2CaaXAoz77w=;
	b=EgwEOPActFRoFRUBZ0fFNsYaMFu4amzAnQzVyHiu8Mnt9XLhfQf8oBZx5SrnmqvMMIiNK0
	HNwzogVN671Y9+RRSW0WmfZJlyQSaVq3PlJiYdfvMQz9/fRQRZbXY4R8UXn2jTJ/C3m5RY
	NIeUN3gKkOjy5FIDoVBvOKHkQq65yfY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DgDpsfcx;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775754894; a=rsa-sha256;
	cv=none;
	b=GLxwp//VOoe8eCcyRNIRv6kVEA3MtQwpIiOu/krwQ0L8afbQfasJsrQZnz61VRW/T8vrvw
	+ZLmI7KyCy68L8OOS6z5YNeJKhdTyulJpxfXkJ3vRVmgP4w5tzmPIoRdUqmq0b9cko6KG4
	tUjPseQdkEu9A2JLyP+SwLMK5ZI+wj4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A71C60137;
	Thu,  9 Apr 2026 17:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61D9C4CEF7;
	Thu,  9 Apr 2026 17:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775754892;
	bh=3BChr3pIQsQ8PuJ7qEoL1q4y61ENqab/lZVBbI7+0ck=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DgDpsfcxzv5NSiLvN+IVMfiNmnB9+X62wNIrc5QZfF+yE4uKuz7UrX3dWxCV8BZ85
	 xB1WCcuNus+YVK4iAlGApK7T7XmbQLkfEE5He6IgNNO+8mjkRbg1tE+InusWEXbHzC
	 PUDqWENRvR45tLlSdKZbp74J7G/sFOCy3gxUBDfo=
Date: Thu, 9 Apr 2026 10:14:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: David Carlier <devnexen@gmail.com>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] mm/userfaultfd: detect VMA type change after copy
 retry in mfill_copy_folio_retry()
Message-Id: <20260409101451.66dcee85281b84f00c645ecb@linux-foundation.org>
In-Reply-To: <b8b1fa91-b3f9-404d-b6b8-f1cb2077a108@kernel.org>
References: <20260409120653.290386-1-devnexen@gmail.com>
	<b8b1fa91-b3f9-404d-b6b8-f1cb2077a108@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ECEED14000C
X-Stat-Signature: 3oyj31tn97rie9oce4x3o6c8m3oj1bq4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775754893-96197
X-HE-Meta: U2FsdGVkX197vbbDPTcN2jpid/RmmWkbh+atNxsVi19VZvJN79GjfAHeMV09kQW6gjX/593mFrNNVdKMzYehLx94xl099qKhSbe5ryqiA/xJ7WZ6tvQo5M6KGYVyl6iP3MMpsyzjWmyYAAWJ0oFG1VT7TKAwihPbUEu2bigmKA/Y9/a/n2z6gp0sxwFqM7F6F6JJt6CEOZBx0lL/runMzXg8sphXC3F4Kz3HmUkcjXysLOSWBTwUp1KCWjxh80/oN81ta83Zp8WkDcOTLWEbEgEW7hEQaBuXSCF1VLcQpTZWCkRt9xeH/ZkTtrWqzsrokUeCzoYu6NUXCXZ7PKGXsQzYB3napySDBoxpDpHRlASKR+9f4CvmAdxmbfBWOsyYxAT/WsxCW0d4wWzNnbaLd+7M2L6FX1uwkLLKX8lCRtEl4F4tPuGNt9FN3cbE8DxdaZVQ8mmH0cTaNa1em5/9NZcN0+/pWfLohpIMAqNdB9CO+MnZjAr7LOIUSysQ9rybk1ncSpbKKUNlMNdVbEO6i7S3ui3Ft3qvu0n9FuCbitaKJKW4u6MvfAm7p6UhDcgXMF6EoidjJPnRkSkvH3j3EG393ykD+JpFvHQR5rOzh0+K9Ot2cYKbpwrJs2t+DyaegBTSAuaeCLbMW+ZGbVTlezXF74rVX36Ld3t+rNgCZWo4d5s32hd1I4s+DpnHm2MsZ5DfDeuQIxl4KFMQJtt8KvL8+lj9LnoZX5tTShTvYAI/SqRE+SZYfG443iYlHiapNaN30DdK3H2n7KJh+qDdzAEAdoRjgiJWrF6cCbQ/gBh5FXMfHmh+0BdQdWz+LSFi6H8VqajZvErhvl65aJwZbxLp3cixsA2gO7i9LyvZLiUmemYxmbmw2afW9WaAP8KXbGavKGlXHPjzpJyuYo1klNlPR8ys43uGjc8gxOK6rhkvBvofO+waKp8uuJpYNw7QT1MKKs8XvL2Aph1KQt6
 mf8L703+
 W6gi3yOR50ofK0V49A4Okp6fN4mL5NM4gxL9MfzqfBe7PrZYB3QcIbbxMfLfyLsGgVYMY49DC8Fn1HpOyLvoXb0rjLTvXLadN3FrZrmMhLugfe8k2iOmdhHBjv0uoCqls7XRmhTw4NoY33nzEp7f2feKY+ST/0uy1VjBrzwrHyzMuCimoddYJN/pjjkx3SO2txMpQhAe04u0nC1icMwXOiEb80mpCts6yh4xN+senC+oDMCjIamdr9WrmEcNDmE5ivhWWaxopNfHzFJTky/YZ7MhxtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Apr 2026 19:04:49 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> On 4/9/26 14:06, David Carlier wrote:
> > mfill_copy_folio_retry() drops mmap_lock for the copy_from_user() call.
> > During this window, the VMA can be replaced with a different type (e.g.
> > hugetlb), making the caller's ops pointer stale. Subsequent use of the
> > stale ops can lead to incorrect folio handling or a kernel crash.
> > 
> > Pass the caller's ops into mfill_copy_folio_retry() and compare against
> > the current vma_uffd_ops() after re-acquiring the lock. Return -EAGAIN
> > if they differ so the operation can be retried.
> > 
> > Fixes: 59da5c32ffa3 ("userfaultfd: mfill_atomic(): remove retry logic")
> 
> I don't have such sha1, is it a stale mm-unstable commit? Seems to be
> 4974a6aaa768 ("userfaultfd: mfill_atomic(): remove retry logic") now in
> mm-unstable (and can further change)

Yup.  I queued this as a squashable fix
"userfaultfd-mfill_atomic-remove-retry-logic-fix.patch".  Against
Mike's "userfaultfd: mfill_atomic(): remove retry logic", queued for
2nd week of he merge window.

I'll remove that Fixes: tag - it changes every day and results in
"invalid Fixes:" emails from Mark.


