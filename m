Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D05A6C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 19:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A6E6B05A6; Thu, 13 Aug 2026 15:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A446B05A7; Thu, 13 Aug 2026 15:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F256B05A8; Thu, 13 Aug 2026 15:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 119DF6B05A6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:23:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AABFEA21B4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:23:05 +0000 (UTC)
X-FDA: 85097219130.16.02E3F62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E3A591C0006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:23:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hPWI2LDB;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786648984;
	b=CZ3TyS3/l82Shv18l6f0MU+Qkl4FSAP4wRjCyuYwq/fdJSXQLJWsrirABj4hMTbJ7BCy7B
	E+jlseYKLkNcTpXtrdn1cA0vp2auNKacIkS+64MMRiG8nCqwYkhaAEWwJ37BgJt0wIdN7B
	VMps9C8wkm/lQMPNp4z/uG9VdyCUWr8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hPWI2LDB;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786648984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5Utq32nBVG5zGqWf4WSM3DsWmatGp6ZBvVtqGuut6A=;
	b=1aJDM7fkZSxnRnmScsf2zUlMAx9c00kx180GnulDhqxPirOZHtabpH8g7+zsaCGERHfuBr
	KQVyV8i3NvWE88MdA6jHHzjh5/7rQIJkaotOIJZpgky0BLDmOplbrJyLCpwEccGZAA3o7e
	dS9xynqQ/kcxqYROHxarHSLsjrlimxA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 02DD340BAC;
	Thu, 13 Aug 2026 19:23:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC561F000E9;
	Thu, 13 Aug 2026 19:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786648982;
	bh=H5Utq32nBVG5zGqWf4WSM3DsWmatGp6ZBvVtqGuut6A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hPWI2LDBHG7D43iUCa4tpf2cpjdK9BI2oMxttDbb9DnipWXU1gT+NN423E+M8eYSY
	 zbdQ54ACS/VpCimCXxs1iMKwOgPJ8s6Ie8WQjlZ9pfTeAYBnSRbSHjaNZahEFa7Oj9
	 w33LzxQgelSkKbt+Ou7dONVXhs+21IGqXIFQXXXs=
Date: Thu, 13 Aug 2026 12:23:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org, Longlong Xia <xialonglong@kylinos.cn>,
 stable@vger.kernel.org, sashiko@lists.linux.dev
Subject: Re: [PATCH] mm/swap: publish cluster tables after full
 initialization
