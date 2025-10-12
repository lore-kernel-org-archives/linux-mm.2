Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D59CCA476
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 00:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90F8B8E000B; Sat, 11 Oct 2025 20:41:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7198E0002; Sat, 11 Oct 2025 20:41:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FD1D8E000B; Sat, 11 Oct 2025 20:41:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EDD38E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 20:41:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E7018160732
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 00:41:54 +0000 (UTC)
X-FDA: 83987609748.26.0CAB338
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0DE03180005
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 00:41:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=alAETZu9;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760229713;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TbPiPr4v+tNnfGsd/T5+fk/qepklVVg1akCeQzWqFsk=;
	b=fqTAupjvIIp+6VjTnaESlY82CTs0PQuyD4fgxaN6aqqhc47dWGzkTVHnU6qbzA/Dbtd3CG
	P9El12/CW+esD4GiaTHDrxf/oVOK99WscoKGVHGDA8UXM3c7PefYT8H1vtDmsdGrzbRNwK
	Ba14rFs9Y+YMImqpbkmlcuqOmVGDK+c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=alAETZu9;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760229713; a=rsa-sha256;
	cv=none;
	b=3HeZgzZGcYQN3sr+1pfX6HXYTI1M5lkiAhlSHs+kfK+kvEtNvdU5YgXUL4ooDl8bVIxn+/
	ycEHBOWQ1zwucB1Gz/+D7AHg/CkraVFYVgrblsAZuS/HtKHQl1ddIfAVjaziJyWP7F+Tun
	dD9ypX37oJMcsIaWmkhGdw2tkyr+aME=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b3dbf11fa9eso532421666b.0
        for <linux-mm@kvack.org>; Sat, 11 Oct 2025 17:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760229711; x=1760834511; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbPiPr4v+tNnfGsd/T5+fk/qepklVVg1akCeQzWqFsk=;
        b=alAETZu9NzVYLIRwloYUylRSsdU8eglMCkDJdnLyoBT6idtMdcw5gRSZ55H2YEC5e0
         F1IXO84I2waBeoiwjrKCE8n7P+Ki6k3R3OkBTfeI1fTLhTedz7NZI8JVcsok20BV5EOj
         vxHpnvLeWl+1WJGFuC7fbgbyMXnN6WZZVvw2AvpaXmLaqZojRLKnyUp4IXsN4v0CH2fZ
         KkS4lLn8/KHxEBENm/bu3uqZ7Mf1O2e2u4JzEhGUGvErmPM7wxvn9/VIPK2wRU5193Hp
         u38D6QqAj798HPqEQPjykRmgNX7LEXU5rjC8AlN8nTqgrIUPGvbrDhTdQtuZaO4xamNQ
         3fzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760229711; x=1760834511;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TbPiPr4v+tNnfGsd/T5+fk/qepklVVg1akCeQzWqFsk=;
        b=G0AkFfwO4DcqNfhgWD0hCSjxCGxPKGmOIYaE40FZj6TFiWiW5Tjt651jEAnbShX7pg
         opLwGzmav0W5XD+i45ZNi8qpqobJ1vlAatxbWxh+ako6TknfQgBhSRR2i83kpHcXa3ET
         W1Cb51eqWgKn8elYrQBuqKfoJ4/D/rni/hIrQuhd0bihOo7F7qM0EymHTdwxsmqneTlg
         dLPYBDklH97ReifCXw+QRlyeDmnVfJip/d9cODLhIJ+sfvJddpEOwZZbGW+TSpyKFeu/
         z86V0NjZDv1x9Z4f32V6KUXauPprFE3jqJSv7x7s3rZ90qRfLXy0W5vvBZ2ONvA6cdpK
         3ZIA==
