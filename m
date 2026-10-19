Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9450DCCF2DF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 02:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D8E76B00E8; Sun, 18 Oct 2026 22:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184936B00E9; Sun, 18 Oct 2026 22:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0734B6B00EA; Sun, 18 Oct 2026 22:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4CDB6B00E8
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:11:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 49AB91A0617
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:26 +0000 (UTC)
X-FDA: 85337748972.22.5B22BB8
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 89DF4A0002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YKdF9zCA;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFKyVkuGCKpOVLuQsnhKod7q0RL600zFuUYepG6R/FE=;
	b=vGg7JgaMzr7IUK3PJTya3jg+KSYTPDJalnC/HjX+RyQArhCmiFGqlF5tA9zzffSGQ4dgnT
	uu02mO1HlhgkLiPZzF5hMR+djyhX+vpPraT33B34VfFrW+e99GXbLFvUPOAvwL2A76JGei
	FB/6J4xVnDNToVTAyUS1T750IR1R38A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792375884;
	b=QKkWPbWvxD2fHUj1lr5eLhxqow7ZT5ov0VkE4Khoj9212VQEcGi1QPHBL9cMCXSZD+0kjb
	jt8wv/apop1sbWX1qfb7Dtqk/7TJ9rkEo/sgUp/atifUQAL5Kj+jCuHHMIg5Jb0k1lDgXw
	4ptRvz2p5FfTl5AldP6fHNG5b2MnRLM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YKdF9zCA;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5eac6c5f927so153522e0c.0
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792375884; x=1792980684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HFKyVkuGCKpOVLuQsnhKod7q0RL600zFuUYepG6R/FE=;
        b=YKdF9zCAvRufpWUWSIhGvRODdq4Jgxfdy3DSeeZk5bEKXGBtQxrmRz+OubYNzEF105
         49pHIsNAmVjGG0aphLpQGpVPPq5LHWySl+zadkjo5My/vU+VqWK7/OCP6YsUYP2XYhPZ
         +JPvN2YiQht4xcNOl+iA75kD3Vz/ZULln+98/3PcLneosnreJch5zSy3TsczhJwT1ZEh
         6PFbiwEEnz/I7iha6VNWmxJ1TPkWdgEPrzD5xwLkMYqE1sK+oyl/M9K9H/c0o6wy+DGP
         kEforNamDVMKSMovulydRpsQnI/uhN0KnOFZ3PspIgEp/M0SN8ziWA4l8bE1CXphMr1t
         Rlrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792375884; x=1792980684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=HFKyVkuGCKpOVLuQsnhKod7q0RL600zFuUYepG6R/FE=;
        b=mXZbx8kaVszUcNRfUe/aoAYLb5vpofYoRIFEZfReALNEVpz7QqlwLOC8dvwG89V965
         Cao1rVQZUHxVqhnrbEAmVo822FlwhxEiuKsSndI4FpNRxvc61oxrwrb9RAc74bFZboUT
         YZJ0RhzmRUP9psqxzzJOy6ZZqJ5aJ4vLJtbcrISyLliwnwuMtJZR914NI4IIoRXmRP5R
         zcgiaqNCHsB9tESPzKtgKtWq98+0uhacN1wvqf/XD1whN3Jdt+iTUELDTtUaskGiH9Fw
         Ys6fJWb9r+CHnMNV3QMhYyMdipTFzNzJHamzWXytljgvGxP1onfOEhSACL+kRiLKHNDq
         9Bjg==
X-Forwarded-Encrypted: i=1; AKwUvBws56UdMGC4WDmE2rjyZ7Qdg7T134sBOd//RhdLqaFxmwwaXdrlxyKW7QId/8GotSrqUp1clh2oqw==@kvack.org
X-Gm-Message-State: AFq9FYKSkp1wCXXj86ZbEd3uRlzmwS/GsaLxm2uWWI+Wf6SGeZULqH/9
	J/k9AnSI6SnUql/sM0p6Bvtmxej/zpwQlZ2LDiCfPK20qOByyomoK9RbvrH1P5aVeKs=
X-Gm-Gg: AYBFou2rkymP5rPNRJ3WxkIQWm8l3Pk98rPgU8ZsoSrh3+agzwlYmrEDqk2J3Dhs3yp
	xADbt3lG7JCHCPpsxJy027xUqs50YbBqddMM2BhH3fJK4eP8h7pLzqOoxU5Aa1Ep0kRkaXXMv2Q
	Cir37YgcqY2b9I1P8EYr5lCKWXi05QUzpdNCreZWt/qcy6HOn0j09t76iZq6L5KnZvteSAhc7Q5
	s3vAdfZk1WuS0Kut/jK3lLNQ9Zkll0eQut2OfMvDAba2ENLm/1mszpCZsyEP2gDhWUiRAXM7o06
	fOrXMexEuRwBxwwayBuElT8TjaAOZcCiMmNwmXUAdh7gbnlz9jmXe2o0id28iIUGOZcuC0dtwSt
	VZFWC6Ix/7iaEwr+Tk12UHQg/To5YAXKZ3IuwH/4YMV387MnHnG2RWTOIYX0cebONSG+RaP4Vai
	xp6P2YuhJYzEkyCZA/RQh4vasJy++X64XblYvxtW0KjjH3kMKfyXR+zV6rtx8jBPdRHGq7Pny/g
	aM+k2SFIoWKdrjN2DnoGl01yfP/SOMtr+EIQTROTGKd9KEDQ2EGICPI+K3xp1qacro0DDRclCLL
	Buh96QeBoj2uzSBE6ec7xtDLxJm7Bw==
