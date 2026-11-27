Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04E1606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N97Ok2bp
Received: by kanga.kvack.org (Postfix)
	id 118806B05B2; Fri, 27 Nov 2026 17:35:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CA366B05B3; Fri, 27 Nov 2026 17:35:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21A66B05B5; Fri, 27 Nov 2026 17:35:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D056C6B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:35:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DA2F160514
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:35:57 +0000 (UTC)
X-FDA: 85482357954.18.FEB5941
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C2CE22000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:35:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N97Ok2bp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795818955;
	b=rjv6GMbhM8m8yr+fHQ469DJjEpeYbQJgCLbikqE8SZKypPoyRFhMeMWxhLY3B6TECnLUw3
	PBKdSYoUKdk95WXqQV4oDCohn2H9+LyIbJD9jaWhnwHJGvfgfxIIRkU60/VeDxKnLR25xj
	7v1/9LqsHead08B+ZyzFZKCg0VTW4t0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795818955;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dzF317K6KqDBv+rHBv9bV3+7O0cBP4sxEFIupvQMWVA=;
	b=YH/rFJrTV2P7hHMmudZcqU+1VWGg+mjNgdfVOR4BnibUaNtpLe0VoHiHgz3qhH8uEbHyqd
	eSfrnVen6ps/rGDZR+dUn5jluh4u+2owyRj3oRXuNNac3vjKwNRBcolcZ8DMcYxLIXhtH+
	kJhEmWSLL//lRKuTHepoXUnRRNZjaMk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N97Ok2bp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA03C60CFB;
	Fri, 27 Nov 2026 22:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563EA1F000C1;
	Fri, 27 Nov 2026 22:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818954;
	bh=dzF317K6KqDBv+rHBv9bV3+7O0cBP4sxEFIupvQMWVA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N97Ok2bpSbtbpvw8SFOg8pmPmUYycOcIkyqzhFPD9FnA4BQ/FrNBQYgVuziSteeNH
	 /9zRQF3nsTNx2bAFiGakWnyixf8X3884ZaY4Xc5L4tkwvcgOCXKjO4RkxEmEooWMj5
	 wKOu4bRbdBOZU2WATujGqJw/eGHXnfG98kC8f3hqKjUWjV9DXBinpHXUCnkiL2H1XZ
	 tQKGektu9F1BJlf4KzPtn6bhF8covbfwMsPhlMFInKLrpcanbTra7rEPgeHS39WO6x
	 GBb5DfI9rye+KgWc8LGtCcj0+uWSt1SygCdXQvdGxBeFLMcHxeRFASf5qHawLf85RR
	 f1cDs+OkN61oQ==
