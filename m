Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0AD6C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 08:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4C26B0088; Mon, 14 Sep 2026 04:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99CE6B008C; Mon, 14 Sep 2026 04:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8A2B6B0092; Mon, 14 Sep 2026 04:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7528E6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:51:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE9AE1608AD
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:51:52 +0000 (UTC)
X-FDA: 85211750064.17.D52885D
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf11.hostedemail.com (Postfix) with ESMTP id F340440007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:51:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X1OhZK1U;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789375911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3UMbxOgugSG7IAZrpMa2G2BPgwFHN+IgrIbQKA7Da4=;
	b=eoG43m3g4Aql4Wk+AM5KFHl0DC6JhpDEdvzo1At8H8v9txwW/+wIGgCwGXOg99YLSOnXfM
	0cA3hjtUaXekx5nR3lrRfanIJWAfYQrCp8gyB5WOqcAH3W+MLJeN2ZNR1b6s0kL/ZRfpML
	yPVfIdnhlISUwTWWnO9/v1m2IMSefvM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789375911;
	b=aGqv9+87ZRllj/qnQl4wnz6o//450WNLWgb5d3C2/n6V1Bc0hap7hzpNqli0oXnv2ZO8yx
	8o3tmg190lWTxSuLKr+8d6LYhugMpEx9n8J1ypvEmKB9f2u/puZRqcMD0iuY6WdjayMfMT
	mZ4hUk0ZvzPLqPTx4ctBz8mTirBGx5M=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X1OhZK1U;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29703cb796so287259566b.2
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:51:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789375909; cv=none;
        d=google.com; s=arc-20260327;
        b=jeL5RoaYcIehyfwIY+3ELmYF+JL4G3wgBlxDmnFjWeBbkfL39VXe5pSjrnMZxuPlkY
         9sZhozFH36hHE1GRyGGXwy77g22cVvRPFPsUxZ0nRjsn+41vhk2i1AJgXU9CSqcqsKAC
         Jjrs6q8hEHm7tZXybgKWU65+lb3viOLdQQQuj4/9KfeKY7D/dkCExK8f0M1jCmj/yz0S
         XNDqQdH38CvFg9SlPOYS5v3hcUpl9coQlUPOTeakh8tTMrb1NUfzs7L6bijvlHQQFmVD
         iqDM+3IjLT5g+ERrHBKtdKsT+mZBqYpCQD8dAoBOzp4MDdcg3w2fnOGKgAZNvcPSZUgL
         HA5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R3UMbxOgugSG7IAZrpMa2G2BPgwFHN+IgrIbQKA7Da4=;
        fh=WHZCmK1nen2JZEkJtz93gJp0SYr017Nf/ygS8qZ09xA=;
        b=LdaHkr+EDy7u1nX/EWAdMnr8R6mcLdzcp2C8lCQ58dkMquEnVeNE+MpN5QbyMIIyE9
         T6RgEKRTepTmL23hLRdz+Hxv5IWNEoFMcXEFIN8IIEjvAkV4v/dR6iS1pl++4eWi8nFl
         9t8FhcNTs7Mcrj5cnqMVyHwwbwF2VrXBNSqZUpB8+aQ+qA24vj00tpxXiLy/BALlAd2V
         kaltQFUdcXiCkxym+I3HW7Aviumfcan1YpS1g47J2c+Q6dzLLhWUXUrPKECSDsV+HKZI
         fOJJc76RfAv/8m7oIQVeTXZypRUnKjxD/BeOu9zIa8KtF5Lw5lfZmGIhC7zytjgY4xtF
         z03Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789375909; x=1789980709; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R3UMbxOgugSG7IAZrpMa2G2BPgwFHN+IgrIbQKA7Da4=;
        b=X1OhZK1UGo5hauQVeQFeDXiXePBPdHmc3uiM+9dhzPftXnfoXLJZlEAXZYMX4iYWU7
         ZTu+6CvvpoA+A+TctdtzqrO7rk1a3x8+ZxvC9Un20hloK3Gztg/3c3ZNbQU30U26PmrL
         eFYU0/PAI7QoTHTO7QOKIoDvuGY8pN8WuIeT6EqC+ceATzlXDK/d19J+33BSk35Yukju
         Cq/XPstCDfEx3jujvQ0xqXX1UnUMMvp+Lhr51AL3SGgf8T0T4nZfEOByNSV/jNn8XK9b
         n8MV65Sz6xWV4dRU2xFU0BgcQMYsBw4l3CfQwOR+AM9kLj73FxZ+9WoVwe3bynDaMEsZ
         m08g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789375909; x=1789980709;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R3UMbxOgugSG7IAZrpMa2G2BPgwFHN+IgrIbQKA7Da4=;
        b=pO5PC+4bGr4TcrmZ2VBKHWKppCLgizVbnyz3kh1sSET/ZE4dRK8C6DrHDTkcUBGMZL
         1+7/3vKPWTmVgjrstLqZY3dFYetFF3iYsij1+noZVfHa24nqCDpPq2wxVV15fKlkRWPr
         x/EjNd7Tys3H8Wh4yDm2zxQ/16h6x2UzC1uh40SZMuTWfavKEt9DMniacGkDgxEvCaVZ
         JyuuZJ3jMK3wP3Mv7hD9pAeqOsDKmC0CqkMBTS2FhV0nLci+Osq1db5HKHGJFUnII3hC
         HtLgj/0n/9j7zu+N6eATEIL/Ftayb9DW3NIAHOZCNtqp56/xWyNqk8yP2dpAljY25rmG
         nC5A==
