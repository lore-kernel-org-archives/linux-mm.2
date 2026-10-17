Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDCFBCCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 16:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07E286B009E; Sat, 17 Oct 2026 12:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02FCF6B009F; Sat, 17 Oct 2026 12:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87566B00A0; Sat, 17 Oct 2026 12:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9A616B009E
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:13:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 729471C3530
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:13:14 +0000 (UTC)
X-FDA: 85332612708.29.6EBECB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id CB6BB140003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:13:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="La6ZcW/U";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792253592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rxnIxgjhHPOhNba69hG5CN7WDYZeGiFPLDt2bgf14ck=;
	b=Gcyo64NI0CPr9Prrvqbp1T4GoQdOIWS7e+8cfkMIoeP5G7GtxkVKdT/37fVwioeukXwUwX
	6R8mysUrI/EU/AiVol50QQDORLjj9xFz73cOZXy40Dtl+7MMQ/7FOBSXXiBSd47oI2xkkY
	BOIL5jTE24VBOxUIgkn51idW2kSCTzE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792253592;
	b=gz8UYIU3FVIGG+CEAerxWe/OLHbVYjXvYvUUQglBPoazv99WN6f8cP+EckzPn7gTD9aksr
	k59iUt8ue+p2FMBHHF1JmQOEM7JUIYedfdhDNFhJppP6Cw//p19TwS7Q0U8eDzUSEwrqCI
	LntLhmoXlqMbAy8fEuN2US4suXzeaSQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="La6ZcW/U";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7D7F4062D;
	Sat, 17 Oct 2026 16:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAAD1F000C4;
	Sat, 17 Oct 2026 16:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792253591;
	bh=rxnIxgjhHPOhNba69hG5CN7WDYZeGiFPLDt2bgf14ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=La6ZcW/Uhu8NVTIoeLjexdfAzN4hdC8y+79OaFNQ38HYguBGwUNMaDBCNLwg5hAUz
	 JsEjETx5AaTp5HY5lntp8yJ01siNMTUqyr4NiDjXw1/ft5x1MYooNWihv9BqmkGxf6
	 WX6Y94NstW4bOMsxeJuDyHPUFDX7ex94SishA2sP/6ZMSjEgLGvQqZnLmbgaes2fCe
	 CVQECjwZ1Qj/fNYoVxgq2XgHQHfM21Cn8NUMPx3+xxLH1Pns2d5QXnvm4H9s+2+oGV
	 tuc5FAxYGAkVjFUiDw52ylUbR5EkDWD19/9DqggngB8Ih1Ryo+PrV4Sg/WbpTbnbtU
	 WSuU5it07fMlw==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Docs/admin-guide/mm/damon/lru_sort: fix grammar and stlye
Date: Sat, 17 Oct 2026 09:13:03 -0700
Message-ID: <20261017161304.103620-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261017083535.1261388-2-manuelebnerli@mailbox.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CB6BB140003
X-Rspamd-Server: rspam08
X-Stat-Signature: 3jkcwrufy6c5qjyx78itm6hcu861iy17
X-HE-Tag: 1792253592-177965
X-HE-Meta: U2FsdGVkX19c//79zy/ZXAfeZ/xnqPC9Gr9XHolTX+pbuQFim3NEnIFewOoVbrrHHNdiozzhgHXhX7ZffbB7wjqyLS8ICjcG7D3Q1OAt7kZdTC5BOS3fvS+yznXZDtjqKDgG8RT+SkOptxD7UOajeZxhlGm5d0Yqu0oMAuZwHTlG9YZDHL4LZkiCAaL9HHARnY/uCWFU9aZQFBoiyZehsyquiHs2f7iu7U8kHiNIRycHo+wgJKG7oLgMEmtwXUYIa03K3a3XWiZc2NOYBdvMKjL0YOpyjA23b/ZWeipP2xWxEzIONSfPmTi3t9BAMB754wz+4SOyrVyBQDowJnWpjuykQ+wZbnlQqi027NPHVfoJmUw/CPGpAEkniLUUVI9/dexaETUAUcw2a8OJqKH0wtgZMZ+celVIL1iRzpKyuyCX+KUF3uVmllFI6rlJEUrNC8zyCm1SEEma3sIOPQR2dKRkfiABHJr6PVWQTw1dc3bygbZDYa7pjoykQfxEcTgesIx4YMA9JkdD6qna0PXsp7d13nEzwllUCqhuqVmSxJbNBYiZsY44UjfqLv8TU+PA+ftIDCl5h3hPEbYoesx8Vf1ZxNsIVM+YlKtsYIvSmNfQvXPcmIzO1uM/uZMpKZF2xCaMjNJAIB0pXYbqMrQ74q48ThyAc+kNy6BdAmaIexdKrs9K3oqNmUTwmSwGITZw2VTWyTPgOo+eSvuzmv9JCw57h5X9Fug0z1WGZLg9GEmQhsEJ5lMvnv+y++UwxOhHGocmgQfFd+wU8LqyXlE/r4uQxiKnhGfLaG+aoKUYRS6izP/Pqyi/kUx/WA5//7hfRbwAUwwTWO/U+iDch3+2i/NneSDGW7g7JtdPCsLDoM1sKsjverUur4xvyj3G0tZ4UrLtnSafQvQXpqB0CD77wlMpg5KlRlPqC+Axcj7s0gX7PKyumeYuvdjNInkXpmIzJS59zeusmRgdx+aFO0p
 9dm0msFc
 1EC8hGupuc5DDxpIyTjehA3tilvJFJUPz+lNVCIbuh3M/Es5BDuYqtKRzu9nR/Xb0FUQ1KpOQqvUlqn1KXcB/0KAHzuaY16yibQa+0OEUaekeLqjyWJDJCCJuesMcAsaec+vZGZcUuBV4y6sMeFpRB9RbJxIaGDdoLbzFPL1gyC1a8d3ViAK1QEFPzJHyS3zJcesExa0jbkilfYIxGxQBgU1Wzs6pdFydJSJZEIBe6IdE1VJAMdKs8tQ1G5tRsZuO8b85vOsTB9B9hGSc+RnaOhFAdLshxyAwwQIskRtvtPPEkzXs+MDFHhsv+CY1vk5OgZq9sCCKneI8czjmxrCL0cfMkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 17 Oct 2026 10:35:34 +0200 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Fix tenses. Split long sentences thereby imporove readability.  Replace
> 'set as' with 'set to'. Replace [] with () to make the file uniform.
> 
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> Reviewed-by: SJ Park <sj@kernel.org>
> ---
> SJ, could you please replace 38b3709936fa ([v2] 'mm/damon/lru_sort: fix
> grammar and stlye') with this patch? I messed up the path in the subject line.

Thank you for fixup.  Done.


Thanks,
SJ

[...]

