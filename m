Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB49CC5AC67
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 01:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA66D6B0088; Tue, 11 Aug 2026 21:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56E16B0093; Tue, 11 Aug 2026 21:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6EEE6B0095; Tue, 11 Aug 2026 21:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8614D6B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:24:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0B1FC02CC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:24:43 +0000 (UTC)
X-FDA: 85090872846.24.6BA8888
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5077D8000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:24:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CyMw8fYN;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786497882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l5+IacHwrKkXrPidsTQCEFGfOBMjs+caiTHLJljiYRk=;
	b=CHx7oc37qGyrcGVcbm+/jvfUiPRcrzcW1MoDIi3XcFGdzfT/vAby2Htv7nhjvjr7oJ7q+A
	nrNoI4iN9VTLoPAK0LpZVWG3mEhf4Wh1VuvxuBzLj86Wfke4IY3hdcPYB+Huo7LwrFIeOJ
	nT/jcoZeAy5oK0qkA99NlPChbEmrwUo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CyMw8fYN;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786497882;
	b=q7ypenL4m1kWujYO93jgW+KzcV/KTNpnuetNGjzwqq11OA2Wd4Q6VPdhcETMuVJLDJXO6k
	MhM+kjijP+vTUb6RxHWJblbHlnBNIMJ1wlBXva7Ydf0whULSykI3tmLIWSXLUVunrZUX50
	J0xXbQ1aL3obmfknHNeI9+VF9QwRn5Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 56DBC600AE;
	Wed, 12 Aug 2026 01:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4F61F000E9;
	Wed, 12 Aug 2026 01:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786497881;
	bh=l5+IacHwrKkXrPidsTQCEFGfOBMjs+caiTHLJljiYRk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CyMw8fYNQBJp7PvVipyqLIow88k30YpmfjAx+g3UxhS49uqcj5vf9IEjLbiXKdCYI
	 QLywYhTO9jAX6EPcTbqBuXz0o09X5WCZstC1XcqqRhfOAz+5u5PjSLZyJOtNlD+rO9
	 kxX+hdazlRQdCqoamobuN4G4Zv3FAc70cp4r1T/g=
Date: Tue, 11 Aug 2026 18:24:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: liuqiangneo@163.com
Cc: jgg@ziepe.ca, leon@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qiang Liu <liuqiang@kylinos.cn>
Subject: Re: [PATCH] lib/test_hmm: fix NULL deref and wrong direction in
 devmem fault debug message
Message-Id: <20260811182440.79cf147171dc7f87762a949d@linux-foundation.org>
In-Reply-To: <20260811092256.102101-1-liuqiangneo@163.com>
References: <20260811092256.102101-1-liuqiangneo@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5077D8000C
X-Stat-Signature: 53ngjit9e9j9jtcwytrj14annegy9kr9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786497882-816695
X-HE-Meta: U2FsdGVkX188zx+zuuqJxl+L89yltzUaEf/LewsDSD8yxCfEpBgCz/XlMNQ7QJmwfcYM46x5oqwQjIqE1hfQgR14D9aNXrz4dMPB5x5J/x0bY5eCLuQieD2rMgcd9c+Y0OIG011ph2olSlkgIg3HxyfmRjC134cQMbYMIG4s/7IXMEGgYoHVGeFfq0147CIKZFPGeuTPwpapSyX/d2Ry4xEof+5X01mVK3CDXiSu2Hj/m4J1PZzpyB0ZEh13sh/YBtf6N93Z7ckvPetDURyZ8UKXWmFT2fXptgRkUG4pQ7Bv+CCPHNn7mikEj4QJfWdcqjWb4Bjrf1+ravSrm4Ar9OP7f8RrXYC+ITgMcyPKaiQToOa4X+HbJPmsHzPDv9L+QTgkwV0eyoaG3KcIqG0ucg8I7ZijZoMl37o0oJR6uJiQ+i6GjqPvrN+XmNXIRPStVDXGKLaiHCAl5cgEe7nqQUZuULc4v2dok16YY/tU0oUR9A6kS4JXjC2Sh69qP8il2W1FBJRZs3BKajES+HmjkZRwLl7efeU6vHBq81t7QZ4qD3vWjVuw7FsMv/1J47ndIT84/TfTD8cyZOFUovpLlG7py9Y2PmjKtKE6k6kL2dwy6mm0uPpxo//nLTEzfk1qWx8s9xpnxSERbnj4eWqxZfaQjubBOHj9hJ612i1J9DkPhkTl9zaAYYi04hJS9uqTIKHSxkgIYRx7hDaARR4Er/Ns9seKhInWekajAjZEhqnBt8jtETPPvOXwdcRUnNKw3/kmEm2OgIxdVyRf5hYevvfGrhueEJvM/IeY2z8I5aLdk1NiS2YVbChg/SswJMFkVjt5IlZ+6wPcWoU9pDPWl5YjzU12Syn7rB/DKcYXjVw63uUKwemEZ5EcJbbSk+pfBaCKFg7p+MnB4OCw5wuTvfGvUvLgzJEFivz9fpkNo7BKavaIvdmq3OVH++AKm+jhZg6XdnvvcsndepVWIAQ
 rbWJqdYV
 g4z+lh7X6qw1YtbYBuyr83CjmwmEugADpQl4rfHMONUrC/2NQhOEAfCNuLrBkBWbkoX5NqW9AgJeezVos8cxSbM436WoY5NI42Ja9U0XgeIKxAjFai3yWcLBUzmNWUmQ5Enms+VKxOkx+dqCfRZj9WnHZO1dIBnvQGbau0S00TQksIBVJKxF7tbbZ+Z3d+W9L22y/PJ0icGcsZZVpTzNdqYDG/JFRcR1wsOMX+oLTQSKcT7gHmY/7MM/ILUBTTvNUEn1PE6nfqIHe2IB3u4NaeKmmYehSDp5PynE9oprBuXgKFiPtdclNouHlvdwmCSRnPIOUMp8ckM3VSpRfwm8XUXy+Rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 17:22:55 +0800 liuqiangneo@163.com wrote:

> From: Qiang Liu <liuqiang@kylinos.cn>
> 
> Move pr_debug() inside the `if (dpage)` block to avoid a NULL deref,
> and fix the direction label from "sys to dev" to "dev to sys" to match
> the device-to-system copy.
> 
> ...
>
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -1151,10 +1151,9 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
>  		if (!dpage && !order)
>  			return VM_FAULT_OOM;
>  
> -		pr_debug("migrating from sys to dev pfn src: 0x%lx pfn dst: 0x%lx\n",
> -				page_to_pfn(spage), page_to_pfn(dpage));
> -
>  		if (dpage) {
> +			pr_debug("migrating from dev to sys pfn src: 0x%lx pfn dst: 0x%lx\n",
> +				 page_to_pfn(spage), page_to_pfn(dpage));
>  			lock_page(dpage);
>  			*dst |= migrate_pfn(page_to_pfn(dpage));
>  		}

Current kernel code doesn't look like this?

