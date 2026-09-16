Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80D2FC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 902CE6B00A1; Wed, 16 Sep 2026 09:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4056B00A2; Wed, 16 Sep 2026 09:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3EB6B00A3; Wed, 16 Sep 2026 09:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFE66B00A1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:05:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5B30406F2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:05:12 +0000 (UTC)
X-FDA: 85219646064.11.1809F8F
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf08.hostedemail.com (Postfix) with ESMTP id 030B0160016
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:05:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jymZga3N;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789563911;
	b=12amwY3x4p09vyaD/+7oVQ3Tcyxxq/ds1K29VNKT9tt3gvmZTetGg0XTInGAcz/DeCdwji
	CBn+XUQ4miHBzOYZ16CDyj5h/fexj2tcvS9n3LXXVu8b0p2kqBpSUXpXUWt9nm6zZc94Sg
	NOGByjlPfQxLNiwjLPsfjdLINL4VtBs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jymZga3N;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789563911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYdUhGpjeA7km3CAfItuHpRj6rsHx55A/+kIwM9brrI=;
	b=ogYEmHyxPjzrXswbqqRZAbgBrW1V6nP/oGvIDhprFkI+g7A5/X+rw64DaMOEVVLdaG6rET
	rC26MQKEr8dzySejalXZ2PuFrC/X4uuONK8FFX42QWUhZIrFU6O2WrBe47Vj4pPl2KELMe
	QNJAZL4W4iMxEfAKsIsrc1zkpVikU6A=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb76ec392so7663111cf.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789563910; x=1790168710; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZYdUhGpjeA7km3CAfItuHpRj6rsHx55A/+kIwM9brrI=;
        b=jymZga3NaDyPujmJMgA8Unp+R9OIVeqM1WRjIninNTc87JqR2CSH1MFz5bfsHCBskx
         8mPi0W0QAyya9GgbNeDEbBW4yx7K0KDPkgcL5dH0g7OSg0SCyLwUJxYGp+IO8Vo34QDG
         6FvD4bb3JSAO63AWRrlb2QHOAUN8F0vfuy3a8Vcil8r9dPfqGy8ulBGph9T85KdsoF0t
         8I0IX4y+tNs1nTtrtXi9DWE0XINVduffw6SMYy9un4tSv7BmYIcNFOraw/djENyyataP
         jzNKu86vWAWlC8x/iY5FNaDgsddykFgj6etc9Ps1MMiGsD1JcExuWRRLciJNDTYTbF00
         m4HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789563910; x=1790168710;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZYdUhGpjeA7km3CAfItuHpRj6rsHx55A/+kIwM9brrI=;
        b=ibfE5Fzsrl56EcbvjNcBd0omMPZyM/AGFv4vJilEUa+fdg/fLcaysjMre6HhPE1p2v
         2tWW5HYapfR2PtCzPpj7flLlNMHBMIn6C/MmUeLYAaF9cLSMI0RirxpLJFJqbKWZL/Tj
         0g8zAHRadB9yCp1LFfLpC8mFHP75f4bHAO77H9eDFj7BQWXOomJRdOo+wl+UCFIU9Vuo
         ChN4PHmdro0ORrwd5cuVIa20tBWNzAKXPZZN9/lQORal//puRG6kGNcXWYaB0I5O3VVF
         gAan9l7dmbLT3lheMmg5OBjyK8TpEj1tGrWfGvt31gxEZVptewcBU4Sijp2eaKAKnQ0p
         7gtA==
X-Gm-Message-State: AFuF++nrG3tjoNOgNi7iji2w5V+6xEPHWSFVFcvc6gAEyltIm96V3c7Y
	btvkZb8/76lXa3QZh+DUvfiJmwuKhwwMfIs8BXj2CWbQKBFX+wqr3m069C8k7+SX5T4=
X-Gm-Gg: AYBFou14k+vNC7m5hg6DyxkRTs4gevsTrl4SWn694PAUo6kj7XAAyPgUrOYABQZhiHW
	B2iDtLsM3kdZtVoFJGyIVniGWN1w960Sgkfsz8nqIz/42c+OovP8yNiH32Et0zk8eCgaRcGu1BC
	95/2uIL5lo9NhyEgSI6aJhdfZB+QDOJwz+Vzb9LSGEr6j5wM9XFt10Lgss/alaFHvFOizOlbxcv
	T0mHJF4vJw1aeo5pHgNXztfOKo0YpB0vUrkuSmSXpyIItxSiQs0HocdJ1Hj0ZkxHUdLRpbxnYbc
	g6fr+h9Cmx81Aw9dGmzeSBE97asu9ZnnwzXfut/rlRF/EaH2H0UFsKpf3vBvpBsxJ04UQBa3xNv
	xh52mgVjHqztzRp5wQzAZNXNbBJY7Ke3CtOIDepPrZczsgkIPNJxzLY0trft4rLXSZICmttIv8k
	0WQdGIn62ZwUDF/8Ka2b9x0kRUJ+O3pP3oO6543RBq4BsXJaX810SHUUYG2adiToFuR+zjOAeeY
	zXckFv7T/6butotkSInYLcz9ACdw3Qg7rxoZoOuzE+Cn9ctHJI+kQM=
X-Received: by 2002:ac8:5742:0:b0:530:eb7e:79fb with SMTP id d75a77b69052e-5327f05f9e4mr43255651cf.45.1789563905323;
        Wed, 16 Sep 2026 06:05:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53261fd7e5bsm21409661cf.7.2026.09.16.06.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 06:05:04 -0700 (PDT)
Date: Wed, 16 Sep 2026 09:05:03 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, 
	jannh@google.com, sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [RESEND PATCH] mm/madvise: use folio_trylock() in the
 cold/pageout PMD split
