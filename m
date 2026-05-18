Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB79CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 07:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B006B0005; Mon, 18 May 2026 03:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722E76B0088; Mon, 18 May 2026 03:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65FEC6B008C; Mon, 18 May 2026 03:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5952B6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:35:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDF671C071C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:35:02 +0000 (UTC)
X-FDA: 84779729244.14.ECF9F03
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf19.hostedemail.com (Postfix) with ESMTP id A920E1A0009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:35:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779089701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=sEouArOwKQNQqdu+ymFv61ztiRH5dGTBYvi6D+X0rUo=;
	b=JxcpP8wDmYI+4gmeuDNATBtsj/aFsVuwFmdbE94qsvUIcf18GPjCbk/3QB96IVarNOkr8f
	kDp+RXxXg30Z52TLLRooATRWhrrX+XOnsO9lVLxLm7NpgU/SmEFTEPLgJptxG9wqPMPLaQ
	52p/F7jbO4HH2s1hf+k7OMjzW6nbIrI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779089701; a=rsa-sha256;
	cv=none;
	b=pCwe1cONmCSvA7rHx2lTRlCd7bwGOTKPE/drQn01U5NaW9yPyNjfGy8yPCGMaT0qgmO386
	m7QDE1HeTItKvXoIUvFXEKNjAhh0TKv+Xgi4DGwg6tAMf4UWc6jKidMnzNx9u9k9xPFqLp
	apVhE/Azydv0+/408M3ulOuWUV5MzA0=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 18 May 2026 16:34:56 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com
Subject: [RFC PATCH 0/2] mm: swap: allow per-device skipping of zero-filled page check
Date: Mon, 18 May 2026 16:34:53 +0900
Message-Id: <20260518073455.2495934-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gwfdrgofouu5jfzj5ooj6u4ns5cotgsg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A920E1A0009
X-Rspam-User: 
X-HE-Tag: 1779089700-878674
X-HE-Meta: U2FsdGVkX18ZmxqI0v1HVkVMCkU5R52h2i/SXeFyxzGqyXs+0po8YpkqOS0OeQeaaq8Sgc0500XoU5R+chkYlG2BtlGkEoUaOQKAc6LyoM24C5FOEc8nlRCb0lnAJp02DzX0ONEVzKOxWfwePfbNrLaHByPP8WZ6SfWv4+Ul6lUvlASQeRQpDNL0XOOyIpwMSAecWTChX5YoOyxTGtoJrhUH/QLlosWxCPpt6gLygGTuCj79r2ruYOAnqXJag08uJMHVo7W0I9eovt4O/E1g+w0//7ma3/Q29bEZf74Zz+/NC3ZqPy6x/XilH8vyCLW4FzV/Nf+kYGHeCIbVvan0zJiyiY5bt5u7y2tIyjAOHYs+o3KMsm2SYA+VeRjJ6fPo4x58zaoesurYBnFXvWFk8LEuWGSjA2o6Yt+wqKjpMoggPYluuWqOh9FkFMk2eL/1SihAoUIZNF/3HHbkBbOY68U0zIwnFmNy9GAlTVCPxmyAC+/q+BN+sFm3eMoZNfMRRALbcN670B2F2btTJJa6Y0g4jQ78kE5ZQJWTf+vgU+Aw1gaKeeMAInrgghEi6gshCxtKFdExRNDA5Z58t8f+CZPT97Etni6OgYhLHrBQcAL7K9vfSLllD8EFRA4TAwcWzyfQrn9570/iR8Q/FyE4Ixl/MOB3kRlFoEkTKNkD06Ku/XkiQovttX7obU0WOYtTYSrk4w8GL5yXFyij/Lq+ZZ+caRmp1XhNy9dPvCgY/ufPEqYY7qccq0j9nbHm68qXH+ql5iyrR+r2ySUNyo/IpncI80cXRhdtPZ84JyieI5EdvHrQ6SNZB5O93ND8RQMZ0cY4d+xdslpgdiSFzUlrUovj6HnENT8cc0dQYxWxqiIAr3KxG2ztIMC1skBXMKDuR0HgYzHLLSlbAHaXP3ZB0A84Ry2+1BkzMvLPqt8Stu8pNYv/ivmVAIE1Q/FGQM39wElPOncEnlmjffBV3HB
 ZiKJJ2qH
 CYsYSUGb18GpoPghb+zWC62ivQElrUUFpFK+LY2tpxwVp6JHP3eMUWSbB3H+nD9b7v9McSn/qnAmnlUdD84+CCsBYuYFn6/npwxrD5ekqT4/29l1FxDZB82CuP0WQty2yUq4NgB0FmajSyhWBtNH4jxMRXaHhxtTeQ7OJSxHcSDB0d5Nxbn6Otc+Fqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the swap layer checks whether a page is entirely zero-filled
before writing it out to the swap device. However, some swap backends,
such as zram and our custom swap device, already perform their own
same-filled page checking internally. This results in redundant CPU operations 
checking same page pattern.

This patchset introduces a new swapon flag, SWAP_FLAG_SKIP_ZERO_CHECK,
to eliminate this redundancy. I introduce this as a per-device flag
rather than a global setting because traditional swap devices still
benefit from the swap layer's zero page check to avoid unnecessary I/O.
By using this flag, userspace can selectively disable the zero check
only for specific backends.

Furthermore, on certain architectures where the zero map is managed via
a separate bitmap, skipping this check allows bypassing
the bitmap allocation entirely (saving memory).

This modification is based on the previous discussion with Nhat Pham [1].
Additionally, this patchset is built on top of Kairui Song's recent
patchset regarding swap table and zeromap modifications [2].

Tested simply with zram on QEMU to verify zero-filled page handling.

References:
[1] https://lore.kernel.org/linux-mm/acQvNRLpHwnHt7i+@yjaykim-PowerEdge-T330/
[2] https://lore.kernel.org/linux-mm/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com/T/#t

Youngjun Park (2):
  mm: swap: add SWAP_FLAG_SKIP_ZERO_CHECK to skip zero-filled page check
  mm: swap: do not allocate zero_bitmap if zero check is skipped

 include/linux/swap.h |  4 +++-
 mm/page_io.c         |  7 ++++++-
 mm/swap.h            | 12 ++++++++++++
 mm/swapfile.c        | 14 ++++++++++----
 4 files changed, 31 insertions(+), 6 deletions(-)

-- 
2.34.1

