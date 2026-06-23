Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDAD6CDB479
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 23:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAC1E6B0095; Tue, 23 Jun 2026 19:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84236B0096; Tue, 23 Jun 2026 19:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A72D56B0098; Tue, 23 Jun 2026 19:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD956B0095
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:16:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE8151C0F41
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:16:58 +0000 (UTC)
X-FDA: 84912739716.04.DF7A9B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1E3FC4000D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:16:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zr8q8RnM;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782256617;
	b=GfkalHaVOcp5okjxKnZjhXV5gTy9KuNED09mqWPEnv7shOZ4AFWXMZ+VBEuzXwjk2bsFEA
	5O1T55Ru4bdq747iUo16i//w6HYLw73E3QSqFOb2KTlv/OT4YxWxq67oZzX8G8DTppDgh5
	aRymBLK5tA6y5ozAdYb0Fd1cWlIGby4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782256617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rvSGHbleQmfcFfn333BuNRZGQJ1s21V7jRdnJLJ04iU=;
	b=mdr1NsJjzt1eZ1yDDDmKWsNyBWwRmUbNLVO77GpgMPb916NYBB5pTog8ghXBInpnv6KsQE
	qpVWJRdy8t2O1H+1A3MTIs00FDcgdZuFE0cZOjIO1y/o5OJZtX/b4Gp1JQ+5QO6A8NTBin
	bO7Lu2kuOpxeFPk0HGPZBAVpwr8eIno=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zr8q8RnM;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B3463601D9;
	Tue, 23 Jun 2026 23:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B66F1F00A3A;
	Tue, 23 Jun 2026 23:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782256616;
	bh=rvSGHbleQmfcFfn333BuNRZGQJ1s21V7jRdnJLJ04iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zr8q8RnM+oMy4uBBrgGd/u5sesXzGLQJ2+i+bHAWBQqQL6a8TWRxDBMNRbrrkizVD
	 dfxOnczCXp22UyOcwrV74PvnH9nJJE7yQaf0WjqHu1VMADl2SuLqu0rx1m9AO2RUaJ
	 g3gSrfeYrziHK2A0eZhxBzJRV2mcE4tmldNTZaobKFrUxu7burvVwunQiN4qjBY+Tl
	 5Z1FZH6KS1gb17HR+P/WhDio6ZwOQF54RGym8aidb7cjvXRmjSDC+/HiYIFuhZOPxT
	 uAvO67PULAZih93wLHvTYZeYMz+A6dtxiVHDEmHqIzT69m2BTFpZEnvVZDs1KA1UBu
	 5D5POP/BBi/UA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: baoquan.he@linux.dev,
	chrisl@kernel.org,
	david@kernel.org,
	jp.kobryn@linux.dev,
	kasong@tencent.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	nphamcs@gmail.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	youngjun.park@lge.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v2 3/4] mm: entirely remove lru_add_drain in do_swap_page
Date: Wed, 24 Jun 2026 07:16:34 +0800
Message-Id: <20260623231635.43086-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260623231635.43086-1-baohua@kernel.org>
References: <20260623231635.43086-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y48xmzz7acc5jh56fgk4xnzmf66d7teg
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E3FC4000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1782256616-871029
X-HE-Meta: U2FsdGVkX1/yLujLBkzK7ddFxL/4iIyJRDEJKTkMorZKu84rnqXCuZK0Do6xJ36WjxtRH3677iYgiy1ucHiT90sz+RURGT/K3qQPGvfqPi9TMLlfCzPo1D2B/8bIan1gZ76CKHjm5u/C8clsny8Pq2f7lZYzU5IP+CDs5Pj/T1u5c+TGyzXMYUZFWO759GkDw9GNAxFWVucHezUG3l9Ys5B3PHo1Q1zpynZQMn+aAXZPaYknerriJB0FMTB1XXTHLsaZTVyo1aZ5PLkA0qCur2Zp39A2Kk4XegP5mZUDggGTF6jfrgtAW4hh8kA8TwLIiGfIv2AEdwMO1dNgTf7Q/17NQuQODuFdpDi15K+ExfDeVkinJ+1XGk3k9sbKxUTtTtq5P/PLcd7LZIf7NADAUwyvfYnAnhYwnMs14TalhL2OSGhkyrnOoD9nQ5ZRmQtQN0VbIQIFk4eCJx1L07t73k3YgENIZeMMbk1o2nF+0ZHzzTz98dsOKzINzyQ/6Ltc0kMXp1nm/y2h1BWsdM9TLolIn0iCXoaQh+zF9GGMGSGugZjy/TXm52TeTt1SbsYa/shz9hY3+d2+39McuMX4QlvJgn+/wo+NOM8CqDyvQreDTY4UJTZ83BILmUV2E6/xpOI+z9Zl3umsCoQcsKLLA9BPtFURup/vbhrpti9MVWuEzKF2E0RlcnprEbviR/yDZSWtSbyA/I97758TmCnuXwqwGd1V8Yz+cDtpC8BORDg0uWP3JufqHPiE+w7K5tdc9qy16/Qz6W9hWdsvOhpj+UMmDKPfWPhg11lcr4c66TtrwrC78nR6tp3zUGCZcXhIndkjFXafXFB4wkJDFCKj549AsCCHsYgDjUUt3bAFkJ6+q9Sqd682s+KCIlPAVA1W8icynwF/d2T3I+R2G587tFifNQ9kfmHJe7dH/bh0O5KIt/DAFGu5O11V2eURGN9j3hx/cf+ScmN7JPz6fJQ
 JQL+CbIK
 UKCuwyrhD7Y6+9dm2CJ2iLrJFDYrD53daKn/4Vzfa5mtAQSk6A+zETR+RInszZFG3Ub26qJeTv44RbcS7fya6smwp3cOAC9u0IcDHuS99GCZBaYhTii4owrwRe/MKch5Vk9rfqAsgBaunP7MOTEPUS8D58rGjHl959M1+h/RSr6GgQ4mCqtBOSCkd+a/midbnaLNPXVZO448JOZj6/bFf/AypvDe+UaPxNkZXQWJblQowLlbThG2+nI1FxIUxkjSp+biCPvfs/Q13dithg2735XZt1j0p2RgB8Fwf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are doing a lot of redundant lru_add_drain() calls in
do_swap_page(), especially for synchronous I/O devices. For
example, the test program below currently ends up draining
lru_cache 100% of the time:

int main(int argc, char *argv[])
{
        int i;
 #define SIZE 100*1024*1024
	while(1) {
		volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

		for (int i = 0; i < SIZE/sizeof(int); i++)
			p[i] =  i%64;
		madvise((void *)p, SIZE, MADV_PAGEOUT);
		for (int i = 0; i < SIZE/sizeof(int); i++)
			p[i] =  i%64;
		munmap(p, SIZE);
	}
	return 0;
}

Folio reuse now relies primarily on the exclusive hint, making
lru_cache draining to drop the refcount in lru_cache largely
irrelevant.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/memory.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index abd0adcf65f0..2983a6baf474 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4903,16 +4903,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	} else if (folio != swapcache)
 		page = folio_page(folio, 0);
 
-	/*
-	 * If we want to map a page that's in the swapcache writable, we
-	 * have to detect via the refcount if we're really the exclusive
-	 * owner. Try removing the extra reference from the local LRU
-	 * caches if required.
-	 */
-	if ((vmf->flags & FAULT_FLAG_WRITE) &&
-	    !folio_test_ksm(folio) && !folio_test_lru(folio))
-		lru_add_drain();
-
 	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
-- 
2.39.3 (Apple Git-146)


