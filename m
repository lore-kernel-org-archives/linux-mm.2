Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F85FAD3F2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 03:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1BE26B0005; Wed, 22 Apr 2026 23:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD6E6B008A; Wed, 22 Apr 2026 23:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4F56B008C; Wed, 22 Apr 2026 23:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA6AF6B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 23:35:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65E43C1B77
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:35:21 +0000 (UTC)
X-FDA: 84688405242.30.01DB1BC
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9083B40007
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:35:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=JSBJQxr3;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf11.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776915319; a=rsa-sha256;
	cv=none;
	b=FpJmOvezpe9GJni8mKrTJCPK53a6d6d70tm85nwr9dzbiRbjNqXADRkJQZiU5SqDW381r9
	Mi9sc1l+7yy+ARq7uZQomt89jnOfT3D2hgeHEucU+K9gs7k4VvVA0sP9TlGt38zJHUCW1N
	m5McCUo6/zQi7qc9NkW63KawLvRR+sA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=JSBJQxr3;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf11.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776915319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6s2isDfE2FieKJNppiSMNQx/Eb5cH3C9i1Rkidi5CY=;
	b=vpyYE/Hhv/8LoCZugI7+FgSGJU0KvTdXbN8y4XIq+MiWwrWYaIjOrGEKfjdlnisVyVJKA5
	swXocbN+2Hco/KocsKkBIILtnMSTSgUfGu7JIlydbxY/kSbv+LlSqCc5fyfE5ETsQehn5R
	vI8x5EtbmH3DD5qiOeZyxlFnZ1IiELE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=V6s2isDfE2FieKJNppiSMNQx/Eb5cH3C9i1Rkidi5CY=; 
	b=JSBJQxr3/MuPfP4zR2UyOyIOZdJAXRkaBy7oOxsEmcWU4m2lO+SYdWlGuyLlaKvWl3cVLvKEZnm
	n9qoEYj4o0kylQo/Y/iafHSnVy2P+a+9AWtXogScO3lQJeqpucEUZRsSd9d/QIdpDRnw3FbllQOob
	d61CzmdZA1lm3E+y4KjPGT+f+pgF5gifaczCjkdGty41VDhXHmjMinmJ5X3EjFPNF/C0A6b3tns7/
	lvql3a8Xp7kPo4dH/wvmoYWLJEfPeoXZR1Fn+1ncrWr2hIoVBItQ5EIaO6wEKNbYKF1Saa5QVfass
	zLYVqWh75XZOmCtkTOYbAjx6bKjw1/45P5cg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wFkq3-0087mr-1W;
	Thu, 23 Apr 2026 11:34:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Apr 2026 11:34:51 +0800
Date: Thu, 23 Apr 2026 11:34:51 +0800
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
Message-ID: <aemTW8yiAe6y1tsQ@gondor.apana.org.au>
References: <202604211323.fac1b29e-lkp@intel.com>
 <aedvSnhOGM_mauYP@milan>
 <aehdcxC14ycvY481@gondor.apana.org.au>
 <aeh2Ii9CxtgfsX_p@milan>
 <aeh_2WwIb8nAIcy2@gondor.apana.org.au>
 <aeiHkG7X_dieMdw5@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeiHkG7X_dieMdw5@milan>
X-Rspamd-Server: rspam10
X-Stat-Signature: 4km1ofa8d7jgg4pjfa196dqr3hhx89dm
X-Rspam-User: 
X-Rspamd-Queue-Id: 9083B40007
X-HE-Tag: 1776915318-442039
X-HE-Meta: U2FsdGVkX191/tJyoDhb19C/h0vCh08SudijqJXGGmi5tHHlQEi9GAOcb55FFzmCcQpItV1d4lMhFh6QMeVOcfm1EGR5MgrhZp19L/k+54O8xZMAwa7XcUBTtGFeStt0gijRKSLCUjFSqVdhb0VyjflyULcHKp1OS+VObXNmzy8nYkTguT2g1+sIL2Bl+BdDchyryf0qNEj0434eaNqYvESRCYcXp6tgQzqapFr7+5uSX2LyMWC/rAzPchFO7U0RWL8nO1PgzHtN+d8FqaUVnj2EDuwsOyE4GqAG3+LTpBz11m7PIiN974PIqmNztUsFrRivnql0uU4zm2ZlT8op0+GlzwlWQQh36f6WuQ1CeWt2qpCdHn1NJ9+1RQ+zOMi/HfoB2OqjZ+bCdAfDb3lpmYKqVg8iYn/rpfcvq98cam7H/e4JAQD4dwev+PFFq0261xeRN9yLe7VogxdyiEEUwBthgWQpMgwHpDMYHA38LuhzVnkR9kSAAy26TDUJTH94sienEnK0ka8bZ37xGemN74YDDaQcBG37nTU9eTM/kOCuoHn91WsDRFDl+1xWlZd6j0xeBN71i/1gnsOasLpxgDllOkigWziAS+Tl1897hSXChiiH3/s8FW1D8D91cE0c7mLJhd+hhlohn/25nKCKmZ4rD2db6gShEen2XXeHJ97Fbr+usQ0v8D/8j40sKRPz9y82RI9d/kFZjrXtC/IxuakH778z9p4SKZM+K+jSEGzfZJ+QJyLq16XlTOfxnG2+A6IeMZ/WvrikuX9gxAEQMtL6apirsgqWWHDVQz5N/pnmzrsXSDko7fUJ0Z9qSuavkUnhAUtCwYmZqEHyNY9N3B2kXxDsKsMCHGfWxjD7MROCK/FNnD2WVm61haHd3SeqI8ax+99QRIbP7Y1evAfvfV5LCXftsMvwGpOtTP3uKk/h/UNDuM/UjRmTwGbfZiHcLLYV6tzX6NzGJp3B5yY
 sCzSHdDw
 7rsuSM1KJY5XJd/Xxe2xq0Umgbispu0SuB0/DNZqR5Gru/BQ4AaqnFLOwE8DWtdctTPMvaYMaNEfbMa/nYMrXyY8SXdOdcG61GE0EY2+UTcHGqKCwAuxoGxmsozGTTdqtSAOBImdPAeQeARlwF7EnRCxYy6iM7DhBw4XfNiylasbqslvLPLdIGBzrTaAm7Q5wSFm7b3KrupxX0b+KcoKWpn3B2zUpwhAYGeRM2FsZ5JbpxatO99vqqNKekzP6jPZU536dXBIYgoNv3FQzbHk1irYNmW9nNm0D+pZn8mkY+cfwU/neJdF/rboACgTMfh7G4OFQdIt+isdruJrLbomHjcsMvhWjNtq4heTy7h95CwkqlPkrIzSTh6XpfvUn2/MK+uNxFPDDiaZ58BAIkpxrljpUfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 10:32:16AM +0200, Uladzislau Rezki wrote:
>
> We have added non-sleeping flags for vmalloc() to extend kvmalloc()
> functionality as folk need those.
>  
> Another option, would be: always use vfree_atomic() from the kvfree()
> path.
>  
> Any thoughts?

Perhaps add a kvfree_atomic that just calls vfree_atomic?

For rhashtable it really makes no difference either way.  But it
would eliminate the unsightly call to is_vmalloc_addr in rhashtable.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

