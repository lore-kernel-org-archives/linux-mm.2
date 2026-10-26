Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513D2606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B0t5NWQd
Received: by kanga.kvack.org (Postfix)
	id 6EAB66B05B5; Mon, 26 Oct 2026 11:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5416B05B6; Mon, 26 Oct 2026 11:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D9266B05B7; Mon, 26 Oct 2026 11:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3709C6B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:19:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96716160713
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:19:26 +0000 (UTC)
X-FDA: 85365136332.09.523A99C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 66C0220011
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:19:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B0t5NWQd;
	spf=pass (imf03.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793027964;
	b=GG1q6jBwv23L8+vNIU/2AFqFjqZNGwi7bnSu8IlfS9UlxTs4GdT/ILwKv/1tEhP7LKz+up
	5FCxVV7g2xY+5HolqyA0tVO82jlaVQLruEo/pFWBLN/gFaGlhJFQrOVRJPbp1WqDaGMdnN
	v3nPjl3FK7vtSamOKhEevQTel5ZWSI8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B0t5NWQd;
	spf=pass (imf03.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793027964;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oec+Wt3gHa1boqU1HQuJjZMLSuduFm7h1veFSZGd5Z8=;
	b=ousFTxPhbY+p4NSUMpumgFOuQl85+ogBy3zduPiaog81/gf2q11HfJG5N48E+d3HzX3Taj
	mmvKSyBesTYqgjJ/OCTvuZ+i2qKdvZDNzPCYrauhr6F8K4c9JJ1qlWsKfLeZrqgZMzAXIL
	o13mKTq0nRuHlAibAhWYpSxv9gSuHAg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B3ED42DBF;
	Mon, 26 Oct 2026 15:19:23 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793027963;
	b=yZlmAG/6kDJ1pVk1famdY35V8HRCuDqcAYtQNBzITYb4rx8W/s1o7kYsDx2spE93EJmZ
	 cz+Z7akQRVle4EjXOafUdwndYsfaCPM2yCCjE3VItEB2bEiVmukwmZN2NcaV9BwgJjEHb
	 /ElSmt4rr0LE59If3wc/sr4MCfDQR3NTmFaqNJ6PObZC+O9UWksrutrFS01L4PmsbZxc2
	 TAFpuiBh0iKEOLHS2p7iBJ28OSAzieO5lqoADS5zIamVoYqZC1kTEouFAba4blm4OJ80r
	 DqfSkuFSeCKljavk/XggL4ywytHEo47xRTcP8XgTfFMSfqMnDwTtrbvchjYr/YBoSdw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793027963;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=oec+Wt3gHa1boqU1HQuJjZMLSuduFm7h1veFSZGd5Z8=;
	b=TO952MsxUNPxN7ZlFOy4K/t9wqLWIqnplApmrjmXkCRsNKKgpMUTadkG8gpOFTorEI/I
	 +fQM16CRBd8ZTBusOEt1HYW62V/XwK8YWUtSm8b74uC4qUr4GllALfP2EHZBiBIDUm1pX
	 bDCqeVJHM+W+A2d0jaghWPsLAFDXLOxt0GQFkthsVVcZ2j7KnMWMJgKoAXpJ/EVwBntSY
	 CSw5DSstXpxO5vLYeXL/qwnADPlgjaiHy95p4BuT4oZGCfARQYpIOQphUzo1qDQEW1WSO
	 nE/tL4EKx0DRCc1UZ11Bo9NpaEztq+UCkh34PjLzs38L6uPvdNTGdJP8sgwB/miJ88Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E5D5A1F01828;
	Mon, 26 Oct 2026 15:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793027963;
	bh=oec+Wt3gHa1boqU1HQuJjZMLSuduFm7h1veFSZGd5Z8=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=B0t5NWQd1nYWesXGLcbrS5kIqaa+VvY0/tbodjEnwvJ5wo1tIqTUI06PKj6l/bMKT
	 xBd/oyTG7CIhOUfZ0ieIllPHBiBLyaNT47UGekYDpLrda5OoUEpOz/jahJzFjwAjM9
	 idmReAf/WQBEc+OhKhSP34qzldEOlBeFiiRp8Lxfi9TfUuyVLyzAY/BLv8n2Ps+5XL
	 VIu5H7skGiDMOUWglf42kNzmVflS2YiiqWw+UJXAmkxzEQrrICeEhpSpRiXFREUz/3
	 nswRpm4gku5MjlqbJUe0s6QT9ZsnFtaJaY7MJPz411f64fmJlRzAlWYs/W6lZSjDwZ
	 NdqNPFzFfPn4Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4C90044D49;
	Mon, 26 Oct 2026 15:19:22 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Mon, 26 Oct 2026 11:19:22 -0400
Subject: [PATCH] mm, swap: stop cluster list scans once swapoff clears
 SWP_WRITEOK
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261026-swapoff-writeok-v1-1-4f4cd420aa33@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDINYtLk8syE9L0y0vyixJzc/WTbEwSjNKTEk2SjQ1VgLqKihKTcusAJs
 YHQvhF5cmZaUml4CMUaqtBQDWLk8TcwAAAA==
X-Change-ID: 20261026-swapoff-writeok-d82f2adc2a53
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu, 
 stable@vger.kernel.org, Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793027962; l=4058;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=13fz6rqNh91gTcPzM8hXNMOTAxUdtQgWk+c7vws4zJ8=;
 b=vg9IYQzJgsesZ3/7DOx8iiu+UpwzJK/cT7keQ9ZTtaH4xqfxdkhcRRPeZI97Poq9QOz1X1L6b
 rOOceG7nTAZB9hJbL18eVW0RArdVG4aOyGUa783AMsl5Gc87b5so/gq
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n5xbsrqero9y1yns6rkx76cmqrxcacko
X-Spam-Status: No, score=-24.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 66C0220011
X-Rspam-User: 
X-HE-Tag: 1793027964-539109
X-HE-Meta: U2FsdGVkX1+6kh9W8E6yz84bZO8QTPRTc2Fpw0FQDJANdJNqfYigtQLxWj16OHvMA9/mOPUtWj0rBQnEyWyHoRRv/xZXTzJP0DbS1B3JazEol6p2frT8YQ/fBsdvzp8zVkVyIvjkcMlrQqtuXwQSudRMLc6vLgKR0bXRzuJd+m2CFzTcsLb1kh6rK06v5UWZVCHvqLQWftqJpJzAtA6i8SwFf6Ud1VSuJaRbUJnfduuEOcuqFki3GuAhc3Ptqkg+kKoKykNiWa90DzP3aWXKWaTK9se+VyG8qj64bUEdZC/po44yTlR+RvsD0Dnn0CqNzS6ZM7fWYhEr1UmM3WIkXj/A5LQ04f+41K/FOi4jAWePhTigeOcLOUSgsG8nBf+7LDH+f7+zsK2EIZZEsOuFnpEjWwkm8Z7qYsW7grfIIge8YdisY/zD2rzYhVtHosyXwpFCRvdcZ1LWbZHCWK5YjrQfohdZC2FgJ/YNPX2RHzr7265fk9UQct9Qi7Kv0ozIWrmPNhTJy8TZ8ITd6t61C1XuOgz6ztsdnEARxYvinyi+0fyRo3BxuOsVFIO7ICdeHXBLhR8ykj13C1x966lIFNPFvkomjYO2Zsr1Fsl//Voxyp10iuXigzGe+e+/gpgf7wmosj93c8X0EylsVtJ+KLn+H9zETqitXXMUVtR3RoYG6/ZeM67Af4C/zTe9WKLRkBVXzJGPb8ELGHPsuGPASokH34w7dIDn5TbUwOMC++8CcieinHANPBtqURqto1s7n6aY9nyLtjtyhb9JJ6+vCp1sDf8/cUzRXXCa7epcBEwOyZ7Ugz1siphtXLRPoZlmPmOn07UF3bd2LqYChG7JYHt7ZCh/PMkgFV7UQW4Mh/DaRHOCnD0AGgd31nSQMFGHITntldp20fjKtWDfdKjeYjuX+8czPWptM5l4OVWnvpLGHCyufZ2skn4UfsRuQJOCHhfNM26fnHx74ktsARE
 naM88HbI
 WrcQGvHOBvKQ0x8bjdItfK2iqSe/SUKHrSf8UhMp32sGPb5rUT8cGxHmpsWdw/PyG2MvWF1b+5Vx+4qT1Ix8OHENwbTFWbXmfpAApph2ET637jBLNpxp2ZH+CKbj6/KPfTMG0SHK65wmBfwLxRw/szdgAIvS5Il6DVitlCk5d1TEArHPQb9uua7hexadtIOpXP95Fuc7BMpPhPmBckd4vCT2Z48VPKeSLNIUA6dz6HVErIuTenJ5XkHVchs//fsQi7ZjvmaB3Bm7fAhWmZlJdd6Rr46lDfFghAkzbaxBiHEVNdDiok8J+j2UL8pObYWtt3BwuyF2Wrzx6p5ZbsDC33uV/0+dT4rYpqVV/+/c4/pw1rbMzipc+JMJQA9Vq6XcY2Z9Z1eNrcz2DYYdWRIwg+S1mTuwzCJeKneTwDQhAfudVAtcDIE4jd1NbLQTYoTIQ1ZKBO6jquBjHTTyTe/cX3GwNHoEZyeMM+weCXuMGa3xF5epo3vMwtPDN6MdAsmoGHszAgi+wd+E/WsvyN2LILSv+Ru0t+fQPRDxrMvvQ41/aBaVDlhe6VegAnEy852cGZKexhDx+WtP4nTTEdHAtUdG3WGq/DpiDYF39GO96hEMuCLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mani Tofigh <mt4022@columbia.edu>

SWP_WRITEOK is cleared under si->lock when swapoff starts so that no
new swap entries are allocated from the device, and try_to_unuse()
then waits for writeback of the folios that still use the device.

However, an order-0 allocation that chose the device can race with
swapoff clearing the flag and then loop forever.  It takes a cluster
from the fragment cluster list of a higher order with
isolate_lock_cluster(), the allocation from that cluster fails because
SWP_WRITEOK is clear, and relocate_cluster() puts the cluster back on
the same list, so the loop keeps finding clusters on it.

The looping task is in reclaim, and it may have set writeback on a
folio whose write has been queued but not yet submitted.  swapoff then
waits for that folio, while the reclaiming task, stuck in the loop,
never reaches the point where it submits the write:

  CPU0 (reclaim)                          CPU1 (swapoff)
  --------------                          --------------
  shrink_folio_list()
    pageout(F)
      /* F under writeback,
         write not submitted */
    folio_alloc_swap(G)  /* order 0 */
      swap_alloc_slow()
                                          del_from_avail_list(si, true)
                                            si->flags &= ~SWP_WRITEOK
                                          try_to_unuse()
                                            folio_wait_writeback(F)
        cluster_alloc_swap_entry()
          isolate_lock_cluster()
          /* allocation fails:
             !SWP_WRITEOK */
          relocate_cluster()
          /* repeats forever */
    swap_write_submit()
    /* never reached */

This results in a soft lockup on CPU0 and a swapoff that never returns.

isolate_lock_cluster() used to check SWP_WRITEOK under si->lock until
commit 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap
table") removed that check.  Restore the check.  Since swapoff clears
the flag under the same lock, isolate_lock_cluster() then returns NULL,
which ends the scan; the swap slot allocation for G fails, and reclaim
goes on to submit the write of F.

Given that this is a race, its reproducibility is non-deterministic.
We reproduce it by using a non-rotational swap device that is not
synchronous, with 64K mTHP enabled, where one CPU repeatedly pages out
two 64K folios and a 4K page with madvise(MADV_PAGEOUT), while other
CPUs run swapoff and swapon on the same device.  In my tests it
triggers within 20s in each run, and with the fix applied, it runs for
300s without any hang/kernel report.  This bug was found and
reproduced deterministically using a deterministic hypervisor that is
currently under development.

Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap table")
Cc: stable@vger.kernel.org
Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
Before commit dda8fb68b590 ("mm/swap: also use struct swap_iocb for
block I/O"), reclaim submitted the swap write right away, so on 6.18
to 7.2 the loop most likely ends once swapoff frees the slots instead
of hanging.

Reproducer: https://github.com/manitofigh/swapoff-repro/blob/main/swapoff.c
---
 mm/swapfile.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 601979b97f95..2b03d14b5f52 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -627,6 +627,10 @@ static struct swap_cluster_info *isolate_lock_cluster(
 	u8 flags = CLUSTER_FLAG_NONE;
 
 	spin_lock(&si->lock);
+
+	if (unlikely(!(si->flags & SWP_WRITEOK)))
+		goto out;
+
 	list_for_each_entry(ci, list, list) {
 		if (!spin_trylock(&ci->lock))
 			continue;
@@ -642,6 +646,7 @@ static struct swap_cluster_info *isolate_lock_cluster(
 		found = ci;
 		break;
 	}
+out:
 	spin_unlock(&si->lock);
 
 	/* Cluster's table is freed when and only when it's on the free list. */

---
base-commit: e9011a65d78258901ba123c5f522bef26d29902f
change-id: 20261026-swapoff-writeok-d82f2adc2a53

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>