X-Forwarded-Encrypted: i=1; AJvYcCWaM2FiLYnuB25FBRlAoH2IlhWgJDQUID2BQWRVAj1I0hBnHtwfpmub1TnhIJ7o2yTreUdUhtH31Q==@kvack.org
X-Gm-Message-State: AOJu0YzMAoeaFpm5CQ/X/Nj9XLBHzON6lg/3A7iWxDKEicKUZx6Iz2pf
	hR2/vFu3OszWIMcqU0QUoowYjrqTYtg34fw7ZNunDyy8s0kAZz6xE6Mm
X-Gm-Gg: ASbGncsUCZO5FMRzD8iE/OP1SbtTyZk8RccA7jSsuCEY7YCe6DgYHzOH5U3h523ryi9
	uhwSxLZNPgKxXwtBNtvcjR/NSC68/u6gn+cPZURRjp/7qe1TOernpNNDA6ZlUO7T46jOa8QN8GX
	50WwCS/UAj4vzo7cHhONgIU/Z2e+y3Af+CeW9McSPfYzOFIoDhDvUGnNaXdGLCIGZHySHi2LFYZ
	fHO2TZCYXIBOMdffUOETmgZGSFXPrm76b59cX6LwV66DraSDAncYHxVD3JBE6LJwYbUd2+FowmI
	U2qtKI3W8MlBR4ix5yftM7ymRJrGwZG3LQlFEekulI0i7f+LNHQSWGdOs2XKrAhShtJk0zfxFHc
	3OKPWSkVhOpKnlWuAH2F+ygvLBDiHMyzGUnXiH9R5
X-Google-Smtp-Source: AGHT+IF2dF7uUP71zJe0AxIJHcNbD6vVscz6n/gJk2c5+tQVcfEKjcPR39Xn8LvDwnX+VoFZq//T9A==
X-Received: by 2002:a17:907:948d:b0:b3f:294c:2467 with SMTP id a640c23a62f3a-b50aa79397dmr1784338766b.10.1760229711049;
        Sat, 11 Oct 2025 17:41:51 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d65d6994sm605672666b.28.2025.10.11.17.41.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 11 Oct 2025 17:41:50 -0700 (PDT)
Date: Sun, 12 Oct 2025 00:41:50 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
	kernel@pankajraghav.com,
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
	mcgrof@kernel.org, nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Message-ID: <20251012004150.sujjmfkleibhvlxl@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251010173906.3128789-1-ziy@nvidia.com>
 <20251010173906.3128789-2-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010173906.3128789-2-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: g4zjxqbj4zsc7bw4u7eo1bsmmpt4979r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0DE03180005
