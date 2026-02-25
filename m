Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5DC4FD3747
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 12:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEAD66B0005; Wed, 25 Feb 2026 07:19:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98906B0088; Wed, 25 Feb 2026 07:19:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9ADA6B008C; Wed, 25 Feb 2026 07:19:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 958A76B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:19:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 24E201A0585
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:19:27 +0000 (UTC)
X-FDA: 84482884374.16.E6CE0B9
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3C289180002
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:19:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J9xTjjgU;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772021965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5GivVNyIA8JAZFbbK477torhwiVkLccEddGHhqwOeMg=;
	b=nS6LZnfxDw/BfG5QlxKX/QcOj2HVfZtY81nh7eo7CzphINYQfm6PFF3HagYvgTV5kXOLgt
	gtMByNWUTPsE5YEmUSUxfwFA7LPAl2YJkHZU4UaAXBoivrVzucbtWpWVJPfIRnqfkQmJYY
	ec7V4A+CA3GtB7LGCxVWxdsZFETixFM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J9xTjjgU;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772021965; a=rsa-sha256;
	cv=pass;
	b=ZLkByQUbzhLdn6YeSNgfjUIM3f8XWLpH2IyFjcO8J/7BDZRoL1tLK0IXeYlbPgJPnWQktm
	OhgVZOWW4u/+N5UV7l6yAih2GfqaNwilScBYQ40zsQNT78OQczju3luVQhs4UmBebI01Rr
	5gREDhxIdU/9PIpv+0LA0f/Eaa4C35E=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50334dd44d2so78952501cf.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:19:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772021964; cv=none;
        d=google.com; s=arc-20240605;
        b=AXJrKaM+ViDENDcT6J8qO2YXLZVgp74EAfA2BZmxShMb4tlyI94dfrKgemkbwPn4Gz
         aaP30iXJPWG/DX/NLlyIJGiH9ZQLkFlbRJewxGDTvQ/lHnXxwEK/5rrtPPgiQOzxCdqV
         O/csAu1Cvjy7OKrGoON9MHur0trUqPvX+x7XEBxq8HLNnEeGG/y8gMGRTQFiiyyisL+o
         +KQIsOVLBNCsOQ2RKQpAMXvmBC1OPNjZLDRGNlgBKXqVVltnTMaMcOdOpxBEY+OqilOL
         6aqS9HyIbeQM4GjGyC0zsscxCo3olY78mlSeXOojOlR3P7eJioiZvFawxVUL2guBoWww
         d1DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5GivVNyIA8JAZFbbK477torhwiVkLccEddGHhqwOeMg=;
        fh=jIchxDKlRgnfV0eL5R53VjxB0IUCJp2NSH1bWCUm7G0=;
        b=O0lfBigQ6KNZF774aYoNCBdY5Bq++YV+6WMiVpVfIM3XY+5H1vDpWoJDaZLl+VcYB1
         sPEH7wEV7tpICgO9QV0RcHLaGgjNxyWmLoWtKDW8k8COPCtRROfI53alP4wjAMCovblQ
         ZrFtC0rRSZ/gKCNT9n1HmhzFS/l2Rwi5UUuiABs/xQBbDKP2Xephhg+vFm/nrFv1z7fS
         EZObCqM4+UJY/FThKIGzcvbj3Uh1BPsv7cK2FrBDQED92okyVtvrj/KjpWFo1KWFGqZa
         yOWNagalbgXnOvSHl7PHJIzk5TiXbuey/CiZWqaGceFxIwQFwjDJ5gFvA6sg/SmNBQYr
         qLBQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772021964; x=1772626764; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5GivVNyIA8JAZFbbK477torhwiVkLccEddGHhqwOeMg=;
        b=J9xTjjgUjxX9UvtJveUatnpb0AdKghqBguiuX5WA71+iVGGWlCcef7hvUq6nr1a5tc
         sk9EC0rbKPsxS3XsRk3ZpUSh7p3rAYvUwqzfGtZy8qTuA+cs4Igb7TBK+OD05YxXfB7E
         4S2Mn/4uRnd5NBqWia8IX6NQFQxuB+aPhqs72GpxVwMO31ObKyv09HLIfXdVCHwbYFnO
         IKNU/CU5Xr3zPkH+7zneHMBoxqg4yFAb77tuIMncvd+HTQnaixxIx6YTm7EV4/ojrtUu
         zW7Fyd+XCTHHCBZgwLR8m6jp1TDm0uPyeOjjb1I19B/LS9XklT/d2xOlHmQrQhhqgwvH
         UnMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772021964; x=1772626764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5GivVNyIA8JAZFbbK477torhwiVkLccEddGHhqwOeMg=;
        b=s7sLiTrVBCmLmIJitQ2eFfpCvNNwL2n82+kGY3FSivJcfw1T86VQCFm9ANKEfTKzZm
         Ksx9k5nOMLYQp4ENL4nqA27BOB0AqqGz9ZRc7Mt2MWyc1xdCPe5hIVHuhJ6cWI7kz2Wk
         S+iObedoW3pdJVa75ZrQbPAqQakA1jpUXYVGy6HnjJfKGLYk9RhyNXx5sJ1CUtcgiFjt
         LCodFaFXvtHMmJa0MY0Y6R+Cd0EwFlWZos1rZe44BNnmh2kEZig/7Enu4cBdMaLTh+2d
         X3SLkiyAdyZvK+cnPhGO0nsZDAQh0CBZuvtfO4xAM/qFZDjOOxp4XWiNTAy52TaiQ8VA
         hh+A==
