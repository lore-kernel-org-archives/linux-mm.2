Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26DB7C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FC9B6B015B; Tue, 18 Aug 2026 05:05:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4D96B0163; Tue, 18 Aug 2026 05:05:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9D86B0166; Tue, 18 Aug 2026 05:05:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE6466B015B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:05:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A1A0A0AF4
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:05:31 +0000 (UTC)
X-FDA: 85113806862.20.12BF76E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id A534AC0008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:05:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=tF8nDEJA;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787043929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WrGJ0Uzan2ImOgGQ7YbCggxDQmGPpBly/qZdeZQEPEA=;
	b=gEv10YdiZLxW/gots/xKXzEm0I7xq6JPbNOXlh/nSQu5RLE096ednAMK+S3gpuJqJKNiJM
	PhGMELOC4EMpYofXZnj7q3pdJxDYYc1xYGJgqaDNPdYBvKAMHrAFj8KB7rEu2RV8mOJq7q
	98W7HPOQugE0JOqD7kKQLwnpIPwTIlQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=tF8nDEJA;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787043929;
	b=bdpu3OUutjcIBHfg3TRPzXg8Of1gsXmr4Q0YwuRIkOEWZtbobF0obtAxq6XXz7qk3qR5um
	W9dmGgnFKwaexwPFLDb//LjmwlmPqkbeKRnQqWMfnHDNcjAWzkEqfZvbzuB9j/XYUG4//7
	zUMHvbTVgKR4LndGOGWML7pi/Vay6nA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=WrGJ0Uzan2ImOgGQ7YbCggxDQmGPpBly/qZdeZQEPEA=; b=tF8nDEJAH/tN1K5TjYvoLFMr1T
	P2nnwgywH71lmQPJ6nXvavL1Xg87U+19sM8AGEAyVRNlXM/L1Pwv94w2+d9U9wgOOnTElJw+uz8mx
	GQ8SaNKxTW3oo4OF8QaYq82rbl6QTUrpqk9Wxk5JDUxkYkuUTgySdfpHOMer6llD2wnnCbOTUfSqu
	M8o8XIcqb+Y7bG5h4bAObhaKFL0MKG++oF2tds+sS3EQeZxc6kGT0JDrxj0pBuKTEmNXy7RW6pB17
	MHajD6M1+8s8gAYkgySj/1rUTGUBAZ617kqC4KZOCf9yQ7QKmzr+JqXu9y10uuBl1U0oCuHu7B/DH
	OZYNXayg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wwFkh-008tsS-2x;
	Tue, 18 Aug 2026 09:05:00 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 18 Aug 2026 02:03:40 -0700
Subject: [PATCH] mm, swap: ratelimit bad swap entry reports
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-swap_part_one-v1-1-a4fc58119fc0@debian.org>
X-B4-Tracking: v=1; b=H4sIAOwfhGoC/x3MUQqAIBAFwKss7ztBg8K8SkRIrbU/JhoVSHcPm
 gNMReEsXOCoIvMlRY4IR6YhLLuPGytZ4QitbnttjVXl9mlOPp/zEVkZv+rAfWf1wGgIKXOQ5//
 G6X0/C6NS318AAAA=
X-Change-ID: 20260818-swap_part_one-1ad0fe65809e
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 stable@vger.kernel.org, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=1799; i=leitao@debian.org;
 h=from:subject:message-id; bh=ArDP+xPYo7L5LAYvlcf9r4ybgRs7cFmSGQ6qSx53NAc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqhCA3s9yhmIJelTJ+LbL97xgDf/DG4nsncIyY/
 q8Ez43ZtbSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaoQgNwAKCRA1o5Of/Hh3
 bVHkD/wPyu0OuSilyXkZ9gP8CY90hf2yoZqTHyBIbB7U6XHUZVkK7NA6XXsqX78Ut6ANTYReAs4
 fSq3DBrrwBaJ44JxHfcoy2XMZ4bQw5sq8l53DuHuTgT5vMytpX2nbWHBwNqGk8V7w1wmMKyQPUR
 +Rm2XfzESaU2F621Ckqu/GiElwfb0uuDsjAVRwdXHLTyUCWjrQKC5bVgs2nL6MgMBJZIJJJepMV
 GhXbiWOOkDn8wDs1SF4NadPhP5xmkxbCp1rsXso8nMKfbQYMBNJHlMg9VY2hYFnSRcBwGcJRTCj
 LNNBZ2TyhJm6YXidk+UibhjIpw3e+fQWeViL8+Z+bAUMiFzhgNxP6jlEtZzfvpfvyh76uUTniS3
 jshFN3XhO9KN8gcjZd9pGu99u6T29aOdJTdwgMN8zMlGlX/+cmCo4AjGAtADaovGh4inuCf6E6W
 uds+y5D9iy3fftgSZ8TJjCYZC2c9hEfASKNVQzu5hD7sU1qWxbJ0qwPXmE0S51PbnMMj/AsoWiS
 DPWetHpXchHyGGBGLHxlUo7fJJTEzuuK0/dquhAuYB2UFRqJvRsVME14tC1qH8q/EnUCupq0fBa
 lleFSjsddMfJDesAKCwUDzkzO/N9RrD02ldBjLCWxaLHcCsrRF36SlQmkA95s8HfguvRERzeBcB
 6kwyk46pb8bl7Rw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: 6zpxphkk4jrdm9i5cu8o8gs8xbmmx91r
