Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05C93CD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 19:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1720D6B0005; Fri, 15 May 2026 15:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FCA06B008A; Fri, 15 May 2026 15:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2CA86B008C; Fri, 15 May 2026 15:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD2DD6B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:58:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 771181C00FE
	for <linux-mm@kvack.org>; Fri, 15 May 2026 19:58:11 +0000 (UTC)
X-FDA: 84770715582.18.B63A176
Received: from eggs.gnu.org (eggs.gnu.org [209.51.188.92])
	by imf22.hostedemail.com (Postfix) with ESMTP id D8CD3C0009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 19:58:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gnu.org header.s=fencepost-gnu-org header.b=rv41dHjZ;
	spf=pass (imf22.hostedemail.com: domain of janneke@gnu.org designates 209.51.188.92 as permitted sender) smtp.mailfrom=janneke@gnu.org;
	dmarc=pass (policy=none) header.from=gnu.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778875089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/aU20b7HmiTcHxu8uxGXgGfoRsTKcHgoJtV6rdezzGw=;
	b=bgcpnzuK4Ibpm/N9PzpNcNkiR90uxr3EN/znCsx1amL254zvkALwN5vlRPz+0I81fWroWY
	oXV1Jz5hk/OCBiau/7sHKHUY6mTPedhrHy/Xp0cZbsMdoHwzct9rfq3u7WIPfqbA5s7N4s
	2TQGjRhkSa38Cf/P7d0VwT+E8VZ+3zk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gnu.org header.s=fencepost-gnu-org header.b=rv41dHjZ;
	spf=pass (imf22.hostedemail.com: domain of janneke@gnu.org designates 209.51.188.92 as permitted sender) smtp.mailfrom=janneke@gnu.org;
	dmarc=pass (policy=none) header.from=gnu.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778875089; a=rsa-sha256;
	cv=none;
	b=5K+uUmvdBjfjl/VtNt53tdKij23825sd6mRAXEv44mYoRTz/9a1X78mEc9YWmBJ8Bz+IWg
	ojjy4oT6ZsUngOJCQh3VSIdIpmNFio2ow1yeHJPpmDcJdHwZ+HidaGCzGZE206yUc3xpsi
	QlRWhktAf0056VrthP0bjELZCoXcK+U=
Received: from fencepost.gnu.org ([2001:470:142:3::e])
	by eggs.gnu.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.90_1)
	(envelope-from <janneke@gnu.org>)
	id 1wNyff-0003T5-50; Fri, 15 May 2026 15:58:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=gnu.org;
	s=fencepost-gnu-org; h=MIME-Version:Date:Subject:To:From:in-reply-to:
	references; bh=/aU20b7HmiTcHxu8uxGXgGfoRsTKcHgoJtV6rdezzGw=; b=rv41dHjZRinUw6
	m3BveAcfReD43nmX7b+qq4pe59CaZR/DFPfOppn88PKaNBGglfrgOgG96kNF5nz5D6nQIVfQrIsPA
	hvSj8GqF+FYxhh6wLcwe3tdJoNsAyhFDloOEMsl2UfZtIw/vtiyXte1Kv9xEqgDMUttyaaqg8YxnK
	nRQI4afasvjG6RHaJMT0njfNNyPn40fdV6wH/oVDUPYVzF/wA1RoMoHW02cJYW8ueDNgMxwL4Vw4l
	9sFmqTZ14Gq3P/NuXGObICvSQvCqluQLMBCFS1RPwQ52tC3/Ls5J/34BdERqSldlWBAH01LhRWEZ4
	PqPQTgPKKfLc++A3ZREw==;
From: Janneke Nieuwenhuizen <janneke@gnu.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: =?utf-8?Q?Ludovic_Court=C3=A8s?= <ludo@gnu.org>, Rutger van Beusekom
 <rutger@reasonable-sourcery.coop>
