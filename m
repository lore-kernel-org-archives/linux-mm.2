Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E3CCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 21:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3876B008A; Mon, 25 May 2026 17:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19C396B008C; Mon, 25 May 2026 17:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8CE6B0092; Mon, 25 May 2026 17:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F10D16B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:49:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 911171C0EE2
	for <linux-mm@kvack.org>; Mon, 25 May 2026 21:49:52 +0000 (UTC)
X-FDA: 84807285024.06.B8F5E2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C32A4120006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 21:49:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZNqoi1or;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779745790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOA4XN1b++rVbl7WSQVELFj3i2FB21qxO/Z236duQus=;
	b=bkVJzVBMuQXm7jgLNk8k/qTPdm2hrw0H5kbp6bkhRHiCDma3Fb4KRBUsdvenHg2w032xJZ
	UBPWRG7JvxSQjN+MerXrp4gKxM3/sCjK6x/F0JgJmwNhYMA0ejSVc5wQiRIhyj5+M296Rw
	QrQbOU+OCOphDiFhdc54Gh5wQ5Tg/ak=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZNqoi1or;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779745790; a=rsa-sha256;
	cv=none;
	b=d/WjY4nofXUmnjzuGEX8W9+GNueQWsO+O18Ht6SB8U8dCbkBouW2FetpjUwVwjtNWjxK25
	jmT+KCvQgp6QOkr5MQTwf3x32NkHl3V2vXMyFpAvs5oyyaq/9MnbGPkJwLxVg1VT4omUHA
	/Au/fiCZUmUjPdte9adGoMtSN1molzc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8FA240E37;
	Mon, 25 May 2026 21:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FFD1F000E9;
	Mon, 25 May 2026 21:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779745789;
	bh=tOA4XN1b++rVbl7WSQVELFj3i2FB21qxO/Z236duQus=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZNqoi1or54qhwFMse+1X3LqVJCm8QFzpiEErxDlPFtbwhOosSzV59KgyOxtW2iICq
	 k/4lx8AM7FnMG3CYu5NU/cdR5dwgmLEb0SkHt6pRLEc4KTEFvl7UbienZLOfNhMH0n
	 DLoOLRNpwh6sbxWwVgImzQuqEwRYSWqh2g94qL6Y=
Date: Mon, 25 May 2026 14:49:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb_vmemmap: fix incorrect vmemmap restore in
 rollback
Message-Id: <20260525144948.15e51eb81151e498cc2af999@linux-foundation.org>
In-Reply-To: <20260525025213.2229628-1-songmuchun@bytedance.com>
References: <20260525025213.2229628-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6re848d51nca5bhpzu9ui4xfxwma78rk
X-Rspamd-Queue-Id: C32A4120006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779745790-478814
X-HE-Meta: U2FsdGVkX1/j3xIM3nIogz/MUfb7+FoTo8snS5aFurC/CiC7KejdtIwgpnZIDcogZuEY2hQoVBCmeVOvSWVNvf/pmxJv+rjBNf4y7B+IlSCO5tZakySmSSf4Wli1eLUnoIRmKs9ncqBcysOwgFlLScIzYhfFu53IRRaPHDICwsMV0iyjqJDb0qBlmzL35QNXh1JhF0uCCs72LC3LIXVC/SfIsp34hON2LHlb2T6V1mn9nhZvB2SJ66MPlRfDsuSMHA6r37+N69xicVh1v4Ucc+m/mPh9nzFGrQsQjbCCZXLNNuR6REwVpXScYjWFQHhSrFuL9eM6VcZvjSDSl6d+e3em3OMK+icvU4jI5zupAnDPgmZAmeRmR+qFjNNB/WvWcpVWtIJY5IVwAWlb3QqMS08KRzbkSAUvORCjUkEU7AaZ2/zt6b0XiVPa5w6UZ4JR/yPwgzZms13kl4bSsGO0xKuhyvFxnnP6/NUHv9NU3O6sXDrDy0rFfOf2/AIZNKaJEx0XBrfS9v1P2oCzG7UEkM4rj0tNWwl5wXTieeUJVsV2F1tL5kL2ojV17MCdGW3H4vvJ6nhvFM81Ak2isWPa/Xct1qg8O796PQMp8GwGzjHEd/jP1ZLerhqdZH6h/ITX8rTo1IMuouyLiBjH7B670K5bGLx3o7q8kjtr/qTMGa4qm+RbuQzvgjDs1m62YwqJk0Lp+8H+pmAfFJ06HKr1yEQosYLSelb4T4d8mcmkEVSxA3beYO822IBoOVXM5iEqgHOnKoi0mcg7SPBS6acn39pdylTJGeib+iKic55Wp+M68OuWTN2CPvwblPEpLhMDgkhadgE8mE/aHYWCSZXpv6elC0UvQr6TUyq1+viCqPcSS8QGYzIyDcBUKgidIZASP4cKfEW+MVQhcfj/heGcPOK3mC4MadxlrbwsMI+rJExZEkFcwhDN/U+xMe6uRAPCBLkdqBuCSeYHo77deFy
 Bajp4z6j
 NjuSm6PJYMfbGmz6Gm5hZwseKsepgYOnptpYpmzyDuzpsewf2QRvouRpW1G24mebiAgZ/0enUKHhg3+Lia5ikkG8sFIH97lf/D5oifmyiv8KrCropPFcNhgfMrIikClv/VrtVz2iUK+b7Ln0xls3HIv/uWvxxseInJqtv2WhOO0fFRH/ugUe8aE09MD/SbE1zrVC6dBBO3T049rh5FV2K8G1NyMp5QN/WOUDWa+HyGoXmLLR5BTJiC27ecaKAHaaZWZiswWF00nrpKHZs3Z2AboKsIaLmjYJ2Qr3Tyv7TT7SJThvGqCJmyJ+EnMgUSl8B5juAewELTAQW6EAY1c0Jc572xcHNMwvAiBSCcytQTrjaToN3Aek28p97bUZdV/PukTIp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 10:52:13 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> vmemmap_restore_pte() rebuilds restored vmemmap pages from a
> tail-page template derived from compound_head(). This is wrong when the
> current PTE already maps a page whose contents are not tail-page
> metadata.
> 
> In the rollback path of vmemmap_remap_free(), the first restored PTE is
> backed by vmemmap_head and contains head-page metadata. Reconstructing
> that page from a tail-page template overwrites the head-page state and
> corrupts the restored vmemmap page.
> 
> Fix this by copying the full page from the page currently mapped by the
> PTE. Also pass vmemmap_tail to the rollback walk so only PTEs backed by
> the shared tail page are restored, while the head PTE remains mapped to
> vmemmap_head. Add VM_WARN_ON_ONCE() checks for unexpected cases.

Queued in mm-hotfixes, thanks.

> Fixes: c0b495b91a47 ("mm/hugetlb: refactor code around vmemmap_walk")

A "refactoring" patch caused a regression?  Ouch.

This patch caused Sashiko to identify a possible pre-existing mem
hotplug race:
	https://sashiko.dev/#/patchset/20260525025213.2229628-1-songmuchun@bytedance.com

