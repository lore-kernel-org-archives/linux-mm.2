Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBAD4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9758C6B00AB; Tue, 30 Jun 2026 06:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926C16B00C4; Tue, 30 Jun 2026 06:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D816B00C5; Tue, 30 Jun 2026 06:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B55A6B00AB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:27:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7C8C1A03D0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:27:19 +0000 (UTC)
X-FDA: 84936201798.23.357BD4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 26DB78000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:27:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ij0/X3OB";
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782815238;
	b=zHHxZyh0J/VHYz9RFePKzihwwV2ehIgN0GbYEtCVtQF15f6jpNUZsGEpR1FYyLIjk5EDKS
	qJD/b5R6Ha90YgSis8/BNK+0/TAyHfWeZtLSeYG3/x0LDcoNPaRZQD4E+WijsFkLFm7/S1
	cxegvjEDG9X0O04lqE6hm12NFJtZeqU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782815238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+nYWrX07JlaFQzXJIQgj7pMrZxgun/XWbsUf+czLcVM=;
	b=HlcCvf6wJWnugb8kirhYD9p8+7WVHlSBPN0ELjlBvQFVFgyEogXuYOJXA+lGbrQ+9lW11h
	BP4o2kdn8O4Wm5lXHdXHmXL02TSj3+NezKj6Sr+Z4lKV6d9IavHl3/PLkhGGZCCKcZNHC3
	9WaBkh24yUL+LVadtwySlR00g0vsXWY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ij0/X3OB";
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CC6A4164E;
	Tue, 30 Jun 2026 10:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8490A1F000E9;
	Tue, 30 Jun 2026 10:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782815237;
	bh=+nYWrX07JlaFQzXJIQgj7pMrZxgun/XWbsUf+czLcVM=;
	h=From:Subject:Date:To:Cc;
	b=Ij0/X3OBsv649sZ8kUBK6iRv04bfxCQxZGiGivCgRzUNKGeChGY+I0CCIa9sghyEc
	 jMrnPZauWJQqdYAqzmbKDLhMyM5mbK6fpZ4X6y/y2GfnT3G10Oxd20S9b9SR3iyQzL
	 ll9EepMUa5oiFSwf2gryT8CzTFwIRnhbsCg7oMx7oagY3kgPlXp/cEYKGURy+Sdgdk
	 wEjsO4KcsAMqCY9XTmrHwRKA5n/2jq1vT7paXv5V+pZK8rY999MXTwj1vFeiZCi5nK
	 kgdApegIUZh7szoho2xgHudVWOR7H6HvaWCOEP/soHPG5jGWEviVA1xqpZoyzR+d2N
	 Rz3nEbH++LePQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/2] USB: replace __get_free_pages() with kmalloc()
Date: Tue, 30 Jun 2026 13:27:07 +0300
Message-Id: <20260630-b4-usb-v1-0-8d547235c374@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPuZQ2oC/yXMsQ6DMAwE0F9BnmvJpFEGfqViiIMp7hCqGKpKi
 H9vUsZ3ursDTIqKwdAdUOSjpmuu6G8dpCXmp6BO1eDIBQp9QPa4GyPfyaUonshPUMvvIrN+/0e
 P8bLt/JK0tXVrcDRBLjGnpUWNcJ4/kEcGLYEAAAA=
X-Change-ID: 20260616-b4-usb-b302cae4004d
To: Alan Stern <stern@rowland.harvard.edu>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mike Rapoport <rpppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-usb@vger.kernel.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Stat-Signature: rxfa5wyi8wuy6ygiu8nhy1e95yoew8fn
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 26DB78000C
X-HE-Tag: 1782815238-837180
X-HE-Meta: U2FsdGVkX19nDqd6r9VlZOvKBlvQOv285L3hG90oqTVLU/URNDKySWdw++LypkfBMz1tBr118p4h67IdmUhDHZaFFppwGXy+NWlDcqhTw6EgpEiA3PdLg3zJlOa0ZmNNhgq2VMW9TImC4bgMaFOsCbJSmUH38lX+7uxrsFkxAA7cPsjeq79cwPBqbe8JeFVhLGZHjpFYpt5djNymeW6u1f9tQdGa+RoGHw350upAhtdxl49T0eMlV7d36KTdk9WgNd5cwF2qcgaEQ+n9TPvvOZsM2gobnQqqmV8RfuvEEhyXIQQC+rT6GmD37+rtrplG5KlH7RtCGtv13G/ua88HA/yWulyrmUMc9mpQpCVkw7Em1fO0cjMrPd8X6+Vus5phE3/4XSOEbEfKp9ScIorbj0BC04B3tHGJ9GfVjd/t2Ma2/1D/x+u4RDauF/O1btwDQLqV/gEdnB36Pvaghwd7TL6W/BjfV0rQhbFVGtzUGjCIPVhs26cuog5ROoKgMUmH12pcG/Szx+wPN3s9D+ozV9NNnejj1WGc4k2r++C08gicgxMxzbCUZG/EFBYXLlTIPvGprPi368hqMCKw3bTmV0nJQFfoLHgBLN/3F0xe3mT5AZnGtz86TQqn798laVjpA1uDVva1FPqElQMLCi7zYDoFSEU1J+zlxqgdTrrxVz++4xm3brFu5q0dLMNScMqsEeFyYr2BZdNrS1/p/9KCOUnhlpe096qKUUEKV/aAEznBK6k8rTQrMjRWpvHQItKnLxyPIm4v9BH7tsFo1UfsrKxuhbkqvuqmmKmmAYO3bq/6Z9FRcnpfxIDNN/t4w3/PDDRlF97X3x6bbNEeUsIgJ3GlBQdCp1FRAzF/YQ21zpfrtxxBBw8Z9BDELqr2ubE4YOLnA29nvVriHOl50M4gUgQKPTYdFuoRYyFNJAQxDpqH3ySWPlEInPbXSrF/gctTv6PN1wztXOf3ymbIE/p
 jYKRYoFf
 k/QftfJXvHCVa2ZtpxrEEoWvSCTUnV/soaEcyPNr2hbaaNBN7G+TumDSKP9in9dXZWfKYyPuEg4iMWETZ3JDYikgO/4H9aZowI7eDefHUBDBnSoei/fejroK1jtpV/a52mPbqEIxKH6pOteuTGVj9fDNsrwvgrEV+T+3WFLJx60SrML2abVdjqlHGLOmZaIMf2X30gGnMIHEcwDU6ZlVxsBRnipQdp+8AdG8FiiJpkCt1Vx+tswoxMIUbCPl3XcecYvRqBYvXTb1z5XxDlO/Z7wk3NQMBTZhNvu6OymDfyxwzzLjeo1yrjY3ZQg==
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
Mike Rapoport (Microsoft) (2):
      usb: host: ohci-dbg: use kmalloc() for print buffer
      usb: core: devices: use kmalloc() to allocate dump buffer

 drivers/usb/core/devices.c  |  7 ++++---
 drivers/usb/host/ohci-dbg.c | 11 ++++-------
 2 files changed, 8 insertions(+), 10 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260616-b4-usb-b302cae4004d

Best regards,
--  
Sincerely yours,
Mike.


