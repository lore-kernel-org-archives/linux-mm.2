Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C467606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 20:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H5o3lkKZ
Received: by kanga.kvack.org (Postfix)
	id 0F8216B055D; Tue, 20 Oct 2026 16:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA7D6B055E; Tue, 20 Oct 2026 16:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDA956B055F; Tue, 20 Oct 2026 16:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B899A6B055D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:47:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47535A76C0
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:47:38 +0000 (UTC)
X-FDA: 85344190596.16.79847D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 603501A000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:47:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H5o3lkKZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792529256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQwGSvzYOohT9kUoKDV9cqE99QB5OZ5zFZdvCKpT658=;
	b=YlJEqcUF6Xy3IAHxlNc8i7aH7YG1l5k54MIb3gxwi4IhauZiyQAP0WV/gTfhzZ17BVXSMc
	J2aBs0SiuRUZ9ia/r/lGryNfCflscA33uOy4YvUg2fsUFrk0svlpWPeUy7EdMc4F5y8fKI
	48JYCiYgshtFL4rmuDoTRw3SSqgqRkY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H5o3lkKZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792529256;
	b=UVDySy/sg6P1FUGDrTBNDZ7/YJT4mr4OWYITbAQtoZBDL6BjP0LeuSH6hOaflv/zVG7TjG
	nx0keQ6J8oJapky6+uMjg2nY+fAvwa5yeq6pZ1f9YlBa62bW+he92YLPVsDk5JMRzGBkVb
	yqibf/FgBBee7czTa5ZrqFS+pb8kY74=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DEC844812
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F841F000D3
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792529255;
	bh=xQwGSvzYOohT9kUoKDV9cqE99QB5OZ5zFZdvCKpT658=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=H5o3lkKZtcjIhxg1Jgv4YSB4NydIvtuc83psyEK5vHeRwE5AllHqOE+kagT49yEZe
	 zwV71Bqz3Fbr0bOUAQrGu+BejHU33ufiDBEFwR7lEyUo+r+6IlnvxT6EHL5YegDHsP
	 W6Xl4C2XARRVmAJ8dlVmPzEL5+kTLphtPUPtxZrVrGcSEEuvZh5EVGcRSQ0kZkWTTE
	 tAbvtvgmiHXSwfGCFrH2dV9vL+iwUIGZcatOfzrqr5sJHdvW1pnewqB0paRiHoU0eT
	 KEycgEnnFkMimB8kxFQrVRjdJfGFpDVHp+YfD2lb/9y+m2K62825e2pUfFr/sRu60/
	 RATdnq8u2bQYw==
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5361e313e63so890061cf.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:47:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByv2OypH3ETPeJl4QRt9nkNSDsbTjl1SOizz7ADOj1iDhmqX6MXpbP396755vOJFZcDqYmrh4vtpg==@kvack.org
X-Gm-Message-State: AFq9FYKVyoLr22zmQHfZYSKkD9J9Nxu1MTLrEgbmAMXxs2/BTwxf8z2I
	BPjDY6xb2BLeOpdwLSfuDwbMuXS0pbh+28vNwWj81zua0Ny7O83faA3BaErpufx9yDgal63wULE
	+PJ8tnzkT0zTYgZQWImax2Brye8SynZ8=
X-Received: by 2002:a05:620a:171e:b0:93e:c12c:9dd2 with SMTP id
 af79cd13be357-93f57f7a370mr81878885a.82.1792529254015; Tue, 20 Oct 2026
 13:47:34 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016084256.12955-1-baohua@kernel.org> <CAMgjq7AtuK22FsuqvGRLVZ2eWrp-N4qQ_MHoXsXDkVBprekdDA@mail.gmail.com>
In-Reply-To: <CAMgjq7AtuK22FsuqvGRLVZ2eWrp-N4qQ_MHoXsXDkVBprekdDA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 21 Oct 2026 04:47:21 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yfX-__y0f5_od7r+j=Hqz2YAGzFDRyVP4s-6t8dh0_rA@mail.gmail.com>
X-Gm-Features: AclHuK_6OQJo2WkKc2jeoR4HdJ1oLezMrDS6BoCD9oiiIL1tyFrKMHixg8usnik
Message-ID: <CAGsJ_4yfX-__y0f5_od7r+j=Hqz2YAGzFDRyVP4s-6t8dh0_rA@mail.gmail.com>
Subject: Re: [PATCH v4 00/17] mm/mglru: frequency guided promotion (MGLRU-FG)
 and flag cleanup
To: Kairui Song <ryncsn@gmail.com>
Cc: devnull+kasong.tencent.com@kernel.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, 
	cgroups@vger.kernel.org, chenridong@xiaomi.com, chrisl@kernel.org, 
	damon@lists.linux.dev, david@kernel.org, dev.jain@arm.com, 
	ehab.ababneh@intel.com, gourry@gourry.net, hannes@cmpxchg.org, 
	hughd@google.com, kunwu.chan@gmail.com, lance.yang@linux.dev, 
	liam@infradead.org, lianux.mm@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liuxiang.277@bytedance.com, ljs@kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, nico.pache@linux.dev, 
	nphamcs@gmail.com, qi.zheng@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryan.roberts@arm.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, sj@kernel.org, surenb@google.com, 
	tz2294@columbia.edu, usama.arif@linux.dev, vbabka@kernel.org, 
	vernon2gm@gmail.com, wangzicheng@honor.com, weixugc@google.com, 
	willy@infradead.org, ying.huang@linux.alibaba.com, youngjun.park@lge.com, 
	yuanchu@google.com, yuzhao@google.com, zhaozhengzhuo@uniontech.com, 
	ziy@nvidia.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 603501A000B
