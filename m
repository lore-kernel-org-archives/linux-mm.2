Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E350CC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 12:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEBE96B0095; Fri, 11 Sep 2026 08:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC29B6B0096; Fri, 11 Sep 2026 08:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF9C6B0098; Fri, 11 Sep 2026 08:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C1A346B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:59:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3ADF5A023C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:59:39 +0000 (UTC)
X-FDA: 85201488078.21.6F6B387
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id AD58CC0005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:59:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S4EmxVGV;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789131577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKbU6ZCLYf+36lNW3LS5uhSrwFRNIDzXZ4c4yuSq4Ug=;
	b=Jm+DztctPesNPla0drXmn32kGuq90fYVsa0zkI5VmlOMlzBg93qtvJX6DyVk3pK5QxmcUR
	4koaAHRbOvT01ErD6JE5V0od15jDTAfNX/RBTvwglkoM9zeSSedHdC+LLsDfAzM8fMOE7Y
	0J/fCZ/57QLoGmP0cxX07qU8W4QysLA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S4EmxVGV;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789131577;
	b=p44OSZ9sJI+H6JT4PiUVkNT0kwBOkRvrLPGd00yO0W1TSzpKUNAQtSGUxomD2Ca6MbTXVj
	AkYv7ZyT7zAvRxGWCoKjr8lLg8Xhnq017iJZOMeqBquqOTtoYAWv/YCXnQzRUBbw7jdO0F
	oQqDZ2SK5JZHi2TjynwkPSJuyBxPqic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF60F60A5E;
	Fri, 11 Sep 2026 12:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91CA1F00893;
	Fri, 11 Sep 2026 12:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789131576;
	bh=dKbU6ZCLYf+36lNW3LS5uhSrwFRNIDzXZ4c4yuSq4Ug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S4EmxVGVN2EXpDK1mdHXmj2dyRkhyvTefQxs2Ed1lcVVpAdr64kc8KZ4OAdO03oob
	 IBw4kCAf4vMzqTMtdkuhTW3RYjP301+5k65naRnSzfEHfoRhmIx57u/fXs0+gSyDms
	 epLslWhFMPJ12tHHQI3wyRgzVny1LAtfsbJJWqW4B0j4A/MXVqxU7+EqGWH45aVGLr
	 qRecNBabXd5k+7EGgl1vCLpKOycF58Jv/7qAtvVo5vEhEJhmw2+Cld1dcAFO2V453P
	 Fa5Ic58w2xkZi08EJfSQUAUd5wYZwkdvfThDH65X4TEQA1mu3OMWgbTeidzuY9lI8s
	 pSEQSvNKRE13g==
Date: Fri, 11 Sep 2026 13:59:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH] kselftest: mm: fix potential failure for merged VMA in
 guard-regions