Message-ID: <aqqTl7JwYzM7azlF@gourry-fedora-PF4VCD3F>
References: <20260912110540.3203010-1-gourry@gourry.net>
 <2f63b25e-71ca-4af6-83d2-70be2388a55a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f63b25e-71ca-4af6-83d2-70be2388a55a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 030B0160016
X-Stat-Signature: hbr7x6ois44draix5sizgjq8xf9mocjm
X-HE-Tag: 1789563910-992955
X-HE-Meta: U2FsdGVkX1+znStU9bbPQ0kFrCzYT7df1f+KCTVwz4/E6XK1OqTbxi4KoIoSnNa5dZYNDZb8a8VFGH406rVejaAP/puFwkoOvdW2vA6zPOy9KmBJa3VHDpWpICa2YnFCG7w8/kNzPa8zj4zV0W7gRrJ/Ykz55EC0jjqJ3cQLWDic0LWFCMfDiiPp48mpquig+TiuWrgIQcIgyWwpCuf8HLcyt4BTj/5n8nnBfVOPTlzkkiJH2izfJATbzQKY03IACYiD+YIBtpHr1wi5vWBGeRlvAzGO1E0opRqEVXWEDpCOABnne/qh2YWiJIzcEltPIEqOGXEPiJxb89MQfuU0qU6NnoECzMdnSHZjT9ek97RMBEQ0pj6Tg+//jUvZ985g/IH+bWfYHZRIJr1spYY0bC3eSBW5V2lK5VEG8x2hR7jl9FFiT4YJhlncTMQQS9m0rkOLwM2/WScg08Ie/cEKPPvLZA4vkHJ2oGWW0p//fiRl9NBkictxBRFr/Xiyo7BmFhaAp3K1f+JNnwucSJ4IAbbjnJlCI6p+dvOACcNxqabqktTYuwcN2crndS2JKVfxhvLBagLFqHmGt0Z/y3cB2ouiGqw3BtbWE4batKKjlzE0XdyHLfDu7x1TLtFaqa/URKx306p46JoI+Btnc52asfwrImB3onqlMniVnQSnjQgMRlHY65MQlqx+240v4DKMZl8ItkQw5Df/n+JEG/k2AC2tWRKTf7iB3wXxaiSMUiVm8jth5Wb2q8f4M8dFyMhtre7CTCjYS0Z2002PHonNgCYX8uCK+m0mC75YUeacXxyMO2FA8FXg3oiXX7thm0hiIISQeN8SZKTvDY0AUeEGWy7omAo52bKEMEz9tqWFUYVogqPiXagrKgJxdt9hYT4uNRPD5pXP3yV5Nn+ZVusSSukSc/IYNa6NxlHPJ8EbgOYmO7ONdVgqGXlbwhv6vzhRT7+5ge6qzhGNn1RIKvk
 daxlEABc
 i8k7jL63hhnpGxseultrP80y6vbsC8SApSyauPn+ll5fON+AeeWwGJsi0xebzteDI2sfYkoHX7Bl/xtuZldB/naw8rA/DVTcipGlBjjRCxAjuW5HGObGQg2u26UZFD7j28Bf9/oJX2M9wRjSfH2LUjudfBv+cr/4ZF5s04fLFbmDQ3qLzYEcFsJIr8nuQApqR0i+Ed2nLRmChyhL2dl1FDpDivTtd6ShBfkMksuIOIH+hSMirSpSPDpUC7MHuag1payXhr5yZkdyQMVuqDDj4Xc2OItgO5SguczF+KytJpbjDvSUi2VTuCpey+QsG5HXG68fqjhzCUnZKckcrZu7olGgZYHm1MbAMOhTzGha4Kgs1UR16F+DGsSxBGRuw2vV11S2jiS9gQHJRf80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 08:25:01AM +0200, David Hildenbrand (Arm) wrote:
> On 9/12/26 13:05, Gregory Price wrote:
> > MADV_COLD or MADV_PAGEOUT over part of a PMD splits the THP in
> > madvise_cold_or_pageout_pte_range().  Two threads doing that to
> > the same THP create spurious failures.
> > 
> >   CPU0                          CPU1
> >   ----                          ----
> >   folio_get()
> >   spin_unlock(ptl)
> >   folio_lock()
> >                                 folio_get()
> >                                 spin_unlock(ptl)
> >                                 folio_lock()  <- blocks, keeps its ref
> >   split_folio()
> >     folio_expected_ref_count(folio) != folio_ref_count(folio) - 1
> >     -EAGAIN
> > 
> > CPU1 cannot drop its reference until it gets the lock CPU0 holds, so CPU0's
> > split always fails.  folio_trylock() makes CPU1 leave without ever taking a
> > reference.  The PTE branch of this same function already does this, as do
> > madvise_free_pte_range() and madvise_free_huge_pmd().
> > 
> > Reproducer: 400 rounds of eight threads calling MADV_COLD on half of each
> > of eight THPs, re-formed with MADV_COLLAPSE between rounds.  From
> > /proc/vmstat:
> > 
> >                      thp_split_page   thp_split_page_failed
> >     before                     3186                     860
> >     after                      3200                       0
> > 
> > The short before count is rounds where every thread failed and the
> > advice was dropped for that THP entirely.

bleh i thought i rewrote this sentence.

reading madvise is driving me crazy.

> 
> While the split now succeeds, one of both calls will just effectively skip
> processing the page table. SO while CPU0 will succeed with the split, CPU1 would
> just skip the page table.
> 
> And what happened before?
> 
> Split on CPU0 failed and it would skip the page table. Split on CPU1, however,
> would likely have succeeded?
> 

Yes., all correct.

> So this is all far from perfect.
> 
> ... but this matches what we do further down in the PTE scenario.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>

Thank you!
~gregory

