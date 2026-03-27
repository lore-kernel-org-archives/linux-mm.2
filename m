Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A05D810F284D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77A26B0096; Fri, 27 Mar 2026 12:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FEF6B00A0; Fri, 27 Mar 2026 12:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65A36B00A1; Fri, 27 Mar 2026 12:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9536D6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:36:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 490971B6FFA
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:36:00 +0000 (UTC)
X-FDA: 84592394880.15.4AA5C6C
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 63CF7180019
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:35:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WmGbEwb9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774629358; a=rsa-sha256;
	cv=none;
	b=zul0vAPDRG60fF6WLm4PbvgxGEZxpjz+sI40LOzitwbKYr6XUWJxoBm18ZWjqaoetPyV2o
	j5G2CzPSL/ia+Jv9pRb2Sf4qXkdYRosGQlM7+08I2IWNmni4LqtBmNJ50EVHX9dMFfEJMe
	4+Wm1SOFueAuq3U1gIwGQ4iyquUgxSA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WmGbEwb9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774629358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cggqE8m4apbWV5U3IAU0wJMWI3EIoJebO/B0glalUlg=;
	b=X6R1SA8SBksaPVSGe5amoH1dP/rPC/KyYNBo57BH3dnfLkuEt1VETR9CuZFAR03/u+ty8F
	trtsh628QfUMa7JLjOWtKqsdZKJLR0WeMgsjw/N7Kz2+/OHONG9uxQP2CJi6XsfXGjfw5Q
	26GOsetxs+Ln4UDnUpmAWElTCPxCUzI=
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-408778a8ec4so1434635fac.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774629357; x=1775234157; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cggqE8m4apbWV5U3IAU0wJMWI3EIoJebO/B0glalUlg=;
        b=WmGbEwb9+9LiaKksHzyvNhfpt4cIsAgVmmz3QsnvrRwtJ9vcbWKuddWRCbzPk/L6aO
         7t6XY0XNZcfRyxjQ/bp4TLVrOTK7jA+Y9tZvG1WIXfGOitx5d+d57Aih0fI+BYwdSKlL
         EAbg8lKO3Wn3bXITv+z7MD4oPjMxbw9XgLAtoG+3RrVU3gnmqpOnyymOkPQVXCA5UxdK
         o7OgXddvdrMfxwB/Fp9lX5pbhaJstdj0jSfKOIEhWlS9wt7dI50cE/oz8x40fb6gI3M6
         aIUHgD48BW6Z9NaECkUI/uXzck7oKeAPn4W8aUoRk07GdXMIVhgNM6sCT4VEYQIpe3VE
         FbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774629357; x=1775234157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cggqE8m4apbWV5U3IAU0wJMWI3EIoJebO/B0glalUlg=;
        b=nkSsV7hzR9KtQZ4pMM001XQkRH3GHDt4jgZduL84QjlZFl/gh1Rija26/H4sfOTL1D
         cUCi9bjRzmtjbk3FD3/KEtR6ald8bdbzV1vopHu3PBvjsD4r8tHD0f5nWEWncWUtfC7z
         8UgOXJZIhHOQzMvnokLc9gGJtbtO4EpROx36TsyAYBcxAbdVamb3TqgJR8RFxppujHq1
         7ZYA4SfHG6kipKHqzsxUhHq/02Jel7ijg+PC041iGK2APnD9sTYnm7R8jOAMiKINj4jE
         GvJuFr49B9rOMGceCniOiH4NrRVA8bCLc/cyDzuQ7IYCpzt33BuCNfAzpJiP14SJab3d
         t9HQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFxHHil+TJi0IDZQ0pMwYQnhdCJXs80DnuKpIJcLAdkoc1OIE3xVKFmHzVFvtAAXUrlEYOgO2Kgw==@kvack.org
X-Gm-Message-State: AOJu0YyEpIFNdGmib+p3tAy4+SRpUF3ZMQ57wFvncBIeNScv/LTN9jk9
	G1bdso6SIU8WU2AdAug3W6oKSN/71a688sDNfpI9He2sdolz+Zn8Okve
X-Gm-Gg: ATEYQzyrlqIeAEiVG5BZJXHJVctNs/eVd4whVrDB5/YavZnluUIBa6CFWvIG+DxYt2Z
	JPwB9amWjT97KwJVhRcnZ5xCkTTi1awoUSsoRukcxlB7wiIe/B1X2/PO3IEC68EUpdVTJviXPjJ
	EVP9YGBr9xmJjYzvGlyXNXt+NCOqRVLg14npdCffLn+FLcUnLm4xkWwn8rZr5ruwJ+uFCmWxelA
	n0GA7ASiH7gVFQiUewpW/1sNjQvdoGF/RXPpGjDvhqKlpnK0g7Ig2LyTT/YVlQVRODd9JQiwMMh
	YAQf48jdVpCKMbbkTmlD4+YYE/Xi0PmJTech0rBXGAyoOI3aRv3nU9kfy0GZcimWKcF042MHjsz
	ZoypSW6cC933stdIiUSCAByaU23BrByq/P1zvzOA/t1smQ/sewr3x/57tZkxnVynI1pUnMoZ7XD
	vPI+hVvQ1CXXaX6N+qG20MGw==
X-Received: by 2002:a05:6870:1799:b0:41c:1bc2:d219 with SMTP id 586e51a60fabf-41cec35946emr1519816fac.37.1774629357141;
        Fri, 27 Mar 2026 09:35:57 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41cc775b12dsm5303329fac.3.2026.03.27.09.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 09:35:56 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>,
	david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH] mm/memory_hotplug: maintain N_NORMAL_MEMORY during hotplug
Date: Fri, 27 Mar 2026 09:35:54 -0700
Message-ID: <20260327163554.42487-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <2356614e-d9b8-4639-8e2a-96c5e4eaef61@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p9g5fyzdtg494c5ozno1pc41bwapf38g
X-Rspamd-Queue-Id: 63CF7180019
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774629358-949180
X-HE-Meta: U2FsdGVkX18VsQ/QW9UXpBEE6O800aKEutvbdswZQKwV911yAONsub8bJFWkCfStAX+KKZA9a65WVCGk6u8YujCcjPdIiIHHe3jois74EF4SFCuqe0wWlLj6rBzMXiRXGAvfz/IwFO9DQIITCMxfQYHgsTYzcobLje3UBCpFzV9Sxm+0kKtfHr+9JaSpDSgSnjp9ABxsye1ryXMLjGfwHkGWvo6CN07x8Leg+fIjPFNh6SVKC/hRB0D5Nqx91/NDD5dEtRCW6S/jZ/18QIw+lXgsxjXj2w/aSbviK+vrD1JQnnped6Qe6OIiER3pbV1p1pXYbhlUao9hEjEgfy7kSj8/UX0BXcDt+ZBLcLY3o9QNwa59uXMU0iyfW4kQ7MkJvFvxHixqJjOVLIWh0OZ4EUtbI+i8/w40EJGTO+ca2WZBPkzB4nc1OjGXOkgIj1b/Xt3TcPYlvRzHJ+dp7MM6/pAZJaJi3DF2d6pqwnxcp3J9S9AfvlJ614XL4ZrR1oixDpAp95JoGAAolCHMhNqwv0gEWIV6DqzfYw/5XeNtPw0LBvSFhtYPx8G9/e9Rf6O9EHf/HY8UBFqw51zm1mScIwxopDV60fGveb/09eksErG/9cwRF/IiXIJ42tB+B6t80TfUO8++Y8T2ERd+erQOj+mNYImGBxvAMQY/zorf2NM2waX1r068WNEJN9tXs7J0lhzufBvskSx6LRJOHLIDjz+xq6/z5/FhsYgiSzwNISfC225Rysep9EhLJSzvfIKLRVF+PQEGSh7XuRwOhI3U1x6uFiGwb8PBheeeEQPtjTvna9lZ1aymwhzgfdUxbD60dqomIejUhvXSd+SU0oP4Qam6UCTOTe65mW85PTRtN7l0doX2hKums4zoiE9AP9Qt2tYHSzuz/+i3v1izjoXgthXJ+SeRDFowKdufmHw6mG+EUJNdwwXJcHcxBk1E/sjcNFruqDjln1ZMEP3nlvY
 m/fy4R6u
 2KzJOrYxtw2UMxEv1rAOee+bh6Dcv4H200EXIhVIj1/W0BCIQ94D4+LmbeyLEDnHWWBBBLsOLrM2Hf5upvMBrmf2f+7gZxL429BeW0sUGTn2fMO8kAZ6OlLicMH67Uuk+1IVsQtnRH5Y/0UArIjoO6shj3sIrS8D2VYeqmuCUXOiCYS3FNnw+/+Pz0LCpfEJbFMd1xVmJvfqh8jSqm9bt4Th7yx/+tYZ1ecuB5gRfZvvBPJdQne3Dvv288jLtdDKzgQKzb791GiSWTZFdmK0dCb3KZ8VgQHfHWZwq1+kt8123Bc/Pgzqw3FuwurxMW5z6ze4KP1E0CXsE7eqA0UgnQy6bh5oo+8EJlDBIQK2megQEv6mATDDt33t3rb0JqxZgeNji04k1sd4xQCaS6TQ4P0rTVizuewRwt6PvpccT8kz9dX04tqfnrkw1Hy6KHqqUyk4Ca7fofJ+skThQ00qz8MB02GjiVJETNZaouXn7jARRe202JtJ3pN1U5MGwu9P8yciONvSzpiu+pUFuw23U5eWHYXO41W9TFQBaxeUIlJYtlsu2pXEZ1nI0citxezHo/ly0fJZznJuBytM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 15:44:18 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> On 3/27/26 15:38, Joshua Hahn wrote:
> > On Fri, 27 Mar 2026 20:42:47 +0800 Hao Li <hao.li@linux.dev> wrote:
> > 
> > Hello Hao,
> > 
> > I hope you are doing well, thank you for the patch!
> > 
> >> N_NORMAL_MEMORY is initialized from zone population at boot, but memory
> >> hotplug currently only updates N_MEMORY. As a result, a node that gains
> >> normal memory via hotplug can remain invisible to users iterating over
> >> N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
> >> incorrectly marked as such.
> > 
> > The second part feels more important than the second part, doing a quick
> > glance through the code I can see a few N_NORMAL_MEMORY iterators that
> 
> Note in practice it's unlikely that a node would hotplug normal memory,
> start using it, and then manage to successfully hotremove it, due to
> unmovable allocations. Most likely only ZONE_MOVABLE memory can get hotremoved.

Hello Vlastimil! I hope you are doing well.

Yup, makes sense : -)

> > are in some hot paths like shrink_memcg. Iterating over nodes that don't
> > contain any NORMAL memory seems like an inefficiency rather than a bug
> > though. 
> 
> Ignoring nodes that have normal memory, just because it was hotplugged, will
> result also just in some form of inefficiency, or can the consequences be worse?

Aaaahh yeah, seems like ignoring the hotplugged normal memory would be a bigger
problem. struct zswap_entries allocated from slab allocator on hotplugged
nodes would just get ignored by shrink_memcg, seems like a much bigger
issue than iterating through extra nodes :P thanks for calling this out.

> >> Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
> >> offline_pages(). Set the bit when a node that currently lacks normal
> >> memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
> >> offlining removes the last present pages from zones <= ZONE_NORMAL.
> >> 
> >> This restores the intended semantics without bringing back the old
> >> status_change_nid_normal notifier plumbing which was removed in
> >> 8d2882a8edb8.
> 
> But commit 8d2882a8edb8 didn't introduce the current state, or did it?

I don't mean to speak on Hao's behalf, but as far as I can tell I think this
would have been the commit to introduce the state, since 
node_states_check_changes_online would set status_change_nid_normal to nid,
then nodes_states_set_node would come around and set it to N_NORMAL_MEMORY.
Maybe I'm missing something? :0

Thanks for the reply, Vlastimil. I hope you have a great day : -)
Joshua

