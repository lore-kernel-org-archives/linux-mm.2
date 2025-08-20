Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C10CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 17:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC53C8E0016; Wed, 20 Aug 2025 13:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F298E000B; Wed, 20 Aug 2025 13:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64E28E0016; Wed, 20 Aug 2025 13:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEE418E000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:00:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28B4814056A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:00:22 +0000 (UTC)
X-FDA: 83797749084.27.A8EC18E
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5FD9020007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:00:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of cmarinas@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755709220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZbaPWaSJi2QPbnOT0kt9lqiUTEzbMDCslDV8Bb+OvE4=;
	b=lGtlWD6dg/slEbG0c5gBr9+w9txkvuwrifFFUBaoXMhMCGCg3Ei6N8fd1tB0o1iOwfcsZV
	5V2HHt4bn7RIl6CEA4RcqcD6aWHiu2RbGNxbMcUGYvSL1X+mU0mrHEATjlSRz1C3/ItY52
	HXeSLOjYl31Lc1uJbduE1jEwVnWm88k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of cmarinas@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755709220; a=rsa-sha256;
	cv=none;
	b=uuSc81BGdDbTzy1c+FyT6WtO/fX8n4BLrhV0dPuDy/UlBvsNN1DLdJys4bF58hRRDOFAk2
	f4lX9Rd4RgxkLUKWgaofF9pQYnoY6QtVSaZat0PwRQPrCUUEqPEnyGxrA/6vLGWuHFv3jr
	VMEhPje39KT+EpYmOQZPLW/HNbl3/5E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 3AB0A5C6209;
	Wed, 20 Aug 2025 17:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CC4C4CEE7;
	Wed, 20 Aug 2025 17:00:17 +0000 (UTC)
Date: Wed, 20 Aug 2025 18:00:14 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Waiman Long <llong@redhat.com>
Cc: Gu Bowen <gubowen5@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, linux-mm@kvack.org,
	Breno Leitao <leitao@debian.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v4] mm: Fix possible deadlock in kmemleak
Message-ID: <aKX_HvAK6ZopNX35@arm.com>
References: <20250818090945.1003644-1-gubowen5@huawei.com>
 <113a8332-b35c-4d00-b8b1-21c07d133f1f@redhat.com>
 <aKWrSfLD5f1r5rg_@arm.com>
 <fed73718-8001-4db6-af36-86c60e85d224@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fed73718-8001-4db6-af36-86c60e85d224@redhat.com>
X-Stat-Signature: qfdp9y88b3qi3er45n6jc765ci77yrp8
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FD9020007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755709220-362837
X-HE-Meta: U2FsdGVkX1+h3qFASRNak5lsRTouqwr4whiI2WD+RzmkTMk7v10SewukYzB+Qa+HKGym9udUkLwujJ3WoTqOecZbDwpq2faRz/NzAdYlglak5Dyp7bkkF+Gn/CseFYFGcEth4rcMq1GZzhvgZkLLLeF4O7jwB0XNJulVzA2aTkix/7Je7tiX/tzgO6kLZBvmsAxltsn2bmjQ8TOm1BslSLpaCBTQVsAeKGCSLuODTYPh4oL+pJJa6QhEHrqshf9diux4bDchEf83qyW5I21vASMscXlehjYlIQKJNUJMsn/52iDs0q+YoOdICpHbfmjPL6daFVY4eGOS6nGFr3FsBHw4JUR8UhM3fHXC4CCHB7Z49NHUubqos6KubWxofatAByyOAPf3IbEMpVDx3M9drqNV/dnXPpR0BZklOZ3JRbM2CdG0UCy2+KLieum79e71xfE7UDaOaHETvkQz+GFEiiGKNqWktxIgdgT93oH97Noe8qXAl54Rl9prZnggw9Hy8eKHJpb4hpLDmURwBD5rXRCWBP7tEFyLm0cCcx6zAYvULdw8TLFlyjVebwUSnCEosUf7REhwL2/7gr8UjfxrdtivEcivPGKetvCM2GHQSeRQJenvtcDWrM7tdq7dPezh8D9+jM+bzRdc4UunQQBzof4+Vuqt62KvMSUPHvr46ZZtCqpVfmLVMWUmm2h0YcFNumxAIFAnKAVULlG5qCT0IaclsZ+VxqPuVjG3Gh+32kZrgNkTVF45b0iVzP8umPb2unRaSahaJdRk1ShA8FvsQI3C7eEKLBMuHBY2zG4oT0ytgFQBJb7G443mjsRdXj3zo98to9llMwRoHyPpVW2kqzkst9VBazjrSR0+D+zzaIsOlPJkV74jReqhAwCHX/qu0iOC8CFJMuyK9L7qyEiCmGZCFH6n9R5emclNrkHlLBdySwZyz28OsDm+Dn1HeRzw/KYozFVf4xm2JRRstBI
 +fWhAM1k
 pKzrHoaSwlWzWnlBkHCMzTKzxtbR0Ah5AVmG7h5+Ep/saVaaeyXdJFGvZF9nobMZtZQx0LmfsO3WhbkLHWiAjSWl1oQil6sMQaDKukwb/3EtE4AffKjEeJMk3pdySMOZgR2xHy7A/WeZ1iWq6C+gtqXpCN9Vi3oKK7B1UYQ0Cqg69iGZzJuCuE2qnn3et33L8IvL4PKG01xTnXgTfOwe+pPFsX2BuqNx4+87P2rC4/xlFKG/si1zUedhUC7HWmIOkCbSftDCrL93XEwXKBH9VxYUAcLX86HHf8/kU6GJhJ/Fh6yiMtRhYOFI24fEs76y6hysRpd23XCjJ6WzUGWkAh7e8YdJP3LxRjFYnMgFmEOR/Zw8IbYNumFgCrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 11:01:00AM -0400, Waiman Long wrote:
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 84265983f239..eb4e0af5edba 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -856,13 +856,8 @@ static void delete_object_part(unsigned long ptr, size_t size,
> 
>         raw_spin_lock_irqsave(&kmemleak_lock, flags);
>         object = __find_and_remove_object(ptr, 1, objflags);
> -       if (!object) {
> -#ifdef DEBUG
> -               kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
> -                             ptr, size);
> -#endif
> +       if (!object)
>                 goto unlock;
> -       }
> 
>         /*
>          * Create one or two objects that may result from the memory block
> @@ -882,8 +877,14 @@ static void delete_object_part(unsigned long ptr, size_t size,
> 
>  unlock:
>         raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
> -       if (object)
> +       if (object) {
>                 __delete_object(object);
> +       } else {
> +#ifdef DEBUG
> +               kmemleak_warn("Partially freeing unknown object at 0x%08lx (size %zu)\n",
> +                             ptr, size);
> +#endif
> +       }
> 
> Anyway, I am not against using printk_deferred_enter/exit here. It is just
> that they should be used as a last resort if there is no easy way to work
> around it.

This works for me if Gu respins the patch

Thanks.

-- 
Catalin

