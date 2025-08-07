Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45888C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 15:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3E96B00B7; Thu,  7 Aug 2025 11:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73536B00BB; Thu,  7 Aug 2025 11:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89AF6B00BC; Thu,  7 Aug 2025 11:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B4DDC6B00B7
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:11:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D71F82B29
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:11:30 +0000 (UTC)
X-FDA: 83750300340.09.9FFE67A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 865C7A0014
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:11:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754579488; a=rsa-sha256;
	cv=none;
	b=R2t+ltEBIdADrt0e8cMP+CT0+0SXX962BfeR72Q5t8P0vToyCdEwPFLR7wORsLZYdMG4qF
	f6eIDr/ElGx4+7VKz0cJUPDPxCNBHfQLVRKYnf++z1LCkmMgL+/d0Y/fedx9vlEO2IpCxU
	P3rITM/m6wmleXaX0NL/dA0LTEmSi+A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754579488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=POZMUa9asAss8JAsgIKtMQ2DyO+1bskCzufU4E64/Ho=;
	b=43OdrebG3z47pxFDWhiTPpyFjqCnXYDgIMC5A6KWhMyLIHLdsgQ7y0D8S9UUZxIFDesOQk
	UlUMuPZt4gf4zRpCHDuVT2q1nEYSuedWHIw6/4niPuW8pnp9VSj21HGjxR6dLL8gnlqImt
	C4vRIwpRH/ccAhz98qt2pL7Uj+9kSlA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8390C16F2;
	Thu,  7 Aug 2025 08:11:19 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B139D3F5A1;
	Thu,  7 Aug 2025 08:11:25 -0700 (PDT)
Date: Thu, 7 Aug 2025 16:11:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Gu Bowen <gubowen5@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
	linux-mm@kvack.org, Waiman Long <llong@redhat.com>,
	Breno Leitao <leitao@debian.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v2] mm: Fix possible deadlock in console_trylock_spinning
Message-ID: <aJTCGrkg69Ytg-CC@arm.com>
References: <20250807091444.1999938-1-gubowen5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807091444.1999938-1-gubowen5@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 865C7A0014
X-Stat-Signature: xkxme9xab4ojyf37ftekwkzck9oukzcz
X-HE-Tag: 1754579488-623592
X-HE-Meta: U2FsdGVkX1+kjd6mVuBYN69d9SApcM9JowxEVaEM/JBeh4XUt2n4XE83A03cWy6xNTBfZPujup+DOj/h2Llo7bp7emgjus9IQMjmfE9MPaid6VFI44rW2po08i5/jU5sllPUIEYloPzXvpEQszFSK6Z0w6J25HF3cEypUiZa82vXOxjUUCyP4X/37U7VGsu9FkcRl7wXGhx/qyEVrcW/IkCiYa/B6zZjYpGfXAdlvrE6O1UVmvRbJMpBlG5isJ18mlYIaXePLBnuu4uRapGyVJrOHYTNIEjf9NP0P/xm7FlkL+76UKb/aD+p8IrwJXlIP5AckwmKbUeWnwsJr3fOpev+pMQweVygu/vyBU+ce8Nq0k9SV6cLUaaa1OqpttDcM3ZGAaZ+bjv4W+tqQvhXgVGH2iO72Q0Rn30mhYtYt+b0MXKdyDcBuB4RJjgzasV2xWMkHx8AsGVxVSMFI/BlsgFOU0Sjmaq47ZJ4x5xjnsA2xUEmEpg7h0r8ZRyuEFwuWuDgmrKjRSBmQWMnVpPoO359ETPEwsdQaVu2if5dnGlKrJvnG9iwfWqc0RV6KsTPRVzD0dGJFc9vtoCrj1ocrX5pnxS0uyb41pWpZ0IEvBRU+4tnGt3U75EtAuTcgu5XLDU3e7SdJ8EG2+AqIXb7jXiwEFBFHEDREyckdZL6apdG6xHErRbEyE1Ob/vlCjzDL8LonggethI4lrZtgll91WEs63EWE4H3VIMh6ehKm7DxTyxT3Ggd6odEwovv3xZZt8XdNF3lVXWdoUNE0J3wKwwUPgJQn6vMpMCrYLQ9PJcrIWPtNAu0LBMG63aPYDmuZtx4S3m/Mo/AYENERbRh3HbdsqF8o2BAQfqgb5bpMEduzpBN+KliIeHQgro/wMWk+N+XusCVf4CuJ5+4ubV7nFUP6qNc1UTDiq4lnJ0XQao7i1jjDvR4nke0Y26ppnvV3PueUuuhfxf/31no6LH
 JC4DA9/z
 rQ5XWA4dNQCRdU4UgYVozPAZSuCHr0xkP0+k59GtMcLuNxi5g2dGXxUdL56usi5FFhL6oQIzMFVEis3CXoax/oAFdVxage6H8XM+0f4XMYb7vwsCXp+SOKNz6c/jELlVw5rJ6gYywuDARVM1hn8f905mCZPcUrZWgje+EciotBMiiuncOsa1hmzlOipdNjy0vYJa/I6FlQsEeVPg4Mk6PiQxgcHMVS/tQQOL+MqE7ptzdMBN75BRcTwoo0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 05:14:44PM +0800, Gu Bowen wrote:
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 4801751cb6b6..381145dde54f 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -390,9 +390,15 @@ static struct kmemleak_object *lookup_object(unsigned long ptr, int alias)
>  		else if (object->pointer == ptr || alias)
>  			return object;
>  		else {
> +			/*
> +			 * Printk deferring due to the kmemleak_lock held.
> +			 * This is done to avoid deadlock.
> +			 */
> +			printk_deferred_enter();
>  			kmemleak_warn("Found object by alias at 0x%08lx\n",
>  				      ptr);
>  			dump_object_info(object);
> +			printk_deferred_exit();
>  			break;
>  		}
>  	}

This hunk is fine.

> @@ -433,8 +439,15 @@ static struct kmemleak_object *mem_pool_alloc(gfp_t gfp)
>  		list_del(&object->object_list);
>  	else if (mem_pool_free_count)
>  		object = &mem_pool[--mem_pool_free_count];
> -	else
> +	else {
> +		/*
> +		 * Printk deferring due to the kmemleak_lock held.
> +		 * This is done to avoid deadlock.
> +		 */
> +		printk_deferred_enter();
>  		pr_warn_once("Memory pool empty, consider increasing CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE\n");
> +		printk_deferred_exit();
> +	}
>  	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);

I wouldn't bother with printk deferring here, just set a bool warn
variable and report it after unlocking. We recently merged another patch
that does this.

>  
>  	return object;
> @@ -632,6 +645,11 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
>  		else if (parent->pointer + parent->size <= ptr)
>  			link = &parent->rb_node.rb_right;
>  		else {
> +			/*
> +			 * Printk deferring due to the kmemleak_lock held.
> +			 * This is done to avoid deadlock.
> +			 */
> +			printk_deferred_enter();
>  			kmemleak_stop("Cannot insert 0x%lx into the object search tree (overlaps existing)\n",
>  				      ptr);
>  			/*
> @@ -639,6 +657,7 @@ static struct kmemleak_object *create_object(unsigned long ptr, size_t size,
>  			 * be freed while the kmemleak_lock is held.
>  			 */
>  			dump_object_info(parent);
> +			printk_deferred_exit();

This is part of __link_object(), called with the lock held, so easier to
defer the printing as above.

BTW, the function names in the diff don't match mainline. Which kernel
version is this patch based on?

With the second change above using a bool warn, feel free to add:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks.

-- 
Catalin

