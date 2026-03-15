Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32A47F30283
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 22:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8A96B00E4; Sun, 15 Mar 2026 18:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 586546B00E5; Sun, 15 Mar 2026 18:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4923C6B00E6; Sun, 15 Mar 2026 18:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 360606B00E4
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 18:45:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C93B4140A1E
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 22:45:16 +0000 (UTC)
X-FDA: 84549779832.18.D1DB783
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7D44BA0005
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 22:45:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=R5xsh5BC;
	spf=none (imf15.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773614715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xKp3gvUqk4FAYhqUDq8U6UmYthO6e2jpd9e3v+YrqkI=;
	b=z5Kwq8fOfH0f7Z25eZ36gBZbcKAh1HcfPVrW4fNJi89tm88hrAvQL36zv4kAwmgdkgJZxK
	7ZiOdUnhXG37IUYWWLO4Hwz6vtTWc+sqNDx3kqDgisT/VNajtjIBYd3pBuNSxDm9SnVgUw
	p6eCm9z2lV4HxasSA7soqw/gfJnwZ7Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773614715; a=rsa-sha256;
	cv=none;
	b=tHDgs/uLW246+rDW39mBfUvBZfYqY4zFI/9JzO/l3tcovDEzLbHWRLBK2cILh1TouSOwly
	nwWVQU39y9DZ0/Gkg6DujgDkg92GKlJ8njhCZiPGKfUZ8bgweA8LhaP4PdI15bgLYTONRI
	in2+4ayezLfaMlMXBUfl7Eq4ALGmr/4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=R5xsh5BC;
	spf=none (imf15.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=xKp3gvUqk4FAYhqUDq8U6UmYthO6e2jpd9e3v+YrqkI=; b=R5xsh5BCWDqP0dYOUh+5E3lPHo
	6fI0lpns9SOdnSL7iZinPEFyRZD/DaAOgOV9ImgiHTvYhMcrTBNoalsihWISeZ9RsjTLZaTnWUNPG
	24lGZhxF31v31N/wylvfyUXOd/rEThTnOtFokV4GXLlZWtuXPWVyMyKsA9ckcaMzztUZwZsb1/mGv
	PGP7UhEAKl8gfO44uGwogH/7LwMUsczTs1ElB4hdiMr0fvTaaoGnllYeqW7unn6hb9Fv0PxdoX/we
	iFX36ryPXOm3Jzok/eTJ8B5hM7LMy658GEDUc272/zb8gyntZne2UGFOZxFJQQPcObq/R/aGLTx5R
	pqltrPxg==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w1uCu-00000002yUR-1hjG;
	Sun, 15 Mar 2026 22:45:12 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Subject: [PATCH] Docs: mmap_prepare: don't italicize structs
Date: Sun, 15 Mar 2026 15:45:06 -0700
Message-ID: <20260315224506.1973566-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D44BA0005
X-Stat-Signature: jhj43db4xyzwosq8fkcuoetkn4ttq7yn
X-HE-Tag: 1773614714-972928
X-HE-Meta: U2FsdGVkX1+Z5q+/POWtlK5hfFroUtUabiR6dXa3d1ILYGAkOtagJDCkJK8oK+HvaFfJWIeIHqHb+iCSnoBTebvquG+2e+vtOFsJRzjq+h9oUlnfgW5Xs/IcJ4iv/CXlMX4tcCBRMe9Rs2BEXLUnZbQlQsfqArI5UUcDuptDob54NCmQb6GynVY+deTCQEExTnRBVO4YgrzRjmzbwUi1P9DuivDXgVA237qUuTwx9M4HcL+E9qqQjluCz7rzagQSk7ghMrj36/lC7T9mWKE1Mr73Q2CrWLMN9rGd8YlWEmYJYU+Lz06JygxFAShQsASg5TR5+OZCddoKanapk8+0pkvWiM806vrBHSb0Dm6S1NXrNGYGr2XLVJyzuz5c4VGk5iXbq2b0oDochdU+9EHeSb9May4Idbn9E5A3CZQdE85ixwnFMqIvMPc1jMt1ZLc53P+HW1I8kcnitukrZXGc2xThfx+DpzbkBsg+o6rSMJ7Sg/rgEAG6DEdJlV1W1p3QNnsX8Ffn6LDGw+smC+EDJkmexePliM5VIeXN8+wFzrV582ok1XFGuwD587w+AGAssJbGWJwZFBKC3HKJvLMEtTTv6ETgW7dUheq4Wa71mgefYiWlqXhy6hgBHIBk6NBf3WrokvMTbL797QmKWycSWL06VmGdIYrYASFdzzeVZWIy37jKHkP/DKgr0fFFSrbW5UIipC4ebbmna500+W5MN7jrvtUTIwYGBEcLkoM5b836dzn8hUq0ju21hvpboUl9vrum7CeXvPlGFXZZ2Ce8rMabY74rZCqZdeDw2Kg5/fEIj4pVmGkkZ3wdZzW3bOIFNlbeX6Yk2vGslCVVHKRNawL7nE3Wiobd8sdosQ2SBMhp1mmYg/N1/xRhDQqPIh5+9yfduMbc2FUdrKrXPwczeVPnT67VCP9E2RBv7/xXVFXXSENAP5CShnmOfs97LxMQ7cso8h7n392nBbI97i1
 6iaaAopX
 uu+KcPivdbpT4wPh7mIQl8GDZ02xvbJn4gyMMZYtf3eZJk+8Q46EQX8vUHfYhfRWPkfiOYhUodeEz9GzEMtjy0Jp/EL8iqfFcw5mWqRPeuxGyhthkw+hqfMgYnFvs3QTt1H/+LOWK7VEwXjOfuFsXiUWXixFcy0aD9YEfSSPALpNiREx8EB+3ZJTYypfYb0Umq0qcTY786a4lhRqKjWxuxGKFhboB2Azzmz52KhighTL+AAJ9ev1SbdwEt31YUKH2EU1LnGRG/WH4GjU2Av+AV5R+ixR0BVRK8oMJld6j/73KmOUYTJbqt/2iUrmZ2wvxb59g5IGlnaNPcZ5Pc6ZbgCX8PIKdqBP+4uZy+9B6X5ivDazfXR8hoCQivgFi10LDLbgStP1fk+tiy5ys1fbW6b0YM+OIz01dGVUsi9AnABQb7CTwS0J2BVYCQ4WobFGJJ1H+OFv+rPGxdCce1gwoh9FLbF/bmyLtBC/i0bigSgd/ZLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using a single quote mark `struct xyz` causes the html output to be
produced as italic. Omit the quote marks so that kernel-doc's automarkup
can make the "struct xyz" bold monospace ("code" style") in the
generated html.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-doc@vger.kernel.org

 Documentation/filesystems/mmap_prepare.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next.orig/Documentation/filesystems/mmap_prepare.rst
+++ linux-next/Documentation/filesystems/mmap_prepare.rst
@@ -129,11 +129,11 @@ pointer. These are:
 * mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
   physical address and over a specified length.
 
-* mmap_action_map_kernel_pages() - Maps a specified array of `struct page`
+* mmap_action_map_kernel_pages() - Maps a specified array of struct page
   pointers in the VMA from a specific offset.
 
-* mmap_action_map_kernel_pages_full() - Maps a specified array of `struct
-  page` pointers over the entire VMA. The caller must ensure there are
+* mmap_action_map_kernel_pages_full() - Maps a specified array of struct
+  page pointers over the entire VMA. The caller must ensure there are
   sufficient entries in the page array to cover the entire range of the
   described VMA.
 

