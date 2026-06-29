Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD851C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07186B010C; Mon, 29 Jun 2026 12:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7546B010E; Mon, 29 Jun 2026 12:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6696B010F; Mon, 29 Jun 2026 12:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62B476B010C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:32:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90BF51201E5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:32:11 +0000 (UTC)
X-FDA: 84933492462.30.D438E20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E08631C0011
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:32:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vj90ypPx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782750730;
	b=Hz7obNLWFWUyMG72z/ttKqXg2GTL/BQA+gYUGEwUiDf+LeUyx7HClmpK3i2Ejdi+KCGdIa
	lT6EZ28QZ91hpYvTtbmRdmw92SPjEpmmmh7hFsM0VI3X2UfFrfKGbeDG7HfnrQeI389Y1U
	Hq7PVCBz72BsobyVRQh+mZcqyjKB6Rg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782750730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JfFZijyJV9AsvP1DQpWFlICw67hKnqAZfYEa37meUrs=;
	b=opb4TqsrZ/HB2VbTDgEhgpeXbUXWvWa6UszfN70xaLmq862+ATyGtpU/G8wFBz0SkZjZBW
	A9Fabd8HaQ4qIkPpAR1p8bDF6IDOSRHz86mCcMVSAJY3bp2YEGsn0uAJhmtysGVIAdHZk0
	VI/NKFYogIR24p+b6hv8UGHWXYFP4Dc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vj90ypPx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D51142A68;
	Mon, 29 Jun 2026 16:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E851F000E9;
	Mon, 29 Jun 2026 16:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782750729;
	bh=JfFZijyJV9AsvP1DQpWFlICw67hKnqAZfYEa37meUrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vj90ypPxS9/8LYTehiyVT6M0ooqBZxwSexLvUasutYhARUQBDzSQVlRkr6ryNwx/i
	 tqIW2VYOnbk7JS2jd2wYaO3GMRBCRtDQGXBhFq4uaLPJAn3G6FD1GO2i/A4lYbOP46
	 n1kG1rSxDrASZkbxJ6I56VX+I/DnXnNQUziuJ3elDEj1cx9HYms3RgKxZJLDSeLmss
	 JlBnr4sOC42dHAnEBDTLAVlyKtxZulXS7gpmYZCvwv+FfovCMnV0g2XSRZHHBJsFTf
	 RFyB/sb4kYNkivxIgV+HgjN4oYM9Q4+C/fw7fIfT2KTxTZRIJE77XQ2ucPxbB/JEuv
	 MClZVQ1IM4CeA==
Date: Mon, 29 Jun 2026 17:32:03 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: A second pagecache maintainer
Message-ID: <akKd7qp7Oy-MhGXX@lucifer>
References: <20260629135927.2586391-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629135927.2586391-2-jack@suse.cz>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E08631C0011
X-Rspam-User: 
X-Stat-Signature: 1ijsnsmpgorups1qwaqjm9zme1eyg6oh
X-HE-Tag: 1782750729-645329
X-HE-Meta: U2FsdGVkX1/N/ejM0lKfHI4oGDCGSAUHFs1r4EVeiB9sfJ1EXJinJwgC7RINRkI8ocInRilGF8FOmXMGPTqtieqiuVqbgydMZ2csjoSDn8m12AVocbuzt+8i5EI5w4lfTupPX6EARkhoFIVPdymPXiI9PQx4aXaporuzE586vj8kXJ+lx4Voj+rimem2wqUI8yBEZ8INAeg8elDybu7pH71FhPvgLsFlA7gtPPS8wBorn6CbekO2qrBWI1JqLOWD/IRd+4AhhJfUWSSB1w8yfjnH9EdpY6Eh9WckX3U4yRVygPi3IiGpVScqa6QBTYcY3Xkvlxb4+UMw/iDsb//ovYaCe45XiZpSRZQJg3XNCr9VklzdCymo+MFPUFS//mc0tGqiY6nT8yxSVuo7Dgma1P9Z8nApELR8Y5b2qFEeG8cuw14V0CzHmcWJd27hXzzTH/P9k70DK+MqIDNPejwunYEFt5mb+WEGrZoGFF2mt8vQmwU8FRxykFdOwa36as5UnSrucEsjIrhnVOcyi54PZw//RvEVz2Gi2uKbVokPMdyu2WEkfrIuQqdIlcZTmdVX+bMRX8APtKvMyqmp1wGqFTg8R2D+n2ialeiGfHiJVtM+VhMU1B3fjBlX2C7gRLdkLZbyBIlJIFtW7O0LG9AZ1O5N7Z8tRW/U1KAVkVc0UClO0g/Pp4X2IYjX9V5PBLZ640mhKnpV5F/FoeR53XGDCHawXiKPRMLDBXzr2yncgRRVvzXG1db0YL/8QjKJw00Nm0IJtjek01vn/8JrpiG0B9xZRVLizdD4ASgEAahfU28B7JiZvmOs5UC/4ZtCRZIo3KuG2OVVmlUALybqKyf3n6bIsl0w/NfvuCslWBUozroGt5au5e430/PScUdoCbq3ZU6YiXoyOoZqiRgVM01Gfm1t0qP36t3vQ6efNrosG73vpGltXY7pslvV3bheTIyOPvvav1ywcibg1xYuPKG
 l3BQRqmH
 MruYtQPOnw6gAvi0Bpg44e5FAndv8N3WGivOSQZ7dJtEgi1NQ1ljQeqiYy1NDlo+LP6LESbCKt5FnnEVtwYrNYhRbOZ3o5eHdm2Pxl8wstn0Ycz81QGNUAUld/6gsYBYqUpdh5fXuG0TtoTbvh40Iuqv1OaRJBFutJuI8dBApdmvil5MHHj06jKDy1DPn2wa0QjkwWWJFdTe6IkXV8Zz9rYnb0mlhT04ByfnXOCkfvT3aY4Wr7vMMpWHjIMrLatQU8NwkgX28Jrb+Jn6y5FAGJkbpcvKpMlu5fbT/MoOUZ1ZK6I8sNjw4w25dQNH1Qg339q3IMC+au94VVZNOUco3MwacDCvhHLLGqfWLTkfqA5rFhmwBxlOhNwsYHsxPf+TqcYAx/oIe/oEexB8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 03:59:28PM +0200, Jan Kara wrote:
> As MM is slowly transitioning towards a more distributed maintainership
> model, we agreed with Matthew that I will be a co-maintainer in case he
> is not available.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks very much :)

Acked-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 15011f5752a9..7d992e288343 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20405,7 +20405,7 @@ F:	kernel/padata.c
>
>  PAGE CACHE
>  M:	Matthew Wilcox (Oracle) <willy@infradead.org>
> -R:	Jan Kara <jack@suse.cz>
> +M:	Jan Kara <jack@suse.cz>
>  L:	linux-fsdevel@vger.kernel.org
>  L:	linux-mm@kvack.org
>  S:	Supported
> --
> 2.51.0
>
>
>

Cheers, Lorenzo

