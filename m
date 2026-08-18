Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BDB4C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 06:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1319A6B08C5; Tue, 18 Aug 2026 02:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3326B08C6; Tue, 18 Aug 2026 02:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13BF6B08CB; Tue, 18 Aug 2026 02:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D162E6B08C5
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:47:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5309FA37BA
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:47:04 +0000 (UTC)
X-FDA: 85113457968.26.8739ECD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6DF47C0007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:47:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CTHVIv0U;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787035622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FV7YaDj8UYJTIBzwGCDd/artCnkl8Zkv75GOYoH7ahA=;
	b=WNc+mLIdXbmcSvNL/hKS9kgoNQQbQeI0rhBaidqbGmvL7UnntS5FwA1eG9K9QRNhcY+C76
	zBRPJT2uo6TxJcY7eBcfayiIJDRnZsf6qONKPFHEBWUVW9AXJkROfE7HdoyqQeBnoDGicb
	Qjai8GTh3v1EUQhrXOYBZ4H3uc/PnmI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787035622;
	b=k4l4JTtW2szeKwl75mHrrv01Xjrih3ughb829leF+mbSFispXoXKGvhV01CkqnIeN0vK3o
	CP9+GNfaTjjtKe40/mF70HwxQirjw7gYc5VH3IhZLZnDaJvIauTw2JV2RAhWlid2/hhhb+
	IELGmLT8z1xOH7rXgmEI8EI9mo6m69A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CTHVIv0U;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B2E2153B;
	Mon, 17 Aug 2026 23:46:57 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DC333F85F;
	Mon, 17 Aug 2026 23:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787035621; bh=3Zdl+JzBl/JqXDZY6Efc0m/ZWyv2YZXvZZGVhQPbC6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CTHVIv0U/vSSapBacgFU41CKb8IkCnpZ2DJDjzNcgunvVYqAzcJ2pDRsc5xebowoG
	 Ey8RR8j+a1OMG+VysbcrCElXu8ahSrFla9uVaCR7UY+2WcW937FvHWotXfIoHqURoj
	 OLC0x54W+TTyIjMJgw9uHmI0Fk+ngh3QzLIkTyqg=
Date: Tue, 18 Aug 2026 12:16:57 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/mm: Drop redundant open() in mprotect_tests()
Message-ID: <vgwwpyvb254quwnbpwbjc2nxzhmt66a5nuxqfpmkpr3y6gbybf@3p3ul7u6jbe5>
References: <20260817080616.52946-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817080616.52946-1-hongfu.li@linux.dev>
X-Rspam-User: 
X-Stat-Signature: j9mxeanbibadsxow5oj5bf6w4oip7g86
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6DF47C0007
X-HE-Tag: 1787035622-23087
X-HE-Meta: U2FsdGVkX1+42psI57xaLvScFBidPnA9mx5P7AhiBhicziTdDISLT/r4xENCQ9gbVpWp3ZNeYuJ3C2W5esEhftDA9RjCccjzX02vPV3Y/63Q/qbS8cnRAsGp33yCc9zDuoWP53BH6crYRGL7R3OEVKP39+tku6vAod5zQz5i2CTzVKZnwkxjGk1i6PlAuE2oq9qcK3J7+xut+6BZjyTUeSWMk0J12BJj9E9N3McXn+7203w39SyTMh4dT/Gas+QG/SsDgXguNGNskoBoU6jKszpdzD9QCIfT8fK9K6LJiBtC6P8ymOSDyfKNMKxeNGiD6xHZdC+yjtvjaD9A/GSvFvYAxYxLw1++lZvuo3GK0soJ5CWXly5TKGGErUu0qRlPIJBuBZWlIr6SUpQBdCEYYzPAPF31wU1lTkCEDp8228KoCec54yoXnYDkhkfhJLxeCiIEkdH4DZ2wD/fT2lKzo0wH1KetzEDD8FKETFH+Grrut+TrLpBXo5XGSJoYCwO7EIdNVm/TmM2UgzTEfd5apsNKoBivsCwfe2lKHcbgQJ18H2x5WII6KjcMZuvuqOGCfwOm5TcKa3GBHzg4su5EO83nqg9EUFF0XuT8lxKunvFUVDBWFmt8okSwvp3wmzTpzRg+3C7W9HVOO/qM4I5+trTNVuhxH8c5ALaQU5/K5r2oPBS0m+gnfMHjJtiozXM1bFzhK/odPuge0fNI8v6rkQskxM7PjhHoDIUtxrm44A7vTtj5DHxyRvX9N10iHyc1UTeZFlazhBUWkKCgphlmlre/v45psjBFOWCASQhDZ3w9zfqTUCVNgrIQgtfaj5lH18MxPX/1xN9xaBvC28KMQxbp5osUAJlVpDNcyOkT+bJIGFLE8dVJKpxUFTEJ+4SZpehTAmQGawvKyA0BRR6xFTWwNiUZhFCC0LC0cyyABcaFqYVn10CNpU1Kdtb1fdvc/1w23UFA4DA8rzE38J8
 hhSWfvsc
 IzqFY4sAUhxGmcCsn9N3qnX5eY5ZTFImDc9ZeLtPEQlH8GuHgt+ilpWesQNMWiyMYzC4kgx0x9zqg4XDsqFyIplzOmjR2/uDJXKk+B5UAnu6NfnQiPlSMEKh8r6BMKQtQgyFouKUCIDqfH8bpSJmN9IlIdx5S+NmhwlVeFIgX1b6v+IfcLe71jFAtXFQAyE23jCwZCb7J30F+KWym8DLCvwVdW5z0g54//UL6twmjp0ePVQRDdrn2EXUPc3bfMxNjYGH84GFT09yOll+C2JCq3VvtJsSEtbSLASBHPBea0PLjeI/Ne1KRvLDL8ofTSna2kFRm0uyJF/JKlvugCV1aOrRi2W4QDR4/wOj4FxMBR8/14YtAE1yV2iyR0q6mwObxqAS3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 04:06:16PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Remove duplicate open() for local pagemap_fd in mprotect_tests() that
> shadows the global pagemap_fd already opened in main(). The local fd
> is never used in the function.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  tools/testing/selftests/mm/pagemap_ioctl.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
> index cfd1987339c1..eadc7159ca5b 100644
> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
> @@ -1332,12 +1332,6 @@ int mprotect_tests(void)
>  	int ret;
>  	char *mem, *mem2;
>  	struct page_region vec;
> -	int pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> -
> -	if (pagemap_fd < 0) {
> -		fprintf(stderr, "open() failed\n");
> -		exit(1);
> -	}
>  
>  	/* 1. Map two pages */
>  	mem = mmap(0, 2 * page_size, PROT_READ|PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
> -- 
> 2.54.0
> 

