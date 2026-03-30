Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F9810D14A4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 12:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88FD6B0099; Mon, 30 Mar 2026 08:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B398A6B009B; Mon, 30 Mar 2026 08:05:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25BC6B00A0; Mon, 30 Mar 2026 08:05:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CFF66B0099
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:05:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 499E45B647
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:05:31 +0000 (UTC)
X-FDA: 84602599662.12.3863420
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B9D2D14000E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:05:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fHp5i//h";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774872329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HzMwiYxm7mUC5hPe18dWQVLKlHtxF1R3ogPeDPOGd5w=;
	b=zj3JSzb0KQza/X8dFvgrmKy4+ARo3SuQ/KzSw0w8SYkTMZENW1tnOO7NW+OkW/1Adki4Ig
	96zFT76CeTXWf9ylvtHQ5hwEvxWt3uncwRSTdrJjKfdSmIw3PZ4tYx84LqisSLi/rbiYdC
	JLJ6Wb/bO5bGbg0GTBalLma9+vBQmt4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774872329; a=rsa-sha256;
	cv=none;
	b=oAoTO5DBNVjIPS/49RiazEDBaXki0C8TiKeXEGFZ7hhvEfBdDbUF5QtFXo5JeaS5HNMhdT
	UFKKYfHlTpfw7f1+SFi+xjudK5ajPcr4/+M8BUMT5MZ07t+jBGD4t26H9NcHpI5DlgyyX4
	HbW4ErYLPLiModv3Qs4FcX94zfMfG7Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fHp5i//h";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E83A60130;
	Mon, 30 Mar 2026 12:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B65AC2BCB0;
	Mon, 30 Mar 2026 12:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774872329;
	bh=3YAzMlMeOCrZ28GqQoCsD/ygZK0bAT3TmpmN5xJXIE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHp5i//hU2PYbop8C5stsJRnhWZ8wzJtYv4nGlIwbHGol9FEtgyveBDLFqan/3wup
	 7+uvb8JxqsRC7pbMns7pmKW2qGz86XEZar/UtikVE6CXc2zBmwh791gA/1CItMjASf
	 xpBguOxJ9FMl7u1XWbr/jjAxhRbuNVvcEWkR8ayKUZ0Vj2ZKqpNmiOiw7RxnNHbAZ4
	 tt8Hm89UTBLAmatDRBvDnyN37Nwt0GUNMgrLq6EQ1J8j8Itlu8PZx6RJLjx0Jspgay
	 vYblVsRJmLQ6Tq2mPNY1IZS0F4f7nMsOiRKh/++Oe2pBVasyxS06dmNJtESGv4udzj
	 +Fi8mi2JPek9A==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	"Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH V1 1/2] MAINTAINERS: add lib/tests/slub_kunit.c to SLAB ALLOCATOR section
Date: Mon, 30 Mar 2026 21:05:15 +0900
Message-ID: <20260330120517.104743-2-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330120517.104743-1-harry@kernel.org>
References: <20260330120517.104743-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B9D2D14000E
X-Stat-Signature: n95nugz39uswp7muo7judj5am5qd4yxr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774872329-749495
X-HE-Meta: U2FsdGVkX1+XsrstNsQZVV9aAn/w6Kio1OFXlbmKgzWwap1nWirkB4wzER6uvUarsP7rR3tzrhoyQC3YRkXYMGYOTJWOmXFYAGOhiTSHmQ+Cx0U46mmRlVIyT3I1Kt/Y/7F9Ok60ntFU/DBhQ4UDrsGJ/uUZaqS6h9b545fdEOb06e7lftWXaRfqIWBKCPkZE5Z7DNv9LoyUVOwO/tYUSnwcq1JerT744Sfr936rDlIM7MOqS1C82b03w33cmhozayFdV+mDanz/PT8AzzTJyjBHKOkA+/JFyTWMD3877chT5/DcKvh0fD2bBpuAkuoiLJLk+4Qc0f4mQpBaCIvbxZbr9FncdfdAm2jJIYLJbEkFA6cb2k37+xPOcnSWvE/MbWvQp5TYZ+5xhJIGn+ffG2bjkcySqbWRRS0djM9lW8Fkz9bNurT7k+Mk+nMvbhMp4GrXiLZ2t4y4xBUDo1LbD0jVWD08XYXGEqLHdcWJMr9FxiKfG8150xs04u8QxiL4m6NQBH2fC5FrupSeY5KZtfZDKTHsqtrUyXOcCIHYbEAK3/Y64rpdlqyr5o44OdKlFx/fcopFf1ehXIJHCfpAyv1bG44l038E8nfVXyYrfJTCvxzOJMZshlVTs+eh6TYAgZJic17OAfqqhm5Lq5yCqZy8ZuJXly8owmIGpNLL2tMxyYcGvNaGnIDXi9xeqCyrQgZ/jYE85p1DiAs9KwCJ674lJq5DFcxP90RkE023sTYaHOkwYA2YuGWmd4N/MwqMwcFUW/mFwetIQW+OlWR0dlRZOli4WjA72Cc5IIABRxBfW1PqztXYEYDDGKiTBnCFJbOG6ogGRfBcwHk3met/yjrvuQwnEuLD6axj5XlAbal3d5nkTlcuoD3QebJscqAUSJy96e83JjbG3G+edtkUgeHMkGtRi8FGyXOG/FydhbeYutFjCc838wcZI86DFAjlYispdh+/LADN/ow6VOc
 TuONsGuv
 NfwjM6o/pj/F20VPDQG82cWE0BFWm7E5o/WHraMtPXpektyoveqtmDKRRXDjAB16cVk+MtYtzaj8esHGRcAA/BhxAUjSrC6/nChaUKmeKct0eC7ETC/RFjaJmt4TnbtDKUw1sHabP/kPcSFpVvH/rjZSFONwVueCvfPm0Hzj0FU2yD/iqo21867uZDsPa4lbUgpFbjqoHiVuJmYaaVTvUrQSpmnM7fvIOSjtHebJY+KQhGXnltNBL1eR5DFMqpIHWvcpB5wHzfe5Kj/bUR4Fz1Sr8OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The slub_kunit module has been maintained by SLAB ALLOCATOR folks,
but is missing in the MAINTAINERS file. Add the missing entry.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 96ea84948d76..5f5add4f72a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24354,6 +24354,7 @@ F:	Documentation/admin-guide/mm/slab.rst
 F:	Documentation/mm/slab.rst
 F:	include/linux/mempool.h
 F:	include/linux/slab.h
+F:	lib/tests/slub_kunit.c
 F:	mm/failslab.c
 F:	mm/mempool.c
 F:	mm/slab.h
-- 
2.43.0


