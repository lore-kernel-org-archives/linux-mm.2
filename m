Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BCECCD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35036B0088; Wed,  3 Jun 2026 06:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5A16B008C; Wed,  3 Jun 2026 06:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22E46B0092; Wed,  3 Jun 2026 06:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C34C86B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:01:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E5BE8D0B8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:01:27 +0000 (UTC)
X-FDA: 84838159014.28.3D16380
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id BEAD28000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:01:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyifO2RL;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780480885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1CTZ7oc5S2yw/byDNkdoYymx9kciSIu5go090hsMMI=;
	b=LWUwJHdA0pyqlQItgQkvkVICzjOLHu5z+3xGczlCaBf4edD8QBX1p7I1QiVguY46zC1pcC
	wyj2zXy5+o7CzRYM+xeoN8+C5y9F57nTbWEfCmcDQ2UTkHlC8BUj3L9qlWFAyXFPJKX2pu
	eAyOe/3Q0HbqXaC5wa74JtWbIOR7M2s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780480885;
	b=Xs1EaCXo/GQIb66IasDEA8IyGsng4tNKlZ9/lRpOohFNBipkLiHEFrctLN6hE/lCK89rS0
	7Y89abenSIH8ayAH6FfRKlDVjk+cUGUKD0jTs5xdSzVf1lWrT4fDiZv6SZzSEMFha5DacW
	/Bx3tuqhtRTD1Ks1KBSKiN2Gd4cKBvg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyifO2RL;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB118408CA;
	Wed,  3 Jun 2026 10:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4731F00898;
	Wed,  3 Jun 2026 10:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780480884;
	bh=u1CTZ7oc5S2yw/byDNkdoYymx9kciSIu5go090hsMMI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=SyifO2RLgJot/0nMvhvebvZ/j/IRFCanYUIghVG+LecIPnvv31bTofLbYJCdFR5jR
	 eHUL1BEW1bYQYByZpVEHqkS/Nf7pH2oFgN1tnCQhh5NztHp6xik7J33WIaVohaLpZQ
	 e2D0siiXHg0zYu7oYW/3nCF23tX2dexeV1fmEbT4TGYJeMB04JBodaLk4UZrzyfChY
	 +c1D0j+wr6/L5xTUEKa5BwPmBI65fQiwTvy4YCMHynUuGLLrkMhyVSFK1Zq6LDhx3b
	 EVJpVA3U8rY3NM3t4yrMdWg4Yh2Ivu7Dh9PEMjVNfnGDdYoZZNo7GOF0JB+uSKXMKA
	 4ZIDapTzVijkQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 3/5] tools/lib/mm: move hugepage_settings out of
 selftests
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Mark Brown <broonie@kernel.org>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260527142432.230127-4-sarthak.sharma@arm.com>
References: <20260527142432.230127-1-sarthak.sharma@arm.com>
 <20260527142432.230127-4-sarthak.sharma@arm.com>
Date: Wed, 03 Jun 2026 13:01:08 +0300
Message-Id: <178048086822.472368.16880248677532938003.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BEAD28000A
X-Stat-Signature: dnhz5z34pcw4dwbxfnrxy3wb9yxzqd1g
X-HE-Tag: 1780480885-607478
X-HE-Meta: U2FsdGVkX1/5YypjC9JwOTxcW8lkUyd8FJdwpeMTYpNByR3XVDqCXLpbQ3KRGdG3JbxMcz/rOrcnD+G+Cmnj6rzFVL8L01ax1m84OAzBhl+mk/I2T/M8o2JcnNa7ahGhtXfNYLOXCAJy7jKj1OHBRY/V58U0w/XpqLG+bLDx0CFj+oX7GDGqQpOdWuliqCtNhQlP84PW1c4sqkoKdy2lqbR6wpkLqWiVPP+0Gyq21lSY3wSQq7kfSaKELVtToY3dIkh9o5K9SmdIINLQ8jute3e81BS4ePY2tthJwC3jpzJ65LtL/Hd1if76p9ggy8qidC/aZQr1wCJZC1viRxfsP5lmgyfG+pReoX0uIWz2nYV+N03NnhAaLITvp6mXC7rRZ9WjeK8ox1lhjvTWjrjKRQnVLU6xQBSTpy5FIgc7sCJUwp6Cm8ezvBNpa9o7MkAJWDK7RbEwdZ7+dCtFiyw45nWmq02sqXMicErZfdN6ydp4r0tkMpwOg9pPF6RODXfDaTVfCkzmDEhTPYXryD7H9kjK75jPZrUdhQcnfZJl07R/AZ7CRNFhPulVIZlYGLf1oZR/6ZQV5L3BN32IOqmgriY3mRkuRhMIElVPA+GyX3K0+bk+l4x0iaLdH6ZJE+S/nyXX7jvlxxDczqT/4+wNObpE33OXwFHaDsziPFsUvkRsZ9O1G2VhGwd5LUMUczDHsnNzW90yy/FhhDxooWX37FsD32iGGcAbQa4sd3n72FvRZZXs5Zcsj0Fn24s0I88sUxhEsRhnHw5JrUjn3gKFvNt5M3CcagTHhkW3FoBq89UalbisVHaw2t9PGWYywfMlvd8YPCF+/poSq0reZEMkgImoXJ0ksFBJMnmLd5TzSLoAkib0dWtv0WMobEw2kBtnpThlPAyeXeYHaALHyzordoHOqSdFguSpl81QjtJtZOAmrWAb0dLONr6ar7GdWzRkHPs71wudj0mx9Sb2Sl/
 tXcMIyt7
 hsWq3/w2zwrxhTbjHG+tG2DPU5+IZfIUZTpRfXBKeRZnWnrrTzFSUePp9RnvsWJcdBNkG/CKxPSu4z+1EcGHnQMcSslJoL2Ueb6owEo1j7xWJ/HAodrgvYS8DXD0P52H2cfkDVzYDRcffPHy5Kgu+MPm15L9fXupHkOusHIVvlgHkZgYSq4W/fVEu100S/Kk/lB85gwCL7hTzpvvKhSiTqkxL8XXRMEBEUSyN5h09kt3UKFHY22S2dfaIYGndyVT+isDPjJLaW4GDoNk6dmTb2oz93RdynLv2memCzQCF041TQhgQjlAtJLCXu1V5AeMNLtjd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 19:54:30 +0530, Sarthak Sharma <sarthak.sharma@arm.com> wrote:

Hi Sarthak,

>
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/lib/mm/hugepage_settings.c
> similarity index 97%
> rename from tools/testing/selftests/mm/hugepage_settings.c
> rename to tools/lib/mm/hugepage_settings.c
> index c2f97fe97e58..c75b9c8f4a74 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/lib/mm/hugepage_settings.c
> @@ -419,8 +424,8 @@ int detect_hugetlb_page_sizes(unsigned long sizes[], int max)
>  		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
>  			continue;
>  		sizes[count++] = kb * 1024;
> -		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
> -			       kb);
> +		fprintf(stderr, "# [INFO] detected hugetlb page size: %zu KiB\n",
> +			kb);

ksft_print_msg() prints to stdout, let's keep it for now.

-- 
Sincerely yours,
Mike.


