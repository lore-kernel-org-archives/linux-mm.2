Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21279CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 19:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D36BE6B0088; Thu,  1 Oct 2026 15:54:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE7C06B008A; Thu,  1 Oct 2026 15:54:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC2F6B008C; Thu,  1 Oct 2026 15:54:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 951D36B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:54:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24835120556
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 19:54:32 +0000 (UTC)
X-FDA: 85275109584.29.C517C8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6EA0620004
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 19:54:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rn4SXaRf;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790884470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CsO3dVP1rE+OXCdeZb4O5Da9+5kdAsDL/2r4hLTyU8s=;
	b=aB1Mj8o4voYkaZzeUpH97DjqNusRf8iJZ7EGS987arRqVZ/zFcjArQBcHGvW7mG+/rOgE3
	jkiLh6z+GABryqHWfVNli9LtFFJ1fiUCbrrDuQzYYKx5h1M7JedW8moV4ma67DBLpeWL8+
	nmZj5E7RA66YTYLQ98w/97bjWVvvisM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790884470;
	b=LftCIOQhggb1Sc9vuenoD/GrxLij7ukDVcwPqMknPAfS3Z0awPjHKSSfTpfb65CO4v1f2B
	tCClaXihtQh+7P/AeUjeunXYXO3ci/sSaSP/Pl80IOeqCZOIKq/qYXR1NYgysDUnWis3hb
	QDuPC+wQySfF1ACh2MirR3MT3BckQkI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rn4SXaRf;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0FC860218;
	Thu,  1 Oct 2026 19:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8211F000FF;
	Thu,  1 Oct 2026 19:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790884469;
	bh=CsO3dVP1rE+OXCdeZb4O5Da9+5kdAsDL/2r4hLTyU8s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Rn4SXaRfH10u05A1D534ERpHxsGPtlfHGQ8PzRHITyxtpP/uikYQkO09ypRCLYgST
	 YfOfWe4sNz2CXWcjUG1pHw+CCoiohUzP3ZPApImQ62ccxVNqkhf26WGRzsJTY+1KM9
	 UD3FfzjSVnIIwRwwbbKX3U046OXTD7XmT1UO3tAZcIBIqW4+PCDsxdbKI5droVnIhY
	 1AqzOSjGqeR+xgHfR6j1Lou4x3pbCOUpGHtkVFhfimbOoty4/pphs3J0ljfEVfJMxm
	 /UJ5m47BhEh5Q08HqOsyQQLrUm/wL7iUyJluUoozQiSGreDcPwJKrv2X897dnEhd6U
	 XSX7SFGj/8DRw==
From: David Hildenbrand <david@kernel.org>
To: david@kernel.org, osalvador@suse.de, Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260930160432.5564-1-lance.yang@linux.dev>
References: <20260930160432.5564-1-lance.yang@linux.dev>
Subject: Re: [PATCH 1/1] mm/memory_hotplug: fix missing rollback in
 __add_pages()
Message-Id: <179088446708.3427.17462740264114406030.b4-ty@b4>
Date: Thu, 01 Oct 2026 21:54:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Stat-Signature: jhud8ou6jqyh4kobosfeddcmjbsbwuy3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6EA0620004
X-HE-Tag: 1790884470-302699
X-HE-Meta: U2FsdGVkX19+Dm5ZL7NZSHc/OePg1UQVe0HN3e9RX2oVppemTX/wYFuRlOPRN70UQG3vvNihxA3zMyHw3viXfeIN7qACK36v4q1BdpM0w22FOxF5vxJms/cTo8fAeyart8vMzSTDO595IrntU9fEigYszcu/DM0/IlgTZOivT6PAbqNkdtZ9DRJNtGamr0nrTNgHm/P75xYQGSj+GMZ0hhECt3sEl9lCnDaF7H9QMsvthaDC41G+3n6YkjVTTz7rKAP+6RP21temuWAEkfEvh4saLD3bEkHqABGNB8bHpsdqI4pUl1UWuUEZwbV1hqU0Ivdp5JbT4yNrQamtaLyi7tilH9+OvZCGJWdm09tL9+UZg4gifIcCs5H/nW19tYfP6wUuLJbwEFO8rFFuegHqfuKQIRQQaMe13AL9ZKmAv5DKOkTPSzjwJLK1BSjNxM6TWlLTgv8uqIcboY2wdRBNt7hKexVUZ9PHDMvnRWOzIt52c+g655835kfgv9Pmco2Kr7KXTJKUx2cVdx/tuiIG99N8VNi1jN+yWSpFVjt2KrC6TInfe8OA/hlPFne2EIWRN8G6CSV1dmQxlCPvcNuBdE+grK6dQDmJLdT3vU33jM8MRoU/qSb7eJKU/ekHP+V3ofJk4CZhnC9Ja3/Boy/bm/Wp+biLRc7l26C+z8t3nQJmEZI0AWvY3toI0A90ebxNM9gFIF/BGVLW1Zqa3zbWDKt7lXOVN6JQ2D5r8zrioULi6DlZ2hSYiWYtqLQvJvkenW29nd/F8h5SXLA2Q8+RJ17e2EWlaSj+hrQ0obTjq2dydYyFz+K1F4+IZV7WJfcOgIZsbd9FZ/R0UzyNb5yjENkJkGauWMsJRZV7I/6zhnUWOmsfNwh1XzkbDOYnwoaFYVnQvQNjEZkmBj1d0nHTckVOtA4OdhXTFkYmr7bBfxa7tg+y9zvKRJ+L/uCWn5p1Zrv2IZIZ8qr8gsnVzEh
 ZCbbF4QL
 ZTzE1A+NgaByvYCPBWVCigiSTTwCAZYgcYQiEPq2wauGwuMkg2efzr+jk9HoEZ6M1Si38Z2xZM6mV3uZWkhJhfqtj3c+y4aK+psdRlNs7DPwYF3UvqhBqUkCK+lDniHoCpAuSQn0dlNnyQ2vD/JXolbuEeJYnZCJq1YGSMLdMHx+4OTqf+0L8Y+dB6X3Cro860s/UjHlnTDD2SjsW0mhgpux0HRz/HZzBVmphjJ0YyUGab3uCLGGCQ9JMo5BEBeljQJZUVleUorVvYxFJlpG0xCR0Da6ZrYUjWwyu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 01 Oct 2026 00:04:32 +0800, Lance Yang wrote:
> __add_pages() returns on a sparse_add_section() failure without removing
> the sections already added in the same request.
> 
> For memremap_pages(), the failed range is not counted in pgmap->nr_range,
> so memunmap_pages() skips it. The sections already added in that range
> retain their vmemmap mappings and subsection bits. Retrying a
> section-aligned range can then fail with -EEXIST.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: memhp-7.4.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/memory_hotplug: fix missing rollback in __add_pages()
      https://git.kernel.org/mm/core/c/c31bb839

-- 
Cheers,

David