X-HE-Tag: 1760229712-147539
X-HE-Meta: U2FsdGVkX1+V0DPYW6iGl1EGTipZlNNsDSjYT7P5tZf8WoW/sR+g2lbGo0sVpEm08+M0sEmlUD+8Nkb2h2xFk0iWMl3HUEa2MGpsIM0mHs/JCsYm8fwtjSrm5SamJWPpQmEMbrkC9iq0FUoailLGLDAxEr/euLWpglUK01NrpEMftv+rEKkBIAP3f33OCiujK2/qfFr/AeQHdq1+14zXl7x3VOkKOw2ei1PgHWH9Xnvf2/eTqaEKF/8lOB8Imhtxfk6BnqvxUnRAqOrHvNDN8FTHH5Exgaaimr1uZexD8H3R69Xb0slU186HqN97WJEfovckob0nQqfIUR0bF0JsKNTKAknlYvp55M+zIRIeTBzDk397VetHZIP12elmDrOMnO3H4SrJCLYzcZceR62s7cxRKdbPSQYOUgNlcg/aDHYllPr8jkIR5H8d0k4CGsZppsyP5U9gubZFqS8nXQuB+RkjL/W6eACDy6zNnRa+hv0ToBjxAChRZ65l/85lOtLuUqqI2OJ+SI4aRoAvxzmA2v95+BhvNzB2TNKx8wYoP4JrqLAgxxAHoBkogvmfQo8OAza3lVW9KCxsLxbvv3u8UC3y7gY7kw8HREwIVDWCxEFvgG5f5TfuUR3ECJ9z7UR3unMhjRm8h/HZpcLXUCLJf+sHOcJwcTrnsXUtuuHraRxiTWkcoDTdmD1wngK2OK36QsmSbf7mFbFoHRJj/CaU0sJHQK9LAbdFwiVJ5izD7d8c/BwV0vYVE1EzPFJuqAiCsT5BXYtQASuc9S60AXQwf58Hluq0C5C39eMXISdZP5NcebHJ+HA8Nx5Tg2n6MYbSbHUE3kYYvnKkKO+PgVH5Bi18UmXcWuIKtzbFzCvjltPnGe2pEg/XhSTi79f92dJHq4sFHrXe7Xl8yX1rwB/FfBLJ6n0GR+bCmm3+a5VeL+NH1HT7/fqwViV6KY2pCA7bWcsPdgcrbWkiAJjQegu
 +4lAi3kr
 eLsikvOAbZBdpuVHNtc4jqpZPoTlVjwwYxzV1zUi9fA6ltg6pVgetU2O06Weay7FKwnXS0jK9pea39sUXpJrqlLIIDLaT8BhHojIo3skCz5O2Dw62gpM2pKnl8sNu9OprU/GvU5tD6x350g5oCUdMV52vTwPcUxBJgkDn9uiY4E56W6NHboDrTALTuRmy+smPQd4HlnfqNQYEU+uBaYzp6Df5PngDL3xEI0jhqpC6nMutF+c8SdmJjEL3xYam3aO8cOpZvJesTjZ8a2+vcd86SzulbJCCPHlMrOfakOxkERR7kLJ7uycsWcev3j6fCuRVWxRrYcxUeO5lnH17+VSg0giMbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 01:39:05PM -0400, Zi Yan wrote:
>Page cache folios from a file system that support large block size (LBS)
>can have minimal folio order greater than 0, thus a high order folio might
>not be able to be split down to order-0. Commit e220917fa507 ("mm: split a
>folio in minimum folio order chunks") bumps the target order of
>split_huge_page*() to the minimum allowed order when splitting a LBS folio.
>This causes confusion for some split_huge_page*() callers like memory
>failure handling code, since they expect after-split folios all have
>order-0 when split succeeds but in really get min_order_for_split() order
>folios.
>
>Fix it by failing a split if the folio cannot be split to the target order.
>
>Fixes: e220917fa507 ("mm: split a folio in minimum folio order chunks")
>[The test poisons LBS folios, which cannot be split to order-0 folios, and
>also tries to poison all memory. The non split LBS folios take more memory
>than the test anticipated, leading to OOM. The patch fixed the kernel
>warning and the test needs some change to avoid OOM.]
>Reported-by: syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com
>Closes: https://lore.kernel.org/all/68d2c943.a70a0220.1b52b.02b3.GAE@google.com/
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> include/linux/huge_mm.h | 28 +++++-----------------------
> mm/huge_memory.c        |  9 +--------
> mm/truncate.c           |  6 ++++--
> 3 files changed, 10 insertions(+), 33 deletions(-)
>
>diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>index 8eec7a2a977b..9950cda1526a 100644
>--- a/include/linux/huge_mm.h
>+++ b/include/linux/huge_mm.h
>@@ -394,34 +394,16 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
>  * Return: 0: split is successful, otherwise split failed.
>  */

It is better to update the document of try_folio_split()

> static inline int try_folio_split(struct folio *folio, struct page *page,
>-		struct list_head *list)
>+		struct list_head *list, unsigned int order)
> {
>-	int ret = min_order_for_split(folio);
>-
>-	if (ret < 0)
>-		return ret;
>-
>-	if (!non_uniform_split_supported(folio, 0, false))
>+	if (!non_uniform_split_supported(folio, order, false))
> 		return split_huge_page_to_list_to_order(&folio->page, list,
>-				ret);
>-	return folio_split(folio, ret, page, list);
>+				order);
>+	return folio_split(folio, order, page, list);
> }

-- 
Wei Yang
Help you, Help me

