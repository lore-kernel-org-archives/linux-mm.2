Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 385A8CA5FC4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 02:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB98D6B0088; Wed, 30 Sep 2026 22:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A5F6B008A; Wed, 30 Sep 2026 22:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7FD36B008C; Wed, 30 Sep 2026 22:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 914936B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 22:06:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1DF091A025D
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 02:06:05 +0000 (UTC)
X-FDA: 85272417090.01.88FEA79
Received: from mta1.migadu.com (out-212.mta1.migadu.com [95.215.58.212])
	by imf01.hostedemail.com (Postfix) with ESMTP id D4BB240007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 02:06:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qhVMhNPg;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.212 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790820363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0PgT7IXqGYdBGJT8SInFKTrK62+bdG9Y3zXvK7Pap7c=;
	b=h/FFt7UiUfWbo8JR4MwrwnbM3fOeZKCAyFWoTiBTGOePErEBbYqH6SDUjYXFKpHIEbb+aT
	F07xXhx/N8KCHxFahv7REX1Hl+Pk6+TIQX0oX7Kz/Fh9eV60pgO7rjC0XfnZkcYgh+IK9f
	BwdN5fyYZvh/cRsz+tQQqFSoxz1Llro=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790820363;
	b=e1Vsf2BmWubnLuvyEH8Bm+PQ/sbBGrRzbwAtqALwpqJ2xF72hyqaBifv9mwPdHk3JIU8ki
	fgtpbc/qZfce3O+oOJIyBKFKzmtQwnGYwTOMmQEX/45tyc/Pb6jWNIeDdQcFepkQK/e/3b
	T0ExYCcd6NfiMAraMxHfo9lCan6oVrw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qhVMhNPg;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.212 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YagsZlTkcHN2bddnpunvmPCH8Cip4+WkjbvDyxAtdJ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790820361; v=1; x=1791425161;
 b=qhVMhNPgSbaAEQOJ0oA9YzP/aQIoLOlFQJBbwUProbKFs3I5Anf9q/253TKTEI9z9fct+Azs
 Rz9Xy5HORawsNhtlVJVKI+zAcIuzm2cPY5crc9XeXX9gp7NQAf+TigpRj6xfPm14nUpAt0N8YVc
 XpgJIpRtMG8/4iUQFHtE3jdo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a8a0d2bf9a452d40;
	Thu, 01 Oct 2026 02:06:01 +0000
X-Mizu-Trace-ID: a8a0d2bf9a452d40
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH 1/1] mm/memory_hotplug: fix missing rollback in
 __add_pages()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260930160432.5564-1-lance.yang@linux.dev>
Date: Thu, 1 Oct 2026 10:05:43 +0800
Cc: david@kernel.org,
 osalvador@suse.de,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D52186EB-026B-4C9D-BBCE-875F259634AB@linux.dev>
References: <20260930160432.5564-1-lance.yang@linux.dev>
To: Lance Yang <lance.yang@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D4BB240007
X-Stat-Signature: zekipinwd9kanqjqa1ah75s9npci5wr5
X-Rspam-User: 
X-HE-Tag: 1790820362-408792
X-HE-Meta: U2FsdGVkX198bZ0Yp2Yv9D5tD1GPmusMMgHEjX/2u4HmKSZvOAxUtecEvE3QASBZI5KF3PH92vybmC/Uijv8ycyrtKpoMeRr5WywQGF/HwUJjFG7n5mOO4tExuvleGiCft5fONFc5KugVJL9xnp6n6Ugn284OwdE1kfKnEhtTPlNbZop2M+GYhu+gkWZanigjNGw1ZDCo9Nsjci8FWb/GFNdRPXoAQ8SORG+KWo6uHvGB/hLfZ0885XYiW9rVZOqTqXuzkCOAzUDB4yZp7+ZLS5ZeShbJaUxxh+ozTo7n1U5WpjtVAQvaEo8lyfWgg5ZeKebVPxXSzY1b8qjHN4lLwSdV47nMlP7sArCGQeFsIPPvXUtqx/Mo2Ex20zUVdT/aOREmuKpXPkfgVjOQUiahcCJrIedu52id0hiSxcDVIXdUZEv0ao3uL/F9aEimL/PKC22SVLCmv+oK/2/X6ABQR3WB02C9CjtFQo6fKwjrHf4w2az0DoTp5WqFd5fNnsDYEvfRH4Ytf4pmP0JI/eqXCvJPrWuru0f/GlZoEF+8257JUPfaUX7RBN5Qjb5xI1MHFfw+FMNSh6poZsem48BRXq+mkex/PUnGfglB6SZBaB6DIG1ua6ksrPBdKqvl4KHh1qR71M4zn5RHnVIhkdkl14gk2sbMPhQYKorarvevX59QhewCGrimEpGWCy8kFz857LCOixoZp9Twb1K7OCTHkhLpQkuAobVbx+U8+VuMUa6utpX8Gk1XNjFLfVtLGkdvk+6ZAvRzU2XHrCVTvg2abIWkFwxcQj2pZgPqjKMkUgN1kXesV9kvSERvgQN+D+RKAQgrrAxJYCZfayjn9GH0ht0ZdNQjm9Ebi1lSQHa5GjMn9LDrmJYjoUu99PwajS6VFT26OOZmtg95uRsGPt7daLY7/FmxsjpUs2OnPvL6ahO/JqIvY4Y6l+NFuJyI4CiEsj+mYDdNCWQqSFhVUw
 Ev3Gj2Ze
 KWjPd6p1Pd0n/GkNf1jIH/DnqIs7/jazefky+CdxNHMdAJwO5YUHsYzIKgvYelBhHZXTcEbz5AadqlhzvRyNH6XJVk7tHoYf3r5uegJvdkkeQxtIpUUeErvmP5ChhDyxbuQqzLgE3SS9bKN6U3c1M6NVFBeCEgYB2XdoxU5jhxyT9l/r/+v1IxOn+vqHCRqBbxCSZxPtNbvlYh8qg/ylTzkVwxscP7dagG/NIWoWSiKc4JYZNYWGweo0KuRrwwvCVI5w9qRbDXYX0tUbFOFXXjHOxcy4rut/ZfgfDpGiXAf+8d9uTVURCsvlfgxKZVI1XshAP6B/Dv4xT3pTbVNNToxw66sDdgBQAv7qNPHBHHm4hvCLrCHzr4yMh+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 1, 2026, at 00:04, Lance Yang <lance.yang@linux.dev> wrote:
