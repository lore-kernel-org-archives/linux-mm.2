Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44861F94CC4
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 05:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31DDF6B0088; Wed, 22 Apr 2026 01:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CEB66B008A; Wed, 22 Apr 2026 01:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4DC6B008C; Wed, 22 Apr 2026 01:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 101DA6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:33:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CEAD161097
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 05:33:00 +0000 (UTC)
X-FDA: 84685072920.25.515307F
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5F4C3140002
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 05:32:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=rxyn6RRg;
	spf=pass (imf26.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776835978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXiySTXnmX0EoYqqPO0CUXpbGPq7kKxCM2FYg6rgL2k=;
	b=zJacLU7inh9LummGMKCsxl8Uh+0qHgeyhtLvdWHQnQu4zPUDPz1C1F7e655zDt6PhcEBgu
	PTgKTd+DfV0nEIByvpWI3vw/Tvq6ieFeMWTPgETCOdOb5HA9gQMPfWjXKFTAbZM5rTZ5vl
	FquJUN3jXZNfYX8+d5hd/TKng3LRPqI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=rxyn6RRg;
	spf=pass (imf26.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776835978; a=rsa-sha256;
	cv=none;
	b=qsC5OOEZcf4Re/p6A9fEVAUwTLmVR3yyk5WOvs4pziecGC9Zt1Nx3YDgDwDqT6ofnMO351
	3Z4VG6Q9LtED3mNllc67xAlwOEb3Cs79rlN9xcyQBd4X31T0Jv6P+BZ9jzexqwrdnorFO2
	DVc0/oqUSHGypEPUE+nohVewCCKtUrg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=oXiySTXnmX0EoYqqPO0CUXpbGPq7kKxCM2FYg6rgL2k=; 
	b=rxyn6RRgWSMPT8cbt6zpRcqyBuzEnxS/cyiGOeMie87KpSi1IcYD2HmX4NgYvFizq/O2Nadx4fF
	43urOEB1JJFHyVxq4Pwo1bNyYB50W+5GbZ57uJfSI/ZjdfvsGC43i/1A6MTxbUX0FuhncYJrXsFMX
	1FhE6Hck6V68uf40tRwmW+icihHrJFU60dfd8gO0kKJglIBTM2WO2MH7XEqJO/AVuPHnUzmlXszFC
	UbjatM55EsESOXQppEZV38XlZZL0vL7UmoEySz4HiHHsOedu1tG3H/mhZIRuGwVciP91dQu3tekFZ
	EyGF7Cs7RD5Lb8OZAU+6yJSaAKzxpLdZLuqQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wFQCR-007szj-06;
	Wed, 22 Apr 2026 13:32:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 22 Apr 2026 13:32:35 +0800
Date: Wed, 22 Apr 2026 13:32:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Thomas Graf <tgraf@suug.ch>, oe-lkp@lists.linux.dev, lkp@intel.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [linus:master] [mm]  c6307674ed:
 BUG:sleeping_function_called_from_invalid_context_at_mm/vmalloc.c
Message-ID: <aehdcxC14ycvY481@gondor.apana.org.au>
References: <202604211323.fac1b29e-lkp@intel.com>
 <aedvSnhOGM_mauYP@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aedvSnhOGM_mauYP@milan>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5F4C3140002
X-Stat-Signature: 1zqrnsgshfzyxcrdb4nnhzi7ctmrpjzq
X-Rspam-User: 
X-HE-Tag: 1776835976-681882
X-HE-Meta: U2FsdGVkX1+3WzTsPTeFtuRcI6viJHd9JnBETNJd3dceFn4kPXZbvHkzqNO5erd0+hD34YR1nDrMUMJufZVAQSSSoO57vPIRRQsnC9xBUYX0VKIJp/Iq3C3s6dtpSG7+ANoXlvjDivPvydCECkvJB62qncLLd9WI9J8gxeFun7xXherRs7jYGzL/JLu3ObuuxMBk9qJ0P/v3ot5Lfouu0bdCPzW7gmInaKBtBxdEYgWsscn0bpZD/+U2jKpWSifeRmORcmx9fjWkY09HDj/3E4Jw8VIvd57rP8Ug2Y6n9XqsMaXO6wUuOK38XMo8/H8dfY7KSAFiPLszl2HOrBm5lJyNWHTkUUfByXUt6sabz6x7a3J2L5xOf4rtLqoWcu79PQhQmy3wgjpamVOlZKrQFPziGk+pm9bIFn2g8Mwh8CvVfxPJ/lP3EUBPYowKDvXeaHQFD2R2qMNkZGCFY98ytvdKUDvTLdAlbfvLYto2uUsiqPVW1JIlzrjRISIbmT2L67uiTR0GYp2XXre1mDjSYgw1MrOf4EbKdfR4k2RkmaYd5vTfwpEO373qJiI2dFIJvApYrrsEbTR5kTQcnpMtzTrMV6yEp6xj7PGHLDF4WtJH+plCNI0lVOBQ4q+6nWkwmEak48EmCandZItVZ3jKbBy9k5H5QNzLn6S8zJk1JB9QXkWd1gAC29nyX90FEn7HjIsb8C74zFBh/4iFl8w2zPBUqvvWEC0MYD0p3aHeNUvvdUKy8qwoaoLui9Bz8GNN0sm2Q3UENVNrizQUi4maWMkEl7rLnoW0EXsXzo2wG3HDqwHIttLBYax57YkwEXrE/wgZy70z6KbWrOxjN7+CaTUGosHGYJYOvBDonFFuNrqruocJTsbw/0qzj0fXfgB2YVOIgSYcvkT/548xSpeOGiWnr3IDJZIh5lVybPMXScJMnfl5sHxBImgFtt69NdNTFOCThosIXiN25hYvV2e
 T9p0/UWt
 vdxm5S8kLMn4FEUdQYiofIjSEAqEc1DCoDvwXWy6VLKpLcSOEiHGirRhByUghahDRuR3lASU7KYIC2roQl2S/ZKUtJ2u1PcLp7UoumnHvDakYo/gF4S6LrWnSX1vYimvoaM9STqKDMA/50BAWWi9QTGYQAm0x1S766F/dVAbZBKjyBmNzKSXAiG23iW0eoJPoQU8aJgvxTrbjkmxtDWeqWPYi0t32e3SazTCkSHJDWgI1R7Uat0WazhBPThWIu2eR2iU/fwuV76L28xVd1yZYOZ/jp9SEzL1pus1NvjtlIIz8O3XUJ8fcCBVGf5kFi7HpKXWshYhfIGrsLfoRgs43ttroNvpsRl1zDcciE1sXiPVXrzqftryCimex4K+6Cqn3adAZ5DvJHo5U/47QLlNF6d2ttA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 02:36:26PM +0200, Uladzislau Rezki wrote:
>
> <snip>
> diff --git a/lib/rhashtable.c b/lib/rhashtable.c
> index 6074ed5f66f3..a892766dcedd 100644
> --- a/lib/rhashtable.c
> +++ b/lib/rhashtable.c
> @@ -473,7 +473,7 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
>  
>  	err = rhashtable_rehash_attach(ht, tbl, new_tbl);
>  	if (err) {
> -		bucket_table_free(new_tbl);
> +		call_rcu(&new_tbl->rcu, bucket_table_free_rcu);
>  		if (err == -EEXIST)
>  			err = 0;
>  	} else
> <snip>
> 
> Could you please check? The problem here is
> 
> rcu_read_lock()
>     rhashtable_insert_rehash()
>         vfree();
> rcu_read_unlokc();
> 
> we can just defer freeing via call_rcu().

I think we should fix that warning instead.  The memory
that's being freed here was just allocated in exactly the
same context through kvmalloc with GFP_ATOMIC.  I can't
see why you're allowed to call kvmalloc but not kvfree.

That makes no sense.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

