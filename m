Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7DFECCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 04:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 768EB6B0088; Sun, 18 Oct 2026 00:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7194A6B008C; Sun, 18 Oct 2026 00:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65B2E6B0092; Sun, 18 Oct 2026 00:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C22C6B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 00:31:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D61716046B
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:31:35 +0000 (UTC)
X-FDA: 85334473350.18.CBCCFC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C432E100003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:31:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mb9BXWxt;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792297893;
	b=Fe+37fDJU4TaytgB/ZQXvVL4eDt/ZoY/g83oCuPRkzxTQJv6aa7jC3LTC0Exqktuo5eeTX
	CwFKP76o2JhofuM2NuLtP6JMB0Rj0QzIBuR2mLD3eivBdxQo/xeNGdnGeAJl0n7EPSJMoo
	n5CpRu5XGJ9Mm3G5tRtveBCNp8Dp7tA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mb9BXWxt;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792297893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYBq7xeKvEEfhwWtcg1/NmSK9WIDoGWbifeYKQ6iaPU=;
	b=EgKkoeiEOIoHfXK1FCcmkR4oUH3ISMIpN4DBadfHO/81Xtnhr2P4NzyY0fBsik8GMGh0cY
	nO+bXU61g/YkqJJBXVjkEXjeQxAjWN/8Bh0nGgiwEcJYwTp1mEjK3cuC/YQLWYTQnsJWFJ
	veatqid3rfVDfbiF6KfMgKqYn6icA9A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9610A423BF;
	Sun, 18 Oct 2026 04:31:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750251F000C6;
	Sun, 18 Oct 2026 04:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792297892;
	bh=DYBq7xeKvEEfhwWtcg1/NmSK9WIDoGWbifeYKQ6iaPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mb9BXWxt88MpB9qYnzbH95e1QrRQzxEiEgi7/2F/8hxj4Nvv6oj2/BHBk3Qm4gqWL
	 GWeQP4oq2b0cRa2vq/YWt+VON52QmcgZEKdFhblV4sG21cPhx+3wEiJL7g1rSNBGWZ
	 DOZEbwSUVAdSZaOr+LHmaj0c+P27fOkNdwnZBKUVKBPukBo5ykBFnYtk4P3++breFR
	 YZGcdhdHz4Cl+8ot9hRaARiYvlfxC5HqpAX3YTCviIkNyGZ8iborIKNboR1PAQKiyL
	 zuVTGaL39gigLDweKWhWXmrbSyUlNv6nhWP+3qMkdZIIEuciRIZYaqsahz6mAOn8+W
	 LWEfQ2qVRcwDw==
Date: Sun, 18 Oct 2026 07:31:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Federico Parola <fparola@amazon.de>
Cc: stable@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	nh-open-source@amazon.com
Subject: Re: [PATCH 6.18.y 2/2] kho: free phys_bits bitmaps using free_page()
 in __kho_abort()
Message-ID: <atRLncxeTcA2dRD6@kernel.org>
References: <20261015144529.76911-1-fparola@amazon.de>
 <20261015144529.76911-3-fparola@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015144529.76911-3-fparola@amazon.de>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C432E100003
