Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B55C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 17:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8EE6B0088; Sat,  5 Sep 2026 13:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9816B008A; Sat,  5 Sep 2026 13:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099076B008C; Sat,  5 Sep 2026 13:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6D0C6B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 13:32:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45DC1A462B
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 17:32:03 +0000 (UTC)
X-FDA: 85180401726.01.1083960
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 72A73C0007
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 17:32:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T9zK2nrN;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788629521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOW8XuwLJiAY2FOtXpU6W0erUZewcmKtXhsLrPUNiVE=;
	b=pti2l+DpFg6nLvxSggKia2P3UDzgL+1uOIVH79PXT+k3o3GBY4QAsRoVszXGjI4mHXJzJE
	wrjfB+priohPW8TIjZARPWPcJgpG8X+bMwgbU2NRzJYWsk85hgozVTNgxWEzikcNc/5xG2
	RbcI4GlR/qHBgYCudQdql463OPt8Fh8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788629521;
	b=gI4tO80YJ+8lhltRCy6VaUVl6/IYviDeAL3a5930qH1I3u1KUwi38X/xyYfKtVjOcgyxrM
	9Zw4b6/aY9bOACzwtPAlDCBSEeK4lsPmbPzEiBXSeNcJ5rKNs0GEveUJ+0BfQCH89KBO5V
	We9NH0SVYw48knqQzuUI2z8hYITz2JY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T9zK2nrN;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c263415982eso46123266b.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 10:32:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788629520; cv=none;
        d=google.com; s=arc-20260327;
        b=lkcRq2XOtOJ+62WtzzlSO0zliADyXH6tkxyslSqawORDdf0TmwnhwM1Lqe8/LTUuHp
         qlalT4fdQ702/RsmLxpCWpOsHRnWsJmczfWrsW55BTXuLb+EpbZUi73z7bWPAeT/JVQt
         dyuB5NWT54KEECulErJ8AT2lOkYrFIrkv0mgN9qrpZuOod+zgFq9vRMHUduVj9IROhe0
         BIAGjLz3/Ax4mAQQ3e8oiSSaTr3Q1myd6o8Azy7CjSL5hUmyAQGBIrwFCqlQlkop5GmO
         kzZIB3KykX92gN+vC23zQoh0tYPHqGvnYdfOh1K3j3diCPt2zk0KLNIkXNz9SmVjInd9
         o+pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JOW8XuwLJiAY2FOtXpU6W0erUZewcmKtXhsLrPUNiVE=;
        fh=PKxWCYZuATGR6xHmyaA7uIrirEwASCIRHd9dBs/MHkA=;
        b=k5JT/ewSV8O4BBJlNchEKsf0zeF9G1KolMN3wKddFIC1mVJsLepDXyYtHmQpA8WRnw
         p9bovH2C8PLH/EC1ZfzpXy1YEgwhV6/nHzlamqzbdaaPL3/HxCxeXcgtOKsTDZSwIEtn
         jVyhMmpEN4pAsLeOLZcf+TNbncCzgEHJWlg7x/FvfFfTKLUwuUtC2zVxfwsCIo0DH1Xy
         SSMd1PPsKVtytju/RUpxkYHm6e5LccDAYUQVrwSbmb01tJ7kOQT6KhUrXUG+IBlvuEhv
         JxDx0VJ/oudSuPwUgWGjRTJSlGxhXtsb5FN1ucyC1KVavWutqb/PsmQx+WFtQBn9V0Yj
         G5yg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788629520; x=1789234320; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JOW8XuwLJiAY2FOtXpU6W0erUZewcmKtXhsLrPUNiVE=;
        b=T9zK2nrNlDbJptl6tcz2YeAjvwIcTZODty0tkX63TABD7lKka0s3dF9Em2aMoWT8SQ
         ggKTvGIKrwhKxiyvm6mK1gjxecLm7RrrRDwTmZT3nXgqgnu9mo3DIfsDZsXyeukQYE7g
         EA25uOI8Mc2jFnAlSzQ+31g3102tg1kLPL1gVpBYysNpXn3WdJL+zpRgqEsTda3OvCLS
         c9KVCEmo/rwp64JWPh+5ccZfKP/qsJ650LJcbGzJvW4LPjoSzktqa0MhPNJRx3CWOHmp
         LIH/FJCCt4gZJapEZGCzU6csrt+iFAkgYkUrkSjQJ5AVfLkAjqunb4FNgMKAK7RptFHr
         XD5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788629520; x=1789234320;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JOW8XuwLJiAY2FOtXpU6W0erUZewcmKtXhsLrPUNiVE=;
        b=LDSxrJ1frNXEs+pNKjz1Vs69L55OSYCcbIPEnEE1lWXwixpfj98Sq4Bc4W05lyZp2v
         u6JOpZgEB9z7+cPW7M/QF1w6doLSfM4pK7kq73tpn5v0usiy5TYuN310yzztRRuTY47T
         O2OPzocZ9AWZSs9FB4SpUSVSVBGuIHCWMJ1E5OBtsn5f0qwlD7Ic5Tn7uNwReoCyNSwo
         xyFKrfkCUKR99f4Eynztpmg7LlT7kB+CPtqhof2qJ53ki385uSzGIXh9hm3kxV5a0/Y3
         c1MxqtHIZRoo+x5WR9z+IZ33oypy6w56yPHQbsNtdVDNX2kISyuH7E7yg+JzFUKz3gCR
         eOIA==
