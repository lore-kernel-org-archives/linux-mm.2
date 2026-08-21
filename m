Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58805C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D77F6B009D; Fri, 21 Aug 2026 07:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AFB96B009F; Fri, 21 Aug 2026 07:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC766B00A0; Fri, 21 Aug 2026 07:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15F446B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:05:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A237740429
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:05:04 +0000 (UTC)
X-FDA: 85124994528.14.5F3BB16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9612D100005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:05:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bXA/xwwX";
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787310302;
	b=XddltMAwEHugc+oODgBTTjVxbzsgFiSme460y3iDyDPO4lEJx35aS4Y8OxMS+Xo7Qy+cP9
	IBh/ko5WMpnlzhq9wiJeLRwgqT/ZtERN4llqsxhUt3lYle8yBerht/9V6iwEUKLqHo2LvG
	wqI0wXl1wX+STnKdBtTXwHGFvnbVEcI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bXA/xwwX";
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787310302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCvD1MdzsW2akKjjzWWz1w5C615w+H1/o/P1Mz5Sgas=;
	b=FBgSNO5ZAVLnSJN0Y0XTEjTqbwrdC9r9rWbq54Wi5Ip8tTIT/p13vt64W7dH/WUA+nS0mh
	sQyCC6+VonESu1v8LTjrLcsMtzkxK2kDFtoLG9L96mpjJe4s/94ktjn3tZfIVCrGKJk3Ly
	Cyi0/5XtVW2AEVny62IqGvjUoIEbWFI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D626419C4;
	Fri, 21 Aug 2026 11:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DE61F000E9;
	Fri, 21 Aug 2026 11:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787310301;
	bh=pCvD1MdzsW2akKjjzWWz1w5C615w+H1/o/P1Mz5Sgas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bXA/xwwXn4mlknABhcs+eK/JMOJK6tbygxJOQMNISU2axQcGedUiq+oXFvNCNv9L/
	 vzUAFDuljuxzu/8t0oydhoubTIBLPP6wUYL7BeADjIqaiFHglf/IOQFNKIvvl4mRGU
	 kOJp1+hurzzvo+cMau+URL845baPVGUlLydXRMaMZKOK+eCDNnoIFzXEJY9oV7kPTh
	 PWHSunSaxuBbMgoCpqz2XyO0ndwTytWoLzqja5SK7kFCfOGtCva7Bw+QHs92OZrau7
	 K0olHV4ldLh2SYkjdBHS+RKu5ZV4kBjiTdTHFwlwt3pcpqSKL/4Bnb7nVOz5EPPLAT
	 DfrTxeGm5Kdmw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id DE9AA1980070;
	Fri, 21 Aug 2026 07:04:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 21 Aug 2026 07:04:58 -0400
X-ME-Sender: <xms:2DCIal3BzlUlLRcbUf1WM3l8G3jfkGrsCNsXyuggYI3ebJOhVS4g-g>
    <xme:2DCIapgoWIV8fysXnFo7Fbf4F6UKCP-YJGNKUg4JKJHBFh7F3zLyL5h-7DGTz0YD8
    8nPdiOMNjK5q7Dw67TGT5XyDdtnJ0Z4RcBQ23TQlW7ufF00kQfa_r0>
