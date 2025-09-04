Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7228CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37418E0008; Thu,  4 Sep 2025 02:11:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0EFA8E0002; Thu,  4 Sep 2025 02:11:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72F98E0008; Thu,  4 Sep 2025 02:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 968008E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:11:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D81D86A03
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:11:32 +0000 (UTC)
X-FDA: 83850546024.22.FDA314C
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1619D40014
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:11:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Zw3zRPkO;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756966290; a=rsa-sha256;
	cv=none;
	b=O0Gqc+bzIS5k1FBxWyYrr3f/JFPSVgDz66EAYP+S3Lp896Lyx9txr6FHGw/ZXlrlyKI+ik
	zy/pwcWMzBwBausOTNCGNhtii7KzIvy9kiGI61K642qE1XjorkhKVCJvXpYgFLe/asF7nq
	8TaKHYK/uHmNVjAhvKT2BeKG+bBv5Ig=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Zw3zRPkO;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756966290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pMr2AJyZ2cwZjMK+R2zzArtB3tmjy+ONY5ZQPKXfLA8=;
	b=1u4wZcUNvxsq9jQ2shFgsm+07RW9D1kGrkDypaAIO89RGqotz9bDtNAJqiFT8BLmxKKhnE
	uFCNkYnMPI++xXvOvwPQAWg3q5/L8LtMUYvCtLWauYpUkRqr819iFhBHsaZ5iI1RlK71Ok
	253lHNMfrkcIrJJM384qH8EIjmFu800=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756966286; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=pMr2AJyZ2cwZjMK+R2zzArtB3tmjy+ONY5ZQPKXfLA8=;
	b=Zw3zRPkO1axEGr8w1PtyxGjhG34U26F9uvpVsF/iQuxX5UZ7OfEahljVnMaYzKpcUp2YobffEfbLUB2gO5d1abRfkJHx4LgO1WgNWvDtisz4n+dCdrxcF0hL2DPSwLrg7cdNgz3PI6Hgqaq8tKAe0tvHtpUOd9ugDC6jbJDBlww=
Received: from 30.74.144.113(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnERfV8_1756966283 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 04 Sep 2025 14:11:24 +0800
Message-ID: <8cf7a0c6-be15-4935-827b-a6000395d545@linux.alibaba.com>
Date: Thu, 4 Sep 2025 14:11:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@redhat.com,
 kas@kernel.org, willy@infradead.org, hughd@google.com
Cc: ziy@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250903054635.19949-1-dev.jain@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250903054635.19949-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1619D40014
X-Stat-Signature: ag5c1zmd5miw9pypozkmg6ctdxqsqgai
X-Rspam-User: 
X-HE-Tag: 1756966288-270230
X-HE-Meta: U2FsdGVkX1/LmxIVF9EUA2JcmSHjsmhC6V8jljgBWAFie87c2kQNHW67VhEtjI4CFmLk7qmoI8PE5Bq0qqAuAwo+78vYVzB4t82LZmvI4VmgwNu5pe98J5bFjBYuIiWNiJOlLcy/Q0QS8vn5rh2BbEnuogf0XY6JaK5SlN4Mvp5RfRhudoFP/cQFqEA/ZYdw2616ruLogXiGumfwZ39TfYM7dG0oX25yOOX4sOxrtoVXwPg2LJwYQw0E0y1ZXXQ8V+LewQrm74oUgYBZAeLB915hkNe4OfH4WmEEOWdAgzSEMBl8dzl2FiQxQSHuiJ8wz6XdQ8erbbs70E07+S0v5Z82RWWgI7UJzjgG3cR3u1RYt+Q3nxX6vkM9HsfudJ7fPVbOJ/MF7brYTP9fibxz2HKi3Q9+ujNSiVe49l0IMZVfBFJgERBttJK6dxZcNsKSs01A5TeretmOJOsZIGtXnydpT21bX1M04QMWIYIjxpa6g0ecj6J/JpL/zb5kvK4WYdHyN0SUNFwF9PZljyncjZZYOEURLQfX2SpY0vPk6F+pc7ydTlnci+7nAvCnap3Nvq7AoxpQ8iOYXztMVzkjbVwKu9mk5dp25qucTtd+o+1KS/jtlY3LK8A+wzKcdNyuyoGgL4uF+jmxD4dTh+CroQdK6HqAN0928VooL/eVdipIJqdlwMvZi8UNAVMjSo/yJ3LgfDzg0z8DVo2OQU3FmTfZt3eT/P8MYaCT/naRGnrZc3i2DzHfVEW9sq7laFKKqs9k9UPClK41tvFFqtEc/n8OKJZLGEutyJY3Q0/KQt650tw+NbLTagTyGKsRKg+/RQm85znPrmN1KqG+q0PhvhSJXBKTpiKFfQlP5HIuZiJupXg+bEFyTRIHQAKPvIFr9KJG4SgNE515JmvwaZEoZktIC2ctbBmqRrNmGR2O29Sse2g+8qbMTqyl1nJdtDEFWIR0ilHhCzDUFP6Q/N4
 aNYTMx6O
 4N3zLO2S4HeiVJTmgJ0opqKFnQ3VCgiWOMMIT2lnC0FZXGGj2clcNCf2v8f9g3yzpBvg+YFCu7/c71nxdk92UijjnhEHmwq/ape55vwomAj5yFYmBhPt9E4hj/lF2/1jiOVkHiVATMgmnfAyCF+zYPzgcWKPPPBKXkzOFw2huEJQ++7bzEl6igxy3DzFaeB1VMyGEDCVwbqNc1iNbrDrt5dB0/HrbOlzF+ra3emfWT9fv267vKVJW2Pb8wz2w1/ZCilxwbI4g0SHYVHufVClCawqDrSoByJ9qQVYiUrom61My00k2RXjtxHPVReBtEzcRoXEBdAACgrYhlxbIk8sV4DW3jZEUsMhwSvwVs+8zkIRSorQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/3 13:46, Dev Jain wrote:
> Currently khugepaged does not collapse a region which does not have a
> single writable page. This is wasteful since non-writable VMAs mapped by
> the application won't benefit from THP collapse. Therefore, remove this
> restriction and allow khugepaged to collapse a VMA with arbitrary
> protections.
> 
> Along with this, currently MADV_COLLAPSE does not perform a collapse on a
> non-writable VMA, and this restriction is nowhere to be found on the
> manpage - the restriction itself sounds wrong to me since the user knows
> the protection of the memory it has mapped, so collapsing read-only
> memory via madvise() should be a choice of the user which shouldn't
> be overriden by the kernel.
> 
> On an arm64 machine, an average of 5% improvement is seen on some mmtests
> benchmarks, particularly hackbench, with a maximum improvement of 12%.

I also wondered about the writable check before, but never dug into the 
history. The result looks nice.

> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

