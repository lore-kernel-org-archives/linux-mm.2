Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CDCFEA3C28
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 10:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C2D6B0005; Thu,  9 Apr 2026 06:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496166B0088; Thu,  9 Apr 2026 06:33:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35E166B008A; Thu,  9 Apr 2026 06:33:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 213686B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 06:33:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BEDBFE2CD7
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:33:26 +0000 (UTC)
X-FDA: 84638655612.30.F6051D1
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id D36B840008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:33:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=POD5uUIZ
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775730804; a=rsa-sha256;
	cv=none;
	b=5ANBHlGYMIMK8SAMpOG8Iopy+1g1EWF5G9mcrvmNFXbUxebOpAXxOhWzYNIcB/muPVUa+t
	ZRuzH4dz6WBeZ3cPrn7OvXYLIpOyRNABGF6I71Z6xpzNsjY1BvsPrL7WtBFpXIfg2hwwml
	eDe+BOd9ViVDhbYkBAmxtipgecWYltY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775730804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xOrV9v/5kxkZp0KXqbx4oj3rerkVpVOAiY3HoKygQhQ=;
	b=Q4GnfcdPtHGVHSoQeIH8eVB3MR31o9APHQj43/PdAH33MCYck4avRDvxCgO4HPTksyDTEg
	qvE71aG0p5fufzsl6Z9J/fOtLq8EMmzlEcIayDDfbTnSY4G4LQnQketJEw6HJ7bGKf9/tK
	SXQWkguGaLFHFK7JZLUxr9iqp9Vrzi0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=POD5uUIZ;
	spf=none (imf17.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=xOrV9v/5kxkZp0KXqbx4oj3rerkVpVOAiY3HoKygQhQ=; b=POD5uUIZoOTuiW6NvSJFl/al3v
	kyctPd4Lx/snwwcr/OqX+VbUyglwKdUwj0ciLg9yugoI4LHruQFZ0D48BQQgUuklW0ooaVYdccQmQ
	SGO9l9h1JN75E+YI9fSuGs0erYD8q6edi1YeGPneeukROmKLcaWVcM2XnMUcbx1oCb1aU9NaAjPbt
	eCQ4d89Vu18CPNmDxRxBx+tr/ObTfbu6R1z1DWKcL2Y3Nz0t0a6oLjIb+fyqXCRWdVhy3g7OYOApk
	JqtLIV99moAa5pGsv/M3k5JOrbWHa6IqpaTMG4tQ2iwZqOJcnkgkP9oxnLq94nMP1DTYcjC6E95tF
	xpOa63EQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wAmhM-0098a8-2h;
	Thu, 09 Apr 2026 10:33:21 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 09 Apr 2026 03:31:40 -0700
Subject: [PATCH] kho: call kho_kexec_metadata_init() for both boot paths
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260409-kho_fix_merge_issue-v1-1-710c84ceaa85@debian.org>
X-B4-Tracking: v=1; b=H4sIAAuA12kC/yXMQQqDMBAF0KsMf20gihWbq0gJiY46LWrJ1CKId
 y/a5du8HcpJWOFoR+KvqCwzHOUZoR3DPLCRDo5Q2KKypb2b17j4XjY/cRrYi+rKpguxrqsYy5D
 fkBHeiXvZrrV5/K1rfHL7OSscxw+z/pjLdwAAAA==
X-Change-ID: 20260409-kho_fix_merge_issue-dab886bb4a15
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, SeongJae Park <sj@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=1854; i=leitao@debian.org;
 h=from:subject:message-id; bh=5TlKEPR92vw6WZwmmebWNqLJax06gARkdAVbmtTdh6M=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp14BtJdPwc3Hpzi3uZYw2/s/qlNiR0GbkZVNEi
 dueDjuqzMSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadeAbQAKCRA1o5Of/Hh3
 bco2D/9u05uwdj+Zbie+rIxz6AQMsA1kX0NaBwLKkxNj9ytJ9DyIXCbjq7jiDnQBplZD/5iQtIW
 72teRKZHY3ubuCjx+uIA+cvy4Q8tGAFF7IGuuoxcCKfmHl212FOE7VrCv1gfEadMC38KuldqLFm
 S18mYegdvopvZ8sqiTt4f8owggEho98Aw4PNIDmw0ZMH0Ncrltt1Q9r41GCO/fO1krw4BbbaMnb
 2USc3JZz/oCKTX4gIIQzH52AwFboEWYHnuH1WY+XSe/00pUuq1Z5rgaaPQAWPau2k/jz+oViwhF
 +Uv2uRgkBnyAF7AdUkTJQi6dOAmmoqQytIFtfRxHqdOOENgIbeoylRNVc38kPa6N5zfaJsQC/EX
 8SQHQLFzCTG5ag92i1Tup6jMZIn4BND9lucvnOvWw04kDaqM6Rjp6n8ns8Tx1kQKXtcBw7Ell/u
 B6/Gv2uQxBFfaJwRW/qg+9XmhyT8IUvHFzpyd/C2VVzQnBUgq1WzYM1fIlAFJ59XYjCZBtiWtGm
 /JjsrcWr3WRNysn/zkzPIF/yspzBHoLSPwS2JS9TyGcyEsXeEP6pmOuMtlBYrpQ+k7Hry55zln6
 FFSJrtjH17appPImq9DT1f4jSNVkY7G3C1WmgY/9xVGRC6hxaLZGb4nPzuee6ayBSLXS3Jng7Fo
 dN8ZsreJPOFjWHg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D36B840008
X-Stat-Signature: ryrerur3zfsimrd8c3kstkrs3o1xz3ma
X-HE-Tag: 1775730804-9642
X-HE-Meta: U2FsdGVkX18gfHJOthxTCF0q60kqk7TM3M794o7vxVvYTSTTNtvxYyvrdENt1oDRlPmntQWsuLHFgqAkuaA+zkhlEnDwQf5WXkovQqfAWFJ2f5PMXTQsUOvCMJ4BJw2Xsm3TZVJTjYaa/57b1DPuk1GStDafcP67Sl6MQCRl9OMk2jdeDW5OFeXvu4y7WfkrS8uLdi+4GbwGRU0HpedupJpfnMyaO2uBynMlghqSIthXpwGGP0V3I2MMGgbVZM2p3cnGGExzYnSaCM3tW/PBcp+RuxPcG9cfkxoZQrYO3ea6CUeSyXKgrjB+doZynlFK5L1ffY2Q0Yr84LwT43T5PGhDa1OdwnahGWxgzdmBiW8FibF6ANZKA4HL24YbLG2u8qREYxRpaQtfBSN97bW8bOS01SqbpQkwo/J4Qo/CPSthpHXEaofr7VF45OGPy9oWDodPt7CKuj+G2epShQ8lQfuo4P7+ZzUKyqTLBbVyphJToXmB6A0DpPb8thEwLeMi0h/8Ku2DOX2hEmCc1QjSqFOFN8RoiiUOo97kXhu0ZXqkwcHevwZtR5ajZZO62TB6ItWjiK2Y4202qwGYbPT2BvKM0npKWFM3ynOuSmGCFMMq9GHs4eP3PKDYySkJgzDngW8AxgnGGJzlwUJYYI51GoCr3T3e4AUs3rTRWBoif9TaAbz8vIWa0LjGlkSOYxyCtKgFsePHfLryZMJE3ED8gAfYB1HFdTctziyDebrp8NF8vPyDfd49A9iX+aJ5HngkGQuwJ4YHcGbVPPTZmEWddjNto4X54lnHsAUJhBaa/CeUj7IYWidFGFav9AwUGT8Vq/6/mC8XgBUHizYsezgPlDkpzdUvMJRalBhgJ6PEvWn1YmfLOyl63q9SStBl39d+qKNNhxBwBUQRiiGAhKqrxpIQ9CsIWNGzsnGaSh5Tc85hy43UxdrTgnvIA4hnieSb0IHnmIqygnrJTQftjfe
 qFmWkSyI
 30ICngzu8wUk5QowXSVA7FeRMFh+PnhztylvShXQIhd2Cs9wZfMGboDCJxYuZvnxvRqx9V6q44GrnCSsIzfm1IRZ3H92dT0d1TdD148zG264UzB2XMamHAvbXHrbwh+PY47oLgukBnKTnXoZ58DNwJQicC5qyX5rjIxWTd89CltIwjcKJDYnbUXF/TWqqSuMZPpQfXgnOFM5MlRJSGqQnq763dhUZflNXk5l+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kho_kexec_metadata_init() was placed after the fdt check, causing it to
run only on the fresh boot path (no incoming FDT) and skipping metadata
initialization on the KHO restore path.

The original patch[1] was based on commit 5c9e55fecf93658 ("Add linux-next
specific files for 20260312"), which included commit d7176a010afce8
("kho: fix deferred init of kho scratch"). That commit has since been
rebased and reworked in linux-next, changing the code flow so that
kho_kexec_metadata_init() is no longer reached on the restore path.

Fix this by moving the call before the fdt check so it runs regardless
of whether an incoming FDT is present.

Link: https://lore.kernel.org/all/20260309-kho-v8-5-c3abcf4ac750@debian.org/ [1]
Fixes: 047117e78331a ("kho: kexec-metadata: track previous kernel chain")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 kernel/liveupdate/kexec_handover.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 5e8206235d99e..94762de1fe5f0 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1519,15 +1519,15 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
+	err = kho_kexec_metadata_init(fdt);
+	if (err)
+		goto err_free_fdt;
+
 	if (fdt) {
 		kho_in_debugfs_init(&kho_in.dbg, fdt);
 		return 0;
 	}
 
-	err = kho_kexec_metadata_init(fdt);
-	if (err)
-		goto err_free_fdt;
-
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		unsigned long base_pfn = PHYS_PFN(kho_scratch[i].addr);
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;

---
base-commit: db7efce4ae23ad5e42f5f55428f529ff62b86fab
change-id: 20260409-kho_fix_merge_issue-dab886bb4a15

Best regards,
--  
Breno Leitao <leitao@debian.org>


