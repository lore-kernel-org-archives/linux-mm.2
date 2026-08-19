Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 377F4C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 18:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19876B0095; Wed, 19 Aug 2026 14:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCB0F6B0098; Wed, 19 Aug 2026 14:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8586B009B; Wed, 19 Aug 2026 14:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6516B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:14:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12AD41205E9
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 18:14:50 +0000 (UTC)
X-FDA: 85118819940.22.9CCDD17
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0BE3FA0008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 18:14:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="K LvABCm";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Mo3J/+IF";
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787163288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BVme79hoRkiBw6t4eEj//pl1ufr9k9eJh/jdgu6CPqs=;
	b=2slS6Jf6qHaruaz0Ul0mrBI9c5gaGsIlU/yKciKNpTH9WPF+5HDVnJ96ssM+lEJjGqPibl
	Q0yXuTxz9iQOwoOQNYas6RzogM9SyahGEuyQC5jZCJGpNxs+whGic9VfRf9fPEUwP22LY2
	33FY6irTrQWdRg/tW+IFVg6GY9+pGVQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="K LvABCm";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="Mo3J/+IF";
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787163288;
	b=XyWcCVHn0yk4KoEfrvgOeqqEHK23VLYP0t1IMGgpsj4WA+pYYlMkfwL75CsegwiXHFl8BI
	1lqkdvNCRRdyKNbL+TpNtepLohe1focgLPkEUD2iNgWH6175RzBmnkmF2pFHe1TBHArN2N
	ZidftRZM2rVY/mF+e2zB7OggNpZpVyM=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id D391813001C8;
	Wed, 19 Aug 2026 14:14:45 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 19 Aug 2026 14:14:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1787163285; x=
	1787170485; bh=BVme79hoRkiBw6t4eEj//pl1ufr9k9eJh/jdgu6CPqs=; b=K
	LvABCmfdZwikDsZYs/PabPcmwBqWBSQFpqOmBS1YgoUR68HQ3MVvg4XUWQpc7qBw
	89Z/ySzitX9CArnyEB2lorlzROAzUqOcFpcbvZVUl9/8aKK+0HhhtUxTuE+4f621
	OqzE77WfMmdfWyUBiCZQVxK1o/Y4rBmOB7x3ckrct3l+i+/o3QgpxgvpSAlvdTxq
	5NGzgRSzxEXioxoGIHPt/BxW3z92kil7TxtH+Ollw02iub7dpdMEX0OFZ3IFARGe
	fW5gv05D3BqggceAolnLf2zfov4uu/rL4bWbp6H0fEMNnuOilc1y3CWQXuJgt3fG
	imNffzSDwziChB9zwClaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787163285; x=1787170485; bh=BVme79hoRkiBw6t4eEj//pl1ufr9k9eJh/j
	dgu6CPqs=; b=Mo3J/+IFlVLLNNdJtnPKlg+u48kgqwnmCXzgORlsGtApYLjBlEr
	3MkI24ee8dV40HeBoa2ZbOnmp6nNOODGI6CrkQKhUwM3SVShChm7a1NAFeZ0dBSI
	yPCdzssPM5lfF/MGIEfOGt7ATJvQboc5/qzYLMCkV+StGzopQrf4/8K5aDK+JhAU
	WFN9Vd592jxxziDbZySr9iOT17gN0NqTV4fEKbiQCIEhGg4C3aW3kKgaFoDYHXqh
	kC0pfaIoKgdyn5B6oJoA4T1taQfChapV7YE3qoqhRoXW59WAGJAKVSwFxS3koAvf
	OQ1aXI5mClDS+2IE+gvWl5Yg47njKvJDGGQ==
X-ME-Sender: <xms:lPKFaqLvez6cyGk72IH_PL-Ng8lRfiHPXlF-Gkv0E2MDV4jK0J8eBw>
    <xme:lPKFaikMe3iGe7HLKIc5aDS4kX9Vks0eQF2LFQJqvPQI3C0Bfp4a-qmTlhBV727Xp
    bNrpkFyPE8GujlKe0VOKv8sMebzt86wxgq9SsVMqnr_oVg0Kf050KQ>
