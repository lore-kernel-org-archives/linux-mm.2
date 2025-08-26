Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A447CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 795FC6B00AE; Tue, 26 Aug 2025 15:41:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D2C6B00B0; Tue, 26 Aug 2025 15:41:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AAE76B02B2; Tue, 26 Aug 2025 15:41:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3EF6B00AE
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:41:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FA2E11863B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:41:08 +0000 (UTC)
X-FDA: 83819927016.05.4E782D7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 732E2180010
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:41:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tLMhM2UN
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756237266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXZHG7FeAOLOdb03rd+3Zpl+8D1DiDY/d4hTHKY6fqE=;
	b=ImiYghykJNz7Kgd1TuzIlydmdj9QQcGHiKyLL2Z1XnCvt9zdCc247+5sI5+y9vO0DUTaox
	2dF6+yJ8FjdsdapAKpjxNfzqe8IS3S2aQGYIdq+MK4P2n52+yV13yjOYYp2/M5W9KKlyCe
	aNM83WWmc/aMyJkMbQsxR1iOIKuBoQA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756237266; a=rsa-sha256;
	cv=none;
	b=OCKyTj2OUChk80Y0ak0bKDO/PYLAFeP3GPUxtS+LVKJ4FxEAsveCMyOOjcXhxd1MB3WNJ0
	V8apuipe3NCSFL3jQ3qkrh4cQ8xpUAJ++/bxQbTDJ3MDh+I42+MRFz3Pv+MmRd/rt03Cyu
	uw11hr2X6VnEEyw7V9eDiLC0g11nwjY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tLMhM2UN;
	spf=none (imf16.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CXZHG7FeAOLOdb03rd+3Zpl+8D1DiDY/d4hTHKY6fqE=; b=tLMhM2UN+tFtFq/me9RYX9Ry4N
	ZLFYOPNJDlPOeXHAENuvC6xLP+OdJYI7lc9H8OEOWi9UiN5RLcky/5CUBRBznFnZ6KHGPMYyeTcS6
	vV2+YZVbTe3o+lsHsGETnLvtBva1cNmCaV6pdcntMCvIOwUceGiHBoTTWA59pzOb9fSoh7yayjYQW
	K9wbPXqGA8LG++N7xJ2YyC+SSvQEYwLcO6fa+eBqu6c6BPuZF5i11STRG8+wDnYdzSvu+SKOS2i8K
	y+V17UBijIjB1jEODonYhpqCAedvVkN+vaxSzzditWefHn+TObeP3XWCKO0s/+kEdQDVzJmqx8Gp1
	Sm1t0+PA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uqzXT-00000008f9y-2mU8;
	Tue, 26 Aug 2025 19:41:03 +0000
Date: Tue, 26 Aug 2025 20:41:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Justin Sanders <justin@coraid.com>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Subject: Re: [PATCH 2/7] aoe: Stop calling page_address() in free_page()
Message-ID: <aK4NzxmGZjKvsGz8@casper.infradead.org>
References: <20250826193258.902608-1-vishal.moola@gmail.com>
 <20250826193258.902608-3-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826193258.902608-3-vishal.moola@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 732E2180010
X-Stat-Signature: 34sdcghkw8ztqrgbk7a18hxkrhchk9wy
X-Rspam-User: 
X-HE-Tag: 1756237266-610161
X-HE-Meta: U2FsdGVkX1+MGFGnvo524yP5dwc5fEh6rjbar8YHI9QHbAnE5YoVRx5w2CNvCjnEA1byXLjuNnNKm4t/2VRK+JAred3uChk86O+IXN3xeIlX8ICcLpaRQn69xZumMzB3ywIjKawRYa83YCuCNDUm0NbQvzr0YKctksOGYNgW2MH/eLLhIjN16/J4F1tmBOKaX41L+vMSs/9KSbp8ROAaccyzYUsCgiue0fHcojRuWw7g9Vl85wKOpvCl9mNQEXFi2KRJ9Wp7aw1pKnjta13JMzZQl7acqP+uvpM4qKcyL7xbVmWLiOAp7JDceWpUeqSIn7myr68i4ypd3vZRA9HmT9OVqaEa4GRZweZ1fAwrIqb+5YNj0nJs9l1xzXFIg628f/QrthctmOfOZOqxDAKuRZKRpHhsqmpKo//FHatMC3YaIw/tr90I2oSqN++evSQTf2NTXgynKOZp+WehUTQI8D0yGGMhqKF7HP0bf5Fe4SDu3WpKJV+2K3JTKyijQ7qf/MC1fzEzntRWebTbaFoHu9LuUfke7eQIaQvEtyvy+ZyXMkH9vpx0lmSKVeopIkFxglD+WT1wJFc9naVQmTgnUKbI1NwtT2LuFDE2vRzQJMToztLQ5l2vDBPTjejWqvDvO5g5NMrX49uEuCTgGPVATYkb9YJHt2Tyz2M+cziqsG/RMjuCzEf4T622IAkFc+MZZxaPUmyKl3zW6aHoUBZV2evDiP8z0VMM234khXC9+WGO/o6sYPdBuWI9g27VhXFO9w5b4W1mN0AyfnWt57DC7ZVZj4XGbU8AZBcuq2g8qeIXdM6gh+CEU27sUBac0IN/DwKzN3Kz+2L5YvR5vhkEXKUOvAvR6+vT7R4LEZebK1g+Y5sHCR6zVpJZq5jF+25PxERMNsnX9CNBIXozyUBJwnTqb770d8AZHJsJN4WnmGACmwXMzPbEpdD6jK11kdrwKFUaCKTau7Rz6v3JOiE
 IE42S15I
 kmHXKH3jyDRNdwU2QSU53cpHfFF3Gl9nnGXC5vzy3OPB3xpuNbH870Ia3zsdMHK7Tp8IveWDFsZYpdp3ov5ZvAFw0Dng+DHZhRUCab4OTRI5d6daY9smM24tTNb/RQe6bd1sk9yGiZK6Jvduzo6X9DJ0BDl+i3Dbgt25eyQGs9jVbYWA5EB+IJuI4HUqQY4maj6YQ4zmKi9197YmB/DjX1ZtpRhVObk65wuNn3eJZPTArtl+sA3aweib3NGBX4zxBsybWla+kl4v5ahg8XTYbtsfO83vBoch4FWZF5/yRSGWrBecZGhwduFSrIMYvBmYPqNyfSPsi1FqvAtJZOnbc0MmovIhuJ3K4A8mlYuTXZCAmhvb2Q34SxgRhuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 12:32:53PM -0700, Vishal Moola (Oracle) wrote:
> free_page() should be used when we only have a virtual address. We
> should call __free_page() directly on our page instead.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Probably should have run ./scripts/get_maintainer.pl drivers/block/aoe/aoecmd.c
Adding ccs.

>  drivers/block/aoe/aoecmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
> index 6298f8e271e3..a9affb7c264d 100644
> --- a/drivers/block/aoe/aoecmd.c
> +++ b/drivers/block/aoe/aoecmd.c
> @@ -1761,6 +1761,6 @@ aoecmd_exit(void)
>  	kfree(kts);
>  	kfree(ktiowq);
>  
> -	free_page((unsigned long) page_address(empty_page));
> +	__free_page(empty_page);
>  	empty_page = NULL;
>  }
> -- 
> 2.51.0
> 
> 

