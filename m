Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37A4D606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CF7B6B05B0; Thu, 26 Nov 2026 04:43:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3803E6B05B1; Thu, 26 Nov 2026 04:43:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295BF6B05B2; Thu, 26 Nov 2026 04:43:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0771D6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:43:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 574BA4021E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:43:27 +0000 (UTC)
X-FDA: 85476782454.10.0805380
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf28.hostedemail.com (Postfix) with ESMTP id 57392C0003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:43:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=pass (policy=none) header.from=ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795686205;
	b=GUlpwzZGY+tcjlUcbcVYm8SWWBRTRexmzhR1cbRqjjMVw4VexY/E+JZSTBmy3GLRWYeFQz
	ShDVhoRpeomQ03AFkGm6eOKUkeMDRSEsb9Tmc0AtWXfywaMet6mTBCrb1mFE/d+HJ7YmRg
	JDc1zc0D3ALNgHllW6BRUMO4eqBSdSU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795686205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=U2RG/43Gt62+a3trqh1OXBqfFh76n70yv7dg/xkqTbQ=;
	b=KEUA7NBIILnR46u4E0KxNgs10erhQZVI2Kb3gpKyppsvGltpdIjld+jC2wEfNFp19SkNhc
	rQRai/wJb4/ljqtivAOAqKzA8ctJRSeq9JNawhVEujeOKU7Mz194pDWNHQ0NVF4VhW5DXA
	vufYYXWewQ3/74zwQxozd425AH8irBg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=pass (policy=none) header.from=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 1B5EF3E815;
	Thu, 26 Nov 2026 09:43:19 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baoquan He <baoquan.he@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Youngjun Park <youngjun.park@lge.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH] mm: free the swap slot of a dirty swapin folio
Date: Thu, 26 Nov 2026 10:42:45 +0100
Message-ID: <20261126094318.244973-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.56.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEdJR/H4Xa4ZKuZ4nTBVEkhQ4eIOXT8KBKdz48DaOc5wbOZ2w+1WPgtVNRgprI4/22vAN1OenUTh9HkBYJ4rslBNvFArNCZXQ28g1/NkIwdm4h1XM9+oBIoN9fzUsCSpmHnfCZksERC5zH7jYF0qCl2FD6Fa8775TNfY95y0FTFrIfI6+213vdjQhq3nY6EH43SiwUTshKCRfEnuJPNOCNGDfHd/ZQa7aM47zEkhJAHXntw1KQCSIeU2xrjpqXzWS6oGdWWFqLBY1BEeZkEWyBT6qXL278TaOR0Qv+mO9gtoNMwrdYw/zT4kcBv5PTthlLQKtd7fCdHYWYj9T55opuvcVhirBRGh89bqo3wTGudx/vk/WQI9z6+eeZLs7jtXlMRrBFuXOwClvIOgiYWuceKyQWb4XC5lqTwVDas/gstcQgP4EEv68P7bS3cwV79NybjR6sUoQyytY3zDlzlR5hlB8Cxrt0y1f5q5Hse5+7ll/9+CLIyfvXr//lXZOyX6Hu/8E53L4693z8FEqIAsgaJlqjf89fYJJglU2aZNhxCiZbkXt/dA4TNqedPE9A3IhRsqgCe0boyvG60aHuesKA/xQSznQmGSK2c3G3SXO2oYOopKgPeL74TrfVfpdNjM2yvy1ovNglzu/1w4ROTeHQe8Q8iIC4jdAxsGlkv3Lm58g
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 57392C0003
X-Stat-Signature: quzkgzwkf3tcehq5zhikt5imphgy3yx9
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795686205-876954
X-HE-Meta: U2FsdGVkX1/auBfFhoxyEGgdawb4SK1pHq8rVTezvwzat5byu72ydjBQenQjlWJfkkycTqJww6w8achlufdfiU3lFkzD+EKIhyravyYjMv2n8evQUV7DJ7iy7GEiatvm42Xy6UfygmhtBQyf1Jp8n2J+z+Q9DPR4mAFcHR2/+pI98Vz1YnZDzGA3X/eRCxWy7bKkMOOEWtuRVTrICKE6dkLaIIs4q7Tqfgrwu3K7fHA0FQRpXj5PC4hPORR+eZTQkChZ1V+IJHHq4bfOYQX4zGj8R+uEFk3nBjGP2q5JrK0JZ/oYN/cFB6/chTKgWiDj/sa5+FBbikUDO34oJdtsimqQ1X1HetbrxyioE/88AJKeet/vbm6Ipv5KTdZD5tjcdUskhN1Zy1j17vxO2xKJjFfQ5JlJoWw9aIZNijLGLx3Np4ns9CfUic8f+RmCX9/6DRsg7BX0bgIzda91qxsX/qKZ3NWOMU7HY+GeUxEhCu8XLGvtGvCRW/NqBGVJw0xPNXr/PmR0MflICA+VK1YrODBdZ4gNmAcpxtF5GWMjyHIYQqEZfNlT/5cRf75o3azHqwY06aZfP3mpMjjve4srwzODmh6rbQ1iVFgKD0ad1vcmR7UGO2v2rk/T7WD0fHSjPFCEERY9bh4getPrdqU3Q2SAnnT+hnU5bGuG6u95wA0G7AhkSrTwGmYvQdd3seuEfhyhmRaFgm4XZCnmXq9y1qO6OH3k57KfBmMU3RsMFUhwe4IJoltWgBUdkrSFdSFy8TYYRcaNkX4bO+0/Yg88PpCb4hDCv+Dn1E8cwyqGZAtZ7mMaIcftJtO4v9vg3crFiYm0NoWpWutX/1MyqqIYGp7t2VTQmdHsO6dwbsa8HK6jVwo3l4nSm21U+W/ebo0VutocWS3qGAwQM6YEPL+Q5g+7wL2zYAgTwk43LWHoqon8pW/DHatvhgyAaO3yA7zVWx3MqSpm6DYE1iwNJaD
 RPnPeLXz
 LH/oIeOlfn3QRxKkXsfXR9a8uzbd98/OS0QyQrtgcF1zic3wu0nDP3i4+XnVP+bSeU4/RaN5eSCam+sFQSuOMmWM2CnL/a2Om1tchTogCm4J6H9cXkJ9xAscYZUGeU5NEp7hV2Ch3BIIGagRuuQJwOpqfArb9WQua+4Y7Na4jq2u6fBL3lIZdF2A1zH+s50Z/pj1awKLYm9Hs6nIBMHUWEieG6GQbBdZXNJjoJKZIdZsrStLdwOc3SbdXvfrbp8au3D1etEI/UQafj0UzMZKt5lymVWsRK39JKV/WuEcqJO2sBoA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_swap_page() frees the swap cache of an exclusive folio on a write
