Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BF24C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC9D6B00D1; Tue,  4 Aug 2026 09:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C526B00D2; Tue,  4 Aug 2026 09:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0E36B00D2; Tue,  4 Aug 2026 09:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA63B6B00D0
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:42:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 939C41A0126
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:15:08 +0000 (UTC)
X-FDA: 85063330296.01.C2585B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 02929120012
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:15:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZnHoS2uq;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785842107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NlvQqMPX1ZBZq6vczB6DK1Q1sg9iUABmibDLc459ooE=;
	b=B69RzzMlGrxKA6ov/VzlbJYFj3sNgM2VMvIJtAsZwjNE1G2/yVsS+D1T/DRYST45rU/Ef8
	//f1phkmQHeeCC+WU3IXDZa3+WcbzMBNpkOFyL4SK6Nx/xdMBMLTT7izfm4qJ73ATgN/XX
	lFbx8nY2gk93vaOOeiIbrMx1rXSgaiU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785842107;
	b=MSfEyV7lw9vpvdfgBURI+YmaNF1sZwogAstirqaQyK3s3qv+s7izPoxoNqSzKfRt5RSzI7
	qxBpmLeacJErerOc3kmzvZ1uwizoKayWV4IOxtVETTYBEI9ClZAYMgZ0zXKuhba3Qk9HCz
	AaNDXl6zkQtMWSU5IWx9l9Bh6kHBI9s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZnHoS2uq;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25FFD60A59;
	Tue,  4 Aug 2026 11:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211D21F000E9;
	Tue,  4 Aug 2026 11:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785842105;
	bh=NlvQqMPX1ZBZq6vczB6DK1Q1sg9iUABmibDLc459ooE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZnHoS2uq+Wpn11Z4etXu+hxwCLOTiTcnmGh7C2+5V3PHkGFMDITE9z6uYgjCeYU/L
	 fC2NEuRAvvmECwZZAk2YEwJi/IwoCe8YsK5WKKXZVKTQd4iez0HYq95u5/tbxm135G
	 BW+tRjPZmgs+NDRQXQS+Z1PArA8qMZ3MY68n34Q2d8TV/awui74P0GXMnIVCuorty7
	 wc+LZ/aDpCuNW+K8lOzK6vW28Jlb7Q6F04ycjuf6wruLgZ+JZ8nOR4jzNd1mJrn889
	 QN98PED33opeHD+Qj9pfIsMlzShSZ8hTwHnXReg/xD7GXlIty0nulMgyNHSoKB2eaN
	 uL1Z8zxWAFNqw==
Date: Tue, 4 Aug 2026 12:14:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] mm/s390: constify ptep_get() argument
Message-ID: <anHJh7rPomeJgVHc@lucifer>
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-5-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803164400.531199-5-pfalcato@suse.de>
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: hxxmqxm3e4fidhmx6ccr55s8mm8dgs76
X-Rspamd-Queue-Id: 02929120012
X-HE-Tag: 1785842106-65501
X-HE-Meta: U2FsdGVkX1+6MFFWs8WJ9EwFizo1ZACcWzQZHhkukbjA0z/1csDQOqIkxT5+n3VXt0ZyyjM+fgpPaLNy0adI8N6yAvzoo9SBb1AQ5I67/f+x14ywh+s5fVGgAvIlqoKhEiZEtumsgHNzN2weeynhWttz20sRzCDfbdaB5kaFlUpgWYGecXUX6WbPESpJ5vE1LLwhZP3pjEDG+lGPF8JzQgDy0+wuEdIZAScW4OEvua0+GIx3hN4mWsIUrNdl3E65yYZT8KU7veKRAPtPZv4tZ2pkCsqfu4YtIekM/l0RUSusHOAl7Jil0B2uJwe0APCJXjU7HqnCwNCi/+HLkT2jQKG3nxqsOspeGEGWU/C9o3nJlb01FUyCIV4QSlWF4L++t21VYq1Xi8G6gTIpfbi525Gq4g8GmaJk/y3sZKr8K+6zmADXjY6SCHSD+YOgE/wwyuVTptt/kzl5bdCmWL0AERaOxGJ3c2MmZCbCmtQPZmALVU77qtrq0fRCqMZPt8NCMRXvGrerASSjgYYTQ7AVQexm5tQ8RAbMvdWyjGTQX4KADZzZ+4H3RQHkj5HuCBXqFELgoseplijv7MxGq3IYfqdw0EFEIYe7ImFhQt3ZSmHEYlF+kp3Yf5OxflJGljKUHFFxTOlzIjrNnemdAIC2axoAnOF803eT+M6capeet1tcVbJUC/9MbJRt/mzMSorJWNFH4zCs+bxVJ+ur9nlKs9GVOQvoeKTws4Pgm6tqq+MSXjG5TkUrdz44NYcRyh7hRosMnDErZGrKo+/cHt/DWYbtgkb8pXpUG6xCDNISLJOFu/cYaoIEqNE4kh/TS8HTGlLtiijC59tUKIZrH8/BCeBE9J0lRKgTsxy2O8+fHxaVb8CgffZ+4in5mrRYCrwOn8/M37YxZwN3IgjZwgmeO1Lc4ndvjT3XTC487gimWQGXDG/xHZcoKD3v9Yg8biIavWv2lUhew0YZFDMFQ+F
 /Se+jbQQ
 AfhAHnCq5GR79TZGM43zZzFUdagnF8JkK9vlRQsZAHrYbVx4mXEZFIw3e2sy24Rp7UF9tRPPIzD/yhlddBu1KM4Db/f9KMIop9b/9UqqvydTCZKOe/yHfjP0LXO3ZBZyRyXxMhgKWS1EWhe4qwqIfy7otnSLyG+r5SOjvTuqPpL+KwRLpIrk9zNy3qMbGD5OBxQIbOdzJMwOskKhzo1kBx6ryKv28/gx6thUZCO0nJzCJLsfe91oJEvoHe6toIq9Pfve+qgPMd1ai08UVh23W7WCDvzNXztAUU+qtG1dv9BUpqI65Nf1IvQOkqfLh0b6IOsKRwbF5acKDIJLt+jGQQ6V5eAUYdLTFboo0xFUyLGIYy79gtNUJ7vmZvgWzxSYfxWhZkzhuyLm5RRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 05:43:58PM +0100, Pedro Falcato wrote:
> It's a simple READ_ONCE() dereference, therefore it can be const.
>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Even I can't be pedantic about this one... :) so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/s390/include/asm/pgtable.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index e882663a58e7..ec331ec92943 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -986,7 +986,7 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
>  }
>
>  #define ptep_get ptep_get
> -static inline pte_t ptep_get(pte_t *ptep)
> +static inline pte_t ptep_get(const pte_t *ptep)
>  {
>  	return READ_ONCE(*ptep);
>  }
> --
> 2.55.0
>

--
Cheers, Lorenzo

