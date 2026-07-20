Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 493ACC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 16:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54B26B008C; Mon, 20 Jul 2026 12:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C4A6B0092; Mon, 20 Jul 2026 12:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941F26B0093; Mon, 20 Jul 2026 12:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB256B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:29:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B777712016D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:29:42 +0000 (UTC)
X-FDA: 85009691004.11.CA626CD
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf11.hostedemail.com (Postfix) with ESMTP id ACEE940009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:29:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=IQG3CFMW;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=FIhS63Zm;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf11.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784564981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VnZuqxzRT5Eax9lVo3hxWudCc264PtMVdVhe+jK5BZ0=;
	b=v1V0MaimWb6GhaprCMP/WCk1kVnvxPF8YDsqE7llfzY8C/l3BU/avfea2pAskwsmOsJRdt
	PLIO1rXw03SssNRnWi51e75AC4mXGlI4bRgRMPhPEytBCThlisq3H/NbPEQncCEN58bEgd
	MHT31wyrCPdnhhK6nH8oe/AzLRL7LE0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=IQG3CFMW;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=FIhS63Zm;
	dmarc=pass (policy=reject) header.from=mailbox.org;
	spf=pass (imf11.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784564981;
	b=FpKdHdxKrAvNalgSzaqN52NW7wvlI00n2kQ6BDoojMGo/aH83quAQPZgX/2LhAHzUsIXVU
	QMFQ5oduytPyNfFTx8jY2vQnfPDDABaJSwNeWR0gxcuyfFrY8GIw8IPEcUT+6oUxIzbMwg
	908q45G8VYV9kNxzOOp3EkVDBwHZCT0=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4h3mF871XBzKm61;
	Mon, 20 Jul 2026 18:29:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1784564973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VnZuqxzRT5Eax9lVo3hxWudCc264PtMVdVhe+jK5BZ0=;
	b=IQG3CFMWLs9PijRvRDvY1Q/2jst+jPooHxypeHSMujkVY8S5L6NQwzqStIbDetngo943sj
	8xPXSrzzKRnWaUlvFXaTfPPuu5ZTPcAPZT7JkAAUNu4Kw8QtNzMu2i3qlqHx9Nv1+1E5XT
	sovpOx4RS8FOkL5SjCzsWidkFmz0LLoz2Iyq0Lqa21+G4smSADPnl6KSuQe+l56BBFjrdT
	mTrYQ0C0liy44PcVoiLSQrD9SzAYjLFRk5iLIcCgq0WsRM17QnFe4GxZHkUO/Y2GCKYWOI
	73l37Z/24CfYKY8X8Jmr5WhbuvzZ6BabY0AiBbEdC5qerxjvUrLKGLPPEianLg==
From: Manuel Ebner <manuelebnerli@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1784564966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VnZuqxzRT5Eax9lVo3hxWudCc264PtMVdVhe+jK5BZ0=;
	b=FIhS63ZmWIo7FZJHUDBVyJSvmTNfpOa/oXE9QyPP9hUXSe2HFxpypLy8G0zeFWdi61WjLY
	kz5BaC0r7+8/shKAqTa6cI14peXbVKochRXIYhv1p68seTTqA+vVDWCGQcK0GNdP0qTwjQ
	ZYRMLzhV/LTkbf8jm+/a45OEW45VW5JjqLCWSy9JcOweZwbaSbO8lVKsA6YBJMH/JPAodC
	oEtTIeBA3rntjSNHu45eEeVhfkdR9pSPRO04qZ87NLHN3Bwb0mI3S1FJpo7Fl10vK94JF0
	LlxsbmJd9ZWvQD1OOmc4IE0D5MMJdO04mc+T7hKy2os4oJikwdgwis9bqpMPQw==
To: Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: Linux MM <linux-mm@kvack.org>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] docs/core-api: memory-allocation: adopt type aware kmalloc_obj
Date: Mon, 20 Jul 2026 18:29:09 +0200
Message-ID: <20260720162910.1714718-1-manuelebnerli@mailbox.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: ksg51jniu7h59xjwyyfzzza3k3m8damc
X-MBO-RS-ID: 3a2a5c4c1aad3b6e586
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ACEE940009
X-Rspam-User: 
X-Stat-Signature: 9e7hufy17o3d511qagwggd77dmokqmg1
X-HE-Tag: 1784564980-533877
X-HE-Meta: U2FsdGVkX190SV4BHAb7CoDBLYZ4j/qXApdaH4n7mDrZADQhb4NyxpyUnVclPh3Qrvaaz8fQmxZB+iOEu2JBv+Y3xfrD8GbcRr6gOPwdHmRYpoTaOMK6DXS3yDpRBnjdIdYFGqj4c/seCCaHHrN7CeqyKc5piXzhO+Zra1Pco4M/a0LP5JrHDuzqmNLS3YpgEyr02bFYT5pHCpGD1izD4XQoc+0a6aeLOdkc5bj3xDCAJ/Jk1O15SWhgSeCZwCfkJ0Bc0NvCWdgS/FbunOJujl6GCfv7MvomCvyH/1I94UEnzQv/+qFVj4v9b4364ewCAk0thdFkEbtQ1OmkaUpemzr/cqI2YEL3v+SWStgTsO9OsBe+qzPPFHHdXXO8htf8PXS0vtW4jD9PCyDYlntDqD5U98t3oDUFVUpg7yFq2DED+kJhqgDKNSrOAjJ2UnncO8RjOTcAEPsHF9Q5zh62+h58hGIz4yLONYTETEwXRyTENNUadqioHzF/MJ9VV9H916D3d9fj5OlJiOvz9xTDXjmlI8FUnVmQ25BJzn48k3rzcwBlNVKLPI5IpuNLtgg0sULn0rQuuhY4qnZb8p6scMYlUZIqynymVwMrzQVdSLlz3ipEvBYxdm7wuaFLGGOlEx5zSxuCnffeUemfxkYbYBkKyDOWRc7xJ0N81zSITDdr4swBHIRlQOolXpKBi3mzdTK0BTxGSLNClmUgRYhQbGlYow63SHxaLzshKxj3LgefFfY7SmnhhaN9ggBoeQfEFRTUY+CnfEeo6fQ7kiNigdIWXWPAylUT/I/YcQcJGWJfDvrHgiDs62b5fK3wEBLbbEBw+n+LPiNwWY19hLvn1GU0Oy03f3rvA9CELwWmtaO6im4Z1S8SiT2gqOv1oza5VXLT54cVkLIMhfwwlsHT0D13XjzJ9gD5lFaOxqiTcuKNHICHkuByU1YydAX9ZcVu7IlsbElUtYGY2ippeDr
 F296c7Gd
 fJODmNCkrzXjqKyvWO+DJ0yQRji75nE7UUnxjl30aFL6BRhtKfoLtUppDHLmHcwCd3FHJ6Jwvr1kKw1flrgqUsoVADZrXAX69Ekm3cJWvNRmuBy0qNLlkgpSYZ+pUlGZTidPX34MWEkOFgMEIAgjkYsuBEFc8FHzbzy0lgub+QsKNdFmM9gxEQ4m1BMpnLZ4E0OG7XauugROvIBevpUESNy/lVFBwjHRYR7444BLFs0bY3BNp3K/wt5u+VvnP2wSuTb3QYWUtcp2M1OH2z6vgRvOUr25d8FLug4YpQ0CoOUn9ByphzrfHuLlZcrOImWGh4DD6ZybvN4HnQvBoCAS020mr6KRgclrxLy+N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update memory-allocation.rst to reflect new type-aware kmalloc-family
as suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
and family").
Add 'prt = ' to example because allocating without having the pointer
is nonsensical.
Replace *alloc() with *alloc_obj() or *alloc_objs().

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
---
I have no deep technical knowledge of memory allocation. I tried to update
memmory-allocation.rst with the help of deprecated.rst and some research.

Therefore @Kees Cock: Can you review my patch?

I couldn't find any clue in the kernel doc of the deprecated k[mzc]alloc
functions of their deprecation status. Is this deliberate?
---
 Documentation/core-api/memory-allocation.rst | 21 ++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
index 0f19dd524323..d3d8b39c95eb 100644
--- a/Documentation/core-api/memory-allocation.rst
+++ b/Documentation/core-api/memory-allocation.rst
@@ -21,10 +21,11 @@ answer, although very likely you should use
 
 ::
 
-  kzalloc(<size>, GFP_KERNEL);
+  ptr = kzalloc_obj(*ptr, GFP_KERNEL);
 
-Of course there are cases when other allocation APIs and different GFP
-flags must be used.
+The ``GFP_KERNEL`` flag can be omitted, because GFP_KERNEL is the
+default value. It is left here deliberately. Of course there are
+cases when other allocation APIs and different GFP flags must be used.
 
 Get Free Page flags
 ===================
@@ -133,24 +134,24 @@ Selecting memory allocator
 ==========================
 
 The most straightforward way to allocate memory is to use a function
-from the kmalloc() family. And, to be on the safe side it's best to use
-routines that set memory to zero, like kzalloc(). If you need to
-allocate memory for an array, there are kmalloc_array() and kcalloc()
+from the kmalloc_obj() family. And, to be on the safe side it's best to use
+routines that set memory to zero, like kzalloc_obj(). If you need to
+allocate memory for an array, there are kmalloc_objs() and kzalloc_objs()
 helpers. The helpers struct_size(), array_size() and array3_size() can
 be used to safely calculate object sizes without overflowing.
 
-The maximal size of a chunk that can be allocated with `kmalloc` is
+The maximal size of a chunk that can be allocated with `kmalloc_obj` is
 limited. The actual limit depends on the hardware and the kernel
-configuration, but it is a good practice to use `kmalloc` for objects
+configuration, but it is a good practice to use `kmalloc_obj` for objects
 smaller than page size.
 
-The address of a chunk allocated with `kmalloc` is aligned to at least
+The address of a chunk allocated with `kmalloc_obj` is aligned to at least
 ARCH_KMALLOC_MINALIGN bytes. For sizes which are a power of two, the
 alignment is also guaranteed to be at least the respective size. For other
 sizes, the alignment is guaranteed to be at least the largest power-of-two
 divisor of the size.
 
-Chunks allocated with kmalloc() can be resized with krealloc(). Similarly
+Chunks allocated with kmalloc_obj() can be resized with krealloc(). Similarly
 to kmalloc_array(): a helper for resizing arrays is provided in the form of
 krealloc_array().
 
-- 
2.54.0


