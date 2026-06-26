Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70EC6CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 03:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F5A6B00C9; Thu, 25 Jun 2026 23:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DF316B00CA; Thu, 25 Jun 2026 23:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8F36B00CB; Thu, 25 Jun 2026 23:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC4EE6B00C9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:33:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 401CD140317
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:33:40 +0000 (UTC)
X-FDA: 84920644200.01.5245F1C
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 197CA160006
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:33:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lpdVZb7d;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782444818;
	b=lbaxjEPX6Y1vVXUBk3PMTJp76q3zI19eO2ElxcbtB6zc72LQVHzjPvm7CZEboOX8rzDmeG
	+FHrYOt8Z1SpGXdbDzI3vByI6PujlhemxBDux34sL2E60je/GblewxXYq2U4SI34gX2V59
	36bQJkxutDo2mwLMUpZ7ckK88xU2fAg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782444818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0HCGQZ57BsFjU/yjnNeadFJo2JebiPKo37EWE7E6eNU=;
	b=tRxkQ9Vj3dsIqVvxYs+PFAyqKIHa1K8mR5UPsMqyp1wAzyXxj8EoQ/iXl5urRFbUCAzaji
	56nt2nHhtbTpDy5k2GKRyM5SGCDVRdHy0COVrLcfck7JxmIFrMMZJ7gvHQG3jf/w3Rip6E
	TwO6lbn1QxJnAPySSRKYfMZj/K9vuu4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lpdVZb7d;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782444815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0HCGQZ57BsFjU/yjnNeadFJo2JebiPKo37EWE7E6eNU=;
	b=lpdVZb7dYZBVQfZG9ALV8QZZPn5pCWrHjojmjbeGjIU4iPSQOMA0ewkkkcghYLsUKx63Fm
	FoGY+IQM4XOitUE4lPfMPkCtzcm8hmMBnJ7uP/l4sNIDU4BIqK3VLTQRPgIQLuwoydkHzj
	J4haBNrsxLdlCOvXEsR5ZnsgyWgo3Nk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 3/5] mm/migrate: use huge_ptep_get() in
 remove_migration_pte()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260625112955.3254283-4-dev.jain@arm.com>
Date: Fri, 26 Jun 2026 11:32:03 +0800
Cc: osalvador@suse.de,
 akpm@linux-foundation.org,
 ljs@kernel.org,
 david@kernel.org,
 liam@infradead.org,
 riel@surriel.com,
 vbabka@kernel.org,
 harry@kernel.org,
 jannh@google.com,
 lance.yang@linux.dev,
 kas@kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 rcampbell@nvidia.com,
 apopple@nvidia.com,
 ziy@nvidia.com,
 matthew.brost@intel.com,
 joshua.hahnjy@gmail.com,
 rakie.kim@sk.com,
 byungchul@sk.com,
 gourry@gourry.net,
 ying.huang@linux.alibaba.com,
 mel@csn.ul.ie,
 nao.horiguchi@gmail.com,
 ak@linux.intel.com,
 j-nomura@ce.jp.nec.com,
 pfalcato@suse.de,
 dave.hansen@intel.com,
 tglx@kernel.org,
 jpoimboe@kernel.org,
 ryan.roberts@arm.com,
 anshuman.khandual@arm.com,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <7E9EBE58-C2D0-44F4-8797-D8077E26AFEC@linux.dev>
References: <20260625112955.3254283-1-dev.jain@arm.com>
 <20260625112955.3254283-4-dev.jain@arm.com>
