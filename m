Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8106EC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 07:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3614A6B00A1; Mon,  6 Jul 2026 03:44:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339206B00A2; Mon,  6 Jul 2026 03:44:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276856B00A4; Mon,  6 Jul 2026 03:44:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEDE96B00A1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 03:44:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7444AC19E6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:44:21 +0000 (UTC)
X-FDA: 84957563922.09.55D2CC5
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf29.hostedemail.com (Postfix) with ESMTP id D38AB120007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:44:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=hC0TCeZK;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783323859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DWB+NjMk1HZepzF30XQzFwBn/hDq5+vh5fwlGqKis+4=;
	b=lWJy7B6zA2vPca+Tq78ZQBx9pLKBUZd6gFpf3+1Cq4sVrDrgN5wktVdtX1uyBInV8zytvr
	QuzlrY0fKOIjuxkK7M91pEr/WMRlHa2Kp9MnEjUp9iU7MqpcBBflLhJtjppzed5/IcLrru
	L0eH154r27/kbh5nQ/tQJtu78yHemEM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=hC0TCeZK;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783323859;
	b=PLzlPAguEIwzYvLd8MmkuXUoX6VX3DwT8Kwr8w8d0maHTPkyfUDUukEWiRKqpcFSVoOde0
	n2bpkQN4ukHHxdWNy5Um9rW4AKiH88vwVurznAr5UljQhb4AS0rWApcpid6xOEqrnE2pfw
	da/dKUN0i+YUS1pFpu/HTZwI4wzW8Oo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783323850; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=DWB+NjMk1HZepzF30XQzFwBn/hDq5+vh5fwlGqKis+4=;
 b=hC0TCeZKMo+CD7ZABwhuUqjie2wrXJGayLjJvPFDdCCde5wEgJryYiimTdjKh4zFzpoq3w
 8GyQqiFxCYGUvez9FAzi4CBTknfmnbHs71Pn0Ze6V3PuuI1nfn1Lc25NmvF7sLCQ3YOGnT
 bf28URxLxQWmnjy1i8srnyNIesd+aRn7RvR7vUyhjXv0r+S9E5zgMBijT9RtGj2DMz23/p
 qO2EkACqzH5xTuLb3Lu2Nfb/gA9PyqzY2DBpJX4Fa/29RI5ei8JSvn7xXqlhzD/IoBTjI8
 BWlYUaWya2RMtYbkceIit4EIJ0Ku3fMwmnlCAOR1CY4DPL8mCNO9EvktD45z9w==
