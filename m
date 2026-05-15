Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E4B9CD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 19:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F273C6B0005; Fri, 15 May 2026 15:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED89A6B008A; Fri, 15 May 2026 15:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED4A6B008C; Fri, 15 May 2026 15:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF1156B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:54:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A8DD401AF
	for <linux-mm@kvack.org>; Fri, 15 May 2026 19:54:25 +0000 (UTC)
X-FDA: 84770706090.15.48EC505
Received: from eggs.gnu.org (eggs.gnu.org [209.51.188.92])
	by imf14.hostedemail.com (Postfix) with ESMTP id A5967100003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 19:54:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gnu.org header.s=fencepost-gnu-org header.b=d6efW5NC;
	spf=pass (imf14.hostedemail.com: domain of janneke@gnu.org designates 209.51.188.92 as permitted sender) smtp.mailfrom=janneke@gnu.org;
	dmarc=pass (policy=none) header.from=gnu.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778874863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZuUhL7kApvjDAZmssblwAioHN2dl6oNg+X+AOXcNmI8=;
	b=lGQFpe2nbj9Og61B3Da2PN0PS6il4h9XlgPMjtKwKs15ti50Y/8NnKe7wvVMxzEmxk81jI
	6X49uINkGzOHJNcnj+la6vjn7L58Gh+qJyvWpzDGjmdBZDKXl7hSsWUbTirqm02315gpbD
	lMSPbgT0m1yNTy9HJLswKedNZAIx6iU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778874863; a=rsa-sha256;
	cv=none;
	b=RxcNxHnO8lrlVyc9lS1on2/t/nq+TfAdDWKSBwHOQpSPmqCkgHeG3W3GGgABKfCUJP+kU4
	X4aVbQasTV5NbA4E+V8QoruvfVEcEEJ6y4ssnXlL+DFngevpysGnB5ns3tXAeA1mtnXk2W
	YRjJ/tzUZcSq2aIJOP0v7C1VT+8szEQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gnu.org header.s=fencepost-gnu-org header.b=d6efW5NC;
	spf=pass (imf14.hostedemail.com: domain of janneke@gnu.org designates 209.51.188.92 as permitted sender) smtp.mailfrom=janneke@gnu.org;
	dmarc=pass (policy=none) header.from=gnu.org
Received: from fencepost.gnu.org ([2001:470:142:3::e])
	by eggs.gnu.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.90_1)
	(envelope-from <janneke@gnu.org>)
	id 1wNybw-00029t-Mm; Fri, 15 May 2026 15:54:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=gnu.org;
	s=fencepost-gnu-org; h=MIME-Version:Date:Subject:To:From:in-reply-to:
	references; bh=ZuUhL7kApvjDAZmssblwAioHN2dl6oNg+X+AOXcNmI8=; b=d6efW5NCsBb2dp
	msJfzkntJMaNTNHfutaejI5bCrOotb3S87jO1L3y0wIHcpvc0+rZvf3ut43n4zhCEVXSTXLTP0FdH
	d42C4hdS1QUiNl2ZZ1bkCQPBp8TAn/rqDeczxBcPbv8dfIhB1j8YpMyfZkUh6RxOYBZ1UdWIpofr/
	b8B2rou061W2IJ6mL0s8jYcc+4K8FLnG71UQoWgO//WA6DRpasxB1/xnVZPPfZGSjlsWX6yDqZpmp
	mYXK4wzJuJNxtwFiqodmGJP3YrmtKDKwvnqD2A7/JWJjn8yqgnKl4LY2CeBK0fflv3gANqcUxF6y2
	Pwx+vt5LxSePkWPlQwsA==;
From: Janneke Nieuwenhuizen <janneke@gnu.org>
To: lindux-kernel@vger.kernel.org, linux-mm@kvack.org, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: =?utf-8?Q?Ludovic_Court=C3=A8s?= <ludo@gnu.org>, Rutger van Beusekom
 <rutger@reasonable-sourcery.coop>
