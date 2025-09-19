Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04AFECAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 09:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE5C8E0053; Fri, 19 Sep 2025 05:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C62C8E0008; Fri, 19 Sep 2025 05:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DB978E0053; Fri, 19 Sep 2025 05:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19C3B8E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:45:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D466C14060F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:45:02 +0000 (UTC)
X-FDA: 83905516044.27.7D44C4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 561D9140002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:45:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhz40lt0;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758275101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=utj8GPGe9xQrwlm+Dp8WOy90lEVmz2edyt0hCd7KAeg=;
	b=kjZFaPmskb0aVeXmZw/uqy8kXor0TXzDCZ16pQFnP61AaqDM2A1fdGq8MBnirheyJePCpv
	aNni3OM01PUiN0rG2izKaTGzLJqxjNdOsY0cecC0LN8wk0zHH/WQqy9xKoFOXaXD6GDcDu
	cYX3qhnLTk3xJ6xyVaOnG7X0132lgM8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758275101; a=rsa-sha256;
	cv=none;
	b=aNs4Hrq7CMbY8/0U8g8Vi0CWhh24xxdp66ohgxUaih11yMwYYP4Yuyc0UPcb5OarleZbwL
	+RN4O5afuYajPpf4Ihbyjmok7Yso1XoMKWeh5cH9Wr7eIbhOaJ8HQCoiUTNaw7hslZz8HV
	ly4m673PeB+ZaLjMFymuGXi+dEeTtv0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhz40lt0;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E7D1A442D8;
	Fri, 19 Sep 2025 09:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADABC4CEF1;
	Fri, 19 Sep 2025 09:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758275099;
	bh=GevPAgZnxPiABiyE8TgVYJoyrxKHZP9YdLV2GloJTu4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lhz40lt0SEu3HxgEYIqaeltRAt4aEBgazYuPF9b2ALx7MPrXRYZh7j4KBJAYjZ4Ab
	 PhrajEYLtN+XhORv3jeUevqKHzRSuZHfsqfmH9EgBXtCpe2gtbQdOcrRd5UJsyc46b
	 tFfY75K57McmOcZnLHImyV5Dv9LtW/GSpwXzxy2jZAovnc2lvPkPRezqGEDhD4l1sO
	 Oh7o8eWuoZ5F6RLqO/4487IB1qBqFdXUKxmxATUT5sPDlCVokiHWmWYxV/1qF9/pD2
	 ELNo7ibLVq3SzpiwEe2yb4CBGNo4N9NRP2IuIfBoXVJJE3/eIIGQXtNQv5jj26TxRe
	 dkNeFxtNu9B6w==
Date: Fri, 19 Sep 2025 12:44:52 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH] kho: only fill kimage if KHO is finalized
Message-ID: <aM0mFDdoQ4r1f9Mo@kernel.org>
References: <20250918170617.91413-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918170617.91413-1-pratyush@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 561D9140002
X-Stat-Signature: et6rwhd5cr45than8ihqg7rcekukxaig
X-Rspam-User: 
X-HE-Tag: 1758275101-891746
X-HE-Meta: U2FsdGVkX1/KM+OABcHcwrzokwW283x5VrsZhYgnlvy8HoZiNbbuIvnEhmgxQ/vnzKRM/ec9xYWcfdB8f3y94m61GoLPxYxGAmj7HzJaslIdiUwmLn2joSCTiacpbgOXBp0FQJKkmFakZCAwNx7BiPID66QEZd13Re7PSdnBSQ9zD1+NCm93zcS7rSuhQ/xU57cIEXE76UelKlXVPYVe75NZorTdlTdiRGmWA/h6QjdCxlNV/OevKGwXm67ahAo1UsX6MogJciKA3IIJYfDOtZV8Wvo4GOBFtfABAv4ag0zfaQt4OjAGvzPQSFgeZ17LoahQm+cwHCkjDu82FHGM+Jbqhkw0U2oZzcxDsknjzP88jD2Ry043/76GtC/V1CiVXC2BD+FrIgAijSQLjltLO/2zStHx5clRfD14a6Pqq1NNVwrDH1FQyIL9QFDZuGrnIflb0cK0Iw26Z3GVnC4hUzl+1U2tkoflcxaLqtOTtOVxvuhBDc+81D6IznWDHDt6ch0dkGeRrGPGjk26Zd+dg/94f5ohzxdwDNfzLMM8jzh3gF13TqjrBGhyGeCoVLiHwu8W9pO8PdeUjYFPEZWsQk8TZ2p0dc94TKObCwVyw52dkp5mClrY3m7TSRzZ7DA5Ya1nSyPVAxrmRj3VornHm/Xfz/othxiPSjtxQ90RTm5CCarUTYdbTpwpYoJ56OwV2WlC7fQIsMcd4MzqXHi3SB57uzKcDlP0snWFN6k5R7jlQYrZ5joVtJP8sKIqZ/a4vDKIchseO00ZdFiqnRv0rwuSSnbTQVH40lbt/HmORi2Qc7zYt0nzbDw6QuEfR+SXsk5E6zxfuLb0IpnRh8KIdEfTPijjBWWc7afo60VY2QhXKE/XmJwZZSBumIGRY8FdrFKHrUgj/leWxoQxv1l5DfYBRPJGdYDKKzMxK6Kk0/seFJFFtX+s/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 07:06:15PM +0200, Pratyush Yadav wrote:
> kho_fill_kimage() only checks for KHO being enabled before filling in
> the FDT to the image. KHO being enabled does not mean that the kernel
> has data to hand over. That happens when KHO is finalized.
> 
> When a kexec is done with KHO enabled but not finalized, the FDT page is
> allocated but not initialized. FDT initialization happens after
> finalize. This means the KHO segment is filled in but the FDT contains
> garbage data.
> 
> This leads to the below error messages in the next kernel:
> 
>     [    0.000000] KHO: setup: handover FDT (0x10116b000) is invalid: -9
>     [    0.000000] KHO: disabling KHO revival: -22
> 
> There is no problem in practice, and the next kernel boots and works
> fine. But this still leads to misleading error messages and garbage
> being handed over.
> 
> Only fill in KHO segment when KHO is finalized. When KHO is not enabled,
> the debugfs interface is not created and there is no way to finalize it
> anyway. So the check for kho_enable is not needed, and kho_out.finalize
> alone is enough.
> 
> Fixes: 3bdecc3c93f9f ("kexec: add KHO support to kexec file loads")
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Nice catch!

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index 8079fc4b9189..5ff959a90165 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -1242,7 +1242,7 @@ int kho_fill_kimage(struct kimage *image)
>  	int err = 0;
>  	struct kexec_buf scratch;
>  
> -	if (!kho_enable)
> +	if (!kho_out.finalized)
>  		return 0;
>  
>  	image->kho.fdt = page_to_phys(kho_out.ser.fdt);
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

