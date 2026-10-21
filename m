Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B7E606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 13:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aIPX+SlG
Received: by kanga.kvack.org (Postfix)
	id CF8E76B070D; Wed, 21 Oct 2026 09:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA9AE6B070E; Wed, 21 Oct 2026 09:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC33D6B070F; Wed, 21 Oct 2026 09:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4986B070D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 09:41:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C88EF1C3CEE
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:41:41 +0000 (UTC)
X-FDA: 85346746002.02.3A48314
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3640240003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:41:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIPX+SlG;
	spf=pass (imf11.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792590100;
	b=vkLNzrnyxfVIIxict7wr3z4c/ViYLi6EeDnoHDws2AxVFHXkIm3oG5IiKro8rx1E2UavCA
	6myPqmE2EoBIFxma1DoUD6QpeabIbgDnoUW4asvUMn9sgZBSRKs9wfjm6sBoj9O/fOMotG
	TSvGwCXxdT39iWIkqX3W9coZYd5kKFQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIPX+SlG;
	spf=pass (imf11.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792590100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTFhtZqgicHqPLQLHq7f0+ApWdYensFNsFbqs8ibbZ8=;
	b=LUUdc2b1bT2Kgm50xu7Ltp4EIK0t5m/Vp+A/sXuF8aA/usAYAoTP5qq+NjUp6LySzBUD/J
	gIFqpKR7rcsOLGNaffC54zLDMpEeOmopmfEakdwptqNCekQesFYjkU0WqdK1Eqli75Kk7A
	KuuAlWrAdqmltzwkcuaM0Rd7tceDhqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FA3760142;
	Wed, 21 Oct 2026 13:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5051F000C6;
	Wed, 21 Oct 2026 13:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792590099;
	bh=lTFhtZqgicHqPLQLHq7f0+ApWdYensFNsFbqs8ibbZ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aIPX+SlG7yHmfF6l9Vgd8xZG0tgIQpxmgyph8tOgd8j+PPYZNdq1QjbE37zVFdcmO
	 ztUF/I0qJQnq0n634ioclSbE1tc5KFfKuv1GVcF8TL7NDRewd7OAtuJsOr9zX5rd53
	 7/DN9LPcwLgXw/lt/s6+hBabQpIgAG9a6nljg6UJaq8RegqQ4UZi4SEZrZbkdBnXeH
	 xpVswCNUD9WTtU0jL9qSHqTZ8IMxYBRhwqOdD8IPNe3g7DtkkYAEJ+HXeYqRR5xtqX
	 UEA3BTPnzlXGgZ6JmozO4UHtfUj7YbolwGEqOoebfYjmapFDqlCd4yxcysw3TuXF1F
	 NVJ9/mpUwJxyw==
Date: Wed, 21 Oct 2026 08:41:38 -0500
From: Rob Herring <robh@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
	Wandun <chenwandun1@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 0/2] of: reserved_mem: use dynamically allocated
 reserved_mem array
Message-ID: <20261021134138.GC3667411-robh@kernel.org>
References: <CGME20261015082333eucas1p28bad74cde14ee0afac2eea11bbe6696c@eucas1p2.samsung.com>
 <20261015082315.56876-1-m.szyprowski@samsung.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015082315.56876-1-m.szyprowski@samsung.com>
X-Stat-Signature: josmqwbwexk6ae9noj66x3sqk7dnzdot
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3640240003
X-Rspam-User: 
X-HE-Tag: 1792590100-505360
X-HE-Meta: U2FsdGVkX19AC7AhjI3IeI53OVNqUe4/V4QTLbARvxZFRwE+YxaozPLrPdRJ1/9E4ZRY824veuIbIw22t5gPjBXUlqXg38ggpa9vgrDCA04rO3BDRpUqAt/o9lN+C/rxuUc0U4DksHjjIQuDa3Fw3spo2f2rzgVYrswpqsGNztsQW8IZxNY4+R9tT5xlmIuEcEyRx8rGy7HMHboPe7ob01hz8BbVAdBDBDLKw8sHZgNYXwwzCdym3mM6asbfk39TRLAo14sG/eUP8hoLzdZaOv1OVAJG1fzKZqYA9GNj7SV4LSRK6Jvzhwax6dEXXbYcMdqRp+JS0fsZyqwdgOyqGE0xhqfCbIkEWA3etlWIDzmpHMZy0QThdXBOcqC4ilixxxCxXf6flKW9q/z2O722s3Ias/Lhk8E8KB8cKE9IFMs44g+7oejNvv09kANxPQjcpnPuVdluH9yQGQ6b9hTpH6dgoZS93Mimic5aeu3cjg6KcHGAAW++uZQBwBRPvSfNDAKPZqcBYP3vpUS1QjVv35KTkenQuXFVM10UBtMyMLDiC7ANyrdT6mlYg3RoQ7NKJWzoGHNzG/1L3IX+WgKTTj/OPr+e0iQFyptyLrCalkBfDcIJGIcBrTBgHQOtzEBLHGODvAu18q63vZME+SZjELFU7ZQ9GP/7tP0rqYOsfoQq6UFsy8uXPTrGumFCpIDXbRcZ19kR3lSGsmPpoADt1G+0EMFbmZGGvCR/Rgru+5yo5IKYxJGoXWNKg704cFvV9TZDtLrCbQP69SP8VdPJFlHPkoFUekfGb4z6L/P3v9qqap5mVgTY9AOCVSG7gqVsS0tF8K1QNraVnU5UzRyWY3VEcuhTt/Psq8nGrnsjKRjqsVWEGtlzAvR002oY2VrNs+l3hUzcMGNUl+4kzIvIgXzdUrpzbd2YclEf7RqTyvJh+ll+q0YPoyjrN0RuVQv37R30iNVc39OMQSLhv6k
 resUJ3Wd
 3Yom5XnATJsFU8WztpjgdDaUaHvlBziQcknwI+K5AAOY3PdXCHV7JIW2DRXkC1+11rtArTNZqnz1yfyv0vuTfttd/zRDg+9dTas3IhkF/x6OybeckwdwRwY7ry8PWacTuwYUvtIoNVvgAwtdsJfmc45uMOJw/1DUN2OQmUa7PcUrcM5SX3LvUk6duQaXztC96uwDjXiaKwc2HX+GoN/nW1V7tES24LJLsolVuxb4B3AbGnEl+0J9DYtcCSmdfW13SqntW7wI8Qkej/CtpC17Nb7rfQBwOaFfg56Un3FOO2o/ql4ajxWezw18kxlV6AgnQ8eE00mIdQR4AiAjpyuTt2hmKHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 15, 2026 at 10:23:10AM +0200, Marek Szyprowski wrote:
> Mike Rapoport suggested [1] how to properly use dynamically allocated
> arrays during early boot.
> 
> Use this approach for reserved_mem array during early scan of the
> reserved regions. Having all the reserved regions in a single array
> removes the need of the two pass initialization introduced by commit
> 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory
> regions are processed"), so implement it to make the code simpler,
> easier to understand and ready for adding proper error checking.
> 
> Tested on ARM32, ARM64 and RiscV64 based boards. Arch specific issues
> with early mappings were discovered by LLM.
> 
> [1] https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/
> 
> 
> Best regards
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
> 
> 
> Changelog:
> 
> v3:
> - allocate the reserved_mem array only after all static regions are
>   reserved or marked as no-map, so it cannot be placed inside any of
>   them
> - record failures of the early static reservations and print a single
>   message asking to fix the device-tree
> - restore conditional compilation of the early mapping code, because
>   some architectures lack support for it (C-SKY & Sparc64 as reported
>   by kbuild robot)
> - allocate the array bottom-up, to avoid allocating from highmem, what
>   might be an issue on Xtensa, C-SKY and MIPS32
> - don't use the early mapping on PPC64, where the scan is done before
>   early_ioremap_setup()
> 
> v2: https://lore.kernel.org/all/20261008152403.766439-1-m.szyprowski@samsung.com/
> - removed superfluous ifdefs
> 
> v1: https://lore.kernel.org/all/20261008094125.3197971-1-m.szyprowski@samsung.com/
> - initial version
> 
> 
> Patch summary:
> 
> Marek Szyprowski (2):
>   of: reserved_mem: group allocation helpers together
>   of: reserved_mem: allocate and map the reserved_mem array early

Can you confirm the sashiko issues are not issues?

I'll apply this after rc1. Are you willing to be added as reviewer or 
maintainer for this code? I'd prefer not to have another entry just for 
the reserved mem code, so you'd have to filter out the rest of the DT 
code (not the bindings and dts firehose) which isn't too much.

Rob

