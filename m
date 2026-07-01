Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77A7C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7B9A6B00A8; Wed,  1 Jul 2026 05:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05B76B00A9; Wed,  1 Jul 2026 05:42:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACDB46B00AB; Wed,  1 Jul 2026 05:42:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8A26B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:42:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A5DA1A02C3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:42:02 +0000 (UTC)
X-FDA: 84939716484.24.F580857
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 63309180006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:42:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aqERfpti;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782898920;
	b=c7Pw3q/WybNZrK9y2Qkr6sTMASiQiHdDCyMOEWjPyWh9cZYQ4EPzpAaph7EgN6sMv0MgC7
	YmmfyYBnd2lbl504r+FqVX6az/D3lyxLdvb17bBoSAdL+Abxx83/ib/jCNQnDYJwVU87+7
	uo6ES+8YI9Kqo9MXGBl0zIpZCBK8r1Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782898920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=e0uy7x/pJ79r/rXJ+9S9E9BL/ogclOfY0Gy5f24mEKI=;
	b=8jVPT1RBnct93LvIcGm7wSTRd9sC3seVW2kJuFfr8t2mxrl0Ts1YiKIF5eo1jtnaf+sOSf
	2GWx6A5jM1G543PrMUSH43COLpuucDSbZq7MUeGuAw1nw565KH5c7w6VRqeEPSBFgizLe8
	1dsxwoKO0k1j8r6XMBo/uHgRPmr501c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aqERfpti;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC31B60138;
	Wed,  1 Jul 2026 09:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34201F000E9;
	Wed,  1 Jul 2026 09:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782898919;
	bh=e0uy7x/pJ79r/rXJ+9S9E9BL/ogclOfY0Gy5f24mEKI=;
	h=From:Subject:Date:To:Cc;
	b=aqERfptiIxjejW8vzKWxznsIUYrh+beV8btiu6X1UlMJSP2L/oLkqvqJcf3pW5GHH
	 j/vB7c6j+GdGvphhLqwQ/7BMe5P/al7wLvn5diuBGtnn8fyaQug5OPd9hGfcRTTT8f
	 MQKAGQRfkkZfNto+ZpWoJId7sSTXuh+nLJseOCsQ91Axgto8HxbGbSv9UmrOLIEkAr
	 uzkq5na7eGPRr2w5rXxew5VaUrYptTLtnbRmhLQvhKE1p0G+h2Ndpqmh1idc45+PLY
	 uZmMOY2qZtJ3f+AmZu1PDhgQMQPoX5h65NhrH1ndzje8BzndQmwyfZHJzBk/WrF6Qp
	 z8aFUDw27lRoQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/2] USB: replace __get_free_pages() with kmalloc()
Date: Wed, 01 Jul 2026 12:41:49 +0300
Message-Id: <20260701-b4-usb-v2-0-272807df4b64@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN3gRGoC/zWOTQ6CMBCFr0JmbU1pCxhX3sOwaMsIVVPIDBAN4
 e5S1OX38v4WYKSADOdsAcI5cOjjBuqQge9sbFGEZmNQUpWyzEvhjJjYCael8haNlKaBzTwQ3sJ
 rL7rWX+bJ3dGPKZ0czjIKRzb6LkkJk9wFHnt67wfmPMV/W1r+t+ZcSHFqClMpXXhdmcsDKeLz2
 FML9bquH62+4ezGAAAA
