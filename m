Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21033CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B856B0088; Thu, 15 Oct 2026 12:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013626B008C; Thu, 15 Oct 2026 12:32:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C7E6B0095; Thu, 15 Oct 2026 12:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C490C6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:32:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 569E4C0116
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:32:05 +0000 (UTC)
X-FDA: 85325402610.28.C28CD55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9217F20006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:32:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AKtG+cuE;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792081923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5UDMqtw54d6/qy4Jttb/86PiM7pxwIVD6wfg8FpzVr4=;
	b=C/lCYddRTW6OumLweBKq8nf7jUjxgQCSNgAto/ZP1ZdoF6STfrRVd6S/pbZTOF8CWj1Dfz
	Mw8b5mXPVPxCyIJkK1iK2r07+6g70LuJaTFpAA4n/cW9a+wts/3Yt9t6JSW/3p9aTZQ2ZX
	ru/6FzYnA7LGQWFLfCIDUw2/FMTxTCA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792081923;
	b=3Gp5mjByeL389ZJq2ovIokcShARaqIL9kl0HlAhOtYCVzlcb40h9FYZUHJH5xjNbQwVepN
	IDs7M8CsImZhGfJV/g+FyFXebHZ/lh5weDMWPTNffdRgb4bvoAdJMniPXa9CQFM/TTu7kh
	2GRWJ2FkwwhuUTnDzykO77dnNBsr1xA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AKtG+cuE;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C284343748;
	Thu, 15 Oct 2026 16:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDA51F000C4;
	Thu, 15 Oct 2026 16:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792081922;
	bh=5UDMqtw54d6/qy4Jttb/86PiM7pxwIVD6wfg8FpzVr4=;
	h=From:Date:Subject:To:Cc;
	b=AKtG+cuEdRdcHnI2bC9bkgGF3tcrhkLVvjO7KAu+Mvox/wFJrc08B+bbuDtA+pSYu
	 w547Fh20Y0EEBt80AcvTVFG2SRwxL8vZ6ezaZiy/Tbaa7inRyOaJjNFIFjnkruMBqG
	 IgTRdEEyhXLG6xYY02WY37Yr8eEQ4XcLNetTuPAJUfbW3DfcurY3yoWv9zu3s1H8Ft
	 gXRsrGh6y3KJkDTNHbxd2T5uPaIGn/EuiJATuxCXERky+Jx6s1evOe2asYn/mnyPin
	 WRRZytq7GvUNYB6pz0doME6W1qYeU5BV9Y/pX/dXQb1tEO8Oen9CpHZmDN/8EmL4Id
	 vyQE627BQ5kcQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 15 Oct 2026 18:31:46 +0200
Subject: [PATCH] MAINTAINERS: exclude DAMON docs from MEMORY MANAGEMENT -
 MISC
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-maint-mm-core-x-doc-damon-v1-1-226decb5cd0d@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPH/0GoC/yXMQQrCMBBG4auUWTvQBFJKr1JcxMyvTiGJJLUUS
 u9u1OW3eO+giqKoNHUHFWxaNacGc+koPH16gFWayfZ2ML1xHL2mlWPkkAt4Z8mBxcecWKx4Nwg
 cMFLrXwV33X/v+fp3fd8WhPU7pPP8AIeilvt9AAAA
