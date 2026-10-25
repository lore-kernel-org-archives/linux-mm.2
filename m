Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3192606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 13:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QL3mvhZq
Received: by kanga.kvack.org (Postfix)
	id 8DFFF6B05B1; Sun, 25 Oct 2026 09:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890E16B05B2; Sun, 25 Oct 2026 09:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F646B05B3; Sun, 25 Oct 2026 09:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 436726B05B1
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 09:25:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3FED1A02AA
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:25:55 +0000 (UTC)
X-FDA: 85361221470.08.EEA6A5B
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id D0CCD10000E
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:25:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QL3mvhZq;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of danielmaraboo@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=danielmaraboo@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792934753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mi2nRyZ2cCGXqGYSLBWNvU2xGmO6GV/Jqec+NuWue9I=;
	b=ykw5Oq3augCMkEiotN3WNBQ1tjDjsWU6kDJISem8UCZggKf/K80LmD2/mzb/yNrwelLhZu
	25YpN4qPKBSyKjmOaPbVwFQa39rjnIfcEbK3IVQw7EiD2KnDcV7U6hnTEqY9pt9FWetKrD
	Gs5jEzlDEeoWamV9/sV92hNiXxJddyk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QL3mvhZq;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of danielmaraboo@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=danielmaraboo@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792934753;
	b=4EY/ngnNWgecEGRExdABATZ/xVyZ1rkkRQ7a29wRhROy/PS83ssYLoc2QzdvIR08v4ykj4
	GowBzZqmt3HCizQawSqsWaBTLrv38RGHOIzKDBiv2oJUrNSTT/g96z9iqenQcVs9tsJE1d
	B7d+U65w1JTV1doghoXtSZcUNffpEjQ=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91c1f548f87so35557096d6.2
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 06:25:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792934753; cv=none;
        d=google.com; s=arc-20260327;
        b=oAOZbWqg6/GbYpGlF2kiNIFORsbL1hEZW3/hx58KVOjgW2Aioa1fL7Rn+PfukG+qtq
         DOaTSZso314lf+4d3ZzBbviFaOYKnryon/mvIn7xHzi6LCjKXMiyi23ti0++8S0CwxBC
         m+9UM/n2hyj6IgGiHbtkk1gZ33ogcbeW1B0bLJ62jhw89ORxDxpO3s2Vz8KOeWzJK+AG
         +EsKiLrO5trLDgmQMCdQ15+vKjPpOlBUK46zAnFMdoie0RNSnBLWDE3uTgpuudD1KEL8
         5oVwLUOfaaKaM3pThYa/Km51lqfdN+x8AyM3WaaKXfB6UfN4Xr7ldLsOADPBHClGt0JX
         byYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mi2nRyZ2cCGXqGYSLBWNvU2xGmO6GV/Jqec+NuWue9I=;
        fh=a3IFsN47o+3H/A9jAcOD1GxA8nGUv9VWON1/8TFmCk4=;
        b=HZ9Kq2kCI1nj7ZoKMjOr8XbX5KRFw3t1qaHEsY2U/Mw+PWZoFjXp+vmdGjRSVUUlIK
         B0v+SLSY/nvF3avu4glONE2nfhhnKofMjp+mw59t4K/EJnpafH9w9kgWJ/HmYkCaw70Z
         gtzmL8IqX2P1A120jQw9+tGKXjbTh3xCG5lLIMOZZJz1V4kdHqiQEyk9SoHo/ldl6NFV
         5MGO+Q90Szx4qsvpKsrO6kPbIu6H/jHpWTfby0RIAvIspDIkt6QnnJEnsJUOcvCMvULq
         0jSFBlpTVmuqV3+wrHrYJD2KySiwZTpelWFG60UtJ5NSDPWkDUx6DKbr+0P25gUyyhVf
         JfHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792934753; x=1793539553; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mi2nRyZ2cCGXqGYSLBWNvU2xGmO6GV/Jqec+NuWue9I=;
        b=QL3mvhZqAu9unZNabCz5sh6+Qfqq1WDoJjxaRg+5a1kUjsih8Qd7kVaTO+RbJ95owc
         thfu3slQmOZ6BayGS0xDL8a6z4dO342a4+Dzd0+/2NPI8a/DToZuLfs7GF13uj4CgQG/
         rup8fnkS4ai+tpROD9s/wiIiPSuJ+Vi4Kmj1rx5Rjahif82TUe/Q+DKRyMc93A7DAQ2v
         t2MlmgbP/6kZLTi9v0XJSNoKoEKkEa68+2D7j66daJVVDbudXfERllRMoRmtHiipCBup
         b3udCymLrpl/aNo+cQmExcN1lBbEOIaa2XHQleSlpflBDC9KGnIXoO2YAabX2mxU8MAw
         mNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792934753; x=1793539553;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mi2nRyZ2cCGXqGYSLBWNvU2xGmO6GV/Jqec+NuWue9I=;
        b=accKORfiWKwkK9ajDfjav1sxSTjzpDN7yp/Zlop7mCxGTP5qHpfWEi3b83IQlm3mQ5
         aWDowb/uLEJoNkT1dSWaINOlKoIAqXmtP1O+/+sTXzfBy+qnEHBLlHvp7KShGVTjfmJE
         /4KNqkXzGi+j5i3fsR6iw39408iGXv9sQ7R3ApH4/A7/5/ukPMFCNK3c8F8T7uzNxxT1
         IaugUJbttlD+mzjlgo75eOAdBmYo/DJqWcqmZET+9aT8eNRonXMjoI7mfVJcG2B+s5No
         92XRI+OjWnZYD7xrYS/8Akdy9OvHwygdrvFGrUqV2E9O72i5J3YvP8nKkBpiTF1Gnj2M
         AT8A==