X-ME-Received: <xmr:2DCIal2UclUQM-TfhqxlJ0XsJiZfpPLiMNb6hdsHGDFLnIDhg2XQKTK2joY>
X-ME-Proxy-Cause: dmFkZTEWM2E58ZDI3GBPHZLDZKPHLTpyhDURcoURdljfk4cH7f/KXOu0wRWhhh9eH1QjfP
    Hp+aXrB4+gX0+3nQ2wUB/0Zvpvx7qc4d6/fk8+4IbRswX34lPo/BdJFV5G0qe+PMX54acE
    6lv00gVtxDmgkIP6CGEleZL9qbWoXqA2tuV52C0yG7xpsMWNkMvCN/v51+Hhf9fW7iEsCg
    hWuFYjNdn5OKp/KjkJpYfUEGv+I0qBpjxsHBdjZoULL4G0EWgCiVun6QBLQ4Z7I97oMxO8
    mNESgb5/JqWf4uBVnaYDM02rPLOn4fEGSZpAAxIkmMXoRT23duwEkNmZ8Ga5IT+v8ho/XJ
    PCkb/fhaZZo0oGr/0/ozdbDPV67SewXLZ9ZpakNXpjAdrdBwRFy+FFPt2Hf3TYa3C5mYTC
    mSmfqEJm+P2jiYXI3Wokb3IFaRvrt1CpmPnuhV33AUFAXTs/MSpZXW7OMtxyIbdNQV6tYu
    BPBXQrx2p7xQAcZwZGycAznwajnw2F3Qtl/nAlWxLxpJnj91KTaq0Ko8/jEJbCjeTCCdDl
    KVtgulxJo8BKttcTC+Yo5KG5o+tQZrkJRkwqA0vRG+6lWRpC67Kj1PdtYZz0eIPjUZrGA2
    RTIwa8c910SS/a9bxUETGsMRVOALUBl/insQ0UaPZevyX2e+/klPyDBCu4ww
X-ME-Proxy: <xmx:2DCIakdSFSnxuxbFUy646Z_3pYcU_JQFsASN4D6sJAP-TMs8JrzTCQ>
    <xmx:2DCIaoEqODzw6s1FL1FnLSsCuRfvekhbFwAJ1HbQqpOQw3ZD_ZwYPw>
    <xmx:2DCIaqowZBgRL8NADKAstydP1-5mHUgpue4ZvUWDj0JXKZP_gT7mHA>
    <xmx:2DCIaqLd6vjFP-EyxxsMYhC_zElx0Y3mLCL6mll6uNeY5PR-YMnRnA>
    <xmx:2DCIajxJhxC591LPoHBXbm1Yl_2ItGS4mPuM2BlqgWSUmfCgvGc5-U2C>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Aug 2026 07:04:55 -0400 (EDT)
Date: Fri, 21 Aug 2026 12:04:54 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/6] efi/libstub: add a helper for the top of usable
 RAM
Message-ID: <aogvGXKH2u7JsJiS@thinkstation>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-1-5743791e48e6@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-hwpoison-kho-v2-1-5743791e48e6@debian.org>
X-Rspamd-Queue-Id: 9612D100005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: f5gezmkcjapdxnd565i4wxucqswru6b7
X-HE-Tag: 1787310302-164084
X-HE-Meta: U2FsdGVkX18GjSJubOWsAl7G9CbFWF/Jj0M67nkgpptz1RdZEqm1bI9nMpSFYirU92Hk3EjzV07/8f2sURU3+W2VYQ5HHY6xXIQ3JTjLuakcAbMRa/lua5k8X1OznfHOt2LsEPYAVKK+36FvJCkbt7Cor2O71c3NK5e7V/j9J3Fy9AfEfEUspAgxQDrNJlk6qOqai85xSPidfVDEbFeuMcuZbMVsXuOgzWBuAeBXwyvxdgt0BTqSUTot+GNkbIEaq3806hqmEGI4MzEB4Il1ptOO15oRO/ESwaatxnoN9cqGXTNR/wLv2PI8W5rcHmIXCjd6Ga0TDgv2zlPnxpyP5h3LGLIm+a0ARrY5LHDPhPnMeX88HvvJDCFdd/qJmS6gjrf6XtRQavFzKirTeVm/XGI1NEu6sZe/yt3C07NWZCTYqXHM93VRrV5+bgJta5j6iMQQOd+ohu0+MUtBXVJqsaSZCKs2VcGb22P3WyRajktV+qeChqwE/7GrLSYhyGFEcNbuTHtm0UX3MJZFcYs1/HoxhHniYfmCF5m9JkUh5RQ4E4FtNr41taybXMcJjs67bKE8rkD85Dv1XderJviA0n3nowwRt07ho/40q04JzZoT+dXJvCNC1mQX7YWMbh65vxXhGdNHJD0/1VEsKSMYeXw+F/yFpk/BzlNkXJ0Najz4SzJaaWUPkH4IIBAo2hr0vm1Gah5pMSqAaPGMQVkDkdfLZrLMIEGe+XuSda5e22xSvbcxn2yPCL01qGpVHb35FSs1EUzV3s2QEInN2AL2QgHIovvVtslTSpFQTCm073lyqAXV202jKLVoFUrH48uzkkQD+6LnVdnKL6xrtbb1o6Bpu3N3peKbK2HGcv/LtahlGkyJOs602v/jMcy0fvgGgkEohzRzBH0XGnO4xSlPJytHupZOaF39VoIEkDuZUnAjsa3bjYa27UFmlKH9xFUCBoW6ibPkkN9cWXnHNN8
 mW0xz9/c
 u05bGAlKfgs3w+z5xp7idjrKW0Y07uH/ObP2I9mbHUr35bpDtEsDj583jEHQUGZHfH76YGClMyl71qifwS98CMCaFxhjksEpJe5S94oRA62mmhmfg9rR0/OWNyrnFMhjDuJ26q0kDjFd1XI3lNqbOp6Hb++Sn9qvANp6FIr/1go8lmBBWhRBMBdsEgE4FRdqfu2gBcmHLjC/8OuHJYhhVewMHWHyWtLSXHQKiDJaW2edUjE37bqPV0zJE206nnFPOWpFQfW3+VWcml52cHgYmu86qMaynYhwrfyx+fP2ZsAcyajLrIWINWKvNCeogLJfowMfh7msk++31jJatDoShk4H3NFCKvItprTtRLZEF4J0W4dC+6Idp8I4pf7+C/zqVjYbu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 03:06:01AM -0700, Breno Leitao wrote:
