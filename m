Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36CE3606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=L5SondQz
Received: by kanga.kvack.org (Postfix)
	id 291016B05B2; Thu,  5 Nov 2026 16:25:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2417C6B05B3; Thu,  5 Nov 2026 16:25:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131296B05B4; Thu,  5 Nov 2026 16:25:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E10126B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:25:23 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 494B580A27
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:25:23 +0000 (UTC)
X-FDA: 85402346526.26.4614CD8
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5052320002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:25:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=L5SondQz;
	spf=pass (imf03.hostedemail.com: domain of zokeefe@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793913921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7IgY4oSwJmunrObC+s4jlkajaBgT8VZrvasnO3k+eC0=;
	b=gOBwQSXKVSjXd8MXJxo9B3ZsWsQsaZvekAO8pi34jQY1VBCJWXtV9RHuswiTTW/+P6Poar
	tNzAKV1umhv6fxYot8kbC3L8h+dBwM7lD/7kT8KF3nOySooyOGx9jAcYXtHe7sDOsOxI3w
	Z4WUdlZTHo6uOZ4+cX+pl8ZNjWfyz4w=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793913921;
	b=uphdudDF0rED1Sqy3tThGuXIUrj05JvY/2cHd9U4GnMhoJjhH6cqt9EFTEi/CdRLwuUk4L
	7WYLl1AwyzyNVQXRBi5iVN8BNVeFshFq+JKCjet2pTSvhZLctYhNblKQIVPU3QE3SBgmRT
	Ytzr7jU4RnTBGJOLUdI0UluS4LAcRQ4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=L5SondQz;
	spf=pass (imf03.hostedemail.com: domain of zokeefe@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-535f598d126so16281cf.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 13:25:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793913920; cv=none;
        d=google.com; s=arc-20260327;
        b=fnTH1NxnOpAVs2OqKTO+ByzOO/qUU1ZRZTcvrMHiPefvqW7XH5wHprgqi+e8+enBEm
         qkztBxHdaR1v98s3KwyowLKyMoIVpdH9QhrriprfbZUul43l8i/oncWZsj4LvIsLer3q
         8ir9o1IQAJjzW+4tMi20qCkp0km1NvunUmnmfSP3IBxpE53JFWsO2gySw7cJzO/z3NIj
         cnA3CR267FY4j0r+c9oOJr6FTQAVYAJCsHoIPAMPQ7bpiFNHUfkV4pqm3RbRZVADXMa7
         65gE5I3mULL9Dunx4u1jhhoiezL7Xrji8OfQK71JDguF+eJ9yi0n78mOwBEJA6ASkN0b
         jJQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7IgY4oSwJmunrObC+s4jlkajaBgT8VZrvasnO3k+eC0=;
        fh=16ysLZvWeQK/Rfk9xpPXRcgb21MaO7AzLVzyXCFLck8=;
        b=AQjawfoF/KT6tUjmbFh4DZdJIIMJjVkXI0CzzmkxAX72a0cRU+Ss+74MpcazUvBJx7
         Y5+G3cyCflVlvKz4msgKVuwoWINv4vpmlvEabrek4cWtiSeIsEejx9wmHptqTOOZeokV
         iSSf1vKy0d0bOCAMT8qVmCCWU6XN92VZUkdKm7jfiy/Z9n2FxjyNIa/T2hS3SciLkJsJ
         u4kYq/U5RnAqy4uFKCCCG9v0Qgk0YOG8fZckgWi7TWeqJiIwZntQeR/X0ORq33gszhLp
         x4uE5aNP2quJl1+Ke3wVQyC0dhzGc8EUdmYiUMomRKQCECSVCMwZEfk7RB1uDM5XKpkF
         HNZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793913920; x=1794518720; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7IgY4oSwJmunrObC+s4jlkajaBgT8VZrvasnO3k+eC0=;
        b=L5SondQzHSQ26RrcL0IgzOxIRNm8Z/KdjLuojNK6jEDcZBmU+MfVIaf//DFEULR2uu
         MszVBFncPPS57dH6ySCTgg1pV548DwsqliZ9/MplXVC0rU/5WlxSctvCGyC3tndecF4p
         KQ8BoCKpGddAWu555aH6Oy1ud/bgXYaLopZ6pxVonmI23OCCTEChEWBtbcl+ZlYxmlTC
         oKOnmvafO6BjXRteKTjfhN8LgjGQLaT6S3UfBr7aHRIskw2URaaD2y0UEQ+0hhBk2x86
         SXqDsK/TrCW+GoxUyJ/bhb1ns67jTVHcoKROStsAv5We4TyQOz8tfSNVMw9vYJOxFhih
         bg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793913920; x=1794518720;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7IgY4oSwJmunrObC+s4jlkajaBgT8VZrvasnO3k+eC0=;
        b=rT7BGWxwTOeryhf+qSqdKwkpAZRhrfK7luqApU3ewJd4qDtfTGWbAjVWZ0nmaIt04P
         uyAZ7w7K7BSe78gM7GHdb/+JM7OSvC2E+Rs64TEa5bVz7g0hnYKapQk+yAJqRNAuyqMp
         YM47wMSk8UeZX3YD9S+arViZnq8tqrJnViyRFmteG66641ap1fOX5/CS5ywqn2QPrstc
         bd2ssVEE7DC8+OAHZ3JZV5k9pyH4nS23Y6XrrW7TfsooqWc6E06N6pPk7hhirwos/I6X
         1EUfix1hD7duw5ZbEghIAsCgmuZOA6ZzGQmL9yAt8FaKo8Fm/tftKAcCOZ3FXjXVnSsU
         zMxw==
X-Forwarded-Encrypted: i=1; AKwUvBy4MFFWMpJL7jh5iD2B3+WYhKNyZDv0ezTnzHoTFJCL3N1PgE7Jyn9KHyW+c8j41HsqqyfCeDyRjg==@kvack.org
X-Gm-Message-State: APuU4Z+iLsOZZtblpZ9MMNG5copyINexuDnPHUx7CFEKQlec3ZOQW1dT
	xPdfNqxubOYVrKBaZobQtggMuEPkPxdDqZbJAawJcTj6gqUPpzD4u+cS4Z0r0gT0QAisB4luvAp
	+NCBGQN+3VUweYegeASAtTlY7NAaSuUooTSoOxZjH
X-Gm-Gg: AYBFou3bezMws87Jm8HxfRZz2scYuzzulCqKxbDQXNNnmBl22FTAMC+E5H/+wJn27Pj
	VQMlF9n/5ie9e5kjjkc4c5ZP55TQg7VE7Mrcq4ncBjB3Pb3R61dvwiLXDEoxbYJ/yBZ35sO1IFz
	lFtgMQgMIOZczfF6HldF8tsAf42VeFDuZ8i2CjlHd++Mi66sIkBxIFzK58XIZgU1wqy8Wf8IQ1y
	khEFAUyv1aVaECVE7hgKnGcrLz5GUqYhXumOYmm8M6RKlKiLciNo+rLeTtCuIG/KALPxfXtsXMp
	5J0q1mrpJjGKAY07/G85xU5WYXgs+5CrffFxYBBNDxJdDt1+Vxq6ksoZyF9ciM3unvDzhDYEcQs
	2JkSBzIxkKS9SFsDziCKJoDIHaBFglPU9O7DeLA==
X-Received: by 2002:a05:622a:4118:b0:536:934f:7da2 with SMTP id
 d75a77b69052e-54e18ff2e12mr4497211cf.2.1793913919805; Thu, 05 Nov 2026
 13:25:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org> <DMNJSQDUACRI.HXKF5B6GSQOX@nvidia.com>
In-Reply-To: <DMNJSQDUACRI.HXKF5B6GSQOX@nvidia.com>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Thu, 5 Nov 2026 13:24:42 -0800
X-Gm-Features: AclHuK_cW9BDiSPs8h6BDqPFpxUXOylylNhDy7qGq0VHRrxqPWf2FvEDLTBnfxI
Message-ID: <CAAa6QmSF0bkATC6kNO0B1ydFtDi=OEYJJ5eH4zEakxjJ9z7ZqA@mail.gmail.com>
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate in MADV_COLLAPSE
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: oriqrtyqw5w64su7o3xuepgzcqtrg9rd
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 5052320002
X-Rspam-User: 
X-HE-Tag: 1793913921-119531
X-HE-Meta: U2FsdGVkX1/9QT7SnfdZp7eRmvtjyg4x92R7rEXQx/X5BbWucx0EVKwzDOCxD7gS3mJAk2qLN1Cfru5T+kK4E1feALyHWPKi+xmxY1pxtdz+HDgz0YjGFNBbYDo0JIXCKH9ENDgFoLH9OVzgOK+DtvcNcfLklOLAv9/lEGq6COZqTKEK9RabdTjqN6r6FEtTZd7Z8jA8ZHmkXJLJcyG5467pcAGNvRzUv6AhUC+7Ew83g0c9hz2TpOsR5cxRnQvzCoYS3UrhE2lnYELWA/8QLJ6jdJUTHDjz2grWghJXJaKZWilkILaUKTlHSxJ3geM8jEoy6bcRMCqxoCbtSBlOmJ6e4DgEEz0TqYTJHqS+ieYun2wSHFzCdqi75pSao6hYdMptEVMyuamVLxjQeD83KvtADMjQneMS1AFJs1bHZx5w3EcmY2WQI+U/IT2GJLpvxdxndu9GRCqakKDVouPjcP8sKIP6n0WYQHyaNf0Ub+fbbhRebA70KfigQi/8DO8nqVwRCKzbB98pbtIwGwBAvb+Bo6/DGQLxOBCmD5R0O3gHs3jilvDxPSaE/n5Uy/bvoBLlRO//OfHjtciOV6RiywcbaZITKemx5a6x+FA9DneyaDG+saV/xAurQsuHv65MFnc42YQl0usVpGJv69OB4VsogOAWP9N1O7JZdKKWrIlyml9/4Hs02tEWs1Yqe/jOw7Dn4WK41d2EC/Ss2OmIgCKYRuN7Pdj2CSBGw2309/wSZzpGcTuwQCpJXCdb/nhBek0kfATqnMpOFMWLGhLz9DWXvyWQT0D0p2vAZ/O+/U8+ci/ArLlV1EBmVzUJcfQp1BObb1cPjEAas//7iELIPBuxsCIZpnizl3fB+cfG2G+sAG4+r/8M0UaVUs+lEnVnKQ3Te7rW+sTpGiVBORBWGVoYULcmajpLOeNXL1dhHO1zniNT3e1wcXpYYjQSKauD8v7GPGmok93cO6/Zzw4
 Q3lI4I7+
 9VsNrxZAdKA3fn7y+3TFJ/FddzgqF/4RGqMre0PL/1OUYwfGnMmLeiIOHcNQcGu5aKe0KMTSwQIC3y23UwJiX+ErTlwDm12GopXz6rD/pNfOBw1Tpg7bYIUmPtUViY3aXmtjYNvwb7rCkpSZaZ1MMQh6Bo1/0r32ZOX3Dza0aSqi8LoC8BwPKqqWPfa09u3EgKYoKjDPRMqlrfa63rXPlHOQZNi5P3e1cO0SAZicFi3TFfkGhtiZQm2zaaWAvpOOO1qDqEYar3bIOfYvsj7aZ+J7unWQjsKPZ0z583p46Pvy70Iv4hW7mOT20jTJZuumRHwNBi3t7SW9HuiPTx0rVo1PYnShBiK3dsM+k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 12:09=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On Thu Nov 5, 2026 at 1:16 PM EST, David Hildenbrand (Arm) wrote:
> > madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
> > uptodate. For example, shmem fallocate() can put such folios into the
> > page cache.
> >
> > collapse_file() already refuses to proceed with folios that are not
> > uptodate. Let's just do the same in try_collapse_pte_mapped_thp() and s=
kip
> > such folios, leaving handling to the page faults.
> >
> > Note that collapse_file() effectively clears shmem folios through
> > shmem_get_folio(); let's keep this fix simple and simply let the page
> > fault path deal with that.
> >
> > Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_CO=
LLAPSE")
> > Reported-by: Chris Mason <mason@kernel.org>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > ---
> > Once reviewed, I will pick this up in a timely manner.
> > ---
> >  mm/khugepaged.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> Makes sense.
>
> Acked-by: Zi Yan <ziy@nvidia.com>

Ah, good catch..

Agree with Hugh that the "pte_mapped" naming is a bit of a misnomer,
though it was how I was thinking of things at the time.

Thanks David / Chris.

Reviewed-by: Zach O'Keefe <zokeefe@google.com>


> --
> Best Regards,
> Yan, Zi
>

