Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E32A7606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZCW8LJpF
Received: by kanga.kvack.org (Postfix)
	id AC0086B0583; Tue, 20 Oct 2026 18:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71696B0584; Tue, 20 Oct 2026 18:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9877A6B0585; Tue, 20 Oct 2026 18:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3276B0583
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:57:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F228F401B7
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:57:25 +0000 (UTC)
X-FDA: 85344517650.17.7224B5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0E857180004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:57:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZCW8LJpF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792537044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+zq3/RTDO/8tOWvja+6CZAxKVk9ioosPOWISPdbg2w=;
	b=PkPWuGEUUQEg8uUg/SWyXaBqUK5gM4m4/REI1osltH37KU8qNHY0GeGKVjfN3a0e2rmm9b
	rUwWPawfEUME7MmM3la14VqybOIoSlbeo++6ZsEAevdzJQjnNGOYf86fYHnlgeG6/Ff53+
	tQq95PqB6ZIo1IM/T82nJWoMLSlsGGk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZCW8LJpF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792537044;
	b=E4a7O5uxaFTllkp2b8LQuQzJEijs4Lhrf/iL5vZ65reNU6sqYWDthUtWZzanvuy+omObbc
	+GDvt+U04aq9LnSrYJhbR6a6Aa8vdcBOnf5FRrypyUJES8+G5dfS7/ZKmgCU+NN43GF0S6
	CFUhkYMpxQDerIbEyG40tnqevZJxX5s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6AB0D444F7
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5374A1F000C9
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792537042;
	bh=M+zq3/RTDO/8tOWvja+6CZAxKVk9ioosPOWISPdbg2w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZCW8LJpFiui0+jXEzE13ync5DkaPvr/TrQ/Oc+zv849mcTxeAAb8xBftnO8lLiMGZ
	 GmPk+1tzAoHQnWRdxvrbYUGOjk8DvD1HPyzAHux7ZnQ7Yup9OwF44uYSx8MZUu5VW3
	 /N6rRuXRvC/b6wTVyG/4it0WXaCFc6CEmzRRPiJQnwDx4b6chd5x5iT/hl+9BD6hp8
	 95vjRY7Kxsfgj/prjvJB+HsgQsMNRqzPKbZTpLvnyHwrYXgYcUehuq+9eahVqxveiS
	 tsqwp2iHFKHugoZe9epQuRmsu9EdeqdjZEwEQBdtH6xkwsHM8+U+SHzfC+nugRRCSJ
	 Y9LyEfn4GAOLg==
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91b55859245so2235326d6.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:57:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBznp4H06mtEYn4MwNw4A6N155y+bJknD0C61vIT7+EYe0ESLc32d7goxn9Rld/LHjBujTYyvlK5dw==@kvack.org
X-Gm-Message-State: AFq9FYLY//0wS+D7xnow/rNqESlW7Qhnb1iHDqyCcxwneXzy52C+abPC
	siNXGPPRF7NgIoIifzvddsHXUwdxOsm8at0kcuJsPeUNg7IT8VT/2lJCKrwmHf8hvcwfigVFLkN
	mam+i0QKF0QBxAYmGFsO3Xt7hkR+jaKo=
X-Received: by 2002:a05:620a:1b82:b0:93c:c4da:f46c with SMTP id
 af79cd13be357-93f57f46150mr129759385a.56.1792537041637; Tue, 20 Oct 2026
 15:57:21 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <sashiko-outbox-175822@kernel.org> <20261018064458.86435-1-baohua@kernel.org>
In-Reply-To: <20261018064458.86435-1-baohua@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 21 Oct 2026 06:57:09 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zY5PrYgbFvY96R+52Tftp_eVrMkSbf_-2b3Tw0r6FgBw@mail.gmail.com>
X-Gm-Features: AclHuK8Vh6-rYE5cHcP7BV2gGX_pqiXcWh_s7ZQdO0Z4QWPypCZNnf7iSB_RAHo
Message-ID: <CAGsJ_4zY5PrYgbFvY96R+52Tftp_eVrMkSbf_-2b3Tw0r6FgBw@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix using folio_mark_accessed to replace folio_set_active
To: sashiko-bot@kernel.org
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, ehab.ababneh@intel.com, 
	kasong@tencent.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	qi.zheng@linux.dev, sashiko-reviews@lists.linux.dev, shakeel.butt@linux.dev, 
	weixugc@google.com, yuanchu@google.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0E857180004
