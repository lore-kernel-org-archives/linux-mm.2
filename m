Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A8FC44515
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD006B00F4; Fri, 17 Jul 2026 20:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3026B00F7; Fri, 17 Jul 2026 20:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C9916B00F8; Fri, 17 Jul 2026 20:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 029616B00F4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:08:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 388301C02ED
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:08:19 +0000 (UTC)
X-FDA: 84999960318.09.E35984D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id AA1E8140009
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:08:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UdLOdCWX;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784333296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUAY6n/JfAMYhXtH9Z07dgCHrHQqnGWfNgZZZ7aOKP4=;
	b=AsHBIiN2seXzOKGwaLOwELmXnqKksnrYi3fN/hvxYWpeOWLQd8cPIlhUedGIi/bpcBMo7N
	CaVmLOLOW/Y82RBLav9TwXvtNsOJiqSupxjQajjZkqz7UAdzdXb0gm7CdbyHnqW+Ogapwx
	9eu4W0MZNpW58qTK0DEM9PRlUxAOj6E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UdLOdCWX;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784333296;
	b=v3SKC+/upn3KOJfwvUQUn1hF0r9FErrJNDkAn03YztI1EYtuZWkm41L500/CAewce6GRyy
	HTlxgKCu8kMm54j0Cuk2WgZJnsHsdg9AYMeR5I4D6byrhf+MNwJBa0cEjrmDNwu2kqgxST
	tuV2L+EBEffFBDcO0CLyar1b7m7Pbog=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0B4360DB5;
	Sat, 18 Jul 2026 00:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BC21F000E9;
	Sat, 18 Jul 2026 00:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784333295;
	bh=UUAY6n/JfAMYhXtH9Z07dgCHrHQqnGWfNgZZZ7aOKP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdLOdCWX7v20VPzDmvLDlNZ+EoG0ewmJwN76lyLfkIAQtPrfMGNkjPUI3fkTe2Xs2
	 0ySoZ0AG1E7kww/UCLp5/pRWdLMia+MiGgINiJqJOfy95OidMqkr0gSx9KMEKAnspL
	 8dhxhbkd6OQUnJj281P6PYs7OjnD+RNsDT6q2RLgh2Ee2pi7E3pn1XziCl93aP1/Xj
	 ffhVS6nEofXDn/IJNrT+0lA6UPi7aqrccB1oWYfkmuZshD6aaEb8rHwaB29ZocJAbm
	 CNTiKY36GFKkI6IYtp2P738Ofx5bv2RZmzYb9oC/WVnBo12gwVpYxz8Ewx3W8/ZbSd
	 3HUzpDlpIzJNA==
