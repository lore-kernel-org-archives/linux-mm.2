Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29FAEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED28D6B00AC; Tue, 30 Jun 2026 05:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E844D6B00AD; Tue, 30 Jun 2026 05:54:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D7D6B00AE; Tue, 30 Jun 2026 05:54:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A60C36B00AC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:54:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 290968DDBB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:11 +0000 (UTC)
X-FDA: 84936118302.02.64C8203
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 95F1BA0009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CKVSHJxA;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782813249;
	b=yDgHeZRAjoWPF6GcqdnmFeUBLId32vFAhInckcy9WP+8HL31Q0tiwSFFP4XXSC+sbdJEI6
	jEq/8H4HGfTAjQHjn6GHc/UuKLVkyPbVA0PyrZ1/4gl90dO5Hxq76b3j+hasKWwmmuwqFO
	eEo0SHlG8OGN0Mq2KMbzB8MbiAwzpM0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782813249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qHdjGsIhJ+8ibgAZAo0aWXS4qbeGOWvcwxs3o6/Dxk0=;
	b=nfF9DuU5plG/hVjA5OexDMjeNJ21nT4lpRXI47iZ0+ayYiw+f0ppfTXa4TO7DNy73g8peS
	Eifrbuu4pJq8rYb6Ae9ofImzYHtBuVu8T+lDVKmEJn+HealZ20BvzQQddqtgKXtQvsaL71
	IM4kvDZ+N7Y7d7Uf72wt5g5J3yKo0PI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CKVSHJxA;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03169600C3;
	Tue, 30 Jun 2026 09:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB081F000E9;
	Tue, 30 Jun 2026 09:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782813248;
	bh=qHdjGsIhJ+8ibgAZAo0aWXS4qbeGOWvcwxs3o6/Dxk0=;
	h=From:Subject:Date:To:Cc;
	b=CKVSHJxAPE1lT77XrFx/EwdRsgolR0yEMv004ju9lIT4uEOOACXWfYPZoFmCM8Stf
	 8FkIpUqHwkwx0e7Py9kYxoxTqzZL9ERzIERYlMd8chFj6oy/XFcqU6Mz9yELOhaf7T
	 pi0Am0mRaQlno0WuP8yJ3sY5OsIV2qCg+biTKNKRNJiqVLv7bdeNprnQC4R6s7xOjx
	 adzDFTnh4cZV1j1ljrPwaM5EZUNklF4Li42JvcpJgpHzBkOCCNhla8Frxg8C2odkJ1
	 HW10EsDbk4hfa2Srt0AGj0UgVEM2sFKdbQMekTSOHBoBlEyDTBRDOcW32SNDqa2rhG
	 2+gb0M95WvImA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v3 0/4] tty: replace __get_free_pages() with kmalloc()
Date: Tue, 30 Jun 2026 12:54:02 +0300
Message-Id: <20260630-b4-tty-v3-0-a8476c66c582@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADqSQ2oC/2WOyw6CMBBFf4V0bQkthVpX/odx0ccUqqaYFhsJ4
 d+lmBiNyzNzz52ZUYTgIKJDMaMAyUU3+BXqXYF0L30H2JmVEa1oWzV0jxXD4zhhrlsQlWXEkBq
 t4XsA655b0en85vhQF9BjtnNCyQhYBel1n0cb8pLmVe/iOIRpeyKRXPF3LxFcYWGksFyCbiw9X
 iF4uJVD6FA+mOiXV5OPR1fPcsKEYNwwsD/esiwvxF31sQIBAAA=
