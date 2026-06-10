Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D64CBCD98C6
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 16:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FB256B0005; Wed, 10 Jun 2026 12:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185816B0088; Wed, 10 Jun 2026 12:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04C696B008C; Wed, 10 Jun 2026 12:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E4A9A6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:27:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 813E9120168
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:27:32 +0000 (UTC)
X-FDA: 84864533544.08.E1B40BD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id E5CA220008
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:27:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i4xagkwq;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781108850;
	b=blQLNiRMDFN10WJ/nNX9kLZTm6OstrNpic7RMeDTeVKodU1R7L3gF+jtQsIxmpZxVFFe0d
	1Gi9qnzIc26PnypbosLTmQeU556+ybAER+jFLeJUHp2kFfBzBL2OURO5kdOrIooMjaV78p
	yt3EczJ9BQPQDgM+WndDziK7664UvrA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i4xagkwq;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781108850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=69ovsGaFESoFtofuBYPpSJ5R+TtHCpzN/Ba3LcguZSY=;
	b=u8aaSSQz2qi4gk+n0vVEj4WvgBZBEHQ4zdOagROWf+LsurX4nh9dykH3g6CljimW3UGfKz
	AaBa/JAHfK0Lwovr3c/+H/YYD4etv3bTuUVyt9R6+d9ndJGHBYNy5p4nzIbQSiuZTby11r
	DirZzfsBRaIVwVchTvS8LLcvOgnxqls=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781108849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=69ovsGaFESoFtofuBYPpSJ5R+TtHCpzN/Ba3LcguZSY=;
	b=i4xagkwqbm+AcaN6INl3cKTpHo5Z/BhuPD/87MjOiRAmqXV1Zws2eDAPfa3Eql0OpTRLgh
	c3QzzO//lIRrHPldJyjfo/jOQny+Acn2etSHOTo/k/dUwk7onZnjmalb5nderA/gPqN9li
	EdWcA+0jQ5wz7gAguHsejvJr4gqvhjc=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-PlishQXsMMWogAhL5HOSdw-1; Wed, 10 Jun 2026 12:27:27 -0400
X-MC-Unique: PlishQXsMMWogAhL5HOSdw-1
X-Mimecast-MFC-AGG-ID: PlishQXsMMWogAhL5HOSdw_1781108847
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-6605859ed2eso9871356d50.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:27:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781108847; x=1781713647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=69ovsGaFESoFtofuBYPpSJ5R+TtHCpzN/Ba3LcguZSY=;
        b=GRzAz0dLkXeKptvOi5VwA+n/pOkwC6rh1lRkO+XbfnZ9WxwxN421yWSQ0BilLeV266
         8IpxCl0DlqvLDfyZcyUhc/vCuExt8zFaC9lahChhPHUfVVuauwwfKKQOSN09RFZFqoBR
         YJTKpnt5AR1anKfY9eqB7nbXXlgJvJqtzgsZgnB2QUhP5ZJm0XN6roLMm9eNowcy1pcu
         xhSFC0s/JzVhq0lQJ1a1lUyEGmAAAM9mKAWdvoyaK6m94swX5FvK6wBoMx2Wxen9YToa
         bSgOibAwohdr5Eioq45G6qyt2rG8CoDidWnfjbrVo2vHdkJg+7rwhBjYgqMQ1MV76zJ6
         KmSA==
X-Forwarded-Encrypted: i=1; AFNElJ9/hq7M1zFs4vDAuUDLc1nZyrwjyCX4I4nSdsrb13+sK7FqgB7qMSDbkDg6E7m1KLQ1XZ3HKGDCzQ==@kvack.org
X-Gm-Message-State: AOJu0YzavKkJ31vJBqJi+EbH62eW6GeI8MzwI4LBQtQK+8L1mg/4/pqI
	fNcHEILzslxbXCSQ4TTMrFU35+zI1h70yhnKqgRpxeQ4PxOog1mNfkPtkcMKbHe5XckZuHRes+N
	dMivRa3xjYRKL06nZF4fKe/6gzM2tNvtccycIOlViLLC5Subw12gAvTn5VBP/nQGKDlxonIKPQM
	07eDtf2YsJu250P+pBp0NY8o3H3v0=
