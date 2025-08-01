Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44E3DC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 22:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33936B007B; Fri,  1 Aug 2025 18:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E47A6B0089; Fri,  1 Aug 2025 18:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA806B008A; Fri,  1 Aug 2025 18:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 824E76B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 18:33:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 14DA21D45B1
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 22:33:08 +0000 (UTC)
X-FDA: 83729640456.19.EBF16C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 532711C000D
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 22:33:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Z2t43Xrf;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754087586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3rvO60USj+pNn9wBxV6mgnX3Qsjz8RAeBti/NlzG2k=;
	b=LeOTk2p3dZ7CS7l9g+EkyJsEBoBQld08zzk994pZMQZu14f9U4+1pio4ScnJmON2oOStB1
	3Sq7GMBsKlDUATFb+ZadQUFRrXnYPyerCOYkkc2zjWlPfpdFk1dmbOoTUT4FZHbYFd5v1Q
	a/gqXta1yFaAQhOFuWQyVsaPRf/B7+Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Z2t43Xrf;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754087586; a=rsa-sha256;
	cv=none;
	b=2p8dWkE4rKhY+G1n3akq6G068HnW2Nq77tXb9bnf9viWpvwtnEIF3FXXzTe8XAPOdxnibR
	S7awnAcvyTAK0e31iuvpusVD7zKfuk/bx2f2rjRFb6RSHAIAGx0tTQq2NfsXLp+DoWGMap
	fVn7wWc7QfLD110cz/uzqcl2RNUzeIQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F13CD4562C;
	Fri,  1 Aug 2025 22:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A50FC4CEE7;
	Fri,  1 Aug 2025 22:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754087584;
	bh=4kH6/3TqERspQwzYdE0tlDFh29jyX5Ih63V/qtXMhHE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Z2t43Xrf8h3ahfFXNjE5y0PbgmYRz9EBtP5vAY/GQatZizhbqzzGTrlJat3hCMqEo
	 c1Z59sbU6OonZ93Yv1+yrOUDWq64RzdEH25Ep04T4/pFdwsf2/Pw3zGKIpkxQbyCm0
	 Qj4i2r4oXj0jCDrznoF0nH2+nabWYTUiKO8InlCg=
Date: Fri, 1 Aug 2025 15:33:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gu Bowen <gubowen5@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, <stable@vger.kernel.org>,
 <linux-mm@kvack.org>, Lu Jialin <lujialin4@huawei.com>, Waiman Long
 <longman@redhat.com>, Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH] mm: Fix possible deadlock in console_trylock_spinning
Message-Id: <20250801153303.cee42dcfc94c63fb5026bba0@linux-foundation.org>
In-Reply-To: <20250730094914.566582-1-gubowen5@huawei.com>
References: <20250730094914.566582-1-gubowen5@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 532711C000D
X-Rspamd-Server: rspam06
X-Stat-Signature: hdxtzd9otip6mt3hnuphsf8cwyuc93zx
X-HE-Tag: 1754087586-380652
X-HE-Meta: U2FsdGVkX19sqnSocd+SPYW6gcLZG4PZMytXtfw0erxaNRFQe7CUadH6AE+xNP2a1SMO96QcROMYxoYZ0mCWyzXew9iYQWxpsTOTKT/TiyA8f1GFye6eKMy2E1Z2CZmFoPQM8HoXfO2BFwoCxRsHdDIVTtms98Sk48quoc4txbW3+udggUkSPfcdfWMqCF1E2VUwXDfDxl0aP8iWmo+/zZhxP8KrJJsCFY4Bk3ZxLg8+T9xPQUy8VgkoqkS3nYq9QgL+XOsfodUZzQkp6XDNmGX8LdD38MqI/A6G20L3AUBsfO2XW5yNDlR3gV/1vqmvdfF4ent8Ojnl1CDGKhMNjfAkMsXyWHy/w1tlrU6i2BJb49WBEXaB3/zTCvfqTu4/Rn0/RkdsFufzj5cFH0wino7fNC3DGe6vx+pAOmC6whoLMkogrezKXD2iXratq2xdKfuMj9x0CzSjnCwswYC9utW8GIF42fko2Abq+BWwRIMPQMW1lV41jf47C9vsEfgyLLLEh8JkaPJn6NjHn5dzq0UoTWi01zQTupfQqfOvz3y2zGA1dphpZYgixEpUhPVmqwwKBafxaQkCcPMuEpfI3dzWUJObrKIe4x51bgC6R5Dkde9pbc4OO8t+wwsS1dJGiGdlGT4pyS2P18nFQnJFWvwp1BihKdqtgmMXThCWTROCuZ8WHmsha7DBct5F1dEmU+rsagedzYhKTcpxfbqIqIw8WfAS9Nm64U0VsBrEuD0+HJz4lxk8Z9BQ7+IteKU1iRS1rFnABlCaNn4bcY8VZZE6+M6xV6uMEY2QxexNm32KWT3znS3GC8vc9BgkhzNuQuhJ+5fxu2kReCdk05AnzeB1hzHsd14UTNgYuKQcegbaHerkcRXxHEaqpnMib6NvOdmnUhHCgvaq9vHgKdNvJtBgurG0Gi35vvr6nmANXqkdU7hvRYiXqs6SfiD4UF5YE1Jt8ss/t+utLpfr3Uf
 UFAIzzcb
 3F6aO0XkI2eW2o3/hO0oV+QKpnqeAPIiBwNgMgs2kwEdIfgrwTQAPOjLfA3vP48qKi8oyG05pHnKv8WSvDEY5/XhM9oN7ouqFP3gwdot9sYkakEElNGCNOT67ps/UHWmQSCgu0eHzEBPoxcXVDxWdIsPMD22ouTlgWkYIsvV6HEHXiepXfCWBkiWK7WC61sk0eiBr1e4ApnWrX1x+rcZYbCHV4zcIS2kYi0ughdP99EsY0zikEpW8dxrkpi8+5yFeahzWpepz3CuDRjpFP/Y5u0BzOAiX5rxrnYfffcYZOovLoOJQm1hfe5s0AZ1xLiwl6QQMaKYdbUruxDrPBHVqyFZCEJCGk3m0N+67
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 17:49:14 +0800 Gu Bowen <gubowen5@huawei.com> wrote:

> kmemleak_scan_thread() invokes scan_block() which may invoke a nomal
> printk() to print warning message. This can cause a deadlock in the
> scenario reported below:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(kmemleak_lock);
>                                lock(&port->lock);
>                                lock(kmemleak_lock);
>   lock(console_owner);
> 
> To solve this problem, switch to printk_safe mode before printing warning
> message, this will redirect all printk()-s to a special per-CPU buffer,
> which will be flushed later from a safe context (irq work), and this
> deadlock problem can be avoided.
> 
> Our syztester report the following lockdep error:
> 
> ...
>
> index 4801751cb6b6..d322897a1de1 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -390,9 +390,11 @@ static struct kmemleak_object *lookup_object(unsigned long ptr, int alias)
>  		else if (object->pointer == ptr || alias)
>  			return object;
>  		else {
> +			__printk_safe_enter();
>  			kmemleak_warn("Found object by alias at 0x%08lx\n",
>  				      ptr);
>  			dump_object_info(object);
> +			__printk_safe_exit();
>  			break;
>  		}
>  	}

Thanks.

There have been a few kmemleak locking fixes lately.

I believe this fix is independent from the previous ones:

https://lkml.kernel.org/r/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org
https://lkml.kernel.org/r/20250728190248.605750-1-longman@redhat.com

But can people please check?