X-Change-ID: 20260528-b4-tty-7c6e90f41d13
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Stat-Signature: 5ntrs5imrg8jge3i1sp9bennfmbneqa9
X-Rspamd-Queue-Id: 95F1BA0009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782813249-757872
X-HE-Meta: U2FsdGVkX18/CfwMGZ338J1CsAvBfglr1gTQK4QZF9nAjlHG7Lo0+ppN1EgzlbOEx3FQONaMm+AM/HGmma2WvVBM3Yf5txBTuC8XyFz4QJdnPHluahythqlUvgslP08cdCy73YeDLcgY/LDdOqWcTrC5KJ+TNGPKsBzJjXfJB5GfROzZ63r3b5igmJdmu56qhri2UwFEE4rgk1LrCQBgkCbx+dJX/P2cgC/two1t8ce6ael1OuAlMSb5v/ppy5o53YBx8XKVwyDX0WPHuocFdY578SVv49xsknS5AWQ46LVMCjOBWmLMWTJc28hr7jBt75zQmGbUVGPtc1eeWx1WDbgGQCLwGYsHS2STHsTTyKeYPdPl4B2goyqwxflbbMTqAQg57DvSu4lQrciXWrKEnX4phHvxFzSmQRnzOBh9DCwKxUohVmdVhvrfdco36l5mauTplL+WxLrah1eChz2Dzn1TqtqDIqk58eIcwe+qZf33/whaxTTAauf3PYR0Q91G5GTUuKAToS4bGk2heGUgzbmssuCHs926kWof5a3qNrJAeQgzBacoFIqFBS1PwP3VuxU3N3Bu8A3XoVMC7XrPuBBLzdrMh2GUD/0YC5nK8HETA8ycYF+X8nROeEXfzSDoy9+luueLClrxPio8ZlkIpTRTEtc+Hb81jGKOQb2UcRjrQhaU9yrFBjeAeiFV8sciePkcM3yuN6xn5NDnWQc9dbl1GtpIvjjbkQotVlLCVUFCjAH+rnNGqRvFfoBcMZb5cvFiRepHR5MwXVZxbLyoLcL+l3inQ8fXPy36KNmE+2ay8Q51VJ37j7KuOXBila4HD9XBMDF1RLaU1YojDju4NYYJIJ3f4YscyS2Z91Msstd9yUyNLzSfJBs7G17TSjzQ6dqG7uceFn8LOk0IqDhDPFtw4M6jqBLifnkYbwRjhOffsUag1vV6Ob6x9rGNL8qTLz1daYaW4SuI77e7aja
 T6JqrNry
 6+DaO86B4sq91Ni+79utHyHkUPfPWQoOvxZr1Lxa2wVjFwr/iJ810N7mV0Mb6VlXytM+XVMDepig6sP/VfqZnZfXWf84Id6tr1dS0aYhYabKtscmRVvEu7O8wW3coiiyNnoLPuuQTBiwnTmq2MnpZiK+J6wr56CLxGV2N1mXFn83cMUS7d8m3TEYNigBGQ6h6jYYTwmoxPl1gckIYdKGMj86WnP+x2+WMaSri18OQv8ufvA1YGXaB1cy++iS/4MMnhWOpqYjvLqAt0fBDjCOjtYkCzkLtNTxlw5eyxYLadyWimqbyLF8QhgHD4FYL9C5AN6nfXhdO/phZK3F0SD0JucIoHXR4T8N2JliKa+ecaWF6YYeplzRyKOeKcVye0r4Xvmabpn5i3EAIsRRyKaXhLQWZ2MxV2qHGL6DcEAdlXvBrsCG7r8CjdfGpuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (tiny) part of larger work of replacing page allocator calls
with kmalloc.

Nowadays the right way to say "I need a buffer" is kmalloc() rather than
ancient and ugly __get_free_pages().

---
v3 changes:
* rebased on v7.2-rc1

v2: https://patch.msgid.link/20260531-b4-tty-v2-0-f7149947d4ef@kernel.org
* fix placement of include <linux/slab.h> in men_z135_uart

To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org
v1: https://patch.msgid.link/20260528-b4-tty-v1-0-9da9f7aec5f2@kernel.org

---
Mike Rapoport (Microsoft) (4):
      serial: pch: replace __get_free_page() with kmalloc()
      tty: amiserial: replace get_zeroed_page() with kzalloc()
      tty: serial: men_z135_uart: replace __get_free_page() with kmalloc()
      vc_screen: replace __get_free_pages() with kmalloc()

 drivers/tty/amiserial.c            | 14 +++++++-------
 drivers/tty/serial/men_z135_uart.c |  7 ++++---
 drivers/tty/serial/pch_uart.c      |  6 +++---
 drivers/tty/vt/vc_screen.c         |  6 ++----
 4 files changed, 16 insertions(+), 17 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260528-b4-tty-7c6e90f41d13

Best regards,
--  
Sincerely yours,
Mike.


