Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A1A9C5AD5A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 01:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D556B008A; Sun,  9 Aug 2026 21:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E4D6B008C; Sun,  9 Aug 2026 21:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064AC6B0092; Sun,  9 Aug 2026 21:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D77116B008A
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 21:14:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53279140414
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 01:14:05 +0000 (UTC)
X-FDA: 85083588450.26.ECC1B48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8000B120007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 01:14:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=o2KUorhb;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786324443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJf0z6sUiaazaZvfWd5l1yYgeWUpiziiNrcD8oTAC9o=;
	b=c9T/ukghxHIAOLpozljNoHhuZg6/Aa1zaRdosXn2SroruBgHPA6o3U10BUsifFy+WbDpc3
	cyVRTgU1F90q0nM+2BvaEZw5xp79g6e1JzISZEhl691lE/wgR2uoHMObcLzJ2WuULT1vhm
	iSeBXkoyc05a7dwKIResg5E1d13TynM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=o2KUorhb;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786324443;
	b=Sp+VvXuQxNV7EJkNULtKDc/CeMn2WRYkRdNWZc7w+NFOpmhipPyto32eDtqFyZ6ABJKniu
	0Oqiwe9xdN7TCcEtj0/IrkqE1SOzxLf/xRnJYOGUNNo/wKm0TwnM9EFUAlrWTkvbKwc9Ka
	ai2NqvFwmrFP0opUYNhCY8vyLmZ4XnA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E09884049C;
	Mon, 10 Aug 2026 01:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935A01F00A3A;
	Mon, 10 Aug 2026 01:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786324441;
	bh=XJf0z6sUiaazaZvfWd5l1yYgeWUpiziiNrcD8oTAC9o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=o2KUorhbWIilkehLn/42i4as5RFncyUcX+gnOmLSRVchtqBty0Ya2HAdFtKfoCtNi
	 hvsWMcNSbZ13TjfnWE2LjMLDooSpR/VI1qO+IGUIshRLjvsmFhINCAHX3cxkSaj42o
	 RfONb0zUc8kYIhajHpMvLBv7bZkvhbhGybi1w81M=
Date: Sun, 9 Aug 2026 18:14:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
Subject: Re: [PATCH 1/1] mm/mm_init: compute hash mask with unsigned
 arithmetic
Message-Id: <20260809181400.148e68eff30394f6b029f4d1@linux-foundation.org>
In-Reply-To: <d12a05ac-037b-470a-a91e-722d15ed712f@163.com>
References: <20260809123119.3811851-1-xialonglong2025@163.com>
	<aniIuZa53OBqCMbB@kernel.org>
	<d12a05ac-037b-470a-a91e-722d15ed712f@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8000B120007
X-Stat-Signature: b884s63koz77cyps19baboswzpzsx416
X-Rspam-User: 
X-HE-Tag: 1786324443-987343
X-HE-Meta: U2FsdGVkX1/Fvc65YjTnBIgYf64U78qEy6yPQJY6LiMJbha2uyAEImJhTy2LWe+X2Em41YmNnV1EtOCWFg7ADoKVOjwoKOl3T2YsriIfeHM8ZL9hF6ke8CtRMnrF6Ay46PKK1lGQc4dpygBtw5nnZwsaQW++FWty+TtKqA49g314OKf2KE8FsI0nuMABTFrZdItmVV1gB6wGv4SG5fpFVLuEmnwQK/hUqZoZH5Z6ufbsLnD5lkTAuMSG3Wxikz+6OUhaw7STGzhPcbx9IbQHBXGMEWfkGsvssVZtxuhScPdwGiRL2yZzGmzvFUVMV5Cfq16lU8Nkjg7DysnhaZ4u3PbYO+QY8XB4oQPCJSPg/P9lF0aYI0yyxdKflNNCE8dkySnBB5in1jFLZ2Ou8+uRlkX2y427R3pN/HJPpHGtnT5C3cj7818QLSuf0QLxLqZ6ixEe6QRM011bvLRofoTkSC+VnjERuey76cKqsjMRr9F/DBg5merXxq31hyj+n97fyLjvfGr53+ATEVaES+uURKtsfnNPKgjifCkxSIMNRQKMfcakAn5Ajk6LFXbQNOmYnfKOxB8aH4J7SrGqk/lv0KrnCTywVmDzWV1OtFrQVBWCL3HErCMPgpZutqTwBH4OROqK0LDp0lmAW9lRbED1iJc+WaTROn5Kr3BGRt5S1v7nmLUTvnXhb8rI6lDgaYSGWPnFpVmTCBKBpVa6aPHWqnGeQqvGN3xYz6krPdStshvqxpOF6BLQPaKfJQ9IpcS7BzI2SpaceZeJQnsbkPnSk7M4fYTAQiVJpvI/fRh3/gFISTtyF9Jok7+WFDYePoIfWJm++m5MOhPuxRMrD2gwxVbl2+MGZHW7Pip/3t/XhbQ8ApNDl/MoqML82evt4kILSpkuuETsGtXNIVX7b6IrZlqBwZniMkNrH8tZ2EMnQOVRMrsolMr/UaFuoT1giuZQlE6rZ2Gw21OY/S3/D4Z
 C63oROC/
 ofEUQ85xaqQCIdqKyiFsrXSckZJ03uEmUe15VYAlEjabEwCmbEoupePlWQ4rhyOVgUrsyC1CIYvHl1ftUl1TL3J2cjBXi9kOiksUZDbVJ1JwrqLDpYWFXnaNSSW8vl62w8/DXAHZ7trs1MvThZF18clEWkGUHkyhaGsvUcQXCUnirGpocp/mmlbSZeNYBhvI2qocBaOwdJgu73tqj8X6TM0aedm+kLPTTh62+L5IVO8a0higptjpwqrXpJpdrl3OFU0ac/YRHH54flmQD/ImNAvcUcMIYAG8jR/wkkVRUNsutXj2r5KEicSmA4dEZOgLGFYuYSTJJdf/ZN3YHi1tqbla8KA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 9 Aug 2026 22:25:35 +0800 Longlong Xia <xialonglong2025@163.com> wrote:

> 在 2026/8/9 22:03, Mike Rapoport 写道:
> > Hi,
> >
> > On Sun, Aug 09, 2026 at 08:31:19PM +0800, Longlong Xia wrote:
> >> From: Longlong Xia <xialonglong@kylinos.cn>
> >>
> >> alloc_large_system_hash() allows up to 2^31 buckets, so log2qty can
> >> reach 31. At that limit, the current expression relies on signed
> >> integer wrapping to produce the unsigned hash mask.
> >>
> >> Use an unsigned literal so the mask is computed with unsigned
> >> arithmetic. Supported compiler settings already produce the same
> >> result, so this is a source-level cleanup with no functional change.
> > If complier already takes care of this then why do we want this patch?
> >   
> Fair point. Since supported compilers already produce the intended 
> result and this patch has no functional impact, the benefit is only 
> making the unsigned arithmetic explicit. So please disregard this patch.

It's a very small thing, but I believe the patch improves the code.

I mean, we erroneously compute a large negative number then subtract 1
from it then copy that larger negative number into a signed scalar.

The copied bit pattern happens to be what we'd have got if the code had
been correct, but the code isn't correct!