From: SJ Park <sj@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Shivank Garg <shivankg@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/migrate: add missing kernel-doc for @migrate_info
Date: Fri, 17 Jul 2026 17:08:06 -0700
Message-ID: <20260718000807.85807-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717022146.1290242-1-rdunlap@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AA1E8140009
X-Stat-Signature: 61tgdmh1kcnm5hsfdipf3pdk4i8qp78t
X-HE-Tag: 1784333296-750091
X-HE-Meta: U2FsdGVkX1/L+POFNzZFDdsjG994X5+BtDVwJGoQ5DyjNY1rZ9OPs+KCE2/mI/gGL9VeycZBE5Ls2HSV5mQsues0aLRx9zNJG/tAG5IBB/cif2nXfh+wNBweosDhH4Jseufq4Smm0e/brlUR0k4QrRPb3H65GCke/nWPQqPVHnQD8+9IyYwcWLcd6/xmM7egK0x1XmzNLgdqmQ/a7RuiFuKpkIvYo/0862fnCaO656bwU0L6ClolrKRTlRxaob/MAfibsZIBfT5JQ1c3JhNj6B8g6/3TQ8zj/+LOEVcNTt1U+wWCyfdyzM0FHbMPoGLoIsysxC7ij9YB28+bk7s2cj2Wo6Wor0w2ucIwefuCLMv4bzTF0K6RAsR/HOEwh4Q4uCA/n3w85IGqfbBMDjNjg23pHyPaQO7Tf+30uLydz72GTc0klQbJ3A6a0bAJu9KZ9QGD7UBaHwpjB9FQ2nvAjP1ySiisCHO/9Kw1xt9BZkOmYBNwby0vIoN+k89w1yXM7e54Tv+VrtugWcKPIvbt7+m9AsMVM+1hWn+lIsQhIzB78lsfEeUWnTV//TdjXvL33gGk/BqPWVuqyfOCqhp0JoWs/h+dRK6frAXw3JkrgkDRiEujydlEA3wG0I56FaSXqRKC0hMacv38JWOOkGWCfA2W2t9CUEgBKWjABknf3bMFYditr3Qre2hZu3Hj/FykrdanlLocSiUrZ1oK0Uow545CKeo4dDUXsyZXZk5RxgeDimXDyrQvS8Sq2yvGJWBQxl2WFxw7rSDGoD6oM509WP1IaBhtl0LsFNILqGNEXtpv7qqiCTHGoxhEH6CIsWJ1OvP3v3VZuAYThto/TBVAKgLrlYGx1NzxGmjVQM0oMMshQ/zn2Dxxmre1BmFeZHXpZepLi2681kE/CboNV0cruP/JbFed7iHpfTJYkj+CWYWZTIRwNjBQYTgBlfY4EOsjkcOGO2iNrHh5aTtyh5R
 m+P6TDPN
 7pN8u8jtDg5GrPrO+VOIvQvkd94mEfwsz58Lc2KmE/hma/f7HFUTQtqeZ2cm+uT3rT2drh+K0lsLxNNDJqaClclZHHsXsCLciXPMZ1j3Q/pT4AuTBcqXUWKDkTW+lLLTTEcIJ52u53gWKvDR5dbFDbEiyRUBSiS5EzwxXQoQFpIxpqNxRPZxkbBANxuXknQlEfQnIh3D1OTfHySn9SoZvfitZepgPd1ZsW54YKoLQMpPG9brqeXVCBMwFMYkAriHraRL19piXcipcgq3pulMe6Gv4FnNj4sjyk0phs3AYBY9w0V0I4Yu2P2+PWGR0gYHfaipdsm0JNPaNkTfKFO7QilYm8DI2oy6dDLgPiMPZhrGIfo8LJdb+lPl0ajse3dRnTlVBgiIQ5FHy7vVEfqUpfhDuHspleLT+Lzi+jKrc5Vprtldm79878rMyVlBfvyckvVGDqC2m5zznruZ8Q0aSVIonag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Jul 2026 19:21:46 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> Add a kernel-doc comment for @migrate_info so that kernel-doc won't
> produce a warning about it:
> 
> WARNING: include/linux/mm_types.h:507 struct member 'migrate_info' not described in 'folio'

Nice catch!

> 
> Fixes: f3768940afdc ("mm/migrate: use migrate_info field instead of private")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Reviewed-by: SJ Park <sj@kernel.org>


Btw, get_maintainer.pl suggests adding below more recipients to this patch.  I
guess they were intentionally not Cc-ed since this is a simple change.  And I
think that's fair enough.  Just wanted to call out for a case.

- David Hildenbrand <david@kernel.org>
- Lorenzo Stoakes <ljs@kernel.org>
- "Liam R. Howlett" <liam@infradead.org>
- Vlastimil Babka <vbabka@kernel.org>
- Mike Rapoport <rppt@kernel.org>
- Suren Baghdasaryan <surenb@google.com>
- Michal Hocko <mhocko@suse.com>
- Huang Ying <ying.huang@linux.alibaba.com>
- Zi Yan <ziy@nvidia.com>
- Jonathan Cameron <jic23@kernel.org>
- linux-kernel@vger.kernel.org


Thanks,
SJ

[...]