X-Gm-Message-State: AFuF++lDICTYF0uNn702IJvrgqSkqBQelHypT54aCCkzWYiI+EjcgfWk
	2cHzAx8yMt/4qysZhf6OY2/tYpR6PwjNp3wNsAygdBotYoC5VQo8bI8zFEzkVUaEEHII80VE61r
	g+gZA0sY1WVRvFdKMWoWQIEjckoclhYU=
X-Gm-Gg: AYBFou1+PvgogtQh5XFGWlfj9sOwAvZov2KF/M1rwEBEeAtnXQ29ii+G7vdmSManQLr
	YpLwjr17kmLvyNZ3JqDLp/8FouMQWdbDU5Vlf9K/OzUXKTzPjqwQneMwCHmMgcnCQ8DCN0oBJJ/
	k/yMZGqKoEyY/cpdKWvhmrwGL1nBPYbrU0q41yMO6bGHoxI5uMKLShadM2tNpfGbN9IY29jB3D1
	tO2CarkhAC678jeCl0c4EEJCum963bpd0G9PKk2xFDeDjikrpi4PGhrmLAHVEA20l7bi/6Wu9ju
	gVQlbokILgJfxBIbo2fMRtF3KT1g2aIRrJq/WC0LFTrddJbcHGpyIrLmK/l2TaS6lV2ER5Z9X8W
	W/uY=
X-Received: by 2002:a17:907:c16:b0:c25:2d27:5652 with SMTP id
 a640c23a62f3a-c260c9d1affmr910733066b.11.1788629519742; Sat, 05 Sep 2026
 10:31:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com> <20260906-mglru-flags-cleanup-v6-2-9aacbd77d4ca@tencent.com>