fault only. A folio loaded from zswap is dirty: zswap drops its copy on
load, so the slot no longer holds the data and only reserves swap space
until the folio is reclaimed again or its owner exits.

Such folios add up, and they are expensive to free at exit: on a large
production workload, the exit time doubled when zswap was enabled. A
third of the increase comes from the folios left in the swap cache,
each costing about 3x a resident page to tear down; the rest comes from
freeing the zswap entries.

So free the swap cache of an exclusive dirty folio as well, so that the
slot is released at swapin, as is already done on an exclusive write
fault. The folio is dirty, so it would get written out again anyway:
the only cost is a new slot allocation on its next reclaim, which write
faults already pay.

On the production workload, this patch removed that third: the exit time
decreased by about 15%. On a simple microbenchmark, 4 GiB of anonymous
memory in a memcg pushed to swap, read back, then SIGKILLed in a QEMU
guest (mean +- stddev of 9 runs):

                     base            patched
  exit time    989 +- 24 ms       502 +- 28 ms   (-49%)

The cost is paid by folios that keep cycling between zswap and memory:
each reclaim allocates a new slot and adds the folio to the swap cache
again. On a kernel build in a 600 MiB memcg (-j4, defconfig), this is
not measurable (mean +- stddev of 5 runs on bare metal):

                       base            patched
  time (s)        592.4 +- 1.1      592.4 +- 0.9    (+0.0%)
  sys (s)         256.6 +- 1.5      257.5 +- 1.4    (+0.3%)

In the worst case, random reads over 4 GiB of anonymous memory in a
3 GiB memcg, so that half the reads are zswap read faults and the task
spends all its time in the kernel, throughput drops by 1.1-1.4%
(mean +- stddev of 5 runs on bare metal):

                       base            patched
  reads/s, 1 thread   37310 +- 182     36889 +- 77     (-1.1%)
  reads/s, 8 threads 291937 +- 802    287954 +- 373    (-1.4%)

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---

Notes:
    Previous discussion:
    https://lore.kernel.org/all/CAGsJ_4xBtKGqXFP4zvp+Qn+tb4X7aCvXn+wqDqot_cXR92DjhQ@mail.gmail.com/

 mm/memory.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d477a4f986bc..dac0f0a24bc7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4711,10 +4711,13 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 		return true;
 
 	/*
-	 * Free the swapcache only if we are the exclusive user and
-	 * this is a write fault.
+	 * Free the swapcache only if we are the exclusive user and this is a
+	 * write fault, or the folio is dirty: its copy in the swap slot is
+	 * stale then (zswap loads are exclusive and dirty the folio), so the
+	 * slot only holds swap space.
 	 */
-	return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
+	return exclusive && ((fault_flags & FAULT_FLAG_WRITE) ||
+			     folio_test_dirty(folio));
 }
 
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
-- 
2.53.1-Meta


