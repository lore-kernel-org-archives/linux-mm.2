Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94EB3CD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 18:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B62F86B0088; Wed,  6 May 2026 14:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3ACE6B008A; Wed,  6 May 2026 14:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A510E6B008C; Wed,  6 May 2026 14:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6E26B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:13:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E10121402F3
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:12:59 +0000 (UTC)
X-FDA: 84737791278.24.9D2BECC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 773CF160003
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:12:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VGbCQhgf;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778091177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bqKNq3m1Md+hrBs+SSGkueZdf4I+Fy2SNIbnUQ7AlE=;
	b=JEfRpcbTzIoysFA5VZuDUOZiHuZnXfZRyGjUns/oBmws1Ni6F97BlSg2idLmxXqQ+FxOTP
	C3UisA+oP4MIcFKuvGYHC+y+LMJ1t0dDzT1G8YLGlW3Jy4rzHi1VDoCKBmDUAfzVDXkWaa
	cMdXqmDLYnV12+v0XrutFiz+Pz3ewR4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VGbCQhgf;
	spf=pass (imf08.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778091177; a=rsa-sha256;
	cv=none;
	b=lzXLBwPb7Yq8pvtU+Vc+Vgt+zwF8cV5pNJ2vJ2kI7rPmMqDpctoCwOrm4vk/AfE7yUSPb0
	OSuDsjeRzrkW/MgVvaXOLPxflbnLPklmrYOfiFaY9IKpGxK4RK4zl7tm0w/5G17Mj3ca9B
	F+ztQU8OsHAf7JGdSDszACgENjr6yWs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778091176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9bqKNq3m1Md+hrBs+SSGkueZdf4I+Fy2SNIbnUQ7AlE=;
	b=VGbCQhgfSX0TX46jIQYm3XrO3IbOf0ZpG5he0MZ65OsdpjtvtLzNpsXhDpSDa/8OJE/n9m
	39DHsvwR8JtYv/mW/h8NaS8D8stD7NLgGC08o/Ss5Gz4++JU1Sp/YU1uQ5OLH1agxesfe8
	972PtZQvIBIQB0BvZJNIBlDVu4KO/js=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-tsUD0I0jMtGuL3c2bN5f7A-1; Wed, 06 May 2026 14:12:53 -0400
X-MC-Unique: tsUD0I0jMtGuL3c2bN5f7A-1
X-Mimecast-MFC-AGG-ID: tsUD0I0jMtGuL3c2bN5f7A_1778091173
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8b5f089a5c3so150494526d6.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 11:12:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778091173; x=1778695973;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9bqKNq3m1Md+hrBs+SSGkueZdf4I+Fy2SNIbnUQ7AlE=;
        b=ewyipyxxISuuryib/MgWqaqVk/5HWt0hZT5Pb31gWCPn0/V5ckZZXaUFqRpWtSUJiZ
         tKXkLPWG9aYCirwQiljRc7qM7TL5+bsYDBIoOiKy0zUo/wqlR7HhuCSyhWSxdqyu8YdB
         zR7l3DaRosiK6NzT+vVWYrpPYKdX+45Wwn/UpiHm6uGI98EJw9FHEW2r6wNZKDVZvOet
         BrzDFoLBlliuklYCttYEuSonZ7iL4x6TvqscWiaE6kxGzAFAjd727LEblaNiAgcIKHny
         yeD7iqekiDo2KFzauABWPn1Xnf662QYFBxj7oR1SB6ke+CwkvMW2VLmtyT3aJWFqlG5j
         CMgg==
X-Forwarded-Encrypted: i=1; AFNElJ/foMRNCwCHtuaXDUyh8fXAuA+C4tykmREpi/EaY+HGbFHxpsheOllRVoBmRfPGbgC5elo/FIUPzA==@kvack.org
X-Gm-Message-State: AOJu0YzTudeGKz4gV3BLueShegyiZeORGV67F2naZhJqgSXngyThyDXu
	k1Kh5QSTV8/A+HK/3Nmw81xN8CCBWwYheKkSIHxdbg+CBY9e093KyELXP/R5P6CFCT43ASTtlBT
	IM3+HmctPN3pCcZG1xq0C7S3455EZRuOOfrCa2KghvLP7ESuJrgvn
X-Gm-Gg: AeBDievzrQr7UVwZL4VZQ5P9gWOfT1XBc8B/Jvs889I47mH9y1k5UKeHbwl0XII3qF/
	6kixzc366d7yfBPBPWUS4zVAZ9iueWL3vhZhqIxOYzcXTjbbQyzjMh9NvFPVA1m1gcVth7R9WrI
	RifP8DuQzUoIqj9PwXx0xsDeWYus6BB6Xh3Bpmi/8OziAlibCJxf0EVyZbvEgChA32wN/gKVYxG
	xBKgcDSVDvk2KgceqlUAp715eFIo9EF2d4VhyP91cdNExtjdRU293TzD1iDJOcCFxOMdas6AUEx
	MVUFoDlnkLlTqWWDrIqB2fbuw8nrLk56d/SBSQJAYuO569+sYy4C5UA8socrktwbppuQlSRe06/
	B35R/VPFe6KYjBIZp6uCO88UxRPz+VZgVRQkYyiQfuIckjFJ9+ewWN9AekwSBA2baXAG7EIplBz
	YyGaeW0d7l+FW+TrWyMzXbJ0L6oDR24HdKQg==
X-Received: by 2002:a05:6214:5908:b0:8ac:b48f:9fa4 with SMTP id 6a1803df08f44-8bc447bcbf9mr68588676d6.35.1778091172758;
        Wed, 06 May 2026 11:12:52 -0700 (PDT)
X-Received: by 2002:a05:6214:5908:b0:8ac:b48f:9fa4 with SMTP id 6a1803df08f44-8bc447bcbf9mr68587306d6.35.1778091171770;
        Wed, 06 May 2026 11:12:51 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b53ca982a1sm207894306d6.38.2026.05.06.11.12.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 11:12:51 -0700 (PDT)
Message-ID: <ed33dc0f-fcde-42b3-90aa-c20290b06f49@redhat.com>
Date: Wed, 6 May 2026 14:12:41 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: (sashiko review) Re: [PATCH v4 6/9] mm: shmem: drop
 has_transparent_hugepage() usage
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <d2d1d0deaa5732d82bc2daea5033a1578781d641.1777663129.git.luizcap@redhat.com>
In-Reply-To: <d2d1d0deaa5732d82bc2daea5033a1578781d641.1777663129.git.luizcap@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pfKYZY6Ul1qbcZmZEUfsi_ZW9nR6no4HbrNPRXHHtDI_1778091173
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z5n55exqghir89b3scypwsip8gzqr9oz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 773CF160003
X-Rspam-User: 
X-HE-Tag: 1778091177-428918
X-HE-Meta: U2FsdGVkX19O6AeUktrVNcvIyx4ac/B4wO/FqQbF5Mzs57ZOw3WvoToDX48q6afrrPHD1+XGbf4Eu8WVix/gAc4rHsiuv97xKQwh4MZ8rqOQJ1TEX8qgwrTZFr053JkHvWuM8gbnEcr+V+patthm5UXRl7qE65qXDWbFegMuYtlaTzN9GsVy/ckpIBYy1Qzm5TctUSQdOYdeneyMoAyLCBvGctJfqoo4BYna4PQs33b2n1y9LzJu/BhF3ixZ2IFa03TC+3HEhkdkH0bC7YQJR22m/bTZXy3CpgxAUmfnS6dX0t4zuh82vsejPz5qD6x8BZdij++JieTMnqsb0lcWdSzTpNIvaEwakrebgGepwo9UqzHa4SYylOEuBiohOHpDod4zuGsae6EoQ9yHc+pgIvVKA8V4RVFNIHR4HCPI+MMDbVYMa78+5x7yPwdwF8S/+qJ7azp6X+yGqwJqxxnh/wQFu19vwq0+bQy1LhL7yGuLOGCnx61nV9j7/jzOXyOUacoF4IOOnQSvr1VJ0UNjvCt4luW+vtpVWfGLyZbuaQuNDSNDTx8KdF0RLw+7QSgkD0Yxugk+lSukQSRWeDXrPOfM1BKCd+XKP6QxAU6QlUAOyy7pvppSWexEZ31ANACwEb4oQAo+ELCnrRWaLDTBtxzG+a6BsBbWz88aG3sRZE3/8SsInO1WO3bnUZT6RqDwVTxESaTNlZmY5WtilXlRKDb5Yw2UaNSPzHiElaDa3qjwEFlhff0+1LZpKMeeBdaAI66eTz6ZZOrDo3raRkUMyYtneFqMgKKyj2OvMOUr54TvCR/IyDFpfdeHNSHOKqtRZ4SIIXUpKg70RxU6dSwpLEJu9vwBcBNvfvY2RtJ5Q4R5+MTbE/pS3r69zQEdtVoloDT90tAzhd5lKl+1x+HYBwrkYvxo7NSDLxpzvpp37+GYgvqFr/dmkMGKtEHQfF6/udorHi6yp7tdS0XOt0x
 jzLIWnKF
 9QB+vxtFlyb6uNVs62razfM7AF/hPTwbj8xMi9Dyzdsg4iXxUZtVIzvF1XZOofFyRZKFQYlataOwk6X5kiZQFa8dTHvpz4WSIdYl5oKFx4eMcqTvJ4gRzOlF69eXIjkhO9JvAje+uOh4YrMVj0fX2pp5BPkZk8LeGLgeiBIXBugZTwyJ4a8o/ZxQBH4LnkRgUhvlJR5CHAS8YySDsIfS3AVUz1ZrhzOyCBElJwuKuFXEDtlZTRvNsQtH0eu20JAd0r0AjJVuAKHdib+FU9OVihmlk1bDZCOakMRWS3QhM0o8O7xLhiRC8ayYx5zEnf/JO4uM38NZHvixaLLLVZSoqb/kbXmmJp2sD/ocoAoHWiu5ikLTyriAapqdoWoW30F0HrIYtWkIk/CVAuNvNcQxRSdazdr4D7eM+5uFhBn1U5K58jYCTAF1mBHxzbAOMz4FpCsq3opl7gvlkNU8TKRNdVL2ltzdOWte7u4/mMO9HelyE15gq/nSHqKZoA0EzUg34YWtaCCOGYrgK20y3+avb4mNWZIL5u241a9aWw4bxDG+Q9CY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-01 15:18, Luiz Capitulino wrote:
> Shmem uses has_transparent_hugepage() in the following ways:
> 
> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>    if the CPU supports PMD-sized pages
> 
> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>    the code block calling has_transparent_hugepage(), the
>    has_transparent_hugepage() call is exclusively checking if the CPU
>    supports PMD-sized pages
> 
> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
> in all cases, shmem can determine mTHP size support at folio allocation
> time. Therefore, drop has_transparent_hugepage() usage while keeping the
> CONFIG_TRANSPARENT_HUGEPAGE checks.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   mm/shmem.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 3b5dc21b323c..1948d73fb1e3 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
>   	else
>   		return -EINVAL;
>   
> -	if (!has_transparent_hugepage() &&
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>   	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>   		return -EINVAL;
>   
> @@ -4656,8 +4656,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
>   	case Opt_huge:
>   		ctx->huge = result.uint_32;
>   		if (ctx->huge != SHMEM_HUGE_NEVER &&
> -		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> -		      has_transparent_hugepage()))
> +		    !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>   			goto unsupported_parameter;
>   		ctx->seen |= SHMEM_SEEN_HUGE;
>   		break;

"""
By dropping the has_transparent_hugepage() check, will mount -t tmpfs
-o huge=always now succeed on hardware lacking PMD support?

If so, since hugepage_init() still sets the TRANSPARENT_HUGEPAGE_UNSUPPORTED
flag, thp_disabled_by_hw() will unconditionally block all large folio
allocations in shmem_allowable_huge_orders().

Does this create an intermediate state where the mount silently succeeds
but no huge pages of any size can actually be allocated?

I see this is resolved later in the series by commit cd27430097e8
("mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()") and
commit 641a20ae032f ("mm: thp: always enable mTHP support").
"""

The mount -t tmpfs -o huge=always succeeding on hardware without PMD
support can happen in this patch, yes. But this seems very minor, the
impact seems to be someone doing bisection, landing on this patch and
their reproducer is depedent on mounting tmpfs with -o huge=always on
hardware without PMD size support? I can fix it if others feel strong
about this.

> @@ -5449,7 +5448,7 @@ void __init shmem_init(void)
>   #endif
>   
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
> +	if (shmem_huge > SHMEM_HUGE_DENY)
>   		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
>   	else
>   		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */

"""
Also, by allowing shmem_huge to be set to SHMEM_HUGE_ALWAYS on systems
without PMD support, does this incorrectly affect shmem_getattr()?

shmem_getattr() relies on shmem_huge_global_enabled(), which only checks
the software configuration and not hardware PMD support. Consequently,
shmem_getattr() will erroneously report stat->blksize = HPAGE_PMD_SIZE
to userspace.

Since subsequent patches in the series do not appear to update
shmem_getattr(), could this misleading block size cause userspace tools
to over-allocate IO buffers on hardware where PMD-sized pages are
structurally impossible?
"""

This a real issue (albeit small one), the problem is this check in
shmem_getattr():

	if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
		stat->blksize = HPAGE_PMD_SIZE;

So, we may report HPAGE_PMD_SIZE even when PMD size is not supported.
Looks like we may over-report today as well for the
SHMEM_HUGE_WITHIN_SIZE case? In any case, I'll fix this.


