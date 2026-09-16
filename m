Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35F81C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A696B0092; Wed, 16 Sep 2026 09:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B556B0093; Wed, 16 Sep 2026 09:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B0B6B0095; Wed, 16 Sep 2026 09:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D586D6B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:22:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45292140727
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:22:06 +0000 (UTC)
X-FDA: 85219688652.04.30EC0E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id AA7E61A0003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:22:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfoVsNzt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789564924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YFiTkxY4NnahRWADkTjvK32t/QFawfHXHLOvPkMD0aQ=;
	b=v0uqFFp95qd/6dKzHP20VPLpHCJ2Klyx78QSjE793R4uKv8nWsUJ8n/p1AZnbs2GFQ80yu
	giMSP0/ekI+KKf/7b/9Dgy812spREtsmfoR/uwe0K4P9Nw+komgf9y5AIkt7KCriZK7hqK
	af6PEPoFx52EWXhtUPL4wImiGmRVkpM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789564924;
	b=0EwMirdgzpDlhdOFOb5czWEo+rOUo6mSm4dWwZzNCbsEFzhKbJjd0YDaBsSkU0dgNfk3t7
	c2KhUi8Ol0F6T8ADAJPx1vigcSzTtSZY984gWvkhWZggdyjGWT8D/vUEa7l5I5HcL4dVkX
	aNinCFZX4cWWhc6W94d4NXydcDCpkQ8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfoVsNzt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AE5760234;
	Wed, 16 Sep 2026 13:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366A81F000FF;
	Wed, 16 Sep 2026 13:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789564923;
	bh=YFiTkxY4NnahRWADkTjvK32t/QFawfHXHLOvPkMD0aQ=;
	h=From:Date:Subject:To:Cc;
	b=LfoVsNzttzZqw9jnVkyiKm1jz+gqn9MVzP6upZW+Cvpfvd4RJMlUv/W2EVBdpN0m2
	 P3IcsjsLZkLuPbbV1Po9K1gKylmprm58C01Y6VUd4HfGIvZUQ1aIMc6/QMX45+Yiug
	 67hZhEMDg5EDO5cSZQN1Sjh9DvQ2vEer22SvLAYt4+ougxk1Gf8cxREmBiwnm+1+oo
	 s1wyueL5y+UtLChAJcCAuTmJxca04manCul/6PI8joa9F8k7or12RIyQHchxNQxdwd
	 sigzQkzEyKLH9Vz2yV+suHMRGb6MY12IVj+DdC4BHEUGYZLBexHNDh3uL1/69jMw/T
	 fdiz1E6L9WFkg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 16:21:58 +0300
Subject: [PATCH] MAINTAINERS: DMA BUFFER SHARING FRAMEWORK: tighten F:
 matches
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-maint-dma-buf-v1-1-0f8d6c5bf1cd@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMQQqDMBBFryKz7tBEQbBXKV1MkolOIbFMtBTEu
 zdpl+/z3zugsAoXuHUHKL+lyJor2EsHfqE8M0qoDL3pRzPZERNJ3jAkQrdHHAZrycXgJ8NQnZd
 ylM+vd3/8uezuyX5rkfZwVBidUvZLm1aVWfI1UdlY4Ty/DQzjNJEAAAA=
X-Change-ID: 20260916-maint-dma-buf-3311abfdc90e
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=83=C2=B6nig?= <christian.koenig@amd.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AA7E61A0003
X-Stat-Signature: 6ewrcwha6c6hrtdj3zftyjafejryo7t7
X-HE-Tag: 1789564924-369304
X-HE-Meta: U2FsdGVkX1+JIP9LJMvwiVIhfIhm9sWR40ZaaD0Wn+p0qOPG5oKauP+Y4jFJ3etnFEFdj7FD2eA3VL3pqLUkaZdCfQ44W9h6JhR5FiY0X30DAPDWajfd4QockrOC1b3mZjbihFy4mMegeCkS87HP5S3PtL+Vy7cmxRe6hdpIm/HAKtVz7WJpwuxB0n2Gc4lTq6A0sVGbCyvDpcTC2sPewpC0FKFXlPAfT1uESrKa2d8ME1r3JSxeaRgoHLSd0gWOsl8w8GmbFhm7a4efAiLoUViMUybnimqYA1NBgXPKelozi3Le2ShSWI0cJUrl5ymyioOW4yMW2/sPo5RnR4NRZJ/0Qhy2zDb4fBEhQ8n87lW82Vd/5c8GY5IowL+hFq6h9Jmj91BBfe8dyKDFR/UHVwmzWDqIj9BfH+pJVZiwtcpEbUoaBqzlUjJTSXHR0oV8F7/J/K6n9UzBpxfBJLnPQidQGBanUhb9EleMqPGzlmJ3dbZs52RRjk353X8d6kyvJdXvlHJx2W3WExpKQbPUyruR/Nsree+rpv1xxWg72bZqnj0aWf/bQanA+9V3A/MIYIGIQzcZFPEJU6wcDObiCKPLJO/BGPJCLMpGqhIYgIMuskgz52LMcbqFx5v35nlAQkUk56OBn+sQJUgympSZ1HDvr3Fc1Mc8/yzezhKgOHeOuvimKbz2Iz72sQe3JoNsEfb5T3/trA68ch8t7ttkze/syCzgOE6OvdR4U9ktz/mnh3TjCQaZntkeOq4dZLCXdqY2XvcAEjI9WOVSSxShPTvKgbNMCJHFigCqKI3hR238Y7t8CNzfaKwhCcM3+hraAzyv0DWJlBCTLBKrGLriNsNgfFGNUdpPsjTqOQNBXyI3R+DYvJVhdOd36ZapKyBPgT4qzeqdoHci3+sHIknyU3wIbZmvLBZQtufRSG8scL+526KPQ778Y4yry/49CtlIAsrUi4vOcjx1Rsahhej
 V4dtbSz9
 stkQdlCdxpLZlSrxCC2VAiOTlYn530aJuVDmGhpX2WGQxjVHRUe5VGgoM6ZYwKc7yn6axeBKhZQeoLH3rwHICwdJEH6t9XMtaED0zt2/SO57FDU+J5dz6VbAWbHRB+0yMxo4Xc2Y9brcQeSBLAL3q1AH+FF8j2jCuYtzZo9CFOwz3VT16mDCtNxeKZa0yeGuliKCg5WReHeKJyGM+QoNH7HSsSgI075Wcb2D9pP+rQ5UmZDoNFn3fscevAoejqig/SNErLbHBSvpzhmi4XTnzzJ04IkCUE+eh8QIsHwRRDrwI43A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

F:	include/linux/*fence.h

in "DMA BUFFER SHARING FRAMEWORK" entry matches include/linux/kfence.h
although that header has nothing to do with dma-buf.

Replace it with explicit 'include/linux/dma-fence.h'.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c2414447892c2..656bc5ed8d2ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7688,7 +7688,7 @@ T:	git https://gitlab.freedesktop.org/drm/misc/kernel.git
 F:	Documentation/driver-api/dma-buf.rst
 F:	Documentation/userspace-api/dma-buf-alloc-exchange.rst
 F:	drivers/dma-buf/
-F:	include/linux/*fence.h
+F:	include/linux/dma-fence.h
 F:	include/linux/dma-buf.h
 F:	include/linux/dma-buf/
 F:	include/linux/dma-resv.h

---
base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
change-id: 20260916-maint-dma-buf-3311abfdc90e

--
Sincerely yours,
Mike.


