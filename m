Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A345FB5190
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 05:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9C96B0088; Tue,  7 Apr 2026 01:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A416B0089; Tue,  7 Apr 2026 01:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897076B008A; Tue,  7 Apr 2026 01:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7ABAF6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:17:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD35C13B55C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:17:11 +0000 (UTC)
X-FDA: 84630601062.06.79C0224
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1185F4000A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:17:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qQ9j0XJj;
	spf=none (imf11.hostedemail.com: domain of BATV+d54640da967e19434292+8262+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d54640da967e19434292+8262+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775539030; a=rsa-sha256;
	cv=none;
	b=WxHG+q74q8DiiVEKyTLp9FWsT1EpprqrvyF1siUZlk4BqP9K2hcsAmIh6sN2rUInJ4wthc
	w2dDmEoOviHP2qKum3+kGApwb9w1W6JQsWqFqZUP3QxZoyP+4SMk4laOQtF8P7iV+efHix
	ONg6kR6apmsujDWNl6o8VejxkStwAiE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775539030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sbbf/Es9EHf9oX0aipQYxujSayx6etDkff7GWf6Q9iQ=;
	b=BR0xP56gC1XK8wj811ALRGPwOqoJz/LvtqfqnnUqF/HjNgZHwQGFIWaB4p5n2xsb/AjuVl
	Io6WHQDnhwlUX7wSV5GinNBTA2MSkbZRV4qu0xXnyEEIpQMHaLdtZXl18UHaOsytUNUZ2M
	6tm0oQSLsbcDfIesXdC2UbVjomnRxoQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qQ9j0XJj;
	spf=none (imf11.hostedemail.com: domain of BATV+d54640da967e19434292+8262+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d54640da967e19434292+8262+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Sbbf/Es9EHf9oX0aipQYxujSayx6etDkff7GWf6Q9iQ=; b=qQ9j0XJjyOLeAHkRBk4e2Y3Szx
	4KLycOyh8bozBXuDczTFZ8JewByuDN5K0HiE3r9jwX7N0N5R4ZS0bitKKIvBDRPUFbk2cSBBjLsuV
	hfDJCezNtVvZSmcmmX9taZ6QjFslpcA4NiTS5ydDqs9xNO+Kd3hHP0q6Aiw4KRwRNEX3SfdLO5XqP
	Xr2cXMDGwmQFta0McxXA1p5JnAQM3xYsiyCInPCALH+3w0wDM0qLCYJmMn3bCE1YgDCnLYH6/OLzn
	EpepWdbJxLIpNUbo1i5KdusfPK7QyfWL6HaS1k93ZByjjhVpCam4CgyMHGDCvQT7EG56kPz1ddiXL
	kzO8up/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9yoF-00000005uE2-02Qt;
	Tue, 07 Apr 2026 05:17:07 +0000
Date: Mon, 6 Apr 2026 22:17:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] f2fs: do not support mmap write for large folio
Message-ID: <adSTUszGSlEK_IBv@infradead.org>
References: <20260406154940.2407853-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260406154940.2407853-1-jaegeuk@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1185F4000A
X-Stat-Signature: egi5ctuxiwhhn4u5456wpdeexa6ikm6a
X-HE-Tag: 1775539028-36202
X-HE-Meta: U2FsdGVkX1/qNRDiUtcSLXp8pkaUcfZJBOnjIUqJUlZnJltGqD8S5LqplXI+0LDhKknDUjGjqOcfYv2VSmIZBaL1MXfD65fTTlsOPCHOR5/kZv7lJ3pb0p1wEKGrHsa5AQUrVxi3FE9ciQgqko7BC/GaUszZRwK+ofTVv3J8K3VAe/DOEEuJKtgPTNRLwUfxKzb2Sj9ic4GR91AczS/v9uolhWAAGG+LqCxW0ovNta2OK+M3Gmh+txZVACIjNZkzB2yMu7N0hN6sR2WUlLTxcabiD3i8KKeyL3cHZbAkV4qIgce4fFj40PJjAwoV/f2J9iN5lZPh5mTuZD4H9mF0gBloQl+QeMM/EBLl8kGwAMebTg47Yd7Y5UvUwfqSzLN6zaq1pI6PZaoJHYR7tXvKIrw9VCeWouqFXUj00BaY2iKTH2Z0xFB00Y+7nuj+ubv6OOr/7FQ0OHVJA34ZP9S3EH/jZSvCzatt0legT6hnE94G22QJnAsCfgIwEtx5KsgTAfo6HRFcCaY3VmQ9vxKXu/WtK7qcFr163Xn8DqF1XWH8EuMcq/uhuglWU0+K/cmcz4zPPzPRaayacPNzkslf14FbdnE3wm2nCyVk4/Wi4IJqWnVDuVIfRpL57GYqPipfRLuGkdzYl02Js72fUvt4dLg0iYjQV/1dUrCjhJFLmIPdC8zdig/Yh5USUqscBFIX71YDDNhtm6477ZbaT+KAbWES1cAiagsfHV23+LyvC8g9lKW8sdsy4g/cA+b9Ev6OjLMFdmnV5fM8Hlajr2Qr5wdYU2sWOChxvAO7umgNe7+YGho+sIDj1vMXDPeAb37juVCCoDUo8IKgnUUCZnYbo+0HdjuUfVXDUQu7rvoZPVEGUcnR4Pp+31P/t1VAZXe+kB2NGuyoJ/6G69MsMMG+GKJJeBhQQkMRbDooQa8GaLvOTs+3pd9hrvMmG0u9ZWcz7n/PtVhsqoeI7JQM+sK
 AH6Jb6xP
 jW8ukhQIzz5OKdVnM5K1Vup717kwQzTptQ4LAye6tOC8V9eoDvbK0gqOiCPJj/gRn1JyRPR7PQJCEM7IXUcfMAZJ9/C5HO00JpLsRPX4kln9/yqux3bFnnL2StIoqf64u7FbV7+TVG9d6RClxi+0yUxq+wsrcqPWlXR1GgmMHzdv0b8kBY5nSCFHfqTcadAI19xgNOjQ0ePOkzuG+WErc6oExMLG2WLwpwZ7koiBimrTVcj12pMWecwTSoMNnlcEFlH936kHkbUIbL0CfcXEsBpyLxNXmtEgHPdTZl6ei7vlqvWFs2aQF/Sa6jQeNQmuc+G64y4VCJISBBIFV/PwGPv/3JhVf0LqemAiFCzfTrUg0WJBbmaQsGeOoDc9fuMeyIGb5ukURIGHdUxubGJJvfiVHECpUYGYAH8wXJC9yhtHDaD9kFsK/pu+bopQEW6aINTRLihyWUrhP5dsCyHAb128J6jaZLNgHChDvlP1wcS+Lm29m3MarJVl0sYAZWD+TzIKzJhfT5tuJdRs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 06, 2026 at 03:49:40PM +0000, Jaegeuk Kim wrote:
> Let's check mmmap writes onto the large folio.

Why?  And how is this not breaking applications?

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index 2c4880f24b54..edfc3a374c40 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -82,7 +82,7 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
>  	int err = 0;
>  	vm_fault_t ret;
>  
> -	if (unlikely(IS_IMMUTABLE(inode)))
> +	if (mapping_large_folio_support(inode->i_mapping))
>  		return VM_FAULT_SIGBUS;
>  
>  	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
> -- 
> 2.53.0.1213.gd9a14994de-goog
> 
> 
---end quoted text---

