Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1A84CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571946B0012; Fri, 12 Sep 2025 11:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521746B0022; Fri, 12 Sep 2025 11:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410EF6B0023; Fri, 12 Sep 2025 11:04:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2FDDA6B0012
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:04:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ECA901DF98A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:04:12 +0000 (UTC)
X-FDA: 83880918744.07.992B37D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6716540012
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:04:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lK9b1Uqh;
	spf=pass (imf04.hostedemail.com: domain of deller@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=deller@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eYzehf8Qtyuhyg6EQItgGFPFowT8+4N9IAbcGWzlcs8=;
	b=ob6tkOI8OEkIX34N0F9nal13r5MF24fO9d71q3HAi7SsDIOuSUxMQM5uQvUaP9Q9lpJOTm
	96K5LBAmfIHp3Y4OKzzob1MdxR2nZkCnG8ZOrWFReAg6JEAPvcE6inubzLSHpFwfgEvlrq
	XndKRRo+54g/MICkAlRPSywGm1Jfx7I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lK9b1Uqh;
	spf=pass (imf04.hostedemail.com: domain of deller@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=deller@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689451; a=rsa-sha256;
	cv=none;
	b=VBUnl3qA8QizHaGZyVOR06AYHVryaOvZ2aBwLPXRpW9d+kC58GNRNu0AKWutLHHq7a4idG
	h6horm99tBYAx4/TVeR7J/amrfPGzmsRwKrh2ctAW65FSNNuvvLqHMf5k8zthOEvWUZl8q
	YHPducfNqg2oSbRUftp9FaMMXcbAeeQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BE290601D3;
	Fri, 12 Sep 2025 15:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBFBC4CEF1;
	Fri, 12 Sep 2025 15:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757689450;
	bh=aJLuEIAp9V/uCGf6PEQj6zz7MXZ2gzmalP2D/DeZujI=;
	h=Date:From:To:Subject:From;
	b=lK9b1UqhTljbAj4g+blMlhA4X1wMFgzDTctN7roiK34DP+Q4F5dYp+k8DBcyTuS1O
	 D62+y0QfPeLpW7O/PUj+6nqJ34TRT0VtCHQ++HWTFpz2DRLasgNZkaj5Iijh8BUAmN
	 qls33WbB8gcWz0h6A3kDgNIASFjWJNFh+nkvl4clVY5/KhpZbPzrHnNDj4Sxv0U/89
	 W6ALLRLzRzCSJxe5qdOCXeyK15JkvTYihBh9xu/+kcrRxnxlh1A/jOt8ozpxnB0NyW
	 kIT2mGgK+Hh9pChYhYyFbfLjnPx91gOOYijmHZxI5z51Ho6cDHO1IckuBGbZxATfdi
	 1UCqld45GvkuA==
Date: Fri, 12 Sep 2025 17:04:06 +0200
From: Helge Deller <deller@kernel.org>
To: David Hildenbrand <david@redhat.com>,
	Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux parisc List <linux-parisc@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix 32-bit boot failure due inaccurate page_pool_page_is_pp()
Message-ID: <aMQ2ZjZNyNwAiUk-@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6716540012
X-Stat-Signature: naiuqppnx1rtsy4aprc6u9ghhjcd4wyx
X-HE-Tag: 1757689451-419204
X-HE-Meta: U2FsdGVkX18U9K/rZ+sImUV5P/RwtMUd8rhjaFufoQi9CL+CKKgXnSQZAChNzLjckeNlXCdANJkniKl1yVtVL71GIFCsUyzrwuCCE7teD0F/nOH8QlHOI0G2u8AnfTk3OKCRaZ81HzUAm/6b3HF7QpVg4R/tWLeuh1+hQMLmlXbk+Z8A6TG5mTWe+L++iyfmPaYIGraPFKdkltfJa0Xh/2BJAWv6inu2xKuvSGB08HUiG8BFJ4fwClm4qTnxm1X7CW7Yp+HfQ7OAmHvnLpQiQLgnUQwyJDkjZoaAkNlFLce6OfINZ5ogsKcLvJm/afB7olwYSYE4/OC2Ls4LjAZquk7+3AtbPD2bnBff3ID47CH2GAO8FapjOKhQxWnwBTxFRMOt7FI7P1PIng7HKELutNb90hh7aKU//7v23HY7JqKwcaUCcTIaj7JlTLY0WwPEeC+iI7CsS+A9hdwdOIzolHEFqx21ZceDzWmU1nwSDH98Vamnf4qd4avAWY4urJ8wpvssIvu0kJVxL2QGRjCcfNhzOHXDIFsABpWsgxTp0IBf5S6EI49LQSBkha1ErO/3nnH9W/drD9ta215fhnLQvNuCs9bGcL/VtlB3xZQXEbE9gLU0ATCrg5i/UcC/vDs46kJjUWT7iCTjBdtNzwnQtdnWGO161BWbrSl06KocM1lhfWL2iE7Azl5GNjnzRXYTUtPUwZAVGM99sSOWZbhND0TzSSedsKDqgH8GNt8aCJqIc7CwmFPY1y3fm+qmrte/ILx9rn8Gq1adelaI50FQURfRgJPZlW7oviCACJv7HL5o6QXPEB3GLymMZhu78UsEk0ApYtpRx+2Iskp8EKHvL7hWNyNo0tXEpNeboj57LJYSlBapbXynjtobcwoIhIkDsJ7RjIIVRqt6vMUvnGRiqeX4kY0Ft9qCCqb000jwGOvVYyAR/m/nYBFoFamV4eKS+SoEFkPahbcL8WPkRqt
 npZsSvRc
 VLS/+vpgP3q2rNe6dvpQDfFcBlO0oG9MY7skurtGL9Xfyz2tF/9BHZTcTAei98TOJDew6AhlttGY3iayIJC+H5nOOyAY7ykAy807cUEa1pxk7ETWFkgkBc3qjSoXqopvjCbGlqlkeVpDAYAPrkNpemKItmWaNb5eIxngLeVGqaJwi4urv3SEcdej5LAD6NdOWprWrZmrTQWP3KPo1uivPWWJQk6XMVDTXBemjR8HZcx7bJ930KE3HXzfOHrcfgV7kMot4WQU5wHQT6iyRMDitOhpwMEkyJ9sJNnbupL40dj7aavIoiq+v/Iv/o4/W7Jg+0cP5ayfOoPVfYHidd7BY2ffK2MYErGobeLn3M4ltYoRJ0ezvN0J1o263C4hJ5C+av7zL44yI2JEugZMYh7GiWQOdftRCMNaj3xxjanC4ZyqG2Nx+oQaAu8ihKYd//u1sjTsaFevAuJSeGyDzuRvLQp9W3EyW2tRKX2x619zTHN/z/bpuBMRvwKKoDxE2xcoA6oVIcmzBEMRt/4ng+HLIOQuIJef0i+Cd+pQ8J8Kq5glKo8lzUkiyMRAAlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when
destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc000007c on
32-bit platforms.

The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify page pool
pages, but the remaining bits are not sufficient to unambiguously identify
such pages any longer.

So page_pool_page_is_pp() now sometimes wrongly reports pages as page pool
pages and as such triggers a kernel BUG as it believes it found a page pool
leak.

There are patches upcoming where page_pool_page_is_pp() will not depend on
PP_MAGIC_MASK and instead use page flags to identify page pool pages. Until
those patches are merged, the easiest temporary fix is to disable the check
on 32-bit platforms.

Cc: David Hildenbrand <david@redhat.com>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Cc: Linux parisc List <linux-parisc@vger.kernel.org>
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Helge Deller <deller@gmx.de>
Link: https://www.spinics.net/lists/kernel/msg5849623.html
Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when destroying the pool")

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..f3822ae70a81 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4190,7 +4190,7 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
  */
 #define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
 
-#ifdef CONFIG_PAGE_POOL
+#if defined(CONFIG_PAGE_POOL) && defined(CONFIG_64BIT)
 static inline bool page_pool_page_is_pp(const struct page *page)
 {
 	treturn (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;

