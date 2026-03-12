Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F8F106ACE3
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15BC06B00A3; Thu, 12 Mar 2026 15:54:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A126B00A5; Thu, 12 Mar 2026 15:54:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9006B00A6; Thu, 12 Mar 2026 15:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCC786B00A3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:54:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E16F8B831
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:54:03 +0000 (UTC)
X-FDA: 84538461966.28.C210DE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B275980015
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:54:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eiJpXBPD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773345241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEkkZv79jB1u3/uzzWu+eWBtRq2Fy92t4yG0YoYEj6A=;
	b=G7r2twkmI35Wy+8Hvo6mD9D3VD1gPXRwTpRHrcm0nZue7jVQA127MmKBUk/JoYNgSJ4POE
	ai36ckEktBuSJ+z8HSaA8deMZzoJ+ArEVEBT1/8fd9m0D2+YXUNK//u4vd8VT9vCm3se8p
	+iMF3+jlw5zJdlRSsAg5ucJMzhR8GFY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eiJpXBPD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773345241; a=rsa-sha256;
	cv=none;
	b=TeU5V+4mGC7ZkcRs9gc4HmtkxQWjE1ixycEeGdiqtejxQeDwxFaNPgVQ+WMB+1faQ3EY7l
	QM17YXvWChCLm0LsovWsFdefko7oCmcAgLwkaB3lmdWsWJQjOk4bxWj5x6pYFX7jJpArMG
	tXIYSBpnDIxlgSp2MjylurcLhC9e8gU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DD7960054;
	Thu, 12 Mar 2026 19:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EF8C2BC86;
	Thu, 12 Mar 2026 19:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773345240;
	bh=SbsndnuF0EiVpDNyBSiEFCrM0e8c8nQnCjz1qAUHPcI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eiJpXBPDrRIIs9Lzx0RgbMPTUzs2HWG8qWkamTZzP0USBdFToQVuo6bKmnBmjipoN
	 onQAAPIVhb2m84hHt56opum474gdHZ2tO4XzRP8hw8XDSaf6L0dZIRlcFuiMOCwZ9p
	 r/w9cb6Yrcn1c5fNQO4ubPQkFcjigUWI1x3Bzp16y4v4mjyc9lCegDsaIAhhwAl6Kq
	 ldySkfEjvMldXBdfBbaxAhc4yaQDBKFGGerXDe0nbfDZvLLenUuSDEjT1XeJqnOpgs
	 +pdpPQobY5Ebk9Pv+hfFcd+WGVBAdGUlqO5eNH0GU5oFgu0xfgp5BKkBJAmZD3Tx6M
	 R+Asn75JvTbyg==
Message-ID: <231fd45e-3c0a-4c9f-917d-255d03fed6f2@kernel.org>
Date: Thu, 12 Mar 2026 20:53:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/11] mm: Relocate the page table ceiling and floor
 definitions
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
 Matthew Wilcox <willy@infradead.org>, SeongJae Park <sj@kernel.org>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
 <20260121164946.2093480-2-Liam.Howlett@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260121164946.2093480-2-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B275980015
X-Stat-Signature: juq1ubfraon5za1t6e85n3safgrcw35q
X-Rspam-User: 
X-HE-Tag: 1773345241-129091
X-HE-Meta: U2FsdGVkX1+/74DDcIKvOHlresTxqCE4A5A2Vnb3wtjEnkcQUUkVmDAcp5D4B9hSzDPGHBuz8qmh9mg3HOXrbM6oxoNvy/riNO8EWJZs1YSbi1DFuOoJNVBrhDymelmFtUypZN3MdRYDFhwVFy+5k9sIKeUm/JYxlUnoj4WzjS6e5HsRx/wHwd6yAeDZ7Tg7/v+HrmxPwi0+HoQU5FGxrr9KMcAfKYs1aVqJEmA2pa8e0v4w5trffg7LO/mC7ANDVqQlAFr08LLl2J7QK0CxTH806fFc0gBTfhHZ9PjBU9ao8VZ+nOUmB8Q1nfm6hhZdp1ltJR+A41si4SJ8KvzWsGqZ27Gd7P7ONMMmiMwArfWgi1lTUzpCKik26UOWo+ikUHVGKfTzuean9eZ1nf/6i8ebWO5X0pXaTtd17FVSGj2Tx75aK43pEMKp3ElLCusU6pODo1myYRCjL8Hsg1i9D68Uat41VdgfXDp8x9VhYMQwDRfim+IdczVcczCOPzASoKi7LbfFPvhdlTWA7I29uSEA67X0QKqPO2KB8kl6XH9h6tqFT/xYO/FhV/MWdSItFWijTKSlA3JmriTnXMu9i7Lna6VBPmFJTU/WqwOis4JQ40S3vQaTIWx1exjzgXpNZ7RQO7mf1Z4aRJ33r55yF4BTEa4rs7R0qRSRhvFG09/qlrz/ctdHd8oOpEumt6ggsVknbVhN4H/+8BTZ0MP8Z9ZGOWqr0zKCHuiapIwqjaV/xh42f0YRnkviyh9YtKuDn6+E9/5mHnLoIV0bFeWbaLp8fsJ5nbtVJdJmbySQrrxHz9oX/IBHTcEJ1POZXQCnae/Qy0+joTN+3X0JvT7LgK/VbGBOi1+fs79TzpIGuYrR5jrut9RsRbRjNWLgN8HP0AjVOaFq/MtFXw01+OMS58snT1T8a6hhsLjFc6JOOVQLV9CRlqTZfe336rGUdvi8ob6nuxWRzxrFbb7FpxW
 d/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/21/26 17:49, Liam R. Howlett wrote:
> pgtables.h defines a fallback for ceiling and floor of the page tables
> within the CONFIG_MMU section.  Moving the definitions to outside the
> CONFIG_MMU Allows for using them in generic code.
> 
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---


[...]

> +
>  /*
>   * No-op macros that just return the current protection value. Defined here
>   * because these macros can be used even if CONFIG_MMU is not defined.
> diff --git a/mm/vma_internal.h b/mm/vma_internal.h
> index 2f05735ff190c..2da6d224c1a85 100644
> --- a/mm/vma_internal.h
> +++ b/mm/vma_internal.h
> @@ -46,6 +46,7 @@
>  #include <linux/swap.h>
>  #include <linux/uprobes.h>
>  #include <linux/userfaultfd_k.h>
> +#include <linux/pgtable.h>
>  
>  #include <asm/current.h>
>  #include <asm/tlb.h>

I was also confused by that change. But it's not worth a respin :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

