Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 580DAC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E9A6B00D9; Mon, 21 Sep 2026 08:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9E46B00D7; Mon, 21 Sep 2026 08:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EA1E6B00D9; Mon, 21 Sep 2026 08:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 263F36B00D5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:31:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0DAF4A0166
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:31:37 +0000 (UTC)
X-FDA: 85237705434.11.AE50F91
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4F55840007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:31:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=D7grE8ZP;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789993895;
	b=HQ2NfjoZBtu/xqieL17LZD+p7ZuNwdOd1vP4ovtUMA6ls0kMuVhRzE5D2pw2CLJErhgH+M
	JLj8dVjIfLiYnwjSdfXKskO0kD7SyZhD/vzo6SSBszwBTJTR/AaNj0NpJxciwhloWKRhw/
	deYok5gbsI05qFnmQtq8kCdnxiovuqA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=D7grE8ZP;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789993895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=itzIMrZmkJ8MCeTVLVRxYjqDuw4fC9HM264ZP4CC/sA=;
	b=3r+VIXWmXNRE5ps6i3AuewSlyShSddOqm6jfMjkvxKJmfWmzHhxdQf9tJwCVf9V5VfJzBj
	EFRzWxwoGq1YybKXoTzeBA8uewcFEyGXxS7RlLYVh0t2QgTko02aK+t1Gbu1csb8EOcQh0
	vUM08MEKhaDJTDN9tZ5b9kiAoeYo3xQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=itzIMrZmkJ8MCeTVLVRxYjqDuw4fC9HM264ZP4CC/sA=; b=D7grE8ZPMQxDkp3ySxIdfArfIL
	+Rap0h8EvJpyGDjwx20BhmclpbVHzdwC0LfiTSBR06n9eyT/uyntHi7VMmOgvC/BR1APlcIIG3qrO
	hoFzmZr0wIdsUG14ziidDPi+FH76S1cSelpIuQvJyC5tz33I4jMD/NqUnMDNJsaFr5ugC6YtaJecD
	La8EtZxBX8B9o9xReHGNl9PIoCh5J96j59ztYhYiGLuqNc7+v9sCjW+K8MBl24fdZdP/wlcYuOFxL
	mlvEnw4K4fc/akIAwqHmzyAxPWWoI80XJX6GBCVXHyJ/7RRaLLud2ftDj6TCh9nMRhAAfM+Bbc9Da
	FONFwD3Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x8dBB-002CbU-2Y;
	Mon, 21 Sep 2026 12:31:30 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH 0/2] mm: kmemleak: batch the struct page scan
Date: Mon, 21 Sep 2026 05:30:25 -0700
Message-Id: <20260921-b4-kmemleak-page-scan-v1-0-fb97d4801b3a@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGEjsWoC/yXMQQ6CQAyF4auQrm0yEIKjVzEuOqVAQUYyVWNCu
 DujLL+8vH8Fk6RicC1WSPJR02fMKE8F8ECxF9Q2GypXNe5Segw1TrPMD6EJF8q7MUXkM3ETnPd
 cd5C/S5JOv//u7X7Y3mEUfv1isG07CW19I3kAAAA=
X-Change-ID: 20260918-b4-kmemleak-page-scan-c7ac6b088c4f
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=1936; i=leitao@debian.org;
 h=from:subject:message-id; bh=bFMsXFJyQ36WfeksTJPCjrhaFvrzgYycx+/jO0rLZYM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqsSOdebnPkkS0U9mCkMeiu0aKMri1nI9kkUYDp
 xqAwOwP/niJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCarEjnQAKCRA1o5Of/Hh3
 bdSzEACgRVNBpvLdVBMPsKl2a/DZmmoFmxJIp51KzGgZvAoWPG9BZXk9u3x9VgLvQaDA7/VmFHS
 pIP9oCsUz8KvbI04hHjvG4Tzc+k1M5fzjSLZ4RM7kYrX+LkZaPOFkSNJqVYyVoxKJKSxjVZAIdW
 CQ+VmXlfZyECHGUJ+9KVIAG/AyctKttvctwN/MtZDJVXXd78U1/e40rLRnJO7RxxijIKAqwYfdz
 bMuG5GJcVwRsd21VEElIcWxvNKuGYAD0ohCqFPQJl63YolvocA+UdBzKkOFjjzkL4iswh+3m03V
 KG7rxJXBsYA+tRrFoPR22aaP+RguJBVVSnEfvS7F5EsHogm0L/kiYduYlHmQrH0BAnxZ7YWXr29
 WYOQH73i9AcGedZYv2/JHC2SjoV+vrRlkFfJRxahSxxXu3Rovj6sJEV7FCRPIlcPu3jhfrrnkwf
 u3sTeQ7i6M6TrOsElbkF0xXgirqGrkv29Ys+LB60H5o8AA9fFE/hrxXD8W2yCb96AleSvqOMeSo
 Q6rcwzo90PJIEBh4vk/wesHtslQ6r9YD+thveDKf0Q2DF9SxeAuELXQ0dso327rX7qPBsYD/hcW
 uDo11CTZJnhuaf/W2DWzz6yhB4Dh8yz6jL13Va2MeuquKIURhTp3N+gFX3Jm2svDOH5rQthZoii
 JpBFR8Mbml+27Cw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F55840007