X-Gm-Gg: Acq92OFBvsRGV/7WItxTao02bae08DEmlqN44bsugruuZdbyZpF/E7gQBw1kAWhXdAl
	RjL2VlqrZ9oJkjeleZrIzHjEl4zX7a/c1f3Fzb0Blw9DsP6iKm1P3IkOLvZfngtafdq2hUwtmpI
	hz36M5r+6MSwzOCdBYLtZqysPdsScC0CynOEQ/WJooF1coUG7OSRuV2OWsf3NSk+O7jksNFL2e5
	zFvGBqNIZGonl8=
X-Received: by 2002:a05:690e:d50:b0:65d:8f98:6bb4 with SMTP id 956f58d0204a3-66106e64201mr21406007d50.29.1781108847102;
        Wed, 10 Jun 2026 09:27:27 -0700 (PDT)
X-Received: by 2002:a05:690e:d50:b0:65d:8f98:6bb4 with SMTP id
 956f58d0204a3-66106e64201mr21405961d50.29.1781108846569; Wed, 10 Jun 2026
 09:27:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
From: Nico Pache <npache@redhat.com>
Date: Wed, 10 Jun 2026 10:28:14 -0600
X-Gm-Features: AVVi8CdALWmcahZhXPy-FoKykTlzQjK3gHyZEyMMwkE0KtxNZmEvvR6Rmyhf5Tw
Message-ID: <CAA1CXcARRvYChZbxfLg1oTh7RdKGqJUFg7M_vCK162v0ncKhVQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/11] add shmem mTHP collapse support
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, willy@infradead.org, ziy@nvidia.com, liam@infradead.org, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3RcHWePncyMxyAsiVRJKTTcPT2B_d5QY1Yq7RDka6-k_1781108847
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5CA220008
X-Rspam-User: 
X-Stat-Signature: m5uiuork8irr9bp7eq63ink19syowgs4
X-HE-Tag: 1781108849-173832
X-HE-Meta: U2FsdGVkX1/0k8c/3raPlqsKKDc725wEyruEYOM0IdaFEMp92Ncpv/eY5sal4PPa0kLfPd805PhFl7EAuwjt3SCyHqc7BixE8TSweR1hrsXp1q3YDsqGML3s9k9ZGrM7jZPc7kuQSbsJdFVia338nZ0etQhMyzn6uDlK/kdtBp47NfB9arTmhp3aplqw9ZRnuJVkvJyB+78RLaFjjaPm4m9KOduY8dmgWbbFBRYkVUAAYzonbY0ZIh3/UKMgeRvNle4WtSRIHjYiqiY/UotWStlLPaS9wDDgh/LJ1s3ZaN/Cv+0+lHVhIXL7vjdVWI2CyEfYHvCKSHgZ1oC6YtLyFLa36OTqMTzOjckIMJikPjWsyo3ktcwlW7pXA6GdASlrWXj8nk+fbuTwrZdo7zHDdTORMTS0qTACyMmoEqf71LxYfEQFmOAGGS/aWQ1h4ZSqavpOvnSx1cz/s915WfX3/nsAigxfqNg7fEU063bVCdkWdosnhO/eMieW4YeDhyxqB2q5mgMz4zjC8+QAVyTywMTktC+WL+ToxXAGDVdscQK7Z/tO5Vha2RUl5lUeSQaqBaIV6yro3SLKGYKwFVSKr98gbW57+tfpszgqTAJR+awMuh4CWr6mrdyTVxgSYH141yBA+Dk8mPP7qQgcSlHKcnL2F48rqMpEeStI+Ve7AVhdXOyDQKpRMkFCJSgcAnoL/c0tPPPJcTz62ZTWwxlDxLXXecZQiFCNGfUmfkYWgXLGfRysRjj0WDhvc2BMSubiwArjQqPKrmWziQOG3wU+yyfc3kZRtqs49TzYjGL+Y9vwD6oauBjrcV7lc2+OXMm9rQMs4l3AgvI20/+XL2+DP+ArtjbOQYb//YXG2hhjlZW7hlM4Mo2t8q36ni7loZHXRSkXpcBLbISwwxSSNXB0rcGEuLzqU4hke0yoh0ATYB0djaVLrAdsoFiM/Kf1SRYpTQikyhNO5XAcNEhd/y1
 7jd9wO2u
 R8e5g2y3OwCYX9XDXzvp8xa1bWBMatPGxY4NUMlRtWHgBy70bs4qCcoN0r8lqXMVK4YPwYFl7BX6vcbFmpwbzJS+LrfGJC9DPVDyx08nrwRFneQsupqG2aDa3HrDVIJaZ+sGbSGiRf3/5SvrV3lHIBgdRCXElCvJ5nvS2ZHuIh7oRCyXJMQmnhg3pO/ougouU3JiQnKgP70EDqRC8skXi8naePAoiBeMTCTou/lPg9WmFzcoVUrfKEnCc9U7eTaYQJTExCzlpkIVGikOryXs8ifN/bOYTUx1UR7UoTVN/hjeaRcA3HBHsnk8XAznOGF31pMDj8qv8r9ndAtSn9T4pebxso9TTnOkDVWcBKcangmEh4I/+csyavHWcSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 4:29=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> (Note: this patchset is not targeting v7.2, but posted for early feedback=
.)
>
> This is a follow-up patchset for mTHP collapse to support shmem mTHP coll=
apse,
> which is based on Nico's patchset[1].
>
> The shmem mTHP collapse strategy follows the anonymous mTHP collapse appr=
oach:
> track present pages via a bitmap while scanning PMD ranges for collapse c=
andidates,
> then use the bitmap after the scan completes to determine the most effici=
ent
> mTHP order to collapse to. Built on the basic framework added for anonymo=
us
> mTHP collapse, the shmem mTHP collapse implementation is straightforward
> (Thanks for Nico's work).

As promised I will review this series :)