Subject: [PATCH] shmem: support xattr gnu.* namespace for the Hurd
Organization: AvatarAcademy.nl
X-Url: http://AvatarAcademy.nl
Date: Fri, 15 May 2026 21:54:12 +0200
Message-ID: <87y0hktpnf.fsf@gnu.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A5967100003
X-Stat-Signature: dtg3fygbpogn7ffn7kqx713d8ypckb45
X-Rspam-User: 
X-HE-Tag: 1778874863-475972
X-HE-Meta: U2FsdGVkX18eKJkfS1i/byXq9+LEt71F82qLfWsM+bNDRpZEQxQZYLg+rfGXMw4I2NmAGpcGX/bx060/BQpHcNsbKhNF1K2rwfkuAaulKxh3CfGwsK929c//H+snAz0OdCr3cOLYo0ziNdokA97e5nx0gQvy5C5YbbZsMpvpTcPy6dkbskNy484UDfwothS5/ZEQnoJUD6Re2wOYcU0Hz+1aMiYhvkPfamoLIuOWOzzh+NTSj9q3M54msd/QbBX79NT1YwbTjA7494sg5j4Z88Pnf8LvBWn2m7HbKy0UcErlhID6/maPzLl4P60aIlP+1Smv3a08dIolbQaqo7MLMRUU93wszvNFuCS5mBvS0rpeFtdAg3m/1w+PCN7AXzJxMg+5Yx2MJSmRYmEmXtjzMOqrySU6yY9FE/vE3i8cOkIioSBZhIKDX2iS/xkbkamXeqGSSh961NBj7/HbZhqyUBIqCCiL0PRAwxCPENCo67ec40v1usvue1nAmL+w6XG9JrEnd0jba382XP3zNSqVR20ZH6YP7P72UC7bmWlNxL/nvhKnSySr7TmcG3ZbAzpR88czvvIKn1QBC7y3lkV2G3DXMkCQ/GhhoCUl6AcDgF1Cll2EH0VwwghpSlYQdW2fTqbOjq3XSYcxDD01FN6bFQFmKrz1/kevs+hIyKPUBiHoEkc1j4G1MTqEle0MLegGuLS9MNHVe+eyTE6FQtb9YlaCitvMlyzY3FDqK69VYBq1emVJGYVFazMZU9PSsmOaB1Q6JqLeEk+ENVI00KEJlQWXECxgOdbjJhJNaBH8sk8CfGPmbqMRHiqWZw7H6eY+Hh/2Slb3a6vD5x5wBKpo7kPOKMhQtdN/+Hvx4LPECs6jMD4YunQaKPtbP7hrkVwRklg9XgAIMugqUVD0y1dPJ9jPQ0mmigkYRBHH4eMMXaUyucp66VwiFPIxCai2PW/faeF5LCQmD6On7vPCFwQ
 tegaASPQ
 RfTmrVRC0kLgwIh0/kgwaCF4UL2xSKRziRJ2Gq+mDu41izjkHB55PiKUVec10gQNRNPkEdETz+yGXTBqw7FsfD8b/1yIlOmP0quW3HTlsvcgmrKf6EoYoxLopPQPq9rEjD13dBjZBqgeEQ/dj+dKWJjmgQ7/c13Vxg+RNXegVHJbfJ3k8fJj6t4M5PMfq+JMYN3AbbiKJ/qZZjsb93/5aU4yxysx+g8vHLJZM1XNkT7qif7DXVcEP+GcdGZZupgaaAifmxBrYUthMORRe29usMgt9pcub5CXkE0bRhJwyCGAlJ6lbKqiTPYFmAmgh7s7lmLUQSpjhMkHnOuOSkY4xPhM5WoRZMoNjef8WJocAZzlH5D3yg5SGkBIuiV3v5Uz6iK4NSa+9QJfqMlAhQ9dvx+yj2Yegdvv4rv/OMFECr6BYRq1vDnM1msx6gM1ZJjhy6LBDF1Tzb5vDvx0DkHmI14TMSFA2apIKVyjCNG1cYjBVWRumv4UMErYWRxClavR/XNfrY4FswDl2Dyib7r3oedIhO++RTOKjSXrF6D++RPLJIxTrMaqIFnaLrIZ+EvIMcwSsjwtCC0DjcC88Vvg4hVHZ3JCW+heoBHMKheQM8gfMHqt46VaivPURnLnKcnMaSMfmP3nH/2FQLi4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Hurd gained[0] support for moving the translator and author
fields out of the inode and into the "gnu.*" xattr namespace.

In anticipation of that, an xattr INDEX was reserved[1].  In 2020, the
Hurd has been brought into compliance[2] with that, and so has ext4[3].

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

to setup a pipe translator, which is being used to create an initial
file-system image for the Hurd from GNU Guix[4].

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

