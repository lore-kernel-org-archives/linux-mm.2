Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B35C624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 01:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DBF46B008C; Mon, 31 Aug 2026 21:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2A66B0092; Mon, 31 Aug 2026 21:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C9976B0096; Mon, 31 Aug 2026 21:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 066E36B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:53:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8911480320
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:53:20 +0000 (UTC)
X-FDA: 85163520960.01.0F52AD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id CC5DF14000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:53:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Zq8VpLup;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788227599;
	b=fQSlLUGc1EPDdEU3lcf82N6Q/0d65WpkHGramngI6jyoe/7BirzIK2ASAshS7xZSpvqJcj
	m5Mgo1FMXZwpmXh7Ipddw2S41aabLtkh/SC+zrWOe2MVdiwxB/dOFoa3CA7e+4BinVikdD
	4K3jkoSnzFJx1JxYBo7uLFlcFYVIhMs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Zq8VpLup;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788227599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfPoQFWa5XJK2n+gLXq+InLZ1SHvMm2K6VuNoOpddPc=;
	b=pw96sjdAWHHsJCiLg1aSPSe+oLMFnblu6cyGu0AsVp+t3yCyyuJnQzd7vURB8Jjd0FtCSw
	L+U2i6JFstHGO/aDWAKLZuT2mIltyB9DASIxdgXapF0x8aQ9Cx9IJaWpE5Y15CDUrq9/T4
	B4kelDc9An2A9joUbVjkF0T66A1DukQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22D17409AC;
	Tue,  1 Sep 2026 01:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E38F1F000E9;
	Tue,  1 Sep 2026 01:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788227597;
	bh=nfPoQFWa5XJK2n+gLXq+InLZ1SHvMm2K6VuNoOpddPc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Zq8VpLupvgE2yRJw1KQGeavVibzTXHtpjCONjfoal2aDB/f32LHC+a9EHOOObR2dz
	 XMrE7NHF4NkTlRLOvkXFK75juHDjUVcCkQ7WguvUjYiW12f7gOk81DFIAVNvWoojWS
	 hStPm28T4PEXRZKb5fXVKK4E/erKvPmWGFqjKOw0=
Date: Mon, 31 Aug 2026 18:53:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, samuel.holland@sifive.com, David Hildenbrand
 <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] sh/mm: Stop using [p4d|pud|pmd]_ERROR()
Message-Id: <20260831185315.ec745606e7eeae6d1116b7d1@linux-foundation.org>
In-Reply-To: <20260831054331.625505-7-anshuman.khandual@arm.com>
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
	<20260831054331.625505-7-anshuman.khandual@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5redsmtpp1nuquzw5o3ggafibn7k4f1c
X-Rspamd-Queue-Id: CC5DF14000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1788227598-460498
X-HE-Meta: U2FsdGVkX19nA1OhCV6Br/wtu1liZPpoacSch6mEqz0QSPAn98/oGvGYhBrUOS5Pzm7j4SGCU3f+YRMa5k3fOYcyFFabuIqLEzmRqDfea+MSZejFvE3gEPhpaULPxJOWSeKylLg3O8t13d9tdcHpVTj2KqnMRzp7fJdujewKUjzbXG7c32N+BL+QsEA8YRogYj+KXbaaj5Q97ImA42xHwDEC1kCEbYpvkxZTUt3eE9LrpEjr3sgUzmHYb9xTDxBekxLleNKgTJqHdVKYKrM5ydGDfwi/ii3JRSLFBG4TQLrZ3Dd5AVQPrzpxcY/CPiEkaaMs1pdfcGb50flZ6CK5GqcbXYb4u0ns+rVrjzY70bkB/X7JWOsBrfHSi50LdqgEgTPR8fHsqP/+r80F6CL/RsKq++Wls21cmyI6WksXZY19DW9Rg+sOI9d4H7Utz2JolFBN6Fp4eItniExJvm8RKcCVO8qHN74222wezRMdmJDnw4b5d28u2/TD5wkBzWWyA+xn06elIA1oF8PCcG8/JnQPGi1q5D+9QoBh5zPpwhT7W797YgM1D+Kkq9azP5d/F5e2mCH5t8ut+5wE9+s/PAcB1oU5xgIq8eI9pYhY3MyvzOdKHOe4BemlUIimaOlzOjeIyJQiuv4NndQu5jj7qD7lFBXn7iRucZY9wJioa3YKksCo2iElAVQm5fxA3bL9YJL7W39sEodetTRvLYx1C+bwQnOMJKUucvWP3XkyWKXsyBzvBsPSBHHjRRC5ub034oLdWpoMU9OlWWSul/Ht3LLpR/LIbLBG/6qzZMCe2DZ6Z50bAzBSWNDUbPYL6P/WxS1GDa1Kf4Po1eeiuiLNdKboMTADo1mWoR2IHS7mW+VUlHZTeFdtjbGK6IOOu6m9r4Ru4wObaxrxFD6u2NUiGSOib0lnY16HZwGVPSDHEUJxuXx8FTigBZryAvtRky70Qavb1xOHJcyuHHGR+Hf
 sbyhtVfA
 ZM75q4NHO/RmMLAKn5IxDYZ409r0Idc4/+i6WIn2+mlr/dLX0gAXx08TVy0OT1z/gUaGRgPKVwDFDpfdAmCAMjYW3RTFM1mpIwzxd7BkZkfeMsnLZRnXA4Ashgir6O1ZQeBdMp6LiO8Ft0evgkd6BiJcCcF2IdWOR1Kt4nquWkRjRybPD3/A8P0uh8sLeeVZzp/bM57Z5cJXZqSLVwUktHzP6GO+7HwikWBUYxBT+5x5NEgbJ0mUMhaowb1FV1lmSruqQPENfAUEX+HXYf2ORnrcC3zyzgUiyZlTtiTBuYqsUcK4E+KYS8csYGs3T5z7OxTExzIXi1XIoy9Ty444MikDmskCO+PsVHCWJqNg3CrRNVGZJqazBn5lAlRT+yQsSc9wDZyXeS2o35XSwv7ekrjCXaDGi56A/R5sQdzvDBborpX62kjU+ZWd2BWvon6IURkC9LKYy0yvmO3vLVBEH9SUqMifncPpbA6+VriKD1f8/ncw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 11:13:28 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> Stop using [p4d|pud|pmd]_ERROR() in __get_pte_phys() as the pgtable entries
> are known to be NULL and hence could not really be accessed.

A note to the sh maintainers: Sashiko might have found a couple of bugs
in __get_pte_phys():

	https://sashiko.dev/#/patchset/20260831054331.625505-1-anshuman.khandual@arm.com