Message-ID: <aqP29-H0iKl-2CVH@gremlin>
References: <20260911123534.1181501-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911123534.1181501-1-yeoreum.yun@arm.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD58CC0005
X-Stat-Signature: kejyc8yjfojzm93i3sj8xihr7z6rinyb
X-Rspam-User: 
X-HE-Tag: 1789131577-968806
X-HE-Meta: U2FsdGVkX1/X9n9m0XtSGXTaV8Z1Mz4ZNYFldpR4XTKApP7ZDwEXklqE9dAAuw7Fq6NqX1nNLlO4jZB91kZF5t7fYtZhfXE1kZYaqUrRG2e/0tldAJabASfVBA+ONvhCft9mAFkeQUr48fWGqRnoInu3lKS8JlhY2Pj64PWmp/FjxQc33UgYB/1q4GCJPw8v+Mx6zj17cxwy+/37l61cBhLdyiDlSZXzdcEpc1LQTZ6HbBCQP4vHZNe++JT/JcgCWZcF+WlQ+vC2i4UJOcB5j2tp2fA2PiNqxD6dd9W/HQyUQWHKRXx/P856QWHGXHzPWBTZpdbiGi0TcR7pzHo9qtNNFgFUbOGdzGxTs7ssWaZS4BUBNYQpqiao2RNSL67kK8Dz0Qj3TTxZjfTm85TjXQ+vt8UCMYoyu4i2C7j6r9TqdU299ryDFCzQrJv29a8hW2bHx/exAIezav62aWSI45tgWDLfDHxC/FGmRLp7F++n3RBU8q1r5ZDdZQLJ5Tm4BAhRIPG1uHdgseK0Cj0tFyjdHI1mOwIzSzko1Qh0ApAMoGuOMEtytespEtG6kqrGa5sr1c/0Apx7JnLqARu+RRrASU/DG5XceJDeAx5ImrQelmJzmPZhuZ7xhwQQ1UEwV/7sTftYfVukOv+kpM6JYr4rLVH2n+8h5Gx3M81eAxNjP//DS1ktB0EWKmHy2L1JpYnVAbotRuxbsbCXPDnvV+IrVTg5tVLF3SygCbO0YC0UoVUISfv9n3DkW3wdhMdela3iu6mfKilWE5HiDpNR1GGOGrIZWFig68tD5wgqOxQcDbkaGVy96ADUu5vqZyB25y+Df6TiCmqzcBcepmmbnr/M0TNVA4O2pPxzjekKNwr/fHoRuafYhp9VhYhahv2eJppNYF4NeXAeYO8DrS69JPJKT2hoOu4ZiB9MHiBgzPFr+kxpl3JlCiKJIxbeS12QESQQOwuirsz7R/Saa5l
 McGjOb93
 GIcshZrN5XmsNSwhAXI1NBcCSMBK6tDmBr8FfUCV98NHMx16SWYtKIMceEjDmfQZgPLr2xTdPRHDOUOzbo6S/7WjSdCDCM1irFfTYjPlWoifSeQjSE8OgMCNAT3VXUD8uof0oT8YvfmuNKiP8NlHjGhwLNTEWvblpsa+YAcZRGfPn4aNH8ZcZIUXEuHtTU8CSfwdEZP6y2Hoo7eTVMMPcOJ1L7lQPj9bZM02q5ojJpTUfPfg96rqzq7WPjj2Vtlnjik9xOCPrU1FVFnoXtm4Rez2q1TE/ko3Tohw3mP4L7mE58pCurPCb9b22Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 01:35:34PM +0100, Yeoreum Yun wrote:
> check_vmflag_guard() uses /proc/self/smaps to retrieve the VMA flags,
> but this can fail if the mapping is merged with an adjacent VMA.
>
> To avoid this potential failure, first allocate a temporary region with
> extra pages at both ends, unmap it, and then map the test region within
> the temporary address range, leaving an unmapped page on each side to
> prevent VMA merging.
>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/guard-regions.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index 5c8ec3ca75d7..a28a57d34e97 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -2257,8 +2257,18 @@ TEST_F(guard_regions, smaps)
>  	char *ptr, *ptr2;
>  	int i;
>
> -	/* Map a region. */
> -	ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
> +	/* Try to Map a region. */

Map -> map

> +	ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_READ | PROT_WRITE, 0, 0);

Should be PROT_NONE otherwise it'll merge with the below.

> +	ASSERT_NE(ptr, MAP_FAILED);
> +	ASSERT_EQ(munmap(ptr, 12 * page_size), 0);
> +
> +	/*
> +	 * Map a region for the test. Since the preceding temporary mapping
> +	 * succeeded, this mapping should also succeed without merging with
> +	 * adjacent VMAs.
> +	 */
> +	ptr = mmap_(self, variant, ptr + page_size, 10 * page_size,
> +		    PROT_READ | PROT_WRITE, MAP_FIXED, 0);
>  	ASSERT_NE(ptr, MAP_FAILED);
>
>  	/* We shouldn't yet see a guard flag. */
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

--
Cheers, Lorenzo