X-Change-ID: 20261015-maint-mm-core-x-doc-damon-d2da56de5ee8
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, damon@lists.linux.dev, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1187; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=iwAp1WxneTu40UtJSubGmq22Cuaf2WoUTUwAQPE2bjw=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWRd+P/71SZvpcea//dwy298qs6+es2+psN/ZEw3vmHXM
 cm8kRSc2Mnoz8LAyMFgKabIUr37hKPoTGWPaR6+H2EGsTKBTJEWaWAAAhYGvtzEvFIjHSM9U21D
 PUMgQ8eIgYtTAKba4yT7P+OjOjsM5SK3a11V08sQ0G6J3VFmcCJk52fzjNM+uVaHvD+lnll6YIt
 1TdVLj02n3sq9rNub3L3fPej74Sjl4Nj1BndYDbfpML1Z/dKdy+HGS8+Y1XkfFmkkH0lI3/po+p
 wT3yNcOS3evTu+Jqox9KtYvYjMnhJHz7nVmyYVs+zax1KtUXW0KUfQOtslbce8ih/Lpsb8K92QO
 iFi49s/qyruHHu27Zs/A+sWd6XQNZ+0snSbFT9Gxt9vvem8WO90Xvb6WQ4fLX8Jf12mk5i9JCvN
 Jcne+ReH8zzdbpNgnvmPxH1M1aSid8jIsfEu7T6/3VLZ+P+s0G63Jc4m00Jvp+30u3whdcbar5r
 pK2dYAwA=
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9217F20006
X-Rspam-User: 
X-Stat-Signature: 17uhj8cp6k9hkdx4z68n5kyoukz5sgc9
X-HE-Tag: 1792081923-934373
X-HE-Meta: U2FsdGVkX1+Vz0HORbucmwAH/5eCc1o7ruHkrV1g/ThLwyk8Irt6TNbpA3qRnO4lprmfS7O8iO1e32skxYaGohSigARkuK3XmiL1qTc/hXZcB/TIWZctdOLng8KED7GOIXrPhqPHXJM0S0AoVlR3SlARZsh3FUDWdEWqDjR+LVRCk+KKQ1t2aeXENpVraRnLsekiiYKPNihMKrfkksLppKMxka71Cg1enUbJdEcP9qnxGA9Nzk0SfQr7Kyc44xoo4TLyNx55wlVvC6dEiWVyUIeQ/23gQ54wyd3aXvU818P0PNM0rIm727/vfHo7dqDVxY+Olxl7Ciuj9M2OBN0kKLI2soxqBzxmnRRoa4IYDHOtve0jWOurSQWOc2FfpeW1vkQiJm1Q25pcgP75+NzojmRuTc5Tkku9Jh6uqQXqQYcI4J7afubbJbCADPPGnKTxOdHbOijFONXcCD/s0YEeL28YXfuOrghipftOCyT/2tEaBBZIzQNySHDeI6eBFs9EKB2xS2YMwFjU6+vJXPFwMNty9bT3pYoqaBEcXD1ztWkKdug6FxpDYQySu6HSqGmVlWjzyxB3aO7mH9mH8QIHm34GI9j8S5W6MUT95vTKOHi8tjFrPv4eKYXXKfgsM03gkQlldTAfoLB5YIJVcGSBiD/xiq5iLVuu0eRs9Mv+s/Z/rn/s+hfSnz5ReszXONB1Eh6ke+1baEiDmdK2IVpWMXG3O0bEpM4Cl9mOuvfLSDYeaPwBLrR86/n3P+e5T/vEkPLrTXeuN+EE8Jr47c13pr6AIwKGxoCHYpojZgMLTJ45CzjHk78dBoLTEaWjSYXzgzKRnFuhY6mrolaVTyDs1NrxFauILXIWW8xtqiPOSviAkSwmTPwQFCZpXt5KAkoaM/IBg5U4+9LB5/qq9sngEyGeNCstTJRtmIQt7nuEtlCO+r76TbsLrh3k+g9GQMuxEDpUAK8pdKoIpZ+bvf7
 EUPLf/bu
 OyX3JhnTpRgd5/1JlrBGLPnnzAClbWO3aF3ur8aDWgqbRtKarL/rdYtz8FOkSNxHgfpC31T9/rdykvam6BBbCU5Xc4slQRYWDyquF5AYaWqtPLA3k+Df3MRRUwEOAXkSSKW8EsJR0lploytuBTmOS9rwvJ3toyuNi9xMfJt8mQ271YcjZ8hohx6JIOEFAvRumiaVLzUGv7zXNrZzmfDNMYbr+ppAUSwI7X//CYmqpukryeCieFznlIrZ7Hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MEMORY MANAGEMENT - MISC is a list of misc mm sources and also acts as
catch-all for the mm Documentation subdirectories. Documentation for
DAMON is well maintained within its own subsystem and also actively
updated, so there's no need to Cc all MISC maintainers for them as well.
Thus add exclusion entries for them.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
I'd love to have the time to check the DAMON documentation changes, but
it's simply not happening, so this will save some mail traffic for me,
if others agree.
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f53047aa8d3c..cbe565b353d1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17269,6 +17269,8 @@ F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
 F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
+X:	Documentation/admin-guide/mm/damon/
+X:	Documentation/mm/damon/
 F:	drivers/char/mem.c
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h

---
base-commit: d6d3455d8751854e0d1820f14184682e23ac4475
change-id: 20261015-maint-mm-core-x-doc-damon-d2da56de5ee8


