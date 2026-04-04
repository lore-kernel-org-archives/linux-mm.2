Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4895E88D9C
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 13:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D03B36B0005; Sat,  4 Apr 2026 09:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB42E6B0089; Sat,  4 Apr 2026 09:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7BAD6B008A; Sat,  4 Apr 2026 09:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A78FC6B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 09:00:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3EE2A8C4ED
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 13:00:13 +0000 (UTC)
X-FDA: 84620881506.15.AB086FD
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id A4B2B40009
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 13:00:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o39tLpN/";
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="o39tLpN/";
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775307611; a=rsa-sha256;
	cv=none;
	b=NZknJ2slxp+yN/+Oq/6wgxPimok/o/bVzk8m1JQmQWhFynb8Q+675QkasiwLBjWfp5lYFC
	VNyvI4jcQCtE+WZsZYuKsUOktWSPt/0R17MSfVwKD+n4sHGVQWu++KsizWaLrNRAk03lAy
	YTCTACmfmbzHF7R2X4WBfydMyXBKQH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775307611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/xCFsixabF/oYHDluWmOQqI46QTrRWpFhihHLF3f6w=;
	b=CVg+Ss3AVvp2pyxt9oSA5aC8V/ETD+k7Xxt1RjL2+O0InlEWQuaHIUF+FHx2r9Bsmqh18/
	D1XfNSoos50AaeXk4bSZZr3GuWh4UKqN1H/aeDGBKLHVKMs5LPhF0DHsFSfS/9bly/49Do
	EVbRGJbuWiJUps5eVb+CjswjAsHZFnc=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775307608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+/xCFsixabF/oYHDluWmOQqI46QTrRWpFhihHLF3f6w=;
	b=o39tLpN/X1/ghIr3SpkvRvoAfOqlCyzm7GTaiBFhBY90D+7jvG6B8D8jg8fCn6yXJKMxbA
	j4q9WKRLEtu1oWfFCVkkTWFGlDV/3j6QAxqJKeb3p3l6jOXtXplsd3/K1cEQL5/owIdvpn
	wr5A04yiVv/SGp8tA9domOBWJf43wJU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] mm/hugetlb: restore reservation on error in
 hugetlb_mfill_atomic_pte() resubmission path
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260322052120.14021-1-devnexen@gmail.com>
Date: Sat, 4 Apr 2026 20:59:11 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 YueHaibing <yuehaibing@huawei.com>,
 Mina Almasry <almasrymina@google.com>,
 linux-mm@kvack.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EE9ACFDB-E601-4C1D-87D1-F5DAC2767CE2@linux.dev>
References: <20260322052120.14021-1-devnexen@gmail.com>
To: David Carlier <devnexen@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A4B2B40009
X-Stat-Signature: fquw3hgxewmjq9wm99inu7exd3rdmcrq
X-Rspam-User: 
X-HE-Tag: 1775307610-16155
X-HE-Meta: U2FsdGVkX1+g//HAnH+AtVCW+Youw25fnd+cTmN3UjYkWfqyJNVczOf33yPUEtnHbiV9RE6Uq0/thqGRwaVoH1QHBiAGW5qd5oTXk14UjPnf9rw37tcG+Vn+wfxYHoR0quB5oI/a/J6ruqJ6i/7zJxPC+Slecoqs0Lz/PCtiT7aVuW4gTYVkcd0Cxk5LzU1MokSftV3zJ+Mi0bKYAOATb47dRwQBNEMcyS/nufUMA9renf694/5Lr7Cb78RprIG7nmhsABK0wGh5Ooe0ngXvynzulzUCRrMJ7YvkXCMjK6WWLVbcXXA6sXa5CzY1Mai9E70HmorLGfkNtzplsDycKUnS7T3uW2yGOGTmbEYP9qWNjnqi6EsRfisbmKGHCiFeFUQES4RZ+NxP3fRcMcRpXUOyO17wMKi2fXDMwfsNhw5QSruLJzAbXEqOW6Q00q8JyUhhuMyDV2KWG907U/yp1nImtDIK0snssI5vzPgON95SB3+Yu3jNpKcAK4S2FKpGaSf0BtJRVLmNr4ytzYamNN9w0cTFJprRy0Nw3DMiQk0PqGHfd16aPdQWsWXJb0LnJXFkb0ZKXfe0LOYlLgxXbZrjodS9rkEeNM3c9CD1NA5OkubZlGYu23tIvSYzXaNAaPh3uxHC/SZiFPaZerU4aOd3S+YSmp5zslnPuZluFr+8pm8CGMFBQVQyZJUwPjg5YZC4/S1kGD76CWz7a/UeRuhpYUFjqFA/qWq9+FJauenQWicS+aAQGoZVyLrSwLD1wJRtnpFUi07nnN1ityDL78PTkiCNiNn8oF/++PIIO/ny+dsGyvf4mU/Px9SWQp6cIacU9G8UaLTmpKoXXV4uWjzBc4MOmyCFgjOu/sWoVrG1CXc4SD9ackg8fME0u8O/YCrkALsfTAdrkOHZKaN9E5ChvbINauzldb1VUSPTZboLxHHYXYYPl/XBk8JYroL9gAWIu0nukxZFPHcZ/iZ
 G/05zx7c
 3eZ7t+AzY15PfOEyMJDAMGKVfyk22lqsieGUR4YM2TQ0OqW1nz94PDM38rUp0zTYiIvU4jU+v6A56YnNRHXTY7LzYpYlu6ilaLMPPzBmXdWZ5Hvtmjlc1FV6tc6uB8nL8aFfIR2MALSd2EZnj96iEqegkwu5UHqc3R/ll2u32il3f4q2H4mKSiuITBYYHvWDbM9S5Pu6C9EYcWtxjxOTnbOIuqVFyYr4FxDQZtmEofvoed76D0cTeuHDQdMz0Zj0T0NTF8u68z2//uX59P0cH0mwINd3cNZtyxg7zuoFrERSKb3mMOcfwpwEkCNYVmuLNIr5wqPDecGZ8ED+cC2S+bLl25yHmArpABSAkqqC3ZF72ua8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Mar 22, 2026, at 13:21, David Carlier <devnexen@gmail.com> wrote:
>=20
> When the resubmission path in hugetlb_mfill_atomic_pte() allocates a =
new
> hugetlb folio via alloc_hugetlb_folio(), a VMA reservation is =
consumed. If
> copy_user_large_folio() subsequently fails, folio_put() restores the =
global
> hugetlb pool count through free_huge_folio(), but the per-VMA =
reservation
> map entry is left in an inconsistent state.
>=20
> Add the missing restore_reserve_on_error() call before folio_put(), =
matching
> the first-attempt error path which already handles this correctly.
>=20
> Fixes: 8cc5fcbb5be8 ("mm, hugetlb: fix racy resv_huge_pages underflow =
on UFFDIO_COPY")

Hi David,

Thanks for this fix. The patch looks good to me and clearly solves the
reservation leak in the resubmission path of hugetlb_mfill_atomic_pte().

However, I'm a bit curious about the Fixes tag. While commit =
8cc5fcbb5be8
did introduce this code structure and the retry path, it seems the bug
wasn't actually introduced there. At that time, copy_huge_page() =
returned
void, so the failure path simply did not exist.

Instead, looking at the git history, the failure branch `if (ret)` was
added later by commit 1cb9dc4b475c ("mm: hwpoison: support recovery from
HugePage copy-on-write faults"). It modified copy_user_large_folio() to
return an int and introduced error handling paths that unfortunately
missed restoring the reservations. Should the Fixes tag perhaps point to
1cb9dc4b475c instead?

Furthermore, if commit 1cb9dc4b475c is indeed the root cause, I noticed
it also introduced similar error handling paths in other places. For
example, in copy_hugetlb_page_range():

        ret =3D copy_user_large_folio(new_folio, pte_folio, addr, =
dst_vma);
        folio_put(pte_folio);
        if (ret) {
                folio_put(new_folio);
                break;
        }

Here, new_folio was allocated with alloc_hugetlb_folio(), which consumes
reservations. But if the copy fails, new_folio is freed via folio_put()
without calling restore_reserve_on_error() first.

Does this imply we might have similar reservation leaks in other error
paths touched by 1cb9dc4b475c? I'd love to hear your thoughts on this.

Thanks,
Muchun

> Cc: stable@vger.kernel.org
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
> mm/hugetlb.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 88009cd2a846..d6ea11113f1d 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6295,6 +6295,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
> 	folio_put(*foliop);
> 	*foliop =3D NULL;
> 	if (ret) {
> + 		restore_reserve_on_error(h, dst_vma, dst_addr, folio);
> 		folio_put(folio);
> 		goto out;
> 	}
> --=20
> 2.53.0
>=20


