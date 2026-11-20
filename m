Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840D760A2601
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=deLSRCTp
Received: by kanga.kvack.org (Postfix)
	id 932CE6B05B1; Fri, 20 Nov 2026 05:11:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E30A6B05B3; Fri, 20 Nov 2026 05:11:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81FA36B05C9; Fri, 20 Nov 2026 05:11:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED0B6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:11:46 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB0ED80E9E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:11:45 +0000 (UTC)
X-FDA: 85455080970.21.AA83921
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5565C40003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:11:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=deLSRCTp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169504;
	b=r5iKqv9L27mTxDRE+8qpx9nH9YVRLjyMA8C2nlnje/v+QdgkhaervSM4ULfq2ZTf8joxAd
	jknVw+JGt8CrsfrW6CPLKdVXMcPq5+6eVHxGmPmo861qlxu+RQyUry4UsqkACZLuqHayS7
	8NXbmqBIFEoh/NPRVChoRHMhm1aBXiw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gX3mLQC7ilPSH2BMyBrpIhR73ceBwKOo+TT9X1EOLu0=;
	b=pffIjy5Dd2EJBWseIaBBtHMI7fra3XVrlXAXmSeCzu4oCVV+c0eJZJx8pEjPJHYqGEkFqg
	8ZLUpvBCF18wxEv7C8zoLtQg4+6drc0GxRRi9X3wQXjXfbQmc/M2IokNOy5GMEfOWU6NrX
	JAulkbijSFczkrLbHm8/mJzdp01paGQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=deLSRCTp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 876DD4139D;
	Fri, 20 Nov 2026 10:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C0A1F000D3;
	Fri, 20 Nov 2026 10:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795169503;
	bh=gX3mLQC7ilPSH2BMyBrpIhR73ceBwKOo+TT9X1EOLu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=deLSRCTpxYpJPHrUizPrOQ+4IE+x9rzCbJRhp3B8Kt8ujsumOiNYgcZyxdvNIx+0F
	 HpylfNoVYtk9ARdYA5wbHh10CsL3cY2vae0vrCqyiubGAGt1hM5sGrxtsVP9lGD9HU
	 aZwM0uftYP/bOowFAqrd2knay7BeU9KOqbZh+vHxB3DcmOaTSi+2PPDsjhFjunh9+X
	 tgZrw2oquUcGbuAIj1PyZCTVJAldKJvMMmgfU+hunDGHHzNOO4pETlNbYqS/b9oLz+
	 hL0RDo24CHmarvGqyzZIxkt4K3MBk51cFW2yrYb5aTKg4OV4CcRoxmVR6aVcf0Nvox
	 ZawXSxqa7GA/A==
Date: Fri, 20 Nov 2026 10:11:39 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ding Feng <dingf3ng@gmail.com>
Cc: Ma Wupeng <mawupeng1@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/4] mm/msync: return ENOMEM if len overflows for msync
Message-ID: <awAZLIPNrcHeNr6a@lucifer>
References: <20230321074035.1526157-5-mawupeng1@huawei.com>
 <20261120051413.46167-1-dingf3ng@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120051413.46167-1-dingf3ng@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5565C40003
