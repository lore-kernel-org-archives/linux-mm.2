Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E437606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NgXk7PPo
Received: by kanga.kvack.org (Postfix)
	id 47BFE6B098C; Wed, 28 Oct 2026 00:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E9E6B098D; Wed, 28 Oct 2026 00:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3422B6B098E; Wed, 28 Oct 2026 00:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 058C76B098C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:26:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93AA880BB4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:26:29 +0000 (UTC)
X-FDA: 85370748498.23.ACFC642
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 07236A0006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:26:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NgXk7PPo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793161588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aj6NKlEI/katth2wIESymczEJETsapNVp1gfTJSIOI4=;
	b=fnpo+RokFuk8t5EsFrxNGOCNOsl/tNCO0CmKnY+rgdn+kPt5nFnD2GDBtPmHJcRK51RGp+
	6kXjkRs9rBuCXwscEp/UuLBlJ/eACRwvQ8kSfl3SdOJnjE2K9YJ5/SaIF1ZbhI+sxbsI+Z
	k692C8tydAWSstEx1M+o1bTF/nJsBTE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NgXk7PPo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793161588;
	b=C566BoQa/Tyh12DrozUqioN60k/depouS4OyPFxgHmOpmNJhXo4CcmRpkl5HxMBawSaqyu
	3WmRQYaMKgRMTi1e2Aa4jQZsqlxqDLC4VYP0IJXCg+PaTZucQ/Ku0lVfhHuxRPDsdYRh7x
	+OvCa/NNYnGJEARMp6cxZvH1BSpkBVw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0508D601F6;
	Wed, 28 Oct 2026 04:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABE91F01828;
	Wed, 28 Oct 2026 04:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793161586;
	bh=Aj6NKlEI/katth2wIESymczEJETsapNVp1gfTJSIOI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgXk7PPolNc+ddHxBHO/mgGAh/tBkeEgp7YT5J9iFXmFKrlhUo5ziqe/cumMyS4UU
	 h30NzbZc4IPcrQtD7B8w55ovJ+z3txhs0Jc+JGEakv8zX/UTYUA6/Awk3Bl9n0N1x8
	 0jg00kzDIlKlUlZnIi7uAYmONdjHRoEOwEqYIjA34rMGSTXMXCXBycFAUV7FPhc/9w
	 mLxjE+NIK1JW0iEa6hGEAfBlwVi8VM/TtUm4YYhVcx3z4k6FdVu1tmORu0d6530YUv
	 bulZbgwlSTAsX6ZbY5y54DaaBrejmA7iBOilYF+ujZOQin1o9iK6+6ni5Q0pPSuvbE
	 z8oMaSrSmcHUQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.12.y 1/2] mm/damon/sysfs: put target pids for damon_start() failure
Date: Tue, 27 Oct 2026 21:26:14 -0700
Message-ID: <20261028042617.165657-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028042617.165657-1-sj@kernel.org>
References: <20261028042617.165657-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 07236A0006
X-Stat-Signature: dwznxef7bidqem4wbfyb8yjx8dgu6um8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793161587-81119
X-HE-Meta: U2FsdGVkX18IjPB4MCEbsYpCoWivmiwwMV4qevz2l0gRNHr9FCl584hivbXRpSKI16Kxw96s5vLhPPVeYgTPUhU7GcPBNYoN7YhnzRVMDdL/fUxovhIhzwk5tD8ZsUc6loKmoMrTNMv63bt7SkUNKfpuDtDCsSJd0G488U2uFiLIFZPNmVVOBplfrUQRI0zpQXj2JjKbPcVVDwgcyfPm6aW0kAVJDxXK02JJWe3kZHBzsdNt2y4wyKCgFgGVM/2RJz1trAcaOJicNKMVLu0RNNmvCcRS2XwTRZR/qBTIswUHqUj3CIuO+ZYkOz9jfAzJvvaJmzI3CpPsv8Tz6lstbnwOBEoVn3zu/d9GQF+Tl5ZWF58ebyxhPQrKwOrHLnKX+o/siSA75oMPdwCxbDUbPtvKIj9RhXIE/1JGzcb2fznqv90AuqFoSg6/fFfolpsHKAztTM5NC+K0yti4GtLiPUy9eJqGwWk79CVWv4vIqxrIs/GM7SOIsKSNr6pRKph768aeBJV1qEksIx/1/9N+5os895KIClvhc5plnVyTPLdH4KQUB/9d4BTcLa80D06d28Ocrbbs4EBhmCD8oWgdmkYR9M5ZCdeLK7v/7kgFQt3/KIsMu5V3xtzYB70BLVLj9v6lKW1FfJ47y6oSzZIBH51h5AiLdVsQgY86wOjOaA1AQ72RdzkaJ9EDwNWGBWRSOaT3zCO/rMoxJI/J9vYcpzuXCNJPV0mwzyLz6XXOMBUn8u1lJXXCgqdk3PYU+kqAJQwqjXxkYz4EdmCRa9wO25qWoJobCU6FztdbE8xklRj5qDAjCYgN6//waMNs5HCHJw5Fv+m6wqvWU7EN23uINgexLKMGlZsCklWTHSOsdP51qUq+NSNqw0Q06muIl8ks67TX/Lcd24o1tNj8ymIFjsR0K2dLcJVqiTiR6dRIitrhpa53PKuEtZKjj0wuYYoKETSc5sGZFhKb4EK4jwO
 Jm45bzS2
 HVDFswBweRSWsfojNEgarSVwNCRMgAVPNZE5fwpKUaKYnATHtTlwbAazlwgvWQO0pZACZFLlzKLnqLP0EPEPXrzcaBNGExuRKr+M70RWpHAqpIoIcOdSoKReJYZoPOCGJF8NqQoB6ZTA6kjvoLvL/J2UuIj7qXIjURoBiVMh705i0tbqbVkopuKvXDvEMtnzmge/gKMcU3Sy0LM1VjrywQ2sMK0mzu3ZWhVKrDCfi9cKBmklaE6kMyugBH/05PzI4Gp9p/i28qfcqciy4mpP1M6UuOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_sysfs_turn_damon_on() allocates and sets up damon_ctx to start.
If it is for virtual address space monitoring, the setup increases the
reference counts of the target pids.  After the setup, the function
invokes damon_start().  If damon_start() fails, it deallocates the
damon_ctx object without decreasing the reference counts of target pids.
As a result, pids can be leaked.

Fix the leak by putting pids using damon_sysfs_destroy_targets() before
deallocating the damon_ctx object.

Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 5aa23c6545cb8..107a28557afe2 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1519,6 +1519,7 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 		return PTR_ERR(ctx);
 	err = damon_start(&ctx, 1, false);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return err;
 	}
-- 
2.47.3

