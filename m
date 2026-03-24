Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDAD0E9A75A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D11E6B0089; Tue, 24 Mar 2026 06:09:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8986B008A; Tue, 24 Mar 2026 06:09:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE0A6B0096; Tue, 24 Mar 2026 06:09:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2866B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:09:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9044714194B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:09:49 +0000 (UTC)
X-FDA: 84580535298.30.F48A7F8
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf20.hostedemail.com (Postfix) with ESMTP id C5A871C0003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:09:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="XEt4Joa/"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774346988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmlJnTySZmDWMkOjZAoeUQR+fhdtlT74RZiVZ452PIM=;
	b=w/DMr5WJ5EZTCZK23LSDyFR6klmPEzBGShdRX9sZeyK3e/culwAGIoNSeaqrXPQSauSs8p
	JxwZTc6/sQzQq3hzGYbZvQdleZ8arZTQ9TJG49Jlx/zieu/M81QQBMcgH0sf+J8XA8FPCr
	f1WZCT6odtn6QucC0xp9WxCRHaX100U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="XEt4Joa/";
	spf=none (imf20.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774346988; a=rsa-sha256;
	cv=none;
	b=uMvdhVW8vltkGsEhgKC2TSJ4Sy4Q9B02PphzDBf2Xlt0T+F2YsE/ULlupFSPrZYE/qQ8Vl
	IpUkJPDmOmxaTWLoBPEf4kqaaFGOZ5p2Cs9dv5eQKeHEtiwUi4J0vtEpI+vjXPs5Bb/x3v
	jBxr0fo93aybJ6NzDxL5enlWhX1pN7c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jmlJnTySZmDWMkOjZAoeUQR+fhdtlT74RZiVZ452PIM=; b=XEt4Joa/vs/skHzujopdU/ZI1b
	EQuOLj0QUlR56RAzsi4wNnyAJqTq2PI/cQaFdXuPUHJ8E840mzctlxYjEZ3H8993FwYh0JM67dndW
	Q57OGXRyzAjhP6RhlXfRZRxuAl23u6Wntp3t4Fr+G/d+6KvC1J1msDKkf51DKHPpqBxIzzPggTLZi
	hTLJ6MXSJz3D6dz9E5C987wP0IheEtwH/CmAk/F7aXKp7Y4pLqGH0e1wx9nKGRJLEDuQujE0zNusl
	54TAnoJxpVWtu3fkBeEVDVQfQvySqehpiM19UfsJKmPZARUGSIw/qr5/RWYXffTc2F4DF57sNP6Ld
	GunnQvWA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w4yhX-008ELG-GY; Tue, 24 Mar 2026 10:09:30 +0000
Date: Tue, 24 Mar 2026 03:09:25 -0700
From: Breno Leitao <leitao@debian.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/2] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
Message-ID: <acJh0Sk4UdjaTFLh@gmail.com>
References: <20260323-ecc_panic-v1-0-72a1921726c5@debian.org>
 <20260323-ecc_panic-v1-2-72a1921726c5@debian.org>
 <e046d0a8-b10b-405f-b3dd-94b7f4450313@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e046d0a8-b10b-405f-b3dd-94b7f4450313@infradead.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5A871C0003
X-Stat-Signature: ekp4uz8s3yp3d4tw3o7hezaxj7t7tiq9
X-Rspam-User: 
X-HE-Tag: 1774346987-133348
X-HE-Meta: U2FsdGVkX19mzYMuC8U8BYEAKw7Co147xqE453/V+F371UVXiXWyJVN2tNlvKyoWXoQmabxKZsdZCqGL7KdccceQGuFqtxQi0PZJlQtOnYYQ/sWBAAVrURq4fXoKgijILUOserzCyD8RozuLa3H6IyUIx1OXoidysHIsUl0RsVMq0FCWE3gajihYnVbvzPNRrBCUzq+nGKVhVfdUKJN6C/6W+JunZRsYU3qKA0ksfidJYjJy+T4ydHReeSxg3cDwJkncE58GE0IPhmthQh2GTB24dz0vVy5MbMaDOUPxNIOoyKa44MWJQ1NZ76ccZCLljTroq/cZw4Weq3q2VdQCcXg8rjZ73rCahDcWCdpOhWXI257uTv37x7ZjRMXk6DqGIHk+LQBb0Htm5MYqI1AWRRgeV+UbqTZwUgzUuhTfFKH5RbZKGJ2e/7cN/XM7nWN9QuHAW6jYWQ+yAa75atRjhEZHZtPmRmlHEbjLZhD/qcjztgf+FxNeeYDcuSqp+AeAc6hx/rozQkwGu5ReKi6njpfRTgFJfyJNmTKZaZDnZlJRrjd1iGW6gry86qsl4hZpWHqflWJlZ4O6D7VVA6uz6paw+qrzegOpkIP6GHVteqkFbqR8qYtI2W4MXqlr6gkbWeu00AeXd8soLAC0RgLyLQZgl8tqO346h3clpTA9nZtfZ6sNkEqLLXYxZ101QiaboIh5yn47O6168mrMh+9ysskcsG+xFhGe8jJKcyf1NqeizhMpHfzTZ1GQ4LTayqNp9amAZ3JJoov5xZq0plWU139738RingJD66+x78TdJpt8CRLBmrsaGoWKUGexehlMGzffIkTFF28ttPvkfcoFnklqfyGi7QTLA1d3tcYbSLcd2Jfm969FPQ593VEj6yLaMuN5HZy4+AIRgyEBVwC3IxCKgKrN/ECZU1KBNoLQvGftDFODD3+K2HQzzy2VxziDnp0ZZiEG2Bci+9R/bH+
 fOQ4P4uW
 DJi4f21G3Zu1Jb8aomQAsqR4KD3zmjzbIdHv5Exba7uyhpKWUsWOJLXo+Y8OPmPdNvzmvF+YhiaKa6z1HnkH9Ax0M6gitkibAqvve5lv8xXf6WIkNSOQp3lHVK65T6PspnnTOVG9kQ8XzkXnaYeQyc0RJo0APag3/h6svRSOO49kcsFFDpiULxDojhjkgdqHRaxtW2opWLzw7hBPNUFk40VQzCgIYyMZ6gvCwfqnV/i0/5ah2LgBTnTJApSBoRDUt3w374+X0yEZgVK8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Randy,

On Mon, Mar 23, 2026 at 09:51:55AM -0700, Randy Dunlap wrote:
> On 3/23/26 8:29 AM, Breno Leitao wrote:
> > Document the new vm.panic_on_unrecoverable_memory_failure sysctl in the
> > admin guide, following the same format as panic_on_unrecovered_nmi.
> >
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > ---
> >  Documentation/admin-guide/sysctl/vm.rst | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> >
> > diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> > index 97e12359775c9..3310fb8272fb9 100644
> > --- a/Documentation/admin-guide/sysctl/vm.rst
> > +++ b/Documentation/admin-guide/sysctl/vm.rst
>
>
> > +
> > += ===================================================================
> > +0 Try to continue operation (default).
> > +1 Panic immediately.  If the ``panic`` sysctl is also non-zero then the
> > +  machine will be rebooted.
> > += ===================================================================
>
> The table begin and end lines must be at least as long as the text (may be
> longer). Please extend the =========== lines by a few characters.

The HTML renders correctly in Sphinx (likely due to automatic column
expansion), but I agree the raw table format should be properly
structured.

I'll send v2 with this corrected.

Thanks for the review,
--breno