Message-ID: <sashiko-outbox-238334@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 3/7] mm/damon/vaddr: implement sz_filter_passed
 for migrate_{hot,cold} action
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261127222719.105510-4-sj@kernel.org>
References: <20261127222719.105510-1-sj@kernel.org>
 <20261127222719.105510-4-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 22:35:53 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C2CE22000A
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: co6to45mrj1x9398ntfh5nbapmxjnzzs
X-HE-Tag: 1795818955-691460
X-HE-Meta: U2FsdGVkX1/4s9XoqrAqDR5Wen8gZr2rWsXli+GGemg9Rps0rqAO4hGdZG67jwjZS+l340M1XQ0Dgl3bRAfACSjjF3aoPoVe67Zu37tFJu2qJDabPxcnpJ7alaqc7CO01LdBsFbqxXv7G4+Voj1WsPX1ddsOPE9dBPALIgOK/ZQhRRAP23yMLBLY6H/NbtfOrauGY2F80pH6Zk1OE6OTYvQbNXZDp624KBdX8M/sMRfm+LJQpuInLcd4+3w4Qo5jLM2yKUHnXsIaZuFjS0Mhfpk8zEY/tsFOKUUA0PcFsO3bbEhFCE2+TqZSqgUgepZxzUr55Lu4xP4MQjle7GQGq/Df+KWdn6U8RHBuWX9uzT2AdEsSsnxYTR1yHeG7XsCIqUiDJIWYFa3MC9QZ3QBfUF8LFEmvF0wL0WUU9fy2ZD7av5U6RV4ECs/NHQwWLYE6g3hEjbN7rorvQQqG/4xa5EejmhRso8TWNaPluIirvo7/OJfOQiX/mSh7v95gJh2OrrBxX4+5P/1XHHliKmuggjyiReOTGjjLQSbD88JVrsyWUAU9oiK3DFGU/dvDpIJYxw+v4aLh1OwwEWNHrk3cEBz2FioGYeS74dHC9w2VvbEZAa6oHg3xibd+eMc3ko42lgar0w1Xs2NyIFN+HkwklxOpmeiqhY7TpCGb0FQdCVEBLzXDye3nl53ved9GiR9H4Yi1Rrp0igVbjKQm/pM0lPuMC4BayTRPgBbOpvbKQFYMkzUf14vm3tGQjX+vZiUuk247JaKr0Z2Qcv//wI0yyHIRl+1mrlGgx0bXg91Z9iqztz/3qvovfxhZv1MW55H0ejbebcRwYWwda2Ma/hobgMPZKCSg2C8NraCDYkaOzcvuN8hB37OSzu0FTv+f1Muag3yjUOwVpvagdplOifrSN4Q0KF2lvYL97PsC5iruWM2LkBGxrIe8tPFcHJ/RKFEmQbWd/tCKo0Q8XfHmVar
 p/bjL5Rp
 SrNb/8pAhKFAEFpIYAISx0ULm06PnmbhYeiN8WSYpd6xIbyn7w5Xxf7FZTme7owtPZic2Sz1OYiXGeSX7NmPn5iQKn273diHP12/S5kuw/lC41wJsMxPqvajmjd0TWOrLo6mXZkwlYPAErGsVhYa+HeAeHuktuW7H4sirApj7dwdFpUfYIZm6m3/IMFoSyGG0XAU0xhMFM6JP+mnY1Cw6mguS3zD7AQb5euv7u5MRfrPVUmmNZR+CPtvKZva2DhMMwjBT78luFPdvYNncE0+/3usmvpwsfNUKBX9Uio6puKFalDpQNHTCYUtlJt4kylrM3RHreXCvqsLL4VqBU9BB+rujKXLMLbyxTGI+KdxbXJn6STnQ8GmipfozX2yKf0p9lfPIQXLuNPZdOAuVw1ouPUOsKCNgitADe49RG2+EG3KLA424KJfSoErRMnYcJChRZ0AJzhsmQD8rWKurkkx9XCvizqdkyIzGkV0n2BFuJBNHYfyILCPo/eDr2QcdAMM8XIwAx/qaUEXjH6MXkjDl0ctJzc6BSb4S4P3kP6QOv0d+DTc+o4vpz5NVsiXmMp8faWFpY+3x+Wy7UDclPhk1+Vw2AZzq6Ej4xJibrOhCBqLQDrkhf3NaRZDmIhTw5QdHctbJDET9dbdTugdFEn0d40D1GgWjDh/LfmANFdL2NEvCcxRU3ixBS97xMSgvNyCYXCuUNmUTjZ4s09UecFocKCeyGHGuI3AJ2UoTwOx4gFPpGPhWomRl4aM9LT+LoPfRhEK8tPCgeQnZ55jE0VKGwu3KP2pCTdwFkNrJh55DPOS3nJNsScZmjvIgsOC4EckJ0IqT+dRn0gKwfZT+hJqTVVfCx8BVvSfdauCyVtjd1VzujmI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/damon/vaddr: NULL folio dereference in
  damos_va_migrate_pmd_entry()
--

commit 446fe1a8fb2f01d2025ab8ed2dd156f643ec9800
Author: SJ Park <sj@kernel.org>

mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold} action

This commit threads sz_filter_passed through damos_va_migrate() and
damos_va_migrate_pmd_entry() to accumulate the size of folios that pass
DAMOS ops filters during migrate_{hot,cold} actions.

> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index c8f93a19c840e..721a23856ee16 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
[ ... ]
> @@ -895,6 +898,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, uns=
igned long addr,
>  		s->last_applied =3D folio;
>  		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
>  			continue;
> +		*sz_filter_passed +=3D folio_size(folio);
>  		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
>  				migration_lists);
>  	}

[Severity: High]
Can the PTE loop in damos_va_migrate_pmd_entry() dereference a NULL folio
when vm_normal_folio() returns NULL (for example, on the shared zero page
or a special mapping)?

Earlier in this series, commit "mm/damon/vaddr: use damos->last_applied
for migrate action" placed damos_va_invalid_folio() (which checks !folio)
after folio_page_idx() and folio_nr_pages():

mm/damon/vaddr.c:damos_va_migrate_pmd_entry() {
	...
		folio =3D vm_normal_folio(walk->vma, addr, ptent);
		page_idx =3D folio_page_idx(folio, pte_page(ptent));
		nr =3D folio_nr_pages(folio) - page_idx;
		if (damos_va_invalid_folio(folio, s))
			continue;
	...
}

When folio is NULL, folio_nr_pages() dereferences NULL while holding the
page table lock.  Checking !folio (or calling damos_va_invalid_folio() or
checking !folio before computing page_idx and nr, as in
damos_va_stat_pmd_entry()) avoids the NULL pointer dereference.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127222719.1055=
10-1-sj@kernel.org?part=3D3