X-Rspamd-Queue-Id: A534AC0008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787043929-738155
X-HE-Meta: U2FsdGVkX1/Wn77ofVdU+rKyFb9wAbeZJIcPOyfDhNnnUCp7dQiyKMiDL4nATwAPdoC6HVUxZuVyDJv33zVnNiQ0stR9ssfxz+8cMy73CiKpYVEmHD+rPT6+Ccq5cSsqhJFUKeI+Mrwtvw6YIpBSYzjuCrm8wvekaYk18xA644A5I5PeG1d5/l7XUJnRlk6pxyu1H8povn2/aYBqYbrxhSKYUQd5NqK7BByTEDlthIAV7x2ujlv+kUBoDIG6A3/X2m9Pr5hHvCGygXDooUcEJcByi9NZYfOruFDbnz8CzIlVmDihTtItMskvOITxPfVHGMRylVJLw/hl34NCo2FZYFNjtqcyXElYVagHpQf9IloeEOawqLgmSFTEtsMIyESz4w84Yb92mh5973coGWGjBumcupvXEraUug3ETGMBZQOte30Chwe8n/aZTf6oqkECmNfJNfBFcZy7Gl9xfeo+CQQnO9ybdtR1FXlhNBYm64Oc09xuj7HG/6WC4QCPIDekzYFhVCOTmtRyTk3ZyiOCL99/44/Jqgo9NbH3oKwWqiTZPs6EkObma6jaxJuZUP4RrPrWM7q200A7eVi7VQ1YP5c74f2HINTrtoZFzSvc/eVcRamZ9eM8DCOx9rqgsAwynmafYMmI4N7P6wJUUcBThjT69L0v7247WVcL3udO7//IEcvnKjzF+5DszP8/t0uWzYtPgr4aTIhTxA8HELk60XXKO/Xl54rOA2ROE0m0oiZPxm5n3obnDny2W9AwQNJlcJPNjALku1pDF9oqWKKhA+WbgetgZRB3ud8HQ7K0rZH734KHGfBoI/DFQ8kFyUY0JFQk4VBMPEALg/3xQH/8tJJBLfXZ5qGTjpbNIPEKUiQwqtQJWpvWSEqoRvENMQmJbujlxVf47rH53y5s/j8dBN/bzoMkUouCg0NQC3ihyJO231GgE71g6rUeZoj34BGDL2flBukJ6VFEKIpVf6H
 fh3EE66d
 CMgHMjSZwLxVlOSxilUPUI4qHiDLUOmJRnNYk6D5rYra8piCoelZPWDAZaor316mBPPABiHuehBjfDoLZNRDMgmtzaO4ICm5qjCOtSGTpvdeUrqUN+NapXdZ8y1ZfkmROkHVBWOMq4EfoLxclYyVUhQNU1ic8U9sVj8snZVPYlvWg/qBh49VXzz278pGqUd/5XEB+i5SruX3W0Vn6pH5nLgq4ESMnjHTMZlixw7z0cTVN9Lub9/SrwLTvtsWDWzPQZDHUgjwYeSnZAADBKgFxvV596JQvK8UIazll91AwRfg07vjV0CnVD242HKnrcxcMzAb93VFpI4/zL9m75rEC6n5GvzZVC3QS2pCTK6NrBAIQISwzHJ6vMQ/LEECsq96z08iB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A corrupt page table hands the same bogus entry to get_swap_device() on
every access to the mapping, and every rejection is logged. One machine
logged 6185620 copies of the same line in a few hours.

swap_dup_entry_direct() prints the same message from the fork path, once
per call: the WARN_ON_ONCE() guarding it warns once, the pr_err() inside
does not.

Rate limit all three prints.

Cc: stable@vger.kernel.org
Fixes: 23b230ba8ac3 ("mm/swap: print bad swap offset entry in get_swap_device")
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/swapfile.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index dacef34a3ed7a..53bf01d5f7f11 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1899,11 +1899,11 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 
 	return si;
 bad_nofile:
-	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
 out:
 	return NULL;
 put_out:
-	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	percpu_ref_put(&si->users);
 	return NULL;
 }
@@ -3883,7 +3883,7 @@ int swap_dup_entry_direct(swp_entry_t entry)
 
 	si = swap_entry_to_info(entry);
 	if (WARN_ON_ONCE(!si)) {
-		pr_err("%s%08lx\n", Bad_file, entry.val);
+		pr_err_ratelimited("%s%08lx\n", Bad_file, entry.val);
 		return -EINVAL;
 	}
 

---
base-commit: e6664f2b33db9b6811eb4cec109f06cb2b4f458d
change-id: 20260818-swap_part_one-1ad0fe65809e

Best regards,
--  
Breno Leitao <leitao@debian.org>