X-ME-Received: <xmr:lPKFasKZf0n8wV2nkh0Olplme-EwXxid4y133wZyB2y7nnTqH6XgH4UcPKA>
X-ME-Proxy-Cause: dmFkZTEAtFenU/LIphu3Pm49APH73zcxjrAh2+DT4lFCFbZt96OaIx4ArNaVHowyzXvVYq
    W9xIIWcgbmtY3cjbSg/G2Y0T8WiYG5K6kc2ogcT1loTWpIezio7q0XuH2d/9UQmNT4K6A0
    0pN7iv0uM0ugmuDBqeHdLUS0qJmciBjJUha6nFw5DI6EhAz6fiASPyDmKpU5uZpRJg3hbh
    Shv7Ge2QX7/OVC4F5vijUSC7W9rEnGk6DMkPJ4Q23BjQco4fQNkMPH9H/lSgdBZEYofptL
    F/oVyFzuZ2aM7moWyI+T/hY0fFE9E3s9gQO4+ik03UGpXnO7FrgCh6nj/ueW5pe+kcnBqA
    pqGhMD+WLbggTIO06gXYj0sz4WHSevh5yMn/bimQn/YZcLcxOpT26WcnTZjbPCPZjpb6yq
    E3vHGwI1syn/uasT2tyhaUF2Ynyj2ecS0RGUe6Rl8mPPu8i1tlznxN+ZWrsQIseFcFP96F
    7/IwIUZN/XQCl2Yf3XxxiJ8rUkXbUW4vJZtEJpODZVUpsoABguaUgkO2PGt8EB5ZYQAiKK
    knm3LVtaiot6Sm+b/eztEGXipoYfKvAa86UxdKwvemuGNIll5br7W0yaH9RhMUoEJWDbOS
    igazw5XGsdwgchQFhdlAQC1BAimZUr2MUaw+IZ+S4Er1pAGj9Zz119IfhsxA
X-ME-Proxy: <xmx:lfKFavbq-xYQLNHEf0FGKGjyBhhY4GRzsQd5rGkjkXP1sUr7-Bb9QQ>
    <xmx:lfKFagx7sxZ6lmILtDIYG9cx2LdbFyG7nGRwVtJpAGTiqjraO7jJeQ>
    <xmx:lfKFajZnk4rX6I_xKUN-mGgwTce1WnrKVkfwtrrs9fxykpufCiHT6w>
    <xmx:lfKFanWIw2NrfuC4qkcIJ-hakJgyWTTyW0GehHJJwnVZaIcttTZpUQ>
    <xmx:lfKFarC8AemfcCfiABb6bq09GyoMNAcE-K7_lW3mEEThY0EAGwt1sIEs>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Aug 2026 14:14:44 -0400 (EDT)
Date: Wed, 19 Aug 2026 19:14:42 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jannh@google.com, willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, 
	mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aoXxkVQJle4Qdl_9@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer>
 <aoLkMUtmzRVuv2Hx@thinkstation>
 <99138bda-55ba-4c58-9b79-b76e9daecdde@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99138bda-55ba-4c58-9b79-b76e9daecdde@kernel.org>
