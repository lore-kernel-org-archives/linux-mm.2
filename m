Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2B11CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0912A6B008C; Fri,  2 Oct 2026 15:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041166B0092; Fri,  2 Oct 2026 15:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E724B6B0093; Fri,  2 Oct 2026 15:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C03706B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:15:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5CFE9C086C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:15:29 +0000 (UTC)
X-FDA: 85278639978.25.AFFB29B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8C341180004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:15:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+zS7V+N;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790968527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RAXYnozfOjCNJd3fS51e4tA12PwRRvWlhRu6gPGg5pY=;
	b=nnoa3isN8byTnQASeke0wEbzXHlaVuaHv/Gin4Chcgrz3UvFvdLxzffB7pGEwolaQMSIhV
	4W6zdO1QaPZ+FmIjRxk9hedUOWCruxRi7xO5QB6G6J73kTIIgwgRBMqMj05VX3IQXbi8I5
	WtC/NCN5IPi0jSmhh/b02W2YNOU5bwc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+zS7V+N;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790968527;
	b=rQXlFr+2u9I2K2A6ZqvKhaVB1M1BgmcVyksAq36ea3ZPPT0cX5JTZks/WoEz951IkhdClR
	gQMHl6rNcnrzME3qKshOCUE3J2W8SdzsOZU7eSE4bXwb5Bsi2lxBxeNsVghpvoSDExrCbk
	w25RfG0AhfzuzfWYl1QK62Ids8uSPi0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B371B43AC1;
	Fri,  2 Oct 2026 19:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B101F00893;
	Fri,  2 Oct 2026 19:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790968526;
	bh=RAXYnozfOjCNJd3fS51e4tA12PwRRvWlhRu6gPGg5pY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i+zS7V+NWrt9FcmmtNbilvGk8AMgrsDPvEmr8qyID+GbT+wn8dKLGm16QlZPm1pQD
	 CKW8GGJzBm926RYbyIJNe8AoOjuVfbkfEPlD7A/NEc6FSqj7IU9vHV3ok3gxgU0c1u
	 pIjm42i8CB4j1ze7Zo0RVVBKXLazV/rV9e5a3W1WUHWJYbHRGQkVyvW4vD0TEN7BjO
	 Fn6wXKf4VNKhqvSv4lCS3zpywrOK3PZBrEAwSx8fuYfMnH06VEUVr0nWbdab+p8Z/0
	 +gG5thxvIRcSkF432btKAabqBmB8URlAqma9xQ/lsXRq52b4ty9B4wJsNIkDg/V1cs
	 yXCcpJ8YSxAFg==
Message-ID: <388b396c-2dca-492d-8873-c9c672ac30f2@kernel.org>
Date: Fri, 2 Oct 2026 21:15:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/14] drivers: dax: use pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <700b622814a2b294083f9066631f655cf61c3070.1789695931.git.luizcap@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <700b622814a2b294083f9066631f655cf61c3070.1789695931.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C341180004
X-Rspam-User: 
X-Stat-Signature: 57mxxot46sb3jxatoedxnbw1cuzti3rg
X-HE-Tag: 1790968527-12566
X-HE-Meta: U2FsdGVkX19dl9h1QylE0tJ7kro2f0L+8FoCXeG1B1E6cJ6HN7FQZ4GRvcdbVwFzUUYC+DwFHKQGBIGTaI8Xv75VIXIC4C7JOhDnlxbjTqqK84W+s93Zkf/tcWptN7jq24e+QJisERvsSfXW8XMSEszheTQHboghRFqOwQAzaDfZS9CP/OxA+IlUKqajyeQ49vut+QyCY0ZRVbJaBRPa+lmj0SFfO8wfClL+kCaJ3dgmTysXZ038xoWJOrmZB/MF1PeWyC0DPgi+8Vx2RVhUDj6PtMhVxzboxN+eUXmGAC2u4mnsnukPm+pPbZbtkxMVQo8AuWGgZcbsRoL395wNxTc7RP9UuRvzhNKw/DU8lWgy+6DDNO/20dXDVcxkSaxkWl0DYITU17llQEtYmyDCZvANXkSv4mtGH9izetZgcKF3QVc4OO/eBo5Z/XjqB8VV6GbobibxwaVa0lPyarQ8Iij+4ngVtTKr7UjFs3Y/IEdiI84vy0F4tGUsf9DXjU1aTGDZ918JCOBEX6ZGWjlI1LEh4VcSq+RsGLchIklMGlFrOKceYt2d4+J569JfjXOSeicaiEJCKoxIG1hhFoarKP9w9/akL+M0mZTfYA+h6EvNEMfRCvMXo3rT2NIpr3+NbCngVOpNmK/y6jiYKABkO0pp0rq03TzVq5RYD6301ZV05xCJ+dXe/vLTsv12VtxsnWlhjGrLyzxMyQDRE0+QgJY2trQz5SqfgF/+/8o66XaHLTMkZrjudGASyzjd6N1WltwHKfN+f3ZcE33BH2E98hPG2A+flIpEjEZFnmMYI547iizBQV2jKLucsY/t6NhufKBCLy5ZzUe7/L+GksCSYv/lagmTY6PVklX05nRx2qeTVEh8pN+TMtV2N6VLOgAujOWnarwRF27p49+iaa/eMz1BAO6eX2QXi3YXMg+8cTtCghreHeeNnZGKnpIxo19B4bt2QiHqlDcqusfRBsx
 vFKvrBAM
 sS3lf52Dh2ewjDathN4IFOrIHcP4XE9aCz+sW4/MumXD0zVQ9SgU6qsmVDv0ds7x8tqlaCvs5VoZXWdhruoLe9fCI8U/6zf6pIULStZVK3SG0lTiQXWdncAJVPS9J83B4DSZiFQfR95/rgbO31i+nXD7VXZ1B6DAJnV/sTFTUm2RKDbKnM1rlTD8AZdJth1ESgy7A+6+ngIn5g+wVDAdr9jIzIjlzk1NNltxH5gkmNdZgm6pRyKPu3KFjJlgrH6gWNLpOsq6S0AJC35QuFQmBfh/XJdxngyFjlc2X/LSJAaeAIQwyjulthcSHNg3ZiKKnRQjLu8I0GZ7r0IS+LOT/8VIvwYjwtwSMgXj1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 03:45, Luiz Capitulino wrote:
> dax_align_valid() uses has_transparent_hugepage() to check if PMD-sized
> pages are supported, use pgtable_has_pmd_leaves() instead.
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  drivers/dax/dax-private.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
> index 607a53a91f58..18a6295aa766 100644
> --- a/drivers/dax/dax-private.h
> +++ b/drivers/dax/dax-private.h
> @@ -121,7 +121,7 @@ static inline bool dax_align_valid(unsigned long align)
>  {
>  	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
>  		return true;
> -	if (align == PMD_SIZE && has_transparent_hugepage())
> +	if (align == PMD_SIZE && pgtable_has_pmd_leaves())
>  		return true;
>  	if (align == PAGE_SIZE)
>  		return true;

The main part why we don't see any change is that dax_align_valid() is wrapped
in the #ifdef CONFIG_TRANSPARENT_HUGEPAGE today.

Might we worth spelling that out in the patch description.

-- 
Cheers,

David

