Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 270B0E6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 07:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 648A46B0088; Mon, 22 Dec 2025 02:16:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62A136B0089; Mon, 22 Dec 2025 02:16:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57D3B6B008A; Mon, 22 Dec 2025 02:16:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 457D66B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:16:13 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E28801409FC
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:16:12 +0000 (UTC)
X-FDA: 84246248184.27.54198E4
Received: from forward100d.mail.yandex.net (forward100d.mail.yandex.net [178.154.239.211])
	by imf13.hostedemail.com (Postfix) with ESMTP id F1CE52000B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:16:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=yandex.ru header.s=mail header.b="p/lIspvc";
	spf=pass (imf13.hostedemail.com: domain of dmantipov@yandex.ru designates 178.154.239.211 as permitted sender) smtp.mailfrom=dmantipov@yandex.ru;
	dmarc=pass (policy=none) header.from=yandex.ru
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766387771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OsTuvNRAQmBwDO2BHS3r6bH4d2S+9QgIQdl90JDMa0c=;
	b=rNgGRZ3cof2fTNM4zmxouCv7NojJqAMIiBQZFIC8EH5sC0SvRfsEkt8P+S7JSpfkML4rHL
	fzQAwj6NCzvVMCdLIQGSPj2svl2pOoVsoT95kWuhYMBpjLjK3P5oiQ6JHir7UDnHvZzfab
	yQ/vwFmGFA72844me5fRj3RqpSBPZlo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=yandex.ru header.s=mail header.b="p/lIspvc";
	spf=pass (imf13.hostedemail.com: domain of dmantipov@yandex.ru designates 178.154.239.211 as permitted sender) smtp.mailfrom=dmantipov@yandex.ru;
	dmarc=pass (policy=none) header.from=yandex.ru
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766387771; a=rsa-sha256;
	cv=none;
	b=CSddGAkNu9NvN3oQnm3R4naKWszmGEyStPKmGYAfn458o/gZrzn6ZMJEBm6P3zUxI7h36K
	PIdYGyJT7QsVXtLZBNOKB5iO+FvIDag5Jhvax2jZCBCDD0XJNiQf5tjluNCyiYDn2gjIoV
	IDTDl3Y77MiOjQWupmbSmbWhn+u9crI=