X-Stat-Signature: rakiuhwews59m1y59kdu7phw3psrqbbq
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795169504-41282
X-HE-Meta: U2FsdGVkX1+0PlFJpNcxKlIldIvnTgeSTC4WV5Rw3Ub74j6VjhChZLqa858ZGE7CLBVoL5Q8ywrjIVbXbj8XBdNKgD7OiScU0Cfjsip2w4Hc+J6Yiv3jxY6Gyl1yFigxG2f7wz3RkfcDVShUDLfg5akbigaAMQkS2YRNqmuKGhLLSpmV8ALadkTyAV5DfQLeRxlEyJFUv2isn+2ztnnRI/h/UDKny2iXgFjNL5SiIEWSSkyi2awxv9gfWPTRB8BOmAlvRiglvy3YYxoI+QOaz1rB6f2ZSSw1FeyVMSjRgBTQ+wHLEqJH0NnLWFHi29GVRQW8+g+M4Oxa9EFTpx35h3TUwUt5JungQtLHB7BlCMmP2SWXrboZWBpX5Nu6fp9foWWnbEiIpL1o22rJyfLlInwUoZjYsQWqp4oj6DzOsHkZ6Fe6vKJhXR6/NjKQpMlx1skHv+xa3BzecaJfgsNYQywdbkUryBrX9IFlsRjPeZi7hnWaVnOz/bKRHgzEsvndB0YbKRm/RFzD1heCV5frOfY/nx4MTLmJkbAlKeMGWLNdy7BrsGROsmYi/ZFWYfq4Lp8GqGEqbDHqKeKX87I/7gOwbP55GXPLGEtcOor+jttUPSzemKbvN2P/QNzU1EBY5cYNTXL/4jM/gTU0yTeg+2Sl2C0Eze5YTXNdNEuKU9yCdsEHi8kCEAGuZ4bALIfHzTFcW+sVPyuT1CG/U31TCGfk3rM2cM395MEzFDq6X8CkaXqh1lQZEHTVPiYCKSbRctKoAfMBszVJHwBHnFIzHck37h7QisbV2l/YPbJw3icFbUEblFukc8bsDiNOI2MJh+DPU99y9E4/Z2viSa6c6pRMJooHJgC6i6x9iZdYZX3Zt6IxY1Sp4dB6Zg6ZFzzMPhmsbp1xVFMI1h1us2fgk22ZCqy16H8mWPsB7YPttnA/FzKv6RMaKB1uQGuNy7DwPvX5xhv3wWtC7I0chb7
 OSrVO0Di
 shd53UHvrc4S85sEwG6NjRoVwDTeUokRMoCgRFYZntb48JxLXoy75THuiY1Sg/UuGkQep9cYSBh94N0TfaJObtFycUBVBRgvvECNTiup23vFk5SnpR/rl5pryx4ZG5KUGSXJ7OMaSqU6HD+pogzfBa5+lNdPIo4sAMK4ZN76DMJD8pt5YGT7i2y+m4Lba6uyT9mXwa6pXuck7zOW6GcyhnRsIBfz0HiYTlWBVNjbWRSiedUM6ylTWT4PkC2FWx51F/UMclw18c5VEPELWteZ6XhxeBXVITlAejdIWZZhywKKwAazCcP7kcPDLuTs7zREEgWfr+/1fpyiiLdGbPnwKWoLr+966fNWdBwZ4Bf/ByhTt7U0/9VXI2EGlkqsjeqy63og0//cMTuEWA+8WgLiZsddZeJ2YlPUbb/G4625pFxjVqlWOpcDae1j+Vi6f/1bET7JcHdH3ozaKvt8U2IWdTm4coh1QgK07WFmphQp8MbxFH7u3KxaADd0bdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 01:14:13PM +0800, Ding Feng wrote:
> Hi,
>
> This patch seems to have stalled with the mlock discussion on v4, but
> the msync part does not depend on it: a range whose page-aligned length
> wraps to 0 always covers unmapped addresses, so msync(2)'s "ENOMEM The
> indicated memory (or part of it) was not mapped" applies.
>
> It is still reproducible on v7.4-rc3 (65e4fd942), and the patch applies
> cleanly there. On a one-page anonymous mapping p (arm64, QEMU):
>
>   call                              unpatched   patched
>   msync(p, SIZE_MAX - 4094, MS_SYNC)   0           ENOMEM
>   msync(p, 1UL << 40, MS_SYNC)         ENOMEM      ENOMEM
>   msync(p, 4096, MS_SYNC)              0           0
>   msync(p, 0, MS_SYNC)                 0           0
>
> Tested-by: Ding Feng <dingf3ng@gmail.com>
>
> Andrew, could this one go in on its own?

This is from 3.5 years ago, so please no :)

This doesn't really matter all the much and is a nice to have I suppose, so
let me send a patch for it to make life easier.

>
> Thanks,
> Ding Feng

--
Cheers, Lorenzo

