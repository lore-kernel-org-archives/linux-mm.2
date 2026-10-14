Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 979E5CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 07:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20F156B0088; Wed, 14 Oct 2026 03:04:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199A46B008A; Wed, 14 Oct 2026 03:04:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088046B008C; Wed, 14 Oct 2026 03:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D77066B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:04:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A67D1A0461
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:04:43 +0000 (UTC)
X-FDA: 85320344046.14.E7A0DBE
Received: from mta0.migadu.com (out-234.mta0.migadu.com [91.218.175.234])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3753140005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:04:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nfKDW2ep;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.234 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791961481;
	b=6r6SX8H64rEqX+Nye047ujVjbEukwD7VFJiKbCxd/QIeg7RM4bYfVf+EklXzTfvpvWV1Sp
	l1NYD254l2ENyI4NQrrVZlfH3t0cOz/GXP9T/e1rcI2yvvIGOa+fefW7hGo4N/9vZG6hMJ
	WQXoTrKC6fyRBg70NC1QZy/OIZjEB/4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nfKDW2ep;
	spf=pass (imf11.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.234 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791961481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2XPjc4Y9bbqhZZ37JB+jYlcLi2A7xqihaUAhIspTJKs=;
	b=vgBlEf8p6nzzm5qbjMdlVBoHZC3i/rgNGvUHTDU4/M6w0uCBJ5J2n5jSDtnjSyM3/zV+Dt
	60EynqFLnYckJ+vUgXUbHFQ5aJNCUe/5qYhEoZuiMib+nUIlO7SBvJrDG6lOTUFYEO0k5D
	ZuEmys5yGFIw4fEyrBZC/bQPgHYHl7c=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DYV7gVOeR2CBG2yKmyTc+5ln+eeoHJB5okAWZ+ZFVBY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791961479; v=1; x=1792566279;
 b=nfKDW2epzgA463YsdR1w5II6lfTCPu93W2w8x9w4mUo3uB8ZNO3SU/pTIWRjCcrsQTYDVCjG
 rNeguEovPcnaaxT2nNlZDkXysxlzUG0JzQ72fTo+z+rNi8PpCzG0y/dYhUTaA5TtbW2RmE5i7Hi
 hQk2sl66UUp506kxhrQ4Cl5s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ed275eddc9041163;
	Wed, 14 Oct 2026 07:04:39 +0000
X-Mizu-Trace-ID: ed275eddc9041163
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Subject: [PATCH 0/3] tools/mm: show_page_info.py enhancements and fixes
Date: Wed, 14 Oct 2026 15:04:27 +0800
Message-Id: <20261014-show_page_info-v1-0-7a68aee0114a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAHspz2oC/yXMSQqEMBBA0atIrQ0khQN6FRFRu6LVi0RSTiDe3
 XS7fIv/LxAKTAJ1ckGgnYW9izBpAuPcu4kUf6IBNRZGm0zJ7I9u6Sfq2FmvDNqhRE15XiHEaAl
 k+fwPm/a1bMOXxvV3gft+AEKOuLNyAAAA
X-Change-ID: 20261014-show_page_info-12fb720e5592
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.17-dev-39d60
X-Stat-Signature: gz4chdfk58457yxmsh4b49xmwe41an4o
X-Rspamd-Queue-Id: 3753140005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791961481-733769
X-HE-Meta: U2FsdGVkX1/AntlydwR2PhzZjC9fMoDwacYXU4B/lR04AFSPCwVnBkEOLvzb20x3Tajn+bc9yqcJXnRXbQDniXBYV9OjLfxJ8GG88GjHwwIR5NyjdMXAklHEgnTsXpTnuO5dxNvyhq/TkdH1f2CZ3PXmiGwFsWihLrF6Hl0VH3XQM+8QWNm7Digh94W5BdEK4CcROnwYpeV9E2IHvUCVnQqgNkUOeu4937r95ERpAbOT8p+ScfkRqHqcK8kKxenmuV0EC5qsPr+EfkDf+eIWBBNafWsIYRekq2Zt2u2Ch1gCBUrmak+VLwrAMaAm1xqzGGaZWzpv+3mRBH2mKfKzjtLK3/KbkV0r6e40XKc7fxYTSJ45aYt/dvw45chW2n3eTN/c0omOQJH0BaSGH4NzaExVtKoDczJrExXDM5HBsgAZCy9V1K1Jn2wZy764/EF99M/yNQuGT/9wGpXFbkLijgQCAqX6GbuJjXOBuHJpgQ8bJnL1GpRUO2NTM7yQGuBkIgPwUGr8wP++7+p9rv18BWZK6Rw1lRGDBH9B3lCKlsP1YWw6RYuPUr75vXdPlmO4mw3ZSXufKtMQPLfAd/Sm9Px2ZRA5heWoeZ39cv12srLmlK2MGwwWrTvJ5kh4f8smq0Obgtz3qulXbLREQ2Ro8eMnFwZb3U/S2wBfPocdCZri0BA1BeoUNpVdPzPaf5jrZPYZmOhelxfPLp9CcOe9DmNYUU3ysvvmUH9qfFVnpgnf7Kadsti5hS6rT8Pwhz6sfVuCuDBexNfBqOVMsA1dFkdA1apVQUeTT+BCBt3wMsIh0IAyZzOvFqnY9KDuAD1L3gkvO1uiXD1nLp//r7d2B5xaHv1GJdHid0fG0xIDdtIdglw2X2+uOxoABOTMLzm36XEKwSczl4hc8wdn+3aIAxs4e4Ob+Zjg5n9iJgcsJ8JcT+ief/lJ2b9yYpQtuv9O4yZEFrnp0BlCnw/e42W
 6GFhaCtu
 sP+p1h7dwmNSX7Dwbm6ZP7BpNwNy1UUYlIiWvvEIfc/whcQtSZOqpnQUgnIb+QPNawbL5qbtDn3y2k6bQ3oZedLocoOkqzwHoD9fS9r6O9VKWoAe4fcvfmcDrbu4hVUH+RBkLr0fB7j8PZofvq9yPcpTyMSjeIe6IXE/x25wkVv4C71oPzv+Wyle285C7MPfUlND7laPukZXthAHmXnLb3WukwJFGpzcjV0DCb6Qjcpc/MmPlNKKWsC8E9/mOAbqbaYE8YztVWG7x2UFCJlOTWxYnbbkhasSyD9kkFJqPIc7vCaX9fMmXtNlPgaLSbz222WN6JPlAuK+4w64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series improves the show_page_info.py drgn script with bug fixes
and new features:

Patch 1 fixes memory cgroup information retrieval by updating the
obj_cgroup type casting and handling slabobj_ext field name changes
for compatibility with newer kernel versions.

Patch 2 removes the incorrect Page Index field display, as pages
don't have indexes - only folios do.

Patch 3 adds VMA flags decoding and VMA name display to provide
more detailed information about the virtual memory area containing
the page.

These changes ensure the script works correctly with current kernel
memory management structures and provides more comprehensive page
state information.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
Actual results：

drgn -s /root/linux-next/vmlinux show_page_info.py 1 7f17c9ab5000

PID: 1 Comm: systemd mm: 0xffff8d796ab73800
RAW: 0017ffffc0020028 fffff2af04d3aa88 fffff2af04d3ab08 ffff8d794703b901
RAW: 00000007f17c9ab5 0000000000000000 0000000100000000 ffff8d79438fd700
Page Address:    0xfffff2af04d3aac0
Page Flags:      PG_uptodate|PG_lru|PG_swapbacked|PG_movable_ops|PG_reported
Page Size:       4096
Page PFN:        0x134eab
Page Physical:   0x134eab000
Page Virtual:    0xffff8d7974eab000
Page Refcount:   1
Page Mapcount:   0
Page Memcg Data: 0xffff8d79438fd700
Memcg Name:      init.scope
Memcg Path:      /sys/fs/cgroup/memory/init.scope
Page Mapping:    0xffff8d794703b901
Page Anon/File:  Anon
Page VMA:        0xffff8d796b0c0cc0
VMA Start:       0x7f17c9ab5000
VMA End:         0x7f17c9ab6000
VMA Flags:       0x8100073 (READ|WRITE|MAYREAD|MAYWRITE|MAYEXEC|ACCOUNT|SOFTDIRTY)
VMA Name:        /usr/lib64/libmount.so.1.1.0
This page is not part of a compound page.

---
Ye Liu (3):
      tools/mm: fix memcg info retrieval in show_page_info.py
      tools/mm: remove Page Index field from show_page_info
      tools/mm: add VMA flags decoding and name display to show_page_info.py

 tools/mm/show_page_info.py | 68 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 60 insertions(+), 8 deletions(-)
---
base-commit: 1fffefb00cc0b0da1f2ae24e3d33364530ea6515
base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
change-id: 20261014-show_page_info-12fb720e5592

Best regards,
--  
Ye Liu <ye.liu@linux.dev>


