Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B39F6606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 09:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZRv9I1Kq
Received: by kanga.kvack.org (Postfix)
	id D419C6B05B1; Thu, 29 Oct 2026 05:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2F56B05B2; Thu, 29 Oct 2026 05:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08CD6B05B3; Thu, 29 Oct 2026 05:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A48E36B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:08:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 392971A0355
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:08:31 +0000 (UTC)
X-FDA: 85375088022.10.DAF8639
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 64907160002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:08:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZRv9I1Kq;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793264909;
	b=sKOxAYHFuNgrhUM9/aPgbEXBJcktxc7muap8Xn+dEFlBXgRbtZg4MZBVBOcNtGVsbA9cLD
	R1PrEw9bIdsD5+BnRIMxeVgk3K/rbCWWFi463t4xKKOY5SJVagbQBoxdJoGuMW1SHTqgtd
	b0JAK/2wMj2DBoqhyjSh8ZBmCmjVyUk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZRv9I1Kq;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793264909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RnjJ9+LjDvlJcOeQCayAGBKYZfKHfE/QuFVs8cv4lL8=;
	b=HeNWI0KJO594UpYve3TlMbGKe8ujEUXMXbEDppTOQ2Jtt+Z+RyEOf3l+yaOJ19OWwVYeDc
	Ys57APAA81UctPrxUFRfkBM8uu4ROBGHWMjdGSDJ8dEHL5KbweyemX4o7gkfDAS6/84LvY
	rK20hqJM/U28df/vj8U3QmvYfcCDmvg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C1FC7601E4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:08:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786C61F031E2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793264908;
	bh=RnjJ9+LjDvlJcOeQCayAGBKYZfKHfE/QuFVs8cv4lL8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZRv9I1KqVuVAi+dknQU82IRiWsxn/cd2MSRVpSaadEAVnGPyb55+698AxPxuEH21e
	 /mAOMMSkw5q/+SSaHm3L3WqL0mKJcIXVUJhyf32d3MVa5CgEbxr3bUDIT35JxAy/24
	 L2HVPkqiUGI0aAEKEpgaEszSM7v5vWvr9bxRYXyWD1kCQZjXkJZKJ2eTMEILJuZkhD
	 tTZr4kLY0FdzYexeNoua9MQMzGNgiGElJSBN6Vu+XbgnHCV4k6VR6PN2dFJ0TQ2HQj
	 DaLvNAZiefd0kRnm3KaR6q5iQGfIz1YYRK4+ZNx1k8uEMUgNdUOlsXJZehpJiIrU80
	 ppIACx4OI5m7A==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9441591aa5cso41979585a.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:08:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzEJr3wdR4Z2nz6sjTiupiJdhQzR4Jno6G+5zh32zwyvvMOihm04vqjK+fKjmGnOesIb1oFsDj+Wg==@kvack.org
X-Gm-Message-State: AFq9FYKzTNlslG0BwmbPQ8fzF+lbEm8VAikz/mwXYpgl8YsMPf2ePQwP
	FlfZgzKuZ+EkegRxONZYQfiRe0uvg+wdayhurha8VBFnevn5L0d69Ma7QKM5qVHSv9yzb+JHW90
	/Pky1IvmbUtATCDuY/4vELGvLfzMKxYY=
X-Received: by 2002:a05:620a:84ca:b0:93f:3834:31f9 with SMTP id
 af79cd13be357-94413358ca4mr270852785a.12.1793264907818; Thu, 29 Oct 2026
 02:08:27 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261029-data_race_huge_mem-v1-1-112e331291c1@linux.dev>
