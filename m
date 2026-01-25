Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4298E63CA2
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 11:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5D66B0005; Sun, 25 Jan 2026 06:51:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 173C76B0088; Sun, 25 Jan 2026 06:51:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B3F6B0089; Sun, 25 Jan 2026 06:51:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E6D356B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 06:51:07 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7658F1B03C7
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 11:51:07 +0000 (UTC)
X-FDA: 84370320174.02.353CD92
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id EB5971C0004
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 11:51:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q0ZMoQno;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769341866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsJsCT1Ku+2oSFFgQjz13x5XOWTJSyM0K4XxyQtDjQ0=;
	b=8NpzqqdQH2Hj1xYwcPSGTCi1D3rSv/jdosANt6QKPOrcr/aHT/mCZST7gpKU7WyKhNchux
	ZcdrKNIzMFyYqXQis252P1fSZSRKdoju8umVoJ0q5CXwu7+ClVrm1duiJgcd9j8u8raaTn
	ADzbVyc3uI1RfYy1taAQ8i+yTcSWUr0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769341866; a=rsa-sha256;
	cv=none;
	b=dn5tGFbIHyb1gCR2oN9BlGaQuFnCAcB6JATxPFBUyN+/l4PQVvsYLnQSSOftjtBhQ8QmBz
	LVNpKOdW2vFZpmr2ssx2kiQknzJnOly7xGrv7gO+EJEHZseRnGykOxrq/0/NCTwBeYgISf
	mS3/pdeB9YKaDQPQd+PRBpWgSp0cjis=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q0ZMoQno;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABCF742BB2;
	Sun, 25 Jan 2026 11:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16513C4CEF1;
	Sun, 25 Jan 2026 11:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769341864;
	bh=6TAiQebVh1oHpaGV4OnDP/LH0lIQ9CGxw6VodtIwayY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q0ZMoQnoT6qLr0kWpr2fmisUihk0K+he89tFOWATBNMW0H+/p5iE0vjMW5LUKLuBY
	 a06+SfVmC8JYdAbJKa60U5rbi8DgEHGil9QfJD88bWZRIEzYyL4ysQxALbEc1Bkp3X
	 m8IvjGt6dOE8edZHeIJI849An14dyi/Hpe9AgYOS/oNKWODUAgtolCSeOMv6mWEaKV
	 Jy49n7cfaHoj7ifPB+YQAbxSfF++0gxnizvxkyQql5453LypHgWfY9n8FAhzuzuNzI
	 Hv+u8Yvicv/m+AxetAHAPRSiUCPP/sSR21D/lkRag1expC6f4l5FXi081y6E/o2e+b
	 EdJx0kPJ25/kQ==
Date: Sun, 25 Jan 2026 13:50:58 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tycho Andersen <tycho@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: fix doc for kho_restore_pages()
Message-ID: <aXYDov8RruYZszaQ@kernel.org>
References: <20260123190506.1058669-1-tycho@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123190506.1058669-1-tycho@kernel.org>
X-Rspamd-Queue-Id: EB5971C0004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gpg9dgw4ckebxmqkqz5mwazeuczckjrk
X-HE-Tag: 1769341865-528778
X-HE-Meta: U2FsdGVkX1/dujvrFl5V8e3ymVWQx6pAq7e0JcEwx39Yq6qyEXEh7o0a3jNO82Ra+o0Vcut5s3sUfdyV2YC12VoFyfA11tHbqBHuMuYYDYBKvdqwgNjGDEqVPucZh4x/hplrosRNxno09aRzcNy8+uzh+ZwJOFWfd+rwKewfylgTUxbhxHSDWr+F07YPWUyjAFZEHdU84DbyxFLy4rjYL7WuycDFajhX3YjU+XIMSZ2DxZwvY1d4jWk8KeKN3Fm379IHldHOHug9Y24UjjAYdhkwYqwapwJdOQtnszp39FfuKNUwoY7G3Juil6FdvoY7H7vKu67m4VOsCsbsqTsZNxFBFk9Q1BBX+mXxylLBwCHEAFZgIvafEpD3ku6z3q7zaRg9uId1wP05/5Opkrmfs5rChLV3zoCWNylSX9v5VydfkziglkWla70UDIYlPUM7T8VWIYZ8sev0glfQVadn350/lSppub/OkPueNDtlDca2YP6Lfc6cBAUyXfyEOPGRCozWLPpCej6vF2NaTAHLJTD8DN67AruMSi3OrqpdjpN2rB0E7EuHBWxGJa3wdK8LlZXW8cW097V0twk0J3mc2UVArO/OFS6rEI6oSnaXGburS2t2GrVLOh97AM0X4qvgu5GfEBKZioueDMIFZ9ogKYhnGqVcglq/Jdhg2tbgXXnY7KH6HFuNjLXta/JPPANidPedYkvYXpNDqQBDGCd5ceomo8V2kmoNSABME4yt8+31jluCBBe2l9Mb7hSqufUSmRUgYGsEBhgi6qKcq3S+qwNdd1+7HJqbFLlMRnHIRDFPgIjgR+tsVXDh40oytyOsQ/LTaDblXduUSJhZbDqw3dx3p0QWBSdNjzhWgIhChFc+B8MasMOXsYKC6vUoj21nZIeoI5lczwUtmP+Lc/H/QpwSRJq2W5pn+fere7QfmvTYpmc1KZmDFOGJo6RyTGj/BEIWr1FNKDk5SEj/K/R
 kwiq6RcT
 Nq45X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 12:05:06PM -0700, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> This function returns NULL if kho_restore_page() returns NULL, which
> happens in a couple of corner cases. It never returns an error code.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index d4482b6e3cae..4c38ea7987c8 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -281,7 +281,7 @@ EXPORT_SYMBOL_GPL(kho_restore_folio);
>   * Restore a contiguous list of order 0 pages that was preserved with
>   * kho_preserve_pages().
>   *
> - * Return: 0 on success, error code on failure
> + * Return: the first page on success, NULL on failure.
>   */
>  struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages)
>  {
> 
> base-commit: c072629f05d7bca1148ab17690d7922a31423984
> -- 
> 2.52.0
> 

-- 
Sincerely yours,
Mike.

