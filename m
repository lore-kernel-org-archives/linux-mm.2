Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1EE606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=na0frTEz
Received: by kanga.kvack.org (Postfix)
	id 5DE8B6B0734; Tue, 24 Nov 2026 09:52:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58F8E6B0735; Tue, 24 Nov 2026 09:52:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A5986B0736; Tue, 24 Nov 2026 09:52:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1386B0734
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:52:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 845881609B1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:52:05 +0000 (UTC)
X-FDA: 85470302610.11.3E027FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id CF857140009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:52:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=na0frTEz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795531924;
	b=ujbUElNxH7viezTa3W6K59/yBVXTeg/V0VHebUuONXljFFomano1um+6g08sornjvqSdOu
	E3cN6YnU+wxDlIKpKbFNCK47WVHlnX5qec/9qgDjBNLXzXZdxMhNSpi/MAOC/Ps8wOw4Nf
	BG/I0G0UJRhWKdxfhqZNCiOWtKeCF4c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795531924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGxFJ44ZaFH6exgExrPW7alOn2CzE3QHdnDsrhGvuiE=;
	b=BmOVq6zZihIaDq4a6WEG2LOJi0VwtIZxlSHtUfpA01aYtWNJw0KTfVXyWrArUKgqK5LuJX
	DEbgeBdUjTyFWnj+5a4kOg6TH6rBH5bsJ0WIpvFcRqAlNZRgrA87EA3XgVa9VtXRB8a0XV
	50CBDbeuuzrPpyq8cKr8TL8Hv5QJkRM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=na0frTEz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C68D401D0;
	Tue, 24 Nov 2026 14:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B5C1F000C0;
	Tue, 24 Nov 2026 14:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795531922;
	bh=sGxFJ44ZaFH6exgExrPW7alOn2CzE3QHdnDsrhGvuiE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=na0frTEzq9oKVPXfW+kl4B1FODPtbmqrLck8Vo7YJ/oC2SJimgVtMXglMH+JdV9r/
	 pBLHbXBmSElloNw9eX8snVCPxyXx89B6QzGt9bmHrxRPmnaQXMIMZmvTDtrg2I2N4F
	 fhTbXwZAZCFV8viHRtmgSrLQvOoDeu4DPUXmxULuDRPUwrZwhsBOqGJV392KQzXca2
	 ubYvG4QOApNz6aT4NTZu3ya2kvgyKO/ujqalAbVCbnfdov2ifiifRqInbAj1xyNxHi
	 T7Y+jg8IOBWP1ScMn1aweg5JruCIcz6fnNObLCmvHHw02M25m23Oil2yIoLw2meIqA
	 /atC3UmE0On0w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Andrew Morton <akpm@linux-foundation.org>,
  kexec@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/memfd_luo: don't use memfd_pin_folios()