Subject: [PATCH] shmem: support xattr gnu.* namespace for the Hurd
Organization: AvatarAcademy.nl
X-Url: http://AvatarAcademy.nl
Date: Fri, 15 May 2026 21:58:05 +0200
Message-ID: <87se7stpgy.fsf@gnu.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: j5ex166tpp6psk3gij7uw4yju886rn71
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D8CD3C0009
X-Rspam-User: 
X-HE-Tag: 1778875089-991448
X-HE-Meta: U2FsdGVkX1+p9YYqzS6I/KPBUinOkV0fRNr3D3Z/yRQi2BazPeXepSobLycg9m4Ufr2fPzNY7QqPXJEuWYfsNkwcI1IUwiTWiAoX1EKMk9xrl7wPEKEIUKrm7uNsXSnrz3QPxcj8qNBcGvgYpG/WpGYreHvtxENPBKlrlO+oEuegkuUng0MVGR9dWZZLNp+b/ynF5utonQ0gqx4hhiStRDdH2qDZ2T43TKE2DR7WFqvtHQ8ly5Q0Wq22SELAKvY/Ij25fReacrp2fNaaUYZE4wan7O9ipgYwTMsW7FpWNDmVJU+EcLbi+7TG+9z6Gn5trCIgK65c5YLxo4Q2xKFIOvPgTrx5OKpileISIgRAM4YbX+oiV8W8muCen11bflc2TEloir5K5Bwqd+yk6OUo0nMyLCbnNg5sfPOdz5BeWTIoAB3+cQG1VRW/F7M5SYi8VuoFpjjvOj9yuVtt9DYK5F0Mm1Hj0NeOnTFd3Hg/ZaAxolHSF37oo4Gn/8JVqOIXa0qVPBlepM2NCsCaW7/d8U5dwpvbcDz9kLcrfV0UYrynVJhVoigjI0HCQMt9R/3FXIcCZGbWyfAyqsmA6ZNJcScY8s8GiKc8DE3Kcnnx6AqlVQGoAWyqO45zBkcRf/4eOfjlgLUBZk8Lj4o9MJlNMpaocDEeb9GBhtNicJ1oTrQIfpAmYPD1NqTl3dhZtGkBe8hPnoXQSzZrJdrDLm/8CODqaC2lP+hVJ85Q9hMZgnM+gd+vDgom1CSF8BMPJ9baDd+EBe+TTHU7HFWtBSXc3UG5GyYo3yGmCP1NvhXxhsApwo+ZBzaWOhzr9eqv7Guwe1U5cXjjpAnGyJonRH7r/UFbTVJ9IwuYt+Xi1tMfWjtQ4mKmsWbUkfREqwi5pDrPTqvvr+/J5z2J+xN9/rDBTy33+uHfIxvaS0GLuNSLma5r5MHyv97XSrG9AdL2Is8tbZeJmaATwuBAACnNzzC
 TzgBNnyS
 ppEZh6Of8lGO8/dAqaE9FZpXsntFWsMK7wKaL5hw9K+eUNIdfrPTUi9YSBtdUP9c6jniYm1L7ls2MfjU83nUtw1+fskrgTzGdaeBxL/u9Ln/+lU8130+0Q005ce0RA6tx1DgxKUzYocxYAwIscsJnWnblANb/Kdg8MYnWMCCrhUxVd1NSwBc2FR1OgZU83qeWTvxivbh2BuRDI6inT7Gj67JRQSdK7etUkOac1QPOKrePm5clGZgXRDymsrfvg7A8mhu07NFYS4hFO2YI0KU5g/0k9WvrXCElMLIN5kn4XoUJZvsDnk6pYsWXnadm9bzYu5X0/XTZeQhSYjfSpQnzA9RGZoMeok8UCIgZ+jHh9rfJmPnO1Zyfk6frQKB0nyoa/wfeXj40w5NLF/GxUS6kw1kLKWC+MRJwYVuoBubGqFvD6fsOAiIm1SsNRxwe3lRno9kaXEUcz7uMijoeszaPsxdKngcPtmSyzJbEeoftQdHUJzty3He2PjqTHYu98DZuCRtOMr0SSqy2txawu3+uZhIxoXwJy0UGN3mllShurvAJvrmeaZP0WXiGu4wBM/aWipoVQ2tEBUt57RANC6kTEz+oSk7I32Mi+sH7NCswAQb4MTZSRTId1KLeJExGUglileWnabXWS1d/Tdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From d8291d06b67db045033664fb440f59001d7755a1 Mon Sep 17 00:00:00 2001
From: Janneke Nieuwenhuizen <janneke@gnu.org>
Date: Fri, 15 May 2026 10:12:30 +0200
Subject: [PATCH] shmem: support xattr gnu.* namespace for the Hurd

The Hurd gained[0] support for moving the translator and author
fields out of the inode and into the "gnu.*" xattr namespace.

In anticipation of that, an xattr INDEX was reserved[1].  The Hurd has
now been brought into compliance[2] with that, and so has ext4[3].

This patch adds support for reading and writing such attributes from
a Linux tmpfs; you can now do something like

    mkdir -p hurd-root
    mount -t tmpfs -o size=2M tmpfs hurd-root
    mkdir -p hurd-root/servers/socket
    touch hurd-root/servers/socket/1
    setfattr --name=gnu.translator --value='"/hurd/pflocal\0"' \
        hurd-root/servers/socket/1
    getfattr --name=gnu.translator hurd-root/servers/socket/1
    # file: 1
    gnu.translator="/hurd/pflocal"

to setup a pipe translator, which is being used to create an
initial file-system image for the Hurd from GNU Guix[4].

[0] https://summerofcode.withgoogle.com/projects/#5869799859027968
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3980bd3b406addb327d858aebd19e229ea340b9a
[2] https://git.savannah.gnu.org/cgit/hurd/hurd.git/commit/?id=a04c7bf83172faa7cb080fbe3b6c04a8415ca645
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=88ee9d571b6d8ed345f877e05f685814412e359b
[4] https://codeberg.org/guix/guix/pulls/8632
---
 mm/shmem.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..5d60aa4dba92 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -15,6 +15,7 @@
  * Extended attribute support for tmpfs:
  * Copyright (c) 2004, Luke Kenneth Casson Leighton <lkcl@lkcl.net>
  * Copyright (c) 2004 Red Hat, Inc., James Morris <jmorris@redhat.com>
+ * Copyright (C) 2026 Janneke Nieuwenhuizen <janneke@gnu.org>
  *
  * tiny-shmem:
  * Copyright (c) 2004, 2008 Matt Mackall <mpm@selenic.com>
@@ -4371,10 +4372,17 @@ static const struct xattr_handler shmem_user_xattr_handler = {
 	.set = shmem_xattr_handler_set,
 };
 
+static const struct xattr_handler shmem_hurd_xattr_handler = {
+	.prefix = XATTR_HURD_PREFIX,
+	.get = shmem_xattr_handler_get,
+	.set = shmem_xattr_handler_set,
+};
+
 static const struct xattr_handler * const shmem_xattr_handlers[] = {
 	&shmem_security_xattr_handler,
 	&shmem_trusted_xattr_handler,
 	&shmem_user_xattr_handler,
+	&shmem_hurd_xattr_handler,
 	NULL
 };
 
-- 
2.54.0


-- 
Reasonable | Free Software for Correctness | GNU Dezyne -- https://dezyne.org
+Sourcery+ | Correctness for Free Software | https://reasonable-sourcery.coop


