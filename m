Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C652EC5DF97
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 02:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821926B0095; Sun, 23 Aug 2026 22:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F96F6B009B; Sun, 23 Aug 2026 22:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738346B009D; Sun, 23 Aug 2026 22:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 527076B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 22:54:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8FCBC03DD
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:54:25 +0000 (UTC)
X-FDA: 85134644490.19.C6B38EA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 00F84180003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:54:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="I3Zhc/oD";
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787540064;
	b=7zOSbzqxIW2A0RAg7q5AIkXrwjxMSJQg/Uewq34p1yQJCKd+MPQzGvOzAfLBBT4WXvVo/M
	hvJGP4f7o5HRQcoxHlqS/Q+Y0ZoOzSVon8VM5HYd7MJxzp7d6saS67bkca3h7WickKpVON
	Zt5Kdd5E+5W/vfjNSvR+s6C31HEpXAY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="I3Zhc/oD";
	spf=pass (imf24.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787540064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFdw7194L4fQEjhILHsILl9N8tSIJ2MhybMqVmE6L9c=;
	b=jPbMNGXIBQqAxmaI/AvfyRCJ82kq6BYq8TzAkhpHQvK61X7sBCgqhNLKVt1C0Ch5sl65dH
	uGoMlBGRVDtlX3ZjPFG2cSmDfOR2FXwka/E+wZnLTi08XRC7kxd4hKEmAkREFVWBP6oHLx
	l1muvTDTmDKTWdo0klSW80J9f3qU8e8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wFdw7194L4fQEjhILHsILl9N8tSIJ2MhybMqVmE6L9c=; b=I3Zhc/oDSZneTHNYEcBzwB7KwE
	IgYOz6SYVEGwUZ7c7+eWBOnZo9sC47x0//cEJTiJNJimNS/yaFJIEj0kOPCEbCeNSJ0qtky6x5nRa
	8kHHPfRVtdYOjj5aI/fxWHSDypOawBjXjd+asw8mys0PcX0Vc8c7XASu1eZC3qt7PngTkkZ1nxzGq
	kGFkdtg63vEEGnjaeuYAAjTUurHJDo9mnW0ofEYxNsVvKEDXbmjuJmOWQDs494gIsoah1JWuQpI4V
	bWSFipWf2u//ng+3KHQVKsJz5ZCxV+BBUkaRWYnLJlRC9uXFWliYif8pg6/7QrH+h6mNhuNuBaefT
	o8m2mUFA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyKpG-000000058gY-2yd1;
	Mon, 24 Aug 2026 02:54:18 +0000
Date: Mon, 24 Aug 2026 03:54:18 +0100
From: Matthew Wilcox <willy@infradead.org>
To: LongWei27 <longwei27@huawei.com>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	hewenliang4@huawei.com
Subject: Re: [PATCH V2] kho: Convert error handling to immediate return
 pattern
Message-ID: <aouyWs39qxGI7CP0@casper.infradead.org>
References: <00c96a62-f783-497c-a7ac-1de495e4af06@huawei.com>
 <20260824024448.550552-1-longwei27@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824024448.550552-1-longwei27@huawei.com>
X-Rspamd-Queue-Id: 00F84180003
X-Rspam-User: 
X-Stat-Signature: raj893pgp53836jdzeetkmtecdneoeuk
X-Rspamd-Server: rspam06
X-HE-Tag: 1787540062-692769
X-HE-Meta: U2FsdGVkX1/HVzhIzbf2G2mKIBqyYntAc8hh4Vr/CdcBcocpzagCD6ZPzdfk0uJwl/cEpPIG5OuQ/xXHLFpD//bUW6gza037mJlRKk2Q8rBIqOroLw9wxOiLf1T4oTazMVbUViBV0McZBC9rzjY8JzKEoQHprSj6Pi6AYCIaGmYMn7hJmQ/YPKj0xczzkK12RH75e9XiUDYf6ExNvyvvhwL4zdE/8HnpdWR/fCxt9ppWkwepOvqkzenP3x9M4aVabP6SG98ecvwnxCYGwYzQr8YDsKAjhu/itjQ7TlWyDa4831Vz2j04NKZd+D7q8KRvMtxU/81B6RyyaLlcAq9/iMFRX2CjsZ5opdHwHMpFULQ9Toao0sJMO6NvOykLz/1C4MvHsYNPxwqZKRDFtjOslA6nwyou1um2ArRwRFXPutBPQZETwWdGIWj9JI/NSBJnUhrXsEWURV5V1tZrvM+AfAMp2slea27yA/8j8cDZcGOtGWUe3/BpeB0ra+EONCEtngvKL2sB3qUAwCCeUcEOy4WKrSWqwSegAS300NwcP5o8us1Y/1Armug2rg5bnVnY97ibEUCtmYWE+KuuCQq4p/ygXLd9pxtk+eqT3dnoofRjEPY244fq7kjw6dWaWyfQXe7ZIwP20uAfcsbjvHFK32m/M7JG6P0XWNs1WFrqCKtu/x2OPahgxeUiiVpxNPx210TPSxjg0o5F/gcJjlhEgI0sof65g3aVi3kT5fwDpdoAchsLejDyHkkWASlBVORBWw+TbSUqfPdrp4UhOTW+NTwJ2iQy8SL0IVoDfATvzlZoe9K5F+xdmI1G/p5500e1rKz4luXwKAdaArBtUt7nFBdbz3O4/keIjNaeDBsaKaCyH3wXPLd3Peu8kRvlswWzb3nqy1rIb+isZRuy/ptYV+Pin4Q24i/oxb7HmiKFtIfTyuptUiK6TWsIqirm91q1xNLWurgYEHI11H8eYZz
 pure+Cvg
 ClwY80Rx58gcm9jv3dOFK5hVZuj6FwnTGIaCDoUnXYmxJ5YDq8dlxMwszLpQ2XmPuf+0MFY88J6elyMzWuD9+iTLVYhtiSEqR8IItEzwj3HljQOfDG0uHXuSBJjOCCBBVbqBgO+fFqjLTwrBgh/NBTaBmG+2qFUPrJn2lw22EmZJhBTynUAOkT5A1+xazr5x/FZslIE9ecQx30l5KE090+MlcOGktYwmuLu7LiGAT8koHcpxW+UGXXz06xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 10:44:48AM +0800, LongWei27 wrote:
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1438,20 +1438,34 @@ static __init int kho_out_fdt_setup(void)
>  	int err;
>  
>  	err = fdt_create(root, PAGE_SIZE);
> -	err |= fdt_finish_reservemap(root);
> -	err |= fdt_begin_node(root, "");
> -	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
> +	if (err)
> +		return err;
> +	err = fdt_finish_reservemap(root);
> +	if (err)
> +		return err;
> +	err = fdt_begin_node(root, "");
> +	if (err)
> +		return err;
> +	err = fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
> +	if (err)
> +		return err;

Less verbose:

 	err = fdt_create(root, PAGE_SIZE);
-	err |= fdt_finish_reservemap(root);
-	err |= fdt_begin_node(root, "");
-	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
+	if (!err)
+		err = fdt_finish_reservemap(root);
+	if (!err)
+		err = fdt_begin_node(root, "");
+	if (!err)
+		err = fdt_property_string(root, "compatible",
+				KHO_FDT_COMPATIBLE);

up to the maintainer which one they prefer ...