X-Rspam-User: 
X-Stat-Signature: p8p5ou6iak1mxsxjdwtq1h3qx7a66b98
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792529256-13167
X-HE-Meta: U2FsdGVkX1+cqiimdMVfi8J+U9clHyeWSJTj5NLiaSXKkcRBeZkldNqqmGDrhVmJEudeFgIJx18rX0c0u31WBQetxGjN4Oggn1Dg4v6yRHvp3jpYz/nWw7oUJhqlmK8JrQ7ZUomCnV3xKkcTNRTRBHJ6ZsdLb9lpc+dJSRJUAxdcvEGXTO2hBm3WQjkNi1a6DOe7eJcqUAY+zNvz4QZRGuUGES4CFUB5AcHoj70cZXtVSuw2Qdm2yrhb1nzn9Xcs75DtH5mmPJWiaKEU0ugT/swiBWgqsg6toCF/g14SxELNNSmLWAZeAx5/oqSMoYq/mpdcbfs9bUyV9TpgUFRg9HAClL0ZYRYZ2Lg9vvvAMyZ8hlOuv4sCHKCTHvPHbydF6srZZ3w/05XS/ty05bl/Gj1IsXuMg2a0R2AKsL0av/2rlUIDcqja5z78z1z3LZ4UGQfuWt0Mek6avOuSXUBEy5cYswvLdi57FclKrkeGJInDyEt78rcnOmjjGwSoD9Ae6BI84dKB33ODnjAjvBfOd6UwirWotwK5q9A/yTmvcLyjlb0L5yBhk8Nn9x/RFv9R/MIQ/1vAKbkSDQNmkQLSMg2pQsIMjpy316vdcAYSPjB/otiMajTt3aEqhvB9zDPnu2JbEX0/MrmTotBhQLILhYcQ6Kab9IhxYUR+CWmOovMKxqUSfV99NNVjZYiqGJTGPZy1hrd+CPxquqg0GA0Af41mQZlP+s0A9wfbdVzizG4kaBoKh7fJXNcoIfCBu48sKgAIop1RfDOZaXOgoFLGnIuD7DNuddimTXNtL5BHzna3tURko2hi+iGr70hW0V4MA+yXDuG4uLF6sNQDQa3/j7hJHAFJY+XWxwUZnE3cM1Pop7SH612VgbTdHDUK1UxwbbKlzvOtJmAGkY6wrXC+sUgEbFZLYau2Q3/1Z6UtAKodokrQGgvNg/aaQATXszHj6aPxN8g+ZrAnJsKhFaW
 RPgJZp6X
 Br7kCvZbRrMEqLCh16zprl/6OM+q7eQe0mLMvINfJ+aRXzuPYXBG4pJ6uF4ZkWgEtzcqRcU2V5hlqe/DVRBOLhy5/vLtROPTw/gGd3Fv4+B0gj1eVDXCXgVlauk/ybPCooJO+ORG0gcbhVWHha6odwle1JmFpRcnjiOOK17tOW/bToh6wkfOAItB3Bq3eq71s3anA5+QoyHXRR/u2/wuglfEZyVN0zQIo+0UthyGa5gopE+MsHZ3uuyL5kY7u6OqizJUQJ0NGTZgFDP6qVIZjEVYhqh93ZZ9SNfWQuqujzmj8HEMRxJ4Q7VvcGOjf83p0xiTKvPIJaTPLAna/Csq1PG/UbwI5grCENlMow0FtjW//awIwZI4DSkm6JK+GXmEi7dVXD2fgG15nLmu1IYmMWz+NASCKjBC9pljNhwdbv1KilkJh7FMh4kHSU3oCPF4n1cHHelpdgbIFP4g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 7:44=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Oct 16, 2026 at 4:43=E2=80=AFPM Barry Song (Xiaomi) <baohua@kerne=
l.org> wrote:
> >
> > On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay <devnu=
ll+kasong.tencent.com@kernel.org> wrote:
> > [...]
> This is a nice change, but meanwhile the LevelDB and cerain workload
> gain are gone too, we will again have a ~40% regression for similiar
> workloads, I just double checked it. But that's fine, though, it was
> never meant to be optimized that way, and the long-term fix can be
> done later.
>
> A quick test on another of my test machine using Tal's LevelDB test case:
>
> CLRU: 3098 ops/s
> MGLRU mainline: 3035 ops/s
> MGLRU-FG: 3233 ops/s
> MGLRU with this patch: 2194 ops/sec (should be same result with
> reverting 6cbdd9726fb5)

Sashiko is raising serious concerns about this approach, so I'm
really considering reverting the commit. The downside is that
the revert would also regress some workloads, such as kernel
builds and LevelDB Scan/Get.

Before we have to revert it, I'm wondering if the one-line
change below could fix the SQLite scan and lookup regressions:

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

If it works, It should be entirely thanks to the inspiration from your MGLR=
U-FG.