X-Gm-Message-State: AOJu0Yxc1B0sR87TM8x1+q7XTszcFHMl1R26lb/GI5cF0WTGz8MZCUMM
	7IRBlezMzU3Mk+0OP/c9QPO9pSPhIta17AHFZHo3FwAQJKUkxx1VfmRSdt14s+3ZOqNqMecaSew
	l9xolGWTx+kHLzqnpj8rEA9FeVCKCAMY=
X-Gm-Gg: ATEYQzz5JtBYugqbrMs/wpywbTjHCVz5NAL+9QDzEP/ifsN5S3wx0LYrIuSZJTyiv0K
	pAXe4iWAIVUKbi3SJ915Kz8gbWGjz7KdS6xH3iScYap66axpjF/QHYusK+OgZ34u2DOoJss3uJP
	77qlHAtr13hx3RXe+VesVxRpZ5Aws+iS2frvKND4kpuk2gSChj08pCAf/5qLhxhHI2KWNG560Vz
	3kBPiN+enrGr9eJVLRYg8fRAazoEPXd4k1/IKqEYsJw9N/6K3VGcfVuPCMkf9c10J6mxXwYvmuL
	OS7kCA==
X-Received: by 2002:ac8:7f91:0:b0:506:9ad2:8d4a with SMTP id
 d75a77b69052e-50741fcfdd3mr1385691cf.75.1772021964065; Wed, 25 Feb 2026
 04:19:24 -0800 (PST)
MIME-Version: 1.0
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com> <20260220-swap-table-p4-v1-12-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-12-104795d19815@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 25 Feb 2026 20:19:14 +0800
X-Gm-Features: AaiRm511TxBGRVuIyMzvT0fAaZozlquA48wNCycgFlMQWIgQStFaENf0SwcgBCQ
Message-ID: <CAGsJ_4yv31utMTsZcRf5adeUzC7NnE0DfMKRFi3v1iCxfdXbdw@mail.gmail.com>
Subject: Re: [PATCH RFC 12/15] mm, swap: merge zeromap into swap table
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: us5s8qwyiqnbm67qygj1bd7t9ea51ras
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C289180002
X-HE-Tag: 1772021965-80962
X-HE-Meta: U2FsdGVkX19aLPb40MfBlMYmgKLfwq33g9BQRAQv4bEAN2yTqM+eRN2XMZZ1HsY76FNgm1bCVMNZzdqGhWd4K2OsCx2DOkqJhPV59gOao919uNbqQh34d0W7zadl8voc8nHm6o3t8H2xrjf6zJT8IO6lBnRjqUKm3CnEk2qoLwDhl1johOtmfi0VrpvEEaU6Bx2UDj6C39Cmet+kvxpVQtFu0+OdK36tmfzXvmuy3MIC/qh1CxgniyA5uMqK08rGdk542k22Pgxf01pnJntgFR4w6NiQ2xyItNa2hjAVgug2BRUDmEFNxdnfdjCHOcRd+zwjLQt3bT7TZBa6z8ooXZFgVuDq6ZqMn9U4zDqCG/uZto34C4W4jzZ8ixq4LygesmWf6mTEUyLsx4YsxxfM+XkjeybSU0RFHY709K+dTjD0AnBKLU80OIGwVV5lDfoj93PXwdvF7naVExcuFXVOruyQfcRjACwK7JqwspLWPyphwZC+il7TVK8aFOidv12oagcShMKNNPiyJyTBGfUREQOMe8vnwiAcYStGhhaC8keZHDGU+BDkzfD8H5GpHhn5v2lnFf19SCq56ba5W0pppXY00CIYSteK0x9b7vLd+sA5LUcSLEaYHdU4gcOonsY8Oar4BYfeEfPrOVVknyL775Ys2AnSB9JejprTjIO4i82BMOMobJ/3zN2Q35JEn2LqVZFhULgLgpQh1owjWYJv3Rz26LN9AjsgbTU4btN2OiqxjBh2mCSkgvmDTfaVGkvUgZy2jjGrlAw0ti8w7wLVvJaQMVLQbBUhLzlfOD/VD92WrhSMfDANdobUL31TXQ/dsl6HhuaYaHX1jHvQqYsfDwYVnpoW19B1HMjHKtbrEUTIZlp1ypOL3tJ5pzz7Y4okTrtYD97I57DoNhSqLtmkka030tvFqoVE9+A5QW4D42bTiFFBENISJiMy5TJu0O+q7SpgV03dUV41OuQN8jl
 okEWCY4b
 UX0uURgKjs3KQgbAqRpRU3wBfMk8W6yG5zpV7w/tGqg6MotvC3tMrroN/P6tnwE4Mu06LTlHmumHuAUxvFneqDzCZwRnnA31I/0fot1sgnRp6gcsbEEnCJpjnaeCaPkYz8co5wt2ZU7dsGYF3RCMaam+W+T1Sp3VcfSguzdhYvkdmbNb8hMvHJ1d68KJ5sJMY5jmBcU1/DkjZoG+6GhUhmr2862k9OiNFnWVkarGrZ624W2j8RYiiHi/0i8BRQvcQWcdSeZRC3YNIFvwmKUhmUv7qncJ+1212IlQ/BvtA6Yspt1cB6/5FU+vtzlVO3ZDSlKB5lMImYLOJTu17jDsH8oEyEpZRM1TchKsCifhcRu70e6Uaq/zYAUD4cjl+4lqf3n1JWV2FYBHLKCatVLItOBF1kbASkxpmKeu1T8nkBwghng7C5uzqceelzJlZc4JaQdmd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 7:42=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> By reserving one bit for the counting part, we can easily merge the
> zeromap into the swap table.


Hi Kairui,

I know you're saving space by removing the zeromap memory,
but do you think a bitmap can sometimes be faster
than iterating over multiple data points to set or get bits?
Or is the performance difference too small to notice?

Thanks
Barry

