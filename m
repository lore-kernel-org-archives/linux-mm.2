Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3023AC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD846B0099; Wed,  2 Sep 2026 04:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5866B00A6; Wed,  2 Sep 2026 04:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212086B00A7; Wed,  2 Sep 2026 04:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8CC66B0099
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:10:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48463C0107
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:10:30 +0000 (UTC)
X-FDA: 85168100220.11.B904B28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id B380C20005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:10:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QS9JrRs7;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788336628;
	b=sQ7S2Yc/4ywreIdxGzDInAD+yktEfkV6UNSmd84eHsavpvVdk8xzdAElbM6UFniJ7UV+54
	Ry8hXnOBub8zwwFuviaw9Up8As8lSIA+nv2WAP0hTpNQCy14QmQ0+pu9nVX8vDSu9y8eke
	llMDzBSREFFYxG0Q296QtaKf6qCYCNc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QS9JrRs7;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788336628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SeqDurGMv4fqw4TES+Ik13n+LgZ66K1BaegvU4ulnMo=;
	b=VjHsSFJ2QtlIUJ06M66Q7anRKOK91NCaDM/CA+Y4x7AwjUx5LuvlcVAPkUIWDAgh0S7M/P
	UBbS8EnRfpnWj4SEDiqAhiBBVRqK2Wn7R5TYyg9coxIJ1nyK/XFY092lH98DKu6Vp0di4B
	ftl4cAgROH2tbdvX+P07Srmay4TpyeI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6037960218;
	Wed,  2 Sep 2026 08:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B297F1F000E9;
	Wed,  2 Sep 2026 08:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788336628;
	bh=SeqDurGMv4fqw4TES+Ik13n+LgZ66K1BaegvU4ulnMo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QS9JrRs7bGqV0qx1W1un5XzrqKncru7qKvNcVKXWc2pY3ZfQXF3tMeeZaSTrqpYSs
	 3TqR7FQBfp6RXpmwyw59LWtV+QUogwxgE5rY3A25MFFD674lTgVMOxfabtOJNg1sSE
	 0Ed755WVp/u5fzxuHEWyJp8NWkbOmOMS4syBg+imAk0bxTvAtLP9tB/cAusP+P3l9K
	 BUfYTTm0IQCDqlY/vTmK71zLeKV1dT9/L5tJY7HBiVvx3TCnnmrrc/i/yp+Rxu18S8
	 tgcXXJphOLO1IfFAwJR/XViZSI3hJZm/lItBVVeJycyBkawAHp9SOW07SdJu7q7dIx
	 i6VsTOfnWIwOQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 02 Sep 2026 11:10:12 +0300
Subject: [PATCH v2 2/2] MAINTAINERS: add memory related docs in core-mm/ to
 MM - MISC section
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-docs-memalloc-guide-v2-2-218c1a4dcb80@kernel.org>
References: <20260902-docs-memalloc-guide-v2-0-218c1a4dcb80@kernel.org>
In-Reply-To: <20260902-docs-memalloc-guide-v2-0-218c1a4dcb80@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 SJ Park <sj@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: qucuuxhuuzg9a93bhpo8u1of3y4xagtx
X-Rspamd-Queue-Id: B380C20005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788336628-786825
X-HE-Meta: U2FsdGVkX186uUmG81YY97KkxfKOIY6cmiyFd9Won5iHie5ZY7JcvI9Wi2R0RN0RJ+KvzeR8GNH0SgaqZ4brZG2u//D+oISodT7CxydMLblsK3XWDq1nAhAY3dOurfXuZTigsa6AAaut7SSS/Mo4/bmjsxjrprdvkFT9FhDDSBx9KtZVz3ZUuQ6ATgweGbXNWJFEIBfzLYhmafb+VnHNtZ8df5EScTuWupgfe2H66tQHBwmGB93OjRUMPcTq2k57q/WObQOCztXsKWYSIsQkhcV/eC4ODgtWiLu6topJj2CvhnIPlqbeqDUadpMrK8kS66ITgIxlS7jA6AFIdfUsS5W3oCvz47wMsjb3cmeL9nRxILZ6Cyn78u9JVM0RBG/On4lUIjpDe2LhBlRYhVMvRs8dsZi1g0kRG19Fn7c+5boXxdneP3AV/VbXrsC0MHr3ut43WXyKzbgiCSCbz+Jymy1HD65217u1SarYApusOROk2DzFErcIMtBk48Kis20/oLuEQt8Wnds8L17f2f/OsSnEIH1WFkRtXCni47kbijEVMyaC8jPAcegwBr7gebsoRgN7EtYXZKvXHwbW3vWYYAGXFtbelp7XdumHa2eFhaGI7fgrjlaH520UMOwBpgGtLOFsHLtJDP5LLqnh8oKApVqkEhVkyVCO5R2s6JiubOAeTEfSH/RENvpV8OEmI2qi7/Hv9fkga3dYtOebUKixIwGn9PGzs9HsBZR6muiG/qsGnisq35kFu2BBcdn99j9suxvnXFeBpXGhwJBHSQCDjSIsgi8oASQVJP646U70ONWpYHLC95FEt54W/92o9ZUcLwNHmvAnCxqZvTyjIghRCwH/HP64kS3kg6YK8ie9ZeQxWKoRBqvO7UjoUOtdsTFhCnlkFp21pD4O4yzLI2NlhXMgvut0R4UbgUab2umemC/t68k/FOd9Np9IflNV8jhnLt914k0m0z4uGL2GgSK
 ZFaUd1uo
 irKJq0eBxnZDC88MxZA4cTfPZ7j1uM8NDKrJuK08on0LTHa9WdtxtlP6utJTmUzIlPXTSezVZpHnYh+07QlsvVUaTE9D4o5XJ0hFI6lZorhSj5GIgWSGSgUhw/Sv57Vp5grDzAeShURLAJGxu7WShczanH0v4vIwJisovWv/7oCPy4WGKHPoWVQ3J5IxIu7WFpE+FdMQgK3HL//CpSFGuVFsrT5hPmgy3cZJ7JQxbc5QWFJ6TKN1wmmEKkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previous efforts to make sure that mm files are properly listed in
MAINTAINERS missed

Documentation/core-api/mm-api.rst
Documentation/core-api/memory-allocation.rst

Add them to "MEMORY MANAGEMENT - MISC"

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a19da74d00c9..707f93320ad72 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17275,6 +17275,8 @@ F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
 F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
+F:	Documentation/core-api/memory-allocation.rst
+F:	Documentation/core-api/mm-api.rst
 F:	Documentation/mm/
 F:	drivers/char/mem.c
 F:	include/linux/cma.h

-- 
2.53.0


