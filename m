Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 085F3606A33B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LrXi9y8X
Received: by kanga.kvack.org (Postfix)
	id 2E2686B05D6; Fri, 20 Nov 2026 03:20:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2931D6B05D7; Fri, 20 Nov 2026 03:20:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1819C6B05D8; Fri, 20 Nov 2026 03:20:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E99206B05D6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:20:19 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7724AA0E02
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:20:19 +0000 (UTC)
X-FDA: 85454800158.30.CA33ACA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A69F81C0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:20:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LrXi9y8X;
	spf=pass (imf21.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795162817;
	b=Ek8JInR5a+maSTQ12cU24gX3c9T76O9OQfT0deW/uSnM+zbsQpvzl1Le7remof1x4bya06
	iMCCULCJdoAkjpmE7jTLuxdq4jDtrJuPywVCM1IxIOxw0dUKmblw0jZrN9i/by6JrXcuq8
	z2m+uk2k3SmyCm+0eeD43H01Zc612BY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795162817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YrezAQ7e02vT8+Swx+rmAAedFzytCEs8zwyhSyPMrmg=;
	b=0vbd9LXYKrIMmkyieWjsm7+9snxySuDxYvWC4lW2zpggF3xGeQx1tOZZYz9tmmOcT0YrhD
	Y1rjXFyhQQbyxAafhQ3zbZB5WcGQj5FrPJvfqgA5DZ61XP6pGPm3svub3QEZ+kKLJroeB4
	267bztZimE0kBvFKILKrBCKGxzD/SOA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LrXi9y8X;
	spf=pass (imf21.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC5CF43B80
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00BA1F000CF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795162816;
	bh=YrezAQ7e02vT8+Swx+rmAAedFzytCEs8zwyhSyPMrmg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=LrXi9y8X8jjdE6yEgzJwcgu1p/UOdN7422Y+PduJ7Jxvv8AvYxo/zOir+iF8nLXpQ
	 Bkrxa51bADXUuwK97jo82FLdKcYZFq6ZEoQhKTFyk5X91tOkJVoTpv55aLahVARV2M
	 PntYTTvtYpKL5EuTFZcOPrcPN2rAAf4XaT9BkfVbTJYXcE8oizzpzG+3jxR4jK1OWq
	 4X7Lk5xyXAQpx2QJAsfnQ8EsjYD7UeZT3q0CAkm/gotPlAiEmkqkU0GWN2Y1e0sYSv
	 wF9XcfoLYPsKIXJ3jDeZpiAeQ0xvv0ZwDgkmv9diOYcxRviZNkwgSG3OmhFI7p30fC
	 pv7pwvkf3GnGQ==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b596afb4c5so677425a12.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:20:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHCBGUMfcvXdFdoqpCuhsLZMak1YLQ0fvBiweKffXmmPKebIfWLlL7yaZYnPxwb37ri1m+6scwueA==@kvack.org
X-Gm-Message-State: APuU4Z9/x1LRJOejX5WYDhF4U3onBiLuX5moDRc/LVMiFOPZx51mFrao
	KwlZqMudqOltpw6ZfiIoZYHt63qHvken5508FvQTAwCfmmivUdG1dt0z6nAHMssp1LhXdxpBFvy
	Nahltc3CUyalTIkTpMCgC8vqkzHByTCw=
X-Received: by 2002:a05:6402:3608:b0:6b8:77ad:62e8 with SMTP id
 4fb4d7f45d1cf-6ba37ee17c3mr1286897a12.44.1795162815520; Fri, 20 Nov 2026
 00:20:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261029172956.20791-1-dongtai.guo@linux.dev> <20261029172956.20791-4-dongtai.guo@linux.dev>
In-Reply-To: <20261029172956.20791-4-dongtai.guo@linux.dev>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 20 Nov 2026 16:20:06 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4A8gYGEMkbPk6MEkjLtdEe4OFwBUkERvdpXjiXfriuZw@mail.gmail.com>
X-Gm-Features: AclHuK-h6bybNetTU_MMXuMJwO3eew7bSt_laDSgKQt1od1cbyCQa8XfhqZT6Vs
Message-ID: <CAAhV-H4A8gYGEMkbPk6MEkjLtdEe4OFwBUkERvdpXjiXfriuZw@mail.gmail.com>
Subject: Re: [PATCH v6 3/8] kho: Include linux/mm.h in kho_block.c
To: George Guo <dongtai.guo@linux.dev>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	ardb@kernel.org, shuah@kernel.org, ilias.apalodimas@linaro.org, 
	akpm@linux-foundation.org, baoquan.he@linux.dev, ruirui.yang@linux.dev, 
	guodongtai@kylinos.cn, kernel@xen0n.name, graf@amazon.com, 
	liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A69F81C0005
X-Rspam-User:
X-Stat-Signature: ad7qfdncf8pkyf5yztiwncbzxcgadxmq
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795162817-864504
X-HE-Meta: U2FsdGVkX1/U0bUd2rrmpC+oSF0e5vHgROBVoguYWNaNPCncA7naav4OYjnFCTNl3fsrMWUo4yowGHPErbQ8Cfir5sUbD52OqY8DgFLeKUlt1ryRifnLL2LjYItP+2WfcWfmzl2E9d1SmkZPF2vHi9QWCMRwgoT092eLRcCSzoWiwivjQSKVhz7k4jryUFB+DG/cKUxasmUjDObSAQO2uae1io/jwxAwZ34CWWQJ2dHB9TWF0gFuic9LuNtvpf9c6L0ISyOfbHfEnhlrzllH92bsn4RpXMF3t04tM25HgCTiWoAmzssGb5sqa+v9VOFqrAourFll+X+a8KvxvRLxNBM8Teb3qoJv5H2v0L8ZxU3h7bi9+QoWr4uloXGSl2IMi5mF/+DxbZBM7cHZ+Nrl04FiA6QvxFlGM11o5zMKz9oAdZW2EKZpvIcqzxx8FJhp9scLtUdzmExnWkP1PDa0HbajIeb99uyUMimT9XSGQQtD3NjenFni7Ddf1l+gEBZrbQ5sn6+3nyqLHR+sMxfl0iMDJRHzOwstEDqt3Eex7JaIfiB7ECMWYPXPafua6jtB+GYi+giLRCcHdzv0elI0hm9F4EftUHMZKKue/NuIffQJa7OkvPo/dzCh3U8gKnk1lQwpcJUkIDr+09hEZA1K3Glx6QAbbsvHPwe9oMyuVuHAQxft4Mmyzd1xEV2eQIjv8g0RhJrDCO9yhYQbXFxM2BYyWucux8KoSjSJMeRkvThWH3KHfNbVjORpPnpld6ZGcT8yGriYNB4HqFLu6nvFcPu2Mx8O+E7EphZ5Y0+KBxDiednbyrdPGFKUOjgNy8qd9A4kHeModrRFknxBFzME94bxHGoMstB0AxXTRN+tKwDNwe5tJQTLlgAzTQTTr5temg6/X4X/sfNehKKVi7BD2gm4U0fyCOMlAo6GMyTtwxcETqgYrPscnCpp9siySVhDNoXObeLr4wAeZiO93sd
 OC7HYDHw
 YTn4SehWEWhjG1DRMkpKXcDKQzgrsd0HOrc8SGZdPMgHlDtY3XHZkHKA0UL5jXW+dXyqE0Hry+pTZLnY9ULKIWWqgMVFO/MczV4dzNSIpevzsUKcl9N7wVyZYa+X1lauBnsbPI5oLeeVizR3HvgjBxgntVSRH8apOqLqlBdZAJ8ned9hdPXhMe9K3pCh+9hvJdPuBIKDZubMfVJGx1AM7aQeWGSQcXQFECYO3zuaXHeZf6D90pF5kaQ9SktcOlUGofL7TdPbFlWqj5IgS4QThZlcbzmeymALE1hACrjeuKCmHEbnTT2dUMY6z+r4QJCBJrqGDJprcckolkFaYp32ZxhmWcs9Xjnp8tFWxupKmg7e4DFzMNOfqvpZpJCeF9Pkp+c02zEspYFCZB6onSJimmTc16+/QVQgLoB6Mtl1Ymt8dktc0iWVYxl1m+zI220KaS6da22Z+1F6pVWwQbxHunkpDX02YMGzI+PbIjbVpSC1fSI1dc5nnkgoGbFcd4YGWx9SsXQcgoBP3m4xBNVlwr/3Su8UNSPhiXlScoq6cqC+W7bHOXpKKVrsCzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I have applied this one as a preparation for others.

Huacai

On Fri, Oct 30, 2026 at 1:30=E2=80=AFAM George Guo <dongtai.guo@linux.dev> =
wrote:
>
> From: George Guo <guodongtai@kylinos.cn>
>
> kho_block.c calls virt_to_phys() and phys_to_virt(). With CONFIG_KFENCE=
=3Dy,
> the LoongArch implementations use offset_in_page() and page_address(),
> which are provided by <linux/mm.h>.
>
> Include <linux/mm.h> explicitly to avoid implicit-declaration build
> errors for these helpers.
>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  kernel/liveupdate/kho_block.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.=
c
> index 0d2a342ef422..0d56891b2f4c 100644
> --- a/kernel/liveupdate/kho_block.c
> +++ b/kernel/liveupdate/kho_block.c
> @@ -25,6 +25,7 @@
>  #include <linux/kho/abi/block.h>
>  #include <linux/kho_block.h>
>  #include <linux/slab.h>
> +#include <linux/mm.h>
>
>  /*
>   * Safeguard limit for the number of serialization blocks. This is used =
to
> --
> 2.53.0
>