X-Forwarded-Encrypted: i=1; AKwUvBw12xEQmQ7mKB0Z7qXtHRyCVABqmi+Hf2FaDn339M+xr2lOeSmITfE2CuOSVEc26IfeY/rZK4sLDA==@kvack.org
X-Gm-Message-State: AFuF++m9fTgd6R6oWuik6SNtMmxAmzbv+uTmXitGB3nuRrGY3tMRPs9f
	ETUytYzdKwpj1z5EXEtc5ReP9GqZtxHvu5e2XGOXErjRWdqc0iAFVDpqB35lnZe0dfJCk8NYWFA
	QAqOIMmsTfBHYJzM2+isKmtqceWf8RWk=
X-Gm-Gg: AYBFou3wSZlN+eZkVCCOhPI0Ljur9efMs0MKX6W9pLPAXk+vHVLYAtS635eGf3+yLJD
	UeqbJXM5Q1qWprK5ei1FZdie1xu+Y6NWCxXdOSAyGn5rbvLfx592/Ln33UILEa1iyOp05PlqSjE
	Rxi5zBHh2PaUaK5EHEPiRvLgfWBNIuuRc77LUxNk5cB4Sk3f/wtOFdhQjGhSa37ylp9mNv1HZ8V
	krsoM1tdy0koH9IKd/18vu3NOCyuniCYQcYX3NDpVTCBWhXCLLbZz3I3few4Uw/AcCn8sYpMwyN
	rbmtK3na+bYmqEORiy/ran6uYqgrRc6kCxPWkonqG1KnaiPqh2H64pQJWhUUA7TwBEouahZQbLH
	+G/B6rJ+o1FygiA==
X-Received: by 2002:a17:907:6d21:b0:c29:72c7:c3bc with SMTP id
 a640c23a62f3a-c29b85faa47mr101080866b.9.1789375909393; Mon, 14 Sep 2026
 01:51:49 -0700 (PDT)
MIME-Version: 1.0
References: <9214e36bf738fcfba86acc8cea85dff4010f66b0.1788918714.git.baolin.wang@linux.alibaba.com>
 <CAMgjq7DdF_fi_MserE_P_AbKR23mrqPLZ-VD71eXH6iv1ncdzQ@mail.gmail.com> <b5263014-23b7-4e8c-9bd9-18198409d0f1@linux.alibaba.com>