Received: from mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:2dcb:0:640:715b:0])
	by forward100d.mail.yandex.net (Yandex) with ESMTPS id C91BBC0084;
	Mon, 22 Dec 2025 10:16:08 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-59.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 7GUgvspGw0U0-ctqyQh1C;
	Mon, 22 Dec 2025 10:16:08 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1766387768; bh=OsTuvNRAQmBwDO2BHS3r6bH4d2S+9QgIQdl90JDMa0c=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=p/lIspvcbrHAFSekI+RjcBDiISdp169u9V8FGdgrZEWDlCY+CgrvPXzf7mdYIYJCn
	 xXaUoUt3fkiXnOPY6c0nvh0PHcYOGfm9oKqDA+kRfSp1lsaUdNT1J6NyfQJyDeg16N
	 bsUh+OPsEygSlk/nM4AyD0M9Qe321bqEhRNvha2U=
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] memblock tests: fix unknown macro build error
Date: Mon, 22 Dec 2025 10:15:43 +0300
Message-ID: <20251222071543.953823-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d8gn17g1zey5p1euqye7erumi3e7kchs
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F1CE52000B
X-HE-Tag: 1766387770-709656
X-HE-Meta: U2FsdGVkX1/CIY7VwE3xIBVdiga0+2r2Zss/ETM2NwK6f+PuI08nTbVqsddLy9wJY9xiB0+MR0TydyCXepQIW/arMJq7HHu5vLvQULtMYF0xezh5XrJw+fhk+5SVYIUhTujvg78pgVjXqVaxqn92IT7uhZXLxWxuFVj8yp4ZiOHaPTBChybTSuSIFry/2EikTWe/uchnJvvthjBKctGikJ++bHByKRxRGtlp++HMATrv1cvg/F61Ks5sT5RoMaKvgpulpQTiCXyLlrqN7+S2xCU7tLsms6t31KiDDom5AjaA1nW/55OGu/eDaz34RcaFByc2Jvcwoh8x5ZRMFWlS4s00Yo3pMb7YNLUItFXclg5PvZZzcGiUXeQ+BT/ZDXWTkfow0gY/obdiJB1DaawOk+m/ZgD8mAfNeJ9syJ3GuD/C5v8qzPikfehBcaLqCaVQeWD4WK4gMsV2LNF2e9/IDkD9KWlhRtK0zc0hJTInW1J9rfv365ud8Db6YGllGN09GGxt0ra56k/3YkYzUD41jv3tqy4OUZo0LS1cWdJsF8mhxN4QPKobRmX38Z15WHNc1qnTeW+i2yrZ4/FadyrSm+7AyGUJzNp3DTrbdcCeMFVLSXjPQZX9WJzRD0aCFjCTzlqDGYiGJV8tSUOzecnPbkFCanONkUwg+fMo/CZ26n+YgQjdraaiDb04lYVKT3qMenzyfSSNrPi/HFoyflAQiQBfAgU2fuKdn37ZOvLGNGgK+XTKU4qkbMLoNQniJAE3oX6AviLk8hMwrCATz/ZixN+eeFfgtMR6wnX9ZVX12Sz7IlRzBpko70vtL4gvHlg1vPuvjsRE82hzvaE83odLg4tnf+4MS2YpK5mL88/enGH4maz1xmkvz6QZRZC13oTcLjOKI1CVozh7FYgytTVIefsWT/kw2DbxlXu6lS6n/ub/+rwLy9mgjvu8nA7MbTMe3J5+6pHRakyO0P9ZTaQ
 +Tb29XIc
 U0YFGHRE4Ixa4y83EX4SDXpztrLX4ZxDc4ChoIomzCd5LifjlnAfi4LTR3Ya0X6WZgPvlYr3RT7vBu1gBBoLTpk6Xl0S1fPN0ak30RgQIJMnVqy4Pe1sXGwRcKGhTxHJ7haDnrhe79hUhxreqoecaNELOh9+j3BLiCmNheTUFKahS6aYLVlp9ZoLTOnpz1KxyfAytb/wi89BehH/aLiXwuwJPt5MlRPH74CoE/4lwkGjaENONoNqQzq9YVN1Sk8KlzHK45nRWb2jXKIMqLAaCRLeZ+hOh8WMocLv5pk1OxirKA8c1vMxMxVuNRruedfY6y7AKmJ38HIISjblfMJk1B3WapeUhNgESxhLUvD6XkdTTAgBDYfT3mfQVCp0Npq90wtyy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.006475, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Running 'make CC=clang' under tools/testing/memblock, I've
noticed the following:

clang -I. -I../../include -Wall -O2 -fsanitize=address -fsanitize=undefined \
      -D CONFIG_PHYS_ADDR_T_64BIT   -c -o memblock.o memblock.c
memblock.c:783:44: error: use of undeclared identifier 'SZ_1M'
  783 |                 mem_size_mb = memblock_phys_mem_size() / SZ_1M;
      |                                                          ^~~~~
memblock.c:785:37: error: use of undeclared identifier 'SZ_1M'
  785 |                        (nr_pages << PAGE_SHIFT) / SZ_1M, mem_size_mb);
      |                                                   ^~~~~

So just include linux/sizes.h from the linux/kernel.h stub.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 tools/testing/memblock/linux/kernel.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/memblock/linux/kernel.h b/tools/testing/memblock/linux/kernel.h
index 4d1012d5be6e..3401ea867c8f 100644
--- a/tools/testing/memblock/linux/kernel.h
+++ b/tools/testing/memblock/linux/kernel.h
@@ -10,5 +10,6 @@
 #include <linux/kconfig.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
+#include <linux/sizes.h>
 
 #endif
-- 
2.52.0