X-Received: by 2002:a05:6122:4b10:b0:5ea:b9b5:8c43 with SMTP id 71dfb90a1353d-5eab9b59387mr1211022e0c.18.1792375883763;
        Sun, 18 Oct 2026 19:11:23 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eabbd9ea2bsm4271383e0c.2.2026.10.18.19.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 19:11:22 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v1 4/8] kho: do not modify incoming serialized blocks
Date: Sun, 18 Oct 2026 22:11:07 -0400
Message-ID: <20261019021111.990394-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019021111.990394-1-pasha.tatashin@soleen.com>
References: <20261019021111.990394-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 89DF4A0002
X-Rspamd-Server: rspam08
X-Stat-Signature: r4icpbc33y41kynpgz6ypksfpmziea9k
X-HE-Tag: 1792375884-115499
X-HE-Meta: U2FsdGVkX19bUKDK9r+tjVc6bkxck8QTIzdG8ZTITsYPEic/UT9NTah6fbIwT/Jwop5sPWU71bRZLKiMVp5CURea6fAR5tr9xc7sPFx/oDB3UDZ2qiKfjSsb8yoPamJ5M6TmsWzIQHCy1LNTyUWGsL930y5W4cY1/Qq6kKRNQbCyjRlp8S7URA7Df0RAB/fogETpEMebulAcbAHmJVFRTCboiSEQr4fOSRWv7L5deOmiQ2AoMaPgNewPLZsRyTcGdBzElPONX1vl/RnCsT6O73V2FZt32nY1BCMnIANyE2NgRmIeA2x4L3pk6Q/IYdGed4G2v9JeEDfPwKlwB6jnGln0fp8/OqaUgRhEeks2ZloUNuXpCJu+Q4kbIge/F+sdDXFa731ytdbh3F3cgQk/ug1sY/eQ7sbrRqKhcOU12XRZUI2h0oIqzWOp4CylKE9y5KGSD7Nk6Q00eXASRAz30x3ttV+7yw/qOZnRxSjzMmItVcCDZ5mBfyw97hXQg1CKdgHo6q33mpWsWPk11JSjeO39XTtQsRh7tv2qO+sVNCoqN/k/J5e9L9NABZ6KzMpfOhHWVhAwRw4OaIjSkn6GFWPzKdUrQraviNWvuV2RGIQJ0+otmilSQav3ZYpeAJrp23dRjZh0JwBwUVzACJUOFK5g1ApEGjEFk0oxnVzFFr8iR0KjWwWVMwMJHpJx0N3PaAxkxsZefb1P29AVJn+rMnXrGvIcjda7qMStiwEDxmPTtu68EvcsE+TRif/y3zfKB7IMrNL6G/NWdSm/yE6Ojo29rFIct6YQjFxLhiX16Z+YYSf931aXAbHkXGjKOkxlQoELX/QydEZku/cx8mG2FZ4TuEVqaRmFeCyJK3Y8QuWMW8wyjXDUIfu2H9Pq4kOKI/iO7c4NLRLT+JfNR6RSR3TSEWTw2TD6YY/ptN4JH7KF25RvuvfLLfTbnvNVosf2R6xclK7qU7UOoBM5UvB
 Fwkio4yT
 ju6NjAUKV9lwjRzsNIk6EdAU6aP4kimZlOiSDpzrA2j4VayWpV+hpW4/+NKqPJM4FEwSt6QfBpyDUZ0ovo77lLFyEh+Ac3TGnQTFRdTi7R1KLWsc4VwxGyFWnO0OKmgppMPzqyWN2aWSkn41iYvsqi/ad4p10fsSMyS7TqLmhyMkLmHqj8mwQ/AErsFOSnzXH2Na484dp9/uyp+NJ3+xI4YIvoBI607rPLlwrrJCwzmp9FM+veB4l5DnfzzbMdsDC/aoMrjjpcGcPiqeZFqH5TxPi9XTKIowkKUIzgXgDxxmJQT0APaGLFrhgTMdoLxy5dlKyeJTkbign+VE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When restoring an incoming block set via kho_block_set_restore(), the
physical chain of blocks is already linked and bs->head_pa is already
set. However, kho_block_add() unconditionally rewrites last->ser->next
and bs->head_pa, and kho_block_set_shrink_one() clears
new_last->ser->next even when operating on an incoming block set.

In the upcoming KHO read-only mode, incoming serialized blocks are
mapped read-only and must not be modified. Guard the ser->next and
bs->head_pa updates in kho_block_add() and kho_block_set_shrink_one()
with !bs->incoming.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kho_block.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
index 0d2a342ef422..a4e945f28fad 100644
--- a/kernel/liveupdate/kho_block.c
+++ b/kernel/liveupdate/kho_block.c
@@ -93,10 +93,12 @@ static int kho_block_add(struct kho_block_set *bs,
 	list_add_tail(&block->list, &bs->blocks);
 	bs->nblocks++;
 
-	if (last)
-		last->ser->next = virt_to_phys(ser);
-	else
-		bs->head_pa = virt_to_phys(ser);
+	if (!bs->incoming) {
+		if (last)
+			last->ser->next = virt_to_phys(ser);
+		else
+			bs->head_pa = virt_to_phys(ser);
+	}
 
 	return 0;
 }
@@ -133,10 +135,10 @@ static void kho_block_set_shrink_one(struct kho_block_set *bs)
 	kfree(last);
 
 	new_last = list_last_entry_or_null(&bs->blocks, struct kho_block, list);
-	if (new_last)
-		new_last->ser->next = 0;
-	else
+	if (!new_last)
 		bs->head_pa = 0;
+	else if (!bs->incoming)
+		new_last->ser->next = 0;
 }
 
 /**
-- 
2.56.0.176.g3575e65682-goog