>
> In addition, I have added some anon/shmem mTHP collapse selftests, and no=
w all
> khugepaged test cases can pass.

Thank you for doing that!!

I was just working on adding the anon mTHP selftests. Any chance we
can separate out those bits and just send a series for adding anon
mTHP selftests without the file-related changes? Then your series adds
the bits you need here for shmem collapse? Thank you for doing all the
heavy lifting there to generalize those functions :)

Cheers,
-- Nico

>
> Note: I have not yet enabled large order collapse for file folios (file f=
olios
> currently only support PMD-sized large folio collapse). Although file lar=
ge order
> collapse would be more straightforward to implement after shmem mTHP coll=
apse
> support is added (requiring some changes to file_thp_enabled()), I think =
this
> still need some discussion on whether it is necessary to support other la=
rge
> orders collapse for file folios.
>
> Comments are welcome. Thanks.
>
> Changes from RFC v1:
> https://lore.kernel.org/all/cover.1755677674.git.baolin.wang@linux.alibab=
a.com/
>  - Rebase on the new code, and update to use the new functions.
>  - Add more test cases.
>
> [1] https://lore.kernel.org/all/20260605161422.213817-1-npache@redhat.com=
/
>
> Baolin Wang (11):
>   mm: khugepaged: add max_ptes_none check in collapse_file()
>   mm: khugepaged: generalize collapse_file() for shmem mTHP support
>   mm: khugepaged: add an order check for PMD-sized THP statistics
>   mm: khugepaged: add shmem mTHP collapse support
>   mm: shmem: run khugepaged for all shmem mTHP orders
>   mm: khugepaged: allow khugepaged to check all shmem mTHP-sized orders
>   mm: khugepaged: skip large folios that don't need to be collapsed
>   selftests: mm: extend the check_huge() to support mTHP check
>   selftests: mm: move gather_after_split_folio_orders() into vm_util.c
>     file
>   selftests: mm: implement the mTHP-sized hugepage check helpers
>   selftests: mm: add mTHP collapse test cases
>
>  include/linux/shmem_fs.h                      |   4 +-
>  mm/khugepaged.c                               | 174 ++++++++++++----
>  mm/shmem.c                                    |  10 +-
>  .../selftests/mm/folio_split_race_test.c      |   2 +-
>  tools/testing/selftests/mm/khugepaged.c       | 195 +++++++++++++-----
>  .../testing/selftests/mm/prctl_thp_disable.c  |   2 +-
>  tools/testing/selftests/mm/run_vmtests.sh     |   4 +
>  tools/testing/selftests/mm/soft-dirty.c       |   2 +-
>  .../selftests/mm/split_huge_page_test.c       | 139 +------------
>  tools/testing/selftests/mm/uffd-common.c      |   4 +-
>  tools/testing/selftests/mm/vm_util.c          | 184 ++++++++++++++++-
>  tools/testing/selftests/mm/vm_util.h          |   8 +-
>  12 files changed, 492 insertions(+), 236 deletions(-)
>
> --
> 2.47.3
>