In-Reply-To: <20260906-mglru-flags-cleanup-v6-2-9aacbd77d4ca@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 6 Sep 2026 01:31:22 +0800
X-Gm-Features: AcwNN1W6XiAA7KV5jUk181yU-Mg2q-AQY3I1lcI5rPzfroqnvUHhwkCK3HoP1Y0
Message-ID: <CAMgjq7DTmBQU4D95J2ur2CUYPohx1ychRV=vKvLjR78tNFJwOg@mail.gmail.com>
Subject: Re: [PATCH v6 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 72A73C0007
X-Stat-Signature: pi3r9kzq5dk9i6yn6gb1zceytdzqd5hg
X-HE-Tag: 1788629521-539502
X-HE-Meta: U2FsdGVkX1+lo6mbGtjj44mEZqgf8dH6obGIniImkBlS6xJ0yijOgBeit3fg1Vl5SsYyHzaVRi9I9PWwpJufMFuXWCtUJ99lnPtAB5eHUxIZlrtzNXkCNkS8Pa8b2lywEH0N22kBUucSaP/JCoYrwPlzQ/5SfuoJcOuZkPTfLvBN6xaZQIFUnl55r0aTjtKXzSu9P8p6j2puSs4u5x3Ez5ix3sftjcoCVeOFGpg5bFktGhDNBLrLkVjszduEczSOiN7xB4bJzKvpysiwXOFPcJ0hnf1Y/uKh7fxKHUvX5l6aUlqblxfJz0PF90fgjbg0lhWaVNx4D57wyrE0rpSUrTM1QPyggFPGj+cgnpZJsSIdl3oJxq6bbw82Os3n/52NmmS9FCAtg8+C5pNd3K1ii70uLB2qQ5qkLS5GX7r1ou/HFm4RKFW1Og5xyND0x6sNMtYVksgAQt6TOBmQCyaxdQg2que6r4MQK32fCZ0sjbTYXoR82p4wYsnmtZqwD5HoGHfCsxakQS7EAp9dFXBdI8tahuLFIv+NrG+Fgvtf+4EGiYQuUOZeWROGMe77DoNt+lQ2AGjL/xyig2zCu1SOtQrwUYZXSZHzf+tpPvqnLq4kQT3qjrQ2p0iBe23Bt5q/+uew1pworUKCAs/o9dMvQAdEypgiewGOLE9rxjzDoFPG1FpANvu6v6d039RdNtPy2DENrFdI0SExHdLoJXtanSJ8eu0t+bN4YaCp0PeuEU9gMOBoBqRzni1Rc/ClTY4DFcs6J4qjGbWeCffPGtnfwf6QgNAy7TReggKI9A7PQ4mWNjMJqsMTMScLJhFF8VRzDQ4JD/wt7lwWoKJ2nPFFgFn/LeDOgV1La2/VCGXzHeEZYZuBZoI8gwJFr5cJvsqQNLjdT760NH09pql9xIg1yzX9o7v3BlCZS3gnRpZkJHA/tNi5sHn9Rrbh2xCFINivE7U4WVOoWMHlchmL6Cg
 JhshhRiJ
 LGsAqTwg3CzugDxmboGExDCknwGOQZC9hwdAr/hdLadwE7GLQ8Um6LUT8qAq920VLovBlqWUo69giuBRwsY/7cikXBHiozRGe9G9A9LGHb9Ci2q5zmsTsPPNi/zSIV52s13PuQGR+Knrdpnn7mZMVZqWc0QyDATGYW1Z2en9ct9lhnVErUUVsoRITu1u5T7Nuk6rQ42fMGA8CuHfEA/J9MRB9cVmE1drl0Qg1jE7oRhQmBqDD2J5Yj6P7PpMo0yrMloISyOs2tUI7T8b6R/JwnFy5Cp8JzjNr4q711ucsGW+e/5+9yslU8HadQXmRbQl512T67EO0TH+3aK5ihx5BOeCjqMFVGUMwyXpFmRRkWF84hGV/wxo2yBR8WmPi8MfQ9Fqxe0qzQnX/w9sJLm46xxBk5uALxXxBfFb3Kz+N9bP7x/bGlbO0UDtkjYRUbXZDc6/vziwJNAWDc7LCQtZt6fzlzaAN/TTmZ7LsUiaD/rdpe/PIohaS3eaFnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko reports (please ignore, false positive):

commit b3b2fc9d5285717c3d36754aee77477780b76245
Author: Kairui Song <kasong@tencent.com>

mm/mglru: introduce helpers for manipulating gen and refs flags

This commit introduces helpers for adjusting a folio's refs and generation
info instead of performing bit operations directly on folio flags. It
splits some combined atomic operations into two without intended functional
changes.

> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
[ ... ]
> @@ -270,7 +339,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
>   gen = lru_gen_from_seq(seq);
>   flags = (gen + 1UL) << LRU_GEN_PGOFF;
>   /* see the comment on MIN_NR_GENS about PG_active */
> - set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
> + set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);

This isn't a bug introduced by this patch, but does lru_gen_add_folio()
fail to clear LRU_REFS_FLAGS when updating the LRU generation mask here?

When an isolated folio is added back to the LRU using lru_gen_add_folio(),
its generation is updated but the stale LRU_REFS_FLAGS are retained.
Stale tier bits can inflate access counts and severely distort eviction
decisions, defeating the purpose of the multi-gen LRU tier tracking.

===

As it said, it's not a bug introduced by this patch, and I don't think
it is an existing bug either, lru_gen_add_folio isn't suppose to clear
the refs flags, or we might under counted refs or workingset.