X-Stat-Signature: 4zh9zr76qk6mfjmjnzg7tnta7ihdk9d8
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792537043-404949
X-HE-Meta: U2FsdGVkX1+7PjQhOYnoFVriAq9BuRrXlu4mHnZC3dHEbdhn+neIXqewQTpr9EgJxbrcVjzNdv2xMJds2EPSmbejHvSWTWc3MOroVxG52LdReij+XAlw1wZioXh/2UV9wWVhxNULouAT5yj7TyByexHBG+JgcwjLvGwnmIn2st6RzW64nAh9CN4HpHl2ueyIuAZL9ylNcAD5fCIkGf3XqnFICob4D4cR6owQQWoI5a+6YTFfE8CV55mUaBY7i8VguGS1XYRtHrwHn3q648NUrhr6jbHvuOJ5pALuK/ZSoUdSfR706z+YNQ2qP+aVbA+gYBnW6tkCDBz6gfdT1G1qGKsPuHr3JB5YlEwd6ScHRvHIR65B+7Uoj+e1vifurQ1N8MXlnQLMhgPyjbhSmB83Yba+BaC4CmMwX6QqjL0uQxisEA2mZ4eu/8c9rcEoCaWaGy3II4DTIm/4rxvixnvhqR44Hc++iQSCl8MmH3J9v6ffqie3wbSBRNnCtjtwu72rnwxyIPomMiTmlDeOhV1rsMLF4s3WUMI6SUElLAh9L7kQCa7KKgbRNFv3PzUf1XkV5s6sGILlq6EL7Ty3v8aP3RH7DQ7xchwKrRwr7XNrDzCkm4V9d/6gvshR2Ny4891BrHwYw38lRKPwDH2s01oUXBWkjYYcitP4Vkxs4IraEZxNULu+6Yk9oXLFW/6E539oUuH4MX6HlpiHtDVzIuYHdFV2Tv4iPVYa2DwEchiYT5YQxYebvZIvCPEKScsqA1DPHBP+LCMduQ2NnBiR9pPHk00zA44ank+NPImtXGdNyxdSDq1LZdGsaHl4vihWsiH3bUTRPzLVimemJdFBpKHnnquWgFWnFFRwwPB9ZVVUZn5jt2EldGGaIUb2QMtVn9Eq/DVRwtof4NcJYsKzuCraV8Yt4Cv3wavj9VC/T/CXjjWlEZRy1nonKViyhuluoV0IILKtcoLWZdHQiJpyFei
 iUTzeTGS
 Qe2RcV9bdO6RUx3lKDKHEAMCDYp9gME6M/H+1EVPAVIjfAKQnoKN4uRF37rkuw0mjWEtSSsT+2u1uB+dnv3ZljrXqkqL00STl4y13LIBPFJH3svpCf403y8E68POpNLeWw43/jOeerFReZov8AYIXFtclWQQaKuQ4UGs4S+SmMiMKHs+kASXdMGFvkJnw3h8xOflKCnBa//AIYxl3nMFmp60CBtSujNMoyHXNs4eABJafiPp9uDAyKkQsrqJBX0gc1PVIZLc9PRrK79XOV5qo8Ag/hzgDMyYouK47DPEM7CyxyRBB+r4J9efV+7+A9/XX3PEPe8wMCM3U4I6NWqfgWWN4nlchQrCU4gir
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 18, 2026 at 2:45=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
[...]
>
> Thanks. I guess the real problem is that we have no reliable way to
> identify whether a folio comes from in-fault readahead. I've tried
> various combinations of PG_ flags, but none of them works. So the
> only solution seems to be separate LRU-add callbacks for readahead
> file folios and other folios.
>
> I've drafted a version below, but it's pretty ugly and feels like
> using a sledgehammer to crack a nut for a quick fix =E2=80=94 simply not
> worth it. Maybe the best approach is to revert 6cbdd9726fb5 and
> leave the proper fix to Kairui's MGLRU-FG.
>

Before reverting the patch (and regressing workloads such as kernel builds)=
,
I tried the following two options:

1. Remove folio_test_referenced() as PG_referenced might interfere with sys=
call.

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893..e231e56f0257 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -327,7 +327,7 @@ static inline unsigned long
lru_gen_folio_seq(const struct lruvec *lruvec,
                  (folio_test_dirty(folio) || folio_test_writeback(folio)))=
)
                gen =3D MIN_NR_GENS;
        else
-               gen =3D MAX_NR_GENS - (folio_test_workingset(folio) ||
folio_test_referenced(folio));
+               gen =3D MAX_NR_GENS - folio_test_workingset(folio);

        return max(READ_ONCE(lrugen->max_seq) - gen + 1,
READ_ONCE(lrugen->min_seq[type]));
 }

2. changing to > 1 for folio_lru_refs() to reduce the syscall
ra/non-ra interference:

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893..a3a894aae10b 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -327,7 +327,7 @@ static inline unsigned long
lru_gen_folio_seq(const struct lruvec *lruvec,
                  (folio_test_dirty(folio) || folio_test_writeback(folio)))=
)
                gen =3D MIN_NR_GENS;
        else
-               gen =3D MAX_NR_GENS - (folio_test_workingset(folio) ||
folio_test_referenced(folio));
+               gen =3D MAX_NR_GENS - (folio_test_workingset(folio) ||
folio_lru_refs(folio) > 1);

        return max(READ_ONCE(lrugen->max_seq) - gen + 1,
READ_ONCE(lrugen->min_seq[type]));
 }

In both cases, kernel build performance holds up. Reverting the
patch would regress system time from 3m40s to 4m4s.

I believe either option would eliminate or reduce interference
with syscalls that use PG_referenced.

All we need is to give in-fault folios slightly higher
priority through folio_mark_accessed(folio). I now realize
the original patch might have gone a bit too far with
|| folio_test_referenced(folio).

I will wait for Ehab's and Kairui's testing results on these options.