To: Dev Jain <dev.jain@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gd5puii5ggk3i9pufijr8y4rtfkca45w
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 197CA160006
X-HE-Tag: 1782444817-826989
X-HE-Meta: U2FsdGVkX186iTdcY1CgYK9R9cQT8fS+0ShdF/uso4cvaxI9i4brPBKOeDmcu43+tswTSEAnwwPFO7JMylVELBe5f6RR6JIH/QV3XDqWkryVFIiK6lfmC0VqY0CiVwF53dkhRQEdE4in5Oi+FkjYJzsks6JlnNkPJ49vIzinGrCZKyNuoKv1nbVMtUopvKQdvJy1IQqR3AfbxU0hC+OCgrr7E/a/R4QvmZEy7/pGy+TkMKxRZySIYQMd62j19naeCP7YcRyt7HnH7mI5D4W0//8W6xrQ3zSMnWG1Je89qIua56HBuXlN0fNRWva5W/NSdAJvOst5cSpXgZ+QKKu+yhfvrf2TI5To7Os+l5/uX6jFrHvrRL6pjXWsbrj6Tz3Rla1vIlRTAWTcHWZmH+VMmjm81CHssBq510ppFJJhvOEjfvRUzD5gw30BKUa4Td6zANg5iTDCV32D4L38tvI2zBeC+UNH3e+xEtHcgn61+asbeSp2B6zqBQvqZwzjyGVFQtqp0ZHfUbSWkl9buZn44eYQyF+fcpaN00msB9FBtpj+QevqutK+PgXnHxa8uU0Y3aYB3075FaoI7/MvS552uyumSFpgZy2VL8G6wcuqli3LaQDXyjgis/doOuCyoLmYOtUzQIY/jwJzUJuyoL52JCmOxEX6/PPIV+2Di0evgobUEdO5cxb2bhkISjjezrMQlns3SM6P2IwuzOtj3V9VMWsM450cwh14RgDnVGq8/c58owJs/2m9UDAI5eReYIrjSksUz412pMn93iQNQOmIzKGPBurmIPVErwMpXyZKKj43CkmQKEgIgZZpt12UhNRg0q92YdUUYEPCjM6Aw0FtA7v1wrV8EWBcPrhWesbWr9pmOPuM8qfImEKVOrb/NQ+TMWIohj/cJzORKx7AQJm7nC59oyYY8ef7OophvX1GChOlJSf44Zt7YMQA20/ZBAcAdjCJvb16E2b8mF2TMPs
 2zL66GOf
 VHT80/GOp2wwnHjA5PFLl2kDHpyYsnLgkPPeDHKxT5mwPIV+fD9T8Ei0/YTt11trkPe6Ti31dbzpvNz7mkPVb2+OhmIsGsSVGipJLG5hPuOrm7fdDEyePR6+pvn+BgiV3KZVc7EhNNkhROqJRZ0+sDm8VWeGDsVEb/2gZfS3r5Wo+RkP56/tiNRYdMfZySJ3onNtzcQoMJRfSEk1Nik9U+sXDAeNGx3XjpzNiisfk77t+K6/Myh+VokYjgh8NJMjZOtOt9JOIh+MRSZixo6mCAsDSxNwmJ9KLhSV1Qz4l2Tq3pvbyNzO9F/llnE/g+jokuWD4j2l6ZUvekAjY3+UbPt1VQdgxwPplBe9hQitKm5+K6L03DbKncA2w9oMYiCQRzyxs3iLLSHufvHUgbwGHmMXrmk/SflwaS1VnHWuuIN5mwhl/hufwSIIsO97cWOYn2mVR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 25, 2026, at 19:29, Dev Jain <dev.jain@arm.com> wrote:
>=20
> remove_migration_pte() converts migration entries back to present PTEs
> after folio migration completes. For hugetlb folios,
> page_vma_mapped_walk() returns the pte pointer to the hugetlb folio in
> pvmw.pte, but the code reads it with ptep_get().
>=20
> On arches which provide their own huge_ptep_get() to dereference a =
huge
> pte pointer, accessing via ptep_get() would cause pte_pfn(),
> pte_present() etc to misbehave.
>=20
> It is not clear whether this has a trivially visible effect to =
userspace.

We are dealing with migration entries here, so the issue mentioned =
shouldn't
be a problem with any of the architectures. Semantically speaking, we =
definitely
should fix this.

>=20
> Use huge_ptep_get() to dereference a huge pte pointer.
>=20
> Fixes: 290408d4a250 ("hugetlb: hugepage migration core")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks


