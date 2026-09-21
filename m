Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54885C982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595136B00E3; Sun, 20 Sep 2026 22:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56CA26B00F1; Sun, 20 Sep 2026 22:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA4B6B00F8; Sun, 20 Sep 2026 22:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 196E66B00E3
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:55:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9796B14050A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:55:24 +0000 (UTC)
X-FDA: 85236253368.15.6CE7B86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 144981C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:55:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZX+R7ln5;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789959323;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GcU0QGmFueS0jwckkv0xg7O1qozQrpTGoV36hRGJ0SM=;
	b=7nbhpzutV/i5ZaTq3PlbqStqhiOg4GgunI40NI1CkuPDP/Awq1hvkqA2G8psmenFxu6uLK
	XceQLXtBRhbRokwYPWOxYEyRAE9EHfSbpi7f+TFvW052wZpNJalnq/ZAZMxMlWRswCJ5FN
	2kffZenqn32q12pozeoEWtfqtHCY8vs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789959323;
	b=iLELW6yGEUrLDpRD7z5icKuQo31/rRvhmA5cJ7adG+VyFDJ/qK6DE/h6eGeilV6B+d7NDc
	jOOT1sUxxszbFo0WvkUPzdIfQK18KF0z+JR5M/4V/2Dz4HhwNlo8ZenIKVMx6L291X3ngH
	PlLNkRv/AbmjtlJ7n3tGVqHWrtA6An4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZX+R7ln5;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2257A600C8;
	Mon, 21 Sep 2026 02:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628971F000FF;
	Mon, 21 Sep 2026 02:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789959321;
	bh=GcU0QGmFueS0jwckkv0xg7O1qozQrpTGoV36hRGJ0SM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZX+R7ln5PpzgQjzjbLK5PtfF1EYpKw2srgRLcWDJ8MfkeuoE59zPv6evJeebMCr3g
	 jI/2p5UQhtDBXT98Vjf/uTXfig7pI+U94YppfWZFxlotwxw4kbLYA0YEblbSy/8d6V
	 akuH+gWTL3mEgdZygbKovtZ8XFvv5gHnmkCKqaq35xTUJbZ5DboVs7VlVMV8MpRRX/
	 8bNDdN92BhACbS3jr/V8IVlCdKhS3seF8ly10JcNwZbKMN7/C/wfJwm/1h0PoVyJXv
	 e8I+Lc8sKw8s96/y1036pNEO9ZnGxlEDIfdrrG2Qh1ZIqJR32d3uNwSKXLNZ447Rqe
	 K46dK1YgZSELQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 17/17] mm/page-flags: remove PG_private
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shakeel Butt" <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Liam
 R. Howlett" <liam@infradead.org>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNs?=
 =?utf-8?b?ZSk=?= <willy@infradead.org>, "Suren Baghdasaryan" <surenb@google.com>, "Nico
 Pache" <nico.pache@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Gregory
 Price" <gourry@gourry.net>, "Kairui Song" <kasong@tencent.com>, "David
 Hildenbrand" <david@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Lance Yang" <lance.yang@linux.dev>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Barry
 Song" <baohua@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Qi Zheng" <qi.zheng@linux.dev>, "Dev
 Jain" <dev.jain@arm.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Usama
 Arif" <usama.arif@linux.dev>, "Mike Rapoport" <rppt@kernel.org>
Cc: "Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, linux-mm@kvack.org, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, kexec@lists.infradead.org, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>, linux-doc@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Baoquan
 He" <baoquan.he@linux.dev>, linux-kernel@vger.kernel.org, "Dave Young" <ruirui.yang@linux.dev>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Shuah Khan" <skhan@linuxfoundation.org>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260920-remove-pg_private-v5-17-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-17-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 02:55:20 +0000
Message-Id: <20260921025520.628971F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fstx546ejx6aacdm9rfbk8a37hco7pa6
X-Rspamd-Queue-Id: 144981C0002
X-HE-Tag: 1789959322-125820
X-HE-Meta: U2FsdGVkX1+JHUQ55OuXLYG53jb2P/p53krvOO88kC+BNJuuDbcsz+T4lWz7dDidU9qLbISyvgcpgzujdYAIMliMEJzRqjXwf18ocRVct7gmyattAGyjAijK/IZneM5AyguMK5LEEzrfuHU1M8ENd7geMBy2cILTfrkJVSIEbUpyFr5tJz018suVn4olN8V0mP+ZVlPoyF08oIxveNXl/n3esciB7zdDb8qho95nCkWmNLz9wHoijGsjKg2R+ZK5l3je2WrSeNWsiyLSin23SUEUPNeqc6MLhYZTqfSeYwTcfW4BGjWuKhpFr4apvTCe7/lPC0HQ/W25wFVlQgNGH0+xhisLl8JSAq/qp4IDNaLvwVpCApkhsSKDn8Q7lIOYjT6yk52d/bnXH78mW++XOVhc38zHCGAEXJr+85ZLxJP3Ehz6iKrUVvR58X77F6nSb2FaBOFU04Xdv+GPXXEy+kZKkMrKp1b74J1Uc0fPK+OAW11mqapGl6miNaP65D1+dJfIVPGKa5pQ75yNVT4GOr0NUEFZtX3Nu2PVZxYZ1Bc4xixKUvtnsZmqqlRZ5kzyoweCBATBqNbjasZ7st9TQlLbEdQSDH5Wt/gGUJX8coX1WWMWFCWPnDOJv1SbcA4iu9gHqdgv4/mfXWbdzWwFlpv/+6JRIMtucCBDYqKM34WSIgPP6MIAA5qWgxL6SiT2cH0DxJcR/njN4UhzrtujRfioealL3SphzRQTIMr9k4/k8N/I6pX8Rt4EFxFEru8jzM/flJTGZ/kn7rHjlFCFRq2xR9lPx3m5ZGLeyBOKFNsasziBC3Z9Vts3D+ymtga/vEK+U6m5bvBY8F9gk7AZCfwILlgQTG9Mk3ifwi49QXMpZ7piMiQwmbt68VE41wGmIYMkNWuUWL1noJu4FT6QLLdhl1rEVYQrAdWNLFyoxtLPFUnInn1V4kCOAnuWuOiSg3pS3B4DCXZzMhGXfEE
 uZPNc+ts
 NjMOBlWXlDoPFbuC0+WYoo4ir7KHxR2UIlPwA9jQA4od2/oV28cPUrj2hcm8qGGjlBqH9aNRN7Ppf1o4+OSw69vs94+ggX6DIhFYreLki2u2OQhHUIfbvHiR3olnspF/ysoz9t3YqdcGf/MxeifARuXf+4yhVhphq4H9wrS6tfmpIbPDgGyezVSQo0nYt9iR2e/CBkpf5zP6iu6dOrg+nVhNCgt0hAZQPlNN327xt7daPOFEZ5ZlhNCV3TmkFZyysItYyZOcNQcZnfoFyN8qBtDCpn2p4xVt1bDRjbmbPfMGCP+I7lcrSBiAje+9IXFIZTNkjGJW+whdH819So7u69ChY+PUtW0XOLKIcKdUkj4Sxrzh2my69X8IpZSU9V2zgOdaicATDZMY4p7kCjUjF7MaxmmjRkQosIvynRj4nScOYeNkgDE9noiQffDyOWPCh0kZrQuVtvDesmZSL8KJcHK1Yq1Cf9vRKqXCgveyX80NBJ1Vk/cQdf1F38HVPO/yRhFoGcK7Zuz+1csv2kW7SDaFvf+zGPXu10a60G0O9/Ga23Aos/OCda6HRpQWC/XsW9uaMVPp9fRKGiFqR/Wbwnbd7iRRcstu3sJ6d7DT8OXh+GtFYdx6vj8AiD318Hqk6HEfe0GpsHnJGNVXKwM6anQfnhI90ZmYWjZ+MzHlAtUdOtT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: silent memory leak masking due to PG_private removal
--

commit aee12ed3446e69cb6eee57384ca09e768dab36dd
Author: Zi Yan <ziy@nvidia.com>

mm/page-flags: remove PG_private

This commit removes the PG_private page flag and replaces its usage with
checking if folio->private !=3D NULL. The space left by PG_private is
reserved as PG_folio for future use.

> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 7080a6a1a79e7..b0ddc652e76cc 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
[ ... ]
> @@ -1169,7 +1175,7 @@ static __always_inline void __ClearPageAnonExclusiv=
e(struct page *page)
>   */
>  #define PAGE_FLAGS_CHECK_AT_FREE				\
>  	(1UL << PG_lru		| 1UL << PG_locked	|	\
> -	 1UL << PG_private	| 1UL << PG_private_2	|	\
> +	 1UL << PG_private_2	|				\

[Severity: Medium]
Since PG_private is removed from PAGE_FLAGS_CHECK_AT_FREE, does this bypass
the safety check that ensures a page doesn't have uncleared private data?

Looking at __free_pages_prepare() in mm/page_alloc.c:

	page_cpupid_reset_last(page);
	page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
	page->private =3D 0;
	reset_page_owner(page, order);

The head page's private field is silently zeroed here without any prior
verification that it was NULL. Previously, free_page_is_bad() would catch
and report leaked data via a bad_page() warning using
PAGE_FLAGS_CHECK_AT_FREE.

Now, if a buggy filesystem fails to detach and free folio->private data
before freeing the page, will this result in silent memory leaks?

>  	 1UL << PG_writeback	| 1UL << PG_reserved	|	\
>  	 1UL << PG_active 	|				\
>  	 1UL << PG_unevictable	| __PG_MLOCKED | LRU_GEN_MASK)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260920-remove-pg_=
private-v5-0-bb68b6a21869@nvidia.com?part=3D17

