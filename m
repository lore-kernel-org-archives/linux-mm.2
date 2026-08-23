Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63C37C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 08:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31156B0095; Sun, 23 Aug 2026 04:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1486B009B; Sun, 23 Aug 2026 04:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD05F6B009D; Sun, 23 Aug 2026 04:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91D396B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 04:53:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06F434028D
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:53:46 +0000 (UTC)
X-FDA: 85131921252.05.627810C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 29AD9140002
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:53:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FQltGN6o;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787475224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0f+XvyVzGo9kMNvrABtj/l2bJUZ99gbFL2WjKcOBjPE=;
	b=J0aHwRcV60xCweYvWCn4MLr75ComXLxyC+JtbTBRLen220YPx1Lg4KjaRsime4iFKzOukT
	4x4TdaBpK7hpUO+hvvyFhLxGlyrEdNDbW8DKjnVFRx8GwGwx4RnXe34PoirYQz/hX2LY7E
	fhc+Hkn/GKAuYBX+RlE+FH/PPTxIuVg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FQltGN6o;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787475224;
	b=MaE7uSlQ8Oy33RHVKCC48alalX6MlCYm+BCrJXXb1ezoVSPpGt7esyDKgE9Ovzidab5ujT
	HLovGPpKKBAydfa3zj57PPdU1l4n3gG6zb+37wpwV/jFs+J0DyVFGvaYNbo/sfZDjewiJ5
	dTfP7FYQvR679KERaeLWDLV7Ty6UYJY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D240441FD
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A1F1F0155E
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787475223;
	bh=0f+XvyVzGo9kMNvrABtj/l2bJUZ99gbFL2WjKcOBjPE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FQltGN6o/ShI8Zdp7Q55ej14VUR7ttj5JmwATYPcFVrmdvj4G6MhuBes3RU97BmR4
	 8VdtoTKmkwgCz1z7YTXcD2bBxVNINdvr0VB7KbxNjtzmaEJ+BL2KpGjy63UZx+OzsJ
	 W3s8Sr4iRe4I8IoKYRYCF9xQpLoxMVl6gAI2IJzK/P+Bo/03hxODihD/IWoz9rxZ3j
	 o4/tNgbCD7HigNwW7DB7F9lkJOctYbXdtaFVAFBhT8WLNnu1RG0ixDpV8jlceBK9ZQ
	 kXYLqMe2YEz7QWBu2FsB4zD9mpyPvGwWST6m2EP3p0sF5F0Tba4a7F1v49sMvhCIzK
	 5fPFi5OOzO6ug==
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-527e352a167so15339441cf.1
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 01:53:42 -0700 (PDT)
X-Gm-Message-State: AFuF++lOyyaF1xSibUofYQQrcT3PVTKkTQ/qERwFgSbJAzXhEbmKaho0
	K50sZYPsl6viknhYaOB0cfNRF13iA7TRbsi9InwuNp6kbUx/nZAC0mPDqgyOJUO21qE2C1Cn378
	ITFHiAofxS0aerIUo81UHUVFtW8/YYSE=
X-Received: by 2002:a05:622a:1191:b0:52d:41d0:89e8 with SMTP id
 d75a77b69052e-52df5a7485amr165040561cf.33.1787475222255; Sun, 23 Aug 2026
 01:53:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com> <20260821-swap-thp-cleanup-v3-1-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-1-9b43f5163238@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 23 Aug 2026 16:53:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y5AA_KrV2t1bFAeTEpDE6JJ+jG3bt0-+W2LNJdyub2cA@mail.gmail.com>
X-Gm-Features: AcwNN1XPehqESuSOMNYualm7T8tzCedNsdlHqEWcaXNnXQwOu-vDMOY9zjbscE4
Message-ID: <CAGsJ_4y5AA_KrV2t1bFAeTEpDE6JJ+jG3bt0-+W2LNJdyub2cA@mail.gmail.com>
Subject: Re: [PATCH v3 01/18] mm/swap: fix off-by-one in swap cache replace
 sanity check
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: spewirrcr1gzkajoq86j175t1m6xsms5
X-Rspamd-Queue-Id: 29AD9140002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787475224-523470
X-HE-Meta: U2FsdGVkX19NsHdvhsDDsFKY0FZm/1WrYMZjPwW/1Tp9aQUXd8Jh90n3eyX1sMkpv+6/sgyeU9FrxUVHIRaynBIJMIrBovmvB+rembP2GkdF0PNCh+zIXlslkYVBJ6Qo4R7DToBmrCoV4TovNpmBZu/NwSU20+PMhhElMlqkh+FQ5+Azs3kIbx2CogR8abAG3egtks2GtvtQHF7CwvJ13D7k8zf2qtoaGSDJVttvuVNkT+OHgRDgC7RS+jjE+lIlCuWYKAyurA1L7YJ59NUpHW1cSpGpRsHucOrWnD9Josezz5foPdw+euVD3k3CJG9smeQfG8JeJwoh0JRGTljfCsFS3PoKoH5OUhVQsQ6YFoZpZeP+chziR65LhZHm8Iyx8LGDnaTReagSBnhHMzbW0hfy4hQZFIyKLvryYhHkciRNug1DjHk71ekQRCE46qjlCmyS/uXQ+mvnBZZp5AV1pDaA0WznLVeIH+JV0gD0TAsOeQjH1NrmczyJvXUWg+Qx4EEcdFEjI6+vVO9UDqO5eu0tmI5LLH4xl7VkWXK23lSs0QsoW/q5ry2seWNzmpzPez5U52/MHBTMzFaj05pxIgfIkTu+nO/IDH3G1/J4IjwZbxaOm9LYk1mGEjuEgMpykQ/E20rjCv2tXcVJkoEHnjIFEalCyKgUmCIKorzsVVLqSvSdHYfGvWY4YOdJDrhIpypRgMnmwn3K3LkzqbVbu8HrrOSkmEjs+HUftUwj25G00rnA+6gHiG3SFL9RgkYf6b4acMn7kBhUYXUSTPkVuvvi9z5PO7IEZ8C30oT2/5tUYNWvhnK56sCuARTbw/9y5TKW2VO83JVrTS/f03yduRpNKBL8SaqZKy45Bv99gD4hQnEeVbpOorWFMpOPOQ3nI41arM9tup50csMlvf7HogJCgPOPj+8dUFmfzDa1/lmsnp8K4xDwXWrNxX+JPpK8CHpChDs3yS93jziq7Qc
 47+WFaq9
 xDozJG4OgvkEOE/5LomjVf9TH+rmfFRb3PurJUcT7DvSmyWPyImMRU40x4aPfhYDys40y6s5NslVlBFUKZ2ys9SCauLbwVnao1qXA4qRNxFMjfaEXCWSF6Vz0c1gWH3UB1FO2nYiQjGT27o5xrZ8EUIKhaIX0YPiO6kPEIsHw0Jr/RWCRIijcZ/65oGoiay/8eIvn5ewMnRxWHB9UAPVvko+V4oOqnPmWt2qDvyyg5Fu3lu0bdIC7DJb9lCcA7JCoeTs73No2LFcTNIO71ILLy+5Fs/6OHa0gAh+BnoIFqxCSqAmskMVt6LXCKli6jhDsGfAq96xSx5xCtr+c7kGhGK1c58wyltWsvzx9sFsqt75aTYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 2:55=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The DEBUG_VM sanity check in __swap_cache_replace_folio() iterates
> the old folio's range with "while (ci_off++ < ci_end)", so the loop
> body runs on the already-incremented offset: the first entry is
> skipped and one entry past the range is read.  For a folio split
> that entry belongs to the first after-split folio and was just
> repointed by the replacement loop above, so the check would warn
> spuriously whenever sub-folio orders differ from the head folio's,
> as non-uniform swapcache splits now do.
>
> Use the same do-while pattern as the replacement loop.
>
> Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and=
 switch API")
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM, thanks!

Reviewed-by: Barry Song <baohua@kernel.org>

