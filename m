Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17413CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 20:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6976B00B1; Wed,  3 Jun 2026 16:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E546B00B3; Wed,  3 Jun 2026 16:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CA8F6B00B5; Wed,  3 Jun 2026 16:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BDF96B00B1
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:48:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6F28C18BD
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:48:34 +0000 (UTC)
X-FDA: 84839789748.11.951066D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id BF41740014
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:48:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fYXrVgq6;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780519713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWq8G2lqw2RpyQfsEvmjqd0W9Ut7hRZ/L/1V1a9YGeo=;
	b=xJUocKtQXMFBxs6VjUHMzMJsvz/u4UPzaCak/Bf+nw5Z5x1Mw5zhuNcxbbn4ScEOFF18NR
	tubVGB7Zi/V8BwzHgABQLXOOTFKXO6hd/oXyEyvBnifqfcgybcWtYf82utqHnJK633V3kZ
	oizsFjSQcW+r5H6jPbCkOzrL9jsmtSM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fYXrVgq6;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780519713;
	b=v3jQV0MwJsAgBvw2rIfWBLTBv4dUpirM3fp2A9IjhhyjkfifFwkY3s6Hh+LFWFG42QD9hM
	Ojfye4cvSj7ybqhtHr2JXX0HPNXetS7M7hvzwGLumai4WyriRwkOyNGhUu9uTChHtjfI/O
	T9ASn4EjxlfWE+/gcV078WaQ2T/CYLc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51E7E6008A;
	Wed,  3 Jun 2026 20:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCA51F00893;
	Wed,  3 Jun 2026 20:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780519712;
	bh=aWq8G2lqw2RpyQfsEvmjqd0W9Ut7hRZ/L/1V1a9YGeo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fYXrVgq6VwBui5CH3f66ph+YRAl8BrNXjRgTtjbvmyh2QsCIioaBSNTbDAAt4dWT3
	 mKmlFk69pBVUjkA+nM94EVfEbmOkDzUep6ki+2imHJW70w1ggs8/f/s1Um+kXs48U3
	 V87j6OBoF0TRT9IjuO5ICyN7KEXfNMjclAJy1A2Q=
Date: Wed, 3 Jun 2026 13:48:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lisa Wang <wyihan@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan
 <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, rientjes@google.com,
 seanjc@google.com, ackerleytng@google.com, vannapurve@google.com,
 michael.roth@amd.com, jiaqiyan@google.com, tabba@google.com,
 dave.hansen@linux.intel.com
Subject: Re: [PATCH v4 0/7] mm: Fix MF_DELAYED handling on memory failure
Message-Id: <20260603134830.ef8caf48aff794da581d0d02@linux-foundation.org>
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: z6s9h4s568tnj79cn5893wg38j941xyu
X-Rspamd-Queue-Id: BF41740014
X-HE-Tag: 1780519712-404608
X-HE-Meta: U2FsdGVkX19SGlShPxy+MijpyKCRg+OqywOknFo1JnYDiLOAohotDnBI0aen4x8f1gyRaM97OIBACn6WwIj8XZzMZCOedR4X7FTNd8CJMkQEGxvlVidAkFPd+aN5lBNBPmoA/p0Icg/0YLmZmDmuKGUEL63/VBPoe7xFbd5uN+amOqdRs2Qbkk2b2HQkCMO8h67yS5niMunOJsjgqYQuJ2sSSlsCOpHJWioCUGMmkC5L2Bz6j/lqg1iMJJ6F1FvVCvhef9T+GSmR9zaH37Gl4076qaClZHiJT68OcVI7L42uEk2FIBhjSzq/XK5oKtICA6Okrim4r6oVrhI4H5yJPbl2/cmcHI8BNsJVsOgBJuY0mRf03CcoJTqZUki9B0j/u85lweuLh47D0l3d37nGqBopNPDD5sG1z266Wa0XCMCyIaMmiM5vsUar1tVqDoFiYUKcXvQgbS55W4HEln9khCxtwlZ4tYXEWTM5/UjzdCpZAPH3nUnIJX7TXZh14BjZ0U+lbQaGlmqWTxHI9siJaJWGv+3/12wxlT39e5+bQMM49hMzf3n7a5lODIkgb17tzrCnFGVNt+94yJBEcz9N/N9Sel+nZWRkiVBVOBcEpsQhMqSuYLZqZ7Gr8FgrEcdK2/1gylu/ONO0PyUe4i2mUufpkVMs36xRhakwFpie5cBhMEgIiD0aiCftYx1Fif+1HTEJgmMrKB7LoYF54oftNn0/2nenIwrZ2x2Npm7MO2vNClPNEWo6eGufCPx9PGLQcPB+CrUZm0iJwB3YE3QDX5V5Z+EFRiSJceXgBGMw5z3PyMGVunngd2CY8MisZz5ICkDjuo15lcueHJjVTlQtd2Fcn2ng5HNjDqklNB8Ug3fjDfWHoLnt255oZrOp6HZX7J0omidmAQqL1KaU4WQ1d8zkjlx/6Iw2WLfqDtXoP+D61OvpUxLABbIjqBv0CfEOFKIASOYhci2tvq4pIhC
 keKLdkRz
 dxmW1h0d9e+cF5AMNGHj5W84eRm0hFLnzTBuAR9Cu+TFSrUWyzpbHgVFywesmxmgfr3tB7JdV6flXKPURLdZ9z9qZNFHVCUyNaZnXjuTcApIQeVHbKexd+xNZAFjx5oCskkDa3jzzYoUTgJ5iKI6W4bK45x1FVWft2F9CaqmdlKQV3LCY9VsmzzwW8+LPUmPBfYfk1XkC+vumLP5N+6sy2ptVRiOnSg5SDXh5dnKM92Ye7lI+bXXfNjBzeQyF0uNZeAJVO1fdQoeqIy7OmkAJjFeyeHiXrFJrNwcnhZLxBecQ9DfC8i4MYbBFRyqDb+A6B2UJDzdjaSscGoVMy7pdMQA4mck2DwKfxcLlMLTRPJbUtWVpH1QZoGLyvAqukZxRNlLhsrgRwrRzfvqPvuKkl2NQIKjJbp7cDAukwX25Vf2uBAu7Nb0ihIXL6DvA4mwtC6yDUreYqysSIVYZhvU/Ml8iTABNO0jN9bdw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 02 Jun 2026 21:55:40 +0000 Lisa Wang <wyihan@google.com> wrote:

> Here's a fourth revision to fix MF_DELAYED handling on memory failure.
> 
> This patch series addresses an issue in the memory failure handling path
> where MF_DELAYED is incorrectly treated as an error. This issue was
> discovered while testing memory failure handling for guest_memfd.

Please include a description of the userspace-visible effects of the issue?

> The proposed solution involves -
> 1. Clarifying the definition of MF_DELAYED to mean that memory failure
>    handling is only partially completed, and that the metadata for the
>    memory that failed (as in struct page/folio) is still referenced.
> 2. Updating shmem’s handling to align with the clarified definition.
> 3. Updating how the result of .error_remove_folio() is interpreted.

Thanks.  I'll take no action at this time - it's late in the cycle and we
lack review.

For some reason Sashiko wasn't able to apply this series to the various
branches which it attempts.  Click on the "baseline" thingy at
	https://sashiko.dev/#/patchset/20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com
to see what it tried to apply this to.