In-Reply-To: <179546369651.425130.14155931836758567682.b4-review@b4> (Mike
	Rapoport's message of "Mon, 23 Nov 2026 21:54:56 +0200")
References: <20261123130115.4021199-1-pratyush@kernel.org>
	<179546369651.425130.14155931836758567682.b4-review@b4>
Date: Tue, 24 Nov 2026 14:51:59 +0000
Message-ID: <2vxzo6bez3hs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: CF857140009
X-Stat-Signature: rx5q6t49bs8gonwbgs55z3i1au84sbga
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795531923-542925
X-HE-Meta: U2FsdGVkX19bcj/9w4KiPOi709NXmvuj1BFPK8pYO4RHU2HWoC3AWHKUm6gz9081aAhSMbiegPNwXG46VlcCogBwGEnZGI6bgzSdxDnPOMoVy92VDRdx3g2uFXvlQJwxiXChNvCo9vAG29fj4PBpdah11j8l3ZHDjyKgsyUmlvWnVutuuWYgZqnNrETibogSmpwOLT0wkrl5MQBV3o1CCrEfGliTojBbABGu/TxJA/JQhy4+JXSJds0LHYKVdw5nHgqyl2FdCUKqIDQ1q/jY2WOZhpvz//iD4y3wcBRjaezeSSZASS9pyMc6HrMvqNa1ni1etDtU0HkMj/73tm/zc21I9JCDW9eiQreLqLuswWdatZJKxpkZZovuAQWx5KK7/GuOAqyZZOcFvOky0/cdDIuO0hxthsBro6dxjXKcAiwHlgGoecy/85cu6ozYIPv92RVu0gP8gZnXpeifFWi4+LFEeWs/NwX7MlZlkJH46Q8O8vGEReVk0cxDVUJ4M39N4cbt9YYQZ1xiHlgAfWju9fDgO0Su0+/5Eq3FNBFE5I8sW4vhQpt6XaQawrC2c/0U0IXiYM/pdCFnt7xk9Z0Dks9WJ2pogSpWa6XvAXPCiznpUxuvNZlIigaXhSpdpRMfDkICIvwh3UAT4uLkTH8uy23nXJWK8+fivMVd2fAjFl4l+eH4g32MYca6mT5WyVcu0lL4/TzTHgyGTp4yVbHMGlPwR+ksdwpqQB0T8Ri1o6msoeJpSaY4TS4VcjkEiOLnLb7xx9Yb6nrv9o9K83o1h1McXHskYUen/PTxKBxZsA+hAtKt3FksjUz9hoyGxAJZTcvMpUw6MMqsIIVxixlfA/9yW30uCiI6onpV/awWBkCn/9EuGbhuLWEOslVqeQyBYhm12Af/LcgXTthee5ZqFUOTJLJmW00v3jEHvYEcm2+rwwTw6YFfeAi7m+wbdvnAI6DUEpagC9Rz7CDu3gR
 n7xROjsM
 o5LO4eHBLVMFUzrbTafwgpZAPbj8A/nGShMzdykjluiLbE+ueOIEA7fm9OyYL9EGRM4cDpmKbgyaz86jS06qJtr137+25xdhg3s6toscgMNFCMvcDxgYy0+KRb2aXhAQ+WRuvndwtNh4+GuYEjyp/dT3WKYHTvTyJ+BDGyTEAxPep/jfionmb99DRtJxoTC2p9aFSYlYkJ6vy3cN/MwV4ddDHYWT6qw0Z5yMuDuHpo7TzLEltrMw8J/KxeyNUoC6AdtHL80jSDpye13iyUPpUXHDTHPiLLc6/NHgOucXzH+87jhy9c5sZmnmoaLQa7dpWX7K5+4mY0xSbxL6y0BrtIcl/KhB1li+LJG8A7nObVbrv2GPS0geiNe8BXTG75oqWRuHK/uH71vafO1bMafXsVQdvRseMgzr2Hxpn2OtUK3lf+yo1fXsNuVJANHe2QXDUojCb3iOMPZPHTfDzoQzeD4lIVR/MiF4K36565SluKcInU/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23 2026, Mike Rapoport wrote:

> Hi,
>
>> memfd_luo takes a snapshot of the folios in the file's mapping. To make
>> sure the snapshot does not go out of sync, it pins the folios in the
>> file via memfd_pin_folios(). The pinning also migrates the folios out of
>> MIGRATE_MOVABLE to make sure doesn't land in KHO boot memory or in a CMA
>> region.
>> 
>> memfd_pin_folios() does not lock the folios. So it can race with
>> shmem_writeout(). A folio returned by memfd_pin_folios() might already
>> be in swap cache. This happens to work but is fragile. memfd_luo looks
>> at folio flags and index on a folio that isn't in the memfd's page
>> cache.
>> 
>> In addition, memfd_pin_folios() needs the caller to allocate an array of
>> folios. memfd_luo does not really need that since it will vmalloc
>> folios_ser and store the information there anyway. The folios array is
>> unnecessary overhead.
>> 
>> Finally, memfd_pin_folios() fills in holes in the memfd. This makes
>> preserving sparse memfds very expensive in both compute and memory.
>> While this patch doesn't yet stop filling in the holes, it sets up the
>> infrastructure to make it simpler.
>> 
>> Fix all this by walking the page cache directly using shmem_get_folio()
>> with SGP_CACHE. This returns a locked folio with an elevated refcount.
>> memfd_luo holds that reference until the memfd is unpreserved. This
>> blocks compaction, migration, etc.
>> 
>> There is still a need to migrate folios out of MIGRATE_MOVABLE page
>> blocks. This is because those might be CMA or KHO scratch. memfd_luo
>> will hold a longterm reference to the folios so it will block migration
>> in that pageblock. Introduce memfd_luo_migrate_folio() to do this.
[...]
>> +/*
>> + * Look up the folio at @index, allocating it if needed. Preservation holds a
>> + * longterm reference on the folio, so folios that are not longterm pinnable are
>> + * migrated out first, retrying a few times if someone else has them isolated.
>> + *
>> + * On success, returns 0 with *@foliop locked and holding a reference.
>> + */
>> +static int memfd_luo_get_folio(struct inode *inode, pgoff_t index,
>> +			       struct folio **foliop)
>> +{
>> +	struct folio *folio;
>> +	int err, retry;
>> +
>> +	for (retry = 0; retry < MEMFD_LUO_MIGRATE_RETRIES; retry++) {
>> +		err = shmem_get_folio(inode, index, 0, &folio, SGP_CACHE);
>> +		if (err)
>> +			return err;
>> +
>> +		if (likely(folio_is_longterm_pinnable(folio))) {
>> +			*foliop = folio;
>> +			return 0;
>> +		}
>> +
>> +		folio_unlock(folio);
>> +		err = memfd_luo_migrate_folio(folio);
>> +		/* Someone else might have it isolated, retry a bit. */
>> +		if (err && err != -EBUSY)
>> +			return err;
>> +	}
>> +
>> +	return -EBUSY;
>
> In v2 we did another shmem_get_folio() after a successfull migration,
> now even if the last iteration migrates successfully we still return
> -EBUSY and don't update *foloip.

Argh, right... Good catch!

How about this:

	for (retry = 0; ; retry++) {
		err = shmem_get_folio(inode, index, 0, &folio, SGP_CACHE);
		if (err)
			return err;

		if (likely(folio_is_longterm_pinnable(folio))) {
			*foliop = folio;
			return 0;
		}

		folio_unlock(folio);
		if (retry == MEMFD_LUO_MIGRATE_RETRIES) {
			folio_put(folio);
			return -EBUSY;
		}

		err = memfd_luo_migrate_folio(folio);
		/* Someone else might have it isolated, retry a bit. */
		if (err && err != -EBUSY)
			return err;
	}

	/* Should never get here. */
	return -EINVAL;

Or, I suppose I can go back to the original implementation.

What do you think?

-- 
Regards,
Pratyush Yadav

