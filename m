Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F2ECA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891828E000A; Thu,  4 Sep 2025 08:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8690D8E0001; Thu,  4 Sep 2025 08:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F288E000A; Thu,  4 Sep 2025 08:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6527C8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:27:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F1FBE1DAACB
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:27:08 +0000 (UTC)
X-FDA: 83851492536.08.95C702B
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf06.hostedemail.com (Postfix) with ESMTP id D20C8180015
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:27:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756988827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ap/u/LxI4jJId+wwpbfiqajsfGDukKXM8oCDW1Th5dw=;
	b=2ehLNme5HjoLR1fZFIElmwrK4mF9jH0wj9J8HtY673TTq82YiAK11K8UzQrnvDefYXyDjR
	eHpndb5GVF/D5Xc3OQzuLpZxcs+kHVmpk5NSo9LyGbuevjK7Ib76l1fYCKg8cLH5IVnhTE
	b0NcthFap8kmHwDgKEJxOqvEhnaY/VM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756988827; a=rsa-sha256;
	cv=none;
	b=0Vg0yXcNazfrPaEGJy0nLZQ2fSm2bowpq4Xf2YL+1YjXI5lbS8hZG5cnHWPbUEXjg/FtqE
	f2wz+39GtIKF1S1VlMJdBNzHl9b5pge+O9PEYzolR3mwV1S44JtKv7FdRSM9EblHLFY6Dx
	3TTlS4wbRslGnNQPHEU3/jDgGu7bgwo=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 99F8842D83;
	Thu,  4 Sep 2025 12:27:02 +0000 (UTC)
Message-ID: <113262ca-214a-4cd4-86f2-c0e3e4bb1a06@ghiti.fr>
Date: Thu, 4 Sep 2025 14:27:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] riscv: Stop calling page_address() in free_pages()
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-efi@vger.kernel.org, virtualization@lists.linux.dev,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>
References: <20250903185921.1785167-1-vishal.moola@gmail.com>
 <20250903185921.1785167-5-vishal.moola@gmail.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250903185921.1785167-5-vishal.moola@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeitddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpedthfelfeejgeehveegleejleelgfevhfekieffkeeujeetfedvvefhledvgeegieenucfkphepvddttddumeekiedumeeffeekvdemvghfledtmeekheeftgemfegrfhegmegvfhegheemsggvudejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvddttddumeekiedumeeffeekvdemvghfledtmeekheeftgemfegrfhegmegvfhegheemsggvudejpdhhvghloheplgfkrfggieemvddttddumeekiedumeeffeekvdemvghfledtmeekheeftgemfegrfhegmegvfhegheemsggvudejngdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhnsggprhgtphhtthhopedufedprhgtphhtthhopehvihhshhgrlhdrmhhoohhlrgesghhmrghilhdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkv
 ghrnhgvl
 hdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugidqsghlohgtkhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgrrhhmqdhkvghrnhgvlheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlihhnuhigphhptgdquggvvheslhhishhtshdrohiilhgrsghsrdhorhhgpdhrtghpthhtoheplhhinhhugidqrhhishgtvheslhhishhtshdrihhnfhhrrgguvggrugdrohhrgh
X-GND-Sasl: alex@ghiti.fr
X-Rspamd-Queue-Id: D20C8180015
X-Rspam-User: 
X-Stat-Signature: wcbhap1edsjjqk1tw8bptqka9s6z4nmf
X-Rspamd-Server: rspam09
X-HE-Tag: 1756988826-652149
X-HE-Meta: U2FsdGVkX1/840B2Q9RmxYUf9xlABOO0l+Vrq1eF/Bk36k5ZT+vz9nglo9SF4JaOekSpPiOiEAKD04Fow4ScFt+ahbRa9AA/1VP/ZqTpokGW7mxQDrIeEftPGeUou9aVA6hofsq4v5Me+TeuZR7xLnM0AVlieLSuJIpW5vj+1c3DNUWKlCdgjs45zIHt8D1PnqNLxDx9VdYS8I+jnXfydVdxak85SnoDCBBlxcHW1IJSsuIn24vmZEFVL3haazBtYE2QDfxm4BDBxpLzkpKqJHjq4WddQllGUrUGypq/QXFJ7G24rUMMP+9drXxfd70bQCjJxJqm/M0SKdlh0p7Td7Ziy5RzaJ4daUkNVTtYrym+fjOZvIDwa9HOAz7oHBIcFvYUdV6C2+bJ1boUSZMsGh62D6THSZN8Iejc6738dfycNstU0aNl8fuo5wlgVFCAK9BCO88vCb3FfNBpit504H/KIsoYeOkUE2hNeXJYmTIPAKBhZnwt5bu3HbVd3F101yVCAkptUEYOLLLnxxNtoDYKo9/ZTh55LuLBZa/wXusxYpPF76gZvovSFftURA7Xtdirl3MsGgPZdoXlwSTnQYbiVbk1sfqDdQ+Jyan90enzMyCjGHjdI/Yo4MxpRkxXIcNsYGdG6vPzbhrGXR8+OnvVweemqIpzl3zzLm0ZvGa5uM80wwy5ymPaEI5pm40jD8SnFszM670dAyK+VaTJRUTN43ToSBxgO9+szGuyaXGQyKoGH6fwo4go8ULZrwS0+R2MUeppX8S+Rj16Dpb8VFkKUQbhX6/MGGPfmeGNxdMsoFAemfFhLRS0VWVstwo3UB0sdgbw8zQMbJ9BL838HCPZW14+RHkO/LNScfYYkb0nPOqHD3+e9hNTy81tvZvee+P/u0WGAgCP1k7Ant6LsCfGndKaf7F2dKNI1XwxGaVSG+Og571MsELM1lMkwU6SaJ5Ubu0Fvqp5kI+cDYS
 ZWxGe79G
 NfH01D4VayvGicfbkvRafYpTarmSHecLmK60W9eOIRtWNLsTiBz0JyV7x6uWvGu7ih7dKWcmJJfucTO4fmvIRHUc4Xk/noeTz2dNbs7XoiTVhiYQ4jjFkLwzUI4ctAh5ndeaSPQ5UjoAcQ3nuSN8Y9OnewwFkKg8W9RTeSevACQDBezH8kxKSI1fN/ECdkIPeIDAdgXaeDcrqD3jZSHhOdTS1DjPFSp+OMVhLgBvbpkV9Q0Bw9sRvLZ1qsjThlPXrUpTq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vishal,

On 9/3/25 20:59, Vishal Moola (Oracle) wrote:
> free_pages() should be used when we only have a virtual address. We
> should call __free_pages() directly on our page instead.
>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>   arch/riscv/mm/init.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 15683ae13fa5..1056c11d3251 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -1624,7 +1624,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
>   	if (PageReserved(page))
>   		free_reserved_page(page);
>   	else
> -		free_pages((unsigned long)page_address(page), 0);
> +		__free_pages(page, 0);
>   	p4d_clear(p4d);
>   }
>   
> @@ -1646,7 +1646,7 @@ static void __meminit free_vmemmap_storage(struct page *page, size_t size,
>   		return;
>   	}
>   
> -	free_pages((unsigned long)page_address(page), order);
> +	__free_pages(page, order);
>   }
>   
>   static void __meminit remove_pte_mapping(pte_t *pte_base, unsigned long addr, unsigned long end,


Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com>

Thanks,

Alex