>=20
> __add_pages() returns on a sparse_add_section() failure without =
removing
> the sections already added in the same request.
>=20
> For memremap_pages(), the failed range is not counted in =
pgmap->nr_range,
> so memunmap_pages() skips it. The sections already added in that range
> retain their vmemmap mappings and subsection bits. Retrying a
> section-aligned range can then fail with -EEXIST.
>=20
> Save the initial PFN and remove [start_pfn, pfn) on failure. For a =
vmemmap
> population failure, section_activate() already cleans up the current
> section, so the rollback excludes it. If the first section fails,
> __remove_pages() receives an empty range and does nothing.
>=20
> Link: =
https://lore.kernel.org/all/BAD58999-1EDD-4A37-ABA0-DB1BD8AB3453@linux.dev=
/
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> No Fixes tag, as I couldn't identify the commit that introduced this =
issue.

Hi Lance,

LLMs are quite good at tracing this kind of code history, so I used one
to go through the relevant commits and identify the correct Fixes tag.

Fixes: ba72b4c8cf60 ("mm/sparsemem: support sub-section hotplug")

Before that commit, __add_pages() ignored -EEXIST and continued with
the remaining sections. After a partial failure, a retry could therefore
reuse the vmemmap of sections added by the failed attempt and continue
with the later sections.

Commit ba72b4c8cf60 made -EEXIST a hard error because
sparse_add_section() began using it to report an actual subsection
collision. That semantic change was correct, but without rolling back
the sections added earlier in the request, stale subsection bits make =
the
retry stop at the first previously added section.

The vmemmap removal infrastructure had already been added by commit
0197518cd367 ("memory-hotplug: remove memmap of sparse-vmemmap").
Therefore, ba72b4c8cf60 appears to be the commit that made this bug
observable in the way described by this patch.

>=20
> mm/memory_hotplug.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 796af1028ee2..ca4656698148 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -380,6 +380,7 @@ EXPORT_SYMBOL_GPL(pfn_to_online_page);
> int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
> struct mhp_params *params)
> {
> + 	const unsigned long start_pfn =3D pfn;
> 	const unsigned long end_pfn =3D pfn + nr_pages;
> 	unsigned long cur_nr_pages;
> int err;
> @@ -413,8 +414,11 @@ int __add_pages(int nid, unsigned long pfn, =
unsigned long nr_pages,
>   SECTION_ALIGN_UP(pfn + 1) - pfn);
> 		err =3D sparse_add_section(nid, pfn, cur_nr_pages, =
altmap,
> 					params->pgmap);
> - 		if (err)
> + 		if (err) {
> + 			__remove_pages(start_pfn, pfn - start_pfn, =
altmap,
> +       				params->pgmap);
> 			break;
> + 		}
> 		cond_resched();
> 	}
> 	vmemmap_populate_print_last();

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks,
Muchun

> --=20
> 2.39.3
>=20


