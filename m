Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD40CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18F66B008A; Thu, 28 May 2026 09:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6986B008C; Thu, 28 May 2026 09:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D067F6B0092; Thu, 28 May 2026 09:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFABF6B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:59:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 586DAC29D3
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:59:15 +0000 (UTC)
X-FDA: 84816985470.18.D6C7560
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B1EE740008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:59:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hEZQxFzq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779976753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPxe5/fUb8HNT5oHXGEZ+67zzb+YcuZJKOw42RnppVc=;
	b=5PDrwB3ZTOkbDcTzDaBnl5Dm2U/olyWz5X1GmeiYoWuCw5XDnp8vXpnhJa6haioMxQnR68
	OekqrmC4Yey/bQeRkoPYYRHVN5yHe2L72lTw/TDhn4MvObi40e9g3At/myUDcuFfKdHZFP
	lLi3bQOaPlh0qr5dw7FzYCR0iv5EnrU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hEZQxFzq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779976753; a=rsa-sha256;
	cv=none;
	b=69XnXsirH/9Xs3RW2v2CwqrQwAqUppuIDaI4/K+goCIorTWakilAGBSk97T8mwl/wDJg21
	E+at+BWw6+f0+K7QYgToHGNYtbRZB3KnmkaDw61jEtpt0CZO+5rQcPnQcUtLasg4OrQ2S5
	mke3PTCH8X6TgboRRMT/ZbQO4gCkz04=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C79D740DFC;
	Thu, 28 May 2026 13:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572AD1F00A3A;
	Thu, 28 May 2026 13:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779976752;
	bh=sPxe5/fUb8HNT5oHXGEZ+67zzb+YcuZJKOw42RnppVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hEZQxFzq4hC8gX5bi06h8iU6QclMBBPcjuaWV9x5GXjav8NSN/YydA2psYZmBMc1E
	 kQG1ND8eooSLv8Q1YRBnkMKs3CyvypJP9MTKFvrput31qvzvkZGXXHZCVpZmWrkLwC
	 V/R2KxBoRrtQDPmnbOLG5b7C3z3ByxrNwnpVfPFqGsNfhQYts4k1O8i4nggPQ52zna
	 a162x8gcmI/kaOt6TUHvrBZo+c5Z1REasqjdfn3NG9Z/jr23NXJJUmhEStd18Yus9X
	 LJ4Cs0c2owV+o5/7XRJg2H/cN9gQjuDcYaiRbP13mx96dQHeO8i3IoNBniRwgy2NPv
	 aTgvqoArIdhBw==
Date: Thu, 28 May 2026 14:59:06 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Brian Masney <bmasney@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add vm.rst to memory management core
Message-ID: <ahhKGmxxTCmM13YY@lucifer>
References: <20260528-mm-vm-rst-maintainers-file-v1-1-306631c0a610@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528-mm-vm-rst-maintainers-file-v1-1-306631c0a610@redhat.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B1EE740008
X-Stat-Signature: 9qfwa6kktg76wwzypz4g3kw3t9u9tb9r
X-Rspam-User: 
X-HE-Tag: 1779976753-35048
X-HE-Meta: U2FsdGVkX19FMDrNUvvzqsyQAH7Aj2czb/GgzA6e8AwHUYt3fOK6SIAA5PLSidWbBM6GcDUKdqV9tpDvRFiV5YLlySYL9mlu2FO7euSWbu/Ks1E4HQEhNZCMSd1oxyvDmiU4oqQ32jnIpxHm9Q31Lk5cCw3hQPg4C0xnTUgJDxWWNdBGZrL7m7LbWTLlUkroMtVqIm4P43+G7+y0Qc+E+mTECwh0bxrrXXECpTdsg+qdyNIQFZ5qnq65BbxjLJ7MovvryStwMnilnma9mWTjwJXi6v2X9YjBuWCcRBWoAEDEY0UDWAVIvNEUvQ1ZlCbzx6iu/fInrkEenlBRRhpnZ4D4nkrJes6sARQC2dYhYk/92Vc2miw/KgQCOHiAFF7sBZmALtVj+Q9RN3jXu9vtcpNFhzhK38suFV+6ByjGdPmPqDp20IByKV6iv30dYQfqyXzNVUbb1FpgiTwcAxB7aQIlT/P0WFai332MM7/X2K83gCdHT/vk/93T7ssnZT9++4OVEoeMBE8jGTfXokFtQymbvOwjIS2s//sn92KMDyOAiTxCzNilHevYPA2UFBoX285xKMTqpafpA3rejQFCmIkdLxViJmUy/qnFEoBxpTIOf2X5L6+2MBMX2xaNP39Slgjv/MrXhSRJ0bdXI04V0SPL/tSi983W65ZB9kxFwEAxO7SQ1m+6z/ccx4TEyuTbfQPpQIagQymO9QXzBgh0Qdx85/w6tV28m3nqyPT2bLAYAG6kECLmsuPSXV7R1LfYocg4ddl0/aqLr1Rc2wf/tVn+IBsHXzVYtYoCRqU9KLiV1NkyvrXzfSQjk9U3fUnAaQAnJvIx5+Fvc7Cl1rDKQnTAPL08ztq9VFHmckQuxBdlSVZE+baZo8WwjKSETJVsYgPEAJYuMFdnkWMj98uot6/q+V0oWxzQN31Iv1fKvprwyoFPs2zKpIVD/M1SG+P8k4SyGtMIfWKuGMLwAvp
 8Drjcaah
 TMD5SHPGzuzcnHIREwcLJFIx2A79xFAGwvjyOtASCbVC21xt7ttRK78RwzRYgGmz71Co0s0aWufv22lPSSu4MmDuP8856SqDtjsFv4jCb7Wv7UYW2iSIiXKY44W8L1sL/sY2hZhvG0BuiU3ozpCqPOAntxjdOOKeFQ8nLlattN9Ygg7g3B1Gt0U2wvvUxVNaIGjwSK3Ce8Xc+8s3Wzuz8hzmfhrgHL777v7OpX9/OKVomF3GcNNufNFOmuc4pEfp1xXbylB0c6ZKM/cnhLiaEu1Of+Fp22K4W9fT/RDyOlW6cemnsvnxDW4ugIPDI9DpKaI7RRw1yMW/hRGP12/CHodi0CZetRYgGdcwHWZttKD8fnjsBChVUkBJLryXTASw+gMeCTcmcz9qgTuZJoYy1NBxg7XPEEh4rcECW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 09:56:14AM -0400, Brian Masney wrote:
> The vm.rst file is currently not listed in the MAINTAINERS file, so
> let's go ahead and add to the MM core subsystem so that the maintainers
> are CCed when changes to the documentation are proposed.
>
> Signed-off-by: Brian Masney <bmasney@redhat.com>

Seems reasonable to me, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c99f0650b334..d8dcc4f25ccf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16923,6 +16923,7 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	Documentation/admin-guide/sysctl/vm.rst
>  F:	include/linux/folio_batch.h
>  F:	include/linux/gfp.h
>  F:	include/linux/gfp_types.h
>
> ---
> base-commit: e7d700e14934e68f86338c5610cf2ae76798b663
> change-id: 20260528-mm-vm-rst-maintainers-file-1baa6da1e7ef
>
> Best regards,
> --
> Brian Masney <bmasney@redhat.com>
>

