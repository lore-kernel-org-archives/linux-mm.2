Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6904EC43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270726B0100; Thu,  2 Jul 2026 20:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249786B0115; Thu,  2 Jul 2026 20:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134276B0116; Thu,  2 Jul 2026 20:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA6796B0100
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:43:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE21040149
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:17:33 +0000 (UTC)
X-FDA: 84944190786.25.FEE281B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 28503A0009
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:17:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PrlL1zVt;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783005452;
	b=EJgIdLaO1uIoz5s51IfTvtIx9GyNxgByAKNWmiFeXdi0CEJzzMLP65TrBTxo9rpdz3mtVw
	LqFlRa+ugFXehIurmZbVaOPRVoOQFiJ2ifQP0LCcnQZkiIiki6+cvEsKscTdXXzgucsVIu
	fPeqisxVMBsQHI6wD3um7fREOWNr9ec=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783005452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7IE1cTP8gYIjzStVQMnbcLaVaQwalgnaExPeatrYk4=;
	b=T36mvfyAZ32srm/svHbKG3qsOW70xF+OoyR5zra9wVCDMsWk/k9qVmdfOuaaLrdh1cwpXM
	VWiXBEeyGAz2mGtixrVMFgFUIISlYeSR3CC6va1JkomiA+V4xhB1IOsDI0L+/awo4uGE8k
	xkZiecDQYm9jxzeZhieeF+7xmCsXnXs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PrlL1zVt;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FAB440DCD;
	Thu,  2 Jul 2026 15:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734E61F00A3A;
	Thu,  2 Jul 2026 15:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783005451;
	bh=Y7IE1cTP8gYIjzStVQMnbcLaVaQwalgnaExPeatrYk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PrlL1zVtDvQS+Yqw7s4ZMpuYEnktktCRL9+9F0oyngH7XoCU9pBAqSsazkA15Muj5
	 3WuYYhl6+KwOle8yrBMwAWVl2HJ3IHAWJdYgBtwRoAnoKHikOpWLn2C8y2DWmEq/sk
	 KmM0io/yeqDKjcOtg590ivRWr+q8BD7FWMZsS6jeznS4jSWw16nrRPLthbc9NfKD31
	 wDOltWqFRelFDZRCy7eCed17nDdzQJXu3HmEQL0U+rECZZvuE43MGOf/o4VcN9iKjO
	 g0EcqrYF2ne/n3aasmeJ+RgRysjdpJJF1iZ5gbW1NLJabN/U3JcAXyTz68mJG+9L1y
	 08O/KzH7Hf2og==
Date: Thu, 2 Jul 2026 16:17:21 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] MAINTAINERS: add Usama as a THP reviewer
Message-ID: <akaA349aX5oCVcyg@lucifer>
References: <20260702140257.44780-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702140257.44780-1-lance.yang@linux.dev>
X-Rspamd-Queue-Id: 28503A0009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: m7ytna9zmou3sbhdkwmybhx81h7gcm5y
X-HE-Tag: 1783005452-613089
X-HE-Meta: U2FsdGVkX1+JVv/fAHXjM61G3LR3sliN3laS4UOH/7enXtEPeIzkui+A/VxfYOqfIE6OK4N/mXvWVs2tF8EzOTLivILjd7YhnxMJunm25X4e+QBad8PVQOlvzsgCf0Gyn41bxLM07ERHXPIqyQGT/T64CP9qyLFugRMXMyetvXQ3kgjFJhX1QSx8G8KjILb7AotGGNCLYucm95CZs8kaDQLSYqldVQTz5jUvuQtkGH2GuV5Ja/9zROxTGKv99zxX6mTsMf+Wfm9DJWmCQXXmaLY54+uoSaR+9xPrfKDDCm3HRW/eNFhhDkI5JaAA6FCftkG0iIigkGwEsQbTVL1Tt0o7XJQ5jcj4VtjyPIOC/j5uNSuQG7rQKkIwSfIG62KlEzU2jY6LxnRPGWLcw6Egd6Vtl8xfqcANC32NDMn/1HjmCWdmOTGTCknM6G7uS1gTjxb2dI9cS3AVKHP4ZYaJyqflg5q0EE4oecTFVK2Cr5EQfX8qsIjXux5YiWVF7cPdqsmbXpf2De5I2lw7EnL/FhKyvMAGPFaMV7XNldX51gC1cZqscN8qZkp42ihPWSeUFDt7MyiBXi6MRfcKbt7P5nvn1FFpha6qUD6Fe6APQ3QRi8LcCKkxRtHuLvdDY0abMZ0FQK8Rfdfk2BI/BupT/8wE1gcZ7JIsOlfrDXtEm8tW8aSfeN2uhWh+GrpjGIkFbuMM6Kvdtx2X0hyQxHGSM69voRGZjU11pLHknWhZQq6LlE70GhaB8oechB9ulOW7M16+jC9Otx/JfmtRbYZ2fzjSCONRRO9EWARcDL+G8g2lHWgf/xjQzj0t371qyC+WCB97FeFqNLfeRo3Uig3gr4ykkcqDhQmuFqRw0UzAGi2VobQbTbKVGhhVxHAslExLP9ALMy6qfq2V+/e5t5PiouaKxxrvLULKOUMuKNC5SJuHHRfPaUiIsfPkKjWX6bne6oWNr3WmHJaXlSqTXay
 1w9H9Bzn
 nqyDK0KN0Zg+Fga/mYFB4+Sekt/06VrnY+UkwuX68lWJahI6/Ybgzz+/PAvzNdB+JSDaBw3BUC6iExVhMJRgBr8lxsahGEDfSIV67lM67vmJhAeph5ZXALnKMDazpHetfmoUe6XLmBJBztQlAvl+T7VSsZK0epwe1eHVx3YJ06ThJlopku+Utmk4RfRpHYN6qHDJEk5P8OuiPXjvEHZlCp6iACzxoJ4JkU2DIGdk9+Cu4J/sJITlTEl1WMEA/qiHmKOMJeXdPj4aOG3oUa9jB7ZuTdACUSaYqyeMHMUqr6TPjiQOXEyzfW0Dqkz39PBj62Q7LkW6ZYkJB75jxQWKK+8xaXXmYzXg8k9jw1M0WzXl/8KY/+WYfST3jLZqihKRgSzakNrA6aTjvYUTnFInjyhpdFI6obn4taN+G+tRiJGkWJ4I41dlllXhzZOv7YxJiYKwdK8YK/yZChZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 10:02:57PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> Usama has been active around THP, really enjoys working on THPs, and tries
> to review all the patches that come in.
>
> Let's invite him to the THP party as a reviewer to help with the ongoing
> THP review load.
>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

Sounds good to me, thanks for your contributions Usama, this is very much
earned :)

So:

Acked-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2acb019516eb..29c302e9c17b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17255,6 +17255,7 @@ R:	Ryan Roberts <ryan.roberts@arm.com>
>  R:	Dev Jain <dev.jain@arm.com>
>  R:	Barry Song <baohua@kernel.org>
>  R:	Lance Yang <lance.yang@linux.dev>
> +R:	Usama Arif <usama.arif@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
> --
> 2.49.0
>

Cheers, Lorenzo

