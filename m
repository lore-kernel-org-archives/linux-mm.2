Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2317D10FC460
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 23:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DAC06B0005; Wed,  8 Apr 2026 19:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B2F6B0088; Wed,  8 Apr 2026 19:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5DC6B008A; Wed,  8 Apr 2026 19:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16A066B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:50:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93996E1AFD
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:50:14 +0000 (UTC)
X-FDA: 84637034748.04.80E84D5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5A1A780010
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:50:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O7rxbre5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775692212; a=rsa-sha256;
	cv=none;
	b=zs/LMbsPpCgUHTWPNM8B2kR5qywdeBOngUIUHm7d5AOj+IWUIf0V8H8+stcMIk+g5/drVY
	FEosUHoqzkL1XEh/uuCqOw7bM+HX6O/cDu8lQ0oOOO90KvGtQZE2e8J4pBuTfSkaVC4DLz
	bQqnO9W4aSZMqkovi8NuC42UYz97k9I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O7rxbre5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775692212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCrP0/yiPFGIZwByrE4JJ2I8Uf5Ye8WtA9EuaL562tY=;
	b=NdCZOqI0GIG50hatb3Qpx063qgbBMqi/v3h04JSID+FwQMQbWpkG7NOaLgSqkHvu59LAEz
	ZAWy4w0sbi643W3yLPSnsbPwD+zMuAcyGiZgwyTCDAPTp7vt/B08R8Bbzw+vmR17d1XM5V
	u3bfYkAe+Pa2J1abB0ebm3YBoRwal88=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775692211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tCrP0/yiPFGIZwByrE4JJ2I8Uf5Ye8WtA9EuaL562tY=;
	b=O7rxbre5trPDav473RiwgzExhVms1OakHfXCY4WOYq2RI2jHEpUMBHqI2Z/Orj0xhEYUM+
	T3z7ZJy3Su/t/QNxLsv1EMoWm4C3UkqQUkiHHBfGcJ0yJY19tk2Ecj2bO58q0u+qF0WtjI
	jpq4je9EFFO52yHKmW1ARvrwh95NnIQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-fR8apmNbM0SY-v41upfTEQ-1; Wed,
 08 Apr 2026 16:23:20 -0400
X-MC-Unique: fR8apmNbM0SY-v41upfTEQ-1
X-Mimecast-MFC-AGG-ID: fR8apmNbM0SY-v41upfTEQ_1775679797
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE48A1800345;
	Wed,  8 Apr 2026 20:23:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.88.140])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 44FEA180036E;
	Wed,  8 Apr 2026 20:23:15 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v3 01/10] docs: tmpfs: remove implementation detail reference
Date: Wed,  8 Apr 2026 16:22:56 -0400
Message-ID: <9a0bed627137a1a0055900114ac6d4abd3a9720c.1775679721.git.luizcap@redhat.com>
In-Reply-To: <cover.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: wxYsoYH8u6pF6ZYxK67AZCh9LDxGIP6jxhGJkPEoi14_1775679797
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 798sjmhnpkoyo3mjmsi8denw7z4cqcd8
X-Rspamd-Queue-Id: 5A1A780010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775692212-96878
X-HE-Meta: U2FsdGVkX187wOIl1QQpHdu7Zld72uVJPbD4CK6hgah6mJqWI1v0M7Q4BpV/GEhW2PsNBWu7NNSoJDzJwJ+oyhPS+akqY/UYZktfFzRoTLl2ELR5zbA9HPlXuTgw3QczxyaKZfzbTKeS38ZaQsDyBmW7siR19Irjjlr1wtN/Rd2XmrR7E8IE6pGdQ/VZjRkFY3gsf5C/tJa+nYJPr8RCyT6EO4FXkkU40WrCiGBeZppY5TbHVGBllqYYWY2SncoPfLW4EOY0D+UFC1sQw46iv1HXKgqq8lmFgbH7zVvEqeVkieyXuRoeuBWHN+y5kXHFP6MXd3LqRuDgVcAEyYBmpKCx+ZORpIItdCnCHCFjtD1ZYzrKL3hyzVEkopgaB5n+4l3ZP+giw80F4Ek/KIbMecdMVnz+W/zwFQWoIC3QJIN9+ErDXTvSyRcoCZ8jVjURs8P5QuPT7JKPBzgh1cGxOsnBwbMRn3Agw+0wWhIjjuCYYcLwGKOfnj8LfL2GM+ISR9/pNqCW5dezvMKN9MOT7vRP8BjAyC/A3OBe1tEklD0Zq7+ZXv3YRTM28hJjnp++zU8QWafB/gV73WhYmvd70DO4LFRjYOcLGpfB1Y66ntRbtdSWz0eOPe3BiTobuQbuuiR4m0ZgcjqhKp7hJBDE4uMIGNxkFCAaUz8wbGiSHvHXtIF0aSMhdLDHoNrqkRjXi/TD21hRRdfRephh8thpaXN8qSW1MbN9s4cCbC3g7uQcYXtKNkhclgQ4mFqZvNXiioJT0S5Qe0aBPQlrDElVi2efwTfUyiR3V/DLE9OBUoXbcdz+ON4kIGv0CemoyL1mZXO2jqF8TNgoFuurLUIO2soRmePzgrkKV8MlH6K/eGaQrOXXrpCxyhOVIi9EyM72vAzPbYHmO3WR/M8iL1suqAatWHJYo+KwyVgL8p6a3XhJKeuFu/feCmUfSF89JPMnhCAU1kZ+BD0kwUdMLL4
 MH7QHzrq
 uRR/pxq1K9m13Tny25r/XE9dcMgw3dazIpXk8ZCwvRD9+ybwJeBXvn0egUkX6+T1PjLOZIEmwheQ7D4NQYqDuhfcg5yuGF63fBuLyV9PlK2leY4+ECi6FOc0a/bGiNEvw7e3ohqlvskcTt3QwjUTvHm1tevt7LhF6wp+rG07BF5W+StCEINaiAYvA8vlJixE4OMYCHejWl0TxVgXpU8oy3oxUB+J8GaH3aQAXGJBf8a8ZeiyIJ/NiYWmsgJuEo7buP6ccZIdT33TRIWWfStJ95Aulab2yth2yvK5lQ17ioqfqNvhWeUNIfV1xz68fNp3QDqtYZ3W/LsGjetZz28jngM96QF3RdC8zl02qdoMkRlkgr/OILUlvuCGL4+ofVM8ZUq3VmjJ91vb21s0=
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


