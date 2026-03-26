Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A3E710A1E64
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 10:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989126B013C; Thu, 26 Mar 2026 06:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939806B013D; Thu, 26 Mar 2026 06:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F5C6B013E; Thu, 26 Mar 2026 06:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7669D6B013C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:47:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13E441B9321
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:47:01 +0000 (UTC)
X-FDA: 84587886642.09.B0881D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5CA5418000B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:46:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uouhDF4Q;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774522019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KWyP7k8xCjeo6QZkYLluIOVg6pijIJ6pG+T5hYCQxs=;
	b=h7yA5PFCDW7CuiJRc8kn3H6/Rf1d+A+jv2TzOl1h2VrByUwgc/TRxPOu0tWdipGs4Fm2+C
	TSxEFdvvHNwBnVh7c8+FONNcpEOaZSu08ubdC3HswgidedMyqjilZx3zSW1C8BySDKwWR/
	7w7+IUz5swo2u99jjm1M898ois5lhR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774522019; a=rsa-sha256;
	cv=none;
	b=2YpKCp2Vs6W/+JGtS02iTAeMgC5fHQ7E49U8pfHsFclV8eKTlcH2SGmfML1IkrE4Z7spd8
	vw8a4u/GrrLRZ4wZ7u2x/c+BTyi/z2WcZ1ncQsAbTfLUQ40ayvvD8z3f2KY/dPzQhY+vmQ
	XqFCcTusks1yEEDQTGgbRaJhCgWyCAc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uouhDF4Q;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C369960053;
	Thu, 26 Mar 2026 10:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E84C19423;
	Thu, 26 Mar 2026 10:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774522018;
	bh=jz4QKqDvyuc0OVYL41YLkI+2R+GPNLQTDLA2i1KuuD8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uouhDF4Qa318/Z9nX9Ws4mHmW4Xj1lUe3ecVX69vddoTww6TykXBFcfxzgLsjsVUr
	 uKEecElGaHwHYwRB5sfVpD/OA8X8sVBjVkid9cXNQoz/6KSifPhScJyeqBMrEDo8oX
	 kXSsXRIlElj4UylHMzwh3I8/YWYRmOgzn/Fvk8BThWe7Ed5I2HEPkk2q0o6tM260d/
	 VEgQAHNg8pmhJezXZ4OK7g48WOO1fuI9Upi7y7U9026H/AmdcAXA4lLqumD439oT/M
	 Pzl4dym+ApN3Z6gmLabe7ExmLvPanhPpcuvksSt4QNF6HwEvXMWbKjIEqggYMGlpNw
	 iwwZm3ig9pXBA==
Message-ID: <171549fc-8d65-41d8-9343-7fcaeeda25b1@kernel.org>
Date: Thu, 26 Mar 2026 11:46:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 21/21] mm: on remap assert that input range within the
 proposed VMA
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <0fc1092f4b74f3f673a58e4e3942dc83f336dd85.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <0fc1092f4b74f3f673a58e4e3942dc83f336dd85.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: m3do1md7w7f4h1mjbd5z1ixujab9pj6t
X-Rspamd-Queue-Id: 5CA5418000B
X-Rspam-User: 
X-HE-Tag: 1774522019-955188
X-HE-Meta: U2FsdGVkX19H2eKmAX77i1kLmsQ99jqadkIR6GkQghmdflOMXcdYMaOgfNeIv73E+TDT2Ah7zyHNzHwVgbhbtgbAk2hFYm1vqVBOt21tX0Ie4LscQxO/fqBrAJK0SPMRTLmd0Cs2ThUcbF1JnHhFxYlckGumlOWLgVkKrqY0gxfEd4dpvqRM4nNr5YSM6puiuKKosukKh1+ILQJ5giMad+bY3WI0qxRKS3N56vlei7M9DXs22uUX/kNo4I7BPv7C1mhYsqHE2H/qjWSUKVVV/GFbSzbsguNxKMhLws/AyNMLLiQ7cSfR39n0wp4PAdKUXbAFu+yT13ciFkyLHncPR05j59ng5HFJ73xdzq3l7WRpopAwWSIZ+UZV/T/bwEb7Kq43P20mqsfFFqHsf6vwzvoAobwhQLnqs5gkhh71+T67N9pN+XIQmCQmjOHlehOS1PnJcxHOsyBHXfjpaJjoxDNztiMOvbqYPIfS7gISCTSkMQSRf1BKN8Soxm9qsr9cHIbrMzUHi5ljvVGFFgjSeufKpWApycMI2I/IP/fTvKXNGXTGd0z1r8+h0jm388sOQqFcXJfiEJwOZq/0igyXbryTgbIVyhAzvtUN04mIJfRc3fGOLWinF85Qpfo+4vrQnujrnhqYcyESEfIR4ET/EtaYaD4qY/5FnOY6rE2jJkWBo6ue6i/vtmSUibK9Vc3NpFfiIWvBld2vDInY4wICsaBQs+8dOIHyFe+3e/uCVsdp3MZQVX8E84AA1izcGaoai7NJE2HdH7eaWW70qp0CZVb/Lg7mmB6IxpgV2j3BfVsVOPS8E+SE4gN9j/MQf0vf8p5z1bzchIqmakItRjjSyMPw2bLmvaok5LdZSeyeZN0+cTn0KQZXhyF9G1E441TxeCnf/TEftjzIhm2364hiaI8qa74GK/YKtwZsRLigS76dklsWyKHvZTQxwOkOXocj9AedWmrADmGRfUfQQMO
 ViVn5zVI
 tEJy3NkTixPBRJG/bJ9MA9Os+a3ja/zcOvzZarU4VAnxa4KdOIpPD/otVgeG16rNCBXST9tJuq+LA8X2ngh6uxAzLLky8PSlRiu7dqoU95SyVAu1l24IDUVsGS2IAI0XSNl0ppDXDtcqIO/dMttJYiPUIc5AH0Ewzhtzg5M1pf9G+uVkjHA+s+eORDw5qtlWp+lWSmJC44arN/EksEkS1GeA1ObOghsNGjFBEPutJjGGiyYWm+lOqQHmGqibRp04dn0q0ajC0Dv1v05yv4Rp8BKYS7GXuhD+VPpq+dyeueS7KL1hLeGJwvPZeFZe5MtkwBPsCbkRJ9dvhkPtzZl20vb7k4jYNHEi70iM3gwTdb1BZhnQTqrzGI4LSvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> Now we have range_in_vma_desc(), update remap_pfn_range_prepare() to check
> whether the input range in contained within the specified VMA, so we can
> fail at prepare time if an invalid range is specified.
> 
> This covers the I/O remap mmap actions also which ultimately call into
> this function, and other mmap action types either already span the full
> VMA or check this already.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/memory.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 53ef8ef3d04a..68cc592ff0ba 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3142,6 +3142,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *desc)
>  	const bool is_cow = vma_desc_is_cow_mapping(desc);
>  	int err;
>  
> +	if (!range_in_vma_desc(desc, start, end))
> +		return -EFAULT;
> +
>  	err = get_remap_pgoff(is_cow, start, end, desc->start, desc->end, pfn,
>  			      &desc->pgoff);
>  	if (err)


