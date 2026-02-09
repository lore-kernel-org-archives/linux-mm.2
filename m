Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F24E94615
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4796B008A; Mon,  9 Feb 2026 17:14:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FA86B008C; Mon,  9 Feb 2026 17:14:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645EA6B0092; Mon,  9 Feb 2026 17:14:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 513CA6B008A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:14:54 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E507B7FFC
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:14:54 +0000 (UTC)
X-FDA: 84426324108.25.D5F3B83
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2A238100003
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:14:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ni26MD/4";
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770675292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCrP0/yiPFGIZwByrE4JJ2I8Uf5Ye8WtA9EuaL562tY=;
	b=AHgjjPHrKaio49Sj07/E+16g7ib7MIw1xIamBK+7/itwYz1eleNRcXpxqw4ooEPaPEcBgj
	YaHu/XlR2V1k7KluVcd4r9Tf0SVq9FkRLKIsN6aa1wW8/Nx1Cde23lhKFX8X7r+9QBQ16M
	cgwUz7InGDVjB3uMKjo6PV7B2OgcslU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Ni26MD/4";
	spf=pass (imf05.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770675292; a=rsa-sha256;
	cv=none;
	b=lVUeK1wnLxWNE/38XNpGEf8/FtW1dVHrPSMXmVKjuKgoHl3FBu/xkZDESTBm+w1f/x5NVW
	lakCVyEsBOiN/jvfChmALoWBvBeBKAIAM70X5iASaD4CZt8vCXb0JtvF3T2gQk3wjb6AxW
	YAbVR5OXt+BzkG7IGKJjOn8SI4awOmY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770675291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tCrP0/yiPFGIZwByrE4JJ2I8Uf5Ye8WtA9EuaL562tY=;
	b=Ni26MD/4jvbhakjNcKg84xuATtiXZflad1QFs4wcwP9zWQeh3l92DyJA+6Z1TIs4EVkUVI
	acFtOYV/6PDfpQYZrA1t0g+BoMegS0dSDk3G7O/GPsB+/ur3flVbFdjA63T5Uz//RC9MoB
	oyFN1284lQbxI6uyo8ZWaz9FztUfoi0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-281-dHUkiJnaMmCWJ_7CR1KXrg-1; Mon,
 09 Feb 2026 17:14:48 -0500
X-MC-Unique: dHUkiJnaMmCWJ_7CR1KXrg-1
X-Mimecast-MFC-AGG-ID: dHUkiJnaMmCWJ_7CR1KXrg_1770675287
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8687D1956088;
	Mon,  9 Feb 2026 22:14:46 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.66])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E09CD18004BB;
	Mon,  9 Feb 2026 22:14:44 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v2 01/11] docs: tmpfs: remove implementation detail reference
Date: Mon,  9 Feb 2026 17:14:23 -0500
Message-ID: <7f674469671346b18bfda22fadde7b6fb4df0e0e.1770675272.git.luizcap@redhat.com>
In-Reply-To: <cover.1770675272.git.luizcap@redhat.com>
References: <cover.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 2tWskJlwvagkvvDRp16_ThnBmB93Ju4lzVZloN5s8q8_1770675287
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 3uwyadunddh6bstf4t1i6bzxajm4on7u
X-Rspamd-Queue-Id: 2A238100003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770675292-294044
X-HE-Meta: U2FsdGVkX1+0N6zx9D3+FNgOZErLkk08LH4BN8diTDCe15Yz3w5lQpZAS17ciMdIGj7opM3xlPCt0REzY9NfdD/XCy0RI4DLRE3BRasjp8/rn9Yr/F/H6S7CQy3wpkZ9kHYRQ+4Ot1lDTRwL8iM+oyF0cf5zrdGyI8o3nLIuqWBJDZIVBXg7FGNB8aY0Rw8clXgIoPBKqom9j/DmO9jU/jTrx9or2cYYnDx2yywHGQ0aNkm6xrae7hoV/tbHYuKmGoKhVaygLxUnAP1nA0P7SwkXjEgfjqMC+D/JZ4F6NkDyzkCMH3eAQGLavivlESybAxupx/qw5WJAQD/gLydxU/HRJQNGZKvsuJlaXeHGUg0+E+RdT5vUK3bYU+n/RJKbGOU94FfKnNlsBmmYiBW3uGgA6FwNQWP9FYF2dxDW3z7luQa+D9O4bClAFZushe81Fg6ik6WeF3YhfMZvkDjRvy1ltkput8vyNu67oMQts3jZTN7TeoJz114hZKsw/Zu3lAxXMUwA3toAjlvPl7NOYyyj9/y6V/SeayxqvvBTc/KL88bw/NG0euBR3ey3iQ0fYdrfXAH1Qo5Mm7qqIrQ2suwz/JG9Tjpd+YUgNdo5Sb8lipCcSXShhKC4PlfXX5chRuoLohXbX4X8eTm6z5hrfvTdQDoQ0SdT3nWaiILDHX6LIjJCH6HnVaB1KQGn/yNoQaL/Iun+SnhPE9UV+zsKL48WYoELd6ybDf4obdLq0/tDSslpiy8VZ4HH+pQEEtymMurUOQAzkpphCaxWuCv5dBBdFXx6vnZqWtsEbFFupaC+xN4dPdZuu2z3yquMd42AEQJ9HTQPiUoCblLWoLI8sY7Hrj3MM+HQaQM2RlDagReAFtCRIVVCia1to8bkAbM/AtwXqu2kqpwZb+mp3DzsHeGO+ukCABnw7a0fg2mCAYUEhlz7ewhQ9usx+sHraI7Mp4lJTHKat+ung0qrL8e
 fJdVi3Mi
 I3Hf+f6OLaWqrzpGwBTwyF0mXwFgtG5AraSDL04xwDHnDQUF9ZGNabJwAlG85ecwArE9XM89LJMm7LC+WYdEPaefXWBrwQ2E3sKL0lZlo64UmZRtv8MSd3E8HVPJR1KHRTjPFj5rl4n5mZrdYihjTCN6EF9PmeSn3l+czmc8QlpDhmFy7wEeEnAAvKAOJ9kYJ/vnqQI1Qm7dclIyLVAAqryaqnCL1hFUPXTHBXtYhtWs/akL/j7NZWCRXLhbEGE+UFL1IHcy72h0jPP4QTSwB4PX7NOEOfhNt4P+4LJuBch4sHIRGPLuJ/RWbRoCvIwxRWt6Q+tg0d3//QWxwOMXlXOP1aYthaZWhsgNxreVwx5A2ygtYLOyzgqhIZ4g0yKVrfAqu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The tmpfs.rst doc references the has_transparent_hugepage() helper, which
is an implementation detail in the kernel and not relevant for users
wishing to properly configure THP support for tmpfs. Remove it.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 Documentation/filesystems/tmpfs.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/tmpfs.rst b/Documentation/filesystems/tmpfs.rst
index d677e0428c3f..46fc986c3388 100644
--- a/Documentation/filesystems/tmpfs.rst
+++ b/Documentation/filesystems/tmpfs.rst
@@ -109,9 +109,8 @@ noswap  Disables swap. Remounts must respect the original settings.
 ======  ===========================================================
 
 tmpfs also supports Transparent Huge Pages which requires a kernel
-configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge supported for
-your system (has_transparent_hugepage(), which is architecture specific).
-The mount options for this are:
+configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge pages
+supported for your system. The mount options for this are:
 
 ================ ==============================================================
 huge=never       Do not allocate huge pages.  This is the default.
-- 
2.53.0