X-Forwarded-Encrypted: i=1; AKwUvBzimxrP93WrYjP1najuLauuPSHaHUP/aVyg3gz9uwyXKUjMrbuGvU/4ea0uUMPzV7Ymns2QriHliQ==@kvack.org
X-Gm-Message-State: AFq9FYKcPEQV5EIsJkAF6YoIXGXTyIMhSTntmwKgkxsn+EJaiuOGkG59
	VuyTv8M9QttnMCoDawtUAFbMwKpWhrnIK7XIqi287RJbLFouSoFcsDb+XG+3fwysrLn5sAwftmK
	1oBkm+HHfiulSp4yoVXrEYTaDkRQPWnMxB5wNLFE=
X-Gm-Gg: AYBFou3soXlyzAKks84GeDSehvekTFbG3MGmMPthakZTuoVi4hYZUAT4q6JTo2oXs0a
	siq2HNcQrE+S7yzeyeCeF/kSfoNG/gMWbv0bqSl8yuYhQBf2Tw2lvuFI2tDlHvTjWd/A2Hq6iRU
	mj6qA/JGQXWG4T6tyUXQzTgkUwJzPgHLk697z19EaP+EWOnMz3YR03RwVHQ/w9vjc164oIjPlR+
	vekz8IV//vB0+RnQxrtBA9OFEm9l2Q3dGFlrDpWZ9Prt6pSZU7Em/qmDWsON2svSyPQOoOwCfsb
	BS78bKN+//3jn6UhMEjn42T3MpHer11yMuZAdvOcFnH3b61ZRMznK4mSvL7s5tBUckfdLz0ULIk
	b3N+Z3012AM+LtgGNeilyPRQQoMzGO7zygXjLsXEKUmIugtD4UdqeY6QWdTY+7JX0v3TYXieWoT
	KF2gfwEkEz8xFKYW/VMYJuXF1SXx1mBHyvJKbFuGkmIHYad+kwcYa+TWi99n9suePbOQwo182Z
X-Received: by 2002:a05:6214:5503:b0:91b:eb98:d93d with SMTP id
 6a1803df08f44-91c48e7ff3dmr74941036d6.56.1792934752890; Sun, 25 Oct 2026
 06:25:52 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023100859.70744-1-lienze@kylinos.cn>
In-Reply-To: <20261023100859.70744-1-lienze@kylinos.cn>
From: Daniel Pereira <danielmaraboo@gmail.com>
Date: Sun, 25 Oct 2026 10:25:40 -0300
X-Gm-Features: AclHuK93cmTn06Lm2iuX31Sy3W6skF1b-wNhVAcg7WhieI117wU5o8qsb4JVsm4
Message-ID: <CAMAsx6fVx41oHsZfZpFmYe8ErP==0b=oXG=aK3EEes58N4a-0w@mail.gmail.com>
Subject: Re: [PATCH] docs: hugetlbpage.rst: clarify HugePages_Total in hugetlbpage.rst
To: lienze@kylinos.cn
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D0CCD10000E
X-Rspam-User: 
X-Stat-Signature: ofc7obpyoik7h6mwhhget6o5n7dm9qxy
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792934753-709605
X-HE-Meta: U2FsdGVkX19IPi3AMVbHSGWTZwS9GX32Tkp5HyUPvJDbwbBr/I6UqgYuk3rCVC+2vz1nL98WxjZ5vsrMC5axS2Ub/lMvC/xHVYNIeMMXZXf1ChFGvBLdp2WenD7FWi0z5qQGn+/amxn4qt6hCro39QY5soDQLie5b7LHef1JTnVje3H7NHWIqnj1h9M+VVeQX1W460B+BL7q2hFMIQO3jnxtfTWxeb1g/zDEqnLshEX/GOtEmjEt17X5zw/kXX53/eGZ0KHrjcFYudW5bd9HakpdzqhKYYDYnuWu4Z2RYVMsTGKxvygQOIW4+OXI61BoZWJ4v0h7MDAQdjdOHO3oDU/C97qLGP6JULlCeMJ/sdNEfpXaOnLAfO4wBVqbp4TK9BbPK4vcDRvpRGJwhJXT2ISRDis0VC9/AGTIKhqoyJVMHDpXhHotMa9HZR9bU/EZdYleRAY21QZVHJk63Y3ImeBhm43Hbf4tey1d/6qTIHcHVOXjhxMk9rGT6XhN6BqSRoPbdvufuhpL03UZyGvsLXOTOhtd1Lw8KmNPU+KB0YaBg7Cj4gUUK8Av7EKDfne7DRtmmGTsC1gwUPivadZEqop/YXCwErNrJ9PZoSYd1XEh6H2jsndFIMCekbwqvlJvje1AalIt3Uf+qaOrM3Xp/Nd8ImD7PJ02rnsfqA83gKYOqZt4OpdYmIrB4odIVQ1r4jcBkSmg3czdzTyDLA6HggLIhAB+mNgyb2PAlJad7JQsqZyuFhhpTwACZjkX+3Nw3Qwgz/3edy3LL97lT5kcz8mx9a9NLnnlxNHHyy1Y/P9WQX415MBaO2UTZGTAA7E76Q1CYcP4gqJ+6mE9tO/5sQroBXpfn3yM7cIvTJm4qZtiqllB01Etv8yD7hP00jkdeb8ZjMw31BIti4YqYqS0Yak99e2fQZY+kkL7uE4n9Nbpu5uQulXSWpcx6XcjU6bTn77tXKDkWOn9vyQCi8I
 aOIuFSxr
 zzPhxJIc+6fY1POYol3j5ADwkpgAhOS4luOkDBUxyCjJulosm8OnGvh/OjW8Vdnib93qSlFs1ABQzuJHyeDN5t8yRIDX5TTnSZUGjZg3cJi1IA8x0ZOm+kuw5iD38mPkagsgUMRbrFj3B1rIegK7cjPZAWFhgW1qa+2EU+joEyLQPIEVf0RI4ggdFTxKAezeb+qe3IjC/aGPRfu+yf6bGX1VfGpDTnpY8rq3UXwb9ctizeeF3X1OzzkQWMTfsHYObTgzdiyLcwX/oY1aeZvJDntdcOQflp+/A/R1fVuXncC4SJtS9GuDRypFxnLDynnY38h1kSluRVzQOqJRVgUzOvlTyRLUSi12/2lEI/eNeE88WsinbpleL0/JYTBTXdVJ16IXKwcN4hsJuhQ/m+6CxeN07aM/VYWkIF9+eXlX9ZHtXOrPsCi+iXzYHkI8DvP5zTC7d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026, Enze Li wrote:
> HugePages_Total
> - is the size of the pool of huge pages.
> + is the number of persistent huge pages of the default size
> + in the pool. Pools of other huge page sizes are not shown
> + here; see ``/sys/kernel/mm/hugepages`` described below.

Hi Enze,

Thanks for this, the current wording is indeed confusing. I checked the
new text against mm/hugetlb.c and have two comments.

1) "persistent" is not accurate. hugetlb_report_meminfo() prints
h->nr_huge_pages for the default hstate, and that counter includes
the surplus pages: alloc_surplus_hugetlb_folio() accounts the new
folio in nr_huge_pages and bumps surplus_huge_pages in the same lock
cycle (persistent_huge_pages() is defined as the difference). The
HugePages_Surp entry just below already says that surplus pages are
"in the pool above the value in /proc/sys/vm/nr_hugepages". So with
overcommit in use, HugePages_Total can be larger than nr_hugepages,
and describing it as the number of persistent pages would be wrong.

2) "Pools of other huge page sizes are not shown here" is not quite
right either. The Hugetlb: line, a few entries below, accounts for
pages of all sizes (as a total in kB) and already points to
/sys/kernel/mm/hugepages. What is missing is only the per-size
count.

Something like this would fix the confusion and stay accurate:

HugePages_Total
is the number of huge pages of the default size in the pool,
both persistent and surplus. Counts for the other huge page
sizes are available in ``/sys/kernel/mm/hugepages`` (described
below).

I built the admin-guide/mm documentation with your patch applied and it
adds no new warnings, so my comments are only about the wording.

Thanks,
Daniel


Em sex., 23 de out. de 2026 =C3=A0s 07:10, Enze Li <lienze@kylinos.cn> escr=
eveu:
>
> "the size of the pool of huge pages" confused me, since it sounds
> like a size in bytes.  It's actually the number of persistent huge
> pages of the default size, and pools of other sizes aren't shown
> here at all.  Reword it and point to /sys/kernel/mm/hugepages for
> those.
>
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
>  Documentation/admin-guide/mm/hugetlbpage.rst | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation=
/admin-guide/mm/hugetlbpage.rst
> index 2075f1f14a42..01fa9f61c9a9 100644
> --- a/Documentation/admin-guide/mm/hugetlbpage.rst
> +++ b/Documentation/admin-guide/mm/hugetlbpage.rst
> @@ -43,7 +43,9 @@ The output of ``cat /proc/meminfo`` will include lines =
like::
>  where:
>
>  HugePages_Total
> -       is the size of the pool of huge pages.
> +       is the number of persistent huge pages of the default size
> +       in the pool.  Pools of other huge page sizes are not shown
> +       here; see ``/sys/kernel/mm/hugepages`` described below.
>  HugePages_Free
>         is the number of huge pages in the pool that are not yet
>          allocated.
>
> base-commit: 3fdcce698abd9193752ee89fb1a440cdceb1b74a
> --
> 2.56.0
>
>