Message-Id: <20260706074346.23928-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, <kees@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v5 7/8] x86/string: extend memcpy_flushcache() fixed-size fastpaths
To: <bp@alien8.de>
Date: Mon,  6 Jul 2026 15:43:46 +0800
In-Reply-To: <20260703195619.GGakgT44P7lpcoMVlY@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a4b5cc8+24c6be+kvack.org+lizhe.67@bytedance.com>
References: <20260703195619.GGakgT44P7lpcoMVlY@fat_crate.local>
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D38AB120007
X-Stat-Signature: kqb691gcgzaaam9nr9mdhxbsuawrwyek
X-HE-Tag: 1783323858-536212
X-HE-Meta: U2FsdGVkX18IWCtj2mlsRIynUDAb4dwu1TJLB8L81a7Z7z3zb7Mw9NnWpjrZMCpOI3ZllCgUA2yWEavGm3n1PNmn0UNIJxHbyEL+KZNkWXZ4JtsCXuVMaLNIUEhGB9JWMOQFNBtXi72vgtgVAh+BqAaa6FlKRNb1TcqyMUj5iTnv9T0oix646R8IHAztgVHsTPrDOE4p4S6YI0pfDIxBoj1nyfybafJMH/FDsVC5oIfoCpyHsitSm2iIytyiusSg3YWaF4bgES/bNJbjpSXOgHOtWOcbHu1ofZzAZLuybRy7cMd/rV29UPXLulzCxY50tt1aAnFoJ5awm9hbkg/7E53Me8Ofe94TReb3EBUe88sYC+RRRagCvwbmhRibs8Ug37hGhcX+0kg7UU152BZVh5cj416nyMaq25Rzv02SQ1lKzcrXxJzTp2b9hm7V9M1I7H/PKHXvriHKsenmKd1rAPdB4ad3gl09Cn3CNlLGr7fRiDUTIqCs0B18utvtETUSzmWEp/2Qv8KiQMYyJhSVtKhoWiiaxorsNZyehqQ/9M7bLSPwbcAAEtdLdtTPmmwYRy8aE5ekQjRawz9oGLdOQNqerUgcZFM2Jtrz8BO03qG0oHH/6EvoRwFgMvv9CstVJMSZ3HWA1xFMKztyh4uqCFC8owEk0zgxvKl4Ufqpst1CIws2zItwPz6pzxgANuIe3FZU3OR2RQgShAv41znffhkHG9D6tY4B0Rle+tHlsd2eBcLDp4gCYngWIdNjC5TqDft9ClGAFFyNZnpfyRkdMGZvS0JhEH+++l6u4GAUp5BWR2ryvTu2EgvAWTpn1Ir55uCs5ALY2it4Rzdx+L3tdO3fVVo5iSXi11pYOxX5JJ1SFIVQE9FLOPUStBYndQLXm7CHWVl3X6BDP/hDH5MUL2DAsbOdHQjLi5E1qNYgRwqswq7ZUSYwHG44qp+xktjINXQ5rjxT5q0g6DhtHm+
 Y3l5aMxB
 kWRXaLNFZNY8ZbH177Je28UP6TKbO6+ILrAyKBUcLpKLA2urVNV+g2zPiyQ2kO0FkOm2kWTySv8KIHHS20ERXEQKABjVsRl8mWWJAQVSk9GfAifxQNPQLUgqixXfrkQiCHhVRAP6PNdT3gauvX2PIpDZ6GswuhrNtGc9JeCSy1onEwhABfYjZYwqCDZp4+uF/e/f1Ntg3HhLxhMSYmRKiAAlH7yToQaI25N2DK8Dda/0svYbtg7FbJ0vwJtDQQtd9lNl84ItyLsBpwC7N9Z8dieBm/Je0S8N2F25L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 3 Jul 2026 12:56:19 -0700, bp@alien8.de wrote:

> On Thu, Jul 02, 2026 at 03:37:50PM +0800, Li Zhe wrote:
> > The relevant target sizes here are the x86_64 sizeof(struct page)
> > values which patch 8 can hit: 64, 80, and 96 bytes.
> >
> > On x86_64, CONFIG_HAVE_ALIGNED_STRUCT_PAGE keeps struct page 16-byte
> > aligned. That gives 64 bytes in the common case, 80 bytes when
> > WANT_PAGE_VIRTUAL or CONFIG_KMSAN adds extra fields, and 96 bytes when
> > both are present. I stopped there deliberately because this series does
> > not have a current caller which needs larger constant sizes.
> >
> > The 32-byte and 48-byte cases were added only as intermediate fixed-size
> > combinations used to build those larger struct page-sized copies while
> > keeping them on the inline movnti path.
> 
> This needs to be in a comment over that code so that it is clear why that
> distinction has been made.

Thanks. I will add a code comment for that in v6.

> > Yes. The separate helper is there exactly because the added
> > 32/48/64/80/96-byte cases carry an extra 8-byte destination-alignment
> > check, while I left the existing 4/8/16-byte inline cases unchanged.
> >
> > The intent was to keep the larger fixed-size cases on the inline
> > movnti path only when they already match the alignment assumptions
> > used by __memcpy_flushcache(); otherwise they fall back to that
> > out-of-line helper, which already handles the misaligned head/tail
> > fragments before entering its movnti loops.
> 
> Why can't the larger MOVNTI sizes deal with misaligned cases too and thus make
> the code even simpler and more straight-forward this way?

The extra IS_ALIGNED() check is meant as a conservative performance
choice, not because MOVNTI itself would be invalid on a misaligned
destination.

As the Intel optimization reference manual notes, higher-throughput
data movement usually comes with alignment considerations, and can
be more efficient when the destination is naturally aligned.

So for these larger fixed-size cases, I kept the inline path limited
to the aligned case. For misaligned destinations, falling back to
__memcpy_flushcache() is expected to be the better choice, since it
already handles the unaligned head first and only then enters its
MOVNTI loops.

I will make that rationale explicit in the code comment and commit
message in v6.

Thanks,
Zhe