> diff --git a/drivers/firmware/efi/libstub/mem.c b/drivers/firmware/efi/libstub/mem.c
> index 59f3f83de50c2..777f1f180c66e 100644
> --- a/drivers/firmware/efi/libstub/mem.c
> +++ b/drivers/firmware/efi/libstub/mem.c
> @@ -64,6 +64,59 @@ efi_status_t efi_get_memory_map(struct efi_boot_memmap **map,
>  	return EFI_SUCCESS;
>  }
>  
> +/**
> + * efi_get_ram_top() - find the top of usable RAM
> + * @top:	on return, the end of the highest memory map entry that becomes
> + *		usable RAM
> + *
> + * Walk the UEFI memory map for the entry types that become usable RAM, the set
> + * setup_e820() maps to E820_TYPE_RAM, and return the highest address any of
> + * them reaches. Memory a confidential guest has not accepted yet counts as
> + * well, since it becomes RAM once accepted. This is what the stub has in place
> + * of max_pfn, which is only set once the kernel proper is up.
> + *
> + * Memory the firmware hot-adds later is not described by the memory map and so
> + * is not accounted for here.
> + *
> + * Return:	status code
> + */
> +efi_status_t efi_get_ram_top(u64 *top)
> +{
> +	struct efi_boot_memmap *map __free(efi_pool) = NULL;
> +	efi_status_t status;
> +	u64 ram_top = 0;
> +	int i, nr_desc;
> +
> +	status = efi_get_memory_map(&map, false);
> +	if (status != EFI_SUCCESS)
> +		return status;
> +
> +	nr_desc = map->map_size / map->desc_size;
> +	for (i = 0; i < nr_desc; i++) {
> +		efi_memory_desc_t *d;
> +
> +		d = efi_memdesc_ptr((unsigned long)map->map, map->desc_size, i);
> +		switch (d->type) {
> +		case EFI_LOADER_CODE:
> +		case EFI_LOADER_DATA:
> +		case EFI_BOOT_SERVICES_CODE:
> +		case EFI_BOOT_SERVICES_DATA:
> +		case EFI_CONVENTIONAL_MEMORY:
> +		case EFI_UNACCEPTED_MEMORY:
> +			ram_top = max(ram_top,
> +				      d->phys_addr + d->num_pages * EFI_PAGE_SIZE);
> +			break;
> +		default:
> +			break;
> +		}
> +	}

You model it after setup_e820() which is x86-specific.

On ARM is_memory() adds anything with WB/WT/WC, and is_usable_memory()
also counts EFI_ACPI_RECLAIM_MEMORY and EFI_PERSISTENT_MEMORY.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