Message-Id: <20260813122302.516f19c013a25968e7dae741@linux-foundation.org>
In-Reply-To: <20260813150316.2793642-1-xialonglong2025@163.com>
References: <20260813150316.2793642-1-xialonglong2025@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E3A591C0006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: b67yigapu4obn7pxfraoz6sr8898esy8
X-HE-Tag: 1786648983-490360
X-HE-Meta: U2FsdGVkX1+hvQJSGGw0JcEhy7V9hV34XYx+sc1cfImz5Y/WVQs+RG3NoPK+f/OTsG39OagtA4m6vZUNqKVqMB01JAV08MT21E77uJ8SvAxg1s+RzAOnhO3NyKuzDHpW/yOEZl38cTOnRktDu30K3XSVjlxRd7nNzB031c81eMUSmALlWD+xFsnxt/95qd1G8NNV+9vw8VlayG8MTO/dd6Qq6Vj27SF/1Vkkzd1EoJuLEUtIITnX+LZ5uzpEYV1QH0FLZESklhrysy9+yXYijiDK9W02D8qRTVQ+Bj4hUTvH3jWR7MACgY3EyruEngeqG0fxDEq0bMFNwUUIR8DjLhEuyq/hXWErC5+F/rFgDEXjWO8ZWHxjp412UC7KLOlXNl9sma8nP6yFt2Do2Mq4j/Dt/M9zI0miU9Y2vst/mGUs8EJt42fUhldKCtBfRKQGEvPdg97Mx5svmH1KkHkz7QVOxgBw09MLo7O+Ya7CcmEtJTdmqFCYnS26RcNwzZPlS+NIianHa5ahogaHEyMLvX4YpLr8O/qsfqXTzj4F5ykttys3G4/INngYRvle1Y+9IaHeecNt1B5tDUlf/awD2L5BK7ZkAPrYIccaunG9QfXvyLISu7xeUoBP4l7+L3IDT6dVdSI3mYm0OKd+r3zUL63C7wzyIRCgmV/KJ3xt8GMONQbBF+9Eq7HoUvfXrt6M5fW0cs/ozu0pLKET0B4NmPTN1+LnuLEVH+gKyxVvIAj88rMPslfTxq8zo+f+Bu0L4XX3Li3fPrfECZ0BJ+fmNOeiiSAlu1JL20H7bkyIw7UvYWDIzNbTDTDYmZC3b9VM+urusvtutjxYLEf3fiwLLXlx6zPk3NQf+xdlwJCBRE7sywsP56SeKmN0OIG7I3tGwOZeJSWvdJqky6qE5bRtw3fxB11+dX8gpdgHDPS/vxT9UQJ5Z3uurXfdw+gHyZsufLAmVB2pag912pTwicG
 fY2T3nYF
 9TUmMszGgSaYG6MwFhC7E38+PV7RTez7hR9E6I1zRD70iOMw+9FNvuT4mY2dXLplV34d14Hvo95vQ5oOSkW/wXnU5hczOu99EKXb8L/TuRmW0m92o27gIrXG822rVPqjGH8n2kzWtWO7Q4xtVT9jWc07kX/Z6Q9QamqwkwLr79ZN/yn5QFhoL+KTDG0EYCcTKP8AaE7k0/TZtq2BMJkyltXj/xNKO6dXU3I0oRVAnUnYX+WfwIsJyaYnI6L2dkfljtntyaZwB/2JG5Hwsv2sT/yJXYo8DVZ2+AE4xVOubmVXtk56SWDe7XRprdzT5Kujb8kymKAAotnLsfWFgTi2tDfCrqa9LJVM8ej5V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 23:03:16 +0800 Longlong Xia <xialonglong2025@163.com> wrote:

> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> swap_cluster_populate() drops the local, global, and cluster locks
> before its sleeping allocation.  The allocation helper publishes ci->table
> before allocating the memcg table and, on some 32-bit configurations, the
> zero bitmap.
> 
> A stale per-CPU or global cluster cursor can reach the isolated cluster in
> that window.  Since CLUSTER_FLAG_NONE and a non-NULL table make the cluster
> appear usable, it can allocate a slot without the auxiliary state.  An
> auxiliary allocation failure can then tear down a table which is already in
> use.
> 
> Allocate the complete set of tables into a private carrier.  Install the
> auxiliary pointers and publish the main table only while holding ci->lock;
> the slow path does this after reacquiring all allocator locks.  Allocation
> failures now free only unpublished resources.

This is a complex patch, for a problem which I'm assuming nobody has
ever encountered.

> Fixes: b197d41462c2 ("mm/memcg, swap: store cgroup id in cluster table directly")

For the eleven thousandth time (I'm not blaming you - this is endemic). 
When fixing a bug, please fully describe the userspace-visible runtime
effects of this bug.

If there is a report then document this.  If there is a testcase which
triggers this then document it.  If there is neither then document
that.

> Cc: stable@vger.kernel.org

Especially when proposing a backport.

Think of the -stable maintainers, and of everyone downstream of them. 
They're looking at this thing wondering "should I merge this into my
kernel".  We're providing them no reason for doing that!  We should do
this.  We're the swap experts, aren't we?  They depend upon us to
explain these things.

> Assisted-by: Codex:gpt-5.6-sol

Doesn't have a great track record, in my drive-by experience.  Sashiko
has found real bugs in things which gpt accepted.  And a second opinion
is always welcome.

Sashiko review says "No regressions", but it also says "Status:
Skipped".  I cannot figure out what this means.  Let me
cc:sashiko@lists.linux.dev.  Folks, can you please explain?

https://sashiko.dev/#/patchset/20260813150316.2793642-1-xialonglong2025@163.com

> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

Thanks.

>  mm/swapfile.c | 167 +++++++++++++++++++++++++++++++++++---------------

I'll take a pass on this and shall await comment from the swap
maintainers.  And please understand that it'll be a lot of work for
them, and without that statement of "userspace-visible runtime
effects", their motivation will not be high.



