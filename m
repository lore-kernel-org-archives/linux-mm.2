Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21398CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B0A8E0007; Wed, 15 Oct 2025 04:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614FF8E0002; Wed, 15 Oct 2025 04:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504668E0007; Wed, 15 Oct 2025 04:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BC128E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:09:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8A77C0B9F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:09:42 +0000 (UTC)
X-FDA: 83999624604.22.03C806D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 30D6540009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:09:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HKJXzUHh;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760515781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LpsVMe3gWQNSqHZ61mLqqVJi3uxpIwIAR2zKBMwaed0=;
	b=UMc40k64rZ86HN6BjeT0DKJl8b04zE9oO7+NLySXn9dajy+6v52BThencIj/+2HT6tAbD4
	ss2LFMLJUZ+LjqySNf0c7NsnDzM8KNwd9vqJPQNZ8R5jrMRTs2bh21TBajVIyB2UUh5zJ3
	lRGcQkPR+U4TQsFYsDWfpuj5xzZ/Nlc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HKJXzUHh;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760515781; a=rsa-sha256;
	cv=none;
	b=MgHNBw5Gj8tvgXP1dUWNMbK39ijbWYZ6ruxoIXonShGFJ75bqMf7fy12luN3TSP0xLmpdZ
	Tl+O9I+V6zmO0PMItgoB5R/i6ByzOSTDAxS9x+6QFmBjXXLfJ7ZfmoAJ1YvGn4XTukCSkk
	C75GXsl4CknC3TbVuVXCyfaRXdlXbeM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CBC6A44CC5;
	Wed, 15 Oct 2025 08:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD03C4CEF8;
	Wed, 15 Oct 2025 08:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760515779;
	bh=TvFSqbcGd3/w9zlIUZI587yIGf6KC0toARU6q7rKKqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HKJXzUHhRhbwK9P/unoPTYFgotjilicrECi5KClgaJ9t3x963PsSXqd6egSOR5aPa
	 DbU1AmDfFaF3GpEXN/aZ0PMwYPGPLiKbn74QEqQvq/LWMt3lRieCaLZh6FCvPYgHVx
	 l7McR6/Kbqsy7hoLdN16s8HUOJ5f45kkWvJX2S8pUQf8Ko/JFsNa/At5SNlxDP0Zy4
	 UnCRnzeOU2DGn9lZcfeAcVaOJnR/NR4c0IDIkrTtWGb6FUMfaRLqAAFGSFIJ56Wr7/
	 Nprv5bM1AB+tUHDmOn1zfxIAZKhcSsJ3/k6h7hdeCYx2F8w4aby/P+RS2j0EStPsna
	 gAw1m4geR47vg==
Date: Wed, 15 Oct 2025 11:09:32 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org
Subject: Re: [PATCH v5 6/7] liveupdate: kho: move to kernel/liveupdate
Message-ID: <aO9WvF_WMkKKqYo5@kernel.org>
References: <20251007033100.836886-1-pasha.tatashin@soleen.com>
 <20251007033100.836886-7-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007033100.836886-7-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 30D6540009
X-Stat-Signature: 5t63axocduqof9d1mzg8qwx1wzdqpc51
X-Rspam-User: 
X-HE-Tag: 1760515780-893627
X-HE-Meta: U2FsdGVkX1/tNS2CcvS6s0VWuyQKQ2ze5xc90uwDGlM5he+gYgl9zXxFKAqnJ75a6zNIBturC3PZPwFSMbBEj2BsdutPakgTaPpFPjyVcES1wRVXZawwd6zi9qF8Bq6qom11CNXKqEAPdxRrE0+nVL/wMjW7MTDf2MsSpnWgMO6IBL6L8wwfVyo3a+S9c5zaEZBb/9SUBuq4WLkByfA8ahl+QtLfVYFkboOyZUVtklxSLkT9PfJcqKFKQEREhat4Mmugef0j0XA/E5q7rr9PSKLbuhMPwWQpqMmNU2mReqDPNzbD0RWvzbPuvP1Np9oyOwCtA5LMszLdMd5+npisRX6Z0hQPXkqa4Dv/GNZJEfHw98hFmqjllD5eeIR9hOybLfhoRQtAEaQTtAtrOr2WQHE06lyUBeYuqa6R3wNqrrvPQWlqKyDQsfoR2UMqgzdjNt1kx77PDwqyDrHNkwVn6RCOXgg9nSMsQLpSsLi0NlPZTyCvbJXWJZRwrBrv5IcYpmRtFLX0hZkclTN5xvLPThKBbryz50cOwVDsPgLv3qu7+q8e4+PB94ndnnUcUhYCJpzhNdE/822yEEzHsNaewbPWiINZtwEJE9nzAawe7spLZvYN9jsjobQphKbx5eb32GBSaZH7JvthDmFlnbtOKoAxx1j/8fR9XZGY/M80hVZueYwpbIk0yP2Bg8zFReTBC9agBTALqJZT4PB4Tope0X9zUS5yjaKa56ystGGToQnno+hnaYF/Cqdev0UkYXY2aKb5bdS3ikH7G/gNIhYO2SQqTOtIYLGwXpFtDtvA5zrbVR4aaqJm4ZkZ92MktKAp+Me3jtrhM74a86gA7UVslGMc4/uyie+I7wSgNhqqzxabBXPSDYnCczJ6BHEKbhiP0bkrS3LMkaUizoKiiVF6uMlLhNO/YwCScLOQR1rbZkGgy13fsPeawdZUdW/XS9n32vjh2y1AJ6oDFFEUcIM
 O3jR1ks/
 ESVFvsDMMla4mV7qJe4go5HA4NWgV1UhrWN969NRD6Ra4YWtb0UIO7m1umRQzM2zhx1RdRTdeUTuZG6Vz+QPOteD26Oly63SKVxX/ktKUtLp/gpVozwFkHN3j9OOTzKhbeI9gNk70qoVTuJl8Qya6+v0urosrImdwXV30U9lFjovyHWrKyOkkpkZVtwh9argzKeVYHIUNPDd51XesqhPC0TtPiKnM0MuZIB3hGMUJVIASWGVz5HbyuU4NVVqhzsxdmgK8V6L2Oa8QGSgsCzFaYvAhG4GJconptzFZs48VFFi3mEImmJxkZ1+jO8lZon11tAUnSf2/mYZ7NV22zOL2205Wfq+ONpOEtpkLASlvBUbU/yg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 03:30:59AM +0000, Pasha Tatashin wrote:
> Move KHO to kernel/liveupdate/ in preparation of placing all Live Update
> core kernel related files to the same place.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

One comment below.

> ---
>  Documentation/core-api/kho/concepts.rst       |  2 +-
>  MAINTAINERS                                   |  2 +-
>  init/Kconfig                                  |  2 ++
>  kernel/Kconfig.kexec                          | 25 ----------------
>  kernel/Makefile                               |  3 +-
>  kernel/liveupdate/Kconfig                     | 30 +++++++++++++++++++
>  kernel/liveupdate/Makefile                    |  4 +++
>  kernel/{ => liveupdate}/kexec_handover.c      |  6 ++--
>  .../{ => liveupdate}/kexec_handover_debug.c   |  0
>  .../kexec_handover_internal.h                 |  0
>  10 files changed, 42 insertions(+), 32 deletions(-)
>  create mode 100644 kernel/liveupdate/Kconfig
>  create mode 100644 kernel/liveupdate/Makefile
>  rename kernel/{ => liveupdate}/kexec_handover.c (99%)
>  rename kernel/{ => liveupdate}/kexec_handover_debug.c (100%)
>  rename kernel/{ => liveupdate}/kexec_handover_internal.h (100%)
> 
> diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> new file mode 100644
> index 000000000000..522b9f74d605
> --- /dev/null
> +++ b/kernel/liveupdate/Kconfig
> @@ -0,0 +1,30 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +
> +menu "Live Update"

KHO can be used without Live Update, let's make this "Kexec HandOver and
Live Update"

> +

-- 
Sincerely yours,
Mike.