X-Stat-Signature: ckp516s7pujuyxdwky3ktopa3ikbprzs
X-HE-Tag: 1792297893-345795
X-HE-Meta: U2FsdGVkX1+rEkfWEVOdGqrJPZAq7NEW86vK9b+pM/+rKTz8/S7D/7MyaluFZm1ZC14gZ5dm60ZeGfw9XJJS05XAp0DZfri+86Jsw963iQYpgaOqw26/i8PwU01YPHb3loSeYOoy2PlIbDipCCv1Tszv34KnKhy2dfaGSHyI4XQfad/mTOvUzADTlCuTdae3k6B94at3ePeXEGffEDKfXr1RkLTaG9QE62CfTrL5wfc/+Nf+Aaf8vw5YioJddbmY3wOczy+nJr2weuKbQhkXYj4G9J3Hz2JoqUotoKXARlMwedFsXesiNzeG5nt3VjsKuB4afXxVm3WtsIXkkE1PVB/bA0nuZ6iuaz2YM/uBxv0Wj9lCsBkZ8brOWHW3rCF/YaqcOPvFAwWL4YZvx0t1OMhUpimp6hm6NIe/hj7vewX2CSvzh5vbiUS/FuDG5Vnf5cpEgP6Ap02zEOQfQUb7dZQ+OYMTDeUenjgyQkphj/4rUcCZO8qC/A9iCA8NPtFxcTl6zDkNaOijzWQw7qoWXJ0ZDgF0p2EsIdPmacWvob7KUJcqZ2YDOYX/Sr8Z/VkhlUJJANvZnBfV2cW+rgFOQPV/hH68hZMbtKabPTEUVaKru/LXlKtX6hN2b0W66fMSPIXCQklfq2cXlMONjpbYZiHPBs2f/1rUmhcERHjLc0lLDvgFWPO1rqWn0PbDb8gVvYBtSyzXQRYPEcYuhDMwZ2pOA3OTpNm+Gw6SdN4rDTRyW8VcMy63TWAv9wl5QPwgpKUClrj+stTsK1/k+2sObgLXkQAdQghoaOyTmXms3U/j2a+VZiMCRjWf2mqTVhUfeKZYgp/yd9u6qF+tiqmWvcShyu6RCY8qM6UiZQ6h7a/CfAnq4m2p8ocBdIcIyq1U0FGD9Yhpw1KaPQftZFXY+k/eNZcgtIbN1E84ZptTtP8dFXVEalELj2VjLgwScT0MuzAnINI/3bDJzKMgTY7
 S8r+RAWg
 Op2JJH20MOfr6AR8ZdIOqPSyGhFpBBcyqXXrNZGp3jun8lSibCm39aHPcEyoDTPsyrIlid+zLma2mnRXZyWrvl7FKmsZHIRX32/ea3vDhN0IuU3cyZuwn7FW/ISEM9Fj97Y4jWsvPD3AWjj02popu3723ZlvFqfvwMWNJm4psGTkfFEdWjpmAyGrls7/rDciyWhUX5DfYIl3fridFIRIEO0fehZFnnFJ3FqS+lZrX8Z8/huZUVG/hrW5FVDqIxmlAtoZq585B4R3w94SUTsuVUnC0mE7nFj6L0tjVBKHYiN/UPzbiCJ/DNXIyeKYqbSCiLhFv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 02:45:29PM +0000, Federico Parola wrote:
> Commit fa759cd75bce ("kho: allocate metadata directly from the buddy
> allocator") switched the allocation of preserved memory bitmaps to
> get_zeroed_page(), but __kho_abort() still releases them with kfree().
> kfree() on a buddy page that is not a large kmalloc allocation hits the
> WARN_ON_ONCE() in free_large_kmalloc() and returns without freeing it,
> so every aborted finalization leaks all bitmap pages.
> 
> Free the bitmaps with free_page() instead.
> 
> This is a stable-only patch. Upstream fixed it as a side effect of
> commit 99cd2ffac697 ("kho: don't unpreserve memory during abort"), which
> removes the tracking teardown from __kho_abort() altogether. That change
> builds on commit 36f8f7ef7fd2 ("kho: add interfaces to unpreserve
> folios, page ranges, and vmalloc") and commit 70f9133096c8 ("kho: drop
> notifiers"). In 6.18.y, KHO users still preserve memory from the
> KEXEC_KHO_FINALIZE notifier and have no interface to unpreserve it, so
> the teardown on abort is the only way their preservations get dropped.
> Backporting that commit would make preservations outlive every abort,
> so keep the teardown and fix only the mismatched free.
> 
> Fixes: fa759cd75bce ("kho: allocate metadata directly from the buddy allocator")
> Signed-off-by: Federico Parola <fparola@amazon.de>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index 9fe5d14f1ec54..9691f6bc2fba7 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -1054,7 +1054,7 @@ static int __kho_abort(void)
>  		unsigned long phys;
>  
>  		xa_for_each(&physxa->phys_bits, phys, bits)
> -			kfree(bits);
> +			free_page((unsigned long)bits);
>  
>  		xa_destroy(&physxa->phys_bits);
>  		kfree(physxa);
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