X-Change-ID: 20260616-b4-usb-b302cae4004d
To: Alan Stern <stern@rowland.harvard.edu>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Rapoport <rpppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-usb@vger.kernel.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 63309180006
X-Stat-Signature: h3t6tekqcjtmgj8z53894u9r7f8pdd4k
X-HE-Tag: 1782898920-711327
X-HE-Meta: U2FsdGVkX1+p5I8652ZMIANkwA4M14XZPAfmPNdhTMiiBTlewl20OnMZ2O91DWQir9svlt0o2JFahggHU3Xlppv1dEUeAaMdGosLeO79iC9Aw/1XURJ/4+vVpsu1QniSik3C5MZH+CXXZtfaDshgrwHBjShJGSJytbLRXy0ceRsZZU1HxcRMHQ5HfBbpPPLN/HXuMEIp9Z3wLhCtoFrX0YJ+6oIbOt6wKdM4rhwk5ASnxFUN/6BKdlw2U/hTFl0h749dV6Df+7jKhJl9OGGKbh8EJq7weLY3W6keWt+CRNZcc1q7YdGrxODe6pIHiDeF6rV1qSCY17zV4UBQo1k7rXYic9ISKzfPFYaoqSRVC1+A3479edyUvp0/e2vgesxALmz8si65ThhDXxPW/Wqgi4Vfx8ArZKHFCWQdDRX+a+Y7XCyJkS2aVPvIC6UwIFnvA9aHjmkcq+rVdczFIW7TuN5XjEza+x9VlDSxCF9900sna0V6Ikq6XXcuIeH5RGB9E1oNnPwr0HtjT1kt3Z1ayRQHPBOlqCHCYtT7xm7wOdSfNg5hVi0CGUHY5KA5zv0l1bRUV8c3d2jCDAMJWowiDdW+KuV92dNH9qHOArDCMqZdOBSeiA1/DdaoYiSIxPX1zdJS0INxPTyOCB2pSDdIeoS0CKBnPqmZgOQ41RCkpekz2RvQNwcEf4vzWnmxP524fAXIHZfT8xJsTkSk8qFkxTv4X2GQDr4RH4munKawrhZvnybipL3+cXbPWYkr5RVmrkS13nxY8lpXMfKhZjhhSNfe5JXwoVIT8eFgsJiFlQw8udFlHMXImbsM2pjhy7RitZ4oUcwyp/65ubM+KGambQ/t4BXPHpsThF8a5W9cArukK4HfFtfQmXV8N0f+r076xTW1YbSnl/R00ajarRRQwklQ6gPmZ631z5xR/VydklydrOUc9SW6gi7pOn4rQT43q7beMalj4KObPFUQCUi
 Z2aBSpHj
 hfIY8cvka1mZ9mq+LVVwbEYE9ZLtq1xmbheixWRK+/EC/Ct7eluV1gXzFPx9T+FWRiVGPh9a0VcCqvkSewrLm/AHbYJ8VBk8btlqYbYjiIhQMgV4IcsoMNHOnINw/TAeEKDWW1gwsPKVdbAioAdUCCnZxx+k9upvtt2qIqYhZB7TreK178m1FiwZ/ESXWUQpxKJG0AfmjPcFnWcNlfu7NeEiQ6q4h3Pu8jE9ouXaGbElhOa09xp5qGPL3gFQGbxbpimplPXMeMRhP6U1QjfW1s2qGR4j4hX1/Rs2Pp3BRmOha05LGjy0eCRggBT5AXXMJqIcQci+l88wMSEyK4eZRSvku93XhO0bE1HIt80Wt7lueHunnIu9xa+M1IwAndRWqnlaIaliFET5HIhU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (small) part of larger work of replacing page allocator calls
with kmalloc.

My initial intention a few month ago was to remove ugly casts [1], but then
willy pointed out that Linus objected to something like this [2] and it
looks like more than a decade old technical debt.

Largely, anything that doesn't need struct page (or a memdesc in the
future) should just use kmalloc() or kvmalloc() to allocate memory.
kmalloc() guarantees alignment, physical contiguity and working
virt_to_phys() and beside nicer API that returns void * on alloc and
doesn't require to know the allocation size on free, kmalloc() provides
better debugging capabilities than page allocator.

Another thing is that touching these allocation sites gives the reviewers
opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
another size is appropriate.

For larger allocations that don't need physically contiguous memory
kvmalloc() can be a better option that __get_free_pages() because under
memory pressure it's is easier to allocate several order-0 pages than a
physically contiguous chunk with the same number of pages.

And last, but not least, removing needless calls to page allocator should
help with memdesc (aka project folio) conversion. There will be way less
places to audit to see if the user was actually using struct page.

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/usb

[1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
[2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/

---
v2 changes:
- rephrase the sentence about unconditional kfree() to make it clear why
  it is safe
- don't include <linux/slab.h> in ohci-dbg
- fix name of debugfs directory

v1: https://patch.msgid.link/20260630-b4-usb-v1-0-8d547235c374@kernel.org

---
Mike Rapoport (Microsoft) (2):
      usb: host: ohci-dbg: use kmalloc() for print buffer
      usb: core: devices: use kmalloc() to allocate dump buffer

 drivers/usb/core/devices.c  | 7 ++++---
 drivers/usb/host/ohci-dbg.c | 9 +++------
 2 files changed, 7 insertions(+), 9 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260616-b4-usb-b302cae4004d

Best regards,
--  
Sincerely yours,
Mike.


