Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEB4CCF9E5
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 04:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D198E011F; Thu, 30 Oct 2025 00:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D7A8E0112; Thu, 30 Oct 2025 00:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C5E8E011F; Thu, 30 Oct 2025 00:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 696428E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:00:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 014331605C4
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:00:41 +0000 (UTC)
X-FDA: 84053429124.23.F5C96F8
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 17094100009
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 04:00:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761796840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V7UkojjVw8iM7ylju2DINYd3+c72O+36Bo2eWT6QfKQ=;
	b=aPAXSxacsc4mxmM6qt4R4ApHSI/8mZJ3MbCxykyAAQnyWEJyC6xR9MYjkwfzvntABrN0Po
	7eEUGe1lhZH83q91udK68ZzrWkkGm1MGVPZ/Hz2GzDcnV/zbgY2SFYETk/Rm1vpuTMXbOo
	ZsNOXV7ZFnpbq2S/D6qrDvJGzU7tGFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761796840; a=rsa-sha256;
	cv=none;
	b=2DrVHE5M9GtYQ2JIbHHJXhgTlAOdG66kjWLmErtHM1b1sWFsZoFBb/tHWR+ayfXwTzgCES
	k/b8UOTTfeGJjdC3kBoCL8lwx3GiYoLTjdcyzCi+u0onH0akjzN9ZN6Iw1UmY5NHxChSSI
	1Zo0y3hfyPDmGa5QN5Zm98g2aFXSJQM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine)
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-88f2b29b651so63355285a.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:00:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761796839; x=1762401639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V7UkojjVw8iM7ylju2DINYd3+c72O+36Bo2eWT6QfKQ=;
        b=RBwAKvKp+NDP6v2QMpDT0LB4TWEsI1q4jYXTLoX+XTP6mVzhBq3KT93qVm5ceEzixz
         mSCPk9ma5zQbvpZKIF9JIX/dAcedC/tv2BcA0lJmFbr1zniB9l8xLoERqGGEe3ApS4u/
         kBqPJASTh8SFie89H4P1snFIlN4iHi6o1lEoA6CACUAZpwg1szDLFs7g/ttFlivTiedW
         5Yu92LUeFD76qnlFqhQ0N0rGQIHsKLDv6uZGtDapQkP5SJQ1mR4rlY9cEvIRAvGoTIQs
         omldRIB7P0vIsMKfdCcixsM0/BailJyiKzR7XeOXVv93Le70gZOb31JI/012XsObesfC
         nzMw==
X-Forwarded-Encrypted: i=1; AJvYcCUm4pLF/p26wYHXQ70FxV/S3Hv63JGcdfSjLB4AXK4tDpIF/aMVU3Ht4JGO+V3YixkuiqviO+Rhww==@kvack.org
X-Gm-Message-State: AOJu0YyllApli9Y79vgf5EK+J60jzMTScrPJ5r2u1T1+amHEHXPMMNLL
	twGZfnVTqrPJwaO1uvyDEZUOlPLRrKWrcunr9VoDq9dMd6ZCq6R3q9heyyS0hZv+OAAS8D2t3if
	wWiLmqZqi+iVTs/eHRR6a1jHe/C3leB4=
X-Gm-Gg: ASbGncv7w+8q3V5hc3AedUZJfWzYLEm9J0NtCTB2HppChA8uK7DFTvnyuGRkGZx1yPU
	ITJeQVq+bzZPH1jF1KiTKCstDZD2o5zh2t+E30FYpAWq0Z9ksLSJvt6mvLOwr4e1kzYYwFvRMzy
	mn6BRs1asluowtunZYe58f8jeBeUEDO1xxtK+VPVKdjnO1EHvErnnlzyJrfsIhsbU47TadfvTJl
	/ge+if/YsMgu3221LpOWdbWtqUnltgn7fx5CcbLxlRGKJUlrWmDJfRUH0aGrcCPAWlwiEjAtyWh
	2kj8dnZMzUXFgkd0UbyUxG2KFXQ=
X-Google-Smtp-Source: AGHT+IHKRNW9sNDGCaX61D0IJSW//S9X5fcnVpi2KVH8DIVv8SCmHI0Nvj5CkCvxgW//clbJrEgQFB4JLZk0JktmY2M=
X-Received: by 2002:a05:620a:3915:b0:811:33d6:1aca with SMTP id
 af79cd13be357-8a8e34d3881mr764987085a.1.1761796838904; Wed, 29 Oct 2025
 21:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <20251030014020.475659-1-ziy@nvidia.com> <20251030014020.475659-3-ziy@nvidia.com>
In-Reply-To: <20251030014020.475659-3-ziy@nvidia.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 30 Oct 2025 12:00:27 +0800
X-Gm-Features: AWmQ_bmug-ryKCzBbavCMxdeQ4VhZPQSA41Fu9mlb8w6XWO_CcoeHvXWOnYu5Oo
Message-ID: <CAGsJ_4xWOhG5dfVZ2XmmVcXDPicRKiBB__=3W6Z9umXjn4M-Ww@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm/memory-failure: improve large block size folio handling.
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com, 
	kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org, 
	nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 93oqys6kqs3xkoz5kyjtef1gy6e989gz
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspamd-Queue-Id: 17094100009
X-Rspam: Yes
X-HE-Tag: 1761796839-658171
X-HE-Meta: U2FsdGVkX18Eu4Jw6RkxqVXQganUvAZHfsFyhnQuwdhti1FF96SivKfsbbIRmVOcvUVhL6vdapKMkFnKVCjvoHyzJhFKAgP7zAkUJW2JYBAprJlRaS4hUufQgFaNszVYFdZxjXCiKoacBb1bLrgmKv1D4lFo5qnVlSDoFvK9DCBP3ain7Hy/4/M4mktmNAVkQzotRPq1/vsMBubZ5Gvuc748vh1cfvcFHkI5+lwzW3HWC6G19npPogjH3lWR1z6XQe7VCdhPRX62Fvvd2NgWqOSztKkT9oKTaqzhZITUgdk2RRh9x7/gWuIhQ6hPrn8YqbVdeRcN+hBCNjemkCG//qruNDoCthLbD0SLdbZ5QEn25g387tly5En7lRRJkr/neGzZWC5o8hU2151Gn9cCyXpuz9sYrfTb3Tt7hFMOg1Nhk1CA+gJL0Yo4s8307uTI6qkTATpes3NUGHUyy5YqdpJZJWJnnvXbHdx7OHczDdkooaGiBss2M3SCffpJwyYFXLGxetK+D5qXP8vYVvF3eismYA4RBzjEvanaoTuMmG80NXNNKo3S4wncF1fkb9aRU1nuiIhRrnR8XLxVFZcYmBZ0B6ZDqGZqeJ3DoDhebL/lzOK/bhIA/Zu2HmyUa13Pjyvia3wd1ZpPhCjjp2XlCHT493kw4F08jsRCK7p7E0V28Tgv9pvUtCi81SNsC43oWTpkraaqxtUF8KajRodYLzEuEs5i9NAos0XQKwnJNvQRpFKT3onQ28jWiWJL/ke0lCUbQNAU3CvqPbK4XmeGVCdvK+Q7ViZ7TNTiCJXDWIG9oXNJeVuMy2aNBxha3tdx/E41rFKCDjdfQnvSZvs+Af0iQYH4m4f7mylgi2LrOUZS+8rhFpcGV/8sIkAdniIxTldydy+necRdlhTL1BtoO2nRr554GJMIcaWi2FNJzRmEp0J0bh+NecAHXcwHeiKqRFQ/xvWZrHi7uEPLnwT
 lQLq+wr4
 EK3bSR4Db178lRvWncT9x/oRRIr1Q/a08Isyj4efCA+jFoLbkwVEnAWQqWhaMJwwWVqH8ZbfK08Omr5hzlYpLEie89uJJRqzkzwp/Hh9LNjgf2TzI6NS+uZLCdBA1rmk4UmzrCNAq9vPSlodoJK3Evgfa7tRbQ4EyV/JB1bUgfzVwF3OGLDYGXlXZ0xqINYpBPrQ0/O40CJNT94/1qJzTFaF9THYSp+QcrDewybzjmEMj9zgR7MQS2l8ZWhnTr/MFCZYbBdJJiXOdKpNJbtuPYdYmhDkVOSw4mQaZRQstXWAr/z0qnNxcFcHQ3+IGfXEX0eb7arLXYHaeVnWwZiAyDJExQPbmviT0xLWpMBAa57MyOclfQlyvnBcA6Wq44nAxuQHpoLOuoBuLvCaN5wRlERSPR8sC75Bw1u+kqbKqvROihsD3EyHnJaH9HJdcYNpP/GsaztJ89I93iVu7yVrYPqpqVt7isq5a3LI5Q7qzDKMajaZd+t/2HMXtWR6r3BENrwQx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 9:40=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> Large block size (LBS) folios cannot be split to order-0 folios but
> min_order_for_folio(). Current split fails directly, but that is not
> optimal. Split the folio to min_order_for_folio(), so that, after split,
> only the folio containing the poisoned page becomes unusable instead.
>
> For soft offline, do not split the large folio if its min_order_for_folio=
()
> is not 0. Since the folio is still accessible from userspace and prematur=
e
> split might lead to potential performance loss.
>
> Suggested-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/memory-failure.c | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index f698df156bf8..acc35c881547 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
...
> @@ -2294,7 +2298,16 @@ int memory_failure(unsigned long pfn, int flags)
>                  * page is a valid handlable page.
>                  */
>                 folio_set_has_hwpoisoned(folio);
> -               if (try_to_split_thp_page(p, false) < 0) {
> +               err =3D try_to_split_thp_page(p, new_order, /* release=3D=
 */ false);
> +               /*
> +                * If splitting a folio to order-0 fails, kill the proces=
s.
> +                * Split the folio regardless to minimize unusable pages.
> +                * Because the memory failure code cannot handle large
> +                * folios, this split is always treated as if it failed.
> +                */
> +               if (err || new_order) {
> +                       /* get folio again in case the original one is sp=
lit */
> +                       folio =3D page_folio(p);

It=E2=80=99s a bit hard to follow that we implicitly use p to get its origi=
nal
folio for splitting in try_to_split_thp_page(), and then again use p to
get its new folio for kill_procs_now(). It might be more readable to move
try_to_split_thp_page() into a helper like try_to_split_folio(folio, =E2=80=
=A6),
so it=E2=80=99s explicit that we=E2=80=99re splitting a folio rather than a=
 page?

Thanks
Barry