In-Reply-To: <b5263014-23b7-4e8c-9bd9-18198409d0f1@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 14 Sep 2026 16:51:12 +0800
X-Gm-Features: AcwNN1VGoSxCGWU9eqz04k5vB_v9B_dE8liPLln5Jh58sMbJiJU5sjqfRhynzKQ
Message-ID: <CAMgjq7CcPfOnAjh1EVRu8-YtCaWjCfx=07Q4RLxF1yV-bj2NPg@mail.gmail.com>
Subject: Re: [PATCH mm-new v2] mm: mglru: clear the reference counter for
 rejected folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org, 
	ljs@kernel.org, ridong.chen@linux.dev, baoquan.he@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qioydpipk3b8r3ahcbxm34gqcdn93npd
X-Rspam-User: 
X-Rspamd-Queue-Id: F340440007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789375910-764547
X-HE-Meta: U2FsdGVkX19oVYcdjyuLbkLpTz99fWaSsdhhR/L5uyuchalL03x7J7C3OmSPhzU2IOLM19Es/zkhhM9nA24/hO2WB0wtclj/gICLYo9X4WR8hZ17ioX2yiWskfC4IdNxVMP1P5tnarmWAvDZm5w8K1824hpzzQxyFQlI3BLEPy9TFdn+MZoQnlPgtFUFP8+1yfnnGGSPQoKBM+HtnEwS5n+SVkCT0g11Ds8NK5jd1ne7Z2sIVrpqPTWySLQa08VyCFzHGx5rAQ7/pxYI5ij3i9EcKPIjD+4AqTLpJoJ++RAGv2/inqhj2ieox/zXXNj1nsO+VAhScpUB8rtK5A4x/+jL7xh6sbKv1HHXdx8uLYezq18N/g1fnm8kvxcKCkfnISFy9uglFkLhY+kJq5t5B3mZ7G5Nv4mmeibk8C4RC7Y5ejxWfHpmjJ17bV3BtCghpc1Em8+7MHurMq0ogT4A4vIoD0oWpYBk+Tkw8nzM865JQl04QS+Fz18mltAB87GdkzTaxlNfACt5zFAmYziK8+hwMZIs5OFcnyE+RTnCN5j0/rBd7UScLcaePOnraLiA3KoDTyFKOk2Ziy6PfWHQIZTv3nnn6/03G8uorw50knEG+H/3EmyVqNMDgCDd3I3YyYooIGr/vhXbfEL4xgzjlIx7G+n4GNHUOlK11BZHNe5zfW9BdTcTuYToCQg0hqJ5UrQIxdYFuZHvq2Lenum5+5D6Qg2zHTKWZqoWoW/sOK4xFkuz88L2Ib7M/4YbEZfIeSufIcLnBllw9EyIgW9B9oBMRzh6G05RVqRAa81X3n+KjoD6TilXmBF1ofCD+YmEfSqRS1bFF6giPDMywUKvNGlx0RSPvr7sAbrpvLdueDOBs+RcifaemTjUkqjnlt7awOnekAs6c0uD+ifkoidIX+950MQK7CGfdIBnqUfgzOnmb9dugo73r0xdOcjDO1/ns6SVpFOCDz74Vcka0ng
 K9qNGD8o
 XNeJRy0EPrZMfgUnVPSap09j00uC2RaPjFX4TXUzUVfIPYk9TEkH29rOcFFt2ErdRLjXpM8IMTVnXgeYc00B+exWuC+8DBjBY+1gcUaej1MSUvhIVsJaU3B++jnVkJyZwJAhChQdqexMcjcRLi2mBHnJjD8pP1qsNq8jX8ZKcTRbO7JT4sZwqbk3nmCpSJ3Hphy8VHdIgmKdh7eOUM4/P9GpYeEq3BBRgW9gJCCvSNu7kXwsUwUAgs/Lwfrr4m0ZKRW2kK07rUCjKTQdEn7PI1F1hs8L+/yUvWOou8VqsSmbmBEWfTt/aLQD6Vt4jJyZh6zjs83ruxP3ymJEIl/aYmnhzlvwRY5+E8eheZnz0lTBvStcWckVNnJez6jdTcrAJtVBfn5m4vAfAQhHvj1Eg9IhJnnR8dqLlm2OLykl2EeNXJi46bQMuoJe75gq+D7UOtZnz+kzhbSK2hwc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 4:24=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 9/14/26 4:09 PM, Kairui Song wrote:
> > On Wed, Sep 9, 2026 at 9:57=E2=80=AFAM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> >>
> >> As per the comment on LRU_REFS_FLAGS, when accessed folios are promote=
d to
> >> a new generation, LRU_REFS_FLAGS should be cleared so that the referen=
ce
> >> counter can start over.
> >>
> >> For folios rejected by shrink_folio_list(), we clear LRU_REFS_FLAGS an=
d
> >> set the PG_active flag when lru_gen_folio_seq() would place them in th=
e
> >> oldest generation. That's fine.
> >>
> >> But for rejected folios where lru_gen_folio_seq() returns a generation
> >> other than the oldest one (which can be treated as a promotion), we do
> >> not clear LRU_REFS_FLAGS. This can violate the promotion mechanism. An=
d
> >> this means the rejected folio enters the new generation with stale, in=
flated
> >> tier bits, which can inflate reference counts and distort eviction
> >> statistics for these rejected folios.
> >>
> >> Fix this by clearing LRU_REFS_FLAGS for rejected folios. Of course, I =
need
> >> to evaluate the impact of the changes, which mainly falls into 3 cases=
:
> >> 1. When lru_gen_folio_seq() returns the oldest generation for rejected=
 folios,
> >> there are no logic changes, and they will be put back into the 2nd you=
ngest
> >> generation.
> >> 2. For rejected folios with PG_active set by shrink_folio_list(), we o=
nly
> >> clear the LRU_REFS_FLAGS and do not change the generation.
> >> 3. For rejected folios with PG_referenced set, the original code would=
 put
> >> them back into the 2nd oldest generation. After this patch, we will pu=
t them
> >> back into the 2nd youngest generation.
> >>
> >> I think case 3 is also reasonable, before commmit 6cbdd9726fb5 ("mm/mg=
lru:
> >> use folio_mark_accessed to replace folio_set_active"), a rejected refe=
renced
> >> folio was also put back to the 2nd youngest gen. Meanwhile, I didn't s=
ee
> >> any noticeable performance impact on my 32-core Arm machine when runni=
ng
> >> 'make -j32' to build the kernel inside a 3G-limited memcg with either =
zram
> >> or NVMe swap.
> >>
> >> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >> ---
> >> Changes from v1:
> >>   - Update the commit message.
> >>   - Clear LRU_REFS_FLAGS earlier.
> >> ---
> >>   mm/vmscan.c | 7 ++++---
> >>   1 file changed, 4 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> index 40d3f1b48a74..1557679aadb1 100644
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -5020,11 +5020,12 @@ static int evict_folios(unsigned long nr_to_sc=
an, struct lruvec *lruvec,
> >>                          continue;
> >>                  }
> >>
> >> +               /* See the comments on LRU_REFS_FLAGS */
> >> +               folio_set_lru_refs(folio, 0);
> >> +
> >
> > Will it be better to mention that we never add the folio to the oldest
> > gen (since `folio_set_active` below prevents that) so this is
> > effectively promotes the folio by at least one generation? Maybe can
> > be combined with the comment below.
>
> OK. How about the following comments?
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c2eb8fa9d5e5..a1ead7c61054 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5071,10 +5071,13 @@ static int evict_folios(unsigned long
> nr_to_scan, struct lruvec *lruvec,
>                          continue;
>                  }
>
> -               /* See the comments on LRU_REFS_FLAGS */
> +               /*
> +                * See the comments on LRU_REFS_FLAGS.
> +                *
> +                * The rejected folios are never added to the oldest
> generation,
> +                * so this effectively promotes them by at least one
> generation.
> +                */

It looks good to me, thanks!