X-Rspam-User: 
X-Stat-Signature: esf8h4gnafpziwcex9hifd7kgb9guzbx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0BE3FA0008
X-HE-Tag: 1787163287-492701
X-HE-Meta: U2FsdGVkX18XkWMDFJazgv1DDEjq7+kMLoqh7g1dKxZp/l+wSiInpsynt1XWBowtxwCuFMGANkRZD6Wd1+AVhsto5qlilI+euAL/ZY5MK27DqTLmKb3e+xGDqH+x55Y5WwifMiRdS2YZRjaGMYl3v31iTMmTqHDLta6R9usbC+3Gry7qPc0ZFRSuSSsmxcLrojqUekpM/lUQsApM9kUSkx13+KvhSceVvOp358cg3IYxKfUBDT6cuvLlQCyNz2A4D0G3ZqokFj4vAbogFm1ost2i6tgbVNOfbEC6A+A0ZJ21ZrUlVL93r8NJrQMxjEgM1u5rNBH3kQuiffpN1cnMP6x/j68L36GdJio0Y5nWqWTPdMRaeyWo16RTfgVnVPKigKBGpZcKhLn5stsVrGw7QsU1hx6nRUX4LWlOIrm3ikh0kcaUFVl5wVCSCzZk7WxP5F2HeHIUodPYgFGBLVEceLeAE3bViGR//zDfIc5VmjJy/IlFe9nCtm8QlHUwlL2R90bhxyyD/DhyF+sV6CbOleDeDvwrUhK8cuxzXnySBL5f+groB6eODC7U4pEpWRjW8Kzed2CZZSmzPgS/+qWjNzBteYG8+CHSIC+hU0QbvqhIShQoi8tgdgxu0TaGV4z7fbnei4HWBg007nXtIy9QVNy5NXskqorWoAMXPU+4afQk1lh+m5kPe/b+U9RdPBKgEZEwKIK3BtDm5BNcdu0bfsGGQM3wTeQz+kfUUTr5CAqi1Zbwds509wJ32/XIWV/lYOo5csWgvCIP6y7jBuMoGUBS+xmfwT8seUSd9Xn5GUUxt2F3Wva9lLq8woOd52/a9NaDeMcC08TqL9UXlqH7lFxAy2pbqaQrYU2VspS+X77HymdvBlXErKdgR6xoXG9G32Wrw6iji0cA5U5f7zwRmy9+NevngDab0yPl42elRruakt9vyp3umHZO2Ldg4JwHDSpIv+G29+rBCx2fhZu
 vKrqM2fy
 pBMLXsRoPuQqi99dPC3z7nh5BvfVWcx2/neC/62cnEkR7EHNYQWpLbrhERl/xYCzn9FtQd7FwlO8Cc3ejMUQLzkm+xj+uBmVzjtmr2hjxTEaQ8kUZbDqw4jP048hdZT9uNVJ8FjZtM0VdUpxIevvIQ2gZy6JPy1HlnqECZqUyjpqqDiXXaVd9UZ3DQR1RRH5msvRR2iNxBf2p5WZ6YTuPO+7GvB7vOx1G7Ajg4qzJgYHtxpie8kZ9Htj/604soVaulDtkTTT8sgF4HbzFnt3u1+81pDyPCVAuhM9d8ESObHybpX/PuZoKh7PgObGm8S7O2LHGkVh+A8hZ17GabKQ/BBTEO26Agcf7yE8MxL2sXzn3blT7w9d/ssgdGF+i5+MvjoC1Lqs8OBAFt18wnAxwNOij/SZCbPyCUccEjZ2q4UiJl1LwFICScfnFOJWCcBRG6A4l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 04:15:27PM +0200, David Hildenbrand (Arm) wrote:
> > David and I talked about this at LSF/MM. 
> 
> Ah, I missed the context in my other reply. Lorenzo already had some patches at
> some point to split up mm/memory.c into better chunks that will also better help
> our subcomponent maintenance model.

Lorenzo, if you can dig those out, I would rather build on them than start
over.  Happy to do the legwork.

> I think the challenge is how to handle huge_memory.c, because ideally, we'd not
> have these stupid callbacks into huge_memory.c once we make PMDs just a
> first-class citizen.

Agreed on settling the target shape before moving anything.

Splitting by operation answers most of huge_memory.c on its own, though.

Its entry points are named after the operation they implement, and each has
one destination: do_huge_pmd_anonymous_page(), do_huge_pmd_wp_page() and
do_huge_pmd_numa_page() belong next to do_anonymous_page() in
mm/fault.c.

zap_huge_pmd() next to zap_pte_range(), copy_huge_pmd() next to
copy_pte_range().  change_huge_pmd(), move_huge_pmd() and follow_huge_pmd()
have their callers in the right file already -- mprotect.c, mremap.c, gup.c
-- so they move to the caller.  The callback goes away because the PMD case
becomes a branch beside the PTE case instead of a call into another file.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