X-Stat-Signature: d4psg4shkcp13byw8953ya8xojej9fk1
X-Rspam-User: 
X-HE-Tag: 1789993895-360158
X-HE-Meta: U2FsdGVkX1/m1fOuGS+CgDZAQj9h+btddTzylV4bhNJVF3sL/DwlNRmlkKAlgeaNfHFPszolKg8m5BzNy4Kwfndvkt1SqwbBfxZeqs69vNC0+33CpTzjxI+aasDP2ac0CmQol7nphvMNaC92qwfKIjMD/Cx6YsREbPVqApZ16zVLu6m0fc2i+QRxt/I3U1kdTYEUBJaqep4uW6gNpOdGNr/ANAjQa9PhICrI9+d0oPT1OZ7Ei+Sl03i+Yhuouveg7Mt+m1IrpByyGWLliCK7xJhZNrKxKwmBtTJwUZWIG62+oR7E/ZdF3M3aS15/GqFHBC/7K7e4ovtxCIrMVoSQI6O1xu1tLIBdjcsmVkgT/NJe7YXDKL7n8sSL55XKktozxPjetQHTrvZ30NkE5Am+8QCGHACE7V6sH/JZkq8k8u2b1YKxrVPqYY1mq5ypOb+4z4AXwSoLecEudgTGMduIeV03aKm5KyTZfmE6wvGEliVFeOYEJMbDNWTAmDLoNs19Vy7d3nNvEPiHqZs5x0F5SFSp/6eCQintlGkFSlEFIWR3kJCk4Y6BcoAVjoKAy72KlFxcS+/U9YiUKfr1ygYp1HeSFEKg/xq6snlaRSa0JYof06D7n0dgPFtw/06jpWya+fY+1Uq7IacmT3lVfCxBWO0OTKTXV/gY4x12MVHgmCmJBSompv71Wv9YYEjvsl0ZPZtmyPGdoYi5v4X0NsILK4MqvaQc/Y7ZljL/l+PEXeMjhmmqUfbasHiHdll46g+YWlqCXcCblM+LvzlSM30CsGcLuJKY0zKm9NBimklCBjWJ5OiMOtG1H2Z8umC0opYkNWkSDJGBTSoYyqHaEjJkjZdR7wZzXCU94u3q30/42Dljk9NUB8ccZtmY3WzEeLyhV69z4roxa1laFQLaXCBM1dy1GX8NAZjGm4D/LrZaHmpbZ7T2URJS6Z1FWi+lYgAqRmoJPxHP2adOjvolo8Y
 GKq7Ry35
 Yc6fKWUpovDv31U2PDw06JvpJXqSL6Wj5PKVCh2nTH+mI74Xnan7Om3vlhtDGEfnjKv1f3N8UHqp44fq9Oe8MckCrrUFAJxN0VWIz6WQ/BjDGGNzDDThe4u13Ymy57K13vO78+hJw8eiBJ7ibGqSfYHY5CuhXfAGv1yqUU1KPBOJTZyFX+JhxPz+FKThUWw+mdMJXsoSx8FWsAsZtz1CUdU6Ps9nJKQQpdwfyoyQRtgtxZx+IfQgGbXFhGQ06nv0b7CVOKezCUm+tXYZqTvKwB8UDaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmemleak walks the struct page array as a scan root and hands it to
scan_block() one page at a time.

scan_block() takes kmemleak_lock with interrupts disabled for the
duration of the call, so the scanner acquires the lock once per online
PFN in order to look at a single 64-byte struct page.

Batching adjacent pages up to that size keeps exactly the same pages
under the same maximum lock hold time, with MAX_SCAN_SIZE / pagesize
fewer acquisitions.

Patch 1 lifts the loop out of __kmemleak_scan() into scan_zone_pages()
with no functional change. Patch 2 does the batching, which is then
contained in that one function.

This improves the performance due to less atomic operations, which is
not a big deal on a regular machine, but, given kmemleak usually comes
with extra debug options, such as PROVE_LOCKING, DEBUG_SPINLOCK, etc.

For instance, measuring Meta's "debug kernel flavor" on an arm64 hosts,
this improve the scan time by 20%.

It is safe to get more work into scan_block(), given it has the
protections, added by commit eb11f56eeca560 ("mm/kmemleak: stop the task
stack scan early when interrupted")

MAX_SCAN_SIZE is also not a new maximum for a single scan_block() call.
kmemleak_scan_task_stacks() already hands it a whole task stack in one
go. On arm64 and x86_64 THREAD_SIZE is never below 16 KiB, four times
MAX_SCAN_SIZE, and it is 64 KiB on arm64 with 64K pages.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Breno Leitao (2):
      mm: kmemleak: move the struct page scan into a helper
      mm: kmemleak: scan the struct page array in MAX_SCAN_SIZE batches

 mm/kmemleak.c | 70 +++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 47 insertions(+), 23 deletions(-)
---
base-commit: 3f2425f5b5bbbdd991ca9cdfd5502e68d8895998
change-id: 20260918-b4-kmemleak-page-scan-c7ac6b088c4f

Best regards,
--  
Breno Leitao <leitao@debian.org>