In-Reply-To: <20261029-data_race_huge_mem-v1-1-112e331291c1@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 29 Oct 2026 17:08:16 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wndM+uFwhX+7wdkm2Q8AkgVcw_4wgpObfw0DAZ1w+sVQ@mail.gmail.com>
X-Gm-Features: AclHuK-H8tWpHZZawUCKisEyC5nq49Lm5sjkdR7OLpR5GCQKP0iwghbrFFjO8Zs
Message-ID: <CAGsJ_4wndM+uFwhX+7wdkm2Q8AkgVcw_4wgpObfw0DAZ1w+sVQ@mail.gmail.com>
Subject: Re: [PATCH] mm/huge_memory: use READ_ONCE() when cloning folio flags
 during split
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ye Liu <liuye@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uc45ggdwxyqm1rdp7pxz65ia85ihewjq
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 64907160002
X-Rspam-User: 
X-HE-Tag: 1793264909-806035
X-HE-Meta: U2FsdGVkX18kvbz+Gtu9ib4Y7vToxGj+JgrXKMBZqxeCcXEHLOC6ccxwWWfSfFB/vIQIwqhh8VSooxo2hIT8/zBUVTb+zAe1EtqEZcr3HKFV7u3qf7/UDGXmN8Tjx9wLnP2+78ZYWdD2gxp8m8Olqt/hAWrhEhtoya6IJ1pH8owuAKLHBvMnLdcZQvP/Y2JZvuwzEgS9P/Uy4kf9ovdyf9gcKDlyQGU4cZCo8h7Y+ir58StR6LK1OGK4WNaoXIHDUjYrBQxkGHucp4g/SsHa7mnxlraRhLkrv3JLRwPEjmD7c3FgO77aup4aAKNZVmwWquOM8wufThocFkvhPanviPRus9Wf/oa1ngk9bT57P+VMp7GCxgw93Kmb3pNtWToipaIH9dBSmUe0bh7WY8G25jSO6zRbU70E3v/DD0lbz7iGD0U5Tir3HWvxuL+IlAmeYXxSq5aYLm+qPSEOU3kN4UO2SEzp/7BHo5ztbT5tCKEiBy38gcbKl1zqylu9tCZfs/FeThQCUXoBFyNKLCWGDta7tw3xJ6UVpCD7zO2d4U+1PKLFivNzFMy3HOdUjHpV/kS72nxUUBZGmQiKUxx5JBMskfLlYxMDuy/i7a4pc17FddBA/k5Xx+EaK9CqCVSZ5+bCXgRtqqfkjrn86rXyklgr+cRcIA/8vd5e3JrPUXmtszk8t8KXQuSpfX4+1PgfEZWWDhw0bjRqBR3LUgfKo0YUi1OEForRuPs+qAdw6+JacZtQo0M02oEiaSv3cJ7gF6rl2EP/77yfd/lJ/jGlEmtsWvaZmEkPwNAW+/v+hgBd0+bAOTP+Z5ClMNER3waXkBlH3csy8M7sVX6QRqK/N0m2guJo7zSTn04Tabf67JWkBr3EQ19pXEAmWAyMXzYNaOVqKvq5WOEPKrH9UHJBUiSOcbeFmlnwil1ltacWAaKVX5feRwMd/KVZnD+d0+zBd1rhyEtBJTyGn+IK5hM
 0dPElps0
 V63JV5G1Duh2kKusSJ1aSG4apYBu0oYSje/9Ne3MrCRiZ03gSm0WBQrLFRKOQinNhvC+6V0xRuHP84f5sUArluMTC4LupRzK34Mn4WFQDN/6IUY+E/L51l/SqRsJIO9MSJxZvCiqd6xglMZ5y1LpiaDn56oCK9x2nxD2LXEAQIbdmiP5bcHjxtxFqjv9w39qAv24UArHsF8JNkzLkXtePbHrgR7aov528neKuvYoGWt+pHDm2OqAlXtfMiA9cKaQA1auTKW2wyykK/3uS5J2s8QSaqgk5HlMO1zUykHd9QNJmBgX/EnP80822z+fnOtCYhHN1USORQ8U5cx2APUJIcqpfD90nCUFO+Reg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 3:41=E2=80=AFPM Ye Liu <ye.liu@linux.dev> wrote:
>
> From: Ye Liu <liuye@kylinos.cn>
>
> The head folio's flags are read as a whole word to clone specific bits
> into tail folios during a THP split.  This plain read can race with
> concurrent atomic flag modifications such as folio_set_waiters()
> (PG_waiters), as reported by KCSAN:
>
>   BUG: KCSAN: data-race in __split_huge_page_tail / migration_entry_wait_=
on_locked
>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---

I assume the race is harmless, but silencing KCSAN is still worthwhile.

Reviewed-by: Barry Song <baohua@kernel.org>

